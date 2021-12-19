///STRFrameV2Decompress(STR, demuxedFrame);

/**
 * V2 frames are (according to the JpsxDec docs) the easiest to read.
 * THANK YOU KING'S FIELD! <3
**/

var STR = argument0;

//Wrap our buffer in a bit buffer.
var bitBuffer = BitBuffer(argument1[0]);

//Start by reading the 10-bit DC Coefficient from the compressed bit stream
var dcCoefficient = BitBufferRead(bitBuffer, 10);

//Now we decompress the AC Coefficients..
var ACCoeff

/*
  - One "Discrete Cosine Transform Direct Current Coefficient"
  - Zero or more "Discrete Cosine Transform Alternating Current Coefficients"
  - One "End of Block" code
  
*/
