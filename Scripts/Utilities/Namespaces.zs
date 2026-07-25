//~~~~~~~~~~~~~~~~~~~~~The Terror of Necromancy Namespaces~~~~~~~~~~~~~~~~~~~//

namespace EnemyNamespace {
    using namespace NPCAnim;
    using namespace NPCAnim::Utility;

   CONFIG DOWALK_TWO_DIR = 0;
   CONFIG DOWALK_FOUR_DIR = 1;
   CONFIG DOWALK_EIGHT_DIR = 2;

   enum dataInd {
      DATA_AFRAMES,
      DATA_CLK,
      DATA_FRAME,
      DATA_INVIS,
      SZ_DATA
   };

   void setNPCToCombo(int[] data, npc n, int comboId) {
      setNPCToCombo(data, n, Game->LoadComboData(comboId));
   }

   void setNPCToCombo(int[] data, npc n, combodata combo) {
      data[DATA_AFRAMES] = combo->Frames;
      n->OriginalTile = combo->OriginalTile;
      n->ASpeed = combo->ASpeed;
      data[DATA_FRAME] = 0;
   }

   void setupNPC(npc n) {
      n->Animation = false;

      unless(n->TileWidth) n->TileWidth = 1;
      unless(n->TileHeight) n->TileHeight = 1;
      unless(n->HitWidth) n->HitWidth = 16;
      unless(n->HitHeight) n->HitHeight = 16;
   }

    void deathAnimation(npc n, int deathSound = 0, bool killBossMusic = true) {
        n->Immortal = true;
        n->NoCollisionTimer = -1;
        n->Stun = 9999;

        int baseX = n->X + n->DrawXOffset;
        int baseY = (n->Y + n->DrawYOffset) - (n->Z + n->DrawZOffset);

        Audio->PlaySound(deathSound);

        for (int i = 0; i < 45; i++) {
            unless(i % 3) {
                lweapon explosion = Screen->CreateLWeapon(LW_BOMBBLAST);
                explosion->X = baseX + RandGen->Rand(16 * n->TileWidth) - 8;
                explosion->Y = baseY + RandGen->Rand(16 * n->TileHeight) - 8;
                explosion->NoCollisionTimer = -1;
            }

            Waitframes(5);
        }

        if (killBossMusic)
            MUSIC_INHERIT->Play();

        for (int i = Screen->NumNPCs; i >= 1; i--) {
            npc n = Screen->LoadNPC(i);
            n->Remove();
        }

        n->Immortal = false;
        n->HP = 0;
    }

   void EnemyWaitframe(npc n, int[] data) {
      if (n->HP <= 0)
         deathAnimation(n, 142);

      if (++data[DATA_CLK] >= n->ASpeed) {
         data[DATA_CLK] = 0;

         if (++data[DATA_FRAME] >= data[DATA_AFRAMES])
            data[DATA_FRAME] = 0;

         n->ScriptTile = n->OriginalTile + (n->TileWidth * data[DATA_FRAME]);
         int rowdiff = Div(n->ScriptTile - n->OriginalTile, 20);

         if (rowdiff)
            n->ScriptTile += (rowdiff * (n->TileHeight - 1));
      }

      int tempTile = n->ScriptTile;

      if (data[DATA_INVIS])
         n->ScriptTile = TILE_INVIS;

      Waitframe();

      n->ScriptTile = tempTile;
   }

   void EnemyWaitframe(npc n, int[] data, bool deathAnim) {
      if (deathAnim && n->HP <= 0)
         deathAnimation(n, 142);

      if (++data[DATA_CLK] >= n->ASpeed) {
         data[DATA_CLK] = 0;

         if (++data[DATA_FRAME] >= data[DATA_AFRAMES])
            data[DATA_FRAME] = 0;

         n->ScriptTile = n->OriginalTile + (n->TileWidth * data[DATA_FRAME]);
         int rowdiff = Div(n->ScriptTile - n->OriginalTile, 20);

         if (rowdiff)
            n->ScriptTile += (rowdiff * (n->TileHeight - 1));
      }

      int tempTile = n->ScriptTile;

      if (data[DATA_INVIS])
         n->ScriptTile = TILE_INVIS;

      Waitframe();

      n->ScriptTile = tempTile;
   }

   void EnemyWaitframe(npc n, int[] data, int frames) {
      while (frames--)
         EnemyWaitframe(n, data);
   }

   bool linkClose(npc this, int distance) {
      return Distance(CenterX(this), CenterY(this), CenterLinkX(), CenterLinkY()) < distance;
   }

   bool canMove(npc n) { // TODO account for HITWIDTH and HITX/YOffset
      if (n->Y - 1 <= 1 && n->Dir == DIR_DOWN)
         return false;
      if (n->Y + 1 >= 175 && n->Dir == DIR_UP)
         return false;
      if (n->X - 1 <= 1 && n->Dir == DIR_RIGHT)
         return false;
      if (n->X + 1 >= 255 && n->Dir == DIR_LEFT)
         return false;
      return true;
   }

   bool forceDir(npc n) { // TODO account for HITWIDTH and HITX/YOffset
      if (n->Y - 1 <= 1)
         return DIR_DOWN;
      if (n->Y + 1 >= 175)
         return DIR_UP;
      if (n->X - 1 <= 1)
         return DIR_RIGHT;
      if (n->X + 1 >= 255)
         return DIR_LEFT;
      return false;
   }

   void doWalk(npc n, int rand, int homing, int step, bool flying = false, int moveStyle = 1) {
      if (n->HP <= 0 || n->MovePaused())
         return;

      CONFIG ONE_IN_N = 1000;

      if (rand >= RandGen->Rand(ONE_IN_N - 1)) {
         int attemptCounter = 0;

         do {
            n->Dir = RandGen->Rand(3);
         }
         until(n->CanMove(n->Dir, 1, flying ? SPW_FLOATER : SPW_NONE) || ++attemptCounter > 500);
      }
      else if (homing >= RandGen->Rand(ONE_IN_N - 1)) {
         switch (moveStyle) {
            case DOWALK_TWO_DIR:
               n->Dir = (gameframe % 2 == 0) ? 1 : 3;
               break;
            case DOWALK_FOUR_DIR:
               n->Dir = RadianAngleDir4(TurnTowards(n->X, n->Y, Hero->X, Hero->Y, 0, 1));
               break;
            case DOWALK_EIGHT_DIR:
               n->Dir = RadianAngleDir8(TurnTowards(n->X, n->Y, Hero->X, Hero->Y, 0, 1));
               break;
         }
      }

      unless(n->Move(n->Dir, step / 100, flying ? SPW_FLOATER : SPW_NONE)) {
         int attemptCounter = 0;

         do {
            n->Dir = RandGen->Rand(3);
         }
         until(n->CanMove(n->Dir, 1, flying ? SPW_FLOATER : SPW_NONE) || ++attemptCounter > 500);
      }
   }

   int byEdgeOfScreen(npc n) {
      if (n->Dir == DIR_UP && n->Y < 16)
         return DIR_DOWN;
      else if (n->Dir == DIR_LEFT && n->X < 16)
         return DIR_RIGHT;
      else if (n->Dir == DIR_DOWN && n->Y > 144)
         return DIR_UP;
      else if (n->Dir == DIR_RIGHT && n->X < 224)
         return DIR_LEFT;
      else
         return -1;
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
      int nx = n->X + n->HitXOffset + (center ? n->HitWidth / 2 : 0);
      int ny = n->Y + n->HitYOffset + (center ? n->HitHeight / 2 : 0);
      int dist = Distance(nx, ny, x, y);

      if (dist < 0.0010)
         return false;

      return n->MoveAtAngle(RadtoDeg(TurnTowards(nx, ny, x, y, 0, 1)), Min(xDistance, dist), special);
   }

   void FourWayFlip(eweapon e) {
        if (e->Angular)
            e->Dir = AngleDir4(WrapDegrees(e->DegAngle));

        int frames = Max(e->NumFrames, 1);

        switch(e->Dir) {
            case DIR_UP:
                break;
            case DIR_DOWN:
                e->Flip = FLIP_VERTICAL;
                break;
            case DIR_LEFT:
                e->Flip = FLIP_HORIZONTAL;
            case DIR_RIGHT:
                e->OriginalTile += frames;
                e->Tile += frames;
                break;
        }
    }

   bool isDifficultyChange(npc n, int maxHp) {
      return n->HP < maxHp * .33;
   }

   int getInvertedDir(int dir) {
      switch (dir) {
         case DIR_UP: return DIR_DOWN;
         case DIR_DOWN: return DIR_UP;
         case DIR_RIGHT: return DIR_LEFT;
         case DIR_LEFT: return DIR_RIGHT;
         case DIR_UPLEFT: return DIR_DOWNRIGHT;
         case DIR_DOWNRIGHT: return DIR_UPLEFT;
         case DIR_UPRIGHT: return DIR_DOWNLEFT;
         case DIR_DOWNLEFT: return DIR_UPRIGHT;
         default: return DIR_UP;
      }
   }

   bool hitByLWeapon(npc n, int weaponId) {
      if (n->HitBy[HIT_BY_LWEAPON_UID]) {
         if (Screen->LoadLWeapon(n->HitBy[HIT_BY_LWEAPON])->Type == weaponId)
            return true;
         else
            return false;
      }
      return false;
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

      return false;
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
      }
      else {
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

    // void Update_Movement_WallBounce(eweapon this, untyped[] vars)
    // {
    //     if(pauseMove||vars[WV_FROZEN])
    //         return;

    //     vars[WV_SUBPIXELSTEP] += (this->Step/100);
    //     int step = Floor(vars[WV_SUBPIXELSTEP]);

    //     for(int i=0; i<step; ++i)
    //     {
    //         vars[WV_X] += VectorX(1, this->DegAngle);
    //         vars[WV_Y] += VectorY(1, this->DegAngle);
    //         this->X = vars[WV_X];
    //         this->Y = vars[WV_Y];

    //         int ang = this->DegAngle;
    //         int vX = VectorX(1, ang);
    //         int vY = VectorY(1, ang);
    //         bool bounced;
    //         if((vX<0&&!CanMove(this, vars[WV_X], vars[WV_Y], DIR_LEFT))||(vX>0&&!CanMove(this, vars[WV_X], vars[WV_Y], DIR_RIGHT)))
    //         {
    //             vX = -vX;
    //             bounced = true;
    //         }
    //         if((vY<0&&!CanMove(this, vars[WV_X], vars[WV_Y], DIR_UP))||(vY>0&&!CanMove(this, vars[WV_X], vars[WV_Y], DIR_DOWN)))
    //         {
    //             vY = -vY;
    //             bounced = true;
    //         }
    //         if(bounced&&vars[WV_MOVE_WALLBOUNCE_NUMBOUNCES]>=0)
    //         {
    //             if(vars[WV_MOVE_WALLBOUNCE_NUMBOUNCES]>0)
    //             {
    //                 --vars[WV_MOVE_WALLBOUNCE_NUMBOUNCES];
    //                 if(!vars[WV_MOVE_WALLBOUNCE_NUMBOUNCES])
    //                     vars[WV_MOVE_WALLBOUNCE_NUMBOUNCES] = -1;
    //             }
    //             this->Step *= vars[WV_MOVE_WALLBOUNCE_BOUNCESPEEDMULT];
    //             if(vars[WV_MOVE_WALLBOUNCE_TARGETLINK])
    //                 this->DegAngle = Angle(CenterX(this), CenterY(this), CenterLinkX(), CenterLinkY());
    //             else
    //                 this->DegAngle = Angle(0, 0, vX, vY);
    //             UpdateFacingAngle(this, vars);
    //         }
    //     }
    //     vars[WV_SUBPIXELSTEP] -= step;
    //     if(vars[WV_MOVE_WALLBOUNCE_NUMBOUNCES]>0)
    //         vars[WV_LIFESPAN_HITWALL_CANDIE] = false;
    // }

} // namespace EnemyNamespace

namespace MinecartNamespace {
   CONFIGB MINECART_TURN_LINK_WITH_CART = true;         // If true, Link will turn with the cart when not moving
   CONFIGB MINECART_USE_SPECIAL_RIDING_SPRITES = false; // If true, replace Link's riding sprites with the minecart's combo +12

