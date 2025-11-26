// Supercar 2.2
 
// By Cuga Rajal <cuga@rajal.org>
// Latest version and more information at https://github.com/cuga-rajal/supercar_plus/
// This work is licensed under the Creative Commons BY 4.0 License: https://creativecommons.org/licenses/by/4.0/
 
//---USER-DEFINED VARIABLES--------------------------------------------------
// * NOTE * There is an option to use a Config notecard to hold settings and thereby ignore those listed below.
// * This allows future script updates to be drop-in replacements without the need to hand-edit settings.
// * To use this option place a Config notecard and Supercar Config NC Reader script along with this script in the Contents
// * Please see the sample Config notecard. This is the recommended method.
 
// Permissions
integer         gDrivePermit = 1; // Who is allowed to drive car: 0=everyone, 1=owner only, 2=group member
list            driverList = [ ]; // list of UUIDs allowed to drive (whitelist), comma delimited, no spaces
string          gSitMessage = "Drive";  // Appears in the pie menu
string          gUrNotAllowedMessage = "Vehicle is Locked";  // Message to chat window if not allowed

// Gear options -- NOTE: 0=first gear, 11=12th gear
integer         maxGear = 4;       // highest gear that can be shifted to, max 11
integer         startGear = 0;      // gear selected on sit
integer         fallbackAbove = 6;  // racecar feature; releasing forward button when gear higher than this falls back to this
list            turnList = [ 3, 3.5, 3.5, 3.5, 3.5, 4.0, 4.1, 4.5, 10.0, 10.0, 10.0, 10.0];
list            speedList = [ 4, 8, 16, 32, 56, 80, 100, 130, 156, 185, 210, 256 ];
float           turn_in_place_speed = 1; // Rotation speed if rotating in place. Set to 0 to disable.
float           tilt_push = 0;  // side force pushing the vehicle into the turn like a motorcycle, typically 5-20
 
// Camera options
integer         enableCamera = TRUE;  // Whether or not to enable camera controls
float           CamDist = 16; // How far back you want the camera positioned
float           CamPitch = 20.0;  // Angle looking down. Range is -45 to 80 Degrees
float           lookAhead = 8.0;  // How far in front of avatar to focus camera. Range is -10 to 10 meters
                
// Other options
integer         click_to_pause = FALSE; // If TRUE will allow driver to click vehicle to toggle engine and lights
string          sit_message = "The car has 5 gears. Use up/down controls to change gears."; // Chat window message shown to driver when sitting

// Sound variables
integer         aggressive_gear = 3; // This gear and above play "gSoundAggressive", below this gear plays "gSoundSlow"
string          gSoundStartup = "Truck Start"; // sound made when driver seated
string          gSoundIdle = "Truck Idle";  // looped sound when not moving
string          gSoundSlow = "Truck Drive";   // looped sound when driving forward and gear below aggresive_gear
string          gSoundAggressive = "Truck High Gear";  // looped sound when driving forward and gear at or above aggresive_gear
string          gSoundRev = "Truck Drive";  // looped sound when driving in reverse
string          gSoundStop = "Truck Off";   // sound when the driver stands
string          gSoundAlarm = "";   // sound if someone not authorized tries to drive car

//---INTERNAL VARIABLES--------------------------------------------------

list            prim_phys_types = [ ];
list            prims_keep_prim = [ ];
integer         i;
integer         primcount;
key             driver = NULL_KEY;
integer         gRun;     //ENGINE RUNNING
integer         gMoving;  //VEHICLE MOVING
integer         sentPower;
integer         seated = FALSE;
integer         parked = FALSE;

integer         reverse;
list            wheels;
list            wheelvec;
list            fwlocalrot;
float           spinstate;
string          currSound;

float           gVAMT=0.35;              // how fast turning force is applied
vector          gVLFT=<80.0,3000.0,8.0>;   // XYZ linear friction   gVLFT=<8.0,3000.0,8.0>
 
integer         gGear;
float           gGearPower;
float           gTurnMulti=1.012345;
float           gTurnRatio;
list            gGearNameList             =[   "1st Gear",
                                               "2nd Gear",
                                               "3rd Gear",
                                               "4th Gear",
                                               "5th Gear",
                                               "6th Gear",
                                               "7th Gear",
                                               "8th Gear",
                                               "9th Gear",
                                               "10th Gear",
                                               "11th Gear",
                                               "12th Gear"
                                         ];
                                         

string          gTurnAngle =               "NoTurn";  // LeftTurn or RightTurn or NoTurn
string          gNewTurnAngle =            "NoTurn";
string          gTireSpin =                "NoSpin";   // ForwardSpin or BackwardSpin or NoSpin
string          gNewTireSpin =             "NoSpin";

integer menu_handler; 
integer menu_channel;
integer do_preload = FALSE; 

