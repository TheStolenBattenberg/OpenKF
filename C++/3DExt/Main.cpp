//DEXterity
//Direct3D Extended for GMS 1.4.9999
//By TSB

#include <d3d9.h>
#include <d3dx9.h>
#include <math.h>

#include "BulletUtility.h"
#include "Main.h"
#include "ParticleSystem.h"
#include "DShowVideoPlayer.h"

//
// Dirty Globals
//
// Rendering
LPDIRECT3DDEVICE9 d3dDev = NULL;
LPDIRECT3D9 d3d = NULL;
HWND gmWindow = NULL;

std::vector<ParticleSystem*> ps;

// Collision
btDefaultCollisionConfiguration* myCollisionConfiguration = nullptr;
btCollisionDispatcher* myCollisionDispatcher = nullptr;
btBroadphaseInterface* myCollisionBroadphase = nullptr;
btCollisionWorld* myCollisionWorld = nullptr;

BulletDebug* myCollisionDebug = nullptr;
BulletRayResult myRayResult;

double adpcmFilterPN[5][2] = 
{ { 0.0, 0.0 },
{   60.0 / 64.0,  0.0 },
{  115.0 / 64.0, -52.0 / 64.0 },
{   98.0 / 64.0, -55.0 / 64.0 },
{  122.0 / 64.0, -60.0 / 64.0 } };

// Temporary, and nasty C. MOVE ME TOO AEolian
gmEx double DecodeADPCM(byte* adpcm, double adpcmOffset, double adpcmLength, short* samples)
{
	byte* adpcmBuffer   = adpcm + (uint)adpcmOffset;
	short* sampleBuffer = samples;

	double sampNew = 0.0, sampOld = 0.0, sampOlder = 0.0;
	int    PCM, S;

	uint offset = 0;
	while (offset < (uint)adpcmLength)
	{
		//Get Shift/Filter and flags
		byte ShiftAndFilter = adpcmBuffer[0];
		byte Flags          = adpcmBuffer[1];
		adpcmBuffer += 2;

		byte adpcmShift  = ShiftAndFilter & 0xF;
		byte adpcmFilter = (ShiftAndFilter >> 4) & 0xF;

		if (adpcmShift > 12)
			adpcmShift = 9;

		if (adpcmFilter > 4)
			adpcmFilter = 0;

		if (Flags == 0x7)
			break;

		for (int i = 0; i < 14; ++i)
		{
			int ADPCM = adpcmBuffer[i];

			//Convert Sample #1
			S = (ADPCM & 0xF) << 12;
			if (S & 0x8000)
				S |= 0xFFFF0000;
			sampNew = S >> adpcmShift;
			sampNew = sampNew + sampOld * adpcmFilterPN[adpcmFilter][0] + sampOlder * adpcmFilterPN[adpcmFilter][1];
			sampOlder = sampOld;
			sampOld   = sampNew;
			PCM = (short)(sampNew + 0.5);
			samples[0] = PCM;

			//Convert Sample #2
			S = (ADPCM & 0xF0) << 8;
			if (S & 0x8000)
				S |= 0xFFFF0000;
			sampNew = S >> adpcmShift;
			sampNew = sampNew + sampOld * adpcmFilterPN[adpcmFilter][0] + sampOlder * adpcmFilterPN[adpcmFilter][1];
			sampOlder = sampOld;
			sampOld = sampNew;
			PCM = (short)(sampNew + 0.5);
			samples[1] = PCM;
			
			//Move our pointers along
			samples += 2;
		}

		adpcmBuffer += 14;
		offset += 16;
	}

	return 1;
}


//
// Initialization
//
gmEx double InitD3D(LPDIRECT3DDEVICE9 dev, HWND window)
{
	if (d3dDev != NULL)
		return -1;

	d3dDev = dev;
	d3dDev->GetDirect3D(&d3d);

	gmWindow = window;
	return 0;
}

//
// Video Playback
//
#pragma region DShowVideo
gmEx double InitDShow()
{
	if (FAILED(CoInitialize(NULL)))
	{
		gmLog("Failed to Initialize the COM library");
		return -1;
	}
	return 0;
}
gmEx double FreeDShow()
{
	CoUninitialize();
	return 0;
}
gmEx double VideoLoad(cstring videoFile)
{
	DShowVideoPlayer* videoPlayer = new DShowVideoPlayer();

	if (!videoPlayer->LoadVideo(videoFile, gmWindow))
	{
		gmLog("Error loading video...");
		return 0;
	}

	return toDouble<DShowVideoPlayer>(videoPlayer);
}
gmEx double VideoPlay(double videoDbl)
{
	if (!toPointer<DShowVideoPlayer>(videoDbl)->PlayVideo())
	{
		gmLog("Error Playing Video");
		return 0;
	}

	return 1;
}

#pragma endregion

