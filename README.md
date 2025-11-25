# supercar_plus
Supercar Plus - Open-Source LSL Car Script

version 2.2, Nov 25, 2025

Supercar Plus is a free LSL land vehicle (car) script by Cuga Rajal and past
contributors, compatible with Opensim and Second Life.

This work is licensed under Creative Commons BY 4.0:
https://creativecommons.org/licenses/by/4.0/

For version information and credits please see
https://github.com/cuga-rajal/supercar_plus/blob/master/Supercar_Plus_Versions_Credits.txt

For a history on how this script first came about please see
https://github.com/cuga-rajal/supercar_plus/blob/master/Supercar_Plus_history.
txt

-----

**Summary**

Supercar Plus is a free LSL land vehicle (car) script compatible with Opensim and Second
Life. It supports a wide range of creative options for various car features and the
runtime is low-impact on the server. By using a Notecard for settings, vehicles can be
updated easily, this also helps manage a large car collection. The full project is
available at https://github.com/cuga-rajal/supercar_plus..

Many popular features are supported, such as driver's animation, passenger seats, multiple
gears/speeds with reverse, rotating wheels, headlights, horns, engine sounds, tank tred
motions, and much more. A variety of add-on scripts are included with instructions.

While most people will find everything they need in the Quick Start section, the List of
Features section provides more details.

-----

**Whats New**

Supercar 2.2 is a major rewrite that improves a number of things, and uses about 20% less
memory than 2.1.x.

The main script and many add-ons received bug fixes and improvements. If you are
upgrading, check the version numbers of the main script and add-on scripts in your vehicle
and update to any new versions. If there are issues, check documentation on the script or
add-on.

The biggest change with version 2.2 is using a separate script for reading in the Config
notecard. Just drop in the Supercar Config NC Reader script along with the Config notecard
and it will work like before. It doesn't matter if it is dropped in before or after the
main script.

The initializing sequence changed but works just the same. With the new version, the car
script is initialized with its own settings and then it reads the Config NC and overwrites
the configs with any changes. If any sound settings changed, the script performs sound
preloading again.

Auto-Park feature was also moved to a separate script. 

Supercar Version 2.2 did not change any config settings from 2.1.3. However there were several
changes to the Config notecard in the last year. If you are upgrading from an old version,
check the settings in your Config to match the current version. For upgrading from older
versions it is easier to transfer your settings to the new Config notecard format.

To see complete lists of changes for each version, please see the file Supercar_Plus_Versions_Credits.txt.

-----

**Quick Start Instructions:**

Rez a cube and set the size to x=4.0, y=2.0, z=0.5. Drop the Supercar script in it and
sit on it to drive. Use your keyboard arrow keys to move. Notice the direction of the prim
when it goes forward. This will need to be aligned with the vehicle when you link them.

Stand up and move the cube rotation back to x=y=z=0; You can do this from the Edit
window., Object tab. The prim will drift away from its original angle each time you test
drive the car, so make sure set it back to be square with the sim before adding, linking
of adjusting prims.

Rez your vehicle. If it has a driver's animation, save that to your inventory, then delete
everything in the root prim. Drop in the driver's animation into the new cube prim. 
Transfer the vehicle's name to the new cube prim as well.

If the vehicle already has wheel scripts or other assets from a previous car script
system, remove those. Align your vehicle square to the sim, pointing the same direction
forward as the cube.

Now move the cube under the vehicle. Resize it to be about the size of the wheelbase. It
doesn't have to be exact, you can do it by eye.

Also add a taper in the prim shape from the Edit window Description tab, Taper x = -0.25.
This will help it go over obstacles much easier.

Now Edit your vehicle, hold down the Shift key, and select the new cube prim last. Link
them together with the Link button. You should now be able to drive your car!

The driver's position is likely to be wrong. You can fix this using a Sit Positioner
System or a sit script. This only needs to be done once. A free Sit Positioner System is
available at Burn2 from giver boxes in the sandbox. 􀀠. When you adjust the driver
position make sure that you are changing the root prim, even if there is a separate visual
drivers seat. Re-test driving the car after you set the sit position.

