///InputPCGet(inputID);

var returnedInput = null;

//Is this a mouse input, or keyboard input?
if(argument0 < 0)
{
    //Mouse Input
    if(argument0 == mouse_axis_ud) {
        returnedInput = window_mouse_get_y() - global.mouse_last_y;
        global.mouse_last_y = window_mouse_get_y();
        
        //'Clamp' mouse y
        if(display_mouse_get_y() < window_get_y())
        {
            global.mouse_last_y = (display_mouse_get_y()-window_get_y()) + window_get_height();
            window_mouse_set(window_mouse_get_x(), global.mouse_last_y);
        }else
        if(display_mouse_get_y() > (window_get_y()+window_get_height()))
        {
            global.mouse_last_y = 0;
            window_mouse_set(window_mouse_get_x(), global.mouse_last_y);
        }
    }else
    if(argument0 == mouse_axis_lr) {
        returnedInput = window_mouse_get_x() - global.mouse_last_x;
        global.mouse_last_x = window_mouse_get_x();   
        
        //'Clamp' mouse x
        if(display_mouse_get_x() < window_get_x())
        {
            global.mouse_last_x = (display_mouse_get_x()-window_get_x()) + window_get_width();
            window_mouse_set(global.mouse_last_x, window_mouse_get_y());
        }else
        if(display_mouse_get_x() > (window_get_x()+window_get_width()))
        {
            global.mouse_last_x = 0;
            window_mouse_set(global.mouse_last_x, window_mouse_get_y());
        } 
    }else
    if(argument0 == mouse_wheelup) {
        returnedInput = mouse_wheel_up() > 0; 
    }else
    if(argument0 == mouse_wheeldown) {
        returnedInput = mouse_wheel_down() > 0;
    }else{
        returnedInput = mouse_check_button(abs(argument0));
    }      
}else{
    returnedInput = keyboard_check(argument0);
}

return returnedInput;
