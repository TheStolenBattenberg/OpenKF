///MODecompressMorphTarget(buffer, offset, lastMT);

//Morph Targets in KFII are compressed, by only storing vertices that have changed
//between frames, and copying from the previous frame (or vertices of the TMD) if no previous
//frame exists.

//Seek to offset of MT
buffer_seek(argument0, buffer_seek_start, argument1);

//Start reading MT data
var packetCount = buffer_read(argument0, buffer_u16);

var vertexNum   = 0;
var morphTarget = array_create(array_length_1d(argument2)); 

do {
    //VX is either position X, or the packet ID for copying vertices from the last frame.
    var VX = buffer_read(argument0, buffer_s16);
    
    
    //FromSoft assume that a vertex will never have an X of this size.
    if((VX == -32768))
    {
        //Packet Type 1:
        //  Copy Vertices from last MT.
        
        var numToCopy = buffer_read(argument0, buffer_u16);
        
        while(numToCopy > 0)
        {
            //Copy vertex from last MT
            morphTarget[vertexNum] = Vector3Copy(argument2[vertexNum]);
            
            vertexNum++;
            numToCopy--;            
        }
    }else{
        //Packet Type 2:
        //  Write Vertices
        
        //Read the VY, VZ.
        var VX = -VX / 2048.0;  //Interprate packetID as a vertex for the X component
        var VY = -buffer_read(argument0, buffer_s16) / 2048.0;
        var VZ =  buffer_read(argument0, buffer_s16) / 2048.0;
        
        morphTarget[vertexNum] = Vector3(VX, VY, VZ);
        vertexNum++;
    }
    
    packetCount--;
} until(packetCount == 0)

return morphTarget;
