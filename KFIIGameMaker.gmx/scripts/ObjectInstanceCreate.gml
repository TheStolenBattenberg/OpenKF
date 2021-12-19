///ObjectInstanceCreate();

enum ObjectInstance
{
    IsEnabled = 0,
    IsVisible = 1,
    ClassID   = 2,
    MeshID    = 3,
    TransformMatrix = 4,
    PositionX = 5,
    PositionY = 6,
    PositionZ = 7,
    RotationX = 8,
    RotationY = 9,
    RotationZ = 10,
    ScaleX = 11,
    ScaleY = 12,
    ScaleZ = 13,
    VisibleDistance = 14,
    ObjectType      = 15,
    Mesh = 16,
    MAMSequencer = 17,
    Layer        = 18,
    CollisionShapes = 20,
    CollisionBodies = 21,
    Flags = 23    
}

var arrObjectInstance = array_create(24);
    arrObjectInstance[0]  = true;           //Enabled
    arrObjectInstance[1]  = false;          //Visible
    arrObjectInstance[2]  = 0;              //Object Class ID
    arrObjectInstance[3]  = 0;              //Object Mesh  ID    
    arrObjectInstance[4]  = 0;              //Transformation Matrix
    arrObjectInstance[5]  = 0;              //Position (X)
    arrObjectInstance[6]  = 0;              //Position (Y)
    arrObjectInstance[7]  = 0;              //Position (Z)
    arrObjectInstance[8]  = 0;              //Rotation (X)
    arrObjectInstance[9]  = 0;              //Rotation (Y)
    arrObjectInstance[10] = 0;              //Rotation (Z)
    arrObjectInstance[11] = -1;             //Scale (X)
    arrObjectInstance[12] = 1;              //Scale (Y)
    arrObjectInstance[13] = 1;              //Scale (Z)
    arrObjectInstance[14] = 10;             //Max Visible Distance  
    arrObjectInstance[15] = 0;              //Object Type
    arrObjectInstance[16] = null;           //Mesh Reference
    arrObjectInstance[17] = null;           //MAM Sequencer    
    arrObjectInstance[18] = 0;              //Current Layer        
    arrObjectInstance[20] = null;           //Collision Shapes
    arrObjectInstance[21] = null;           //Collision Body
    arrObjectInstance[23] = null;           //Flag Array

    arrObjectInstance[19] = 0;              //Reserved
    arrObjectInstance[22] = 0;              //Reserved

return arrObjectInstance;
