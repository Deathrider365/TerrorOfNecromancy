///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~~The Terror of Necromancy Active Subscreen~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

CONFIG BG_MAP = 6;
CONFIG BG_SCREEN = 0x0E;
CONFIG SCROLL_SPEED = 4;

COLOR BG_COLOR = C_DGRAY;
DEFINE NUM_SUBSCR_SEL_ITEMS = 24;
DEFINE NUM_SUBSCR_INAC_ITEMS = 14;
CONFIG CURSOR_MOVEMENT_SFX = 5;
CONFIG TRIFORCE_CYCLE_SFX = 124;
CONFIG ITEM_SELECTION_SFX = 66;
CONFIG SUBSCR_COUNTER_FONT = FONT_LA;
CONFIG SUBSCR_DMAPTITLE_FONT = FONT_Z3SMALL;
COLOR C_SUBSCR_COUNTER_TEXT = C_WHITE;
COLOR C_SUBSCR_COUNTER_BG = C_TRANSBG;
CONFIGB CNTR_USES_0 = true;
CONFIG TILE_SUBSCR_BUTTON_FRAME = 1378;
CONFIG TILE_HEARTS = 32420;

COLOR C_MAGIC_METER_FILL = C_GREEN;
CONFIG TILE_MAGIC_METER = 32527;//32520;
CONFIG MAGIC_METER_TILE_WIDTH = 5;
CONFIG MAGIC_METER_PIX_WIDTH = 63;//55; //-1 from actual
CONFIG MAGIC_METER_PIX_HEIGHT = 1; //-1 from actual
CONFIG MAGIC_METER_FILL_XOFF = 11;
CONFIG MAGIC_METER_FILL_YOFF = 3;

CONFIG TILE_MINIMAP_OW_BG = 1220;
CONFIG TILE_MINIMAP_DNGN_BG = 42400;

COLOR C_MINIMAP_EXPLORED = C_WHITE;
COLOR C_MINIMAP_ROOM = C_BLACK;
COLOR C_MINIMAP_LINK = C_DARKGREEN;
COLOR C_MINIMAP_COMPASS = C_RED;
COLOR C_MINIMAP_COMPASS_DEFEATED = C_BLUE;

int subscr_y_offset = -224;

int scrollingOffset; 

//start Active Items
int itemIDs[] = {IC_SWORD, 		IC_BRANG, 			IC_BOMB, 		IC_ARROW, 
				 IC_CANDLE, 	IC_WHISTLE, 		IC_POTION, 		IC_BAIT,
                 IC_SBOMB, 		IC_HOOKSHOT, 		IC_HAMMER, 		IC_WAND, 
				 IC_LENS, 		IC_WPN_SCRIPT_02, 	IC_CBYRNA, 		-1,
				 IC_DINSFIRE, 	IC_FARORESWIND, 	IC_NAYRUSLOVE, 	IC_CUSTOM4, 
				 IC_CUSTOM1, 	IC_CUSTOM3, 		IC_CUSTOM5, 	IC_CUSTOM6};
				  
 int itemLocsX[] = {166, 188, 210, 232,
					166, 188, 210, 232,
					166, 188, 210, 232,
					166, 188, 210, 232,
					166, 188, 210, 232,
					166, 188, 210, 232};
				  
 int itemLocsY[] = {32,	32, 32, 32,
				    54,	54, 54, 54,
				    76,	76, 76, 76,
				    98, 98, 98, 98,
					120, 120, 120, 120,
					142, 142, 142, 142};
				  
//end Active Items

//start Inactive Items
int in_itemIDs[] = {IC_BOSSKEY, IC_COMPASS, IC_MAP,

                    IC_RING, IC_SHIELD, IC_LADDER, IC_RAFT, IC_WALLET, 
					IC_FLIPPERS, IC_BRACELET, IC_CUSTOM8, IC_CUSTOM2, IC_MAGICRING, 
					IC_WEALTHMEDAL};
					 
int in_itemLocsX[] = {129, 129, 129,	//dungeon items

					  8, 26, 44, 62, 80, 
					  8, 26, 44, 62, 80,
					  8};
					  
int in_itemLocsY[] = {108, 126, 144,

					  8, 8, 8, 8, 8,
					  26, 26, 26, 26, 26,
					  44};
//end Inactive Items

//start Triforce Frames
CONFIG TILE_COURAGE_FRAME = 320;
CONFIG TILE_POWER_FRAME = 326;
CONFIG TILE_WISDOM_FRAME = 380;
CONFIG TILE_DEATH_FRAME = 386;

CONFIG COURAGE_SHARD1 = 274;
CONFIG COURAGE_SHARD2 = 334;
CONFIG COURAGE_SHARD3 = 394;
CONFIG COURAGE_SHARD4 = 454;

CONFIG WISDOM_SHARD1 = 702;
CONFIG WISDOM_SHARD2 = 522;
CONFIG WISDOM_SHARD3 = 582;
CONFIG WISDOM_SHARD4 = 642;

CONFIG POWER_SHARD1 = 648;
CONFIG POWER_SHARD2 = 708;
CONFIG POWER_SHARD3 = 588;
CONFIG POWER_SHARD4 = 528;

