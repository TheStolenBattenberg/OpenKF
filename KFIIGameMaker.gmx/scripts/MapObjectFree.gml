///MapObjectFree(objectInstance);

//Free Matrix
argument0[@ 4] = -1;

//Free Rendering Stuff
argument0[@ 16] = -1;   //Remove MAM Reference
argument0[@ 17] = -1;   //Delete MAM Sequencer

//Free Collision Shapes
if(is_array(argument0[20]))
{
    //Multiple Shape Object
    var cShape = argument0[@ 20];
    for(var i = 0; i < array_length_1d(cShape); ++i)
        CollisionShapeDestroy(cShape[i]);
        
    argument0[@ 20] = null;
}else{
    //Single Shape Object
    if(argument0[20] != null)
        CollisionShapeDestroy(argument0[20]);    
    
    argument0[@ 20] = null;
}

//Free Collision Bodies
if(is_array(argument0[21]))
{
    //Multiple Body Object
    var cBody = argument0[@ 21];
    for(var i = 0; i < array_length_1d(cBody); ++i)
        CollisionBodyDestroy(cBody[i]);
        
    argument0[@ 21] = null;
}else{
    //Single Body Object
    if(argument0[21] != null)
        CollisionBodyDestroy(argument0[21]);    
    
    argument0[@ 21] = null;
}

//Free Flags
argument0[@ 24] = -1; 
