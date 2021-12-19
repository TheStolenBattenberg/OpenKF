//
// Simple passthrough vertex shader
//
attribute vec3 in_Position;                  // (x,y,z)
attribute vec2 in_TextureCoord;              // (u,v)

varying vec2 v_vTexcoord;

void main()
{
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1.0);
    
    v_vTexcoord = in_TextureCoord;
}

//######################_==_YOYO_SHADER_MARKER_==_######################@~//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;

uniform vec2 uMaxCoord;

void main()
{
    vec4 Colour = vec4(0, 0, 0, clamp(uMaxCoord.x/2.0, 0.0, 0.5));
    if(v_vTexcoord.x < uMaxCoord.x)
    {
        Colour = texture2D(gm_BaseTexture, v_vTexcoord);
    }
       
    gl_FragColor = Colour;
}

