// Supercar Plus rear wheel 1.6
// For use with Supercar Plus script (https://github.com/cuga-rajal/supercar_plus)
//
// Place this script in the contents of rear wheel prims
// This will rotate the wheel prim at correct rotation for wheel diameter and ground speed
// This script rotates the prim, so the texture appears correct on both inner and outer sides.
// Notes:
// 1. This script is pre-configured for cylinder shape prim wheels
// 2. Mesh and other type wheels may be used by adjusting values of wheel_rotation, turnl, turnr, turnc
// 3. Depending on the prim orientation, the wheel may spin in the opposite direction from desired.
//    If this happens, either rotate the prim orientation by 180 degrees, or change the lines below
//    that start with "rate = .." to the opposite values (negative to positive and positive to negative)


float rate=0;
vector wheel_size =<0,0,0>;
float spinstate;

// cylinder prim
vector wheel_rotation = <0,0,1>;
// Example settings for mesh wheels:
// mesh wheel - Offroad Car
//vector wheel_rotation = <0,0,.84>;
// mesh wheel - Scortcher
//vector wheel_rotation = <-.4,0.0,0.0>;
// mesh wheel - porsche supercar
//vector wheel_rotation = <0,0.2,0>;
// mesh wheel - custom wheel
//vector wheel_rotation = <0,0.16,0>;

default {
    state_entry() {
        wheel_size = llGetScale();
        vector wheelrot = llRot2Euler(llGetLocalRot())*RAD_TO_DEG;
        if((wheelrot.x > 2.00) || (wheelrot.y > 2.00)) { wheel_rotation = <wheel_rotation.x * -1, wheel_rotation.y * -1, wheel_rotation.z * -1>; }
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