menu(key user,string title,list object_list)  { 
    menu_channel = (integer)(llFrand(99999.0) * -1); //random channel 
    menu_handler = llListen(menu_channel,"","",""); 
    llDialog(user,title,object_list,menu_channel); 
} 

init_PhysEng(){
    if(llSubStringIndex(llGetEnv("sim_channel"), "Second Life") !=-1) { // SL/Havok
        gTurnMulti=2;
        llOwnerSay("   Tuned for SL/Havok");
    } else {  // Opensim/Bullet/ODE
        gTurnMulti=0.987654; // adjustment for tire rotation
        gVAMT=0.50; // adjustment for turn speed/force
        llOwnerSay("   Tuned for Opensim");
    }

}

preload_sounds(){
    list InventoryList;
    integer count = llGetInventoryNumber(INVENTORY_SOUND);
    string  ItemName;
    while (count--)    {
        ItemName = llGetInventoryName(INVENTORY_SOUND, count);
        InventoryList += ItemName;
    }
    integer index = llListFindList(InventoryList, [gSoundStartup]);
    if((index == -1) && (llStringLength(gSoundStartup) != 36)) { gSoundStartup=""; } else if(gSoundSlow != "") { llPreloadSound(gSoundStartup); }
    index = llListFindList(InventoryList, [gSoundIdle]);
    if((index == -1) && (llStringLength(gSoundIdle) != 36)) { gSoundIdle=""; } else if(gSoundIdle != "") { llPreloadSound(gSoundIdle); }
    index = llListFindList(InventoryList, [gSoundSlow]);
    if((index == -1) && (llStringLength(gSoundSlow) != 36)) { gSoundSlow=""; } else if(gSoundSlow != "") { llPreloadSound(gSoundSlow); }
    index = llListFindList(InventoryList, [gSoundAggressive]);
    if((index == -1) && (llStringLength(gSoundAggressive) != 36)) { gSoundAggressive=""; } else if(gSoundAggressive != "") { llPreloadSound(gSoundAggressive); }
    index = llListFindList(InventoryList, [gSoundRev]);
    if((index == -1) && (llStringLength(gSoundRev) != 36)) { gSoundRev=""; } else if(gSoundRev != "") { llPreloadSound(gSoundRev); }
    index = llListFindList(InventoryList, [gSoundAlarm]);
    if((index == -1) && (llStringLength(gSoundAlarm) != 36)) { gSoundAlarm=""; } else if(gSoundAlarm != "") { llPreloadSound(gSoundAlarm); }
    index = llListFindList(InventoryList, [gSoundStop]);
    if((index == -1) && (llStringLength(gSoundStop) != 36)) { gSoundStop=""; } else if(gSoundStop != "") { llPreloadSound(gSoundStop); }
}

init_followCam(){
    if(llGetPermissions() & PERMISSION_CONTROL_CAMERA) {
        llSetCameraParams([
                       CAMERA_ACTIVE, 1,                 // 0=INACTIVE  1=ACTIVE
                       CAMERA_BEHINDNESS_ANGLE, 2.0,     // (0 to 180) DEGREES
                       CAMERA_BEHINDNESS_LAG, 0.01,       // (0 to 3) SECONDS
                       CAMERA_DISTANCE, CamDist,             // ( 0.5 to 10) METERS
                       CAMERA_PITCH, CamPitch,                // (-45 to 80) DEGREES
                       CAMERA_POSITION_LOCKED, FALSE,    // (TRUE or FALSE)
                       CAMERA_POSITION_LAG, 0.000,         // (0 to 3) SECONDS
                       CAMERA_POSITION_THRESHOLD, 8.0,   // (0 to 4) METERS
                       CAMERA_FOCUS_LOCKED, FALSE,       // (TRUE or FALSE)
                       CAMERA_FOCUS_LAG, 0.00 ,           // (0 to 3) SECONDS
                       CAMERA_FOCUS_THRESHOLD, 8.0,      // (0 to 4) METERS
                       CAMERA_FOCUS_OFFSET, <lookAhead,0,0>   // <-10,-10,-10> to <10,10,10> METERS
                      ]);
    }
}

