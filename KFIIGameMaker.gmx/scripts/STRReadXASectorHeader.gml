///STRReadXASectorHeader(STR, outXASectorHeader);

///01 01 42 80 01 01 42 80

var XASectorData = argument1;

//Varify Sync Header (Slow, can be removed)
var badXAHeader = false;
for(var i = 0; i < 12; ++i)
{
    var syncByte = buffer_read(argument0[0], buffer_u8);
   
    //Varify the that first and last bytes are $00, the inbetween bytes are $FF 
    if(i == 0 || i == 11)
    {
        if(syncByte != 0)
        {
            badXAHeader = true;
            break;
        }
    }else
    if(syncByte != $FF)
    {
        badXAHeader = true;
        break;
    }
}

if(badXAHeader == true)
    return STRERR_BADXASYNC;

//Read Header
XASectorData[@ 0] = buffer_read_bcd(argument0[0]);
XASectorData[@ 1] = buffer_read_bcd(argument0[0]);
XASectorData[@ 2] = buffer_read_bcd(argument0[0]);
XASectorData[@ 3] = buffer_read(argument0[0], buffer_u8);

//Varify XAMode. Should only be 2.
if(XASectorData[@ 3] != 2)
{
    return STRERR_BADXAMODE;
}

//Read Subheader
XASectorData[@ 4] = buffer_read(argument0[0], buffer_u8);
XASectorData[@ 5] = buffer_read(argument0[0], buffer_u8);

//Read Subheader (submode);
var submode = buffer_read(argument0[0], buffer_u8);

XASectorData[@ 6] = (submode >> 7) & $1;    //Is Last Sector of File
XASectorData[@ 7] = (submode >> 6) & $1;    //Real Time
XASectorData[@ 8] = (submode >> 5) & $1;    //Form (0 = Mode 1 (2048 bytes), 1 = Mode 2 (2324 Bytes)

if(((submode >> 3) & $1))
{
    XASectorData[@ 9] = XASectorType.DATA;
}
if(((submode >> 2) & $1))
{
    XASectorData[@ 9] = XASectorType.AUDIO;
}
if(((submode >> 1) & $1))
{
    XASectorData[@ 9] = XASectorType.VIDEO;
}

//Read Subheader (coding info, only needed with audio sector)
var codingInfo = buffer_read(argument0[0], buffer_u8);
if(XASectorData[@ 9] == XASectorType.AUDIO)
{
    XASectorData[@ 10] = (codingInfo >> 4) & $1;
    XASectorData[@ 11] = (codingInfo >> 2) & $1;
    XASectorData[@ 12] = (codingInfo >> 0) & $1;
}

//Skip duplicate data
buffer_seek(argument0[0], buffer_seek_relative, 4);

return STRERR_NOERROR;
