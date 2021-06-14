///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~~~~~~The Terror of Necromancy Bosses~~~~~~~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

// IN SEQUENTIAL ORDER

//~~~~~Leviathan1~~~~~//
@Author("Moosh, modified by Deathrider365")
npc script Leviathan1 //start
{	
	using namespace Leviathan1Namespace;
	
	const int VARS_HEADNPC = 0;
	const int VARS_HEADCX = 1;
	const int VARS_HEADCY = 2;
	const int VARS_FLIP = 3;
	const int VARS_BODYHP = 8;
	const int VARS_FLASHTIMER = 5;
	const int VARS_INITHP = 6;
	
	int hitByWaterfall = 0;
	int hitByWaterCannon = 0;
	int hitByBurstCannon = 0;
	int hitBySideSwipe = 0;
	
	void run(int fight) //start
	{		
	//start Setup
		Hero->Dir = DIR_UP;
		if (waterfall_bmp && waterfall_bmp->isAllocated())
			waterfall_bmp->Free();
			
		waterfall_bmp = Game->CreateBitmap(32, 176);
		
		int i; int j; int k;
		int x; int y;
		int x2; int y2;
		int angle, dist;
		
		eweapon e;
		
		untyped vars[16];
		npc head = CreateNPCAt(NPC_LEVIATHANHEAD, this->X, this->Y);

		vars[VARS_HEADNPC] = head;
		vars[VARS_BODYHP] = this->HP;
		vars[VARS_INITHP] = this->HP;
		
		this->HitXOffset = 64;
		this->HitYOffset = 32;
		
		this->HitWidth = 48;
		this->HitHeight = 48;
		
		this->X = 52;
		this->Y = 112;
		
		int attack;	
		
		Audio->PlayEnhancedMusic(NULL, 0);
		
		//
		//    The leviathan is rising and screen is quaking
		//
		for(i = 0; i < 180; ++i) //start
		{
			Hero->Dir = DIR_UP;
			NoAction();
			GlideFrame(this, vars, 52, 112, 52, 32, 180, i);
			
			if(i % 40 == 0)
			{
				Audio->PlaySound(SFX_ROCKINGSHIP);
				Screen->Quake = 20;
			}

			Waitframe(this, vars);
		} //end
		
		//
		//    The leviathan pauses, roars, then pauses
		//			
		for(i = 0; i < 120; ++i) //start
		{
			NoAction();
			if (i == 60)
			{
			   Audio->PlaySound(SFX_ROAR);
			   Audio->PlayEnhancedMusic("DS3 - Old Demon King.ogg", 0);
			   if (firstRun)
			   {
					Screen->Message(16);
					firstRun = false;
			   }
			}
			 
			Waitframe(this, vars);
		} //end
		
		//
		//    The leviathan dives
		//
		for(i = 0; i < 20; ++i) //start
		{
			GlideFrame(this, vars, 52, 32, 52, 112, 20, i);
			Waitframe(this, vars);
		} //end
		
		//
		//    The splash SFX he makes when diving
		//
		Audio->PlaySound(SFX_SPLASH);
		Splash(this->X + 64, 100);
		
		//end setup
				
		//
		//    Leviathan's behavior loop
		//

		while(true)
		{
			attack = attackChoice(this, vars);
			
			int riseAnim = 120;
			if(this->HP < vars[VARS_INITHP] * 0.45)
			{
				riseAnim = 60;		
				LEVIATHAN1_WATERCANNON_DMG = 70;
				LEVIATHAN1_BURSTCANNON_DMG = 40;
				LEVIATHAN1_WATERFALL_DMG = 60;
			}
			if(this->HP < vars[VARS_INITHP] * 0.25)
			{
				riseAnim = 30;		
				LEVIATHAN1_WATERCANNON_DMG = 80;
				LEVIATHAN1_BURSTCANNON_DMG = 50;
				LEVIATHAN1_WATERFALL_DMG = 70;
			}
				
			switch(attack) 
			{
				// Waterfall Attack
				case 0: //start
					x = Link->X-64;
					x2 = x + Choose(-8, 8);
				
					Glide(this, vars, x, 112, x2, 32, riseAnim);
					Waitframe(this, vars, 40);
					
					for(i = 0; i < 20; ++i)
					{
						GlideFrame(this, vars, x2, 32, x2, 112, 20, i);
						Audio->PlaySound(SFX_WATERFALL);
						if(i == 3)
						{								
							if(this->HP < vars[VARS_INITHP]*0.45)
							{
								int cx1 = this->X + this->HitXOffset + (this->HitWidth / 2) - 24;
								eweapon waterfall = CreateEWeaponAt(EW_SCRIPT10, cx1 - 8, 112);
								waterfall->Damage = LEVIATHAN1_WATERFALL_DMG;
								waterfall->Script = Game->GetEWeaponScript("Waterfall");
								waterfall->DrawYOffset = -1000;
								waterfall->InitD[0] = 3;
								waterfall->InitD[1] = 64;
								
								int cx2 = this->X + this->HitXOffset + (this->HitWidth / 2) + 24;
								eweapon waterfall2 = CreateEWeaponAt(EW_SCRIPT10, cx2 - 8, 112);
								waterfall2->Damage = LEVIATHAN1_WATERFALL_DMG;
								waterfall2->Script = Game->GetEWeaponScript("Waterfall");
								waterfall2->DrawYOffset = -1000;
								waterfall2->InitD[0] = 3;
								waterfall2->InitD[1] = 64;
							}
							else
							{
								int cx = this->X + this->HitXOffset + (this->HitWidth / 2);
								eweapon waterfall = CreateEWeaponAt(EW_SCRIPT10, cx - 8, 112);
								waterfall->Damage = LEVIATHAN1_WATERFALL_DMG;
								waterfall->Script = Game->GetEWeaponScript("Waterfall");
								waterfall->DrawYOffset = -1000;
								waterfall->InitD[0] = 3;
								waterfall->InitD[1] = 64;
							
							}

						}
						
						Waitframe(this, vars);
					}			
					
					Audio->PlaySound(SFX_SPLASH);
					break; //end
				
				// Water Cannon
				case 1: //start
					x = Rand(-32, 144);
					x2 = x + Choose(-8, 8);
					
					if(x < 56)
						vars[VARS_FLIP] = 0;
					else
						vars[VARS_FLIP] = 1;
				
					// Rise out of water
					Glide(this, vars, x, 112, x2, 32, riseAnim);
					
					x = vars[VARS_HEADCX];
					y = vars[VARS_HEADCY];
					Audio->PlaySound(SFX_CHARGE);
					
					// Charge animation
					Charge(this, vars, x, y, 60, 24);
					
					angle = Angle(x, y, Link->X + 8, Link->Y + 8);
					
					int wSizes[4] = {-24, 24, -12, 12};
					int wSpeeds[4] = {16, 16, 12, 12};
					
					// Shooting loop
					for(i = 0; i < 32; ++i)
					{
						if(this->HP < vars[VARS_INITHP]*0.45)
							angle = TurnToAngle(angle, Angle(x, y, Link->X + 8, Link->Y + 8), 1.75);
						if(this->HP < vars[VARS_INITHP]*0.25)
							angle = TurnToAngle(angle, Angle(x, y, Link->X + 8, Link->Y + 8), 2.25);
						
						Audio->PlaySound(SFX_SHOT);
						
						for(j = 0; j < 4; ++j)
						{
							e = CreateEWeaponAt(EW_SCRIPT1, x - 8, y - 8);
							e->Damage = LEVIATHAN1_WATERCANNON_DMG;
							e->UseSprite(SPR_WATERBALL);
							e->Angular = true;
							e->Angle = DegtoRad(angle);
							e->Dir = AngleDir4(angle);
							e->Step = 300;
							e->Script = Game->GetEWeaponScript("LeviathanSignWave");
							e->InitD[0] = wSizes[j] * (0.5 + 0.5 * (i / 32));
							e->InitD[1] = wSpeeds[j];
							e->InitD[2] = true;
						}
						
						Waitframe(this, vars, 4);
					}
					
					// Splashing animation
					Glide(this, vars, x2, 32, x2, 112, 20);
					Audio->PlaySound(SFX_SPLASH);
					Splash(this->X + 64, 100);
					
					break; //end
				
				// Water Cannon (Burst)
				case 2: //start
					x = Rand(-32, 144);
					x2 = x + Choose(-8, 8);
					
					if(x < 56)
						vars[VARS_FLIP] = 0;
					else
						vars[VARS_FLIP] = 1;
				
					// Rise out of water
					Glide(this, vars, x, 112, x2, 32, riseAnim);
					
					x = vars[VARS_HEADCX];
					y = vars[VARS_HEADCY];
					Audio->PlaySound(SFX_CHARGE);
					
					int wSizes[2] = {-32, 32};
					int wSpeeds[2] = {6, 6};
					
					int numBursts = 3;
					int burstDelay = 40;
					
					if(this->HP < vars[VARS_INITHP]*0.45)
					{
						numBursts = 5;
						burstDelay = 24;
					}
					
					if(this->HP < vars[VARS_INITHP]*0.25)
					{
						numBursts = 7;
						burstDelay = 12;
					}
					
					
						
					// Shooting loop
					for(i = 0; i < numBursts; ++i)
					{
						// Charge animation
						Charge(this, vars, x, y, 20, 16);
						
						angle = Angle(x, y, Link->X + 8, Link->Y + 8) + Rand(-20, 20);
						
						for(j = 0; j < 3; ++j)
						{
							Audio->PlaySound(SFX_SHOT);
							
							for(k = 0; k < 2; ++k)
							{
								e = CreateEWeaponAt(EW_SCRIPT1, x - 8, y - 8);
								e->Damage = LEVIATHAN1_BURSTCANNON_DMG; //this->WeaponDamage;
								e->UseSprite(SPR_WATERBALL);
								e->Angular = true;
								e->Angle = DegtoRad(angle);
								e->Dir = AngleDir4(angle);
								e->Step = 200;
								e->Script = Game->GetEWeaponScript("LeviathanSignWave");
								e->InitD[0] = wSizes[k]-Rand(-4, 4);
								e->InitD[1] = wSpeeds[k];
								e->InitD[2] = true;
							}
							Waitframe(this, vars, 4);
						}
						
						Waitframe(this, vars, 16);
						
						for(j = 0; j < 2; ++j)
						{
							e = CreateEWeaponAt(EW_SCRIPT1, x - 8, y - 8);
							e->Damage = LEVIATHAN1_BURSTCANNON_DMG; //this->WeaponDamage;
							e->UseSprite(SPR_WATERBALL);
							e->Angular = true;
							e->Angle = DegtoRad(angle);
							e->Dir = AngleDir4(angle);
							e->Step = 150;
							e->Script = Game->GetEWeaponScript("LeviathanSignWave");
							e->InitD[0] = 4;
							e->InitD[1] = 16;
							e->InitD[2] = true;
							Waitframe(this, vars, 4);
						}
						
						Waitframe(this, vars, burstDelay);
					}
					
					// Splashing animation
					Glide(this, vars, x2, 32, x2, 112, 20);
					Audio->PlaySound(SFX_SPLASH);
					Splash(this->X + 64, 100);
					
					break; //end
				
				// Side Swipe
				case 3: //start
					int side = Choose(-1, 1);
					
					x = side == -1 ? -32 : 144;
					x2 = x + 32*side;
					
					if(x < 56)
						vars[VARS_FLIP] = 0;
					else
						vars[VARS_FLIP] = 1;
				
					// Rise out of water
					Glide(this, vars, x, 112, x2, 32, riseAnim);
					
					for(i = 0; i < 64; ++i)
					{
						this->X += side * 0.25;
						this->Y -= 0.125;
						Waitframe(this, vars);
					}
					
					j = 8;
					k = 8;
					for(i=0; i<64; ++i)
					{
						this->X -= side*4;
						this->Y += 0.5;
						
						eweapon waterfall = CreateEWeaponAt(EW_SCRIPT10, this->X + 80, 112);
						waterfall->Damage = LEVIATHAN1_WATERFALL_DMG + 20;
						waterfall->Script = Game->GetEWeaponScript("Waterfall");
						waterfall->DrawYOffset = -1000;
						waterfall->InitD[0] = 1;
						waterfall->InitD[1] = 64-i*0.5;
						
						Waitframe(this, vars);
					}
					
					// Splashing animation
					Glide(this, vars, this->X, this->Y, this->X, 112, 20);
					Audio->PlaySound(SFX_SPLASH);
					Splash(this->X + 64, 100);
					
					break; //end
			}
			
			Waitframe(this, vars);
		}
	} //end
	
	int attackChoice(npc this, untyped vars) //start
	{		
		if (this->HP < vars[VARS_INITHP] * 0.25)
		{					
			if (Link->Y < 144)
			{
				if (Rand(2) == 0)
					return 0; 
			}
			if(Link->X < 48 || Link->X > 192)
			{
				if(Rand(2) == 0)
					return 1;
				if(Rand(2) == 0)
					return 3;
				if(Rand(2) == 0)
					return 2;
			}
			//Don't do Waterfall if not near the top of the arena
			if(Link->Y >= 144)
			{
				if(Rand(2)==0)
					return 2;
				if(Rand(2)==0)
					return 1;
			}
			
			return Choose(0, 1, 3);
		}
		
		else if(this->HP < vars[VARS_INITHP] * 0.45)
		{
			//Do stream at left and right sides
			
			if (Link->Y < 144)
			{
				if (Rand(3) == 0)
					return 0; 
				if (Rand(3) == 1)
					return 1;
			}
			if(Link->X < 48 || Link->X > 192)
			{
				if(Rand(4) == 0)
					return 1;
				if (Rand(4) == 1)
					return 3;
			}
			//Don't do Waterfall if not near the top of the arena
			if(Link->Y >= 144)
			{
				if(Rand(2)==0)
					return Choose(1, 2);
			}
			return Choose(0, 1, 2, 3);
		}
		else
		{
			//Do stream at left and right sides
			if (Link->Y < 144)
			{
				if (Rand(3) == 0)
					return 0;
				if (Rand(2) == 1)
					return 1;
			}
			if(Link->X < 48 || Link->X > 192)
			{
				if(Rand(2) == 0)
					return 1;
			}
			if(Link->Y >= 144)
			{
				if(Rand(2) == 0)
					return 1;
				if(Rand(2) == 0)
					return 2;
			}
			return Choose(0, 1, 2);
		}
	} //end
	
	void Glide(npc this, untyped vars, int x1, int y1, int x2, int y2, int numFrames) //start
	{
		int angle = Angle(x1, y1, x2, y2);
		int dist = Distance(x1, y1, x2, y2);
		
		for(int i = 0; i < numFrames; ++i)
		{
			int x = x1 + VectorX(dist * (i / numFrames), angle);
			int y = y1 + VectorY(dist * (i / numFrames), angle);
			this->X = x;
			this->Y = y;
			Waitframe(this, vars);
		}
	} //end
	
	void GlideFrame(npc this, untyped vars, int x1, int y1, int x2, int y2, int numFrames, int i) //start
	{
		int angle = Angle(x1, y1, x2, y2);
		int dist = Distance(x1, y1, x2, y2);
		int x = x1 + VectorX(dist * (i / numFrames), angle);
		int y = y1 + VectorY(dist * (i / numFrames), angle);
		this->X = x;
		this->Y = y;
	} //end
	
	void Charge(npc this, untyped vars, int x, int y, int chargeFrames, int chargeMaxSize) //start
	{
		Audio->PlaySound(SFX_CHARGE);
					
		// Charge animation
		for(int i = 0; i < chargeFrames; ++i)
		{
			Screen->Circle(4, x + Rand(-2, 2), y + Rand(-2, 2), (i / chargeFrames) * chargeMaxSize, Choose(C_CHARGE1, C_CHARGE2, C_CHARGE3), 1, 0, 0, 0, true, OP_OPAQUE);
			Waitframe(this, vars);
		}
	} //end
	
	void Splash(int x, int y) //start
	{
		lweapon l;
		
		for(int i = 0; i < 5; ++i)
		{
			for(int j=1; j<=2; ++j)
			{
				l = CreateLWeaponAt(LW_SPARKLE, x - 4 - 4 * i, y);
				l->UseSprite(SPR_SPLASH);
				l->ASpeed += Rand(3);
				l->Step = Rand(100, 200)*j*0.5;
				l->Angular = true;
				l->Angle = DegtoRad( - 90 - 5 - 15 * i + Rand(-5, 5));
				l->CollDetection = false;
				
				l = CreateLWeaponAt(LW_SPARKLE, x + 4 + 4 * i, y);
				l->UseSprite(SPR_SPLASH);
				l->ASpeed += Rand(3);
				l->Step = Rand(100, 200)*j*0.5;
				l->Angular = true;
				l->Angle = DegtoRad( - 90 + 5 + 15 * i + Rand(-5, 5));
				l->CollDetection = false;
				l->Flip = 1;
			}
		}
	} //end
	
	void Waitframe(npc this, untyped vars, int frames) //start
	{
		for(int i = 0; i < frames; ++i)
			Waitframe(this, vars);
	} //end
	
	void UpdateWaterfallBitmap() //start
	{
		int cmb;
		waterfall_bmp->Clear(0);
		int ptr[5 * 22];
		for(int i = 0; i < 11; ++i)
		{
			cmb = CMB_WATERFALL;
			if(i == 0)
				cmb = CMB_WATERFALL + 1;
			waterfall_bmp->FastCombo(0, 0, 16 * i, cmb, CS_WATERFALL, 128);
			
			cmb = CMB_WATERFALL + 2;
			if(i == 10)
				cmb = CMB_WATERFALL + 3;
			waterfall_bmp->FastCombo(0, 16, 16 * i, cmb, CS_WATERFALL, 128);
		}
	} //end
	
	void Waitframe(npc this, untyped vars) //start
	{
		this->DrawYOffset = -1000;
		this->Stun = 10;
		this->Immortal = true;
		
		if(vars[VARS_FLIP])
			this->HitXOffset = 32;
		else
			this->HitXOffset = 64;
	
		if(this->Y+this->HitYOffset+this->HitHeight-1 <= 112 && vars[VARS_FLASHTIMER] == 0)
			this->CollDetection = true;
		else
			this->CollDetection = false;
		
		npc head = <npc>vars[VARS_HEADNPC];
		
		if(head->isValid())
		{
			if(head->Y + head->HitYOffset+head->HitHeight - 1 <= 112 && vars[VARS_FLASHTIMER] == 0)
				head->CollDetection = true;
			else
				head->CollDetection = false;
				
			head->DrawYOffset = -1000;
			head->Stun = 10;
			
			if(vars[VARS_FLIP])
				vars[VARS_HEADCX] = this->X + 16 + 12;
			else
				vars[VARS_HEADCX] = this->X + 104 + 12;
			
			vars[VARS_HEADCY] = this->Y + 48 + 8;
			head->X = vars[VARS_HEADCX] - 12;
			head->Y = vars[VARS_HEADCY] - 8;
			head->HitWidth = 24;
			head->HitHeight = 16;
			
			if(head->HP < 1000)
			{
				this->HP -= 1000 - head->HP;
				head->HP = 1000;
			}
		}
		
		if(vars[VARS_BODYHP] != this->HP)
		{
			if(vars[VARS_BODYHP]>this->HP)
				vars[VARS_FLASHTIMER] = 32;
			
			vars[VARS_BODYHP] = this->HP;
		}
		
		if(this->HP<=0)
			DeathAnim(this, vars);
		WaitframeLite(this, vars);
	} //end
	
	void WaitframeLite(npc this, untyped vars) //start
	{
		int cset = this->CSet;
		if(vars[VARS_FLASHTIMER])
			cset = 9-(vars[VARS_FLASHTIMER]>>1);
		
		if(vars[VARS_FLASHTIMER])
			--vars[VARS_FLASHTIMER];
		
		Screen->DrawTile(0, this->X, this->Y, this->OriginalTile, 9, 6, cset, -1, -1, 0, 0, 0, vars[VARS_FLIP], 1, 128);
		
		UpdateWaterfallBitmap();
		Waitframe();
	} //end
			
	void DeathAnim(npc this, untyped vars) //start
	{		
		npc head = vars[VARS_HEADNPC];
		Remove(head);
		this->CollDetection = false;
		
		int i;
		int x = this->X;
		
		Waitframe();
		
		Screen->Message(MSG_BEATEN);
		vars[VARS_FLASHTIMER] = 0;
		WaitframeLite(this, vars);
		
		Audio->PlaySound(120);
					
		while(this->Y < 112)
		{
			this->Y += 0.5;
			++i;
			i %= 360;
			this->X = x + 12 * Sin(i * 8);
			Audio->PlaySound(SFX_RISE);
			Screen->Quake = 20;
			WaitframeLite(this, vars);
		}
		
		Waitframe();
		
		item theItem = CreateItemAt(183, Link->X, Link->Y);
		theItem->Pickup = IP_HOLDUP;
		Screen->Message(MSG_LEVIATHAN_SCALE);
		
		Waitframe();

		Hero->WarpEx({WT_IWARPOPENWIPE, 2, 11, -1, WARP_A, WARPEFFECT_OPENWIPE, 0, 0, DIR_LEFT});
			
		this->Immortal = false;
		this->Remove();

	}//end
} //end

