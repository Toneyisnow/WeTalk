#ifndef _DEL_SIL_H
#define _DEL_SIL_H
#ifdef __cplusplus
extern "C" {
#endif
const int Df_TimeSeg = 16;//���룬���G���Ƿ�Ϊ������ʱ��
const int Df_SilenceETh = 200;//������ʼ�Gֵ
const int Df_SilenceCTh = 0;//�i���ʳ�ʼ�Gֵ
const double Energy_CE = 1.25;//����ϵ�i
const double Crossz_CE = 1.23;//�i����ϵ�i
bool delSil(const char* sFileName, const char* tFileName);
#ifdef __cplusplus
}
#endif
#endif