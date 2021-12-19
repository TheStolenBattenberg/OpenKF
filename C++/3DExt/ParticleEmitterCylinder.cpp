#include "ParticleEmitterCylinder.h"
#include "GameMath.h"

void ParticleEmitterCylinder::Emitt(std::vector<ParticleInstance>& instance, int numEmitt)
{
	ParticleInstance part;

	float xOff, yOff, zOff;
	float Theta, SqrtR;

	while (numEmitt > 0)
	{
		//Calculate Position inside of a cylinder
		
		// X, Y not so easy... z is too easy
		Theta = RandomRangeF(0.f, TAU);
		SqrtR = sqrtf(RandomF(1.f)) * CylinderParam.x;

		xOff = SqrtR * cos(Theta);
		yOff = SqrtR * sin(Theta);
		zOff = RandomRangeF(0.f, CylinderParam.y);

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