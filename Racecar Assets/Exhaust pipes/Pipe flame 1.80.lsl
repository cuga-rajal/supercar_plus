// Pipe Flame 1.80
// For use with Supercar Plus script (https://github.com/cuga-rajal/supercar_plus)
// Requires a texture to be placed in the same prim.  

string texture = "particle_flame.png";
list sys; 
integer i;

updateParticles() {

    sys = [             PSYS_PART_MAX_AGE, 1.3,
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
                        PSYS_SRC_TARGET_KEY,"",
                        PSYS_SRC_INNERANGLE, 0, 
                        PSYS_SRC_OUTERANGLE, 0,
                        PSYS_SRC_OMEGA, <0,0,0>,
                        PSYS_SRC_MAX_AGE, 0,
                        PSYS_SRC_TEXTURE, texture,
                        PSYS_PART_START_ALPHA, 0.05,
                        PSYS_PART_END_ALPHA, 0
                            ];
    llParticleSystem(sys);
}

    
default {

    state_entry() {
        llParticleSystem([]);
        texture = llGetInventoryName(INVENTORY_TEXTURE, 0);
    }
    
    on_rez( integer start_param ) {
        llResetScript();
    }

    link_message(integer sender, integer num, string message, key id) {
    
        if(message=="pipeflameoff") { llParticleSystem([]);} 
        else if (message=="pipeflame") { updateParticles();} 
        else if (message=="startupflame") { updateParticles(); llSetTimerEvent(3.0); } 
    }
    
    timer() {
        llParticleSystem([]);
        llSetTimerEvent(0.0);
    }

}