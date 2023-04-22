// Headlight Source 1.80
// By Cuga Rajal (cuga@rajal.org) - An accessory script for the Supercar Plus package
// For the latest version and more information visit https://github.com/cuga-rajal/supercar_plus/ 
// This work is licensed under the Creative Commons BY-NC-SA 3.0 License: https://creativecommons.org/licenses/by-nc-sa/3.0/

// Configurable settings

integer shine = TRUE;
integer projector = TRUE;
integer face = 2; // prim face number or ALL_SIDES; used with shine setting
float glow = .15; // glow value used with shine setting
vector color = <1,1,1>; // used with projector setting
float intensity = 1.0; // used with projector setting
float radius = 20; // used with projector setting
float falloff = 0.25; // used with projector setting

// End of configurable settings

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
