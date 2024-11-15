# supercar_plus
Supercar Plus - Open-Source LSL Car Script

version 2.1.0, Nov 14, 2024

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

Supercar Plus is a free LSL land vehicle (car) script compatible with Opensim
and Second Life. It supports a wide range of creative options for various car
features and the runtime is low-impact on the server. By using a Notecard for
settings, vehicles can be updated easily by swapping out the main script without
the need to hand-edit any settings. The full project is available at
https://github.com/cuga-rajal/supercar_plus.

Many popular features are supported, such as rotating wheels, headlights, horns,
driver's animation, passenger seats, multiple gears with reverse, 
engine sounds, tank tred motions, and much more. A variety of add-on scripts are
included with the package along with instructions.

While most people will find everything they need in the Quick Start section, other
sections in this Readme have more details.

-----

**Whats New**

Version 2.1 has the following changes since 2.0.x:

- [Change] The config setting useAvsitter has been removed, but avSitter is still supported.
  Driver animation is now played by the script if there is one and only one animation in the Contents.
  If there is more than one animation in the Contents then the Supercar main script will
  assume another animation system is being used, and not play any. The script managing multiple
  animations can be the kit-provided script, avSitter, or others. This change allowed some leaner code.
  See the Animation Controls section for details on the benefits and limitations of avSitter versus
  other systems.
- [Usability] Improved default values for turning radius. There was a re-calibration of viewer
  turn controls in Firestorm 7.x viewer, the new settings shuld work better on the latest viewers.
- [Bug Fix] If the configurations turnList or speedList contain fewer entries then the number of gears you
are using, the script no longer breaks when you gear up beyond the list; default values will be applied to higher gears.
- [Usability] Renamed auto_return_time to auto_park_time, to avoid confusion with parcel auto return
- [Usability] Renamed click_to_park to click_to_pause, to avoid confusion with auto-park
- [Usability] Better handling of the case where an object is rezzed after being returned to inventory
in a driving state, typically by going off-world while being driven.
- [Added] Multi-sim auto-park script added to the package; See new detail section on auto-park.



*Upgrading from a 2.0.x version of Supercar Plus*

In the Config notecard, 

	- Rename auto_return_time to auto_park_time
	- Rename click_to_park to click_to_pause
	
The setting useAvsitter is no longer used and can be removed.

*Upgrading from a 1.x version of Supercar Plus*

Please see the separate document
"Upgrading from a 1.x version of Supercar Plus". In most cases it is easier to
start over with the latest version and transfer your settings to the new Config 
notecard format.

-----

**Quick Start Instructions:**

Any object can be made a "vehicle" by attaching it to an invisible scripted prim
that lies flat on the ground. In most cases the LI of the object should be kept under 32,
but there are tricks to allow higher LI counts to work, described in other
sections of these docs.

Rez a cube and set the size to x=4.0, y=2.0, z=0.5. Drop the Supercar script 
in it and then sit on it to drive. Use your keyboard arrow keys to move. Notice
the direction of the prim when it goes forward. This will need to be aligned
with the vehicle when you link them.

Stand up and move the cube rotation back to x=y=z=0; You can do this from the
Edit window, Object tab. The prim will usually drift each time you
test drive the car, and it's important to set it back to be square with the sim before
adding, linking of adjusting prims.

Now, rez your vehicle. If it has a driver's animation, save that to your inventory,
then delete everything in the root prim. Drop in the driver's animation into the
new cube prim.  Transfer the vehicle's name to the new cube prim as well.

If the vehicle already has wheel scripts or other assets from a previous car
script system, remove those. Align your vehicle square to the sim, pointing the
same direction as the forward direction of the cube.

Now move the cube under the vehicle. Resize it to be about the size of the
wheelbase. It doesn't have to be exact, you can do it by eye.

Now make a small adjustment to the shape from the Edit window Description tab.
For Opensimulator, you can get better stability by switching the base prim shape
to Sphere, after resizing it in the previous step. In SL, you can improve the mobility 
by adding a taper to the prim shape by setting Taper x= -0.15. 
This will help it go over obstacles much easier. 

Now Edit your vehicle, hold down the Shift key, and select the new cube prim
last. Link them together with the Link button. You should now be able to drive your
car.

The driver's position is likely to be wrong. You can fix this using a Sit
Positioner System or with a sit script. Setting the driver's position only needs to
be done once. Make sure that you use the base prim when you set the sit position,
even if there is a separate drivers seat prim. Re-test driving the car after you
set the sit position to make sure the driver's position looks correct.

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

Supercar no longer requires separate wheel scripts! A Wheel Configurator
provides a dialog-based setup to configure the wheels without the need to
hand-edit any numbers. It uses the Name and Description fields on the wheel
prims to store wheel settings and will overwrite anything already in the
Description. 

The Wheel Configurator requires the following preparations:

1. For each wheel prim, remove any wheel moving script in Contents that may have been there.

2. Set the prim Name to "fwheel" for the front wheels (or any wheels that turn left-right) and "rwheel" for the rear wheels (or any wheels that stay straight)

