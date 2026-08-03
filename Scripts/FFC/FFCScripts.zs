// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ General FFC Scripts~~~~~~~~~~~~~~~~~~~~~~~~~~~//

// clang-format off
@Author("EmilyV99")
ffc script ContinuePoint {
   // clang-format on

   void run(int dmap, int scrn) {
      unless(dmap || scrn) {
         dmap = Game->CurDMap;
         scrn = Game->HeroScreen;
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
         Audio->PlaySound(SFX_COMPASS_BEEP);
   }
}

// clang-format off
@Author("Deathrider365")
 ffc script BossMusic {
   // clang-format on

   void run(int musicChoice, int triggerOnScreenD, int invertTriggerOnScreenD) {
      unless(musicChoice) Quit();

      if (triggerOnScreenD == 0 && Screen->State[ST_SECRET]
         || (triggerOnScreenD > 0 && (!getScreenD(triggerOnScreenD)
         || invertTriggerOnScreenD > 0 && getScreenD(triggerOnScreenD)))
      )
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

      MUSIC_INHERIT->Play();

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

      MUSIC_INHERIT->Play();
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
               case 1: setEnemies({ENEMY_MOBLIN_LV2, ENEMY_MOBLIN_LV2, ENEMY_MOBLIN_LV2, ENEMY_ROPE_LV2, ENEMY_ROPE_LV2, ENEMY_ROPE_LV2}); break;
               case 2: setEnemies({ENEMY_STALFOS_LV2, ENEMY_STALFOS_LV2, ENEMY_STALFOS_LV2, ENEMY_GORIYA_LV2, ENEMY_GORIYA_LV1, ENEMY_GORIYA_LV1}); break;
               case 3: setEnemies({ENEMY_BAT, ENEMY_BAT, ENEMY_BAT, ENEMY_BAT, ENEMY_BAT}); break;
               case 4: setEnemies({ENEMY_ARMOS_LV1, ENEMY_ARMOS_LV1, ENEMY_ARMOS_LV1, ENEMY_ARMOS_LV1, ENEMY_ARMOS_LV2, ENEMY_ARMOS_LV2, ENEMY_ARMOS_LV2}); break;
               case 5: setEnemies({ENEMY_BUBBLE_TEMP_LV1, ENEMY_THIEF_LV1, ENEMY_THIEF_LV1, ENEMY_THIEF_LV1, ENEMY_THIEF_LV1, ENEMY_THIEF_LV1}); break;
               case 6:
                  playBossTheme(arenaListNum);
                  setEnemies({ENEMY_THIEF_BOSS});
                  shouldReturn = true;
                  break;
            }
            break;
         }
         case 2: {
            Screen->Pattern = PATTERN_STANDARD;

            switch (round) {
               case 1: setEnemies({ENEMY_MOBLIN_LV2, ENEMY_MOBLIN_LV2, ENEMY_MOBLIN_LV2, ENEMY_ROPE_LV2, ENEMY_ROPE_LV2, ENEMY_ROPE_LV2});
                  shouldReturn = true;
                  break;
               // case 2: setEnemies({ENEMY_STALFOS_LV2, ENEMY_STALFOS_LV2, ENEMY_STALFOS_LV2, ENEMY_GORIYA_LV2, ENEMY_GORIYA_LV1, ENEMY_GORIYA_LV1}); break;
               // case 3: setEnemies({ENEMY_BAT, ENEMY_BAT, ENEMY_BAT, ENEMY_BAT, ENEMY_BAT}); break;
               // case 4: setEnemies({ENEMY_ARMOS_LV1, ENEMY_ARMOS_LV1, ENEMY_ARMOS_LV1, ENEMY_ARMOS_LV1, ENEMY_ARMOS_LV2, ENEMY_ARMOS_LV2, ENEMY_ARMOS_LV2}); break;
               // case 5: setEnemies({ENEMY_BUBBLE_TEMP_LV1, ENEMY_THIEF_LV1, ENEMY_THIEF_LV1, ENEMY_THIEF_LV1, ENEMY_THIEF_LV1, ENEMY_THIEF_LV1}); break;
               // case 6:
               //    playBossTheme(arenaListNum);
               //    setEnemies({ENEMY_THIEF_BOSS});
               //    shouldReturn = true;
               //    break;
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
         until(Hero->Action == LA_SWIMMING && Hero->Action == LA_DIVING && Screen->ComboT[ComboAt(Hero->X + 8, Hero->Y + 12)] == CT_SHALLOWWATER) Waitframe();

         int maxDamageTimer = 120;
         int damageTimer = maxDamageTimer;

         while (Hero->Action == LA_SWIMMING || Hero->Action == LA_DIVING || (Screen->ComboT[ComboAt(Hero->X + 8, Hero->Y + 12)] == CT_SHALLOWWATER)) {
            damageTimer--;

            if (damageTimer <= 0)
               if (Screen->ComboT[ComboAt(Hero->X + 8, Hero->Y + 12)] == CT_SHALLOWWATER || Hero->Action == LA_SWIMMING) {
                  Hero->HP -= 8;
                  Audio->PlaySound(Choose(SFX_HERO_HURT_1, SFX_HERO_HURT_2, SFX_HERO_HURT_3));
                  damageTimer = maxDamageTimer;
               }

            Waitframe();
         }
      }
   }
} // end

