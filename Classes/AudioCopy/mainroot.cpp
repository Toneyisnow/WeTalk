#include "model.h"
#include "mfcc.h"
#include "mainroot.h"
#include <iostream>
#include <string>
#include <fstream>
#include <cstring>
#include <map>
#include <vector>
using namespace std;
extern int vecSize;
extern int mixNum;

void readKeyword(map<string, vector<string> >& keywordMap, const char* keywordFIleName);
void readDict(map<string, vector<string> >& dict,const char* dictName);
void readTiedlist(map<string, string>& tiedList,const char* listName);
void readModel(map<string, Model*>& modelMap, map<string, State*>& stateMap, map<string, Transp*>& transpMap,const char* fileName);
void genTriVt(const vector<string>& py, map<string, vector<string> >& dict, map<string, string>& tiedList, vector<string>& triVt);
void selectMod(vector<string>& triVt, map<string, Model*>& modelMap, vector<Model*>& modSeq);
float recg(MFCC& mfcc, vector<Model*>& modSeq, float* pScore);
void releaseMap(map<string, State*>& stateMap, map<string, Transp*>& transpMap);


map<string, vector<string> > dict;
map<string, string> tiedList;
map<string, Model*> modelMap;
map<string, State*> stateMap;
map<string, Transp*> transpMap;

void Initiate(const char* dictstr, const char* tiedListstr, const char* hmmdefsstr)
{
    readDict(dict, dictstr);
    readTiedlist(tiedList, tiedListstr);
    readModel(modelMap,stateMap,transpMap,hmmdefsstr);
}

float Viterbi(char* mfccFileName, vector<string>& answerPY)
{
    if(answerPY.size() <= 0)
	{
		return 0.0;
	}
	
	MFCC curMfcc = MFCC(mfccFileName, true);
    vector<string> triVt;
    vector<Model*> modSeq;
    //生成关键词对应的triphone序列
    genTriVt(answerPY,dict,tiedList,triVt);
    selectMod(triVt, modelMap, modSeq);
    float* pScore = new float[answerPY.size()];
    recg(curMfcc, modSeq, pScore);
	
	
	float sum = 0;
    for (int i = 0; i < answerPY.size(); i++)
    {
        cout<<pScore[i]<<endl;
		sum += pScore[i];
    }
    delete[] pScore;
	
    return - sum / answerPY.size();
}

void PostViterbi()
{
    releaseMap(stateMap, transpMap);
}

int mainroot()
{
    // Initiate();
    vector<string> answerPY;
    answerPY.push_back("er");
    answerPY.push_back("pao");
    answerPY.push_back("she");
    answerPY.push_back("qu");
    // Viterbi("a.mfc", answerPY);
    PostViterbi();
    return 0;
}