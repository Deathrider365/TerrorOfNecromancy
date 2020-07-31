///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~The Terror of Necromancy Global Active Scripts~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Global Active~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
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
CONFIG CR_LEGIONNAIRE_RING = CR_SCRIPT1;

CONFIG TILE_LEGIONNAIRE_RING = 42700;
CONFIG CSET_LEGIONNAIRE_RING = 4;
CONFIG TILE_INVIS = 196;
//CONFIG COMBO_INVIS = ;

int onContHP = 0;
int onContMP = 0;
int gameframe = 0;

//end
//~~~~~~~~~~~~~~~~~~~~~~~~~~~//

//~~~~~Active~~~~~//
//start
global script GlobalScripts
{
	void run()
	{	
		if (DEBUG)									//turn off debug when releasing
			debug();
		
		LinkMovement_Init();
		
		while(true)
		{
			gameframe = (gameframe+1)%3600;	//global timer
			checkDungeon();
			
			LinkMovement_Update1();
			Waitdraw();
			LinkMovement_Update2();
			
			Waitframe();
		}
	}
	
	//~~~~~ItemCycling~~~~~//
	void checkItemCycle() //start
	{
		if (Link->PressL) Link->SelectBWeapon(DIR_LEFT);
		if (Link->PressR) Link->SelectBWeapon(DIR_RIGHT);
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
}
//end

//~~~~~OnLaunch~~~~~//
//start
global script OnLaunch
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

//~~~~~OnF6Menu~~~~~//
//start
global script onF6Menu
{
	void run()
	{
		onContHP = Hero->HP;
		onContMP = Hero->MP;	
		printf("%d, %d\n", onContHP, onContMP);
	}
}
//end

//~~~~~OnContGame~~~~~//
//start
global script onContGame
{
	void run()
	{
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