To get your wheels working, name any front wheel prim "fwheel" and any rear wheel prim
"rwheel". Erase the Description fields in these prims. Then drop the Wheel Configurator 
into *one* wheel only. Touch it to begin the dialog process. At the end of the process,
when it asks to copy the settings to other wheels, say Yes. In most cases this will get
all 4 wheels working correctly. If you need to adjust other wheels, use the Wheel
Configurator for each individual wheel that needs adjusting. You can also adjust wheel
settings by editing the wheels' description fields and restarting the car script.


Many other features are detailed below.

-----

**Configuration Notecard**

By placing a Config notecard and the notecard reader script in the same root prim as the
main script, you can update the main script (for example with new bugfix versions) without
needing to hand-edit any settings. If these files are present in the Contents, the script
will use settings from the notecard and ignore the settings within the main script. 

This is the
preferred method because it allows script updates to be a simple replacement, without needing to hand-edit any settings.

The file Config.txt provided with this package is a working template for the
Config notecard, and provides reasonable values for average-sized cars.

-----

**Wheel Rotation**

Supercar 2 manages all wheel rotations and turning without separate wheel scripts! A
one-time setup is required. A Wheel Configurator script provides a dialog-based setup to
configure the wheels without the need to hand-edit any numbers. It uses the Name and
Description fields on the wheel prims to store wheel settings and will overwrite anything
already in the Description. 

The Wheel Configurator requires the following preparations before use:

1. For each wheel prim, remove any scripts in the wheel
2. For each wheel prim, set the prim Name to "fwheel" for the front wheels (or any wheels that turn left-right) and "rwheel" for the rear wheels (or any wheels that stay straight)
3. For each wheel prim, erase anything in the Description (or it can say "(No Description)").
4. The Supercar 2 car script should be installed and working before using the Wheel Configurator
    
Once these preparations are completed, the Wheel Configurator script can be dropped into
any *one* wheel. Then click on that wheel to open the dialogs. Follow the instructions in
the dialog that appears. The script will delete itself when setup is complete.

During the dialog configuration there is an opportunity to copy the settings to all the
wheels. In most cases, this step sets the other wheels correctly and no further steps are
needed.

When the Wheel Configurator finishes, check all your wheels. If any of the wheels need to
be adjusted, you can adjust them individually, either by using the Wheel Configurator
script separately on those wheels, or, you can hand-edit the numbers in the Description
fields and restart the car script for the changes to take effect.

When you drop in the Wheel Configurator on a wheel that's already configured, it will ask
you what you want to change, such as axis, direction of rotation, or speed. You can select
the setting that needs to be changed and it will retain the other settings. For example if
you just need to change the direction, select that option to adjust it, and then select
the defaults on the remaining options to complete the setup for that wheel. 

*Reverse turn option*

Front wheels (or any wheels that turn left-right) have an option to turn left-right in
opposite direction of the left-right keys used. This is useful for vehicles that have
wheels on rear of the car,  that need to turn opposite the direction of the turning wheel.
To enable this, add "reverse" to the prim name. The prim name may contain multiple words -
"fwheel", "smoke" and "reverse" can be in any order. 


-----

**Passenger Seats**

Any prim on the vehicle (except root prim) can be made into a sittable passenger seat. You
will need a separate dedicated prim for each seat; This can be a prim already on the
vehicle, or an invisible prim that you add in strategic places for seating purposes.

*Use a Sit Positioner System to Calibrate Your Passenger Seats*

Each prim being used as a passenger seat will need to have its Sit Offset adjusted. The
easiest way to do this is to use a Sit Positioner System, with visual tools to calibrate a
sit position for each prim that you want to make sittable. This is the same tool you used
to set the driver position. 

*If a passenger seat doesn't need to trigger animations or other actions*

