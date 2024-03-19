**Upgrading from a 1.x version of Supercar Plus**

1. Wheel scripts are no longer needed! If your vehicle already has wheel scripts
from version 1.x, they will continue to work. However there 2 options to
eliminate the wheel scripts to reduce script count and server lag:
        
a) transfer your settings from your old wheel scripts to the wheel prim
Description (details below), and delete the old wheel scripts, or

b) just delete the wheel scripts and use the new wheel configurator See
the Wheel Rotation section on how to do this.
    
2. Driver's sit position/offset is no longer configured or enforced. Cars
already using the Supercar script are not affected. People building new cars
will need use a sit position system or separate sit script to set the driver's
sit position. This only needs to be done once, unless you change the animation.
The script does check to see if the sit offset has never been set, 
for example on a newly-rezzed prim, and if so,
changes it so that an avatar can sit on the prim to test the script.

The Supercar script will still manage playing a driver's animation that is
placed in the root prim contents, unless avSitter is being used.

3. Support has been dropped for updating the driver's sit offset dynamically
through  link messages. This feature could be useful for vehicles that
transfrorm their shape, and place the driver in different offsets depending on
the vehicle state. If this feature is needed that will have to be managed
through an external script.

4. Most people use a single animation for the driver. But the script has an
option to switch driver's animation for being idle, moving forward, or moving
fast. If you were using this feature, the settings anim_fwd, anim_idle, or
anim_fast have been moved to a separate script  "Supercar 2 Animation
Controller". You will need to drop this into your root prim and transfer your
settings.

5. If your scripted car was using the racecar HUD, this is now managed by a
separate script "Supercar 2 HUD Manager". You will need to drop this into your
root prim along with the HUD. The HUD itself has not changed. HUD-related
settings in the Config notecard have been removed.

6. The racecar particles and sound effects ("screech and smoke" and "pipeflame")
are now all controlled by one script, "Supercar 2 Racecar Effects". Read the
Racecar Effects section for details on adding this to your car.  This replaces
the "burnout effects" scripts and the "pipeflame" scripts in previous versions.
In most cases this will greatly reduce vehicle script count. You can delete
everything in the wheel contents!

7. Some settings in the previous version 1.x are no longer used, as explained
above. I recommend checking the new sample Config notecard in this package for
the list of current settings and updating yours to match.
        

Scripts for headlights, horn, or tank treds have not changed. The HUD has a
minor UI update but otherwise not changed, the old HUD will still work.

If you are upgrading from a very old version, older than 1.80, you should plan
on rescripting the whole car with the new scripts, and transfer any settings.

*Instructions for transferring your old wheel script settings are as follows:*

The simplest path is to use the Wheel Configurator. See the Quick Start section
on how to do this.

It is possible to open the old wheel script and look for the setting setting
"wheel_rotation" which will be a vector enclosed in angle brackets < >. Copy the
setting starting with < and ending with > and paste it into the Description
field of the wheel.  Then delete all the contents of the wheel prim. Repeat this
for all the wheel prims. Set the prim Name for each rear wheel prim to "rwheel",
and front wheel to "fwheel".

Then reset the Supercar 2 car script. The wheels should rotate on the correct
axis and direction but their speed might need adjusting. That is easy to do with
the Wheel Configurator.. Or you can delete the wheel scripts and just start
fresh using the Wheel Configurator. It is easy to use.
