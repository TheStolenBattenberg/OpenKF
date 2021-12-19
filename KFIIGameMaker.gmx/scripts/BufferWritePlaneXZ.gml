///BufferWritePlaneXZ(buffer, x, y, z, hsX, hsZ);
gml_pragma("forceinline");
BufferWriteVertex(argument0,  argument1-argument4, argument2, argument3-argument5);
BufferWriteVertex(argument0,  argument1-argument4, argument2, argument3+argument5);
BufferWriteVertex(argument0,  argument1+argument4, argument2, argument3-argument5);
BufferWriteVertex(argument0,  argument1-argument4, argument2, argument3+argument5);
BufferWriteVertex(argument0,  argument1+argument4, argument2, argument3-argument5);
BufferWriteVertex(argument0,  argument1+argument4, argument2, argument3+argument5);
