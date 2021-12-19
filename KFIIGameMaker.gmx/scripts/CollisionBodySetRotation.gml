///CollisionBodySetRotation(body, x, y, z);
gml_pragma("forceinline");

return external_call(global.dexCBodySetRotation, argument0, degtorad(argument2), degtorad(argument1), degtorad(argument3));
