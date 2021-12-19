///DOpen(filepath);

//Open D file as buffer
var dBuffer = buffer_load(argument0);

//Open IDX file as TXT
var dMD5 = buffer_md5(dBuffer, 0, buffer_get_size(dBuffer));

show_debug_message(argument0 + "'s MD5: " + dMD5);

var dIndexF = file_text_open_read(working_directory+"Data\Index\"+dMD5+".idx");
var dIndexes = string_split(file_text_read_string(dIndexF), ",");
file_text_close(dIndexF);

var arrD = array_create(2);
    arrD[0] = dBuffer;
    arrD[1] = dIndexes;     //{Offset, Size}, {Offset, Size}, ..., ...
    
return arrD;
