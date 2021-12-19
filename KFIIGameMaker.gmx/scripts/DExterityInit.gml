///DExterityInit();

var dll = "DExterity.dll";

//
// ENUMS
//
enum SamplerFilter
{
    None = 0,
    Point = 1,
    Linear = 2,
    Anisotropic = 3,
    PyramidalQuad = 4,
    GaussianQuad = 5
}

enum SamplerTile {
    Wrap = 1,
    Mirror = 2,
    Clamp = 3,
    Border = 4,
    MirrorOnce = 5
}

//
// Temporary Sshit
//
global.dexDecodeADPCM = external_define(dll, "DecodeADPCM", dll_cdecl, ty_real, 4, ty_string, ty_real, ty_real, ty_string);

//
// DEFINES
//

global.dexInitD3D   = external_define(dll, "InitD3D", dll_cdecl, ty_real, 2, ty_string, ty_string);

// Video
global.dexInitDShow = external_define(dll, "InitDShow", dll_cdecl, ty_real, 0);
global.dexFreeDShow = external_define(dll, "FreeDShow", dll_cdecl, ty_real, 0);
global.dexVideoLoad = external_define(dll, "VideoLoad", dll_cdecl, ty_real, 1, ty_string);
global.dexVideoPlay = external_define(dll, "VideoPlay", dll_cdecl, ty_real, 1, ty_real);

// Render State
global.dexSetCullMode = external_define(dll, "SetCullMode", dll_cdecl, ty_real, 1, ty_real);
global.dexSetZFunc = external_define(dll, "SetDepthFunc", dll_cdecl, ty_real, 1, ty_real);
global.dexClearTarget = external_define(dll, "ClearTarget", dll_cdecl, ty_real, 0);

// Clipping
global.dexSetClipPlane = external_define(dll, "SetClipPlaneParam", dll_cdecl, ty_real, 5, ty_real, ty_real, ty_real, ty_real, ty_real);
global.dexSetClipPlaneEnabled = external_define(dll, "SetClipPlaneEnable", dll_cdecl, ty_real, 1, ty_real);
global.dexSetClipPlaneDisable = external_define(dll, "SetClipPlaneDisable", dll_cdecl, ty_real, 0);

// Texture
global.dexTextureLoad = external_define(dll, "TextureLoad", dll_cdecl, ty_real, 3, ty_string, ty_real, ty_real);
global.dexTextureFree = external_define(dll, "TextureFree", dll_cdecl, ty_real, 1, ty_real);
global.dexTextureSet  = external_define(dll, "TextureSet",  dll_cdecl, ty_real, 2, ty_real, ty_real);
global.dexTextureNumLevel = external_define(dll, "TextureGetNumMipmap", dll_cdecl, ty_real, 1, ty_real);

// Sampler
global.dexSamplerSetMinF = external_define(dll, "SamplerSetFilterMin", dll_cdecl, ty_real, 2, ty_real, ty_real);
global.dexSamplerSetMagF = external_define(dll, "SamplerSetFilterMag", dll_cdecl, ty_real, 2, ty_real, ty_real);
global.dexSamplerSetMipF = external_define(dll, "SamplerSetFilterMip", dll_cdecl, ty_real, 2, ty_real, ty_real);
global.dexSamplerSetAnisotropy = external_define(dll, "SamplerSetAnisotropy", dll_cdecl, ty_real, 2, ty_real, ty_real);
global.dexSamplerSetTiling = external_define(dll, "SamplerSetTileType", dll_cdecl, ty_real, 2, ty_real, ty_real);

