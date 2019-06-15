# supercar_plus
Supercar Plus Notes
version  0.33, Sept 16, 2018

This is a free LSL land vehicle car script by Cuga Rajal and past contributors, compatible with Opensim and Second Life.

This work is licensed under Creative Commons BY-NC-SA 3.0:
  https://creativecommons.org/licenses/by-nc-sa/3.0/

For version information and credits please see https://github.com/cuga-rajal/supercar_plus/blob/master/Supercar_Plus_Versions_Credits.txt

For a history on how this script first came about please see https://github.com/cuga-rajal/supercar_plus/blob/master/Supercar_Plus_history.txt

-----

Supercar Plus - Open-Source LSL Car Script

The Supercar Plus is an LSL script for land vehicles. It merges the best features of several car scripts to provide many useful features and low server impact (lag). It works in Opensim (Bullet Physics) and Second Life (Havok engine).

In it's simplest form, the script can be dropped into a root prim and used immediately. The root prim containing the script should be an elongated cube prim positioned flat on the ground. In most cases this root prim is given an invisible texture after linking with a visual vehicle.

**Quick Start Instructions**

Rez your vehicle and adjust it's angle in-world so that it's square with the sim. 

Create a cube prim about the size of the vehicle's wheelbase. Make the X dimension the length and Y dimension the width. Also set the X-Taper to -0.15, this helps the car go over bumps and obstacles.

Place the Supercar Plus script in the prim and sit to drive the car. Move forward using your arrow keys and make note of it's direction of movement. This will need to be match the vehicle you are linking. Stand up. and then adjust the prim and/or your vehicle so that both are oriented the same direction. Move the root prim with the car script under the car along it's wheelbase. This can be lined up by eye, it doesn't have to be exact.

Remove any driving scripts that may be on your car. If there is a special driver sit animation in the root prim of the car, transfer that from of the car's root prim into your inventory and then delete it from the car. Then drag it into the new cube prim which will become the new root prim of the vehicle. Also transfer the name of the car object to the cube prim. 

Now link the car and the new root prim together, with the cube prim selected last as the new root prim. Reset the script and then test drive it.

You will probably need to adjust the driver sit offset, gSitTarget_Pos, so the driver appears in the driver's seat. This is the offset from the center of the root prim.

**Getting Familiar:**

Take a look at the configuration settings in the Config notecard. There are comments that explain what each does.
Take a look at the assets that come with the script.

**Asset organization:**

Since most assets correspond to specific car parts, the easiest way to organize the assets is to create folders that each correspond to car parts, such as front right wheel, etc. So it's easy to see which assets go with which prims. Viewer software does not have an automated way to create nested folders through an unpacking process, so you will have to create these by hand. A screen capture image is included showing a typical viewer inventory organization.

**Passenger seats:**

Any child prim can be made sittable and used as passenger seats. This can be a prim already on the car or a poseball can be added. It is customary to set the 'Click To' setting of passenger prims to 'Sitting' (Edit window General tab) so it's easy for people to see which prims are intended to sit on using mouse hover. Sit scripts do not need to remain in the sittable prims if the default sit animation is ok; Custom sit scripts in passenger seats can force an animation or do other things when an avatar sits. If you want to drive a vehicle, make sure you don;t click on a passenger prim. Rght-clicking on a car might be required to drive.

Do not place sit scripts in the root prim or driver's seat. This would cause the car not to be drivable. The Supercar Plus script already manages the driver's sitting.

**Configuration options:**

The beginning section of the script contains a number of adjustable configuration settings. The script supports the use of an external notecard named "Config" also to store these settings. If the Config notecard is present, in the same prim as the script, the script will read settings from the notecard and ignore settings within the script. This is the preferred method because it simplifies future maintenance. When new versions of the script become available (bug fixes for example) the updated script can be dropped into the prim, replacing the old one, without having to edit any settings. 

**Accompanying scripts:**

Additional scripts can be used with the Supercar Plus script to further enhance the vehicle. These extra scripts listen for signals coming from the main script to manage other parts of the car, such as wheel rotation, headlights, horns, etc.

**Link messages:**

