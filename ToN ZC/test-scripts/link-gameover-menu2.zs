import "std.zh"

dmapdata script dmapscript
{
	void run()
	{
		int f;
		while(1)
		{
			++f; 
			if (!(f%180)) 
			{ 
				TraceS("Dmap Script Before Waitdraw()"); TraceNL();
				
			}
			Waitdraw(); 
			if (!(f%180))
			{ 
				TraceS("Dmap Script After Waitdraw()"); TraceNL();
				
			}
			Waitframe();
		}

	}
}

screendata script sd1
{
void run(){}
}

link script link_init1
{
	void run()
	{
		TraceS("Running Link Init Script"); TraceNL();
		Link->X = 100;
		Link->Y = 60;
		
	}
}

link script link_active
{
	void run()
	{
		//lweapon l = Screen->CreateLWeapon(LW_SCRIPT1);
		while(1)
		{
			//TraceS("Link Active Script Running"); TraceNL();
			if ( Input->ReadKey[KEY_T] ) { Game->ShowContinueScreen(); }
			if ( Input->ReadKey[KEY_U] ) { Game->SkipF6 = (!Game->SkipF6); }
			Waitframe();
		}
	}
}

link script onWin
{
	void run()
	{
		int q;
		while(1)
		{
			++q;
			Trace(q);
			if ( q > 100 ) Quit();
			Waitframe();
		}
	}
}
///////////////////////////////
/// Custom Game Over Screen ///
/// v1.2 for ZC 2.55        ///
/// 24th October, 2018      ///
/// By: ZoriaRPG            ///
//////////////////////////////////////
/// Requested by: Korben on PureZC ///
//////////////////////////////////////

typedef const int DEFINE;
typedef const int config;

script typedef ffc namespace;

namespace script gameover
{
	// Sounds and MIDIs
config SFX_WINKOUT 			= 38; //Sound to play during wink-out animation.
config SFX_LINKDEATH 			= 28; //Sound to play when Link dies.
config SFX_GAMEOVERSCREEN_CURSOR 	= 6;  //Sound to play when the player moves the game over cursor.
config SFX_GAMEOVERSCREEN_SELECTION 	= 44; //Sound to play when the user selectsl a game over menu option.
config MIDI_GAMEOVER 			= -4; //MIDI to play on Game Over screen.
	//Defaults: -3 is the internal Game Over, -2 is Level 9, -1 is Overworld
 
// Sprites (Weapons/Misc)
config SPR_DEATH 		= 88; //Sprite of Link Spinning
config SPR_DEATH_WINKOUT 	= 89; //Sprite of wink-out
// Sprite Timing
config END_DEATH_SPIN 		= 40; //Frames to display death spin animation.
config END_WINKOUT 		= 10; //Frames to display wink-out animation.

// Other Graphics and Colours
config TILE_SAVECURSOR 		= 20;
config TILE_SAVECURSOR_CSET 	= 1;    //CSet for minitile cursor. 
config BLACK 			= 0x0F; //Black in the current palette
config RED	 		= 0x93; //Red in the current palette
config WHITE	 		= 0x01; //White in the current palette

// Menu Object Positions and Settings
config DONT_SAVE_X 		= 102; //X position of the RETRY string.
config SAVE_X 			= 102; //X position of the SAVE string.
config DONT_SAVE_Y 		= 68;  //Y position of the RETRY string.
config SAVE_Y 			= 54;  //X position of the SAVE string.
config CURSOR_OFFSET 		= 26;  //X offset of the cursor from the text. 

//Global Variables and Arrays

//Indices for values[]
DEFINE MENU_SEL_STATE 		= 0; //The current selected menu option. 
DEFINE MENU_SEL_POS_X 		= 1; //Stores where to draw menu selector.
DEFINE MENU_SEL_POS_Y 		= 2; //Stores where to draw menu selector.
DEFINE DEATH_LX 		= 3; //Cache of Link's last X position before death.
DEFINE DEATH_LY 		= 4; //Cache of Link's last Y position before death.
DEFINE DEATHFRAME 		= 5; //Timer for death animations. 
DEFINE QUIT 			= 6; //The game 'QUIT' type, SAVE or RETRY

//gameover.QUIT Types
DEFINE quitSAVE = 1;
DEFINE quitRETRY = 2;

