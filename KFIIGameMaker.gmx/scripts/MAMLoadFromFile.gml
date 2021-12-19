///MAMLoadFromFile(mamFile);

var mamBuffer = buffer_load(argument0);
var mamModel  = MAMModelCreate();

//
// Header
//
var magicID = buffer_read(mamBuffer, buffer_u32);
var version = buffer_read(mamBuffer, buffer_u32);
var flags   = buffer_read(mamBuffer, buffer_u32);
var numAnim = buffer_read(mamBuffer, buffer_u32);

if(magicID != $664D414D)    //MAMf
{
    show_debug_message("Invalid MAM magic ID");
    return null;
}

if(version != 1)
{
    show_debug_message("Invalid MAM version (not v1)");
    return null;
}

//
// Read MAMBase Mesh
//
var numVertex = buffer_read(mamBuffer, buffer_u32);

//Set number of primitives in the MAM Data
mamModel[4] = numVertex / 3;

//Read PStream
mamModel[0] = VertexStreamCreate(12 * numVertex);
VertexStreamFillFrom(mamModel[0], mamBuffer, buffer_tell(mamBuffer), (12*numVertex));
buffer_seek(mamBuffer, buffer_seek_relative, (12*numVertex));

//Read NTCStream
mamModel[1] = VertexStreamCreate(36 * numVertex);
VertexStreamFillFrom(mamModel[1], mamBuffer, buffer_tell(mamBuffer), (36*numVertex));
buffer_seek(mamBuffer, buffer_seek_relative, (36*numVertex));

//Animated MAM?
if((flags & $1) == 0)
{
    var MAMAnimations = array_create(numAnim);
    var MAMStreams    = array_create(1);
    
    var numStream = 0;
    
    //Read Each Animation from the file.
    for(var i = 0; i < numAnim; ++i)
    {
        var frameCount = buffer_read(mamBuffer, buffer_u32);
        
        var MAMFrames = array_create(frameCount);
        
        //Read each frame from the file.
        for(var j = 0; j < frameCount; ++j)
        {
            //Create MAM Frame
            var MAMFrame = MAMFrameCreate();
                MAMFrame[0] = buffer_read(mamBuffer, buffer_f32);
                MAMFrame[1] = numStream;
                
            //Copy VB for frame stream
            MAMStreams[numStream] = VertexStreamCreate(12 * numVertex);
            VertexStreamFillFrom(MAMStreams[numStream], mamBuffer, buffer_tell(mamBuffer), 12 * numVertex);
            buffer_seek(mamBuffer, buffer_seek_relative, (12*numVertex));
            
            numStream++;
            MAMFrames[j] = MAMFrame;
        }
        
        var MAMAnimation = MAMAnimationCreate();
            MAMAnimation[0] = frameCount;
            MAMAnimation[1] = MAMFrames;
          
        MAMAnimations[i] = MAMAnimation;
    }
    
    mamModel[2] = MAMStreams;
    mamModel[3] = MAMAnimations;
}

//
// Clean up
//
buffer_delete(mamBuffer);

return mamModel;
