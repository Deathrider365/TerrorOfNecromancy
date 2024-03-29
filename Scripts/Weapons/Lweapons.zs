//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ LWeapons ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

@Author("EmilyV99")
lweapon script GaleBoomerang {
   // REQUIRES: `ZScript>>Quest Script Settings>>Objects` - `Weapons Live One Extra Frame With WDS_DEAD` must be checked.
   // InitD[]:
   // D0: turn rate (degrees per frame)
   // D1: wind drop rate (every x frames, drop wind visual effect)
   //  Sprites[]:
   //  - 0 = sprite for the weapon
   //  - 1 = sprite for the wind visual effect

   CONFIG CF_BRANG_BOUNCE = CF_SCRIPT20;

   CONFIG DEFAULT_SPRITE = 5;
   CONFIG DEFAULT_WIND_SPRITE = 13;

   CONFIG DEFAULT_SFX = 63;

   CONFIG SFX_DELAY = 5;

   DEFINE ROTATION_RATE = 40; // degrees

   CONFIGB FORCE_QRS_TO_NEEDED_STATE = true;
   CONFIGB BOUNCE_OFF_FLAGS_ON_LAYERS_1_AND_2 = true;
   CONFIGB STOPS_WHEN_GRABBING_ITEMS = true;

   void run(int turnRate, int wind_drop_rate) {
      Game->FFRules[qr_WEAPONS_EXTRA_FRAME] = true;
      Game->FFRules[qr_OLDSPRITEDRAWS] = false;
      Game->FFRules[qr_CHECKSCRIPTWEAPONOFFSCREENCLIP] = true;

      itemdata parent;
      int wind_sprite;
      int windClock;
      int sfxClock;
      int sfx;

      // Initialize with data from the item that created this.
      if (this->Parent > -1) {
         parent = Game->LoadItemData(this->Parent);
         this->UseSprite(parent->Sprites[0]);
         wind_sprite = parent->Sprites[1];
         sfx = parent->UseSound;
      }
      // If this weapon was created by a script, instead of an item, initialize with defaults.
      else {
         parent = NULL;
         this->UseSprite(DEFAULT_SPRITE);
         wind_sprite = DEFAULT_WIND_SPRITE;
         sfx = DEFAULT_SFX;
      }

      this->Angular = true;
      this->Angle = DirRad(this->Dir);
      int radTurnRate = DegtoRad(turnRate);
      bool controlling = (Input->Button[CB_A] || Input->Button[CB_B]);
      itemsprite dragging = NULL;
      bool collided = false;

      until(this->DeadState == WDS_DEAD || collided) {
         if (dragging) {
            dragging->X = this->X;
            dragging->Y = this->Y;
         }

         if (controlling) {
            if (Input->Button[CB_LEFT])
               this->Angle -= radTurnRate;
            else if (Input->Button[CB_RIGHT])
               this->Angle += radTurnRate;
         }

         int position = ComboAt(this->X + 8, this->Y + 8);

         for (int q = 0; q <= (BOUNCE_OFF_FLAGS_ON_LAYERS_1_AND_2 ? 2 : 0); ++q) {
            mapdata mapData = Game->LoadTempScreen(q);

            if (mapData->ComboF[position] == CF_BRANG_BOUNCE || mapData->ComboI[position] == CF_BRANG_BOUNCE)
               collided = true;
         }

         for (int q = Screen->NumItems(); q > 0; --q) {
            itemsprite it = Screen->LoadItem(q);

            unless(it->Pickup & IP_TIMEOUT) continue;

            if (Collision(it, this))
            {
               dragging = it;
               collided = STOPS_WHEN_GRABBING_ITEMS;
            }
         }

         if (this->X < 0 || this->Y < 0 || (this->X + this->HitWidth) > 255 || (this->Y + this->HitHeight) > 175)
            collided = true; // Collide if off-screen

         if (controlling)
            ++Hero->Stun;

         windClock = (windClock + 1) % wind_drop_rate;
         sfxClock = (sfxClock + 1) % SFX_DELAY;

         unless(windClock)
             drop_sparkle(this->X, this->Y, wind_sprite);

         unless(sfxClock)
             Audio->PlaySound(sfx);

         this->Rotation = WrapDegrees(this->Rotation + ROTATION_RATE);
         Waitframe();

         if (controlling)
            controlling = (Input->Button[CB_A] || Input->Button[CB_B]);
      }

      while (true) {
         this->DeadState = WDS_ALIVE;
         this->Angle = TurnTowards(this->X, this->Y, Hero->X, Hero->Y, this->Angle, 1); // Turn directly towards the Hero.

         // touching the Hero
         if (Collision(this)) {
            this->DeadState = WDS_DEAD;

            if (dragging) {
               dragging->X = Hero->X;
               dragging->Y = Hero->Y;
            }

            return;
         }

         if (dragging) {
            dragging->X = this->X;
            dragging->Y = this->Y;
         }

         windClock = (windClock + 1) % wind_drop_rate;
         sfxClock = (sfxClock + 1) % SFX_DELAY;

         unless(windClock)
             drop_sparkle(this->X, this->Y, wind_sprite);

         unless(sfxClock)
             Audio->PlaySound(sfx);

         this->Rotation = WrapDegrees(this->Rotation + ROTATION_RATE);
         Waitframe();
      }
   }

   void drop_sparkle(int x, int y, int sprite) {
      lweapon sparkle = Screen->CreateLWeapon(LW_SPARKLE);
      sparkle->X = x;
      sparkle->Y = y;
      sparkle->UseSprite(sprite);
   }
}

@Author("Deathrider365")
lweapon script PortalSphere {
   void run() {
   }
}

@Author("Deathrider365")
lweapon script ScholarCandelabra {
   void run() {
   }
}

@Author("KoolAidWannaBe")
lweapon script SineWave {
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

@Author("Deathrider365")
lweapon script DeathsTouch {
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

@Author("EmilyV99")
lweapon script CustomSparkle {
   void run(int sprId, int fadeMult) {
      unless(fadeMult)
          fadeMult = 1;

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

@Author("Moosh")
lweapon script TimedEffect {
   void run(int timer) {
      while (timer--)
         Waitframe();

      this->Remove();
   }
}

@Author("Moosh")
lweapon script FlamingArrow {
   void run() {
      unless(this->ID == LW_ARROW)
          Quit();

      bool collided;

      while (true) {
         unless(collided) {
            for (int i = Screen->NumLWeapons(); i > 0; --i) {
               lweapon weapon = Screen->LoadLWeapon(i);

               switch (weapon->ID) {
               case LW_FIRE:
                  if (weapon->CollDetection && Collision(this, weapon)) {
                     collided = true;
                     Audio->PlaySound(SFX_FLAMMING_ARROW);
                  }
                  break;
               }
            }
            for (int i = Screen->NumEWeapons(); i > 0; --i) {
               eweapon weapon = Screen->LoadEWeapon(i);

               switch (weapon->ID) {
               case EW_FIRE:
               case EW_FIRE2:
               case EW_FIRETRAIL:
                  if (weapon->CollDetection && Collision(this, weapon)) {
                     collided = true;
                     Audio->PlaySound(SFX_FLAMMING_ARROW);
                  }
                  break;
               }
            }

            if (arrowPointCollision(this->X + 7, this->Y + 7)) {
               collided = true;
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

@Author("Moosh")
lweapon script DieTimeOut {
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
   weapon->CollDetection = false;
   weapon->InitD[0] = frames;

   return weapon;
}