// Cube Map
global.dexCubemapCreate        = external_define(dll, "CubeMapCreate", dll_cdecl, ty_real, 2, ty_real, ty_real);
global.dexCubemapFree          = external_define(dll, "CubeMapFree",   dll_cdecl, ty_real, 1, ty_real);
global.dexCubemapLoad          = external_define(dll, "CubeMapLoad",   dll_cdecl, ty_real, 1, ty_string);
global.dexCubemapSave          = external_define(dll, "CubeMapSave",   dll_cdecl, ty_real, 2, ty_string, ty_real);
global.dexCubemapRenderBegin   = external_define(dll, "CubeMapRenderBegin", dll_cdecl, ty_real, 0);
global.dexCubemapRenderSetFace = external_define(dll, "CubeMapRenderSetFace", dll_cdecl, ty_real, 2, ty_real, ty_real);
global.dexCubemapRenderEnd     = external_define(dll, "CubeMapRenderEnd", dll_cdecl, ty_real, 0);
global.dexCubemapSet           = external_define(dll, "CubeMapSet", dll_cdecl, ty_real, 2, ty_real, ty_real);

//Vertex Global
global.dexSetVertexFormat = external_define(dll, "SetVertexFormat", dll_cdecl, ty_real, 1, ty_real);
global.dexSetVertexStream = external_define(dll, "SetVertexStream", dll_cdecl, ty_real, 3, ty_real, ty_real, ty_real);
global.dexVertexSubmit = external_define(dll, "VertexSubmit", dll_cdecl, ty_real, 2, ty_real, ty_real);

//Vertex Format
global.dexVertexFormatAdd = external_define(dll, "VertexFormatAdd", dll_cdecl, ty_real, 6, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real);
global.dexVertexFormatCreate = external_define(dll, "VertexFormatCreate", dll_cdecl, ty_real, 0);
global.dexVertexFormatFree = external_define(dll, "VertexFormatFree", dll_cdecl, ty_real, 1, ty_real);

//Vertex Stream
global.dexVertexStreamCreate = external_define(dll, "VertexStreamCreate", dll_cdecl, ty_real, 1, ty_real);
global.dexVertexStreamFree = external_define(dll, "VertexStreamFree", dll_cdecl, ty_real, 1, ty_real);
global.dexVertexStreamFill = external_define(dll, "VertexStreamFill", dll_cdecl, ty_real, 4, ty_real, ty_string, ty_real, ty_real);
//
// Particles
//

// System
global.dexPartSCreate         = external_define(dll, "ParticleSystemCreate", dll_cdecl, ty_real, 1, ty_real);
global.dexPartSSetTexture     = external_define(dll, "ParticleSystemSetTexture", dll_cdecl, ty_real, 2, ty_real, ty_real);
global.dexPartSAddEmitter     = external_define(dll, "ParticleSystemAddEmitter", dll_cdecl, ty_real, 2, ty_real, ty_real);
global.dexPartSRemoveEmitter  = external_define(dll, "ParticleSystemRemoveEmitter", dll_cdecl, ty_real, 2, ty_real, ty_real);
global.dexPartSAddModifier    = external_define(dll, "ParticleSystemAddModifier", dll_cdecl, ty_real, 2, ty_real, ty_real);
global.dexPartSRemoveModifier = external_define(dll, "ParticleSystemRemoveModifier", dll_cdecl, ty_real, 2, ty_real, ty_real);
global.dexPartSStep           = external_define(dll, "ParticleSystemStep", dll_cdecl, ty_real, 1, ty_real);
global.dexPartSDraw           = external_define(dll, "ParticleSystemDraw", dll_cdecl, ty_real, 1, ty_real);
global.dexPartSDestroy        = external_define(dll, "ParticleSystemDestroy", dll_cdecl, ty_real, 1, ty_real);

