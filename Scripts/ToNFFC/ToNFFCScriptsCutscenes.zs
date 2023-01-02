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
         Waitframe();
         
         if (timer == timeUntilWarp) {
            disableLink();
            Screen->Message(message);
            Waitframe();
            
            for (int i = 0; i < 240; ++i) {
               if (i % 60 == 0) {
                  Screen->Quake = 20;
                  Audio->PlaySound(SFX_ROCKINGSHIP);
               }
               
               Waitframe();
            }
            
            Screen->Message(message + 1);
            Waitframe();
            
            Hero->WarpEx({WT_IWARPOPENWIPE, dmap, scr, -1, WARP_A, WARPEFFECT_WAVE, 0, 0, DIR_UP});
         }
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
ffc script IntroLeavingIsleOfHaeren {
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
      Hero->Item[26] = false;
      
      Audio->PlayEnhancedMusic(NULL, 0);
      
      for (int i = 0; i < 120; ++i) {
         disableLink();
         Screen->FastCombo(2, 240 - i, 128, 6743, 0, OP_OPAQUE);
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
         Screen->FastCombo(2, 120, 128, 6743, 0, OP_OPAQUE);
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
         Screen->FastCombo(2, 120, 128, 6743, 0, OP_OPAQUE);
         Screen->FastCombo(1, 120, 128, 6742, 0, OP_OPAQUE);
         Screen->DrawTile(0, -16, 48, 45760, 9, 6, 0, -1, -1, 0, 0, 0, 0, 1, 128);
         Waitframe();
      }
      
      Audio->PlaySound(SFX_ROAR);
      
      Screen->Message(Hero->Item[183] ? 49 : 53);
      
      for(int i = 0; i < 60; ++i) {
         disableLink();
         Screen->FastCombo(2, 120, 128, 6743, 0, OP_OPAQUE);
         Screen->FastCombo(1, 120, 128, 6742, 0, OP_OPAQUE);
         Screen->DrawTile(0, -16 - 0.125, 48, 45760, 9, 6, 0, -1, -1, 0, 0, 0, 0, 1, 128);
         Waitframe();
      }

      int x, x2;
      
      //Charging
      for (int i = 0; i < 120; ++i) {		
         disableLink();
         
         if (i < 80) {
            Screen->FastCombo(2, 120, 128, 6743, 0, OP_OPAQUE);
            Screen->FastCombo(1, 120, 128, 6742, 0, OP_OPAQUE);
         }
         
         Screen->DrawTile(0, -16 + (i * 2), 48, 45760, 9, 6, 0, -1, -1, 0, 0, 0, 0, 1, 128);		
         
         if (i == 10) {
            int side = -1;
            
            x = side == -1 ? -32 : 144;
            x2 = x + 32 * side;
            
            for(i = 0; i < 64; ++i) {
               disableLink();
               Screen->FastCombo(2, 120, 128, 6743, 0, OP_OPAQUE);
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
ffc script IntroFinalMessageBeforeIsleOfHaeren {
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
    
    void notDuringCutsceneLink() {    
      Hero->Stun = 999;
      Link->PressStart = false;
      Link->InputStart = false;
      Link->PressMap = false;
      Link->InputMap = false;
   }
}





















