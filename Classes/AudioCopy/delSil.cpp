#include <iostream>
#include <fstream>
#include <string.h>
#include <assert.h>
#include "delSil.h"
#include <string>
using namespace std;

struct Struct_E_C
{
	int energy;
	int czeroRate;
};
#define _UNKNOWN_WAV_FMT_

int processData(short* srcData, short* dstData, int datalen, int vadFrameSize);
Struct_E_C calEnergy(short* data, int len);
void getScp(string scpFileName, string path);
bool readWavHeader(ifstream& wavFile, int& headerlen, int& datalen, int& sampleRate, short& channels);
#ifdef _UNKNOWN_WAV_FMT_
void transfm(const char* sFileName)
{
	ifstream wavFile(sFileName, ios_base::in | ios_base::binary);
	if(!wavFile.is_open())
		return;
	wavFile.seekg(-1,ios_base::end);
	int fileLength = wavFile.tellg();
	fileLength = fileLength - 4096 + 44;
	char * data = new char[fileLength];
	wavFile.seekg(0);
	wavFile.read(data,36);
	wavFile.seekg(4088);
	wavFile.read(data+36,fileLength - 36);
	wavFile.close();
	string dFileName;
	dFileName.assign(sFileName).append(".bk");
	ofstream newWavFile(dFileName.c_str(), ios_base::trunc | ios_base::binary);
	newWavFile.write(data,fileLength);
	newWavFile.flush();
	newWavFile.close();
	return;
}
#endif
bool delSil(const char* sFileName, const char* tFileName)
{
#ifdef _UNKNOWN_WAV_FMT_
	transfm(sFileName);
	string newSFileName;
	newSFileName.assign(sFileName).append(".bk");
	sFileName = newSFileName.c_str();
#endif
	ifstream wavFile(sFileName, ios_base::in | ios_base::binary);
	if(!wavFile.is_open())
		return false;
	int headerlen = 0;
	int datalen = 0;
	int sampleRate = 0;
	short channels = 0;
	if (!readWavHeader(wavFile, headerlen, datalen, sampleRate, channels))
	{
		cerr<<"Error occurred in reading the wav file"
			<<" Please make sure the file is a standard RIFF wave file"<<endl;
		return false;
	}
	if (channels == 2)
	{
		cout<<"We don't support for this two-channels kind music yet"<<endl;
		exit(1);
	}
	datalen /= 2;
	short* srcData = new short[datalen];
	short* dstData = new short[datalen];
	int vadFrameSize = Df_TimeSeg * sampleRate / 1000;
	wavFile.seekg(0);
	char* headerData = new char[headerlen - 4];
	wavFile.read(headerData, headerlen - 4);
	wavFile.seekg(headerlen);
	wavFile.read((char*)srcData, datalen * sizeof(short));
	wavFile.close();
	int newDatalen = processData(srcData, dstData, datalen, vadFrameSize);
	ofstream newWavFile(tFileName, ios_base::trunc | ios_base::binary);
	newWavFile.write(headerData, headerlen - 4);
	delete[] headerData;
	newDatalen *= 2;//×Ö½ÚÊý
	newWavFile.write((char*)&newDatalen, sizeof(int));
	newWavFile.write((char*)dstData, newDatalen);
	newWavFile.close();
	delete []dstData;
	delete []srcData;
	return true;
}

int processData(short* srcData, short* dstData, int datalen, int vadFrameSize)
{
	int i = 0, j = 0;
	int SilenceETh = 0;
	int SilenceCTh = 0;
	int frameNum = datalen / vadFrameSize;
	assert(frameNum > 3);
	for (i = 0; i < 3; i++)
	{
		Struct_E_C tmp_E_C = calEnergy(srcData + i*vadFrameSize, vadFrameSize);
		SilenceETh += tmp_E_C.energy;
		SilenceCTh += tmp_E_C.czeroRate;
	}
	SilenceETh =(int)(SilenceETh * Energy_CE / 3);
	SilenceCTh =(int)(SilenceCTh * Crossz_CE / 3);
	if(SilenceETh < Df_SilenceETh || SilenceETh > Df_SilenceETh)
		//SilenceETh = Df_SilenceETh;
		SilenceETh = Df_SilenceETh*2;
	for (i = 0; i < frameNum; i++)
	{
		Struct_E_C struct_E_C = calEnergy(srcData + i*vadFrameSize, vadFrameSize);
		if (struct_E_C.energy * 3 > SilenceETh)
		{
			memcpy(dstData + j*vadFrameSize, srcData+i*vadFrameSize, vadFrameSize*sizeof(short));
			j++;
		}
		else
		{
			datalen -= vadFrameSize;
		}
	}
	memcpy(dstData + j*vadFrameSize, srcData + i*vadFrameSize,datalen%vadFrameSize);
	return datalen;
}

Struct_E_C calEnergy(short* data, int len)
{
	double eng, avg;
	avg = 0;
	int czr = 0;
	for(int i = 0; i < len; i++ )
	{
		avg += data[i];
// 		if(i > 0)
// 		{
// 			int tmp = data[i]*data[i-1];
// 			if (tmp < 0)
// 			{
// 				czr += 2;
// 			}
// 			else if (tmp == 0)
// 			{
// 				czr += 1;
// 			}
// 		}
	}
	czr /= 2;
	avg /= len;

	// Get Frame Energy
	eng = 0;
	for(int i = 0; i < len; i++ )
		eng += abs((int)(data[i]-avg));
	eng /= len;
	Struct_E_C struct_E_C = {int(eng), czr};
	return struct_E_C;
}

void getScp(string scpFileName, string path)
{
	ifstream scpFile(scpFileName.data(), ios_base::in);
	string srcName, dstName;
	char buf[255];
	while (!scpFile.eof())
	{
		scpFile.getline(buf, 255);
		srcName.assign(buf);
		if (0 == srcName.length())
			break;
		int idx = srcName.rfind('\\');
		if (idx == string::npos)
		{
			idx = srcName.rfind('/');
		}
		if (string::npos == idx)
		{
			cerr<<"Pathname separator should be '\\' or '/' in scp file"<<endl;
			exit(1);
		}
		dstName.assign(path.data()).append("\\").append(srcName.substr(idx+1).data());
		bool state = delSil(srcName.data(), dstName.data());
		if(!state)
			cerr<<"Del silence failed in "<<srcName<<endl;
	}
	scpFile.close();
}

bool readWavHeader(ifstream& wavFile, int& headerlen, int& datalen, int& sampleRate, short& channels)
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
	wavFile.read((char*)&datalen, 4);
	return true;
}