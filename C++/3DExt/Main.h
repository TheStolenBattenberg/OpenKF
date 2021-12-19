#pragma once

#include <iostream>
#include <exception>
#include <vector>
#include <Windows.h>

#include "Types.h"

#define gmEx extern "C" __declspec (dllexport)

#define gmLog(str) std::cout << str << std::endl;
#define DebugMsg(msg) MessageBoxA(NULL, msg, "Error", NULL)

typedef const char* cstring;

template<typename T> inline T* toPointer(double v)
{
	return *(T**)&v;
}
template<typename T> inline double toDouble(T * v)
{
	double r;
	*(T**)&r = v;

	return r;
}
