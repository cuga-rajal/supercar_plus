// Supercar all Headlights 1.0
// For use with Supercar Plus script version 1.80 or higher (https://github.com/cuga-rajal/supercar_plus)
// Place this in any prim to control all headlights
// prim name "headlight" for face only and "headbeam" for projector only. For both on the same prim use "headlight headbeam"
// Only one face surface number is supported.


list faceprims;
list beamprims;
integer i; 
integer totalprims; 

integer shine = TRUE;
integer projector = TRUE;
integer face = 2; // can also be ALL_SIDES
vector color = <1,1,1>;
float intensity = 1.0;
float radius = 20;
float falloff = 0.25;
float glow = .15;

lightsOn() {
    for(i=0; i<llGetListLength(faceprims); i++) {
        llSetLinkPrimitiveParamsFast(llList2Integer(faceprims, i), [ PRIM_GLOW, face, glow, PRIM_FULLBRIGHT, face, TRUE ]);
    }
    for(i=0; i<llGetListLength(beamprims); i++) {
        llSetLinkPrimitiveParamsFast(llList2Integer(beamprims, i), [PRIM_POINT_LIGHT, TRUE, color, intensity, radius, falloff ]);
    }
}

lightsOff() {
    for(i=0; i<llGetListLength(faceprims); i++) {
        llSetLinkPrimitiveParamsFast(llList2Integer(faceprims, i), [ PRIM_GLOW, face, 0, PRIM_FULLBRIGHT, face, FALSE ]);
    }
    for(i=0; i<llGetListLength(beamprims); i++) {
        llSetLinkPrimitiveParamsFast(llList2Integer(beamprims, i), [PRIM_POINT_LIGHT, FALSE, color, intensity, radius, falloff ]);
    }
}

default {
    state_entry() {
        totalprims = llGetObjectPrimCount(llGetKey());
        for(i=2; i<= llGetObjectPrimCount(llGetKey()); i++) {
            if(llSubStringIndex(llList2String(llGetLinkPrimitiveParams(i, [PRIM_NAME]), 0), "headlight")!=-1) { faceprims += i; }
            if(llSubStringIndex(llList2String(llGetLinkPrimitiveParams(i, [PRIM_NAME]), 0), "headbeam")!=-1) { beamprims += i; }
        }
    } 

    changed(integer change) {     
        if (change & CHANGED_LINK) {
            if(totalprims != llGetObjectPrimCount(llGetKey())) { 
                llResetScript();
            }
        }
    }
    
    link_message(integer sender, integer num, string message, key id){
        if((message=="car_start") || (message=="headlight")) { lightsOn(); }
        else if((message=="car_stop") || (message=="headlightoff")) { lightsOff(); }
    }
              
}

