///MAP1LoadFromBuffer(buffer, offset);

//Store buffer/offset in temporary variables
var map1Buffer = argument0;
var map1Offset = argument1;

//Make sure we are at the required offset
buffer_seek(map1Buffer, buffer_seek_start, map1Offset);

//Read Offset to CBuffer
var cBuffOff = (map1Offset + buffer_read(map1Buffer, buffer_u32)) + 4;

//
// Map 1 Tilemap
//
var arrTilemap;
var arrTile, datInt;

for(var i = 0; i < 80; ++i)
{
    for(var j = 0; j < 80; ++j)
    {
        //Create Tile Structure
        arrTile = array_create(10);
        
        //Load Layer 2
        datInt = buffer_read(map1Buffer, buffer_u32);   //Try to make reading faster by reading it in uints.
        
        //We also bake rotation/elevation conversion here for ez af rendering
        
        arrTile[0]  = (datInt >> 00) & $FF;                    //Mesh
        arrTile[1]  = -(((datInt >> 08) & $FF) * -$80) / 2048; //Elevation
        arrTile[2]  = 90 * (((datInt >> 16) & $FF) - 1);       //Rotation
        arrTile[3]  = (datInt >> 24) & $FF;                    //Collision
        arrTile[4]  = buffer_read(map1Buffer, buffer_u8);      //Flags
        
        //Load Layer 1
        datInt = buffer_read(map1Buffer, buffer_u32);
        
        arrTile[5]  = (datInt >> 00) & $FF;                    //Mesh
        arrTile[6] = -(((datInt >> 08) & $FF) * -$80) / 2048;  //Elevation
        arrTile[7]  = 90 * (((datInt >> 16) & $FF) - 1);       //Rotation
        arrTile[8]  = (datInt >> 24) & $FF;                    //Collision
        arrTile[9]  = buffer_read(map1Buffer, buffer_u8);      //Flags
        
        //Additional baked properties which are not part of the file.
        arrTile[10] = 0;                                       //Visibility
        arrTile[11] = matrix_build(79-i, arrTile[1], j, 0, arrTile[2], 0, -1, 1, 1);
        arrTile[12] = matrix_build(79-i, arrTile[6], j, 0, arrTile[7], 0, -1, 1, 1);
        
        arrTilemap[79-i, j] = arrTile;
    }
}

//
// Map 1 Collision Packets
//

//Seek to start of data
buffer_seek(map1Buffer, buffer_seek_start, cBuffOff);

//Read size of collision buffer...
var cBuffSize = buffer_read(map1Buffer, buffer_u32);

//Copy Collision Buffer
var cBuffer = buffer_create(cBuffSize, buffer_fixed, 1);
buffer_copy(map1Buffer, buffer_tell(map1Buffer), cBuffSize, cBuffer, 0); 

//Create data to return
var retData = array_create(2);
    retData[0] = arrTilemap;
    retData[1] = cBuffer;
return retData;
