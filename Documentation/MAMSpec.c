//
// Moonlight Animated Model
// Format Version 1, Spec Version 1
//

// Format Types
struct MAMVertexP
{
	float Position[3];
};

struct MAMVertexNTC
{
	float Normal[3];
	float Texcoord[2];
	float Colour[4];	
};

// Format Structure
struct MAMHeader
{
	uint magicID;	   //MAMf
	uint version;	   //1
	uint flags;		   //(Bits) 0 = Static, 1-15 = Reserved
	uint numAnimation; //0 - INT_MAX
};

struct MAMBaseMesh {
	uint numVertex;
	
	MAMVertexP   BaseP[numVertex];		//Position
	MAMVertexNTC BaseNTC[numVertex];	//Normal, Texcoord, Colour
};

struct MAMFrame
{
	float interpolationIncrement;
	MAMVertexP vertices[MAMBaseMesh.numVertex];
};

struct MAMAnimation 
{
	uint numFrame;
	
	MAMFrame frames[numFrame];
};