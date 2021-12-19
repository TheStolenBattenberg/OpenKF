///FileSystemLoadMO(fileID, overrideDir);

//Check if file exists
if(!ds_map_exists(global.FS[5], argument0))
{
    //show_debug_message("File does not exist: " + argument0);
    return null;    
}
    
//Get file info from the virtual file system
var arrFileRef = ds_map_find_value(global.FS[5], argument0);

if(arrFileRef[4] != null)
{
    //show_debug_message("File was already loaded ("+argument0+"), so returning a reference.");
    return arrFileRef[4];
}

var MDL = null;   
var CT = current_time;

//Check if an override exists for this file
if(file_exists(global.FS[2]+argument1+"\"+argument0+".mam"))
{
    //Load from overrides
    //show_debug_message("Loading " + argument0 + " from overrides...");
    MDL = MAMLoadFromFile(global.FS[2]+argument1+"\"+argument0+".mam");
}else
{
    //Override didn't exist, see if it exists within the cache
    if(file_exists(global.FS[0]+arrFileRef[1]+".mam"))
    {
        //Load from Cache
        //show_debug_message("Loading " + argument0 + " from cache...");
        MDL = MAMLoadFromFile(global.FS[0]+arrFileRef[1]+".mam");
        
    }else{
        //Load from T
        var temp = null;
        
        //Some MOs are a bit weird, so we do this switch to apply additional effects.
        switch(argument0)
        {
            case "MO_320":  //Gold Seath Water Fountain
                temp = MOLoadFromBufferUVOffset(arrFileRef[0], arrFileRef[2], 0.3515625, 0.0625, 22);
            break;
            
            case "MO_323":  //Small Water Well
                temp = MOLoadFromBufferUVOffset(arrFileRef[0], arrFileRef[2], 0.3515625, -0.125, 22);
            break;
            
            case "MO_324":  //Blue Seath Water Fountain
                temp = MOLoadFromBufferUVOffset(arrFileRef[0], arrFileRef[2], 0.3515625, -0.125, 22);
            break;
            
            case "MO_325":  //Green Seath Water Fountain
                temp = MOLoadFromBufferUVOffset(arrFileRef[0], arrFileRef[2], 0.3515625, -0.0625, 22);
            break;
            
            case "MO_326":  //Pink Seath Water Fountain
                temp = MOLoadFromBufferUVOffset(arrFileRef[0], arrFileRef[2], 0.3515625, 0, 22);
            break;
            
            default:
                temp = MOLoadFromBuffer(arrFileRef[0], arrFileRef[2]);
            break;
        }
        
        //Sort transparent tris to the end of the list
        MAMBuilderSortTransparentToEnd(temp);
        
        //Save model to the cache
        MAMModelSaveFromBuilder(temp, global.FS[0]+arrFileRef[1]+".mam");

        //Build Model
        MDL = MAMModelBuildFromBuilder(temp);
        
        temp = -1;
    }
}

//show_debug_message("Time Taken: " + string(current_time-CT));

arrFileRef[@ 4] = MDL;

return MDL;
