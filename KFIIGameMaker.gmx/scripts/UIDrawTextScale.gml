///UIDrawTextScale(x, y, string, colour, halign, valign, scale);


//Set Draw Parameters
draw_set_halign(argument4);
draw_set_valign(argument5);
draw_set_colour(argument3);

//Actual draw
draw_text_transformed(argument0, argument1, argument2, argument6, argument6, 0);

//Reset
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);