   CONFIG SFX_MINECART = 173;     // Looping sound of the minecart on the tracks
   CONFIG MINECART_SFX_FREQ = 30; // How often the sound loops

   CONFIG MINECART_LINKYOFFSET = 10; // Offset Link's sprite is drawn at compared to the minecart
   CONFIG MINECART_HOLDFRAMES = 8;   // How many frames Link needs to hold to get in the minecart

   CONFIG DAMAGE_MINECART_COLLISION = 8;         // How much damage the minecart does when it hits enemies
   CONFIG LW_MINECART_DAMAGE = LW_SCRIPT10;      // Weapon type the minecart's hitbox uses
   CONFIG LW_MINECART_DAMAGE_DEFENSE = LW_SWORD; // Defense type the minecart's hitbox uses

   CONFIG MAX_MINECARTS = 1024;
   untyped GBMinecarts[MCI_LAST + MAX_MINECARTS * MCII_LAST];

   enum MinecartIndices {
      MCI_FIRSTLOAD,
      MCI_ACTIVEMINECARTS,
      MCI_INMINECART,
      MCI_CURRENTID,
      MCI_CARTX,
      MCI_CARTY,
      MCI_CARTDIR,
      MCI_CARTSPEED,
      MCI_CARTTEMPSTEP,
      MCI_CARTCOMBO,
      MCI_CARTCSET,
      MCI_SFXTIMER,
      MCI_NOAIRSCROLL_QR,

      MCI_LAST
   };

   enum MinecartInstanceIndices {
      MCII_MAP,
      MCII_SCREEN,
      MCII_X,
      MCII_Y,
      MCII_NORESET,
      MCII_COMBO,
      MCII_CSET,
      MCII_DIR,
      MCII_SPEED,
      MCII_ORIGINALSCREEN,
      MCII_ORIGINALMAP,
      MCII_ORIGINALX,
      MCII_ORIGINALY,
      MCII_ORIGINALFFC,

      MCII_LAST
   };

   enum MinecartTrackTypes {
      MTT_LANDINGPAD,
      MTT_VERTICAL,
      MTT_HORIZONTAL,
      MTT_RIGHTDOWN,
      MTT_LEFTDOWN,
      MTT_RIGHTUP,
      MTT_LEFTUP,
      MTT_UPT,
      MTT_DOWNT,
      MTT_LEFTT,
      MTT_RIGHTT,
      MTT_4WAY
   };

   void SetMinecartVar(int id, int var, int value) {
      GBMinecarts[MCII_LAST + id * MCII_LAST + var] = value;
   }

   int GetMinecartVar(int id, int var) {
      return GBMinecarts[MCII_LAST + id * MCII_LAST + var];
   }

} // namespace MinecartNamespace


namespace BurningCombosNamespace {
   CONFIG BURNABLE_INID_POST_BURN_OFFSET = 0;
   CONFIG BURNABLE_INID_BURNTIME = 1;
   CONFIG BURNABLE_INID_SPREADTIME = 2;
   CONFIG BURNABLE_INID_INCLUDE_EWEAPONS = 3;

   CONFIG BURNING_COMBO_LV1 = 6344;
   CONFIG BURNING_COMBO_LV2 = 6345;
   CONFIG BURNING_COMBO_LV3 = 6346;
   CONFIG BURNING_COMBO_LV4 = 6347;

   class BurningCombo {
      combodata comboData;
      int burnTimer;
      int spreadTimer;
      int layer;
      int damage;
   }

   combodata script Burnable {
      void run(int postBurnOffset, int burnTime, int spreadTime, bool includeEWeapons) {
         //used as a marker
      }
   }

   ffc script RecursiveFire {
      void run(int minLevelRequired) {
         BurningCombo burningCombos[176];
         ResizeArray(burningCombos, NUM_COMBO_POS);

         int slotBurnable = Game->GetComboScript("Burnable");

         loop() {
            if (Game->LoadItemData(GetHighestLevelItemOwned(IC_CANDLE))->Level >= minLevelRequired) {
               //LWeapon collision
               for (int i = Screen->NumLWeapons; i > 0; --i) {
                  lweapon lWeapon = Screen->LoadLWeapon(i);

                     if (lWeapon->Type != LW_FIRE)
                        continue;

                  int pos = ComboAt(CenterX(lWeapon), CenterY(lWeapon));

                  for (int layer = 0; layer <= 2; ++layer) {
                     combodata comboData = Game->LoadComboData(Game->LoadTempScreen(layer)->ComboD[pos]);

                     if (comboData->Script == slotBurnable) {
                        if (burningCombos[pos] == null)
                           burningCombos[pos] = new BurningCombo();

                        if (burningCombos[pos]->burnTimer == 0) {
                           burningCombos[pos]->burnTimer = comboData->InitD[BURNABLE_INID_BURNTIME];
                           burningCombos[pos]->spreadTimer = comboData->InitD[BURNABLE_INID_SPREADTIME];
                           burningCombos[pos]->comboData = comboData;
                           burningCombos[pos]->layer = layer;
                           burningCombos[pos]->damage = lWeapon->Damage;
                        }
                     }
                  }
               }
            }
            //EWeapon collision
            if (Game->LoadItemData(GetHighestLevelItemOwned(IC_CANDLE))->Level >= minLevelRequired) {
               for (int i = Screen->NumEWeapons; i > 0; --i) {
                  eweapon eWeapon = Screen->LoadEWeapon(i);

                  if (eWeapon->Type != EW_FIRE)
                     continue;

                  int pos = ComboAt(CenterX(eWeapon), CenterY(eWeapon));

                  for (int layer = 0; layer <= 2; ++layer) {
                     combodata comboData = Game->LoadComboData(Game->LoadTempScreen(layer)->ComboD[pos]);

                     if (comboData->Script == slotBurnable) {
                        if (burningCombos[pos] == null)
                           burningCombos[pos] = new BurningCombo();

                        if (burningCombos[pos]->burnTimer == 0) {
                           burningCombos[pos]->burnTimer = comboData->InitD[BURNABLE_INID_BURNTIME];
                           burningCombos[pos]->spreadTimer = comboData->InitD[BURNABLE_INID_SPREADTIME];
                           burningCombos[pos]->comboData = comboData;
                           burningCombos[pos]->layer = layer;
                           burningCombos[pos]->damage = eWeapon->Damage;
                        }
                     }
                  }
               }
            }

            //Combo updates as the fire spreads
            for (int comboPos = 0; comboPos < NUM_COMBO_POS; ++comboPos) {
               BurningCombo burnCombo = burningCombos[comboPos];

               if (burnCombo != null && burnCombo->burnTimer > 0) {
                  --burnCombo->burnTimer;

                  // This ain't no Bible. Bushes burn up eventually.
                  if (burnCombo->burnTimer == 0) {
                     mapdata mapData = Game->LoadTempScreen(burnCombo->layer);
                     mapData->ComboD[comboPos] += burnCombo->comboData->InitD[BURNABLE_INID_POST_BURN_OFFSET];
                  }

                  Screen->FastCombo(burnCombo->layer, ComboX(comboPos), ComboY(comboPos), getBurningCombo(), 0, OP_OPAQUE);
                  makeHitbox(ComboX(comboPos), ComboY(comboPos), 16, 16, burnCombo->damage, 2);
                  makeHitboxLW(LW_SCRIPT1, ComboX(comboPos), ComboY(comboPos), 16, 16, burnCombo->damage, 2);

                  //If you're on fire raise your hand
                  if (burnCombo->spreadTimer > 0) {
                     --burnCombo->spreadTimer;

                     if (burnCombo->spreadTimer == 0) {
                        for (int dir = 0; dir <= 3; ++dir) {
                           int adjacentPos = AdjacentCombo(comboPos, dir);

                           if (adjacentPos > -1) {
                              for (int layer = 0; layer <= 2; ++layer) {
                                 combodata comboData = Game->LoadComboData(Game->LoadTempScreen(layer)->ComboD[adjacentPos]);

                                 if (comboData->Script == slotBurnable) {
                                    if (burningCombos[adjacentPos] == null)
                                       burningCombos[adjacentPos] = new BurningCombo();

                                    if (burningCombos[adjacentPos]->burnTimer == 0) {
                                       burningCombos[adjacentPos]->burnTimer = comboData->InitD[BURNABLE_INID_BURNTIME];
                                       burningCombos[adjacentPos]->spreadTimer = comboData->InitD[BURNABLE_INID_SPREADTIME];

                                       if (adjacentPos > comboPos) {
                                          ++burningCombos[adjacentPos]->burnTimer;
                                          ++burningCombos[adjacentPos]->spreadTimer;
                                       }

                                       burningCombos[adjacentPos]->comboData = comboData;
                                       burningCombos[adjacentPos]->layer = layer;
                                       burningCombos[adjacentPos]->damage = burnCombo->damage;
                                    }
                                 }
                              }
                           }
                        }
                     }
                  }
               }
            }

            Waitframe();
         }
      }
   }

   int getBurningCombo() {
      switch (GetHighestLevelItemOwned(IC_CANDLE)) {
         case 158: return BURNING_COMBO_LV1;
         case 10: return BURNING_COMBO_LV2;
         case 11: return BURNING_COMBO_LV3;
         case 150: return BURNING_COMBO_LV4;
         default: return BURNING_COMBO_LV1;
      }
   }
}

namespace IntroMovie {
   void introSequenceIntro() {
      for (int i = 0; i < INTRO_SCENE_TRANSITION_FRAMES; ++i) {
         disableLink();
         Screen->Rectangle(7, 0 - i * INTRO_SCENE_TRANSITION_MULT, 0, 256 - i * INTRO_SCENE_TRANSITION_MULT, 176, C_BLACK, 1, 0, 0, 0, true, OP_OPAQUE);
         Waitframe();
      }
   }

   void introSequenceOutro(int dmap, int screen) {
      for (int i = 0; i < INTRO_SCENE_TRANSITION_FRAMES; ++i) {
         disableLink();
         Screen->Rectangle(7, 256 - i * INTRO_SCENE_TRANSITION_MULT, 0, 512 - i * INTRO_SCENE_TRANSITION_MULT, 176, C_BLACK, 1, 0, 0, 0, true, OP_OPAQUE);
         Waitframe();
      }

      for (int i = 0; i < 60; ++i) {
         Screen->Rectangle(7, 0, 0, 256, 176, C_BLACK, 1, 0, 0, 0, true, OP_OPAQUE);
         disableLink();
         Waitframe();
      }

      Hero->Warp(dmap, screen);
   }

