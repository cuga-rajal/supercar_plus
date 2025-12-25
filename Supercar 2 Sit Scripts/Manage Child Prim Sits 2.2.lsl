// Manage Child Prim Sits 2.2
// By Cuga Rajal (cuga@rajal.org) - An accessory script for the Supercar Plus package
// For the latest version and more information visit https://github.com/cuga-rajal/supercar_plus/ 
// This work is licensed under the Creative Commons BY-NC-SA 3.0 License: https://creativecommons.org/licenses/by-nc-sa/3.0/
 
// ** New in version 2.1: Touch object to adjust your avatar!
// ** New in version 2.2: Remembers your previous adjustments!

// Instructions:
// 1. Create individual sits in child prims with individual sit scripts and animations
//    Adjust the sit offsets on each sit prim for specific animations.
// 2. For each seat prim,
//    a) copy the exact name of the animation to the prim Description,
//    b) set the prim Name to the word "sit",
//    c) Place a copy of the seat's animation into the root prim
//    d) then remove the sit script and the animation from the seat prim
// 3. Place a copy of this script in the root prim

// Configurable Settings 

float alpha_not_sit = 1.0; // alpha when not seated. 1 = opaque, 0 = transparent
float alpha_on_sit = 1.0;  // alpha when seated
string sit_message = "Touch the object to adjust your avatar"; // local chat message to each person who just sat down
float dialog_timeout = 60; // seconds for dialog timeout
vector eigenvec = ZERO_VECTOR; // Object rotation in degrees when upright and facing East
                               // This corrects the movement directions when adjusting the avatar

// end of configurable settings 

list sitprims; 
integer i; 
integer numprims; 
integer totalprims;
string dancename;
key av;

integer menu_handler; 
integer menu_channel;
list adjust_list = [ "Back", "Right", "Down", "Fwd", "Left", "Up" ];
list avis;
list offsets;

