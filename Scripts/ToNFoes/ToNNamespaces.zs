///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~~~~~The Terror of Necromancy Namespaces~~~~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

//~~~~~Leviathan1~~~~~//
namespace Leviathan1Namespace //start
{
	const int CMB_WATERFALL = 6828; //Leviathan's waterfall combos: Up (BG, middle) Up, (BG, foam) Down (FG, middle), Down (FG, foam)
	const int CS_WATERFALL = 0;
	
	const int NPC_LEVIATHANHEAD = 177;

	CONFIG SFX_RISE = 67;		//9
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

	int MSG_BEATEN = 19;
	int MSG_LEVIATHAN_SCALE = 122;

	bool firstRun = true;

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

//~~~~~Amalgamation of Decay ---Shambles---~~~~~//
namespace ShamblesNamespace //start
{
	bool firstRun = true;
	
	int moveMe() //start Movement function
	{
		int pos;
		
		for (int i = 0; i < 352; ++i)
		{
			if (i < 176)
				pos = Rand(176);
			else
				pos = i - 176;
				
			int x = ComboX(pos);
			int y = ComboY(pos);
			
			if (Distance(Hero->X, Hero->Y, x, y) > 48)
				if (Ghost_CanPlace(x, y, 16, 16))
					break;
		}
		
		return pos;
	} //end
		
	void emerge(ffc this, npc ghost, int frames) //start
	{
		int combo = ghost->Attributes[10];
		ghost->CollDetection = true;
		ghost->DrawYOffset = -2;			
		
		Ghost_Data = combo + 4;
		ShamblesWaitframe(this, ghost, frames);
		
		Audio->PlaySound(130);
		
		Ghost_Data = combo + 5;
		ShamblesWaitframe(this, ghost, frames);
		
		Ghost_Data = combo + 6;
		ShamblesWaitframe(this, ghost, frames);
	} //end

	void submerge(ffc this, npc ghost, int frames) //start
	{
		int combo = ghost->Attributes[10];

		Ghost_Data = combo + 6;
		ShamblesWaitframe(this, ghost, frames);
		
		Audio->PlaySound(130);
		
		Ghost_Data = combo + 5;
		ShamblesWaitframe(this, ghost, frames);
		
		Ghost_Data = combo + 4;
		ShamblesWaitframe(this, ghost, frames);
		
		ghost->CollDetection = false;
		ghost->DrawYOffset = -1000;
	} //end
	
	// Chooses an attack
	int chooseAttack() //start
	{
		int numEnemies = Screen->NumNPCs();
		
		if (numEnemies > 5)
			return Rand(0, 1);
		
		return Rand(0, 2);
		
	} //end
	
	// Spawns Zombies
	void spawnZambos(ffc this, npc ghost) //start
	{
		for (int i = 0; i < 3; ++i)
		{
			Audio->PlaySound(64);
			int zamboChoice = Rand(0, 2);
			npc zambo;
			
			if (zamboChoice == 0)
				zambo = Screen->CreateNPC(225);
			else if (zamboChoice == 1)
				zambo = Screen->CreateNPC(222);
			else
				zambo = Screen->CreateNPC(228);
				
			int pos = moveMe();
			
			zambo->X = ComboX(pos);
			zambo->Y = ComboY(pos);
			
			ShamblesWaitframe(this, ghost, 30);
		
		}	
	} //end
	
	void ShamblesWaitframe(ffc this, npc ghost, int frames) //start
	{
		for(int i = 0; i < frames; ++i)
			Ghost_Waitframe(this, ghost, 1, true);
	} //end
	
	void ShamblesWaitframe(ffc this, npc ghost, int frames, int sfx) //start
	{
		for(int i = 0; i < frames; ++i)
		{
			if (sfx > 0 && i % 30 == 0)
				Audio->PlaySound(sfx);
				
			Ghost_Waitframe(this, ghost, 1, true);
		}
	} //end
 
} //end

namespace WaterPaths //start
{
	typedef const int DEFINE;
	typedef const int CONFIG;
	typedef const bool CONFIGB;
	
	CONST_ASSERT(MAX_PATHS > 1 && MAX_PATHS <= 32, "[WaterPaths] MAX_PATHS must be between 2 and 32!");
	
	enum Fluid
	{
		FL_EMPTY,
		FL_PURPLE,
		FL_FLAMING,
		FL_SZ
	};
	
