# Sonic GBA

Sonic GBA is a fan developed reinterpretation of decompiled Java output from the Android version of Sonic Advance.

All software is developed using the [Monkey programming language](https://github.com/blitz-research/monkey).

This project aims to maintain a codebase that resembles the original decompiled output,
without making any claim to parody the original behavior in any way.

## TODO

### Major:
* **Finish implementing 'sonicgba'**:
    * Implement the remaining boss behavior.
* Properly implement sound behavior.
* *Finish missing parts of 'MFLib'.*
* *Implement font behavior.*

### Minor:
* *Split supporting sub-classes into separate modules.* (Animation, etc)
* Resolve foreign text.

### Done:
* **~~Implement 'special'~~** (Special Stage objects)
* **~~Implement 'common'~~** (Utilities)
* **~~Implement 'platformstandard'~~**
* **~~Implement 'ending'~~** (Ending animations, credits, etc)
* **~~Implement 'gameengine'~~** (Input systems, etc)
* **~~Implement 'pyxanimation' / 'pyxeditor'~~**
* **~~Implement the missing portions of 'lib'~~** (Some unused features may be missing)
* **~~Implement 'state'~~** (Gameplay state, title screen, special stage state, etc)