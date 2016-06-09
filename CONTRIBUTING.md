* All modules will be lowercase, following Monkey's standard naming scheme.
Disregarding the names, the module/file structure must represent the original source code.

* Custom files may be created, but should be avoided unless well researched.
For example, sub-classes may be moved to separate files without much of an issue.
Similarly, common patterns can be mapped to a shared base-class,
but you must follow the behavior as accurately as possible.

* All names (Unless reserved by Monkey) should remain consistent with the decompiled source code.
This basically means bad translations and foreign names will stay no matter how bad they are.
This does not cover foreign (Non-English) text, which should be translated.

* All Japanese and/or Chinese text should be replaced with English equivalents.
In addition, the original text should appear in a comment beside the updated text.
This rule is in place to ensure the text is readable and displayable using English fonts.

* Local variables should be reasonably descriptive, but this is not a requirement.
If the decompiled source doesn't have descriptive names for something, but you
know what it is, feel free to rename it. This only applies to local
variables and function/method arguments, however.

* Resources will not be modified until the project is in a sufficient state to do so.
* Initial work will be done on the 'master' branch, unless another branch is needed.
* The state of the initial version will be preserved in a new branch when the source is ready.

* Development of poorly decompiled material should likely be handled
using the 'test' branch, or otherwise carefully managed.

* The code style will follow the original C/Java practices for the most part,
other than the recommended formatting seen in most files and comments.
Other styles, such as the 'regal' Monkey modules' particular CamelCase should not
be followed, unless creating a public API extension, or the
original software followed that practice in the first place.

* Unlike the 'regal' modules' code-style, this port will not force usage of
'Return' on 'Void' methods or functions. With that said, however, 'Void'
methods/functions must be declared as 'Void', no matter the situation.
This is done to resolve conflicts, ensure readable code, and future-proof this software.

* Without exception, all non-third-party software must follow
the standard 'Strict' language rules. It's best to declare everything
as accurately as possible, excluding manual uses of 'Final', unless reflected in the original source.

* Resource paths and similar details will not be changed, unless absolutely necessary.

* Uses of 'instanceof' in Java code should be replaced with
dynamic casts and/or preliminary type checks. ('PlayerObject.getCharacterID', etc)

* Constant and global variables may use type-inference, although this is sometimes not preferable.
Local variables can, and usually *should* take full advantage of type-inference.
When a type isn't relevant, it probably shouldn't be mentioned.
(Excluding readability or otherwise reducing ambiguity)

* Comments about the function or detailed behavior of a piece of code is appreciated but not required.
Ideally, the code should stand on its own, unless you think it's particularly note worthy.

* Magic numbers *should* be marked clearly, above or near their unknown usage.
Common numbers like 1 and 0 tend not to be note worthy, and likely reflect the usage in the original code.
The key word here is ***should***. You aren't required to report anything in
your code, but it's appreciated when a number is understood
and resolved, or if not possible, marked as 'magic'.
**This isn't required, but it's appreciated.**

* Wildly incorrect usage of global or constant variables will need to be
corrected eventually, and should be handled sooner rather than later.
