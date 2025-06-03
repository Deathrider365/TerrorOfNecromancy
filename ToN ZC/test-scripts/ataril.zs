import "std.zh"

// Atari Game Script
// v0.2
// 19th August, 2018
// By: ZoriaRPG

const float MOVE_RATE = 1;

const int PLAYER_WIDTH = 5;
const int PLAYER_HEIGHT = 8;

const int MIN_ZC_ALPHA_BUILD = 33; //Alphas are negatives, so we neex to check maximum, not minimum.


global script Atari
{
	void run()
	{

		ffc player = Screen->LoadFFC(1);
		player->Data = 188;
		bitmap playfield = Game->LoadBitmapID(RT_SCREEN);
		Link->Invisible = true; Link->DrawYOffset = -32768;
		
		check_min_zc_build();
		
		while(1)
		{
			Link->X = 60; 
			Link->Y = 60;
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
					++player->Y;
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
		int col[8]; bool coll = true;
		switch(dir)
		{
			case DIR_LEFT:
			{
				for ( int q = 0; q < PLAYER_HEIGHT; ++q )
				{
					col[q] = bmp->GetPixel(p->X-1, p->Y+q) * 10000;
				}
				
				for ( int q = 0; q < PLAYER_HEIGHT; ++q )
				{
					if ( ( col[q] % 16 ) != 0 ) 
					{
						return false;
					}
				}
				return true;
			}
			case DIR_RIGHT:
			{
				for ( int q = 0; q < PLAYER_HEIGHT; ++q )
				{
					col[q] = bmp->GetPixel(p->X+PLAYER_WIDTH, p->Y+q) * 10000;
				}
				for ( int q = 0; q < PLAYER_HEIGHT; ++ q )
				{
					if ( ( col[q] % 16 ) != 0 ) 
					{
						TraceNL(); TraceS("Pixel Colour Was: "); Trace(col);
						return false;
					}
				}
				return true;
			}
			case DIR_UP:
			{
				for ( int q = 0; q < PLAYER_WIDTH; ++q )
				{
					col[q] = bmp->GetPixel(p->X+q, p->Y-1) * 10000;
				}
				for ( int q = 0; q < PLAYER_WIDTH; ++ q )
				{
					if ( ( col[q] % 16 ) != 0 ) 
					{
						return false;
					}
				}
				return true;
			}
			case DIR_DOWN:
			{
				for ( int q = 0; q < PLAYER_WIDTH; ++q )
				{
					col[q] = bmp->GetPixel(p->X+q, p->Y+PLAYER_HEIGHT) * 10000;
				}
				for ( int q = 0; q < PLAYER_WIDTH; ++q )
				{
					if ( ( col[q] % 16 ) != 0 ) 
					{
						return false;
					}
				}
				return true;
			}
			//default: return false;
		}
		return true;
	}
	void check_min_zc_build()
	{
		if ( Game->Beta < MIN_ZC_ALPHA_BUILD )
		{
			//Game->PlayMIDI(9);
			int v_too_early = 600; int req_vers[3]; itoa(req_vers, MIN_ZC_ALPHA_BUILD);
			TraceNL(); int vers[3]; itoa(vers,Game->Beta);
			TraceS("This version of Atari.qst requires Zelda Classic v2.54, Alpha (");
			TraceS(req_vers);
			TraceS("), or later.");
			TraceNL();
			TraceS("I'm detecting Zelda Classic v2.54, Alpha (");
			TraceS(vers);
			TraceS(") and therefore, I must refuse to run. :) ");
			TraceNL();
			
			while(v_too_early--)
			{
				//Screen->DrawString(7, 4, 40, 1, 0x04, 0x5F, 0, 
				//"This version of Arkanoid.qst requires Zelda Classic 2.54, Alpha 32", 
				//128);
				Screen->DrawString(7, 15, 40, 1, 0x04, 0x5F, 0, 
				"You are not using a version of ZC adequate to run         ", 
				128);
				
				Screen->DrawString(7, 15, 55, 1, 0x04, 0x5F, 0, 
				"this quest. Please see allegro.log for details.                   ", 
				128);
			
				Waitdraw();
				WaitNoAction();
			}
			Game->End();
			
		}
	}
}

global script Init
{
	void run()
	{
		Link->Invisible = true; Link->DrawYOffset = -32768;
	}
}

global script init
{
	void run()
	{
		Link->Invisible = true; Link->DrawYOffset = -32768;
	}
}

global script onContinue
{
	void run()
	{
		Link->Invisible = true; Link->DrawYOffset = -32768;
	}
}
