///UICursorDraw(cursor, x, y);

if(argument0[2] == 0)
{
    argument0[@ 1]++;
    if(argument0[1] == argument0[0]-1)
    {
        argument0[@ 2] = 1;
    }
}else
if(argument0[2] == 1)
{
    argument0[@ 1]--;
    if(argument0[1] == 0)
    {
        argument0[@ 2] = 2;
    }
}

if(!surface_exists(conRenderer.psxVram))
    return false;

var cursorScale = 1;
if(conUI.uiW1P > conUI.uiH1P)
{
    cursorScale = conUI.uiW1P / 6.4;
}else{
    cursorScale = conUI.uiH1P / 4.8;
}
    
shader_set(shdBlackIsAlpha);
d3d_transform_set_scaling(cursorScale, cursorScale, 0);
d3d_transform_add_translation(argument1 - (16*cursorScale), argument2 - (15*cursorScale), 0);
    draw_surface_part(conRenderer.psxVram, 3200 + (16 * argument0[@ 1]), 384, 16, 15, 0, 0);
d3d_transform_set_identity();    
shader_reset();