#pragma region Clipplane
gmEx double SetClipPlaneParam(double index, double xc, double yc, double zc, double wc)
{
	D3DXPLANE P = D3DXPLANE((float)xc, (float)yc, (float)zc, (float)wc);
	d3dDev->SetClipPlane((DWORD)index, &P.a);
	return 1;
}
gmEx double SetClipPlaneEnable(double index)
{
	d3dDev->SetRenderState(D3DRS_CLIPPLANEENABLE, (1 << (DWORD)index));
	return 1;
}
gmEx double SetClipPlaneDisable()
{
	d3dDev->SetRenderState(D3DRS_CLIPPLANEENABLE, 0);
	return 1;
}

#pragma endregion
#pragma region Render States
gmEx double SetCullMode(double mode)
{
	d3dDev->SetRenderState(D3DRS_CULLMODE, (DWORD)mode);
	return 0;
}
gmEx double SetTweenMode(double onOff)
{
	d3dDev->SetRenderState(D3DRS_VERTEXBLEND, ((int)onOff == 1) ? D3DVBF_TWEENING : D3DVBF_DISABLE);
	return 1;
}
gmEx double SetTweenFactor(double tween)
{
	float t = (float)tween;

	d3dDev->SetRenderState(D3DRS_TWEENFACTOR, *(DWORD*)&t);
	return 1;
}
gmEx double SetDepthFunc(double func)
{
	d3dDev->SetRenderState(D3DRS_ZFUNC, (D3DCMPFUNC)(int)func);
	return 1;
}
gmEx double ClearTarget()
{
	d3dDev->Clear(0, 0, D3DCLEAR_ZBUFFER | D3DCLEAR_TARGET, D3DCOLOR_RGBA(0, 0, 0, 1), 1.0f, 0);
	return 1;
}
#pragma endregion
#pragma region Texture
gmEx double TextureCreate(double width, double height, double format)
{
	LPDIRECT3DTEXTURE9 pTexture;
	d3dDev->CreateTexture((uint)width, (uint)height, 0, 0, (D3DFORMAT)format, D3DPOOL_DEFAULT, &pTexture, NULL);

	return toDouble<IDirect3DTexture9>(pTexture);
}
gmEx double TextureLoad(cstring filepath, double width, double height)
{
	//Texture Info
	LPDIRECT3DTEXTURE9 pTexture;
	D3DXCreateTextureFromFileExA(d3dDev, filepath, (uint)width, (uint)height, 4, 0, D3DFMT_FROM_FILE, D3DPOOL_DEFAULT, D3DX_DEFAULT, D3DX_DEFAULT, 0, NULL, NULL, &pTexture);

	return toDouble<IDirect3DTexture9>(pTexture);
}
gmEx double TextureFree(double texture)
{
	toPointer<IDirect3DTexture9>(texture)->Release();

	return 1;
}
gmEx double TextureSet(double sampler, double texture)
{
	d3dDev->SetTexture((int)sampler, toPointer<IDirect3DTexture9>(texture));
	return 1;
}
gmEx double TextureGetNumMipmap(double texture)
{
	return (double)toPointer<IDirect3DTexture9>(texture)->GetLevelCount();
}
#pragma endregion
#pragma region Sampler
gmEx double SamplerSetFilterMin(double sampler, double filter)
{
	d3dDev->SetSamplerState((int)sampler, D3DSAMP_MINFILTER, (D3DTEXTUREFILTERTYPE)(int)filter);
	return 1;
}
gmEx double SamplerSetFilterMag(double sampler, double filter)
{
	d3dDev->SetSamplerState((int)sampler, D3DSAMP_MAGFILTER, (D3DTEXTUREFILTERTYPE)(int)filter);
	return 1;
}
gmEx double SamplerSetFilterMip(double sampler, double filter)
{
	d3dDev->SetSamplerState((int)sampler, D3DSAMP_MIPFILTER, (D3DTEXTUREFILTERTYPE)(int)filter);
	return 1;
}
gmEx double SamplerSetAnisotropy(double sampler, double anisotropy)
{
	d3dDev->SetSamplerState((int)sampler, D3DSAMP_MAXANISOTROPY, (int)anisotropy);
	return 1;
}
gmEx double SamplerSetTileType(double sampler, double tileType)
{
	d3dDev->SetSamplerState((int)sampler, D3DSAMP_ADDRESSU, (D3DTEXTUREADDRESS)(int)tileType);
	d3dDev->SetSamplerState((int)sampler, D3DSAMP_ADDRESSV, (D3DTEXTUREADDRESS)(int)tileType);
	d3dDev->SetSamplerState((int)sampler, D3DSAMP_ADDRESSW, (D3DTEXTUREADDRESS)(int)tileType);
	return 1;
}
#pragma endregion
#pragma region Cubemap
LPDIRECT3DSURFACE9 pDBuffer = NULL, pZBuffer = NULL;
LPDIRECT3DSURFACE9 newDepth = NULL;

