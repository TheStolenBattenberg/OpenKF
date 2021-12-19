///FileSystemLoadMAP1(fileID, overrideDir);

//Check if file exists
if(!ds_map_exists(global.FS[5], argument0))
    return null;
    
//Get file info from the virtual file system
var arrFileRef = ds_map_find_value(global.FS[5], argument0);
    
if(arrFileRef[4] != null)
{
    show_debug_message("File was already loaded ("+argument0+"), so returning a reference.");
    return arrFileRef[4];
}

var CT   = current_time;
var MAP1 = null;
//Check if an override exists for this file
if(file_exists(global.FS[2]+argument1+"\"+argument0+".png"))
{
    show_debug_message("Loading " + argument0 + " from overrides...");    
}else
{
    //Override didn't exist, see if it exists within the cache
    if(file_exists(global.FS[0]+arrFileRef[1]+".png"))
    {
        
    }else{
        //Load from T
        show_debug_message("Loading " + argument0 + " from T...");
        
        MAP1 = MAP1LoadFromBuffer(arrFileRef[0], arrFileRef[2]);
    }
}

show_debug_message("Time Taken: " + string(current_time-CT));

return MAP1;