Once you use the Sit Positioner System to set the passenger position, the next step is to
decide if you want to have a custom animation play for the passenger, or if their default
sit animation is sufficient. If their default sit is sufficient, no further scripting is
needed. 

*If a passenger seat needs to trigger animations or other actions*

If you need to play an animation when a passenger is seated, or trigger something else
when they sit, such as making a poseball invisible, then a script will need to be placed
in that prim to accomplish this. A general-purpose sit script, Sit w/Animation 2.0, is
provided for this. This script works with any build, vehicle or not. The sit script has
a number of other options that you can read about in the notes at the top.

The latest version adds an important feature - a touch menu to adjust the sitter position.
This avatar adjust option will work even if you do not have an animation to play.

*Better option for managing a large number of seats*

This kit provides another script option for passenger seats that is useful when you have a
vehicle with a large number of seats. Instead of using a separate script in each passenger
prim, you can manage all the passenger sits with one script. This can help reduce script
memory on the vehicle and help it be more responsive to driving controls. The script
"Manage Child Prim Sits 2.1.lsl" can be set up as described in the following section. 􀀎

*Pros and cons of avSitter*

If you are already using another sit management system such as avSitter, this is
compatible with the Supercar script, however, there can be out-of-memory issues if used
with a large number of seats. avSitter works well for a couples car or up to about 10
singles sits or 5 couples sits. But it has been found to cause vehicle out-of-memory
conditions if more than 10 singles sits or more than 5 couples sits are used, causing
problems at sim crossings and in sims under heavy load. Vehicles with more than 10 singles
sits or 5 couples sits should not use avSitter and use a different sit scripting system
instead. Working options are included with the kit. 

*Large cars with many passengers*

In most cases you can use a separate script in each passenger seat. If you have a large
number of seats, you can reduce overall vehicle script memory by replacing the separate scripts with one
single script that manages all the passenger sits. "Manage Child Prim Sits" script is provided for
this. Check the comments at the top of the script for setup details. It provides some additional
options, such as managing alpha of the sit prims.

*Adjusting the sit offset by editing numbers manually*

Another way to adjust the sit position of passenger seats or the driver is to use a sit
script with numerical offsets, and manually editing numbers in the script. Some like this
option, others don't. If you used the Sit Positioner system, that prints out the sit
offset settings in local chat. You can copy those settings into the script as a starting
point, then manually adjust the numbers to make further changes.

*Sit adjust provided with touch menu*

The passenger sit scripts allow passengers to touch the vehicle to adjust their position. 

*Options for Driver Sits*

If there is exactly one animation placed in the Contents, the driver will play the
animation when the driver sits. A sit script is not needed for the driver.

Optionally, the Sit w/Animation 2.0 script can be placed in the root prim to allow the
driver to touch the vehicle and adjust their position.

If there is more than one animation in the Contents, the car script will not play a
driver's animation automatically (it doesn't know which one to play). In this case a
separate script is needed to manage the driver animation. Use the Supercar 2 Animation
Controller 1.0 for this case. The script needs to be configured with the name of the
animation to play.

-----

**Manage All Child Prim Sits With One Script**

The script Manage Child Prim Sits can manage sits for many passenger seats with
one single script, greatly reducing the script count on the vehicle and reducing
lag. This script now includes a touch dialog to adjust avatar position!

The script supports one animation per seat, and the setup process is fairly easy:

    1. Create individual sits in child prims with individual sit scripts and
    animations Adjust the sit offsets on each sit prim for specific animations.
    2. For each seat prim,
        a) copy the exact name of the animation to the prim Description,
        b) set the prim Name to the word "sit",
        c) Place a copy of the seat's animation into the root prim
        d) then remove the sit script and the animation from the seat prim
    3. Place a copy of this script in the root prim
    
If you use this option, you will also need to use the Driver Animation
Controller script to manage the driver's animation.

-----

**Engine Sounds**

You can use your own car sounds. Just drop them into the root prim and
update the Config notecard with your sound names. Alternatively, you can use
sound UUIDs in the Config without needing to place sounds in the root prim.

