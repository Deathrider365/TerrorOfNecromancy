//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Bosses ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

namespace LeviathanNamespace {
   CONFIG CMB_WATERFALL = 9984;
   CONFIG CS_WATERFALL = 0;

   CONFIG VARS_HEADNPC = 0;
   CONFIG VARS_FLASHTIMER = 5;
   CONFIG VARS_HEAD_CENTERX = 1;
   CONFIG VARS_HEAD_CENTERY = 2;
   CONFIG VARS_FLIP = 3;
   CONFIG VARS_INITHP = 6;
   CONFIG VARS_BODYHP = 8;

   CONFIG NPC_LEVIATHANHEAD = 177;

   CONFIG SFX_RISE = 67;
   CONFIG SFX_WATERFALL = 26;
   CONFIG SFX_LEVIATHAN_ROAR = SFX_ROAR;
   CONFIG SFX_LEVIATHAN_SPLASH = SFX_SPLASH;
   CONFIG SFX_CHARGE = 35;
   CONFIG SFX_SHOT = 40;

   CONFIG ATTACK_WATERFALL = 0;
   CONFIG ATTACK_WATERBEAM = 1;
   CONFIG ATTACK_WATERCANNON = 2;
   CONFIG ATTACK_SIDE_SWIPE = 3;

   CONFIG DIFFICULTY_STAGE_1 = 0;
   CONFIG DIFFICULTY_STAGE_2 = 1;
   CONFIG DIFFICULTY_STAGE_3 = 2;

   CONFIG SPR_SPLASH = 93;
   CONFIG SPR_WATERBALL = 94;

   CONFIG MSG_BEATEN = 23;
   CONFIG MSG_LEVIATHAN_SCALE = 1052;

   Color C_CHARGE1 = C_DARKBLUE;
   Color C_CHARGE2 = C_SEABLUE;
   Color C_CHARGE3 = C_TAN;

   bool firstRun = true;

   // clang-format off
   @Author("Moosh, modified by Deathrider365")
   npc script Leviathan {
      // clang-format on

      void run() {
         int LEVIATHAN_WATERCANNON_DMG = 70;
         int LEVIATHAN_BURSTCANNON_DMG = 40;
         int LEVIATHAN_WATERFALL_DMG = 60;
         int LEVIATHAN_SIDESWIPE_DMG = 80;

         Hero->Dir = DIR_UP;

         waterfallBitmap = new bitmap(32, 176);

         untyped vars[16];

         npc head = CreateNPCAt(NPC_LEVIATHANHEAD, this->X, this->Y);

         vars[VARS_HEADNPC] = head;
         vars[VARS_BODYHP] = this->HP;
         vars[VARS_INITHP] = this->HP;

         this->HitXOffset = 64;
         this->HitYOffset = 32;
         this->HitWidth = 48;
         this->HitHeight = 48;
         this->X = 52;
         this->Y = 112;
         int attack;

         Audio->PlayEnhancedMusic(NULL, 0);

         for (int i = 0; i < 180; ++i) {
            disableLink();
            glideFrame(this, vars, 52, 112, 52, 32, 180, i);

            if (i % 40 == 0) {
               Audio->PlaySound(SFX_ROCKINGSHIP);
               Screen->Quake = 20;
            }

            LeviathanWaitframe(this, vars);
         }

         for (int i = 0; i < 120; ++i) {
            disableLink();

            if (i == 60) {
               Audio->PlaySound(SFX_ROAR);
               Audio->PlayEnhancedMusic("DS3 - Old Demon King.ogg", 0);
               if (firstRun) {
                  Screen->Message(802);
                  firstRun = false;
               }
            }

            LeviathanWaitframe(this, vars);
         }

         for (int i = 0; i < 20; ++i) {
            glideFrame(this, vars, 52, 32, 52, 112, 20, i);
            LeviathanWaitframe(this, vars);
         }

         Audio->PlaySound(SFX_SPLASH);
         splash(this->X + 64, 100);

         loop () {
            attack = attackChoice(this, vars);

            int riseAnim = 120;

            if (changeInDifficulty(this, vars) == DIFFICULTY_STAGE_2) {
               riseAnim = 60;

               if (LEVIATHAN_WATERCANNON_DMG < 60) {
                  LEVIATHAN_WATERCANNON_DMG *= .2;
                  LEVIATHAN_BURSTCANNON_DMG *= .2;
                  LEVIATHAN_WATERFALL_DMG *= .2;
                  LEVIATHAN_SIDESWIPE_DMG *= .2;
               }
            }
            else if (changeInDifficulty(this, vars) == DIFFICULTY_STAGE_3) {
               riseAnim = 30;

               if (LEVIATHAN_WATERCANNON_DMG < 80) {
                  LEVIATHAN_WATERCANNON_DMG *= .2;
                  LEVIATHAN_BURSTCANNON_DMG *= .2;
                  LEVIATHAN_WATERFALL_DMG *= .2;
               }
            }

            switch (attack) {
               case ATTACK_WATERFALL: {
                  vars[VARS_FLIP] = Hero->X + 8 <= 128 ? 0 : 1;
                  int difficultyLevel = changeInDifficulty(this, vars);
                  int flipModifier;
                  int centerOnLinkX;

                  if (Hero->X <= 32) {
                     if (difficultyLevel >= DIFFICULTY_STAGE_2)
                        centerOnLinkX = 32;
                     else
                        centerOnLinkX = 16;
                  }
                  else if (Hero->X >= 224) {
                     if (difficultyLevel >= DIFFICULTY_STAGE_2)
                        centerOnLinkX = -32;
                     else
                        centerOnLinkX = -16;
                  }

                  if (difficultyLevel >= DIFFICULTY_STAGE_2)
                     flipModifier = 16;

                  centerOnLinkX += Hero->X - (vars[VARS_FLIP] ? 48 : 64) - flipModifier;

                  int xModifier = centerOnLinkX;

                  if (vars[VARS_FLIP])
                     xModifier += Choose(0, 8);
                  else
                     xModifier += Choose(-4, 4);

                  glide(this, vars, centerOnLinkX, 112, xModifier, 32, riseAnim);
                  LeviathanWaitframe(this, vars, 40);

                  for (int i = 0; i < 20; ++i) {
                     glideFrame(this, vars, xModifier, 32, xModifier, 112, 20, i);
                     Audio->PlaySound(SFX_WATERFALL);

                     if (i == 3) {
                        int weaponX = this->X + this->HitXOffset + (this->HitWidth / 2) - ((changeInDifficulty(this, vars) == DIFFICULTY_STAGE_2) ? -16 : 0);
                        eweapon waterfall = CreateEWeaponAt(EW_SCRIPT10, weaponX - 8, 112);
                        waterfall->Damage = LEVIATHAN_WATERFALL_DMG;
                        waterfall->Script = Game->GetEWeaponScript("Waterfall");
                        waterfall->DrawYOffset = -1000;
                        waterfall->InitD[0] = changeInDifficulty(this, vars) == DIFFICULTY_STAGE_2 ? 6 : 3;
                        waterfall->InitD[1] = 64;
                     }

                     LeviathanWaitframe(this, vars);
                  }

                  Audio->PlaySound(SFX_SPLASH);
                  splash(this->X + 64, 100);
                  break;
               }
               case ATTACK_WATERBEAM: {
                  int risingX = Hero->X <= 64 ? Rand(32, 144) : Rand(-48, 64);
                  int xModifier = risingX + Choose(-8, 8);

                  if (risingX < 49) {
                     if (Hero->X > this->X + 72)
                        vars[VARS_FLIP] = 0;
                     else
                        vars[VARS_FLIP] = 1;
                  }
                  else {
                     if (Hero->X < this->X + 72)
                        vars[VARS_FLIP] = 1;
                     else
                        vars[VARS_FLIP] = 0;
                  }

                  glide(this, vars, risingX, 112, xModifier, 32, riseAnim);

                  int centerY = vars[VARS_HEAD_CENTERY];
                  risingX = vars[VARS_HEAD_CENTERX];
                  Audio->PlaySound(SFX_CHARGE);

                  chargeAttack(this, vars, risingX, centerY, 60, 24);

                  int angle = Angle(risingX, centerY, Hero->X + 8, Hero->Y + 8);

                  int wSizes[4] = {-24, 24, -12, 12};
                  int wSpeeds[4] = {16, 16, 12, 12};

                  for (int i = 0; i < 32; ++i) {
                     switch (changeInDifficulty(this, vars)) {
                        case DIFFICULTY_STAGE_2: {
                           angle = turnToAngle(angle, Angle(risingX, centerY, Hero->X + 8, Hero->Y + 8), 1.75);
                           break;
                        }
                        case DIFFICULTY_STAGE_3: {
                           angle = turnToAngle(angle, Angle(risingX, centerY, Hero->X + 8, Hero->Y + 8), 2.25);
                           break;
                        }
                        case DIFFICULTY_STAGE_1: {
                           break;
                        }
                     }

                     Audio->PlaySound(SFX_SHOT);

                     for (int j = 0; j < 4; ++j) {
                        eweapon waterBall = CreateEWeaponAt(EW_SCRIPT1, risingX - 8, centerY - 8);
                        waterBall->Damage = LEVIATHAN_WATERCANNON_DMG;
                        waterBall->UseSprite(SPR_WATERBALL);
                        waterBall->Angular = true;
                        waterBall->Angle = DegtoRad(angle);
                        waterBall->Dir = AngleDir4(angle);
                        waterBall->Step = 300;
                        waterBall->Script = Game->GetEWeaponScript("LeviathanSignWave");
                        waterBall->InitD[0] = wSizes[j] * (0.5 + 0.5 * (i / 32));
                        waterBall->InitD[1] = wSpeeds[j];
                        waterBall->InitD[2] = true;
                     }

                     LeviathanWaitframe(this, vars, 4);
                  }

                  glide(this, vars, xModifier, 32, xModifier, 112, 20);
                  Audio->PlaySound(SFX_SPLASH);
                  splash(this->X + 64, 100);
                  break;
               }
               case ATTACK_WATERCANNON: {
                  int risingX = Hero->X <= 64 ? Rand(32, 144) : Rand(-48, 64);
                  int xModifier = risingX + Choose(-8, 8);

                  if (risingX < 49) {
                     if (Hero->X > this->X + 72)
                        vars[VARS_FLIP] = 0;
                     else
                        vars[VARS_FLIP] = 1;
                  }
                  else {
                     if (Hero->X < this->X + 72)
                        vars[VARS_FLIP] = 1;
                     else
                        vars[VARS_FLIP] = 0;
                  }

                  glide(this, vars, risingX, 112, xModifier, 32, riseAnim);

                  risingX = vars[VARS_HEAD_CENTERX];
                  int centerY = vars[VARS_HEAD_CENTERY];
                  Audio->PlaySound(SFX_CHARGE);

                  int wSizes[2] = {-32, 32};
                  int wSpeeds[2] = {6, 6};

                  int numBursts = 3;
                  int burstDelay = 40;

                  switch (changeInDifficulty(this, vars)) {
                     case DIFFICULTY_STAGE_2: {
                        numBursts = 5;
                        burstDelay = 24;
                        break;
                     }
                     case DIFFICULTY_STAGE_3: {
                        numBursts = 7;
                        burstDelay = 12;
                        break;
                     }
                     case DIFFICULTY_STAGE_1: {
                        break;
                     }
                  }

                  for (int i = 0; i < numBursts; ++i) {
                     chargeAttack(this, vars, risingX, centerY, 20, 16);

                     int angle = Angle(risingX, centerY, Hero->X + 8, Hero->Y + 8) + Rand(-20, 20);

                     for (int j = 0; j < 3; ++j) {
                        Audio->PlaySound(SFX_SHOT);

                        for (int k = 0; k < 2; ++k) {
                           eweapon wavectorYShots = CreateEWeaponAt(EW_SCRIPT1, risingX - 8, centerY - 8);
                           wavectorYShots->Damage = LEVIATHAN_BURSTCANNON_DMG;
                           wavectorYShots->UseSprite(SPR_WATERBALL);
                           wavectorYShots->Angular = true;
                           wavectorYShots->Angle = DegtoRad(angle);
                           wavectorYShots->Dir = AngleDir4(angle);
                           wavectorYShots->Step = 200;
                           wavectorYShots->Script = Game->GetEWeaponScript("LeviathanSignWave");
                           wavectorYShots->InitD[0] = wSizes[k] - Rand(-4, 4);
                           wavectorYShots->InitD[1] = wSpeeds[k];
                           wavectorYShots->InitD[2] = true;
                        }

                        LeviathanWaitframe(this, vars, 4);
                     }

                     LeviathanWaitframe(this, vars, 16);

                     for (int j = 0; j < 2; ++j) {
                        eweapon straightShots = CreateEWeaponAt(EW_SCRIPT1, risingX - 8, centerY - 8);
                        straightShots->Damage = LEVIATHAN_BURSTCANNON_DMG;
                        straightShots->UseSprite(SPR_WATERBALL);
                        straightShots->Angular = true;
                        straightShots->Angle = DegtoRad(angle);
                        straightShots->Dir = AngleDir4(angle);
                        straightShots->Step = 150;
                        straightShots->Script = Game->GetEWeaponScript("LeviathanSignWave");
                        straightShots->InitD[0] = 4;
                        straightShots->InitD[1] = 16;
                        straightShots->InitD[2] = true;
                        LeviathanWaitframe(this, vars, 4);
                     }

                     LeviathanWaitframe(this, vars, burstDelay);
                  }

                  glide(this, vars, xModifier, 32, xModifier, 112, 20);
                  Audio->PlaySound(SFX_SPLASH);
                  splash(this->X + 64, 100);
                  break;
               }
               case ATTACK_SIDE_SWIPE: {
                  int side = Choose(-1, 1);
                  int risingX = side == -1 ? -32 : 144;
                  int xModifier = risingX + 32 * side;

                  vars[VARS_FLIP] = risingX < 56 ? 0 : 1;

                  glide(this, vars, risingX, 112, xModifier, 32, riseAnim);

                  for (int i = 0; i < 64; ++i) {
                     this->X += side * 0.25;
                     this->Y -= 0.125;
                     LeviathanWaitframe(this, vars);
                  }

                  for (int i = 0; i < 64; ++i) {
                     this->X -= side * 4;
                     this->Y += 0.5;

                     eweapon waterfall = CreateEWeaponAt(EW_SCRIPT10, this->X + 80, 112);
                     waterfall->Damage = LEVIATHAN_SIDESWIPE_DMG;
                     waterfall->Script = Game->GetEWeaponScript("Waterfall");
                     waterfall->DrawYOffset = -1000;
                     waterfall->InitD[0] = 1;
                     waterfall->InitD[1] = 64 - i * 0.5;

                     LeviathanWaitframe(this, vars);
                  }

                  glide(this, vars, this->X, this->Y, this->X, 112, 20);
                  Audio->PlaySound(SFX_SPLASH);
                  splash(this->X + 64, 100);
                  break;
               }
            }

            LeviathanWaitframe(this, vars);
         }
      }
   }

   int changeInDifficulty(npc n, int[] vars) {
      if (n->HP < vars[VARS_INITHP] * 0.50)
         return DIFFICULTY_STAGE_2;
      if (n->HP < vars[VARS_INITHP] * 0.25)
         return DIFFICULTY_STAGE_3;

      return DIFFICULTY_STAGE_1;
   }

   int attackChoice(npc this, untyped vars) {
      switch (changeInDifficulty(this, vars)) {
         case DIFFICULTY_STAGE_2: {
            if (Hero->Y < 144) {
               if (Rand(3) == 0)
                  return 0;
               if (Rand(3) == 1)
                  return 1;
            }
            else if (Hero->X < 48 || Hero->X > 192) {
               if (Rand(4) == 0)
                  return 1;
               if (Rand(4) == 1)
                  return 3;
            }
            else if (Hero->Y >= 144)
               if (Rand(2) == 0)
                  return Choose(1, 2);

            return Choose(0, 1, 2, 3);
            break;
         }
         case DIFFICULTY_STAGE_3: {
            if (Hero->Y < 144)
               if (Rand(2) == 0)
                  return 0;
               else if (Hero->X < 48 || Hero->X > 192) {
                  if (Rand(2) == 0)
                     return 1;
                  if (Rand(2) == 0)
                     return 3;
                  if (Rand(2) == 0)
                     return 2;
               }
               else if (Hero->Y >= 144) {
                  if (Rand(2) == 0)
                     return 2;
                  if (Rand(2) == 0)
                     return 1;
               }

            return Choose(0, 1, 3);
            break;
         }
         case DIFFICULTY_STAGE_1: {
            if (Hero->Y < 144) {
               if (Rand(3) == 0)
                  return 0;
               if (Rand(2) == 1)
                  return 1;
            }
            else if (Hero->X < 48 || Hero->X > 192)
               if (Rand(2) == 0)
                  return 1;
            if (Hero->Y >= 144) {
               if (Rand(2) == 0)
                  return 1;
               if (Rand(2) == 0)
                  return 2;
            }

            return Choose(0, 1, 2);
            break;
         }
         default: return 1;
      }
   }

   void glide(npc this, untyped vars, int x1, int y1, int x2, int y2, int numFrames) {
      int angle = Angle(x1, y1, x2, y2);
      int dist = Distance(x1, y1, x2, y2);

      for (int i = 0; i < numFrames; ++i) {
         int x = x1 + VectorX(dist * (i / numFrames), angle);
         int y = y1 + VectorY(dist * (i / numFrames), angle);
         this->X = x;
         this->Y = y;

         LeviathanWaitframe(this, vars);
      }
   }

   void glideFrame(npc this, untyped vars, int x1, int y1, int x2, int y2, int numFrames, int i) {
      float num = 9.4;
      int angle = Angle(x1, y1, x2, y2);
      int dist = Distance(x1, y1, x2, y2);
      int x = x1 + VectorX(dist * (i / numFrames), angle);
      int y = y1 + VectorY(dist * (i / numFrames), angle);
      this->X = x;
      this->Y = y;
   }

   void chargeAttack(npc this, untyped vars, int x, int y, int chargeFrames, int chargeMaxSize) {
      Audio->PlaySound(SFX_CHARGE);

      for (int i = 0; i < chargeFrames; ++i) {
         Screen->Circle(4, x + Rand(-2, 2), y + Rand(-2, 2), (i / chargeFrames) * chargeMaxSize, Choose(C_CHARGE1, C_CHARGE2, C_CHARGE3), 1, 0, 0, 0, true, OP_OPAQUE);
         LeviathanWaitframe(this, vars);
      }
   }

   void splash(int x, int y) {
      lweapon waterSplash;

      for (int i = 0; i < 5; ++i) {
         for (int j = 1; j <= 2; ++j) {
            waterSplash = CreateLWeaponAt(LW_SPARKLE, x - 4 - 4 * i, y);
            waterSplash->UseSprite(SPR_SPLASH);
            waterSplash->ASpeed += Rand(3);
            waterSplash->Step = Rand(100, 200) * j * 0.5;
            waterSplash->Angular = true;
            waterSplash->Angle = DegtoRad(-90 - 5 - 15 * i + Rand(-5, 5));
            waterSplash->NoCollisionTimer = -1;

            waterSplash = CreateLWeaponAt(LW_SPARKLE, x + 4 + 4 * i, y);
            waterSplash->UseSprite(SPR_SPLASH);
            waterSplash->ASpeed += Rand(3);
            waterSplash->Step = Rand(100, 200) * j * 0.5;
            waterSplash->Angular = true;
            waterSplash->Angle = DegtoRad(-90 + 5 + 15 * i + Rand(-5, 5));
            waterSplash->NoCollisionTimer = -1;
            waterSplash->Flip = 1;
         }
      }
   }

   void LeviathanWaitframe(npc this, untyped vars, int frames) {
      for (int i = 0; i < frames; ++i)
         LeviathanWaitframe(this, vars);
   }

   void LeviathanWaitframe(npc this, untyped[] vars) {
      this->DrawYOffset = -1000;
      this->Stun = 10;
      this->Immortal = true;

      if (vars[VARS_FLIP])
         this->HitXOffset = 32;
      else
         this->HitXOffset = 64;

      if (this->Y + this->HitYOffset + this->HitHeight - 1 <= 112 && vars[VARS_FLASHTIMER] == 0)
         this->NoCollisionTimer = 0;
      else
         this->NoCollisionTimer = -1;

      npc head = vars[VARS_HEADNPC];

      if (head->isValid()) {
         if (head->Y + head->HitYOffset + head->HitHeight - 1 <= 112 && vars[VARS_FLASHTIMER] == 0)
            head->NoCollisionTimer = 0;
         else
            head->NoCollisionTimer = -1;

         head->DrawYOffset = -1000;
         head->Stun = 10;

         if (vars[VARS_FLIP])
            vars[VARS_HEAD_CENTERX] = this->X + 16 + 12;
         else
            vars[VARS_HEAD_CENTERX] = this->X + 104 + 12;

         vars[VARS_HEAD_CENTERY] = this->Y + 48 + 8;
         head->X = vars[VARS_HEAD_CENTERX] - 12;
         head->Y = vars[VARS_HEAD_CENTERY] - 8;
         head->HitWidth = 24;
         head->HitHeight = 16;

         if (head->HP < 1000) {
            this->HP -= 1000 - head->HP;
            head->HP = 1000;
         }
      }

      if (vars[VARS_BODYHP] != this->HP) {
         if (vars[VARS_BODYHP] > this->HP)
            vars[VARS_FLASHTIMER] = 32;

         vars[VARS_BODYHP] = this->HP;
      }

      if (this->HP <= 0)
         DeathAnim(this, vars);

      LeviathanWaitframeLite(this, vars);
   }

   void LeviathanWaitframeLite(npc this, untyped vars) {
      int cset = this->CSet;

      if (vars[VARS_FLASHTIMER])
         cset = 9 - (vars[VARS_FLASHTIMER] >> 1);

      if (vars[VARS_FLASHTIMER])
         --vars[VARS_FLASHTIMER];

      Screen->DrawTile(0, this->X, this->Y, this->OriginalTile, 9, 6, cset, -1, -1, 0, 0, 0, vars[VARS_FLIP], 1, 128);

      UpdateWaterfallBitmap();

      Waitframe();
   }

   void UpdateWaterfallBitmap() {
      int cmb;
      waterfallBitmap->Clear(0);
      int ptr[5 * 22];

      for (int i = 0; i < 11; ++i) {
         cmb = CMB_WATERFALL;

         if (i == 0)
            cmb = CMB_WATERFALL + 1;

         waterfallBitmap->FastCombo(0, 0, 16 * i, cmb, CS_WATERFALL, 128);

         cmb = CMB_WATERFALL + 2;

         if (i == 10)
            cmb = CMB_WATERFALL + 3;

         waterfallBitmap->FastCombo(0, 16, 16 * i, cmb, CS_WATERFALL, 128);
      }
   }

   void DeathAnim(npc this, untyped vars) {
      npc head = vars[VARS_HEADNPC];
      Remove(head);
      this->NoCollisionTimer = -1;

      int i;
      int x = this->X;

      Waitframe();

      Screen->Message(MSG_BEATEN);
      vars[VARS_FLASHTIMER] = 0;
      LeviathanWaitframeLite(this, vars);

      Audio->PlaySound(120);

      while (this->Y < 112) {
         this->Y += 0.5;
         ++i;
         i %= 360;
         this->X = x + 12 * Sin(i * 8);
         Audio->PlaySound(SFX_RISE);
         Screen->Quake = 20;
         LeviathanWaitframeLite(this, vars);
      }

      Waitframe();

      item leviathanScale = CreateItemAt(183, Hero->X, Hero->Y);
      leviathanScale->Pickup = IP_HOLDUP;
      Screen->Message(MSG_LEVIATHAN_SCALE);

      Waitframe();

      Hero->WarpEx(WT_IWARPOPENWIPE, 2, 13, -1, WARP_A, WARPEFFECT_WAVE, 0, WARP_FLAG_NONE, DIR_LEFT);

      this->Immortal = false;
      this->Remove();
   }