	int values[8] = {1,SAVE_Y,DONT_SAVE_Y, 0,0};
	void run(){}
	bool check()
	{
		if ( Link->HP < 1 ) 
		{
			Link->HP = 1;
			Link->Invisible = true;
			Link->CollDetection = false;
			values[DEATH_LX] = Link->X;
			values[DEATH_LY] = Link->Y;
			return true;
		}
		return false;
	}
	void clean_up()
	{
		int q;
		if ( Screen->NumNPCs() )
		{
			for ( q = Screen->NumNPCs(); q > 0; --q ) 
			{ 
				npc n = Screen->LoadNPC(q); Remove(n); 
			}
		}
		if ( Screen->NumLWeapons() )
		{
			for ( q = Screen->NumLWeapons(); q > 0; --q ) 
			{ lweapon n = Screen->LoadLWeapon(q); Remove(n); }
		}
		if ( Screen->NumEWeapons() )
		{
			for ( q = Screen->NumEWeapons(); q > 0; --q ) 
			{ eweapon n = Screen->LoadEWeapon(q); Remove(n); }
		}
		if ( Screen->NumItems() )
		{
			for ( q = Screen->NumItems(); q > 0; --q ) 
			{ item n = Screen->LoadItem(q); Remove(n); }
		}
		//clear all ffcs
		for ( q = 1; q < 33; ++q )
		{
			ffc f = Screen->LoadFFC(q);
			f->Data = 0; f->Script = 0;
		}
	}
	void draw()
	{
		//Draw black background with Rectangle()
		

		if ( values[MENU_SEL_STATE] )
		{
			Screen->Rectangle(5,0,0,256,256,BLACK,100, 0,0,0,true,128);
			//int ss1[]="Drawing cursor and text.";
			//TraceS(ss1);
			Screen->FastTile(6,SAVE_X-CURSOR_OFFSET, SAVE_Y, TILE_SAVECURSOR, TILE_SAVECURSOR_CSET,128); 
			//draw strings, red for selected
			Screen->DrawString(6,SAVE_X,SAVE_Y,0,RED, -1,0,"SAVE",128);
			Screen->DrawString(6,DONT_SAVE_X,DONT_SAVE_Y,0,WHITE, -1,0,"RETRY",128);
		}
		else
		{
			Screen->Rectangle(5,0,0,256,256,BLACK,100, 0,0,0,true,128);
			//Draw cursor
			Screen->FastTile(6,DONT_SAVE_X-CURSOR_OFFSET, DONT_SAVE_Y, TILE_SAVECURSOR, TILE_SAVECURSOR_CSET,128); 
			//draw strings, red for selected
			Screen->DrawString(6,SAVE_X,SAVE_Y,0,WHITE, -1,0,"SAVE",128);
			Screen->DrawString(6,DONT_SAVE_X,DONT_SAVE_Y,0,RED, -1,0,"RETRY",128);
		}
	}
	bool choice()
	{
		if ( Link->PressDown || Link->PressUp )
		{
			values[MENU_SEL_STATE] = Cond(values[MENU_SEL_STATE],0,1);
			Game->PlaySound(SFX_GAMEOVERSCREEN_CURSOR);
			return true;
		}
		
		if ( Link->PressStart )
		{
			Game->PlaySound(SFX_GAMEOVERSCREEN_SELECTION);
			if ( values[MENU_SEL_STATE] ) values[QUIT] = quitSAVE;
			else values[QUIT] = quitRETRY; //no save
			return false;
		}
		return true;
	}
	void animation()
	{
	if ( values[DEATHFRAME] == 0 ) Game->PlaySound(SFX_LINKDEATH);
		lweapon death = Screen->CreateLWeapon(LW_SPARKLE);
		
		death->UseSprite(SPR_DEATH);
		death->X = values[DEATH_LX];
		death->Y = values[DEATH_LY];

		while ( values[DEATHFRAME] < END_DEATH_SPIN )
		{
			++values[DEATHFRAME];
			//spin Link around by drawing his tiles, then make the wink out.
			NoAction(); Waitdraw(); Waitframe();
		}
		Remove(death);
		Game->PlaySound(SFX_WINKOUT);
		lweapon death2 = Screen->CreateLWeapon(LW_SPARKLE);
		death2->UseSprite(SPR_DEATH_WINKOUT);
		death2->X = values[DEATH_LX];
		death2->Y = values[DEATH_LY];
		while ( values[DEATHFRAME] < END_DEATH_SPIN+END_WINKOUT )
		{
			++values[DEATHFRAME];
			//wink-out
			NoAction();  Waitdraw(); Waitframe();
		}
		Remove(death2);
	}
}

