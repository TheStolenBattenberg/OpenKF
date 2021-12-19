///MAMModelBuildFromBuilder(MAMBuilder);

//Get data from MAM Builder
var arrMSMBuilder    = argument0[0];
var arrAnimationList = argument0[1];

var MAMModel = MAMModelCreate();

//
// Build Base Streams
//
var msmData, msmFace, msmC1, msmC2, msmC3, msmV, msmN, msmT, msmC;

//Calculate the size of our base model
var BasePSize = 0;
var BaseNTCSize = 0;
for(var i = 0; i < array_length_1d(arrMSMBuilder); ++i)
{
    msmData = arrMSMBuilder[i];
    BasePSize   += (36 * ds_list_size(msmData[4]));
    BaseNTCSize += (108 * ds_list_size(msmData[4]));
}

// Create two buffers... one for Position, one for Normal, Texcoord, Colour.
var MAMBasePBuffer   = buffer_create(BasePSize  , buffer_fixed, 1);
var MAMBaseNTCBuffer = buffer_create(BaseNTCSize, buffer_fixed, 1);

for(var i = 0; i < array_length_1d(arrMSMBuilder); ++i)
{
    //Get MSM Data from builder i
    msmData = arrMSMBuilder[i];
    
    //Get each opaque face from the MSMBuilder, and add write it to the buffers
    for(var j = 0; j < ds_list_size(msmData[4]); ++j)
    {
        //Get Face
        msmFace = MSMMeshBuilderGetFace(msmData, j);
        
        //Get each vertex of the face, and write it.
        for(var k = 0; k < 3; ++k)
        {
            //Get the Vertex, Normal and Texcoord vectors
            msmV = MSMMeshBuilderGetVertex(msmData, msmFace[(3 * 0) + k]);
            msmN = MSMMeshBuilderGetNormal(msmData, msmFace[(3 * 1) + k]);
            msmT = MSMMeshBuilderGetTexcoord(msmData, msmFace[(3 * 2) + k]); 
            msmC = MSMMeshBuilderGetColour(msmData, msmFace[(3 * 3) + k]);
            
            //Write the Position to MAMBasePBuffer
            buffer_write(MAMBasePBuffer, buffer_f32, msmV[0]);
            buffer_write(MAMBasePBuffer, buffer_f32, msmV[1]);
            buffer_write(MAMBasePBuffer, buffer_f32, msmV[2]);
            
            //Write the Normal, Texcoord, Colour to MAMBaseNTCBuffer
            //Normal
            buffer_write(MAMBaseNTCBuffer, buffer_f32, msmN[0]);
            buffer_write(MAMBaseNTCBuffer, buffer_f32, msmN[1]);
            buffer_write(MAMBaseNTCBuffer, buffer_f32, msmN[2]);
            
            //Texcoord
            buffer_write(MAMBaseNTCBuffer, buffer_f32, msmT[0]);
            buffer_write(MAMBaseNTCBuffer, buffer_f32, msmT[1]);
            
            //Colour
            buffer_write(MAMBaseNTCBuffer, buffer_f32, msmC[0]);
            buffer_write(MAMBaseNTCBuffer, buffer_f32, msmC[1]);
            buffer_write(MAMBaseNTCBuffer, buffer_f32, msmC[2]);
            buffer_write(MAMBaseNTCBuffer, buffer_f32, msmC[3]);
        }
    }
}

//Build MAM Model so far
MAMModel[@ 0] = VertexStreamCreate(BasePSize);      //Stream 0/1 Base Position
MAMModel[@ 1] = VertexStreamCreate(BaseNTCSize);    //Stream 2   Base Normal Texcoord Colour
MAMModel[@ 2] = null;
MAMModel[@ 3] = null;
MAMModel[@ 4] = BasePSize / 36;             //Number of primitives to be drawn...

//Fill the streams we just created...
VertexStreamFill(MAMModel[@ 0], MAMBasePBuffer);
VertexStreamFill(MAMModel[@ 1], MAMBaseNTCBuffer);

