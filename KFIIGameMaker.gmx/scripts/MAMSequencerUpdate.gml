///MAMSequencerUpdate(mamSequencer);

var arrAnim, arrFrames;
var arrF1, arrF2, F1id, F2id;

if(argument0[8] == true)
{
    //Reversed Animation
          
    //Increment frame interpolation value
    argument0[@ 2] += argument0[@ 4] * global.DT;
    
    //When it's greater than 1.0, switch frames.
    if(argument0[@ 2] >= 1.0)
    {
        arrAnim   = argument0[@ 1];
        arrFrames = arrAnim[1];
        
        //Decrement frame number
        argument0[@ 3]--;
        
        //See if this is a looping/non looping animation
        if(argument0[7] == true)
        {
            //Looping Animation            
            if(argument0[@ 3] <= 0)
            {
                argument0[@ 3] = arrAnim[0]-1;
            }            
            
            F1id = argument0[@ 3];
            F2id = (argument0[@ 3] - 1);          
        }else
        if(argument0[7] == false)
        {
            //Non-Looping Animation
            if(argument0[@ 3] <= 0)
            {
                argument0[@ 3] = 0;
                argument0[@ 9] = true;
            }
            
            F1id = argument0[@ 3];
            F2id = clamp(argument0[@ 3] - 1, 0, (arrAnim[0]-1));   
        }

        //Get the current and next frames
        arrF1 = arrFrames[F1id];
        arrF2 = arrFrames[F2id];

        //Set interpolation incrementation to that of the first frame
        //argument0[@ 4] = arrF1[0];
        
        //Set the streams that we draw.
        argument0[@ 5] = arrF1[1];
        argument0[@ 6] = arrF2[1];
        
        //Reset frame interpolation value
        argument0[@ 2] = frac(argument0[@ 2]);
    }    
}else
if(argument0[8] == false)
{
    //
    //Non-Reversed Animation
    //
    
    //Increment frame interpolation value
    argument0[@ 2] += argument0[@ 4] * global.DT;
    
    //When it's greater than 1.0, switch frames.
    if(argument0[@ 2] >= 1.0)
    {
        arrAnim   = argument0[1];
        arrFrames = arrAnim[1];
        
        //Increment frame number
        argument0[@ 3]++;  
        
        //See if this is a looping/non looping animation
        if(argument0[7] == true)
        {
            //Looping Animation            
            if(argument0[@ 3] >= arrAnim[0])
            {
                argument0[@ 3] = 0;
            }            
            F1id = argument0[@ 3];
            F2id = (argument0[@ 3] + 1) % arrAnim[0];
        }else
        if(argument0[7] == false)
        {
            //Non-Looping Animation
            if(argument0[@ 3] >= (arrAnim[0]-1))
            {
                argument0[@ 3] = (arrAnim[0]-1);
                argument0[@ 9] = true;
            }
            F1id = argument0[@ 3];
            F2id = clamp(argument0[@ 3] + 1, 0, (arrAnim[0]-1));
        }
        
        //Get the current and next frames
        arrF1 = arrFrames[F1id];
        arrF2 = arrFrames[F2id];

        //Set interpolation incrementation to that of the first frame
        //argument0[@ 4] = arrF1[0];
        
        //Set the streams that we draw.
        argument0[@ 5] = arrF1[1];
        argument0[@ 6] = arrF2[1];
        
        //Reset frame interpolation value, carrying the remainder
        argument0[@ 2] = frac(argument0[@ 2]);
    }
}
