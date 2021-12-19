///MAP1DecodeCollisionPacket(cbuffer, cID, outBuffer, rot, elev, x, z);

enum PacketType
{
    PlaneXZ = $1000,
}

//Ensure cID is not out of bounds
if(argument1 > 255)
{
    show_debug_message("Bad Collision ID: " + string(argument1));
    return null;
}

buffer_seek(argument0, buffer_seek_start, 2 * argument1);

//Read the offset
var cOffset = buffer_read(argument0, buffer_u16);

//Ensure Offset is valid
if(cOffset == 0)
{
    show_debug_message("Bad Collision Offset: " + dec_to_hex(cOffset));
    return null;
}

//
// Read Packet Header
//

//Seek to location
buffer_seek(argument0, buffer_seek_start, cOffset);

var cPacketType = buffer_read(argument0, buffer_u16);
var cPacketNum  = buffer_read(argument0, buffer_u16);

show_debug_message("Collision Packet Type: " + dec_to_hex(cPacketType));
show_debug_message("Collision Count: " + string(cPacketNum));


var fuckmebum = argument3;

//Read Each Collision
for(var i = 0; i < cPacketNum; ++i)
{
    var cCollisionID = buffer_read(argument0, buffer_u16);
    
    switch(cCollisionID)
    {
        case $0011: //PlaneXZ For Ceilings
            var yDelta  = (-buffer_read(argument0, buffer_s16)) / 2048;
            buffer_read(argument0, buffer_s16);
            
            BufferWritePlaneXZ(argument2, argument5, argument4+yDelta, argument6, 0.5, 0.5);
        break;
        
        case $0010: //PlaneXZ For Floor
            var yDelta = (-buffer_read(argument0, buffer_s16)) / 2048;     
                              
            BufferWritePlaneXZ(argument2, argument5, argument4+yDelta, argument6, 0.5, 0.5);
        break;
            
        case $0018: //PlaneXZ For Water or Lava
            var yDelta = (-buffer_read(argument0, buffer_s16)) / 2048;  
                                 
            //BufferWritePlaneXZ(argument2, argument5, argument4+yDelta, argument6, 0.5, 0.5);
        break;
        
        case $0020: //PlaneYX
            var xzDelta = 0.5 - (buffer_read(argument0, buffer_s16) / 2048);
            buffer_read(argument0, buffer_s16);
            var ySize   = (-buffer_read(argument0, buffer_s16)) / 2048;
            var dir     = buffer_read(argument0, buffer_s16);
           
            var newDir = (90 + argument3) + (90 * dir);
            if(newDir > 360)
            {
                newDir -= 360;
            }
            switch(newDir)
            {
                case 90:  BufferWritePlaneYZ(argument2, argument5-xzDelta, argument4+(ySize/2), argument6, ySize/2, 0.5); break;
                case 270: BufferWritePlaneYZ(argument2, argument5+xzDelta, argument4+(ySize/2), argument6, ySize/2, 0.5); break;               
                case 0:   BufferWritePlaneYX(argument2, argument5, argument4+(ySize/2), argument6-xzDelta, ySize/2, 0.5); break;
                case 180: BufferWritePlaneYX(argument2, argument5, argument4+(ySize/2), argument6+xzDelta, ySize/2, 0.5); break;
            }
        break;
        
        default:
            show_debug_message("Unrecognised Collision ID: " + dec_to_hex(cCollisionID));
            return null;
        break;
    }   
}

return true;
