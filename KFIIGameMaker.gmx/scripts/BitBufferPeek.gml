///BitBufferPeek(bitbuffer, numBits);

//Make sure we have bits ready
var bits = 0;
var bit;

//Store the current state of the BitBuffer/GMBuffer
var bufferTell  = buffer_tell(argument0[@0]);
var bitsRead    = argument0[@ 2];
var bufferValue = argument0[@ 1];

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

//Restore the state of our BitBuffer to what it was before we peeked...
buffer_seek(argument0[@0], buffer_seek_start, bufferTell);
argument0[@ 1] = bufferValue;
argument0[@ 2] = bitsRead;

return bits;
