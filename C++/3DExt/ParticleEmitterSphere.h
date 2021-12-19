#pragma once

#include <d3dx9.h>
#include <d3d9.h>

#include "ParticleEmitter.h"

class ParticleEmitterSphere : public ParticleEmitter
{
private:
	D3DXVECTOR3 Position;
	float SphereRadius;

public:
	ParticleEmitterSphere(int maxEmitt, int minEmitt)
	{
		maxPerStep = maxEmitt;
		minPerStep = minEmitt;
	}

	//Interface :)
	void Emitt(std::vector<ParticleInstance>& instance, int numEmitt);

	//Other shit
	void SetOrigin(float x, float y, float z)
	{
		Position.x = x;
		Position.y = y;
		Position.z = z;
	}
	void SetRadius(float r)
	{
		SphereRadius = r;
	}

};