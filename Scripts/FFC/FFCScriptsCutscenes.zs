//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Cutscene FFCs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

// clang-format off
@Author("Deathrider365")
ffc script IntroAwaitingLeviathan {
   // clang-format on

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
            Hero->WarpEx(WT_IWARPOPENWIPE, dmap, scr, -1, WARP_A, WARPEFFECT_WAVE, 0, WARP_FLAG_NONE, DIR_UP);
         }

         Waitframe();
      }
   }
}

// clang-format off
@Author ("Deathrider365")
ffc script IntroLeviathanFightFail {
   // clang-format on

   void run(int dmap, int screen) {
      loop () {
         if (Hero->HP <= 0) {
            Hero->HP = 1;
            Hero->Warp(dmap, screen);
         }
         Waitframe();
      }
   }
}

// clang-format off
@Author ("Deathrider365")
ffc script IntroLeviathanFailDialogue {
   // clang-format on

   void run(int dmap, int scrn, int message) {
      Screen->Message(message);
      Audio->PlayEnhancedMusic(NULL, 0);

      for (int i = 0; i < 120; ++i) {
         disableLink();
         Screen->DrawTile(0, 50, 32, 45760, 9, 6, 0, -1, -1, 0, 0, 0, 0, 1, 128);
         Waitframe();
      }

      Hero->WarpEx(WT_IWARPOPENWIPE, dmap, scrn, -1, WARP_A, WARPEFFECT_WAVE, 0, WARP_FLAG_NONE, DIR_UP);
   }
}

// clang-format off
@Author ("Deathrider365")
ffc script IntroLeviathanEnding {
   // clang-format on

   using namespace LeviathanNamespace;

   void run(int dmap, int scrn, int initialMessage, int secondaryMessage) {
      Audio->PlayEnhancedMusic("Final Fantasy IV - Bomb Ring.ogg", 0);

      waterfallBitmap = new bitmap(32, 176);
      UpdateWaterfallBitmap();

      Hero->Dir = DIR_UP;
      disableLink();

      Screen->Message(initialMessage);

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

      Screen->Message(secondaryMessage);

      // Buffer
      for (int i = 0; i < 30; ++i) {
         disableLink();
         Screen->DrawTile(0, 16, -11, 45760, 9, 6, 0, -1, -1, 0, 0, 0, 0, 1, 128);
         Waitframe();
      }

      Hero->HP = Hero->MaxHP;

      // Falling
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

      Waitframes(12);

      Hero->WarpEx(WT_IWARPOPENWIPE, dmap, scrn, -1, WARP_A, WARPEFFECT_NONE, 0, WARP_FLAG_NONE, DIR_UP);
   }
}

// clang-format off
@Author ("Deathrider365")
ffc script IntroEndOfOpeningScene {
   // clang-format on

   void run(int dmap, int scr, int message) {
      for (int i = 0; i < 120; ++i) {
         Audio->PlayEnhancedMusic(NULL, 0);
         disableLink();
         Waitframe();
      }

      // disableLink();
      // Screen->Message(message);
      // Waitframe();
      Hero->WarpEx(WT_IWARPBLACKOUT, dmap, scr, -1, WARP_A, WARPEFFECT_WAVE, 0, WARP_FLAG_NONE, DIR_DOWN);
   }
}

// clang-format off
@Author ("Deathrider365")
ffc script IntroLeavingIoH {
   // clang-format on

   void run() {
      loop() {
         if (Hero->X < 5) {
            unless(getScreenD(0)) {
               setScreenD(0, true);
               Hero->WarpEx(WT_IWARPBLACKOUT, 0, 80, -1, WARP_A, WARPEFFECT_WAVE, 0, WARP_FLAG_NONE, DIR_UP);
            }
         }
         else
            Hero->Action = LA_RAFTING;

         Waitframe();
      }
   }
}

