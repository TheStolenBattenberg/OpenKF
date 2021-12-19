///WBFLoad(file);

var WBFFile = buffer_load(argument0);

// Read Header
var magicID = buffer_read(WBFFile, buffer_u32);
var version = buffer_read(WBFFile, buffer_u32);
var flags   = buffer_read(WBFFile, buffer_u32);
var numWave = buffer_read(WBFFile, buffer_u32);

if(magicID != $66464257)    //MSMf
{
    show_debug_message("Invalid WBF magic ID");
    return null;
}

if(version != 1)
{
    show_debug_message("Invalid WBF version (not v1)");
    return null;
}

var sampWaves   = array_create(numWave);
var sampBuffers = array_create(1);
    sampBuffers[0] = WBFFile;
    
for(var i = 0; i < numWave; ++i)
{
    // Read Waveform Header
    var sampleRate = buffer_read(WBFFile, buffer_u32);
    var channelFmt = buffer_read(WBFFile, buffer_u32);
    var numSample  = buffer_read(WBFFile, buffer_u32);
    var sampleFmt  = buffer_read(WBFFile, buffer_u32);
    
    // Read Waveform
    sampWaves[i] = AEOSoundLoadFromBuffer(WBFFile, buffer_tell(WBFFile), numSample * 2, $00200000 | SoundFlag.IsSample | SoundFlag.Is3D);  
    buffer_seek(WBFFile, buffer_seek_relative, numSample * 2);    
}
buffer_delete(WBFFile);



var arrWBF = WBFCreate();
    arrWBF[0] = sampWaves;
    arrWBF[1] = sampBuffers;
    
return arrWBF;
