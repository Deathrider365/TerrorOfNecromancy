#option SHORT_CIRCUIT on
#option BINARY_32BIT off
#option HEADER_GUARD on

namespace WaterPaths {
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
            //if screen has a FL_FLAMING play sound 13
         
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
}
