#pragma once

#include <vector>
#include <stack>

#include "ParticleType.h"

class ParticleEmitter {
public:
	virtual void Emitt(std::vector<ParticleInstance> &instance, int numEmitt) = 0;

	int GetMinEmitt() { return minPerStep; }
	int GetMaxEmitt() { return maxPerStep; }

	void setMinMaxEmitt(int minEmitt, int maxEmitt)
	{
		minPerStep = minEmitt;
		maxPerStep = maxEmitt;
	}
	void setMinMaxLife(int minlife, int maxlife)
	{
		minLife = minlife;
		maxLife = maxlife;
	}
	void setMinMaxSize(float minsize, float maxsize)
	{
		minSize = minsize;
		maxSize = maxsize;
	}
	void setMinMaxVelocity(D3DXVECTOR3 minvel, D3DXVECTOR3 maxvel)
	{
		minVelocity = minvel;
		maxVelocity = maxvel;
	}
	void setMinMaxColour(D3DXVECTOR4 mincolour, D3DXVECTOR4 maxcolour)
	{
		minColour = mincolour;
		maxColour = maxcolour;
	}

protected:
	int minPerStep = 0, maxPerStep = 8;
	int minLife = 0, maxLife = 60;
	float minSize = 1.f, maxSize = 2.f;

	D3DXVECTOR3 minVelocity, maxVelocity;
	D3DXVECTOR4 minColour, maxColour;
};