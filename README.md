# supercar_plus
Supercar Plus - Open-Source LSL Car Script

version  2.0.4, July 24, 2023 / Kit Update Mar 18, 2024

This is a free LSL land vehicle (car) script by Cuga Rajal and past
contributors, compatible with Opensim and Second Life.

This work is licensed under Creative Commons BY-NC-SA 3.0:
https://creativecommons.org/licenses/by-nc-sa/3.0/

For version information and credits please see
https://github.com/cuga-rajal/supercar_plus/blob/master/Supercar_Plus_Versions_Credits.txt

For a history on how this script first came about please see
https://github.com/cuga-rajal/supercar_plus/blob/master/Supercar_Plus_history.
txt

-----

**Summary**

Supercar Plus is a free LSL land vehicle (car) script compatible with Opensim
and Second Life. It supports a wide range of creative options for various car
features and the runtime is low-impact on the server. By using a Notecard for
settings, vehicles can be updated easily, this also helps manage a large car
collection. The full project is available at
https://github.com/cuga-rajal/supercar_plus..

Many popular features are supported, such as driver's animation, passenger
seats, multiple gears/speeds with reverse, rotating wheels, headlights, horns,
engine sounds, tank tred motions, and much more. A variety of add-on scripts are
included with instructions.

While most people will find everything they need in the Quick Start section, other
sections in this Readme have more details.

-----

**Whats New**

March 2024 - A new version of the Supercar Boarding Ramp Rezzer add-on script is available. It uses an improved method to manage ramp object UUIDs which works across region restarts. It fixes am issue of vehicles leaving stray ramp objects behind.

The section "Upgrading from a 1.x version of Supercar Plus" has been moved to a separate document in this repository since 2.x is now a couple years old.

Version 2.0.4 has the following changes since 2.0:

- Supports an option for reverse-direction left-right wheel rotation (see Wheel Rotation section for details)
- Restored original speed of 1st gear from version 1.x
- A single script to manage all headlights and brake lights, optional replacement for a script per light
- Internal scripting improvements and bug fixes


*April 18, 2023*

Version 2.0 is a major update that brings better responsiveness, lower server
impact and simplifies car scripting compared to previous versions. If you are
using a version older than 2.0 we recommend updating.

If you are upgrading a vehicle that already on a recent version
(1.80 or newer) and using a Config file for your settings, version 2.0 will work
as a drop-in replacement without changing any settings. But there is an
opportunity to reduce the script count on the car with some upgrading
steps.

The major changes from version 1.x are
    1) Overall process to script a new car is much simpler than before
    2) Separate wheel scripts are no longer needed (but it supports old wheel scripts)
    3) A new wheel configurator provides a menu-driven wheel setup without requiring hand-editing
    4) Racecar features and animation controllers were moved to separate scripts
    5) There is ~25% less code in the core script, and uses much less CPU time


-----

**Quick Start Instructions:**

Rez a cube and set the size to x=4.0, y=2.0, z=0.5. Drop the Supercar 2.0 script 
in it and sit on it to drive. Use your keyboard arrow keys to move. Notice
the direction of the prim when it goes forward. This will need to be aligned
with the vehicle when you link them.

Stand up and move the cube rotation back to x=y=z=0; You can do this from the
Edit window., Object tab. The prim direction will always drift each time you
test drive the car, so make sure set it back to be square with the sim before
adding, linking of adjusting prims.

Rez your vehicle. If it has a driver's animation, save that to your inventory,
then delete everything in the root prim. Drop in the driver's animation into the
new cube prim.  Transfer the vehicle's name to the new cube prim as well.

If the vehicle already has wheel scripts or other assets from a previous car
script system, remove those. Align your vehicle square to the sim, pointing the
same direction forward as the cube.

Now move the cube under the vehicle. Resize it to be about the size of the
wheelbase. It doesn't have to be exact, you can do it by eye.

Also add a taper in the prim shape from the Edit window Description tab, Taper x
= -0.15. This will help it go over obstacles much easier.

