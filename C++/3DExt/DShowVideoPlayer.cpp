#include "DShowVideoPlayer.h"
#include <atlstr.h>

bool DShowVideoPlayer::LoadVideo(const char* filename, HWND owningWindow)
{
	//Create Graph Builder, and pass file name.
	if (FAILED(CoCreateInstance(CLSID_FilterGraph, NULL, CLSCTX_INPROC_SERVER, IID_IGraphBuilder, (void**)&pGraphBuilder)))
		return false;

	pGraphBuilder->RenderFile(CA2CT(filename), NULL);

	//Create Video Window
	if (FAILED(pGraphBuilder->QueryInterface(IID_IVideoWindow, (void**)&pVideoWindow)))
		return false;

	pVideoWindow->put_Owner((OAHWND)owningWindow);
	pVideoWindow->put_WindowStyle(WS_CHILD | WS_CLIPSIBLINGS);

	RECT clientRect;
	GetClientRect(owningWindow, &clientRect);
	pVideoWindow->SetWindowPosition(0, 0, clientRect.right, clientRect.bottom);

	//Create Media Control
	if (FAILED(pGraphBuilder->QueryInterface(IID_IMediaControl, (void**)&pMediaControl)))
		return false;
	
	//Create Media Event
	if (FAILED(pGraphBuilder->QueryInterface(IID_IMediaEvent, (void**)&pMediaEvent)))
		return false;

	return true;
}
bool DShowVideoPlayer::PlayVideo()
{
	if (FAILED(pMediaControl->Run()))
		return false;

	return true;
}