set_engine(){
    if(llGetListLength(prims_keep_prim) ==0) {
        llSetLinkPrimitiveParamsFast(LINK_ALL_CHILDREN, [PRIM_PHYSICS_SHAPE_TYPE, PRIM_PHYSICS_SHAPE_NONE]);
    } else {
        for(i=2; i<= llGetObjectPrimCount(llGetKey()); i++) {
            if(llListFindList( prims_keep_prim, [ i ] ) == -1) {
                llSetLinkPrimitiveParamsFast(i, [PRIM_PHYSICS_SHAPE_TYPE, PRIM_PHYSICS_SHAPE_NONE]);
            }
        }
    }
    
    llSetVehicleType(VEHICLE_TYPE_CAR);
    llSetVehicleRotationParam(VEHICLE_REFERENCE_FRAME, <0.00000, 0.00000, 0.00000, 0.00000>); // rev 1.1 per Vegaslon's comment
    llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, 1.0); // how fast to reach max speed
    llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 0.10); // how fast to reach min speed or zero
    llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <1.0, 2.0, 8.0>);
    llSetVehicleVectorParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, <10, 10000,0.10> ); // XYZ angular friction  // Was <0.10,0.10,0.10>
    llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_TIMESCALE, gVAMT); // how fast turning force is applied 
    llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 0.20); // how fast turning force is released
    llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 0.80); // adjusted on 0.7.6
    llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 0.10);
    llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 0.20);
    llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 0.10);
    llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 0.25); // 0.50
    llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 1.0);   // 5.0
    llSetVehicleFloatParam(VEHICLE_HOVER_EFFICIENCY, 0 );
    llSetVehicleFloatParam(VEHICLE_HOVER_TIMESCALE, 0 );
    llSetVehicleFloatParam(VEHICLE_HOVER_HEIGHT, 0 );
    llSetVehicleFloatParam(VEHICLE_BUOYANCY, 0 );

    llRemoveVehicleFlags(VEHICLE_FLAG_HOVER_WATER_ONLY | VEHICLE_FLAG_HOVER_TERRAIN_ONLY | VEHICLE_FLAG_HOVER_GLOBAL_HEIGHT);      
    llRemoveVehicleFlags(VEHICLE_FLAG_HOVER_GLOBAL_HEIGHT);      
    llSetVehicleFlags(VEHICLE_FLAG_NO_DEFLECTION_UP | VEHICLE_FLAG_LIMIT_ROLL_ONLY | VEHICLE_FLAG_HOVER_UP_ONLY |
        VEHICLE_FLAG_LIMIT_MOTOR_UP); 
            
    if(gSoundStartup!="") { llTriggerSound(gSoundStartup,1.0); }
    llSetStatus(STATUS_PHYSICS, TRUE); 
    gRun = 1;
    gMoving=0;
    llSleep(2);
    enginesound();
}

gearshift(integer g){
    enginesound();
    llRegionSayTo(driver,0,llList2String(gGearNameList, g));
    llMessageLinked(LINK_SET, 0, "gear " + (string)(g+1), NULL_KEY);
}

enginesound(){
    if (gMoving==0) {
        if((gSoundIdle != "") && (currSound != gSoundIdle)) {
            llStopSound();
            llLoopSound(gSoundIdle,1.0);
            currSound = gSoundIdle;
        }
    } else if (reverse) {
        if((gSoundRev != "") && (currSound != gSoundRev)) {
            llStopSound();
            llLoopSound(gSoundRev,1.0);
            currSound = gSoundRev;
        }
    } else if ((gSoundAggressive != "") && (gGear >= aggressive_gear) && (gSoundSlow != gSoundAggressive)) {
        if(currSound != gSoundAggressive) {
            llStopSound();
            llLoopSound(gSoundAggressive,1.0);
            currSound = gSoundAggressive;
        }
    } else {
        if((gSoundSlow != "") && (currSound != gSoundSlow)) {
            llStopSound();
            llLoopSound(gSoundSlow,1.0);
            currSound = gSoundSlow;
        }
    }
}

config_init() {
    llOwnerSay("Initializing Supercar script, please wait...");
    llOwnerSay("   Reading wheel settings and child prims physics types..");
    prim_phys_types = [ ];
    primcount = llGetObjectPrimCount(llGetKey());
    for(i=2; i<= primcount; i++) { 
        list params = llGetLinkPrimitiveParams(i,[PRIM_PHYSICS_SHAPE_TYPE, PRIM_DESC, PRIM_NAME]);
        integer ptype = llList2Integer(params, 0);
        prim_phys_types += ptype;
        if(llList2String(params, 1) == "prim") {
            prims_keep_prim += i;
        }
        string primname = llList2String(params, 2);
        if(((llSubStringIndex(primname, "rwheel")!=-1) || (llSubStringIndex(primname, "fwheel")!=-1)) && (llList2String(params, 1) != "") && (llList2String(params, 1) != "(No Description)"))  {
            list veclist = llParseStringKeepNulls(llList2String(params, 1), ["<",">"], []);
            if(llList2String(veclist, 1) != "") {
                wheels += i;
                wheelvec += (vector)llList2String(params, 1);
                if(llSubStringIndex(primname, "fwheel")!=-1) { fwlocalrot += llList2Rot(llGetLinkPrimitiveParams(i, [PRIM_ROT_LOCAL]), 0); }
                else { fwlocalrot += (integer)0; }
            }
        }
    }
    llCollisionSound("", 0.0);
    preload_sounds();
    init_PhysEng();
    llOwnerSay("Initialization complete, ready to drive.");
}