Now Edit your vehicle, hold down the Shift key, and select the new cube prim
last. Link them together with the Link button. You should be able to drive your
car!

Put a copy of the Config notecard in your root prim. This will hold your car
script settings.

The driver's position is likely to be wrong. You can fix this using a Sit
Positioner System or a sit script. Setting the driver's position only needs to
be done once. Make sure that you use the base prim when you set the sit position,
even if there is a separate drivers seat prim. Re-test driving the car after you
set the sit position.

To get your wheels working, name any front wheel "fwheel" and any rear wheel
"rwheel". Then drop in the Wheel Configurator to any wheel. Touch it to
begin the dialog process. When it asks to copy the settings to other wheels, say
Yes. In most cases this will get all 4 wheels working correctly. If you need to
adjust other wheels, use the Wheel Configuratopr for each individual wheel that
needs adjusting.

Many other features are detailed below.

-----

**Configuration Notecard**

The recommended setup is to use a notecard named Config in the same root
prim as the main script, which contains configuration settings. A sample is
provided with the package. If the Config notecard is present, the  script will
read settings from the notecard instead of within the script. This is the
preferred method because it allows script updates to be dropped into the prim,
replacing the old one, without needing to hand-edit any settings.

The file Config.txt provided with this package is a working template for the
Config notecard.

-----

**Wheel Rotation**

Supercar 2 no longer requires separate wheel scripts! A Wheel Configurator
provides a dialog-based setup to configure the wheels without the need to
hand-edit any numbers. It uses the Name and Description fields on the wheel
prims to store wheel settings and will overwrite anything already in the
Description. 

The Wheel Configurator requires the following preparations:

1. For each wheel prim, remove any wheel moving script in Contents that may have been there.

2. For each wheel prim, set the prim Name to "fwheel" for the front wheels (any wheels that turn left-right) and "rwheel" for the rear wheels (any wheels that stay straight)

3. For each wheel prim, erase anything in the Description (or it can say "(No Description)").

4. The Supercar 2 car script should be placed in the car and tested before using the wheel configurator
    
Once these steps are completed, the Wheel Configurator script can be dropped
into any wheel. Then click on the wheel to open the dialogs. Follow the
instructions in the dialog that appears. The script will delete itself when
setup is complete.

During the dialog configuration there is an opportunity to copy the settings to
all the wheels. In some cases, this step sets the other wheels correctly and no
further steps are needed.

When the Wheel Configurator finishes, check all your wheels. If any of the
wheels need to be adjusted, adjust them individually using the Wheel
Configurator by dropping the script into the wheel and then touching it to open
the dialog.

When you drop in the Wheel Configurator on a wheel that's already configured, it
will ask you what you want to change, such as axis, direction of rotation, or
speed. You can select the setting that needs to be changed and it will retain
the other settings. For example if you just need to change the direction, select
that option to adjust it, and then select the defaults on the remaining options
to complete the setup for that wheel.

If you adjust a wheel's speed when all the other wheels are already configured,
you have the option to copy the setting to other wheels. In this case the script
will update the speed on the other wheels but preserve the other wheels'
rotation direction. This is so it's easy to fine-tune the wheel speed after
initial setup.

*reverse turn option*

Front wheels (or any wheels that turn left-right) have an option to turn
left-right in opposite direction of the left-right keys used. This is useful for
vehicles that have wheels on rear of the car,  which need to turn in the
opposite direction as when in front. To enable this on a wheel add "reverse" to
the prim name. The prim name may contain multiple words - "fwheel", "smoke" and
"reverse" can be in any order. 

-----

**Passenger Seats**

Any child prim on the vehicle can be made into a sittable passenger seat.

Sittable prims do not need a sit script if the default avatar sits are
sufficient; In this case, you can use a sit positioner system to set the
passenger position, then you are done.

However if you need to play a passenger animation when seated, or trigger
something else when they sit, such as making a poseball invisible, then a sit
script is required in the prim. A general-purpose sit script is provided for
this, Sit w/Animation 1.5. This works on any build, vehicle or not, and are
not part of the Supercar system.

