///MSMLoadFromFile(msmFile, cShapes);
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

    //Copy data from buffer to our vertex buffer    
    var msmMesh = array_create(2);
        msmMesh[0] = VertexStreamCreate(msmVBSize);
        msmMesh[1] = msmVBSize / 144;
        
    VertexStreamFillFrom(msmMesh[0], msmBuffer, buffer_tell(msmBuffer), msmVBSize);
    
    //Build Collision Shapes   
    if(argument1 != null)
    {
        argument1[@ totMesh-numMesh] = CollisionShapeCreateTrimeshOffset(msmBuffer, buffer_tell(msmBuffer), 12, msmVBSize / 144);
    }
      
    //Seek past this bufferr
    buffer_seek(msmBuffer, buffer_seek_relative, msmVBSize);
      
    msmModel[totMesh-numMesh] = msmMesh;    
    
    numMesh--;
} until(numMesh <= 0)

buffer_delete(msmBuffer);

return msmModel;
