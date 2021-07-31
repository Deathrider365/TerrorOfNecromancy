

namespace Emily::EmilyMap
{
	CONFIG COLOR_NULL = 0x0F;
	CONFIG COLOR_FRAME = 0x01;
	CONFIG INPUT_REPEAT_TIME = 15;
	CONFIG MAP_PUSH_PIXELS = 8;
	
	@Author("EmilyV99")
	dmapdata script CoolMap
	{
		void run(bool lockPalette)
		{
			DEFINE WIDTH = 256 * 16, HEIGHT = 176 * 8;
			
			bitmap bmp = create(WIDTH,HEIGHT);
			//start Generate map
			bmp->Clear(0);
			int type_wid = ((this->Type & 11b) == DMAP_OVERWORLD) ? 16 : 8;
			int l = Max(this->Offset, 0);
			int r = Min(this->Offset + type_wid - 1, 15);
			int xdraw = -1;
			bitmap tmp = create(256, 176);
			
			for(int x = l; x <= r; ++x)
			{
				++xdraw;
				int ydraw = -1;
				
				for(int y = 0; y < 8; ++y)
				{
					++ydraw;
					int scr = x + (y * 0x10);
					mapdata m = Game->LoadMapData(this->Map, scr);
					
					if(lockPalette && m->Palette != this->Palette)
						continue;
					
					unless(m->Valid & 1b)
						continue;
					
					tmp->Clear(0);
					bool bg2 = isBG(false, m, this), bg3 = isBG(true, m, this);
					
					if(bg2)
						tmp->DrawLayer(0, this->Map, scr, 2, 0, 0, 0, OP_OPAQUE);
					if(bg3)
						tmp->DrawLayer(0, this->Map, scr, 3, 0, 0, 0, OP_OPAQUE);
					
					tmp->DrawLayer(0, this->Map, scr, 0, 0, 0, 0, OP_OPAQUE);
					tmp->DrawLayer(0, this->Map, scr, 1, 0, 0, 0, OP_OPAQUE);
					
					for(int q = 1; q < 33; ++q)
					{
						unless(m->FFCData[q]) 
							continue;
						
						if(m->FFCFlags[q] & (1b<<FFCF_OVERLAY)) //Skip drawing overlays
							continue; 
							
						tmp->DrawCombo(0, m->FFCX[q], m->FFCY[q], m->FFCData[q], m->FFCTileWidth[q], m->FFCTileHeight[q],
							m->FFCCSet[q], -1, -1, 0, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
					}
					
					unless(bg2)
						tmp->DrawLayer(0, this->Map, scr, 2, 0, 0, 0, OP_OPAQUE);
					unless(bg3)
						tmp->DrawLayer(0, this->Map, scr, 3, 0, 0, 0, OP_OPAQUE);
					
					tmp->DrawLayer(0, this->Map, scr, 4, 0, 0, 0, OP_OPAQUE);
					tmp->DrawLayer(0, this->Map, scr, 5, 0, 0, 0, OP_OPAQUE);
					
					for(int q = 1; q < 33; ++q)
					{
						unless(m->FFCData[q]) 
							continue;
						unless(m->FFCFlags[q] & (1b<<FFCF_OVERLAY)) //Only draw overlays
							continue; 
							
						tmp->DrawCombo(0, m->FFCX[q], m->FFCY[q], m->FFCData[q], m->FFCTileWidth[q], m->FFCTileHeight[q],
							m->FFCCSet[q], -1, -1, 0, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
					}
					
					tmp->DrawLayer(0, this->Map, scr, 6, 0, 0, 0, OP_OPAQUE);
					tmp->Blit(0, bmp, 0, 0, 256, 176, xdraw * 256, ydraw * 176, 256, 176, 0, 0, 0, BITDX_NORMAL, 0, true);
				}
			}
			tmp->Free();
			//end Generate map
			
			if (DEBUG)
				bmp->Write(7, "foo.png", true);
			
			int use_wid = (type_wid == 16) ? WIDTH : WIDTH / 2;
			int min_zoom = type_wid;
			int x, y, zoom = 16;
			int input_clk;
			
			do //start 
			{
				input_clk = (input_clk + 1) % INPUT_REPEAT_TIME;
				bool pressed = true;
				
				if(Input->Press[CB_A] || (!input_clk && Input->Button[CB_A]))
					--zoom;
				else if(Input->Press[CB_B] || (!input_clk && Input->Button[CB_B]))
					++zoom;
				else if(Input->Press[CB_UP] || (!input_clk && Input->Button[CB_UP]))
					y += MAP_PUSH_PIXELS;
				else if(Input->Press[CB_DOWN] || (!input_clk && Input->Button[CB_DOWN]))
					y -= MAP_PUSH_PIXELS;
				else if(Input->Press[CB_LEFT] || (!input_clk && Input->Button[CB_LEFT]))
					x += MAP_PUSH_PIXELS;
				else if(Input->Press[CB_RIGHT] || (!input_clk && Input->Button[CB_RIGHT]))
					x -= MAP_PUSH_PIXELS;
				else pressed = false;
				
				if(pressed) 
					input_clk = 1;
				
				zoom = VBound(zoom, min_zoom, 1);
				y = VBound(y, 176, -(HEIGHT/zoom));
				x = VBound(x, 256, -(use_wid/zoom));
				
				Screen->Rectangle(7, 0, -56, 255, 175, COLOR_NULL, 1, 0, 0, 0, true, OP_OPAQUE);
				Screen->Rectangle(7, x - 1, y - 1, x + use_wid / zoom, y + HEIGHT / zoom, COLOR_FRAME, 1, 0, 0, 0, false, OP_OPAQUE);
				bmp->Blit(7, RT_SCREEN, 0, 0, use_wid, HEIGHT, x, y, use_wid / zoom, HEIGHT / zoom, 0, 0, 0, BITDX_NORMAL, 0, false);
				
				Waitframe();
				
			} until(Input->Press[CB_MAP]); //end
			
			bmp->Free();
		}
	}
	
	bool isBG(bool l3, mapdata m, dmapdata dm) //start
	{
		if(l3)
			return (GetMapscreenFlag(m, MSF_LAYER3BG) ^^ dm->Flagset[DMFS_LAYER3ISBACKGROUND]);
		else
			return (GetMapscreenFlag(m, MSF_LAYER2BG) ^^ dm->Flagset[DMFS_LAYER2ISBACKGROUND]);
	} //end
}















