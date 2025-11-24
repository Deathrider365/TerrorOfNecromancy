// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ General FFC Scripts~~~~~~~~~~~~~~~~~~~~~~~~~~~//

// clang-format off
@Author("EmilyV99")
ffc script ContinuePoint {
   // clang-format on

   void run(int dmap, int scrn) {
      unless(dmap || scrn) {
         dmap = Game->CurDMap;
         scrn = Game->CurScreen;
      }

      Game->LastEntranceDMap = dmap;
      Game->LastEntranceScreen = scrn;
      Game->ContinueDMap = dmap;
      Game->ContinueScreen = scrn;
   }
}

// clang-format off
@Author("Demonlink")
 ffc script CompassBeep {
   // clang-format on

   void run() {
      if (!Screen->State[ST_ITEM] && !Screen->State[ST_CHEST] && !Screen->State[ST_LOCKEDCHEST] && !Screen->State[ST_BOSSCHEST] && !Screen->State[ST_SPECIALITEM] && (Game->LItems[Game->CurLevel] & LI_COMPASS))
         Audio->PlaySound(COMPASS_BEEP);
   }
}

// clang-format off
@Author("Deathrider365")
 ffc script BossMusic {
   // clang-format on

   void run(int musicChoice) {
      unless(musicChoice) Quit();

      if (Screen->State[ST_SECRET])
         Quit();

      until(EnemiesAlive()) Waitframe();

      switch (musicChoice) {
         case 1: Audio->PlayEnhancedMusic("OoT - Middle Boss.ogg", 0); break;
         case 2: Audio->PlayEnhancedMusic("Metroid Prime - Parasite Queen.ogg", 0); break;
         case 3: Audio->PlayEnhancedMusic("The Binding of Isaac - Divine Combat.ogg", 0); break;
         case 4: Audio->PlayEnhancedMusic("The Binding of Isaac - Divine Combat.ogg", 0); break;
         default: Audio->PlayEnhancedMusic(NULL, 0); break;
      }

      while (EnemiesAlive())
         Waitframe();

      char32 areaMusic[256];
      Game->LoadDMapData(Game->CurDMap)->GetMusic(areaMusic);
      Audio->PlayEnhancedMusic(areaMusic);

      Quit();
   }
}