(Alternatively, you can use sit management system like avSitter if you already
know how to implement those. See Other Features section for more details.)

There are different styles on how to visually indicate a passenger seat.
Sometimes the intended seat will already be it's own prim and you can just
script that prim directly. In cases where there isn't a 1-to-1 correspondence
between a prim and seat location, you can add an invisible prim to be sittable
in an intuitive location, or add a small poseball as a visual indicator that it
can be sat on. There are different styles of doing this.

You will need to decide what prim on the vehicle will be sittable, and if
needed, place and link in a prim to act as the sittable prim.  Then you can use
a Sit Positioner System on that prim to set the passenger position.

Before you add the sit script Sit w/Animation 1.5, open it and check the first
setting "setoffset". This should be set to FALSE if you are using a Sit
Positioning System; This tells the script not to set the sit offset because it
was already done.

Or, if you want to set the passenger position manually, set "setoffset" to TRUE
and adjust the settings "sitposition" and "sitrotation". The script comments
explain how to adjust these. The Sit Positioner System will also put its results
in local chat, so you can copy those into the script settings if needed,

Either way, the script will manage playing an animation is also placed in the
prim contents. The script settings also give options to switch visibility of the
prim when they are sat on or to add hover text. Comments in the script describe
these options in more detail.

It is customary to set the "Click To" setting of any passenger prim to
'Sitting'. You can change this from the Edit window General tab. This makes it
more intuitive for people to find a seat by hovering their mouse over the car to
see which prims are intended to sit on. Check the Click Action of your sit prims
and adjust it to "Sitting" if needed.

For vehicles with many seats, you can potentially reduce the total number of
running scripts on the vehicle by using a special script also provided with this
package, "Manage Child Prim Sits" (See the Other Features section). This single
script can manage sits and animations on all passenger seats.

Do not place sit scripts in the root prim! This causes the car not to be
drivable.

-----

**Engine Sounds**

You can add your own engine sounds or use sounds provided.

In Second Life the is a config option "use\_sl\_sounds" that plays a series of car sounds
available on that grid. 
This a simple way to play engine sounds from your car in SL without having
individual sound files. If you use this option you don't need to configure
individual sounds.

You can also use your own car sounds. Just drop them into the root prim and
update this Config section with your sound names. Alternatively, you can use
sound UUIDs in the configs without needing to place sounds in the root prim.

Race car sounds are also provided in the repository.  These came with from
original iTec Supercar by Shin Ingen and are included here by permission. 

-----

**Headlights**

Headlights can be switched on and off with one of the provided headlight
scripts. These scripts will switch  lights either at time of driving, or with an
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

The script "Supercar Headlight 1.80" is a simple script that can be placed in
each prim that you want to light up and/or to cast a light projection when car
lights are turned on. The script has a few configuration options where you can
adjust lighting features. There are also settings to enable or disable the face
light-up or projectior feature on a per-prim basis. This allows you to assign
separate prims as the visual headlight on the car and other invisible prims that
may be used to cast a projection. Separate prims are often needed because the
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

There is an option to add wheel smoke, wheel screech sounds, and exhaust pipe
flame and smoke to the vehicle, as follows.

All these effects are now controlled by one script, Supercar 2 Racecar Effects.
This script must be placed in any prim OTHER THAN THE ROOT PRIM. The
selected prim is where the sounds will come from.

There are 2 versions of this script included. The one named "w/pipesmoke" adds
smoke from the tailpipes when they are not making flames.

Prims that you want to display smoke when turning left and right, typically the
wheels, should have "smoke" included in its name. Wheel prims that are already
named "fwheel" or "rwheel" can be named "fwheel smoke" or "rwheel smoke".

Prims that are meant to display exhaust pipes flame effects should be named
"flame" or append "flame" to the existing name.

When the script  is placed in the vehicle, it checks for child prims for "smoke"
or "flame" and remembers those prims. Then the effects are triggered while
driving.

The particle texture settings in the script can be the particle asset name or
it's UUID. If a asset name is used, a copy of the texture asset MUST be placed
in the contents of each prim where that asset is expected to be used. However if
a UUID is used in the settings, the texture assets do not need to copied to the
object.