// clang-format off
@Author ("Deathrider365")
ffc script IntroPreInteritusLeviathanScene {
   // clang-format on

   using namespace LeviathanNamespace;

   void run() {
      Hero->Item[ITEM_RAFT_ANCIENT_HERO] = false;

      Audio->PlayEnhancedMusic(NULL, 0);

      for (int i = 0; i < 120; ++i) {
         disableLink();
         Screen->FastCombo(3, 240 - i, 132, 6271, 0, OP_TRANS);
         Screen->FastCombo(2, 240 - i, 122, 6743, 0, OP_OPAQUE);
         Screen->FastCombo(1, 240 - i, 128, 6742, 0, OP_OPAQUE);
         Waitframe();
      }

      Audio->PlayEnhancedMusic("Final Fantasy IV - Bomb Ring.ogg", 0);
      waterfallBitmap = new bitmap(32, 176);
      UpdateWaterfallBitmap();
      Hero->Dir = DIR_UP;

      // Rising
      for (int i = 0; i < 180; ++i) {
         disableLink();
         Screen->FastCombo(3, 120, 132, 6271, 0, OP_TRANS);
         Screen->FastCombo(2, 120, 122, 6702, 0, OP_OPAQUE);
         Screen->FastCombo(1, 120, 128, 6742, 0, OP_OPAQUE);
         Screen->DrawTile(0, -16, 228 - i, 45760, 9, 6, 0, -1, -1, 0, 0, 0, 0, 1, 128);
         Waitframe();

         if (i % 40 == 0) {
            Audio->PlaySound(SFX_ROCKINGSHIP);
            Screen->Quake = 20;
         }

         Waitframe();
      }

      // The leviathan pauses
      for (int i = 0; i < 120; ++i) {
         disableLink();
         Screen->FastCombo(3, 120, 132, 6271, 0, OP_TRANS);
         Screen->FastCombo(2, 120, 122, 6702, 0, OP_OPAQUE);
         Screen->FastCombo(1, 120, 128, 6742, 0, OP_OPAQUE);
         Screen->DrawTile(0, -16, 48, 45760, 9, 6, 0, -1, -1, 0, 0, 0, 0, 1, 128);
         Waitframe();
      }

      Audio->PlaySound(SFX_ROAR);

      Screen->Message(Hero->Item[183] ? 43 : 47);

      for (int i = 0; i < 60; ++i) {
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

            for (i = 0; i < 64; ++i) {
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

// clang-format off
@Author("Deathrider365")
ffc script IntroFinalMessageBeforeIoH {
   // clang-format on

   void run(int message) {
      Audio->PlayEnhancedMusic(NULL, 0);
      // Screen->Message(message);
      leavingTransition(12, 80, 0);
   }
}

// clang-format off
@Author("Deathrider365")
ffc script OfficialIntroPresents {
   // clang-format on

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

      for (int i = 0; i < 120; ++i) {
         disableLink();
         Screen->DrawTile(6, 24, 24, 42406, 13, 3, 0, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
         Waitframe();
      }

      leavingTransition(12, 96, 1);
   }
}

// clang-format off
@Author("Deathrider365")
ffc script OfficialIntroMovie {
   // clang-format on

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

// clang-format off
@Author("Deathrider365")
ffc script OfficialIntroFinalScene {
   // clang-format on

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

// clang-format off
@Author ("Deathrider365")
ffc script ComingFromIsleOfHaeren {
   // clang-format on

   void run() {
      while (true) {
         if (Hero->X == 240 && Hero->Y == 80)
            Hero->Action = LA_RAFTING;

         Waitframe();
      }
   }
}

// clang-format off
@Author ("Moosh")
ffc script DifficultyChoice {
   // clang-format on

   void run() {
      for (int i = 0; i < 20; ++i) {
         notDuringCutsceneLink();
         Screen->Rectangle(7, 0, 0, 256, 176, C_BLACK, 1, 0, 0, 0, true, OP_OPAQUE);
         Waitframe();
      }

      enteringTransition();

      bool cursor = false;

      while (true) {
         notDuringCutsceneLink();

         Screen->FastTile(7, 96, !cursor ? 96 : 112, 46675, 0, OP_OPAQUE);

         if (Input->Press[CB_DOWN] || Input->Press[CB_UP]) {
            Audio->PlaySound(SFX_CURSOR_MOVEMENT);
            cursor = !cursor;
         }

         if (Input->Press[CB_A]) {
            Hero->Item[!cursor ? ITEM_DIFF_NORMAL : ITEM_DIFF_VERYHARD] = true;
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
            Hero->Stun = 0;
            Hero->WarpEx(WT_IWARP, 5, 0x3E, -1, WARP_B, WARPEFFECT_WAVE, 0, WARP_FLAG_NONE, DIR_RIGHT);
         }

         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script CapturedSequenceImprisioned {
   // clang-format on

   CONFIG SCREEND_SEQUENCE_DONE = 0;
   CONFIG SCREEND_SEQUENCE_ESCAPE_RETRY_LOOP = 1;
   CONFIG SCREEND_BEAT_FIRST_SCREEN_ENEMIES = 2;

   void run() {
      dmapdata dmapData = Game->LoadDMapData(Game->CurDMap);
      mapdata mapDataLayer1 = Game->LoadTempScreen(1);
      mapdata mapDataLayer3 = Game->LoadTempScreen(3);
      int thisData = this->Data;
      this->Data = CMB_INVIS;

      if (getScreenD(24, 0x33, SCREEND_SEQUENCE_DONE))
         Quit();
      if (getScreenD(SCREEND_BEAT_FIRST_SCREEN_ENEMIES)) {
         dmapData->Music->SetPath("Castlevania Lament of Innocence-Elemental Tactician.ogg");
         Quit();
      }

      int soldierCombo1X = 224;
      int soldierCombo2X = 224;
      this->Data = thisData;

      if (getScreenD(SCREEND_SEQUENCE_ESCAPE_RETRY_LOOP) || Screen->State[ST_SECRET]) {
         soldierCombo1X = 176;
         soldierCombo2X = 192;

         mapDataLayer1->ComboD[98] = 7288;
         mapDataLayer3->ComboD[82] = 7284;
         mapDataLayer1->ComboD[125] = 7011;
         this->Data = 7015;
         this->X = 144;
         this->Y = 112;
         dmapData->Music->SetPath("Castlevania 64 - Setting.ogg");
         Audio->PlayEnhancedMusic("Castlevania 64 - Setting.ogg", 0);
      }
      else {
         falseZeldaGotcha(this, mapDataLayer1, mapDataLayer3, soldierCombo1X, soldierCombo2X);
      }

      int counter = 600;
      soldierCombo1X = 176;
      soldierCombo2X = 192;

      // Wait for Link to act
      if (!getScreenD(SCREEND_SEQUENCE_ESCAPE_RETRY_LOOP)) {
         while (Hero->Y < 100) {
            Screen->FastCombo(1, soldierCombo1X, 112, 7014, 7, OP_OPAQUE);
            Screen->FastCombo(1, soldierCombo2X, 112, 7014, 7, OP_OPAQUE);

            if (!counter)
               necromancerWalksIn(this, mapDataLayer1, mapDataLayer3, soldierCombo1X, soldierCombo2X);

            --counter;
            Waitframe();
         }
      }

      linkAttemptsToBreakOut(this, dmapData, mapDataLayer1, soldierCombo1X, soldierCombo2X);
   }

   void falseZeldaGotcha(ffc this, mapdata mapDataLayer1, mapdata mapDataLayer3, int soldierCombo1X, int soldierCombo2X) {
      until(Hero->X < 48 && Hero->Y < 48) Waitframe();

      Audio->PlayEnhancedMusic(NULL, 0);
      disableLink();
      Audio->PlaySound(SFX_SHUTTER_CLOSE);
      mapDataLayer1->ComboD[98] = 7288;
      mapDataLayer3->ComboD[82] = 7284;

      for (int i = 0; i < 45; ++i) {
         disableLink();
         Waitframe();
      }

      Screen->Message(241);

      for (int i = 0; i < 30; ++i) {
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

      for (int i = 0; i < 4; ++i) {
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

   void linkAttemptsToBreakOut(ffc this, dmapdata dmapData, mapdata mapDataLayer1, int soldierCombo1X, int soldierCombo2X, ) {
      if (!getScreenD(SCREEND_SEQUENCE_ESCAPE_RETRY_LOOP)) {
         this->Data = 7014;
         Audio->PlayEnhancedMusic(NULL, 0);

         Screen->Message(243);
         Screen->FastCombo(1, soldierCombo1X, 112, 7014, 7, OP_OPAQUE);
         Screen->FastCombo(1, soldierCombo2X, 112, 7014, 7, OP_OPAQUE);
         Waitframe();

         setScreenD(SCREEND_SEQUENCE_ESCAPE_RETRY_LOOP, true);
      }

      dmapData->Music->SetPath("Castlevania Lament of Innocence-Elemental Tactician.ogg");
      Audio->PlayEnhancedMusic("Castlevania Lament of Innocence-Elemental Tactician.ogg", 0);

      if (!getScreenD(SCREEND_BEAT_FIRST_SCREEN_ENEMIES)) {
         this->Data = CMB_INVIS;
         npc soldier1 = Screen->CreateNPC(ENEMY_SOLDIER_LEVEL2_HALTED);
         soldier1->X = 176;
         soldier1->Y = 112;
         npc soldier2 = Screen->CreateNPC(ENEMY_SOLDIER_LEVEL2_HALTED);
         soldier2->X = 192;
         soldier2->Y = 112;
         npc soldier3 = Screen->CreateNPC(ENEMY_SOLDIER_LEVEL2_HALTED);
         soldier3->X = this->X;
         soldier3->Y = this->Y;

         while (Screen->NumNPCs)
            Waitframe();

         Audio->PlaySound(SFX_OOT_SECRET);
         mapDataLayer1->ComboD[125] = 7007;
         setScreenD(SCREEND_BEAT_FIRST_SCREEN_ENEMIES, true);
      }
   }

   void necromancerWalksIn(ffc this, mapdata mapDataLayer1, mapdata mapDataLayer3, int soldierCombo1X, int soldierCombo2X) {
      disableLink();
      mapDataLayer1->ComboD[125] = 7007;
      Audio->PlayEnhancedMusic("Final Fantasy VII - Those Chosen by the Planet.ogg", 0);
      this->Data = 7015;

      for (int i = 0; i < 60; ++i) {
         disableLink();
         Screen->FastCombo(1, soldierCombo1X, 112, 7015, 7, OP_OPAQUE);
         Screen->FastCombo(1, soldierCombo2X, 112, 7015, 7, OP_OPAQUE);
         Waitframe();
      }

      Audio->PlaySound(SFX_SHUTTER_OPEN);
      mapDataLayer1->ComboD[102] = CMB_INVIS;
      mapDataLayer1->ComboD[105] = CMB_INVIS;
      mapDataLayer1->ComboD[109] = CMB_INVIS;
      mapDataLayer3->ComboD[86] = CMB_INVIS;
      mapDataLayer3->ComboD[93] = CMB_INVIS;

      this->Data = 7014;
      int solderCombo1Y = 112;
      int solderCombo2Y = 112;

      CONFIG COMBO_NECROMANCER_LEFT = 6799;
      CONFIG COMBO_NECROMANCER_UP = 6744;
      CONFIG COMBO_RIGHT_HAND_LEFT = 6802;
      int necromancerStartX = 224;
      int rightHandStartX = 224;

      for (int i = 0; i < 432; ++i) {
         disableLink();
         if (i < 16) {
            this->X -= 1;
            Screen->FastCombo(1, soldierCombo1X -= 1, solderCombo1Y, 7014, 7, OP_OPAQUE);
            Screen->FastCombo(1, soldierCombo2X += 1, solderCombo2Y, 7015, 7, OP_OPAQUE);
         }
         else if (i < 32) {
            this->X -= 1;
            Screen->FastCombo(1, soldierCombo1X -= 1, solderCombo1Y, 7014, 7, OP_OPAQUE);
            Screen->FastCombo(1, soldierCombo2X, solderCombo2Y -= 1, 7013, 7, OP_OPAQUE);
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
         else if (i < 224) {
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

      Screen->FastCombo(1, soldierCombo1X, solderCombo1Y, 7013, 7, OP_OPAQUE);
      Screen->FastCombo(1, soldierCombo2X, solderCombo2Y, 7013, 7, OP_OPAQUE);
      Screen->FastCombo(1, necromancerStartX, 112, COMBO_NECROMANCER_UP, 7, OP_OPAQUE);
      Screen->FastCombo(1, rightHandStartX, 112, COMBO_RIGHT_HAND_LEFT, 7, OP_OPAQUE);

      Screen->Message(250);
      Waitframe();

      setScreenD(SCREEND_SEQUENCE_DONE, true);
      Hero->WarpEx(WT_IWARP, 104, 0x12, -1, WARP_A, WARPEFFECT_WAVE, 0, WARP_FLAG_NONE, DIR_RIGHT);
   }
}

// clang-format off
@Author("Deathrider365")
ffc script CapturedSequenceEscape {
   // clang-format on
   CONFIG SCREEND_SEQUENCE_DONE = 0;
   CONFIG SCREEND_SEQUENCE_ESCAPE_RETRY_LOOP = 1;

   void run(int screenNumber) {
      if (!getScreenD(33, 0x23, SCREEND_SEQUENCE_ESCAPE_RETRY_LOOP) || getScreenD(screenNumber))
         Quit();

      mapdata mapDataLayer1 = Game->LoadTempScreen(1);
      int comboPos;

      npc soldier1 = Screen->CreateNPC(ENEMY_SOLDIER_LEVEL2_HALTED);
      npc soldier2 = Screen->CreateNPC(ENEMY_SOLDIER_LEVEL2_HALTED);

      switch (screenNumber) {
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

      while (Screen->NumNPCs) {
         mapDataLayer1->ComboD[comboPos] = 7011;
         Waitframe();
      }

      Audio->PlaySound(SFX_OOT_SECRET);
      setScreenD(screenNumber, true);
      mapDataLayer1->ComboD[comboPos] = 7007;
   }
}

// clang-format off
@Author("Deathrider365")
ffc script CapturedSequenceNecromancer {
   // clang-format on

   //Carried forward from the other scripts related to this (this script may not use all of those, these are a reference)
   CONFIG SCREEND_SEQUENCE_DONE = 0;
   CONFIG SCREEND_SEQUENCE_ESCAPE_RETRY_LOOP = 1;
   CONFIG SCREEND_BEAT_FIRST_SCREEN_ENEMIES = 2;
   CONFIG SCREEND_BEAT_ENEMIES_ON_LAST_SCREEN = 3;

   void run() {
      //Only run this script when the sequence is not done and the last enemies screen screed was set
      if (getScreenD(SCREEND_SEQUENCE_DONE) || !getScreenD(33, 0x33, SCREEND_BEAT_ENEMIES_ON_LAST_SCREEN)) {
         dmapdata dmapDataForThis = Game->LoadDMapData(Game->CurDMap);
         dmapDataForThis->Music->SetPath("FFIV - Baron Castle.ogg");
         //Setting the neutral music for the dungeons now if the whole necromancer sequence is already done
         dmapdata dmapData = Game->LoadDMapData(33);
         dmapData->Music->SetPath("Castlevania 64 - Setting.ogg");
         Quit();
      }

      dmapdata dmapData = Game->LoadDMapData(Game->CurDMap);
      dmapData->Music->SetPath("Castlevania Lament of Innocence-Elemental Tactician.ogg");

      CONFIG COMBO_NECROMANCER = 6744;
      CONFIG COMBO_RIGHT_HAND = 6753;
      CONFIG COMBO_GUARD = 6755;
      CONFIG COMBO_LEFT_BARRIER = 6981;
      CONFIG COMBO_RIGHT_BARRIER = 6977;
      CONFIG COMBO_TOP_BARRIER = 6973;

      mapdata mapData = Game->LoadTempScreen(1);

      Input->DisableKey[KEY_F6] = true;

      mapData->ComboD[12] = COMBO_TOP_BARRIER;

      mapData->ComboD[64] = COMBO_LEFT_BARRIER;
      mapData->ComboD[80] = COMBO_LEFT_BARRIER;
      mapData->ComboD[96] = COMBO_LEFT_BARRIER;

      mapData->ComboD[79] = COMBO_RIGHT_BARRIER;
      mapData->ComboD[95] = COMBO_RIGHT_BARRIER;
      mapData->ComboD[111] = COMBO_RIGHT_BARRIER;
      Audio->PlaySound(SFX_SHUTTER_CLOSE);

      until(Hero->X > 96 && Hero->X < 160 && Hero->Y >= 128)
         Waitframe();

      if (Hero->X > 96 && Hero->X < 160 && Hero->Y > 144) {
         Hero->X = 120;
         Hero->Y = 128;
      }

      Audio->PlayEnhancedMusic("Final Fantasy VII - Those Chosen by the Planet.ogg", 0);

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

         unless(i % 5) Hero->Y -= 1;

         unless(i % 4) Screen->FastCombo(1, 120, necromancerStartY -= 1, COMBO_NECROMANCER, 0, OP_OPAQUE);

         if (i % 5 == 0 && necromancerStartY < 160)
            Screen->FastCombo(1, 120, rightHandStartY -= 1, COMBO_RIGHT_HAND, 0, OP_OPAQUE);

         if (i >= 120 && i % 8 == 0) {
            ++leftGuardX;
            --rightGuardX;
         }

         Screen->FastCombo(1, 120, necromancerStartY, COMBO_NECROMANCER, 0, OP_OPAQUE);
         Screen->FastCombo(1, 120, rightHandStartY, COMBO_RIGHT_HAND, 0, OP_OPAQUE);

         Waitframe();
      }

      Screen->FastCombo(1, 120, necromancerStartY, COMBO_NECROMANCER, 0, OP_OPAQUE);
      Screen->FastCombo(1, 120, rightHandStartY, COMBO_RIGHT_HAND, 0, OP_OPAQUE);


      Screen->Message(244);
      Waitframe();

      Screen->FastCombo(1, 120, necromancerStartY, COMBO_NECROMANCER, 0, OP_OPAQUE);
      Screen->FastCombo(1, 120, rightHandStartY, COMBO_RIGHT_HAND, 0, OP_OPAQUE);

      Screen->Message(257);
      Waitframe();

      bool chose = false;
      bool cursorOnYes = true;
      int message = 251;

      until(chose) { // TODO make this do something
         notDuringCutsceneLink();

         Screen->FastTile(7, cursorOnYes ? 80 : 128, 16, 46675, 0, OP_OPAQUE);

         if (Input->Press[CB_LEFT] || Input->Press[CB_RIGHT]) {
            Audio->PlaySound(SFX_CURSOR_MOVEMENT);
            cursorOnYes = !cursorOnYes;
         }

         if (Input->Press[CB_A]) {
            Audio->PlaySound(cursorOnYes ? 139 : 140);
            message = cursorOnYes ? 252 : 251;

            for (int i = 0; i < 30; ++i) {
               Screen->FastTile(7, 96, 16, cursorOnYes ? 46696 : 46676, 0, OP_OPAQUE);
               Screen->FastTile(7, 112, 16, cursorOnYes ? 46697 : 46677, 0, OP_OPAQUE);
               Screen->FastTile(7, 144, 16, cursorOnYes ? 46678 : 46698, 0, OP_OPAQUE);

               Screen->FastCombo(1, 120, necromancerStartY, COMBO_NECROMANCER, 0, OP_OPAQUE);
               Screen->FastCombo(1, 120, rightHandStartY, COMBO_RIGHT_HAND, 0, OP_OPAQUE);

               Waitframe();
            }
            chose = true;
         }

         Screen->FastTile(7, 96, 16, cursorOnYes ? 46696 : 46676, 0, OP_OPAQUE);
         Screen->FastTile(7, 112, 16, cursorOnYes ? 46697 : 46677, 0, OP_OPAQUE);
         Screen->FastTile(7, 144, 16, cursorOnYes ? 46678 : 46698, 0, OP_OPAQUE);

         Screen->FastCombo(1, 120, necromancerStartY, COMBO_NECROMANCER, 0, OP_OPAQUE);
         Screen->FastCombo(1, 120, rightHandStartY, COMBO_RIGHT_HAND, 0, OP_OPAQUE);

         Waitframe();
      }

      Screen->FastCombo(1, 120, necromancerStartY, COMBO_NECROMANCER, 0, OP_OPAQUE);
      Screen->FastCombo(1, 120, rightHandStartY, COMBO_RIGHT_HAND, 0, OP_OPAQUE);

      Screen->Message(message);
      Waitframe();

      for (int i = 0; i < 30; ++i) {
         unless(i % 2) {
            --necromancerStartY;
            --rightHandStartY;
            ++leftGuardX;
            --rightGuardX;
         }

         Screen->FastCombo(1, 120, necromancerStartY, COMBO_NECROMANCER, 0, OP_OPAQUE);
         Screen->FastCombo(1, 120, rightHandStartY, COMBO_RIGHT_HAND, 0, OP_OPAQUE);

         Waitframe();
      }

      Hero->Stun = 0;
      Input->DisableKey[KEY_F6] = false;
      setScreenD(SCREEND_SEQUENCE_DONE, true);
      setScreenD(33, 0x23, SCREEND_SEQUENCE_DONE, true);
      Hero->WarpEx(WT_IWARP, 104, 0x12, -1, WARP_A, WARPEFFECT_WAVE, 0, WARP_FLAG_NONE, DIR_RIGHT);
   }
}

// clang-format off
@Author("Deathrider365")
ffc script CapturedSequenceRightHand {
   // clang-format on

   CONFIG COMBO_UPPER_GATE = 7284;
   CONFIG COMBO_LOWER_GATE = 7288;
   CONFIG COMBO_UPSIDE_DOWN_GATE_TOP = 7231;
   CONFIG COMBO_UPSIDE_DOWN_GATE = 7234;

   CONFIG COMBO_RIGHT_HAND_UP = 6800;
   CONFIG COMBO_RIGHT_HAND_DOWN = 6801;
   CONFIG COMBO_RIGHT_HAND_LEFT = 6802;
   CONFIG COMBO_RIGHT_HAND_RIGHT = 6803;

   void run() {
      if (getScreenD(0)) {
         this->Data = CMB_INVIS;
         mapdata mapDataLayer1 = Game->LoadTempScreen(1);
         mapdata mapDataLayer3 = Game->LoadTempScreen(3);
         mapDataLayer3->ComboD[50] = CMB_INVIS;
         mapDataLayer1->ComboD[66] = CMB_INVIS;

         Game->LastEntranceDMap = Game->CurDMap;
         Game->LastEntranceScreen = Game->CurScreen;
         Game->ContinueDMap = Game->CurDMap;
         Game->ContinueScreen = Game->CurScreen;

         while (true) {
            unless(gameframe % 120) Audio->PlaySound(SFX_WATER_DRIPPING);

            Waitframe();
         }
      }

      mapdata mapDataLayer1 = Game->LoadTempScreen(1);
      mapdata mapDataLayer3 = Game->LoadTempScreen(3);
      Audio->PlayEnhancedMusic(NULL, 0);

      for (int i = 0; i < 300; ++i) {
         unless(gameframe % 120) Audio->PlaySound(SFX_WATER_DRIPPING);

         Waitframe();
      }

      this->Data = COMBO_RIGHT_HAND_UP;
      this->Y = 176;

      //Entering the room
      for (int i = 0; i < 48; ++i) {
         unless(gameframe % 120) Audio->PlaySound(SFX_WATER_DRIPPING);

         --this->Y;
         Waitframe();
      }

      //Pause at the gate
      for (int i = 0; i < 15; ++i) {
         unless(gameframe % 120) Audio->PlaySound(SFX_WATER_DRIPPING);
         Waitframe();
      }

      //Open the gate
      Audio->PlaySound(SFX_SHUTTER_OPEN);
      mapDataLayer1->ComboD[125] = CMB_INVIS;
      mapDataLayer1->ComboD[126] = CMB_INVIS;
      mapDataLayer3->ComboD[141] = CMB_INVIS;
      mapDataLayer3->ComboD[142] = CMB_INVIS;

      //Walking through the open gate
      for (int i = 0; i < 32; ++i) {
         unless(gameframe % 120) Audio->PlaySound(SFX_WATER_DRIPPING);

         --this->Y;
         Waitframe();
      }

      this->Data = COMBO_RIGHT_HAND_DOWN;

      //Close the gate
      for (int i = 0; i < 15; ++i) {
         unless(gameframe % 120) Audio->PlaySound(SFX_WATER_DRIPPING);
         Waitframe();
      }

      Audio->PlaySound(SFX_SHUTTER_CLOSE);
      mapDataLayer1->ComboD[125] = COMBO_UPSIDE_DOWN_GATE;
      mapDataLayer1->ComboD[126] = COMBO_UPSIDE_DOWN_GATE;
      mapDataLayer3->ComboD[141] = COMBO_UPSIDE_DOWN_GATE_TOP;
      mapDataLayer3->ComboD[142] = COMBO_UPSIDE_DOWN_GATE_TOP;

      this->Data = COMBO_RIGHT_HAND_LEFT;

      //Walking left
      for (int i = 0; i < 184; ++i) {
         unless(gameframe % 120) Audio->PlaySound(SFX_WATER_DRIPPING);

         --this->X;
         Waitframe();
      }

      this->Data = COMBO_RIGHT_HAND_UP;

      //Walk up to Link's cell
      for (int i = 0; i < 16; ++i) {
         unless(gameframe % 120) Audio->PlaySound(SFX_WATER_DRIPPING);

         --this->Y;
         Waitframe();
      }

      Screen->Message(253);
      Waitframe();

      //Open Link's cell
      Audio->PlaySound(SFX_SHUTTER_OPEN);
      mapDataLayer1->ComboD[66] = CMB_INVIS;
      mapDataLayer3->ComboD[50] = CMB_INVIS;

      //Pause after opening Link's cell
      for (int i = 0; i < 15; ++i) {
         unless(gameframe % 120) Audio->PlaySound(SFX_WATER_DRIPPING);
         Waitframe();
      }

      Screen->Message(254);
      Waitframe();

      this->Data = COMBO_RIGHT_HAND_DOWN;

      //Walk down from Link's cell
      for (int i = 0; i < 16; ++i) {
         unless(gameframe % 120) Audio->PlaySound(SFX_WATER_DRIPPING);

         ++this->Y;
         Waitframe();
      }

      this->Data = COMBO_RIGHT_HAND_RIGHT;

      //Walk to the right
      for (int i = 0; i < 184; ++i) {
         disableLink();

         unless(gameframe % 120) Audio->PlaySound(SFX_WATER_DRIPPING);

         ++this->X;
         Waitframe();
      }

      this->Data = COMBO_RIGHT_HAND_DOWN;

      //Pause at the gate
      for (int i = 0; i < 15; ++i) {
         unless(gameframe % 120) Audio->PlaySound(SFX_WATER_DRIPPING);
         Waitframe();
      }

      //Open the gate
      Audio->PlaySound(SFX_SHUTTER_OPEN);
      mapDataLayer3->ComboD[141] = CMB_INVIS;
      mapDataLayer3->ComboD[142] = CMB_INVIS;
      mapDataLayer1->ComboD[125] = CMB_INVIS;
      mapDataLayer1->ComboD[126] = CMB_INVIS;

      //Walk through open gate
      for (int i = 0; i < 32; ++i) {
         unless(gameframe % 120) Audio->PlaySound(SFX_WATER_DRIPPING);

         ++this->Y;
         Waitframe();
      }

      this->Data = COMBO_RIGHT_HAND_UP;

      //Pause at the gate
      for (int i = 0; i < 15; ++i) {
         unless(gameframe % 120) Audio->PlaySound(SFX_WATER_DRIPPING);
         Waitframe();
      }

      //Close the gate
      Audio->PlaySound(SFX_SHUTTER_CLOSE);
      mapDataLayer1->ComboD[125] = COMBO_UPSIDE_DOWN_GATE;
      mapDataLayer1->ComboD[126] = COMBO_UPSIDE_DOWN_GATE;
      mapDataLayer3->ComboD[141] = COMBO_UPSIDE_DOWN_GATE_TOP;
      mapDataLayer3->ComboD[142] = COMBO_UPSIDE_DOWN_GATE_TOP;

      this->Data = COMBO_RIGHT_HAND_DOWN;

      //Leave the room
      for (int i = 0; i < 48; ++i) {
         unless(gameframe % 120) Audio->PlaySound(SFX_WATER_DRIPPING);

         ++this->Y;
         Waitframe();
      }

      this->Data = CMB_INVIS;
      setScreenD(0, true);

      if (getScreenD(0)) {
         this->Data = CMB_INVIS;

         while (true) {
            unless(gameframe % 120) Audio->PlaySound(SFX_WATER_DRIPPING);

            Waitframe();
         }
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script FallingStalagtites {
   // clang-format on

   void run(int xSpeed, int ySpeed, int duration, int doesDamage) {
      if (Screen->State[ST_SECRET]) {
         this->Data = 0;
         Quit();
      }

      until(Screen->State[ST_SECRET]) Waitframe();

      eweapon eWeapon;
      lweapon lWeapon;

      if (doesDamage) {
         eWeapon = CreateEWeaponAt(EW_SCRIPT1, this->X, this->Y);
         eWeapon->Damage = doesDamage;
         eWeapon->X = this->X;
         eWeapon->Y = this->Y;
         eWeapon->HitHeight = 32;
         eWeapon->DrawYOffset = -1000;
         eWeapon->Unblockable = UNBLOCK_ALL;

         lWeapon = CreateLWeaponAt(EW_SCRIPT1, this->X, this->Y);
         lWeapon->Damage = doesDamage;
         lWeapon->X = this->X;
         lWeapon->Y = this->Y;
         lWeapon->HitHeight = 32;
         lWeapon->DrawYOffset = -1000;
         lWeapon->Unblockable = UNBLOCK_ALL;
      }

      Screen->Quake = 20;
      Audio->PlaySound(SFX_ROCKINGSHIP);

      for (int i = 0; i < duration; ++i) {
         if (xSpeed) {
            this->X += (i *= xSpeed);

            if (eWeapon->isValid()) {
               eWeapon->X = this->X;
               lWeapon->X = this->X;
            }
         }
         if (ySpeed) {
            this->Y += (i *= ySpeed);

            if (lWeapon->isValid()) {
               eWeapon->Y = this->Y;
               lWeapon->Y = this->Y;
            }
         }

         Waitframe();
      }

      // eWeapon->DeadState = WDS_DEAD;
      lWeapon->DeadState = WDS_DEAD;

      Quit();
   }
}

// clang-format off
@Author("Deathrider365")
ffc script GraveKeeperSequence {
   // clang-format on

   void run(int messageImWarningYou, int messageMad, int messageDontKillMe, int messageLeavePls, int messageSad, int messageThankful) {
      int originalCombo = this->Data;
      mapdata graveScreen = Game->LoadMapData(20, 0x37);

      while (Hero->Item[ITEM_RING1]) {
         waitForTalking(this);
         Screen->Message(messageThankful);
         Waitframe();
      }

      until(graveScreen->State[ST_SECRET]) {
         waitForTalking(this);
         Screen->Message(messageImWarningYou);
         Waitframe();
      }
      else {
         unless(Hero->Item[ITEM_STRANGE_COFFER]) {
            Screen->Message(messageMad);
            Waitframe();

            this->Data = CMB_INVIS;
            this->Flags[FFCF_SOLID] = false;

            npc enemy = Screen->CreateNPC(ENEMY_GRAVE_KEEPER_GONE_APE);
            enemy->X = this->X;
            enemy->Y = this->Y;

            this->X = 0;
            this->Y = 0;
            int lastX, lastY;

            while (Screen->NumNPCs) {
               lastX = enemy->X;
               lastY = enemy->Y;
               Waitframe();
            }

            this->X = lastX;
            this->Y = lastY;

            this->Data = originalCombo;
            this->Flags[FFCF_SOLID] = true;
            Screen->Message(messageDontKillMe);
            Waitframe();

            while (true) {
               waitForTalking(this);
               Screen->Message(messageLeavePls);
               Waitframe();
            }
         }
         else {
            Waitframes(60);
            Screen->Message(messageSad);
            Waitframe();
            Hero->Item[ITEM_STRANGE_COFFER] = false;

            itemsprite it = CreateItemAt(ITEM_RING1, Hero->X, Hero->Y);
            it->Pickup = IP_HOLDUP;

            while (true) {
               waitForTalking(this);
               Screen->Message(messageThankful);
               Waitframe();
            }
         }
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script GoddessFaithfulZeldaScenes {
   CONFIG screenD0 = 0;
   CONFIG screenD1 = 1;
   CONFIG screenD2 = 2;
   CONFIG screenD3 = 3;

   CONFIG HYLIAN_GENERAL_COMBO = 5507;
   CONFIG SERVUS_SOLDIER = 5523;
   CONFIG SEIZED_TOWER_GUARD = 5523;
   CONFIG CARULEM_ZORA = 5809;
   CONFIG DURATU_GORON = 5818;
   CONFIG DURATU_GORON_HAIR = 5814;
   CONFIG CONFLATOS_NEPHEW = 5850;

   void run() {
      if (Screen->State[ST_SECRET]) {
         this->Flags[FFCF_SOLID] = false;
         this->Data = CMB_INVIS;
         Quit();
      }

      mapdata mapDataBeatQuickknife = Game->LoadMapData(66, 0x23);
      mapdata mapDataBeatGamoth = Game->LoadMapData(75, 0x22);
      mapdata mapDataBombRoom = Game->LoadMapData(16, 0x55);
      mapdata mapDataAuriVillageSaved = Game->LoadMapData(9, 0x62);
      mapdata mapDataBeatLvl8 = Game->LoadMapData(152, 0x2A);

      loop () {
         waitForTalking(this);

         if (mapDataBeatQuickknife->State[ST_SECRET] && !mapDataBeatGamoth->State[ST_SECRET])
            zeldaIntroDialogue();
         if (mapDataBeatGamoth->State[ST_SECRET] && !mapDataBombRoom->State[ST_SECRET])
            zeldaGetGiantBombsDialogue();
         if (mapDataBombRoom->State[ST_SECRET] && !mapDataAuriVillageSaved->State[ST_SECRET] && !mapDataBeatLvl8->State[ST_SECRET])
            zeldaGivesMagicOcarina();
         if (mapDataAuriVillageSaved->State[ST_SECRET] && !mapDataBeatLvl8->State[ST_SECRET])
            zeldaThanksLinkForHelpingAuri();
            //TODO add checks for beating level 6 and 7
         if (mapDataBeatLvl8->State[ST_SECRET])
            zeldaInitiatesTheSiege(this);
         if (!mapDataBeatQuickknife->State[ST_SECRET])
            Screen->Message(448); //oops, you shouldnt be here message

         Waitframe();
      }
   }

   void zeldaIntroDialogue() {
      const int zeldaIntroMessage = 395;
      const int zeldaPostIntroMessage = 390;

      if (!getScreenD(screenD0)) {
         setScreenD(screenD0, true);
         Screen->Message(zeldaIntroMessage);
         Waitframe();
         Audio->PlaySound(SFX_SECRET);
      }
      else
         Screen->Message(zeldaPostIntroMessage);
   }

   void zeldaGetGiantBombsDialogue() {
      const int zeldaIntroMessage = 404;
      const int zeldaPostIntroMessage = 562;

      if (!getScreenD(screenD1)) {
         setScreenD(screenD1, true);

         setScreenD(7, true);
         setScreenD(8, true);

         Screen->Message(zeldaIntroMessage);
         Waitframe();
      }
      else
         Screen->Message(zeldaPostIntroMessage);
   }

   void zeldaGivesMagicOcarina() {
      const int zeldaIntroMessage = 441;
      const int zeldaPostIntroMessage = 443;

      if (!getScreenD(screenD2)) {
         setScreenD(screenD2, true);
         Screen->Message(zeldaIntroMessage);
         Waitframe();

         itemsprite it = CreateItemAt(ITEM_OCARINA2, Hero->X, Hero->Y);
         it->Pickup = IP_HOLDUP;
      }
      else
         Screen->Message(zeldaPostIntroMessage);
   }

   void zeldaThanksLinkForHelpingAuri() {
      const int zeldaIntroMessage = 521;
      const int zeldaPostIntroMessage = 465;
      const int zeldaGettingOcarinaMessage = 441;

      if (!getScreenD(screenD3)) {
         if (!getScreenD(screenD2)) {
            Screen->Message(zeldaGettingOcarinaMessage);
            Waitframe();
            itemsprite it = CreateItemAt(ITEM_OCARINA2, Hero->X, Hero->Y);
            it->Pickup = IP_HOLDUP;
            setScreenD(screenD2, true);
         }

         Screen->Message(zeldaIntroMessage);
         setScreenD(screenD3, true);
      } else {
         Screen->Message(zeldaIntroMessage);
      }
      Waitframe();
   }

   void zeldaInitiatesTheSiege(ffc this) {
      int zeldaIntroMessage = 1244;
      int zeldaOpeningMessage = 1258;
      int zeldaSideQuestMessage = 1260;
      int zeldaSideQuestMessageNonDone = 1272;
      int zeldaBreakDownMessage = 1267;
      int zeldaClosingMessage = 1271;

      bool hylianGeneralTriggered = Game->LoadMapData(16, 0x3A)->State[ST_SECRET];
      bool servusSoldierTriggered = Game->LoadMapData(16, 0x05)->State[ST_SECRET];
      bool seizedTowerSoldierTriggered = Game->LoadMapData(16, 0x4B)->State[ST_SECRET];
      bool duratuElderTriggered = Game->LoadMapData(53, 0x3D)->State[ST_SECRET];
      bool carulemZoraTriggered = Game->LoadMapData(96, 0x21)->State[ST_SECRET];
      bool conflatosNephewTriggered = Game->LoadMapData(53, 0x75)->State[ST_SECRET];

      bool anySideCharacters = hylianGeneralTriggered || servusSoldierTriggered || seizedTowerSoldierTriggered || duratuElderTriggered || carulemZoraTriggered || conflatosNephewTriggered;

      if (!getScreenD(screenD2)) {
         const int zeldaGettingOcarinaMessage = 441;
         Screen->Message(zeldaGettingOcarinaMessage);
         Waitframe();
         itemsprite it = CreateItemAt(ITEM_OCARINA2, Hero->X, Hero->Y);
         it->Pickup = IP_HOLDUP;
         setScreenD(screenD2, true);
      }

      Waitframe();

      Screen->Message(zeldaIntroMessage);
      Waitframe();

      //cut the music
      //play some music here

      if (anySideCharacters)
         sendInThePeople(hylianGeneralTriggered, servusSoldierTriggered, seizedTowerSoldierTriggered, duratuElderTriggered, carulemZoraTriggered, conflatosNephewTriggered);

      Screen->Message(zeldaOpeningMessage);
      Waitframe();

      if (hylianGeneralTriggered || servusSoldierTriggered || seizedTowerSoldierTriggered || duratuElderTriggered || carulemZoraTriggered || conflatosNephewTriggered)
         Screen->Message(zeldaSideQuestMessage);

      Waitframe();

      //Each NPC you got says their piece
      if (hylianGeneralTriggered) {
         Screen->Message(zeldaSideQuestMessage + 1);
         Waitframe();
      }
      if (servusSoldierTriggered) {
         Screen->Message(zeldaSideQuestMessage + 2);
         Waitframe();
      }
      if (seizedTowerSoldierTriggered) {
         Screen->Message(zeldaSideQuestMessage + 3);
         Waitframe();
      }
      if (duratuElderTriggered) {
         Screen->Message(zeldaSideQuestMessage + 4);
         Waitframe();
      }
      if (carulemZoraTriggered) {
         Screen->Message(zeldaSideQuestMessage + 5);
         Waitframe();
      }
      if (conflatosNephewTriggered) {
         Screen->Message(zeldaSideQuestMessage + 6);
         Waitframe();
      }

      Screen->Message(zeldaBreakDownMessage);
      Waitframe();

      if (anySideCharacters)
         sendOutThePeople(hylianGeneralTriggered, servusSoldierTriggered, seizedTowerSoldierTriggered, duratuElderTriggered, carulemZoraTriggered, conflatosNephewTriggered);

      Screen->TriggerSecrets();
      Screen->State[ST_SECRET] = true;
      Audio->PlaySound(SFX_SECRET);

      loop() {
         waitForTalking(this);

         Screen->Message(zeldaClosingMessage);
         Waitframe();
      }
   }

   void sendInThePeople(bool hylianGeneralTriggered, bool servusSoldierTriggered, bool seizedTowerSoldierTriggered, bool duratuElderTriggered, bool carulemZoraTriggered, bool conflatosNephewTriggered) {
      int npcArrayIndex = 0;
      int moveNPCXOffset = 1;
      int moveNPCYOffset = 1;

      int hylianGeneralX = 96;
      int hylianGeneralY = 192;

      int servusSoldierX = 128;
      int servusSoldierY = 208;

      int seizedTowerGuardX = 96;
      int seizedTowerGuardY = 224;

      int carulemZoraX = 128;
      int carulemZoraY = 240;

      int duratuGoronX = 96;
      int duratuGoronY = 256;

      int conflatosNephewX = 128;
      int conflatosNephewY = 272;

      int timer = 330;

      mapdata mapData = Game->LoadTempScreen(2);
      mapdata mapData3 = Game->LoadTempScreen(3);

      while (timer) {
         disableLink();

         if (hylianGeneralTriggered) {
            if (hylianGeneralX == 32 && hylianGeneralY == 64)
               mapData->ComboD[ComboAt(hylianGeneralX, hylianGeneralY)] = HYLIAN_GENERAL_COMBO;
            else if (hylianGeneralY > 64)
               hylianGeneralY -= 1;
            else
               hylianGeneralX -= 1;

            Screen->FastCombo(2, hylianGeneralX, hylianGeneralY, HYLIAN_GENERAL_COMBO, 0, OP_OPAQUE);
         }

         if (servusSoldierTriggered) {
            if (servusSoldierX == 178 && servusSoldierY == 96)
               mapData->ComboD[ComboAt(servusSoldierX, servusSoldierY)] = SERVUS_SOLDIER;
            else if (servusSoldierY > 96)
               servusSoldierY -= 1;
            else
               servusSoldierX += 1;

            Screen->FastCombo(2, servusSoldierX, servusSoldierY, SERVUS_SOLDIER, 0, OP_OPAQUE);
         }

         if (seizedTowerSoldierTriggered) {
            if (seizedTowerGuardX == 48 && seizedTowerGuardY == 32)
               mapData->ComboD[ComboAt(seizedTowerGuardX, seizedTowerGuardY)] = SEIZED_TOWER_GUARD;
            else if (seizedTowerGuardY > 64)
               seizedTowerGuardY -= 1;
            else {
               if (seizedTowerGuardX > 48)
                  seizedTowerGuardX -= 1;
               else
                  seizedTowerGuardY -= 1;
            }

            Screen->FastCombo(2, seizedTowerGuardX, seizedTowerGuardY, SEIZED_TOWER_GUARD, 0, OP_OPAQUE);
         }

         if (carulemZoraTriggered) {
            if (carulemZoraX == 144 && carulemZoraY == 128)
               mapData->ComboD[ComboAt(carulemZoraX, carulemZoraY)] = CARULEM_ZORA;
            else if (carulemZoraY > 128)
               carulemZoraY -= 1;
            else {
               carulemZoraX += 1;
            }

            Screen->FastCombo(2, carulemZoraX, carulemZoraY, CARULEM_ZORA, 0, OP_OPAQUE);
         }

         if (duratuElderTriggered) {
            if (duratuGoronX == 32 && duratuGoronY == 80) {
               mapData->ComboD[ComboAt(duratuGoronX, duratuGoronY)] = DURATU_GORON;
               mapData3->ComboD[ComboAt(duratuGoronX, duratuGoronY - 16)] = DURATU_GORON_HAIR;
            }
            else if (duratuGoronY > 80)
               duratuGoronY -= 1;
            else {
               duratuGoronX -= 1;
            }

            Screen->FastCombo(2, duratuGoronX, duratuGoronY, DURATU_GORON, 0, OP_OPAQUE);
            Screen->FastCombo(3, duratuGoronX, duratuGoronY - 16, DURATU_GORON_HAIR, 0, OP_OPAQUE);
         }

         if (conflatosNephewTriggered) {
            if (conflatosNephewX == 178 && conflatosNephewY == 64)
               mapData->ComboD[ComboAt(conflatosNephewX, conflatosNephewY)] = CONFLATOS_NEPHEW;
            else if (conflatosNephewY > 64)
               conflatosNephewY -= 1;
            else
               conflatosNephewX += 1;

            Screen->FastCombo(2, conflatosNephewX, conflatosNephewY, CONFLATOS_NEPHEW, 0, OP_OPAQUE);
         }

         timer--;
         Waitframe();
      }
   }

   void sendOutThePeople(bool hylianGeneralTriggered, bool servusSoldierTriggered, bool seizedTowerSoldierTriggered, bool duratuElderTriggered, bool carulemZoraTriggered, bool conflatosNephewTriggered) {
      mapdata mapData = Game->LoadTempScreen(2);
      mapdata mapData3 = Game->LoadTempScreen(3);

      if (hylianGeneralTriggered && mapData->ComboD[ComboAt(32, 64)] == HYLIAN_GENERAL_COMBO)
         mapData->ComboD[ComboAt(32, 64)] = CMB_INVIS;

      if (servusSoldierTriggered && mapData->ComboD[ComboAt(178, 96)] == SERVUS_SOLDIER)
         mapData->ComboD[ComboAt(178, 96)] = CMB_INVIS;

      if (seizedTowerSoldierTriggered && mapData->ComboD[ComboAt(48, 32)] == SEIZED_TOWER_GUARD)
         mapData->ComboD[ComboAt(48, 32)] = CMB_INVIS;

      if (carulemZoraTriggered && mapData->ComboD[ComboAt(144, 128)] == CARULEM_ZORA)
         mapData->ComboD[ComboAt(144, 128)] = CMB_INVIS;

      if (duratuElderTriggered && mapData->ComboD[ComboAt(32, 80)] == DURATU_GORON) {
         mapData->ComboD[ComboAt(32, 80)] = CMB_INVIS;
         mapData3->ComboD[ComboAt(32, 80 - 16)] = CMB_INVIS;
      }

      if (conflatosNephewTriggered && mapData->ComboD[ComboAt(178, 64)] == CONFLATOS_NEPHEW)
         mapData->ComboD[ComboAt(178, 64)] = CMB_INVIS;

   }
}

// clang-format off
@Author("Deathrider365")
ffc script SummusTabletPedestal {
// clang-format on

   CONFIG CMB_SHARD_A = 11184;
   CONFIG CMB_SHARD_B = 11185;
   CONFIG CMB_SHARD_C = 11186;
   CONFIG CMB_SHARD_D = 11187;

   void run(int allShardsMessage, int shardAMessage, int shardBMessage, int shardCMessage, int shardDMessage, int noShardMessage, int completedMessage, int needMoreShardsMessage) {
      mapdata mapData1 = Game->LoadTempScreen(1);

      loop() {
         if (getScreenD(0)) {
            mapData1->ComboD[28] = 0;
            mapData1->ComboD[195] = 0;
            waitForReading(this);
            drawAllNecessaryShards();

            Screen->Message(completedMessage);
            Waitframe();
         } else {
            Audio->PlaySound(SFX_SHUTTER_CLOSE);
            int tabletShardCount = 0;

            if (getScreenD(1))
               tabletShardCount++;
            if (getScreenD(2))
               tabletShardCount++;
            if (getScreenD(3))
               tabletShardCount++;
            if (getScreenD(4))
               tabletShardCount++;

            waitForReading(this);

            bool noMoreShardsMessageShouldTrigger = true;

            if (Hero->Item[ITEM_SUMMUS_TABLET_SHARD_A]) {
               if (!getScreenD(1)) {
                  setScreenD(1, true);
                  drawAllNecessaryShards();
                  Screen->Message(shardAMessage);
                  tabletShardCount++;
               } else if (noMoreShardsMessageShouldTrigger) {
                  drawAllNecessaryShards();
                  Screen->Message(needMoreShardsMessage);
                  noMoreShardsMessageShouldTrigger = false;
               }

               Waitframe();
            }
            if (Hero->Item[ITEM_SUMMUS_TABLET_SHARD_B]) {
               if (!getScreenD(2)) {
                  setScreenD(2, true);
                  drawAllNecessaryShards();
                  Screen->Message(shardBMessage);
                  tabletShardCount++;
               } else if (noMoreShardsMessageShouldTrigger) {
                  drawAllNecessaryShards();
                  Screen->Message(needMoreShardsMessage);
                  noMoreShardsMessageShouldTrigger = false;
               }

               Waitframe();
            }
            if (Hero->Item[ITEM_SUMMUS_TABLET_SHARD_C]) {
               if (!getScreenD(3)) {
                  setScreenD(3, true);
                  drawAllNecessaryShards();
                  Screen->Message(shardCMessage);
                  tabletShardCount++;
               } else if (noMoreShardsMessageShouldTrigger) {
                  drawAllNecessaryShards();
                  Screen->Message(needMoreShardsMessage);
                  noMoreShardsMessageShouldTrigger = false;
               }

               Waitframe();
            }
            if (Hero->Item[ITEM_SUMMUS_TABLET_SHARD_D]) {
               if (!getScreenD(4)) {
                  setScreenD(4, true);
                  drawAllNecessaryShards();
                  Screen->Message(shardDMessage);
                  tabletShardCount++;
               } else if (noMoreShardsMessageShouldTrigger) {
                  drawAllNecessaryShards();
                  Screen->Message(needMoreShardsMessage);
                  noMoreShardsMessageShouldTrigger = false;
               }

               Waitframe();
            }

            if (tabletShardCount == 4) {
               drawAllNecessaryShards();
               Screen->Message(allShardsMessage);
               Screen->Quake = 120;

               mapData1->ComboD[28] = 11176;
               mapData1->ComboD[195] = 11176;
               Audio->PlaySound(SFX_SHUTTER_OPEN);

               Audio->PlaySound(SFX_SECRET);
               setScreenD(0, true);
            } else if (tabletShardCount == 0) {
               Screen->Message(noShardMessage);
            }
         }

         drawAllNecessaryShards();
         Waitframe();
      }
   }

   void waitForReading(ffc this) {
      until(againstFFC(this->X, this->Y, true) && Input->Press[CB_SIGNPOST]) {
         if (againstFFC(this->X, this->Y, true)) {
            Screen->FastCombo(7, Link->X - 10, Link->Y - 15, 48, 0, OP_OPAQUE);
            Input->Button[CB_SIGNPOST] = false;
         }

         drawAllNecessaryShards();

         Waitframe();
      }

   }

   void drawAllNecessaryShards() {
      if (getScreenD(1))
         Screen->FastCombo(1, 240, 32, CMB_SHARD_A, 0, OP_OPAQUE);
      if (getScreenD(2))
         Screen->FastCombo(1, 240, 32, CMB_SHARD_B, 0, OP_OPAQUE);
      if (getScreenD(3))
         Screen->FastCombo(1, 256, 32, CMB_SHARD_C, 0, OP_OPAQUE);
      if (getScreenD(4))
         Screen->FastCombo(1, 256, 32, CMB_SHARD_D, 0, OP_OPAQUE);
   }
}
