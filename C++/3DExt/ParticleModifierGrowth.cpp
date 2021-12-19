#include "ParticleModifierGrowth.h"

inline float lerp(float a, float b, float t)
{
	return (a * (1.f - t) + b * t);
}

inline float minimum(float a)
{
	if (a < 0.f)
		return 0.f;
	return a;
}

void ParticleModifierGrowth::Modify(ParticleInstance& instance)
{
	instance.Size += lerp(0.f, growth, minimum(instance.Age - minAge) / ageC);
}