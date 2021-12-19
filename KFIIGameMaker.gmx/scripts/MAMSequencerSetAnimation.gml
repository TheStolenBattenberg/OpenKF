///MAMSequencerSetAnimation(mamSequencer, animID, looping, reverse);

//Get MAM reference for error catching
var refMAM = argument0[0];
var refAnm = refMAM[3];

if(argument1 >= array_length_1d(refAnm))
{
    show_debug_message("MAMSequencer -> Invalid Animation ID");
    return null;
}

//Reset Sequencer State
argument0[@ 1] = refAnm[argument1];
argument0[@ 2] = 0; //Reset Interpolation Value
argument0[@ 3] = 0; //Reset Frame
argument0[@ 4] = 0;
argument0[@ 5] = 0;
argument0[@ 6] = 0;
argument0[@ 7] = argument2;
argument0[@ 8] = argument3;
argument0[@ 9] = false;

//Set Initial Interpolation Increment
var Animation = refAnm[argument1];
var Frames    = Animation[1];

if(argument3)
{
    var CurrentF  = Frames[clamp(Animation[0]-1, 0, Animation[0]-1)];
    var NextF     = Frames[clamp(Animation[0]-2, 0, Animation[0]-1)];    
    argument0[@ 3] = Animation[0]-1;
}else{
    var CurrentF  = Frames[0];
    var NextF     = Frames[1];
}

argument0[@ 4] = CurrentF[0];
argument0[@ 5] = CurrentF[1];
argument0[@ 6] = NextF[1];
