///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~~The Terror of Necromancy Active Subscreen~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

CONFIG BG_MAP = 6;
CONFIG BG_SCREEN = 0x0E;
CONFIG SCROLL_SPEED = 4;

COLOR BG_COLOR = C_DGRAY;
DEFINE NUM_SUBSCR_SEL_ITEMS = 24;
DEFINE NUM_SUBSCR_INAC_ITEMS = 13;
CONFIG CURSOR_MOVEMENT_SFX = 5;
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
				 IC_LENS, 		IC_WPN_SCRIPT_02, 	IC_CBYRNA, 		0,
				 IC_DINSFIRE, 	IC_FARORESWIND, 	IC_NAYRUSLOVE, 	IC_CUSTOM4, 
				 IC_CUSTOM1, 	IC_CUSTOM3, 		IC_CUSTOM5, 	IC_CUSTOM6};
				  
 int itemLocsX[] = {192, 208, 224, 240,
					192, 208, 224, 240,
					192, 208, 224, 240,
					192, 208, 224, 240,
					192, 208, 224, 240,
					192, 208, 224, 240};
				  
 int itemLocsY[] = {48,	48, 48, 48,
				    64,	64, 64, 64,
				    80,	80, 80, 80,
				    96,	96, 96, 96,
					112, 112, 112, 112,
					128, 128, 128, 128};
				  
//end Active Items

//start Inactive Items
int in_itemIDs[] = {IC_BOSSKEY, IC_COMPASS, IC_MAP,
                    IC_RING, IC_SHIELD, IC_LADDER, 
					IC_RAFT, IC_WALLET, IC_FLIPPERS,
					IC_BRACELET, IC_CUSTOM8, IC_CUSTOM2, IC_MAGICRING};
					 
int in_itemLocsX[] = {176, 176, 176,
					  160, 160, 160,
					  144, 144, 144,
					  128, 128, 128, 128};
int in_itemLocsY[] = {48, 64, 80,
					  48, 64, 80,
					  48, 64, 80,
					  48, 64, 80, 96};
//end Inactive Items

int asubscr_pos = 0;
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
			
		if(asubscr_pos < 0)
			asubscr_pos += (4 * 6);
		else 
			asubscr_pos %= (4 * 6);
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
	
	//start Custom Draws
	//start Legionnaire Ring
	Screen->FastTile(4, 16, y + 0, TILE_LEGIONNAIRE_RING, CSET_LEGIONNAIRE_RING, OP_OPAQUE);
	char32 buf[3];
	
	if(Game->Counter[CR_LEGIONNAIRE_RING] < 10)
		sprintf(buf, "0%i", Game->Counter[CR_LEGIONNAIRE_RING]);
	else 
		sprintf(buf, "%i", Game->Counter[CR_LEGIONNAIRE_RING]);
		
	Screen->DrawString(4, , y + 0, FONT_LA, C_WHITE, C_TRANSBG, TF_NORMAL, buf, OP_OPAQUE, SHD_SHADOWED, C_BLACK);
	//end Legionnaire Ring
	
	//start Selected Item Name
	char32 buf2[30];
	itemdata idata = Game->LoadItemData(selID);
	
	if (idata)
		idata->GetName(buf2);
			
	Venrob::DrawStrings(4, 208, y + 4, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, buf2, OP_OPAQUE, SHD_SHADOWED, C_BLACK, 0, 80);
	//end Selected Item Name
	//end Custom Draws
	
	//start Cursor Stuff
	drawTileToLoc(7, loadItemTile(I_SELECTA), loadItemCSet(I_SELECTA), itemLocsX[asubscr_pos], itemLocsX[asubscr_pos], y);
	drawTileToLoc(7, loadItemTile(I_SELECTB), loadItemCSet(I_SELECTB), itemLocsY[asubscr_pos], itemLocsY[asubscr_pos], y);
	
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
}

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






















