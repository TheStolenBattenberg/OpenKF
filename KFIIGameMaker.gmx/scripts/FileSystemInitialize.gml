///FileSystemInitialize(flags);

enum FSFlag
{
    None            = $00,
    IgnoreCache     = $01,
    IgnoreOverrides = $02
}

enum FSOpenFlags {
    None = 0,
    PrettifyNames = $01
}

var arrFS = array_create(6);
    arrFS[0] = environment_get_variable("appdata")+"\"+game_project_name+"\cache\";     //Location of the cached files
    
    if(build == 1)
    {
        arrFS[1] = program_directory + "Data\";                                         //Location of the data files
        arrFS[2] = program_directory + "DataOverride\";                                 //Location of override files
    }else{
        arrFS[1] = "Data\";
        arrFS[2] = "DataOverride\";
    }
    
    arrFS[3] = argument0;                                                               //Flags
    arrFS[4] = ds_list_create();                                                        //Data Buffers (T, D)
    arrFS[5] = ds_map_create();                                                         //File Map

global.FS = arrFS;

