///MapBuildChunks();

var cachedLocation = FileSystemCachedFolderName(fileTilemap);

//For each layer...
var chunkS, chunkA;

var ct = current_time;

show_debug_message("Building Map Data...");

//Create a mesh builder...
var MBSL1 = MSMMeshBuilderCreate();
var MBSL2 = MSMMeshBuilderCreate();
var MBAL1 = MSMMeshBuilderCreate();
var MBAL2 = MSMMeshBuilderCreate();

for(var i2 = 0; i2 < 80; ++i2)
{
    for(var j2 = 0; j2 < 80; ++j2)
    {
        //Get tile from tilemap
        var arrTile = tilemap[i2, j2];
        
        //Add Layer 1 triangles
        if(arrTile[0] < array_length_1d(tileset))
        {
            var Mesh = tileset[arrTile[0]];
            
            //This little hack solves a lot of headaches... Why are the tiles fucked?
            var skipStart = 0;
            var skipEnd   = 0;
            if(fileTilemap == "FDAT_3")
            {
                if(arrTile[0] == 70)
                {
                    skipStart = 46;
                    skipEnd   = 50;       
                }else
                if(arrTile[0] == 81)
                {
                    skipStart = 39;
                    skipEnd   = 41;              
                }else
                if(arrTile[0] == 91 || arrTile[0] == 95)
                {
                    skipStart = 18;
                    skipEnd   = 20;
                }else          
                if(arrTile[0] == 93)
                {
                    skipStart = 14;
                    skipEnd   = 16;
                }
            }
            
            for(var F = 0; F < MSMMeshBuilderGetFaceCount(Mesh); ++F)
            {
                //The final part of 'this little hack'
                if(F >= skipStart && F < skipEnd)
                    continue;
            
                var Face = MSMMeshBuilderGetFace(Mesh, F);

                var V1 = MSMMeshBuilderGetVertex(Mesh, Face[0]);
                var V2 = MSMMeshBuilderGetVertex(Mesh, Face[1]);
                var V3 = MSMMeshBuilderGetVertex(Mesh, Face[2]);                        
                var C1  = MSMMeshBuilderGetColour(Mesh, Face[9]);
                var C2  = MSMMeshBuilderGetColour(Mesh, Face[10]);
                var C3  = MSMMeshBuilderGetColour(Mesh, Face[11]);

                //Transform Vertices
                matrix_set(matrix_world, arrTile[11]);                      
                V1 = d3d_transform_vertex(V1[0], V1[1], V1[2]);
                V2 = d3d_transform_vertex(V2[0], V2[1], V2[2]);
                V3 = d3d_transform_vertex(V3[0], V3[1], V3[2]);                        
                                                                                            
                //To Alpha
                if(mean(C1[3], C2[3], C3[3]) < 0.995)
                {        
                    var VI1  = MSMMeshBuilderAddVertex(MBAL1, V1);
                    var VI2  = MSMMeshBuilderAddVertex(MBAL1, V2);
                    var VI3  = MSMMeshBuilderAddVertex(MBAL1, V3);                     
                    var N1  = MSMMeshBuilderAddNormal(MBAL1, MSMMeshBuilderGetNormal(Mesh, Face[3]));
                    var N2  = MSMMeshBuilderAddNormal(MBAL1, MSMMeshBuilderGetNormal(Mesh, Face[4]));
                    var N3  = MSMMeshBuilderAddNormal(MBAL1, MSMMeshBuilderGetNormal(Mesh, Face[5])); 
                    var T1  = MSMMeshBuilderAddTexcoord(MBAL1, MSMMeshBuilderGetTexcoord(Mesh, Face[6]));
                    var T2  = MSMMeshBuilderAddTexcoord(MBAL1, MSMMeshBuilderGetTexcoord(Mesh, Face[7]));
                    var T3  = MSMMeshBuilderAddTexcoord(MBAL1, MSMMeshBuilderGetTexcoord(Mesh, Face[8]));                                 
                    var CI1 = MSMMeshBuilderAddColour(MBAL1, C1);            
                    var CI2 = MSMMeshBuilderAddColour(MBAL1, C2);   
                    var CI3 = MSMMeshBuilderAddColour(MBAL1, C3);                           
                    
                    MSMMeshBuilderAddFace(MBAL1, MSMFace(VI1,VI2,VI3,N1,N2,N3,T1,T2,T3,CI1,CI2,CI3));                          
                }else
                //To Solid
                {         
                    
                    var VI1  = MSMMeshBuilderAddVertex(MBSL1, V1);
                    var VI2  = MSMMeshBuilderAddVertex(MBSL1, V2);
                    var VI3  = MSMMeshBuilderAddVertex(MBSL1, V3);                  
                    var N1  = MSMMeshBuilderAddNormal(MBSL1, MSMMeshBuilderGetNormal(Mesh, Face[3]));
                    var N2  = MSMMeshBuilderAddNormal(MBSL1, MSMMeshBuilderGetNormal(Mesh, Face[4]));
                    var N3  = MSMMeshBuilderAddNormal(MBSL1, MSMMeshBuilderGetNormal(Mesh, Face[5])); 
                    var T1  = MSMMeshBuilderAddTexcoord(MBSL1, MSMMeshBuilderGetTexcoord(Mesh, Face[6]));
                    var T2  = MSMMeshBuilderAddTexcoord(MBSL1, MSMMeshBuilderGetTexcoord(Mesh, Face[7]));
                    var T3  = MSMMeshBuilderAddTexcoord(MBSL1, MSMMeshBuilderGetTexcoord(Mesh, Face[8]));                                  
                    var CI1 = MSMMeshBuilderAddColour(MBSL1, C1);            
                    var CI2 = MSMMeshBuilderAddColour(MBSL1, C2);   
                    var CI3 = MSMMeshBuilderAddColour(MBSL1, C3);                           
                    
                    MSMMeshBuilderAddFace(MBSL1, MSMFace(VI1,VI2,VI3,N1,N2,N3,T1,T2,T3,CI1,CI2,CI3));                          
                }
            }                             
        }
 
        //Add Layer 2 triangles
        if(arrTile[5] < array_length_1d(tileset))
        {
            var Mesh = tileset[arrTile[5]];
            
            //This little hack solves a lot of headaches... Why are the maps fucked?
            var skipStart = 0;
            var skipEnd   = 0;
            if(fileTilemap == "FDAT_3")
            {
                if(arrTile[5] == 70)
                {
                    skipStart = 46;
                    skipEnd   = 50;       
                }else
                if(arrTile[5] == 81)
                {
                    skipStart = 39;
                    skipEnd   = 41;              
                }else
                if(arrTile[5] == 91 || arrTile[5] == 95)
                {
                    skipStart = 18;
                    skipEnd   = 20;
                }else             
                if(arrTile[5] == 93)
                {
                    skipStart = 14;
                    skipEnd   = 16;
                }
            }            
            
            for(var F = 0; F < MSMMeshBuilderGetFaceCount(Mesh); ++F)
            {
                //The final part of 'this little hack'
                if(F >= skipStart && F < skipEnd)
                    continue;            
            
                var Face = MSMMeshBuilderGetFace(Mesh, F);
                
                var V1 = MSMMeshBuilderGetVertex(Mesh, Face[0]);
                var V2 = MSMMeshBuilderGetVertex(Mesh, Face[1]);
                var V3 = MSMMeshBuilderGetVertex(Mesh, Face[2]);                        
                var C1  = MSMMeshBuilderGetColour(Mesh, Face[9]);
                var C2  = MSMMeshBuilderGetColour(Mesh, Face[10]);
                var C3  = MSMMeshBuilderGetColour(Mesh, Face[11]);

                //Transform Vertices
                matrix_set(matrix_world, arrTile[12]);                        
                V1 = d3d_transform_vertex(V1[0], V1[1], V1[2]);
                V2 = d3d_transform_vertex(V2[0], V2[1], V2[2]);
                V3 = d3d_transform_vertex(V3[0], V3[1], V3[2]);     
                                        
                //To Alpha
                if(mean(C1[3], C2[3], C3[3]) < 0.995)
                {                                           
                    var VI1  = MSMMeshBuilderAddVertex(MBAL2, V1);
                    var VI2  = MSMMeshBuilderAddVertex(MBAL2, V2);
                    var VI3  = MSMMeshBuilderAddVertex(MBAL2, V3);                     
                    var N1  = MSMMeshBuilderAddNormal(MBAL2, MSMMeshBuilderGetNormal(Mesh, Face[3]));
                    var N2  = MSMMeshBuilderAddNormal(MBAL2, MSMMeshBuilderGetNormal(Mesh, Face[4]));
                    var N3  = MSMMeshBuilderAddNormal(MBAL2, MSMMeshBuilderGetNormal(Mesh, Face[5])); 
                    var T1  = MSMMeshBuilderAddTexcoord(MBAL2, MSMMeshBuilderGetTexcoord(Mesh, Face[6]));
                    var T2  = MSMMeshBuilderAddTexcoord(MBAL2, MSMMeshBuilderGetTexcoord(Mesh, Face[7]));
                    var T3  = MSMMeshBuilderAddTexcoord(MBAL2, MSMMeshBuilderGetTexcoord(Mesh, Face[8]));                                 
                    var CI1 = MSMMeshBuilderAddColour(MBAL2, C1);            
                    var CI2 = MSMMeshBuilderAddColour(MBAL2, C2);   
                    var CI3 = MSMMeshBuilderAddColour(MBAL2, C3);                           
                    
                    MSMMeshBuilderAddFace(MBAL2, MSMFace(VI1,VI2,VI3,N1,N2,N3,T1,T2,T3,CI1,CI2,CI3));                            
                }else
                //To Solid
                { 
                    var VI1  = MSMMeshBuilderAddVertex(MBSL2, V1);
                    var VI2  = MSMMeshBuilderAddVertex(MBSL2, V2);
                    var VI3  = MSMMeshBuilderAddVertex(MBSL2, V3);                  
                    var N1  = MSMMeshBuilderAddNormal(MBSL2, MSMMeshBuilderGetNormal(Mesh, Face[3]));
                    var N2  = MSMMeshBuilderAddNormal(MBSL2, MSMMeshBuilderGetNormal(Mesh, Face[4]));
                    var N3  = MSMMeshBuilderAddNormal(MBSL2, MSMMeshBuilderGetNormal(Mesh, Face[5])); 
                    var T1  = MSMMeshBuilderAddTexcoord(MBSL2, MSMMeshBuilderGetTexcoord(Mesh, Face[6]));
                    var T2  = MSMMeshBuilderAddTexcoord(MBSL2, MSMMeshBuilderGetTexcoord(Mesh, Face[7]));
                    var T3  = MSMMeshBuilderAddTexcoord(MBSL2, MSMMeshBuilderGetTexcoord(Mesh, Face[8]));                                  
                    var CI1 = MSMMeshBuilderAddColour(MBSL2, C1);            
                    var CI2 = MSMMeshBuilderAddColour(MBSL2, C2);   
                    var CI3 = MSMMeshBuilderAddColour(MBSL2, C3);                           
                    
                    MSMMeshBuilderAddFace(MBSL2, MSMFace(VI1,VI2,VI3,N1,N2,N3,T1,T2,T3,CI1,CI2,CI3));      
                }
            }                             
        }
    }
}