Race car sounds are also provided in the repository.  These came with from
original iTec Supercar by Shin Ingen and are included here by permission. 

-----

**Headlights**

Headlights can be switched on and off with one the provided headlight
scripts. These scripts will switch lights either at time of driving, or with an
optional Supercar HUD. The scripts provide two separate functions -- making the
face of the headlight prim bright like a light, and casting a projected light
beam on the ground.

To see the headlight beam you will need to enable Advanced Lighting Model in
your viewer graphics preferences.

If you are using a headlight beam on one of your prims, you should apply a
projector texture to the prim manually before using the script. A sample texture
"spotlight" is included for this purpose. Apply this as follows:

Select the prim, go to the Features tab in the Edit window and check the Light
checkbox. This will temporarily turn on a point light from the prim. The two
boxes to the right of the Light checkbox correspond to color and texture applied
to the light. Drag and drop the Spotlight texture to the texture window. This
will be applied to the light projector in the prim. Then rotate the prim while
watching the projection to point the light beam where you want. When you have
finished positioning the prim, you can un-check the Light checkbox. This
projection setting will now be used when the light is switched on.

The script "Supercar Headlight 1.80" can be placed in
each prim that you want to light up and/or to cast a light projection when car
lights are turned on. The script has a few configurations where you can
adjust lighting features. There are also settings to enable or disable the face
light-up or projector feature on a per-prim basis. It is often necessary to assign
some prims displaying as visual headlight and other invisible prims 
used for casting a projection. Separate prims are often needed because the
visual prims may not be facing the right direction for the projection.

With the projector setting disabled but shine setting enabled, the script can be
used to light up such things as rear driving lights, visual headlights and
running lights. With the projector setting enabled and shine setting disabled,
the script can be used to create a headlight projection beam from an invisible
prim.

If your car has many lights, The script "Supercar all headlights 1.0" is an
alternative method that can control all lights from one script. It requires some
extra setup steps and has some limitations, but reduces script count and impact.
It requires the visual lights on the car all to have the same settings and the
projectors all to have the same settings. Settings can be adjusted from the top
section of the script. Setup is as follows:

Name each prim that you want faces to light up as "headlight" and each prim you
want to act as a projector as "headbeam". If you want a prim to act as both of
these you can name it "headlight headbeam". After naming the prims, drop in the
script. If you placed the script before naming the prims, you will need to
restart the script for it to take effect. 


-----

**Horn**

The provided horn script makes the horn honk when the horn prim is touched, or when
gets a signal from the optional HUD. Place the horn script along with the
desired sound asset into the prim that you want to be the horn.  Some sample
horn sounds are provided.

When you mouse-down on the prim, the horn will play in a continuous loop.  When
you mouse-up, the horn sound will stop.

If you use the HUD, clicking the horn icon once will play a continuous loop. 
Click again to stop the horn.

-----

**Racecar Effects**

There is an option to add exhaust pipe smoke, wheel smoke, and wheel screech sounds to the
vehicle, as follows.

Place the Racecar Effects script into one of the prims on the car OTHER THAN THE ROOT PRIM. The selected
prim is where the sounds will come from.

Prims that you want to display smoke when turning left and right, typically at the base of the wheels,
should have "smoke" included in its name. Wheel prims that are already named "fwheel" or
"rwheel" can be named "fwheel smoke" or "rwheel smoke", or you can link separate prims
at the base of each wheel.

Prims that are meant to display exhaust pipe effects should be named "tailpipe".

When the script  is placed in the vehicle, it checks for child prims for "smoke" or
"tailpipe" and remembers those prims. Then the effects are triggered while driving.

The script is pre-configured for the texture names and screech sounds provided in the kit.
However you can use your own textures or sounds, or UUIDs, and update the settings.

The smoke and flame particle textures used in the script can be the texture asset name or it's UUID.
If a asset name is used, a copy of the texture asset must be placed in the contents. However if a UUID is used in the
settings, the texture assets do not need to copied to the object.

