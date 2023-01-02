///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~~~~~~The Terror of Necromancy Bosses~~~~~~~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

@Author("Moosh, modified by Deathrider365")
npc script Leviathan {
   using namespace LeviathanNamespace;

   CONFIG ATTACK_WATERFALL = 0;
   CONFIG ATTACK_WATERBEAM = 1;
   CONFIG ATTACK_WATERCANNON = 2;
   CONFIG ATTACK_SIDE_SWIPE = 3;

   CONFIG DIFFICULTY_STAGE_1 = 0;
   CONFIG DIFFICULTY_STAGE_2 = 1;
   CONFIG DIFFICULTY_STAGE_3 = 2;

   const int VARS_HEADNPC = 0;
   const int VARS_HEAD_CENTERX = 1;
   const int VARS_HEAD_CENTERY = 2;
   const int VARS_FLIP = 3;
   const int VARS_FLASHTIMER = 5;
   const int VARS_INITHP = 6;
   const int VARS_BODYHP = 8;

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
         
         if(i % 40 == 0) {
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
               Screen->Message(400);
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
      
      while(true) {
         attack = attackChoice(this, vars);
         
         int riseAnim = 120;
         
         if (changeInDifficulty(this, vars) == DIFFICULTY_STAGE_2) {
            riseAnim = 60;		
            LEVIATHAN_WATERCANNON_DMG = 70;
            LEVIATHAN_BURSTCANNON_DMG = 40;
            LEVIATHAN_WATERFALL_DMG = 60;
         }
         else if(changeInDifficulty(this, vars) == DIFFICULTY_STAGE_3) {
            riseAnim = 30;		
            LEVIATHAN_WATERCANNON_DMG = 80;
            LEVIATHAN_BURSTCANNON_DMG = 50;
            LEVIATHAN_WATERFALL_DMG = 70;
         }
            
         switch(attack) {
            case ATTACK_WATERFALL:
               vars[VARS_FLIP] = Hero->X + 8 < 128 ? 0 : 1;
               int difficultyLevel = changeInDifficulty(this, vars);
               int flipModifier;
               int centerOnLinkX;
               
               if (Hero->X <= 32){
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
            case ATTACK_WATERBEAM:
               int risingX = Hero->X <= 64 ? Rand(32, 144) : Rand(-48, 80);
               int xModifier = risingX + Choose(-8, 8);
               
               if (risingX < 49) {
                  if (Hero->X > this->X + 72)
                     vars[VARS_FLIP] = 0;
                  else 
                     vars[VARS_FLIP] = 1;
               } else {
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
               
               for(int i = 0; i < 32; ++i) {
                  switch(changeInDifficulty(this, vars)) {
                     case DIFFICULTY_STAGE_2:
                        angle = turnToAngle(angle, Angle(risingX, centerY, Hero->X + 8, Hero->Y + 8), 1.75);
                        break;
                     case DIFFICULTY_STAGE_3:
                        angle = turnToAngle(angle, Angle(risingX, centerY, Hero->X + 8, Hero->Y + 8), 2.25);
                        break;
                     case DIFFICULTY_STAGE_1:
                        break;
                  }
                  
                  Audio->PlaySound(SFX_SHOT);
                  
                  for(int j = 0; j < 4; ++j) {
                     eweapon waterBall = CreateEWeaponAt(EW_SCRIPT1, risingX - 8, centerY - 8);
                     waterBall->Damage = LEVIATHAN_WATERCANNON_DMG;
                     waterBall->UseSprite(SPR_WATERBALL);
                     waterBall->Angular = true;
                     waterBall->Angle = DegtoRad(angle);
                     waterBall->Dir = AngleDir4(angle);
                     waterBall->Step = 300;
                     waterBall->Script = Game->GetEWeaponScript("LeviathanSignWave");
                     waterBall->InitD[0] = wSizes[j]         * (0.5 + 0.5 * (i / 32));
                     waterBall->InitD[1] = wSpeeds[j];
                     waterBall->InitD[2] = true;
                  }
                  
                  LeviathanWaitframe(this, vars, 4);
               }
               
               glide(this, vars, xModifier, 32, xModifier, 112, 20);
               Audio->PlaySound(SFX_SPLASH);
               splash(this->X + 64, 100);
               break;
            case ATTACK_WATERCANNON:
               int risingX = Hero->X <= 64 ? Rand(32, 144) : Rand(-48, 80);
               int xModifier = risingX + Choose(-8, 8);
               
               if (risingX < 49) {
                  if (Hero->X > this->X + 72)
                     vars[VARS_FLIP] = 0;
                  else 
                     vars[VARS_FLIP] = 1;
               } else {
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
                  case DIFFICULTY_STAGE_2:
                     numBursts = 5;
                     burstDelay = 24;
                     break;
                  case DIFFICULTY_STAGE_3:
                     numBursts = 7;
                     burstDelay = 12;
                     break;
                  case DIFFICULTY_STAGE_1:
                     break;
               }
               
               for (int i = 0; i < numBursts; ++i) {
                  chargeAttack(this, vars, risingX, centerY, 20, 16);
                  
                  int angle = Angle(risingX, centerY, Hero->X + 8, Hero->Y + 8) + Rand(-20, 20);
                  
                  for(int j = 0; j < 3; ++j) {
                     Audio->PlaySound(SFX_SHOT);
                     
                     for(int k = 0; k < 2; ++k) {
                        eweapon wavectorYShots = CreateEWeaponAt(EW_SCRIPT1, risingX - 8, centerY - 8);
                        wavectorYShots->Damage = LEVIATHAN_BURSTCANNON_DMG;
                        wavectorYShots->UseSprite(SPR_WATERBALL);
                        wavectorYShots->Angular = true;
                        wavectorYShots->Angle = DegtoRad(angle);
                        wavectorYShots->Dir = AngleDir4(angle);
                        wavectorYShots->Step = 200;
                        wavectorYShots->Script = Game->GetEWeaponScript("LeviathanSignWave");
                        wavectorYShots->InitD[0] = wSizes[k]-Rand(-4, 4);
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
            case ATTACK_SIDE_SWIPE:
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
                  waterfall->Damage = LEVIATHAN_WATERFALL_DMG + 20;
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
         
         LeviathanWaitframe(this, vars);
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
      switch(changeInDifficulty(this, vars)) {
         case DIFFICULTY_STAGE_2:
            if (Hero->Y < 144) {
               if (Rand(3) == 0)
                  return 0; 
               if (Rand(3) == 1)
                  return 1;
            }
            else if (Hero->X < 48 || Hero->X > 192) {
               if(Rand(4) == 0)
                  return 1;
               if (Rand(4) == 1)
                  return 3;
            }
            else if (Hero->Y >= 144)
               if(Rand(2)==0)
                  return Choose(1, 2);
                  
            return Choose(0, 1, 2, 3);
            break;
         case DIFFICULTY_STAGE_3:
            if (Hero->Y < 144)
               if (Rand(2) == 0)
                  return 0; 
            else if (Hero->X < 48 || Hero->X > 192) {
               if(Rand(2) == 0)
                  return 1;
               if(Rand(2) == 0)
                  return 3;
               if(Rand(2) == 0)
                  return 2;
            }
            else if (Hero->Y >= 144) {
               if(Rand(2) == 0)
                  return 2;
               if(Rand(2) == 0)
                  return 1;
            }
            
            return Choose(0, 1, 3);
            break;
         case DIFFICULTY_STAGE_1:
            if (Hero->Y < 144) {
               if (Rand(3) == 0)
                  return 0;
               if (Rand(2) == 1)
                  return 1;
            }
            else if (Hero->X < 48 || Hero->X > 192)
               if (Rand(2) == 0)
                  return 1;
            if(Hero->Y >= 144)             {
               if(Rand(2) == 0)
                  return 1;
               if(Rand(2) == 0)
                  return 2;
            }
            
            return Choose(0, 1, 2);
            break;
      }
   }

   void glide(npc this, untyped vars, int x1, int y1, int x2, int y2, int numFrames) {
      int angle = Angle(x1, y1, x2, y2);
      int dist = Distance(x1, y1, x2, y2);
      
      for(int i = 0; i < numFrames; ++i) {
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
      
      for(int i = 0; i < chargeFrames; ++i) {
         Screen->Circle(4, x + Rand(-2, 2), y + Rand(-2, 2), (i / chargeFrames) * chargeMaxSize, Choose(C_CHARGE1, C_CHARGE2, C_CHARGE3), 1, 0, 0, 0, true, OP_OPAQUE);
         LeviathanWaitframe(this, vars);
      }
   }

   void splash(int x, int y) {
      lweapon waterSplash;
      
      for(int i = 0; i < 5; ++i) {
         for(int j = 1; j <= 2; ++j) {
            waterSplash = CreateLWeaponAt(LW_SPARKLE, x - 4 - 4 * i, y);
            waterSplash->UseSprite(SPR_SPLASH);
            waterSplash->ASpeed += Rand(3);
            waterSplash->Step = Rand(100, 200) * j * 0.5;
            waterSplash->Angular = true;
            waterSplash->Angle = DegtoRad( - 90 - 5 - 15 * i + Rand(-5, 5));
            waterSplash->CollDetection = false;
            
            waterSplash = CreateLWeaponAt(LW_SPARKLE, x + 4 + 4 * i, y);
            waterSplash->UseSprite(SPR_SPLASH);
            waterSplash->ASpeed += Rand(3);
            waterSplash->Step = Rand(100, 200) * j * 0.5;
            waterSplash->Angular = true;
            waterSplash->Angle = DegtoRad( - 90 + 5 + 15 * i + Rand(-5, 5));
            waterSplash->CollDetection = false;
            waterSplash->Flip = 1;
         }
      }
   }

   void LeviathanWaitframe(npc this, untyped vars, int frames) {
      for(int i = 0; i < frames; ++i)
         LeviathanWaitframe(this, vars);
   }

   void LeviathanWaitframe(npc this, untyped vars) {
      this->DrawYOffset = -1000;
      this->Stun = 10;
      this->Immortal = true;
      
      if(vars[VARS_FLIP])
         this->HitXOffset = 32;
      else
         this->HitXOffset = 64;

      if(this->Y+this->HitYOffset+this->HitHeight-1 <= 112 && vars[VARS_FLASHTIMER] == 0)
         this->CollDetection = true;
      else
         this->CollDetection = false;
      
      npc head = <npc>vars[VARS_HEADNPC];
      
      if(head->isValid()) {
         if(head->Y + head->HitYOffset + head->HitHeight - 1 <= 112 && vars[VARS_FLASHTIMER] == 0)
            head->CollDetection = true;
         else
            head->CollDetection = false;
            
         head->DrawYOffset = -1000;
         head->Stun = 10;
         
         if(vars[VARS_FLIP])
            vars[VARS_HEAD_CENTERX] = this->X + 16 + 12;
         else
            vars[VARS_HEAD_CENTERX] = this->X + 104 + 12;
         
         vars[VARS_HEAD_CENTERY] = this->Y + 48 + 8;
         head->X = vars[VARS_HEAD_CENTERX] - 12;
         head->Y = vars[VARS_HEAD_CENTERY] - 8;
         head->HitWidth = 24;
         head->HitHeight = 16;
         
         if(head->HP < 1000) {
            this->HP -= 1000 - head->HP;
            head->HP = 1000;
         }
      }
      
      if(vars[VARS_BODYHP] != this->HP) {
         if(vars[VARS_BODYHP]>this->HP)
            vars[VARS_FLASHTIMER] = 32;
         
         vars[VARS_BODYHP] = this->HP;
      }
      
      if(this->HP <= 0)
         DeathAnim(this, vars);
         
      LeviathanWaitframeLite(this, vars);
   }

   void LeviathanWaitframeLite(npc this, untyped vars) {
      int cset = this->CSet;
      
      if(vars[VARS_FLASHTIMER])
         cset = 9 - (vars[VARS_FLASHTIMER] >> 1);
      
      if(vars[VARS_FLASHTIMER])
         --vars[VARS_FLASHTIMER];
      
      Screen->DrawTile(0, this->X, this->Y, this->OriginalTile, 9, 6, cset, -1, -1, 0, 0, 0, vars[VARS_FLIP], 1, 128);
      
      UpdateWaterfallBitmap();
      
      Waitframe();
   }

   void UpdateWaterfallBitmap() {
      int cmb;
      waterfallBitmap->Clear(0);
      int ptr[5 * 22];
      
      for(int i = 0; i < 11; ++i) {
         cmb = CMB_WATERFALL;
         
         if(i == 0)
            cmb = CMB_WATERFALL + 1;
         
         waterfallBitmap->FastCombo(0, 0, 16 * i, cmb, CS_WATERFALL, 128);
         
         cmb = CMB_WATERFALL + 2;
         
         if(i == 10)
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
		
		while(this->Y < 112) {
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
}

@Author("Moosh, modified by Deathrider365")
ffc script Legionnaire {
   void run(int enemyid) { 
      npc ghost = Ghost_InitAutoGhost(this, enemyid);
      
      if (Screen->State[ST_SECRET]) {
         ghost->Remove();
         Quit();
      }

      Ghost_SetFlag(GHF_4WAY);
      int combo = ghost->Attributes[10];
      int attackCoolDown = 90 + Rand(30);
      int attack;
      int startHP = Ghost_HP;
      int movementDirection = Choose(90, -90);
      
      int timeToSpawnAnother, enemyCount;
      
      CONFIG ATTACK_FIRE_SWORDS = 0;
      CONFIG ATTACK_JUMPS_ON_YOU = 1;
      CONFIG ATTACK_SPRINT_SLASH = 2;
      
      CONFIG SPR_LEGIONNAIRESWORD = 110;
      CONFIG SFX_SHOOTSWORD = 127;
      CONFIG TIL_IMPACTMID = 955;
      CONFIG TIL_IMPACTBIG = 952;
      
      int numEnemies = Screen->NumNPCs();
      
      if (numEnemies == 1) {
         Ghost_Y = -32;
         Ghost_X = 120;
         
         for (int i = 0; i < 32; ++i) {
            disableLink();
            Ghost_Waitframe(this, ghost);
         }
         
         Ghost_Y = 80;
         Ghost_Z = 176;
         Ghost_Dir = DIR_DOWN;
         
         while (Ghost_Z) {
            disableLink();
            Ghost_Z -= 4;
            Ghost_Waitframe(this, ghost);
         }
         
         Screen->Quake = 10;
         Audio->PlaySound(3);
         
         for (int i = 0; i < 32; ++i) {
            disableLink();
            Ghost_Waitframe(this, ghost);
         }
      }
      
      while(true) {
         Ghost_Data = combo + 4;
         Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Hero->X, Hero->Y));
         
         int moveAngle = Angle(Ghost_X, Ghost_Y, Hero->X, Hero->Y) + movementDirection;
         
         Ghost_MoveAtAngle(moveAngle, ghost->Step / 100, 0);
         
         numEnemies = Screen->NumNPCs();
         
         if (timeToSpawnAnother >= 300 && numEnemies < 3) {
            enemyShake(this, ghost, 32, 1);
            Audio->PlaySound(SFX_OOT_WHISTLE);
            
            npc backupLegionnaire = Screen->CreateNPC(ENEMY_LEGIONNAIRE);
            backupLegionnaire->ItemSet = 0;
            backupLegionnaire->HP *= .5;
            backupLegionnaire->Step *= .5;
            backupLegionnaire->Damage *= .5;
            
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
            attack = Rand(3);
            
            switch(attack) {
               case ATTACK_FIRE_SWORDS:
                  enemyShake(this, ghost, 48, 1);
                  
                  Ghost_Data = combo;
                  int swordDamage = 2;
                  
                  for (int i = 0; i < 5; ++i) {
                     eweapon projectile = FireAimedEWeapon(EW_BEAM, Ghost_X, Ghost_Y, 0, 300, swordDamage, SPR_LEGIONNAIRESWORD, SFX_SHOOTSWORD, EWF_UNBLOCKABLE);
                     Ghost_Waitframes(this, ghost, 16);
                  }
                  
                  Ghost_Waitframes(this, ghost, 16);
                  
                  movementDirection = Choose(90, -90);
                  break;
               case ATTACK_JUMPS_ON_YOU: 
                  enemyShake(this, ghost, 32, 2);
                  Ghost_Data = combo + 8;
                  int distance = Distance(Ghost_X, Ghost_Y, Hero->X, Hero->Y);
                  int jumpAngle = Angle(Ghost_X, Ghost_Y, Hero->X, Hero->Y);
                  
                  int explosionDamage = 4;
                  
                  Ghost_Jump = getJumpLength(distance / 2, true);
                  
                  Audio->PlaySound(SFX_JUMP);
                  
                  while (Ghost_Jump || Ghost_Z) {
                     Ghost_MoveAtAngle(jumpAngle, 2, 0);
                     Ghost_Waitframe(this, ghost);
                  }
                  
                  Ghost_Data = combo;
                  Audio->PlaySound(3);	
                  
                  for (int i = 0; i < 24; ++i) {
                     makeHitbox(Ghost_X - 12, Ghost_Y - 12, 40, 40, explosionDamage);
                     
                     if (i > 7 && i <= 15)
                        Screen->DrawTile(2, Ghost_X - 16, Ghost_Y - 16, TIL_IMPACTBIG, 3, 3, 8, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
                     else	
                        Screen->DrawTile(2, Ghost_X - 16, Ghost_Y - 16, TIL_IMPACTMID, 3, 3, 8, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
                        
                     Ghost_Waitframe(this, ghost);
                  }
                  
                  movementDirection = Choose(90, -90);
                  break;
               case ATTACK_SPRINT_SLASH:
                  enemyShake(this, ghost, 16, 2);
                  Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Hero->X, Hero->Y));
                  
                  int slashDamage = 3;
                  
                  int moveAngle = Angle(Ghost_X, Ghost_Y, Hero->X, Hero->Y);
                  int distance = Distance(Ghost_X, Ghost_Y, Hero->X, Hero->Y);
                  
                  int dashFrames = Max(6, (distance - 36) / 3);
                  
                  for (int i = 0; i < dashFrames; ++i) {
                     Ghost_MoveAtAngle(moveAngle, 3, 0);
                     
                     if (i > dashFrames / 2)
                        sword1x1(Ghost_X, Ghost_Y, moveAngle - 90, (i - dashFrames / 2) / (dashFrames / 2) * 16, combo + 12, 10, slashDamage);
                        
                     Ghost_Waitframe(this, ghost);
                  }
                  
                  Audio->PlaySound(SFX_SWORD);
                  
                  for (int i = 0; i <= 12; ++i) {
                     Ghost_MoveAtAngle(moveAngle, 3, 0);
                     sword1x1(Ghost_X, Ghost_Y, moveAngle - 90 + 15 * i, 16, combo + 12, 10, slashDamage);
                     Ghost_Waitframe(this, ghost);
                  }
                  
                  movementDirection = Choose(90, -90);
                  break;
            }
         }
         
         if (Ghost_HP <= startHP * 0.5)
            timeToSpawnAnother++;
         
         Ghost_Waitframe(this, ghost);
      }
   }
}

@Author("Moosh, modified by Deathrider365")
ffc script Shambles {
   using namespace ShamblesNamespace;

   void run(int enemyid) {
      npc ghost = Ghost_InitAutoGhost(this, enemyid);
      int combo = ghost->Attributes[10];
      int attackCoolDown = 90;
      int attack;
      int startHP = Ghost_HP;
      int bombsToLob = 3;
      int difficultyMultiplier = 0.5;
      
      CONFIG ATTACK_LINK_CHARGE = 0;
      CONFIG ATTACK_BOMB_LOB = 1;
      CONFIG ATTACK_SPAWN_ZAMBIES = 2;
      
      Ghost_X = 128;
      Ghost_Y = -32;
      Ghost_Dir = DIR_DOWN;

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

      if (firstRun) {
         Screen->Message(401);
         firstRun = false;
      }

      submerge(this, ghost, 8);

      while (true) {		
         int choice = chooseAttack();
         
         ShamblesWaitframe(this, ghost, 120);
         
         int pos = moveMe();
         Ghost_X = ComboX(pos);
         Ghost_Y = ComboY(pos);
         
         if (Ghost_HP < startHP * difficultyMultiplier) {
            emerge(this, ghost, 4);
            bombsToLob = 5;
         }
         else
            emerge(this, ghost, 8);
         
         switch(choice) {
            case ATTACK_LINK_CHARGE:
               Waitframes(30);
               
               for (int i = 0; i < 5; ++i) {
                  int moveAngle = Angle(Ghost_X, Ghost_Y, Hero->X, Hero->Y);
                  Audio->PlaySound(SFX_SWORD);
                  
                  for (int j = 0; j < 22; ++j) {
                     if (Ghost_HP < startHP * difficultyMultiplier && j % 3 == 0) {
                        eweapon poisonTrail = FireEWeapon(EW_SCRIPT10, Ghost_X + Rand(-2, 2), Ghost_Y + Rand(-2, 2), 0, 0, 1, SPR_POISON_CLOUD, SFX_SIZZLE, EWF_UNBLOCKABLE);
                        SetEWeaponLifespan(poisonTrail, EWL_TIMER, 120);
                        SetEWeaponDeathEffect(poisonTrail, EWD_VANISH, 0);
                     }
                     
                     Ghost_ShadowTrail(this, ghost, false, 4);
                     Ghost_MoveAtAngle(moveAngle, 3, 0);
                     ShamblesWaitframe(this, ghost, 1);
                  }
                  
                  ShamblesWaitframe(this, ghost, 30);
               }
               break;
            case ATTACK_BOMB_LOB:
               for (int i = 0; i < bombsToLob; ++i) {
                  ShamblesWaitframe(this, ghost, 16);
                  eweapon bomb = FireAimedEWeapon(EW_BOMB, Ghost_X, Ghost_Y, 0, 200, ghost->WeaponDamage, -1, -1, EWF_UNBLOCKABLE | EWF_ROTATE);
                  Audio->PlaySound(SFX_LAUNCH_BOMBS);
                  runEWeaponScript(bomb, Game->GetEWeaponScript("ArcingWeapon"), {-1, 0, (Ghost_HP < (startHP * difficultyMultiplier)) ? AE_LARGEPOISONPOOL : AE_SMALLPOISONPOOL});
                  Waitframes(6);
               }
               break;
            case ATTACK_SPAWN_ZAMBIES:
               spawnZambos(this, ghost);
               break;
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

@Author("EmilyV99, Deathrider365")
npc script OvergrownRaccoon {
   using namespace OvergrownRaccoonNamespace;
   using namespace EnemyNamespace;
   
   void run() {
      disableLink();
      State state = STATE_NORMAL;
      State previousState = state;
      const int maxHp = this->HP;
      int timer;
      
      this->Dir = faceLink(this);
      
      until (this->Z == 0)
         Waitframe();
      
      Screen->Quake = 60;
      Audio->PlaySound(SFX_BOMB_BLAST);
      
      Waitframes(30);
      
      disableLink();
      
      unless (getScreenD(255)) {
         Screen->Message(403);
         setScreenD(255, true);
      }
         
      while(true) {
         if (this->HP <= 0)
            deathAnimation(this, 136);
            
         int randModifier = isDifficultyChange(this, maxHp) ? Rand(-90, 30) : Rand(-60, 60);
         
         if (++timer > 120 + randModifier) {
            timer = 0;
            int attackChoice = 0;
            
            if (Screen->NumNPCs() > 5 && Screen->NumNPCs() < 10)
               attackChoice = STATE_RACCOON_THROW;
            else if (previousState == STATE_SMALL_ROCKS_THROW)
               attackChoice = RandGen->Rand(1, 4);
            else if (previousState == STATE_CHARGE)
               attackChoice = RandGen->Rand(2, 4);
            else
               attackChoice = RandGen->Rand(4);
               
            state = parseAttackChoice(attackChoice);
         }
         
         switch(state) {
            case STATE_NORMAL:
               previousState = state;
               this->ScriptTile = -1;
               doWalk(this, 5, 10, this->Step);
               break;
            case STATE_LARGE_ROCK_THROW:
               previousState = state;
               
               Waitframes(60);
               
               eweapon rockProjectile = FireBigAimedEWeapon(196, CenterX(this) - 8, CenterY(this) - 8, 0, 255, 6, 119, -1, EWF_UNBLOCKABLE, 2, 2);
               Audio->PlaySound(SFX_LAUNCH_BOMBS);
               runEWeaponScript(rockProjectile, Game->GetEWeaponScript("ArcingWeapon"), {-1, 0, AE_BOULDER_PROJECTILE});
               state = STATE_NORMAL;
               break;
            case STATE_SMALL_ROCKS_THROW:
               previousState = state;
               
               Waitframes(30);
               
               for(int i = 0; i < 60; ++i) {
                  if (this->HP <= 0)
                     deathAnimation(this, 136);
                     
                  this->ScriptTile = this->OriginalTile + (this->Tile % 8) + 52;
                  
                  unless (i % 20) {
                     eweapon rockProjectile = FireAimedEWeapon(195, CenterX(this) - 8, CenterY(this) - 8, 0, 255, 3, 118, -1, EWF_UNBLOCKABLE | EWF_ROTATE);
                     Audio->PlaySound(SFX_LAUNCH_BOMBS);
                     runEWeaponScript(rockProjectile, Game->GetEWeaponScript("ArcingWeapon"), {-1, 0, AE_ROCK_PROJECTILE});
                  }
                  
                  Waitframe();
               }
               
               state = STATE_NORMAL;
               break;						
            case STATE_RACCOON_THROW:
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
            case STATE_CHARGE:
               previousState = state;
               
               int angle = RadtoDeg(TurnTowards(CenterX(this), CenterY(this), CenterLinkX(), CenterLinkY(), 0, 1));
               this->Dir = AngleDir4(angle);
               this->ScriptTile = -1;
               
               this->Jump = 2.5;
               
               do Waitframe(); while(this->Z);
               
               while(this->MoveAtAngle(angle, 4, SPW_NONE))
                  Waitframe();
               
               this->Jump = 2;
               Screen->Quake = 30;
               Audio->PlaySound(SFX_BOMB_BLAST);
               
               do Waitframe(); while(this->Z);
               
               state = STATE_NORMAL;
               break;
         }
         
         Waitframe();
      }
   }
}

@Author("Deathrider365")
npc script Demonwall {
   void run() {
      // for (int i = 0; i < roomsize since the wall can squish link for instakill; ++i)
      // {
         // move the guy perhaps 1/8th of a tile every frame 
         // if (demonwall->HP at 70%)
            // move demonwall back 3 tiles if it can, otherwise just back the the left wall
            
         // do some attacks
         
      // }
   }
}

@Author("Moosh")
npc script SeizedGuardGeneral {
   using namespace NPCAnim;

   enum Animations {
      WALKING,
      ATTACK
   };

   void run() {
     int aptr[ANIM_BUFFER_LENGTH];
     InitAnims(this, aptr);

     AddAnim(aptr, WALKING, 0, 4, 8, ADF_4WAY);
     AddAnim(aptr, ATTACK, 20, 2, 16, ADF_4WAY | ADF_NOLOOP);
      
      int maxHp = this->HP;
      Audio->PlayEnhancedMusic("OoT - Middle Boss.ogg", 0);
      
      while(true) {
         int movementDirection = Choose(90, -90);
         int attackCoolDown = 120;
         
         PlayAnim(this, WALKING);
         
         int tooCloseBoiCounter = 0;
         
         while (attackCoolDown) 			{
            int moveAngle = Angle(this->X + 8, this->Y + 8, Hero->X + 8, Hero->Y + 8);
            int distance = Distance(this->X, this->Y, Hero->X, Hero->Y);
            
            if (distance < 48)
               tooCloseBoiCounter++;
            else
               tooCloseBoiCounter = 0;
            
            if (tooCloseBoiCounter == 60) {
               for (int i = 0; i < 15; ++i) {
                  FaceLink(this);
                  sword1x1(this->X, this->Y, moveAngle - 90 + 15 * i, 16, 10252, 10, 10);
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
         
         for (int i = 0; i < dashFrames; ++i) {
            this->MoveAtAngle(moveAngle, this->Step / (gettingDesperate(this, maxHp) ? 20 : 25), SPW_NONE);
            FaceLink(this);
            
            if (i > dashFrames / 2)
               sword1x1(this->X, this->Y, moveAngle - 90, (i - dashFrames / 2) / (dashFrames / 2) * 16, 10252, 10, 6);
               
            CustomWaitframe(this);
         }
         
         Audio->PlaySound(SFX_SWORD);
         distance = Distance(this->X + 8, this->Y + 8, Hero->X + 8, Hero->Y + 8);
         
         for (int i = 0; i <= 12 && !swordCollided; ++i) {
            this->MoveAtAngle(moveAngle, this->Step / (gettingDesperate(this, maxHp) ? 25 : 30), SPW_NONE);
            FaceLink(this);
            swordCollided = sword1x1Collision(this->X, this->Y, moveAngle - 90 + 15 * i, 16, 10252, 10, 6);
            CustomWaitframe(this);
         }
         
         if (swordCollided) {
            Audio->PlaySound(SFX_SWORD_ROCK3);
            
            for(int i = 0; i < 12; ++i) {
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
         n->Immortal = false;
         PlayDeathAnim(n);
      }

      Waitframe(n);
   }

   void CustomWaitframe(npc n, int frames) {
      for (int i = 0; i < frames; ++i)
         CustomWaitframe(n);
   }
}

@Author("EmilyV99, Moosh, Deathrider365")
npc script ServusMalus {
   using namespace EnemyNamespace;
   using namespace ServusMalusNamespace;
   
   void run() {
      CONFIG originalTile = this->OriginalTile;
      CONFIG attackingTile = 49660;
      CONFIG unarmedTile = 49740;
      
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
         
      until (getScreenD(254)) {
         int litTorchCount = 0;
      
         template = Game->LoadTempScreen(1);
         
         litTorchCount += <int> (template->ComboD[upperLeftTorchLoc] == litTorch);
         litTorchCount += <int> (template->ComboD[upperRightTorchLoc] == litTorch);
         litTorchCount += <int> (template->ComboD[lowerLeftTorchLoc] == litTorch);
         litTorchCount += <int> (template->ComboD[lowerRightTorchLoc] == litTorch);
         
         checkTorchBrightness(litTorchCount, cmbLitTorch);
            
         if (litTorchCount == 4) {
            torchesLit = true;
            setScreenD(254, true);
            commenceIntroCutscene(this, template, unlitTorch, cmbLitTorch, bigSummerBlowout, upperLeftTorchLoc, upperRightTorchLoc, lowerLeftTorchLoc, lowerRightTorchLoc, originalTile, attackingTile);
            
            Audio->PlayEnhancedMusic("Bloodborne PSX - Cleric Beast.ogg", 0);
            Screen->Message(404);
         }
         
         Waitframe();
      }
      
      this->X = 128;
      this->Y = 32;
      
      while(true) {
         this->Z = 20;
         this->CollDetection = false;
         this->OriginalTile = invisibleTile;
         
         int blowOutRandomTorchTimer = 180;
         int chosenTorch;
         int spawnTimer = 90;
         int maxEnemies = 5;
         
         torchesLit = false;
         int vectorX, vectorY;
         
         until (torchesLit) {
            template = Game->LoadTempScreen(1);
            
            int litTorchCount = 0;
            
            int litTorches[4];
            int allTorches[4] = {upperLeftTorchLoc, upperRightTorchLoc, lowerLeftTorchLoc, lowerRightTorchLoc};

            for (int q = 0; q < 4; ++q)
               if (template->ComboD[allTorches[q]] == litTorch)
                  litTorches[litTorchCount++] = allTorches[q];
            
            ResizeArray(litTorches, litTorchCount);
            
            checkTorchBrightness(litTorchCount, cmbLitTorch);
            
            unless (chosenTorch || --blowOutRandomTorchTimer) {
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
                     ewind->Damage = 2;
                  }
                  
                  Audio->PlaySound(SFX_ONOX_TORNADO);
                  chosenTorch = 0;
               }
            } else {
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
         
         while(timer < START_TIMER) {
            if (this->HP <= maxHp * .3)
               gettingDesperate = true;
               
            float percent = timer / START_TIMER;
               
            cmbLitTorch->Attribytes[0] = Lerp(24, 50, 1 - percent);
            
            if (this->HP <= 0)
               deathAnimation(this, 148);
               
            if (this->Z > 0 && !(gameframe % 2))
               this->Z -= 1;
            
            unless (attackCooldown) {
               chooseAttack(this, originalTile, attackingTile, unarmedTile, gettingDesperate);
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
               
               unless (dodgeTimer) {
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
               
               unless (dodgeTimer) {
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
         
         int unlitTorchCount = 0;
         
         int multipler = 1;
            
         do {
            if (this->HP <= 0)
               deathAnimation(this, 148);
               
            unlitTorchCount = 0;
            
            unless(gameframe % 60) {
               windBlast(this, originalTile, attackingTile, multipler);
               ++multipler;
            }
            
            unlitTorchCount += <int> (template->ComboD[upperLeftTorchLoc] == litTorch);
            unlitTorchCount += <int> (template->ComboD[upperRightTorchLoc] == litTorch);
            unlitTorchCount += <int> (template->ComboD[lowerLeftTorchLoc] == litTorch);
            unlitTorchCount += <int> (template->ComboD[lowerRightTorchLoc] == litTorch);
            
            checkTorchBrightness(unlitTorchCount, cmbLitTorch, 1);
            
            Waitframe();
            
         } while(unlitTorchCount)

         Waitframe();
      }
   }

   void commenceIntroCutscene(npc this, mapdata template,int unlitTorch, combodata cmbLitTorch, int bigSummerBlowout, int upperLeftTorchLoc,  int upperRightTorchLoc, int lowerLeftTorchLoc, int lowerRightTorchLoc, int originalTile, int attackingTile) {
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
      until (xLocation == 120) {
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
            Screen->Message(653);

         Waitframe();
      }
      
      // Turns left
      for (int i = 0; i < 120; ++i) {
         disableLink();
         Screen->FastCombo(2, 120, 80, soldierLeft, 0, OP_OPAQUE);
         
         if (i == 60) 
            Screen->Message(654);
            
         Waitframe();
      }
      
      // Turns right
      for (int i = 0; i < 120; ++i) {
         disableLink();
         Screen->FastCombo(2, 120, 80, soldierRight, 0, OP_OPAQUE);
         
         if (i == 60) 
            Screen->Message(655);
         
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
      
      Screen->Message(656);
      
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
      
      Screen->Message(658);
      
      // Buffer
      for (int i = 0; i < 60; ++i) {
         disableLink();
         
         Screen->FastCombo(2, 112, 32, servusFullStartingCombo, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 32, servusFullStartingCombo + 1, 3, OP_OPAQUE);
         Screen->FastCombo(2, 112, 48, servusFullStartingCombo + 2, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 48, servusFullStartingCombo + 3, 3, OP_OPAQUE);
         
         Screen->FastCombo(2, 120, 80, soldierUp, 0, OP_OPAQUE);
         
         if (i == 59)
            Screen->Message(660);
         
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
      
      Screen->Message(663);
      
      // Turns around
      for (int i = 0; i < 15; ++i) {
         disableLink();
         
         if (i < 8) {
            Screen->FastCombo(2, 112, 32, servusMovingUpStartingCombo, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 32, servusMovingUpStartingCombo + 1, 3, OP_OPAQUE);
            Screen->FastCombo(2, 112, 48, servusMovingUpStartingCombo + 2, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 48, servusMovingUpStartingCombo + 3, 3, OP_OPAQUE);
         } else {
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
      
      until (distanceTraveled == 64) {
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
      
      Screen->Message(665);
      
      // Link intervenes
      until (Hero->X >= 120) {
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
      for (int i = 0; i < 30; ++i) 			{
         disableLink();
         
         Screen->FastCombo(2, 112, 62, servusFullStartingCombo, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 62, servusFullStartingCombo + 1, 3, OP_OPAQUE);
         Screen->FastCombo(2, 112, 78, servusFullStartingCombo + 2, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 78, servusFullStartingCombo + 3, 3, OP_OPAQUE);
         
         Waitframe();
      }
      
      Screen->Message(666);
      
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
         } else {
            Screen->FastCombo(2, 112, 14, servusTransStartingCombo, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 14, servusTransStartingCombo + 1, 3, OP_OPAQUE);
            Screen->FastCombo(2, 112, 30, servusTransStartingCombo + 2, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 30, servusTransStartingCombo + 3, 3, OP_OPAQUE);
         }
         
         Waitframe();
      }         
   }
}



