This file covers certain quirks and common themes shown in the source code.

There's little structure here, so this is basically a
list of details that could be optimized or fixed later.

## Details:


#### Hurt + Platform + Base
There seems to be an 'event-listener' system going on with the "steam" base, platform, and "hurt" classes.
Basically, the three objects (And potentially more) maintain the behavior of one object in the world.
This may be a weird implementation quirk related to static vs. dynamic object management.

#### Common Collision Behavior
As may seem obvious, the 'refreshCollisionRect' method seems to take in X and Y coordinates.
This is usually done to refresh the current collision-rect position for the object.
This is used for events/callbacks for sure, but may also be connected to collision behavior for dynamic objects.

Something to note when porting code is that most code using 'refreshCollisionRect' tends to have the object centered in the rectangle.
This is sometimes altered a bit, for example, using an offset based on the width or height of the object's image.
At any rate, you can observe this behavior with things like 'SteamHurt', and similar classes that care about collision.

#### Animations and GimmickObjects
Many 'GimmickObject' types use an animation system which allows them to
be given "descriptor objects", which point to areas in an image/texture/atlas.

This also means a lot of boilerplate that could be avoided in theory.
Or, better yet, this system gets nixed for a proper resource manager.

Regardless, there's at least a sensible system for releasing textures/image-handles.

If it wasn't obvious, this is why I've marked certain modules as having potentially problematic dependencies.

#### Common Constructors
There seems to be a common 7-argument constructor used as a base for a lot of objects.
Particularly, this seems to come from 'GimmickObject', which seems to at least take a position and/or other critical information.
Some classes seem to suggest that the second and third arguments are X and Y positions, but this has not been proven.