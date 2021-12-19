///CollisionShapeCreateTrimeshOffset(buffer, bufferOffset, vertStride, nTris);
gml_pragma("forceinline");

return external_call(global.dexCShapeCreateTrimesh, buffer_get_address(argument0), argument1, argument2, argument3);
