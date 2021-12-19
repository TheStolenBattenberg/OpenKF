///AEolianInit();

var dll = "AEolian.dll";

//
// Functions
//

// Main
global.aeoAudioInit = external_define(dll, "AudioInit", dll_cdecl, ty_real, 1, ty_real);
global.aeoAudioFree = external_define(dll, "AudioFree", dll_cdecl, ty_real, 0);
global.aeoAudioUodate = external_define(dll, "AudioUpdate", dll_cdecl, ty_real, 0);

// Sounds
global.aeoSoundLoadFF = external_define(dll, "SoundLoadFromFile", dll_cdecl, ty_real, 2, ty_string, ty_real);
global.aeoSoundLoadFB = external_define(dll, "SoundLoadFromBuffer", dll_cdecl, ty_real, 4, ty_string, ty_real, ty_real, ty_real);
global.aeoSoundFree = external_define(dll, "SoundFree", dll_cdecl, ty_real, 1, ty_real);
global.aeoSoundSetLoopPoints = external_define(dll, "SoundSetLoopPoints", dll_cdecl, ty_real, 3, ty_real, ty_real, ty_real);
global.aeoSoundSetLoopCount = external_define(dll, "SoundSetLoopCount", dll_cdecl, ty_real, 2, ty_real, ty_real);
global.aeoSoundPlay = external_define(dll, "SoundPlay", dll_cdecl, ty_real, 2, ty_real, ty_real);
global.aeoSoundGetState = external_define(dll, "SoundGetState", dll_cdecl, ty_real, 1, ty_real);
global.aeoSoundSetLoop  = external_define(dll, "SoundSetLoop", dll_cdecl ,ty_real, 2, ty_real, ty_real);

// Channels
global.aeoChannelStop = external_define(dll, "ChannelStop", dll_cdecl, ty_real, 1, ty_real);
global.aeoChannelSet3DPosVel = external_define(dll, "ChannelSet3DPosVel", dll_cdecl, ty_real, 7, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real);
global.aeoChannelSet3DMinMax = external_define(dll, "ChannelSet3DMixMan", dll_cdecl, ty_real, 3, ty_real, ty_real, ty_real);
global.aeoChannelIsPlaying = external_define(dll, "ChannelIsPlaying", dll_cdecl, ty_real, 1, ty_real);
global.aeoChannelSetPauseState = external_define(dll, "ChannelSetPauseState", dll_cdecl, ty_real, 2, ty_real, ty_real);
global.aeoChannelSetPitch = external_define(dll, "ChannelSetPitch", dll_cdecl, ty_real, 2, ty_real, ty_real);
global.aeoChannelSetFrequency = external_define(dll, "ChannelSetFrequency", dll_cdecl, ty_real, 2, ty_real, ty_real);
global.aeoChannelSet3D = external_define(dll, "ChannelSet3D", dll_cdecl, ty_real, 1, ty_real);
global.aeoChannelSet2D = external_define(dll, "ChannelSet2D", dll_cdecl, ty_real, 1, ty_real);

// Listener
global.aeoListenerSetOrientation = external_define(dll, "ListenerSetOrientation", dll_cdecl, ty_real, 6, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real);
global.aeoListenerSetPosition = external_define(dll, "ListenerSetPosition", dll_cdecl, ty_real, 6, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real);
global.aeoListenerSetCount = external_define(dll, "ListenerSetCount", dll_cdecl, ty_real, 1, ty_real);
global.aeoListenerUpdate = external_define(dll, "ListenerUpdate", dll_cdecl, ty_real, 1, ty_real);

// Bus
global.aeoBusCreate = external_define(dll, "BusCreate", dll_cdecl, ty_real, 1, ty_string);
global.aeoBusFree = external_define(dll, "BusFree", dll_cdecl, ty_real, 1, ty_real);
global.aeoBusSetVolume = external_define(dll, "BusSetVolume", dll_cdecl, ty_real, 2, ty_real, ty_real);
global.aeoBusAddChild = external_define(dll, "BusAddChild", dll_cdecl, ty_real, 2, ty_real, ty_real);
global.aeoBusAddDSP = external_define(dll, "BusAddDSP", dll_cdecl, ty_real, 3, ty_real, ty_real, ty_real);
global.aeoBusRemoveDSP = external_define(dll, "BusRemoveDSP", dll_cdecl, ty_real, 2, ty_real, ty_real);

