///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~~~~The Terror of Necromancy FFC Scripts~~~~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

//~~~~~VoiceOverText~~~~~//
//D0: Starting message
//D1: Number of strings in sequence
@Author("Deathrider365")
ffc script VoiceOverText //start
{	
	void run(int msg, int numStrings)
	{
		for (int i = 0; i < numStrings; ++i)
		{
			Audio->PlaySound(" ");
			Screen->Message(msg + i);
		}

	}
} //end

//~~~~~BossNameString~~~~~//
//D0: String number
@Author("Deathrider365")
ffc script BossNameString //start
{
	void run(int string)
	{
		Waitframes(4);
		if (EnemiesAlive())
			Screen->Message(string);
	}
}

//end

//~~~~~CompassBeep~~~~~//
@Author("Demonlink")
ffc script CompassBeep //start
{	
	void run()
	{
		if(!Screen->State[ST_ITEM] && !Screen->State[ST_CHEST] && !Screen->State[ST_LOCKEDCHEST] && !Screen->State[ST_BOSSCHEST] && 
			!Screen->State[ST_SPECIALITEM] && (Game->LItems[Game->GetCurLevel()] & LI_COMPASS))
			Audio->PlaySound(COMPASS_BEEP);
	}
}
//end

//~~~~~BossMusic~~~~~//
//D0: Index value 
//D1: 0 for no 1 for yes to fanfare music
@Author("Deathrider365")
ffc script BossMusic //start
{	
	void run(int musicChoice, int isFanfare)
	{
		char32 areaMusic[256];

		if (Screen->State[ST_SECRET])
			Quit();
		
		Waitframes(4);
		
		unless (EnemiesAlive())
			return;
		
		switch(musicChoice)
		{		
			case 1:
				Audio->PlayEnhancedMusic("Middle Boss - OoT.ogg", 0);
				break;
				
			case 2:
				Audio->PlayEnhancedMusic("Metroid Prime - Parasite Queen.ogg", 0);
				break;
				
			case 2:
				Audio->PlayEnhancedMusic("", 0);
				break;
		}
		
		while(EnemiesAlive())
			Waitframe();
			
		if (isFanfare == 1)
		{
			Audio->PlayEnhancedMusic("Boss Fanfare - Wind Waker.ogg", 0);
			Waitframes(1465);
		}

		Game->GetDMapMusicFilename(Game->GetCurDMap(), areaMusic);
		Audio->PlayEnhancedMusic(areaMusic, 0);

	}
}

//end

//~~~~~MessageThenWarp~~~~~//
//D0: Message number to show
//D1: Dmap to warp Link to
//D2: Screen on the specified dmap to warp Link to
@Author("Deathrider365")
ffc script MessageThenWarp //start
{	
	void run(int msg, int dmap, int scr)
	{
		NoAction();
		Link->PressStart = false;
		Link->InputStart = false;
		Link->PressMap = false;
		Link->InputMap = false;
		Screen->Message(msg);
		Waitframe();
		Hero->WarpEx({WT_IWARPBLACKOUT, dmap, scr, -1, WARP_A, WARPFX_NONE, 0, 0, DIR_DOWN});
	}
}
//end

//~~~~~NormalString~~~~~//
//D0: Number of string to show
@Author("Deathrider365")
ffc script NormalString //start
{
	void run(int m, int triggerOnSecret)
	{
		if (triggerOnSecret)
		{
			if (Screen->State[ST_SECRET])
			{
				Waitframes(2);
				Screen->Message(m);
			}
			else
				Waitframe();
		}
		else
		{
			Waitframes(2);
			Screen->Message(m);
		}
	}
}

//end

//~~~~~ItemGuy~~~~~//
//D0: Number of string to show
//D1: Item to be given
//D2: X position of where the item will appear
//D3: Y position of where the item will appear
@Author("Deathrider365")
ffc script ItemGuy //start
{
	void run(int message, int itemID, int x, int y)
	{
		if (Screen->State[ST_SPECIALITEM])
			return;
		
		Waitframes(2);
		itemsprite it = CreateItemAt(itemID, x, y);
		it->Pickup = IP_HOLDUP | IP_ST_SPECIALITEM;
		
		unless(getScreenD(255))
			Screen->Message(message);
		
		setScreenD(255, true);
	}
}

