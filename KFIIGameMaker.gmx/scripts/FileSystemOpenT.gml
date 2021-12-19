///FileSystemOpenT(filepath, flags);

//Open T Buffer, get T name
var tBuffer = buffer_load(global.FS[1]+argument0);
var tName = string_replace(filename_name(argument0), ".T", "");

//Read T Offsets
var numOffset = buffer_read(tBuffer, buffer_u16);

var offStart, offEnd;
for(var i = 0; i < numOffset; ++i)
{
    //Read/Peek data from Ts File Table
    offStart = buffer_read(tBuffer, buffer_u16) << 11;
    offEnd   = buffer_peek(tBuffer, buffer_tell(tBuffer), buffer_u16) << 11;
    
    //Gotta make sure the size isn't lt/e 0 'cause T files have fake offsets.
    if((offEnd-offStart) <= 0)
        continue;
   
    //Build a FileRef for our FileSystem
    var FSFileRef = array_create(5);
        FSFileRef[0] = tBuffer;
        FSFileRef[1] = buffer_md5(tBuffer, offStart, offEnd-offStart);
        FSFileRef[2] = offStart;
        FSFileRef[3] = offEnd-offStart;
        FSFileRef[4] = null;    

    if((argument1 & FSOpenFlags.PrettifyNames) > 0)
    {
        show_debug_message("Prettifier not implemented!");
    }else{
        ds_map_add(global.FS[5], tName+"_"+string(i), FSFileRef);
    }
}

ds_list_add(global.FS[4], tBuffer);
