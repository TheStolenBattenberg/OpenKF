///InputManagerPollDevices();

var device;

for(var i = 0; i < ds_list_size(global.IM[0]); ++i)
{
    //Get Device from InputManager
    device = ds_list_find_value(global.IM[0], i);
    
    //What type of device is this?
    switch(device[1])
    {
        case InputDeviceType.PC:
            InputDevicePollPC(device);
        break;
        
        case InputDeviceType.Gamepad:
        
        break;
    }
}
