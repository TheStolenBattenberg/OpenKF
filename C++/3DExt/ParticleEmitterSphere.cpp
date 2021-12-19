#include "ParticleEmitterSphere.h"
#include "GameMath.h"

void ParticleEmitterSphere::Emitt(std::vector<ParticleInstance>& instance, int numEmitt)
{
	ParticleInstance part;

	float xOff, yOff, zOff;
	float Theta, Phi, r, sinPhi;

	while (numEmitt > 0)
	{
		//Calculate random position inside a sphere

		// The proper way
		Theta = RandomRangeF(0.f, TAU);
		Phi   = acosf((RandomF(2.f)) - 1.f);
		r     = powf(RandomF(1.f), 1.f / 3.f) * SphereRadius;

		sinPhi = sin(Phi);
		xOff = r * sinPhi * cos(Theta);
		yOff = r * sinPhi * sin(Theta);
		zOff = r * cos(Phi);

		// Position
		part.Position = D3DXVECTOR3(Position.x + xOff, Position.y + yOff, Position.z + zOff);

		// Velocity
		part.Velocity.x = RandomRangeF(minVelocity.x, maxVelocity.x);
		part.Velocity.y = RandomRangeF(minVelocity.y, maxVelocity.y);
		part.Velocity.z = RandomRangeF(minVelocity.z, maxVelocity.z);

		// Colour
		part.Colour.x = RandomRangeF(minColour.x, maxColour.x);
		part.Colour.y = RandomRangeF(minColour.y, maxColour.y);
		part.Colour.z = RandomRangeF(minColour.z, maxColour.z);
		part.Colour.w = RandomRangeF(minColour.w, maxColour.w);

		// Size
		part.Size = RandomRangeF(minSize, maxSize);

		// Life
		part.Life = RandomRangeI(minLife, maxLife);

		// Other
		part.Age = 0;


		instance.push_back(part);
		numEmitt--;
	}
}