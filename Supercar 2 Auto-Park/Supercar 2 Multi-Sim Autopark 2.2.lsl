// Supercar Multi-Sim Autopark v2.2, Nov 14, 2024
// By Cuga Rajal (cuga@rajal.org) - An accessory script for the Supercar Plus package
// For the latest version and more information visit https://github.com/cuga-rajal/supercar_plus/ 
// This work is licensed under the Creative Commons BY-NC-SA 3.0 License: https://creativecommons.org/licenses/by-nc-sa/3.0/
//
// This script will auto-park the vehicle from any place in any of the regions back to your
// parking spot also anywhere else in the regions.
//
// Adjacent regions must be all the same size and in a rectangular grid of A by B regions, 
// where A and B are 9 or less.
//
// Make sure you have disabled the auto-park config option in the Supercar script by setting the
// "auto_return_time" config to 0. That option only works in a single region.
// Use this script instead for multi-region support for auto-park.
//
// *** Setup process ***
// Replace the sample data for "simnames", "codes" and "parkDelay" below with your settings.
//
// 1) "simnames" should be the list of region names that are returned from llGetRegionName();
//    These should be ordered as the example shows, in order of rows with the most Southeast
//    first and the most Northwest last. The example is for a 3x3 grid but this can be
//    any size up to 9x9.
// 2) "codes" should be a list of integers where the first digit is the row number (1=Southmost)
//    and the 2nd digit is the column number (1=Eastmost). These should be listed in the same order
//    as the corresponding simnames.
// 3) Set the regionSize setting to the region size in meters
// 4) Set the desired value for parkDelay, in seconds.
//
// Then drop this script in, and owner-touch the vehicle while it is not being driven.
// This will bring up a dialog confirming the new parking location.
//
// Read the Supercar documentation for more details.
// ----------------------------

// configurable parameters *

list simnames =[ "Southeast", "South", "Southwest",
                "East", "Center", "West", 
                "Northeast", "North", "Northwest" ];
list codes = [ 11, 12, 13, 21, 22, 23, 31, 32, 33 ];

integer regionSize = 256;

integer parkDelay = 10; // seconds after driver stands that car auto-parks

// end of configurable parameters 

float moveDelay = 2.0; // delay between cross-sim moves during repark - don't alter this
string region;
vector currentPosition;
vector HomePos;
rotation HomeRot;
string HomeRegion;
integer waitingToPark = FALSE;
integer wasDriving = FALSE;
key agent;
key lastav;
string regioncode;
string homecode;
integer menu_handler; 
integer menu_channel;
integer dialogwait = FALSE;
integer clicktopark = FALSE;




Home() {
    llSetRegionPos(HomePos);
    llSetRot(HomeRot);
    llSetStatus( STATUS_PHANTOM, FALSE);
    llMessageLinked(LINK_SET, 0, "park_done", NULL_KEY);
    llSay(0,"Auto-Park Complete!");
    llResetScript(); // just in case a listener was left open
}

Park() {
    region = llGetRegionName();
    currentPosition = llGetPos();
    regioncode = (string)llList2Integer(codes, llListFindList( simnames, [region]));
    if(regioncode == "-1") {
        llOwnerSay("\nohmygosh, I have become MOOP!");
        llInstantMessage(llGetOwner(),
        llGetScriptName() + " failed to return your car \"" + llGetObjectName() +
        "\". It is located in region \"" + region + "\" at location " +
        (string)llGetPos() );
        return;
    }
    
    if(region == HomeRegion) {
        Home();
        return;
    } else if((integer)llGetSubString(regioncode, 1, 1) < (integer)llGetSubString(homecode, 1, 1)) {
        llSetRegionPos(< 2.0, 2.0, currentPosition.z >);
        llSleep(moveDelay);
        llSetPos( llGetPos() + < -10.0, 0.0 , 0.0 > );   
        Park();
    } else if((integer)llGetSubString(regioncode, 1, 1) > (integer)llGetSubString(homecode, 1, 1)) {
        llSetRegionPos(< regionSize - 2, regionSize - 2, currentPosition.z >);
        llSleep(moveDelay);
        llSetPos( llGetPos() + < 10.0, 0.0 , 0.0 > );   
        Park();
    } else if((integer)llGetSubString(regioncode, 0, 0) > (integer)llGetSubString(homecode, 0, 0)) {
        llSetRegionPos(< 2.0, 2.0, currentPosition.z >);
        llSleep(moveDelay);
        llSetPos( llGetPos() + < 0.0, -10.0 , 0.0 > );   
        Park();
    } else if((integer)llGetSubString(regioncode, 0, 0) < (integer)llGetSubString(homecode, 0, 0)) {
        llSetRegionPos(< regionSize - 2, regionSize - 2, currentPosition.z >);
        llSleep(moveDelay);
        llSetPos( llGetPos() + < 0.0, 10.0 , 0.0 > );   
        Park();
    } 
}

