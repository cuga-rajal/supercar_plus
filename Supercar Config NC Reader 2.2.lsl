// Supercar NC Config 2.2
 
// By Cuga Rajal <cuga@rajal.org>
// Latest version and more information at https://github.com/cuga-rajal/supercar_plus/
// This work is licensed under the Creative Commons BY 4.0 License: https://creativecommons.org/licenses/by/4.0/
 
// This script's sole purpose is to read the configuration settings in the Config Notecard
// It must be used with the Supercar script 

string          notecard_name = "Config";


//---INTERNAL VARIABLES--------------------------------------------------

key kQuery = NULL_KEY;
integer iLine = 0;
key notecard_key = NULL_KEY;


config_init() {
    integer nFound = FALSE;
    integer i;
    for (i=0; i<llGetInventoryNumber(INVENTORY_NOTECARD);i++) {
        if(notecard_name==llGetInventoryName(INVENTORY_NOTECARD, i)) { nFound=TRUE; }
    }
    if(! nFound) {
        llOwnerSay("Config notecard not found, using configs from script");
        return;
    }
    //if (notecard_key == llGetInventoryKey(notecard_name)){  finish(); return; }
    llOwnerSay("Reading Config notecard...");
    notecard_key = llGetInventoryKey(notecard_name);
    iLine = 0;
    kQuery = llGetNotecardLine(notecard_name, iLine);
}

setConfig(string setting, string qval) {
    llMessageLinked(LINK_THIS, 999, setting + "=" + qval, NULL_KEY);
}

default {
    state_entry() {
    }
    
    link_message(integer Sender, integer Number, string msg, key Key) {
        if(msg == "readConfig") {
            config_init();
        }
    }

    dataserver(key query_id, string data) {
        if (query_id == kQuery) {
            if (data != EOF)  {
                if(llStringTrim(data, STRING_TRIM)=="") { jump break; }
                list tmp = llParseString2List(data, [";"], []);
                string conf = llList2String(tmp,0);
                tmp = llParseString2List(conf, ["="], []);
                string setting = llStringTrim(llList2String(tmp,0), STRING_TRIM);
                string qval = llStringTrim(llList2String(tmp,1), STRING_TRIM);
                if(setting=="") { jump break; }
                if((llGetSubString(qval,0,0)=="[") && (llGetSubString(qval,-1,-1)=="]")) { // If it's a list
                    qval = llStringTrim(llGetSubString(qval,1,-2), STRING_TRIM);;    // remove square brackets
                }
                if((llGetSubString(qval,0,0)=="\"") && (llGetSubString(qval,-1,-1)=="\"")) { // If it's enclosed in quotes
                    qval = llGetSubString(qval,1,-2);  // remove outer quotes
                    if(llSubStringIndex(qval,"\"") != -1) { // if there are still more quotes in the string, assume it's a list
                        tmp = llParseString2List(qval, ["\",\"","\", \"","\" ,\"","\" , \""], []); // parse the list to remove the remaining quote marks
                        qval = llDumpList2String(tmp,",");  // reconstruct the value without quote marks to pass on
                    }
                }
                setConfig(setting, qval);
                @break;
                ++iLine;
                kQuery = llGetNotecardLine(notecard_name, iLine);
            } else {
                llOwnerSay("Finished Reading Config Notecard");
                llMessageLinked(LINK_THIS, 1000, "", NULL_KEY);
            }
        }
    }
}


// END

