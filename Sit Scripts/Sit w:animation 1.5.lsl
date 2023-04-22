// Sit w/animation 1.5
// By Cuga Rajal (cuga@rajal.org) - An accessory script for the Supercar Plus package
// For the latest version and more information visit https://github.com/cuga-rajal/supercar_plus/ 
// This work is licensed under the Creative Commons BY-NC-SA 3.0 License: https://creativecommons.org/licenses/by-nc-sa/3.0/

// Configurable settings

integer setoffset = TRUE; // set to FALSE if you are using a sit positioning system to set the offset
vector sitposition = <0, 0, 0.5>;  // position relative to prim center <fwd-back, left-right, up-down> 
vector sitrotation = <0, 0, 0>; // rotation in degrees, relative to prim orientation
float alpha_not_sit = 1.0; // alpha when not seated. 1 = fully opaque, 0 = fully transparent
float alpha_on_sit = 1.0;  // alpha when seated
string sittext = ""; // Replaces "Sit" in right-click Menu. Set to "" to use the default
string hovertext = ""; // Hover text when nobody sitting. Set to "" to disable
vector hovercolor = <1.0, 1.0, 1.0>; // Color of hover text if used

// End of configurable settings

integer i;
integer count;
key av = NULL_KEY;
key lastav = NULL_KEY;

default {
    state_entry() {
        if(setoffset) {
            rotation sitrot = llEuler2Rot(sitrotation * DEG_TO_RAD);
            llSitTarget(sitposition, sitrot);
        }
        if(alpha_not_sit != alpha_on_sit) { llSetAlpha(alpha_not_sit, ALL_SIDES); }
        if(sittext != "") { llSetSitText(sittext); }
        if(hovertext != "") { llSetText(hovertext,hovercolor,1.0); }
    }
    
    on_rez(integer param)  {
        av = NULL_KEY;
        key lastav = NULL_KEY;
    }

    run_time_permissions(integer perm) {
        if(perm & PERMISSION_TRIGGER_ANIMATION ){
            count = llGetInventoryNumber(INVENTORY_ANIMATION);
            if (count != 0) {
                llStopAnimation("sit");
                for (i=0; i<count;i++) {
                    llStartAnimation(llGetInventoryName(INVENTORY_ANIMATION, i));
                }
            }
        }
        if(alpha_not_sit != alpha_on_sit) { llSetAlpha(alpha_on_sit, ALL_SIDES); }
        if(hovertext != "") { llSetText("",hovercolor,1.0); }
        // Add here anything else you want to happoen when avatar sits
        
    }
    changed(integer change) {
        if (change & CHANGED_LINK){
            av = llAvatarOnSitTarget();
            if ((av == NULL_KEY) && (av != lastav)) {
                if(alpha_not_sit != alpha_on_sit) { llSetAlpha(alpha_not_sit, ALL_SIDES); }
                integer perm = llGetPermissions();
                if((perm & PERMISSION_TRIGGER_ANIMATION) && (llGetAgentSize(lastav)!=ZERO_VECTOR)) {
                    count = llGetInventoryNumber(INVENTORY_ANIMATION);
                    if (count != 0) {
                        for (i=0; i<count;i++) {
                            llStopAnimation(llGetInventoryName(INVENTORY_ANIMATION, i));
                        }
                    }
                }
                if(hovertext != "") { llSetText(hovertext,hovercolor,1.0); }
                // Add here anything else you want to happen when avatar stands

            } else if(av != lastav) {
                llRequestPermissions(av, PERMISSION_TRIGGER_ANIMATION);
            }
            lastav = av;
        }
    }
}
