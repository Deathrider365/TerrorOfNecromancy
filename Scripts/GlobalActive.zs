//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Global Active ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

// clang-format off
@Author("Deathrider365")
global script Init {
   // clang-format off

	void run() {
      giveStartingCrap();
	}
}

// clang-format off
@Author("EmilyV99, Moosh, Deathrider365")
global script GlobalScripts {
   // clang-format on

   void run() {
      if (DEBUG)
         debug();

      int map = -1, dmap = -1, screen = -1;

      LinkMovement_Init();
      StartGhostZH();
      DifficultyGlobal_Init();

      Game->MaxLWeapons(1024);
      Game->MaxEWeapons(1024);

      mapdata mapData[6];

      int footprintArray[3] = {1, 0, 0};

      Hero->HurtSound = getHeroHitSound();

      int ocarinaIndex = 1;

      while (true) {
         gameframe = (gameframe + 1) % 3600;

         checkDungeon();

         LinkMovement_Update1();
         UpdateGhostZH1();

         DifficultyGlobal_Update();
         DifficultyGlobal_EnemyUpdate();

         setupTransparentLayers();
         Waitdraw();

         Screen->DrawOrigin = DRAW_ORIGIN_SPRITE;
         Screen->DrawOriginTarget = Hero;
         // Put draws that I want at link's position here, the origin becomes his upper left pixel
         // use Screen->Draw stuff. 0,0 should draw at the top-left of the player.

         CONFIG GREY_BUBBLE_JINX_COMBO = 6896;
         CONFIG RED_BUBBLE_JINX_COMBO = 6897;

         if (Hero->SwordJinx < 0) {
            Screen->DrawCombo(SPLAYER_PLAYER_DRAW, 0, 0, RED_BUBBLE_JINX_COMBO, 1, 1, 0, -1, -1, 0, 0, 0, 0, FLIP_NONE, true, OP_TRANS);
         }
         else if (Hero->SwordJinx) {
            Screen->DrawCombo(SPLAYER_PLAYER_DRAW, 0, 0, GREY_BUBBLE_JINX_COMBO, 1, 1, 0, -1, -1, 0, 0, 0, 0, FLIP_NONE, true, OP_TRANS);
         }

         Screen->DrawOrigin = DRAW_ORIGIN_DEFAULT; // restore.

         drawRadialTransparency(mapData);

         checkFootprints(footprintArray);

         if (map != Game->CurMap || screen != Game->CurScreen) {
            map = Game->CurMap;
            screen = Game->CurScreen;
            onScreenChange(mapData);
         }

         if (dmap != Game->CurDMap) {
            dmap = Game->CurDMap;
            onDMapChange();
         }

         LinkMovement_Update2();
         UpdateGhostZH2();

         BoomerangNerf();

         Waitframe();
      }
   }

   void setupTransparentLayers() {
      int layers = getTransLayers(Game->CurDMap, Game->CurScreen);

      for (int l = 1; l < 6; ++l) {
         unless(layers & (1b << (l - 1))) continue;
         Screen->LayerInvisible[l] = (HeroIsScrollingOrWarping() || disableTrans) ? false : true;
      }

      return;
   }

   void drawRadialTransparency(mapdata[] mapData) {
      CONFIG TRANS_RADIUS = 36;

      unless(IsValidArray(mapData)) return;

      int layers = getTransLayers(Game->CurDMap, Game->CurScreen);

      for (int l = 1; l < 6; ++l) {
         unless(layers & (1b << (l - 1))) continue;
         unless(mapData[l]) continue;

         overheadBitmaps[l]->Clear(0);

         for (int q = 0; q < 176; ++q) {
            if (HeroIsScrollingOrWarping())
               overheadBitmaps[l]->FastCombo(l, ComboX(q) + Game->Scrolling[SCROLL_NX], ComboY(q) + Game->Scrolling[SCROLL_NY], mapData[l]->ComboD[q], mapData[l]->ComboC[q], OP_OPAQUE);
            else {
               combodata cmb = Game->LoadComboData(mapData[l]->ComboD[q]);
               if (!(cmb->AnimFlags & AF_TRANSPARENT))
                  overheadBitmaps[l]->FastCombo(l, ComboX(q), ComboY(q), cmb->ID, mapData[l]->ComboC[q], OP_OPAQUE);
            }
         }

         if (HeroIsScrollingOrWarping())
            overheadBitmaps[l]->Circle(l, Hero->X + 8 + Game->Scrolling[SCROLL_NX], Hero->Y + 8 + Game->Scrolling[SCROLL_NY], TRANS_RADIUS, 0, 1, 0, 0, 0, true, OP_OPAQUE);
         else
            overheadBitmaps[l]->Circle(l, Hero->X + 8, Hero->Y + 8, TRANS_RADIUS, 0, 1, 0, 0, 0, true, OP_OPAQUE);

         for (int q = 0; q < 176; ++q) {
            if (HeroIsScrollingOrWarping())
               Screen->FastCombo(l, ComboX(q) + Game->Scrolling[SCROLL_NX], ComboY(q) + Game->Scrolling[SCROLL_NY], mapData[l]->ComboD[q], mapData[l]->ComboC[q], OP_TRANS);
            else
               Screen->FastCombo(l, ComboX(q), ComboY(q), mapData[l]->ComboD[q], mapData[l]->ComboC[q], OP_TRANS);
         }

         overheadBitmaps[l]->Blit(l, -1, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
      }
   }

   void onScreenChange(mapdata[] mapData) {
      disableTrans = false;
      int layers = getTransLayers(Game->CurDMap, Game->CurScreen);

      for (int l = 1; l < 6; ++l) {
         unless(overheadBitmaps[l]->isValid()) overheadBitmaps[l] = create(256, 176);

         overheadBitmaps[l]->Clear(0);

         unless(layers & (1b << (l - 1))) continue;

         Screen->LayerInvisible[l] = true;

         mapData[l] = Game->LoadTempScreen(l);
      }

      if (Screen->Palette != lastPal) {
         lastPal = Screen->Palette;

         for (int i = 0; i <= MAX_USED_DMAP; ++i)
            Game->LoadDMapData(i)->Palette = Screen->Palette;
      }
   }

   // 654321b
   int getTransLayers(int dmap, int screen) {
      switch (dmap) {
         case 4:
            switch (screen) {
               case 0x26: return 011000b;
               case 0x38:
               case 0x39: return 001000b;
            }
            break;
         case 5:
            switch (screen) {
               case 0x1c: return 000100;
               case 0x33: return 000100;
               case 0x63: return 000100;
            }
            break;
         case 6:
            switch (screen) {
               case 0x08:
               case 0x17: return 000100b;
            }
            break;
         case 9:
            switch (screen) {
               case 0x76: return 001000b;
            }
         case 14:
            switch (screen) {
               case 0x0E: return 001000b;
               case 0x0D: return 001000b;
               case 0x0B: return 011000b;
               case 0x0A: return 011000b;
               case 0x2B: return 011000b;
            }
            break;
         case 15:
            switch (screen) {
               case 0x04: return 011100;
               case 0x55: return 000100;
            }
            break;

         case 21:
            switch (screen) {
               case 0x77: return 000100;
            }
            break;
         case 31:
            switch (screen) {
               case 0x4A:
               case 0x7C:
               case 0x5D: return 001000b;
            }
            break;
         case 32:
            switch (screen) {
               case 0x06: return 011000b;
               case 0x07: return 001100b;
            }
            break;
            break;
         case 34:
            switch (screen) {
               case 0x20:
               case 0x21: return 011000b;
            }
            break;
         case 35:
            switch (screen) {
               case 0x5B: return 000100;
            }
            break;
         case 36:
            switch (screen) {
               case 0x76: return 001000b;
            }
            break;
         case 39:
            switch (screen) {
               case 0x7C: return 011100b;
            }
            break;
         case 43:
            switch (screen) {
               case 0x0F: return 001000b;
            }
            break;
         case 47:
            switch (screen) {
               case 0x35: return 000100b;
            }
            break;
         case 49:
            switch (screen) {
               case 0x41: return 000100b;
            }
         case 50:
            switch (screen) {
               case 0x02: return 000100b;
            }
            break;
         case 59:
            switch (screen) {
               case 0x76: return 000100b;
               case 0x77: return 001000b;
            }
            break;
         case 69:
            switch (screen) {
               case 0x22: return 000100b;
            }
            break;
         case 70:
            switch (screen) {
               case 0x4D: return 000100b;
               case 0x1E: return 001000b;
               case 0x2E: return 001000b;
               case 0x58: return 001000b;
               case 0x59: return 001000b;
            }
            break;
         case 71:
            switch (screen) {
               case 0x45: return 001000b;
               case 0x35: return 000100b;
            }
            break;
         case 73:
            switch (screen) {
               case 0x34: return 000100b;
               case 0x44: return 011000b;
               case 0x46: return 011100b;
            }
            break;
      }
      return 0;
   }

   void checkFootprints(int[] footprints) {
      int fadeMult = getFadeMult();

      unless(fadeMult) fadeMult = 1;

      if (!HeroIsScrolling() && Hero->Action == LA_WALKING && ((footprints[1] == Hero->X && footprints[2] == Hero->Y) ? false : true)) {
         footprints[1] = Hero->X;
         footprints[2] = Hero->Y;

         unless(--footprints[0]) {
            int pos = ComboAt(Link->X + 4, Link->Y + 4);
            int comboT = Screen->ComboT[pos];

            for (int i = 1; i < 3; ++i)
               if (Screen->LayerMap[i]) {
                  mapdata mapData = Game->LoadTempScreen(i);

                  if (mapData->ComboD[pos])
                     comboT = mapData->ComboT[pos];
               }

            if (comboT == CT_FOOTPRINT)
               createFootprint(fadeMult);

            footprints[0] = 12;
         }
      }
   }

   int getFadeMult() {
      switch (Game->CurDMap) {
         // Smaller value quicker decay
         case 1: return 1;
         case 3: return 2;
         case 4: return 1;
         case 5...6: return 2;
         case 7: {
            mapdata mapData = Game->LoadMapData(9, 0x62);
            return mapData->State[ST_SECRET] ? 1 : .2;
         }
         case 8: return 1;
         case 9: return .2;
         case 10...13: return 1;
         case 14: return .2;
         case 15...16: return 1;
         case 18...23: return 2;
         case 21: return 1;
         case 22...23: return 3;
         case 30...31: return 2;
         case 32: return 1;
         case 35: return 1;
         case 36: return 2;
         case 37: return 1;
         case 38: return 1;
         case 39: return .75;
         case 40: return 1;
         case 48: return 3;
         case 49: return 1;
         case 50...52: return 2;
         case 57: return .75;
         case 58: return .75;
         case 60: return 1.5;
         case 61...62: return .5;
         case 71: return 3;
         case 73: return 2;
         case 74: return 2;
      }

      return 0;
   }

   void createFootprint(int fadeMult) {
      if (int scr = CheckLWeaponScript("CustomSparkle")) {
         lweapon footprint = RunLWeaponScriptAt(LW_SCRIPT1, scr, Hero->X, Hero->Y, {SPR_FOOTSTEP, fadeMult});
         footprint->Behind = true;
         footprint->Dir = Hero->Dir;
         footprint->ScriptTile = TILE_INVIS;
         footprint->CollDetection = false;
      }
   }

   void onDMapChange() {
   }

   void checkDungeon() {
      int level = Game->CurLevel;
      unless(Game->LItems[level] & LI_MAP) {
         Link->InputMap = false;
         Link->PressMap = false;
      }
   }

   // Author - Jamien
   void BoomerangNerf() {
      for (int i = 1; i <= Screen->NumNPCs; ++i) {
         npc enem = Screen->LoadNPC(i);

         if (STUN_DURATION > 0 && enem->Stun > STUN_DURATION)
            enem->Stun = STUN_DURATION;
      }
   }

   void debug() {
      Game->Cheat = 4;
   }
}

// clang-format off
@Author("EmilyV99, Deathrider365")
global script OnLaunch {
   // clang-format off

   void run() {
      lastPal = -1;
      subscreenYOffset = -232;
      subscreenOpen = false;

      setGameOverMenu(C_TAN, C_BLACK, C_RED, MIDI_GAMEOVER);

      // Makes these combos' invisible (dont make these combos animate)
      for (cid : { 7302 }) {
         Game->LoadComboData(cid)->OriginalTile = TILE_INVIS;
      }

      // For debug purposes because test builds start you with nothing on a or b
      if (Debug->Testing) {
         Hero->ItemA = GetHighestLevelItemOwned(IC_SWORD);
         Hero->ItemB = GetHighestLevelItemOwned(IC_BRANG);
      }

      if (onContHP != 0) {
         Hero->HP = onContHP;
         Hero->MP = onContMP;
      } else {
         Hero->HP = Hero->MaxHP;
         Hero->MP = Hero->MaxMP;
      }
   }
}

// clang-format off
@Author("Deathrider365")
global script onF6Menu {
   // clang-format off

   void run() {
      onContHP = Hero->HP;
      onContMP = Hero->MP;

      if (SizeOfArray(stolenLinkItems))
         for (int i = 0; i < SizeOfArray(stolenLinkItems); ++i)
            Hero->Item[stolenLinkItems[i]] = true;
   }
}

// clang-format off
@Author("Deathrider365")
global script onContGame {
   // clang-format off

   void run() {
      subscreenYOffset = -232;

      if(onContHP != 0) {
         Hero->HP = onContHP;
         Hero->MP = onContMP;
      } else {
         Hero->HP = Hero->MaxHP;
         Hero->MP = Hero->MaxMP;
      }

      if (SizeOfArray(stolenLinkItems))
         for (int i = 0; i < SizeOfArray(stolenLinkItems); ++i)
            Hero->Item[stolenLinkItems[i]] = true;
   }
}

// clang-format off
@Author("Deathrider365")
global script onSave {
   // clang-format off

   void run() {
      if (SizeOfArray(stolenLinkItems))
         for (int i = 0; i < SizeOfArray(stolenLinkItems); ++i)
            Hero->Item[stolenLinkItems[i]] = true;
   }
}

// clang-format off
@Author("Deathrider365")
global script onSaveLoad {
   // clang-format off

   void run() {
      if (auriVillageMusicSet) {
         dmapdata dm = Game->LoadDMapData(Game->GetDMap("NEI Auri Village"));
         dm->SetMusic("Final Fantasy VII - Desert Wasteland.ogg");
      }
   }
}

// clang-format off
@Author("Deathrider365")
global script onExit {
   // clang-format off

   void run() {

   }
}