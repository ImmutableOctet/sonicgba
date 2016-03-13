# Description
This file contains a list of modules known to use external APIs that may or may not be ported to Monkey.

## List
    * "sonicgba.fallflush"
    * "sonicgba.fan"
    * "sonicgba.tutorialpoint"

## Notes
A number of the entries are likely to be perfectly fine.

For example the gimmick objects like fans and "fallflushes" just
use 'MFGraphics' and co. for traditional resource management.

Still, they'll be placed here if there isn't too much of a common pattern.

If this gets to be very common as the port moves forward, then only the biggest
offenders (Dependant modules) will be marked.