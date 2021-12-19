///BufferWritePlaneYX(buffer, x, y, z, hsY, hsX);
gml_pragma("forceinline");

BufferWriteVertex(argument0, argument1-argument5, argument2-argument4, argument3);
BufferWriteVertex(argument0, argument1+argument5, argument2-argument4, argument3);
BufferWriteVertex(argument0, argument1-argument5, argument2+argument4, argument3);
BufferWriteVertex(argument0, argument1+argument5, argument2-argument4, argument3);
BufferWriteVertex(argument0, argument1-argument5, argument2+argument4, argument3);
BufferWriteVertex(argument0, argument1+argument5, argument2+argument4, argument3);
