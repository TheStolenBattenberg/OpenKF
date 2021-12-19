///STRFrameHeader();

var arrSTRFrameHeader = array_create(12);

    //JpsxDec doc on STR says this is a 4-byte entry, but Filefrmt.pdf says it's 2, 2-byte entries
    //StStatus (2 bytes)
    arrSTRFrameHeader[0] = 0;   //StSTATUS - FormatID
    arrSTRFrameHeader[1] = 0;   //StSTATUS - Version
    
    //StType (2 bytes)
    arrSTRFrameHeader[2] = 0;   //StTYPE
    
    arrStrFrameHeader[3] = 0;   //Sector number in this frame
    arrStrFrameHeader[4] = 0;   //Number of sectors in this frame.
    arrStrFrameHeader[5] = 0;   //Frame number of streaming data
    arrStrFrameHeader[6] = 0;   //Frame size in uints (4 bytes)
    arrStrFrameHeader[7] = 0;   //Frame Width in pixels
    arrStrFrameHeader[8] = 0;   //Frame Height in pixels
    arrStrFrameHeader[9] = 0;   //Number of 32-byte blocks it would take to hold the uncompressed MDEC codes
    arrStrFrameHeader[10] = 0;  //Frame's quantization scale
    arrStrFrameHeader[11] = 0;  //Frame's Version
    
return arrSTRFrameHeader;
