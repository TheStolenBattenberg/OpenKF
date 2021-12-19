///string_split(string, substr);

var index = 0;
var splits = array_create(string_count(argument0, argument1));
var offset = 1;

for(var i = 1; i <= (string_length(argument0) + 1); ++i)
{
    if(string_char_at(argument0, i) == argument1 || i == (string_length(argument0) + 1))
    {
        splits[index] = string_copy(argument0, offset, i-offset);
        offset = i + 1; 
        
        index++;
    }
}

return splits;
