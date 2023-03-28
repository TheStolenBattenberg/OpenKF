#ifndef GMUTIL_H_
#define GMUTIL_H_

#include <iostream>

#define gmLog(str) std::cout << str << std::endl;
#define gmEx extern "C" __declspec (dllexport)

template<typename T> inline T* toPointer(double v)
{
	return *(T**)&v;
}

template<typename T> inline double toDouble(T* v)
{
	double r;
	*(T**)&r = v;

	return r;
}

#endif