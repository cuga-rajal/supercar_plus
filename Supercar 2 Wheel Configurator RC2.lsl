// Supercar 2 Wheel Configurator RC2
// By Cuga Rajal (cuga@rajal.org) - An accessory script for the Supercar Plus package
// For the latest version and more information visit https://github.com/cuga-rajal/supercar_plus/ 
// This work is licensed under the Creative Commons BY-NC-SA 3.0 License: https://creativecommons.org/licenses/by-nc-sa/3.0/

// no configurable settings 

integer menu_channel;
integer menu_handler; 
integer stage = 0;
vector tryvec;
rotation rotlocal;
vector omega;
integer tryangle;
integer x; 
integer i;
 
menu(key user,string title,list object_list)  {  
    menu_channel = (integer)(llFrand(99999.0) * -1); //random channel 
    menu_handler = llListen(menu_channel,"","",""); 
    llDialog(user,title,object_list,menu_channel); 
}

string fixedprec2(float input) {
    string newval =  llGetSubString((string)input, 0, -5);
    if((integer)llGetSubString((string)input, -4, -4)>=5) { 
        if((float)newval>0) { newval = (string)((float)newval + 0.01); }
        else { newval = (string)((float)newval - 0.01); }
        newval = llGetSubString(newval, 0, -5);
    }
    if(input==(-1*input)) { newval="0"; }
    return(newval);
} 

string menutop(integer stage) {
    integer fw = FALSE;
    if(llList2String(llGetLinkPrimitiveParams(LINK_THIS, [PRIM_NAME]), 0)=="fwheel") { fw=TRUE; }
    string ntext =  "Supercar 2 Wheel Configurator       Step 1: Axis";
    if(stage ==1) { ntext += " ←"; } else { ntext += " ✔"; }
    ntext += "\n                                                     Step 2: Rotation︎";
    if(stage ==2) { ntext += " ←"; } else if(stage>2) { ntext += " ✔"; }
    ntext += "\n                                                     Step 3: Speed";
    if(stage ==3) { ntext += " ←"; } else if(stage>3) { ntext += " ✔"; }
    ntext += "\n\n";
    return(ntext);
}

start1() {
            if(llGetObjectPrimCount(llGetKey())<llGetNumberOfPrims()) {
                llOwnerSay("Unseating driver and passengers");
            }
            while(llGetObjectPrimCount(llGetKey())<llGetNumberOfPrims()) {
                llUnSit(llGetLinkKey(llGetNumberOfPrims()+1));
            }
                
            integer shape = llList2Integer(llGetLinkPrimitiveParams(LINK_THIS, [PRIM_TYPE]),0);
            if(shape==1) { tryvec = <0,0,0.7>; } // cylinder
            else if(shape==4) { tryvec = <0.7, 0, 0>; } // torus
            else if(shape==5) { tryvec = <0.7, 0, 0>; } // tube
            else if(shape==6) { tryvec = <0.7, 0, 0>; } // ring
            else {  tryvec = <0.7, 0, 0>; } // mesh or other
                
            rotlocal = llList2Rot(llGetLinkPrimitiveParams(LINK_THIS, [PRIM_ROT_LOCAL]), 0);
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_OMEGA, tryvec * rotlocal, 1.0, 1.0]);
                
            string menutext = menutop(stage);
            menutext += "Look at the wheel. Is it rotating on the correct axis?";
                
            menu(llGetOwner(), menutext, ["Yes", "No", "Exit"]);
}
 
start2() {
    string menutext = menutop(stage);
    menutext += "Is the wheel rotating in the correct direction?";
    menu(llGetOwner(), menutext, ["Yes", "No", "Exit"]);
}

start3() {
    llMessageLinked(1, 0, "wheelcalc", NULL_KEY);
    string menutext = menutop(stage);
    menutext += "Now drive the car in its slowest speed and watch the wheel. \nIs it rotating too fast or too slow?";
    menu(llGetOwner(), menutext, ["Too Fast/Slow", "Use This", "Exit"]);
}

