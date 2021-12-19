///UIDrawQuadSkewed(x1,y1,x2,y2,x3,y3,x4,y4, c1,c2,c3,c4, a);

draw_primitive_begin(pr_trianglelist);

//Triangle 1
draw_vertex_colour(argument0, argument1, argument8, argument12);
draw_vertex_colour(argument2, argument3, argument9, argument12);
draw_vertex_colour(argument4, argument5, argument10, argument12);

//Triangle 2
draw_vertex_colour(argument2, argument3, argument9, argument12);
draw_vertex_colour(argument4, argument5, argument10, argument12);
draw_vertex_colour(argument6, argument7, argument11, argument12);

draw_primitive_end();


