///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~~~~~The Terror of Necromancy Namespaces~~~~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

#option SHORT_CIRCUIT on
#option BINARY_32BIT off
#option HEADER_GUARD on

namespace EnemyNamespace {		
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

   void deathAnimation(npc n, int deathSound) { // TODO can still hear the normal bomb sfx behind explosions
      n->Immortal = true;
      n->CollDetection = false;
      n->Stun = 9999;

      int baseX = n->X + n->DrawXOffset;
      int baseY = (n->Y + n->DrawYOffset) - (n->Z + n->DrawZOffset);
      
      Audio->PlaySound(deathSound);
      
      for(int i = 0; i < 45; i++) {
         unless (i % 3) {
				lweapon explosion = Screen->CreateLWeapon(LW_BOMBBLAST);
				explosion->X = baseX + RandGen->Rand(16 * n->TileWidth) - 8;
				explosion->Y = baseY + RandGen->Rand(16 * n->TileHeight) - 8;
				explosion->CollDetection = false;
            Audio->EndSound(SFX_BOMB);
				Audio->PlaySound(SFX_POWDER_KEG_BLAST);
         }
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
   
   bool canMove(npc n) { // TODO account for HITWIDTH and HITX/YOffset
      if (n->Y - 1 <= 1 && n->Dir == DIR_DOWN) return false;
      if (n->Y + 1 >= 175 && n->Dir == DIR_UP) return false;
      if (n->X - 1 <= 1 && n->Dir == DIR_RIGHT) return false;
      if (n->X + 1 >= 255 && n->Dir == DIR_LEFT) return false;
      return true;
   }
   
   bool forceDir(npc n) { // TODO account for HITWIDTH and HITX/YOffset
      if (n->Y - 1 <= 1) return DIR_DOWN;
      if (n->Y + 1 >= 175) return DIR_UP;
      if (n->X - 1 <= 1) return DIR_RIGHT;
      if (n->X + 1 >= 255) return DIR_LEFT;
      return false;
   }
   
   void doWalk(npc n, int rand, int homing, int step, bool flying = false) { 
		const int ONE_IN_N = 1000;
		
		if (rand >= RandGen->Rand(ONE_IN_N - 1)) {
			int attemptCounter  = 0;
			
			do {
				n->Dir = RandGen->Rand(3);
			} until(n->CanMove(n->Dir, 1, flying ? SPW_FLOATER : SPW_NONE) || ++attemptCounter > 500);
		}
		else if (homing >= RandGen->Rand(ONE_IN_N - 1))
			n->Dir = RadianAngleDir4(TurnTowards(n->X, n->Y, Hero->X, Hero->Y, 0, 1));
		
		unless (n->Move(n->Dir, step / 100, flying ? SPW_FLOATER : SPW_NONE)) {
			int attemptCounter  = 0;
			
			do {
				n->Dir = RandGen->Rand(3);
			} until(n->CanMove(n->Dir, 1, flying ? SPW_FLOATER : SPW_NONE) || ++attemptCounter > 500);
		}
	}
   
   int byEdgeOfScreen(npc n) {
      if (n->Dir == DIR_UP && n->Y < 16) return DIR_DOWN;
      else if (n->Dir == DIR_LEFT && n->X < 16) return DIR_RIGHT;
      else if (n->Dir == DIR_DOWN && n->Y > 144) return DIR_UP;
      else if (n->Dir == DIR_RIGHT && n->X < 224) return DIR_LEFT;
      else return -1;
   }

   void gridLockNPC(npc n) {
      int remainderX = n->X % 16;
      int remainderY = n->Y % 16;
      
      if (remainderX) {
         if (remainderX < 8)
            n->X -= remainderX;
         else 
            n->X += remainderX;
      }
      
      if (remainderY) {
         if (remainderY < 8)
            n->Y -= remainderY;
         else 
            n->Y += remainderY;
      }
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
      // if (n->HitBy[HIT_BY_EWEAPON_UID]) {
         // if (Screen->LoadEWeapon(n->HitBy[HIT_BY_EWEAPON])->Type == weaponId)
            // return true;
         // else
            // return false;
      // }
      
      if (n->HitBy[HIT_BY_EWEAPON]) {
         if (n->HitBy[HIT_BY_EWEAPON_UID] == weaponId) 
            return true;
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

namespace LeviathanNamespace {
   const int CMB_WATERFALL = 6828;
   const int CS_WATERFALL = 0;

   const int NPC_LEVIATHANHEAD = 177;

   CONFIG SFX_RISE = 67;
   CONFIG SFX_WATERFALL = 26;
   CONFIG SFX_LEVIATHAN_ROAR = SFX_ROAR;
   CONFIG SFX_LEVIATHAN_SPLASH = SFX_SPLASH;
   CONFIG SFX_CHARGE = 35;
   CONFIG SFX_SHOT = 40;

   CONFIG SPR_SPLASH = 93;
   CONFIG SPR_WATERBALL = 94;

   COLOR C_CHARGE1 = C_DARKBLUE;
   COLOR C_CHARGE2 = C_SEABLUE;
   COLOR C_CHARGE3 = C_TAN;

   //TODO Make not a global
   int LEVIATHAN_WATERCANNON_DMG = 60;
   int LEVIATHAN_BURSTCANNON_DMG = 30;
   int LEVIATHAN_WATERFALL_DMG = 50;

   CONFIG MSG_BEATEN = 23;
   CONFIG MSG_LEVIATHAN_SCALE = 1052;

   bool firstRun = true;

   eweapon script Waterfall{
      void run(int width, int peakHeight) {
         this->UseSprite(94);
         
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
         int bgHeight;
         int fgHeight;
         this->CollDetection = false;
         
         while(waterfallTop > peakHeight) {
            waterfallTop = Max(waterfallTop - 1.5, peakHeight);
            bgHeight = waterfallBottom - waterfallTop;
            
            for (int i = 0; i < width; ++i) {
               int xWithOffset = startX - (width - 1) * 8 + i * 16;
               waterfallBitmap->Blit(0, -2, 0, 0, 16, bgHeight, xWithOffset, waterfallTop, 16, bgHeight, 0, 0, 0, BITDX_NORMAL, 0, false);
            }
            
            Waitframe();
         }
         
         bgHeight = waterfallBottom-waterfallTop;
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
               waterfallBitmap->Blit(4, -2, 16, 175-fgHeight, 16, fgHeight, xWithOffset, peakHeight, 16, fgHeight, 0, 0, 0, BITDX_NORMAL, 0, false);
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
            fgHeight = waterfallBottom-waterfallTop;
            
            for (int i = 0; i < width; ++i) {
               int xWithOffset = startX - (width - 1) * 8 + i * 16;
               waterfallBitmap->Blit(4, -2, 16, 175 - fgHeight, 16, fgHeight, xWithOffset, waterfallTop, 16, fgHeight, 0, 0, 0, BITDX_NORMAL, 0, false);
            }
            
            Waitframe();
         }
         
         this->DeadState = 0;
         
         if(hitbox->isValid())
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
         
         while(true) {
            timer += speed;
            timer %= 360;
            
            x += RadianCos(this->Angle) * this->Step * 0.01;
            y += RadianSin(this->Angle) * this->Step * 0.01;
            
            dist = Sin(timer) * size;
            
            this->X = x + VectorX(dist, RadtoDeg(this->Angle) - 90);
            this->Y = y + VectorY(dist, RadtoDeg(this->Angle) - 90);
            
            if(noBlock)
               this->Dir = Hero->Dir;
            
            Waitframe();
         }
      }
   }
}

namespace ShamblesNamespace {
   CONFIG ATTACK_INITIAL_RUSH = -1;
   CONFIG ATTACK_LINK_CHARGE = 0;
   CONFIG ATTACK_BOMB_LOB = 1;
   CONFIG ATTACK_SPAWN_ZAMBIES = 2;
   
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

   int chooseAttack(int attack) {
      if (Screen->NumNPCs() >= 4) {
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

namespace HazarondNamespace {
   using namespace EnemyNamespace;
   
   bool firstRun = true;

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

namespace OvergrownRaccoonNamespace {
   using namespace EnemyNamespace;
   
   enum State {
      STATE_NORMAL,
      STATE_SMALL_ROCKS_THROW,
      STATE_LARGE_ROCK_THROW,
      STATE_RACCOON_THROW,
      STATE_CHARGE
   };

   State parseAttackChoice(int attackChoice) {
      switch(attackChoice) {
         case 0: 
            return STATE_NORMAL;
         case 1:
            return STATE_SMALL_ROCKS_THROW;
         case 2:
            return STATE_LARGE_ROCK_THROW;
         case 3:
            return STATE_RACCOON_THROW;
         case 4:
            return STATE_CHARGE;
      }
   }
}

namespace ServusMalusNamespace {
   using namespace EnemyNamespace;
   
   void checkTorchBrightness(int litTorchCount, combodata cmbLitTorch, int mode = 0) {
      switch(mode) {
         case 0:
            switch(litTorchCount) {
               case 0: 
               case 1:
                  cmbLitTorch->Attribytes[0] = 36;
                  return;
               case 2:
                  cmbLitTorch->Attribytes[0] = 40;
                  return;
               case 3:
                  cmbLitTorch->Attribytes[0] = 58;
                  return;
               case 4:
                  cmbLitTorch->Attribytes[0] = 64;
                  return;
            }
            break;
         case 1:
            switch(litTorchCount) {
               case 0: 
               case 1:
                  cmbLitTorch->Attribytes[0] = 12;
                  return;
               case 2:
                  cmbLitTorch->Attribytes[0] = 16;
                  return;
               case 3:
                  cmbLitTorch->Attribytes[0] = 20;
                  return;
               case 4:
                  cmbLitTorch->Attribytes[0] = 24;
                  return;
            }
            break;
      }
   }
   
   void spawnEnemy(npc this) {
      for (int i = 0; i < 30; ++i)
         Waitframe();
         
      Game->PlaySound(SFX_MIRROR_SHIELD_ABSORB_LOOP);
      
      for (int i = 0; i <= 30; ++i) {
         unless (i % 5)
            i < 15 ? this->Z-- : this->Z++;
            
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
   
   void chooseAttack(npc this, int originalTile, int attackingTile, int unarmedTile, bool gettingDesperate) {
      if (Distance(this->X, this->Y, Hero->X, Hero->Y) <= (gettingDesperate ? 49 : 48))
         scytheSlash(this, originalTile, attackingTile, unarmedTile, gettingDesperate);
         
      if (Distance(this->X, this->Y, Hero->X, Hero->Y) > (gettingDesperate ? 48 : 49))
         scytheThrow(this, originalTile, attackingTile, unarmedTile, gettingDesperate);
   }
   
   void scytheSlash(npc this, int originalTile, int attackingTile, int unarmedTile, bool gettingDesperate) {
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
            
            sword2x1(this->X + 8, this->Y + 8, angle + Lerp((attackCount % 2 ? -90 : 90), (attackCount % 2 ? 90 : -90), i / 14), 16, 6944, 3, 5);
            
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
   
   void scytheThrow(npc this, int originalTile, int attackingTile, int unarmedTile, bool gettingDesperate) {
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
            scythe->Damage = 7;
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
               scythe2->Damage = 8;
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
            
            while(scythe2->isValid() || scythe->isValid())
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
      // int lscr = CheckLWeaponScript("LwWindBlast");
      
      Audio->PlaySound(SFX_ONOX_TORNADO);
      this->OriginalTile = attackingTile;
      
      for (int i = 0; i < 15; i++) {
         unless (i % 5) {
            switch(this->Dir) {
               case DIR_UP:
                  this->Dir = DIR_RIGHT;
                  break;
               case DIR_DOWN:
                  this->Dir = DIR_LEFT;
                  break;
               case DIR_RIGHT:
                  this->Dir = DIR_DOWN;
                  break;
               case DIR_LEFT:
                  this->Dir = DIR_UP;
                  break;
            }
         }
         Waitframe();
      }
         
      if(escr) { // && lscr) {
         WindHandler.init();
         
         for(int i = 0; i < wc; ++i) {
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
         for(int i = 0; i < 360;) {
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
         until(this->Misc[0])
            Waitframe();
         
         int catchCounter = 0;
         
         while(this->isValid()) {
            unless (Screen->isSolid(this->X, this->Y)
               || Screen->isSolid(this->X + 15, this->Y)
               || Screen->isSolid(this->X, this->Y + 15)
               || Screen->isSolid(this->X + 15, this->Y + 15)
               || this->X < 0 || this->X > 240 || this->Y < 0 || this->Y > 160
            ) {
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

   lweapon script LwWindBlast {
      void run() {
         untyped arr[600];
         
         this->Misc[0] = arr;
      
         until(arr[0])
            Waitframe();
         
         while(this->isValid()) {
            for (int q = 1; q <= arr[0]; ++q) {
               npc n = arr[q];
               
               unless (n->isValid())
                  continue;
                  
               n->X = this->X;
               n->Y = this->Y;
               n->Stun = 2;
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
         // int lwWindBlast = CheckLWeaponScript("LwWindBlast");
         
         while(true) {
            switch(WaitEvent()) {
               case GENSCR_EVENT_HERO_HIT_1:
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
               // case GENSCR_EVENT_ENEMY_HIT2: 
                  // npc n = Game->EventData[GENEV_EHIT_NPCPTR];
                  
                  // lweapon weapon = Game->EventData[GENEV_EHIT_LWPNPTR];

                  // if (weapon->Script != lwWindBlast)
                     // break;
                     
                  // Game->EventData[GENEV_EHIT_NULLIFY] = true;
                  
                  // if (n->Stun)
                     // break;
                     
                  // untyped arr = weapon->Misc[0];
                  // arr[++arr[0]] = n;
                  // n->Stun = 2;
                  
                  // break;
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
         shieldHp = 30;
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
   
   void EgentemWaitframe(npc this, Egentem egentem, int frames = 1) {
      for (int i = 0; i < frames; ++i) {
         if (this->HP <= 0)
            egentemDeathAnimation(this, SFX_OOT_STALFOS_DIE);
            
         handleShieldDamage(this, egentem);
         Waitframe(this);
      }
   }
   
   void egentemDeathAnimation(npc n, int deathSound) { // TODO can still hear the normal bomb sfx behind explosions
      n->Immortal = true;
      n->CollDetection = false;
      n->Stun = 9999;

      int baseX = n->X + n->DrawXOffset;
      int baseY = (n->Y + n->DrawYOffset) - (n->Z + n->DrawZOffset);
      
      Audio->PlaySound(deathSound);
      
      for(int i = 0; i < 45; i++) {
         unless (i % 3) {
				lweapon explosion = Screen->CreateLWeapon(LW_BOMBBLAST);
				explosion->X = baseX + RandGen->Rand(16 * n->TileWidth) - 8;
				explosion->Y = baseY + RandGen->Rand(16 * n->TileHeight) - 8;
				explosion->CollDetection = false;
            Audio->EndSound(SFX_BOMB);
				Audio->PlaySound(SFX_POWDER_KEG_BLAST);
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
               Audio->PlaySound(SFX_BOMB_BLAST);
               AnimHandler aptr = GetAnimHandler(this);
               
               switch(aptr->GetCurAnim()) {
                  case WALKING:
                  case WALKING_SH:
                     playAnim(aptr, egentem, WALKING);
                     break;
                  case STANDING:
                  case STANDING_SH:
                     playAnim(aptr, egentem, STANDING);
                     break;
               }
               
            } else {
               Audio->PlaySound(SFX_SWORD_ROCK3);
            }
         }
      }
      
   }
   
   void playAnim(AnimHandler aptr, Egentem egentem, int anim) {
      if (egentem->shieldHp > 0) {
         switch(anim) {
            case WALKING:
               anim = WALKING_SH;
               break;
            case STANDING:
               anim = STANDING_SH;
               break;
         }
      }
      
      aptr->PlayAnim(anim);
   }
   
   void closeShutters(npc this) {
      while(Hero->Y < 16) {
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
      
      while (Hero->Y > 128 || Hero->Y < 112)
         Waitframe();
      
      this->X = 120;
      this->Y = -16;
      this->Dir = DIR_DOWN;
      
      AnimHandler aptr = GetAnimHandler(this);
      aptr->PlayAnim(WALKING);
      Hero->Dir = DIR_UP;
      
      for (int i = 0; i < 90; ++i) {
         disableLink();
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
               eweapon weap = RunEWeaponScriptAt(EW_SCRIPT10, escr, xy->X, xy->Y, { 49852 });
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
      
      switch(this->Dir) {
         case DIR_UP:
            switch(frame) {
               case 0:
                  y -= 14;
                  break;
               case 1:
                  y -= 12;
                  break;
               case 2:
                  y -= 13;
                  break;
            }
            break;
         case DIR_DOWN:
            switch(frame) {
               case 0:
                  y -= 12;
                  break;
               case 1:
                  y += 4;
                  break;
               case 2:
                  y += 14;
                  break;
            }
            break;
         case DIR_LEFT:
            switch(frame) {
               case 0:
                  y -= 14;
                  break;
               case 1:
                  x -= 12;
                  y -= 12;
                  break;
               case 2:
                  x -= 14;
                  break;
            }
            break;
         case DIR_RIGHT:
            switch(frame) {
               case 0:
                  y -= 14;
                  break;
               case 1:
                  x += 12;
                  y -= 12;
                  break;
               case 2:
                  x += 14;
                  break;
            }
            break;
      }
      
      unless (doNothing) {
         eweapon hammer = FireEWeapon(EW_SCRIPT10, x, y, 0, 0, damage, 0, 0, EWF_UNBLOCKABLE);
         hammer->ScriptTile = TILE_HAMMER + 3 * this->Dir + frame;
         hammer->CSet = CSET_HAMMER;
         // hammer->Behind = true;
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
               Audio->PlaySound(SFX_BOMB_BLAST);
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
      
      hammerAnimHoldUp(this, xy, 30);
      hammerAnimSwing(this, xy);
      
      int offset = Rand(360);
      
      for (int i = 0; i < 8; ++i) {
         eweapon wave = RunEWeaponScriptAt(EW_SCRIPT10, shockwaveSlot, xy->X, xy->Y, 
            {137, SFX_WALL_SMASH, 8, SFX_ARIN_SPLAT, 136, 8, offset + i * 45, false}
         );
         wave->Damage = this->WeaponDamage;
         wave->Unblockable = UNBLOCK_ALL;
      }
      
      hammerAnimSmash(this, xy, 45);
      
      int angle = Angle(Hero->X, Hero->Y, this->X, this->Y);
      
      playAnim(aptr, egentem, WALKING);
      
      for (int i = 0; i < 30; ++i) {
         this->MoveAtAngle(angle, 2, SPW_NONE);
         
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
      
      unless (closestPillar->isValid())
         return;
         
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
         Audio->PlaySound(SFX_BOMB_BLAST);
         
         for (int i = 0; i < this->NumFrames * this->ASpeed - 1; ++i) {
            this->DeadState = WDS_ALIVE;
            Waitframe();
         }
         
         this->Tile = this->OriginalTile;
         this->NumFrames = 1;
         this->ASpeed = 0;
         
         while(upTime > 0 || this->InitD[D_NO_DIE]) {
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
            this->UseSprite(57); //TODO set to constant
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
      
         until (Screen->SecretsTriggered())
            Waitframe();

         // Audio->PlaySound(/*some laughing thing*/);
         Audio->PlayEnhancedMusic(NULL, 0);
         setScreenD(0, true);
      }
   }
}

namespace WaterPathsNamespace {
   typedef const int DEFINE;
   typedef const int CONFIG;
   typedef const bool CONFIGB;

   CONST_ASSERT(MAX_PATHS > 1 && MAX_PATHS <= 32, "[WaterPaths] MAX_PATHS must be between 2 and 32!");

   enum Fluid {
      FL_EMPTY,
      FL_PURPLE,
      FL_FLAMING,
      FL_SZ
   };

   //start CONSTANTS
   CONFIGB WP_DEBUG = false;
   CONFIG COMBO_FLUID_EMPTY = 3263;
   CONFIG COMBO_SOLID_PURPLE = 3259;
   CONFIG COMBO_NON_SOLID_PURPLE = 3267;
   CONFIG COMBO_SOLID_FLAMING = 3255;
   CONFIG COMBO_NON_SOLID_FLAMING = 3255;

   CONFIG CT_FLUID = CT_SCRIPT2;
   CONFIG MAX_PATHS = 32;
   DEFINE SZ_PATHSTATES = MAX_PATHS * 2 + 1;
   DEFINE UPDATE_PATHS = SZ_PATHSTATES - 1;

   untyped pathStates[SZ_PATHSTATES];
   long fluidConnections[MAX_DMAPS * MAX_PATHS];

   CONFIG CMB_TL_OUTER = 3248;
   CONFIG CMB_TR_OUTER = 3250;
   CONFIG CMB_BL_OUTER = 3256;
   CONFIG CMB_BR_OUTER = 3258;
   CONFIG CMB_TL_INNER = 3265;
   CONFIG CMB_TR_INNER = 3264;
   CONFIG CMB_BL_INNER = 3261;
   CONFIG CMB_BR_INNER = 3260;
   CONFIG CMB_TOP = 3249;
   CONFIG CMB_BOTTOM = 3257;
   CONFIG CMB_LEFT = 3252;
   CONFIG CMB_RIGHT = 3254;
   CONFIG CMB_BARRIER_HORZ = 3262;
   CONFIG CMB_BARRIER_VERT = 3266;
   CONFIG CMB_BARRIER_TOP = 3244;
   CONFIG CMB_BARRIER_BOTTOM = 3245;
   CONFIG CMB_BARRIER_RIGHT = 3247;
   CONFIG CMB_BARRIER_LEFT = 3246;
   CONFIG CMB_SOLID_INVIS = 2;
   //end

   DEFINE ATTBU_FLUIDPATH = 0;
   DEFINE VAL_BARRIER = -1;

   @Author("EmilyV99")
   dmapdata script WaterPaths {
      /**layers form: 0101010b (layers 6543210, 1 for on 0 for off. 2 layers exactly should be enabled.)
       * Sources form: val.fluid (i.e. to set key 1 to a source of fluid 1 would be 1.0001)
       * Fluid 0 is always air, and can never have a 'source'
       * Combos on the second-highest enabled layer of type 'CT_FLUID' will be scanned.
       *     The 'Attribute[ATTBU_FLUIDPATH]' will be used to determine what a given combo represents.
       *     ~~ Positive values represent liquid in a given path (values > MAX_PATHS are invalid)
       *     ~~ -1 represents barriers between paths
       *     ~~ Any other value will cause the combo to be ignored.
       */
       
      enum {
         PASS_LIQUID,
         PASS_BARRIERS,
         PASS_COUNT
      };
      
      void run(int layers, int source1, int source2, int source3, int source4, int source5, int source6, int source7) {
         Waitframes(2);
         
         if (WP_DEBUG) 
            printf("Running DM script WaterPaths (%d,%d,%d,%d,%d,%d,%d,%d)\n", layers, source1, source2, source3, source4, source5, source6, source7);
         
         int sources[] = {source1, source2, source3, source4, source5, source6, source7};
         memset(pathStates, 0, SZ_PATHSTATES);
         
         for (int layer = 0; layer < 7; ++layer) {
            unless(sources[layer] % 1 && sources[layer] > 1)
               continue;
               
            Fluid fluid = <Fluid>((sources[layer] % 1) / 1L);
            
            unless(fluid > 0 && fluid < FL_SZ)
               continue;
            
            pathStates[MAX_PATHS + Floor(sources[layer] - 1)] = fluid;
         }
         
         updateFluidFlow();
         
         int layer1, layer2;
         
         // calculate layers
         for (int layer = 6; layer >= 0; --layer) {
            if (layers & (1b << layer)) {
               if (layer2) {
                  layer1 = layer;
                  break;
               } else 
                  layer2 = layer;
            }
         }
         
         int screen = -1;
         
         while (true) {
            //if screen has a FL_FLAMING play sound 117 or 160
            
            if (screen != Game->GetCurScreen() || pathStates[UPDATE_PATHS]) {
               screen = Game->GetCurScreen();
               pathStates[UPDATE_PATHS] = false;
               
               mapdata currentMapMapata = Game->LoadMapData(Game->GetCurMap(), Game->GetCurScreen());
               
               mapdata currentMapLayer1 = Emily::loadLayer(currentMapMapata, layer1);
               mapdata currentMapLayer2 = Emily::loadLayer(currentMapMapata, layer2);
               mapdata templateLeft, templateRight, templateUp, templateDown;
               
               unless(Game->GetCurScreen() < 0x10)
                  templateUp = Emily::loadLayer(Game->LoadMapData(Game->GetCurMap(), Game->GetCurScreen() - 0x10), layer1);
               unless(Game->GetCurScreen() >= 0x70)
                  templateDown = Emily::loadLayer(Game->LoadMapData(Game->GetCurMap(), Game->GetCurScreen() + 0x10), layer1);
               if (Game->GetCurScreen() % 0x10)
                  templateLeft = Emily::loadLayer(Game->LoadMapData(Game->GetCurMap(), Game->GetCurScreen() - 1), layer1);
               unless(Game->GetCurScreen() % 0x10 == 0xF)
                  templateRight = Emily::loadLayer(Game->LoadMapData(Game->GetCurMap(), Game->GetCurScreen() + 1), layer1);
            
               mapdata layer1Template = Game->LoadTempScreen(layer1);
               mapdata layer2Template = Game->LoadTempScreen(layer2);
               
               for (int pass = 0; pass < PASS_COUNT; ++pass) {
                  for (int combo = 0; combo < 176; ++combo) {
                     if (currentMapLayer1->ComboT[combo] != CT_FLUID)
                        continue;
                     
                     combodata comboData = Game->LoadComboData(currentMapLayer1->ComboD[combo]);
                     int flag = comboData->Attributes[ATTBU_FLUIDPATH];
                     
                     switch(pass) {
                        case PASS_LIQUID:
                           unless(flag > 0)
                              continue;
                           break;
                        case PASS_BARRIERS:
                           unless(flag == VAL_BARRIER) 
                              continue;
                           break;
                     }
                        
                     int up, down, left, right;
                     
                     unless(combo < 0x10)
                        up = Game->LoadComboData(currentMapLayer1->ComboD[combo - 0x10])->Attributes[ATTBU_FLUIDPATH];
                     else if (templateUp)
                        up = Game->LoadComboData(templateUp->ComboD[combo + 0x90])->Attributes[ATTBU_FLUIDPATH];
                     
                     unless(combo >= 0xA0)
                        down = Game->LoadComboData(currentMapLayer1->ComboD[combo + 0x10])->Attributes[ATTBU_FLUIDPATH];
                     else if (templateDown)
                        down = Game->LoadComboData(templateDown->ComboD[combo - 0x90])->Attributes[ATTBU_FLUIDPATH];
                     
                     if (combo % 0x10) 
                        left = Game->LoadComboData(currentMapLayer1->ComboD[combo - 1])->Attributes[ATTBU_FLUIDPATH];
                     else if (templateLeft) 
                        left = Game->LoadComboData(templateLeft->ComboD[combo + 0xF])->Attributes[ATTBU_FLUIDPATH];
                     
                     unless(combo % 0x10 == 0xF) 
                        right = Game->LoadComboData(currentMapLayer1->ComboD[combo + 1])->Attributes[ATTBU_FLUIDPATH];
                     else if (templateRight)
                        right = Game->LoadComboData(templateRight->ComboD[combo - 0xF])->Attributes[ATTBU_FLUIDPATH];
                     
                     // Standard fluid
                     if (flag > 0) {
                        int cmb = -1;
                        
                        //all same
                        if (isBarrierFlag(up, flag) && isBarrierFlag(down, flag) && isBarrierFlag(left, flag) && isBarrierFlag(right, flag)) {
                           // Inner Corners
                           int upperLeft, upperRight, lowerLeft, lowerRight;
                           
                           if (combo > 0xF && combo % 0x10)
                              upperLeft = Game->LoadComboData(currentMapLayer1->ComboD[combo - 0x11])->Attributes[ATTBU_FLUIDPATH];
                           else if (combo < 0x10 && combo % 0x10)
                              upperLeft = Game->LoadComboData(templateUp->ComboD[combo + 0x8F])->Attributes[ATTBU_FLUIDPATH];
                           else if (combo > 0xF && !(combo % 0x10))
                              upperLeft = Game->LoadComboData(templateLeft->ComboD[combo - 1])->Attributes[ATTBU_FLUIDPATH];
                           
                           if (combo > 0xF && (combo % 0x10) != 0xF)
                              upperRight = Game->LoadComboData(currentMapLayer1->ComboD[combo - 0xF])->Attributes[ATTBU_FLUIDPATH];
                           else if (combo < 0x10 && (combo % 0x10) != 0xF)
                              upperRight = Game->LoadComboData(templateUp->ComboD[combo + 0x91])->Attributes[ATTBU_FLUIDPATH];
                           else if (combo > 0xF && (combo % 0x10) == 0xF)
                              upperRight = Game->LoadComboData(templateRight->ComboD[combo - 0x1F])->Attributes[ATTBU_FLUIDPATH];
                           
                           if (combo < 0xA0 && combo % 0x10)
                              lowerLeft = Game->LoadComboData(currentMapLayer1->ComboD[combo + 0xF])->Attributes[ATTBU_FLUIDPATH];
                           else if (combo > 0x9F && combo % 0x10)
                              lowerLeft = Game->LoadComboData(templateDown->ComboD[combo - 0x91])->Attributes[ATTBU_FLUIDPATH];
                           else if (combo < 0xA0 && !(combo % 0x10))
                              lowerLeft = Game->LoadComboData(templateLeft->ComboD[combo + 0x1F])->Attributes[ATTBU_FLUIDPATH];
                           
                           if (combo < 0xA0 && (combo % 0x10) != 0xF)
                              lowerRight = Game->LoadComboData(currentMapLayer1->ComboD[combo + 0x11])->Attributes[ATTBU_FLUIDPATH];
                           else if (combo > 0x9F && (combo % 0x10) != 0xF)
                              lowerRight = Game->LoadComboData(templateDown->ComboD[combo - 0x8F])->Attributes[ATTBU_FLUIDPATH];
                           else if (combo < 0xA0 && (combo % 0x10) == 0xF)
                              lowerRight = Game->LoadComboData(templateRight->ComboD[combo + 0x01])->Attributes[ATTBU_FLUIDPATH];
                              
                           unless(isBarrierFlag(upperLeft, flag) || !(isBarrierFlag(upperRight, flag) && isBarrierFlag(lowerLeft, flag) && isBarrierFlag(lowerRight, flag)))
                              cmb = CMB_TL_INNER;
                           else unless(isBarrierFlag(upperRight, flag) || !(isBarrierFlag(upperLeft, flag) && isBarrierFlag(lowerLeft, flag) && isBarrierFlag(lowerRight, flag)))
                              cmb = CMB_TR_INNER;
                           else unless(isBarrierFlag(lowerLeft, flag) || !(isBarrierFlag(upperRight, flag) && isBarrierFlag(upperLeft, flag) && isBarrierFlag(lowerRight, flag)))
                              cmb = CMB_BL_INNER;
                           else unless(isBarrierFlag(lowerRight, flag) || !(isBarrierFlag(upperRight, flag) && isBarrierFlag(lowerLeft, flag) && isBarrierFlag(upperLeft, flag)))
                              cmb = CMB_BR_INNER;
                           else
                              cmb = 0;
                        }
                        // up
                        else if (isBarrierFlag(up, flag)) {
                           // upleft
                           if (isBarrierFlag(left, flag)) {
                              //upleft, notdown
                              unless(isBarrierFlag(down, flag)) {
                                 //upleftright, notdown
                                 if (isBarrierFlag(right, flag)) 
                                    cmb = CMB_BOTTOM;
                                 //upleft, notrightdown
                                 else 
                                    cmb = CMB_BR_OUTER;
                              }
                              //upleftdown, notright
                              else unless(isBarrierFlag(right, flag)) 
                                 cmb = CMB_RIGHT;
                           }
                           // up not-left
                           else {
                              // upright, notleft
                              if (isBarrierFlag(right, flag)) {
                                 //upright, notdownleft
                                 unless(isBarrierFlag(down, flag)) 
                                    cmb = CMB_BL_OUTER;
                                 //uprightdown, notleft
                                 else 
                                    cmb = CMB_LEFT;
                              }
                           }
                        }
                        // notup
                        else {
                           // right, notup
                           if (isBarrierFlag(right,flag)) {
                              //rightdown, notup
                              if (isBarrierFlag(down, flag)) {
                                 //rightdownleft, notup
                                 if (isBarrierFlag(left, flag)) 
                                    cmb = CMB_TOP;
                                 //rightdown, notleftup
                                 else 
                                    cmb = CMB_TL_OUTER;
                              }
                           }
                           // notrightup
                           else {
                              //down, notrightup
                              if (isBarrierFlag(down, flag))
                                 //leftdown, notrightup
                                 if (isBarrierFlag(left, flag)) 
                                    cmb = CMB_TR_OUTER;
                           }
                        }
                        
                        if (cmb > -1) {
                           layer1Template->ComboD[combo] = getCombo(getFluid(flag), cmb > 0);
                           layer2Template->ComboD[combo] = cmb;
                           layer2Template->ComboC[combo] = currentMapLayer1->ComboC[combo];
                        }
                        else if (WP_DEBUG)
                           printf("[WaterPaths] Error: Bad combo calculation for fluid pos %d (f: %d, udlr: %d,%d,%d,%d)\n", combo, flag, up, down, left, right);
                        
                     }
                     // Barriers
                     else if (flag == VAL_BARRIER) {
                        int cmb = -1;
                        int flowpath = 0;
                        bool flowing = false;
                        
                        // horizontal barrier
                        if (up > 0 && down > 0 && left < 1 && right < 1)  {
                           flowing = getConnection(Game->GetCurLevel(), up, down);
                           
                           if (flowing)
                              flowpath = up;
                           
                           if (left == VAL_BARRIER) {
                              //Center
                              if (right == VAL_BARRIER) {
                                 if (flowing)
                                    cmb = 0;
                                 else {
                                    cmb = CMB_BARRIER_HORZ;
                                    
                                    if (CMB_SOLID_INVIS) {
                                       if (combo >= 0x10) {
                                          layer1Template->ComboD[combo - 0x10] = getCombo(getFluid(up), true); 
                                          layer2Template->ComboD[combo - 0x10] = CMB_SOLID_INVIS;
                                       }
                                       if (combo < 0xA0) {
                                          layer1Template->ComboD[combo + 0x10] = getCombo(getFluid(down), true); 
                                          layer2Template->ComboD[combo + 0x10] = CMB_SOLID_INVIS;
                                       }
                                    }
                                 }
                              }
                              // Left
                              else {
                                 if (flowing)
                                    cmb = CMB_RIGHT;
                                 else
                                    cmb = CMB_BARRIER_RIGHT;
                              }
                           }
                           //Right
                           else if (right == VAL_BARRIER) {
                              if (flowing)
                                 cmb = CMB_LEFT;
                              else
                                 cmb = CMB_BARRIER_LEFT;
                           }
                        }
                        // vertical barrier
                        else if (left > 0 && right > 0 && up < 1 && down < 1) {
                           flowing = getConnection(Game->GetCurLevel(), left, right);
                           
                           if (flowing)
                              flowpath = left;
                           
                           if (up == VAL_BARRIER) {
                              // Center
                              if (down == VAL_BARRIER) {
                                 if (flowing)
                                    cmb = 0;
                                 else {
                                    cmb = CMB_BARRIER_VERT;
                                    
                                    if (CMB_SOLID_INVIS) {
                                       if (combo % 0x10) {
                                          layer1Template->ComboD[combo-1] = getCombo(getFluid(left), true); 
                                          layer2Template->ComboD[combo-1] = CMB_SOLID_INVIS;
                                       }
                                       if (combo % 0x10 < 0x0F) {
                                          layer1Template->ComboD[combo+1] = getCombo(getFluid(right), true); 
                                          layer2Template->ComboD[combo+1] = CMB_SOLID_INVIS;
                                       }
                                    }
                                 }
                              }
                              // Up
                              else {
                                 if (flowing)
                                    cmb = CMB_BOTTOM;
                                 else
                                    cmb = CMB_BARRIER_BOTTOM;
                              }
                           }
                           //Down
                           else if (down == VAL_BARRIER) {
                              if (flowing)
                                 cmb = CMB_TOP;
                              else
                                 cmb = CMB_BARRIER_TOP;
                           }
                        }
                        if (cmb > -1) {
                           if (flowpath)
                              layer1Template->ComboD[combo] = getCombo(getFluid(flowpath), cmb > 0);
                                                         
                           layer2Template->ComboD[combo] = cmb;
                           layer2Template->ComboC[combo] = currentMapLayer1->ComboC[combo];
                        }
                        else if (WP_DEBUG)
                           printf("[WaterPaths] Error: Bad combo calculation for barrier pos %d (f: %d, udlr: %d,%d,%d,%d)\n", combo, flag, up, down, left, right);
                        
                     }
                  }
               }
            }
            
            Waitframe();
         }
      }	
   }

   int getCombo(Fluid fluid, bool solid) {
      switch(fluid) {
         case FL_EMPTY:
            return COMBO_FLUID_EMPTY;
         case FL_PURPLE:
            return solid ? COMBO_SOLID_PURPLE : COMBO_NON_SOLID_PURPLE;
         case FL_FLAMING:
            return solid ? COMBO_SOLID_FLAMING : COMBO_NON_SOLID_FLAMING;
      }
      
      if (WP_DEBUG)
         printf("[WaterPaths] ERROR: Invalid fluid '%d' passed to 'getCombo'\n");
         
      return 0;
   }

   Fluid getFluid(int path) {
      if (path < 1 || path >= MAX_PATHS)
         return <untyped>(-1);
         
      return pathStates[path - 1];
   }

   Fluid getSource(int path) {
      if (path < 1 || path >= MAX_PATHS)
         return <untyped>(-1);
         
      return pathStates[path - 1 + MAX_PATHS];
   }

   int getConnection(int level, int path) {
      return fluidConnections[level * 512 + path - 1];
   }

   bool getConnection(int level, int path1, int path2) {
      return fluidConnections[level * 512 + path1 - 1] & 1L << (path2 - 1);
   }

   void setConnection(int level, int path1, int path2, bool connect) {
      if (WP_DEBUG)
         printf("Try connect: LVL %d, (%d <> %d) %s\n", level, path1 - 1, path2 - 1, connect ? "true" : "false");
      
      if (path1 == path2) return; //Can't connect to self
      --path1;
      --path2; //From 1-indexed to 0-indexed
      
      if (connect) {
         fluidConnections[level * 512 + path1] |= 1L << path2;
         fluidConnections[level * 512 + path2] |= 1L << path1;
      } else {
         fluidConnections[level * 512 + path1] ~= 1L << path2;
         fluidConnections[level * 512 + path2] ~= 1L << path1;
      }
   }

   void updateFluidFlow() {
      memcpy(pathStates, 0, pathStates, MAX_PATHS, MAX_PATHS); //Set to default sources
      
      DEFINE MAX_PATH_PAIRS = MAX_PATHS * (MAX_PATHS - 1) + 1;
      int pathPairs1[MAX_PATH_PAIRS];
      int pathPairs2[MAX_PATH_PAIRS];
      
      //Cache the pairs of connected paths, so they don't need to be repeatedly calculated 
      int index = 0;
      
      for (int path1 = 0; path1 < MAX_PATHS; ++path1) {
         int connection = getConnection(Game->GetCurLevel(), path1 + 1);
         
         unless(connection)
            continue;
            
         for (int path2 = path1 + 1; path2 < MAX_PATHS; ++path2)  {
            unless(connection & (1L << path2))
               continue;
            
            if (WP_DEBUG)
               printf("Found pair: %d,%d\n", path1, path2);
               
            pathPairs1[index] = path1;
            pathPairs2[index++] = path2;
         }
      }
      
      pathPairs1[index] = -1;
      bool flowTriggered;
      
      do {
         flowTriggered = false;
         
         for (int q = 0; pathPairs1[q] > -1; ++q)
            if (flow(pathPairs1[q], pathPairs2[q]))
               flowTriggered = true;
      } while (flowTriggered);
      
      pathStates[UPDATE_PATHS] = true;
   }

   bool flow(int path1, int path2) {
      Fluid fluid1 = pathStates[path1];
      Fluid fluid2 = pathStates[path2];
      
      if (WP_DEBUG)
         printf("Checking flow between [%d] (%d) and [%d] (%d)\n", path1, fluid1, path2, fluid2);
      
      if (fluid1 == fluid2) 
         return false;
      
      if (WP_DEBUG)
         printf("Flow occurring: %d != %d\n", fluid1, fluid2);
         
      //Special fluid mixing logic can occur here, for now the higher value simply flows
      if (fluid1 < fluid2) {
         if (WP_DEBUG)
            printf("%d<%d, setting [%d] = %d\n", fluid1, fluid2, path1, fluid2); 
         
         pathStates[path1] = fluid2;
      } else {
         if (WP_DEBUG)
            printf("%d>%d, setting [%d] = %d\n", fluid1, fluid2, path2, fluid1);
            
         pathStates[path2] = fluid1;
      }
      
      return true;
   }

   bool isBarrierFlag(int fluid, int barrierFlag) {
      return fluid == VAL_BARRIER || fluid == barrierFlag;
   }

   @Author("EmilyV99")
   ffc script SecretsTriggersWaterPaths {
      void run(int path1, int pathActivated) {
         if (WP_DEBUG)
            printf("STWP: Start %d,%d\n", path1, pathActivated);
            
         if (Screen->State[ST_SECRET])
            return;
         
         unless(path1 > 0 && path1 <= MAX_PATHS && pathActivated > 0 && pathActivated <= MAX_PATHS) {
            if (WP_DEBUG)
               printf("[WaterPaths] FFC %d invalid setup; first 2 params must both be >0 and <=MAX_PATHS(%d)\n", this->ID, MAX_PATHS);
            return;
         }
         
         if (WP_DEBUG)
            printf("STWP: Begin waiting for secret trigger\n");
         
         until (Screen->State[ST_SECRET])
            Waitframe();
            
         if (WP_DEBUG)
            printf("STWP: Secrets Triggered. Setting connection %d,%d\n", path1, pathActivated);
            
         setConnection(Game->GetCurLevel(), path1, pathActivated, true);
         
         updateFluidFlow();
      }
   }

   @Author("EmilyV99")
   ffc script TorchLight {
      using namespace WaterPathsNamespace;

      void run(int litCombo, int path) {
         until(getFluid(path) == FL_FLAMING)
            Waitframe();
            
         this->Data = litCombo;
      }
   }

   @Author("EmilyV99")
   ffc script ActivateTorches {
      using namespace WaterPathsNamespace;

      void run(int p1, int p2, int p3, int p4) {
         if (Screen->State[ST_SECRET])
            return;
            
         until(getFluid(p1) == FL_FLAMING && getFluid(p2) == FL_FLAMING && getFluid(p3) == FL_FLAMING && getFluid(p4) == FL_FLAMING)
            Waitframe();
            
         Screen->TriggerSecrets();
         Screen->State[ST_SECRET] = true;
         Audio->PlaySound(SFX_SECRET);
      }
   }

   @Author("EmilyV99")
   ffc script TorchFirePaths {
      using namespace WaterPathsNamespace;
      
      void run(int layers) {
         while(true) {
            for(int q = Screen->NumLWeapons(); q > 0; --q) {
               lweapon wep = Screen->LoadLWeapon(q);
               
               unless (wep->Type == LW_FIRE && GetHighestLevelItemOwned(IC_CANDLE) != 158)
                  continue;
                  
               int l1, l2;

               for(int q = 6; q >= 0; --q) {
                  if(layers & (1b << q)) {
                     if(l2) {
                        l1 = q;
                        break;
                     }
                     else 
                        l2 = q;
                  }
               }

               mapdata template = Game->LoadMapData(Game->GetCurMap(), Game->GetCurScreen());
               mapdata t1 = Emily::loadLayer(template, l1), t2 = Emily::loadLayer(template, l2);
               int cmb[4] = {
                  ComboAt(wep->X,wep->Y),
                  ComboAt(wep->X + 15, wep->Y),
                  ComboAt(wep->X, wep->Y + 15),
                  ComboAt(wep->X + 15, wep->Y + 15)
               };
               
               for(int p = 0; p < 4; ++p) {
                  combodata cd = Game->LoadComboData(t1->ComboD[cmb[p]]);
                  
                  if(cd->Type == CT_FLUID) {
                     int flag = cd->Attributes[ATTBU_FLUIDPATH];
                     
                     if(flag > 0) {
                        Fluid f = getFluid(flag);
                        
                        if(f == FL_PURPLE)
                           connectRoots(flag, FL_PURPLE, 32);
                     }
                  }
               }
            }
            Waitframe();
         }
      }
      
      void connectRoots(int path, Fluid sourcetype, int connectTo) {
         DEFINE MAX_PATH_PAIRS = MAX_PATHS * (MAX_PATHS - 1) + 1;
         int v1[MAX_PATH_PAIRS];
         int v2[MAX_PATH_PAIRS];
           
         //Cache the pairs of connected paths
         int ind = 0;
           
         for(int q = 0; q < MAX_PATHS; ++q) {
            int c = getConnection(Game->GetCurLevel(), q+1);
               
            unless(c)
               continue;
                   
            for(int p = q+1; p < MAX_PATHS; ++p) {
               unless(c & (1L << p))
                  continue;
               v1[ind] = q;
               v2[ind++] = p;
            }
         }
           
         v1[ind] = -1;
           
         bool isConnected[MAX_PATHS];
         bool didSomething;
         
         isConnected[path-1] = true;
           
         do {
            didSomething = false;
               
            for(int q = 0; v1[q] > -1; ++q)
            {
               if(isConnected[v1[q]] ^^ isConnected[v2[q]])
               {
                  isConnected[v1[q]] = true;
                  isConnected[v2[q]] = true;
                  didSomething = true;
               }
            }
         } while(didSomething);
           
         for(int q = 0; q < MAX_PATHS; ++q)
            if(isConnected[q])
               if(getSource(q + 1) == FL_PURPLE)
                  setConnection(Game->GetCurLevel(), q + 1, connectTo, true);
         
         updateFluidFlow();
      }
   }
}

namespace EmilyMap {
//start because notepad++ is stupid
   CONFIG COLOR_NULL = 0x0F;
   CONFIG COLOR_FRAME = 0x01;
   CONFIG COLOR_CUR_ROOM = 0x66;
   CONFIG CUR_ROOM_BORDER_THICKNESS = 4;
   CONFIG INPUT_REPEAT_TIME = 3;
   CONFIG ZOOM_INPUT_REPEAT_TIME = 12;
   CONFIG MAP_PUSH_PIXELS = 16;
   CONFIGB ALLOW_COMBO_ANIMS = false;
   DEFINE MAP_PUSH_VAL = MAP_PUSH_PIXELS/8;

   void generateMap(bitmap bmp, dmapdata this, bool lockPalette, bitmap currentScreen) {
      bool isOverworld = ((this->Type & 11b) == DMAP_OVERWORLD);
      
      bmp->Clear(0);
      int mapWidth = isOverworld ? 16 : 8;
      int leftEdge = Max(this->Offset, 0);
      int rightEdge = Min(this->Offset + mapWidth - 1, 15);
      int xdraw = -1;
      bitmap tmp = create(256, 176);
      
      int layer1, layer2;
      bool paths;
      
      if (this->Script == Game->GetDMapScript("WaterPaths")) {
         paths = true;
         
         for (int q = 6; q >= 0; --q) {
            if (this->InitD[0] & (1b << q)) {
               if (layer2)  {
                  layer1 = q;
                  break;
               } else 
                  layer2 = q;
            }
         }
      }

      for (int x = leftEdge; x <= rightEdge; ++x) {
         ++xdraw;
         int ydraw = -1;
         
         for (int y = 0; y < 8; ++y) {
            ++ydraw;
            int screen = x + (y * 0x10);
            mapdata mapData = Game->LoadMapData(this->Map, screen);
            bool null = false;
            
            if (lockPalette && mapData->Palette != this->Palette)
               null = true;
               
            unless (mapData->State[ST_VISITED])
               null = true;
               
            unless (mapData->Valid & 1b)
               null = true;
               
            if (null)
               tmp->ClearToColor(7, COLOR_NULL);
            else {
               tmp->Clear(7);
               bool bg2 = isBG(false, mapData, this);
               bool bg3 = isBG(true, mapData, this);
               
               if (bg2) {
                  tmp->DrawLayer(7, this->Map, screen, 2, 0, 0, 0, OP_OPAQUE);
                  handlePaths(tmp, mapData, 2, layer1, layer2);
               }
               if (bg3) {
                  tmp->DrawLayer(7, this->Map, screen, 3, 0, 0, 0, OP_OPAQUE);
                  handlePaths(tmp, mapData, 3, layer1, layer2);
               }
               
               tmp->DrawLayer(7, this->Map, screen, 0, 0, 0, 0, OP_OPAQUE);
               handlePaths(tmp, mapData, 0, layer1, layer2);
               tmp->DrawLayer(7, this->Map, screen, 1, 0, 0, 0, OP_OPAQUE);
               handlePaths(tmp, mapData, 1, layer1, layer2);
               
               // non-overlay ffcs
               for (int freeformCombo = 1; freeformCombo < 33; ++freeformCombo) {
                  unless (mapData->FFCData[freeformCombo]) 
                     continue;
                  
                  if (mapData->FFCFlags[freeformCombo] & (FFCBF_CHANGER | FFCBF_ETHEREAL | FFCBF_LENSVIS))
                     continue;
                     
                  // Skip drawing overlays
                  if (mapData->FFCFlags[freeformCombo] & FFCBF_OVERLAY) 
                     continue;
                  
                  tmp->DrawCombo(
                     7, 
                     mapData->FFCX[freeformCombo], 
                     mapData->FFCY[freeformCombo], 
                     mapData->FFCData[freeformCombo], 
                     mapData->FFCTileWidth[freeformCombo], 
                     mapData->FFCTileHeight[freeformCombo],
                     mapData->FFCCSet[freeformCombo], 
                     -1, -1, 0, 0, 0, 0, FLIP_NONE, true, (mapData->FFCFlags[freeformCombo] & FFCBF_TRANS) ? OP_TRANS : OP_OPAQUE
                  );
               }
               
               unless (bg2) {
                  tmp->DrawLayer(7, this->Map, screen, 2, 0, 0, 0, OP_OPAQUE);
                  handlePaths(tmp, mapData, 2, layer1, layer2);
               }
               unless (bg3) {
                  tmp->DrawLayer(7, this->Map, screen, 3, 0, 0, 0, OP_OPAQUE);
                  handlePaths(tmp, mapData, 3, layer1, layer2);
               }
               
               tmp->DrawLayer(7, this->Map, screen, 4, 0, 0, 0, OP_OPAQUE);
               handlePaths(tmp, mapData, 4, layer1, layer2);
               tmp->DrawLayer(7, this->Map, screen, 5, 0, 0, 0, OP_OPAQUE);
               handlePaths(tmp, mapData, 5, layer1, layer2);
               
               // overlay ffcs
               for (int freeformCombo = 1; freeformCombo < 33; ++freeformCombo) {
                  unless (mapData->FFCData[freeformCombo]) 
                     continue;
                  
                  if (mapData->FFCFlags[freeformCombo] & (FFCBF_CHANGER | FFCBF_ETHEREAL | FFCBF_LENSVIS))
                     continue;
                  
                  unless (mapData->FFCFlags[freeformCombo] & (1b<<FFCF_OVERLAY)) //Only draw overlays
                     continue; 
                  
                  tmp->DrawCombo(
                     7, 
                     mapData->FFCX[freeformCombo], 
                     mapData->FFCY[freeformCombo], 
                     mapData->FFCData[freeformCombo], 
                     mapData->FFCTileWidth[freeformCombo], 
                     mapData->FFCTileHeight[freeformCombo],
                     mapData->FFCCSet[freeformCombo], 
                     -1, -1, 0, 0, 0, 0, FLIP_NONE, true, (mapData->FFCFlags[freeformCombo] & FFCBF_TRANS) ? OP_TRANS : OP_OPAQUE);
               } //end
               
               tmp->DrawLayer(7, this->Map, screen, 6, 0, 0, 0, OP_OPAQUE);
               handlePaths(tmp, mapData, 6, layer1, layer2);
               
               if (currentScreen && screen == Game->GetCurScreen()) {
                  currentScreen->Blit(7, tmp, 0, 0, 256, 168, 0, 0, 256, 168, 0, 0, 0, BITDX_NORMAL, 0, false);
                  
                  for (int q = 0; q < CUR_ROOM_BORDER_THICKNESS; ++q) 
                     tmp->Rectangle(7, q, q, 255 - q, 175 - q, COLOR_CUR_ROOM, 1, 0, 0, 0, false, OP_OPAQUE);
               }
            }
            
            tmp->Blit(7, bmp, 0, 0, 256, 176, xdraw * 256, ydraw * 176, 256, 176, 0, 0, 0, BITDX_NORMAL, 0, false);
         }
      }
      
      tmp->Free();
   }

   @Author("EmilyV99")
   dmapdata script Map {
      void run(bool lockPalette) {
         DEFINE WIDTH = 256 * 16;
         DEFINE HEIGHT = 176 * 8;
         
         bitmap bmp = create(WIDTH,HEIGHT);
         bitmap currentScreen = create(256,168);
         currentScreen->BlitTo(7, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
         generateMap(bmp, this, lockPalette, currentScreen);
         
         bool isOverworld = ((this->Type & 11b) == DMAP_OVERWORLD);
         int mapWidth = isOverworld ? 16 : 8;
         int usableWidth = isOverworld ? WIDTH : WIDTH / 2;
         int minZoom = mapWidth;
         int x = 0, y = 0;
         int zoom = minZoom;
         int inputClock, zoomInputClock;
         
         do {
            inputClock = (inputClock + 1) % INPUT_REPEAT_TIME;
            zoomInputClock = (zoomInputClock + 1) % ZOOM_INPUT_REPEAT_TIME;
            
            bool pressed = true;
            bool zoomed = true;
            
            if (Input->Press[CB_A] || (!zoomInputClock && Input->Button[CB_A]))
               --zoom;
            else if (Input->Press[CB_B] || (!zoomInputClock && Input->Button[CB_B]))
               ++zoom;
            else 
               zoomed = false;
            
            zoom = VBound(zoom, minZoom, 1);
            int zoomMultiplier = minZoom / zoom;
            int moveMultiplier = minZoom /(minZoom - zoom + 1);
            
            if (Input->Press[CB_L] || (!inputClock && Input->Button[CB_L]))
               moveMultiplier *= 2;
            
            bool pressedUp = Input->Press[CB_UP] || (!inputClock && Input->Button[CB_UP]);
            bool pressedDown = Input->Press[CB_DOWN] || (!inputClock && Input->Button[CB_DOWN]);
            bool pressedLeft = Input->Press[CB_LEFT] || (!inputClock && Input->Button[CB_LEFT]);
            bool pressedRight = Input->Press[CB_RIGHT] || (!inputClock && Input->Button[CB_RIGHT]);
            
            if (pressedUp)
               y += MAP_PUSH_VAL * moveMultiplier;
            if (pressedDown)
               y -= MAP_PUSH_VAL * moveMultiplier;
            if (pressedLeft)
               x += MAP_PUSH_VAL * moveMultiplier;
            if (pressedRight)
               x -= MAP_PUSH_VAL * moveMultiplier;
               
            unless (pressedUp || pressedDown || pressedLeft || pressedRight)
               pressed = false;
            
            if (pressed) 
               inputClock = 1;
            if (zoomed)
               zoomInputClock = 1;
            
            if (isOverworld) {
               x = VBound(x, 128 + 112, -128 - 112); //VBound(x, (usableWidth)/2-256, (-usableWidth)/2-256);
               y = VBound(y, 112 + 94.5, 58.5); //VBound(y, (HEIGHT)/2-224, (-HEIGHT)/2-224);
            } else {
               x = VBound(x, 128 + 96, -128 - 96);//VBound(x, (usableWidth)/2-256, (-usableWidth)/2-256);
               y = VBound(y, 112 + 77, -112 + 5);//VBound(y, (HEIGHT)/2-224, (-HEIGHT)/2-224);
            }
            
            int tx = (256 + ((x - 256) * zoomMultiplier)) / 2;
            int ty = ((224 + ((y - 224) * zoomMultiplier)) / 2) - 28;
            
            Screen->Rectangle(7, 0, -56, 255, 175, COLOR_NULL, 1, 0, 0, 0, true, OP_OPAQUE);
            Screen->Rectangle(7, tx - 1, ty - 1, tx + usableWidth / zoom, ty + HEIGHT / zoom, COLOR_FRAME, 1, 0, 0, 0, false, OP_OPAQUE);
            
            bmp->Blit(7, RT_SCREEN, 0, 0, usableWidth, HEIGHT, tx, ty, usableWidth / zoom, HEIGHT / zoom, 0, 0, 0, BITDX_NORMAL, 0, false);
            
            Waitframe();
            
            if (ALLOW_COMBO_ANIMS)
               generateMap(bmp, this, lockPalette, currentScreen);
               
         } until (Input->Press[CB_MAP] || Input->Press[CB_START]);
         
         Input->Press[CB_MAP] = false;
         Input->Button[CB_MAP] = false;
         Input->Press[CB_START] = false;
         Input->Button[CB_START] = false;
         
         bmp->Free();
      }
   }
	
   bool isBG(bool l3, mapdata m, dmapdata dm) {
      if (l3)
         return (GetMapscreenFlag(m, MSF_LAYER3BG) ^^ dm->Flagset[DMFS_LAYER3ISBACKGROUND]);
      else
         return (GetMapscreenFlag(m, MSF_LAYER2BG) ^^ dm->Flagset[DMFS_LAYER2ISBACKGROUND]);
   }

	void handlePaths(bitmap bmp, mapdata template, int layer, int layer1, int layer2) {
		using namespace WaterPathsNamespace;
      
		if (layer != layer1 && layer != layer2) 
         return;
         
		mapdata currentMapLayer1 = Emily::loadLayer(template, layer1);
      mapdata currentMapLayer2 = Emily::loadLayer(template, layer2);
		mapdata templateLeft, templateRight, templateUp, templateDown;
		
      unless (template->Screen < 0x10)
         templateUp = Emily::loadLayer(Game->LoadMapData(template->Map, template->Screen - 0x10), layer1);
      unless (template->Screen >= 0x70)
         templateDown = Emily::loadLayer(Game->LoadMapData(template->Map, template->Screen + 0x10), layer1);
      if (template->Screen % 0x10)
         templateLeft = Emily::loadLayer(Game->LoadMapData(template->Map, template->Screen - 1), layer1);
      unless (template->Screen % 0x10 == 0xF)
         templateRight = Emily::loadLayer(Game->LoadMapData(template->Map, template->Screen + 1), layer1);
		
		enum {
			PASS_LIQUID,
			PASS_BARRIERS,
			PASS_COUNT
		};
		
		for (int pass = 0; pass < PASS_COUNT; ++pass) {
			for (int combo = 0; combo < 176; ++combo) {
				if (currentMapLayer1->ComboT[combo] != CT_FLUID)
					continue;
					
				combodata comboData = Game->LoadComboData(currentMapLayer1->ComboD[combo]);
				int flag = comboData->Attributes[ATTBU_FLUIDPATH];
				
				switch(pass) {
					case PASS_LIQUID:
						unless (flag > 0) 
                     continue;
						break;
					case PASS_BARRIERS:
						unless (flag == VAL_BARRIER) 
                     continue;
						break;
				}
					
				int up, down, left, right;
				
				unless (combo < 0x10)
					up = Game->LoadComboData(currentMapLayer1->ComboD[combo - 0x10])->Attributes[ATTBU_FLUIDPATH];
				else if (templateUp)
					up = Game->LoadComboData(templateUp->ComboD[combo + 0x90])->Attributes[ATTBU_FLUIDPATH];
				
				unless (combo >= 0xA0)
					down = Game->LoadComboData(currentMapLayer1->ComboD[combo + 0x10])->Attributes[ATTBU_FLUIDPATH];
				else if (templateDown)
					down = Game->LoadComboData(templateDown->ComboD[combo - 0x90])->Attributes[ATTBU_FLUIDPATH];
				
				if (combo % 0x10) 
					left = Game->LoadComboData(currentMapLayer1->ComboD[combo - 1])->Attributes[ATTBU_FLUIDPATH];
				else if (templateLeft) 
					left = Game->LoadComboData(templateLeft->ComboD[combo + 0xF])->Attributes[ATTBU_FLUIDPATH];
				
				unless (combo % 0x10 == 0xF) 
					right = Game->LoadComboData(currentMapLayer1->ComboD[combo + 1])->Attributes[ATTBU_FLUIDPATH];
				else if (templateRight)
					right = Game->LoadComboData(templateRight->ComboD[combo - 0xF])->Attributes[ATTBU_FLUIDPATH];
				
            // Standard fluid
				if (flag > 0) {
					int cmb = -1;
					
               //all same
					if (isBarrierFlag(up, flag) && isBarrierFlag(down, flag) && isBarrierFlag(left, flag) && isBarrierFlag(right, flag)) {
						//start Inner Corners
						int upperLeft, upperRight, lowerLeft, lowerRight;
						
						if (combo > 0xF && combo % 0x10)
							upperLeft = Game->LoadComboData(currentMapLayer1->ComboD[combo - 0x11])->Attributes[ATTBU_FLUIDPATH];
						else if (combo < 0x10 && combo % 0x10)
							upperLeft = Game->LoadComboData(templateUp->ComboD[combo + 0x8F])->Attributes[ATTBU_FLUIDPATH];
						else if (combo > 0xF && !(combo % 0x10))
							upperLeft = Game->LoadComboData(templateLeft->ComboD[combo - 1])->Attributes[ATTBU_FLUIDPATH];
						
						if (combo > 0xF && (combo % 0x10) != 0xF)
							upperRight = Game->LoadComboData(currentMapLayer1->ComboD[combo - 0xF])->Attributes[ATTBU_FLUIDPATH];
						else if (combo < 0x10 && (combo % 0x10) != 0xF)
							upperRight = Game->LoadComboData(templateUp->ComboD[combo + 0x91])->Attributes[ATTBU_FLUIDPATH];
						else if (combo > 0xF && (combo % 0x10) == 0xF)
							upperRight = Game->LoadComboData(templateRight->ComboD[combo - 0x1F])->Attributes[ATTBU_FLUIDPATH];
						
						if (combo < 0xA0 && combo % 0x10)
							lowerLeft = Game->LoadComboData(currentMapLayer1->ComboD[combo + 0xF])->Attributes[ATTBU_FLUIDPATH];
						else if (combo > 0x9F && combo % 0x10)
							lowerLeft = Game->LoadComboData(templateDown->ComboD[combo - 0x91])->Attributes[ATTBU_FLUIDPATH];
						else if (combo < 0xA0 && !(combo % 0x10))
							lowerLeft = Game->LoadComboData(templateLeft->ComboD[combo + 0x1F])->Attributes[ATTBU_FLUIDPATH];
						
						if (combo < 0xA0 && (combo % 0x10) != 0xF)
							lowerRight = Game->LoadComboData(currentMapLayer1->ComboD[combo + 0x11])->Attributes[ATTBU_FLUIDPATH];
						else if (combo > 0x9F && (combo % 0x10) != 0xF)
							lowerRight = Game->LoadComboData(templateDown->ComboD[combo - 0x8F])->Attributes[ATTBU_FLUIDPATH];
						else if (combo < 0xA0 && (combo % 0x10) == 0xF)
							lowerRight = Game->LoadComboData(templateRight->ComboD[combo + 0x01])->Attributes[ATTBU_FLUIDPATH];
							
						unless (isBarrierFlag(upperLeft, flag) || !(isBarrierFlag(upperRight, flag) && isBarrierFlag(lowerLeft, flag) && isBarrierFlag(lowerRight, flag)))
							cmb = CMB_TL_INNER;
						else unless (isBarrierFlag(upperRight, flag) || !(isBarrierFlag(upperLeft, flag) && isBarrierFlag(lowerLeft, flag) && isBarrierFlag(lowerRight, flag)))
							cmb = CMB_TR_INNER;
						else unless (isBarrierFlag(lowerLeft, flag) || !(isBarrierFlag(upperRight, flag) && isBarrierFlag(upperLeft, flag) && isBarrierFlag(lowerRight, flag)))
							cmb = CMB_BL_INNER;
						else unless (isBarrierFlag(lowerRight, flag) || !(isBarrierFlag(upperRight, flag) && isBarrierFlag(lowerLeft, flag) && isBarrierFlag(upperLeft, flag)))
							cmb = CMB_BR_INNER;
						else
							cmb = 0;
					}
               // up
					else if (isBarrierFlag(up, flag)) {
                  // upleft
						if (isBarrierFlag(left, flag)) {
                     // upleft, notdown
							unless (isBarrierFlag(down, flag)) {
                        // upleftright, notdown
								if (isBarrierFlag(right, flag)) 
									cmb = CMB_BOTTOM;
                        // upleft, notrightdown
								else 
									cmb = CMB_BR_OUTER;
							}
                     //upleftdown, notright
							else unless (isBarrierFlag(right, flag))
								cmb = CMB_RIGHT;
						}
                  //up not-left
						else {
                     //upright, notleft
							if (isBarrierFlag(right, flag)) {
                        //upright, notdownleft
								unless (isBarrierFlag(down, flag))
									cmb = CMB_BL_OUTER;
                        //uprightdown, notleft
                        else 
									cmb = CMB_LEFT;
							}
						}
					}
               // notup
					else {
                  // right, notup
						if (isBarrierFlag(right,flag)) {
                     // rightdown, notup
							if (isBarrierFlag(down, flag)) {
                        //rightdownleft, notup
								if (isBarrierFlag(left, flag)) 
									cmb = CMB_TOP;
								//rightdown, notleftup
                        else 
									cmb = CMB_TL_OUTER;
							}
						}
                  // notrightup
						else {
                     //down, notrightup
							if (isBarrierFlag(down, flag))
                        //leftdown, notrightup
								if (isBarrierFlag(left, flag))
									cmb = CMB_TR_OUTER;
						}
					}
					if (cmb > -1) {
						if (layer == layer1)
							bmp->FastCombo(7, ComboX(combo), ComboY(combo), getCombo(getFluid(flag), cmb > 0), currentMapLayer1->ComboC[combo], OP_OPAQUE);
						if (layer == layer2 && cmb)
							bmp->FastCombo(7, ComboX(combo), ComboY(combo), cmb, currentMapLayer1->ComboC[combo], OP_OPAQUE);
					}
					else if (WP_DEBUG)
						printf("[WaterPaths] Error: Bad combo calculation for fluid pos %d (f: %d, udlr: %d,%d,%d,%d)\n", combo, flag, up, down, left, right);
					
				}
            // Barriers
				else if (flag == VAL_BARRIER) {
					int cmb = -1;
					int flowpath = 0;
					bool flowing = false;
					
               // horizontal barrier
					if (up > 0 && down > 0 && left < 1 && right < 1) {
						flowing = getConnection(Game->GetCurLevel(), up, down);
						
                  if (flowing)
							flowpath = up;
						
						if (left == VAL_BARRIER) {
                     // Center
							if (right == VAL_BARRIER) {
								if (flowing)
									cmb = 0;
								else
									cmb = CMB_BARRIER_HORZ;
							}
                     // Left
							else {
								if (flowing)
									cmb = CMB_RIGHT;
								else
									cmb = CMB_BARRIER_RIGHT;
							}
						}
                  // Right
						else if (right == VAL_BARRIER) {
							if (flowing)
								cmb = CMB_LEFT;
							else
								cmb = CMB_BARRIER_LEFT;
						}
					}
               // vertical barrier
					else if (left > 0 && right > 0 && up < 1 && down < 1) {
						flowing = getConnection(Game->GetCurLevel(), left, right);
						
						if (flowing)
							flowpath = left;
						
						if (up == VAL_BARRIER){
                     // Center
							if (down == VAL_BARRIER) {
								if (flowing)
									cmb = 0;
								else
									cmb = CMB_BARRIER_VERT;
							}
                     // Up
							else {
								if (flowing)
									cmb = CMB_BOTTOM;
								else
									cmb = CMB_BARRIER_BOTTOM;
							}
						}
                  // Down
						else if (down == VAL_BARRIER) {
							if (flowing)
								cmb = CMB_TOP;
							else
								cmb = CMB_BARRIER_TOP;
						}
					}
					if (cmb > -1) {
						if (flowpath && layer == layer1)
							bmp->FastCombo(7, ComboX(combo), ComboY(combo), getCombo(getFluid(flowpath), cmb > 0), currentMapLayer1->ComboC[combo], OP_OPAQUE);
						if (layer == layer2 && cmb)
							bmp->FastCombo(7, ComboX(combo), ComboY(combo), cmb, currentMapLayer1->ComboC[combo], OP_OPAQUE);
					}
					else if (WP_DEBUG)
						printf("[WaterPaths] Error: Bad combo calculation for barrier pos %d (f: %d, udlr: %d,%d,%d,%d)\n", combo, flag, up, down, left, right);
					
				}
			}
		}
   }
} //end