setConfig(string setting, string qval) { 
    if(setting=="gDrivePermit") { gDrivePermit = (integer)qval; }
    else if(setting=="driverList") { 
        if(qval!="") { driverList = llParseString2List(qval,[","],[""]); }
    }
    else if(setting=="gSitMessage") { gSitMessage = qval; }
    else if(setting=="gUrNotAllowedMessage") { gUrNotAllowedMessage = qval; }
    else if(setting=="maxGear") { maxGear = (integer)qval; }
    else if(setting=="startGear") { startGear = (integer)qval; }
    else if(setting=="fallbackAbove") { fallbackAbove = (integer)qval; }
    else if(setting=="turn_in_place_speed") { turn_in_place_speed = (float)qval; }
    else if((setting=="turnList")  && (qval!="")) {
        list oldturnList = turnList;
        turnList = llParseString2List(qval,[","],[""]);
        for(i=0; i<llGetListLength(turnList); i++) {
            turnList = llListReplaceList(turnList, [(float)llList2String(turnList,i)], i, i);
        }
        if(llGetListLength(turnList)<llGetListLength(oldturnList)) {
            turnList += llList2List(oldturnList, llGetListLength(turnList), -1);
        }
    }
    else if((setting=="speedList") && (qval!="")) {
        list oldspeedList = speedList;
        speedList = llParseString2List(qval,[","],[""]);
        for(i=0; i<llGetListLength(speedList); i++) {
            speedList = llListReplaceList(speedList, [(integer)llList2String(speedList,i)], i, i);
        }
        if(llGetListLength(speedList)<llGetListLength(oldspeedList)) {
            speedList += llList2List(oldspeedList, llGetListLength(speedList), -1);
        }
    }
    else if(setting=="tilt_push") { tilt_push = (float)qval; }
    else if(setting=="enableCamera") { if(qval=="TRUE") { enableCamera=TRUE; } else { enableCamera=FALSE; } }
    else if(setting=="CamDist") { CamDist = (float)qval; }
    else if(setting=="CamPitch") { CamPitch = (float)qval; }
    else if(setting=="lookAhead") { lookAhead = (float)qval; }
    else if(setting=="click_to_pause") { if(qval=="TRUE") { click_to_pause=TRUE; } else { click_to_pause=FALSE; } }
    else if(setting=="sit_message") { sit_message = qval; }
    else if(setting=="aggressive_gear") { aggressive_gear = (integer)qval; }
    else if(setting=="gSoundStartup") { gSoundStartup = qval; }
    else if(setting=="gSoundIdle") { gSoundIdle = qval; }
    else if(setting=="gSoundSlow") { gSoundSlow = qval; }
    else if(setting=="gSoundAggressive") { gSoundAggressive = qval; }
    else if(setting=="gSoundRev") { gSoundRev = qval; }
    else if(setting=="gSoundStop") { gSoundStop = qval; }
    else if(setting=="gSoundAlarm") { gSoundAlarm = qval; }
    
}

finish() {
    llOwnerSay("   Reading wheel settings and child prims physics types..");
    prim_phys_types = [ ];
    primcount = llGetObjectPrimCount(llGetKey());
    for(i=2; i<= primcount; i++) { 
        list params = llGetLinkPrimitiveParams(i,[PRIM_PHYSICS_SHAPE_TYPE, PRIM_DESC, PRIM_NAME]);
        integer ptype = llList2Integer(params, 0);
        prim_phys_types += ptype;
        if(llList2String(params, 1) == "prim") {
            prims_keep_prim += i;
        }
        string primname = llList2String(params, 2);
        if(((llSubStringIndex(primname, "rwheel")!=-1) || (llSubStringIndex(primname, "fwheel")!=-1)) && (llList2String(params, 1) != "") && (llList2String(params, 1) != "(No Description)"))  {
            list veclist = llParseStringKeepNulls(llList2String(params, 1), ["<",">"], []);
            if(llList2String(veclist, 1) != "") {
                wheels += i;
                wheelvec += (vector)llList2String(params, 1);
                if(llSubStringIndex(primname, "fwheel")!=-1) { fwlocalrot += llList2Rot(llGetLinkPrimitiveParams(i, [PRIM_ROT_LOCAL]), 0); }
                else { fwlocalrot += (integer)0; }
            }
        }
    }
    turnwheels("NoTurn");
    list ls = llGetLinkPrimitiveParams(LINK_THIS, [PRIM_SIT_TARGET]);
    if(llList2Vector(ls, 1)==ZERO_VECTOR) {
        llSitTarget(<0,0,0.5>, ZERO_ROTATION); // an arbitrary but reasonable value until the offset is fine-tuned
    }
    
    llOwnerSay("   Preloading sounds.."); 
    preload_sounds();
    init_PhysEng();
    //llOwnerSay("   Free memory: " + (string)(llGetFreeMemory()) + " bytes"); 
    llOwnerSay("Initialization complete, ready to drive.");
}