chunks[@ 0] = null;
chunks[@ 1] = null;

if(MSMMeshBuilderGetFaceCount(MBSL1) <= 0)
{
    MSMMeshBuilderAddVertex(MBSL1, Vector3(0, 0, 0));
    MSMMeshBuilderAddNormal(MBSL1, Vector3(0, 0, 0));
    MSMMeshBuilderAddTexcoord(MBSL1, Vector2(0, 0));
    MSMMeshBuilderAddColour(MBSL1, Vector4(0, 0, 0, 0));
    MSMMeshBuilderAddFace(MBSL1, MSMFace(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
}
if(MSMMeshBuilderGetFaceCount(MBSL2) <= 0)
{
    MSMMeshBuilderAddVertex(MBSL2, Vector3(0, 0, 0));
    MSMMeshBuilderAddNormal(MBSL2, Vector3(0, 0, 0));
    MSMMeshBuilderAddTexcoord(MBSL2, Vector2(0, 0));
    MSMMeshBuilderAddColour(MBSL2, Vector4(0, 0, 0, 0));
    MSMMeshBuilderAddFace(MBSL2, MSMFace(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
}
if(MSMMeshBuilderGetFaceCount(MBAL1) <= 0)
{
    MSMMeshBuilderAddVertex(MBAL1, Vector3(0, 0, 0));
    MSMMeshBuilderAddNormal(MBAL1, Vector3(0, 0, 0));
    MSMMeshBuilderAddTexcoord(MBAL1, Vector2(0, 0));
    MSMMeshBuilderAddColour(MBAL1, Vector4(0, 0, 0, 0));
    MSMMeshBuilderAddFace(MBAL1, MSMFace(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
}
if(MSMMeshBuilderGetFaceCount(MBAL2) <= 0)
{
    MSMMeshBuilderAddVertex(MBAL2, Vector3(0, 0, 0));
    MSMMeshBuilderAddNormal(MBAL2, Vector3(0, 0, 0));
    MSMMeshBuilderAddTexcoord(MBAL2, Vector2(0, 0));
    MSMMeshBuilderAddColour(MBAL2, Vector4(0, 0, 0, 0));
    MSMMeshBuilderAddFace(MBAL2, MSMFace(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
}

//Save Chunks
var arrMB1 = array_create(2); arrMB1[0] = MBSL1; arrMB1[1] = MBSL2;
var arrMB2 = array_create(2); arrMB2[0] = MBAL1; arrMB2[1] = MBAL2;              
//MSMModelSaveFromMeshBuilders(arrMB1, cachedLocation + "opaqueLayers.msm");
//MSMModelSaveFromMeshBuilders(arrMB2, cachedLocation + "translucentLayers.msm");

//Build Render Mesh
chunks[@ 0] = MSMModelBuildFromMeshBuilders(arrMB1, colChunks);
chunks[@ 1] = MSMModelBuildFromMeshBuilders(arrMB2, null);

//
arrMB1 = -1;           
arrMB2 = -1;

//
show_debug_message("Built Map Data! (tt: " + string(current_time-ct)+")");
