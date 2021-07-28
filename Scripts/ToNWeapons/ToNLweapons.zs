///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~LWeapons~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

//~~~~~GaleBoomerang~~~~~//
//REQUIRES: `ZScript>>Quest Script Settings>>Objects` - `Weapons Live One Extra Frame With WDS_DEAD` must be checked.
//InitD[]:
//D0: turn rate (degrees per frame)
//D1: wind drop rate (every x frames, drop wind visual effect)
// Sprites[]:
// -0 = sprite for the weapon
// -1 = sprite for the wind visual effect
@Author("EmilyV99")
lweapon script GaleBRang //start
{	
	void run(int turnRate, int wind_drop_rate) //start
	{
		Game->FFRules[qr_WEAPONS_EXTRA_FRAME] = true;
		Game->FFRules[qr_OLDSPRITEDRAWS] = false;
		Game->FFRules[qr_CHECKSCRIPTWEAPONOFFSCREENCLIP] = true;
		itemdata parent;
		int wind_sprite;
		int windClock;
		int sfxClock;
		int sfx;
		
		if(this->Parent > -1) //Initialize with data from the item that created this.
		{
			parent = Game->LoadItemData(this->Parent);
			this->UseSprite(parent->Sprites[0]);
			wind_sprite = parent->Sprites[1];
			sfx = parent->UseSound;
		}
		else //If this weapon was created by a script, instead of an item, initialize with defaults.
		{
			parent = NULL;
			this->UseSprite(DEFAULT_SPRITE);
			wind_sprite = DEFAULT_WIND_SPRITE;
			sfx = DEFAULT_SFX;
		}
		
		this->Angular = true;
		this->Angle = DirRad(this->Dir);
		int radTurnRate = DegtoRad(turnRate);
		bool controlling = (Input->Button[CB_A] || Input->Button[CB_B]);
		itemsprite dragging = NULL;
		bool collided = false;
		
		until(this->DeadState == WDS_DEAD || collided) //start
		{
			if(dragging)
			{
				dragging->X = this->X;
				dragging->Y = this->Y;
			}
			
			if(controlling)
			{
				if(Input->Button[CB_LEFT])
					this->Angle -= radTurnRate;
				else if(Input->Button[CB_RIGHT])
					this->Angle += radTurnRate;
			}
			
			int position = ComboAt(this->X + 8, this->Y + 8);
			
			for(int q = 0; q <= (BOUNCE_OFF_FLAGS_ON_LAYERS_1_AND_2 ? 2 : 0); ++q)
			{
				mapdata m = Game->LoadTempScreen(q);
				
				if(m->ComboF[position] == CF_BRANG_BOUNCE || m->ComboI[position] == CF_BRANG_BOUNCE)
					collided = true;
			}
			
			for(int q = Screen->NumItems(); q > 0; --q)
			{
				itemsprite it = Screen->LoadItem(q);
				
				unless(it->Pickup & IP_TIMEOUT) 
					continue;
				
				if(Collision(it, this))
				{
					dragging = it;
					collided = STOPS_WHEN_GRABBING_ITEMS;
				}
			}
			
			if(this->X < 0 || this->Y < 0 || (this->X + this->HitWidth) > 255 || (this->Y + this->HitHeight) > 175)
				collided = true; //Collide if off-screen
				
			if(controlling)
				++Hero->Stun;
				
			windClock = (windClock + 1) % wind_drop_rate;
			sfxClock = (sfxClock + 1) % SFX_DELAY;
			
			unless(windClock) 
				drop_sparkle(this->X, this->Y, wind_sprite);
				
			unless(sfxClock)
				Audio->PlaySound(sfx);
			
			this->Rotation = WrapDegrees(this->Rotation + ROTATION_RATE);
			Waitframe();
			
			if(controlling) 
				controlling = (Input->Button[CB_A] || Input->Button[CB_B]);
		} //end
		
		while(true) //start
		{
			this->DeadState = WDS_ALIVE;
			this->Angle = TurnTowards(this->X, this->Y, Hero->X, Hero->Y, this->Angle, 1); //Turn directly towards the Hero.
			
			if(Collision(this)) //touching the Hero
			{
				this->DeadState = WDS_DEAD;
				
				if(dragging)
				{
					dragging->X = Hero->X;
					dragging->Y = Hero->Y;
				}
				
				return;
			}
			
			if(dragging)
			{
				dragging->X = this->X;
				dragging->Y = this->Y;
			}
			
			windClock = (windClock + 1) % wind_drop_rate;
			sfxClock = (sfxClock + 1) % SFX_DELAY;
			
			unless(windClock) 
				drop_sparkle(this->X, this->Y, wind_sprite);
				
			unless(sfxClock) 
				Audio->PlaySound(sfx);
				
			this->Rotation = WrapDegrees(this->Rotation + ROTATION_RATE);
			Waitframe();
		} //end
	
	} //end
	
	void drop_sparkle(int x, int y, int sprite) //start
	{
		lweapon sparkle = Screen->CreateLWeapon(LW_SPARKLE);
		sparkle->X = x;
		sparkle->Y = y;
		sparkle->UseSprite(sprite);
	} //end
}

