// Supercar HUD 2.1
// By Cuga Rajal (cuga@rajal.org) - An accessory script for the Supercar Plus package
// For the latest version and more information visit https://github.com/cuga-rajal/supercar_plus/ 
// This work is licensed under the Creative Commons BY-NC-SA 3.0 License: https://creativecommons.org/licenses/by-nc-sa/3.0/


integer RACECAR_HUD_CHANNEL = 19997;
integer listener;
key carkey = NULL_KEY;
key avkey = NULL_KEY;
integer askattach = FALSE;
integer honk = 0;
integer lights = 1;
integer smoke = 0;
integer fastdial=0;
integer DISPLAY_STRING      = 204000;

default {
    state_entry() {
        listener = llListen(RACECAR_HUD_CHANNEL, "", NULL_KEY, "");
        llSetText("0 mph",<1,1,.6>,1.0);
        llSetLinkAlpha(2, 1, ALL_SIDES);
        llSetLinkAlpha(3, 0, ALL_SIDES);
        llSetLinkPrimitiveParamsFast(4, [PRIM_ROT_LOCAL, llEuler2Rot(DEG_TO_RAD*<90,331,-90>)] );
        llMessageLinked(11, DISPLAY_STRING, "1", "");
        vector hudsize = llList2Vector(llGetLinkPrimitiveParams(1, [PRIM_SIZE]),0);
        float ratio = hudsize.x / 0.137294;
        llSetLinkPrimitiveParamsFast(11, [PRIM_POS_LOCAL, <-0.018298, 0.000000, 0.040009> * ratio]);
        llSetTimerEvent(60);
    }
    
    listen(integer channel, string name, key av, string message) {
            //llOwnerSay("HUD received message: " + message);
            if(llSubStringIndex(message, "avkey ") == 0) {
                avkey = (key)llGetSubString(message, 6, -1);
                llRequestPermissions( avkey, PERMISSION_ATTACH );
                askattach = TRUE;
            }
            else if(llSubStringIndex(message, "carkey ") == 0) {
                carkey = (key)llGetSubString(message, 7, -1);
            }
            else if(message=="control poof") {
                if(llGetAttached()) { llDetachFromAvatar(); }
                else { llDie(); }
            }
            else if(llSubStringIndex(message, "speed ") == 0) {
                integer speed = (integer)llGetSubString(message, 6, -1);
                if((speed>100) && (fastdial==0)) {
                    llSetLinkAlpha(2, 0, ALL_SIDES);
                    llSetLinkAlpha(3, 1, ALL_SIDES);
                    fastdial=1;
                } else if((speed<10) && (fastdial==1)) {
                    llSetLinkAlpha(3, 0, ALL_SIDES);
                    llSetLinkAlpha(2, 1, ALL_SIDES);
                    fastdial=0;
                }
                llSetText((string)llRound(speed) + "mph",<1,1,.6>,1.0);
                if(fastdial) {
                    llSetLinkPrimitiveParamsFast(4, [PRIM_ROT_LOCAL, llEuler2Rot(DEG_TO_RAD*<90,331-(0.6*speed),-90>)] );
                } else {
                    llSetLinkPrimitiveParamsFast(4, [PRIM_ROT_LOCAL, llEuler2Rot(DEG_TO_RAD*<90,331-(3*speed),-90>)] );
                }
            }
            else if(llSubStringIndex(message, "gear ") == 0) {
                string gear = llGetSubString(message, 5, -1);
                llMessageLinked(11, DISPLAY_STRING, gear, "");
                vector hudsize = llList2Vector(llGetLinkPrimitiveParams(1, [PRIM_SIZE]),0);
                float ratio = hudsize.x / 0.137294;
                if(llStringLength(gear)==1) { llSetLinkPrimitiveParamsFast(11, [PRIM_POS_LOCAL, <-0.018298, 0.000000, 0.040009> * ratio]); }
                else if(llStringLength(gear)==2) { llSetLinkPrimitiveParamsFast(11, [PRIM_POS_LOCAL, <-0.027018, 0.000000, 0.040009> * ratio]); }
            }
            if((carkey != NULL_KEY) && (askattach)) {
                llListenRemove(listener);
                listener = llListen(RACECAR_HUD_CHANNEL, "", carkey, "");
            }
    }
    
    touch_start(integer total_number) {
        integer touched = llDetectedLinkNumber(0);
        if(touched == 7) { // lights
            if(lights==0) {
                llRegionSayTo(carkey, RACECAR_HUD_CHANNEL, "lights_on");
                lights=1;
                llSetLinkPrimitiveParamsFast(7, [PRIM_COLOR, 0, <1.0,1.0,1.0>, 1.0, PRIM_GLOW, 0.28]);
            }
            else {
                llRegionSayTo(carkey, RACECAR_HUD_CHANNEL, "lights_off");
                lights=0;
                llSetLinkPrimitiveParamsFast(7, [PRIM_COLOR, 0, <0.8, 0.8, 0.8>, 1.0, PRIM_GLOW, 0.0]);
            }
        } else if(touched == 6) { // horn 
            if(honk==0) { llRegionSayTo(carkey, RACECAR_HUD_CHANNEL, "honk_on"); honk=1; 
                llSetLinkPrimitiveParamsFast(6, [PRIM_COLOR, 0, <1.0,1.0,1.0>, 1.0, PRIM_GLOW, 0.28]);}
            else {  llRegionSayTo(carkey, RACECAR_HUD_CHANNEL, "honk_off"); honk=0;
                llSetLinkPrimitiveParamsFast(6, [PRIM_COLOR, 0, <0.8, 0.8, 0.8>, 1.0, PRIM_GLOW, 0.0]);
            }
        } else if(touched == 5) { // burnout 
            if(smoke==0) { llRegionSayTo(carkey, RACECAR_HUD_CHANNEL, "smoke_on"); smoke=1;
                llSetLinkPrimitiveParamsFast(5, [PRIM_COLOR, 0, <1.0,1.0,1.0>, 1.0, PRIM_GLOW, 0.28]);
            }
            else {  llRegionSayTo(carkey, RACECAR_HUD_CHANNEL, "smoke_off"); smoke=0;
                llSetLinkPrimitiveParamsFast(5, [PRIM_COLOR, 0, <0.8, 0.8, 0.8>, 1.0, PRIM_GLOW, 0.0]);
            }
        } else if(touched == 10) { // up 
            llRegionSayTo(carkey, RACECAR_HUD_CHANNEL, "gear_up"); 
        } else if(touched == 8) { // down 
            llRegionSayTo(carkey, RACECAR_HUD_CHANNEL, "gear_down"); 
        } 
    }
    
    attach(key id) {
        if (id) {
            llRequestPermissions( id, PERMISSION_ATTACH );
        }
    }
    
    run_time_permissions( integer vBitPermissions ) {
        if (!llGetAttached() && (vBitPermissions & PERMISSION_ATTACH)) {
            llAttachToAvatarTemp(37);
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_ROT_LOCAL, llEuler2Rot(DEG_TO_RAD*<0, 270,270>)] );
            llSetLinkPrimitiveParamsFast(5, [PRIM_COLOR, 0, <0.8, 0.8, 0.8>, 1.0, PRIM_GLOW, 0.0]);
            llSetLinkPrimitiveParamsFast(6, [PRIM_COLOR, 0, <0.8, 0.8, 0.8>, 1.0, PRIM_GLOW, 0.0]);
            llSetLinkPrimitiveParamsFast(7, [PRIM_COLOR, 0, <0.8, 0.8, 0.8>, 1.0, PRIM_GLOW, 0.0]);
            llSetTimerEvent(0);
        } else {
            //llDie();
        }
    }
    
    on_rez(integer start_param) {
        llResetScript();
    }
    
    timer() { 
        //llDie();
    }
}
