///GameConfigApply();

//
// Apply render config
//

//Resolution / Window Size
window_set_size(conMain.GameConfig[? "windowWidth"], conMain.GameConfig[? "windowHeight"]);
window_set_position(display_get_width()/2 - conMain.GameConfig[? "windowWidth"]/2, display_get_height()/2 - conMain.GameConfig[? "windowHeight"]/2);

window_set_fullscreen(conMain.GameConfig[? "windowFullscreen"]);

//Language
LanguageLoad(conMain.GameConfig[? "gameLanguage"]);
