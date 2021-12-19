///ObjectLinkCollisionBodies(objectInsntace, instanceID);

//Check to see if there are multiple colliders
if(is_array(argument0[ObjectInstance.CollisionBodies]))
{
    //Set ID on multiple bodies
    var cBodies = argument0[ObjectInstance.CollisionBodies];
    
    //Loop through each body
    for(var i = 0; i < array_length_1d(cBodies); ++i)
    {
        //Only set when the body is not null.
        if(cBodies[i] != null)
            CollisionBodySetUserID(cBodies[i], argument1);
    }
}else{
    //Set ID on Single Body
    var cBody = argument0[ObjectInstance.CollisionBodies];
    
    //Only set when the body is not null.
    if(cBody != null)
        CollisionBodySetUserID(cBody, argument1);
}
