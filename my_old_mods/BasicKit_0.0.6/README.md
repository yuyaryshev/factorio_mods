# BasicKit
Factorio mod for the 'no-crafting' challenge

# What it does
This mod makes factorio a lot more difficult.
It gives you the absolute minimum items you need to craft
everything and disables manual crafting completely.

This means you get these Items:
- Solar panel
- Power pole
- Assembling machine (type 3)

## Solar panel
A solar panel generates 60 Kw of power during the day.
This is barely enough to keep the assembling machine running.
The player does not gets steam energy,
because this would require at least 3 items (engine, boiler, pump),
also it makes much more energy and works during the night.
Getting steam energy running is not difficult.
This can be tweaked, see `USE_STEAM` below.

## Power pole
The power pole is needed, because it's the only way for electricity to flow.
Directly placing a machine next to a panel or a steam engine does nothing.
This can be tweaked, see `BIG_POLE` below.

## Assembling machine (type 3)
The type 3 of this device is the only one, capable of having 5 input slots.
To get this machine, you need blue science packs, to get blue science packs,
you need advanced circuits, advanced circuits require plastic.
Plastic is made from petroleum, which is made in a refinery.
A refinery requires 5 input items.
To get the 3rd assembling machine in a 'no crafting' challenge,
you need a 3rd assembling machine.

# Configuration
In the code files, certain values can be changed from `false` to `true`.
Each one of them makes the game easier in a certain way.
All values, that are to change are written in `ALL_CAPS`

## control.lua
Constants in control.lua enable certain items

### ADD_ORE
This adds 4 iron ore items into the players inventory.
This is just enough to craft the first pickaxe.
Mining a single iron ore takes about 20 seconds without a pickaxe.
This greatly speeds up the bootstrap phase.

### ADD_AXE
Gives the player a pickaxe to start with.
Without the pickaxe, the player has to mine 4 iron ores.
If the axe is too much, the `ADD_ORE` option can be used instead.

This is on by default.

### USE_STEAM
Setting this to true, gives a steam engine,
boiler and pump to the player instead of solar.

### BIG_POLE
Enabling this, gives the player a big pole instead of a small pole.
Big poles have a smaller active area around them.
Their bigger cable span can only be used by other big poles.

### ADD_BASICS
Gives the player a stone furnace and a burner mining drill.
These items are usually removed to add a small amount of difficulty back.

### ADD_ACCU
Gives the player an accumulator.
The assembling machine already drains 7 Kw when it does not works.
When crafting stuff, a solar panel can't keep up with the energy requirement by far.
The accumulator allows to bridge that gap and also allows crafting at night.

## data-final-fixes.lua
This file makes all items machine-craftable only.

### DEBUG
Setting this to true will enable all items from the start without doing the science.
This can be used to test the mod. Since all items,
that can be crafted in the assembling machine have a white background (opposed to a red one),
it can be used to easily test, if all items are available.
If an item is highlighted red, hovering over it with the mouse tells the player,
in which machine it can be crafted.
If there is no machine listed, it will be unobtainable.
This is useful when new items are added.

# Overrides
To override a certain recipe to be available, give it the category `ayras-no-crafting-challenge`