gmEx double CubeMapCreate(double resolution, double format)
{
	//Create Cubemap
	LPDIRECT3DCUBETEXTURE9 pCubeMap;

	if (FAILED(d3dDev->CreateCubeTexture((int)resolution, 1, D3DUSAGE_RENDERTARGET, (D3DFORMAT)(int)format, D3DPOOL_DEFAULT, &pCubeMap, NULL)))
	{
		DebugMsg("Failed to create CubeMap!");
		return 0;
	}

	if (newDepth != NULL)
		newDepth->Release();

	if (FAILED(d3dDev->CreateDepthStencilSurface((int)resolution, (int)resolution, D3DFMT_D24X8, D3DMULTISAMPLE_NONE, 0, true, &newDepth, NULL)))
	{
		DebugMsg("Couldn't create depth buffer :(");
		pCubeMap->Release();
		return 0;
	}

	return toDouble<IDirect3DCubeTexture9>(pCubeMap);
}
gmEx double CubeMapFree(double cubeMap)
{
	//Get Cube Map
	LPDIRECT3DCUBETEXTURE9 pCubeMap = toPointer<IDirect3DCubeTexture9>(cubeMap);

	//Release Cube Map
	pCubeMap->Release();

	return 1;
}
gmEx double CubeMapLoad(cstring filepath)
{
	LPDIRECT3DCUBETEXTURE9 cubeMap;

	//Attempt to load CubeMap
	if (FAILED(D3DXCreateCubeTextureFromFileA(d3dDev, filepath, &cubeMap)))
	{
		DebugMsg("Failed to load CubeMap");
		return 0;
	}

	return toDouble<IDirect3DCubeTexture9>(cubeMap);
}
gmEx double CubeMapSave(cstring filepath, double cubeMap)
{
	//Get CubeMap from double
	LPDIRECT3DCUBETEXTURE9 pCubeMap = toPointer<IDirect3DCubeTexture9>(cubeMap);

	//Attempt to save cube map
	if (FAILED(D3DXSaveTextureToFileA(filepath, D3DXIFF_DDS, pCubeMap, NULL)))
	{
		DebugMsg("Failed to save CubeMap");
		return 0;
	}

	return 1;
}
gmEx double CubeMapRenderBegin()
{
	//Store Display buffer
	d3dDev->GetRenderTarget(0, &pDBuffer);

	//Store Depth/Stencil buffer
	d3dDev->GetDepthStencilSurface(&pZBuffer);
	return 1;
}
gmEx double CubeMapRenderSetFace(double cubeMap, double face)
{
	//Get Cubemap
	LPDIRECT3DCUBETEXTURE9 pCubeMap = toPointer<IDirect3DCubeTexture9>(cubeMap);
	
	//Get Cubemap Face
	LPDIRECT3DSURFACE9 pCubeFace;

	if (FAILED(pCubeMap->GetCubeMapSurface((D3DCUBEMAP_FACES)(int)face, 0, &pCubeFace)))
	{
		DebugMsg("Failed to get CubeMap face...");
		return 0;
	}

	//Set Cubemap face as target
	d3dDev->SetDepthStencilSurface(newDepth);
	d3dDev->SetRenderTarget(0, pCubeFace);

	return 1;
}
gmEx double CubeMapRenderEnd()
{
	//Restore Display Buffer
	d3dDev->SetRenderTarget(0, pDBuffer);

	//Restore Depth/Stencil Buffer
	d3dDev->SetDepthStencilSurface(pZBuffer);

	return 1;
}
gmEx double CubeMapSet(double sampler, double cubeMap)
{
	//Set CubeMap as texture for the sampler stage
	d3dDev->SetTexture((int)sampler, toPointer<IDirect3DCubeTexture9>(cubeMap));

	return 1;
}
#pragma endregion
#pragma region Vertex Buffer
std::vector<D3DVERTEXELEMENT9> formatBuilder;

// Streams
gmEx double SetIndexBuffer(double indexBuffer)
{
	d3dDev->SetIndices(toPointer<IDirect3DIndexBuffer9>(indexBuffer));

	return 1;
}
gmEx double SetVertexStream(double streamNum, double vertexStream, double stride)
{
	d3dDev->SetStreamSource((int)streamNum, toPointer<IDirect3DVertexBuffer9>(vertexStream), 0, (int)stride);

	return 1;
}
gmEx double SetVertexFormat(double vertexFormat)
{
	d3dDev->SetVertexDeclaration(toPointer<IDirect3DVertexDeclaration9>(vertexFormat));

	return 1;
}

