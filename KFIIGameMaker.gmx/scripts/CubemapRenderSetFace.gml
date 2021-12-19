///CubemapRenderSetFace(cubemap, face);
gml_pragma("forceinline");

enum CubemapFace {
    XPos = 0,
    XNeg = 1,
    YPos = 2,
    YNeg = 3,
    ZPos = 4,
    ZNeg = 5
}
return external_call(global.dexCubemapRenderSetFace, argument0, argument1);
