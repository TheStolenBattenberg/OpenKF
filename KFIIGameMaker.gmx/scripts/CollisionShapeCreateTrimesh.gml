///CollisionShapeCreateTrimesh(buffer, vertStride, nTris);
gml_pragma("forceinline");

return external_call(global.dexCShapeCreateTrimesh, buffer_get_address(argument0), 0, argument1, argument2);
