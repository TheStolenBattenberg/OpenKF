///MSMBuildCollisionFromMeshBuilder(msmMeshBuilder);

//Build Mesh
var meshBuffer = buffer_create((12 * 3) * ds_list_size(argument0[4]), buffer_grow, 1);

for(var j = 0; j < MSMMeshBuilderGetFaceCount(argument0); ++j)
{
    //For each vertex in the face, write the data to the buffer.
    var face = MSMMeshBuilderGetFace(argument0, j);
    
    for(var k = 0; k < 3; ++k)
    {
        var V = MSMMeshBuilderGetVertex(argument0, face[k]);
        
        //Position
        buffer_write(meshBuffer, buffer_f32, V[0]);
        buffer_write(meshBuffer, buffer_f32, V[1]);
        buffer_write(meshBuffer, buffer_f32, V[2]);
    }
}

//Build Collision Shape
var cShape = CollisionShapeCreateTrimesh(meshBuffer, ds_list_size(argument0[4]));

//Delete duplicate buffer from memory
buffer_delete(meshBuffer);

return cShape;
