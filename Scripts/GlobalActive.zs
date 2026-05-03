//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Global Active ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

// clang-format off
@Author("Deathrider365")
global script Init {
   // clang-format off

	void run() {

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
      bitmap overheadBitmaps[7];

      int footprintArray[3] = {1, 0, 0};

      int flipperPower;
      int breathCounter;

      if (Hero->Item[ITEM_FLIPPERS1] || Hero->Item[ITEM_FLIPPERS2]) {
         flipperPower = Game->LoadItemData(GetHighestLevelItemOwned(IC_FLIPPERS))->Power;
         breathCounter = flipperPower;
      }

      loop () {
         gameframe = (gameframe + 1) % 3600;

         onContHP = Hero->HP;
         onContMP = Hero->MP;

         Hero->HurtSound = getHeroHitSound();

         checkDungeon();
         checkMagicCharge();
         checkHeartCharge();

         LinkMovement_Update1();
         UpdateGhostZH1();

         DifficultyGlobal_Update();
         DifficultyGlobal_EnemyUpdate();

         setupTransparentLayers();
         Waitdraw();

         fall();

         if (Hero->Item[ITEM_FLIPPERS1] || Hero->Item[ITEM_FLIPPERS2]) {
            unless (Hero->Item[ITEM_JEWEL_OF_MARRE]) {
               flipperPower = Game->LoadItemData(GetHighestLevelItemOwned(IC_FLIPPERS))->Power;

               if (isUnderWater())
                  --breathCounter;
               else
                  breathCounter = flipperPower;

               if (breathCounter <= 0)
                  hurtDatHero(60, 2);
            }
         }

         giveGoddessJewel();

         Screen->DrawOrigin = DRAW_ORIGIN_SPRITE;
         Screen->DrawOriginTarget = Hero;
         // Put draws that I want at link's position here, the origin becomes his upper left pixel
         // use Screen->Draw stuff. 0,0 should draw at the top-left of the player.

         CONFIG GREY_BUBBLE_JINX_COMBO = 6896;
         CONFIG RED_BUBBLE_JINX_COMBO = 6897;

         if (Hero->SwordJinx < 0)
            Screen->FastCombo(SPLAYER_PLAYER_DRAW, 0, 0, RED_BUBBLE_JINX_COMBO, 1, OP_TRANS);
         else if (Hero->SwordJinx)
            Screen->FastCombo(SPLAYER_PLAYER_DRAW, 0, 0, GREY_BUBBLE_JINX_COMBO, 1, OP_TRANS);

         Screen->DrawOrigin = DRAW_ORIGIN_DEFAULT; // restore.

         drawRadialTransparency(mapData, overheadBitmaps);

         checkFootprints(footprintArray);

         if (map != Game->CurMap || screen != Game->CurScreen) {
            map = Game->CurMap;
            screen = Game->CurScreen;
            onScreenChange(mapData, overheadBitmaps);
         }

         if (dmap != Game->CurDMap) {
            dmap = Game->CurDMap;
            onDMapChange();
         }

         if (Hero->Item[ITEM_EXPANSION_BOMB])
            Hero->Item[ITEM_EXPANSION_BOMB] = false;
         if (Hero->Item[ITEM_EXPANSION_QUIVER])
            Hero->Item[ITEM_EXPANSION_QUIVER] = false;

         LinkMovement_Update2();
         UpdateGhostZH2();

         BoomerangNerf();

         Waitframe();
      }
   }

   bool isUnderWater() { //TODO something still breaks link from drowning
      switch(Hero->Action) {
         case LA_DIVING:
         case LA_SIDESWIM:
         case LA_SIDESWIMHIT:
         case LA_SIDESWIMATTACKING:
         case LA_HOLD1SIDESWIM:
         case LA_HOLD2SIDESWIM:
         case LA_SIDESWIMCASTING:
         case LA_SIDESWIMFROZEN:
         case LA_SIDESWIMSPINNING:
         case LA_SIDESWIMCHARGING:
            return true;
      }

      return false;
   }

   void giveGoddessJewel() {
      //TODO add cutscene to this
      if (Game->Counter[CR_TRIFORCE_OF_COURAGE] == 4 && !Hero->Item[ITEM_FARORES_WIND]) {
         Waitframes(15);
         Screen->Message(773);
         Waitframe();
         CreateItemAt(ITEM_FARORES_WIND, Hero->X, Hero->Y);
      }
      if (Game->Counter[CR_TRIFORCE_OF_POWER] == 4 && !Hero->Item[ITEM_DINS_FIRE]) {
         Waitframes(15);
         Screen->Message(774);
         Waitframe();
         CreateItemAt(ITEM_DINS_FIRE, Hero->X, Hero->Y);
      }
      if (Game->Counter[CR_TRIFORCE_OF_WISDOM] == 4 && !Hero->Item[ITEM_NAYRUS_LOVE]) {
         Waitframes(15);
         Screen->Message(775);
         Waitframe();
         CreateItemAt(ITEM_NAYRUS_LOVE, Hero->X, Hero->Y);
      }
      if (Game->Counter[CR_TRIFORCE_OF_DEATH] == 4 && !Hero->Item[ITEM_DEATHS_AURA]) {
         Waitframes(15);
         Screen->Message(776);
         Waitframe();
         CreateItemAt(ITEM_DEATHS_AURA, Hero->X, Hero->Y);
      }
   }

   void checkMagicCharge() {
      int[] magicRings = { ITEM_MAGIC_RING1, ITEM_MAGIC_RING2, ITEM_MAGIC_RING3, ITEM_MAGIC_RING4, ITEM_MAGIC_RING5 };

      if (Hero->Item[ITEM_MAGIC_RING1])
         Hero->Item[magicRings[Game->Counter[CR_MAGIC_RING_SHARDS]]] = true;
   }

   void checkHeartCharge() {
      int[] heartRings = { ITEM_HEART_RING1, ITEM_HEART_RING2, ITEM_HEART_RING3, ITEM_HEART_RING4, ITEM_HEART_RING5 };

      if (Hero->Item[ITEM_HEART_RING1])
         Hero->Item[heartRings[Game->Counter[CR_HEART_RING_SHARDS]]] = true;
   }

   void fall() {
      //Pit warp constants
      CONFIG WARPS_LINK = 1;
      CONFIG DIRECT_WARP = 2;
      if (Hero->Falling == 1) {
         combodata combo = Game->LoadComboData(Hero->FallCombo);
         if (combo->UserFlags & WARPS_LINK) {
               if (combo->UserFlags & DIRECT_WARP)
                  Hero->Z = Hero->Y;
         }
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

   void drawRadialTransparency(mapdata[] mapData, bitmap[] overheadBitmaps) {
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

   void onScreenChange(mapdata[] mapData, bitmap[] overheadBitmaps) {
      disableTrans = false;
      int layers = getTransLayers(Game->CurDMap, Game->CurScreen);

      for (int l = 1; l < 6; ++l) {
         unless(overheadBitmaps[l]->isValid()) overheadBitmaps[l] = create(256, 176);

         overheadBitmaps[l]->Clear(0);

         unless(layers & (1b << (l - 1))) continue;

         Screen->LayerInvisible[l] = true;

         mapData[l] = Game->LoadTempScreen(l);
      }
   }

   // 654321b
   int getTransLayers(int dmap, int screen) {
      switch (dmap) {
         case 0:  //Isle of Haeren
            switch (screen) {
               case 0x22: return 011000b;
               case 0x16: return 011100b;
            }
         case 4:  //NEI Plains
            switch (screen) {
               case 0x26: return 011000b;
               case 0x38:
               case 0x39: return 001000b;
            }
            break;
         case 5:  //NEI Residence
            switch (screen) {
               case 0x1c: return 000100;
               case 0x33: return 000100;
               case 0x63: return 000100;
            }
            break;
         case 6:  //NEI Caves
            switch (screen) {
               case 0x08:
               case 0x17: return 000100b;
            }
            break;
         case 8:  //NEI Cumpura Forest
            switch (screen) {
               case 0x0A: return 001000b;
            }
            break;
         case 9:  //NEI Auri Desert
            switch (screen) {
               case 0x76: return 001000b;
            }
         case 10: //NEI Coasts
            switch (screen) {
               case 0x6E: return 000100b;
               case 0x32: return 001100b;
            }
         case 14: //SWI Auri Desert
            switch (screen) {
               case 0x0E: return 001000b;
               case 0x0D: return 001000b;
               case 0x0B: return 011000b;
               case 0x0A: return 011000b;
               case 0x2B: return 011000b;
            }
            break;
         case 15: //SWI Plains
            switch (screen) {
               case 0x04: return 111100;
               case 0x55: return 001100;
            }
            break;
         case 19: //Lv1 Pern Grotto B1
            switch (screen) {
               case 0x4C: return 010000;
               case 0x4D: return 001000;
               case 0x5D: return 001000;
            }
            break;

         case 21: //Battle Arena 1
            switch (screen) {
               case 0x77: return 000100;
            }
            break;
         case 31: //Lv3 Ancient Shrine B1
            switch (screen) {
               case 0x4A:
               case 0x7C:
               case 0x5D: return 001000b;
            }
            break;
         case 32: //NEI Quarry
            switch (screen) {
               case 0x06: return 011000b;
               case 0x07: return 001100b;
            }
            break;
         case 34: //SWI Celo Village
            switch (screen) {
               case 0x20:
               case 0x21: return 011000b;
            }
            break;
         case 35: //SWI Residence
            switch (screen) {
               case 0x5B: return 000100;
               case 0x61: return 000100;
            }
            break;
         case 36: //SWI Caves
            switch (screen) {
               case 0x17: return 001100b;
               case 0x76: return 000100b;
            }
            break;
         case 38: //SWI Mt. Caldum
            switch (screen) {
               case 0x60: return 001000b;
            }
            break;
         case 39: //SWI Mt Duratu
            switch (screen) {
               case 0x6F: return 000100b;
               case 0x7C: return 011100b;
               case 0x7F: return 001100b;
            }
            break;
         case 40: //SEI Caves
            switch (screen) {
               case 0x21: return 000100b;
               case 0x22: return 000100b;
            }
            break;
         case 43: //Molten Flooded Forge B1
            switch (screen) {
               case 0x0F: return 001000b;
            }
            break;
         case 47: //Lv4 Pillaged Prison B2
            switch (screen) {
               case 0x35: return 000100b;
            }
            break;
         case 49: //SWI Palus Village
            switch (screen) {
               case 0x41: return 000100b;
            }
         case 50: //Lv5 Temple of Gamoth F1
            switch (screen) {
               case 0x02: return 000100b;
            }
            break;
         case 57: //SWI Duratu Village
            switch (screen) {
               case 0x6E: return 001000b;
            }
            break;
         case 58: //SEI Mt Duratu
            switch (screen) {
               case 0x70: return 000100b;
               case 0x71: return 000100b;
            }
            break;
         case 59: //NWI Shrouded Forest
            switch (screen) {
               case 0x76: return 000100b;
               case 0x77: return 001000b;
            }
            break;
         case 62: //SEI Gelido Shoal
            switch (screen) {
               case 0x25: return 011000b;
               case 0x35: return 001000b;
               case 0x45: return 011000b;
               case 0x76: return 011000b;
            }
            break;
         case 66: //NWI Carulem Village
            switch (screen) {
               case 0x21: return 000100b;
            }
         break;
         case 69: //Lv6 Geothermal Plant B1 West
            switch (screen) {
               case 0x22: return 000100b;
            }
            break;
         case 70: //Lv6 Geothermal Plant B1 East
            switch (screen) {
               case 0x4D: return 000100b;
               case 0x1E: return 001000b;
               case 0x2E: return 001000b;
               case 0x58: return 001000b;
               case 0x59: return 001000b;
            }
            break;
         case 71: //Sweltering Iron Mine
            switch (screen) {
               case 0x45: return 001000b;
               case 0x35: return 000100b;
            }
            break;
         case 73: //Summus Pass
            switch (screen) {
               case 0x34: return 000100b;
               case 0x44: return 011000b;
               case 0x46: return 011100b;
            }
            break;
         case 77: //Lv7 Palace of Tides F1
            switch (screen) {
               case 0x42: return 000100b;
               case 0x62: return 000100b;
            }
            break;
         case 89: //Seaside Outpost F2
            switch (screen) {
               case 0x76: return 011000b;
               case 0x45: return 011000b;
               case 0x25: return 011000b;
            }
            break;
         case 124: //NWI Mt. Summus
            switch (screen) {
               case 0x66: return 011000b;
            }
            break;
      }
      return 0;
   }

   void checkFootprints(int[] footprints) {
      CONFIG CT_FOOTPRINT = CT_SCRIPT20;
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
      int stunDuration = Game->LoadItemData(GetHighestLevelItemOwned(IC_BRANG))->Level * 60;

      for (int i = 1; i <= Screen->NumNPCs; ++i) {
         npc enem = Screen->LoadNPC(i);

         if (stunDuration > 0 && enem->Stun > stunDuration)
            enem->Stun = stunDuration;
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
      CONFIG MIDI_GAMEOVER = 8;

      setGameOverMenu(C_TAN, C_BLACK, C_RED, MIDI_GAMEOVER);

      // Makes these combos' invisible (dont make these combos animate)
      for (cid : { 7302 }) {
         Game->LoadComboData(cid)->OriginalTile = TILE_INVIS;
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
// @Author("Deathrider365")
// generic script onF6Menu {
//    // clang-format off

//    void run() {
//       onContHP = Hero->HP;
//       onContMP = Hero->MP;

//       for (int i = 0; i < SizeOfArray(stolenLinkItems); ++i)
//          if (stolenLinkItems[i] > 1)
//             Hero->Item[stolenLinkItems[i]] = true;
//    }
// }

// clang-format off
@Author("Deathrider365")
global script onContGame {
   // clang-format off

   void run() {
      if (onContHP != 0) {
         Hero->HP = onContHP;
         Hero->MP = onContMP;
      } else {
         Hero->HP = Hero->MaxHP;
         Hero->MP = Hero->MaxMP;
      }

      for (int i = 0; i < SizeOfArray(stolenLinkItems); ++i)
         if (stolenLinkItems[i] > 1)
            Hero->Item[stolenLinkItems[i]] = true;
   }
}

// clang-format off
@Author("Deathrider365")
global script onSave {
   // clang-format off

   void run() {
      for (int i = 0; i < SizeOfArray(stolenLinkItems); ++i)
         if (stolenLinkItems[i] > 1)
            Hero->Item[stolenLinkItems[i]] = true;
   }
}

// clang-format off
@Author("Deathrider365")
global script onSaveLoad {
   // clang-format off

   void run() {
      if (auriVillageMusicSet)
         Game->LoadDMapData(Game->GetDMap("NEI Auri Village"))->Music = Audio->LoadMusicData(93); //Dmap 7, NEI Auri Village TODO use this not audio file names
   }
}

// clang-format off
@Author("Deathrider365")
global script onExit {
   // clang-format off

   void run() {

   }
}