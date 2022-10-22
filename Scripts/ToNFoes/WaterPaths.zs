#option SHORT_CIRCUIT on
#option BINARY_32BIT off
#option HEADER_GUARD on

namespace WaterPaths //start
{
	typedef const int DEFINE;
	typedef const int CONFIG;
	typedef const bool CONFIGB;
	
	CONST_ASSERT(MAX_PATHS > 1 && MAX_PATHS <= 32, "[WaterPaths] MAX_PATHS must be between 2 and 32!");
	
	enum Fluid //start
	{
		FL_EMPTY,
		FL_PURPLE,
		FL_FLAMING,
		FL_SZ
	}; //end
	
	CONFIGB WP_DEBUG = false;
	
	int getCombo(Fluid f, bool solid) //start
	{
		switch(f)
		{
			case FL_EMPTY:
				return 3263;
			case FL_PURPLE:
				return solid ? 3259 : 3267;
			case FL_FLAMING:
				return solid ? 3255 : 3255;
		}
		
		if(WP_DEBUG)
			printf("[WaterPaths] ERROR: Invalid fluid '%d' passed to 'getCombo'\n");
			
		return 0;
	} //end
	
	CONFIG CT_FLUID = CT_SCRIPT2;
	CONFIG MAX_PATHS = 32;
	DEFINE SZ_PATHSTATES = MAX_PATHS * 2 + 1;
	DEFINE UPDATE_PATHS = SZ_PATHSTATES - 1;
	
	untyped pathStates[SZ_PATHSTATES];
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
	CONFIG CMB_BARRIER_TOP = 3244;
	CONFIG CMB_BARRIER_BOTTOM = 3245;
	CONFIG CMB_BARRIER_RIGHT = 3247;
	CONFIG CMB_BARRIER_LEFT = 3246;
	CONFIG CMB_SOLID_INVIS = 2;
	//end
	
	DEFINE ATTBU_FLUIDPATH = 0;
	DEFINE VAL_BARRIER = -1;
	
	Fluid getFluid(int path) //start
	{
		if(path < 1 || path >= MAX_PATHS)
			return <untyped>(-1);
			
		return pathStates[path - 1];
	} //end
	
	Fluid getSource(int path) //start
	{
		if(path < 1 || path >= MAX_PATHS)
			return <untyped>(-1);
			
		return pathStates[path - 1 + MAX_PATHS];
	} //end
	
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
		printf("Try connect: LVL %d, (%d <> %d) %s\n", lvl, q-1, p-1, connect ? "true" : "false");
		
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
		memcpy(pathStates, 0, pathStates, MAX_PATHS, MAX_PATHS); //Set to default sources
		
		DEFINE MAX_PATH_PAIRS = MAX_PATHS * (MAX_PATHS - 1) + 1;
		int v1[MAX_PATH_PAIRS];
		int v2[MAX_PATH_PAIRS];
		
		//Cache the pairs of connected paths, so they don't need to be repeatedly calculated 
		int ind = 0;
		