The sound settings can also be the asset name or UUID. If sound asset names are used, the
sound assets must be placed in the contents. If
the UUID is used in the settings, the sound assets do not need to copied to the object.

Make sure you reset the Supercar 2 Racecar Effects script if you change the prim names or 
assets in contents.

Other settings:
    
    - "burnout_gear" is a specific gear that will play continuous sound and particle
     effects when moving forward or backward. To disable this feature set it to 0.
     Burnout in real life is to heat the tire rubber just before a race to improve
     traction, and to test functioning of the engine at full RPM before a race.

    - "turnburnGear" - this gear and above will make smoke & screech sounds when
    turning, on the side opposite the turn direction, simulating the expected effects
    at high speed. You can set it to 0 to disable.

Tailpipe flame effects are displayed for 3 seconds when the car starts up, and
while driving in burnout gear.

The textures and sounds provided in this kit came from the original iTec
Supercar by Shin Ingen and are included by permission.

-----

**HUD**

An optional HUD is provided with the package.

To include it with a car, place the HUD in the root prim of the car along with
the script Supercar 2 HUD Manager. When the driver sits, they will get a
dialog requesting to temp-attach the HUD.

The HUD shows speed, gear selection, and includes controls for changing gears,
headlights, horn, and smokescreen. When the driver stands, the HUD automatically
un-attaches and deletes. It also deletes itself if not attached after a
specified time, to prevent stray objects in the region.

If the headlights, horn, and smokescreen are active when the driver stands, they
will be deactivated at  that time.

The HUD adds some performance overhead to the region. Don't use the HUD in heavily
populated regions or where there is already significant time dilation.

-----

**Driver Animation Controller**

There are 2 situations when you will need this script. 

In most cases a single animation is sufficient for the driver. But there are occasions
when you want the driver animation to change depending on if the vehicle is stopped,
moving, or going fast. For example, a bicycle, or a hamster wheel. The Supercar 2
Animation Controller add-on script can do this.

The script has instructions in the comments on how to set it up. You configure the script
with names of the driver animations, then place copies of the animations into the root
prim contents along with the script. The settings anim\_idle, anim\_fwd and anim\_fast
correspond to being stopped, moving forward or moving fast.

You will also need to use this script if there are more than one animation in the root
prim Contents, and you want the driver to play a specific animation when driving. Set all
3 options to the animation you want to use.

-----

**Boarding Ramp Rezzer**

The script Supercar 2 Boarding Ramp Rezzer manages the rezzing and removal of a
boarding ramp object which is typically used for larger vehicles. This allows
avatars to walk up the ramp from ground level up onto the vehicle without having
to fly up, adding realism and convenience.

The ramp is deployed when the driver stands and is removed when somebody sits to
become driver.

If the click\_to\_pause config option is used, the ramp is also deployed when the
driver puts the vehicle into Park mode and then removed when resuming driving.

If the settings are configured to enable auto-park after a given time, the ramp
is automatically removed just before the car moves back to parked location, and
then is re-deployed.

The Rez-listen-poof Boarding Ramp script should be placed in the root prim of
the boarding ramp.

The Supercar Boarding Ramp script and (scripted) ramp object should be placed in
the same prim on the car, but this doesn't have to be the root prim. There are
distance limitations on how far from an object an item can be rezzed. If the
root prim is too far from the desired ramp location, you can select a prim
closer to that location to hold the script and ramp object.

To configure the script, position the vehicle with angle x=y=z=0 to the sim and
place the ramp object manually where you would like it to be when deployed.

Check and record the <x,y,z> position of the  prim you wish to use for the
rezzer script and the <x,y,z> position of the ramp. Calculate the difference
between these two positions. In simpler terms this can be done by subtracting
the x number from the ramp position from x number of the prim position, and so
on. The resulting <x,y,z> number representing the difference between the
positions should be added for setting "offset" in the script.