//end

//~~~~~DungeonString~~~~~//
//D0: Number of string to show
@Author("Deathrider365")
ffc script DungeonString //start
{
	void run(int m)
	{		
		unless (levelEntries[Game->GetCurLevel()])
		{
			levelEntries[Game->GetCurLevel()] = true;
			Waitframes(2);
			Screen->Message(m);		
		}
	}
}

//end

//~~~~~TradeGuy~~~~~//
@Author("Deathrider365")
ffc script TradeGuy //start
{
	void run(int hasItemString, int noItemString, int requiredItem, int obtainedItem)
	{
		if (Hero->Item[requiredItem])
		{
			Screen->Message(hasItemString);	
			Hero->Item[obtainedItem] = true;
			Hero->Item[requiredItem] = false;
		}
		else
			Screen->Message(noItemString);
	}
}

//end

//~~~~~FFCLocks~~~~~//
@Author("Deathrider365")
ffc script Locks //start
{
	void run(int keyId, int noItemString, int sfx)
	{
		if (Hero->Item[keyId])
		{
			//change ComboAt[] to no lock
			Audio->PlaySound(sfx);
		}
	}
}

//end

//~~~~~SignPost~~~~~//
//D0: Number of string to show
//D1: 0 for not anyside 1 for anyside
@Author("Joe123")
ffc script Signpost //start
{
	void run(int msg, bool anySide)
	{
		int loc = ComboAt(this->X, this->Y);
		
		while(true)
		{
			until(AgainstComboBase(loc, anySide) && Input->Press[CB_SIGNPOST]) 
			{
				if (AgainstComboBase(loc, anySide))
					Screen->FastCombo(7, Link->X - 10, Link->Y - 15, 48, 0, OP_OPAQUE);
					
				Waitframe();
			}			
			
			Input->Button[CB_SIGNPOST] = false;
			Screen->Message(msg);
			Waitframe();
		}
	}
}

//end

//~~~~~Message~~~~~//
//D0: Number of string to show
@Author("Deathrider365")
ffc script Message //start
{
	void run(int msg)
	{
		unless(getScreenD(255))
			Screen->Message(msg);
		
		setScreenD(255, true);
	}
}

//end

//~~~~~sfxPlay~~~~~//
//D0: The sound effect to play.
//D1: How many frames to wait until the sound effect plays.
//D2: Set this to anything other than 0 to have the sound effect loop.
@Author ("Tabletpillow")
ffc script sfxplay //start
{
	void run(int sound, int wait, int rep)
	{
		if (rep == 0)
		{
			Waitframes(wait);
			Audio->PlaySound(sound);
		}
		else
		{
			while(true)
			{
				Waitframes(wait);
				Audio->PlaySound(sound);
			}
		}
	}
}

//end

//~~~~~BattleArena~~~~~//
//D0: Num of attempts until failure is determined
//D1: Dmap to warp to
//D2: screen to warp to
@Author ("Deathrider365")
ffc script BattleArena //start
{
	void run(int enemyListNum, int roundListNum, int rounds, int message, int prize)
	{	
	/*
		Audio->PlayEnhancedMusic("ToT Miniboss theme.ogg", 0)
		
		int currentEnemyList[10]; 
		getEnemiesList(currentEnemyList, enemyListNum);
		int currentRoundList[10] = getRoundList(roundListNum);
		
		for (int i = 0; i < currentRoundList[rounds]; ++i)
		{
			// npc n1 = Screen->CreateNPC(37);
			// n1->X = 64;
			// n1->Y = 80;		
			
			// npc n2 = Screen->CreateNPC(179);
			// n2->X = 80;
			// n2->Y = 80;
			
			// npc n3 = Screen->CreateNPC(184);		
			// n3->X = 96;
			// n3->Y = 80;
			
			npc i = Screen->CreateNPC(currentEnemyList[i]);
			
			round();
			++round;
		}
		
		Screen->Message(m);
		Hero->Item[prize] = true;
		*/
	}
	/*
	
	void getEnemiesList(int buf, int enemyListNum) //start
	{
		switch(enemyListNum)
		{
			case 1: 
				buf[0] = 12;
				return;
				
			case 1: 
			
			case 1: 
			
			case 1: 
		}

	} //end
	
	int getEnemyList1() //start
	{
		int enemyList1[10];
		enemyList1[0] = 12;
		
		return enemyList1[];
	} //end

	void round() //start
	{
		while(EnemiesAlive())
			Waitframe();
	} //end
	*/
}

