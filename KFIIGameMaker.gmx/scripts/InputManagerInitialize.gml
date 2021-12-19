///InputManagerInitialize();

enum InputType {
    Button,
    FakeAxis,
    Axis
}

enum InputDeviceType {
    PC,
    Gamepad
}

global.mouse_last_x = window_mouse_get_x();
global.mouse_last_y = window_mouse_get_y();

//Create Input Manager Structure
var arrInputManager = array_create(4);
    arrInputManager[0] = ds_list_create();  //Device List
    arrInputManager[1] = null;              //Selected Device
    
global.IM = arrInputManager;

//Search for Input Devices
InputManagerFindDevices();
InputManagerSetCurrentDevice(InputManagerGetDevice(0));

return arrInputManager;