//~~~~~LegionnaireLevel1~~~~~//
@Author("Moosh")
ffc script LegionnaireLevel1 //start
{
	void run(int enemyid)
	{	//start Set Up
	
		if (Screen->State[ST_SECRET])
			Quit();
	
		npc ghost = Ghost_InitAutoGhost(this, enemyid);			// pairing enemy with ffc
		Ghost_SetFlag(GHF_4WAY);								// 4 way movement
		int combo = ghost->Attributes[10];						// finds enemy first combo
		int attackCoolDown = 90 + Rand(30);
		int attack;
		int startHP = Ghost_HP;
		int movementDirection = Choose(90, -90);
		
		int timeToSpawnAnother, enemyCount;
		
		CONFIG SPR_LEGIONNAIRESWORD = 110;
		CONFIG SFX_SHOOTSWORD = 127;
		CONFIG TIL_IMPACTMID = 955;
		CONFIG TIL_IMPACTBIG = 952;
		//end
		
		//start Appear in
		int numEnemies = Screen->NumNPCs();
		
		if (numEnemies == 1)
		{
			Ghost_Y = -32;
			Ghost_X = 120;
			
			for (int i = 0; i < 32; ++i)
			{
				NoAction();
				Ghost_Waitframe(this, ghost);
			}
			
			Ghost_Y = 80;
			Ghost_Z = 176;
			Ghost_Dir = DIR_DOWN;
			
			while (Ghost_Z)
			{
				NoAction();
				Ghost_Z -= 4;
				Ghost_Waitframe(this, ghost);
			}
			
			Screen->Quake = 10;
			Audio->PlaySound(3);
			
			for (int i = 0; i < 32; ++i)
			{
				NoAction();
				Ghost_Waitframe(this, ghost);
			}
		}
		//end Appear in
		
		while(true) //start Activity Cycle
		{
			Ghost_Data = combo + 4;
			Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Hero->X, Hero->Y));
			
			int moveAngle = Angle(Ghost_X, Ghost_Y, Hero->X, Hero->Y) + movementDirection;
			
			Ghost_MoveAtAngle(moveAngle, ghost->Step / 100, 0);
			
			if (timeToSpawnAnother >= 600 && enemyCount < 2) //start Spawning more
			{
				enemyShake(this, ghost, 32, 1);
				Audio->PlaySound(132); // was 64 (general spawn sfx)
				npc n1 = Screen->CreateNPC(220);
				
				int pos, x, y;
			
				for (int i = 0; i < 352; ++i)
				{
					if (i < 176)
						pos = Rand(176);
					else
						pos = i - 176;
						
					x = ComboX(pos);
					y = ComboY(pos);
					
					if (Distance(Hero->X, Hero->Y, x, y) > 48)
						if (Ghost_CanPlace(x, y, 16, 16))
							break;
				}
				
				n1->X = x;
				n1->Y = y;

				++enemyCount;
				timeToSpawnAnother = 0;
			} //end
			
			if (attackCoolDown)
				--attackCoolDown;
			else
			{				
				attackCoolDown = 90 + Rand(30);
				attack = Rand(3);
				
				switch(attack)
				{
					case 0: //start Fire Swordz
						Ghost_Data = combo;
						int swordDamage = 3;
						
						enemyShake(this, ghost, 16, 1);
				
						for (int i = 0; i < 5; ++i)
						{
							eweapon projectile = FireAimedEWeapon(EW_BEAM, Ghost_X, Ghost_Y, 0, 300, swordDamage, SPR_LEGIONNAIRESWORD, SFX_SHOOTSWORD, EWF_UNBLOCKABLE);
							Ghost_Waitframes(this, ghost, 16);
						}
						
						Ghost_Waitframes(this, ghost, 16);
						
						movementDirection = Choose(90, -90);
						
						break; //end
						
					case 1: //start Jump Essplode
						Ghost_Data = combo + 8;
						int distance = Distance(Ghost_X, Ghost_Y, Hero->X, Hero->Y);
						int jumpAngle = Angle(Ghost_X, Ghost_Y, Hero->X, Hero->Y);
						
						int explosionDamage = 4;
						
						Ghost_Jump = FindJumpLength(distance / 2, true);
						
						Audio->PlaySound(SFX_JUMP);
						
						while (Ghost_Jump || Ghost_Z)
						{
							Ghost_MoveAtAngle(jumpAngle, 2, 0);
							Ghost_Waitframe(this, ghost);
						}
						
						Ghost_Data = combo;
						Audio->PlaySound(3);	
						
						for (int i = 0; i < 24; ++i)
						{
							MakeHitbox(Ghost_X - 12, Ghost_Y - 12, 40, 40, explosionDamage);
							
							if (i > 7 && i <= 15)
								Screen->DrawTile(2, Ghost_X - 16, Ghost_Y - 16, TIL_IMPACTBIG, 3, 3, 8, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
							else	
								Screen->DrawTile(2, Ghost_X - 16, Ghost_Y - 16, TIL_IMPACTMID, 3, 3, 8, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
								
							Ghost_Waitframe(this, ghost);
						}
						
						movementDirection = Choose(90, -90);
						
						break; //end
						
					case 2: //start Sprint slash
						enemyShake(this, ghost, 32, 2);
						Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Hero->X, Hero->Y));
						
						int slashDamage = 3;
						
						int moveAngle = Angle(Ghost_X, Ghost_Y, Hero->X, Hero->Y);
						int distance = Distance(Ghost_X, Ghost_Y, Hero->X, Hero->Y);
						
						int dashFrames = Max(6, (distance - 36) / 3);
						
						for (int i = 0; i < dashFrames; ++i)
						{
							Ghost_MoveAtAngle(moveAngle, 3, 0);
							
							if (i > dashFrames / 2)
								sword1x1(Ghost_X, Ghost_Y, moveAngle - 90, (i - dashFrames / 2) / (dashFrames / 2) * 16, combo + 12, 10, slashDamage);
								
							Ghost_Waitframe(this, ghost);
						}
						
						Audio->PlaySound(SFX_SWORD);
						
						for (int i = 0; i <= 12; ++i)
						{
							Ghost_MoveAtAngle(moveAngle, 3, 0);
							sword1x1(Ghost_X, Ghost_Y, moveAngle - 90 + 15 * i, 16, combo + 12, 10, slashDamage);
							Ghost_Waitframe(this, ghost);
						}
						
						movementDirection = Choose(90, -90);
						
						break; //end
					
				}
			}
			
			if (Ghost_HP <= startHP * 0.40)
				timeToSpawnAnother++;
			
			Ghost_Waitframe(this, ghost);
		} //end
	}
} //end

