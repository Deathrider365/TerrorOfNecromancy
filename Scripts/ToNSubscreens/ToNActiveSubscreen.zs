///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~~The Terror of Necromancy ActiveSubscreen~~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

// When I eventually have the quiver and bomb back items loaded here have a small bit of text on top
// that shows the bomb max and when I get bomb expansions update that max

//~~~~~ActiveSubscreen~~~~~//
@Author("EmilyV99, Modified by Deathrider365")
dmapdata script ActiveSubscreen //start
{
	void run()
	{
		if(Game->Suspend[susptSUBSCREENSCRIPTS]) return;
		subscr_open = true;
		bitmap b = Game->CreateBitmap(256, 224);
		b->ClearToColor(0, BG_COLOR);
		b->DrawScreen(0, BG_MAP, BG_SCREEN, 0, 0, 0); //Draw BG screen
		//Do any other draws to the bitmap here
		
		for(subscr_y_offset = -224; subscr_y_offset < -56; subscr_y_offset += SCROLL_SPEED)
		{
			//Waitdraw();
			do_asub_frame(b, subscr_y_offset, false);
			Waitframe();
		}
		
		subscr_y_offset = -56;
		
		do
		{
			//Waitdraw();
			do_asub_frame(b, subscr_y_offset, true);
			Waitframe();
		}
		until(Input->Press[CB_START]);
		
		for(subscr_y_offset = -56; subscr_y_offset > -224; subscr_y_offset -= SCROLL_SPEED)
		{
			//Waitdraw();
			do_asub_frame(b, subscr_y_offset, false);
			Waitframe();
		}
		subscr_y_offset = -224;
		subscr_open = false;
	}
} //end

