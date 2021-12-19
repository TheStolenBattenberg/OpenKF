///InputDeviceFakeAxisMapping(InputDevice, mappedID, mappedU, mappedD, mappedL, mappedR);

//Create stupid input thingy
var arrInput = array_create(5);
    arrInput[0] = InputType.FakeAxis;
    arrInput[1] = argument2;
    arrInput[2] = argument3;
    arrInput[3] = argument4;
    arrInput[4] = argument5;

//Make sure last/current states are compliant with this type
var arrLastIn = argument0[3];
    arrLastIn[@ argument1] = Vector3(0.0, 0.0, false);
    
var arrCurrIn = argument0[4];    
    arrCurrIn[@ argument1] = Vector3(0.0, 0.0, false);   
    
//Add Mapping
var arrMapping = argument0[5];
    arrMapping[@ argument1] = arrInput;
