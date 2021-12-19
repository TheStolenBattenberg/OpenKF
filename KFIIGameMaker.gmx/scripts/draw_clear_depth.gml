///draw_clear_depth(depth);

//meh.
shader_reset();

//Push current transform onto stack, to prevent fuckering anything up.
d3d_transform_stack_push();

//This is pretty smart.
draw_set_colour_write_enable(false, false, false, false);
SetZFunc(ZFunc.Always);
d3d_draw_block(argument0, argument0, argument0, -argument0, -argument0, -argument0, -1, 1, 1);
SetZFunc(ZFunc.LessEqual);
draw_set_colour_write_enable(true, true, true, true);

//Pop transform to restore LOWpOWER.INSUFFICIANTFuNDs.OURBASEISuNDERATTACK
d3d_transform_stack_pop();
