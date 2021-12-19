///PlayerSetGoodStatus(GoodPlayerStatus);

enum GoodPlayerStatus
{
    MissileShield = $0001,
    ResistFire    = $0002,
    Light         = $0004,
    DemonsPick    = $0008,
    SeathsPlume   = $0010,
    PhantomRod    = $0020,
}

//Set the bit for this status.
statusGood = statusGood | argument0;

//Set Status Timer (Seconds)
switch(argument0)
{
    case GoodPlayerStatus.MissileShield:
       statusMissileShieldTimer = 60;   //1 Minute
       break;
    case GoodPlayerStatus.ResistFire:
        statusResistFireTimer = 60;     //1 Minute
        break;
    case GoodPlayerStatus.Light:
        statusLightTimer = 300;         //5 Minutes
        break;
    case GoodPlayerStatus.SeathsPlume:
        statusSeathsPlumeTimer = 60;    //1 Minute
        break;
    case GoodPlayerStatus.PhantomRod:
        statusPhantomRodTimer = 300;    //5 Minutes (actually useful...)
        break;
}
