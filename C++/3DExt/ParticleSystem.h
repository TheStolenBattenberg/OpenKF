#pragma once

#include <d3d9.h>
#include <d3dx9.h>
#include <vector>

#include "ParticleType.h"

#include "ParticleEmitter.h"
#include "ParticleEmitterPoint.h"
#include "ParticleEmitterCylinder.h"
#include "ParticleEmitterSphere.h"

#include "ParticleModifier.h"
#include "ParticleModifierAcceleration.h"
#include "ParticleModifierGrowth.h"

class ParticleSystem {
public:
	ParticleSystem(IDirect3DDevice9* dev, int maxParticles);
	~ParticleSystem();

	void SetTexture(LPDIRECT3DTEXTURE9 tex);
	int AddEmitter(ParticleEmitter* pe);
	int AddModifier(ParticleModifier* pm);
	void RemoveEmitter(int index);
	void RemoveModifier(int index);

	void ToggleAutoEmitt();

	void Step();
	void Draw(IDirect3DDevice9* dev);

private:
	std::vector<ParticleInstance> particleInstance;

	std::vector<ParticleEmitter*> particleEmitter;
	std::vector<ParticleModifier*> particleModifier;

	bool autoEmitt = true;
	int maxNumParticles = 1024;

	LPDIRECT3DVERTEXDECLARATION9 decl = NULL;
	LPDIRECT3DVERTEXBUFFER9 buffer = NULL;
	LPDIRECT3DTEXTURE9 texture = NULL;

	const float pointScaleAB = 0.f;
	const float pointScaleC = 1.f;
};