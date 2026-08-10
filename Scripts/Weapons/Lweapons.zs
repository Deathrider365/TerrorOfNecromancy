//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ LWeapons ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

// clang-format off
@InitD0("turnRate"),
@InitDHelp0("Degrees the boomerang will turn per frame"),
@Author("Emily, Deathrider365")
lweapon script ContollableBoomerang { //TODO if the rang is thrown and is flying when screens trans, the sfx keeps playing
   // clang-format on
   void run(int turnRate) {
      this->Angular = true;
      this->Angle = DirRad(this->Dir);

      int radTurnRate = DegtoRad(turnRate);
      bool controlling = (Input->Button[CB_A] || Input->Button[CB_B]);

      until (this->DeadState == WDS_DEAD) {
         if (controlling) {
            if (Input->Button[CB_LEFT])
               this->Angle -= radTurnRate;
            else if (Input->Button[CB_RIGHT])
               this->Angle += radTurnRate;
         }

         if (controlling)
            ++Hero->Stun;

         Waitframe();

         if (controlling)
            controlling = (Input->Button[CB_A] || Input->Button[CB_B]);
      }

      loop () {
         this->DeadState = WDS_ALIVE;
         this->Angle = TurnTowards(this->X, this->Y, Hero->X, Hero->Y, this->Angle, 1);

         if (Collision(this)) {
            this->DeadState = WDS_DEAD;
            return;
         }

         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365")
lweapon script ScholarCandelabra {
   // clang-format on

   void run() {
   }
}

// clang-format off
@Author("KoolAidWannaBe")
lweapon script SineWave {
   // clang-format on

   void run(int amplitude, int frequency) {
      this->Angle = DirRad(this->Dir);
      this->Angular = true;
      int x = this->X;
      int y = this->Y;
      int clock;
      int dist;

      while (true) {
         clock += frequency;
         clock %= 360;

         x += RadianCos(this->Angle) * this->Step * .01;
         y += RadianSin(this->Angle) * this->Step * .01;

         dist = Sin(clock) * amplitude;

         this->X = x + VectorX(dist, RadtoDeg(this->Angle) - 90);
         this->Y = y + VectorY(dist, RadtoDeg(this->Angle) - 90);
         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365")
lweapon script DeathsTouch {
   // clang-format on

   void run() {
      // an aura n pixel circle around link that does x dps to all enemies in the radius and has a lasting damage effect even after they leave. works on all except undead until
      //  the triforce of death is cleansed, then it hurts only undead but for a lot more than before it was cleansed (extremely useful for the legionnaire crypt)

      // lweapon deathsAura;
      // deathsAura->X = Hero->X - 8;
      // deathsAura->Y = Hero->Y - 8;
      // deathsAura->LoadSpriteData

      for (int i = 0; i < 240; ++i) {
         Screen->DrawCombo(7, this->X, this->Y, 6854, 2, 2, 0, 1, 1, 0, 0, 0, 0, 0, true, OP_OPAQUE);

         Waitframe();
      }

      // void DrawCombo	(int layer, int x, int y,
      // int combo, int w, int h,
      // int cset, int xscale, int yscale,
      // int rx, int ry, int rangle,
      // int frame, int flip,
      // bool transparency, int opacity);

      // 1: draw growing circle
      // 2: loop for every enemy on screen and do collision check
      // 3: apply damage to enemies touching
      // 4: shrink circle when done
   }
}

// clang-format off
@Author("EmilyV99")
lweapon script CustomSparkle {
   // clang-format on

   void run(int sprId, int fadeMult) {
      unless(fadeMult) fadeMult = 1;

      spritedata spr = Game->LoadSpriteData(sprId);
      this->CSet = spr->CSet;

      int clk = 0;
      int tile = spr->Tile;
      int speed = Max(1, spr->Speed);
      int frames = Max(1, spr->Frames);
      int frame = 0;

      speed = Round(speed * fadeMult);
      tile += this->Dir * frames;

      while (true) {
         if (++clk >= speed) {
            if (++frame >= frames)
               break;

            clk = 0;
         }

         this->ScriptTile = tile + frame;

         Waitframe();
      }

      this->Remove();
   }
}

// clang-format off
@Author("Moosh")
lweapon script TimedEffect {
   // clang-format on

   void run(int timer) {
      while (timer--)
         Waitframe();

      this->Remove();
   }
}

// clang-format off
@Author("Moosh")
lweapon script FlamingArrow { //TODO needed?
   // clang-format on

   void run() {
      unless(this->ID == LW_ARROW) Quit();

      bool collided;

      while (true) {
         unless(collided) {
            for (int i = Screen->NumLWeapons; i > 0; --i) {
               lweapon weapon = Screen->LoadLWeapon(i);

               switch (weapon->ID) {
                  case LW_FIRE:
                     if (!weapon->NoCollisionTimer && Collision(this, weapon)) {
                        collided = true;
                     }
                     break;
               }
            }
            for (int i = Screen->NumEWeapons; i > 0; --i) {
               eweapon weapon = Screen->LoadEWeapon(i);

               switch (weapon->ID) {
                  case EW_FIRE:
                  case EW_FIRE2:
                  case EW_FIRETRAIL:
                     if (!weapon->NoCollisionTimer && Collision(this, weapon)) {
                        collided = true;
                     }
                     break;
               }
            }

            if (collided || this->Flags[WFLAG_BURN_ANYFIRE] || arrowPointCollision(this->X + 7, this->Y + 7)) {
               collided = true;
               this->Flags[WFLAG_BURN_ANYFIRE] = true;
               Audio->PlaySound(SFX_FLAMMING_ARROW);
            }
         }
         else if (this->DeadState == WDS_ALIVE) {
            if (gameframe % 4 == 0) {
               lweapon flame = dropFlame(this->X + Rand(-4, 4), this->Y + Rand(-4, 4), SPR_FLAME_TRAIL);
               flame->Script = 0;
            }

            lweapon flameHitbox = CreateLWeaponAt(LW_FIRE, this->X, this->Y);
            flameHitbox->DrawYOffset = -1000;
            flameHitbox->Damage = this->Damage;
            flameHitbox->Dir = this->Dir;

            flameHitbox->Script = Game->GetLWeaponScript("DieTimeOut");
            flameHitbox->InitD[0] = 1;
         }

         Waitframe();
      }
   }

   bool arrowPointCollision(int x, int y) {
      int pos = ComboAt(x, y);
      int comboType = Screen->ComboT[pos];

      if (comboType == CT_LANTERN)
         return true;

      mapdata layer1 = Game->LoadTempScreen(1);
      comboType = layer1->ComboT[pos];

      if (comboType == CT_LANTERN)
         return true;

      mapdata layer2 = Game->LoadTempScreen(2);
      comboType = layer2->ComboT[pos];

      if (comboType == CT_LANTERN)
         return true;

      return false;
   }

   lweapon dropFlame(int x, int y, int sprite) {
      lweapon sparkle = Screen->CreateLWeapon(LW_FIRESPARKLE);
      sparkle->X = x;
      sparkle->Y = y;
      sparkle->Damage = 2;
      sparkle->UseSprite(sprite);
      sparkle->LightRadius = 12;

      return sparkle;
   }
}

// clang-format off
@Author("Moosh")
lweapon script DieTimeOut {
   // clang-format on

   void run(int frames) {
      Waitframes(frames);
      this->DeadState = WDS_DEAD;
   }
}

lweapon spawnTimedSprite(int x, int y, int sprite, int tileWidth, int tileHeight, int frames) {
   lweapon weapon = CreateLWeaponAt(LW_SCRIPT1, x, y);
   weapon->UseSprite(sprite);
   weapon->TileWidth = tileWidth ? tileWidth : 1;
   weapon->TileHeight = tileHeight ? tileHeight : 1;
   weapon->Script = Game->GetLWeaponScript("TimedEffect");
   weapon->NoCollisionTimer = -1;
   weapon->InitD[0] = frames;

   return weapon;
}

lweapon SparkleSpriteAnim(int x, int y, int sprite, int w, int h) {
    lweapon l = CreateLWeaponAt(LW_SPARKLE, x, y);
    l->UseSprite(sprite);
    l->NoCollisionTimer = -1;
    l->Extend = 3;
    l->TileWidth = w;
    l->TileHeight = h;

    return l;
}
