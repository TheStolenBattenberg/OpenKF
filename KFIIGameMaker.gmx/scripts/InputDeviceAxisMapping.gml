///InputDeviceAxisMapping(InputDevice, mappedID, mappedX, mappedY);

//Create stupid input thingy
var arrInput = array_create(2);
    arrInput[0] = InputType.Axis;
    arrInput[1] = argument2;
    arrInput[2] = argument3;

//Make sure last/current states are compliant with this type
var arrLastIn = argument0[3];
    arrLastIn[@ argument1] = Vector3(0.0, 0.0, false);
    
var arrCurrIn = argument0[4];    
    arrCurrIn[@ argument1] = Vector3(0.0, 0.0, false);
    
//Add Mapping
var arrMapping = argument0[5];
    arrMapping[@ argument1] = arrInput;
