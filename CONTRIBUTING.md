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

* Unlike the 'regal' modules' code-style, this port will not force usage of 'Return' on 'Void' methods or functions.
With that said, however, 'Void' methods/functions must be declared as 'Void'.
This is done to resolve conflicts, as Monkey 1 assumes 'Int' as a default return-type, whereas Monkey 2 does not.
In addition, strict-conformity is ideal, so it's best to declare functions/methods as accurately to Java as possible.

* Resource paths and similar details will not be changed until the initial structural work is done.

* Constant and global variables may use type inference, although this is sometimes not preferable.
Local variables follow similar rules. Although, they're more likely to be
declared with exact types due to the nature of the original code.