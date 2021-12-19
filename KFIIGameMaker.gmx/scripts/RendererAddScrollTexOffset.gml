///RendererAddScrollTexOffset(texID, delta_x, delta_y, offX, offY);

var scrollTex = array_create(5);
    scrollTex[0] = argument0;
    scrollTex[1] = argument1;  
    scrollTex[2] = argument2;
    scrollTex[3] = 0;
    scrollTex[4] = 0;
    scrollTex[5] = argument3;
    scrollTex[6] = argument4;
    
ds_list_add(conRenderer.psxScrollTex, scrollTex);

