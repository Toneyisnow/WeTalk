#pragma once

struct MFCCHeader 
{
    int nSamples;
    int sampPeriod;
    short sampSize;
    short parmKind;
    bool readOrder;

    MFCCHeader(char* mfccFileName, bool order = true);
    ~MFCCHeader(){}
};

class MFCC
{
private:
    float* dataBuf;
public:
    MFCCHeader mfccHeader;
    MFCC(char* mfccFileName, bool order = true);
    float* getFrame(int frameNo);
    ~MFCC();
};
