///MAMModelSaveFromBuilder(MAMBuilder, filename);

var builderBase = argument0[0];
var builderAnim = argument0[1];

var MAMModel = MAMModelCreate();

//Is this to be a static, or normal MAM?
if(builderAnim == null)
{
    //Calculate the size of the static MAM    
    var MAMSize = 16;    
    for(var i = 0; i < array_length_1d(builderBase); ++i)
    {
        var msmData = builderBase[i];
        
        MAMSize += 4 + (144 * ds_list_size(msmData[4]));
    }
    
    //Build Static MSM
    var MSMBaseBuffer = buffer_create(MAMSize, buffer_fixed, 1);
    
    //Write Header
    buffer_write(MSMBaseBuffer, buffer_u32, $664D414D);
    buffer_write(MSMBaseBuffer, buffer_u32, 1);
    buffer_write(MSMBaseBuffer, buffer_u32, 1);
    buffer_write(MSMBaseBuffer, buffer_u32, array_length_1d(array_length_1d(builderBase))); //Used as Mesh Count with Static MAM. Exactly the same as MSM.
    
    //Write Each Mesh
    for(var i = 0; i < array_length_1d(builderBase); ++i)
    {
        buffer_write(MSMBaseBuffer, buffer_u32, 3 * ds_list_size(msmData[4]));
        
        var msmData = builderBase[i];
        
        //Write Opaque Data First
        for(var j = 0; j < ds_list_size(msmData[4]); ++j)
        {
            //Get Face
            var msmFace = ds_list_find_value(msmData[4], j);
            
            var C1 = MSMMeshBuilderGetColour(msmData, msmFace[9]);
            var C2 = MSMMeshBuilderGetColour(msmData, msmFace[10]);
            var C3 = MSMMeshBuilderGetColour(msmData, msmFace[11]);
            
            if(mean(C1[3], C2[3], C3[3]) > 0.995)
            {
                for(var k = 0; k < 3; ++k)
                {
                    var V = MSMMeshBuilderGetVertex(msmData, msmFace[(3*0)+k]);
                    var N = MSMMeshBuilderGetNormal(msmData, msmFace[(3*1)+k]);
                    var T = MSMMeshBuilderGetTexcoord(msmData, msmFace[(3*2)+k]);
                    
                    //Write Position
                    buffer_write(MSMBaseBuffer, buffer_f32, V[0]);
                    buffer_write(MSMBaseBuffer, buffer_f32, V[1]);
                    buffer_write(MSMBaseBuffer, buffer_f32, V[2]);
                    
                    //Write Normal
                    buffer_write(MSMBaseBuffer, buffer_f32, N[0]);
                    buffer_write(MSMBaseBuffer, buffer_f32, N[1]);
                    buffer_write(MSMBaseBuffer, buffer_f32, N[2]);
                    
                    //Write Texcoord
                    buffer_write(MSMBaseBuffer, buffer_f32, T[0]);
                    buffer_write(MSMBaseBuffer, buffer_f32, T[1]);
                    
                    //Write Colour
                    var C = null;
                    switch(k)
                    {
                    case 0: C = C1; break;
                    case 1: C = C2; break;
                    case 2: C = C3; break;
                    }
                    
                    //Write Colour
                    buffer_write(MSMBaseBuffer, buffer_f32, C[0]);
                    buffer_write(MSMBaseBuffer, buffer_f32, C[1]);
                    buffer_write(MSMBaseBuffer, buffer_f32, C[2]);
                    buffer_write(MSMBaseBuffer, buffer_f32, C[3]);                    
                }
            }
        }
        
        //Write Transparent Data Next
        for(var j = 0; j < ds_list_size(msmData[4]); ++j)
        {
            //Get Face
            var msmFace = ds_list_find_value(msmData[4], j);
            
            var C1 = MSMMeshBuilderGetColour(msmData, msmFace[9]);
            var C2 = MSMMeshBuilderGetColour(msmData, msmFace[10]);
            var C3 = MSMMeshBuilderGetColour(msmData, msmFace[11]);
            
            if(mean(C1[3], C2[3], C3[3]) < 0.995)
            {
                for(var k = 0; k < 3; ++k)
                {
                    var V = MSMMeshBuilderGetVertex(msmData, msmFace[(3*0)+k]);
                    var N = MSMMeshBuilderGetNormal(msmData, msmFace[(3*1)+k]);
                    var T = MSMMeshBuilderGetTexcoord(msmData, msmFace[(3*2)+k]);
                    
                    //Write Position
                    buffer_write(MSMBaseBuffer, buffer_f32, V[0]);
                    buffer_write(MSMBaseBuffer, buffer_f32, V[1]);
                    buffer_write(MSMBaseBuffer, buffer_f32, V[2]);
                    
                    //Write Normal
                    buffer_write(MSMBaseBuffer, buffer_f32, N[0]);
                    buffer_write(MSMBaseBuffer, buffer_f32, N[1]);
                    buffer_write(MSMBaseBuffer, buffer_f32, N[2]);
                    
                    //Write Texcoord
                    buffer_write(MSMBaseBuffer, buffer_f32, T[0]);
                    buffer_write(MSMBaseBuffer, buffer_f32, T[1]);
                    
                    //Write Colour
                    var C = null;
                    switch(k)
                    {
                    case 0: C = C1; break;
                    case 1: C = C2; break;
                    case 2: C = C3; break;
                    }
                    
                    //Write Colour
                    buffer_write(MSMBaseBuffer, buffer_f32, C[0]);
                    buffer_write(MSMBaseBuffer, buffer_f32, C[1]);
                    buffer_write(MSMBaseBuffer, buffer_f32, C[2]);
                    buffer_write(MSMBaseBuffer, buffer_f32, C[3]);                    
                }
            }
        }
        
        //Only write one object
        break;
    }    
    
    //Save MAM data
    buffer_save(MSMBaseBuffer, argument1);
    buffer_delete(MSMBaseBuffer);
    
}else{
    //This is an animated MAM. We only operate on builder #0.  
    var msmData = builderBase[0];
    
    //Calculate Size of MAM Stream 2
    var MAMStream2Size = (108 * ds_list_size(msmData[4]));
    
    //Calculate Size of MAM Stream 1's
    var MAMStream1Size = (36 * ds_list_size(msmData[4]));
    
    //
    // Calculate Size of MAM
    //
    var MAMSize = 16;                               //Start with size of header
        MAMSize += (4 + MAMStream2Size);            //Add Size of MAMBaseMesh
        
    for(var i = 0; i < array_length_1d(builderAnim); ++i)
    {
        var anim = builderAnim[i];
        var animFrames  = anim[1];
        var animTargets = anim[2];
        
        MAMSize += (4 + MAMStream1Size) * array_length_1d(animTargets);
        MAMSize += 4;
    }
    
    var MAMBuffer = buffer_create(MAMSize, buffer_fixed, 1);
    
    buffer_write(MAMBuffer, buffer_u32, $664D414D);                    //Magic ID. MAMf
    buffer_write(MAMBuffer, buffer_u32, 1);                            //Version
    buffer_write(MAMBuffer, buffer_u32, 0);                            //Flags. See MAMSpec.c
    buffer_write(MAMBuffer, buffer_u32, array_length_1d(builderAnim)); //Animation Count
       
    //Write MAMBaseMesh
    buffer_write(MAMBuffer, buffer_u32, 3 * MSMMeshBuilderGetFaceCount(msmData));
    
    //Add Opaque Faces
    for(var i = 0; i < MSMMeshBuilderGetFaceCount(msmData); ++i)
    {
        var msmFace = MSMMeshBuilderGetFace(msmData, i);
                    
        //Add the vertex data of each face.
        for(var j = 0; j < 3; ++j)
        {
            var N = MSMMeshBuilderGetNormal(msmData, msmFace[(3 * 1)   + j]);
            var T = MSMMeshBuilderGetTexcoord(msmData, msmFace[(3 * 2) + j]);
            var C = MSMMeshBuilderGetColour(msmData, msmFace[(3 * 3)   + j]);
            
            //Write Normal
            buffer_write(MAMBuffer, buffer_f32, N[0]);
            buffer_write(MAMBuffer, buffer_f32, N[1]);
            buffer_write(MAMBuffer, buffer_f32, N[2]);
            
            //Write Texcoord
            buffer_write(MAMBuffer, buffer_f32, T[0]);
            buffer_write(MAMBuffer, buffer_f32, T[1]);
            
            //Write Colour
            buffer_write(MAMBuffer, buffer_f32, C[0]);
            buffer_write(MAMBuffer, buffer_f32, C[1]);
            buffer_write(MAMBuffer, buffer_f32, C[2]);
            buffer_write(MAMBuffer, buffer_f32, C[3]);            
        }        
    }
    
    //Write MAM Animations
    for(var i = 0; i < array_length_1d(builderAnim); ++i)
    {            
        //Get MO Animation, and MO Animation Structures...
        var anim = builderAnim[i];
        
        var animFrames  = anim[1];
        var animTargets = anim[2];
        
        //Write animation length
        buffer_write(MAMBuffer, buffer_u32, anim[0]);
        
        //Write animation frames
        for(var j = 0; j < anim[0]; ++j)
        {
            var frame  = animFrames[j];
            var target = animTargets[j];
            
            //Write frame interpolation thingy
            buffer_write(MAMBuffer, buffer_f32, 0.01 * frame[0]);
            
            //Write all vertices of this frames target
            for(var faceID = 0; faceID < MSMMeshBuilderGetFaceCount(msmData); ++faceID)
            {
                var msmFace = MSMMeshBuilderGetFace(msmData, faceID);
                
                for(var vID = 0; vID < 3; ++vID)
                {
                    var V = target[msmFace[vID]];
                    
                    buffer_write(MAMBuffer, buffer_f32, V[0]);
                    buffer_write(MAMBuffer, buffer_f32, V[1]);
                    buffer_write(MAMBuffer, buffer_f32, V[2]);
                }
            }            
        }
    }
    
    buffer_save(MAMBuffer, argument1);
    buffer_delete(MAMBuffer);
}
