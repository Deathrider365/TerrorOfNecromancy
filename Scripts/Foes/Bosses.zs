//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Bosses ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

namespace LeviathanNamespace {
   const int CMB_WATERFALL = 9984;
   const int CS_WATERFALL = 0;

   const int VARS_HEADNPC = 0;
   const int VARS_FLASHTIMER = 5;
   const int VARS_HEAD_CENTERX = 1;
   const int VARS_HEAD_CENTERY = 2;
   const int VARS_FLIP = 3;
   const int VARS_INITHP = 6;
   const int VARS_BODYHP = 8;

   const int NPC_LEVIATHANHEAD = 177;

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

   COLOR C_CHARGE1 = C_DARKBLUE;
   COLOR C_CHARGE2 = C_SEABLUE;
   COLOR C_CHARGE3 = C_TAN;

   // TODO Make not a global
   int LEVIATHAN_WATERCANNON_DMG = 70;
   int LEVIATHAN_BURSTCANNON_DMG = 40;
   int LEVIATHAN_WATERFALL_DMG = 60;
   int LEVIATHAN_SIDESWIPE_DMG = 80;

   CONFIG MSG_BEATEN = 23;
   CONFIG MSG_LEVIATHAN_SCALE = 1052;

   bool firstRun = true;

   // clang-format off
   @Author("Moosh, modified by Deathrider365")
   npc script Leviathan {
      // clang-format on

      void run() {
         Hero->Dir = DIR_UP;

         if (waterfallBitmap && waterfallBitmap->isAllocated())
            waterfallBitmap->Free();

         waterfallBitmap = Game->CreateBitmap(32, 176);

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

         while (true) {
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
                  vars[VARS_FLIP] = Hero->X + 8 < 128 ? 0 : 1;
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

                  centerOnLinkX += Hero->X - (vars[VARS_FLIP] ? 48 : 80) - flipModifier;

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
                  int risingX = Hero->X <= 64 ? Rand(32, 144) : Rand(-48, 80);
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
                  int risingX = Hero->X <= 64 ? Rand(32, 144) : Rand(-48, 80);
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

   int changeInDifficulty(npc n, int vars) {
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
            waterSplash->CollDetection = false;

            waterSplash = CreateLWeaponAt(LW_SPARKLE, x + 4 + 4 * i, y);
            waterSplash->UseSprite(SPR_SPLASH);
            waterSplash->ASpeed += Rand(3);
            waterSplash->Step = Rand(100, 200) * j * 0.5;
            waterSplash->Angular = true;
            waterSplash->Angle = DegtoRad(-90 + 5 + 15 * i + Rand(-5, 5));
            waterSplash->CollDetection = false;
            waterSplash->Flip = 1;
         }
      }
   }

   void LeviathanWaitframe(npc this, untyped vars, int frames) {
      for (int i = 0; i < frames; ++i)
         LeviathanWaitframe(this, vars);
   }

   void LeviathanWaitframe(npc this, untyped vars) {
      this->DrawYOffset = -1000;
      this->Stun = 10;
      this->Immortal = true;

      if (vars[VARS_FLIP])
         this->HitXOffset = 32;
      else
         this->HitXOffset = 64;

      if (this->Y + this->HitYOffset + this->HitHeight - 1 <= 112 && vars[VARS_FLASHTIMER] == 0)
         this->CollDetection = true;
      else
         this->CollDetection = false;

      npc head = <npc> vars[VARS_HEADNPC];

      if (head->isValid()) {
         if (head->Y + head->HitYOffset + head->HitHeight - 1 <= 112 && vars[VARS_FLASHTIMER] == 0)
            head->CollDetection = true;
         else
            head->CollDetection = false;

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
      this->CollDetection = false;

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

      Hero->WarpEx({WT_IWARPOPENWIPE, 2, 11, -1, WARP_A, WARPEFFECT_WAVE, 0, 0, DIR_LEFT});

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
         hitbox->CollDetection = false;

         int startX = this->X;

         int waterfallTop = this->Y;
         int waterfallBottom = this->Y;
         int bgHeight;
         int fgHeight;
         this->CollDetection = false;

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
         hitbox->CollDetection = true;

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
} // namespace LeviathanNamespace

// clang-format off
@Author("Moosh, modified by Deathrider365") 
ffc script Legionnaire {
   // clang-format on

   CONFIG ATTACK_INITIAL_RUSH = -1;
   CONFIG ATTACK_FIRE_SWORDS = 0;
   CONFIG ATTACK_JUMPS_ON_YOU = 1;
   CONFIG ATTACK_SPRINT_SLASH = 2;

   void run(int enemyid) {
      npc ghost = Ghost_InitAutoGhost(this, enemyid);

      CONFIG DMG_FIRE_SWORDS = ghost->WeaponDamage + ghost->WeaponDamage * .3;
      CONFIG DMG_JUMPS_ON_YOU = ghost->WeaponDamage + ghost->WeaponDamage * .4;
      CONFIG DMG_SPRINT_SLASH = ghost->WeaponDamage + ghost->WeaponDamage * .5;

      if (Screen->State[ST_SECRET]) {
         ghost->Remove();
         Quit();
      }

      Ghost_SetFlag(GHF_4WAY);

      int screenD = ghost->Attributes[6];
      int startX = ghost->Attributes[7];
      int startY = ghost->Attributes[8];
      int hp = ghost->Attributes[9];
      int combo = ghost->Attributes[10];

      int attackCoolDown = 0;
      int attack = -1;
      int startHP = Ghost_HP;
      int movementDirection = Choose(90, -90);

      int timeToSpawnAnother, enemyCount;
      int numEnemies = Screen->NumNPCs();

      // Intro Animation
      unless(getScreenD(screenD)) {
         Ghost_Y = -32;
         Ghost_X = startX;

         for (int i = 0; i < 32; ++i) {
            disableLink();
            Ghost_Waitframe(this, ghost);
         }

         Ghost_Y = startY;
         Ghost_Z = 176;
         Ghost_Dir = DIR_DOWN;

         while (Ghost_Z) {
            disableLink();
            Ghost_Z -= 4;
            Ghost_Waitframe(this, ghost);
         }

         Screen->Quake = 10;
         Audio->PlaySound(SFX_IMPACT_EXPLOSION);

         for (int i = 0; i < 32; ++i) {
            disableLink();
            Ghost_Waitframe(this, ghost);
         }

         Audio->PlaySound(SFX_STALFOS_GROAN);

         setScreenD(screenD, true);
      }
      else {
         Ghost_X = startX;
         Ghost_Y = startY;
         Ghost_Z = 0;
      }

      while (true) {
         Ghost_Data = combo + 4;
         Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Hero->X, Hero->Y));
         int moveAngle = Angle(Ghost_X, Ghost_Y, Hero->X, Hero->Y) + movementDirection;
         numEnemies = Screen->NumNPCs();

         Ghost_MoveAtAngle(moveAngle, ghost->Step / 100, 0);

         // Calls Reinforcements
         if (timeToSpawnAnother >= 300 && numEnemies < 3) {
            enemyShake(this, ghost, 32, 1);
            Audio->PlaySound(SFX_OOT_WHISTLE);

            npc backupLegionnaire = Screen->CreateNPC(ENEMY_LEGIONNAIRE);
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
                  if (Ghost_CanPlace(x, y, 16, 16))
                     break;
            }

            backupLegionnaire->X = x;
            backupLegionnaire->Y = y;

            timeToSpawnAnother = 0;
         }

         if (attackCoolDown)
            --attackCoolDown;
         else {
            attackCoolDown = 90 + Rand(30);
            attack = attackChoice(attack);

            switch (attack) {
               case ATTACK_INITIAL_RUSH: {
                  jumpsOnYou(this, ghost, combo, Ghost_X, Ghost_X, movementDirection, 32, DMG_JUMPS_ON_YOU);
                  attackFireSwords(this, ghost, combo, Ghost_X, Ghost_X, movementDirection, DMG_FIRE_SWORDS);
                  attackSprintSlash(this, ghost, combo, Ghost_X, Ghost_X, movementDirection, DMG_SPRINT_SLASH);
                  attack = ATTACK_FIRE_SWORDS;
                  break;
               }
               case ATTACK_FIRE_SWORDS: {
                  attackFireSwords(this, ghost, combo, Ghost_X, Ghost_X, movementDirection, DMG_FIRE_SWORDS);
                  break;
               }
               case ATTACK_JUMPS_ON_YOU: {
                  jumpsOnYou(this, ghost, combo, Ghost_X, Ghost_X, movementDirection, 32, DMG_JUMPS_ON_YOU);
                  break;
               }
               case ATTACK_SPRINT_SLASH: {
                  attackSprintSlash(this, ghost, combo, Ghost_X, Ghost_X, movementDirection, DMG_SPRINT_SLASH);
                  break;
               }
            }
         }

         if (Ghost_HP <= startHP * .5)
            timeToSpawnAnother++;

         Ghost_Waitframe(this, ghost);
      }
   }

   int attackChoice(int attack) {
      int distanceBetween = Distance(Ghost_X, Ghost_Y, Hero->X, Hero->Y);

      if (attack == ATTACK_FIRE_SWORDS) {
         attack = ATTACK_SPRINT_SLASH;
      }
      else if (attack == ATTACK_JUMPS_ON_YOU) {
         if (distanceBetween < 48)
            attack = ATTACK_JUMPS_ON_YOU;
         if (distanceBetween < 64)
            attack = ATTACK_FIRE_SWORDS;
         else
            attack = ATTACK_SPRINT_SLASH;
      }
      else if (attack == ATTACK_SPRINT_SLASH) {
         if (distanceBetween > 64)
            attack = ATTACK_SPRINT_SLASH;
         else if (distanceBetween > 48)
            attack = ATTACK_FIRE_SWORDS;
         else
            attack = ATTACK_JUMPS_ON_YOU;
      }
      return attack;
   }

   void attackFireSwords(ffc this, npc ghost, int combo, int ghostX, int ghostY, int movementDirection, int damage) {
      Audio->PlaySound(SFX_STALFOS_GROAN_SLOW);
      enemyShake(this, ghost, 48, 1);
      Ghost_Data = combo;

      for (int i = 0; i < 5; ++i) {
         eweapon projectile = FireAimedEWeapon(EW_BEAM, Ghost_X, Ghost_Y, 0, 300, damage, SPR_LEGIONNAIRESWORD, SFX_SHOOTSWORD, EWF_UNBLOCKABLE);
         Ghost_Waitframes(this, ghost, 16);
      }

      Ghost_Waitframes(this, ghost, 16);
      movementDirection = Choose(90, -90);
   }