With the car still at placed with angle x=y=z=0, open the Edit window on the
ramp and copy it's x,y,z angle into the setting "ramprot" (you can use the "C"
button to the right of the Angle section to copy, then paste the value into the script.)
These are angles in degrees.

That's it! You can delete the ramp you were using to calculate the settings.
Try driving the car and testing the ramp deployment.

-----

**Door Opener**

Scripts are provided for making a vehicle door/hood/hatch open and close when
touching it. Another way to describe this is that a script toggles the prim's
local offset and local angle between two positions.

Move your prim to the closed position, then drop in the Display Local Offset
script into it's contents. Touch the prim and it's local position and
rotation will be displayed in your local chat.

Then move your prim to where you want it to be for the open position. Touch it
again and the local position and rotation for the open position will be
displayed once again in your local chat.

You can now delete the Display Local Offset script from its contents.

Now open and edit the Toggle Child Prim Position script. Edit a copy in your
inventory before placing it in your car!!  Copy-paste the position and angle of
the Closed position from your local chat to the pos1 and angle1 settings of the
script. Copy-paste the position and angle of the Open position from your local
chat into pos2 and angle2 settings of the script. Save and close.

MAKE A COPY of your vehicle/object BEFORE dropping in the script!! If something
goes wrong, it may be difficult to restore the original offsets. Now that you
made a copy, edit the child prim you are working on and drop in the Toggle Child
Prim Position script that you just edited. If all goes well it should move back
to the closed position and touching it should toggle between the open and closed
positions.

You can also add sounds for opening and closing the prim, by changing the
sound\_open and sound\_closed settings. If you use the name of a sound asset, that
asset must be placed inside the prim along with the script. If you use the UUID
of the sound asset in the settings, then you do not need to add the asset to
contents.

The provided script only supports moving a single prim but it could be
customized fairly easily to move more than one prim.

-----

**Auto-Park**

There is an optional add-on script to park the car back in it's parking spot at a given
time after the driver stands. The default settings work for a single region when there
are no adjacent regions. The script can also
work across multiple adjacent regions with additional configuration steps.
See the script notes for details.

To use, set the "parkDelay" to the number of seconds after the driver stands that the car
auto-parks. The parking location is set when the script resets, but it can also be changed
by owner-touching the car when it is not being driven. This brings up a dialog to confirm
it's new park location. 

The auto-park script is integrated with the main car script in a number of ways.

1. if someone resumes driving during the park delay, the countdown is canceled.
2. If a boarding ramp option is used, a boarding ramp is rezzed when parked; That ramp will be deleted just before auto-park begins, and re-rezzed back at it's parking location. 
3. If a vehicle is configured with Click-to-Pause enabled, and the driver uses a touch menu to pause the vehicle, auto-park is temporarily disabled. Auto-park re-enables automatically when someone resumes driving the car.

If you rez a vehicle from Inventory that was previously configured to use auto-park by
either method, auto-park will automatically be disabled and you will get a message in
local chat indicating this. This is to prevent the vehicle being re-parked to a location
from previous use that is no longer relevant.  To reactivate auto-park, simply move the
vehicle to it's new parking location, touch it and confirm the dialog.

If you rez a vehicle from Inventory that was previously in countdown for auto-park, that
countdown is canceled when rezzing.


-----

**Configuration Settings**

Settings in the Config notecard template have good default values for average
sized cars. A number of settings can be changed to further
enhance your vehicle. The meaning of each setting is explained in the
notecard. The following sections detail some of these.

*click\_to\_pause*

This option allows the driver to "Pause" the vehicle without the driver standing.
Useful when a vehicle is used as a tour bus making multiple stops.
The driver can remain seated and park to let people off and on.
The driver can touch the vehicle again and select "Drive" to resume driving.

"Pausing" turns off the engine sound, lights, and deploys any boarding ramp if that option is used.
It also sets the child prims' physics types to their original state so that avatars can walk
onto the vehicle to find a seat. Without "pausing", child prims remain physics type "None" and
avatars trying to walk on it will fall through.

