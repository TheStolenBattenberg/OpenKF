///PlayerInstantiate()

if(instance_number(objPlayer) > 0)
{
    show_debug_message("Tried to instantiate a second player... Only one can exist.");
    return false;
}

global.Player = instance_create(0, 0, objPlayer);
