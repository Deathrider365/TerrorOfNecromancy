///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Enemies ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

@Author("Deathrider365")
npc script Candlehead {
   using namespace EnemyNamespace;
   
   const int NORMAL_RAND = 5;
   const int AGGRESSIVE_RAND = 50;
   const int NORMAL_MOVE_DURATION = 30;
   const int AGGRESSIVE_MOVE_DURATION = 60;
   const int NORMAL_HOMING = 10;
   const int AGGRESSIVE_HOMING = 20;
   
   void run(int chungo) {
      int knockbackDist = 4;
      
      gridLockNPC(this);
      
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

@Author("EmilyV99")
npc script Mimic {
   void run(int speedMult, int fireRate, int knockbackDist) {
      unless (speedMult)
         speedMult = 1;
         
      unless (fireRate)
         fireRate = 30;
         
      unless (knockbackDist)
         knockbackDist = 4;
         
      int fireClock;
      
      if (knockbackDist < 0)
         this->NoSlide = true;
      else
         this->SlideSpeed = knockbackDist;
         
      eweapon e;
      
      while (true) {
         while (this->Stun) {
            this->Slide();
            Waitframe();
         }
         
         this->Slide();
            
         int xStep = -LinkMovement[LM_STICKX] * Hero->Step / 100 * speedMult;			
         int yStep = -LinkMovement[LM_STICKY] * Hero->Step / 100 * speedMult;
         
         this->Dir = OppositeDir(Hero->Dir);
         int step = Max(Abs(xStep), Abs(yStep));
         
         int mDir = (yStep ? (yStep < 0 ? DIR_UP : DIR_DOWN) : -1);
         mDir = Emily::addX(mDir, (xStep ? (xStep < 0 ? DIR_LEFT : DIR_RIGHT) : -1));
         
         unless (fireClock) {
            if (this->Dir == this->LinedUp(12, false)) {
               this->Attack();
               fireClock = fireRate;
            }
         }
         else
            --fireClock;
         
         if (mDir != -1) {
            while(true) {					
               if (this->CanMove({mDir, step, 0})) {
                  this->X += xStep;
                  this->Y += yStep;
                  break;
               }
               
               if (--step <= 0)
                  break;
               
               if (xStep)
                  xStep > 0 ? --xStep : ++xStep;
               if (yStep)
                  yStep > 0 ? --yStep : ++yStep;
            }
         }
         
         Waitframe();
      }
   }
}

@Author("Moosh, Emily")
npc script HammerBoi {
   using namespace GhostBasedMovement;
   using namespace EnemyNamespace;
   
   void run() {
      int counter = -1;
      const int COOLDOWN = 60;
      int timer;
      
      while(true) {
         counter = ConstWalk4(this, counter);
         
         unless (timer) {
            if (Abs(this->X - Hero->X) < 32 && Abs(this->Y - Hero->Y) < 16) {
               int oldDir = this->Dir;
               this->Dir = faceLink(this);
               hammerAnim(this);
               
               this->Dir = oldDir;
               
               timer = COOLDOWN;
            }
         }
         else
            --timer;
         
         Waitframe();
      }
   }
   
   void hammerAnim(npc this) {
      this->ScriptTile = this->OriginalTile + 4 * this->Dir;
      
      Coordinates xy = new Coordinates();
      
      //Hold Up
      for (int i = 0; i < 20; ++i) {
         if (this->HP <= 0)
            break;
            
         hammerFrame(this, 0, this->WeaponDamage, xy);
         Waitframe();
      }
      
      // Swing
      for (int i = 0; i < 4; ++i) {
         if (this->HP <= 0)
            break;
            
         hammerFrame(this, 1, this->WeaponDamage, xy);
         Waitframe();
      }
      
      if (this->HP > 0)
         Audio->PlaySound(SFX_HAMMER);
      
      //Smash
      for (int i = 0; i < 30; ++i) {
         if (this->HP <= 0)
            break;
            
         hammerFrame(this, 2, this->WeaponDamage, xy);
         
         if (i == 0) {
            if (int escr = CheckEWeaponScript("HammerImpactEffect")) {
               eweapon weap = RunEWeaponScriptAt(EW_SCRIPT10, escr, xy->X, xy->Y, { 49852 });
               weap->ScriptTile = TILE_INVIS;
            }
         }
         
         Waitframe();
      }
      
      this->ScriptTile = -1;
      delete xy;
   }
   
   void hammerFrame(npc this, int frame, int damage, Coordinates xy) {
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
      
      eweapon hammer = FireEWeapon(EW_SCRIPT10, x, y, 0, 0, damage, 0, 0, EWF_UNBLOCKABLE);
      hammer->ScriptTile = TILE_HAMMER + 3 * this->Dir + frame;
      hammer->CSet = CSET_HAMMER;
      // hammer->Behind = true;
      hammer->Timeout = 2;
      
      if (frame < 2)
         hammer->CollDetection = false;
      
      xy->X = x;
      xy->Y = y;
   }
}