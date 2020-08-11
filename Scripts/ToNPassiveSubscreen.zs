///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~The Terror of Necromancy Passive Subscreen~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

CONFIG BG_MAP1 = 6;
CONFIG BG_SCREEN1 = 0x0F;

@Author("Venrob")
dmapdata script PassiveSubscreen
{
	using namespace time;
	void run() //start
	{
		Trace(Hero->ItemA);
		bitmap bm = Game->CreateBitmap(256,56);
		bm->ClearToColor(0, BG_COLOR);
		bm->DrawScreen(0, BG_MAP1, BG_SCREEN1, 0, 0, 0); //Draw BG screen
		//Do any other draws to the bitmap here
		
		int lastButton = -1;
		int lastA = Hero->ItemA;
		int lastB = Hero->ItemB;
		
		while(true)
		{
			//start Button Forcing
			if (Hero->ItemA > -1 && Hero->ItemA != checkID(Game->LoadItemData(Hero->ItemA)->Type))
				forceButton(CB_A);
				
			if (Hero->ItemB > -1 && Hero->ItemB != checkID(Game->LoadItemData(Hero->ItemB)->Type))
				forceButton(CB_B); 
		
			if (Input->Press[CB_A])
				lastButton = CB_A;
			else if (Input->Press[CB_B])
				lastButton = CB_B;
				
			if ((lastButton == CB_A && lastA != Hero->ItemA) || (lastButton == CB_B && lastB != Hero->ItemB))
			{
				if (lastButton == CB_A && Game->LoadItemData(lastA)->Type == IC_POTION)
				{
					int id = checkID(IC_POTION);
					if (id)
						Hero->ItemA = id;
				}
				else if (lastButton == CB_B && Game->LoadItemData(lastB)->Type == IC_POTION)
				{
					int id = checkID(IC_POTION);
					if (id)
						Hero->ItemB = id;
				}
				
				if (Hero->ItemA == Hero->ItemB)
					forceButton(lastButton);
			} //end
			
			unless(subscr_open) //start Cycling; Not while the active subscreen is open
			{
				if(Input->Press[CB_L]) //start Left Cycle
				{
					int pos = 0;
					if(Hero->ItemB > 0)
					{
						for(int q = 0; q < NUM_SUBSCR_SEL_ITEMS; ++q)
						{
							if(checkID(itemIDs[q]) == Hero->ItemB)
							{
								pos = q;
								break;
							}
						}
					}
					int spos = pos;
					--pos; if(pos < 0) pos = NUM_SUBSCR_SEL_ITEMS - 1;
					int id = checkID(itemIDs[pos]);
					until(id && id != Hero->ItemA)
					{
						--pos; if(pos < 0) pos = NUM_SUBSCR_SEL_ITEMS - 1;
						id = checkID(itemIDs[pos]);
						if(pos == spos)
							break;
					}
					if(id)
						Hero->ItemB = id;
				} //end
				else if(Input->Press[CB_R]) //start Right Cycle
				{
					int pos = NUM_SUBSCR_SEL_ITEMS - 1;
					if(Hero->ItemB > 0)
					{
						for(int q = 0; q < NUM_SUBSCR_SEL_ITEMS; ++q)
						{
							if(checkID(itemIDs[q]) == Hero->ItemB)
							{
								pos = q;
								break;
							}
						}
					}
					int spos = pos;
					++pos; if(pos >= NUM_SUBSCR_SEL_ITEMS) pos = 0;
					int id = checkID(itemIDs[pos]);
					printf("First ID found on right cycle: pos %d, id %d\n", pos, id);
					until(id && id != Hero->ItemA)
					{
						if(id == Hero->ItemA) TraceS("id == ItemA; continuing\n");
						++pos; if(pos >= NUM_SUBSCR_SEL_ITEMS) pos = 0;
						id = checkID(itemIDs[pos]);
						printf("Nth ID found on right cycle: pos %d, id %d\n", pos, id);
						if(pos == spos)
							break;
					}
					if(id)
						Hero->ItemB = id;
				} //end
			} //end
			
			// if (Input->KeyPress[KEY_J])
				// Game->LItems[Game->GetCurLevel()] |= LI_BOSS;
				
			Waitdraw();
			do_psub_frame(bm, subscr_y_offset+168);
			
			lastA = Hero->ItemA;
			lastB = Hero->ItemB;
			
			Waitframe();
		}
	} //end
	
	void do_psub_frame(bitmap bm, int y)
	{
		Screen->Rectangle(7, 0, y, 255, y + 55, BG_COLOR, 1, 0, 0, 0, true, OP_OPAQUE);
		bm->Blit(7, RT_SCREEN, 0, 0, 256, 56, 0, y, 256, 56, 0, 0, 0, BITDX_NORMAL, 0, true); //Draw the BG bitmap to the screen
		//start Counters
		//Rupees
		minitile(RT_SCREEN, 7, 134, y+4, 32780, 1, 0);
		counter(RT_SCREEN, 7, 134+10, y+4, CR_RUPEES, SUBSCR_COUNTER_FONT, C_SUBSCR_COUNTER_TEXT, C_SUBSCR_COUNTER_BG, TF_NORMAL, 3, CNTR_USES_0);
		minitile(RT_SCREEN, 7, 134, y+14, 32780, 1, 1);
		counter(RT_SCREEN, 7, 134+10, y+14, CR_BOMBS, SUBSCR_COUNTER_FONT, C_SUBSCR_COUNTER_TEXT, C_SUBSCR_COUNTER_BG, TF_NORMAL, 2, CNTR_USES_0);
		minitile(RT_SCREEN, 7, 134, y+24, 32780, 1, 3);
		counter(RT_SCREEN, 7, 134+10, y+24, CR_SBOMBS, SUBSCR_COUNTER_FONT, C_SUBSCR_COUNTER_TEXT, C_SUBSCR_COUNTER_BG, TF_NORMAL, 2, CNTR_USES_0);
		minitile(RT_SCREEN, 7, 134, y+34, 32780, 1, 2);
		counter(RT_SCREEN, 7, 134+10, y+34, CR_ARROWS, SUBSCR_COUNTER_FONT, C_SUBSCR_COUNTER_TEXT, C_SUBSCR_COUNTER_BG, TF_NORMAL, 2, CNTR_USES_0);
		minitile(RT_SCREEN, 7, 134, y+44, 32800, 1, 0);
		counter(RT_SCREEN, 7, 134+10, y+44, Game->GetCurLevel() ? -Game->GetCurLevel() : MAX_INT, SUBSCR_COUNTER_FONT, C_SUBSCR_COUNTER_TEXT, C_SUBSCR_COUNTER_BG, TF_NORMAL, 2, CNTR_USES_0);
		//end Counters
		//start Buttons
		//Frames
		Screen->DrawTile(7, 82, y+18, TILE_SUBSCR_BUTTON_FRAME, 2, 2, 11, -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
		Screen->DrawTile(7, 105, y+18, TILE_SUBSCR_BUTTON_FRAME, 2, 2, 11, -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
		//Labels
		Screen->FastTile(7, 87, y+5, 1288, 0, OP_OPAQUE);
		Screen->FastTile(7, 110, y+5, 1268, 0, OP_OPAQUE);
		//Items
		Screen->FastTile(7, 86, y + 26, loadItemTile(Hero->ItemB), loadItemCSet(Hero->ItemB), OP_OPAQUE);
		Screen->FastTile(7, 109, y + 26, loadItemTile(Hero->ItemA), loadItemCSet(Hero->ItemA), OP_OPAQUE);
		//end Buttons
		//start Life Meter
		heart(RT_SCREEN, 7, 171, y+36,  0, TILE_HEARTS);
		heart(RT_SCREEN, 7, 177, y+36,  1, TILE_HEARTS);
		heart(RT_SCREEN, 7, 183, y+36,  2, TILE_HEARTS);
		heart(RT_SCREEN, 7, 189, y+36,  3, TILE_HEARTS);
		heart(RT_SCREEN, 7, 195, y+36,  4, TILE_HEARTS);
		heart(RT_SCREEN, 7, 201, y+36,  5, TILE_HEARTS);
		heart(RT_SCREEN, 7, 207, y+36,  6, TILE_HEARTS);
		heart(RT_SCREEN, 7, 213, y+36,  7, TILE_HEARTS);
		heart(RT_SCREEN, 7, 219, y+36,  8, TILE_HEARTS);
		heart(RT_SCREEN, 7, 225, y+36,  9, TILE_HEARTS);
		heart(RT_SCREEN, 7, 174, y+29, 10, TILE_HEARTS);
		heart(RT_SCREEN, 7, 180, y+29, 11, TILE_HEARTS);
		heart(RT_SCREEN, 7, 186, y+29, 12, TILE_HEARTS);
		heart(RT_SCREEN, 7, 192, y+29, 13, TILE_HEARTS);
		heart(RT_SCREEN, 7, 198, y+29, 14, TILE_HEARTS);
		heart(RT_SCREEN, 7, 204, y+29, 15, TILE_HEARTS);
		heart(RT_SCREEN, 7, 210, y+29, 16, TILE_HEARTS);
		heart(RT_SCREEN, 7, 216, y+29, 17, TILE_HEARTS);
		heart(RT_SCREEN, 7, 222, y+29, 18, TILE_HEARTS);
		heart(RT_SCREEN, 7, 228, y+29, 19, TILE_HEARTS);
		heart(RT_SCREEN, 7, 177, y+22, 20, TILE_HEARTS);
		heart(RT_SCREEN, 7, 183, y+22, 21, TILE_HEARTS);
		heart(RT_SCREEN, 7, 189, y+22, 22, TILE_HEARTS);
		heart(RT_SCREEN, 7, 195, y+22, 23, TILE_HEARTS);
		heart(RT_SCREEN, 7, 201, y+22, 24, TILE_HEARTS);
		heart(RT_SCREEN, 7, 207, y+22, 25, TILE_HEARTS);
		heart(RT_SCREEN, 7, 213, y+22, 26, TILE_HEARTS);
		heart(RT_SCREEN, 7, 219, y+22, 27, TILE_HEARTS);
		heart(RT_SCREEN, 7, 225, y+22, 28, TILE_HEARTS);
		heart(RT_SCREEN, 7, 231, y+22, 29, TILE_HEARTS);
		//end Life Meter
		//start Magic Meter
		int perc = Game->Counter[CR_MAGIC] / Game->MCounter[CR_MAGIC];
		Screen->DrawTile(7, 162, y+44, TILE_MAGIC_METER + (Game->Generic[GEN_MAGICDRAINRATE] < 2 ? 20 : 0), MAGIC_METER_TILE_WIDTH, 1, 0, -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
		if(MAGIC_METER_PIX_WIDTH*perc >= 0.5)
			Screen->Rectangle(7, 162+MAGIC_METER_FILL_XOFF,                                   y+44+MAGIC_METER_FILL_YOFF,
			                     162+MAGIC_METER_FILL_XOFF+Round(MAGIC_METER_PIX_WIDTH*perc), y+44+MAGIC_METER_FILL_YOFF+MAGIC_METER_PIX_HEIGHT,
								 C_MAGIC_METER_FILL, 1, 0, 0, 0, true, OP_OPAQUE);
		//end Magic Meter
		//start Clock
		char32 buf[16];
		sprintf(buf, "%d:%02d:%02d",Hours(),Minutes(),Seconds());
		Screen->DrawString(7, 224, y+3, SUBSCR_COUNTER_FONT, C_SUBSCR_COUNTER_TEXT, C_SUBSCR_COUNTER_BG, TF_RIGHT, buf, OP_OPAQUE, SHD_SHADOWED, C_BLACK);
		//end Clock
		//start Minimap
		ScreenType ow = getScreenType(true);
		int mm_tile = ow == DM_OVERWORLD ? TILE_MINIMAP_OW_BG : TILE_MINIMAP_DNGN_BG;
		int cs = 0;
		dmapdata dm = Game->LoadDMapData(Game->GetCurDMap());
		bool hasMap = Game->LItems[Game->GetCurLevel()] & LI_MAP;
		if(hasMap && dm->MiniMapTile[1])
		{
			mm_tile = dm->MiniMapTile[1];
			cs = dm->MiniMapCSet[1];
		}
		else if(dm->MiniMapTile[0] && !hasMap)
		{
			mm_tile = dm->MiniMapTile[0];
			cs = dm->MiniMapCSet[0];
		}
		Screen->DrawTile(7, 0, y+8, mm_tile, 5, 3, cs, -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
		minimap(RT_SCREEN, 7, 0, y+8, ow);
		//end Minimap
		//start DMap Title
		char32 titlebuf[80];
		Game->GetDMapTitle(dm->ID, titlebuf);
		int index;
		int lastLetter;
		bool wasSpace = true;
		
		for (int q = 0; q < 80; ++q)
		{
			if (titlebuf[q] == ' ')
			{
				unless (wasSpace)
					wasSpace = true;
				else
					continue;
			}
			else
			{
				lastLetter = q;
				wasSpace = false;
			}
			
			titlebuf[index++] = titlebuf[q];
		}
		
		for (int q = lastLetter + 1; q < 80; ++q)
			titlebuf[q] = 0;
		
		Screen->DrawString(7, 41, y+2, SUBSCR_DMAPTITLE_FONT, C_SUBSCR_COUNTER_TEXT, C_SUBSCR_COUNTER_BG,
		                   TF_CENTERED, titlebuf, OP_OPAQUE, SHD_SHADOWED, C_BLACK);
		//end DMap Title
	}
}

void counter(untyped bit, int layer, int x, int y, int cntr, int font, Color color, Color bgcolor, int format, int min_digits, bool show_zeroes) //start
{
	char32 buf[16];
	int chr = cntr < 0 ? itoa(buf, Game->LKeys[-cntr]) : (cntr == MAX_INT ? itoa(buf, Game->LKeys[0]) : itoa(buf, Game->Counter[cntr]));
	unless(chr)
		buf[chr++] = '0';
	char32 spcbuf[16];
	for(int q = 0; q < min_digits-chr; ++q)
		spcbuf[q] = show_zeroes ? '0' : ' ';
	sprintf(buf, "%s%s", spcbuf, buf);
	if(bit == RT_SCREEN)
		Screen->DrawString(layer, x, y, font, color, bgcolor, format, buf, OP_OPAQUE, SHD_SHADOWED, C_BLACK);
	else <bitmap>(bit)->DrawString(layer, x, y, font, color, bgcolor, format, buf, OP_OPAQUE, SHD_SHADOWED, C_BLACK);
} //end

void heart(untyped bit, int layer, int x, int y, int num, int baseTile) //start
{
	if(Game->MCounter[CR_LIFE] < (num*16+1)) return;
	int shift = (Game->Counter[CR_LIFE] >= (num+1)*16)
	            ? 4
				: (Game->Counter[CR_LIFE] < (num*16)
				  ? 0
	              : Div(Game->Counter[CR_LIFE] % HP_PER_HEART, HP_PER_HEART/4));
	if(bit == RT_SCREEN)
		Screen->FastTile(layer, x, y, baseTile+shift, 0, OP_OPAQUE);
	else
		<bitmap>(bit)->FastTile(layer, x, y, baseTile+shift, 0, OP_OPAQUE);
} //end

void minimap(untyped bit, int layer, int orig_x, int orig_y, ScreenType ow) //start
{
	if(ow == DM_OVERWORLD)
	{
		int scr = Game->GetCurScreen();
		int x = orig_x + 9 + (4*(scr%0x010));
		int y = orig_y + 8 + (4*Div(scr, 0x010));
		if(bit == RT_SCREEN)
			Screen->Rectangle(layer, x, y, x+2, y+2, C_MINIMAP_LINK, 1, 0, 0, 0, true, OP_OPAQUE);
		else
			<bitmap>(bit)->Rectangle(layer, x, y, x+2, y+2, C_MINIMAP_LINK, 1, 0, 0, 0, true, OP_OPAQUE);
	}
	else
	{
		bool hasMap = Game->LItems[Game->GetCurLevel()] & LI_MAP;
		bool hasCompass = Game->LItems[Game->GetCurLevel()] & LI_COMPASS;
		bool killedBoss = Game->LItems[Game->GetCurLevel()] & LI_BOSS;
		dmapdata dm = Game->LoadDMapData(Game->GetCurDMap());
		orig_x += 8;
		orig_y += 8;
		int offs = Game->DMapOffset[Game->GetCurDMap()];
		int curscr = Game->GetCurDMapScreen();
		
		int lim = 8 - Max(offs - 8, 0);
		int low_lim = -Min(offs, 0);
		
		for(int q = 0; q < 128; ++q)
		{			
			if(q % 0x10 >= lim)
				continue;
			if(q % 0x10 < low_lim)
				continue;
			
			Color c = C_TRANS;
			Color sm_c = C_TRANS;
			int x = orig_x + (8*(q%0x010));
			int y = orig_y + (4*Div(q, 0x010));
			
			if((gameframe & 100000b || killedBoss) && hasCompass && q+offs == dm->Compass)
			{
				sm_c = killedBoss ? C_MINIMAP_COMPASS_DEFEATED : C_MINIMAP_COMPASS;
			}
			else if(q == curscr)
			{
				sm_c = C_MINIMAP_LINK;
			}
			unless (ow == DM_BSOVERWORLD)
			{
				mapdata m = Game->LoadMapData(Game->GetCurMap(), q+offs);
				if(m->State[ST_VISITED])
				{
					c = C_MINIMAP_EXPLORED;
				}
				else if(hasMap && dmapinfo::VisibleOnDungeonMap(q, true))
				{
					c = C_MINIMAP_ROOM;
				}
			}
			if(c)
			{
				if(bit == RT_SCREEN)
				{			
					Screen->Rectangle(layer, x, y, x+6, y+2, c, 1, 0, 0, 0, true, OP_OPAQUE);	
				}
				else
				{
					<bitmap>(bit)->Rectangle(layer, x, y, x+6, y+2, c, 1, 0, 0, 0, true, OP_OPAQUE);					
				}
			}
			if(sm_c)
			{
				if(bit == RT_SCREEN)
				{			
					Screen->Rectangle(layer, x+2, y, x+4, y+2, sm_c, 1, 0, 0, 0, true, OP_OPAQUE);	
				}
				else
				{
					<bitmap>(bit)->Rectangle(layer, x+2, y, x+4, y+2, sm_c, 1, 0, 0, 0, true, OP_OPAQUE);					
				}
			}
		}
	}
} //end

void forceButton(int button) //start
{
	for (int q = 0; q < NUM_SUBSCR_SEL_ITEMS; ++q)
	{
		int id = checkID(itemIDs[q]);
		if (id)
		{
			if (button == CB_A)
			{
				if(id != Hero->ItemB)
				{
					Hero->ItemA = id;
					break;
				}
			}
			else if (id != Hero->ItemA)
			{
				Hero->ItemB = id;
				break;
			}
		}
	}
} //end





























