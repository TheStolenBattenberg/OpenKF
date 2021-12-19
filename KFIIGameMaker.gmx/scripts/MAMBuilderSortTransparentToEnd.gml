///MAMBuilderSortTransparentToEnd(MAMBuilder);

//Get base mesh from MAM
var MSMMeshBuilders = argument0[0];

//Get first object from Basemesh
var MSMBaseMesh = MSMMeshBuilders[0];
var MSMFaces    = MSMBaseMesh[4];

for(var i = ds_list_size(MSMFaces)-1; i >= 0; --i)
{
    //Get Face
    var arrFace1 = MSMFaces[| i];
    
    //Check the opacity of the face
    var C1 = MSMMeshBuilderGetColour(MSMBaseMesh, arrFace1[9]);
    var C2 = MSMMeshBuilderGetColour(MSMBaseMesh, arrFace1[10]);
    var C3 = MSMMeshBuilderGetColour(MSMBaseMesh, arrFace1[11]);
    
    if(mean(C1[3], C2[3], C3[3]) < 0.995)
    {
        //If average transparency is less than 0.995, leave it be.
        continue;
    }else{
        //Move it's solid, move it to the next found transparent triangle.
        for(var j = i-1; j >= 0; --j)
        {
            var arrFace2 = MSMFaces[| j];
            
            var C4 = MSMMeshBuilderGetColour(MSMBaseMesh, arrFace2[9]);
            var C5 = MSMMeshBuilderGetColour(MSMBaseMesh, arrFace2[10]);
            var C6 = MSMMeshBuilderGetColour(MSMBaseMesh, arrFace2[11]);
            
            if(mean(C4[3], C5[3], C6[3]) < 0.995)
            {
                //Switch the faces
                MSMFaces[| i] = arrFace2;
                MSMFaces[| j] = arrFace1;           
                break;
            }
        }
        
        //If we reached the bottom of the list, we've safely sorted all triangles and can break out of the loop.
        if(j == -1)
        {
            break;
        }
    }
}
