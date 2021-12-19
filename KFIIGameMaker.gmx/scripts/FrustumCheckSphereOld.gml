///FrustumCheckSphere(x, y, z, r);

var plane, p, d;

for(p = 0; p < 6; p++)
{
    plane = global.Frust[p];
    
    d = plane[0] * argument0 + plane[1] * argument1 + plane[2] * argument2 + plane[3];
    if(d <= -argument3)
        return 0;
}

return d + argument3;

