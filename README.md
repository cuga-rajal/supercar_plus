# supercar_plus
Supercar Plus Notes
version  0.33, Sept 16, 2018

This is a free LSL land vehicle car script by Cuga Rajal and other past contributors.
Compatible with Opensim and Second Life.

This work is licensed under Creative Commons BY-NC-SA 3.0:
  https://creativecommons.org/licenses/by-nc-sa/3.0/

For version information and credits please see https://github.com/cuga-rajal/supercar_plus/blob/master/Supercar_Plus_Versions_Credits.txt

For a history on how this script first came about please see https://github.com/cuga-rajal/supercar_plus/blob/master/Supercar_Plus_history.txt

-----

Supercar Plus - Open-Source LSL Car Script

The Supercar Plus is an LSL script for land vehicles. It merges the best features of several car scripts to provide many useful features and low server impact (lag). It works in Opensim (Bullet Physics) and Second Life (Havok engine).

In it's simplest form, the script can be dropped into a root prim and used immediately. The root prim containing the script should be an elongated cube prim positioned flat on the ground. In most cases this root prim is given an invisible texture after linking with a visual vehicle. While this is a different setup than some car scripts, there are some big advantages that are described later. It is good practice to test the car script on the root prim by itself, before linking it, so that you confirm it's forward-back motion matches the orientation of the vehicle you are linking.

**Quick Start Instructions**

Rez your vehicle and adjust it's angle in-world so that it's square with the sim. 

Create a cube prim about the size of the vehicle's wheelbase. The car will move in the x-direction, so make the X dimension the length and Y dimension the width. Also set the X-Taper to -0.15, this helps the car go over bumps and obstacles.

Place the Supercar Plus script in the prim and sit to drive the car. Move forward using your arrow keys and make note of it's direction of movement. This will need to be match the vehicle you are linking. Stand up. and then adjust the prim and/or your vehicle so that both are oriented the same direction. Move the root prim with the car script under the car along it's wheelbase. This can be lined up by eye, it doesn't have to be exact.

Remove any driving scripts that may be on your car. If there is a special driver sit animation in the root prim, transfer that out of the root prim into your inventory and then delete it from the car. Then drag it into the new wedge prim which will become the new root prim of the vehicle.

Now link the car and the new root prim together, with the wedge prim as the new root prim. Transfer the name of the car object back into it. You will need to adjust the driver sit position offset, gSitTarget_Pos, to position the driver avatar where they need to be. This is the offset from the center of the root prim.

Review the Config notecard and make any adjustments needed. Make the root prim invisible.

**Getting Familiar:**

Take a look at the configuration settings in the Config notecard. There are comments that explain what each does.
Take a look at the assets that come with the script.

**Asset organization:**

Typically, the easiest way to organize the assets is to create folders that each correspond to car parts, such as front right wheel, etc. So it's easy to see which assets go with which prims. Viewer software does not have an automated way to create nested folders through an unpacking process, so you will have to create those by hand. Assets are already organized this way at Github, so Github can be used as a guide for re-creating this folder structure in your viewer's inventory. A screen capture image of a viewer's nested folders is also provided.

**Converting existing vehicles to the Supercar Plus script:**

If the vehicle or object you are linking already has a car script and animation, the car script needs to be removed and the animation transferred to the root prim containing the Supercar script. The animation will play automatically if it is present when someone drives. The sit offset of the Supercar Plus script will need to be adjusted so that the driver appears where they are expected visually. 

**Passenger seats:**

Any prims with a non-zero sit offset can be used as passenger prims. It is customary to set the passenger prims' Click To setting is Sitting (Edit window General tab) to make it easy for people to recognize which prims are intended to sit on. Sit scripts are not required inside passenger seat prims if their sit offset is already set. However, sit scripts can be used in passenger seats if you want to force an animation or do other things on sit. If you want to drive a vehicle that has passenger seats, you have to right-click on any non-passenger prim and select Drive.

Do not place sit scripts in the root prim. This would cause the car not to be drivable. The Supercar Plus script already manages the driver's sitting.

**Configuration options:**

The beginning section of the script contains a number of adjustable configuration settings. The script supports the use of an external notecard named "Config" also to store these settings. If the Config notecard is present in the same prim as the script, the script will read settings in the notecard and ignore settings within the script itself. This is the preferred method because it simplifies future maintenance. When new versions of the script become available (bug fixes for example) the updated script can be dropped into the prim, replacing the old one, without having to edit any settings if those are stored in the Config notecard. 

