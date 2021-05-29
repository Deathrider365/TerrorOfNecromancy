///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~The Terror of Necromancy Global Active Scripts~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

//~~~~~Init~~~~~//
global script Init //start
{
	void run()
	{
		Hero->ItemA = checkID(IC_SWORD);
		Hero->ItemB = checkID(IC_BRANG);
	}
} //end

//~~~~~Active~~~~~//
global script GlobalScripts //start
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
			checkTriforceShards();
			
			Waitframe();
		}
	}
	
	void checkTriforceShards() //start
	{
		amountOfCourageTriforceShards = getAmountOfShards(0);
		amountOfPowerTriforceShards = getAmountOfShards(1);
		amountOfWisdomTriforceShards = getAmountOfShards(2);
		amountOfDeathTriforceShards = getAmountOfShards(3);		
	} //end
	
	void onScreenChange() //start
	{
		disableTrans = false;
		
		//
		
		if (Screen->Palette != lastPal)
		{
			lastPal = Screen->Palette;
			
			for (int i = 0; i <= MAX_USED_DMAP; ++i)
				Game->DMapPalette[i] = Screen->Palette;
		}
	} //end
	
	void onDMapChange() //start
	{
	
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
	
} //end

//~~~~~OnLaunch~~~~~//
global script OnLaunch //start
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
} //end

//~~~~~OnF6Menu~~~~~//
global script onF6Menu //start
{
	void run()
	{
		onContHP = Hero->HP;
		onContMP = Hero->MP;
	}
} //end

//~~~~~OnContGame~~~~~//
global script onContGame //start
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
} //end

