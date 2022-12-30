///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~The Terror of Necromancy FFC Scripts ~ Warps, Strings~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

@Author("Deathrider365")
ffc script MessageOnce {
   void run(int message, bool dungeonString, int screenD) {
      while(Game->Suspend[susptGUYS]) 
         Waitframe();
      
      if (dungeonString) {
         unless (levelEntries[Game->GetCurLevel()]) {
            levelEntries[Game->GetCurLevel()] = true;
            Waitframe();
            Screen->Message(message);		
         }
      } else {
         unless(getScreenD(screenD))
            Screen->Message(message);
         
         setScreenD(screenD, true);
      }
   }
}

@Author("Joe123, Deathrider365")
ffc script Signpost {
   CONFIG SMT_SCREEND = 1;
   CONFIG SMT_SECRETS = 2;
   CONFIG SMT_HAS_ITEM = 3;

   void run(int message, int warp, int hasSecondMessage, int secondMessage) { 
      int secondMessageTrigger, secondMessageTriggerValue;
      
      if (hasSecondMessage) {
         secondMessageTrigger = Floor(hasSecondMessage);
         secondMessageTriggerValue = (hasSecondMessage % 1) / 1L; 
      }

      while(true) {
         until(againstFFC(this->X, this->Y) && Input->Press[CB_SIGNPOST]) {
            if (againstFFC(this->X, this->Y))
               Screen->FastCombo(7, Link->X - 10, Link->Y - 15, 48, 0, OP_OPAQUE);
            Waitframe();
         }         
         
         Input->Button[CB_SIGNPOST] = false;
         Game->Suspend[susptSCREENDRAW] = true;
         
         switch(secondMessageTrigger) {
            case SMT_SCREEND:
               unless (getScreenD(secondMessageTriggerValue)) {
                  Screen->Message(message);
                  setScreenD(secondMessageTriggerValue, true);
               } else {
                  Screen->Message(secondMessage);
               }
               break;
            case SMT_SECRETS:
               unless (Screen->State[ST_SECRET])
                  Screen->Message(message);
               else
                  Screen->Message(secondMessage);
               break;
            case SMT_HAS_ITEM:
               unless (Hero->Item[secondMessageTriggerValue])
                  Screen->Message(message);
               else
                  Screen->Message(secondMessage);
               break;
            default:
               Screen->Message(message);
               break;
         }
         
         Game->Suspend[susptSCREENDRAW] = false;
         Waitframe();
         
         if (warp) {
            int dmap = Floor(warp);
            int screen = (warp % 1) / 1L;
            Hero->WarpEx({WT_IWARPBLACKOUT, dmap, screen, -1, WARP_A, WARPFX_NONE, 0, 0, DIR_DOWN});
         }
      }
   }
}

//~~~~~WarpCustomReturn~~~~~//
//Dirs: -1 = Tile, 0 = Up, 1 = Down, 2 = Left, 3 = Right
//If d2 is set, and the warp is a sidewarp, it will use the FFC's x/y to split into 2 sidewarps
//d1 / d2 = 'dmap.screen', i.e. dm1scr1 = 1.0001
@Author("EmilyV99")
ffc script WarpCustomReturn //start
{
	void run(int d1, int x, int y, int sideFacing, int warp, int d2, int x2, int y2)
	{
		int dm = Floor(d1);
		int scr = (d1 % 1) / 1L;
		int dm2 = Floor(d2);
		int scr2 = (d2 % 1) / 1L;
		int wtype = Floor(warp);
		int warpEffect = (warp % 1) / 1L;
		int side = Floor(sideFacing);
		int dir = (sideFacing % 1) / 1L;
		
		switch(side)
		{
			case DIR_UP:
			{
				while(true)
				{
					if(Hero->Y <= 1.5 && Hero->InputUp)
					{
						if(d2 && Hero->X >= this->X)
							Hero->WarpEx({wtype, dm2, scr2, x2, y2, warpEffect, 0, 0, dir});
						else 
							Hero->WarpEx({wtype, dm, scr, x, y, warpEffect, 0, 0, dir});
					}
					Waitframe();
				}
			}
			case DIR_DOWN:
			{
				while(true)
				{
					if(Hero->Y >= 158.5 && Hero->InputDown)
					{
						if(d2 && Hero->X >= this->X)
							Hero->WarpEx({wtype, dm2, scr2, x2, y2, warpEffect, 0, 0, dir});
						else 
							Hero->WarpEx({wtype, dm, scr, x, y, warpEffect, 0, 0, dir});
					}
					Waitframe();
				}
			}
			case DIR_LEFT:
			{
				while(true)
				{
					if(Hero->X <= 1.5 && Hero->InputLeft)
					{
						if(d2 && Hero->Y >= this->Y)
							Hero->WarpEx({wtype, dm2, scr2, x2, y2, warpEffect, 0, 0, dir});
						else 
							Hero->WarpEx({wtype, dm, scr, x, y, warpEffect, 0, 0, dir});
					}
					Waitframe();
				}
			}
			case DIR_RIGHT:
			{
				while(true)
				{
					if(Hero->X >= 238.5 && Hero->InputRight)
					{
						if(d2 && Hero->Y >= this->Y)
							Hero->WarpEx({wtype, dm2, scr2, x2, y2, warpEffect, 0, 0, dir});
						else 
							Hero->WarpEx({wtype, dm, scr, x, y, warpEffect, 0, 0, dir});
					}
					Waitframe();
				}
			}
			default: //Tile warp, at the FFC's location.
			{
				while(true)
				{
					if(Abs(Hero->X - this->X) <= 14 && Abs(Hero->Y - this->Y) <= 14)
						Hero->WarpEx({wtype, dm, scr, x, y, warpEffect, 0, 0, dir});
					Waitframe();
				}
			}
		}
	}
}
//end

