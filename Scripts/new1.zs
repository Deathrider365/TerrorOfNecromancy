//D0: Layer to draw footprints on
//D1: Combo type number to draw on top of
//D1: Tile number where the animation starts
//D2: Cset of the footprints
//D3: Footprint lifetime before transitioning
//TILE ON P151 39288
dmapdata script ANewFootprints //start
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
						
					switch(walkingCounter)
					{
						case 1:
							pos1[0] = Hero->X;
							pos1[1] = Hero->Y;
							pos1[2] = Hero->Dir;
							pos1[3] = (Hero->Dir == DIR_LEFT || Hero->Dir == DIR_RIGHT) ? horizontalAdder : 0;
							pos1[4] = printLifeTime;
							break;
						case 12:
							pos2[0] = Hero->X;
							pos2[1] = Hero->Y;
							pos2[2] = Hero->Dir;
							pos2[3] = (Hero->Dir == DIR_LEFT || Hero->Dir == DIR_RIGHT) ? horizontalAdder : 0;
							pos2[4] = printLifeTime;
							break;
						case 24:
							pos3[0] = Hero->X;
							pos3[1] = Hero->Y;
							pos3[2] = Hero->Dir;
							pos3[3] = (Hero->Dir == DIR_LEFT || Hero->Dir == DIR_RIGHT) ? horizontalAdder : 0;
							pos3[4] = printLifeTime;
							break;
						case 36:
							pos4[0] = Hero->X;
							pos4[1] = Hero->Y;
							pos4[2] = Hero->Dir;
							pos4[3] = (Hero->Dir == DIR_LEFT || Hero->Dir == DIR_RIGHT) ? horizontalAdder : 0;
							pos4[4] = printLifeTime;
							break;
						case 48:
							pos5[0] = Hero->X;
							pos5[1] = Hero->Y;
							pos5[2] = Hero->Dir;
							pos5[3] = (Hero->Dir == DIR_LEFT || Hero->Dir == DIR_RIGHT) ? horizontalAdder : 0;
							pos5[4] = printLifeTime;
							break;
						case 60:
							pos6[0] = Hero->X;
							pos6[1] = Hero->Y;
							pos6[2] = Hero->Dir;
							pos6[3] = (Hero->Dir == DIR_LEFT || Hero->Dir == DIR_RIGHT) ? horizontalAdder : 0;
							pos6[4] = printLifeTime;
							break;
					} 
					
					if (pos1[4] > 0)
						pos1[4]--;
					else
						pos1[4] = 0;
						
					if (pos2[4] > 0)
						pos2[4]--;
					else
						pos2[4] = 0;
						
					if (pos3[4] > 0)
						pos3[4]--;
					else
						pos3[4] = 0;
						
					if (pos4[4] > 0)
						pos4[4]--;
					else
						pos4[4] = 0;
						
					if (pos5[4] > 0)
						pos5[4]--;
					else
						pos5[4] = 0;
						
					if (pos6[4] > 0)
						pos6[4]--;
					else
						pos6[4] = 0;
					
				}
				
				if (pos1[4] > 0)
					draw(layer, cset, pos1, startingTile);
					
				if (pos2[4] > 0)
					draw(layer, cset, pos2, startingTile);
					
				if (pos3[4] > 0)
					draw(layer, cset, pos3, startingTile);
					
				if (pos4[4] > 0)
					draw(layer, cset, pos4, startingTile);
					
				if (pos5[4] > 0)
					draw(layer, cset, pos5, startingTile);
					
				if (pos6[4] > 0)
					draw(layer, cset, pos6, startingTile);
					
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
	void draw(int layer, int cset, int pos[], int startingTile) //start
	{
		if (pos[4] > 60)
			pos[5] = 0;
		else if (pos[4] > 48)
			pos[5] = 1;
		else if(pos[4] > 36)
			pos[5] = 2;
		else if(pos[4] > 24)
			pos[5] = 3;
		else if(pos[4] > 12)
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
	
} //end











