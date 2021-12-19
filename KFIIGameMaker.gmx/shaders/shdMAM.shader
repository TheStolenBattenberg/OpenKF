struct VertexIn {
    float3 vPosition1 : POSITION0;
    float3 vPosition2 : POSITION1;
    float3 vNormal    : NORMAL0;
    float2 vTexcoord  : TEXCOORD0;
    float4 vColour    : COLOR0;
};

struct VertexOut {
    float4 vPosition : POSITION;
    float3 vNormal   : NORMAL0;
    float2 vTexcoord : TEXCOORD0;
    float4 vColour   : COLOR0;
    float3 vViewPos  : TEXCOORD1;
};

uniform float uInterpolation;
uniform int   uMethod;

float3 CosLerp(float3 A, float3 B, float T)
{
    float T2;
    
    T2 = (1.0 - cos(T * 3.14159265)) / 2.0; 
    return (A * (1.0 - T2) + B * T2);
}

VertexOut main(in VertexIn IN)
{
    VertexOut OUT;
        
        float4 V = float4(CosLerp(IN.vPosition1, IN.vPosition2, uInterpolation), 1.0);
        //float4 V = float4(smoothstep(IN.vPosition1, IN.vPosition2, uInterpolation), 1.0);
        //float4 V = float4(lerp(IN.vPosition1, IN.vPosition2, uInterpolation), 1.0);
    
        OUT.vPosition = mul(gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION], V);
        OUT.vNormal   = normalize(IN.vNormal);
        OUT.vTexcoord = IN.vTexcoord;
        OUT.vColour   = IN.vColour;
           
        OUT.vViewPos  = mul(gm_Matrices[MATRIX_WORLD_VIEW], V).xyz;
    return OUT;
}
//######################_==_YOYO_SHADER_MARKER_==_######################@~struct PixelIn {
    float3 vNormal   : NORMAL0;
    float2 vTexcoord : TEXCOORD0;
    float4 vColour   : COLOR0;
    float3 vViewPos  : TEXCOORD1;
};

struct PixelOut {
    float4 Colour : COLOR0;
};

PixelOut main(in PixelIn IN) {
    PixelOut OUT;       
        float fogDistance = length(IN.vViewPos);
        float fogAmount   = smoothstep(6, 11, fogDistance);
    
        float4 texC = tex2D(gm_BaseTexture, IN.vTexcoord);
        
        OUT.Colour =  lerp(IN.vColour * texC, float4(0.0, 0.0, 0.0, 1.0), fogAmount);
    return OUT;
}