void do_asub_frame(bitmap b, int y, bool isActive) //start
{
	gameframe = (gameframe + 1) % 3600;
	b->Blit(0, RT_SCREEN, 0, 0, 256, 168, 0, y, 256, 168, 0, 0, 0, BITDX_NORMAL, 0, true); //Draw the BG bitmap to the screen
	
	//start Handle asubscr_position movement
	if(isActive)
	{
		if(Input->Press[CB_LEFT])
		{
			Audio->PlaySound(CURSOR_MOVEMENT_SFX);
			--asubscr_pos;
		}
		else if(Input->Press[CB_RIGHT])
		{
			Audio->PlaySound(CURSOR_MOVEMENT_SFX);
			++asubscr_pos;
		}
		else if(Input->Press[CB_UP])
		{
			Audio->PlaySound(CURSOR_MOVEMENT_SFX);
			asubscr_pos -= 4;
		}
		else if(Input->Press[CB_DOWN])
		{
			Audio->PlaySound(CURSOR_MOVEMENT_SFX);
			asubscr_pos += 4;
		}
		
		if(Input->Press[CB_L])
		{
			Audio->PlaySound(TRIFORCE_CYCLE_SFX);
			--currTriforceIndex;
		}
		else if(Input->Press[CB_R])
		{
			Audio->PlaySound(TRIFORCE_CYCLE_SFX);
			++currTriforceIndex;
		}
			
		if(asubscr_pos < 0)
			asubscr_pos += (4 * 6);
		else 
			asubscr_pos %= (4 * 6);
		
		unless(Game->GetCurDMap() == 2)
		{
			if(currTriforceIndex == -1)
				currTriforceIndex = 3;
			else if (currTriforceIndex == 4)
				currTriforceIndex = 0;
		}
		else
		{
			if(currTriforceIndex == -1)
				currTriforceIndex = 2;
			else if (currTriforceIndex == 3)
				currTriforceIndex = 0;
		}
	}
	//end Handle asubscr_position movement
	
	//start Item Draws
	int selID = 0;
	
	for(int q = 0; q < NUM_SUBSCR_INAC_ITEMS; ++q) //start Non Selectable Items
	{
		int id = checkID(itemIDs[q]);
		
		unless(id) 
			continue;
			
		drawTileToLoc(1, loadItemTile(id), loadItemCSet(id), itemLocsX[q], itemLocsY[q], y);
	}
	//end
	
	for(int q = 0; q < NUM_SUBSCR_SEL_ITEMS; ++q) //start Selectable items
	{
		int id = checkID(itemIDs[q]);
		
		unless(id) 
			continue;
		
		if(q == asubscr_pos) 
			selID = id;
		
		drawTileToLoc(1, loadItemTile(id), loadItemCSet(id), itemLocsX[q], itemLocsY[q], y);
	}
	//end
	
	for(int q = 0; q < NUM_SUBSCR_DUNGEON_ITEMS; ++q) //start Dungeon Item Draws
	{
		int id = checkID(dungeonItemIds[q]);
		unless(id) 
			continue;
			
		drawTileToLoc(1, loadItemTile(id), loadItemCSet(id), dungeonItemX[q], dungeonItemY[q], y);
	}
	//end

	//start Legionnaire Ring
	Screen->FastTile(4, 122, y + 84, TILE_LEGIONNAIRE_RING, CSET_LEGIONNAIRE_RING, OP_OPAQUE);
	counter(RT_SCREEN, 4, 141, y + 88, CR_LEGIONNAIRE_RING, SUBSCR_COUNTER_FONT, C_SUBSCR_COUNTER_TEXT, C_SUBSCR_COUNTER_BG, TF_NORMAL, 2, CNTR_USES_0);
	//end Legionnaire Ring
	
	//start Leviathan Scale	
	if(Hero->Item[183])
		Screen->FastTile(4, 110, y + 6, TILE_LEVIATHAN_SCALE, CSET_LEVIATHAN_SCALE, OP_OPAQUE);
	//end Leviathan Scale
	
	//start Toxic Forest Key
	if(Hero->Item[184])
		Screen->FastTile(4, 110, y + 24, TILE_TOXIC_FOREST_KEY, CSET_TOXIC_FOREST_KEY, OP_OPAQUE);
	//end ale
	
	//start Main Trading Sequence items
	int itemId = GetHighestLevelItemOwned(IC_TRADING_SEQ);
    if(itemId > -1)
    {
        itemdata tradingItem = Game->LoadItemData(GetHighestLevelItemOwned(IC_TRADING_SEQ));
        Screen->FastTile(4, 22, y + 140, tradingItem->Tile, tradingItem->CSet, OP_OPAQUE);    
    }
	//end
	
	//start Selected Item Name
	char32 buf2[30];
	itemdata idata = Game->LoadItemData(selID);
	
	if (idata)
		idata->GetName(buf2);
			
	Emily::DrawStrings(4, 206, y + 7, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, buf2, OP_OPAQUE, SHD_SHADOWED, C_BLACK, 0, 80);
	//end Selected Item Name

	//start Cursor Stuff
	
	drawTileToLoc(7, loadItemTile(I_SELECTA), loadItemCSet(I_SELECTA), itemLocsX[asubscr_pos], itemLocsY[asubscr_pos], y);
	drawTileToLoc(7, loadItemTile(I_SELECTB), loadItemCSet(I_SELECTB), itemLocsX[asubscr_pos], itemLocsY[asubscr_pos], y);
	
	if(isActive && selID)
	{
		if(Input->Press[CB_A])
		{
			Audio->PlaySound(ITEM_SELECTION_SFX);
			
			if(Hero->ItemB == selID)
				Hero->ItemB = Hero->ItemA;
			Hero->ItemA = selID;
		}
		else if(Input->Press[CB_B])
		{
			Audio->PlaySound(ITEM_SELECTION_SFX);
			
			if(Hero->ItemA == selID)
				Hero->ItemA = Hero->ItemB;
			Hero->ItemB = selID;
		}
	}
	//end Cursor Stuff
	
	//start Other Tile Draws
	int leftArrowCombo = 7746;
	int rightArrowCombo = 7747;
	int LCombo = 7744;
	int RCombo = 7745;
	
	Screen->FastCombo(7, 4, 88 + y, leftArrowCombo, 0, OP_OPAQUE);
	Screen->FastCombo(7, 104, 88 + y, rightArrowCombo, 0, OP_OPAQUE);
	
	Screen->FastCombo(7, 4, 104 + y, LCombo, 0, OP_OPAQUE);
	Screen->FastCombo(7, 104, 104 + y, RCombo, 0, OP_OPAQUE);
	
	//end Other Tile Draws
	
	//start Handle Heart Pieces	
	Screen->FastTile(4, 122, y + 68, TILE_ZERO_PIECES + Game->Generic[GEN_HEARTPIECES], 8, OP_OPAQUE);
	counter(RT_SCREEN, 4, 141, y + 72, CR_HEARTPIECES, SUBSCR_COUNTER_FONT, C_SUBSCR_COUNTER_TEXT, C_SUBSCR_COUNTER_BG, TF_NORMAL, 2, CNTR_USES_0);
	//end Handle Heart Pieces

	//start Handle Triforce Frame Cycling / Drawing
	
	if (currTriforceIndex == 0)
		Emily::DrawStrings(4, 62, y + 72, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, "Triforce of Courage", OP_OPAQUE, SHD_SHADOWED, C_BLACK, 0, 120);
	if (currTriforceIndex == 1)
		Emily::DrawStrings(4, 62, y + 72, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, "Triforce of Power", OP_OPAQUE, SHD_SHADOWED, C_BLACK, 0, 120);
	if (currTriforceIndex == 2)
		Emily::DrawStrings(4, 62, y + 72, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, "Triforce of Wisdom", OP_OPAQUE, SHD_SHADOWED, C_BLACK, 0, 120);
	if (currTriforceIndex == 3 && Game->GetCurDMap() != 2)
		Emily::DrawStrings(4, 62, y + 72, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, "Triforce of Death", OP_OPAQUE, SHD_SHADOWED, C_BLACK, 0, 120);
		
	Screen->DrawTile(0, 14, 80 + y, triforceFrames[currTriforceIndex], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
		
	switch(currTriforceIndex)
	{
		case 0: //start Courage shard drawing
			switch(amountOfCourageTriforceShards)
			{
				case 1:
					Screen->DrawTile(0, 14, 80 + y, courageShards[0], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
					break;
				case 2:
					Screen->DrawTile(0, 14, 80 + y, courageShards[0], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
					Screen->DrawTile(0, 14, 80 + y, courageShards[1], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
					break;
				case 3:
					Screen->DrawTile(0, 14, 80 + y, courageShards[0], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
					Screen->DrawTile(0, 14, 80 + y, courageShards[1], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
					Screen->DrawTile(0, 14, 80 + y, courageShards[2], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
					break;
				case 4:
					Screen->DrawTile(0, 14, 80 + y, courageShards[0], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
					Screen->DrawTile(0, 14, 80 + y, courageShards[1], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
					Screen->DrawTile(0, 14, 80 + y, courageShards[2], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
					Screen->DrawTile(0, 14, 80 + y, courageShards[3], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
					break;
			}
			break; //end
		case 1: //start Power shard drawing
			switch(amountOfPowerTriforceShards)
			{
				case 1:
					Screen->DrawTile(0, 14, 80 + y, powerShards[0], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
					break;
				case 2:
					Screen->DrawTile(0, 14, 80 + y, powerShards[0], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
					Screen->DrawTile(0, 14, 80 + y, powerShards[1], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
					break;
				case 3:
					Screen->DrawTile(0, 14, 80 + y, powerShards[0], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
					Screen->DrawTile(0, 14, 80 + y, powerShards[1], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
					Screen->DrawTile(0, 14, 80 + y, powerShards[2], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
					break;
				case 4:
					Screen->DrawTile(0, 14, 80 + y, powerShards[0], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
					Screen->DrawTile(0, 14, 80 + y, powerShards[1], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
					Screen->DrawTile(0, 14, 80 + y, powerShards[2], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
					Screen->DrawTile(0, 14, 80 + y, powerShards[3], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
					break;
			}
			break; //end
		case 2: //start Wisdom shard drawing
			switch(amountOfWisdomTriforceShards)
			{
				case 1:
					Screen->DrawTile(0, 14, 80 + y, wisdomShards[0], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
					break;
				case 2:
					Screen->DrawTile(0, 14, 80 + y, wisdomShards[0], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
					Screen->DrawTile(0, 14, 80 + y, wisdomShards[1], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
					break;
				case 3:
					Screen->DrawTile(0, 14, 80 + y, wisdomShards[0], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
					Screen->DrawTile(0, 14, 80 + y, wisdomShards[1], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
					Screen->DrawTile(0, 14, 80 + y, wisdomShards[2], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
					break;
				case 4:
					Screen->DrawTile(0, 14, 80 + y, wisdomShards[0], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
					Screen->DrawTile(0, 14, 80 + y, wisdomShards[1], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
					Screen->DrawTile(0, 14, 80 + y, wisdomShards[2], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
					Screen->DrawTile(0, 14, 80 + y, wisdomShards[3], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
					break;
			}
			break; //end
		case 3: //start Death shard drawing
			unless (Game->GetCurDMap() == 2)
			{
				switch(amountOfDeathTriforceShards)
				{
					case 1:
						Screen->DrawTile(0, 14, 80 + y, deathShards[0], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
						break;
					case 2:
						Screen->DrawTile(0, 14, 80 + y, deathShards[0], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
						Screen->DrawTile(0, 14, 80 + y, deathShards[1], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
						break;
					case 3:
						Screen->DrawTile(0, 14, 80 + y, deathShards[0], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
						Screen->DrawTile(0, 14, 80 + y, deathShards[1], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
						Screen->DrawTile(0, 14, 80 + y, deathShards[2], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
						break;
					case 4:
						Screen->DrawTile(0, 14, 80 + y, deathShards[0], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
						Screen->DrawTile(0, 14, 80 + y, deathShards[1], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
						Screen->DrawTile(0, 14, 80 + y, deathShards[2], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
						Screen->DrawTile(0, 14, 80 + y, deathShards[3], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
						break;
				}
				break; 
			}//end
	}

	//end Handle Triforce Frame Cycling / Drawing
} //end do_asub_fram

int getAmountOfShards(int type) //start
{
	switch(type)
	{
		case 0:	// Courage shard item ids
			if (Link->Item[169])
				return 4;
			else if (Link->Item[168])
				return 3;
			else if (Link->Item[167])
				return 2;
			else if (Link->Item[166])
				return 1;
			else
				return 0;
			break;
			
		case 1:	//Power shard item ids
			if (Link->Item[173])
				return 4;
			else if (Link->Item[172])
				return 3;
			else if (Link->Item[171])
				return 2;
			else if (Link->Item[170])
				return 1;
			else
				return 0;
			break;
				
		case 2:	//Wisdom shard item ids
			if (Link->Item[177])
				return 4;
			else if (Link->Item[176])
				return 3;
			else if (Link->Item[175])
				return 2;
			else if (Link->Item[174])
				return 1;
			else 
				return 0;
			break;
				
		case 3:	//Death shard item ids
			if (Link->Item[181])
				return 4;
			else if (Link->Item[180])
				return 3;
			else if (Link->Item[179])
				return 2;
			else if (Link->Item[178])
				return 1;
			else
				return 0;
			break;
	}
} //end

int checkID(int id) //start
{
	if (id == -1)
		return 0;
		
	if(id < 0)
	{
		id = -id;
		unless(id && Hero->Item[id]) 
			return 0;
	}
	else
	{
		int fam = id;
		id = 0;
		
		// Item selction
		switch(fam)
		{
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
				
				switch(fam)
				{
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
						unless (Game->Counter[CR_ARROWS])
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

void drawTileToLoc(int layer, int tile, int cset, int locX, int locY) //start
{
	drawTileToLoc(layer, tile, cset, locX, locY, 0);
} //end

void drawTileToLoc(int layer, int tile, int cset, int locX, int locY, int y) //start
{
	Screen->FastTile(layer, locX, locY + y, tile, cset, OP_OPAQUE);
} //end

int loadItemTile(int itID) //start
{
	unless(itID > 0) 
		return TILE_INVIS;
		
	itemdata i = Game->LoadItemData(itID);
	int frameNum = 0;
	
	if(i->ASpeed > 0 && i->AFrames > 0)
	{
		int temp = (gameframe % ((i->ASpeed * i->AFrames) + (i->ASpeed * i->Delay))) - (i->Delay * i->ASpeed);
		if(temp >= 0)
			frameNum = Floor(temp / i->ASpeed);
	}
	
	return i->Tile + frameNum;
} //end

int loadItemCSet(int itID) //start
{
	unless(itID > 0) return 0;
	return Game->LoadItemData(itID)->CSet;
} //end

//Use 'RT_SCREEN' as 'bit' to draw to the screen
void minitile(untyped bit, int layer, int x, int y, int tile, int cset, int corner) //start
{
	bitmap sub = Game->CreateBitmap(16, 16);
	sub->Clear(0);
	tile(sub, 0, 0, 0, tile, cset);
	sub->Blit(layer, bit, (corner & 01b) ? 8 : 0, (corner & 10b) ? 8 : 0, 8, 8, x, y, 8, 8, 0, 0, 0, 0, 0, true);
	sub->Free();
} //end

void tile(untyped bit, int layer, int x, int y, int tile, int cset) //start
{
	<bitmap>(bit)->FastTile(layer, x, y, tile, cset, OP_OPAQUE);
} //end




















