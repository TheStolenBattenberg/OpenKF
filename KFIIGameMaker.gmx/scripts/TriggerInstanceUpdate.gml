///TriggerInstanceUpdate(triggerInstance);

//Check if player is in the bounds of the trigger
var InX = (objPlayer.posX > argument0[6]) & (objPlayer.posX < argument0[9]);
var InY = (objPlayer.posY > argument0[7]) & (objPlayer.posY < argument0[10]);
var InZ = (objPlayer.posZ > argument0[8]) & (objPlayer.posZ < argument0[11]);

//Update trigger state
argument0[@ 4] = argument0[5];
argument0[@ 5] = (InX & InY & InZ);
