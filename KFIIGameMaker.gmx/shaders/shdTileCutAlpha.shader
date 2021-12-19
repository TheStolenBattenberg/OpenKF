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
    float2 vWPos     : TEXCOORD2;
};

VertexOut main(in VertexIn IN)
{
    VertexOut OUT;
    
        OUT.vPosition = mul(gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION], float4(IN.vPosition, 1.0));
        OUT.vNormal   = normalize(IN.vNormal);
        OUT.vTexcoord = IN.vTexcoord;
        OUT.vColour   = IN.vColour;
    
        OUT.vViewPos  = mul(gm_Matrices[MATRIX_WORLD_VIEW], float4(IN.vPosition, 1.0)).xyz;
        OUT.vWPos     = (mul(gm_Matrices[MATRIX_WORLD], float4(IN.vPosition, 1.0)).xz + float2(0.5,0.5)) / float2(80.0, 80.0);
    return OUT;
}
//######################_==_YOYO_SHADER_MARKER_==_######################@~struct PixelIn {
    float3 vNormal   : NORMAL0;
    float2 vTexcoord : TEXCOORD0;
    float4 vColour   : COLOR0;
    float3 vViewPos  : TEXCOORD1;
    float2 vWPos     : TEXCOORD2;
};

struct PixelOut {
    float4 Colour : COLOR0;
};

uniform sampler sLightmap;
uniform int uLayer;

PixelOut main(in PixelIn IN) {
    PixelOut OUT;   
        
        clip(IN.vColour.a < 0.95 ? -1.0 : 1.0);
             
        float2 LMCoord = IN.vWPos;
        float  LMVal = 0.0;
        
        if(uLayer < 0.95)
        {
            LMVal = tex2D(sLightmap, LMCoord).r;
        }else
        if(uLayer > 0.96)
        {
            LMVal = tex2D(sLightmap, LMCoord).g;
        }
        
        float fogDistance = length(IN.vViewPos);
        float fogAmount   = smoothstep(6, 11, fogDistance);
        
        OUT.Colour = lerp(float4((IN.vColour * tex2D(gm_BaseTexture, IN.vTexcoord)).rgb * LMVal, 1.0), float4(0.0, 0.0, 0.0, 1.0), fogAmount);
    return OUT;
}