   void jumpsOnYou(ffc this, npc ghost, int combo, int ghostX, int ghostY, int movementDirection, int shakeDuration, int damage) {
      Audio->PlaySound(SFX_STALFOS_GROAN);
      Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Hero->X, Hero->Y));
      enemyShake(this, ghost, shakeDuration, 2);
      Ghost_Data = combo + 8;

      int distance = Distance(Ghost_X, Ghost_Y, Hero->X, Hero->Y);
      int jumpAngle = Angle(Ghost_X, Ghost_Y, Hero->X, Hero->Y);

      Ghost_Jump = getJumpLength(distance / 2, true);
      Audio->PlaySound(SFX_JUMP);

      while (Ghost_Jump || Ghost_Z) {
         Ghost_MoveAtAngle(jumpAngle, 2, 0);
         Ghost_Waitframe(this, ghost);
      }

      Ghost_Data = combo;
      Audio->PlaySound(SFX_IMPACT_EXPLOSION);

      for (int i = 0; i < 24; ++i) {
         makeHitbox(Ghost_X - 12, Ghost_Y - 12, 40, 40, damage);
         Screen->DrawTile(2, Ghost_X - 16, Ghost_Y - 16, (i > 7 && i <= 15) ? TILE_IMPACT_BIG : TILE_IMPACT_MID, 3, 3, 8, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
         Ghost_Waitframe(this, ghost);
      }

      movementDirection = Choose(90, -90);
   }

   void attackSprintSlash(ffc this, npc ghost, int combo, int ghostX, int ghostY, int movementDirection, int damage) {
      Audio->PlaySound(SFX_STALFOS_GROAN_FAST);
      enemyShake(this, ghost, 16, 2);
      Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Hero->X, Hero->Y));

      int moveAngle = Angle(Ghost_X, Ghost_Y, Hero->X, Hero->Y);
      int distance = Distance(Ghost_X, Ghost_Y, Hero->X, Hero->Y);
      int dashFrames = Max(6, (distance - 36) / 3);

      for (int i = 0; i < dashFrames; ++i) {
         Ghost_MoveAtAngle(moveAngle, 3, 0);

         if (i > dashFrames / 2)
            sword1x1(Ghost_X, Ghost_Y, moveAngle - 90, (i - dashFrames / 2) / (dashFrames / 2) * 16, combo + 12, 10, damage);

         Ghost_Waitframe(this, ghost);
      }

      Audio->PlaySound(SFX_SWORD);

      for (int i = 0; i <= 12; ++i) {
         Ghost_MoveAtAngle(moveAngle, 3, 0);
         sword1x1(Ghost_X, Ghost_Y, moveAngle - 90 + 15 * i, 16, combo + 12, 10, damage);
         Ghost_Waitframe(this, ghost);
      }

      movementDirection = Choose(90, -90);
   }
}

namespace ShamblesNamespace {
   CONFIG ATTACK_INITIAL_RUSH = -1;
   CONFIG ATTACK_LINK_CHARGE = 0;
   CONFIG ATTACK_BOMB_LOB = 1;
   CONFIG ATTACK_SPAWN_ZAMBIES = 2;

   bool firstRun = true;

   // clang-format off
   @Author("Moosh, modified by Deathrider365") 
   ffc script Shambles {
      // clang-format on

      void run(int enemyid) {
         npc ghost = Ghost_InitAutoGhost(this, enemyid);
         int combo = ghost->Attributes[10];
         int attackCoolDown = 90;
         int startHP = Ghost_HP;
         int bombsToLob = 2;
         int difficultyMultiplier = 0.5;
         int attack = -1;

         CONFIG DMG_CLOUD = 1;
         CONFIG DMG_BOMB = ghost->WeaponDamage;
         CONFIG DMG_BOMB_POISON = ghost->WeaponDamage / 2;

         Ghost_X = 128;
         Ghost_Y = -32;
         Ghost_Dir = DIR_DOWN;

         if (firstRun) {
            introCutscene(this, ghost, combo);
            firstRun = false;
         }

         while (true) {
            attack = chooseAttack(attack);

            ShamblesWaitframe(this, ghost, 120);

            int pos = moveMe();
            Ghost_X = ComboX(pos);
            Ghost_Y = ComboY(pos);

            if (Ghost_HP < startHP * difficultyMultiplier) {
               emerge(this, ghost, 4);
               bombsToLob = 3;
            }
            else
               emerge(this, ghost, 8);

            switch (attack) {
               case ATTACK_INITIAL_RUSH: {
                  spawnZambos(this, ghost, 2);
                  attackBombLob(this, ghost, startHP, bombsToLob, Ghost_X, Ghost_Y, difficultyMultiplier, DMG_BOMB, DMG_BOMB_POISON);
                  break;
               }
               case ATTACK_LINK_CHARGE: {
                  for (int i = 0; i < 3; ++i) {
                     Audio->PlaySound(SFX_MIRROR_SHIELD_ABSORB_LOOP);
                     Waitframes(15);

                     int moveAngle = Angle(Ghost_X, Ghost_Y, Hero->X, Hero->Y);
                     Audio->PlaySound(SFX_SWORD);

                     for (int j = 0; j < 30; ++j) {
                        if (Ghost_HP < startHP * difficultyMultiplier && j % 3 == 0) {
                           eweapon poisonTrail = FireEWeapon(EW_SCRIPT10, Ghost_X + Rand(-2, 2), Ghost_Y + Rand(-2, 2), 0, 0, DMG_CLOUD, SPR_POISON_CLOUD, SFX_SIZZLE, EWF_UNBLOCKABLE);
                           SetEWeaponLifespan(poisonTrail, EWL_TIMER, 60);
                           SetEWeaponDeathEffect(poisonTrail, EWD_VANISH, 0);
                        }

                        Ghost_ShadowTrail(this, ghost, false, 6);
                        Ghost_MoveAtAngle(moveAngle, 3, 0);
                        ShamblesWaitframe(this, ghost, 1);
                     }

                     ShamblesWaitframe(this, ghost, 45);
                  }
                  break;
               }
               case ATTACK_BOMB_LOB: {
                  attackBombLob(this, ghost, startHP, bombsToLob, Ghost_X, Ghost_Y, difficultyMultiplier, DMG_BOMB, DMG_BOMB_POISON);
                  break;
               }
               case ATTACK_SPAWN_ZAMBIES: {
                  spawnZambos(this, ghost, 2);
                  break;
               }
            }

            if (Ghost_HP < startHP * 0.50)
               submerge(this, ghost, 4);
            else
               submerge(this, ghost, 8);

            pos = moveMe();
            Ghost_X = ComboX(pos);
            Ghost_Y = ComboY(pos);
         }
      }
   }

   void introCutscene(ffc this, npc ghost, int combo) {
      Hero->Stun = 270;

      Screen->Quake = 90;
      ShamblesWaitframe(this, ghost, 90, SFX_ROCKINGSHIP);

      Ghost_X = 120;
      Ghost_Y = 80;
      Ghost_Data = combo + 4;

      Screen->Quake = 60;
      ShamblesWaitframe(this, ghost, 60, SFX_ROCKINGSHIP);

      Ghost_Data = combo + 5;

      Screen->Quake = 60;
      ShamblesWaitframe(this, ghost, 60, SFX_ROCKINGSHIP);

      Ghost_Data = combo + 6;

      Screen->Quake = 60;
      ShamblesWaitframe(this, ghost, 60, SFX_ROCKINGSHIP);

      Screen->Message(803);
      submerge(this, ghost, 8);
   }

   void attackBombLob(ffc this, npc ghost, int startHP, int bombsToLob, int Ghost_X, int Ghost_Y, int difficultyMultiplier, int bombDamage, int poisonDamage) {
      Audio->PlaySound(SFX_OOT_BIG_DEKU_BABA_LUNGE);
      Waitframes(30);

      for (int i = 0; i < bombsToLob; ++i) {
         ShamblesWaitframe(this, ghost, 16);
         eweapon bomb = FireAimedEWeapon(EW_BOMB, Ghost_X, Ghost_Y, 0, 200, bombDamage, -1, -1, EWF_UNBLOCKABLE | EWF_ROTATE);
         Audio->PlaySound(SFX_LAUNCH_BOMBS);
         runEWeaponScript(bomb, Game->GetEWeaponScript("ArcingWeapon"), {-1, 0, (Ghost_HP < (startHP * difficultyMultiplier)) ? AE_LARGEPOISONPOOL : AE_SMALLPOISONPOOL, poisonDamage});
         Waitframes(15);
      }
   }

   void spawnZambos(ffc this, npc ghost, int numZombies) {
      for (int i = 0; i < numZombies; ++i) {
         Audio->PlaySound(SFX_SUMMON_MINE);
         npc zambo = Screen->CreateNPC(ENEMY_ZOMBIE_LV1);

         int pos = moveMe();

         zambo->X = ComboX(pos);
         zambo->Y = ComboY(pos);

         ShamblesWaitframe(this, ghost, 30);
      }
   }

   int moveMe() {
      int pos;

      for (int i = 0; i < 352; ++i) {
         if (i < 176)
            pos = Rand(176);
         else
            pos = i - 176;

         int x = ComboX(pos);
         int y = ComboY(pos);

         if (Distance(Hero->X, Hero->Y, x, y) > 48)
            if (Ghost_CanPlace(x, y, 16, 16))
               break;
      }

      return pos;
   }

   void emerge(ffc this, npc ghost, int frames) {
      int combo = ghost->Attributes[10];
      ghost->CollDetection = true;
      ghost->DrawYOffset = -2;

      Ghost_Data = combo + 4;
      ShamblesWaitframe(this, ghost, frames);

      Audio->PlaySound(130);

      Ghost_Data = combo + 5;
      ShamblesWaitframe(this, ghost, frames);

      Ghost_Data = combo + 6;
      ShamblesWaitframe(this, ghost, frames);
   }

   void submerge(ffc this, npc ghost, int frames) {
      int combo = ghost->Attributes[10];

      Ghost_Data = combo + 6;
      ShamblesWaitframe(this, ghost, frames);

      Audio->PlaySound(130);

      Ghost_Data = combo + 5;
      ShamblesWaitframe(this, ghost, frames);

      Ghost_Data = combo + 4;
      ShamblesWaitframe(this, ghost, frames);

      ghost->CollDetection = false;
      ghost->DrawYOffset = -1000;
   }

   int chooseAttack(int attack) {
      if (Screen->NumNPCs() >= 3) {
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

   void ShamblesWaitframe(ffc this, npc ghost, int frames) {
      for (int i = 0; i < frames; ++i)
         Ghost_Waitframe(this, ghost, 1, true);
   }

   void ShamblesWaitframe(ffc this, npc ghost, int frames, int sfx) {
      for (int i = 0; i < frames; ++i) {
         if (sfx > 0 && i % 30 == 0)
            Audio->PlaySound(sfx);

         Ghost_Waitframe(this, ghost, 1, true);
      }
   }
} // namespace ShamblesNamespace

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
         }

         if (firstRun) {
            disableLink();
            commenceIntroSequence(this, data, heads);
            Screen->Message(804);
            firstRun = false;
         }
         else
            Audio->PlayEnhancedMusic("The Binding of Isaac - Divine Combat.ogg", 0);

         disableLink();

