#include "ParticleEmitterPoint.h"
#include "GameMath.h"

void ParticleEmitterPoint::Emitt(std::vector<ParticleInstance> &instance, int numEmitt)
{
	ParticleInstance part;

	while (numEmitt > 0)
	{
		part.Position = D3DXVECTOR3(Position.x, Position.y, Position.z);

		part.Velocity.x = RandomRangeF(minVelocity.x, maxVelocity.x);
		part.Velocity.y = RandomRangeF(minVelocity.y, maxVelocity.y);
		part.Velocity.z = RandomRangeF(minVelocity.z, maxVelocity.z);
		part.Colour.x = RandomRangeF(minColour.x, maxColour.x);
		part.Colour.y = RandomRangeF(minColour.y, maxColour.y);
		part.Colour.z = RandomRangeF(minColour.z, maxColour.z);
		part.Colour.w = RandomRangeF(minColour.w, maxColour.w);
		part.Size = RandomRangeF(minSize, maxSize);
		part.Life = RandomRangeI(minLife, maxLife);
		part.Age = 0;

		instance.push_back(part);
		
		numEmitt--;

	}
}