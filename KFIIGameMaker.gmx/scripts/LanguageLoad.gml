///LanguageLoad(language);

var langPath = global.FS[1] + "Language\"+argument0+"\";

if(!directory_exists(langPath))
{
    show_debug_message("Invalid Language. Defaulting to EnglishUK.");
    langPath = global.FS[1] + "Language\"+"EnglishUK"+"\";
}

var arrLanguage = array_create(2);

//Load language.json
var langConfF = file_text_open_read(langPath+"language.json");
var langConfT  = "";
while(!file_text_eof(langConfF))
{
    langConfT += file_text_read_string(langConfF);
    file_text_readln(langConfF);
}
file_text_close(langConfF);

langConf = json_decode(langConfT);

show_debug_message(langConfT);

show_debug_message("Language Name: " + langConf[? "name"]);

//Load Font
font_add_enable_aa(true);
arrLanguage[0] = font_add(langPath+langConf[? "fontFile"], langConf[? "fontSize"], false, false, langConf[? "fontFirstChar"], langConf[? "fontLastChar"]);

draw_set_font(arrLanguage[0]);

//Load Strings
arrLanguage[1] = ds_map_create();

var textFile;

//Load UIText
textFile = file_text_open_read(langPath+"uitext.txt");
ds_map_add_list(arrLanguage[1], "uiText", ds_list_create());
while(!file_text_eof(textFile))
{
    ds_list_add(ds_map_find_value(arrLanguage[1], "uiText"), file_text_read_string(textFile));
    file_text_readln(textFile);
}
file_text_close(textFile);

//Load UIMessage
textFile = file_text_open_read(langPath+"uimsg.txt");
ds_map_add_list(arrLanguage[1], "uiMessage", ds_list_create());
while(!file_text_eof(textFile))
{
    ds_list_add(ds_map_find_value(arrLanguage[1], "uiMessage"), file_text_read_string(textFile));
    file_text_readln(textFile);
}
file_text_close(textFile);

//Load ItemName
textFile = file_text_open_read(langPath+"itemnames.txt");
ds_map_add_list(arrLanguage[1], "itemNames", ds_list_create());
while(!file_text_eof(textFile))
{
    ds_list_add(ds_map_find_value(arrLanguage[1], "itemNames"), file_text_read_string(textFile));
    file_text_readln(textFile);
}
file_text_close(textFile);

//Load WorldMessage
textFile = file_text_open_read(langPath+"worldmsg.txt");
ds_map_add_list(arrLanguage[1], "worldMessage", ds_list_create());
while(!file_text_eof(textFile))
{
    ds_list_add(ds_map_find_value(arrLanguage[1], "worldMessage"), file_text_read_string(textFile));
    file_text_readln(textFile);
}
file_text_close(textFile);

global.Language = arrLanguage;

return arrLanguage;
