///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~The Terror of Necromancy Global Active Scripts~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Global ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

//~~~~~Constants/globals~~~~~//
//start

CONFIGB DEBUG = true;

int deathCount = 0;

CONFIG SUB_B_X = 94;
CONFIG SUB_B_Y = -10;
CONFIG SUB_A_X = 118;
CONFIG SUB_A_Y = -10;
COLOR SUB_TEXT_COLOR = C_BLACK;
CONFIG SUB_TEXT_FONT = FONT_LA;
CONFIG SUB_COOLDOWN_TILE = 29281;
CONFIG SUB_COOLDOWN_TILE_WIDTH = 9;

CONFIG TILE_LEGIONNAIRE_RING = 42700;
CONFIG CSET_LEGIONNAIRE_RING = 5;

CONFIG SPR_EZB_DEATHEXPLOSION = 0; //Sprite to use for death explosions (0 for ZC default)
CONFIG WIDTH_EZB_DEATHEXPLOSION = 2; //Tile width for death explosions
CONFIG HEIGHT_EZB_DEATHEXPLOSION = 2; //Tile height for death explosions
CONFIG EZB_DEATH_FLASH = 1; //Set to 1 to make the enemy flash during death animations
CONFIG LW_EZB_DEATHEXPLOSION = 40; //LWeapon type used for death explosions. Script 10 by default


//start Counter constants
CONFIG CR_LEGIONNAIRE_RING = CR_SCRIPT1;
CONFIG CR_HEARTPIECES = CR_SCRIPT2;
//end Counter constants

int onContHP = 0;
int onContMP = 0;
int gameframe = 0;
int lastPal = -1;

//end
//~~~~~~~~~~~~~~~~~~~~~~~~~~~//

//~~~~~Init~~~~~//
//start
global script Init
{
	void run()
	{
		Hero->ItemA = checkID(IC_SWORD);
		Hero->ItemB = checkID(IC_BRANG);
	}
}
//end

//~~~~~Active~~~~~//
//start
global script GlobalScripts
{
	void run()
	{		
		if (DEBUG)									//turn off debug when releasing
			debug();
		
		int map = -1, dmap = -1, scr = -1;
		
		LinkMovement_Init();
		StartGhostZH();
		DifficultyGlobal_Init();

		
		while(true)
		{
			gameframe = (gameframe + 1) % 3600;	//global timer
				
			checkDungeon();
						
			LinkMovement_Update1();
			UpdateGhostZH1();
			
			DifficultyGlobal_Update();
			DifficultyGlobal_EnemyUpdate();
			
			Waitdraw();
			
			if (map != Game->GetCurMap() || scr != Game->GetCurScreen())
			{
				map = Game->GetCurMap();
				scr = Game->GetCurScreen();
				
				onScreenChange();
			}
			if (dmap != Game->GetCurDMap())
			{
				dmap = Game->GetCurDMap();
				onDMapChange();
			}
			
			
			LinkMovement_Update2();
			UpdateGhostZH2();
			
			shutterControl();
			updatePrev();
			
			amountOfCourageTriforceShards = getAmountOfShards(0);
			amountOfPowerTriforceShards = getAmountOfShards(1);
			amountOfWisdomTriforceShards = getAmountOfShards(2);
			amountOfDeathTriforceShards = getAmountOfShards(3);		
			
			Waitframe();
		}
	}
	
	void onScreenChange()
	{
		disableTrans = false;
		//
		if (Screen->Palette != lastPal)
		{
			lastPal = Screen->Palette;
			
			for (int i = 0; i <= MAX_USED_DMAP; ++i)
				Game->DMapPalette[i] = Screen->Palette;
		}
	}
	
	void onDMapChange()
	{
	
	}
	
	//~~~~~ItemCycling~~~~~//		Passive subscreen script handles this
	void checkItemCycle() //start
	{
		if (Link->PressL) 
			Link->SelectBWeapon(DIR_LEFT);
		if (Link->PressR) 
			Link->SelectBWeapon(DIR_RIGHT);
	} //end
	
	//~~~~~checkDungeon~~~~~//
	void checkDungeon() //start
	{
		int level = Game->GetCurLevel();
		unless (Game->LItems[level] & LI_MAP)
		{
			Link->InputMap = false;
			Link->PressMap = false;
		}
	} //end
	
	//~~~~~Debug~~~~~//
	void debug() //start
	{
		Game->Cheat = 4;
	} //end
	
	//~~~~~Directional Bomb Damage Removed~~~~~//
	// Causes an attack to be unblockable by enemies that block based on direction
	// void BombDarknut()
	// {
		// for (int i = Screen->NumLWeapons(); i > 0; --i)
		// {
			// lweapon bomb = Screen->LoadLWeapon(i);
			// if (bomb->ID == LW_BOMB || bomb->ID == LW_BOMBBLAST || bomb->ID == LW_SBOMB || bomb->ID == LW_SBOMBBLAST)
			// {
				// if (bomb->Dir < 8) bomb->Dir += 8;
			// }
		// }
	// }
}
//end

//~~~~~OnLaunch~~~~~//
//start
global script OnLaunch
{
	void run()
	{
		lastPal = -1;
		subscr_y_offset = -224;
		subscr_open = false;

		SetGameOverMenu(C_TAN, C_BLACK, C_RED, MIDI_GAMEOVER);

		if(onContHP != 0)
		{
			Hero->HP = onContHP;
			Hero->MP = onContMP;	
		}
		else
		{
			Hero->HP = Hero->MaxHP;
			Hero->MP = Hero->MaxMP;		
		}		
	}
}
//end

//~~~~~OnF6Menu~~~~~//
//start
global script onF6Menu
{
	void run()
	{
		onContHP = Hero->HP;
		onContMP = Hero->MP;
	}
}
//end

//~~~~~OnContGame~~~~~//
//start
global script onContGame
{
	void run()
	{
		subscr_y_offset = -224;
		
		if(onContHP != 0)
		{
			Hero->HP = onContHP;
			Hero->MP = onContMP;	
		}
		else
		{
			Hero->HP = Hero->MaxHP;
			Hero->MP = Hero->MaxMP;		
		}
	}
}
//end

