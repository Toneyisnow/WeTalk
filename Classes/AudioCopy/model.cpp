#include "model.h"
#include <iostream>
#include <string>
using namespace std;

State::State(int mixNumber, int vecSize)
{
    weight = new float[mixNumber];
    mean = new float[vecSize * mixNumber];
    variance = new float[vecSize * mixNumber];
    gconst = new float[mixNumber];
}

State::~State()
{
    delete[] weight;
    delete[] mean;
    delete[] variance;
    delete[] gconst;
}

Transp::Transp(int stateNum)
{
    logTransp = new float[stateNum * stateNum];
}

Transp::~Transp()
{
    delete[] logTransp;
}

Model::Model(const char* modelName, int num)
{
    if (strlen(modelName) >= MAXNAMELEN)
    {
        cerr<<"Model name '"<<modelName<<"' too long\n";
        exit(1);
    }
    strcpy(name, modelName);
    stateNum = num;
    state = new State*[num - 2];
}

Model::~Model()
{
    delete[] state;
    //��ͬ��ģ�ͼ���ܹ���ͬһ��״̬��ת�ƾ�����˲����ڴ˴�����
}