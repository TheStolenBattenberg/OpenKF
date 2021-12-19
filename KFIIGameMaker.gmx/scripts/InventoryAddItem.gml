///InventoryAddItem(Inventory, ItemID, Count);

/**
 * Desc:
 *   Adds an item to the inventory lists. If the item already exists,
 *   it's count will be increased up to a maximum of 99.
 *
 * Args:
 *  @0 Inventory - An Inventory previously created
 *  @1 ItemID    - The ItemID to add
 *  @2 Count     - Number to add.
**/

//Check if the item is already contained in the inventory
var containedIndex = InventoryContainsItem(argument0, argument1);

if(containedIndex != null)
{
    //The item is contained, so we add to it's count up to a maximum of 99.
    var arrInvItem = ds_list_find_value(argument0[ArrInv.Content], containedIndex);
    
    //Don't add to count if it's -1, which is considered infinite.
    if(arrInvItem[ArrInvItem.Count] == -1)
        return false;

    //Don't add to count if it would surpass the max of 99.    
    if((arrInvItem[ArrInvItem.Count] + argument2) > 99)
        return false;
        
    //Since our checks passed, add the item count.
    arrInvItem[@ ArrInvItem.Count] += argument2;
}else
{
    //The item is not contained, so we must add a new one.
    var arrInvItem = InventoryItemCreate(argument1, argument2);
    ds_list_add(argument0[ArrInv.Content], arrInvItem);
}

return true;
