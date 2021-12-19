///PlayerStateMoving();
gml_pragma("forceinline");  //Only used in one place, script for cleanliness.

//Get Player AxisRH and AxisLH
var AxisRH = InputManagerGetAxis(InputMap.AxisRH);
var AxisLH = InputManagerGetAxis(InputMap.AxisLH);

//Set Player Rotation X
rotX -= AxisRH[1];

//When falling, force player to look down slowly...
if(posLastSafeY - posY > 2) //EHEHEHEHEHEHE fuck man...
{
    rotX += 8 * udSpeed;
}

rotX = clamp(rotX, -90, 90);

//Set Player Rotation Y (Wrap < -360 and > 360)
rotY += AxisRH[0];
rotY = rotY - (360 * floor(rotY/360));

//Do Player Movement (normal)
var nextX = 0, nextZ = 0, nextY;

//Calculate move speed

//Am I running?
if(!InputManagerGetHeld(InputMap.Run) || PlayerGetBadStatusSet(BadPlayerStatus.Crippled))
{
    //When Axis isn't 0'd (x or y)
    if(AxisLH[0] != 0 || AxisLH[1] != 0)
    {
        lrSpeed = smoothstep(lrSpeed, speedWalk*-AxisLH[0], accelWalk);
        fbSpeed = smoothstep(fbSpeed, speedWalk*-AxisLH[1], accelWalk);
    }else{
        lrSpeed = smoothstep(lrSpeed, 0, decelWalk);
        fbSpeed = smoothstep(fbSpeed, 0, decelWalk);
    }
    
    //When crippled status set, reduce speed to half.
    if(PlayerGetBadStatusSet(BadPlayerStatus.Crippled))
    {
        lrSpeed *= 0.8;
        fbSpeed *= 0.8;
    }
}else{
    if(AxisLH[0] != 0 || AxisLH[1] != 0)
    {
        lrSpeed = smoothstep(lrSpeed, speedRun*-AxisLH[0], accelRun);
        fbSpeed = smoothstep(fbSpeed, speedRun*-AxisLH[1], accelRun);
    }else{
        lrSpeed = smoothstep(lrSpeed, 0, decelRun);
        fbSpeed = smoothstep(fbSpeed, 0, decelRun);
    }
}

//Calculate our next XYZ
nextX += ((dsin(rotY+90) * fbSpeed) + (dsin(rotY) * lrSpeed)) * global.DT;
nextZ += ((dcos(rotY+90) * fbSpeed) + (dcos(rotY) * lrSpeed)) * global.DT;
nextY = udSpeed * global.DT;

//Check if there is overlap where the player currently is.
if(CollisionWorldOverlap(posX+nextX, posY, posZ+nextZ, 0, 0, 0, CMask.Player, CMask.Static | CMask.Object, cBody))
{
    //Reset udSpeed. fuck you udSpeed and all your bugs.
    udSpeed = 0;
    nextY   = 0;
    
    //Calculate the next positions ahead of time
    var cNX = posX + nextX;
    var cNY = posY + 0.15;
    var cNZ = posZ + nextZ;    
    
    //Check if there is overlap where the player wants to go
    var cAtNextA = CollisionWorldOverlap(cNX, cNY, cNZ, 0, 0, 0, CMask.Player, CMask.Static, cBody);
    
    //Can't be collision above the player...
    if(cAtNextA)
    {    
        //Now we do a trace to find the climb height we want to go to.
        var numSteps = 8;
        var stepSize = maxClimbHeight / numSteps;
        var steps = 0;
        
        repeat(numSteps)
        {
            if(!CollisionWorldOverlap(cNX, cNY+steps, cNZ, 0, 0, 0, CMask.Player, CMask.Static, cBody))
            {
                nextY = steps;
                posLastY = posY;                
                break;
            }
            steps += stepSize;
        }
    }
    
    //Player Fell Hard...
    if(posLastSafeY - posY > 2)
    {
        PlayerSetBadStatus(BadPlayerStatus.Crippled);
        SoundPlay2DFrequency(WBFGetWave(conMain.gameSound, 4), 10025);
    }
    
    //Set Safe Y
    posLastSafeY = posY; 
}else{
    //We are not on ground, accelerate udSpeed
    udSpeed = lerp(udSpeed, -2.8, 0.002);
}

//Check/Cancel X
if(CollisionWorldOverlap(posX + nextX, posY + 0.15, posZ, 0, 0, 0, CMask.Player, CMask.Static | CMask.Object, cBody))
    nextX = 0;

//Check/Cancel Z
if(CollisionWorldOverlap(posX, posY + 0.15, posZ + nextZ, 0, 0, 0, CMask.Player, CMask.Static | CMask.Object, cBody))
    nextZ = 0;  

posX += nextX;
posZ += nextZ;
posY += nextY;
