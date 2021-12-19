///FileSystemLoadVAB(fileID, overrideDir);

//Check if file exists
if(!ds_map_exists(global.FS[5], argument0))
{
    show_debug_message("File does not exist: " + argument0);
    return null;    
}
    
//Get file info from the virtual file system
var arrFileRef = ds_map_find_value(global.FS[5], argument0);

if(arrFileRef[4] != null)
{
    show_debug_message("File was already loaded ("+argument0+"), so returning a reference.");
    return arrFileRef[4];
}

var WBF = null;   
var CT = current_time;

//Check if an override exists for this file
if(file_exists(global.FS[2]+argument1+"\"+argument0+".wbf"))
{
    //Load from overrides
    show_debug_message("Loading " + argument0 + " from overrides...");
    WBF = WBFLoad(global.FS[2]+argument1+"\"+argument0+".wbf");
}else
{
    //Override didn't exist, see if it exists within the cache
    if(file_exists(global.FS[0]+arrFileRef[1]+".wbf"))
    {
        //Load from Cache
        show_debug_message("Loading " + argument0 + " from cache...");    
        WBF = WBFLoad(global.FS[0]+arrFileRef[1]+".wbf");
    }else{
        //Load from T
        show_debug_message("Loading " + argument0 + " from T...");
        
        var temp = VABLoadFromBuffer(arrFileRef[0], arrFileRef[2], arrFileRef[0], arrFileRef[2]+arrFileRef[3]);
        
        WBFSaveFromBuilder(temp, global.FS[0]+arrFileRef[1]+".wbf");
        
        WBF = WBFBuildFromBuilder(temp);          
    }
}

show_debug_message("Time Taken: " + string(current_time-CT));

arrFileRef[@ 4] = WBF;
return WBF;
