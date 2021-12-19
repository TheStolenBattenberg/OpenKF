///MIXDBLoadFromBuffer(buffer, offset);

//Store buffer/offset in temporary variables
var mixBuffer = argument0;
var mixOffset = argument1;

//Make sure we are at the required offset
buffer_seek(mixBuffer, buffer_seek_start, mixOffset);

//Mix files are stored with a length, then data lump until the end.

var arrMIXDB = array_create(8);
    arrMIXDB[0] = null;         //Object Class Declaration
    arrMIXDB[1] = null;         //Weapon Stats
    arrMIXDB[2] = null;         //Armour Stats
    arrMIXDB[3] = null;         //Player Level Graph
    arrMIXDB[4] = null;         //Magic  Stats
    arrMIXDB[5] = null;         //Tile Render Param
    arrMIXDB[6] = null;         //Sound Effect Param
    arrMIXDB[7] = null;         //HUD MOs
    arrMIXDB[8] = null;         //Magic MOs

//Start reading MIX

//We skip everything but tile render parameters for now.
var SkipLength;

SkipLength = buffer_read(mixBuffer, buffer_u32);

//Read Object Classes
var arrObjectClasses = array_create(320);
var index = 0;

/**
 * Object Types:
 *      2 = Doors that go up (Secret, Jail)
 *      3 = Things going up to open (Big Rough Stone Door, Big Stone Door, Harvine Castle Door)
 *      4 = Things that rotate to open (Wooden Chest Lid, Knocker Door Left, Big Grey Door Right, Seath Door Left)
 *      5 = Secret Compartment
 *      9 = Item Hider (Bones, MinersGrave, Barrel)
 *     13 = Signs
 *     14 = Save Point
 *     15 = Guide Post
 *     17 = Rhombus Key Slot
 *     18 = Water Well
 *     19 = Dragon Grass
 *
 *
 *
 *     22 = Things sliding to open (Stone Chest Lid)
 *     32 = Minecart 
 *     34 = Guyra Warp
 *     64 = Item to be picked up
 *     81 = Traps (Swinging Sythe, Swinging Spikeyball, Hidden Stabby Spear)
 *     83 = Switch
 *     84 = Floor Trap (
 *     88 = ???
 *
 *
 *    160 = Skull Key Slot
 *    161 = Dragon Stone Slot
 *    164 = Shrine Key Slot
 *
 *    224 = Load Trigger
 *    240 = Skybox          !! Implement as hidden by everything. !!
 *
 *    255 = Generic
**/


repeat(320) //Each entry is 24 bytes long
{
    var arrObjectClass = array_create(20);
    
    //Only things we really need here are ObjectType1/ObjectType2... But we'll take the lot :)
    arrObjectClass[0]  = buffer_read(mixBuffer, buffer_u8);              //Object Type    (64 == Pickup, 255 = None, 
    arrObjectClass[1]  = buffer_read(mixBuffer, buffer_u8);              //Object Type #2 (20 == Gold)
    arrObjectClass[2]  = buffer_read(mixBuffer, buffer_u8);              //0x02 = ???
    arrObjectClass[3]  = buffer_read(mixBuffer, buffer_u8);              //0x03 = ???
    arrObjectClass[4]  = buffer_read(mixBuffer, buffer_s16) / 2048.0;    //Collision Radius #1
    arrObjectClass[5]  = buffer_read(mixBuffer, buffer_s16) / 2048.0;    //Collision Radius #2
    arrObjectClass[6]  = buffer_read(mixBuffer, buffer_s16) / 2048.0;    //Collision Height
    arrObjectClass[7]  = buffer_read(mixBuffer, buffer_u8);              //0x0A = ???
    arrObjectClass[8]  = buffer_read(mixBuffer, buffer_u8);              //0x0B = ???
    arrObjectClass[9]  = buffer_read(mixBuffer, buffer_u8);              //0x0C = ???
    arrObjectClass[10] = buffer_read(mixBuffer, buffer_u8);              //0x0D = ???
    arrObjectClass[11] = buffer_read(mixBuffer, buffer_u8);              //0x0E = ???
    arrObjectClass[12] = buffer_read(mixBuffer, buffer_u8);              //SFX ?
    arrObjectClass[13] = buffer_read(mixBuffer, buffer_u8);              //0x10 = ???
    arrObjectClass[14] = buffer_read(mixBuffer, buffer_u8);              //0x11 = ???
    arrObjectClass[15] = buffer_read(mixBuffer, buffer_u8);              //0x12 = ???
    arrObjectClass[16] = buffer_read(mixBuffer, buffer_u8);              //0x13 = ???
    arrObjectClass[17] = buffer_read(mixBuffer, buffer_u8);              //0x14 = ???
    arrObjectClass[18] = buffer_read(mixBuffer, buffer_u8);              //0x15 = ???
    arrObjectClass[19] = buffer_read(mixBuffer, buffer_u8);              //0x16 = ???
    arrObjectClass[20] = buffer_read(mixBuffer, buffer_u8);              //0x17 = ???
    
    //Some Overrides
    switch(index)
    {
        case 141:
            arrObjectClass[@ 0] = 9;
        break;
    }
    
    arrObjectClasses[index] = arrObjectClass;
    index++;
}




