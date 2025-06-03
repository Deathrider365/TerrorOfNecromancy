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
		while(1)
		{
			//TraceS("Link Active Script Running"); TraceNL();
			if ( Input->ReadKey[KEY_T] ) { ++Link->X; }
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

///////////////////////////////////////
/// Custom Game Over and F6 Screens ///
/// v1.4 for ZC 2.55                ///
/// 24th October, 2018              ///
/// By: ZoriaRPG                    ///
///////////////////////////////////////

//v1.4 : Added CONTINUE option to both screens. The user can enable or disable this. 

typedef const int define;
typedef const int config;

define ON = 1;
define OFF = 0;
define YES = 1;
define NO = 0;

script typedef ffc namespace;

namespace script F6
{
define SELECTION_SAVE = 1;
define SELECTION_RETRY = 2;
define SELECTION_CANCEL = 3;
define SELECTION_CONTINUE = 4;
define CONTINUE_HP = 16*3;
define CONTINUE_MP = 32*3;

config ALLOW_F6_CONTINUE = YES;
	
config F6MIDI = -3;
	
	void run(){}
	const int FREEZE = 504; //Freeze Combo
	void freeze(int state)
	{
		ffc f = Screen->LoadFFC(32);
		if ( state ) f->Data = FREEZE;
		else f->Data = 0;
	}
		
	//if ( F6.press() ) { F6.optiona(); }
	bool press()
	{
		TraceS("User pressed F6"); TraceNL();
		if ( Input->ReadKey[46+6] ) return true;
		return false;
	}
	void draw(bool ALLOW_F6_CONTINUE) 
	{ 
		gameover.draw(true, ALLOW_F6_CONTINUE); 
	}
	int choice(bool ALLOW_F6_CONTINUE) 
	{ 
		return gameover.get_choice(ALLOW_F6_CONTINUE); 
	}
	
	void options()
	{
		Game->DisableActiveSubscreen = true;
		freeze(ON);
		int oldmidi = Game->GetMIDI();
		Game->PlayMIDI(F6MIDI);
		while(menu(CONTINUE_HP, YES, CONTINUE_MP, YES)) 
		{
			draw(true);
			Waitdraw();
			Waitframe();
		}
		Game->PlayMIDI(oldmidi);
		freeze(OFF);
		
		Link->PressStart = false; Link->InputStart = false;
		
	}
	//for HP, 0 will preserve Link's HP before continuing. For MAGIC, use -1 to do this. 
	bool menu(int cont_hp, bool hp_is_percent, int cont_mp, bool mp_is_percent)
	{
		int sel = choice(true);
		switch(sel)
		{
			case SELECTION_SAVE:
			{
				Game->Save(); return false;
			}
			case SELECTION_RETRY: 
			{
				freeze(OFF);
				Game->End(); return false;
			}
			case SELECTION_CONTINUE: 
			{
				freeze(OFF);
				return do_continue(cont_hp, hp_is_percent, cont_mp, mp_is_percent);
			}
			case SELECTION_CANCEL: 
			{
				return false;
			}
		}
		return true;
	}
	bool do_continue(int hp, bool hp_percent, int mp, bool mp_percent)
	{
		//int entrancedmap = Game->LastEntranceDMap;
		//Replace with WarpEx()
		//Link->Warp(Game->GetCurDMap(), Game->DMapContinue[Game->GetCurDMap()]); 
		Link->Warp(Game->LastEntranceDMap, Game->LastEntranceScreen); 
		if ( hp > 0 ) Link->HP = ( Cond(hp_percent, Link->MaxHP*(hp/100), hp) );
		if ( mp > -1 ) Link->MP = ( Cond(mp_percent, Link->MaxMP*(mp/100), hp) );
		Link->Dir = DIR_DOWN;
		Link->Action = LA_NONE;
		return false;
	}
	
}

namespace script gameover
{

config ALLOW_DEATH_CONTINUE = YES; 

	// Sounds and MIDIs
config SFX_WINKOUT 			= 38; //Sound to play during wink-out animation.
config SFX_LINKDEATH 			= 28; //Sound to play when Link dies.
config SFX_GAMEOVERSCREEN_CURSOR 	= 6;  //Sound to play when the player moves the game over cursor.
config SFX_GAMEOVERSCREEN_SELECTION 	= 44; //Sound to play when the user selects a game over menu option.
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
config CANCEL_Y 		= 68+14;  //Y position of the CANCEL string.
config CONTINUE_Y 		= 68+28;  //Y position of the CONTINUE string.
config SAVE_Y 			= 54;  //X position of the SAVE string.
config CURSOR_OFFSET 		= 26;  //X offset of the cursor from the text. 

//Global Variables and Arrays

//Indices for values[]
define MENU_SEL_STATE 		= 0; //The current selected menu option. 
define MENU_SEL_POS_X 		= 1; //Stores where to draw menu selector.
define MENU_SEL_POS_Y 		= 2; //Stores where to draw menu selector.
define DEATH_LX 		= 3; //Cache of Link's last X position before death.
define DEATH_LY 		= 4; //Cache of Link's last Y position before death.
define DEATHFRAME 		= 5; //Timer for death animations. 
define QUIT 			= 6; //The game 'QUIT' type, SAVE or RETRY

//gameover.QUIT Types
define quitSAVE 		= 1;
define quitRETRY 		= 2;
define quitCONTINUE 		= 4;

//Menu Selection types
define SELECTION_SAVE 		= 1;
define SELECTION_RETRY 		= 2;
define SELECTION_CANCEL 	= 3;
define SELECTION_CONTINUE 	= 4;

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
	void draw(bool cancel, bool can_continue)
	{
		//Draw black background with Rectangle()
		Screen->Rectangle(5,0,0,256,256,BLACK,100, 0,0,0,true,128);
		if ( !cancel )
		{
			if ( !can_continue ) 
			{
				switch ( values[MENU_SEL_STATE] )
				{
					case SELECTION_SAVE:
					{
						//int ss1[]="Drawing cursor and text.";
						//TraceS(ss1);
						Screen->FastTile(6,SAVE_X-CURSOR_OFFSET, SAVE_Y, TILE_SAVECURSOR, TILE_SAVECURSOR_CSET,128); 
						//draw strings, red for selected
						Screen->DrawString(6,SAVE_X,SAVE_Y,0,RED, -1,0,"SAVE",128);
						Screen->DrawString(6,DONT_SAVE_X,DONT_SAVE_Y,0,WHITE, -1,0,"RETRY",128);
						break;
					}
					case SELECTION_RETRY:
					{
						//Draw cursor
						Screen->FastTile(6,DONT_SAVE_X-CURSOR_OFFSET, DONT_SAVE_Y, TILE_SAVECURSOR, TILE_SAVECURSOR_CSET,128); 
						//draw strings, red for selected
						Screen->DrawString(6,SAVE_X,SAVE_Y,0,WHITE, -1,0,"SAVE",128);
						Screen->DrawString(6,DONT_SAVE_X,DONT_SAVE_Y,0,RED, -1,0,"RETRY",128);
						break;
					}
					default: break;
				}
			}
			else
			{
				switch ( values[MENU_SEL_STATE] )
				{
					case SELECTION_SAVE:
					{
						//int ss1[]="Drawing cursor and text.";
						//TraceS(ss1);
						Screen->FastTile(6,SAVE_X-CURSOR_OFFSET, SAVE_Y, TILE_SAVECURSOR, TILE_SAVECURSOR_CSET,128); 
						//draw strings, red for selected
						Screen->DrawString(6,SAVE_X,SAVE_Y,0,RED, -1,0,"SAVE",128);
						Screen->DrawString(6,DONT_SAVE_X,DONT_SAVE_Y,0,WHITE, -1,0,"CONTINUE",128);
						Screen->DrawString(6,DONT_SAVE_X,CANCEL_Y,0,WHITE, -1,0,"RETRY",128);
						break;
					}
					case SELECTION_CONTINUE:
					{
						//int ss1[]="Drawing cursor and text.";
						//TraceS(ss1);
						Screen->FastTile(6,SAVE_X-CURSOR_OFFSET, DONT_SAVE_Y, TILE_SAVECURSOR, TILE_SAVECURSOR_CSET,128); 
						//draw strings, red for selected
						Screen->DrawString(6,SAVE_X,SAVE_Y,0,RED, -1,0,"SAVE",128);
						Screen->DrawString(6,DONT_SAVE_X,DONT_SAVE_Y,0,WHITE, -1,0,"CONTINUE",128);
						Screen->DrawString(6,DONT_SAVE_X,CANCEL_Y,0,WHITE, -1,0,"RETRY",128);
						break;
					}
					case SELECTION_RETRY:
					{
						//Draw cursor
						Screen->FastTile(6,DONT_SAVE_X-CURSOR_OFFSET, CANCEL_Y, TILE_SAVECURSOR, TILE_SAVECURSOR_CSET,128); 
						//draw strings, red for selected
						Screen->DrawString(6,SAVE_X,SAVE_Y,0,WHITE, -1,0,"SAVE",128);
						Screen->DrawString(6,DONT_SAVE_X,DONT_SAVE_Y,0,WHITE, -1,0,"CONTINUE",128);
						Screen->DrawString(6,DONT_SAVE_X,CANCEL_Y,0,RED, -1,0,"RETRY",128);
						break;
					}
					default: break;
				}
			
			
			
			}
		}
		else
		{
			if ( !can_continue )
			{
				switch(values[MENU_SEL_STATE])
				{
					
					
					case SELECTION_SAVE:
					{
						//int ss1[]="Drawing cursor and text.";
						//TraceS(ss1);
						Screen->FastTile(6,SAVE_X-CURSOR_OFFSET, SAVE_Y, TILE_SAVECURSOR, TILE_SAVECURSOR_CSET,128); 
						//draw strings, red for selected
						Screen->DrawString(6,SAVE_X,SAVE_Y,0,RED, -1,0,"SAVE",128);
						Screen->DrawString(6,DONT_SAVE_X,DONT_SAVE_Y,0,WHITE, -1,0,"RETRY",128);
						Screen->DrawString(6,DONT_SAVE_X,CANCEL_Y,0,WHITE, -1,0,"CANCEL",128);
						break;
					}
					case SELECTION_RETRY:
					{
						//Draw cursor
						Screen->FastTile(6,DONT_SAVE_X-CURSOR_OFFSET, DONT_SAVE_Y, TILE_SAVECURSOR, TILE_SAVECURSOR_CSET,128); 
						//draw strings, red for selected
						Screen->DrawString(6,SAVE_X,SAVE_Y,0,WHITE, -1,0,"SAVE",128);
						Screen->DrawString(6,DONT_SAVE_X,DONT_SAVE_Y,0,RED, -1,0,"RETRY",128);
						Screen->DrawString(6,DONT_SAVE_X,CANCEL_Y,0,WHITE, -1,0,"CANCEL",128);
						break;
					}
					case SELECTION_CANCEL:
					{
						//Draw cursor
						Screen->FastTile(6,DONT_SAVE_X-CURSOR_OFFSET, CANCEL_Y, TILE_SAVECURSOR, TILE_SAVECURSOR_CSET,128); 
						//draw strings, red for selected
						Screen->DrawString(6,SAVE_X,SAVE_Y,0,WHITE, -1,0,"SAVE",128);
						Screen->DrawString(6,DONT_SAVE_X,DONT_SAVE_Y,0,WHITE, -1,0,"RETRY",128);
						Screen->DrawString(6,DONT_SAVE_X,CANCEL_Y,0,RED, -1,0,"CANCEL",128);
						break;
					}
					default: break;
					
				}
			}
			else //allow F6 continue
			{
				switch(values[MENU_SEL_STATE])
				{
					
					//I'm reusing the positional defines for cancel and continue, and transposing them
					//to reorder the list. -Z
					
					//I should rename these to LIST_1_Y, LIST_2_Y, and so forth. 
					case SELECTION_SAVE:
					{
						//int ss1[]="Drawing cursor and text.";
						//TraceS(ss1);
						Screen->FastTile(6,SAVE_X-CURSOR_OFFSET, SAVE_Y, TILE_SAVECURSOR, TILE_SAVECURSOR_CSET,128); 
						//draw strings, red for selected
						Screen->DrawString(6,SAVE_X,SAVE_Y,0,RED, -1,0,"SAVE",128);
						Screen->DrawString(6,DONT_SAVE_X,DONT_SAVE_Y,0,WHITE, -1,0,"RETRY",128);
						Screen->DrawString(6,DONT_SAVE_X,CONTINUE_Y,0,WHITE, -1,0,"CANCEL",128);
						Screen->DrawString(6,DONT_SAVE_X,CANCEL_Y,0,WHITE, -1,0,"CONTINUE",128);
						break;
					}
					case SELECTION_RETRY:
					{
						//Draw cursor
						Screen->FastTile(6,DONT_SAVE_X-CURSOR_OFFSET, DONT_SAVE_Y, TILE_SAVECURSOR, TILE_SAVECURSOR_CSET,128); 
						//draw strings, red for selected
						Screen->DrawString(6,SAVE_X,SAVE_Y,0,WHITE, -1,0,"SAVE",128);
						Screen->DrawString(6,DONT_SAVE_X,DONT_SAVE_Y,0,RED, -1,0,"RETRY",128);
						Screen->DrawString(6,DONT_SAVE_X,CONTINUE_Y,0,WHITE, -1,0,"CANCEL",128);
						Screen->DrawString(6,DONT_SAVE_X,CANCEL_Y,0,WHITE, -1,0,"CONTINUE",128);
						break;
					}
					case SELECTION_CANCEL:
					{
						//Draw cursor
						Screen->FastTile(6,DONT_SAVE_X-CURSOR_OFFSET, CANCEL_Y, TILE_SAVECURSOR, TILE_SAVECURSOR_CSET,128); 
						//draw strings, red for selected
						Screen->DrawString(6,SAVE_X,SAVE_Y,0,WHITE, -1,0,"SAVE",128);
						Screen->DrawString(6,DONT_SAVE_X,DONT_SAVE_Y,0,WHITE, -1,0,"RETRY",128);
						Screen->DrawString(6,DONT_SAVE_X,CONTINUE_Y,0,RED, -1,0,"CANCEL",128);
						Screen->DrawString(6,DONT_SAVE_X,CANCEL_Y,0,WHITE, -1,0,"CONTINUE",128);
						break;
					}
					case SELECTION_CONTINUE:
					{
						//Draw cursor
						Screen->FastTile(6,DONT_SAVE_X-CURSOR_OFFSET, CONTINUE_Y, TILE_SAVECURSOR, TILE_SAVECURSOR_CSET,128); 
						//draw strings, red for selected
						Screen->DrawString(6,SAVE_X,SAVE_Y,0,WHITE, -1,0,"SAVE",128);
						Screen->DrawString(6,DONT_SAVE_X,DONT_SAVE_Y,0,WHITE, -1,0,"RETRY",128);
						Screen->DrawString(6,DONT_SAVE_X,CONTINUE_Y,0,WHITE, -1,0,"CANCEL",128);
						Screen->DrawString(6,DONT_SAVE_X,CANCEL_Y,0,RED, -1,0,"CONTINUE",128);
						break;
					}
					default: break;
					
				}
			}
			
		}
	}
	bool choice(bool can_continue)
	{
		if ( !can_continue )
		{
			if ( Link->PressDown ) // || Link->PressUp )
			{
				switch(values[MENU_SEL_STATE])
				{
					case SELECTION_SAVE: //save
						++values[MENU_SEL_STATE]; break;
					case SELECTION_RETRY: //retry
						--values[MENU_SEL_STATE]; break;
				}
				Game->PlaySound(SFX_GAMEOVERSCREEN_CURSOR);
				return true;
			}
			if ( Link->PressUp ) 
			{
				switch(values[MENU_SEL_STATE])
				{
					case SELECTION_SAVE: //save
						--values[MENU_SEL_STATE]; return true;;
					case SELECTION_RETRY: //retry
						++values[MENU_SEL_STATE]; return true;;
				}
				Game->PlaySound(SFX_GAMEOVERSCREEN_CURSOR);
				return true;
			}
		}
		else //save, continue, retry
		{
			if ( Link->PressDown ) // || Link->PressUp )
			{
				switch(values[MENU_SEL_STATE])
				{
					case SELECTION_SAVE: //save
						values[MENU_SEL_STATE] = SELECTION_CONTINUE; break;
					case SELECTION_CONTINUE: //save
						values[MENU_SEL_STATE] = SELECTION_RETRY; break;
					case SELECTION_RETRY: //retry
						values[MENU_SEL_STATE] = SELECTION_SAVE; break;
				}
				Game->PlaySound(SFX_GAMEOVERSCREEN_CURSOR);
				return true;
			}
			if ( Link->PressUp ) 
			{
				switch(values[MENU_SEL_STATE])
				{
					case SELECTION_SAVE: //save
						values[MENU_SEL_STATE] = SELECTION_RETRY; break;
					case SELECTION_CONTINUE: //save
						values[MENU_SEL_STATE] = SELECTION_SAVE; break;
					case SELECTION_RETRY: //retry
						values[MENU_SEL_STATE] = SELECTION_CONTINUE; break;
				}
				Game->PlaySound(SFX_GAMEOVERSCREEN_CURSOR);
				return true;
			}
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
	
	
	int get_choice(bool can_continue)
	{
		if ( !can_continue )
		{
			if ( Link->PressDown )
			{
				Game->PlaySound(SFX_GAMEOVERSCREEN_CURSOR);
				switch(values[MENU_SEL_STATE])
				{
					case SELECTION_SAVE: //save
						++values[MENU_SEL_STATE]; break;
					case SELECTION_RETRY: //retry
						++values[MENU_SEL_STATE]; break;
					case SELECTION_CANCEL: //3
						values[MENU_SEL_STATE] = 1; break;
					default: //cance;
						values[MENU_SEL_STATE] = 0; break;
				}
			}
			if ( Link->PressUp )
			{
				Game->PlaySound(SFX_GAMEOVERSCREEN_CURSOR);
				switch(values[MENU_SEL_STATE])
				{
					case 1: //save
						values[MENU_SEL_STATE] = 3; break;
					case 2: //retry
						--values[MENU_SEL_STATE] ; break;
					case SELECTION_CANCEL: //3
						--values[MENU_SEL_STATE] ; break;
					default: //cance;
						values[MENU_SEL_STATE] = 0; break;
				}
			}		
		}
		else //allow continue
		{
			if ( Link->PressDown )
			{
				Game->PlaySound(SFX_GAMEOVERSCREEN_CURSOR);
				switch(values[MENU_SEL_STATE])
				{
					case SELECTION_SAVE: //save
						++values[MENU_SEL_STATE]; break;
					case SELECTION_RETRY: //retry
						++values[MENU_SEL_STATE]; break;
					case SELECTION_CANCEL: //3
						++values[MENU_SEL_STATE] = 1; break;
					case SELECTION_CONTINUE: //3
						values[MENU_SEL_STATE] = 1; break;
					default: //cance;
						values[MENU_SEL_STATE] = 0; break;
				}
			}
			if ( Link->PressUp )
			{
				Game->PlaySound(SFX_GAMEOVERSCREEN_CURSOR);
				switch(values[MENU_SEL_STATE])
				{
					case 1: //save
						values[MENU_SEL_STATE] = 4; break;
					case 2: //retry
						--values[MENU_SEL_STATE]; break;
					case SELECTION_CANCEL: //3
						--values[MENU_SEL_STATE]; break;
					case SELECTION_CONTINUE: //3
						--values[MENU_SEL_STATE]; break;
					default: //cance;
						values[MENU_SEL_STATE] = 0; break;
				}
			}	
		}
		if ( Link->PressStart )
		{
			Game->PlaySound(SFX_GAMEOVERSCREEN_SELECTION);
			int ret = values[MENU_SEL_STATE];
			values[MENU_SEL_STATE] = 1;
			return ret;
		}
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


//Global Active Script
link script noF6
{
	void run()
	{
		while(true)
		{
			//Normal pre-waitdraw functions go here.
		
			//UpdateGhostZH1();
			
			//Put any health refull code above this!
			//Run the check to see if Link is dying...
			if ( F6.press() ) { Game->DisableActiveSubscreen = false; F6.options(); }
			if ( gameover.check() ) break; //LAST before Waitdraw()
			Waitdraw(); 
			
			//Normal post-waitdraw functions go here. 
	       
			//UpdateGhostZH2();
			
			Waitframe();
		}
		while(!gameover.values[gameover.QUIT])
		{
			//gameover.values[gameover.DEATH_LX] = Link->X;
			//gameover.values[gameover.DEATH_LY] = Link->Y;
			//Set game music to a silent MIDI.

			Link->HP = Link->MaxHP;
			Link->Invisible = true;
			Link->CollDetection = false;
			//Clean up screen objects
			gameover.clean_up();
			//Do Link Death animation
			gameover.animation();
			
			bool menu = true;
			Game->PlayMIDI(gameover.MIDI_GAMEOVER);//Play game over midi.
			Game->DisableActiveSubscreen = true;	
			
			while(menu) //menu loop
			{
				//    GAME OVER SCREEN
				gameover.draw(false,false); //gameover.draw(true, ALLOW_F6_CONTINUE); 
				menu = gameover.choice(gameover.ALLOW_DEATH_CONTINUE);
				Waitdraw();
				Waitframe();
			}
			Waitdraw(); Waitframe();
		}
		switch(gameover.values[gameover.QUIT])
		{
			case gameover.quitSAVE:
			{
				++Game->NumDeaths;
				Game->Save();
				Game->End();
				break;
			}
			case gameover.quitRETRY:
			{
				Game->End(); //Retry
				break;
			}
			case gameover.quitCONTINUE:
			{
				F6.do_continue(F6.CONTINUE_HP, YES, F6.CONTINUE_MP, YES);
				break;
			}
			default: break;
		}
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


