///BufferWritePlaneYZ(buffer, x, y, z, hsY, hsZ);
gml_pragma("forceinline");

BufferWriteVertex(argument0, argument1, argument2-argument4, argument3-argument5);
BufferWriteVertex(argument0, argument1, argument2-argument4, argument3+argument5);
BufferWriteVertex(argument0, argument1, argument2+argument4, argument3-argument5);
BufferWriteVertex(argument0, argument1, argument2-argument4, argument3+argument5);
BufferWriteVertex(argument0, argument1, argument2+argument4, argument3-argument5);
BufferWriteVertex(argument0, argument1, argument2+argument4, argument3+argument5);
