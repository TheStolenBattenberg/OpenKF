///UIDrawFrame(x, y, w, h, ft);

var X = argument0;
var Y = argument1;
var W = argument2;
var H = argument3;
var L = argument4;

//Begin Drawing Quads

//Left
UIDrawQuadSkewed(X, Y, X+L, Y+L, X, Y+H, X+L, (Y+H)-L, $303030, $606060, $303030, $606060, 0.75);
UIDrawQuadSkewed(X, Y, X+W, Y, X+L, Y+L, (X+W)-L, Y+L, $303030, $303030, $606060, $606060, 0.75);
UIDrawQuadSkewed((X+W)-L, Y+L, (X+W), Y, (X+W)-L, (Y+H)-L, X+W, Y+H, $606060, $303030, $606060, $303030, 0.75); 
UIDrawQuadSkewed(X, Y+H, X+W, Y+H, X+L, (Y+H)-L, (X+W)-L, (Y+H)-L, $303030, $303030, $606060, $606060, 0.75);