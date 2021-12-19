///TIMLoadFromBuffer(buffer, offset);

//Store buffer/offset in temporary variables
var timBuffer = argument0;
var timOffset = argument1;

//Make sure we are at the required offset
buffer_seek(timBuffer, buffer_seek_start, timOffset);

//Start reading data as TIM

//
// TIM Header
//

var timID = buffer_read(timBuffer, buffer_u32);
var timFlags = buffer_read(timBuffer, buffer_u32);

if(timID != $00000010)
{
    show_debug_message("TIMLoadFromBuffer failed because of a bad magicID");
    return null;
}

var timBPP =     (timFlags & $7);
var timHasClut = (timFlags & $8) >> 3;

//
// TIM CLUT (if present)
//
var CLUT;

if(timHasClut)
{
    //We use the BPP to figure out what size our CLUT should be. This doesn't work for multiple CLUTs.
    switch(timBPP)
    {
        case 0: CLUT = array_create(16);  break;    //4BPP
        case 1: CLUT = array_create(256); break;    //8BPP
        default: show_debug_message("TIMLoadFromBuffer failed -> Invalid CLUT"); return null;
    }
    
    //Read CLUT Header
    var clutBNUM = buffer_read(timBuffer, buffer_u32);
    var clutX = buffer_read(timBuffer, buffer_u16);
    var clutY = buffer_read(timBuffer, buffer_u16);
    var clutW = buffer_read(timBuffer, buffer_u16);
    var clutH = buffer_read(timBuffer, buffer_u16);
    
    //Only read the number of CLUT entries equal to our CLUT size.
    for(var i = 0; i < array_length_1d(CLUT); ++i)
    {
        //Read RGBA5551 colour from buffer
        var clutColour = buffer_read(timBuffer, buffer_u16);
        
        //Convert RGBA5551 to RGB888 colour using PSX colour ramp & and non standard interpolation
        var ccR = (clutColour << 3) & $FF; //smoothstep(0, 255, (clutColour & $1F) / $1F);
        var ccG = (clutColour >> 2) & $F8; //smoothstep(0, 255, ((clutColour >> 5) & $1F) / $1F);
        var ccB = (clutColour >> 7) & $F8; //smoothstep(0, 255, ((clutColour >> 10) & $1F) / $1F);
        
        //Make a colour GameMaker understands.
        CLUT[i] = make_colour_rgb(ccR, ccG, ccB);
    }
    
    //Skip any additional data.
    buffer_seek(timBuffer, buffer_seek_start, (timOffset + $8) + clutBNUM);
}

//
// TIM Image
//
var imageBNUM = buffer_read(timBuffer, buffer_u32);
var imageX    = buffer_read(timBuffer, buffer_u16);
var imageY    = buffer_read(timBuffer, buffer_u16);
var imageW    = buffer_read(timBuffer, buffer_u16);
var imageH    = buffer_read(timBuffer, buffer_u16);

var surface = null;
switch(timBPP)
{   
    //4BPP;
    case 0:
        surface = surface_create(imageW << 2, imageH);
        
        surface_set_target(surface);
        
        for(var dy = 0; dy < imageH; ++dy)
        {
            for(var dx = 0; dx < imageW; ++dx)
            {
                var pixelData = buffer_read(timBuffer, buffer_u16);
                
                draw_point_colour((4 * dx) + 0, dy, CLUT[pixelData & $F]);
                draw_point_colour((4 * dx) + 1, dy, CLUT[(pixelData >> 4) & $F]);
                draw_point_colour((4 * dx) + 2, dy, CLUT[(pixelData >> 8) & $F]);
                draw_point_colour((4 * dx) + 3, dy, CLUT[(pixelData >> 12) & $F]);
            }
        }
        
        break;
        
    //8BPP
    case 1:
        surface = surface_create(imageW << 1, imageH);
        
        surface_set_target(surface);
        
        for(var dy = 0; dy < imageH; ++dy)
        {
            for(var dx = 0; dx < imageW; ++dx)
            {
                var pixelData = buffer_read(timBuffer, buffer_u16);
                
                draw_point_colour((2 * dx) + 0, dy, CLUT[pixelData & $FF]);
                draw_point_colour((2 * dx) + 1, dy, CLUT[(pixelData >> 8) & $FF]);
            }
        }
        
        break;
        
    //16BPP
    case 2:
        surface = surface_create(imageW, imageH);
        
        surface_set_target(surface);
        
        for(var dy = 0; dy < imageH; ++dy)
        {
            for(var dx = 0; dx < imageW; ++dx)
            {
                var pixelData = buffer_read(timBuffer, buffer_u16);
                
                var STP = pixelData >> 15;
                
                //Convert RGBA5551 to RGB888 colour using PSX colour ramp & and non standard interpolation
                var ccR = (pixelData << 3) & $FF; //smoothstep(0, 255, (clutColour & $1F) / $1F);
                var ccG = (pixelData >> 2) & $F8; //smoothstep(0, 255, ((clutColour >> 5) & $1F) / $1F);
                var ccB = (pixelData >> 7) & $F8; //smoothstep(0, 255, ((clutColour >> 10) & $1F) / $1F);

                /*
                if(STP == 0)
                {
                    if((ccR + ccG + ccB) != 0)
                    {
                        draw_point_colour(dx, dy, make_colour_rgb(ccR, ccG, ccB));   
                    }
                }else{
                    if((ccR + ccG + ccB) != 0)
                    {
                        draw_set_alpha(0.5);
                        draw_point_colour(dx, dy, make_colour_rgb(ccR, ccG, ccB));
                        draw_set_alpha(1.0);
                    }else{
                        draw_point_colour(dx, dy, c_black);
                    }
                }
                */
                draw_point_colour(dx, dy, make_colour_rgb(ccR, ccG, ccB)); 
            }
        }
        
        break;
        
    default:
        show_debug_message("Unsupported TIM format");
        break;
}

if(surface != null)
{
    surface_reset_target();
    
    var BG = background_create_from_surface(surface, 0, 0, surface_get_width(surface), surface_get_height(surface), false, false);
    
    var arrTIM = array_create(5);
        arrTIM[0] = imageX * 4;
        arrTIM[1] = imageY;
        arrTIM[2] = imageW;
        arrTIM[3] = imageH;
        arrTIM[4] = BG;
        
    surface_free(surface);
    
    return arrTIM;
}

return null;
