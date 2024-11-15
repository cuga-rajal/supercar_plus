// Supercar 2.1.0

// By Cuga Rajal <cuga@rajal.org>
// Latest version and more information at https://github.com/cuga-rajal/supercar_plus/ 
// This work is licensed under the Creative Commons BY 4.0 License: https://creativecommons.org/licenses/by/4.0/
 
//---USER-DEFINED VARIABLES--------------------------------------------------
// * NOTE * A Config notecard placed in the same prim as this script will override settings listed below.
// * Please see the sample Config notecard. This is the recommended method.
// * This allows future script updates to be drop-in replacements without the need to hand-edit settings.
 
// Driver permissions and sit offsets 
integer         gDrivePermit = 0; // Who is allowed to drive car: 0=everyone, 1=owner only, 2=group member
list            driverList = [ ]; // list of UUIDs allowed to drive (whitelist), comma delimited, no spaces
string          gSitMessage = "Drive";  // Appears in the pie menu
string          gUrNotAllowedMessage = "Vehicle is Locked";  // Message to chat window if not allowed

// Gear options -- NOTE: 0=first gear, 11=12th gear
integer         maxGear = 3;       // highest gear that can be shifted to, max 11
integer         lowestGear = 0;     // lowest gear that can be shifted to, min 0
integer         startGear = 0;      // gear selected on sit 
integer         fallbackAbove = 6;  // releasing forward button when gear higher than this falls back to this
float           turn_in_place_speed = 2; // Rotation speed if rotating in place. Set to 0 to disable.
list            turnList = [ ]; // Empty list uses default values; Override defaults with this list 
list            speedList = [ ]; // Empty list uses default values; Override defaults with this list 
 
// Camera options
integer         enableCamera = TRUE;  // Whether or not to enable camera controls
float           CamDist = 12; // How far back you want the camera positioned
float           CamPitch = 20.0;  // Angle looking down. Range is -45 to 80 Degrees
float           lookAhead = 6.0;  // How far in front of avatar to focus camera. Range is -10 to 10 meters
                
// Other options
integer         auto_park_time = 300;  // Delay before auto-return in seconds. Set to 0 to disable.
integer         click_to_pause = FALSE; // If TRUE will allow driver to click vehicle to toggle engine and lights
string          sit_message = ""; // Chat window message shown to driver when sitting
string          stand_message = ""; // Chat window message shown to driver when standing

// Sound variables
integer         aggressive_gear = 3; // This gear and above play "gSoundAggressive", below this gear plays "gSoundSlow"
integer         use_sl_sounds = FALSE;  // Whether to use free car sounds in SL. If set to TRUE this overrides sounds below.
string          gSoundStartup = ""; // sound made when driver seated
string          gSoundIdle = "";  // looped sound when not moving
string          gSoundSlow = "";   // looped sound when driving forward and gear below aggresive_gear
string          gSoundAggressive = "";  // looped sound when driving forward and gear at or above aggresive_gear
string          gSoundRev = "";  // looped sound when driving in reverse
string          gSoundStop = "";   // sound when the driver stands
string          gSoundAlarm = "";   // sound if someone not authorized tries to drive car

// Simulator selection

string          notecard_name = "Config";


//---INTERNAL VARIABLES--------------------------------------------------

vector          startposition;
rotation        startrot;
list            prim_phys_types = [ ];
list            prims_keep_prim = [ ];
integer         i;
integer         primcount;
integer         is_resetting = TRUE;
integer         listener;
key             driver = NULL_KEY;
key             prevDriver = NULL_KEY;
integer         gRun;     //ENGINE RUNNING
integer         gMoving;  //VEHICLE MOVING
integer         sentPower;
integer         seated = FALSE;
integer            parked = FALSE;
integer            dialogwait = FALSE;

integer         gOldSound=3;   //variable for sound function
integer         gNewSound=3;
integer         reverse;
list            wheels;
list            wheelvec;
list            fwlocalrot;
float           spinstate;

