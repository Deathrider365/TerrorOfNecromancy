///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~The Terror of Necromancy FFC Scripts ~ Cutscenes~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

// When i give triuforce shards use this: Game->LItems[lvl] |= LI_TRIFORCE;/
/*
int countTriforce()
{
    int ret;
    for(int q = 0; q < 512; ++q)
        if(Game->LItems[q] & LI_TRIFORCE)
            ++ret;
    return ret;
}
*/

//~~~~~ORDERED SEQUENTIALLY~~~~~//

//~~~~~Leviathan1Cabin~~~~~//
@Author("Deathrider365")
ffc script Leviathan1Cabin //start
{
	void run()
	{
		Audio->PlayEnhancedMusic("WW - Ship Theme.ogg", 0);
	}
}
//end

//~~~~~ScreenBeforeLeviathan1~~~~~//
//D0: Message number to show
//D1: Dmap to warp Link to
//D2: Screen on the specified dmap to warp Link to
@Author("Deathrider365")
ffc script ScreenBeforeLeviathan1 //start
{	
	void run(int msg, int dmap, int scr, int timeUntilWarp)
	{
		Audio->PlayEnhancedMusic("WW - The Great Sea.ogg", 0);
		int timer = 0;
		while (true)
		{
			++timer;
			Waitframe();
			
			if (timer == timeUntilWarp)
			{
				NoAction();
				Link->PressStart = false;
				Link->InputStart = false;
				Link->PressMap = false;
				Link->InputMap = false;
				Screen->Message(msg);
				Waitframe();
				
				for (int i = 0; i < 240; ++i)
				{
					if (i % 60 == 0)
					{
						Screen->Quake = 20;
						Audio->PlaySound(SFX_ROCKINGSHIP);
					}
					
					Waitframe();
				}
				
				Screen->Message(msg + 1);
				Waitframe();
				
				Hero->WarpEx({WT_IWARPOPENWIPE, dmap, scr, -1, WARP_A, WARPEFFECT_OPENWIPE, 0, 0, DIR_UP});
				
			}
		}
	}
}
//end

//~~~~~LeviathanFailureP1~~~~~//
//D0: Num of attempts until failure is determined
//D1: Dmap to warp to
//D2: screen to warp to
@Author ("Deathrider365")
ffc script LeviathanFailureP1 //start
{
	void run(int numAttempts, int dmap, int scrn)
	{
		while (true)
		{
			if (Hero->HP <= 0)
			{
				Hero->HP = 4;
				Hero->Warp(dmap, scrn);
			}
			Waitframe();
		}
	}
}

//end

//~~~~~LeviathanFailureP2~~~~~//
//D0: Dmap to warp to
//D1: screen to warp to
@Author ("Deathrider365")
ffc script LeviathanFailureP2 //start
{
	void run(int dmap, int scrn)
	{
		Screen->Message(MSG_LINK_BEATEN);
		Audio->PlayEnhancedMusic(NULL, 0);

		for (int i = 0; i < 120; ++i)
		{					
			NoAction();
			Screen->DrawTile(0, 50, 32, 45760, 9, 6, 0, -1, -1, 0, 0, 0, 0, 1, 128);	
			Waitframe();
		}
		
		Hero->WarpEx({WT_IWARPOPENWIPE, dmap, scrn, -1, WARP_A, WARPEFFECT_OPENWIPE, 0, 0, DIR_UP});
	}
}

//end

