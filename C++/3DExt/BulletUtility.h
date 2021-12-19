#pragma once

#include <btBulletCollisionCommon.h>

#include <vector>
#include <iostream>
#include <d3d9.h>
#include <d3dx9.h>

#include "Types.h"

struct BulletRayResult {
	btVector3 hitPosition;
	btVector3 hitNormal;
	int hitIndex;
};
struct BulletOverlapCallback : public btCollisionWorld::ContactResultCallback {
	BulletOverlapCallback(btCollisionObject* tgtBody) : btCollisionWorld::ContactResultCallback(), body(tgtBody) {};
	btCollisionObject* body;
	bool hasHit = false;

	virtual btScalar addSingleResult(btManifoldPoint& cp, const btCollisionObjectWrapper* colObj0, int partId0, int index0, const btCollisionObjectWrapper* colObj1, int partId1, int index1) {
		if (colObj0->m_collisionObject == body) {
			hasHit = true;
		}
		return 0;
	}
};

class BulletDebug : public btIDebugDraw
{
	struct Vertex {
		D3DXVECTOR3 position;
		D3DXCOLOR colour;

		Vertex(float x, float y, float z, D3DXCOLOR c) : position(x, y, z), colour(c) { }
	};

	int m_debugMode = DBG_DrawWireframe;
	std::vector<Vertex> vertices;

public:
	virtual void drawLine(const btVector3& from, const btVector3& to, const btVector3& fromColor, const btVector3& toColor);
	virtual void drawLine(const btVector3& from, const btVector3& to, const btVector3& color);
	virtual void drawContactPoint(const btVector3& PointOnB, const btVector3& normalOnB, btScalar distance, int lifeTime, const btVector3& color);
	virtual void draw3dText(const btVector3& location, const char* textString) { return; }

	virtual void reportErrorWarning(const char* warningString) { std::cout << warningString << std::endl; }

	virtual void setDebugMode(int debugMode) { m_debugMode = debugMode; }
	virtual int  getDebugMode() const { return m_debugMode; }

	void debugDraw(IDirect3DDevice9* renderer);
	void debugUpdatePrepare();
	void debugReserve();
};

class BulletCollisionMesh : public btTriangleIndexVertexArray
{
	uint numIndex, numVertex;

	btVector3*  vertices = NULL;
	uint*       indices  = NULL;
	btIndexedMesh* indexedMesh = NULL;

public:
	BulletCollisionMesh(uint numIndices, uint numVertices);
	~BulletCollisionMesh();

	bool getUse32bitIndices() const { return true; }
	bool getUse4componentVertices() const { return false; }

	void setVertices(ubyte* vertexBuffer, ulong offset);
	void setIndices(ubyte* indexBuffer, ulong offset);

//	virtual void preallocateVertices(uint numverts);
//	virtual void preallocateIndices(uint numindices);
};