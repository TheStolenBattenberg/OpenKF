///MSMModelSaveFromMeshBuilders(msmMeshBuilders, outName);

var msmBuffer = null;
var msmBufferSize = 0;

//Calculate Buffer Size
msmBufferSize = 16;
for(var i = 0; i < array_length_1d(argument0); ++i)
    msmBufferSize += 4 + (144 * MSMMeshBuilderGetFaceCount(argument0[i]));
    
//Write MSM Header
msmBuffer = buffer_create(msmBufferSize, buffer_fixed, 1);
    buffer_write(msmBuffer, buffer_u32, $664D534D); //MagicID
    buffer_write(msmBuffer, buffer_u32, 1);         //Version
    buffer_write(msmBuffer, buffer_u32, 0);         //Flags
    buffer_write(msmBuffer, buffer_u32, array_length_1d(argument0));    //Mesh Count
    
//Write each mesh to MSM
for(var i = 0; i < array_length_1d(argument0); ++i)
{
    //Vertex Count
    buffer_write(msmBuffer, buffer_u32, 3 * MSMMeshBuilderGetFaceCount(argument0[i]));
    
    //Write Vertices
    for(var j = 0; j < MSMMeshBuilderGetFaceCount(argument0[i]); ++j)
    {
        //For each vertex in the face, write the data to the buffer.
        var face = MSMMeshBuilderGetFace(argument0[i], j);
        
        //Write all 3 vertices.
        for(var k = 0; k < 3; ++k)
        {
            var V = MSMMeshBuilderGetVertex(argument0[i], face[(3 * 0) + k]);
            var N = MSMMeshBuilderGetNormal(argument0[i], face[(3 * 1) + k]);
            var T = MSMMeshBuilderGetTexcoord(argument0[i], face[(3 * 2) + k]);
            var C = MSMMeshBuilderGetColour(argument0[i], face[(3 * 3) + k]);
            
            //Position
            buffer_write(msmBuffer, buffer_f32, V[0]);
            buffer_write(msmBuffer, buffer_f32, V[1]);
            buffer_write(msmBuffer, buffer_f32, V[2]);
            
            //Normal
            buffer_write(msmBuffer, buffer_f32, N[0]);
            buffer_write(msmBuffer, buffer_f32, N[1]);
            buffer_write(msmBuffer, buffer_f32, N[2]);
            
            //Texcoord
            buffer_write(msmBuffer, buffer_f32, T[0]);
            buffer_write(msmBuffer, buffer_f32, T[1]);
            
            //Colour
            buffer_write(msmBuffer, buffer_f32, C[0]);
            buffer_write(msmBuffer, buffer_f32, C[1]);
            buffer_write(msmBuffer, buffer_f32, C[2]);
            buffer_write(msmBuffer, buffer_f32, C[3]);
        }
    }
}

buffer_save(msmBuffer, argument1);
buffer_delete(msmBuffer);

return null;