   @Author("Deathrider365")
   ffc script IntroSequenceScene1 {
      CONFIG COMBO_SCHOLAR_FACE_UP = 6744;
      CONFIG COMBO_SCHOLAR_FACE_RIGHT = 6795;

      void run(int dmap, int screen, int message1, int message2) {
         for (int i = 0; i < 120; ++i) {
            NoAction();
            Waitframe();
         }

         Screen->Message(message1);

         for (int i = 0; Screen->ShowingMessage; ++i) {
            // WaitTo(SCR_TIMING_POST_DRAW);
            NoAction();

            if (i == 120)
               Input->Button[CB_A] = true;

            Waitframe();
         }

         this->Data = COMBO_SCHOLAR_FACE_UP;

         for (int i = 0; i < 16; ++i) {
            this->Y -= 1;
            NoAction();
            Waitframe();
         }

         this->Data = COMBO_SCHOLAR_FACE_RIGHT;

         for (int i = 0; i < 60; ++i) {
            NoAction();
            Waitframe();
         }

         Screen->Message(message2);

         for (int i = 0; i < 120; ++i) {
            NoAction();
            Waitframe();
         }

         introSequenceOutro(dmap, screen);
      }
   }

   @Author("Deathrider365")
   ffc script IntroSequenceScene2 {
      CONFIG COMBO_SCHOLAR_FACE_UP = 6744;
      CONFIG COMBO_SCHOLAR_FACE_RIGHT = 6795;

      void run(int dmap, int screen, int message1) {
         int thisData = this->Data;
         this->Data = CMB_INVIS;

         introSequenceIntro();

         this->Data = thisData;
         this->Y = 192;

         for (int i = 0; i < 60; ++i) {
            NoAction();
            Waitframe();
         }

         for (int i = 0; i < 64; ++i) {
            this->Y -= 1;
            NoAction();
            Waitframe();
         }

         Screen->Message(message1);

         for (int i = 0; i < 120; ++i) {
            NoAction();
            Waitframe();
         }

         introSequenceOutro(dmap, screen);
      }
   }

   @Author("Deathrider365")
   ffc script IntroSequenceScene3 {
      CONFIG COMBO_SCHOLAR_FACE_UP = 6744;
      CONFIG COMBO_SCHOLAR_FACE_RIGHT = 6795;

      void run(int dmap, int screen, int message1) {
         introSequenceIntro();

         for (int i = 0; i < 120; ++i) {
            NoAction();
            Waitframe();
         }

         Screen->Message(message1);

         for (int i = 0; i < 120; ++i) {
            NoAction();
            Waitframe();
         }

         introSequenceOutro(dmap, screen);
      }
   }

   @Author("Deathrider365")
   ffc script IntroSequenceScene4 {
      CONFIG COMBO_SCHOLAR_FACE_UP = 6744;
      CONFIG COMBO_SCHOLAR_FACE_RIGHT = 6795;

      void run(int dmap, int screen, int message1) {
         int thisData = this->Data;
         this->Data = CMB_INVIS;

         introSequenceIntro();

         for (int i = 0; i < 180; ++i) {
            NoAction();
            Waitframe();
         }

         this->Data =  thisData;

         for (int i = 0; i < 32; ++i) {
            this->Y += (i % 2) ? 1 : 0;
            Waitframe();
         }

         Screen->Message(message1);

         for (int i = 0; i < 120; ++i) {
            NoAction();
            Waitframe();
         }

         introSequenceOutro(dmap, screen);
      }
   }

   @Author("Deathrider365")
   ffc script IntroSequenceScene5 {
      void run(int dmap, int screen, int message1) {
         introSequenceIntro();

         // this->X = 304;
         for (int i = 0; i < 120; ++i) {
            NoAction();
            Waitframe();
         }

         for (int i = 0; i < 64; ++i) {
            NoAction();
            // this->X -= 1;
            Waitframe();
         }

         Screen->Message(message1);

         for (int i = 0; i < 120; ++i) {
            NoAction();
            Waitframe();
         }

         introSequenceOutro(dmap, screen);
      }
   }

   @Author("Deathrider365")
   ffc script IntroSequenceScene5ShipPieces { //TODO better way of doing this
      void run(int startingX, int startingY) {
         // this->X = startingX;
         // this->Y = startingY;

         // for (int i = 0; i < 120; ++i) {
         //    NoAction();
         //    Waitframe();
         // }

         // for (int i = 0; i < 64; ++i) {
         //    NoAction();
         //    this->X -= 1;
         //    Waitframe();
         // }
      }
   }

   @Author("Deathrider365")
   ffc script IntroSequenceScene6 {
      void run(int dmap, int screen, int message1) {
         introSequenceIntro();

         for (int i = 0; i < 120; ++i) {
            NoAction();
            Waitframe();
         }

         Screen->Message(message1);
         Waitframe();
         Screen->TriggerSecrets();

         for (int i = 0; i < 120; ++i) {
            NoAction();
            Waitframe();
         }

         for (int i = 0; i < 48; ++i) {
            NoAction();
            this->Y -= (i & 3) ? 1 : 0;
            Waitframe();
         }

         introSequenceOutro(dmap, screen);
      }
   }

   @Author("Deathrider365")
   ffc script IntroSequenceScene7 {
      void run(int dmap, int screen, int message1) {
         introSequenceIntro();

         for (int i = 0; i < 120; ++i) {
            NoAction();
            Waitframe();
         }

         Screen->Message(message1);

         for (int i = 0; i < 120; ++i) {
            NoAction();
            Waitframe();
         }

         introSequenceOutro(dmap, screen);
      }
   }

   @Author("Deathrider365")
   ffc script IntroSequenceScene8 {
      void run(int dmap, int screen, int message1) {
         introSequenceIntro();

         for (int i = 0; i < 120; ++i) {
            NoAction();
            Waitframe();
         }

         for (int i = 0; i < 144; ++i) {
            NoAction();
            this->Y -= (i & 3) ? 1 : 0;
            Waitframe();
         }

         for (int i = 0; i < 120; ++i) {
            NoAction();
            Waitframe();
         }

         introSequenceOutro(dmap, screen);
      }
   }

   @Author("Deathrider365")
   ffc script IntroSequenceScene9 {
      void run(int dmap, int screen, int message1) {
         introSequenceIntro();

         for (int i = 0; i < 120; ++i) {
            NoAction();
            Waitframe();
         }

         Screen->Message(message1);

         for (int i = 0; i < 120; ++i) {
            NoAction();
            Waitframe();
         }

         introSequenceOutro(dmap, screen);
      }
   }

   @Author("Deathrider365")
   ffc script IntroSequenceScene10 {
      void run() {
         unless (getScreenD(0)) {
            introSequenceIntro();
            setScreenD(0, true);
         }
      }
   }
}

namespace Parallax {
    CONFIGB WARN_ON_UNIT_SCALE = false; // If true, the script will print a warning to the console if a setup appears to have the unit scale flag set wrong

    DEFINEL PLF_IS_SCREEN              = 0x001L; // Uses DrawScreen()
    DEFINEL PLF_TRANS                  = 0x002L;
    DEFINEL PLF_LERP_X                 = 0x004L;
    DEFINEL PLF_LERP_Y                 = 0x008L;
    DEFINEL PLF_NO_WRAP_X              = 0x010L;
    DEFINEL PLF_NO_WRAP_Y              = 0x020L;
    DEFINEL PLF_LERP_X_USES_MAP_POS    = 0x040L;
    DEFINEL PLF_LERP_Y_USES_MAP_POS    = 0x080L;
    DEFINEL PLF_VELOCITY_IGNORES_SCALE = 0x100L;
    DEFINEL PLF_NO_CLAMP_LERP          = 0x200L;
    DEFINEL PLF_RENDER_TARGET          = 0x400L;

    enum ParallaxLayerComboFlags {
        FLAG_DEFINITION_USE_SCREEN_DRAWS,
        FLAG_DEFINITION_TRANSPARENT,
        FLAG_DEFINITION_LOWER_FLOOR,
        FLAG_DEFINITION_LERP_X,
        FLAG_DEFINITION_LERP_Y,
        FLAG_DEFINITION_LERP_X_USES_MAP_POS,
        FLAG_DEFINITION_LERP_Y_USES_MAP_POS,
        FLAG_DEFINITION_NO_WRAP_X,
        FLAG_DEFINITION_NO_WRAP_Y,
        FLAG_DEFINITION_RANDOMIZE_STARTING_POSITION,
        FLAG_DEFINITION_VELOCITY_IGNORES_SCALE,
        FLAG_DEFINITION_UNITS_IN_SCREENS,
        FLAG_DEFINITION_LERP_ISNT_CLAMPED,
        FLAG_DEFINITION_USE_RENDER_TARGET
    };

    enum ParallaxLayerAttributes {
        ATTRIBUTE_DEFINITION_BG_COLOR,
        ATTRIBUTE_DEFINITION_UPDATE_FRAMES,
        ATTRIBUTE_DEFINITION_STARTING_X,
        ATTRIBUTE_DEFINITION_STARTING_Y,
        ATTRIBUTE_DEFINITION_WIDTH,
        ATTRIBUTE_DEFINITION_HEIGHT,
        ATTRIBUTE_DEFINITION_LERP_MIN_X,
        ATTRIBUTE_DEFINITION_LERP_MAX_X,
        ATTRIBUTE_DEFINITION_LERP_MIN_Y,
        ATTRIBUTE_DEFINITION_LERP_MAX_Y,
        ATTRIBUTE_DEFINITION_LERP_EDGE_BUFFER,
        ATTRIBUTE_DEFINITION_LERP_REF_MIN_X,
        ATTRIBUTE_DEFINITION_LERP_REF_MAX_X,
        ATTRIBUTE_DEFINITION_LERP_REF_MIN_Y,
        ATTRIBUTE_DEFINITION_LERP_REF_MAX_Y,
        ATTRIBUTE_DEFINITION_ROTATE_SCROLL,
        ATTRIBUTE_DEFINITION_ROTATE_PARALLAX
    };

    enum ParallaxLayerInitD {
        INITD_CONFIG_COMBO,
        INITD_CONFIG_NUM_COMBOS,
        INITD_CONFIG_FLOOR_MAP,
        INITD_CONFIG_FLOOR_SCREEN,
        INITD_CONFIG_TEMPORARY,

        INITD_DEFINITION_LAYER = 0,
        INITD_DEFINITION_SOURCE_MAP,
        INITD_DEFINITION_SOURCE_SCREEN,
        INITD_DEFINITION_VX,
        INITD_DEFINITION_VY,
        INITD_DEFINITION_PARALLAX_X,
        INITD_DEFINITION_PARALLAX_Y,
        INITD_DEFINITION_SCALE
    };

    enum ParallaxLayerArray {
        PLARRAY_CURRENT_LAYERS,
        PLARRAY_NEW_LAYERS,
        PLARRAY_BACKUP_LAYERS
    };

    ParallaxContainer ParallaxLayers;

    int RegionScreenOrigin() {
        return Region->OriginScreenIndex*10000;
    }

    class ParallaxContainer {
        ParallaxLayer CurrentLayers[0]; // The currently displaying set of layers
        ParallaxLayer NewLayers[0]; // Used when scroll warping into a screen with a different set of layers
        ParallaxLayer BackupLayers[0]; // Used to to store persistent layers underneath temporary ones

        bitmap DrawChecker;

