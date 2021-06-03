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
@Author("Emily")
ffc script WarpCustomReturn //start
{
	void run(int d1, int x, int y, int sideFacing, int warp, int d2, int x2, int y2)
	{
		int dm = Floor(d1), scr = (d1 % 1) / 1L;
		int dm2 = Floor(d2), scr2 = (d2 % 1) / 1L;
		int wtype = Floor(warp), warpEffect = (warp % 1) / 1L;
		int side = Floor(sideFacing), dir = (sideFacing % 1) / 1L;
		
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
						else Hero->WarpEx({wtype, dm, scr, x, y, warpEffect, 0, 0, dir});
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
						else Hero->WarpEx({wtype, dm, scr, x, y, warpEffect, 0, 0, dir});
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
						else Hero->WarpEx({wtype, dm, scr, x, y, warpEffect, 0, 0, dir});
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
						else Hero->WarpEx({wtype, dm, scr, x, y, warpEffect, 0, 0, dir});
					}
					Waitframe();
				}
			}
			default: //Tile warp, at the FFC's location.
			{
				while(true)
				{
					if(Abs(Hero->X-this->X) <= 14 && Abs(Hero->Y-this->Y) <= 14)
						Hero->WarpEx({wtype, dm, scr, x, y, warpEffect, 0, 0, dir});
					Waitframe();
				}
			}
		}
	}
}
//end

//~~~~~BossNameString~~~~~//
//D0: String number
@Author("Deathrider365")
ffc script BossNameString //start
{
	void run(int string)
	{
		Waitframes(4);
		
		if (EnemiesAlive())
			Screen->Message(string);
	}
}

//end

//~~~~~NormalString~~~~~//
//D0: Number of string to show
//D1: 1 -> Trigger on secret, 0 -> No Secret
@Author("Deathrider365")
ffc script NormalString //start
{
	void run(int m, int triggerOnSecret)
	{
		if (triggerOnSecret)
		{
			if (Screen->State[ST_SECRET])
			{
				Waitframes(2);
				Screen->Message(m);
			}
			else
				Waitframe();
		}
		else
		{
			Waitframes(2);
			Screen->Message(m);
		}
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
@Author("Joe123")
ffc script Signpost //start
{
	void run(int msg, bool anySide)
	{
		int loc = ComboAt(this->X, this->Y);
		
		while(true)
		{
			until(AgainstComboBase(loc, anySide) && Input->Press[CB_SIGNPOST]) 
			{
				if (AgainstComboBase(loc, anySide))
					Screen->FastCombo(7, Link->X - 10, Link->Y - 15, 48, 0, OP_OPAQUE);
					
				Waitframe();
			}			
			
			Input->Button[CB_SIGNPOST] = false;
			Screen->Message(msg);
			Waitframe();
		}
	}
}

//end

//~~~~~MessageOnce~~~~~//
//D0: Number of string to show
@Author("Deathrider365")
ffc script MessageOnce //start
{
	void run(int msg)
	{
		unless(getScreenD(255))
			Screen->Message(msg);
		
		setScreenD(255, true);
	}
} //end


























