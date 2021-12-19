///GameConfigLoad();

var configF = file_text_open_read("config.json");
var config = json_decode(file_text_read_string(configF));
file_text_close(configF);

return config;
