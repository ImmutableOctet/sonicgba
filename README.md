A multi-platform port of the Android version of Sonic Advance.
All code is ported from decompiled Java to [Monkey](https://github.com/blitz-research/monkey).

The project's source code makes the assumption that all
dependencies will be resolved when the project is "finished".

All source has been adapted from decompiled Sonic Advance
source code, and should at least be "functionally accurate".

Special thanks to [EvilHamWizard](https://forums.sonicretro.org/?showtopic=33173) of Sonic Retro for sparking the project, and
providing the original decompilation. Though the project mostly uses a better
decompiled version, the original version has been helpful regardless.

TODO List:
* **Finish implementing 'sonicgba'**.
* Implement font behavior.
* Implement the missing portions of 'lib'.
* Implement 'special'. (Special Stage objects)
* Implement 'ending'. (Ending animation behavior?)
* Implement 'gameengine'. (Input systems)
* Implement 'pyxanimation' / 'pyxeditor'.
* Implement 'platformstandard'.
* Implement 'common'. (Utilities)
* Properly implement sound behavior.
* Finish missing parts of 'MFLib'.
* Resolve foreign text.