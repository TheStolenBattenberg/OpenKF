#include "gmutil.h"
#include "type.h"

#include <Windows.h>

#include <fmod.hpp>
#include <vector>

#pragma region Globals
//
// Listener
//
FMOD_VECTOR lstVectorFwd = { 0.f, 0.f, 1.f };
FMOD_VECTOR lstVectorUp  = { 0.f, 1.f, 0.f };
FMOD_VECTOR lstVectorVel = { 0.f, 0.f, 0.f };
FMOD_VECTOR lstVectorPos = { 0.f, 0.f, 0.f };

FMOD::System* fmodSystem;

#pragma endregion
#pragma region Main
gmEx double AudioInit(double maxChannels)
{
	if (FMOD::System_Create(&fmodSystem) != FMOD_OK)
	{
		gmLog("AEolian -> Failed to create FMOD System");
		return -1;
	}
	if (fmodSystem->init((int32)maxChannels, FMOD_INIT_NORMAL | FMOD_INIT_THREAD_UNSAFE, NULL) != FMOD_OK)
	{
		gmLog("AEolian -> Failed to Initialize FMOD System");
		return -1;
	}
	return 0;
}
gmEx double AudioFree()
{
	//Release System
	fmodSystem->close();
	fmodSystem->release();
	return 0;
}
gmEx double AudioUpdate()
{
	fmodSystem->update();
	return 0;
}

#pragma endregion
#pragma region Sounds
gmEx double SoundLoadFromFile(string path, double flags)
{
	FMOD::Sound* pSound = NULL;

	FMOD_RESULT res;
	if (res = fmodSystem->createSound(path, (uint32)flags, NULL, &pSound), res != FMOD_OK)
	{
		gmLog("AEolian -> Failed to create sound from file...");
		gmLog(res);

		return 0;
	}

	return toDouble<FMOD::Sound>(pSound);
}
gmEx double SoundLoadFromBuffer(void* buffer, double offset, double size, double flags)
{
	FMOD::Sound* pSound = NULL;

	//Create EX Info
	FMOD_CREATESOUNDEXINFO exinfo;
	ZeroMemory(&exinfo, sizeof(FMOD_CREATESOUNDEXINFO));
	exinfo.cbsize = sizeof(FMOD_CREATESOUNDEXINFO);
	exinfo.length = (uint32) size;
	exinfo.format = FMOD_SOUND_FORMAT::FMOD_SOUND_FORMAT_PCM16;
	exinfo.numchannels = 1;
	exinfo.defaultfrequency = 22050;

	//Get buffer ptr with offset
	const char* pcmData = (const char*)buffer + (uint32)offset;

	FMOD_RESULT res;
	if (res = fmodSystem->createSound(pcmData, FMOD_OPENRAW | FMOD_OPENMEMORY | (uint32)flags, &exinfo, &pSound), res != FMOD_OK)
	{
		gmLog("AEolian -> Failed to create sound from buffer...");
		gmLog(res);

		return 0;
	}

	return toDouble<FMOD::Sound>(pSound);
}
gmEx double SoundFree(double ptrSound)
{
	toPointer<FMOD::Sound>(ptrSound)->release();
	return 0;
}
gmEx double SoundSetLoopPoints(double ptrSound, double loopStart, double loopEnd)
{
	toPointer<FMOD::Sound>(ptrSound)->setLoopPoints((uint32)loopStart, 0x00000001, (uint32)loopEnd, 0x00000001);
	return 0;
}
gmEx double SoundSetLoopCount(double ptrSound, double loopCount)
{
	toPointer<FMOD::Sound>(ptrSound)->setLoopCount((uint32)loopCount);
	return 0;
}
gmEx double SoundSetLoop(double ptrSound, double loopOnOff)
{
	FMOD::Sound* sound = toPointer<FMOD::Sound>(ptrSound);
	
	FMOD_MODE mode;
	sound->getMode(&mode);

	if ((bool)loopOnOff == true)
	{
		mode &= 0xFFFFFFFE;
		mode |= FMOD_LOOP_NORMAL;
	}
	else {
		mode &= 0xFFFFFFFD;
		mode |= FMOD_LOOP_OFF;
	}

	sound->setMode(mode);

	return true;
}
gmEx double SoundPlay(double ptrSound, double ptrBus)
{
	FMOD::Sound* sound = toPointer<FMOD::Sound>(ptrSound);
	FMOD::ChannelGroup* bus = toPointer<FMOD::ChannelGroup>(ptrBus);
	FMOD::Channel* channel;

	fmodSystem->playSound(sound, bus, false, &channel);

	return toDouble<FMOD::Channel>(channel);
}
gmEx double SoundGetState(double ptrSound)
{
	FMOD_OPENSTATE openState;

	toPointer<FMOD::Sound>(ptrSound)->getOpenState(&openState, NULL, NULL, NULL);

	return (double)(uint32)openState;
}