// clang-format off
@Author("Deathrider365")
 ffc script BattleArena {
   // clang-format on

   void run(int arenaListNum, int screenD, int map, int screen, int setScreenDOnOtherScreen, int screenDForShutter) {
      unless(Hero->Item[ITEM_BATTLE_ARENA_TICKET]) {
         Screen->TriggerSecrets();
         setScreenD(screenD, true);
         Quit();
      }

      setScreenD(screenDForShutter, true);
      setScreenD(screenD, false);
      Hero->Item[ITEM_BATTLE_ARENA_TICKET] = false;

      int round = 1;

      playBattleTheme(arenaListNum);

      until(spawnEnemies(arenaListNum, round)) {
         while (EnemiesAlive())
            Waitframe();

         ++round;

         Waitframes(120);
      }

      while (EnemiesAlive())
         Waitframe();

      Screen->TriggerSecrets();
      setScreenD(screenD, true);
      setScreenD(screenDForShutter, false);

      if (map && screen) {
         mapdata mapData = Game->LoadMapData(map, screen);
         mapData->State[ST_SECRET] = true;
         Audio->PlaySound(SFX_SECRET);
      }

      if (setScreenDOnOtherScreen)
         setScreenD(map, screen, setScreenDOnOtherScreen, true);

      char32 areaMusic[256];
      Game->LoadDMapData(Game->CurDMap)->GetMusic(areaMusic);
      Audio->PlayEnhancedMusic(areaMusic, 0);
   }

   bool spawnEnemies(int arenaListNum, int round) { //TODO make these enemy sets have some variability (chances to get different enemies)
      int enemyList[50];
      bool shouldReturn;

      switch (arenaListNum) {
         case 0: {
            Screen->Pattern = PATTERN_CEILING;

            switch (round) {
               case 1: setEnemies({ENEMY_OCTOROCK_LV1_SLOW, ENEMY_OCTOROCK_LV1_FAST, ENEMY_OCTOROCK_LV1_FAST, ENEMY_OCTOROCK_LV1_FAST, ENEMY_OCTOROCK_LV2_FAST}); break;
               case 2: setEnemies({ENEMY_MOBLIN_LV1, ENEMY_MOBLIN_LV1, ENEMY_MOBLIN_LV1, ENEMY_STALFOS_LV1, ENEMY_STALFOS_LV1, ENEMY_STALFOS_LV1, ENEMY_ROPE_LV1, ENEMY_ROPE_LV1}); break;
               case 3: setEnemies({ENEMY_MOBLIN_LV2, ENEMY_MOBLIN_LV2, ENEMY_OCTOROCK_LV2_FAST, ENEMY_OCTOROCK_LV2_FAST, ENEMY_OCTOROCK_LV2_FAST, ENEMY_GORIYA_LV1, ENEMY_GORIYA_LV1}); break;
               case 4: setEnemies({ENEMY_LEEVER_LV1_INSIDE, ENEMY_LEEVER_LV1_INSIDE, ENEMY_LEEVER_LV1_INSIDE, ENEMY_LEEVER_LV1_INSIDE, ENEMY_LEEVER_LV2_INSIDE, ENEMY_LEEVER_LV2_INSIDE, ENEMY_LEEVER_LV2_INSIDE}); break;
               case 5: setEnemies({ENEMY_CANDLEHEAD_LV1, ENEMY_CANDLEHEAD_LV1, ENEMY_CANDLEHEAD_LV1}); break;
               case 6:
                  playBossTheme(arenaListNum);
                  setEnemies({ENEMY_OVERGROWN_RACCOON});
                  shouldReturn = true;
                  break;
            }
            break;
         }
         case 1: {
            Screen->Pattern = PATTERN_CEILING;

            switch (round) {
               case 0: setEnemies({ENEMY_MOBLIN_LV2, ENEMY_MOBLIN_LV2, ENEMY_MOBLIN_LV2, ENEMY_ROPE_LV2, ENEMY_ROPE_LV2, ENEMY_ROPE_LV2}); break;
               case 1: setEnemies({ENEMY_STALFOS_LV2, ENEMY_STALFOS_LV2, ENEMY_STALFOS_LV2, ENEMY_GORIYA_LV2, ENEMY_GORIYA_LV1, ENEMY_GORIYA_LV1}); break;
               case 2: setEnemies({ENEMY_BAT, ENEMY_BAT, ENEMY_BAT, ENEMY_BAT, ENEMY_BAT}); break;
               case 3: setEnemies({ENEMY_ARMOS_LV1, ENEMY_ARMOS_LV1, ENEMY_ARMOS_LV1, ENEMY_ARMOS_LV1, ENEMY_ARMOS_LV2, ENEMY_ARMOS_LV2, ENEMY_ARMOS_LV2}); break;
               case 4: setEnemies({ENEMY_BUBBLE_TEMP_LV1, ENEMY_THIEF_LV1, ENEMY_THIEF_LV1, ENEMY_THIEF_LV1, ENEMY_THIEF_LV1, ENEMY_THIEF_LV1}); break;
               case 5:
                  playBossTheme(arenaListNum);
                  setEnemies({ENEMY_THIEF_BOSS});
                  shouldReturn = true;
                  break;
            }
            break;
         }
         case 2: {
            Screen->Pattern = PATTERN_SIDES;

            switch (round) {
               case 0: setEnemies({ENEMY_STALFOS_LV2, ENEMY_STALFOS_LV2, ENEMY_STALFOS_LV2, ENEMY_STALFOS_LV2, ENEMY_STALFOS_LV2, ENEMY_STALFOS_LV2}); break;
               case 1: setEnemies({ENEMY_STALFOS_LV2, ENEMY_STALFOS_LV2, ENEMY_STALFOS_LV2, ENEMY_ZOMBIE_LV3, ENEMY_ZOMBIE_LV3, ENEMY_ZOMBIE_LV3}); break;
               case 2: setEnemies({ENEMY_ZOMBIE_LV3, ENEMY_ZOMBIE_LV3, ENEMY_ZOMBIE_LV3, ENEMY_ZOMBIE_LV3, ENEMY_ZOMBIE_LV3}); break;
               case 5:
                  playBossTheme(arenaListNum);
                  setEnemies({ENEMY_ZOMBIE_LV3});
                  shouldReturn = true;
                  break;
            }
            break;
         }
      }

      Screen->SpawnScreenEnemies();

      return shouldReturn;
   }

   void setEnemies(int arr) {
      int enemyArray[10];

      memcpy(enemyArray, arr, SizeOfArray(arr));

      for (int q = 0; q < 10; ++q)
         Screen->Enemy[q] = enemyArray[q];
   }

   void playBattleTheme(int arenaListNum) {
      switch (arenaListNum) {
         case 0: Audio->PlayEnhancedMusic("Romancing Saga, MS - ACTGFKB.ogg", 0); break;
         case 1: Audio->PlayEnhancedMusic("Tales of Graces - Sword Drawing.ogg", 0); break;
         case 2: Audio->PlayEnhancedMusic("Tales of Graces - Sword Drawing.ogg", 0); break;
      }
   }

   void playBossTheme(int arenaListNum) {
      switch (arenaListNum) {
         case 0: Audio->PlayEnhancedMusic("Skies of Arcadia - Bombardment.ogg", 0); break;
         case 1: Audio->PlayEnhancedMusic("Otosan - Lord Rat Laureate Boss Battle.ogg", 0); break;
         case 2: Audio->PlayEnhancedMusic("Otosan - Lord Rat Laureate Boss Battle.ogg", 0); break;
      }
   }
}

