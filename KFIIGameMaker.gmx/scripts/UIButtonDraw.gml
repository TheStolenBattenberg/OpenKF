///UIButtonDraw(UIButton, x, y, w, h)

//Store arguments in temporary variables
var X = argument1;
var Y = argument2;
var W = argument3;
var H = argument4;

//Calculate Scale
var scale = 1.0;
if(conUI.uiW1P > conUI.uiH1P)
{
    scale = conUI.uiW1P / 19.2;
}else{
    scale = conUI.uiH1P / 10.8;
}

//
// Update
//
argument0[@ 1] = argument0[2];
argument0[@ 2] = keyboard_check_pressed(vk_enter); 

//
// Draw
//

//Calculate L
var L = 16 * scale;

//Frame
UIDrawQuadSkewed(X, Y, X+L, Y+L, X, Y+H, X+L, (Y+H)-L, $303030, $606060, $303030, $606060, 0.75);
UIDrawQuadSkewed(X, Y, X+W, Y, X+L, Y+L, (X+W)-L, Y+L, $303030, $303030, $606060, $606060, 0.75);
UIDrawQuadSkewed((X+W)-L, Y+L, (X+W), Y, (X+W)-L, (Y+H)-L, X+W, Y+H, $606060, $303030, $606060, $303030, 0.75); 
UIDrawQuadSkewed(X, Y+H, X+W, Y+H, X+L, (Y+H)-L, (X+W)-L, (Y+H)-L, $303030, $303030, $606060, $606060, 0.75);

//Fill
draw_set_colour($102030);
draw_set_alpha(0.75);
draw_rectangle(X+L, Y+L, ((X+W)-L)-1, ((Y+H)-L)-1, false);
draw_set_alpha(1.0);
