const float MOVE_RATE = 1;

global script Atari
{
	void run()
	{
		ffc player = Screen->LoadFFC(1);
		bitmap playfield = Game->LoadBitMapID(RT_SCREEN);
		while(1)
		{
			if ( Input->Press[CB_LEFT] ) 
			{
				if ( canmove(DIR_LEFT, player, playfield) )
				{
					--player->X;
				}
			}
			if ( Input->Hold[CB_LEFT] ) 
			{
				if ( canmove(DIR_LEFT, player, playfield) )
				{
					--player->X;
				}
			}
			if ( Input->Press[CB_DOWN] ) 
			{
				if ( canmove(DIR_DOWN, player, playfield) )
				{
					++player->Y;
				}
			}
			if ( Input->Hold[CB_DOWN] ) 
			{
				if ( canmove(DIR_DOWN, player, playfield) )
				{
					++player->Y
				}
			}
			if ( Input->Press[CB_UP] ) 
			{
				if ( canmove(DIR_UP, player, playfield) )
				{
					--player->Y;
				}
			}
			if ( Input->Hold[CB_UP] ) 
			{
				if ( canmove(DIR_UP, player, playfield) )
				{
					--player->Y;
				}
			}
			if ( Input->Press[CB_RIGHT] ) 
			{
				if ( canmove(DIR_RIGHT, player, playfield) )
				{
					++player->X;
				}
			}
			if ( Input->Hold[CB_RIGHT] ) 
			{
				if ( canmove(DIR_RIGHT, player, playfield) )
				{
					++player->X;
				}
			}
			Waitdraw();
			Waitframe();
		}
	}
	bool canmove(int dir, ffc p, bitmap bmp)
	{
		switch(dir)
		{
			case DIR_LEFT:
			{
				if ( bpm->GetPixel(p->X-1, p->Y) != 0 ) return false;
			}
			case DIR_RIGHT:
			{
				if ( bpm->GetPixel(p->X+16, p->Y) != 0 ) return false;
			}
			case DIR_UP:
			{
				if ( bpm->GetPixel(p->X, p->Y-1) != 0 ) return false;
			}
			case DIR_DOWN:
			{
				if ( bpm->GetPixel(p->X, p->Y+16) != 0 ) return false; 
			}
			default: return false;
		}
		return true;
	}
}