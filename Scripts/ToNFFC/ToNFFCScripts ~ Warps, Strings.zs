///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~The Terror of Necromancy FFC Scripts ~ Warps, Strings~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

//~~~~~MessageThenWarp~~~~~//
//D0: Message number to show
//D1: Dmap to warp Link to
//D2: Screen on the specified dmap to warp Link to
@Author("Deathrider365")
ffc script MessageThenWarp //start
{	
	void run(int msg, int dmap, int scr)
	{
		while(Game->Suspend[susptGUYS]) Waitframe();
		NoAction();
		Link->PressStart = false;
		Link->InputStart = false;
		Link->PressMap = false;
		Link->InputMap = false;
		Screen->Message(msg);
		Waitframe();
		Hero->WarpEx({WT_IWARPBLACKOUT, dmap, scr, -1, WARP_A, WARPFX_NONE, 0, 0, DIR_DOWN});
	}
}
//end

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

//~~~~~BossNameString~~~~~//
//D0: String number
@Author("Deathrider365")
ffc script BossNameString //start
{
	void run(int string)
	{
		Waitframes(4);
		while(Game->Suspend[susptGUYS]) Waitframe();
		
		if (EnemiesAlive())
			Screen->Message(string);
	}
}

//end


//~~~~~DungeonString~~~~~//
//D0: Number of string to show
@Author("Deathrider365")
ffc script DungeonString //start
{
	void run(int m)
	{
		while(Game->Suspend[susptGUYS]) Waitframe();
		unless (levelEntries[Game->GetCurLevel()])
		{
			levelEntries[Game->GetCurLevel()] = true;
			Waitframes(2);
			Screen->Message(m);		
		}
	}
}

//end

//~~~~~SignPost~~~~~//
//D0: Number of string to show
//D1: 0 for not anyside 1 for anyside
@Author("Joe123, Deathrider365")
ffc script Signpost //start
{
	void run(int msg)
	{
		while(true)
		{
			while(!(againstFFC(this->X, this->Y) && Input->Press[CB_SIGNPOST])) 
			{
				if (againstFFC(this->X, this->Y))
					Screen->FastCombo(7, Link->X - 10, Link->Y - 15, 48, 0, OP_OPAQUE);
					
				Waitframe();
			}			
			
			Input->Button[CB_SIGNPOST] = false;
			Game->Suspend[susptSCREENDRAW] = true;
			Screen->Message(msg);
			Game->Suspend[susptSCREENDRAW] = false;
			Waitframe();
		}
	}
}
//end

//~~~~~TalkToMeTwice~~~~~//
@Author("Joe123")
ffc script TalkToMeTwice //start
{
	void run(int talkToMeOnce, int talkToMeTwice)
	{
		while(true)
		{
			until(againstFFC(this->X, this->Y) && Input->Press[CB_SIGNPOST]) 
			{
				if (againstFFC(this->X, this->Y))
					Screen->FastCombo(7, Link->X - 10, Link->Y - 15, 48, 0, OP_OPAQUE);
					
				Waitframe();
			}			
			
			Input->Button[CB_SIGNPOST] = false;
			Game->Suspend[susptSCREENDRAW] = true;
			
			if (getScreenD(255))
				Screen->Message(talkToMeTwice);
			else
				Screen->Message(talkToMeOnce);
				
			Game->Suspend[susptSCREENDRAW] = false;
			
			setScreenD(255, true);
			
			Waitframe();
		}
	}
}
//end

//~~~~~SignPostOnSecret~~~~~//
//D0: Number of string to show
//D1: 0 for not anyside 1 for anyside
@Author("Joe123")
ffc script SignPostOnSecret //start
{
	void run(int messageNoSecret, int messageSecret)
	{
		while(true)
		{
			until(againstFFC(this->X, this->Y) && Input->Press[CB_SIGNPOST]) 
			{
				if (againstFFC(this->X, this->Y))
					Screen->FastCombo(7, Link->X - 10, Link->Y - 15, 48, 0, OP_OPAQUE);
					
				Waitframe();
			}			
			
			Input->Button[CB_SIGNPOST] = false;
			Game->Suspend[susptSCREENDRAW] = true;
			
			if (Screen->State[ST_SECRET])
				Screen->Message(messageSecret);
			else
				Screen->Message(messageNoSecret);
			
			Game->Suspend[susptSCREENDRAW] = false;
			Waitframe();
		}
	}
}
//end