	CONFIGB WP_DEBUG = true;
	
	int getCombo(Fluid f) //start
	{
		switch(f)
		{
			case FL_EMPTY:
				return 3263;
			case FL_PURPLE:
				return 3267;
			case FL_FLAMING:
				return 0;
		}
		
		if(WP_DEBUG)
			printf("[WaterPaths] ERROR: Invalid fluid '%d' passed to 'getCombo'\n");
			
		return 0;
	} //end
	
	CONFIG CT_FLUID = CT_SCRIPT1;
	CONFIG MAX_PATHS = 32;
	
	Fluid pathStates[MAX_PATHS];
	Fluid loadedPattern[MAX_PATHS]; //This contains fluid sources
	long fluidConnections[MAX_DMAPS * MAX_PATHS];
	
	//start COMBO CONSTANTS - SET HERE
	CONFIG CMB_TL_OUTER = 3248;
	CONFIG CMB_TR_OUTER = 3250;
	CONFIG CMB_BL_OUTER = 3256;
	CONFIG CMB_BR_OUTER = 3258;
	CONFIG CMB_TL_INNER = 3265;
	CONFIG CMB_TR_INNER = 3264;
	CONFIG CMB_BL_INNER = 3261;
	CONFIG CMB_BR_INNER = 3260;
	CONFIG CMB_TOP = 3249;
	CONFIG CMB_BOTTOM = 3257;
	CONFIG CMB_LEFT = 3252;
	CONFIG CMB_RIGHT = 3254;
	CONFIG CMB_BARRIER_HORZ = 3262;
	CONFIG CMB_BARRIER_VERT = 3266;
	CONFIG CMB_BARRIER_TOP = 3245;
	CONFIG CMB_BARRIER_BOTTOM = 3244;
	CONFIG CMB_BARRIER_LEFT = 3247;
	CONFIG CMB_BARRIER_RIGHT = 3246;
	//end
	
	DEFINE ATTBU_FLUIDPATH = 0;
	DEFINE VAL_BARRIER = -1;
	
	//start Connections
	int getConnection(int lvl, int q)
	{
		return fluidConnections[lvl * 512 + q - 1];
	}
	
	bool getConnection(int lvl, int q, int p)
	{
		return fluidConnections[lvl * 512 + q - 1] & 1L << (p - 1);
	}
	
	void setConnection(int lvl, int q, int p, bool connect)
	{
		if(q == p) return; //Can't connect to self
		--q;
		--p; //From 1-indexed to 0-indexed
		
		if(connect)
		{
			fluidConnections[lvl * 512 + q] |= 1L << p;
			fluidConnections[lvl * 512 + p] |= 1L << q;
		}
		else
		{
			fluidConnections[lvl * 512 + q] ~= 1L << p;
			fluidConnections[lvl * 512 + p] ~= 1L << q;
		}
	} //end
	
	void updateFluidFlow() //start
	{
		memcpy(pathStates, loadedPattern, MAX_PATHS); //Set to default sources
		
		DEFINE MAX_PATH_PAIRS = MAX_PATHS * (MAX_PATHS - 1) + 1;
		int v1[MAX_PATH_PAIRS];
		int v2[MAX_PATH_PAIRS];
		
		//Cache the pairs of connected paths, so they don't need to be repeatedly calculated 
		int ind = 0;
		
		for(int q = 1; q <= MAX_PATHS; ++q)
		{
			int c = getConnection(Game->GetCurLevel(), q);
			
			unless(c)
				continue;
				
			for(int p = 1; p <= MAX_PATHS; ++p)
			{
				unless(c & (1L << p))
					continue;
				
				v1[ind] = q - 1;
				v2[ind++] = p - 1;
			}
		}
		
		v1[ind] = -1;
		bool didSomething;
		
		do
		{
			didSomething = false;
			
			for(int q = 0; v1[q] > -1; ++q)
			{
				if(flow(v1[q], v2[q]))
					didSomething = true;
			}
		}
		while(didSomething);
	} //end
	
	bool flow(int q, int p)
	{
		Fluid a = pathStates[q], b = pathStates[p];
		
		if(a == b) 
			return false;
		
		//Special fluid mixing logic can occur here
		//For now, the higher value simply flows
		if(a < b) 
			pathStates[q] = b;
		else 
			pathStates[p] = a;
		
		return true;
	}//end
	
