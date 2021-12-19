///MusicFadeOut(timeSeconds);

if(conMain.audioInst != null)
{
    audio_sound_gain(conMain.audioInst, 0.0, 1000 * argument[0]);
}
