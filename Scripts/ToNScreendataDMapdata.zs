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
// So if I were to want layer 1, 2, and 3 to be transparent I would input 7 (000111b) (1 + 2 + 4) or (000001, 000010, 000100)
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
dmapdata script DarkRegion //start
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
@Author("Deathrider365")
dmapdata script Footprints //start
{	
	void run(int layer, int comboType, int startingTile, int cset, int printLifeTime)
	{
		int walkingCounter;
		int horizontalAdder = 6;
		int pos1[6], pos2[6], pos3[6], pos4[6], pos5[6], pos6[6];
		int previousX, previousY;
		
		while(true)
		{
			if (!HeroIsScrolling())
			{
				if (Hero->Action == LA_WALKING && ((previousX == Hero->X && previousY == Hero->Y) ? false : true))
				{
					previousX = Hero->X;
					previousY = Hero->Y;
					
					walkingCounter++;
					
					if (walkingCounter == printLifeTime)
						walkingCounter = 0;
					
					if (Screen->ComboT[ComboAt(Link->X + 4, Link->Y + 6)] == comboType)
					{
						// if (walkingCounter == 1)
							// saveInstance(pos1, horizontalAdder, printLifeTime);
						// else if(walkingCounter == (printLifeTime / 6))
							// saveInstance(pos2, horizontalAdder, printLifeTime);
						// else if(walkingCounter == (printLifeTime / 3))
							// saveInstance(pos3, horizontalAdder, printLifeTime);
						// else if(walkingCounter == (printLifeTime / 2))
							// saveInstance(pos4, horizontalAdder, printLifeTime);
						// else if(walkingCounter == (printLifeTime / 1.5))
							// saveInstance(pos5, horizontalAdder, printLifeTime);
						// else if(walkingCounter == (printLifeTime / 1.2))
							// saveInstance(pos6, horizontalAdder, printLifeTime);
							
						if (walkingCounter % 8 == 0)
							saveInstance(pos1, horizontalAdder, printLifeTime);
							
							
							
					}
					
					if (pos1[4] > 0)
						pos1[4]--;
						
					if (pos2[4] > 0)
						pos2[4]--;
						
					if (pos3[4] > 0)
						pos3[4]--;
						
					if (pos4[4] > 0)
						pos4[4]--;
						
					if (pos5[4] > 0)
						pos5[4]--;
						
					if (pos6[4] > 0)
						pos6[4]--;
					
				}
				
				if (pos1[4] > 0)
					draw(layer, cset, pos1, startingTile, printLifeTime);
					
				if (pos2[4] > 0)
					draw(layer, cset, pos2, startingTile, printLifeTime);
					
				if (pos3[4] > 0)
					draw(layer, cset, pos3, startingTile, printLifeTime);
					
				if (pos4[4] > 0)
					draw(layer, cset, pos4, startingTile, printLifeTime);
					
				if (pos5[4] > 0)
					draw(layer, cset, pos5, startingTile, printLifeTime);
					
				if (pos6[4] > 0)
					draw(layer, cset, pos6, startingTile, printLifeTime);
					
			}
			else
			{
				walkingCounter = 0;
				clearPos(pos1);
				clearPos(pos2);
				clearPos(pos3);
				clearPos(pos4);
				clearPos(pos5);
				clearPos(pos6);
				previousX = 0;
				previousY = 0;
				
				for (int i = startingTile; i < (horizontalAdder * 2); ++i)
					ClearTile(i);
			}
			
			Waitframe();
		}
	}
	
	// Draws the correct tiles bases on the "age" (pos[4]) of the footprint
	void draw(int layer, int cset, int pos[], int startingTile, int printLifeTime) //start
	{
		if (pos[4] > (printLifeTime / 1.2))
			pos[5] = 0;
		else if (pos[4] > (printLifeTime / 1.5))
			pos[5] = 1;
		else if(pos[4] > (printLifeTime / 2))
			pos[5] = 2;
		else if(pos[4] > (printLifeTime / 3))
			pos[5] = 3;
		else if(pos[4] > (printLifeTime / 6))
			pos[5] = 4;
		else if (pos[4] > 0)
			pos[5] = 5;
			
		Screen->FastTile(layer, pos[0], pos[1], startingTile + pos[3] + pos[5], cset, OP_OPAQUE);
	} //end
	
	// Clears pos[] for screen transitions
	void clearPos(int pos[]) //start
	{
		for (int i = 0; i < 6; ++i)
			pos[i] = 0;
	} //end
	
	// Saves Link's information in a provided pos[]
	void saveInstance(int pos[], int horizontalAdder, int printLifeTime) //start
	{
		pos[0] = Hero->X;
		pos[1] = Hero->Y;
		pos[2] = Hero->Dir;
		pos[3] = (Hero->Dir == DIR_LEFT || Hero->Dir == DIR_RIGHT) ? horizontalAdder : 0;
		pos[4] = printLifeTime;
	} //end
	
} //end














