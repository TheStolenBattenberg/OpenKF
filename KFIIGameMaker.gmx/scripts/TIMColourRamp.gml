///TIMColourRamp(rgb555comp)

if(argument0 <= 8)
{
    return 12 * argument0;
}else
if(argument0 > 8) {
    return 96 + (6 * (argument0-8));
}

return 0;

