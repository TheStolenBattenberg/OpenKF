///UIDrawTitleBox(x, y, string);

//Calculate Scaling. We base our default scaling on 1920x1080, but I don't think it really matters.
var textScale = 1;
if(conUI.uiW1P > conUI.uiH1P)
{
    textScale = conUI.uiW1P / 12.8;
}else{
    textScale = conUI.uiH1P / 7.2;
}

//Draw Pannel
var PW = (string_width(argument2) + (16 * textScale)) * textScale;
var PH = (string_height(argument2) + (8 * textScale)) * textScale;
UIDrawPanel(argument0, argument1, PW, PH, 8 * textScale);

//Actual draw
draw_set_colour($d8b888);
draw_text_transformed(argument0 + (9*textScale), argument1 + (4*textScale), argument2, textScale, textScale, 0);
draw_set_colour(c_black);
