///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ EWeapons ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

@Author("KoolAidWannaBe")
eweapon script SignWave {
   void run(int size, int speed, bool unBlockable, int step) {
      this->Angle = DirRad(this->Dir);
      this->Angular = true;
      this->Step = step;
      
      int x = this->X;
      int y = this->Y;
      
      if (this->Parent)
         this->UseSprite(this->Parent->WeaponSprite);
      
      int dist;
      int timer;
      
      while(true) {
         timer += speed;
         timer %= 360;
         
         x += RadianCos(this->Angle) * this->Step * 0.01;
         y += RadianSin(this->Angle) * this->Step * 0.01;
         
         dist = Sin(timer)*size;
         
         this->X = x + VectorX(dist, RadtoDeg(this->Angle) - 90);
         this->Y = y + VectorY(dist, RadtoDeg(this->Angle) - 90);
         
         if(unBlockable)
            this->Dir = Link->Dir;
         
         Waitframe();
      }
   }
}

@Author("Moosh")
eweapon script ArcingWeapon {
   void run(int initJump, int gravity, int effect) {
      this->Gravity = false;
      
      int jump = initJump;
      int linkDistance = Distance(Hero->X, Hero->Y, this->X, this->Y);
      
      if (initJump == -1 && gravity == 0)
         jump = getJumpLength(linkDistance / (this->Step / 100), true);
      
      unless (gravity)
         gravity = Game->Gravity[GR_STRENGTH];

      while (jump > 0 || this->Z > 0) {
         this->Z += jump;
         jump -= gravity;
         this->DeadState = WDS_ALIVE;
         
         CustomWaitframe(this, 1);
      }
      
      this->DrawYOffset = -1000;
      this->CollDetection = false;
      
      if (effect) {
         switch (effect) {
            case AE_SMALLPOISONPOOL: 
               this->Step = 0;
               Audio->PlaySound(SFX_BOMB);
               
               for (int i = 0; i < 12; ++i) {
                  int distance = 24 * i / 12;
                  int angle = Rand(360);
                  
                  eweapon poisonTrail = FireEWeapon(EW_SCRIPT10, this->X + VectorX(distance, angle), this->Y + VectorY(distance, angle), 0, 0, this->Damage, SPR_POISON_CLOUD, SFX_SIZZLE, EWF_UNBLOCKABLE);

                  SetEWeaponLifespan(poisonTrail, EWL_TIMER, 90);
                  SetEWeaponDeathEffect(poisonTrail, EWD_VANISH, 0);
                  
                  CustomWaitframe(this, 4);
               }
               break;
            case AE_LARGEPOISONPOOL:
               this->Step = 0;
               Audio->PlaySound(SFX_BOMB);
               
               for (int i = 0; i < 18; ++i) {
                  int distance = 40 * i / 18;
                  int angle = Rand(360);
                  
                  eweapon poisonTrail = FireEWeapon(EW_SCRIPT10, this->X + VectorX(distance, angle), this->Y + VectorY(distance, angle), 0, 0, this->Damage, 
                                             SPR_POISON_CLOUD, SFX_SIZZLE, EWF_UNBLOCKABLE);

                  SetEWeaponLifespan(poisonTrail, EWL_TIMER, 90);
                  SetEWeaponDeathEffect(poisonTrail, EWD_VANISH, 0);
                  
                  CustomWaitframe(this, 4);
               }
               break;					
            case AE_PROJECTILEWITHMOMENTUM:
               for (int i = 0; i < 12; ++i) {
                  int distance = 24 * i / 12;
                  int angle = Rand(360);
                  
                  eweapon poisonTrail = FireEWeapon(EW_SCRIPT10, this->X + VectorX(distance, angle), this->Y + VectorY(distance, angle), 0, 0, this->Damage, 
                                             SPR_POISON_CLOUD, SFX_SIZZLE, EWF_UNBLOCKABLE);

                  SetEWeaponLifespan(poisonTrail, EWL_TIMER, 90);
                  SetEWeaponDeathEffect(poisonTrail, EWD_VANISH, 0);
                  
                  CustomWaitframe(this, 4);
               }
               break;
            case AE_OIL_BLOB:
               const int oilCombo = 6349;
               Audio->PlaySound(SFX_BOMB);
               int pos = ComboAt(this->X + 8, this->Y + 8);
               
               if (Screen->ComboT[pos] == CT_SCRIPT20)
                  Screen->ComboD[pos] = oilCombo;
               
               break;
            case AE_OIL_DEATH_BLOB:
               for (int i = 0; i < 4; ++i) {
                  eweapon oilProjectile = FireEWeapon(195, this->X + 8 + VectorX(8, -45 + 90 * i), this->Y + 8 + VectorY(8, -45 + 90 * i), DegtoRad(-45 + 90 * i), 150, 4, 118, -1, EWF_UNBLOCKABLE | EWF_ROTATE);
                  runEWeaponScript(oilProjectile, Game->GetEWeaponScript("ArcingWeapon"), {1, 0, AE_ROCK_PROJECTILE});	
               }
               break;
            case AE_ROCK_PROJECTILE:
               for (int i = 0; i < 4; ++i) {
                  eweapon pebbleProjectile = FireEWeapon(195, this->X + 8 + VectorX(8, -45 + 90 * i), this->Y + 8 + VectorY(8, -45 + 90 * i), DegtoRad(-45 + 90 * i), 150, 2, 18, -1, EWF_UNBLOCKABLE | EWF_ROTATE);
                  runEWeaponScript(pebbleProjectile, Game->GetEWeaponScript("ArcingWeapon"), {1, 0, -1});	
               }
               Audio->PlaySound(SFX_BOMB);
               break;
            case AE_BOULDER_PROJECTILE:
               for (int i = 0; i < 4; ++i) {
                  eweapon rockProjectile = FireEWeapon(195, this->X + 8 + VectorX(8, -45 + 90 * i), this->Y + 8 + VectorY(8, -45 + 90 * i), DegtoRad(-45 + 90 * i), 150, 4, 118, -1, EWF_UNBLOCKABLE | EWF_ROTATE);
                  runEWeaponScript(rockProjectile, Game->GetEWeaponScript("ArcingWeapon"), {1, 0, AE_ROCK_PROJECTILE});	
               }
            
               Audio->PlaySound(SFX_BOMB);
               break;
            case AE_RACCOON_PROJECTILE:
               npc n = CreateNPCAt(236, this->X, this->Y);
               break;
            case AE_EGENTEM_HAMMER:
               if (int escr = CheckEWeaponScript("EgentemPillar")) {
                  eweapon pillar = RunEWeaponScriptAt(EW_SCRIPT10, escr, this->X, this->Y, {30, 300, 0, 0});
                  pillar->Damage = 4;
                  pillar->Unblockable = UNBLOCK_ALL;
               }
               break;
            case AE_DEBUG:
               this->Step = 0;
               
               for(int i = 0; i < 90; ++i) {
                  Screen->DrawInteger(6, this->X, this->Y, FONT_Z1, C_WHITE, C_BLACK, -1, -1, i, 0, 128);
                  this->DeadState = WDS_ALIVE;
                  CustomWaitframe(this, 1);
               }
               break;
         }
      }
      
      this->DeadState = WDS_DEAD;
   }
	
   void CustomWaitframe(eweapon this, int frames) {
      for (int i = 0; i < frames; ++i) {
         this->DeadState = WDS_ALIVE;
         Waitframe();
      }
   }
}

