// Supercar Plus 1.75
// By Cuga Rajal (Cuga_Rajal@http://rajal.org:9000, GMail: cugarajal@gmail.com)
// For the latest version and more information visit https://github.com/cuga-rajal/supercar_plus/ 
// For history and credits please see https://github.com/cuga-rajal/supercar_plus/blob/master/Supercar_Plus_Versions_Credits.txt
// This work is licensed under the Creative Commons BY-NC-SA 3.0 License: https://creativecommons.org/licenses/by-nc-sa/3.0/

//---USER-DEFINED VARIABLES--------------------------------------------------
// ** NOTE ** On version 1.65 and later, a Config notecard will override these settings if present

                // Driver permissions and sit offsets
integer         gDrivePermit = 0; // Who is allowed to drive car: 0=everyone, 1=owner only, 2=group member
list            driverList = [ ]; // list of UUIDs allowed to drive (whitelist), comma delimited, no spaces
string          gSitMessage = "Drive";  // Appears in the pie menu
string          gUrNotAllowedMessage = "Vehicle is Locked";  // Message to chat window if not allowed
vector          gSitTarget_Pos = <0, 0, 1>;   // sit position offset
vector          gSitTarget_Rot = <0, 0, 0>;   // sit angle offset

                // Gear options -- NOTE: 0=first gear, 11=12th gear
integer         maxGear = 3;       // highest gear that can be shifted to, max 11
integer         lowestGear = 0;     // lowest gear that can be shifted to, min 0
integer         startGear = 0;      // gear selected on sit 
integer         fallbackAbove = 6;  // releasing forward button when gear higher than this falls back to this
integer         turn_in_place = FALSE;  // Whether the vehicle should rotate in place when no linear velocity
float           turn_in_place_speed = 2; // Rotation speed if rotating in place
list            turnList = [ ]; // Empty list uses default values; Override defaults with this list 
list            speedList = [ ]; // Empty list uses default values; Override defaults with this list 

                // Camera options
integer         enableCamera = TRUE;  // Whether or not to enable camera controls
float             CamDist = 4; // How far back you want the camera positioned
float            CamPitch = 8.0;  // Angle looking down. Range is -45 to 80 Degrees
float            lookAhead = 8.0;  // How far in front of avatar to focus camera. Range is -10 to 10 meters

                // The following are used only if there are effects scripts in other vehicle prims.
integer         burnoutGear = 1;    // gear that will disply burnout effects. Not used if no effects script in vehicle.
integer         turnburnGear = 3;   // this gear and above show smoke & screech when turning.
integer         pipeflameGear = 3;  // one selected gear will show pipe flames.
integer         lights_on_sit = FALSE; // Whether to turn on headlights on sit

                // Other options
integer         auto_return = FALSE; // Whether the car parks itself after use - to place/angle when script last reset
integer         reset_on_rez = FALSE; // Whether script resets on rez. Set to FALSE if using rezzer
integer         auto_return_time = 300;  // Delay before auto-return in seconds
string          sit_message = ""; // Chat window message shown to driver when sitting
string          stand_message = ""; // Chat window message shown to driver when standing
integer         show_speed = FALSE; // Whether the car should display speed vectors in hover text while driving
integer         verbose_level = 1; // 0 = no messages; 1 = display gear when shifting; 2 = display all llMessageLinked messages
integer         use_hud = FALSE;   // Whether to rez and attach HUD in contents - user must confirm in dialog
string          hud_name = "Supercar HUD 1.57"; // If used, HUD should be in Contents and have this name
integer         HUD_CHANNEL = 19997;

                // Simulator selection
integer         is_SL = FALSE;   // Set to TRUE when using in Second Life, or FALSE for Opensim
integer         use_sl_sounds = FALSE;  // Whether to use DMV 3.0 sounds in Second Life
string          use_alt_sound = "";

string          notecard_name = "Config";


//---INTERNAL VARIABLES--------------------------------------------------

vector          startposition;
rotation        startrot;
integer         burnoutState = FALSE;
integer         turnburnState = FALSE;
integer         pipeflameState = FALSE;
integer         cornerFXRState = FALSE;
integer         cornerFXLState = FALSE;
list            prim_phys_types = [ ];
list            prims_keep_prim = [ ];
integer         i;
integer         desc;
integer         listener;
key             hudid = NULL_KEY;
integer         index;
vector          sitOffset;
key             gOldAgent;
key             gAgent;
key             driver = NULL_KEY;
integer         driverFound = FALSE;
integer         gRun;     //ENGINE RUNNING
integer         gMoving;  //VEHICLE MOVING
integer         sentPower;
vector            vel;
vector            speedvec;