spinwheels(float power, string Spin) {
    float rate;
    rotation rotlocal;
    if (Spin == "ForwardSpin") { rate = 1.32 * power; }
    else if (Spin == "BackwardSpin") { rate = -1.32 * power; }
    else if (Spin == "NoSpin") { rate = 0; }
    for(i=0; i<llGetListLength(wheels); i++) {
        rotlocal = llList2Rot(llGetLinkPrimitiveParams(llList2Integer(wheels, i), [PRIM_ROT_LOCAL]), 0);
        llSetLinkPrimitiveParamsFast(llList2Integer(wheels, i), [PRIM_OMEGA, llList2Vector(wheelvec, i) * rotlocal, rate, 1.0]);
    }
    spinstate = rate;
}

turnwheels(string turn) {
    rotation rotlocal;
    for(i=0; i<llGetListLength(wheels); i++) {
        if(llList2String(fwlocalrot, i) != "0") {
            list params = llGetLinkPrimitiveParams(llList2Integer(wheels, i), [PRIM_ROT_LOCAL, PRIM_NAME]);
            rotlocal = llList2Rot(params, 0);
            rotation newrot;
            integer reverse = FALSE;
            if(llSubStringIndex(llList2String(params, 1), "reverse")!=-1) { reverse = TRUE; }
                if( ((turn == "LeftTurn") && !reverse) || ((turn == "RightTurn") && reverse) ) {
                    newrot = llList2Rot(fwlocalrot, i) * (llEuler2Rot(<0,0,30>*DEG_TO_RAD)); }
                else if( ((turn == "RightTurn") && !reverse) || ((turn == "LeftTurn") && reverse) ) {
                    newrot = llList2Rot(fwlocalrot, i) * (llEuler2Rot(<0,0,-30>*DEG_TO_RAD)); }
                else if (turn == "NoTurn") { newrot = llList2Rot(fwlocalrot, i); }
            llSetLinkPrimitiveParamsFast(llList2Integer(wheels, i), [ PRIM_OMEGA, llList2Vector(wheelvec, i) * rotlocal, 0, 1.0,
                                                                      PRIM_ROT_LOCAL, newrot,
                                                                      PRIM_OMEGA, llList2Vector(wheelvec, i) * newrot, spinstate, 1.0 ]);
        }
    }
}

wheelcalc() {
    wheels = [];
    wheelvec = [];
    fwlocalrot = [];
    
    for(i=2; i<= primcount; i++) {
        list params = llGetLinkPrimitiveParams(i,[PRIM_DESC, PRIM_NAME]);
        string primname = llList2String(params, 1);
        if(((llSubStringIndex(primname, "rwheel")!=-1) || (llSubStringIndex(primname, "fwheel")!=-1)) && (llList2String(params, 0) != "") && (llList2String(params, 0) != "(No Description)"))  {
            list veclist = llParseStringKeepNulls(llList2String(params, 0), ["<",">"], []);
            if(llList2String(veclist, 1) != "") {
                wheels += i;
                wheelvec += (vector)llList2String(params, 0);
                if(llSubStringIndex(primname, "fwheel")!=-1) { fwlocalrot += llList2Rot(llGetLinkPrimitiveParams(i, [PRIM_ROT_LOCAL]), 0); }
                else { fwlocalrot += (integer)0; }
            }
        }
    }
}

drivecar() {
    gGear = startGear;
    set_engine();
    llMessageLinked(LINK_SET, 0, "car_start", NULL_KEY);
    llMessageLinked(LINK_SET, 0, "gear " + (string)(startGear + 1), NULL_KEY);
    llSetSitText("Sit");
    seated = TRUE;
    if(sit_message !="") { llRegionSayTo(driver,0,sit_message); }
    if(parked) { llRegionSayTo(driver,0, "Driving resumed."); }
    parked = FALSE;
}

reset_car() {
    seated = FALSE;
    gRun = 0;
    turnwheels("NoTurn");
    spinwheels(0, "NoSpin");
    currSound = "";
    gTireSpin = "NoSpin";
    gTurnAngle = "NoTurn";
    llMessageLinked(LINK_ALL_OTHERS, 0, gTireSpin, NULL_KEY);      // NO SPIN
    llMessageLinked(LINK_ALL_OTHERS, 0, gTurnAngle, NULL_KEY);     // NO TURN
    llSetSitText(gSitMessage);
    llMessageLinked(LINK_SET, 0, "honkoff", NULL_KEY);
    llMessageLinked(LINK_SET, 0, "car_stop", NULL_KEY);
    llSetStatus(STATUS_PHYSICS, FALSE); 
    for(i=2; i<= llGetObjectPrimCount(llGetKey()); i++) {
        list params = llGetLinkPrimitiveParams(i,[PRIM_PHYSICS_SHAPE_TYPE]);
        if(llList2Integer(prim_phys_types, i-2) != llList2Integer(params, 0)) {
            llSetLinkPrimitiveParamsFast(i,[ PRIM_PHYSICS_SHAPE_TYPE,llList2Integer(prim_phys_types, i-2) ] );
        }
    }
    llListenRemove(menu_handler);
    llStopSound();
}

