struct VertexIn {
    float3 vPosition : POSITION0;
    float3 vNormal   : NORMAL0;
    float2 vTexcoord : TEXCOORD0;
    float4 vColour   : COLOR0;
};

struct VertexOut {
    float4 vPosition : POSITION;
    float3 vNormal   : NORMAL0;
    float2 vTexcoord : TEXCOORD0;
    float4 vColour   : COLOR0;
    float3 vViewPos  : TEXCOORD1;
};

VertexOut main(in VertexIn IN)
{
    VertexOut OUT;
    
        OUT.vPosition = mul(gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION], float4(IN.vPosition, 1.0));
        OUT.vNormal   = normalize(IN.vNormal);
        OUT.vTexcoord = IN.vTexcoord;
        OUT.vColour   = IN.vColour;

        OUT.vViewPos  = mul(gm_Matrices[MATRIX_WORLD_VIEW], float4(IN.vPosition, 1.0)).xyz;
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
        
        //Calculate Final Colour
        float4 FinalColour = float4((IN.vColour.rgb * texC.rgb), IN.vColour.a);    
        
        OUT.Colour =  lerp(FinalColour, float4(0.0, 0.0, 0.0, 1.0), fogAmount);
    return OUT;
}