//~~~~~ConditionalSignPost~~~~~//
//D0: Number of string to show
//D1: 0 for not anyside 1 for anyside
@Author("Joe123")
ffc script ConditionalSignPost //start
{
	void run(int msg, bool anySide, int itemConditional, int specialMsg)
	{
		while(true)
		{
			until(againstFFC(this->X, this->Y) && Input->Press[CB_SIGNPOST]) 
			{
				if (againstFFC(this->X, this->Y))
					Screen->FastCombo(7, Link->X - 10, Link->Y - 15, 48, 0, OP_OPAQUE);
					
				Waitframe();
			}			
			
			Input->Button[CB_SIGNPOST] = false;
			Game->Suspend[susptSCREENDRAW] = true;
			Screen->Message(Hero->Item[itemConditional] ? specialMsg : msg);
			Game->Suspend[susptSCREENDRAW] = false;
			Waitframe();
		}
	}
}

//end

//~~~~~SignPostOnce~~~~~//
//DOESNT AFFECT screenD, just plays messages based on if screenD was changed!
//D0: Number of string to show
//D1: 0 for not anyside 1 for anyside
@Author("Joe123 + Deathrider365")
ffc script SignpostBasedOnScreenD //start
{
	void run(int msgFirst, int msgSubsequent, bool anySide)
	{
		Waitframes(2);
		while(Game->Suspend[susptGUYS]) Waitframe();
		
		while(true)
		{
			until(againstFFC(this->X, this->Y) && Input->Press[CB_SIGNPOST]) 
			{
				if (againstFFC(this->X, this->Y))
					Screen->FastCombo(7, Link->X - 10, Link->Y - 15, 48, 0, OP_OPAQUE);
					
				Waitframe();
			}			
			
			Input->Button[CB_SIGNPOST] = false;
			
			unless (getScreenD(255))
			{
				Screen->Message(msgFirst);
				
				Waitframes(2);
				
				Input->Button[CB_SIGNPOST] = false;
			}
			else
				Screen->Message(msgSubsequent);
			
			Waitframe();
			
		}
	}
}

//end

@Author("Deathrider365")
ffc script MessageOnce {
   void run(int message) {
      while(Game->Suspend[susptGUYS]) 
         Waitframe();
      
      unless(getScreenD(255))
         Screen->Message(message);
      
      setScreenD(255, true);
   }
}

//~~~~~FatherAndSonDialogue~~~~~//
// Sets screenD(255) upon receiving
//D0: Item ID to give
//D1: String for getting the item
//D2: String for if you already got the item
//D3: 1 for all dirs, 0 for only front (up)
@Author("Deathrider365")
ffc script FatherAndSonDialogue //start
{
	void run(
		int itemId, 
		int gettingItemString, 
		int alreadyGotItemString, 
		int anySide, 
		int triggerOnScreenD, 
		int itemToCheckFor
		)
	{
		mapdata template = Game->LoadTempScreen(1);
		int prevData = this->Data;
		
		if (Hero->Item[itemToCheckFor])
		{
			this->Data = 0;
			template->ComboD[ComboAt(this->X, this->Y)] = 0;
			Quit();
		}
		
		if (triggerOnScreenD)
		{
			until(getScreenD(triggerOnScreenD))
			{
				this->Data = 0;
				template->ComboD[ComboAt(this->X, this->Y)] = 0;
				Waitframe();
			}
		
			template->ComboD[ComboAt(this->X, this->Y)] = COMBO_SOLID;
		}
			
		this->Data = prevData;

		while(true)
		{
			if (triggerOnScreenD)
				while (/*Screen->NumNPCs() && */!Screen->State[ST_SECRET])
					Waitframe();
			
			until(againstFFC(this->X, this->Y) && Input->Press[CB_SIGNPOST])
			{
				if (againstFFC(this->X, this->Y))
					Screen->FastCombo(7, Link->X - 10, Link->Y - 15, 48, 0, OP_OPAQUE);
					
				if (getScreenD(triggerOnScreenD) && Screen->State[ST_SECRET]) 
					this->Data = 6755;

				Waitframe();
			}			

			Input->Button[CB_SIGNPOST] = false;

			unless (getScreenD(255))
			{
				Screen->Message(gettingItemString);

				Waitframes(2);

				itemsprite it = CreateItemAt(itemId, Hero->X, Hero->Y);
				it->Pickup = IP_HOLDUP;
				
				Input->Button[CB_SIGNPOST] = false;
				setScreenD(255, true);
			}
			else
				Screen->Message(alreadyGotItemString);

			Waitframe();
		}
	}
}
//end
























