///UIDestroy(uiInstance);

var index = ds_list_find_index(global.UIManager.uiList, argument0);
ds_list_delete(global.UIManager.uiList, index);

//Reset Focus UI
if(global.UIManager.uiFocus == argument0)
{
    global.UIManager.uiFocus = global.UIManager.uiList[| ds_list_size(global.UIManager.uiList)-1];
}

with(argument0)
    instance_destroy();
