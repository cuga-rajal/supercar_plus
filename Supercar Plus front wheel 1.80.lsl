// Supercar Plus front wheel 1.80
// For use with Supercar Plus script (https://github.com/cuga-rajal/supercar_plus)
//
// Place this script in the contents of front wheel prims
// This will rotate the wheel prim at correct rotation for wheel diameter and ground speed
// And will turn the front wheel left or right when the vehicle is turning.
// This script rotates the prim, so the texture appears correct on both inner and outer sides.
//
// Notes:
// This script is pre-configured for cylinder regular prim wheels.
// For regular cylinder prim wheels, the same script can be used for left and right front wheels.
//
// Mesh wheels:
// Values for "wheel_rotation", "turnl", "turnr", and "turnc" will need to be configured manually for mesh.
// The same script can be used for left and right front wheels but the configuration will differ.
// There is no way to automate the correct rotation direction on mesh rotation.
// The configuration can be determined through a short discovery process and updating the settings manually.
// You can use "wheel_rotation" value from a rear wheel using the same type prim on the same side of the car.
// Determine "turnl", "turnr", and "turnc" vectors visually using a similar process as the rear wheel.
// Values for "turnl", "turnr", and "turnc" will be different for left and right front wheels.
// Some examples of mesh wheel settings are shown in comments below.

rotation turnl;
rotation turnr;
rotation turnc;
rotation newrot;
float rate=0;
vector wheel_size;
rotation turnstate;
float spinstate;

// cylinder prim
vector wheel_rotation = <0,0,0.7>;
// mesh wheel - Offroad Car
//vector wheel_rotation = <0,0,.84>;
// mesh wheel - Scortcher
//vector wheel_rotation = <-.4,0.0,0.0>;
// mesh wheel - porsche supercar
// vector wheel_rotation = <0,0.2,0>;

default {
    state_entry() {
        wheel_size = llGetScale();
        // If the prim is a regular cylinder we try to detect reverse orientation and adjust
        integer isreversed = FALSE;
        if(llList2Integer(llGetPrimitiveParams([ PRIM_TYPE ]), 0)==1) {
            vector wheelrot = llRot2Euler(llGetLocalRot())*RAD_TO_DEG;
            if(wheelrot.x < 180) { isreversed = TRUE; }
            if(isreversed) { wheel_rotation = <0, 0, wheel_rotation.z * -1>; }
        }
        
        // Specify "turnl", "turnr", and "turnc" vectors. Values are preconfigured for regular cylinder prims.
        // Some past examples for various mesh wheels are shown in comments.

        // cylinder prims - left and right wheels
        if(! isreversed) {
            turnl = llEuler2Rot(DEG_TO_RAD * <90,210,0>);
            turnr = llEuler2Rot(DEG_TO_RAD * <90,150,0>);
            turnc = llEuler2Rot(DEG_TO_RAD * <90,180,0>);
        } else {
            turnl = llEuler2Rot(DEG_TO_RAD * <90,30,0>);
            turnr = llEuler2Rot(DEG_TO_RAD * <90,330,0>);
            turnc = llEuler2Rot(DEG_TO_RAD * <90,0,0>);
        }
        
        // mesh wheel - Offroad Car
        // **right front wheel
        //turnl = llEuler2Rot(DEG_TO_RAD * <90,210,0>);
        //turnr = llEuler2Rot(DEG_TO_RAD * <90,150,0>);
        //turnc = llEuler2Rot(DEG_TO_RAD * <90,180,0>);
        // **left front wheel
        //turnl = llEuler2Rot(DEG_TO_RAD * <90,30,0>);
        //turnr = llEuler2Rot(DEG_TO_RAD * <90,-30,0>);
        //turnc = llEuler2Rot(DEG_TO_RAD * <90,0,0>);
        
        // mesh wheel - Scortcher
        // **right front wheel
        //turnl = llEuler2Rot(DEG_TO_RAD * <90,120,0>);
        //turnr = llEuler2Rot(DEG_TO_RAD * <90,60,0>);
        //turnc = llEuler2Rot(DEG_TO_RAD * <90,90,0>);
        // **left front wheel
        //turnl = llEuler2Rot(DEG_TO_RAD * <90,300,0>);
        //turnr = llEuler2Rot(DEG_TO_RAD * <90,240,0>);
        //turnc = llEuler2Rot(DEG_TO_RAD * <90,270,0>);
        
        // mesh wheel - porsche supercar
        //vector vec = llRot2Euler(llGetLocalRot());
        //float x = vec.x;
        //float y = vec.y;
        //float z = vec.z;
        // **right front wheel
        //turnl = llEuler2Rot(DEG_TO_RAD * <x,y,30>);
        //turnr = llEuler2Rot(DEG_TO_RAD * <x,y,330>);
        //turnc = llEuler2Rot(DEG_TO_RAD * <x,y,0>);
        // **left front wheel
        //turnl = llEuler2Rot(DEG_TO_RAD * <x,y,30>);
        //turnr = llEuler2Rot(DEG_TO_RAD * <x,y,330>);
        //turnc = llEuler2Rot(DEG_TO_RAD * <x,y,0>);
        
        turnstate = turnc;
    }

    link_message(integer sender, integer num, string str, key id) {

        if(str == "SetMat")  {
            llSetPrimitiveParams([PRIM_MATERIAL, PRIM_MATERIAL_GLASS]);
        }
        else if ((str == "ForwardSpin"))   {
            rate = 1.32 * num/wheel_size.y;
            if(spinstate != rate) {
                llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_OMEGA, wheel_rotation * llGetLocalRot(), rate, 1.0]);
                spinstate=rate;
            }
        }
        else if ((str == "BackwardSpin"))   {
            rate = -1.32 * num/wheel_size.y;
            if(spinstate != rate) {
                llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_OMEGA, wheel_rotation * llGetLocalRot(), rate, 1.0]);
                spinstate=rate;
            }
        }
        else if ((str == "NoSpin")) {
            rate = 0;
            if(spinstate != rate) {
                llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_OMEGA, wheel_rotation * llGetLocalRot(), 0, 1.0]);
                spinstate=rate;
            }
        }
        else if((str == "LeftTurn") && (turnstate != turnl)) {
            turnstate = turnl;
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_OMEGA, wheel_rotation * llGetLocalRot(), 0, 1.0]);
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_ROT_LOCAL, turnl]);
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_OMEGA, wheel_rotation * llGetLocalRot(), spinstate, 1.0]);
        }
        else if ((str == "RightTurn") && (turnstate != turnr)) {
            turnstate = turnr;
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_OMEGA, wheel_rotation * llGetLocalRot(), 0, 1.0]);
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_ROT_LOCAL, turnr]);
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_OMEGA, wheel_rotation * llGetLocalRot(), spinstate, 1.0]);
        }
        else if ((str == "NoTurn") && (turnstate != turnc)) {
            turnstate = turnc;
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_OMEGA, wheel_rotation * llGetLocalRot(), 0, 1.0]);
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_ROT_LOCAL, turnc]);
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_OMEGA, wheel_rotation * llGetLocalRot(), spinstate, 1.0]);
        }
    }
}

