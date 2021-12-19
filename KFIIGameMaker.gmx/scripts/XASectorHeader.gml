///XASectorHeader();

enum XASectorType {
    NONE  = 0,
    DATA  = 1,
    AUDIO = 2,
    VIDEO = 3
}

var arrXASectorHeader = array_create(13);

    //Main Header
    arrXASectorHeader[0] = 0;   //Minute
    arrXASectorHeader[1] = 0;   //Second
    arrXASectorHeader[2] = 0;   //Frame
    arrXASectorHeader[3] = 0;   //XAMode
    
    //Sub Header
    arrXASectorHeader[4] = 0;   //Interleaved
    arrXASectorHeader[5] = 0;   //Channel
    
    //Sub Header - Submode
    arrXASectorHeader[6] = 0;   //EoF File?
    arrXASectorHeader[7] = 0;   //Real Time?
    arrXASectorHeader[8] = 0;   //Form (0 = Mode 1 (2048 bytes), 1 = Mode 2 (2324 Bytes)
    arrXASectorHeader[9] = 0;   //XASectorType
    
    //Sub Header - Coding Info (Only when XASectorType == AUDIO)
    arrXASectorHeader[10] = 0;  //Audio Bits/Sample
    arrXASectorHeader[11] = 0;  //Audio Sample Rate
    arrXASectorHeader[12] = 0;  //Audio Channels
    
return arrXASectorHeader;
