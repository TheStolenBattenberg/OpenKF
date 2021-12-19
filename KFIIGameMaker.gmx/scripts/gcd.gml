///gcd(int a, int b);

if(argument1 == 0)
{
    return argument0;
}else{
    return gcd(argument1, argument0 % argument1);
}

