///MSMLoadFromFile(msmFile, collisionArray);

var msmBuffer = null;
var msmModel  = MSMModelCreate();

//Open MSM Buffer
msmBuffer = buffer_load(argument0);

//Read Header
var magicID = buffer_read(msmBuffer, buffer_u32);
var version = buffer_read(msmBuffer, buffer_u32);
var reserve = buffer_read(msmBuffer, buffer_u32);
var numMesh = buffer_read(msmBuffer, buffer_u32);

if(magicID != $664D534D)    //MSMf
{
    show_debug_message("Invalid MSM magic ID");
    return null;
}

if(version != 1)
{
    show_debug_message("Invalid MSM version (not v1)");
    return null;
}

var totMesh = numMesh;
do {
    //Read Each VB from the MSM file.
    var msmVBSize = 48 * buffer_read(msmBuffer, buffer_u32);

    //I was a genius when I made DExterity, so I added a function to copy the VBs directly without copying to another buffer first.
    //I.E - Cached MSM should be fast to load.
    var msmTempBuf = buffer_create(msmVBSize, buffer_fixed, 1);
    buffer_copy(msmBuffer, buffer_tell(msmBuffer), msmVBSize, msmTempBuf, 0);
    buffer_seek(msmBuffer, buffer_seek_relative, msmVBSize);
        
    var msmMesh = array_create(2);
        msmMesh[0] = VertexStreamCreate(msmVBSize);
        msmMesh[1] = (msmVBSize / 3);
        
        VertexStreamFill(msmMesh[0], msmTempBuf);       
        buffer_delete(msmTempBuf);
        
    msmModel[totMesh-numMesh] = msmMesh;    
    
    numMesh--;
} until(numMesh <= 0)

buffer_delete(msmBuffer);

return msmModel;
