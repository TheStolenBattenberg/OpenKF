///STROpen(strFile);

var arrStr = array_create(4);

arrStr[0] = buffer_load(argument0); //File Stream (Buffer);
arrStr[1] = 0;                      //Total sector count
arrStr[2] = 0;                      //Current sector index


// Do some calculations to save us time later.
arrStr[1] = buffer_get_size(argument0)  / 2352;     //This should give us the total amount of sectors in the file


show_debug_message("STROpen ->");
show_debug_message("Buffer ID: " + string(arrStr[0]));
show_debug_message("Buffer Size: " + string(buffer_get_size(arrStr[0])));
show_debug_message("Total Sectors: " + string(arrStr[1]));

buffer_seek(arrStr[0], buffer_seek_start, 0);

return arrStr;
