///InputManagerFindDevices();

show_debug_message("IM> Polling Input Devices...");

enum InputMap
{
    AxisLH,
    AxisRH,
    Activate,
    Run,
    Menu,
    Attack,
    Block
}

//Automatically assume the player has a KB/M set up
var IPD = InputDeviceCreate("Keyboard and Mouse", 7, InputDeviceType.PC, null);

    //Set Default mappings to keyboard/Mouse
    InputDeviceFakeAxisMapping(IPD, InputMap.AxisLH, ord("W"), ord("S"), ord("A"), ord("D"));
    InputDeviceAxisMapping(IPD, InputMap.AxisRH, mouse_axis_lr, mouse_axis_ud);
    InputDeviceButtonMapping(IPD, InputMap.Activate, ord("E"));
    InputDeviceButtonMapping(IPD, InputMap.Run, vk_shift);
    InputDeviceButtonMapping(IPD, InputMap.Menu, vk_tab);
    InputDeviceButtonMapping(IPD, InputMap.Block, -mb_right);
    InputDeviceButtonMapping(IPD, InputMap.Attack, -mb_left);
    
ds_list_add(global.IM[0], IPD);

show_debug_message("IM> Input Device Added: Keyboard and Mouse");
