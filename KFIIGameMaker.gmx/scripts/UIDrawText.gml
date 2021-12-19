///UIDrawText(x, y, string, colour, centerX, centerY);


//Set Draw Parameters
draw_set_halign(lerp(fa_left, fa_center, round(argument4)));
draw_set_valign(lerp(fa_top,  fa_center, round(argument5)));
draw_set_colour(argument3);

//Calculate Scaling. We base our default scaling on 1920x1080, but I don't think it really matters.
var textScale = 1;
if(conUI.uiW1P > conUI.uiH1P)
{
    textScale = conUI.uiW1P / 19.2;
}else{
    textScale = conUI.uiH1P / 10.8;
}

//Actual draw
draw_text_transformed(argument0, argument1, argument2, textScale, textScale, 0);

//Reset
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);