list            gTSvarList;
float           gVLMT=1.0;               // how fast to reach max speed
float           gVLMDT=0.10;               // how fast to reach min speed or zero
vector          gVLFT=<8.0,3000.0,8.0>;   // XYZ linear friction
vector          gVAFT=<10000, 10000,0.10>;   // XYZ angular friction  // Was <0.10,0.10,0.10>
float           gVAMT=0.35;              // how fast turning force is applied 
float           gVAMDT=0.20;               // how fast turning force is released
float           gVLDE=0.80;                // adjusted on 0.7.6
float           gVLDT=0.10;
float           gVADE=0.20;
float           gVADT=0.10;
float           gVVAE=0.50;
float           gVVAT=5.0;
float           gVHE=0;
float           gVHT=0;
float           gVHH=0;
float           gVB=0;
 
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

key kQuery = NULL_KEY;
integer iLine = 0;
key notecard_key = NULL_KEY;

integer menu_handler; 
integer menu_channel;

menu(key user,string title,list object_list)  { 
    menu_channel = (integer)(llFrand(99999.0) * -1); //random channel 
    menu_handler = llListen(menu_channel,"","",""); 
    llDialog(user,title,object_list,menu_channel); 
    llSetTimerEvent(30.0); //menu channel open for 30 seconds 
    dialogwait = TRUE;
} 

init_PhysEng(){
    if(llSubStringIndex(llGetEnv("sim_channel"), "Second Life") !=-1) { // SL/Havok
        gTurnMulti=2;
        llOwnerSay("   Tuned for SL/Havok");
    } else {  // Opensim/Bullet/ODE
        gTurnMulti=0.987654;
        gVAMT=0.50; // adjustment for turn speed
        llOwnerSay("   Tuned for Opensim");
    }
    
    list newturnList        = [   3,    //1st Gear
                                    3.5,    //2nd Gear
                                    3.5,    //3rd Gear
                                    3.5,    //4th Gear
                                    3.5,    //5th Gear
                                    4.0,    //6th Gear
                                    4.1,    //7th Gear
                                    4.5,    //8th Gear
                                    10.0,   //9th Gear
                                    10.0,   //10th Gear
                                    10.0,   //11th Gear
                                    10.0    //12th Gear
                                ];
                                
    if(llGetListLength(turnList)==0) {
        turnList = newturnList;
    } else {
        turnList = llListReplaceList(newturnList, turnList, 0, llGetListLength(turnList)-1);
    }
    
    list newspeedList         = [   4,    //1st Gear
                                    8,    //2nd Gear
                                    16,    //3rd Gear
                                    32,    //4th Gear
                                    56,    //5th Gear
                                    80,    //6th Gear
                                    100,    //7th Gear
                                    130,    //8th Gear
                                    156,    //9th Gear
                                    185,    //10th Gear
                                    210,    //11th Gear
                                    256     //12th Gear
                                ];
                                
    if(llGetListLength(speedList)==0) {
        speedList = newspeedList;
    } else {
        speedList = llListReplaceList(newspeedList, speedList, 0, llGetListLength(speedList)-1);
    }

}

