import "std.zh"

global script a
{
	int explode_link;
	int explode_npcs;
	void run()
	{
		while(1)
		{
			if ( Input->ReadKey[KEY_1] ) 
			{
				explode_npcs = 0;
			}
			if ( Input->ReadKey[KEY_2] ) 
			{
				explode_npcs = 1;
			}
			if ( Input->ReadKey[KEY_3] ) 
			{
				explode_npcs = 2;
			}
			if ( Input->ReadKey[KEY_4] ) 
			{
				explode_link = 0;
			}
			if ( Input->ReadKey[KEY_5] ) 
			{
				explode_link = 1;
			}
			if ( Input->ReadKey[KEY_5] ) 
			{
				explode_link = 2;
			}
			if ( Input->ReadKey[KEY_N] ) 
			{
				for ( int q = Screen->NumNPCs(); q > 0; --q )
				{
					npc n = Screen->LoadNPC(q);
					n->Stun = 5000;
					n->DrawXOffset = -10000;
					n->Explode(explode_npcs);
				}
			}
			if ( Input->ReadKey[KEY_I] ) 
			{
				Link->Invisible = !Link->Invisible;
			}
			if ( Input->ReadKey[KEY_L] ) 
			{
				Link->Explode(explode_link);
			}
			Waitdraw(); Waitframe();
		}
	}
}