stage3(string message) {
                vector newvec = tryvec;
                if(message == "-2%") {  newvec = <tryvec.x*0.98, tryvec.y*0.98, tryvec.z*0.98>; }
                else if(message == "-10%") {  newvec = <tryvec.x*0.9, tryvec.y*0.9, tryvec.z*0.9>; }
                else if(message == "-50%") {  newvec = <tryvec.x*0.5, tryvec.y*0.5, tryvec.z*0.5>; }
                else if(message == "+2%") {  newvec = <tryvec.x*1.02, tryvec.y*1.02, tryvec.z*1.02>; }
                else if(message == "+10%") {  newvec = <tryvec.x*1.1, tryvec.y*1.1, tryvec.z*1.1>; }
                else if(message == "+50%") {  newvec = <tryvec.x*1.5, tryvec.y*1.5, tryvec.z*1.5>; }
                tryvec = newvec;
                llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_DESC, (string)tryvec]);
                llMessageLinked(1, 0, "wheelcalc", NULL_KEY);  
                string menutext = menutop(stage);
                menutext += "Use the buttons below to adjust the speed. When the speed looks correct select \"Use This\".";
                menu(llGetOwner(), menutext, ["-2%","-10%", "-50%", "+2%","+10%", "+50%", "Use This"]);
}

