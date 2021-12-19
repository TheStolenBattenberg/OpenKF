///UIListInventoryDraw(ListInventory, x, y, w, h);

//Store Arguments
var X = argument1;
var Y = argument2;
var W = argument3;
var H = argument4;

//
// DRAW
//

//Calculate frame thickness
var FT = 16 * conUI.uiScale;

//Calculate Item Size
var itemW = W - FT;
var itemH = floor((H-(FT*2)) / 4);

//Draw Frame
UIDrawFrame(X, Y, W, H, FT);

//Draw Items
for(var i = 0; i < 4; ++i)
{
    //Calculate List Position
    var ListPosition = argument0[2] + i;
    
    //Draw Background (figure out colour too)
    draw_set_alpha(0.75);
    if(i == argument0[3])
    {
        draw_set_colour($102030);
    }else{
        draw_set_colour($303030);
    }

    //+1 'cause fuckin' Game Maker
    draw_rectangle(X+FT, (Y+FT)+(itemH*i)+1, X+itemW, (Y+FT)+(itemH*i)+itemH, false);
    draw_set_alpha(1.0);
    
    if(ListPosition >= InventoryGetSize(argument0[0]))
        continue;
    
    //Get Inventory Item Data
    var arrItemData = InventoryGetItemData(argument0[0], ListPosition);
    
    //Draw Text
    UIDrawTextScale((X+FT)+(FT/2), (Y+FT)+(itemH*i)+(itemH*0.5), InventoryItemGetName(arrItemData), $a8f8f8, fa_left, fa_center, 1.75 * conUI.uiScale);
    UIDrawTextScale(((X+W)-FT)-(FT/2), (Y+FT)+(itemH*i)+(itemH*0.5), "x"+string(InventoryItemGetCount(arrItemData)), $a8f8f8, fa_right, fa_center, 1.75 * conUI.uiScale); 
}

//
// UPDATE
//

//List Scroll (Axis)
if(InputManagerGetAxisHeld(InputMap.AxisLH))
{
    argument0[@ 4] = (argument0[4] + 1) % 10;
}else {
    argument0[@ 4] = 8;
}

if(argument0[@ 4] == 9)
{
    //Get Axis Values
    var AxisLH = InputManagerGetAxis(InputMap.AxisLH);
    
    //Incremenent Cursor Position
    argument0[@ 3] += AxisLH[1];
    
    if(argument0[@ 3] < 0) 
    {
        //Clamp Cursor Position
        argument0[@ 3] = 0;
        
        //Decrement Window Position
        argument0[@ 2]--;
        
        //Wrap window position
        if(argument0[@ 2] < 0)
        {
            argument0[@ 2] = max(InventoryGetSize(argument0[0])-4, 0);
            argument0[@ 3] = 3;
        }
        
    }else
    if(argument0[@ 3] > 3)
    {
        //Clamp Cursor Position
        argument0[@ 3] = 3;
        
        //Incremenet Window Position
        argument0[@ 2]++;
        
        if(argument0[@ 2] > InventoryGetSize(argument0[0])-4)
        {
            argument0[@ 2] = 0;
            argument0[@ 3] = 0;
        }
    }
    
    SoundPlay2DPitch(WBFGetWave(conMain.gameSound, 15), 1.4);
}