#pragma endregion
#pragma region Channel
gmEx double ChannelStop(double ptrChannel)
{
	toPointer<FMOD::Channel>(ptrChannel)->stop();
	return 0;
}
gmEx double ChannelSet3DPosVel(double ptrChannel, double x, double y, double z, double vx, double vy, double vz)
{
	FMOD_VECTOR pos = { (float)x, (float)y, (float)z };
	FMOD_VECTOR vel = { (float)vx, (float)vy, (float)vz };

	toPointer<FMOD::Channel>(ptrChannel)->set3DAttributes(&pos, &vel);
	return 0;
}


gmEx double ChannelSet3DMixMan(double ptrChannel, double minDist, double maxDist)
{
	toPointer<FMOD::Channel>(ptrChannel)->set3DMinMaxDistance((float)minDist, (float)maxDist);
	return 0;
}
gmEx double ChannelIsPlaying(double ptrChannel)
{
	bool isPlaying;
	toPointer<FMOD::Channel>(ptrChannel)->isPlaying(&isPlaying);

	return (double)isPlaying;
}
gmEx double ChannelSetPauseState(double ptrChannel, double pauseState)
{
	toPointer<FMOD::Channel>(ptrChannel)->setPaused((bool)pauseState);
	return 0;
}
gmEx double ChannelSetPitch(double ptrChannel, double pitch)
{
	toPointer<FMOD::Channel>(ptrChannel)->setPitch((float)pitch);
	return 0;
}
gmEx double ChannelSetFrequency(double ptrChannel, double frequency)
{
	toPointer<FMOD::Channel>(ptrChannel)->setFrequency((float)frequency);
	return 0;
}
gmEx double ChannelSet3D(double ptrChannel)
{
	FMOD::Channel* channel = toPointer<FMOD::Channel>(ptrChannel);

	return 0;
}
gmEx double ChannelSet2D(double ptrChannel)
{
	FMOD::Channel* channel = toPointer<FMOD::Channel>(ptrChannel);
	//channel->set3DLevel(0);
	return 0;
}

#pragma endregion
#pragma region Listener
gmEx double ListenerSetOrientation(double fx, double fy, double fz, double ux, double uy, double uz)
{
	lstVectorFwd = { (float)fx, (float)fy, (float)fz };
	lstVectorUp  = { (float)ux, (float)uy, (float)uz };

	return 0;
}
gmEx double ListenerSetPosition(double x, double y, double z, double vx, double vy, double vz)
{
	lstVectorPos = { (float)x, (float)y, (float)z };
	lstVectorVel = { (float)vx, (float)vy, (float)vz };

	return 0;
}
gmEx double ListenerSetCount(double numListener)
{
	fmodSystem->set3DNumListeners((uint32)numListener);
	return 0;
}
gmEx double ListenerUpdate(double listenerId)
{
	fmodSystem->set3DListenerAttributes((uint32)listenerId, &lstVectorPos, &lstVectorVel, &lstVectorFwd, &lstVectorUp);
	return 0;
}

