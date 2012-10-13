//
//  mainroot.h
//  OralTeacher
//
//  Created by sui toney on 10-9-12.
//  Copyright 2010 ms. All rights reserved.
//

#ifndef _MAINROOT_H
#define _MAINROOT_H

#include <vector>
using namespace std;

void Initiate(const char* dictstr, const char* tiedListstr,const char* hmmdefsstr);

float Viterbi(char* mfccFileName, vector<string>& answerPY);

void PostViterbi();



#endif