// clang-format off
@Author("Moosh")
 ffc script PoisonWater {
   // clang-format on

   void run() {
      while (true) {
         until(Link->Action == LA_SWIMMING && Link->Action == LA_DIVING && Screen->ComboT[ComboAt(Link->X + 8, Link->Y + 12)] == CT_SHALLOWWATER) Waitframe();

         int maxDamageTimer = 120;
         int damageTimer = maxDamageTimer;

         while (Link->Action == LA_SWIMMING || Link->Action == LA_DIVING || (Screen->ComboT[ComboAt(Link->X + 8, Link->Y + 12)] == CT_SHALLOWWATER)) {
            damageTimer--;

            if (damageTimer <= 0)
               if (Screen->ComboT[ComboAt(Link->X + 8, Link->Y + 12)] == CT_SHALLOWWATER || Link->Action == LA_SWIMMING) {
                  Link->HP -= 8;
                  Audio->PlaySound(Choose(SFX_HERO_HURT_1, SFX_HERO_HURT_2, SFX_HERO_HURT_3));
                  damageTimer = maxDamageTimer;
               }

            Waitframe();
         }
      }
   }
} // end

// clang-format off
@Author("Deathrider365")
 ffc script Thrower {
   // clang-format on

   void run(int coolDown, int variance, float trigger, bool throwsItem, int projectile, int sprite, int hasArc, int sfx) {
      const int COOLDOWN = !coolDown ? 120 : coolDown;

      int lowVariance = Floor(variance);
      int highVariance = -(variance % 1) / 1L;

      int projectileId = Floor(projectile);
      int projectileType = (projectile % 1) / 1L;

      while (true) {
         if (wasTriggered(trigger))
            Quit();

         unless(coolDown) {
            if (throwsItem) {
               if (int scr = CheckItemSpriteScript("ArcingItemSprite")) {
                  itemsprite it = RunItemSpriteScriptAt(projectileId, scr, this->X, this->Y, {Angle(this->X + 8, this->Y + 8, Hero->X + 8, Hero->Y + 8), 5, -1, 0});

                  it->Pickup |= IP_TIMEOUT;
               }
            }
            else {
               if (projectileType < 0 || projectileType >= AE_DEBUG)
                  projectileType = AE_DEBUG;

               eweapon projectile = FireAimedEWeapon(projectileId, CenterX(this) - 8, CenterY(this) - 8, 0, 255, 3, sprite, -1, EWF_UNBLOCKABLE | EWF_ROTATE);

               if (hasArc) {
                  if (int scr = CheckEWeaponScript("ArcingWeapon")) {
                     if (sfx)
                        Audio->PlaySound(sfx);
                     runEWeaponScript(projectile, scr, {-1, 0, projectileType, 0, 8, 0, false});
                  }
               }
            }

            coolDown = COOLDOWN + Rand(lowVariance, highVariance);
         }

         coolDown--;
         Waitframe();
      }
   }
}

