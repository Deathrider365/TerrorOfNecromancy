///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Enemies~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

//~~~~~Mimic~~~~~//
// D0: Speed Multiplier
// D1: Fire cooldown (frames)
// D2: Knockback rate in pixels per frame 
@Author("Venrob")
npc script Mimic //start
{
	void run(int speedMult, int fireRate, int knockbackDist)
	{
		unless (speedMult)
			speedMult = 1;
			
		unless (fireRate)
			fireRate = 30;
			
		unless (knockbackDist)
			knockbackDist = 4;
			
		int fireClock;
		
		if (knockbackDist < 0)
			this->NoSlide = true;
		else
			this->SlideSpeed = knockbackDist;	// 4 is default
			
			
		eweapon e;
		
		while (true)
		{
			while (this->Stun)
			{
				this->Slide();
				Waitframe();
			}
			
			this->Slide();
				
			int xStep = -LinkMovement[LM_STICKX] * Hero->Step / 100 * speedMult;			
			int yStep = -LinkMovement[LM_STICKY] * Hero->Step / 100 * speedMult;
			
			this->Dir = OppositeDir(Hero->Dir);
			int step = Max(Abs(xStep), Abs(yStep));
			
			int mDir = (yStep ? (yStep < 0 ? DIR_UP : DIR_DOWN) : -1);
			mDir = Venrob::addX(mDir, (xStep ? (xStep < 0 ? DIR_LEFT : DIR_RIGHT) : -1));
			
			
			unless (fireClock)
			{
				if (this->Dir == this->LinedUp(12, false))
				{
					this->Attack();
					fireClock = fireRate;
				}
			}
			else
				--fireClock;
			
			if (mDir != -1)
			{
				while(true)
				{					
					if (this->CanMove({mDir, step, 0}))
					{
						this->X += xStep;
						this->Y += yStep;
						break;
					}
					
					if (--step <= 0)
						break;
					
					if (xStep)
						xStep > 0 ? --xStep : ++xStep;
					if (yStep)
						yStep > 0 ? --yStep : ++yStep;
				}
			}
			
			Waitframe();
		}	
	}
} //end

//~~~~~Bomber~~~~~//
@Author("Deathrider365")
ffc script Bomber //start
{
	void run()
	{
		while (true)
		{
			
		}	
	}
} //end

//~~~~~Beamos~~~~~//
@Author("Deathrider365")
ffc script Beamos //start
{
	void run()
	{
		while (true)
		{
			
		}	
	}
} //end

//~~~~~LoSTurret~~~~~//
@Author("Deathrider365")
ffc script LoSTurret //start
{
	void run()
	{
		while (true)
		{
			
		}	
	}
} //end