// Emitter
global.dexPartECreatePoint       = external_define(dll, "ParticleEmitterCreatePoint", dll_cdecl, ty_real, 2, ty_real, ty_real);
global.dexPartEPointSetOrigin    = external_define(dll, "ParticleEmitterPointSetOrigin", dll_cdecl, ty_real, 4, ty_real, ty_real, ty_real, ty_real);
global.dexPartECylinderCreate    = external_define(dll, "ParticleEmitterCreateCylinder", dll_cdecl, ty_real, 2, ty_real, ty_real);
global.dexPartECylinderSetOrigin = external_define(dll, "ParticleEmitterCylinderSetOrigin", dll_cdecl, ty_real, 4, ty_real, ty_real, ty_real, ty_real);
global.dexPartECylinderSetParam  = external_define(dll, "ParticleEmitterCylinderSetParam", dll_cdecl, ty_real, 3, ty_real, ty_real, ty_real);
global.dexPartESphereCreate    = external_define(dll, "ParticleEmitterCreateSphere", dll_cdecl, ty_real, 2, ty_real, ty_real);
global.dexPartESphereSetOrigin = external_define(dll, "ParticleEmitterSphereSetOrigin", dll_cdecl, ty_real, 4, ty_real, ty_real, ty_real, ty_real);
global.dexPartESphereSetRadius = external_define(dll, "ParticleEmitterSphereSetRadius", dll_cdecl, ty_real, 2, ty_real, ty_real);
global.dexPartESetMinMaxEmitt    = external_define(dll, "ParticleEmitterSetMinMaxEmitt", dll_cdecl, ty_real, 3, ty_real, ty_real, ty_real);
global.dexPartESetMinMaxLife     = external_define(dll, "ParticleEmitterSetMinMaxLife", dll_cdecl, ty_real, 3, ty_real, ty_real, ty_real);
global.dexPartESetMinMaxSize     = external_define(dll, "ParticleEmitterSetMinMaxSize", dll_cdecl, ty_real, 3, ty_real, ty_real, ty_real);
global.dexPartESetMinMaxVelocity = external_define(dll, "ParticleEmitterSetMinMaxVelocity", dll_cdecl, ty_real, 7, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real);
global.dexPartESetMinMaxColour   = external_define(dll, "ParticleEmitterSetMinMaxColour", dll_cdecl, ty_real, 9, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real);
global.dexPartEDestroy           = external_define(dll, "ParticleEmitterDestroy", dll_cdecl, ty_real, 1, ty_real);

// Modifier
global.dexPartMCreateAcceleration = external_define(dll, "ParticleModifierCreateAcceleration", dll_cdecl, ty_real, 1, ty_real);
global.dexPartMCreateGrowth       = external_define(dll, "ParticleModifierCreateGrowth", dll_cdecl, ty_real, 3, ty_real, ty_real, ty_real);
global.dexPartMDestroy            = external_define(dll, "ParticleModifierDestroy", dll_cdecl, ty_real, 1, ty_real);


//
// Collisions
//

// World
global.dexCWorldCreate     = external_define(dll, "BLTWorldCreate", dll_cdecl, ty_real, 0);
global.dexCWorldDestroy    = external_define(dll, "BLTWorldDestroy", dll_cdecl, ty_real, 0);
global.dexCWorldExists     = external_define(dll, "BLTWorldExists", dll_cdecl, ty_real, 0);
global.dexCWorldAddBody    = external_define(dll, "BLTWorldAddBody", dll_cdecl, ty_real, 3, ty_real, ty_real, ty_real);
global.dexCWorldRemoveBody = external_define(dll, "BLTWorldRemoveBody", dll_cdecl, ty_real, 1, ty_real);
global.dexCWorldDebugDraw  = external_define(dll, "BLTWorldDebugDraw", dll_cdecl, ty_real, 1, ty_real);
global.dexCWorldRaycast    = external_define(dll, "BLTWorldRaycast", dll_cdecl, ty_real, 8, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real);
global.dexCWorldOverlap    = external_define(dll, "BLTWorldOverlap", dll_cdecl, ty_real, 9, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real);

