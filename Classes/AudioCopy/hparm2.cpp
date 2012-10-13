#include "hparm2.h"
#include <complex>
#include <fstream>
#include <iostream>
#include <vector>
using namespace std;

#define __Linear_
static float* hamWin = NULL;
static int hamWinSize = 0;
static float* centreFre = NULL;
static int cfSize = 0;
static short* loChan = NULL;
static float* loWt = NULL;
static int klo = 0, khi = 0;
static int cepWinL = 0, cepWinSize = 0;
static float* cepWin = NULL;
static int fftN = 2;
static float* fftBuf = NULL;
static float* fbank = NULL;
static float* cepstral = NULL;
static float* feature;
/*
static int nSamples = 0;
static const short* wave = NULL;
static int sampleRate = 0;
static int offset = 0;//分帧时记录偏移量
*/

IOConfigRec myIOConfig;
void setConfig(char* configFile);


bool readWavHeader2(ifstream& wavFile, int& headerlen, int& datalen, int& sampleRate, short& channels)
{
	if (!wavFile.is_open())
		return false;
	char format[] = "WAVEfmt ";
	wavFile.seekg(8);
	char ch;
	for (int i = 0; i < 8; i++)
	{
		wavFile.read(&ch, 1);
		if (ch != format[i])
			return false;
	}
	wavFile.seekg(24);
	wavFile.read((char*)&sampleRate, 4);
	wavFile.seekg(16);
	int encodeType;
	wavFile.read((char*)&encodeType, 4);
	wavFile.seekg(22);
	wavFile.read((char*)&channels, 2);
	if (channels < 1 || channels > 2)
		return false;
	switch (encodeType)
	{
		case 0x10 : 
			headerlen = 44;
			break;
		case 0x12 :
			headerlen = 58;
			break;
		case 0x14 :
			headerlen = 60;
			break;
		case 0x32 :
			headerlen = 90;
			break;
		default :
			return false;
	}
	wavFile.seekg(headerlen - 4);
	//////////////////////////////////////////////////////////////////////////
    int zeros;
    wavFile.read((char*)&zeros, 4);
    ///headerlen += zeros + 8;
    headerlen += zeros + 8;
	
	cout << "HeaderLen : " <<headerlen<<endl;
    wavFile.seekg(headerlen - 4);
	//////////////////////////////////////////////////////////////////////////
	
	///wavFile.read((char*)&datalen, 4);
	wavFile.read((char*)&datalen, 4);
	cout << "Datalength:" << datalen<< endl;
	return true;
}

void setConfig(char* configFile)
{
	//默认NATURALWRITEORDER 为true
	myIOConfig.tgtPK = 0x0B46;
	myIOConfig.tgtSampRate = 100000.0;
	myIOConfig.winDur = 200000.0;
	myIOConfig.preEmph = 0.97;
	myIOConfig.numChans = 24;
	myIOConfig.cepLifter = 30;
	myIOConfig.numCepCoef = 14;
	myIOConfig.loFBankFreq = 100;         /* Fbank lo frequency cut-off */
	myIOConfig.hiFBankFreq = 3800;         /* Fbank hi frequency cut-off */
	myIOConfig.srcSampRate = 1250.0;
	myIOConfig.silFloor = 50.0;
	myIOConfig.eScale = 0.1;
	myIOConfig.simpleDiffs = true;
	myIOConfig.zMeanSrc = true;
	myIOConfig.eNormalise = true;
	myIOConfig.numColumn = myIOConfig.numCepCoef;
	myIOConfig.numOrgCoef = myIOConfig.numCepCoef;
	if (myIOConfig.tgtPK&HASZEROC)
	{
		myIOConfig.numColumn++;
		myIOConfig.numOrgCoef++;
	}
	if (myIOConfig.tgtPK&HASENERGY)
	{
		myIOConfig.numColumn++;
		myIOConfig.numOrgCoef++;
	}
	if (myIOConfig.tgtPK&HASDELTA)
	{
		myIOConfig.numColumn += myIOConfig.numOrgCoef;
	}
	if (myIOConfig.tgtPK&HASACCS)
	{
		myIOConfig.numColumn += myIOConfig.numOrgCoef;
	}
}

