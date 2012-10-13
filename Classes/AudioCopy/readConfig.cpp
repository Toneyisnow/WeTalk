#include <iostream>
#include <string>
#include <fstream>
#include <cstring>
#include <map>
#include <vector>
using namespace std;

typedef pair<string, vector<string> > Dict_Pair;

void readKeyword(map<string, vector<string> >& keywordMap, const char* keywordFIleName)
{
    string hz;
    string py;
    keywordMap.clear();
    ifstream fin(keywordFIleName);
    if (!fin.is_open())
    {
        cerr<<"File "<<keywordFIleName<<" doesn't exist\n";
        exit(1);
    }
    char ch = '\0';
    while(!fin.eof())
    {
        if(!(fin>>hz))
            break;
        vector<string> pinyinVt;
        fin.get(ch);
        while(1)
        {
            while ((ch < 'a' || ch > 'z') && ch != '\n')
            {
                fin.get(ch);
            }
            if (ch == '\n')
                break;
            else
            {
                fin.putback(ch);
                fin>>py;
                pinyinVt.push_back(py);
                fin.get(ch);
            }
        }
        keywordMap[hz] = pinyinVt;
    }
}

void readDict(map<string, vector<string> >& dict,const char* dictName)
{
    ifstream fin(dictName);
    if (!fin.is_open())
    {
        cerr<<"File "<<dictName<<" doesn't exist\n";
        exit(1);
    }
    string py, phone;
    while(!fin.eof())
    {
        fin>>py;
        if (0 == py.length())
            break;
        fin>>phone;
        vector<string> phoneVt;
        if (0 != phone.compare("[]"))
        {
            phoneVt.push_back(phone);
            char ch;
            while(1)
            {
                fin.get(ch);
                while (ch == '\t' || ch == ' ')
                    fin.get(ch);
                fin.putback(ch);
                if (ch == '\r' || ch == '\n')
                    break;
                else
                {
                    fin>>phone;
                    phoneVt.push_back(phone);
                }
            }
        }
        else
        {
            getline(fin,phone);
            phoneVt.push_back("sil");
        }
        dict.insert(Dict_Pair(py, phoneVt));
    }
}

void readTiedlist(map<string, string>& tiedList,const char* listName)
{
    ifstream fin(listName);
    if (!fin.is_open())
    {
        cerr<<"File "<<listName<<" doesn't exist\n";
        exit(1);
    }
    string modName, physicalName;
    while(!fin.eof())
    {
        fin>>modName;
        if (0 == modName.length())
            break;
        char ch;
        physicalName = modName;
        fin.get(ch);
        while (ch == '\t' || ch == ' ')
            fin.get(ch);
        fin.putback(ch);
        if ('\r' != ch && '\n' != ch)
        {
            fin>>physicalName;
        }
        tiedList[modName] = physicalName;
    }
}

void genTriVt(const vector<string>& py, map<string, vector<string> >& dict, map<string, string>& tiedList, vector<string>& triVt)
/************************************************************************/
/* py 待识别拼音串  dict triphone的字典   tiedlist 映射  triVt 最终拼音串对应的物理模型*/
/************************************************************************/
{
    triVt.clear();
    vector<string> tmpVt;
    map<string, vector<string> >::const_iterator dict_Iter;
    tmpVt.push_back("sil");
    for (int i = 0; i < py.size(); i++)
    {
        dict_Iter = dict.find(py[i]);
        if ( dict_Iter == dict.end( ) )
        {
            cout << "The map m1 doesn't have an element "<< "with a key of "<< py[i]<< endl;
            exit(1);
        }
        const vector<string>& triphones = dict_Iter->second;
        for (vector<string>::const_iterator it = triphones.begin(); it != triphones.end(); it++)
        {
            tmpVt.push_back(*it);
        }
    }
    if (tmpVt[tmpVt.size()-1] == "sp")
    {
        tmpVt[tmpVt.size()-1] = "sil";
    }
    else
        tmpVt.push_back("sil");
    triVt.push_back("sil");
    map <string, string> :: const_iterator list_Iter;
    vector<string>::const_iterator it = tmpVt.begin()+1, itPre, itNext;
    for (; it != tmpVt.end()-1; it++)
    //tmpVt的开头和结尾都有sil
    {
        itPre = it - 1;
        itNext = it + 1;
        string curTri, physicalTri;
        if (*it == "sp")
        {
            triVt.push_back("sp");
            continue;
        }
        if (*itNext == "sp")
            itNext++;
        if (*itPre == "sp")
            itPre--;
        curTri = *itPre+"-"+*it+"+"+*itNext;
        list_Iter = tiedList.find(curTri);
        if ( list_Iter == tiedList.end( ) )
        {
            cout << "The map m1 doesn't have an element with a key of " << curTri << endl;
            exit(1);
        }
        triVt.push_back(list_Iter->second);
    }
    triVt.push_back("sil");
}