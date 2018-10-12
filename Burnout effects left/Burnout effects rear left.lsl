// Burnout effects rear left 1.61
// For use with Supercar Plus script (https://github.com/cuga-rajal/supercar_plus)
// Place this in a prim at the base of the rear left wheel
// Requires a texture and sound to be placed in the same prim. 


integer     burnout = FALSE;
integer     turnburn = FALSE;
integer     screech = FALSE;
float		Speed;
integer		LoopSound = 0;
key			texture;
key			screechsound;

updateParticles() {

 llParticleSystem([
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
     PSYS_SRC_TEXTURE,           texture,
     PSYS_PART_FLAGS,
         PSYS_PART_WIND_MASK |
         PSYS_PART_EMISSIVE_MASK |
         PSYS_PART_FOLLOW_VELOCITY_MASK |
         PSYS_PART_INTERP_COLOR_MASK |
         PSYS_PART_INTERP_SCALE_MASK
	]);
}


default {
    state_entry() {
        llParticleSystem([]);
        texture = llGetInventoryName(INVENTORY_TEXTURE, 0);
        screechsound = llGetInventoryName(INVENTORY_SOUND, 0);
    }
    
    on_rez( integer start_param ) {
        llResetScript();
    }

    link_message(integer sender, integer num, string message, key id) {
        if(message=="burnout") {
            burnout = TRUE;
        }
        else if(message=="burnoutoff") {
            burnout = FALSE;
            llParticleSystem([]);
        }
        else if(message=="screechon") {
            screech = TRUE;
        }
        else if(message=="screechoff") {
            screech = FALSE;
            llStopSound();
            LoopSound = 0;
        }
        else if(message=="turnburnon") {
            turnburn = TRUE;
        }
        else if(message=="turnburnoff") {
            turnburn = FALSE;
            llStopSound();
            LoopSound = 0;
            llParticleSystem([]);
        }
        else if(message=="letsburn") {
            if(burnout) {
                updateParticles();
            }
        }
        else if(message=="letsscreech") {
            if(screech) {
                if(LoopSound != 1) {
                    llLoopSound(screechsound,1); 
                    LoopSound = 1; 
                }
            }
        }
        else if(message=="letsburnL" && turnburn) {
            updateParticles();
            if(LoopSound != 1) {
                llLoopSound(screechsound,1);
                LoopSound = 1;
            }
        }
        else if(message=="letsburnLstop") {
            llStopSound();
            LoopSound = 0;
            llParticleSystem([]);
        }
    }
   

}