3. For each wheel prim, erase anything in the Description field (or it can say "(No Description)").

4. The Supercar 2 car script should be placed in the car and tested before using the wheel configurator
    
Once these steps are completed, the Wheel Configurator script can be dropped
into any _one_ wheel. Then click on that wheel to open the dialogs. Follow the
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

Wheels that turn left and right in addition to rotating have an option to turn
left-right in opposite direction of the left-right keys used. This is useful for
vehicles that have wheels on rear of the car,  which need to turn in the
opposite direction as when in front. To enable this on a wheel add "reverse" to
the prim name. The prim name may contain multiple words - for example, 
"fwheel", "smoke" and "reverse" can be in any order. 

-----

**Passenger Seats**

Any child prim on the vehicle can be made into a sittable passenger seat.

Sittable prims do not need a sit script if the default avatar sits are
sufficient; In this case, you can use a sit positioner system to set the
passenger position, then you are done.

However if you need to play a passenger animation when seated, or trigger
something else when they sit, such as making a poseball invisible, then a sit
script is required in the prim. A general-purpose sit script is provided for
this, Sit w/Animation 1.5. This works on any build, vehicle or not, and is
not limited to the Supercar system.

Alternatively, you can use sit management system like avSitter if you already
know how to implement those. avSitter can work well
for a small number of seats, but it has been
found to cause performance problems when too many sit locations are used. Excessive scripts in
the vehicle can cause out-of-memory conditions and problems with sim crossings.

If you want to manage animations for a large number of passenger seats, avoid these
problems by using the scripts provided with this package. 

There are different styles on how to visually indicate a passenger seat.
Sometimes the intended seat will already be it's own prim and you can just
script that prim directly. In cases where there isn't a 1-to-1 correspondence
between a prim and seat location, you can add an invisible prim to be sittable
in an intuitive location, or add a small poseball as a visual indicator that it
can be sat on. There are different styles of doing this.

You will need to decide what prim on the vehicle will be sittable, and if
needed, place and link in a prim to act as the sittable prim.  Then you can use
a Sit Positioner System on that prim to set the passenger position.

Before you add the sit script Sit w/Animation 1.5, open that script in your inventory and check the first
setting "setoffset". This should be set to FALSE if you are using a Sit
Positioning System; This tells the script not to change the sit offset because it
was already done. In this case, the main purpose of the sit script is to play
the animation or make other changes, depending on your settings.

If you want to manually adjust the passenger position and rotation numerically, you can
set the "setoffset" config option to TRUE and then hand-adjust the numerical values
"sitposition" and "sitrotation". The script comments explain how to do this.

If you first used the Sit Positioner System, that system prints it's settings to local
chat. You then have the option to hand-copy those settings out of local chat and into the
sit script, to preserve the current settings, and then switch to numerical adjustments to
fine-tune the sit position.

Either way, the script will manage playing an animation is also placed in the
prim contents, switch visibility and/or hover text of the prim sat on.

It is customary to set the "Click To" setting of any passenger prim to 'Sitting' so that
it is easily recognized by the mouse cursor changing to a seat icon when you hover over
that prim. You can change this from the Edit window General tab. 

For vehicles with many seats, you can reduce the total script count of the vehicle
by replacing all of them with a special script "Manage Child Prim Sits" provided in this
package. (See the Other Features section). This single
script can manage sits and animations on all passenger seats, with some limitations.

Do not place sit scripts in the root prim! This can cause problems with the the driver's
sit position and may cause the car not to be drivable.

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
continuous smoke from the tailpipes when they are not making flames.

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
in the same prim as the Supercar 2 Racecar Effects script.

The sound settings can also be the asset name or UUID. If sound asset names are
used, the sound assets must be placed in the same prim as the Supercar 2 Racecar
Effects script.

The script is pre-configured for the texture names and screech sounds provided
in the kit. However you can use your own textures or sounds, or UUIDs, and
update the settings.

If you change these prim names or assets in Contents after the script is in the car, you will
need to reset the script to recognize the changes.

Other settings:
    
    - "burnout_gear" is a specific gear that will play continuus sound and particle
     effects when moving forward or backward. To disable this feature set it to 0.
     Burnout in real life is to heat the tire rubber just before a race to improve
     adhesion; and to test functioning of the engine at full RPM before the race.

    - "turnburnGear" - this gear and above will make smoke & screech sounds when
    turning, on the side opposite the turn direction

Tailpipe flame effects are displayed for 3 seconds when the car starts up, and
whiledriving in burnout gear.

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

Most people use a single animation for the driver. But there are occasions when you want
the driver animation to change depending on if the vehicle is stopped, moving, or going fast.
For example, a bicycle, or a hamster wheel. The Supercar 2 Animation Controller add-on script can do this.

The script has instructions in the
comments on how to set it up. You configure the script with names of the driver
animations, then place copies of the animations into the root prim contents
along with the script. The settings anim\_idle, anim\_fwd and anim\_fast correspond
to being stopped, moving or moving fast.

You will also need to use this script if there are more than one animation in the root prim Contents,
and you want the driver to play a specific animation when driving. Set all 3 options
to the animation you want to use.

