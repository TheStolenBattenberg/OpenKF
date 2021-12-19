///VertexStreamFill(vertexStream, buffer);
gml_pragma("forceinline");

return external_call(global.dexVertexStreamFill, argument0, buffer_get_address(argument1), 0, buffer_get_size(argument1));
