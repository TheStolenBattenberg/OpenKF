///STRReadFrameHeader(STR, outSTRFrameHeader);

var arrSTRFrameHeader = argument1;

var StStatus = buffer_read(argument0[0], buffer_u16);
arrSTRFrameHeader[@ 0] = (StStatus >> 4) & $F;
arrSTRFrameHeader[@ 1] = (StStatus >> 8) & $F;

arrSTRFrameHeader[@ 2] = buffer_read(argument0[0], buffer_u16);
arrSTRFrameHeader[@ 3] = buffer_read(argument0[0], buffer_u16);
arrSTRFrameHeader[@ 4] = buffer_read(argument0[0], buffer_u16);

arrSTRFrameHeader[@ 5] = buffer_read(argument0[0], buffer_u32);
arrSTRFrameHeader[@ 6] = buffer_read(argument0[0], buffer_u32);

arrSTRFrameHeader[@ 7] = buffer_read(argument0[0], buffer_u16);
arrSTRFrameHeader[@ 8] = buffer_read(argument0[0], buffer_u16);
arrSTRFrameHeader[@ 9] = buffer_read(argument0[0], buffer_u16);
buffer_read(argument0[0], buffer_u16);
arrSTRFrameHeader[@ 10] = buffer_read(argument0[0], buffer_u16);
arrSTRFrameHeader[@ 11] = buffer_read(argument0[0], buffer_u16);

buffer_seek(argument0[0], buffer_seek_relative, 4);
