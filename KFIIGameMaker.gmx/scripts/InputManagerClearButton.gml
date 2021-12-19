///InputManagerClearButton(mappingID);

var dev      = global.IM[@ 1];
var inputOld = dev[@ 3];
var inputNew = dev[@ 4];

inputOld[@ argument0] = false;
inputNew[@ argument0] = false;

dev[@ 3] = inputOld;
dev[@ 4] = inputNew;
global.IM[@ 1] = dev;
