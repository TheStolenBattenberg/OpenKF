#pragma once

#include <d3dx9.h>

struct ParticleInstance {
	D3DXVECTOR3 Position;
	D3DXVECTOR4 Colour;
	float Size;

	D3DXVECTOR3 Velocity;
	int Age, Life;
};

struct ParticlePoint {
	D3DXVECTOR3 Position;
	D3DXVECTOR4 Colour;
	float Size;
};