// DSP
global.aeoDSPCreateByType = external_define(dll, "DSPCreateByType", dll_cdecl, ty_real, 1, ty_real);
global.aeoDSPSetParamF = external_define(dll, "DSPSetParamF", dll_cdecl, ty_real, 3, ty_real, ty_real, ty_real);
global.aeoDSPSetParamB = external_define(dll, "DSPSetParamB", dll_cdecl, ty_real, 3, ty_real, ty_real, ty_real);
global.aeoDSPSetParamI = external_define(dll, "DSPSetParamI", dll_cdecl, ty_real, 3, ty_real, ty_real, ty_real);
global.aeoDSPSetWetDry = external_define(dll, "DSPSetWetDry", dll_cdecl, ty_real, 4, ty_real, ty_real, ty_real, ty_real);
global.aeoDSPFree = external_define(dll, "DSPFree", dll_cdecl, ty_real, 1, ty_real);

// DSP Param Info
global.aeoDSPGetParamCount = external_define(dll, "DSPGetParamCount", dll_cdecl, ty_real, 1, ty_real);
global.aeoDSPGetParamInfo = external_define(dll, "DSPGetParamInfo", dll_cdecl, ty_real, 2, ty_real, ty_real);
global.aeoDSPGetParamName = external_define(dll, "DSPParamName", dll_cdecl, ty_string, 1, ty_real);
global.aeoDSPGetParamLabel = external_define(dll, "DSPParamLabel", dll_cdecl, ty_string, 1, ty_real);
global.aeoDSPGetParamDesc = external_define(dll, "DSPParamDescription", dll_cdecl, ty_string, 1, ty_real);
global.aeoDSPGetParamType = external_define(dll, "DSPParamType", dll_cdecl, ty_real, 1, ty_real);
global.aeoDSPParamInfoFree = external_define(dll, "DSPParamInfoFree", dll_cdecl, ty_real, 1, ty_real);

//
// Enum Definition
//

enum OpenState {
    Ready,
    Loading,
    Error,
    Connecting,
    Buffering,
    Seeking,
    Playing,
    SetPosition,
};

enum SoundFlag {
    Default    = $00000000,
    LoopOff    = $00000001,
    LoopNormal = $00000002,
    LoopBidi   = $00000004,
    Is2D       = $00000008,
    Is3D       = $00000010,
    IsStream   = $00000080,
    IsSample   = $00000100,
    ASyncLoad  = $00010000,
    Unique     = $00020000   
};

enum DSPType {
    Unknown,
    Mixer,
    Oscillator,
    Lowpass,
    ITLowpass,
    Highpass,
    Echo,
    Fader,
    Flange,
    Distortion,
    Normalize,
    Limiter,
    ParamEQ,
    Pitchshift,
    Chorus,
    VstPlugin,
    WinampPlugin,
    ITEcho,
    Compressor,
    SFXReverb,
    LowpassSimple,
    Delay,
    Tremolo,
    LadspaPlugin,
    Send,
    Return,
    HighpassSimple,
    Pan,
    ThreeEQ,
    FFT,
    LoudnessMeter,
    EnvelopeFollower,
    ConvolutionReverb,
    ChannelMix,
    Transceiver,
    ObjectPan,
    MultibandEQ,
    
    Max,
    ForceInt = $FFFF        //Pointless in GM, but whatever right?    
};

//
// DSP Parameter Enums
//
enum DSPParameterType
{
    Float    = 0,
    Integer  = 1,
    Boolean  = 2,
    Data     = 3
}

enum DSPReverbSFXParam
{
    DecayTime     = 0,      //Float, Miliseconds
    EarlyDelay    = 1,      //Float, Miliseconds
    LateDelay     = 2,      //Float, Miliseconds
    HFRefererence = 3,      //Float, Hz
    HFDecayRatio  = 4,      //Float, %
    Diffusion     = 5,      //Float, %
    Density       = 6,      //Float, %
    LowShelfFreq  = 7,      //Float, Hz
    LowShelfGain  = 8,      //Float, dB
    HighCut       = 9,      //Float, Hz
    EarlyLateMix  = 10,     //Float, %
    WetLevel      = 11,     //Float, dB
    DryLevel      = 12,     //Float, dB
}
