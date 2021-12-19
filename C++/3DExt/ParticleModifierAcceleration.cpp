#include "ParticleModifierAcceleration.h"

void ParticleModifierAcceleration::Modify(ParticleInstance& instance)
{
	instance.Velocity.x = instance.Velocity.x * acceleration;
	instance.Velocity.y = instance.Velocity.y * acceleration;
	instance.Velocity.z = instance.Velocity.z * acceleration;
}