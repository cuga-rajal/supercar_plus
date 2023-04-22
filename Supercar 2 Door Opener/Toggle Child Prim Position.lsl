// Toggle Child Prim Position
// By Cuga Rajal (cuga@rajal.org) - An accessory script for the Supercar Plus package
// For the latest version and more information visit https://github.com/cuga-rajal/supercar_plus/ 
// This work is licensed under the Creative Commons BY-NC-SA 3.0 License: https://creativecommons.org/licenses/by-nc-sa/3.0/

// UPDATE THESE SETTINGS BEFORE USING! Values are provided only as an example.

vector pos1 = <3.2, -7.2, -0.19>; 
vector angle1 = <0, 37.7, 0>;  // in degrees
vector pos2 = <4.6, -7.2, 1.9>;
vector angle2 = <0, -49, 0>;  // in degrees
string sound_open = ""; // sound to make when it opens
string sound_closed = ""; // sound to make when it closes


integer n = 0;



set_closed() {
    llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_POS_LOCAL, pos1,
                                            PRIM_ROT_LOCAL, llEuler2Rot(angle1 * DEG_TO_RAD)]);
    n=0;
}

set_open() {
    llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_POS_LOCAL, pos2,
                                            PRIM_ROT_LOCAL, llEuler2Rot(angle2 * DEG_TO_RAD)]);
    n=1;
}


default {
    state_entry() {
        set_closed();
    }
    
    touch_start(integer num) {
        if(llDetectedLinkNumber(0)==llGetLinkNumber()) {
            if(n==0) {
            	if(sound_open!="") { llPlaySound(sound_open, 1.0); }
                set_open();
            } else {
            	if(sound_closed!="") { llPlaySound(sound_closed, 1.0); }
                set_closed();
            }
        }
    }
}