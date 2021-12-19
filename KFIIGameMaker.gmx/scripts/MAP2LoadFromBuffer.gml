///MAP2LoadFromBuffer(buffer, offset);

//Store buffer/offset in temporary variables
var map2Buffer = argument0;
var map2Offset = argument1;

//Make sure we are at the required offset
buffer_seek(map2Buffer, buffer_seek_start, map2Offset);

var nextSection;

//
// Read Entity Class Data
//

//Grab Offset to next section
nextSection = map2Offset + buffer_read(map2Buffer, buffer_u32) + 4;

//Set up data...
var arrEntityClassList = array_create(40);
var entityClassID = 0;

repeat(40)
{
    //Create Entity Class.
    var arrEntityClass = array_create(33);

    //Entity Class Section #1 - Basic Parameters
    arrEntityClass[0]  = buffer_read(map2Buffer, buffer_u8);    //Mesh ID
    arrEntityClass[1]  = buffer_read(map2Buffer, buffer_u8);    //??? Four Or Fourty
    arrEntityClass[2]  = buffer_read(map2Buffer, buffer_u8);    //???
    arrEntityClass[3]  = buffer_read(map2Buffer, buffer_u8);    //Knockback Resistance #1
    arrEntityClass[4]  = buffer_read(map2Buffer, buffer_u8);    //Knockback Resistance #2
    arrEntityClass[5]  = buffer_read(map2Buffer, buffer_u8);    //???
    arrEntityClass[6]  = buffer_read(map2Buffer, buffer_u8);    //???
    arrEntityClass[7]  = buffer_read(map2Buffer, buffer_u8);    //??? Rendering Something
    arrEntityClass[8]  = buffer_read(map2Buffer, buffer_u8);    //??? Rendering Something
    arrEntityClass[9]  = buffer_read(map2Buffer, buffer_u8);    //??? Copied To Instance
    arrEntityClass[10] = buffer_read(map2Buffer, buffer_u8);    //Spawn Distance
    arrEntityClass[11] = buffer_read(map2Buffer, buffer_u8);    //Despawn Distance
    arrEntityClass[12] = buffer_read(map2Buffer, buffer_s16);   //??? Some Vector X
    arrEntityClass[13] = buffer_read(map2Buffer, buffer_s16);   //??? Some Vector Y
    arrEntityClass[14] = buffer_read(map2Buffer, buffer_s16);   //??? Some Vector Z
    arrEntityClass[15] = buffer_read(map2Buffer, buffer_u16);   //Collision Radius
    arrEntityClass[16] = buffer_read(map2Buffer, buffer_u16);   //Collision Height
    arrEntityClass[17] = buffer_read(map2Buffer, buffer_u16);   //Vision Cone Start
    arrEntityClass[18] = buffer_read(map2Buffer, buffer_u16);   //Vision Cone End
    arrEntityClass[19] = buffer_read(map2Buffer, buffer_u16);   //Max HP
    arrEntityClass[20] = buffer_read(map2Buffer, buffer_u16);   //???  Maybe Unused Max MP?
    arrEntityClass[21] = buffer_read(map2Buffer, buffer_u16);   //Experience Gain On Kill
    
    //Entity Class Section #2 - Defense
    arrEntityClass[22] = buffer_read(map2Buffer, buffer_u16);   //Defence Against Edged  Attack
    arrEntityClass[23] = buffer_read(map2Buffer, buffer_u16);   //Defence Against Blunt  Attack
    arrEntityClass[24] = buffer_read(map2Buffer, buffer_u16);   //Defence Against Pierce Attack
    arrEntityClass[25] = buffer_read(map2Buffer, buffer_u16);   //Defence Against Light  Attack
    arrEntityClass[26] = buffer_read(map2Buffer, buffer_u16);   //Defence Against Fire   Attack
    arrEntityClass[27] = buffer_read(map2Buffer, buffer_u16);   //Defence Against Earth  Attack
    arrEntityClass[28] = buffer_read(map2Buffer, buffer_u16);   //Defence Against Wind   Attack
    arrEntityClass[29] = buffer_read(map2Buffer, buffer_u16);   //Defence Against Water  Attack
    
    //Entity Class Section #3 - Other
    arrEntityClass[30] = buffer_read(map2Buffer, buffer_u16);   //Minimum Gold Drop
    arrEntityClass[31] = buffer_read(map2Buffer, buffer_s16);   //Uniform Scale
    arrEntityClass[32] = buffer_read(map2Buffer, buffer_u32);   //Entity Class Flags
    
    var arrEntityStatePtrs; //We skip this for now.
    buffer_seek(map2Buffer, buffer_seek_relative, 4 * 16);    
    
    //Put Entity Class into array  
    arrEntityClassList[entityClassID] = arrEntityClass;
    entityClassID++;
}
buffer_seek(map2Buffer, buffer_seek_start, nextSection);

