// Headlight 1.61
// For use with Supercar Plus script (https://github.com/cuga-rajal/supercar_plus)
// Place this in a prim that is supposed to be the headlight beam. 
// It will respond to headlight signals from the HUD

// Although not required, it is recommended to make this prim physics type None

default
{
    state_entry() {
    }
    
    link_message(integer sender, integer num, string message, key id)
    {
        if(message=="headlight") { llSetLinkPrimitiveParamsFast(LINK_THIS, [ PRIM_GLOW, ALL_SIDES, 0.05 ]); }
        else if (message=="headlightoff") { llSetLinkPrimitiveParamsFast(LINK_THIS, [ PRIM_GLOW, ALL_SIDES, 0 ]); }
    }

}