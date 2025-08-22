// Sit w/Animationt 2.0
// By Cuga Rajal (cuga@rajal.org) - An accessory script for the Supercar Plus package
// For the latest version and more information visit https://github.com/cuga-rajal/supercar_plus/ 
// This work is licensed under the Creative Commons BY-NC-SA 4.0 License: https://creativecommons.org/licenses/by-nc-sa/4.0/

// Configurable settings

integer setoffset = TRUE; // set to FALSE if you are using a sit positioning system
vector sitposition = <0, 0, 0.5>;  // position relative to prim center <fwd-back, left-right, up-down> 
vector sitrotation = <0, 0, 0>; // rotation in degrees, relative to prim orientation
float alpha_not_sit = 1.0; // alpha when not seated. 1 = fully opaque
float alpha_on_sit = 1.0;  // alpha when seated. 0 = fully transparent
string sittext = ""; // Replaces "Sit" in Pie Menu. Set to "" to disable
string hovertext = ""; // Hover text when nobody sitting. Set to "" to disable
vector hovercolor = <1.0, 1.0, 1.0>; // Color of hover text if used
float dialog_timeout = 30; // seconds for dialog timeout

// end of configurable settings

integer i;
integer count;
key av = NULL_KEY;
key lastav = NULL_KEY;
integer menu_handler; 
integer menu_channel;
list adjust_list = [ "Right", "Up", "Down", "Fwd", "Back", "Left" ];

menu(key user,string title,list object_list)  { 
    menu_channel = (integer)(llFrand(99999.0) * -1); //random channel 
    menu_handler = llListen(menu_channel,"","",""); 
    llDialog(user,title,object_list,menu_channel); 
    if(dialog_timeout !=0) {  llSetTimerEvent(dialog_timeout); } //limit time menu channel is open
} 

default {
    state_entry() {
        if(setoffset) {
            rotation sitrot = llEuler2Rot(sitrotation * DEG_TO_RAD);
            llSitTarget(sitposition, sitrot);
        }
        if(alpha_not_sit != alpha_on_sit) { llSetAlpha(alpha_not_sit, ALL_SIDES); }
        if(sittext != "") { llSetSitText(sittext); }
        if(hovertext != "") { llSetText(hovertext,hovercolor,1.0); }
    }
    
    on_rez(integer param)  {
        av = NULL_KEY;
        key lastav = NULL_KEY;
    }

    run_time_permissions(integer perm) {
        if(perm & PERMISSION_TRIGGER_ANIMATION ){
            count = llGetInventoryNumber(INVENTORY_ANIMATION);
            if (count != 0) {
                llStopAnimation("sit");
                llStartAnimation(llGetInventoryName(INVENTORY_ANIMATION, 0));
            }
        }
        if(alpha_not_sit != alpha_on_sit) { llSetAlpha(alpha_on_sit, ALL_SIDES); }
        if(hovertext != "") { llSetText("",hovercolor,1.0); }
        // Add here anything else you want to happoen when avatar sits
        
    }
    changed(integer change) {
        if (change & CHANGED_LINK){
            av = llAvatarOnSitTarget();
            if ((av == NULL_KEY) && (av != lastav)) {
                if(alpha_not_sit != alpha_on_sit) { llSetAlpha(alpha_not_sit, ALL_SIDES); }
                if((llGetPermissions() & PERMISSION_TRIGGER_ANIMATION) && (llGetAgentSize(lastav)!=ZERO_VECTOR)) {
                    count = llGetInventoryNumber(INVENTORY_ANIMATION);
                    if (count != 0) {
                        llStopAnimation(llGetInventoryName(INVENTORY_ANIMATION, 0));
                    }
                }
                if(hovertext != "") { llSetText(hovertext,hovercolor,1.0); }
                // Add here anything else you want to happen when avatar stands

            } else if(av != lastav) {
                llRequestPermissions(av, PERMISSION_TRIGGER_ANIMATION);
            }
            lastav = av;
        }
    }
    
    touch_start(integer total_number) { 
    	if((av != NULL_KEY) && (av == llDetectedKey(0))) {
    		menu(av, "\nAdjust Avatar Position:", adjust_list); 
    	}
    }
    
    listen(integer channel,string name,key id,string message)  { 
        if ((channel == menu_channel) && (id == av)) {
        	llListenRemove(menu_handler); 
        	if((message == "Fwd") || (message == "Back") || (message == "Left") || (message == "Right") || (message == "Up") || (message == "Down")) {
                vector newpos;
                if(message == "Fwd") { newpos = <0.02,0,0> * llGetLocalRot(); }
                else if(message == "Back") { newpos = <-0.02,0,0> * llGetLocalRot(); }
                else if(message == "Left") { newpos = <0,0.02,0> * llGetLocalRot(); }
                else if(message == "Right") { newpos = <0,-0.02,0> * llGetLocalRot(); }
                else if(message == "Up") { newpos = <0,0,0.02> * llGetLocalRot(); }
                else if(message == "Down") { newpos = <0,0,-0.02> * llGetLocalRot(); }
                for(i=llGetObjectPrimCount(llGetKey())+1; i<=llGetNumberOfPrims(); i++) {
                	if(llGetLinkKey(i)==av) {
                		vector currpos = llList2Vector(llGetLinkPrimitiveParams(i, [PRIM_POS_LOCAL]), 0);
                		llSetLinkPrimitiveParamsFast(i, [PRIM_POS_LOCAL, (currpos + newpos) ]);
                	}
                	jump found;
                }
                @found;
                menu(av, "\nAdjust Avatar Position:", adjust_list); 
        	}
        }
    }
    
    timer() {
        llListenRemove(menu_handler);
        llSetTimerEvent(0.0);  
        llRegionSayTo(av, 0, "Dialog listener has timed out. Please touch again to select.");
    }
    
}
