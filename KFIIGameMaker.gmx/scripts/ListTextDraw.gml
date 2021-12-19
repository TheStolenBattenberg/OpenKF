///ListTextDraw(ListText, x, y, centerX, centerY);

//Draw Text, Highlight Selected
var i = 0;
while(i < ds_list_size(argument0[0]))
{
    var textStr = ds_list_find_value(argument0[0], i);
    
    if(i == argument0[1])
    {
        UIDrawText(argument1, argument2 + ((conUI.uiH1P * 4) * i), textStr, c_white, argument3, argument4);
    }else{
        UIDrawText(argument1, argument2 + ((conUI.uiH1P * 4) * i), textStr, $CE8FBB, argument3, argument4);
    }
    
    ++i;
}
