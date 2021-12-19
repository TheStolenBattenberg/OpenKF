///MSMMeshBuilderCreate();

/**
 * Mesh Builder stores mesh data in a non efficient format.
 * In KF2GM it is used to convert from TMD to our cached, PC ready format.
**/

var arrMSMMesh = array_create(5);

    arrMSMMesh[0] = ds_list_create();   //Vertices
    arrMSMMesh[1] = ds_list_create();   //Normals
    arrMSMMesh[2] = ds_list_create();   //Texcoords
    arrMSMMesh[3] = ds_list_create();   //Colour
    arrMSMMesh[4] = ds_list_create();   //Faces
    
return arrMSMMesh;