On larger vehicles there may be a few second delay before the physics change ("going solid") is noticed; This is a platform limitation.

"Pausing" the vehicle also has the effect of temporarily disabling the auto-park feature.
The driver has the option to stand and exit the vehicle while "paused" and the auto-park
will remain temporarily disabled. If anyone resumes driving, the "paused" feature
turns off and the next time the driver stands, auto-park will be activated 
(unless the driver decides to "pause" it again).

This is also useful for a group of people doing a tour with a number of
expected stops. "Pausing" can be selected at each stop, to disable auto-park.

click\_to\_pause is integrated with the boarding ramp script included with this
package. Pausing the vehicle triggers the rezzing of a boarding ramp, if used. When
the driver resumes driving, the ramp disappears. 

If the setting click\_to\_pause is set to FALSE, nothing happens when the seated driver
touches the car.

*turnList and speedList*

The car speed and turning radius for each gear use presets that work well for an
average sized car. If you are using this script on a very small or very big car,
it's likely that you will need to override the presets with custom speeds and turning
radius that look more realistic.

speedList is a list of integers that are the forward power of the vehicle for
the various speeds. If this list setting not blank, it will replace the defaults.
If there are fewer entries in the list as the number of gears you
are using, the default values will be applied to higher gears.

turnList is a list of floats that represent the turning power for various gears.
If this list setting not blank, it will replace the defaults. 
If there are fewer entries in the list as the number of gears you
are using, the default values will be applied to higher gears.

You can check the default values in the Supercar script and then create a list
of adjusted values.

Example 1: For a small "Cupcake Car" with a 1.5m footprint, turning radius settings that were smaller than the defaults worked best:

	turnList = [ 0.5, 1.1, 1.2, 1.2 ];
	
Example 2: For a large bus holding 20 passengers, turning radius settings that were larger than the defaults worked best:

	turnList = [ 8, 8, 8, 8 ];

*turn_in_place_speed* 

This gives the option for the car to be able to rotate in place by the driver
when not moving forward, using the left-right arrow keys. Value of 0 disables.
The number is proportional to how fast it spins. 

-----

**Link messages**

The Supercar Plus script sends llMessageLinked() messages to child prims for
various event changes. Some of the add-on scripts in the kit use these messages, 
for example, headlights turning on when a
driver sits and turning off when they stand. Custom scripts can be added to the vehicle that use these link
messages.


	car_start - when driver first sits to drive
	car_stop - when the driver stands
	car_park - if auto-park is active, just before the car parks
	ForwardSpin - when the forward arrow key is held down
	BackwardSpin - when the reverse arrow key is held down
	NoSpin - when the forward or reverse arrow key is released
	RightTurn - when the right arrow key is pressed down
	LeftTurn - when the left arrow key is pressed down
	NoTurn - when the left or right arrow key is released
	

-----

**Underlying features to Minimize Lag and Physics Shape Types**

When the script resets or is placed in a car, it checks and the physics types of
all child prims on the vehicle and stores them in memory so that it can preserve
then before and after driving. When the driver sits to drive, all child prims
are set to physics type None to minimize lag - physics calculations only need to
be made for the one root prim with a simple shape. When the driver stands, the
script restores the original physics types of all child prims.

If you change any child prim physics types on the vehicle, make sure you reset
the car script *before* you drive it so that it can refresh it's list of child
prim physics types. Otherwise you will lose your changes. There is no way for
the script to automatically detect when child prim physics type is changed, so the
script reset must be done manually.

The script has an option to selectively keep physics shape type Prim on some
child prims during driving, if needed, rather than setting every child prim type
None. This can be done by naming the Description field of any prim that you want
to remain physical to "prim" and resetting the script. This feature is useful
for creating articulating hinges on multi-axle vehicles (experimental).



----

This is a work in progress. Please notify me of bugs or feature requests.

Cuga Rajal (Second Life and Opensim)

cuga@rajal.org
