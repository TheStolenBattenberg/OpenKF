#include "ParticleSystem.h"

#include <iostream>

ParticleSystem::ParticleSystem(IDirect3DDevice9* dev, int maxParticles)
{
	particleInstance.reserve(maxParticles);
	maxNumParticles = maxParticles;

	//D3D Vertex Declaration
	D3DVERTEXELEMENT9 partDecl[] = {
	{ 0, 0 , D3DDECLTYPE_FLOAT3, D3DDECLMETHOD_DEFAULT, D3DDECLUSAGE_POSITION, 0 },
	{ 0, 12, D3DDECLTYPE_FLOAT4, D3DDECLMETHOD_DEFAULT, D3DDECLUSAGE_COLOR, 0 },
	{ 0, 28, D3DDECLTYPE_FLOAT1, D3DDECLMETHOD_DEFAULT, D3DDECLUSAGE_PSIZE, 0 },
	D3DDECL_END()
	};

	if (FAILED(dev->CreateVertexDeclaration(partDecl, &decl)))
	{
		std::cout << "Create Declaration Failed" << std::endl;
	}

	if (FAILED(dev->CreateVertexBuffer(sizeof(ParticleInstance) * maxParticles, D3DUSAGE_DYNAMIC | D3DUSAGE_WRITEONLY, NULL, D3DPOOL_DEFAULT, &buffer, NULL)))
	{
		std::cout << "Create Buffer Failed" << std::endl;
	}

	dev->SetRenderState(D3DRS_POINTSPRITEENABLE, true);
	dev->SetRenderState(D3DRS_POINTSCALEENABLE, true);

	dev->SetRenderState(D3DRS_POINTSCALE_A, *(DWORD*)&pointScaleAB);
	dev->SetRenderState(D3DRS_POINTSCALE_B, *(DWORD*)&pointScaleAB);
	dev->SetRenderState(D3DRS_POINTSCALE_C, *(DWORD*)&pointScaleC);
}

ParticleSystem::~ParticleSystem()
{
	if (buffer != NULL)
		buffer->Release();

	if (decl != NULL)
		decl->Release();

	for (ParticleModifier* pm : particleModifier)
		delete pm;

	for (ParticleEmitter* pe : particleEmitter)
		delete pe;

	particleInstance.clear();
	particleModifier.clear();
	particleEmitter.clear();
}

int ParticleSystem::AddEmitter(ParticleEmitter* pe)
{
	particleEmitter.push_back(pe);
	return particleEmitter.size() - 1;
}

void ParticleSystem::SetTexture(LPDIRECT3DTEXTURE9 tex)
{
	texture = tex;
}

int ParticleSystem::AddModifier(ParticleModifier* pm)
{
	particleModifier.push_back(pm);
	return particleModifier.size() - 1;
}

void ParticleSystem::RemoveEmitter(int index)
{
	particleEmitter[index] = particleEmitter.back();
	particleEmitter.pop_back();
}

void ParticleSystem::RemoveModifier(int index)
{
	particleModifier[index] = particleModifier.back();
	particleModifier.pop_back();
}

void ParticleSystem::ToggleAutoEmitt()
{
	autoEmitt = !autoEmitt;
}

void ParticleSystem::Step()
{
	// Update Old Particles and apply modifiers
	unsigned int i = 0;
	while (i < particleInstance.size())
	{
		//'kill' old particles
		if (particleInstance[i].Age > particleInstance[i].Life)
		{
			particleInstance[i] = particleInstance.back();
			particleInstance.pop_back();

			if (i >= particleInstance.size())
				break;
		}

		//Update particle position and age
		particleInstance[i].Position += particleInstance[i].Velocity;
		particleInstance[i].Age++;

		//Apply any modifiers
		for (ParticleModifier* pm : particleModifier)
			pm->Modify(particleInstance[i]);

		++i;
	}

	// Emitt New Particles
	if (autoEmitt)
	{
		for (ParticleEmitter* pe : particleEmitter)
		{
			//Calculate num emitt, if it goes above the max size of the particle system,
			//simply say numEmitt is however many particles can be added before the max is reached.
			int numEmitt = pe->GetMinEmitt() + (rand() % (pe->GetMaxEmitt() - pe->GetMinEmitt() + 1));
			
			if (numEmitt < 0)
				numEmitt = 0;

			if ((particleInstance.size() + numEmitt) > (unsigned int)maxNumParticles)
				numEmitt = maxNumParticles - particleInstance.size();

			//Emitter call.
			pe->Emitt(particleInstance, numEmitt);
		}
	}

	// Build VB ( And flood the GPU with some useless data D: )
	if (particleInstance.size() > 0)
	{
		ParticleInstance* points;

		buffer->Lock(0, 0, (void**)&points, 0);
		memcpy(points, &particleInstance[0], sizeof(ParticleInstance) * (particleInstance.size()-1));
		buffer->Unlock();
	}
}

void ParticleSystem::Draw(IDirect3DDevice9* dev)
{
	//Set some blend / zwrite states
	//dev->SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
	//dev->SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
	dev->SetRenderState(D3DRS_ZWRITEENABLE, false);

	//Actual drawing.
	dev->SetTexture(0, texture);
	dev->SetVertexDeclaration(decl);
	dev->SetStreamSource(0, buffer, 0, sizeof(ParticleInstance));
	dev->DrawPrimitive(D3DPT_POINTLIST, 0, particleInstance.size());
	
	//Disable the blend / zwrite states
	dev->SetRenderState(D3DRS_ZWRITEENABLE, true);
	//dev->SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);
	//dev->SetRenderState(D3DRS_SRCBLEND, D3DBLEND_ZERO);
}