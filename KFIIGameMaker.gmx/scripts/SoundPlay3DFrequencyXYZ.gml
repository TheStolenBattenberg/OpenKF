///SoundPlay3DFrequencyXYZNF(sound, freq, x, y, z, near, far);

var sndInst = AEOSoundPlay(argument0, conAudio.busSoundFX);
AEOChannelSetFrequency(sndInst, argument1);
AEOChannelSet3DPosVel(sndInst, argument2, argument3, argument4, 0, 0, 0);
AEOChannelSet3DMinMax(sndInst, argument5, argument6);

return sndInst;