//
// Read Entity Instance Data
//

//Grab Offset to next section
nextSection = (nextSection + 4) + buffer_read(map2Buffer, buffer_u32);

//Set up data
var arrEntityInstanceList = array_create(200);
var entityInstanceID   = 0;

repeat(200)
{
    //Create Entity Instance
    var arrEntityInstance = array_create(12);
    
    //Read Entity Instance    
    arrEntityInstance[0]  = buffer_read(map2Buffer, buffer_u8);     //Respawn Mode
    arrEntityInstance[1]  = buffer_read(map2Buffer, buffer_u8);     //Class ID
    arrEntityInstance[2]  = buffer_read(map2Buffer, buffer_u8);     //Don't Randomize Rotation
    arrEntityInstance[3]  = buffer_read(map2Buffer, buffer_u8);     //Tile X
    arrEntityInstance[4]  = buffer_read(map2Buffer, buffer_u8);     //Tile Z
    arrEntityInstance[5]  = buffer_read(map2Buffer, buffer_u8);     //Respawn Chance
    arrEntityInstance[6]  = buffer_read(map2Buffer, buffer_u8);     //Dropped Item ID
    arrEntityInstance[7]  = buffer_read(map2Buffer, buffer_u8) > 1; //Layer
    arrEntityInstance[8]  = buffer_read(map2Buffer, buffer_s16);    //Rotation
    arrEntityInstance[9]  = buffer_read(map2Buffer, buffer_s16);    //Fine X
    arrEntityInstance[10] = buffer_read(map2Buffer, buffer_s16);    //Fine Y
    arrEntityInstance[11] = buffer_read(map2Buffer, buffer_s16);    //Fine Z
    
    //Put Entity Instance into array 
    arrEntityInstanceList[entityInstanceID] = arrEntityInstance;
    entityInstanceID++;
}
buffer_seek(map2Buffer, buffer_seek_start, nextSection);

//
// Read Object Instance Data
//

//Grab Offset to next section
nextSection = (nextSection + 4) + buffer_read(map2Buffer, buffer_u32);

//Set up data
var arrObjectInstanceList = array_create(350);
var objectInstanceID   = 0;

