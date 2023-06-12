///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Cutscenes ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

@Author("Deathrider365")
ffc script ShipCabin {
   void run() {
      Audio->PlayEnhancedMusic("WW - Ship Theme.ogg", 0);
   }
}

@Author("Deathrider365")
ffc script IntroAwaitingLeviathan {	
   void run(int message, int dmap, int scr, int timeUntilWarp) {
      Audio->PlayEnhancedMusic("WW - The Great Sea.ogg", 0);
      int timer = 0;
      
      while (true) {
         ++timer;
         
         if (timer == timeUntilWarp) {
            Audio->PlayEnhancedMusic(NULL, 0);
            Hero->Dir = DIR_RIGHT;
            
            for (int i = 0; i < 16; ++i) {
               disableLink();
               Screen->FastCombo(2, 256 - i, 80, 6715, 0, OP_OPAQUE);
               Waitframe();
            }
            
            disableLink();
            Screen->FastTile(2, 240, 80, 44276, 0, OP_OPAQUE);
            Screen->Message(message);
            Waitframe();
            
            for (int i = 0; i < 240; ++i) {
               disableLink();
               
               if (i % 60 == 0) {
                  Screen->Quake = 20;
                  Audio->PlaySound(SFX_ROCKINGSHIP);
               }
               
               Hero->Dir = DIR_UP;
               Screen->FastTile(2, 240, 80, 44275, 0, OP_OPAQUE);
               Waitframe();
            }
            
            disableLink();
            Hero->Dir = DIR_RIGHT;
            Screen->FastTile(2, 240, 80, 44276, 0, OP_OPAQUE);
            Screen->Message(message + 1);
            Waitframe();
            
            disableLink();
            Screen->FastTile(2, 240, 80, 44276, 0, OP_OPAQUE);
            Hero->WarpEx({WT_IWARPOPENWIPE, dmap, scr, -1, WARP_A, WARPEFFECT_WAVE, 0, 0, DIR_UP});
         }
         
         Waitframe();
      }
   }
}

@Author ("Deathrider365")
ffc script IntroLeviathanFightFail {
	void run() {
		while (true) {
			if (Hero->HP <= 0) {
				Hero->HP = 1;
				Hero->Warp(2, 10);
			}
			Waitframe();
		}
	}
}

@Author ("Deathrider365")
ffc script IntroLeviathanFailDialogue {
   void run(int dmap, int scrn) {
      Screen->Message(24);
      Audio->PlayEnhancedMusic(NULL, 0);

      for (int i = 0; i < 120; ++i) {					
         disableLink();
         Screen->DrawTile(0, 50, 32, 45760, 9, 6, 0, -1, -1, 0, 0, 0, 0, 1, 128);	
         Waitframe();
      }
      
      Hero->WarpEx({WT_IWARPOPENWIPE, dmap, scrn, -1, WARP_A, WARPEFFECT_WAVE, 0, 0, DIR_UP});
   }
}

@Author ("Deathrider365")
ffc script IntroLeviathanEnding {
	using namespace LeviathanNamespace;
	
   void run(int dmap, int scrn) {
      Audio->PlayEnhancedMusic("Final Fantasy IV - Bomb Ring.ogg", 0);

      if (waterfallBitmap && waterfallBitmap->isAllocated())
         waterfallBitmap->Free();
         
      waterfallBitmap = Game->CreateBitmap(32, 176);
      Leviathan.UpdateWaterfallBitmap();
      
      Hero->Dir = DIR_UP;
      disableLink();
      
      Screen->Message(25);
      
      // Buffer
      for (int i = 0; i < 60; ++i) {
         disableLink();
         Screen->DrawTile(0, 16, 4, 45760, 9, 6, 0, -1, -1, 0, 0, 0, 0, 1, 128);
         Waitframe();			
      }
      
      // Rising
      for (int i = 0; i < 32; ++i) {
         disableLink();
         Screen->DrawTile(0, 16, 4 - (i / 2), 45760, 9, 6, 0, -1, -1, 0, 0, 0, 0, 1, 128);			
         Waitframe();
      }
      
      Screen->Message(26);
      
      // Buffer
      for (int i = 0; i < 30; ++i) {
         disableLink();
         Screen->DrawTile(0, 16, -11, 45760, 9, 6, 0, -1, -1, 0, 0, 0, 0, 1, 128);
         Waitframe();			
      }
      
      Hero->HP = Hero->MaxHP;
      
      //Falling
      for (int i = 0; i < 100; ++i) {
         disableLink();
         
         if (i < 35)
            Screen->DrawTile(0, 16, -11 + (i * 2), 45760, 9, 6, 0, -1, -1, 0, 0, 0, 0, 1, 128);
            
         if (i == 24) {
            eweapon waterfall = CreateEWeaponAt(EW_SCRIPT10, 100, 80);
            waterfall->Damage = 0;
            waterfall->Script = Game->GetEWeaponScript("Waterfall");
            waterfall->DrawYOffset = -1000;
            waterfall->InitD[0] = 6;
            waterfall->InitD[1] = 32;
         }
         
         Waitframe();
      }
      
      removeAllItems();
      Hero->WarpEx({WT_IWARPOPENWIPE, dmap, scrn, -1, WARP_A, WARPEFFECT_NONE, 0, 0, DIR_UP});	
   }
}

@Author ("Deathrider365")
ffc script IntroEndOfOpeningScene {
   void run(int msg, int dmap, int scr) {
      
      for (int i = 0; i < 120; ++i) {
         Audio->PlayEnhancedMusic(NULL, 0);
         disableLink();
         Waitframe();
      }
      
      disableLink();
      Screen->Message(msg);
      Waitframe();
      Hero->WarpEx({WT_IWARPBLACKOUT, dmap, scr, -1, WARP_A, WARPFX_BLACKOUT, 0, 0, DIR_DOWN});
   }
}

@Author ("Deathrider365")
ffc script IntroLeavingIoH {
   void run()	{
      while(true) {
         if (Hero->X == 0 && Hero->Y > 59) {
            unless (getScreenD(0)) {
               setScreenD(0, true);
               Hero->WarpEx({WT_IWARPBLACKOUT, 0, 80, -1, WARP_A, WARPEFFECT_WAVE, 0, 0, DIR_UP});
            }
            else
               Hero->Warp(10, 47);
         }
         else
            Hero->Action = LA_RAFTING;

         Waitframe();
      }
   }
}

