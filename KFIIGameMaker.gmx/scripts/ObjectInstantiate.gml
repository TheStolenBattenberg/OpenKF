///ObjectInstantiate(objectDeclaration, objectClasses);

//Store Object Declaration
var arrObjectDecl  = argument0;

//Make sure this is not an invalid object
if(arrObjectDecl[4] == $FF || arrObjectDecl[4] == $FFFF)
    return null;

//Get Class from declaration
var arrObjectClass = argument1[arrObjectDecl[4]];

//Get Flags from declaration
var arrObjectFlags = arrObjectDecl[9];

//Get tile this object is 'on'
var arrTile = tilemap[arrObjectDecl[1], arrObjectDecl[2]];

//Object Instance we store the data in.
var arrObjectInstance = ObjectInstanceCreate();

//Parameters to copy to object instance
var PositionX = 0, PositionY = 0, PositionZ = 0;
var RotationX = 0, RotationY = 0, RotationZ = 0;
var ScaleX = -1, ScaleY = 1, ScaleZ = 1;
var VisibleDistance = 10;
var Mesh = FileSystemLoadMO("MO_"+string($80 + arrObjectDecl[4]), "Model");
var MAMSequencer = null;
var Flags = null;

//Anything we can set now, do.
PositionX = arrObjectDecl[6] + arrObjectDecl[1];                    //Tile X + Fine X
PositionZ = arrObjectDecl[7] + arrObjectDecl[2];                    //Tile Z + Fine Z
PositionY = arrTile[(5 * arrObjectDecl[0]) + 1] + arrObjectDecl[8]; //Tile Elevation + Fine Y
RotationY = arrObjectDecl[5];                                       //Tile Rotation

//show_message("Tile Z: " + string_format(arrObjectDecl[2], 0, 20));
//show_message("Fine Z: " + string_format(arrObjectDecl[7], 0, 20));
//show_message("Position Z: " + string_format(PositionZ, 0, 20));

