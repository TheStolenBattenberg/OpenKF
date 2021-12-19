///TMDConvTCOffset(U, V, TSB, offU, offV, offP);

/**
 * Quick utility script converts a UV and TSB from a TMD packet
 * into a texture coordinate for use on a 8 : 1 aspect ratio image.
**/

var TexPageID = argument2 & $1F;

var TexOffX = ((TexPageID % 16) << 8) / 4096.0;
var TexOffY = (floor(TexPageID / 16) << 8) / 512.0;

if(TexPageID == argument5)
{
    TexOffX += argument3;
    TexOffY += argument4; 
}

return Vector2(TexOffX + (argument0 * 0.0625), TexOffY + (argument1 * 0.5));