@Author ("Deathrider365")
ffc script IntroPreInteritusLeviathanScene {
   using namespace LeviathanNamespace;
	
   void run() {	
      Hero->Item[189] = false;
      
      Audio->PlayEnhancedMusic(NULL, 0);
      
      for (int i = 0; i < 120; ++i) {
         disableLink();
         Screen->FastCombo(3, 240 - i, 132, 6271, 0, OP_TRANS);
         Screen->FastCombo(2, 240 - i, 122, 6743, 0, OP_OPAQUE);
         Screen->FastCombo(1, 240 - i, 128, 6742, 0, OP_OPAQUE);
         Waitframe();
      }
      
      Audio->PlayEnhancedMusic("Final Fantasy IV - Bomb Ring.ogg", 0);

      if (waterfallBitmap && waterfallBitmap->isAllocated())
         waterfallBitmap->Free();
         
      waterfallBitmap = Game->CreateBitmap(32, 176);
      
      Leviathan.UpdateWaterfallBitmap();
      
      Hero->Dir = DIR_UP;
      
      // Rising
      for(int i = 0; i < 180; ++i) {
         disableLink();
         Screen->FastCombo(3, 120, 132, 6271, 0, OP_TRANS);
         Screen->FastCombo(2, 120, 122, 6702, 0, OP_OPAQUE);
         Screen->FastCombo(1, 120, 128, 6742, 0, OP_OPAQUE);
         Screen->DrawTile(0, -16, 228 - i, 45760, 9, 6, 0, -1, -1, 0, 0, 0, 0, 1, 128);
         Waitframe();
         
         if(i % 40 == 0) {
            Audio->PlaySound(SFX_ROCKINGSHIP);
            Screen->Quake = 20;
         }

         Waitframe();
      }
      
      // The leviathan pauses
      for(int i = 0; i < 120; ++i) {
         disableLink();
         Screen->FastCombo(3, 120, 132, 6271, 0, OP_TRANS);
         Screen->FastCombo(2, 120, 122, 6702, 0, OP_OPAQUE);
         Screen->FastCombo(1, 120, 128, 6742, 0, OP_OPAQUE);
         Screen->DrawTile(0, -16, 48, 45760, 9, 6, 0, -1, -1, 0, 0, 0, 0, 1, 128);
         Waitframe();
      }
      
      Audio->PlaySound(SFX_ROAR);
      
      Screen->Message(Hero->Item[183] ? 43 : 47);
      
      for(int i = 0; i < 60; ++i) {
         disableLink();
         Screen->FastCombo(3, 120, 132, 6271, 0, OP_TRANS);
         Screen->FastCombo(2, 120, 122, 6702, 0, OP_OPAQUE);
         Screen->FastCombo(1, 120, 128, 6742, 0, OP_OPAQUE);
         Screen->DrawTile(0, -16 - 0.125, 48, 45760, 9, 6, 0, -1, -1, 0, 0, 0, 0, 1, 128);
         Waitframe();
      }

      int x, x2;
      
      for (int i = 0; i < 120; ++i) {		
         disableLink();
         
         if (i < 80) {
            Screen->FastCombo(3, 120, 132, 6271, 0, OP_TRANS);
            Screen->FastCombo(2, 120, 122, 6772, 0, OP_OPAQUE);
            Screen->FastCombo(1, 120, 128, 6742, 0, OP_OPAQUE);
         }
         
         Screen->DrawTile(0, -16 + (i * 2), 48, 45760, 9, 6, 0, -1, -1, 0, 0, 0, 0, 1, 128);		
         
         if (i == 10) {
            int side = -1;
            
            x = side == -1 ? -32 : 144;
            x2 = x + 32 * side;
            
            for(i = 0; i < 64; ++i) {
               disableLink();
               Screen->FastCombo(3, 120, 132, 6271, 0, OP_TRANS);
               Screen->FastCombo(2, 120, 122, 6772, 0, OP_OPAQUE);
               Screen->FastCombo(1, 120, 128, 6742, 0, OP_OPAQUE);
               
               Screen->DrawTile(0, -16 + (i * 2) + 20, 48, 45760, 9, 6, 0, -1, -1, 0, 0, 0, 0, 1, 128);		
               
               this->X -= side * 4;
               this->Y += 0.5;
               
               eweapon waterfall = CreateEWeaponAt(EW_SCRIPT10, this->X + 60, 112);
               waterfall->Damage = 0;
               waterfall->Script = Game->GetEWeaponScript("Waterfall");
               waterfall->DrawYOffset = -1000;
               waterfall->InitD[0] = 1;
               waterfall->InitD[1] = 64 - i * 0.5;
               
               Waitframe();
            }
         }
         
         if (i == 60)
            Audio->PlaySound(SFX_HERO_HURT_1);
         
         if (i % 80 == 0)
            Audio->PlaySound(SFX_ROAR);
         
         Hero->HP = Hero->MaxHP;
         
         Waitframe();
      }
      
      Waitframes(60);
      leavingTransition(0, 81, 0);
   }
}

@Author("Deathrider365")
ffc script IntroFinalMessageBeforeIoH {
   void run(int message) {
      Audio->PlayEnhancedMusic(NULL, 0);
      Screen->Message(message);
      leavingTransition(12, 80, 0);	
   }
}