//---SOUND VARIABLES---------------------------------------------------
string       gSoundHorn =            "";
string       gSoundStartup =         "s_startup";
string       gSoundIdle =            "s_idle";
string       gSoundSlow =            "s_slow";
string       gSoundAggressive =      "s_fast";
string       gSoundRev =             "s_rev";
string       gSoundAlarm =           "s_alarm";
string       gSoundStop =            "s_rev";

//NEED KEYWORD SOUND PROCESSOR
integer      gOldSound=3;   //variable for sound function
integer      gNewSound=3;
//---------------------------------------------------------------------

//---iTEC - STOCK ENGINE GLOBAL VARIABLES------------------------------
list        gTSvarList;
float       gVLMT=0.90;                  //INITVAL=0.90   
float       gVLMDT=0.10;                 //INITVAL=0.10  
vector      gVLFT=<8.0, 3000.0, 8.0>;    //INITVAL=<8.0, 3000.0, 8.0>
vector      gVAFT=<0.10, 0.10, 0.10>;    //INITVAL=<0.10, 0.10, 0.10>
float       gVADE=0.20;                  //INITVAL=0.20
float       gVADT=0.50;                  //INITVAL=0.10
float       gVAMT=1.0;                   //INITVAL=0.10 
float       gVAMDT=0.10;                 //INITVAL=0.10
float       gVLDE=1.0;                   //INITVAL=1.0
float       gVLDT=0.10;                  //INITVAL=0.10
float       gVVAE=0.50;                  //INITVAL=0.50
float       gVVAT=5.0;                   //INITVAL=5.0
float       gVHE=0.0;                    //INITVAL=0.0
float       gVHT=0.0;                    //INITVAL=0.0
float       gVHH=0.0;                    //INITVAL=0.0
float       gVB=0.0;                     //INITVAL=0.0
//---------------------------------------------------------------------
 
