///RendererClearScrollTextures();

for(var i = 0; i < ds_list_size(conRenderer.psxScrollTex); ++i)
{
    conRenderer.psxScrollTex[| i] = -1;
}
ds_list_clear(conRenderer.psxScrollTex);
