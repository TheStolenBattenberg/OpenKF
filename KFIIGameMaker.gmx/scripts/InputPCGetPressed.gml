///InputPCGetPressed(inputID);

var returnedInput = false;

//Is this a mouse input, or keyboard input?
if(argument0 < 0)
{
    returnedInput = mouse_check_button_pressed(abs(argument0));    
}else{
    returnedInput = keyboard_check_pressed(argument0);
}

return returnedInput;
