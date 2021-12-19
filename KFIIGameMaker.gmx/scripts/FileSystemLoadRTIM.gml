///FileSystemLoadRTIM(fileID, overrideDir);

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
var TEXBANK = null;
//Check if an override exists for this file
if(directory_exists(global.FS[2]+argument1))
{
    //Load from Overrides
    show_debug_message("Loading " + argument0 + " from overrides...");
    
    TEXBANK = array_create(1);        
    var i = 0;
    
    while(file_exists(global.FS[2]+argument1+"\"+string(i)+".png"))
    {
        var arrTex = array_create(5);
        
        //Load PNG
        arrTex[4] = background_add(global.FS[2]+argument1+"\"+string(i)+".png", false, false);
        
        //Load Meta
        var bMeta = buffer_load(global.FS[2]+argument1+"\"+string(i)+".meta");
        arrTex[0] = buffer_read(bMeta, buffer_u16);
        arrTex[1] = buffer_read(bMeta, buffer_u16);
        arrTex[2] = buffer_read(bMeta, buffer_u16);
        arrTex[3] = buffer_read(bMeta, buffer_u16);
        buffer_delete(bMeta);
        
        TEXBANK[i] = arrTex;
        i++;
    }    
}else
{
    //Override didn't exist, see if it exists within the cache
    if(directory_exists(global.FS[0]+arrFileRef[1]))
    {
        //Load from Cache
        show_debug_message("Loading " + argument0 + " from cache...");
        
        TEXBANK = array_create(1);        
        var i = 0;
        
        while(file_exists(global.FS[0]+arrFileRef[1]+"\"+string(i)+".png"))
        {
            var arrTex = array_create(5);
            
            //Load PNG
            arrTex[4] = background_add(global.FS[0]+arrFileRef[1]+"\"+string(i)+".png", false, false);
            
            //Load Meta
            var bMeta = buffer_load(global.FS[0]+arrFileRef[1]+"\"+string(i)+".meta");
            arrTex[0] = buffer_read(bMeta, buffer_u16);
            arrTex[1] = buffer_read(bMeta, buffer_u16);
            arrTex[2] = buffer_read(bMeta, buffer_u16);
            arrTex[3] = buffer_read(bMeta, buffer_u16);
            buffer_delete(bMeta);
            
            TEXBANK[i] = arrTex;
            i++;
        }
        
    }else{
        //Load from T
        show_debug_message("Loading " + argument0 + " from T...");
        
        //Get RTIMs
        TEXBANK = RTIMLoadFromBuffer(arrFileRef[0], arrFileRef[2], arrFileRef[3]);
        
        //Caching works a little differently here.
        directory_create(global.FS[0]+arrFileRef[1]);
        
        //Create buffer for saving metadata
        var bMeta = buffer_create(8, buffer_fixed, 1);
        
        //Save each RTIM as a PNG
        for(var i = 0; i < array_length_1d(TEXBANK); ++i)
        {
            var arrTex = TEXBANK[i];
            
            //Save PNG
            background_save(arrTex[4], global.FS[0]+arrFileRef[1]+"\"+string(i)+".png");
            
            //Save Metadata
            buffer_seek(bMeta, buffer_seek_start, 0);
            buffer_write(bMeta, buffer_u16, arrTex[0]);
            buffer_write(bMeta, buffer_u16, arrTex[1]);
            buffer_write(bMeta, buffer_u16, arrTex[2]);
            buffer_write(bMeta, buffer_u16, arrTex[3]);                
            buffer_save(bMeta, global.FS[0]+arrFileRef[1]+"\"+string(i)+".meta");
        }
        
        //Free buffer for saving metadata
        buffer_delete(bMeta);        
    }
}

show_debug_message("Time Taken: " + string(current_time-CT));

arrFileRef[@ 4] = TEXBANK;

return TEXBANK;