@Author("EmilyV99")
eweapon script Stopper {
   void run(int timer) {
      do Waitframe(); while (--timer);
      this->Step = 0;
   }
}

@Author("EmilyV99")
eweapon script StopperKiller {
   void run(int stopTime, int killTime) {
      while(true) {
         if (stopTime > 0)
            unless(--stopTime)
         this->Step = 0;

         if (killTime > 0)
            unless(--killTime)
         this->Remove();

         Waitframe();
      }
   }
}

eweapon makeHitbox(int x, int y, int w, int h, int damage) {
   eweapon e = FireEWeapon(EW_SCRIPT10, 120, 80, 0, 0, damage, -1, -1, EWF_UNBLOCKABLE);
   e->HitXOffset = x-e->X;
   e->HitYOffset = y-e->Y;
   e->DrawYOffset = -1000;
   e->HitWidth = w;
   e->HitHeight = h;
   SetEWeaponLifespan(e, EWL_TIMER, 1);
   SetEWeaponDeathEffect(e, EWD_VANISH, 0);

   return e;
}

eweapon makeHitboxPersistent(eweapon hitbox, int x, int y, int w, int h, int damage) {
   unless (hitbox->isValid())
      hitbox = FireEWeapon(EW_SCRIPT10, 120, 80, 0, 0, damage, -1, -1, EWF_UNBLOCKABLE);
   else 
      hitbox->DeadState = WDS_ALIVE;
      
   hitbox->HitXOffset = x - hitbox->X;
   hitbox->HitYOffset = y - hitbox->Y;
   hitbox->DrawYOffset = -1000;
   hitbox->HitWidth = w;
   hitbox->HitHeight = h;
   hitbox->Timeout = 2;

   return hitbox;
}

