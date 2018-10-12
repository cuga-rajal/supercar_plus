// Supercar Plus HUD 1.7
// For use with Supercar Plus script (https://github.com/cuga-rajal/supercar_plus)
// Rez a cube object in-world and use the accompanying texture on a face
// Place this script in the HUD object
// Take the object to inventory and attach it to HUD top-center. Position it as needed for the controls face to be visible.
// Remove the HUD from wearing, it is ready to use.
// To use the HUD, place a copy of it in the car contents, and edit car script configuration to use the HUD
// The HUD will request a temp-attach when the driver sits to drive.
// The HUD object will poof when the driver stands, or if the driver ignores the attach dialog, or answers No to the dialog.
// Buttons will respond to user clicks, but there is no visual change when clicking.


integer RACECAR_HUD_CHANNEL = 19997;
integer listener;
key carkey = NULL_KEY;
key avkey = NULL_KEY;
integer askattach = FALSE;
integer honk = 0;
integer lights = 0;
integer pipeflame = 0;
integer smoke = 0;
vector  touchUV;

default {
    state_entry() {
        listener = llListen(RACECAR_HUD_CHANNEL, "", NULL_KEY, "");
        llSetTimerEvent(60);
    }
    
    listen(integer channel, string name, key av, string message)  {
        if (channel == RACECAR_HUD_CHANNEL) {
            if(llSubStringIndex(message, "avkey ") == 0) {
                avkey = (key)llGetSubString(message, 6, -1);
                llRequestPermissions( avkey, PERMISSION_ATTACH );
                askattach = TRUE;
            }
            else if(llSubStringIndex(message, "carkey ") == 0) {
                carkey = (key)llGetSubString(message, 7, -1);
            }
            else if(message=="control poof") {
            	if(llGetAttached()) { llDetachFromAvatar(); }
            	else { llDie(); }
            }
            if((carkey != NULL_KEY) && (askattach)) {
                llListenRemove(listener);
                listener = llListen(RACECAR_HUD_CHANNEL, "", carkey, "");
            }
        }
    }
    
    
    touch_start(integer total_number) {
        touchUV   = llDetectedTouchUV(0);
        if((touchUV.y>.07) && (touchUV.y<.241)) {
            if(smoke==0) { llRegionSayTo(carkey, RACECAR_HUD_CHANNEL, "smoke_on"); smoke=1; }
            else {  llRegionSayTo(carkey, RACECAR_HUD_CHANNEL, "smoke_off"); smoke=0; }
        }
        else if((touchUV.y>.282) && (touchUV.y<.454)) {
            if(pipeflame==0) { llRegionSayTo(carkey, RACECAR_HUD_CHANNEL, "pipeflame_on"); pipeflame=1; }
            else {  llRegionSayTo(carkey, RACECAR_HUD_CHANNEL, "pipeflame_off"); pipeflame=0; }
        }
        else if((touchUV.y>.49) && (touchUV.y<.657)) {
            if(lights==0) { llRegionSayTo(carkey, RACECAR_HUD_CHANNEL, "lights_on"); lights=1; }
            else {  llRegionSayTo(carkey, RACECAR_HUD_CHANNEL, "lights_off"); lights=0; }
        }
        else if((touchUV.y>.70) && (touchUV.y<.875)) {
            if(honk==0) { llRegionSayTo(carkey, RACECAR_HUD_CHANNEL, "honk_on"); honk=1; }
            else {  llRegionSayTo(carkey, RACECAR_HUD_CHANNEL, "honk_off"); honk=0; }
        }
    }
    
    attach(key id) {
        if (id) {
            llRequestPermissions( id, PERMISSION_ATTACH );
        }
    }
    
    run_time_permissions( integer vBitPermissions ) {
        if (!llGetAttached() && (vBitPermissions & PERMISSION_ATTACH))  {
            llAttachToAvatarTemp(33);
            llSetTimerEvent(0);
        } else {
            llDie();
        }
    }
    
    on_rez(integer start_param) {
        llResetScript();
    }
    
    timer() { 
        llDie();
    }
    
}
