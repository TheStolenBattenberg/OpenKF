///PlayerSetBadStatus(BadPlayerStatus);

enum BadPlayerStatus
{
    Poison   = $0001,
    Dark     = $0002,
    Slow     = $0004,
    Paralyze = $0008,
    Curse    = $0010,
    Crippled = $0020,
    Mask     = $FFFF
}

//Set the bit for this status.
statusBad = statusBad | argument0;

//Set Status Timer (Seconds)
switch(argument0)
{
    case BadPlayerStatus.Poison:    //1 Minute, 30 Seconds
        statusPosionTimer = 90;
    break;
    
    case BadPlayerStatus.Dark:      //1 Minute
        statusDarkTimer = 60;
    break;
    
    case BadPlayerStatus.Slow:      //1 Minute
        statusSlowTimer = 60;
    break;
    
    case BadPlayerStatus.Paralyze:  //5 Seconds
        statusParalyzeTimer = 5;
    break;
    
    case BadPlayerStatus.Curse:     //3 Minutes
        statusSlowTimer = 180;
    break;
    
    case BadPlayerStatus.Crippled:
        statusCrippledTimer = 3;    //3 Seconds
    break;
}
