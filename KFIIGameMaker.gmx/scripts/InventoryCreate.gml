///InventoryCreate();

//Easier access to the contents of the inventory, using constants
enum ArrInv
{
    Content,
}

var arrInventory = array_create(1);
    arrInventory[0] = ds_list_create(); //Inventory Contents

return arrInventory;
