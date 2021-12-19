///MOLoadFromBufferUVOffset(buffer, offset, uOff, vOff, pID);

//Store buffer/offset in temporary variables
var moBuffer = argument0;
var moOffset = argument1;

//Make sure we are at the required offset
buffer_seek(moBuffer, buffer_seek_start, moOffset);

// Start reading data as MO

//
// Read Header
//
var moEoF   = moOffset + buffer_read(moBuffer, buffer_u32);    //EoF for MO
var numAnim = buffer_read(moBuffer, buffer_u32);               //Number of animations
var offTMD  = moOffset + buffer_read(moBuffer, buffer_u32);    //Offset to TMD
var offMTs  = moOffset + buffer_read(moBuffer, buffer_u32);    //Offset to Morph Target Table
var offAT   = moOffset + buffer_read(moBuffer, buffer_u32);    //Offset to Animation Table

var mamBuilder = MAMBuilderCreate();

//
// Read TMD
//
var msmData = TMDLoadFromBufferUVOffset(moBuffer, offTMD, argument2, argument3, argument4);

if(numAnim == 0)
{
    //This is a static MAM.
    mamBuilder[@ 0] = msmData;
    mamBuilder[@ 1] = null;
    
    return mamBuilder;
}

//Make sure TMD only had 1 mesh
if(array_length_1d(msmData) > 1)
{
    show_debug_message("MO::TMD Object count greater than 1.");  
    return null;
}

var msmMeshBuilder = msmData[0];

mamBuilder[@ 0] = msmData;

msmData = -1;

//Copy TMD vertices to array...
var tmdVertData = array_create(ds_list_size(msmMeshBuilder[0]));
for(var i = 0; i < ds_list_size(msmMeshBuilder[0]); ++i)
{
    tmdVertData[i] = ds_list_find_value(msmMeshBuilder[0], i);
}

//
// Read Animation Table
//
var animTable = array_create(numAnim);

buffer_seek(moBuffer, buffer_seek_start, offAT);
for(var i = 0; i < numAnim; ++i)
{
    animTable[i] = moOffset + buffer_read(moBuffer, buffer_u32);
}

//
// Read Animations - This is HELL!
//
var animations = array_create(numAnim);

for(var i = 0; i < numAnim; ++i)
{
    //Seek to location of animation data
    buffer_seek(moBuffer, buffer_seek_start, animTable[i]);
    
    //Read animation frame count
    var numFrame  = buffer_read(moBuffer, buffer_u32);
    var anim = array_create(3);
        anim[0] = numFrame;

    var frames = array_create(numFrame);
        
    //Read each animation frame... (Fuck me...)
    var curOff = buffer_tell(moBuffer);
    for(var j = 0; j < numFrame; ++j)
    {        
        buffer_seek(moBuffer, buffer_seek_start, curOff);
        
        //Offset to frame data... Fuck off with these offsets FromSoft.
        var frameOff = moOffset + buffer_read(moBuffer, buffer_u32);
        
        //READ FRAME, FINALLY
        buffer_seek(moBuffer, buffer_seek_start, frameOff);
        
        var frame = array_create(4);
        
        buffer_read(moBuffer, buffer_u16);                     //Useless padding. Thanks Eiichi :)
        frame[0] = buffer_read(moBuffer, buffer_s16) / 4096;   //How long this frame takes to complete
        frame[1] = buffer_read(moBuffer, buffer_u16);          //Morph Target to use
        frame[2] = buffer_read(moBuffer, buffer_u16);          //Num Morph Targets in journey
        
        //What the hell is this crap?
        var journey = null;
        
        if(frame[2] > 0)
        {
            journey = array_create(frame[2]);

            for(var k = 0; k < frame[2]; ++k)
            {
                journey[k] = buffer_read(moBuffer, buffer_u16); //Each entry is a Morph Target ID.
            }
        }
        
        frame[3] = journey;        
        frames[j] = frame;
        
        //Incrememnt curOff to point at the next frame.
        curOff += 4;
    } 
    
    anim[1] = frames;
    anim[2] = null;
    
    animations[i] = anim;
}

//
// Read Morph Target Table
//
buffer_seek(moBuffer, buffer_seek_start, offMTs);

//Calculate number of morph targets
var numMT = ((moOffset + buffer_read(moBuffer, buffer_u32)) - offMTs) / 4;

var mtTable = array_create(numMT);

buffer_seek(moBuffer, buffer_seek_relative, -4);
for(var i = 0; i < numMT; ++i)
{
    mtTable[i] = moOffset + buffer_read(moBuffer, buffer_u32);
}

//
// Read MT's using animation
//
for(var i = 0; i < numAnim; ++i)
{
    
    var anim    = animations[i];
    var frames  = anim[1];
    var targets = array_create(1);
    
    //We go through each frame, to load it's targets.
    for(var j = 0; j < anim[0]; ++j)
    {     
        var frame  = frames[j];
        var journey = frame[3];
        
        var target = null;
        
        //When only two frames exist, we don't bother with the expensive copy.
        if(anim[0] == 2)
        {
            target = MODecompressMorphTarget(moBuffer, mtTable[frame[1]], tmdVertData);
        }
        //When only 1 frame exists, throw the base frame in too buffer in too...
        else if(anim[0] = 1)
        {
            anim[@ 0] = 2;
            targets[0] = tmdVertData;
            targets[1] = MODecompressMorphTarget(moBuffer, mtTable[frame[1]], tmdVertData);
            frames[@ 1] = frames[0];
            
            break;
        }
        else{
            //First, load the journey when there is one... Otherwise, just throw the base frame in with the base target.
            if(frame[2] == 0)
            {
                target = MODecompressMorphTarget(moBuffer, mtTable[frame[1]], tmdVertData);
            }else
            {
                //When we do have a journey we need to start blending ALL the frames together... Starting with the TMDBaseFrame
                target = MODecompressMorphTarget(moBuffer, mtTable[frame[1]], tmdVertData);       
                  
                for(var k = 0; k < frame[2]; ++k)
                {
                    target = MODecompressMorphTarget(moBuffer, mtTable[journey[k]], target);
                }  
            }        
        }

        targets[j] = target;
    }
    
    anim[@ 2] = targets;
}

mamBuilder[1] = animations;

return mamBuilder;
