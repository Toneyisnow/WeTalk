#ifndef GENWDNET2 
#define GENWDNET2

//#include <string>
#include "genWdnet.h"
#include <fstream>
#include <vector>
using namespace std;
//bool genWdnet2(string pyFileName, string wdnetFileName);

bool genWdnet2(string pyFileName, string wdnetFileName)
{
    ifstream pyStream;
    pyStream.open(pyFileName.c_str());
    if (!pyStream.is_open())
        return false;
    vector<string> pinyinVt;
    string pinyin;
    while (pyStream>>pinyin)
    {
        pinyinVt.push_back(pinyin);
    }
    pyStream.close();
    ofstream wdnetStream(wdnetFileName.c_str(), ios_base::trunc | ios_base::binary);
    //////////////////////////////////////////////////////////////////////////
    wdnetStream<<"VERSION=1.0"<<endl;
    wdnetStream<<"N="<<4+pinyinVt.size()<<"     L="<<pinyinVt.size()+3<<endl;
    wdnetStream<<"I=0    W=!NULL"<<endl;
    wdnetStream<<"I=1    W=!NULL"<<endl;
    wdnetStream<<"I=2    W=SENT-START"<<endl;
    vector<string>::iterator itStr;
    int i = 3;
    for (itStr = pinyinVt.begin(); itStr != pinyinVt.end(); i++,itStr++)
        wdnetStream<<"I="<<i<<"    W="<<*itStr<<endl;
    wdnetStream<<"I="<<i<<"    W=SENT-END"<<endl;
    wdnetStream<<"J=0     S="<<i<<"    E=1"<<endl;
    wdnetStream<<"J=1     S=0    E=2"<<endl;
    for (i = 2; i < pinyinVt.size()+3; i++)
        wdnetStream<<"J="<<i<<"     S="<<i<<"    E="<<i+1<<endl;
    //////////////////////////////////////////////////////////////////////////
    wdnetStream.flush();
    wdnetStream.close();
	
	return true;
}

#endif