If you were using this feature before Supercar version 2.0, the settings
anim\_fwd, anim\_idle, or anim\_fast that were previously in the Config notecard
will need to be transfered to this script.

-----

**Manage All Child Prim Sits With One Script**

The script Manage Child Prim Sits can manage sits for many passenger seats with
one single script, greatly reducing the script count on the vehicle and reducing
lag. It can also prevent out-of-memory conditions and lag that may occur when 
using avSitter on a vehicle with a large number of seats.

The script supports one animation per seat which can all be different, and
the setup process is fairly easy:

    1. Create individual sits in child prims with individual sit scripts and
    animations Adjust the sit offsets on each sit prim for specific animations.
    2. For each seat prim,
        a) copy the exact name of the animation to the prim Description,
        b) set the prim Name to the word "sit",
        c) Place a copy of the seat's animation into the root prim
        d) then remove the sit script and the animation from the seat prim
    3. Place a copy of this script in the root prim
    
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
button to the right of the Angle section to copy.) These are angles in degrees.

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

**Configuration Settings**

Settings in the Config notecard template have good default values for average
sized cars. A number of settings can be changed to further
enhance your vehicle. The meaning of each setting is explained in the
notecard. The following sections detail some of these.

*Auto-Park* 

The script has an optional feature to park the car back in it's parking spot at a
given time after the driver stands. This built-in feature works only for a single region
where it can not be driven to adjacent regions. 
If there are multiple adjacent regions then this script feature should be disabled 
and you can use the separate Multi-Sim Auto-Park script instead.

To use the single-region feature, set the config option _auto\_park\_time_ to the
number of seconds after the driver stands that the car auto-parks. To disable
the single-region feature set _auto\_park\_time_ to 0. If used, the parking location is set
when the script resets, but it can be changed by owner-touching the car when it is
not being driven. This brings up a dialog to confirm it's new park location. 

The Multi-Sim Auto-Park script has similar settings at the top of the script for
delay before parking. It requires some additional setup detailed in the script comments.
It works where the adjacent regions are in a rectangular grid of A by B regions, all
of the same size. The setup requires capturing the names of each of the regions and adding
them to the configuration. 

Like the single-region feature, the Multi-Sim Auto-Park script sets the parking location
when the script resets, but it can be changed by owner-touching the car when it is
not being driven. This brings up a dialog to confirm it's new park location. 

When using either the single-region feature or multi-region script, both options allow you
to set or reset the parking spot, and to configure the parking delay.
Both options announce in local chat when auto-park countdown begins, and when it is complete. 
Both options integrate with the Boarding Ramp Rezzer script. 
If a boarding ramp is being rezzed when parked, that ramp will be removed just before 
vehicle parking begins, and re-rezzed back at it's parking location. 

If you rez a vehicle from Inventory that was previously configured to use auto-park
by either method, auto-park will automatically be disabled and you will get a message in
local chat indicating this. This is
to prevent the vehicle being re-parked to a location from previous use that is no longer relevant. 
To reactivate it, simply move the vehicle to it's new parking location, touch it and confirm the dialog.

*click_to_pause*

The setting click\_to\_pause adds some options that are useful in group situations, and
integrates with auto-park.

This option brings up a dialog to the vehicle _driver_ when they touch the vehicle while
driving.

The dialog allows them to "Pause" the vehicle without the driver standing.
This is useful when a vehicle is used as a tour
bus; The driver can remain seated and park to let people off and allow others to board.
The driver can touch the vehicle again for the dialog and select "Drive" to resume driving.

When "paused" the vehicle engine stops, headlights turn off, physics is turned off, and
most importantly, physics types of child prims are restored to their original values. This
allows departing or arriving passengers to walk on the vehicle without falling through, in
order to exit or find a place to sit.

Without putting the vehicle into "paused" mode, trying
to walk on the vehicle results in the avatar falling through the vehicle. So
this setting is ideal when passengers are expected to board and exit during vehicle use,
such as public transportation.
This can be useful for other situations such as at drive-in movies, where you want to stop the engine with
driver and passengers still seated.

On larger vehicles there may be a few second delay before "going solid" is noticed; This is a platform limitation.

"Pausing" the vehicle also has the effect of temporarily disabling the auto-park feature.
The driver has the option to stand and exit the vehicle while "paused" and the auto-park
will remain temporarily disabled. If any driver resumes driving, the "paused" feature
turns off and the next time the driver stands, auto-park will be activated 
(unless the driver decides to "pause" it again).

This is useful for a group of people going on a tour with a number of
expected stops. The auto-park can be disabled at each stop, and then re-engaged at the end.

The boarding ramp script included with this
package integrates with this feature. Pausing the vehicle also triggers the rezzing of a boarding ramp, if used. When
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

Example 1: For a small "Cupcake Car" with a 1.5m footprint, settings that were smaller than the defaults worked best:

	turnList = [ 0.5, 1.1, 1.2, 1.2 ];
	
Example 2: For a large bus holding 20 passengers, settings that were larger than the defauts worked best:

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
