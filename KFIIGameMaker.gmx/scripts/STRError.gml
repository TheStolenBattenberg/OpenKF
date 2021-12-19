///STRError(STRERR);

switch(argument0)
{
    case STRERR_NOERROR:    break;
    case STRERR_BADXASYNC:
        show_debug_message("STR ERROR!!! Bad XA Sector Sync");
        break;
    case STRERR_BADXAMODE:
        show_debug_message("STR ERROR!!! Bad XA Sector Mode");
        break;    
}