//---iTEC POWERTRAIN + (e3s) GLOBAL VARIABLES -------------------------
integer      gGear;
//integer      gNewGear;
float        gGearPower;
float        gReversePower;
list         gGearPowerList;
//integer     gGearCount;
//string      gPhysEngDesc;
integer     gPhysEng=1; // if os function is off set this to 0=ODE| 1=Bullet
float       gTurnMulti=1.012345;
float       gTurnRatio;
list        gTurnRatioList;
string      gGearName;
list        gGearNameList                 =[   "1st Gear",
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
float         gSpeed=0;
//---------------------------------------------------------------------

//---------------------------------------------------------------------

integer            gTurnCount;
string             gTurnAngle =               "NoTurn";  // LeftTurn or RightTurn or NoTurn
string             gNewTurnAngle =            "NoTurn";
string             gTireSpin =                "ForwardSpin";   // ForwardSpin or BackwardSpin or NoSpin
string             gNewTireSpin =             "ForwardSpin";

integer            gTcountL; //for cornerFX
integer            gTcountR;

key kQuery = NULL_KEY;
integer iLine = 0;
key notecard_key = NULL_KEY;


//---------------------------------------------------------------------

init_TSvar(integer i){
    if (i==0){
        gTSvarList = [  3.0,               // how fast to reach max speed
                        0.10,               // how fast to reach min speed or zero
                        <7.0,3000.0,100.0>,   // XYZ linear friction
                        <0.10,0.10,0.20>,   // XYZ angular friction
                        0.90,               // how fast turning force is applied 
                        0.50,               // how fast turning force is released
                        1.0,                // adjusted on 0.7.6
                        0.10,
                        0.20,
                        0.10,
                        0.50,
                        5.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0
                     ];
    }else{
        gTSvarList = [  1.0,               // how fast to reach max speed
                        0.10,               // how fast to reach min speed or zero
                        <8.0,3000.0,8.0>,   // XYZ linear friction
                        <0.10,0.10,0.10>,   // XYZ angular friction
                        0.20,               // how fast turning force is applied 
                        0.20,               // how fast turning force is released
                        0.80,               // adjusted on 0.8.0
                        0.10,
                        1.0,
                        0.10,
                        0.50,
                        5.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0
                    ];
    }
    gVLMT=llList2Float(gTSvarList,0);
    gVLMDT=llList2Float(gTSvarList,1);
    gVLFT=llList2Vector(gTSvarList,2);
    gVAFT=llList2Vector(gTSvarList,3);
    gVAMT=llList2Float(gTSvarList,4);
    gVAMDT=llList2Float(gTSvarList,5);
    gVLDE=llList2Float(gTSvarList,6);
    gVLDT=llList2Float(gTSvarList,7);
    gVADE=llList2Float(gTSvarList,8);
    gVADT=llList2Float(gTSvarList,9);
    gVVAE=llList2Float(gTSvarList,10);
    gVVAT=llList2Float(gTSvarList,11);
    gVHE=llList2Float(gTSvarList,12);
    gVHT=llList2Float(gTSvarList,13);
    gVHH=llList2Float(gTSvarList,14);
    gVB=llList2Float(gTSvarList,15);

}

init_PhysEng(){
    //string server = llGetEnv("simulator_hostname");
    //list serverParsed = llParseString2List(server,["."],[]);
    //string grid = llList2String(serverParsed, llGetListLength(serverParsed) - 2);
    //if(grid == "lindenlab") {
    if(is_SL) {
        gPhysEng=0;
        if(verbose_level > 0) { llOwnerSay("   Vehicle is tuned for Havok physics engine / SL"); }
    } else {
        gPhysEng=1;
        if(verbose_level > 0) { llOwnerSay("   Vehicle is tuned for Bullet physics engine / Opensim"); }
    }
    
    if(gPhysEng==0){  // SL/Havok
        gTurnMulti=2;
        init_TSvar(1);
        if(llGetListLength(turnList)>0) {
            gTurnRatioList = turnList;
        } else {
            gTurnRatioList        = [   1.1,    //1st Gear
                                        2.5,    //2nd Gear
                                        1.5,    //3rd Gear
                                        1.5,    //4th Gear
                                        3.9,    //5th Gear
                                        4.0,    //6th Gear
                                        4.1,    //7th Gear
                                        4.5,    //8th Gear
                                        10.0,   //9th Gear
                                        10.0,   //10th Gear
                                        10.0,   //11th Gear
                                        10.0    //12th Gear
                                    ];
        }
        
        if(llGetListLength(speedList)>0) {
            gGearPowerList = speedList;
        } else {
               gGearPowerList        = [ 4,    //1st Gear
                                        10,    //2nd Gear
                                        24,    //3rd Gear
                                        40,    //4th Gear
                                        70,    //5th Gear
                                        80,    //6th Gear
                                        100,    //7th Gear
                                        110,    //8th Gear
                                        155,    //9th Gear
                                        170,    //10th Gear
                                        198,    //11th Gear
                                        256     //12th Gear
                                   ];
        }
    
    } else {  // Opensim/Bullet (works fine in ODE too)
        gTurnMulti=0.987654;
        init_TSvar(1);
        if(llGetListLength(turnList)>0) {
            gTurnRatioList = turnList;
        } else {
            gTurnRatioList        = [   1.3,    //1st Gear
                                        2.5,    //2nd Gear
                                        1.5,    //3rd Gear
                                        2.5,    //4th Gear
                                        3.9,    //5th Gear
                                        4.0,    //6th Gear
                                        4.1,    //7th Gear
                                        4.5,    //8th Gear
                                        10.0,   //9th Gear
                                        10.0,   //10th Gear
                                        10.0,   //11th Gear
                                        10.0    //12th Gear
                                    ];
        }
        
        if(llGetListLength(speedList)>0) {
            gGearPowerList = speedList;
        } else {
               gGearPowerList        = [   6,    //1st Gear
                                        15,    //2nd Gear
                                        24,    //3rd Gear
                                        40,    //4th Gear
                                        70,    //5th Gear
                                        80,    //6th Gear
                                        100,    //7th Gear
                                        110,    //8th Gear
                                        155,    //9th Gear
                                        170,    //10th Gear
                                        198,    //11th Gear
                                        256     //12th Gear
                                   ];
        }
    }

}

preload_sounds(){
    // SL will throw script errors if it tries to play a sound that's not in contents, but keys are ok
    if(use_alt_sound != "") {
        gSoundHorn =            "";
        gSoundStartup =         "";
        gSoundIdle =            use_alt_sound;
        gSoundSlow =            use_alt_sound;
        gSoundAggressive =      use_alt_sound;
        gSoundRev =             use_alt_sound;
        gSoundStop =            "";
    } else if(use_sl_sounds) {
        gSoundHorn =            "2832a902-fd45-fd23-3dc3-457cdded3b1f";
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
        integer index = llListFindList(InventoryList, [gSoundHorn]);
        if((index == -1) && (llStringLength(gSoundHorn) != 36)) { gSoundHorn=""; } else { llPreloadSound(gSoundHorn); }
        index = llListFindList(InventoryList, [gSoundStartup]);
        if((index == -1) && (llStringLength(gSoundStartup) != 36)) { gSoundStartup=""; } else { llPreloadSound(gSoundStartup); }
        index = llListFindList(InventoryList, [gSoundIdle]);
        if((index == -1) && (llStringLength(gSoundIdle) != 36)) { gSoundIdle=""; } else { llPreloadSound(gSoundIdle); }
        index = llListFindList(InventoryList, [gSoundSlow]);
        if((index == -1) && (llStringLength(gSoundSlow) != 36)) { gSoundSlow=""; } else { llPreloadSound(gSoundSlow); }
        index = llListFindList(InventoryList, [gSoundAggressive]);
        if((index == -1) && (llStringLength(gSoundAggressive) != 36)) { gSoundAggressive=""; } else { llPreloadSound(gSoundAggressive); }
        index = llListFindList(InventoryList, [gSoundRev]);
        if((index == -1) && (llStringLength(gSoundRev) != 36)) { gSoundRev=""; } else { llPreloadSound(gSoundRev); }
        index = llListFindList(InventoryList, [gSoundAlarm]);
        if((index == -1) && (llStringLength(gSoundAlarm) != 36)) { gSoundAlarm=""; } else { llPreloadSound(gSoundAlarm); }
        index = llListFindList(InventoryList, [gSoundStop]);
        if((index == -1) && (llStringLength(gSoundStop) != 36)) { gSoundStop=""; } else { llPreloadSound(gSoundStop); }
    }
}

init_engine(){
    gRun = 0;
    llSetSitText(gSitMessage);
    llCollisionSound("", 0.0);
    //gSitTarget_Rot = llRot2Euler( llGetRootRotation() ); // SIT TARGET IS BASED ON VEHICLE'S ROTATION.
    llSitTarget(gSitTarget_Pos + sitOffset, llEuler2Rot(DEG_TO_RAD * gSitTarget_Rot));
    gOldSound=3; 
    gNewSound=3;
    gTireSpin = "NoSpin";
    gTurnAngle = "NoTurn";

    llMessageLinked(LINK_ALL_OTHERS, 0, gTireSpin, NULL_KEY);      // NO SPIN
    llMessageLinked(LINK_ALL_OTHERS, 0, gTurnAngle, NULL_KEY);     // NO TURN

}

init_followCam(float degrees){
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
                        rotation sitRot = llAxisAngle2Rot(<0, 0, 1>, degrees * PI);
                        llSetCameraEyeOffset(<-10, 0, 3.5> * sitRot);
                        llSetCameraAtOffset(<4, 0, 3> * sitRot);
                        llForceMouselook(FALSE);
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
    llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, gVLFT );
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
}

