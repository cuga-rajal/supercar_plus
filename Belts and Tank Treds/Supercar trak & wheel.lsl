// Trak script by Xiija Anju, adapted for the Supercar Plus by Cuga Rajal, version 1.0
// This script can be used as a companion to the Supercar Plus script to trigger texture animations
// typically used for belts or treds of a tank, for example. It supports forward and backward motion.
// Texture animation is triggered by signals from the Supercar Plus script.
// Only one copy of the script is needed for the car. It can be placed in any prim.
// For Supercar versions 1.72 or earlier the script must be placed in a child prim.
// It will manage texture animation for all prims given the name "trak" (without quotes) 

list traks;
list wheel1;
list wheel2;
list wheel3;
integer x;
integer i;
float rate=0;
vector wheel_size;
float spinstate;
vector wheel_rotation;
integer totalprims;

getTraks() {
    integer prims=llGetNumberOfPrims();  
    for(x = 1; x <= prims; ++x) {  
        list params = llGetLinkPrimitiveParams(x, [PRIM_NAME, PRIM_DESC]);
        if (llList2String(params,0) == "trak") { traks += x; }      
        else if (llList2String(params,1) == "wheel1") { wheel1 += x; }    
        else if (llList2String(params,1) == "wheel2") { wheel2 += x; }    
        else if (llList2String(params,1) == "wheel3") { wheel3 += x; }      
    }  
}

doTraks(integer k) {
    if( k==1 ) {
        integer len = llGetListLength(traks);
        for(x = 0; x < len; x++) {
            i = llList2Integer(traks,x);
            llSetLinkTextureAnim( i , ANIM_ON | SMOOTH | LOOP , ALL_SIDES, 1, 1, 1, 1, -0.14);    
        }
    } else if(k==2) {
        integer len = llGetListLength(traks);
        for(x = 0; x < len; x++) {
            i = llList2Integer(traks,x);
            llSetLinkTextureAnim( i , ANIM_ON | SMOOTH | LOOP , ALL_SIDES, 1, 1, 1, 1, 0.14);    
        }
    } else {
        llSetLinkTextureAnim( LINK_SET, FALSE, 1, 0, 0, 0.0, 0.0, 1.0);
    }
}


default {
    state_entry() {
        getTraks();
        totalprims = llGetObjectPrimCount(llGetKey());
        wheel_size = llGetScale();
    }
    
    changed(integer change) {      
        if (change & CHANGED_LINK) {
            if(llGetObjectPrimCount(llGetKey()) != totalprims) {
                llResetScript();
            }
        }
    }

    link_message(integer sender, integer num, string str, key id) {

        if (str == "ForwardSpin")    {
            doTraks(1);
            rate = 1.32 * num/wheel_size.y;
            if(spinstate != rate) {
                wheel_rotation = <0,1.2,0.0>;
                for(i=0; i<llGetListLength(wheel1); i++) {
                    llSetLinkPrimitiveParamsFast(llList2Integer(wheel1, i), [PRIM_OMEGA, wheel_rotation, rate, 1.0]);
                }
                wheel_rotation = <0,1.6,0.0>;
                for(i=0; i<llGetListLength(wheel2); i++) {
                    llSetLinkPrimitiveParamsFast(llList2Integer(wheel2, i), [PRIM_OMEGA, wheel_rotation, rate, 1.0]);
                }
                wheel_rotation = <0,2.0,0.0>;
                for(i=0; i<llGetListLength(wheel3); i++) {
                    llSetLinkPrimitiveParamsFast(llList2Integer(wheel3, i), [PRIM_OMEGA, wheel_rotation, rate, 1.0]);
                }
                spinstate = rate;
            }
        }
        else if (str == "BackwardSpin") {
            doTraks(2);
            rate = -1.32 * num/wheel_size.y;
            if(spinstate != rate) {
                wheel_rotation = <0,1.2,0.0>;
                for(i=0; i<llGetListLength(wheel1); i++) {
                    llSetLinkPrimitiveParamsFast(llList2Integer(wheel1, i), [PRIM_OMEGA, wheel_rotation, rate, 1.0]);
                }
                wheel_rotation = <0,1.6,0.0>;
                for(i=0; i<llGetListLength(wheel2); i++) {
                    llSetLinkPrimitiveParamsFast(llList2Integer(wheel2, i), [PRIM_OMEGA, wheel_rotation, rate, 1.0]);
                }
                wheel_rotation = <0,2.0,0.0>;
                for(i=0; i<llGetListLength(wheel3); i++) {
                    llSetLinkPrimitiveParamsFast(llList2Integer(wheel3, i), [PRIM_OMEGA, wheel_rotation, rate, 1.0]);
                }
                spinstate = rate;
            }
        }
        else if (str == "NoSpin") {
            doTraks(0);
            rate = 0;
            if(spinstate != rate) {
                wheel_rotation = <0,1.2,0.0>;
                for(i=0; i<llGetListLength(wheel1); i++) {
                    llSetLinkPrimitiveParamsFast(llList2Integer(wheel1, i), [PRIM_OMEGA, wheel_rotation, rate, 1.0]);
                    llSleep(0.2);
                    llSetLinkPrimitiveParamsFast(llList2Integer(wheel1, i), [PRIM_ROT_LOCAL, llEuler2Rot(<0, 270, 270> * DEG_TO_RAD)]);
                }
                wheel_rotation = <0,1.6,0.0>;
                for(i=0; i<llGetListLength(wheel2); i++) {
                    llSetLinkPrimitiveParamsFast(llList2Integer(wheel2, i), [PRIM_OMEGA, wheel_rotation, rate, 1.0]);
                    llSleep(0.2);
                    llSetLinkPrimitiveParamsFast(llList2Integer(wheel2, i), [PRIM_ROT_LOCAL, llEuler2Rot(<0, 270, 270> * DEG_TO_RAD)]);
                }
                wheel_rotation = <0,2.0,0.0>;
                for(i=0; i<llGetListLength(wheel3); i++) {
                    llSetLinkPrimitiveParamsFast(llList2Integer(wheel3, i), [PRIM_OMEGA, wheel_rotation, rate, 1.0]);
                    llSleep(0.2);
                    llSetLinkPrimitiveParamsFast(llList2Integer(wheel3, i), [PRIM_ROT_LOCAL, llEuler2Rot(<0, 270, 270> * DEG_TO_RAD)]);
                }
                spinstate = rate;
            }
        }
    }
}
