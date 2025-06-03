//Flying enemym with hardcoded sprite and animations
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
			if ( this->LinedUp(60,true) )
			{
				if ( this->LinkInRange(60) )
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

//Hard codes a walking enemy sprite
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
			if ( this->LinedUp(60,true) )
			{
				if ( this->LinkInRange(60) )
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


//Uses the Enemy Editor to draw the sprite and do its animation
npc script walker2 
{
	void run()
	{
		int attack_clk;
		//TraceS("Running npc script 'test'"); TraceNL();
		this->Dir = Rand(0,3);
		
		while(this->isValid())
		{
			//if ( this->CanMove(this->Dir) )
			//{
				this->HaltingWalk({10,1,0,50,2});
			//}
			if ( this->LinedUp(20,false) > -1 )
			{
				if ( this->LinkInRange(60) )
				{
					if (!attack_clk)
					{
						attack_clk = 100;
						this->Attack();
					}
				}
			}
			if (attack_clk) --attack_clk;
			if ( Input->ReadKey[KEY_0] ) this->Attack();
			Waitframe();
		}
	}
}