link script win
{
	
	void run()
	{
		while(1)
		{
		TraceS("Running onWin script.()");TraceNL();
		
			Screen->FastTile(6,60,60,11979,0,128);
			Waitframe();
		}
		Quit();
	}
}
//Global Active Script
link script noF6
{
	void run()
	{
		TraceS("Running onDeath script.()");TraceNL();
		//while(!gameover.values[gameover.QUIT])
		while(1)
		{
			//gameover.values[gameover.DEATH_LX] = Link->X;
			//gameover.values[gameover.DEATH_LY] = Link->Y;
			//Set game music to a silent MIDI.

			//Link->HP = Link->MaxHP;
			//Link->Invisible = true;
			//Link->CollDetection = false;
			//Clean up screen objects
			//gameover.clean_up();
			//Do Link Death animation
			//TraceS("Doing gameover.animation()");TraceNL();
			//gameover.animation();
			
			bool menu = true;
			Game->PlayMIDI(gameover.MIDI_GAMEOVER);//Play game over midi.
			Game->DisableActiveSubscreen = true;	
			TraceS("Loading gameover menu()");TraceNL();
			Screen->FastTile(6,60,60,11979,0,128);
			//while(menu) //menu loop
			//{
				//    GAME OVER SCREEN
			//	Screen->FastTile(6,60,60,11979,0,128);
				//gameover.draw();
				//menu = gameover.choice();
				//Waitdraw();
			//	Waitframe();
			//}
			//Waitdraw(); 
			Waitframe();
		}
		if ( gameover.values[gameover.QUIT] == gameover.quitSAVE )
		{
			++Game->NumDeaths;
			Game->Save();
			Game->End();
		}
		else Game->End(); //Retry
	}
}

global script OnExit
{
	void run()
	{
		Link->Invisible = false;
	}
}
eweapon script E2
{
	void run(){}
}

eweapon script E
{
	void run()
	{
		//TraceS("eweapon script E: this: "); Trace(this); TraceNL();
		int f;
		Trace(this->ID);
		while(this->isValid())
		{
TraceS("EWeapon Script Running"); TraceNL();
			++f;
			if ( !(f%10) ) 
			{
				this->Dir = Rand(0,3);
				TraceS("EWeapon Script Running"); TraceNL();
			}
			if ( !(this->isValid()) ) Quit();
			Waitframe();
		
		}
	}
}

lweapon script L
{
	void run() 
	{ 
		TraceS("Script L: this: "); Trace(this); TraceNL();
		int f = 0;
		while(this->isValid())
		{
			 
			++f;
			if ( !(f%10) ) 
			{
				this->Dir = Rand(0,3);
				TraceS("LWeapon Script Running"); TraceNL();
			}
			if ( !(this->isValid()) ) Quit();
			Waitframe();
		
		}
	}
}

lweapon script sword
{
	void run()
	{
		TraceS("Script sword: this: "); Trace(this); TraceNL();
		Trace(this->ID);
		while(this->isValid())
		{
			//this->X += 10;
			TraceS("LWeapon Script Running"); TraceNL();
			Waitframe();
		}
	}
}

lweapon script beam
{
	void run()
	{
		//TraceS("Script beam: this: "); Trace(this); TraceNL();
		int f;
		Trace(this->ID);
		while(this->isValid())
		{
			++f;
			if ( !(f%10) ) 
			{
				this->Dir = Rand(0,3);
				//TraceS("LWeapon Script Running"); TraceNL();
			}
			if ( !(this->isValid()) ) Quit();
			Waitframe();
		
		}
	}
}

lweapon script bait
{
	void run()
	{
		TraceS("Script bait: this: "); Trace(this); TraceNL();
		int f = 0; int dir = Rand(0,3); int step = 2;
		while(this->isValid())
		{
			++f; if (!(f%6)) { dir = Rand(0,3); step = Rand(2,6); }
			switch(dir)
			{
				case DIR_UP: this->Y -= step; break;
				case DIR_DOWN: this->Y += step; break;
				case DIR_LEFT: this->X -= step; break;
				case DIR_RIGHT: this->X += step; break;
				default: break;
			}
			if ( !(this->isValid()) ) Quit();
			Waitframe();
		}
	}
}		

