///WBFBuildFromBuilder(wbfBuilder);
var waves  = array_create(array_length_1d(argument0));

for(var i = 0; i < array_length_1d(argument0); ++i)
{
    //Get Sample Buffer from builder
    var sampBuffer = argument0[i];
    
    //Build Sample Buffer
    //waves[i] = audio_create_buffer_sound(sampBuffer, buffer_s16, 11025, 0, buffer_get_size(sampBuffer), audio_mono);
    waves[i] = AEOSoundLoadFromBuffer(sampBuffer, 0, buffer_get_size(sampBuffer), SoundFlag.Default | SoundFlag.IsSample);   
    buffer_delete(sampBuffer);
}

var arrWBF = WBFCreate();
    arrWBF[0] = waves;
    arrWBF[1] = argument0;
return arrWBF;
