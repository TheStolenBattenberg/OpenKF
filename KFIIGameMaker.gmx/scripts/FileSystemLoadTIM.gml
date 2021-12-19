///FileSystemLoadTIM(fileID, overrideDir);

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

var CT  = current_time;
var TEX = null;
//Check if an override exists for this file
if(file_exists(global.FS[2]+argument1+"\"+argument0+".png"))
{
    show_debug_message("Loading " + argument0 + " from overrides...");
    
    //Load PNG file
    TEX = array_create(5);
    TEX[4] = background_add(global.FS[2]+argument1+"\"+argument0+".png", false, false);
        
    //Load META file
    var bMeta = buffer_load(global.FS[2]+argument1+"\"+argument0+".meta");
        TEX[0] = buffer_read(bMeta, buffer_u16);
        TEX[1] = buffer_read(bMeta, buffer_u16);
        TEX[2] = buffer_read(bMeta, buffer_u16);
        TEX[3] = buffer_read(bMeta, buffer_u16);
    buffer_delete(bMeta);
    
}else
{
    //Override didn't exist, see if it exists within the cache
    if(file_exists(global.FS[0]+arrFileRef[1]+".png"))
    {
        //Load from Cache
        show_debug_message("Loading " + argument0 + " from cache...");
        
        //Load PNG file
        TEX = array_create(5);
        TEX[4] = background_add(global.FS[0]+arrFileRef[1]+".png", false, false);
        
        //Load META file
        var bMeta = buffer_load(global.FS[0]+arrFileRef[1]+".meta");
            TEX[0] = buffer_read(bMeta, buffer_u16);
            TEX[1] = buffer_read(bMeta, buffer_u16);
            TEX[2] = buffer_read(bMeta, buffer_u16);
            TEX[3] = buffer_read(bMeta, buffer_u16);
        buffer_delete(bMeta);
        
    }else{
        //Load from T
        show_debug_message("Loading " + argument0 + " from T...");
        
        //Get TIM From Buffer
        TEX = TIMLoadFromBuffer(arrFileRef[0], arrFileRef[2]);
        
        //Save PNG file
        background_save(TEX[4], global.FS[0]+arrFileRef[1]+".png");
        
        //Save META file
        var bMeta = buffer_create(8, buffer_fixed, 1);
            buffer_write(bMeta, buffer_u16, TEX[0]);
            buffer_write(bMeta, buffer_u16, TEX[1]);
            buffer_write(bMeta, buffer_u16, TEX[2]);
            buffer_write(bMeta, buffer_u16, TEX[3]);
        buffer_save(bMeta, global.FS[0]+arrFileRef[1]+".meta");
    }
}

show_debug_message("Time Taken: " + string(current_time-CT));

arrFileRef[@ 4] = TEX;

return TEX;
