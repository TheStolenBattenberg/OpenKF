///PlayerStateLookItem();
gml_pragma("forceinline");

//Get Player AxisRHH
var AxisRH = InputManagerGetAxis(InputMap.AxisRH);

//Take the item
switch(lookState)
{
    //Move item to centre of screen
    case LookItemState.PickUpItem:
        //When item distance is less than 1 away from camera, set state to ViewItem...
        if(lookInterp >= 0.5)
        {
            lookState = LookItemState.ViewItem;
            break;
        }
        
        //Calculate the position of the LookItem per step.
        if(is_array(lookItemInst))
        {
            lookPosX = smoothstep(lookItemInst[ObjectInstance.PositionX], conRenderer.camXfrom, lookInterp);
            lookPosY = smoothstep(lookItemInst[ObjectInstance.PositionY], conRenderer.camYfrom, lookInterp);
            lookPosZ = smoothstep(lookItemInst[ObjectInstance.PositionZ], conRenderer.camZfrom, lookInterp);
        }
        //Increment lookInterp.
        lookInterp += 0.02 * global.DT;
    break;
    
    //View Item
    case LookItemState.ViewItem:
        //When Activate is pressed, try to take the item.
        if(InputManagerGetPressed(InputMap.Activate))
        {
            //If the ID is 70, it's gold.
            if(lookItemID == 70)
            {
                UIQueueMessageVars(LanguageGetString("uiMessage", 21), 20);
            }else{
                //Now we have to check the count of the item in the inventory
                var invItemInd = InventoryContainsItem(inventory, lookItemID);
                if(invItemInd != null)
                {
                    //Make sure that adding the item will not make the count over 99
                    if(InventoryItemGetCount(InventoryGetItemData(inventory, invItemInd)) >= 99)
                    {
                        //Queue "Stop Hoarding" message
                        UIQueueMessage(LanguageGetString("uiMessage", 18));
                        lookState = LookItemState.PutDownItem; //3;
                        
                        break;
                    }
                }
                
                //Actually add the item to the inventory
                InventoryAddItem(inventory, lookItemID, 1); //Only 1 supported for now.
            }
            
            //We assume at this point that the player took the item, and clean up some shit.
            
            //Remove colliders from world, and destroy them.
            CollisionWorldRemoveBody(lookItemInst[ObjectInstance.CollisionBodies]);
            CollisionBodyDestroy(lookItemInst[ObjectInstance.CollisionBodies]);
            CollisionShapeDestroy(lookItemInst[ObjectInstance.CollisionShapes]);
            lookItemInst[@ ObjectInstance.CollisionBodies] = null;
            lookItemInst[@ ObjectInstance.CollisionShapes] = null;
            
            lookState = LookItemState.TakeItem;
        }
        
        //When any other input (other than AxisRH) is used, put item down.
        if(InputManagerGetAnyPressed(InputMap.AxisRH) && lookState == 1)
        {           
            lookState = LookItemState.PutDownItem; //3;
            break;         
        }
        
        //Adjust rotation of item, using AxisRH
        lookRotY -= AxisRH[0];
        lookRotX -= AxisRH[1];
    break;
    
    case LookItemState.TakeItem:
        //When lookInterp is greater than 1.0, we clear our data and the item instance.
        if(lookInterp > 1.0)
        {
            //Remove the item from the container (if it exists
            if(lookItemContainer != null)
            {
                var arrFlags = lookItemContainer[ObjectInstance.Flags];
                    arrFlags[@ 0] = null;
            }
            
            //I don't think this is really needed... Good/bad practice?
            lookItemContainer = null;
            lookItemID   = 0;
            lookItemInst = null;
            lookItemMesh = null;           
            lookPosX = 0;
            lookPosY = 0;
            lookPosZ = 0;
            lookRotX = 0;
            lookRotY = 0;
            lookRotZ = 0;   
            lookInterp = 0.0;
            lookState  = 0;
            
            //Change player state to the previous
            PlayerSetState(playerStateLast);
            break;
        }
        
        //Calculate the position of the LookItem per step
        lookPosX    = smoothstep(lookItemInst[ObjectInstance.PositionX], conRenderer.camXfrom, lookInterp);
        lookPosY    = smoothstep(lookItemInst[ObjectInstance.PositionY], conRenderer.camYfrom, lookInterp);
        lookPosZ    = smoothstep(lookItemInst[ObjectInstance.PositionZ], conRenderer.camZfrom, lookInterp);
        
        //Increment lookInterp.
        lookInterp += 0.02 * global.DT;
    break;
    
    case LookItemState.PutDownItem:
        //When lookInterp is greater than 1.0, we clear our data and the item instance.
        if(lookInterp > 1.0)
        {
            //I don't think this is needed.
            lookItemInst[@ 0] = true;
            lookItemInst[@ 1] = true;    
            lookItemContainer = null;        
            lookItemID   = 0;
            lookItemInst = null;
            lookItemMesh = null;
            lookPosX = 0;
            lookPosY = 0;
            lookPosZ = 0;
            lookRotX = 0;
            lookRotY = 0;
            lookRotZ = 0;    
            lookInterp = 0.0;
            lookState  = 0;
            
            //Change player state to the previous
            PlayerSetState(playerStateLast);
            break;
        }
        
        //Calculate the position of the LookItem per step
        if(is_array(lookItemInst))
        {
            lookPosX    = smoothstep(conRenderer.camXfrom, lookItemInst[ObjectInstance.PositionX], lookInterp);
            lookPosY    = smoothstep(conRenderer.camYfrom, lookItemInst[ObjectInstance.PositionY], lookInterp);
            lookPosZ    = smoothstep(conRenderer.camZfrom, lookItemInst[ObjectInstance.PositionZ], lookInterp);
        }
        
        //Increment lookInterp.
        lookInterp += 0.02 * global.DT;    
    break;
}
