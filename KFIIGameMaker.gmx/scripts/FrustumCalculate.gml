///FrustumCalculateOld();

//
// Get Matrices from DX
//
var mWorldView = matrix_multiply(matrix_get(matrix_view), matrix_get(matrix_world));
var mClip = matrix_multiply(mWorldView, matrix_get(matrix_projection));
var plane, t;

//
// Extract Right Plane
//
plane = array_create(4);
plane[0] = mClip[3] - mClip[0];
plane[1] = mClip[7] - mClip[4];
plane[2] = mClip[11] - mClip[8];
plane[3] = mClip[15] - mClip[12];

t = sqrt(plane[0] * plane[0] + plane[1] * plane[1] + plane[2] * plane[2]);
plane[0] /= t;
plane[1] /= t;
plane[2] /= t;
plane[3] /= t;

global.Frust[0] = plane;

//
// Extract Left Plane
//
plane = array_create(4);
plane[0] = mClip[3]  + mClip[0];
plane[1] = mClip[7]  + mClip[4];
plane[2] = mClip[11] + mClip[8];
plane[3] = mClip[15] + mClip[12];

t = sqrt(plane[0] * plane[0] + plane[1] * plane[1] + plane[2] * plane[2]);
plane[0] /= t;
plane[1] /= t;
plane[2] /= t;
plane[3] /= t;

global.Frust[1] = plane;

//
// Extract Far Plane
//
plane = array_create(4);
plane[0] = mClip[3]  - mClip[2];
plane[1] = mClip[7]  - mClip[6];
plane[2] = mClip[11] - mClip[10];
plane[3] = mClip[15] - mClip[14];

t = sqrt(plane[0] * plane[0] + plane[1] * plane[1] + plane[2] * plane[2]);
plane[0] /= t;
plane[1] /= t;
plane[2] /= t;
plane[3] /= t;

global.Frust[2] = plane;

//
// Extract Near Plane
//
plane = array_create(4);
plane[0] = mClip[3]  + mClip[2];
plane[1] = mClip[7]  + mClip[6];
plane[2] = mClip[11] + mClip[10];
plane[3] = mClip[15] + mClip[14];

t = sqrt(plane[0] * plane[0] + plane[1] * plane[1] + plane[2] * plane[2]);
plane[0] /= t;
plane[1] /= t;
plane[2] /= t;
plane[3] /= t;

global.Frust[3] = plane;
