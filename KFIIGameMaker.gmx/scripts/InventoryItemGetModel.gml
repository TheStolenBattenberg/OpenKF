///InventoryItemGetModel(InventoryItem);

if(argument0 == undefined || argument0 == null)
    return null;

var arrItemClass = conMain.ItemDatabase[? argument0[0]];

return FileSystemLoadTMD(arrItemClass[1], "InventoryItem");