The Supercar Plus script sends llMessageLinked() messages to child prims for various driver controls; Custom scripts can be added elsewhere on the car that respond to these messages. For example, a script could turn on headlights when a driver sits and turn off when they stand, by responding to the link messages. Texture animations can be started, stopped and put into reverse, in response to forward or back driving motion, for such things as conveyor belts or tank treds.  

In addition to the script sending link_messages, it also listens for link messages beginning with "sitoffset" to dynamically adjust the driver sit offset. This can be useful for vehicles that might need to change the driver position due to some other use of the vehicle. For example, a scissors lift vehicle might adjust the driver's position to remain in the lift as it goes up and down. In this example, a separate script managing the up-down motion of the lift could send link messages back to the Supercar Plus script to keep the driver position in a logical place.

**Minimizing Lag:**

When the script is placed in a car, or on reset, it checks and remembers the physics types of all child prims on the vehicle. Then, when the driver sits to drive, the script sets all child prims to physics type None. This minimizes lag on the server, since physics calculations only need to be made for the one root prim. When the driver stands, the script restores the original physics types to all child prims. This way, you can have a mix of physics types on the vehicle prims, and those will be preserved before and after driving.

The script has an option to selectively keep a child prim physics type Prim instead of None while driving, if needed. This can be done by naming the Description field of a prim to "prim" and resetting the script. This can be useful for creating articulating hinges on multi-axle vehicles (experimental).

**Smoke and Screech Effects**

There is an optional set of assets that can be used to create smoke and squealing while driving the car, typically for race car applications. Textures and sounds came from the original iTec Supercar by Shin Ingen in 2015 and are included by permission. These effects are best placed into invisible prims at the bottom of the rear wheels, causing the smoke to appear to come from where the wheel touches the ground. The smoke and screech scripts require a texture and sound placed in the contents of the same prim the effects script. Finally, you will need to adjust configuration setting to manage which gears the burnout effects will appear.

**Wheel Rotations**

If your car has wheels, you can use the Supercar Plus wheel scripts. These scripts rotate the wheel prims at the correct spin based on wheel size and car motion, and support the multi-gear options. They are pre-configured for cylinder prims and can be adjusted to support mesh prims with different orientations. 

**Engine Sounds**

Sound files that came with the original iTec Supercar are included by permission. These race car sounds may be placed in the root prim. If present in the root prim, the Supercar Plus script will play these sounds during use. If using this script in Second Life, there is another option to use sounds available in SL, through a configuration change. 

**Pipe Flame**

An optional pipeflame script can be used to produce flame from exhaust pipes. This typically requires invisible prims placed near the exhaust pipe outlets, and angled so that the direction of particle effects from the invisible prim aligns to the pipe direction. The script configuration can be used to control which gears the pipeflame appears. Once the pipeflame effects are visible, the position and angle of the invisible prim can be adjusted to get the flames aligned with the tailpipe.

**Headlights**

Headlight and headlight beams can be switched on and off with the provided Headlight scripts. These are designed to switch on either at time of driving, or to be controlled with an optional Supercar HUD, depending on the configuration.

Two types of headlight scripts are provided. Headlight Beams are conical shaped prims to simulate beams coming from the headlights. These are typically set to white color, physics type None, and transparency 100% when parked. The Headlight Beam script adjusts the transparency and glow so that it appears when the lights are on and goes invisible again when off.

The Headlight Source script is meant for the headlight prim itself. The script switches the Fullbright setting and point light source.

**Horn**

A horn script makes the horn honk when it gets a signal from the optional HUD. The horn will be heard coming from the prim you place the horn script in. 

**HUD**

An optional HUD is also provided. Setup instructions are included in the notes in the HUD script. Once the HUD object is set up, place it in the root prim of the car and configure the Supercar script to use it. When the driver first sits, they will get a dialog requesting to temp-attach the HUD. The HUD allows the driver control headlights, horn, pipeflame and smoke effects ("smokescreen"). Each of those components needs to be set up and configured on the car in order for the HUD button to work. When the driver stands, the HUD automatically un-attaches and deletes.



----

This is a work in progress. Please notify me of bugs or feature requests.

Cuga Rajal (Second Life and OSGrid)
cugarajal@gmail.com
