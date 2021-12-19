///MAMDrawBaseFrame(MAMModel, MAMSequencer);

var mamSeq = argument1;

//Check if BaseModel is not null...
if(argument0[0] != null)
{
    //It's not-null, so we're drawing MSM data.
    VertexSetFormat(global.VF_MSM);
    
    //Set stream, submit vertices to GPU for rendering
    VertexSetStream(0, argument0[0], 48);
    VertexSubmit(PrimitiveType.TriangleList, argument0[4]);
}
else
{   
    //Quick hack for fuclfiuaga
    var f;   
    if(argument1 != null)
        f = argument1[@ 5];
    
    shader_set(shdMAM);
    shader_set_uniform_f(shader_get_uniform(shdMAM, "uInterpolation"), 0.0);
    
    //It's null. We're drawing true MAM data.
    VertexSetFormat(global.VF_MAM);
    
    //Set Streams, submit vertices to GPU for rendering
    var streams = argument0[2];
    
    VertexSetStream(0, streams[f], 12);
    VertexSetStream(1, streams[f], 12);
    VertexSetStream(2, argument0[1], 36);
    
    VertexSubmit(PrimitiveType.TriangleList, argument0[4]);
    
    shader_set(shdMSM);
}
