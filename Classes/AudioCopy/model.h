#pragma once

#define MAXNAMELEN 20
#define PI   3.14159265358979
#define TPI  6.28318530717959     /* PI*2 */
#define LZERO  (-1.0E10)   /* ~log(0) */
#define LSMALL (-0.5E10)   /* log values < LSMALL are set to LZERO */
#define MINEARG (-708.3)   /* lowest exp() arg  = log(MINLARG) */
#define MINLARG 2.45E-308  /* lowest log() arg  = exp(MINEARG) */
#define MINMIX  1.0E-5     /* Min usable mixture weight */
#define LMINMIX -11.5129254649702     /* log(MINMIX) */
#define _MYDEBUG
#define _MYDEBUGDTL

struct State
{
    float* weight;
    float* mean;
    float* variance;
    float* gconst;
    State(int mixNumber, int vecSize);
    ~State();
};

struct Transp
{
    float* logTransp;
    Transp(int num);
    ~Transp();
};

struct Model
{
    char name[MAXNAMELEN];
    int stateNum;
    State** state;
    Transp* transp;
    Model(const char* modelName, int num);
    ~Model();
};