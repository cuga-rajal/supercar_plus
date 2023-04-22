// Manage Child Prim Sits 2.0
// By Cuga Rajal (cuga@rajal.org) - An accessory script for the Supercar Plus package
// For the latest version and more information visit https://github.com/cuga-rajal/supercar_plus/ 
// This work is licensed under the Creative Commons BY-NC-SA 3.0 License: https://creativecommons.org/licenses/by-nc-sa/3.0/

// Configurable settings

// instructions:
// 1. Create individual sits in child prims with individual sit scripts and animations
//    Adjust the sit offsets on each sit prim for specific animations.
// 2. For each seat prim,
//    a) copy the exact name of the animation to the prim Description,
//    b) set the prim Name to the word "sit",
//    c) Place a copy of the seat's animation into the root prim
//    d) then remove the sit script and the animation from the seat prim
// 4. Place a copy of this script in the root prim

// configurable settings 

float alpha_not_sit = 1.0; // alpha when not seated. 1 = opaque, 0 = transparent
float alpha_on_sit = 0.0;  // alpha when seated
string sit_message = ""; // local chat message to each person who just sat down

// end of configurable settings 

list sitprims; 
integer i; 
integer numprims; 
integer totalprims;
string dancename;


default {
    state_entry() {
        totalprims = llGetObjectPrimCount(llGetKey());
        for(i=2; i<= llGetObjectPrimCount(llGetKey()); i++) {
            if(llList2String(llGetLinkPrimitiveParams(i, [PRIM_NAME]), 0) == "sit") { sitprims += i; }
        }
    }

    changed(integer change) {     
        if (change & CHANGED_LINK) {
            if(totalprims != llGetObjectPrimCount(llGetKey())) { // prim was added or removed
                llResetScript();
            } else if(llGetNumberOfPrims() > numprims) {  // someone just sat down
                key av = llGetLinkKey(llGetNumberOfPrims());
                for(i=0; i<llGetListLength(sitprims); i++) {
                    if(llAvatarOnLinkSitTarget(llList2Integer(sitprims,i)) == av) {
                        if(alpha_not_sit != alpha_on_sit) {
                            llSetLinkAlpha(llList2Integer(sitprims,i), alpha_on_sit, ALL_SIDES);
                        }
                        dancename = llList2String(llGetLinkPrimitiveParams(llList2Integer(sitprims,i), [PRIM_DESC]), 0);
                        if(sit_message != "") { llRegionSayTo(av, 0, sit_message); }
                        llRequestPermissions(av, PERMISSION_TRIGGER_ANIMATION);
                        jump done; 
                    }
                }
                @done;
            } else {  // someone stood up
                for(i=0; i<llGetListLength(sitprims); i++) {
                    if(llAvatarOnLinkSitTarget(llList2Integer(sitprims,i)) == NULL_KEY) {
                        if(alpha_not_sit != alpha_on_sit){
                            llSetLinkAlpha(llList2Integer(sitprims,i), alpha_not_sit, ALL_SIDES);
                        }
                    }
                }
            }
            numprims = llGetNumberOfPrims();
        }
    }
    
    run_time_permissions(integer perm) {
        if(perm & PERMISSION_TRIGGER_ANIMATION ){
            llStopAnimation("sit");
            llStartAnimation(dancename);
        }
    }
              
}
