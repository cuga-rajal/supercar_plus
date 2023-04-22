// Supercar 2 Animation Controller 1.0
// By Cuga Rajal (cuga@rajal.org) - An accessory script for the Supercar Plus package
// For the latest version and more information visit https://github.com/cuga-rajal/supercar_plus/ 
// This work is licensed under the Creative Commons BY-NC-SA 3.0 License: https://creativecommons.org/licenses/by-nc-sa/3.0/

// configurable settings 

string          anim_fwd = "";  // animation to play when moving forward;
string          anim_idle = ""; // animation to play when idle;
string          anim_fast = ""; // optional; animation to play when moving forward at or above aggressive_gear
integer         aggressive_gear = 2;

// end of configurable parameters

string          currentanimation;
integer         gGear = 0;
key             driver;
key             lastdriver;

default {
    state_entry() {
    }
    
    changed(integer change) { 
        if (change & CHANGED_LINK) {
            driver = llAvatarOnLinkSitTarget(LINK_THIS);
            if ((driver != lastdriver) && (driver != NULL_KEY)) {
                llRequestPermissions(driver,  PERMISSION_TRIGGER_ANIMATION ); 
            }
            lastdriver = driver;
        }
    }
    
    run_time_permissions(integer perm) {
        if(perm & PERMISSION_TRIGGER_ANIMATION) {
            string pilot_anim = llGetAnimationOverride("Sitting");
            llStopAnimation(pilot_anim);
            llStopAnimation("sit");
            llStartAnimation(anim_idle);
            currentanimation=anim_idle;
        }
    }
    
    link_message(integer Sender, integer Number, string msg, key Key) {
        if(msg=="ForwardSpin") {
            if((anim_fwd != "") && (currentanimation != anim_fwd) && ((gGear < aggressive_gear) || ((gGear > aggressive_gear) && (anim_fast == "")))) {
                if(currentanimation != "") { llStopAnimation(currentanimation); }
                llStartAnimation(anim_fwd);
                currentanimation=anim_fwd;
            } else if((anim_fast != "") && (gGear>=aggressive_gear) && (currentanimation!=anim_fast)){
                if(currentanimation != "") { llStopAnimation(currentanimation); }
                llStartAnimation(anim_fast);
                currentanimation=anim_fast;
            }
        } else if(msg=="BackwardSpin") {
            if(currentanimation != "") { llStopAnimation(currentanimation); }
            llStartAnimation(anim_fwd);
            currentanimation=anim_fwd;
        } else if(msg=="NoSpin") {
            if((anim_idle != "") && (currentanimation!=anim_idle)) {
                 llStopAnimation(currentanimation);
                 llStartAnimation(anim_idle);
                 currentanimation=anim_idle;
            }
        } else if(llGetSubString(msg, 0, 4) == "gear ") {
            gGear = (integer)llGetSubString(msg, 5, -1);
        } 
    }

}

// END

