///MSMFree(msmModel);

//Draw Each Mesh
for(var i = 0; i < array_length_1d(argument0); ++i)
{
    //Fetch Mesh
    var msmMesh = argument0[i];
       
    VertexStreamFree(msmMesh[0]);
    msmMesh = -1;
    argument0[i] = -1;
}

argument0 = -1;
