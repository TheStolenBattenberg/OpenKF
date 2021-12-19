///MapBuildChunksNew();

//
// We build map data as our custom MSM Format
// but without the help of our builder scripts.
// It's a lot faster, but without the convinience.
//

show_debug_message("Building map chunks...");

// Get time at start of building
var ct = current_time;

//Data used for building our chunks.
var buffSolidL1, buffSolidL2;
var buffAlphaL1, buffAlphaL2;

var buffCollisionInds, numCollisionIndex;
var buffCollisionVert, numCollisionVertex;

// Get the cache location for this map
var cachedLocation = FileSystemCachedFolderName(fileTilemap);

//Build Chunks
for(var cx = 0; cx < 8; ++cx)
{   
    for(var cy = 0; cy < 8; ++cy)
    {
        //We prepare our data buffers
        buffSolidL1 = buffer_create(16, buffer_grow, 1);
        buffSolidL2 = buffer_create(16, buffer_grow, 1);
        buffAlphaL1 = buffer_create(16, buffer_grow, 1);
        buffAlphaL2 = buffer_create(16, buffer_grow, 1);
        buffCollisionInds = buffer_create(16, buffer_grow, 1);
        buffCollisionVert = buffer_create(16, buffer_grow, 1);
        numCollisionIndex  = 0;
        numCollisionVertex = 0;
        //Now add each tiles data in this chunk.
        for(var tx = 0; tx < 10; ++tx)
        {
            //Calculate X Tilemap Offset
            var tox = (10 * cx) + tx;
            
            for(var ty = 0; ty < 10; ++ty)
            {
                //Calculate Y Tilemap Offset        
                var toy = (10 * cy) + ty;
                
                //Get tile from tilemap
                var arrTile = tilemap[tox, toy];
                
                //Build Layer 1
                if(arrTile[0] < array_length_1d(tileset))
                {
                    var arrMesh = tileset[arrTile[0]];
                    
                    //For each face of the mesh...
                    for(var F = 0; F < MSMMeshBuilderGetFaceCount(arrMesh); ++F)
                    {
                        //Get face from mesh
                        var arrFace = MSMMeshBuilderGetFace(arrMesh, F);
                        
                        //Get data from face
                        var V1 = MSMMeshBuilderGetVertex(arrMesh, arrFace[0]);
                        var V2 = MSMMeshBuilderGetVertex(arrMesh, arrFace[1]);
                        var V3 = MSMMeshBuilderGetVertex(arrMesh, arrFace[2]);
                        var N1 = MSMMeshBuilderGetNormal(arrMesh, arrFace[3]);
                        var N2 = MSMMeshBuilderGetNormal(arrMesh, arrFace[4]);
                        var N3 = MSMMeshBuilderGetNormal(arrMesh, arrFace[5]);
                        var T1 = MSMMeshBuilderGetTexcoord(arrMesh, arrFace[6]);
                        var T2 = MSMMeshBuilderGetTexcoord(arrMesh, arrFace[7]);
                        var T3 = MSMMeshBuilderGetTexcoord(arrMesh, arrFace[8]);
                        var C1 = MSMMeshBuilderGetColour(arrMesh, arrFace[9]);
                        var C2 = MSMMeshBuilderGetColour(arrMesh, arrFace[10]);
                        var C3 = MSMMeshBuilderGetColour(arrMesh, arrFace[11]);
                        
                        //Transform our vertex data
                        matrix_set(matrix_world, arrTile[11]);                      
                        V1 = d3d_transform_vertex(V1[0], V1[1], V1[2]);
                        V2 = d3d_transform_vertex(V2[0], V2[1], V2[2]);
                        V3 = d3d_transform_vertex(V3[0], V3[1], V3[2]);
                        
                        //Check to see if this is an opaque face
                        var isOpaqueFace = mean(C1[3], C2[3], C3[3]) > 0.995;
                        
                        if(isOpaqueFace)
                        {
                            //Add Data to Solid Buffer
                            BufferWriteVector3(buffSolidL1, V1);
                            BufferWriteVector3(buffSolidL1, N1);
                            BufferWriteVector2(buffSolidL1, T1);
                            BufferWriteVector4(buffSolidL1, C1);
                            BufferWriteVector3(buffSolidL1, V2);
                            BufferWriteVector3(buffSolidL1, N2);
                            BufferWriteVector2(buffSolidL1, T2);
                            BufferWriteVector4(buffSolidL1, C2);
                            BufferWriteVector3(buffSolidL1, V3);
                            BufferWriteVector3(buffSolidL1, N3);
                            BufferWriteVector2(buffSolidL1, T3);
                            BufferWriteVector4(buffSolidL1, C3);
                        }else{
                            //Add Data to Alpha Buffer
                            BufferWriteVector3(buffAlphaL1, V1);
                            BufferWriteVector3(buffAlphaL1, N1);
                            BufferWriteVector2(buffAlphaL1, T1);
                            BufferWriteVector4(buffAlphaL1, C1);
                            BufferWriteVector3(buffAlphaL1, V2);
                            BufferWriteVector3(buffAlphaL1, N2);
                            BufferWriteVector2(buffAlphaL1, T2);
                            BufferWriteVector4(buffAlphaL1, C2);
                            BufferWriteVector3(buffAlphaL1, V3);
                            BufferWriteVector3(buffAlphaL1, N3);
                            BufferWriteVector2(buffAlphaL1, T3);
                            BufferWriteVector4(buffAlphaL1, C3);
                        }
                        
                        //Write face data to collision index buffer
                        //if(isOpaqueFace)
                        {
                            buffer_write(buffCollisionInds, buffer_u32, numCollisionIndex);
                            buffer_write(buffCollisionInds, buffer_u32, numCollisionIndex+1);
                            buffer_write(buffCollisionInds, buffer_u32, numCollisionIndex+2);
                            BufferWriteVector3(buffCollisionVert, V1);
                            BufferWriteVector3(buffCollisionVert, V2);
                            BufferWriteVector3(buffCollisionVert, V3);
                            
                            numCollisionIndex+=3;
                        }  
                    }
                }
                
                //Build Layer 2
                if(arrTile[5] < array_length_1d(tileset))
                {
                    var arrMesh = tileset[arrTile[5]];
                    
                    //For each face of the mesh...
                    for(var F = 0; F < MSMMeshBuilderGetFaceCount(arrMesh); ++F)
                    {
                        //Get face from mesh
                        var arrFace = MSMMeshBuilderGetFace(arrMesh, F);
                        
                        //Get data from face
                        var V1 = MSMMeshBuilderGetVertex(arrMesh, arrFace[0]);
                        var V2 = MSMMeshBuilderGetVertex(arrMesh, arrFace[1]);
                        var V3 = MSMMeshBuilderGetVertex(arrMesh, arrFace[2]);
                        var N1 = MSMMeshBuilderGetNormal(arrMesh, arrFace[3]);
                        var N2 = MSMMeshBuilderGetNormal(arrMesh, arrFace[4]);
                        var N3 = MSMMeshBuilderGetNormal(arrMesh, arrFace[5]);
                        var T1 = MSMMeshBuilderGetTexcoord(arrMesh, arrFace[6]);
                        var T2 = MSMMeshBuilderGetTexcoord(arrMesh, arrFace[7]);
                        var T3 = MSMMeshBuilderGetTexcoord(arrMesh, arrFace[8]);
                        var C1 = MSMMeshBuilderGetColour(arrMesh, arrFace[9]);
                        var C2 = MSMMeshBuilderGetColour(arrMesh, arrFace[10]);
                        var C3 = MSMMeshBuilderGetColour(arrMesh, arrFace[11]);
                        
                        //Transform our vertex data
                        matrix_set(matrix_world, arrTile[12]);                      
                        V1 = d3d_transform_vertex(V1[0], V1[1], V1[2]);
                        V2 = d3d_transform_vertex(V2[0], V2[1], V2[2]);
                        V3 = d3d_transform_vertex(V3[0], V3[1], V3[2]);
                        
                        //Check to see if this is an opaque face
                        var isOpaqueFace = mean(C1[3], C2[3], C3[3]) > 0.995;
                        
                        if(isOpaqueFace)
                        {
                            //Add Data to Solid Buffer
                            BufferWriteVector3(buffSolidL2, V1);
                            BufferWriteVector3(buffSolidL2, N1);
                            BufferWriteVector2(buffSolidL2, T1);
                            BufferWriteVector4(buffSolidL2, C1);
                            BufferWriteVector3(buffSolidL2, V2);
                            BufferWriteVector3(buffSolidL2, N2);
                            BufferWriteVector2(buffSolidL2, T2);
                            BufferWriteVector4(buffSolidL2, C2);
                            BufferWriteVector3(buffSolidL2, V3);
                            BufferWriteVector3(buffSolidL2, N3);
                            BufferWriteVector2(buffSolidL2, T3);
                            BufferWriteVector4(buffSolidL2, C3);
                        }else{
                            //Add Data to Alpha Buffer
                            BufferWriteVector3(buffAlphaL2, V1);
                            BufferWriteVector3(buffAlphaL2, N1);
                            BufferWriteVector2(buffAlphaL2, T1);
                            BufferWriteVector4(buffAlphaL2, C1);
                            BufferWriteVector3(buffAlphaL2, V2);
                            BufferWriteVector3(buffAlphaL2, N2);
                            BufferWriteVector2(buffAlphaL2, T2);
                            BufferWriteVector4(buffAlphaL2, C2);
                            BufferWriteVector3(buffAlphaL2, V3);
                            BufferWriteVector3(buffAlphaL2, N3);
                            BufferWriteVector2(buffAlphaL2, T3);
                            BufferWriteVector4(buffAlphaL2, C3);
                        }
                        
                        //Write face data to collision index buffer
                        //if(isOpaqueFace)
                        {
                            buffer_write(buffCollisionInds, buffer_u32, numCollisionIndex);
                            buffer_write(buffCollisionInds, buffer_u32, numCollisionIndex+1);
                            buffer_write(buffCollisionInds, buffer_u32, numCollisionIndex+2);
                            BufferWriteVector3(buffCollisionVert, V1);
                            BufferWriteVector3(buffCollisionVert, V2);
                            BufferWriteVector3(buffCollisionVert, V3);
                            
                            numCollisionIndex+=3;
                        }  
                    }
                }
            }       
        }
        
        //Ensure each buffer actually has data...
        repeat(36)
        {
            buffer_write(buffSolidL1, buffer_f32, 0);
            buffer_write(buffSolidL2, buffer_f32, 0);
            buffer_write(buffAlphaL1, buffer_f32, 0);
            buffer_write(buffAlphaL2, buffer_f32, 0); 
        }
        
        repeat(3)
        {
            buffer_write(buffCollisionInds, buffer_u32, numCollisionIndex);
        }
        buffer_write(buffCollisionVert, buffer_f32, 0);
        buffer_write(buffCollisionVert, buffer_f32, 0);
        buffer_write(buffCollisionVert, buffer_f32, 0);
        
        //Build map chunk...
        
        //Build an MSM From these buffers
        var MSMBuffer = buffer_create(16, buffer_grow, 1);
        
        //Write MSM - Header
        buffer_write(MSMBuffer, buffer_u32, $664D534D); //MagicID
        buffer_write(MSMBuffer, buffer_u32, 1);         //Version
        buffer_write(MSMBuffer, buffer_u32, 1);         //Flags (1 = Has Collision Mesh)
        buffer_write(MSMBuffer, buffer_u32, 4);         //Mesh Count (Alpha L1, L2 - Solid L1, L2)
        
        //Write MSM - Meshes
        
        //S1
        buffer_write(MSMBuffer, buffer_u32, buffer_tell(buffSolidL1) / 48);
        buffer_copy(buffSolidL1, 0, buffer_tell(buffSolidL1), MSMBuffer, buffer_tell(MSMBuffer));
        buffer_seek(MSMBuffer, buffer_seek_relative, buffer_tell(buffSolidL1));
        
        //S2
        buffer_write(MSMBuffer, buffer_u32, buffer_tell(buffSolidL2) / 48);
        buffer_copy(buffSolidL2, 0, buffer_tell(buffSolidL2), MSMBuffer, buffer_tell(MSMBuffer));
        buffer_seek(MSMBuffer, buffer_seek_relative, buffer_tell(buffSolidL2));
        
        //A1
        buffer_write(MSMBuffer, buffer_u32, buffer_tell(buffAlphaL1) / 48);
        buffer_copy(buffAlphaL1, 0, buffer_tell(buffAlphaL1), MSMBuffer, buffer_tell(MSMBuffer));
        buffer_seek(MSMBuffer, buffer_seek_relative, buffer_tell(buffAlphaL1));
        
        //A2
        buffer_write(MSMBuffer, buffer_u32, buffer_tell(buffAlphaL2) / 48);
        buffer_copy(buffAlphaL2, 0, buffer_tell(buffAlphaL2), MSMBuffer, buffer_tell(MSMBuffer));
        buffer_seek(MSMBuffer, buffer_seek_relative, buffer_tell(buffAlphaL2));
        
        //Write MSM - Collision Mesh
        
        //Sizes
        buffer_write(MSMBuffer, buffer_u32, buffer_tell(buffCollisionInds) / 12);
        buffer_write(MSMBuffer, buffer_u32, buffer_tell(buffCollisionVert) / 12);
        
        //Indices
        buffer_copy(buffCollisionInds, 0, buffer_tell(buffCollisionInds), MSMBuffer, buffer_tell(MSMBuffer));
        buffer_seek(MSMBuffer, buffer_seek_relative, buffer_tell(buffCollisionInds));
        
        //Vertices
        buffer_copy(buffCollisionVert, 0, buffer_tell(buffCollisionVert), MSMBuffer, buffer_tell(MSMBuffer));
        buffer_seek(MSMBuffer, buffer_seek_relative, buffer_tell(buffCollisionVert));
        
        //Save MSM
        buffer_resize(MSMBuffer, buffer_tell(MSMBuffer));
        buffer_save(MSMBuffer, cachedLocation + "mapc_x"+string(cx)+"_y"+string(cy)+".msm");
        
        //Clean up
        buffer_delete(MSMBuffer);
        buffer_delete(buffSolidL1);
        buffer_delete(buffSolidL2);
        buffer_delete(buffAlphaL1);
        buffer_delete(buffAlphaL2);
        buffer_delete(buffCollisionInds);
        buffer_delete(buffCollisionVert);
    }
}
