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
		
		Trace(Hero->ItemA);
		Trace(Hero->ItemB);
		Trace(asubscr_pos);
		
		
		int map = -1, dmap = -1, scr = -1;
		
		LinkMovement_Init();
		StartGhostZH();
		DifficultyGlobal_Init();
				
		mapdata m[6];
		
		int footprintArray[3] = {1, 0, 0};
		
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
			
			checkFootprints(footprintArray);
			
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
					case 0x07:
						return 001100b;
					case 0x38:
					case 0x39:
						return 001000b;
					
				}
				break;
			case 5:
				switch(scr)
				{
					case 0x1c:
						return 000100;
					case 0x63:
						return 000100;
				}
			case 6:
				switch(scr)
				{
					case 0x08:
						return 000100;
					case 0x17:
						return 000100;
				}
			case 21:
				switch(scr)
				{
					case 0x77:
						return 000100;
				}
		}
		return 0;
	} //end
	
	void checkFootprints(int arr) //start
	{
		int fadeMult = getFadeMult();
		
		unless(fadeMult)
			fadeMult = 1;
		
		if (!HeroIsScrolling() && Hero->Action == LA_WALKING && ((arr[1] == Hero->X && arr[2] == Hero->Y) ? false : true))
		{
			arr[1] = Hero->X;
			arr[2] = Hero->Y;
			
			unless (--arr[0])
			{	
				int pos = ComboAt(Link->X + 4, Link->Y + 4);
				int comboT = Screen->ComboT[pos]; 
				
				for (int i = 1; i < 3; ++i)
					if (Screen->LayerMap[i])
					{
						mapdata m = Game->LoadTempScreen(i);
						
						if (m->ComboD[pos])
							comboT = m->ComboT[pos];
					}
				
				if (comboT == CT_FOOTPRINT)
					createFootprint(fadeMult);
					
				arr[0] = 12;
			}
		}
	} //end
	
	int getFadeMult() //start
	{
		switch(Game->GetCurDMap())
		{
			case 0...8:
				return 0.4;
			case 9:
				return 2;
			case 10:
				return 1;
			case 11:
				return 0.3333;
			case 18...23:
				return 1;
		}
		
		return 0;
	} //end
	
	void createFootprint(int fadeMult) //start
	{
		if (int scr = CheckLWeaponScript("CustomSparkle"))
		{
			lweapon footprint = RunLWeaponScriptAt(LW_SCRIPT1, scr, Hero->X, Hero->Y, {SPR_FOOTSTEP, fadeMult});
			footprint->Behind = true;
			footprint->Dir = Hero->Dir;
			footprint->ScriptTile = TILE_INVIS;
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
		// Hero->Item[191] = true;
		// Hero->Warp(21, 0x57);
		// Hero->Warp(20, 0x23);
		// Hero->Warp(18, 0x23);
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

