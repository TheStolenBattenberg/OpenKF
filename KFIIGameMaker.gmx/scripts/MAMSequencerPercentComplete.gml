///MAMSequencerComplete(mamSequencer);

var Animation = argument0[1];

//Animation is reversed, so we need to flip this to get the correct value...
if(argument0[8] == true)
    return ((argument0[3] - argument0[2]) / (Animation[0]-1))  

return (argument0[3] + argument0[2]) / (Animation[0]-1);
