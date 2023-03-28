#include <Windows.h>
#include <vector>
#include <fmod.h>

#include "gmutil.hpp"
#include "types.hpp"

BOOL WINAPI DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved)
{
	switch (fdwReason)
	{
	case DLL_PROCESS_ATTACH:
		gmLog("AEolian successfully attached.");
		break;

	case DLL_PROCESS_DETACH:
		gmLog("AEolian successfully detatched.");
		break;
	}

	return 1;
}