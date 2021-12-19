///FileSystemWriteFileMap();

var textFile = file_text_open_write("fs_filemap.txt");

var mapEntry = ds_map_find_first(global.FS[5]);
while(mapEntry != undefined)
{
    file_text_write_string(textFile, mapEntry);
    file_text_writeln(textFile);

    mapEntry = ds_map_find_next(global.FS[5], mapEntry);
}

file_text_close(textFile);