         while (this->HP > 0) {
            int previousAttack;

            int angle;
            int headOpen = 20;
            int headOpenIndex;

            while (true) {
               if (isHeadsDead(heads))
                  break;

               for (int i = 0; i < 20; ++i)
                  this->Defense[i] = NPCDT_IGNORE;

               for (int i = 0; i < 4; ++i)
                  if (heads[i])
                     heads[i]->CollDetection = true;

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

            this->CollDetection = true;
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

            for (int i = 0; i < 10; ++i)
               EnemyWaitframe(this, data);

            int previousX, previousY, prevIndex;

            int fleeDuration = 5 * 60;

            while (fleeDuration) {
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

            this->CollDetection = false;

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
               heads[headIndex]->CollDetection = false;
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
            this->CollDetection = true;

            for (int headIndex = 0; headIndex < 4; ++headIndex)
               heads[headIndex]->DrawXOffset = 0;
         }

         effectBitmap->Free();
         this->CollDetection = false;
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
      bitmap introSequenceBitmap = create(512, 168);
      int panPosition = 0;
      disableLink();

      this->X = -64;
      this->Y = -64;
      Hero->Dir = DIR_RIGHT;
      Hero->Invisible = true;

      // Silent Pause
      Audio->PlayEnhancedMusic(null, 0);
      introSequenceBitmap->Clear(0);

      // Pause
      for (int i = 0; i < 60; ++i) {
         disableLink();
         introSequenceBitmap->DrawLayer(2, 37, 43, 3, 0, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 43, 0, 0, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 43, 1, 0, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 43, 2, 0, 0, 0, OP_TRANS);
         introSequenceBitmap->DrawLayer(2, 37, 43, 4, 0, 0, 0, OP_OPAQUE);
         introSequenceBitmap->FastCombo(2, 112, 0, 4632, 2, OP_OPAQUE);
         introSequenceBitmap->FastCombo(2, 128, 0, 4632, 2, OP_OPAQUE);
         introSequenceBitmap->FastCombo(2, 120, 120, 6731, 0, OP_OPAQUE);

         introSequenceBitmap->Blit(2, RT_SCREEN, 0, 0, 512, 168, 0, 0, 512, 168, 0, 0, 0, BITDX_NORMAL, 0, true);

         Waitframe();
      }

      // Start Panning
      until(panPosition == 40) {
         disableLink();
         panPosition += 4;

         introSequenceBitmap->DrawLayer(2, 37, 43, 3, 0, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 43, 0, 0, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 43, 1, 0, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 43, 2, 0, 0, 0, OP_TRANS);
         introSequenceBitmap->DrawLayer(2, 37, 43, 4, 0, 0, 0, OP_OPAQUE);
         introSequenceBitmap->FastCombo(2, 112, 0, 4632, 2, OP_OPAQUE);
         introSequenceBitmap->FastCombo(2, 128, 0, 4632, 2, OP_OPAQUE);
         introSequenceBitmap->FastCombo(2, 120, 120, 6731, 0, OP_OPAQUE);

         introSequenceBitmap->DrawLayer(2, 37, 44, 3, 256, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 44, 0, 256, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 44, 1, 256, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 44, 2, 256, 0, 0, OP_TRANS);
         introSequenceBitmap->DrawLayer(2, 37, 44, 4, 256, 0, 0, OP_OPAQUE);

         introSequenceBitmap->Blit(2, RT_SCREEN, panPosition, 0, 512, 168, 0, 0, 512, 168, 0, 0, 0, BITDX_NORMAL, 0, true);

         Waitframe();
      }

      // Panning right
      until(panPosition == 100) {
         disableLink();
         panPosition += 6;

         introSequenceBitmap->DrawLayer(2, 37, 43, 3, 0, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 43, 0, 0, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 43, 1, 0, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 43, 2, 0, 0, 0, OP_TRANS);
         introSequenceBitmap->DrawLayer(2, 37, 43, 4, 0, 0, 0, OP_OPAQUE);
         introSequenceBitmap->FastCombo(2, 112, 0, 4632, 2, OP_OPAQUE);
         introSequenceBitmap->FastCombo(2, 128, 0, 4632, 2, OP_OPAQUE);
         introSequenceBitmap->FastCombo(2, 120, 120, 6731, 0, OP_OPAQUE);

         introSequenceBitmap->DrawLayer(2, 37, 44, 3, 256, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 44, 0, 256, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 44, 1, 256, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 44, 2, 256, 0, 0, OP_TRANS);
         introSequenceBitmap->DrawLayer(2, 37, 44, 4, 256, 0, 0, OP_OPAQUE);

         introSequenceBitmap->Blit(2, RT_SCREEN, panPosition, 0, 512, 168, 0, 0, 512, 168, 0, 0, 0, BITDX_NORMAL, 0, true);

         Waitframe();
      }

      this->X = 260;
      this->Y = 64;

      // Panning right
      until(panPosition == 180) {
         disableLink();
         panPosition += 8;

         if (panPosition > 170)
            this->X -= 8;

         introSequenceBitmap->DrawLayer(2, 37, 43, 3, 0, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 43, 0, 0, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 43, 1, 0, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 43, 2, 0, 0, 0, OP_TRANS);
         introSequenceBitmap->DrawLayer(2, 37, 43, 4, 0, 0, 0, OP_OPAQUE);
         introSequenceBitmap->FastCombo(2, 112, 0, 4632, 2, OP_OPAQUE);
         introSequenceBitmap->FastCombo(2, 128, 0, 4632, 2, OP_OPAQUE);
         introSequenceBitmap->FastCombo(2, 120, 120, 6731, 0, OP_OPAQUE);

         introSequenceBitmap->DrawLayer(2, 37, 44, 3, 256, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 44, 0, 256, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 44, 1, 256, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 44, 2, 256, 0, 0, OP_TRANS);
         introSequenceBitmap->DrawLayer(2, 37, 44, 4, 256, 0, 0, OP_OPAQUE);

         introSequenceBitmap->Blit(2, RT_SCREEN, panPosition, 0, 512, 168, 0, 0, 512, 168, 0, 0, 0, BITDX_NORMAL, 0, true);

         Waitframe();
      }

      // Panning right
      until(panPosition == 230) {
         disableLink();
         panPosition += 5;
         this->X -= 5;

         introSequenceBitmap->DrawLayer(2, 37, 43, 3, 0, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 43, 0, 0, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 43, 1, 0, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 43, 2, 0, 0, 0, OP_TRANS);
         introSequenceBitmap->DrawLayer(2, 37, 43, 4, 0, 0, 0, OP_OPAQUE);
         introSequenceBitmap->FastCombo(2, 112, 0, 4632, 2, OP_OPAQUE);
         introSequenceBitmap->FastCombo(2, 128, 0, 4632, 2, OP_OPAQUE);
         introSequenceBitmap->FastCombo(2, 120, 120, 6731, 0, OP_OPAQUE);

         introSequenceBitmap->DrawLayer(2, 37, 44, 3, 256, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 44, 0, 256, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 44, 1, 256, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 44, 2, 256, 0, 0, OP_TRANS);
         introSequenceBitmap->DrawLayer(2, 37, 44, 4, 256, 0, 0, OP_OPAQUE);

         introSequenceBitmap->Blit(2, RT_SCREEN, panPosition, 0, 512, 168, 0, 0, 512, 168, 0, 0, 0, BITDX_NORMAL, 0, true);

         Waitframe();
      }

      // Panning right
      until(panPosition == 256) {
         disableLink();
         panPosition += 1;
         this->X -= 1;

         introSequenceBitmap->DrawLayer(2, 37, 43, 3, 0, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 43, 0, 0, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 43, 1, 0, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 43, 2, 0, 0, 0, OP_TRANS);
         introSequenceBitmap->DrawLayer(2, 37, 43, 4, 0, 0, 0, OP_OPAQUE);
         introSequenceBitmap->FastCombo(2, 112, 0, 4632, 2, OP_OPAQUE);
         introSequenceBitmap->FastCombo(2, 128, 0, 4632, 2, OP_OPAQUE);
         introSequenceBitmap->FastCombo(2, 120, 120, 6731, 0, OP_OPAQUE);

         introSequenceBitmap->DrawLayer(2, 37, 44, 3, 256, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 44, 0, 256, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 44, 1, 256, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 44, 2, 256, 0, 0, OP_TRANS);
         introSequenceBitmap->DrawLayer(2, 37, 44, 4, 256, 0, 0, OP_OPAQUE);

         introSequenceBitmap->Blit(2, RT_SCREEN, panPosition, 0, 512, 168, 0, 0, 512, 168, 0, 0, 0, BITDX_NORMAL, 0, true);

         Waitframe();
      }

      // Pausing on him
      for (int i = 0; i < 60; ++i) {
         disableLink();
         introSequenceBitmap->DrawLayer(2, 37, 44, 3, 256, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 44, 0, 256, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 44, 1, 256, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 44, 2, 256, 0, 0, OP_TRANS);
         introSequenceBitmap->DrawLayer(2, 37, 44, 4, 256, 0, 0, OP_OPAQUE);

         introSequenceBitmap->Blit(2, RT_SCREEN, panPosition, 0, 512, 168, 0, 0, 512, 168, 0, 0, 0, BITDX_NORMAL, 0, true);

         Waitframe();
      }

      int timer = 0;
      int yModifier = 0, xModifier = -1;

      // Panning back into boss room
      until(panPosition == 0) {
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

         introSequenceBitmap->DrawLayer(2, 37, 43, 3, 0, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 43, 0, 0, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 43, 1, 0, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 43, 2, 0, 0, 0, OP_TRANS);
         introSequenceBitmap->DrawLayer(2, 37, 43, 4, 0, 0, 0, OP_OPAQUE);
         introSequenceBitmap->FastCombo(2, 112, 0, 4632, 2, OP_OPAQUE);
         introSequenceBitmap->FastCombo(2, 128, 0, 4632, 2, OP_OPAQUE);
         introSequenceBitmap->FastCombo(2, 120, 120, 6731, 0, OP_OPAQUE);

         introSequenceBitmap->DrawLayer(2, 37, 44, 3, 256, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 44, 0, 256, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 44, 1, 256, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 44, 2, 256, 0, 0, OP_TRANS);
         introSequenceBitmap->DrawLayer(2, 37, 44, 4, 256, 0, 0, OP_OPAQUE);

         if (!(panPosition % 16) || panPosition == 254)
            Audio->PlaySound(121);

         introSequenceBitmap->Blit(2, RT_SCREEN, panPosition, 0, 512, 168, 0, 0, 512, 168, 0, 0, 0, BITDX_NORMAL, 0, true);

         EnemyWaitframe(this, data);
      }

      // Wait and Roars
      for (int i = 0; i < 60; ++i) {
         disableLink();
         introSequenceBitmap->DrawLayer(2, 37, 43, 3, 0, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 43, 0, 0, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 43, 1, 0, 0, 0, OP_OPAQUE);
         introSequenceBitmap->DrawLayer(2, 37, 43, 2, 0, 0, 0, OP_TRANS);
         introSequenceBitmap->DrawLayer(2, 37, 43, 4, 0, 0, 0, OP_OPAQUE);
         introSequenceBitmap->FastCombo(2, 112, 0, 4632, 2, OP_OPAQUE);
         introSequenceBitmap->FastCombo(2, 128, 0, 4632, 2, OP_OPAQUE);
         introSequenceBitmap->FastCombo(2, 120, 120, 6731, 0, OP_OPAQUE);

         introSequenceBitmap->Blit(2, RT_SCREEN, panPosition, 0, 512, 168, 0, 0, 512, 168, 0, 0, 0, BITDX_NORMAL, 0, true);

         Waitframe();
      }

      Audio->PlaySound(142);
      Hero->Invisible = false;

      introSequenceBitmap->Free();
      Audio->PlayEnhancedMusic("The Binding of Isaac - Divine Combat.ogg", 0);
   }

   void dropFlame(npc heads, int headOpenIndex, int eweaponStopper, int damage) {
      eweapon flame = CreateEWeaponAt(EW_SCRIPT1, heads[headOpenIndex]->X, heads[headOpenIndex]->Y + 8);
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

         eweapon oilBlob = FireAimedEWeapon(194, CenterX(this) - 8, CenterY(this) - 8, 0, 255, damage, 117, -1, EWF_UNBLOCKABLE | EWF_ROTATE);
         Audio->PlaySound(SFX_SQUISH);
         runEWeaponScript(oilBlob, Game->GetEWeaponScript("ArcingWeapon"), {-1, 0, AE_OIL_BLOB, damage});
         EnemyWaitframe(this, data, 5);
      }

      EnemyWaitframe(this, data, 60);
   }

