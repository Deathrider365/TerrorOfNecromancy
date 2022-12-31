
namespace Emily::EmilyMap {
   CONFIG COLOR_NULL = 0x0F;
   CONFIG COLOR_FRAME = 0x01;
   CONFIG COLOR_CUR_ROOM = 0x66;
   CONFIG CUR_ROOM_BORDER_THICKNESS = 4;
   CONFIG INPUT_REPEAT_TIME = 3;
   CONFIG ZOOM_INPUT_REPEAT_TIME = 12;
   CONFIG MAP_PUSH_PIXELS = 16;
   CONFIGB ALLOW_COMBO_ANIMS = false;
   DEFINE MAP_PUSH_VAL = MAP_PUSH_PIXELS/8;

   void generateMap(bitmap bmp, dmapdata this, bool lockPalette, bitmap currentScreen) {
      bool isOverworld = ((this->Type & 11b) == DMAP_OVERWORLD);
      
      bmp->Clear(0);
      int mapWidth = isOverworld ? 16 : 8;
      int leftEdge = Max(this->Offset, 0);
      int rightEdge = Min(this->Offset + mapWidth - 1, 15);
      int xdraw = -1;
      bitmap tmp = create(256, 176);
      
      int layer1, layer2;
      bool paths;
      
      if (this->Script == Game->GetDMapScript("WaterPaths")) {
         paths = true;
         
         for (int q = 6; q >= 0; --q) {
            if (this->InitD[0] & (1b << q)) {
               if (layer2)  {
                  layer1 = q;
                  break;
               } else 
                  layer2 = q;
            }
         }
      }

      for (int x = leftEdge; x <= rightEdge; ++x) {
         ++xdraw;
         int ydraw = -1;
         
         for (int y = 0; y < 8; ++y) {
            ++ydraw;
            int screen = x + (y * 0x10);
            mapdata mapData = Game->LoadMapData(this->Map, screen);
            bool null = false;
            
            if (lockPalette && mapData->Palette != this->Palette)
               null = true;
               
            unless (mapData->State[ST_VISITED])
               null = true;
               
            unless (mapData->Valid & 1b)
               null = true;
               
            if (null)
               tmp->ClearToColor(7, COLOR_NULL);
            else {
               tmp->Clear(7);
               bool bg2 = isBG(false, mapData, this);
               bool bg3 = isBG(true, mapData, this);
               
               if (bg2) {
                  tmp->DrawLayer(7, this->Map, screen, 2, 0, 0, 0, OP_OPAQUE);
                  handlePaths(tmp, mapData, 2, layer1, layer2);
               }
               if (bg3) {
                  tmp->DrawLayer(7, this->Map, screen, 3, 0, 0, 0, OP_OPAQUE);
                  handlePaths(tmp, mapData, 3, layer1, layer2);
               }
               
               tmp->DrawLayer(7, this->Map, screen, 0, 0, 0, 0, OP_OPAQUE);
               handlePaths(tmp, mapData, 0, layer1, layer2);
               tmp->DrawLayer(7, this->Map, screen, 1, 0, 0, 0, OP_OPAQUE);
               handlePaths(tmp, mapData, 1, layer1, layer2);
               
               // non-overlay ffcs
               for (int freeformCombo = 1; freeformCombo < 33; ++freeformCombo) {
                  unless (mapData->FFCData[freeformCombo]) 
                     continue;
                  
                  if (mapData->FFCFlags[freeformCombo] & (FFCBF_CHANGER | FFCBF_ETHEREAL | FFCBF_LENSVIS))
                     continue;
                     
                  // Skip drawing overlays
                  if (mapData->FFCFlags[freeformCombo] & FFCBF_OVERLAY) 
                     continue;
                  
                  tmp->DrawCombo(
                     7, 
                     mapData->FFCX[freeformCombo], 
                     mapData->FFCY[freeformCombo], 
                     mapData->FFCData[freeformCombo], 
                     mapData->FFCTileWidth[freeformCombo], 
                     mapData->FFCTileHeight[freeformCombo],
                     mapData->FFCCSet[freeformCombo], 
                     -1, -1, 0, 0, 0, 0, FLIP_NONE, true, (mapData->FFCFlags[freeformCombo] & FFCBF_TRANS) ? OP_TRANS : OP_OPAQUE
                  );
               }
               
               unless (bg2) {
                  tmp->DrawLayer(7, this->Map, screen, 2, 0, 0, 0, OP_OPAQUE);
                  handlePaths(tmp, mapData, 2, layer1, layer2);
               }
               unless (bg3) {
                  tmp->DrawLayer(7, this->Map, screen, 3, 0, 0, 0, OP_OPAQUE);
                  handlePaths(tmp, mapData, 3, layer1, layer2);
               }
               
               tmp->DrawLayer(7, this->Map, screen, 4, 0, 0, 0, OP_OPAQUE);
               handlePaths(tmp, mapData, 4, layer1, layer2);
               tmp->DrawLayer(7, this->Map, screen, 5, 0, 0, 0, OP_OPAQUE);
               handlePaths(tmp, mapData, 5, layer1, layer2);
               
               // overlay ffcs
               for (int freeformCombo = 1; freeformCombo < 33; ++freeformCombo) {
                  unless (mapData->FFCData[freeformCombo]) 
                     continue;
                  
                  if (mapData->FFCFlags[freeformCombo] & (FFCBF_CHANGER | FFCBF_ETHEREAL | FFCBF_LENSVIS))
                     continue;
                  
                  unless (mapData->FFCFlags[freeformCombo] & (1b<<FFCF_OVERLAY)) //Only draw overlays
                     continue; 
                  
                  tmp->DrawCombo(
                     7, 
                     mapData->FFCX[freeformCombo], 
                     mapData->FFCY[freeformCombo], 
                     mapData->FFCData[freeformCombo], 
                     mapData->FFCTileWidth[freeformCombo], 
                     mapData->FFCTileHeight[freeformCombo],
                     mapData->FFCCSet[freeformCombo], 
                     -1, -1, 0, 0, 0, 0, FLIP_NONE, true, (mapData->FFCFlags[freeformCombo] & FFCBF_TRANS) ? OP_TRANS : OP_OPAQUE);
               } //end
               
               tmp->DrawLayer(7, this->Map, screen, 6, 0, 0, 0, OP_OPAQUE);
               handlePaths(tmp, mapData, 6, layer1, layer2);
               
               if (currentScreen && screen == Game->GetCurScreen()) {
                  currentScreen->Blit(7, tmp, 0, 0, 256, 168, 0, 0, 256, 168, 0, 0, 0, BITDX_NORMAL, 0, false);
                  
                  for (int q = 0; q < CUR_ROOM_BORDER_THICKNESS; ++q) 
                     tmp->Rectangle(7, q, q, 255 - q, 175 - q, COLOR_CUR_ROOM, 1, 0, 0, 0, false, OP_OPAQUE);
               }
            }
            
            tmp->Blit(7, bmp, 0, 0, 256, 176, xdraw * 256, ydraw * 176, 256, 176, 0, 0, 0, BITDX_NORMAL, 0, false);
         }
      }
      
      tmp->Free();
   }
	
