///InputDeviceCreate(name, inputCount, InputDeviceType, [opt] deviceID == null);

var deviceID = null;
if(argument_count > 3)
    deviceID = argument[3];

var arrInputDevice = array_create(6);
    arrInputDevice[0] = argument[0];                //Device Name
    arrInputDevice[1] = argument[2];                //Device Type
    arrInputDevice[2] = deviceID;                   //Gamepad devices get an ID, PC gets null.
    arrInputDevice[3] = array_create(argument[1]);  //Input Last State
    arrInputDevice[4] = array_create(argument[1]);  //Input Current State
    arrInputDevice[5] = array_create(argument[1]);  //Input Mapping
    
    array_clear_1d(arrInputDevice[5], null);
    
return arrInputDevice;