**Accompanying scripts:**

A set of optional scripts can be used along with the Supercar Plus script to further enhance the vehicle. These extra scripts listen for signals coming from the main script to manage other parts of the car, such as wheel rotation, headlights, horns, and others. Wheel rotation, for example, rotates the wheel prims instead of using a texture animation, so the wheel textures look correct all the way around. 

**Link messages:**

The Supercar Plus script sends llMessageLinked() messages to other prims so that they may respond to driver controls; Custom scripts can be added elsewhere on the car that respond to these messages. For example, a script could turn on headlights when a driver sits and turn off when they stand, by responding to the link messages. Texture animations can be started, stopped and put into reverse, in response to forward or back driving motion, for such things as conveyor belts or tank treds.  

The Supercar Plus script listens for link messages beginning with "sitoffset" to dynamically adjust the driver sit offset. This can be useful if the driver position might change by some other use of the vehicle. For example, a scissors lift vehicle might adjust the driver's position to remain in the lift as it goes up and down. In this example, a separate script managing the up-down motion of the lift could send link messages back to the Supercar Plus script to keep the driver position in a logical place.

**Minimizing Lag:**

When the script is placed in a car, or is reset, it checks and remembers the physics type of all child prims on the vehicle. Then, when the driver sits to drive, the script sets all child prims to physics type None. This minimizes lag on the server, since physics calculations only need to be made for the one root prim. When the driver stands, the script restores the original physics types to all child prims. This way, you can have a mix of physics types on the vehicle prims, and those will be preserved before and after driving.

The script has an option to selectively keep a child prim physics type Prim instead of None while driving, if needed. This can be done by naming the Description field of a prim to "prim" and resetting the script. This can be useful for creating articulating hinges on multi-axle vehicles (experimental).

**Sound and particles:**

There is an optional set of assets that can be used to create smoke and squealing while driving the car, typically for race car applications. Textures and sounds came from the original iTec Supercar by Shin Ingen in 2015 and are included by permission.

**Wheel Rotations**

If your car has wheels, you can use the Supercar Plus wheel scripts. These scripts rotate the wheel prims at the correct spin based on wheel size and car motion, and support the multi-gear options. They are pre-configured for cylinder prims and can be adjusted to support mesh prims with different orientations. 

**Engine Sounds**

Sound files that came with the original iTec Supercar are included by permission. These race car sounds may be placed in the root prim. If present in the root prim, the Supercar Plus script will play these sounds during use. If using this script in Second Life, there is an option to use sounds available in SL, through a configuration change. 

**Smoke and Screech Effects**

There are optional scripts for smoke and screech effects. This is usually added for cars with multiple gears. These effects can be placed anywhere on the vehicle though it usually makes sense to place them in the rear wheels. Or, for more realistic effects, into invisible prims at the bottom of the rear wheels, causing the smoke to appear to come from where the wheel touches the ground. The smoke and screech scripts require a texture and sound placed in the contents of the same prim the effects script is in. Finally, you will need to adjust the main script configuration to set which gears the burnout effects will appear.

**Pipe Flame**

The optional pipeflame script can be used to produce flame from exhaust pipes. This is usually used only on cars with multiple gears. This typically requires invisible prims placed near the exhaust pipe outlets, and angled so that the direction of particle effects from the invisible prim aligns to the pipe direction. The script and texture can first be placed in the prim, and then the main Supercar script configuration can be adjusted to set which gears the pipeflame appears. Once the pipeflame effects are visible, the position and angle of the invisible prim can be adjusted to get the flames aligned with the tailpipe.

**Headlights**

Headlight and headlight beams can be switched on and off by the Supercar script. Headlight scripts are included in the package. Since it is difficult to use small switch prims on the car itself, headlight scripts are designed to switch on either at time of driving, or to be controlled with an optional Supercar HUD. 

**Horn**
The same is true with the included horn script. The script makes the horn honk when it gets a signal from the optional HUD. The horn will be heard coming from the prim you place the horn script in. 

**HUD**
An optional HUD is also provided. To use, placing it in the root prim and then configure the Supercar script to use it. When the driver first sits, they will get a dialog requesting to temp-attach the HUD to their Top Center HUD location. The HUD lets the driver control headlights, horn, and manually switches pipeflame and smoke effects. When the driver stands, the HUD automatically un-attaches and deletes.



----

This is a work in progress. Please notify me of bugs or feature requests.

Cuga Rajal (Second Life and OSGrid)
cugarajal@gmail.com