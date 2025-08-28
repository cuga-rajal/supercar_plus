// Supercar 2 Racecar Effects w/tailsmoke 1.0
// By Cuga Rajal (cuga@rajal.org) - An accessory script for the Supercar Plus package
// For the latest version and more information visit https://github.com/cuga-rajal/supercar_plus/ 
// This work is licensed under the Creative Commons BY-NC-SA 3.0 License: https://creativecommons.org/licenses/by-nc-sa/3.0/

// configurable settings 

// Note: 1st gear = 0, 12th gear = 11;
// burnoutGear setting can be in range 1-11 for gears 2-12. Set to 0 to disable.
// turnburnGear is typically higher than burnoutGear by 1 or more gears.

integer         burnoutGear = 3;
integer         turnburnGear = 4;   // this gear and above show smoke & screech when turning.

// SL assets
//string          smoke_tex = "9358845b-c735-3a94-f13f-062bd464dd9a"; // texture name or UUID. If name is used tex must be placed in each child prim producing smoke particles.
//string          pipeflame_tex = "6cbe1bee-c770-ce9d-ca44-d736280332d0"; // texture name or UUID. If name is used tex must be placed in each child prim producing flame particles.
//string          sound_L = "57f23e25-ff01-1c33-4fc2-81a937c36825"; // sound asset name or UUID. If name is used, sound asset must be placed in root prim.
//string          sound_R = "456c5568-73b2-cec4-e2bc-36c642427a4a"; // sound asset name or UUID. If name is used, sound asset must be placed in root prim.

// OS assets
string          smoke_tex = "4e4b5c91-dc47-44b7-9936-bd5f521050cd";
string          pipeflame_tex = "e2fe5df5-63e3-4122-acf4-b65f0271a997"; 
string          sound_L = "cfa733ca-ec42-44b9-912a-1e41c599280c";
string          sound_R = "05c49e32-5a10-4d37-a89d-f8704981dbe9"; 

// end of configurable parameters

integer         gGear = 0;
integer         primcount;
integer         isLeft;
integer         makePower = FALSE;
integer         burnout = FALSE;
integer         smoking = FALSE;

list            smoke_prims;
list            flame_prims;
integer i;

list smoke;
list flame;
list tailsmoke;

