///ListTextUpdate(ListText);

//Keyboard/Gamepad Interaction
if(InputManagerGetAxisPressed(InputMap.AxisLH))
{
    var Axis = InputManagerGetAxis(InputMap.AxisLH);
    
    argument0[@ 1] += Axis[1];
    
    SoundPlay2DPitch(WBFGetWave(conMain.gameSound, 15), 1.4);
    
    //Wrapping. Wish I could use modulo, but GM modulo is fucked?
    if(argument0[@ 1] > ds_list_size(argument0[0])-1)
    {
        argument0[@ 1] = 0; 
    }else
    if(argument0[@ 1] < 0)
    {
        argument0[@ 1] = ds_list_size(argument0[0])-1;
    }
}

argument0[@ 2] = InputManagerGetPressed(InputMap.Activate);

if(argument0[@ 2] == true)
{
    SoundPlay2DPitch(WBFGetWave(conMain.gameSound, 14), 1.0);
}
