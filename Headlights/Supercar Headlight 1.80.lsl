// Headlight Source 1.80
// For use with Supercar Plus script version 1.80 or higher (https://github.com/cuga-rajal/supercar_plus)
// Place this in a prim that is supposed to be the actual headlight, not the beam
// It will respond to link messages from the main script or HUD

integer shine = TRUE;
integer projector = TRUE;
integer face = 2;
vector color = <1,1,1>;
float intensity = 1.0;
float radius = 20;
float falloff = 0.25;
float glow = .15;

lightsOn() {
    if(shine) {
        llSetPrimitiveParams([
        PRIM_GLOW, face, glow,
        PRIM_FULLBRIGHT, face, TRUE
        ]);
    }
    if(projector) {
        llSetPrimitiveParams([
        PRIM_POINT_LIGHT, TRUE, color, intensity, radius, falloff
        ]);
    }
}

lightsOff() {
    if(shine) {
        llSetPrimitiveParams([
        PRIM_GLOW, face, 0,
        PRIM_FULLBRIGHT, face, FALSE
        ]);
    }
    if(projector) {
        llSetPrimitiveParams([
        PRIM_POINT_LIGHT, FALSE, color, intensity, radius, falloff
        ]);
    }
}



default{

    state_entry() {
        lightsOff();
    }
    
    link_message(integer sender, integer num, string message, key id){
        if((message=="car_start") || (message=="headlight")) { lightsOn(); }
        else if((message=="car_stop") || (message=="headlightoff")) { lightsOff(); }
    }
}