default {
    state_entry() {
        primcount = llGetObjectPrimCount(llGetKey());
        for(i=2; i<= primcount; i++) {
            string primname = llList2String(llGetLinkPrimitiveParams(i,[PRIM_NAME]), 0);
            if(llSubStringIndex(primname, "smoke")!=-1) { smoke_prims += i; }
            else if(llSubStringIndex(primname, "flame")!=-1) { flame_prims += i; }
        }
        
        smoke = [
         PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE_CONE,
         PSYS_SRC_BURST_PART_COUNT,  9999,
         PSYS_SRC_BURST_RATE,        0.0100000,
        PSYS_PART_MAX_AGE,          5.000000,
        PSYS_SRC_BURST_RADIUS,      0.100000,
        PSYS_SRC_ACCEL,             <0.00000, 2.00000, 0.00000>,
        PSYS_SRC_ANGLE_BEGIN,       0.000000,
        PSYS_SRC_ANGLE_END,         3.141593,
        PSYS_SRC_BURST_SPEED_MIN,   1.000000,
        PSYS_SRC_BURST_SPEED_MAX,   0.100000,
        PSYS_SRC_OMEGA,             <9.00000, 9.00000, 9.00000>,
        PSYS_PART_END_SCALE,        <2.00000, 2.00000, 2.00000>,
        PSYS_PART_START_SCALE,      <1.00000, 1.00000, 1.00000>,
        PSYS_PART_END_COLOR,        <1.00000, 1.00000, 1.00000>,
        PSYS_PART_START_COLOR,      <1.00000, 1.00000, 1.00000>,
        PSYS_PART_END_ALPHA,        0.030000,
        PSYS_PART_START_ALPHA,      0.300000,
        PSYS_SRC_TEXTURE,           smoke_tex,
        PSYS_PART_FLAGS,
        PSYS_PART_WIND_MASK |
        PSYS_PART_EMISSIVE_MASK |
        PSYS_PART_FOLLOW_VELOCITY_MASK |
        PSYS_PART_INTERP_COLOR_MASK |
        PSYS_PART_INTERP_SCALE_MASK
        ];

        flame = [
        PSYS_PART_MAX_AGE, 1.3,
        PSYS_PART_FLAGS, (PSYS_PART_EMISSIVE_MASK
                | PSYS_PART_FOLLOW_SRC_MASK
                | PSYS_PART_FOLLOW_VELOCITY_MASK
                | PSYS_PART_INTERP_COLOR_MASK
                | PSYS_PART_INTERP_SCALE_MASK),
        PSYS_PART_START_COLOR, <0.0,0.0,1.0>,
        PSYS_PART_END_COLOR, <1.0, 1.0, 1.0>,
        PSYS_PART_START_SCALE, <0.33,0.33,0.5>,
        PSYS_PART_END_SCALE, <0.01,1.,0.01>, 
        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE_CONE,
        PSYS_SRC_BURST_RATE, 0.01,
        PSYS_SRC_ACCEL, <0,0,0>,
        PSYS_SRC_BURST_PART_COUNT, 5,
        PSYS_SRC_BURST_RADIUS, .1,
        PSYS_SRC_BURST_SPEED_MIN, 1.00,
        PSYS_SRC_BURST_SPEED_MAX, 1.00,
        PSYS_SRC_INNERANGLE, 0, 
        PSYS_SRC_OUTERANGLE, 0,
        PSYS_SRC_OMEGA, <0,0,0>,
        PSYS_SRC_MAX_AGE, 0,
        PSYS_SRC_TEXTURE, pipeflame_tex,
        PSYS_PART_START_ALPHA, 0.05,
        PSYS_PART_END_ALPHA, 0
        ];
        
        
        tailsmoke =
     [PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE_CONE,
     PSYS_SRC_BURST_PART_COUNT,  10,
     PSYS_SRC_BURST_RATE,        0.1,
     PSYS_PART_MAX_AGE,         1.000000,
     PSYS_SRC_BURST_RADIUS,      0.01,
     PSYS_SRC_ACCEL,             <0.00000, 0.00000, 0.00000>,
     PSYS_SRC_ANGLE_BEGIN,       0,
     PSYS_SRC_ANGLE_END,         0.1,
     PSYS_SRC_BURST_SPEED_MIN,   0.5,
     PSYS_SRC_BURST_SPEED_MAX,   0.6,
     PSYS_SRC_OMEGA,             <0,0,0>,
     PSYS_PART_END_SCALE,        <0.20000, 0.20000, 2.00000>,
     PSYS_PART_START_SCALE,      <0.20000, 0.20000, 1.00000>,
     PSYS_PART_END_COLOR,        <1.00000, 1.00000, 1.00000>,
     PSYS_PART_START_COLOR,      <1.00000, 1.00000, 1.00000>,
     PSYS_PART_END_ALPHA,        0.030000,
     PSYS_PART_START_ALPHA,      0.300000,
     PSYS_SRC_TEXTURE,           smoke_tex,
     PSYS_PART_FLAGS,
        // PSYS_PART_WIND_MASK |
         PSYS_PART_EMISSIVE_MASK |
         PSYS_PART_FOLLOW_VELOCITY_MASK |
         PSYS_PART_INTERP_COLOR_MASK |
         PSYS_PART_INTERP_SCALE_MASK
    ];
    
    }

    
    link_message(integer Sender, integer Number, string msg, key Key) {
        if(msg=="car_start") {
            for(i=0; i<llGetListLength(flame_prims); i++) {
                llLinkParticleSystem(llList2Integer(flame_prims, i), flame);
            }
            llSetTimerEvent(3.0);
        } else if(msg=="smoke_on") {
            for(i=0; i<llGetListLength(smoke_prims); i++) {
                llLinkParticleSystem(llList2Integer(smoke_prims, i), smoke);
            }
            smoking = TRUE;
        } else if(msg=="smoke_off") {
            for(i=0; i<llGetListLength(smoke_prims); i++) {
                llLinkParticleSystem(llList2Integer(smoke_prims, i), []);
            }
            smoking = FALSE;
        } else if(msg=="car_stop") {
            for(i=0; i<llGetListLength(smoke_prims); i++) {
                llLinkParticleSystem(llList2Integer(smoke_prims, i), []);
            }
            for(i=0; i<llGetListLength(flame_prims); i++) {
                llLinkParticleSystem(llList2Integer(flame_prims, i), []);
            }
            smoking = FALSE;
        } else if(llGetSubString(msg, 0, 4) == "gear ") {
            gGear = (integer)llGetSubString(msg, 5, -1);
        } else if((gGear==burnoutGear) && (burnoutGear != 0)) {
            if((msg=="ForwardSpin") || (msg=="BackwardSpin")) {
                llLoopSound(sound_L,1.0);
                for(i=0; i<llGetListLength(smoke_prims); i++) {
                    llLinkParticleSystem(llList2Integer(smoke_prims, i), smoke);
                }
                for(i=0; i<llGetListLength(flame_prims); i++) {
                    llLinkParticleSystem(llList2Integer(flame_prims, i), flame);
                }
                burnout = TRUE;
            } else if(msg == "NoSpin") {
                if(! smoking) {
                    for(i=0; i<llGetListLength(smoke_prims); i++) {
                        llLinkParticleSystem(llList2Integer(smoke_prims, i), []);
                    }
                }
                for(i=0; i<llGetListLength(flame_prims); i++) {
                    llLinkParticleSystem(llList2Integer(flame_prims, i), tailsmoke);
                }
                llStopSound();
                burnout = FALSE;
            }
        } else if(burnout) {
            if(! smoking) {
                for(i=0; i<llGetListLength(smoke_prims); i++) {
                    llLinkParticleSystem(llList2Integer(smoke_prims, i), []);
                }
            }
            for(i=0; i<llGetListLength(flame_prims); i++) {
                llLinkParticleSystem(llList2Integer(flame_prims, i), tailsmoke);
            }
            llStopSound();
            burnout = FALSE;
        }
        if(gGear >= turnburnGear) {
            if((msg=="ForwardSpin") || (msg=="BackwardSpin")) { makePower = TRUE; }
            else if(msg == "NoSpin") { makePower = FALSE; }
            if(makePower && (msg == "RightTurn") || (msg == "LeftTurn")) {
                if(msg == "RightTurn") {
                    llLoopSound(sound_L,1.0);
                    for(i=0; i<llGetListLength(smoke_prims); i++) {
                        vector offset = llList2Vector(llGetLinkPrimitiveParams(llList2Integer(smoke_prims, i),[PRIM_POS_LOCAL]), 0);
                        if(offset.y > 0) { llLinkParticleSystem(llList2Integer(smoke_prims, i), smoke); }
                    }
                } else if(msg == "LeftTurn") {
                    llLoopSound(sound_R,1.0);
                    for(i=0; i<llGetListLength(smoke_prims); i++) {
                        vector offset = llList2Vector(llGetLinkPrimitiveParams(llList2Integer(smoke_prims, i),[PRIM_POS_LOCAL]), 0);
                        if(offset.y < 0) { llLinkParticleSystem(llList2Integer(smoke_prims, i), smoke); }
                    }
                }
            } else if((! makePower) || (msg == "NoTurn")) {
                if(! smoking) {
                    for(i=0; i<llGetListLength(smoke_prims); i++) {
                        llLinkParticleSystem(llList2Integer(smoke_prims, i), []);
                    }
                }
                llStopSound();
            }
        }
    }
    
    changed(integer change) {
        if (change & CHANGED_LINK) {
            if(llGetObjectPrimCount(llGetKey()) != primcount) {
                llResetScript();
            }
        }
    }
    
    timer() {
    	list tsm = [];
    	if(llGetStatus(STATUS_PHYSICS)) { tsm = tailsmoke; }
        for(i=0; i<llGetListLength(flame_prims); i++) {
            llLinkParticleSystem(llList2Integer(flame_prims, i), tsm);
        }
        llSetTimerEvent(0.0);
    }
    
    
}