        int LastDMap,LastScreen; // Used for detecting screen changes
        int NoScrollLastDMap,NoScrollLastScreen; // Timing jank used for finding true map positions during scrolling
        int LayerSourceDMap,LayerSourceScreen; // Used for detecting temp layer changes
        int RefCombos,RefCombosCount; // Used for comparing against new sets of layers
        int LowerFloorMap,LowerFloorScreen; // Used for comparing against new sets of layers
        int LastX,LastY; // Used for tracking viewport scrolling
        bool TemporaryLayer; // This layer will disappear upon changing screens/dmaps
        bool LayerCreatedByDMap; // Will disappear upon changing dmap if TemporaryLayer is set
        bool WasScrolling; // In the middle of a scrolling animation between two different parallax regions
        bool DisposeOfTempLayer; // Set when scrolling to a new screen when there is a temp layer
        bool ScrollingBGTransition; // Set every frame when scrolling between two screens with different layers. Used for communication.
        bool HasDrawn; // True if the script has drawn this frame
        bool ContinueFrame; // True if this is a continue frame (opening wipe)
        bool DrawFailed; // True if a draw has failed the previous frame
        int DrawCheckerColor; // Color used by the draw checker
        int BackupRefs[4]; // Backups of RefCombos, RefCombosCount, LowerFloorMap, and LowerFloorScreen, for use with IsDifferent()

        int Slot_ConfigParallaxFFC;

        ParallaxContainer() {
            Slot_ConfigParallaxFFC = Game->GetFFCScript("ConfigParallaxFFC");
            DrawChecker = new bitmap(1, 1);

            Init();
        }

        // Reset variables when created
        void Init() {
            LastDMap = -1;
            LastScreen = Game->CurScreen;
            NoScrollLastDMap = -1;
            NoScrollLastScreen = RegionScreenOrigin();
            LayerSourceDMap = -1;
            ResetParallax();
            ClearLayerFloorAndComboData();
            TemporaryLayer = false;
            WasScrolling = false;
            DisposeOfTempLayer = false;
            ScrollingBGTransition = false;
        }

        // Clears data about the current layer, when cleaning up temporary layers
        void ClearLayerFloorAndComboData() {
            LowerFloorMap = 0;
            LowerFloorScreen = 0;
            RefCombos = 0;
            RefCombosCount = 0;
        }

        // Called when starting or ending a scroll to reset the parallax tracking, since scrolling uses a different reference point
        void ResetParallax() {
            LastX = Viewport->X;
            LastY = Viewport->Y;
        }

        // Called every frame
        void Update() {
            if(Game->CurScreen>=0x80)
                return;

            Screen->DrawOrigin = DRAW_ORIGIN_PLAYING_FIELD;

            UpdateScreenChanges();
            UpdateScrolling();
            UpdateLayers(false);
            HasDrawn = false;
            ContinueFrame = false;
        }

        // Returns true if draw commands were unable to execute the previous frame
        bool CheckCanDrawDesync() {
            int prevColor = DrawCheckerColor;
            DrawCheckerColor = (DrawCheckerColor+1)%0xF;
            int getPixel = DrawChecker->GetPixel(0, 0);
            DrawChecker->PutPixel(0, 0, 0, DrawCheckerColor, 0, 0, 0, OP_OPAQUE);
            // The result of GetPixel is the color from the previous frame, because draws are deferred.
            // This means we can't tell if bitmap draws failed this frame, but we can tell
            // if the previous call's did and run them again!
            bool hasPixel = getPixel==prevColor;
            return !hasPixel;
        }

        // Called by the generic script to preload layers off of scripts
        void Preload() {
            bool found = RunFFCScriptsRemote();

            if(found) {
                UpdateLayers(true);
                HasDrawn = true;
            }
        }

        // Update tracking of screen changes
        void UpdateScreenChanges() {
            if(LastScreen != Game->CurScreen || LastDMap != Game->CurDMap) {
                if(TemporaryLayer) {
                    DisposeOfTempLayer = CanLayerDispose();

                    if(DisposeOfTempLayer)
                        TemporaryLayer = false;
                }
            }
            if(Game->Scrolling[SCROLL_DIR]==-1&&(NoScrollLastScreen!=RegionScreenOrigin()||NoScrollLastDMap!=Game->CurDMap))
            {
                NoScrollLastScreen = RegionScreenOrigin();
                NoScrollLastDMap = Game->CurDMap;
            }
            LastScreen = Game->CurScreen;
            LastDMap = Game->CurDMap;
        }

        // Process things that happen during scrolling
        void UpdateScrolling()
        {
            // // ContinueFrame is not cleared during preload, so if this is check, we known this is the frame following a continue.
            // // Viewport X and Y are not valid during continue, so the parallax must be reset afterwards.
            if(ContinueFrame)
                ResetParallax();
            // If just started scrolling
            if(Game->Scrolling[SCROLL_DIR]>-1)
            {
                if(!WasScrolling)
                {
                    ResetParallax();
                }
                // If layers will be disposed of but there's a backup to fall back on, do that
                if(DisposeOfTempLayer&&SizeOfArray(BackupLayers))
                {
                    LoadBackupLayers(PLARRAY_NEW_LAYERS);
                    DisposeOfTempLayer = false;
                }
                WasScrolling = true;
            }
            // ...Otherwise when stopping
            else
            {
                if(WasScrolling)
                {
                    ResetParallax();
                    // DisposeOfTempLayer is cleared when a new layer is assigned
                    // So this branch should only run if entering a truly empty screen
                    if(DisposeOfTempLayer)
                    {
                        ClearVisibleLayers();
                        ClearLayerFloorAndComboData();
                    }
                    // Otherwise we swap the new layers to the active layers
                    else
                    {
                        TransferNewLayers();
                    }
                    DisposeOfTempLayer = false;
                }
                WasScrolling = false;
            }

            // If not scrolling but disposing of a layer, just get rid of it here
            if(Game->Scrolling[SCROLL_DIR]==-1&&DisposeOfTempLayer)
            {
                ClearVisibleLayers();
                DisposeOfTempLayer = false;
                ClearLayerFloorAndComboData();
                LoadBackupLayers(PLARRAY_NEW_LAYERS);
            }
        }

        // Update the layers
        void UpdateLayers(bool preload)
        {
            int sz = SizeOfArray(CurrentLayers);
            int szNew = SizeOfArray(NewLayers);
            // Transition Type 1: The backgrounds are different
            ScrollingBGTransition = (szNew>0&&Game->Scrolling[SCROLL_DIR]>-1);
            // Transition Type 2: Scrolling off a temp layer screen
            if(DisposeOfTempLayer&&Game->Scrolling[SCROLL_DIR]>-1)
                ScrollingBGTransition = true;
            // Get movement based on viewport scrolling
            int dX = Viewport->X-LastX;
            int dY = Viewport->Y-LastY;
            LastX = Viewport->X;
            LastY = Viewport->Y;
            // Call update functions on Current and New layers
            if(preload)
            {
                for(int i=0; i<sz; ++i)
                {
                    CurrentLayers[i]->UpdatePreload();
                }
                for(int i=0; i<szNew; ++i)
                {
                    NewLayers[i]->UpdatePreload();
                }
            }
            else
            {
                for(int i=0; i<sz; ++i)
                {
                    CurrentLayers[i]->Update(dX, dY);
                }
                for(int i=0; i<szNew; ++i)
                {
                    NewLayers[i]->Update(dX, dY);
                }
            }
        }

        // Returns true if conditions are met to dispose of a layer
        bool CanLayerDispose()
        {
            if(!TemporaryLayer)
                return false;
            if(LayerCreatedByDMap)
                return LayerSourceDMap!=Game->CurDMap;
            else
                return (LayerSourceDMap!=Game->CurDMap||LayerSourceScreen!=RegionScreenOrigin());
        }

        // Update layers for FFCs carrying the script
        bool RunFFCScriptsRemote()
        {
            bool ret;
            for(int i=1; i<=MAX_FFC; ++i)
            {
                ffc f = Screen->LoadFFC(i);
                if(f->Script==Slot_ConfigParallaxFFC)
                {
                    ConfigParallaxFFC.runRemote(f);
                    ret = true;
                }
            }
            return ret;
        }

        // Add a new layer onto the list
        void Add(combodata cd, int floorMap, int floorScreen, bool scrolling)
        {
            ParallaxLayer pl = new ParallaxLayer(cd, floorMap, floorScreen);
            if(scrolling)
            {
                ArrayPushBack(NewLayers, pl);
                pl->IsNew = true;
            }
            else
            {
                ArrayPushBack(CurrentLayers, pl);
                pl->IsNew = false;
            }
        }

        // Clear the active Current and New layers
        void ClearVisibleLayers()
        {
            TemporaryLayer = false;
            Clear(PLARRAY_CURRENT_LAYERS);
            Clear(PLARRAY_NEW_LAYERS);
        }

        // Clear a specific layer list
        void Clear(ParallaxLayerArray which)
        {
            switch(which)
            {
                case PLARRAY_CURRENT_LAYERS:
                {
                    ResizeArray(CurrentLayers, 0);
                    break;
                }
                case PLARRAY_NEW_LAYERS:
                {
                    ResizeArray(NewLayers, 0);
                    break;
                }
                case PLARRAY_BACKUP_LAYERS:
                {
                    ResizeArray(BackupLayers, 0);
                    break;
                }
            }
        }

        // Transfer layers from the New list to the Current one, if there are any New layers
        void TransferNewLayers()
        {
            int sz = SizeOfArray(NewLayers);
            if(sz>0)
            {
                Clear(PLARRAY_CURRENT_LAYERS);
                for(int i=0; i<sz; ++i)
                {
                    NewLayers[i]->IsNew = false;
                    ArrayPushBack(CurrentLayers, NewLayers[i]);
                }
                Clear(PLARRAY_NEW_LAYERS);
            }
        }

        // Transfers Backup layers to the New or Current list, if there are any Backup layers
        void LoadBackupLayers(ParallaxLayerArray toWhich)
        {
            int sz = SizeOfArray(BackupLayers);
            if(sz>0)
            {
                Clear(toWhich);
                for(int i=0; i<sz; ++i)
                {
                    if(toWhich==PLARRAY_CURRENT_LAYERS)
                    {
                        BackupLayers[i]->IsNew = false;
                        ArrayPushBack(CurrentLayers, BackupLayers[i]);
                    }
                    else
                    {
                        BackupLayers[i]->IsNew = true;
                        ArrayPushBack(NewLayers, BackupLayers[i]);
                    }
                }
                RefCombos = BackupRefs[0];
                RefCombosCount = BackupRefs[1];
                LowerFloorMap = BackupRefs[2];
                LowerFloorScreen = BackupRefs[3];
            }
        }

        // Transfers layers from the New or Current list to the Backup layers
        void SaveBackupLayers(ParallaxLayerArray fromWhich)
        {
            int sz;
            if(fromWhich==PLARRAY_CURRENT_LAYERS)
                sz = SizeOfArray(CurrentLayers);
            else
                sz = SizeOfArray(NewLayers);
            if(sz>0)
            {
                Clear(PLARRAY_BACKUP_LAYERS);
                for(int i=0; i<sz; ++i)
                {
                    if(fromWhich==PLARRAY_CURRENT_LAYERS)
                        ArrayPushBack(BackupLayers, CurrentLayers[i]);
                    else
                        ArrayPushBack(BackupLayers, NewLayers[i]);
                }
                BackupRefs[0] = RefCombos;
                BackupRefs[1] = RefCombosCount;
                BackupRefs[2] = LowerFloorMap;
                BackupRefs[3] = LowerFloorScreen;
            }
        }
    }