preload_sounds(){
    if(use_sl_sounds) {
        gSoundStartup =         "84d98fd0-937f-95e9-9b71-4fdd8ba3b757";
        gSoundIdle =            "5e5bb630-40f2-582a-c49e-56fd3bb9d68d";
        gSoundSlow =            "bdf52fa2-3fcc-5852-0061-b9e4d17ec833";
        gSoundAggressive =      "bdf52fa2-3fcc-5852-0061-b9e4d17ec833";
        gSoundRev =             "66a5db06-4078-de3b-d532-ae3deaec52b8";
        gSoundStop =            "66a5db06-4078-de3b-d532-ae3deaec52b8";
    } else {
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
}

init_engine(){
    gRun = 0;
    llSetSitText(gSitMessage);
    llCollisionSound("", 0.0);
    gOldSound=3; 
    gNewSound=3;
    gTireSpin = "NoSpin";
    gTurnAngle = "NoTurn";

    llMessageLinked(LINK_ALL_OTHERS, 0, gTireSpin, NULL_KEY);      // NO SPIN
    llMessageLinked(LINK_ALL_OTHERS, 0, gTurnAngle, NULL_KEY);     // NO TURN

}

init_followCam(){
    // Set camera for driver only
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
    
    integer vfW = VEHICLE_FLAG_HOVER_WATER_ONLY | VEHICLE_FLAG_HOVER_TERRAIN_ONLY | VEHICLE_FLAG_HOVER_GLOBAL_HEIGHT;
    integer vfG = VEHICLE_FLAG_NO_DEFLECTION_UP | VEHICLE_FLAG_LIMIT_ROLL_ONLY | VEHICLE_FLAG_HOVER_UP_ONLY |
        VEHICLE_FLAG_LIMIT_MOTOR_UP;
    integer vfA = VEHICLE_FLAG_HOVER_GLOBAL_HEIGHT;
    llSetVehicleType(VEHICLE_TYPE_CAR);
    llSetVehicleRotationParam(VEHICLE_REFERENCE_FRAME, <0.00000, 0.00000, 0.00000, 0.00000>); // rev 1.1 per Vegaslon's comment
    llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, gVLMT);
    llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, gVLMDT);
    if(gGear == 0) {
        llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <1.0, 2.0, 8.0>);
    } else {
        llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, gVLFT);
    }
    llSetVehicleVectorParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, gVAFT );
    llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_TIMESCALE, gVAMT);
    llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, gVAMDT);
    llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, gVLDE);
    llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_TIMESCALE, gVLDT);
    llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, gVADE);
    llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, gVADT);
    llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, gVVAE);
    llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, gVVAT);
    llSetVehicleFloatParam(VEHICLE_HOVER_EFFICIENCY, gVHE );
    llSetVehicleFloatParam(VEHICLE_HOVER_TIMESCALE, gVHT );
    llSetVehicleFloatParam(VEHICLE_HOVER_HEIGHT, gVHH );
    llSetVehicleFloatParam(VEHICLE_BUOYANCY, gVB );

    llRemoveVehicleFlags(vfW);      
    llRemoveVehicleFlags(vfA);      
    llSetVehicleFlags(vfG);     
    if(gSoundStartup!="") { llTriggerSound(gSoundStartup,1.0); }
    llSetStatus(STATUS_PHYSICS, TRUE); 
    gRun = 1;
    enginesound();
}

gearshift(integer g){
    enginesound();
    llRegionSayTo(driver,0,llList2String(gGearNameList, g));
    llMessageLinked(LINK_SET, 0, "gear " + (string)(g+1), NULL_KEY);
}

enginesound(){
    if (gMoving==0) {
        gNewSound = 0;
        if (gOldSound != gNewSound) {
            llStopSound();
            if(gSoundIdle != "") {
                llLoopSound(gSoundIdle,1.0);
            }
        }
        
    } else if (reverse) {
        gNewSound = 4;
        if (gOldSound != gNewSound) {
            llStopSound();
            if(gSoundRev!="") {
                llLoopSound(gSoundRev,1.0);
            } else if(gSoundSlow!="") {
                llLoopSound(gSoundSlow,1.0);
            }
        }
    } else if ((gSoundAggressive != "") && (gGear >= aggressive_gear) && (gSoundSlow != gSoundAggressive)) {
        gNewSound = 2;
        if (gOldSound != gNewSound) {
            llStopSound();
            if(gSoundAggressive!="") {
                llLoopSound(gSoundAggressive,1.0);
            }
        }
    } else {
        gNewSound = 1;
        if (gOldSound != gNewSound) {
            llStopSound();
            if(gSoundSlow!="") {
                llLoopSound(gSoundSlow,1.0);
            }
        }
    }
    gOldSound = gNewSound; 
}

config_init() {
    llOwnerSay("Initializing Supercar Plus script, please wait...");
    if(llGetInventoryNumber(INVENTORY_NOTECARD)==0) { finish(); return; }
    llOwnerSay("   Reading Config notecard...");
    integer nFound = FALSE;
    for (i=0; i<llGetInventoryNumber(INVENTORY_NOTECARD);i++) {
        if(notecard_name==llGetInventoryName(INVENTORY_NOTECARD, i)) { nFound=TRUE; }
    }
    if(! nFound) {
        llOwnerSay("   Error reading Config notecard, using configs from script");
        finish();
        return;
    }
    if (notecard_key == llGetInventoryKey(notecard_name)){  finish(); return; }
    notecard_key = llGetInventoryKey(notecard_name);
    iLine = 0;
    kQuery = llGetNotecardLine(notecard_name, iLine);
}