//Do a switch here to figure out what sort of object we have...
switch(arrObjectClass[0])
{
    //Small Slide Up Door 
    /** Declaration Flags
     *    0x00  ...
     *    0x01  ...
     *    0x02  Key Item ID
     *    0x03  Some Tile Y
     *    0x04  Some Tile X
     *    0x05  Some Tile Y
     *    0x06  Some Tile X
     *    0x07  ...
     *    0x08  Message ID When Using the wrong key
     *    0x09  Message ID When Locked
     *
     *  Instance Flags:
     *    0000  Is Door Open
     *    0001  Door Animation Timer
     *    0002  Is Locked
     *    0003  Key Item ID
     *    0004  Message ID (Wrong Key)
     *    0005  Message ID (Locked)
    **/
    case 2:
        Flags = array_create(6);
        Flags[0] = false;
        Flags[1] = 0.0;
        Flags[2] = arrObjectFlags[2] != $FF;
        Flags[3] = arrObjectFlags[2];
        Flags[4] = arrObjectFlags[8];
        Flags[5] = arrObjectFlags[9];
        
        MAMSequencer = MAMSequencerCreate(Mesh);                            //MAM Sequencer
    break;
    
    //Big Slide Up Door
    /** Declaration Flags
     *    0x00  ...
     *    0x01  ...
     *    0x02  Key Item ID
     *    0x03  Some Tile Y
     *    0x04  Some Tile X
     *    0x05  Some Tile Y
     *    0x06  Some Tile X
     *    0x07  ...
     *    0x08  Message ID When Using the wrong key
     *    0x09  Message ID When Locked
     *
     *  Instance Flags:
     *    0000  Is Door Open
     *    0001  Door Animation Timer
     *    0002  Is Locked
     *    0003  Key Item ID
     *    0004  Message ID (Wrong Key)
     *    0005  Message ID (Locked)
    **/
    case 3:
        Flags = array_create(6);
        Flags[0] = false;
        Flags[1] = 0.0;
        Flags[2] = arrObjectFlags[2] != $FF || arrObjectFlags[2] == $FC;    //0xFC is Rhombus Key Lock?...
        Flags[3] = arrObjectFlags[2];
        Flags[4] = arrObjectFlags[8];
        Flags[5] = arrObjectFlags[9];
        
        MAMSequencer = MAMSequencerCreate(Mesh);                            //MAM Sequencer
    break;
    
    //Double Door
    /** Declaration Flags
     *    0x00  ...
     *    0x01  ...
     *    0x02  Key Item ID
     *    0x03  Some Tile Y
     *    0x04  Some Tile X
     *    0x05  Some Tile Y
     *    0x06  Some Tile X
     *    0x07  Linked Other Door
     *    0x08  Message ID When Using the wrong key
     *    0x09  Message ID When Locked
     *
     *  Instance Flags:
     *    0000  Linked Other Door
     *    0001  Is Door Open
     *    0002  Door Animation Timer
     *    0003  Is Locked
     *    0004  Key Object ID
     *
     *
    **/
    case 4:
        Flags = array_create(5);
        Flags[0] = arrObjectFlags[7];
        Flags[1] = false;
        Flags[2] = 0.0;
        Flags[3] = arrObjectFlags[2] != $FF;    //!= FF: No Key, == FC: Rhombus Key 
        Flags[4] = arrObjectFlags[2];
    break;
    
    //Secret Compartment
    /** Declaration Flags
     *    0x00  ...
     *    0x01  ...
     *    0x02  ...
     *    0x03  ...
     *    0x04  Contained Object ID (Low Byte)
     *    0x05  Contained Object ID (High Byte)
     *    0x06  ...
     *    0x07  ...
     *    0x08  ...
     *    0x09  ...
     *
     *  Instance Flags:
     *    0000  Contained Object ID  
     *    0001  IsOpen?
     *    0002  IsEmpty?
    **/
    case 5: 
        Flags = array_create(1);
        Flags[0] = ((arrObjectFlags[4] & $FF) | (arrObjectFlags[5] & $FF) << 8);
        Flags[1] = false;
        Flags[2] = false;
        
        MAMSequencer = MAMSequencerCreate(Mesh);                            //MAM Sequencer
    break;
    
    //Hinged Chest Lid
    /** Declaration Flags
     *    0x00  ...
     *    0x01  ...
     *    0x02  Key Object ID (Low Byte)
     *    0x03  Key Object ID (High Byte)
     *    0x04  Contained Object ID (Low Byte)
     *    0x05  Contained Object ID (High Byte)
     *    0x06  ...
     *    0x07  ...
     *    0x08  Message ID When Using the wrong key
     *    0x09  Message ID When Locked
     *
     *  Instance Flags:
     *    0000  Contained Object ID  
     *    0001  Key Object ID
     *    0002  Message ID (Wrong Key)
     *    0003  Message ID (Locked)
     *    0004  Already Looted
    **/
    case 8:   
        Flags = array_create(5);
        Flags[0] = ((arrObjectFlags[4] & $FF) | (arrObjectFlags[5] & $FF) << 8);
        Flags[1] = ((arrObjectFlags[2] & $FF) | (arrObjectFlags[3] & $FF) << 8);
        Flags[2] = arrObjectFlags[8];
        Flags[3] = arrObjectFlags[9];
        Flags[4] = Flags[1] == $FFFE;   //Basically -2?.. Weird...
        
        PositionY = PositionY + 0.0005;                                     //Y Adjustment
    break;
    
    //Item Container (Bones, Bones2, Miners Grave, Soliders Grave, Elves Grave, Generic Graves)
    /** Declaration Flags
     *    0x00  ...
     *    0x01  ...
     *    0x02  ...
     *    0x03  ...
     *    0x04  Contained Object ID (Low Byte)
     *    0x05  Contained Object ID (High Byte)
     *    0x06  ...
     *    0x07  ...
     *    0x08  ...
     *    0x09  Message ID
     *
     *  Instance Flags:
     *    0000  Contained Object ID  
     *    0001  Message ID
     *    0002  IsEmpty
    **/
    case 9:
        Flags = array_create(2);
        Flags[0] = ((arrObjectFlags[4] & $FF) | (arrObjectFlags[5] & $FF) << 8);
        Flags[1] =   arrObjectFlags[9];
    break;
    
    //Sign
    /** Declaration Flags
     *    0x00  ...
     *    0x01  ...
     *    0x02  Text ID (Low Byte)
     *    0x03  Text ID (High Byte)
     *    0x04  ...
     *    0x05  ...
     *    0x06  ...
     *    0x07  ...
     *    0x08  ...
     *    0x09  ...
     *
     *  Instance Flags:
     *    0000  Sign Message ID
    **/
    case 13:
        PositionX = PositionX + lengthdir_x(0.0005, RotationY+90);          //X Adjustment
        PositionZ = PositionZ + lengthdir_y(0.0005, RotationZ+90);          //Z Adjustment
        
        Flags = array_create(1);
        Flags[0] = ((arrObjectFlags[2] & $FF) | (arrObjectFlags[3] & $FF) << 8);
    break;
    
    //Savepoint
    case 14:   
    break;
    
    //Guidepost
    case 15:       
    break;
    
    //Rhombus Slot
    case 17:    
    break;
    
    //Water Well
    case 18:         
        PositionY = PositionY + 0.0005;                                     //Y Adjustment    
    break;
    
    //Dragon Grass
    case 19:
    break;
    
    //Hidden Item Container
    case 21:        
    break;
    
    //Sliding Chest Lid
    case 22:      
    break;
    
    //Minecart
    case 32:    
    break;
    
    //Guyra Teleport Cube
    case 34:     
    break;    
    
    case 64:
    break;
    
    //Trap (Scythe, Spikeball, Wall Spike) 
    case 81:        
        MAMSequencer = MAMSequencerCreate(Mesh);                            //MAM Sequencer    
    break;
    
    //Switch
    case 83:
        MAMSequencer = MAMSequencerCreate(Mesh);                            //MAM Sequencer        
    break;
    
    //Trap (Opening Floor)
    /** Declaration Flags
     *    0x00  ...
     *    0x01  ...
     *    0x02  ???
     *    0x03  Some Tile Z
     *    0x04  Some Tile X
     *    0x05  ???
     *    0x06  ???
     *    0x07  ???
     *    0x08  ???
     *    0x09  ...
     *
     *  Instance Flags:
     *    0000  IsOpen
     *    0001  Trigger ID
     *    0002  Sound Bank
    **/
    case 84:
        Flags = array_create(3);
        //6 to 11
        var Trig = TriggerInstanceCreate(TriggerType.User);
            Trig[6]  = (PositionX - lengthdir_x(0.875, RotationY)) + lengthdir_y(0.5, RotationY);
            Trig[7]  = PositionY;
            Trig[8]  = (PositionZ + lengthdir_y(0.875, RotationY)) - lengthdir_x(0.5, RotationY);
            Trig[9]  = (PositionX + lengthdir_x(0.875, RotationY)) - lengthdir_y(0.5, RotationY);
            Trig[10] = PositionY + 3.5625;
            Trig[11] = (PositionZ - lengthdir_y(0.875, RotationY)) + lengthdir_x(0.5, RotationY);
           
        ds_list_add(triggerInstance, Trig);   
             
        Flags[0] = false;
        Flags[1] = ds_list_size(triggerInstance)-1;;
        Flags[2] = FileSystemLoadVAB("VAB_198", "none");
        
        MAMSequencer = MAMSequencerCreate(Mesh);                            //MAM Sequencer
    break;
    
    //Draw Bridge
    case 88:
        MAMSequencer = MAMSequencerCreate(Mesh);                            //MAM Sequencer      
    break;
    
    //Bridge of Wind
    case 89:    
    break;
    
    //Skull Key Blockade
    case 95:
        MAMSequencer = MAMSequencerCreate(Mesh);                            //MAM Sequencer     
    break;    
    
    //Skull Key Slot
    case 160:      
    break;   
     
    //Dragon Stone Slot
    case 161:     
    break;
    
    //Shrine Key Slot
    case 164:        
    break;
    
    //Containment Vat (Faries)
    case 165:     
    break;
    
    //Generic Object
    case 255:
        Flags = array_create(1);
        Flags[0] = null;
        if(arrObjectFlags[9] != $FF)
            Flags[0] = arrObjectFlags[9];
            
        //Some VERY special flags for certail generic objects
        switch(arrObjectDecl[4])
        {
            case 121:   //Hinged Chest Trunk
                PositionY = PositionY + 0.0005; //Y Adjustment
            break;
            case 191:   //Seaths Fountain Pillar
                PositionY = PositionY + 0.0005; //Y Adjustment  
            break;
        }
    break;
    
    //Unknown
    case 20:
    case 31:
    case 33:
    case 48:
    case 162:
    case 163:
    default:
    show_debug_message("Unknown Object Declaration Tried to be Instantiated:");
    show_debug_message(ctab + "Class: " + string(arrObjectClass[0]));
    return null;
    
    //
    // Special
    //
    // These are sorted into different lists than regular objects or removed.
    //
    
    //Load Trigger
    case 224:
        var arrTriggerInstance = TriggerInstanceCreate(TriggerType.LoadArea);
            arrTriggerInstance[0] = true;   //Enabled
            arrTriggerInstance[1] = true;   //Visible
            arrTriggerInstance[2] = 224;    //Class ID
            arrTriggerInstance[3] = TriggerType.LoadArea;
            arrTriggerInstance[4] = false;  //Last State
            arrTriggerInstance[5] = false;  //Current State
            
            arrTriggerInstance[6]  = (arrObjectDecl[1] + 0.5) - arrObjectFlags[3];   //X1
            arrTriggerInstance[7]  = arrTile[(5 * arrObjectDecl[0]) + 1];            //Y1
            arrTriggerInstance[8]  = arrObjectDecl[2] - 0.5;                         //Z1
            arrTriggerInstance[9]  = arrTriggerInstance[6] + arrObjectFlags[3];      //X2
            arrTriggerInstance[10] = arrTriggerInstance[7] + 2.0;                    //Y2
            arrTriggerInstance[11] = arrTriggerInstance[8] + arrObjectFlags[2];      //Z2
            
            Flags = array_create(9);
                Flags[0] = 79 - (-(arrObjectDecl[6] - 0.5) * 2048.0);       //Map Destination X
                Flags[1] = ((arrObjectDecl[8] * 2048) * -$80) / 2048.0;     //Map Destination Y
                Flags[2] = (arrObjectDecl[7] + 0.5) * 2048.0;               //Map Destination Z
                Flags[3] = arrObjectFlags[4];                               //Map  ID
                Flags[4] = arrObjectFlags[5];                               //RTMD ID
                Flags[5] = arrObjectFlags[6];                               //RTIM ID
                Flags[6] = arrObjectFlags[7];                               //SEQ  ID
                Flags[7] = arrObjectFlags[8];                               //VAB1 ID
                Flags[8] = arrObjectFlags[9];                               //VAB2 ID
                
            arrTriggerInstance[12] = Flags;
    return arrTriggerInstance;
    
    //Event Trigger
    case 225:
    return null;
    
    //Zone
    case 226:
    return null;
    
    //Skybox
    case 240:
        var arrSkyboxInstance = SkyboxInstanceCreate();
            arrSkyboxInstance[0] = true;
            arrSkyboxInstance[1] = true;
            arrSkyboxInstance[2] = arrObjectDecl[4];
            arrSkyboxInstance[3] = Mesh;
    return arrSkyboxInstance;
}

