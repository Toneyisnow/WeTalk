#ifndef _DEL_SIL_H
#define _DEL_SIL_H
#ifdef __cplusplus
extern "C" {
#endif
const int Df_TimeSeg = 16;//毫秒，即臛断是否为静音的时长
const int Df_SilenceETh = 200;//能量初始鉍值
const int Df_SilenceCTh = 0;//筰零率初始鉍值
const double Energy_CE = 1.25;//能量系蔵
const double Crossz_CE = 1.23;//筰零率系蔵
bool delSil(const char* sFileName, const char* tFileName);
#ifdef __cplusplus
}
#endif
#endif