default {
    state_entry() {
        config_init();
        
        reset_car();
        
        list l = llGetLinkPrimitiveParams(LINK_THIS, [PRIM_SIT_TARGET]);
        if(llList2Vector(l, 1)==ZERO_VECTOR) {
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_SIT_TARGET, TRUE,  <0, 0, 0.5>, ZERO_ROTATION ]);
        }
        
        llMessageLinked(LINK_THIS, 0, "readConfig", NULL_KEY);
        
        state Idle;
    }
    
    link_message(integer Sender, integer Number, string msg, key Key) {
        if(Number == 999) {
            list tmp = llParseString2List(msg, ["="], []);
            setConfig(llList2String(tmp,0), llList2String(tmp,1));
        }
    }

}

state Idle {
    state_entry() {
        currSound = "";
        llSetSitText(gSitMessage);
        //llOwnerSay("Free memory: " + (string)llGetFreeMemory());
    }

    on_rez(integer param) {

    }
    
    changed(integer change) {     
        if (change & CHANGED_LINK) {
            if((llGetObjectPrimCount(llGetKey()) != primcount) && (! seated)) { // adding or removing a prim
                llOwnerSay("** Prim count changed, resetting **");
                llResetScript();
            }
            
            driver = llAvatarOnLinkSitTarget(LINK_THIS);
            if ((driver != NULL_KEY) && (! seated)) { // happens once
                
                if((gDrivePermit == 0) || ((gDrivePermit == 1) && (driver == llGetOwner())) || ((gDrivePermit == 2) && (llSameGroup(driver)==TRUE))
                    || (llListFindList( driverList, [(string)driver] ) != -1)) { 
                    state Driving;
                    
                }
                else {
                    llRegionSayTo(driver,0, gUrNotAllowedMessage);
                    llUnSit(driver);
                    if(gSoundAlarm !="") { llPlaySound(gSoundAlarm,1.0); }
                    
                }
            }
        }
        
        if (change & CHANGED_INVENTORY) { // possible Config NC change
            llOwnerSay("** Inventory change detected, resetting **");
            llResetScript();
        }
    }
    
    link_message(integer Sender, integer Number, string msg, key Key) {
        if(Number == 999) {
            list tmp = llParseString2List(msg, ["="], []);
            setConfig(llList2String(tmp,0), llList2String(tmp,1));
            if(llSubStringIndex(llList2String(tmp,0), "Sound") !=-1) { do_preload = TRUE; }
        } else if(Number == 1000) {
            if(do_preload) {
                llOwnerSay("Preloading sounds..");
                preload_sounds();
                llOwnerSay("Preloading complete");
                do_preload = FALSE; 
            }
        }
    }

}

