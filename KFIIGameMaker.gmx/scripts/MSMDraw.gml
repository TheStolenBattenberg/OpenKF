///MSMDraw(msmModel);

VertexSetFormat(global.VF_MSM);

//Draw Each Mesh
for(var i = 0; i < array_length_1d(argument0); ++i)
{
    //Fetch Mesh
    var msmMesh = argument0[i];
       
    //Set up streams
    VertexSetStream(0, msmMesh[0], 48);
    VertexSubmit(PrimitiveType.TriangleList, msmMesh[1]);
}
