///WBFSaveFromBuilder(wbfBuilder, name);

//Calculate the size of our WBF file
var WBFSize = 16;
for(var i = 0; i < array_length_1d(argument0); ++i)
{
    WBFSize += (16 + buffer_get_size(argument0[i]));
}

//Write our WBF File
var WBFFile = buffer_create(WBFSize, buffer_fixed, 1);

//Write WBF Header
buffer_write(WBFFile, buffer_u32, $66464257);                   //Magic ID
buffer_write(WBFFile, buffer_u32, 1);                           //Version
buffer_write(WBFFile, buffer_u32, 0);                           //Flags (always 0 in version 1)
buffer_write(WBFFile, buffer_u32, array_length_1d(argument0));  //Number of Waveforms

for(var i = 0; i < array_length_1d(argument0); ++i)
{
    //Write Waveform Header
    buffer_write(WBFFile, buffer_u32, 11025);                           //Sample Rate
    buffer_write(WBFFile, buffer_u32, audio_mono);                      //Channel Type
    buffer_write(WBFFile, buffer_u32, buffer_get_size(argument0[i])/2); //Size in SAMPLES... NOT BYTES!
    buffer_write(WBFFile, buffer_u32, buffer_s16);                      //Sample Format
    
    //Copy Samples
    buffer_copy(argument0[i], 0, buffer_get_size(argument0[i]), WBFFile, buffer_tell(WBFFile));
    buffer_seek(WBFFile, buffer_seek_relative, buffer_get_size(argument0[i]));
}

buffer_save(WBFFile, argument1);

buffer_delete(WBFFile);
