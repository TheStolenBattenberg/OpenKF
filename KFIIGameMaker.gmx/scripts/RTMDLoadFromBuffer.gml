///RTMDLoadFromBuffer(buffer, offset);

//Store buffer/offset in temporary variables
var tmdBuffer = argument0;
var tmdOffset = argument1;
 
//Make sure we are at the required offset
buffer_seek(tmdBuffer, buffer_seek_start, tmdOffset);

//
// Read Data as TMD
//

//Header
var magicID = buffer_read(tmdBuffer, buffer_u32);
buffer_seek(tmdBuffer, buffer_seek_relative, 4);    //Skip flags
var objectCount = buffer_read(tmdBuffer, buffer_u32);

if(magicID != $00000000)
{
    show_debug_message("RTMDLoadFromBuffer failed because of a bad magicID");
    return null;
}

//Objects
var objectOffset = tmdOffset + $C;
var mbArray = array_create(objectCount);

var objectIndex = 0;

repeat(objectCount)
{
    //Seek to object location
    buffer_seek(tmdBuffer, buffer_seek_start, objectOffset);
    
    //Read Object Structure
    var offVertex = (tmdOffset + $C) + buffer_read(tmdBuffer, buffer_u32);
    var numVertex = buffer_read(tmdBuffer, buffer_u32);
    var offNormal = (tmdOffset + $C) + buffer_read(tmdBuffer, buffer_u32);
    var numNormal = buffer_read(tmdBuffer, buffer_u32);
    var offPacket = (tmdOffset + $C) + buffer_read(tmdBuffer, buffer_u32);
    var numPacket = buffer_read(tmdBuffer, buffer_u32);
    buffer_seek(tmdBuffer, buffer_seek_relative, 4);   //Skip 'scale'
    
    //Save next objects offset
    objectOffset = buffer_tell(tmdBuffer);
    
    //Start Building an MSM Mesh
    var msmMeshBuilder = MSMMeshBuilderCreate();
    var defCO = MSMMeshBuilderAddColour(msmMeshBuilder, Vector4(1.0, 1.0, 1.0, 1.0));
    var defCT = MSMMeshBuilderAddColour(msmMeshBuilder, Vector4(1.0, 1.0, 1.0, 0.5));
    var defTC = MSMMeshBuilderAddTexcoord(msmMeshBuilder, Vector2(0.0, 0.0));
    
    //Read Vertices
    buffer_seek(tmdBuffer, buffer_seek_start, offVertex);
    
    repeat(numVertex)
    {
        //We do some division here to make our integer coordinates into decent FP coordinates
        var VX = -buffer_read(tmdBuffer, buffer_s16) / 2048.0;
        var VY = -buffer_read(tmdBuffer, buffer_s16) / 2048.0;
        var VZ = buffer_read(tmdBuffer, buffer_s16) / 2048.0;
        buffer_seek(tmdBuffer, buffer_seek_relative, 2);
        
        MSMMeshBuilderAddVertex(msmMeshBuilder, Vector3(VX, VY, VZ));
    }
    
    //Read Normals
    buffer_seek(tmdBuffer, buffer_seek_start, offNormal);
    
    repeat(numNormal)
    {
        var NX = -buffer_read(tmdBuffer, buffer_s16) / 4096.0;
        var NY = -buffer_read(tmdBuffer, buffer_s16) / 4096.0;
        var NZ = buffer_read(tmdBuffer, buffer_s16) / 4096.0;
        buffer_seek(tmdBuffer, buffer_seek_relative, 2);
        
        MSMMeshBuilderAddNormal(msmMeshBuilder, Vector3(VX, VY, VZ));
    }
    
    //Read Packets
    buffer_seek(tmdBuffer, buffer_seek_start, offPacket);
    
    repeat(numPacket)
    {
        //Read Packet ID
        var packetID = buffer_read(tmdBuffer, buffer_u32);        
        var oLen = (packetID & $FF);
        var iLen = (packetID >> 8)  & $FF;
        var flag = (packetID >> 16) & $FF;
        var mode = (packetID >> 24) & $FF;
        
        //Deal with alpha values by doing this shit.
        var CA = 1.0;
        var CC = defCO;
        
        //Switch statement with all TMD packets.
        switch(packetID)
        {
            //
            // Triangle
            //
            
            //Flat, Single Colour
            case $22000304: CA = 0.5; CC = defCT;
            case $20000304:
            
                //Read colour data
                var R1 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var G1 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var B1 = buffer_read(tmdBuffer, buffer_u8) / 255;
                buffer_seek(tmdBuffer, buffer_seek_relative, 1);
                
                //Read normal/vertex data
                var N1 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V1 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V2 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V3 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                
                //Add data to Mesh Builder
                var C1 = MSMMeshBuilderAddColour(msmMeshBuilder, Vector4(R1, G1, B1, CA));
                MSMMeshBuilderAddFace(msmMeshBuilder, MSMFace(V1,V2,V3, N1,N1,N1, defTC,defTC,defTC, C1,C1,C1));
                
            break;
            
            //Flat, Gradient Colour
            case $22040506: CA = 0.5; CC = defCT;                
            case $20040506:
            
                //Read colour data
                var R1 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var G1 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var B1 = buffer_read(tmdBuffer, buffer_u8) / 255;
                buffer_seek(tmdBuffer, buffer_seek_relative, 1);
                var R2 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var G2 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var B2 = buffer_read(tmdBuffer, buffer_u8) / 255;
                buffer_seek(tmdBuffer, buffer_seek_relative, 1); 
                var R3 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var G3 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var B3 = buffer_read(tmdBuffer, buffer_u8) / 255;
                buffer_seek(tmdBuffer, buffer_seek_relative, 1);
                               
                //Read normal/vertex data
                var N1 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V1 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V2 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V3 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                
                //Add data to Mesh Builder
                var C1 = MSMMeshBuilderAddColour(msmMeshBuilder, Vector4(R1, G1, B1, CA));
                var C2 = MSMMeshBuilderAddColour(msmMeshBuilder, Vector4(R2, G2, B2, CA));
                var C3 = MSMMeshBuilderAddColour(msmMeshBuilder, Vector4(R3, G3, B3, CA));
                MSMMeshBuilderAddFace(msmMeshBuilder, MSMFace(V1,V2,V3, N1,N1,N1, defTC,defTC,defTC, C1,C2,C3));
                
            break;  
                      
            //Flat, Texture
            case $26000507: CA = 0.5; CC = defCT; 
            case $24000507:
            
                //Read texture data
                var tcU1 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var tcV1 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var cba  = buffer_read(tmdBuffer, buffer_u16);
                var tcU2 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var tcV2 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var tsb  = buffer_read(tmdBuffer, buffer_u16);
                var tcU3 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var tcV3 = buffer_read(tmdBuffer, buffer_u8) / 255;
                buffer_seek(tmdBuffer, buffer_seek_relative, 2);
                
                //Read normal/vertex data
                var N1 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V1 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V2 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V3 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                
                //Add data to Mesh Builder
                var T1 = MSMMeshBuilderAddTexcoord(msmMeshBuilder, TMDConvTC(tcU1, tcV1, tsb));
                var T2 = MSMMeshBuilderAddTexcoord(msmMeshBuilder, TMDConvTC(tcU2, tcV2, tsb));
                var T3 = MSMMeshBuilderAddTexcoord(msmMeshBuilder, TMDConvTC(tcU3, tcV3, tsb));
                MSMMeshBuilderAddFace(msmMeshBuilder, MSMFace(V1,V2,V3, N1,N1,N1, T1,T2,T3, CC,CC,CC));
                
            break;
            
            //Smooth, Single Colour
            case $32000406: CA = 0.5; CC = defCT;  
            case $30000406:
            
                //Read colour data
                var R1 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var G1 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var B1 = buffer_read(tmdBuffer, buffer_u8) / 255;
                buffer_seek(tmdBuffer, buffer_seek_relative, 1);
                
                //Read normal/vertex data
                var N1 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V1 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var N2 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V2 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var N3 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V3 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                
                //Add data to Mesh Builder
                var C1 = MSMMeshBuilderAddColour(msmMeshBuilder, Vector4(R1, G1, B1, CA));             
                MSMMeshBuilderAddFace(msmMeshBuilder, MSMFace(V1,V2,V3, N1,N2,N3, defTC,defTC,defTC, C1,C1,C1));
                
            break;
            
            //Smooth, Gradient Colour
            case $32040606: CA = 0.5; CC = defCT; 
            case $30040606:
            
                //Read colour data
                var R1 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var G1 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var B1 = buffer_read(tmdBuffer, buffer_u8) / 255;
                buffer_seek(tmdBuffer, buffer_seek_relative, 1);
                var R2 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var G2 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var B2 = buffer_read(tmdBuffer, buffer_u8) / 255;
                buffer_seek(tmdBuffer, buffer_seek_relative, 1); 
                var R3 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var G3 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var B3 = buffer_read(tmdBuffer, buffer_u8) / 255;
                buffer_seek(tmdBuffer, buffer_seek_relative, 1);
                
                //Read normal/vertex data
                var N1 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V1 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var N2 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V2 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var N3 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V3 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                
                //Add data to Mesh Builder
                var C1 = MSMMeshBuilderAddColour(msmMeshBuilder, Vector4(R1, G1, B1, CA));
                var C2 = MSMMeshBuilderAddColour(msmMeshBuilder, Vector4(R2, G2, B2, CA));
                var C3 = MSMMeshBuilderAddColour(msmMeshBuilder, Vector4(R3, G3, B3, CA));
                MSMMeshBuilderAddFace(msmMeshBuilder, MSMFace(V1,V2,V3, N1,N2,N3, defTC,defTC,defTC, C1,C2,C3));
                
            break;
                        
            //Smooth, Texture
            case $36000609: CA = 0.5; CC = defCT; 
            case $34000609:
            
                //Read texture data
                var tcU1 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var tcV1 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var cba  = buffer_read(tmdBuffer, buffer_u16);
                var tcU2 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var tcV2 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var tsb  = buffer_read(tmdBuffer, buffer_u16);
                var tcU3 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var tcV3 = buffer_read(tmdBuffer, buffer_u8) / 255;
                buffer_seek(tmdBuffer, buffer_seek_relative, 2);
                
                //Read normal/texcoord data
                var N1 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V1 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var N2 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V2 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var N3 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V3 = buffer_read(tmdBuffer, buffer_u16) >> 3;  
                
                //Add data to Mesh Builder
                var T1 = MSMMeshBuilderAddTexcoord(msmMeshBuilder, TMDConvTC(tcU1, tcV1, tsb));
                var T2 = MSMMeshBuilderAddTexcoord(msmMeshBuilder, TMDConvTC(tcU2, tcV2, tsb));
                var T3 = MSMMeshBuilderAddTexcoord(msmMeshBuilder, TMDConvTC(tcU3, tcV3, tsb));
                MSMMeshBuilderAddFace(msmMeshBuilder, MSMFace(V1,V2,V3, N1,N2,N3, T1,T2,T3, CC,CC,CC));     
                    
            break;     
                   
            //
            // Quad
            //
            
            //Flat, Single Colour
            case $2A000405: CA = 0.5; CC = defCT;            
            case $28000405:
            
                //Read colour data
                var R1 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var G1 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var B1 = buffer_read(tmdBuffer, buffer_u8) / 255;
                buffer_seek(tmdBuffer, buffer_seek_relative, 1);
                
                //Read normal/vertex data
                var N1 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V1 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V2 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V3 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V4 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                buffer_seek(tmdBuffer, buffer_seek_relative, 2);
                
                //Add data to Mesh Builder
                var C1 = MSMMeshBuilderAddColour(msmMeshBuilder, Vector4(R1, G1, B1, CA)); 
                MSMMeshBuilderAddFace(msmMeshBuilder, MSMFace(V1,V2,V3, N1,N1,N1, defTC,defTC,defTC, C1,C1,C1)); 
                MSMMeshBuilderAddFace(msmMeshBuilder, MSMFace(V4,V3,V2, N1,N1,N1, defTC,defTC,defTC, C1,C1,C1)); 
                
            break;
            
            //Flat, Gradient Colour
            case $2A040708: CA = 0.5; CC = defCT;  
            case $28040708:
            
                //Read colour data
                var R1 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var G1 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var B1 = buffer_read(tmdBuffer, buffer_u8) / 255;
                buffer_seek(tmdBuffer, buffer_seek_relative, 1);
                var R2 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var G2 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var B2 = buffer_read(tmdBuffer, buffer_u8) / 255;
                buffer_seek(tmdBuffer, buffer_seek_relative, 1);
                var R3 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var G3 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var B3 = buffer_read(tmdBuffer, buffer_u8) / 255;
                buffer_seek(tmdBuffer, buffer_seek_relative, 1);
                var R4 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var G4 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var B4 = buffer_read(tmdBuffer, buffer_u8) / 255;
                buffer_seek(tmdBuffer, buffer_seek_relative, 1);  
                         
                //Read normal/vertex data
                var N1 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V1 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V2 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V3 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V4 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                buffer_seek(tmdBuffer, buffer_seek_relative, 2);
                
                //Add data to Mesh Builder
                var C1 = MSMMeshBuilderAddColour(msmMeshBuilder, Vector4(R1, G1, B1, CA)); 
                var C2 = MSMMeshBuilderAddColour(msmMeshBuilder, Vector4(R2, G2, B2, CA)); 
                var C3 = MSMMeshBuilderAddColour(msmMeshBuilder, Vector4(R3, G3, B3, CA)); 
                var C4 = MSMMeshBuilderAddColour(msmMeshBuilder, Vector4(R4, G4, B4, CA)); 
                MSMMeshBuilderAddFace(msmMeshBuilder, MSMFace(V1,V2,V3, N1,N1,N1, defTC,defTC,defTC, C1,C2,C3)); 
                MSMMeshBuilderAddFace(msmMeshBuilder, MSMFace(V4,V3,V2, N1,N1,N1, defTC,defTC,defTC, C4,C3,C2));                 
                
            break;
            
            //Flat, Texture
            case $2E000709: CA = 0.5; CC = defCT; 
            case $2C000709:
            
                //Read texture data
                var tcU1 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var tcV1 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var cba  = buffer_read(tmdBuffer, buffer_u16);
                var tcU2 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var tcV2 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var tsb  = buffer_read(tmdBuffer, buffer_u16);
                var tcU3 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var tcV3 = buffer_read(tmdBuffer, buffer_u8) / 255;
                buffer_seek(tmdBuffer, buffer_seek_relative, 2);
                var tcU4 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var tcV4 = buffer_read(tmdBuffer, buffer_u8) / 255;
                buffer_seek(tmdBuffer, buffer_seek_relative, 2);
                                         
                //Read normal/vertex data
                var N1 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V1 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V2 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V3 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V4 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                buffer_seek(tmdBuffer, buffer_seek_relative, 2);
                
                //Add data to Mesh Builder
                var T1 = MSMMeshBuilderAddTexcoord(msmMeshBuilder, TMDConvTC(tcU1, tcV1, tsb));
                var T2 = MSMMeshBuilderAddTexcoord(msmMeshBuilder, TMDConvTC(tcU2, tcV2, tsb));
                var T3 = MSMMeshBuilderAddTexcoord(msmMeshBuilder, TMDConvTC(tcU3, tcV3, tsb));
                var T4 = MSMMeshBuilderAddTexcoord(msmMeshBuilder, TMDConvTC(tcU4, tcV4, tsb));   
                MSMMeshBuilderAddFace(msmMeshBuilder, MSMFace(V1,V2,V3, N1,N1,N1, T1,T2,T3, CC,CC,CC));
                MSMMeshBuilderAddFace(msmMeshBuilder, MSMFace(V4,V3,V2, N1,N1,N1, T4,T3,T2, CC,CC,CC));
                    
            break;
            
            //Smooth, Single Colour
            case $3A000508: CA = 0.5; CC = defCT;
            case $38000508:
            
                //Read colour data
                var R1 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var G1 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var B1 = buffer_read(tmdBuffer, buffer_u8) / 255;
                buffer_seek(tmdBuffer, buffer_seek_relative, 1);
                
                //Read normal/vertex data
                var N1 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V1 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var N2 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V2 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var N3 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V3 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var N4 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V4 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                
                //Add data to Mesh Builder
                var C1 = MSMMeshBuilderAddColour(msmMeshBuilder, Vector4(R1, G1, B1, CA)); 
                MSMMeshBuilderAddFace(msmMeshBuilder, MSMFace(V1,V2,V3, N1,N2,N3, defTC,defTC,defTC, C1,C1,C1)); 
                MSMMeshBuilderAddFace(msmMeshBuilder, MSMFace(V4,V3,V2, N4,N3,N2, defTC,defTC,defTC, C1,C1,C1)); 
                
            break;
            
            //Smooth, Gradient Colour
            case $3A040808: CA = 0.5; CC = defCT;
            case $38040808:
            
                //Read colour data
                var R1 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var G1 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var B1 = buffer_read(tmdBuffer, buffer_u8) / 255;
                buffer_seek(tmdBuffer, buffer_seek_relative, 1);
                var R2 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var G2 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var B2 = buffer_read(tmdBuffer, buffer_u8) / 255;
                buffer_seek(tmdBuffer, buffer_seek_relative, 1);
                var R3 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var G3 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var B3 = buffer_read(tmdBuffer, buffer_u8) / 255;
                buffer_seek(tmdBuffer, buffer_seek_relative, 1);
                var R4 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var G4 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var B4 = buffer_read(tmdBuffer, buffer_u8) / 255;
                buffer_seek(tmdBuffer, buffer_seek_relative, 1);
                
                //Read normal/vertex data
                var N1 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V1 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var N2 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V2 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var N3 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V3 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var N4 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V4 = buffer_read(tmdBuffer, buffer_u16) >> 3;
               
                //Add data to Mesh Builder
                var C1 = MSMMeshBuilderAddColour(msmMeshBuilder, Vector4(R1, G1, B1, CA)); 
                var C2 = MSMMeshBuilderAddColour(msmMeshBuilder, Vector4(R2, G2, B2, CA)); 
                var C3 = MSMMeshBuilderAddColour(msmMeshBuilder, Vector4(R3, G3, B3, CA)); 
                var C4 = MSMMeshBuilderAddColour(msmMeshBuilder, Vector4(R4, G4, B4, CA)); 
                MSMMeshBuilderAddFace(msmMeshBuilder, MSMFace(V1,V2,V3, N1,N2,N3, defTC,defTC,defTC, C1,C2,C3)); 
                MSMMeshBuilderAddFace(msmMeshBuilder, MSMFace(V4,V3,V2, N4,N3,N2, defTC,defTC,defTC, C4,C3,C2)); 
                
            break;
            
            //Smooth, Texture
            case $3E00080C: 
            case $3C00080C:
            
                //Read texture data
                var tcU1 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var tcV1 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var cba  = buffer_read(tmdBuffer, buffer_u16);
                var tcU2 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var tcV2 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var tsb  = buffer_read(tmdBuffer, buffer_u16);
                var tcU3 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var tcV3 = buffer_read(tmdBuffer, buffer_u8) / 255;
                buffer_seek(tmdBuffer, buffer_seek_relative, 2);
                var tcU4 = buffer_read(tmdBuffer, buffer_u8) / 255;
                var tcV4 = buffer_read(tmdBuffer, buffer_u8) / 255;
                buffer_seek(tmdBuffer, buffer_seek_relative, 2);
                                         
                //Read normal/vertex data
                var N1 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V1 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var N2 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V2 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var N3 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V3 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var N4 = buffer_read(tmdBuffer, buffer_u16) >> 3;
                var V4 = buffer_read(tmdBuffer, buffer_u16) >> 3;

                //Add data to Mesh Builder
                var T1 = MSMMeshBuilderAddTexcoord(msmMeshBuilder, TMDConvTC(tcU1, tcV1, tsb));
                var T2 = MSMMeshBuilderAddTexcoord(msmMeshBuilder, TMDConvTC(tcU2, tcV2, tsb));
                var T3 = MSMMeshBuilderAddTexcoord(msmMeshBuilder, TMDConvTC(tcU3, tcV3, tsb));
                var T4 = MSMMeshBuilderAddTexcoord(msmMeshBuilder, TMDConvTC(tcU4, tcV4, tsb));   
                MSMMeshBuilderAddFace(msmMeshBuilder, MSMFace(V1,V2,V3, N1,N2,N3, T1,T2,T3, CC,CC,CC));
                MSMMeshBuilderAddFace(msmMeshBuilder, MSMFace(V4,V3,V2, N4,N3,N2, T4,T3,T2, CC,CC,CC));                
            break;
            
            default:
                show_error("Unrecognised TMD packet: " + dec_to_hex(packetID, 8), true);
            break;
        }
    }
    
    //Add the object to an array of mesh builders.
    mbArray[objectIndex] = msmMeshBuilder;    
    objectIndex++;
} 

//return only the mesh builder array
return mbArray;
