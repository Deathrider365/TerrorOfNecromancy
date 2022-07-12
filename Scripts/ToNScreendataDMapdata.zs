///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~The Terror of Necromancy Screendata / Dmapdata~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

//~~~~~OverheadTransparency~~~~~//
// D0: Each layer is represented by a bit EX:(layers 3, 4, 5 would be represented by 00011100 = 28) LAYER 6 DOESNT WORK
@Author ("EmilyV99")
screendata script OverheadTransparency //start
{
	void run(int layers)
	{
		while(true)
		{
			for (int l = 1; l < 7; ++l)
			{
				unless(layers & (1b << (l - 1)))
					continue;
					
				mapdata m = Game->LoadTempScreen(l);
				
				int combos[] = {m->ComboD[ComboAt(Hero->X, Hero->Y)], 
				                m->ComboD[ComboAt(Hero->X + 15, Hero->Y)], 
				                m->ComboD[ComboAt(Hero->X, Hero->Y +15)],
				                m->ComboD[ComboAt(Hero->X + 15, Hero->Y + 15)]};
				
				Screen->LayerOpacity[l] = 255;
				
				for (int c = 0; c < 4; ++c)
					if (combos[c])
					{
						Screen->LayerOpacity[l] = OP_TRANS;
						break;
					}
			}
			
			Waitframe();
		}	
	}
} //end

//~~~~~RadialTransparency (Fancy)~~~~~//
// D0: Each layer is represented by a bit EX:(layers 3, 4, 5 would be represented by 00011100 = 28) LAYER 6 DOESNT WORK
// D1: Radius
@Author ("EmilyV99")
screendata script RadialTransparency //start
{
	void run(int layers, int radius)
	{			
		mapdata m[6];
		
		for (int l = 1; l < 6; ++l)
		{
			unless(layers & (1b << (l - 1)))
				continue;
			
			Screen->LayerInvisible[l] = true;
			
			unless(ohead_bmps[l]->isValid())
				ohead_bmps[l] = create(256, 176);
		 
			m[l] = Game->LoadTempScreen(l);
		}
		
		while(true)
		{
			for (int l = 1; l < 6; ++l)
			{
				unless(layers & (1b << (l - 1)))
					continue;
				
				ohead_bmps[l]->Clear(0);
				
				for (int q = 0; q < 176; ++q)
					ohead_bmps[l]->FastCombo(l, ComboX(q), ComboY(q), m[l]->ComboD[q], m[l]->ComboC[q], OP_OPAQUE);
				
				ohead_bmps[l]->Circle(l, Hero->X + 8, Hero->Y + 8, radius, 0, 1, 0, 0, 0, true, OP_OPAQUE);
				
				for (int q = 0; q < 176; ++q)
					Screen->FastCombo(l, ComboX(q), ComboY(q), m[l]->ComboD[q], m[l]->ComboC[q], OP_TRANS);
					
				ohead_bmps[l]->Blit(l, -1, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
			}
			
			Waitframe();
			
			if (disableTrans)
			{
				for (int l = 1; l < 6; ++l)
				{
					unless(layers & (1b << (l - 1)))
						continue;
					
					Screen->LayerInvisible[l] = false;
				}
				
				while (disableTrans) 
					Waitframe();
			}
			
			if (HeroIsScrolling())
				for (int l = 1; l < 6; ++l)
				{
					unless(layers & (1b << (l - 1)))
						continue;
					
					Screen->LayerInvisible[l] = false;
				}
			else
				for (int l = 1; l < 6; ++l)
				{
					unless(layers & (1b << (l - 1)))
						continue;
					
					Screen->LayerInvisible[l] = true;
				}
		}	
	}
} //end

//~~~~~DarkRegion~~~~~//
// D0: Radius
// D1: itemClass (probably a candle)
// D2: Layer
@Author ("EmilyV99, Dimi for pulsing lantern effect")
dmapdata script DarkRegion //start		Credit Dimi for candle style
{	
	void run(int radius, int itemClass, int layer, int torchPower)
	{
		unless(darkness_bmp->isValid())
			darkness_bmp = create(256 * 3, 176 * 4.5); //This and 132 shoould be * 3, * 4.5 is not a good fix
		else
			recreate(darkness_bmp, 256 * 3, 176 * 4.5);
		
		int animationCounter;
		
		while(true)
		{
			Waitdraw();
		
			int id = GetHighestLevelItemOwned(itemClass);
			itemdata idata = id < 0 ? NULL : Game->LoadItemData(id);
			int power = idata ? idata->Attributes[9] : 0;
			int mode = 0;
			
			if (idata) 
				mode = idata->Flags[14] ? BITDX_TRANS : 0;
			
			animationCounter += 2;
			animationCounter %= 360;
			
			for (int i = layer; i >= 0; --i)
			{
				darkness_bmp->ClearToColor(layer, C_BLACK);
				
				if (power)
					darkness_bmp->Circle(layer, Hero->X + 8 + 256, Hero->Y + 8 + 176, (radius * power) + VectorY(4, animationCounter) + (i * 4), mode, 1, 0, 0, 0, true, OP_OPAQUE);
				
				if (torchPower)
				{
					for (int xPos = 0; xPos < 256; xPos += 16)
					{
						for (int yPos = 0; yPos < 176; yPos += 16)
						{
							int pos = ComboAt(xPos, yPos);
							int comboT = Screen->ComboT[pos]; 
							
							for (int lightLayer = 1; lightLayer < 3; ++lightLayer)
								if (Screen->LayerMap[lightLayer])
								{
									mapdata m = Game->LoadTempScreen(lightLayer);
									
									if (m->ComboD[pos])
										comboT = m->ComboT[pos];
								}
							
							if (comboT == CT_LIGHT_EMITING_TORCH)
								darkness_bmp->Circle(layer, xPos + 8 + 256, yPos + 8 + 176, (radius * torchPower) + VectorY(4, animationCounter) + (i * 4), mode, 1, 0, 0, 0, true, OP_OPAQUE);
						}
					}
				}
				
				darkness_bmp->Blit(layer, -2, 256 - Game->Scrolling[SCROLL_NX], 176 - Game->Scrolling[SCROLL_NY], 256, 176, 0, 0, 256, 176, 0, 0, 0, 1, 0, true);
			}
			
			Waitframe();
		}
	}
} //end