The sound settings can also be the asset name or UUID. If sound asset names are
used, the sound assets must be placed in the same prim as the Supercar 2 Racecar
Effects script. If the UUID is used in the settings, the sound assets do not
need to copied to the object.


The script is pre-configured for the texture names and screech sounds provided
in the kit. However you can use your own textures or sounds, or UUIDs, and
update the settings.

Make sure you reset the Supercar 2 Racecar Effects script if you change the prim
names or  assets in contents.

Other settings:
    
    - "burnout_gear" is the gear number that will play all the effects when
    moving forward or backward. To disable this feature set it to 0.

    - "turnburnGear" - this gear and above will make smoke & screech sounds when
    turning. Only on the side opposite the turn direction, adding realistic
    effects.

Tailpipe flame effects are displayed for 3 seconds when the car starts up, and
whiledriving in burnout gear.

The textures and sounds provided in this kit came from the original iTec
Supercar by Shin Ingen and are included by permission.

-----

**HUD**

An optional HUD is provided with the package. 􀀔

To include it with a car, place the HUD in the root prim of the car along with
the script Supercar 2 HUD Manager. When the driver sits, they will get a
dialog requesting to temp-attach the HUD.

The HUD shows speed, gear selection, and includes controls for changing gears,
headlights, horn, and smokescreen. When the driver stands, the HUD automatically
un-attaches and deletes. It also deletes itself if not attached after a
specified time, to prevent stray objects in the region.

If the headlights, horn, and smokescreen are active when the driver stands, they
will be deactivated at  that time.

-----

**Driver Animation Controller**

Most people use a single animation for the driver. But there is an option to
switch driver's animation for being idle, moving forward, or moving fast. This
is Supercar 2 Animation Controller script. The script has instructions in the
comments on how to set it up. You configure the script with names of the driver
animations, then place copies of the animations into the root prim contents
along with the script.

If you were using this feature before Supercar version 2.0, the settings
anim\_fwd, anim\_idle, or anim\_fast that were previously in the Config notecard
will need to be transfered to this script.

-----

**Manage All Child Prim Sits With One Script**

The script Manage Child Prim Sits can manage sits for many passenger seats with
one single script, greatly reducing the script count on the vehicle and reducing
lag. It is easier to set up than avSitter but has some limitations and
advantages.

Avatars can sit directly on the prim they choose. It provides only one animation
per seat, but you can have a mix of different animations in the seats all
managed with one script and an easy setup process: 

    1. Create individual sits in child prims with individual sit scripts and
    animations Adjust the sit offsets on each sit prim for specific animations.
    2. For each seat prim,
        a) copy the exact name of the animation to the prim Description,
        b) set the prim Name to the word "sit",
        c) Place a copy of the seat's animation into the root prim
        d) then remove the sit script and the animation from the seat prim
    4. Place a copy of this script in the root prim
    
If you use this option, you will also need to use the Supercar 2 Animation
Controller script to manage the driver's animation.

-----

**Boarding Ramp Rezzer**

The script Supercar 2 Boarding Ramp Rezzer manages the rezzing and removal of a
boarding ramp object which is typically used for larger vehicles. This allows
avatars to walk up the ramp from ground level up onto the vehicle without having
to fly up, adding realism and convenience.

The ramp is deployed when the driver stands and is removed when somebody sits to
become driver.

If the click\_to\_park config option is used, the ramp is also deployed when the
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

To configure the script, position the car with angle x=y=z=0 to the sim and
place the ramp object manually where you would like it to be when deployed.

Check and record the <x,y,z> position of the  prim you wish to use for the
rezzer script and the <x,y,z> position of the ramp. Calculate the difference
between these two positions. In simpler terms this can be done by subtracting
the x number from the ramp position from x number of the prim position, and so
on. The resulting <x,y,z> number representing the difference between the
positions should be added for setting "offset" in the script.

