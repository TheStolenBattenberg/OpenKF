///GameConfigSave(config);

var config = file_text_open_write("config.json");
file_text_write_string(config, json_encode(argument0));
file_text_close(config);
