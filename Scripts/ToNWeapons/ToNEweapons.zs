///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~EWeapon~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

//~~~~~~~~~SignWave~~~~~~~~~~//
@Author("DONT REMEMBER")
eweapon script SignWave //start
{
	void run(int size, int speed, bool unBlockable, int step)
	{
		this->Angle = DirRad(this->Dir);
		this->Angular = true;
		this->Step = step;
		
		int x = this->X;
		int y = this->Y;
		
		if (this->Parent)
			this->UseSprite(this->Parent->WeaponSprite);
		
		int dist;
		int timer;
		
		while(true)
		{
			timer += speed;
			timer %= 360;
			
			x += RadianCos(this->Angle) * this->Step * 0.01;
			y += RadianSin(this->Angle) * this->Step * 0.01;
			
			dist = Sin(timer)*size;
			
			this->X = x + VectorX(dist, RadtoDeg(this->Angle) - 90);
			this->Y = y + VectorY(dist, RadtoDeg(this->Angle) - 90);
			
			if(unBlockable)
				this->Dir = Link->Dir;
			
			Waitframe();
		}
	}
}
//end

//~~~~~~~~~PoisonDamage~~~~~~~~~~//
@Author("Deathrider365")
eweapon script PoisonDamage //start
{
	void run(int dps)
	{
		// The sprinting zombies will apply this
	}
}
//end

//~~~~~~~~~ArcingWeapon~~~~~~~~~~//
@Author("Moosh")
eweapon script ArcingWeapon //start
{
	void run(int initJump, int gravity, int effect)
	{
		int jump = initJump;
		int linkDistance = Distance(Hero->X, Hero->Y, this->X, this->Y);
		
		if (initJump == -1 && gravity == 0)
			jump = FindJumpLength(linkDistance / (this->Step / 100), true);
		
		if (gravity == 0)
			gravity = 0.16;

		while (jump > 0 || this->Z > 0)
		{
			this->Z += jump;
			this->Jump = 0;
			jump -= gravity;
			
			this->DeadState = WDS_ALIVE;
			
			CustomWaitframe(this, 1);
		}
		
		this->DrawYOffset = -1000;
		this->CollDetection = false;
		
		if(effect)
		{
			switch(effect)
			{
				case AE_SMALLPOISONPOOL: //start
					this->Step = 0;
					
					Audio->PlaySound(SFX_BOMB);
					
					for (int i = 0; i < 12; ++i)
					{
						int distance = 24 * i / 12;
						int angle = Rand(360);
						
						eweapon poisonTrail = FireEWeapon(EW_SCRIPT10, this->X + VectorX(distance, angle), this->Y + VectorY(distance, angle), 0, 0, this->Damage, SPR_POISON_CLOUD, SFX_SIZZLE, EWF_UNBLOCKABLE);

						SetEWeaponLifespan(poisonTrail, EWL_TIMER, 90);
						SetEWeaponDeathEffect(poisonTrail, EWD_VANISH, 0);
						
						CustomWaitframe(this, 4);
					}
					break;
					//end
					
				case AE_LARGEPOISONPOOL: //start
					this->Step = 0;
					
					Audio->PlaySound(SFX_BOMB);
					
					for (int i = 0; i < 18; ++i)
					{
						int distance = 40 * i / 18;
						int angle = Rand(360);
						
						eweapon poisonTrail = FireEWeapon(EW_SCRIPT10, this->X + VectorX(distance, angle), this->Y + VectorY(distance, angle), 0, 0, this->Damage, 
															SPR_POISON_CLOUD, SFX_SIZZLE, EWF_UNBLOCKABLE);

						SetEWeaponLifespan(poisonTrail, EWL_TIMER, 90);
						SetEWeaponDeathEffect(poisonTrail, EWD_VANISH, 0);
						
						CustomWaitframe(this, 4);
					}
					break;
					//end
					
				case AE_PROJECTILEWITHMOMENTUM: //start
					for (int i = 0; i < 12; ++i)
					{
						int distance = 24 * i / 12;
						int angle = Rand(360);
						
						eweapon poisonTrail = FireEWeapon(EW_SCRIPT10, this->X + VectorX(distance, angle), this->Y + VectorY(distance, angle), 0, 0, this->Damage, 
															SPR_POISON_CLOUD, SFX_SIZZLE, EWF_UNBLOCKABLE);

						SetEWeaponLifespan(poisonTrail, EWL_TIMER, 90);
						SetEWeaponDeathEffect(poisonTrail, EWD_VANISH, 0);
						
						CustomWaitframe(this, 4);
					}
					break;
					//end
				
				case AE_OIL_BLOB: //start
					// this->Step = 0;
					const int oilCombo = 6349;
					
					Audio->PlaySound(SFX_BOMB);
					
					int pos = ComboAt(this->X + 8, this->Y + 8);
					
					if (Screen->ComboT[pos] == CT_SCRIPT20)
						Screen->ComboD[pos] = oilCombo;
					
					break;
					//end
				
				case AE_ROCK_PROJECTILE:
					Audio->PlaySound(SFX_BOMB);
					break;
				
				case AE_BOULDER_PROJECTILE:
				
					for (int i = 0; i < 4; ++i)
					{
						eweapon rockProjectile = FireEWeapon(195, this->X + 8 + VectorX(8, -45 + 90 * i), this->Y + 8 + VectorY(8, -45 + 90 * i), DegtoRad(-45 + 90 * i), 150, 4, 118, -1, EWF_UNBLOCKABLE | EWF_ROTATE);
						RunEWeaponScript(rockProjectile, Game->GetEWeaponScript("ArcingWeapon"), {1, 0, AE_ROCK_PROJECTILE});	
					}
				
					Audio->PlaySound(SFX_BOMB);
					break;
					
				case AE_RACCOON_PROJECTILE:
					npc n = CreateNPCAt(236, this->X, this->Y);
					
				case AE_DEBUG: //start
					this->Step = 0;
					
					for(int i = 0; i < 90; ++i)
					{
						Screen->DrawInteger(6, this->X, this->Y, FONT_Z1, C_WHITE, C_BLACK, -1, -1, i, 0, 128);
						this->DeadState = WDS_ALIVE;
						CustomWaitframe(this, 1);
					}
					break;
					//end
			}
		}
		
		this->DeadState = WDS_DEAD;
	}
	
	void CustomWaitframe(eweapon this, int frames) //start
	{
		for (int i = 0; i < frames; ++i)
		{
			this->DeadState = WDS_ALIVE;
			Waitframe();
		}
	} //end
}
//end

lweapon script timedEffect //start
{
    void run(int timer)
    {
        while(timer--) Waitframe();
        this->Remove();
    }
} //end

lweapon spawnTimedSprite(int x, int y, int sprite, int tileWidth, int tileHeight, int frames) //start
{
    lweapon weapon = CreateLWeaponAt(LW_SCRIPT1, x, y);
    weapon->UseSprite(sprite);
    weapon->TileWidth = tileWidth ? tileWidth : 1;
    weapon->TileHeight = tileHeight ? tileHeight : 1;
    weapon->Script = Game->GetLWeaponScript("timedEffect");
	weapon->CollDetection = false;
    weapon->InitD[0] = frames;
    
	return weapon;
} //end

eweapon script Stopper //start
{
    void run(int timer)
    {
        do Waitframe(); while (--timer);
        this->Step = 0;
    }
} //end

eweapon script StopperKiller //start
{
    void run(int stoptime, int killtime)
    {
        while(true)
        {
            unless(stoptime--)
                this->Step = 0;
            unless(killtime--)
                this->Remove();
            Waitframe();
        }
    }
} //end
