//Vertex Format
gmEx double VertexFormatAdd(double stream, double offset, double type, double method, double usage, double usageIndex)
{
	//Create Element
	D3DVERTEXELEMENT9 element;
		element.Stream = (WORD)stream;
		element.Offset = (WORD)offset;
		element.Type = (BYTE)type;
		element.Method = (BYTE)method;
		element.Usage = (BYTE)usage;
		element.UsageIndex = (BYTE)usageIndex;

	//Add Element to list
	formatBuilder.push_back(element);

	return 1;
}
gmEx double VertexFormatCreate()
{
	//Add DECLEND to vector
	formatBuilder.push_back(D3DDECL_END());

	//Build Format
	LPDIRECT3DVERTEXDECLARATION9 decl;

	//Create Vertex Declaration
	if (FAILED(d3dDev->CreateVertexDeclaration(formatBuilder.data(), &decl)))
	{
		DebugMsg("Failed to create Vertex Declaration");
		return 0;
	}

	//Clean Up
	formatBuilder.clear();

	return toDouble<IDirect3DVertexDeclaration9>(decl);
}
gmEx double VertexFormatFree(double vertexFormat)
{
	//Release the vertex format
	LPDIRECT3DVERTEXDECLARATION9 decl = toPointer<IDirect3DVertexDeclaration9>(vertexFormat);

	decl->Release();

	return 1;
}

//Index Buffer
gmEx double IndexBufferCreate(double size)
{
	//Create the index buffer
	LPDIRECT3DINDEXBUFFER9 indBuff;
	d3dDev->CreateIndexBuffer((int)size, D3DUSAGE_WRITEONLY, D3DFMT_INDEX16, D3DPOOL_DEFAULT, &indBuff, NULL);

	//Convert ptr and return to GM
	return toDouble<IDirect3DIndexBuffer9>(indBuff);
}
gmEx double IndexBufferFree(double indexBuffer)
{
	//Get Index Buffer
	LPDIRECT3DINDEXBUFFER9 indBuff = toPointer<IDirect3DIndexBuffer9>(indexBuffer);

	//Free Index Buffer
	indBuff->Release();

	return 1;
}
gmEx double IndexBufferFill(double indBuffer, void* srcBuffer, double length)
{
	//Get Index Buffer
	LPDIRECT3DINDEXBUFFER9 indBuff = toPointer<IDirect3DIndexBuffer9>(indBuffer);

	//Lock Index Buffer
	void* pIndices;

	indBuff->Lock(0, (int)length, &pIndices, 0);

	//Copy Data
	memcpy(pIndices, srcBuffer, (int)length);

	//Unlock Index Buffer
	indBuff->Unlock();

	return 1;
}

//Vertex Stream
gmEx double VertexStreamCreate(double size)
{
	LPDIRECT3DVERTEXBUFFER9 vBuff;

	if (FAILED(d3dDev->CreateVertexBuffer((int)size, 0, 0, D3DPOOL_DEFAULT, &vBuff, 0)))
	{
		DebugMsg("Failed to create VertexBuffer!!!");
		return 0;
	}

	return toDouble<IDirect3DVertexBuffer9>(vBuff);
}
gmEx double VertexStreamFree(double vertexStream)
{
	LPDIRECT3DVERTEXBUFFER9 vBuff = toPointer<IDirect3DVertexBuffer9>(vertexStream);

	vBuff->Release();

	return 1;
}
gmEx double VertexStreamFill(double vertexStream, byte* srcBuffer, double offset, double length)
{
	//Get Vertex Buffer
	LPDIRECT3DVERTEXBUFFER9 vBuff = toPointer<IDirect3DVertexBuffer9>(vertexStream);

	//Offset the buffer
	float* buffer = (float*)(srcBuffer + (uint)offset);

	//Lock Vertex Buffer
	void* pData;
	if (FAILED(vBuff->Lock(0, 0, &pData, 0)))
	{
		DebugMsg("Failed to Lock VertexBuffer!!!");
		return 0;
	}

	//Fill Vertex Buffer
	memcpy(pData, buffer, (int)length);

	//Unlock Vertex Buffer
	if (FAILED(vBuff->Unlock()))
	{
		DebugMsg("Failed to Unlock VertexBuffer!!!");
		return 0;
	}

	return 1;
}

