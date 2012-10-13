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
/*GetParFromHeader：根据读取的文件头设置采样率和采样点数                */
/************************************************************************/
//wave为原始音频文件的数据部分。
//nSamples:wav文件中的采样点数,即short数组的实际长度。
//返回值false: wave为空或nSamples非正或sampleRate不合法。true----正常返回
//录音时请将sampleRate设置为如下值:6000,8000,16000,32000,44100,单位为hz
// 
// __declspec(dllexport) bool SetDataFlow (const short* wave,int nSamples,int sampleRate);
// __declspec(dllexport) bool SetDataFlow (const vector<short>& wave,int sampleRate);

/************************************************************************/
/*CalFrameNum：根据配置的分帧策略计算产生的帧数                         */
/************************************************************************/
//winSize分帧时采用的窗宽，单位为毫秒(一般设为20-30毫秒)
//targetRate分帧后的帧移，单位为毫秒（一般设为窗宽的一半左右）
/*__declspec(dllexport) int CalFrameNum (int winSize, int targetRate);*/

/************************************************************************/
/*GenOneFrameFromData：根据配置进行分帧,每调用一次根据wave数据生成一帧  */

//wave:|------------------------------|
//分帧 | 第一帧 |
//          | 第二帧 |
//               | 第三帧 |
//                    ....
//                                |--补零~~~|

//注：最后一帧数据不足时，函数会将零值补入。
/************************************************************************/
//ft:分帧之后的一帧数据，其中元素的类型为float.
//       函数中不会对此数组分配新的存储空间，请在调用前分配好
//frameSize:一帧内的采样点数，即float数组的长度
//       大小等于分帧是设置的窗宽(windowSize一般为20-30毫秒)*采样率(sampleRate)
//                例如：窗宽25ms,采样率为16000hz。则frameSize=25*10^(-3) * 16000=400
//targetFrameRate:帧移的采样点数
//       大小等于帧移targetRate(一般为windowSize的一半左右)*采样率(sampleRate)
//                例如：targetRate为10ms,采样率为16000hz,则targetFrameRate=160
//返回值：
//       帧首越界返回false
//       负责返回为true
/*
__declspec(dllexport) bool GenOneFrameFromData (vector<float>& ft,int frameSize,
											   int targetSampleRate);
__declspec(dllexport) bool GenOneFrameFromData (float* ft,int frameSize,
											   int targetFrameRate);*/

/************************************************************************/
/*PreEmphasise：抑制数据帧中的低频分量                                  */
/************************************************************************/
//输入为数据帧s(如为数组则需要传入数组长度)，预加重系数k
//函数中会对数据进行修改
//__declspec(dllexport) void PreEmphasise (vector<float>& s, float k);
//__declspec(dllexport) void PreEmphasise (float* s,int size, float k);

//void PreEmphasise (vector<float>& s, float k);
void PreEmphasise (float* s,int size, float k);

/************************************************************************/
/*Ham：对此帧数据加汉明窗                                               */
/************************************************************************/
//输入为数据帧s(如为数组则需要传入数组长度)
//注：此函数中会分配内存
//void Ham (vector<float>& s);
void Ham (float* s, int size);

/************************************************************************/
/*Realft：对float数组应用fft变换                                        */
/************************************************************************/
//注意此float数组是在加窗完成后进行补零值后生成的新数组
//void Realft (vector<float>& s);
void Realft (float* s, int size);

/************************************************************************/
/*ReleaseMem：main函数结束前需调用此函数释放dll中分配的资源             */
/************************************************************************/
void ReleaseMem ();
//释放dll中分配的资源

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
	int numOrgCoef;			   //每帧原始特征数目(即非D,A,T)
	int numColumn;             //每帧特征数目
	bool simpleDiffs;       /* Use simple differences for delta calcs */
	bool zMeanSrc;          /* Zero Mean the Source */
	bool eNormalise;        /* Normalise log energy */
}IOConfigRec;