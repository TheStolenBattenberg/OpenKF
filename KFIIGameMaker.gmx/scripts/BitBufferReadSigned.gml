///BitBufferReadSigned(bitbuffer, numBits);

//Make sure we have bits ready


var bits = 0;
var bit;

//Accumulate Bits
numBits = 0;
do
{
    //We've reached the end of our alloted bits, so we need to buffer new bits. 
    if(argument0[@ 2] == 16)
    {
        argument0[@ 1] = buffer_read(argument0[@0], buffer_u16);
        argument0[@ 2] = 0;
    }
        
    //Some absolute magic.
    bit =(argument0[@ 1] & $1);
          argument0[@ 1] = (argument0[@ 1] >> 1);
          argument0[@ 2]++;

    //Add the read bit to our accumulated bits...
    bits = bits | (bit << numBits);
    
    numBits++;
} until(numBits == argument1)

//Quick hack for signed bits. Which side is a sign on though?
if((bits & $1) == 1)
    bits = -(bits >> 1);
else{
    bits = bits >> 1;
}

return bits;