state Driving {

    state_entry() {
        llRequestPermissions(driver,  PERMISSION_TAKE_CONTROLS | PERMISSION_CONTROL_CAMERA | PERMISSION_TRIGGER_ANIMATION ); 
        
        if((llGetPermissions() & PERMISSION_TRIGGER_ANIMATION) && (llGetInventoryNumber(INVENTORY_ANIMATION) == 1)) {
            llStopAnimation("sit");
            llStartAnimation(llGetInventoryName(INVENTORY_ANIMATION, 0));
        }
        
        llSetSitText("Sit as Passenger");
        llListenRemove(menu_handler); 
        
        drivecar();
    }
    
    on_rez(integer param) {
        reset_car();
        state Idle;
    }
    
    touch_start(integer total_number) { 
        if(click_to_pause && (llDetectedKey(0) == driver)) { 
            menu(driver,"\nPause your car or resume driving?",["Pause Car", "Drive"]); 
        } 
    } 
    
    changed(integer change) {     
        if (change & CHANGED_LINK) {
            if(llGetObjectPrimCount(llGetKey()) != primcount) { // adding or removing a prim
                llOwnerSay("** Prim count changed, resetting **");
                llResetScript();
            }
            
            driver = llAvatarOnLinkSitTarget(LINK_THIS);
            if ((driver == NULL_KEY) && seated) { // If driver stood up 
                llReleaseControls(); 
                reset_car();
                if(gSoundStop!="") { llTriggerSound(gSoundStop,1); }
                                
                state Idle;

            } // end - no driver
            
            else if(driver !=NULL_KEY) { // someone sat or stood on another prim
                llRequestPermissions(driver,  PERMISSION_TAKE_CONTROLS | PERMISSION_CONTROL_CAMERA | PERMISSION_TRIGGER_ANIMATION );
                if( (llGetPermissions() & PERMISSION_CONTROL_CAMERA) && (enableCamera) ) {
                    init_followCam();
                }
            }    
        }// end changed link
        
        else if (change & CHANGED_REGION) {
            llRequestPermissions(driver,  PERMISSION_TAKE_CONTROLS | PERMISSION_CONTROL_CAMERA | PERMISSION_TRIGGER_ANIMATION );
            if( (llGetPermissions() & PERMISSION_CONTROL_CAMERA) && (enableCamera) ) {
                init_followCam();
            }
        }
    }
    
    run_time_permissions(integer perm) {
        if(perm & PERMISSION_TAKE_CONTROLS){
            llTakeControls(
                CONTROL_FWD | CONTROL_BACK  | CONTROL_DOWN |
                CONTROL_UP  | CONTROL_RIGHT | CONTROL_LEFT |
                CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT, TRUE, FALSE);            
        }
         
        if((perm & PERMISSION_CONTROL_CAMERA) && (enableCamera)) {
            init_followCam();
        }
    }

    control(key id, integer held, integer change) {
        if(gRun == 0){
            return;
        }
        reverse=0;
        gTurnRatio = llList2Float(turnList,gGear);
        gGearPower = llList2Integer(speedList, gGear);

        if (held & change & CONTROL_UP){
            if(gGear < maxGear) {
                gGear=gGear+1;
                gearshift(gGear); 
                llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, gVLFT);
            }
        }

        if (held & change & CONTROL_DOWN) {
            if(gGear > 0) {
                gGear=gGear-1;
                gearshift(gGear); 
                if(gGear == 0) {
                    llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <1.0, 2.0, 8.0>);
                } else {
                    llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, gVLFT);
                }
            }
            
        }
        if (held & CONTROL_FWD){
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <gGearPower,0,0>);
            gMoving=1;
            gNewTireSpin = "ForwardSpin";
            
        }

        if (held & CONTROL_BACK) {
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <-1 * gGearPower,0,0>);
            llSetCameraParams([CAMERA_FOCUS_THRESHOLD, 0.1, CAMERA_POSITION_THRESHOLD, 0.1, CAMERA_FOCUS_OFFSET, <0,0,0>]);
            gTurnRatio = -2.0;
            reverse = 1;
            gNewTireSpin = "BackwardSpin";
            gMoving = 1;
        }
        
        if(! ((held & CONTROL_BACK) || (held & CONTROL_FWD))) { gMoving = 0;}
        
        if (~held & change & CONTROL_FWD) {
            //  Released FWD button   
            gNewTireSpin = "NoSpin";
            gNewTurnAngle = "NoTurn";
            
            if (gGear > fallbackAbove) {
                gGear = fallbackAbove;
                llRegionSayTo(driver,0,"Fallback to " + llList2String(gGearNameList, gGear));
                llMessageLinked(LINK_SET, 0, "gear " + (string)(gGear+1), NULL_KEY);
            }
            
        }
        if (~held & change & CONTROL_BACK) {
            //  Released BACK button          
            gNewTireSpin = "NoSpin";
            gNewTurnAngle = "NoTurn";
            
            llSetCameraParams([CAMERA_FOCUS_THRESHOLD,8.0, CAMERA_POSITION_THRESHOLD, 8.0, CAMERA_FOCUS_OFFSET, <lookAhead,0,0> ]);
        }
                
        enginesound();
 
        vector AngularMotor;
        if (held & (CONTROL_RIGHT|CONTROL_ROT_RIGHT)) {
            if(gMoving==0) {
                if(turn_in_place_speed !=0) { AngularMotor.z -= PI*turn_in_place_speed; }
            } else if (gGear==0) {
                AngularMotor.z -= (gGearPower * 2.0) / ((gTurnRatio/gTurnMulti)*1);
            } else {
                AngularMotor.z -= (gGearPower * 2.0) / ((gTurnRatio/gTurnMulti)*gGear);
            }
            if(tilt_push!=0) { AngularMotor.x = tilt_push; }
            gNewTurnAngle = "RightTurn";
        }

        if (held & (CONTROL_LEFT|CONTROL_ROT_LEFT)) {
            if(gMoving==0) {
                if(turn_in_place_speed !=0) { AngularMotor.z += PI*turn_in_place_speed; }
            } else if (gGear==0) {
                AngularMotor.z += (gGearPower * 2.0)/ ((gTurnRatio/gTurnMulti)*1);
            } else {
                AngularMotor.z += (gGearPower * 2.0) / ((gTurnRatio/gTurnMulti)*gGear);
            }
            if(tilt_push!=0) { AngularMotor.x = -tilt_push; }
            gNewTurnAngle = "LeftTurn";
        }
        
        if ((~held & change & CONTROL_LEFT) || (~held & change & CONTROL_ROT_LEFT) ||
            (~held & change & CONTROL_RIGHT) || (~held & change & CONTROL_ROT_RIGHT))  {
            gNewTurnAngle = "NoTurn";
        }

        llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, AngularMotor);
            
        if(gTurnAngle != gNewTurnAngle) {
            gTurnAngle = gNewTurnAngle;
            if(llGetListLength(wheelvec)>0) { turnwheels(gTurnAngle); }
            llMessageLinked(LINK_SET, 0, gTurnAngle, NULL_KEY);
        }
        if((gTireSpin != gNewTireSpin) || ((gGearPower>20) && (sentPower !=20)) || ((sentPower != llRound(gGearPower)))) {
            gTireSpin = gNewTireSpin;
            if(gGearPower<20) { sentPower =  llRound(gGearPower);}
            else { sentPower=20;} // cap wheel spin due to frame rate
            if(llGetListLength(wheelvec)>0) { spinwheels(sentPower, gTireSpin); }
            llMessageLinked(LINK_SET, sentPower, gTireSpin, NULL_KEY);  
            
        }
    }
    
    link_message(integer Sender, integer Number, string msg, key Key) {
        if(msg == "gear_up") {
            gGear=gGear+1;
            if (gGear > maxGear) { gGear = maxGear; }
            else { gearshift(gGear); }
        } else if(msg == "gear_down") {
            gGear=gGear-1;
            if (gGear < 0) { gGear = 0; }
            else { gearshift(gGear); }
        } else if(msg == "wheelcalc") {
            wheelcalc();
        } else if(Number == 999) {
            list tmp = llParseString2List(msg, ["="], []);
            setConfig(llList2String(tmp,0), llList2String(tmp,1));
            if(llSubStringIndex(llList2String(tmp,0), "Sound") !=-1) { do_preload = TRUE; }
        } else if(Number == 1000) {
            if(do_preload) {
                llOwnerSay("Preloading sounds..");
                preload_sounds();
                llOwnerSay("Preloading complete");
                do_preload = FALSE; 
            }
        }
    }
    
    listen(integer channel, string name, key av, string message) {
        if (channel == menu_channel) {
            llSetTimerEvent(0.0); 
            llListenRemove(menu_handler); 
            if((message == "Pause Car") && (gRun==1))  { 
                llSetStatus(STATUS_PHYSICS, FALSE);
                for(i=2; i<= llGetObjectPrimCount(llGetKey()); i++) {
                    list params = llGetLinkPrimitiveParams(i,[PRIM_PHYSICS_SHAPE_TYPE]);
                    if(llList2Integer(prim_phys_types, i-2) != llList2Integer(params, 0)) {
                        llSetLinkPrimitiveParamsFast(i,[ PRIM_PHYSICS_SHAPE_TYPE,llList2Integer(prim_phys_types, i-2) ] );
                    }
                }               
                gRun = 0;
                gMoving = 0;
                parked = TRUE;
                llStopSound();
                llMessageLinked(LINK_SET, 0, "car_stop", NULL_KEY);
                if(gSoundStop!="") { llStopSound(); llTriggerSound(gSoundStop,1); }
                llRegionSayTo(driver, 0, "Car paused. Auto-Park disabled. Touch again to resume driving.");
            } 
            else if((message == "Drive") && (gRun==0)) { 
                if(llGetListLength(prims_keep_prim) ==0) {
                    llSetLinkPrimitiveParamsFast(LINK_ALL_CHILDREN, [PRIM_PHYSICS_SHAPE_TYPE, PRIM_PHYSICS_SHAPE_NONE]);
                } else {
                    for(i=2; i<= llGetObjectPrimCount(llGetKey()); i++) {
                        if(llListFindList( prims_keep_prim, [ i ] ) == -1) {
                            llSetLinkPrimitiveParamsFast(i, [PRIM_PHYSICS_SHAPE_TYPE, PRIM_PHYSICS_SHAPE_NONE]);
                        }
                    }
                }
                llSetStatus(STATUS_PHYSICS, TRUE);                  
                gRun = 1;
                parked=FALSE;
                llStopSound();
                llMessageLinked(LINK_SET, 0, "car_start", NULL_KEY);
                if(gSoundStartup!="") { llStopSound(); llTriggerSound(gSoundStartup,1); }
                llSleep(1.5);
                enginesound();
                llRegionSayTo(driver, 0, "Driving resumed.");
            } 
        }
    }

}

// END



