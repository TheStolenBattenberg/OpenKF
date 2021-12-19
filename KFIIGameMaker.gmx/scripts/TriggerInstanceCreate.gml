///TriggerInstanceCreate(TriggerType);

enum TriggerType
{
    LoadArea,
    Event,
    User
}

var arrTriggerInstance = array_create(16);

    arrTriggerInstance[0]  = true;       //IsEnabled
    arrTriggerInstance[1]  = true;       //IsVisible
    arrTriggerInstance[2]  = 0;          //Class ID (always 224)
    arrTriggerInstance[3]  = argument0;  //Trigger Type
    arrTriggerInstance[4]  = false;      //Last State
    arrTriggerInstance[5]  = false;      //Current State
    arrTriggerInstance[6]  = 0;          //Min X
    arrTriggerInstance[7]  = 0;          //Min Y
    arrTriggerInstance[8]  = 0;          //Min Z
    arrTriggerInstance[9]  = 0;          //Max X
    arrTriggerInstance[10] = 0;          //Max Y
    arrTriggerInstance[11] = 0;          //Max Z
    arrTriggerInstance[12] = null;       //Flags OR user data
    arrTriggerInstance[13] = 0;          //Reserved
    arrTriggerInstance[14] = 0;          //Reserved
    arrTriggerInstance[15] = 0;          //Reserved
    
return arrTriggerInstance;
