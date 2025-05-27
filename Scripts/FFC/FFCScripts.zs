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
      Game->LoadDMapData(Game->CurDMap)->GetMusic(areaMusic);
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
                        Audio->PlaySound(sfx);
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
         for (i = Screen->NumEWeapons; i >= 1; i--) {
            eweapon e = Screen->LoadEWeapon(i);

            // Only fire weapons can burn oil/bushes
            if ((e->ID == EW_FIRE || e->ID == EW_FIRE2 || e->OriginalTile == 800) && GetHighestLevelItemOwned(IC_CANDLE) != 158) {
               c = ComboAt(CenterX(e), CenterY(e));
               // Check to make sure it isn't already burning

               if (burnTimers[c] <= 0) {
                  // Check if oil is allowed and if the combo is a water combo
                  if (!noOil && OilBush_IsWater(c)) {
                     if (SFX_OIL_BURN > 0)
                        Audio->PlaySound(SFX_OIL_BURN);

                     burnTimers[c] = OILBUSH_OIL_DURATION;
                     burnTypes[c] = 0; // Mark as an oil burn
                  }
                  // Else check if bushes are allowd and if the combo is a bush
                  else if (!noBushes && OilBush_IsBush(c)) {
                     if (SFX_BUSH_BURN > 0)
                        Audio->PlaySound(SFX_BUSH_BURN);

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
            for (i = Screen->NumLWeapons; i >= 1; i--) {
               lweapon l = Screen->LoadLWeapon(i);
               // Only fire weapons can burn oil/bushes
               if (l->ID == LW_FIRE) {
                  c = ComboAt(CenterX(l), CenterY(l));
                  // Check to make sure it isn't already burning
                  if (burnTimers[c] <= 0) {
                     // Check if oil is allowed and if the combo is a water combo
                     if (!noOil && OilBush_IsWater(c)) {
                        if (SFX_OIL_BURN > 0)
                           Audio->PlaySound(SFX_OIL_BURN);

                        burnTimers[c] = OILBUSH_OIL_DURATION;
                        burnTypes[c] = 0; // Mark as an oil burn
                     }
                     // Else check if bushes are allowd and if the combo is a bush
                     else if (!noBushes && OilBush_IsBush(c)) {
                        if (SFX_BUSH_BURN > 0)
                           Audio->PlaySound(SFX_BUSH_BURN);

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
                                 Audio->PlaySound(SFX_OIL_BURN);

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
                                 Audio->PlaySound(SFX_BUSH_BURN);

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
         default: return 6344;
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
                  mapDataLayer1->ComboD[i] = COMBO_INVIS;

               if (mapDataLayer2->ComboD[i] == 4362) {
                  mapDataLayer0->ComboD[i] = 4807;
               }
            }

            break;
         }

         Waitframe();
      }
   }
}

// clang-format off
ffc script LensTorches {
   // clang-format on

   void run() {
      // Get the revealed lens layer
      mapdata md = Game->LoadTempScreen(0);
      // int layer = Clamp(md->LensLayer - 15, 1, 6); // 15 = Hide Layer 6? Weird undocumented behavior thank you Zoria

      int drawLayer;
      // Because the screen flag hides the layer, we need to find the next closest to draw to
      // switch (layer) {
      //    case 1: drawLayer = 2; break;
      //    case 2: drawLayer = 1; break;
      //    case 3: drawLayer = 4; break;
      //    case 4: drawLayer = 3; break;
      //    case 5: drawLayer = 6; break;
      //    case 6: drawLayer = 5; break;
      // }

      for (int layer = 6; layer >= 0; --layer) {
         if (md->LensShows[layer] || md->LensHides[layer])
            continue;

         drawLayer = layer;
         break;
      }

      int comboSlot = Game->GetComboScript("TorchMarker");

      bitmap lenslayer = new bitmap(256, 176);
      lenslayer->Own();
      bitmap lensmask = new bitmap(256, 176);
      lensmask->Own();

      while (true) {
         lenslayer->Clear(0);
         // lensmask gets cleared to a color because circles are erased from it rather than added
         lensmask->ClearToColor(0, C_LENSBITMAPMARKER);

         for (int i = 1; i <= 6; ++i) {
            if (!md->LensHides[i] && i != drawLayer)
               continue;

            mapdata md = Game->LoadTempScreen(i);

            for (int j = 0; j < 176; ++j)
               lenslayer->FastCombo(0, ComboX(j), ComboY(j), md->ComboD[j], md->ComboC[j]);
         }

         // Draw circles for combos on layers 0-4
         for (int i = 0; i <= 4; ++i) {
            mapdata md = Game->LoadTempScreen(i);

            for (int j = 0; j < 176; ++j) {
               combodata cd = Game->LoadComboData(md->ComboD[j]);
               if (cd->Script == comboSlot) {
                  DrawLensCircle(lensmask, ComboX(j) + 8, ComboY(j) + 8, cd->InitD[0]);
               }
            }
         }

         // Draw circles for FFCs
         for (int i = 1; i <= MAX_FFC; ++i) {
            ffc f = Screen->LoadFFC(i);
            if (f->Data) {
               combodata cd = Game->LoadComboData(f->Data);
               if (cd->Script == comboSlot) {
                  DrawLensCircle(lensmask, f->X + 8, f->Y + 8, cd->InitD[0]);
               }
            }
         }

         // Draw the mask over the layer
         lensmask->Blit(0, lenslayer, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_NORMAL, 0, true);
         // Replace colors from the mask
         lenslayer->ReplaceColors(0, 0x00, C_LENSBITMAPMARKER, C_LENSBITMAPMARKER);

         lenslayer->Blit(drawLayer, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_NORMAL, 0, true);

         Waitframe();
      }
   }
   // This draws a circle to the bitmap imitating the lens of truth
   void DrawLensCircle(bitmap b, int x, int y, int rad) {
      b->Circle(0, x, y, rad, 0x00, 1, 0, 0, 0, true, OP_OPAQUE);
      b->Circle(0, x, y, rad + 2, 0x00, 1, 0, 0, 0, false, OP_OPAQUE);
      b->Circle(0, x, y, rad + 5, 0x00, 1, 0, 0, 0, false, OP_OPAQUE);
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
      if (Screen->State[ST_SECRET]) {
         Quit();
      }

      int goronsSaved = 0;

      while (true) {
         if (getScreenD(67, 0x13, 0)) {
            setScreenD(0, true);
            ++goronsSaved;
         }
         if (getScreenD(67, 0x44, 1)) {
            setScreenD(1, true);
            ++goronsSaved;
         }
         if (getScreenD(68, 0x41, 2)) {
            setScreenD(2, true);
            ++goronsSaved;
         }
         if (getScreenD(68, 0x14, 3)) {
            setScreenD(3, true);
            ++goronsSaved;
         }
         if (getScreenD(69, 0x12, 4)) {
            setScreenD(4, true);
            ++goronsSaved;
         }
         if (getScreenD(69, 0x75, 5)) {
            setScreenD(5, true);
            ++goronsSaved;
         }
         if (goronsSaved == 6) {
            Screen->TriggerSecrets();
            Screen->State[ST_SECRET] = true;
            Audio->PlaySound(SFX_SECRET);
         }

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
      mapdata mapData = Game->LoadMapData(map, screen);

      until(getScreenD(screenD)) {
         if (mapData->State[ST_SECRET]) {
            setScreenD(screenD, true);
         }
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
         this->Data = FFCS_INVISIBLE_COMBO;
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
      this->Data = FFCS_INVISIBLE_COMBO;
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
