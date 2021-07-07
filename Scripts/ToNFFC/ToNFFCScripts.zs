///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~~~~The Terror of Necromancy FFC Scripts~~~~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

//~~~~~CompassBeep~~~~~//
@Author("Demonlink")
ffc script CompassBeep //start
{	
	void run()
	{
		if(!Screen->State[ST_ITEM] && 
			!Screen->State[ST_CHEST] && 
			!Screen->State[ST_LOCKEDCHEST] && 
			!Screen->State[ST_BOSSCHEST] && 
			!Screen->State[ST_SPECIALITEM] && 
			(Game->LItems[Game->GetCurLevel()] & LI_COMPASS))
			Audio->PlaySound(COMPASS_BEEP);
	}
}
//end

//~~~~~BossMusic~~~~~//
//D0: Number that correlates with the song desired
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
				Audio->PlayEnhancedMusic("OoT - Middle Boss.ogg", 0);
				break;
				
			case 2:
				Audio->PlayEnhancedMusic("Metroid Prime - Parasite Queen.ogg", 0);
				break;
				
			default:
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

//~~~~~ConditionalItem~~~~~//
//D0: String id when you first enter the room and you have the required item
//D1: Same as D0 but you don't have the required item
//D2: Item id you get
//D3: Item id that is required
//D4: String id for when you talk to the NPC if you don't have the required item
//D5: Same as D4 but you have the required item
//D6: X Coordinate where the item spawns
//D7: Y Coordinate where the item spawns
ffc script ConditionalItem //start
{
	void run(int hasRequiredItemStrings, int noHasRequiredItemInitialString, int itemIdToNeed, int itemIdToGet, int guyStringNoHasRequiredItem, int guyStringHasRequiredItem, int itemLocX, int itemLocY)
	{
		int loc = ComboAt(this->X, this->Y);
		
		int hasRequiredItemInitialString = Floor(hasRequiredItemStrings);
		int hasRequiredItemButAlreadyEnteredString = (hasRequiredItemStrings % 1) / 1L;
		
		while (true)
		{
			// If you have the item he gives, do nothing but have him talk when against saying "use dat item well andcall that" (this is essentially the "done" state)
			if (Hero->Item[itemIdToGet])
			{
				while (true)
				{
					until(AgainstComboBase(loc, 1) && Input->Press[CB_SIGNPOST]) 
					{
						if (AgainstComboBase(loc, 1))
							Screen->FastCombo(7, Link->X - 10, Link->Y - 15, 48, 0, OP_OPAQUE);
							
						Waitframe();
					}	
					
					Input->Button[CB_SIGNPOST] = false;
					Screen->Message(guyStringHasRequiredItem);
					
					Waitframe();
				}
			}
			// If you haven't gotten the item he gives, actually do things
			else
			{
				// If you have the required item but have not yet picked it up
				if (Hero->Item[itemIdToNeed] && !getScreenD(255))
				{
					// If first entry, give initial has needed item string
					unless (getScreenD(254))
					{
						Screen->Message(hasRequiredItemInitialString);
						setScreenD(254, true);
					}
					else unless (getScreenD(253))
					{
						Screen->Message(hasRequiredItemButAlreadyEnteredString);
						setScreenD(253, true);
					}
					
					Audio->PlaySound(SFX_CLEARED);
					
					int itemXLoc = itemLocX;
					int itemYLoc = itemLocY;
					item givenItem = CreateItemAt(itemIdToGet, itemXLoc, itemYLoc);
					givenItem->Pickup = IP_HOLDUP;
					
					// Waiting to pick up the item
					while (true && !getScreenD(255))
					{
						until(AgainstComboBase(loc, 1) && Input->Press[CB_SIGNPOST]) 
						{
							if (AgainstComboBase(loc, 1))
								Screen->FastCombo(7, Link->X - 10, Link->Y - 15, 48, 0, OP_OPAQUE);
								
							Waitframe();
						}
						
						Input->Button[CB_SIGNPOST] = false;
						Screen->Message(guyStringHasRequiredItem);
						
						if (Hero->Item[itemIdToGet])
						{
							setScreenD(255, true);
							break;
						}
						
						Waitframe();
					}
				}
				// If you do not have the required item
				else
				{
					// If first entry, give initial has needed item string
					unless (getScreenD(254))
					{
						Screen->Message(noHasRequiredItemInitialString);
						setScreenD(254, true);
					}
					
					while (true)
					{
						until(AgainstComboBase(loc, 1) && Input->Press[CB_SIGNPOST]) 
						{
							if (AgainstComboBase(loc, 1))
								Screen->FastCombo(7, Link->X - 10, Link->Y - 15, 48, 0, OP_OPAQUE);
								
							Waitframe();
						}	
						
						Input->Button[CB_SIGNPOST] = false;
						Screen->Message(guyStringNoHasRequiredItem);
						
						Waitframe();
					}
				}
			}
		}
	}
} //end

//~~~~~ItemGuy~~~~~//
// Sets screenD(255) upon receiving
//D0: Item ID to give
//D1: String for getting the item
//D2: String for if you already got the item
//D3: 1 for all dirs, 0 for only front (up)
@Author("Deathrider365")
ffc script ItemGuy //start
{
	void run(int itemID, int gettingItemString, int alreadyGotItemString, int anySide)
	{
		Waitframes(2);
		
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
			
			unless (getScreenD(255))
			{
				Screen->Message(gettingItemString);
				
				Waitframes(2);
				
				itemsprite it = CreateItemAt(itemID, Hero->X, Hero->Y);
				it->Pickup = IP_HOLDUP;
				Input->Button[CB_SIGNPOST] = false;
				setScreenD(255, true);
			}
			else
				Screen->Message(alreadyGotItemString);
			
			Waitframe();
		}
	}
}