//~~~~~Leviathan1Ending~~~~~//
//D0: Dmap to warp to
//D1: screen to warp to
@Author ("Deathrider365")
ffc script Leviathan1Ending //start
{
	using namespace Leviathan1Namespace;
	
	void run(int dmap, int scrn)
	{
		Audio->PlayEnhancedMusic("Bomb Ring - Final Fantasy IV.ogg", 0);
	
		if (waterfall_bmp && waterfall_bmp->isAllocated())
			waterfall_bmp->Free();
			
		waterfall_bmp = Game->CreateBitmap(32, 176);
		
		Leviathan1.UpdateWaterfallBitmap();
		
		Hero->Dir = DIR_UP;
		NoAction();
		
		Screen->Message(MSG_LINK_BEATEN + 1);
		
		// Buffer
		for (int i = 0; i < 60; ++i)
		{
			NoAction();
			Screen->DrawTile(0, 16, 4, 45760, 9, 6, 0, -1, -1, 0, 0, 0, 0, 1, 128);
			Waitframe();			
		}
		
		// Rising
		for (int i = 0; i < 32; ++i)
		{					
			NoAction();
			Screen->DrawTile(0, 16, 4 - (i / 2), 45760, 9, 6, 0, -1, -1, 0, 0, 0, 0, 1, 128);			
			Waitframe();
		}
		
		Screen->Message(MSG_LINK_BEATEN + 2);
		
		// Buffer
		for (int i = 0; i < 60; ++i)
		{					
			NoAction();
			Screen->DrawTile(0, 16, -11, 45760, 9, 6, 0, -1, -1, 0, 0, 0, 0, 1, 128);
			Waitframe();			
		}
		
		Hero->HP = Hero->MaxHP;
		
		//Falling
		for (int i = 0; i < 32; ++i)
		{					
			NoAction();
			Screen->DrawTile(0, 16, -11 + (i * 2), 45760, 9, 6, 0, -1, -1, 0, 0, 0, 0, 1, 128);		
			
			if (i == 10)
			{
				eweapon waterfallLeft = CreateEWeaponAt(EW_SCRIPT10, 76, 64);
				waterfallLeft->Damage = 0;
				waterfallLeft->Script = Game->GetEWeaponScript("Waterfall");
				waterfallLeft->DrawYOffset = -1000;
				waterfallLeft->InitD[0] = 3;
				waterfallLeft->InitD[1] = 64;	
				
				eweapon waterfallRight = CreateEWeaponAt(EW_SCRIPT10, 124, 64);
				waterfallRight->Damage = 0;
				waterfallRight->Script = Game->GetEWeaponScript("Waterfall");
				waterfallRight->DrawYOffset = -1000;
				waterfallRight->InitD[0] = 3;
				waterfallRight->InitD[1] = 64;	
			}
			
			if (i == 31)
			{
				for(int q = 0; q < MAX_ITEMDATA; ++q)
					unless(q == 3 || q == I_DIFF_NORMAL || q == 183)
						Hero->Item[q] = false;
					
				Game->Counter[CR_SBOMBS] = 0;
				Game->Counter[CR_BOMBS] = 0;
				Game->Counter[CR_ARROWS] = 0;
				Game->Counter[CR_RUPEES] = 0;				

				Game->MCounter[CR_SBOMBS] = 0;
				Game->MCounter[CR_BOMBS] = 0;
				Game->MCounter[CR_ARROWS] = 0;
				Game->MCounter[CR_RUPEES] = 255;
				Game->Generic[GEN_MAGICDRAINRATE] = 2;
				
				Hero->MaxHP = 48;
				Hero->MaxMP = 32;
		
				Hero->HP = Hero->MaxHP;
				Hero->MP = Hero->MaxMP;
		
				Hero->WarpEx({WT_IWARPOPENWIPE, dmap, scrn, -1, WARP_A, WARPEFFECT_OPENWIPE, 0, 0, DIR_UP});	
			}
			
			Waitframe();
		}		
	}
}

//end

//~~~~~EndOfOpeningScene~~~~~//
//D0: Message to play
//D1: Dmap to warp to
//D2: screen to warp to
@Author ("Deathrider365")
ffc script EndOfOpeningScene //start
{
	void run(int msg, int dmap, int scr)
	{
		Audio->PlayEnhancedMusic(NULL, 0);
		NoAction();
		
		for (int i = 0; i < 120; ++i)
		{
			Audio->PlayEnhancedMusic(NULL, 0);
			Waitframe();
		}
		
		Link->PressStart = false;
		Link->InputStart = false;
		Link->PressMap = false;
		Link->InputMap = false;
		Audio->PlayEnhancedMusic(NULL, 0);
		Screen->Message(msg);
		Audio->PlayEnhancedMusic(NULL, 0);
		Waitframe();
		Audio->PlayEnhancedMusic(NULL, 0);
		Hero->WarpEx({WT_IWARPBLACKOUT, dmap, scr, -1, WARP_A, WARPFX_BLACKOUT, 0, 0, DIR_DOWN});
	}
} //end

//~~~~~PreInteritusCutscene~~~~~//
//D0: Dmap to warp to
//D1: screen to warp to
@Author ("Deathrider365")
ffc script PreInteritusCutscene //start
{
	void run(int reg)
	{
		while(true)
		{
			if (Hero->X == 0 && Hero->Y > 59)
			{
				unless (getScreenD(reg))
				{
					setScreenD(reg, true);
					Hero->WarpEx({WT_IWARPBLACKOUT, 0, 80, -1, WARP_A, WARPEFFECT_OPENWIPE, 0, 0, DIR_UP});
				}
				else
					Hero->WarpEx({WT_IWARPBLACKOUT, 10, 47, -1, WARP_A, WARPEFFECT_OPENWIPE, 0, 0, DIR_LEFT});
			}
			else
				Hero->Action = LA_RAFTING;

			Waitframe();
		}
	}
}

//end

