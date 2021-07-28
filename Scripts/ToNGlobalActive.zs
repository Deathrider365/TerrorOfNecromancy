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
		
		mapdata m[6];
		
		while(true)
		{
			gameframe = (gameframe + 1) % 3600;	//global timer
		
			doRadialTransparency();
			
			checkDungeon();
			
			LinkMovement_Update1();
			UpdateGhostZH1();
			
			DifficultyGlobal_Update();
			DifficultyGlobal_EnemyUpdate();
			
			doRadialTransparency2(m);
			
			Waitdraw();
			
			if (map != Game->GetCurMap() || scr != Game->GetCurScreen())
			{
				map = Game->GetCurMap();
				scr = Game->GetCurScreen();
				
				onScreenChange(m);
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
			
			takeMapScreenshot();
			
			Waitframe();
		}
	}
	
	void doRadialTransparency2(mapdata m) //start
	{
		CONFIG TRANS_RADIUS = 36;
		
		if (HeroIsScrollingOrWarping())
			return;

		unless(IsValidArray(m))
		{
			Trace(0);
			return;
		}
		
		int layers = getTransLayers(Game->GetCurDMap(), Game->GetCurScreen());
		
		for (int l = 1; l < 6; ++l)
		{
			unless(layers & (1b << (l - 1)))
				continue;
			unless (m[l])
				continue;
			
			ohead_bmps[l]->Clear(0);
			
			for (int q = 0; q < 176; ++q)
				ohead_bmps[l]->FastCombo(l, ComboX(q), ComboY(q), m[l]->ComboD[q], m[l]->ComboC[q], OP_OPAQUE);
			
			ohead_bmps[l]->Circle(l, Hero->X + 8, Hero->Y + 8, TRANS_RADIUS, 0, 1, 0, 0, 0, true, OP_OPAQUE);
			
			for (int q = 0; q < 176; ++q)
				Screen->FastCombo(l, ComboX(q), ComboY(q), m[l]->ComboD[q], m[l]->ComboC[q], OP_TRANS);
				
			ohead_bmps[l]->Blit(l, -1, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
		}
	} //end
	
	void doRadialTransparency() //start
	{
		int layers = getTransLayers(Game->GetCurDMap(), Game->GetCurScreen());
		
		if (disableTrans)
		{
			for (int l = 1; l < 6; ++l)
			{
				unless(layers & (1b << (l - 1)))
					continue;
				
				Screen->LayerInvisible[l] = false;
			}
			
			return;
		}
		
		if (HeroIsScrolling())
			for (int l = 1; l < 6; ++l)
			{
				unless(layers & (1b << (l - 1)))
					continue;
				
				Screen->LayerInvisible[l] = false;
			}
		else
			for (int l = 1; l < 6; ++l)
			{
				unless(layers & (1b << (l - 1)))
					continue;
				
				Screen->LayerInvisible[l] = true;
			}
	} //end
	
	void checkTriforceShards() //start
	{
		amountOfCourageTriforceShards = getAmountOfShards(0);
		amountOfPowerTriforceShards = getAmountOfShards(1);
		amountOfWisdomTriforceShards = getAmountOfShards(2);
		amountOfDeathTriforceShards = getAmountOfShards(3);		
	} //end
	
	void onScreenChange(mapdata m) //start
	{
		disableTrans = false;
		
		int layers = getTransLayers(Game->GetCurDMap(), Game->GetCurScreen());
		
		for (int l = 1; l < 6; ++l)
		{
			unless(ohead_bmps[l]->isValid())
				ohead_bmps[l] = create(256, 176);
			ohead_bmps[l]->Clear(0);
				
			unless(layers & (1b << (l - 1)))
				continue;
			
			Screen->LayerInvisible[l] = true;
			
			m[l] = Game->LoadTempScreen(l);
		}
		
		//
		
		if (Screen->Palette != lastPal)
		{
			lastPal = Screen->Palette;
			
			for (int i = 0; i <= MAX_USED_DMAP; ++i)
				Game->DMapPalette[i] = Screen->Palette;
		}
	} //end
	
	int getTransLayers(int dmap, int scr) //start
	{
		switch(dmap)
		{
			case 4:
				switch(scr)
				{
					case 0x26:
						return 011000b;
					case 0x16:
						return 001100b;
					
				}
				break;
		}
		return 0;
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
		Hero->Warp(18, 0x71);
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