		for(int q = 0; q < MAX_PATHS; ++q)
		{
			int c = getConnection(Game->GetCurLevel(), q + 1);
			
			unless(c)
				continue;
				
			for(int p = q + 1; p < MAX_PATHS; ++p)
			{
				unless(c & (1L << p))
					continue;
					
				printf("Found pair: %d,%d\n", q, p);
				v1[ind] = q;
				v2[ind++] = p;
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
		pathStates[UPDATE_PATHS] = true;
	} //end
	
	bool flow(int q, int p) //start
	{
		Fluid a = pathStates[q], b = pathStates[p];
		printf("Checking flow between [%d] (%d) and [%d] (%d)\n", q, a, p, b);
		if(a == b) 
			return false;
		printf("Flow occurring: %d != %d\n", a, b);
		//Special fluid mixing logic can occur here
		//For now, the higher value simply flows
		if(a < b)
		{
			printf("%d<%d, setting [%d] = %d\n", a, b, q, b); 
			pathStates[q] = b;
		}
		else
		{
			printf("%d>%d, setting [%d] = %d\n", a, b, p, a);
			pathStates[p] = a;
		}
		
		return true;
	} //end
	
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
			Waitframes(2);
			
			if(WP_DEBUG) printf("Running DM script WaterPaths (%d,%d,%d,%d,%d,%d,%d,%d)\n", layers, s1, s2, s3, s4, s5, s6, s7);
			int foo[] = {s1, s2, s3, s4, s5, s6, s7};
			memset(pathStates, 0, SZ_PATHSTATES);
			
			for(int q = 0; q < 7; ++q)
			{
				unless(foo[q] % 1 && foo[q] > 1)
					continue;
					
				Fluid fl = <Fluid>((foo[q] % 1) / 1L);
				
				unless(fl > 0 && fl < FL_SZ)
					continue;
				
				pathStates[MAX_PATHS + Floor(foo[q] - 1)] = fl;
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
				//if screen has a FL_FLAMING play sound 13
			
				if(scr != Game->GetCurScreen() || pathStates[UPDATE_PATHS])
				{
					scr = Game->GetCurScreen();
					pathStates[UPDATE_PATHS] = false;
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
					
					//start passes
					enum //start
					{
						PASS_LIQUID,
						PASS_BARRIERS,
						PASS_COUNT
					}; //end
					
					for(int pass = 0; pass < PASS_COUNT; ++pass)
					{
						for(int q = 0; q < 176; ++q)
						{
							if(t1->ComboT[q] != CT_FLUID)
								continue;
								
							combodata cd = Game->LoadComboData(t1->ComboD[q]);
							int flag = cd->Attributes[ATTBU_FLUIDPATH];
							
							switch(pass)
							{
								case PASS_LIQUID:
									unless(flag > 0) 
									continue;
									break;
								case PASS_BARRIERS:
									unless(flag == VAL_BARRIER) 
									continue;
									break;
							}
								
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
										br = Game->LoadComboData(tright->ComboD[q + 0x01])->Attributes[ATTBU_FLUIDPATH];
										
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
									m1->ComboD[q] = getCombo(getFluid(flag), cmb>0);
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
											{
												cmb = CMB_BARRIER_HORZ;
												if(CMB_SOLID_INVIS)
												{
													if(q >= 0x10)
													{
														m1->ComboD[q-0x10] = getCombo(getFluid(u), true); 
														m2->ComboD[q-0x10] = CMB_SOLID_INVIS;
													}
													if(q < 0xA0)
													{
														m1->ComboD[q+0x10] = getCombo(getFluid(d), true); 
														m2->ComboD[q+0x10] = CMB_SOLID_INVIS;
													}
												}
											}
										}
										else //Left
										{
											if(flowing)
												cmb = CMB_RIGHT;
											else
												cmb = CMB_BARRIER_RIGHT;
										}
									}
									else if(r == VAL_BARRIER) //Right
									{
										if(flowing)
											cmb = CMB_LEFT;
										else
											cmb = CMB_BARRIER_LEFT;
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
											{
												cmb = CMB_BARRIER_VERT;
												if(CMB_SOLID_INVIS)
												{
													if(q % 0x10)
													{
														m1->ComboD[q-1] = getCombo(getFluid(l), true); 
														m2->ComboD[q-1] = CMB_SOLID_INVIS;
													}
													if(q % 0x10 < 0x0F)
													{
														m1->ComboD[q+1] = getCombo(getFluid(r), true); 
														m2->ComboD[q+1] = CMB_SOLID_INVIS;
													}
												}
											}
										}
										else //Up
										{
											if(flowing)
												cmb = CMB_BOTTOM;
											else
												cmb = CMB_BARRIER_BOTTOM;
										}
									}
									else if(d == VAL_BARRIER) //Down
									{
										if(flowing)
											cmb = CMB_TOP;
										else
											cmb = CMB_BARRIER_TOP;
									}
								}
								if(cmb > -1)
								{
									if(flowpath)
										m1->ComboD[q] = getCombo(getFluid(flowpath), cmb>0);
									
									m2->ComboD[q] = cmb;
									m2->ComboC[q] = t1->ComboC[q];
								}
								else if(WP_DEBUG)
									printf("[WaterPaths] Error: Bad combo calculation for barrier pos %d (f: %d, udlr: %d,%d,%d,%d)\n", q, flag, u, d, l, r);
								
							} //end
						}
					}
					//end
				}
				Waitframe();
			}
		}
		
	} //end

	bool fl(int f, int bf) //start
	{
		return f == VAL_BARRIER || f == bf;
	} //end
	
	// p1 is first path and p2 is the patha activated on secret trigger
	@Author("EmilyV99")
	ffc script SecretsTriggersWaterPaths //start Basic trigger mechanism
	{
		void run(int p1, int p2)
		{
			printf("STWP: Start %d,%d\n", p1, p2);
						
			if(Screen->State[ST_SECRET]) //already triggered
				return;
			
			unless(p1 > 0 && p1 <= MAX_PATHS && p2 > 0 && p2 <= MAX_PATHS)
			{
				if(WP_DEBUG)
					printf("[WaterPaths] FFC %d invalid setup; first 2 params must both be >0 and <=MAX_PATHS(%d)\n", this->ID, MAX_PATHS);
				return;
			}
			
			printf("STWP: Begin waiting for secret trigger\n");
			
			until(Screen->State[ST_SECRET])
				Waitframe();
				
			printf("STWP: Secrets Triggered. Setting connection %d,%d\n", p1, p2);
			setConnection(Game->GetCurLevel(), p1, p2, true);
			
			updateFluidFlow();
		}
	} //end
} //end
