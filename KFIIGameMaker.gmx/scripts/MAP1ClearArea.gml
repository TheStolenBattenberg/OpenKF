///MAP1ClearArea(MAP1, x, y, w, h, l, value);

for(var i = argument1; i < argument1+argument3; ++i)
{
    for(var j = argument2; j < argument2+argument4; ++j)
    {
        var arrTile = argument0[i, j];
        arrTile[@ (5 * argument5)] = argument6;
    }
}