SkipLength = buffer_read(mixBuffer, buffer_u32);
buffer_seek(mixBuffer, buffer_seek_relative, SkipLength);   //Weapon Stats

SkipLength = buffer_read(mixBuffer, buffer_u32);
buffer_seek(mixBuffer, buffer_seek_relative, SkipLength);   //Armour Stats

SkipLength = buffer_read(mixBuffer, buffer_u32);

//Read Player Level Graph
var arrPlayerLevelGraph = array_create(99);
var index = 0;
repeat(99)
{
    var arrPlayerStats = array_create(5);
        arrPlayerStats[0] = buffer_read(mixBuffer, buffer_u16); //HP at level
        arrPlayerStats[1] = buffer_read(mixBuffer, buffer_u16); //MP at level
        arrPlayerStats[2] = buffer_read(mixBuffer, buffer_u16); //Strength Increase
        arrPlayerStats[3] = buffer_read(mixBuffer, buffer_u16); //Magic Increase
        arrPlayerStats[4] = buffer_read(mixBuffer, buffer_u32); //XP For next level
        
    arrPlayerLevelGraph[index] = arrPlayerStats;
    index++;
}
buffer_seek(mixBuffer, buffer_seek_relative, SkipLength - (12 * 99));

SkipLength = buffer_read(mixBuffer, buffer_u32);
buffer_seek(mixBuffer, buffer_seek_relative, SkipLength);   //Magic Stats


SkipLength = buffer_read(mixBuffer, buffer_u32);

//Read Tile Render Parameters
var arrTileRenderParam = array_create(64);
var index = 0;
repeat(64)
{
    var arrTRP = array_create(4);
    
    buffer_seek(mixBuffer, buffer_seek_relative, 36);   //Skip Colour Matrix
    buffer_seek(mixBuffer, buffer_seek_relative, 2);    //Skip Padding
    
    //Read RGBx
    arrTRP[0] = buffer_read(mixBuffer, buffer_u8);
    arrTRP[1] = buffer_read(mixBuffer, buffer_u8);
    arrTRP[2] = buffer_read(mixBuffer, buffer_u8);
    buffer_read(mixBuffer, buffer_u8);
    
    //Read FogFar
    arrTRP[3] = buffer_read(mixBuffer, buffer_u16)  / 2048.0;
    
    arrTileRenderParam[index] = arrTRP;
    index++;
}

arrMIXDB[@ 0] = arrObjectClasses;
arrMIXDB[@ 3] = arrPlayerLevelGraph;
arrMIXDB[@ 5] = arrTileRenderParam;

return arrMIXDB;
