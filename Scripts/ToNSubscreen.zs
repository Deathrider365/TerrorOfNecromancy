#option SHORT_CIRCUIT on

CONFIG BG_MAP = 7;
CONFIG BG_SCREEN = 0x00;
COLOR BG_COLOR = C_LGRAY;
DEFINE NUM_SUBSCR_SEL_ITEMS = 24;
DEFINE NUM_SUBSCR_INAC_ITEMS = 13;
//start Active Items
int itemIDs[] = {IC_SWORD, IC_BRANG, IC_BOMB, IC_ARROW, IC_CANDLE, IC_WHISTLE, IC_POTION, IC_BAIT,
                 IC_SBOMB, IC_HOOKSHOT, IC_HAMMER, IC_WAND, IC_LENS, 256, IC_CBYRNA, IC_CUSTOM8,
				 IC_DINSFIRE, IC_FARORESWIND, IC_NAYRUSLOVE, IC_CUSTOM4, IC_CUSTOM1, 260, 261, 262};
int itemLocs[] = { 43,  44,  45,  46,  59,  60,  61,  62,
                   75,  76,  77,  78,  91,  92,  93,  94,
				  107, 108, 109, 110, 123, 124, 125, 126};
//end Active Items
//start Inactive Items
int in_itemIDs[] = {IC_BOSSKEY, IC_COMPASS, IC_MAP,
                    IC_RING, IC_SHIELD, IC_LADDER, IC_RAFT, IC_WALLET, IC_FLIPPERS,
					IC_BRACELET, NULL, IC_CUSTOM2, IC_MAGICRING};
int in_itemLocs[] = { 42, 58, 74,
                       8,  9, 24, 25, 40, 41,
					  56, 57, 72, 73};
//end Inactive Items
int asubscr_pos = 0;
dmapdata script ActiveSubscreen
{
	void run()
	{
		bitmap b = Game->CreateBitmap(256,224);
		b->Clear(0);
		b->Rectangle(0,0,56,256,176,BG_COLOR,1,0,0,0,true,OP_OPAQUE); //BG Color
		b->DrawScreen(0, BG_MAP, BG_SCREEN, 0, 56, 0); //Draw BG screen
		//Do any other draws to the bitmap here
		
		for(int y = 168; y > 0; --y)
		{
			do_asub_frame(b, y, false);
			Waitframe();
		}
		do
		{
			do_asub_frame(b, 0, true);
			Waitframe();
		}
		until(Input->Press[CB_START]);
		for(int y = 0; y < 168; ++y)
		{
			do_asub_frame(b, y, false);
			Waitframe();
		}
	}
}

void do_asub_frame(bitmap b, int y, bool isActive)
{
	gameframe = (gameframe+1)%3600;
	b->Blit(0,RT_SCREEN,0,0,256,176,0,y,256,176,0,0,0,BITDX_NORMAL,0,true); //Draw the BG bitmap to the screen
	
	//start Handle asubscr_position movement
	if(isActive)
	{
		if(Input->Press[CB_LEFT])
			--asubscr_pos;
		else if(Input->Press[CB_RIGHT])
			++asubscr_pos;
		else if(Input->Press[CB_UP])
			asubscr_pos-=4;
		else if(Input->Press[CB_DOWN])
			asubscr_pos+=4;
		if(asubscr_pos < 0) asubscr_pos += (4*6);
		else asubscr_pos %= (4*6);
	}
	//end Handle asubscr_position movement
	
	//start Item Draws
	int selID = 0;
	for(int q = 0; q < NUM_SUBSCR_INAC_ITEMS; ++q)
	{
		int id = checkID(in_itemIDs[q]);
		unless(id) continue;
		
		drawTileToLoc(1, loadItemTile(id), loadItemCSet(id), in_itemLocs[q], y);
	}
	for(int q = 0; q < NUM_SUBSCR_SEL_ITEMS; ++q)
	{
		int id = checkID(itemIDs[q]);
		unless(id) continue;
		if(q == asubscr_pos) selID = id;
		drawTileToLoc(1, loadItemTile(id), loadItemCSet(id), itemLocs[q], y);
	}
	//end Item Draws
	//start Custom Draws
	//Legionnaire Ring
	Screen->FastTile(4, 0, y + 0, TILE_LEGIONNAIRE_RING, CSET_LEGIONNAIRE_RING, OP_OPAQUE);
	char32 buf[3];
	if(Game->Counter[CR_LEGIONNAIRE_RING] < 10)
		sprintf("0%i", Game->Counter[CR_LEGIONNAIRE_RING]);
	else sprintf("%i", Game->Counter[CR_LEGIONNAIRE_RING]);
	Screen->DrawString(4, 16, y + 0, FONT_LA, C_BLACK, C_TRANSBG, TF_NORMAL, buf, OP_OPAQUE);
	//end Custom Draws
	//start Cursor Stuff
	drawTileToLoc(7, loadItemTile(I_SELECTA), loadItemCSet(I_SELECTA), itemLocs[asubscr_pos], y);
	drawTileToLoc(7, loadItemTile(I_SELECTB), loadItemCSet(I_SELECTB), itemLocs[asubscr_pos], y);
	if(isActive && selID)
	{
		if(Input->Press[CB_A])
		{
			if(Hero->ItemB == selID)
				Hero->ItemB = Hero->ItemA;
			Hero->ItemA = selID;
		}
		else if(Input->Press[CB_B])
		{
			if(Hero->ItemA == selID)
				Hero->ItemA = Hero->ItemB;
			Hero->ItemB = selID;
		}
	}
	//end Cursor Stuff
}

