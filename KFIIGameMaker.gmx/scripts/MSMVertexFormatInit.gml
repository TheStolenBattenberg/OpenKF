///MSMVertexFormatInit();

VertexFormatAdd(0, 0,  VertexElementType.Float3, VertexElementUsage.Position, 0);   //Position of Vertex
VertexFormatAdd(0, 12, VertexElementType.Float3, VertexElementUsage.Normal,   0);   //Normal of Vertex
VertexFormatAdd(0, 24, VertexElementType.Float2, VertexElementUsage.Texcoord, 0);   //Texcoord of Vertex
VertexFormatAdd(0, 32, VertexElementType.Float4, VertexElementUsage.Colour,   0);   //Colour of Vertex
global.VF_MSM = VertexFormatCreate();