CONFIG DEATH_SHARD1 = 654;
CONFIG DEATH_SHARD2 = 534;
CONFIG DEATH_SHARD3 = 714;
CONFIG DEATH_SHARD4 = 594;

int triforceFrames[] = {TILE_COURAGE_FRAME, TILE_POWER_FRAME, TILE_WISDOM_FRAME, TILE_DEATH_FRAME};

int courageShards[] = {COURAGE_SHARD1, COURAGE_SHARD2, COURAGE_SHARD3, COURAGE_SHARD4};
int powerShards[] = {POWER_SHARD1, POWER_SHARD2, POWER_SHARD3, POWER_SHARD4};
int wisdomShards[] = {WISDOM_SHARD1, WISDOM_SHARD2, WISDOM_SHARD3, WISDOM_SHARD4};
int deathShards[] = {DEATH_SHARD1, DEATH_SHARD2, DEATH_SHARD3, DEATH_SHARD4};

int amountOfShardsToDraw = 0;

//end Triforce Frames

int asubscr_pos = 0;
int currTriforceIndex = 0;

int amountOfCourageTriforceShards = 0;
int amountOfPowerTriforceShards = 0;
int amountOfWisdomTriforceShards = 0;
int amountOfDeathTriforceShards = 0;

int numHeartPieces = 0;

bool subscr_open = false;

@Author("Venrob")
dmapdata script ActiveSubscreen //start
{
	void run()
	{
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

void do_asub_frame(bitmap b, int y, bool isActive)
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
			
		if(currTriforceIndex == -1)
			currTriforceIndex = 3;
		else if (currTriforceIndex == 4)
			currTriforceIndex = 0;

	}
	//end Handle asubscr_position movement
	
	//start Item Draws
	int selID = 0;
	for(int q = 0; q < NUM_SUBSCR_INAC_ITEMS; ++q)
	{
		int id = checkID(in_itemIDs[q]);
		unless(id) 
			continue;
			
		drawTileToLoc(1, loadItemTile(id), loadItemCSet(id), in_itemLocsX[q], in_itemLocsY[q], y);
	}
	
	for(int q = 0; q < NUM_SUBSCR_SEL_ITEMS; ++q)
	{
		int id = checkID(itemIDs[q]);
		
		unless(id) 
			continue;
		
		if(q == asubscr_pos) 
			selID = id;
		
		drawTileToLoc(1, loadItemTile(id), loadItemCSet(id), itemLocsX[q], itemLocsY[q], y);
	}
	//end Item Draws

	//start Legionnaire Ring
	Screen->FastTile(4, 122, y + 82, TILE_LEGIONNAIRE_RING, CSET_LEGIONNAIRE_RING, OP_OPAQUE);
	counter(RT_SCREEN, 4, 137, y + 86, CR_LEGIONNAIRE_RING, SUBSCR_COUNTER_FONT, C_SUBSCR_COUNTER_TEXT, C_SUBSCR_COUNTER_BG, TF_NORMAL, 2, CNTR_USES_0);

	//end Legionnaire Ring
	
	
	//start Selected Item Name
	char32 buf2[30];
	itemdata idata = Game->LoadItemData(selID);
	
	if (idata)
		idata->GetName(buf2);
			
	Venrob::DrawStrings(4, 206, y + 7, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, buf2, OP_OPAQUE, SHD_SHADOWED, C_BLACK, 0, 80);
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
	CONFIG TILE_ZERO_PIECES = 29420;	
	Screen->FastTile(4, 120, y + 68, TILE_ZERO_PIECES + Game->Generic[GEN_HEARTPIECES], 8, OP_OPAQUE);
	counter(RT_SCREEN, 4, 137, y + 72, CR_HEARTPIECES, SUBSCR_COUNTER_FONT, C_SUBSCR_COUNTER_TEXT, C_SUBSCR_COUNTER_BG, TF_NORMAL, 2, CNTR_USES_0);
	//end Handle Heart Pieces

	//start Handle Triforce Frame Cycling / Drawing
	
	if (currTriforceIndex == 0)
		Venrob::DrawStrings(4, 62, y + 72, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, "Triforce of Courage", OP_OPAQUE, SHD_SHADOWED, C_BLACK, 0, 120);
	if (currTriforceIndex == 1)
		Venrob::DrawStrings(4, 62, y + 72, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, "Triforce of Power", OP_OPAQUE, SHD_SHADOWED, C_BLACK, 0, 120);
	if (currTriforceIndex == 2)
		Venrob::DrawStrings(4, 62, y + 72, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, "Triforce of Wisdom", OP_OPAQUE, SHD_SHADOWED, C_BLACK, 0, 120);
	if (currTriforceIndex == 3)
		Venrob::DrawStrings(4, 62, y + 72, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, "Triforce of Death", OP_OPAQUE, SHD_SHADOWED, C_BLACK, 0, 120);
		
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
			break; //end
	}

	//end Handle Triforce Frame Cycling / Drawing
}

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
				
				unless(id > 0) return 0;
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




















