#include "mfcc.h"
#include "model.h"
#include <iostream>
#include <cmath>
#include <vector>
#include <string>
#include <iomanip>

using namespace std;

struct Node
{
    int modIdx;
    int stateId;
    Node* pPreNode;
    double avgPb;
    Node(int mid = -1, int sid = -1):modIdx(mid), stateId(sid), pPreNode(NULL), avgPb(LZERO){}
};
extern int seqActStateNum;
extern int vecSize;
extern int mixNum;
static float minLogExp = -log(-LZERO);

float logPdf(float* feature, State* pState, int vecSize, int mixNum);

//计算最大平均概率，并记录路径
float recg(MFCC& mfcc, vector<Model*>& modSeq, float* pScore)
{
	if(mfcc.mfccHeader.nSamples < 2) {
		return 0.0;
	}
	
    int modSize = modSeq.size();
    Node** nodeSeq = new Node*[mfcc.mfccHeader.nSamples - 1];//第n-1帧为终点
    nodeSeq[0] = new Node[seqActStateNum];
    for (int i = 0, inited = 0; i < modSize; i++)
    {
        int numState = modSeq[i]->stateNum;
        for (int j = 2; j < numState; j++)
        {
            nodeSeq[0][inited].modIdx = i;
            nodeSeq[0][inited].stateId = j;
            inited++;
        }
    }
    Node edNode = Node(modSize-1, modSeq[modSize - 1]->stateNum - 1);
    if (mfcc.mfccHeader.sampSize != vecSize * 4)
    {
        cerr<<"The dimension of feature file is "<<mfcc.mfccHeader.sampSize / 4<<" while model is "<<vecSize<<endl;
        exit(1);
    }
    //处理第0帧
    float* feature = mfcc.getFrame(0);
    float pb = logPdf(feature, modSeq[0]->state[0], vecSize, mixNum);
    nodeSeq[0][0].avgPb = pb;
    for (int cur = 1; cur < mfcc.mfccHeader.nSamples - 1; cur++)
    {
        feature = mfcc.getFrame(cur);
        nodeSeq[cur] = new Node[seqActStateNum];
        //初始化此帧对应的状态集
        for (int i = 0, inited = 0; i < modSize; i++)
        {
            int numState = modSeq[i]->stateNum;
            for (int j = 2; j < numState; j++)
            {
                nodeSeq[cur][inited].modIdx = i;
                nodeSeq[cur][inited].stateId = j;
                inited++;
            }
        }
        int pre = cur - 1;
        for (int i = 0; i < seqActStateNum; i++)
        {
            int j = i < 1 ? 0 : i - 1;
            float maxLike = LZERO, pb;
            Model* pModel;
            int preStateNo;
            for (; j <= i; j++)
            {
                if (nodeSeq[pre][j].avgPb < LSMALL)
                    continue;
                preStateNo = nodeSeq[pre][j].stateId;
                pModel = modSeq[nodeSeq[pre][j].modIdx];
                if (j == i - 1)
                {
                    //从同模型的前一状态跳转到下一状态 preStateNo = curStateNo - 1;
                    pb = pModel->transp->logTransp[(preStateNo - 1) * pModel->stateNum + preStateNo];
                    pModel = modSeq[nodeSeq[cur][i].modIdx];
                }
                else if (j == i)
                {
                    //同模型同一状态的自转 preStateNo = curStateNo;
                    pb = pModel->transp->logTransp[(preStateNo - 1) * pModel->stateNum + preStateNo - 1];
                }
                else
                {
                    cerr<<"No support for skip more than 1 step \n";
                    exit(1);
                }
                pb += logPdf(feature, pModel->state[nodeSeq[cur][i].stateId - 2],vecSize,mixNum);
                pb = nodeSeq[pre][j].avgPb * cur / (cur + 1) + pb / (cur + 1);
                if (pb > maxLike)
                {
                    maxLike = pb;
                    nodeSeq[cur][i].avgPb = pb;
                    nodeSeq[cur][i].pPreNode = &nodeSeq[pre][j];
                }
            }
        }
    }
    //////////////////////////////////////////////////////////////////////////
    //free Node buffer
#ifdef _MYDEBUGDTL
    vector<string> modNameVt;
    vector<float> pbVt;
    Node* pCurNode = &nodeSeq[mfcc.mfccHeader.nSamples - 2][seqActStateNum - 1];
    int frameId = mfcc.mfccHeader.nSamples - 2;
    while (pCurNode->modIdx == modSize - 1)
    {
        pCurNode = pCurNode->pPreNode;
        frameId--;
    }
    for (int offset = modSize / 3; offset > 0; offset--)
    {
        float sumPb = pCurNode->avgPb * (frameId + 1);
        int curModIdx = pCurNode->modIdx;
        int detSeq = 0;
        while (pCurNode->modIdx != curModIdx - 2)
        {
            pCurNode = pCurNode->pPreNode;
            frameId--;
            detSeq++;
        }
        float curPb =( sumPb - pCurNode->avgPb * (frameId + 1))/detSeq;
        while (curModIdx >= 3 && pCurNode->modIdx != curModIdx - 3)
        {
            pCurNode = pCurNode->pPreNode;
            frameId--;
        }
        pScore[offset - 1] = curPb;
    }
#endif
    float returPb = nodeSeq[mfcc.mfccHeader.nSamples - 2][seqActStateNum - 1].avgPb;
    for (int i = mfcc.mfccHeader.nSamples - 2; i >= 0 ; i--)
    {
        delete[] nodeSeq[i];
    }
    delete nodeSeq;
    return returPb;
}

float LAdd(float x, float y)
{
    float temp,diff,z;

    if (x<y) {
        temp = x; x = y; y = temp;
    }
    diff = y-x;
    if (diff<minLogExp) 
        return  (x<LSMALL)?LZERO:x;
    else {
        z = exp(diff);
        return x+log(1.0+z);
    }
}

float logPdf(float* feature, State* pState, int vecSize, int mixNum)
{
    float bx = LZERO, wt, sum, xmm;
    for (int i = 0; i < mixNum; i++)
    {
        wt = pState->weight[i] < MINMIX ? LZERO : log(pState->weight[i]);
        if (wt > LMINMIX)
        {
            sum = pState->gconst[i];
            for (int j = 0; j < vecSize; j++)
            {
                xmm = feature[j] - pState->mean[i * vecSize + j];
                sum += xmm * xmm * pState->variance[i * vecSize + j];
            }
            sum *= (-0.5);
            bx=LAdd(bx,wt+sum);
        }
    }
    return bx;
}