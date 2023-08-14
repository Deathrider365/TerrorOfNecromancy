//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Subscreen ~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

namespace SubscreenActive {
   using namespace Subscreen;

   // clang-format off
   @Author("EmilyV99, Deathrider365")
   dmapdata script SubscreenActive {
      // clang-format on

      void run() {
         if (Game->Suspend[susptSUBSCREENSCRIPTS])
            return;

         subscreenOpen = true;
         bitmap b = Game->CreateBitmap(256, 224);
         b->ClearToColor(0, BG_COLOR);
         b->DrawScreen(0, BG_MAP, BG_SCREEN, 0, 0, 0);

         for (subscreenYOffset = -224; subscreenYOffset < -56; subscreenYOffset += SCROLL_SPEED) {
            doActiveMenuFrame(b, subscreenYOffset, false);
            Waitframe();
         }

         subscreenYOffset = -56;

         do {
            doActiveMenuFrame(b, subscreenYOffset, true);
            Waitframe();
         }
         until(Input->Press[CB_START]);

         for (subscreenYOffset = -56; subscreenYOffset > -224; subscreenYOffset -= SCROLL_SPEED) {
            doActiveMenuFrame(b, subscreenYOffset, false);
            Waitframe();
         }
         subscreenYOffset = -224;
         subscreenOpen = false;
      }
   }