    class ParallaxLayer
    {
        bitmap LayerBitmap;
        bitmap ScreenBitmap;
        int Layer;
        int X,Y;
        int VX,VY;
        int ParallaxVX,ParallaxVY;
        int RotateScroll,RotateParallax;
        int XOffset,YOffset;
        int LerpMinX,LerpMaxX;
        int LerpMinY,LerpMaxY;
        int LerpEdgeBuffer;
        int LerpRefMinX,LerpRefMaxX;
        int LerpRefMinY,LerpRefMaxY;
        int Width,Height;
        int SourceMap,SourceScreen;
        int Scale;
        int BGColor;
        int UpdateFrames;
        int UpdateFreq;
        long Flags;

        bool IsNew;

        ParallaxLayer(combodata cd, int floorMap, int floorScreen)
        {
            ParallaxDefinition.Load(cd, this, floorMap, floorScreen);
            if(Width<=0)
                Width = 256;
            if(Height<=0)
                Height = DMapViewportHeight();
            LayerBitmap = new bitmap(Width*2, Height*2);
            ScreenBitmap = new bitmap(256, 232);
            RefreshBitmap();
        }

        // Runs every frame to update the position of the layer and then draw it
        void Update(int dX, int dY)
        {
            if(UpdateFreq>0)
            {
                ++UpdateFrames;
                if(UpdateFrames>=UpdateFreq)
                {
                    UpdateFrames = 0;
                    RefreshBitmap();
                }
            }

            UpdateMotion(dX, dY);
            UpdateLerp();
            UpdateWrap();
            Draw();
        }

        // Runs on preload frames after being newly created off an FFC, for drawing during certain timings
        void UpdatePreload()
        {
            UpdateLerp();
            UpdateWrap();
            Draw();
        }

        // Redraws the whole bitmap used for the layer. Expensive so ideally only called when it needs to be
        void RefreshBitmap()
        {
            int lyr = 0;
            int rt = SourceScreen;
            int offset = 0;
            if(Flags&PLF_RENDER_TARGET)
            {
                lyr = rt==RT_SCREEN?7:0;
                offset = rt==RT_SCREEN?56:0;
            }
            LayerBitmap->ClearToColor(lyr, BGColor);
            if(Flags&PLF_RENDER_TARGET)
            {
                int rt = SourceScreen;
                LayerBitmap->BlitTo(lyr, rt, 0, offset, Width, Height, 0, 0, Width, Height, 0, 0, 0, BITDX_NORMAL, 0, true);
            }
            else
            {
                int w = Ceiling(Width/256);
                int h = Ceiling(Height/176);
                for(int x=0; x<w; ++x)
                {
                    for(int y=0; y<h; ++y)
                    {
                        int scrn = Clamp(SourceScreen+x+y*16, 0x00, 0x7F);
                        if(Flags&PLF_IS_SCREEN)
                            LayerBitmap->DrawScreen(lyr, SourceMap, scrn, x*256, y*176, 0);
                        else
                            LayerBitmap->DrawLayer(lyr, SourceMap, scrn, 0, x*256, y*176, 0, OP_OPAQUE);
                    }
                }
                LayerBitmap->Rectangle(lyr, Width, 0, LayerBitmap->Width, LayerBitmap->Height, 0x00, 1, 0, 0, 0, true, OP_OPAQUE);
                LayerBitmap->Rectangle(lyr, 0, Height, LayerBitmap->Width, LayerBitmap->Height, 0x00, 1, 0, 0, 0, true, OP_OPAQUE);
            }
            for(int i=0; i<4; ++i)
            {
                int x = i%2;
                int y = Floor(i/2);
                bool drawCopy = true;
                switch(i)
                {
                    case 0:
                        drawCopy = false;
                        break;
                    case 1:
                        if(Flags&PLF_NO_WRAP_X)
                            drawCopy = false;
                        break;
                    case 2:
                        if(Flags&PLF_NO_WRAP_Y)
                            drawCopy = false;
                        break;
                    case 3:
                        if((Flags&PLF_NO_WRAP_X)||(Flags&PLF_NO_WRAP_Y))
                            drawCopy = false;
                        break;
                }
                if(drawCopy)
                    LayerBitmap->Blit(lyr, LayerBitmap, 0, 0, Width, Height, x*Width, y*Height, Width, Height, 0, 0, 0, BITDX_NORMAL, 0, false);
            }
        }

        // Moves the layer based on time and viewport movement
        void UpdateMotion(int dX, int dY)
        {
            if(Screen->ShowingMessage)
                return;
            int vX = VX;
            int vY = VY;
            if(RotateScroll)
            {
                int dist = Distance(0, 0, vX, vY);
                vX = VectorX(dist, RotateScroll);
                vY = VectorY(dist, RotateScroll);
            }
            if(RotateParallax)
            {
                int dist = Distance(0, 0, dX, dY);
                dX = VectorX(dist, RotateParallax);
                dY = VectorY(dist, RotateParallax);
            }
            if(Scale==0)
                printf("Scale is 0!\n");
            if(Flags&PLF_VELOCITY_IGNORES_SCALE)
            {
                X -= vX/Scale;
                Y -= vY/Scale;
                X += dX*ParallaxVX/Scale;
                Y += dY*ParallaxVY/Scale;
            }
            else
            {
                X -= vX;
                Y -= vY;
                X += dX*ParallaxVX;
                Y += dY*ParallaxVY;
            }
            if(ParallaxLayers->ScrollingBGTransition)
            {
                if(ParallaxVX!=0&&Game->Scrolling[SCROLL_DIR]>=DIR_LEFT)
                    X -= dX*1/Scale;
                if(ParallaxVY!=0&&Game->Scrolling[SCROLL_DIR]<DIR_LEFT)
                    Y -= dY*1/Scale;
            }
            //UpdateMotionDebug(4, 0.1);
        }

        // For debugging motion stuff
        void UpdateMotionDebug(int layerStep, int scaleStep)
        {
            if(Link->InputEx1)
            {
                X += (Link->InputLeft?-layerStep:0) + (Link->InputRight?layerStep:0);
                Y += (Link->InputUp?-layerStep:0) + (Link->InputDown?layerStep:0);
                if(Link->PressL)
                    Scale -= scaleStep;
                else if(Link->PressR)
                    Scale += scaleStep;
                if(Link->PressEx2)
                {
                    Flags ^= PLF_NO_WRAP_X;
                    RefreshBitmap();
                }
                if(Link->PressEx3)
                {
                    Flags ^= PLF_NO_WRAP_Y;
                    RefreshBitmap();
                }
                for(int i=0; i<16; ++i)
                    Screen->DrawInteger(7, 15*i-i*6, 0, FONT_Z3SMALL, 0x01, 0x0F, -1, -1, ((Flags&(1L<<i))>>i)*10000, 0, OP_OPAQUE);
                Link->Stun = 10;
            }
        }

        // Moves the layer based on viewport position when lerp is enabled
        void UpdateLerp()
        {
            int vw = 256;
            int vh = DMapViewportHeight();
            int xClamped,yClamped;
            int edgeBuf = LerpEdgeBuffer/Scale;
            if(Flags&PLF_LERP_X)
            {
                int vpX = Viewport->X;
                int rW = Region->Width;
                if(Game->Scrolling[SCROLL_DIR]>-1)
                {
                    if(IsNew)
                    {
                        vpX = Game->Scrolling[SCROLL_NEW_VIEWPORT_X];
                        rW = Game->Scrolling[SCROLL_NEW_REGION_SCREEN_WIDTH]*256;
                        if(Game->Scrolling[SCROLL_DIR]<DIR_LEFT)
                            vpX = Viewport->X-Game->Scrolling[SCROLL_NEW_REGION_DELTA_X];
                    }
                    else
                    {
                        vpX = Game->Scrolling[SCROLL_OLD_VIEWPORT_X];
                        rW = Game->Scrolling[SCROLL_OLD_REGION_SCREEN_WIDTH]*256;
                        if(Game->Scrolling[SCROLL_DIR]<DIR_LEFT)
                            vpX = Viewport->X;
                    }
                }
                int pct;
                int topBufDiff, bottomBufDiff;
                if(LerpEdgeBuffer>0)
                {
                    topBufDiff = Min(vpX, LerpEdgeBuffer)/Scale;
                    bottomBufDiff = (LerpEdgeBuffer - Max(0, vpX-(rW-vw-LerpEdgeBuffer)))/Scale;
                }
                if(Flags&PLF_LERP_X_USES_MAP_POS)
                {
                    int globalViewportX = (RegionScreenOrigin()%16)*256+Viewport->X;
                    if(Game->Scrolling[SCROLL_DIR]>-1)
                        globalViewportX = (ParallaxLayers->NoScrollLastScreen%16)*256+Viewport->X;
                    pct = (globalViewportX-LerpRefMinX)/(LerpRefMaxX-LerpRefMinX);
                    int vScaleOffset = Width/Scale-Width;
                    X = Lerp(LerpMinX, LerpMaxX, pct);
                }
                else
                {
                    pct = (rW-vw)==0?0:vpX/(rW-vw);
                    if(rW-vw<=0)
                        X = Lerp(LerpMinX, LerpMaxX, 0.5);
                    else
                        X = Lerp(LerpMinX+topBufDiff, LerpMaxX-bottomBufDiff, pct);
                }
                if(!(Flags&PLF_NO_CLAMP_LERP))
                    X = Clamp(X, Min(LerpMinX, LerpMaxX), Max(LerpMinX, LerpMaxX));
                X += XOffset;
                if(Flags&PLF_LERP_X_USES_MAP_POS)
                    X -= (Width-(Width*Scale))/2/Scale;
            }
            if(Flags&PLF_LERP_Y)
            {
                int vpY = Viewport->Y;
                int rH = Region->Height;
                if(Game->Scrolling[SCROLL_DIR]>-1)
                {
                    if(IsNew)
                    {
                        vpY = Game->Scrolling[SCROLL_NEW_VIEWPORT_Y];
                        rH = Game->Scrolling[SCROLL_NEW_REGION_SCREEN_HEIGHT]*176;
                        if(Game->Scrolling[SCROLL_DIR]>=DIR_LEFT)
                            vpY = Viewport->Y-Game->Scrolling[SCROLL_NEW_REGION_DELTA_Y];
                    }
                    else
                    {
                        vpY = Game->Scrolling[SCROLL_OLD_VIEWPORT_Y];
                        rH = Game->Scrolling[SCROLL_OLD_REGION_SCREEN_HEIGHT]*176;
                        if(Game->Scrolling[SCROLL_DIR]>=DIR_LEFT)
                            vpY = Viewport->Y;
                    }
                }
                int pct;
                int topBufDiff, bottomBufDiff;
                if(LerpEdgeBuffer>0)
                {
                    topBufDiff = Min(vpY, LerpEdgeBuffer)/Scale;
                    bottomBufDiff = (LerpEdgeBuffer - Max(0, vpY-(rH-vh-LerpEdgeBuffer)))/Scale;
                }
                if(Flags&PLF_LERP_Y_USES_MAP_POS)
                {
                    int globalViewportY = Floor(RegionScreenOrigin()/16)*176+Viewport->Y;
                    if(Game->Scrolling[SCROLL_DIR]>-1)
                        globalViewportY = Floor(ParallaxLayers->NoScrollLastScreen/16)*176+Viewport->Y;
                    pct = (globalViewportY-LerpRefMinY)/(LerpRefMaxY-LerpRefMinY);
                    Y = Lerp(LerpMinY, LerpMaxY, pct);
                }
                else
                {
                    pct = (rH-vh)==0?0:vpY/(rH-vh);
                    if(rH-vh<=0)
                        Y = Lerp(LerpMinY, LerpMaxY, 0.5);
                    else
                        Y = Lerp(LerpMinY+topBufDiff, LerpMaxY-bottomBufDiff, pct);
                }
                if(!(Flags&PLF_NO_CLAMP_LERP))
                    Y = Clamp(Y, Min(LerpMinY, LerpMaxY), Max(LerpMinY, LerpMaxY));
                Y += YOffset;
                if(Flags&PLF_LERP_Y_USES_MAP_POS)
                    Y -= (Height-(Height*Scale))/2/Scale;
            }
        }

