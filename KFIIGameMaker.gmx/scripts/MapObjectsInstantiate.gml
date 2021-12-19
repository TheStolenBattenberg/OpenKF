///MapObjectsInstantiate();

/*
//Create Object Instance List...
objectInstance = ds_list_create();

//We don't store our triggers as objects, so create a second list for those too
triggerInstance = ds_list_create();

//Get Data
var arrObjectDecl  = database[2];
var arrObjectClass = conMain.fdatDB[0];

//Spawn any valid Object Instances
for(var i = 0; i < array_length_1d(arrObjectDecl); ++i)
{
    // Get Object declaration
    var decl  = arrObjectDecl[i];
    
    // Skip invalid/empty declarations
    if(decl[4] == 255 || decl[4] == 65535)
        continue;
    
    // Get Object Class / Flags       
    var class = arrObjectClass[decl[4]];
    var flags = decl[9];
    
    // Handle Spawning of special Instances
    switch(class[0])
    {
        //Triggers
        case 224:
            var arrTrigger = array_create(8);
            arrTrigger[0]  = false;              //Last State
            arrTrigger[1]  = false;              //Curr State
            
            //Trigger Bounds...
            var arrTile = tilemap[decl[1], decl[2]];
            
            arrTrigger[2]  = (decl[1] + 0.5) - flags[3]; //X1
            arrTrigger[3]  = arrTile[(5 * decl[0]) + 1]; //Y1
            arrTrigger[4]  = decl[2] - 0.5;              //Z1
            arrTrigger[5]  = arrTrigger[2] + flags[3];   //X2
            arrTrigger[6]  = arrTrigger[3] + 2;          //Y2
            arrTrigger[7]  = arrTrigger[4] + flags[2];   //Z2
            
            //Flags
            arrTrigger[8]  = 79 - (-(decl[6] -0.5) * 2048.0);  //Map Dest X
            arrTrigger[9]  = (decl[7]+0.5) * 2048.0;           //Map Dest Z
            arrTrigger[10] = ((decl[8] * 2048) * -$80) / 2048; //Map Dest Y
            
            arrTrigger[11] = flags[4];                         //Map To Load
            arrTrigger[12] = flags[5];                         //RTMD To Load
            arrTrigger[13] = flags[6];                         //RTIM To Load
            arrTrigger[14] = flags[7];                         //SEQ To load
            arrTrigger[15] = flags[8];                         //VAB To load
            arrTrigger[16] = flags[9];                         //SFX VAB To load
            
            ds_list_add(triggerInstance, arrTrigger);
        continue;
        
        //These checks should be disabled for release
        case 240:
            show_debug_message("Object Declaration #"+string(i) + " is a skybox...");
            show_debug_message("Type: " + string(decl[4]));
        break;
        
        case 226:
            show_debug_message("Object Declaration #"+string(i) + " is a Class 226. Remove/Figure out what it is");
        break;
        
        case 31:
            show_debug_message("Object Declaration #"+string(i) + " is a Class 31. Remove/Figure out what it is");
        break;
    }
    
    var mamSequencer = null;
    var cullRadius = 1.0;
    var rotX = 0.0;
    var rotY = decl[5];
    var rotZ = 0.0;
    var meshID = decl[4] + $80;
    var newFlags = array_create(8);
    
    //Calculate Type Spesific Parameters
    switch(class[0])
    {      
        case 4:
            newFlags[@ 6] = flags[7];
        break;
          
        case 81:
            mamSequencer = MAMSequencerCreate(FileSystemLoadMO("MO_"+string(meshID), "Model"));
            MAMSequencerSetAnimationRate(mamSequencer, 0, true, false, 0.08);
        break;
        
        case 2:       
        case 5:
        case 3:
            mamSequencer = MAMSequencerCreate(FileSystemLoadMO("MO_"+string(meshID), "Model"));
        break;
        
        //8 = Wood Chest, 9 = Barrel, Bucket, Bones..., 22 = Stone Chest
        case 8:
        case 22:
        case 9:      
            newFlags[@ 0] = ((flags[5] & $FF) << 8) | (flags[4] & $FF); //Object IDs are stored in two bytes.
        break;
        
        case 64: //Item
            switch(class[1])
            {
                //Weapons
                case 16:    //Anything but arbalest
                    rotZ = 270.0;
                    rotX = 0.0;
                    rotY -= 90;
                break;
                
                case 17:    //Arbalest
                
                break;
            }
            cullRadius = 0.25; 
        break;
        
        case 255:                            //Objects
            cullRadius = (class[4] / 2) + 0.5;
            if(cullRadius <= 0.5)
            {
                cullRadius = 1.5;
            }
        break;
        case 162:
            cullRadius = 3.5;
        break;
        default:
            cullRadius = 1.0;
        break;
    }    
    
    // Spawn a new objectInstance using information from the declaration & class...
    var arrObjInst    = array_create(17);
        arrObjInst[0] = true;                   //Enabled
        arrObjInst[1] = true;                   //Visible
        arrObjInst[2] = decl[4];                //Object Class ID
        arrObjInst[3] = meshID;                 //Mesh ID
        
        //Build Transformation
        var arrTile = tilemap[decl[1], decl[2]];
        var RPX     = decl[1] + decl[6];
        var RPY     = (arrTile[(5 * decl[0]) + 1] + decl[8]);
        var RPZ     = decl[2] + decl[7];
        
        //Add Offsets to fix ZFighting issues. Fuck you Sony
        RPX += lengthdir_x(0.001, decl[5]+90)
        RPY += 0.001;
        RPZ += lengthdir_y(0.001, decl[5]+90)

        arrObjInst[4]  = matrix_build(RPX,RPY,RPZ, rotX,rotY,rotZ, -1, 1, 1);   //Big Boi Transform Matrix
        arrObjInst[5]  = RPX;                    //Position
        arrObjInst[6]  = RPY;                    //^^
        arrObjInst[7]  = RPZ;                    //^^
        arrObjInst[8]  = rotX;                   //Rotation
        arrObjInst[9]  = decl[5];                //^^
        arrObjInst[10] = rotZ;                   //^^
        arrObjInst[11] = -1;                     //Scale
        arrObjInst[12] = 1;                      //^^
        arrObjInst[13] = 1;                      //^^
        arrObjInst[14] = cullRadius;             //Culling Radius (For now unused)
        arrObjInst[15] = null;                   //^^
        
        //Some stuff relating to models.
        arrObjInst[16] = FileSystemLoadMO("MO_"+string(arrObjInst[3]), "Model");
        arrObjInst[17] = mamSequencer;
        
        //Collision Stuff
        arrObjInst[20] = null;
        arrObjInst[21] = null;
        
        MapObjectCollisionsFromClass(arrObjInst);
        
        //Flags
        arrObjInst[@ 24] = newFlags;
        arrObjInst[25] = i;                 //Original Decl ID
        
    //Add Object Instance to list of object instances...
    ds_list_add(objectInstance, arrObjInst);    
}

//Sort Spawned Instances Like so>
//  Firsts  - Skybox
//  Seconds - Other

var numSkyBox = 0;
for(var i = 0; i < ds_list_size(objectInstance); ++i)
{
    //Get Object instance
    var arrObjInst  = objectInstance[| i];
    
    //Get Class
    var arrObjClass = arrObjectClass[arrObjInst[2]];
    
    //Check type
    switch(arrObjClass[0])
    {
        //Perform a switcharoo
        case 240:                           
            objectInstance[| i] = ds_list_find_value(objectInstance, numSkyBox);
            objectInstance[| numSkyBox] = arrObjInst;
            numSkyBox++;
        break;
    }
}

//Now we can fix the decl pointers we just fucking broken.. We also sort collision IDs.
for(var i = 0; i < ds_list_size(objectInstance); ++i)
{
    var arrObjInst  = objectInstance[| i];
    var arrObjClass = arrObjectClass[arrObjInst[2]];
    var arrFlags = arrObjInst[@ 24];
    
    if(arrObjInst[21] != null)
    {
        if(is_array(arrObjInst[21]))
        {
            var bodies = arrObjInst[21];
            
            for(var j = 0; j < array_length_1d(bodies); ++j)
            {
                CollisionBodySetUserID(bodies[j], i);
            }
        }else{
            CollisionBodySetUserID(arrObjInst[21], i);
        }
    }    
    
    switch(arrObjClass[0])
    {
        //Doors need to be retargeted...
        case 4:
            for(var j = 0; j < ds_list_size(objectInstance); ++j)
            {
                var childInstance = objectInstance[| j];
                
                if(childInstance[@ 25] == arrFlags[6])
                {
                    break;
                }
            }           
            arrFlags[@ 6] = j; 
        break;
        
        //Item Containers need to be retargeted
        case 8:
        case 9:
        case 22:
            for(var j = 0; j < ds_list_size(objectInstance); ++j)
            {
                var childInstance = objectInstance[| j];
                
                if(childInstance[@ 25] == arrFlags[0])
                {
                    //Disable/make invisible the child instance
                    childInstance[@ 0] = false;
                    childInstance[@ 1] = false;
                    break;
                }
            }
            if(arrFlags[@ 0] != $FFFF)
            {
                arrFlags[@ 0] = j;
            }else{
                arrFlags[@ 0] = -1;
            }     
        break;
    }
    
    arrObjInst[@ 24] = arrFlags;
}

show_debug_message("Sorted "+string(numSkyBox)+" skyboxes into the correct place");

arrObjectDecl = -1;

*/