//Fill Instance Data
arrObjectInstance[ObjectInstance.ClassID] = arrObjectDecl[4];
arrObjectInstance[ObjectInstance.MeshID]  = $80 + arrObjectDecl[4];
arrObjectInstance[ObjectInstance.TransformMatrix] = matrix_build(PositionX, PositionY, PositionZ, RotationX, RotationY, RotationZ, ScaleX, ScaleY, ScaleZ);
arrObjectInstance[ObjectInstance.PositionX] = PositionX;
arrObjectInstance[ObjectInstance.PositionY] = PositionY;
arrObjectInstance[ObjectInstance.PositionZ] = PositionZ;
arrObjectInstance[ObjectInstance.RotationX] = RotationX;
arrObjectInstance[ObjectInstance.RotationY] = RotationY;
arrObjectInstance[ObjectInstance.RotationZ] = RotationZ;
arrObjectInstance[ObjectInstance.ScaleX] = ScaleX;
arrObjectInstance[ObjectInstance.ScaleY] = ScaleY;
arrObjectInstance[ObjectInstance.ScaleZ] = ScaleZ;
arrObjectInstance[ObjectInstance.VisibleDistance] = VisibleDistance;
arrObjectInstance[ObjectInstance.ObjectType] = arrObjectClass[0];
arrObjectInstance[ObjectInstance.Mesh] = Mesh;
arrObjectInstance[ObjectInstance.MAMSequencer] = MAMSequencer;
arrObjectInstance[ObjectInstance.Layer] = arrObjectDecl[0];
arrObjectInstance[ObjectInstance.Flags] = Flags;

//Generate Colliders for Instance
//ObjectInstanceGenerateColliders(arrObjectInstance);

//Return our instance.
return arrObjectInstance;
