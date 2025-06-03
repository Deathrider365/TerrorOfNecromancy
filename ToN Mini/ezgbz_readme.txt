#----------
# Intro
#----------

Tileset Title: ezgbz
ZC Version: ZC 192b183

#----------
# Overview
#----------

Create your own Gameboy Zelda quest! Based off Glenn The Great's cgbz tileset.

#----------
# Documentation
#----------

CSets:

I organized each cset into four distinct colors of three shades each, separated by four constant colors. The general cset layout is as follows:

X | 1 | FL | 2 | BLK | 3 | WH | 4

where X is transparent, 1-4 are the four distinct colors, FL is the flower color (usually pink), BLK is black, and WH is white.

Level Palettes:

From the layout above, each color draws something different. Color 1 is the constant level color, used for floors, mountains, sand, etc. Color 2 draws green objects and dungeon walls.* Color 3 is used for general objects like stones, statues, blocks, and jars. Color 4 is used for red and blue objects like water, lava, and chests.

        |  color 1  |  color 2  |  color 3  |  color 4
--------+-----------+-----------+-----------+-----------
cset 2  |  constant |  green    |  grey     |  red
cset 3  |  constant |  dgnwalls |  tan      |  blue
cset 4  |  extra    |  extra    |  extra    |  extra

* Specifically, color 2 cset 2 draws trees and auxiliary dungeon floor tiles. Color 2 cset 3 draws grass and dungeon walls.

Main Palette:

Color 1 is usually brown. Color 2 is usually orange or gold. Color 3 is the sprite color; it switches from green, blue, red, grey, etc., depending on the cset. Use color 4 as another sprite color.

        |  color 1  |  color 2  |  color 3  |  color 4
--------+-----------+-----------+-----------+-----------
function|  brown    |  gold     |  sprites  |  sprites2

There should be no pressing need to change the main palette colors. Also, if you change cset 9, keep in mind that certain enemies use this cset.

Tiles:

page 00: Link, equipment, items
page 01: weapon animations, Ganon
page 02: frames and maps
page 03: labels and backend text
page 04-05: scrap for weapons, animation, maps, etc.
page 06-32: new enemies
page 33-35: sprites, font, misc. graphics
page 36-39: scrap for sprites and enemies
page 40-52: overworld
page 53-58: dungeon
page 59: door sets
page 60-62: ow/dgn scrap
page 63-64: title screen
page 65+: your own tiles

The scrap pages contain extra graphics. None of them exist as combos, so you can move or delete them to your liking.

Combos:

Look over the list of combos before designing your quest! You're free to shuffle combos around, add/remove space, delete unwanted combos, etc.; doing so won't affect door sets, cycled combos, or map 1.

Combo page 40 contains extra combos for your convenience, namely the title screen and other combos that are tedious to implement. If you want to use them, I suggest you copy them to a lower page number.

Combo pages 50 and beyond contain combos that shouldn't be moved, such as combo cycles, door sets, map 1 combos, etc.

Door Sets:

Five door sets are implemented. To draw dungeon doors properly, you need to use layer 3 to cover the outer wall combos. Door set tiles are found on page 59.

Map 1:

On map 1 you will find a preview of all the level palettes. Each screen coordinate corresponds to the palette number. Shuffling and deleting combos will not mess up any screens (except for the title screen).

#----------
# Special Notes
#----------

- Use layers!
- Tiles have been edited to favor functionality and simplicity.
- For bush clippings and tall grass animations, use cset 2.
- Cset 4 is usually blank. Use it to make your own cset.
- Not all graphics will match up. That's the style of the set.
- Gameboy graphics generally have a sharp contrast between the lightest two shades. If you find the colors too sharp for your tastes, try adjusting the lightest shade to blend with the second shade.

#----------
# Feedback and Help
#----------

PM Akkabus if you need help:
http://www.purezc.com/forums/index.php?showuser=6300

#----------
# Credits
#----------

Akkabus, compiler
Glenn The Great, cgbz tiles, palettes
Mr. Z, tileset framework, PTUX tiles, palettes
Will Bill, Pure tiles
Radien, tileset framework, DoR tiles
Warlock, newfirst tiles
Taco Chopper, sprites and tiles
Taco Chopper, ideas from cgbz_update
http://www.spriters-resource.com/, sprites
http://tsgk.captainn.net/, sprites
Trimaster001, title
Xavier, title
Ebola Zaire, gasha tree sprite, advice and help
Bonegolem, ideas from Quest For Hyrule 3
Bonegolem, loose tiles
DarkFlameWolf, ideas from Ganon's Claim
DarkFlameWolf, loose tiles
http://www.vgmaps.com/, colors and sprites
dlbrooks34, tiles
Phoenix, ideas from The Dark Wizard
Phoenix, door tiles
Phoenix, special thanks
Phantom Menace, classic LOZ tiles
Joe123, ideas and palettes from The Fort Knights
Joe123, advice and help, Link/loose tile rips
Joe123, custom tiles
Joe123, Link's Awakening corrected palettes
Joe123, special thanks
Zemious, custom tiles
Matthew, ideas from Realm Of Mirrors
Hergiswi, loose tiles
Spiro, Link slash tiles
Rocksfan13, newfirst ice tile rip

PM Akkabus if your name is missing. Thank you.

#----------
# Release Notes
#----------

Release 1: December 22 2007
