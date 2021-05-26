///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~The Terror of Necromancy Screendata / Dmapdata~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

//~~~~~OverheadTransparency~~~~~//
// So if I were to want layer 1, 2, and 3 to be transparent I would input 7 (000111b) (1 + 2 + 4) or (000001, 000010, 000100) LAYER 6 DOESNT WORK
@Author ("Venrob")
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
				{
					if (combos[c])
					{
						Screen->LayerOpacity[l] = OP_TRANS;
						break;
					}
				}
			}
			
			Waitframe();
		}	
	}
} //end

//~~~~~RadialTransparency (Fancy)~~~~~//
// D0: So if I were to want layer 1, 2, and 3 to be transparent I would input 7 (000111b) (1 + 2 + 4) or (000001, 000010, 000100)
// D1: Radius
@Author ("Venrob")
screendata script RadialTransparency //start
{
	void run(int layers, int radius)
	{			
		mapdata m[7];
		
		for (int l = 1; l < 7; ++l)
		{
			unless(layers & (1b << (l - 1)))
				continue;
			
			Screen->LayerInvisible[l] = true;
			
			unless(ohead_bmps[l]->isValid())
				ohead_bmps[l] = create(256, 256);
		 
			m[l] = Game->LoadTempScreen(l);
		}
		
		while(true)
		{
			for (int l = 1; l < 7; ++l)
			{
				unless(layers & (1b << (l - 1)))
					continue;
				
				ohead_bmps[l]->Clear(0);
				
				for (int q = 0; q < 176; ++q)
					ohead_bmps[l]->FastCombo(l, ComboX(q), ComboY(q), m[l]->ComboD[q], m[l]->ComboC[q], OP_OPAQUE);
				
				ohead_bmps[l]->Circle(l, Hero->X + 8, Hero->Y + 8, radius, 0, 1, 0, 0, 0, true, OP_OPAQUE);
				
				ohead_bmps[l]->Blit(l, -2, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
				
				for (int q = 0; q < 176; ++q)
					Screen->FastCombo(l, ComboX(q), ComboY(q), m[l]->ComboD[q], m[l]->ComboC[q], OP_TRANS);
				
			}
			
			Waitframe();
			
			if (disableTrans)
			{
				for (int l = 1; l < 7; ++l)
				{
					unless(layers & (1b << (l - 1)))
						continue;
					
					Screen->LayerInvisible[l] = false;
				}
				
				while (disableTrans) 
					Waitframe();
			}
			
			if (HeroIsScrolling())
			{
				for (int l = 1; l < 7; ++l)
				{
					unless(layers & (1b << (l - 1)))
						continue;
					
					Screen->LayerInvisible[l] = false;
				}
			}
			else
			{
				for (int l = 1; l < 7; ++l)
				{
					unless(layers & (1b << (l - 1)))
						continue;
					
					Screen->LayerInvisible[l] = true;
				}
			}
				
		}	
	}
} //end

//~~~~~DarkRegion~~~~~//
@Author ("Venrob")
dmapdata script DarkRegion //start		Credit Dimi for candle style
{	
	void run(int radius, int itemClass, int layer)
	{
		unless(darkness_bmp->isValid())
			darkness_bmp = create(256 * 3, 176 * 3);
		else
			recreate(darkness_bmp, 256 * 3, 176 * 3);
		
		Waitframe();
		Trace(darkness_bmp->Width);
		
		int animationCounter; 
		
		while(true)
		{
			Waitdraw();
		
			int id = GetHighestLevelItemOwned(itemClass);
			itemdata idata = id < 0 ? NULL : Game->LoadItemData(id);
			int power = idata ? idata->Attributes[9] : 0;
			int mode = idata ? (idata->Flags[14] ? BITDX_TRANS : 0) : 0; 
			
			animationCounter += 2;
			animationCounter %= 360;
			
			for (int i = layer; i >= 0; --i)
			{
				darkness_bmp->ClearToColor(7, C_BLACK);
				
				if (power)
					darkness_bmp->Circle(7, Hero->X + 8 + 256, Hero->Y + 8 + 176, (radius * power) + VectorY(4, animationCounter) + (i * 4), mode, 1, 0, 0, 0, true, OP_OPAQUE);
				
				if (Input->Button[CB_EX4])
					darkness_bmp->Write(7, "Test.png", true);
				
				darkness_bmp->Blit(7, -2, 256 - Game->Scrolling[SCROLL_NX], 176 - Game->Scrolling[SCROLL_NY], 256, 176, 0, 0, 256, 176, 0, 0, 0, /*mode*/ 1, 0, true);
			}
			
			
			Waitframe();
		}
	}

} //end

//D0: Layer to draw footprints on
//D1: Combo type number to draw on top of
//D1: Tile number where the animation starts
//D2: Cset of the footprints
//D3: Footprint lifetime before transitioning
//TILE ON P151 39288
//Sprite 112
@Author("Deathrider365")
dmapdata script Footprints //start
{	
	void run(int comboType)
	{
		int walkingCounter;
		int horizontalAdder = 6;
		int footprintSprite = 112;
		int previousX, previousY;
		
		while(true)
		{
			if (!HeroIsScrolling() && Hero->Action == LA_WALKING && ((previousX == Hero->X && previousY == Hero->Y) ? false : true))
			{
				previousX = Hero->X;
				previousY = Hero->Y;
				walkingCounter++;
				
				int pos = ComboAt(Link->X + 4, Link->Y + 4);
				int comboT = Screen->ComboT[pos]; 
				
				for (int i = 1; i < 3; ++i)
					if (Screen->LayerMap[i])
					{
						mapdata m = Game->LoadTempScreen(i);
						
						if (m->ComboD[pos])
							comboT = m->ComboT[pos];
					}
				
				if (comboT == comboType && walkingCounter == 12)
					createFootprint(footprintSprite);
					
				if (walkingCounter == 12)
					walkingCounter = 0;
			}
			
			Waitframe();
		}
	}
	
	void createFootprint(int footprintSprite) //start
	{
		
		lweapon footprint = Screen->CreateLWeapon(LW_SPARKLE);
		footprint->X = Hero->X;
		footprint->Y = Hero->Dir < 2 ? Hero->Y : Hero->Y + 6;
		footprint->UseSprite(Hero->Dir < 2 ? footprintSprite : footprintSprite + 1);
	} //end
	
} //end


dmapdata script NOCRASHPLZ //start
{
	void run()
	{
		Quit();
	}
} //end












