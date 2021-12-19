///STRFrameDemux(STR);

//Demux a frame from the sectors
var sectorHeader = XASectorHeader();
var frameHeader  = STRFrameHeader();

var demuxVideoBuffer = null;
var demuxVideoWidth  = 0;
var demuxVideoHeight = 0;
var demuxAudioBuffer = null;


var demuxComplete = false;

//Read sectors until we have demuxed a complete frame
do
{
    STRError(STRReadXASectorHeader(argument0, sectorHeader));   
    
    //Only handle video frames for now
    switch(sectorHeader[9])
    {
        //We will always skip data. Fuck data.
        case XASectorType.DATA:
            buffer_seek(argument0[0], buffer_seek_relative, XASECTOR_SIZE - 24);
            show_debug_message("Skipping Data Sector");
        break;
        
        //Copy just one (?) XA Audio Sector.
        case XASectorType.AUDIO:
            
            if(demuxAudioBuffer == null)
                demuxAudioBuffer = buffer_create(XASECTOR_SIZE - 24, buffer_fixed, 1);
                
            buffer_copy(argument0[0], buffer_tell(argument0[0]), XASECTOR_SIZE - 24, demuxAudioBuffer, 0);        
            buffer_seek(argument0[0], buffer_seek_relative, XASECTOR_SIZE - 24);
            
            show_debug_message("Demuxing Audio Frame");
        break;
        
        //Copy each video sector with equal frame number to the video demux buffer. We really rely on this for the loop to work. pure XA WILL BREAK.
        case XASectorType.VIDEO:
            //Read Frame Header (32 bytes, leaves 2016 bytes of video)
            STRReadFrameHeader(argument0, frameHeader);
            
            //The is the first sector, so we create our demux buffer for video
            if(demuxVideoBuffer == null)
                demuxVideoBuffer = buffer_create(4 * frameHeader[6], buffer_fixed, 1);
                
            //Copy remaining sector data to the demuxVideoBuffer
            buffer_copy(argument0[0], buffer_tell(argument0[0]), 2012, demuxVideoBuffer, buffer_tell(demuxVideoBuffer));
            buffer_seek(demuxVideoBuffer, buffer_seek_relative, 2012);
            
            //Skip error correction data and data we copied      
            buffer_seek(argument0[0], buffer_seek_relative, $8F8);   
            
            
            demuxVideoWidth  = frameHeader[7];
            demuxVideoHeight = frameHeader[8];
            demuxComplete = (frameHeader[3]+1) == frameHeader[4];
            
            show_debug_message("Demuxing Video Frame ["+string(frameHeader[5])+"]. (Sector "+string(frameHeader[3])+"/"+string(frameHeader[4])+")");
        break;
    }
    
    argument0[@ 2]++;
    
    //Keep going until the demuxing is complete, or we reach the end of the buffer (done with sector counts here)
} until(demuxComplete == true || argument0[@ 2] == argument0[1]);

//Return our demuxed data.
var demuxedData = array_create(2);
    demuxedData[0] = demuxVideoBuffer;
    demuxedData[1] = demuxAudioBuffer;
    demuxedData[2] = demuxVideoWidth;
    demuxedData[3] = demuxVideoHeight;
    
return demuxedData;
