///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~~~~~~~~~~ Screendata & Dmapdata ~~~~~~~~~~~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

@Author ("EmilyV99")
screendata script OverheadTransparency {
   void run(int layers) {
      while(true) {
         for (int l = 1; l < 7; ++l) {
            unless(layers & (1b << (l - 1)))
               continue;
               
            mapdata mapData = Game->LoadTempScreen(l);
            
            int combos[] = {
               mapData->ComboD[ComboAt(Hero->X, Hero->Y)], 
               mapData->ComboD[ComboAt(Hero->X + 15, Hero->Y)], 
               mapData->ComboD[ComboAt(Hero->X, Hero->Y + 15)],
               mapData->ComboD[ComboAt(Hero->X + 15, Hero->Y + 15)]
            };
            
            Screen->LayerOpacity[l] = 255;
            
            for (int c = 0; c < 4; ++c)
               if (combos[c]){
                  Screen->LayerOpacity[l] = OP_TRANS;
                  break;
               }
         }
         
         Waitframe();
      }	
   }
}

@Author ("EmilyV99")
screendata script RadialTransparency {
   void run(int layers, int radius) {			
      mapdata mapData[6];
      
      for (int l = 1; l < 6; ++l) {
         unless(layers & (1b << (l - 1)))
            continue;
         
         Screen->LayerInvisible[l] = true;
         
         unless(overheadBitmaps[l]->isValid())
            overheadBitmaps[l] = create(256, 176);
       
         mapData[l] = Game->LoadTempScreen(l);
      }
      
      while(true) {
         for (int l = 1; l < 6; ++l) {
            unless(layers & (1b << (l - 1)))
               continue;
            
            overheadBitmaps[l]->Clear(0);
            
            for (int q = 0; q < 176; ++q)
               overheadBitmaps[l]->FastCombo(l, ComboX(q), ComboY(q), mapData[l]->ComboD[q], mapData[l]->ComboC[q], OP_OPAQUE);
            
            overheadBitmaps[l]->Circle(l, Hero->X + 8, Hero->Y + 8, radius, 0, 1, 0, 0, 0, true, OP_OPAQUE);
            
            for (int q = 0; q < 176; ++q)
               Screen->FastCombo(l, ComboX(q), ComboY(q), mapData[l]->ComboD[q], mapData[l]->ComboC[q], OP_TRANS);
               
            overheadBitmaps[l]->Blit(l, -1, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
         }
         
         Waitframe();
         
         if (disableTrans) {
            for (int l = 1; l < 6; ++l) {
               unless(layers & (1b << (l - 1)))
                  continue;
               
               Screen->LayerInvisible[l] = false;
            }
            
            while (disableTrans) 
               Waitframe();
         }
         
         if (HeroIsScrolling())
            for (int l = 1; l < 6; ++l) {
               unless(layers & (1b << (l - 1)))
                  continue;
               
               Screen->LayerInvisible[l] = false;
            }
         else
            for (int l = 1; l < 6; ++l) {
               unless(layers & (1b << (l - 1)))
                  continue;
               
               Screen->LayerInvisible[l] = true;
            }
      }	
   }
}

@Author ("EmilyV99, Dimi")
dmapdata script DarkRegion {	
   void run(int radius, int itemClass, int layer, int torchPower) {
      unless(darknessBitmap->isValid())
         darknessBitmap = create(256 * 3, 176 * 4.5); 
      else
         recreate(darknessBitmap, 256 * 3, 176 * 4.5);
      
      int animationCounter;
      
      while(true) {
         Waitdraw();
      
         int itemId = GetHighestLevelItemOwned(itemClass);
         itemdata itemData = itemId < 0 ? NULL : Game->LoadItemData(itemId);
         int power = itemData ? itemData->Attributes[9] : 0;
         int mode = 0;
         
         if (itemData) 
            mode = itemData->Flags[14] ? BITDX_TRANS : 0;
         
         animationCounter += 2;
         animationCounter %= 360;
         
         for (int i = layer; i >= 0; --i) {
            darknessBitmap->ClearToColor(layer, C_BLACK);
            
            if (power)
               darknessBitmap->Circle(layer, Hero->X + 8 + 256, Hero->Y + 8 + 176, (radius * power) + VectorY(4, animationCounter) + (i * 4), mode, 1, 0, 0, 0, true, OP_OPAQUE);
            
            if (torchPower) {
               for (int xPos = 0; xPos < 256; xPos += 16) {
                  for (int yPos = 0; yPos < 176; yPos += 16) {
                     int pos = ComboAt(xPos, yPos);
                     int comboT = Screen->ComboT[pos]; 
                     
                     for (int lightLayer = 1; lightLayer < 3; ++lightLayer)
                        if (Screen->LayerMap[lightLayer]) {
                           mapdata mapData = Game->LoadTempScreen(lightLayer);
                           
                           if (mapData->ComboD[pos])
                              comboT = mapData->ComboT[pos];
                        }
                     
                     if (comboT == CT_SCRIPT_TORCH)
                        darknessBitmap->Circle(layer, xPos + 8 + 256, yPos + 8 + 176, (radius * torchPower) + VectorY(4, animationCounter) + (i * 4), mode, 1, 0, 0, 0, true, OP_OPAQUE);
                  }
               }
            }
            
            darknessBitmap->Blit(layer, -2, 256 - Game->Scrolling[SCROLL_NX], 176 - Game->Scrolling[SCROLL_NY], 256, 176, 0, 0, 256, 176, 0, 0, 0, 1, 0, true);
         }
         
         Waitframe();
      }
   }
}

@Author("Deathrider365")
dmapdata script HeatedRoom {
   void run(int armorLevel, int damage) {
      while (true) {
         if (GetHighestLevelItemOwned(IC_RING) < armorLevel) {
            if (gameframe % 60 == 0 && Hero->X > 0 && Hero->Y > 0 && Hero->X < 256 && Hero->Y < 176) {
               Hero->HP -= damage;
               Audio->PlaySound(Choose(SFX_HERO_HURT_1, SFX_HERO_HURT_2, SFX_HERO_HURT_3));
            }
         }
         
         Waitframe();
      }
   }
}
