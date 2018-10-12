// Pipe Flame 1.61
// For use with Supercar Plus script (https://github.com/cuga-rajal/supercar_plus)
// Requires a texture to be placed in the same prim.  

integer      glow = TRUE;        // TRUE or FALSE(*)
vector startColor = <0.0,0.0,1.0>;     // RGB color, black<0,0,0> to white<1,1,1>(*)
vector   endColor = <10.0,10.0,10.0>;     // 
float  startAlpha = 0.05;         // 0.0 to 1.0(*), lower = more transparent
float    endAlpha = 0.0;         // 
vector  startSize = <0.33,0.33,0.5>; // <0.04,0.04,0>(min) to <10,10,0>(max>, <1,1,0>(*)
vector    endSize = <0.01,1.,0.01>; // (Z part of vector is discarded)  
string    texture ;          // Texture used for particles. Texture must be in prim's inventory.

integer count = 5;    // Number of particles created per burst, 1(*) to 4096
float    rate = 0.01;   // Delay between bursts of new particles, 0.0 to 60, 0.1(*)
float     age = 1.3;   // How long each particle lives, 0.1 to 60, 10.0(*)
float    life = 0.0;   // When to stop creating new particles. never stops if 0.0(*)

float      radius = .1;        // 0.0(default) to 64?  Distance from Emitter where new particles are created.
float  innerAngle = 0.0;  // "spread", for all ANGLE patterns, 0(default) to PI
float  outerAngle = 0.0;        // "tilt", for ANGLE patterns,  0(default) to TWO_PI, can use PI_BY_TWO or PI as well.
integer   pattern = PSYS_SRC_PATTERN_ANGLE_CONE; // Choose one of the following:
                //PSYS_SRC_PATTERN_EXPLODE (sends particles in all directions)
                // PSYS_SRC_PATTERN_DROP  (ignores minSpeed and maxSpeed.  Don't bother with count>1 )
                // PSYS_SRC_PATTERN_ANGLE_CONE (set innerangle/outerange to make rings/cones of particles)
                // PSYS_SRC_PATTERN_ANGLE (set innerangle/outerangle to make flat fanshapes of particles)
vector      omega = <0,0,0>; // How much to rotate the emitter around the <X,Y,Z> axises. <0,0,0>(*)
                             // Warning, there's no way to RESET the emitter direction once you use Omega!!
                             // You must attach the script to a new prim to clear the effect of omega.

integer followSource = TRUE;   // TRUE or FALSE(*), Particles move as the emitter moves, (TRUE disables radius!)
integer    followVel = TRUE;    // TRUE or FALSE(*), Particles rotate towards their direction
integer         wind = FALSE;   // TRUE or FALSE(*), Particles get blown away by wind in the sim
integer       bounce = FALSE;   // TRUE or FALSE(*), Make particles bounce on Z altitude of emitter
float       minSpeed = 1.00;     // 0.01 to ? Min speed each particle is spit out at, 1.0(*)
float       maxSpeed = 0.99;     // 0.01 to ? Max speed each particle is spit out at, 1.0(*)
vector          push = <0,0,0>; // Continuous force pushed on particles, use small settings for long lived particles
key           target = "";      // Select a target for particles to arrive at when they die
                                // can be "self" (emitter), "owner" (you), "" or any prim/persons KEY

// === Don't muck about below this line unless you're comfortable with the LSL scripting language ====

// Script variables
integer flags;
list sys;
integer i;

updateParticles() {
    flags = 0;
    if (target == "owner") target = llGetOwner();
    if (target == "self") target = llGetKey();
    if (glow) flags = flags | PSYS_PART_EMISSIVE_MASK;
    if (bounce) flags = flags | PSYS_PART_BOUNCE_MASK;
    if (startColor != endColor) flags = flags | PSYS_PART_INTERP_COLOR_MASK;
    if (startSize != endSize) flags = flags | PSYS_PART_INTERP_SCALE_MASK;
    if (wind) flags = flags | PSYS_PART_WIND_MASK;
    if (followSource) flags = flags | PSYS_PART_FOLLOW_SRC_MASK;
    if (followVel) flags = flags | PSYS_PART_FOLLOW_VELOCITY_MASK;
    if (target != "") flags = flags | PSYS_PART_TARGET_POS_MASK;
    sys = [  PSYS_PART_MAX_AGE,age,
                        PSYS_PART_FLAGS,flags,
                        PSYS_PART_START_COLOR, startColor,
                        PSYS_PART_END_COLOR, endColor,
                        PSYS_PART_START_SCALE,startSize,
                        PSYS_PART_END_SCALE,endSize, 
                        PSYS_SRC_PATTERN, pattern,
                        PSYS_SRC_BURST_RATE,rate,
                        PSYS_SRC_ACCEL, push,
                        PSYS_SRC_BURST_PART_COUNT,count,
                        PSYS_SRC_BURST_RADIUS,radius,
                        PSYS_SRC_BURST_SPEED_MIN,minSpeed,
                        PSYS_SRC_BURST_SPEED_MAX,maxSpeed,
                        PSYS_SRC_TARGET_KEY,target,
                        PSYS_SRC_INNERANGLE,innerAngle, 
                        PSYS_SRC_OUTERANGLE,outerAngle,
                        PSYS_SRC_OMEGA, omega,
                        PSYS_SRC_MAX_AGE, life,
                        PSYS_SRC_TEXTURE, texture,
                        PSYS_PART_START_ALPHA, startAlpha,
                        PSYS_PART_END_ALPHA, endAlpha
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
        else if (message=="startupflame") { updateParticles(); llSetTimerEvent(1.0); } 
    }
    
    timer() {
        llParticleSystem([]);
        llSetTimerEvent(0.0);
    }

}