   eweapon script Waterfall {
      void run(int width, int peakHeight) {
         this->UseSprite(SPR_WATERBALL); // TODO what? sprite 94?

         unless(waterfallBitmap->isAllocated()) {
            this->DeadState = 0;
            Quit();
         }

         eweapon hitbox = CreateEWeaponAt(EW_SCRIPT1, this->X, this->Y);
         hitbox->Damage = this->Damage;
         hitbox->DrawYOffset = -1000;
         hitbox->NoCollisionTimer = -1;

         int startX = this->X;

         int waterfallTop = this->Y;
         int waterfallBottom = this->Y;
         int bgHeight;
         int fgHeight;
         this->NoCollisionTimer = -1;

         while (waterfallTop > peakHeight) {
            waterfallTop = Max(waterfallTop - 1.5, peakHeight);
            bgHeight = waterfallBottom - waterfallTop;

            for (int i = 0; i < width; ++i) {
               int xWithOffset = startX - (width - 1) * 8 + i * 16;
               waterfallBitmap->Blit(0, -2, 0, 0, 16, bgHeight, xWithOffset, waterfallTop, 16, bgHeight, 0, 0, 0, BITDX_NORMAL, 0, false);
            }

            Waitframe();
         }

         bgHeight = waterfallBottom - waterfallTop;
         waterfallTop = peakHeight;
         waterfallBottom = peakHeight;
         hitbox->NoCollisionTimer = 0;

         while (waterfallBottom < 176) {
            if (!hitbox->isValid()) {
               hitbox = CreateEWeaponAt(EW_SCRIPT1, this->X, this->Y);
               hitbox->Damage = this->Damage;
               hitbox->DrawYOffset = -1000;
            }

            hitbox->Dir = -1;
            hitbox->DeadState = -1;
            hitbox->X = 120;
            hitbox->Y = 80;
            hitbox->HitXOffset = (startX - (width - 1) * 8) - 120;
            hitbox->HitYOffset = waterfallTop - 80;
            hitbox->HitWidth = width * 16;
            hitbox->HitHeight = fgHeight;

            waterfallBottom += 3;
            fgHeight = waterfallBottom - waterfallTop;

            for (int i = 0; i < width; ++i) {
               int xWithOffset = startX - (width - 1) * 8 + i * 16;
               waterfallBitmap->Blit(0, -2, 0, 0, 16, bgHeight, xWithOffset, peakHeight, 16, bgHeight, 0, 0, 0, BITDX_NORMAL, 0, false);
               waterfallBitmap->Blit(4, -2, 16, 175 - fgHeight, 16, fgHeight, xWithOffset, peakHeight, 16, fgHeight, 0, 0, 0, BITDX_NORMAL, 0, false);
            }

            Waitframe();
         }

         while (waterfallTop < 176) {
            if (!hitbox->isValid()) {
               hitbox = CreateEWeaponAt(EW_SCRIPT1, this->X, this->Y);
               hitbox->Damage = this->Damage;
               hitbox->DrawYOffset = -1000;
            }

            hitbox->Dir = -1;
            hitbox->DeadState = -1;
            hitbox->X = 120;
            hitbox->Y = 80;
            hitbox->HitXOffset = (startX - (width - 1) * 8) - 120;
            hitbox->HitYOffset = waterfallTop - 80;
            hitbox->HitWidth = width * 16;
            hitbox->HitHeight = fgHeight;

            waterfallTop += 3;
            fgHeight = waterfallBottom - waterfallTop;

            for (int i = 0; i < width; ++i) {
               int xWithOffset = startX - (width - 1) * 8 + i * 16;
               waterfallBitmap->Blit(4, -2, 16, 175 - fgHeight, 16, fgHeight, xWithOffset, waterfallTop, 16, fgHeight, 0, 0, 0, BITDX_NORMAL, 0, false);
            }

            Waitframe();
         }

         this->DeadState = 0;

         if (hitbox->isValid())
            hitbox->DeadState = 0;

         Quit();
      }
   }

   eweapon script LeviathanSignWave {
      void run(int size, int speed, bool noBlock) {
         int x = this->X;
         int y = this->Y;

         int dist;
         int timer;

         while (true) {
            timer += speed;
            timer %= 360;

            x += RadianCos(this->Angle) * this->Step * 0.01;
            y += RadianSin(this->Angle) * this->Step * 0.01;

            dist = Sin(timer) * size;

            this->X = x + VectorX(dist, RadtoDeg(this->Angle) - 90);
            this->Y = y + VectorY(dist, RadtoDeg(this->Angle) - 90);

            if (noBlock)
               this->Dir = Hero->Dir;

            Waitframe();
         }
      }
   }
}