With the car still at placed with angle x=y=z=0, open the Edit window on the
ramp and copy it's x,y,z angle into the setting "ramprot" (you can use the "C"
button to the right of the Amgle section to copy.) These are angles in degrees.

There is also a setting "key\_prim" setting which is the prim number on your
object that will store the UUID of the rezzed ramp i it's Description field. The
script does this automatically so choose a prim that doesn't require anything
important there. Don't use the root prim or any of the wheel prims since those
have reserved use of the Description field. Any other prims on the vehicle will
be ok. This is required to prevent stray ramps to be remain rezzed in the
regions after sim restarts or sim upgrades, which may cause the script to lose
it's state. 

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

**Configuration Settings**

Settings in the Config notecard template have good default values for average
sized cars. A number of settings can be changed to further
enhance your vehicle. The meaning of each setting is explained in the
notecard. The following sections detail some of these.


*useAvsitter* 

The setting useAvsitter adds the option to use the avSitter system (or any sit
managing system) to manage avatar sits. With this enabled, the car script does
not change the driver's animation. All sit offsets and animations for all seated
avatars including the driver are controlled through avSitter or the sit managing
system. Please note that the person driving the car will remain the same even if
they swap positions in avSitter.

*click_to_park*

The setting click\_to\_park adds the option for the driver to touch the vehicle
for a dialog that allows them to "park" the vehicle without unseating the driver
or affecting other passengers. This is useful for drive-in movies, or when a
vehicle is used as a tour bus, The driver can park to let people off and allow
others to board. The driver can touch the vehicle again for a dialog to resume
driving.

When "parked" the vehicle engine stops, headlights turn off, physics is turned
off, and physics types of child prims are restored to their original values.
This allows departing or arriving passengers to walk on the vehicle without
falling through, in order to exit or find a place to sit.

Without putting the vehicle into "parked" mode while a driver is seated, trying
to walk on the vehicle results in the avatar falling through the vehicle. So
this setting is ideal when avatars are expected to board and exit.

it also allows a group of people to go out on tour and temporarily disable the
auto-park while visiting a destination.

The driver can also exit the vehicle while "parked". This overrides the
auto-park feature and the vehicle will not move back to its home position after
a set time, if configured. When the driver resumes driving, the "parked" feature
turns off and the next time the driver stands, auto-park will be activated.

Parking the vehicle also triggers the rezzing of a boarding ramp, if used. When
the driver resumes driving, the ramp disappears, and the physics types of child
prims are set to None.

If the setting click\_to\_park is set to FALSE, nothing happens when the driver
touches the car.

*turnList and speedList*

The car speed and turning radius for each gear use presets that work well for an
average sized car. If you are using this script on a very small or very big car,
you might want to override the presets with custom speeds and turning radius
that look more realistic.

speedList is a list of integers that are the forward power of the vehicle for
the various speeds. If this list setting not blank, it will replace the default.
You must have at least as many entries in the list as the number of gears you
are using on the car. They correspond to gear 1, 2, etc.

turnList is a list of floats that represent the turning power for various gears.
If this list setting not blank, it will replace the default. You must have at
least as many entries in the list as the number of gears you are using on the
car.

You can check the default values in the Supercar script and then create a list
of adjusted values.

*turn_in_place_speed* 

This gives the option for the car to be able to rotate in place by the driver
when not moving forward, using the left-right arrow keys. Value of 0 disables.
The number is proportional to how fast it spins. 

-----

**Link messages:**

The Supercar Plus script sends llMessageLinked() messages to child prims for
various driver controls; For example, a script could turn on headlights when a
driver sits and turn off when they stand. Custom scripts can use these link
messages to further customize the car.


	car_start - when driver first sits to drive
	ForwardSpin - when the forward arrow key is held down
	BackwardSpin - when the reverse arrow key is held down
	NoSpin - when the forward or reverse arrow key is released
	RightTurn - when the right arrow key is pressed down
	LeftTurn - when the left arrow key is pressed down
	NoTurn - when the left or right arrow key is released
	car_stop - when the driver stands
	car_park - if auto-park is active, just before the car parks

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
the script to automatically detect when child prim physics types change so the
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