eweapon sword1x1(int x, int y, int angle, int dist, int cmb, int cset, int dmg) {
   x += VectorX(dist, angle);
   y += VectorY(dist, angle);

   Screen->DrawCombo(2, x, y, cmb, 1, 1, cset, -1, -1, x, y, angle, -1, 0, true, OP_OPAQUE);

   return makeHitbox(x, y, 16, 16, dmg);
}

eweapon sword1x1Tile(int x, int y, int angle, int dist, int tile, int cset, int dmg) {
   x += VectorX(dist, angle);
   y += VectorY(dist, angle);

   Screen->DrawTile(2, x, y, tile, 1, 1, cset, -1, -1, x, y, angle, 0, true, OP_OPAQUE);

   return makeHitbox(x, y, 16, 16, dmg);
}

eweapon sword1x1Persistent(eweapon hitbox, int x, int y, int angle, int dist, int cmb, int cset, int dmg) {
   x += VectorX(dist, angle);
   y += VectorY(dist, angle);

   Screen->DrawCombo(2, x, y, cmb, 1, 1, cset, -1, -1, x, y, angle, -1, 0, true, OP_OPAQUE);

   return makeHitboxPersistent(hitbox, x, y, 16, 16, dmg);
}

eweapon script HammerImpact {
   void run() {
      const int TILE_HAMMER_IMPACT = 49916;
      this->Step = 250;
      
      while(true) {
         int x = this->X + 8 + DirX(this->Dir) * 4;
         int y = this->Y + 8 + DirY(this->Dir) * 4;
         
         if (Screen->isSolid(x, y))
            break;
         
         Waitframe();
      }
      
      Audio->PlaySound(SFX_WALL_SMASH);
      
      int angle = DirAngle(OppositeDir(this->Dir));
      
      for (int i = 0; i < 4; ++i) {
         eweapon e = FireEWeapon(EW_SCRIPT10, this->X, this->Y, DegtoRad(angle + Rand(-30, 30)), Rand(100, 250), this->Damage * .5, SPR_SUPER_SMALL_ROCK, 0, EWF_UNBLOCKABLE);
         e->Timeout = 32;
      }
      
      eweapon e = CreateEWeaponAt(EW_BOMBBLAST, this->X, this->Y);
      e->Damage = this->Damage * .75;
      
      this->Step = 0;
      this->CollDetection = false;
      this->ScriptTile = TILE_HAMMER_IMPACT + this->Dir;
      
      for (int i = 0; i < 60; ++i) {
         this->DeadState = WDS_ALIVE;
         Waitframe();
      }
      
      this->Remove();
   }
}

eweapon script HammerImpactEffect {
   void run(int tile) {
      this->CollDetection = false;
      this->ScriptTile = TILE_INVIS;
      
      for (int i = 0; i < 5; ++i) {
         int tempTile = tile + (i > 0 ? 2 : 0);
         int offset;
         
         if (i > 1)
            offset = 2 * (i - 1);
         
         for (int j = 0; j < 3; ++j) {
            Screen->FastTile(3, this->X - offset, this->Y + 8 - offset, tempTile, 0, OP_OPAQUE);
            Screen->FastTile(3, this->X + 8 + offset, this->Y + 8 - offset, tempTile + 1, 0, OP_OPAQUE);
            Waitframe();
         }
      }
      
      this->Remove();
   }
}