        // Keeps the layer view wrapped, if wrapping is enabled
        void UpdateWrap()
        {
            if(!(Flags&PLF_NO_WRAP_X))
                X = wrap(X, Width);
            if(!(Flags&PLF_NO_WRAP_Y))
                Y = wrap(Y, Height);
        }

        // Draw the layer to the screen
        void Draw()
        {
            if(ParallaxLayers->HasDrawn)
                return;
            Screen->DrawOrigin = DRAW_ORIGIN_PLAYING_FIELD;
            int vw = 256;
            int vh = DMapViewportHeight();
            ScreenBitmap->Clear(0);
            int wSample = Floor(vw/Scale);
            int hSample = Floor(vh/Scale);
            WrapBlit(LayerBitmap, 0, ScreenBitmap, X, Y, wSample, hSample, 0, 0, vw, vh, 0, 0, 0, BITDX_NORMAL, 0, false, Flags&PLF_NO_WRAP_X, Flags&PLF_NO_WRAP_Y);
            int xoff,yoff;
            if(ParallaxLayers->ScrollingBGTransition)
            {
                // Get scrolling offsets
                if(IsNew)
                {
                    xoff = Game->Scrolling[SCROLL_NX];
                    yoff = Game->Scrolling[SCROLL_NY];
                }
                else
                {
                    xoff = Game->Scrolling[SCROLL_OX];
                    yoff = Game->Scrolling[SCROLL_OY];
                }
                // Don't draw offset for screen realignment
                if(Game->Scrolling[SCROLL_DIR]<DIR_LEFT)
                    xoff = 0;
                else
                    yoff = 0;
                // When extended viewport is on
                if(vh>176)
                {
                    // Weird offset for the upper screen of a vertical scroll
                    if(Game->Scrolling[SCROLL_DIR]==DIR_UP&&IsNew)
                        yoff -= 56;
                    else if(Game->Scrolling[SCROLL_DIR]==DIR_DOWN&&!IsNew)
                        yoff -= 56;
                }
            }
            // Small viewport draws lower on the screen
            if(vh==176)
                yoff += 56;
            else if(IsMessyVerticalScroll())
                yoff += vh-Viewport->Height;
            //int offsetY = vh-Viewport->Height+56;
            Screen->DrawOrigin = DRAW_ORIGIN_SCREEN;
            ScreenBitmap->Blit(Layer, RT_SCREEN, 0, 0, vw, vh, xoff, yoff, vw, vh, 0, 0, 0, (Flags&PLF_TRANS)?BITDX_TRANS:BITDX_NORMAL, 0, BGColor==0);
        }
        // Returns true if scrolling vertically onto a new screen that will change the size of the viewport
        bool IsMessyVerticalScroll()
        {
            if(ParallaxLayers->ScrollingBGTransition)
            {
                if(Game->Scrolling[SCROLL_DIR]<DIR_LEFT&&Game->Scrolling[SCROLL_NEW_REGION_SCREEN_HEIGHT]!=Game->Scrolling[SCROLL_OLD_REGION_SCREEN_HEIGHT]==1)
                {
                    return Game->Scrolling[SCROLL_NEW_REGION_SCREEN_HEIGHT]==1||Game->Scrolling[SCROLL_OLD_REGION_SCREEN_HEIGHT]==1;
                }
            }
            return false;
        }

        // Blit that wraps around the edges to fit the destination rect
        void WrapBlit(bitmap b, int layer, bitmap target, int sx, int sy, int sw, int sh, int dx, int dy, int dw, int dh, int rotation = 0, int cx = 0, int cy = 0, int mode = 0, int lit = 0, bool mask = true, bool noWrapX = false, bool noWrapY = false)
        {
            int vpH = DMapViewportHeight();

            // The bitmap contains four copies of itself for wrapping so the true size is halved
            int w = b->Width/2;
            int h = b->Height/2;
            if(!noWrapX)
                sx = wrap(sx, w);
            if(!noWrapY)
                sy = wrap(sy, h);
            // Unit source: This is the source rect but clamped to the bitmap's size
            int uSrcW = Ceiling(Min(sw, w));
            int uSrcH = Ceiling(Min(sh, h));
            // If the viewport goes outside the bitmap but there's no wrap, ignore unit scale
            if(noWrapX&&(sx<0||sx+sw>=w))
                uSrcW = sw;
            if(noWrapY&&(sy<0||sy+sh>=h))
                uSrcH = sh;
            // Scaling for destination units.
            // Represents how many times the original source rect can fit inside the unit source rect
            int scaleX = Min(uSrcW/sw, 1);
            int scaleY = Min(uSrcH/sh, 1);
            // Unit dest: Size and offset for drawn sections
            int uDestW = Ceiling(dw*scaleX);
            int uDestH = Ceiling(dh*scaleY);
            // Repeat counts: Number of units drawn in a grid on each axis
            int repX = Ceiling(dw/uDestW);
            int repY = Ceiling(dh/uDestH);

            int dXOff = 0;
            int dYOff = 0;
            if(noWrapX)
            {
                if(uSrcW<256)
                {
                    dXOff = sx*scaleX;
                    sx = 0;
                }
                repX = 1;
            }
            if(noWrapY)
            {
                if(uSrcH<vpH)
                {
                    dYOff = sy*scaleY;
                    sy = 0;
                }
                repY = 1;
            }
            uSrcW = Ceiling(uSrcW);
            uSrcH = Ceiling(uSrcH);
            for(int xx=0; xx<repX; ++xx)
            {
                for(int yy=0; yy<repY; ++yy)
                {
                    ClampedBlit(b, layer, target, Round(sx), Round(sy), uSrcW, uSrcH, uDestW*xx+dXOff, uDestH*yy+dYOff, uDestW, uDestH, rotation, cx, cy, mode, lit, mask);
                }
            }

        }

        // Blit that's clamped to the screen, to prevent a crash
        void ClampedBlit(bitmap b, int layer, untyped target, int sx, int sy, int sw, int sh, int dx, int dy, int dw, int dh, int rotation = 0, int cx = 0, int cy = 0, int mode = 0, int lit = 0, bool mask = true)
        {
            sx = Floor(sx);
            sy = Floor(sy);
            dx = Floor(dx);
            dy = Floor(dy);
            // Scaling multipier for the dest rect
            int scx = (dw/sw);
            int scy = (dh/sh);
            // Clipped the left side, shrink width and offset right to compensate
            if(sx<0)
            {
                int shave = -sx;
                sw -= shave;
                sx += shave;
                int dshave = Floor(shave*scx);
                dw -= dshave;
                dx += dshave;
            }
            // Clipped the right side, shrink width
            if(sx+sw>b->Width)
            {
                int shave = Abs(b->Width-(sx+sw));
                sw -= shave;
                int dshave = Floor(shave*scx);
                dw -= dshave;
            }
            // Clipped the top side, shrink height and offset down to compensate
            if(sy<0)
            {
                int shave = -sy;
                sh -= shave;
                sy += shave;
                int dshave = Floor(shave*scy);
                dh -= dshave;
                dy += dshave;
            }
            // Clipped the bottom side, shrink height
            if(sy+sh>b->Height)
            {
                int shave = Abs(b->Height-(sy+sh));
                sh -= shave;
                int dshave = Floor(shave*scy);
                dh -= dshave;
            }
            // Don't bother if the whole source rect is out of bounds
            if(sw>0&&sh>0)
                b->Blit(layer, target, sx, sy, sw, sh, dx, dy, dw, dh, rotation, cx, cy, mode, lit, mask);
        }
    }

    // Returns the max height for the viewport for the current DMap
    // Even if it's shrunk be being in a smaller region, it will still return 232 for an extended viewport
    int DMapViewportHeight()
    {
        dmapdata dmd = Game->LoadDMapData(Game->CurDMap);
        if(dmd->Flagset[DMFS_EXTENDEDVIEWPORT])
            return 232;
        return 176;
    }

    @InitScript(0)
    global script ParallaxInit
    {
        void run()
        {
            RunGenericScript(CheckGenericScript("ParallaxGeneric"));
            RunGenericScript(CheckGenericScript("ParallaxGenericEvents"));
        }
    }
    generic script ParallaxGeneric
    {
        void run()
        {
            this->ReloadState[GENSCR_ST_RELOAD] = true;
            this->ReloadState[GENSCR_ST_CONTINUE] = true;
            RunGenericScript(CheckGenericScript("ParallaxGenericEvents"));

            Screen->DrawOrigin = DRAW_ORIGIN_SCREEN;
            if(!ParallaxLayers)
            {
                ParallaxLayers = new ParallaxContainer();
            }

            ParallaxLayers->DrawChecker->Clear(0);
            ParallaxLayers->DrawCheckerColor = 0x00;

            while(true)
            {
                WaitTo(SCR_TIMING_WAITDRAW);
                ParallaxLayers->Update();
                Waitframe();
            }
        }
    }

    generic script ParallaxGenericEvents
    {
        void run()
        {
            this->EventListen[GENSCR_EVENT_INIT] = true;
            this->EventListen[GENSCR_EVENT_CONTINUE] = true;
            this->EventListen[GENSCR_EVENT_FFC_PRELOAD] = true;
            while(true)
            {
                switch(WaitEvent())
                {
                    case GENSCR_EVENT_INIT:
                    case GENSCR_EVENT_CONTINUE:
                        ParallaxLayers->ClearVisibleLayers();
                        ParallaxLayers->Clear(PLARRAY_BACKUP_LAYERS);
                        ParallaxLayers->ClearLayerFloorAndComboData();
                        ParallaxLayers->ContinueFrame = true;
                        break;
                    case GENSCR_EVENT_FFC_PRELOAD:
                        ParallaxLayers->Preload();
                        if(ParallaxLayers->ContinueFrame)
                            ParallaxLayers->HasDrawn = false;
                        break;
                }
            }
        }
    }