// clang-format off
@Author("Moosh, modified by Deathrider365")
npc script Legionnaire {
   // clang-format on

   using namespace EnemyNamespace;
   using namespace NPCAnim;
   using namespace NPCAnim::Utility;

   CONFIG ATTACK_INITIAL_RUSH = -1;
   CONFIG ATTACK_FIRE_SWORDS = 0;
   CONFIG ATTACK_JUMPS_ON_YOU = 1;
   CONFIG ATTACK_SPRINT_SLASH = 2;

   CONFIG INTRO_SCREEND = 0;

   CONFIG TILE_IMPACT_MID = 955;
   CONFIG TILE_IMPACT_BIG = 952;

   CONFIG MESSAGE_LEGIONNAIRE_INTRO = 811;

   void run(int enemyid, int spawnCondition) {
      CONFIG SPAWN_CONDITION_SECRETS = 1;
      CONFIG SPAWN_CONDITION_PROXIMITY = 2;
      CONFIG SPAWN_CONDITION_ITEM = 3;

      CONFIG DMG_FIRE_SWORDS = this->WeaponDamage + (this->WeaponDamage * .3);
      CONFIG DMG_JUMPS_ON_YOU = this->WeaponDamage + (this->WeaponDamage * .4);
      CONFIG DMG_SPRINT_SLASH = this->WeaponDamage + (this->WeaponDamage * .5);

      CONFIG MAX_HP = this->HP;
      CONFIGB IS_CLONE = this->Step != 100;

      int attackCoolDown = 0;
      int timeToSpawnAnother = 0;
      int attack = -1;

      if (!Screen->ComboF[ComboAt(this->X + 8, this->Y + 8)]) { //TODO enhance to check CF_ENEMY0-CF_ENEMY9
         this->X = 120;
         this->Y = 80;
         this->Z = 0;
      }

      this->Flags[NPCF_ISINVISIBLE] = true;
      this->NoCollisionTimer = -1;

      if (spawnCondition > 0) {
         int condition = Floor(spawnCondition);
         int conditionModifier = (spawnCondition % 1) / 1L;

         switch(condition) {
            case SPAWN_CONDITION_SECRETS:
               until (Screen->State[ST_SECRET]) Waitframe();
               break;
            case SPAWN_CONDITION_PROXIMITY:
               until (Distance(this->X + 8, this->Y + 8, Hero->X + 8, Hero->Y + 8) < conditionModifier) Waitframe();
               break;
            case SPAWN_CONDITION_ITEM:
               until (Hero->Item[conditionModifier]) Waitframe();
               break;
         }
      }

      unless (IS_CLONE)
         Audio->PlayEnhancedMusic("OoT - Middle Boss.ogg"); //TODO dont refer to music files directly (I already added the legionnaire music to the engine)

      // Intro Animation
      if (!getScreenD(INTRO_SCREEND))
         introCutscene(this);
      else {
         this->Flags[NPCF_ISINVISIBLE] = false;
         this->NoCollisionTimer = 0;
      }

      int movementDirection = Choose(90, -90);

      loop() {
         FaceLink(this);

         int angle = AngleLink(this) + movementDirection;
         this->MoveAtAngle(angle, this->Step / 100, SPW_NONE);

         int numLegionnaires = 0;

         for (int i = 1; i <= Screen->NumNPCs; ++i) {
            if (Screen->LoadNPC(i)->ID == this->ID)
               numLegionnaires++;
         }

         if (timeToSpawnAnother >= 300 && numLegionnaires < 3 && !IS_CLONE) {
            spawnReinforcements(this);
            this->HP += (MAX_HP * .2);
            timeToSpawnAnother = 0;
         }

         if (attackCoolDown)
            --attackCoolDown;
         else {
            attackCoolDown = 90 + Rand(30);
            attack = attackChoice(this, attack, numLegionnaires);

            switch (attack) {
               case ATTACK_INITIAL_RUSH: {
                  jumpsOnYou(this, movementDirection, DMG_JUMPS_ON_YOU);
                  attackFireSwords(this, movementDirection, DMG_FIRE_SWORDS);
                  attackSprintSlash(this, movementDirection, DMG_SPRINT_SLASH);
                  attack = ATTACK_FIRE_SWORDS;
                  break;
               }
               case ATTACK_FIRE_SWORDS: {
                  attackFireSwords(this, movementDirection, DMG_FIRE_SWORDS);
                  break;
               }
               case ATTACK_JUMPS_ON_YOU: {
                  jumpsOnYou(this, movementDirection, DMG_JUMPS_ON_YOU);
                  break;
               }
               case ATTACK_SPRINT_SLASH: {
                  attackSprintSlash(this, movementDirection, DMG_SPRINT_SLASH);
                  break;
               }
            }

            movementDirection = Choose(90, -90);
         }

         if (this->HP <= MAX_HP * .5)
            timeToSpawnAnother++;

         LegionnaireWaitframe(this);
      }
   }

   void LegionnaireWaitframe(npc this, int frames = 1) {
      for (int i = 0; i < frames; ++i) {
         if (this->HP <= 0)
            deathAnimation(this, 0, (this->Step == 100) ? true : false);

         Waitframe();
      }
   }

   void legionnaireShake(npc this, int frames, int intensity) {
      for (int i = 0; i < frames; ++i) {
         this->DrawXOffset = Rand(-intensity, intensity);
         this->DrawYOffset = Rand(-intensity, intensity);

         LegionnaireWaitframe(this);
      }

      this->DrawXOffset = 0;
      this->DrawYOffset = 0;
   }

   void introCutscene(npc this) {
      FaceLink(this);
      this->Gravity = false;

      for (int i = 0; i < 24; ++i) {
         disableLink();
         LegionnaireWaitframe(this);
      }

      this->Gravity = true;
      this->Z = 176;

      this->Flags[NPCF_ISINVISIBLE] = false;
      this->NoCollisionTimer = 0;

      while (this->Z > 0) {
         disableLink();
         this->Z -= 2;
         LegionnaireWaitframe(this);
      }

      Screen->Quake = 10;
      Audio->PlaySound(SFX_IMPACT_EXPLOSION);

      for (int i = 0; i < 30; ++i) {
         disableLink();
         makeHitbox(this->X - 12, this->Y - 12, 40, 40, 0);
         Screen->DrawTile(2, this->X - 16, this->Y - 16, TILE_IMPACT_BIG, 3, 3, 8, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
         LegionnaireWaitframe(this);
      }

      Audio->PlaySound(SFX_STALFOS_GROAN);

      if (!receivedLegionnaireOpeningMessage) {
         Screen->Message(MESSAGE_LEGIONNAIRE_INTRO);
         receivedLegionnaireOpeningMessage = true;
      }

      setScreenD(INTRO_SCREEND, true);
   }

   void spawnReinforcements(npc this) {
      legionnaireShake(this, 32, 1);
      Audio->PlaySound(SFX_OOT_WHISTLE);

      npc backupLegionnaire = Screen->CreateNPC(this->ID);
      backupLegionnaire->ItemSet = 0;
      backupLegionnaire->HP *= .5;
      backupLegionnaire->Step *= .5;
      backupLegionnaire->Damage *= .5;
      backupLegionnaire->WeaponDamage *= .5;

      int pos, x, y;

      for (int i = 0; i < 352; ++i) {
         pos = i < 176 ? Rand(176) : i - 176;

         x = ComboX(pos);
         y = ComboY(pos);

         if (Distance(Hero->X, Hero->Y, x, y) > 48)
            if (validSpawn(pos))
               break;
      }

      backupLegionnaire->X = x;
      backupLegionnaire->Y = y;
   }

   int attackChoice(npc this, int attack, int numLegionnaires) {
      int distance = Distance(this->X, this->Y, Hero->X + 8, Hero->Y + 8);

      if (attack == ATTACK_FIRE_SWORDS)
         attack = ATTACK_SPRINT_SLASH;
      else if (attack == ATTACK_JUMPS_ON_YOU) {
         if (distance < 48)
            attack = ATTACK_JUMPS_ON_YOU;
         if (distance < 64)
            attack = ATTACK_FIRE_SWORDS;
         else
            attack = ATTACK_SPRINT_SLASH;
      }
      else if (attack == ATTACK_SPRINT_SLASH) {
         if (distance > 64)
            attack = ATTACK_SPRINT_SLASH;
         else if (distance > 48)
            attack = ATTACK_FIRE_SWORDS;
         else
            attack = ATTACK_JUMPS_ON_YOU;
      }
      else if (attack == ATTACK_FIRE_SWORDS && numLegionnaires > 1)
         attack = ATTACK_FIRE_SWORDS;

      return attack;
   }

   void attackFireSwords(npc this, int movementDirection, int damage) {
      FaceLink(this);
      Audio->PlaySound(SFX_STALFOS_GROAN_SLOW);
      legionnaireShake(this, 48, 1);

      for (int i = 0; i < 5; ++i) {
         FaceLink(this);
         eweapon sword = FireEWeaponAtHero(EW_SCRIPT1, this->X, this->Y, true, 300, damage, SPR_LEGIONNAIRESWORD, SFX_SHOOTSWORD);
         sword->Unblockable = UNBLOCK_ALL;

         LegionnaireWaitframe(this, 16);
      }

      LegionnaireWaitframe(this, 16);
      movementDirection = Choose(90, -90);
   }

   void jumpsOnYou(npc this, int movementDirection, int damage) {
      FaceLink(this);
      Audio->PlaySound(SFX_STALFOS_GROAN);
      legionnaireShake(this, 32, 2);

      int aSpeed = this->ASpeed;
      int distance = Distance(this->X + 8, this->Y + 8, Hero->X + 8, Hero->Y + 8);

      this->Jump = getJumpLength(distance / 2, true);
      this->Z = 2;
      Audio->PlaySound(SFX_JUMP);
      this->ASpeed = this->ASpeed / 2; //TODO this makes him flash for some reason

      int currentLinkPositionX = Hero->X + 8;
      int currentLinkPositionY = Hero->Y + 8;

      while (this->Jump || this->Z) {
         MoveTowardsPoint(this, currentLinkPositionX, currentLinkPositionY, 2, SPW_FLOATER, true);
         LegionnaireWaitframe(this);
      }

      this->ASpeed = aSpeed;
      Audio->PlaySound(SFX_IMPACT_EXPLOSION);

      for (int i = 0; i < 24; ++i) {
         makeHitbox(this->X - 12, this->Y - 12, 40, 40, (distance > 80) ? (damage + damage * .2) : damage);
         Screen->DrawTile(2, this->X - 16, this->Y - 16, (distance > 80) ? TILE_IMPACT_BIG : TILE_IMPACT_MID, 3, 3, 8, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
         LegionnaireWaitframe(this);
      }

      movementDirection = Choose(90, -90);
   }

   void attackSprintSlash(npc this, int movementDirection, int damage) {
      CONFIG COMBO_LEGIONNAIRE_SWORD = 10252;

      FaceLink(this);
      Audio->PlaySound(SFX_STALFOS_GROAN_FAST);
      legionnaireShake(this, 16, 2);

      int moveAngle = Angle(this->X + 8, this->Y + 8, Hero->X + 8, Hero->Y + 8);
      int distance = Distance(this->X + 8, this->Y + 8, Hero->X + 8, Hero->Y + 8);
      int dashFrames = Max(2, (distance - 36) / 3);

      bool swordCollided;

      int thisStep = this->Step;
      this->Step = 100;

      for (int i = 0; i < dashFrames; ++i) {
         this->MoveAtAngle(moveAngle, this->Step / 30, SPW_NONE);

         if (i > dashFrames / 2)
            sword1x1(this->X, this->Y, moveAngle - 90, (i - dashFrames / 2) / (dashFrames / 2) * 16, COMBO_LEGIONNAIRE_SWORD, 10, damage);

         LegionnaireWaitframe(this);
      }

      Audio->PlaySound(SFX_SWORD);
      distance = Distance(this->X + 8, this->Y + 8, Hero->X + 8, Hero->Y + 8);

      for (int i = 0; i <= 12 && !swordCollided; ++i) {
         this->MoveAtAngle(moveAngle, this->Step / 35, SPW_NONE);
         swordCollided = sword1x1Collision(this->X, this->Y, moveAngle - 90 + 15 * i, 16, COMBO_LEGIONNAIRE_SWORD, 10, damage);

         LegionnaireWaitframe(this);
      }

      if (swordCollided) {
         Audio->PlaySound(SFX_SWORD_ROCK3);

         for (int i = 0; i < 12; ++i) {
            this->MoveAtAngle(moveAngle + 180, this->Step / 30, SPW_NONE);
            LegionnaireWaitframe(this);
         }

         LegionnaireWaitframe(this, 40);
      }

      this->Step = thisStep;
      movementDirection = Choose(90, -90);
   }
}

namespace ShamblesNamespace {
   using namespace EnemyNamespace;
   using namespace NPCAnim;
   using namespace NPCAnim::Utility;

   class ShamblesData {
      int defenses[MAX_DEFENSE];
   }

   bool firstRun = true;

   enum Animations {
      ANIM_EMERGED,
      ANIM_HALF_EMERGED,
      ANIM_SUBMERGED
   };

   CONFIG ANIM_SPEED = 16;

   // clang-format off
   @Author("Moosh, modified by Deathrider365")
   npc script Shambles {
      // clang-format on

      CONFIG ATTACK_INITIAL_RUSH = -1;
      CONFIG ATTACK_LINK_CHARGE = 0;
      CONFIG ATTACK_BOMB_LOB = 1;
      CONFIG ATTACK_SPAWN_ZAMBIES = 2;

      void run() {
         CONFIG ATTACK_COOLDOWN = 90;
         CONFIG MAX_HP = this->HP;
         CONFIG DIFFICULTY_MULTIPLIER = 0.5;

         CONFIG DMG_CLOUD = 1;
         CONFIG DMG_BOMB = this->WeaponDamage;
         CONFIG DMG_BOMB_POISON = this->WeaponDamage / 2;

         AnimHandler aptr = new AnimHandler(this);

         aptr->AddAnim(ANIM_EMERGED, 0, 4, ANIM_SPEED, ADF_4WAY);
         aptr->AddAnim(ANIM_HALF_EMERGED, 20, 4, ANIM_SPEED, ADF_4WAY);
         aptr->AddAnim(ANIM_SUBMERGED, 40, 4, ANIM_SPEED, ADF_4WAY);

         ShamblesData shamblesData = new ShamblesData();
         StoreEnemyClassPointer(this, shamblesData);
         StoreDefenses(this, shamblesData->defenses);

         int bombsToLob = 2;
         int attack = -1;

         aptr->PlayAnim(-1);

         this->X = 120;
         this->Y = 80;
         this->Dir = DIR_DOWN;

         Waitframes(15);

         Audio->PlayEnhancedMusic("Metroid Prime - Parasite Queen.ogg"); //TODO dont refer to music files directly (I already added the legionnaire music to the engine)

         if (firstRun) {
            introCutscene(this);
            firstRun = false;
         }
         else {
            aptr->PlayAnim(ANIM_EMERGED);
            ShamblesWaitframe(this, 30);
         }

         submerge(this, 8);

         loop () {
            attack = chooseAttack(attack);

            ShamblesWaitframe(this, this->HP < MAX_HP * DIFFICULTY_MULTIPLIER ? 90 : 120);

            moveMe(this);

            if (this->HP < MAX_HP * DIFFICULTY_MULTIPLIER) {
               emerge(this, 4);
               bombsToLob = 3;
            }
            else
               emerge(this, 8);

            switch (attack) {
               case ATTACK_INITIAL_RUSH: {
                  spawnZambos(this, 2);
                  attackBombLob(this, MAX_HP, bombsToLob, DIFFICULTY_MULTIPLIER, DMG_BOMB, DMG_BOMB_POISON);
                  break;
               }
               case ATTACK_LINK_CHARGE: {
                  for (int i = 0; i < 3; ++i) {
                     Audio->PlaySound(SFX_MIRROR_SHIELD_ABSORB_LOOP);
                     ShamblesWaitframe(this, 15);

                     int moveAngle = AngleLink(this);
                     Audio->PlaySound(SFX_SWORD);

                     for (int i = 0; i < 30; ++i) {
                        if (this->HP < MAX_HP * DIFFICULTY_MULTIPLIER && i % 3 == 0) {
                           eweapon poisonTrail = FireEWeaponDegAngle(EW_SCRIPT10, this->X + Rand(-2, 2), this->Y + Rand(-2, 2), 0, 0, DMG_CLOUD, SPR_POISON_CLOUD, SFX_SIZZLE);
                           poisonTrail->Unblockable = UNBLOCK_ALL;
                           poisonTrail->Timeout = 60; //Maybe have the poison stay forever in paladin... ha! it already does this!
                        }

                        shadowTrail(this, false, 6);
                        this->MoveAtAngle(moveAngle, 3, 0);
                        ShamblesWaitframe(this, 1);
                     }

                     ShamblesWaitframe(this, 45);
                  }
                  break;
               }
               case ATTACK_BOMB_LOB: {
                  attackBombLob(this, MAX_HP, bombsToLob, DIFFICULTY_MULTIPLIER, DMG_BOMB, DMG_BOMB_POISON);
                  break;
               }
               case ATTACK_SPAWN_ZAMBIES: {
                  spawnZambos(this, 2);
                  break;
               }
            }

            if (this->HP < MAX_HP * 0.50)
               submerge(this, 4);
            else
               submerge(this, 8);
         }
      }

      void introCutscene(npc this) {
         AnimHandler aptr = GetAnimHandler(this);
         Hero->Stun = 285;
         ShamblesWaitframe(this, 15);

         Screen->Quake = 90;
         ShamblesWaitframe(this, 90, SFX_ROCKINGSHIP);

         aptr->PlayAnim(ANIM_SUBMERGED);
         Screen->Quake = 60;
         ShamblesWaitframe(this, 60, SFX_ROCKINGSHIP);

         aptr->PlayAnim(ANIM_HALF_EMERGED);
         Screen->Quake = 60;
         ShamblesWaitframe(this, 60, SFX_ROCKINGSHIP);

         aptr->PlayAnim(ANIM_EMERGED);
         Screen->Quake = 60;
         ShamblesWaitframe(this, 60, SFX_ROCKINGSHIP);

         Screen->Message(803);
      }

      void attackBombLob(npc this, int maxHP, int bombsToLob, int difficultyMultiplier, int bombDamage, int poisonDamage) {
         Audio->PlaySound(SFX_OOT_BIG_DEKU_BABA_LUNGE);
         ShamblesWaitframe(this, 30);

         for (int i = 0; i < bombsToLob; ++i) {
            ShamblesWaitframe(this, 16);

            eweapon bomb = FireEWeaponDegAngle(EW_BOMB, this->X, this->Y, AngleLink(this), 200, bombDamage, -1, 0, Game->GetEWeaponScript("ArcingWeapon"),
               {-1, 0, (this->HP < (maxHP * difficultyMultiplier)) ? AE_LARGEPOISONPOOL : AE_SMALLPOISONPOOL, this, poisonDamage, 0, true}
            );
            bomb->Unblockable = UNBLOCK_ALL;
            FourWayFlip(bomb);

            Audio->PlaySound(SFX_LAUNCH_BOMBS);
            ShamblesWaitframe(this, 15);
         }
      }

      void spawnZambos(npc this, int numZombies) {
         for (int i = 0; i < numZombies; ++i) {
            Audio->PlaySound(SFX_SUMMON_MINE);
            npc zambo = Screen->CreateNPC(ENEMY_ZOMBIE_LV1);

            zambo->X = this->X;
            zambo->Y = this->Y;

            moveMe(zambo, false);

            ShamblesWaitframe(this, 30);
         }
      }

      void moveMe(npc this, bool moveThem = true) {
         int pos, x, y;

         for (int i = 0; i < 352; ++i) {
            pos = i < 176 ? Rand(176) : i - 176;

            x = ComboX(pos);
            y = ComboY(pos);

            if (Distance(Hero->X, Hero->Y, x, y) > 48)
               if (validSpawn(pos))
                  break;
         }

         while (moveThem && MoveToPoint(this, x, y, 2, SPW_FLOATER))
            ShamblesWaitframe(this);
      }

      void emerge(npc this, int frames) {
         AnimHandler aptr = GetAnimHandler(this);
         ShamblesData shamblesData = GetEnemyClassPointer(this);

         aptr->PlayAnim(ANIM_SUBMERGED);
         ShamblesWaitframe(this, frames);
         Audio->PlaySound(130);

         SetDefenses(this, shamblesData->defenses);
         aptr->PlayAnim(ANIM_HALF_EMERGED);
         ShamblesWaitframe(this, frames);

         aptr->PlayAnim(ANIM_EMERGED);
         ShamblesWaitframe(this, frames);
      }

      void submerge(npc this, int frames) {
         AnimHandler aptr = GetAnimHandler(this);

         ShamblesWaitframe(this, frames);
         Audio->PlaySound(130);

         aptr->PlayAnim(ANIM_HALF_EMERGED);
         ShamblesWaitframe(this, frames);

         SetAllDefenses(this, NPCDT_IGNORE);
         aptr->PlayAnim(ANIM_SUBMERGED);
         ShamblesWaitframe(this, frames);
      }

      int chooseAttack(int attack) {
         if (Screen->NumNPCs >= 3) {
            if (attack == ATTACK_INITIAL_RUSH)
               attack = ATTACK_LINK_CHARGE;
            else if (attack == ATTACK_LINK_CHARGE)
               attack = ATTACK_BOMB_LOB;
            else if (attack == ATTACK_BOMB_LOB) {
               attack = ATTACK_LINK_CHARGE;
            }
         }
         else
            attack = ATTACK_INITIAL_RUSH;

         return attack;
      }

      void ShamblesWaitframe(npc this, int frames = 1, int sfx = 0) {
         for (int i = 0; i < frames; ++i) {
            if (this->HP <= 0)
               deathAnimation(this);

            if (sfx > 0 && i % 30 == 0)
               Audio->PlaySound(sfx);

            Waitframe(this);
         }
      }
   }
}

namespace HazarondNamespace {
   using namespace EnemyNamespace;

   bool firstRun = true;

   // clang-format off
   @Author("EmilyV99, Deathrider365")
   npc script Hazarond {
      // clang-format on

      using namespace EnemyNamespace;

      CONFIG DEFAULT_COMBO = 10272;
      CONFIG JUMP_PREP_COMBO = 10273;
      CONFIG JUMPING_COMBO = 10274;
      CONFIG JUMP_LANDING_COMBO = 10275;

      CONFIG TIME_BETWEEN_ATTACKS = 180;

      void run(int hurtCSet, int minion) {
         if (firstRun)
            disableLink();

         CONFIG DMG_DROPPED_FLAME = this->WeaponDamage;
         CONFIG DMG_OIL_BLOB = this->WeaponDamage / 3;

         setupNPC(this);

         untyped data[SZ_DATA];
         int oCSet = this->CSet;
         int timeSinceLastAttack = 180;

         setNPCToCombo(data, this, DEFAULT_COMBO);

         npc heads[4];

         int eweaponStopper = Game->GetEWeaponScript("StopperKiller");

         bitmap effectBitmap = create(256, 168);
         this->Immortal = true;

         const int maxHp = this->HP;

         for (int headIndex = 0; headIndex < 4; ++headIndex) {
            heads[headIndex] = Screen->CreateNPC(minion);
            heads[headIndex]->InitD[0] = this;
            heads[headIndex]->Dir = headIndex + 4;
            heads[headIndex]->Defense[NPCD_SCRIPT1] = NPCDT_IGNORE;
         }

         if (firstRun) {
            disableLink();
            commenceIntroSequence(this, data, heads);
            Screen->Message(804);
            firstRun = false;
         }
         else {
            mapdata mapDataLayer1 = Game->LoadTempScreen(1);
            mapDataLayer1->ComboD[94] = CMB_INVIS;
            mapDataLayer1->ComboD[95] = CMB_INVIS;
            Audio->PlayEnhancedMusic("The Binding of Isaac - Divine Combat.ogg", 0);
         }
         disableLink();

         while (this->HP > 0) {
            int previousAttack;

            int angle;
            int headOpen = 20;
            int headOpenIndex;

            while (true) {
               if (isHeadsDead(heads))
                  break;

               for (int i = 0; i < MAX_DEFENSE; ++i)
                  this->Defense[i] = NPCDT_IGNORE;


               for (int i = 0; i < 4; ++i)
                  if (heads[i])
                     heads[i]->NoCollisionTimer = 0;

               if (headOpen == 20) {
                  headOpenIndex = RandGen->Rand(3);

                  until(heads[headOpenIndex]) headOpenIndex = RandGen->Rand(3);

                  if (heads[headOpenIndex])
                     heads[headOpenIndex]->OriginalTile -= 1;
               }

               if (headOpen == 0) {
                  if (heads[headOpenIndex])
                     heads[headOpenIndex]->OriginalTile += 1;

                  headOpenIndex = RandGen->Rand(3);

                  until(heads[headOpenIndex]) headOpenIndex = RandGen->Rand(3);

                  if (heads[headOpenIndex])
                     heads[headOpenIndex]->OriginalTile -= 1;

                  headOpen = 20;
               }

               angle = RadtoDeg(TurnTowards(CenterX(this), CenterY(this), CenterLinkX(), CenterLinkY(), 0, 1));

               unless(data[DATA_CLK] % 3) this->MoveAtAngle(angle, 1, SPW_NONE);

               bool justSprayed = false;

               if (TIME_BETWEEN_ATTACKS <= timeSinceLastAttack) {
                  if (heads[headOpenIndex])
                     heads[headOpenIndex]->OriginalTile += 1;

                  oilSpray(data, this, heads, isDifficultyChange(this, maxHp), DMG_OIL_BLOB);

                  headOpen = 21;
                  justSprayed = true;
                  timeSinceLastAttack = 0;
               }

               if (this->HP <= 0)
                  deathAnimation(this, 142);

               if (isHeadsDead(heads))
                  break;

               if (linkClose(this, 32)) {
                  timeSinceLastAttack += 60;

                  if (heads[headOpenIndex] && timeSinceLastAttack != 0 && !justSprayed)
                     heads[headOpenIndex]->OriginalTile += 1;

                  headOpen = 21;

                  groundPound(this, data, heads, headOpenIndex);

                  if (HazarondWaitframe(this, data, 45, heads))
                     break;
               }

               if (headOpen == 10)
                  if (heads[headOpenIndex] && heads[headOpenIndex]->isValid())
                     dropFlame(heads, headOpenIndex, eweaponStopper, DMG_DROPPED_FLAME);

               ++timeSinceLastAttack;
               --headOpen;

               EnemyWaitframe(this, data);
            }

            this->NoCollisionTimer = 0;
            int originalCSet = this->CSet;
            this->CSet = hurtCSet;

            for (int i = 0; i < 20; ++i) {
               if (i == NPCD_FIRE)
                  this->Defense[i] = NPCDT_IGNORE;
               else if (i == NPCD_ARROW)
                  this->Defense[i] = NPCDT_BLOCK;
               else
                  this->Defense[i] = NPCDT_NONE;
            }

            this->Defense[LW_SCRIPT1] = NPCDT_IGNORE;

            for (int i = 0; i < 10; ++i)
               EnemyWaitframe(this, data);

            int previousX, previousY, prevIndex;

            int fleeDuration = 5 * 60;

            while (fleeDuration) {
               this->Defense[LW_SCRIPT1] = NPCDT_IGNORE;

               if (this->HP <= 0)
                  deathAnimation(this, 142);

               angle = RadtoDeg(TurnTowards(CenterX(this), CenterY(this), CenterLinkX(), CenterLinkY(), 0, 1));

               if ((!(this->CanMove(this->Dir, 1, 0)) || (this->X == previousX && this->Y == previousY)) && linkClose(this, 48))
                  stuckAction(this, data, fleeDuration);

               previousX = this->X;
               previousY = this->Y;

               this->MoveAtAngle(180 + angle, 1, SPW_NONE);

               --fleeDuration;
               EnemyWaitframe(this, data);
            }

            EnemyWaitframe(this, data, 60);

            if (this->HP <= 0)
               deathAnimation(this, 142);

            int centerX = 256 / 2;
            int centerY = 176 / 2 - 16;

            while (Distance(this->X + this->HitXOffset + this->HitWidth / 2, this->Y + this->HitYOffset + this->HitHeight / 2, centerX, centerY) > 3)
               while (MoveTowardsPoint(this, centerX, centerY, 2, SPW_FLOATER, true))
                  EnemyWaitframe(this, data, 2);

            this->NoCollisionTimer = -1;

            for (int i = 0; i < 20; ++i)
               this->Defense[i] == NPCDT_IGNORE;

            data[DATA_INVIS] = true;

            for (int i = 0; i < 32; ++i) {
               for (int j = 0; j < 4; ++j) {
                  effectBitmap->Clear(0);
                  effectBitmap->DrawTile(4, this->X, this->Y + i, this->ScriptTile, 2, 2, this->CSet, -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
                  effectBitmap->Rectangle(4, this->X - 8, 167, this->X + 39, this->Y + 31, 0, -1, 0, 0, 0, true, OP_OPAQUE);
                  effectBitmap->Blit(4, RT_SCREEN, 0, 0, 256, 168, 0, 0, 256, 168, 0, 0, 0, BITDX_NORMAL, 0, true);
                  Screen->DrawCombo(4, this->X, this->Y + 24, 6725, 1, 1, 2, -1, -1, 0, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
                  Screen->DrawCombo(4, this->X + 16, this->Y + 24, 6725, 1, 1, 2, -1, -1, 0, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);

                  EnemyWaitframe(this, data);
               }
            }

            for (int headIndex = 0; headIndex < 4; ++headIndex) {
               heads[headIndex] = Screen->CreateNPC(minion);
               heads[headIndex]->InitD[0] = this;
               heads[headIndex]->Dir = headIndex + 4;
               heads[headIndex]->DrawXOffset = 1000;
               heads[headIndex]->NoCollisionTimer = -1;
               heads[headIndex]->Defense[NPCD_SCRIPT1] = NPCDT_IGNORE;
            }

            this->CSet = originalCSet;

            for (int i = 31; i >= 0; --i) {
               for (int j = 0; j < 4; ++j) {
                  effectBitmap->Clear(0);
                  effectBitmap->DrawTile(4, this->X, this->Y + i, this->ScriptTile, 2, 2, this->CSet, -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);

                  for (int headIndex = 0; headIndex < 4; ++headIndex)
                     effectBitmap->DrawTile(4, heads[headIndex]->X, heads[headIndex]->Y + i - 2, heads[headIndex]->ScriptTile, 1, 1, heads[headIndex]->CSet, -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);

                  effectBitmap->Rectangle(4, this->X - 8, 167, this->X + 39, this->Y + 31, 0, -1, 0, 0, 0, true, OP_OPAQUE);
                  effectBitmap->Blit(4, RT_SCREEN, 0, 0, 256, 168, 0, 0, 256, 168, 0, 0, 0, BITDX_NORMAL, 0, true);
                  Screen->DrawCombo(4, this->X, this->Y + 24, 6725, 1, 1, 2, -1, -1, 0, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
                  Screen->DrawCombo(4, this->X + 16, this->Y + 24, 6725, 1, 1, 2, -1, -1, 0, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);

                  EnemyWaitframe(this, data);
               }
            }

            this->HP += 6;
            data[DATA_INVIS] = false;
            this->NoCollisionTimer = 0;

            for (int headIndex = 0; headIndex < 4; ++headIndex)
               heads[headIndex]->DrawXOffset = 0;
         }

         this->NoCollisionTimer = -1;
         deathAnimation(this, 142);
      }
   }

   enum Attacks {
      GROUND_POUND,
      OIL_CANNON,
      OIL_SPRAY,
      FLAME_TOSS,
      FLAME_CANNON
   };

   void groundPound(npc this, int data, npc heads, int headOpenIndex) {
      for (int i = 0; i < 20; ++i) {
         this->ScriptTile = this->OriginalTile + 40;
         EnemyWaitframe(this, data);
      }

      const int JUMP_SPEED = 2;
      int linkX = CenterLinkX(), linkY = CenterLinkY();

      this->Jump = 2;
      this->Z = 12.5;

      this->ScriptTile = this->OriginalTile + 42;

      while (MoveTowardsPoint(this, linkX, linkY, JUMP_SPEED, SPW_FLOATER, true))
         Waitframe();

      while (this->Z) {
         if (isHeadsDead(heads))
            return;
         Waitframe();
      }

      Screen->Quake = 30;

      for (int i = 0; i < 20; ++i) {
         this->ScriptTile = this->OriginalTile + 40;
         EnemyWaitframe(this, data);
      }

      this->ScriptTile = this->OriginalTile;
   }

   void commenceIntroSequence(npc this, int data, npc heads) {
      bitmap introSequenceBitmap;

      introSequenceBitmap = create(512, 176);
      int panPosition = 0;
      disableLink();

      this->X = -64;
      this->Y = -64;
      Hero->Dir = DIR_RIGHT;
      Hero->InvisibleTimer = -2;

      // Silent Pause
      Audio->PlayEnhancedMusic(null, 0);
      introSequenceBitmap->Clear(0);

      CONFIG SFX_STEP = 121;
      CONFIG SFX_ROAR = 142;
      CONFIG SFX_SPLASH = 26;

      // Pause
      for (int i = 0; i < 60; ++i) {
         disableLink();

         introCutsceneDraws(introSequenceBitmap, true, false, true, true, false, true);
         introSequenceBitmap->Blit(2, RT_SCREEN, 0, 0, 512, 176, 0, 0, 512, 176, 0, 0, 0, BITDX_NORMAL, 0, true);

         Waitframe();
      }

      // Start Panning
      until(panPosition >= 40) {
         disableLink();
         panPosition += 4;

         introCutsceneDraws(introSequenceBitmap, true, true, true, false, false);
         introSequenceBitmap->Blit(2, RT_SCREEN, panPosition, 0, 512, 176, 0, 0, 512, 176, 0, 0, 0, BITDX_NORMAL, 0, true);

         Waitframe();
      }

      // Panning right
      until(panPosition >= 100) {
         disableLink();
         panPosition += 6;

         introCutsceneDraws(introSequenceBitmap, true, true, true, false, false);
         introSequenceBitmap->Blit(2, RT_SCREEN, panPosition, 0, 512, 176, 0, 0, 512, 176, 0, 0, 0, BITDX_NORMAL, 0, true);

         Waitframe();
      }

      this->X = 260;
      this->Y = 64;

      // Panning right
      until(panPosition >= 180) {
         disableLink();
         panPosition += 8;

         if (panPosition > 170)
            this->X -= 8;

         introCutsceneDraws(introSequenceBitmap, true, true, true, false, false);
         introSequenceBitmap->Blit(2, RT_SCREEN, panPosition, 0, 512, 176, 0, 0, 512, 176, 0, 0, 0, BITDX_NORMAL, 0, true);

         Waitframe();
      }

      // Panning right
      until(panPosition >= 230) {
         disableLink();
         panPosition += 5;
         this->X -= 5;

         introCutsceneDraws(introSequenceBitmap, true, true, true, false, false);
         introSequenceBitmap->Blit(2, RT_SCREEN, panPosition, 0, 512, 176, 0, 0, 512, 176, 0, 0, 0, BITDX_NORMAL, 0, true);

         Waitframe();
      }

      // Panning right
      until(panPosition >= 256) {
         disableLink();
         panPosition += 1;
         this->X -= 1;

         introCutsceneDraws(introSequenceBitmap, true, true, true, false, false);
         introSequenceBitmap->Blit(2, RT_SCREEN, panPosition, 0, 512, 176, 0, 0, 512, 176, 0, 0, 0, BITDX_NORMAL, 0, true);

         Waitframe();
      }

      // Pausing on him
      for (int i = 0; i < 60; ++i) {
         disableLink();
         introCutsceneDraws(introSequenceBitmap, false, true, false, false, false);
         introSequenceBitmap->Blit(2, RT_SCREEN, panPosition, 0, 512, 176, 0, 0, 512, 176, 0, 0, 0, BITDX_NORMAL, 0, true);
         Waitframe();
      }

      int timer = 0;
      int yModifier = 0, xModifier = -1;

      // Panning back into boss room
      until(panPosition <= 0) {
         disableLink();
         --panPosition;
         ++timer;

         if (timer < 24) {
            unless(timer % 3) yModifier = -3.8;
            else yModifier = 0;
         }
         else if (timer < 112)
            yModifier = 0;
         else if (timer < 148) {
            unless(timer % 3) yModifier = 2;
            else yModifier = 0;
         }
         else if (timer < 232)
            yModifier = 0;

         this->Y += yModifier;

         introCutsceneDraws(introSequenceBitmap, true, true, true, false, false);

         if (!(panPosition % 16) || panPosition == 254)
            Audio->PlaySound(SFX_STEP);

         introSequenceBitmap->Blit(2, RT_SCREEN, panPosition, 0, 512, 176, 0, 0, 512, 176, 0, 0, 0, BITDX_NORMAL, 0, true);

         EnemyWaitframe(this, data);
      }

      // Wait and Roars
      for (int i = 0; i < 60; ++i) {
         disableLink();
         introCutsceneDraws(introSequenceBitmap, true, false, true, true, false);
         introSequenceBitmap->Blit(2, RT_SCREEN, panPosition, 0, 512, 176, 0, 0, 512, 176, 0, 0, 0, BITDX_NORMAL, 0, true);
         Waitframe();
      }

      introCutsceneDraws(introSequenceBitmap, true, false, true, true, true, true);

      Hero->InvisibleTimer = 0;

      this->Jump = 4;
      this->Z = 12.5;

      until (this->Z == 0) {
         NoAction();
         Waitframe();
      }

      Audio->PlaySound(SFX_BOMB_BLAST);
      Screen->Quake = 20;

      mapdata mapDataLayer1 = Game->LoadTempScreen(1);
      mapDataLayer1->ComboD[94] = CMB_INVIS;
      mapDataLayer1->ComboD[95] = CMB_INVIS;

      for (int i = 0; i < 60; ++i) {
         NoAction();
         Waitframe();
      }

      Audio->PlaySound(SFX_ROAR);
      Audio->PlayEnhancedMusic("The Binding of Isaac - Divine Combat.ogg", 0);
   }

   void introCutsceneDraws(bitmap introSequenceBitmap, bool doFirstScreen, bool doSecondScreen, bool doLink, bool doWaterfalls, bool redrawWaterfalls, bool redrawTopWaterfalls = false) {
      CONFIG CMB_SHUTTER = 6957;
      CONFIG CMB_LINK = 6731;
      CONFIG CMB_WATERFALL = 1129;
      CONFIG CMB_WATERFALL_BOTTOM = 1133;

      if (doFirstScreen)
         introSequenceBitmap->DrawScreen(2, 37, 43, 0, 0);
      if (doSecondScreen)
         introSequenceBitmap->DrawScreen(2, 37, 44, 256, 0);
      if (doLink) {
         introSequenceBitmap->FastCombo(2, 112, 0, CMB_SHUTTER, 2, OP_OPAQUE);
         introSequenceBitmap->FastCombo(2, 128, 0, CMB_SHUTTER, 2, OP_OPAQUE);
         introSequenceBitmap->FastCombo(2, 120, 120, CMB_LINK, 0, OP_OPAQUE);
      }
      if (doWaterfalls) {
         mapdata bossRoom3 = Game->LoadTempScreen(3);
         introSequenceBitmap->FastCombo(3, 112, 0, CMB_WATERFALL, 0, OP_TRANS);
         introSequenceBitmap->FastCombo(3, 128, 0, CMB_WATERFALL, 0, OP_TRANS);
      }

      mapdata bossRoom2 = Game->LoadTempScreen(2);
      mapdata bossRoom3 = Game->LoadTempScreen(3);

      bossRoom2->ComboD[71] = redrawWaterfalls ? CMB_WATERFALL_BOTTOM : CMB_INVIS;
      bossRoom2->ComboD[72] = redrawWaterfalls ? CMB_WATERFALL_BOTTOM : CMB_INVIS;
      bossRoom2->ComboD[87] = redrawWaterfalls ? CMB_WATERFALL_BOTTOM : CMB_INVIS;
      bossRoom2->ComboD[88] = redrawWaterfalls ? CMB_WATERFALL_BOTTOM : CMB_INVIS;

      if (redrawTopWaterfalls) {
         bossRoom3->ComboD[7] = redrawWaterfalls ? CMB_WATERFALL : CMB_INVIS;
         bossRoom3->ComboD[8] = redrawWaterfalls ? CMB_WATERFALL : CMB_INVIS;
      }

      bossRoom3->ComboD[23] = redrawWaterfalls ? CMB_WATERFALL : CMB_INVIS;
      bossRoom3->ComboD[24] = redrawWaterfalls ? CMB_WATERFALL : CMB_INVIS;

      bossRoom3->ComboD[39] = redrawWaterfalls ? CMB_WATERFALL : CMB_INVIS;
      bossRoom3->ComboD[40] = redrawWaterfalls ? CMB_WATERFALL : CMB_INVIS;

      bossRoom3->ComboD[55] = redrawWaterfalls ? CMB_WATERFALL : CMB_INVIS;
      bossRoom3->ComboD[56] = redrawWaterfalls ? CMB_WATERFALL : CMB_INVIS;

      bossRoom3->ComboD[71] = redrawWaterfalls ? CMB_WATERFALL : CMB_INVIS;
      bossRoom3->ComboD[72] = redrawWaterfalls ? CMB_WATERFALL : CMB_INVIS;
   }

   void dropFlame(npc[] heads, int headOpenIndex, int eweaponStopper, int damage) {
      eweapon flame = CreateEWeaponAt(EW_FIRE, heads[headOpenIndex]->X, heads[headOpenIndex]->Y + 8);
      flame->Dir = heads[headOpenIndex]->Dir;
      flame->Step = RandGen->Rand(125, 175);
      flame->Angular = true;
      flame->Angle = DirRad(flame->Dir);
      flame->Script = eweaponStopper;
      flame->Z = heads[headOpenIndex]->Z + 8;
      flame->InitD[0] = RandGen->Rand(8, 15);
      flame->InitD[1] = RandGen->Rand(60, 180);
      flame->Gravity = true;
      flame->Damage = damage;
      flame->UseSprite(SPR_FLAME_OIL);
   }

   void oilSpray(int data, npc this, npc heads, bool isDifficultyChange, int damage) {
      int attackingCounter = 30;
      bool modTile = false;

      this->ScriptTile = this->OriginalTile;

      EnemyWaitframe(this, data, 60);

      while (--attackingCounter) {
         if (isHeadsDead(heads))
            break;

         modTile = attackingCounter % 2;

         if (modTile)
            this->ScriptTile = this->OriginalTile + 40;
         else
            this->ScriptTile = this->OriginalTile;

         eweapon oilBlob = FireEWeaponAtHero(EW_SCRIPT1, CenterX(this) - 8, CenterY(this) - 8, true, 255, damage, 117, 0, Game->GetEWeaponScript("ArcingWeapon"),
            {-1, 0, AE_OIL_BLOB, this, damage, 0, true}
         );
         oilBlob->Unblockable = UNBLOCK_ALL;

         Audio->PlaySound(SFX_SQUISH);
         EnemyWaitframe(this, data, 5);
      }

      EnemyWaitframe(this, data, 60);
   }

   bool isHeadsDead(npc[] heads) {
      bool dead = true;

      for (int headIndex = 0; headIndex < 4; ++headIndex) {
         if (heads[headIndex] && heads[headIndex]->isValid() && heads[headIndex]->HP > 0)
            dead = false;
         else
            heads[headIndex] = NULL;
      }

      return dead;
   }

   bool HazarondWaitframe(npc n, int data, int frames, npc heads) {
      while (frames--) {
         if (isHeadsDead(heads))
            return true;

         EnemyWaitframe(n, data);

         return false;
      }

      return false;
   }

   void stuckAction(npc this, untyped data, int fleeDuration) {
      for (int i = 0; i < 20; ++i) {
         this->ScriptTile = this->OriginalTile + 40;
         EnemyWaitframe(this, data);
      }

      const int JUMP_SPEED = 2;
      int centerX = 256 / 2, centerY = 176 / 2 - 16;

      this->Jump = 4;
      this->Z = 12.5;

      this->ScriptTile = this->OriginalTile + 42;

      while (MoveTowardsPoint(this, centerX, centerY, JUMP_SPEED, SPW_FLOATER, true))
         Waitframe();

      while (this->Z)
         Waitframe();

      Screen->Quake = 30;

      for (int i = 0; i < 20; ++i) {
         this->ScriptTile = this->OriginalTile + 40;
         EnemyWaitframe(this, data);
      }

      this->ScriptTile = this->OriginalTile;
      fleeDuration -= 10;
   }

   npc script HazarondHead {
      void run(npc parent) {
         unless(parent) this->Remove();

         while (true) {
            this->Defense[LW_SCRIPT1] = NPCDT_IGNORE;
            this->X = (parent->X + (parent->HitWidth / 2) + parent->HitXOffset) + getDrawLocationX(this);
            this->Y = (parent->Y + (parent->HitHeight / 2) + parent->HitYOffset) + getDrawLocationY(this) - 2;
            this->Z = parent->Z;

            this->ScriptTile = this->OriginalTile + this->Dir * 20 + 1;
            Waitframe();
         }
      }

      int getDrawLocationX(npc parent) {
         if (parent->Dir & 100b) {
            if (parent->Dir & 1b)
               return 4;
            else
               return -20;
         }
         else {
            if (parent->Dir == DIR_RIGHT)
               return 8;
            else {
               if (parent->Dir == DIR_LEFT)
                  return -24;
               else
                  return 0;
            }
         }
      }

      int getDrawLocationY(npc parent) {
         if (parent->Dir & 100b) {
            if (parent->Dir & 10b)
               return -6;
            else
               return -23;
         }
         else {
            if (parent->Dir == DIR_DOWN)
               return -2;
            else if (parent->Dir == DIR_UP)
               return -27;
            else
               return -10;
         }
      }
   }
}

namespace OvergrownRaccoonNamespace {
   using namespace EnemyNamespace;

   enum State {
      STATE_NORMAL,
      STATE_SMALL_ROCKS_THROW,
      STATE_LARGE_ROCK_THROW,
      STATE_RACCOON_THROW,
      STATE_CHARGE
   };

   // clang-format off
   @Author("EmilyV99, Deathrider365")
   npc script OvergrownRaccoon {
      // clang-format on

      using namespace EnemyNamespace;

      void run() {
         CONFIG DMG_BOULDER = this->WeaponDamage;
         CONFIG DMG_ROCK = this->WeaponDamage / 2;
         CONFIG DMG_PEBBLE = this->WeaponDamage / 4;

         State state = STATE_NORMAL;
         State previousState = state;
         const int maxHp = this->HP;
         int timer;

         this->Dir = faceLink(this);
         Hero->NoCollisionTimer = -1;

         until(this->Z == 0) {
            disableLink();

            if (this->HP <= 0)
               deathAnimation(this, 136);

            Waitframe();
         }

         Screen->Quake = 60;
         Audio->PlaySound(SFX_IMPACT_EXPLOSION);

         for (int i = 0; i < 30; ++i) {
            disableLink();

            if (this->HP <= 0)
               deathAnimation(this, 136);

            Waitframe();
         }

         unless(getScreenD(255)) {
            Screen->Message(805);
            setScreenD(255, true);
         }

         Hero->NoCollisionTimer = 0;

         loop () {
            if (this->HP <= 0)
               deathAnimation(this, 136);

            int randModifier = isDifficultyChange(this, maxHp) ? Rand(-90, 30) : Rand(-60, 60);

            if (++timer > 120 + randModifier) {
               timer = 0;
               int attackChoice = 0;

               if (Screen->NumNPCs > 5) {
                  if (previousState == STATE_RACCOON_THROW)
                     attackChoice = STATE_CHARGE;
                  else
                     attackChoice = Rand(1, 2);
               }
               else {
                  if (previousState == STATE_NORMAL)
                     attackChoice = STATE_CHARGE;
                  else if (previousState == STATE_RACCOON_THROW)
                     attackChoice = Rand(0, 60) > 15 ? 4 : 3;
                  else if (previousState == STATE_CHARGE)
                     attackChoice = Rand(0, 60) > 20 ? STATE_CHARGE : STATE_SMALL_ROCKS_THROW;
                  else if (previousState == STATE_SMALL_ROCKS_THROW)
                     attackChoice = STATE_LARGE_ROCK_THROW;
                  else
                     attackChoice = Rand(1, 4);
               }

               state = parseAttackChoice(attackChoice);
            }

            switch (state) {
               case STATE_NORMAL: {
                  this->ScriptTile = -1;
                  doWalk(this, 5, 10, this->Step);
                  break;
               }
               case STATE_LARGE_ROCK_THROW: {
                  previousState = state;

                  this->ScriptTile = this->OriginalTile + (this->Tile % 8) + 52;

                  for (int i = 0; i < 60; i++) {
                     if (this->HP <= 0)
                        deathAnimation(this, 136);

                     Waitframe();
                  }

                  eweapon rockProjectile = FireEWeaponAtHero(EW_SCRIPT10, CenterX(this) - 8, CenterY(this) - 8, true, 255, DMG_BOULDER, 119, 0, Game->GetEWeaponScript("ArcingWeapon"),
                     {-1, 0, AE_BOULDER_PROJECTILE, this, DMG_ROCK, 0, true}
                  );
                  rockProjectile->Unblockable = UNBLOCK_ALL;
                  rockProjectile->HitHeight = 32;
                  rockProjectile->HitWidth = 32;
                  rockProjectile->TileHeight = 2;
                  rockProjectile->TileWidth = 2;
                  rockProjectile->Extend = EXT_NORMAL; //TODO may not need to do this

                  Audio->PlaySound(SFX_LAUNCH_BOMBS);
                  state = STATE_NORMAL;
                  break;
               }
               case STATE_SMALL_ROCKS_THROW: {
                  previousState = state;

                  for (int i = 0; i < 30; i++) {
                     if (this->HP <= 0)
                        deathAnimation(this, 136);

                     Waitframe();
                  }

                  for (int i = 0; i < 60; ++i) {
                     if (this->HP <= 0)
                        deathAnimation(this, 136);

                     this->ScriptTile = this->OriginalTile + (this->Tile % 8) + 52;

                     unless(i % 20) {
                        eweapon rockProjectile = FireEWeaponAtHero(EW_SCRIPT10, CenterX(this) - 8, CenterY(this) - 8, true, 255, DMG_ROCK, SPR_SMALL_ROCK, 0, Game->GetEWeaponScript("ArcingWeapon"),
                           {-1, 0, AE_ROCK_PROJECTILE, this, DMG_PEBBLE, 0, true}
                        );
                        rockProjectile->Unblockable = UNBLOCK_ALL;

                        Audio->PlaySound(SFX_LAUNCH_BOMBS);
                     }

                     Waitframe();
                  }

                  state = STATE_NORMAL;
                  break;
               }
               case STATE_RACCOON_THROW: {
                  previousState = state;

                  for (int i = 0; i < 60; i++) {
                     if (this->HP <= 0)
                        deathAnimation(this, 136);

                     Waitframe();
                  }

                  for (int i = 0; i < 2; ++i) {
                     if (this->HP <= 0)
                        deathAnimation(this, 136);

                     this->ScriptTile = this->OriginalTile + (this->Tile % 8) + 52;

                     for (int i = 0; i < 5; i++) {
                        if (this->HP <= 0)
                           deathAnimation(this, 136);

                        Waitframe();
                     }

                     eweapon raccoonProjectile = FireEWeaponAtHero(EW_SCRIPT10, CenterX(this) - 8, CenterY(this) - 8, true, 255, 2, 121, 0, Game->GetEWeaponScript("ArcingWeapon"),
                        {-1, 0, AE_RACCOON_PROJECTILE, this, true}
                     );
                     raccoonProjectile->Unblockable = UNBLOCK_ALL;

                     Audio->PlaySound(SFX_LAUNCH_BOMBS);
                  }

                  state = STATE_NORMAL;
                  break;
               }
               case STATE_CHARGE: {
                  previousState = state;

                  int angle = RadtoDeg(TurnTowards(CenterX(this), CenterY(this), CenterLinkX(), CenterLinkY(), 0, 1));
                  this->Dir = AngleDir4(angle);
                  this->ScriptTile = -1;

                  this->Jump = 2.5;

                  Waitframe();

                  while (this->Z) {
                     if (this->HP <= 0)
                        deathAnimation(this, 136);

                     Waitframe();
                  }

                  while (this->MoveAtAngle(angle, 4, SPW_NONE)) {
                     if (this->HP <= 0)
                        deathAnimation(this, 136);

                     this->ASpeed = 200;

                     Waitframe();
                  }

                  this->Jump = 2;
                  Screen->Quake = 30;
                  Audio->PlaySound(SFX_IMPACT_EXPLOSION);

                  Waitframe();

                  while (this->Z) {
                     if (this->HP <= 0)
                        deathAnimation(this, 136);

                     Waitframe();
                  }

                  this->ASpeed = 100;
                  state = STATE_NORMAL;
                  break;
               }
            }

            Waitframe();
         }
      }
   }

   State parseAttackChoice(int attackChoice) {
      switch (attackChoice) {
         case 0: return STATE_NORMAL;
         case 1: return STATE_SMALL_ROCKS_THROW;
         case 2: return STATE_LARGE_ROCK_THROW;
         case 3: return STATE_RACCOON_THROW;
         case 4: return STATE_CHARGE;
         default: return STATE_CHARGE;
      }
   }
}

namespace ServusMalusNamespace {
   using namespace EnemyNamespace;

   CONFIG SCREEND_DID_CUTSCENE = 254;
   CONFIG SCREEND_SOLDIER_IS_OOF = 253;

   // clang-format off
   @Author("EmilyV99, Moosh, Deathrider365")
   npc script ServusMalus {
      // clang-format on

      using namespace EnemyNamespace;

      void run() {
         CONFIG originalTile = this->OriginalTile;
         CONFIG attackingTile = 49660;
         CONFIG unarmedTile = 49740;

         CONFIG DMG_SCYTHE_SLASH = this->WeaponDamage + this->WeaponDamage * .5;
         CONFIG DMG_SCYTHE_THROW = this->WeaponDamage + this->WeaponDamage * .75;
         CONFIG DMG_WIND = this->WeaponDamage + this->WeaponDamage * .2;

         bool gettingDesperate = false;
         bool torchesLit = false;
         int unlitTorch = 7156;
         int litTorch = 7157;

         int upperLeftTorchLoc = 36;
         int upperRightTorchLoc = 43;
         int lowerLeftTorchLoc = 132;
         int lowerRightTorchLoc = 139;

         int bigSummerBlowout = 6928;
         int invisibleTile = 49220;

         int attackCooldown, timer;

         combodata cmbLitTorch = Game->LoadComboData(litTorch);
         cmbLitTorch->Attributes[8] = 32;

         mapdata mapData, template;

         // this->X = -32;
         // this->Y = -32;

         this->X = 112;
         this->Y = 32;
         this->Dir = DIR_DOWN;
         this->OriginalTile = TILE_INVIS;

         int maxHp = this->HP;
         this->Immortal = true;

         Audio->PlayEnhancedMusic(NULL);

         //If already went through the cutscene, bypass it
         if (getScreenD(SCREEND_DID_CUTSCENE))
            Audio->PlayEnhancedMusic("Bloodborne PSX - Cleric Beast.ogg"); //TODO dont refer to music files directly

         //If didnt do cutscene, just dew it!
         until(getScreenD(SCREEND_DID_CUTSCENE)) {
            this->NoCollisionTimer = -1;
            int litTorchCount = 0;

            template = Game->LoadTempScreen(1);

            litTorchCount += <int>(template->ComboD[upperLeftTorchLoc] == litTorch);
            litTorchCount += <int>(template->ComboD[upperRightTorchLoc] == litTorch);
            litTorchCount += <int>(template->ComboD[lowerLeftTorchLoc] == litTorch);
            litTorchCount += <int>(template->ComboD[lowerRightTorchLoc] == litTorch);

            checkTorchBrightness(litTorchCount, cmbLitTorch);

            if (litTorchCount == 4) {
               torchesLit = true;
               setScreenD(SCREEND_DID_CUTSCENE, true);
               commenceIntroCutscene(this, template, unlitTorch, cmbLitTorch, bigSummerBlowout, upperLeftTorchLoc, upperRightTorchLoc, lowerLeftTorchLoc, lowerRightTorchLoc, originalTile, attackingTile);

               Audio->PlayEnhancedMusic("Bloodborne PSX - Cleric Beast.ogg", 0);
               Screen->Message(806);
            }

            Waitframe();
         }

         this->NoCollisionTimer = -1;

         loop () {
            this->Z = 20;
            this->NoCollisionTimer = -1;
            this->OriginalTile = invisibleTile;

            int blowOutRandomTorchTimer = 180;
            int chosenTorch;
            int spawnTimer = 90;
            int maxEnemies = 5;

            torchesLit = false;
            int vectorX, vectorY;

            until(torchesLit) {
               template = Game->LoadTempScreen(1);

               int litTorchCount = 0;

               int litTorches[4];
               int allTorches[4] = {upperLeftTorchLoc, upperRightTorchLoc, lowerLeftTorchLoc, lowerRightTorchLoc};

               for (int q = 0; q < 4; ++q)
                  if (template->ComboD[allTorches[q]] == litTorch)
                     litTorches[litTorchCount++] = allTorches[q];

               ResizeArray(litTorches, litTorchCount);

               checkTorchBrightness(litTorchCount, cmbLitTorch);

               unless(chosenTorch || --blowOutRandomTorchTimer) {
                  for (int i = 0; i < SizeOfArray(litTorches); i++) {
                     if (!chosenTorch)
                        chosenTorch = litTorches[0];

                     int selectedTorchDistance = Distance(this->X - 12, this->Y - 12, ComboX(litTorches[i]) - 8, ComboY(litTorches[i]) - 8);
                     int chosenTorchDistance = Distance(this->X - 12, this->Y - 12, ComboX(chosenTorch) - 8, ComboY(chosenTorch) - 8);
                     chosenTorch = (chosenTorchDistance < selectedTorchDistance) ? chosenTorch : litTorches[i];
                  }

                  blowOutRandomTorchTimer = 120;
               }

               if (chosenTorch) {
                  int moveAngle = Angle(this->X + 12, this->Y + 12, ComboX(chosenTorch) + 8, ComboY(chosenTorch) + 8);

                  vectorX = VectorX(Hero->Step / 100, moveAngle);
                  vectorY = VectorY(Hero->Step / 100, moveAngle);

                  if (Distance(this->X + 12, this->Y + 12, ComboX(chosenTorch) + 8, ComboY(chosenTorch) + 8) < 16) {
                     if (int escr = CheckEWeaponScript("StopperKiller")) {
                        eweapon ewind = FireEWeaponDegAngle(EW_SCRIPT2, ComboX(chosenTorch), ComboY(chosenTorch), 5, DMG_WIND, 0, 128, 0, Game->GetEWeaponScript("StopperKiller"),
                           {0, 60}
                        );
                        ewind->Unblockable = UNBLOCK_ALL;
                     }

                     Audio->PlaySound(SFX_ONOX_TORNADO);
                     chosenTorch = 0;
                  }
               }
               else {
                  vectorX = lazyChase(vectorX, this->X + 12, Hero->X - 8, .05, Hero->Step / 100);
                  vectorY = lazyChase(vectorY, this->Y + 12, Hero->Y - 8, .05, Hero->Step / 100);
               }

               unless(spawnTimer) {
                  spawnEnemy(this);
                  spawnTimer = 90;
               }

               this->MoveXY(vectorX, vectorY, SPW_FLOATER);
               this->Dir = faceLink(this);

               if (litTorchCount == 4)
                  torchesLit = true;

               if ((Screen->NumNPCs - 1) < maxEnemies && chosenTorch == 0)
                  --spawnTimer;

               Waitframe();
            }

            Audio->PlaySound(SFX_MC_BOUNDCHEST_ROAR2);

            this->NoCollisionTimer = 0;
            this->OriginalTile = originalTile;

            for (int i = 0; i < 90; ++i)
               Waitframe();

            vectorX = 0;
            vectorY = 0;

            attackCooldown = gettingDesperate ? 60 : 90;
            timer = 0;
            CONFIG START_TIMER = 600;
            int dodgeTimer;

            while (timer < START_TIMER) {
               if (this->HP <= maxHp * .5)
                  gettingDesperate = true;

               float percent = timer / START_TIMER;

               cmbLitTorch->Attributes[8] = Lerp(24, 50, 1 - percent);

               if (this->HP <= 0) {
                  Screen->Message(1236);
                  deathAnimation(this, SFX_GOMESS_DIE);
               }

               if (this->Z > 0 && !(gameframe % 2))
                  this->Z -= 1;

               unless(attackCooldown) {
                  chooseAttack(this, originalTile, attackingTile, unarmedTile, gettingDesperate, DMG_SCYTHE_SLASH, DMG_SCYTHE_THROW);
                  attackCooldown = gettingDesperate ? 60 : 90;
               }

               int angle = Angle(Hero->X - 8, Hero->Y - 8, this->X, this->Y);

               int tX = Hero->X - 8 + VectorX(30, angle);
               int tY = Hero->Y - 8 + VectorY(30, angle);

               if (dodgeTimer)
                  --dodgeTimer;

               if (dodgeTimer || tX < 0 || tX > 255 - 32 || tY < 0 || tY > 175 - 32) {
                  tX = 128 - 16;
                  tY = 88 - 16;

                  unless(dodgeTimer) {
                     int dodgeAngle = Angle(this->X, this->Y, tX, tY);
                     int diff = angleDiff(dodgeAngle, angle);

                     dodgeAngle += diff < 0 ? -90 : 90;

                     vectorX = VectorX(Hero->Step / 100, dodgeAngle);
                     vectorY = VectorY(Hero->Step / 100, dodgeAngle);
                     dodgeTimer = 90;
                  }
               }

               vectorX = lazyChase(vectorX, this->X, tX, .05, Hero->Step / 100);
               vectorY = lazyChase(vectorY, this->Y, tY, .05, Hero->Step / 100);
               this->MoveXY(vectorX, vectorY, SPW_FLOATER);
               this->Dir = faceLink(this);

               --attackCooldown;
               ++timer;
               Waitframe();
            }

            while (Distance(this->X, this->Y, 128, 88) > 64) {
               if (this->HP <= 0) {
                  Screen->Message(1236);
                  deathAnimation(this, 148);
               }

               int angle = Angle(Hero->X - 8, Hero->Y - 8, this->X - 12, this->Y - 12);

               int tX = Hero->X - 8 + VectorX(30, angle);
               int tY = Hero->Y - 8 + VectorY(30, angle);

               if (dodgeTimer)
                  --dodgeTimer;

               if (dodgeTimer || tX < 0 || tX > 255 - 32 || tY < 0 || tY > 175 - 32) {
                  tX = 128 - 16;
                  tY = 88 - 16;

                  unless(dodgeTimer) {
                     int dodgeAngle = Angle(this->X, this->Y, tX, tY);
                     int diff = angleDiff(dodgeAngle, angle);

                     dodgeAngle += diff < 0 ? -90 : 90;

                     vectorX = VectorX(Hero->Step / 100, dodgeAngle);
                     vectorY = VectorY(Hero->Step / 100, dodgeAngle);
                     dodgeTimer = 90;
                  }
               }

               vectorX = lazyChase(vectorX, this->X, tX, .05, Hero->Step / 100);
               vectorY = lazyChase(vectorY, this->Y, tY, .05, Hero->Step / 100);
               this->MoveXY(vectorX, vectorY, SPW_FLOATER);
               this->Dir = faceLink(this);

               Waitframe();
            }

            int unlitTorchCount = 1;
            int multipler = 1;

            while (unlitTorchCount) {
               if (this->HP <= 0) {
                  Screen->Message(1236);
                  deathAnimation(this, 148);
               }

               unlitTorchCount = 0;

               unless(gameframe % 60) {
                  windBlast(this, originalTile, attackingTile, multipler);
                  ++multipler;
               }

               unlitTorchCount += <int>(template->ComboD[upperLeftTorchLoc] == litTorch);
               unlitTorchCount += <int>(template->ComboD[upperRightTorchLoc] == litTorch);
               unlitTorchCount += <int>(template->ComboD[lowerLeftTorchLoc] == litTorch);
               unlitTorchCount += <int>(template->ComboD[lowerRightTorchLoc] == litTorch);

               checkTorchBrightness(unlitTorchCount, cmbLitTorch, 1);

               Waitframe();
            }

            Waitframe();
         }
      }
   }

   //TODO do this cutscene with servus's actual NPC instead of combos
   void commenceIntroCutscene(npc this, mapdata template, int unlitTorch, combodata cmbLitTorch, int bigSummerBlowout, int upperLeftTorchLoc, int upperRightTorchLoc, int lowerLeftTorchLoc, int lowerRightTorchLoc, int originalTile, int attackingTile) {
      int soldierLeftFast = 6715;
      int soldierUpStunned = 6714;
      int soldierUpLaying = 6709;
      int soldierUp = 6722;
      int soldierDown = 6723;
      int soldierLeft = 6726;
      int soldierRight = 6727;

      CONFIG TILE_SERVUS_FACE_UP = 49140;
      CONFIG TILE_SERVUS_FACE_DOWN = 49148;
      CONFIG TILE_SERVUS_FACE_LEFT = 49156;
      CONFIG TILE_SERVUS_ATTACK_DOWN = 49272;
      CONFIG TILE_SERVUS_SPECRAL = 49220;
      int servusFullStartingCombo = 6916; //TODO if NPCs are able to animate during a string, get rid of all of these combo draws
      int servusTransStartingCombo = 6920;
      int servusAttackingStartingCombo = 6924;
      int servusMovingUpStartingCombo = 6932;
      int servusVanishingStartingCombo = 6936;
      int servusTurningStartingCombo = 6940;

      // Buffer
      for (int i = 0; i < 120; ++i) {
         disableLink();
         Waitframe();
      }

      Screen->Message(36);
      Hero->Dir = DIR_RIGHT;
      Waitframe();

      //Link walks back to the entrance for the soldier to enter
      until (Abs(Hero->X - 32) < 2 && Abs(Hero->Y - 80) < 2) {

         if (Hero->Y >= 81) Hero->InputUp = true;
         else if (Hero->Y <= 79) Hero->InputDown = true;


         if (Hero->X >= 33) Hero->InputLeft = true;
         else if (Hero->X <= 31) Hero->InputRight = true;

         Waitframe();
      }

      Hero->X = 32;
      Hero->Y = 80;
      Hero->Dir = DIR_RIGHT;

      int xLocation = 256;

      // Soldier walks in from right
      until(xLocation == 120) {
         disableLink();
         Screen->FastCombo(2, xLocation, 80, soldierLeftFast, 0, OP_OPAQUE);
         --xLocation;

         Waitframe();
      }

      // Turns up
      for (int i = 0; i < 120; ++i) {
         disableLink();
         Screen->FastCombo(2, 120, 80, soldierUp, 0, OP_OPAQUE);

         if (i == 60)
            Screen->Message(167);

         Waitframe();
      }

      // Turns left
      for (int i = 0; i < 120; ++i) {
         disableLink();
         Screen->FastCombo(2, 120, 80, soldierLeft, 0, OP_OPAQUE);

         if (i == 60)
            Screen->Message(168);

         Waitframe();
      }

      // Turns right
      for (int i = 0; i < 120; ++i) {
         disableLink();
         Screen->FastCombo(2, 120, 80, soldierRight, 0, OP_OPAQUE);

         if (i == 60)
            Screen->Message(169);

         Waitframe();
      }

      int modifier;
      int counter;
      bool alternate;

      // Turns up and buffer
      for (int i = 0; i < 60; ++i) {
         disableLink();

         if (i % 4)
            this->OriginalTile = TILE_SERVUS_SPECRAL;
         else
            this->OriginalTile = TILE_INVIS;

         Screen->FastCombo(1, 120, 80, soldierUp, 0, OP_OPAQUE);
         Waitframe();
      }

      Audio->PlayEnhancedMusic("Metroid Fusion - Environmental Intrigue.ogg", 0);

      // Servus apparates in
      for (int i = 0; i < 300; ++i) {
         disableLink();

         if (i < 120)
            modifier = 1;
         else if (i < 210)
            modifier = 2;
         else if (i < 270)
            modifier = 4;
         else if (i < 300)
            modifier = 8;

         if (counter > modifier) {
            counter = 0;
            alternate = !alternate;
         }

         if (alternate)
            this->OriginalTile = TILE_SERVUS_FACE_DOWN - 8;
         else
            this->OriginalTile = TILE_SERVUS_SPECRAL;

         Screen->FastCombo(2, 120, 80, soldierUp, 0, OP_OPAQUE);

         counter++;
         Waitframe();
      }

      this->OriginalTile = TILE_SERVUS_FACE_DOWN - 8;
      this->X = -32;
      this->Y = -32;
      Screen->Message(170);
      Screen->FastCombo(3, 112, 32, servusFullStartingCombo, 11, OP_OPAQUE);
      Screen->FastCombo(3, 128, 32, servusFullStartingCombo + 1, 11, OP_OPAQUE);
      Screen->FastCombo(3, 112, 48, servusFullStartingCombo + 2, 11, OP_OPAQUE);
      Screen->FastCombo(3, 128, 48, servusFullStartingCombo + 3, 11, OP_OPAQUE);
      Screen->FastCombo(2, 120, 80, soldierUp, 0, OP_OPAQUE);

      Waitframe();

      this->X = 112;
      this->Y = 32;

      // Servus fully appears
      for (int i = 0; i < 60; ++i) {
         disableLink();
         Screen->FastCombo(2, 120, 80, soldierUp, 0, OP_OPAQUE);
         Waitframe();
      }

      this->X = -32;
      this->Y = -32;
      Screen->Message(172);
      Screen->FastCombo(3, 112, 32, servusFullStartingCombo, 11, OP_OPAQUE);
      Screen->FastCombo(3, 128, 32, servusFullStartingCombo + 1, 11, OP_OPAQUE);
      Screen->FastCombo(3, 112, 48, servusFullStartingCombo + 2, 11, OP_OPAQUE);
      Screen->FastCombo(3, 128, 48, servusFullStartingCombo + 3, 11, OP_OPAQUE);
      Screen->FastCombo(2, 120, 80, soldierUp, 0, OP_OPAQUE);

      Waitframe();

      this->X = 112;
      this->Y = 32;

      // Buffer
      for (int i = 0; i < 60; ++i) {
         disableLink();
         Screen->FastCombo(2, 120, 80, soldierUp, 0, OP_OPAQUE);
         Waitframe();
      }

      this->X = -32;
      this->Y = -32;
      Screen->Message(174);
      Screen->FastCombo(3, 112, 32, servusFullStartingCombo, 11, OP_OPAQUE);
      Screen->FastCombo(3, 128, 32, servusFullStartingCombo + 1, 11, OP_OPAQUE);
      Screen->FastCombo(3, 112, 48, servusFullStartingCombo + 2, 11, OP_OPAQUE);
      Screen->FastCombo(3, 128, 48, servusFullStartingCombo + 3, 11, OP_OPAQUE);
      Screen->FastCombo(2, 120, 80, soldierUp, 0, OP_OPAQUE);

      Waitframe();

      this->X = 112;
      this->Y = 32;

      // Turns around
      for (int i = 0; i < 15; ++i) {
         disableLink();

         if (i < 8)
            this->Dir = DIR_LEFT;
         else
            this->Dir = DIR_UP;

         Screen->FastCombo(2, 120, 80, soldierUp, 0, OP_OPAQUE);

         Waitframe();
      }

      this->X = -32;
      this->Y = -32;
      Screen->Message(176);
      this->Dir = DIR_UP;
      Screen->FastCombo(3, 112, 32, servusMovingUpStartingCombo, 11, OP_OPAQUE);
      Screen->FastCombo(3, 128, 32, servusMovingUpStartingCombo + 1, 11, OP_OPAQUE);
      Screen->FastCombo(3, 112, 48, servusMovingUpStartingCombo + 2, 11, OP_OPAQUE);
      Screen->FastCombo(3, 128, 48, servusMovingUpStartingCombo + 3, 11, OP_OPAQUE);
      Screen->FastCombo(2, 120, 80, soldierUp, 0, OP_OPAQUE);

      Waitframe();

      this->X = 112;
      this->Y = 32;

      // Turns back around
      for (int i = 0; i < 15; ++i) {
         disableLink();

         if (i < 8)
            this->Dir = DIR_LEFT;
         else
            this->Dir = DIR_DOWN;

         Screen->FastCombo(2, 120, 80, soldierUp, 0, OP_OPAQUE);

         Waitframe();
      }

      // Servus about to charge
      for (int i = 0; i < 30; ++i) {
         disableLink();

         Screen->FastCombo(2, 120, 80, soldierUp, 0, OP_OPAQUE);
         Waitframe();
      }

      // Servus charges at soldier
      for (int i = 0; i < 30; ++i) {
         disableLink();
         this->OriginalTile = TILE_SERVUS_ATTACK_DOWN - 8;
         this->Y += 1;

         Screen->FastCombo(2, 120, 80, soldierUp, 0, OP_OPAQUE);
         Waitframe();
      }

      //Soldier drops key when yeeted
      Audio->PlaySound(144);
      this->OriginalTile = TILE_SERVUS_FACE_DOWN - 8;
      itemsprite it = CreateItemAt(ITEM_GUARD_TOWER_KEY, 120, 96);
      it->Pickup = IP_HOLDUP;
      it->Z = 6;

      // Soldier flies back
      int distanceTraveled = 2;

      until(distanceTraveled == 64) {
         disableLink();
         Screen->FastCombo(2, 120, 80 + distanceTraveled, soldierUpStunned, 0, OP_OPAQUE);

         distanceTraveled += 2;
         Waitframe();
      }

      Audio->PlaySound(121);
      Screen->Quake = 20;
      setScreenD(SCREEND_SOLDIER_IS_OOF, true);

      // Buffer as soldier is against the wall
      for (int i = 0; i < 30; ++i) {
         disableLink();
         Waitframe();
      }

      this->X = -32;
      this->Y = -32;
      Screen->Message(179);
      this->Dir = DIR_LEFT;
      Screen->FastCombo(3, 112, 62, servusFullStartingCombo, 11, OP_OPAQUE);
      Screen->FastCombo(3, 128, 62, servusFullStartingCombo + 1, 11, OP_OPAQUE);
      Screen->FastCombo(3, 112, 78, servusFullStartingCombo + 2, 11, OP_OPAQUE);
      Screen->FastCombo(3, 128, 78, servusFullStartingCombo + 3, 11, OP_OPAQUE);

      Waitframe();

      this->X = 112;
      this->Y = 62;

      // Link intervenes
      until(Hero->X >= 120) {
         disableLink();

         if (Hero->Y <= 96) {
            Hero->InputRight = true;
            Hero->InputDown = true;
         }
         else
            Hero->InputRight = true;

         Waitframe();
      }

      this->Dir = DIR_DOWN;
      Hero->Dir = DIR_UP;

      // Buffer as link just got in front of Servus
      for (int i = 0; i < 30; ++i) {
         disableLink();

         Waitframe();
      }

      this->X = -32;
      this->Y = -32;
      Screen->Message(180);
      this->Dir = DIR_LEFT;
      Screen->FastCombo(3, 112, 62, servusFullStartingCombo, 11, OP_OPAQUE);
      Screen->FastCombo(3, 128, 62, servusFullStartingCombo + 1, 11, OP_OPAQUE);
      Screen->FastCombo(3, 112, 78, servusFullStartingCombo + 2, 11, OP_OPAQUE);
      Screen->FastCombo(3, 128, 78, servusFullStartingCombo + 3, 11, OP_OPAQUE);

      Waitframe();

      this->X = 112;
      this->Y = 62;

      // Buffer before Big Summer Blowout
      for (int i = 0; i < 30; ++i) {
         disableLink();
         Waitframe();
      }

      this->Dir = DIR_UP;

      // Servus moves up for the Big Summer Blowout
      for (int i = 0; i < 48; ++i) {
         disableLink();
         this->Y -= 1;
         Waitframe();
      }

      this->Dir = DIR_DOWN;

      // Buffer before Big Summer Blowout
      for (int i = 0; i < 30; ++i) {
         disableLink();
         Waitframe();
      }

      for (int i = 0; i < 60; ++i) {
         disableLink();
         this->OriginalTile = TILE_SERVUS_ATTACK_DOWN - 8;
         Waitframe();
      }

      // Big Summer Blowout
      Audio->PlaySound(SFX_ONOX_TORNADO);
      this->X = 112;
      this->Y = 16;
      windBlast(this, originalTile, attackingTile, 2);

      // Servus vanishes
      for (int i = 0; i < 20; ++i) {
         disableLink();

         if (i < 10)
            this->OriginalTile = TILE_SERVUS_FACE_DOWN - 8;
         else
            this->OriginalTile = TILE_SERVUS_SPECRAL;

         Waitframe();
      }
   }

   void checkTorchBrightness(int litTorchCount, combodata cmbLitTorch, int mode = 0) {
      switch (mode) {
         case 0:
            switch (litTorchCount) {
               case 0:
               case 1: {
                  cmbLitTorch->Attributes[8] = 36;
                  return;
               }
               case 2: {
                  cmbLitTorch->Attributes[8] = 40;
                  return;
               }
               case 3: {
                  cmbLitTorch->Attributes[8] = 58;
                  return;
               }
               case 4: {
                  cmbLitTorch->Attributes[8] = 64;
                  return;
               }
            }
            break;
         case 1:
            switch (litTorchCount) {
               case 0:
               case 1: {
                  cmbLitTorch->Attributes[8] = 12;
                  return;
               }
               case 2: {
                  cmbLitTorch->Attributes[8] = 16;
                  return;
               }
               case 3: {
                  cmbLitTorch->Attributes[8] = 20;
                  return;
               }
               case 4: {
                  cmbLitTorch->Attributes[8] = 24;
                  return;
               }
            }
            break;
      }
   }

   void spawnEnemy(npc this) {
      for (int i = 0; i < 30; ++i)
         Waitframe();

      Audio->PlaySound(SFX_MIRROR_SHIELD_ABSORB_LOOP);

      for (int i = 0; i <= 30; ++i) {
         unless(i % 5) i < 15 ? this->Z-- : this->Z++;

         Waitframe();
      }

      this->Z = 20;

      for (int i = 0; i < 45; ++i)
         Waitframe();

      Audio->PlaySound(SFX_SUMMON_MINE);

      npc enemy = Screen->CreateNPC(ENEMY_GHINI_SERVUS_SUMMON);
      enemy->X = this->X + 12;
      enemy->Y = this->Y + 12;

      for (int i = 0; i < 30; ++i)
         Waitframe();
   }

   void chooseAttack(npc this, int originalTile, int attackingTile, int unarmedTile, bool gettingDesperate, int slashDamage, int throwDamage) {
      if (Distance(this->X, this->Y, Hero->X, Hero->Y) <= (gettingDesperate ? 49 : 48))
         scytheSlash(this, originalTile, attackingTile, unarmedTile, gettingDesperate, slashDamage);

      if (Distance(this->X, this->Y, Hero->X, Hero->Y) > (gettingDesperate ? 48 : 49))
         scytheThrow(this, originalTile, attackingTile, unarmedTile, gettingDesperate, throwDamage);
   }

   void scytheSlash(npc this, int originalTile, int attackingTile, int unarmedTile, bool gettingDesperate, int damage) {
      for (int attackCount = 1; attackCount < (gettingDesperate ? 4 : 2); attackCount++) {
         if (this->HP <= 0) {
            Screen->Message(1236);
            deathAnimation(this, SFX_GOMESS_DIE);
         }

         int angle = Angle(this->X + 8, this->Y + 8, Hero->X, Hero->Y);
         this->OriginalTile = attackingTile;
         Audio->PlaySound(SFX_MC_BOUNDCHEST_ROAR2);

         int attackBuffer = gettingDesperate ? 15 : 30;
         Waitframes(attackCount == 1 ? attackBuffer + 5 : attackBuffer);

         for (int i = 0; i < (gettingDesperate ? 5 : 15); ++i)
            Waitframe();

         if (attackCount == 3)
            Waitframes(5);

         for (int i = 0; i < 15; ++i) {
            this->OriginalTile = unarmedTile;

            int vectorX = VectorX(this->Step / (40 - (attackCount * 7)), angle);
            int vectorY = VectorY(this->Step / (40 - (attackCount * 7)), angle);
            vectorX = lazyChase(vectorX, this->X, Hero->X, .05, this->Step);
            vectorY = lazyChase(vectorY, this->Y, Hero->Y, .05, this->Step);
            this->MoveXY(vectorX, vectorY, SPW_FLOATER);
            this->Dir = faceLink(this);

            sword2x1(this->X + 8, this->Y + 8, angle + Lerp((attackCount % 2 ? -90 : 90), (attackCount % 2 ? 90 : -90), i / 14), 16, 6944, 3, damage);

            Waitframe();
         }
         for (int i = 0; i < (gettingDesperate ? 8 : 15); ++i) {
            if (this->HP <= 0) {
               Screen->Message(1236);
               deathAnimation(this, SFX_GOMESS_DIE);
            }

            this->OriginalTile = originalTile;
            Waitframe();
         }
      }
   }

   void scytheThrow(npc this, int originalTile, int attackingTile, int unarmedTile, bool gettingDesperate, int damage) {
      Audio->PlaySound(SFX_MC_BOUNDCHEST_ROAR1);

      for (int i = 0; i < 30; ++i) {
         if (this->HP <= 0) {
            Screen->Message(1236);
            deathAnimation(this, SFX_GOMESS_DIE);
         }

         this->OriginalTile = attackingTile;
         Waitframe();
      }

      for (int i = 0; i < (gettingDesperate ? 2 : 1); i++) {
         if (this->HP <= 0) {
            Screen->Message(1236);
            deathAnimation(this, SFX_GOMESS_DIE);
         }

         if (i > 0)
            Audio->PlaySound(SFX_MC_BOUNDCHEST_ROAR1);

         this->OriginalTile = unarmedTile;

         eweapon scythe, scythe2;

         Audio->PlaySound(SFX_AXE2);

         scythe = FireEWeaponDegAngle(EW_SCRIPT3, this->X, this->Y, 0, 0, damage, 125, 0, Game->GetEWeaponScript("BoomerangThrow"),
            {this, Hero->X - 8, Hero->Y - 8, 7, 1, 0}
         );
         scythe->Unblockable = UNBLOCK_ALL;

         scythe->Extend = 3;
         scythe->TileWidth = 2;
         scythe->TileHeight = 2;
         scythe->HitWidth = 24;
         scythe->HitHeight = 24;
         scythe->HitXOffset = 4;
         scythe->HitYOffset = 4;
         scythe->Unblockable = UNBLOCK_ALL;

         if (gettingDesperate) {
            scythe2 = FireEWeaponDegAngle(EW_SCRIPT3, this->X, this->Y, 0, 0, damage, 125, 0, Game->GetEWeaponScript("BoomerangThrow"),
               {this, Hero->X - 8, Hero->Y - 8, 7, 1, 1}
            );
            scythe2->Unblockable = UNBLOCK_ALL;
            scythe2->Extend = 3;
            scythe2->TileWidth = 2;
            scythe2->TileHeight = 2;
            scythe2->HitWidth = 24;
            scythe2->HitHeight = 24;
            scythe2->HitXOffset = 4;
            scythe2->HitYOffset = 4;
         }

         while (scythe2->isValid() || scythe->isValid())
            Waitframe();

         for (int i = 0; i < 15; ++i) {
            if (this->HP <= 0) {
               Screen->Message(1236);
               deathAnimation(this, SFX_GOMESS_DIE);
            }

            this->OriginalTile = attackingTile;
            Waitframe();
         }
      }

      for (int i = 0; i < 15; ++i) {
         if (this->HP <= 0) {
            Screen->Message(1236);
            deathAnimation(this, SFX_GOMESS_DIE);
         }

         this->OriginalTile = originalTile;
         Waitframe();
      }
   }

   void windBlast(npc this, int originalTile, int attackingTile, int mult = 1) {
      CONFIG WIND_COUNT = 8;

      Audio->PlaySound(SFX_MC_BOUNDCHEST_ROAR1AND2);

      int wc = WIND_COUNT * mult;
      int angle = RadtoDeg(TurnTowards(CenterX(this), CenterY(this), CenterLinkX(), CenterLinkY(), 0, 1));
      int inc = 360 / wc;

      Audio->PlaySound(SFX_ONOX_TORNADO);
      this->OriginalTile = attackingTile;

      for (int i = 0; i < 15; i++) {
         unless(i % 5) {
            switch (this->Dir) {
               case DIR_UP: {
                  this->Dir = DIR_RIGHT;
                  break;
               }
               case DIR_DOWN: {
                  this->Dir = DIR_LEFT;
                  break;
               }
               case DIR_RIGHT: {
                  this->Dir = DIR_DOWN;
                  break;
               }
               case DIR_LEFT: {
                  this->Dir = DIR_UP;
                  break;
               }
            }
         }
         Waitframe();
      }

      WindHandler.init();

      for (int i = 0; i < wc; ++i) {
         if (this->HP <= 0) {
            Screen->Message(1236);
            deathAnimation(this, SFX_GOMESS_DIE);
         }

         eweapon ewind = FireEWeaponDegAngle(EW_SCRIPT2, CenterX(this) - 8, CenterY(this) - 8, WrapDegrees(angle + inc * i), 250, 0, 128, 0, Game->GetEWeaponScript("EwWindBlast"));
         ewind->Unblockable = UNBLOCK_ALL;
      }

      this->OriginalTile = originalTile;
   }

   eweapon script BoomerangThrow {
      void run(npc parent, int tX, int tY, int step, int skew, int clockWise) {
         for (int i = 0; i < 360;) {
            int cX = (parent->X + tX) / 2;
            int cY = (parent->Y + tY) / 2;
            int r = Distance(cX, cY, parent->X, parent->Y);
            int ang = Angle(cX, cY, parent->X, parent->Y);
            int rstep = step / (2 * PI * (r + r * skew / 2)) * 360;

            int axis1 = VectorX(r, i);
            int axis2 = VectorY(r * skew, i);

            this->X = cX + VectorX(axis1, ang) + VectorX(axis2, ang + (clockWise ? 90 : -90));
            this->Y = cY + VectorY(axis1, ang) + VectorY(axis2, ang + (clockWise ? 90 : -90));

            i += rstep;
            this->DeadState = WDS_ALIVE;

            Waitframe();
         }
         this->Remove();
      }
   }

   eweapon script EwWindBlast {
      void run() {
         until(this->Misc[0]) Waitframe();

         int catchCounter = 0;

         while (this->isValid()) {
            unless(Screen->isSolid(this->X, this->Y) || Screen->isSolid(this->X + 15, this->Y) || Screen->isSolid(this->X, this->Y + 15) || Screen->isSolid(this->X + 15, this->Y + 15) || this->X < 0 || this->X > 240 || this->Y < 0 || this->Y > 160) {
               if (catchCounter < 20) {
                  Hero->X = this->X;
                  Hero->Y = this->Y;
                  Hero->Action = LA_NONE;
                  catchCounter++;
               }
               else
                  this->Remove();
            }

            Waitframe();
         }
      }
   }

   generic script WindHandler {
      void run() {
         this->EventListen[GENSCR_EVENT_HERO_HIT_1] = true;
         // this->EventListen[GENSCR_EVENT_ENEMY_HIT2] = true;

         int ewWindBlast = CheckEWeaponScript("EwWindBlast");

         while (true) {
            switch (WaitEvent()) {
               case GENSCR_EVENT_HERO_HIT_1: {
                  if (Game->EventData[GENEV_HEROHIT_HITTYPE] != OBJTYPE_EWPN)
                     break;

                  eweapon weapon = Game->EventData[GENEV_HEROHIT_HITOBJ];

                  if (weapon->Script != ewWindBlast)
                     break;

                  Game->EventData[GENEV_HEROHIT_NULLIFY] = true;

                  if (Hero->Stun)
                     break;

                  weapon->Misc[0] = 1;
                  Hero->Stun = 2;

                  break;
               }
            }
         }
      }

      void init() {
         if (int scr = CheckGenericScript("WindHandler")) {
            genericdata gd = Game->LoadGenericData(scr);
            gd->Running = true;
         }
      }
   }

   ffc script ServusFloatingAbout {
      void run(int startX, int startY, int moveInX, int moveInY, int isXPositiveDirection, int isYPositiveDirection) {
         if (Game->LoadMapData(40, 0x5B)->State[ST_SECRET])
            Quit();

         int startingRightCombo = 6920;
         int startingLeftCombo = 6948;

         if (Rand(1, 10) > 3)
            Quit();

         for (int i = 0; i < 300; ++i) {
            int xModifier = 0;
            int yModifier = 0;

            if (moveInX) {
               if (isXPositiveDirection)
                  xModifier += i;
               else
                  xModifier -= i;
            }

            if (moveInY) {
               if (isYPositiveDirection)
                  yModifier += i;
               else
                  yModifier -= i;
            }

            if (i % 3) {
               Screen->FastCombo(6, startX + xModifier, startY + yModifier, (isXPositiveDirection ? startingRightCombo : startingLeftCombo), 3, OP_OPAQUE);
               Screen->FastCombo(6, startX + 16 + xModifier, startY + yModifier, (isXPositiveDirection ? startingRightCombo : startingLeftCombo) + 1, 3, OP_OPAQUE);
               Screen->FastCombo(6, startX + xModifier, startY + 16 + yModifier, (isXPositiveDirection ? startingRightCombo : startingLeftCombo) + 2, 3, OP_OPAQUE);
               Screen->FastCombo(6, startX + 16 + xModifier, startY + 16 + yModifier, (isXPositiveDirection ? startingRightCombo : startingLeftCombo) + 3, 3, OP_OPAQUE);
            }

            Waitframe();
         }
      }
   }
}

// clang-format off
@Author("Moosh")
npc script TurnedHylianElite {
   // clang-format on

   using namespace EnemyNamespace;
   using namespace NPCAnim;
   using namespace NPCAnim::Utility;

   enum Animations {
      ANIM_WALKING,
      ANIM_ATTACK
   };

   void run(int introMessage) {
      AnimHandler aptr = new AnimHandler(this);

      aptr->AddAnim(ANIM_WALKING, 0, 4, 8, ADF_4WAY);
      aptr->AddAnim(ANIM_ATTACK, 20, 2, 16, ADF_4WAY | ADF_NOLOOP);

      CONFIG DMG_STANDING_SLASH = this->WeaponDamage *= 2;
      CONFIG DMG_SPRINTING_SLASH_CHARGING = this->WeaponDamage *= 1.25;
      CONFIG DMG_SPRINTING_SLASH = this->WeaponDamage;

      CONFIG MAX_HP = this->HP;

      Audio->PlayEnhancedMusic("OoT - Middle Boss.ogg"); //TODO dont refer to music files directly (I already added the legionnaire music to the engine)

      unless(getScreenD(0)) {
         Screen->Message(introMessage);
         setScreenD(0, true);
      }

      loop () {
         int movementDirection = Choose(90, -90);
         int attackCoolDown = 120;

         aptr->PlayAnim(ANIM_WALKING);

         int tooCloseBoiCounter = 0;

         while (attackCoolDown) {
            this->Immortal = true;
            int moveAngle = Angle(this->X + 8, this->Y + 8, Hero->X + 8, Hero->Y + 8);
            int distance = Distance(this->X, this->Y, Hero->X, Hero->Y);

            if (distance < 48)
               tooCloseBoiCounter++;
            else
               tooCloseBoiCounter = 0;

            if (tooCloseBoiCounter == 60) {
               Audio->PlaySound(SFX_IRON_KNUCKLE_ATTACK);
               Audio->PlaySound(SFX_IRON_KNUCKLE_ATTACK_SWIPE);

               for (int i = 0; i < 15; ++i) {
                  FaceLink(this);
                  sword1x1(this->X, this->Y, moveAngle - 90 + 15 * i, 16, 10252, 10, DMG_STANDING_SLASH);
                  CustomWaitframe(this);
               }

               tooCloseBoiCounter = 0;
            }

            int angle = Angle(this->X + 8, this->Y + 8, Hero->X + 8, Hero->Y + 8) + movementDirection;
            this->MoveAtAngle(angle, this->Step / (gettingDesperate(this, MAX_HP) ? 100 : 75), SPW_NONE);
            --attackCoolDown;

            FaceLink(this);
            CustomWaitframe(this);
         }

         int moveAngle = Angle(this->X + 8, this->Y + 8, Hero->X + 8, Hero->Y + 8);
         int distance = Distance(this->X + 8, this->Y + 8, Hero->X + 8, Hero->Y + 8);
         int dashFrames = Max(2, (distance - 36) / 3);

         bool swordCollided;
         aptr->PlayAnim(ANIM_ATTACK);

         Audio->PlaySound(SFX_IRON_KNUCKLE_ATTACK);

         for (int i = 0; i < dashFrames; ++i) {
            this->MoveAtAngle(moveAngle, this->Step / (gettingDesperate(this, MAX_HP) ? 25 : 30), SPW_NONE);
            FaceLink(this);

            if (i > dashFrames / 2)
               sword1x1(this->X, this->Y, moveAngle - 90, (i - dashFrames / 2) / (dashFrames / 2) * 16, 10252, 10, DMG_SPRINTING_SLASH_CHARGING);

            CustomWaitframe(this);
         }

         Audio->PlaySound(SFX_IRON_KNUCKLE_ATTACK_SWIPE);
         distance = Distance(this->X + 8, this->Y + 8, Hero->X + 8, Hero->Y + 8);

         for (int i = 0; i <= 12 && !swordCollided; ++i) {
            this->MoveAtAngle(moveAngle, this->Step / (gettingDesperate(this, MAX_HP) ? 30 : 35), SPW_NONE);
            FaceLink(this);
            swordCollided = sword1x1Collision(this->X, this->Y, moveAngle - 90 + 15 * i, 16, 10252, 10, DMG_SPRINTING_SLASH);
            CustomWaitframe(this);
         }

         if (swordCollided) {
            Audio->PlaySound(SFX_SWORD_ROCK3);

            for (int i = 0; i < 12; ++i) {
               FaceLink(this);
               this->MoveAtAngle(moveAngle + 180, this->Step / 30, SPW_NONE);
               CustomWaitframe(this);
            }

            CustomWaitframe(this, 40);
         }

         attackCoolDown = 90;
         CustomWaitframe(this);
      }
   }

   bool gettingDesperate(npc this, int maxHp) {
      return this->HP < maxHp * .4;
   }

   void CustomWaitframe(npc this) {
      if (this->HP <= 0)
         deathAnimation(this);

      Waitframe(this);
   }

   void CustomWaitframe(npc this, int frames) {
      for (int i = 0; i < frames; ++i)
         CustomWaitframe(this);
   }
}

namespace EgentemNamespace {
   using namespace NPCAnim;
   using namespace NPCAnim::Utility;

   CONFIG ANIM_SPEED = 16;

   // Hammer
   CONFIG CMB_HAMMER = 7005;
   CONFIG CSET_HAMMER = 8;
   CONFIG SPIN_SPEED = 50;
   CONFIG TURN_SPEED = 2;

   // Pillars
   CONFIG D_LAUNCHED = 2;
   CONFIG D_NO_DIE = 3;

   CONFIG SCREEND_EGENTEM_TRAP_TRIGGERED = 0;
   CONFIG SCREEND_EGENTEM_BEATEN = 1;
   CONFIG SCREEND_EGENTEM_INITIATE_INTRO = 2;
   CONFIG SCREEND_EGENTEM_FIGHT_TOP_SHUTTERS = 3;
   CONFIG SCREEND_EGENTEM_FIGHT_BOTTOM_SHUTTERS = 4;

   enum ATTACKS {
      ATTACK_HAMMER_SPIN,
      ATTACK_HAMMER_ERUPTION,
      ATTACK_THROW_HAMMERS,
      ATTACK_JUMP_TO_PILLAR
   };

   enum Animations {
      WALKING,
      STANDING,
      WALKING_SH,
      STANDING_SH
   };

   class Egentem {
      int moveAngle;
      int moveTime;
      int cooldown;
      int shieldHp;
      npc owner;

      Egentem(npc n) {
         owner = n;
         cooldown = 60;
         shieldHp = 40;
      }

      void MoveMe(int startStepFrames = 48, int startCooldown = 60) {
         if (cooldown) {
            --cooldown;

            if (cooldown == 0) {
               moveTime = startStepFrames;
               moveAngle = Angle(owner->X, owner->Y, Hero->X, Hero->Y);
               owner->Dir = AngleDir4(moveAngle);
            }
         }

         if (moveTime) {
            owner->MoveAtAngle(moveAngle, owner->Step / 100, SPW_NONE);
            --moveTime;

            if (moveTime == 0)
               cooldown = startCooldown;
         }
      }
   }

   // clang-format off
   @Author("Moosh, Deathrider365")
   npc script EgentemBoss {
      // clang-format on

      using namespace GhostBasedMovement;
      using namespace EnemyNamespace;

      //TODO for some reason the pillar projectile itself is only doing a heart of damage on paladin mode

      void run() {
         AnimHandler aptr = new AnimHandler(this);

         aptr->AddAnim(WALKING, 20, 4, ANIM_SPEED, ADF_4WAY);
         aptr->AddAnim(STANDING, 44, 1, ANIM_SPEED, ADF_4WAY);
         aptr->AddAnim(WALKING_SH, 0, 4, ANIM_SPEED, ADF_4WAY);
         aptr->AddAnim(STANDING_SH, 40, 1, ANIM_SPEED, ADF_4WAY);

         Egentem egentem = new Egentem(this);

         CONFIG DMG_HOLD_UP_HAMMER = this->WeaponDamage *= .5;
         CONFIG DMG_SWING_HAMMER = this->WeaponDamage *= 1.3;
         CONFIG DMG_SMASH_HAMMER = this->WeaponDamage *= 1.5;
         CONFIG DMG_SHOCKWAVE_HAMMER = this->WeaponDamage;
         CONFIG DMG_SPIN_HAMMER = this->WeaponDamage *= 2;
         CONFIG DMG_THROWN_HAMMER = this->WeaponDamage *= .75;
         CONFIG DMG_LAUNCHED_PILLAR = this->WeaponDamage *= 1.75;
         CONFIG DMG_STATIONARY_PILLAR = this->WeaponDamage *= .4;
         CONFIG DMG_EXPLOSION_PILLAR = this->WeaponDamage *= 2.2;

         this->X = -32;
         this->Y = -32;
         int maxHp = this->HP;
         this->NoCollisionTimer = -1;

         until (getScreenD(SCREEND_EGENTEM_TRAP_TRIGGERED))
            Waitframe();

         if (getScreenD(SCREEND_EGENTEM_INITIATE_INTRO) && getScreenD(SCREEND_EGENTEM_TRAP_TRIGGERED)) {
            Audio->PlayEnhancedMusic("Dragon Quest IV - Boss Battle.ogg", 0);
            this->X = 120;
            this->Y = 128;
            this->Dir = DIR_UP;
            aptr->PlayAnim(STANDING_SH);

            setScreenD(SCREEND_EGENTEM_FIGHT_BOTTOM_SHUTTERS, true);
            setScreenD(SCREEND_EGENTEM_FIGHT_TOP_SHUTTERS, true);
         }
         else if (!getScreenD(SCREEND_EGENTEM_INITIATE_INTRO)) {
            if (Hero->Y < 48)
               setScreenD(SCREEND_EGENTEM_FIGHT_TOP_SHUTTERS, true);
            else
               setScreenD(SCREEND_EGENTEM_FIGHT_BOTTOM_SHUTTERS, true);

            introCutscene(this);
            setScreenD(SCREEND_EGENTEM_INITIATE_INTRO, true);
         }

         this->NoCollisionTimer = 0;

         for (int i = 0; i < 20; ++i)
            this->Defense[i] = NPCDT_QUARTERDAMAGE;

         this->Defense[NPCD_BRANG] = NPCDT_BLOCK;
         this->Defense[NPCD_WHISTLE] = NPCDT_IGNORE;

         int heroDistances[10];
         int heroActiveAItems[10];
         int heroActiveBItems[10];

         attackThrowHammers(this, egentem, 10, 15, DMG_HOLD_UP_HAMMER, DMG_THROWN_HAMMER, DMG_STATIONARY_PILLAR, DMG_EXPLOSION_PILLAR);

         loop () {
            int trackerCount;
            aptr->PlayAnim(egentem->shieldHp <= 0 ? WALKING : WALKING_SH);

            for (int i = 0; i < 180; ++i) {
               egentem->MoveMe();

               unless(i % 18) {
                  heroDistances[trackerCount] = Distance(Hero->X, Hero->Y, this->X, this->Y);
                  heroActiveAItems[trackerCount] = Hero->ItemA;
                  heroActiveBItems[trackerCount] = Hero->ItemB;
                  trackerCount++;
               }

               EgentemWaitframe(this, egentem);
            }

            EgentemWaitframe(this, egentem, 60);

            trackerCount = 0;
            int avgDistances;
            int totalDistances;
            int meleeCount;
            int aggressiveCount;
            int candleCount;

            for (int i = 0; i < 10; ++i)
               totalDistances += heroDistances[i];

            avgDistances = totalDistances / 10;

            for (int i = 0; i < 10; ++i) {
               if (heroActiveAItems[i] == 10 || heroActiveBItems[i] == 10)
                  candleCount++;

               if (heroActiveAItems[i] == 3 || heroActiveAItems[i] == 5 || heroActiveAItems[i] == 10 || heroActiveAItems[i] == 147)
                  meleeCount++;
               else if (heroActiveBItems[i] == 3 || heroActiveBItems[i] == 5 || heroActiveBItems[i] == 10 || heroActiveBItems[i] == 147)
                  meleeCount++;
            }

            for (int i = 0; i < 10; ++i) {
               if (heroActiveAItems[i] == 3 || heroActiveAItems[i] == 5 || heroActiveAItems[i] == 10 || heroActiveAItems[i] == 147)
                  aggressiveCount++;
               else if (heroActiveBItems[i] == 3 || heroActiveBItems[i] == 5 || heroActiveBItems[i] == 10 || heroActiveBItems[i] == 147)
                  aggressiveCount++;
            }

            if (candleCount == 10) {
               aptr->PlayAnim(egentem->shieldHp <= 0 ? STANDING : STANDING_SH);
               attackHammerEruption(this, egentem, DMG_SHOCKWAVE_HAMMER, DMG_HOLD_UP_HAMMER, DMG_SWING_HAMMER, DMG_SMASH_HAMMER);
               attackThrowHammers(this, egentem, 5, 1, DMG_HOLD_UP_HAMMER, DMG_THROWN_HAMMER, DMG_STATIONARY_PILLAR, DMG_EXPLOSION_PILLAR);
            }

            if (numPillars() > 15) {
               aptr->PlayAnim(egentem->shieldHp ? WALKING : WALKING_SH);

               for (int i = 0; i < (numPillars() * .9); ++i)
                  attackJumpToPillar(this, egentem, DMG_LAUNCHED_PILLAR);
            }

            if (egentem->shieldHp > 0) {
               if (avgDistances > 48) {
                  attackHammerSpin(this, egentem, DMG_HOLD_UP_HAMMER, DMG_SPIN_HAMMER);
                  attackThrowHammers(this, egentem, 5, 10, DMG_HOLD_UP_HAMMER, DMG_THROWN_HAMMER, DMG_STATIONARY_PILLAR, DMG_EXPLOSION_PILLAR);

                  for (int i = 0; i < numPillars() / 2; ++i)
                     attackJumpToPillar(this, egentem, DMG_LAUNCHED_PILLAR);
               }
               else if (meleeCount > 7) {
                  attackHammerSpin(this, egentem, DMG_HOLD_UP_HAMMER, DMG_SPIN_HAMMER);
                  attackHammerEruption(this, egentem, DMG_SHOCKWAVE_HAMMER, DMG_HOLD_UP_HAMMER, DMG_SWING_HAMMER, DMG_SMASH_HAMMER);
               }
               else {
                  attackThrowHammers(this, egentem, 15, 10, DMG_HOLD_UP_HAMMER, DMG_THROWN_HAMMER, DMG_STATIONARY_PILLAR, DMG_EXPLOSION_PILLAR);

                  for (int i = 0; i < numPillars() / 2; ++i)
                     attackJumpToPillar(this, egentem, DMG_LAUNCHED_PILLAR);
               }
            }
            else {
               if (avgDistances > 48) {
                  attackHammerSpin(this, egentem, DMG_HOLD_UP_HAMMER, DMG_SPIN_HAMMER);
                  attackThrowHammers(this, egentem, 5, 10, DMG_HOLD_UP_HAMMER, DMG_THROWN_HAMMER, DMG_STATIONARY_PILLAR, DMG_EXPLOSION_PILLAR);

                  for (int i = 0; i < numPillars() / 2; ++i)
                     attackJumpToPillar(this, egentem, DMG_LAUNCHED_PILLAR);
               }
               else if (meleeCount > 7) {
                  attackHammerEruption(this, egentem, DMG_SHOCKWAVE_HAMMER, DMG_HOLD_UP_HAMMER, DMG_SWING_HAMMER, DMG_SMASH_HAMMER);
                  attackHammerSpin(this, egentem, DMG_HOLD_UP_HAMMER, DMG_SPIN_HAMMER);
                  attackHammerEruption(this, egentem, DMG_SHOCKWAVE_HAMMER, DMG_HOLD_UP_HAMMER, DMG_SWING_HAMMER, DMG_SMASH_HAMMER);
                  attackThrowHammers(this, egentem, 5, 10, DMG_HOLD_UP_HAMMER, DMG_THROWN_HAMMER, DMG_STATIONARY_PILLAR, DMG_EXPLOSION_PILLAR);
               }
               else {
                  attackThrowHammers(this, egentem, 15, 10, DMG_HOLD_UP_HAMMER, DMG_THROWN_HAMMER, DMG_STATIONARY_PILLAR, DMG_EXPLOSION_PILLAR);

                  for (int i = 0; i < numPillars() / 2; ++i)
                     attackJumpToPillar(this, egentem, DMG_LAUNCHED_PILLAR);
               }
            }

            EgentemWaitframe(this, egentem, 1);
         }
      }
   }

   void EgentemWaitframe(npc this, Egentem egentem, int frames = 1) {
      for (int i = 0; i < frames; ++i) {
         if (this->HP <= 0)
            egentemDeathAnimation(this);

         handleShieldDamage(this, egentem);
         Waitframe(this);
      }
   }

   void egentemDeathAnimation(npc n) {
      setScreenD(SCREEND_EGENTEM_BEATEN, true);
      setScreenD(SCREEND_EGENTEM_FIGHT_TOP_SHUTTERS, false);
      setScreenD(SCREEND_EGENTEM_FIGHT_BOTTOM_SHUTTERS, false);

      n->Immortal = true;
      n->NoCollisionTimer = -1;
      n->Stun = 9999;

      int baseX = n->X + n->DrawXOffset;
      int baseY = (n->Y + n->DrawYOffset) - (n->Z + n->DrawZOffset);

      Audio->PlaySound(SFX_OOT_STALFOS_DIE);

      for (int i = 0; i < 45; i++) {
         unless(i % 3) {
            lweapon explosion = Screen->CreateLWeapon(LW_BOMBBLAST);
            explosion->X = baseX + RandGen->Rand(16 * n->TileWidth) - 8;
            explosion->Y = baseY + RandGen->Rand(16 * n->TileHeight) - 8;
            explosion->NoCollisionTimer = -1;
         }
         Waitframes(5);
      }

      MUSIC_INHERIT->Play();

      for (int i = Screen->NumEWeapons; i >= 1; i--) {
         eweapon e = Screen->LoadEWeapon(i);
         e->Remove();
      }

      for (int i = Screen->NumNPCs; i >= 1; i--) {
         npc n = Screen->LoadNPC(i);
         n->Remove();
      }

      n->Immortal = false;
      n->HP = 0;
   }

   void handleShieldDamage(npc this, Egentem egentem) {
      if (egentem->shieldHp <= 0)
         return;

      int weaponId = this->HitBy[HIT_BY_LWEAPON];

      if (Hero->Dir == OppositeDir(this->Dir) && weaponId) {
         lweapon weapon = Screen->LoadLWeapon(weaponId);

         if (weapon->ID == LW_HAMMER) {
            egentem->shieldHp -= weapon->Damage;

            if (egentem->shieldHp <= 0) {
               this->BreakShield();
               Audio->PlaySound(SFX_IRON_KNUCKLE_STEP);
               AnimHandler aptr = GetAnimHandler(this);

               for (int i = 0; i < 20; ++i)
                  this->Defense[i] = NPCDT_NONE;

               this->Defense[NPCD_BRANG] = NPCDT_BLOCK;
               this->Defense[NPCD_BOMB] = NPCDT_HALFDAMAGE;
               this->Defense[NPCD_SBOMB] = NPCDT_HALFDAMAGE;
               this->Defense[NPCD_FIRE] = NPCDT_2XDAMAGE;
               this->Defense[NPCD_HAMMER] = NPCDT_HALFDAMAGE;

               switch (aptr->GetCurAnim()) {
                  case WALKING:
                  case WALKING_SH: {
                     playAnim(aptr, egentem, WALKING);
                     break;
                  }
                  case STANDING:
                  case STANDING_SH: {
                     playAnim(aptr, egentem, STANDING);
                     break;
                  }
               }
            }
            else {
               Audio->PlaySound(SFX_SWORD_ROCK3);
            }
         }
      }
   }

   void playAnim(AnimHandler aptr, Egentem egentem, int anim) {
      if (egentem->shieldHp > 0) {
         switch (anim) {
            case WALKING: anim = WALKING_SH; break;
            case STANDING: anim = STANDING_SH; break;
         }
      }

      aptr->PlayAnim(anim);
   }

   void introCutscene(npc this) {
      Audio->PlayEnhancedMusic(NULL, 0);

      if (Hero->Y < 32) {
         while (Hero->Y < 32)
            Waitframe();
      }
      else {
         while (Hero->Y > 128 || Hero->Y < 112)
            Waitframe();
      }

      if (Hero->Y <= 48) {
         this->X = 120;
         this->Y = 176;
         this->Dir = DIR_UP;
         Hero->Dir = DIR_DOWN;
      }
      else {
         this->X = 120;
         this->Y = -16;
         this->Dir = DIR_DOWN;
         Hero->Dir = DIR_UP;
      }

      AnimHandler aptr = GetAnimHandler(this);
      aptr->PlayAnim(WALKING);

      for (int i = 0; i < 90; ++i) {
         disableLink();

         if (Hero->Y <= 48) {
            this->Y -= .5;
         }
         else
            this->Y += .5;

         Waitframe(this);
      }

      aptr->PlayAnim(STANDING);

      for (int i = 0; i < 32; ++i) {
         disableLink();
         Waitframe(this);
      }

      Screen->Message(334);
      Waitframe();

      aptr->PlayAnim(STANDING_SH);
      Coordinates xy = new Coordinates();

      for (int i = 0; i < 32; ++i) {
         disableLink();
         hammerFrame(this, 0, 0, xy);
         Waitframe(this);
      }

      if (Hero->Y < 48)
         setScreenD(SCREEND_EGENTEM_FIGHT_BOTTOM_SHUTTERS, true);
      else
         setScreenD(SCREEND_EGENTEM_FIGHT_TOP_SHUTTERS, true);

      Audio->PlaySound(SFX_SHUTTER_CLOSE);

      Waitframes(10);

      Screen->Message(337);
      Waitframe();
      hammerFrame(this, 0, 0, xy);
      Screen->Message(807);
      Audio->PlayEnhancedMusic("Dragon Quest IV - Boss Battle.ogg", 0);
      Waitframe();

      aptr->PlayAnim(STANDING_SH);
   }

   void hammerAnimHoldUp(npc this, Coordinates xy, int holdUpDamage, int frames = 20) {
      for (int i = 0; i < frames; ++i) {
         if (this->HP <= 0)
            break;

         hammerFrame(this, 0, holdUpDamage, xy);
         Waitframe(this);
      }
   }

   void hammerAnimSwing(npc this, Coordinates xy, int holdUpDamage, int swingDamage) {
      for (int i = 0; i < 4; ++i) {
         if (this->HP <= 0)
            break;

         hammerFrame(this, 1, holdUpDamage, xy);
         Waitframe(this);
      }

      hammerFrame(this, 2, swingDamage, xy, true);

      if (this->HP > 0)
         Audio->PlaySound(SFX_HAMMER);
   }

   void hammerAnimSmash(npc this, Coordinates xy, int hammerSmashDamage, int frames = 30) {
      for (int i = 0; i < frames; ++i) {
         if (this->HP <= 0)
            break;

         hammerFrame(this, 2, hammerSmashDamage, xy);

         if (i == 0) {
            eweapon weap = FireEWeaponDegAngle(EW_SCRIPT10, xy->X, xy->Y, 0, 0, 0, 128, 0, Game->GetEWeaponScript("HammerImpactEffect"),
               {49852}
            );

            weap->ScriptTile = TILE_INVIS;
         }

         Waitframe(this);
      }
   }

   void hammerFrame(npc this, int frame, int damage, Coordinates xy, bool doNothing = false) {
      const int TILE_HAMMER = 49840;
      const int CSET_HAMMER = 8;
      int x = this->X;
      int y = this->Y;

      switch (this->Dir) {
         case DIR_UP: {
            switch (frame) {
               case 0: y -= 14; break;
               case 1: y -= 12; break;
               case 2: y -= 13; break;
            }
            break;
         }
         case DIR_DOWN: {
            switch (frame) {
               case 0: y -= 12; break;
               case 1: y += 4; break;
               case 2: y += 14; break;
            }
            break;
         }
         case DIR_LEFT: {
            switch (frame) {
               case 0: y -= 14; break;
               case 1:
                  x -= 12;
                  y -= 12;
                  break;
               case 2: x -= 14; break;
            }
            break;
         }
         case DIR_RIGHT: {
            switch (frame) {
               case 0: y -= 14; break;
               case 1:
                  x += 12;
                  y -= 12;
                  break;
               case 2: x += 14; break;
            }
            break;
         }
      }

      unless(doNothing) {
         eweapon hammer = FireEWeaponDegAngle(EW_SCRIPT10, x, y, 0, 0, damage, 128, 0);
         hammer->Unblockable = UNBLOCK_ALL;
         hammer->ScriptTile = TILE_HAMMER + 3 * this->Dir + frame;
         hammer->CSet = CSET_HAMMER;
         hammer->Timeout = 2;

         if (frame < 2)
            hammer->NoCollisionTimer = -1;
      }

      xy->X = x;
      xy->Y = y;
   }

   void attackHammerSpin(npc this, Egentem egentem, int holdingDamage, int spinnyDamage) {
      AnimHandler aptr = GetAnimHandler(this);
      int spinDir = Choose(-1, 1);
      int moveAngle = Angle(this->X, this->Y, Hero->X, Hero->Y) + 30 * spinDir;
      int facingAngle = moveAngle;

      this->Dir = AngleDir4(facingAngle);
      playAnim(aptr, egentem, STANDING);
      eweapon hitbox;

      // Holding hammer to some side
      for (int i = 0; i < 45; ++i) {
         hitbox = sword1x1Persistent(hitbox, this->X, this->Y, facingAngle + spinDir * 90, 16, CMB_HAMMER, CSET_HAMMER, holdingDamage);
         EgentemWaitframe(this, egentem);
      }

      bool linkGotHit;

      for (int i = 0; i < 60; ++i) {
         facingAngle = WrapDegrees(facingAngle - spinDir * SPIN_SPEED);
         moveAngle = WrapDegrees(turnToAngle(moveAngle, Angle(this->X, this->Y, Hero->X, Hero->Y), TURN_SPEED));
         this->Dir = AngleDir4(facingAngle);
         this->MoveAtAngle(moveAngle, 3, SPW_NONE);

         if (i % (360 / SPIN_SPEED) == 0)
            Audio->PlaySound(SFX_SPINATTACK);

         hitbox = sword1x1Persistent(hitbox, this->X, this->Y, facingAngle + spinDir * 90, 16, CMB_HAMMER, CSET_HAMMER, spinnyDamage);

         int hitId = Hero->HitBy[HIT_BY_EWEAPON];

         if (hitId) {
            eweapon hitHero = Screen->LoadEWeapon(hitId);

            if (hitHero->isValid() && hitbox == hitHero) {
               linkGotHit = true;
               Audio->PlaySound(SFX_IMPACT_EXPLOSION);
               break;
            }
         }

         EgentemWaitframe(this, egentem);
      }

      if (linkGotHit) {
         yeetHero(Angle(this->X, this->Y, Hero->X, Hero->Y), 4, 200, true, true);

         for (int i = 0; i < 45; ++i) {
            hitbox = sword1x1Persistent(hitbox, this->X, this->Y, facingAngle + spinDir * 90, 12, CMB_HAMMER, CSET_HAMMER, spinnyDamage);
            EgentemWaitframe(this, egentem);
         }
      }

      playAnim(aptr, egentem, WALKING);
   }

   void attackHammerEruption(npc this, Egentem egentem, int shockwaveDamage, int holdUpDamage, int swingDamage, int hammerSmashDamage) {
      CONFIG D_ERUPT = 7;
      AnimHandler aptr = GetAnimHandler(this);
      Coordinates xy = new Coordinates();
      FaceLink(this);

      playAnim(aptr, egentem, STANDING);

      hammerAnimHoldUp(this, xy, holdUpDamage);
      hammerAnimSwing(this, xy, holdUpDamage, swingDamage);

      int offset = Rand(360);

      for (int i = 0; i < 8; ++i) {
         eweapon wave = FireEWeaponDegAngle(EW_SCRIPT10, xy->X, xy->Y, 0, 0, shockwaveDamage, SPR_FLOOR_CRACK, 0, Game->GetEWeaponScript("ShockWave"),
            {SPR_FLOOR_CRACK, SFX_IMPACT_EXPLOSION, 8, SFX_POWDER_KEG_BLAST, SPR_EARTH_PILLAR, 12, offset + i * 45, false}
         );

         wave->Unblockable = UNBLOCK_ALL;
      }

      hammerAnimSmash(this, xy, hammerSmashDamage, 30);

      int angle = Angle(Hero->X, Hero->Y, this->X, this->Y);

      playAnim(aptr, egentem, WALKING);

      for (int i = 0; i < 45; ++i) {
         this->MoveAtAngle(angle, 3, SPW_NONE);
         EgentemWaitframe(this, egentem);
      }

      FaceLink(this);
      playAnim(aptr, egentem, STANDING);

      hammerAnimHoldUp(this, xy, holdUpDamage, 8);
      hammerAnimSwing(this, xy, holdUpDamage, swingDamage);

      for (int i = Screen->NumEWeapons; i > 0; --i) {
         eweapon e = Screen->LoadEWeapon(i);

         if (e->Script == Game->GetEWeaponScript("ShockWave"))
            e->InitD[D_ERUPT] = true;
      }

      hammerAnimSmash(this, xy, hammerSmashDamage);
   }

   void attackThrowHammers(npc this, Egentem egentem, int hammerCount, int hammerThrowDelay, int holdUpDamage, int thrownHammerDamage, int pillarDamage, int pillarExplosionDamage) {
      int angle = Angle(Hero->X, Hero->Y, this->X, this->Y);
      FaceLink(this);

      for (int i = 0; i < 30; ++i) {
         sword1x1(this->X, this->Y, angle, 16, CMB_HAMMER, CSET_HAMMER, holdUpDamage);
         EgentemWaitframe(this, egentem);
      }

      for (int i = 0; i < hammerCount; ++i) {
         Audio->PlaySound(SFX_SWORD);
         FaceLink(this);

         for (int j = 0; j < 9; ++j) {
            sword1x1(this->X, this->Y, angle + j * 20, 16, CMB_HAMMER, CSET_HAMMER, holdUpDamage);
            EgentemWaitframe(this, egentem);
         }

         eweapon hammer = FireEWeaponAtHero(EW_SCRIPT10, this->X + VectorX(16, angle + 180), this->Y + VectorY(16, angle + 180), true, 300, thrownHammerDamage, 134, 0, Game->GetEWeaponScript("ArcingWeapon"),
            {-1, 0, AE_EGENTEM_HAMMER, this, pillarDamage, pillarExplosionDamage, true}
         );
         hammer->Unblockable = UNBLOCK_ALL;

         Waitframes(hammerThrowDelay);
      }
   }

   void attackJumpToPillar(npc this, Egentem egentem, int damage) {
      AnimHandler aptr = GetAnimHandler(this);
      eweapon closestPillar = findPillar(this);

      unless(closestPillar->isValid()) return;

      closestPillar->InitD[D_NO_DIE] = true;
      int tx = closestPillar->X + VectorX(16, Angle(Hero->X, Hero->Y, closestPillar->X, closestPillar->Y));
      int ty = closestPillar->Y + VectorY(16, Angle(Hero->X, Hero->Y, closestPillar->X, closestPillar->Y));

      int oldX = this->X;
      int oldY = this->Y;

      this->MoveXY(tx - this->X, ty - this->Y, SPW_NONE);
      tx = this->X;
      ty = this->Y;

      this->X = oldX;
      this->Y = oldY;

      FaceLink(this);

      if (Distance(this->X, this->Y, tx, ty) < 32) {
         playAnim(aptr, egentem, WALKING);

         for (int i = 0; i < 12 && Distance(this->X, this->Y, tx, ty) > 4; ++i) {
            this->MoveAtAngle(Angle(this->X, this->Y, tx, ty), 4, SPW_NONE);
            FaceLink(this);
            EgentemWaitframe(this, egentem);
         }
      }
      else {
         playAnim(aptr, egentem, WALKING);
         int distance = Distance(this->X, this->Y, tx, ty);
         this->Jump = 1.8;

         for (int i = 0; i < 24; ++i) {
            this->MoveAtAngle(Angle(this->X, this->Y, tx, ty), distance / 24, SPW_NONE);
            FaceLink(this);
            EgentemWaitframe(this, egentem);
         }
      }

      if (Distance(this->X, this->Y, tx, ty) < 8) {
         int anglePillar = Angle(this->X, this->Y, closestPillar->X, closestPillar->Y);
         Audio->PlaySound(SFX_SWORD);

         for (int i = 0; i < 9; ++i) {
            sword1x1(this->X, this->Y, anglePillar - 90 + i * 20, 16, CMB_HAMMER, CSET_HAMMER, damage);

            if (i == 5)
               closestPillar->InitD[D_LAUNCHED] = true;

            EgentemWaitframe(this, egentem);
         }
      }

      closestPillar->InitD[D_NO_DIE] = false;
   }

   int numPillars() {
      int slot = Game->GetEWeaponScript("EgentemPillar");
      int count;

      for (int i = Screen->NumEWeapons; i > 0; --i) {
         eweapon e = Screen->LoadEWeapon(i);

         if (e->Script == slot && !e->InitD[D_LAUNCHED] && !e->NoCollisionTimer)
            ++count;
      }

      return count;
   }

   eweapon findPillar(npc this) {
      int slot = Game->GetEWeaponScript("EgentemPillar");
      eweapon closest;
      int closestDistance = 1000;

      for (int i = Screen->NumEWeapons; i > 0; --i) {
         eweapon e = Screen->LoadEWeapon(i);

         if (e->Script == slot && !e->InitD[D_LAUNCHED] && !e->NoCollisionTimer) {
            int distEnemy = Distance(e->X, e->Y, this->X, this->Y);
            int distLink = Distance(e->X, e->Y, Hero->X, Hero->Y);

            if (distEnemy + distLink < closestDistance) {
               closestDistance = distEnemy + distLink;
               closest = e;
            }
         }
      }

      return closest;
   }

   eweapon script EgentemPillar {
      CONFIG TILE_ROTATING = 50104;

      void run(int delay, int upTime, bool launched, bool noDie, int pillarDamage, int pillarExplosionDamage) {
         if (Screen->isSolid(this->X + 8, this->Y + 8))
            this->Remove();

         this->Behind = true;
         this->NoCollisionTimer = -1;
         this->UseSprite(SPR_FLOOR_CRACK);

         Waitframes(delay);

         this->Behind = false;
         this->Extend = EXT_NORMAL;
         this->TileHeight = 2;
         this->DrawYOffset = -16;
         this->HitYOffset = -16;
         this->HitHeight = 32;
         this->NoCollisionTimer = 0;
         this->UseSprite(SPR_EARTH_PILLAR);
         Audio->PlaySound(SFX_IMPACT_EXPLOSION);

         for (int i = 0; i < this->NumFrames * this->ASpeed - 1; ++i) {
            this->DeadState = WDS_ALIVE;
            Waitframe();
         }

         this->Tile = this->OriginalTile;
         this->NumFrames = 1;
         this->ASpeed = 0;

         while (upTime > 0 || this->InitD[D_NO_DIE]) {
            if (this->InitD[D_LAUNCHED])
               break;

            this->DeadState = WDS_ALIVE;
            Waitframe();
         }

         if (this->InitD[D_LAUNCHED]) {
            this->Y -= 8;
            this->DrawXOffset = -8;
            this->DrawYOffset = -8;
            this->TileWidth = 2;
            this->TileHeight = 2;
            this->NoCollisionTimer = -1;
            this->UseSprite(SPR_ROTATING_PILLAR);
            this->Angular = true;
            this->Damage = pillarDamage;

            int angle = Angle(this->X, this->Y, Hero->X, Hero->Y);

            for (int i = 0; i < 18; ++i) {
               this->Rotation = WrapDegrees(angle + i * 20);
               this->DeadState = WDS_ALIVE;

               Waitframe();
            }

            this->DegAngle = angle;
            this->Step = 450;

            until (wallCollision(this)) {
               this->Rotation = this->DegAngle;
               rotatingHitbox(this);
               Waitframe();
            }
            eweapon explosion = CreateEWeaponAt(EW_BOMBBLAST, this->X, this->Y);
            explosion->Damage = pillarExplosionDamage;
         }

         this->Remove();
      }

      void rotatingHitbox(eweapon this) {
         eweapon hitbox = CreateEWeaponAt(EW_SCRIPT10, this->X + VectorX(8, this->Rotation), this->Y + VectorY(8, this->Rotation));
         hitbox->Damage = this->Damage;
         hitbox->Unblockable = UNBLOCK_ALL;
         hitbox->Timeout = 1;
         hitbox->DrawYOffset = -1000;

         hitbox = CreateEWeaponAt(EW_SCRIPT10, this->X + VectorX(-8, this->Rotation), this->Y + VectorY(-8, this->Rotation));
         hitbox->Damage = this->Damage;
         hitbox->Unblockable = UNBLOCK_ALL;
         hitbox->Timeout = 1;
         hitbox->DrawYOffset = -1000;
      }

      bool wallCollision(eweapon this) {
         if (Screen->isSolid(this->X + 8, this->Y + 8))
            return true;

         if (this->X < 0 || this->X > 240 || this->Y < 0 || this->Y > 160)
            return true;

         return false;
      }
   }

   ffc script EgentemGotcha {
      void run() {
         if (getScreenD(31, 0x33, SCREEND_EGENTEM_BEATEN)) {
            mapdata mapData = Game->LoadTempScreen(0);
            mapData->ComboD[39] = 0;
            mapData->ComboD[40] = 0;
         }

         until(Screen->SecretsTriggered) Waitframe();

         Audio->PlayEnhancedMusic(NULL, 0);
         setScreenD(31, 0x33, SCREEND_EGENTEM_TRAP_TRIGGERED, true);
      }
   }
}

namespace LatrosNamespace {
   using namespace EnemyNamespace;
   using namespace NPCAnim;
   using namespace NPCAnim::Utility;

   CONFIG CMB_BLUE_POTION = 8960;
   CONFIG CMB_RED_POTION = 8964;
   CONFIG CMB_PURPLE_POTION = 8968;

   class Latros {
      npc owner;
      int numItems;
      int stolenItems[5];
      int hitCounter;
      int attackCooldown;
      bool canDropItem;

      Latros(npc latros) {
         owner = latros;
         hitCounter = 2;
         attackCooldown = 120;
      }

      void update() {
         if (numItems > 0) {
            int weaponId = owner->HitBy[HIT_BY_LWEAPON];

            if (weaponId) {
               --hitCounter;

               if (hitCounter <= 0)
                  dropItem();
            }
         }
      }

      void stealItem(int itemId) {
         stolenItems[numItems] = itemId;
         ++numItems;
      }

      void dropItem(int itemId = 0) {
         if (int scr = CheckItemSpriteScript("ArcingItemSprite2")) {
            int indexOfDroppedItem = 0;
            int itemToDrop = itemId;

            if (itemId) {
               for (int i = 0; i < SizeOfArray(stolenItems); ++i)
                  if (stolenItems[i] == itemId)
                     indexOfDroppedItem = i;
            }
            else {
               indexOfDroppedItem = Rand(0, numItems - 1);
               itemToDrop = stolenItems[indexOfDroppedItem];
            }

            if (itemToDrop) {
               itemsprite item1 = RunItemSpriteScriptAt(itemToDrop, scr, owner->X, owner->Y, {Rand(-180, 180), 2, 4, 0});

               item1->Pickup |= IP_ALWAYSGRAB | IP_DUMMY;

               stolenItems[indexOfDroppedItem] = 0;
               int tempItems[5];
               int tempItemsIndex;

               for (int i = 0; i < SizeOfArray(stolenItems); ++i)
                  if (stolenItems[i] > 0)
                     tempItems[tempItemsIndex++] = stolenItems[i];

               for (int i = 0; i < SizeOfArray(tempItems); ++i)
                  stolenItems[i] = tempItems[i];

               --numItems;
               hitCounter = 2;
            }
         }
      }

      bool hasItem(int itemId) {
         for (int i = 0; i < SizeOfArray(stolenItems); ++i)
            if (stolenItems[i] == itemId)
               return true;
         return false;
      }
   }

   // clang-format off
   @Author("Moosh, Deathrider365")
   npc script LatrosBoss {
      // clang format on
      using namespace EnemyNamespace;

      void run() {
         disableLink();
         AnimHandler aptr = new AnimHandler(this);
         Latros latros = new Latros(this);
         CONFIG WALKING = 0;
         CONFIG ANIM_SPEED = 4;
         CONFIG UNCHANGED_HP_COUNTER_VALUE = 300;

         CONFIG DMG_SWORD_DAMAGE = Game->LoadItemData(GetHighestLevelItemOwned(IC_SWORD))->Power;
         CONFIG DMG_BOOMERANG_DAMAGE = Game->LoadItemData(GetHighestLevelItemOwned(IC_BRANG))->Power;
         CONFIG DMG_BOMB_DAMAGE = Game->LoadItemData(GetHighestLevelItemOwned(IC_BOMB))->Power;
         CONFIG DMG_BOMB_EXPLOSION = DMG_BOMB_DAMAGE * 2;
         CONFIG DMG_ARROW_DAMAGE = Game->LoadItemData(GetHighestLevelItemOwned(IC_ARROW))->Power;
         CONFIG DMG_FLAME_DAMAGE = Game->LoadItemData(GetHighestLevelItemOwned(IC_CANDLE))->Power;
         CONFIG DMG_HAMMER_DAMAGE = Game->LoadItemData(GetHighestLevelItemOwned(IC_HAMMER))->Power;
         CONFIG DMG_RUBBLE_DAMAGE = this->WeaponDamage;

         const int boomerangLevel = Game->LoadItemData(GetHighestLevelItemOwned(IC_BRANG))->Level;

         FaceLink(this);

         until(this->Z == 0) {
            disableLink();
            FaceLink(this);
            Waitframe(this);
         }

         Screen->Quake = 20;
         Audio->PlaySound(SFX_IMPACT_EXPLOSION);
         FaceLink(this);

         for (int i = 0; i < 30; ++i) {
            disableLink();
            LatrosWaitframe(this, latros);
         }

         unless(getScreenD(255)) {
            Screen->Message(809);
            setScreenD(255, true);
         }

         aptr->AddAnim(WALKING, 0, 4, ANIM_SPEED, ADF_4WAY);
         int heroHp = Hero->HP;
         int latrosHealth = this->HP;
         int hpUnchangedCounter = UNCHANGED_HP_COUNTER_VALUE;
         int attackCooldown = 120;
         int attackAttemptCounter = 10;

         while (true) {
            doWalk(this, this->Random, this->Homing, this->Step);

            unless(hpUnchangedCounter) {
               if (latros->numItems)
                  latros->dropItem();

               latrosHealth = this->HP;
               hpUnchangedCounter = UNCHANGED_HP_COUNTER_VALUE;
            }

            unless(attackCooldown) {
               int validItem = 0;

               if (latros->numItems > 4) {
                  int possessingItems[5];
                  int possessingItemsIndex;

                  for (int i = 0; i < SizeOfArray(latros->stolenItems); ++i)
                     if (latros->stolenItems[i])
                        possessingItems[possessingItemsIndex++] = latros->stolenItems[i];

                  while (!validItem && attackAttemptCounter) {
                     validItem = possessingItems[Rand(0, latros->numItems - 1)];
                     --attackAttemptCounter;
                  }

                  attackAttemptCounter = 10;
                  attackWithItem(this, latros, validItem, DMG_SWORD_DAMAGE, DMG_BOOMERANG_DAMAGE, DMG_BOMB_DAMAGE, DMG_ARROW_DAMAGE, DMG_FLAME_DAMAGE, DMG_HAMMER_DAMAGE, DMG_RUBBLE_DAMAGE, boomerangLevel, DMG_BOMB_EXPLOSION);
               }
               else {
                  charge(this, latros);

                  if (Screen->NumItems)
                     seekItem(this, latros);

                  int possessingItems[5];
                  int possessingItemsIndex;

                  for (int i = 0; i < SizeOfArray(latros->stolenItems); ++i)
                     if (latros->stolenItems[i])
                        possessingItems[possessingItemsIndex++] = latros->stolenItems[i];

                  while (!validItem && attackAttemptCounter) {
                     validItem = possessingItems[Rand(0, latros->numItems - 1)];
                     --attackAttemptCounter;
                  }

                  attackAttemptCounter = 10;
                  attackWithItem(this, latros, validItem, DMG_SWORD_DAMAGE, DMG_BOOMERANG_DAMAGE, DMG_BOMB_DAMAGE, DMG_ARROW_DAMAGE, DMG_FLAME_DAMAGE, DMG_HAMMER_DAMAGE, DMG_RUBBLE_DAMAGE, boomerangLevel, DMG_BOMB_EXPLOSION);
               }

               attackCooldown = 120;
               LatrosWaitframe(this, latros, 30);
            }

            if (this->HP == latrosHealth)
               --hpUnchangedCounter;
            else {
               latrosHealth = this->HP;
               hpUnchangedCounter = UNCHANGED_HP_COUNTER_VALUE;
            }

            --attackCooldown;
            LatrosWaitframe(this, latros);
         }
      }
   }

   void LatrosWaitframe(npc this, Latros latros, int frames = 1) {
      for (int i = 0; i < frames; ++i) {
         if (this->HP <= 0)
            latrosDeathAnimation(this, 170, latros);

         latros->update();
         Waitframe(this);
      }
   }

   void charge(npc this, Latros latros) {
      bool stolen;
      int chargingCounter = 60;

      until(stolen) {
         this->NoCollisionTimer = -1;

         unless(chargingCounter) break;

         FaceLink(this);
         int angle = Angle(this->X, this->Y, Hero->X, Hero->Y);
         this->MoveAtAngle(angle, 4, SPW_NONE);

         if (Collision(this)) {
            Hero->Stun = 60;
            Audio->PlaySound(SFX_STALCHILD_ATTACK);
            LatrosWaitframe(this, latros, 30);
            Audio->PlaySound(Choose(SFX_HERO_HURT_1, SFX_HERO_HURT_2, SFX_HERO_HURT_3));

            int numExistingStolenItems = 0;

            for (int i = 0; i < SizeOfArray(stolenLinkItems); ++i)
               if (stolenLinkItems[i])
                  ++numExistingStolenItems;

            if (Hero->ItemA)
               stolenLinkItems[numExistingStolenItems] = Hero->ItemA;
            if (Hero->ItemB)
               stolenLinkItems[numExistingStolenItems + 1] = Hero->ItemB;

            if (int scr = CheckItemSpriteScript("ArcingItemSprite2")) {
               if (Hero->ItemA) {
                  itemsprite item1 = RunItemSpriteScriptAt(Hero->ItemA, scr, this->X, this->Y, {Angle(Hero->X + 8, Hero->Y + 8, this->X, this->Y) - 10 - Rand(30), 2, 3, 0});
                  item1->Pickup |= IP_ALWAYSGRAB | IP_DUMMY;
               }

               if (Hero->ItemB) {
                  itemsprite item2 = RunItemSpriteScriptAt(Hero->ItemB, scr, this->X, this->Y, {Angle(Hero->X + 8, Hero->Y + 8, this->X, this->Y) + 10 + Rand(30), 2, 3, 0});

                  item2->Pickup |= IP_ALWAYSGRAB | IP_DUMMY;
               }
            }

            int itemA = Hero->ItemA;
            int itemB = Hero->ItemB;

            Hero->Item[Hero->ItemA] = false;
            Hero->Item[Hero->ItemB] = false;

            // if (Game->LoadItemData(itemA)->Type < 0 || Game->LoadItemData(itemB)->Type < 0)
            //    break;

            if (Game->LoadItemData(itemA)->Type == IC_BRANG)
               clearBoomerangs(itemA);
            if (Game->LoadItemData(itemB)->Type == IC_BRANG)
               clearBoomerangs(itemB);

            if (Game->LoadItemData(itemA)->Type == IC_CANDLE)
               clearCandles(itemA);
            if (Game->LoadItemData(itemB)->Type == IC_CANDLE)
               clearCandles(itemB);

            if (Game->LoadItemData(itemA)->Type == IC_SWORD)
               clearSwords(itemA);
            if (Game->LoadItemData(itemB)->Type == IC_SWORD)
               clearSwords(itemB);

            if (Game->LoadItemData(itemA)->Type == IC_ARROW)
               clearArrows(itemA);
            if (Game->LoadItemData(itemB)->Type == IC_ARROW)
               clearArrows(itemB);

            if (Game->LoadItemData(itemA)->Type == IC_POTION)
               clearPotions(itemA);
            if (Game->LoadItemData(itemB)->Type == IC_POTION)
               clearPotions(itemB);

            if (Game->LoadItemData(itemA)->Type == IC_WHISTLE)
               clearOcarinas(itemA);
            if (Game->LoadItemData(itemB)->Type == IC_WHISTLE)
               clearOcarinas(itemB);

            stolen = true;
         }

         --chargingCounter;
         LatrosWaitframe(this, latros);
      }

      this->NoCollisionTimer = 0;
   }

   void clearBoomerangs(int itemId) {
      switch (itemId) {
         case ITEM_BRANG2: Hero->Item[ITEM_BRANG1] = false;
      }
   }

   void clearSwords(int itemId) {
      switch (itemId) {
         case ITEM_SWORD3: Hero->Item[ITEM_SWORD2] = false;
         case ITEM_SWORD2: Hero->Item[ITEM_SWORD1] = false;
      }
   }

   void clearArrows(int itemId) {
      switch (itemId) {
         case ITEM_ARROW4: Hero->Item[ITEM_ARROW3] = false;
         case ITEM_ARROW3: Hero->Item[ITEM_ARROW2] = false;
         case ITEM_ARROW2: Hero->Item[ITEM_ARROW1] = false;
      }
   }

   void clearCandles(int itemId) {
      switch (itemId) {
         case ITEM_CANDLE3:
            Hero->Item[ITEM_CANDLE2] = false;
            Hero->Item[ITEM_CANDLE1] = false;
         case ITEM_CANDLE2: Hero->Item[ITEM_CANDLE1] = false;
      }
   }

   void clearPotions(int itemId) {
      switch (itemId) {
         case ITEM_POTION3: Hero->Item[ITEM_POTION2] = false;
         case I_POTION2: Hero->Item[ITEM_POTION1] = false;
      }
   }

   void clearOcarinas(int itemId) {
      switch (itemId) {
         case ITEM_OCARINA2: Hero->Item[ITEM_OCARINA1] = false;
         case ITEM_OCARINA1: Hero->Item[ITEM_OCARINA1] = false;
      }
   }

   void seekItem(npc this, Latros latros) {
      while (Screen->NumItems && !itemsUpForGrabs())
         LatrosWaitframe(this, latros, 16);

      while (itemsUpForGrabs() && latros->numItems < 5) {
         itemsprite itm = getClosestItem(this);
         this->Dir = AngleDir4(Angle(this->X, this->Y, itm->X, itm->Y));

         while (itm->isValid() && Distance(itm->X, itm->Y, this->X, this->Y) > 8) {
            this->MoveAtAngle(Angle(this->X, this->Y, itm->X, itm->Y), this->Step / 50, SPW_NONE);
            LatrosWaitframe(this, latros);
         }

         if (itm->isValid() && Collision(this, itm)) {
            Audio->PlaySound(SFX_PICKUP);
            latros->stealItem(itm->ID);
            itm->Remove();
         }

         LatrosWaitframe(this, latros, 16);
      }
   }

   int itemsUpForGrabs() {
      int count;

      for (int i = Screen->NumItems; i > 0; --i) {
         itemsprite itm = Screen->LoadItem(i);

         if (itm->Z == 0)
            ++count;
      }

      return count;
   }

   itemsprite getClosestItem(npc this) {
      itemsprite closestItem;
      int closestDist = 1000;

      for (int i = Screen->NumItems; i > 0; --i) {
         itemsprite itm = Screen->LoadItem(i);
         int dist = Distance(itm->X, itm->Y, this->X, this->Y) + Rand(8);

         if (dist < closestDist) {
            closestDist = dist;
            closestItem = itm;
         }
      }

      return closestItem;
   }

   void attackWithItem(npc this, Latros latros, int itemId, int swordDamage, int boomerangDamage, int bombDamage, int arrowDamage, int flameDamage, int hammerDamage, int rubbleDamage, int boomerangLevel, int bombExplosionDamage) {
      int potionCombo;

      itemdata id = Game->LoadItemData(itemId);
      spritedata spr = Game->LoadSpriteData(id->Sprites[0]);

      switch (itemId) {
         case ITEM_SWORD1: {
            for (int i = 0; i < 3; ++i) {
               if (swordSlash(this, latros, spr->Tile + 1, spr->CSet, ITEM_SWORD1, swordDamage))
                  break;
            }
            break;
         }
         case ITEM_SWORD2: {
            for (int i = 0; i < 3; ++i) {
               if (swordSlash(this, latros, spr->Tile + 1, spr->CSet, ITEM_SWORD2, swordDamage))
                  break;
            }
            break;
         }
         case ITEM_SWORD3: {
            for (int i = 0; i < 3; ++i) {
               if (swordSlash(this, latros, spr->Tile + 1, spr->CSet, ITEM_SWORD3, swordDamage))
                  break;
            }
            break;
         }
         case ITEM_BRANG1:
         case ITEM_BRANG2:
         case ITEM_BRANG3: {
            throwBoomerang(this, latros, id, boomerangDamage, boomerangLevel);
            break;
         }
         case ITEM_BOMB1: {
            Audio->PlaySound(SFX_OOT_BIG_DEKU_BABA_LUNGE);
            Waitframes(30);

            for (int i = 0; i < 5; ++i) {
               LatrosWaitframe(this, latros, 12);

               eweapon bomb = FireEWeaponAtHero(EW_BOMB, this->X, this->Y, true, 325, bombDamage, -1, 0, Game->GetEWeaponScript("ArcingWeapon"),
                  {-1, 0, AE_BOMB_EXPLOSION, this, bombDamage, bombExplosionDamage, true}
               );
               bomb->Unblockable = UNBLOCK_ALL;

               Audio->PlaySound(SFX_LAUNCH_BOMBS);
               LatrosWaitframe(this, latros, 6);
            }

            break;
         }
         case ITEM_ARROW1:
         case ITEM_ARROW2:
         case ITEM_ARROW3: {
            for (int i = 0; i < 5; ++i) {
               LatrosWaitframe(this, latros, 16);
               eweapon arrow = FireEWeaponAtHero(EW_ARROW, this->X, this->Y, true, 350, arrowDamage, -1, 0, Game->GetEWeaponScript("ArcingWeapon"),
                  {-1, 0, 0, this, arrowDamage, 0, true}
               );
               arrow->Unblockable = UNBLOCK_ALL;

               Audio->PlaySound(SFX_ARROW);
            }
            break;
         }
         case ITEM_CANDLE2: {
            flameChase(this, latros, ITEM_CANDLE2, flameDamage);
            break;
         }
         case ITEM_CANDLE1: {
            flameChase(this, latros, ITEM_CANDLE1, flameDamage);
            break;
         }
         case ITEM_HAMMER1: {
            for (int i = 0; i < 5; ++i) {
               int angle = Angle(this->X, this->Y, Hero->X, Hero->Y);
               FaceLink(this);
               eweapon hammer = FireEWeaponAtHero(EW_SCRIPT10, this->X + VectorX(16, angle + 180), this->Y + VectorY(16, angle + 180), true, 325, hammerDamage, 134, 0, Game->GetEWeaponScript("ArcingWeapon"),
                  {-1, 0, AE_ROCK_PROJECTILE, this, hammerDamage, rubbleDamage, true}
               );
               hammer->Unblockable = UNBLOCK_ALL;

               LatrosWaitframe(this, latros, 16);
            }

            break;
         }
         case ITEM_OCARINA2: {
            bool droppedOcarina = false;

            for (int i = 0; i < 180 && !droppedOcarina; ++i) {
               unless(i) Audio->PlaySound(SFX_WHISTLE);

               unless(latros->hasItem(ITEM_OCARINA2)) droppedOcarina = true;

               this->Dir = Hero->X < this->X ? DIR_LEFT : DIR_RIGHT;
               Screen->FastCombo(3, this->X + (this->Dir == DIR_LEFT ? -4 : 6), this->Y + 6, this->Dir == DIR_LEFT ? 6876 : 6877, 7, OP_OPAQUE);
               LatrosWaitframe(this, latros);
            }
            unless(droppedOcarina) {
               Audio->PlaySound(SFX_STALCHILD_ATTACK);
               latros->dropItem(ITEM_OCARINA2);
            }
            break;
         }
         case ITEM_OCARINA1: {
            bool droppedOcarina = false;

            for (int i = 0; i < 180 && !droppedOcarina; ++i) {
               unless(i) Audio->PlaySound(SFX_WHISTLE);

               unless(latros->hasItem(ITEM_OCARINA1)) droppedOcarina = true;

               this->Dir = Hero->X < this->X ? DIR_LEFT : DIR_RIGHT;
               Screen->FastCombo(3, this->X + (this->Dir == DIR_LEFT ? -4 : 6), this->Y + 6, this->Dir == DIR_LEFT ? 6876 : 6877, 0, OP_OPAQUE);
               LatrosWaitframe(this, latros);
            }
            unless(droppedOcarina) {
               Audio->PlaySound(SFX_STALCHILD_ATTACK);
               latros->dropItem(ITEM_OCARINA1);
            }
            break;
         }
         case ITEM_POTION3: {
            potionChug(this, latros, CMB_PURPLE_POTION);
            break;
         }
         case ITEM_POTION2: {
            potionChug(this, latros, CMB_RED_POTION);
            break;
         }
         case ITEM_POTION1: {
            potionChug(this, latros, CMB_BLUE_POTION);
            break;
         }
         case ITEM_MEDICINAL_HERB: {
            latros->dropItem(I_LETTER);
            break;
         }
         case ITEM_HEART_1: {
            Audio->PlaySound(SFX_STALCHILD_ATTACK);
            Audio->PlaySound(SFX_REFILL);
            latros->dropItem(ITEM_HEART_1);
            this->HP += 4;
            break;
         }
      } // TODO perhaps add more cases for rupees and such (handle that heart
        // situation)
   }

   void throwBoomerang(npc this, Latros latros, itemdata id, int damage, int boomerangLevel) {
      FaceLink(this);
      eweapon boomer = FireEWeaponDegAngle(EW_SCRIPT10, this->X, this->Y, (Angle(this->X, this->Y, Hero->X, Hero->Y)), 300, damage, id->Sprites[0], 0, Game->GetEWeaponScript("Boomerang"),
         {48, 10, 0, this, damage}
      );

      while (boomer->isValid()) {
         int hitId = Hero->HitBy[HIT_BY_EWEAPON];

         if (hitId) {
            eweapon hitHero = Screen->LoadEWeapon(hitId);

            int stunDur = boomerangLevel * 50;

            if (hitHero->isValid()) {
               Audio->PlaySound(Choose(SFX_HERO_HURT_1, SFX_HERO_HURT_2, SFX_HERO_HURT_3));
               Hero->Stun = stunDur;
               break;
            }
         }

         LatrosWaitframe(this, latros);
      }
   }

   void potionChug(npc this, Latros latros, int potionCombo) {
      LatrosWaitframe(this, latros, 30);
      bool droppedPotion = false;
      bool drankPotion = false;

      int potionToDrop;
      int postDrinkPotion;

      if (potionCombo == CMB_BLUE_POTION) {
         postDrinkPotion = 0;
         potionToDrop = I_POTION1;
      }
      else if (potionCombo == CMB_RED_POTION) {
         postDrinkPotion = I_POTION1;
         potionToDrop = I_POTION2;
      }
      else {
         postDrinkPotion = I_POTION2;
         potionToDrop = ITEM_POTION3;
      }

      for (int i = 0; i < 60 && !droppedPotion; ++i) {
         this->Dir = Hero->X < this->X ? DIR_LEFT : DIR_RIGHT;
         int drawX = this->Dir == DIR_LEFT ? this->X - 8 : this->X + 10;
         Screen->FastCombo(4, drawX, this->Y + 6, potionCombo, 1, OP_OPAQUE);

         if (int weaponId = latros->owner->HitBy[HIT_BY_LWEAPON]) {
            if (latros->numItems && weaponId) {
               --latros->hitCounter;
               latros->dropItem(potionToDrop);
               Audio->EndSound(SFX_REFILL);
               droppedPotion = true;
               break;
            }
         }

         LatrosWaitframe(this, latros);
      }

      unless(droppedPotion) {
         for (int i = 0; i < 60 && !droppedPotion; ++i) {
            Audio->PlaySound(SFX_REFILL);

            this->Dir = Hero->X < this->X ? DIR_LEFT : DIR_RIGHT;
            int drawX = this->Dir == DIR_LEFT ? this->X - 8 : this->X + 10;
            Screen->FastCombo(4, drawX, this->Y - 6, potionCombo + (this->Dir == DIR_LEFT ? 1 : 2), 1, OP_OPAQUE);

            if (int weaponId = latros->owner->HitBy[HIT_BY_LWEAPON]) {
               if (latros->numItems && weaponId) {
                  --latros->hitCounter;
                  latros->dropItem(potionToDrop);
                  Audio->EndSound(SFX_REFILL);
                  droppedPotion = true;
                  break;
               }
            }
            LatrosWaitframe(this, latros);
         }

         drankPotion = true;
         npcdata npcData = Game->LoadNPCData(this->ID);
         this->HP = npcData->HP;
      }

      if (drankPotion) {
         for (int i = 0; i < SizeOfArray(latros->stolenItems); ++i)
            if (latros->stolenItems[i] == potionToDrop) {
               latros->stolenItems[i] = postDrinkPotion;
            }
      }
   }

   bool swordSlash(npc this, Latros latros, int tile, int cset, int sword, int damage) {
      int moveAngle = Angle(this->X, this->Y, Hero->X, Hero->Y);
      int dashFrames = 12;

      for (int i = 0; i < 15; ++i) {
         unless(latros->hasItem(sword)) return true;
         LatrosWaitframe(this, latros);
      }

      for (int i = 0; i < dashFrames; ++i) {
         unless(latros->hasItem(sword)) return true;

         FaceLink(this);
         this->MoveAtAngle(moveAngle, 3, 0);

         if (i > dashFrames / 2)
            sword1x1Tile(this->X, this->Y, moveAngle - 90, (i - dashFrames / 2) / (dashFrames / 2) * 16, tile, cset, damage);

         LatrosWaitframe(this, latros);
      }

      Audio->PlaySound(SFX_SWORD);

      for (int i = 0; i <= 12; ++i) {
         unless(latros->hasItem(sword)) return true;

         FaceLink(this);
         this->MoveAtAngle(moveAngle, 3, 0);
         sword1x1Tile(this->X, this->Y, moveAngle - 90 + 15 * i, 16, tile, cset, damage);
         LatrosWaitframe(this, latros);
      }

      return false;
   }

   void flameChase(npc this, Latros latros, int itemId, int damage) {
      int vectorX, vectorY;

      for (int i = 0; i < 120; ++i) {
         FaceLink(this);
         vectorX = lazyChase(vectorX, this->X + 8, Hero->X - 8, .05, Hero->Step / 75);
         vectorY = lazyChase(vectorY, this->Y + 8, Hero->Y - 8, .05, Hero->Step / 75);
         this->MoveXY(vectorX, vectorY, SPW_NONE);

         int fireSprite;

         switch (itemId) {
            case ITEM_CANDLE1: {
               fireSprite = SPR_FLAME_WAX;
               break;
            }
            case ITEM_CANDLE2: {
               fireSprite = SPR_FLAME_OIL;
               damage = 6;
               break;
            }
         }

         unless(i % 10) {
            eweapon flame = CreateEWeaponAt(EW_SCRIPT1, this->X, this->Y);
            flame->Dir = AngleDir8(Angle(this->X, this->Y, Hero->X, Hero->Y));
            flame->Step = 225;
            flame->Angular = true;
            flame->Angle = DirRad(flame->Dir);
            flame->Script = Game->GetEWeaponScript("StopperKiller");
            flame->InitD[0] = 30;
            flame->InitD[1] = 200;
            flame->Gravity = true;
            flame->Damage = damage;
            flame->UseSprite(fireSprite);

            Audio->PlaySound(SFX_FIRE);
         }

         LatrosWaitframe(this, latros);
      }
   }

   void latrosDeathAnimation(npc n, int deathSound, Latros latros) {
      n->Immortal = true;
      n->NoCollisionTimer = -1;
      n->Stun = 9999;

		Screen->Message(349);
		Waitframe();

      int baseX = n->X + n->DrawXOffset;
      int baseY = (n->Y + n->DrawYOffset) - (n->Z + n->DrawZOffset);

      Audio->PlaySound(deathSound);
      int dropCount = 0;

      for (int i = 0; i < 45; i++) {
         unless(i % 3) {
            lweapon explosion = Screen->CreateLWeapon(LW_BOMBBLAST);
            explosion->X = baseX + RandGen->Rand(16 * n->TileWidth) - 8;
            explosion->Y = baseY + RandGen->Rand(16 * n->TileHeight) - 8;
            explosion->NoCollisionTimer = -1;
         }

         unless(i % 9) latros->dropItem(latros->stolenItems[dropCount++]);

         Waitframes(5);
      }

      MUSIC_INHERIT->Play();

      for (int i = Screen->NumNPCs; i >= 1; i--) {
         npc n = Screen->LoadNPC(i);
         n->Remove();
      }

      n->Immortal = false;
      n->HP = 0;
   }
}

   // Fight begins with him standing in the middle of the room
   // - He jumps into one of the walls
   // - For x seconds on each of the 4 walls his image is seen very small growing into normal size, if Link does nothing all 4 jump out and attack link with a magic blast
   // - If Link uses the Lens, he will see one of them will have a different cset
   // - If Link attacks one of the false quickknife's that one will vanish and the other 3 continue to approach
   // - If Link attacks the real one, quickknife takes damage and is lobbed somewhere in the room with a small stun afterwards
   // - Enter main battle loop:
   //    - Wanders around and cycles between attacks:
   //       - Turn to link, shoot a single magic blast
   //       - Turn to link, shoot a flurry of magic at Link
   //       - Turn to link, big attack, shoots two magic blasts that go out the the sides and close in on link in a hemisphere pattern
   //       - After x seconds, jumps back into a wall, repeat
   // - Phase 2 (under X% health)
   // - Speed increases, new attacks in main battle loop:
   //    - Single magic blasts turn into 2 quick succession blasts
   //    - Flurry is quicker
   //    - The two magic blasts in a hemisphere pattern turns into 4 with 2 more at a wider range, closing in on link slower after the first 2
   //    - New attack, shoots a giant magic blast (2x2 magic sprite), sometimes he shoots this in the patterns described in the other attacks

namespace Quickknife { //TODO reference ForceLinkInLv9Boss for forcing link into the room
   using namespace EnemyNamespace;
   using namespace NPCAnim;
   using namespace NPCAnim::Utility;

   class QuickknifeData {
      bool isClone;
      int initialHP;
      int phase;
      npc clones[0];

      QuickknifeData(npc owner, bool isClone) {
         initialHP = owner->HP;
         this->isClone = isClone;
      }
   }

   npc script Quickknife {
      enum Animations {
         ANIM_WALKING,
         ANIM_ATTACK,
         ANIM_APPEARING
      };

      CONFIG ANIM_WALKING_SPEED = 16;
      CONFIG ANIM_APPEAR_SPEED = 8;

      CONFIG INITD_IS_CLONE = 0;

      void run(bool isClone) {
         if (isClone)
            runClone(this);
         else
            runMain(this);
      }

      void runMain(npc this) {
         AnimHandler aptr = new AnimHandler(this);

         aptr->AddAnim(ANIM_WALKING, 0, 2, ANIM_WALKING_SPEED, ADF_4WAY);
         aptr->AddAnim(ANIM_ATTACK, 20, 1, 0, ADF_4WAY);
         aptr->AddAnim(ANIM_APPEARING, 40, 4, ANIM_APPEAR_SPEED, ADF_4WAY);

         QuickknifeData quickknifeData = new QuickknifeData(this, false);
         StoreEnemyClassPointer(this, quickknifeData);

         loop() {

            //Portrait Phase
            loop() {
               spawnClones(this);
               expandAppear(this);




               QuickknifeWaitframe(this);
            }

            QuickknifeWaitframe(this);
         }
      }

      void runClone(npc this) {
         AnimHandler aptr = new AnimHandler(this);

         aptr->AddAnim(ANIM_WALKING, 0, 2, ANIM_WALKING_SPEED, ADF_4WAY);
         aptr->AddAnim(ANIM_ATTACK, 20, 1, 0, ADF_4WAY);
         aptr->AddAnim(ANIM_APPEARING, 40, 4, ANIM_APPEAR_SPEED, ADF_4WAY);

         QuickknifeData quickknifeData = new QuickknifeData(this, true);
         StoreEnemyClassPointer(this, quickknifeData);

         bool interrupted = expandAppear(this);

         if (interrupted) {
            int angle = DirAngle(this->Dir);

            aptr->PlayAnim(ANIM_APPEARING, false, 4);

            for (int i = 0; i < 60; i++) {
               this->Dir = AngleDir4(WrapDegrees(angle + (i * 10)));
               QuickknifeWaitframe(this);
            }

            for (int i = 0; i < 8; i++) { //TODO change sprite to something fancy
               eweapon bullet = FireEWeaponDegAngle(EW_FIREBALL, this->X, this->Y, angle + Lerp(-45, 45, i / 7), 400, 8 /*is 8 a heart?*/, SPR_FIREBALL, SFX_AXE2);
               bullet->Unblockable = UNBLOCK_ALL;
            }

            this->Remove();
         }
         else {
            //jump out and attack
         }

         this->Remove();
      }

      void JumpAndShootMans(npc this) {
         CONFIG GRAVITY = .16;
         CONFIG TERMINAL_VELOCITY = 3.2;

         QuickknifeData quickknifeData = GetEnemyClassPointer(this);
         AnimHandler aptr = GetAnimHandler(this);

         aptr->PlayAnim(ANIM_ATTACK);

         this->Jump = PredictJumpFromDurationBruteForce(16, GRAVITY, TERMINAL_VELOCITY, 0);

         for (int i = 0; i < 16; i++) {
            this->Move(this->Dir, 1);
            QuickknifeWaitframe(this);
         }

         QuickknifeWaitframe(this, quickknifeData->isClone ? 90 : 30);

         FireEWeaponDegAngle(EW_MAGIC, this->X, this->Y, AngleLink(this), 400, 8 /*CREATE CONFIGS FOR DAMAGE*/, -1, SFX_MAGIC);
      }

      bool expandAppear(npc this) {
         QuickknifeData quickknifeData = GetEnemyClassPointer(this);
         bool ret;

         // this->Flags[NPCF_ONLY_LENS] = true;
         this->Flags[NPCF_NO_CONTACT_DAMAGE] = true;
         AnimHandler aptr = GetAnimHandler(this);

         aptr->PlayAnim(ANIM_APPEARING, false, quickknifeData->isClone ? 1 : 2);

         for (int i = 0; i < 240; i++) {
            this->Scale = Lerp(.1, 1, i / 239); //TODO, .1 because scale of 0 and near 0 will draw at full scale
            this->DrawXOffset = Lerp(8, 0, i / 239);
            this->DrawYOffset = Lerp(8, 0, i / 239);

            if (this->HitBy[HIT_BY_LWEAPON_PTR]) {
               ret = true;
               break;
            }

            QuickknifeWaitframe(this);
         }

         this->Scale = 1;
         this->DrawXOffset = 0;
         this->DrawYOffset = 0;

         for (int i = 0; i < 60 && !ret; i++) {
            if (this->HitBy[HIT_BY_LWEAPON_PTR]) {
               ret = true;
               break;
            }

            QuickknifeWaitframe(this);
         }

         this->Flags[NPCF_NO_CONTACT_DAMAGE] = false;
         // this->Flags[NPCF_ONLY_LENS] = false;

         return ret;
      }

      void spawnClones(npc this) {
         QuickknifeData quickknifeData = GetEnemyClassPointer(this);

         int topWall[0], bottomWall[0], leftWall[0], rightWall[0];
         int walls[][] = {topWall, bottomWall, leftWall, rightWall};

         for (int i = 0; i < NUM_COMBO_POS; i++) {
            switch(Screen->ComboF[i]) {
               case CF_ENEMY0:
                  ArrayPushBack(topWall, i);
                  break;
               case CF_ENEMY1:
                  ArrayPushBack(bottomWall, i);
                  break;
               case CF_ENEMY2:
                  ArrayPushBack(leftWall, i);
                  break;
               case CF_ENEMY3:
                  ArrayPushBack(rightWall, i);
                  break;
            }
         }

         int whichWall = Rand(0, 3);

         for (int i = 0; i < 4; i++) {
            int dir = (whichWall + i) % 4;
            int wallArray[] = walls[dir];

            int whichPos = Rand(SizeOfArray(wallArray));
            int x = ComboX(wallArray[whichPos]);
            int y = ComboY(wallArray[whichPos]);

            if (i == 0) {
               this->X = x;
               this->Y = y;
               this->Dir = OppositeDir(dir);
            }
            else {
               npc clone = CreateNPCAt(this->ID, x, y);
               clone->InitD[INITD_IS_CLONE] = true;
               clone->Dir = OppositeDir(dir);

               ArrayPushBack(quickknifeData->clones, clone);
            }
         }
      }

      void QuickknifeWaitframe(npc this, int frame = 1) {
         for (int i = 0; i < frame; i++) {

            Waitframe(this);
         }
      }
   }
}

npc script BigBadDodongo { //working name
   void run() {
      // Waits x seconds where Link can wander (not long like 3 seconds). Freeze action, climbs out of the pool of lava on the top or bottom of the screen (random), roars releasing a wind that pushes link (dont drown :D )
      // This battle is a side to side battle (since he is a 2x2 and there isnt much room above and below)
      // Similar to demon wall from FF, he slowly walks to you, you have to drop bombs and have the smoke hit its face (like classic), each time stunning him.
      // Do this enough times and he will open his mouth to sneeze, pushing link to a horizontal side of the room, he is stunned for awhile and Link can hit him with anything that makes sense
      // After the stun, he jumps back into a lava pool, regaining a small amount of health
      // Should Link hit him with a giant bomb, he will immediately jump back into a pool
      // Should Link not stop him from squishing him into a wall, he will eat link and chew, doing progressive damage, turn around and spit link across the room doing damage when he hits the wall
      // Repeat
   }
}

npc script Gamoth {
   void run() {
      // Upon entering the arena Gamoth is sitting on the tree on the bottom. Once Link is done rafting he spreads wings and makes a roar as dust comes out of his wings
      // Whenever he is moving he drops dust that will hurt link progressively and making him slightly drunk
      // He begins flying around the arena, main battle loop:
      //    - Spawns moth adds
      //    - Spreads wings and releases dust, this does progressive damage to link on contact and makes him drunk
      //    - He will fly to the closest side of the arena, and charge fly at link, leaving dust behind him
      //    Phase 2:
      //       - He flies faster and does 3 charges side to side (either vert or hori based on what wall was closest to him at first)
      //       - New attack, big burst AOE dust attack covering most of the arena
   }
}

npc script Gorodenti {
   void run() {
      // Upon entering the arena he will be on the right side of the room, roar, is a skeletal gleeok
      // Main battle loop: He strafes on one of the side walls and top wall doing things
      //    - If on a side wall
      //       - he will charge up, giving Link time to get higher, he then shoots a spray of fire that will fall on the bottom of the arena, if link is caught by that deal massive damage
      //       - he will slam the sides dropping rocks from above
      //    - If on the top wall
      //       - Drop a small burst of flame
      //       - Drop a flurry of flame that Link will need to hide under a platform to avoid
      //       - Big attack, shoots a giant flame multiple times that Link will need to time to dodge and this one doesnt get stopped by the platforms
      //    - He has 4 heads, every 20% hp reduction looses a head that then has its own pattern:
      //       - Flies around, but tries to keep a safe distance from Link, shooting flames at Link
      //       - Can be stunned and will be stunnable mid air so can be used as makeshift platforms temporarily, especially weak to giant bombs (can destroy them)
      //    - Death Animation is it freezes, and falls to the ground and on impact explodes
      //
   }
}

npc script Natavora {
   void run() {
      // Upon entering the arena he will be floating on the right side
      // NOTE - Is weak to the lvl2 ocarina, playing it stuns it for a considerable amount of time
      // When stunned at all it slowly floats to the bottom
      // Main Battle Loop:
      //    - Swims around at a safe distance from Link, always facing Link, occassionally shooting bubbles at Link that when Link gets hit, he is stunned and begins drifting into one of the corners (contact with him also does this)
      //    - Charge attack, will predict Link's movement so Link will have to be smart with movement and timing when this attack starts
      //    - Does a spin attack where it swirls the water towards itself and if Link gets too close, he gets eaten and takes damage over time while inside, IF he drops a giant bomb in this state (everything else does nothing) it does a ton of damage
      //    - Big Attack: Manipulates the water to suck everything into the corners, have to position near the middle of the arena to not drown
      //    - Death Animation is he goes belly up to the surface and explodes
   }
}

npc script Serris {
   void run() {
      // Upon entering the arena he will be hidden, then start like he does in metroid (basically this is a metroid clone sans the big attack)
      // Similar to his metroid variant
      // Main Battle Loop:
      //    - Basically the same as from metroid, except in phase 2 he drops giant bombs in his wake
      //    - Big Attack: He starts swirlling around Link if Link isnt able to do enough damage while he does this he scoops Link up, and with the camera focused on Link he swims around with Link in his mouth, then he spits Link out across the arena into the wall where he then floats down, lays there briefly, and continues the fight
   }
}

npc script Leviathan2 {
   void run() {
      // Starts hidden, he plays dialog,
      // Main Battle Loop:
      //    -
      //    -
      //    -
      //    -
   }
}

npc script Ignav {
   void run() {
      // 2 fights, Once before the dungeon is on and the other as the final boss
      // First Encounter;
      //    - Walks slowly at Link, shooting magic at him, after so long or he gets too close to Link he does something:
      //       - Too close: Swings a sword at Link that on impact yeets Link
      //       - Shoots a flurry of magic (think venser)
      //
      // Second Encounter (in a 2x2 region)
      // Main Battle Loop:
      //    - Walks slowly at Link, shooting magic at him, after so long or he gets too close to Link he does something:
      //       - Too close: Swings a sword at Link that on impact yeets Link
      //       - Shoots a flurry of magic (think venser)
      //    - Summons wizzrobes
      //    - Will call down magical orbs that crash on the ground, if link touches or hits them they split in 2, this happens even to the split ones. If they split too many times, all existing orbs home in on like with acceleration
      //    - Big Attack: Occassionally jump really far back from Link and shoots a massive burst of magic that closes in on link (think the skull attack from Slave Knight Gale)
      //    - Big Attack: (Only way to stop is to hit him) He charges up a massive magical blast above him
      //       - If he completes the charging, it perfectly homes in on link with acceleration dealing huge damage, only way to avoid is Nayru's Love (dont even have yet) or an essentially frame perfect hookshot
      //       - (Desperation attack) If Link interrupts, Link has a few seconds to get away from him before he explodes, dealing enough damage to kill Link outright, and a huge amount to him
   }
}

npc script Camazotz {
   void run() {
      // Giant Dark Vire with enough bats surrounding it you can barely even see it, enemies that get close to it are sucked into the swarm
      // Heavily movement based, moving is not always the answer
      // All bats are enflamed
      // Main Battle Loop:
      //    - It starts by wandering around as though it doesnt know Link are there
      //    - When Link move, it moves towards Link but not directly, it takes wide turns and sort of gravitates to Link, stopping it moves away from Link
      //    - Should it make contact with Link, Link get caught by it and start to swirl amongst the bats, if Link hit it enough it will drop Link
      //    - Hitting it does not do damage
      //    - As it is moving towards Link bats from the swirl will progressively fly out towards Link
      //    - In order to do actual damage, Link must get all of the bat to fly off of him, once he does, phase 2 begins
      // Phase 2 (NOTE - as it moves it has the shadow trail)
      //    - This boss is not shy and does not keep its distance from Link, but Link hitting it does apply knockback
      //    - After being knocked back, sometimes it will pause and materialize bats on itself, making it invulnerable, and shoot them all back at Link, then it continues the pursuit
      //    - If Link uses the Spectral Cane on it, it goes into a frenzy mode, continuously materializing bats on itself and shooting them at Link (think sasic's flaming drift towards link attack but shooting bats), it does this for awhile for those fools who try to use a dark weapon on a dark entity :facepalm:
      //    - Big Attack:
      //       - (Desperation attack) Long Charge Time, invulnerable, materializing bats but the bats grow larger to 2x2, and once he has so many swirling about him, he shoots them at link, he is then motionless for a couple seconds after this and vulnerable
   }
}

npc script Morsa {
   void run() {
      // 2 encounters, This boss is a black skeleton (2x2) that is shrouded in darkness to where you only see glimpses of it behind the darkness
      // Deadhand is also here, if he wasnt beaten in his boss arena
      // Main Battle Loop:
      //    - Animation is a figure-eight-ish pattern where it is floating above the ground
      //    - At the start of the fight it doesnt move, once Link approaches it does its darknessFlash
      //    - DarknessFlash is a move it does where it moves in some direction away from Link, think of it as it very quickly dashes off in a cloud of darkness vanishing
      //    - From its DarknessFlash it can do a number of things:
      //       - If Link does not move much he will drop from above grabbing Link. In this grab Link takes a lot of damage over time and is with the skeleton in the shroud of darkness
      //          - Once released Link is slower, does less damage, and has lowered defenses for some time after
      //       - If Link is moving he will DarknessFlash back into the arena
      //          - If link is near the arena edge he will dash at him, otherwise he will dash at any random point
      //    - Right after the dash he will immediately shoot orbs of darkness (the sprite will be basically a black ball with swirling darkness around it) he has multiple shooting patterns
      //       - Many obs sequentially at Link
      //       - Sometimes the orbs go away from Link for a bit, them home in on him (think the red magic from venser)
      //       - He will shoot larger orbs (2x2 perhaps) that bounce off the walls and stick around for n bounces
      //    - Special attack if deadhand is present:
      //       - He rises above the arena and infuses deadhand with darkness, making him faster and do more damage
      //    - Big Attack: Executed from his DarknessFlash, his big attack is where, after Link, darknessflashing in then out repeatedly, and on the last one, charges at Link perfectly and can only be stopped with an attack
   }
}

npc script Deadhand {
   void run() {
      // Essentially the same as OoT
      // Main Battle Loop:
      //    - 4 Arms are sticking out of the ground, getting grabbed lures the deadhand towards you, hands do 1 damage per second you are grabbed
      //    - Once he gets so close he attempts to bite you
      //    - Hitting him interrupts him, not hitting him gets you bit, but this time he picks you up in his mouth and bites harder until he kills you or you hit him after 3 bites
      //    - Should you kill all of the hands he immediately comes out weakened, moving slowly away from Link and after so long goes back under and respawns his hands
   }
}

npc script Necromancer {
   void run() {
      // Starts hidden, he plays dialog,
      // Main Battle Loop:
      //    -
      //    -
      //    -
      //    -
   }
}

npc script OvergrownOctorock {
   void run() {
      // Starts hidden, he plays dialog,
      // Main Battle Loop:
      //    -
      //    -
      //    -
      //    -
   }
}

npc script Kaarszythe {
   void run() {
      // Starts hidden, he plays dialog,
      // Main Battle Loop:
      //    -
      //    -
      //    -
      //    -
   }
}

npc script Duorum {
   void run() {
      // Starts hidden, he plays dialog,
      // Main Battle Loop:
      //    -
      //    -
      //    -
      //    -
   }
}

npc script Riafron {
   void run() {
      // Starts hidden, he plays dialog,
      // Main Battle Loop:
      //    -
      //    -
      //    -
      //    -
   }
}

npc script ArcaneGolem {
   void run() {
      // Starts hidden, he plays dialog,
      // Main Battle Loop:
      //    -
      //    -
      //    -
      //    -
   }
}

npc script Frostflame {
   void run() {
      // Starts hidden, he plays dialog,
      // Main Battle Loop:
      //    -
      //    -
      //    -
      //    -
   }
}

npc script Atronach {
   void run() {
      // Starts hidden, he plays dialog,
      // Main Battle Loop:
      //    -
      //    -
      //    -
      //    -
   }
}

npc script TheStorm {
   void run() {
      // Starts hidden, he plays dialog,
      // Main Battle Loop:
      //    -
      //    -
      //    -
      //    -
   }
}

npc script Oblitem {
   void run() {
      // Starts hidden, he plays dialog,
      // Main Battle Loop:
      //    -
      //    -
      //    -
      //    -
   }
}

npc script AemulorShade {
   void run() {
      // Starts hidden, he plays dialog,
      // Main Battle Loop:
      //    -
      //    -
      //    -
      //    -
   }
}

npc script ShadowLink {
   void run() {
      // Starts hidden, he plays dialog,
      // Main Battle Loop:
      //    -
      //    -
      //    -
      //    -
   }
}

npc script Aemulor {
   void run() {
      // Starts hidden, he plays dialog,
      // Main Battle Loop:
      //    -
      //    -
      //    -
      //    -
   }
}

// clang-format off
@Author("Deathrider365")
npc script Demonwall { //TODO this script already exists to some degree (probably as ghost)
   // clang-format on
   void run() {
      // for (int i = 0; i < roomsize since the wall can squish link for
      // instakill; ++i)
      // {
      // move the guy perhaps 1/8th of a tile every frame
      // if (demonwall->HP at 70%)
      // move demonwall back 3 tiles if it can, otherwise just back the the left
      // wall

      // do some attacks

      // }
   }
}

// clang-format off
@Author("Deathrider365")
npc script TheMorsa {
   // clang-format on

   using namespace EnemyNamespace;

   void run() {
      this->Immortal = true;

      while(this->HP > 0) {
         Waitframe();
      }

      //Death animation

      auriVillageMusicSet = true;
      Game->LoadDMapData(Game->GetDMap("NEI Auri Village"))->Music = Audio->LoadMusicData(93); //Dmap 7, NEI Auri Village

      this->Immortal = false;
   }
}