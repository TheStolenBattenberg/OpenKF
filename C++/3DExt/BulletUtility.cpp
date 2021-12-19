#include "BulletUtility.h"

#pragma region Bullet Debug
void BulletDebug::drawLine(const btVector3& from, const btVector3& to, const btVector3& fromColor, const btVector3& toColor)
{
	vertices.push_back(Vertex(from.x(), from.y(), from.z(), D3DXCOLOR(fromColor.x(), fromColor.y(), fromColor.z(), 1.0f)));
	vertices.push_back(Vertex(to.x(), to.y(), to.z(), D3DXCOLOR(toColor.x(), toColor.y(), toColor.z(), 1.0f)));
}
void BulletDebug::drawLine(const btVector3& from, const btVector3& to, const btVector3& color)
{
	if (from == NULL || to == NULL || color == NULL)
		return;

	vertices.push_back(Vertex(from.x(), from.y(), from.z(), D3DXCOLOR(color.x(), color.y(), color.z(), 1.0f)));
	vertices.push_back(Vertex(to.x(), to.y(), to.z(), D3DXCOLOR(color.x(), color.y(), color.z(), 1.0f)));
}
void BulletDebug::drawContactPoint(const btVector3& PointOnB, const btVector3& normalOnB, btScalar distance, int lifeTime, const btVector3& color)
{
	btVector3 from = PointOnB;
	btVector3 to = from + normalOnB;

	vertices.push_back(Vertex(from.x(), from.y(), from.z(), D3DXCOLOR(color.x(), color.y(), color.z(), 1.0f)));
	vertices.push_back(Vertex(to.x(), to.y(), to.z(), D3DXCOLOR(color.x(), color.y(), color.z(), 1.0f)));
}
void BulletDebug::debugUpdatePrepare()
{
	vertices.clear();
}
void BulletDebug::debugReserve()
{
	vertices.reserve(8192);
}
void BulletDebug::debugDraw(IDirect3DDevice9* dev)
{
	if (vertices.size() > 1)
	{
		dev->SetFVF(D3DFVF_XYZ | D3DFVF_DIFFUSE);
		dev->DrawPrimitiveUP(D3DPT_LINELIST, vertices.size() / 2, &vertices[0], sizeof(Vertex));
	}
}
#pragma endregion

#pragma region Bullet Collision Mesh
BulletCollisionMesh::BulletCollisionMesh(uint numIndices, uint numVertices)
{
	//Set counts for future use...
	numIndex  = numIndices;
	numVertex = numVertices;

	//Create our arrays of mesh data
	vertices = new btVector3[numVertices];
	indices = new unsigned int[numIndices];

	//Create btIndexedMesh structure and fill data...
	indexedMesh = new btIndexedMesh();
	indexedMesh->m_numTriangles = numIndices / 3;
	indexedMesh->m_numVertices  = numVertices;
	indexedMesh->m_indexType    = PHY_INTEGER;
	indexedMesh->m_triangleIndexBase   = (unsigned char*)indices;
	indexedMesh->m_triangleIndexStride = 12;
	indexedMesh->m_vertexBase   = (unsigned char*)vertices;
	indexedMesh->m_vertexStride = sizeof(btVector3);

	//Push indexed mesh to parents data
	m_indexedMeshes.push_back(*indexedMesh);
}
BulletCollisionMesh::~BulletCollisionMesh()
{
	if (vertices != NULL)
		delete vertices;

	if (indices != NULL)
		delete indices;

	if (indexedMesh != NULL)
		delete indexedMesh;
}

void BulletCollisionMesh::setVertices(ubyte* vertexBuffer, ulong offset)
{
	//We need to first create a btVector3 buffer.
	btVector3* buff = (btVector3*)(vertexBuffer + offset);

	//memcpy to std::vector of vertices
	memcpy(&vertices[0], &buff[0], sizeof(btVector3) * numVertex);
}
void BulletCollisionMesh::setIndices(ubyte* indexBuffer, ulong offset)
{
	//Create buffer in our required type...
	uint* buff = (uint*)(indexBuffer + offset);

	//memcpy to std::vector of indices
	memcpy(&indices[0], &buff[0], sizeof(uint) * numIndex);
}

#pragma endregion