@Author("Deathrider365")
ffc script OfficialIntroPresents {
   void run() {
      for (int i = 0; i < 120; ++i) {
         disableLink();
         Screen->Rectangle(7, 24, 24, 232, 71, C_BLACK, 1, 0, 0, 0, true, OP_OPAQUE);
         Waitframe();
      }
      
      for (int i = 0; i < 45; ++i) {
         disableLink();
         Screen->Rectangle(7, 24 - i * 5, 24, 232 - i * 5, 71, C_BLACK, 1, 0, 0, 0, true, OP_OPAQUE);
         Screen->DrawTile(6, 24, 24, 42406, 13, 3, 0, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
         Waitframe();			
      }
      
      for (int i = 0; i < 120; ++i)	{
         disableLink();
         Screen->DrawTile(6, 24, 24, 42406, 13, 3, 0, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
         Waitframe();
      }
      
      leavingTransition(12, 96, 1);
   }
}

@Author("Deathrider365")
ffc script OfficialIntroMovie {
   void run(int dmap, int screen) {
      for (int i = 0; i < INTRO_SCENE_TRANSITION_FRAMES; ++i) {
         disableLink();
         Screen->Rectangle(7, 0 - i * INTRO_SCENE_TRANSITION_MULT, 0, 256 - i * INTRO_SCENE_TRANSITION_MULT, 176, C_BLACK, 1, 0, 0, 0, true, OP_OPAQUE);
         Waitframe();
      }
      
      for (int i = 0; i < 180; ++i) {
         disableLink();
         Waitframe();
      }
      
      for (int i = 0; i < INTRO_SCENE_TRANSITION_FRAMES; ++i) {
         disableLink();
         Screen->Rectangle(7, 256 - i * INTRO_SCENE_TRANSITION_MULT, 0, 512 - i * INTRO_SCENE_TRANSITION_MULT, 176, C_BLACK, 1, 0, 0, 0, true, OP_OPAQUE);
         Waitframe();
      }
      
      Hero->Warp(dmap, screen);
   }
}

@Author("Deathrider365")
ffc script OfficialIntroFinalScene {
   void run() {
      enteringTransition();
      
      for (int i = 0; i < 180; ++i) {
         disableLink();
         Waitframe();
      }
      
      for (int i = 0; i < INTRO_SCENE_TRANSITION_FRAMES; ++i) {
         disableLink();
         Screen->Rectangle(7, 256 - i * INTRO_SCENE_TRANSITION_MULT, 0, 512 - i * INTRO_SCENE_TRANSITION_MULT, 176, C_BLACK, 1, 0, 0, 0, true, OP_OPAQUE);
         Waitframe();
      }
      
      Hero->Warp(12, 13);
   }
}

@Author ("Deathrider365")
ffc script ComingFromIsleOfHaeren {
   void run() {
      while(true) {
         if (Hero->X == 240 && Hero->Y == 80)
            Hero->Action = LA_RAFTING;
            
         Waitframe();
      }
   }
}

@Author ("Moosh")
ffc script DifficultyChoice {
    void run() {
		for (int i = 0; i < 20; ++i) {
         notDuringCutsceneLink();
			Screen->Rectangle(7, 0, 0, 256, 176, C_BLACK, 1, 0, 0, 0, true, OP_OPAQUE);
			Waitframe();
		}

		enteringTransition();
      
      bool cursor = false;

		while(true) {
         notDuringCutsceneLink();
         
         Screen->FastTile(7, 96, !cursor ? 96 : 112, 46675, 0, OP_OPAQUE);
         
         if (Input->Press[CB_DOWN] || Input->Press[CB_UP]) {
            Audio->PlaySound(CURSOR_MOVEMENT_SFX);
            cursor = !cursor;
         }
            
			if (Input->Press[CB_A]) {
            Hero->Item[!cursor ? I_DIFF_NORMAL : I_DIFF_VERYHARD] = true;
            Audio->PlaySound(!cursor ? 139 : 140);

            for (int i = 0; i < 45; ++i) {
               Screen->FastTile(7, 80, !cursor ? 96 : 112, !cursor ? 46594 : 46634, 0, OP_OPAQUE);
               Screen->FastTile(7, 96, !cursor ? 96 : 112, !cursor ? 46595 : 46635, 0, OP_OPAQUE);
               Screen->FastTile(7, 112, !cursor ? 96 : 112, !cursor ? 46596 : 46636, 0, OP_OPAQUE);
               Screen->FastTile(7, 128, !cursor ? 96 : 112, !cursor ? 46597 : 46637, 0, OP_OPAQUE);
               Screen->FastTile(7, 144, !cursor ? 96 : 112, !cursor ? 46598 : 46638, 0, OP_OPAQUE);
               Screen->FastTile(7, 160, !cursor ? 96 : 112, !cursor ? 46599 : 46639, 0, OP_OPAQUE);
               Waitframe();
            }

            Waitframes(30);
            Hero->WarpEx({WT_IWARP, 5, 0x3E, -1, WARP_B, WARPEFFECT_WAVE, 0, 0, DIR_RIGHT});
			}

			Waitframe();
		}
    }
}

@Author("Deathrider365")
ffc script CapturedSequenceImprisioned {
   void run() {
      if (getScreenD(0)) {
         this->Data = COMBO_INVIS;
         Quit();
      }
      
      mapdata mapDataLayer1 = Game->LoadTempScreen(1);
      mapdata mapDataLayer3 = Game->LoadTempScreen(3);
      dmapdata dmapData = Game->LoadDMapData(Game->GetCurDMap());
      int soldierCombo1X = 224;
      int soldierCombo2X = 224;
   
      if (getScreenD(1)) {
         dmapData->SetMusic("Castlevania 64 - Setting.ogg");
         
         soldierCombo1X = 176;
         soldierCombo2X = 192;
         
         mapDataLayer1->ComboD[98] = 7288;
         mapDataLayer3->ComboD[82] = 7284;
         mapDataLayer1->ComboD[125] = 7011;
         this->Data = 7015;
         this->X = 144;
         this->Y = 112;
      }
      else {
         until (Hero->X < 48 && Hero->Y < 48)
            Waitframe();
            
         Audio->PlayEnhancedMusic(NULL, 0);
         disableLink();
         Audio->PlaySound(SFX_SHUTTER_CLOSE);
         mapDataLayer1->ComboD[98] = 7288;
         mapDataLayer3->ComboD[82] = 7284;
         
         for(int i = 0; i < 45; ++i) {
            disableLink();
            Waitframe();
         }
         Screen->Message(241);
         
         for(int i = 0; i < 30; ++i) {
            disableLink();
            Waitframe();
         }
         
         this->Data = 7013;
         
         for (int i = 0; i < 45; ++i) {
            disableLink();
            Waitframe();
         }
         
         for (int i = 0; i < 120; ++i) {
            disableLink();
            
            if (i < 48) {
               Hero->Dir = DIR_LEFT;
               this->Y += 1;
               
               if (Hero->X <= 32)
                  Hero->X += 1;
            }
            else if (i < 64) {
               Hero->Dir = DIR_DOWN;
               this->Data = 7015;
               this->X += 1;
            }
            else if (i < 80) {
               this->Data = 7013;
               this->Y += 1;
            }
            
            Waitframe();
         }
            
         for (int i = 0; i < 4; ++i) {
            disableLink();
            Waitframe();
         }
         
         Audio->PlaySound(SFX_SHUTTER_OPEN);
         mapDataLayer1->ComboD[98] = 0;
         mapDataLayer3->ComboD[82] = 0;
         Audio->PlayEnhancedMusic("Castlevania 64 - Setting.ogg", 0); 
         
         for (int i = 0; i < 32; ++i) {
            disableLink();
            
            if (i < 24)
               Hero->InputDown = true;
            
            this->Y += 1;
            Waitframe();
         }
           
         this->Data = 7012;
         
         for (int j = 0; j < 4; ++j) {
            disableLink();
            Waitframe();
         }
         
         mapDataLayer1->ComboD[98] = 7288;
         mapDataLayer3->ComboD[82] = 7284;
         Audio->PlaySound(SFX_SHUTTER_CLOSE);
         
         Screen->Message(242);
         Waitframe();
         
         this->Data = 7015;
         
         for (int i = 0; i < 112; ++i) {
            this->X += 1;
            
            if (i < 48) {
               Screen->FastCombo(1, soldierCombo1X -= 1, 112, 7014, 7, OP_OPAQUE);
               
               if (i > 16)
                  Screen->FastCombo(1, soldierCombo2X -= 1, 112, 7014, 7, OP_OPAQUE);
            }
            else {
               Screen->FastCombo(1, soldierCombo1X, 112, 7014, 7, OP_OPAQUE);
               Screen->FastCombo(1, soldierCombo2X, 112, 7014, 7, OP_OPAQUE);
            }
            Waitframe();
         }
         
         mapDataLayer1->ComboD[125] = 7011;
         
         Screen->FastCombo(1, 208, 112, 5067, 3, OP_OPAQUE);
      }
      
      int counter = 300;
      
      while (Hero->Y < 100) {
         setScreenD(1, true);
         Screen->FastCombo(1, soldierCombo1X, 112, 7014, 7, OP_OPAQUE);
         Screen->FastCombo(1, soldierCombo2X, 112, 7014, 7, OP_OPAQUE);
         
         if (!counter && !Screen->State[ST_SECRET])
            break;
            
         --counter;
         Waitframe();
      }
      
      if (Screen->State[ST_SECRET]) {
         this->Data = 7014;
         Audio->PlayEnhancedMusic(NULL, 0);  
         
         Screen->Message(243);
         Screen->FastCombo(1, soldierCombo1X, 112, 7014, 7, OP_OPAQUE);
         Screen->FastCombo(1, soldierCombo2X, 112, 7014, 7, OP_OPAQUE);
         Waitframe();
         
         dmapData->SetMusic("Castlevania Lament of Innocence-Elemental Tactician.ogg");
         Audio->PlayEnhancedMusic("Castlevania Lament of Innocence-Elemental Tactician.ogg", 0);
         
         this->Data = COMBO_INVIS;
         npc soldier1 = Screen->CreateNPC(ENEMY_SOLDIER_LEVEL2_HALTED);
         soldier1->X = 176;
         soldier1->Y = 112;
         npc soldier2 = Screen->CreateNPC(ENEMY_SOLDIER_LEVEL2_HALTED);
         soldier2->X = 192;
         soldier2->Y = 112;
         npc soldier3 = Screen->CreateNPC(ENEMY_SOLDIER_LEVEL2_HALTED);
         soldier3->X = this->X;
         soldier3->Y = this->Y;
         // soldier3->X = 48;
         // soldier3->Y = 112;
         
         while (Screen->NumNPCs()) 
            Waitframe();
         
         Audio->PlaySound(SFX_OOT_SECRET);
         mapDataLayer1->ComboD[125] = 7007;
         setScreenD(0, true);
      }
      else {
         mapDataLayer1->ComboD[125] = 7007;
         Audio->PlayEnhancedMusic("Final Fantasy VII - Those Chosen by the Planet.mp3", 0);
         this->Data = 7015;
         
         for (int i = 0; i < 60; ++i) {
            Screen->FastCombo(1, soldierCombo1X, 112, 7015, 7, OP_OPAQUE);
            Screen->FastCombo(1, soldierCombo2X, 112, 7015, 7, OP_OPAQUE);
            Waitframe();
         }
         
         Audio->PlaySound(SFX_SHUTTER_OPEN);
         mapDataLayer1->ComboD[102] = COMBO_INVIS;
         mapDataLayer1->ComboD[105] = COMBO_INVIS;
         mapDataLayer1->ComboD[109] = COMBO_INVIS;
         mapDataLayer3->ComboD[86] = COMBO_INVIS;
         mapDataLayer3->ComboD[93] = COMBO_INVIS;
         
         this->Data = 7014;
         int solderCombo1Y = 112;
         int solderCombo2Y = 112;
         
         CONFIG COMBO_NECROMANCER_LEFT = 6799;
         CONFIG COMBO_NECROMANCER_UP = 6744;
         CONFIG COMBO_RIGHT_HAND_LEFT = 6802;
         int necromancerStartX = 224;
         int rightHandStartX = 224;
         
         for (int i = 0; i < 432; ++i) {
            if (i < 16) {
               this->X -= 1;
               Screen->FastCombo(1, soldierCombo1X -= 1, solderCombo1Y, 7014, 7, OP_OPAQUE);
               Screen->FastCombo(1, soldierCombo2X += 1, solderCombo2Y, 7015, 7, OP_OPAQUE);
            }
            else if (i < 32) {
               this->X -= 1;
               Screen->FastCombo(1, soldierCombo1X -= 1, solderCombo1Y, 7014, 7, OP_OPAQUE);
               Screen->FastCombo(1, soldierCombo2X, solderCombo2Y -=1, 7013, 7, OP_OPAQUE);
               
            }
            else if (i < 48) {
               Screen->FastCombo(1, soldierCombo1X, solderCombo1Y -= 1, 7013, 7, OP_OPAQUE);
               Screen->FastCombo(1, soldierCombo2X, solderCombo2Y, 7013, 7, OP_OPAQUE);
               this->X -= 1;
            }
            else if (i < 64) {
               Screen->FastCombo(1, soldierCombo1X, solderCombo1Y, 7013, 7, OP_OPAQUE);
               Screen->FastCombo(1, soldierCombo2X, solderCombo2Y, 7013, 7, OP_OPAQUE);
               this->Y -= 1;
               this->Data = 7013;
               
               Screen->FastCombo(1, necromancerStartX -= .5, 112, COMBO_NECROMANCER_LEFT, 7, OP_OPAQUE);
            }
            else if (i < 112) {
               Screen->FastCombo(1, soldierCombo1X, solderCombo1Y, 7013, 7, OP_OPAQUE);
               Screen->FastCombo(1, soldierCombo2X, solderCombo2Y, 7013, 7, OP_OPAQUE);
               Screen->FastCombo(1, necromancerStartX -= .5, 112, COMBO_NECROMANCER_LEFT, 7, OP_OPAQUE);
               
            }
            else if (i < 143) {
               Screen->FastCombo(1, soldierCombo1X, solderCombo1Y, 7013, 7, OP_OPAQUE);
               Screen->FastCombo(1, soldierCombo2X, solderCombo2Y, 7013, 7, OP_OPAQUE);
               Screen->FastCombo(1, necromancerStartX -= .5, 112, COMBO_NECROMANCER_LEFT, 7, OP_OPAQUE);
               Screen->FastCombo(1, rightHandStartX -= .5, 112, COMBO_RIGHT_HAND_LEFT, 7, OP_OPAQUE);
               
            }
            else if (i < 224){
               Screen->FastCombo(1, soldierCombo1X, solderCombo1Y, 7013, 7, OP_OPAQUE);
               Screen->FastCombo(1, soldierCombo2X, solderCombo2Y, 7013, 7, OP_OPAQUE);
               Screen->FastCombo(1, necromancerStartX -= .5, 112, COMBO_NECROMANCER_LEFT, 7, OP_OPAQUE);
               Screen->FastCombo(1, rightHandStartX, 112, COMBO_RIGHT_HAND_LEFT, 7, OP_OPAQUE);
            }
            else {
               Screen->FastCombo(1, soldierCombo1X, solderCombo1Y, 7013, 7, OP_OPAQUE);
               Screen->FastCombo(1, soldierCombo2X, solderCombo2Y, 7013, 7, OP_OPAQUE);
               Screen->FastCombo(1, necromancerStartX -= .5, 112, COMBO_NECROMANCER_LEFT, 7, OP_OPAQUE);
               Screen->FastCombo(1, rightHandStartX, 112, COMBO_RIGHT_HAND_LEFT, 7, OP_OPAQUE);
            }
            Waitframe();
         }
         
         Hero->Dir = DIR_DOWN;
         
         for (int i = 0; i < 180; ++i) {
            disableLink();
            Screen->FastCombo(1, soldierCombo1X, solderCombo1Y, 7013, 7, OP_OPAQUE);
            Screen->FastCombo(1, soldierCombo2X, solderCombo2Y, 7013, 7, OP_OPAQUE);
            Screen->FastCombo(1, necromancerStartX, 112, COMBO_NECROMANCER_UP, 7, OP_OPAQUE);
            Screen->FastCombo(1, rightHandStartX, 112, COMBO_RIGHT_HAND_LEFT, 7, OP_OPAQUE);
            Waitframe();
         }
         
         Screen->FastCombo(1, soldierCombo1X, solderCombo1Y, 7013, 7, OP_OPAQUE);
         Screen->FastCombo(1, soldierCombo2X, solderCombo2Y, 7013, 7, OP_OPAQUE);
         Screen->FastCombo(1, necromancerStartX, 112, COMBO_NECROMANCER_UP, 7, OP_OPAQUE);
         Screen->FastCombo(1, rightHandStartX, 112, COMBO_RIGHT_HAND_LEFT, 7, OP_OPAQUE);
         Screen->Message(244);
         Waitframe();
         
         bool chose = false;
         bool cursorOnYes = true;
         int message = 251;
         
         until (chose) {
            notDuringCutsceneLink();
            
            Screen->FastTile(7, cursorOnYes ? 80 : 128, 16, 46675, 0, OP_OPAQUE);
            
            if (Input->Press[CB_LEFT] || Input->Press[CB_RIGHT]) {
               message = cursorOnYes ? 251 : 252;
               Audio->PlaySound(CURSOR_MOVEMENT_SFX);
               cursorOnYes = !cursorOnYes;
            }
               
            if (Input->Press[CB_A]) {
               Audio->PlaySound(cursorOnYes ? 139 : 140);

               for (int i = 0; i < 30; ++i) {
                  Screen->FastTile(7, 96, 16, cursorOnYes ? 46696 : 46676, 0, OP_OPAQUE);
                  Screen->FastTile(7, 112, 16, cursorOnYes ? 46697 : 46677, 0, OP_OPAQUE);
                  Screen->FastTile(7, 144, 16, cursorOnYes ? 46678 : 46698, 0, OP_OPAQUE);
                  
                  Screen->FastCombo(1, soldierCombo1X, solderCombo1Y, 7013, 7, OP_OPAQUE);
                  Screen->FastCombo(1, soldierCombo2X, solderCombo2Y, 7013, 7, OP_OPAQUE);
                  Screen->FastCombo(1, necromancerStartX, 112, COMBO_NECROMANCER_UP, 7, OP_OPAQUE);
                  Screen->FastCombo(1, rightHandStartX, 112, COMBO_RIGHT_HAND_LEFT, 7, OP_OPAQUE);
                  
                  Waitframe();
               }
               chose = true;
            }

            Screen->FastTile(7, 96, 16, cursorOnYes ? 46696 : 46676, 0, OP_OPAQUE);
            Screen->FastTile(7, 112, 16, cursorOnYes ? 46697 : 46677, 0, OP_OPAQUE);
            Screen->FastTile(7, 144, 16, cursorOnYes ? 46678 : 46698, 0, OP_OPAQUE);
            
            Screen->FastCombo(1, soldierCombo1X, solderCombo1Y, 7013, 7, OP_OPAQUE);
            Screen->FastCombo(1, soldierCombo2X, solderCombo2Y, 7013, 7, OP_OPAQUE);
            Screen->FastCombo(1, necromancerStartX, 112, COMBO_NECROMANCER_UP, 7, OP_OPAQUE);
            Screen->FastCombo(1, rightHandStartX, 112, COMBO_RIGHT_HAND_LEFT, 7, OP_OPAQUE);
            
            Waitframe();
         }
         
         Screen->FastCombo(1, soldierCombo1X, solderCombo1Y, 7013, 7, OP_OPAQUE);
         Screen->FastCombo(1, soldierCombo2X, solderCombo2Y, 7013, 7, OP_OPAQUE);
         Screen->FastCombo(1, necromancerStartX, 112, COMBO_NECROMANCER_UP, 7, OP_OPAQUE);
         Screen->FastCombo(1, rightHandStartX, 112, COMBO_RIGHT_HAND_LEFT, 7, OP_OPAQUE);
         
         Screen->Message(message);
         Waitframe();
         
         Hero->WarpEx({WT_IWARP, 44, 0x66, -1, WARP_A, WARPEFFECT_WAVE, 0, 0, DIR_RIGHT});
      }
   }
}

@Author("Deathrider365")
ffc script CapturedSequenceEscape {
   void run(int screenNumber) {      
      if (!getScreenD(33, 0x23, 0) || getScreenD(screenNumber))
         Quit();
      
      mapdata mapDataLayer1 = Game->LoadTempScreen(1);
      int comboPos;
      
      npc soldier1 = Screen->CreateNPC(ENEMY_SOLDIER_LEVEL2_HALTED);
      npc soldier2 = Screen->CreateNPC(ENEMY_SOLDIER_LEVEL2_HALTED);
      
      switch(screenNumber) {
         case 1:
            soldier1->X = 32;
            soldier1->Y = 112;
            soldier2->X = 48;
            soldier2->Y = 112;
            comboPos = 114;
            break;
         case 2:
            soldier1->X = 192;
            soldier1->Y = 112;
            soldier2->X = 208;
            soldier2->Y = 112;
            comboPos = 125;
            break;
            
         case 3:
            soldier1->X = 48;
            soldier1->Y = 112;
            soldier2->X = 64;
            soldier2->Y = 112;
            comboPos = 99;
            break;
            
      }
      
      while (Screen->NumNPCs()) {
         mapDataLayer1->ComboD[comboPos] = 7011;
         Waitframe();
      }
      
      Audio->PlaySound(SFX_OOT_SECRET);
      setScreenD(screenNumber, true);
      mapDataLayer1->ComboD[comboPos] = 7007;
   }
}

@Author("Deathrider365")
ffc script CapturedSequenceNecromancer {
   void run() {
      unless (getScreenD(33, 0x23, 0))
         Quit();
         
      CONFIG COMBO_NECROMANCER = 6744;
      CONFIG COMBO_RIGHT_HAND = 6753;
      CONFIG COMBO_GUARD = 6755;
         
      until (Hero->X > 96 && Hero->X < 160 && Hero->Y >= 128) 
         Waitframe();
         
      Audio->PlayEnhancedMusic("Final Fantasy VII - Those Chosen by the Planet.mp3", 0);
         
      for (int i = 0; i < 120; ++i) {
         disableLink();
         Waitframe();
      }
      
      int necromancerStartY = 176;
      int rightHandStartY = 176;
      int leftGuardX = -16;
      int rightGuardX = 256;
      
      for (int i = 0; i < 240; ++i) {
         disableLink();
         Hero->Dir = DIR_DOWN;
         
         unless (i % 5)
            Hero->Y -= 1;
         
         unless (i % 4)
            Screen->FastCombo(1, 120, necromancerStartY -= 1, COMBO_NECROMANCER, 0, OP_OPAQUE);
         
         if (i % 5  == 0 && necromancerStartY < 160)
            Screen->FastCombo(1, 120, rightHandStartY -= 1, COMBO_RIGHT_HAND, 0, OP_OPAQUE);
         
         if (i >= 120 && i % 8 == 0) {
            ++leftGuardX;
            --rightGuardX;
            
            for (int i = 0; i < 9; ++i) {
               Screen->FastCombo(1, leftGuardX, 16 + (i * 16), COMBO_GUARD, 7, OP_OPAQUE);
               Screen->FastCombo(1, rightGuardX, 16 + (i * 16), COMBO_GUARD, 7, OP_OPAQUE);
            }
         }
         
         Screen->FastCombo(1, 120, necromancerStartY, COMBO_NECROMANCER, 0, OP_OPAQUE);
         Screen->FastCombo(1, 120, rightHandStartY, COMBO_RIGHT_HAND, 0, OP_OPAQUE);
         
         for (int i = 0; i < 9; ++i) {
            Screen->FastCombo(1, leftGuardX, 16 + (i * 16), COMBO_GUARD, 7, OP_OPAQUE);
            Screen->FastCombo(1, rightGuardX, 16 + (i * 16), COMBO_GUARD, 7, OP_OPAQUE);
         }
         
         Waitframe();
      }
      
      Screen->FastCombo(1, 120, necromancerStartY, COMBO_NECROMANCER, 0, OP_OPAQUE);
      Screen->FastCombo(1, 120, rightHandStartY, COMBO_RIGHT_HAND, 0, OP_OPAQUE);
      
      for (int i = 0; i < 9; ++i) {
         Screen->FastCombo(1, leftGuardX, 16 + (i * 16), COMBO_GUARD, 7, OP_OPAQUE);
         Screen->FastCombo(1, rightGuardX, 16 + (i * 16), COMBO_GUARD, 7, OP_OPAQUE);
      }
      
      Screen->Message(244);
      Waitframe();
      
      bool chose = false;
      bool cursorOnYes = true;
		int message = 251;
      
      until (chose) {
         notDuringCutsceneLink();
         
         Screen->FastTile(7, cursorOnYes ? 80 : 128, 16, 46675, 0, OP_OPAQUE);
         
         if (Input->Press[CB_LEFT] || Input->Press[CB_RIGHT]) {
            message = cursorOnYes ? 251 : 252;
            Audio->PlaySound(CURSOR_MOVEMENT_SFX);
            cursorOnYes = !cursorOnYes;
         }
            
			if (Input->Press[CB_A]) {
            Audio->PlaySound(cursorOnYes ? 139 : 140);

            for (int i = 0; i < 30; ++i) {
               Screen->FastTile(7, 96, 16, cursorOnYes ? 46696 : 46676, 0, OP_OPAQUE);
               Screen->FastTile(7, 112, 16, cursorOnYes ? 46697 : 46677, 0, OP_OPAQUE);
               Screen->FastTile(7, 144, 16, cursorOnYes ? 46678 : 46698, 0, OP_OPAQUE);
               
               Screen->FastCombo(1, 120, necromancerStartY, COMBO_NECROMANCER, 0, OP_OPAQUE);
               Screen->FastCombo(1, 120, rightHandStartY, COMBO_RIGHT_HAND, 0, OP_OPAQUE);
               
               for (int i = 0; i < 9; ++i) {
                  Screen->FastCombo(1, leftGuardX, 16 + (i * 16), COMBO_GUARD, 7, OP_OPAQUE);
                  Screen->FastCombo(1, rightGuardX, 16 + (i * 16), COMBO_GUARD, 7, OP_OPAQUE);
               }
         
               Waitframe();
            }
            chose = true;
			}

         Screen->FastTile(7, 96, 16, cursorOnYes ? 46696 : 46676, 0, OP_OPAQUE);
         Screen->FastTile(7, 112, 16, cursorOnYes ? 46697 : 46677, 0, OP_OPAQUE);
         Screen->FastTile(7, 144, 16, cursorOnYes ? 46678 : 46698, 0, OP_OPAQUE);
         
         Screen->FastCombo(1, 120, necromancerStartY, COMBO_NECROMANCER, 0, OP_OPAQUE);
         Screen->FastCombo(1, 120, rightHandStartY, COMBO_RIGHT_HAND, 0, OP_OPAQUE);
         
         for (int i = 0; i < 9; ++i) {
            Screen->FastCombo(1, leftGuardX, 16 + (i * 16), COMBO_GUARD, 7, OP_OPAQUE);
            Screen->FastCombo(1, rightGuardX, 16 + (i * 16), COMBO_GUARD, 7, OP_OPAQUE);
         }
         
			Waitframe();
		}
      
      Screen->FastCombo(1, 120, necromancerStartY, COMBO_NECROMANCER, 0, OP_OPAQUE);
      Screen->FastCombo(1, 120, rightHandStartY, COMBO_RIGHT_HAND, 0, OP_OPAQUE);
      
      for (int i = 0; i < 9; ++i) {
         Screen->FastCombo(1, leftGuardX, 16 + (i * 16), COMBO_GUARD, 7, OP_OPAQUE);
         Screen->FastCombo(1, rightGuardX, 16 + (i * 16), COMBO_GUARD, 7, OP_OPAQUE);
      }
      
      Screen->Message(message);
      Waitframe();
      
      for (int i = 0; i < 30; ++i) {
         unless (i % 2) {
            --necromancerStartY;
            --rightHandStartY;
            ++leftGuardX;
            --rightGuardX;
         }
         
         Screen->FastCombo(1, 120, necromancerStartY, COMBO_NECROMANCER, 0, OP_OPAQUE);
         Screen->FastCombo(1, 120, rightHandStartY, COMBO_RIGHT_HAND, 0, OP_OPAQUE);
         
         for (int i = 0; i < 9; ++i) {
            Screen->FastCombo(1, leftGuardX, 16 + (i * 16), COMBO_GUARD, 7, OP_OPAQUE);
            Screen->FastCombo(1, rightGuardX, 16 + (i * 16), COMBO_GUARD, 7, OP_OPAQUE);
         }
         
         Waitframe();
      }
      
      Hero->WarpEx({WT_IWARP, 44, 0x66, -1, WARP_A, WARPEFFECT_WAVE, 0, 0, DIR_RIGHT});
   }
}

@Author("Deathrider365")
ffc script CapturesSequenceRightHand {
   CONFIG COMBO_UPPER_GATE = 7284;
   CONFIG COMBO_LOWER_GATE = 7288;
   CONFIG COMBO_RIGHT_HAND_UP = 6800;
   CONFIG COMBO_RIGHT_HAND_DOWN = 6801;
   CONFIG COMBO_RIGHT_HAND_LEFT = 6802;
   CONFIG COMBO_RIGHT_HAND_RIGHT = 6803;
   
   void run() {
      if (getScreenD(0)) {
         this->Data = COMBO_INVIS;
         
         while(true) {
            unless (gameframe % 120)
               Audio->PlaySound(SFX_WATER_DRIPPING);
               
            Waitframe();            
         }
      }
            
      mapdata mapDataLayer1 = Game->LoadTempScreen(1);
      mapdata mapDataLayer2 = Game->LoadTempScreen(3);
      Audio->PlayEnhancedMusic(NULL, 0);
      
      for (int i = 0; i < 300; ++i) {
         unless (gameframe % 120)
            Audio->PlaySound(SFX_WATER_DRIPPING);
         
         Waitframe();
      }
      
      this->Data = COMBO_RIGHT_HAND_DOWN;
      
      for (int i = 0; i < 48; ++i) {
         unless (gameframe % 120)
            Audio->PlaySound(SFX_WATER_DRIPPING);
            
         ++this->Y;
         Waitframe();
      }
      
      for (int i = 0; i < 15; ++i) {
         unless (gameframe % 120)
            Audio->PlaySound(SFX_WATER_DRIPPING);
         Waitframe();
      }
      
      Audio->PlaySound(SFX_SHUTTER_OPEN);
      mapDataLayer2->ComboD[61] = COMBO_INVIS;
      mapDataLayer2->ComboD[62] = COMBO_INVIS;
      mapDataLayer1->ComboD[77] = COMBO_INVIS;
      mapDataLayer1->ComboD[78] = COMBO_INVIS;
      
      for (int i = 0; i < 32; ++i) {
         unless (gameframe % 120)
            Audio->PlaySound(SFX_WATER_DRIPPING);
            
         ++this->Y;
         Waitframe();
      }
      
      this->Data = COMBO_RIGHT_HAND_UP;
      
      for (int i = 0; i < 15; ++i) {
         unless (gameframe % 120)
            Audio->PlaySound(SFX_WATER_DRIPPING);
         Waitframe();
      }
      
      Audio->PlaySound(SFX_SHUTTER_CLOSE);
      mapDataLayer2->ComboD[61] = COMBO_UPPER_GATE;
      mapDataLayer2->ComboD[62] = COMBO_UPPER_GATE;
      mapDataLayer1->ComboD[77] = COMBO_LOWER_GATE;
      mapDataLayer1->ComboD[78] = COMBO_LOWER_GATE;
      
      this->Data = COMBO_RIGHT_HAND_LEFT;
      
      for (int i = 0; i < 192; ++i) {
         unless (gameframe % 120)
            Audio->PlaySound(SFX_WATER_DRIPPING);
            
         --this->X;
         Waitframe();
      }
      
      this->Data = COMBO_RIGHT_HAND_UP;
      Screen->Message(253);
      Waitframe();
      
      Audio->PlaySound(SFX_SHUTTER_OPEN);
      mapDataLayer2->ComboD[50] = COMBO_INVIS;
      mapDataLayer1->ComboD[66] = COMBO_INVIS;
      
      for (int i = 0; i < 15; ++i) {
         unless (gameframe % 120)
            Audio->PlaySound(SFX_WATER_DRIPPING);
         Waitframe();
      }
      
      Screen->Message(254);
      Waitframe();
      
      this->Data = COMBO_RIGHT_HAND_RIGHT;
      
      for (int i = 0; i < 192; ++i) {
         disableLink();
         
         unless (gameframe % 120)
            Audio->PlaySound(SFX_WATER_DRIPPING);
            
         ++this->X;
         Waitframe();
      }
      
      this->Data = COMBO_RIGHT_HAND_UP;
      
      for (int i = 0; i < 15; ++i) {
         unless (gameframe % 120)
            Audio->PlaySound(SFX_WATER_DRIPPING);
         Waitframe();
      }
      
      Audio->PlaySound(SFX_SHUTTER_OPEN);
      mapDataLayer2->ComboD[61] = COMBO_INVIS;
      mapDataLayer2->ComboD[62] = COMBO_INVIS;
      mapDataLayer1->ComboD[77] = COMBO_INVIS;
      mapDataLayer1->ComboD[78] = COMBO_INVIS;
      
      for (int i = 0; i < 32; ++i) {
         unless (gameframe % 120)
            Audio->PlaySound(SFX_WATER_DRIPPING);
            
         --this->Y;
         Waitframe();
      }
      
      this->Data = COMBO_RIGHT_HAND_DOWN;
      
      for (int i = 0; i < 15; ++i) {
         unless (gameframe % 120)
            Audio->PlaySound(SFX_WATER_DRIPPING);
         Waitframe();
      }
      
      Audio->PlaySound(SFX_SHUTTER_CLOSE);
      mapDataLayer2->ComboD[61] = COMBO_UPPER_GATE;
      mapDataLayer2->ComboD[62] = COMBO_UPPER_GATE;
      mapDataLayer1->ComboD[77] = COMBO_LOWER_GATE;
      mapDataLayer1->ComboD[78] = COMBO_LOWER_GATE;
      
      this->Data = COMBO_RIGHT_HAND_UP;
      
      for (int i = 0; i < 48; ++i) {
         unless (gameframe % 120)
            Audio->PlaySound(SFX_WATER_DRIPPING);
         
         --this->Y;
         Waitframe();
      }
      
      this->Data = COMBO_INVIS;
      setScreenD(0, true);
      
      if (getScreenD(0)) {
         this->Data = COMBO_INVIS;
         
         while(true) {
            unless (gameframe % 120)
               Audio->PlaySound(SFX_WATER_DRIPPING);
               
            Waitframe();            
         }
      }
   }
}

ffc script FallingStalagtites {
   void run(int xSpeed, int ySpeed, int duration) {
      if (Screen->State[ST_SECRET]) {
         this->Data = 0;
         Quit();
      }
         
      until (Screen->State[ST_SECRET])
         Waitframe();
         
      for (int i = 0; i < duration; ++i) {
         if (xSpeed)
            this->X += (i *= xSpeed);
         if (ySpeed)
            this->Y += (i *= ySpeed);
         
         Waitframe();
      }
      
      Quit();
   }
}

ffc script GraveKeeperSequence {
   void run(int messageImWarningYou, int messageMad, int messageDontKillMe, int messageLeavePls, int messageSad, int messageThankful) {
      int originalCombo = this->Data;
      mapdata map = Game->LoadMapData(20, 0x37);
      
      while (Hero->Item[17]) {
         waitForTalking(this);        
         
         Input->Button[CB_SIGNPOST] = false;
         Game->Suspend[susptSCREENDRAW] = true;
         Screen->Message(messageThankful);
         Game->Suspend[susptSCREENDRAW] = false;
         Waitframe();
      }
      
      until(map->State[ST_SECRET]) {
         waitForTalking(this);        
         
         Input->Button[CB_SIGNPOST] = false;
         Game->Suspend[susptSCREENDRAW] = true;
         Screen->Message(messageImWarningYou);
         Game->Suspend[susptSCREENDRAW] = false;
         Waitframe();
      } 
      else {
         unless (Hero->Item[155]) {
            Screen->Message(messageMad);
            Waitframe();
            
            this->Data = COMBO_INVIS;
            mapdata template = Game->LoadTempScreen(1);
            template->ComboD[ComboAt(this->X, this->Y)] = COMBO_INVIS;
            
            npc enemy = Screen->CreateNPC(ENEMY_GRAVE_KEEPER_GONE_APE);
            enemy->X = this->X;
            enemy->Y = this->Y;
            
            this->X = 0;
            this->Y = 0;
            int lastX, lastY;
            
            while (Screen->NumNPCs()) {
               lastX = enemy->X;
               lastY = enemy->Y;
               Waitframe();
            }
               
            this->X = lastX;
            this->Y = lastY;
            
            this->Data = originalCombo;
            Screen->Message(messageDontKillMe);
            Waitframe();
            
            while(true) {
               waitForTalking(this);        
               
               Input->Button[CB_SIGNPOST] = false;
               Game->Suspend[susptSCREENDRAW] = true;
               Screen->Message(messageLeavePls);
               Game->Suspend[susptSCREENDRAW] = false;
               Waitframe();
            }
         } 
         else {
            Screen->Message(messageSad);
            Waitframe();
            Hero->Item[155] = false;
            
            itemsprite it = CreateItemAt(17, Hero->X, Hero->Y);
            it->Pickup = IP_HOLDUP;
            
            while(true) {
               waitForTalking(this);        
               
               Input->Button[CB_SIGNPOST] = false;
               Game->Suspend[susptSCREENDRAW] = true;
               Screen->Message(messageThankful);
               Game->Suspend[susptSCREENDRAW] = false;
               Waitframe();
            }
         }
      }
   }
}







