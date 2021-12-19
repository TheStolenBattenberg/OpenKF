///MapLoadChunks();

var cachedLocation = FileSystemCachedFolderName(fileTilemap);

chunks[@ 0] = null;
chunks[@ 1] = null;

if(file_exists(cachedLocation + "opaqueLayers.msm"))
{
    chunks[@ 0] = MSMLoadFromFile(cachedLocation+"opaqueLayers.msm", colChunks); 
}

if(file_exists(cachedLocation + "translucentLayers.msm"))
{
    chunks[@ 1] = MSMLoadFromFile(cachedLocation+"translucentLayers.msm", null); 
}
