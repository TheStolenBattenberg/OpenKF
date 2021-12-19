///BitBufferSeek(bitbuffer, mode, numBits);

switch(argument1)
{
    case buffer_seek_relative:
        //Calculate number of ushorts to seek forward
        var seeku16 = floor(argument2 / 16);
        
        //Calculate remaining bits to seek after ushort seek.
        var seekbit = argument2 % 16;
        
        //First seek the ushorts
        buffer_seek(argument0[0], buffer_seek_relative, 2 * seeku16);
        
        //Now seek bits.
        while(seekbit > 0) 
        {
            if(argument0[@ 2] == 16)
            {
                argument0[@ 1] = buffer_read(argument0[@0], buffer_u16);
                argument0[@ 2] = 0;
            }
            
            argument0[@ 1] = (argument0[@ 1] >> 1);
            argument0[@ 2]++; 
            
            show_debug_message("Did bit seek");
            
            seekbit--;       
        }
        
    break;
}
