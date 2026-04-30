//~~~~~~~~~~~~~~~~~~~~~The Terror of Necromancy Namespaces~~~~~~~~~~~~~~~~~~~//

namespace EnemyNamespace {
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

   void deathAnimation(npc n, int deathSound) {
      n->Immortal = true;
      n->CollDetection = false;
      n->Stun = 9999;

      int baseX = n->X + n->DrawXOffset;
      int baseY = (n->Y + n->DrawYOffset) - (n->Z + n->DrawZOffset);

      Audio->PlaySound(deathSound);

      for (int i = 0; i < 45; i++) {
         unless(i % 3) {
            lweapon explosion = Screen->CreateLWeapon(LW_BOMBBLAST);
            explosion->X = baseX + RandGen->Rand(16 * n->TileWidth) - 8;
            explosion->Y = baseY + RandGen->Rand(16 * n->TileHeight) - 8;
            explosion->CollDetection = false;
         }
         Waitframes(5);
      }

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
      if (n->HP <= 0)
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