float Mel(int k,float fres)
{
	return 1127 * log(1 + (k-1)*fres);
}

void ZeroMeanFrame(float* v,int size)
{
	int i;
	float sum=0.0,off;

	for (i=0; i<size; i++) sum += v[i];
	off = sum / size;
	for (i=0; i<size; i++) v[i] -= off;
}

void InitFBank(int frameSize, int sampleP, IOConfigRec myIOConfig)
{
	int numChans = myIOConfig.numChans;
	fbank = new float[numChans];
	cepstral = new float[myIOConfig.numCepCoef];
	while (frameSize>fftN) fftN *= 2;
	fftBuf = new float[fftN];
	int Nby2 = fftN / 2;
	float fres = 1.0E7/(sampleP * fftN * 700.0);
	klo = 1, khi = Nby2-1;
	float mlo = 0.0, mhi = Mel(Nby2+1,fres);
	if (myIOConfig.loFBankFreq>=0.0) {
		mlo = 1127*log(1+myIOConfig.loFBankFreq/700.0);
		klo = (int) ((myIOConfig.loFBankFreq * myIOConfig.srcSampRate * 1.0e-7 * fftN) + 2.5) - 1;
		if (klo<1) klo = 1;
	}
	if (myIOConfig.hiFBankFreq>=0.0) {
		mhi = 1127*log(1+myIOConfig.hiFBankFreq/700.0);
		khi = (int) ((myIOConfig.hiFBankFreq * myIOConfig.srcSampRate * 1.0e-7 * fftN) + 0.5) - 1;
		if (khi>Nby2 - 1) khi = Nby2 - 1;
	}
	int maxChan = numChans+1;
	centreFre = new float[maxChan];
	float ms = mhi - mlo;
	int chan = 0;
	for (chan=0; chan < maxChan; chan++)
	{
		centreFre[chan] = ((float)(chan+1)/(float)maxChan)*ms + mlo;
	}
	loChan = new short[Nby2];
	int k = 0;
	float melk = 0.0;
	for (k=0,chan=0; k<Nby2; k++){
		melk = Mel(k+1,fres);
		if (k<klo || k>khi) loChan[k]=-1;
		else {
			while (centreFre[chan] < melk  && chan<maxChan) ++chan;
			loChan[k] = chan;
		}
	}
	loWt = new float[Nby2];
	for (k=0; k<Nby2; k++) {
		chan = loChan[k];
		if (k<klo || k>khi) loWt[k]=0.0;
		else {
			if (chan>0) 
				loWt[k] = ((centreFre[chan] - Mel(k+1,fres)) / 
				(centreFre[chan] - centreFre[chan-1]));
			else
				loWt[k] = (centreFre[0]-Mel(k+1,fres))/(centreFre[0] - mlo);
		}
	}
}
// bool SetDataFlow (const vector<short>& wave,int sampleRate)
// {
// 	return SetDataFlow(&wave[0],wave.size(),sampleRate);
// }
// bool SetDataFlow (const short* wave,int nSamples,int sampleRate)
// {
// 	if (nSamples <= 0 )
// 	{
// 		return false;
// 	}
// 	if (wave == NULL)
// 	{
// 		return false;
// 	}
// 	switch (sampleRate)
// 	{
// 	case 6000:
// 	case 8000:
// 	case 16000:
// 	case 32000:
// 	case 44100:
// 		break;
// 	default:
// 		return false;
// 	}
// 
// 	::nSamples = nSamples;
// 	::wave = wave;
// 	::sampleRate = sampleRate;
// 	return true;
// }

/*
int CalFrameNum (int nSamples,int sampleRate,int winSize, int targetRate)
{
	return (nSamples - winSize * sampleRate)/(targetRate * sampleRate) + 1;
}*/


void PreEmphasise (vector<float>& s, float k)
{
	PreEmphasise(&s[0],s.size(),k);
}

/*
bool GenOneFrameFromData (float* ft,int frameSize,int targetFrameRate)
{
	if (offset > nSamples)
	{
		return false;
	}
	for (int i = 0; i < frameSize; i++)
	{
		ft[i] = wave[offset + i];
	}
	offset += targetFrameRate;
	return;
}*/


