///FileSystemOpenD(filepath, flags);

//Open D Buffer, and get it's MD5 for index files.
var dBuffer = buffer_load(global.FS[1]+argument0);
var dMD5    = buffer_md5(dBuffer, 0, buffer_get_size(dBuffer));

//Open and read IDX file.
var idxF = file_text_open_read(global.FS[1]+"Index\"+dMD5+".idx");
var idxD = string_split(file_text_read_string(idxF), ",");
file_text_close(idxF);

//Store files in FileSystem
for(var i = 0; i < array_length_1d(idxD)/2; ++i)
{
    var FSFileRef = array_create(5);
        FSFileRef[0] = dBuffer;
        FSFileRef[1] = buffer_md5(dBuffer, idxD[(2 * i) + 0], idxD[(2 * i) + 1]);
        FSFileRef[2] = idxD[(2 * i) + 0];
        FSFileRef[3] = idxD[(2 * i) + 1];
        FSFileRef[4] = null;
        
    if((argument1 & FSOpenFlags.PrettifyNames) > 0)
    {
        show_debug_message("Prettifier not implemented!");
    }else{
        ds_map_add(global.FS[5], "OP_"+string(i), FSFileRef);
    }
}


ds_list_add(global.FS[4], dBuffer);
