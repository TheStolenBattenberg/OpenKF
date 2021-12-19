///ObjectRestoreAdjacency(objectInstance, adjacencyMap);

var arrFlags = argument0[ObjectInstance.Flags];

//We need to switch on the object type in order to restore adjacency.
//We also make contained items invisible should they exist...
switch(argument0[ObjectInstance.ObjectType])
{
    case 4: arrFlags[@ 0] = argument1[? arrFlags[0]]; break;    //Double Door
    
    //Secret Compartment
    case 5: 
        arrFlags[@ 0] = argument1[? arrFlags[0]];
        
        if(ds_map_find_value(argument1, arrFlags[0]) == undefined)
        {
            arrFlags[@ 0] = null;
            break;   
        }           
         
        var containedInstance = objectInstance[| arrFlags[@ 0]];
            containedInstance[@ 0] = false;
            containedInstance[@ 1] = false;
        break;
    
    //Chest (Rotate Opening)
    case 8: arrFlags[@ 0] = argument1[? arrFlags[0]]; break;
    
    //Container
    case 9: 
        arrFlags[@ 0] = argument1[? arrFlags[0]]; 

        if(ds_map_find_value(argument1, arrFlags[0]) == undefined)
        {
            arrFlags[@ 0] = null;
            break;   
        }
        
        var containedInstance = objectInstance[| arrFlags[@ 0]];
            containedInstance[@ 0] = false;
            containedInstance[@ 1] = false;
        break;    
}

return argument0;