void PreEmphasise (float* s,int size, float k)
{
	int i = 0;
	float preE = k;
	for (i = size - 1; i > 0; i --)
		s[i] -= s[i - 1] * preE;
	s[0] *= 1.0 - preE;
}
static void GenHamWindow (int frameSize)
{
	int i;
	float a;

	if (hamWin==NULL || hamWinSize != frameSize)
		hamWin = new float[frameSize];
	hamWinSize = frameSize;
	a = TPI / (frameSize - 1);
	for (i=0;i<frameSize;i++)
		hamWin[i] = 0.54 - 0.46 * cos(a*i);
	hamWinSize = frameSize;
}

void Ham (vector<float>& s)
{
	Ham(&s[0], s.size());
}
void Ham (float* s, int size)
{
	int i;
	if (hamWinSize != size)
		GenHamWindow(size);
	for (i=0;i<size;i++)
		s[i] *= hamWin[i];
}

void FFT(float* s, int size, int invert)
{
	int ii,jj,n,nn,limit,m,j,inc,i;
	double wx,wr,wpr,wpi,wi,theta;
	double xre,xri,x;

	n=size;
	nn=n / 2; j = 1;
	for (ii=1;ii<=nn;ii++) {
		i = 2 * ii - 1;
		if (j>i) {
			xre = s[j-1]; xri = s[j];
			s[j-1] = s[i-1];  s[j] = s[i];
			s[i-1] = xre; s[i] = xri;
		}
		m = n / 2;
		while (m >= 2  && j > m) {
			j -= m; m /= 2;
		}
		j += m;
	};
	limit = 2;
	while (limit < n) {
		inc = 2 * limit; theta = TPI / limit;
		if (invert) theta = -theta;
		x = sin(0.5 * theta);
		wpr = -2.0 * x * x; wpi = sin(theta); 
		wr = 1.0; wi = 0.0;
		for (ii=1; ii<=limit/2; ii++) {
			m = 2 * ii - 1;
			for (jj = 0; jj<=(n - m) / inc;jj++) {
				i = m + jj * inc;
				j = i + limit;
				xre = wr * s[j-1] - wi * s[j];
				xri = wr * s[j] + wi * s[j-1];
				s[j-1] = s[i-1] - xre; s[j] = s[i] - xri;
				s[i-1] = s[i-1] + xre; s[i] = s[i] + xri;
			}
			wx = wr;
			wr = wr * wpr - wi * wpi + wr;
			wi = wi * wpr + wx * wpi + wi;
		}
		limit = inc;
	}
	if (invert)
		for (i = 1;i<=n;i++) 
			s[i-1] = s[i-1] / nn;

}

void Realft (float* s, int size)
{
	int n, n2, i, i1, i2, i3, i4;
	double xr1, xi1, xr2, xi2, wrs, wis;
	double yr, yi, yr2, yi2, yr0, theta, x;

	n=size / 2; n2 = n/2;
	theta = PI / n;
	FFT(s, size, false);
	x = sin(0.5 * theta);
	yr2 = -2.0 * x * x;
	yi2 = sin(theta); yr = 1.0 + yr2; yi = yi2;
	for (i=1; i<n2; i++) {
		i1 = i + i;      i2 = i1 + 1;
		i3 = n + n + 1 - i2; i4 = i3 + 1;
		wrs = yr; wis = yi;
		xr1 = (s[i1] + s[i3])/2.0; xi1 = (s[i2] - s[i4])/2.0;
		xr2 = (s[i2] + s[i4])/2.0; xi2 = (s[i3] - s[i1])/2.0;
		s[i1] = xr1 + wrs * xr2 - wis * xi2;
		s[i2] = xi1 + wrs * xi2 + wis * xr2;
		s[i3] = xr1 - wrs * xr2 + wis * xi2;
		s[i4] = -xi1 + wrs * xi2 + wis * xr2;
		yr0 = yr;
		yr = yr * yr2 - yi  * yi2 + yr;
		yi = yi * yr2 + yr0 * yi2 + yi;
	}
	xr1 = s[0];
	s[0] = xr1 + s[1];
	s[1] = 0.0;
}

