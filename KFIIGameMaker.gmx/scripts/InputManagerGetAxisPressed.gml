///InputManagerGetAxisPressed(mappingID);

var dev      = global.IM[1];
var inputOld = dev[3];
var inputNew = dev[4];

var AxisOld  = inputOld[argument0];
var AxisNew  = inputNew[argument0];



return AxisNew[2] == true && AxisOld[2] == false;
