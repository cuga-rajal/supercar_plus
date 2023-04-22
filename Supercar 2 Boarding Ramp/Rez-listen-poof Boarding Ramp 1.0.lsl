// Rez-listen-poof Boarding Ramp 1.0
// By Cuga Rajal (cuga@rajal.org) - An accessory script for the Supercar Plus package
// For the latest version and more information visit https://github.com/cuga-rajal/supercar_plus/ 
// This work is licensed under the Creative Commons BY-NC-SA 3.0 License: https://creativecommons.org/licenses/by-nc-sa/3.0/

// Configurable settings

integer COM_CHANNEL = 23572; // should match channel used by rezzer script

// End of configurable settings

key carkey = NULL_KEY;
integer listener;

default {
    state_entry() {
        listener = llListen(COM_CHANNEL, "", NULL_KEY, "");
        llCollisionSound(NULL_KEY,0);
    }
    
    on_rez(integer param) {
        llResetScript();
    }

    listen(integer channel, string name, key av, string message) {
        if((carkey == NULL_KEY) && (llSubStringIndex(message, "carkey ") == 0)) {
            carkey = llGetSubString(message, 7, -1);
            llListenRemove(listener);
            listener = llListen(COM_CHANNEL, "", carkey, "");
        } else if(message=="control poof") {
            llDie();
        }
    }
}
