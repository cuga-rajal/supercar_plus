// Supercar Horn 1.80
// For use with Supercar Plus script (https://github.com/cuga-rajal/supercar_plus)
// Place this script, and the desired horn sound, in the prim you want to act as the horn
// It will respond to touch_start or to horn signals from the HUD

default{
    state_entry() {
        
    }
    
    touch_start(integer total_number) {
        llLoopSound(llGetInventoryName(INVENTORY_SOUND, 0),1.0);
    }
    
    touch_end(integer total_number) {
        llStopSound();
    }

    link_message(integer sender, integer num, string str, key id){
        if (str=="honk") { llLoopSound(llGetInventoryName(INVENTORY_SOUND, 0),1.0);}
        else if (str=="honkoff") { llStopSound();}
    } 
}
