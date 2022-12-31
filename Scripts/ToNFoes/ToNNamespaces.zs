///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~~~~~The Terror of Necromancy Namespaces~~~~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

namespace Leviathan1Namespace {
   //Leviathan's waterfall combos: Up (BG, middle) Up, (BG, foam) Down (FG, middle), Down (FG, foam)
   const int CMB_WATERFALL = 6828; 
   const int CS_WATERFALL = 0;

   const int NPC_LEVIATHANHEAD = 177;

   CONFIG SFX_RISE = 67;		//9
   CONFIG SFX_WATERFALL = 26;
   CONFIG SFX_LEVIATHAN1_ROAR = SFX_ROAR;
   CONFIG SFX_LEVIATHAN1_SPLASH = SFX_SPLASH;
   CONFIG SFX_CHARGE = 35;
   CONFIG SFX_SHOT = 40;

   CONFIG SPR_SPLASH = 93;
   CONFIG SPR_WATERBALL = 94;

   COLOR C_CHARGE1 = C_DARKBLUE;
   COLOR C_CHARGE2 = C_SEABLUE;
   COLOR C_CHARGE3 = C_TAN;

   int LEVIATHAN1_WATERCANNON_DMG = 60;
   int LEVIATHAN1_BURSTCANNON_DMG = 30;
   int LEVIATHAN1_WATERFALL_DMG = 50;

   int MSG_BEATEN = 23;
   int MSG_LEVIATHAN_SCALE = 122;

   bool firstRun = true;