//~~~~~Shambles~~~~~//
@Author("Moosh")
ffc script Shambles //start
{
	using namespace ShamblesNamespace;
	
	void run(int enemyid)
	{
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		int combo = ghost->Attributes[10];
		int attackCoolDown = 90;
		int attack;
		int startHP = Ghost_HP;
		int bombsToLob = 3;
		int difficultyMultiplier = 0.33;
		
		Audio->PlayEnhancedMusic(NULL, 0);
		
		//start spawning animation
		Ghost_X = 128;				// sets him off screen as a time buffer
		Ghost_Y = -32;
		Ghost_Dir = DIR_DOWN;

		Hero->Stun = 270;
		
		Screen->Quake = 90;
		ShamblesWaitframe(this, ghost, 90, SFX_ROCKINGSHIP);
		
		Ghost_X = 120;
		Ghost_Y = 80;
		Ghost_Data = combo + 4;
		
		Screen->Quake = 60;
		ShamblesWaitframe(this, ghost, 60, SFX_ROCKINGSHIP);
		
		Ghost_Data = combo + 5;
		
		Screen->Quake = 60;
		ShamblesWaitframe(this, ghost, 60, SFX_ROCKINGSHIP);
		
		Ghost_Data = combo + 6;
		
		Screen->Quake = 60;
		ShamblesWaitframe(this, ghost, 60, SFX_ROCKINGSHIP);

		if (firstRun)
		{
			Screen->Message(45);
			firstRun = false;
		}
		//end spawning animation

		submerge(this, ghost, 8);

		while (true) //start Activity Cycle
		{		
			int choice = chooseAttack();
			
			ShamblesWaitframe(this, ghost, 120);
			
			int pos = moveMe();
			Ghost_X = ComboX(pos);
			Ghost_Y = ComboY(pos);
			
			if (Ghost_HP < startHP * difficultyMultiplier)
			{
				emerge(this, ghost, 4);
				bombsToLob = 5;
			}
			else
				emerge(this, ghost, 8);
			
			switch(choice) 
			{
				case 0:	//start LinkCharge
					Waitframes(30);
					for (int i = 0; i < 5; ++i)
					{
						int moveAngle = Angle(Ghost_X, Ghost_Y, Hero->X, Hero->Y);
						
						Audio->PlaySound(SFX_SWORD);
						
						for (int j = 0; j < 22; ++j)
						{
							// if (Ghost_HP < startHP * difficultyMultiplier && j % 3 == 0)		//Save for the Boss rush at the tailend of the game
							// {
								// eweapon poisonTrail = FireEWeapon(EW_SCRIPT10, Ghost_X + Rand(-2, 2), Ghost_Y + Rand(-2, 2), 0, 0, ghost->WeaponDamage, 
																	// SPR_POISON_CLOUD, SFX_SIZZLE, EWF_UNBLOCKABLE);

								// SetEWeaponLifespan(poisonTrail, EWL_TIMER, 180);
								// SetEWeaponDeathEffect(poisonTrail, EWD_VANISH, 0);
							// }
							
							Ghost_ShadowTrail(this, ghost, false, 4);
							Ghost_MoveAtAngle(moveAngle, 3, 0);
							ShamblesWaitframe(this, ghost, 1);
						}
						
						ShamblesWaitframe(this, ghost, 30);
					}
						
					break; //end
				
				case 1:	//start Poison Bombs
					for (int i = 0; i < bombsToLob; ++i)
					{
						ShamblesWaitframe(this, ghost, 16);
						eweapon bomb = FireAimedEWeapon(EW_BOMB, Ghost_X, Ghost_Y, 0, 200, ghost->WeaponDamage, -1, -1, EWF_UNBLOCKABLE | EWF_ROTATE);
						Audio->PlaySound(129);
						RunEWeaponScript(bomb, Game->GetEWeaponScript("ArcingWeapon"), {-1, 0, (Ghost_HP < (startHP * difficultyMultiplier)) ? AE_LARGEPOISONPOOL : AE_SMALLPOISONPOOL});
						Waitframes(6);
					}
					break; //end
				
				case 2: //start Spawn Zambos
					spawnZambos(this, ghost);
					break; //end
			}
			
			if (Ghost_HP < startHP * 0.50)
				submerge(this, ghost, 4);
			else
				submerge(this, ghost, 8);
			
			pos = moveMe();
			Ghost_X = ComboX(pos);
			Ghost_Y = ComboY(pos);
		} //end
	
	}
} //end

//~~~~~Demonwall~~~~~//
@Author("Deathrider365")
ffc script Demonwall //start
{
	void run()
	{

		// for (int i = 0; i < roomsize since the wall can squish link for instakill; ++i)
		// {
			// move the guy perhaps 1/8th of a tile every frame 
			// if (demonwall->HP at 70%)
				// move demonwall back 3 tiles if it can, otherwise just back the the left wall
				
			// do some attacks
			
		// }

	}
} //end

