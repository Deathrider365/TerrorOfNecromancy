

namespace Emily::EmilyMap
{
	CONFIG COLOR_NULL = 0x0F;
	CONFIG COLOR_FRAME = 0x01;
	CONFIG INPUT_REPEAT_TIME = 3;
	CONFIG ZOOM_INPUT_REPEAT_TIME = 6;
	CONFIG MAP_PUSH_PIXELS = 8;
	
	@Author("EmilyV99")
	dmapdata script CoolMap //start
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
			
			int l1, l2;
			bool paths;
			
			if (this->Script == Game->GetDMapScript("WaterPaths"))
			{
				paths = true;
				
				for(int q = 6; q >= 0; --q) //start calculate layers
				{
					if(this->InitD[0] & (1b << q))
					{
						if(l2)
						{
							l1 = q;
							break;
						}
						else 
							l2 = q;
					}
				} //end
			}

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
						
					unless(m->State[ST_VISITED])
						;//continue;
						
					unless(m->Valid & 1b)
						continue;
					
					tmp->Clear(0);
					bool bg2 = isBG(false, m, this), bg3 = isBG(true, m, this);
					
					if(bg2)
					{
						tmp->DrawLayer(0, this->Map, scr, 2, 0, 0, 0, OP_OPAQUE);
						handlePaths(tmp, m, 2, l1, l2);
					}
					if(bg3)
					{
						tmp->DrawLayer(0, this->Map, scr, 3, 0, 0, 0, OP_OPAQUE);
						handlePaths(tmp, m, 3, l1, l2);
					}
					
					tmp->DrawLayer(0, this->Map, scr, 0, 0, 0, 0, OP_OPAQUE);
					handlePaths(tmp, m, 0, l1, l2);
					tmp->DrawLayer(0, this->Map, scr, 1, 0, 0, 0, OP_OPAQUE);
					handlePaths(tmp, m, 1, l1, l2);
					
					for(int q = 1; q < 33; ++q) //start non-overlay ffcs
					{
						unless(m->FFCData[q]) 
							continue;
						
						if(m->FFCFlags[q] & (FFCBF_CHANGER | FFCBF_ETHEREAL | FFCBF_LENSVIS))
							continue;
						
						if(m->FFCFlags[q] & FFCBF_OVERLAY) //Skip drawing overlays
							continue;
						
						tmp->DrawCombo(0, m->FFCX[q], m->FFCY[q], m->FFCData[q], m->FFCTileWidth[q], m->FFCTileHeight[q],
							m->FFCCSet[q], -1, -1, 0, 0, 0, 0, FLIP_NONE, true, (m->FFCFlags[q] & FFCBF_TRANS) ? OP_TRANS : OP_OPAQUE);
					} //end
					
					unless(bg2)
					{
						tmp->DrawLayer(0, this->Map, scr, 2, 0, 0, 0, OP_OPAQUE);
						handlePaths(tmp, m, 2, l1, l2);
					}
					unless(bg3)
					{
						tmp->DrawLayer(0, this->Map, scr, 3, 0, 0, 0, OP_OPAQUE);
						handlePaths(tmp, m, 3, l1, l2);
					}
					
					tmp->DrawLayer(0, this->Map, scr, 4, 0, 0, 0, OP_OPAQUE);
					handlePaths(tmp, m, 4, l1, l2);
					tmp->DrawLayer(0, this->Map, scr, 5, 0, 0, 0, OP_OPAQUE);
					handlePaths(tmp, m, 5, l1, l2);
					
					for(int q = 1; q < 33; ++q) //start overlay ffcs
					{
						unless(m->FFCData[q]) 
							continue;
						
						if(m->FFCFlags[q] & (FFCBF_CHANGER | FFCBF_ETHEREAL | FFCBF_LENSVIS))
							continue;
						
						unless(m->FFCFlags[q] & (1b<<FFCF_OVERLAY)) //Only draw overlays
							continue; 
						
						tmp->DrawCombo(0, m->FFCX[q], m->FFCY[q], m->FFCData[q], m->FFCTileWidth[q], m->FFCTileHeight[q],
							m->FFCCSet[q], -1, -1, 0, 0, 0, 0, FLIP_NONE, true, (m->FFCFlags[q] & FFCBF_TRANS) ? OP_TRANS : OP_OPAQUE);
					} //end
					