   @Author("Moosh")
   eweapon script Waterfall {
      void run(int width, int peakHeight) {
         this->UseSprite(SPR_WATERBALL);
         
         unless (waterfallBitmap->isAllocated()) {
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
         int waterfallRisingHeight;
         int waterfallFallingHeight;
         this->CollDetection = false;
         
         while (waterfallTop > peakHeight) {
            waterfallTop = Max(waterfallTop - 1.5, peakHeight);
            waterfallRisingHeight = waterfallBottom - waterfallTop;
            
            for (int i = 0; i < width; ++i) {
               int x = startX - (width - 1) * 8 + i * 16;
               waterfallBitmap->Blit(0, -2, 0, 0, 16, waterfallRisingHeight, x, waterfallTop, 16, waterfallRisingHeight, 0, 0, 0, BITDX_NORMAL, 0, false);
            }
            
            Waitframe();
         }
         
         waterfallRisingHeight = waterfallBottom - waterfallTop;
         waterfallTop = peakHeight;
         waterfallBottom = peakHeight;
         hitbox->CollDetection = true;
         
         while (waterfallBottom < 176) {
            unless (!hitbox->isValid()) {
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
            hitbox->HitHeight = waterfallFallingHeight;
            
            waterfallBottom += 3;
            waterfallFallingHeight = waterfallBottom - waterfallTop;
            
            for(int i = 0; i < width; ++i) {
               int x = startX - (width - 1) * 8 + i * 16;
               waterfallBitmap->Blit(0, -2, 0, 0, 16, waterfallRisingHeight, x, peakHeight, 16, waterfallRisingHeight, 0, 0, 0, BITDX_NORMAL, 0, false);
               waterfallBitmap->Blit(4, -2, 16, 175-waterfallFallingHeight, 16, waterfallFallingHeight, x, peakHeight, 16, waterfallFallingHeight, 0, 0, 0, BITDX_NORMAL, 0, false);
            }
            
            Waitframe();
         }
         
         while(waterfallTop < 176) {
            if(!hitbox->isValid()) {
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
            hitbox->HitHeight = waterfallFallingHeight;
            
            waterfallTop += 3;
            waterfallFallingHeight = waterfallBottom-waterfallTop;
            
            for(int i = 0; i < width; ++i) {
               int x = startX - (width - 1) * 8 + i * 16;
               waterfallBitmap->Blit(4, -2, 16, 175 - waterfallFallingHeight, 16, waterfallFallingHeight, x, waterfallTop, 16, waterfallFallingHeight, 0, 0, 0, BITDX_NORMAL, 0, false);
            }
            
            Waitframe();
         }
         
         this->DeadState = 0;
         
         if(hitbox->isValid())
            hitbox->DeadState = 0;
         
         Quit();
      }
   }
   
   @Author("Moosh")
   eweapon script LeviathanSignWave {
      void run(int size, int speed, bool noBlock) {
         int x = this->X;
         int y = this->Y;
         
         int dist;
         int timer;
         
         while(true) {
            timer += speed;
            timer %= 360;
            
            x += RadianCos(this->Angle) * this->Step * 0.01;
            y += RadianSin(this->Angle) * this->Step * 0.01;
            
            dist = Sin(timer) * size;
            
            this->X = x + VectorX(dist, RadtoDeg(this->Angle) - 90);
            this->Y = y + VectorY(dist, RadtoDeg(this->Angle) - 90);
            
            if(noBlock)
               this->Dir = Link->Dir;
            
            Waitframe();
         }
      }
   }
} 

namespace ShamblesNamespace {
   bool firstRun = true;

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

   int chooseAttack() {
      int numEnemies = Screen->NumNPCs();
      
      if (numEnemies > 5)
         return Rand(0, 1);
      
      return Rand(0, 2);	
   }

   void spawnZambos(ffc this, npc ghost) {
      for (int i = 0; i < 3; ++i) {
         Audio->PlaySound(SFX_SUMMON);
         int zamboChoice = Rand(0, 2);
         npc zambo;
         
         if (zamboChoice == 0)
            zambo = Screen->CreateNPC(ENEMY_ZOMBIE_LV1_POPUP);
         else if (zamboChoice == 1)
            zambo = Screen->CreateNPC(ENEMY_ZOMBIE_LV1);
         else
            zambo = Screen->CreateNPC(ENEMY_ZOMBIE_LV1_SPRINTING);
            
         int pos = moveMe();
         
         zambo->X = ComboX(pos);
         zambo->Y = ComboY(pos);
         
         ShamblesWaitframe(this, ghost, 30);
      
      }	
   }

   void ShamblesWaitframe(ffc this, npc ghost, int frames) {
      for(int i = 0; i < frames; ++i)
         Ghost_Waitframe(this, ghost, 1, true);
   }

   void ShamblesWaitframe(ffc this, npc ghost, int frames, int sfx) {
      for(int i = 0; i < frames; ++i) {
         if (sfx > 0 && i % 30 == 0)
            Audio->PlaySound(sfx);
            
         Ghost_Waitframe(this, ghost, 1, true);
      }
   }

}

namespace Enemy::Hazarond {
   bool firstRun = true;

   enum Attacks {
      GROUND_POUND,
      OIL_CANNON,
      OIL_SPRAY,
      FLAME_TOSS,
      FLAME_CANNON
   };

   npc script Hazarond {
      CONFIG DEFAULT_COMBO = 10272;
      CONFIG JUMP_PREP_COMBO = 10273;
      CONFIG JUMPING_COMBO = 10274;
      CONFIG JUMP_LANDING_COMBO = 10275;
      
      CONFIG TIME_BETWEEN_ATTACKS = 180;
      
      void run(int hurtCSet, int minion) {
         if (firstRun)
            disableLink();
            
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
            Screen->Message(402);
            firstRun = false;
         }
         else
            Audio->PlayEnhancedMusic("The Binding of Isaac - Divine Combat.ogg", 0);
         
         disableLink();
         
         while(this->HP > 0) {
            int previousAttack;
            
            int angle;
            int headOpen = 20;
            int headOpenIndex;
            
            while(true) {
               if (isHeadsDead(heads))
                  break;
               
               for (int i = 0; i < 20; ++i)
                  this->Defense[i] = NPCDT_IGNORE;
               
               for (int i = 0; i < 4; ++i)
                  if (heads[i])
                     heads[i]->CollDetection = true;
                  
               if (headOpen == 20) {
                  headOpenIndex = RandGen->Rand(3);
                  
                  until (heads[headOpenIndex])
                     headOpenIndex = RandGen->Rand(3);
               
                  if (heads[headOpenIndex])
                     heads[headOpenIndex]->OriginalTile -= 1;
               }
               
               if (headOpen == 0) {
                  if (heads[headOpenIndex])
                     heads[headOpenIndex]->OriginalTile += 1;
                  
                  headOpenIndex = RandGen->Rand(3);
                  
                  until (heads[headOpenIndex])
                     headOpenIndex = RandGen->Rand(3);
                     
                  if (heads[headOpenIndex])
                     heads[headOpenIndex]->OriginalTile -= 1;
                     
                  headOpen = 20;
               }
                  
               angle = RadtoDeg(TurnTowards(CenterX(this), CenterY(this), CenterLinkX(), CenterLinkY(), 0, 1));
               
               unless (data[DATA_CLK] % 3)
                  this->MoveAtAngle(angle, 1, SPW_NONE);
               
               bool justSprayed = false;
               
               if (TIME_BETWEEN_ATTACKS <= timeSinceLastAttack) {
                  if (heads[headOpenIndex])
                     heads[headOpenIndex]->OriginalTile += 1;
                     
                  oilSpray(data, this, heads, isDifficultyChange(this, maxHp));
                  
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
                     dropFlame(heads, headOpenIndex, eweaponStopper);
               
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
               else if(i == NPCD_ARROW)
                  this->Defense[i] = NPCDT_BLOCK;
               else
                  this->Defense[i] = NPCDT_NONE;
            }
            
            for(int i = 0; i < 10; ++i)
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
            
            while(Distance(this->X + this->HitXOffset + this->HitWidth / 2, this->Y + this->HitYOffset + this->HitHeight / 2, centerX, centerY) > 3)
               while (MoveTowardsPoint(this, centerX, centerY, 2, SPW_FLOATER, true))
                  EnemyWaitframe(this, data, 2);
            
            this->CollDetection = false;
            
            for (int i = 0; i < 20; ++i)
               this->Defense[i] == NPCDT_IGNORE;
               
            data[DATA_INVIS] = true;
            
            for (int i = 0; i < 32; ++i) {
               for(int j = 0; j < 4; ++j) {
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
               for(int j = 0; j < 4; ++j) {
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
		
		while(MoveTowardsPoint(this, linkX, linkY, JUMP_SPEED, SPW_FLOATER, true))		
			Waitframe();
		
		while(this->Z) {
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
		until (panPosition == 40) {
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
		until (panPosition == 100) {
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
		until (panPosition == 180) {
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
		until (panPosition == 230) {
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
		until (panPosition == 256) {
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
		until (panPosition == 0) {
			disableLink();
			--panPosition;
			++timer;
         
			if(timer < 24)
			{
				unless (timer % 3)
					yModifier = -3.8;
				else
					yModifier = 0;
			}
			else if (timer < 112)
				yModifier = 0;
			else if (timer < 148)
			{
				unless (timer % 3)
					yModifier = 2;
				else
					yModifier = 0;
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
	
	void dropFlame(npc heads, int headOpenIndex, int eweaponStopper) {
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
		flame->Damage = 2;
		flame->UseSprite(SPR_FLAME_OIL);
	}
	
	void oilSpray(int data, npc this, npc heads, bool isDifficultyChange) {
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
		
			eweapon oilBlob = FireAimedEWeapon(194, CenterX(this) - 8, CenterY(this) - 8, 0, 255, 1, 117, -1, EWF_UNBLOCKABLE | EWF_ROTATE);
			Audio->PlaySound(SFX_SQUISH);
			runEWeaponScript(oilBlob, Game->GetEWeaponScript("ArcingWeapon"), {-1, 0, AE_OIL_BLOB});
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
		while(frames--) {
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
		
		while(MoveTowardsPoint(this, centerX, centerY, JUMP_SPEED, SPW_FLOATER, true))
			Waitframe();
		
		while(this->Z)
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
         unless(parent)
            this->Remove();
         
         while(true) {
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
         } else {
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
         } else {
            if (parent->Dir == DIR_DOWN)
               return -2;
            else if(parent->Dir == DIR_UP)
               return -27;
            else
               return -10;
         }		
      }
   }
}

namespace Enemy::Candlehead {
	@Author("Deathrider365")
	npc script Candlehead {
		const int NORMAL_RAND = 5;
		const int AGGRESSIVE_RAND = 50;
		const int NORMAL_MOVE_DURATION = 30;
		const int AGGRESSIVE_MOVE_DURATION = 60;
		const int NORMAL_HOMING = 10;
		const int AGGRESSIVE_HOMING = 20;
		
		void run(int chungo) {
			int knockbackDist = 4;
			
			if (knockbackDist < 0)
				this->NoSlide = true;
			else
				this->SlideSpeed = knockbackDist;
			
			while(true) {
				this->Slide();
            
				if (hitByLWeapon(this, LW_FIRE) || hitByEWeapon(this, EW_FIRE) || hitByEWeapon(this, EW_SCRIPT1))
					burnToDeath(this, chungo);
					
				unless (gameframe % RandGen->Rand(45, 60)) {
					for (int i = 0; i < (linkClose(this, 24) ? AGGRESSIVE_MOVE_DURATION : NORMAL_MOVE_DURATION); ++i) {
						this->Slide();
						
                  if (hitByLWeapon(this, LW_FIRE) || hitByEWeapon(this, EW_FIRE) || hitByEWeapon(this, EW_SCRIPT1))
							burnToDeath(this, chungo);
							
						doWalk(this, linkClose(this, 24) ? AGGRESSIVE_RAND : NORMAL_RAND, linkClose(this, 24) ? AGGRESSIVE_HOMING : NORMAL_HOMING, this->Step);
						Waitframe();
					}
				}
				Waitframe();
			}
		}
      
		void burnToDeath(npc n, int chungo) {
         n->Step += n->Step / 3;
			
         int burningCombo = getBurningCombo(chungo);
			int sprite = getBurningSprite(chungo);
			
			n->Dir = getInvertedDir(n->Dir);
			n->Step += n->Step / 2;
			
			until (n->HP <= 0) {
				int x = chungo ? n->X + 8 : n->X;
				int y = chungo ? n->Y + 8 : n->Y;

				if (n->HP < 10)
					n->HP = 0;
				else
					n->HP -= 1; 
				
				n->Slide();
				
				if (gameframe % 20 == 0) {
					eweapon flame = CreateEWeaponAt(EW_SCRIPT1, x - (chungo ? 8 : 0), y - (chungo ? 8 : 0));
					flame->Dir = n->Dir;
					flame->Script = Game->GetEWeaponScript("StopperKiller");
					flame->Z = n->Z;
					flame->InitD[1] = 120;
					flame->Gravity = true;
					flame->Damage = 2;
					flame->UseSprite(sprite);
					
					if (chungo) {
						flame->Extend = 3;
						flame->TileWidth = 2;
						flame->TileHeight = 2;
						flame->HitWidth = 32;
						flame->HitHeight = 32;
						flame->UseSprite(sprite);
					}
				}
				
				Screen->FastCombo(7, n->X, n->Y, burningCombo, 0, OP_OPAQUE);
				
				if (chungo) {
					Screen->FastCombo(7, n->X + 16, n->Y, burningCombo + 1, 0, OP_OPAQUE);
					Screen->FastCombo(7, n->X, n->Y + 16, burningCombo + 2, 0, OP_OPAQUE);
					Screen->FastCombo(7, n->X + 16, n->Y + 16, burningCombo + 3, 0, OP_OPAQUE);
				}
				
				// doWalk(n, linkClose(n, 24) ? AGGRESSIVE_RAND : NORMAL_RAND, linkClose(n, 24) ? AGGRESSIVE_HOMING : NORMAL_HOMING, n->Step);
				doWalk(n, linkClose(n, 24) ? AGGRESSIVE_RAND : NORMAL_RAND, linkClose(n, 24) ? AGGRESSIVE_HOMING : NORMAL_HOMING, n->Step);
				
				Waitframe();
			}
			
			for (int i = 0; i < 8; ++i) {
				eweapon flame = CreateEWeaponAt(EW_SCRIPT1, n->X, n->Y);
				flame->Dir = i;
				flame->Step = chungo ? 160 : 120;
				flame->Angular = true;
				flame->Angle = DirRad(flame->Dir);
				flame->Script = Game->GetEWeaponScript("StopperKiller");
				flame->Z = n->Z;
				flame->InitD[0] = chungo ? 40 : 20;
				flame->InitD[1] = chungo ? 250 : 150;
				flame->Gravity = true;
				flame->Damage = 2;
				flame->UseSprite(sprite);
				
				if (chungo) {
					flame->Extend = 3;
					flame->TileWidth = 2;
					flame->TileHeight = 2;
					flame->HitWidth = 32;
					flame->HitHeight = 32;
					flame->UseSprite(sprite);
				}
			}
			
			Audio->PlaySound(10);
			n->HP = 0;
		}
		
		int getBurningCombo(int chungo) {
			switch(GetHighestLevelItemOwned(IC_CANDLE)) {
				case 158:
					return chungo ? 7180 : 6344;
				case 10:
					return chungo ? 7184 : 6345;
				case 11:
					return chungo ? 7188 : 6346;
				case 150:
					return chungo ? 7192 : 6347;
			}
		}
		
		int getBurningSprite(int chungo) {
			switch(GetHighestLevelItemOwned(IC_CANDLE)) {
				case 158:
					return chungo ? SPR_FLAME_WAX2X2 : SPR_FLAME_WAX;
				case 10:
					return chungo ? SPR_FLAME_OIL2X2 : SPR_FLAME_OIL;
				case 11:
					return chungo ? SPR_FLAME_INCENDIARY2X2 : SPR_FLAME_INCENDIARY;
				case 150:
					return chungo ? SPR_FLAME_HELLS2X2 : SPR_FLAME_HELLS;
			}
		}
		
	}
}

namespace Enemy {		
   enum dataInd {
      DATA_AFRAMES,
      DATA_CLK,
      DATA_FRAME,
      DATA_INVIS,
      SZ_DATA
   };

   void setNPCToCombo(int data, npc n, int comboId) {
      setNPCToCombo(data, n, Game->LoadComboData(comboId));
   }

   void setNPCToCombo(int data, npc n, combodata combo) {
      data[DATA_AFRAMES] = combo->Frames;
      n->OriginalTile = combo->OriginalTile;
      n->ASpeed = combo->ASpeed;
      data[DATA_FRAME] = 0;
   }

   void setupNPC(npc n) {
      n->Animation = false;
      
      unless(n->TileWidth)
         n->TileWidth = 1;
      unless(n->TileHeight)
         n->TileHeight = 1;
      unless(n->HitWidth)
         n->HitWidth = 16;
      unless(n->HitHeight)
         n->HitHeight = 16;
   }

   void deathAnimation(npc n, int deathSound) {
      n->Immortal = true;
      n->CollDetection = false;
      n->Stun = 9999;

      int baseX = n->X + n->DrawXOffset;
      int baseY = (n->Y + n->DrawYOffset) - (n->Z + n->DrawZOffset);
      
      Audio->PlaySound(deathSound);
      
      for(int i = 0; i < 45; i++) {
         unless (i % 3) {
            lweapon explosion = Screen->CreateLWeaponDx(LW_BOMBBLAST, 213);
            explosion->X = baseX + RandGen->Rand(16 * n->TileWidth) - 8;
            explosion->Y = baseY + RandGen->Rand(16 * n->TileHeight) - 8;
            explosion->CollDetection = false;
         }
         Waitframes(5);
      }
      
      char32 areaMusic[256];
      Game->GetDMapMusicFilename(Game->GetCurDMap(), areaMusic);
      Audio->PlayEnhancedMusic(areaMusic, 0);
      
      for(int i = Screen->NumNPCs(); i >= 1; i--) {
         npc n = Screen->LoadNPC(i);
         n->HP = 0;
      }
      
      n->Immortal = false;
      n->HP = 0;
   }

   void EnemyWaitframe(npc n, int data) {
      if (n->HP <= 0)
         deathAnimation(n, 142);

      if(++data[DATA_CLK] >= n->ASpeed) {
         data[DATA_CLK] = 0;
         
         if(++data[DATA_FRAME] >= data[DATA_AFRAMES])
            data[DATA_FRAME] = 0;
            
         n->ScriptTile = n->OriginalTile + (n->TileWidth * data[DATA_FRAME]);
         int rowdiff = Div(n->ScriptTile-n->OriginalTile, 20);
         
         if(rowdiff)
            n->ScriptTile += (rowdiff * (n->TileHeight - 1));
      }
      
      int tempTile = n->ScriptTile;
      
      if (data[DATA_INVIS])
         n->ScriptTile = TILE_INVIS;
      
      Waitframe();
      
      n->ScriptTile = tempTile;
   }

   void EnemyWaitframe(npc n, int data, bool deathAnim) {
      if (deathAnim && n->HP <= 0)
         deathAnimation(n, 142);

      if(++data[DATA_CLK] >= n->ASpeed) {
         data[DATA_CLK] = 0;
         
         if(++data[DATA_FRAME] >= data[DATA_AFRAMES])
            data[DATA_FRAME] = 0;
            
         n->ScriptTile = n->OriginalTile + (n->TileWidth * data[DATA_FRAME]);
         int rowdiff = Div(n->ScriptTile-n->OriginalTile, 20);
         
         if(rowdiff)
            n->ScriptTile += (rowdiff * (n->TileHeight - 1));
      }
      
      int tempTile = n->ScriptTile;
      
      if (data[DATA_INVIS])
         n->ScriptTile = TILE_INVIS;
      
      Waitframe();
      
      n->ScriptTile = tempTile;
   }

   void EnemyWaitframe(npc n, int data, int frames) {
      while(frames--)
         EnemyWaitframe(n, data);
   }

   bool linkClose(npc this, int distance) {
      return Distance(CenterX(this), CenterY(this), CenterLinkX(), CenterLinkY()) < distance; 
   }
   
   void doWalk(npc n, int rand, int homing, int step, bool flying = false) {
      const int ONE_IN_N = 1000;
      
      if (rand >= RandGen->Rand(ONE_IN_N - 1)) {
         // int attemptCounter  = 0;
         
         do {
            n->Dir = RandGen->Rand(3);
            
            if (byEdgeOfScreen(n))
               n->Dir = RandGen->Rand(3);
         } until(n->CanMove(n->Dir, 1, flying ? SPW_FLOATER : SPW_NONE));// || ++attemptCounter > 500);
      }
      else if (homing >= RandGen->Rand(ONE_IN_N - 1))
         n->Dir = RadianAngleDir4(TurnTowards(n->X, n->Y, Hero->X, Hero->Y, 0, 1));
      
      unless (n->Move(n->Dir, step / 100, flying ? SPW_FLOATER : SPW_NONE)) {
         // int attemptCounter  = 0;
         
         do {
            n->Dir = RandGen->Rand(3);
            int forceDir = byEdgeOfScreen(n);
            
            if (forceDir > -1)
               n->Dir = forceDir;
         } until(n->CanMove(n->Dir, 2, flying ? SPW_FLOATER : SPW_NONE));// || ++attemptCounter > 500);
      }
   }
   
   int byEdgeOfScreen(npc n) {
      if (n->Dir == DIR_UP && n->Y < 16) return DIR_DOWN;
      else if (n->Dir == DIR_LEFT && n->X < 16) return DIR_RIGHT;
      else if (n->Dir == DIR_DOWN && n->Y > 144) return DIR_UP;
      else if (n->Dir == DIR_RIGHT && n->X < 224) return DIR_LEFT;
      else return -1;
   }

   float lazyChase(int velocity, int currentPosition, int targetPosition, int acceleration, int topSpeed) {
      return Clamp(velocity + Sign(targetPosition - currentPosition) * acceleration, -topSpeed, topSpeed);
   }

   bool MoveTowardsPoint(npc n, int x, int y, int xDistance, int special, bool center) {
      int nx = n->X + n->HitXOffset + (center ? n->HitWidth/2 : 0);
      int ny = n->Y + n->HitYOffset + (center ? n->HitHeight/2 : 0);
      int dist = Distance(nx, ny, x, y);
      
      if(dist < 0.0010) 
         return false;
      
      return n->MoveAtAngle(RadtoDeg(TurnTowards(nx, ny, x, y, 0, 1)), Min(xDistance, dist), special);
   }

   bool isDifficultyChange(npc n, int maxHp) {
      return n->HP < maxHp * .33;
   }

   int getInvertedDir(int dir) {
      switch(dir) {
         case DIR_UP: return DIR_DOWN;
         case DIR_DOWN: return DIR_UP;
         case DIR_RIGHT: return DIR_LEFT;
         case DIR_LEFT: return DIR_RIGHT;
         case DIR_UPLEFT: return DIR_DOWNRIGHT;
         case DIR_DOWNRIGHT: return DIR_UPLEFT;
         case DIR_UPRIGHT: return DIR_DOWNLEFT;
         case DIR_DOWNLEFT: return DIR_UPRIGHT;
      } 
   }

   bool hitByLWeapon(npc n, int weaponId) {
      if (n->HitBy[HIT_BY_LWEAPON_UID]) {
         if (Screen->LoadLWeapon(n->HitBy[HIT_BY_LWEAPON])->Type == weaponId)
            return true;
         else
            return false;
      }
   }
   
   bool hitByEWeapon(npc n, int weaponId) {      
      if (n->HitBy[HIT_BY_EWEAPON_UID]) {
         if (Screen->LoadEWeapon(n->HitBy[HIT_BY_EWEAPON])->Type == weaponId)
            return true;
         else
            return false;
      }
   }

   int faceLink(npc n) { 
      if (Hero->Y > n->Y) {
         if (Abs(Hero->X - n->X) > Abs(Hero->Y - n->Y)) {
            if (Hero->X > n->X)
               return DIR_RIGHT;
            else
               return DIR_LEFT;
         } 
         else
            return DIR_DOWN;
      } else  {
         if (Abs(Hero->X - n->X) > Abs(Hero->Y - n->Y)) {
            if (Hero->X > n->X)
               return DIR_RIGHT;
            else
               return DIR_LEFT;
         }
         else
            return DIR_UP;
      }
   }
}


















