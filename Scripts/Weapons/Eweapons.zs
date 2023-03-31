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
      
      if(effect) {
         switch(effect) {
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

eweapon sword1x1(int x, int y, int angle, int dist, int cmb, int cset, int dmg) {
   x += VectorX(dist, angle);
   y += VectorY(dist, angle);

   Screen->DrawCombo(2, x, y, cmb, 1, 1, cset, -1, -1, x, y, angle, -1, 0, true, OP_OPAQUE);

   return makeHitbox(x, y, 16, 16, dmg);
} 











