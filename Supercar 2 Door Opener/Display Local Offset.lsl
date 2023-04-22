// Display Local Offset
// By Cuga Rajal (cuga@rajal.org) - An accessory script for the Supercar Plus package
// For the latest version and more information visit https://github.com/cuga-rajal/supercar_plus/ 
// This work is licensed under the Creative Commons BY-NC-SA 3.0 License: https://creativecommons.org/licenses/by-nc-sa/3.0/

default{

    state_entry(){

    }

    touch_start(integer touchCount){
        
        list params = llGetPrimitiveParams([PRIM_POS_LOCAL, PRIM_ROT_LOCAL]);
        
        string str = "object offset position: " + (string)llList2Vector(params, 0) + "\n" +
                    "object offset rotation: " + (string)(llRot2Euler(llList2Rot(params, 1)) * RAD_TO_DEG);
        
        llOwnerSay(str);
    }
}