//end

//~~~~~DifficultyChoice~~~~~//
@Author ("Moosh")
ffc script DifficultyChoice //start
{
    void run()
	{
		Waitframes(60);
		
		while(true)
		{
			if (Input->Press[CB_A])
			{
				Hero->Item[I_DIFF_NORMAL] = true;
				break;
			}
			else if (Input->Press[CB_B])
			{
				Hero->Item[I_DIFF_VERYHARD] = true;
				break;
			}
			
			Waitframe();
		}
		
		Audio->PlaySound(32);
		
		Waitframes(120);
		
		Hero->WarpEx({WT_IWARPOPENWIPE, 5, 0x3E, -1, WARP_B, WARPEFFECT_OPENWIPE, 0, 0, DIR_RIGHT});	
    }
} //end

//~~~~~GiveItem~~~~~//
@Author ("Moosh")
ffc script GiveItem //start
{
	void run()
	{
		Hero->Item[I_DIFF_NORMAL] = true;
	}
}//end

//~~~~~ContinuePoint~~~~~//
@Author ("Emily")
ffc script ContinuePoint //start
{
	void run(int dmap, int scrn)
	{
		unless (dmap || scrn)
		{
			dmap = Game->GetCurDMap();
			scrn = Game->GetCurScreen();
		}
		
		Game->LastEntranceDMap = dmap;
		Game->LastEntranceScreen = scrn;
		Game->ContinueDMap = dmap;
		Game->ContinueScreen = scrn;
	}
}
//end

ffc script CircMove //start
{
	void run(int a, int v, int theta)
	{
		int x = this->X;
		int y = this->Y;
		if(theta < 0) theta = Rand(180);
		while(true)
		{
			theta += v;
			WrapDegrees(theta);
			this->X = x + a * Cos(theta);
			this->Y = y + a * Sin(theta);
			Waitframe();
		}
	}
} //end

ffc script OvMove //start
{
	void run(int a, int b, int v, int theta, int phi)
	{
		int x = this->X;
		int y = this->Y;
		if(theta < 0) theta = Rand(180);
		while(true)
		{
			theta += v;
			WrapDegrees(theta);
			this->X = x + a * Cos(theta) * Cos(phi) - b * Sin(theta) * Sin(phi);
			this->Y = y + b * Sin(theta) * Cos(phi) + a * Cos(theta) * Sin(phi);
			Waitframe();
		}
	}
} //end

//~~~~~DisableRadialTransparency~~~~~//
ffc script DisableRadialTransparency //start
{
	void run(int pos)
	{
		while(true)
		{
			disableTrans = Screen->ComboD[pos] ? true : false;
			Waitframe();
		}
	}
} //end

