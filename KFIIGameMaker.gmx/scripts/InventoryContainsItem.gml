///InventoryContainsItem(Inventory, ItemID);

/**
 * Desc:
 *   Returns list index if the item exists, or null if it does not.
 *
 * Args:
 *  @0 Inventory - An Inventory previously created
 *  @1 ItemID    - The ItemID to search for.
**/

for(var i = 0; i < ds_list_size(argument0[0]); ++i)
{
    //Get an inventory item from the inventory contents
    var arrInvItem = ds_list_find_value(argument0[0], i);
    
    //Check if this inventory item is the item we are looking for
    if(arrInvItem[0] == argument1)
    {
        //It is, so we return the current index
        return i;
    }
}

//ItemID note contained, return null.
return null;