//Delete the now, memory clogging data...
buffer_delete(MAMBasePBuffer);
buffer_delete(MAMBaseNTCBuffer);

//
// Build Frame Streams
//

//If the animation list is null, we call it a day.
if(arrAnimationList == null)
{
    return MAMModel;
}

//Animations are generally only done on the first TMD Object, so we cache that here.
var MSMBuilder = arrMSMBuilder[0];

//It's big boi animation time...
var MAMStreamID   = 0;
var MAMStreams    = array_create(1);
var MAMAnimations = array_create(array_length_1d(arrAnimationList));
 
var MAMFrameBuffer = buffer_create(BasePSize, buffer_fixed, 1);

//Build each stream by looping through the animations.
for(var i = 0; i < array_length_1d(arrAnimationList); ++i)
{
    //Get MO Animation Data
    var arrMOAnim    = arrAnimationList[i];
    var arrMOFrames  = arrMOAnim[1];
    var arrMOTargets = arrMOAnim[2];
    
    //Create a structure to hold our MAM Frames
    var MAMFrames = array_create(arrMOAnim[0]);
    
    //Convert MO Animation to MAM Animation
    for(var j = 0; j < arrMOAnim[0]; ++j)
    {
        //Get Frame & Target data
        var arrMOFrame  = arrMOFrames[j];
        var arrMOTarget = arrMOTargets[j];
        
        //Loop through each face of the BaseMesh
        for(var k = 0; k < MSMMeshBuilderGetFaceCount(MSMBuilder); ++k)
        {
            //Get Face from MSMBuilder
            msmFace = MSMMeshBuilderGetFace(MSMBuilder, k);
            
            //Write each vertex
            BufferWriteVector3(MAMFrameBuffer, arrMOTarget[msmFace[0]]);
            BufferWriteVector3(MAMFrameBuffer, arrMOTarget[msmFace[1]]);
            BufferWriteVector3(MAMFrameBuffer, arrMOTarget[msmFace[2]]);
        }
        
        //Now the data has been written, we can create the stream and out frame structure...
        MAMStreams[MAMStreamID] = VertexStreamCreate(BasePSize);
        VertexStreamFill(MAMStreams[MAMStreamID], MAMFrameBuffer);
        
        //We reuse the same buffer all streams, so seek to the start of it.
        buffer_seek(MAMFrameBuffer, buffer_seek_start, 0);
        
        //Create the frame structure, fill with data.
        var MAMFrame = MAMFrameCreate();
            MAMFrame[0] = (1/60) * arrMOFrame[0];      //MO Stores it's framerates in 'percentage of animation' format. This 'might' convert them, idk.
            MAMFrame[1] = MAMStreamID;
        
        //Store this frame, increment stream ID
        MAMFrames[j] = MAMFrame;        
        MAMStreamID++;
    }
    
    //Create MAM Animation using the data we just collected...
    var MAMAnimation = MAMAnimationCreate();
        MAMAnimation[0] = array_length_1d(MAMFrames);
        MAMAnimation[1] = MAMFrames;
    
    MAMAnimations[i] = MAMAnimation;
}

//Delete buffer we used to make the streams.
buffer_delete(MAMFrameBuffer);

//Fill MAMModel with the animation data...
MAMModel[2] = MAMStreams;
MAMModel[3] = MAMAnimations;

//Clean up data we no longer need.
for(var i = 0; i < array_length_1d(arrMSMBuilder); ++i)
{
    //Get MSMData.
    msmData = arrMSMBuilder[i];
    
    //Clear DS Lists
    ds_list_clear(msmData[4]);
    ds_list_clear(msmData[3]);
    ds_list_clear(msmData[2]);
    ds_list_clear(msmData[1]);
    ds_list_clear(msmData[0]);
    
    //Delete DS Lists
    ds_list_destroy(msmData[4]);
    ds_list_destroy(msmData[3]);
    ds_list_destroy(msmData[2]);
    ds_list_destroy(msmData[1]);
    ds_list_destroy(msmData[0]);
    
    arrMSMBuilder[@ i] = -1
}
argument0 = -1;

//Finally, return our MAMModel.
return MAMModel;