//Drawing
gmEx double VertexSubmit(double primitiveType, double primitiveCount)
{
	d3dDev->DrawPrimitive((D3DPRIMITIVETYPE)(int)primitiveType, 0, (int)primitiveCount);
	return 1;
}
gmEx double IndexSubmit(double primitiveType, double vertexCount, double primitiveCount)
{
	d3dDev->DrawIndexedPrimitive((D3DPRIMITIVETYPE)(int)primitiveType, 0, 0, (int)vertexCount, 0, (int)primitiveCount);
	return 1;
}
#pragma endregion
#pragma region Particles
// System
gmEx double ParticleSystemCreate(double maxParticles)
{
	ParticleSystem* psPtr = new ParticleSystem(d3dDev, (int)maxParticles);

	return toDouble<ParticleSystem>(psPtr);
}
gmEx double ParticleSystemSetTexture(double psDbl, double textureDbl)
{
	toPointer<ParticleSystem>(psDbl)->SetTexture(toPointer<IDirect3DTexture9>(textureDbl));
	return 1;
}
gmEx double ParticleSystemAddEmitter(double psDbl, double peDbl)
{
	return (double) toPointer<ParticleSystem>(psDbl)->AddEmitter(toPointer<ParticleEmitter>(peDbl));
}
gmEx double ParticleSystemRemoveEmitter(double psDbl, double emitterIndex)
{
	toPointer<ParticleSystem>(psDbl)->RemoveEmitter((int)emitterIndex);
	return 1;
}
gmEx double ParticleSystemAddModifier(double psDbl, double pmDbl)
{
	return (double) toPointer<ParticleSystem>(psDbl)->AddModifier(toPointer<ParticleModifier>(pmDbl));
}
gmEx double ParticleSystemRemoveModifier(double psDbl, double modifierIndex)
{
	toPointer<ParticleSystem>(psDbl)->RemoveModifier((int)modifierIndex);
	return 1;
}
gmEx double ParticleSystemStep(double psDbl)
{
	toPointer<ParticleSystem>(psDbl)->Step();
	return 1;
}
gmEx double ParticleSystemDraw(double psDbl)
{
	toPointer<ParticleSystem>(psDbl)->Draw(d3dDev);
	return 1;
}
gmEx double ParticleSystemDestroy(double psDbl)
{
	ParticleSystem* psPtr = toPointer<ParticleSystem>(psDbl);
	delete psPtr;

	return 1;
}

// Emitter
gmEx double ParticleEmitterCreatePoint(double minEmitt, double maxEmitt)
{
	ParticleEmitter* pe = new ParticleEmitterPoint((int)minEmitt, (int)maxEmitt);

	return toDouble<ParticleEmitter>(pe);
}
gmEx double ParticleEmitterPointSetOrigin(double peDbl, double x, double y, double z)
{
	toPointer<ParticleEmitterPoint>(peDbl)->SetOrigin((float)x, (float)y, (float)z);
	return 1;
}
gmEx double ParticleEmitterCreateCylinder(double minEmitt, double maxEmitt)
{
	ParticleEmitter* pe = new ParticleEmitterCylinder((int)minEmitt, (int)maxEmitt);

	return toDouble<ParticleEmitter>(pe);
}
gmEx double ParticleEmitterCylinderSetOrigin(double peDbl, double x, double y, double z)
{
	toPointer<ParticleEmitterCylinder>(peDbl)->SetOrigin((float)x, (float)y, (float)z);
	return 1;
}
gmEx double ParticleEmitterCylinderSetParam(double peDbl, double r, double h)
{
	toPointer<ParticleEmitterCylinder>(peDbl)->SetParam((float)r, (float)h);
	return 1;
}
gmEx double ParticleEmitterCreateSphere(double minEmitt, double maxEmitt)
{
	ParticleEmitter* pe = new ParticleEmitterSphere((int)minEmitt, (int)maxEmitt);

	return toDouble<ParticleEmitter>(pe);
}
gmEx double ParticleEmitterSphereSetOrigin(double peDbl, double x, double y, double z)
{
	toPointer<ParticleEmitterSphere>(peDbl)->SetOrigin((float)x, (float)y, (float)z);
	return 1;
}
gmEx double ParticleEmitterSphereSetRadius(double peDbl, double r)
{
	toPointer<ParticleEmitterSphere>(peDbl)->SetRadius((float)r);
	return 1;
}
gmEx double ParticleEmitterSetMinMaxEmitt(double peDbl, double min, double max)
{
	toPointer<ParticleEmitter>(peDbl)->setMinMaxEmitt((int)min, (int)max);
	return 1;
}
gmEx double ParticleEmitterSetMinMaxLife(double peDbl, double min, double max)
{
	toPointer<ParticleEmitter>(peDbl)->setMinMaxLife((int)min, (int)max);
	return 1;
}
gmEx double ParticleEmitterSetMinMaxSize(double peDbl, double min, double max)
{
	toPointer<ParticleEmitter>(peDbl)->setMinMaxSize((float)min, (float)max);
	return 1;
}
gmEx double ParticleEmitterSetMinMaxVelocity(double peDbl, double minX, double minY, double minZ, double maxX, double maxY, double maxZ)
{
	toPointer<ParticleEmitter>(peDbl)->setMinMaxVelocity(
		D3DXVECTOR3((float)minX, (float)minY, (float)minZ),
		D3DXVECTOR3((float)maxX, (float)maxY, (float)maxZ));
	return 1;
}
gmEx double ParticleEmitterSetMinMaxColour(double peDbl, double minR, double minG, double minB, double minA, double maxR, double maxG, double maxB, double maxA)
{
	toPointer<ParticleEmitter>(peDbl)->setMinMaxColour(
		D3DXVECTOR4((float)minR, (float)minG, (float)minB, (float)minA),
		D3DXVECTOR4((float)maxR, (float)maxG, (float)maxB, (float)maxA));
	return 1;
}
gmEx double ParticleEmitterDestroy(double peDbl)
{
	ParticleEmitter* pePtr = toPointer<ParticleEmitter>(peDbl);
	delete pePtr;

	return 1;
}

