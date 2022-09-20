# supercar_plus
Supercar Plus - Open-Source LSL Car Script

version  1.89, Sept 20, 2022

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

**Whats new in the latest releases**

Version 1.89 has 2 changes. The click\_to\_park option now restores child prim
physics types while parked, allowing avatars to walk on the vehicle. Child prims
are switched back to physics type None when resuming driving. Also, camera
controls for avatars seated as passengers have been removed after feedback from
end users. Camera eye offsets on child prims are a persistent property. If your
vehicle used previous versions of the Supercar script and you wish to remove the
camera eye offset on child prims, you will need to use a scrubbing script that
sets
	llSetLinkCamera(LINK\_ALL\_CHILDREN, ZERO\_VECTOR, ZERO\_VECTOR )

Version 1.88 adds a new config option "useAvsitter" which if enabled, allows the
Supercar Plus script to co-exist with an avSitter scripting system, something it
was previously not compatible with.

With this option enabled, all sit offsets and animation settings in the Supercar
Plus configs are ignored. All sit offsets and animations for everyone seated
including the driver are controlled through avSitter. Please note that the
person who has control of driving the car will remain the same person regardless
of their sit position using Swap in avSitter.

Version 1.87 adds a new config option "click\_to\_park". This option, if
enabled, will allow the driver to touch the vehicle to set it to Park mode,
where the engine and lights off shut off but the driver can remain seated with
the current animations running. Click again to re-enable the engine and lights.
Useful for such things as drive-in movies. If this option is disabled, there is
no effect when the driver touches the vehicle.

For a complete list of other feature changes and bug fixes in previous releases
please see
https://github.com/cuga-rajal/supercar_plus/blob/master/Supercar_Plus_Versions_Credits.txt

-----

**About upgrading from versions earlier than 1.80**

Version 1.80 of the Supercar Plus was a major rewrite that fixes bugs, improves
efficiency and adds features. If you are upgrading your vehicle from a version
earlier than 1.80, the following steps are required:

The Config section and Config notecard has changed, removing some old settings
and adding new ones. If you are upgrading your vehicle from a previous version,
you need to use the new Config notecard and transfer your settings.

Most of the add-on scripts have changed to support the new main script or with
other improvements. If you are upgrading, you may need to update these as well.

Add-on scripts were previously each on their own version numbers, which led to
confusion on what was the latest version. Starting with v1.80, all add-on
scripts that depend on the 1.80 or newer main script have also been numbered
version 1.80 or 1.8x.

The new headlight script works a little differently than before. It uses
different link messages to switch on and off when the driver sits and stands. If
you are upgrading and your vehicle is using headlights you need to upgrade those
scripts.

New horn script merges previous touch and HUD versions. Touch the horn prim with
your cursor or use HUD to honk. The old scripts will continue to work but we
recommend upgrading.

The script previously set slow or fast engine sound based on detected speed, and
that threshold was not adjustable. It now sets the slow or fast driving sound
based on the gear selected. A new config setting "aggressive\_gear" sets the gear
at or above which plays fast engine sound.

Three new settings anim\_fwd, anim\_idle and anim\_fast optionally
allow different driver animations while idling, moving forward. anim\_fast is
an optional 3rd animation that can play when the gear is at or above
"aggressive_gear". This is useful for such things as bicycles or mouse wheels.

There is now one wheel script for the front wheels, and one for the rear wheels.
Wheel scripts have improved support for cylinder prim wheels, and improved
instructions for configuring mesh wheels.

There are also numerous internal improvements in the script to make it more
efficient.

-----

**Quick Start Instructions:**

In it's simplest form, the script can be dropped into the root prim of an object
and used immediately. The recommended setup is to use an invisible (transparent)
cube prim placed under the vehicle which holds the vehicle script, and link the
visual vehicle to it, with the invisible prim remaining the root prim.

Following are detailed instructions for this setup.

Rez your vehicle and adjust it's angle in-world so that it's square with the
sim. In most cases, you want the car's angle set to x=0, y=0, z=0.

