//
// WBF - Waveform Bank Format
// File Ver = 1.0, Spec Ver = 1.0
//

struct WBFHeader {
	uint magicID;
	uint version;
	uint flags;
	uint numWaveform;
};

struct WBFWaveform
{
	uint sampleRate;
	uint channelType;
	uint numSamples;
	uint sampleFormat;
	
	short samples[numSamples];
};