#pragma endregion
#pragma region Bus
gmEx double BusCreate(string name)
{
	FMOD::ChannelGroup* bus;
	fmodSystem->createChannelGroup(name, &bus);

	return toDouble<FMOD::ChannelGroup>(bus);
}
gmEx double BusFree(double ptrBus)
{
	toPointer<FMOD::ChannelGroup>(ptrBus)->release();
	return 0;
}
gmEx double BusSetVolume(double ptrBus, double volume)
{
	toPointer<FMOD::ChannelGroup>(ptrBus)->setVolume((float)volume);
	return 0;
}
gmEx double BusAddChild(double ptrParent, double ptrChild)
{
	toPointer<FMOD::ChannelGroup>(ptrParent)->addGroup(toPointer<FMOD::ChannelGroup>(ptrChild), false);
	return 0;
}
gmEx double BusAddDSP(double ptrBus, double DSPindex, double ptrDSP)
{
	toPointer<FMOD::ChannelGroup>(ptrBus)->addDSP((uint32)DSPindex, toPointer<FMOD::DSP>(ptrDSP));
	return 0;
}
gmEx double BusRemoveDSP(double ptrBus, double ptrDSP)
{
	toPointer<FMOD::ChannelGroup>(ptrBus)->removeDSP(toPointer<FMOD::DSP>(ptrDSP));
	return 0;
}

#pragma endregion
#pragma region DSP

//Main DSP stuff
gmEx double DSPCreateByType(double type)
{
	FMOD::DSP* dsp;
	fmodSystem->createDSPByType((FMOD_DSP_TYPE)(uint32)type, &dsp);

	return toDouble<FMOD::DSP>(dsp);
}
gmEx double DSPSetParamF(double ptrDsp, double param, double value)
{
	toPointer<FMOD::DSP>(ptrDsp)->setParameterFloat((uint32)param, (float)value);
	return 0;
}
gmEx double DSPSetParamB(double ptrDsp, double param, double value)
{
	toPointer<FMOD::DSP>(ptrDsp)->setParameterBool((uint32)param, (bool)value);
	return 0;
}
gmEx double DSPSetParamI(double ptrDsp, double param, double value)
{
	toPointer<FMOD::DSP>(ptrDsp)->setParameterInt((uint32)param, (int32)value);
	return 0;
}
gmEx double DSPSetWetDry(double ptrDsp, double preWet, double postWet, double dry)
{
	toPointer<FMOD::DSP>(ptrDsp)->setWetDryMix((float)preWet, (float)postWet, (float)dry);
	return 0;
}
gmEx double DSPGetParamCount(double ptrDsp)
{
	int32 numParam;
	toPointer<FMOD::DSP>(ptrDsp)->getNumParameters(&numParam);

	return (double)numParam;
}
gmEx double DSPFree(double ptrDsp)
{
	FMOD::DSP* dsp;
	dsp = toPointer<FMOD::DSP>(ptrDsp);
	dsp->disconnectAll(true, true);
	dsp->release();

	return 0;
}

//Param DSP Stuff
gmEx double DSPGetParamInfo(double ptrDsp, double paramInd)
{
	FMOD_DSP_PARAMETER_DESC* paramDesc;
	toPointer<FMOD::DSP>(ptrDsp)->getParameterInfo((int32)paramInd, &paramDesc);
	return toDouble<FMOD_DSP_PARAMETER_DESC>(paramDesc);
}
gmEx string DSPParamName(double ptrPInf)
{
	return toPointer<FMOD_DSP_PARAMETER_DESC>(ptrPInf)->name;
}
gmEx string DSPParamLabel(double ptrPInf)
{
	return toPointer<FMOD_DSP_PARAMETER_DESC>(ptrPInf)->label;
}
gmEx string DSPParamDescription(double ptrPInf)
{
	return toPointer<FMOD_DSP_PARAMETER_DESC>(ptrPInf)->description;
}
gmEx double DSPParamType(double ptrPInf)
{
	return (double)toPointer<FMOD_DSP_PARAMETER_DESC>(ptrPInf)->type;
}
gmEx double DSPParamInfoFree(double ptrPInf)
{
	FMOD_DSP_PARAMETER_DESC* pInf = toPointer<FMOD_DSP_PARAMETER_DESC>(ptrPInf);
	delete pInf;

	return 0;
}
#pragma endregion

BOOL WINAPI DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved)
{
	switch (fdwReason)
	{
	case DLL_PROCESS_ATTACH:
		gmLog("AEolian now attatched to executable.");
		break;

	case DLL_PROCESS_DETACH:
		gmLog("AEolian now detatched from executable.");
		break;
	}

	return 1;
}