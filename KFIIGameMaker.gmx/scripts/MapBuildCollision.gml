///MapBuildCollision(opaqueCollision, translucentCollision);

//Get cached location of the collision buffers.
var cachedLocation = FileSystemCachedFolderName(fileTilemap);

for(var i = 0; i < 80; ++i)
{
    for(var j = 0; j < 80; ++j)
    {
        //Get Tile
        var arrTile = tileset[i, j];
        
        //Build Layer 1 Collisions
        if(arrTile[0] < array_length_1d(tileset))
        {
            
        }
    }
}
