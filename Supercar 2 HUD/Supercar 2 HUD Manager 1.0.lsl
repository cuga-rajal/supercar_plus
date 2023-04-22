// Supercar 2 HUD Manager 1.0
// By Cuga Rajal (cuga@rajal.org) - An accessory script for the Supercar Plus package
// For the latest version and more information visit https://github.com/cuga-rajal/supercar_plus/ 
// This work is licensed under the Creative Commons BY-NC-SA 3.0 License: https://creativecommons.org/licenses/by-nc-sa/3.0/

// configurable settings 

string          hud_name = "Supercar HUD 2.0"; // HUD with this name should be in Contents
integer         HUD_CHANNEL = 19997;  // Shound match the channel the HUD is using
float           poll_time = 0.1;  // Update interval in secs. Use higher number to reduce lag
 
// end of configurable settings

integer         listener;
key             hudid = NULL_KEY;
float           gSpeed;
float           lastspeed;
integer         gGear;
integer         timeron = FALSE;

default {
    state_entry() {
    }
    
    object_rez(key id) {
        hudid = id;
        listener = llListen(HUD_CHANNEL, "", id, "");
        llRegionSayTo(id, HUD_CHANNEL, "avkey " + (string)llAvatarOnLinkSitTarget(LINK_THIS));
        llRegionSayTo(id, HUD_CHANNEL, "carkey " + (string)llGetKey());
        llSleep(0.5);
        llRegionSayTo(id, HUD_CHANNEL, "gear " + (string)(gGear + 1));
    }
    
    link_message(integer Sender, integer Number, string msg, key Key) {
        if(msg == "car_start") {
            key driver = llAvatarOnLinkSitTarget(LINK_THIS);
            if ((llGetInventoryNumber(INVENTORY_OBJECT) != 0) && (llGetInventoryName(INVENTORY_OBJECT, 0) == hud_name)) {
                llRezObject(hud_name, llGetPos()+<0.0,0.0,5.0>,ZERO_VECTOR,ZERO_ROTATION,90);
                llRegionSayTo(driver,0,"Please confirm the dialog to attach the HUD");
                llSetTimerEvent(poll_time);
            }
        } else if(msg == "car_stop") {
            llSetTimerEvent(0);
            timeron = FALSE;
            llRegionSayTo(hudid, HUD_CHANNEL, "control poof");
            llListenRemove(listener);  
        } else if((msg == "ForwardSpin") || (msg == "BackwardSpin")) {
            if(! timeron) {
                timeron = TRUE;
                llSetTimerEvent(poll_time);
            }
        } else if(llGetSubString(msg, 0, 4) == "gear ") {
            gGear = (integer)llGetSubString(msg, 5, -1);
            llRegionSayTo(hudid,HUD_CHANNEL,msg);
        }
    }
    
    listen(integer channel, string name, key av, string message) {
        if(message=="gear_up") { 
            llMessageLinked(LINK_THIS, 0, "gear_up", NULL_KEY);
        } else if(message=="gear_down") {
            llMessageLinked(LINK_THIS, 0, "gear_down", NULL_KEY);
        }
        else if(message=="honk_on") { llMessageLinked(LINK_SET, 0, "honk", NULL_KEY);  }
        else if(message=="honk_off") { llMessageLinked(LINK_SET, 0, "honkoff", NULL_KEY);  }
        else if(message=="lights_on") { llMessageLinked(LINK_SET, 0, "headlight", NULL_KEY); }
        else if(message=="lights_off") { llMessageLinked(LINK_SET, 0, "headlightoff", NULL_KEY); }
        else if(message=="smoke_on") { llMessageLinked(LINK_SET, 0, "smoke_on", NULL_KEY); }
        else if(message=="smoke_off") { llMessageLinked(LINK_SET, 0, "smoke_off", NULL_KEY);  }
    }
    

    timer() {
        gSpeed = llRound(llVecMag(llGetVel()*2.23692912));
        if(gSpeed<0.2) {
            llRegionSayTo(hudid,HUD_CHANNEL,"speed 0"); 
            llSetTimerEvent(0);
            timeron = FALSE;
        } else if(lastspeed != gSpeed) {
            llRegionSayTo(hudid,HUD_CHANNEL,"speed " + (string)gSpeed);
            lastspeed = gSpeed;
        }
    }

}

// END

