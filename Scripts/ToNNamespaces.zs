///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~~~~~The Terror of Necromancy Namespaces~~~~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

//~~~~~Leviathan1~~~~~//
 
namespace Leviathan //start
{
	const int CMB_WATERFALL = 6828; //Leviathan's waterfall combos: Up (BG, middle) Up, (BG, foam) Down (FG, middle), Down (FG, foam)
	const int CS_WATERFALL = 0;
	
	const int NPC_LEVIATHANHEAD = 177;

	CONFIG SFX_RISE = 67;		//9
	CONFIG SFX_ROCKINGSHIP = 9;
	CONFIG SFX_WATERFALL = 26;
	CONFIG SFX_LEVIATHAN1_ROAR = SFX_ROAR;
	CONFIG SFX_LEVIATHAN1_SPLASH = SFX_SPLASH;
	CONFIG SFX_CHARGE = 35;
	CONFIG SFX_SHOT = 40;

	CONFIG SPR_SPLASH = 93;
	CONFIG SPR_WATERBALL = 94;

	COLOR C_CHARGE1 = C_DARKBLUE;
	COLOR C_CHARGE2 = C_SEABLUE;
	COLOR C_CHARGE3 = C_TAN;
	
	int LEVIATHAN1_WATERCANNON_DMG = 60;
	int LEVIATHAN1_BURSTCANNON_DMG = 30;
	int LEVIATHAN1_WATERFALL_DMG = 50;

	const int MSG_BEATEN = 19;

	bool firstRun = true;
	
	
	npc script Leviathan1 //start
	{	
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
		
		void run(int fight)
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
			for(i = 0; i < 180; ++i)        
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
			}
			
			//
			//    The leviathan pauses, roars, then pauses
			//			
			for(i = 0; i < 120; ++i)
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
			}
			
			//
			//    The leviathan dives
			//
			for(i = 0; i < 20; ++i)
			{
				GlideFrame(this, vars, 52, 32, 52, 112, 20, i);
				Waitframe(this, vars);
			}
			
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
		}
		
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
			
			if(vars[VARS_BODYHP]!=this->HP)
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
			
			Screen->Message(MSG_BEATEN);
			vars[VARS_FLASHTIMER] = 0;
			WaitframeLite(this, vars);
			
			Audio->PlaySound(120);
						
			while(this->Y<112)
			{
				this->Y += 0.5;
				++i;
				i %= 360;
				this->X = x+12*Sin(i*8);
				Audio->PlaySound(SFX_RISE);
				Screen->Quake = 20;
				WaitframeLite(this, vars);
			}
			
			Hero->WarpEx({WT_IWARPOPENWIPE, 2, 11, -1, WARP_A, WARPEFFECT_OPENWIPE, 0, 0, DIR_LEFT});
				
			this->Immortal = false;
			this->Remove();

		}//end
	} //end
	
	//~~~~~Leviathan1_Waterfall~~~~~//
	eweapon script Waterfall //start
	{
		void run(int width, int peakHeight)
		{
			this->UseSprite(94);
			
			int i;
			int x;
			if(!waterfall_bmp->isAllocated())
			{
				this->DeadState = 0;
				Quit();
			}
			
			eweapon hitbox = CreateEWeaponAt(EW_SCRIPT1, this->X, this->Y);
			hitbox->Damage = this->Damage;
			hitbox->DrawYOffset = -1000;
			hitbox->CollDetection = false;
			
			int startX = this->X;
			
			int waterfallTop = this->Y;
			int waterfallBottom = this->Y;
			int bgHeight;
			int fgHeight;
			this->CollDetection = false;
			
			while(waterfallTop > peakHeight)
			{
				waterfallTop = Max(waterfallTop-1.5, peakHeight);
				bgHeight = waterfallBottom-waterfallTop;
				
				for(i = 0; i < width; ++i)
				{
					x = startX - (width - 1) * 8 + i * 16;
					waterfall_bmp->Blit(0, -2, 0, 0, 16, bgHeight, x, waterfallTop, 16, bgHeight, 0, 0, 0, BITDX_NORMAL, 0, false);
				}
				
				Waitframe();
			}
			
			bgHeight = waterfallBottom-waterfallTop;
			waterfallTop = peakHeight;
			waterfallBottom = peakHeight;
			hitbox->CollDetection = true;
			
			while(waterfallBottom < 176)
			{
				if(!hitbox->isValid())
				{
					hitbox = CreateEWeaponAt(EW_SCRIPT1, this->X, this->Y);
					hitbox->Damage = this->Damage;
					hitbox->DrawYOffset = -1000;
				}
				
				hitbox->Dir = -1;
				hitbox->DeadState = -1;
				hitbox->X = 120;
				hitbox->Y = 80;
				hitbox->HitXOffset = (startX - (width - 1) * 8) - 120;
				hitbox->HitYOffset = waterfallTop - 80;
				hitbox->HitWidth = width * 16;
				hitbox->HitHeight = fgHeight;
				
				waterfallBottom += 3;
				fgHeight = waterfallBottom - waterfallTop;
				
				for(i = 0; i < width; ++i)
				{
					x = startX - (width - 1) * 8 + i * 16;
					waterfall_bmp->Blit(0, -2, 0, 0, 16, bgHeight, x, peakHeight, 16, bgHeight, 0, 0, 0, BITDX_NORMAL, 0, false);
					waterfall_bmp->Blit(4, -2, 16, 175-fgHeight, 16, fgHeight, x, peakHeight, 16, fgHeight, 0, 0, 0, BITDX_NORMAL, 0, false);
				}
				
				Waitframe();
			}
			
			while(waterfallTop < 176)
			{
				if(!hitbox->isValid())
				{
					hitbox = CreateEWeaponAt(EW_SCRIPT1, this->X, this->Y);
					hitbox->Damage = this->Damage;
					hitbox->DrawYOffset = -1000;
				}
				
				hitbox->Dir = -1;
				hitbox->DeadState = -1;
				hitbox->X = 120;
				hitbox->Y = 80;
				hitbox->HitXOffset = (startX - (width - 1) * 8) - 120;
				hitbox->HitYOffset = waterfallTop - 80;
				hitbox->HitWidth = width * 16;
				hitbox->HitHeight = fgHeight;
				
				waterfallTop += 3;
				fgHeight = waterfallBottom-waterfallTop;
				
				for(i = 0; i < width; ++i)
				{
					x = startX - (width - 1) * 8 + i * 16;
					waterfall_bmp->Blit(4, -2, 16, 175 - fgHeight, 16, fgHeight, x, waterfallTop, 16, fgHeight, 0, 0, 0, BITDX_NORMAL, 0, false);
				}
				
				Waitframe();
			}
			
			this->DeadState = 0;
			
			if(hitbox->isValid())
				hitbox->DeadState = 0;
			
			Quit();
		}
	}

	//end
			
	//~~~~~LeviathanSignWave~~~~~//
	eweapon script LeviathanSignWave//start
	{
		void run(int size, int speed, bool noBlock)
		{
			int x = this->X;
			int y = this->Y;
			
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
				
				if(noBlock)
					this->Dir = Link->Dir;
				
				Waitframe();
			}
		}
	}
	//end
} 

//end





