setConfig(string setting, string qval) {
    if(setting=="gDrivePermit") { gDrivePermit = (integer)qval; }
    else if(setting=="driverList") { 
        qval = llStringTrim(llDeleteSubString(llDeleteSubString(qval, llStringLength(qval)-1, llStringLength(qval)-1),0,0), STRING_TRIM);
        if(qval!="") { driverList = llParseString2List(qval,[","],[""]); }
    }
    else if(setting=="gSitMessage") { gSitMessage = llDeleteSubString(llDeleteSubString(qval, llStringLength(qval)-1, llStringLength(qval)-1),0,0); }
    else if(setting=="gUrNotAllowedMessage") { gUrNotAllowedMessage = llDeleteSubString(llDeleteSubString(qval, llStringLength(qval)-1, llStringLength(qval)-1),0,0); }
    else if(setting=="maxGear") { maxGear = (integer)qval; }
    else if(setting=="lowestGear") { lowestGear = (integer)qval; }
    else if(setting=="startGear") { startGear = (integer)qval; }
    else if(setting=="fallbackAbove") { fallbackAbove = (integer)qval; }
    else if(setting=="turn_in_place_speed") { turn_in_place_speed = (float)qval; }
    else if(setting=="turnList") {
        qval = llStringTrim(llDeleteSubString(llDeleteSubString(qval, llStringLength(qval)-1, llStringLength(qval)-1),0,0), STRING_TRIM);
        if(qval!="") { turnList = llParseString2List(qval,[","],[""]); }
    }
    else if(setting=="speedList") {
        qval = llStringTrim(llDeleteSubString(llDeleteSubString(qval, llStringLength(qval)-1, llStringLength(qval)-1),0,0), STRING_TRIM);
        if(qval!="") { speedList = llParseString2List(qval,[","],[""]); }
    }
    else if(setting=="enableCamera") { if(qval=="TRUE") { enableCamera=TRUE; } else { enableCamera=FALSE; } }
    else if(setting=="CamDist") { CamDist = (float)qval; }
    else if(setting=="CamPitch") { CamPitch = (float)qval; }
    else if(setting=="lookAhead") { lookAhead = (float)qval; }
    else if(setting=="auto_park_time") { auto_park_time = (integer)qval; }
    else if(setting=="click_to_pause") { if(qval=="TRUE") { click_to_pause=TRUE; } else { click_to_pause=FALSE; } }
    else if(setting=="sit_message") { sit_message = llDeleteSubString(llDeleteSubString(qval, llStringLength(qval)-1, llStringLength(qval)-1),0,0); }
    else if(setting=="stand_message") { stand_message = llDeleteSubString(llDeleteSubString(qval, llStringLength(qval)-1, llStringLength(qval)-1),0,0); }
    else if(setting=="aggressive_gear") { aggressive_gear = (integer)qval; }
    else if(setting=="use_sl_sounds") { if(qval=="TRUE") { use_sl_sounds=TRUE; } else { use_sl_sounds=FALSE; } }
    else if(setting=="gSoundStartup") { gSoundStartup = llDeleteSubString(llDeleteSubString(qval, llStringLength(qval)-1, llStringLength(qval)-1),0,0); }
    else if(setting=="gSoundIdle") { gSoundIdle = llDeleteSubString(llDeleteSubString(qval, llStringLength(qval)-1, llStringLength(qval)-1),0,0); }
    else if(setting=="gSoundSlow") { gSoundSlow = llDeleteSubString(llDeleteSubString(qval, llStringLength(qval)-1, llStringLength(qval)-1),0,0); }
    else if(setting=="gSoundAggressive") { gSoundAggressive = llDeleteSubString(llDeleteSubString(qval, llStringLength(qval)-1, llStringLength(qval)-1),0,0); }
    else if(setting=="gSoundRev") { gSoundRev = llDeleteSubString(llDeleteSubString(qval, llStringLength(qval)-1, llStringLength(qval)-1),0,0); }
    else if(setting=="gSoundStop") { gSoundStop = llDeleteSubString(llDeleteSubString(qval, llStringLength(qval)-1, llStringLength(qval)-1),0,0); }
    else if(setting=="gSoundAlarm") { gSoundAlarm = llDeleteSubString(llDeleteSubString(qval, llStringLength(qval)-1, llStringLength(qval)-1),0,0); }
    
}

