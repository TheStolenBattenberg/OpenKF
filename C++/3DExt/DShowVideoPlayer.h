#pragma once

#include <dshow.h>

class DShowVideoPlayer
{
public:
	bool LoadVideo(const char* filename, HWND owningWindow);
	bool PlayVideo();

private:
	IGraphBuilder* pGraphBuilder;
	IMediaControl* pMediaControl;
	IMediaEvent*   pMediaEvent;
	IVideoWindow*  pVideoWindow;
	OAFilterState* pFilterState;
};