					tmp->DrawLayer(0, this->Map, scr, 6, 0, 0, 0, OP_OPAQUE);
					handlePaths(tmp, m, 6, l1, l2);
					tmp->Blit(0, bmp, 0, 0, 256, 176, xdraw * 256, ydraw * 176, 256, 176, 0, 0, 0, BITDX_NORMAL, 0, true);
				}
			}
			tmp->Free();
			//end Generate map
			
			if (DEBUG)
				bmp->Write(7, "foo.png", true);
			
			int use_wid = (type_wid == 16) ? WIDTH : WIDTH / 2;
			int min_zoom = type_wid;
			int x, y, zoom = min_zoom;
			int input_clk, zoom_input_clk;
			
			do //start 
			{
				input_clk = (input_clk + 1) % INPUT_REPEAT_TIME;
				zoom_input_clk = (zoom_input_clk + 1) % INPUT_REPEAT_TIME;
				bool pressed = true, zoomed = true;
				if(Input->Press[CB_A] || (!zoom_input_clk && Input->Button[CB_A]))
				{
					--zoom;
					x -= ((use_wid/(zoom+1)) - (use_wid/zoom))/2;
					y -= ((HEIGHT/(zoom+1)) - (HEIGHT/zoom))/2;
				}
				else if(Input->Press[CB_B] || (!zoom_input_clk && Input->Button[CB_B]))
				{
					++zoom;
					x -= ((use_wid/(zoom-1)) - (use_wid/zoom))/2;
					y -= ((HEIGHT/(zoom-1)) - (HEIGHT/zoom))/2;
				}
				else zoomed = false;
				if(Input->Press[CB_UP] || (!input_clk && Input->Button[CB_UP]))
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
				if(zoomed)
					zoom_input_clk = 1;
				
				zoom = VBound(zoom, min_zoom, 1);
				y = VBound(y, HEIGHT, -HEIGHT);
				x = VBound(x, use_wid, -use_wid);
				
				int tx =  x;
				int ty = y-56;
				//printf("x%d,y%d, drawing at %d,%d (%d,%d)\n", x, y, tx, ty, use_wid/zoom, HEIGHT/zoom);
				Screen->Rectangle(7, 0, -56, 255, 175, COLOR_NULL, 1, 0, 0, 0, true, OP_OPAQUE);
				Screen->Rectangle(7, tx - 1, ty - 1, tx + use_wid / zoom, ty + HEIGHT / zoom, COLOR_FRAME, 1, 0, 0, 0, false, OP_OPAQUE);
				bmp->Blit(7, RT_SCREEN, 0, 0, use_wid, HEIGHT, tx, ty, use_wid / zoom, HEIGHT / zoom, 0, 0, 0, BITDX_NORMAL, 0, false);
				
				Waitframe();
				
			} until(Input->Press[CB_MAP]); //end
			
			bmp->Free();
		}
	} //end
	
	bool isBG(bool l3, mapdata m, dmapdata dm) //start
	{
		if(l3)
			return (GetMapscreenFlag(m, MSF_LAYER3BG) ^^ dm->Flagset[DMFS_LAYER3ISBACKGROUND]);
		else
			return (GetMapscreenFlag(m, MSF_LAYER2BG) ^^ dm->Flagset[DMFS_LAYER2ISBACKGROUND]);
	} //end

	void handlePaths(bitmap b, mapdata template, int layer, int l1, int l2) //start
	{
		using namespace WaterPaths;
		if(layer != l1 && layer != l2) return;
		mapdata t1 = Emily::loadLayer(template, l1), t2 = Emily::loadLayer(template, l2);
		mapdata tleft, tright, tup, tdown;
		
		{ //start
			unless(template->Screen < 0x10)
				tup = Emily::loadLayer(Game->LoadMapData(template->Map, template->Screen - 0x10), l1);
			unless(template->Screen >= 0x70)
				tdown = Emily::loadLayer(Game->LoadMapData(template->Map, template->Screen + 0x10), l1);
			if(template->Screen % 0x10)
				tleft = Emily::loadLayer(Game->LoadMapData(template->Map, template->Screen - 1), l1);
			unless(template->Screen % 0x10 == 0xF)
				tright = Emily::loadLayer(Game->LoadMapData(template->Map, template->Screen + 1), l1);
		} //end
		//start passes
		enum //start
		{
			PASS_LIQUID,
			PASS_BARRIERS,
			PASS_COUNT
		}; //end
		
		for(int pass = 0; pass < PASS_COUNT; ++pass)
		{
			for(int q = 0; q < 176; ++q)
			{
				if(t1->ComboT[q] != CT_FLUID)
					continue;
					
				combodata cd = Game->LoadComboData(t1->ComboD[q]);
				int flag = cd->Attributes[ATTBU_FLUIDPATH];
				
				switch(pass)
				{
					case PASS_LIQUID:
						unless(flag > 0) 
						continue;
						break;
					case PASS_BARRIERS:
						unless(flag == VAL_BARRIER) 
						continue;
						break;
				}
					
				int u,d,l,r;
				
				//start calculations
				unless(q < 0x10)
					u = Game->LoadComboData(t1->ComboD[q - 0x10])->Attributes[ATTBU_FLUIDPATH];
				else if(tup)
					u = Game->LoadComboData(tup->ComboD[q + 0x90])->Attributes[ATTBU_FLUIDPATH];
				
				unless(q >= 0xA0)
					d = Game->LoadComboData(t1->ComboD[q + 0x10])->Attributes[ATTBU_FLUIDPATH];
				else if(tdown)
					d = Game->LoadComboData(tdown->ComboD[q - 0x90])->Attributes[ATTBU_FLUIDPATH];
				
				if(q % 0x10) 
					l = Game->LoadComboData(t1->ComboD[q - 1])->Attributes[ATTBU_FLUIDPATH];
				else if(tleft) 
					l = Game->LoadComboData(tleft->ComboD[q + 0xF])->Attributes[ATTBU_FLUIDPATH];
				
				unless(q % 0x10 == 0xF) 
					r = Game->LoadComboData(t1->ComboD[q + 1])->Attributes[ATTBU_FLUIDPATH];
				else if(tright)
					r = Game->LoadComboData(tright->ComboD[q - 0xF])->Attributes[ATTBU_FLUIDPATH];
				//end
				
				if(flag > 0) //start Standard fluid
				{
					int cmb = -1;
					
					if(fl(u, flag) && fl(d, flag) && fl(l, flag) && fl(r, flag)) //all same
					{
						//start Inner Corners
						int ul,ur,bl,br;
						
						if(q > 0xF && q % 0x10)
							ul = Game->LoadComboData(t1->ComboD[q - 0x11])->Attributes[ATTBU_FLUIDPATH];
						else if(q < 0x10 && q % 0x10)
							ul = Game->LoadComboData(tup->ComboD[q + 0x8F])->Attributes[ATTBU_FLUIDPATH];
						else if(q > 0xF && !(q % 0x10))
							ul = Game->LoadComboData(tleft->ComboD[q - 1])->Attributes[ATTBU_FLUIDPATH];
						
						if(q > 0xF && (q % 0x10) != 0xF)
							ur = Game->LoadComboData(t1->ComboD[q - 0xF])->Attributes[ATTBU_FLUIDPATH];
						else if(q < 0x10 && (q % 0x10) != 0xF)
							ur = Game->LoadComboData(tup->ComboD[q + 0x91])->Attributes[ATTBU_FLUIDPATH];
						else if(q > 0xF && (q % 0x10) == 0xF)
							ur = Game->LoadComboData(tright->ComboD[q - 0x1F])->Attributes[ATTBU_FLUIDPATH];
						
						if(q < 0xA0 && q % 0x10)
							bl = Game->LoadComboData(t1->ComboD[q + 0xF])->Attributes[ATTBU_FLUIDPATH];
						else if(q > 0x9F && q % 0x10)
							bl = Game->LoadComboData(tdown->ComboD[q - 0x91])->Attributes[ATTBU_FLUIDPATH];
						else if(q < 0xA0 && !(q % 0x10))
							bl = Game->LoadComboData(tleft->ComboD[q + 0x1F])->Attributes[ATTBU_FLUIDPATH];
						
						if(q < 0xA0 && (q % 0x10) != 0xF)
							br = Game->LoadComboData(t1->ComboD[q + 0x11])->Attributes[ATTBU_FLUIDPATH];
						else if(q > 0x9F && (q % 0x10) != 0xF)
							br = Game->LoadComboData(tdown->ComboD[q - 0x8F])->Attributes[ATTBU_FLUIDPATH];
						else if(q < 0xA0 && (q % 0x10) == 0xF)
							br = Game->LoadComboData(tright->ComboD[q + 0x01])->Attributes[ATTBU_FLUIDPATH];
							
						unless(fl(ul, flag) || !(fl(ur, flag) && fl(bl, flag) && fl(br, flag)))
							cmb = CMB_TL_INNER;
						else unless(fl(ur, flag) || !(fl(ul, flag) && fl(bl, flag) && fl(br, flag)))
							cmb = CMB_TR_INNER;
						else unless(fl(bl, flag) || !(fl(ur, flag) && fl(ul, flag) && fl(br, flag)))
							cmb = CMB_BL_INNER;
						else unless(fl(br, flag) || !(fl(ur, flag) && fl(bl, flag) && fl(ul, flag)))
							cmb = CMB_BR_INNER;
						//end
						else
							cmb = 0;
					}
					else if(fl(u, flag)) //start up
					{
						if(fl(l, flag)) //start upleft
						{
							unless(fl(d, flag)) //upleft, notdown
							{
								if(fl(r, flag)) //upleftright, notdown
									cmb = CMB_BOTTOM;
								else //upleft, notrightdown
									cmb = CMB_BR_OUTER;
							}
							else unless(fl(r, flag)) //upleftdown, notright
								cmb = CMB_RIGHT;
						} //end
						else //start up not-left
						{
							if(fl(r, flag)) //upright, notleft
							{
								unless(fl(d, flag)) //upright, notdownleft
									cmb = CMB_BL_OUTER;
								else //uprightdown, notleft
									cmb = CMB_LEFT;
							}
						} //end
					} //end
					else //start notup
					{
						if(fl(r,flag)) //start right, notup
						{
							if(fl(d, flag)) //rightdown, notup
							{
								if(fl(l, flag)) //rightdownleft, notup
									cmb = CMB_TOP;
								else //rightdown, notleftup
									cmb = CMB_TL_OUTER;
							}
						} //end
						else //start notrightup
						{
							if(fl(d, flag)) //down, notrightup
								if(fl(l, flag)) //leftdown, notrightup
									cmb = CMB_TR_OUTER;
						} //end
					} //end
					
					if(cmb > -1)
					{
						if(layer==l1)
						{
							b->FastCombo(0, ComboX(q), ComboY(q), getCombo(getFluid(flag), cmb>0), t1->ComboC[q], OP_OPAQUE);
						}
						if(layer==l2 && cmb)
						{
							b->FastCombo(0, ComboX(q), ComboY(q), cmb, t1->ComboC[q], OP_OPAQUE);
						}
					}
					else if(WP_DEBUG)
						printf("[WaterPaths] Error: Bad combo calculation for fluid pos %d (f: %d, udlr: %d,%d,%d,%d)\n", q, flag, u, d, l, r);
					
				} //end
				else if(flag == VAL_BARRIER) //start Barriers
				{
					int cmb = -1;
					int flowpath = 0;
					bool flowing = false;
					
					if(u > 0 && d > 0 && l < 1 && r < 1) //horizontal barrier
					{
						flowing = getConnection(Game->GetCurLevel(), u, d);
						if(flowing)
							flowpath = u;
						
						if(l == VAL_BARRIER)
						{
							if(r == VAL_BARRIER) //Center
							{
								if(flowing)
									cmb = 0;
								else
								{
									cmb = CMB_BARRIER_HORZ;
								}
							}
							else //Left
							{
								if(flowing)
									cmb = CMB_RIGHT;
								else
									cmb = CMB_BARRIER_RIGHT;
							}
						}
						else if(r == VAL_BARRIER) //Right
						{
							if(flowing)
								cmb = CMB_LEFT;
							else
								cmb = CMB_BARRIER_LEFT;
						}
					}
					else if(l > 0 && r > 0 && u < 1 && d < 1) //vertical barrier
					{
						flowing = getConnection(Game->GetCurLevel(), l, r);
						
						if(flowing)
							flowpath = l;
						
						if(u == VAL_BARRIER)
						{
							if(d == VAL_BARRIER) //Center
							{
								if(flowing)
									cmb = 0;
								else
								{
									cmb = CMB_BARRIER_VERT;
								}
							}
							else //Up
							{
								if(flowing)
									cmb = CMB_BOTTOM;
								else
									cmb = CMB_BARRIER_BOTTOM;
							}
						}
						else if(d == VAL_BARRIER) //Down
						{
							if(flowing)
								cmb = CMB_TOP;
							else
								cmb = CMB_BARRIER_TOP;
						}
					}
					if(cmb > -1)
					{
						if(flowpath && layer==l1)
						{
							b->FastCombo(0, ComboX(q), ComboY(q), getCombo(getFluid(flowpath), cmb>0), t1->ComboC[q], OP_OPAQUE);
						}
						if(layer==l2 && cmb)
						{
							b->FastCombo(0, ComboX(q), ComboY(q), cmb, t1->ComboC[q], OP_OPAQUE);
						}
					}
					else if(WP_DEBUG)
						printf("[WaterPaths] Error: Bad combo calculation for barrier pos %d (f: %d, udlr: %d,%d,%d,%d)\n", q, flag, u, d, l, r);
					
				} //end
			}
		}
		//end
	} //end
}