finish() {
    if(auto_park_time>0) {
        llOwnerSay("   Setting auto-park position...");
        startposition = llGetPos();
        startrot = llGetRot();
    }
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
    
    llOwnerSay("   Loading sounds.."); 
    preload_sounds();
    init_engine();
    init_PhysEng();
    is_resetting = FALSE;
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
    //llSleep(1.5); // why is this here?
    set_engine();
    llMessageLinked(LINK_SET, 0, "car_start", NULL_KEY);
    llMessageLinked(LINK_SET, 0, "gear " + (string)startGear, NULL_KEY);
    llSetSitText("Sit");
    seated = TRUE;
    if(sit_message !="") { llRegionSayTo(driver,0,sit_message); }
    prevDriver = driver;
    if(parked) { llRegionSayTo(driver,0, "Driving resumed."); }
    parked = FALSE;
}


default {
    state_entry() {
        is_resetting = TRUE;
        config_init();
        if(is_resetting == FALSE) { state Idle; }
    }

    dataserver(key query_id, string data) {
        if (query_id == kQuery) {
            if (data != EOF)  {
                if(llStringTrim(data, STRING_TRIM)=="") { jump break; }
                list tmp = llParseString2List(data, [";"], []);
                string conf = llList2String(tmp,0);
                tmp = llParseString2List(conf, ["="], []);
                string setting = llStringTrim(llList2String(tmp,0), STRING_TRIM);
                string qval = llStringTrim(llList2String(tmp,1), STRING_TRIM);
                setConfig(setting, qval);
                @break;
                ++iLine;
                kQuery = llGetNotecardLine(notecard_name, iLine);
            } else {
                finish();
                @myidle;
                state Idle;
            }
        }
    }
}

state Idle {
    state_entry() {
    
    }

    on_rez(integer param) {
        startposition = ZERO_VECTOR;
        if((llList2Integer(llGetObjectDetails(llGetLinkKey(LINK_THIS), [ OBJECT_TEMP_ON_REZ ]), 0)==0) && (auto_park_time != 0)) {
            llOwnerSay("To enable Auto-Park, place your vehicle in its parking location and then touch the vehicle to open the dialog.");
        }
        seated = FALSE;
    }
    
    touch_start(integer total_number) { 
        if((auto_park_time > 0) && (llDetectedKey(0) == llGetOwner())) { 
            menu(llGetOwner(),"\nSet Auto-Park location??",["Set Location", "Cancel"]); 
        }
    }  
    
    changed(integer change) {     
        if (change & CHANGED_LINK) {
            if((llGetObjectPrimCount(llGetKey()) != primcount) && (! seated) && (! is_resetting)) { // adding or removing a prim
                llOwnerSay("** Prim count changed, resetting **");
                llResetScript();
            }
            
            driver = llAvatarOnLinkSitTarget(LINK_THIS);
            if ((driver != NULL_KEY) && (! seated)) { // happens once
                if(is_resetting) {
                    llRegionSayTo(driver,0, "Please wait for the script to finish resetting.");
                    llUnSit(driver);
                    return;
                }
                
                if((gDrivePermit == 0) || ((gDrivePermit == 1) && (driver == llGetOwner())) || ((gDrivePermit == 2) && (llSameGroup(driver)==TRUE))
                    || (llListFindList( driverList, [(string)driver] ) != -1)) { 
                    state Driving;
                    
                }
                else {
                    llRegionSayTo(driver,0, gUrNotAllowedMessage);
                    llUnSit(driver);
                    if(gSoundAlarm !="") { llPlaySound(gSoundAlarm,1.0); }
                    llPushObject(driver, <0,0,20>, ZERO_VECTOR, FALSE);
                    
                }
            }
             
 
        }// end changed link
        
        if (change & CHANGED_INVENTORY) { // possible Config NC change
            llOwnerSay("** Inventory change detected, resetting **");
            llResetScript();
        }
    }
    
    listen(integer channel, string name, key av, string message) {
        if ((channel == menu_channel) && (av==llGetOwner())) {
            dialogwait = FALSE;  
            llSetTimerEvent(0.0); 
            llListenRemove(menu_handler); 
            if(message == "Set Location")  { 
                llOwnerSay("Auto-park position set");
                startposition = llGetPos();
                startrot = llGetRot();
            }
        }
    }
    

    timer() {
        if(dialogwait == TRUE) {
            llListenRemove(menu_handler);
            llSetTimerEvent(0.0);  
            dialogwait = FALSE;
        }
    }

}