// Modifier
gmEx double ParticleModifierCreateGrowth(double minAge, double maxAge, double growth)
{
	ParticleModifier* pm = new ParticleModifierGrowth((int)minAge, (int)maxAge, (float)growth);
	return toDouble<ParticleModifier>(pm);
}
gmEx double ParticleModifierCreateAcceleration(double acceleration)
{
	ParticleModifier* pm = new ParticleModifierAcceleration((float)acceleration);
	return toDouble<ParticleModifier>(pm);
}
gmEx double ParticleModifierDestroy(double pmDbl)
{
	ParticleModifier* pm = toPointer<ParticleModifier>(pmDbl);
	delete pm;

	return 1;
}

#pragma endregion
#pragma region Collision
// World
gmEx double BLTWorldCreate()
{
	myCollisionConfiguration = new btDefaultCollisionConfiguration();
	myCollisionDispatcher = new btCollisionDispatcher(myCollisionConfiguration);
	myCollisionBroadphase = new btDbvtBroadphase();
	myCollisionWorld = new btCollisionWorld(myCollisionDispatcher, myCollisionBroadphase, myCollisionConfiguration);
	myCollisionDebug = new BulletDebug();

	myCollisionWorld->setDebugDrawer(myCollisionDebug);

	return 1;
}
gmEx double BLTWorldDestroy()
{
	delete myCollisionWorld;
	delete myCollisionBroadphase;
	delete myCollisionDispatcher;
	delete myCollisionConfiguration;

	delete myCollisionDebug;

	myCollisionWorld = nullptr;

	return 1;
}
gmEx double BLTWorldExists()
{
	return myCollisionWorld != nullptr ? 1 : 0;
}
gmEx double BLTWorldAddBody(double bodyDbl, double group, double mask)
{
	btCollisionObject* objectPtr = toPointer<btCollisionObject>(bodyDbl);

	myCollisionWorld->addCollisionObject(objectPtr, (int)group, (int)mask);

	return 1;
}
gmEx double BLTWorldRemoveBody(double bodyDbl)
{
	btCollisionObject* objectPtr = toPointer<btCollisionObject>(bodyDbl);

	myCollisionWorld->removeCollisionObject(objectPtr);

	return 1;
}
gmEx double BLTWorldDebugDraw(double update)
{
	if (update > 0.5)
	{
		myCollisionDebug->debugUpdatePrepare();
		myCollisionWorld->debugDrawWorld();
	}

	myCollisionDebug->debugDraw(d3dDev);

	return 1;
}
gmEx double BLTWorldRaycast(double xf, double yf, double zf, double xt, double yt, double zt, double group, double mask)
{
	btVector3 start = btVector3((btScalar)xf, (btScalar)yf, (btScalar)zf);
	btVector3 end   = btVector3((btScalar)xt, (btScalar)yt, (btScalar)zt);

	btCollisionWorld::ClosestRayResultCallback rayCallback(start, end);
	rayCallback.m_collisionFilterGroup = (int)group;
	rayCallback.m_collisionFilterMask  = (int)mask;

	myCollisionWorld->rayTest(start, end, rayCallback);

	if (rayCallback.hasHit())
	{
		myRayResult.hitPosition = rayCallback.m_hitPointWorld;
		myRayResult.hitNormal   = rayCallback.m_hitNormalWorld;
		myRayResult.hitIndex    = rayCallback.m_collisionObject->getUserIndex();
		return 1;
	}

	return 0;
}
gmEx double BLTWorldOverlap(double x, double y, double z, double rx, double ry, double rz, double group, double mask, double objectDbl)
{
	btCollisionObject* objectPtr = toPointer<btCollisionObject>(objectDbl);

	//Store old transform
	btTransform oldTransform = objectPtr->getWorldTransform();

	//Make new transform
	btTransform transform;
	transform.setOrigin(btVector3((btScalar)x, (btScalar)y, (btScalar)z));
	transform.setRotation(btQuaternion((btScalar)rx, (btScalar)ry, (btScalar)rz));

	//Set object transform to new transform
	objectPtr->setWorldTransform(transform);

	//Do overlap test
	BulletOverlapCallback overlapCallback(objectPtr);
	overlapCallback.m_collisionFilterGroup = (int)group;
	overlapCallback.m_collisionFilterMask = (int)mask;

	myCollisionWorld->contactTest(objectPtr, overlapCallback);

	//restore objects prior transform
	objectPtr->setWorldTransform(oldTransform);

	if (overlapCallback.hasHit)
	{
		return 1;
	}
	return 0;
}

