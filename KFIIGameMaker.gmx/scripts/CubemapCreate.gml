///CubemapCreate(format, resolution);
gml_pragma("forceinline");

enum CubemapFormat 
{
    RGBA32  = 21,
    F16     = 111,
    F32     = 114   
}

return external_call(global.dexCubemapCreate, argument1, argument0);
