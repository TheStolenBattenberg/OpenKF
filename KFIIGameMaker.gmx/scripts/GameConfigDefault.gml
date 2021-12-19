///GameConfigDefault();

enum RenderAPI {
    DirectX9  = 0,
    DirectX12 = 1,
    Vulkan    = 2
}

var config = ds_map_create();

// Window
config[? "windowWidth"]      = 960;
config[? "windowHeight"]     = 540;
config[? "windowFullscreen"] = false;

config[? "renderWidth"]      = 640;
config[? "renderHeight"]     = 480;

config[? "renderAPI"]        = RenderAPI.DirectX9;

// Audio
config[? "audioMusicVolume"] = 1.0;
config[? "audioSoundVolume"] = 1.0;

// HUD
config[? "hudCompassType"] = 0;
config[? "hudStatusType"]  = 0;

// Game
config[? "gameLanguage"] = "EnglishUK";

// Controls
config[? "controlLookUD"] = null;
config[? "controlLookLR"] = null;
config[? "controlMoveFB"] = null;
config[? "controlMoveLR"] = null;

return config;