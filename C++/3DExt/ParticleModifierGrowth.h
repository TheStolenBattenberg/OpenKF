#pragma once

#include "ParticleModifier.h"

class ParticleModifierGrowth : public ParticleModifier
{
public:
	ParticleModifierGrowth(int minage, int maxage, float scalar) 
	{ 
		minAge = (float)minage; 
		maxAge = (float)maxage; 
		growth = scalar;

		ageC = (float)(maxAge - minAge);
	}
	void Modify(ParticleInstance& instance);

private:
	float minAge, maxAge, ageC;
	float growth;

};