//~~~~~WarpCustomReturnOneSide~~~~~//
//D0: Dmap to warp to
//D1: Screen to warp to
//D2: Side of screen Link is hitting
//D3: Direction to have Link face on warp
//D4: Warp type
//D5: Warp effect
//D6: 1 = the sidewarp will occur when Link is left or below the FFC, 0 otherwise for other side
ffc script WarpCustomReturnOneSide //start
{
	void run(int dmap, int screen, int side, int dir, int warpType, int warpEffect, int leftOrBelow, int rightOrAbove)
	{
		switch(side)
		{
			case DIR_UP:
			{
				while(true)
				{
					if(Hero->Y <= 1.5 && Hero->InputUp)
					{
						if (leftOrBelow && Hero->X <= this->X)
							Hero->WarpEx({warpType, dmap, screen, -1, WARP_A, warpEffect, 0, 0, dir});
						else if (rightOrAbove && Hero->X >= this->X)
							Hero->WarpEx({warpType, dmap, screen, -1, WARP_A, warpEffect, 0, 0, dir});
					}
					Waitframe();
				}
			}
			case DIR_DOWN:
			{
				while(true)
				{
					if(Hero->Y >= 158.5 && Hero->InputDown)
					{
						if(leftOrBelow && Hero->X <= this->X)
							Hero->WarpEx({warpType, dmap, screen, -1, WARP_A, warpEffect, 0, 0, dir});
						else if (rightOrAbove && Hero->X >= this->X)
							Hero->WarpEx({warpType, dmap, screen, -1, WARP_A, warpEffect, 0, 0, dir});
					}
					Waitframe();
				}
			}
			case DIR_LEFT:
			{
				while(true)
				{
					if(Hero->X <= 1.5 && Hero->InputLeft)
					{
						if(leftOrBelow && Hero->Y >= this->Y)
							Hero->WarpEx({warpType, dmap, screen, -1, WARP_A, warpEffect, 0, 0, dir});
						else if(rightOrAbove && Hero->Y <= this->Y)
							Hero->WarpEx({warpType, dmap, screen, -1, WARP_A, warpEffect, 0, 0, dir});
					}
					Waitframe();
				}
			}
			case DIR_RIGHT:
			{
				while(true)
				{
					if(Hero->X >= 238.5 && Hero->InputRight)
					{
						if(leftOrBelow && Hero->Y >= this->Y)
							Hero->WarpEx({warpType, dmap, screen, -1, WARP_A, warpEffect, 0, 0, dir});
						else if(rightOrAbove && Hero->Y <= this->Y)
							Hero->WarpEx({warpType, dmap, screen, -1, WARP_A, warpEffect, 0, 0, dir});
					}
					Waitframe();
				}
			}
		}
	
	}
} //end





















