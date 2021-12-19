///MAMVertexFormatInit();

//Stride = 60

VertexFormatAdd(0, 0,  VertexElementType.Float3, VertexElementUsage.Position, 0);   //Frame 1 Vertex
VertexFormatAdd(1, 0,  VertexElementType.Float3, VertexElementUsage.Position, 1);   //Frame 2 Vertex
VertexFormatAdd(2, 0,  VertexElementType.Float3, VertexElementUsage.Normal,   0);   //Normal of Vertex
VertexFormatAdd(2, 12, VertexElementType.Float2, VertexElementUsage.Texcoord, 0);   //Texcoord of Vertex
VertexFormatAdd(2, 20, VertexElementType.Float4, VertexElementUsage.Colour,   0);   //Colour of Vertex

global.VF_MAM = VertexFormatCreate();