init() {
    HomeRot = llGetRot();
    HomePos = llGetPos();  
    HomeRegion = llGetRegionName();
    homecode = (string)llList2Integer(codes, llListFindList( simnames, [HomeRegion]));
}

menu(key user,string title,list object_list)  { 
    menu_channel = (integer)(llFrand(99999.0) * -1); //random channel 
    menu_handler = llListen(menu_channel,"","",""); 
    llDialog(user,title,object_list,menu_channel); 
    if(! waitingToPark) {
        llSetTimerEvent(30.0); //menu channel open for 30 seconds 
        dialogwait = TRUE;
    }
    // If dialog is opened during auto-park countdown, there is no timer to remove the listener
    // In this case the listener will be removed at completion of auto-park
} 

default {
    on_rez(integer param) { 
        llResetScript();
    }
    
    state_entry(){
        init();
    }
    
    changed(integer change) {       
        if (change & CHANGED_LINK) {
            agent = llAvatarOnSitTarget();
            if (agent == NULL_KEY) {  // no driver
                if((waitingToPark == FALSE) && (wasDriving == TRUE) && (! clicktopark)) {
                    llSay(0,"The vehicle will self-park in " + (string)parkDelay + " seconds." );
                    waitingToPark = TRUE;
                    llSetTimerEvent(parkDelay);
                }
                wasDriving = FALSE; 
            } else {
                clicktopark = FALSE; // re-enable auto-park on driver stand if it was disabled
                wasDriving = TRUE;
                llSleep(1);
                //if(llGetStatus(STATUS_PHYSICS)) {
                    if(waitingToPark) {
                        llRegionSayTo(agent,0,"Self-parking canceled." );
                        waitingToPark = FALSE;
                        llSetTimerEvent(0); // cancel auto-park
                    }
                    wasDriving = TRUE;
                    lastav = agent;
                //}
            }
        }
    }
    
    link_message(integer Sender, integer Number, string msg, key Key) {
        if((msg=="car_stop") && (llAvatarOnSitTarget() != NULL_KEY)) { // can only happen if driver clicked "Park Car"
            clicktopark = TRUE;
        } else if(msg=="car_start") {
            clicktopark = FALSE;
        }
    }
    
    touch_start(integer total_number) { 
        if(! llGetStatus(STATUS_PHYSICS) && (llDetectedKey(0) == llGetOwner())) { // physics is off, owner touch
            if(waitingToPark) {
                menu(llGetOwner(),"\nThe vehicle is currently in countdown to auto-park. Are you sure you want to cancel this and change the Auto-Park location?",["Yes, Reset", "Cancel"]); 
            } else if (agent == NULL_KEY) { // no driver seated
                menu(llGetOwner(),"\nSet Auto-Park location?",["Set Location", "Cancel"]); 
            }
        }
    }
    
    listen(integer channel, string name, key av, string message) {
        if ((channel == menu_channel) && (av == llGetOwner()) && ((message == "Set Location") || (message == "Yes, Reset"))) {
            dialogwait = FALSE;
            llSetTimerEvent(0.0); 
            llListenRemove(menu_handler); 
            init();
            llOwnerSay("Auto-park position set");
        }
    }
                
    timer() {
        if(dialogwait) {
            llListenRemove(menu_handler);
            llSetTimerEvent(0.0);  
            dialogwait = FALSE;
            return;
        } 
        llSay(0,"Vehicle self-parking now.");  
        llMessageLinked(LINK_SET, 0, "car_park", NULL_KEY);
        waitingToPark = FALSE;    
        llSetStatus( STATUS_PHANTOM, TRUE);
        llSetStatus( STATUS_PHYSICS, FALSE); 
        llSetTimerEvent(0);
        Park();
    }
}