// Result
global.dexCHitX  = external_define(dll, "BLTRayHitX", dll_cdecl, ty_real, 0);
global.dexCHitY  = external_define(dll, "BLTRayHitY", dll_cdecl, ty_real, 0);
global.dexCHitZ  = external_define(dll, "BLTRayHitZ", dll_cdecl, ty_real, 0);
global.dexCHitNX = external_define(dll, "BLTRayHitNX", dll_cdecl, ty_real, 0);
global.dexCHitNY = external_define(dll, "BLTRayHitNY", dll_cdecl, ty_real, 0);
global.dexCHitNZ = external_define(dll, "BLTRayHitNZ", dll_cdecl, ty_real, 0);
global.dexCHitID = external_define(dll, "BLTRayHitID", dll_cdecl, ty_real, 0);

// Shape
global.dexCShapeCreateBox       = external_define(dll, "BLTShapeCreateBox", dll_cdecl, ty_real, 3, ty_real, ty_real, ty_real);
global.dexCShapeCreateCylinderX = external_define(dll, "BLTShapeCreateCylinderX", dll_cdecl, ty_real, 2, ty_real, ty_real);
global.dexCShapeCreateCylinderY = external_define(dll, "BLTShapeCreateCylinderY", dll_cdecl, ty_real, 2, ty_real, ty_real);
global.dexCShapeCreateCylinderZ = external_define(dll, "BLTShapeCreateCylinderZ", dll_cdecl, ty_real, 2, ty_real, ty_real);
global.dexCShapeCreateTrimesh   = external_define(dll, "BLTShapeCreateTrimeshEzee", dll_cdecl, ty_real, 4, ty_string, ty_real, ty_real, ty_real);
global.dexCShapeDestroy         = external_define(dll, "BLTShapeDestroy", dll_cdecl, ty_real, 1, ty_real);
global.dexCShapeCreateFromTrimesh = external_define(dll, "BLTShapeCreateFromTrimesh", dll_cdecl, ty_real, 1, ty_real);

// Trimesh
global.dexCTrimeshCreate      = external_define(dll, "BLTTrimeshCreate", dll_cdecl, ty_real, 2, ty_real, ty_real);
global.dexCTrimeshAddIndices  = external_define(dll, "BLTTrimeshAddIndices", dll_cdecl, ty_real, 3, ty_real, ty_string, ty_real);
global.dexCTrimeshAddVertices = external_define(dll, "BLTTrimeshAddVertices", dll_cdecl, ty_real, 3, ty_real, ty_string, ty_real);
global.dexCTrimeshDestroy     = external_define(dll, "BLTTrimeshDestroy", dll_cdecl, ty_real, 1, ty_real);

// Compound Shape
global.dexCCompoundCreate   = external_define(dll, "BLTCompoundShapeCreate", dll_cdecl, ty_real, 0);
global.dexCCompoundAddChild = external_define(dll, "BLTCompoundShapeAddChild", dll_cdecl, ty_real, 8, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real);
global.dexCCompoundTransformChild = external_define(dll, "BLTCompoundShapeTransformChild", dll_cdecl, ty_real, 8, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real);
global.dexCCompoundDestroy = external_define(dll, "BLTCompoundShapeDestroy", dll_cdecl, ty_real, 1, ty_real);

// Body
global.dexCBodyCreate         = external_define(dll, "BLTBodyCreate", dll_cdecl, ty_real, 1, ty_real);
global.dexCBodyDestroy        = external_define(dll, "BLTBodyDestroy", dll_cdecl, ty_real, 1, ty_real);
global.dexCBodySetTranslation = external_define(dll, "BLTBodySetTranslation", dll_cdecl, ty_real, 4, ty_real, ty_real, ty_real, ty_real);
global.dexCBodySetRotation    = external_define(dll, "BLTBodySetRotation", dll_cdecl, ty_real, 4, ty_real, ty_real, ty_real, ty_real);
global.dexCBodySetUserID      = external_define(dll, "BLTBodySetUserID", dll_cdecl, ty_real, 2, ty_real, ty_real);

external_call(global.dexInitDShow);
return external_call(global.dexInitD3D, window_device(), window_handle());

