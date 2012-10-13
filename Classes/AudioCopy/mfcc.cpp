#include "mfcc.h"
#include <fstream>
#include <iostream>
#include <cstring>
using namespace std;

MFCCHeader::MFCCHeader(char* mfccFileName, bool order)
{
    ifstream fin(mfccFileName, ios_base::in | ios_base::binary);
    if (!fin.is_open())
    {
        cerr<<mfccFileName<<" doesn't exist"<<endl;
        exit(1);
    }
    int l = strlen(mfccFileName);
    readOrder = order;
    if (readOrder)
    {
        fin.read((char*)&nSamples, sizeof(int));
        fin.read((char*)&sampPeriod, sizeof(int));
        fin.read((char*)&sampSize, sizeof(short));
        fin.read((char*)&parmKind, sizeof(short));
    } 
    else
    {
        fin.read((char*)(&nSamples)+3,1);
        fin.read((char*)(&nSamples)+2,1);
        fin.read((char*)(&nSamples)+1,1);
        fin.read((char*)(&nSamples),1);
        fin.read((char*)(&sampPeriod)+3,1);
        fin.read((char*)(&sampPeriod)+2,1);
        fin.read((char*)(&sampPeriod)+1,1);
        fin.read((char*)(&sampPeriod),1);
        fin.read((char*)(&sampSize)+1,1);
        fin.read((char*)(&sampSize),1);
        fin.read((char*)(&parmKind)+1,1);
        fin.read((char*)(&parmKind),1);
    }
    fin.close();
}

MFCC::MFCC(char* mfccFileName, bool order /* = true */):mfccHeader(mfccFileName, order)
{
    int numSz= mfccHeader.nSamples * mfccHeader.sampSize / 4;
    dataBuf = new float[numSz];
    ifstream fin(mfccFileName, ios_base::in | ios_base::binary);
    fin.seekg(12);
    for (int i = 0; i < numSz; i++)
    {
        if (mfccHeader.readOrder)
        {
            fin.read((char*)&dataBuf[i], sizeof(float));
        } 
        else
        {
            fin.read((char*)(&dataBuf[i])+3,1);
            fin.read((char*)(&dataBuf[i])+2,1);
            fin.read((char*)(&dataBuf[i])+1,1);
            fin.read((char*)(&dataBuf[i]),1);
        }
    }
    fin.close();
}

MFCC::~MFCC()
{
    delete[] dataBuf;
}

float* MFCC::getFrame(int frameNo)
{
    return dataBuf+frameNo*mfccHeader.sampSize/4;
}