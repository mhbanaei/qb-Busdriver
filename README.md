# qb-Busdriver
It allows players to drive as a bus driver, and it has multiple terminals.

Basically, what you can do is configure a bus spawn location and a delivery bus location, both of which act as one terminal.
Each terminal has a custom route that you can customize.
You can also define how much reward you want to pay the bus driver, and this reward is defined for each terminal.
For example, if a bus driver decides to work at Terminal 1, they would receive a reward of 100.
If another driver decides to work at Terminal 2, they would receive a reward of 150 , and so on.
I assume you got the point.

It is important to note that whenever the route ends, the bus driver should drive from the bottom stop location to the top.
So, these top locations go from top to bottom and bottom to top as a loop.
Whenever the driver decides to stop working, they can return to the bus depot location.
I also made an optional command to print the current terminal configurations.
This will print the spawn locations, depot locations, and stop locations.

A little note to keep in mind:
There will be a translation file for other languages, but for now, the language in use is Persian inside the Client/main.lua.
As I said, I will add other languages in the future, but as far as I know, it isn’t hard to figure out what corresponds to what.

And as you know, this is the QBox Framework.