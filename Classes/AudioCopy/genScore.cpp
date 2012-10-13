#include <string>
#include <fstream>
#include <vector>
#include <math.h>
#include "genScore.h"
using namespace std;


int score(string recgFIleName)
{
    string ignore, word;
    double sc;
    vector<string> strRst;
    ifstream fin(recgFIleName.c_str());
    getline(fin,ignore);
    getline(fin,ignore);
    
	int sum = 0;
	int count = 0;
    while (!fin.eof())
    {
        fin>>word;
        if (word.length() == 0)
        {
            break;
        }
        if (word.compare("."))
        {
            count++;
            fin>>word;
            fin>>word;
            fin>>sc;
			
			sc = abs((int)sc + 1500);
			int val = 0;
			if (sc < 1500)
            {
				val = 100 - ((int)(sc * sc/62500));
            }
			else {
				val = 70 * (int)(1500 / sc);
			}

			if(val < 70)
			{
				strRst.push_back(word);
			}
			sum += val;
        }
        else
            break;
    }
    if(0 == count)
        return 0;
    else
        return int(sum/count);
}