   void doActiveMenuFrame(bitmap b, int y, bool isActive) {
      gameframe = (gameframe + 1) % 3600;
      b->Blit(0, RT_SCREEN, 0, 0, 256, 168, 0, y, 256, 168, 0, 0, 0, BITDX_NORMAL, 0, true);

      // Input reading when in menu
      if (isActive) {
         if (Input->Press[CB_LEFT]) {
            Audio->PlaySound(CURSOR_MOVEMENT_SFX);
            --activeSubscreenPosition;
         }
         else if (Input->Press[CB_RIGHT]) {
            Audio->PlaySound(CURSOR_MOVEMENT_SFX);
            ++activeSubscreenPosition;
         }
         else if (Input->Press[CB_UP]) {
            Audio->PlaySound(CURSOR_MOVEMENT_SFX);
            activeSubscreenPosition -= 4;
         }
         else if (Input->Press[CB_DOWN]) {
            Audio->PlaySound(CURSOR_MOVEMENT_SFX);
            activeSubscreenPosition += 4;
         }

         // Triforce cycling
         if (Input->Press[CB_L]) {
            Audio->PlaySound(TRIFORCE_CYCLE_SFX);
            --currTriforceIndex;
         }
         else if (Input->Press[CB_R]) {
            Audio->PlaySound(TRIFORCE_CYCLE_SFX);
            ++currTriforceIndex;
         }

         if (activeSubscreenPosition < 0)
            activeSubscreenPosition += (4 * 6);
         else
            activeSubscreenPosition %= (4 * 6);

         unless(Game->GetCurDMap() <= 2) {
            if (currTriforceIndex == -1)
               currTriforceIndex = 3;
            else if (currTriforceIndex == 4)
               currTriforceIndex = 0;
         }
         else {
            if (currTriforceIndex == -1)
               currTriforceIndex = 2;
            else if (currTriforceIndex == 3)
               currTriforceIndex = 0;
         }
      }

      int selectedId = 0;

      // Selectable items
      for (int q = 0; q < NUM_SUBSCR_SEL_ITEMS; ++q) {
         int id = checkId(activeItemIDs[q]);

         unless(id) continue;

         if (q == activeSubscreenPosition)
            selectedId = id;

         drawTileToLoc(1, loadItemTile(id), loadItemCSet(id), activeItemLocsX[q], activeItemLocsY[q], y);
      }

      // Non Selectable Items
      for (int q = 0; q < NUM_SUBSCR_INAC_ITEMS; ++q) {
         int id = checkId(inactiveItemIDs[q]);

         int upgradeBombTile = TILE_BOMB_BAG;
         int upgradeQuiverTile = TILE_QUIVER;

         unless(id) continue;

         if (id == 81 || id == 74) {
            if (Game->Counter[CR_BOMB_BAG_EXPANSIONS] > 2)
               upgradeBombTile += 1;
            if (Game->Counter[CR_BOMB_BAG_EXPANSIONS] > 4)
               upgradeBombTile += 1;

            if (Game->Counter[CR_QUIVER_EXPANSIONS] > 2)
               upgradeQuiverTile += 1;
            if (Game->Counter[CR_QUIVER_EXPANSIONS] > 4)
               upgradeQuiverTile += 1;

            drawTileToLoc(1, id == 81 ? upgradeBombTile : upgradeQuiverTile, loadItemCSet(id), inactiveItemLocsX[q], inactiveItemLocsY[q], y);
         }
         else
            drawTileToLoc(1, loadItemTile(id), loadItemCSet(id), inactiveItemLocsX[q], inactiveItemLocsY[q], y);
      }

      // Bomb bag and Quiver counter draws
      sprintf(numBombUpgradesBuf, "%d", Game->Counter[CR_BOMB_BAG_EXPANSIONS]);
      sprintf(numQuiverUpgradesBuf, "%d", Game->Counter[CR_QUIVER_EXPANSIONS]);

      Screen->DrawString(7, 96, y + 11 - Text->FontHeight(FONT_LA) - 2, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, numBombUpgradesBuf, OP_OPAQUE, SHD_SHADOWED, C_BLACK);
      Screen->FastTile(7, 88, y + 8, TILE_BOMB_BAG_UPGRADE, 8, OP_OPAQUE);

      Screen->DrawString(7, 96, y + 34 - Text->FontHeight(FONT_LA) - 2, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, numQuiverUpgradesBuf, OP_OPAQUE, SHD_SHADOWED, C_BLACK);
      Screen->FastTile(7, 88, y + 31, TILE_QUIVER_UPGRADE, 8, OP_OPAQUE);

      // Magic Container upgrades
      sprintf(numMagicUpgradesBuf, "%d", Game->Counter[CR_MAGIC_EXPANSIONS]);
      Screen->DrawString(7, 96, y + 57 - Text->FontHeight(FONT_LA) - 2, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, numMagicUpgradesBuf, OP_OPAQUE, SHD_SHADOWED, C_BLACK);
      Screen->FastTile(7, 88, y + 56, TILE_MAGIC_CONTAINER_UPGRADE, 7, OP_OPAQUE);

      // Dungeon Item Draws
      for (int q = 0; q < NUM_SUBSCR_DUNGEON_ITEMS; ++q) {
         int id = checkId(dungeonItemIds[q]);

         unless(id) continue;

         drawTileToLoc(1, loadItemTile(id), loadItemCSet(id), dungeonItemX[q], dungeonItemY[q], y);
      }

      // start Misc draws
      //  Green Mail
      if (!Hero->Item[155] && GetHighestLevelItemOwned(IC_RING) < 17)
         Screen->FastTile(4, 22, y + 4, 29266, 6, OP_OPAQUE);
      // Legionnaire Ring
      Screen->FastTile(4, 122, y + 84, TILE_LEGIONNAIRE_RING, CSET_LEGIONNAIRE_RING, OP_OPAQUE);
      counter(RT_SCREEN, 4, 141, y + 88, CR_LEGIONNAIRE_RING, SUBSCR_COUNTER_FONT, C_SUBSCR_COUNTER_TEXT, C_SUBSCR_COUNTER_BG, TF_NORMAL, 2, CNTR_USES_0);

      // Leviathan Scale
      if (Hero->Item[183])
         Screen->FastTile(4, 110, y + 6, TILE_LEVIATHAN_SCALE, CSET_LEVIATHAN_SCALE, OP_OPAQUE);

      // Toxic Forest Key
      if (Hero->Item[184])
         Screen->FastTile(4, 110, y + 24, TILE_TOXIC_FOREST_KEY, CSET_TOXIC_FOREST_KEY, OP_OPAQUE);

      // Guard Tower Key
      if (Hero->Item[202])
         Screen->FastTile(4, 110, y + 24, TILE_GUARD_TOWER_KEY, CSET_GUARD_TOWER_KEY, OP_OPAQUE);

      // Allegiance Signet
      if (Hero->Item[206])
         Screen->FastTile(4, 130, y + 6, TILE_ALLEGIANCE_SIGNET, CSET_ALLEGIANCE_SIGNET, OP_OPAQUE);

      // Mysterious Key
      if (Hero->Item[207])
         Screen->FastTile(4, 110, y + 24, TILE_MYSTERIOUS_KEY, CSET_MYSTERIOUS_KEY, OP_OPAQUE);

      // Strange Coffer
      if (Hero->Item[155])
         Screen->FastTile(4, 22, y + 4, TILE_STRANGE_COFFER, CSET_MYSTERIOUS_COFFER, OP_OPAQUE);

      // Really Small Key
      if (Hero->Item[156])
         Screen->FastTile(4, 88, y + 144, TILE_REALLY_SMALL_KEY, CSET_REALLY_SMALL_KEY, OP_OPAQUE);

      // Engagement Ring
      if (Hero->Item[157])
         Screen->FastTile(4, 88, y + 140, TILE_ENGAGEMENT_RING, CSET_ENGAGEMENT_RING, OP_OPAQUE);

      // Main Trading Sequence items
      int itemId = GetHighestLevelItemOwned(IC_TRADING_SEQ);

      if (itemId > -1) {
         itemdata tradingItem = Game->LoadItemData(GetHighestLevelItemOwned(IC_TRADING_SEQ));
         Screen->FastTile(4, 22, y + 140, tradingItem->Tile, tradingItem->CSet, OP_OPAQUE);
      }
      // end

      // Selected Item Name
      char32 buf2[30];
      itemdata idata = Game->LoadItemData(selectedId);

      if (idata)
         idata->GetDisplayName(buf2);

      Emily::DrawStrings(4, 206, y + 7, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, buf2, OP_OPAQUE, SHD_SHADOWED, C_BLACK, 0, 80);

      // Selecting item
      drawTileToLoc(7, loadItemTile(I_SELECTA), loadItemCSet(I_SELECTA), activeItemLocsX[activeSubscreenPosition], activeItemLocsY[activeSubscreenPosition], y);
      drawTileToLoc(7, loadItemTile(I_SELECTB), loadItemCSet(I_SELECTB), activeItemLocsX[activeSubscreenPosition], activeItemLocsY[activeSubscreenPosition], y);

      if (isActive && selectedId) {
         if (Input->Press[CB_A]) {
            Audio->PlaySound(ITEM_SELECTION_SFX);

            if (Hero->ItemB == selectedId)
               Hero->ItemB = Hero->ItemA;

            Hero->ItemA = selectedId;
         }
         else if (Input->Press[CB_B]) {
            Audio->PlaySound(ITEM_SELECTION_SFX);

            if (Hero->ItemA == selectedId)
               Hero->ItemA = Hero->ItemB;

            Hero->ItemB = selectedId;
         }
      }

      int leftArrowCombo = 7746;
      int rightArrowCombo = 7747;
      int LCombo = 7744;
      int RCombo = 7745;

      Screen->FastCombo(7, 4, 88 + y, leftArrowCombo, 0, OP_OPAQUE);
      Screen->FastCombo(7, 104, 88 + y, rightArrowCombo, 0, OP_OPAQUE);

      Screen->FastCombo(7, 4, 104 + y, LCombo, 0, OP_OPAQUE);
      Screen->FastCombo(7, 104, 104 + y, RCombo, 0, OP_OPAQUE);

      // Heart Pieces
      Screen->FastTile(4, 122, y + 68, TILE_ZERO_PIECES + Game->Generic[GEN_HEARTPIECES], 8, OP_OPAQUE);
      counter(RT_SCREEN, 4, 141, y + 72, CR_HEARTPIECES, SUBSCR_COUNTER_FONT, C_SUBSCR_COUNTER_TEXT, C_SUBSCR_COUNTER_BG, TF_NORMAL, 2, CNTR_USES_0);

      // Triforce Frame Cycling / Drawing
      if (currTriforceIndex == 0)
         Emily::DrawStrings(4, 62, y + 75, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, "Triforce of Courage", OP_OPAQUE, SHD_SHADOWED, C_BLACK, 0, 120);
      if (currTriforceIndex == 1)
         Emily::DrawStrings(4, 62, y + 75, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, "Triforce of Power", OP_OPAQUE, SHD_SHADOWED, C_BLACK, 0, 120);
      if (currTriforceIndex == 2)
         Emily::DrawStrings(4, 62, y + 75, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, "Triforce of Wisdom", OP_OPAQUE, SHD_SHADOWED, C_BLACK, 0, 120);
      if (currTriforceIndex == 3 && Game->GetCurDMap() != 2)
         Emily::DrawStrings(4, 62, y + 75, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, "Triforce of Death", OP_OPAQUE, SHD_SHADOWED, C_BLACK, 0, 120);

      Screen->DrawTile(0, 14, 80 + y, triforceFrames[currTriforceIndex], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);

      switch (currTriforceIndex) {
         case 0:
            for (int i = 0; i < Game->Counter[CR_TRIFORCE_OF_COURAGE]; ++i)
               Screen->DrawTile(0, 14, 80 + y, courageShards[i], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
            break;
         case 1:
            for (int i = 0; i < Game->Counter[CR_TRIFORCE_OF_POWER]; ++i)
               Screen->DrawTile(0, 14, 80 + y, powerShards[i], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
            break;
         case 2:
            for (int i = 0; i < Game->Counter[CR_TRIFORCE_OF_WISDOM]; ++i)
               Screen->DrawTile(0, 14, 80 + y, wisdomShards[i], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
            break;
         case 3:
            for (int i = 0; i < Game->Counter[CR_TRIFORCE_OF_DEATH]; ++i)
               Screen->DrawTile(0, 14, 80 + y, deathShards[i], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
            break;
      }
   }

   void drawTileToLoc(int layer, int tile, int cset, int locX, int locY) {
      drawTileToLoc(layer, tile, cset, locX, locY, 0);
   }

   void drawTileToLoc(int layer, int tile, int cset, int locX, int locY, int y) {
      Screen->FastTile(layer, locX, locY + y, tile, cset, OP_OPAQUE);
   }

} // namespace SubscreenActive

namespace SubscreenPassive {
   using namespace Subscreen;
   using namespace time;

   // clang-format off
   @Author("EmilyV99, Deathrider365")
   dmapdata script SubscreenPassive {
      // clang-format on

      void run() {
         bitmap bm = Game->CreateBitmap(256, 56);
         bm->DrawScreen(0, BG_MAP1, BG_SCREEN1, 0, 0, 0);

         int lastButton = -1;
         int lastA = Hero->ItemA;
         int lastB = Hero->ItemB;

         while (true) {
            if (Hero->ItemA > -1 && Hero->ItemA != checkId(Game->LoadItemData(Hero->ItemA)->Type))
               forceButton(CB_A);
            if (Hero->ItemB > -1 && Hero->ItemB != checkId(Game->LoadItemData(Hero->ItemB)->Type)) {
               forceButton(CB_B);
            }

            if (Input->Press[CB_A])
               lastButton = CB_A;
            else if (Input->Press[CB_B])
               lastButton = CB_B;

            if ((lastButton == CB_A && lastA != Hero->ItemA) || (lastButton == CB_B && lastB != Hero->ItemB)) {
               if (lastButton == CB_A && Game->LoadItemData(lastA)->Type == IC_POTION) {
                  int id = checkId(IC_POTION);

                  if (id)
                     Hero->ItemA = id;
               }
               else if (lastButton == CB_B && Game->LoadItemData(lastB)->Type == IC_POTION) {
                  int id = checkId(IC_POTION);

                  if (id)
                     Hero->ItemB = id;
               }

               if (Hero->ItemA == Hero->ItemB)
                  forceButton(lastButton);
            }

            unless(subscreenOpen) {
               if (Input->Press[CB_L]) {
                  int pos = 0;

                  if (Hero->ItemB > 0) {
                     for (int i = 0; i < NUM_SUBSCR_SEL_ITEMS; ++i) {
                        if (checkId(activeItemIDs[i]) == Hero->ItemB) {
                           pos = i;
                           break;
                        }
                     }
                  }

                  int spos = pos;
                  int id;

                  do {
                     --pos;

                     if (pos < 0)
                        pos = NUM_SUBSCR_SEL_ITEMS - 1;

                     id = checkId(activeItemIDs[pos]);

                     if (pos == spos)
                        break;
                  }
                  until(id && id != Hero->ItemA)

                      if (Hero->ItemA != id && id) {
                     Hero->ItemB = id;
                     lastB = id;
                  }
               }
               else if (Input->Press[CB_R]) {
                  int pos = NUM_SUBSCR_SEL_ITEMS - 1;

                  if (Hero->ItemB > 0) {
                     for (int q = 0; q < NUM_SUBSCR_SEL_ITEMS; ++q) {
                        if (checkId(activeItemIDs[q]) == Hero->ItemB) {
                           pos = q;
                           break;
                        }
                     }
                  }

                  int prevPos = pos;
                  int id;

                  do {
                     ++pos;

                     if (pos >= NUM_SUBSCR_SEL_ITEMS)
                        pos = 0;

                     id = checkId(activeItemIDs[pos]);

                     if (pos == prevPos)
                        break;
                  }
                  until(id && id != Hero->ItemA)

                      if (Hero->ItemA != id && id) {
                     Hero->ItemB = id;
                     lastB = id;
                  }
               }
            }

            Waitdraw();
            doPassiveMenuFrame(bm, subscreenYOffset + 168);

            lastA = Hero->ItemA;
            lastB = Hero->ItemB;

            Waitframe();

            while (Game->Suspend[susptSUBSCREENSCRIPTS])
               Waitframe();
         }
      }
   }

   void doPassiveMenuFrame(bitmap bm, int y) {
      if (y > -55)
         Screen->Rectangle(7, 0, y, 255, y + 55, BG_COLOR, 1, 0, 0, 0, true, OP_OPAQUE);
      else {
         Screen->Rectangle(7, 0, y, 180, y + 55, BG_COLOR, 1, 0, 0, 0, true, OP_OPAQUE);
         Screen->Rectangle(7, 0, y + 12, 255, y + 55, BG_COLOR, 1, 0, 0, 0, true, OP_OPAQUE);
         Screen->Rectangle(7, 235, y, 255, y + 12, BG_COLOR, 1, 0, 0, 0, true, OP_OPAQUE);
      }

      bm->Blit(7, RT_SCREEN, 0, 0, 256, 56, 0, y, 256, 56, 0, 0, 0, BITDX_NORMAL, 0, true); // Draw the BG bitmap to the screen

      // Counters
      minitile(RT_SCREEN, 7, 134, y + 4, 32780, 0, 0);
      counter(RT_SCREEN, 7, 134 + 10, y + 4, CR_MONEY, SUBSCR_COUNTER_FONT, C_SUBSCR_COUNTER_TEXT, C_SUBSCR_COUNTER_BG, TF_NORMAL, 3, CNTR_USES_0);
      minitile(RT_SCREEN, 7, 134, y + 14, 32780, 0, 1);
      counter(RT_SCREEN, 7, 134 + 10, y + 14, CR_BOMBS, SUBSCR_COUNTER_FONT, C_SUBSCR_COUNTER_TEXT, C_SUBSCR_COUNTER_BG, TF_NORMAL, 2, CNTR_USES_0);
      minitile(RT_SCREEN, 7, 134, y + 24, 32780, 0, 3);
      counter(RT_SCREEN, 7, 134 + 10, y + 24, CR_SBOMBS, SUBSCR_COUNTER_FONT, C_SUBSCR_COUNTER_TEXT, C_SUBSCR_COUNTER_BG, TF_NORMAL, 2, CNTR_USES_0);
      minitile(RT_SCREEN, 7, 134, y + 34, 32780, 0, 2);
      counter(RT_SCREEN, 7, 134 + 10, y + 34, CR_ARROWS, SUBSCR_COUNTER_FONT, C_SUBSCR_COUNTER_TEXT, C_SUBSCR_COUNTER_BG, TF_NORMAL, 2, CNTR_USES_0);
      minitile(RT_SCREEN, 7, 134, y + 44, 32800, 0, 0);
      counter(RT_SCREEN, 7, 134 + 10, y + 44, Game->GetCurLevel() ? -Game->GetCurLevel() : MAX_INT, SUBSCR_COUNTER_FONT, C_SUBSCR_COUNTER_TEXT, C_SUBSCR_COUNTER_BG, TF_NORMAL, 2, CNTR_USES_0);

      // Buttons
      // Frames
      Screen->DrawTile(7, 82, y + 18, TILE_SUBSCR_BUTTON_FRAME, 2, 2, 11, -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
      Screen->DrawTile(7, 105, y + 18, TILE_SUBSCR_BUTTON_FRAME, 2, 2, 11, -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
      // Labels
      Screen->FastTile(7, 87, y + 5, 1288, 0, OP_OPAQUE);
      Screen->FastTile(7, 110, y + 5, 1268, 0, OP_OPAQUE);
      // Items
      Screen->FastTile(7, 86, y + 26, loadItemTile(Hero->ItemB), loadItemCSet(Hero->ItemB), OP_OPAQUE);
      Screen->FastTile(7, 109, y + 26, loadItemTile(Hero->ItemA), loadItemCSet(Hero->ItemA), OP_OPAQUE);

      // start Life Meter
      drawHearts(y);
      // end

      // Magic Meter TODO IMPROVE THIS
      int perc = Game->Counter[CR_MAGIC] / Game->MCounter[CR_MAGIC];
      Screen->DrawTile(7, 162, y + 44, TILE_MAGIC_METER + (Game->Generic[GEN_MAGICDRAINRATE] < 2 ? 20 : 0), MAGIC_METER_TILE_WIDTH, 1, 0, -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);

      if (MAGIC_METER_PIX_WIDTH * perc >= 0.5)
         Screen->Rectangle(7, 162 + MAGIC_METER_FILL_XOFF, y + 44 + MAGIC_METER_FILL_YOFF, 162 + MAGIC_METER_FILL_XOFF + Round(MAGIC_METER_PIX_WIDTH * perc), y + 44 + MAGIC_METER_FILL_YOFF + MAGIC_METER_PIX_HEIGHT, C_MAGIC_METER_FILL, 1, 0, 0, 0, true, OP_OPAQUE);

      drawDifficultyItem(y);

      char32 buf[16];
      sprintf(buf, "%d:%02d:%02d", Hours(), Minutes(), Seconds());

      if (y > -55)
         Screen->DrawString(7, 224, y + 3, SUBSCR_COUNTER_FONT, C_SUBSCR_COUNTER_TEXT, C_SUBSCR_COUNTER_BG, TF_RIGHT, buf, OP_OPAQUE, SHD_SHADOWED, C_BLACK);
      // end

      // start Minimap
      ScreenType ow = getScreenType(true);
      int minimapTile = ow == DM_OVERWORLD ? TILE_MINIMAP_OW_BG : TILE_MINIMAP_DNGN_BG;
      int cs = 0;
      dmapdata dmap = Game->LoadDMapData(Game->GetCurDMap());
      bool hasMap = Game->LItems[Game->GetCurLevel()] & LI_MAP;

      if (hasMap && dmap->MiniMapTile[1]) {
         minimapTile = dmap->MiniMapTile[1];
         cs = dmap->MiniMapCSet[1];
      }
      else if (dmap->MiniMapTile[0] && !hasMap) {
         minimapTile = dmap->MiniMapTile[0];
         cs = dmap->MiniMapCSet[0];
      }

      Screen->DrawTile(7, 0, y + 8, minimapTile, 5, 3, cs, -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
      minimap(RT_SCREEN, 7, 0, y + 8, ow);
      // end

      // start DMap Title
      char32 titlebuf[80];
      Game->GetDMapTitle(dmap->ID, titlebuf);
      int index;
      int lastLetter;
      bool wasSpace = true;

      for (int q = 0; q < 80; ++q) {
         if (titlebuf[q] == ' ') {
            unless(wasSpace) wasSpace = true;
            else continue;
         }
         else {
            lastLetter = q;
            wasSpace = false;
         }

         titlebuf[index++] = titlebuf[q];
      }

      for (int q = lastLetter + 1; q < 80; ++q)
         titlebuf[q] = 0;

      Emily::DrawStrings(7, 41, y + 2, SUBSCR_DMAPTITLE_FONT, C_SUBSCR_COUNTER_TEXT, C_SUBSCR_COUNTER_BG, TF_CENTERED, titlebuf, OP_OPAQUE, SHD_SHADOWED, C_BLACK, 1, 64);
      // end
   }

   void drawHearts(int y) {
      const int INITIAL_X = 166;
      int x = INITIAL_X;
      int yModifier = 43;
      int rowCount = 1;

      for (int i = 0; i < 30; i++) {
         unless(i % 10) {
            ++rowCount;
            x = INITIAL_X + (3 * rowCount);
            yModifier -= 7;
         }
         else x += 6;

         heart(RT_SCREEN, 7, x, y + yModifier, i, TILE_HEARTS);
      }
   }

   void heart(untyped bit, int layer, int x, int y, int num, int baseTile) {
      if (Game->MCounter[CR_LIFE] < (num * 16 + 1))
         return;

      int shift;

      if (Game->Counter[CR_LIFE] >= (num + 1) * 16)
         shift = 4;
      else {
         if (Game->Counter[CR_LIFE] < (num * 16))
            shift = 0;
         else
            shift = Div(Game->Counter[CR_LIFE] % HP_PER_HEART, HP_PER_HEART / 4);
      }

      if (bit == RT_SCREEN)
         Screen->FastTile(layer, x, y, baseTile + shift, 0, OP_OPAQUE);
      else
         <bitmap>(bit)->FastTile(layer, x, y, baseTile + shift, 0, OP_OPAQUE);
   }

   void minimap(untyped bit, int layer, int originalX, int originalY, ScreenType dmap) {
      if (dmap == DM_OVERWORLD) {
         int scr = Game->GetCurScreen();
         int x = originalX + 9 + (4 * (scr % 0x010));
         int y = originalY + 8 + (4 * Div(scr, 0x010));

         if (bit == RT_SCREEN)
            Screen->Rectangle(layer, x, y, x + 2, y + 2, C_MINIMAP_LINK, 1, 0, 0, 0, true, OP_OPAQUE);
         else
            <bitmap>(bit)->Rectangle(layer, x, y, x + 2, y + 2, C_MINIMAP_LINK, 1, 0, 0, 0, true, OP_OPAQUE);
      }
      else {
         bool hasMap = Game->LItems[Game->GetCurLevel()] & LI_MAP;
         bool hasCompass = Game->LItems[Game->GetCurLevel()] & LI_COMPASS;
         bool killedBoss = Game->LItems[Game->GetCurLevel()] & LI_BOSS;
         dmapdata currentDmap = Game->LoadDMapData(Game->GetCurDMap());

         hasCompass = currentDmap->Compass ? hasCompass : false;

         originalX += 8;
         originalY += 8;

         int dmapOffset = Game->DMapOffset[Game->GetCurDMap()];
         int currentScreen = Game->GetCurDMapScreen();

         int dmapOffsetMax = 8 - Max(dmapOffset - 8, 0);
         int dmapOffsetMin = -Min(dmapOffset, 0);

         for (int q = 0; q < 128; ++q) {
            if (q % 0x10 >= dmapOffsetMax || q % 0x10 < dmapOffsetMin)
               continue;

            Color mapCellColor = C_TRANS;
            Color compassMarkerColor = C_TRANS;
            int x = originalX + (8 * (q % 0x010));
            int y = originalY + (4 * Div(q, 0x010));

            if ((gameframe & 100000b || killedBoss) && hasCompass && q + dmapOffset == currentDmap->Compass) // TODO how to hide the compass when "Dont display compass in minimap is checked"
               compassMarkerColor = killedBoss ? C_MINIMAP_COMPASS_DEFEATED : C_MINIMAP_COMPASS;
            else if (q == currentScreen)
               compassMarkerColor = C_MINIMAP_LINK;

            unless(dmap == DM_BSOVERWORLD) {
               mapdata m = Game->LoadMapData(Game->GetCurMap(), q + dmapOffset);

               if (m->State[ST_VISITED])
                  mapCellColor = C_MINIMAP_EXPLORED;
               else if (hasMap && dmapinfo::VisibleOnDungeonMap(q, true))
                  mapCellColor = C_MINIMAP_ROOM;
            }

            if (mapCellColor) {
               if (bit == RT_SCREEN)
                  Screen->Rectangle(layer, x, y, x + 6, y + 2, mapCellColor, 1, 0, 0, 0, true, OP_OPAQUE);
               else
                  <bitmap>(bit)->Rectangle(layer, x, y, x + 6, y + 2, mapCellColor, 1, 0, 0, 0, true, OP_OPAQUE);
            }
            if (compassMarkerColor) {
               if (bit == RT_SCREEN)
                  Screen->Rectangle(layer, x + 2, y, x + 4, y + 2, compassMarkerColor, 1, 0, 0, 0, true, OP_OPAQUE);
               else
                  <bitmap>(bit)->Rectangle(layer, x + 2, y, x + 4, y + 2, compassMarkerColor, 1, 0, 0, 0, true, OP_OPAQUE);
            }
         }
      }
   }

   void forceButton(int button) {
      for (int q = 0; q < NUM_SUBSCR_SEL_ITEMS; ++q) {
         int id = checkId(activeItemIDs[q]);

         if (id) {
            if (button == CB_A) {
               if (id != Hero->ItemB) {
                  Hero->ItemA = id;
                  break;
               }
            }
            else if (id != Hero->ItemA) {
               Hero->ItemB = id;
               break;
            }
         }
         else {
            if (button == CB_A)
               Hero->ItemA = 0;
            else
               Hero->ItemB = 0;
         }
      }
   }

   void drawDifficultyItem(int y) {
      if (Link->Item[I_DIFF_VERYEASY])
         Screen->FastTile(7, 240, y, TILE_DIFF_NORMAL, 0, OP_OPAQUE);
      if (Link->Item[I_DIFF_EASY])
         Screen->FastTile(7, 240, y, TILE_DIFF_NORMAL, 7, OP_OPAQUE);
      if (Link->Item[I_DIFF_NORMAL])
         Screen->FastTile(7, 240, y, TILE_DIFF_NORMAL, 8, OP_OPAQUE);
      if (Link->Item[I_DIFF_HARD])
         Screen->FastTile(7, 240, y, TILE_DIFF_HARD, 1, OP_OPAQUE);
      if (Link->Item[I_DIFF_VERYHARD])
         Screen->FastTile(7, 240, y, TILE_DIFF_PALADIN, 1, OP_OPAQUE);
   }
} // namespace SubscreenPassive

namespace Subscreen {
   int checkId(int id) {
      if (id == -1)
         return 0;

      if (id < 0) {
         id = -id;

         unless(id && Hero->Item[id]) return 0;
      }
      else {
         int fam = id;
         id = 0;

         switch (fam) {
            case IC_BOSSKEY:
               if (isOverworld(true))
                  return 0;

               if (Game->LItems[Game->GetCurLevel()] & LI_BOSSKEY)
                  id = I_BOSSKEY;
               break;
            case IC_MAP:
               if (isOverworld(true))
                  return 0;

               if (Game->LItems[Game->GetCurLevel()] & LI_MAP)
                  id = I_MAP;
               break;
            case IC_COMPASS:
               if (isOverworld(true))
                  return 0;

               if (Game->LItems[Game->GetCurLevel()] & LI_COMPASS)
                  id = I_COMPASS;
               break;
            default:
               id = GetHighestLevelItemOwned(fam);
               switch (fam) {
                  case IC_BOMB: unless(Game->Counter[CR_BOMBS]) return 0; break;
                  case IC_SBOMB: unless(Game->Counter[CR_SBOMBS]) return 0; break;
                  case IC_POTION: unless(id > 0) id = GetHighestLevelItemOwned(IC_LETTER); break;
                  case IC_ARROW:
                     if (Game->Counter[CR_ARROWS] == 0 || !Hero->Item[15])
                        return 0;
                     break;
                  case IC_BRANG:
                     int id2 = GetHighestLevelItemOwned(IC_WPN_SCRIPT_01);

                     if (id2 > 0)
                        id = id2;

                     break;
               }

               unless(id > 0) return 0;
         }
      }
      return id;
   } // end

   void counter(untyped bit, int layer, int x, int y, int cntr, int font, Color color, Color bgcolor, int format, int minDigits, bool showZeroes) {
      char32 buf[16];
      int chr = cntr < 0 ? itoa(buf, Game->LKeys[-cntr]) : (cntr == MAX_INT ? itoa(buf, Game->LKeys[0]) : itoa(buf, Game->Counter[cntr]));

      unless(chr) buf[chr++] = '0';

      char32 spcbuf[16];

      for (int q = 0; q < minDigits - chr; ++q)
         spcbuf[q] = showZeroes ? '0' : ' ';

      sprintf(buf, "%s%s", spcbuf, buf);

      if (bit == RT_SCREEN)
         Screen->DrawString(layer, x, y, font, color, bgcolor, format, buf, OP_OPAQUE, SHD_SHADOWED, C_BLACK);
      else
         <bitmap>(bit)->DrawString(layer, x, y, font, color, bgcolor, format, buf, OP_OPAQUE, SHD_SHADOWED, C_BLACK);
   }

   void minitile(untyped bit, int layer, int x, int y, int tile, int cset, int corner) {
      bitmap sub = Game->CreateBitmap(16, 16);
      sub->Clear(0);
      tile(sub, 0, 0, 0, tile, cset);
      sub->Blit(layer, bit, (corner & 01b) ? 8 : 0, (corner & 10b) ? 8 : 0, 8, 8, x, y, 8, 8, 0, 0, 0, 0, 0, true);
      sub->Free();
   }

   void tile(untyped bit, int layer, int x, int y, int tile, int cset) {
      <bitmap>(bit)->FastTile(layer, x, y, tile, cset, OP_OPAQUE);
   }

   int loadItemTile(int itemId) {
      unless(itemId > 0) return TILE_INVIS;

      itemdata i = Game->LoadItemData(itemId);
      int frameNum = 0;

      if (i->ASpeed > 0 && i->AFrames > 0) {
         int temp = (gameframe % ((i->ASpeed * i->AFrames) + (i->ASpeed * i->Delay))) - (i->Delay * i->ASpeed);

         if (temp >= 0)
            frameNum = Floor(temp / i->ASpeed);
      }

      return i->Tile + frameNum;
   }

   int loadItemCSet(int itemId) {
      unless(itemId > 0) return 0;

      return Game->LoadItemData(itemId)->CSet;
   }
} // namespace Subscreen