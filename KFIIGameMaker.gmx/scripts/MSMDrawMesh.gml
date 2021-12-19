///MSMDrawMesh(msmModel, meshID);

VertexSetFormat(global.VF_MSM);

var msmMesh = argument0[argument1];

VertexSetStream(0, msmMesh[0], 48);
VertexSubmit(PrimitiveType.TriangleList, msmMesh[1]);
