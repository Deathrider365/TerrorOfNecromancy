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
ffc script LensTorches {
   // clang-format on
   void run() {
      int comboSlot = Game->GetComboScript("TorchMarker");
      CONFIG C_LENSBITMAPMARKER = 0xFE;

      bitmap lenslayer = new bitmap(Viewport->Width, Viewport->Height);
      bitmap lensmask = new bitmap(Viewport->Width, Viewport->Height);
      int drawLayer;
      Screen->DrawOrigin = DRAW_ORIGIN_PLAYING_FIELD;

      while (true) {
         int screen = Game->HeroScreen;
         int oldLayer = drawLayer;

         // Get the revealed lens layer
         mapdata md = Game->LoadTempScreen(0);

         for (int layer = 6; layer > 0; --layer) {
            if (!md->LensShows[layer])
               continue;

            drawLayer = layer - 1;
            break;
         }

         while(screen == Game->HeroScreen) {
            Waitdraw();
            lenslayer->Clear(0);

            // lensmask gets cleared to a color because circles are erased from it rather than added
            lensmask->ClearToColor(0, C_LENSBITMAPMARKER);

            for (int i = 1; i <= 6; ++i) {
               if (md->LensShows[i] || i == drawLayer) {
                  mapdata md = Game->LoadTempScreen(i);

                  for (int j = 0; j < NUM_COMBO_POS; ++j)
                     if (viewportContainsRect(ComboX(j), ComboY(j), 16, 16))
                        lenslayer->FastCombo(0, ComboX(j) - Viewport->X, ComboY(j) - Viewport->Y, md->ComboD[j], md->ComboC[j]);
               }
            }

            // Draw circles for combos on layers 0-4
            for (int i = 0; i <= 4; ++i) {
               mapdata md = Game->LoadTempScreen(i);

               for (int j = 0; j < NUM_COMBO_POS; ++j) {
                  combodata cd = Game->LoadComboData(md->ComboD[j]);

                  if (cd->Script == comboSlot) {
                     int inScreenRadius = cd->InitD[0] + 8;
                     int x = ComboX(j) + 8 - inScreenRadius;
                     int y = ComboY(j) + 8 - inScreenRadius;

                     if (viewportContainsRect(x, y, inScreenRadius * 2, inScreenRadius * 2))
                        drawLensCircle(lensmask, ComboX(j) + 8 - Viewport->X, ComboY(j) + 8 - Viewport->Y, cd->InitD[0]);
                  }
               }
            }

            // Draw circles for FFCs
            // for (int i = 1; i <= MAX_FFC; ++i) { //TODO why cant I? because this
            //    ffc f = Screen->LoadFFC(i);

            //    if (f->Data) {
            //       combodata cd = Game->LoadComboData(f->Data);
            //       if (cd->Script == comboSlot)
            //          drawLensCircle(lensmask, (f->X + 8), (f->Y + 8), cd->InitD[0]);
            //    }
            // }

            // Screen->DrawOrigin = DRAW_ORIGIN_REGION_SCROLLING_NEW;
            // Draw the mask over the layer
            lensmask->Blit(0, lenslayer, 0, 0, Viewport->Width, Viewport->Height, 0, 0, Viewport->Width, Viewport->Height, 0, 0, 0, BITDX_NORMAL, 0, true);
            // Replace colors from the mask
            lenslayer->ReplaceColors(0, 0x00, C_LENSBITMAPMARKER, C_LENSBITMAPMARKER);

            lenslayer->Blit(drawLayer, RT_SCREEN, 0, 0, Viewport->Width, Viewport->Height, 0, 0, Viewport->Width, Viewport->Height, 0, 0, 0, BITDX_NORMAL, 0, true);

            Waitframe();
         }
      }

      Screen->DrawOrigin = DRAW_ORIGIN_DEFAULT;
   }
   // This draws a circle to the bitmap imitating the lens of truth
   void drawLensCircle(bitmap b, int x, int y, int rad) {
      b->Circle(0, x, y, rad, 0x00, 1, 0, 0, 0, true, OP_OPAQUE);
      b->Circle(0, x, y, rad + 2, 0x00, 1, 0, 0, 0, false, OP_OPAQUE);
      b->Circle(0, x, y, rad + 5, 0x00, 1, 0, 0, 0, false, OP_OPAQUE);
   }
}

