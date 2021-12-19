///GameSetMap(mapObject);

show_debug_message("Map Changed To: " + object_get_name(argument0));

if(conMain.gameMap != null)
{
    with(conMain.gameMap)
        instance_destroy();
}

conMain.gameMap = instance_create(0, 0, argument0);
