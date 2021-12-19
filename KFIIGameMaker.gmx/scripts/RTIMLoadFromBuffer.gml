///RTIMLoadFromBuffer(buffer, offset, size);

//Store buffer/offset in temporary variables
var rtimBuffer = argument0;
var rtimOffset = argument1;
var rtimSize   = argument2;

//Make sure we are at the required offset
buffer_seek(rtimBuffer, buffer_seek_start, rtimOffset);

//Start Seeking for RTIM Data
var clutX1, clutY1, clutW1, clutH1, clutX2, clutY2, clutW2, clutH2, clutData;
var dataX1, dataY1, dataW1, dataH1, dataX2, dataY2, dataW2, dataH2;

var arrRTIM;
var rtimNum = 0;

//Create a surface with the maximum size of a texture page.
var tempSurf = surface_create(256, 256);

//Ready for some fuckery?
while((buffer_tell(rtimBuffer)-rtimOffset) < rtimSize-64)
{
    //Read CLUT header
    clutX1 = buffer_read(rtimBuffer, buffer_u16);
    clutY1 = buffer_read(rtimBuffer, buffer_u16);
    clutW1 = buffer_read(rtimBuffer, buffer_u16);
    clutH1 = buffer_read(rtimBuffer, buffer_u16);
    clutX2 = buffer_read(rtimBuffer, buffer_u16);
    clutY2 = buffer_read(rtimBuffer, buffer_u16);
    clutW2 = buffer_read(rtimBuffer, buffer_u16);
    clutH2 = buffer_read(rtimBuffer, buffer_u16);

    //If any of these checks fail, we just go back to the start of the loop and try again. RTIM files are ALWAYS 16 byte aligned.
    
    //Check For Valid RTIM #1
    if(clutX1 != clutX2 || clutY1 != clutY2 || clutW1 != clutW2 || clutH1 != clutH2)
        continue;
    
    //Check for valid RTIM #2
    if(clutX1 >= 1024 || clutY1 >= 512)
        continue;
     
    //Read the CLUT
    clutData = array_create(16);    //I know that this is sketchy, but RTIM is KFII is only ever 4bpp... Don't judge me :(    
    for(var i = 0; i < 16; ++i)
    {
        var rgba5551 = buffer_read(rtimBuffer, buffer_u16);
        
        //This way of shifting RGBA5551 to RGB888 is easier than the classic >> 5 & 1f << 3... Simple, gorgeous, bitshifting.
        clutData[i] = make_colour_rgb((rgba5551 << 3) & $F8, (rgba5551 >> 2) & $F8, (rgba5551 >> 7) & $F8);
    }
    
    //Read Image Header
    dataX1 = buffer_read(rtimBuffer, buffer_u16);
    dataY1 = buffer_read(rtimBuffer, buffer_u16);
    dataW1 = buffer_read(rtimBuffer, buffer_u16);
    dataH1 = buffer_read(rtimBuffer, buffer_u16);
    dataX2 = buffer_read(rtimBuffer, buffer_u16);
    dataY2 = buffer_read(rtimBuffer, buffer_u16);
    dataW2 = buffer_read(rtimBuffer, buffer_u16);
    dataH2 = buffer_read(rtimBuffer, buffer_u16);
    
    //Check For Valid RTIM #3
    if(dataX1 != dataX2 || dataY1 != dataY2 || dataW1 != dataW2 || dataH1 != dataH2)
        continue;
    
    //Check for valid RTIM #4
    if(dataX1 >= 1024 || dataY1 >= 512 || dataW1 == 0 || dataH1 == 0)
        continue;
        
    //Read Image Pixels, again assuming that this is 4BPP. We don't even switch statement... Going in raw.    
    surface_set_target(tempSurf);
    d3d_set_projection_ortho(0, 0, 256, 256, 0);
    
    for(var j = 0; j < dataH1; ++j)
    {
        for(var i = 0; i < dataW1; ++i)
        {
            //Get 4 packed pixels
            var pixels = buffer_read(rtimBuffer, buffer_u16);
            
            //Draw 4 pixels, unpacked
            draw_point_colour((4 * i) + 0, j, clutData[(pixels >>  0) & $F]);
            draw_point_colour((4 * i) + 1, j, clutData[(pixels >>  4) & $F]);
            draw_point_colour((4 * i) + 2, j, clutData[(pixels >>  8) & $F]);
            draw_point_colour((4 * i) + 3, j, clutData[(pixels >> 12) & $F]);            
        }
    }
    surface_reset_target();
    
    //Build quick texture 'struct'
    var arrTex = array_create(5);
        arrTex[0] = dataX1 * 4;
        arrTex[1] = dataY1;
        arrTex[2] = dataW1 << 2;
        arrTex[3] = dataH1;
        arrTex[4] = background_create_from_surface(tempSurf, 0, 0, dataW1 << 2, dataH1, false, false);
        
    arrRTIM[rtimNum] = arrTex;
    rtimNum++;
}

//Cheeky...
surface_free(tempSurf);

return arrRTIM;
