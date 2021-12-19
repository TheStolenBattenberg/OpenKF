///SetZFunc(ZFunc)
gml_pragma("forceinline");

enum ZFunc {
    Never           = 1,
    Less            = 2,
    Equal           = 3,
    LessEqual       = 4,
    Greater         = 5,
    NotEqual        = 6,
    GreaterEqual    = 7,
    Always          = 8
}

return external_call(global.dexSetZFunc, argument0);