// clang-format off
@Author("EmilyV99"),
@InitD0("dmapScreen1"),
@InitDHelp0("dmap.screen, screen is not the hex screen"),
@InitD1("x1"),
@InitDHelp1("-1 if using A-D, otherwise an x return location"),
@InitD2("y1"),
@InitDHelp2("0-3 == A-D"),
@InitD3("dmapScreen2"),
@InitDHelp3("dmap.screen, screen is not the hex screen"),
@InitD4("x2"),
@InitDHelp4("-1 if using A-D, otherwise an x return location"),
@InitD5("y2"),
@InitDHelp5("0-3 == A-D"),
@InitD6("sideFacing"),
@InitDHelp6("0 == up, 1 == right..."),
@InitD7("warp"),
@InitDHelp7("warpType.warpEffect")
 ffc script WarpCustomReturn {
   // clang-format on

   void run(int dmapScreen1, int x1, int y1, int dmapScreen2, int x2, int y2, int sideFacing, int warp) {
      int dmap1 = Floor(dmapScreen1);
      int screen1 = (dmapScreen1 % 1) / 1L;
      int dmap2 = Floor(dmapScreen2);
      int screen2 = (dmapScreen2 % 1) / 1L;
      int warpType = Floor(warp);
      int warpEffect = (warp % 1) / 1L;
      int side = Floor(sideFacing);
      int dir = (sideFacing % 1) / 1L;

      switch (side) {
         case DIR_UP: {
            while (true) {
               if (Hero->Y <= 1.5 && Hero->InputUp) {
                  if (dmap2 && Hero->X >= this->X)
                     Hero->WarpEx({warpType, dmap2, screen2, x2, y2, warpEffect, 0, 0, dir});
                  else
                     Hero->WarpEx({warpType, dmap1, screen1, x1, y1, warpEffect, 0, 0, dir});
               }
               Waitframe();
            }
         }
         case DIR_DOWN: {
            while (true) {
               if (Hero->Y >= 158.5 && Hero->InputDown) {
                  if (dmap2 && Hero->X >= this->X)
                     Hero->WarpEx({warpType, dmap2, screen2, x2, y2, warpEffect, 0, 0, dir});
                  else
                     Hero->WarpEx({warpType, dmap1, screen1, x1, y1, warpEffect, 0, 0, dir});
               }
               Waitframe();
            }
         }
         case DIR_LEFT: {
            while (true) {
               if (Hero->X <= 1.5 && Hero->InputLeft) {
                  if (dmap2 && Hero->Y >= this->Y)
                     Hero->WarpEx({warpType, dmap2, screen2, x2, y2, warpEffect, 0, 0, dir});
                  else
                     Hero->WarpEx({warpType, dmap1, screen1, x1, y1, warpEffect, 0, 0, dir});
               }
               Waitframe();
            }
         }
         case DIR_RIGHT: {
            while (true) {
               if (Hero->X >= 238.5 && Hero->InputRight) {
                  if (dmap2 && Hero->Y >= this->Y)
                     Hero->WarpEx({warpType, dmap2, screen2, x2, y2, warpEffect, 0, 0, dir});
                  else
                     Hero->WarpEx({warpType, dmap1, screen1, x1, y1, warpEffect, 0, 0, dir});
               }
               Waitframe();
            }
         }
         default: {
            while (true) {
               if (Abs(Hero->X - this->X) <= 14 && Abs(Hero->Y - this->Y) <= 14)
                  Hero->WarpEx({warpType, dmap1, screen1, x1, y1, warpEffect, 0, 0, dir});
               Waitframe();
            }
         }
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script PlayEnhancedMusic {
   // clang-format on

   void run(int musicChoice) {
      switch (musicChoice) {
         case 0: Audio->PlayEnhancedMusic("WW - Ship Theme.ogg", 0); break;
         case 1: Audio->PlayEnhancedMusic("OoT - Potion Shop.ogg", 0); break;
         case 2: Audio->PlayEnhancedMusic("Metroid Prime 3 - Bryyo.ogg", 0); break;
      }
   }
}

// clang-format off
@Author("Deathrider365"),
@InitD0("dir"),
@InitDHelp0("0 - up, 1 - down, 2 - left, 3 - right")
ffc script FaceLinkOnEntrance {
   // clang-format on

   void run(int dir) {
      Hero->Dir = dir;
   }
}

// clang-format off
@Author("Deathrider365")
ffc script UnlockMoltenFloodedForgeBoss { //doesnt seem to trigger right away
   // clang-format on

   void run() {
      mapdata mapData1 = Game->LoadMapData(61, 0x33);
      mapdata mapData2 = Game->LoadMapData(61, 0x53);

      if (mapData1->State[ST_SECRET] && mapData2->State[ST_SECRET]) {
         Screen->TriggerSecrets();
         Screen->State[ST_SECRET] = true;
         Audio->PlaySound(SFX_SECRET);
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script OpenTheGates {
   // clang-format on

   CONFIG R_GATE_LEFT = 7283;
   CONFIG R_GATE_CENTER = 7287;
   CONFIG R_GATE_RIGHT = 7291;
   CONFIG R_GATE_TOP = 7279;

   CONFIG T_GATE_LEFT = 7289;
   CONFIG T_GATE_CENTER = 7288;
   CONFIG T_GATE_RIGHT = 7290;
   CONFIG T_GATE_TOP = 7284;

   CONFIG D_GATE_LEFT = 7233;
   CONFIG D_GATE_CENTER = 7234;
   CONFIG D_GATE_RIGHT = 7235;
   CONFIG D_GATE_TOP = 7231;

   CONFIG INVISIBLE_GATE = 4778;

   void run(int screenWithTrigger) {
      mapdata map = Game->LoadMapData(70, screenWithTrigger);
      mapdata mapDataLayer0 = Game->LoadTempScreen(0);
      mapdata mapDataLayer1 = Game->LoadTempScreen(1);
      mapdata mapDataLayer2 = Game->LoadTempScreen(2);

      while (true) {
         if (map->State[ST_SECRET]) {
            for (int i = 0; i < 176; i++) {
               if (mapDataLayer1->ComboD[i] == 7283 || mapDataLayer1->ComboD[i] == 7287 || mapDataLayer1->ComboD[i] == 7291 || mapDataLayer1->ComboD[i] == 7279 || mapDataLayer1->ComboD[i] == 7289 || mapDataLayer1->ComboD[i] == 7288 || mapDataLayer1->ComboD[i] == 7290 ||
                   mapDataLayer1->ComboD[i] == 7285 || mapDataLayer1->ComboD[i] == 7233 || mapDataLayer1->ComboD[i] == 7234 || mapDataLayer1->ComboD[i] == 7235 || mapDataLayer1->ComboD[i] == 7231 || mapDataLayer1->ComboD[i] == 7265 || mapDataLayer1->ComboD[i] == 7269 ||
                   mapDataLayer1->ComboD[i] == 7284)
                  mapDataLayer1->ComboD[i] = CMB_INVIS;

               if (mapDataLayer2->ComboD[i] == 4778) {
                  mapDataLayer2->ComboD[i] = 4362;
               }
            }

            break;
         }

         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365"),
@InitD0("armorLevel"),
@InitDHelp0("1 = green, 2 = blue, 3 = red..."),
@InitD1("damage"),
@InitDHelp1("8 = 1 heart")
ffc script HeatedRoomFFC {
   // clang-format on
   void run(int armorLevel, int damage) {
      handleHeatOrCold(armorLevel, damage);
   }
}

// clang-format off
@Author("Deathrider365")
ffc script TriggerSavedGoronsLvl6 {
   // clang-format on
   void run() {
      if (Screen->State[ST_SECRET])
         Quit();

      int goronsSaved = 0;

      while (true) {
         if (getScreenD(67, 0x13, 84)) {
            setScreenD(0, true);
            ++goronsSaved;
         }
         if (getScreenD(67, 0x44, 84)) {
            setScreenD(1, true);
            ++goronsSaved;
         }
         if (getScreenD(68, 0x41, 84)) {
            setScreenD(2, true);
            ++goronsSaved;
         }
         if (getScreenD(68, 0x14, 84)) {
            setScreenD(3, true);
            ++goronsSaved;
         }
         if (getScreenD(69, 0x12, 84)) {
            setScreenD(4, true);
            ++goronsSaved;
         }
         if (getScreenD(69, 0x75, 84)) {
            setScreenD(5, true);
            ++goronsSaved;
         }
         if (goronsSaved == 6) {
            Screen->TriggerSecrets();
            Screen->State[ST_SECRET] = true;
            Audio->PlaySound(SFX_SECRET);
            Quit();
         }

         goronsSaved = 0;
         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365"),
@InitD0("map"),
@InitDHelp0("map that has the screen with secrets"),
@InitD1("screen"),
@InitDHelp1("screen that has the secrets"),
@InitD2("screenD"),
@InitDHelp2("screenD to set on THIS screen")
ffc script SetScreenDIfSecretsInOtherRoom {
   // clang-format on
   void run(int map, int screen, int screenD) {
      if (getScreenD(screenD))
         Quit();

      mapdata mapData = Game->LoadMapData(map, screen);

      until(getScreenD(screenD)) {
         if (mapData->State[ST_SECRET])
            setScreenD(screenD, true);

         Waitframe();
      }
   }
}

// clang-format off
@Author("kifstopher")
ffc script BossCam { // clang-format on

   void run() {
      int myDistance = 200; // how far until camera stops splitting
      Viewport->Mode = VIEW_MODE_CENTER_AND_BOUND;
      Viewport->Target = this;

      while (Screen->NumNPCs == 0)
         Waitframe();

      npc boss = Screen->LoadNPC(1);

      while (true) {
         // check if boss is ded
         if (!boss->isValid()) {
            Viewport->Target = Hero;
            Quit();
         }
         // check if boss is too far
         if (Distance(Hero->X, Hero->Y, boss->X, boss->Y) > myDistance) {
            this->X = Hero->X;
            this->Y = Hero->Y;
         }
         else {
            // otherwise update position
            this->X = (Hero->X + boss->X) / 2;
            this->Y = (Hero->Y + boss->Y) / 2;
         }
         Waitframe();
      }
   }
}

// clang-format off
@InitD0("Speed"),
@InitDHelp0("The speed the cart travels in pixels per frame"),
@InitD1("No Reset"),
@InitDHelp1("If 1, this minecart's position will never reset when the Reset_Minecarts FFC script runs"),
@InitD2("Script Spawned"),
@InitDHelp2("Used for communication with the Generic script, leave at 0."),
@InitD3("Jump Out?"),
@InitDHelp2("Used for communication with the Generic script, leave at 0.")
ffc script GBMinecart {
   // clang-format on

   using namespace MinecartNamespace;

   void run(int speed, int noReset, int scriptSpawned, int jumpOut) {
      int id;
      if (!scriptSpawned) {
         id = GetMinecartID(this);
         // If this is a new minecart, set it up
         if (GetMinecartVar(id, MCII_MAP) == 0) {
            SetMinecartVar(id, MCII_MAP, Game->CurMap);
            SetMinecartVar(id, MCII_SCREEN, Game->CurScreen);
            SetMinecartVar(id, MCII_X, this->X);
            SetMinecartVar(id, MCII_Y, this->Y);
            SetMinecartVar(id, MCII_DIR, this->Data % 4);
            SetMinecartVar(id, MCII_NORESET, noReset);
            SetMinecartVar(id, MCII_ORIGINALMAP, Game->CurMap);
            SetMinecartVar(id, MCII_ORIGINALSCREEN, Game->CurScreen);
            SetMinecartVar(id, MCII_ORIGINALX, this->X);
            SetMinecartVar(id, MCII_ORIGINALY, this->Y);
            SetMinecartVar(id, MCII_ORIGINALFFC, this->ID);
            SetMinecartVar(id, MCII_COMBO, Floor(this->Data / 4) * 4);
            SetMinecartVar(id, MCII_CSET, this->CSet);
            SetMinecartVar(id, MCII_SPEED, speed);
            ++GBMinecarts[MCI_ACTIVEMINECARTS];
         }
         else {
            // If it's not parked on the current screen, quit out
            if (GetMinecartVar(id, MCII_MAP) != Game->CurMap || GetMinecartVar(id, MCII_SCREEN) != Game->CurScreen || GetMinecartVar(id, MCII_X) != this->X || GetMinecartVar(id, MCII_Y) != this->Y) {
               this->Data = 0;
               Quit();
            }
            // Else make sure it faces the right way
            else
               SetMinecartVar(id, MCII_DIR, this->Data % 4);
         }
      }
      else {
         id = scriptSpawned - 1;
         this->Data = GetMinecartVar(id, MCII_COMBO) + GetMinecartVar(id, MCII_DIR);
         this->CSet = GetMinecartVar(id, MCII_CSET);
      }

      // The minecart origin FFC shouldn't spawn while riding it
      if (GBMinecarts[MCI_INMINECART] && id == GBMinecarts[MCI_CURRENTID]) {
         int oldcmb = this->Data;
         // Failsafe to prevent a false positive while F6ing in a cart. Bleh.
         this->Data = CMB_INVIS;
         Waitframe();
         if (GBMinecarts[MCI_INMINECART] && id == GBMinecarts[MCI_CURRENTID]) {
            this->Data = 0;
            Quit();
         }
         this->Data = oldcmb;
      }

      int dir = this->Data % 4;
      // Jump out animation if called via script
      if (jumpOut) {
         // Link is launched out in the opposite direction because
         // the cart turns around on reaching the platform
         Link->Dir = OppositeDir(dir);
         Link->Jump = 2;
         Audio->PlaySound(SFX_JUMP);
         int tx = this->X + DirX(OppositeDir(dir)) * 16;
         int ty = this->Y + DirY(OppositeDir(dir)) * 16;
         int angle = Angle(this->X, this->Y, tx, ty);
         int dist = Distance(this->X, this->Y, tx, ty);
         int linkX = Link->X;
         int linkY = Link->Y;
         for (int i = 0; i < 26; i++) {
            linkX += VectorX(dist / 26, angle);
            linkY += VectorY(dist / 26, angle);
            NoAction();
            Waitdraw();
            Link->X = linkX;
            Link->Y = linkY;
            Waitframe();
         }
         Link->X = tx;
         Link->Y = ty;
         this->Data = Floor(this->Data / 4) * 4 + dir;
      }
      this->Flags[FFCF_SOLID] = true;
      int timer[1];

      if (this->Flags[FFCF_PRELOAD])
         Waitframe();

      while (true) {
         if (PressAgainstCart(this, timer)) {
            this->Flags[FFCF_SOLID] = false;
            Link->Dir = AngleDir4(Angle(Link->X, Link->Y, this->X, this->Y - MINECART_LINKYOFFSET));
            Link->Jump = 2;
            Audio->PlaySound(SFX_JUMP);
            int tx = this->X;
            int ty = this->Y - MINECART_LINKYOFFSET;
            int angle = Angle(Link->X, Link->Y, tx, ty);
            int dist = Distance(Link->X, Link->Y, tx, ty);
            int linkX = Link->X;
            int linkY = Link->Y;
            for (int i = 0; i < 26; i++) {
               linkX += VectorX(dist / 26, angle);
               linkY += VectorY(dist / 26, angle);
               NoAction();
               Waitdraw();
               Link->X = linkX;
               Link->Y = linkY;
               Waitframe();
            }
            Link->X = tx;
            Link->Y = ty;

            // Set global variables for carting based on the FFC
            GBMinecarts[MCI_INMINECART] = true;
            GBMinecarts[MCI_CURRENTID] = id;
            GBMinecarts[MCI_CARTCOMBO] = GetMinecartVar(id, MCII_COMBO);
            GBMinecarts[MCI_CARTCSET] = GetMinecartVar(id, MCII_CSET);
            GBMinecarts[MCI_CARTDIR] = dir;
            GBMinecarts[MCI_CARTSPEED] = GetMinecartVar(id, MCII_SPEED);
            GBMinecarts[MCI_CARTX] = this->X;
            GBMinecarts[MCI_CARTY] = this->Y;

            this->Data = 0;
            Quit();
         }
         Waitframe();
      }
   }
   int GetMinecartID(ffc this) {
      // Scan over all active minecarts
      for (int i = 0; i < GBMinecarts[MCI_ACTIVEMINECARTS]; ++i) {
         int ogMap = GetMinecartVar(i, MCII_ORIGINALMAP);
         int ogScreen = GetMinecartVar(i, MCII_ORIGINALSCREEN);
         int ogFFC = GetMinecartVar(i, MCII_ORIGINALFFC);
         // Find one that matches the screen and FFC
         if (ogMap == Game->CurMap && ogScreen == Game->CurScreen && ogFFC == this->ID)
            return i;
      }
      if (GBMinecarts[MCI_ACTIVEMINECARTS] + 1 > MAX_MINECARTS) {
         printf("ERROR: Not enough free minecart slots, please increase MAX_MINECARTS");
         return 0;
      }
      // Otherwise it's a new minecart
      return GBMinecarts[MCI_ACTIVEMINECARTS];
   }
   bool PressAgainstCart(ffc this, int[] timer) {
      if (Link->Z > 0 || Link->FakeZ > 0)
         return false;
      bool pressing;
      if (Abs(Link->X - this->X) <= 8 && Link->Y > this->Y && Link->Y <= this->Y + 8 && Link->InputUp)
         pressing = true;
      if (Abs(Link->X - this->X) <= 8 && Link->Y >= this->Y - 16 && Link->Y < this->Y && Link->InputDown)
         pressing = true;
      if (Link->X <= this->X + 16 && Link->X > this->X && Link->Y >= this->Y - 8 && Link->Y <= this->Y && Link->InputLeft)
         pressing = true;
      if (Link->X >= this->X - 16 && Link->X < this->X && Link->Y >= this->Y - 8 && Link->Y <= this->Y && Link->InputRight)
         pressing = true;
      if (pressing) {
         ++timer[0];
         if (timer[0] > MINECART_HOLDFRAMES)
            return true;
      }
      else
         timer[0] = 0;
      return false;
   }
}

// clang-format off
@InitD0("Only This Map"),
@InitDHelp0("If 1, only resets minecarts on the current map")
ffc script GBReset_Minecarts {
   // clang-format on

   using namespace MinecartNamespace;

   void run(int onlyThisMap) {
      if (Abs(Link->X - this->X) <= 8 && Abs(Link->Y - this->Y) <= 8) {
         for (int i = 0; i < GBMinecarts[MCI_ACTIVEMINECARTS]; ++i) {
            if (!onlyThisMap || GetMinecartVar(i, MCII_MAP) == Game->CurMap) {
               if (!GetMinecartVar(i, MCII_NORESET)) {
                  SetMinecartVar(i, MCII_MAP, GetMinecartVar(i, MCII_ORIGINALMAP));
                  SetMinecartVar(i, MCII_SCREEN, GetMinecartVar(i, MCII_ORIGINALSCREEN));
                  SetMinecartVar(i, MCII_X, GetMinecartVar(i, MCII_ORIGINALX));
                  SetMinecartVar(i, MCII_Y, GetMinecartVar(i, MCII_ORIGINALY));
               }
            }
         }
      }
   }
}

// clang-format off
@Author("Moosh")
ffc script GBMinecart_Shutter {
   // clang-format on

   using namespace MinecartNamespace;

   CONFIG CMB_SHUTTER_OPEN = 0;

   void run() {
      mapdata shutterLayer = Game->LoadTempScreen(IsBackgroundLayer(2) ? 1 : 2);
      int combo = this->Data;
      int pos = ComboAt(this->X + 8, this->Y + 8);
      this->Data = CMB_INVIS;
      bool open;
      int x = Link->X;
      int y = Link->Y;

      if (this->Flags[FFCF_PRELOAD]) {
         if (x <= 0)
            x = 240;
         else if (x >= 240)
            x = 0;
         if (y <= 0)
            y = 160;
         else if (y >= 160)
            y = 0;
      }
      int triggerDist = 16 + 4 * GBMinecarts[MCI_CARTSPEED];
      if (GBMinecarts[MCI_INMINECART] && Abs(x - this->X) < triggerDist && Abs(y - this->Y) < triggerDist)
         open = true;

      shutterLayer->ComboD[pos] = open ? CMB_SHUTTER_OPEN : combo;
      shutterLayer->ComboC[pos] = this->CSet;

      if (this->Flags[FFCF_PRELOAD])
         Waitframe();
      while (true) {
         x = Link->X;
         y = Link->Y;
         if (open) {
            if (!(Abs(x - this->X) < triggerDist && Abs(y - this->Y) < triggerDist)) {
               Audio->PlaySound(SFX_SHUTTER);
               shutterLayer->ComboD[pos] = combo + 4;
               Waitframes(4);
               shutterLayer->ComboD[pos] = combo;
               open = false;
            }
         }
         else {
            if (GBMinecarts[MCI_INMINECART] && Abs(x - this->X) < triggerDist && Abs(y - this->Y) < triggerDist) {
               Audio->PlaySound(SFX_SHUTTER);
               shutterLayer->ComboD[pos] = combo + 4;
               Waitframes(4);
               shutterLayer->ComboD[pos] = CMB_SHUTTER_OPEN;
               open = true;
            }
         }
         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script AssignAAndBForIntro {
   // clang-format on
   void run() {
      Hero->ItemA = ITEM_SWORD3;
      Hero->ItemB = ITEM_BRANG2;
   }
}

// clang-format off
@InitD0("condition"),
@InitDHelp0("The condition in which enemies vanish: 1 - screenD set, 2 - secrets triggered, 3 - based on item"),
@InitD1("conditionValue"),
@InitDHelp1("screenD value, N/A, itemId"),
@Author("Deathrider365")
ffc script EnemiesNeverReturn {
   // clang-format on

   CONFIG SMT_SCREEND = 1;
   CONFIG SMT_SECRETS = 2;
   CONFIG SMT_HAS_ITEM = 3;

   void run(int condition, int conditionValue) {
      switch(condition) {
         case SMT_SCREEND:
            if (getScreenD(conditionValue))
               removeEnemies();
            break;
         case SMT_SECRETS:
            if (Screen->State[ST_SECRET])
               removeEnemies();
            break;
         case SMT_HAS_ITEM:
            if (Hero->Item[conditionValue])
               removeEnemies();
            break;
         default: break;
      }
   }

   void removeEnemies() {
      for (int q = 0; q < 10; ++q)
         Screen->Enemy[q] = 0;
   }
}

ffc script EquipItemsOnGameStart {
   void run() {
      Hero->ItemA = GetHighestLevelItemOwned(IC_SWORD);
      Hero->ItemB = GetHighestLevelItemOwned(IC_BRANG);
   }
}