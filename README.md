# Sonic GBA

Sonic GBA is a fan developed reinterpretation of decompiled Java output from the Android version of Sonic Advance.

[![YouTube video of this project](https://img.youtube.com/vi/Xq-3us3xgBg/0.jpg)](https://www.youtube.com/watch?v=Xq-3us3xgBg)

All software is developed using the [Monkey programming language](https://github.com/blitz-research/monkey).

This project aims to maintain a codebase that resembles the original decompiled output, but does not make any guarantee of 1:1 behavior to the original codebase.

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
