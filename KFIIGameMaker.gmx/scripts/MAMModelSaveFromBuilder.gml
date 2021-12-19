///MAMModelSaveFromBuilder(MAMBuilder, filename);

//Get data from MAM Builder
var arrMSMBuilder    = argument0[0];
var arrAnimationList = argument0[1];

//
// Calculate the size of the MAM
//
var MAMFileSize = 20;   //The initial 16 Bytes of header...

//Calculate the size of the P and NTC Buffers
var BasePSize   = 0;
var BaseNTCSize = 0;
for(var i = 0; i < array_length_1d(arrMSMBuilder); ++i)
{
    BasePSize   += (36  * MSMMeshBuilderGetFaceCount(arrMSMBuilder[i]));
    BaseNTCSize += (108 * MSMMeshBuilderGetFaceCount(arrMSMBuilder[i]));
}

//We know there is always 1 PBuffer and 1 NTCBuffer, and 4 Bytes for the number of vertices...
MAMFileSize += 4;
MAMFileSize += BasePSize;
MAMFileSize += BaseNTCSize;

//When we have animations, we also need to add the size of that data...
if(arrAnimationList != null)
{
    for(var i = 0; i < array_length_1d(arrAnimationList); ++i)
    {
        //Get Animation From the List
        var arrMOAnim = arrAnimationList[i];
        
        //Add the data length of each frame...
        MAMFileSize += (4 + BasePSize) * array_length_1d(arrMOAnim[2]);
        
        //Add the data length of each animation
        MAMFileSize += 4;
    }
}

//
// Begin Writing MAM File
//
var MAMBuffer = buffer_create(MAMFileSize, buffer_fixed, 1);

//
// Header
//
buffer_write(MAMBuffer, buffer_u32, $664D414D);                 //Magic ID
buffer_write(MAMBuffer, buffer_u32, 1);                         //Version

if(arrAnimationList == null)
{
    buffer_write(MAMBuffer, buffer_u32, 1);                                 //Flags... 1 = Static
    buffer_write(MAMBuffer, buffer_u32, 0);                                 //Animation Count
}else{
    buffer_write(MAMBuffer, buffer_u32, 0);                                 //Flags... 0 = Animated
    buffer_write(MAMBuffer, buffer_u32, array_length_1d(arrAnimationList)); //Animation Count
}

//
// Write Base Streams
//
buffer_write(MAMBuffer, buffer_u32, BasePSize / 12); //Vertex Count

//We use poke to write the data, so we need the base offset of each base parts data.
var POffset   = buffer_tell(MAMBuffer);
var NTCOffset = POffset + BasePSize;

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
            buffer_poke(MAMBuffer, POffset+ 0, buffer_f32, msmV[0]);
            buffer_poke(MAMBuffer, POffset+ 4, buffer_f32, msmV[1]);
            buffer_poke(MAMBuffer, POffset+ 8, buffer_f32, msmV[2]);
            POffset += 12;
            
            //Write the Normal, Texcoord, Colour to MAMBaseNTCBuffer
            //Normal
            buffer_poke(MAMBuffer, NTCOffset+ 0, buffer_f32, msmN[0]);
            buffer_poke(MAMBuffer, NTCOffset+ 4, buffer_f32, msmN[1]);
            buffer_poke(MAMBuffer, NTCOffset+ 8, buffer_f32, msmN[2]);
            buffer_poke(MAMBuffer, NTCOffset+12, buffer_f32, msmT[0]);
            buffer_poke(MAMBuffer, NTCOffset+16, buffer_f32, msmT[1]);
            buffer_poke(MAMBuffer, NTCOffset+20, buffer_f32, msmC[0]);
            buffer_poke(MAMBuffer, NTCOffset+24, buffer_f32, msmC[1]);
            buffer_poke(MAMBuffer, NTCOffset+28, buffer_f32, msmC[2]);
            buffer_poke(MAMBuffer, NTCOffset+32, buffer_f32, msmC[3]);
            NTCOffset += 36;
        }
    }
}

//After all that poking, we need to seek the the 'end'.
buffer_seek(MAMBuffer, buffer_seek_start, POffset + BaseNTCSize);

//If the animation list is null, we call it a day.
if(arrAnimationList == null)
{
    buffer_write(MAMBuffer, buffer_u32, $59584553);
    buffer_save(MAMBuffer, argument1);  //Save buffer to the predetermined file name...
    buffer_delete(MAMBuffer);           //Don't need this floating around in memory forever.
    return true;
}

//
// Write Animations
//

//Animations are generally only done on the first TMD Object, so we cache that here.
var MSMBuilder = arrMSMBuilder[0];

//Build each stream by looping through the animations.
for(var i = 0; i < array_length_1d(arrAnimationList); ++i)
{
    //Get MO Animation Data
    var arrMOAnim    = arrAnimationList[i];
    var arrMOFrames  = arrMOAnim[1];
    var arrMOTargets = arrMOAnim[2];
    
    //Write Animation frame count
    buffer_write(MAMBuffer, buffer_u32, arrMOAnim[0]);
    
    //Convert MO Animation to MAM Animation
    for(var j = 0; j < arrMOAnim[0]; ++j)
    {
        //Get Frame & Target data
        var arrMOFrame  = arrMOFrames[j];
        var arrMOTarget = arrMOTargets[j];
        
        //Write Frame Interpolation Increment
        buffer_write(MAMBuffer, buffer_f32, (1/60) * arrMOFrame[0]);
        
        //Loop through each face of the BaseMesh
        for(var k = 0; k < MSMMeshBuilderGetFaceCount(MSMBuilder); ++k)
        {
            //Get Face from MSMBuilder
            msmFace = MSMMeshBuilderGetFace(MSMBuilder, k);
            
            //Write each vertex
            BufferWriteVector3(MAMBuffer, arrMOTarget[msmFace[0]]);
            BufferWriteVector3(MAMBuffer, arrMOTarget[msmFace[1]]);
            BufferWriteVector3(MAMBuffer, arrMOTarget[msmFace[2]]);
        }
    }
}

//Write SEXY
buffer_write(MAMBuffer, buffer_u32, $59584553);
buffer_save(MAMBuffer, argument1);  //Save buffer to the predetermined file name...
buffer_delete(MAMBuffer);           //Don't need this floating around in memory forever.

return true;
