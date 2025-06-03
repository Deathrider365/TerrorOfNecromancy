import "std.zh"


global script a
{
	void run()
	{
		
		while(1)
		{
			if ( Input->ReadKey[KEY_U] )
			{
				lweapon s = Screen->CreateLWeapon(LW_SCRIPT9);
				s->X = 50; s->Y = 50; Trace(Screen->NumLWeapons());
				s->CollDetection = false;
				
			}
			if ( Input->ReadKey[KEY_I] ) Trace(Screen->NumLWeapons());
			if ( Input->ReadKey[KEY_O] )
			{
				for ( int q = Screen->NumLWeapons(); q > 0; --q )
				{
					lweapon l = Screen->LoadLWeapon(q);
					l->DeadState = WDS_DEAD;
				}
			}
			Waitframe();
		}
	}
}

lweapon script scr9
{
	void run()
	{
		TraceS("Running Weapon Script scr9"); TraceNL();
		int clk = 200;
		this->X = 50; this->Y = 50;
		
		while(1)
		{
			//++this->ScriptTile;
			if ( Input->ReadKey[KEY_P] )
			{
				this->DeadState = WDS_DEAD;
				Trace(this->DeadState);
				
			}

			Waitframe();
		}
	}
}

npc script n
{
	void run()
	{
		while(this->isValid())
		{
			//TraceS("NPC Script N is Running"); TraceNL();
			//TraceS("CanMove returned: "); TraceB(this->CanMove({this->Dir,4,0}));
			bool can = this->CanMove({this->Dir});
			if ( !can ) { TraceS("CanMove returned false."); TraceNL(); }
			if ( Input->ReadKey[KEY_N] ) this->Attack();
			if ( Input->ReadKey[KEY_K] ) this->Remove();	
		if ( Input->ReadKey[KEY_L] ) this->Slide();
			Waitframe();
		}
	}
}

npc script floater_old
{
	void run()
	{
		TraceS("Running npc script 'test'"); TraceNL();
		this->Dir = Rand(0,3);
		while(this->isValid())
		{


			this->FloatingWalk({10,200,2});
			Waitframe();
		}
	}
}

npc script floater
{
	void run()
	{
		int attack_clk;
		TraceS("Running npc script 'test'"); TraceNL();
		this->Dir = Rand(0,3);
		switch(this->Dir)
		{
			case DIR_UP: this->ScriptTile = 862; break;
			case DIR_DOWN: this->ScriptTile = 861; break;
			case DIR_LEFT: this->ScriptTile = 882; break;
			case DIR_RIGHT: this->ScriptTile = 881; break;
			default: break;
		}

		this->ScriptTile = this->Tile;
		while(this->isValid())
		{
			switch(this->Dir)
			{
				case DIR_UP: this->ScriptTile = 862; break;
				case DIR_DOWN: this->ScriptTile = 861; break;
				case DIR_LEFT: this->ScriptTile = 882; break;
				case DIR_RIGHT: this->ScriptTile = 881; break;
				default: break;
			}
			//this->ScriptTile;
			//if ( this->CanMove(this->Dir) )
			//{
				this->FloatingWalk({10,200,2});
			//}
			if ( this->LinedUp(200,true) )
			{
				if ( this->LinkInRange(100) )
				{
					if (!attack_clk)
					{
						attack_clk = 100;
						this->Attack();
					}
				}
			}
			if (attack_clk) --attack_clk;
			Waitframe();
		}
	}
}

npc script walker
{
	void run()
	{
		int attack_clk;
		TraceS("Running npc script 'test'"); TraceNL();
		this->Dir = Rand(0,3);
		switch(this->Dir)
		{
			case DIR_UP: this->ScriptTile = 862; break;
			case DIR_DOWN: this->ScriptTile = 861; break;
			case DIR_LEFT: this->ScriptTile = 882; break;
			case DIR_RIGHT: this->ScriptTile = 881; break;
			default: break;
		}

		this->ScriptTile = this->Tile;
		while(this->isValid())
		{
			switch(this->Dir)
			{
				case DIR_UP: this->ScriptTile = 862; break;
				case DIR_DOWN: this->ScriptTile = 861; break;
				case DIR_LEFT: this->ScriptTile = 882; break;
				case DIR_RIGHT: this->ScriptTile = 881; break;
				default: break;
			}
			//this->ScriptTile;
			//if ( this->CanMove(this->Dir) )
			//{
				this->HaltingWalk({10,1,0,50,2});
			//}
			if ( this->LinedUp(200,true) )
			{
				if ( this->LinkInRange(100) )
				{
					if (!attack_clk)
					{
						attack_clk = 100;
						this->Attack();
					}
				}
			}
			if (attack_clk) --attack_clk;
			Waitframe();
		}
	}
}


			