void PerformFBank(float* s, int size, float* fbank, int numChans)
{
	float t1, t2, ek;
	int bin = 0;
	for (int k = klo; k <= khi; k++) {             /* fill bins */
		t1 = s[2*k]; t2 = s[2*k + 1];
		ek = sqrt(t1*t1 + t2*t2);
		bin = loChan[k];
		t1 = loWt[k]*ek;
		if (bin>0) fbank[bin-1] += t1;
		if (bin<=numChans) fbank[bin] += ek - t1;
	}
	for (bin=0; bin<numChans; bin++) { 
		t1 = fbank[bin];
		if (t1<1.0) t1 = 1.0;
		fbank[bin] = log(t1);
	}
}

void FBank2MFCC(float* fbank,int fsize, float* c, int n)//c:mfcc data, n:mfcc datasize
{
	int j,k,numChan;
	float mfnorm,pi_factor,x;

	numChan = fsize;//26
	mfnorm = sqrt(2.0/(float)numChan);
	pi_factor = PI/(float)numChan;
	for (j=0; j<n; j++)  {//n:NUMCEPS
		c[j] = 0.0; x = (float)(j+1) * pi_factor;
		for (k=0; k<numChan; k++)
			c[j] += fbank[k] * cos(x*(k+0.5));
		c[j] *= mfnorm;
	}        
}

/* GenCepWin: generate a new cep liftering vector */
static void GenCepWin (int cepLiftering, int count)
{
	int i;
	float a, Lby2;

	if (cepWin==NULL || cepWinSize < count)
		cepWin = new float[count];
	a = PI/cepLiftering;
	Lby2 = cepLiftering/2.0;
	for (i=0;i<count;i++)
		cepWin[i] = 1.0 + Lby2*sin((i+1) * a);
	cepWinL = cepLiftering;
	cepWinSize = count;
}
/* EXPORT->WeightCepstrum: Apply cepstral weighting to c */
void WeightCepstrum (float* c, int count, int cepLiftering)
{
	int i,j;

	if (cepWinL != cepLiftering || count > cepWinSize)
		GenCepWin(cepLiftering,count);
	j = 0;
	for (i=0;i<count;i++)
		c[j++] *= cepWin[i];
}

/* EXPORT->FBank2C0: return zero'th cepstral coefficient */
float FBank2C0(float* fbank, int numChan)
{
	int k;
	float mfnorm,sum;

	mfnorm = sqrt(2.0/(float)numChan);
	sum = 0.0; 
	for (k=0; k<numChan; k++)
		sum += fbank[k];
	return sum * mfnorm;
}

void NormaliseLogEnergy(float *data,int n,int step,float silFloor,float escale)
{
	float *p,max,min;
	int i;

	/* find max log energy */
	p = data; max = *p;
	for (i=1;i<n;i++){
		p += step;                   /* step p to next e val */
		if (*p > max) max = *p;
	}
	min = max - (silFloor*log(10.0))/10.0;  /* set the silence floor */
	/* normalise */
	p = data;
	for (i=0;i<n;i++){
		if (*p < min) *p = min;          /* clamp to silence floor */
		*p = 1.0 - (max - *p) * escale;  /* normalise */
		p += step; 
	}
}

void Regress(float *data, int vSize, int step, int offset,
					int delwin, int head, int tail, int cur,bool simpleDiffs)
{
	float *fp,*fp1,*fp2, *back, *forw;
	float sum, sigmaT2;
	int i,t,j;

	sigmaT2 = 0.0;
	for (t=1;t<=delwin;t++)
		sigmaT2 += t*t;
	sigmaT2 *= 2.0;
	fp = data;
	fp1 = fp; fp2 = fp+offset;
	for (j=0;j<vSize;j++){
		back = forw = fp1; sum = 0.0;
		for (t=1;t<=delwin;t++) {
			if (cur-t >= head) back -= step;
			if (cur+t <= tail) forw += step;
			sum += t * (*forw - *back);
		}
		if (simpleDiffs)
			*fp2 = (*forw - *back) / (2*delwin);
		else
			*fp2 = sum / sigmaT2;
		++fp1; ++fp2;
	}
}

