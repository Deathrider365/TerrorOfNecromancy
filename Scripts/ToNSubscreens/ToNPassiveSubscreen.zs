///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~The Terror of Necromancy PassiveSubscreen~~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

@Author("EmilyV99")
dmapdata script PassiveSubscreen {
   using namespace time;

	void run() {
      bitmap bm = Game->CreateBitmap(256, 56);
      bm->DrawScreen(0, BG_MAP1, BG_SCREEN1, 0, 0, 0); 
      
      int lastButton = -1;
      int lastA = Hero->ItemA;
      int lastB = Hero->ItemB;
      
      while(true) {
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
               } until (id && id != Hero->ItemA)
               
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
               } until(id && id != Hero->ItemA)
               
               if (Hero->ItemA != id && id) {
                  Hero->ItemB = id;
                  lastB = id;
               }
            }
         }
            
         Waitdraw();
         doPassiveMenuFrame(bm, subscr_y_offset + 168);
         
         lastA = Hero->ItemA;
         lastB = Hero->ItemB;
         
         Waitframe();
         
         while(Game->Suspend[susptSUBSCREENSCRIPTS])
            Waitframe();
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
      
      bm->Blit(7, RT_SCREEN, 0, 0, 256, 56, 0, y, 256, 56, 0, 0, 0, BITDX_NORMAL, 0, true); //Draw the BG bitmap to the screen
      
      // Counters
      minitile(RT_SCREEN, 7, 134, y + 4, 32780, 0, 0);
      counter(RT_SCREEN, 7, 134 + 10, y + 4, CR_RUPEES, SUBSCR_COUNTER_FONT, C_SUBSCR_COUNTER_TEXT, C_SUBSCR_COUNTER_BG, TF_NORMAL, 3, CNTR_USES_0);
      minitile(RT_SCREEN, 7, 134, y + 14, 32780, 0, 1);
      counter(RT_SCREEN, 7, 134 + 10, y + 14, CR_BOMBS, SUBSCR_COUNTER_FONT, C_SUBSCR_COUNTER_TEXT, C_SUBSCR_COUNTER_BG, TF_NORMAL, 2, CNTR_USES_0);
      minitile(RT_SCREEN, 7, 134, y + 24, 32780, 0, 3);
      counter(RT_SCREEN, 7, 134 + 10, y + 24, CR_SBOMBS, SUBSCR_COUNTER_FONT, C_SUBSCR_COUNTER_TEXT, C_SUBSCR_COUNTER_BG, TF_NORMAL, 2, CNTR_USES_0);
      minitile(RT_SCREEN, 7, 134, y + 34, 32780, 0, 2);
      counter(RT_SCREEN, 7, 134 + 10, y + 34, CR_ARROWS, SUBSCR_COUNTER_FONT, C_SUBSCR_COUNTER_TEXT, C_SUBSCR_COUNTER_BG, TF_NORMAL, 2, CNTR_USES_0);
      minitile(RT_SCREEN, 7, 134, y + 44, 32800, 0, 0);
      counter(RT_SCREEN, 7, 134 + 10, y + 44, Game->GetCurLevel() ? -Game->GetCurLevel() : MAX_INT, SUBSCR_COUNTER_FONT, C_SUBSCR_COUNTER_TEXT, C_SUBSCR_COUNTER_BG, TF_NORMAL, 2, CNTR_USES_0);
      
      // Buttons
      //Frames
      Screen->DrawTile(7, 82, y + 18, TILE_SUBSCR_BUTTON_FRAME, 2, 2, 11, -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
      Screen->DrawTile(7, 105, y + 18, TILE_SUBSCR_BUTTON_FRAME, 2, 2, 11, -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
      //Labels
      Screen->FastTile(7, 87, y + 5, 1288, 0, OP_OPAQUE);
      Screen->FastTile(7, 110, y + 5, 1268, 0, OP_OPAQUE);
      //Items
      Screen->FastTile(7, 86, y + 26, loadItemTile(Hero->ItemB), loadItemCSet(Hero->ItemB), OP_OPAQUE);
      Screen->FastTile(7, 109, y + 26, loadItemTile(Hero->ItemA), loadItemCSet(Hero->ItemA), OP_OPAQUE);
      
      //start Life Meter		
      heart(RT_SCREEN, 7, 171, y + 36,  0, TILE_HEARTS);
      heart(RT_SCREEN, 7, 177, y + 36,  1, TILE_HEARTS);
      heart(RT_SCREEN, 7, 183, y + 36,  2, TILE_HEARTS);
      heart(RT_SCREEN, 7, 189, y + 36,  3, TILE_HEARTS);
      heart(RT_SCREEN, 7, 195, y + 36,  4, TILE_HEARTS);
      heart(RT_SCREEN, 7, 201, y + 36,  5, TILE_HEARTS);
      heart(RT_SCREEN, 7, 207, y + 36,  6, TILE_HEARTS);
      heart(RT_SCREEN, 7, 213, y + 36,  7, TILE_HEARTS);
      heart(RT_SCREEN, 7, 219, y + 36,  8, TILE_HEARTS);
      heart(RT_SCREEN, 7, 225, y + 36,  9, TILE_HEARTS);
      heart(RT_SCREEN, 7, 174, y + 29, 10, TILE_HEARTS);
      heart(RT_SCREEN, 7, 180, y + 29, 11, TILE_HEARTS);
      heart(RT_SCREEN, 7, 186, y + 29, 12, TILE_HEARTS);
      heart(RT_SCREEN, 7, 192, y + 29, 13, TILE_HEARTS);
      heart(RT_SCREEN, 7, 198, y + 29, 14, TILE_HEARTS);
      heart(RT_SCREEN, 7, 204, y + 29, 15, TILE_HEARTS);
      heart(RT_SCREEN, 7, 210, y + 29, 16, TILE_HEARTS);
      heart(RT_SCREEN, 7, 216, y + 29, 17, TILE_HEARTS);
      heart(RT_SCREEN, 7, 222, y + 29, 18, TILE_HEARTS);
      heart(RT_SCREEN, 7, 228, y + 29, 19, TILE_HEARTS);
      heart(RT_SCREEN, 7, 177, y + 22, 20, TILE_HEARTS);
      heart(RT_SCREEN, 7, 183, y + 22, 21, TILE_HEARTS);
      heart(RT_SCREEN, 7, 189, y + 22, 22, TILE_HEARTS);
      heart(RT_SCREEN, 7, 195, y + 22, 23, TILE_HEARTS);
      heart(RT_SCREEN, 7, 201, y + 22, 24, TILE_HEARTS);
      heart(RT_SCREEN, 7, 207, y + 22, 25, TILE_HEARTS);
      heart(RT_SCREEN, 7, 213, y + 22, 26, TILE_HEARTS);
      heart(RT_SCREEN, 7, 219, y + 22, 27, TILE_HEARTS);
      heart(RT_SCREEN, 7, 225, y + 22, 28, TILE_HEARTS);
      heart(RT_SCREEN, 7, 231, y + 22, 29, TILE_HEARTS);
      //end
      
      // Magic Meter TODO IMPROVE THIS
      int perc = Game->Counter[CR_MAGIC] / Game->MCounter[CR_MAGIC];
      Screen->DrawTile(7, 162, y + 44, TILE_MAGIC_METER + (Game->Generic[GEN_MAGICDRAINRATE] < 2 ? 20 : 0), MAGIC_METER_TILE_WIDTH, 1, 0, -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
      
      if (MAGIC_METER_PIX_WIDTH * perc >= 0.5)
         Screen->Rectangle(7, 162 + MAGIC_METER_FILL_XOFF,                                       y + 44 + MAGIC_METER_FILL_YOFF,
                              162 + MAGIC_METER_FILL_XOFF + Round(MAGIC_METER_PIX_WIDTH * perc), y + 44 + MAGIC_METER_FILL_YOFF + MAGIC_METER_PIX_HEIGHT,
                              C_MAGIC_METER_FILL, 1, 0, 0, 0, true, OP_OPAQUE);
                              
      drawDifficultyItem(y);
      
      char32 buf[16];
      sprintf(buf, "%d:%02d:%02d", Hours(), Minutes(), Seconds());
      
      if (y > -55)
         Screen->DrawString(7, 234, y+3, SUBSCR_COUNTER_FONT, C_SUBSCR_COUNTER_TEXT, C_SUBSCR_COUNTER_BG, TF_RIGHT, buf, OP_OPAQUE, SHD_SHADOWED, C_BLACK);
      
      //start Minimap
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
      //end
      
      //start DMap Title
      char32 titlebuf[80];
      Game->GetDMapTitle(dmap->ID, titlebuf);
      int index;
      int lastLetter;
      bool wasSpace = true;
      
      for (int q = 0; q < 80; ++q) {
         if (titlebuf[q] == ' ') {
            unless (wasSpace)
               wasSpace = true;
            else
               continue;
         } else {
            lastLetter = q;
            wasSpace = false;
         }
         
         titlebuf[index++] = titlebuf[q];
      }
      
      for (int q = lastLetter + 1; q < 80; ++q)
         titlebuf[q] = 0;
      
      Emily::DrawStrings(7, 41, y + 2, SUBSCR_DMAPTITLE_FONT, C_SUBSCR_COUNTER_TEXT, C_SUBSCR_COUNTER_BG, TF_CENTERED, titlebuf, OP_OPAQUE, SHD_SHADOWED, C_BLACK, 1, 64);
      //end
   }
}

void counter(untyped bit, int layer, int x, int y, int cntr, int font, Color color, Color bgcolor, int format, int minDigits, bool showZeroes) {
   char32 buf[16];
   int chr = cntr < 0 ? itoa(buf, Game->LKeys[-cntr]) : (cntr == MAX_INT ? itoa(buf, Game->LKeys[0]) : itoa(buf, Game->Counter[cntr]));

   unless(chr)
      buf[chr++] = '0';
      
   char32 spcbuf[16];

   for (int q = 0; q < minDigits - chr; ++q)
      spcbuf[q] = showZeroes ? '0' : ' ';
      
   sprintf(buf, "%s%s", spcbuf, buf);

   if (bit == RT_SCREEN)
      Screen->DrawString(layer, x, y, font, color, bgcolor, format, buf, OP_OPAQUE, SHD_SHADOWED, C_BLACK);
   else 
      <bitmap>(bit)->DrawString(layer, x, y, font, color, bgcolor, format, buf, OP_OPAQUE, SHD_SHADOWED, C_BLACK);
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
   } else {
      bool hasMap = Game->LItems[Game->GetCurLevel()] & LI_MAP;
      bool hasCompass = Game->LItems[Game->GetCurLevel()] & LI_COMPASS;
      bool killedBoss = Game->LItems[Game->GetCurLevel()] & LI_BOSS;
      dmapdata currentDmap = Game->LoadDMapData(Game->GetCurDMap());
      
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
         
         if ((gameframe & 100000b || killedBoss) && hasCompass && q + dmapOffset == currentDmap->Compass)
            compassMarkerColor = killedBoss ? C_MINIMAP_COMPASS_DEFEATED : C_MINIMAP_COMPASS;
         else if (q == currentScreen)
            compassMarkerColor = C_MINIMAP_LINK;
            
         unless (dmap == DM_BSOVERWORLD) {
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
      } else {
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



























