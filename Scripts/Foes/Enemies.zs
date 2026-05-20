//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Enemies ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

// clang-format off
@Author("Deathrider365")
npc script Candlehead {
   // clang-format on
   using namespace EnemyNamespace;

   CONFIG NORMAL_RAND = 5;
   CONFIG AGGRESSIVE_RAND = 50;
   CONFIG NORMAL_MOVE_DURATION = 30;
   CONFIG AGGRESSIVE_MOVE_DURATION = 60;
   CONFIG NORMAL_HOMING = 10;
   CONFIG AGGRESSIVE_HOMING = 20;

   void run(int chungo) {
      int knockbackDist = 4;

      // int highestLevelCandle = GetHighestLevelItemOwned(IC_CANDLE) < 0 ? 1 : GetHighestLevelItemOwned(IC_CANDLE);

      CONFIG DMG_FLAME = this->WeaponDamage;
      // CONFIG DMG_FLAME = (Game->LoadItemData(highestLevelCandle)->Damage * (chungo ? 2 : 1) * this->WeaponDamage) / 2;

      gridLockNPC(this);

      if (knockbackDist < 0)
         this->NoSlide = true;
      else
         this->SlideSpeed = knockbackDist;

      loop () {
         if (this->HP <= 0)
            this->Step = 0;

         this->Slide();

         if (hitByLWeapon(this, LW_FIRE) || hitByEWeapon(this, EW_FIRE) || hitByEWeapon(this, EW_SCRIPT1))
            burnToDeath(this, chungo, DMG_FLAME);

         unless(gameframe % RandGen->Rand(45, 60)) {
            for (int i = 0; i < (linkClose(this, 24) ? AGGRESSIVE_MOVE_DURATION : NORMAL_MOVE_DURATION); ++i) {
               this->Slide();

               if (hitByLWeapon(this, LW_FIRE) || hitByEWeapon(this, EW_FIRE) || hitByEWeapon(this, EW_SCRIPT1))
                  burnToDeath(this, chungo, DMG_FLAME);

               doWalk(this, linkClose(this, 24) ? AGGRESSIVE_RAND : NORMAL_RAND, linkClose(this, 24) ? AGGRESSIVE_HOMING : NORMAL_HOMING, this->Step);
               
               Waitframe();
            }
         }
         Waitframe();
      }
   }

   void burnToDeath(npc n, int chungo, int damage) {
      n->Step += n->Step / 3;

      int burningCombo = getBurningCombo(chungo);
      int sprite = getBurningSprite(chungo);

      n->Dir = getInvertedDir(n->Dir);
      n->Step += n->Step / 2;

      n->LightRadius = 24;
      n->LightShape = LIGHT_CIRCLE;

      until (n->HP <= 0) {
         if (n->HP <= 0)
            n->Step = 0;

         int x = chungo ? n->X + 8 : n->X;
         int y = chungo ? n->Y + 8 : n->Y;

         if (n->HP < 10) {
            n->HP = 0;
            n->Step = 0;
         }
         else
            n->HP -= 1;

         n->Slide();

         if (gameframe % 5 == 0) {
            eweapon flame = CreateEWeaponAt(EW_FIRE, x - (chungo ? 8 : 0), y - (chungo ? 8 : 0));
            flame->Dir = n->Dir;
            flame->Script = Game->GetEWeaponScript("StopperKiller");
            flame->Z = n->Z;
            flame->InitD[1] = 120;
            flame->Gravity = true;
            flame->Damage = damage;
            flame->UseSprite(sprite);
            flame->Step = 0;
            flame->LightRadius = 16;
            flame->LightShape = LIGHT_CIRCLE;

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

         doWalk(n, linkClose(n, 24) ? AGGRESSIVE_RAND : NORMAL_RAND, linkClose(n, 24) ? AGGRESSIVE_HOMING : NORMAL_HOMING, n->Step, false, DOWALK_EIGHT_DIR);

         Waitframe();
      }

      for (int i = 0; i < 8; ++i) {
         eweapon flame = CreateEWeaponAt(EW_FIRE, n->X, n->Y);
         flame->Dir = i;
         flame->Step = chungo ? 160 : 120;
         flame->Angular = true;
         flame->Angle = DirRad(flame->Dir);
         flame->Script = Game->GetEWeaponScript("StopperKiller");
         flame->Z = n->Z;
         flame->InitD[0] = chungo ? 40 : 20;
         flame->InitD[1] = chungo ? 250 : 150;
         flame->Gravity = true;
         flame->Damage = damage;
         flame->UseSprite(sprite);
         flame->LightRadius = 16;
         flame->LightShape = LIGHT_CIRCLE;

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
      switch (GetHighestLevelItemOwned(IC_CANDLE)) {
         case 158: return chungo ? 7180 : 6344;
         case 10: return chungo ? 7184 : 6345;
         case 11: return chungo ? 7188 : 6346;
         case 150: return chungo ? 7192 : 6347;
         default: return 0;
      }
   }

   int getBurningSprite(int chungo) {
      switch (GetHighestLevelItemOwned(IC_CANDLE)) {
         case 158: return chungo ? SPR_ENEMY_FLAME_WAX2X2 : SPR_ENEMY_FLAME_WAX;
         case 10: return chungo ? SPR_ENEMY_FLAME_OIL2X2 : SPR_ENEMY_FLAME_OIL;
         case 11: return chungo ? SPR_ENEMY_FLAME_INCENDIARY2X2 : SPR_ENEMY_FLAME_INCENDIARY;
         case 150: return chungo ? SPR_ENEMY_FLAME_HELLS2X2 : SPR_ENEMY_FLAME_HELLS;
         default: return 0;
      }
   }
}

@Author("Emily")
npc script DisintegrateOnDeath {
    void run() {
        while(this->HP > 0) Waitframe();
        this->Explode(0);
    }
}

// clang-format off
// @Author("EmilyV99")
// npc script Mimic {
//    // clang-format on
//    void run(int speedMult, int fireRate, int knockbackDist) {
//       unless(speedMult) speedMult = 1;

//       unless(fireRate) fireRate = 30;

//       unless(knockbackDist) knockbackDist = 4;

//       int fireClock;

//       if (knockbackDist < 0)
//          this->NoSlide = true;
//       else
//          this->SlideSpeed = knockbackDist;

//       eweapon e;

//       while (true) {
//          while (this->Stun) {
//             this->Slide();
//             Waitframe();
//          }

//          this->Slide();

//          int xStep = -LinkMovement[LM_STICKX] * Hero->Step / 100 * speedMult;
//          int yStep = -LinkMovement[LM_STICKY] * Hero->Step / 100 * speedMult;

//          this->Dir = OppositeDir(Hero->Dir);
//          int step = Max(Abs(xStep), Abs(yStep));

//          int mDir = (yStep ? (yStep < 0 ? DIR_UP : DIR_DOWN) : -1);
//          mDir = Emily::addX(mDir, (xStep ? (xStep < 0 ? DIR_LEFT : DIR_RIGHT) : -1));

//          unless(fireClock) {
//             if (this->Dir == this->LinedUp(12, false)) {
//                this->Attack();
//                fireClock = fireRate;
//             }
//          }
//          else --fireClock;

//          if (mDir != -1) {
//             while (true) {
//                if (this->CanMove({mDir, step, 0})) {
//                   this->X += xStep;
//                   this->Y += yStep;
//                   break;
//                }

//                if (--step <= 0)
//                   break;

//                if (xStep)
//                   xStep > 0 ? --xStep : ++xStep;
//                if (yStep)
//                   yStep > 0 ? --yStep : ++yStep;
//             }
//          }

//          Waitframe();
//       }
//    }
// }

// clang-format off
@Author("Moosh, Emily")
npc script HammerBoi {
   // clang-format on

   using namespace GhostBasedMovement;
   using namespace EnemyNamespace;

   void run() {
      CONFIG DMG_HOLD_UP_HAMMER = this->WeaponDamage * .5;
      CONFIG DMG_SWING_HAMMER = this->WeaponDamage * 1.3;
      CONFIG DMG_SMASH_HAMMER = this->WeaponDamage * 1.5;

      int counter = -1;
      CONFIG COOLDOWN = 60;
      int timer;

      while (true) {
         if (this->HP <= 0)
            this->Step = 0;


         counter = ConstWalk4(this, counter);

         this->Slide();

         unless(timer) {
            if (Abs(this->X - Hero->X) < 32 && Abs(this->Y - Hero->Y) < 16) {
               int oldDir = this->Dir;
               this->Dir = faceLink(this);
               hammerAnim(this, DMG_HOLD_UP_HAMMER, DMG_SWING_HAMMER, DMG_SMASH_HAMMER);
               this->Dir = oldDir;
               timer = COOLDOWN;
            }
         }
         else --timer;

         Waitframe();
      }
   }

   void hammerAnim(npc this, int holdUpDamage, int swingDamage, int smashDamage) {
      this->ScriptTile = this->OriginalTile + 4 * this->Dir;

      Coordinates xy = new Coordinates();

      hammerAnimHoldUp(this, xy, holdUpDamage);
      hammerAnimSwing(this, xy, swingDamage);
      hammerAnimSmash(this, xy, smashDamage);

      this->ScriptTile = -1;
   }

   void hammerAnimHoldUp(npc this, Coordinates xy, int damage, int frames = 20) {
      for (int i = 0; i < frames; ++i) {
         if (this->HP <= 0)
            break;

         hammerFrame(this, 0, damage, xy);
         Waitframe();
      }
   }

   void hammerAnimSwing(npc this, Coordinates xy, int damage) {
      for (int i = 0; i < 4; ++i) {
         if (this->HP <= 0)
            break;

         hammerFrame(this, 1, damage, xy);
         Waitframe();
      }

      hammerFrame(this, 2, damage, xy, true);

      if (this->HP > 0)
         Audio->PlaySound(SFX_HAMMER);
   }

   void hammerAnimSmash(npc this, Coordinates xy, int damage, int frames = 30) {
      for (int i = 0; i < frames; ++i) {
         if (this->HP <= 0)
            break;

         hammerFrame(this, 2, damage, xy);

         if (i == 0) {
            if (int escr = CheckEWeaponScript("HammerImpactEffect")) {
               eweapon weap = RunEWeaponScriptAt(EW_SCRIPT10, escr, xy->X, xy->Y, {49852});
               weap->ScriptTile = TILE_INVIS;
            }
         }

         Waitframe();
      }
   }

   void hammerFrame(npc this, int frame, int damage, Coordinates xy, bool doNothing = false) {
      const int TILE_HAMMER = 49840;
      const int CSET_HAMMER = 8;
      int x = this->X;
      int y = this->Y;

      switch (this->Dir) {
         case DIR_UP:
            switch (frame) {
               case 0: y -= 14; break;
               case 1: y -= 12; break;
               case 2: y -= 13; break;
            }
            break;
         case DIR_DOWN:
            switch (frame) {
               case 0: y -= 12; break;
               case 1: y += 4; break;
               case 2: y += 14; break;
            }
            break;
         case DIR_LEFT:
            switch (frame) {
               case 0: y -= 14; break;
               case 1:
                  x -= 12;
                  y -= 12;
                  break;
               case 2: x -= 14; break;
            }
            break;
         case DIR_RIGHT:
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

      unless(doNothing) {
         eweapon hammer = FireEWeapon(EW_SCRIPT10, x, y, 0, 0, damage, 0, 0, EWF_UNBLOCKABLE);
         hammer->ScriptTile = TILE_HAMMER + 3 * this->Dir + frame;
         hammer->CSet = CSET_HAMMER;
         hammer->Timeout = 2;

         if (frame < 2)
            hammer->NoCollisionTimer = -1;
      }

      xy->X = x;
      xy->Y = y;
   }
}

// clang-format off
@Author("Deathrider365")
npc script GraveDudeGoneApe {
   // clang-format on

   using namespace EnemyNamespace;

   void run() {
      gridLockNPC(this);
      this->ASpeed = 15;

      while (true) {
         if (this->HP <= this->HP * .2)
            this->Remove();

         this->Slide();
         doWalk(this, this->Random, this->Homing, this->Step);
         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365")
npc script Bomber {
   // clang-format on

   using namespace EnemyNamespace;

   void run() {
      CONFIG DMG_BOMB = this->WeaponDamage * 2;
      CONFIG DMG_BOMB_EXPLOSION = this->WeaponDamage;

      int attackCooldown = 150 + Rand(-30, 30);

      while (true) {
         if (this->HP <= 0)
            this->Step = 0;

         this->Z = 1;
         this->FakeZ = 10;
         this->FakeJump = 10;
         doWalk(this, 3, 1, 30, true, DOWALK_EIGHT_DIR);

         unless(attackCooldown) {
            Waitframes(15);
            eweapon bomb = FireAimedEWeapon(EW_BOMB, this->X + 8, this->Y - 6, 0, 200, DMG_BOMB, -1, -1, EWF_UNBLOCKABLE | EWF_ROTATE);
            runEWeaponScript(bomb, Game->GetEWeaponScript("ArcingWeapon"), <untyped[]>{-1, 0, AE_BOMB_EXPLOSION, this, DMG_BOMB_EXPLOSION, 0, true});
            attackCooldown = 150 + Rand(-30, 30);
         }

         --attackCooldown;
         Waitframe();
      }
   }
}

// Gives an enemy a mace to swing at Link
// clang-format off
@Author("Joe123")
ffc script MaceEnemy {
   // clang-format on
   CONFIG T_CHAIN = 196; // Mace Chain
   CONFIG T_HEAD = 197;  // Mace Head

   void run(int num, int maxradius, int damage) {
      int counter = Rand(360);
      int spintimer;
      int radius = maxradius;
      int x;
      int y;
      int ret;

      Waitframes(4);
      npc e = Screen->LoadNPC(num);

      while (e->isValid()) {
         spintimer = 0;

         // spin the ball
         while (spintimer < 240 + Rand(120) && e->isValid()) {
            SpinBall(radius, counter, num, damage, false);

            if (spintimer % 90 == 0)
               Audio->PlaySound(SFX_BRANG);

            spintimer++;
            counter = (counter + 3) % 360;
            Waitframe();
         }

         // pull the ball in
         while (radius > 20 && e->isValid()) {
            SpinBall(radius, counter, num, damage, false);
            radius -= 2;
            counter = (counter + 3) % 360;
            Waitframe();
         }

         spintimer = 0;

         // spin very fast with small radius
         while (spintimer < 120 && e->isValid()) {
            SpinBall(radius, counter, num, damage, false);

            if (spintimer % 30 == 0)
               Audio->PlaySound(SFX_BRANG);

            spintimer++;
            counter = (counter + 10) % 360;
            Waitframe();
         }

         // throw at Link
         x = Hero->X;
         y = Hero->Y;
         counter = 4;
         ret = 1;

         while (e->isValid() && counter > 0) {
            SpinBall(counter, ArcTan((x - e->X), (y - e->Y)), num, damage, true);

            if (Abs(x - (e->X + RadianCos(ArcTan((x - e->X), (y - e->Y))) * counter)) < 4 && Abs(y - (e->Y + RadianSin(ArcTan((x - e->X), (y - e->Y))) * counter)) < 4) {
               if (ret == 1) {
                  Audio->PlaySound(SFX_HAMMER);
                  Pause(counter, ArcTan((x - e->X), (y - e->Y)), num, damage);
               }
               // return
               ret = -1;
            }
            counter += 4 * ret;
            Waitframe();
         }

         Pause(0, 0, num, damage);

         // bring back to main spin position
         counter = Floor(ArcTan((x - e->X), (y - e->Y)) * 180 / PI);
         radius = 0;

         while (radius < maxradius && e->isValid()) {
            SpinBall(radius, counter, num, damage, false);
            radius += 2;
            counter = (counter + 3) % 360;
            Waitframe();
         }
      }
      Screen->ClearSprites(SL_EWPNS);
   }

   void Pause(int r, int c, int n, int d) {
      for (int i = 0; i < 10; i++) {
         SpinBall(r, c, n, d, true);
         Waitframe();
      }
   }

   void SpinBall(int radius, int counter, int num, int damage, bool radians) {
      npc e = Screen->LoadNPC(num);
      Screen->ClearSprites(SL_EWPNS);

      for (int i = 0; i < 5; i++) {
         eweapon ball = Screen->CreateEWeapon(EW_SCRIPT1);

         if (i < 4)
            ball->Tile = T_CHAIN;
         else
            ball->Tile = T_HEAD;

         ball->Damage = damage;

         if (radians) {
            ball->X = e->X + RadianCos(counter) * (radius * (i + 1) / 5);
            ball->Y = e->Y + RadianSin(counter) * (radius * (i + 1) / 5);
         }
         else {
            ball->X = e->X + Cos(counter) * (radius * (i + 1) / 5);
            ball->Y = e->Y + Sin(counter) * (radius * (i + 1) / 5);
         }
      }
   }
}

// clang-format off
// @Author("Moosh")
// npc script BSGanon {
//    // clang-format on
//    CONFIG SFX_BS_GANON_FANFARE = 64;  // Sound that plays when entering the room
//    CONFIG SFX_BS_GANON_HIT = 63;      // Looping hit sound during Ganon's death
//    CONFIG SFX_BS_GANON_DEATH = 62;    // Screen flash sound during Ganon's death
//    CONFIG SFX_BS_GANON_TRIFORCE = 65; // Sound of the triforce appearing

//    CONFIG MIDI_BS_GANON = 13; // MIDI that plays when you enter the screen with Ganon. I'm assuming you're using MIDI right? If not, make it negative for enhanced music. Can read it off a ZQuest string.
//    CONFIG TRACK_BS_GANON = 0; // On the even rarer chance you're using trackers...

//    CONFIG C_BS_GANON_FLASHYELLOW = 0xEB; // Yellow used for the hit animation
//    CONFIG C_BS_GANON_FLASHWHITE = 0x01;  // White for the fade out
//    CONFIG _THISPTR = 0;
//    CONFIG _OTILE = 1;
//    CONFIG _FLASHTILES = 2;
//    CONFIG _SILVERHIT = 3;

//    void SetTile(untyped dat, int frame) {
//       npc this = dat[_THISPTR];
//       int oTile = dat[_OTILE];
//       bitmap flashTiles = dat[_FLASHTILES];
//       bool silverHit = dat[_SILVERHIT];

//       if (!silverHit)
//          this->ScriptTile = oTile + frame * this->TileWidth;
//    }
//    void SetFlashingTile(untyped dat, int frame, int flashLevel) {
//       npc this = dat[_THISPTR];
//       int oTile = dat[_OTILE];
//       bitmap flashTiles = dat[_FLASHTILES];
//       bool silverHit = dat[_SILVERHIT];

//       int x = frame * 32;
//       int y = flashLevel * 32;

//       flashTiles->WriteTile(0, x, y, oTile + 9 * this->TileWidth, true, false);
//       flashTiles->WriteTile(0, x + 16, y, oTile + 9 * this->TileWidth + 1, true, false);
//       flashTiles->WriteTile(0, x, y + 16, oTile + 9 * this->TileWidth + 20, true, false);
//       flashTiles->WriteTile(0, x + 16, y + 16, oTile + 9 * this->TileWidth + 21, true, false);

//       this->ScriptTile = oTile + 9 * this->TileWidth;
//    }
//    bool WaitArrowCollision(untyped dat, int frames) {
//       npc this = dat[_THISPTR];
//       int oTile = dat[_OTILE];
//       bitmap flashTiles = dat[_FLASHTILES];
//       bool silverHit = dat[_SILVERHIT];
//       for (int i = 0; i < frames && !silverHit; ++i) {
//          int hitby = this->HitBy[2]; // lweapon
//          if (hitby) {
//             lweapon l = Screen->LoadLWeapon(hitby);
//             Trace(l->ID);
//             Trace(l->Level);
//             if (l->ID == LW_ARROW && l->Level > 1) {
//                dat[_SILVERHIT] = true;
//             }
//          }
//          Waitframe();
//       }
//    }
//    // This teleport function is probably even janker than engine. Whoops
//    void Teleport(npc this) {
//       int targetPos[] = {51, 59, 99, 107, 39, 119, 82, 92};
//       int x;
//       int y;
//       int pos;
//       // Loop over preset combo positions to find one suitably far from Link
//       for (int i = 0; i < 24; ++i) {
//          pos = targetPos[Rand(8)];
//          if (i > 15)
//             pos = targetPos[i - 16];
//          x = ComboX(pos);
//          y = ComboY(pos);
//          if (Distance(x + 8, y + 8, Hero->X, Hero->Y) >= 96)
//             break;
//       }
//       this->X = x;
//       this->Y = y;
//    }
//    void run(int stunnedID) {
//       // If HP starts out at <0, this instance of the enemy was created to change the sprite palette
//       if (this->HP <= 0)
//          Quit();

//       // 1 extra HP to account for health bar scripts
//       ++this->HP;

//       // Store the enemy's defenses
//       int defs[36];
//       for (int i = 0; i < 36; ++i) {
//          defs[i] = this->Defense[i];
//       }

//       // Scale and position
//       int oTile = this->Tile;
//       this->Extend = 3;
//       this->TileWidth = 2;
//       this->TileHeight = 2;
//       this->HitWidth = 32;
//       this->HitHeight = 32;
//       this->X = 112;
//       this->Y = 80;

//       // Create the bitmap used for drawing Ganon when flashing
//       bitmap flashTiles = Game->CreateBitmap(320, 64);
//       flashTiles->Clear(0);
//       flashTiles->DrawTile(0, 0, 0, oTile, 20, 2, 14, -1, -1, 0, 0, 0, 0, false, 128);
//       flashTiles->ReplaceColors(0, C_BS_GANON_FLASHYELLOW, 0xE1, 0xEF);
//       flashTiles->DrawTile(0, 0, 32, oTile, 20, 2, 14, -1, -1, 0, 0, 0, 0, false, 128);
//       flashTiles->Blit(0, flashTiles, 0, 0, 320, 32, 0, 32, 320, 32, 0, 0, 0, BITDX_TRANS, 0, true);
//       flashTiles->Blit(0, flashTiles, 0, 0, 320, 32, 0, 32, 320, 32, 0, 0, 0, BITDX_TRANS, 0, true);

//       bitmap dissolve = Game->CreateBitmap(96, 32);
//       dissolve->Clear(0);

//       this->NoCollisionTimer = -1;
//       while (Hero->X < 32 || Hero->X > 208 || Hero->Y < 32 || Hero->Y > 128) {
//          Waitframe();
//       }

//       untyped dat[] = {this, oTile, flashTiles, false};

//       // Spawn in animation
//       Game->PlayMIDI(0);
//       Audio->PlaySound(SFX_BS_GANON_FANFARE);
//       WaitNoAction(64);
//       SetTile(dat, 1);
//       WaitNoAction(5);
//       SetTile(dat, 2);
//       WaitNoAction(5);
//       SetTile(dat, 3);
//       WaitNoAction(5);
//       SetTile(dat, 4);
//       WaitNoAction(5);
//       SetTile(dat, 5);
//       WaitNoAction(26);
//       for (int i = 0; i < 7; ++i) {
//          SetTile(dat, 4);
//          WaitNoAction(9);
//          SetTile(dat, 5);
//          WaitNoAction(9);
//       }
//       WaitNoAction(96);
//       SetTile(dat, 3);
//       WaitNoAction(5);
//       SetTile(dat, 2);
//       WaitNoAction(5);
//       SetTile(dat, 1);
//       WaitNoAction(5);
//       SetTile(dat, 0);
//       WaitNoAction(5);
//       for (int i = 0; i < 6; ++i) {
//          this->DrawXOffset = -1000;
//          WaitNoAction(2);
//          this->DrawXOffset = 0;
//          WaitNoAction(2);
//       }
//       Teleport(this);
//       this->DrawXOffset = -1000;
//       int shotTimer = 64;
//       if (MIDI_BS_GANON > 0)
//          Game->PlayMIDI(MIDI_BS_GANON);
//       else if (MIDI_BS_GANON < 0) {
//          int str[512];
//          Game->GetMessage(Abs(MIDI_BS_GANON), str);
//          Game->PlayEnhancedMusic(str, TRACK_BS_GANON);
//       }
//       this->NoCollisionTimer = 0;
//       this->Immortal = true;
//       this->NoSlide = true;
//       int startHP = this->HP;
//       int lastHP = this->HP;
//       while (true) {
//          // Shoot a fireball every 64 frames
//          if (shotTimer)
//             --shotTimer;
//          else {
//             eweapon e = CreateEWeaponAt(EW_FIREBALL, this->X, this->Y);
//             e->Angular = true;
//             e->Dir = AngleDir4(Angle(e->X, e->Y, Hero->X, Hero->Y));
//             e->Angle = DegtoRad(Angle(e->X, e->Y, Hero->X, Hero->Y));
//             e->Step = 150;
//             e->Damage = this->WeaponDamage;
//             e->UseSprite(17);
//             e->Unblockable = UNBLOCK_ALL;
//             shotTimer = 64;
//          }

//          this->HP = Max(this->HP, 1);
//          if (this->HP < lastHP) {
//             if (this->HP > 1) { // Hit animation
//                for (int i = 0; i < 36; ++i) {
//                   if (i == NPCD_SWORD)
//                      this->Defense[i] = NPCDT_IGNORE;
//                   else
//                      this->Defense[i] = NPCDT_BLOCK;
//                }
//                this->DrawXOffset = 0;
//                // Flash
//                for (int i = 0; i < 5; ++i) {
//                   SetTile(dat, 6);
//                   Waitframes(3);
//                   SetFlashingTile(dat, 6, 1);
//                   Waitframe();
//                   SetFlashingTile(dat, 6, 0);
//                   Waitframe();
//                   SetFlashingTile(dat, 6, 1);
//                   Waitframe();
//                }
//                SetTile(dat, 6);
//                Waitframes(12);
//                SetTile(dat, 5);
//                Waitframes(7);
//                SetTile(dat, 3);
//                Waitframes(5);
//                SetTile(dat, 2);
//                Waitframes(5);
//                SetTile(dat, 1);
//                Waitframes(5);
//                SetTile(dat, 0);
//                Waitframes(5);
//                // Flicker
//                for (int i = 0; i < 6; ++i) {
//                   this->DrawXOffset = -1000;
//                   Waitframes(2);
//                   this->DrawXOffset = 0;
//                   Waitframes(2);
//                }
//                this->DrawXOffset = -1000;
//                for (int i = 0; i < 36; ++i) {
//                   this->Defense[i] = defs[i];
//                }
//                Teleport(this);
//             }
//             else { // Turn blue animation
//                this->DrawXOffset = 0;
//                // Create a new enemy to update the sprite palette, then instantly kill it. Hooray for jank
//                npc n = CreateNPCAt(stunnedID, 120, -32);
//                n->ItemSet = 0;
//                n->HP = -1000;
//                SetTile(dat, 5);
//                WaitArrowCollision(dat, 32);
//                for (int i = 0; i < 36; ++i) {
//                   if (i == NPCD_ARROW)
//                      this->Defense[i] = NPCDT_NONE;
//                   else
//                      this->Defense[i] = NPCDT_IGNORE;
//                }
//                SetTile(dat, 4);
//                WaitArrowCollision(dat, 9);
//                SetTile(dat, 8);
//                WaitArrowCollision(dat, 9);
//                SetTile(dat, 6);
//                for (int i = 0; i < 300; ++i) {
//                   WaitArrowCollision(dat, 1);
//                }
//                WaitArrowCollision(dat, 9);
//                SetTile(dat, 8);
//                WaitArrowCollision(dat, 10);
//                SetTile(dat, 4);
//                WaitArrowCollision(dat, 8);
//                SetTile(dat, 5);
//                WaitArrowCollision(dat, 68);
//                // Ganon was hit by a silver arrow, play death animation
//                if (dat[_SILVERHIT]) {
//                   // Randomize the order to dissolve pixels in
//                   int pixelOrder[1024];
//                   for (int i = 0; i < 1024; ++i) {
//                      pixelOrder[i] = i;
//                   }
//                   for (int i = 0; i < 4096; ++i) {
//                      int whichA = Rand(1024);
//                      int whichB = Rand(1024);
//                      int backup = pixelOrder[whichB];
//                      pixelOrder[whichB] = pixelOrder[whichA];
//                      pixelOrder[whichA] = backup;
//                   }
//                   this->NoCollisionTimer = -1;
//                   flashTiles->Clear(0);
//                   flashTiles->DrawTile(0, 0, 0, this->ScriptTile, 2, 2, this->CSet, -1, -1, 0, 0, 0, 0, true, 128);
//                   Audio->PlaySound(SFX_BS_GANON_DEATH);
//                   int erasedPixels;
//                   this->DrawXOffset = -1000;
//                   for (int i = 0; i < 240; ++i) {
//                      if (i % 32 == 0)
//                         Audio->PlaySound(SFX_BS_GANON_HIT);
//                      if (i % 2 == 0) {
//                         this->HitXOffset = Rand(-1, 1);
//                         this->HitYOffset = Rand(-1, 1);
//                         if (i > 32) {
//                            for (int j = 0; j < 12; ++j) {
//                               if (erasedPixels < 1024) {
//                                  flashTiles->PutPixel(0, pixelOrder[erasedPixels] % 32, Floor(pixelOrder[erasedPixels] / 32), 0x00, 0, 0, 0, 128);
//                                  ++erasedPixels;
//                               }
//                            }
//                         }
//                      }
//                      flashTiles->Blit(2, RT_SCREEN, 0, 0, 32, 32, this->X + this->HitXOffset, this->Y + this->DrawYOffset + this->HitYOffset, 32, 32, 0, 0, 0, 0, 0, true);
//                      if (i > 240 * 0.25)
//                         Screen->Rectangle(6, 0, 0, 255, 175, C_BS_GANON_FLASHWHITE, 1, 0, 0, 0, true, 64);
//                      if (i > 240 * 0.5)
//                         Screen->Rectangle(6, 0, 0, 255, 175, C_BS_GANON_FLASHWHITE, 1, 0, 0, 0, true, 64);
//                      if (i > 240 * 0.75)
//                         Screen->Rectangle(6, 0, 0, 255, 175, C_BS_GANON_FLASHWHITE, 1, 0, 0, 0, true, 128);
//                      WaitNoAction();
//                   }
//                   item triforce = CreateItemAt(I_TRIFORCEBIG, this->X + 8, this->Y + 8);
//                   triforce->Pickup = IP_DUMMY;
//                   item dust = CreateItemAt(I_DUST_PILE, this->X + 8, this->Y + 12);
//                   dust->HitXOffset = -1000;
//                   dust->Pickup = IP_DUMMY;
//                   Audio->PlaySound(SFX_BS_GANON_TRIFORCE);
//                   for (int i = 0; i < 154; ++i) {
//                      if (i < 240 * 0.75)
//                         Screen->Rectangle(6, 0, 0, 255, 175, C_BS_GANON_FLASHWHITE, 1, 0, 0, 0, true, 64);
//                      if (i < 240 * 0.5)
//                         Screen->Rectangle(6, 0, 0, 255, 175, C_BS_GANON_FLASHWHITE, 1, 0, 0, 0, true, 64);
//                      if (i < 240 * 0.25)
//                         Screen->Rectangle(6, 0, 0, 255, 175, C_BS_GANON_FLASHWHITE, 1, 0, 0, 0, true, 128);
//                      WaitNoAction();
//                   }
//                   triforce->Pickup = 0;
//                   while (triforce->isValid()) {
//                      Waitframe();
//                   }
//                   // Allow the enemy to die and shutters to open
//                   this->DrawXOffset = -1000;
//                   this->Immortal = false;
//                   this->ItemSet = 0;
//                   this->HP = -1000;
//                }
//                // Changing the sprite palette back. Ganon practices self harm
//                n = CreateNPCAt(this->ID, 120, -32);
//                n->ItemSet = 0;
//                n->HP = -1000;
//                for (int i = 0; i < 36; ++i) {
//                   if (i == NPCD_SWORD)
//                      this->Defense[i] = NPCDT_IGNORE;
//                   else
//                      this->Defense[i] = NPCDT_BLOCK;
//                }
//                SetTile(dat, 3);
//                Waitframes(5);
//                SetTile(dat, 2);
//                Waitframes(6);
//                SetTile(dat, 1);
//                Waitframes(4);
//                SetTile(dat, 0);
//                Waitframes(6);
//                for (int i = 0; i < 10; ++i) {
//                   this->DrawXOffset = -1000;
//                   Waitframes(2);
//                   this->DrawXOffset = 0;
//                   Waitframes(2);
//                }
//                this->DrawXOffset = -1000;
//                for (int i = 0; i < 36; ++i) {
//                   this->Defense[i] = defs[i];
//                }
//                this->HP = startHP;
//                Teleport(this);
//             }
//          }
//          lastHP = this->HP;

//          this->ConstantWalk({this->Rate, this->Homing, 0});
//          Waitframe();
//       }
//    }
// }

// clang-format off
// @Author("Moosh"),
// @InitD0("Num Links"),
// @InitDHelp0("How many chain links the chomp has. This determines its leash distance.")
// npc script Chainchomp {
//    // clang-format on

//    CONFIG SFX_CHOMP = 89; // Sound the chain chomp makes when it charges
//    using namespace NPCAnim;

//    void run(int numLinks) {
//       if (numLinks == 0)
//          numLinks = 8;
//       numLinks = Clamp(numLinks, 3, 32);
//       ++numLinks;
//       int maxDist = (numLinks - 1) * 8;

//       Waitspawn(this);

//       AnimHandler aptr = new AnimHandler(this);
//       aptr->AddAnim(0, 0, 1, 1, ADF_8WAY);

//       int homeX = this->X;
//       int homeY = this->Y;
//       int chainX[33];
//       int chainY[33];
//       for (int i = 0; i < 33; i++) {
//          chainX[i] = this->X;
//          chainY[i] = this->Y;
//       }

//       int vars[16] = {chainX, chainY, numLinks};
//       int chompAngle;
//       ChompWaitframe(this, vars, 10);
//       this->MoveFlags[NPCMV_IGNORE_SOLIDITY] = true;
//       this->MoveFlags[NPCMV_OBEYS_GRAVITY] = true;
//       this->MoveFlags[NPCMV_CAN_PITFALL] = false;
//       this->MoveFlags[NPCMV_CAN_PIT_WALK] = true;
//       this->MoveFlags[NPCMV_CAN_WATERDROWN] = false;
//       this->MoveFlags[NPCMV_CAN_WATER_WALK] = true;
//       while (true) {
//          int numHops = Rand(4, 6);
//          // Do 4-6 hops, keep hopping until within the home distance
//          for (int i = 0; i < numHops || Distance(this->X, this->Y, homeX, homeY) >= 7 * vars[2]; i++) {
//             if (Distance(this->X, this->Y, homeX, homeY) < maxDist)
//                chompAngle = Rand(360);
//             else
//                chompAngle = Angle(this->X, this->Y, homeX, homeY) + Rand(-45, 45);
//             this->Jump = 1;
//             while (this->Jump > 0 || this->Z > 0) {
//                this->MoveAtAngle(chompAngle, this->Step / 100, SPW_FLOATER);
//                this->Dir = AngleDir8(WrapDegrees(chompAngle));
//                ChompWaitframe(this, vars);
//             }
//             // 1/3 of the time, pause after a hop
//             if (Rand(3) == 0) {
//                ChompWaitframe(this, vars, 20);
//             }
//          }
//          // If Link is within 40 pixels of the home distance, do a charge
//          if (Distance(Hero->X, Hero->Y, homeX, homeY) < maxDist + 40) {
//             chompAngle = Angle(this->X, this->Y, Hero->X, Hero->Y);
//             bool cancharge = true;
//             int X = this->X;
//             int Y = this->Y;
//             bool obeyNoEnemy = this->MoveFlags[NPCMV_IGNORE_BLOCKFLAGS];
//             this->MoveFlags[NPCMV_IGNORE_BLOCKFLAGS] = true;
//             // Project the charge to see if it passes over no enemy combos
//             for (int i = 0; i < 60 && Distance(this->X, this->Y, homeX, homeY) < maxDist; i++) {
//                this->MoveAtAngle(chompAngle, this->Step / 100 * 2.6666, SPW_FLOATER);
//                if (ComboFI(this->X + 8, this->Y + 8, 96))
//                   cancharge = false;
//             }
//             this->X = X;
//             this->Y = Y;
//             this->MoveFlags[NPCMV_IGNORE_BLOCKFLAGS] = obeyNoEnemy;
//             // Do the charge if able
//             if (cancharge) {
//                ChompWaitframe(this, vars, 10);
//                Audio->PlaySound(SFX_CHOMP);
//                for (int i = 0; i < 60 && Distance(this->X, this->Y, homeX, homeY) < maxDist; i++) {
//                   this->MoveAtAngle(chompAngle, this->Step / 100 * 2.6666, SPW_FLOATER);
//                   this->Dir = AngleDir8(WrapDegrees(chompAngle));
//                   ChompWaitframe(this, vars);
//                }
//                ChompWaitframe(this, vars, 90);
//             }
//          }
//       }
//    }
//    void UpdateChain(npc this, int vars) {
//       AnimHandler aptr = GetAnimHandler(this);
//       int til = aptr->OriginalTile + 8;

//       int Combo = this->Attributes[10];
//       int chainX = vars[0];
//       int chainY = vars[1];
//       int numLinks = vars[2];
//       int vX[33];
//       int vY[33];
//       int sz = SizeOfArray(chainX);
//       for (int i = 1; i < numLinks - 1; i++) {
//          vX[i] = 0;
//          vY[i] = 0;
//          float d1 = Distance(chainX[i], chainY[i], chainX[i + 1], chainY[i + 1]);
//          float a1 = Angle(chainX[i], chainY[i], chainX[i + 1], chainY[i + 1]);
//          float d2 = Distance(chainX[i], chainY[i], chainX[i - 1], chainY[i - 1]);
//          float a2 = Angle(chainX[i], chainY[i], chainX[i - 1], chainY[i - 1]);
//          if (d1 >= 8 || d2 >= 8) {
//             vX[i] += VectorX(d1 / 4, a1) + VectorX(d2 / 4, a2);
//             vY[i] += VectorY(d1 / 4, a1) + VectorY(d2 / 4, a2);
//          }
//       }

//       for (int i = 1; i < numLinks; i++) {
//          chainX[i] += vX[i];
//          chainY[i] += vY[i];
//          if (Hero->HP > 0)
//             Screen->FastTile(SPLAYER_EWEAP_BEHIND_DRAW, chainX[i], chainY[i], til, this->CSet, OP_OPAQUE);
//       }
//    }
//    void ChompWaitframe(npc this, int vars, int frames = 1) {
//       for (int i = 0; i < frames; ++i) {
//          int chainX = vars[0];
//          int chainY = vars[1];
//          chainX[0] = this->X;
//          chainY[0] = this->Y - this->Z;
//          UpdateChain(this, vars);
//          Waitframe(this);
//       }
//    }
// }

// clang-format off
// @Author("Moosh"),
//Eyegore Script
//Attribute 1: The distance in pixels at which the enemy detects Link
//Attribute 2: How long the enemy moves for
//Attribute 3: How long the enemy pauses after moving before moving again
//Attribute 11: The first of 7 combos. Up, Down, Left, Right, Eye Closed, Eye Opening, Eye Open
//Attribute 12: The slot this script is loaded into
// ffc script Eyegore{
//    // clang-format on

//    void run(int enemyid) {
//       npc ghost = Ghost_InitAutoGhost(this, enemyid);
//       Ghost_SetFlag(GHF_NORMAL);
//       Ghost_SetFlag(GHF_REDUCED_KNOCKBACK);
//       int DetectDist = Ghost_GetAttribute(ghost, 0, 32);
//       int MovementTime = Ghost_GetAttribute(ghost, 1, 240);
//       int CooldownPause = Ghost_GetAttribute(ghost, 2, 120);
//       int Combo = ghost->Attributes[10];
//       int Defenses[18];
//       Ghost_StoreDefenses(ghost, Defenses);
//       Ghost_Data = Combo + 4;
//       Ghost_SetAllDefenses(ghost, NPCDT_BLOCK);
//       ghost->Defense[NPCD_FIRE] = NPCDT_IGNORE;
//       int Counter = -1;
//       while (true) {
//          // Wait for Link to come into range
//          while (Distance(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY()) > DetectDist) {
//             Ghost_Waitframe(this, ghost);
//          }
//          // Open eye and become vulnerable
//          Ghost_Data = Combo + 5;
//          Ghost_Waitframes(this, ghost, 20);
//          Ghost_Data = Combo + 6;
//          Ghost_Waitframes(this, ghost, 20);
//          Ghost_Data = Combo;
//          Ghost_SetFlag(GHF_4WAY);
//          Ghost_SetDefenses(ghost, Defenses);
//          // Move about like a normal enemy
//          for (int i = 0; i < MovementTime; i++) {
//             Counter = Ghost_ConstantWalk4(Counter, ghost->Step, ghost->Rate, ghost->Homing, ghost->Hunger);
//             Ghost_Waitframe(this, ghost);
//          }
//          // Close eye and set defenses back
//          Ghost_Data = Combo + 6;
//          Ghost_UnsetFlag(GHF_4WAY);
//          Ghost_SetAllDefenses(ghost, NPCDT_BLOCK);
//          ghost->Defense[NPCD_FIRE] = NPCDT_IGNORE;
//          Ghost_Waitframes(this, ghost, 20);
//          Ghost_Data = Combo + 5;
//          Ghost_Waitframes(this, ghost, 20);
//          Ghost_Data = Combo + 4;
//          // Pause before opening eye again
//          Ghost_Waitframes(this, ghost, CooldownPause);
//       }
//    }
// }

// clang-format off
// @Author("LinkTheMaster"),
// This script is for a fire keese, which harms Link when he slashes at it
// IMPORTANT: This requires ghost.zh to be setup first
	// Type: Other (Floating)
	// Attributes to set for the fire keese
	// Random Rate: The number of 8 pixel segments the keese will go before changing directions (DEFAULT: 6)
	// Homing Factor: The percentage (0-100) of times the keese will go toward Link when changing directions
	// Misc Attribute 11: The value set to GH_INVISIBLE_COMBO or -1
	// Misc Attribute 12: The ffc script slot
	// Be sure to check "Damaged by Power 0 Weapons" under Misc. Flags if you want the level 1 boomerang to hurt it!
// ffc script FireKeese {
//    // clang-format on

//    void run(int enemyID) {
//       npc ghost;

//       // Initialize - come to life and set the combo
//       ghost = Ghost_InitAutoGhost(this, enemyID);
//       Ghost_SetFlag(GHF_SET_DIRECTION);
//       Ghost_SetFlag(GHF_FLYING_ENEMY);
//       Ghost_SetFlag(GHF_IGNORE_WATER);
//       Ghost_SetFlag(GHF_IGNORE_PITS);
//       Ghost_SetFlag(GHF_FAKE_Z);

//       float step = ghost->Step / 100;
//       float maxSegments = ghost->Rate;
//       if (maxSegments <= 0)
//          maxSegments = 5;

//       int movingDir = Rand(8);
//       int movingDistance = (Rand(5) + 1) * 8; // 8-48 pixels

//       // Give the keese a chance to go after Link
//       if (Rand(100) < ghost->Homing)
//          movingDir = RadianAngleDir8(RadianAngle(this->X, this->Y, Hero->X, Hero->Y));

//       // Continue while the keese is still alive
//       while (Ghost_HP > 0) {
//          // See how far the keese is going to move this round
//          int dist = movingDistance;
//          if (dist > step)
//             dist = step;
//          movingDistance -= dist;

//          // If the keese has stopped going in its current direction or needs to move
//          if (movingDistance == 0 || !Ghost_CanMove(movingDir, dist, 0)) {
//             int newDir = Rand(8);

//             // Give a chance for the keese to attack Link
//             if (ghost->Homing > 0 && Rand(100) < ghost->Homing)
//                newDir = RadianAngleDir8(RadianAngle(this->X, this->Y, Hero->X, Hero->Y));

//             // If the new direction doesn't work, increment and try again
//             for (int i = 1; i < 8 && !Ghost_CanMove(newDir, 8, 0); i++)
//                newDir = (newDir + 1) % 8;

//             movingDir = newDir;
//             movingDistance = (Rand(5) + 1) * 8 - step; // 8-48 pixels
//             dist = step;
//          }

//          Ghost_Z = 8;
//          Ghost_Move(movingDir, dist, 0);
//          Ghost_Waitframe(this, ghost, true, false);
//       }

//       eweapon linkDamager;

//       // The keese is dead, so damage Link if he hit it with the sword
//       for (int i = 1; i <= Screen->NumLWeapons(); i++) {
//          lweapon temp = Screen->LoadLWeapon(i);
//          if ((temp->ID == LW_SWORD || temp->ID == LW_HAMMER || temp->ID == LW_WAND) && Collision(temp, ghost)) {
//             // Create an eweapon to damage Link
//             linkDamager = Screen->CreateEWeapon(EW_FIREBALL);
//             linkDamager->Dir = RadianAngleDir4(Angle(temp->X, temp->Y, Hero->X, Hero->Y)) + 8;
//             linkDamager->X = Hero->X;
//             linkDamager->Y = Hero->Y;
//             linkDamager->Tile = GH_BLANK_TILE;
//             linkDamager->OriginalTile = GH_BLANK_TILE;
//             linkDamager->NumFrames = 0;
//             linkDamager->Damage = ghost->Damage;
//          }
//       }

//       // Wait to remove the damager so that it doesn't staw on the screen forever
//       for (int i = 0; linkDamager->isValid() && i < 20; i++) {
//          linkDamager->X = Hero->X;
//          linkDamager->Y = Hero->Y;
//          Waitframe();
//       }
//       if (linkDamager->isValid())
//          Remove(linkDamager);
//    }
// } //! End of ffc script FireKeese


// clang-format off
// @Author("Mero")
// ffc script HardhatBeetle {
//    // clang-format on

//    CONFIG HARDHAT_ATTR_MIN_STEP = 0;
//    CONFIG HARDHAT_ATTR_MAX_STEP = 1;

//    void run(int enemyID) {
//       // Initialize
//       npc ghost = Ghost_InitAutoGhost(this, enemyID);
//       Ghost_SetFlag(GHF_STUN);
//       Ghost_SetFlag(GHF_CLOCK);

//       // Movement Variables
//       int minStep = Ghost_GetAttribute(ghost, HARDHAT_ATTR_MIN_STEP, 67);
//       int maxStep = Ghost_GetAttribute(ghost, HARDHAT_ATTR_MAX_STEP, 125);
//       int ss = Rand(minStep, maxStep);
//       int counter = 0;
//       Trace(minStep);
//       Trace(maxStep);

//       // Knockback Variables
//       int knockbackCounter;
//       int knockbackAngle;

//       // Spawn Animation
//       Ghost_SpawnAnimationPuff(this, ghost);

//       // Behavior Loop
//       do {
//          // Knockback
//          if (Ghost_GotHit()) {
//             int xDiff = Abs(Hero->X - Ghost_X) << 0;
//             int yDiff = Abs(Hero->Y - Ghost_Y) << 0;
//             if (xDiff < (Ghost_TileWidth + 1) * 16 && yDiff < (Ghost_TileHeight + 1) * 16) {
//                knockbackCounter = __GH_KNOCKBACK_TIME;
//                knockbackAngle = Angle(Hero->X, Hero->Y, Ghost_X, Ghost_Y);
//             }
//             ss = minStep;
//          }
//          if (knockbackCounter != 0) {
//             knockbackCounter--;
//             int dir = AngleDir8(knockbackAngle);
//             if (Ghost_CanMove(dir, __GH_KNOCKBACK_STEP / 2, __GH_DEFAULT_IMPRECISION))
//                Ghost_Move(dir, __GH_KNOCKBACK_STEP / 2, __GH_DEFAULT_IMPRECISION);
//             else
//                knockbackCounter = 0;
//          }

//          // Chase Link
//          else {
//             if (ss < maxStep) {
//                counter = (counter + 1) % 24;
//                if (counter == 0)
//                   ss = Clamp(ss + (maxStep - minStep) / 24, minStep, maxStep);
//             }
//             int angle = Angle(Ghost_X, Ghost_Y, Hero->X, Hero->Y);
//             if (Hero->Action == LA_GOTHURTLAND && LinkCollision(ghost))
//                Hero->HitDir = AngleDir4(angle);
//             if (!Ghost_CanMove(AngleDir8(angle), ss / 100, 2))
//                ss = minStep;
//             Ghost_MoveTowardLink(ss / 100, 2);
//          }
//       } while (Ghost_Waitframe(this, ghost, true, true));
//    }
// }

// clang-format off
// @Author("Mero")
// ffc script Hellrobe {
//    // clang-format on

//    CONFIG I_STUNRING = 123;
//    CONFIG FROZEN_TIME = 60;
//    void run(int enemyID) {
//       npc ghost = Ghost_InitAutoGhost(this, enemyID);
//       Ghost_SetFlag(GHF_NORMAL);
//       int OTile = ghost->OriginalTile;
//       int scriptName[] = "SnowmanLink";
//       int scriptNum = Game->GetFFCScript(scriptName);
//       int wizzrobeIDs[5] = {NPC_WIZZROBEFIRE, NPC_WIZZROBEBAT, NPC_WIZZROBEMIRR, NPC_WIZZROBEWIND, enemyID};
//       int formTime = ghost->Attributes[5];
//       int clk = formTime;
//       int defenses[18];
//       Ghost_StoreDefenses(ghost, defenses);

//       Ghost_SpawnAnimationPuff(this, ghost);

//       while (true) {
//          if (ghost->ID == enemyID) {
//             for (int i = Screen->NumEWeapons(); i > 0; i--) {
//                eweapon e = Screen->LoadEWeapon(i);
//                if (e->ID == EW_BEAM) {
//                   eweapon icemagic = FireNonAngularEWeapon(EW_SCRIPT1, e->X, e->Y, e->Dir, e->Step, e->Damage, 83, SFX_ICE, EWF_ROTATE);
//                   SetEWeaponLifespan(icemagic, EWL_NEAR_LINK, 12);
//                   SetEWeaponDeathEffect(icemagic, EWD_RUN_SCRIPT, scriptNum);
//                   icemagic->NoCollisionTimer = -1;
//                   e->DeadState = WDS_DEAD;
//                }
//             }
//          }
//          clk--;
//          if (clk == 0) {
//             clk = formTime;
//             npc newghost = Screen->CreateNPC(wizzrobeIDs[Rand(5)]);
//             newghost->OriginalTile = OTile;
//             if (newghost->Step != 0)
//                newghost->OriginalTile += 60;
//             newghost->CSet = Ghost_CSet;
//             Ghost_ReplaceNPC(ghost, newghost, true);
//             ghost->HP = -1000;
//             ghost = newghost;
//             Ghost_SetDefenses(ghost, defenses);
//          }
//          Ghost_Waitframe2(this, ghost, 1, true);
//       }
//    }
// }

// clang-format off
// @Author("Mero")
// ffc script SnowmanLink {
//    // clang-format on
//    void run(int weaponNum) {
//       eweapon wpn = GetAssociatedEWeapon(weaponNum);
//       wpn->DeadState = WDS_DEAD;
//       if (!LinkCollision(wpn))
//          Quit();
//       if (Hero->Item[I_STUNRING])
//          Quit();
//       Hero->Item[I_STUNRING] = true;
//       int stuntime = FROZEN_TIME;
//       Hero->HP -= wpn->Damage;
//       Audio->PlaySound(SFX_OUCH);
//       while (stuntime > 0) {
//          stuntime--;
//          WaitNoAction();
//       }
//       Hero->Item[I_STUNRING] = false;
//    }
// }


// clang-format off
// @Author("Mero")
// ffc script IceGolem {
//    // clang-format on

//    const int GOLEM_SFX_FIST = 61;
//    const int GOLEM_SFX_LASER = 62;
//    void run(int enemyID) {
//       // init
//       npc ghost;
//       ghost = Ghost_InitAutoGhost(this, enemyID);
//       this->Flags[FFCF_CARRYOVER] = true;

//       // reposition and transform
//       Ghost_X = 120;
//       Ghost_Y = 64;
//       Ghost_Transform(this, ghost, -1, -1, 3, 3);
//       Ghost_SetHitOffsets(ghost, 16, 0, 8, 8);

//       // Store the starting combo.
//       int baseCombo = Ghost_Data;

//       // flags
//       Ghost_SetFlag(GHF_SET_DIRECTION);
//       Ghost_SetFlag(GHF_4WAY);

//       // movement variables
//       float counter = -1;
//       int step = ghost->Step;
//       int rate = ghost->Rate;
//       int homing = ghost->Homing;
//       int hunger = ghost->Hunger;
//       int haltrate = ghost->Haltrate;
//       int halttime = 48;

//       // eweapon variables
//       int fistStep = Ghost_GetAttribute(ghost, 0, 200);
//       int fistSprite = Ghost_GetAttribute(ghost, 1, 88);
//       int laserStep = Ghost_GetAttribute(ghost, 2, 400);
//       int laserSprite = Ghost_GetAttribute(ghost, 3, 89);
//       int laserChance = Ghost_GetAttribute(ghost, 4, haltrate, 1, 16);
//       bool laser;

//       // Spawn
//       Ghost_SpawnAnimationPuff(this, ghost);

//       // behavior
//       while (Ghost_HP > 0) {
//          int dir = Ghost_Dir;
//          counter = Ghost_HaltingWalk4(counter, step, rate, homing, hunger, haltrate, halttime);
//          if (counter >> 0 > 0) {
//             if (counter == halttime) {

//                if (Rand(16) < laserChance) {
//                   Ghost_Data = baseCombo + 8;
//                   dir = RadianAngleDir8(ArcTan(Hero->X - Ghost_X + 8, Hero->Y - Ghost_Y + 4));
//                   laser = true;
//                }
//                else {
//                   Ghost_Data = baseCombo + 4;
//                   dir = RadianAngleDir4(ArcTan(Hero->X - Ghost_X, Hero->Y - Ghost_Y));
//                   Hero->PitWarp(Game->CurDMap, Game->GetCurDMapScreen());
//                }
//             }
//             else if (counter == halttime / 2) {
//                if (laser) {
//                   laser = false;
//                   FireAimedEWeapon(EW_SCRIPT1, Ghost_X + 16, Ghost_Y, 0, laserStep, ghost->WeaponDamage, laserSprite, GOLEM_SFX_LASER, EWF_UNBLOCKABLE | EWF_ROTATE_360);
//                }
//                else
//                   RocketFist(ghost, fistStep, fistSprite, ghost->WeaponDamage);
//             }
//             Ghost_ForceDir(dir);
//          }
//          else {
//             Ghost_Data = baseCombo;
//          }

//          Ghost_Waitframe(this, ghost, 0, true);
//       }
//    }
//    void RocketFist(npc ghost, int step, int sprite, int damage) {
//       int x = Ghost_X + ghost->DrawXOffset;
//       int y = Ghost_Y + ghost->DrawYOffset;
//       int w = 1;
//       int h = 1;
//       int xdiff;
//       int ydiff;

//       if (Ghost_Dir == DIR_UP) {
//          x += 5;
//          h = 2;
//          xdiff = 24;
//       }
//       else if (Ghost_Dir == DIR_DOWN) {
//          x += 5;
//          y += 7;
//          h = 2;
//          xdiff = 24;
//       }
//       else if (Ghost_Dir == DIR_LEFT) {
//          y += 1;
//          w = 2;
//          ydiff = 8;
//       }
//       else if (Ghost_Dir == DIR_RIGHT) {
//          x += 16;
//          y += 1;
//          w = 2;
//          ydiff = 8;
//       }
//       else
//          return; // invalid direction.

//       eweapon fist[2];
//       fist[0] = FireBigNonAngularEWeapon(EW_SCRIPT1, x, y, Ghost_Dir, step, damage, sprite, 0, EWF_UNBLOCKABLE, w, h);
//       fist[1] = FireBigNonAngularEWeapon(EW_SCRIPT1, x + xdiff, y + ydiff, Ghost_Dir, step, damage, sprite, 0, EWF_UNBLOCKABLE, w, h);

//       for (int i; i < 2; i++) {
//          if (Ghost_Dir == DIR_DOWN)
//             fist[i]->OriginalTile += 2;
//          else if (Ghost_Dir == DIR_LEFT)
//             fist[i]->OriginalTile += 4;
//          else if (Ghost_Dir == DIR_RIGHT)
//             fist[i]->OriginalTile += 8;
//       }

//       Audio->PlaySound(GOLEM_SFX_FIST);
//    }
// }