default {
    state_entry() {
        totalprims = llGetObjectPrimCount(llGetKey());
        for(i=2; i<= llGetObjectPrimCount(llGetKey()); i++) {
            if(llList2String(llGetLinkPrimitiveParams(i, [PRIM_NAME]), 0) == "sit") { sitprims += i; }
        }
        menu_channel = (integer)(200 + llFrand(99799.0) * -1); //random channel 
        menu_handler = llListen(menu_channel,"","",""); 
        llListenControl(menu_handler, FALSE);
    }
    
    on_rez(integer t) {
        // So if you rez multiple items they won't share channels
        llListenRemove(menu_handler);
        menu_channel = (integer)(200 + llFrand(99799.0) * -1); //random channel 
        menu_handler = llListen(menu_channel,"","",""); 
        av = NULL_KEY;
    }

    changed(integer change) {     
        if (change & CHANGED_LINK) {
            if(totalprims != llGetObjectPrimCount(llGetKey())) { // prim was added or removed
                llResetScript();
            } else if(llGetNumberOfPrims() > numprims) {  // someone just sat down
                av = llGetLinkKey(llGetNumberOfPrims());
                for(i=0; i<llGetListLength(sitprims); i++) {
                    if(llAvatarOnLinkSitTarget(llList2Integer(sitprims,i)) == av) {
                        if(alpha_not_sit != alpha_on_sit) {
                            llSetLinkAlpha(llList2Integer(sitprims,i), alpha_on_sit, ALL_SIDES);
                        }
                        dancename = llList2String(llGetLinkPrimitiveParams(llList2Integer(sitprims,i), [PRIM_DESC]), 0);
                        if(sit_message != "") { llRegionSayTo(av, 0, sit_message); }
                        llRequestPermissions(av, PERMISSION_TRIGGER_ANIMATION);
                        jump done; 
                    }
                }
                @done;
            } else {  // someone stood up
                if(alpha_not_sit != alpha_on_sit){
                    for(i=0; i<llGetListLength(sitprims); i++) {
                        if(llAvatarOnLinkSitTarget(llList2Integer(sitprims,i)) == NULL_KEY) {
                            llSetLinkAlpha(llList2Integer(sitprims,i), alpha_not_sit, ALL_SIDES);
                        }
                    }
                }
            }
            numprims = llGetNumberOfPrims();
        }
    }
    
    run_time_permissions(integer perm) {
        if(perm & PERMISSION_TRIGGER_ANIMATION ){
            llStopAnimation("sit");
            llStartAnimation(dancename);
            integer avoffset = llListFindList(avis, [(string)av]);
            if(avoffset!=-1) {
                for(i=llGetObjectPrimCount(llGetKey())+1; i<=llGetNumberOfPrims(); i++) {
                    if(llGetLinkKey(i)==av) {
                        vector currpos = llList2Vector(llGetLinkPrimitiveParams(i, [PRIM_POS_LOCAL]), 0);
                        llSetLinkPrimitiveParamsFast(i, [PRIM_POS_LOCAL, (currpos + llList2Vector(offsets,avoffset)) ]);
                    }
                    jump found;
                }
                @found;
                llRegionSayTo(av,0,"Recognized " + llKey2Name(av) + ", sit adjustments restored.");
            }
        }
    }
    
    touch_start(integer total_number) { 
        for(i=0; i<llGetListLength(sitprims); i++) {
            if(llAvatarOnLinkSitTarget(llList2Integer(sitprims,i)) == llDetectedKey(0)) {
                llDialog(llDetectedKey(0),"\nAdjust Avatar Position:", adjust_list, menu_channel); 
                llListenControl(menu_handler, TRUE);
                if(dialog_timeout !=0) {  llSetTimerEvent(dialog_timeout); }
                return;
            }
        }
    }
    
    listen(integer channel,string name,key id,string message)  { 
        for(i=llGetObjectPrimCount(llGetKey())+1; i<=llGetNumberOfPrims(); i++) {
            if(llGetLinkKey(i)==id) {
                llSetTimerEvent(0.0);
                if((message == "Fwd") || (message == "Back") || (message == "Left") || (message == "Right") || (message == "Up") || (message == "Down")) {
                    vector newpos;
                    rotation eigenrot = llEuler2Rot(eigenvec * DEG_TO_RAD);
                    // if movement relative to child prim rotation is desired you can do:
                    // integer j;
                    // for j=2; j<=llGetObjectPrimCount(llGetKey()); j++) {
                	//	if(llAvatarOnLinkSitTarget(j)==id) {
                    //		eigenrot = eigenrot * llList2Rot(llGetLinkPrimitiveParams(j,[PRIM_ROT_LOCAL]),0);
                    //		jump done;
                    //	}
                    // }
                    // @done;
                    if(message == "Fwd") { newpos = <0.02,0,0> / eigenrot; }
                    else if(message == "Back") { newpos = <-0.02,0,0> / eigenrot; }
                    else if(message == "Left") { newpos = <0,0.02,0> / eigenrot; }
                    else if(message == "Right") { newpos = <0,-0.02,0> / eigenrot; }
                    else if(message == "Up") { newpos = <0,0,0.02> / eigenrot; }
                    else if(message == "Down") { newpos = <0,0,-0.02> / eigenrot; }
                    vector currpos = llList2Vector(llGetLinkPrimitiveParams(i, [PRIM_POS_LOCAL]), 0);
                    llSetLinkPrimitiveParamsFast(i, [PRIM_POS_LOCAL, (currpos + newpos) ]);
                    integer avoffset = llListFindList(avis, [(string)id]);
                    if(avoffset==-1) {
                        avis += [(string)id];
                        offsets  += [newpos];
                    } else {
                        vector noff = llList2Vector(offsets, avoffset);
                        noff = noff + newpos;
                        offsets = llListReplaceList(offsets,[noff],avoffset,avoffset);
                    }
        
                    llDialog(id,"\nAdjust Avatar Position:", adjust_list, menu_channel); 
                    llListenControl(menu_handler, TRUE);
                    if(dialog_timeout !=0) {  llSetTimerEvent(dialog_timeout); }
                    jump found;
                }
            }
        }
        @found;

    }
    
    timer() {
        llListenControl(menu_handler, FALSE);
        llSetTimerEvent(0.0);
    }
              
}
