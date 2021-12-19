#pragma once

#include "ParticleType.h"

class ParticleModifier {
public:
	virtual void Modify(ParticleInstance &instance) = 0;
};