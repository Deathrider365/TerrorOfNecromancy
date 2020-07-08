///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~The Terror of Necromancy Passive Subscreen~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

CONFIG BG_MAP1 = 6;
CONFIG BG_SCREEN1 = 0x0F;

@Author("Venrob")
dmapdata script PassiveSubscreen
{
	using namespace time;
	void run()
	{
		bitmap bm = Game->CreateBitmap(256,56);
		bm->Clear(0);
		bm->Rectangle(0, 0, 0, 256, 56, BG_COLOR, 1, 0, 0, 0, true, OP_OPAQUE); //BG Color
		bm->DrawScreen(0, BG_MAP1, BG_SCREEN1, 0, 56, 0); //Draw BG screen
		//Do any other draws to the bitmap here
		while(true)
		{
			Waitdraw();
			do_psub_frame(bm, subscr_y_offset+168);
			Waitframe();
		}
	}
	
	void do_psub_frame(bitmap bm, int y)
	{
		bm->Blit(7, RT_SCREEN, 0, 0, 256, 56, 0, y, 256, 56, 0, 0, 0, BITDX_NORMAL, 0, true); //Draw the BG bitmap to the screen
		//start Counters
		//Rupees
		minitile(RT_SCREEN, 7, 134, y+6, 32780, 1, 0);
		counter(RT_SCREEN, 7, 134+10, y+6, CR_RUPEES, SUBSCR_COUNTER_FONT, C_SUBSCR_COUNTER_TEXT, C_SUBSCR_COUNTER_BG, TF_NORMAL, 3, CNTR_USES_0);
		minitile(RT_SCREEN, 7, 134, y+16, 32780, 1, 1);
		counter(RT_SCREEN, 7, 134+10, y+16, CR_BOMBS, SUBSCR_COUNTER_FONT, C_SUBSCR_COUNTER_TEXT, C_SUBSCR_COUNTER_BG, TF_NORMAL, 2, CNTR_USES_0);
		minitile(RT_SCREEN, 7, 134, y+26, 32780, 1, 3);
		counter(RT_SCREEN, 7, 134+10, y+26, CR_SBOMBS, SUBSCR_COUNTER_FONT, C_SUBSCR_COUNTER_TEXT, C_SUBSCR_COUNTER_BG, TF_NORMAL, 2, CNTR_USES_0);
		minitile(RT_SCREEN, 7, 134, y+36, 32780, 1, 2);
		counter(RT_SCREEN, 7, 134+10, y+36, CR_ARROWS, SUBSCR_COUNTER_FONT, C_SUBSCR_COUNTER_TEXT, C_SUBSCR_COUNTER_BG, TF_NORMAL, 2, CNTR_USES_0);
		minitile(RT_SCREEN, 7, 134, y+46, 32800, 1, 0);
		counter(RT_SCREEN, 7, 134+10, y+46, Game->GetCurLevel() ? -Game->GetCurLevel() : MAX_INT, SUBSCR_COUNTER_FONT, C_SUBSCR_COUNTER_TEXT, C_SUBSCR_COUNTER_BG, TF_NORMAL, 2, CNTR_USES_0);
		//end Counters
		//start Buttons
		//Frames
		Screen->DrawTile(7, 82, y+13, TILE_SUBSCR_BUTTON_FRAME, 2, 2, 11, -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
		Screen->DrawTile(7, 105, y+13, TILE_SUBSCR_BUTTON_FRAME, 2, 2, 11, -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
		//Labels
		Screen->FastTile(7, 87, y+0, 1288, 0, OP_OPAQUE);
		Screen->FastTile(7, 110, y+0, 1268, 0, OP_OPAQUE);
		//Items
		Screen->FastTile(7, 86, y + 21, loadItemTile(Hero->ItemB), loadItemCSet(Hero->ItemB), OP_OPAQUE);
		Screen->FastTile(7, 109, y + 21, loadItemTile(Hero->ItemA), loadItemCSet(Hero->ItemA), OP_OPAQUE);
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
		heart(RT_SCREEN, 7, 174, y+30, 10, TILE_HEARTS);
		heart(RT_SCREEN, 7, 180, y+30, 11, TILE_HEARTS);
		heart(RT_SCREEN, 7, 186, y+30, 12, TILE_HEARTS);
		heart(RT_SCREEN, 7, 192, y+30, 13, TILE_HEARTS);
		heart(RT_SCREEN, 7, 198, y+30, 14, TILE_HEARTS);
		heart(RT_SCREEN, 7, 204, y+30, 15, TILE_HEARTS);
		heart(RT_SCREEN, 7, 210, y+30, 16, TILE_HEARTS);
		heart(RT_SCREEN, 7, 216, y+30, 17, TILE_HEARTS);
		heart(RT_SCREEN, 7, 222, y+30, 18, TILE_HEARTS);
		heart(RT_SCREEN, 7, 228, y+30, 19, TILE_HEARTS);
		heart(RT_SCREEN, 7, 177, y+24, 20, TILE_HEARTS);
		heart(RT_SCREEN, 7, 183, y+24, 21, TILE_HEARTS);
		heart(RT_SCREEN, 7, 189, y+24, 22, TILE_HEARTS);
		heart(RT_SCREEN, 7, 195, y+24, 23, TILE_HEARTS);
		heart(RT_SCREEN, 7, 201, y+24, 24, TILE_HEARTS);
		heart(RT_SCREEN, 7, 207, y+24, 25, TILE_HEARTS);
		heart(RT_SCREEN, 7, 213, y+24, 26, TILE_HEARTS);
		heart(RT_SCREEN, 7, 219, y+24, 27, TILE_HEARTS);
		heart(RT_SCREEN, 7, 225, y+24, 28, TILE_HEARTS);
		heart(RT_SCREEN, 7, 231, y+24, 29, TILE_HEARTS);
		//end Life Meter
		//start Magic Meter
		int perc = Game->Counter[CR_MAGIC] / Game->MCounter[CR_MAGIC];
		Screen->DrawTile(7, 166, y+44, TILE_MAGIC_METER + (Game->Generic[GEN_MAGICDRAINRATE] < 2 ? 20 : 0), MAGIC_METER_TILE_WIDTH, 1, 0, -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
		if(MAGIC_METER_PIX_WIDTH*perc >= 0.5)
			Screen->Rectangle(7, 166+MAGIC_METER_FILL_XOFF,                                   y+44+MAGIC_METER_FILL_YOFF,
			                     166+MAGIC_METER_FILL_XOFF+Round(MAGIC_METER_PIX_WIDTH*perc), y+44+MAGIC_METER_FILL_YOFF+MAGIC_METER_PIX_HEIGHT,
								 C_MAGIC_METER_FILL, 1, 0, 0, 0, true, OP_OPAQUE);
		//end Magic Meter
		//start Clock
		char32 buf[16];
		sprintf(buf, "%d:%02d:%02d",Hours(),Minutes(),Seconds());
		Screen->DrawString(7, 224, y+3, SUBSCR_COUNTER_FONT, C_SUBSCR_COUNTER_TEXT, C_SUBSCR_COUNTER_BG, TF_RIGHT, buf, OP_OPAQUE);
		//end Clock
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
		Screen->DrawString(layer, x, y, font, color, bgcolor, format, buf, OP_OPAQUE);
	else <bitmap>(bit)->DrawString(layer, x, y, font, color, bgcolor, format, buf, OP_OPAQUE);
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

