	@Author("EmilyV99")
	dmapdata script WaterPaths //start
	{
		/**layers form: 0101010b (layers 6543210, 1 for on 0 for off. 2 layers exactly should be enabled.)
		 * Sources form: val.fluid (i.e. to set key 1 to a source of fluid 1 would be 1.0001)
		 * Fluid 0 is always air, and can never have a 'source'
		 * Combos on the second-highest enabled layer of type 'CT_FLUID' will be scanned.
		 *     The 'Attribute[ATTBU_FLUIDPATH]' will be used to determine what a given combo represents.
		 *     ~~ Positive values represent liquid in a given path (values > MAX_PATHS are invalid)
		 *     ~~ -1 represents barriers between paths
		 *     ~~ Any other value will cause the combo to be ignored.
		 */
		void run(int layers, int s1, int s2, int s3, int s4, int s5, int s6, int s7)
		{
			int foo[] = {s1, s2, s3, s4, s5, s6, s7};
			memset(loadedPattern, 0, MAX_PATHS);
			
			for(int q = 0; q < 7; ++q)
			{
				unless(foo[q] % 1 && foo[q] > 1)
					continue;
					
				Fluid fl = <Fluid>((foo[q] % 1) / 1L);
				unless(fl > 0 && fl < FL_SZ)
					continue;
				
				loadedPattern[Floor(foo[q] - 1)] = fl;
			}
			
			updateFluidFlow();
			
			int l1, l2;
			
			for(int q = 6; q >= 0; --q) //start calculate layers
			{
				if(layers & (1b << q))
				{
					if(l2)
					{
						l1 = q;
						break;
					}
					else 
						l2 = q;
				}
			} //end
			
			int scr = -1;
			
			while(true)
			{
				if(scr != Game->GetCurScreen())
				{
					scr = Game->GetCurScreen();
					mapdata template = Game->LoadMapData(Game->GetCurMap(), Game->GetCurScreen());
					mapdata t1 = Emily::loadLayer(template, l1), t2 = Emily::loadLayer(template, l2);
					mapdata tleft, tright, tup, tdown;
					
					{ //start
						unless(Game->GetCurScreen() < 0x10)
							tup = Emily::loadLayer(Game->LoadMapData(Game->GetCurMap(), Game->GetCurScreen() - 0x10), l1);
						unless(Game->GetCurScreen() >= 0x70)
							tdown = Emily::loadLayer(Game->LoadMapData(Game->GetCurMap(), Game->GetCurScreen() + 0x10), l1);
						if(Game->GetCurScreen() % 0x10)
							tleft = Emily::loadLayer(Game->LoadMapData(Game->GetCurMap(), Game->GetCurScreen() - 1), l1);
						unless(Game->GetCurScreen() % 0x10 == 0xF)
							tright = Emily::loadLayer(Game->LoadMapData(Game->GetCurMap(), Game->GetCurScreen() + 1), l1);
					} //end
					
					mapdata m1 = Game->LoadTempScreen(l1), m2 = Game->LoadTempScreen(l2);
					
					for(int q = 0; q < 176; ++q)
					{
						if(t1->ComboT[q] != CT_FLUID)
							continue;
							
						combodata cd = Game->LoadComboData(t1->ComboD[q]);
						int flag = cd->Attributes[ATTBU_FLUIDPATH];
						
						unless(flag)
							continue;
							
						int u,d,l,r;
						
						//start calculations
						unless(q < 0x10)
							u = Game->LoadComboData(t1->ComboD[q - 0x10])->Attributes[ATTBU_FLUIDPATH];
						else if(tup)
							u = Game->LoadComboData(tup->ComboD[q + 0x90])->Attributes[ATTBU_FLUIDPATH];
						
						unless(q >= 0xA0)
							d = Game->LoadComboData(t1->ComboD[q + 0x10])->Attributes[ATTBU_FLUIDPATH];
						else if(tdown)
							d = Game->LoadComboData(tdown->ComboD[q - 0x90])->Attributes[ATTBU_FLUIDPATH];
						
						if(q % 0x10) 
							l = Game->LoadComboData(t1->ComboD[q - 1])->Attributes[ATTBU_FLUIDPATH];
						else if(tleft) 
							l = Game->LoadComboData(tleft->ComboD[q + 0xF])->Attributes[ATTBU_FLUIDPATH];
						
						unless(q % 0x10 == 0xF) 
							r = Game->LoadComboData(t1->ComboD[q + 1])->Attributes[ATTBU_FLUIDPATH];
						else if(tright)
							r = Game->LoadComboData(tright->ComboD[q - 0xF])->Attributes[ATTBU_FLUIDPATH];
						//end
						
						if(flag > 0) //start Standard fluid
						{
							m1->ComboD[q] = getCombo(pathStates[flag - 1]);
							int cmb = -1;
							
							if(fl(u, flag) && fl(d, flag) && fl(l, flag) && fl(r, flag)) //all same
							{
								//start Inner Corners
								int ul,ur,bl,br;
								
								if(q > 0xF && q % 0x10)
									ul = Game->LoadComboData(t1->ComboD[q - 0x11])->Attributes[ATTBU_FLUIDPATH];
								else if(q < 0x10 && q % 0x10)
									ul = Game->LoadComboData(tup->ComboD[q + 0x8F])->Attributes[ATTBU_FLUIDPATH];
								else if(q > 0xF && !(q % 0x10))
									ul = Game->LoadComboData(tleft->ComboD[q - 1])->Attributes[ATTBU_FLUIDPATH];
								
								if(q > 0xF && (q % 0x10) != 0xF)
									ur = Game->LoadComboData(t1->ComboD[q - 0xF])->Attributes[ATTBU_FLUIDPATH];
								else if(q < 0x10 && (q % 0x10) != 0xF)
									ur = Game->LoadComboData(tup->ComboD[q + 0x91])->Attributes[ATTBU_FLUIDPATH];
								else if(q > 0xF && (q % 0x10) == 0xF)
									ur = Game->LoadComboData(tright->ComboD[q - 0x1F])->Attributes[ATTBU_FLUIDPATH];
								
								if(q < 0xA0 && q % 0x10)
									bl = Game->LoadComboData(t1->ComboD[q + 0xF])->Attributes[ATTBU_FLUIDPATH];
								else if(q > 0x9F && q % 0x10)
									bl = Game->LoadComboData(tdown->ComboD[q - 0x91])->Attributes[ATTBU_FLUIDPATH];
								else if(q < 0xA0 && !(q % 0x10))
									bl = Game->LoadComboData(tleft->ComboD[q + 0x1F])->Attributes[ATTBU_FLUIDPATH];
								
								if(q < 0xA0 && (q % 0x10) != 0xF)
									br = Game->LoadComboData(t1->ComboD[q + 0x11])->Attributes[ATTBU_FLUIDPATH];
								else if(q > 0x9F && (q % 0x10) != 0xF)
									br = Game->LoadComboData(tdown->ComboD[q - 0x8F])->Attributes[ATTBU_FLUIDPATH];
								else if(q < 0xA0 && (q % 0x10) == 0xF)
									br = Game->LoadComboData(tright->ComboD[q + 0x1F])->Attributes[ATTBU_FLUIDPATH];
							
								unless(fl(ul, flag) || !(fl(ur, flag) && fl(bl, flag) && fl(br, flag)))
									cmb = CMB_TL_INNER;
								else unless(fl(ur, flag) || !(fl(ul, flag) && fl(bl, flag) && fl(br, flag)))
									cmb = CMB_TR_INNER;
								else unless(fl(bl, flag) || !(fl(ur, flag) && fl(ul, flag) && fl(br, flag)))
									cmb = CMB_BL_INNER;
								else unless(fl(br, flag) || !(fl(ur, flag) && fl(bl, flag) && fl(ul, flag)))
									cmb = CMB_BR_INNER;
								//end
								else
									cmb = 0;
							}
							else if(fl(u, flag)) //start up
							{
								if(fl(l, flag)) //start upleft
								{
									unless(fl(d, flag)) //upleft, notdown
									{
										if(fl(r, flag)) //upleftright, notdown
											cmb = CMB_BOTTOM;
										else //upleft, notrightdown
											cmb = CMB_BR_OUTER;
									}
									else unless(fl(r, flag)) //upleftdown, notright
										cmb = CMB_RIGHT;
								} //end
								else //start up not-left
								{
									if(fl(r, flag)) //upright, notleft
									{
										unless(fl(d, flag)) //upright, notdownleft
											cmb = CMB_BL_OUTER;
										else //uprightdown, notleft
											cmb = CMB_LEFT;
									}
								} //end
							} //end
							else //start notup
							{
								if(fl(r,flag)) //start right, notup
								{
									if(fl(d, flag)) //rightdown, notup
									{
										if(fl(l, flag)) //rightdownleft, notup
											cmb = CMB_TOP;
										else //rightdown, notleftup
											cmb = CMB_TL_OUTER;
									}
								} //end
								else //start notrightup
								{
									if(fl(d, flag)) //down, notrightup
										if(fl(l, flag)) //leftdown, notrightup
											cmb = CMB_TR_OUTER;
								} //end
							} //end
							
							if(cmb > -1)
							{
								m2->ComboD[q] = cmb;
								m2->ComboC[q] = t1->ComboC[q];
							}
							else if(WP_DEBUG)
								printf("[WaterPaths] Error: Bad combo calculation for fluid pos %d (f: %d, udlr: %d,%d,%d,%d)\n", q, flag, u, d, l, r);
							
						} //end
						else if(flag == VAL_BARRIER) //start Barriers
						{
							int cmb = -1;
							int flowpath = 0;
							bool flowing = false;
							
							if(u > 0 && d > 0 && l < 1 && r < 1) //horizontal barrier
							{
								flowing = getConnection(Game->GetCurLevel(), u, d);
								if(flowing)
									flowpath = u;
								
								if(l == VAL_BARRIER)
								{
									if(r == VAL_BARRIER) //Center
									{
										if(flowing)
											cmb = 0;
										else
											cmb = CMB_BARRIER_HORZ;
									}
									else //Left
									{
										if(flowing)
											cmb = CMB_LEFT;
										else
											cmb = CMB_BARRIER_LEFT;
									}
								}
								else if(r == VAL_BARRIER) //Right
								{
									if(flowing)
										cmb = CMB_RIGHT;
									else
										cmb = CMB_BARRIER_RIGHT;
								}
							}
							else if(l > 0 && r > 0 && u < 1 && d < 1) //vertical barrier
							{
								flowing = getConnection(Game->GetCurLevel(), l, r);
								
								if(flowing)
									flowpath = l;
								
								if(u == VAL_BARRIER)
								{
									if(d == VAL_BARRIER) //Center
									{
										if(flowing)
											cmb = 0;
										else
											cmb = CMB_BARRIER_VERT;
									}
									else //Up
									{
										if(flowing)
											cmb = CMB_TOP;
										else
											cmb = CMB_BARRIER_TOP;
									}
								}
								else if(d == VAL_BARRIER) //Down
								{
									if(flowing)
										cmb = CMB_BOTTOM;
									else
										cmb = CMB_BARRIER_BOTTOM;
								}
							}
							if(cmb > -1)
							{
								if(flowpath)
									m1->ComboD[q] = getCombo(pathStates[flowpath-1]);
									
								m2->ComboD[q] = cmb;
								m2->ComboC[q] = t1->ComboC[q];
							}
							else if(WP_DEBUG)
								printf("[WaterPaths] Error: Bad combo calculation for barrier pos %d (f: %d, udlr: %d,%d,%d,%d)\n", q, flag, u, d, l, r);
							
						} //end
					}
				}
				Waitframe();
			}
		}
		
		bool fl(int f, int bf) //start
		{
			return f == VAL_BARRIER || f == bf;
		} //end
	} //end

	@Author("EmilyV99")
	ffc script SecretsTriggersWaterPaths //start Basic trigger mechanism
	{
		void run(int p1, int p2)
		{
			if(Screen->State[ST_SECRET]) //already triggered
				return;
			
			unless(p1 > 0 && p1 <= MAX_PATHS && p2 > 0 && p2 <= MAX_PATHS)
			{
				if(WP_DEBUG)
					printf("[WaterPaths] FFC %d invalid setup; first 2 params must both be >0 and <=MAX_PATHS(%d)\n", this->ID, MAX_PATHS);
				return;
			}
			
			until(Screen->State[ST_SECRET])
				Waitframe();
				
			setConnection(Game->GetCurLevel(), p1, p2, true);
			updateFluidFlow();
		}
	} //end
} //end






























