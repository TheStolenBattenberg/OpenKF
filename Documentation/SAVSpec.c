//
// SAVE
// Spec Version = 1, Format Version = 1
//

struct Header
{
	uint MagicID;		//Magic ID 'SAVf'
	uint Version;		//1
	uint ChunkCount;	//Number of chunks present in the file
	uint FileSize;		//True File Size
};

struct ChunkHeader
{
	ulong ChunkID;
	uint  ChunkSize;
};

//Player Chunk
//	ChunkID: 'PlyrData'
struct ChunkPlayerData
{
	//Level, Hp, Mp, Str, Mag, Exp, Gold etc...
	//Inventory, Equiped Items,
};

//Game Chunk
//	ChunkID: 'GameData'
struct ChunkGameData
{
	uint numFlag;
	
	GameFlag flags[numFlag];
};

struct GameFlag 
{
	char  FlagName[32];
	float FlagValue;
};

//Map Chunk
//  ChunkID: 'Map Data'
struct ChunkMapData
{
	uint MapID;				//The ID of the map this data belongs too...
	uint numObjectParam;	//Count of Object Parameters stored...
	uint numEntityParam;	//Count of Entity Parameters stored...
	uint numObjectExParam;	//Count of ObjectEx Parameters stored...
	
	MapObjectParam objParams[numObjectParam];
	MapEntityParam entParams[numEntityParam];
	MapObjectExParam objExParams[numObjectExParam];
};

//MapObjectParam is used to store data about objects that exist the first time you enter a map.
struct MapObjectParam
{
	float Position[3];
	float Rotation[3];
	float flags[8];
};

//MapObjectExParam is used to store data for newly spawned objects... Herbs, gold etc...
struct MapObjectExParam
{
	MapObjectParam objParam;
	uint ObjectType;
};