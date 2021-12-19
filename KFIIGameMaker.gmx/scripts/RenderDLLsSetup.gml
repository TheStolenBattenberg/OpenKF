///RenderDLLsSetup();

/**
 * Pretty important. Our support for Vulkan/DirectX12 is done via dgVoodoo2 and DXVK.
**/

switch(conMain.GameConfig[? "renderAPI"])
{
    case RenderAPI.DirectX9:
        show_debug_message("Renderer -> DirectX9");
        RenderDLLsDeleteDXVK();
        RenderDLLsDeletedgVoodoo();    
    break;
    
    case RenderAPI.Vulkan:
        RenderDLLsDeletedgVoodoo();
        zip_unzip("Data\Extension\dxvk.zip", program_directory);
    break;
    
    case RenderAPI.DirectX12:
        RenderDLLsDeleteDXVK();
        zip_unzip("Data\Extension\dgVoodoo.zip", program_directory);
    break;
}
