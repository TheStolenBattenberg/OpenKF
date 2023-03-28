//
// Moonlight Static Model
// Format Version 1, Spec Version 1
//

struct MSMHeader
{
	uint magicID;	//MSMf
	uint version;	//1
	uint flags;		//0x00
	uint numMesh;	//0 - UINT_MAX
};

struct MSMVertex 	//48 byte stride
{
	float Position[3];
	float Normal[3];
	float Texcoord[2];
	float Colour[4];
};

struct MSMMesh
{
	uint numVertex;
	
	MSMVertex vertices[numVertex];
};