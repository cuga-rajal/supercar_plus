// Supercar Multi-Sim Autopark v2.3, Oct 26, 2025
// By Cuga Rajal (cuga@rajal.org) - An accessory script for the Supercar Plus package
// For the latest version and more information visit https://github.com/cuga-rajal/supercar_plus/ 
// This work is licensed under the Creative Commons BY-NC-SA 3.0 License: https://creativecommons.org/licenses/by-nc-sa/3.0/
//
// This script will park your vehicle back to its parking spot after the driver stands, and 
// after a configurable delay.
//
// To use in a single region without neighboring regions, you only need to configure
// the delay after the driver stands before it parks.
//
// To use it for parking in places with multiple adjacent regions, additional configurations
// are required. Details in the following section.
//
// Regions must be all the same size and in a rectangular grid of A by B regions, 
// where A and B are 9 or less.
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
// 3) Set the regionSize setting to the region size in meters. In SL this is always 256.
// 4) Set the desired value for parkDelay, in seconds.
//
// Then drop this script in, and owner-touch the vehicle while it is not being driven.
// This will bring up a dialog confirming the new parking location.
// ----------------------------

// configurable parameters *

integer parkDelay = 30; // seconds after driver stands that car auto-parks

// Following parameters are only required for multi-sim auto-park - please read instructions above

list simnames =[ "Southeast", "South", "Southwest",
                "East", "Center", "West", 
                "Northeast", "North", "Northwest" ];
list codes = [ 11, 12, 13, 21, 22, 23, 31, 32, 33 ];

integer regionSize = 256;

// end of configurable parameters 

float moveDelay = 2.0; // delay between cross-sim moves during repark - don't alter this unless you know what you're doing
vector currentPosition;
vector HomePos;
rotation HomeRot;
string HomeRegion;
integer waitingToPark = FALSE;
integer wasDriving = FALSE;
key agent = NULL_KEY;
key lastav;
string regioncode;
string homecode;
integer menu_handler; 
integer menu_channel;
integer clicktopause = FALSE;




Home() {
    llSetRegionPos(HomePos);
    llSetRot(HomeRot);
    llSetStatus( STATUS_PHANTOM, FALSE);
    llMessageLinked(LINK_SET, 0, "park_done", NULL_KEY);
    llSay(0,"Auto-Park Complete!");
    llListenRemove(menu_handler); // just in case a listener was left open
}

Park() {
    string region = llGetRegionName();
    
    if(region == HomeRegion) {
        Home();
        return;
    }
    
    if(llListFindList(simnames, [region]) == -1) {
        llInstantMessage(llGetOwner(),
        llGetScriptName() + " failed to return your car \"" + llGetObjectName() +
        "\". It is located in region \"" + region + "\" at location " +
        (string)llGetPos() );
        return;
    }
    
    currentPosition = llGetPos();
    regioncode = (string)llList2Integer(codes, llListFindList( simnames, [region]));
    homecode = (string)llList2Integer(codes, llListFindList( simnames, [HomeRegion]));
    
    if((integer)llGetSubString(regioncode, 1, 1) < (integer)llGetSubString(homecode, 1, 1)) {
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
}

menu(key user,string title,list object_list)  { 
	llListenRemove(menu_handler);
    menu_channel = (integer)(llFrand(99999.0) * -1); //random channel 
    menu_handler = llListen(menu_channel,"","",""); 
    llDialog(user,title,object_list,menu_channel); 
} 

default {
    on_rez(integer param) {
        HomePos = ZERO_VECTOR;
        if((llList2Integer(llGetObjectDetails(llGetLinkKey(LINK_THIS), [ OBJECT_TEMP_ON_REZ ]), 0)==0)) { 
            llOwnerSay("To enable Auto-Park, place your vehicle in its parking location and then touch the vehicle to open the dialog.");
        }
    }
    
    state_entry(){
        init();
        llOwnerSay("Auto-park position set");
    }
    
    changed(integer change) {       
        if (change & CHANGED_LINK) {
            agent = llAvatarOnSitTarget();
            if ((agent == NULL_KEY) && (lastav != NULL_KEY)) {  // driver just stood up
                if((waitingToPark == FALSE) && (wasDriving == TRUE) && (! clicktopause) && (HomePos != ZERO_VECTOR)) {
                    llSay(0,"The vehicle will self-park in " + (string)parkDelay + " seconds." );
                    waitingToPark = TRUE;
                    llSetTimerEvent(parkDelay);
                }
                wasDriving = FALSE; 
            } else if ((agent != NULL_KEY) && (agent != lastav) && (HomePos != ZERO_VECTOR)) {
                clicktopause = FALSE; // re-enable auto-park on driver stand if it was disabled
                wasDriving = TRUE;
                llSleep(1);
                if(waitingToPark) {
                    llRegionSayTo(agent,0,"Self-parking canceled." );
                    waitingToPark = FALSE;
                    llSetTimerEvent(0); // cancel auto-park
                }
            }
            lastav = agent;
        }
    }
    
    link_message(integer Sender, integer Number, string msg, key Key) {
        if((msg=="car_stop") && (llAvatarOnSitTarget() != NULL_KEY)) { // can only happen if driver clicked "Park Car"
            clicktopause = TRUE;
        } else if(msg=="car_start") {
            clicktopause = FALSE;
        }
    }
    
    touch_start(integer total_number) { 
        if((! llGetStatus(STATUS_PHYSICS)) && (llDetectedKey(0) == llGetOwner())) { // physics is off, owner touch
            if(waitingToPark) {
                menu(llGetOwner(),"\nThe vehicle is currently in countdown to auto-park. Are you sure you want to cancel this and change the Auto-Park location?",["Yes, Reset", "Cancel"]); 
            } else if (agent == NULL_KEY) { // no driver seated
                menu(llGetOwner(),"\nSet Auto-Park location?",["Set Location", "Cancel"]); 
            }
        }
    }
    
    listen(integer channel, string name, key av, string message) {
        if ((channel == menu_channel) && (av == llGetOwner()) && ((message == "Set Location") || (message == "Yes, Reset"))) {
            llSetTimerEvent(0.0); 
            llListenRemove(menu_handler); 
            init();
            llOwnerSay("Auto-park position set");
            waitingToPark = FALSE; 
        }
    }
                
    timer() {
        llSay(0,"Vehicle self-parking now.");  
        llMessageLinked(LINK_SET, 0, "car_park", NULL_KEY);
        waitingToPark = FALSE;    
        llSetStatus( STATUS_PHANTOM, TRUE);
        llSetStatus( STATUS_PHYSICS, FALSE); 
        llSetTimerEvent(0);
        Park();
    }
}
