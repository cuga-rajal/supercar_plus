# supercar_plus
Supercar Plus - Open-Source LSL Car Script

version  1.81, June 13, 2020

This is a free LSL land vehicle (car) script by Cuga Rajal and past contributors, compatible with Opensim and Second Life.

This work is licensed under Creative Commons BY-NC-SA 3.0: https://creativecommons.org/licenses/by-nc-sa/3.0/

For version information and credits please see https://github.com/cuga-rajal/supercar_plus/blob/master/Supercar_Plus_Versions_Credits.txt

For a history on how this script first came about please see https://github.com/cuga-rajal/supercar_plus/blob/master/Supercar_Plus_history.txt

-----

**Whats New in 1.8x and Upgrading From Previous Versions**

Version 1.8x of the Supercar Plus is a major rewrite that fixes bugs, improves
efficiency and adds features. If you are upgrading your vehicle from a previous
version, the following describes steps required.

The Config section and Config notecard has changed, removing some old settings
and adding new ones. If you are upgrading your vehicle from a previous version,
use the new Config notecard and transfer your settings.

Most of the add-on scripts have changed to support the new main script or with
other improvements. If you are upgrading, you may need to update these as well.

Add-on scripts were previously each on their own version numbers, which led to
confusion on what is the latest. Starting with v1.80, all add-on scripts that
depend on this release have also been numbered version 1.80.

The new headlight script works a little differently than before. It uses
different link messages to switch on and off when the driver sits and stands. If
you are upgrading and your vehicle is using headlights you need to upgrade those
scripts.

New horn script merges previous touch and HUD versions. Touch the horn prim with
your cursor or use HUD to honk.

All car sounds are now configurable in the Config notecard. See comments in the
NC for the sound settings.

The script previously set slow or fast engine sound based on detected speed, and
that threshold was not adjustable. It now sets the slow or fast driving sound
based on the gear selected. A new config setting "aggressive_gear" sets the gear
at or above which plays fast engine sound.

Two new settings "anim_fwd", "anim_idle" and "anim_fast" optionally allow
different driver animations while idle or moving forward.

There is now one wheel script for the front wheels, and one for the rear wheels.
Wheel scripts have improved support for cylinder prim wheels, and improved
instructions for configuring mesh wheels.

There are also numerous internal improvements in the script to make it more
efficient.

-----

**Quick Start Instructions:**

In it's simplest form, the script can be dropped into the root prim of an object
and used immediately. The recommended setup is to use a transparent cube prim
placed under the vehicle and set to be the root prim of the vehicle. Following
are quick instructions for this setup.

Rez your vehicle and adjust it's angle in-world so that it's square with the
sim.

Create a cube prim about the size of the vehicle's wheelbase. This can be done
by eye, it doesn't have to be exact. Make the X dimension the length and Y
dimension the width. (Setting the X-Taper to -0.15 can help the car go over
bumps and obstacles, but this causes issues with some physics engines.)

Slide this new cube prim away from the vehicle. Place the Supercar Plus script
in the prim. Sit on the prim to test drive it. Move forward using your arrow
keys and notice it's direction of movement. This will need to be match the
vehicle orientation you are linking. Stand up and then rotate the prim and/or
your vehicle so that both are oriented the same direction. Now move the root
prim with the car script back under the car along it's wheelbase. This can be
lined up by eye, it doesn't have to be exact.

Remove any driving scripts that may be on your car. If there is a special driver
sit animation in the root prim of the car, transfer that from of the car's root
prim into your inventory and then delete it from the car. Then drag it into the
new cube prim which will become the new root prim of the vehicle. Also transfer
the name of the car object to the cube prim.

Now link the car and the new root prim together, with the cube prim selected
last as the new root prim. Reset the script and then test drive it.

You will probably need to adjust the driver sit offset, gSitTarget_Pos, so the
driver appears in the driver's seat. This is the offset from the center of the
root prim.


**Passenger seats:**

