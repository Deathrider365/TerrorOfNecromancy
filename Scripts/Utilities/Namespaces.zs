//~~~~~~~~~~~~~~~~~~~~~The Terror of Necromancy Namespaces~~~~~~~~~~~~~~~~~~~//

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

   void EnemyWaitframe(npc n, int data, bool deathAnim) {
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

   void EnemyWaitframe(npc n, int data, int frames) {
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

   void doWalk(npc n, int rand, int homing, int step, bool flying = false, bool fourDir = true) {
      const int ONE_IN_N = 1000;

      if (rand >= RandGen->Rand(ONE_IN_N - 1)) {
         int attemptCounter = 0;

         do {
            n->Dir = RandGen->Rand(3);
         }
         until(n->CanMove(n->Dir, 1, flying ? SPW_FLOATER : SPW_NONE) || ++attemptCounter > 500);
      }
      else if (homing >= RandGen->Rand(ONE_IN_N - 1)) {
         if (fourDir)
            n->Dir = RadianAngleDir4(TurnTowards(n->X, n->Y, Hero->X, Hero->Y, 0, 1));
         else
            n->Dir = RadianAngleDir8(TurnTowards(n->X, n->Y, Hero->X, Hero->Y, 0, 1));
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

   // start CONSTANTS
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
   // end

   DEFINE ATTBU_FLUIDPATH = 0;
   DEFINE VAL_BARRIER = -1;

   @Author("EmilyV99") dmapdata script WaterPaths {
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
            unless(sources[layer] % 1 && sources[layer] > 1) continue;

            Fluid fluid = <Fluid>((sources[layer] % 1) / 1L);

            unless(fluid > 0 && fluid < FL_SZ) continue;

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
               }
               else
                  layer2 = layer;
            }
         }

         int screen = -1;

         while (true) {
            // if screen has a FL_FLAMING play sound 117 or 160

            if (screen != Game->GetCurScreen() || pathStates[UPDATE_PATHS]) {
               screen = Game->GetCurScreen();
               pathStates[UPDATE_PATHS] = false;

               mapdata currentMapMapata = Game->LoadMapData(Game->GetCurMap(), Game->GetCurScreen());

               mapdata currentMapLayer1 = Emily::loadLayer(currentMapMapata, layer1);
               mapdata currentMapLayer2 = Emily::loadLayer(currentMapMapata, layer2);
               mapdata templateLeft, templateRight, templateUp, templateDown;

               unless(Game->GetCurScreen() < 0x10) templateUp = Emily::loadLayer(Game->LoadMapData(Game->GetCurMap(), Game->GetCurScreen() - 0x10), layer1);
               unless(Game->GetCurScreen() >= 0x70) templateDown = Emily::loadLayer(Game->LoadMapData(Game->GetCurMap(), Game->GetCurScreen() + 0x10), layer1);
               if (Game->GetCurScreen() % 0x10)
                  templateLeft = Emily::loadLayer(Game->LoadMapData(Game->GetCurMap(), Game->GetCurScreen() - 1), layer1);
               unless(Game->GetCurScreen() % 0x10 == 0xF) templateRight = Emily::loadLayer(Game->LoadMapData(Game->GetCurMap(), Game->GetCurScreen() + 1), layer1);

               mapdata layer1Template = Game->LoadTempScreen(layer1);
               mapdata layer2Template = Game->LoadTempScreen(layer2);

               for (int pass = 0; pass < PASS_COUNT; ++pass) {
                  for (int combo = 0; combo < 176; ++combo) {
                     if (currentMapLayer1->ComboT[combo] != CT_FLUID)
                        continue;

                     combodata comboData = Game->LoadComboData(currentMapLayer1->ComboD[combo]);
                     int flag = comboData->Attributes[ATTBU_FLUIDPATH];

                     switch (pass) {
                        case PASS_LIQUID: unless(flag > 0) continue; break;
                        case PASS_BARRIERS: unless(flag == VAL_BARRIER) continue; break;
                     }

                     int up, down, left, right;

                     unless(combo < 0x10) up = Game->LoadComboData(currentMapLayer1->ComboD[combo - 0x10])->Attributes[ATTBU_FLUIDPATH];
                     else if (templateUp) up = Game->LoadComboData(templateUp->ComboD[combo + 0x90])->Attributes[ATTBU_FLUIDPATH];

                     unless(combo >= 0xA0) down = Game->LoadComboData(currentMapLayer1->ComboD[combo + 0x10])->Attributes[ATTBU_FLUIDPATH];
                     else if (templateDown) down = Game->LoadComboData(templateDown->ComboD[combo - 0x90])->Attributes[ATTBU_FLUIDPATH];

                     if (combo % 0x10)
                        left = Game->LoadComboData(currentMapLayer1->ComboD[combo - 1])->Attributes[ATTBU_FLUIDPATH];
                     else if (templateLeft)
                        left = Game->LoadComboData(templateLeft->ComboD[combo + 0xF])->Attributes[ATTBU_FLUIDPATH];

                     unless(combo % 0x10 == 0xF) right = Game->LoadComboData(currentMapLayer1->ComboD[combo + 1])->Attributes[ATTBU_FLUIDPATH];
                     else if (templateRight) right = Game->LoadComboData(templateRight->ComboD[combo - 0xF])->Attributes[ATTBU_FLUIDPATH];

                     // Standard fluid
                     if (flag > 0) {
                        int cmb = -1;

                        // all same
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

                           unless(isBarrierFlag(upperLeft, flag) || !(isBarrierFlag(upperRight, flag) && isBarrierFlag(lowerLeft, flag) && isBarrierFlag(lowerRight, flag))) cmb = CMB_TL_INNER;
                           else unless(isBarrierFlag(upperRight, flag) || !(isBarrierFlag(upperLeft, flag) && isBarrierFlag(lowerLeft, flag) && isBarrierFlag(lowerRight, flag))) cmb = CMB_TR_INNER;
                           else unless(isBarrierFlag(lowerLeft, flag) || !(isBarrierFlag(upperRight, flag) && isBarrierFlag(upperLeft, flag) && isBarrierFlag(lowerRight, flag))) cmb = CMB_BL_INNER;
                           else unless(isBarrierFlag(lowerRight, flag) || !(isBarrierFlag(upperRight, flag) && isBarrierFlag(lowerLeft, flag) && isBarrierFlag(upperLeft, flag))) cmb = CMB_BR_INNER;
                           else cmb = 0;
                        }
                        // up
                        else if (isBarrierFlag(up, flag)) {
                           // upleft
                           if (isBarrierFlag(left, flag)) {
                              // upleft, notdown
                              unless(isBarrierFlag(down, flag)) {
                                 // upleftright, notdown
                                 if (isBarrierFlag(right, flag))
                                    cmb = CMB_BOTTOM;
                                 // upleft, notrightdown
                                 else
                                    cmb = CMB_BR_OUTER;
                              }
                              // upleftdown, notright
                              else unless(isBarrierFlag(right, flag)) cmb = CMB_RIGHT;
                           }
                           // up not-left
                           else {
                              // upright, notleft
                              if (isBarrierFlag(right, flag)) {
                                 // upright, notdownleft
                                 unless(isBarrierFlag(down, flag)) cmb = CMB_BL_OUTER;
                                 // uprightdown, notleft
                                 else cmb = CMB_LEFT;
                              }
                           }
                        }
                        // notup
                        else {
                           // right, notup
                           if (isBarrierFlag(right, flag)) {
                              // rightdown, notup
                              if (isBarrierFlag(down, flag)) {
                                 // rightdownleft, notup
                                 if (isBarrierFlag(left, flag))
                                    cmb = CMB_TOP;
                                 // rightdown, notleftup
                                 else
                                    cmb = CMB_TL_OUTER;
                              }
                           }
                           // notrightup
                           else {
                              // down, notrightup
                              if (isBarrierFlag(down, flag))
                                 // leftdown, notrightup
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
                        if (up > 0 && down > 0 && left < 1 && right < 1) {
                           flowing = getConnection(Game->GetCurLevel(), up, down);

                           if (flowing)
                              flowpath = up;

                           if (left == VAL_BARRIER) {
                              // Center
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

                           if (up == VAL_BARRIER) {
                              // Center
                              if (down == VAL_BARRIER) {
                                 if (flowing)
                                    cmb = 0;
                                 else {
                                    cmb = CMB_BARRIER_VERT;

                                    if (CMB_SOLID_INVIS) {
                                       if (combo % 0x10) {
                                          layer1Template->ComboD[combo - 1] = getCombo(getFluid(left), true);
                                          layer2Template->ComboD[combo - 1] = CMB_SOLID_INVIS;
                                       }
                                       if (combo % 0x10 < 0x0F) {
                                          layer1Template->ComboD[combo + 1] = getCombo(getFluid(right), true);
                                          layer2Template->ComboD[combo + 1] = CMB_SOLID_INVIS;
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
                           // Down
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
      switch (fluid) {
         case FL_EMPTY: return COMBO_FLUID_EMPTY;
         case FL_PURPLE: return solid ? COMBO_SOLID_PURPLE : COMBO_NON_SOLID_PURPLE;
         case FL_FLAMING: return solid ? COMBO_SOLID_FLAMING : COMBO_NON_SOLID_FLAMING;
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

      if (path1 == path2)
         return; // Can't connect to self
      --path1;
      --path2; // From 1-indexed to 0-indexed

      if (connect) {
         fluidConnections[level * 512 + path1] |= 1L << path2;
         fluidConnections[level * 512 + path2] |= 1L << path1;
      }
      else {
         // clang-format off
         fluidConnections[level * 512 + path1] ~= 1L << path2;
         fluidConnections[level * 512 + path2] ~= 1L << path1;
         // clang-format on
      }
   }

   void updateFluidFlow() {
      memcpy(pathStates, 0, pathStates, MAX_PATHS, MAX_PATHS); // Set to default sources

      DEFINE MAX_PATH_PAIRS = MAX_PATHS * (MAX_PATHS - 1) + 1;
      int pathPairs1[MAX_PATH_PAIRS];
      int pathPairs2[MAX_PATH_PAIRS];

      // Cache the pairs of connected paths, so they don't need to be repeatedly calculated
      int index = 0;

      for (int path1 = 0; path1 < MAX_PATHS; ++path1) {
         int connection = getConnection(Game->GetCurLevel(), path1 + 1);

         unless(connection) continue;

         for (int path2 = path1 + 1; path2 < MAX_PATHS; ++path2) {
            unless(connection & (1L << path2)) continue;

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

      // Special fluid mixing logic can occur here, for now the higher value simply flows
      if (fluid1 < fluid2) {
         if (WP_DEBUG)
            printf("%d<%d, setting [%d] = %d\n", fluid1, fluid2, path1, fluid2);

         pathStates[path1] = fluid2;
      }
      else {
         if (WP_DEBUG)
            printf("%d>%d, setting [%d] = %d\n", fluid1, fluid2, path2, fluid1);

         pathStates[path2] = fluid1;
      }

      return true;
   }

   bool isBarrierFlag(int fluid, int barrierFlag) {
      return fluid == VAL_BARRIER || fluid == barrierFlag;
   }

   @Author("EmilyV99") ffc script SecretsTriggersWaterPaths {
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

         until(Screen->State[ST_SECRET]) Waitframe();

         if (WP_DEBUG)
            printf("STWP: Secrets Triggered. Setting connection %d,%d\n", path1, pathActivated);

         setConnection(Game->GetCurLevel(), path1, pathActivated, true);

         updateFluidFlow();
      }
   }

   @Author("EmilyV99") ffc script TorchLight {
      using namespace WaterPathsNamespace;

      void run(int litCombo, int path) {
         until(getFluid(path) == FL_FLAMING) Waitframe();

         this->Data = litCombo;
      }
   }

   @Author("EmilyV99") ffc script ActivateTorches {
      using namespace WaterPathsNamespace;

      void run(int p1, int p2, int p3, int p4) {
         if (Screen->State[ST_SECRET])
            return;

         until(getFluid(p1) == FL_FLAMING && getFluid(p2) == FL_FLAMING && getFluid(p3) == FL_FLAMING && getFluid(p4) == FL_FLAMING) Waitframe();

         Screen->TriggerSecrets();
         Screen->State[ST_SECRET] = true;
         Audio->PlaySound(SFX_SECRET);
      }
   }

   @Author("EmilyV99") ffc script TorchFirePaths {
      using namespace WaterPathsNamespace;

      void run(int layers) {
         while (true) {
            for (int q = Screen->NumLWeapons(); q > 0; --q) {
               lweapon wep = Screen->LoadLWeapon(q);

               unless(wep->Type == LW_FIRE && GetHighestLevelItemOwned(IC_CANDLE) != 158) continue;

               int l1, l2;

               for (int q = 6; q >= 0; --q) {
                  if (layers & (1b << q)) {
                     if (l2) {
                        l1 = q;
                        break;
                     }
                     else
                        l2 = q;
                  }
               }

               mapdata template = Game->LoadMapData(Game->GetCurMap(), Game->GetCurScreen());
               mapdata t1 = Emily::loadLayer(template, l1), t2 = Emily::loadLayer(template, l2);
               int cmb[4] = {ComboAt(wep->X, wep->Y), ComboAt(wep->X + 15, wep->Y), ComboAt(wep->X, wep->Y + 15), ComboAt(wep->X + 15, wep->Y + 15)};

               for (int p = 0; p < 4; ++p) {
                  combodata cd = Game->LoadComboData(t1->ComboD[cmb[p]]);

                  if (cd->Type == CT_FLUID) {
                     int flag = cd->Attributes[ATTBU_FLUIDPATH];

                     if (flag > 0) {
                        Fluid f = getFluid(flag);

                        if (f == FL_PURPLE)
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

         // Cache the pairs of connected paths
         int ind = 0;

         for (int q = 0; q < MAX_PATHS; ++q) {
            int c = getConnection(Game->GetCurLevel(), q + 1);

            unless(c) continue;

            for (int p = q + 1; p < MAX_PATHS; ++p) {
               unless(c & (1L << p)) continue;
               v1[ind] = q;
               v2[ind++] = p;
            }
         }

         v1[ind] = -1;

         bool isConnected[MAX_PATHS];
         bool didSomething;

         isConnected[path - 1] = true;

         while (didSomething) {
            didSomething = false;

            for (int q = 0; v1[q] > -1; ++q) {
               // clang-format off
               if (isConnected[v1[q]] ^^ isConnected[v2[q]]) {
                  // clang-format on
                  isConnected[v1[q]] = true;
                  isConnected[v2[q]] = true;
                  didSomething = true;
               }
            }
         }

         for (int q = 0; q < MAX_PATHS; ++q)
            if (isConnected[q])
               if (getSource(q + 1) == FL_PURPLE)
                  setConnection(Game->GetCurLevel(), q + 1, connectTo, true);

         updateFluidFlow();
      }
   }
} // namespace WaterPathsNamespace

namespace EmilyMap {
   CONFIG COLOR_NULL = 0x0F;
   CONFIG COLOR_FRAME = 0x01;
   CONFIG COLOR_CUR_ROOM = 0x66;
   CONFIG CUR_ROOM_BORDER_THICKNESS = 4;
   CONFIG INPUT_REPEAT_TIME = 3;
   CONFIG ZOOM_INPUT_REPEAT_TIME = 12;
   CONFIG MAP_PUSH_PIXELS = 16;
   CONFIGB ALLOW_COMBO_ANIMS = false;
   DEFINE MAP_PUSH_VAL = MAP_PUSH_PIXELS / 8;

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
               if (layer2) {
                  layer1 = q;
                  break;
               }
               else
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

            unless(mapData->State[ST_VISITED]) null = true;

            unless(mapData->Valid & 1b) null = true;

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
                  unless(mapData->FFCData[freeformCombo]) continue;

                  if (mapData->FFCFlags[freeformCombo] & (FFCBF_CHANGER | FFCBF_ETHEREAL | FFCBF_LENSVIS))
                     continue;

                  // Skip drawing overlays
                  if (mapData->FFCFlags[freeformCombo] & FFCBF_OVERLAY)
                     continue;

                  tmp->DrawCombo(7, mapData->FFCX[freeformCombo], mapData->FFCY[freeformCombo], mapData->FFCData[freeformCombo], mapData->FFCTileWidth[freeformCombo], mapData->FFCTileHeight[freeformCombo], mapData->FFCCSet[freeformCombo], -1, -1, 0, 0, 0, 0, FLIP_NONE, true, (mapData->FFCFlags[freeformCombo] & FFCBF_TRANS) ? OP_TRANS : OP_OPAQUE);
               }

               unless(bg2) {
                  tmp->DrawLayer(7, this->Map, screen, 2, 0, 0, 0, OP_OPAQUE);
                  handlePaths(tmp, mapData, 2, layer1, layer2);
               }
               unless(bg3) {
                  tmp->DrawLayer(7, this->Map, screen, 3, 0, 0, 0, OP_OPAQUE);
                  handlePaths(tmp, mapData, 3, layer1, layer2);
               }

               tmp->DrawLayer(7, this->Map, screen, 4, 0, 0, 0, OP_OPAQUE);
               handlePaths(tmp, mapData, 4, layer1, layer2);
               tmp->DrawLayer(7, this->Map, screen, 5, 0, 0, 0, OP_OPAQUE);
               handlePaths(tmp, mapData, 5, layer1, layer2);

               // overlay ffcs
               for (int freeformCombo = 1; freeformCombo < 33; ++freeformCombo) {
                  unless(mapData->FFCData[freeformCombo]) continue;

                  if (mapData->FFCFlags[freeformCombo] & (FFCBF_CHANGER | FFCBF_ETHEREAL | FFCBF_LENSVIS))
                     continue;

                  unless(mapData->FFCFlags[freeformCombo] & (1b << FFCF_OVERLAY)) // Only draw overlays
                      continue;

                  tmp->DrawCombo(7, mapData->FFCX[freeformCombo], mapData->FFCY[freeformCombo], mapData->FFCData[freeformCombo], mapData->FFCTileWidth[freeformCombo], mapData->FFCTileHeight[freeformCombo], mapData->FFCCSet[freeformCombo], -1, -1, 0, 0, 0, 0, FLIP_NONE, true, (mapData->FFCFlags[freeformCombo] & FFCBF_TRANS) ? OP_TRANS : OP_OPAQUE);
               } // end

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

   @Author("EmilyV99") dmapdata script Map {
      void run(bool lockPalette) {
         DEFINE WIDTH = 256 * 16;
         DEFINE HEIGHT = 176 * 8;

         bitmap bmp = create(WIDTH, HEIGHT);
         bitmap currentScreen = create(256, 168);
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
            int moveMultiplier = minZoom / (minZoom - zoom + 1);

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

            unless(pressedUp || pressedDown || pressedLeft || pressedRight) pressed = false;

            if (pressed)
               inputClock = 1;
            if (zoomed)
               zoomInputClock = 1;

            if (isOverworld) {
               x = VBound(x, 128 + 112, -128 - 112); // VBound(x, (usableWidth)/2-256, (-usableWidth)/2-256);
               y = VBound(y, 112 + 94.5, 58.5);      // VBound(y, (HEIGHT)/2-224, (-HEIGHT)/2-224);
            }
            else {
               x = VBound(x, 128 + 96, -128 - 96); // VBound(x, (usableWidth)/2-256, (-usableWidth)/2-256);
               y = VBound(y, 112 + 77, -112 + 5);  // VBound(y, (HEIGHT)/2-224, (-HEIGHT)/2-224);
            }

            int tx = (256 + ((x - 256) * zoomMultiplier)) / 2;
            int ty = ((224 + ((y - 224) * zoomMultiplier)) / 2) - 28;

            Screen->Rectangle(7, 0, -56, 255, 175, COLOR_NULL, 1, 0, 0, 0, true, OP_OPAQUE);
            Screen->Rectangle(7, tx - 1, ty - 1, tx + usableWidth / zoom, ty + HEIGHT / zoom, COLOR_FRAME, 1, 0, 0, 0, false, OP_OPAQUE);

            bmp->Blit(7, RT_SCREEN, 0, 0, usableWidth, HEIGHT, tx, ty, usableWidth / zoom, HEIGHT / zoom, 0, 0, 0, BITDX_NORMAL, 0, false);

            Waitframe();

            if (ALLOW_COMBO_ANIMS)
               generateMap(bmp, this, lockPalette, currentScreen);
         }
         until(Input->Press[CB_MAP] || Input->Press[CB_START]);

         Input->Press[CB_MAP] = false;
         Input->Button[CB_MAP] = false;
         Link->InputStart = false;
         Link->InputStart = false;

         bmp->Free();
      }
   }

   bool isBG(bool l3, mapdata m, dmapdata dm) {
      // clang-format off
      if (l3)
         return (GetMapscreenFlag(m, MSF_LAYER3BG) ^^ dm->Flagset[DMFS_LAYER3ISBACKGROUND]);
      else
         return (GetMapscreenFlag(m, MSF_LAYER2BG) ^^ dm->Flagset[DMFS_LAYER2ISBACKGROUND]);
      // clang-format on
   }

   void handlePaths(bitmap bmp, mapdata template, int layer, int layer1, int layer2) {
      using namespace WaterPathsNamespace;

      if (layer != layer1 && layer != layer2)
         return;

      mapdata currentMapLayer1 = Emily::loadLayer(template, layer1);
      mapdata currentMapLayer2 = Emily::loadLayer(template, layer2);
      mapdata templateLeft, templateRight, templateUp, templateDown;

      unless(template->Screen < 0x10) templateUp = Emily::loadLayer(Game->LoadMapData(template->Map, template->Screen - 0x10), layer1);
      unless(template->Screen >= 0x70) templateDown = Emily::loadLayer(Game->LoadMapData(template->Map, template->Screen + 0x10), layer1);
      if (template->Screen % 0x10)
         templateLeft = Emily::loadLayer(Game->LoadMapData(template->Map, template->Screen - 1), layer1);
      unless(template->Screen % 0x10 == 0xF) templateRight = Emily::loadLayer(Game->LoadMapData(template->Map, template->Screen + 1), layer1);

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

            switch (pass) {
               case PASS_LIQUID: unless(flag > 0) continue; break;
               case PASS_BARRIERS: unless(flag == VAL_BARRIER) continue; break;
            }

            int up, down, left, right;

            unless(combo < 0x10) up = Game->LoadComboData(currentMapLayer1->ComboD[combo - 0x10])->Attributes[ATTBU_FLUIDPATH];
            else if (templateUp) up = Game->LoadComboData(templateUp->ComboD[combo + 0x90])->Attributes[ATTBU_FLUIDPATH];

            unless(combo >= 0xA0) down = Game->LoadComboData(currentMapLayer1->ComboD[combo + 0x10])->Attributes[ATTBU_FLUIDPATH];
            else if (templateDown) down = Game->LoadComboData(templateDown->ComboD[combo - 0x90])->Attributes[ATTBU_FLUIDPATH];

            if (combo % 0x10)
               left = Game->LoadComboData(currentMapLayer1->ComboD[combo - 1])->Attributes[ATTBU_FLUIDPATH];
            else if (templateLeft)
               left = Game->LoadComboData(templateLeft->ComboD[combo + 0xF])->Attributes[ATTBU_FLUIDPATH];

            unless(combo % 0x10 == 0xF) right = Game->LoadComboData(currentMapLayer1->ComboD[combo + 1])->Attributes[ATTBU_FLUIDPATH];
            else if (templateRight) right = Game->LoadComboData(templateRight->ComboD[combo - 0xF])->Attributes[ATTBU_FLUIDPATH];

            // Standard fluid
            if (flag > 0) {
               int cmb = -1;

               // all same
               if (isBarrierFlag(up, flag) && isBarrierFlag(down, flag) && isBarrierFlag(left, flag) && isBarrierFlag(right, flag)) {
                  // start Inner Corners
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

                  unless(isBarrierFlag(upperLeft, flag) || !(isBarrierFlag(upperRight, flag) && isBarrierFlag(lowerLeft, flag) && isBarrierFlag(lowerRight, flag))) cmb = CMB_TL_INNER;
                  else unless(isBarrierFlag(upperRight, flag) || !(isBarrierFlag(upperLeft, flag) && isBarrierFlag(lowerLeft, flag) && isBarrierFlag(lowerRight, flag))) cmb = CMB_TR_INNER;
                  else unless(isBarrierFlag(lowerLeft, flag) || !(isBarrierFlag(upperRight, flag) && isBarrierFlag(upperLeft, flag) && isBarrierFlag(lowerRight, flag))) cmb = CMB_BL_INNER;
                  else unless(isBarrierFlag(lowerRight, flag) || !(isBarrierFlag(upperRight, flag) && isBarrierFlag(lowerLeft, flag) && isBarrierFlag(upperLeft, flag))) cmb = CMB_BR_INNER;
                  else cmb = 0;
               }
               // up
               else if (isBarrierFlag(up, flag)) {
                  // upleft
                  if (isBarrierFlag(left, flag)) {
                     // upleft, notdown
                     unless(isBarrierFlag(down, flag)) {
                        // upleftright, notdown
                        if (isBarrierFlag(right, flag))
                           cmb = CMB_BOTTOM;
                        // upleft, notrightdown
                        else
                           cmb = CMB_BR_OUTER;
                     }
                     // upleftdown, notright
                     else unless(isBarrierFlag(right, flag)) cmb = CMB_RIGHT;
                  }
                  // up not-left
                  else {
                     // upright, notleft
                     if (isBarrierFlag(right, flag)) {
                        // upright, notdownleft
                        unless(isBarrierFlag(down, flag)) cmb = CMB_BL_OUTER;
                        // uprightdown, notleft
                        else cmb = CMB_LEFT;
                     }
                  }
               }
               // notup
               else {
                  // right, notup
                  if (isBarrierFlag(right, flag)) {
                     // rightdown, notup
                     if (isBarrierFlag(down, flag)) {
                        // rightdownleft, notup
                        if (isBarrierFlag(left, flag))
                           cmb = CMB_TOP;
                        // rightdown, notleftup
                        else
                           cmb = CMB_TL_OUTER;
                     }
                  }
                  // notrightup
                  else {
                     // down, notrightup
                     if (isBarrierFlag(down, flag))
                        // leftdown, notrightup
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

                  if (up == VAL_BARRIER) {
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
} // namespace EmilyMap
