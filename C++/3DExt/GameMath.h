#pragma once

#ifndef RAND_MAX
#define RAND_MAX 0x7fff
#endif // !RAND_MAX

#ifndef PI
#define PI 3.14159265359
#endif // !PI

#ifndef TAU
#define TAU 6.28318530718
#endif

#include <cmath>

//
// Conversion
//
#define Deg2Rad(V) return V * 0.0174532925;
#define Rad2Deg(V) return V * 57.2958;

//
// Random
//
inline float RandomRangeF(float min, float max)
{
	return min + (((float)rand()) / ((float)RAND_MAX / (max - min)));
}

inline float RandomF(float max)
{
	return (((float)rand()) / ((float)RAND_MAX)) * max;
}

inline int RandomRangeI(int min, int max)
{
	return min + (rand() % (max - min + 1));
}

//
// Interpolation
//
inline float LinearInterpolate(float v1, float v2, float t)
{
    return (v1 * (1.f - t) + v2 * t);
}