eweapon script ShockWave {
   void run(int spr, int sfx, int delay, int detonateSfx, int detonateSpr, int waves, int angle, bool doErupt) {
      if (Screen->isSolid(this->X + 8, this->Y + 8))
         this->Remove();
   
      CONFIG D_ERUPT = 7;
      int x = this->X + VectorX(16, angle);
      int y = this->Y + VectorY(16, angle);
      this->CollDetection = false;
      this->UseSprite(spr);
      this->Behind = true;
      Audio->PlaySound(sfx);
      
      Waitframes(delay);
   
      if (waves) {
         eweapon child = RunEWeaponScriptAt(EW_SCRIPT2, this->Script, x, y, {
            spr, sfx, delay, detonateSfx, detonateSpr, 
            waves - 1, 
            angle + Rand(10, 20) * Choose(-1, 1),
            false
         });
         
         child->Damage = this->Damage;
         child->Unblockable = UNBLOCK_ALL;
      }
      
      
      until(this->InitD[D_ERUPT])
         Waitframe();
         
      this->Behind = false;
      this->Extend = EXT_NORMAL;
      this->TileHeight = 2;
      this->DrawYOffset = -16;
      this->HitYOffset = -16;
      this->HitHeight = 32;
      this->CollDetection = true;
      this->UseSprite(detonateSpr);
      Audio->PlaySound(detonateSfx);
      
      for (int i = 0; i < this->NumFrames * this->ASpeed; ++i) {
         this->DeadState = WDS_ALIVE;
         Waitframe();
      }
      
      this->Remove();
   }
}

@Author("Moosh")
eweapon script Boomerang {
   void run(int travelTime, int slowTime, int stun, npc parent) {
      int step = this->Step;
      int brangSfxTiming = 15;
      this->Unblockable = UNBLOCK_ALL;
      bool bounced;

      for (int i = 0; i < travelTime; ++i) {
         this->DeadState = WDS_ALIVE;
         int hitId = Link->HitBy[HIT_BY_EWEAPON];
         
         unless (this->X > 0 && this->X < 240 && this->Y > 0 && this->Y < 160) {
            bounced = true;
            break;
         }
         
         unless(gameframe % brangSfxTiming)
            Audio->PlaySound(SFX_BRANG);
         
         if (hitId) {
            eweapon e = Screen->LoadEWeapon(hitId);
            
            if (e == this) {
               Hero->Stun = Max(Hero->Stun, stun);
               break;
            }
         }
         
         Waitframe();
      }
      
      for (int i = 0; i < slowTime && !bounced; ++i) {
         this->Step = Lerp(step, 0, i / slowTime);
         this->DeadState = WDS_ALIVE;
         int hitId = Link->HitBy[HIT_BY_EWEAPON];
         
         unless (this->X > 0 && this->X < 240 && this->Y > 0 && this->Y < 160) {
            bounced = true;
            break;
         }
         
         unless(gameframe % brangSfxTiming)
            Audio->PlaySound(SFX_BRANG);
         
         if (hitId) {
            eweapon e = Screen->LoadEWeapon(hitId);
            
            if (e == this) {
               Hero->Stun = Max(Hero->Stun, stun);
               break;
            }
         }
         
         Waitframe();
      }
      
      this->DegAngle += 180;
      
      for (int i = 0; i < slowTime; ++i) {
         if (parent->isValid())
            this->DegAngle = Angle(this->X, this->Y, CenterX(parent) - 8, CenterY(parent) - 8);
         
         this->Step = Lerp(0, step, i / slowTime);
         this->DeadState = WDS_ALIVE;
         int hitId = Link->HitBy[HIT_BY_EWEAPON];
         
         unless(gameframe % brangSfxTiming)
            Audio->PlaySound(SFX_BRANG);
            
         if (hitId) {
            eweapon e = Screen->LoadEWeapon(hitId);
            
            if (e == this)
               Hero->Stun = Max(Hero->Stun, stun);
         }
         
         Waitframe();
      }
      
      this->Step = step;
      
      while (true) {
         if (parent->isValid()) {
            this->DegAngle = Angle(this->X, this->Y, CenterX(parent) - 8, CenterY(parent) - 8);
            
            if (Distance(this->X, this->Y, CenterX(parent) - 8, CenterY(parent) - 8) < step / 100)
               this->Remove();
         }
         
         if (this->X > 0 && this->X < 240 && this->Y > 0 && this->Y < 160) {
            this->DeadState = WDS_ALIVE;
         }
         
         unless(gameframe % brangSfxTiming)
            Audio->PlaySound(SFX_BRANG);
         
         int hitId = Link->HitBy[HIT_BY_EWEAPON];
         
         if (hitId) {
            eweapon e = Screen->LoadEWeapon(hitId);
            
            if (e == this)
               Hero->Stun = Max(Hero->Stun, stun);
         }
         
         Waitframe();
      }
   }
}




