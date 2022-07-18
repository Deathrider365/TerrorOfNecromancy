///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Enemies~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

//~~~~~Mimic~~~~~//
// D0: Speed Multiplier
// D1: Fire cooldown (frames)
// D2: Knockback rate in pixels per frame 
@Author("EmilyV99")
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
			mDir = Emily::addX(mDir, (xStep ? (xStep < 0 ? DIR_LEFT : DIR_RIGHT) : -1));
			
			
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

//~~~~~Candlehead~~~~~//
namespace Enemy::Candlehead //start
{
	@Author("Deathrider365")
	npc script Candlehead //start
	{
		const int NORMAL_RAND = 5;
		const int AGGRESSIVE_RAND = 50;
		const int NORMAL_MOVE_DURATION = 30;
		const int AGGRESSIVE_MOVE_DURATION = 60;
		const int NORMAL_HOMING = 10;
		const int AGGRESSIVE_HOMING = 20;
		
		void run()
		{
			int knockbackDist = 4;
			
			if (knockbackDist < 0)
				this->NoSlide = true;
			else
				this->SlideSpeed = knockbackDist;	// 4 is default
			
			//start Behaviour loop
			while(true)
			{
				this->Slide();
				
				//TODO Add EW_FIRE to this function to support the fires dropped by the candles to also have the ability to light other candles
				
				if (hitByFire(this))
					deathAnimation(this);
					
				unless (gameframe % RandGen->Rand(45, 60))
				{
					for (int i = 0; i < (linkClose(this, 24) ? AGGRESSIVE_MOVE_DURATION : NORMAL_MOVE_DURATION); ++i)
					{
						this->Slide();
						
						if (hitByFire(this))
							deathAnimation(this);
							
						doWalk(this, linkClose(this, 24) ? AGGRESSIVE_RAND : NORMAL_RAND, linkClose(this, 24) ? AGGRESSIVE_HOMING : NORMAL_HOMING, this->Step);
						Waitframe();
					}
				}
				Waitframe();
			} //end
		}
		
		void deathAnimation(npc n) //start
		{
			n->Dir = getInvertedDir(n->Dir);
			n->Step += n->Step / 2;
			int cset;
			
			if(Hero->Item[10])
				cset = 7;
			else if (Hero->Item[158])
				cset = 8;
			
			
			//TODO when making the miniboss variant of these guys set this bound to a timer 
			until (n->HP <= 0)
			{
				if (n->HP < 10)
					n->HP = 0;
				else
					n->HP -= 1; 
				
				n->Slide();
				
				//start Dropping flames while dying
				if (gameframe % 16 == 0)
				{
					spritedata sprite = Game->LoadSpriteData(115);
					setFlameSpriteCSet(sprite);
				
					eweapon flame = CreateEWeaponAt(EW_SCRIPT1, n->X, n->Y);	
					flame->Dir = n->Dir;
					flame->Step = n->Step;
					flame->Angular = true;
					flame->Script = Game->GetEWeaponScript("StopperKiller");
					flame->Z = n->Z;
					flame->InitD[1] = 120;
					flame->Gravity = true;
					flame->Damage = 2;
					flame->UseSprite(115);
				} //end
				
				Screen->FastCombo(7, n->X, n->Y, 6344, cset, OP_OPAQUE);
				
				doWalk(n, linkClose(n, 24) ? AGGRESSIVE_RAND : NORMAL_RAND, linkClose(n, 24) ? AGGRESSIVE_HOMING : NORMAL_HOMING, n->Step);
				
				Waitframe();
			}
			
			//start Death Explosion
			for (int i = 0; i < 8; ++i)
			{
				spritedata sprite = Game->LoadSpriteData(115);
				setFlameSpriteCSet(sprite);
				
				
				//TODO increase the range of the fire explosion
				eweapon flame = CreateEWeaponAt(EW_SCRIPT1, n->X, n->Y);
				flame->Dir = i;
				flame->Step = 120;
				flame->Angular = true;
				flame->Angle = DirRad(flame->Dir);
				flame->Script = Game->GetEWeaponScript("StopperKiller");
				flame->Z = n->Z;
				flame->InitD[0] = 20;
				flame->InitD[1] = 150;
				flame->Gravity = true;
				flame->Damage = 2;
				flame->UseSprite(115);
			} //end
			
			Audio->PlaySound(10);
			n->Remove();
		} //end
		
		void setFlameSpriteCSet(spritedata sprite) //start
		{
			if(Hero->Item[10])
				sprite->CSet = 7;
			else if (Hero->Item[158])
				sprite->CSet = 8;
		} //end
		
		bool hitByFire(npc n) //start
		{
			if (n->HitBy[2] || n->HitBy[1])
			{
				lweapon lWeapon = Screen->LoadLWeapon(n->HitBy[2]);
				lweapon eWeapon = Screen->LoadLWeapon(n->HitBy[1]);
				
				if (lWeapon->Type == LW_FIRE || lWeapon->Type == LW_FIRESPARKLE || eWeapon->Type == EW_FIRE)
					return true;
				else
					return false;
			}
		} //end
	
	} //end
} //end
