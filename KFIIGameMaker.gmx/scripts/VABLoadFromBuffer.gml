///VABLoadFromBuffer(vhBuffer, vhOffset, vbBuffer, vbOffset);

//Store buffer/offset in temporary variables
var vhBuffer = argument0;
var vhOffset = argument1;
var vbBuffer = argument2;
var vbOffset = argument3;

//Make sure we are at the required offset
buffer_seek(vhBuffer, buffer_seek_start, vhOffset);

//Start reading data as VH
var magicID  = buffer_read(vhBuffer, buffer_u32);
var version  = buffer_read(vhBuffer, buffer_u32);
buffer_seek(vhBuffer, buffer_seek_relative, 4);
var bankSize = buffer_read(vhBuffer, buffer_u32);
buffer_seek(vhBuffer, buffer_seek_relative, 2);
var numProg = buffer_read(vhBuffer, buffer_u16);
var numTone = buffer_read(vhBuffer, buffer_u16);
var numVags = buffer_read(vhBuffer, buffer_u16);
buffer_seek(vhBuffer, buffer_seek_relative, 8);

//Varify VAB
if(magicID != $56414270)
{
    show_debug_message("File is not VAB.");  
    return null;
}

//Skip Programs
buffer_seek(vhBuffer, buffer_seek_relative, 16 * 128);

//Skip Tones
buffer_seek(vhBuffer, buffer_seek_relative, 32 * (16 * numProg));

//Read VAG Table (Always 256 entries, shifted 3 to right, and only numTone is used)
var vagTableStart = 0;
var vagTable = array_create(256);
var i = 0;
do
{
    var vagData = array_create(2);
    if(i == 0)
    {
        vagData[0] = vagTableStart;                                                     //Offset
        vagData[1] = (buffer_read(vhBuffer, buffer_u16) << 3);   //Size
    }else{
        var oldData = vagTable[i-1];
        
        vagData[0] = oldData[0] + oldData[1];
        vagData[1] = (buffer_read(vhBuffer, buffer_u16) << 3);
    }
    
    vagTable[i] = vagData;
    
    i++;  
} until(i == 256)

//Coefficients
var adpcmCoeffP = array_create(5);
    adpcmCoeffP[0] = 0;
    adpcmCoeffP[1] = 60 / 64;
    adpcmCoeffP[2] = 115 / 64;
    adpcmCoeffP[3] = 98 / 64;
    adpcmCoeffP[4] = 122 / 64;
    
var adpcmCoeffN = array_create(5);  
    adpcmCoeffN[0] = 0;
    adpcmCoeffN[1] = 0;
    adpcmCoeffN[2] = -52 / 64;
    adpcmCoeffN[3] = -55 / 64;
    adpcmCoeffN[4] = -60 / 64;
 
//
// Read VAG Samples and convert them.
//
var arrWBFBuilder = WBFBuilderCreate();

var i = 0;
var waveCount = 0;
do
{
    //Get VAG Sample offsets
    var vagData = vagTable[i];
    
    //Skip Zero Size VAG
    if(vagData[1] == 0)
    {
        i++;
        continue;
    }
    
    //Seek to VAG Sample Location
    buffer_seek(vbBuffer, buffer_seek_start, vbOffset + vagData[0]);
    
    //Make buffer for decoding purposes
    var sampBuffer = buffer_create((2 * 28) * (vagData[1] / 16), buffer_fixed, 1);
    
    //Decode ADPCM samples
    DecodeADPCM(vbBuffer, vbOffset+vagData[0], vagData[1], sampBuffer);
       
    WBFBuilderSetBuffer(arrWBFBuilder, waveCount, sampBuffer);

    waveCount++;
    i++;
} until(i == array_length_1d(vagTable));

return arrWBFBuilder;
