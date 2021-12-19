///FileSystemCachedFolderName(fileID);

//Check if file exists
if(!ds_map_exists(global.FS[5], argument0))
    return false;
    
//Get file info from the virtual file system
var arrFileRef = ds_map_find_value(global.FS[5], argument0);

return global.FS[0] + arrFileRef[1] + "\";