//~~~~~PreInteritusLeviathanScene~~~~~//
//D0: Dmap to warp to
//D1: screen to warp to
@Author ("Deathrider365")
ffc script PreInteritusLeviathanScene //start Have this vary based on whether you defeated the leviathan or not
{
	using namespace Leviathan1Namespace;
	
	void run()
	{			
		Hero->Item[26] = false;
		NoAction();
		
		Audio->PlayEnhancedMusic(NULL, 0);
		
		for (int i = 0; i < 120; ++i)
		{
			NoAction();
			Screen->FastCombo(2, 240 - i, 128, 6743, 0, OP_OPAQUE);
			Screen->FastCombo(1, 240 - i, 128, 6742, 0, OP_OPAQUE);
			Waitframe();
		}
		
		Audio->PlayEnhancedMusic("Bomb Ring - Final Fantasy IV.ogg", 0);
	
		if (waterfall_bmp && waterfall_bmp->isAllocated())
			waterfall_bmp->Free();
			
		waterfall_bmp = Game->CreateBitmap(32, 176);
		
		Leviathan1.UpdateWaterfallBitmap();
		
		Hero->Dir = DIR_UP;
		NoAction();
		
		// Rising
		for(int i = 0; i < 180; ++i) //start
		{
			NoAction();
			
			Screen->FastCombo(2, 120, 128, 6743, 0, OP_OPAQUE);
			Screen->FastCombo(1, 120, 128, 6742, 0, OP_OPAQUE);
			
			Screen->DrawTile(0, -16, 228 - i, 45760, 9, 6, 0, -1, -1, 0, 0, 0, 0, 1, 128);
			Waitframe();
			
			if(i % 40 == 0)
			{
			
				NoAction();
				Audio->PlaySound(SFX_ROCKINGSHIP);
				Screen->Quake = 20;
			}
			
			NoAction();

			Waitframe();
		} //end
		
		//
		//    The leviathan pauses
		//
		for(int i = 0; i < 120; ++i) //start
		{
			NoAction();
			
			Screen->FastCombo(2, 120, 128, 6743, 0, OP_OPAQUE);
			Screen->FastCombo(1, 120, 128, 6742, 0, OP_OPAQUE);
			
			Screen->DrawTile(0, -16, 48, 45760, 9, 6, 0, -1, -1, 0, 0, 0, 0, 1, 128);
			Waitframe();
		} //end
		
		Audio->PlaySound(SFX_ROAR);
		
		if (Hero->Item[183])
			Screen->Message(173);
		else
			Screen->Message(47);
		
		for(int i = 0; i < 120; ++i) //start
		{
			NoAction();
			
			Screen->FastCombo(2, 120, 128, 6743, 0, OP_OPAQUE);
			Screen->FastCombo(1, 120, 128, 6742, 0, OP_OPAQUE);
			
			Screen->DrawTile(0, -16 - 0.125, 48, 45760, 9, 6, 0, -1, -1, 0, 0, 0, 0, 1, 128);
			Waitframe();
		} //end

		int x, x2, j, k;
		
		//Charging
		for (int i = 0; i < 128; ++i)
		{				
			NoAction();
			
			if (i < 80)
			{
				Screen->FastCombo(2, 120, 128, 6743, 0, OP_OPAQUE);
				Screen->FastCombo(1, 120, 128, 6742, 0, OP_OPAQUE);
			}
			
			Screen->DrawTile(0, -16 + (i * 2), 48, 45760, 9, 6, 0, -1, -1, 0, 0, 0, 0, 1, 128);		
			
			if (i == 10)
			{
				int side = -1;
				
				x = side == -1 ? -32 : 144;
				x2 = x + 32 * side;
				
				for(i = 0; i < 64; ++i)
				{
				
					NoAction();
					Screen->FastCombo(2, 120, 128, 6743, 0, OP_OPAQUE);
					Screen->FastCombo(1, 120, 128, 6742, 0, OP_OPAQUE);
					
					Screen->DrawTile(0, -16 + (i * 2) + 20, 48, 45760, 9, 6, 0, -1, -1, 0, 0, 0, 0, 1, 128);		
					
					this->X -= side * 4;
					this->Y += 0.5;
					
					eweapon waterfall = CreateEWeaponAt(EW_SCRIPT10, this->X + 80, 112);
					waterfall->Damage = 0;
					waterfall->Script = Game->GetEWeaponScript("Waterfall");
					waterfall->DrawYOffset = -1000;
					waterfall->InitD[0] = 1;
					waterfall->InitD[1] = 64 - i * 0.5;
					
					Waitframe();
				}
			}
			
			if (i % 80 == 0)
			   Audio->PlaySound(SFX_ROAR);
			
			if (i == 120)
			{
				Hero->HP = Hero->MaxHP;
				Hero->WarpEx({WT_IWARPOPENWIPE, 2, 96, -1, WARP_A, WARPEFFECT_OPENWIPE, 0, 0, DIR_UP});
			}
			Waitframe();
		}		
	}
}

//end

//~~~~~PostSceneEnteringInteritus~~~~~//
//D0: Dmap to warp to
//D1: screen to warp to
@Author ("Deathrider365")
ffc script PostSceneEnteringInteritus //start
{
	void run()
	{
		while(true)
		{
			if (Hero->X == 240 && Hero->Y == 80)
				Hero->Action = LA_RAFTING;
				
			Waitframe();
		}
	}
}
//end






















