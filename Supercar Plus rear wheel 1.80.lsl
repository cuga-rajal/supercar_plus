// Supercar Plus rear wheel 1.62
// For use with Supercar Plus script (https://github.com/cuga-rajal/supercar_plus)
//
// Place this script in the contents of rear wheel prims
// This will rotate the wheel prim at correct rotation for wheel diameter and ground speed
// This script rotates the prim, so the texture appears correct on both inner and outer sides.
//
// Notes:
// This script is pre-configured for cylinder prim wheels.
// For regular cylinder prim wheels, the same script can be used for left and right front wheels.
//
// Mesh wheels:
// Value for "wheel_rotation" will need to be configured manually for mesh.
// The same script can be used for left and right front wheels but the configuration will differ.
// There is no way to automate the correct rotation direction on mesh rotation.
// The configuration can be determined through a short discovery process and updating the settings manually.
// First, get the wheel moving in the correct orientation by trying different axes, such as <1,0,0>, <0,1,0> or <0,0,1>.
// Then adjust the value (raising or lowering the number 1) so the rotation speed looks correct.
// Use a negative number to change the direction of spin.
// Some example mesh wheel settings are shown in comments below.

float rate=0;
vector wheel_size =<0,0,0>;
float spinstate;

// cylinder prim
vector wheel_rotation = <0,0,0.7>;
// Example settings for mesh wheels:
// mesh wheel - Offroad Car:
//  vector wheel_rotation = <0,0,.84>;
// mesh wheel - Scortcher:
//  vector wheel_rotation = <-.4,0.0,0.0>;
// mesh wheel - porsche supercar:
//  vector wheel_rotation = <0,0.2,0>;
// mesh wheel - custom wheel:
//  vector wheel_rotation = <0,0.16,0>;

default {
    state_entry() {
        wheel_size = llGetScale();
        // If the prim is a regular cylinder we try to detect reverse orientation and adjust
        if(llList2Integer(llGetPrimitiveParams([ PRIM_TYPE ]), 0)==1) {
            vector wheelrot = llRot2Euler(llGetLocalRot())*RAD_TO_DEG;
            if((wheelrot.x > 2.00) || (wheelrot.y > 2.00)) { wheel_rotation = <0, 0, wheel_rotation.z * -1>; }
        }
    }

    link_message(integer sender, integer num, string str, key id) {

        if(str == "SetMat")  {
            llSetPrimitiveParams([PRIM_MATERIAL, PRIM_MATERIAL_GLASS]);
        }
        else if (str == "ForwardSpin")    {
            rate = 1.32 * num/wheel_size.y;
            if(spinstate != rate) {
                llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_OMEGA, wheel_rotation * llGetLocalRot(), rate, 1.0]);
                spinstate = rate;
            }
        }
        else if (str == "BackwardSpin") {
            rate = -1.32 * num/wheel_size.y;
            if(spinstate != rate) {
                llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_OMEGA, wheel_rotation * llGetLocalRot(), rate, 1.0]);
                spinstate = rate;
            }
        }
        else if (str == "NoSpin") {
            rate = 0;
            if(spinstate != rate) {
                llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_OMEGA, wheel_rotation * llGetLocalRot(), 0, 1.0]);
                spinstate = rate;
            }
        }
    }
}