Create a cube prim about the size of the vehicle's wheelbase. This can be done
by eye, it doesn't have to be exact. Make the X dimension of this cube prim
along the length of the car and Y dimension the width.

(Power tip is to add an x-taper of -0.15 to the prim shape settings. This can
help the car go over bumps and obstacles.)

Slide this new cube prim away from the vehicle. Place the Supercar Plus script
in the prim. Sit on the prim (right-click -> Drive) to test drive it. Move
forward and back using your arrow keys and notice it's direction of movement.
This will need to be match up to the orientation of the visual vehicle you are
linking.

Stand up and re-align the cube prim to be square with the sim by adjusting the
Angle setting to z=0. Now rotate you visual vehicle so that it is oriented the
same direction as the forward direction of the cube prim. Make sure that both
the cube prim and visual vehicle are square to the sim, so their angular
alignment can be precise.

Next, move the cube prim with the car script back under the car along
it's wheelbase. This can be lined up by eye, it doesn't have to be exact. The
angle alignment is more important than the position.

Remove any driving scripts that may be on your car. If there is a special driver
sit animation in the root prim of the car, transfer that from of the car's root
prim into your inventory and delete it from the car. Then, drag it from your
inventory back into the new cube prim, which will become the new root prim of the
vehicle. Also transfer the name of the car object to the cube prim.

Now link the car and the new root prim together, with the cube prim selected
last as the new root prim. This will cause the script to reset. Watch the script
messages in local chat, and when it indicates the script has finished resetting
and is ready to drive, then test drive it.

You will probably need to adjust the driver sit position, gSitTarget_Pos, so the
driver appears in the driver's seat. This is the offset from the center of the
root prim.


**Passenger seats:**

Any child prim can be made sittable and used as passenger seats. This can be a
prim already on the car or a poseball can be added. It is customary to set the
'Click To' setting of passenger prims to 'Sitting' (Edit window General tab) so
it's easy for people to see which prims are intended to sit on with mouse hover.
Sit scripts do not need to remain in the sittable prims if the default sit
animation is desired; Custom animations such as dancing, or other actions on sit
such as hiding the poseball, require that the sit script remain in the prim.

There are also special purpose sit scripts that can manage sits for multiple
prims, potentially reducing the total number of running scripts on the vehicle.

Do not place sit scripts in the root prim unless you intend to use the
useAvsitter option. Otherwise this would cause the car not to be drivable. The
Supercar Plus script normally manages the driver's sit position and animation in
the Config settings, without any separate sit scripts in the root prim.


**Configuration options:**

The beginning section of the script contains a number of adjustable
configuration settings. Comments in that section explain what each of the
config settings do. 

The recommended setup is to use a notecard named Config in the same root
prim as the main script, which contains the same configuration settings. A
sample is provided with the package. If the Config notecard is present, the
script will read settings from the notecard only and ignore settings within the
script. This is the preferred method for storing config settings because it
allows future versions of the script (bug fixes for example) to be dropped into
the prim, replacing the old one, without having to hand-edit any settings.

The file Config.txt provided with this package is a working template for the
Config notecard.


**Accompanying scripts:**

Add-on scripts that interoerate with the main Supercar script are included with
the package. These scripts listen for llMessageLinked() signals coming from the
main script to manage other parts of the car, such as wheel rotation,
headlights, horns, etc. Details of these scripts are below.


**Link messages:**

The Supercar Plus script sends llMessageLinked() messages to child prims for
various driver controls; For example, a script could turn on headlights when a
driver sits and turn off when they stand. Custom scripts can be added anywhere
on the car that respond to these messages: 

car\_start - when driver first sits to drive
ForwardSpin - when the forward arrow key is held down
BackwardSpin - when the reverse arrow key is held down
NoSpin - when a driver seated but not moving
car\_stop - when the driver stands
car\_park - if auto-return is active, just before car parks