    @InitD0("Combo Reference"),
    @InitDHelp0("This is the first of the combos to reference for the layers."),
    @InitD1("Num Combos"),
    @InitDHelp1("This many combos will be used for layer data, each combo representing a layer to add."),
    @InitD2("Floor Map"),
    @InitDHelp2("If a layer has the flag \"Lower Floor\" checked, this map will be used instead of the one indicated by the combo."),
    @InitD3("Floor Screen"),
    @InitDHelp3("If a layer has the flag \"Lower Floor\" checked, this screen will be used instead of the one indicated by the combo."),
    @InitDType3("H"),
    @InitD4("Temporary"),
    @InitDHelp4("If checked, this layer will only persist for the current screen."),
    @InitDType4("B")
    ffc script ConfigParallaxFFC
    {
        void run()
        {
            if(this->Flags[FFCF_PRELOAD])
                Waitframe();
            // Most of the time this function is being called via generic script via preload timing
            runRemote(this, ParallaxLayers->CheckCanDrawDesync());
            while(true)
                Waitframe();
        }
        void runRemote(ffc this, bool forceReplace=false)
        {
            int refCombos = this->InitD[INITD_CONFIG_COMBO];
            int refCombosCount = this->InitD[INITD_CONFIG_NUM_COMBOS];
            int floorMap = this->InitD[INITD_CONFIG_FLOOR_MAP];
            int floorScreen = this->InitD[INITD_CONFIG_FLOOR_SCREEN];
            bool temporary = this->InitD[INITD_CONFIG_TEMPORARY];
            if(!refCombosCount)
                refCombosCount = 1;
            // This needs to be called to keep the color of the checker bitmap synced
            if(!forceReplace)
                ParallaxLayers->CheckCanDrawDesync();
            if(forceReplace||IsDifferent(refCombos, refCombosCount, floorMap, floorScreen))
            {
                if(Game->Scrolling[SCROLL_DIR]==-1)
                    ParallaxLayers->ClearVisibleLayers();
                else
                    ParallaxLayers->Clear(PLARRAY_NEW_LAYERS);
                for(int i=0; i<refCombosCount; ++i)
                {
                    combodata cd = Game->LoadComboData(refCombos+i);
                    ParallaxLayers->Add(cd, floorMap, floorScreen, Game->Scrolling[SCROLL_DIR]>-1);
                    ParallaxLayers->TemporaryLayer = temporary;
                    ParallaxLayers->LayerCreatedByDMap = false;
                }
                if(!temporary)
                    ParallaxLayers->SaveBackupLayers(Game->Scrolling[SCROLL_DIR]>-1?PLARRAY_NEW_LAYERS:PLARRAY_CURRENT_LAYERS);
                ParallaxLayers->RefCombos = refCombos;
                ParallaxLayers->RefCombosCount = refCombosCount;
                ParallaxLayers->LowerFloorMap = floorMap;
                ParallaxLayers->LowerFloorScreen = floorScreen;
                ParallaxLayers->LayerSourceDMap = Game->CurDMap;
                ParallaxLayers->LayerSourceScreen = RegionScreenOrigin();
            }
        }
        bool IsDifferent(int refCombos, int refCombosCount, int floorMap, int floorScreen)
        {
            bool differentScreen = (ParallaxLayers->LayerSourceDMap!=Game->CurDMap||ParallaxLayers->LayerSourceScreen!=RegionScreenOrigin());
            if(ParallaxLayers->TemporaryLayer&&!ParallaxLayers->LayerCreatedByDMap)
                return differentScreen;
            if(floorMap>0)
            {
                if(ParallaxLayers->LowerFloorMap!=floorMap||ParallaxLayers->LowerFloorScreen!=floorScreen)
                    return true;
            }
            if(ParallaxLayers->RefCombos!=refCombos||ParallaxLayers->RefCombosCount!=refCombosCount)
                return true;
            return false;
        }
    }

    @InitD0("Combo Reference"),
    @InitDHelp0("This is the first of the combos to reference for the layers."),
    @InitD1("Num Combos"),
    @InitDHelp1("This many combos will be used for layer data, each combo representing a layer to add."),
    @InitD2("Floor Map"),
    @InitDHelp2("If a layer has the flag \"Lower Floor\" checked, this map will be used instead of the one indicated by the combo. Pretty useless on a dmap."),
    @InitD3("Floor Screen"),
    @InitDHelp3("If a layer has the flag \"Lower Floor\" checked, this screen will be used instead of the one indicated by the combo. Pretty useless on a dmap."),
    @InitDType3("H"),
    @InitD4("Temporary"),
    @InitDHelp4("If checked, this layer will only persist for the current screen."),
    @InitDType4("B")
    dmapdata script ConfigParallaxDMap
    {
        void run(int refCombos, int refCombosCount, int floorMap, int floorScreen, bool temporary)
        {
            if(!refCombosCount)
                refCombosCount = 1;
            tryLoad(refCombos, refCombosCount, floorMap, floorScreen, temporary);
            Waitframe();
            tryLoad(refCombos, refCombosCount, floorMap, floorScreen, temporary);
        }
        void runRemote(dmapdata this)
        {
            int refCombos = this->InitD[INITD_CONFIG_COMBO];
            int refCombosCount = this->InitD[INITD_CONFIG_NUM_COMBOS];
            int floorMap = this->InitD[INITD_CONFIG_FLOOR_MAP];
            int floorScreen = this->InitD[INITD_CONFIG_FLOOR_SCREEN];
            bool temporary = this->InitD[INITD_CONFIG_TEMPORARY];
            if(!refCombosCount)
                refCombosCount = 1;
            tryLoad(refCombos, refCombosCount, floorMap, floorScreen, temporary);
        }
        void tryLoad(int refCombos, int refCombosCount, int floorMap, int floorScreen, bool temporary)
        {
            if(IsDifferent(refCombos, refCombosCount, floorMap, floorScreen))
            {
                if(Game->Scrolling[SCROLL_DIR]==-1)
                    ParallaxLayers->ClearVisibleLayers();
                else
                    ParallaxLayers->Clear(PLARRAY_NEW_LAYERS);
                for(int i=0; i<refCombosCount; ++i)
                {
                    combodata cd = Game->LoadComboData(refCombos+i);
                    ParallaxLayers->Add(cd, floorMap, floorScreen, Game->Scrolling[SCROLL_DIR]>-1);
                    ParallaxLayers->TemporaryLayer = temporary;
                    ParallaxLayers->LayerCreatedByDMap = true;
                }
                if(!temporary)
                    ParallaxLayers->SaveBackupLayers(Game->Scrolling[SCROLL_DIR]>-1?PLARRAY_NEW_LAYERS:PLARRAY_CURRENT_LAYERS);
                ParallaxLayers->RefCombos = refCombos;
                ParallaxLayers->RefCombosCount = refCombosCount;
                ParallaxLayers->LowerFloorMap = floorMap;
                ParallaxLayers->LowerFloorScreen = floorScreen;
                ParallaxLayers->LayerSourceDMap = Game->CurDMap;
                ParallaxLayers->LayerSourceScreen = RegionScreenOrigin();
            }
        }
        bool IsDifferent(int refCombos, int refCombosCount, int floorMap, int floorScreen)
        {
            bool differentScreen = (ParallaxLayers->LayerSourceDMap!=Game->CurDMap||ParallaxLayers->LayerSourceScreen!=RegionScreenOrigin());
            if(ParallaxLayers->TemporaryLayer)
                return differentScreen;
            if(floorMap>0)
            {
                if(ParallaxLayers->LowerFloorMap!=floorMap||ParallaxLayers->LowerFloorScreen!=floorScreen)
                    return true;
            }
            if(ParallaxLayers->RefCombos!=refCombos||ParallaxLayers->RefCombosCount!=refCombosCount)
                return true;
            return false;
        }
    }