   @Author("EmilyV99")
   dmapdata script Map {
      void run(bool lockPalette) {
         DEFINE WIDTH = 256 * 16;
         DEFINE HEIGHT = 176 * 8;
         
         bitmap bmp = create(WIDTH,HEIGHT);
         bitmap currentScreen = create(256,168);
         currentScreen->BlitTo(7, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
         generateMap(bmp, this, lockPalette, currentScreen);
         
         bool isOverworld = ((this->Type & 11b) == DMAP_OVERWORLD);
         int mapWidth = isOverworld ? 16 : 8;
         int usableWidth = isOverworld ? WIDTH : WIDTH / 2;
         int minZoom = mapWidth;
         int x = 0, y = 0;
         int zoom = minZoom;
         int inputClock, zoomInputClock;
         
         do {
            inputClock = (inputClock + 1) % INPUT_REPEAT_TIME;
            zoomInputClock = (zoomInputClock + 1) % ZOOM_INPUT_REPEAT_TIME;
            
            bool pressed = true;
            bool zoomed = true;
            
            if (Input->Press[CB_A] || (!zoomInputClock && Input->Button[CB_A]))
               --zoom;
            else if (Input->Press[CB_B] || (!zoomInputClock && Input->Button[CB_B]))
               ++zoom;
            else 
               zoomed = false;
            
            zoom = VBound(zoom, minZoom, 1);
            int zoomMultiplier = minZoom / zoom;
            int moveMultiplier = minZoom /(minZoom - zoom + 1);
            
            if (Input->Press[CB_L] || (!inputClock && Input->Button[CB_L]))
               moveMultiplier *= 2;
            
            bool pressedUp = Input->Press[CB_UP] || (!inputClock && Input->Button[CB_UP]);
            bool pressedDown = Input->Press[CB_DOWN] || (!inputClock && Input->Button[CB_DOWN]);
            bool pressedLeft = Input->Press[CB_LEFT] || (!inputClock && Input->Button[CB_LEFT]);
            bool pressedRight = Input->Press[CB_RIGHT] || (!inputClock && Input->Button[CB_RIGHT]);
            
            if (pressedUp)
               y += MAP_PUSH_VAL * moveMultiplier;
            if (pressedDown)
               y -= MAP_PUSH_VAL * moveMultiplier;
            if (pressedLeft)
               x += MAP_PUSH_VAL * moveMultiplier;
            if (pressedRight)
               x -= MAP_PUSH_VAL * moveMultiplier;
               
            unless (pressedUp || pressedDown || pressedLeft || pressedRight)
               pressed = false;
            
            if (pressed) 
               inputClock = 1;
            if (zoomed)
               zoomInputClock = 1;
            
            if (isOverworld) {
               x = VBound(x, 128 + 112, -128 - 112); //VBound(x, (usableWidth)/2-256, (-usableWidth)/2-256);
               y = VBound(y, 112 + 94.5, 58.5); //VBound(y, (HEIGHT)/2-224, (-HEIGHT)/2-224);
            } else {
               x = VBound(x, 128 + 96, -128 - 96);//VBound(x, (usableWidth)/2-256, (-usableWidth)/2-256);
               y = VBound(y, 112 + 77, -112 + 5);//VBound(y, (HEIGHT)/2-224, (-HEIGHT)/2-224);
            }
            
            int tx = (256 + ((x - 256) * zoomMultiplier)) / 2;
            int ty = ((224 + ((y - 224) * zoomMultiplier)) / 2) - 28;
            
            Screen->Rectangle(7, 0, -56, 255, 175, COLOR_NULL, 1, 0, 0, 0, true, OP_OPAQUE);
            Screen->Rectangle(7, tx - 1, ty - 1, tx + usableWidth / zoom, ty + HEIGHT / zoom, COLOR_FRAME, 1, 0, 0, 0, false, OP_OPAQUE);
            
            bmp->Blit(7, RT_SCREEN, 0, 0, usableWidth, HEIGHT, tx, ty, usableWidth / zoom, HEIGHT / zoom, 0, 0, 0, BITDX_NORMAL, 0, false);
            
            Waitframe();
            
            if (ALLOW_COMBO_ANIMS)
               generateMap(bmp, this, lockPalette, currentScreen);
               
         } until (Input->Press[CB_MAP] || Input->Press[CB_START]);
         
         Input->Press[CB_MAP] = false;
         Input->Button[CB_MAP] = false;
         Input->Press[CB_START] = false;
         Input->Button[CB_START] = false;
         
         bmp->Free();
      }
   }
	
   bool isBG(bool l3, mapdata m, dmapdata dm) {
      if (l3)
         return (GetMapscreenFlag(m, MSF_LAYER3BG) ^^ dm->Flagset[DMFS_LAYER3ISBACKGROUND]);
      else
         return (GetMapscreenFlag(m, MSF_LAYER2BG) ^^ dm->Flagset[DMFS_LAYER2ISBACKGROUND]);
   }

	void handlePaths(bitmap bmp, mapdata template, int layer, int layer1, int layer2) {
		using namespace WaterPaths;
      
		if (layer != layer1 && layer != layer2) 
         return;
         
		mapdata currentMapLayer1 = Emily::loadLayer(template, layer1);
      mapdata currentMapLayer2 = Emily::loadLayer(template, layer2);
		mapdata templateLeft, templateRight, templateUp, templateDown;
		
      unless (template->Screen < 0x10)
         templateUp = Emily::loadLayer(Game->LoadMapData(template->Map, template->Screen - 0x10), layer1);
      unless (template->Screen >= 0x70)
         templateDown = Emily::loadLayer(Game->LoadMapData(template->Map, template->Screen + 0x10), layer1);
      if (template->Screen % 0x10)
         templateLeft = Emily::loadLayer(Game->LoadMapData(template->Map, template->Screen - 1), layer1);
      unless (template->Screen % 0x10 == 0xF)
         templateRight = Emily::loadLayer(Game->LoadMapData(template->Map, template->Screen + 1), layer1);
		
		enum {
			PASS_LIQUID,
			PASS_BARRIERS,
			PASS_COUNT
		};
		
		for (int pass = 0; pass < PASS_COUNT; ++pass) {
			for (int combo = 0; combo < 176; ++combo) {
				if (currentMapLayer1->ComboT[combo] != CT_FLUID)
					continue;
					
				combodata comboData = Game->LoadComboData(currentMapLayer1->ComboD[combo]);
				int flag = comboData->Attributes[ATTBU_FLUIDPATH];
				
				switch(pass) {
					case PASS_LIQUID:
						unless (flag > 0) 
                     continue;
						break;
					case PASS_BARRIERS:
						unless (flag == VAL_BARRIER) 
                     continue;
						break;
				}
					
				int up, down, left, right;
				
				unless (combo < 0x10)
					up = Game->LoadComboData(currentMapLayer1->ComboD[combo - 0x10])->Attributes[ATTBU_FLUIDPATH];
				else if (templateUp)
					up = Game->LoadComboData(templateUp->ComboD[combo + 0x90])->Attributes[ATTBU_FLUIDPATH];
				
				unless (combo >= 0xA0)
					down = Game->LoadComboData(currentMapLayer1->ComboD[combo + 0x10])->Attributes[ATTBU_FLUIDPATH];
				else if (templateDown)
					down = Game->LoadComboData(templateDown->ComboD[combo - 0x90])->Attributes[ATTBU_FLUIDPATH];
				
				if (combo % 0x10) 
					left = Game->LoadComboData(currentMapLayer1->ComboD[combo - 1])->Attributes[ATTBU_FLUIDPATH];
				else if (templateLeft) 
					left = Game->LoadComboData(templateLeft->ComboD[combo + 0xF])->Attributes[ATTBU_FLUIDPATH];
				
				unless (combo % 0x10 == 0xF) 
					right = Game->LoadComboData(currentMapLayer1->ComboD[combo + 1])->Attributes[ATTBU_FLUIDPATH];
				else if (templateRight)
					right = Game->LoadComboData(templateRight->ComboD[combo - 0xF])->Attributes[ATTBU_FLUIDPATH];
				
            // Standard fluid
				if (flag > 0) {
					int cmb = -1;
					
               //all same
					if (isBarrierFlag(up, flag) && isBarrierFlag(down, flag) && isBarrierFlag(left, flag) && isBarrierFlag(right, flag)) {
						//start Inner Corners
						int upperLeft, upperRight, lowerLeft, lowerRight;
						
						if (combo > 0xF && combo % 0x10)
							upperLeft = Game->LoadComboData(currentMapLayer1->ComboD[combo - 0x11])->Attributes[ATTBU_FLUIDPATH];
						else if (combo < 0x10 && combo % 0x10)
							upperLeft = Game->LoadComboData(templateUp->ComboD[combo + 0x8F])->Attributes[ATTBU_FLUIDPATH];
						else if (combo > 0xF && !(combo % 0x10))
							upperLeft = Game->LoadComboData(templateLeft->ComboD[combo - 1])->Attributes[ATTBU_FLUIDPATH];
						
						if (combo > 0xF && (combo % 0x10) != 0xF)
							upperRight = Game->LoadComboData(currentMapLayer1->ComboD[combo - 0xF])->Attributes[ATTBU_FLUIDPATH];
						else if (combo < 0x10 && (combo % 0x10) != 0xF)
							upperRight = Game->LoadComboData(templateUp->ComboD[combo + 0x91])->Attributes[ATTBU_FLUIDPATH];
						else if (combo > 0xF && (combo % 0x10) == 0xF)
							upperRight = Game->LoadComboData(templateRight->ComboD[combo - 0x1F])->Attributes[ATTBU_FLUIDPATH];
						
						if (combo < 0xA0 && combo % 0x10)
							lowerLeft = Game->LoadComboData(currentMapLayer1->ComboD[combo + 0xF])->Attributes[ATTBU_FLUIDPATH];
						else if (combo > 0x9F && combo % 0x10)
							lowerLeft = Game->LoadComboData(templateDown->ComboD[combo - 0x91])->Attributes[ATTBU_FLUIDPATH];
						else if (combo < 0xA0 && !(combo % 0x10))
							lowerLeft = Game->LoadComboData(templateLeft->ComboD[combo + 0x1F])->Attributes[ATTBU_FLUIDPATH];
						
						if (combo < 0xA0 && (combo % 0x10) != 0xF)
							lowerRight = Game->LoadComboData(currentMapLayer1->ComboD[combo + 0x11])->Attributes[ATTBU_FLUIDPATH];
						else if (combo > 0x9F && (combo % 0x10) != 0xF)
							lowerRight = Game->LoadComboData(templateDown->ComboD[combo - 0x8F])->Attributes[ATTBU_FLUIDPATH];
						else if (combo < 0xA0 && (combo % 0x10) == 0xF)
							lowerRight = Game->LoadComboData(templateRight->ComboD[combo + 0x01])->Attributes[ATTBU_FLUIDPATH];
							
						unless (isBarrierFlag(upperLeft, flag) || !(isBarrierFlag(upperRight, flag) && isBarrierFlag(lowerLeft, flag) && isBarrierFlag(lowerRight, flag)))
							cmb = CMB_TL_INNER;
						else unless (isBarrierFlag(upperRight, flag) || !(isBarrierFlag(upperLeft, flag) && isBarrierFlag(lowerLeft, flag) && isBarrierFlag(lowerRight, flag)))
							cmb = CMB_TR_INNER;
						else unless (isBarrierFlag(lowerLeft, flag) || !(isBarrierFlag(upperRight, flag) && isBarrierFlag(upperLeft, flag) && isBarrierFlag(lowerRight, flag)))
							cmb = CMB_BL_INNER;
						else unless (isBarrierFlag(lowerRight, flag) || !(isBarrierFlag(upperRight, flag) && isBarrierFlag(lowerLeft, flag) && isBarrierFlag(upperLeft, flag)))
							cmb = CMB_BR_INNER;
						else
							cmb = 0;
					}
               // up
					else if (isBarrierFlag(up, flag)) {
                  // upleft
						if (isBarrierFlag(left, flag)) {
                     // upleft, notdown
							unless (isBarrierFlag(down, flag)) {
                        // upleftright, notdown
								if (isBarrierFlag(right, flag)) 
									cmb = CMB_BOTTOM;
                        // upleft, notrightdown
								else 
									cmb = CMB_BR_OUTER;
							}
                     //upleftdown, notright
							else unless (isBarrierFlag(right, flag))
								cmb = CMB_RIGHT;
						}
                  //up not-left
						else {
                     //upright, notleft
							if (isBarrierFlag(right, flag)) {
                        //upright, notdownleft
								unless (isBarrierFlag(down, flag))
									cmb = CMB_BL_OUTER;
                        //uprightdown, notleft
                        else 
									cmb = CMB_LEFT;
							}
						}
					}
               // notup
					else {
                  // right, notup
						if (isBarrierFlag(right,flag)) {
                     // rightdown, notup
							if (isBarrierFlag(down, flag)) {
                        //rightdownleft, notup
								if (isBarrierFlag(left, flag)) 
									cmb = CMB_TOP;
								//rightdown, notleftup
                        else 
									cmb = CMB_TL_OUTER;
							}
						}
                  // notrightup
						else {
                     //down, notrightup
							if (isBarrierFlag(down, flag))
                        //leftdown, notrightup
								if (isBarrierFlag(left, flag))
									cmb = CMB_TR_OUTER;
						}
					}
					if (cmb > -1) {
						if (layer == layer1)
							bmp->FastCombo(7, ComboX(combo), ComboY(combo), getCombo(getFluid(flag), cmb > 0), currentMapLayer1->ComboC[combo], OP_OPAQUE);
						if (layer == layer2 && cmb)
							bmp->FastCombo(7, ComboX(combo), ComboY(combo), cmb, currentMapLayer1->ComboC[combo], OP_OPAQUE);
					}
					else if (WP_DEBUG)
						printf("[WaterPaths] Error: Bad combo calculation for fluid pos %d (f: %d, udlr: %d,%d,%d,%d)\n", combo, flag, up, down, left, right);
					
				}
            // Barriers
				else if (flag == VAL_BARRIER) {
					int cmb = -1;
					int flowpath = 0;
					bool flowing = false;
					
               // horizontal barrier
					if (up > 0 && down > 0 && left < 1 && right < 1) {
						flowing = getConnection(Game->GetCurLevel(), up, down);
						
                  if (flowing)
							flowpath = up;
						
						if (left == VAL_BARRIER) {
                     // Center
							if (right == VAL_BARRIER) {
								if (flowing)
									cmb = 0;
								else
									cmb = CMB_BARRIER_HORZ;
							}
                     // Left
							else {
								if (flowing)
									cmb = CMB_RIGHT;
								else
									cmb = CMB_BARRIER_RIGHT;
							}
						}
                  // Right
						else if (right == VAL_BARRIER) {
							if (flowing)
								cmb = CMB_LEFT;
							else
								cmb = CMB_BARRIER_LEFT;
						}
					}
               // vertical barrier
					else if (left > 0 && right > 0 && up < 1 && down < 1) {
						flowing = getConnection(Game->GetCurLevel(), left, right);
						
						if (flowing)
							flowpath = left;
						
						if (up == VAL_BARRIER){
                     // Center
							if (down == VAL_BARRIER) {
								if (flowing)
									cmb = 0;
								else
									cmb = CMB_BARRIER_VERT;
							}
                     // Up
							else {
								if (flowing)
									cmb = CMB_BOTTOM;
								else
									cmb = CMB_BARRIER_BOTTOM;
							}
						}
                  // Down
						else if (down == VAL_BARRIER) {
							if (flowing)
								cmb = CMB_TOP;
							else
								cmb = CMB_BARRIER_TOP;
						}
					}
					if (cmb > -1) {
						if (flowpath && layer == layer1)
							bmp->FastCombo(7, ComboX(combo), ComboY(combo), getCombo(getFluid(flowpath), cmb > 0), currentMapLayer1->ComboC[combo], OP_OPAQUE);
						if (layer == layer2 && cmb)
							bmp->FastCombo(7, ComboX(combo), ComboY(combo), cmb, currentMapLayer1->ComboC[combo], OP_OPAQUE);
					}
					else if (WP_DEBUG)
						printf("[WaterPaths] Error: Bad combo calculation for barrier pos %d (f: %d, udlr: %d,%d,%d,%d)\n", combo, flag, up, down, left, right);
					
				}
			}
		}
	}
}