Any child prim can be made sittable and used as passenger seats. This can be a
prim already on the car or a poseball can be added. It is customary to set the
'Click To' setting of passenger prims to 'Sitting' (Edit window General tab) so
it's easy for people to see which prims are intended to sit on with mouse
hover. Sit scripts do not need to remain in the sittable prims if the default
sit animation is desired; Custom animations or other actions on sit, such as
hiding the poseball, require that the sit script remain in the prim.

Do not place sit scripts in the root prim. This would cause the car not to be
drivable. The Supercar Plus script manages the driver's sit position and
animation.


**Configuration options:**

The beginning section of the script contains a number of adjustable
configuration settings. Comments in that section explain what each of the
config settings do. 

However the recommended setup is to use a notecard named Config in the same root
prim as the main script, which contasins the same configuration settings. A
sample is provided with the package. If the Config notecard is present, the
script will read settings from the notecard only and ignore settings within the
script. This is the preferred method for storing config settings because it
allows future versions of the script (bug fixes for example) to be dropped into
the prim, replacing the old one, without having to edit any settings.

The file Config.txt is the sample text content for the Config notecard.


**Accompanying scripts:**

Add-on scripts that interoerate with the main Supercar script are included with
the package. These scripts listen for signals coming from the main script to
manage other parts of the car, such as wheel rotation, headlights, horns, etc.
Details of these scripts are below.


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

In addition to sending out link_messages, the script listens for incoming
link messages beginning with "sitoffset" to dynamically adjust the driver sit
offset. This is useful for vehicles that change the driver position during
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
scripts rotate the wheel prims at the correct spin based on wheel size and car
motion, and support the multi-gear options. They are pre-configured for cylinder
prims and include notes for supporting mesh prims with different orientations. 


**Engine Sounds:**

A number of sound options are included in the configuration. Sounds files may
be dropped into the root prim, or settings can reference sound file UUIDs.

Race car sounds that came with the original iTec Supercar are included by
permission. 

If using this script in Second Life, there is an option to use sounds available
in SL, through a configuration. If this option is used, it overrides other sound
options.

**Headlights:**

Headlights can be switched on and off with the provided Headlight script. It
switches lights either at time of driving, or with an optional Supercar HUD. The
script has two functions in one script, making the face of the prim bright
like a light, and casting a projected light beam on the ground. Each of these
features can be enabled or disabled in the preferences.

With both features enabled, the script can make a prim light up and cast a
projected beam, typically for a cylinder prim for the front headlights. With
the projector feature disabled, the script can be used to light up such things as
rear driving lights and running lights. With the projector feature enabled, and
light-up feature disabled, the scipt can create a headlight beam from an
invisible prim or from a prim already on the vehicle which you do not want to
light up.

Headlight Beams made from conical shaped prims are no longer supported, although
the headlight script can be adapted to work with them.

**Horn:**

A horn script makes the horn honk when it is touched, or when gets a signal from
the optional HUD. The horn sound will be heard coming from the prim you place
the horn script in.

**Smoke and Screech Effects:**

There are assets that can be used to create smoke and squealing noise while
driving the car, typically for race car applications. Textures and sounds from
the original iTec Supercar are included by permission. These effects are best
placed into invisible prims at the bottom of the rear wheels, causing the smoke
to appear to come from the ground. Adjust the configuration settings to manage
which gears the burnout effects will appear.

**Pipe Flame:**

An optional pipeflame script can be used to produce flames from exhaust pipes.
This typically requires invisible prims placed near the exhaust pipe outlets,
and angled so that the direction of particle effects from the invisible prim
aligns to the pipe direction. The main script configuration can be used to
control which gears the pipeflame appears. 

**HUD:**

An optional HUD is provided. Setup instructions are included in the notes
in the HUD script. Once the HUD object is set up, place it in the root prim of
the car and configure the Supercar script to use it. When the driver first sits,
they will get a dialog requesting to temp-attach the HUD.

The HUD shows speed, gear selection, and includes controls for changing gears,
headlights, horn, and burnout effects. When the driver stands, the HUD
automatically un-attaches and deletes. It includes features to automatically
delete itself if not attached after a specified time, to prevent stray objects
in the region.

----

This is a work in progress. Please notify me of bugs or feature requests.

Cuga Rajal (Second Life and OSGrid)
cugarajal@gmail.com
