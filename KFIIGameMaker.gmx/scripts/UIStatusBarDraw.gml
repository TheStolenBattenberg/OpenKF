///UIStatusBarDraw(statusbar, x, y, w, h);

//Draw Fill
var FW = (argument3 / 100) * argument0[0];

draw_set_colour(argument0[1]);
draw_rectangle(argument1, argument2, argument1+argument3, argument2+argument4, false);

//Draw Frame
draw_set_colour(c_black);
draw_rectangle(argument1, argument2, argument1+argument3, argument2+argument4, true);
