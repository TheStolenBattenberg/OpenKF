///hex_to_dec(hex);

var dec = 0;

var dig = "0123456789ABCDEF";
var len = string_length(argument0);

for (var pos=1; pos<=len; pos+=1) 
{
    dec = dec << 4 | (string_pos(string_char_at(argument0, pos), dig) - 1);
}

return dec;
