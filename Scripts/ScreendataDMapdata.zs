//~~~~~~~~~~~~~~~~~~~~~~~~~~ Screendata & Dmapdata ~~~~~~~~~~~~~~~~~~~~~~~~~~//

// clang-format off
@Author ("EmilyV99")
screendata script OverheadTransparency {
   // clang-format on

   void run(int layers) {
      while (true) {
         for (int l = 1; l < 7; ++l) {
            unless(layers & (1b << (l - 1))) continue;

            mapdata mapData = Game->LoadTempScreen(l);

            int combos[] = {mapData->ComboD[ComboAt(Hero->X, Hero->Y)], mapData->ComboD[ComboAt(Hero->X + 15, Hero->Y)], mapData->ComboD[ComboAt(Hero->X, Hero->Y + 15)], mapData->ComboD[ComboAt(Hero->X + 15, Hero->Y + 15)]};

            Screen->LayerOpacity[l] = 255;

            for (int c = 0; c < 4; ++c)
               if (combos[c]) {
                  Screen->LayerOpacity[l] = OP_TRANS;
                  break;
               }
         }

         Waitframe();
      }
   }
}

// clang-format off
@Author ("EmilyV99")
screendata script RadialTransparency {
   // clang-format on

   void run(int layers, int radius) {
      mapdata mapData[6];

      for (int l = 1; l < 6; ++l) {
         unless(layers & (1b << (l - 1))) continue;

         Screen->LayerInvisible[l] = true;

         unless(overheadBitmaps[l]->isValid()) overheadBitmaps[l] = create(256, 176);

         mapData[l] = Game->LoadTempScreen(l);
      }

      while (true) {
         for (int l = 1; l < 6; ++l) {
            unless(layers & (1b << (l - 1))) continue;

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
               unless(layers & (1b << (l - 1))) continue;

               Screen->LayerInvisible[l] = false;
            }

            while (disableTrans)
               Waitframe();
         }

         if (HeroIsScrolling())
            for (int l = 1; l < 6; ++l) {
               unless(layers & (1b << (l - 1))) continue;

               Screen->LayerInvisible[l] = false;
            }
         else
            for (int l = 1; l < 6; ++l) {
               unless(layers & (1b << (l - 1))) continue;

               Screen->LayerInvisible[l] = true;
            }
      }
   }
}

// clang-format off
@Author ("EmilyV99, Dimi")
dmapdata script DarkRegion {
   // clang-format on

   void run(int radius, int itemClass, int layer, int torchPower) {
      // unless(darknessBitmap->isValid()) darknessBitmap = create(256 * 3, 176 * 4.5);
      // else recreate(darknessBitmap, 256 * 3, 176 * 4.5);

      // int animationCounter;

      // while (true) {
      //    Waitdraw();

      //    int itemId = GetHighestLevelItemOwned(itemClass);
      //    itemdata itemData = itemId < 0 ? NULL : Game->LoadItemData(itemId);
      //    int power = itemData ? itemData->Attributes[9] : 0;
      //    int mode = 0;

      //    if (itemData)
      //       mode = itemData->Flags[14] ? BITDX_TRANS : 0;

      //    animationCounter += 2;
      //    animationCounter %= 360;

      //    for (int i = layer; i >= 0; --i) {
      //       darknessBitmap->ClearToColor(layer, C_BLACK);

      //       if (power)
      //          darknessBitmap->Circle(layer, Hero->X + 8 + 256, Hero->Y + 8 + 176, (radius * power) + VectorY(4, animationCounter) + (i * 4), mode, 1, 0, 0, 0, true, OP_OPAQUE);

      //       if (torchPower) {
      //          for (int xPos = 0; xPos < 256; xPos += 16) {
      //             for (int yPos = 0; yPos < 176; yPos += 16) {
      //                int pos = ComboAt(xPos, yPos);
      //                int comboT = Screen->ComboT[pos];

      //                for (int lightLayer = 1; lightLayer < 3; ++lightLayer)
      //                   if (Screen->LayerMap[lightLayer]) {
      //                      mapdata mapData = Game->LoadTempScreen(lightLayer);

      //                      if (mapData->ComboD[pos])
      //                         comboT = mapData->ComboT[pos];
      //                   }

      //                if (comboT == CT_SCRIPT_TORCH)
      //                   darknessBitmap->Circle(layer, xPos + 8 + 256, yPos + 8 + 176, (radius * torchPower) + VectorY(4, animationCounter) + (i * 4), mode, 1, 0, 0, 0, true, OP_OPAQUE);
      //             }
      //          }
      //       }

      //       darknessBitmap->Blit(layer, -2, 256 - Game->Scrolling[SCROLL_NX], 176 - Game->Scrolling[SCROLL_NY], 256, 176, 0, 0, 256, 176, 0, 0, 0, 1, 0, true);
      //    }

      //    Waitframe();
      // }
   }
}

// clang-format off
@Author("Deathrider365")
dmapdata script HeatedRoom {
   // clang-format on

   void run(int armorLevel, int damage) {
      handleHeatOrCold(armorLevel, damage);
   }
}

// clang-format off
@Author("Deathrider365"),
@InitD0("frequency"),
@InitDHelp0("how often to play (smaller number is more frequent)"),
@InitD1("cooldown"),
@InitDHelp1("after a sound plays, how long to wait until playing another one"),
@InitD2("sfx1"),
@InitDHelp2("sfx number to play"),
@InitD3("sfx2"),
@InitDHelp3("sfx number to play"),
@InitD4("sfx2"),
@InitDHelp4("sfx number to play")
dmapdata script PlaySFXByFrequency {
// clang-format on
   void run(int frequency, int cooldown, int sfx1, int sfx2, int sfx3) {
      loop() {
         if (gameframe % frequency == 0) {
            Audio->PlaySound(Choose(sfx1, sfx2, sfx3));
            Waitframes(cooldown);
         }

         Waitframe();
      }
   }
}

