///MAP2SwitchObjectDeclaration(map2, indA, indB);

//Get Object Declarations
var arrObjectDeclList = argument0[2];

//Get the object to clear
var arrObjectDecl1 = arrObjectDeclList[argument1];
var arrObjectDecl2 = arrObjectDeclList[argument2];


arrObjectDeclList[@ argument2] = arrObjectDecl1;
arrObjectDeclList[@ argument1] = arrObjectDecl2;
