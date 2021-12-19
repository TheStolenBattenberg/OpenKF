///ObjectInstanceDestroy(objectInstance);

var arrObjectInstance = argument0;

arrObjectInstance[@ ObjectInstance.TransformMatrix]  = null; //Free Transformation
arrObjectInstance[@ ObjectInstance.MAMSequencer]     = null; //Free MAM Sequencer

//Free Collision Body(s)
if(arrObjectInstance[ObjectInstance.CollisionBodies] != null)
{
    if(is_array(arrObjectInstance[ObjectInstance.CollisionBodies]))
    {
        //Free array of collision shapes
        var arrcBody = arrObjectInstance[ObjectInstance.CollisionBodies];
        
        for(var i = 0; i < array_length_1d(arrcBody); ++i)
        {
            if(arrcBody[i] == null)
                continue;
                
            CollisionWorldRemoveBody(arrcBody[i]);
            CollisionBodyDestroy(arrcBody[i]);
            arrcBody[@ i] = null;
        }
        arrObjectInstance[@ ObjectInstance.CollisionBodies] = null;
    }else{
        //Free single collision shape
        CollisionWorldRemoveBody(arrObjectInstance[ObjectInstance.CollisionBodies]);
        CollisionBodyDestroy(arrObjectInstance[ObjectInstance.CollisionBodies]);
        arrObjectInstance[@ ObjectInstance.CollisionBodies] = null;
    }
}

//Free Collision Shape(s)
if(arrObjectInstance[ObjectInstance.CollisionShapes] != null)
{
    if(is_array(arrObjectInstance[ObjectInstance.CollisionShapes]))
    {
        //Free array of collision shapes
        var arrcShape = arrObjectInstance[ObjectInstance.CollisionShapes];
        
        for(var i = 0; i < array_length_1d(arrcShape); ++i)
        {
            if(arrcShape[i] == null)
                continue;
                
            CollisionShapeDestroy(arrcShape[i]);
            arrcShape[@ i] = null;
        }
        arrObjectInstance[@ ObjectInstance.CollisionShapes] = null;
    }else{
        //Free single collision shape
        CollisionShapeDestroy(arrObjectInstance[ObjectInstance.CollisionShapes]);
        arrObjectInstance[@ ObjectInstance.CollisionShapes] = null;
    }
}
        
arrObjectInstance[@ ObjectInstance.Flags] = null; //Free flag array
