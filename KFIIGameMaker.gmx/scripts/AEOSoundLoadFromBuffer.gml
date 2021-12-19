///AEOSoundLoadFromBuffer(buffer, offset, size, flags);
gml_pragma("forceinline");

return external_call(global.aeoSoundLoadFB, buffer_get_address(argument0), argument1, argument2, argument3);
