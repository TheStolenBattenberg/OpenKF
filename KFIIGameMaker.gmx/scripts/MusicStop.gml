///MusicStop();

if(conMain.audioInst != null)
{
    audio_stop_sound(conMain.audioInst);
}

if(conMain.audioStream != null)
{
    audio_destroy_stream(conMain.audioStream); 
}

ds_queue_clear(conMain.audioQueue);
