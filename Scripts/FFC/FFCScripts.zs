// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ General FFC Scripts~~~~~~~~~~~~~~~~~~~~~~~~~~~//

// clang-format off
@Author("Deathrider365") 
ffc script Debug {
   // clang-format on

   void run() {
      while (true) {
         Waitframe();
      }
   }
}

// clang-format off
@Author("EmilyV99")
  ffc script ContinuePoint {
   // clang-format on

   void run(int dmap, int scrn) {
      unless(dmap || scrn) {
         dmap = Game->GetCurDMap();
         scrn = Game->GetCurScreen();
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
      if (!Screen->State[ST_ITEM] && !Screen->State[ST_CHEST] && !Screen->State[ST_LOCKEDCHEST] && !Screen->State[ST_BOSSCHEST] && !Screen->State[ST_SPECIALITEM] && (Game->LItems[Game->GetCurLevel()] & LI_COMPASS))
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
      Game->GetDMapMusicFilename(Game->GetCurDMap(), areaMusic);
      Audio->PlayEnhancedMusic(areaMusic, 0);

      Quit();
   }
}

// clang-format off
@Author("Deathrider365")
 ffc script BattleArena {
   // clang-format on

   void run(int arenaListNum, int screenD, int map, int screen, int setScreenDOnOtherScreen) {
      unless(Hero->Item[191]) {
         Screen->TriggerSecrets();
         setScreenD(screenD, true);
         Quit();
      }

      setScreenD(screenD, false);
      Hero->Item[191] = false;

      int round = 0;

      until(spawnEnemies(arenaListNum, round++)) {
         while (EnemiesAlive())
            Waitframe();

         Waitframes(120);
      }

      while (EnemiesAlive())
         Waitframe();

      Screen->TriggerSecrets();
      setScreenD(screenD, true);

      if (map && screen) {
         mapdata mapData = Game->LoadMapData(map, screen);
         mapData->State[ST_SECRET] = true;
         Audio->PlaySound(SFX_SECRET);
      }

      if (setScreenDOnOtherScreen) {
         setScreenD(map, screen, setScreenDOnOtherScreen, true);
      }

      char32 areaMusic[256];
      Game->GetDMapMusicFilename(Game->GetCurDMap(), areaMusic);
      Audio->PlayEnhancedMusic(areaMusic, 0);
   }

   bool spawnEnemies(int arenaListNum, int round) {
      int enemyList[50];
      bool shouldReturn;

      switch (arenaListNum) {
         case 0: {
            Screen->Pattern = PATTERN_CEILING;

            switch (round) {
               case 0:
                  playBattleTheme(arenaListNum);
                  setEnemies({ENEMY_OCTOROCK_LV1_SLOW, ENEMY_OCTOROCK_LV1_SLOW, ENEMY_OCTOROCK_LV1_FAST, ENEMY_OCTOROCK_LV1_FAST, ENEMY_OCTOROCK_LV1_FAST, ENEMY_OCTOROCK_LV2_FAST});
                  break;
               case 1: setEnemies({ENEMY_MOBLIN_LV1, ENEMY_MOBLIN_LV1, ENEMY_MOBLIN_LV1, ENEMY_STALFOS_LV1, ENEMY_STALFOS_LV1, ENEMY_STALFOS_LV1, ENEMY_ROPE_LV1, ENEMY_ROPE_LV1}); break;
               case 2: setEnemies({ENEMY_MOBLIN_LV2, ENEMY_MOBLIN_LV2, ENEMY_OCTOROCK_LV2_FAST, ENEMY_OCTOROCK_LV2_FAST, ENEMY_OCTOROCK_LV2_FAST, ENEMY_GORIYA_LV1, ENEMY_GORIYA_LV1}); break;
               case 3: setEnemies({ENEMY_LEEVER_LV1_INSIDE, ENEMY_LEEVER_LV1_INSIDE, ENEMY_LEEVER_LV1_INSIDE, ENEMY_LEEVER_LV1_INSIDE, ENEMY_LEEVER_LV2_INSIDE, ENEMY_LEEVER_LV2_INSIDE, ENEMY_LEEVER_LV2_INSIDE}); break;
               case 4: setEnemies({ENEMY_CANDLEHEAD_LV1, ENEMY_CANDLEHEAD_LV1, ENEMY_CANDLEHEAD_LV1}); break;
               case 5:
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
               case 0:
                  playBattleTheme(arenaListNum);
                  setEnemies({ENEMY_MOBLIN_LV2, ENEMY_MOBLIN_LV2, ENEMY_MOBLIN_LV2, ENEMY_ROPE_LV2, ENEMY_ROPE_LV2, ENEMY_ROPE_LV2});
                  break;
               case 1: setEnemies({ENEMY_STALFOS_LV2, ENEMY_STALFOS_LV2, ENEMY_STALFOS_LV2, ENEMY_GORIYA_LV2, ENEMY_GORIYA_LV1, ENEMY_GORIYA_LV1}); break;
               case 2: setEnemies({ENEMY_BAT, ENEMY_BAT, ENEMY_BAT, ENEMY_BAT, ENEMY_BAT}); break;
               case 3: setEnemies({ENEMY_ARMOS_LV1, ENEMY_ARMOS_LV1, ENEMY_ARMOS_LV1, ENEMY_ARMOS_LV1, ENEMY_ARMOS_LV2, ENEMY_ARMOS_LV2, ENEMY_ARMOS_LV2}); break;
               case 4: setEnemies({ENEMY_BUBBLE_TEMP_LV1, ENEMY_BUBBLE_TEMP_LV1, ENEMY_THIEF_LV1, ENEMY_THIEF_LV1, ENEMY_THIEF_LV1, ENEMY_THIEF_LV1, ENEMY_THIEF_LV1}); break;
               case 5:
                  playBossTheme(arenaListNum);
                  setEnemies({ENEMY_THIEF_BOSS});
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
      }
   }

   void playBossTheme(int arenaListNum) {
      switch (arenaListNum) {
         case 0: Audio->PlayEnhancedMusic("Skies of Arcadia - Bombardment.ogg", 0); break;
         case 1: Audio->PlayEnhancedMusic("Otosan - Lord Rat Laureate Boss Battle.ogg", 0); break;
      }
   }
}

// clang-format off
@Author("Emily")
 ffc script DisableRadialTransparency {
   // clang-format on

   void run(int pos) {
      while (true) {
         disableTrans = Screen->ComboD[pos] ? true : false;
         Waitframe();
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
                        Game->PlaySound(sfx);
                     runEWeaponScript(projectile, scr, {-1, 0, projectileType});
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
@Author("EmilyV99")
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
      }
   }
}

// clang-format off
@Author("Moosh")
 ffc script BurningOilandBushes {
   // clang-format on

   // start constants
   const int OILBUSH_LAYER = 2;  // Layer to which burning is drawn
   const int OILBUSH_DAMAGE = 2; // Damage dealt by burning oil/bushes

   const int OILBUSH_CANTRIGGER = 1;           // Set to 1 if burning objects can trigger adjacent burn triggers
   const int OILBUSH_DAMAGEENEMIES = 1;        // Set to 1 if burning objects can damage enemies standing on them
   const int OILBUSH_BUSHESSTILLDROPITEMS = 1; // Set to 1 if burning bushes should still drop their items

   const int NPC_BUSHDROPSET = 177; // The ID of an Other type enemy with the tall grass dropset

   const int OILBUSH_OIL_DURATION = 180; // Duration oil burns for in frames
   const int OILBUSH_BUSH_DURATION = 60; // Duration bushes/grass burn for in frames

   const int OILBUSH_OIL_SPREAD_FREQ = 2;   // How frequently burning oil spreads (should be shorter than burn
                                            // duration)
   const int OILBUSH_BUSH_SPREAD_FREQ = 10; // How frequently burning bushes/grass spread

   const int CS_OIL_BURNING = 7;               // was 8 CSet for burning oil
   const int OILBUSH_ENDFRAMES_OILBURN = 4;    // Number of combos for oil burning out
   const int OILBUSH_ENDDURATION_OILBURN = 16; // Duration of the burning out animation

   const int CMB_BUSH_BURNING = 6344;           // First combo for burning oil
   const int CS_BUSH_BURNING = 0;               // CSet for burning oil (I set this to 0 since
                                                // the combos are 8 bit anyway)
   const int OILBUSH_ENDFRAMES_BUSHBURN = 4;    // Number of combos for bushes/grass burning out
   const int OILBUSH_ENDDURATION_BUSHBURN = 16; // Duration of the burning out animation

   const int SFX_OIL_BURN = 13;  // Sound when oil catches fire
   const int SFX_BUSH_BURN = 13; // Sound when bushes catch fire

   // EWeapon and LWeapon IDs used for burning stuff.
   const int EW_OILBUSHBURN = 40; // EWeapon ID. Script 10 by default
   const int LW_OILBUSHBURN = 9;  // LWeapon ID. Fire by default
   // end constants

   void run(int noOil, int noBushes, int advanceOil, int burnCSet) {
      int i;
      int j;
      int c;
      int ct;
      int burnTimers[176];
      int burnTypes[176];
      lweapon burnHitboxes[176];

      while (true) {
         // start Loop through all EWeapons
         for (i = Screen->NumEWeapons(); i >= 1; i--) {
            eweapon e = Screen->LoadEWeapon(i);

            // Only fire weapons can burn oil/bushes
            if ((e->ID == EW_FIRE || e->ID == EW_FIRE2 || e->OriginalTile == 800) && GetHighestLevelItemOwned(IC_CANDLE) != 158) {
               c = ComboAt(CenterX(e), CenterY(e));
               // Check to make sure it isn't already burning

               if (burnTimers[c] <= 0) {
                  // Check if oil is allowed and if the combo is a water combo
                  if (!noOil && OilBush_IsWater(c)) {
                     if (SFX_OIL_BURN > 0)
                        Game->PlaySound(SFX_OIL_BURN);

                     burnTimers[c] = OILBUSH_OIL_DURATION;
                     burnTypes[c] = 0; // Mark as an oil burn
                  }
                  // Else check if bushes are allowd and if the combo is a bush
                  else if (!noBushes && OilBush_IsBush(c)) {
                     if (SFX_BUSH_BURN > 0)
                        Game->PlaySound(SFX_BUSH_BURN);

                     burnTimers[c] = OILBUSH_BUSH_DURATION;
                     burnTypes[c] = 1;    // Mark as a bush burn
                     Screen->ComboD[c]++; // Advance to the next combo

                     // If item drops are allowed, create and kill a dummy enemy
                     if (OILBUSH_BUSHESSTILLDROPITEMS) {
                        npc n = CreateNPCAt(NPC_BUSHDROPSET, ComboX(c), ComboY(c));
                        n->HP = -1000;
                        n->DrawYOffset = -1000;
                     }
                  }
               }
            }
         } // end

         if (GetHighestLevelItemOwned(IC_CANDLE) != 158) {
            // start Loop through all LWeapons
            for (i = Screen->NumLWeapons(); i >= 1; i--) {
               lweapon l = Screen->LoadLWeapon(i);
               // Only fire weapons can burn oil/bushes
               if (l->ID == LW_FIRE) {
                  c = ComboAt(CenterX(l), CenterY(l));
                  // Check to make sure it isn't already burning
                  if (burnTimers[c] <= 0) {
                     // Check if oil is allowed and if the combo is a water combo
                     if (!noOil && OilBush_IsWater(c)) {
                        if (SFX_OIL_BURN > 0)
                           Game->PlaySound(SFX_OIL_BURN);

                        burnTimers[c] = OILBUSH_OIL_DURATION;
                        burnTypes[c] = 0; // Mark as an oil burn
                     }
                     // Else check if bushes are allowd and if the combo is a bush
                     else if (!noBushes && OilBush_IsBush(c)) {
                        if (SFX_BUSH_BURN > 0)
                           Game->PlaySound(SFX_BUSH_BURN);

                        burnTimers[c] = OILBUSH_BUSH_DURATION;
                        burnTypes[c] = 1;    // Mark as a bush burn
                        Screen->ComboD[c]++; // Advance to the next combo

                        if (OILBUSH_BUSHESSTILLDROPITEMS) { // If item drops are
                                                            // allowed, create and kill
                                                            // a dummy enemy
                           npc n = CreateNPCAt(NPC_BUSHDROPSET, ComboX(c), ComboY(c));
                           n->HP = -1000;
                           n->DrawYOffset = -1000;
                        }
                     }
                  }
               }
            } // end
         }

         // start Loop through all Combos (spread the fire around)
         for (i = 0; i < 176; i++) {
            // If you're on fire raise your hand
            if (burnTimers[i] > 0) {
               int burnDuration = OILBUSH_OIL_DURATION;
               int spreadFreq = OILBUSH_OIL_SPREAD_FREQ;
               int burnEndFrames = OILBUSH_ENDFRAMES_OILBURN;
               int burnEndDuration = OILBUSH_ENDDURATION_OILBURN;

               // Bushes have different burning properties from oil
               if (burnTypes[i] == 1) {
                  burnDuration = OILBUSH_BUSH_DURATION;
                  spreadFreq = OILBUSH_BUSH_SPREAD_FREQ;
                  burnEndFrames = OILBUSH_ENDFRAMES_BUSHBURN;
                  burnEndDuration = OILBUSH_ENDDURATION_BUSHBURN;
               }

               // start If it has been spreadFreq frames since the burning started,
               // spread to adjacent combos
               if (burnTimers[i] == burnDuration - spreadFreq) {
                  // Check all four adjacent combos
                  for (j = 0; j < 4; j++) {
                     c = i; // Target combo is set to i and moved based on direction or
                            // j

                     if (j == DIR_UP) {
                        c -= 16;
                        if (i < 16) // Prevent checking combo above along top edge
                           continue;
                     }
                     else if (j == DIR_DOWN) {
                        c += 16;

                        if (i > 159) // Prevent checking combo below along bottom edge
                           continue;
                     }
                     else if (j == DIR_LEFT) {
                        c--;

                        if (i % 16 == 0) // Prevent checking combo to the left along left edge
                           continue;
                     }
                     else if (j == DIR_RIGHT) {
                        c++; // Name drop

                        if (i % 16 == 15) // Prevent checking combo to the right along right edge
                           continue;
                     }

                     // If the adjacent combo isn't already burning
                     if (burnTimers[c] <= 0) {
                        // If the burning combo at i is oil
                        if (burnTypes[i] == 0) {
                           // If the adjacent combo is water, light it on fire
                           if (OilBush_IsWater(c)) {
                              if (SFX_OIL_BURN > 0)
                                 Game->PlaySound(SFX_OIL_BURN);

                              burnTimers[c] = OILBUSH_OIL_DURATION;
                              burnTypes[c] = 0;
                           }
                           // If there's an adjacent fire trigger and the script is
                           // allowed to trigger them
                           else if (ComboFI(c, CF_CANDLE1) && OILBUSH_CANTRIGGER) {
                              lweapon l = CreateLWeaponAt(LW_FIRE, ComboX(c),
                                  ComboY(c));         // Make a weapon on top of
                                                      // the combo to trigger it
                              l->CollDetection = 0;   // Turn off its collision
                              l->Step = 0;            // Make it stationary
                              l->DrawYOffset = -1000; // Make it invisible
                           }
                        }

                        // Otherwise if it's a bush
                        else if (burnTypes[i] == 1) {
                           // If the adjancent combo is a bush, light it on fire
                           if (OilBush_IsBush(c)) {
                              if (SFX_BUSH_BURN > 0)
                                 Game->PlaySound(SFX_BUSH_BURN);

                              burnTimers[c] = OILBUSH_BUSH_DURATION;
                              burnTypes[c] = 1;    // Mark as a bush burn
                              Screen->ComboD[c]++; // Advance to the next combo

                              // If item drops are allowed, create and kill a dummy enemy
                              if (OILBUSH_BUSHESSTILLDROPITEMS) {
                                 npc n = CreateNPCAt(NPC_BUSHDROPSET, ComboX(c), ComboY(c));
                                 n->HP = -1000;
                                 n->DrawYOffset = -1000;
                              }
                           }

                           // If there's an adjacent fire trigger and the script is
                           // allowed to trigger them
                           else if (ComboFI(c, CF_CANDLE1) && OILBUSH_CANTRIGGER) {
                              lweapon l = CreateLWeaponAt(LW_FIRE, ComboX(c),
                                  ComboY(c));         // Make a weapon on top of
                                                      // the combo to trigger it
                              l->CollDetection = 0;   // Turn off its collision
                              l->Step = 0;            // Make it stationary
                              l->DrawYOffset = -1000; // Make it invisible
                           }
                        }
                     }
                  }
               } // end
            }
         } // end

         // start Loop through all Combos again (actually draw the fire)
         for (i = 0; i < 176; i++) {
            // Check through all burning combos
            if (burnTimers[i] > 0) {
               // Only if enemy damaging is on
               if (OILBUSH_DAMAGEENEMIES) {
                  // If the hitbox for the tile isn't there, recreate it
                  if (!burnHitboxes[i]->isValid()) {
                     burnHitboxes[i] = CreateLWeaponAt(LW_SCRIPT10, ComboX(i), ComboY(i));
                     burnHitboxes[i]->Step = 0;                // Make it stationary
                     burnHitboxes[i]->Dir = 8;                 // Make it pierce
                     burnHitboxes[i]->DrawYOffset = -1000;     // Make it invisible
                     burnHitboxes[i]->Damage = OILBUSH_DAMAGE; // Make it deal damage
                  }
               }

               // If Link is close enough, create fire hitboxes
               if (Distance(ComboX(i), ComboY(i), Link->X, Link->Y) < 48) {
                  eweapon e = FireEWeapon(EW_SCRIPT10, ComboX(i), ComboY(i), 0, 0, OILBUSH_DAMAGE, 0, 0, EWF_UNBLOCKABLE);
                  // Make the hitbox invisible
                  e->DrawYOffset = -1000;
                  // Make the hitbox last for one frame
                  SetEWeaponLifespan(e, EWL_TIMER, 1);
                  SetEWeaponDeathEffect(e, EWD_VANISH, 0);
               }

               burnTimers[i]--; // This ain't no Bible. Bushes burn up eventually.

               if (burnTimers[i] == 0 && advanceOil && Screen->ComboT[i] == CT_SHALLOWWATER)
                  ++Screen->ComboD[i];

               int cmbBurn;

               // if(burnTypes[i] == 0)
               // {
               // Set animation for oil burning out
               // cmbBurn = CMB_OIL_BURNING + Clamp(OILBUSH_ENDFRAMES_OILBURN - 1 -
               // Floor(burnTimers[i] / (OILBUSH_ENDDURATION_OILBURN /
               // OILBUSH_ENDFRAMES_OILBURN)), 0, OILBUSH_ENDFRAMES_OILBURN - 1);
               // Screen->FastCombo(OILBUSH_LAYER, ComboX(i), ComboY(i), cmbBurn,
               // burnCSet ? burnCSet : CS_OIL_BURNING, 128);
               // }
               // else
               // {
               // Set animation for bush burning out
               // cmbBurn = CMB_BUSH_BURNING + Clamp(OILBUSH_ENDFRAMES_BUSHBURN - 1 -
               // Floor(burnTimers[i] /
               // (OILBUSH_ENDDURATION_BUSHBURN/OILBUSH_ENDFRAMES_BUSHBURN)), 0,
               // OILBUSH_ENDFRAMES_BUSHBURN - 1);
               Screen->FastCombo(OILBUSH_LAYER, ComboX(i), ComboY(i), getBurningCombo(), CS_BUSH_BURNING, 128);
               // }
            }
            else {
               // Clean up any leftover hitboxes
               if (burnHitboxes[i]->isValid())
                  burnHitboxes[i]->DeadState = 0;
            }
         } // end

         Waitframe();
      }
   }

   bool OilBush_IsWater(int pos) {
      int combo = Screen->ComboT[pos];
      return (combo == CT_SHALLOWWATER || combo == CT_WATER || combo == CT_SWIMWARP || combo == CT_DIVEWARP || (combo >= CT_SWIMWARPB && combo <= CT_DIVEWARPD));
   }

   bool OilBush_IsBush(int pos) {
      int combo = Screen->ComboT[pos];
      return (combo == CT_BUSHNEXT || combo == CT_BUSHNEXTC || combo == CT_TALLGRASSNEXT);
   }

   int getBurningCombo() {
      switch (GetHighestLevelItemOwned(IC_CANDLE)) {
         case 158: return 6344;
         case 10: return 6345;
         case 11: return 6346;
         case 150: return 6347;
      }
   }
}

// clang-format off
@Author("Deathrider365")
 ffc script FaceDownLinkFromTopOfScreen {
   // clang-format on

   void run() {
      Hero->Dir = DIR_DOWN;
   }
}

// clang-format off
@Author("Deathrider365")
 ffc script UnlockMoltenFloodedForgeBoss {
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