int checkID(int id) //start
{
	if(id < 0)
	{
		id = -id
		unless(id && Hero->Item[id]) return 0;
	}
	else
	{
		int fam = id;
		id = 0;
		switch(fam)
		{
			case IC_BOSSKEY:
				if(Game->LItems[Game->GetCurLevel()] & LI_BOSSKEY)
				{
					id = I_BOSSKEY;
				}
				break;
			case IC_MAP:
				if(Game->LItems[Game->GetCurLevel()] & LI_MAP)
				{
					id = I_MAP;
				}
				break;
			case IC_COMPASS:
				if(Game->LItems[Game->GetCurLevel()] & LI_COMPASS)
				{
					id = I_COMPASS;
				}
				break;
			default:
				id = GetHighestLevelItemOwned(id);
				unless(id && Hero->Item[id]) return 0;
		}
	}
	return id;
} //end

void drawTileToLoc(int layer, int tile, int cset, int loc)
{
	drawTileToLoc(layer, tile, cset, loc, 0);
}

void drawTileToLoc(int layer, int tile, int cset, int loc, int y)
{
	Screen->FastTile(layer,(loc%16)*16,Div(loc,16)*16,tile,cset,OP_OPAQUE);
}

int loadItemTile(int itID) //start
{
	unless(itID) return TILE_INVIS;
	itemdata i = Game->LoadItemData(itID);
	int frameNum = 0;
	if(i->ASpeed>0&&i->AFrames>0)
	{
		int temp = (gameframe%((i->ASpeed*i->AFrames)+(i->ASpeed*i->Delay)))-(i->Delay*i->ASpeed);
		if(temp>=0)
			frameNum = Floor(temp/i->ASpeed);
	}
	return i->Tile+frameNum;
} //end

int loadItemCSet(int itID) //start
{
	unless(itID) return 0;
	return Game->LoadItemData(itID)->CSet;
} //end

//Use 'RT_SCREEN' as 'bit' to draw to the screen
void minitile(untyped bit, int layer, int x, int y, int tile, int cset, int corner) //start
{
	bitmap sub = Game->CreateBitmap(16, 16);
	sub->Clear(0);
	tile(sub, 0, 0, 0, tile, cset);
	sub->Blit(layer, bit, (corner&01b)?8:0, (corner&10b)?8:0, 8, 8, x, y, 8, 8, 0, 0, 0, 0, 0, true);
	sub->Free();
} //end

void tile(untyped bit, int layer, int x, int y, int tile, int cset) //start
{
	<bitmap>(bit)->FastTile(layer, x, y, tile, cset, OP_OPAQUE);
} //end
