///SoundPlay3DPitchXYZ(sound, pitch, x, y, z);

var sndInst = AEOSoundPlay(argument0, conAudio.busSoundFX);
AEOChannelSet3DPosVel(sndInst, argument2, argument3, argument4, 0, 0, 0);
AEOChannelSetPitch(sndInst, argument1);

return sndInst;