// Hit
gmEx double BLTRayHitX()
{
	return (double) myRayResult.hitPosition.x();
}
gmEx double BLTRayHitY()
{
	return (double) myRayResult.hitPosition.y();
}
gmEx double BLTRayHitZ()
{
	return (double) myRayResult.hitPosition.z();
}
gmEx double BLTRayHitNX()
{
	return (double) myRayResult.hitNormal.x();
}
gmEx double BLTRayHitNY()
{
	return (double) myRayResult.hitNormal.y();
}
gmEx double BLTRayHitNZ()
{
	return (double) myRayResult.hitNormal.z();
}
gmEx double BLTRayHitID() {
	return (double)myRayResult.hitIndex;
}

// Shape
gmEx double BLTShapeCreateBox(double HX, double HY, double HZ)
{
	btCollisionShape* shapePtr = new btBoxShape(btVector3((btScalar)HX, (btScalar)HY, (btScalar)HZ));

	return toDouble<btCollisionShape>(shapePtr);
}
gmEx double BLTShapeCreateSphere(double R)
{
	btCollisionShape* shapePtr = new btSphereShape((btScalar)R);

	return toDouble<btCollisionShape>(shapePtr);
}
gmEx double BLTShapeCreateCylinderX(double R, double H)
{
	btCollisionShape* shapePtr = new btCylinderShapeX(btVector3((btScalar)H, (btScalar)R, (btScalar)R));
	shapePtr->setUserPointer(nullptr);
	return toDouble<btCollisionShape>(shapePtr);
}
gmEx double BLTShapeCreateCylinderY(double R, double H)
{
	btCollisionShape* shapePtr = new btCylinderShape(btVector3((btScalar)R, (btScalar)H, (btScalar)R));
	shapePtr->setUserPointer(nullptr);
	return toDouble<btCollisionShape>(shapePtr);
}
gmEx double BLTShapeCreateCylinderZ(double R, double H)
{
	btCollisionShape* shapePtr = new btCylinderShapeZ(btVector3((btScalar)H, (btScalar)R, (btScalar)R));
	shapePtr->setUserPointer(nullptr);

	return toDouble<btCollisionShape>(shapePtr);
}
gmEx double BLTShapeCreateTrimeshEzee(ubyte* srcBuffer, double offset, double vertexStride, double numTri)
{
	btTriangleMesh* trimesh = new btTriangleMesh(true, false);

	//We pass our buffer as bytes so we can do this horrible pointer math.
	float* buffer = (float*)(srcBuffer + (uint)offset);

	//Reserve a number of triangles
	trimesh->preallocateVertices(((int)numTri) * 3);

	//Loop through and add our buffer data...
	int triPos, vertPos;

	btVector3* V = new btVector3[3];

	for (int i = 0; i < numTri; ++i)
	{
		triPos = (int)(vertexStride * 3) * i;

		for (int j = 0; j < 3; ++j)
		{
			vertPos = triPos + ((int)vertexStride * j);

			V[j] = btVector3(buffer[vertPos + 0], buffer[vertPos + 1], buffer[vertPos + 2]);
		}

		trimesh->addTriangle(V[0], V[1], V[2], false);
	}

	delete[] V;

	//Create the collision shape from our trimesh
	btCollisionShape* shapePtr = new btBvhTriangleMeshShape(trimesh, true, true);

	shapePtr->setUserPointer((void*)trimesh);

	return toDouble<btCollisionShape>(shapePtr);
}
gmEx double BLTShapeCreateFromTrimesh(double trimesh)
{
	btCollisionShape* shapePtr = new btBvhTriangleMeshShape(toPointer<BulletCollisionMesh>(trimesh), true, true);
	return toDouble<btCollisionShape>(shapePtr);
}
gmEx double BLTShapeDestroy(double shapeDbl)
{
	btCollisionShape* shapePtr = toPointer<btCollisionShape>(shapeDbl);

	if (shapePtr->getUserPointer() != nullptr)
		delete (btTriangleMesh*)shapePtr->getUserPointer();

	delete shapePtr;

	return 1;
}