   bool isHeadsDead(npc heads) {
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
} // namespace HazarondNamespace

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
         disableLink();

         CONFIG DMG_BOULDER = this->WeaponDamage;
         CONFIG DMG_ROCK = this->WeaponDamage / 2;
         CONFIG DMG_PEBBLE = this->WeaponDamage / 4;

         State state = STATE_NORMAL;
         State previousState = state;
         const int maxHp = this->HP;
         int timer;

         this->Dir = faceLink(this);

         until(this->Z == 0) Waitframe();

         Screen->Quake = 60;
         Audio->PlaySound(SFX_IMPACT_EXPLOSION);

         Waitframes(30);

         disableLink();

         unless(getScreenD(255)) {
            Screen->Message(805);
            setScreenD(255, true);
         }

         while (true) {
            if (this->HP <= 0)
               deathAnimation(this, 136);

            int randModifier = isDifficultyChange(this, maxHp) ? Rand(-90, 30) : Rand(-60, 60);

            if (++timer > 120 + randModifier) {
               timer = 0;
               int attackChoice = 0;

               if (Screen->NumNPCs() > 5) {
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

                  Waitframes(60);

                  eweapon rockProjectile = FireBigAimedEWeapon(196, CenterX(this) - 8, CenterY(this) - 8, 0, 255, DMG_BOULDER, 119, -1, EWF_UNBLOCKABLE, 2, 2);
                  Audio->PlaySound(SFX_LAUNCH_BOMBS);
                  runEWeaponScript(rockProjectile, Game->GetEWeaponScript("ArcingWeapon"), {-1, 0, AE_BOULDER_PROJECTILE, DMG_ROCK});
                  state = STATE_NORMAL;
                  break;
               }
               case STATE_SMALL_ROCKS_THROW: {
                  previousState = state;

                  Waitframes(30);

                  for (int i = 0; i < 60; ++i) {
                     if (this->HP <= 0)
                        deathAnimation(this, 136);

                     this->ScriptTile = this->OriginalTile + (this->Tile % 8) + 52;

                     unless(i % 20) {
                        eweapon rockProjectile = FireAimedEWeapon(195, CenterX(this) - 8, CenterY(this) - 8, 0, 255, DMG_ROCK, SPR_SMALL_ROCK, -1, EWF_UNBLOCKABLE | EWF_ROTATE);
                        Audio->PlaySound(SFX_LAUNCH_BOMBS);
                        runEWeaponScript(rockProjectile, Game->GetEWeaponScript("ArcingWeapon"), {-1, 0, AE_ROCK_PROJECTILE, DMG_PEBBLE});
                     }

                     Waitframe();
                  }

                  state = STATE_NORMAL;
                  break;
               }
               case STATE_RACCOON_THROW: {
                  previousState = state;

                  Waitframes(60);

                  for (int i = 0; i < 2; ++i) {
                     if (this->HP <= 0)
                        deathAnimation(this, 136);

                     Waitframes(5);

                     eweapon raccoonProjectile = FireAimedEWeapon(197, CenterX(this) - 8, CenterY(this) - 8, 0, 255, 1, 121, -1, EWF_UNBLOCKABLE | EWF_ROTATE_360);
                     Audio->PlaySound(SFX_LAUNCH_BOMBS);
                     runEWeaponScript(raccoonProjectile, Game->GetEWeaponScript("ArcingWeapon"), {-1, 0, AE_RACCOON_PROJECTILE});
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

                  do
                     Waitframe();
                  while (this->Z);

                  while (this->MoveAtAngle(angle, 4, SPW_NONE))
                     Waitframe();

                  this->Jump = 2;
                  Screen->Quake = 30;
                  Audio->PlaySound(SFX_IMPACT_EXPLOSION);

                  do
                     Waitframe();
                  while (this->Z);

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
      }
   }
} // namespace OvergrownRaccoonNamespace

namespace ServusMalusNamespace {
   using namespace EnemyNamespace;

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
         cmbLitTorch->Attribytes[0] = 32;

         mapdata mapData, template;

         this->X = -32;
         this->Y = -32;
         int maxHp = this->HP;

         Audio->PlayEnhancedMusic(NULL, 0);

         if (getScreenD(254))
            Audio->PlayEnhancedMusic("Bloodborne PSX - Cleric Beast.ogg", 0);

         until(getScreenD(254)) {
            int litTorchCount = 0;

            template = Game->LoadTempScreen(1);

            litTorchCount += <int>(template->ComboD[upperLeftTorchLoc] == litTorch);
            litTorchCount += <int>(template->ComboD[upperRightTorchLoc] == litTorch);
            litTorchCount += <int>(template->ComboD[lowerLeftTorchLoc] == litTorch);
            litTorchCount += <int>(template->ComboD[lowerRightTorchLoc] == litTorch);

            checkTorchBrightness(litTorchCount, cmbLitTorch);

            if (litTorchCount == 4) {
               torchesLit = true;
               setScreenD(254, true);
               commenceIntroCutscene(this, template, unlitTorch, cmbLitTorch, bigSummerBlowout, upperLeftTorchLoc, upperRightTorchLoc, lowerLeftTorchLoc, lowerRightTorchLoc, originalTile, attackingTile);

               Audio->PlayEnhancedMusic("Bloodborne PSX - Cleric Beast.ogg", 0);
               Screen->Message(806);
            }

            Waitframe();
         }

         this->X = 128;
         this->Y = 32;

         while (true) {
            this->Z = 20;
            this->CollDetection = false;
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
                        eweapon ewind = RunEWeaponScriptAt(EW_SCRIPT2, escr, ComboX(chosenTorch), ComboY(chosenTorch), {0, 60});
                        ewind->Unblockable = UNBLOCK_ALL;
                        ewind->UseSprite(128);
                        ewind->Damage = DMG_WIND;
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

               if ((Screen->NumNPCs() - 1) < maxEnemies && chosenTorch == 0)
                  --spawnTimer;

               Waitframe();
            }

            Audio->PlaySound(SFX_MC_BOUNDCHEST_ROAR2);

            this->CollDetection = true;
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
               if (this->HP <= maxHp * .3)
                  gettingDesperate = true;

               float percent = timer / START_TIMER;

               cmbLitTorch->Attribytes[0] = Lerp(24, 50, 1 - percent);

               if (this->HP <= 0)
                  deathAnimation(this, SFX_GOMESS_DIE);

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
               if (this->HP <= 0)
                  deathAnimation(this, 148);

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
               if (this->HP <= 0)
                  deathAnimation(this, 148);

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

   void commenceIntroCutscene(npc this, mapdata template, int unlitTorch, combodata cmbLitTorch, int bigSummerBlowout, int upperLeftTorchLoc, int upperRightTorchLoc, int lowerLeftTorchLoc, int lowerRightTorchLoc, int originalTile, int attackingTile) {
      int soldierLeftFast = 6715;
      int soldierUpStunned = 6714;
      int soldierUpLaying = 6709;
      int soldierUp = 6722;
      int soldierDown = 6723;
      int soldierLeft = 6726;
      int soldierRight = 6727;
      int servusFullStartingCombo = 6916;
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
         if (i % 4) {
            Screen->FastCombo(2, 112, 32, servusTransStartingCombo, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 32, servusTransStartingCombo + 1, 3, OP_OPAQUE);
            Screen->FastCombo(2, 112, 48, servusTransStartingCombo + 2, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 48, servusTransStartingCombo + 3, 3, OP_OPAQUE);
         }

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

         if (alternate) {
            Screen->FastCombo(2, 112, 32, servusFullStartingCombo, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 32, servusFullStartingCombo + 1, 3, OP_OPAQUE);
            Screen->FastCombo(2, 112, 48, servusFullStartingCombo + 2, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 48, servusFullStartingCombo + 3, 3, OP_OPAQUE);
         }
         else {
            Screen->FastCombo(2, 112, 32, servusTransStartingCombo, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 32, servusTransStartingCombo + 1, 3, OP_OPAQUE);
            Screen->FastCombo(2, 112, 48, servusTransStartingCombo + 2, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 48, servusTransStartingCombo + 3, 3, OP_OPAQUE);
         }

         Screen->FastCombo(2, 120, 80, soldierUp, 0, OP_OPAQUE);

         counter++;
         Waitframe();
      }

      Screen->Message(170);

      // Servus fully appears
      for (int i = 0; i < 60; ++i) {
         disableLink();

         Screen->FastCombo(2, 112, 32, servusFullStartingCombo, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 32, servusFullStartingCombo + 1, 3, OP_OPAQUE);
         Screen->FastCombo(2, 112, 48, servusFullStartingCombo + 2, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 48, servusFullStartingCombo + 3, 3, OP_OPAQUE);

         Screen->FastCombo(2, 120, 80, soldierUp, 0, OP_OPAQUE);

         Waitframe();
      }

      Screen->Message(172);

      // Buffer
      for (int i = 0; i < 60; ++i) {
         disableLink();

         Screen->FastCombo(2, 112, 32, servusFullStartingCombo, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 32, servusFullStartingCombo + 1, 3, OP_OPAQUE);
         Screen->FastCombo(2, 112, 48, servusFullStartingCombo + 2, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 48, servusFullStartingCombo + 3, 3, OP_OPAQUE);

         Screen->FastCombo(2, 120, 80, soldierUp, 0, OP_OPAQUE);

         if (i == 59)
            Screen->Message(174);

         Waitframe();
      }

      // Turns around
      for (int i = 0; i < 15; ++i) {
         disableLink();

         if (i < 8) {
            Screen->FastCombo(2, 112, 32, servusTurningStartingCombo, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 32, servusTurningStartingCombo + 1, 3, OP_OPAQUE);
            Screen->FastCombo(2, 112, 48, servusTurningStartingCombo + 2, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 48, servusTurningStartingCombo + 3, 3, OP_OPAQUE);
         }
         else {
            Screen->FastCombo(2, 112, 32, servusMovingUpStartingCombo, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 32, servusMovingUpStartingCombo + 1, 3, OP_OPAQUE);
            Screen->FastCombo(2, 112, 48, servusMovingUpStartingCombo + 2, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 48, servusMovingUpStartingCombo + 3, 3, OP_OPAQUE);
         }

         Screen->FastCombo(2, 120, 80, soldierUp, 0, OP_OPAQUE);

         Waitframe();
      }

      Screen->Message(177);

      // Turns around
      for (int i = 0; i < 15; ++i) {
         disableLink();

         if (i < 8) {
            Screen->FastCombo(2, 112, 32, servusMovingUpStartingCombo, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 32, servusMovingUpStartingCombo + 1, 3, OP_OPAQUE);
            Screen->FastCombo(2, 112, 48, servusMovingUpStartingCombo + 2, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 48, servusMovingUpStartingCombo + 3, 3, OP_OPAQUE);
         }
         else {
            Screen->FastCombo(2, 112, 32, servusFullStartingCombo, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 32, servusFullStartingCombo + 1, 3, OP_OPAQUE);
            Screen->FastCombo(2, 112, 48, servusFullStartingCombo + 2, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 48, servusFullStartingCombo + 3, 3, OP_OPAQUE);
         }

         Screen->FastCombo(2, 120, 80, soldierUp, 0, OP_OPAQUE);

         Waitframe();
      }

      // Servus about to charge
      for (int i = 0; i < 30; ++i) {
         disableLink();

         Screen->FastCombo(2, 112, 32, servusFullStartingCombo, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 32, servusFullStartingCombo + 1, 3, OP_OPAQUE);
         Screen->FastCombo(2, 112, 48, servusFullStartingCombo + 2, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 48, servusFullStartingCombo + 3, 3, OP_OPAQUE);

         Screen->FastCombo(2, 120, 80, soldierUp, 0, OP_OPAQUE);
         Waitframe();
      }

      // Servus charges at soldier
      for (int i = 0; i < 30; ++i) {
         disableLink();

         Screen->FastCombo(2, 112, 32 + i, servusAttackingStartingCombo, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 32 + i, servusAttackingStartingCombo + 1, 3, OP_OPAQUE);
         Screen->FastCombo(2, 112, 48 + i, servusAttackingStartingCombo + 2, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 48 + i, servusAttackingStartingCombo + 3, 3, OP_OPAQUE);

         Screen->FastCombo(2, 120, 80, soldierUp, 0, OP_OPAQUE);
         Waitframe();
      }

      Audio->PlaySound(144);

      // Soldier flies back
      int distanceTraveled = 2;

      until(distanceTraveled == 64) {
         disableLink();

         Screen->FastCombo(2, 112, 62, servusFullStartingCombo, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 62, servusFullStartingCombo + 1, 3, OP_OPAQUE);
         Screen->FastCombo(2, 112, 78, servusFullStartingCombo + 2, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 78, servusFullStartingCombo + 3, 3, OP_OPAQUE);

         Screen->FastCombo(2, 120, 80 + distanceTraveled, soldierUpStunned, 0, OP_OPAQUE);

         distanceTraveled += 2;
         Waitframe();
      }

      Audio->PlaySound(121);
      Screen->Quake = 20;
      setScreenD(253, true);

      // Buffer as soldier is against the wall
      for (int i = 0; i < 30; ++i) {
         disableLink();

         Screen->FastCombo(2, 112, 62, servusFullStartingCombo, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 62, servusFullStartingCombo + 1, 3, OP_OPAQUE);
         Screen->FastCombo(2, 112, 78, servusFullStartingCombo + 2, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 78, servusFullStartingCombo + 3, 3, OP_OPAQUE);

         Waitframe();
      }

      Screen->Message(179);

      // Link intervenes
      until(Hero->X >= 120) {
         disableLink();

         if (Hero->Y <= 96) {
            Hero->InputRight = true;
            Hero->InputDown = true;
         }
         else
            Hero->InputRight = true;

         Screen->FastCombo(2, 112, 62, servusFullStartingCombo, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 62, servusFullStartingCombo + 1, 3, OP_OPAQUE);
         Screen->FastCombo(2, 112, 78, servusFullStartingCombo + 2, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 78, servusFullStartingCombo + 3, 3, OP_OPAQUE);

         Waitframe();
      }

      Hero->Dir = DIR_UP;

      // Buffer as link just got in front of Servus
      for (int i = 0; i < 30; ++i) {
         disableLink();

         Screen->FastCombo(2, 112, 62, servusFullStartingCombo, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 62, servusFullStartingCombo + 1, 3, OP_OPAQUE);
         Screen->FastCombo(2, 112, 78, servusFullStartingCombo + 2, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 78, servusFullStartingCombo + 3, 3, OP_OPAQUE);

         Waitframe();
      }

      Screen->Message(180);

      // Buffer before Big Summer Blowout
      for (int i = 0; i < 30; ++i) {
         disableLink();

         Screen->FastCombo(2, 112, 62, servusFullStartingCombo, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 62, servusFullStartingCombo + 1, 3, OP_OPAQUE);
         Screen->FastCombo(2, 112, 78, servusFullStartingCombo + 2, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 78, servusFullStartingCombo + 3, 3, OP_OPAQUE);

         Waitframe();
      }

      // Servus moves up for the Big Summer Blowout
      for (int i = 0; i < 48; ++i) {
         disableLink();

         Screen->FastCombo(2, 112, 62 - i, servusMovingUpStartingCombo, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 62 - i, servusMovingUpStartingCombo + 1, 3, OP_OPAQUE);
         Screen->FastCombo(2, 112, 78 - i, servusMovingUpStartingCombo + 2, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 78 - i, servusMovingUpStartingCombo + 3, 3, OP_OPAQUE);

         Waitframe();
      }

      // Buffer before Big Summer Blowout
      for (int i = 0; i < 30; ++i) {
         disableLink();

         Screen->FastCombo(2, 112, 16, servusFullStartingCombo, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 16, servusFullStartingCombo + 1, 3, OP_OPAQUE);
         Screen->FastCombo(2, 112, 30, servusFullStartingCombo + 2, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 30, servusFullStartingCombo + 3, 3, OP_OPAQUE);

         Waitframe();
      }

      for (int i = 0; i < 60; ++i) {
         disableLink();

         Screen->FastCombo(2, 112, 14, servusAttackingStartingCombo, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 14, servusAttackingStartingCombo + 1, 3, OP_OPAQUE);
         Screen->FastCombo(2, 112, 30, servusAttackingStartingCombo + 2, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 30, servusAttackingStartingCombo + 3, 3, OP_OPAQUE);

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

         if (i < 10) {
            Screen->FastCombo(2, 112, 14, servusVanishingStartingCombo, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 14, servusVanishingStartingCombo + 1, 3, OP_OPAQUE);
            Screen->FastCombo(2, 112, 30, servusVanishingStartingCombo + 2, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 30, servusVanishingStartingCombo + 3, 3, OP_OPAQUE);
         }
         else {
            Screen->FastCombo(2, 112, 14, servusTransStartingCombo, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 14, servusTransStartingCombo + 1, 3, OP_OPAQUE);
            Screen->FastCombo(2, 112, 30, servusTransStartingCombo + 2, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 30, servusTransStartingCombo + 3, 3, OP_OPAQUE);
         }

         Waitframe();
      }
   }

   void checkTorchBrightness(int litTorchCount, combodata cmbLitTorch, int mode = 0) {
      switch (mode) {
         case 0:
            switch (litTorchCount) {
               case 0:
               case 1: {
                  cmbLitTorch->Attribytes[0] = 36;
                  return;
               }
               case 2: {
                  cmbLitTorch->Attribytes[0] = 40;
                  return;
               }
               case 3: {
                  cmbLitTorch->Attribytes[0] = 58;
                  return;
               }
               case 4: {
                  cmbLitTorch->Attribytes[0] = 64;
                  return;
               }
            }
            break;
         case 1:
            switch (litTorchCount) {
               case 0:
               case 1: {
                  cmbLitTorch->Attribytes[0] = 12;
                  return;
               }
               case 2: {
                  cmbLitTorch->Attribytes[0] = 16;
                  return;
               }
               case 3: {
                  cmbLitTorch->Attribytes[0] = 20;
                  return;
               }
               case 4: {
                  cmbLitTorch->Attribytes[0] = 24;
                  return;
               }
            }
            break;
      }
   }

   void spawnEnemy(npc this) {
      for (int i = 0; i < 30; ++i)
         Waitframe();

      Game->PlaySound(SFX_MIRROR_SHIELD_ABSORB_LOOP);

      for (int i = 0; i <= 30; ++i) {
         unless(i % 5) i < 15 ? this->Z-- : this->Z++;

         Waitframe();
      }

      this->Z = 20;

      for (int i = 0; i < 45; ++i)
         Waitframe();

      Game->PlaySound(SFX_SUMMON_MINE);

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
         if (this->HP <= 0)
            deathAnimation(this, SFX_GOMESS_DIE);

         int angle = Angle(this->X + 8, this->Y + 8, Hero->X, Hero->Y);
         this->OriginalTile = attackingTile;
         Audio->PlaySound(SFX_MC_BOUNDCHEST_ROAR2);

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
            if (this->HP <= 0)
               deathAnimation(this, 148);

            this->OriginalTile = originalTile;
            Waitframe();
         }
      }
   }

   void scytheThrow(npc this, int originalTile, int attackingTile, int unarmedTile, bool gettingDesperate, int damage) {
      Audio->PlaySound(SFX_MC_BOUNDCHEST_ROAR1);

      for (int i = 0; i < 30; ++i) {
         if (this->HP <= 0)
            deathAnimation(this, SFX_GOMESS_DIE);

         this->OriginalTile = attackingTile;
         Waitframe();
      }

      if (int escr = CheckEWeaponScript("BoomerangThrow")) {
         for (int i = 0; i < (gettingDesperate ? 2 : 1); i++) {
            if (this->HP <= 0)
               deathAnimation(this, SFX_GOMESS_DIE);

            if (i > 0)
               Audio->PlaySound(SFX_MC_BOUNDCHEST_ROAR1);

            this->OriginalTile = unarmedTile;

            eweapon scythe, scythe2;

            Audio->PlaySound(SFX_AXE2);

            scythe = RunEWeaponScriptAt(EW_SCRIPT3, escr, this->X, this->Y, {this, Hero->X - 8, Hero->Y - 8, 7, 1, 0});
            scythe->Damage = damage;
            scythe->UseSprite(125);
            scythe->Extend = 3;
            scythe->TileWidth = 2;
            scythe->TileHeight = 2;
            scythe->HitWidth = 24;
            scythe->HitHeight = 24;
            scythe->HitXOffset = 4;
            scythe->HitYOffset = 4;
            scythe->Unblockable = UNBLOCK_ALL;

            if (gettingDesperate) {
               scythe2 = RunEWeaponScriptAt(EW_SCRIPT3, escr, this->X, this->Y, {this, Hero->X - 8, Hero->Y - 8, 7, 1, 1});
               scythe2->Damage = damage;
               scythe2->UseSprite(125);
               scythe2->Extend = 3;
               scythe2->TileWidth = 2;
               scythe2->TileHeight = 2;
               scythe2->HitWidth = 24;
               scythe2->HitHeight = 24;
               scythe2->HitXOffset = 4;
               scythe2->HitYOffset = 4;
               scythe2->Unblockable = UNBLOCK_ALL;
            }

            while (scythe2->isValid() || scythe->isValid())
               Waitframe();

            for (int i = 0; i < 15; ++i) {
               if (this->HP <= 0)
                  deathAnimation(this, 148);

               this->OriginalTile = attackingTile;
               Waitframe();
            }
         }
      }

      for (int i = 0; i < 15; ++i) {
         if (this->HP <= 0)
            deathAnimation(this, SFX_GOMESS_DIE);

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
      int escr = CheckEWeaponScript("EwWindBlast");

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

      if (escr) {
         WindHandler.init();

         for (int i = 0; i < wc; ++i) {
            if (this->HP <= 0)
               deathAnimation(this, 136);

            eweapon ewind = RunEWeaponScriptAt(EW_SCRIPT2, escr, CenterX(this) - 8, CenterY(this) - 8);
            ewind->Angular = true;
            ewind->Angle = DegtoRad(WrapDegrees(angle + inc * i));
            ewind->Step = 250;
            ewind->UseSprite(128);
            ewind->Unblockable = UNBLOCK_ALL;
         }

         this->OriginalTile = originalTile;
      }
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
         if (Hero->Item[202])
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
} // namespace ServusMalusNamespace

// clang-format off
@Author("Moosh") 
npc script TurnedHylianElite {
   // clang-format on

   using namespace NPCAnim;
   using namespace NPCAnim::Legacy;

   enum Animations {
      WALKING,
      ATTACK
   };

   void run(int introMessage) {
      AnimHandler aptr = new AnimHandler(this);

      AddAnim(aptr, WALKING, 0, 4, 8, ADF_4WAY);
      AddAnim(aptr, ATTACK, 20, 2, 16, ADF_4WAY | ADF_NOLOOP);

      int maxHp = this->HP;
      Audio->PlayEnhancedMusic("OoT - Middle Boss.ogg", 0);

      unless(getScreenD(0)) {
         Screen->Message(introMessage);
         setScreenD(0, true);
      }

      while (true) {
         int movementDirection = Choose(90, -90);
         int attackCoolDown = 120;

         PlayAnim(this, WALKING);

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
                  sword1x1(this->X, this->Y, moveAngle - 90 + 15 * i, 16, 10252, 10, this->WeaponDamage + this->WeaponDamage * .33);
                  CustomWaitframe(this);
               }

               tooCloseBoiCounter = 0;
            }

            int angle = Angle(this->X + 8, this->Y + 8, Hero->X + 8, Hero->Y + 8) + movementDirection;
            this->MoveAtAngle(angle, this->Step / (gettingDesperate(this, maxHp) ? 75 : 100), SPW_NONE);
            --attackCoolDown;

            FaceLink(this);
            CustomWaitframe(this);
         }

         int moveAngle = Angle(this->X + 8, this->Y + 8, Hero->X + 8, Hero->Y + 8);
         int distance = Distance(this->X + 8, this->Y + 8, Hero->X + 8, Hero->Y + 8);
         int dashFrames = Max(2, (distance - 36) / 3);

         bool swordCollided;
         PlayAnim(this, ATTACK);

         Audio->PlaySound(SFX_IRON_KNUCKLE_ATTACK);

         for (int i = 0; i < dashFrames; ++i) {
            this->MoveAtAngle(moveAngle, this->Step / (gettingDesperate(this, maxHp) ? 20 : 25), SPW_NONE);
            FaceLink(this);

            if (i > dashFrames / 2)
               sword1x1(this->X, this->Y, moveAngle - 90, (i - dashFrames / 2) / (dashFrames / 2) * 16, 10252, 10, this->WeaponDamage * .4);

            CustomWaitframe(this);
         }

         Audio->PlaySound(SFX_IRON_KNUCKLE_ATTACK_SWIPE);
         distance = Distance(this->X + 8, this->Y + 8, Hero->X + 8, Hero->Y + 8);

         for (int i = 0; i <= 12 && !swordCollided; ++i) {
            this->MoveAtAngle(moveAngle, this->Step / (gettingDesperate(this, maxHp) ? 25 : 30), SPW_NONE);
            FaceLink(this);
            swordCollided = sword1x1Collision(this->X, this->Y, moveAngle - 90 + 15 * i, 16, 10252, 10, this->WeaponDamage);
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

   void CustomWaitframe(npc n) {
      if (n->HP <= 0) {
         PlayDeathAnim(n);
         n->Immortal = false;
      }

      Waitframe(n);
   }

   void CustomWaitframe(npc n, int frames) {
      for (int i = 0; i < frames; ++i)
         CustomWaitframe(n);
   }
}

namespace EgentemNamespace {
   using namespace NPCAnim;

   CONFIG ANIM_SPEED = 16;

   // Hammer
   CONFIG CMB_HAMMER = 7005;
   CONFIG CSET_HAMMER = 8;
   CONFIG SPIN_SPEED = 40;
   CONFIG TURN_SPEED = 2.5;

   // Pillars
   CONFIG D_LAUNCHED = 2;
   CONFIG D_NO_DIE = 3;
   CONFIG SPR_RISE = 136;
   CONFIG SPR_CRACK = 137;

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

      void run() {
         AnimHandler aptr = new AnimHandler(this);

         aptr->AddAnim(WALKING, 20, 4, ANIM_SPEED, ADF_4WAY);
         aptr->AddAnim(STANDING, 44, 1, ANIM_SPEED, ADF_4WAY);
         aptr->AddAnim(WALKING_SH, 0, 4, ANIM_SPEED, ADF_4WAY);
         aptr->AddAnim(STANDING_SH, 40, 1, ANIM_SPEED, ADF_4WAY);

         Egentem egentem = new Egentem(this);

         this->X = -32;
         this->Y = -32;
         int maxHp = this->HP;
         this->CollDetection = false;

         // Not yet activated Egentem yet
         until(getScreenD(31, 0x43, 0)) {
            this->X = -32;
            this->Y = -32;
            Waitframe();
         }

         // You already triggered his trap and failed to defeat him once
         if (getScreenD(31, 0x23, 0) && getScreenD(31, 0x43, 0)) {
            Audio->PlayEnhancedMusic("Dragon Quest IV - Boss Battle.ogg", 0);
            this->X = 120;
            this->Y = 128;
            this->Dir = DIR_UP;
            aptr->PlayAnim(STANDING_SH);
         }

         // You activated his triforce trap, do intro
         else if (!getScreenD(0)) {
            introCutscene(this);
            setScreenD(0, true);
         }

         closeShutters(this);
         this->CollDetection = true;

         for (int i = 0; i < 20; ++i)
            this->Defense[i] = NPCDT_QUARTERDAMAGE;

         this->Defense[NPCD_BRANG] = NPCDT_BLOCK;
         this->Defense[NPCD_WHISTLE] = NPCDT_IGNORE;

         int heroDistances[10];
         int heroActiveAItems[10];
         int heroActiveBItems[10];

         attackThrowHammers(this, egentem, 10, 15);

         while (true) {
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
               attackHammerEruption(this, egentem);
               attackThrowHammers(this, egentem, 5, 1);
            }

            if (numPillars() > 15) {
               aptr->PlayAnim(egentem->shieldHp ? WALKING : WALKING_SH);

               for (int i = 0; i < (numPillars() * .9); ++i)
                  attackJumpToPillar(this, egentem);
            }

            if (egentem->shieldHp > 0) {
               if (avgDistances > 48) {
                  attackHammerSpin(this, egentem);
                  attackThrowHammers(this, egentem, 5, 10);

                  for (int i = 0; i < numPillars() / 2; ++i)
                     attackJumpToPillar(this, egentem);
               }
               else if (meleeCount > 7) {
                  attackHammerSpin(this, egentem);
                  attackHammerEruption(this, egentem);
               }
               else {
                  attackThrowHammers(this, egentem, 15, 10);

                  for (int i = 0; i < numPillars() / 2; ++i)
                     attackJumpToPillar(this, egentem);
               }
            }
            else {
               if (avgDistances > 48) {
                  attackHammerSpin(this, egentem);
                  attackThrowHammers(this, egentem, 5, 10);

                  for (int i = 0; i < numPillars() / 2; ++i)
                     attackJumpToPillar(this, egentem);
               }
               else if (meleeCount > 7) {
                  attackHammerEruption(this, egentem);
                  attackHammerSpin(this, egentem);
                  attackHammerEruption(this, egentem);
                  attackThrowHammers(this, egentem, 5, 10);
               }
               else {
                  attackThrowHammers(this, egentem, 15, 10);

                  for (int i = 0; i < numPillars() / 2; ++i)
                     attackJumpToPillar(this, egentem);
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
      n->Immortal = true;
      n->CollDetection = false;
      n->Stun = 9999;

      int baseX = n->X + n->DrawXOffset;
      int baseY = (n->Y + n->DrawYOffset) - (n->Z + n->DrawZOffset);

      Audio->PlaySound(SFX_OOT_STALFOS_DIE);

      for (int i = 0; i < 45; i++) {
         unless(i % 3) {
            lweapon explosion = Screen->CreateLWeapon(LW_BOMBBLAST);
            explosion->X = baseX + RandGen->Rand(16 * n->TileWidth) - 8;
            explosion->Y = baseY + RandGen->Rand(16 * n->TileHeight) - 8;
            explosion->CollDetection = false;
         }
         Waitframes(5);
      }

      openShutters();

      char32 areaMusic[256];
      Game->GetDMapMusicFilename(Game->GetCurDMap(), areaMusic);
      Audio->PlayEnhancedMusic(areaMusic, 0);

      for (int i = Screen->NumEWeapons(); i >= 1; i--) {
         eweapon e = Screen->LoadEWeapon(i);
         e->Remove();
      }

      for (int i = Screen->NumNPCs(); i >= 1; i--) {
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
            egentem->shieldHp -= weapon->Damage * 2; //(* 2)makes this compatible with jank

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

   void closeShutters(npc this) {
      while (Hero->Y < 16) {
         disableLink();
         Hero->InputDown = true;
         Waitframe(this);
      }

      mapdata md = Game->LoadTempScreen(1);
      Audio->PlaySound(SFX_SHUTTER_CLOSE);

      md->ComboD[7] = 6974;
      md->ComboD[8] = 6974;
      md->ComboD[167] = 6972;
      md->ComboD[168] = 6972;
   }

   void openShutters() {
      mapdata md = Game->LoadTempScreen(1);
      Audio->PlaySound(SFX_SHUTTER_OPEN);

      md->ComboD[7] = 0;
      md->ComboD[8] = 0;
      md->ComboD[167] = 0;
      md->ComboD[168] = 0;

      setScreenD(1, true);
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

      Screen->Message(337);
      Waitframe();
      hammerFrame(this, 0, 0, xy);
      Screen->Message(807);
      Audio->PlayEnhancedMusic("Dragon Quest IV - Boss Battle.ogg", 0);
      Waitframe();

      setScreenD(31, 0x23, 0, true);

      aptr->PlayAnim(STANDING_SH);
   }

   void hammerAnimHoldUp(npc this, Coordinates xy, int frames = 20) {
      for (int i = 0; i < frames; ++i) {
         if (this->HP <= 0)
            break;

         hammerFrame(this, 0, this->WeaponDamage, xy);
         Waitframe(this);
      }
   }

   void hammerAnimSwing(npc this, Coordinates xy) {
      for (int i = 0; i < 4; ++i) {
         if (this->HP <= 0)
            break;

         hammerFrame(this, 1, this->WeaponDamage, xy);
         Waitframe(this);
      }

      hammerFrame(this, 2, this->WeaponDamage, xy, true);

      if (this->HP > 0)
         Audio->PlaySound(SFX_HAMMER);
   }

   void hammerAnimSmash(npc this, Coordinates xy, int frames = 30) {
      for (int i = 0; i < frames; ++i) {
         if (this->HP <= 0)
            break;

         hammerFrame(this, 2, this->WeaponDamage, xy);

         if (i == 0) {
            if (int escr = CheckEWeaponScript("HammerImpactEffect")) {
               eweapon weap = RunEWeaponScriptAt(EW_SCRIPT10, escr, xy->X, xy->Y, {49852});
               weap->ScriptTile = TILE_INVIS;
            }
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
         eweapon hammer = FireEWeapon(EW_SCRIPT10, x, y, 0, 0, damage, 0, 0, EWF_UNBLOCKABLE);
         hammer->ScriptTile = TILE_HAMMER + 3 * this->Dir + frame;
         hammer->CSet = CSET_HAMMER;
         hammer->Timeout = 2;

         if (frame < 2)
            hammer->CollDetection = false;
      }

      xy->X = x;
      xy->Y = y;
   }

   void attackHammerSpin(npc this, Egentem egentem) {
      AnimHandler aptr = GetAnimHandler(this);
      int spinDir = Choose(-1, 1);
      int moveAngle = Angle(this->X, this->Y, Hero->X, Hero->Y) + 30 * spinDir;
      int facingAngle = moveAngle;

      this->Dir = AngleDir4(facingAngle);
      playAnim(aptr, egentem, STANDING);
      eweapon hitbox;

      // Holding hammer to some side
      for (int i = 0; i < 45; ++i) {
         hitbox = sword1x1Persistent(hitbox, this->X, this->Y, facingAngle + spinDir * 90, 16, CMB_HAMMER, CSET_HAMMER, this->WeaponDamage * 2);
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

         hitbox = sword1x1Persistent(hitbox, this->X, this->Y, facingAngle + spinDir * 90, 16, CMB_HAMMER, CSET_HAMMER, this->WeaponDamage * 2);

         int hitId = Hero->HitBy[HIT_BY_EWEAPON];

         if (hitId) {
            eweapon hitLink = Screen->LoadEWeapon(hitId);

            if (hitLink->isValid() && hitbox == hitLink) {
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
            hitbox = sword1x1Persistent(hitbox, this->X, this->Y, facingAngle + spinDir * 90, 12, CMB_HAMMER, CSET_HAMMER, this->WeaponDamage * 2);
            EgentemWaitframe(this, egentem);
         }
      }

      playAnim(aptr, egentem, WALKING);
   }

   void attackHammerEruption(npc this, Egentem egentem) {
      CONFIG D_ERUPT = 7;
      AnimHandler aptr = GetAnimHandler(this);
      Coordinates xy = new Coordinates();
      int shockwaveSlot = Game->GetEWeaponScript("ShockWave");
      FaceLink(this);

      playAnim(aptr, egentem, STANDING);

      hammerAnimHoldUp(this, xy, 15);
      hammerAnimSwing(this, xy);

      int offset = Rand(360);

      for (int i = 0; i < 8; ++i) {
         eweapon wave = RunEWeaponScriptAt(EW_SCRIPT10, shockwaveSlot, xy->X, xy->Y, {137, SFX_IMPACT_EXPLOSION, 8, SFX_POWDER_KEG_BLAST, 136, 12, offset + i * 45, false});
         wave->Damage = this->WeaponDamage;
         wave->Unblockable = UNBLOCK_ALL;
      }

      hammerAnimSmash(this, xy, 30);

      int angle = Angle(Hero->X, Hero->Y, this->X, this->Y);

      playAnim(aptr, egentem, WALKING);

      for (int i = 0; i < 30; ++i) {
         this->MoveAtAngle(angle, 3, SPW_NONE);
         EgentemWaitframe(this, egentem);
      }

      FaceLink(this);
      playAnim(aptr, egentem, STANDING);

      hammerAnimHoldUp(this, xy, 8);
      hammerAnimSwing(this, xy);

      for (int i = Screen->NumEWeapons(); i > 0; --i) {
         eweapon e = Screen->LoadEWeapon(i);

         if (e->Script == shockwaveSlot)
            e->InitD[D_ERUPT] = true;
      }

      hammerAnimSmash(this, xy);

      delete xy;
   }

   void attackThrowHammers(npc this, Egentem egentem, int hammerCount, int hammerThrowDelay) {
      int angle = Angle(Hero->X, Hero->Y, this->X, this->Y);
      FaceLink(this);

      for (int i = 0; i < 30; ++i) {
         sword1x1(this->X, this->Y, angle, 16, CMB_HAMMER, CSET_HAMMER, this->WeaponDamage * 1.25);
         EgentemWaitframe(this, egentem);
      }

      for (int i = 0; i < hammerCount; ++i) {
         Audio->PlaySound(SFX_SWORD);
         FaceLink(this);

         for (int j = 0; j < 9; ++j) {
            sword1x1(this->X, this->Y, angle + j * 20, 16, CMB_HAMMER, CSET_HAMMER, this->WeaponDamage * 1.25);
            EgentemWaitframe(this, egentem);
         }

         eweapon hammer = FireAimedEWeapon(EW_SCRIPT10, this->X + VectorX(16, angle + 180), this->Y + VectorY(16, angle + 180), 0, 300, this->WeaponDamage * 1.25, 134, -1, EWF_UNBLOCKABLE | EWF_ROTATE);
         runEWeaponScript(hammer, Game->GetEWeaponScript("ArcingWeapon"), {-1, 0, AE_EGENTEM_HAMMER});

         Waitframes(hammerThrowDelay);
      }
   }

   void attackJumpToPillar(npc this, Egentem egentem) {
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
            sword1x1(this->X, this->Y, anglePillar - 90 + i * 20, 16, CMB_HAMMER, CSET_HAMMER, this->WeaponDamage * 1.5);

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

      for (int i = Screen->NumEWeapons(); i > 0; --i) {
         eweapon e = Screen->LoadEWeapon(i);

         if (e->Script == slot && !e->InitD[D_LAUNCHED] && e->CollDetection)
            ++count;
      }

      return count;
   }

   eweapon findPillar(npc this) {
      int slot = Game->GetEWeaponScript("EgentemPillar");
      eweapon closest;
      int closestDistance = 1000;

      for (int i = Screen->NumEWeapons(); i > 0; --i) {
         eweapon e = Screen->LoadEWeapon(i);

         if (e->Script == slot && !e->InitD[D_LAUNCHED] && e->CollDetection) {
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

      void run(int delay, int upTime, bool launched, bool noDie) {
         if (Screen->isSolid(this->X + 8, this->Y + 8))
            this->Remove();

         this->Behind = true;
         this->CollDetection = false;
         this->UseSprite(SPR_CRACK);

         Waitframes(delay);

         this->Behind = false;
         this->Extend = EXT_NORMAL;
         this->TileHeight = 2;
         this->DrawYOffset = -16;
         this->HitYOffset = -16;
         this->HitHeight = 32;
         this->CollDetection = true;
         this->UseSprite(SPR_RISE);
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
            this->CollDetection = false;
            this->UseSprite(SPR_ROTATING_PILLAR);
            this->Angular = true;
            this->Damage = 6;

            int angle = Angle(this->X, this->Y, Hero->X, Hero->Y);

            for (int i = 0; i < 18; ++i) {
               this->Rotation = WrapDegrees(angle + i * 20);
               this->DeadState = WDS_ALIVE;

               Waitframe();
            }

            this->DegAngle = angle;
            this->Step = 450;

            while (true) {
               if (wallCollision(this)) {
                  eweapon explosion = CreateEWeaponAt(EW_BOMBBLAST, this->X, this->Y);
                  explosion->Damage = this->Damage;
               }

               this->Rotation = this->DegAngle;
               rotatingHitbox(this);
               Waitframe();
            }
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
      }
   }

   ffc script EgentumGotcha {
      void run() {
         if (getScreenD(31, 0x33, 1)) {
            mapdata mapData = Game->LoadTempScreen(0);
            mapData->ComboD[39] = 0;
            mapData->ComboD[40] = 0;
         }

         until(Screen->SecretsTriggered()) Waitframe();

         Audio->PlayEnhancedMusic(NULL, 0);
         setScreenD(0, true);
      }
   }
} // namespace EgentemNamespace

namespace LatrosNamespace {
   using namespace EnemyNamespace;
   using namespace NPCAnim;

   CONFIG CMB_BLUE_POTION = 6952;
   CONFIG CMB_RED_POTION = 6956;
   CONFIG CMB_PURPLE_POTION = 6960;

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
                  attackWithItem(this, latros, validItem);
               }
               else {
                  charge(this, latros);

                  if (Screen->NumItems())
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
                  attackWithItem(this, latros, validItem);
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
         this->CollDetection = false;

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

            if (Game->LoadItemData(itemA)->Type == IC_POTION)
               clearPotions(itemA);
            if (Game->LoadItemData(itemB)->Type == IC_POTION)
               clearPotions(itemB);

            stolen = true;
         }

         --chargingCounter;
         LatrosWaitframe(this, latros);
      }

      this->CollDetection = true;
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

   void clearCandles(int itemId) {
      switch (itemId) {
         case ITEM_CANDLE2: Hero->Item[ITEM_CANDLE1] = false;
      }
   }

   void clearPotions(int itemId) {
      switch (itemId) {
         case ITEM_POTION3: Hero->Item[ITEM_POTION2] = false;
         case I_POTION2: Hero->Item[ITEM_POTION1] = false;
      }
   }

   void seekItem(npc this, Latros latros) {
      while (Screen->NumItems() && !itemsUpForGrabs())
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

      for (int i = Screen->NumItems(); i > 0; --i) {
         itemsprite itm = Screen->LoadItem(i);

         if (itm->Z == 0)
            ++count;
      }

      return count;
   }

   itemsprite getClosestItem(npc this) {
      itemsprite closestItem;
      int closestDist = 1000;

      for (int i = Screen->NumItems(); i > 0; --i) {
         itemsprite itm = Screen->LoadItem(i);
         int dist = Distance(itm->X, itm->Y, this->X, this->Y) + Rand(8);

         if (dist < closestDist) {
            closestDist = dist;
            closestItem = itm;
         }
      }

      return closestItem;
   }

   void attackWithItem(npc this, Latros latros, int itemId) {
      int potionCombo;

      itemdata id = Game->LoadItemData(itemId);
      spritedata spr = Game->LoadSpriteData(id->Sprites[0]);

      switch (itemId) {
         case ITEM_SWORD1: {
            for (int i = 0; i < 3; ++i) {
               if (swordSlash(this, latros, spr->Tile + 1, spr->CSet, ITEM_SWORD1))
                  break;
            }
            break;
         }
         case ITEM_SWORD2: {
            for (int i = 0; i < 3; ++i) {
               if (swordSlash(this, latros, spr->Tile + 1, spr->CSet, ITEM_SWORD2))
                  break;
            }
            break;
         }
         case ITEM_SWORD3: {
            for (int i = 0; i < 3; ++i) {
               if (swordSlash(this, latros, spr->Tile + 1, spr->CSet, ITEM_SWORD3))
                  break;
            }
            break;
         }
         case ITEM_BRANG1:
         case ITEM_BRANG2:
         case ITEM_BRANG3: {
            throwBoomerang(this, latros, id);
            break;
         }
         case ITEM_BOMB1: {
            Audio->PlaySound(SFX_OOT_BIG_DEKU_BABA_LUNGE);
            Waitframes(30);

            for (int i = 0; i < 5; ++i) {
               // if (int weaponId = latros->owner->HitBy[HIT_BY_LWEAPON]) {
               // if (latros->numItems && weaponId) {
               // --latros->hitCounter;
               // latros->dropItem(I_BOMB);
               // break;
               // }
               // }

               LatrosWaitframe(this, latros, 12);
               eweapon bomb = FireAimedEWeapon(EW_BOMB, this->X, this->Y, 0, 325, 4, -1, -1, EWF_UNBLOCKABLE | EWF_ROTATE);
               Audio->PlaySound(SFX_LAUNCH_BOMBS);
               runEWeaponScript(bomb, Game->GetEWeaponScript("ArcingWeapon"), {-1, 0, AE_BOMB_EXPLOSION});
               LatrosWaitframe(this, latros, 6);
            }

            break;
         }
         case ITEM_ARROW1:
         case ITEM_ARROW2: {
            for (int i = 0; i < 5; ++i) {
               // if (int weaponId = latros->owner->HitBy[HIT_BY_LWEAPON]) {
               // if (latros->numItems && weaponId) {
               // --latros->hitCounter;
               // latros->dropItem(I_ARROW1);
               // break;
               // }
               // }

               LatrosWaitframe(this, latros, 16);
               eweapon arrow = FireAimedEWeapon(EW_ARROW, this->X, this->Y, 0, 350, 2, -1, -1, EWF_UNBLOCKABLE | EWF_ROTATE);
               Audio->PlaySound(SFX_ARROW);
               runEWeaponScript(arrow, Game->GetEWeaponScript("ArcingWeapon"), {-1, 0, 0});
            }
            break;
         }
         case ITEM_CANDLE2: {
            flameChase(this, latros, ITEM_CANDLE2);
            break;
         }
         case ITEM_CANDLE1: {
            flameChase(this, latros, ITEM_CANDLE1);
            break;
         }
         case ITEM_HAMMER1: {
            for (int i = 0; i < 5; ++i) {
               // if (int weaponId = latros->owner->HitBy[HIT_BY_LWEAPON]) {
               // if (latros->numItems && weaponId) {
               // --latros->hitCounter;
               // latros->dropItem(I_HAMMER);
               // break;
               // }
               // }

               int angle = Angle(this->X, this->Y, Hero->X, Hero->Y);
               FaceLink(this);
               eweapon hammer = FireAimedEWeapon(EW_SCRIPT10, this->X + VectorX(16, angle + 180), this->Y + VectorY(16, angle + 180), 0, 325, this->WeaponDamage * 1.25, 134, -1, EWF_UNBLOCKABLE | EWF_ROTATE);
               runEWeaponScript(hammer, Game->GetEWeaponScript("ArcingWeapon"), {-1, 0, AE_ROCK_PROJECTILE});
               LatrosWaitframe(this, latros, 16);
            }

            break;
         }
         case ITEM_OCARINA1: {
            bool droppedOcarina = false;

            for (int i = 0; i < 180 && !droppedOcarina; ++i) {
               unless(i) Audio->PlaySound(SFX_WHISTLE);

               unless(latros->hasItem(ITEM_OCARINA1)) droppedOcarina = true;

               // if (int weaponId = latros->owner->HitBy[HIT_BY_LWEAPON]) {
               // if (latros->numItems && weaponId) {
               // --latros->hitCounter;
               // latros->dropItem(I_WHISTLE);
               // Audio->EndSound(SFX_WHISTLE);
               // droppedOcarina = true;
               // break;
               // }
               // }

               this->Dir = Hero->X < this->X ? DIR_LEFT : DIR_RIGHT;
               Screen->FastCombo(3, this->X + (this->Dir == DIR_LEFT ? -4 : 6), this->Y + 6, this->Dir == DIR_LEFT ? 6876 : 6877, 0, OP_OPAQUE);
               LatrosWaitframe(this, latros);
            }
            unless(droppedOcarina) {
               Audio->PlaySound(SFX_STALCHILD_ATTACK);
               latros->dropItem(I_WHISTLE);
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

   void throwBoomerang(npc this, Latros latros, itemdata id) {
      FaceLink(this);
      eweapon boomer = FireEWeaponAngle(EW_SCRIPT10, this->X, this->Y, DegtoRad(Angle(this->X, this->Y, Hero->X, Hero->Y)), 300, this->WeaponDamage, id->Sprites[0], 0, Game->GetEWeaponScript("Boomerang"), {48, 10, 0, this, 6});

      while (boomer->isValid()) {
         // if (int weaponId = latros->owner->HitBy[HIT_BY_LWEAPON]) {
         // if (latros->numItems && weaponId) {
         // --latros->hitCounter;
         // latros->dropItem(I_BRANG2);
         // boomer->Remove();
         // break;
         // }
         // }

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

   bool swordSlash(npc this, Latros latros, int tile, int cset, int sword) {
      int moveAngle = Angle(this->X, this->Y, Hero->X, Hero->Y);
      int dashFrames = 12;
      int damage = 6;

      for (int i = 0; i < 15; ++i) {
         unless(latros->hasItem(sword)) return true;
         // if (int weaponId = latros->owner->HitBy[HIT_BY_LWEAPON]) {
         // if (latros->numItems && weaponId) {
         // --latros->hitCounter;
         // latros->dropItem(sword);
         // clearSwords(sword);
         // return true;
         // }
         // }

         LatrosWaitframe(this, latros);
      }

      for (int i = 0; i < dashFrames; ++i) {
         unless(latros->hasItem(sword)) return true;
         // if (int weaponId = latros->owner->HitBy[HIT_BY_LWEAPON]) {
         // if (latros->numItems && weaponId) {
         // --latros->hitCounter;
         // latros->dropItem(sword);
         // clearSwords(sword);
         // return true;
         // }
         // }

         FaceLink(this);
         this->MoveAtAngle(moveAngle, 3, 0);

         if (i > dashFrames / 2)
            sword1x1Tile(this->X, this->Y, moveAngle - 90, (i - dashFrames / 2) / (dashFrames / 2) * 16, tile, cset, damage);

         LatrosWaitframe(this, latros);
      }

      Audio->PlaySound(SFX_SWORD);

      for (int i = 0; i <= 12; ++i) {
         unless(latros->hasItem(sword)) return true;
         // if (int weaponId = latros->owner->HitBy[HIT_BY_LWEAPON]) {
         // if (latros->numItems && weaponId) {
         // --latros->hitCounter;
         // latros->dropItem(sword);
         // clearSwords(sword);
         // return true;
         // }
         // }

         FaceLink(this);
         this->MoveAtAngle(moveAngle, 3, 0);
         sword1x1Tile(this->X, this->Y, moveAngle - 90 + 15 * i, 16, tile, cset, damage);
         LatrosWaitframe(this, latros);
      }

      return false;
   }

   void flameChase(npc this, Latros latros, int itemId) {
      int vectorX, vectorY;

      for (int i = 0; i < 120; ++i) {
         FaceLink(this);
         vectorX = lazyChase(vectorX, this->X + 8, Hero->X - 8, .05, Hero->Step / 75);
         vectorY = lazyChase(vectorY, this->Y + 8, Hero->Y - 8, .05, Hero->Step / 75);
         this->MoveXY(vectorX, vectorY, SPW_NONE);

         int fireSprite;
         int damage;

         switch (itemId) {
            case ITEM_CANDLE1: {
               fireSprite = SPR_FLAME_WAX;
               damage = 4;
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
            flame->Damage = 4;
            flame->UseSprite(fireSprite);

            Audio->PlaySound(SFX_FIRE);
         }

         LatrosWaitframe(this, latros);
      }
   }

   void latrosDeathAnimation(npc n, int deathSound, Latros latros) {
      n->Immortal = true;
      n->CollDetection = false;
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
            explosion->CollDetection = false;
         }

         unless(i % 9) latros->dropItem(latros->stolenItems[dropCount++]);

         Waitframes(5);
      }

      char32 areaMusic[256];
      Game->GetDMapMusicFilename(Game->GetCurDMap(), areaMusic);
      Audio->PlayEnhancedMusic(areaMusic, 0);

      for (int i = Screen->NumNPCs(); i >= 1; i--) {
         npc n = Screen->LoadNPC(i);
         n->Remove();
      }

      n->Immortal = false;
      n->HP = 0;
   }
} // namespace LatrosNamespace

namespace Quickknife {
   using namespace EnemyNamespace;

   npc script Quickknife {
      void run() {
         
      }

   }

}

// clang-format off
@Author("Deathrider365") 
npc script Demonwall {
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
