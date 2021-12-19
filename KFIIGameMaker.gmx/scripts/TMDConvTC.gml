///TMDConvTC(U, V, TSB);

/**
 * Quick utility script converts a UV and TSB from a TMD packet
 * into a texture coordinate for use on a 8 : 1 aspect ratio image.
**/

//Get the Texpage ID, used to convert texcoords...
var TexPageID = argument2 & $1F;

//Use the texpage ID to figure out the texpage offset...
var TexOffX = ((TexPageID % 16) << 8) / 4096.0;
var TexOffY = (floor(TexPageID / 16) << 8) / 512.0;

//Get the new, offseted texcoords
var TexU = TexOffX + (argument0 * 0.0625);
var TexV = TexOffY + (argument1 * 0.5);

//Wrap texture coordinates so they cannot go off the tex page boundries...
while(TexV < TexOffY)        { TexV += 0.5; }
while(TexV > TexOffY+0.5)    { TexV -= 0.5; }
while(TexU < TexOffX)        { TexU += 0.0625; }
while(TexU > TexOffX+0.0625) { TexU -= 0.0625; } 

//Return final texcoords
return Vector2(TexU, TexV);