// Trimesh Shape
gmEx double BLTTrimeshCreate(double numIndex, double numVertex)
{
	BulletCollisionMesh* cMeshPtr = new BulletCollisionMesh((uint)numIndex, (uint)numVertex);
	return toDouble<BulletCollisionMesh>(cMeshPtr);
}
gmEx double BLTTrimeshAddIndices(double bcmPtr, ubyte* srcBuffer, double offset)
{
	toPointer<BulletCollisionMesh>(bcmPtr)->setIndices(srcBuffer, (ulong)offset);
	return true;
}
gmEx double BLTTrimeshAddVertices(double bcmPtr, ubyte* srcBuffer, double offset)
{
	toPointer<BulletCollisionMesh>(bcmPtr)->setVertices(srcBuffer, (ulong)offset);
	return true;
}
gmEx double BLTTrimeshDestroy(double bcmPtr)
{
	delete toPointer<BulletCollisionMesh>(bcmPtr);
	return true;
}

// Compound Shape
gmEx double BLTCompoundShapeCreate()
{
	btCompoundShape* shapePtr = new btCompoundShape(true);
	return toDouble<btCompoundShape>(shapePtr);
}
gmEx double BLTCompoundShapeAddChild(double parentDbl, double childDbl, double x, double y, double z, double rx, double ry, double rz)
{
	btCompoundShape* shapePtr = toPointer<btCompoundShape>(parentDbl);

	//Build Child Transformation
	btTransform transform;
	transform.setOrigin(btVector3((btScalar)x, (btScalar)y, (btScalar)z));
	transform.setRotation(btQuaternion((btScalar)rx, (btScalar)ry, (btScalar)rz));

	shapePtr->addChildShape(transform, toPointer<btCollisionShape>(childDbl));
	shapePtr->createAabbTreeFromChildren();
	return (double)shapePtr->getNumChildShapes() - 1;
}
gmEx double BLTCompoundShapeRemoveChild(double parentDbl, double childIndex)
{
	toPointer<btCompoundShape>(parentDbl)->removeChildShapeByIndex((int)childIndex);
	return 0;
}
gmEx double BLTCompoundShapeTransformChild(double parentDbl, double childIndex, double x, double y, double z, double rx, double ry, double rz)
{
	btCompoundShape* shapePtr = toPointer<btCompoundShape>(parentDbl);

	btTransform transform;
	transform.setOrigin(btVector3((btScalar)x, (btScalar)y, (btScalar)z));
	transform.setRotation(btQuaternion((btScalar)rx, (btScalar)ry, (btScalar)rz));

	shapePtr->updateChildTransform((int)childIndex, transform);

	return 0;
}
gmEx double BLTCompoundShapeDestroy(double shapeDbl)
{
	btCompoundShape* shapePtr = toPointer<btCompoundShape>(shapeDbl);

	for (int i = 0; i < shapePtr->getNumChildShapes(); ++i)
	{
		delete shapePtr->getChildShape(i);
	}
	delete shapePtr;

	return 0;
}

// Body (Object? I'll still call them a body though)
gmEx double BLTBodyCreate(double shapeDbl)
{
	btCollisionShape* shapePtr = toPointer<btCollisionShape>(shapeDbl);
	btCollisionObject* objectPtr = new btCollisionObject();

	objectPtr->setCollisionShape(shapePtr);
	objectPtr->setUserIndex(0);
	objectPtr->setWorldTransform(btTransform::getIdentity());
	
	return toDouble<btCollisionObject>(objectPtr);
}
gmEx double BLTBodyDestroy(double bodyDbl)
{
	btCollisionObject* objectPtr = toPointer<btCollisionObject>(bodyDbl);

	delete objectPtr;

	return 1;
}
gmEx double BLTBodySetTranslation(double bodyDbl, double x, double y, double z)
{
	btCollisionObject* objectPtr = toPointer<btCollisionObject>(bodyDbl);

	btTransform transform = objectPtr->getWorldTransform();
	transform.setOrigin(btVector3((btScalar)x, (btScalar)y, (btScalar)z));

	objectPtr->setWorldTransform(transform);

	myCollisionWorld->updateAabbs();

	return 1;
}
gmEx double BLTBodySetRotation(double bodyDbl, double x, double y, double z)
{
	btCollisionObject* objectPtr = toPointer<btCollisionObject>(bodyDbl);

	btTransform transform = objectPtr->getWorldTransform();
	transform.setRotation(btQuaternion((btScalar)x, (btScalar)y, (btScalar)z));

	objectPtr->setWorldTransform(transform);

	myCollisionWorld->updateAabbs();

	return 1;
}
gmEx double BLTBodySetUserID(double bodyDbl, double userID)
{
	btCollisionObject* objectPtr = toPointer<btCollisionObject>(bodyDbl);
	objectPtr->setUserIndex((int)userID);

	return 1;
}
#pragma endregion

BOOL WINAPI DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved) 
{
	switch (fdwReason) 
	{
	case DLL_PROCESS_ATTACH:
		gmLog("DEXterity now attatched to executable...");
		break;

	case DLL_PROCESS_DETACH:
		gmLog("DEXterity now detatched from executable...");
		break;
	}

	return 1;
}