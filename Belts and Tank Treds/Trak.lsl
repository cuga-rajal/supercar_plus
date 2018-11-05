// Trak script by Xiija Anju, adapted for the Supercar Plus by Cuga Rajal, version 1.0
// This script can be used as a companion to the Supercar Plus script to trigger texture animations
// typically used for belts or treds of a tank, for example. It supports forward and backward motion.
// Texture animation is triggered by signals from the Supercar Plus script.
// Only one copy of the script is needed for the car. It can be placed in any prim.
// For Supercar versions 1.72 or earlier the script must be placed in a child prim.
// It will manage texture animation for all prims given the name "trak" (without quotes) 

list traks;

getTraks() {
	integer prims=llGetNumberOfPrims();  
	for(integer x = 2; x <= prims; ++x) {
		string lName = llGetLinkName(x);       
        list my_list = llParseString2List(lName,[" "],[","]);       
		if (llList2String(my_list,0) == "trak") {
			traks += x;          
		} 
	}  
}

doTraks(integer k) {
    if( k==1 ) {
        integer len = llGetListLength(traks);
        for(integer n = 0; n < len; n++) {
            integer i = llList2Integer(traks,n);
            llSetLinkTextureAnim( i , ANIM_ON | SMOOTH | LOOP , ALL_SIDES, 1, 1, 1, 1, 0.25);    
        }
    } else if(k==2) {
        integer len = llGetListLength(traks);
        for(integer n = 0; n < len; n++) {
            integer i = llList2Integer(traks,n);
            llSetLinkTextureAnim( i , ANIM_ON | SMOOTH | LOOP , ALL_SIDES, 1, 1, 1, 1, -0.25);    
        }
    } else {
        llSetLinkTextureAnim( LINK_SET, FALSE, 1, 0, 0, 0.0, 0.0, 1.0);
    }
}


default {
    state_entry() {
        getTraks();
    }

    link_message(integer sender, integer num, string str, key id) {

        if (str == "ForwardSpin")    {
            doTraks(1);
        }
        else if (str == "BackwardSpin") {
            doTraks(2);
        }
        else if (str == "NoSpin") {
            doTraks(0);
        }
    }
}
