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
		
		switch(effect)
		{
			case AE_SMALLPOISONPOOL: //start
				this->Step = 0;
				
				Audio->PlaySound(SFX_BOMB);
				
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