state Driving {

    state_entry() {
        drivecar();
        llRequestPermissions(driver,  PERMISSION_TAKE_CONTROLS | PERMISSION_CONTROL_CAMERA | PERMISSION_TRIGGER_ANIMATION ); 
    }
    
    on_rez(integer param) {
        seated = FALSE;       
        gRun = 0;
        turnwheels("NoTurn");
        spinwheels(0, "NoSpin");
        init_engine();
                
        llSetTimerEvent(0.0);
        llStopSound();
        llReleaseControls();  
        llSetText("",<0,0,0>,1.0);
        llMessageLinked(LINK_SET, 0, "honkoff", NULL_KEY);
        llMessageLinked(LINK_SET, 0, "car_stop", NULL_KEY);
        llListenRemove(listener);  

        llSetStatus(STATUS_PHYSICS, FALSE); 
        for(i=2; i<= llGetObjectPrimCount(llGetKey()); i++) {
            list params = llGetLinkPrimitiveParams(i,[PRIM_PHYSICS_SHAPE_TYPE]);
            if(llList2Integer(prim_phys_types, i-2) != llList2Integer(params, 0)) {
                llSetLinkPrimitiveParamsFast(i,[ PRIM_PHYSICS_SHAPE_TYPE,llList2Integer(prim_phys_types, i-2) ] );
            }
        }                   
        llListenRemove(menu_handler);
        dialogwait = FALSE;
        state Idle;
    }
    
    touch_start(integer total_number) { 
        if(click_to_pause && (llDetectedKey(0) == driver)) { 
            menu(driver,"\nPause your car or resume driving?",["Pause Car", "Drive"]); 
        }
    } 
    
    changed(integer change) {     
        if (change & CHANGED_LINK) {
            if((llGetObjectPrimCount(llGetKey()) != primcount) && (! seated) && (! is_resetting)) { // adding or removing a prim
                llOwnerSay("** Prim count changed, resetting **");
                llResetScript();
            }
            
            driver = llAvatarOnLinkSitTarget(LINK_THIS);
            if ((driver != NULL_KEY) && (! seated)) { // happens once
                
                if((gDrivePermit == 0) || ((gDrivePermit == 1) && (driver == llGetOwner())) || ((gDrivePermit == 2) && (llSameGroup(driver)==TRUE))
                    || (llListFindList( driverList, [(string)driver] ) != -1)) { 
                    
                    if(parked && (auto_park_time>0) && (startposition != ZERO_VECTOR)) {
                        llSay(0, "Auto-park enabled");
                    }
                    drivecar();
                    llRequestPermissions(driver,  PERMISSION_TAKE_CONTROLS | PERMISSION_CONTROL_CAMERA | PERMISSION_TRIGGER_ANIMATION ); 
                    
                }
                else {
                    llRegionSayTo(driver,0, gUrNotAllowedMessage);
                    llUnSit(driver);
                    if(gSoundAlarm !="") { llPlaySound(gSoundAlarm,1.0); }
                    llPushObject(driver, <0,0,20>, ZERO_VECTOR, FALSE);
                    
                }
            }
            else if ((driver == NULL_KEY) && seated) { // If driver stood up 
                seated = FALSE;       
                gRun = 0;
                turnwheels("NoTurn");
                spinwheels(0, "NoSpin");
                init_engine();
                
                llSetTimerEvent(0.0);
                llStopSound();
                llReleaseControls();  
                llSetText("",<0,0,0>,1.0);
                llMessageLinked(LINK_SET, 0, "honkoff", NULL_KEY);
                llMessageLinked(LINK_SET, 0, "car_stop", NULL_KEY);
                llListenRemove(listener);  
                
                if(stand_message !="") { llRegionSayTo(prevDriver,0,stand_message); }  
                if(gSoundStop!="") { llStopSound(); llTriggerSound(gSoundStop,1); }
                if(llGetPermissions() & PERMISSION_TRIGGER_ANIMATION) {                    
                    if (llGetInventoryNumber(INVENTORY_ANIMATION) == 1) { llStopAnimation(llGetInventoryName(INVENTORY_ANIMATION, 0)); }
                    else { llStopAnimation("sit"); }
                }   
                llSetStatus(STATUS_PHYSICS, FALSE); 
                for(i=2; i<= llGetObjectPrimCount(llGetKey()); i++) {
                    list params = llGetLinkPrimitiveParams(i,[PRIM_PHYSICS_SHAPE_TYPE]);
                    if(llList2Integer(prim_phys_types, i-2) != llList2Integer(params, 0)) {
                        llSetLinkPrimitiveParamsFast(i,[ PRIM_PHYSICS_SHAPE_TYPE,llList2Integer(prim_phys_types, i-2) ] );
                    }
                }                   
                if((! parked) && (auto_park_time>0) && (startposition != ZERO_VECTOR)) {
                    llSay(0, "The vehicle will auto-park in " + (string)auto_park_time + " seconds, unless a new driver takes control.");
                    llSetTimerEvent(auto_park_time);
                } else if(parked && (auto_park_time>0) && (startposition != ZERO_VECTOR)) {
                    llSay(0, "Auto-park temporarily disabled");
                }

            } // end - no driver
            
            else if(driver !=NULL_KEY) { // someone sat or stood on another prim
               if (driver != NULL_KEY) { init_followCam(); }
            }    
        }// end changed link
        
        if (change & CHANGED_INVENTORY) { // possible Config NC change
            llOwnerSay("** Inventory change detected, resetting **");
            llResetScript();
        }
    }
    
    run_time_permissions(integer perm) {
        if(perm & PERMISSION_TAKE_CONTROLS){
            llTakeControls(
             CONTROL_FWD | CONTROL_BACK  | CONTROL_DOWN |
             CONTROL_UP  | CONTROL_RIGHT | CONTROL_LEFT |
             CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT, TRUE, FALSE);            
        }
         
        if( (perm & PERMISSION_CONTROL_CAMERA) && (enableCamera) ) {
            init_followCam();
        }
        
        if((perm & PERMISSION_TRIGGER_ANIMATION) && (llGetInventoryNumber(INVENTORY_ANIMATION) == 1)) {
            llStopAnimation("sit");
            llStartAnimation(llGetInventoryName(INVENTORY_ANIMATION, 0));
        }
       
    }

    control(key id, integer held, integer change) {
        if(gRun == 0){
            return;
        }
        reverse=0;
        gTurnRatio = llList2Float(turnList,gGear);
        gGearPower = llList2Integer(speedList, gGear);

        if ((held & change & CONTROL_UP) || ((gGear >= maxGear) && (held & CONTROL_UP))){
            if(gGear < maxGear) {
                gGear=gGear+1;
                gearshift(gGear); 
                llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, gVLFT);
            }
        }

        if ((held & change & CONTROL_DOWN) || ((gGear <= lowestGear) && (held & CONTROL_DOWN))){
            if(gGear > lowestGear) {
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
            if (gGear < lowestGear) { gGear = lowestGear; }
            else { gearshift(gGear); }
        } else if(msg == "wheelcalc") {
            wheelcalc();
        }
    }
    
    listen(integer channel, string name, key av, string message) {
        if (channel == menu_channel) {
            dialogwait = FALSE;  
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
                llRegionSayTo(driver, 0, "Car parked. Auto-Park disabled. Touch again to resume driving.");
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
    

    timer() {
        if(dialogwait == TRUE) {
            llListenRemove(menu_handler);
            llSetTimerEvent(0.0);  
            dialogwait = FALSE;
        } else if((! parked) && (gRun == 0) && (auto_park_time>0) && (startposition != ZERO_VECTOR)) {
            llSetRegionPos(startposition);
            llSetRot(startrot);
            llMessageLinked(LINK_SET, 0, "car_park", NULL_KEY);
            llSetTimerEvent(0);
            state Idle;
        }
    }

}

// END

