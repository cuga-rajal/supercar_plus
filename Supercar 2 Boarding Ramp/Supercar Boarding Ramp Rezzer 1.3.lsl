// Boarding Ramp Rezzer 1.3
// By Cuga Rajal (cuga@rajal.org) - An accessory script for the Supercar Plus package
// For the latest version and more information visit https://github.com/cuga-rajal/supercar_plus/ 
// This work is licensed under the Creative Commons BY-NC-SA 3.0 License: https://creativecommons.org/licenses/by-nc-sa/3.0/

// Configurable settings

vector offset = <5.974, -4.005, 1.5013>; // rezzed item offset from rezzer prim when root prim is rotated 0,0,0.
vector ramprot = <38, 0, 180>; // rezzed item rotation relative to root prim, in degrees. If rezzer prim rot is 0,0,0, this is rot of ramp.
integer key_prim = 5; // select a prim number to hold ramp uuid in desc, *NOT root prim, wheel prim, or passenger seat!!**
integer COM_CHANNEL = 23572;

// End of configurable settings

key rampkey = NULL_KEY;

rezitem() {
    rotation objrot = llEuler2Rot(ramprot * DEG_TO_RAD) * llGetRootRotation();
    llRezAtRoot(llGetInventoryName(INVENTORY_OBJECT, 0), llGetPos() + (offset * llGetRootRotation()),ZERO_VECTOR, objrot,0); 
}

default {
    state_entry() {
        rampkey = (key)llList2String(llGetLinkPrimitiveParams(key_prim, [PRIM_DESC]), 0);
    }
    
    changed(integer change) {
        if (change & CHANGED_REGION_START) {
            rampkey = (key)llList2String(llGetLinkPrimitiveParams(key_prim, [PRIM_DESC]), 0);
        }
    }
    
    object_rez(key id) {
        rampkey = id;
        llSleep(1.0);
        llRegionSayTo(id, COM_CHANNEL, "carkey " + (string)llGetKey());
        llSetLinkPrimitiveParamsFast(key_prim, [PRIM_DESC, (string)id]);
    }
    
    link_message(integer Sender, integer Number, string String, key Key) {
        if(String == "car_stop") {
            rezitem();
        } else if(String == "car_start") {
            llRegionSayTo(rampkey, COM_CHANNEL, "control poof");
            rampkey = NULL_KEY;
        } else if(String == "car_park") {
            llRegionSayTo(rampkey, COM_CHANNEL, "control poof");
            rampkey = NULL_KEY;
            llSleep(2.0);
            rezitem();
        }
    }
}
