///MSMModelBuildFromMeshBuilders(msmMeshBuilders, outColliders);

var msmModel = MSMModelCreate();

for(var i = 0; i < array_length_1d(argument0); ++i)
{
    //Build Mesh
    var meshBuilder = argument0[i];
    var meshBuffer = buffer_create(144 * MSMMeshBuilderGetFaceCount(meshBuilder), buffer_fixed, 1);
    
    for(var j = 0; j < MSMMeshBuilderGetFaceCount(meshBuilder); ++j)
    {
        //For each vertex in the face, write the data to the buffer.
        var face = MSMMeshBuilderGetFace(meshBuilder, j);
        
        for(var k = 0; k < 3; ++k)
        {
            var V = MSMMeshBuilderGetVertex(meshBuilder, face[(3 * 0) + k]);
            var N = MSMMeshBuilderGetNormal(meshBuilder, face[(3 * 1) + k]);
            var T = MSMMeshBuilderGetTexcoord(meshBuilder, face[(3 * 2) + k]);
            var C = MSMMeshBuilderGetColour(meshBuilder, face[(3 * 3) + k]);
            
            //Position
            buffer_write(meshBuffer, buffer_f32, V[0]);
            buffer_write(meshBuffer, buffer_f32, V[1]);
            buffer_write(meshBuffer, buffer_f32, V[2]);
            
            //Normal
            buffer_write(meshBuffer, buffer_f32, N[0]);
            buffer_write(meshBuffer, buffer_f32, N[1]);
            buffer_write(meshBuffer, buffer_f32, N[2]);
            
            //Texcoord
            buffer_write(meshBuffer, buffer_f32, T[0]);
            buffer_write(meshBuffer, buffer_f32, T[1]);
            
            //Colour
            buffer_write(meshBuffer, buffer_f32, C[0]);
            buffer_write(meshBuffer, buffer_f32, C[1]);
            buffer_write(meshBuffer, buffer_f32, C[2]);
            buffer_write(meshBuffer, buffer_f32, C[3]);
        }
    }
    
    //Create/Fill Vertex Stream
    var msmMesh = array_create(2);
        msmMesh[0] = VertexStreamCreate(buffer_get_size(meshBuffer));
        msmMesh[1] = MSMMeshBuilderGetFaceCount(meshBuilder);
        
        VertexStreamFill(msmMesh[0], meshBuffer);
        
    msmModel[i] = msmMesh;

    //Collision Shapes
    if(argument1 != null)
    {
        argument1[@ i] = CollisionShapeCreateTrimesh(meshBuffer, 12, MSMMeshBuilderGetFaceCount(meshBuilder));
    }
    
    //Delete duplicate buffer from memory
    buffer_delete(meshBuffer);
    
    //Clean up MeshBuilder data
    ds_list_destroy(meshBuilder[0]);
    ds_list_destroy(meshBuilder[1]);
    ds_list_destroy(meshBuilder[2]);
    ds_list_destroy(meshBuilder[3]);
    ds_list_destroy(meshBuilder[4]);
    
}

return msmModel;
