// Headlight Source 1.61
// For use with Supercar Plus script (https://github.com/cuga-rajal/supercar_plus)
// Place this in a prim that is supposed to be the actual headlight, not the beam
// It will respond to headlight signals from the HUD

integer face = 0;
vector color = <1,1,1>;
float intensity = 5;
float radius = 10;
float falloff = 5;
float glow = .25;

lightsOn(){
    llSetPrimitiveParams([
        PRIM_GLOW, face, glow,
        PRIM_FULLBRIGHT, face, TRUE,
        PRIM_POINT_LIGHT, TRUE, color, intensity, radius, falloff
    ]);
}

lightsOff(){
    llSetPrimitiveParams([
        PRIM_GLOW, face, 0,
        PRIM_FULLBRIGHT, face, FALSE,
        PRIM_POINT_LIGHT, FALSE, color, intensity, radius, falloff
    ]);
}



default{
    link_message(integer sender, integer num, string str, key id){
        if (str=="headlight"){ lightsOn();}
        else if (str=="headlightoff"){ lightsOff();}
    }
}
