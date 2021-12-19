///SetCullMode(CullMode)

enum CullMode {
    None  = 1,
    Back  = 2,
    Front = 3,
}

return external_call(global.dexSetCullMode, argument0);