powershift(integer g){
    gGearPower = llList2Integer(gGearPowerList, g);
}

gearshift(integer g){
    gGearName = llList2String(gGearNameList, g);
    enginesound();
    if(verbose_level>0) { llRegionSayTo(driver,0,gGearName);}
}

showdata(string s){
    if(show_speed) { llSetText(s+"\n.\n.\n.\n.",<1,1,.6>,1.0); }
}

enginesound(){
    if ((gMoving==0) || ((gPhysEng==0) && (gSpeed < 1.0)) || ((gPhysEng==1) && (gSpeed <=20))) {
        gNewSound = 0;
        if ((gOldSound != gNewSound) && (gSoundIdle!="")) {
            llStopSound();
            llLoopSound(gSoundIdle,1.0);
            gOldSound = gNewSound;
        }
    } else if (((gPhysEng==0) && (gSpeed >12)) || ((gPhysEng==1) && (gSpeed >50))) {
        gNewSound = 2;
        if ((gOldSound != gNewSound) && (gSoundAggressive!="")) {
            llStopSound();
            llLoopSound(gSoundAggressive,1.0);
            gOldSound = gNewSound;
        }
    } else {
        gNewSound = 1;
        if ((gOldSound != gNewSound) && (gSoundSlow!="")) {
            llStopSound();
            llLoopSound(gSoundSlow,1.0);
            gOldSound = gNewSound;
        }
    }
}

SendLinkMessage(integer Lnum, string Lstr) {
   llMessageLinked(LINK_SET, Lnum, Lstr, NULL_KEY);
   if(verbose_level>1) { llRegionSayTo(driver,0,"llMessageLinked: num=" + (string)Lnum + ", string=" + Lstr); }
}

