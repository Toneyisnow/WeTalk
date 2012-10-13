#pragma once
//#include <vector>
#import <string.h>

//using namespace std;

#define PI   3.14159265358979
#define TPI  6.28318530717959     /* PI*2 */


bool hcopy2(const char* sFileName, const char* dFileName);

//__declspec(dllexport) void InitFBank(int frameSize, int sampleP, int numChans);
void InitFBank(int frameSize, int sampleP, int numChans);

/************************************************************************/
/*GetParFromHeader�����ݶ�ȡ���ļ�ͷ���ò����ʺͲ�������                */
/************************************************************************/
//waveΪԭʼ��Ƶ�ļ������ݲ��֡�
//nSamples:wav�ļ��еĲ�������,��short�����ʵ�ʳ��ȡ�
//����ֵfalse: waveΪ�ջ�nSamples������sampleRate���Ϸ���true----��������
//¼��ʱ�뽫sampleRate����Ϊ����ֵ:6000,8000,16000,32000,44100,��λΪhz
// 
// __declspec(dllexport) bool SetDataFlow (const short* wave,int nSamples,int sampleRate);
// __declspec(dllexport) bool SetDataFlow (const vector<short>& wave,int sampleRate);

/************************************************************************/
/*CalFrameNum���������õķ�֡���Լ��������֡��                         */
/************************************************************************/
//winSize��֡ʱ���õĴ�����λΪ����(һ����Ϊ20-30����)
//targetRate��֡���֡�ƣ���λΪ���루һ����Ϊ�����һ�����ң�
/*__declspec(dllexport) int CalFrameNum (int winSize, int targetRate);*/

/************************************************************************/
/*GenOneFrameFromData���������ý��з�֡,ÿ����һ�θ���wave��������һ֡  */

//wave:|------------------------------|
//��֡ | ��һ֡ |
//          | �ڶ�֡ |
//               | ����֡ |
//                    ....
//                                |--����~~~|

//ע�����һ֡���ݲ���ʱ�������Ὣ��ֵ���롣
/************************************************************************/
//ft:��֮֡���һ֡���ݣ�����Ԫ�ص�����Ϊfloat.
//       �����в���Դ���������µĴ洢�ռ䣬���ڵ���ǰ�����
//frameSize:һ֡�ڵĲ�����������float����ĳ���
//       ��С���ڷ�֡�����õĴ���(windowSizeһ��Ϊ20-30����)*������(sampleRate)
//                ���磺����25ms,������Ϊ16000hz����frameSize=25*10^(-3) * 16000=400
//targetFrameRate:֡�ƵĲ�������
//       ��С����֡��targetRate(һ��ΪwindowSize��һ������)*������(sampleRate)
//                ���磺targetRateΪ10ms,������Ϊ16000hz,��targetFrameRate=160
//����ֵ��
//       ֡��Խ�緵��false
//       ���𷵻�Ϊtrue
/*
__declspec(dllexport) bool GenOneFrameFromData (vector<float>& ft,int frameSize,
											   int targetSampleRate);
__declspec(dllexport) bool GenOneFrameFromData (float* ft,int frameSize,
											   int targetFrameRate);*/

/************************************************************************/
/*PreEmphasise����������֡�еĵ�Ƶ����                                  */
/************************************************************************/
//����Ϊ����֡s(��Ϊ��������Ҫ�������鳤��)��Ԥ����ϵ��k
//�����л�����ݽ����޸�
//__declspec(dllexport) void PreEmphasise (vector<float>& s, float k);
//__declspec(dllexport) void PreEmphasise (float* s,int size, float k);

//void PreEmphasise (vector<float>& s, float k);
void PreEmphasise (float* s,int size, float k);

/************************************************************************/
/*Ham���Դ�֡���ݼӺ�����                                               */
/************************************************************************/
//����Ϊ����֡s(��Ϊ��������Ҫ�������鳤��)
//ע���˺����л�����ڴ�
//void Ham (vector<float>& s);
void Ham (float* s, int size);

/************************************************************************/
/*Realft����float����Ӧ��fft�任                                        */
/************************************************************************/
//ע���float�������ڼӴ���ɺ���в���ֵ�����ɵ�������
//void Realft (vector<float>& s);
void Realft (float* s, int size);

/************************************************************************/
/*ReleaseMem��main��������ǰ����ô˺����ͷ�dll�з������Դ             */
/************************************************************************/
void ReleaseMem ();
//�ͷ�dll�з������Դ

#define MINLARG 2.45E-308  /* lowest log() arg  = exp(MINEARG) */
#define LZERO  (-1.0E10)   /* ~log(0) */

typedef short ParmKind;          /* BaseParmKind + Qualifiers */

#define HASENERGY  0100       /* _E log energy included */
#define HASNULLE   0200       /* _N absolute energy suppressed */
#define HASDELTA   0400       /* _D delta coef appended */
#define HASACCS   01000       /* _A acceleration coefs appended */
#define HASCOMPX  02000       /* _C is compressed */
#define HASZEROM  04000       /* _Z zero meaned */
#define HASCRCC  010000       /* _K has CRC check */
#define HASZEROC 020000       /* _0 0'th Cepstra included */
#define HASVQ    040000       /* _V has VQ index attached */
#define HASTHIRD 0100000       /* _T has Delta-Delta-Delta index attached */

#define BASEMASK  077         /* Mask to remove qualifiers */

typedef double HTime;      /* time in 100ns units */
typedef struct {
	/* ------- Overrideable parameters ------- */
	ParmKind tgtPK;            /* Target ParmKind */ 
	HTime tgtSampRate;         /* Target Sample Rate */ 
	HTime srcSampRate;         /* Source Sample Rate */ 
	HTime winDur;              /* Source window duration */
	float preEmph;             /* PreEmphasis Coef */
	int numChans;              /* Number of filter bank channels */
	int cepLifter;             /* Cepstral liftering coef */
	int numCepCoef;            /* Number of cepstral coef */
	float loFBankFreq;         /* Fbank lo frequency cut-off */
	float hiFBankFreq;         /* Fbank hi frequency cut-off */
	float eScale;              /* Energy scale factor */
	float silFloor;            /* Silence floor in dBs */
	int numOrgCoef;			   //ÿ֡ԭʼ������Ŀ(����D,A,T)
	int numColumn;             //ÿ֡������Ŀ
	bool simpleDiffs;       /* Use simple differences for delta calcs */
	bool zMeanSrc;          /* Zero Mean the Source */
	bool eNormalise;        /* Normalise log energy */
}IOConfigRec;