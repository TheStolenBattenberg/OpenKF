#pragma once

#include "ParticleModifier.h"

class ParticleModifierAcceleration : public ParticleModifier
{
public:
	ParticleModifierAcceleration(float accel) { acceleration = accel; }
	void Modify(ParticleInstance& instance);

private:
	float acceleration;

};