    // Flags
    @Flag0("Use Screen Draws"),
    @FlagHelp0("If checked, the layer will use full screen draws, which are slower but show layers."),
    @Flag1("Transparent"),
    @FlagHelp1("If checked, the layer will use transparency."),
    @Flag2("Lower Floor"),
    @FlagHelp2("If checked, the map and screen properties will be ignored and instead the \"Floor Map\" and \"Floor Screen\" properties from the parent script will be used."),
    @Flag3("Lerp X"),
    @FlagHelp3("If checked, the layer's X position uses linear interpolation instead of using parallax VX and VY. This means that it will move from a starting position to an ending position as the viewport moves across the current region or the map as a whole. Being all the way on the left will put the layer at \"Lerp Min X\" while being all the way on the right will put it at \"Lerp Max X\" and any other position will put it somewhere in between."),
    @Flag4("Lerp Y"),
    @FlagHelp4("If checked, the layer's X position uses linear interpolation instead of using parallax VX and VY. This means that it will move from a starting position to an ending position as the viewport moves across the current region or the map as a whole. Being all the way at the top will put the layer at \"Lerp Min Y\" while being all the way at the bottom will put it at \"Lerp Max Y\" and any other position will put it somewhere in between."),
    @Flag5("Lerp X Uses Map Position"),
    @FlagHelp5("If checked and \"Lerp X\" is also checked, the lerped position is lerped based on Link's position on the map rather than his position in the current region."),
    @Flag6("Lerp Y Uses Map Position"),
    @FlagHelp6("If checked and \"Lerp Y\" is also checked, the lerped position is lerped based on Link's position on the map rather than his position in the current region."),
    @Flag7("No Wrap X"),
    @FlagHelp7("If checked, the layer will not wrap around on the X axis."),
    @Flag8("No Wrap Y"),
    @FlagHelp8("If checked, the layer will not wrap around on the Y axis."),
    @Flag9("Randomize Starting Position"),
    @FlagHelp9("If checked, he starting position of the layer will be randomzied based on its size."),
    @Flag10("Velocity Ignores Scale"),
    @FlagHelp10("If checked, the layer's movement will be the same no matter its scale."),
    @Flag11("Use Screens As Units"),
    @FlagHelp11("If checked, the following will use screen lengths instead of pixels for their units:\nStarting X, Starting Y, Width, Height, Lerp Min X, Lerp Max X, Lerp Min Y, Lerp Max Y"),
    @Flag12("Lerp Isn't Clamped"),
    @FlagHelp12("Normally lerp clamps the position of the layer to the upper and lower bounds. If Ref Min and Max settings are used, however, you can travel outside of these boundaries. This setting will allow the layer to travel outside of its normal boundaries when those settings are used."),
    @Flag13("Use Render Target"),
    @FlagHelp13("Instead of a screen, the layer will use one of the offscreen bitmaps using the RT_ constants from std.zh. The map argument will be ignored."),
    // InitD
    @InitD0("Layer"),
    @InitDHelp0("The layer this layer will be drawn to."),
    @InitD1("Source Map"),
    @InitDHelp1("The map for the screen used as a reference for this layer."),
    @InitD2("Source Screen"),
    @InitDHelp2("The screen used as a reference for this layer. Layer visuals will extend down from the top-left, referencing other screens if big enough."),
    @InitDType2("H"),
    @InitD3("VX"),
    @InitDHelp3("How much the layer moves along the X axis each frame."),
    @InitD4("VY"),
    @InitDHelp4("How much the layer moves along the Y axis each frame."),
    @InitD5("Parallax X"),
    @InitDHelp5("How much the layer moves along with the viewport on the X axis when scrolling."),
    @InitD6("Parallax Y"),
    @InitDHelp6("How much the layer moves along with the viewport on the Y axis when scrolling."),
    @InitD7("Scale"),
    @InitDHelp7("Scaling multiplier for the layer, defaults to 1 if left at 0."),
    // Attributes
    @Attribute0("Background Color"),
    @AttributeHelp0("Background color drawn behind the layer. 0 for transparent."),
    @Attribute1("Update Frames"),
    @AttributeHelp1("How frequently the layer should update, for animated layers. If 0, it's static."),
    @Attribute2("X Offset"),
    @AttributeHelp2("The starting X position for the layer. If lerp flags are set, this is added to the final position."),
    @Attribute3("Y Offset"),
    @AttributeHelp3("The starting Y position for the layer. If lerp flags are set, this is added to the final position."),
    @Attribute4("Width"),
    @AttributeHelp4("The width of the layer in pixels."),
    @Attribute5("Height"),
    @AttributeHelp5("The height of the layer in pixels."),
    @Attribute6("Lerp Min X"),
    @AttributeHelp6("If using a linear interpolation, this is the minimum X position of the layer."),
    @Attribute7("Lerp Max X"),
    @AttributeHelp7("If using a linear interpolation, this is the maximum X position of the layer."),
    @Attribute8("Lerp Min Y"),
    @AttributeHelp8("If using a linear interpolation, this is the minimum Y position of the layer."),
    @Attribute9("Lerp Max Y"),
    @AttributeHelp9("If using a linear interpolation, this is the maximum Y position of the layer."),
    @Attribute10("Lerp Edge Buffer"),
    @AttributeHelp10("If using default lerp positions, the layer's min and max positions will be kept this many pixels away from the edges of the region."),
    @Attribute11("Lerp Ref Min X"),
    @AttributeHelp11("Reference point for the minimum X value of a lerp. By default this is the left side of the region/map. This is only used if the flag \"Lerp X Uses Map Position\" is checked."),
    @Attribute12("Lerp Ref Max X"),
    @AttributeHelp12("Reference point for the maximum X value of a lerp. By default this is the right side of the region/map. This is only used if the flag \"Lerp X Uses Map Position\" is checked."),
    @Attribute13("Lerp Ref Min Y"),
    @AttributeHelp13("Reference point for the minimum Y value of a lerp. By default this is the top side of the region/map. This is only used if the flag \"Lerp Y Uses Map Position\" is checked."),
    @Attribute14("Lerp Ref Max Y"),
    @AttributeHelp14("Reference point for the maximum Y value of a lerp. By default this is the bottom side of the region/map. This is only used if the flag \"Lerp Y Uses Map Position\" is checked."),
    @Attribute15("Rotate Scroll"),
    @AttributeHelp15("If >0, the scroll effect will be rotated by this angle. Useful if you want things scrolling at a particular speed and angle without doing math."),
    @Attribute16("Rotate Parallax"),
    @AttributeHelp16("If >0, the parallax effect will be rotated by this angle. Will cause trippy looking background effects.")
    combodata script ParallaxDefinition
    {
        void run()
        {

        }
        void Load(combodata cd, ParallaxLayer lyr, int floorMap, int floorScreen)
        {
            int vw = 256;
            int vh = DMapViewportHeight();

            // Flags
            if(cd->Flags[FLAG_DEFINITION_USE_SCREEN_DRAWS])
                lyr->Flags |= PLF_IS_SCREEN;
            if(cd->Flags[FLAG_DEFINITION_TRANSPARENT])
                lyr->Flags |= PLF_TRANS;
            if(cd->Flags[FLAG_DEFINITION_LERP_X])
                lyr->Flags |= PLF_LERP_X;
            if(cd->Flags[FLAG_DEFINITION_LERP_Y])
                lyr->Flags |= PLF_LERP_Y;
            if(cd->Flags[FLAG_DEFINITION_NO_WRAP_X])
                lyr->Flags |= PLF_NO_WRAP_X;
            if(cd->Flags[FLAG_DEFINITION_NO_WRAP_Y])
                lyr->Flags |= PLF_NO_WRAP_Y;
            if(cd->Flags[FLAG_DEFINITION_LERP_X_USES_MAP_POS])
                lyr->Flags |= PLF_LERP_X_USES_MAP_POS;
            if(cd->Flags[FLAG_DEFINITION_LERP_Y_USES_MAP_POS])
                lyr->Flags |= PLF_LERP_Y_USES_MAP_POS;
            if(cd->Flags[FLAG_DEFINITION_VELOCITY_IGNORES_SCALE])
                lyr->Flags |= PLF_VELOCITY_IGNORES_SCALE;
            if(cd->Flags[FLAG_DEFINITION_LERP_ISNT_CLAMPED])
                lyr->Flags |= PLF_NO_CLAMP_LERP;
            if(cd->Flags[FLAG_DEFINITION_USE_RENDER_TARGET])
                lyr->Flags |= PLF_RENDER_TARGET;
            int scrMultX = 1;
            int scrMultY = 1;
            if(cd->Flags[FLAG_DEFINITION_UNITS_IN_SCREENS])
            {
                scrMultX = 256;
                scrMultY = 176;
            }
            WarnOnUnitScaleError(cd);
            // Scale
            lyr->Scale = cd->InitD[INITD_DEFINITION_SCALE];
            if(lyr->Scale<=0)
                lyr->Scale = 1;
            // Starting Position
            lyr->XOffset = -cd->Attributes[ATTRIBUTE_DEFINITION_STARTING_X]*scrMultX*lyr->Scale;
            lyr->YOffset = -cd->Attributes[ATTRIBUTE_DEFINITION_STARTING_Y]*scrMultY*lyr->Scale;
            lyr->X = lyr->XOffset;
            lyr->Y = lyr->YOffset;
            // Size Stuff
            if(cd->Flags[FLAG_DEFINITION_LOWER_FLOOR])
            {
                lyr->Flags |= PLF_IS_SCREEN;
                lyr->SourceMap = floorMap;
                lyr->SourceScreen = floorScreen;
                lyr->Width = Max(Region->Width, vw);
                lyr->Height = Max(Region->Height, vh);
            }
            else
            {
                lyr->SourceMap = cd->InitD[INITD_DEFINITION_SOURCE_MAP];
                lyr->SourceScreen = cd->InitD[INITD_DEFINITION_SOURCE_SCREEN];
                lyr->Width = cd->Attributes[ATTRIBUTE_DEFINITION_WIDTH]*scrMultX;
                lyr->Height = cd->Attributes[ATTRIBUTE_DEFINITION_HEIGHT]*scrMultY;
                if(!lyr->Width)
                    lyr->Width = 256;
                if(!lyr->Height)
                    lyr->Height = 176;
            }
            // Randomize position
            if(cd->Flags[FLAG_DEFINITION_RANDOMIZE_STARTING_POSITION])
            {
                lyr->X = Rand(lyr->Width);
                lyr->Y = Rand(lyr->Height);
            }
            // Lerp Stuff
            lyr->LerpMinX = -cd->Attributes[ATTRIBUTE_DEFINITION_LERP_MIN_X]*scrMultX;
            lyr->LerpMaxX = -cd->Attributes[ATTRIBUTE_DEFINITION_LERP_MAX_X]*scrMultX;
            lyr->LerpMinY = -cd->Attributes[ATTRIBUTE_DEFINITION_LERP_MIN_Y]*scrMultY;
            lyr->LerpMaxY = -cd->Attributes[ATTRIBUTE_DEFINITION_LERP_MAX_Y]*scrMultY;
            lyr->LerpEdgeBuffer = cd->Attributes[ATTRIBUTE_DEFINITION_LERP_EDGE_BUFFER];
            lyr->LerpRefMinX = cd->Attributes[ATTRIBUTE_DEFINITION_LERP_REF_MIN_X]*scrMultX;
            lyr->LerpRefMaxX = cd->Attributes[ATTRIBUTE_DEFINITION_LERP_REF_MAX_X]*scrMultX;
            lyr->LerpRefMinY = cd->Attributes[ATTRIBUTE_DEFINITION_LERP_REF_MIN_Y]*scrMultY;
            lyr->LerpRefMaxY = cd->Attributes[ATTRIBUTE_DEFINITION_LERP_REF_MAX_Y]*scrMultY;
            if(!lyr->LerpRefMaxX)
                lyr->LerpRefMaxX = 256*15;
            if(!lyr->LerpRefMaxY)
                lyr->LerpRefMaxY = 176*7;
            int edgeBuf = lyr->LerpEdgeBuffer/lyr->Scale;
            if(lyr->LerpMinX==lyr->LerpMaxX)
            {
                lyr->LerpMinX = -edgeBuf;
                lyr->LerpMaxX = (lyr->Width+edgeBuf)-(vw/lyr->Scale);
            }
            if(lyr->LerpMinY==lyr->LerpMaxY)
            {
                lyr->LerpMinY = -edgeBuf;
                lyr->LerpMaxY = (lyr->Height+edgeBuf)-(vh/lyr->Scale);
            }
            // Velocity
            lyr->VX = cd->InitD[INITD_DEFINITION_VX];
            lyr->VY = cd->InitD[INITD_DEFINITION_VY];
            lyr->ParallaxVX = cd->InitD[INITD_DEFINITION_PARALLAX_X];
            lyr->ParallaxVY = cd->InitD[INITD_DEFINITION_PARALLAX_Y];
            lyr->RotateScroll = cd->Attributes[ATTRIBUTE_DEFINITION_ROTATE_SCROLL];
            lyr->RotateParallax = cd->Attributes[ATTRIBUTE_DEFINITION_ROTATE_PARALLAX];
            // Everything else
            lyr->BGColor = cd->Attributes[ATTRIBUTE_DEFINITION_BG_COLOR];
            lyr->UpdateFreq = cd->Attributes[ATTRIBUTE_DEFINITION_UPDATE_FRAMES];
            lyr->Layer = cd->InitD[INITD_DEFINITION_LAYER];
        }
        void WarnOnUnitScaleError(combodata cd)
        {
            if(!WARN_ON_UNIT_SCALE)
                return;

            int attribs[] = {
                ATTRIBUTE_DEFINITION_STARTING_X, ATTRIBUTE_DEFINITION_STARTING_Y, ATTRIBUTE_DEFINITION_WIDTH, ATTRIBUTE_DEFINITION_HEIGHT,
                ATTRIBUTE_DEFINITION_LERP_MIN_X, ATTRIBUTE_DEFINITION_LERP_MAX_X, ATTRIBUTE_DEFINITION_LERP_MIN_Y, ATTRIBUTE_DEFINITION_LERP_MAX_Y
            };
            int sz = SizeOfArray(attribs);
            if(cd->Flags[FLAG_DEFINITION_UNITS_IN_SCREENS])
            {
                for(int i=0; i<sz; ++i)
                {
                    if(Abs(cd->Attributes[attribs[i]])>0x7F)
                    {
                        printf("WARNING: Values on combo %d are higher than unit scale would indicate. The flag \"Use Screens As Units\" is set, so numbers are expected to be small, representing screen lengths. If this error is unhelpful, you can disable it by setting WARN_ON_UNIT_SCALE to false.\n", cd->ID);
                    }
                }
            }
            else
            {
                bool nonZero;
                for(int i=0; i<sz; ++i)
                {
                    if(Abs(cd->Attributes[attribs[i]])>0xF)
                    {
                        break;
                    }
                    if(cd->Attributes[attribs[i]]!=0)
                        nonZero = true;
                }
                if(nonZero)
                    printf("WARNING: Values on combo %d are lower than unit scale would indicate. The flag \"Use Screens As Units\" is unset, so numbers are expected to be large, representing pixel lengths. If this error is unhelpful, you can disable it by setting WARN_ON_UNIT_SCALE to false.\n", cd->ID);
            }
        }
    }
}