//end

//~~~~~PortalSphere~~~~~//
@Author("Deathrider365")
lweapon script PortalSphere //start
{
	void run()
	{

	}
}

//end

// the item that when used on an enemy of boss will display the health bar work where it will be a weapon script that basically checks the id of the enemy
// it hit and if it is a boss then display the health bar for n seconds (perhaps 10)
//~~~~~Scholar's Candelabra~~~~~//
@Author("Deathrider365")
lweapon script ScholarCandelabra //start
{
	void run()
	{

	}
}
//end

//~~~~~Sine Wave~~~~~//
@Author("KoolAidWannaBe I THINK")
lweapon script SineWave //start
{
	void run(int amplitude, int frequency)
	{
		this->Angle = DirRad(this->Dir);
		this->Angular = true;
		int x = this->X;
		int y = this->Y;
		int clock;
		int dist;
		
		while(true)
		{
			clock += frequency;
			clock %= 360;
			
			x += RadianCos(this->Angle) * this->Step * .01;
			y += RadianSin(this->Angle) * this->Step * .01;
			
			dist = Sin(clock) * amplitude;
			
			this->X = x + VectorX(dist, RadtoDeg(this->Angle) - 90);
			this->Y = y + VectorY(dist, RadtoDeg(this->Angle) - 90);
			Waitframe();
		}
	}
} //end

//~~~~~Death's Touch~~~~~//
@Author("Deathrider365")
lweapon script DeathsTouch //start
{
	void run()
	{
		//an aura n pixel circle around link that does x dps to all enemies in the radius and has a lasting damage effect even after they leave. works on all except undead until
		// the triforce of death is cleansed, then it hurts only undead but for a lot more than before it was cleansed (extremely useful for the legionnaire crypt)
		
		// lweapon deathsAura;
		// deathsAura->X = Hero->X - 8;
		// deathsAura->Y = Hero->Y - 8;
		// deathsAura->LoadSpriteData
		
		for (int i = 0; i < 240; ++i)
		{
			Screen->DrawCombo(7, this->X, this->Y, 6854, 2, 2, 0, 1, 1, 0, 0, 0, 0, 0, true, OP_OPAQUE);
		
			Waitframe();
		}
		
		// void DrawCombo	(int layer, int x, int y, 
		// int combo, int w, int h, 
		// int cset, int xscale, int yscale, 
		// int rx, int ry, int rangle, 
		// int frame, int flip, 
		// bool transparency, int opacity);
		
		//1: draw growing circle
		//2: loop for every enemy on screen and do collision check
		//3: apply damage to enemies touching
		//4: shrink circle when done
	}
}
//end

