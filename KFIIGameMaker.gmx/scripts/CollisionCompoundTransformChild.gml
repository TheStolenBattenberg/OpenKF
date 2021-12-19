///CollisionCompoundTransformChild(parent, child, x, y, z, rx, ry, rz);
gml_pragma("forceinline");

return external_call(global.dexCCompoundTransformChild, argument0, argument1, argument2, argument3, argument4, degtorad(argument5), degtorad(argument6), degtorad(argument7));
