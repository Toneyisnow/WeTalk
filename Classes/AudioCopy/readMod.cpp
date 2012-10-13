#include "model.h"
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <map>
#include <cmath>
using namespace std;

int vecSize;
int mixNum;
int seqActStateNum = 0;

void readModel(map<string, Model*>& modelMap, map<string, State*>& stateMap, map<string, Transp*>& transpMap,const char* fileName)
{
    //map<string, State*> stateMap 关联状态与状态名
    //map<string, Transp*> transpMap 关联转移矩阵与矩阵名
    string ignore, str;
    int stateNum;
    ifstream fin(fileName, ios_base::in | ios_base::binary);
    if (!fin.is_open())
    {
        cerr<<"File "<<fileName<<" doesn't exist"<<endl;
        exit(1);
    }
    //////////////////////////////////////////////////////////////////////////
    //read file
    for (int i = 0; i < 2; i++)
        getline(fin, ignore);
    fin>>ignore;
    fin>>vecSize;
    getline(fin, ignore);
    fin>>str;
    float logP;
    while ("~t" == str)
    {
        fin>>str;
        fin>>ignore;
        fin>>stateNum;
        Transp* pTransp = new Transp(stateNum);
        for (int i = 0; i < stateNum*stateNum; i++)
        {
            fin >> logP; 
            if (logP < MINLARG)
                pTransp->logTransp[i] = LZERO;
            else
                pTransp->logTransp[i] = log(logP);
        }
        transpMap[str] = pTransp;//在Map中记录新增的转移矩阵
        fin>>str;
    }
    if ("~s" == str)
    {
        int pos = fin.tellg();
        fin>>ignore>>ignore;
        fin>>mixNum;
        fin.seekg(pos);
    }
    while("~s" == str)
    {
        fin>>str;
        fin>>ignore>>ignore;
        State* state = new State(mixNum, vecSize);
        for (int i = 0; i < mixNum; i++)
        {
            fin>>ignore>>ignore>>state->weight[i]>>ignore>>ignore;
            //有mixNum * vecSize 维均值和方差
            for (int j = 0; j < vecSize; j++)
                fin>>state->mean[i * vecSize + j];
            fin>>ignore>>ignore;
            for (int j = 0; j < vecSize; j++)
            {
                fin>>state->variance[i * vecSize + j];
                state->variance[i * vecSize + j] = 1.0 / state->variance[i * vecSize + j];
            }
            fin>>ignore>>state->gconst[i];
        }
        stateMap[str] = state;
        fin>>str;
    }
    //以下两个iterator 用于关联状态分布函数和转移矩阵
    map<string, State*>::const_iterator stateIt;
    map<string, Transp*>::const_iterator transpIt;
    string modName;
    while ("~h" == str)
    {
        fin>>modName;
        if (string::npos != modName.find("-sil+"))
        {
            fin>>ignore>>ignore>>stateNum;
            int skipLine = 1 + 2 * (stateNum - 2);
            for (int i = 0; i < skipLine; i++)
                getline(fin, ignore);
            fin>>ignore;
            if ("~t" == ignore)
                skipLine = 2;
            else
                skipLine = 2 + stateNum;
            for (int i = 0; i < skipLine; i++)
                getline(fin, ignore);
        }
        else
        {
            modName = modName.substr(1,modName.length()-2);
            fin>>ignore>>ignore>>stateNum;
            Model* pModel = new Model(modName.c_str(), stateNum);
            getline(fin, ignore);
            for (int i = 0; i < stateNum - 2; i++)
            {
                getline(fin, ignore);
                fin>>ignore>>str;
                getline(fin, ignore);//读入回车
                stateIt = stateMap.find(str);
                if (stateIt == stateMap.end())
                {
                    cerr << "The map State doesn't have an element with a key of " << str << endl;
                    exit(1);
                }
                pModel->state[i] = stateIt->second;
            }
            fin>>str;
            if ("~t" == str)
            {
                fin >> str;
                transpIt = transpMap.find(str);
                if (transpIt == transpMap.end())
                {
                    cerr << "The map Transp doesn't have an element with a key of " << str << endl;
                    exit(1);
                }
                pModel->transp = transpIt->second;
                fin >> ignore;
            }
            else if("<TRANSP>" == str)
            {
                getline(fin, ignore);
                Transp* pTransp = new Transp(stateNum);
                float logP;
                for (int i = 0; i < stateNum*stateNum; i++)
                {
                    fin >> logP; 
                    if (logP < MINLARG)
                        pTransp->logTransp[i] = LZERO;
                    else
                        pTransp->logTransp[i] = log(logP);
                }
                transpMap[pModel->name] = pTransp;//在Map中记录新增的转移矩阵
                pModel->transp = pTransp;
                fin>>ignore;
            }
            else
            {
                cerr<<"Invalid keywords "<<str<<endl;
            }
            modelMap[modName] = pModel;
        }
        if(! (fin >> str))
            break;
    }
}

void selectMod(vector<string>& triVt, map<string, Model*>& modelMap, vector<Model*>& modSeq)
{
    modSeq.clear();
    seqActStateNum = 0;
    map<string, Model*>::const_iterator modIt;
    for (vector<string>::const_iterator triIt = triVt.begin(); triIt != triVt.end(); triIt++)
    {
        modIt = modelMap.find(*triIt);
        if (modIt == modelMap.end())
        {
            cerr << "The map State doesn't have an element with a key of " << *triIt << endl;
            exit(1);
        }
        modSeq.push_back(modIt->second);
        seqActStateNum += (modIt->second->stateNum - 2);
    }
}

void releaseMap(map<string, State*>& stateMap, map<string, Transp*>& transpMap)
{
    map<string, State*>::const_iterator stateIt;
    map<string, Transp*>::const_iterator transpIt;
    for (stateIt = stateMap.begin(); stateIt != stateMap.end(); stateIt++)
    {
        delete stateIt->second;
    }
    for (transpIt = transpMap.begin(); transpIt != transpMap.end(); transpIt++)
    {
        delete transpIt->second;
    }
}