///ObjectInstanceGenerateColliders(objectInstance);

//This will be the resulting Collision Shape.
var cShape = null, cBody = null;

switch(argument0[ObjectInstance.ClassID])
{
    //
    // Weapons
    //
    case 0: //Dagger
        cShape = CollisionShapeCreateBox(0.06, 0.15, 0.015);
        cBody  = CollisionBodyCreate(cShape);
        CollisionBodySetTranslation(cBody,argument0[5], argument0[6] + 0.15, argument0[7]);
        CollisionWorldAddBody(cBody, CMask.Item, CMask.Player);   
    break;    
    case 1: //Short Sword
    case 2: //Knight Sword
        cShape = CollisionShapeCreateBox(0.06, 0.225, 0.015);
        cBody  = CollisionBodyCreate(cShape);
        CollisionBodySetTranslation(cBody,argument0[5], argument0[6] + 0.225, argument0[7]);
        CollisionWorldAddBody(cBody, CMask.Item, CMask.Player);   
    break;
    case 3: //Morning Star
        cShape = CollisionShapeCreateBox(0.05, 0.2, 0.05);
        cBody  = CollisionBodyCreate(cShape);
        CollisionBodySetTranslation(cBody,argument0[5], argument0[6] + 0.2, argument0[7]);
        CollisionWorldAddBody(cBody, CMask.Item, CMask.Player);   
    break;        
    case 4: //Battle Hammer
        cShape = CollisionShapeCreateBox(0.16, 0.415, 0.06);
        cBody  = CollisionBodyCreate(cShape);
        CollisionBodySetTranslation(cBody,argument0[5], argument0[6] + 0.415, argument0[7]);
        CollisionWorldAddBody(cBody, CMask.Item, CMask.Player);   
    break;            
    case 5: //Bastard Sword
        cShape = CollisionShapeCreateBox(0.11, 0.30, 0.025);
        cBody  = CollisionBodyCreate(cShape);
        CollisionBodySetTranslation(cBody,argument0[5], argument0[6] + 0.30, argument0[7]);
        CollisionWorldAddBody(cBody, CMask.Item, CMask.Player);  
    break;    
    case 6: //Crescent Axe
        cShape = CollisionShapeCreateBox(0.13, 0.40, 0.025);
        cBody  = CollisionBodyCreate(cShape);
        CollisionBodySetTranslation(cBody,argument0[5], argument0[6] + 0.40, argument0[7]);
        CollisionWorldAddBody(cBody, CMask.Item, CMask.Player);  
    break;        
    case 9: //Flame Sword
        cShape = CollisionShapeCreateBox(0.015, 0.37, 0.08);
        cBody  = CollisionBodyCreate(cShape);
        CollisionBodySetTranslation(cBody,argument0[5], argument0[6] + 0.37, argument0[7]);
        CollisionWorldAddBody(cBody, CMask.Item, CMask.Player);  
    break;
    case 10: //Shiden
        cShape = CollisionShapeCreateBox(0.015, 0.3, 0.06);
        cBody  = CollisionBodyCreate(cShape);
        CollisionBodySetTranslation(cBody,argument0[5], argument0[6] + 0.3, argument0[7]);
        CollisionWorldAddBody(cBody, CMask.Item, CMask.Player);  
    break;    
    case 11: //Spider
        cShape = CollisionShapeCreateBox(0.09, 0.38, 0.015);
        cBody  = CollisionBodyCreate(cShape);
        CollisionBodySetTranslation(cBody,argument0[5], argument0[6] + 0.38, argument0[7]);
        CollisionWorldAddBody(cBody, CMask.Item, CMask.Player);  
    break;        
    case 12: //Ice Blade
        cShape = CollisionShapeCreateBox(0.12, 0.32, 0.025);
        cBody  = CollisionBodyCreate(cShape);
        CollisionBodySetTranslation(cBody,argument0[5], argument0[6] + 0.32, argument0[7]);
        CollisionWorldAddBody(cBody, CMask.Item, CMask.Player);  
    break;       
    case 13: //Seaths Sword
        cShape = CollisionShapeCreateBox(0.06, 0.26, 0.015);
        cBody  = CollisionBodyCreate(cShape);
        CollisionBodySetTranslation(cBody,argument0[5], argument0[6] + 0.26, argument0[7]);
        CollisionWorldAddBody(cBody, CMask.Item, CMask.Player);   
    break;        
    case 14: //Moonlight Sword <3
        cShape = CollisionShapeCreateBox(0.10, 0.31, 0.025);
        cBody  = CollisionBodyCreate(cShape);
        CollisionBodySetTranslation(cBody,argument0[5], argument0[6] + 0.31, argument0[7]);
        CollisionWorldAddBody(cBody, CMask.Item, CMask.Player);  
    break;            
    case 15: //Dark Slayer
        cShape = CollisionShapeCreateBox(0.10, 0.31, 0.025);
        cBody  = CollisionBodyCreate(cShape);
        CollisionBodySetTranslation(cBody,argument0[5], argument0[6] + 0.31, argument0[7]);
        CollisionWorldAddBody(cBody, CMask.Item, CMask.Player);  
    break;       
    case 16: //Bow
        cShape = CollisionShapeCreateBox(0.08, 0.26, 0.025);
        cBody  = CollisionBodyCreate(cShape);
        CollisionBodySetTranslation(cBody,argument0[5], argument0[6] + 0.26, argument0[7]);
        CollisionWorldAddBody(cBody, CMask.Item, CMask.Player);  
    break;       
    case 17: //Arbalest
        cShape = CollisionShapeCreateBox(0.25, 0.05, 0.10);
        cBody  = CollisionBodyCreate(cShape);
        CollisionBodySetTranslation(cBody,argument0[5], argument0[6] + 0.05, argument0[7]);
        CollisionWorldAddBody(cBody, CMask.Item, CMask.Player);  
    break;  
    
    //
    // Armour - All
    //   
    case 21:
    case 22:
    case 23:
    case 24:
    case 25:
    case 26:
    case 28:
    case 29:
    case 30:
    case 31:
    case 32:
    case 34:
    case 35:
    case 36:
    case 37:
    case 38:
    case 39:
    case 41:
    case 42:
    case 43:
    case 44:
    case 45:
    case 47:
    case 48:
    case 49:
    case 50:
    case 51:
    case 53:
    case 54:
    case 55:
    case 56:
    case 57:
    case 58:
    case 59:
        cShape = CollisionShapeCreateBox(0.10, 0.10, 0.10);
        cBody  = CollisionBodyCreate(cShape);
        CollisionBodySetTranslation(cBody,argument0[5], argument0[6] + 0.10, argument0[7]);
        CollisionWorldAddBody(cBody, CMask.Item, CMask.Player);    
    break;     
    
    //
    // Items
    //
    case 67:
    case 68:
    case 69:
    case 70:
    case 71:
    case 72:
    case 73:
    case 74:
    case 75:
    case 76:
    case 77:
    case 78:
    case 79:
    case 80:
    case 82:
    case 83:
    case 84:
    case 85:
    case 86:
    case 87:
    case 88:
    case 89:
    case 90:
    case 91:
    case 92:
    case 93:
    case 94:
    case 95:
    case 96:
    case 97:
  //case 98:
    case 99:
    case 100:
    case 101:
    case 102:
    case 103:
    case 104:
    case 105:
    case 106:
    case 107:
    case 108:
    case 109:
  //case 110:
    case 111:
    case 112:
    case 113:
    case 114:
    case 115:
    case 116:
    case 117:
    case 118: 
  //case 119:
        cShape = CollisionShapeCreateBox(0.1, 0.1, 0.1);
        cBody  = CollisionBodyCreate(cShape);
        CollisionBodySetTranslation(cBody,argument0[5], argument0[6] + 0.1, argument0[7]);
        CollisionWorldAddBody(cBody, CMask.Item, CMask.Player);
    break;
    
    //
    // Objects
    //
    case 120:   //Wooden Chest Lid
        cShape = CollisionShapeCreateBox(0.32, 0.08, 0.15);
        cBody  = CollisionBodyCreate(cShape);
        
        var cX = argument0[5] + lengthdir_y(0.15, argument0[9]);
        var cY = argument0[7] - lengthdir_x(0.15, argument0[9]);
        
        CollisionBodySetTranslation(cBody, cX, argument0[6] + 0.08, cY);
        CollisionBodySetRotation(cBody, argument0[8], argument0[9], argument0[10]);
        CollisionWorldAddBody(cBody, CMask.Object, CMask.Player);    
    break;
    
    case 121:   //Wooden Chest Trunk
        cShape = CollisionShapeCreateBox(0.32, 0.115, 0.15);
        cBody  = CollisionBodyCreate(cShape);
        
        var cX = argument0[5];
        var cY = argument0[7];
        
        CollisionBodySetTranslation(cBody, cX, argument0[6] + 0.115, cY);
        CollisionBodySetRotation(cBody, argument0[8], argument0[9], argument0[10]);
        CollisionWorldAddBody(cBody, CMask.Object, CMask.Player);     
    break;
    
    case 124:   //Square Well
        cShape[0] = CollisionShapeCreateBox(0.06, 0.125, 0.6);
        cShape[1] = CollisionShapeCreateBox(0.6, 0.125, 0.06);
        
        cBody[0] = CollisionBodyCreate(cShape[0]);
        var cX = argument0[5] + (lengthdir_x(0.05, argument0[9]) + lengthdir_y(0.52, argument0[9]));
        var cZ = argument0[7] + (lengthdir_y(0.05, argument0[9]) + lengthdir_x(0.52, argument0[9]));
        CollisionBodySetTranslation(cBody[0], cX, argument0[6]+0.125, cZ);
        CollisionBodySetRotation(cBody[0], argument0[8], argument0[9], argument0[10]);
        CollisionWorldAddBody(cBody[0], CMask.Static, CMask.Player);
        
        cBody[1] = CollisionBodyCreate(cShape[0]);
        var cX = argument0[5] + (lengthdir_x(-0.05, argument0[9]) + lengthdir_y(-0.52, argument0[9]));
        var cZ = argument0[7] + (lengthdir_y(-0.05, argument0[9]) + lengthdir_x(-0.52, argument0[9]));
        CollisionBodySetTranslation(cBody[1], cX, argument0[6]+0.125, cZ);
        CollisionBodySetRotation(cBody[1], argument0[8], argument0[9], argument0[10]);
        CollisionWorldAddBody(cBody[1], CMask.Static, CMask.Player);
        
        cBody[2] = CollisionBodyCreate(cShape[1]);
        var cX = argument0[5] + (lengthdir_y(0.05, argument0[9]-90) + lengthdir_x(0.62, argument0[9]-90));
        var cZ = argument0[7] + (lengthdir_x(0.05, argument0[9]-90) + lengthdir_y(0.62, argument0[9]-90));
        CollisionBodySetTranslation(cBody[2], cX, argument0[6]+0.125, cZ);
        CollisionBodySetRotation(cBody[2], argument0[8], argument0[9], argument0[10]);
        CollisionWorldAddBody(cBody[2], CMask.Static, CMask.Player);
        
        cBody[3] = CollisionBodyCreate(cShape[1]);
        var cX = argument0[5] + (lengthdir_y(-0.05, argument0[9]-90) + lengthdir_x(-0.62, argument0[9]-90));
        var cZ = argument0[7] + (lengthdir_x(-0.05, argument0[9]-90) + lengthdir_y(-0.62, argument0[9]-90));
        CollisionBodySetTranslation(cBody[3], cX, argument0[6]+0.125, cZ);
        CollisionBodySetRotation(cBody[3], argument0[8], argument0[9], argument0[10]);
        CollisionWorldAddBody(cBody[3], CMask.Static, CMask.Player);   
    break;
    
    case 125:   //Brown Wooden Door
  //case 126:
    case 127:   //Water Rotted Wooden Door
  //case 128:
    case 133:   //Seath's Fountain Door
  //case 134:
        cShape = CollisionShapeCreateBox(0.88, 0.78, 0.055);
        
        var cX = argument0[5] + (lengthdir_x(0.88, argument0[9]) + lengthdir_y(0.025, argument0[9]));
        var cZ = argument0[7] + (lengthdir_y(0.88, argument0[9]) - lengthdir_x(0.025, argument0[9]));
        
        cBody = CollisionBodyCreate(cShape);       
        CollisionBodySetTranslation(cBody, cX, argument0[6]+0.78, cZ);
        CollisionBodySetRotation(cBody, argument0[8], argument0[9], argument0[10]);
        CollisionWorldAddBody(cBody, CMask.Object, CMask.Player);        
    break;
    
    case 130:   //Secret Door #1
    case 132:   //Jail Door
    case 205:   //Secret Door #2
        cShape = array_create(2);
        cBody  = array_create(2);

        //Shape for moving component
        cShape[0] = CollisionShapeCreateBox(0.125, 0.78, 0.5);
        
        //Shape For Frame        
        var buffer = buffer_create(288, buffer_fixed, 1);
        BufferWritePlaneXZ(buffer, 0, 0, 0, 0.5, 1.0);
        BufferWritePlaneYZ(buffer, -0.5, 0.78, 0, 0.78, 0.125);
        BufferWritePlaneYZ(buffer, +0.5, 0.78, 0, 0.78, 0.125);
        BufferWritePlaneXZ(buffer, 0, 1.56, 0, 0.5, 1.0);
        cShape[1] = CollisionShapeCreateTrimesh(buffer, 3, 8); 
        buffer_delete(buffer);
        
        //Body for moving component
        cBody[0] = CollisionBodyCreate(cShape[0]);
        CollisionBodySetRotation(cBody[0], argument0[8], argument0[9], argument0[10]);
        CollisionBodySetTranslation(cBody[0], argument0[5], argument0[6]+0.78, argument0[7]);
        CollisionWorldAddBody(cBody[0], CMask.Object, CMask.Player); 
                
        //Body For Frame
        cBody[1]  = CollisionBodyCreate(cShape[1]);
        CollisionBodySetRotation(cBody[1], argument0[8], argument0[9]-90, argument0[10]);
        CollisionBodySetTranslation(cBody[1],argument0[5], argument0[6], argument0[7]);
        CollisionWorldAddBody(cBody[1], CMask.Object, CMask.Player);  
    break;
    
    case 129:   //Big Rough Stone Door
    case 139:   //Rhombus Door
        cShape = array_create(2);
        cBody  = array_create(2);
        
        //Shape for moving component
        cShape[0] = CollisionShapeCreateBox(0.875, 0.78, 0.25);
        
        //Shape for frame
        var buffer = buffer_create(288, buffer_fixed, 1);
        BufferWritePlaneXZ(buffer, 0, 0, 0, 0.875, 0.5);
        BufferWritePlaneYZ(buffer, -0.875, 0.78, 0, 0.78, 0.5);
        BufferWritePlaneYZ(buffer, +0.875, 0.78, 0, 0.78, 0.5);
        BufferWritePlaneXZ(buffer, 0, 1.56, 0, 0.875, 0.5);
        cShape[1] = CollisionShapeCreateTrimesh(buffer, 3, 8);
        buffer_delete(buffer);
        
        //Body for moving component
        cBody[0] = CollisionBodyCreate(cShape[0]);
        CollisionBodySetRotation(cBody[0], argument0[8], argument0[9], argument0[10]);
        CollisionBodySetTranslation(cBody[0], argument0[5], argument0[6]+0.78, argument0[7]);
        CollisionWorldAddBody(cBody[0], CMask.Object, CMask.Player); 
        
        //Body for frame
        cBody[1] = CollisionBodyCreate(cShape[1]);
        CollisionBodySetRotation(cBody[1], argument0[8], argument0[9], argument0[10]);
        CollisionBodySetTranslation(cBody[1], argument0[5], argument0[6], argument0[7]);
        CollisionWorldAddBody(cBody[1], CMask.Static, CMask.Player);   
    break;
    
    case 131:   //Secret Compartment #1
    case 138:   //Secret Compartment #2
    case 209:   //Secret Compartment #3
    case 214:   //Secret Compartment #4
        //Shape For Frame        
        var buffer = buffer_create(216, buffer_fixed, 1);
        BufferWritePlaneXZ(buffer, 0.06, 0, 0, 0.44, 0.5);
        BufferWritePlaneYZ(buffer, -0.375, 0.78, 0, 0.78, 0.5);
        BufferWritePlaneXZ(buffer, 0.06, 1.56, 0, 0.44, 0.5);
        cShape = CollisionShapeCreateTrimesh(buffer, 3, 6);  
        buffer_delete(buffer);
        
        //Body for frame
        cBody  = CollisionBodyCreate(cShape);
        CollisionBodySetRotation(cBody, argument0[8], argument0[9], argument0[10]);
        CollisionBodySetTranslation(cBody,argument0[5], argument0[6], argument0[7]);
        CollisionWorldAddBody(cBody, CMask.Object, CMask.Player);  
    break;
    
    case 141:   //Dead Solider of Verdite
        cShape = CollisionShapeCreateBox(0.5, 0.25, 0.8);
        
        cBody = CollisionBodyCreate(cShape);
        CollisionBodySetRotation(cBody, argument0[8], argument0[9]+0.25, argument0[10]);
        CollisionBodySetTranslation(cBody,argument0[5], argument0[6], argument0[7]);
        CollisionWorldAddBody(cBody, CMask.Item, CMask.Player); 
    break;
    
    case 159:   //King Harvine Sign
        cShape = CollisionShapeCreateBox(0.20, 0.20, 0.025);
        cBody  = CollisionBodyCreate(cShape);
        CollisionBodySetRotation(cBody, argument0[8], argument0[9], argument0[10]);
        CollisionBodySetTranslation(cBody,argument0[5], argument0[6], argument0[7]);
        CollisionWorldAddBody(cBody, CMask.Item, CMask.Player);       
    break;
    
    case 160:   //WallWriting #1
    case 161:   //WallWriting #2
    case 162:   //WallWriting #3
        cShape = CollisionShapeCreateBox(0.20, 0.10, 0.025);
        cBody  = CollisionBodyCreate(cShape);
        CollisionBodySetRotation(cBody, argument0[8], argument0[9], argument0[10]);
        CollisionBodySetTranslation(cBody,argument0[5], argument0[6], argument0[7]);
        CollisionWorldAddBody(cBody, CMask.Item, CMask.Player);   
    break;
    
    case 203:   //Opening Floor Trap
    case 206:
        //Shape For Frame        
        var buffer = buffer_create(432, buffer_fixed, 1);
        BufferWritePlaneXZ(buffer, 0, 0, 0, 0.875, 0.5);
        BufferWritePlaneYZ(buffer, -0.875, 1.78125, 0, 1.78125, 0.5);
        BufferWritePlaneYZ(buffer, +0.875, 1.78125, 0, 1.78125, 0.5);
        BufferWritePlaneYX(buffer, 0, 1.780, +0.5, 0.22, 1.0);
        BufferWritePlaneYX(buffer, 0, 1.780, -0.5, 0.22, 1.0);
        BufferWritePlaneXZ(buffer, 0, 3.5625, 0, 0.875, 0.5);
        cShape = CollisionShapeCreateTrimesh(buffer, 3, 12);
        buffer_delete(buffer);
        
        //Body for frame
        cBody  = CollisionBodyCreate(cShape);
        CollisionBodySetRotation(cBody, argument0[8], argument0[9], argument0[10]);
        CollisionBodySetTranslation(cBody,argument0[5], argument0[6], argument0[7]);
        CollisionWorldAddBody(cBody, CMask.Object, CMask.Player);    
    break;    
      
    case 136:   //Wooden Platform
        cShape = CollisionShapeCreateBox(0.5, 0.25, 0.5);
        cBody  = CollisionBodyCreate(cShape);
        CollisionBodySetTranslation(cBody, argument0[5], argument0[6] - 0.255, argument0[7]);
        CollisionWorldAddBody(cBody, CMask.Static, CMask.Player);
    break;
    
    case 163:   //Magicians Lamp
        cShape = CollisionShapeCreateCylinderY(0.16, 0.54);
        cBody  = CollisionBodyCreate(cShape);
        CollisionBodySetTranslation(cBody, argument0[5], argument0[6] + 0.54, argument0[7]);    
        CollisionWorldAddBody(cBody, CMask.Object, CMask.Player);
    break;
    
    case 179:   //Barrel
        cShape = CollisionShapeCreateCylinderY(0.26, 0.31);
        cBody  = CollisionBodyCreate(cShape);
        CollisionBodySetTranslation(cBody, argument0[5], argument0[6] + 0.31, argument0[7]);    
        CollisionWorldAddBody(cBody, CMask.Object, CMask.Player);    
    break;

    case 180:   //Bucket
        cShape = CollisionShapeCreateCylinderY(0.13, 0.13);
        cBody  = CollisionBodyCreate(cShape);
        CollisionBodySetTranslation(cBody, argument0[5], argument0[6] + 0.13, argument0[7]);    
        CollisionWorldAddBody(cBody, CMask.Object, CMask.Player);    
    break;
    
    case 195:   //Circle Well
        cShape = CollisionShapeCreateCylinderY(0.8, 0.20);
        cBody  = CollisionBodyCreate(cShape);
        CollisionBodySetTranslation(cBody, argument0[5], argument0[6] + 0.20, argument0[7]);    
        CollisionWorldAddBody(cBody, CMask.Object, CMask.Player);            
    break;
    
    default:    //Catch unknown/no collision classes
    break;
}

argument0[@ 20] = cShape;
argument0[@ 21] = cBody;

return true;
