///InputDeviceButtonMapping(InputDevice, mappedID, mappedKey);

//Create stupid input thingy
var arrInput = array_create(2);
    arrInput[0] = InputType.Button;
    arrInput[1] = argument2;

//Add Mapping
var arrMapping = argument0[5];
    arrMapping[@ argument1] = arrInput;