// clang-format off
@Author("Deathrider365"),
@InitD0("cooldownAndDamage"),
@InitDHelp0("Time in frames between shots . damage"),
@InitD1("variance"),
@InitDHelp1("modifier on the cooldown, high.low"),
@InitD2("trigger"),
@InitDHelp2("trigger to stop this thrower type.value"),
@InitD3("throwsItem"),
@InitDHelp3("if what is thrown is an item"),
@InitD4("projectile"),
@InitDHelp4("EWeapon (use EW_*) EWeapon.weapon type (weapon type is the custom one I have AE_*)"),
@InitD5("spriteId"),
@InitDHelp5("Custom sprite to use"),
@InitD6("hasArc"),
@InitDHelp6("Whether the projectile travels straight to the player or is lobbed"),
@InitD7("sfx"),
@InitDHelp7("sound effect played when shot")
ffc script Thrower {
   // clang-format on
   void run(int cooldownAndDamage, int variance, int trigger, bool throwsItem, int projectile, int spriteId, int hasArc, int sfx = 0) {
      int cooldown = !Floor(cooldownAndDamage) ? 120 : Floor(cooldownAndDamage);
      int damage = !((cooldownAndDamage % 1) / 1L) ? 120 : ((cooldownAndDamage % 1) / 1L);

      CONFIG COOLDOWN = cooldown;

      int lowVariance = Floor(variance);
      int highVariance = -(variance % 1) / 1L;

      int projectileId = Floor(projectile);
      int projectileType = (projectile % 1) / 1L;

      loop () {
         if (wasTriggered(trigger))
            Quit();

         unless(cooldown) {
            if (throwsItem) {
               if (int scr = CheckItemSpriteScript("ArcingItemSprite")) {
                  itemsprite it = RunItemSpriteScriptAt(projectileId, scr, this->X, this->Y, {Angle(this->X + 8, this->Y + 8, Hero->X + 8, Hero->Y + 8), 5, -1, 0});

                  it->Pickup |= IP_TIMEOUT;
               }
            }
            else {
               if (projectileType < 0 || projectileType >= AE_DEBUG)
                  projectileType = AE_DEBUG;

               eweapon projectile = FireEWeaponAtHero(projectileId, CenterX(this) - 8, CenterY(this) - 8, true, 255, damage, spriteId, sfx, Game->GetEWeaponScript("ArcingWeapon"),
                  {-1, 0, projectileType, 0, 8, 0, false}
               );
               projectile->Unblockable = UNBLOCK_ALL;
            }

            cooldown = COOLDOWN + Rand(lowVariance, highVariance);
         }

         cooldown--;
         Waitframe();
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
@InitDHelp0("0: Up\n 1: Down\n 2: Left\n 3: Right"),
@InitD1("side"),
@InitDHelp1("0: Top\n 1: Bottom\n 2: Left\n 3: Right")
ffc script FaceLinkOnEntrance {
   // clang-format on

   void run(int dir, int side) {
      // if ((HeroIsScrollingOrWarping() && Hero->Y >= 168 || Hero->Y < 16 && !HeroIsScrollingOrWarping()) && dir == DIR_DOWN) //TODO make this smarter
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

      loop () {
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
@Author("Deathrider365"),
@InitD0("itemId"),
@InitDHelp0("ItemId to check"),
@InitD1("screenD"),
@InitDHelp1("screenD to set on THIS screen"),
@InitD2("invert"),
@InitDHelp2("whether to UNSET if you have the item")
ffc script SetScreenDIfHasItem {
   // clang-format on
   void run(int itemId, int screenD, int invert) {
      loop() {
         if (Hero->Item[itemId]) {
            if (invert > -1)
               setScreenD(screenD, false);
            else
               setScreenD(screenD, true);
         }
         else
            if (invert > -1)
               setScreenD(screenD, true);
            else
               setScreenD(screenD, false);

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
         Hero->Dir = OppositeDir(dir);
         Hero->Jump = 2;
         Audio->PlaySound(SFX_JUMP);
         int tx = this->X + DirX(OppositeDir(dir)) * 16;
         int ty = this->Y + DirY(OppositeDir(dir)) * 16;
         int angle = Angle(this->X, this->Y, tx, ty);
         int dist = Distance(this->X, this->Y, tx, ty);
         int linkX = Hero->X;
         int linkY = Hero->Y;
         for (int i = 0; i < 26; i++) {
            linkX += VectorX(dist / 26, angle);
            linkY += VectorY(dist / 26, angle);
            NoAction();
            Waitdraw();
            Hero->X = linkX;
            Hero->Y = linkY;
            Waitframe();
         }
         Hero->X = tx;
         Hero->Y = ty;
         this->Data = Floor(this->Data / 4) * 4 + dir;
      }
      this->Flags[FFCF_SOLID] = true;
      int timer[1];

      if (this->Flags[FFCF_PRELOAD])
         Waitframe();

      while (true) {
         if (PressAgainstCart(this, timer)) {
            this->Flags[FFCF_SOLID] = false;
            Hero->Dir = AngleDir4(Angle(Hero->X, Hero->Y, this->X, this->Y - MINECART_LINKYOFFSET));
            Hero->Jump = 2;
            Audio->PlaySound(SFX_JUMP);
            int tx = this->X;
            int ty = this->Y - MINECART_LINKYOFFSET;
            int angle = Angle(Hero->X, Hero->Y, tx, ty);
            int dist = Distance(Hero->X, Hero->Y, tx, ty);
            int linkX = Hero->X;
            int linkY = Hero->Y;
            for (int i = 0; i < 26; i++) {
               linkX += VectorX(dist / 26, angle);
               linkY += VectorY(dist / 26, angle);
               NoAction();
               Waitdraw();
               Hero->X = linkX;
               Hero->Y = linkY;
               Waitframe();
            }
            Hero->X = tx;
            Hero->Y = ty;

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
      if (Hero->Z > 0 || Hero->FakeZ > 0)
         return false;
      bool pressing;
      if (Abs(Hero->X - this->X) <= 8 && Hero->Y > this->Y && Hero->Y <= this->Y + 8 && Hero->InputUp)
         pressing = true;
      if (Abs(Hero->X - this->X) <= 8 && Hero->Y >= this->Y - 16 && Hero->Y < this->Y && Hero->InputDown)
         pressing = true;
      if (Hero->X <= this->X + 16 && Hero->X > this->X && Hero->Y >= this->Y - 8 && Hero->Y <= this->Y && Hero->InputLeft)
         pressing = true;
      if (Hero->X >= this->X - 16 && Hero->X < this->X && Hero->Y >= this->Y - 8 && Hero->Y <= this->Y && Hero->InputRight)
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
      int x = Hero->X;
      int y = Hero->Y;

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
         x = Hero->X;
         y = Hero->Y;
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
      // Hero->ItemA = ITEM_SWORD3;
      // Hero->ItemB = ITEM_BRANG2;
   }
}

// clang-format off
@InitD0("radius"),
@InitDHelp0("radius in pixels"),
@InitD1("speed"),
@InitDHelp1("speed of rotation in degreess"),
@InitD2("angle"),
@InitDHelp2("starting position in degrees. If negative it will be random"),
@InitD3("radius2"),
@InitDHelp3("radius2, this is used for the Y Axis, if set it will turn into a oval"),
@InitD4("angle2"),
@InitDHelp4("this will cause the oval to be rotated at it's center"),
@Author("Mero")
ffc script CircularMotion {
   // clang-format on
    void run(int radius, int speed, int angle, int radius2, int angle2) {
        if (radius2 == 0) radius2 = radius; //Circle
        if (angle < 0) angle = Rand(360); //Random Start
        int cx = this->X;
        int cy = this->Y;

        loop() {
            angle += speed;
            if (angle < -360) angle += 360; //Wrap if below -360.
            else if (angle > 360) angle -= 360; //Wrap if above 360.
            if (angle2 == 0) {
               this->X = cx + radius * Cos(angle);
               this->Y = cy + radius2 * Sin(angle);
            }
            else { //Rotate at center.
                this->X = cx + radius * Cos(angle) * Cos(angle2) - radius2 * Sin(angle) * Sin(angle2);
                this->Y = cy + radius2 * Sin(angle) * Cos(angle2) + radius * Cos(angle) * Sin(angle2);
            }
            Waitframe();
        }
    }
}

@InitD0("dir"),
@InitDHelp0("Up = 0,\n Down = 1,\n Left = 2,\n Right = 3"),
@InitD1("tolerance"),
@InitDHelp1("How many pixels off will it still shoot: https://github.com/ZQuestClassic/ZQuestClassic/blob/4774704ceff07bbe524b1de6e71d297843f99d00/resources/include/bindings/eweapon.zh#L2"),
@InitD2("eweaponIdAndRotate"),
@InitDHelp2("Weapon type id . rotate"),
@InitD3("damage"),
@InitDHelp3("Damage"),
@InitD4("sprite"),
@InitDHelp4("The sprite to use for the weapon.\n 0 = Pull from weapon"),
@InitD5("step"),
@InitDHelp5("How fast is the weapon"),
@InitD6("shotCooldown"),
@InitDHelp6("Time in frames between each shot"),
@InitD7("ignoreSolidity"),
@InitDHelp7("Does the weapon ignore solidity? \n 0 = Yes \n 1 = WFLAG_STOP_ON_SOLID \n 2 = WFLAG_BREAKS_ON_SOLID"),
@Author("Deathrider365")
ffc script LoSShooter {
   void run(int dir, int tolerance, int eweaponIdAndRotate, int damage, int spriteData, int step, int shotCooldown, int ignoreSolidity) {
      int cooldown = 0;
      int weaponId = Floor(eweaponIdAndRotate);
      bool rotate = ((eweaponIdAndRotate % 1) / 1L);
      int weaponSprite = spriteData ? spriteData : -1;
      int originalCombo = this->Data;

      loop () {
         if (this->Data != originalCombo) Quit();

         int angle = lineOfSightAngle(this, dir, tolerance);

         if (angle > 0) {
            if (cooldown == 0) {
               eweapon weapon = FireEWeaponDegAngle(weaponId, this->X, this->Y, angle, step, damage, weaponSprite, SFX_FIRE);
               weapon->Unblockable = UNBLOCK_ALL;

               if (rotate)
                  EnemyNamespace::FourWayFlip(weapon);

               switch (ignoreSolidity) {
                  case 1:
                     weapon->Flags[WFLAG_STOP_ON_SOLID] = true;
                     weapon->Flags[WFLAG_TEMP_IGNORE_SOLID] = true;
                     break;
                  case 2:
                     weapon->Flags[WFLAG_BREAKS_ON_SOLID] = true;
                     weapon->Flags[WFLAG_TEMP_IGNORE_SOLID] = true;
                     break;
               }

               cooldown = shotCooldown;
            }

            cooldown--;
         }

         Waitframe();
      }
   }

   int lineOfSightAngle(ffc this, int dir, int tolerance) {
      switch(dir) {
         case DIR_UP: {
            if (Hero->Y < this->Y && Abs((Hero->X + 8) - (this->X + 8)) < tolerance)
               return 270;
            break;
         }
         case DIR_DOWN: {
            if (Hero->Y > this->Y && Abs((Hero->X + 8) - (this->X + 8)) < tolerance)
               return 90;
            break;
         }
         case DIR_LEFT: {
            if (Hero->X < this->X && Abs((Hero->Y + 8) - (this->Y + 8)) < tolerance)
               return 180;
            break;
         }
         case DIR_RIGHT: {
            if (Hero->X > this->X && Abs((Hero->Y + 8) - (this->Y + 8)) < tolerance)
               return 360;
            break;
         }
      }

      return -1;
   }
}

@InitD0("proximity"),
@InitDHelp0("Distance in pixels away Link will be from this to start shooting"),
@InitD1("tolerance"),
@InitDHelp1("How many pixels off will it still shoot: https://github.com/ZQuestClassic/ZQuestClassic/blob/4774704ceff07bbe524b1de6e71d297843f99d00/resources/include/bindings/eweapon.zh#L2"),
@InitD2("eweaponId"),
@InitDHelp2("Weapon type id"),
@InitD3("damage"),
@InitDHelp3("Damage"),
@InitD4("sprite"),
@InitDHelp4("The sprite to use for the weapon.\n 0 = Pull from weapon"),
@InitD5("step"),
@InitDHelp5("How fast is the weapon"),
@InitD6("shotCooldown"),
@InitDHelp6("Time in frames between each shot"),
@InitD7("ignoreSolidity"),
@InitDHelp7("Does the weapon ignore solidity? \n 0 = Yes \n 1 = WFLAG_STOP_ON_SOLID \n 2 = WFLAG_BREAKS_ON_SOLID"),
@Author("Deathrider365")
ffc script Beamos {
   void run(int proximity, int tolerance, int eweaponId, int damage, int spriteData, int step, int shotCooldown, int ignoreSolidity) {
      int cooldown = shotCooldown;
      int weaponSprite = spriteData ? spriteData : -1;
      int originalCombo = this->Data;

      loop () {
         if (this->Data != originalCombo) Quit();
         if (Distance(this->X, this->Y, Hero->X, Hero->Y) < proximity /*&& it sees link*/) { //TODO enhance to sync up with a rotating combo
            if (cooldown == 0) {
               eweapon weapon = FireEWeaponAtHero(eweaponId, this->X, this->Y, true, step, damage, weaponSprite, SFX_FIRE);
               weapon->Unblockable = UNBLOCK_ALL;

               this->MoveFlags[NPCMV_CAN_PITFALL] = false;

               switch (ignoreSolidity) {
                  case 1:
                     weapon->Flags[WFLAG_STOP_ON_SOLID] = true;
                     weapon->Flags[WFLAG_TEMP_IGNORE_SOLID] = true;
                     break;
                  case 2:
                     weapon->Flags[WFLAG_BREAKS_ON_SOLID] = true;
                     weapon->Flags[WFLAG_TEMP_IGNORE_SOLID] = true;
                     break;
               }

               cooldown = shotCooldown;
            }

            cooldown--;
         }

         Waitframe();
      }
   }
}

@Author("Deathrider365")
ffc script HideEnemiesUntilSecrets {
   void run(bool screenIsRemote, int map, int screen) {
      if (screenIsRemote && (!map || !screen))
         Trace("screenIsRemote but no map or screen was provided");
      else {
         until (Screen->State[ST_SECRET] || !(screenIsRemote && Game->LoadMapData(map, screen)->State[ST_SECRET])) Waitframe();

         if (Screen->State[ST_SECRET])
            Screen->Pattern = PATTERN_STANDARD;
         else
            Screen->Pattern = PATTERN_NO_SPAWNING;
      }
   }
}

@Author("Deathrider365"),
@InitD0("condition"),
@InitDHelp0("condition to trigger"),
@InitD1("conditionValue"),
@InitDHelp1("where applicable, the value to check"),
@InitD2("dmapId"),
@InitDHelp2("dmap in question"),
@InitD3("oldMusicId"),
@InitDHelp3("old music id to check"),
@InitD4("newMusicId"),
@InitDHelp4("new music id to assign")
ffc script SetLevel8Music {
   void run (int condition, int conditionValue, int dmapId, int oldMusicData, int newMusicData) {
      loop() {
         if (Game->LevelStates[Game->CurLevel] & (1Lb << (conditionValue)) && Game->LoadDMapData(dmapId)->Music == Audio->LoadMusicData(oldMusicData)) {
            until (Hero->Z == 0) Waitframe();

            Game->LoadDMapData(dmapId)->Music = Audio->LoadMusicData(newMusicData);
            Game->LoadDMapData(dmapId + 1)->Music = Audio->LoadMusicData(newMusicData);
            Game->LoadDMapData(dmapId + 2)->Music = Audio->LoadMusicData(newMusicData);
            Game->LoadDMapData(dmapId + 3)->Music = Audio->LoadMusicData(newMusicData);
            Game->LoadDMapData(dmapId + 4)->Music = Audio->LoadMusicData(newMusicData);
            Game->LoadDMapData(dmapId + 5)->Music = Audio->LoadMusicData(newMusicData);

            if (!getScreenD(0)) {
               Screen->Message(1017);
               setScreenD(0, true);
            }

            Quit();
         }

         Waitframe();
      }
   }
}

@Author("Deathrider365")
ffc script ForceLinkInLv9Boss {
   void run() {
      while (HeroIsScrollingOrWarping()) Waitframe();

      if (Game->LoadMapData(171, 0x3E)->State[ST_SECRET]) Quit();

      while (Hero->Y > 224) {
         NoAction();
         Hero->InputUp = true;
         Waitframe();
      }

      //Shutter closes
      setScreenD(1, true);

      while (!Game->LoadMapData(171, 0x3E)->State[ST_SECRET]) Waitframe();

      //Shutters open
      setScreenD(1, false);
   }
}

//TODO Remove
ffc script DrawF4Palette {
   void run() {
      Game->LoadDMapData(Game->CurDMap)->Palette = Screen->Palette;
   }
}

@Author("Deathrider365")
ffc script SideviewElevator {
   void run (int elevatorIndex, int speed, int distance, int direction, int upModifier, int csetMod, bool ignoreInputAtHome) {
      int thisData = this->Data;
      int thisCSet = this->CSet;
      bool flash;

      int modifiedDirection = direction;

      if (!elevatorsAtHome[elevatorIndex]) {
         switch(modifiedDirection) {
            case DIR_UP:
               modifiedDirection = DIR_DOWN;
               this->Y = this->Y - distance;
               break;
            case DIR_DOWN:
               modifiedDirection = DIR_UP;
               this->Y = this->Y + distance;
               break;
            case DIR_LEFT:
               modifiedDirection = DIR_RIGHT;
               this->X = this->X - distance;
               break;
            case DIR_RIGHT:
               modifiedDirection = DIR_LEFT;
               this->X = this->X + distance;
               break;
         }
      }

      loop () {
         this->Data = thisData;

         if (((Abs((Hero->X + 8) - (this->X + (this->TileWidth * 8))) < 8) && Abs(Hero->Y - this->Y) == 16)) {
            if (gameframe % 10 == 0)
               this->CSet = this->CSet == thisCSet ? csetMod : thisCSet;

            bool takeTheVator = false;

            if (!elevatorsAtHome[elevatorIndex] && !ignoreInputAtHome)
               takeTheVator = true;
            else if (ignoreInputAtHome && elevatorsAtHome[elevatorIndex])
               takeTheVator = true;
            else if (Input->Button[modifiedDirection])
               takeTheVator = true;

            if (takeTheVator) {
               //Taking the elevator in in the direction of direction
               Audio->PlaySoundEx(SFX_SM_ELEVATOR_LOOP, 100, 0, 0, true);

               for (int i = distance; i > 0; --i) {
                  if (gameframe % 10 == 0)
                     this->CSet = this->CSet == thisCSet ? csetMod : thisCSet;

                  if (modifiedDirection == DIR_UP || modifiedDirection == DIR_DOWN)
                     Hero->X = (this->X + (this->TileWidth * 8)) - 8;

                  Hero->Dir = DIR_DOWN;
                  NoAction();

                  switch(modifiedDirection) {
                     case DIR_UP:
                        this->Y -= speed;
                        break;
                     case DIR_DOWN:
                        this->Y += speed;
                        break;
                     case DIR_RIGHT:
                        this->X += speed;
                        break;
                     case DIR_LEFT:
                        this->X -= speed;
                        break;
                  }

                  // while (HeroIsScrollingOrWarping()) { logic to handle 2 elevators appearing when scrolling
                  //    this->Data = CMB_INVIS;
                  //    Waitframe();
                  // }

                  Waitframe();
               }

               if (modifiedDirection == DIR_UP)
                  this->Y += upModifier;

               //Arrived at your destination, end elevator sound and reverse activation direction
               Audio->EndSound(SFX_SM_ELEVATOR_LOOP);
               elevatorsAtHome[elevatorIndex] = !elevatorsAtHome[elevatorIndex];

               switch(modifiedDirection) {
                  case DIR_UP:
                     modifiedDirection = DIR_DOWN;
                     break;
                  case DIR_DOWN:
                     modifiedDirection = DIR_UP;
                     break;
                  case DIR_LEFT:
                     modifiedDirection = DIR_RIGHT;
                     break;
                  case DIR_RIGHT:
                     modifiedDirection = DIR_LEFT;
                     break;
               }

               if (!elevatorsAtHome[elevatorIndex]) Waitframes(5);
            }
         }
         else
            this->CSet = thisCSet;

         Waitframe();
      }
   }
}

@InitD0("portalId"),
@InitDHelp0("The id that connects this portal to the other"),
@Author("Deathrider")
ffc script Portal {
   void run(int portalId) { //TODO would be nice to handle collision with portal sphere projectiles too...
      CONFIG CMB_DORMANT_PORTAL = this->Data;
      CONFIG CMB_ACTIVE_PORTAL = 8736;

      loop () {
         while (this->Data == CMB_DORMANT_PORTAL)
            Waitframe();

         if (Abs(Hero->X - this->X) < 4 && Abs(Hero->Y - this->Y) < 4) {
            ffc otherPortal;

            for (int i = 1; i <= MAX_FFC; ++i) {
               otherPortal = Screen->LoadFFC(i);

               if (otherPortal->Script == Game->GetFFCScript("Portal") && otherPortal->ID != this->ID && otherPortal->InitD[0] == portalId) {
                  Hero->X = otherPortal->X;
                  Hero->Y = otherPortal->Y;
                  break;
               }
            }

            this->Data = CMB_DORMANT_PORTAL;
            otherPortal->Data = CMB_DORMANT_PORTAL;

            while (Abs(Hero->X - otherPortal->X) < 8 && Abs(Hero->Y - otherPortal->Y) < 8)
               Waitframe();
         }

         Waitframe();
      }
   }
}

ffc script RisingFallingLava {
   void run(int layer, int yLevel, int refMap, int refScreen) {
      loop() {
         // for (int x = 0; x < Region->ScreenWidth; ++x) {
         //    for (int y = 0; y < Region->ScreenHeight; ++y) {
         //       int x2 = x * 256;
         //       int y2 = Floor(yLevel) + y * 176;

         //       if (x2 >= Viewport->X && y2 >= Viewport->Y && x2 <= Viewport->X + 255 && y2 <= Viewport->Y + 175) {
         //          if (y2 == 0)
         //             Screen->DrawLayer(layer, refMap, refScreen, 0, x2, y2, 0, OP_TRANS);
         //          else
         //             Screen->DrawLayer(layer, refMap, refScreen + 16, 0, x2, y2, 0, OP_TRANS);
         //       }
         //    }
         // }

         Waitframe();
      }
   }
}

@InitD0("itemId"),
@InitDHelp0("ItemId to give on chest state"),
@InitD1("state"),
@InitDHelp1("0 = Chest \n1 = Lockblock"),
@Author("Deathrider")
ffc script GiveItemOnState {
   void run(int itemId, int state) {
      if (Hero->Item[itemId]) Quit();

      loop () {
         if ((state == 0 && Screen->State[ST_CHEST]) || (state == 1 && Screen->State[ST_LOCKBLOCK]))
            Hero->Item[itemId] = true;

         Waitframe();
      }
   }
}

@InitD0("message"),
@InitDHelp0("Message stating that this is an Auri Library book that needs to be returned"),
@InitD1("screenD"),
@InitDHelp1("0-18 but CANNOT be 1"),
@Author("Deathrider")
ffc script LoreBook {
   void run(int message, int screenD) {
      if (getScreenD(16, 0x43, screenD)) Quit();

      waitForTalking(this);

      Screen->Message(message);
      setScreenD(16, 0x43, screenD, true);
      Quit();
   }
}

@Author("Deathrider")
ffc script LoreBookshelf {
   void run(int message, int screenD) {
      if (!getScreenD(screenD)) Quit();

      loop() {
         waitForTalking(this, true);
         Screen->Message(message);
         Waitframe();
      }
   }
}