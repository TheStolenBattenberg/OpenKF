///MOLoadFromBuffer(buffer, offset);

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
var offMT   = moOffset + buffer_read(moBuffer, buffer_u32);    //Offset to Morph Target Table
var offAT   = moOffset + buffer_read(moBuffer, buffer_u32);    //Offset to Animation Table

//
// Read TMD
//
var mamBuilder = MAMBuilderCreate();

var msmData = TMDLoadFromBuffer(moBuffer, offTMD);
var msmMesh = msmData[0];

//If animation count is 0 this is a static MO
if(numAnim == 0)
{
    mamBuilder[@ 0] = msmData;
    mamBuilder[@ 1] = null; 
       
    return mamBuilder;
}

//Copy TMD vertices from Object #0 to an array
var arrTMDVertexBase = array_create(ds_list_size(msmMesh[0]));
for(var i = 0; i < ds_list_size(msmMesh[0]); ++i)
    arrTMDVertexBase[i] = ds_list_find_value(msmMesh[0], i);

//
// Read Animation Table
//
buffer_seek(moBuffer, buffer_seek_start, offAT);

var arrAnimationOffset = array_create(numAnim);
for(var i = 0; i < numAnim; ++i)
    arrAnimationOffset[i] = moOffset + buffer_read(moBuffer, buffer_u32);

//
// Read Morph Target Table
//
buffer_seek(moBuffer, buffer_seek_start, offMT);

//Calculate Morph Target Count
var numTarget = ((moOffset + buffer_read(moBuffer, buffer_u32)) - offMT) / 4;
buffer_seek(moBuffer, buffer_seek_relative, -4);

//Read Table
var arrTargetOffset = array_create(numTarget);
for(var i = 0; i < numTarget; ++i)
    arrTargetOffset[i] = moOffset + buffer_read(moBuffer, buffer_u32);

//
// Read Animations
//
var arrAnimationList = array_create(numAnim);

for(var i = 0; i < numAnim; ++i)
{
    //Seek to the location of the animation data
    buffer_seek(moBuffer, buffer_seek_start, arrAnimationOffset[i]);
    
    //Read animation frame count.
    var animFrameCount = buffer_read(moBuffer, buffer_u32);
    var animFrame      = array_create(animFrameCount);
    
    //Read each frame of the animation
    for(var j = 0; j < animFrameCount; ++j)
    {
        //Seek to the location of the frame data...
        buffer_seek(moBuffer, buffer_seek_start, (arrAnimationOffset[i] + 4) + 4 * j);  
        
        //Seek to the location of the frame, and read it's data
        buffer_seek(moBuffer, buffer_seek_start, moOffset + buffer_read(moBuffer, buffer_u32));
        
        //Frame Header
        buffer_read(moBuffer, buffer_u16);  //Padding...
        
        var arrFrame = array_create(4);
            arrFrame[0] = buffer_read(moBuffer, buffer_s16) / 4096; //Frame Length...
            arrFrame[1] = buffer_read(moBuffer, buffer_u16);        //Frame Target
            arrFrame[2] = buffer_read(moBuffer, buffer_u16);        //Number of targets in the journey to this one.
            arrFrame[3] = null;
           
        //Frame Journey
        var arrJourney = null;
        if(arrFrame[2] > 0)
        {
            arrJourney = array_create(arrFrame[2]);
            for(var k = 0; k < arrFrame[2]; ++k)
            {
                arrJourney[k] = buffer_read(moBuffer, buffer_u16);
            }
        }
        
        arrFrame[3]  = arrJourney;
        animFrame[j] = arrFrame;
    }
    
    var arrAnimation = array_create(3);
        arrAnimation[0] = animFrameCount;   //Frame Count
        arrAnimation[1] = animFrame;        //Frames
        arrAnimation[2] = null;             //Morph Targets
        
    arrAnimationList[i] = arrAnimation;
}

//
// Read Morph Targets (using animations)
//
for(var i = 0; i < numAnim; ++i)
{
    //Get Information from each animation
    var arrAnimation = arrAnimationList[i];
    var arrFrames    = arrAnimation[1];
    
    //Read Targets
    var arrTargetList = array_create(1);
    
    //Shift all current animation frames forward
    for(var j = arrAnimation[0]-1; j >= 0; --j)
    {
        arrFrames[j + 1] = arrFrames[j];
    }
    
    //Store base TMD as Target 0
    arrTargetList[0] = arrTMDVertexBase;
        
    //Copy Frame 1 To Frame 0
    arrFrames[0] = arrFrames[1];        
    
    //Build Morph Targets, storing them after the Base TMD (1 + j)
    for(var j = 0; j < arrAnimation[0]; ++j)
    {
        var arrFrame   = arrFrames[1+j];
        var arrJourney = arrFrame[3];
        
        //Copy vertices from base frame into a new array...
        var arrTarget = array_create(array_length_1d(arrTMDVertexBase));
        array_copy(arrTarget, 0, arrTMDVertexBase, 0, array_length_1d(arrTMDVertexBase));
        
        //If a journey is present, blend all the vertices into our copied base buffer
        for(var k = 0; k < arrFrame[2]; ++k)
        {
            arrTarget = MODecompressMorphTarget(moBuffer, arrTargetOffset[arrJourney[k]], arrTarget);
        }
        
        //Blend the primary target with the calculated target so far.        
        arrTargetList[1+j] = MODecompressMorphTarget(moBuffer, arrTargetOffset[arrFrame[1]], arrTarget);
    }    
        
    //Store changed information into animation structure
    arrAnimation[0] = arrAnimation[0] + 1;
    arrAnimation[1] = arrFrames;
    arrAnimation[2] = arrTargetList;
    
    arrAnimationList[i] = arrAnimation;
}

mamBuilder[0] = msmData;
mamBuilder[1] = arrAnimationList;

return mamBuilder;
