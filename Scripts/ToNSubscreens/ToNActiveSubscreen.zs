///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~~The Terror of Necromancy ActiveSubscreen~~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

@Author("EmilyV99, Modified by Deathrider365")
dmapdata script SubscreenActive {
   void run() {
      if(Game->Suspend[susptSUBSCREENSCRIPTS]) 
         return;
         
      subscreenOpen = true;
      bitmap b = Game->CreateBitmap(256, 224);
      b->ClearToColor(0, BG_COLOR);
      b->DrawScreen(0, BG_MAP, BG_SCREEN, 0, 0, 0);
      
      for(subscreenYOffset = -224; subscreenYOffset < -56; subscreenYOffset += SCROLL_SPEED) {
         doActiveMenuFrame(b, subscreenYOffset, false);
         Waitframe();
      }
      
      subscreenYOffset = -56;
      
      do {
         doActiveMenuFrame(b, subscreenYOffset, true);
         Waitframe();
      } until(Input->Press[CB_START]);
      
      for(subscreenYOffset = -56; subscreenYOffset > -224; subscreenYOffset -= SCROLL_SPEED) {
         doActiveMenuFrame(b, subscreenYOffset, false);
         Waitframe();
      }
      subscreenYOffset = -224;
      subscreenOpen = false;
   }
   
   void doActiveMenuFrame(bitmap b, int y, bool isActive) {
      gameframe = (gameframe + 1) % 3600;
      b->Blit(0, RT_SCREEN, 0, 0, 256, 168, 0, y, 256, 168, 0, 0, 0, BITDX_NORMAL, 0, true);
      
      // Input reading when in menu
      if(isActive) {
         if(Input->Press[CB_LEFT]) {
            Audio->PlaySound(CURSOR_MOVEMENT_SFX);
            --activeSubscreenPosition;
         }
         else if(Input->Press[CB_RIGHT]) {
            Audio->PlaySound(CURSOR_MOVEMENT_SFX);
            ++activeSubscreenPosition;
         }
         else if(Input->Press[CB_UP]) {
            Audio->PlaySound(CURSOR_MOVEMENT_SFX);
            activeSubscreenPosition -= 4;
         }
         else if(Input->Press[CB_DOWN]) {
            Audio->PlaySound(CURSOR_MOVEMENT_SFX);
            activeSubscreenPosition += 4;
         }
         
         // Triforce cycling
         if(Input->Press[CB_L]) {
            Audio->PlaySound(TRIFORCE_CYCLE_SFX);
            --currTriforceIndex;
         }
         else if(Input->Press[CB_R]) {
            Audio->PlaySound(TRIFORCE_CYCLE_SFX);
            ++currTriforceIndex;
         }
            
         if(activeSubscreenPosition < 0)
            activeSubscreenPosition += (4 * 6);
         else 
            activeSubscreenPosition %= (4 * 6);
         
         unless(Game->GetCurDMap() <= 2) {
            if(currTriforceIndex == -1)
               currTriforceIndex = 3;
            else if (currTriforceIndex == 4)
               currTriforceIndex = 0;
         }
         else {
            if(currTriforceIndex == -1)
               currTriforceIndex = 2;
            else if (currTriforceIndex == 3)
               currTriforceIndex = 0;
         }
      }
      
      int selectedId = 0;
      
      // Selectable items
      for(int q = 0; q < NUM_SUBSCR_SEL_ITEMS; ++q) {
         int id = checkId(activeItemIDs[q]);
         
         unless(id) 
            continue;
            
         if(q == activeSubscreenPosition) 
            selectedId = id;
         
         drawTileToLoc(1, loadItemTile(id), loadItemCSet(id), activeItemLocsX[q], activeItemLocsY[q], y);
      }
      
      // Non Selectable Items
      for(int q = 0; q < NUM_SUBSCR_INAC_ITEMS; ++q) {
         int id = checkId(inactiveItemIDs[q]);
         
         int upgradeBombTile = TILE_BOMB_BAG;
         int upgradeQuiverTile = TILE_QUIVER;
         
         unless(id) 
            continue;
            
         if (id == 81 || id == 74) {
            if (numBombUpgrades > 2)
               upgradeBombTile += 1;
            if (numBombUpgrades > 4)
               upgradeBombTile += 1;
               
            if (numQuiverUpgrades > 2)
               upgradeQuiverTile += 1;
            if (numQuiverUpgrades > 4)
               upgradeQuiverTile += 1;
               
            drawTileToLoc(1, id == 81 ? upgradeBombTile : upgradeQuiverTile, loadItemCSet(id), inactiveItemLocsX[q], inactiveItemLocsY[q], y);
         } 
         else 	
            drawTileToLoc(1, loadItemTile(id), loadItemCSet(id), inactiveItemLocsX[q], inactiveItemLocsY[q], y);
      }
      
      // Bomb bag and Quiver counter draws
      sprintf(numBombUpgradesBuf, "%d", numBombUpgrades);
      sprintf(numQuiverUpgradesBuf, "%d", numQuiverUpgrades);
      
      Screen->FastTile(7, 86, 14 + y, TILE_BOMB_BAG_UPGRADE, 8, OP_OPAQUE);
      Screen->DrawString(7, 94, y + 14 - Text->FontHeight(FONT_LA) - 2, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, numBombUpgradesBuf, OP_OPAQUE, SHD_SHADOWED, C_BLACK);
      
      Screen->FastTile(7, 86, 44 + y, TILE_QUIVER_UPGRADE, 8, OP_OPAQUE);
      Screen->DrawString(7, 94, y + 44 - Text->FontHeight(FONT_LA) - 2, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, numQuiverUpgradesBuf, OP_OPAQUE, SHD_SHADOWED, C_BLACK);
      
      // Dungeon Item Draws
      for(int q = 0; q < NUM_SUBSCR_DUNGEON_ITEMS; ++q) {
         int id = checkId(dungeonItemIds[q]);
         
         unless(id) 
            continue;
            
         drawTileToLoc(1, loadItemTile(id), loadItemCSet(id), dungeonItemX[q], dungeonItemY[q], y);
      }

      //start Misc draws
      // Legionnaire Ring
      Screen->FastTile(4, 122, y + 84, TILE_LEGIONNAIRE_RING, CSET_LEGIONNAIRE_RING, OP_OPAQUE);
      counter(RT_SCREEN, 4, 141, y + 88, CR_LEGIONNAIRE_RING, SUBSCR_COUNTER_FONT, C_SUBSCR_COUNTER_TEXT, C_SUBSCR_COUNTER_BG, TF_NORMAL, 2, CNTR_USES_0);
      
      // Leviathan Scale	
      if(Hero->Item[183])
         Screen->FastTile(4, 110, y + 6, TILE_LEVIATHAN_SCALE, CSET_LEVIATHAN_SCALE, OP_OPAQUE);
      
      // Toxic Forest Key
      if(Hero->Item[184])
         Screen->FastTile(4, 110, y + 24, TILE_TOXIC_FOREST_KEY, CSET_TOXIC_FOREST_KEY, OP_OPAQUE);
      
      // Guard Tower Key
      if(Hero->Item[202])
         Screen->FastTile(4, 110, y + 24, TILE_GUARD_TOWER_KEY, CSET_GUARD_TOWER_KEY, OP_OPAQUE);
      
      //Allegiance Signet
      if(Hero->Item[206])
         Screen->FastTile(4, 130, y + 6, TILE_ALLEGIANCE_SIGNET, CSET_ALLEGIANCE_SIGNET, OP_OPAQUE);
      
      //Mysterious Key
      if(Hero->Item[207])
         Screen->FastTile(4, 110, y + 24, TILE_MYSTERIOUS_KEY, CSET_MYSTERIOUS_KEY, OP_OPAQUE);
      
      // Main Trading Sequence items
      int itemId = GetHighestLevelItemOwned(IC_TRADING_SEQ);
      
      if(itemId > -1) {
         itemdata tradingItem = Game->LoadItemData(GetHighestLevelItemOwned(IC_TRADING_SEQ));
         Screen->FastTile(4, 22, y + 140, tradingItem->Tile, tradingItem->CSet, OP_OPAQUE);    
      }
      //end 
      
      // Selected Item Name
      char32 buf2[30];
      itemdata idata = Game->LoadItemData(selectedId);
      
      if (idata)
         idata->GetName(buf2);
            
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
         else if(Input->Press[CB_B]) {
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
         Emily::DrawStrings(4, 62, y + 72, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, "Triforce of Courage", OP_OPAQUE, SHD_SHADOWED, C_BLACK, 0, 120);
      if (currTriforceIndex == 1)
         Emily::DrawStrings(4, 62, y + 72, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, "Triforce of Power", OP_OPAQUE, SHD_SHADOWED, C_BLACK, 0, 120);
      if (currTriforceIndex == 2)
         Emily::DrawStrings(4, 62, y + 72, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, "Triforce of Wisdom", OP_OPAQUE, SHD_SHADOWED, C_BLACK, 0, 120);
      if (currTriforceIndex == 3 && Game->GetCurDMap() != 2)
         Emily::DrawStrings(4, 62, y + 72, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, "Triforce of Death", OP_OPAQUE, SHD_SHADOWED, C_BLACK, 0, 120);
         
      Screen->DrawTile(0, 14, 80 + y, triforceFrames[currTriforceIndex], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
      
      switch(currTriforceIndex) {
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
}

int loadItemTile(int itemId) {
   unless(itemId > 0) 
      return TILE_INVIS;
      
   itemdata i = Game->LoadItemData(itemId);
   int frameNum = 0;
   
   if(i->ASpeed > 0 && i->AFrames > 0) {
      int temp = (gameframe % ((i->ASpeed * i->AFrames) + (i->ASpeed * i->Delay))) - (i->Delay * i->ASpeed);
      
      if(temp >= 0)
         frameNum = Floor(temp / i->ASpeed);
   }
   
   return i->Tile + frameNum;
}

int loadItemCSet(int itemId) {
   unless(itemId > 0) 
      return 0;
   
   return Game->LoadItemData(itemId)->CSet;
}

int checkId(int id) {
   if (id == -1)
      return 0;
      
   if(id < 0) {
      id = -id;
      
      unless(id && Hero->Item[id]) 
         return 0;
   } else {
      int fam = id;
      id = 0;
      
      switch(fam) {
         case IC_BOSSKEY:
            if (isOverworld(true))
               return 0;
            
            if(Game->LItems[Game->GetCurLevel()] & LI_BOSSKEY)
               id = I_BOSSKEY;
            break;
         case IC_MAP:
            if (isOverworld(true))
               return 0;
            
            if(Game->LItems[Game->GetCurLevel()] & LI_MAP)
               id = I_MAP;
            break;
         case IC_COMPASS:
            if (isOverworld(true))
               return 0;
            
            if(Game->LItems[Game->GetCurLevel()] & LI_COMPASS)
               id = I_COMPASS;
            break;		
         default:
            id = GetHighestLevelItemOwned(fam);
            switch(fam) {
               case IC_BOMB:
                  unless(Game->Counter[CR_BOMBS])
                     return 0;
                  break;
               case IC_SBOMB:
                  unless(Game->Counter[CR_SBOMBS])
                     return 0;
                  break;
               case IC_POTION:
                  unless (id > 0)
                     id = GetHighestLevelItemOwned(IC_LETTER);
                  break;
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
            
         unless(id > 0) 
            return 0;
      }
   }
   return id;
} //end

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
   
