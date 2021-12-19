///VertexSubmit(primitiveType, primitiveCount);
gml_pragma("forceinline");

enum PrimitiveType
{
    PointList = 1,
    LineList = 2,
    LineStrip = 3,
    TriangleList = 4,
    TriangleStrip = 5,
    TriangleFan = 6
}

return external_call(global.dexVertexSubmit, argument0, argument1);