repeat(350)
{
    //Create Object Instance
    var arrObjectInstance = array_create(10);
    
    //Read Object Instance
    arrObjectInstance[0] = buffer_read(map2Buffer, buffer_u8) > 1;                               //Layer (hak'd)
    arrObjectInstance[1] = 79 - buffer_read(map2Buffer, buffer_u8);                              //Tile X
    arrObjectInstance[2] = buffer_read(map2Buffer, buffer_u8);                                   //Tile Z
    arrObjectInstance[3] = buffer_read(map2Buffer, buffer_u8);                                   //???
    arrObjectInstance[4] = buffer_read(map2Buffer, buffer_u16);                                  //Object ID
    arrObjectInstance[5] = (90 + (360 * (buffer_read(map2Buffer, buffer_s16) / 4096.0)));        //Rotation
    arrObjectInstance[6] = 0.5 + ((-buffer_read(map2Buffer, buffer_s16)) / 2048);                //Fine X
    arrObjectInstance[7] = -0.5 + (buffer_read(map2Buffer, buffer_s16) / 2048);                  //Fine Z
    arrObjectInstance[8] = (-buffer_read(map2Buffer, buffer_s16)) / 2048.0;                      //Fine Y
    
    //Read Object Instance Flags
    var arrObjectFlags = array_create(10);
        arrObjectFlags[0] = buffer_read(map2Buffer, buffer_u8);
        arrObjectFlags[1] = buffer_read(map2Buffer, buffer_u8);
        arrObjectFlags[2] = buffer_read(map2Buffer, buffer_u8);
        arrObjectFlags[3] = buffer_read(map2Buffer, buffer_u8);
        arrObjectFlags[4] = buffer_read(map2Buffer, buffer_u8);
        arrObjectFlags[5] = buffer_read(map2Buffer, buffer_u8);
        arrObjectFlags[6] = buffer_read(map2Buffer, buffer_u8);
        arrObjectFlags[7] = buffer_read(map2Buffer, buffer_u8);
        arrObjectFlags[8] = buffer_read(map2Buffer, buffer_u8);
        arrObjectFlags[9] = buffer_read(map2Buffer, buffer_u8);
    arrObjectInstance[9] = arrObjectFlags;
    
    arrObjectInstanceList[objectInstanceID] = arrObjectInstance;
    objectInstanceID++;
}
buffer_seek(map2Buffer, buffer_seek_start, nextSection);

//
// Read FX Instance Data
//

//Grab Offset to next section
nextSection = (nextSection + 4) + buffer_read(map2Buffer, buffer_u32);

//Set up data
var arrEffectDeclList = array_create(128);
var effectInstanceID   = 0;

repeat(128)
{
    //Create Effect Declaration
    var arrEffectDecl = array_create(12);
    
    //Read Effect Decl
    arrEffectDecl[0]  = buffer_read(map2Buffer, buffer_u16);           //Effect ID
    arrEffectDecl[1]  = buffer_read(map2Buffer, buffer_u8);            //Frame Count
    arrEffectDecl[2]  = buffer_read(map2Buffer, buffer_u8);            //Frame Speed
    arrEffectDecl[3]  = buffer_read(map2Buffer, buffer_u8) > 1;        //Layer
    arrEffectDecl[4]  = 79 - buffer_read(map2Buffer, buffer_u8);       //Tile X
    arrEffectDecl[5]  = buffer_read(map2Buffer, buffer_u8);            //Tile Z
    arrEffectDecl[6]  = buffer_read(map2Buffer, buffer_u8);            //???
    arrEffectDecl[7]  = buffer_read(map2Buffer, buffer_u8);            //???
    arrEffectDecl[8]  = buffer_read(map2Buffer, buffer_u8);            //???
    arrEffectDecl[9]  = 0.5 + ((-buffer_read(map2Buffer, buffer_s16)) / 2048);    //Fine X
    arrEffectDecl[10] = -0.5 + (buffer_read(map2Buffer, buffer_s16) / 2048);      //Fine Z
    arrEffectDecl[11] = (-buffer_read(map2Buffer, buffer_s16)) / 2048; //Fine Y

    //Store Effect Decl in list
    arrEffectDeclList[effectInstanceID] = arrEffectDecl;
    effectInstanceID++;
    
}

var arrMap2DB = array_create(4);
    arrMap2DB[0] = arrEntityClassList;
    arrMap2DB[1] = arrEntityInstanceList;
    arrMap2DB[2] = arrObjectInstanceList;
    arrMap2DB[3] = arrEffectDeclList;
    
return arrMap2DB;

