///MapLoadObjects();

//Create a temporary map to reconnect lost object connections
var AdjacencyMap = ds_map_create();

//Create data lists we are about to fill...
skyboxInstance  = ds_list_create();
objectInstance  = ds_list_create();
triggerInstance = ds_list_create();

//Get object declarations from mapDB
var arrObjectDecl  = database[2];

//Get object classes from gameDB
var arrObjectClasses = conMain.fdatDB[0];

//Store new Instance ID
var myInstanceID = -1;

//Try to instantiate each object...
for(var i = 0; i < array_length_1d(arrObjectDecl); ++i)
{
    var arrInstance = ObjectInstantiate(arrObjectDecl[i], arrObjectClasses);
    
    //Check what type of object we instantiated...
    if(arrInstance != null)
    {
        //This is cheeky, but it's the best idea I got.
        switch(array_length_1d(arrInstance))
        {
            //Trigger
            case 16:
                //Add to Trigger Instances
                ds_list_add(triggerInstance, arrInstance);
            break;
            
            //Skybox
            case 4:
                //Add to Skybox Instances
                ds_list_add(skyboxInstance, arrInstance);
            break;
            
            //Object
            case 24:
                //Add to Object Instances
                ds_list_add(objectInstance, arrInstance);
                
                //Get the instance ID from the ds_list_size - 1
                myInstanceID = ds_list_size(objectInstance)-1;
                
                //Link Collision bodies
                ObjectLinkCollisionBodies(arrInstance, myInstanceID); 
                
                //Store instance ID in adjacency map
                AdjacencyMap[? i] = myInstanceID;
            break;
        }
    }else{
        continue;
    }
}

//Restore each objects adjacency
for(var i = 0; i < ds_list_size(objectInstance); ++i)
    ObjectRestoreAdjacency(objectInstance[| i], AdjacencyMap);   
    
//Clean up
ds_map_destroy(AdjacencyMap);