default {
    state_entry() {
        llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_OMEGA, <0.7,0,0>, 0, 1.0]);
    }
    
    touch_start(integer total_number) {
        if(llDetectedKey(0)==llGetOwner()) {
            if(stage==0) {
                if((vector)llList2String(llGetLinkPrimitiveParams(LINK_THIS, [PRIM_DESC]), 0)!= ZERO_VECTOR) {
                    list choices = ["Axis","Direction","Speed", "Exit"]; 
                    menu(llGetOwner(),"Supercar 2 Wheel Configurator\n\nThis wheel appears to be already configured.\nChange:",choices);
                } else { 
                    menu(llGetOwner(),"Supercar 2 Wheel Configurator\n\nBegin wheel configuration?",["Begin", "Exit"]);
                }
            }
            else if(stage==1) { start1(); }
            else if(stage==2) { start2(); }
            else if(stage==3) { start3(); }
            else if(stage==4) { stage=3; start3(); }
        }
    }
    
    listen(integer channel, string name, key av, string message) {
        llListenRemove(menu_handler);
        if(message == "Exit") {
            llSetTimerEvent(0); 
            stage=0;
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_OMEGA, tryvec * rotlocal, 0, 1.0, PRIM_ROT_LOCAL, rotlocal]);
            llSetText("1", ZERO_VECTOR, 1.0);llSetText("", ZERO_VECTOR, 0.0);
        }
        else if((message == "Begin") || (message == "Axis")) {
            stage=1;
            start1();
        } else if(message == "Direction") {
            stage =2;
            tryvec = (vector)llList2String(llGetLinkPrimitiveParams(LINK_THIS, [PRIM_DESC]), 0);
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_OMEGA, tryvec, 0, 1.0]);
            llSetText("1", ZERO_VECTOR, 1.0);llSetText("", ZERO_VECTOR, 0.0);
            rotlocal = llList2Rot(llGetLinkPrimitiveParams(LINK_THIS, [PRIM_ROT_LOCAL]), 0);
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_OMEGA, tryvec * rotlocal, 1.0, 1.0]);
            start2();
        } else if(message == "Speed") {
            stage =3;
            tryvec = (vector)llList2String(llGetLinkPrimitiveParams(LINK_THIS, [PRIM_DESC]), 0);
            string menutext = menutop(stage);
            menutext += "Use the buttons below to adjust the speed. When the speed looks correct select \"Use This\".";
            menu(llGetOwner(), menutext, ["-2%","-10%", "-50%", "+2%","+10%", "+50%", "Use This"]);
        } else if(stage==1) {
            if(message == "Yes") {
                stage =2;
                start2();
            } else if(message == "No") {
                llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_OMEGA, tryvec * rotlocal, 0, 1.0]);
                llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_ROT_LOCAL, rotlocal]);
                llSetText("1", ZERO_VECTOR, 1.0);llSetText("", ZERO_VECTOR, 0.0);
                llSleep(1.0);
                vector newvec = <tryvec.y, tryvec.z, tryvec.x>;
                tryvec = newvec;

                llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_OMEGA, tryvec * rotlocal, 1.0, 1.0]);
                    
                string menutext = menutop(stage);
                menutext += "OK, changing rotation axis. Is it rotating on the correct axis?";
                menu(llGetOwner(), menutext, ["Yes", "No", "Exit"]);
                    
            }
        } else if(stage==2) {
            if(message == "Yes") {
                llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_OMEGA, tryvec * rotlocal, 0, 1.0, PRIM_DESC, (string)tryvec]);
                stage =3;
                start3();
                
            } else if(message == "No") {
                vector newvec = <-tryvec.x, -tryvec.y, -tryvec.z>;
                tryvec = newvec;

                llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_OMEGA, tryvec * rotlocal, 1.0, 1.0]);
                string menutext = menutop(stage);
                menutext += "OK, changing direction. Is it rotating in the correct direction?";
                menu(llGetOwner(), menutext, ["Yes", "No", "Exit"]);
            }
        } else if(stage==3) {
            if(message == "Use This") {
                stage=4;
                string menutext = menutop(stage);
                menutext += "Copy this rotation speed to other wheels named \"rwheel\" and \"fwheel\"?";
                menu(llGetOwner(), menutext, ["Yes", "No", "Exit"]);
            } else {
                stage3(message);
            }
        } else if(stage==4) {
            
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_DESC, "<" + fixedprec2(tryvec.x) + "," + fixedprec2(tryvec.y) + "," + fixedprec2(tryvec.z) + ">"]);
                
            if(message == "Yes") {
                vector thisoffset = llList2Vector(llGetLinkPrimitiveParams(LINK_THIS, [PRIM_POS_LOCAL]), 0);
                
                for(i=2; i<= llGetObjectPrimCount(llGetKey()); i++) {
                    list params = llGetLinkPrimitiveParams(i, [PRIM_NAME, PRIM_DESC, PRIM_POS_LOCAL]);
                    if( ((llSubStringIndex(llList2String(params,0), "rwheel")!=-1) || (llSubStringIndex(llList2String(params,0), "fwheel")!=-1)) && (i != llGetLinkNumber())) {
                        vector offsetvec = llList2Vector(params, 2);
                        integer switch = FALSE;
                        if((llList2String(params, 1)=="") || (llList2String(params, 1)=="(No Description)")) { //not yet configured, *-1 if opposite side
                            if( ((thisoffset.y>0) && (offsetvec.y<0)) || ((thisoffset.y<0) && (offsetvec.y>0)) ) {
                                tryvec = tryvec * -1.0;
                                switch = TRUE;
                            }
                        } else { // configured, preserve +- 
                            vector wheelvec = llList2Vector(params, 1);
                            if ( ( ((tryvec.x<0)||(tryvec.y<0)||(tryvec.z<0)) && ((wheelvec.x>0)||(wheelvec.y>0)||(wheelvec.z>0)) ) ||
                                 ( ((tryvec.x>0)||(tryvec.y>0)||(tryvec.z>0)) && ((wheelvec.x<0)||(wheelvec.y<0)||(wheelvec.z<0)) ) ) {
                                 tryvec = tryvec * -1.0;
                                 switch = TRUE;
                            }
                        }
                        llSetLinkPrimitiveParamsFast(i, [PRIM_DESC, "<" + fixedprec2(tryvec.x) + "," + fixedprec2(tryvec.y) + "," +
                                fixedprec2(tryvec.z) + ">"]);
                        if(switch) { tryvec = tryvec * -1.0; } //switch back
                    }
                }
                
                llOwnerSay("Rotation speed copied to other wheels named \"rwheel\" or \"fwheel\".");
            } 
            llMessageLinked(1, 0, "wheelcalc", NULL_KEY);
            llOwnerSay("Wheel configuration complete! Script will now auto-delete.\nPlace a copy of the script in the next wheel to be configured.");
            llRemoveInventory(llGetScriptName());

        }
    }
}