config_init() {
    llOwnerSay("Initializing Supercar Plus script, please wait...");
    if(llGetInventoryNumber(INVENTORY_NOTECARD)==0) { finish(); return; }
    llOwnerSay("   Reading Config notecard...");
    integer nFound = FALSE;
    for (i=0; i<llGetInventoryNumber(INVENTORY_NOTECARD);i++) {
        if(notecard_name==llGetInventoryName(INVENTORY_NOTECARD, i)) { nFound=TRUE; }
    }
    if(! nFound) { finish(); return; }
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
    else if(setting=="gSitTarget_Pos") { gSitTarget_Pos = (vector)qval; }
    else if(setting=="gSitTarget_Rot") { gSitTarget_Rot = (vector)qval; }
    else if(setting=="maxGear") { maxGear = (integer)qval; }
    else if(setting=="lowestGear") { lowestGear = (integer)qval; }
    else if(setting=="startGear") { startGear = (integer)qval; }
    else if(setting=="fallbackAbove") { fallbackAbove = (integer)qval; }
    else if(setting=="turn_in_place") { if(qval=="TRUE") { turn_in_place=TRUE; } else { turn_in_place=FALSE; } }
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
    else if(setting=="burnoutGear") { burnoutGear = (integer)qval; }
    else if(setting=="turnburnGear") { turnburnGear = (integer)qval; }
    else if(setting=="pipeflameGear") { pipeflameGear = (integer)qval; }
    else if(setting=="lights_on_sit") { if(qval=="TRUE") { lights_on_sit=TRUE; } else { lights_on_sit=FALSE; } }
    else if(setting=="auto_return") { if(qval=="TRUE") { auto_return=TRUE; } else { auto_return=FALSE; } }
    else if(setting=="auto_return_time") { auto_return_time = (integer)qval; }
    else if(setting=="reset_on_rez") { if(qval=="TRUE") { reset_on_rez=TRUE; } else { reset_on_rez=FALSE; } }
    else if(setting=="sit_message") { sit_message = llDeleteSubString(llDeleteSubString(qval, llStringLength(qval)-1, llStringLength(qval)-1),0,0); }
    else if(setting=="stand_message") { stand_message = llDeleteSubString(llDeleteSubString(qval, llStringLength(qval)-1, llStringLength(qval)-1),0,0); }
    else if(setting=="show_speed") { if(qval=="TRUE") { show_speed=TRUE; } else { show_speed=FALSE; } }
    else if(setting=="verbose_level") { verbose_level = (integer)qval; }
    else if(setting=="use_hud") {  if(qval=="TRUE") { use_hud=TRUE; } else { use_hud=FALSE; }  }
    else if(setting=="hud_name") { hud_name = llDeleteSubString(llDeleteSubString(qval, llStringLength(qval)-1, llStringLength(qval)-1),0,0); }
    else if(setting=="HUD_CHANNEL") { HUD_CHANNEL = (integer)qval; }
    else if(setting=="is_SL") { if(qval=="TRUE") { is_SL=TRUE; } else { is_SL=FALSE; } }
    else if(setting=="use_sl_sounds") { if(qval=="TRUE") { use_sl_sounds=TRUE; } else { use_sl_sounds=FALSE; } }
    else if(setting=="use_alt_sound") { use_alt_sound = llDeleteSubString(llDeleteSubString(qval, llStringLength(qval)-1, llStringLength(qval)-1),0,0); }
}

finish() {
    if(auto_return) {
        llOwnerSay("   Setting auto-park position...");
        startposition = llGetPos();
        startrot = llGetRot();
    }
    llOwnerSay("   Reading physics types of child prims..");
    prim_phys_types = [ ];
    for(i=2; i<= llGetObjectPrimCount(llGetKey()); i++) {
        list params = llGetLinkPrimitiveParams(i,[PRIM_PHYSICS_SHAPE_TYPE, PRIM_DESC]);
        desc = llList2Integer(params, 0);
        prim_phys_types += desc;
        if(llList2String(params, 1) == "prim") {
            prims_keep_prim += i;
        }
    }
    llOwnerSay("   Done reading physics types of child prims");
    llOwnerSay("   Loading sounds..");
    preload_sounds();
    llOwnerSay("   Done loading sounds");
    init_engine();
    init_PhysEng();
    llOwnerSay("Initialization complete, ready to drive.");
}

