//VERSION 1.01
//Author: Venrob

Requires: Tango.zh

TangoHandler Setup:

Download the latest Tango.zh and place the 'tango' folder in your ZC directory.
Import the 'TangoHandler.zs' file.
Import the 'customTango.zh' file.

COMBO_PRESSA - a combo containing the indicator for the player to press A to advance the text.
COMBO_UPARROW - a combo containing an up-arrow, indicating that the player can scroll the message upwards
COMBO_DOWNARROW - a combo containing an down-arrow, indicating that the player can scroll the message downwards
COMBO_MENUCURSOR - a combo contiaining the cursor used to select menu options

TILE_BACKDROPUL - The upper-left corner of a 12x3 set of tiles, which are drawn as the background of the message box.

SFX_MENUMOVE = 5; //The sound to play when changing menu options
SFX_MENUCONFIRM = 5; //The sound to play when confirming in a menu
SFX_MENUDENY = 5; //The sound to play when canceling in a menu
SFX_TEXT = 18; //The sound of text advancing

COLOR_TEXT_MAIN - The main text color
//The below colors are triggered automatically for text surrounded by double-brackets (of 4 bracket types), as indicated next to it
//The usage and color in the comment next to them are purely suggestions. Feel free to make them whatever you want.	
COLOR_TEXT_ALT_1 - //(()) //"Item" / Red
COLOR_TEXT_ALT_2 - //[[]] //"Objective" / Light Blue
COLOR_TEXT_ALT_3 - //{{}} //"Name" / Green
COLOR_TEXT_ALT_4 - //<<>> //"Menu Choice" / Gray

TSTYLE_MAJORAS - The default style. Yes this is named as it was for my quest. This should always be 0, unless you are combining this with
	- an existing tango setup.
A_COMBO_X / A_COMBO_Y - the coordinates for the placement of COMBO_PRESSA
MAIN_X / MAIN_Y - the coordinates for the message box
MENU_CURSOR_WIDTH - the visible width of COMBO_MENUCURSOR, measured from the far-left, in pixels.
TEXT_SPEED - Lower number = faster; this represents the number of frames between each letter appearing.

//USAGE
ShowMessageAndWait(STRING_TABLE_ID) //displays the message from the string table at the given ID, and handles the message slot. Do not use from global script.
ShowStringAndWait(ZSCRIPT_STRING) //displays text from a ZScript string, and handles the message slot. Do not use from global script.
setupStyles() //Sets up the tango styles. If you feel like getting fancy, you can change stuff here; most of the constants affect this already, though.
TangoInit() //Custom init function. This calls setupStyles() for you, as well as Tango_Start(). Call this before while(true) in your global active.

//GLOBAL SCRIPT MERGE:
global script ExampleTango
{
	void run()
	{
		TangoInit();
		
		while(true)
		{
			Tango_Update1();
			Waitdraw();
			Tango_Update2();
			Waitframe();
		}
	}
}

//Included resources:
TangoTiles.png - 8-bit tiles for all the constants above (you will need to combo the ones which require combos).
	-Grab these to page 251, and it will align with the default constant values.
	-Mass-combo-create the 5 in the upper-left corner to combo page 254, and it will align with the default constant values.
	-These tiles designed for DoR Hybrid.