ffc script WarpCustomReturn //start
{
	//Dirs: -1 = Tile, 0 = Up, 1 = Down, 2 = Left, 3 = Right
	//If d2 is set, and the warp is a sidewarp, it will use the FFC's x/y to split into 2 sidewarps
	//d1 / d2 = 'dmap.screen', i.e. dm1scr1 = 1.0001
	void run(int d1, int x, int y, int sideFacing, int warp, int d2, int x2, int y2)
	{
		int dm = Floor(d1), scr = (d1 % 1) / 1L;
		int dm2 = Floor(d2), scr2 = (d2 % 1) / 1L;
		int wtype = Floor(warp), warpEffect = (warp % 1) / 1L;
		int side = Floor(sideFacing), dir = (sideFacing % 1) / 1L;
		
		switch(side)
		{
			case DIR_UP:
			{
				while(true)
				{
					if(Hero->Y <= 1.5 && Hero->InputUp)
					{
						if(d2 && Hero->X >= this->X)
							Hero->WarpEx({wtype, dm2, scr2, x2, y2, warpEffect, 0, 0, dir});
						else Hero->WarpEx({wtype, dm, scr, x, y, warpEffect, 0, 0, dir});
					}
					Waitframe();
				}
			}
			case DIR_DOWN:
			{
				while(true)
				{
					if(Hero->Y >= 158.5 && Hero->InputDown)
					{
						if(d2 && Hero->X >= this->X)
							Hero->WarpEx({wtype, dm2, scr2, x2, y2, warpEffect, 0, 0, dir});
						else Hero->WarpEx({wtype, dm, scr, x, y, warpEffect, 0, 0, dir});
					}
					Waitframe();
				}
			}
			case DIR_LEFT:
			{
				while(true)
				{
					if(Hero->X <= 1.5 && Hero->InputLeft)
					{
						if(d2 && Hero->Y >= this->Y)
							Hero->WarpEx({wtype, dm2, scr2, x2, y2, warpEffect, 0, 0, dir});
						else Hero->WarpEx({wtype, dm, scr, x, y, warpEffect, 0, 0, dir});
					}
					Waitframe();
				}
			}
			case DIR_RIGHT:
			{
				while(true)
				{
					if(Hero->X >= 238.5 && Hero->InputRight)
					{
						if(d2 && Hero->Y >= this->Y)
							Hero->WarpEx({wtype, dm2, scr2, x2, y2, warpEffect, 0, 0, dir});
						else Hero->WarpEx({wtype, dm, scr, x, y, warpEffect, 0, 0, dir});
					}
					Waitframe();
				}
			}
			default: //Tile warp, at the FFC's location.
			{
				while(true)
				{
					if(Abs(Hero->X-this->X) <= 14 && Abs(Hero->Y-this->Y) <= 14)
						Hero->WarpEx({wtype, dm, scr, x, y, warpEffect, 0, 0, dir});
					Waitframe();
				}
			}
		}
	}
}
//end

ffc script DisableLink //start
{
	void run()
	{
		while(true)
		{
			NoAction();
			Link->PressStart = false;
			Link->InputStart = false;
			Link->PressMap = false;
			Link->InputMap = false;
			Waitframe();
		}
	}
} //end

//D0: ID of the item
//D1: Price of the item
//D2: Message that plays when the item is bought
//D3: Message that plays when you don't have enough rupees
//D4: Input type 0=A 1=B 2=L 3=R
@Author("Tabletpillow, Emily")
ffc script SimpleShop //start
{
    void run(int itemID, int price, int boughtMessage, int notBoughtMessage, int input, int introMessage)
	{
		int noStockCombo = this->Data;
		this->Data = COMBO_INVIS;
		itemsprite dummy = CreateItemAt(itemID, this->X, this->Y);
		dummy->Pickup = IP_DUMMY;
		
        int loc = ComboAt(this->X + 8, this->Y + 8);		
		Screen->Message(introMessage);
		char32 priceBuf[6];
		sprintf(priceBuf, "%d", price);
		
		itemdata id = Game->LoadItemData(itemID);
		bool checkStock = !id->Combine && id->Keep;
		
        while(true)
		{
			if(checkStock && Hero->Item[itemID])
			{
				dummy->ScriptTile = TILE_INVIS;
				this->Data = noStockCombo;
				
				do Waitframe(); while (Hero->Item[itemID]);
				
				dummy->ScriptTile = -1;
				this->Data = COMBO_INVIS;
			}
			
			Screen->DrawString(2, this->X + 8, this->Y - Text->FontHeight(FONT_LA) - 2, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, priceBuf, OP_OPAQUE, SHD_SHADOWED, C_BLACK);
			
			if (AgainstComboBase(loc, 1))
			{
				Screen->FastCombo(7, Link->X - 10, Link->Y - 15, 48, 0, OP_OPAQUE);
            	
				if(Input->Press[CB_SIGNPOST])
				{
					if (Game->Counter[CR_RUPEES] >= price)
					{
						Game->DCounter[CR_RUPEES] -= price;
						item shpitm = CreateItemAt(itemID, Link->X, Link->Y);
						
						shpitm->Pickup = IP_HOLDUP;
						Screen->Message(boughtMessage);
					}
					else
						Screen->Message(notBoughtMessage);
				}		
			}		
			Waitframe();
        }
    }
	
    bool AgainstComboBase(int loc)
	{
        return Link->Z == 0 && (Link->Dir == DIR_UP && Link->Y == ComboY(loc) + 8 && Abs(Link->X - ComboX(loc)) < 8);
    }
} //end














