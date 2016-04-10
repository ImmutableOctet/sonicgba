# Sonic GBA

Sonic GBA is a fan developed reinterpretation of decompiled Java output from the Android version of Sonic Advance.

All software is developed using the [Monkey programming language](https://github.com/blitz-research/monkey).

This project aims to maintain a codebase that resembles the original decompiled output,
without making any claim to parody the original behavior in any way.

## TODO
* **Finish implementing 'sonicgba'**.
* Implement 'state.gamestate'. (Only remaining module in 'state')
* Properly implement sound behavior.
* *Finish missing parts of 'MFLib'.*
* *Split supporting sub-classes into separate modules.* (Animation, etc)
* *Implement font behavior.*
* Resolve foreign text.

* **~~Implement 'special'~~** (Special Stage objects)
* **~~Implement 'common'~~** (Utilities)
* **~~Implement 'platformstandard'~~**
* **~~Implement 'ending'~~** (Ending animations, credits, etc)
* **~~Implement 'gameengine'~~** (Input systems, etc)
* **~~Implement 'pyxanimation' / 'pyxeditor'~~**
* **~~Implement the missing portions of 'lib'~~** (Some unused features may be missing)