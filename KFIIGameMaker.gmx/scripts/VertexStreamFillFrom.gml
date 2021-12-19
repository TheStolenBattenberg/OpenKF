///VertexStreamFillFrom(vertexStream, buffer, offset, length);
gml_pragma("forceinline");

return external_call(global.dexVertexStreamFill, argument0, buffer_get_address(argument1), argument2, argument3);