In addition to sending out link_messages, the script listens for incoming link
messages beginning with "sitoffset" to dynamically adjust the driver sit offset.
This is useful for cases where vehicles  change the driver position during
normal use, for example, a scissors lift vehicle with the driver remaining in
the lift as it goes up and down.


**Minimizing Lag:**

When the script resets or is placed in a car, it checks and remembers the
physics types of all child prims on the vehicle. The script then preserves these
physics types before and after driving. When the driver sits to drive, the
script sets all child prims to physics type None to minimize lag - physics
calculations only need to be made for the one root prim with a simple shape.
When the driver stands, the script restores the original physics types of all
child prims. 

The script has an option to selectively keep physics type Prim on certain child
prims during driving, if needed. This can be done by naming the Description
field of a prim to "prim" and resetting the script. This feature is useful for
creating articulating hinges on multi-axle vehicles (experimental).


**Wheel Rotation:**

If your car has wheels, you can use the Supercar Plus wheel scripts. These
scripts receive messages from the main script to rotate the wheel prims at the
correct spin based on wheel size and car speed, and support the multi-gear
options. They are pre-configured for cylinder prims and include notes for
configuring them for mesh prims. 


**Engine Sounds:**

A number of sound options are included in the configuration. Sounds files may
be dropped into the root prim, or settings can reference sound file UUIDs.

Race car sounds that came with the original iTec Supercar are included by
permission from Shin Ingen. 

If using this script in Second Life, there is an option to use sounds available
in SL, through a configuration "use\_sl\_sounds". If this option is used, it
overrides other sound options and applies several preset sounds for startup,
idle, driving, etc.


**Headlights:**

Headlights can be switched on and off with the provided Headlight script. It
switches lights either at time of driving, or with an optional Supercar HUD. The
script has two functions in one script, making the face of the prim bright
like a light, and casting a projected light beam on the ground. Each of these
2 features can be enabled or disabled in the preferences.

With the projector feature disabled, the script can be used to light up such
things as rear driving lights and running lights. With the projector feature
enabled, and light-up feature disabled, the scipt can create a headlight beam
from an invisible prim or from a prim already on the vehicle which you do not
want to light up.

**Horn:**

A horn script makes the horn honk when it is touched, or when gets a signal from
the optional HUD. The horn sound will be heard coming from the prim you place
the horn script in.

**Smoke and Screech Effects:**

There are assets that can be used to create smoke and squealing noise while
driving the car, typically for race car applications. These textures and sounds
came from the original iTec Supercar and are included by permission from Shin
Ingen. These effects are best placed into invisible prims at the bottom of the
rear wheels, causing the smoke to appear to come from the ground. Adjust the
configuration settings to manage which gears the burnout effects will appear.

**Pipe Flame:**

An optional pipeflame script can be used to produce flames from exhaust pipes.
This typically requires invisible prims placed near the exhaust pipe outlets,
and angled so that the direction of particle effects from the invisible prim
aligns to the pipe direction. The main script configuration can be used to
control which gears the pipeflame appears. These textures
are also from the original iTec Supercar and included by permission.

**HUD:**

An optional HUD is provided in the form of an archived linkset. Setup
instructions are as follows:
- Using your viewer, import the .oxp linkset provided in the package with "Include Content" option checked.
- After the object is imported in world, take it into inventory.
- Select "Attach to HUD".. Bottom. Adjust ther HUD's screen position in the viewer so it's fully visible.
- Detach the HUD.. It is now ready to place in a vehicle.

To include it with a car, place it in the root prim of the car and configure the
Supercar script to use it. When the driver first sits, they will get a dialog
requesting to temp-attach the HUD.

The HUD shows speed, gear selection, and includes controls for changing gears,
headlights, horn, and burnout effects. When the driver stands, the HUD
automatically un-attaches and deletes. It includes features to automatically
delete itself if not attached after a specified time, to prevent stray objects
in the region.

----

This is a work in progress. Please notify me of bugs or feature requests.

Cuga Rajal (Second Life and Opensim)

cuga@rajal.org
