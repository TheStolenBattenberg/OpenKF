///TriggerInstanceDebugDraw(trigger);

// Set trigger colour based on the state
draw_set_colour(c_red);
if(TriggerInstanceOnStay(argument0))
{
    draw_set_colour(c_lime);
}else
if(TriggerInstanceOnExit(argument0) || TriggerInstanceOnEnter(argument0)) 
{
    draw_set_colour(c_yellow);  
}

// Draw trigger using D3D primitives.
d3d_primitive_begin(pr_linelist);
d3d_vertex(argument0[6], argument0[7], argument0[8]);   //Bottom
d3d_vertex(argument0[9], argument0[7], argument0[8]);
d3d_vertex(argument0[9], argument0[7], argument0[8]);
d3d_vertex(argument0[9], argument0[7], argument0[11]);
d3d_vertex(argument0[9], argument0[7], argument0[11]);
d3d_vertex(argument0[6], argument0[7], argument0[11]);
d3d_vertex(argument0[6], argument0[7], argument0[11]);
d3d_vertex(argument0[6], argument0[7], argument0[8]);
d3d_vertex(argument0[6], argument0[10], argument0[8]);  //Top
d3d_vertex(argument0[9], argument0[10], argument0[8]);
d3d_vertex(argument0[9], argument0[10], argument0[8]);
d3d_vertex(argument0[9], argument0[10], argument0[11]);
d3d_vertex(argument0[9], argument0[10], argument0[11]);
d3d_vertex(argument0[6], argument0[10], argument0[11]);
d3d_vertex(argument0[6], argument0[10], argument0[11]);
d3d_vertex(argument0[6], argument0[10], argument0[8]);
d3d_vertex(argument0[6], argument0[7], argument0[8]);   //Corners
d3d_vertex(argument0[6], argument0[10], argument0[8]);
d3d_vertex(argument0[6], argument0[7], argument0[11]);
d3d_vertex(argument0[6], argument0[10], argument0[11]);
d3d_vertex(argument0[9], argument0[7], argument0[8]);
d3d_vertex(argument0[9], argument0[10], argument0[8]);
d3d_vertex(argument0[9], argument0[7], argument0[11]);
d3d_vertex(argument0[9], argument0[10], argument0[11]);
d3d_primitive_end();

// Draw set colour
draw_set_colour(c_white);
