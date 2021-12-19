///CollisionWorldCreate();
gml_pragma("forceinline");

enum CMask {
    None    = $0,
    Player  = $1,
    Static  = $2,
    Object  = $4,
    Item    = $8,
    All     = $FFFF
}


return external_call(global.dexCWorldCreate);
