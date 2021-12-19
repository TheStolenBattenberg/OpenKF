///buffer_read_bcd(buffer);

var bcd = buffer_read(argument0, buffer_u8);
var dec = 0;

dec = 10 * ((bcd >> 4) & $F)
dec += bcd & $F;

return dec;