//end

//~~~~~SFXPlay~~~~~//
//D0: The sound effect to play.
//D1: How many frames to wait until the sound effect plays.
//D2: Set this to anything other than 0 to have the sound effect loop.
@Author ("Tabletpillow")
ffc script SFXPlay //start
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
		for (int i = 0; i < 20; ++i)
		{
			Screen->Rectangle(7, 0, 0, 256, 176, C_BLACK, 1, 0, 0, 0, true, OP_OPAQUE);
			Waitframe();
		}
		
		enteringTransition();
		
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

//~~~~~DisableLink~~~~~//
@Author("Deathrider365")
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
@Author("Tabletpillow, Emily")
ffc script SimpleShop //start
{
    void run(int itemID, int price, int boughtMessage, int notBoughtMessage)
	{
		int noStockCombo = this->Data;
		this->Data = COMBO_INVIS;
		itemsprite dummy = CreateItemAt(itemID, this->X, this->Y);
		dummy->Pickup = IP_DUMMY;
		
        int loc = ComboAt(this->X + 8, this->Y + 8);
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
						item shpitm = CreateItemAt(itemID, Hero->X, Hero->Y);
						
						shpitm->Pickup = IP_HOLDUP;
						Screen->Message(boughtMessage);
					}
					else
					{
						Input->Button[CB_SIGNPOST] = false;
						Screen->Message(notBoughtMessage);
					}
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

//D0: Info string #
//D1: Price of the info
//D2: Message that plays when you don't have enough rupees
//D5: Intro string
@Author("Deathrider365")
ffc script InfoShop //start
{
	void run(int introMessage, int price, int toPoor, int intro)
	{
        int loc = ComboAt(this->X + 8, this->Y + 8);		
		Screen->Message(introMessage);
		char32 priceBuf[6];
		sprintf(priceBuf, "%d", price);
	
	}

} //end

//~~~~~SpawnItem~~~~~//
//D0: Item ID
@Author("Emily")
ffc script SpawnItem //start
{
    void run(int itemId)
    {	
        if(Screen->State[ST_ITEM]) 
			return;
			
		item spawnedItem = CreateItemAt(itemId, this->X, this->Y);
		Screen->State[IP_ST_ITEM] = true;
    
	}
} //end

//~~~~~CapacityIncreasor~~~~~//
//D0: Message to play on entry
//D1: Price of increasor
//D2: Amount to increase
//D3: Counter ID to increase (currently just bombs and arrows)
@Author("Deathrider365")
ffc script CapacityIncreasor //start
{
	void run(int message, int price, int increaseAmount, int itemToIncrease, int sfxOnBuy)
	{
		bool alreadyBought = false;
		
		if (getScreenD(255))
		{
			this->Data = COMBO_INVIS;
			Quit();
		}
		char32 priceBuf[6];
		sprintf(priceBuf, "%d", price);
		
		Screen->DrawString(2, this->X + 8, this->Y - Text->FontHeight(FONT_LA) - 2, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, priceBuf, OP_OPAQUE, SHD_SHADOWED, C_BLACK);
			
		Screen->Message(message);
		
		Waitframe();
		
        while(true && !alreadyBought)
		{
			Screen->DrawString(2, this->X + 8, this->Y - Text->FontHeight(FONT_LA) - 2, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, priceBuf, OP_OPAQUE, SHD_SHADOWED, C_BLACK);
			
			if (onTop(this->X, this->Y))
				if (Game->Counter[CR_RUPEES] >= price)
				{
					Game->DCounter[CR_RUPEES] -= price;
					
					itemToIncrease == 1 ? (Game->MCounter[CR_BOMBS] += increaseAmount) : (Game->MCounter[CR_ARROWS] += increaseAmount);
					itemToIncrease == 1 ? (Game->Counter[CR_BOMBS] += increaseAmount) : (Game->Counter[CR_ARROWS] += increaseAmount);
					Audio->PlaySound(sfxOnBuy);
					
					setScreenD(255, true);
					alreadyBought = true;
					this->Data = COMBO_INVIS;
				}
				
			Waitframe();
        }
	}
} //end

//~~~~~PoisonWater~~~~~//
// Just place on screen with shallow water
@Author("Moosh")
ffc script PoisonWater //start
{
	void run()
	{
		while(true)
		{
			while(Link->Action != LA_SWIMMING && Link->Action != LA_DIVING && Screen->ComboT[ComboAt(Link->X + 8, Link->Y + 12)] != CT_SHALLOWWATER)
				Waitframe();
			
			int maxDamageTimer = 120;
			int damageTimer = maxDamageTimer;
			
			while(Link->Action == LA_SWIMMING || Link->Action == LA_DIVING || (Screen->ComboT[ComboAt(Link->X + 8, Link->Y + 12)] == CT_SHALLOWWATER))
			{
				damageTimer--;
				
				if(damageTimer <= 0)
					if(Screen->ComboT[ComboAt(Link->X + 8, Link->Y + 12)] == CT_SHALLOWWATER || Link->Action == LA_SWIMMING)
					{
						Link->HP -= 8;
						Game->PlaySound(SFX_OUCH);
						damageTimer = maxDamageTimer;
					}
					
				Waitframe();
			}
		}
	}
} //end

//~~~~~ScreenQuakeOnSecret~~~~~//
//D0: Power of the quake
@Author("Deathrider365")
ffc script ScreenQuakeOnSecret //start
{
	void run(int quakePower)
	{
		if (Screen->State[ST_SECRET])
			Quit();
			
		until (Screen->State[ST_SECRET])
			Waitframe();
			
		Screen->Quake = quakePower;
	}
} //end

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














