// clang-format off
dmapdata script LensTorches {
   // clang-format on

   void run() {
      int comboSlot = Game->GetComboScript("TorchMarker");

      bitmap lenslayer = new bitmap(256, 176); //TODO refactor to handle showing multiple screens (if necessary)
      bitmap lensmask = new bitmap(256, 176);
      // bitmap scrollLayer = new bitmap(256, 176);
      // bitmap scrollmask = new bitmap(256, 176);
      int drawLayer;

      while (true) {
         int screen = Game->CurScreen;
         int oldLayer = drawLayer;

         // Get the revealed lens layer
         mapdata md = Game->LoadTempScreen(0);
         mapdata md2 = Game->LoadScrollingScreen(0);

         for (int layer = 6; layer > 0; --layer) {
            if (!md->LensShows[layer])
               continue;

            drawLayer = layer - 1;
            break;
         }

         while(screen == Game->CurScreen) {
            lenslayer->Clear(0);
            // scrollLayer->Clear(0);
            // lensmask gets cleared to a color because circles are erased from it rather than added
            lensmask->ClearToColor(0, C_LENSBITMAPMARKER);
            // scrollmask->ClearToColor(0, C_LENSBITMAPMARKER);

            for (int i = 1; i <= 6; ++i) {
               if (md->LensShows[i] || i == drawLayer) {
                  mapdata md = Game->LoadTempScreen(i);

                  for (int j = 0; j < 176; ++j)
                     lenslayer->FastCombo(0, ComboX(j), ComboY(j), md->ComboD[j], md->ComboC[j]);
               }

               // if ((md2->LensShows[i] || i == oldLayer) && Game->Scrolling[SCROLL_DIR] > -1) {
               //    mapdata md2 = Game->LoadScrollingScreen(i);

               //    for (int j = 0; j < 176; ++j)
               //       scrollLayer->FastCombo(0, ComboX(j), ComboY(j), md2->ComboD[j], md2->ComboC[j]);
               // }
            }

            // Draw circles for combos on layers 0-4
            for (int i = 0; i <= 4; ++i) {
               mapdata md = Game->LoadTempScreen(i);
               mapdata md2 = Game->LoadScrollingScreen(i);

               for (int j = 0; j < 176; ++j) {
                  combodata cd = Game->LoadComboData(md->ComboD[j]);
                  if (cd->Script == comboSlot) {
                     DrawLensCircle(lensmask, ComboX(j) + 8, ComboY(j) + 8, cd->InitD[0]);
                  }

                  // if (Game->Scrolling[SCROLL_DIR] > -1) {
                  //    combodata cd2 = Game->LoadComboData(md2->ComboD[j]);
                  //    if (cd2->Script == comboSlot) {
                  //       DrawLensCircle(scrollmask, ComboX(j) + 8, ComboY(j) + 8, cd2->InitD[0]);
                  //    }
                  // }
               }
            }

            // Draw circles for FFCs
            for (int i = 1; i <= MAX_FFC; ++i) {
               ffc f = Screen->LoadFFC(i);
               if (f->Data) {
                  combodata cd = Game->LoadComboData(f->Data);
                  if (cd->Script == comboSlot) {
                     DrawLensCircle(lensmask, f->X + 8, f->Y + 8, cd->InitD[0]);
                  }
               }
               // if (Game->Scrolling[SCROLL_DIR] > -1) {
               //    if (md2->FFCData[i]) {
               //       combodata cd = Game->LoadComboData(md2->FFCData[i]);
               //       if (cd->Script == comboSlot) {
               //          DrawLensCircle(lensmask, md2->FFCX[i] + 8, md2->FFCY[i] + 8, cd->InitD[0]);
               //       }
               //    }
               // }
            }

            Screen->DrawOrigin = DRAW_ORIGIN_REGION_SCROLLING_NEW;
            // Draw the mask over the layer
            lensmask->Blit(0, lenslayer, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_NORMAL, 0, true);
            // Replace colors from the mask
            lenslayer->ReplaceColors(0, 0x00, C_LENSBITMAPMARKER, C_LENSBITMAPMARKER);

            lenslayer->Blit(drawLayer, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_NORMAL, 0, true);

            // if (Game->Scrolling[SCROLL_DIR] > -1) {
            //    Screen->DrawOrigin = DRAW_ORIGIN_REGION_SCROLLING_OLD;
            //    // Draw the mask over the layer
            //    scrollmask->Blit(0, scrollLayer, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_NORMAL, 0, true);
            //    // Replace colors from the mask
            //    scrollLayer->ReplaceColors(0, 0x00, C_LENSBITMAPMARKER, C_LENSBITMAPMARKER);

            //    scrollLayer->Blit(drawLayer, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_NORMAL, 0, true);
            // }

            Waitframe();
         }
      }
   }
   // This draws a circle to the bitmap imitating the lens of truth
   void DrawLensCircle(bitmap b, int x, int y, int rad) {
      b->Circle(0, x, y, rad, 0x00, 1, 0, 0, 0, true, OP_OPAQUE);
      b->Circle(0, x, y, rad + 2, 0x00, 1, 0, 0, 0, false, OP_OPAQUE);
      b->Circle(0, x, y, rad + 5, 0x00, 1, 0, 0, 0, false, OP_OPAQUE);
   }
}
