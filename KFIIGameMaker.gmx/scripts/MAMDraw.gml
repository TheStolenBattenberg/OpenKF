///MAMDraw(MAMModel, MAMSequencer);

var mamSeq = argument1;

//Set the render state for MAM Models
shader_set(shdMAM);

//When Animations = null, or Sequencer = null, Just draw the base
if(argument0[3] == null || argument1 == null)
{
    //Set the vertex format.
    VertexSetFormat(global.VF_MAM);
    
    //Set Base Stream
    VertexSetStream(0, argument0[0], 12);
    VertexSetStream(1, argument0[0], 12);
    VertexSetStream(2, argument0[1], 36);
    
    //Submit Streams for rendering
    VertexSubmit(PrimitiveType.TriangleList, argument0[4]);
    
    return true;
}

//When the above checks are false, we're drawing a real MAM baby...
shader_set_uniform_f(shader_get_uniform(shdMAM, "uInterpolation"), argument1[2]);

//Set the vertex format.
VertexSetFormat(global.VF_MAM);
  
//Set Frame Streams
var MAMStreams = argument0[2];  
VertexSetStream(0, MAMStreams[argument1[5]], 12);
VertexSetStream(1, MAMStreams[argument1[6]], 12);

//Set Base Stream
VertexSetStream(2, argument0[1], 36);

//Submit for rendering
VertexSubmit(PrimitiveType.TriangleList, argument0[4]);
