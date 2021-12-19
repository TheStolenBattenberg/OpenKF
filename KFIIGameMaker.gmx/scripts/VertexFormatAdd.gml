///VertexFormatAdd(streamID, offset, type, usage, slot);
gml_pragma("forceinline");

enum VertexElementType
{
    Float1 = 0,
    Float2 = 1,
    Float3 = 2,
    Float4 = 3,
    Colour = 4,
    UByte4 = 5,
    Short2 = 6,
    Short4 = 7
}

enum VertexElementUsage
{
    Position     = 0,
    BlendWeight  = 1,
    BlendIndices = 2,
    Normal       = 3,
    PointSize    = 4,
    Texcoord     = 5,
    Tangent      = 6,
    Binormal     = 7,
    TessFactor   = 8,
    PositionT    = 9,
    Colour       = 10,
    Fog          = 11,
    Depth        = 12,
    Sample       = 13 
}

return external_call(global.dexVertexFormatAdd, argument0, argument1, argument2, 0, argument3, argument4);
