///STRFrameDecompress(STR, demuxedFrame);

var fuck = argument0;

buffer_seek(argument1[0], buffer_seek_start, 0);

//Read frame header
demuxVideoBuffer = argument1[0];

var num32byteBlocks = buffer_read(demuxVideoBuffer, buffer_u16);
buffer_read(demuxVideoBuffer, buffer_u16);  //0x3800
var quantScale = buffer_read(demuxVideoBuffer, buffer_u16);
var frameVersion = buffer_read(demuxVideoBuffer, buffer_u16);

switch(frameVersion)
{
    case $02:
        show_debug_message("Decompressing Version 2 Frame...");
        return STRFrameV2Decompress(argument0, argument1);     
    break;
    
    default:
        show_debug_message("Unsupported STR frame version.");
    break;
}

return null;