default {
    state_entry() {
        config_init();
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
                llOwnerSay("   Finished reading Config notecard.");
                finish();
            }
        }
    }
    
    on_rez(integer param) {
        if(reset_on_rez) { llResetScript(); }
    }
    
    changed(integer change){
        if ((change & CHANGED_LINK) == CHANGED_LINK){
            gAgent = llAvatarOnSitTarget();
            if (gAgent != NULL_KEY){
                
                if((gDrivePermit == 0) || ((gDrivePermit == 1) && (gAgent == llGetOwner())) || ((gDrivePermit == 2) && (llSameGroup(gAgent)==TRUE))
                    || (llListFindList( driverList, [(string)gAgent] ) != -1)) {
                    
                    gOldAgent = gAgent;
                    set_engine();
                    llSetStatus(STATUS_PHYSICS, TRUE);
                    if(driver == NULL_KEY) {
                        driver = gAgent;
                        llRequestPermissions(gAgent, PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS | PERMISSION_CONTROL_CAMERA);
                        gRun = 1;
                        if(sit_message !="") { llRegionSayTo(driver,0,sit_message); }
                        llSetSitText("Sit");
                    }
                }
                else {
                    llRegionSayTo(gAgent,0, gUrNotAllowedMessage);
                    llUnSit(gAgent);
                    if(gSoundAlarm !="") { llPlaySound(gSoundAlarm,1.0); }
                    llPushObject(gAgent, <0,0,20>, ZERO_VECTOR, FALSE);
                }
            }
            else if (gRun==1) {  // If someone stood up while car is running
                integer total_num = llGetObjectPrimCount(llGetKey());
                driverFound = FALSE;
                if(total_num < llGetNumberOfPrims()) {  // If there still are avatars seated, see if driver is still seated
                    integer i = llGetObjectPrimCount(llGetKey());
                    while(++i <= llGetNumberOfPrims()) {  if(llGetLinkKey(i)==driver) { driverFound = TRUE; } }
                }
                if((total_num == llGetNumberOfPrims()) || (! driverFound)) { // If there are no seated avatars or if driver is no longer seated
                    llSetStatus(STATUS_PHYSICS, FALSE); 
                    for(i=2; i<= llGetObjectPrimCount(llGetKey()); i++) {
                        list params = llGetLinkPrimitiveParams(i,[PRIM_PHYSICS_SHAPE_TYPE]);
                        if(llList2Integer(prim_phys_types, i-2) != llList2Integer(params, 0)) {
                            llSetLinkPrimitiveParamsFast(i,[ PRIM_PHYSICS_SHAPE_TYPE,llList2Integer(prim_phys_types, i-2) ] );
                        }
                    }
                    gRun = 0;
                    if(stand_message !="") { llRegionSayTo(driver,0,stand_message); }
                    driver = NULL_KEY;
                    init_engine();
                    if(gSoundStop!="") { llStopSound(); llTriggerSound(gSoundStop,1); }
                    
                    if(llGetPermissions() & PERMISSION_TRIGGER_ANIMATION) {
                        integer count = llGetInventoryNumber(INVENTORY_ANIMATION);
                        if (count != 0) { llStopAnimation(llGetInventoryName(INVENTORY_ANIMATION, 0)); }
                        else { llStopAnimation("sit"); }
                    }
                    llSetTimerEvent(0.0);
                    llStopSound();
                    llReleaseControls();
                    if(llGetPermissions() & PERMISSION_CONTROL_CAMERA) { llClearCameraParams(); }
                    llSetText("",<0,0,0>,1.0);
                    SendLinkMessage(0, "pipeflameoff");
                    SendLinkMessage(0, "burnoutoff");
                    SendLinkMessage(0, "headlightoff");
                    SendLinkMessage(0, "honkoff");
                    SendLinkMessage(0, "car_stop");
                    llRegionSayTo(hudid, HUD_CHANNEL, "control poof");
                    llListenRemove(listener);  
                    if(auto_return) { llSetTimerEvent(auto_return_time); }
                }
            }
        }
        if (change & CHANGED_INVENTORY) { // possible Config NC change
			llOwnerSay("** Inventory change detected, resetting **");
        	llResetScript();
		}
    }
    
    run_time_permissions(integer perm){
        if( perm & PERMISSION_TAKE_CONTROLS ){
            gGear = startGear;
            llTakeControls(CONTROL_FWD | CONTROL_BACK | CONTROL_DOWN | CONTROL_UP | CONTROL_RIGHT | CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT, TRUE, FALSE);
        }
        
        if(perm & PERMISSION_TRIGGER_ANIMATION) {
        	string pilot_anim = llGetAnimationOverride("Sitting");
 			llStopAnimation(pilot_anim);
            integer count = llGetInventoryNumber(INVENTORY_ANIMATION);
            if (count != 0) {
                llStopAnimation("sit");
                llStartAnimation(llGetInventoryName(INVENTORY_ANIMATION, 0));
            } else {
                llStartAnimation("sit");
            }
        }
        
        if((perm & PERMISSION_CONTROL_CAMERA) && (enableCamera)) {
            init_followCam(0);
        }
        
        if(use_hud) {
            i = llGetInventoryNumber(INVENTORY_OBJECT);
            if ((i != 0) && (llGetInventoryName(INVENTORY_OBJECT, 0) == hud_name)) {
                llRezObject(hud_name, llGetPos()+<0.0,0.0,5.0>,ZERO_VECTOR,ZERO_ROTATION,90);
            }
        }
        SendLinkMessage(0, "startupflame");
        SendLinkMessage(0, "car_start");
        if(lights_on_sit) { SendLinkMessage(0, "headlight");}
        if(gSoundStartup!="") { llTriggerSound(gSoundStartup,1.0); }
        llSleep(1.5);
        enginesound();

    }

    control(key id, integer held, integer change){
        if(gRun == 0){
            return;
        }
        llSetTimerEvent(0);
        integer reverse=1;
        vel = llGetVel();
        speedvec = vel / llGetRot();
        gSpeed = llVecMag(vel);
        gTurnRatio = llList2Float(gTurnRatioList,gGear);

        if ((held & change & CONTROL_UP) || ((gGear >= maxGear) && (held & CONTROL_UP))){
            gGear=gGear+1;
            if (gGear > maxGear) { gGear = maxGear; }
            else { gearshift(gGear); }
        }

        if ((held & change & CONTROL_DOWN) || ((gGear <= lowestGear) && (held & CONTROL_DOWN))){
            gGear=gGear-1;
            if (gGear < lowestGear) { gGear = lowestGear; }
            else { gearshift(gGear); }
        }
        if (held & CONTROL_FWD){
            if(gGear == 0) {
                llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <1.0, 2.0, 8.0>);
            } else {
                llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, gVLFT);
            }
            if(gGear == burnoutGear) {
                if(burnoutState == FALSE) {
                    SendLinkMessage(0, "burnout");
                    SendLinkMessage(0, "screechon");
                    SendLinkMessage(0, "pipeflameon");
                    SendLinkMessage(0, "letsburn");
                    SendLinkMessage(0, "letsscreech");
                    SendLinkMessage(0, "pipeflame");
                    burnoutState = TRUE;
                }
            } else if(burnoutState == TRUE) {
                SendLinkMessage(0, "burnoutoff");
                SendLinkMessage(0, "screechoff");
                SendLinkMessage(0, "pipeflameoff");
                burnoutState = FALSE;
            }
            
            if(gGear == pipeflameGear) {
                if(pipeflameState == FALSE) {
                    SendLinkMessage(0, "pipeflame");
                    pipeflameState = TRUE;
                }
            } else if(pipeflameState == TRUE) {
                SendLinkMessage(0, "pipeflameoff");
                pipeflameState = FALSE;
            }
            
            if(gGear >= turnburnGear) {
                if(turnburnState == FALSE) {
                    SendLinkMessage(0, "turnburnon");
                    turnburnState = TRUE;
                }
            } else if(turnburnState == TRUE) {
                SendLinkMessage(0, "turnburnoff");
                turnburnState = FALSE;
            }
            
            powershift(gGear); 
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <gGearPower,0,0>);
            gMoving=1;
            reverse=1;
            gNewTireSpin = "ForwardSpin";
            
        }

        if (held & CONTROL_BACK){
            //llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <gReversePower,0,0>);
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <-1 * gGearPower,0,0>);
            //llSetCameraParams([CAMERA_BEHINDNESS_ANGLE,-45.0]);
            //llSetCameraParams([CAMERA_DISTANCE,8.0]);
            gTurnRatio = -2.0;
            reverse = -1;
            gNewTireSpin = "BackwardSpin";
            gMoving = 1;
            //llMessageLinked(LINK_SET, 0, gTireSpin, NULL_KEY);
        }
        
        if(! ((held & CONTROL_BACK) || (held & CONTROL_FWD))) { gMoving = 0;}
        
        if (~held & change & CONTROL_FWD){
            //llSay(0,"CONTROL_FWD:Released");
            //llMessageLinked(LINK_SET, 0, gTireSpin, NULL_KEY);   
            
            if((gGear == burnoutGear) && (burnoutState == TRUE)) {
                SendLinkMessage(0, "burnoutoff");
                SendLinkMessage(0, "screechoff");
                SendLinkMessage(0, "pipeflameoff");
                burnoutState = FALSE;
            }
            
            if((gGear >= turnburnGear) && (turnburnState == TRUE)) {
                SendLinkMessage(0, "turnburnoff");
                turnburnState = FALSE;
            }
            
            if(gGear == pipeflameGear) {
                SendLinkMessage(0, "pipeflameoff");
                pipeflameState = FALSE;
            }
                      
            gNewTireSpin = "NoSpin";
            gNewTurnAngle = "NoTurn";
            
            if (gGear > fallbackAbove) {
            	gGear = fallbackAbove;
            	if(verbose_level>0) {
            		gGearName = llList2String(gGearNameList, gGear);
            		llRegionSayTo(driver,0,"Fallback to " + gGearName);
            	}
            }
            
            llSetTimerEvent(0.3);

        }
        if (~held & change & CONTROL_BACK){
            //  Released BACK button          
            gNewTireSpin = "NoSpin";
            gNewTurnAngle = "NoTurn";
            
            llSetTimerEvent(0.3);
        }
        if (~held & ~change & CONTROL_FWD){
            // Not sure of this if{} is needed           
        }
        if (~held & ~change & CONTROL_BACK){
            // Not sure if this if{} is needed   
        }
       
        showdata("Speed Vector:" + (string)speedvec + " Speed:" + (string)(gSpeed*2.23692912) + " mph");
        
        enginesound();
 
        vector AngularMotor;
        if (held & (CONTROL_RIGHT|CONTROL_ROT_RIGHT)){
            if((gSpeed<1) && (turn_in_place)) {
                AngularMotor.z -= PI*turn_in_place_speed;
            } else if (gGear==0) {
                AngularMotor.z -= gSpeed / ((gTurnRatio/gTurnMulti)*1);
            } else {
                AngularMotor.z -= gSpeed / ((gTurnRatio/gTurnMulti)*gGear);
            }
            gNewTurnAngle = "RightTurn";
            gTurnCount = 10;
            gTcountR = 2;
        }

        if (held & (CONTROL_LEFT|CONTROL_ROT_LEFT)){
            if((gSpeed<1) && (turn_in_place)) {
                AngularMotor.z += PI*turn_in_place_speed;
            } else if (gGear==0) {
                AngularMotor.z += gSpeed / ((gTurnRatio/gTurnMulti)*1);
            } else {
                AngularMotor.z += gSpeed / ((gTurnRatio/gTurnMulti)*gGear);
            }
            gNewTurnAngle = "LeftTurn";
            gTurnCount = 10;
            gTcountL = 2;
        }
        
        if (((held & (CONTROL_LEFT|CONTROL_ROT_LEFT))==0) && ((held & (CONTROL_RIGHT|CONTROL_ROT_RIGHT))==0)) {
            gNewTurnAngle = "NoTurn";
        }

        llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, AngularMotor);
        
        if(gTcountL > 0){
            gTcountL--;
        }
        if(gTcountR > 0){
            gTcountR--;
        }
        
        if(gGear>=turnburnGear) {
            
            if((gTcountL == 1) && (! cornerFXLState)) {
                SendLinkMessage(0, "letsburnR");
                cornerFXLState = TRUE;
            } else if((gTcountL != 1) && (cornerFXLState)) {
                SendLinkMessage(0, "letsburnRstop");
                cornerFXLState = FALSE;
            }
            
            if((gTcountR == 1) && (! cornerFXRState)) {
                SendLinkMessage(0, "letsburnL");
                cornerFXRState = TRUE;
            } else if((gTcountR != 1) && (cornerFXRState)) {
                SendLinkMessage(0, "letsburnLstop");
                cornerFXRState = FALSE;
            }
        }
    
        if(gTurnCount > 0){
            gTurnCount--;
        }
        if(gTurnCount == 1){
            gNewTurnAngle = "NoTurn";
        }
        if(gTurnAngle != gNewTurnAngle){
            gTurnAngle = gNewTurnAngle;
            SendLinkMessage(0, gTurnAngle);
        }
        if(gTireSpin != gNewTireSpin){
            gTireSpin = gNewTireSpin;
            if(gGearPower<20) { sentPower =  llRound(gGearPower);}
            else { sentPower=20;} // cap wheel spin due to frame rate
            SendLinkMessage(sentPower, gTireSpin);
        }

    }
    
    object_rez(key id)
    {
        hudid = id;
        listener = llListen(HUD_CHANNEL, "", id, "");
        llRegionSayTo(id, HUD_CHANNEL, "avkey " + (string)driver);
        llRegionSayTo(id, HUD_CHANNEL, "carkey " + (string)llGetKey());
    }
    
    link_message(integer Sender, integer Number, string msg, key Key)
    {
        if(llGetSubString(msg, 0, 8)=="sitoffset") {
            sitOffset =<0,0,(float)llGetSubString(msg, 9, -1)>;
            llSitTarget(gSitTarget_Pos + sitOffset, llEuler2Rot(DEG_TO_RAD * gSitTarget_Rot));
        }
    }
    
    listen(integer channel, string name, key av, string message) 
    {
       //llOwnerSay("car received message: " + message);
            if(message=="honk_on") { SendLinkMessage(0, "honk");  }
            else if(message=="honk_off") { SendLinkMessage(0, "honkoff");  }
            else if(message=="lights_on") { SendLinkMessage(0, "headlight"); }
            else if(message=="lights_off") { SendLinkMessage(0, "headlightoff"); }
            else if(message=="pipeflame_on") { SendLinkMessage(0, "pipeflame"); }
            else if(message=="pipeflame_off") { SendLinkMessage(0, "pipeflameoff"); }
            else if(message=="smoke_on") { SendLinkMessage(0, "burnout"); SendLinkMessage(0, "letsburn"); }
            else if(message=="smoke_off") { SendLinkMessage(0, "burnoutoff");  }
    }
    
    
    timer() {
        if(gRun == 1) {
            vel = llGetVel();
            gSpeed = llVecMag(vel);
            speedvec = vel / llGetRot();
            enginesound();
            showdata("Speed Vector:" + (string)speedvec + " Speed:" + (string)(gSpeed*2.23692912) + " mph");
            if(gSpeed<1) { llSetTimerEvent(0); }
        } else if(auto_return) {
            llSetRegionPos(startposition);
            llSetRot(startrot);
            SendLinkMessage(0, "car_park");
            llSetTimerEvent(0);
        }
    }

}

// END

