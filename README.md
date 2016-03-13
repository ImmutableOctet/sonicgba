A multi-platform port of Sonic Advance (Mobile) - Ported from Java to Monkey

## Port Design and Structural Notes
    * All modules will be lowercase, following Monkey's standard naming scheme.
    Disregarding the names, the module/file structue must represent the original source code.
    
    * All names will be consistent with the decompiled version unless 100% sure of their purpose.
    Variables should be renamed when completely know what they are, or what they relate to.
    In general, these details should wait until the port is properly built up (Module structure, etc).
    
    * Resources will not be modified until the project is in a sufficient state.
    * Initial work will be done on the 'master' branch, unless another branch is needed.
    * The state of the initial version will be preserved in a new branch when the source is ready.
    
    * Code style will follow C or Java practices mostly, only following other styles,
    such as the 'regal' Monkey module's comment patterns for clarity and navigation.
    Most details aren't required here, as long as the code works. At the end of the day, it's a formatting choice.