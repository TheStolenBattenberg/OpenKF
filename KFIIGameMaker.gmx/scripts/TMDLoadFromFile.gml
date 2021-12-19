///TMDLoadFromFile(tmdFile);

//Open the TMD as a buffer
var tmdBuffer = buffer_load(argument0);

//Read TMD data
return TMDLoadFromBuffer(tmdBuffer, 0);