global script a
{
	void run()
	{
		while(1)
		{
			for ( int q = Screen->NumLWeapons(); q > 0; --q )
			{
				lweapon l = Screen->LoadLWeapon(q);
				if ( l->ID == LW_SCRIPT1 ) 
				{
					//TraceS("Found LW_SCRIPT1"); TraceNL();
				}
			}
			Waitframe();
		}
	}
}





link script menu
{
	config SFX_WINKOUT 			= 38; //Sound to play during wink-out animation.
config SFX_LINKDEATH 			= 28; //Sound to play when Link dies.
config SFX_GAMEOVERSCREEN_CURSOR 	= 6;  //Sound to play when the player moves the game over cursor.
config SFX_GAMEOVERSCREEN_SELECTION 	= 44; //Sound to play when the user selectsl a game over menu option.
config MIDI_GAMEOVER 			= -4; //MIDI to play on Game Over screen.
	//Defaults: -3 is the internal Game Over, -2 is Level 9, -1 is Overworld
 
// Sprites (Weapons/Misc)
config SPR_DEATH 		= 88; //Sprite of Link Spinning
config SPR_DEATH_WINKOUT 	= 89; //Sprite of wink-out
// Sprite Timing
config END_DEATH_SPIN 		= 40; //Frames to display death spin animation.
config END_WINKOUT 		= 10; //Frames to display wink-out animation.

// Other Graphics and Colours
config TILE_SAVECURSOR 		= 20;
config TILE_SAVECURSOR_CSET 	= 1;    //CSet for minitile cursor. 
config BLACK 			= 0x0F; //Black in the current palette
config RED	 		= 0x93; //Red in the current palette
config WHITE	 		= 0x01; //White in the current palette

// Menu Object Positions and Settings
config DONT_SAVE_X 		= 102-12; //X position of the RETRY string.
config SAVE_X 			= 102-12; //X position of the SAVE string.
config DONT_CONTINUE_Y 		= 82;  //Y position of the RETRY string.
config DONT_SAVE_Y 		= 68;  //Y position of the RETRY string.
config SAVE_Y 			= 54;  //X position of the SAVE string.
config CURSOR_OFFSET 		= 12;  //X offset of the cursor from the text. 

//Global Variables and Arrays

//Indices for values[]
DEFINE MENU_SEL_STATE 		= 0; //The current selected menu option. 
DEFINE MENU_SEL_POS_X 		= 1; //Stores where to draw menu selector.
DEFINE MENU_SEL_POS_Y 		= 2; //Stores where to draw menu selector.
//DEFINE DEATH_LX 		= 3; //Cache of Link's last X position before death.
int DEATH_LX 		= 0; //Cache of Link's last X position before death.
//DEFINE DEATH_LY 		= 4; //Cache of Link's last Y position before death.
int DEATH_LY 		= 0; //Cache of Link's last Y position before death.
//DEFINE DEATHFRAME 		= 5; //Timer for death animations. 
int DEATHFRAME 		= 0; //Timer for death animations. 
//DEFINE QUIT 			= 6; //The game 'QUIT' type, SAVE or RETRY
int QUIT;

//gameover.QUIT Types
DEFINE quitSAVE = 1;
DEFINE quitRETRY = 2;
DEFINE quitCONTINUE = 3;
int MENU_STATE = quitCONTINUE;

	int values[8] = {1,SAVE_Y,DONT_SAVE_Y, 0,0};
	bool check()
	{
		if ( Link->HP < 1 ) 
		{
			Link->HP = 1;
			Link->Invisible = true;
			Link->CollDetection = false;
			values[DEATH_LX] = Link->X;
			values[DEATH_LY] = Link->Y;
			return true;
		}
		return false;
	}
	void clean_up()
	{
		int q;
		if ( Screen->NumNPCs() )
		{
			for ( q = Screen->NumNPCs(); q > 0; --q ) 
			{ 
				npc n = Screen->LoadNPC(q); Remove(n); 
			}
		}
		if ( Screen->NumLWeapons() )
		{
			for ( q = Screen->NumLWeapons(); q > 0; --q ) 
			{ lweapon n = Screen->LoadLWeapon(q); Remove(n); }
		}
		if ( Screen->NumEWeapons() )
		{
			for ( q = Screen->NumEWeapons(); q > 0; --q ) 
			{ eweapon n = Screen->LoadEWeapon(q); Remove(n); }
		}
		if ( Screen->NumItems() )
		{
			for ( q = Screen->NumItems(); q > 0; --q ) 
			{ item n = Screen->LoadItem(q); Remove(n); }
		}
		//clear all ffcs
		for ( q = 1; q < 33; ++q )
		{
			ffc f = Screen->LoadFFC(q);
			f->Data = 0; f->Script = 0;
		}
	}
	int getgood_x = Rand(-128,256);
	void draw()
	{
		--getgood_x;
		if ( getgood_x < -128) getgood_x = 256;
		//Draw black background with Rectangle()
		//Screen->Rectangle(5,0,0,256,256,BLACK,100, 0,0,0,true,128);
		
		if ( MENU_STATE == quitSAVE )
		{
			//int ss1[]="Drawing cursor and text.";
			//TraceS(ss1);
			Screen->Rectangle(7,0,-56,256,256,BLACK,100, 0,0,0,true,128);
			Screen->DrawString(7,getgood_x,0,FONT_SATURN,0x04, -1,0,"Git Gud!",128);
			Screen->FastTile(7,SAVE_X-CURSOR_OFFSET, SAVE_Y-4, TILE_SAVECURSOR, TILE_SAVECURSOR_CSET,128); 
			//draw strings, red for selected
			Screen->DrawString(7,SAVE_X,SAVE_Y,FONT_SATURN,RED, -1,0,"SAVE",128);
			Screen->DrawString(7,DONT_SAVE_X,DONT_SAVE_Y,FONT_SATURN,WHITE, -1,0,"RETRY",128);
			Screen->DrawString(7,DONT_SAVE_X,DONT_CONTINUE_Y,FONT_SATURN,WHITE, -1,0,"CONTINUE",128);
		}
		else if ( MENU_STATE == quitRETRY )//retry
		{
			//Draw cursor
			Screen->Rectangle(7,0,-56,256,256,BLACK,100, 0,0,0,true,128);
			Screen->DrawString(7,getgood_x,0,FONT_SATURN,0x04, -1,0,"Git Gud!",128);
			Screen->FastTile(7,DONT_SAVE_X-CURSOR_OFFSET, DONT_SAVE_Y-4, TILE_SAVECURSOR, TILE_SAVECURSOR_CSET,128); 
			//draw strings, red for selected
			Screen->DrawString(7,SAVE_X,SAVE_Y,FONT_SATURN,WHITE, -1,0,"SAVE",128);
			Screen->DrawString(7,DONT_SAVE_X,DONT_SAVE_Y,FONT_SATURN,RED, -1,0,"RETRY",128);
			Screen->DrawString(7,DONT_SAVE_X,DONT_CONTINUE_Y,FONT_SATURN,WHITE, -1,0,"CONTINUE",128);
		}
		else if ( MENU_STATE == quitCONTINUE )
		{
			//Draw cursor
			Screen->Rectangle(7,0,-56,256,256,BLACK,100, 0,0,0,true,128);
			Screen->DrawString(7,getgood_x,0,FONT_SATURN,0x04, -1,0,"Git Gud!",128);
			Screen->FastTile(7,DONT_SAVE_X-CURSOR_OFFSET, DONT_CONTINUE_Y-4, TILE_SAVECURSOR, TILE_SAVECURSOR_CSET,128); 
			//draw strings, red for selected
			Screen->DrawString(7,SAVE_X,SAVE_Y,FONT_SATURN,WHITE, -1,0,"SAVE",128);
			Screen->DrawString(7,DONT_SAVE_X,DONT_SAVE_Y,FONT_SATURN,WHITE, -1,0,"RETRY",128);
			Screen->DrawString(7,DONT_SAVE_X,DONT_CONTINUE_Y,FONT_SATURN,RED, -1,0,"CONTINUE",128);
		}
	}
	bool choice()
	{
		//if ( Input->ReadKey[KEY_P] )
		if ( Link->PressDown )
		{
			switch(MENU_STATE)
			{
				case quitSAVE: MENU_STATE = quitRETRY; LogPrint("Menu PressDOWN Selection is: %s \n", "quitRETRY"); break;
				case quitRETRY: MENU_STATE = quitCONTINUE; LogPrint("Menu PressDown Selection is: %s \n", "quitCONTINUE"); break;
				case quitCONTINUE: MENU_STATE = quitSAVE; LogPrint("Menu PressDown Selection is: %s \n", "quitSAVE");break;
				default: break;
			}
			//MENU_STATE = Cond(MENU_STATE,0,1);
			Game->PlaySound(SFX_GAMEOVERSCREEN_CURSOR);
			return true;
		}
		if ( Link->PressUp )
		{
			switch(MENU_STATE)
			{
				case quitSAVE: MENU_STATE = quitCONTINUE; LogPrint("Menu PressUp Selection is: %s \n", "quitCONTINUE"); break;
				case quitRETRY: MENU_STATE = quitSAVE; LogPrint("Menu PressUp Selection is: %s \n", "quitSAVE"); break;
				case quitCONTINUE: MENU_STATE = quitRETRY; LogPrint("Menu PressUp Selection is: %s \n", "quitRETRY"); break;
				default: break;
			}
			//MENU_STATE = Cond(MENU_STATE,0,1);
			Game->PlaySound(SFX_GAMEOVERSCREEN_CURSOR);
			return true;
		}
		
		if ( Link->PressStart )
		{
			Game->PlaySound(SFX_GAMEOVERSCREEN_SELECTION);
			QUIT = MENU_STATE;
			//switch(MENU_STATE)
			//{
			//	case 0:  QUIT = quitRETRY; //no save
			//	case 1:  QUIT = quitSAVE; //no save
			//	case 2:  QUIT = quitCONTINUE; //no save
			//	default: break;
			//}
			return false;
		}
		return true;
	}
	void animation()
	{
		Link->Invisible = true;
	int DEATHFRAME;
	if ( DEATHFRAME == 0 ) Game->PlaySound(SFX_LINKDEATH);
		lweapon death = Screen->CreateLWeapon(LW_SPARKLE);
		Graphics->Monochrome(TINT_GREY);
		death->UseSprite(SPR_DEATH);
		death->X = Link->X;//DEATH_LX;
		death->Y = Link->Y; //DEATH_LY;

		while ( DEATHFRAME < END_DEATH_SPIN )
		{
			++DEATHFRAME;
			//++Link->X;
			//spin Link around by drawing his tiles, then make the wink out.
			NoAction(); Waitframe();
		}
		Remove(death);
		Game->PlaySound(SFX_WINKOUT);
		lweapon death2 = Screen->CreateLWeapon(LW_SPARKLE);
		death2->UseSprite(SPR_DEATH_WINKOUT);
		death2->X = Link->X;//DEATH_LX;
		death2->Y = Link->Y; //DEATH_LY;
		while ( DEATHFRAME < END_DEATH_SPIN+END_WINKOUT )
		{
			++DEATHFRAME;
			//wink-out
			NoAction(); Waitframe();
		}
		Remove(death2);
	}
	void run()
	{
		Trace(12345);
TraceS("Running menu script");
		bool menu = true;
		//while(1)
		//{
			clean_up();
			animation();
			Graphics->ClearTint();
			while(menu) //menu loop
			{
				//    GAME OVER SCREEN
				draw();
				menu = choice();
				//itdraw();
				Waitframe();
			}
			//Waitdraw(); 
			Waitframe();
		//}
		switch(QUIT)
		{
			case quitSAVE:
			{
				if ( Link->HP < 1 ) ++Game->NumDeaths;
				LogPrint("Death Menu returned a QUIT state of: %s \n", "quitSAVE");
				Game->Save();
				Game->End();
				break;
			}
			case quitRETRY:
			{
				LogPrint("Death Menu returned a QUIT state of: %s", "quitRETRY");
				Game->End();
				break;
			}
			case quitCONTINUE:
			{
				if ( Link->HP < 1 ) ++Game->NumDeaths;
				LogPrint("Death Menu returned a QUIT state of: %s", "quitCONTINUE");
				Game->Continue();
				break;
			}
			default: break;
		}
		//if ( QUIT == quitSAVE )
		//{
		//	++Game->NumDeaths;
		//	Game->Save();
		//	Game->End();
		//}
		//else Game->End(); //Retry
	}
}
