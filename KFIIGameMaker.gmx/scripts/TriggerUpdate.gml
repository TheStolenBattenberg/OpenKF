///TriggerUpdate(arrTrigger);

///Check if player is area of trigger...
var InX = (conRenderer.camXfrom > argument0[2]) & (conRenderer.camXfrom < argument0[5]);
var InY = (conRenderer.camYfrom > argument0[3]) & (conRenderer.camYfrom < argument0[6]);
var InZ = (conRenderer.camZfrom > argument0[4]) & (conRenderer.camZfrom < argument0[7]);

//Update trigger state...
argument0[@ 0] = argument0[1];
argument0[@ 1] = InX & InY & InZ;