void FZeroMean(float *data, int vSize, int n, int step)
{
	double sum;
	float *fp,mean;
	int i,j;

	for (i=0; i<vSize; i++){
		/* find mean over i'th component */
		sum = 0.0;
		fp = data+i;
		for (j=0;j<n;j++){
			sum += *fp; fp += step;
		}
		mean = sum / (double)n;
		/* subtract mean from i'th components */
		fp = data+i;
		for (j=0;j<n;j++){
			*fp -= mean; fp += step;
		}
	}
}

void ReleaseMem ()
{
	delete [] hamWin;
	delete [] centreFre;
	delete [] loChan;
	delete [] loWt;
	delete [] cepWin;
	delete [] fftBuf;
	delete [] fbank;
	delete [] cepstral;
}

bool hcopy2(const char* sFileName,const char* dFileName)
{
	setConfig("hello");
	
	ifstream wavFile(sFileName, ios_base::in | ios_base::binary);
	if(!wavFile.is_open())
		return false;
	int headerlen = 0;
	int datalen = 0;
	int sampleRate = 0;
	short channels = 0;
	
	if (!readWavHeader2(wavFile, headerlen, datalen, sampleRate, channels))
	{
		cerr<<"Error occurred in reading the wav file"
			<<" Please make sure the file is a standard RIFF wave file"<<endl;
		return false;
	}
	
	cout << "ReadWavHeader2 finished." <<endl;
	if (channels != 1)
	{
		return false;
	}
#ifdef __Linear_
	datalen /= 2;
	short* wavShortBuf = new short[datalen];
	wavFile.seekg(headerlen);
	wavFile.read((char*)wavShortBuf, datalen * sizeof(short));
	int frameSize = myIOConfig.winDur * sampleRate / 10000000;
	int frameShiftSize = myIOConfig.tgtSampRate * sampleRate / 10000000;
	int frameNo = (datalen > frameSize) ? (datalen - frameSize)/frameShiftSize : 0;
	float* wavFltBuf = new float[frameSize];

	feature = new float[frameNo * myIOConfig.numColumn];
	InitFBank(frameSize,10000000.0/sampleRate,myIOConfig);
	float* curfp = feature;
	for (int num = 0; num < frameNo; num++)
	{
		/************************************************************************/
		/* 分帧                                                                 */
		/************************************************************************/
		for (int j = 0; j < frameSize; j++)
			wavFltBuf[j] = wavShortBuf[num*frameShiftSize+j];
		if (myIOConfig.zMeanSrc)
			ZeroMeanFrame(wavFltBuf,frameSize);
		float rawte = 0.0;
		if (myIOConfig.tgtPK&HASENERGY){
			for (int j=0; j<frameSize; j++)
				rawte += wavFltBuf[j] * wavFltBuf[j];
		}
		/************************************************************************/
		/* 预加重                                                               */
		/************************************************************************/
		PreEmphasise(wavFltBuf,frameSize,myIOConfig.preEmph);
		/************************************************************************/
		/*加窗                                                                  */
		/************************************************************************/
		Ham(wavFltBuf,frameSize);
		/************************************************************************/
		/* 傅里叶                                                               */
		/************************************************************************/
		for (int i = 0; i < frameSize; i++)
		{
			fftBuf[i] = wavFltBuf[i];
		}
		for (int i = frameSize; i < fftN; i++)
		{
			fftBuf[i] = 0.0;
		}
		Realft(fftBuf,fftN);
		/************************************************************************/
		/* 应用滤波器组                                                         */
		/************************************************************************/
		for (int i = 0; i < myIOConfig.numChans; i++)
		{
			fbank[i] = 0.0;
		}
		PerformFBank(fftBuf,fftN,fbank,myIOConfig.numChans);
		/************************************************************************/
		/* 计算倒谱系数                                                         */
		/************************************************************************/
		FBank2MFCC(fbank,myIOConfig.numChans,cepstral,myIOConfig.numCepCoef);
		/************************************************************************/
		/* 加重                                                                 */
		/************************************************************************/
		WeightCepstrum(cepstral,myIOConfig.numCepCoef,myIOConfig.cepLifter);
		for (int i = 0; i < myIOConfig.numCepCoef; i++)
		{
			*curfp= cepstral[i];
			curfp++;
		}
		/************************************************************************/
		/* 傅里叶变换                                                           */
		/************************************************************************/
		{
			int countPush = myIOConfig.numCepCoef;
			if (myIOConfig.tgtPK&HASZEROC)
			{
				float c0 = FBank2C0(fbank,myIOConfig.numChans);
				*curfp = c0;
				curfp++;
			}
			if (myIOConfig.tgtPK&HASENERGY) {
				float te = rawte;
				te = (te<MINLARG) ? LZERO : log(te);
				*curfp = te;
				curfp++;
			}
			curfp += (myIOConfig.numColumn - myIOConfig.numOrgCoef);//如果有D,A,T 先空出位置
// 			for (int i = countPush; i < myIOConfig.numColumn; i++)
// 			{
// 				feature.push_back(0.0);
// 			}
		}
	}
	/************************************************************************/
	/* 是否需要把能量标准化                                                 */
	/************************************************************************/
	if ((myIOConfig.tgtPK&HASENERGY)&& myIOConfig.eNormalise)
	{
		NormaliseLogEnergy(feature+myIOConfig.numCepCoef,frameNo,myIOConfig.numColumn,myIOConfig.silFloor,myIOConfig.eScale);
	}
	/************************************************************************/
	/* 计算detla                                                            */
	/************************************************************************/
	if (myIOConfig.tgtPK&HASDELTA)
	{
		for (int i = 0; i < frameNo; i++)
		{
			float *curfp = feature+i*myIOConfig.numColumn;
			int step = myIOConfig.numColumn;
			int offset = myIOConfig.numOrgCoef;
			int vSize = offset;
			int deltawin = 2;
			int head = 0;
			int tail = frameNo - 1;
			int cur = i;
			Regress(curfp,vSize,step,offset,deltawin,head,tail,cur,myIOConfig.simpleDiffs);
		}
	}
	/************************************************************************/
	/* 计算Accelerate                                                       */
	/************************************************************************/
	if (myIOConfig.tgtPK&HASACCS)
	{
		for (int i = 0; i < frameNo; i++)
		{
			float *curfp = feature+i*myIOConfig.numColumn+myIOConfig.numOrgCoef;
			int step = myIOConfig.numColumn;
			int offset = myIOConfig.numOrgCoef;
			int vSize = offset;
			int deltawin = 2;
			int head = 0;
			int tail = frameNo - 1;
			int cur = i;
			Regress(curfp,vSize,step,offset,deltawin,head,tail,cur,myIOConfig.simpleDiffs);
		}
	}
	/************************************************************************/
	/* 输出类型中是否有Z                                                    */
	/************************************************************************/
	if (myIOConfig.tgtPK&HASZEROM)
	{
		int d = myIOConfig.numCepCoef;
		if (myIOConfig.tgtPK&HASZEROC)
			d++;
		FZeroMean(feature,d,frameNo,myIOConfig.numColumn);
	}
	/************************************************************************/
	/* 输出文件                                                             */
	/************************************************************************/
	int nSamples = frameNo;
	int samplePeriod = myIOConfig.tgtSampRate;
	short sampSize = myIOConfig.numColumn * sizeof(float);
	short parmKind = myIOConfig.tgtPK;
	ofstream fout(dFileName,ios_base::binary | ios_base::trunc);
	fout.write((char*)&nSamples,sizeof(int));
	fout.write((char*)&samplePeriod,sizeof(int));
	fout.write((char*)&sampSize,sizeof(short));
	fout.write((char*)&parmKind,sizeof(short));
	fout.write((char*)feature,frameNo*myIOConfig.numColumn*sizeof(float));
	fout.flush();
	fout.close();
	/************************************************************************/
	/* 结束                                                                 */
	/************************************************************************/
	ReleaseMem();
	delete [] feature;
	delete wavShortBuf;
	delete wavFltBuf;
#endif
	return true;
}