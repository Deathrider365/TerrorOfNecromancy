ffc script LightOfTheHeavensVersionThree{ //Now with 100% less magnetshot
	
	enum{ //Horizon Array
		_BACKGROUNDTOGGLE,
		_PALETTETARGET,
		_PALETTEOVERRIDE,
		_BURNCOUNTER_ASHER,
		_BURNCOUNTER_TORRIN,
		_BURNCOUNTER_KAYLANI,
		_HALOXOFFSET, //For manually drawing the halo in one sequence, we use this silly thing
		_HALOYOFFSET, //This absolutely could be handled better, but this also isn't the worst so I can't be assed to fixed it
		_MANUALCOLORCHANGE,
		_SURFBOARD
	};
	enum{ //Combo state array
		BASECOMBO,
		WALKINGCOMBO,
		ATKCOMBO1,
		ATKCOMBO2,
		TELECOMBO,
		HOLDUPCOMBO
	};

	void run(int enemyID){
		npc ghost = Ghost_InitAutoGhost(this,enemyID);
		this->Flags[FFCF_ETHEREAL] = true;
		Ghost_Transform(this, ghost, -1, -1, 1, 2);
		Ghost_SetHitOffsets(ghost, 15, 0, 0, 0);
		
		Ghost_HP=30000;
		ghost->HP=30000;
		ghost->Damage=6;
		ghost->WeaponDamage=4;
		
		int BossType = G[G_CHASEDIFF]; //Set this against whatever global variable you end up using to handle the funny dialogue branches. 
		//0 is the full fight, 1 is phases 1&2, 2 is the easiest fight
		
		int MaxHP = Ghost_HP;
		int Phase = 1;
		int Form = 1;
		int CharacterAttackMod = Rand(0,2);
		int LastAttack = -1;
		int Attackchoice = -1;
		int Attackcount = 0;
		int MinAttackchoice = 0;
		int MaxAttackchoice = 2;
		int HorizonArray[16];
		int HorizonCombo[6]; //Stored combo states for the main boss
		int linkTiles[2];
		int TX; int TY; int TAngle;
		eweapon EArray[12];
		npc NPCArray[3]; //Sun enemy management
		
		HorizonArray[_BACKGROUNDTOGGLE]=1;
		HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
		
		for(int i=0; i<SizeOfArray(HorizonCombo); ++i){
			HorizonCombo[i] = ghost->Attributes[10]+i*4;
		}
		RNGFlush();
		
		int StarD[128];
		int StarA[128];
		for(int i=0; i<128; ++i){
			StarD[i] = Rand(256);
			StarA[i] = Rand(359);
		}
		
		Ghost_SetFlag(GHF_4WAY);
		Ghost_SetFlag(GHF_IGNORE_NO_ENEMY);
		//Ghost_SetFlag(GHF_IGNORE_ALL_TERRAIN);
		
		Ghost_X = 120;
		Ghost_Y = 72;
		Ghost_Dir = DIR_DOWN;
		
		Game->PlayEnhancedMusic("SS-ImagineTheSun.ogg", 0);
		HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 48);
		
		G[G_HORIZONCURRENTFORM] = 0;
		while(Form==1){ //First Form
			for(int i=0; i<42; ++i){
				Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
				HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
			}
			Ghost_Data = HorizonCombo[ATKCOMBO1];
			for(int i=0; i<42; ++i){
				Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
				HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
			}
			
			if(Phase==1 && Ghost_HP<= MaxHP-HORIZON_FIRSTHP/5){
				Phase=2; 
				MaxAttackchoice=4;
			}
			else if(Phase==2 && Ghost_HP<=MaxHP-HORIZON_FIRSTHP/2){
				Phase =3;
			}
			else if(Ghost_HP<=MaxHP-HORIZON_FIRSTHP && Phase>3){ //Transition to next stage of the fight after taking enough damage...
				break;
			}
			
			Attackchoice = Rand(MinAttackchoice, MaxAttackchoice);
			while(Attackchoice==LastAttack){
				Attackchoice = Rand(MinAttackchoice, MaxAttackchoice);
			}
			LastAttack = Attackchoice;
			Attackcount++;
			
			if(Attackcount%3==CharacterAttackMod && Phase>1){ //Character specific attack logic
				
				HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER;
			
				if(GetCharID() == CHAR_ASHER){ //Solar sword
					TAngle = Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8);
					Ghost_Dir=AngleDir4(TAngle);
					Ghost_Data=HorizonCombo[ATKCOMBO1];
					int j=Choose(-1,1); int i; int k;
					Game->PlaySound(SFX_STELLARSWORD_APPEAR);
					for(i=0; i<5; ++i){
						for(k=0; k<2; ++k){
							DrawHorizonSword(Ghost_X, Ghost_Y+16, TAngle-90*j, 8, i, ghost->Damage*1.5, 0, 0, 0);
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
						}
					}
					for(i=0; i<48; ++i){
						DrawHorizonSword(Ghost_X, Ghost_Y+16, TAngle-90*j, 8, 5, ghost->Damage*1.5, -0, 0, 0);
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					Game->PlaySound(SFX_STELLARSWORD_SLASH);
					for(i=30; i<180+45; i+=15){
						
						DrawHorizonSword(Ghost_X, Ghost_Y+16, TAngle-90*j+i*j, 12, 5, ghost->Damage*1.5, TAngle-90*j+i*j -(i-45)*j, 30, 600);
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					for(i=5; i>1; --i){
						DrawHorizonSword(Ghost_X, Ghost_Y+16, TAngle-90*j+180*j, 8, i, ghost->Damage*1.5, 0, 0, 0);
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					//DrawHorizonSword(int sx, int sy, int angle, int dist, int swordlength, int damage, int TrailAngle, int TrailSpacing, int FlareDuration)
				}
				else if(GetCharID() == CHAR_TORRIN){ //Wicked Weaves
					int Delay=36;
					int LastChoice=0;
					for(int Punches=0; Punches<7; Punches++){
						if(Ghost_Data==HorizonCombo[ATKCOMBO1])Ghost_Data=HorizonCombo[ATKCOMBO2];
						else Ghost_Data=HorizonCombo[ATKCOMBO1];
						TAngle = Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8);
						Ghost_Dir=AngleDir4(TAngle);
						
						
						int Offset = Choose(0, 40, 75);
						while(Offset==LastChoice)Offset = Choose(0, 0, 40, 75);
						LastChoice = Offset;
						Offset *= Choose(-1,1);
						TX = Link->X+VectorX(48, TAngle+180+Offset);
						TY = Link->Y+VectorY(48, TAngle+180+Offset);
						
						eweapon e = FireAimedEWeapon(EW_SOLAR, TX, TY, 0, 0, ghost->Damage/2, 108, 97, EWF_UNBLOCKABLE);
						if(Ghost_Data==HorizonCombo[ATKCOMBO1])e->Tile=TIL_HORIZONFIST1;
						else e->Tile = TIL_HORIZONFIST2;
						e->CSet=3;
						e->DrawYOffset=1000;
						e->CollDetection=false;
						int Goddamnit[8];
						Goddamnit[0]=64; //4-long fist
						Goddamnit[1]=Delay;
						Goddamnit[2]=8;
						Goddamnit[3]=24;
						Goddamnit[4]=12;
						//int extend, int telegraphTime, int extendTime, int sustainTime, int retractTime
						RunEWeaponScript(e, "HorizonWeave", Goddamnit);
						
						int DelayMod = Rand(16, 32);
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, DelayMod);
						Delay=36+(24-DelayMod);
					}
					Ghost_Data = HorizonCombo[BASECOMBO];
					Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 32);
					Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
				}
				else if(GetCharID() == CHAR_KAYLANI){ //Sundog Danmaku
					Ghost_Data = HorizonCombo[HOLDUPCOMBO];
					int XPos[12]; //Stores if a slot has been taken or not yet
					int Choice;
					for(int i=0; i<3; ++i){ //Bias the first 3 towards the side of the screen as the player
						
						if(Link->X >128)Choice = Rand(6,11);
						else Choice = Rand(0,5);
						
						if(XPos[Choice]){ //Slot taken? Try again
							i--;
							continue;
						}
						else{
							XPos[Choice]=1;
							eweapon e = FireNonAngularEWeapon(EW_SOLAR, 32+Choice*16, 32, DIR_DOWN, 0, ghost->WeaponDamage, 108, 39, EWF_UNBLOCKABLE);
							ConfigureSundog(e, DIR_DOWN, 150, 2, 70);
							//int FlickerTime, int NumShots, int FiringDelay
						}
					}
					HorizonArray[_HALOYOFFSET]=-1;
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 24);
					HorizonArray[_HALOYOFFSET]=-1;
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 24);
					
					ghost->CollDetection=false;
					Ghost_Data = HorizonCombo[TELECOMBO];
					Game->PlaySound(SFX_HORIZONTELEPORT);
					
					for(int g=0; g<3; ++g){ //3 waves of 3...
						for(int i=0; i<3; ++i){ 
							Choice = Rand(0,11);
							
							if(XPos[Choice]){
								i--;
								continue;
							}
							else{
								XPos[Choice]=1;
								eweapon e = FireNonAngularEWeapon(EW_SOLAR, 32+Choice*16, 32, DIR_DOWN, 0, ghost->WeaponDamage, 108, 39, EWF_UNBLOCKABLE);
								ConfigureSundog(e, DIR_DOWN, 150, 2, 70);
							}
						}	
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 48);
					}
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 240);
					ghost->CollDetection=true;
					Ghost_Data = HorizonCombo[BASECOMBO];
					HorizonArray[_HALOYOFFSET]=0;
					Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
					
				}
				Ghost_Data = HorizonCombo[BASECOMBO];
				HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
				HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 90);
			}
			
			if(Phase==1 && Ghost_HP<= MaxHP-HORIZON_FIRSTHP/5){
				Phase=2; 
				MaxAttackchoice=4;
			}
			else if(Phase==2 && Ghost_HP<=MaxHP-HORIZON_FIRSTHP/2){
				Phase =3;
				Attackchoice=-1;
			}
			else if(Ghost_HP<=MaxHP-HORIZON_FIRSTHP && Phase>3){ //Transition to next stage of the fight after taking enough damage...
				break;
			}
			
			switch(Attackchoice){
				case 0:{ //Large Homing Shot barrage
					Ghost_Data = HorizonCombo[ATKCOMBO1];
					Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 20);
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE+2;
					for(int i=0; i<4; ++i){
						Ghost_Data = HorizonCombo[ATKCOMBO1];
						if(i%2==1)Ghost_Data = HorizonCombo[ATKCOMBO2];
						
						Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
						eweapon e = FireAimedEWeapon(EW_SOLAR, Ghost_X, Ghost_Y+16, DegtoRad(0), 200, ghost->WeaponDamage, 108, SFX_HORIZONSHOT, EWF_UNBLOCKABLE);
						SetEWeaponMovement(e, EWM_HOMING, DegtoRad(.5), -1);
						RunEWeaponScript(e, "HorizonLargeShot", {0});
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 20);
					}
					Ghost_Data = HorizonCombo[BASECOMBO];
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
					Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 60);
					Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
					break;
				}
				case 1:{ //Volleys of longshots
					for(int g=0; g<4; ++g){
						Ghost_Data = HorizonCombo[ATKCOMBO1];
						if(g%2==1)Ghost_Data = HorizonCombo[ATKCOMBO2];
						
						TAngle = Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8);
						for(int i=-45; i<=45; i+=45){
							TX = Ghost_X-16+VectorX(30, TAngle+i);
							TY = Ghost_Y+16+VectorY(30, TAngle+i);
							int Offset=i/1.5;
							if(g%2==0)Offset=0;
							eweapon e = FireBigEWeapon(EW_SOLAR, TX, TY, DegtoRad(TAngle+Offset), 600, ghost->WeaponDamage, SPR_HORIZONSHOT3X1, 0, EWF_UNBLOCKABLE, 3, 1);
							e->CollDetection = false;
							e->DrawYOffset = -1000;
							RunEWeaponScript(e, "HorizonPortalShot", {0});
						}
						Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
						HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE+2;
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 30);
						HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
						Ghost_Data = HorizonCombo[BASECOMBO];
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 30);
						Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
					}
					break;
				}
				case 2:{ //Bullet Flower
					int Choice=Choose(-1,1);
					TAngle=Rand(1,360);
					Ghost_Data = HorizonCombo[ATKCOMBO1];
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER;
					for(int shots=0; shots<8; shots++){
						for(int i=1; i<=6; i++){
							eweapon CircleArc1 = FireEWeapon(EW_SOLAR, Ghost_X, Ghost_Y+16, DegtoRad(60*i+TAngle), 150, ghost->WeaponDamage, SPR_HORIZONSPAZER, SFX_HORIZONSHOT, EWF_UNBLOCKABLE|EWF_ROTATE_360);
							SetEWeaponMovement(CircleArc1, EWM_SINE_WAVE, -4*Choice, 10);
							SetEWeaponLifespan(CircleArc1, EWL_TIMER, 200);
							SetEWeaponDeathEffect(CircleArc1, EWD_VANISH, 0);
							CircleArc1->Misc[0]=1.15;
							RunEWeaponScript(CircleArc1, "HorizonSpazer", {0});
						
							CircleArc1 = FireEWeapon(EW_SOLAR, Ghost_X, Ghost_Y+16, DegtoRad(60*i-TAngle), 150, ghost->WeaponDamage, SPR_HORIZONSPAZER, SFX_HORIZONSHOT, EWF_UNBLOCKABLE|EWF_ROTATE_360);
							SetEWeaponMovement(CircleArc1, EWM_SINE_WAVE, 4*Choice, 10);
							SetEWeaponLifespan(CircleArc1, EWL_TIMER, 200);
							SetEWeaponDeathEffect(CircleArc1, EWD_VANISH, 0);
							CircleArc1->Misc[0]=-1.15;
							RunEWeaponScript(CircleArc1, "HorizonSpazer", {0});
							
						}
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 8);
						Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
					}
					Ghost_Data = HorizonCombo[BASECOMBO];
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 90);
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
					Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
					break;
				}
				case 3:{ //Tracking laser
					Ghost_Data = HorizonCombo[ATKCOMBO1];
					Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
					
					TX = Ghost_X+InFrontX(Ghost_Dir, 4);
					TY = Ghost_Y+16+InFrontY(Ghost_Dir, 4);
					
					eweapon e = FireAimedEWeapon(EW_SOLAR, TX, TY, DegtoRad(0), 0, ghost->Damage, 108, 0, EWF_UNBLOCKABLE);
					e->CollDetection = false;
					e->DrawYOffset = -1000;
					e->Misc[HL_LINETELEGRAPH]=1;
					e->Misc[HL_WIDTH]=48;
					e->Misc[HL_STARTTIME]=48;
					e->Misc[HL_DURATION]=60;
					e->Misc[HL_ROTOFFSET]=0; //Manually dragging this one
					
					RunEWeaponScript(e, "HorizonLaser", {0});
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER;
					while(e->Misc[HL_DURATION]>0){
						TAngle=Angle(e->X, e->Y, Link->X, Link->Y);
						float tracking = 1.25;
						if(e->Misc[HL_STARTTIME])tracking=.6;
						e->Angle=DegtoRad(TurnToAngle(RadtoDeg(e->Angle), TAngle, tracking));
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 1);
					}
					Ghost_Data = HorizonCombo[BASECOMBO];
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 10);
					Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 30);
					
					break;
				}
				case 4:{ //Orbiting tri-lasers
					Ghost_Data = HorizonCombo[ATKCOMBO1];
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER;
					Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
					int Length = 4;
					TAngle=Rand(359);
					int TAngle2;
					for(int i=0; i<3; ++i){
						TAngle2 = TAngle+i*120;
						TX=Ghost_X+VectorX(Length, TAngle2);
						TY=Ghost_Y+16+VectorY(Length, TAngle2);
						
						eweapon e = FireEWeapon(EW_SOLAR, TX, TY, DegtoRad(TAngle2), 0, ghost->Damage, 108, 0, EWF_UNBLOCKABLE);
						e->CollDetection = false;
						e->DrawYOffset = -1000;
						e->Misc[HL_LINETELEGRAPH]=0;
						e->Misc[HL_WIDTH]=48;
						e->Misc[HL_STARTTIME]=120;
						e->Misc[HL_DURATION]=64;
						e->Misc[HL_ROTOFFSET]=2;
						EArray[i]=e;
						RunEWeaponScript(e, "HorizonLaser", {0});
					}
					
					for(int frames=0; frames<180; ++frames){
						Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
						if(frames==30)Ghost_Data = HorizonCombo[BASECOMBO];
						if(Length<40 && frames%3==0)Length++;
						for(int i=0; i<3; ++i){
							if(EArray[i]->isValid()){
								EArray[i]->Angle+=DegtoRad(EArray[i]->Misc[HL_ROTOFFSET]);
								TAngle2 = RadtoDeg(EArray[i]->Angle);
								TX=Ghost_X+VectorX(Length, TAngle2);
								TY=Ghost_Y+16+VectorY(Length, TAngle2);
								EArray[i]->X=TX;
								EArray[i]->Y=TY;
								if(frames==80)EArray[i]->Misc[HL_LINETELEGRAPH]=1;
								if(EArray[i]->Misc[HL_STARTTIME]==0)EArray[i]->Misc[HL_ROTOFFSET]=4.5;
								
							}
						}
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 1);
					}
					Ghost_Data = HorizonCombo[BASECOMBO];
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
					Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 20);
					
					break;
				}
			}
			for(int i=0; i<24; ++i){ //Delay after base attacks
				Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
				HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
			}
			
			if(Phase==3){ //Sunsphere
				Phase=4;
				MinAttackchoice=1; //adeau, easy to dodge homing spheres
				Ghost_Data = HorizonCombo[TELECOMBO];
				Game->PlaySound(SFX_HORIZONTELEPORT);
				ghost->CollDetection=false;
				//Ghost_HP=MaxHP-HORIZON_FIRSTHP/2;
				//ghost->HP = Ghost_HP;
				//ghost->Misc[NPCM_DAMAGENUMBERSLASTHP] = ghost->HP;
				CharacterAttackMod = Rand(0,2);
				
				HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 30);
				HorizonArray[_PALETTETARGET]=HORIZON_PAL_BRIGHT;
				
				int Dist = 12;
				int FAngle;
				int Offset;
				int FX; int FY;
				Game->PlaySound(SFX_CHARGE1);
				HorizonArray[_MANUALCOLORCHANGE]=1;
				for(int frames=0; frames<720; ++frames){
					if(frames%2==0)Screen->D[D_HORIZON_FX] = Choose(C_WHITE, Rand(C_GOLD1-3, C_GOLD2-3), Rand(C_GOLD1, C_GOLD2));
					
					if(Dist<60 && frames<540)Dist++;
					else if(frames>=600 && frames%2==0)Dist--;
					Screen->Quake = Rand(10,16);
					if(frames%40==0 && Dist>=60 && frames<=540){
						if(frames%120!=0){
							FAngle = Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8);
							for(int i=0; i<2; i++){
								
								FX = Ghost_X+8+VectorX(Dist-24, FAngle);
								FY = Ghost_Y+24+VectorY(Dist-24, FAngle);
								eweapon e = FireEWeapon(EW_SOLAR, FX, FY, DegtoRad(FAngle), 0, ghost->WeaponDamage*2, 108, 0, EWF_UNBLOCKABLE);
								e->CollDetection = false;
								e->DrawYOffset = -1000;
								e->Misc[HL_LINETELEGRAPH]=0;
								e->Misc[HL_WIDTH]=32;
								e->Misc[HL_STARTTIME]=64;
								e->Misc[HL_DURATION]=72;
								e->Misc[HL_ROTOFFSET]=0;
								RunEWeaponScript(e, "HorizonLaser", {0});
								FAngle+= Rand(120, 240);
							}
						}
						else{
							FAngle = Rand(360);
							Offset = Choose({-0.55, -.45, .45, 0.55});
							for(int i=0; i<2; i++){
								FAngle+= Rand(120, 240);
								FX = Ghost_X+8+VectorX(Dist-24, FAngle);
								FY = Ghost_Y+24+VectorY(Dist-24, FAngle);
								eweapon e = FireEWeapon(EW_SOLAR, FX, FY, DegtoRad(FAngle), 0, ghost->WeaponDamage*2, 108, 0, EWF_UNBLOCKABLE);
								e->CollDetection = false;
								e->DrawYOffset = -1000;
								e->Misc[HL_LINETELEGRAPH]=0;
								e->Misc[HL_WIDTH]=32;
								e->Misc[HL_STARTTIME]=48;
								e->Misc[HL_DURATION]=72;
								RunEWeaponScript(e, "HorizonLaser", {0});
								e->Misc[HL_ROTOFFSET]=Offset;
							}
						}
					}
					for(int i=Screen->NumEWeapons(); i>0; --i){
						eweapon e = Screen->LoadEWeapon(i);
						if(e->Script==Game->GetEWeaponScript("HorizonLaser")){
							e->Angle+=DegtoRad(e->Misc[HL_ROTOFFSET]);
							FAngle = RadtoDeg(e->Angle);
							TX=Ghost_X+VectorX(Dist-24, FAngle);
							TY=Ghost_Y+16+VectorY(Dist-24, FAngle);
							e->X=TX;
							e->Y=TY;
							if(e->Misc[HL_STARTTIME]<24)e->Misc[HL_LINETELEGRAPH]=1;
						}
					}
					Screen->Circle(2, Ghost_X+8+Rand(-2,2), Ghost_Y+24+Rand(-2,2), Rand(-2,2)+Dist, C_WHITE, 1, 0, 0, 0, true, OP_TRANS);
					Screen->Circle(4, Ghost_X+8+Rand(-2,2), Ghost_Y+24+Rand(-2,2), Rand(-2,2)+Dist-16, Screen->D[D_HORIZON_FX], 1, 0, 0, 0, true, OP_OPAQUE);
					if(Distance(Link->X+8, Link->Y+8, Ghost_X+8, Ghost_Y+24)<Dist-16){
						DamageLinkSolar(ghost->WeaponDamage*1.5);
					}
					if(frames==600)HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER;
					else if(frames==660)HorizonArray[_PALETTETARGET]=HORIZON_PAL_BRIGHT;
					
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
				}
				HorizonArray[_MANUALCOLORCHANGE]=0;
				ghost->CollDetection=true;
				Ghost_Data = HorizonCombo[BASECOMBO];
				HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
			}
			else if(Ghost_HP<=MaxHP-HORIZON_FIRSTHP && Phase==4){ //A second check down here to 
				break;
			}
			else if(Attackcount%2==0 && Distance(Link->X+8, Link->Y+8, Ghost_X+8, Ghost_Y+24)<=48){ //Anti-hug shockwave
				Ghost_Data = HorizonCombo[HOLDUPCOMBO]; //It's not you, I just have personal space issues!
				HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER;
				Game->PlaySound(35);
				for(int frames=0; frames<32; ++frames){
					TX = Ghost_X+4;
					TY = Ghost_Y+13;
					Screen->Circle(3, TX, TY, 1+frames/5+Rand(0,6), Screen->D[D_HORIZON_FX], 1, 0, 0, 0, true, OP_OPAQUE);
					
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
				}
				
				Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
				Game->PlaySound(37);
				bool push=false;
				Screen->Quake=32;
				for(int frames=0; frames<16; ++frames){
					DrawEnergyRing(4, TX+Rand(-1,1), TY+Rand(-1,1), frames*4, frames/2, frames/2, Screen->D[D_HORIZON_FX], 24, Rand(359));
					if(Distance(Ghost_X, Ghost_Y+16, Link->X, Link->Y)<=(frames*4)){
						DamageLinkSolar(ghost->Damage);
						push=true;
					}
					if(push){
						TAngle = Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y);
						LinkMovement_Push2(VectorX(4, TAngle), VectorY(4, TAngle));
						Link->HitDir=-1;
						NoAction();
					}
					
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
				}
				HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
				Ghost_Data = HorizonCombo[BASECOMBO];
				if(push){
					Screen->Quake=16;
					for(int i=0; i<8; ++i){
						TAngle = Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y);
						LinkMovement_Push2(VectorX(3, TAngle), VectorY(3, TAngle));
						Link->HitDir=-1;
						NoAction();
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					Game->PlaySound(67);
				}
				
			}
			
			if(Phase==1 && Ghost_HP<= MaxHP-HORIZON_FIRSTHP/5){
				Phase=2; 
				MaxAttackchoice=4;
			}
			else if(Phase==2 && Ghost_HP<=MaxHP-HORIZON_FIRSTHP/2){
				Phase =3;
				Attackchoice=-1;
			}
			else if(Ghost_HP<=MaxHP-HORIZON_FIRSTHP && Phase>3){ //Transition to next stage of the fight after taking enough damage...
				break;
			}
			
			if(Attackcount%2==1 && Phase==4){ //Summon funny sun enemies if none are there. If there are, reflect a projectile off it
				if(NumNPCsOf(NPC_SUNFRIEND)){
					if(Rand(0,2)!=0){ // 2/3 chance to do something funny
						if(NPCArray[0]->isValid()){
							Ghost_Data = HorizonCombo[ATKCOMBO1];
							HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE+2;
							HorizonArray[_MANUALCOLORCHANGE]=1;
							for(int frames=0; frames<48 && NPCArray[0]->isValid(); ++frames){
								if(frames%2==0)Screen->D[D_HORIZON_FX] = Choose(C_WHITE, Rand(C_GOLD1-3, C_GOLD2-3), Rand(C_GOLD1, C_GOLD2));
								if(frames%6==0)Game->PlaySound(SFX_HORIZONLASER);
								Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, CenterX(NPCArray[0]), CenterY(NPCArray[0])-NPCArray[0]->Z));
								TAngle = Angle(Ghost_X+8, Ghost_Y+24, CenterX(NPCArray[0]), CenterY(NPCArray[0]));
								
								
								DrawThickLine(3, Ghost_X+8, Ghost_Y+24, CenterX(NPCArray[0]), CenterY(NPCArray[0])-NPCArray[0]->Z, 2, Screen->D[D_HORIZON_FX], true, OP_OPAQUE);
								Screen->Circle(3, Ghost_X+8, Ghost_Y+24, 4+Rand(-1,1), Screen->D[D_HORIZON_FX], 1, 0, 0, 0, true, OP_OPAQUE);
								Screen->Circle(3,  CenterX(NPCArray[0]), CenterY(NPCArray[0])-NPCArray[0]->Z, 4+Rand(-1,1), Screen->D[D_HORIZON_FX], 1, 0, 0, 0, true, OP_OPAQUE);
								
								if(frames%16==15){ //Pew
									int TAngle2 = Angle(NPCArray[0]->X,  NPCArray[0]->Y-NPCArray[0]->Z, Link->X, Link->Y)+Rand(-15,15);
									TX = NPCArray[0]->X-16+VectorX(30, TAngle2);
									TY = NPCArray[0]->Y-NPCArray[0]->Z+VectorY(30, TAngle2);
									eweapon e = FireBigEWeapon(EW_SOLAR, TX, TY, DegtoRad(TAngle2), 600, ghost->WeaponDamage, SPR_HORIZONSHOT3X1, 0, EWF_UNBLOCKABLE, 3, 1);
									e->CollDetection = false;
									e->DrawYOffset = -1000;
									RunEWeaponScript(e, "HorizonPortalShot", {0});
								}
								HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
							}
							HorizonArray[_MANUALCOLORCHANGE]=0;
							Ghost_Data = HorizonCombo[BASECOMBO];
							HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
						}
					}
				}
				else{ //If no sun friends are around, lets make some!
					TAngle = Angle(Link->X, Link->Y, Ghost_X, Ghost_Y+16);
					TX = Ghost_X+VectorX(70, TAngle);
					TY = Ghost_Y+VectorY(70, TAngle);
					Game->PlaySound(SFX_SUMMON);
					NPCArray[0]=CreateNPCAt(NPC_SUNFRIEND, TX, TY);
					NPCArray[0]->ItemSet=ITEMSET_HEART;
					//Ghost_SpawnAnimationPuff(this, NPCArray[0]);
				}
			}
			else{
				for(int i=0; i<36; ++i){ //Delay after base attacks
					Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
				}
			}
			
		}
		if(BossType==2){ //End the fight here on the lowest difficulty
			
			//CHASE CUTSCENE #1
			EndingHandler(this, ghost);
			
		}
		else{ //Giga shockwave
			Ghost_Data = HorizonCombo[HOLDUPCOMBO]; //Clear a 3 mile radius to survive this shockwave!
			HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER; //Unfortunately that's not possible in ZC, so...
			
			int Radius = 0;
			for(int frames=0; frames<450; ++frames){
				int RandFactor=Rand(0,3);
				if(frames>350)RandFactor=Rand(0,1);
				if(frames<=60){
					if(HorizonArray[_HALOXOFFSET]>-4 && frames%15==0)HorizonArray[_HALOXOFFSET]--;
					else if(HorizonArray[_HALOYOFFSET] >-4 && frames%15==2)HorizonArray[_HALOYOFFSET]--;
				}
				else{
					HorizonArray[_HALOXOFFSET] = -4-Rand(-1,1);
					HorizonArray[_HALOYOFFSET] = -4-Rand(RandFactor*-1, RandFactor);
				}
				
				if(frames%48==0){
					if(frames<180){
						Game->PlaySound(35);
						if(frames>60)Screen->Quake=Rand(32,48)*.5;
					}
					else if(frames<360){
						Game->PlaySound(36);
						Screen->Quake=Rand(32,48);
					}
					else{
						Game->PlaySound(SFX_HORIZONBEEGRUMBLE);
						Screen->Quake=Rand(32,48)*1.5;
					}
				}
				if(frames==150){
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_BRIGHT;
				}
				else if(frames==300){
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_YEET;
				}
				if(Radius<6 && frames%16==0 && frames<300)Radius++;
				else if(frames>350 && frames%16==0 && Radius>3)Radius--;
				TX = Ghost_X+4;
				TY = Ghost_Y+13;
				int OP;
				if(frames>200){
					OP = Choose(OP_OPAQUE, OP_TRANS);
					if(frames>400)OP=OP_OPAQUE;
					for(int g=0; g<4; ++g){
						DrawLaser(3, TX, TY, 1+RandFactor, frames*15+90*g, C_WHITE, OP);
					}
				}
				
				Screen->Circle(3, TX, TY, 1+Radius+RandFactor, Screen->D[D_HORIZON_FX], 1, 0, 0, 0, true, OP_OPAQUE);
				
				if(frames>420){
					OP=OP_TRANS;
					if(frames>440) OP=OP_OPAQUE;
					Screen->Rectangle(5, -16, -16, 255+32, 175+32, C_WHITE, 1, 0, 0, 0, true, OP);
				}
				
				HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
			}
			ghost->CollDetection=false;
			HorizonArray[_BURNCOUNTER_ASHER]=0;
			HorizonArray[_BURNCOUNTER_TORRIN]=0;
			HorizonArray[_BURNCOUNTER_KAYLANI]=0;
			ClearEWeapons();
			ClearSuns();
			Game->PlayMIDI(0);
			
			mapdata l1 = Game->LoadTempScreen(1); //Current screen
			mapdata refl1 = Game->LoadMapData(Game->GetCurMap()+1, HORIZON_SCREEN_MELTED);
			mapdata refl0 = Game->LoadMapData(Game->GetCurMap(), HORIZON_SCREEN_MELTED);
			for(int i=0; i<176; ++i){
				l1->ComboD[i] = refl1->ComboD[i];
				l1->ComboC[i] = refl1->ComboC[i];
				Screen->ComboD[i] = refl0->ComboD[i];
				Screen->ComboC[i] = refl0->ComboC[i];
			}
			
			
			switch(GetCharID()){ //I tried to give the character a black silhouette during the whiteout effect but it clearly didn't work
				case CHAR_ASHER: //You can fix it if you like. Give Chase one too if you do.
					linkTiles[0] = 105303;
					linkTiles[1] = 105306;
					break;
				case CHAR_TORRIN:
					linkTiles[0] = 105304;
					linkTiles[1] = 105308;
					break;
				case CHAR_KAYLANI:
					linkTiles[0] = 105305;
					linkTiles[1] = 105310;
					break;
			}
			// int bitID = TempBitmap_Create(0, 48, 32);
			// int bitID2 = TempBitmap_Create(0, 256, 256);
			bitmap b = Game->CreateBitmap(48, 32); //TempBMP[bitID];
			b->Own();
			bitmap scrn = Game->CreateBitmap(256, 256); //TempBMP[bitID2];
			scrn->Own();
			b->Clear(0);
			b->DrawTile(0, 0, 0, linkTiles[0], 1, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
			b->DrawTile(0, 16, 0, linkTiles[1], 2, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
			b->ReplaceColors(0, 0x0F, 0x01, 0xBF);
			
			for(int frames=0; frames<80; ++frames){
				NoAction();
				Screen->Rectangle(5, -16, -16, 255+32, 175+32, C_WHITE, 1, 0, 0, 0, true, OP_OPAQUE);
				scrn->DrawTile(5, Link->X, Link->Y-16, linkTiles[0], 1, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
				//b->Blit(5, scrn, 0, 0, 16, 32, anchorX, anchorY-16, 16, 32, 0, 0, 0, BITDX_TRANS, 0, true);
				
				HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
			}
			Game->PlaySound(SFX_HORIZONGIGASHOCKWAVE);
			HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER;
			
			HorizonArray[_HALOXOFFSET]=0;
			HorizonArray[_HALOYOFFSET]=0;
			
			for(int frames=0; frames<120; ++frames){ //Stand back, I'm about to morb!!!
				NoAction();
				int Color=C_WHITE;
				if(frames>12)Color = Screen->D[D_HORIZON_FX];
				Screen->Rectangle(5, -16, -16, 255+32, 175+32, Color, 1, 0, 0, 0, true, OP_OPAQUE);
				scrn->DrawTile(5, Link->X, Link->Y-16, linkTiles[0], 1, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
				//b->Blit(5, scrn, 0, 0, 16, 32, anchorX, anchorY-16, 16, 32, 0, 0, 0, BITDX_TRANS, 0, true);
				
				if(frames<60)DrawEnergyRing(5, TX+Rand(-1,1), TY+Rand(-1,1), frames*8, frames*6+Rand(0,16), Min(frames*2, 36), C_BLACK, 48, Rand(359));
				//DrawEnergyRing(int layer, int cx, int cy, int radius, int thickness, int variance, int c, int points, int angle)
				if(frames>20 && frames<30){
					TAngle = Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y);
					LinkMovement_Push2(VectorX(8, TAngle), VectorY(8, TAngle));
					Link->HitDir=-1;
				}
				if(frames==30){
					Game->PlaySound(19);
					//Damage number
					DamageNumbers_AddNumberGFX(CenterLinkX(), CenterLinkY()-DAMAGENUMBERS_HEIGHT/2, _DNUM_TYPE_LINKDAMAGE, DMG_SHOCKWAVESUPER);
				}
				if(frames>30){
					G[G_DRAWNHPZERO]=1;
				}
				HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
			}
			ApplyActuallyDead(); //Not tired, not fainted. Actually dead for real
			Screen->Quake=40;
			
			HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
			if(Form==1)Form=2;
			for(int i=0; i<16; ++i){
				NoAction();
				Screen->Rectangle(5, -16, -16, 255+32, 175+32, C_WHITE, 1, 0, 0, 0, true, OP_TRANS);
				HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
			}
			Game->PlayEnhancedMusic("SS-LightingTheHeavens.ogg", 0);
		}
		ghost->HP = 30000;
		Ghost_HP = 30000;
		ghost->Misc[NPCM_DAMAGENUMBERSLASTHP] = ghost->HP;
		Ghost_Data = HorizonCombo[BASECOMBO];
		ghost->CollDetection=true;
		Phase=1;
		MinAttackchoice=0;
		MaxAttackchoice=4;
		LastAttack=-1;
		Attackcount=0;
		
		RNGFlush();
		
		G[G_HORIZONCURRENTFORM] = 1;
		while(Form==2){ //Second Form
			for(int i=0; i<64; ++i){
				if(Ghost_GotHit())i+=24;
				Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
				HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
			}
			
			if(Phase==1 && Ghost_HP<= MaxHP-HORIZON_SECONDHP/3){
				Phase=2; 
			}
			else if(Phase==3 && Ghost_HP<= MaxHP-HORIZON_SECONDHP/3*2){
				Phase=4; 
			}
			else if(Phase==5 && Ghost_HP<= MaxHP-HORIZON_SECONDHP){
				break;
			}
			
			
			if(Phase!=2 && Phase!=4){ //No super attacks queued, start the sub-attack routines
				switch(Attackcount%4){ //No RNG here, officer
					case 0:{ //Lazychase surfing!
						Ghost_Data = HorizonCombo[BASECOMBO];
						HorizonArray[_SURFBOARD]=1;
						for(int frames=0; frames<240; ++frames){
							Ghost_Vx=LazyChase(Ghost_Vx, Ghost_X, Link->X, 0.06, 1.6);
							Ghost_Vy=LazyChase(Ghost_Vy, Ghost_Y+16, Link->Y, 0.06, 1.6);
							Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y));
							
							if(Phase<5){
								if(frames%60==20){
									Ghost_Data = HorizonCombo[ATKCOMBO1];
									HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE+2;
								}
								else if(frames%60==30){ //Shoot beeg solar sphere
									eweapon e = FireAimedEWeapon(EW_SOLAR, Ghost_X, Ghost_Y+16, DegtoRad(0), 200, ghost->WeaponDamage, 108, SFX_HORIZONSHOT, EWF_UNBLOCKABLE);
									SetEWeaponMovement(e, EWM_HOMING, DegtoRad(.5), -1);
									RunEWeaponScript(e, "HorizonLargeShot", {0});
								}
								else if(frames%60==40){
									Ghost_Data = HorizonCombo[BASECOMBO];
									HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
								}
							}
							else{
								if(frames%14==8 && frames<200 && frames >20){
									if(Ghost_Data == HorizonCombo[ATKCOMBO1])Ghost_Data = HorizonCombo[ATKCOMBO2];
									else Ghost_Data = HorizonCombo[ATKCOMBO1];
									
									HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE+2;
									int g=Rand(0,2);
									eweapon e = FireAimedEWeapon(EW_SOLAR, Ghost_X+InFrontX(Ghost_Dir, 8), Ghost_Y+16+InFrontY(Ghost_Dir,8), DegtoRad(Rand(359)), 125+50*g, ghost->WeaponDamage, 108, 0, EWF_UNBLOCKABLE);
									e->CollDetection = false;
									e->DrawYOffset = -1000;
									e->Misc[HSS_MAXRADIUS]=42;
									e->Misc[HSS_WANDERTIME]=48;
									e->Misc[HSS_SHOTDELAY]=24;
									e->Misc[HSS_MAXVEER]=45+15*g;
									e->Misc[HSS_STEPDECAY]=5+5*g;
									RunEWeaponScript(e, "HorizonSwarmSphere", {0});
									
								}
							}
							Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
						}
						Ghost_Vx=0; Ghost_Vy=0;
						HorizonArray[_SURFBOARD]=0;
						HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
						break;
					}
					case 1:{ //Summon suns
						if(!NPCArray[0]->isValid()){
							TAngle = Angle(Link->X, Link->Y, 120, 88)+Rand(15,40);
							TX = 120+VectorX(70, TAngle);
							TY = 88+VectorY(70, TAngle);
							Game->PlaySound(SFX_SUMMON);
							NPCArray[0]=CreateNPCAt(NPC_SUNFRIEND, TX, TY);
							NPCArray[0]->ItemSet=ITEMSET_HEART;
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 12);
						}
						if(!NPCArray[1]->isValid()){
							TAngle = Angle(Link->X, Link->Y, 120, 88)-Rand(15,40);
							TX = 120+VectorX(70, TAngle);
							TY = 88+VectorY(70, TAngle);
							Game->PlaySound(SFX_SUMMON);
							NPCArray[1]=CreateNPCAt(NPC_SUNFRIEND, TX, TY);
							NPCArray[1]->ItemSet=ITEMSET_MAGIC;
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 12);
						}	
						break;
					}
					case 2:{ //Reposition teleport
						do{
							TX= Rand(56, 192);
							TY= Rand(48, 120)-16;
						}while(Distance(Ghost_X, Ghost_Y, TX, TY)<48);
						
						TAngle = Angle(Ghost_X, Ghost_Y, TX, TY);
						Ghost_Data = HorizonCombo[TELECOMBO];
						Game->PlaySound(SFX_HORIZONTELEPORT);
						ghost->CollDetection=false;
						while(Distance(Ghost_X, Ghost_Y, TX, TY)>3){
							TAngle = Angle(Ghost_X, Ghost_Y, TX, TY);
							Ghost_MoveAtAngle(TAngle, 2, 2);
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
						}
						Ghost_X=TX; Ghost_Y=TY;
						ghost->CollDetection=true;
						Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
						if(Phase>4){ //Salty surprise later in the fight
							Ghost_Data = HorizonCombo[ATKCOMBO1];
							HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE+2;
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 12);
							eweapon e = FireAimedEWeapon(EW_SOLAR, Ghost_X, Ghost_Y+16, DegtoRad(0), 200, ghost->WeaponDamage, 108, SFX_HORIZONSHOT, EWF_UNBLOCKABLE);
							SetEWeaponMovement(e, EWM_HOMING, DegtoRad(.5), -1);
							RunEWeaponScript(e, "HorizonLargeShot", {0});
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 24);
							
							HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
						}
						Ghost_Data = HorizonCombo[BASECOMBO];
						
						break;
					}
					case 3:{ //Attack with suns
						if(NPCArray[0]->isValid() || NPCArray[1]->isValid()){
							Ghost_Data = HorizonCombo[ATKCOMBO1];
							HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER;
							HorizonArray[_MANUALCOLORCHANGE]=1;
							for(int frames=0; frames<130 && (NPCArray[0]->isValid() || NPCArray[1]->isValid()); ++frames){
								if(frames%2==0)Screen->D[D_HORIZON_FX] = Choose(C_WHITE, Rand(C_GOLD1-3, C_GOLD2-3), Rand(C_GOLD1, C_GOLD2));
								if(NPCArray[0]->isValid() && frames<26){
									Ghost_Data = HorizonCombo[ATKCOMBO1];
									if(frames%6==0)Game->PlaySound(SFX_HORIZONLASER);
									Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, CenterX(NPCArray[0]), CenterY(NPCArray[0])-4));
									TAngle = Angle(Ghost_X+8, Ghost_Y+24, CenterX(NPCArray[0]), CenterY(NPCArray[0]));
									
									
									DrawThickLine(3, Ghost_X+8, Ghost_Y+24, CenterX(NPCArray[0]), CenterY(NPCArray[0])-4, 2, Screen->D[D_HORIZON_FX], true, OP_OPAQUE);
									Screen->Circle(3, Ghost_X+8, Ghost_Y+24, 4+Rand(-1,1), Screen->D[D_HORIZON_FX], 1, 0, 0, 0, true, OP_OPAQUE);
									Screen->Circle(3,  CenterX(NPCArray[0]), CenterY(NPCArray[0])-4, 4+Rand(-1,1), Screen->D[D_HORIZON_FX], 1, 0, 0, 0, true, OP_OPAQUE);
									NPCArray[0]->Misc[NPCM_SITSTILLYOULITTLEFUCK] = 1;
									
									if(frames==25){ //Pew
										TX = CenterX(NPCArray[0])-8;
										TY = CenterY(NPCArray[0])-12;
										eweapon e = FireAimedEWeapon(EW_SOLAR, Clamp(TX,0,240),Clamp(TY,0,160) , DegtoRad(0), 0, ghost->WeaponDamage, 108, 0, EWF_UNBLOCKABLE);
										e->CollDetection = false;
										e->DrawYOffset = -1000;
										e->Misc[HL_WIDTH]=16;
										e->Misc[HL_STARTTIME]=48+45;
										e->Misc[HL_DURATION]=64;
										e->Misc[HL_LINETELEGRAPH]=1;
										e->Misc[HL_ROTOFFSET]=.5;
										e->Misc[HL_AUTOTRACK]=1;
										RunEWeaponScript(e, "HorizonLaser", {0});
									}
								}
								if(NPCArray[1]->isValid() && frames>46 && frames<71){
									Ghost_Data = HorizonCombo[ATKCOMBO1];
									if(frames%6==0)Game->PlaySound(SFX_HORIZONLASER);
									Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, CenterX(NPCArray[1]), CenterY(NPCArray[1])-4));
									TAngle = Angle(Ghost_X+8, Ghost_Y+24, CenterX(NPCArray[1]), CenterY(NPCArray[1]));
									
									DrawThickLine(3, Ghost_X+8, Ghost_Y+24, CenterX(NPCArray[1]), CenterY(NPCArray[1])-4, 2, Screen->D[D_HORIZON_FX], true, OP_OPAQUE);
									Screen->Circle(3, Ghost_X+8, Ghost_Y+24, 4+Rand(-1,1), Screen->D[D_HORIZON_FX], 1, 0, 0, 0, true, OP_OPAQUE);
									Screen->Circle(3,  CenterX(NPCArray[1]), CenterY(NPCArray[1])-4, 4+Rand(-1,1), Screen->D[D_HORIZON_FX], 1, 0, 0, 0, true, OP_OPAQUE);
									NPCArray[1]->Misc[NPCM_SITSTILLYOULITTLEFUCK] = 1;
									
									if(frames==70){ //Pew
										TX = CenterX(NPCArray[1])-8;
										TY = CenterY(NPCArray[1])-12;
										eweapon e = FireAimedEWeapon(EW_SOLAR, Clamp(TX,0,240),Clamp(TY,0,160), DegtoRad(0), 0, ghost->WeaponDamage, 108, 0, EWF_UNBLOCKABLE);
										e->CollDetection = false;
										e->DrawYOffset = -1000;
										e->Misc[HL_WIDTH]=16;
										e->Misc[HL_STARTTIME]=48;
										e->Misc[HL_DURATION]=64;
										e->Misc[HL_LINETELEGRAPH]=1;
										e->Misc[HL_ROTOFFSET]=.5;
										e->Misc[HL_AUTOTRACK]=1;
										RunEWeaponScript(e, "HorizonLaser", {0});
									}
								}
								else{
									Ghost_Data = HorizonCombo[BASECOMBO];
									Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
								}
								
								HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
							}
							HorizonArray[_MANUALCOLORCHANGE]=0;
							Ghost_Data = HorizonCombo[BASECOMBO];
							HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 32);
							if(NPCArray[0]->isValid()){
								NPCArray[0]->Misc[NPCM_SITSTILLYOULITTLEFUCK] = 0;
							}
							if(NPCArray[1]->isValid()){
								NPCArray[1]->Misc[NPCM_SITSTILLYOULITTLEFUCK] = 0;
							}
							
						}
						break;
					}	
				}
			}
			
			if(Phase==1 && Ghost_HP<= MaxHP-HORIZON_SECONDHP/3){
				Phase=2; 
			}
			else if(Phase==3 && Ghost_HP<= MaxHP-HORIZON_SECONDHP/3*2){
				Phase=4; 
			}
			else if(Phase==5 && Ghost_HP<= MaxHP-HORIZON_SECONDHP){
				break;
			}
			
			
			Attackchoice = Rand(MinAttackchoice, MaxAttackchoice);
			while(Attackchoice==LastAttack){
				Attackchoice = Rand(MinAttackchoice, MaxAttackchoice);
			}
			LastAttack = Attackchoice;
			
			
			
			Ghost_Data=HorizonCombo[ATKCOMBO1];
			HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 32);
			
			if(Phase==1 && Ghost_HP<= MaxHP-HORIZON_SECONDHP/3){
				Phase=2; 
			}
			else if(Phase==3 && Ghost_HP<= MaxHP-HORIZON_SECONDHP/3*2){
				Phase=4; 
			}
			else if(Phase==5 && Ghost_HP<= MaxHP-HORIZON_SECONDHP){
				break;
			}
			if(Phase==2)Attackchoice=100;
			else if(Phase==4)Attackchoice=101;
			
			switch(Attackchoice){
				case 0:{ //Repeated aimed small beams
					for(int Cycles=0; Cycles<3; Cycles++){
						do{
							TX= Rand(56, 192);
							TY= Rand(48, 120)-16;
						}while(Distance(Ghost_X, Ghost_Y, TX, TY)<48);
						
						TAngle = Angle(Ghost_X, Ghost_Y, TX, TY);
						Ghost_Data = HorizonCombo[TELECOMBO];
						Game->PlaySound(SFX_HORIZONTELEPORT);
						ghost->CollDetection=false;
						while(Distance(Ghost_X, Ghost_Y, TX, TY)>3){
							TAngle = Angle(Ghost_X, Ghost_Y, TX, TY);
							Ghost_MoveAtAngle(TAngle, 2, 2);
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
						}
						Ghost_X=TX; Ghost_Y=TY;
						ghost->CollDetection=true;
						Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
						HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER;
						Ghost_Data=HorizonCombo[ATKCOMBO1];
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 12);
						
						eweapon e = FireAimedEWeapon(EW_SOLAR, TX+InFrontX(Ghost_Dir, 8), TY+16+InFrontY(Ghost_Dir,8), DegtoRad(0), 0, ghost->WeaponDamage, 108, 0, EWF_UNBLOCKABLE);
						e->CollDetection = false;
						e->DrawYOffset = -1000;
						e->Misc[HL_WIDTH]=24;
						e->Misc[HL_STARTTIME]=32;
						e->Misc[HL_DURATION]=108;
						RunEWeaponScript(e, "HorizonLaser", {0});
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 24);
						e->Misc[HL_LINETELEGRAPH]=1;
						
						Ghost_Data = HorizonCombo[BASECOMBO];
					}
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
					Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 32);
					break;
				}
				case 1:{ //Sit still lmao
					TAngle = Angle(Link->X, Link->Y, 120, 88);
					TX = 120+VectorX(32, TAngle);
					TY = 88-16+VectorY(32, TAngle);
					Ghost_Data = HorizonCombo[TELECOMBO];
					Game->PlaySound(SFX_HORIZONTELEPORT);
					ghost->CollDetection=false;
					while(Distance(Ghost_X, Ghost_Y, TX, TY)>3){
						TAngle = Angle(Ghost_X, Ghost_Y, TX, TY);
						Ghost_MoveAtAngle(TAngle, 2, 2);
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					Ghost_X=TX; Ghost_Y=TY;
					ghost->CollDetection=true;
					Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 30);
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER;
					Ghost_Data=HorizonCombo[ATKCOMBO1];
					for(int i=0; i<=1; ++i){
						TAngle = Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8);
						Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
						TX = Ghost_X+VectorX(24, TAngle+90+180*i);
						TY = Ghost_Y+16+VectorY(24, TAngle+90+180*i);
						EArray[i] = FireEWeapon(EW_SOLAR, TX, TY, DegtoRad(TAngle), 0, ghost->Damage, 108, 0, EWF_UNBLOCKABLE);
						EArray[i]->CollDetection = false;
						EArray[i]->DrawYOffset = -1000;
						EArray[i]->Misc[HL_WIDTH]=48;
						EArray[i]->Misc[HL_STARTTIME]=48;
						EArray[i]->Misc[HL_DURATION]=64;
						EArray[i]->Misc[HL_ROTOFFSET]=1.5+i*-3;
						RunEWeaponScript(EArray[i], "HorizonLaser", {0});
					}
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 24);
					Ghost_Data = HorizonCombo[BASECOMBO];
					if(EArray[0]->isValid())EArray[0]->Misc[HL_LINETELEGRAPH]=1;
					if(EArray[1]->isValid())EArray[1]->Misc[HL_LINETELEGRAPH]=1;
					for(int i=0; i<120; ++i){
						if(i>30){
							if(EArray[0]->isValid())EArray[0]->Angle+=DegtoRad(EArray[0]->Misc[HL_ROTOFFSET]);
							if(EArray[1]->isValid())EArray[1]->Angle+=DegtoRad(EArray[1]->Misc[HL_ROTOFFSET]);
						}
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
					Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
					
					break;
				}
				case 2:{ //Bullet flower
					int Choice=Choose(-1,1);
					TAngle=Rand(1,360);
					Ghost_Data = HorizonCombo[WALKINGCOMBO];
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER;
					for(int i=0; i<32; ++i){
						Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
						Ghost_MoveTowardLink(.75,1);
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 1);
					}
					Ghost_Data = HorizonCombo[ATKCOMBO1];
					
					for(int shots=0; shots<8; shots++){
						for(int i=1; i<=6; i++){
							eweapon CircleArc1 = FireEWeapon(EW_SOLAR, Ghost_X, Ghost_Y+16, DegtoRad(60*i+TAngle), 150, ghost->WeaponDamage, SPR_HORIZONSPAZER, SFX_HORIZONSHOT, EWF_UNBLOCKABLE|EWF_ROTATE_360);
							SetEWeaponMovement(CircleArc1, EWM_SINE_WAVE, 4*Choice, -10);
							SetEWeaponLifespan(CircleArc1, EWL_TIMER, 200);
							SetEWeaponDeathEffect(CircleArc1, EWD_VANISH, 0);
							CircleArc1->Misc[0]=-1.15;
							RunEWeaponScript(CircleArc1, "HorizonSpazer", {0});
						
							CircleArc1 = FireEWeapon(EW_SOLAR, Ghost_X, Ghost_Y+16, DegtoRad(60*i-TAngle), 150, ghost->WeaponDamage, SPR_HORIZONSPAZER, SFX_HORIZONSHOT, EWF_UNBLOCKABLE|EWF_ROTATE_360);
							SetEWeaponMovement(CircleArc1, EWM_SINE_WAVE, 4*Choice, 10);
							SetEWeaponLifespan(CircleArc1, EWL_TIMER, 200);
							SetEWeaponDeathEffect(CircleArc1, EWD_VANISH, 0);
							CircleArc1->Misc[0]=1.15;
							RunEWeaponScript(CircleArc1, "HorizonSpazer", {0});
							
						}
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 8);
						Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
					}
					Ghost_Data = HorizonCombo[BASECOMBO];
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 42);
					Ghost_Data = HorizonCombo[WALKINGCOMBO];
					for(int i=0; i<42; ++i){
						Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
						Ghost_MoveTowardLink(.75,1);
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 1);
					}
					Ghost_Data = HorizonCombo[BASECOMBO];
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
					Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 32);
					break;
				}
				case 3:{ //Small solar sphere swarm
					TAngle = Angle(120, 88, Link->X, Link->Y);
					TX = 120+VectorX(32, TAngle);
					TY = 88-16+VectorY(32, TAngle);
					Ghost_Data = HorizonCombo[TELECOMBO];
					Game->PlaySound(SFX_HORIZONTELEPORT);
					ghost->CollDetection=false;
					while(Distance(Ghost_X, Ghost_Y, TX, TY)>3){
						TAngle = Angle(Ghost_X, Ghost_Y, TX, TY);
						Ghost_MoveAtAngle(TAngle, 2, 2);
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					Ghost_X=TX; Ghost_Y=TY;
					ghost->CollDetection=true;
					Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 30);
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE+2;
					Ghost_Data=HorizonCombo[ATKCOMBO1];
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 30);
					for(int i=8; i>=0; --i){
						for(int g=0; g<2; ++g){
							eweapon e = FireAimedEWeapon(EW_SOLAR, Ghost_X+InFrontX(Ghost_Dir, 8), Ghost_Y+16+InFrontY(Ghost_Dir,8), DegtoRad(Rand(359)), 150+150*g, ghost->WeaponDamage, 108, 0, EWF_UNBLOCKABLE);
							e->CollDetection = false;
							e->DrawYOffset = -1000;
							e->Misc[HSS_MAXRADIUS]=42+i*2;
							e->Misc[HSS_WANDERTIME]=20+i*6;
							e->Misc[HSS_SHOTDELAY]=24+i*5;
							e->Misc[HSS_MAXVEER]=45+15*g;
							e->Misc[HSS_STEPDECAY]=5+5*g;
							RunEWeaponScript(e, "HorizonSwarmSphere", {0});
						}
						
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 6);
					}
					Ghost_Data = HorizonCombo[BASECOMBO];
					Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 48);
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 32);
					break;
				}
				case 4:{ //Laser Hand
					Ghost_Data=HorizonCombo[WALKINGCOMBO];
					int AttackAngle;
					for(int i=0; i<30; i++){
						AttackAngle = Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y);
						Ghost_MoveAtAngle(AttackAngle+180, .75, 2);
						Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y));
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 1);
					}
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER;
					Ghost_Data=HorizonCombo[ATKCOMBO1];
					for(int i=-3; i<=3; ++i){
						TAngle = AttackAngle+i*30;
						TX = Ghost_X+VectorX(12, TAngle);
						TY = Ghost_Y+16+VectorY(12, TAngle);
						
						eweapon e = FireEWeapon(EW_SOLAR, TX+InFrontX(Ghost_Dir, 8), TY+InFrontY(Ghost_Dir,8), DegtoRad(TAngle), 0, ghost->WeaponDamage, 108, 0, EWF_UNBLOCKABLE);
						e->CollDetection = false;
						e->DrawYOffset = -1000;
						e->Misc[HL_WIDTH]=24;
						e->Misc[HL_STARTTIME]=32;
						e->Misc[HL_DURATION]=64;
						e->Misc[HL_LINETELEGRAPH]=1;
						RunEWeaponScript(e, "HorizonLaser", {0});
						
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 4);
					}
					Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y));
					Ghost_Data=HorizonCombo[BASECOMBO];
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 60);
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 12);
					break;
				}
				case 5:{ //Rotating beams around the boss
					Ghost_Data=HorizonCombo[WALKINGCOMBO];
					for(int i=0; i<30; i++){
						int AttackAngle = Angle(Ghost_X, Ghost_Y+16, 120, 88);
						Ghost_MoveAtAngle(AttackAngle, .75, 2);
						Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y));
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 1);
					}
					Ghost_Data = HorizonCombo[ATKCOMBO1];
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER;
					Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
					int Length = 4;
					TAngle=Rand(359);
					int TAngle2;
					for(int i=0; i<3; ++i){
						TAngle2 = TAngle+i*120;
						TX=Ghost_X+VectorX(Length, TAngle2);
						TY=Ghost_Y+16+VectorY(Length, TAngle2);
						
						eweapon e = FireEWeapon(EW_SOLAR, TX, TY, DegtoRad(TAngle2), 0, ghost->Damage, 108, 0, EWF_UNBLOCKABLE);
						e->CollDetection = false;
						e->DrawYOffset = -1000;
						e->Misc[HL_LINETELEGRAPH]=0;
						e->Misc[HL_WIDTH]=48;
						e->Misc[HL_STARTTIME]=120;
						e->Misc[HL_DURATION]=84;
						e->Misc[HL_ROTOFFSET]=2;
						EArray[i]=e;
						RunEWeaponScript(e, "HorizonLaser", {0});
					}
					
					for(int frames=0; frames<200; ++frames){
						Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
						if(frames==30)Ghost_Data = HorizonCombo[BASECOMBO];
						if(Length<48 && frames%3==0)Length++;
						for(int i=0; i<3; ++i){
							if(EArray[i]->isValid()){
								EArray[i]->Angle+=DegtoRad(EArray[i]->Misc[HL_ROTOFFSET]);
								TAngle2 = RadtoDeg(EArray[i]->Angle);
								TX=Ghost_X+VectorX(Length, TAngle2);
								TY=Ghost_Y+16+VectorY(Length, TAngle2);
								EArray[i]->X=TX;
								EArray[i]->Y=TY;
								if(frames==80)EArray[i]->Misc[HL_LINETELEGRAPH]=1;
								if(EArray[i]->Misc[HL_STARTTIME]==0)EArray[i]->Misc[HL_ROTOFFSET]=4.5;
								
							}
						}
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 1);
					}
					Ghost_Data = HorizonCombo[BASECOMBO];
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
					Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 10);
					if(Phase==5 && Distance(Link->X+8, Link->Y+8, Ghost_X+8, Ghost_Y+24)<=48){ //Anti-hug shockwave. Again.
						Ghost_Data = HorizonCombo[HOLDUPCOMBO];
						HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER;
						Game->PlaySound(35);
						for(int frames=0; frames<32; ++frames){
							TX = Ghost_X+4;
							TY = Ghost_Y+13;
							Screen->Circle(3, TX, TY, 1+frames/5+Rand(0,6), Screen->D[D_HORIZON_FX], 1, 0, 0, 0, true, OP_OPAQUE);
							
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
						}
						
						Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
						Game->PlaySound(37);
						bool push=false;
						Screen->Quake=32;
						for(int frames=0; frames<16; ++frames){
							DrawEnergyRing(4, TX+Rand(-1,1), TY+Rand(-1,1), frames*4, frames/2, frames/2, Screen->D[D_HORIZON_FX], 24, Rand(359));
							if(Distance(Ghost_X, Ghost_Y+16, Link->X, Link->Y)<=(frames*4)){
								DamageLinkSolar(ghost->Damage);
								push=true;
							}
							if(push){
								TAngle = Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y);
								LinkMovement_Push2(VectorX(4, TAngle), VectorY(4, TAngle));
								Link->HitDir=-1;
								NoAction();
							}
							
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
						}
						HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
						Ghost_Data = HorizonCombo[BASECOMBO];
						if(push){
							Screen->Quake=16;
							for(int i=0; i<8; ++i){
								TAngle = Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y);
								LinkMovement_Push2(VectorX(3, TAngle), VectorY(3, TAngle));
								Link->HitDir=-1;
								NoAction();
								HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
							}
							Game->PlaySound(67);
						}
					}
					
					break;
				}
				case 6:{ //Barrages of longshots
					TAngle = Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y);
					Ghost_Data=HorizonCombo[WALKINGCOMBO];
					int LastGap=-1;
					for(int i=0; i<30; i++){
						TAngle  = Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y);
						Ghost_MoveAtAngle(TAngle+180, .75, 2);
						Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y));
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 1);
					}
					TAngle = Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8);
					int Intervals = 4;
					if(Phase==5)Intervals=5;
					for(int g=0; g<Intervals; ++g){
						Ghost_Data = HorizonCombo[ATKCOMBO1];
						if(g%2==1)Ghost_Data = HorizonCombo[ATKCOMBO2];
						
						TAngle = Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8);
						Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y));
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 30);
						int Gap=Choose(-24,0,24);
						while(Gap==LastGap)Gap=Choose(-24,0,24);
						LastGap=Gap;
						for(int i=-48; i<=48; i+=24){
							if(i==Gap)continue;
							int FX = Ghost_X-16+VectorX(28, TAngle);
							int FY = Ghost_Y+16+VectorY(28, TAngle);
							TX = FX+VectorX(i, TAngle+90);
							TY = FY+VectorY(i, TAngle+90);
							
							int Offset=0;
							if(Phase==5 && g%2==1)Offset=i/2;
							
							eweapon e = FireBigEWeapon(EW_SOLAR, TX, TY, DegtoRad(TAngle+Offset), 600, ghost->WeaponDamage, SPR_HORIZONSHOT3X1, 0, EWF_UNBLOCKABLE, 3, 1);
							e->CollDetection = false;
							e->DrawYOffset = -1000;
							e->Misc[0]=28;
							RunEWeaponScript(e, "HorizonPortalShot", {0});
						}
						Ghost_Dir=AngleDir4(TAngle);
						HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE+2;
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 30);
						HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
						Ghost_Data = HorizonCombo[BASECOMBO];
						for(int i=0; i<30; i++){
							TAngle  = Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y);
							Ghost_MoveAtAngle(TAngle+180, .75, 2);
							Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y));
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 1);
						}
						Ghost_Dir=AngleDir4(TAngle);
					}
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 48);
					break;
				}
				case 7:{ //Everyone's favorite lattice
					int TX = 32;
					if(Link->X<120)TX = 208;
					TY = 88-16;
					Ghost_Data = HorizonCombo[TELECOMBO];
					Game->PlaySound(SFX_HORIZONTELEPORT);
					ghost->CollDetection=false;
					while(Distance(Ghost_X, Ghost_Y, TX, TY)>3){
						TAngle = Angle(Ghost_X, Ghost_Y, TX, TY);
						Ghost_MoveAtAngle(TAngle, 2, 2);
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					Ghost_X=TX; Ghost_Y=TY;
					ghost->CollDetection=true;
					TAngle = Angle(Ghost_X, Ghost_Y+16, 120, 88);
					Ghost_Dir=AngleDir4(TAngle);
					Ghost_Data=HorizonCombo[ATKCOMBO2];
					int LAngle1 = TAngle+45;
					int LAngle2 = TAngle-45;
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER;
					for(int i=0; i<128; i+=24){
						TX = Ghost_X+VectorX(i, LAngle1);
						TY = Ghost_Y+16+VectorY(i, LAngle1);
						
						eweapon e = FireEWeapon(EW_SOLAR, TX, TY, DegtoRad(LAngle1-90), 0, ghost->WeaponDamage, 108, 0, EWF_UNBLOCKABLE);
						e->CollDetection = false;
						e->DrawYOffset = -1000;
						e->Misc[HL_LINETELEGRAPH]=1;
						e->Misc[HL_WIDTH]=16;
						e->Misc[HL_STARTTIME]=32+i/4;
						e->Misc[HL_DURATION]=72;
						RunEWeaponScript(e, "HorizonLaser", {0});
						
						TX = Ghost_X+VectorX(i, LAngle2);
						TY = Ghost_Y+16+VectorY(i, LAngle2);
						
						e = FireEWeapon(EW_SOLAR, TX, TY, DegtoRad(LAngle2+90), 0, ghost->WeaponDamage, 108, 0, EWF_UNBLOCKABLE);
						e->CollDetection = false;
						e->DrawYOffset = -1000;
						e->Misc[HL_LINETELEGRAPH]=1;
						e->Misc[HL_WIDTH]=16;
						e->Misc[HL_STARTTIME]=32+i/4;
						e->Misc[HL_DURATION]=72;
						RunEWeaponScript(e, "HorizonLaser", {0});
						
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 8);
					}
					TX = 240-Ghost_X;
					TY = Ghost_Y+16;
					if(TX<120)TX-=24;
					else TX+=24;
					if(true){ //I was initially going to have this be an escalation at lower health, but I don't think conditionally rewarding the easy safe spot inconsistently is a good idea, in hindsight
						eweapon e = FireEWeapon(EW_SOLAR, TX, TY, DegtoRad(TAngle+180-45), 0, ghost->Damage, 108, 0, EWF_UNBLOCKABLE);
						e->CollDetection = false;
						e->DrawYOffset = -1000;
						e->Misc[HL_LINETELEGRAPH]=1;
						e->Misc[HL_WIDTH]=48;
						e->Misc[HL_STARTTIME]=48;
						e->Misc[HL_DURATION]=64;
						RunEWeaponScript(e, "HorizonLaser", {0});
						
						e = FireEWeapon(EW_SOLAR, TX, TY, DegtoRad(TAngle+180+45), 0, ghost->Damage, 108, 0, EWF_UNBLOCKABLE);
						e->CollDetection = false;
						e->DrawYOffset = -1000;
						e->Misc[HL_LINETELEGRAPH]=1;
						e->Misc[HL_WIDTH]=48;
						e->Misc[HL_STARTTIME]=48;
						e->Misc[HL_DURATION]=64;
						RunEWeaponScript(e, "HorizonLaser", {0});
					}
					Ghost_Data=HorizonCombo[BASECOMBO];
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 64);
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 32);
					
					break;
				}
				
				case 100:{ //Purging Thorn Super
					Phase=3;
					Ghost_HP=MaxHP-HORIZON_SECONDHP/3;
					ghost->HP = Ghost_HP;
					ghost->Misc[NPCM_DAMAGENUMBERSLASTHP] = ghost->HP;
					MaxAttackchoice=6;
					SodOffSuns(NPCArray);
					
					Ghost_SetFlag(GHF_IGNORE_ALL_TERRAIN);
					TX=120; TY=0;
					Ghost_Data = HorizonCombo[TELECOMBO];
					Game->PlaySound(SFX_HORIZONTELEPORT);
					ghost->CollDetection=false;
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_BRIGHT;
					while(Distance(Ghost_X, Ghost_Y, TX, TY)>3){
						TAngle = Angle(Ghost_X, Ghost_Y, TX, TY);
						Ghost_MoveAtAngle(TAngle, 2, 2);
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					Ghost_X=TX; Ghost_Y=TY;
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 48);
					
					int SpawnX[12] = {232, 8, 16, 224, 24, 216, 192, 48, 80, 160, 136, 104};
					int SpawnY[12] = {72, 72, 40, 40, 16, 16, 8, 8, 5, 5, 2, 2};
					int SpawnFlag[12];
					for(int Volleys=0; Volleys<3; ++Volleys){
						for(int i=0; i<12; ++i){
							int Choice = Rand(0,11);
							if(SpawnFlag[Choice]){
								i--;
								continue;
							}
							SpawnFlag[Choice]=1;
							
							eweapon e = FireAimedEWeapon(EW_SOLAR, SpawnX[Choice], SpawnY[Choice], DegtoRad(0), 0, ghost->Damage, 108, 0, EWF_UNBLOCKABLE);
							e->CollDetection = false;
							e->DrawYOffset = -1000;
							e->Misc[HPT_MODE] = 1;
							e->Misc[HPT_FIRINGDELAY] = 72+(12-i)*4;
							if(i%4==1){
								e->Misc[HPT_FIRINGDELAY]+=8*i;
								e->Misc[HPT_AUTOTRACK]=1 + Volleys*.15;
								e->Misc[HPT_TARGETX]=Link->X+8;
								e->Misc[HPT_TARGETY]=Link->Y+8;
							}
							else if(i%4==2){
								TAngle = Angle(Link->X+8, Link->Y+8, 128, 96)+Rand(-100,100);
								e->Misc[HPT_FIRINGDELAY]+=8*i;
								e->Misc[HPT_TARGETX]=Link->X+8+VectorX(32, TAngle);
								e->Misc[HPT_TARGETY]=Link->Y+8+VectorY(32, TAngle);
							}
							else{
								e->Misc[HPT_TARGETX] = 40+8+Rand(10)*16;
								e->Misc[HPT_TARGETY] = 32+8+Rand(7)*16;
							}
							RunEWeaponScript(e, "HorizonGilgameshPosting", {0});
							// HPT_MODE,
							// HPT_FIRINGDELAY,
							// HPT_EXTENDINGTIME,
							// HPT_AUTOTRACK,
							// HPT_TARGETX,
							// HPT_TARGETY,
							// HPT_CHAINTARGETLENGTH
							
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 16);
						}
						for(int i=0; i<12; ++i){
							SpawnFlag[i]=0;
						}
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 32);
					}
					
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 200);
					for(int i=0; i<12; ++i){
						eweapon e = FireAimedEWeapon(EW_SOLAR, SpawnX[i], SpawnY[i], DegtoRad(0), 0, ghost->Damage*1.5, 108, 0, EWF_UNBLOCKABLE);
						e->CollDetection = false;
						e->DrawYOffset = -1000;
						e->Misc[HPT_MODE] = 1;
						e->Misc[HPT_FIRINGDELAY] = 32;
						e->Misc[HPT_AUTOTRACK]=2;
						e->Misc[HPT_TARGETX]=Link->X+8;
						e->Misc[HPT_TARGETY]=Link->Y+8;
						RunEWeaponScript(e, "HorizonGilgameshPosting", {0});
					}
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 64);
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
					
					TX= 120; TY=72;
					while(Distance(Ghost_X, Ghost_Y, TX, TY)>3){
						TAngle = Angle(Ghost_X, Ghost_Y, TX, TY);
						Ghost_MoveAtAngle(TAngle, 1.5, 2);
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					Ghost_X=TX; Ghost_Y=TY;
					Ghost_UnsetFlag(GHF_IGNORE_ALL_TERRAIN);
					ghost->CollDetection=true;
					TAngle = Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y);
					Ghost_Dir=AngleDir4(TAngle);
					Ghost_Data=HorizonCombo[BASECOMBO];
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 32);
					break;
				}
				case 101:{ //Solar Cage Super
					Phase=5;
					Ghost_HP=MaxHP-HORIZON_SECONDHP/3*2;
					ghost->HP = Ghost_HP;
					ghost->Misc[NPCM_DAMAGENUMBERSLASTHP] = ghost->HP;
					MinAttackchoice=2;
					MaxAttackchoice=7;
					SodOffSuns(NPCArray);
					
					TX=120; TY=72;
					Ghost_Data = HorizonCombo[TELECOMBO];
					Game->PlaySound(SFX_HORIZONTELEPORT);
					ghost->CollDetection=false;
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_BRIGHT;
					while(Distance(Ghost_X, Ghost_Y, TX, TY)>3){
						TAngle = Angle(Ghost_X, Ghost_Y, TX, TY);
						Ghost_MoveAtAngle(TAngle, 2, 2);
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					Ghost_X=TX; Ghost_Y=TY;
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 24);
					TAngle = Rand(359);
					for(int i=0; i<2; ++i){
						TX = Ghost_X+VectorX(16, TAngle+180*i);
						TY = Ghost_Y+16+VectorY(16, TAngle+180*i);
						EArray[i]= FireEWeapon(EW_SOLAR, TX, TY, DegtoRad(TAngle+180*i),0, ghost->Damage, 108, 0, EWF_UNBLOCKABLE);
						EArray[i]->CollDetection = false;
						EArray[i]->DrawYOffset = -1000;
						EArray[i]->Misc[HPT_MODE] = 0;
						EArray[i]->Misc[HPT_FIRINGDELAY] = 32;
						EArray[i]->Misc[HPT_EXTENDINGTIME] = 600;
						EArray[i]->Misc[HPT_CHAINTARGETLENGTH] = 150;
						RunEWeaponScript(EArray[i], "HorizonGilgameshPosting", {0});
					}
					int Radius = 150;
					HorizonArray[_MANUALCOLORCHANGE]=1;
					int FAngle; int FOffset;
					for(int frames=0; frames<1248; frames++){
						
						if(frames>60 && frames<750){
							if(Radius>78)Radius-=2;
							TAngle = WrapDegrees(TAngle+1);
							
							if(frames<360){
								if(frames%72==0){
									for(int i=0; i<2; ++i){
										FOffset = Choose({-20, -10, 0, 10, 20});
										FAngle = TAngle+90+(180*i)+FOffset;
										TX=Ghost_X+VectorX(Radius, FAngle);
										TY=Ghost_Y+16+VectorY(Radius, FAngle);
										eweapon e = FireAimedEWeapon(EW_SOLAR, TX, TY, DegtoRad(0), 0, ghost->WeaponDamage, 108, 0, EWF_UNBLOCKABLE);
										e->CollDetection = false;
										e->DrawYOffset = -1000;
										e->Misc[HL_LINETELEGRAPH]=1;
										e->Misc[HL_WIDTH]=24;
										e->Misc[HL_STARTTIME]=48;
										e->Misc[HL_DURATION]=32;
										RunEWeaponScript(e, "HorizonLaser", {0});
									}
								}
							}
							else if(frames%36==0){
								FOffset = Choose({-30, -20, -10, 0, 10, 20, 30});
								if(frames%84==0)FOffset+=180;
								FAngle = TAngle+90+180+FOffset;
								TX=Ghost_X+VectorX(Radius, FAngle);
								TY=Ghost_Y+16+VectorY(Radius, FAngle);
								eweapon e = FireAimedEWeapon(EW_SOLAR, TX, TY, DegtoRad(0), 0, ghost->WeaponDamage, 108, 0, EWF_UNBLOCKABLE);
								e->CollDetection = false;
								e->DrawYOffset = -1000;
								e->Misc[HL_LINETELEGRAPH]=1;
								e->Misc[HL_WIDTH]=16;
								e->Misc[HL_STARTTIME]=36;
								e->Misc[HL_DURATION]=24;
								RunEWeaponScript(e, "HorizonLaser", {0});
							}
							
						}
						else if(frames>=800 && frames<1200){
							TAngle = WrapDegrees(TAngle-1);
							
							if(frames%48==30){
								FOffset = Choose({-15, -10, 0, 10, 15});
								if(frames%(48*2)==30)FOffset+=180;
								FAngle = TAngle+90+180+FOffset;
								TX=Ghost_X+VectorX(Radius, FAngle);
								TY=Ghost_Y+16+VectorY(Radius, FAngle);
								eweapon e = FireAimedEWeapon(EW_SOLAR, TX, TY, DegtoRad(0), 0, ghost->WeaponDamage, 108, 0, EWF_UNBLOCKABLE);
								e->CollDetection = false;
								e->DrawYOffset = -1000;
								e->Misc[HL_LINETELEGRAPH]=1;
								e->Misc[HL_WIDTH]=16;
								e->Misc[HL_STARTTIME]=36;
								e->Misc[HL_DURATION]=24;
								RunEWeaponScript(e, "HorizonLaser", {0});
							}
							else if(frames%60==0){
								FOffset = Choose({-25, -20, -15, 15, 20, 25})+180;
								if(frames%(60*2)==0)FOffset-=180;
								FAngle = TAngle+90+180+FOffset;
								TX=Ghost_X-16+VectorX(Radius, FAngle);
								TY=Ghost_Y+16+VectorY(Radius, FAngle);
								FAngle = Angle(TX+16, TY, Link->X, Link->Y);
								TX+=VectorX(16, FAngle);
								TY+=VectorY(16, FAngle);
								eweapon e = FireBigEWeapon(EW_SOLAR, TX, TY, DegtoRad(FAngle), 600, ghost->WeaponDamage, SPR_HORIZONSHOT3X1, 0, EWF_UNBLOCKABLE, 3, 1);
								e->CollDetection = false;
								e->DrawYOffset = -1000;
								e->Misc[0]=28;
								RunEWeaponScript(e, "HorizonPortalShot", {0});
							}
						}
						for(int i=0; i<2; ++i){
							EArray[i]->X = Ghost_X+VectorX(12, TAngle+180*i);
							EArray[i]->Y = Ghost_Y+16+VectorY(12, TAngle+180*i);
							EArray[i]->Angle = DegtoRad(TAngle+180*i);
							EArray[i]->Misc[HPT_CHAINTARGETLENGTH]=Radius;
						}
						
						if(frames%2==0)Screen->D[D_HORIZON_FX] = Choose(C_WHITE, Rand(C_GOLD1-3, C_GOLD2-3), Rand(C_GOLD1, C_GOLD2));
						InvertedCircle(3, CenterX(ghost), HitboxCenterY(ghost), Radius+Rand(-1,0), Screen->D[D_HORIZON_FX]);
						Screen->Circle(3, CenterX(ghost), HitboxCenterY(ghost), 16+Rand(-1,1), Screen->D[D_HORIZON_FX], 1, 0, 0, 0, true, OP_OPAQUE);
						
						if(Distance(Link->X, Link->Y, Ghost_X, Ghost_Y+16)>Radius || Distance(Link->X, Link->Y, Ghost_X, Ghost_Y+16)<16){
							DamageLinkSolar(ghost->Damage*1.5);
						}
						
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					EArray[0]->Misc[HPT_EXTENDINGTIME] = 0;
					EArray[1]->Misc[HPT_EXTENDINGTIME] = 0;
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
					for(int i=0; i<48; ++i){
						if(i%2==0)Screen->D[D_HORIZON_FX] = Choose(C_WHITE, Rand(C_GOLD1-3, C_GOLD2-3), Rand(C_GOLD1, C_GOLD2));
						InvertedCircle(5, CenterX(ghost), HitboxCenterY(ghost), Radius+i*3, Screen->D[D_HORIZON_FX]);
						Screen->Circle(4, Ghost_X+8, Ghost_Y+22-(i/(48/4)), 12-(48-i)/3, Screen->D[D_HORIZON_FX], 1, 0, 0, 0, true, OP_OPAQUE);
						if(Distance(Link->X, Link->Y, Ghost_X, Ghost_Y+16)>Radius+i*3 || Distance(Link->X, Link->Y, Ghost_X, Ghost_Y+16)<12){
							DamageLinkSolar(ghost->Damage*1.5);
						}
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					ghost->CollDetection=true;
					TAngle = Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y);
					Ghost_Dir=AngleDir4(TAngle);
					Ghost_Data=HorizonCombo[BASECOMBO];
					HorizonArray[_MANUALCOLORCHANGE]=0;
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 32);
					break;
				}
			}
			Ghost_Data=HorizonCombo[BASECOMBO];
			
			for(int i=0; i<64; ++i){
				if(Ghost_GotHit())i+=24;
				Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
				HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
			}
			if(Phase==5 && Ghost_HP<= MaxHP-HORIZON_SECONDHP){
				break;
			}
			else if(Attackcount%3==CharacterAttackMod){ //Character specific attack logic
				
				if(GetCharID() == CHAR_ASHER){ //Solar sword
					TAngle = Angle(Link->X, Link->Y, 120, 88);
					TX = 120+VectorX(20, TAngle);
					TY = 88+VectorY(20, TAngle);
					Ghost_Data = HorizonCombo[TELECOMBO];
					Game->PlaySound(SFX_HORIZONTELEPORT);
					ghost->CollDetection=false;
					int breaktime;
					while(Distance(Ghost_X, Ghost_Y+16, TX, TY)>3){
						breaktime++;
						if(breaktime>120)break;
						TAngle = Angle(Ghost_X, Ghost_Y+16, TX, TY);
						Ghost_MoveAtAngle(TAngle, 1.5, 2);
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					TAngle = Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8);
					Ghost_Dir=AngleDir4(TAngle);
					Ghost_Data=HorizonCombo[ATKCOMBO1];
					ghost->CollDetection=true;
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER;
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 12);
					int j=Choose(-1,1); int i; int k;
					Game->PlaySound(SFX_STELLARSWORD_APPEAR);
					for(i=0; i<5; ++i){
						for(k=0; k<2; ++k){
							DrawHorizonSword(Ghost_X, Ghost_Y+16, TAngle-90*j, 8, i, ghost->Damage*1.5, 0, 0, 0);
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
						}
					}
					for(i=0; i<60; ++i){
						DrawHorizonSword(Ghost_X, Ghost_Y+16, TAngle-90*j, 8, 5, ghost->Damage*1.5, -0, 0, 0);
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					Game->PlaySound(SFX_STELLARSWORD_SLASH);
					for(i=30; i<180+45; i+=15){
						Ghost_MoveAtAngle(TAngle, 2, 1);
						DrawHorizonSword(Ghost_X, Ghost_Y+16, TAngle-90*j+i*j, 12, 5, ghost->Damage*1.5, TAngle-90*j+i*j -(i-30)*j, 30, 300);
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					for(i=0; i<45; i++){
						DrawHorizonSword(Ghost_X, Ghost_Y+16, TAngle-90*j+180+45*j, 12, 5, ghost->Damage*1.5, 0, 0, 0);
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					Game->PlaySound(SFX_STELLARSWORD_SLASH);
					Ghost_Data=HorizonCombo[ATKCOMBO2];
					for(i=180+15; i>-60; i-=15){
						Ghost_MoveAtAngle(TAngle, 2.5, 1);
						DrawHorizonSword(Ghost_X, Ghost_Y+16, TAngle-90*j+i*j, 12, 5, ghost->Damage*1.5, TAngle-90*j+i*j +(180+15-i)*j, 30, 300);
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					for(i=5; i>1; --i){
						DrawHorizonSword(Ghost_X, Ghost_Y+16, TAngle-90*j-60*j, 8, i, ghost->Damage*1.5, 0, 0, 0);
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					//DrawHorizonSword(int sx, int sy, int angle, int dist, int swordlength, int damage, int TrailAngle, int TrailSpacing, int FlareDuration)
				}
				else if(GetCharID() == CHAR_TORRIN){ //Wicked Weaves
					int Delay=36;
					int LastChoice=0;
					int Offset;
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER;
					for(int Punches=0; Punches<9; Punches++){
						if(Ghost_Data==HorizonCombo[ATKCOMBO1])Ghost_Data=HorizonCombo[ATKCOMBO2];
						else Ghost_Data=HorizonCombo[ATKCOMBO1];
						TAngle = Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8);
						Ghost_Dir=AngleDir4(TAngle);
						
						Offset = Choose(0, 45, 75);
						while(Offset==LastChoice)Offset = Choose(0, 0, 45, 70);
						LastChoice = Offset;
						
						if(Punches%3==2){ //Double
							Offset=90;
							LastChoice=75;
						}
						else if(Punches%3==1 && Rand(0,2)>0){ //Honku
							Offset=180;
							LastChoice=0;
						}
						Offset *= Choose(-1,1);
						TX = Clamp(Link->X+VectorX(48, TAngle+180+Offset),8,232);
						TY = Clamp(Link->Y+VectorY(48, TAngle+180+Offset),8,168);
						
						eweapon e = FireAimedEWeapon(EW_SOLAR, TX, TY, 0, 0, ghost->Damage/2, 108, 97, EWF_UNBLOCKABLE);
						if(Ghost_Data==HorizonCombo[ATKCOMBO1])e->Tile=TIL_HORIZONFIST1;
						else e->Tile = TIL_HORIZONFIST2;
						e->CSet=3;
						e->DrawYOffset=1000;
						e->CollDetection=false;
						int Goddamnit[8];
						Goddamnit[0]=64;
						Goddamnit[1]=Delay;
						Goddamnit[2]=8;
						Goddamnit[3]=24;
						Goddamnit[4]=12;
						RunEWeaponScript(e, "HorizonWeave", Goddamnit);
						
						if(Punches%3==2){
							TAngle = Angle(TX, TY, Link->X, Link->Y);
							int Dist = Distance(TX, TY, Link->X, Link->Y);
							int FX = Clamp(TX+VectorX(Dist*2, TAngle), 8, 232);
							int FY = Clamp(TY+VectorY(Dist*2, TAngle), 8, 168);
							
							eweapon e = FireAimedEWeapon(EW_SOLAR, FX, FY, 0, 0, ghost->Damage/2, 108, 97, EWF_UNBLOCKABLE);
							if(Ghost_Data==HorizonCombo[ATKCOMBO1])e->Tile=TIL_HORIZONFIST2;
							else e->Tile = TIL_HORIZONFIST1;
							e->CSet=3;
							e->DrawYOffset=1000;
							e->CollDetection=false;
							Goddamnit[0]=64;
							Goddamnit[1]=Delay;
							Goddamnit[2]=8;
							Goddamnit[3]=24;
							Goddamnit[4]=12;
							RunEWeaponScript(e, "HorizonWeave", Goddamnit);
						}
						
						//int extend, int telegraphTime, int extendTime, int sustainTime, int retractTime
						
						int DelayMod = Rand(16, 32);
						for(int i=0; i<DelayMod; ++i){
							Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y));
							Ghost_MoveTowardLink(.33, 2);
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
						}
						Delay=36+(24-DelayMod);
					}
					Offset=Choose(0,45);
					for(int i=0; i<4; ++i){
						TX = Ghost_X+VectorX(20, 90*i+Offset);
						TY = Ghost_Y+16+VectorY(20, 90*i+Offset);
						int Goddamnit[8];
						eweapon e = FireEWeapon(EW_SOLAR, TX, TY, DegtoRad(90*i+Offset), 0, ghost->Damage/2, 108, 97, EWF_UNBLOCKABLE);
						if(i%2==0)e->Tile=TIL_HORIZONFIST1;
						else e->Tile = TIL_HORIZONFIST2;
						e->CSet=3;
						e->DrawYOffset=1000;
						e->CollDetection=false;
						Goddamnit[0]=64;
						Goddamnit[1]=Delay+16;
						Goddamnit[2]=8;
						Goddamnit[3]=24;
						Goddamnit[4]=12;
						RunEWeaponScript(e, "HorizonWeave", Goddamnit);
					}
					Ghost_Data = HorizonCombo[BASECOMBO];
					Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 48);
					Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
				}
				else if(GetCharID() == CHAR_KAYLANI){ //Sundog Danmaku
					Ghost_Data = HorizonCombo[HOLDUPCOMBO];
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER;
					int YPos[9]; //Stores if a slot has been taken or not yet
					int Choice;
					int TDir;
					if(Link->X >128){
						TX = 32;
						TDir=DIR_RIGHT;
					}
					else{
						TX = 208;
						TDir = DIR_LEFT;
					}
					
					for(int i=0; i<3; ++i){ //Bias the first 2 towards the side of the screen as the player
						
						if(i!=3){
							if(Link->Y <= 88)Choice = Rand(0,4);
							else Choice = Rand(4,8);
						}
						else Choice = Rand(0,8);
						
						if(YPos[Choice]){ //Slot taken? Try again
							i--;
							continue;
						}
						else{
							YPos[Choice]=1;
							eweapon e = FireNonAngularEWeapon(EW_SOLAR, TX, 24+Choice*16, TDir, 0, ghost->WeaponDamage, 108, 39, EWF_UNBLOCKABLE);
							ConfigureSundog(e, TDir, 150, 3, 70);
							//int FlickerTime, int NumShots, int FiringDelay
						}
					}
					HorizonArray[_HALOYOFFSET]=-1;
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 24);
					HorizonArray[_HALOYOFFSET]=-1;
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 24);
					
					ghost->CollDetection=false;
					Ghost_Data = HorizonCombo[TELECOMBO];
					Game->PlaySound(SFX_HORIZONTELEPORT);
					
					for(int g=0; g<2; ++g){ //2 more waves of 3...
						for(int i=0; i<3; ++i){ 
							Choice = Rand(0,8);
							
							if(YPos[Choice]){
								i--;
								continue;
							}
							else{
								YPos[Choice]=1;
								eweapon e = FireNonAngularEWeapon(EW_SOLAR, TX, 24+Choice*16, TDir, 0, ghost->WeaponDamage, 108, 39, EWF_UNBLOCKABLE);
								ConfigureSundog(e, TDir, 150, 3, 70);
							}
						}	
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 48);
					}
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 300);
					ghost->CollDetection=true;
					Ghost_Data = HorizonCombo[BASECOMBO];
					HorizonArray[_HALOYOFFSET]=0;
					Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
					
				}
				Ghost_Data = HorizonCombo[BASECOMBO];
				HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
				HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 60);
			}
			
			Attackcount++;
		}
		SodOffSuns(NPCArray);
		if(BossType==1){ //Second cutscene
			
			//CHASE CUTSCENE #2
			EndingHandler(this, ghost);
			
		}
		else{ //BEEEEG BEEEEG LASER
			TX=120; TY=72;
			Ghost_Data = HorizonCombo[TELECOMBO];
			Game->PlaySound(SFX_HORIZONTELEPORT);
			ghost->CollDetection=false;
			while(Distance(Ghost_X, Ghost_Y, TX, TY)>3){
				TAngle = Angle(Ghost_X, Ghost_Y, TX, TY);
				Ghost_MoveAtAngle(TAngle, 2, 2);
				HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
			}
			Ghost_X=TX; Ghost_Y=TY;
			HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 64);
			
			HorizonArray[_PALETTETARGET]=HORIZON_PAL_BRIGHT;
			for(int i=0; i<48*3; ++i){
				if(i%16==0){
					if(i<48*2)Game->PlaySound(SFX_CHARGE1);
					else Game->PlaySound(SFX_CHARGE2);
					Screen->Quake = 12;
				}
				Screen->Circle(4, Ghost_X+8+Rand(-2,2), Ghost_Y+22+Rand(-2,2), 8+i/3, C_WHITE, 1, 0, 0, 0, true, OP_TRANS);
				Screen->Circle(4, Ghost_X+8+Rand(-2,2), Ghost_Y+22+Rand(-2,2), 2+i/3, Screen->D[D_HORIZON_FX], 1, 0, 0, 0, true, OP_OPAQUE);
				if(Distance(Ghost_X, Ghost_Y+14, Link->X, Link->Y)<=i/3)DamageLinkSolar(ghost->Damage*1.5);
				HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
			}
			Game->PlaySound(SFX_METEORITE_FALL);
			HorizonArray[_PALETTETARGET]=HORIZON_PAL_YEET;
			HorizonArray[_BACKGROUNDTOGGLE]=0;
			for(int i=0; i<64; ++i){
				Screen->Circle(4, Ghost_X+8+Rand(-1,1), Ghost_Y+22+Rand(-1,1)-i*3, 56, C_WHITE, 1, 0, 0, 0, true, OP_TRANS);
				Screen->Circle(4, Ghost_X+8+Rand(-1,1), Ghost_Y+22+Rand(-1,1)-i*3, 50, Screen->D[D_HORIZON_FX], 1, 0, 0, 0, true, OP_OPAQUE);
				if(Distance(Ghost_X, Ghost_Y+14, Link->X, Link->Y)<=48)DamageLinkSolar(ghost->Damage*1.5);
				HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
			}
			HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 32);
			Game->PlaySound(86);
			HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 48);
			Game->PlaySound(SFX_HORIZONBEEGRUMBLE);
			int YOffset;
			int LineX[64]; int LineY[64];
			for(int i=SizeOfArray(LineX)-1; i>=0; --i){
				LineX[i]=Rand(2,13)*16+8+Rand(-3,3);
				LineY[i]=Rand(-64, 168);
			}
			for(int i=0; i<120; ++i){
				if(YOffset<48){
					YOffset++;
					Screen->Quake=12;
				}
				Screen->Ellipse(5, 128, -60+YOffset, 200, 48+Rand(-1,1), C_WHITE, 1,128, -64+YOffset, 0, true, OP_TRANS);
				Screen->Ellipse(5, 128, -64+YOffset, 200, 44+Rand(-2,2), Screen->D[D_HORIZON_FX], 1, 128, -64+YOffset, 0, true, OP_OPAQUE);
				
				HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
			}
			Game->PlayMIDI(0);
			Game->PlaySound(SFX_HORIZONBEEGRUMBLE);
			HorizonArray[_BURNCOUNTER_ASHER]=0;
			HorizonArray[_BURNCOUNTER_TORRIN]=0;
			HorizonArray[_BURNCOUNTER_KAYLANI]=0;
			
			for(int i=0; i<120; ++i){
				DrawLaser(4, 128, -32, 8, 90, C_WHITE, OP_OPAQUE);
				Screen->Ellipse(4, 128, -60+YOffset, 200, 48+Rand(-1,1), C_WHITE, 1, 128, -64+YOffset, 0, true, OP_TRANS);
				Screen->Ellipse(4, 128, -64+YOffset, 200, 44+Rand(-2,2), Screen->D[D_HORIZON_FX], 1, 128, -64+YOffset, 0, true, OP_OPAQUE);
				for(int g=0; g<SizeOfArray(LineX); ++g){
					DrawThickLine(3, LineX[g], LineY[g], LineX[g], LineY[g]+48, 1, Screen->D[D_HORIZON_FX], true, OP_TRANS);
					LineY[g]+=((g%4)+1)*4;
					if(LineY[g]>=172){
						LineY[g]-=(172+64);
						LineX[g]=Rand(2,13)*16+8+Rand(-3,3);
					}
				}
				if(i>116)NoAction();
				HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
			}
			//YEET
			int XOffset=0;
			for(int i=0; i<300; ++i){
				NoAction();
				G[G_DRAWNHPZERO]=1;
				Screen->Quake = Rand(16,24);
				LinkMovement_Push2(VectorX(2, 90), VectorY(2, 90));
				if(i%15==0)Game->PlaySound(SFX_HORIZONBEEGLASER);
				if(i%32==0){
					Game->PlaySound(19);
					int Divisor = Choose({4, 4, 4.1, 4.34, 4.38, 4.41, 4.44, 4.47, 4.9, 5, 5, 5, 5.21, 5.28, 5.32, 5.4, 5.55, 5.71, 5.89, 6, 6}); //Really silly random number range
					DamageNumbers_AddNumberGFX(CenterLinkX(), CenterLinkY()-DAMAGENUMBERS_HEIGHT/2, _DNUM_TYPE_LINKDAMAGE, Round(DMG_BEEGLASERSUPER/Divisor));
					
				}
				if(i>288 && XOffset<40){
					XOffset+=4;
				}
				//Screen->Ellipse(5, 128, -64+YOffset, 256, 48+Rand(-1,1), C_WHITE, 1, 0, 0, 0, true, OP_TRANS);
				int Pulse = Sin((G[G_ANIM]%6) * 36)*4;
				Screen->Rectangle(4, 0, -32, 255, 175+32, C_WHITE, 1, 0, 0, 0, true, OP_TRANS);
				Screen->Ellipse(4, 128, -64+YOffset, 200, 44+Rand(-2,2), Screen->D[D_HORIZON_FX], 1, 128, -64+YOffset, 0, true, OP_OPAQUE);
				Screen->Rectangle(4, 36-XOffset-Pulse, -32, 255-36+XOffset+Pulse, 175+32, Screen->D[D_HORIZON_FX], 1, 0, 0, 0, true, OP_OPAQUE);
				for(int g=0; g<SizeOfArray(LineX); ++g){
					DrawThickLine(4, LineX[g], LineY[g], LineX[g], LineY[g]+48, 2, Choose(0x86, 0x87), true, OP_OPAQUE);
					LineY[g]+=((g%4)+3)*4;
					if(LineY[g]>=172){
						LineY[g]-=(172+64);
						LineX[g]=Rand(2,13)*16+8+Rand(-3,3);
					}
				}
				Screen->Rectangle(4, 36+64-XOffset*2.5-Pulse*1.5, -32, 255-64-36+XOffset*2.5+Pulse*1.5, 175+32, C_WHITE, 1, 0, 0, 0, true, OP_OPAQUE);
				
				HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
			}
			
			for(int i=0; i<60; ++i){
				if(i%15==0)Game->PlaySound(SFX_HORIZONBEEGLASER);
				if(i==25){
					Game->PlaySound(19);
					DamageNumbers_AddNumberGFX(CenterLinkX(), CenterLinkY()-DAMAGENUMBERS_HEIGHT/2, _DNUM_TYPE_LINKDAMAGE, DMG_BEEGLASERSUPER);
				}
				Screen->Rectangle(5, 0, -32, 255, 175+32, C_WHITE, 1, 0, 0, 0, true, OP_OPAQUE);
				
				NoAction();
				G[G_DRAWNHPZERO]=1;
				HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
			}
			ApplyActuallyDead();
			mapdata l1 = Game->LoadTempScreen(1); //Current screen
			mapdata refl1 = Game->LoadMapData(Game->GetCurMap()+1, HORIZON_SCREEN_DESTROYED);
			mapdata refl0 = Game->LoadMapData(Game->GetCurMap(), HORIZON_SCREEN_DESTROYED);
			for(int i=0; i<176; ++i){
				l1->ComboD[i] = refl1->ComboD[i];
				l1->ComboC[i] = refl1->ComboC[i];
				Screen->ComboD[i] = refl0->ComboD[i];
				Screen->ComboC[i] = refl0->ComboC[i];
			}
			Screen->Rectangle(5, 0, -32, 255, 175+32, C_WHITE, 1, 0, 0, 0, true, OP_OPAQUE);
			HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
			HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
			HorizonArray[_BACKGROUNDTOGGLE]=1;
			if(Form==2)Form=3;
			for(int i=0; i<16; ++i){
				NoAction();
				Screen->Rectangle(5, -16, -16, 255+32, 175+32, C_WHITE, 1, 0, 0, 0, true, OP_TRANS);
				HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
			}
			Game->PlayEnhancedMusic("SS-TalkShitGetHit.ogg", 0);
		}
		ghost->HP = 30000;
		Ghost_HP = 30000;
		ghost->Misc[NPCM_DAMAGENUMBERSLASTHP] = ghost->HP;
		Ghost_Data = HorizonCombo[BASECOMBO];
		ghost->CollDetection=true;
		Phase=1;
		MinAttackchoice=0;
		MaxAttackchoice=5;
		LastAttack=-1;
		int LastAttack2=-1;
		Attackcount=0;
		CharacterAttackMod = Rand(0,2);
		RNGFlush();
		
		G[G_HORIZONCURRENTFORM] = 2;
		while(Form==3){ //It's morbin' time!!
			for(int i=0; i<64 && Attackchoice; ++i){
				if(Ghost_GotHit())i+=24;
				Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
				HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
			}
			
			if(Phase==1 && Ghost_HP<= MaxHP-HORIZON_THIRDHP/5*2){ //60%
				Phase=2; 
			}
			else if(Phase==3 && Ghost_HP<=MaxHP-HORIZON_THIRDHP/5*4){ //20%
				Phase=4; 
			}
			else if(Phase==5 && Ghost_HP<= MaxHP-HORIZON_THIRDHP){
				break;
			}
			
			if(Phase%2==1){
				switch(Attackcount%4){
					case 0:{ //Summon Suns
						if(Phase==5)break; //No suns at the end of the fight.
						
						if(!NPCArray[0]->isValid()){
							TAngle = Angle(Link->X, Link->Y, 120, 88)+Rand(15,40);
							TX = 120+VectorX(70, TAngle);
							TY = 88+VectorY(70, TAngle);
							Game->PlaySound(SFX_SUMMON);
							NPCArray[0]=CreateNPCAt(NPC_SUNFRIEND, TX, TY);
							NPCArray[0]->ItemSet=ITEMSET_HEART;
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 12);
						}
						if(!NPCArray[1]->isValid()){
							TAngle = Angle(Link->X, Link->Y, 120, 88)-Rand(15,40);
							TX = 120+VectorX(70, TAngle);
							TY = 88+VectorY(70, TAngle);
							Game->PlaySound(SFX_SUMMON);
							NPCArray[1]=CreateNPCAt(NPC_SUNFRIEND, TX, TY);
							NPCArray[1]->ItemSet=ITEMSET_MAGIC;
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 12);
						}
						
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 24);
						break;
					}
					case 1:{ //Surfing Lazychase
						Ghost_Data = HorizonCombo[BASECOMBO];
						HorizonArray[_SURFBOARD]=1;
						for(int frames=0; frames<240; ++frames){
							Ghost_Vx=LazyChase(Ghost_Vx, Ghost_X, Link->X, 0.07, 1.7);
							Ghost_Vy=LazyChase(Ghost_Vy, Ghost_Y+16, Link->Y, 0.07, 1.7);
							Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y));
							
							if(Phase<3){
								if(frames%60==20){
									Ghost_Data = HorizonCombo[ATKCOMBO1];
									HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE+2;
								}
								else if(frames%60==30){
									TAngle = Angle(0,0,Ghost_Vx, Ghost_Vy)+Rand(-15,15);
									for(int i=0; i<=2; ++i){
										TX = Ghost_X-16+VectorX(24, 45+TAngle+i*120);
										TY = Ghost_Y+16+VectorY(24, 45+TAngle+i*120);
										
										eweapon e = FireBigEWeapon(EW_SOLAR, TX, TY, DegtoRad(45+TAngle+i*120), 600, ghost->WeaponDamage, SPR_HORIZONSHOT3X1, 0, EWF_UNBLOCKABLE, 3, 1);
										e->CollDetection = false;
										e->DrawYOffset = -1000;
										RunEWeaponScript(e, "HorizonPortalShot", {0});
									}
								}
								else if(frames%60==40){
									Ghost_Data = HorizonCombo[BASECOMBO];
									HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
								}
							}
							else{
								if(frames%10==8 && frames<200 && frames >10){
									if(Ghost_Data == HorizonCombo[ATKCOMBO1])Ghost_Data = HorizonCombo[ATKCOMBO2];
									else Ghost_Data = HorizonCombo[ATKCOMBO1];
									
									HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER;
									eweapon e = FireAimedEWeapon(EW_SOLAR, Ghost_X, Ghost_Y+16, DegtoRad(0), 0, ghost->WeaponDamage, 108, 0, EWF_UNBLOCKABLE);
									e->CollDetection = false;
									e->DrawYOffset = -1000;
									e->Misc[HL_LINETELEGRAPH]=1;
									e->Misc[HL_WIDTH]=16;
									e->Misc[HL_STARTTIME]=32;
									e->Misc[HL_DURATION]=80;
									RunEWeaponScript(e, "HorizonLaser", {0});
								}
							}
							Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
						}
						Ghost_Vx=0; Ghost_Vy=0;
						HorizonArray[_SURFBOARD]=0;
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 12);
						HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 12);
						break;
					}
					case 2:{ //Attack with suns
						if(Phase==5)break; //No suns at the end of the fight.
						if(!NPCArray[0]->isValid() && !NPCArray[1]->isValid())break;
						
						Ghost_Data = HorizonCombo[ATKCOMBO1];
						HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER;
						HorizonArray[_MANUALCOLORCHANGE]=1;
						for(int cycles=0; cycles<2; cycles++){
							for(int frames=0; frames<=48 && (NPCArray[0]->isValid() || NPCArray[1]->isValid()); ++frames){
								if(frames%2==0)Screen->D[D_HORIZON_FX] = Choose(C_WHITE, Rand(C_GOLD1-3, C_GOLD2-3), Rand(C_GOLD1, C_GOLD2));
								if(NPCArray[0]->isValid() && frames<=16){
									Ghost_Data = HorizonCombo[ATKCOMBO1];
									if(frames%6==0)Game->PlaySound(SFX_HORIZONLASER);
									Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, CenterX(NPCArray[0]), CenterY(NPCArray[0])-4));
									TAngle = Angle(Ghost_X+8, Ghost_Y+24, CenterX(NPCArray[0]), CenterY(NPCArray[0]));
									
									
									DrawThickLine(3, Ghost_X+8, Ghost_Y+24, CenterX(NPCArray[0]), CenterY(NPCArray[0])-4, 2, Screen->D[D_HORIZON_FX], true, OP_OPAQUE);
									Screen->Circle(3, Ghost_X+8, Ghost_Y+24, 4+Rand(-1,1), Screen->D[D_HORIZON_FX], 1, 0, 0, 0, true, OP_OPAQUE);
									Screen->Circle(3,  CenterX(NPCArray[0]), CenterY(NPCArray[0])-4, 4+Rand(-1,1), Screen->D[D_HORIZON_FX], 1, 0, 0, 0, true, OP_OPAQUE);
									
									if(frames==16){ //Pew
										TX = CenterX(NPCArray[0])-8;
										TY = CenterY(NPCArray[0])-12;
										eweapon e = FireAimedEWeapon(EW_SOLAR, TX, TY, DegtoRad(0), 200, ghost->WeaponDamage, 108, SFX_HORIZONSHOT, EWF_UNBLOCKABLE);
										SetEWeaponMovement(e, EWM_HOMING, DegtoRad(.5), -1);
										RunEWeaponScript(e, "HorizonLargeShot", {0});
									}
								}
								if(NPCArray[1]->isValid() && frames>32){
									Ghost_Data = HorizonCombo[ATKCOMBO1];
									if(frames%6==0)Game->PlaySound(SFX_HORIZONLASER);
									Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, CenterX(NPCArray[1]), CenterY(NPCArray[1])-4));
									TAngle = Angle(Ghost_X+8, Ghost_Y+24, CenterX(NPCArray[1]), CenterY(NPCArray[1]));
									
									DrawThickLine(3, Ghost_X+8, Ghost_Y+24, CenterX(NPCArray[1]), CenterY(NPCArray[1])-4, 2, Screen->D[D_HORIZON_FX], true, OP_OPAQUE);
									Screen->Circle(3, Ghost_X+8, Ghost_Y+24, 4+Rand(-1,1), Screen->D[D_HORIZON_FX], 1, 0, 0, 0, true, OP_OPAQUE);
									Screen->Circle(3,  CenterX(NPCArray[1]), CenterY(NPCArray[1])-4, 4+Rand(-1,1), Screen->D[D_HORIZON_FX], 1, 0, 0, 0, true, OP_OPAQUE);
									
									if(frames==48){ //Pew
										TX = CenterX(NPCArray[1])-8;
										TY = CenterY(NPCArray[1])-12;
										eweapon e = FireAimedEWeapon(EW_SOLAR, TX, TY, DegtoRad(0), 200, ghost->WeaponDamage, 108, SFX_HORIZONSHOT, EWF_UNBLOCKABLE);
										SetEWeaponMovement(e, EWM_HOMING, DegtoRad(.5), -1);
										RunEWeaponScript(e, "HorizonLargeShot", {0});
									}
								}
								else{
									Ghost_Data = HorizonCombo[BASECOMBO];
									Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
								}
								
								HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
							}
							for(int i=0; i<16; ++i){
								if(i%2==0)Screen->D[D_HORIZON_FX] = Choose(C_WHITE, Rand(C_GOLD1-3, C_GOLD2-3), Rand(C_GOLD1, C_GOLD2));
								HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
							}
						}
						HorizonArray[_MANUALCOLORCHANGE]=0;
						Ghost_Data = HorizonCombo[BASECOMBO];
						HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
						
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 24);
						break;
					}
					case 3:{ //Reposition teleport with a brief attack at the end
						
						do{
							TX= Rand(56, 192);
							TY= Rand(48, 120)-16;
						}while(Distance(Ghost_X, Ghost_Y, TX, TY)<48);
						
						TAngle = Angle(Ghost_X, Ghost_Y, TX, TY);
						Ghost_Data = HorizonCombo[TELECOMBO];
						Game->PlaySound(SFX_HORIZONTELEPORT);
						ghost->CollDetection=false;
						while(Distance(Ghost_X, Ghost_Y, TX, TY)>3){
							TAngle = Angle(Ghost_X, Ghost_Y, TX, TY);
							Ghost_MoveAtAngle(TAngle, 2, 2);
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
						}
						Ghost_X=TX; Ghost_Y=TY;
						ghost->CollDetection=true;
						Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
						if(Rand(-1,Phase)>0){ //React!
							Ghost_Data = HorizonCombo[ATKCOMBO1];
							HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE+2;
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 12);
							TAngle = Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y);
							for(int i=-90; i<=90; i+=45){
								TX = Ghost_X-16+VectorX(30, TAngle+i);
								TY = Ghost_Y+16+VectorY(30, TAngle+i);
								
								eweapon e = FireBigEWeapon(EW_SOLAR, TX, TY, DegtoRad(TAngle+i), 600, ghost->WeaponDamage, SPR_HORIZONSHOT3X1, 0, EWF_UNBLOCKABLE, 3, 1);
								e->CollDetection = false;
								e->DrawYOffset = -1000;
								RunEWeaponScript(e, "HorizonPortalShot", {0});
							}
							
							HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
							Ghost_Data = HorizonCombo[BASECOMBO];
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 24);
						}
						else{
							TAngle=Rand(359);
							Ghost_Data = HorizonCombo[ATKCOMBO1];
							HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER;
							for(int i=0; i<8; ++i){
								Screen->Circle(2, Ghost_X+8, Ghost_Y+24, i*2, Screen->D[D_HORIZON_FX], 1, 0, 0, 0, true, OP_OPAQUE);
								HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
							}
							for(int i=0; i<10; ++i){
								TX = Ghost_X+VectorX(16, TAngle+i*36);
								TY = Ghost_Y+16+VectorY(16, TAngle+i*36);
								EArray[i]= FireEWeapon(EW_SOLAR, TX, TY, DegtoRad(TAngle+i*36),0, ghost->Damage, 108, 0, EWF_UNBLOCKABLE);
								EArray[i]->CollDetection = false;
								EArray[i]->DrawYOffset = -1000;
								EArray[i]->Misc[HPT_MODE] = 0;
								EArray[i]->Misc[HPT_FIRINGDELAY] = 24;
								EArray[i]->Misc[HPT_EXTENDINGTIME] = 32;
								EArray[i]->Misc[HPT_CHAINTARGETLENGTH] = 250;
								RunEWeaponScript(EArray[i], "HorizonGilgameshPosting", {0});
							}
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 48);
							for(int i=0; i<10; ++i){
								if(EArray[i]->isValid())EArray[i]->Misc[HPT_EXTENDINGTIME] = 0;
							}
							HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
							Ghost_Data = HorizonCombo[BASECOMBO];
						}
						
						break;
					}
				}
			}
			
			Ghost_Data=HorizonCombo[ATKCOMBO1];
			for(int i=0; i<48; ++i){
				if(Ghost_GotHit())i+=12;
				Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
				HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
			}
			
			if(Phase==1 && Ghost_HP<= MaxHP-HORIZON_THIRDHP/5*2){ //60%
				Phase=2; 
			}
			else if(Phase==3 && Ghost_HP<=MaxHP-HORIZON_THIRDHP/5*4){ //20%
				Phase=4; 
			}
			else if(Phase==5 && Ghost_HP<= MaxHP-HORIZON_THIRDHP){
				break;
			}
			
			if(Phase%2==0){
				if(Phase==2)Attackchoice=101;
				else if(Phase==4)Attackchoice=102;
			}
			else{
				if((Phase==1 || Attackcount%3==0) && Phase!=5){
					Attackchoice = Rand(MinAttackchoice, MaxAttackchoice);
					while(Attackchoice==LastAttack){
						Attackchoice = Rand(MinAttackchoice, MaxAttackchoice);
						if(Attackchoice==4 && LastAttack2==9)Attackchoice = Rand(MinAttackchoice, MaxAttackchoice); //Ensure both beam orbit moves have a very low chance to be used back to back even if it's extremely rarely possible
						if(Attackchoice==1 && LastAttack2==6)Attackchoice = Rand(MinAttackchoice, MaxAttackchoice); //Same, but with different moves
					}
					if(Attackchoice)LastAttack = Attackchoice;
				}
				else if(Phase==3 || Phase==5){ //A special brand of awful shit later in the fight.
					Attackchoice = Rand(6, 11);
					while(Attackchoice==LastAttack2){
						Attackchoice = Rand(6, 11);
						if(Attackchoice==9 && LastAttack==4)Attackchoice = Rand(6, 11); //See above
						if(Attackchoice==6 && LastAttack==1)Attackchoice = Rand(6, 11); //Yeah me too
					}
					LastAttack2 = Attackchoice;
				}
			}
			
			switch(Attackchoice){
				case 0:{ //Wow, it's fucking nothing
					MinAttackchoice=1; //Throws off the timing of all of the modulus based behaviors once and only once in the fight.
					break;
				}
				case 1:{ //Rapid teleports to the player's location followed by Urizen shockwaves
					Ghost_Data = HorizonCombo[TELECOMBO];
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 24);
					for(int cycles=0; cycles<4; cycles++){
						TX = Link->X; TY = Link->Y;
						Ghost_Data = HorizonCombo[TELECOMBO];
						Game->PlaySound(SFX_HORIZONTELEPORT);
						ghost->CollDetection=false;
						int breaktime;
						while(Distance(Ghost_X, Ghost_Y+16, TX, TY)>4){
							breaktime++;
							if(breaktime>60)break;
							TAngle = Angle(Ghost_X, Ghost_Y+16, TX, TY);
							Ghost_MoveAtAngle(TAngle, 4.5, 2);
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
						}
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 8);
						TAngle = Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8);
						Ghost_Dir=AngleDir4(TAngle);
						Ghost_Data=HorizonCombo[HOLDUPCOMBO];
						ghost->CollDetection=true;
						HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER;
						Game->PlaySound(35);
						for(int frames=0; frames<20; ++frames){
							TX = Ghost_X+4;
							TY = Ghost_Y+13;
							Screen->Circle(3, TX, TY, 1+frames/3+Rand(0,6), Screen->D[D_HORIZON_FX], 1, 0, 0, 0, true, OP_OPAQUE);
							
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
						}
						
						Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
						Game->PlaySound(37);
						bool push=false;
						Screen->Quake=32;
						for(int frames=0; frames<16; ++frames){
							DrawEnergyRing(4, TX+Rand(-1,1), TY+Rand(-1,1), frames*4, frames/2, frames/2, Screen->D[D_HORIZON_FX], 24, Rand(359));
							if(Distance(Ghost_X, Ghost_Y+16, Link->X, Link->Y)<=(frames*4)){
								DamageLinkSolar(ghost->Damage);
								push=true;
							}
							if(push){
								TAngle = Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y);
								LinkMovement_Push2(VectorX(4, TAngle), VectorY(4, TAngle));
								Link->HitDir=-1;
								NoAction();
							}
							
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
						}
						HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
						Ghost_Data = HorizonCombo[BASECOMBO];
						if(push){
							Screen->Quake=16;
							for(int i=0; i<8; ++i){
								TAngle = Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y);
								LinkMovement_Push2(VectorX(3, TAngle), VectorY(3, TAngle));
								Link->HitDir=-1;
								NoAction();
								HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
							}
							Game->PlaySound(67);
						}
						if(cycles==2 && Rand(0,1))break;
						else if(cycles==3 && Rand(0,2))break;
					}
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE+2;
					Ghost_Data = HorizonCombo[ATKCOMBO2];
					TAngle = Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8);
					Ghost_Dir=AngleDir4(TAngle);
					eweapon e = FireAimedEWeapon(EW_SOLAR, Ghost_X, Ghost_Y+16, DegtoRad(0), 250, ghost->WeaponDamage, 108, SFX_HORIZONSHOT, EWF_UNBLOCKABLE);
					SetEWeaponMovement(e, EWM_HOMING, DegtoRad(.5), -1);
					RunEWeaponScript(e, "HorizonLargeShot", {0});
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 30);
					Ghost_Data = HorizonCombo[BASECOMBO];
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 30);
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 30);
					break;
				}
				case 2:{ //Rude bullet flower
					int Choice=Choose(-1,1);
					TAngle=Rand(-30,30);
					Ghost_Data = HorizonCombo[WALKINGCOMBO];
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER;
					for(int i=0; i<32; ++i){
						Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
						Ghost_MoveTowardLink(1,1);
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 1);
					}
					Ghost_Data = HorizonCombo[ATKCOMBO1];
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 6);
					for(int shots=0; shots<8; shots++){
						for(int i=1; i<=6; i++){
							eweapon CircleArc1 = FireEWeapon(EW_SOLAR, Ghost_X, Ghost_Y+16, DegtoRad(60*i+TAngle), 130, ghost->WeaponDamage, SPR_HORIZONSPAZER, SFX_HORIZONSHOT, EWF_UNBLOCKABLE|EWF_ROTATE_360);
							SetEWeaponMovement(CircleArc1, EWM_SINE_WAVE, 5*Choice, -12);
							SetEWeaponLifespan(CircleArc1, EWL_TIMER, 150);
							SetEWeaponDeathEffect(CircleArc1, EWD_VANISH, 0);
							CircleArc1->Misc[0]=-1.25;
							RunEWeaponScript(CircleArc1, "HorizonSpazer", {0});
						
							CircleArc1 = FireEWeapon(EW_SOLAR, Ghost_X, Ghost_Y+16, DegtoRad(60*i-TAngle), 130, ghost->WeaponDamage, SPR_HORIZONSPAZER, SFX_HORIZONSHOT, EWF_UNBLOCKABLE|EWF_ROTATE_360);
							SetEWeaponMovement(CircleArc1, EWM_SINE_WAVE, 5*Choice, 12);
							SetEWeaponLifespan(CircleArc1, EWL_TIMER, 150);
							SetEWeaponDeathEffect(CircleArc1, EWD_VANISH, 0);
							CircleArc1->Misc[0]=1.25;
							RunEWeaponScript(CircleArc1, "HorizonSpazer", {0});
							
						}
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 8);
						Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
					}
					Ghost_Data = HorizonCombo[BASECOMBO];
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 24);
					Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
					Ghost_Data = HorizonCombo[ATKCOMBO1];
					for(int i=1; i<=6; ++i){
						TX = Ghost_X+VectorX(12, TAngle+i*60);
						TY = Ghost_Y+16+VectorY(12, TAngle+i*60);
						HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER;
						eweapon e = FireEWeapon(EW_SOLAR, TX, TY, DegtoRad(TAngle+i*60), 0, ghost->WeaponDamage, 108, 0, EWF_UNBLOCKABLE);
						e->CollDetection = false;
						e->DrawYOffset = -1000;
						e->Misc[HL_LINETELEGRAPH]=1;
						e->Misc[HL_WIDTH]=24;
						e->Misc[HL_STARTTIME]=32;
						e->Misc[HL_DURATION]=24;
						RunEWeaponScript(e, "HorizonLaser", {0});
					}
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 32);
					Ghost_Data = HorizonCombo[BASECOMBO];
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 16);
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 16);
					break;
				}
				case 3:{ //Just sit still lmao V2
					TAngle = Angle(Link->X, Link->Y, 120, 88);
					TX = 120+VectorX(32, TAngle);
					TY = 88-16+VectorY(32, TAngle);
					Ghost_Data = HorizonCombo[TELECOMBO];
					Game->PlaySound(SFX_HORIZONTELEPORT);
					ghost->CollDetection=false;
					while(Distance(Ghost_X, Ghost_Y, TX, TY)>3){
						TAngle = Angle(Ghost_X, Ghost_Y, TX, TY);
						Ghost_MoveAtAngle(TAngle, 2, 2);
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					Ghost_X=TX; Ghost_Y=TY;
					ghost->CollDetection=true;
					Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 30);
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER;
					Ghost_Data=HorizonCombo[ATKCOMBO1];
					for(int i=0; i<=1; ++i){
						TAngle = Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8);
						Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
						TX = Ghost_X+VectorX(24, TAngle+90+180*i);
						TY = Ghost_Y+16+VectorY(24, TAngle+90+180*i);
						EArray[i] = FireEWeapon(EW_SOLAR, TX, TY, DegtoRad(TAngle), 0, ghost->Damage, 108, 0, EWF_UNBLOCKABLE);
						EArray[i]->CollDetection = false;
						EArray[i]->DrawYOffset = -1000;
						EArray[i]->Misc[HL_WIDTH]=48;
						EArray[i]->Misc[HL_STARTTIME]=42;
						EArray[i]->Misc[HL_DURATION]=36;
						EArray[i]->Misc[HL_ROTOFFSET]=2.5+i*-5;
						RunEWeaponScript(EArray[i], "HorizonLaser", {0});
					}
					Ghost_Data = HorizonCombo[BASECOMBO];
					if(EArray[0]->isValid())EArray[0]->Misc[HL_LINETELEGRAPH]=1;
					if(EArray[1]->isValid())EArray[1]->Misc[HL_LINETELEGRAPH]=1;
					for(int frames=0; frames<42+64+16; ++frames){
						if(frames>42){
							if(EArray[0]->isValid())EArray[0]->Angle+=DegtoRad(EArray[0]->Misc[HL_ROTOFFSET]);
							if(EArray[1]->isValid())EArray[1]->Angle+=DegtoRad(EArray[1]->Misc[HL_ROTOFFSET]);
						}
						else if(frames==36){
							for(int i=-1; i<=1; ++i){
								TX = Ghost_X+VectorX(16, TAngle);
								TY = Ghost_Y+16+VectorY(16, TAngle);
								int FX = TX+VectorX(20*i, TAngle+90);
								int FY = TY+VectorY(20*i, TAngle+90);
								EArray[i+3]= FireEWeapon(EW_SOLAR, FX, FY, DegtoRad(TAngle),0, ghost->Damage, 108, 0, EWF_UNBLOCKABLE);
								EArray[i+3]->CollDetection = false;
								EArray[i+3]->DrawYOffset = -1000;
								EArray[i+3]->Misc[HPT_MODE] = 0;
								EArray[i+3]->Misc[HPT_FIRINGDELAY] = 42;
								EArray[i+3]->Misc[HPT_EXTENDINGTIME] = 32;
								EArray[i+3]->Misc[HPT_CHAINTARGETLENGTH] = 250;
								RunEWeaponScript(EArray[i+3], "HorizonGilgameshPosting", {0});
							}
						}
						if(frames==42+64){
							if(EArray[2]->isValid())EArray[2]->Misc[HPT_EXTENDINGTIME] = 0;
							if(EArray[3]->isValid())EArray[3]->Misc[HPT_EXTENDINGTIME] = 0;
							if(EArray[4]->isValid())EArray[4]->Misc[HPT_EXTENDINGTIME] = 0;
						}
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}				
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
					Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
					
					
					break;
				}
				case 4:{ //Tri-orbiting beams that fire swarmshots before firing. Also shockwave at the end.
					Ghost_Data=HorizonCombo[WALKINGCOMBO];
					for(int i=0; i<30; i++){
						int AttackAngle = Angle(Ghost_X, Ghost_Y+16, 120, 88);
						Ghost_MoveAtAngle(AttackAngle, .75, 2);
						Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y));
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 1);
					}
					Ghost_Data = HorizonCombo[ATKCOMBO1];
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER;
					Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
					int Length = 4;
					TAngle=Rand(359);
					int TAngle2;
					for(int i=0; i<3; ++i){
						TAngle2 = TAngle+i*120;
						TX=Ghost_X+VectorX(Length, TAngle2);
						TY=Ghost_Y+16+VectorY(Length, TAngle2);
						
						eweapon e = FireEWeapon(EW_SOLAR, TX, TY, DegtoRad(TAngle2), 0, ghost->Damage, 108, 0, EWF_UNBLOCKABLE);
						e->CollDetection = false;
						e->DrawYOffset = -1000;
						e->Misc[HL_LINETELEGRAPH]=0;
						e->Misc[HL_WIDTH]=48;
						e->Misc[HL_STARTTIME]=120+260;
						e->Misc[HL_DURATION]=84;
						e->Misc[HL_ROTOFFSET]=2;
						EArray[i]=e;
						RunEWeaponScript(e, "HorizonLaser", {0});
					}
					
					for(int frames=0; frames<200+260; ++frames){
						Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
						if(frames==30)Ghost_Data = HorizonCombo[BASECOMBO];
						if(Length<48 && frames%3==0)Length++;
						for(int i=0; i<3; ++i){
							if(EArray[i]->isValid()){
								EArray[i]->Angle+=DegtoRad(EArray[i]->Misc[HL_ROTOFFSET]);
								TAngle2 = RadtoDeg(EArray[i]->Angle);
								TX=Ghost_X+VectorX(Length, TAngle2);
								TY=Ghost_Y+16+VectorY(Length, TAngle2);
								EArray[i]->X=TX;
								EArray[i]->Y=TY;
								if(frames==80)EArray[i]->Misc[HL_LINETELEGRAPH]=1;
								if(EArray[i]->Misc[HL_STARTTIME]==0)EArray[i]->Misc[HL_ROTOFFSET]=4.5;
								
								if(frames>=48 && frames<200 && frames%12==i*3){
									int g=Rand(0,2);
									eweapon e = FireAimedEWeapon(EW_SOLAR, EArray[i]->X, EArray[i]->Y, DegtoRad(Rand(359)), 125+50*g, ghost->WeaponDamage, 108, 0, EWF_UNBLOCKABLE);
									e->CollDetection = false;
									e->DrawYOffset = -1000;
									e->Misc[HSS_MAXRADIUS]=20;
									e->Misc[HSS_WANDERTIME]=48;
									e->Misc[HSS_SHOTDELAY]=Max(200-frames, 24);
									e->Misc[HSS_MAXVEER]=45+15*g;
									e->Misc[HSS_STEPDECAY]=5+5*g;
									RunEWeaponScript(e, "HorizonSwarmSphere", {0});
								}
							}
						}
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 1);
					}
					Ghost_Data = HorizonCombo[BASECOMBO];
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
					Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 10);
					if(Distance(Link->X+8, Link->Y+8, Ghost_X+8, Ghost_Y+24)<=48){
						Ghost_Data = HorizonCombo[HOLDUPCOMBO];
						HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER;
						Game->PlaySound(35);
						for(int frames=0; frames<32; ++frames){
							TX = Ghost_X+4;
							TY = Ghost_Y+13;
							Screen->Circle(3, TX, TY, 1+frames/5+Rand(0,6), Screen->D[D_HORIZON_FX], 1, 0, 0, 0, true, OP_OPAQUE);
							
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
						}
						
						Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
						Game->PlaySound(37);
						bool push=false;
						Screen->Quake=32;
						for(int frames=0; frames<16; ++frames){
							DrawEnergyRing(4, TX+Rand(-1,1), TY+Rand(-1,1), frames*4, frames/2, frames/2, Screen->D[D_HORIZON_FX], 24, Rand(359));
							if(Distance(Ghost_X, Ghost_Y+16, Link->X, Link->Y)<=(frames*4)){
								DamageLinkSolar(ghost->Damage);
								push=true;
							}
							if(push){
								TAngle = Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y);
								LinkMovement_Push2(VectorX(4, TAngle), VectorY(4, TAngle));
								Link->HitDir=-1;
								NoAction();
							}
							
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
						}
						HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
						Ghost_Data = HorizonCombo[BASECOMBO];
						if(push){
							Screen->Quake=16;
							for(int i=0; i<8; ++i){
								TAngle = Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y);
								LinkMovement_Push2(VectorX(3, TAngle), VectorY(3, TAngle));
								Link->HitDir=-1;
								NoAction();
								HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
							}
							Game->PlaySound(67);
						}
					}
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 10);
					
					break;
				}
				case 5:{ //Laser Hand with sine shots in the gaps.
					
					Ghost_Data=HorizonCombo[WALKINGCOMBO];
					int AttackAngle;
					for(int i=0; i<30; i++){
						AttackAngle = Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y);
						Ghost_MoveAtAngle(AttackAngle+180, .75, 2);
						Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y));
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 1);
					}
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER;
					Ghost_Data=HorizonCombo[ATKCOMBO1];
					for(int i=-3; i<=3; ++i){
						TAngle = AttackAngle+i*30;
						TX = Ghost_X+VectorX(12, TAngle);
						TY = Ghost_Y+16+VectorY(12, TAngle);
						
						eweapon e = FireEWeapon(EW_SOLAR, TX+InFrontX(Ghost_Dir, 8), TY+InFrontY(Ghost_Dir,8), DegtoRad(TAngle), 0, ghost->WeaponDamage, 108, 0, EWF_UNBLOCKABLE);
						e->CollDetection = false;
						e->DrawYOffset = -1000;
						e->Misc[HL_WIDTH]=24;
						e->Misc[HL_STARTTIME]=32;
						e->Misc[HL_DURATION]=72;
						e->Misc[HL_LINETELEGRAPH]=1;
						RunEWeaponScript(e, "HorizonLaser", {0});
						
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 3);
					}
					int Choice=Choose(-6,6);
					for(int g=0; g<5; ++g){
						for(int i=-60; i<=120; i+=30){
							eweapon CircleArc1 = FireEWeapon(EW_SOLAR, Ghost_X, Ghost_Y+16, DegtoRad(AttackAngle+i-45), 150, ghost->WeaponDamage, SPR_HORIZONSPAZER, SFX_HORIZONSHOT, EWF_UNBLOCKABLE|EWF_ROTATE_360);
							SetEWeaponMovement(CircleArc1, EWM_SINE_WAVE, 4*4, Choice);
							SetEWeaponLifespan(CircleArc1, EWL_TIMER, 200);
							SetEWeaponDeathEffect(CircleArc1, EWD_VANISH, 0);
						}
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 8);
					}
					Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y));
					Ghost_Data=HorizonCombo[BASECOMBO];
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 60);
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 48);
					
					break;
				}
				//Extra rude shit from here on down that happens below 60% health
				case 6:{ //Rapid teleports to the player's location with some miniature overlapping bullet flowers after each one
					for(int cycles=0; cycles<3; cycles++){
						TX = Link->X; TY = Link->Y;
						Ghost_Data = HorizonCombo[TELECOMBO];
						Game->PlaySound(SFX_HORIZONTELEPORT);
						ghost->CollDetection=false;
						int breaktime;
						while(Distance(Ghost_X, Ghost_Y+16, TX, TY)>4){
							breaktime++;
							if(breaktime>60)break;
							TAngle = Angle(Ghost_X, Ghost_Y+16, TX, TY);
							Ghost_MoveAtAngle(TAngle, 2, 2);
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
						}
						TAngle = Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8);
						Ghost_Dir=AngleDir4(TAngle);
						Ghost_Data=HorizonCombo[ATKCOMBO1];
						
						ghost->CollDetection=true;
						HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE+2;
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 6);
						TAngle=Rand(359);
						int Choice=Choose(-1,1);
						for(int shots=0; shots<6; shots++){
							for(int i=1; i<=5; i++){
								eweapon CircleArc1 = FireEWeapon(EW_SOLAR, Ghost_X, Ghost_Y+16, DegtoRad(70*i+TAngle), 150, ghost->WeaponDamage, SPR_HORIZONSPAZER, SFX_HORIZONSHOT, EWF_UNBLOCKABLE|EWF_ROTATE_360);
								SetEWeaponMovement(CircleArc1, EWM_SINE_WAVE, -3*Choice, 15);
								SetEWeaponLifespan(CircleArc1, EWL_TIMER, 200);
								SetEWeaponDeathEffect(CircleArc1, EWD_VANISH, 0);
								CircleArc1->Misc[0]=1.3;
								RunEWeaponScript(CircleArc1, "HorizonSpazer", {0});
							
								CircleArc1 = FireEWeapon(EW_SOLAR, Ghost_X, Ghost_Y+16, DegtoRad(70*i-TAngle), 150, ghost->WeaponDamage, SPR_HORIZONSPAZER, SFX_HORIZONSHOT, EWF_UNBLOCKABLE|EWF_ROTATE_360);
								SetEWeaponMovement(CircleArc1, EWM_SINE_WAVE, 3*Choice, 15);
								SetEWeaponLifespan(CircleArc1, EWL_TIMER, 200);
								SetEWeaponDeathEffect(CircleArc1, EWD_VANISH, 0);
								CircleArc1->Misc[0]=-1.3;
								RunEWeaponScript(CircleArc1, "HorizonSpazer", {0});
								
							}
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 6);
						}
						Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
						Ghost_Data=HorizonCombo[BASECOMBO];
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 32);
						HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
					}
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 32);
					break;
				}
				case 7:{ //Rotating Aimed large beams
					eweapon e;
					for(int Cycles=0; Cycles<4; Cycles++){
						do{
							TX= Rand(56, 192);
							TY= Rand(48, 120)-16;
						}while(Distance(Ghost_X, Ghost_Y, TX, TY)<48);
						
						TAngle = Angle(Ghost_X, Ghost_Y, TX, TY);
						Ghost_Data = HorizonCombo[TELECOMBO];
						Game->PlaySound(SFX_HORIZONTELEPORT);
						ghost->CollDetection=false;
						int breaktime;
						while(Distance(Ghost_X, Ghost_Y, TX, TY)>3){
							breaktime++;
							if(e->isValid() && breaktime==16)e->Misc[HL_LINETELEGRAPH]=1;
							if(breaktime==40)break;
							TAngle = Angle(Ghost_X, Ghost_Y, TX, TY);
							Ghost_MoveAtAngle(TAngle, 2, 2);
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
						}
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 40-breaktime);
						if(e->isValid()){
							e->Misc[HL_LINETELEGRAPH]=1;
							e->Misc[HL_AUTOTRACK]=1;
							e->Misc[HL_ROTOFFSET]=.7;
						}
						
						Ghost_X=TX; Ghost_Y=TY;
						ghost->CollDetection=true;
						Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
						HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER;
						Ghost_Data=HorizonCombo[ATKCOMBO1];
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 8);
						
						e = FireAimedEWeapon(EW_SOLAR, Ghost_X, Ghost_Y+16, DegtoRad(0), 0, ghost->Damage, 108, 0, EWF_UNBLOCKABLE);
						e->CollDetection = false;
						e->DrawYOffset = -1000;
						e->Misc[HL_WIDTH]=48;
						e->Misc[HL_STARTTIME]=48;
						e->Misc[HL_DURATION]=80;
						RunEWeaponScript(e, "HorizonLaser", {0});
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 8);
						Ghost_Data = HorizonCombo[BASECOMBO];
					}
					
					Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 32);
					if(e->isValid()){
						e->Misc[HL_LINETELEGRAPH]=1;
						e->Misc[HL_AUTOTRACK]=1;
						e->Misc[HL_ROTOFFSET]=.7;
					}
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 32);
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
					break;
				}
				case 8:{ //Solar greatsword swing summoning swarmshots out of the tip
					TAngle = Angle(Link->X, Link->Y, 120, 88);
					TX = 120+VectorX(20, TAngle);
					TY = 88+VectorY(20, TAngle);
					Ghost_Data = HorizonCombo[TELECOMBO];
					Game->PlaySound(SFX_HORIZONTELEPORT);
					ghost->CollDetection=false;
					int breaktime;
					while(Distance(Ghost_X, Ghost_Y+16, TX, TY)>3){
						breaktime++;
						if(breaktime>120)break;
						TAngle = Angle(Ghost_X, Ghost_Y+16, TX, TY);
						Ghost_MoveAtAngle(TAngle, 1.5, 2);
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					TAngle = Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8);
					ghost->CollDetection=true;
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER;
					Ghost_Dir=AngleDir4(TAngle);
					Ghost_Data=HorizonCombo[ATKCOMBO1];
					int j=Choose(-1,1); int i; int k;
					Game->PlaySound(SFX_STELLARSWORD_APPEAR);
					for(i=0; i<5; ++i){
						for(k=0; k<2; ++k){
							DrawHorizonSword(Ghost_X, Ghost_Y+16, TAngle-90*j, 8, i, ghost->Damage*1.5, 0, 0, 0);
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
						}
					}
					for(i=0; i<72; ++i){
						DrawHorizonSword(Ghost_X, Ghost_Y+16, TAngle-90*j, 8, 5, ghost->Damage*1.5, -0, 0, 0);
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					Game->PlaySound(SFX_STELLARSWORD_SLASH);
					for(i=30; i<180+45; i+=15){
						
						DrawHorizonSword(Ghost_X, Ghost_Y+16, TAngle-90*j+i*j, 12, 5, ghost->Damage*1.5, TAngle-90*j+i*j -(i-45)*j, 30, 0);
						
						TX = Ghost_X+VectorX(8+4*16, TAngle-90*j+i*j);
						TY = Ghost_Y+16+VectorY(8+4*16, TAngle-90*j+i*j);
						eweapon e = FireAimedEWeapon(EW_SOLAR, TX, TY, DegtoRad(Rand(359)), 150, ghost->WeaponDamage, 108, 0, EWF_UNBLOCKABLE);
						e->CollDetection = false;
						e->DrawYOffset = -1000;
						e->Misc[HSS_MAXRADIUS]=24;
						e->Misc[HSS_WANDERTIME]=32;
						e->Misc[HSS_SHOTDELAY]=16+(i/20);
						e->Misc[HSS_MAXVEER]=60;
						e->Misc[HSS_STEPDECAY]=5;
						RunEWeaponScript(e, "HorizonSwarmSphere", {0});
						
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					for(i=5; i>1; --i){
						DrawHorizonSword(Ghost_X, Ghost_Y+16, TAngle-90*j+180*j, 8, i, ghost->Damage*1.5, 0, 0, 0);
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 32);
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 32);
					
					break;
				}
				case 9:{ //Tri-orbiting beams with F I S T
					
					TX=120; TY=72;
					Ghost_Data = HorizonCombo[TELECOMBO];
					Game->PlaySound(SFX_HORIZONTELEPORT);
					ghost->CollDetection=false;
					while(Distance(Ghost_X, Ghost_Y, TX, TY)>3){
						TAngle = Angle(Ghost_X, Ghost_Y, TX, TY);
						Ghost_MoveAtAngle(TAngle, 2, 2);
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					Ghost_X=TX; Ghost_Y=TY;
					Ghost_Data=HorizonCombo[ATKCOMBO1];
					ghost->CollDetection=true;
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER;
					Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
					int Length = 4;
					TAngle=Rand(359);
					int TAngle2;
					for(int i=0; i<3; ++i){
						TAngle2 = TAngle+i*120;
						TX=Ghost_X+VectorX(Length, TAngle2);
						TY=Ghost_Y+16+VectorY(Length, TAngle2);
						
						eweapon e = FireEWeapon(EW_SOLAR, TX, TY, DegtoRad(TAngle2), 0, ghost->Damage, 108, 0, EWF_UNBLOCKABLE);
						e->CollDetection = false;
						e->DrawYOffset = -1000;
						e->Misc[HL_LINETELEGRAPH]=0;
						e->Misc[HL_WIDTH]=48;
						e->Misc[HL_STARTTIME]=120;
						e->Misc[HL_DURATION]=84+40+8;
						e->Misc[HL_ROTOFFSET]=2;
						EArray[i]=e;
						RunEWeaponScript(e, "HorizonLaser", {0});
					}
					
					for(int frames=0; frames<200+40; ++frames){
						Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
						if(frames==120){
							Ghost_Data = HorizonCombo[TELECOMBO];
							ghost->CollDetection=false;
							Game->PlaySound(SFX_HORIZONTELEPORT);
							
							for(int i=0; i<5; ++i){
								TX=Ghost_X+VectorX(64, TAngle+360/6*i);
								TY=Ghost_Y+16+VectorY(64, TAngle+360/6*i);
								
								eweapon e = FireEWeapon(EW_SOLAR, TX, TY, DegtoRad(TAngle+180+360/6*i), 0, ghost->Damage/2, 108, 97, EWF_UNBLOCKABLE);
								if(i%2==0)e->Tile=TIL_HORIZONFIST1;
								else e->Tile = TIL_HORIZONFIST2;
								e->CSet=3;
								e->DrawYOffset=1000;
								e->CollDetection=false;
								int Goddamnit[8];
								Goddamnit[0]=64;
								Goddamnit[1]=152;
								Goddamnit[2]=8;
								Goddamnit[3]=24;
								Goddamnit[4]=12;
								EArray[i+3]=e;
								RunEWeaponScript(e, "HorizonWeave", Goddamnit);
							}
						}
						if(Length<44 && frames%3==0)Length++;
						
						
						for(int i=0; i<8; ++i){
							if(EArray[i]->isValid() && i<3 && frames<188+40){ //Rotlaser upkeep
								EArray[i]->Angle+=DegtoRad(EArray[i]->Misc[HL_ROTOFFSET]);
								TAngle2 = RadtoDeg(EArray[i]->Angle);
								TX=Ghost_X+VectorX(Length, TAngle2);
								TY=Ghost_Y+16+VectorY(Length, TAngle2);
								EArray[i]->X=TX;
								EArray[i]->Y=TY;
								if(frames==80)EArray[i]->Misc[HL_LINETELEGRAPH]=1;
								if(EArray[i]->Misc[HL_STARTTIME]==0)EArray[i]->Misc[HL_ROTOFFSET]=4.5;
							}
							if(EArray[i]->isValid() && i>2 && frames<188+40){ //Fist upkeep
								TAngle2 = RadtoDeg(EArray[i]->Angle);
								TAngle2-=6;
								TX=Ghost_X+VectorX(64, TAngle2+180);
								TY=Ghost_Y+16+VectorY(64, TAngle2+180);
								EArray[i]->X=TX;
								EArray[i]->Y=TY;
								EArray[i]->Angle=DegtoRad(TAngle2);
							}
						}
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 1);
					}
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 24);
					Ghost_Data=HorizonCombo[BASECOMBO];
					ghost->CollDetection=true;
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
					Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 24);
					
					
					break;
				}
				case 10:{ //Sundog grid with purging thorn slams
					Ghost_Data = HorizonCombo[HOLDUPCOMBO];
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER;
					
					//There's definitely a more elegant way to do this, but I'm too braindead to do it right now
					//Bottom pair
					eweapon e = FireNonAngularEWeapon(EW_SOLAR, 88, 160, DIR_UP, 0, ghost->WeaponDamage, 108, 39, EWF_UNBLOCKABLE);
					ConfigureSundog(e, DIR_UP, 120, 2, 120);
					
					e = FireNonAngularEWeapon(EW_SOLAR, 152, 160, DIR_UP, 0, ghost->WeaponDamage, 108, 39, EWF_UNBLOCKABLE);
					ConfigureSundog(e, DIR_UP, 60, 2, 120);
					//Upper pair
					e = FireNonAngularEWeapon(EW_SOLAR, 88, 24, DIR_DOWN, 0, ghost->WeaponDamage, 108, 39, EWF_UNBLOCKABLE);
					ConfigureSundog(e, DIR_DOWN, 60, 2, 120);
					
					e = FireNonAngularEWeapon(EW_SOLAR, 152, 24, DIR_DOWN, 0, ghost->WeaponDamage, 108, 39, EWF_UNBLOCKABLE);
					ConfigureSundog(e, DIR_DOWN, 120, 2, 120);
					//Side Pair
					e = FireNonAngularEWeapon(EW_SOLAR, 24, 88, DIR_RIGHT, 0, ghost->WeaponDamage, 108, 39, EWF_UNBLOCKABLE);
					ConfigureSundog(e, DIR_RIGHT, 120, 2, 120);
					
					e = FireNonAngularEWeapon(EW_SOLAR, 216, 88, DIR_LEFT, 0, ghost->WeaponDamage, 108, 39, EWF_UNBLOCKABLE);
					ConfigureSundog(e, DIR_LEFT, 60, 2, 120);
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 20);
					Ghost_Data = HorizonCombo[TELECOMBO];
					Game->PlaySound(SFX_HORIZONTELEPORT);
					ghost->CollDetection=false;
					int ThornX[] = {16, 224, 56, 184, 96, 144};
					for(int Thorns=0; Thorns<6; ++Thorns){
						eweapon e = FireAimedEWeapon(EW_SOLAR, ThornX[Thorns], 4, DegtoRad(0), 0, ghost->Damage, 108, 0, EWF_UNBLOCKABLE);
						e->CollDetection = false;
						e->DrawYOffset = -1000;
						e->Misc[HPT_MODE] = 1;
						e->Misc[HPT_FIRINGDELAY] = 45+240/6*(Thorns+1);
						e->Misc[HPT_AUTOTRACK]=.25+Thorns*0.225;
						e->Misc[HPT_TARGETX]=Link->X+8;
						e->Misc[HPT_TARGETY]=Link->Y+8;
						RunEWeaponScript(e, "HorizonGilgameshPosting", {0});
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 10);
					}
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 240);
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
					Ghost_Data=HorizonCombo[BASECOMBO];
					ghost->CollDetection=true;
					Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 64);
					break;
				}
				case 11:{ //Lattice of the Heavens 3.0
					int TX = 32;
					if(Link->X<120)TX = 208;
					TY = 88-16;
					Ghost_Data = HorizonCombo[TELECOMBO];
					Game->PlaySound(SFX_HORIZONTELEPORT);
					ghost->CollDetection=false;
					while(Distance(Ghost_X, Ghost_Y, TX, TY)>3){
						TAngle = Angle(Ghost_X, Ghost_Y, TX, TY);
						Ghost_MoveAtAngle(TAngle, 2, 2);
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					Ghost_X=TX; Ghost_Y=TY;
					ghost->CollDetection=true;
					Ghost_Data=HorizonCombo[ATKCOMBO1];
					int TX2 = TX; int TY2 = TX;
					for(int cycles; cycles<3; cycles++){
						TX = TX2; TY = TY2;
						TAngle = Angle(Ghost_X, Ghost_Y+16, 120, 88);
						Ghost_Dir=AngleDir4(TAngle);
						int LAngle1 = TAngle+45;
						int LAngle2 = TAngle-45;
						HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER;
						int InitialOffset=0;
						if(cycles%2==1)InitialOffset=8;
						for(int i=InitialOffset; i<128; i+=24){
							TX = Ghost_X+VectorX(i, LAngle1);
							TY = Ghost_Y+16+VectorY(i, LAngle1);
							
							eweapon e = FireEWeapon(EW_SOLAR, TX, TY, DegtoRad(LAngle1-90), 0, ghost->WeaponDamage, 108, 0, EWF_UNBLOCKABLE);
							e->CollDetection = false;
							e->DrawYOffset = -1000;
							e->Misc[HL_LINETELEGRAPH]=1;
							e->Misc[HL_WIDTH]=16;
							e->Misc[HL_STARTTIME]=36+i/6;
							e->Misc[HL_DURATION]=72;
							RunEWeaponScript(e, "HorizonLaser", {0});
							
							TX = Ghost_X+VectorX(i, LAngle2);
							TY = Ghost_Y+16+VectorY(i, LAngle2);
							
							e = FireEWeapon(EW_SOLAR, TX, TY, DegtoRad(LAngle2+90), 0, ghost->WeaponDamage, 108, 0, EWF_UNBLOCKABLE);
							e->CollDetection = false;
							e->DrawYOffset = -1000;
							e->Misc[HL_LINETELEGRAPH]=1;
							e->Misc[HL_WIDTH]=16;
							e->Misc[HL_STARTTIME]=36+i/6;
							e->Misc[HL_DURATION]=72;
							RunEWeaponScript(e, "HorizonLaser", {0});
							
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 8);
						}
						if(cycles==0){
							TX = 240-Ghost_X;
							TY = Ghost_Y+16;
							if(TX<120)TX-=24;
							else TX+=24;
							eweapon e = FireEWeapon(EW_SOLAR, TX, TY, DegtoRad(TAngle+180-45), 0, ghost->Damage, 108, 0, EWF_UNBLOCKABLE);
							e->CollDetection = false;
							e->DrawYOffset = -1000;
							e->Misc[HL_LINETELEGRAPH]=1;
							e->Misc[HL_WIDTH]=48;
							e->Misc[HL_STARTTIME]=48;
							e->Misc[HL_DURATION]=80*3;
							RunEWeaponScript(e, "HorizonLaser", {0});
							
							e = FireEWeapon(EW_SOLAR, TX, TY, DegtoRad(TAngle+180+45), 0, ghost->Damage, 108, 0, EWF_UNBLOCKABLE);
							e->CollDetection = false;
							e->DrawYOffset = -1000;
							e->Misc[HL_LINETELEGRAPH]=1;
							e->Misc[HL_WIDTH]=48;
							e->Misc[HL_STARTTIME]=48;
							e->Misc[HL_DURATION]=80*3;
							RunEWeaponScript(e, "HorizonLaser", {0});
						
							Ghost_Data=HorizonCombo[TELECOMBO];
							ghost->CollDetection=false;
							Game->PlaySound(SFX_HORIZONTELEPORT);
						}
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 64);
					}
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
					ghost->CollDetection=true;
					Ghost_Data=HorizonCombo[BASECOMBO];
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray, HorizonCombo, 24);
					
					
					break;
				}
				//Supers
				case 101:{ //Sun Sphere-cage Combo that nobody asked for nor wanted!
					SodOffSuns(NPCArray);
					
					TX=120; TY=72;
					Ghost_Data = HorizonCombo[TELECOMBO];
					Game->PlaySound(SFX_HORIZONTELEPORT);
					ghost->CollDetection=false;
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_BRIGHT;
					while(Distance(Ghost_X, Ghost_Y, TX, TY)>3){
						TAngle = Angle(Ghost_X, Ghost_Y, TX, TY);
						Ghost_MoveAtAngle(TAngle, 2, 2);
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					Ghost_X=TX; Ghost_Y=TY;
					
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 48);
					TAngle = Rand(359);
					for(int i=0; i<2; ++i){
						TX = Ghost_X+VectorX(16, TAngle+180*i);
						TY = Ghost_Y+16+VectorY(16, TAngle+180*i);
						EArray[i]= FireEWeapon(EW_SOLAR, TX, TY, DegtoRad(TAngle+180*i),0, ghost->Damage, 108, 0, EWF_UNBLOCKABLE);
						EArray[i]->CollDetection = false;
						EArray[i]->DrawYOffset = -1000;
						EArray[i]->Misc[HPT_MODE] = 0;
						EArray[i]->Misc[HPT_FIRINGDELAY] = 32;
						EArray[i]->Misc[HPT_EXTENDINGTIME] = 600;
						EArray[i]->Misc[HPT_CHAINTARGETLENGTH] = 150;
						RunEWeaponScript(EArray[i], "HorizonGilgameshPosting", {0});
					}
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 12);
					int Radius = 200;
					int InnerRadius=16;
					int RadiusOffset=0;
					HorizonArray[_MANUALCOLORCHANGE]=1;
					int FAngle;
					for(int frames=0; frames<90; frames++){
						if(frames>20){
							for(int i=0; i<2; ++i){
								EArray[i]->X = Ghost_X+VectorX(12, TAngle+180*i);
								EArray[i]->Y = Ghost_Y+16+VectorY(12, TAngle+180*i);
								EArray[i]->Angle = DegtoRad(TAngle+180*i);
								EArray[i]->Misc[HPT_CHAINTARGETLENGTH]=Radius;
							}
						}
						if(Radius>80)Radius-=2;
						else if(Radius<80)Radius=80;
						
						if(InnerRadius<32)InnerRadius++;
						
						if(frames%2==0)Screen->D[D_HORIZON_FX] = Choose(C_WHITE, Rand(C_GOLD1-3, C_GOLD2-3), Rand(C_GOLD1, C_GOLD2));
						InvertedCircle(3, CenterX(ghost), HitboxCenterY(ghost), Radius+Rand(-1,0), Screen->D[D_HORIZON_FX]);
						Screen->Circle(2, CenterX(ghost), HitboxCenterY(ghost), InnerRadius+3+Rand(-1,1), C_WHITE, 1, 0, 0, 0, true, OP_TRANS);
						Screen->Circle(3, CenterX(ghost), HitboxCenterY(ghost), InnerRadius+Rand(-1,1), Screen->D[D_HORIZON_FX], 1, 0, 0, 0, true, OP_OPAQUE);
						
						if(Distance(Link->X, Link->Y, Ghost_X, Ghost_Y+16)>Radius || Distance(Link->X, Link->Y, Ghost_X, Ghost_Y+16)<InnerRadius){
							DamageLinkSolar(ghost->Damage*1.5);
						}
						
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					
					for(int frames=0; frames<660; frames++){
						
						if(frames==550){
							int ThornX[] = {18, 232, 48, 192, 84, 156, 104, 136};
							for(int Thorns=0; Thorns<8; ++Thorns){
								TX=Ghost_X+VectorX(48, TAngle+45*Thorns);
								TY=Ghost_Y+16+VectorY(48, TAngle+45*Thorns);
								eweapon e = FireAimedEWeapon(EW_SOLAR, ThornX[Thorns], 4, DegtoRad(0), 0, ghost->Damage, 108, 0, EWF_UNBLOCKABLE);
								e->CollDetection = false;
								e->DrawYOffset = -1000;
								e->Misc[HPT_MODE] = 1;
								e->Misc[HPT_FIRINGDELAY] = 80+50;
								e->Misc[HPT_TARGETX]=TX+8;
								e->Misc[HPT_TARGETY]=TY+8;
								RunEWeaponScript(e, "HorizonGilgameshPosting", {0});
							}
						}
						if(frames<420)TAngle = WrapDegrees(TAngle+.75);
						else if(frames>450 && frames<=600)TAngle = WrapDegrees(TAngle-.9);
						
						if(frames<=600){
							
							RadiusOffset = Sin(frames*2)*16;
							
							if(frames%70==0 && frames>0){
								FAngle=Rand(360);
								for(int i=0; i<10; ++i){
									TX=Ghost_X+VectorX(8, FAngle+36*i);
									TY=Ghost_Y+16+VectorY(8, FAngle+36*i);
									eweapon e = FireEWeapon(EW_SOLAR, TX, TY, DegtoRad(FAngle+36*i), 0, ghost->WeaponDamage, 108, 0, EWF_UNBLOCKABLE);
									e->CollDetection = false;
									e->DrawYOffset = -1000;
									e->Misc[HL_LINETELEGRAPH]=1;
									e->Misc[HL_WIDTH]=16;
									e->Misc[HL_STARTTIME]=48;
									e->Misc[HL_DURATION]=16;
									RunEWeaponScript(e, "HorizonLaser", {0});
								}
							}
						}
						else{
							if(frames%2==0){
								if(RadiusOffset>1)RadiusOffset--;
								else if(RadiusOffset<-1)RadiusOffset++;
								else RadiusOffset=0;
							}
						}
						for(int i=0; i<2; ++i){
							EArray[i]->X = Ghost_X+VectorX(12, TAngle+180*i);
							EArray[i]->Y = Ghost_Y+16+VectorY(12, TAngle+180*i);
							EArray[i]->Angle = DegtoRad(TAngle+180*i);
							EArray[i]->Misc[HPT_CHAINTARGETLENGTH]=Radius+RadiusOffset;
						}
						
						if(frames%2==0)Screen->D[D_HORIZON_FX] = Choose(C_WHITE, Rand(C_GOLD1-3, C_GOLD2-3), Rand(C_GOLD1, C_GOLD2));
						InvertedCircle(5, CenterX(ghost), HitboxCenterY(ghost), Radius+RadiusOffset+Rand(-1,0), Screen->D[D_HORIZON_FX]);
						Screen->Circle(2, CenterX(ghost), HitboxCenterY(ghost), InnerRadius+RadiusOffset+3+Rand(-1,1), C_WHITE, 1, 0, 0, 0, true, OP_TRANS);
						Screen->Circle(3, CenterX(ghost), HitboxCenterY(ghost), InnerRadius+RadiusOffset+Rand(-1,1), Screen->D[D_HORIZON_FX], 1, 0, 0, 0, true, OP_OPAQUE);
						
						if(Distance(Link->X, Link->Y, Ghost_X, Ghost_Y+16)>Radius+RadiusOffset || Distance(Link->X, Link->Y, Ghost_X, Ghost_Y+16)<InnerRadius+RadiusOffset){
							DamageLinkSolar(ghost->Damage*1.5);
						}
						
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					EArray[0]->Misc[HPT_EXTENDINGTIME] = 0;
					EArray[1]->Misc[HPT_EXTENDINGTIME] = 0;
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
					for(int i=0; i<48; ++i){
						if(i%2==0)Screen->D[D_HORIZON_FX] = Choose(C_WHITE, Rand(C_GOLD1-3, C_GOLD2-3), Rand(C_GOLD1, C_GOLD2));
						InvertedCircle(5, CenterX(ghost), HitboxCenterY(ghost), Radius+i*3, Screen->D[D_HORIZON_FX]);
						Screen->Circle(2, Ghost_X+8, Ghost_Y+22-(i/(48/4)), 14-(48-i)/3, C_WHITE, 1, 0, 0, 0, true, OP_TRANS);
						Screen->Circle(4, Ghost_X+8, Ghost_Y+22-(i/(48/4)), 12-(48-i)/3, Screen->D[D_HORIZON_FX], 1, 0, 0, 0, true, OP_OPAQUE);
						if(Distance(Link->X, Link->Y, Ghost_X, Ghost_Y+16)>Radius+i*3 || Distance(Link->X, Link->Y, Ghost_X, Ghost_Y+16)<12){
							DamageLinkSolar(ghost->Damage*1.5);
						}
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					HorizonArray[_MANUALCOLORCHANGE]=0;
					Ghost_Data = HorizonCombo[BASECOMBO];
					Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
					ghost->CollDetection=true;
					Phase=3;
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 12);
					
					do{
						CharacterAttackMod = Rand(0,2);
					}while(CharacterAttackMod == Attackcount%3);
					Ghost_HP = MaxHP-HORIZON_THIRDHP/5*2;
					ghost->HP = Ghost_HP;
					ghost->Misc[NPCM_DAMAGENUMBERSLASTHP] = ghost->HP;
					break;
				}
				case 102:{ //Solar Finality
					SodOffSuns(NPCArray);
					
					Ghost_SetFlag(GHF_IGNORE_ALL_TERRAIN);
					TX=120; TY=0;
					Ghost_Data = HorizonCombo[TELECOMBO];
					Game->PlaySound(SFX_HORIZONTELEPORT);
					ghost->CollDetection=false;
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE+2;
					while(Distance(Ghost_X, Ghost_Y, TX, TY)>3){
						TAngle = Angle(Ghost_X, Ghost_Y, TX, TY);
						Ghost_MoveAtAngle(TAngle, 2, 2);
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					Ghost_X=TX; Ghost_Y=TY;
					
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER;
					bitmap swordA = Game->CreateBitmap(256, 176);
					swordA->Own();
					bitmap swordB = Game->CreateBitmap(256, 176);
					swordB->Own();
					bitmap scrnBuffer = Game->CreateBitmap(256, 176);
					scrnBuffer->Own();
					bitmap dissolveMask = Game->CreateBitmap(256, 176);
					dissolveMask->Own();
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 48);
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_BRIGHT;
					Game->PlaySound(SFX_HORIZONBEEGRUMBLE);
					for(int i=180; i>0; --i){
						Screen->Quake=32;
						for(int g=0; g<2; ++g){
							Screen->Circle(1, 128, 96, 2+i/3+g, Screen->D[D_HORIZON_FX], 1, 0, 0, 0, false, OP_OPAQUE);
						}
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					HorizonArray[_BACKGROUNDTOGGLE]=0;
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_YEET;
					for(int i=36; i>0; --i){
						Screen->Quake=0;
						for(int g=0; g<2; ++g){
							Screen->Circle(1,128, 96, 2+g, Screen->D[D_HORIZON_FX], 1, 0, 0, 0, false, OP_OPAQUE);
						}
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
			 
					//Run the sword falling animation
					genericdata gd = Game->LoadGenericData(Game->GetGenericScript("BigSwordFall"));
					gd->RunFrozen(); //Everything is frozen until this script quits
					int portalX = 160;
					int portalY = 16-176;
					int swordAng = Angle(portalX, portalY, 128, 96);
					int swordX = 128+VectorX(128, swordAng);
					int swordY = 128+VectorY(128, swordAng);
					//[EVAN] Put the majority of your big explosion effect here
					
					TX = 128; TY=96;
					//Draw the sword sitting idle
					int NumPulses;
					for(int i=0; i<64; ++i){
						NoAction();
						G[G_DRAWNHPZERO]=1;
						if(i%32==0){
							eweapon e = FireEWeapon(EW_SOLAR, 120, 88, DegtoRad(0), 0, 0, 108, 0, EWF_UNBLOCKABLE);
							e->CollDetection=false;
							e->DrawYOffset=1000;
							float InitAng = 22.5*NumPulses;
							NumPulses++;
							RunEWeaponScript(e, "HorizonSwordShockwave", {3, 1.25, InitAng, -6, 1.5});
							//3, 1.085, X, X, 1.2
							//void run(float InitalRadius, float ExpansionMult, float InitialAngle, float AngleIncrement, float AngleMult)
						}
						int OP = Choose(OP_OPAQUE, OP_TRANS, OP_OPAQUE);
						int RandFactor=Rand(2);
						for(int g=0; g<4; ++g){
							DrawLaser(3, TX, TY, 1+RandFactor, i*15+90*g, C_WHITE, OP);
						}
						BigSwordFall.DrawBigSword(4, scrnBuffer, swordA, swordB, swordX, swordY, swordAng, portalX, portalY, 96, true, true);
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					dissolveMask->ClearToColor(0, 0x01);
					//Sword dissolves
					for(int i=0; i<32; ++i){
						NoAction();
						G[G_DRAWNHPZERO]=1;
						
						if(i%24==0){
							eweapon e = FireEWeapon(EW_SOLAR, 120, 88, DegtoRad(0), 0, 0, 108, 0, EWF_UNBLOCKABLE);
							e->CollDetection=false;
							e->DrawYOffset=1000;
							float InitAng = 22.5*NumPulses;
							NumPulses++;
							RunEWeaponScript(e, "HorizonSwordShockwave", {2.5, 1.3, InitAng, -4, 1.66});
						}
						int OP = Choose(OP_OPAQUE, OP_TRANS, OP_OPAQUE);
						int RandFactor=Rand(2);
						for(int g=0; g<4; ++g){
							DrawLaser(3, TX, TY, 1+RandFactor, i*15+90*g, C_WHITE, OP);
						}
						BigSwordFall.DrawBigSword(0, scrnBuffer, swordA, swordB, swordX, swordY, swordAng, portalX, portalY, 96, true, false);
						swordA->Dither(0, dissolveMask, 0x00, DITH_STATIC, Lerp(0, 255, i/31));
						swordB->Dither(0, dissolveMask, 0x00, DITH_STATIC, Lerp(0, 255, i/31));
						swordB->Blit(4, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_TRANS, 0, true);
						swordA->Blit(4, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_NORMAL, 0, true);
						
						
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					for(int i=32; i<72; ++i){
						NoAction();
						G[G_DRAWNHPZERO]=1;
						if(i%24==0){
							eweapon e = FireEWeapon(EW_SOLAR, 120, 88, DegtoRad(0), 0, 0, 108, 0, EWF_UNBLOCKABLE);
							e->CollDetection=false;
							e->DrawYOffset=1000;
							float InitAng = 22.5*NumPulses;
							NumPulses++;
							RunEWeaponScript(e, "HorizonSwordShockwave", {2.5, 1.3, InitAng, -4, 1.66});
						}
						int OP = Choose(OP_OPAQUE, OP_TRANS, OP_OPAQUE);
						int RandFactor=Rand(2);
						for(int g=0; g<4; ++g){
							DrawLaser(3, TX, TY, 1+RandFactor, i*15+90*g, C_WHITE, OP);
						}
						
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					for(int i=72; i<96; ++i){
						NoAction();
						G[G_DRAWNHPZERO]=1;
						if(i%16==0){
							eweapon e = FireEWeapon(EW_SOLAR, 120, 88, DegtoRad(0), 0, 0, 108, 0, EWF_UNBLOCKABLE);
							e->CollDetection=false;
							e->DrawYOffset=1000;
							float InitAng = 22.5*NumPulses;
							NumPulses++;
							RunEWeaponScript(e, "HorizonSwordShockwave", {2, 1.4, InitAng, -2, 1.75});
						}
						int OP = Choose(OP_OPAQUE, OP_TRANS, OP_OPAQUE);
						int RandFactor=Rand(2);
						for(int g=0; g<4; ++g){
							DrawLaser(3, TX, TY, 1+RandFactor, i*15+90*g, C_WHITE, OP);
						}
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					for(int i=0; i<32; ++i){
						NoAction();
						G[G_DRAWNHPZERO]=1;
						int OP = Choose(OP_OPAQUE, OP_TRANS, OP_OPAQUE);
						int RandFactor=Rand(2);
						if(i>16)Screen->Rectangle(5, -16, -16, 255+32, 175+32, C_WHITE, 1, 0, 0, 0, true, OP_TRANS);
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					
					for(int i=0; i<500; ++i){
						NoAction();
						G[G_DRAWNHPZERO]=1;
						if(i==32){
							DamageNumbers_AddNumberGFX(CenterLinkX(), CenterLinkY()-DAMAGENUMBERS_HEIGHT/2, _DNUM_TYPE_LINKDAMAGE, DMG_SOLARFINALITY);
							Game->PlaySound(19);
						}
						//REPLACE STRINGS HERE
						if(i==120){
							G[G_PASSIVESTRINGNAMESIDE]=0;
							if(GetCharID()==CHAR_ASHER)//PlayStringAndWait("I can’t give up now... not when I’ve come so far!", SCHAR_ASHER, EMOTE_DISMAYED);
								PlayStringCustom("I can't give up now... not when I've come so far!", "Asher", 0, 0, 16, 128, true);
							else if(GetCharID()==CHAR_TORRIN)//PlayStringAndWait("Ya sure do play rough Chase... but I can roll with the punches. Even giant lasery punches!", SCHAR_TORRIN, EMOTE_DISMAYED);
								PlayStringCustom("Ya sure do play rough Chase... but I can roll with the punches. Even giant lasery punches!", "Torrin", 0, 0, 16, 128, true);
							else if(GetCharID()==CHAR_KAYLANI)//PlayStringAndWait("I don’t know what you are... but I'm not losing here! Not after everything I’ve been through!", SCHAR_KAYLANI, EMOTE_DISMAYED);
								PlayStringCustom("I don't know what you are... but I'm not losing here! Not after everything I've been through!", "Kaylani", 0, 0, 16, 128, true);
						}
						
						if(i==470){
							DamageNumbers[_DNUM_LASTLINKHP]=1;
							Link->HP=2;
						}
						Screen->Rectangle(5, -16, -16, 255+32, 175+32, C_WHITE, 1, 0, 0, 0, true, OP_OPAQUE);
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
					HorizonArray[_BACKGROUNDTOGGLE]=1;
					for(int i=0; i<32; ++i){
						Screen->Rectangle(5, -16, -16, 255+32, 175+32, C_WHITE, 1, 0, 0, 0, true, OP_TRANS);
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					
					TX=120; TY=64;
					while(Distance(Ghost_X, Ghost_Y, TX, TY)>3){
						TAngle = Angle(Ghost_X, Ghost_Y, TX, TY);
						Ghost_MoveAtAngle(TAngle, 1, 2);
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					Phase=5;
					LastAttack=-1;
					Ghost_X=TX; Ghost_Y=TY;
					Ghost_Data = HorizonCombo[BASECOMBO];
					Ghost_Dir = DIR_DOWN;
					ghost->CollDetection=true;
					Ghost_UnsetFlag(GHF_IGNORE_ALL_TERRAIN);
					
					Ghost_HP=MaxHP-HORIZON_THIRDHP/5*4;
					ghost->HP = Ghost_HP;
					ghost->Misc[NPCM_DAMAGENUMBERSLASTHP] = ghost->HP;
					
					break;
				}
			}
			for(int i=0; i<64 && Attackchoice; ++i){
				if(Ghost_GotHit())i+=24;
				Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
				HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
			}
			
			if(Phase==5 && Ghost_HP<= MaxHP-HORIZON_THIRDHP){
				break;
			}
			else if(Attackcount%3==CharacterAttackMod && Phase<4){ //Character specific attack logic. Doesn't happen at the end of the fight.
				HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 16);
				if(GetCharID() == CHAR_ASHER){ //Solar sword
					TAngle = Angle(Link->X, Link->Y, 120, 88);
					TX = 120+VectorX(20, TAngle);
					TY = 88+VectorY(20, TAngle);
					Ghost_Data = HorizonCombo[TELECOMBO];
					Game->PlaySound(SFX_HORIZONTELEPORT);
					ghost->CollDetection=false;
					int breaktime;
					while(Distance(Ghost_X, Ghost_Y+16, TX, TY)>3){
						breaktime++;
						if(breaktime>120)break;
						TAngle = Angle(Ghost_X, Ghost_Y+16, TX, TY);
						Ghost_MoveAtAngle(TAngle, 1.5, 2);
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					TAngle = Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8);
					Ghost_Dir=AngleDir4(TAngle);
					Ghost_Data=HorizonCombo[ATKCOMBO1];
					ghost->CollDetection=true;
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER;
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 12);
					int j=Choose(-1,1); int i; int k;
					Game->PlaySound(SFX_STELLARSWORD_APPEAR);
					for(i=0; i<5; ++i){
						for(k=0; k<2; ++k){
							DrawHorizonSword(Ghost_X, Ghost_Y+16, TAngle-(90+30)*j, 8, i, ghost->Damage*1.5, 0, 0, 0);
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
						}
					}
					for(i=0; i<42; ++i){
						DrawHorizonSword(Ghost_X, Ghost_Y+16, TAngle-(90+30)*j, 8, 5, ghost->Damage*1.5, -0, 0, 0);
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					for(int Slashes=0; Slashes<2; ++Slashes){
						for(i=0; i<8; ++i){
							DrawHorizonSword(Ghost_X, Ghost_Y+16, TAngle-(90+30)*j, 8, 5, ghost->Damage*1.5, -0, 0, 0);
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
						}
						Ghost_Data=HorizonCombo[ATKCOMBO1];
						Game->PlaySound(SFX_STELLARSWORD_SLASH);
						for(i=0; i<180+45; i+=15){
							Ghost_MoveAtAngle(TAngle, .85, 1);
							DrawHorizonSword(Ghost_X, Ghost_Y+16, TAngle-90*j+i*j, 12, 5, ghost->Damage*1.5, TAngle-90*j+i*j -(i-15)*j, 30, 180);
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
						}
						for(i=0; i<16; i++){
							DrawHorizonSword(Ghost_X, Ghost_Y+16, TAngle-90*j+180+45*j, 12, 5, ghost->Damage*1.5, 0, 0, 0);
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
						}
						Game->PlaySound(SFX_STELLARSWORD_SLASH);
						Ghost_Data=HorizonCombo[ATKCOMBO2];
						for(i=180+15; i>-15; i-=15){
							Ghost_MoveAtAngle(TAngle, .85, 1);
							DrawHorizonSword(Ghost_X, Ghost_Y+16, TAngle-90*j+i*j, 12, 5, ghost->Damage*1.5, TAngle-90*j+i*j +(180+30-i)*j, 30, 180);
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
						}
						for(i=0; i<8; i++){
							DrawHorizonSword(Ghost_X, Ghost_Y+16, TAngle-90*j-30*j, 12, 5, ghost->Damage*1.5, 0, 0, 0);
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
						}
					}
					for(i=5; i>1; --i){
						DrawHorizonSword(Ghost_X, Ghost_Y+16, TAngle-90*j-60*j, 8, i, ghost->Damage*1.5, 0, 0, 0);
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					//DrawHorizonSword(int sx, int sy, int angle, int dist, int swordlength, int damage, int TrailAngle, int TrailSpacing, int FlareDuration)
				}
				else if(GetCharID() == CHAR_TORRIN){ //Wicked Weaves
					int Delay=36;
					int LastChoice=0;
					int Offset;
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER;
					Ghost_Data=HorizonCombo[ATKCOMBO2];
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 16);
					for(int Punches=0; Punches<9; Punches++){
						if(Punches<3 || Punches>6){
							ghost->CollDetection=true;
							if(Ghost_Data==HorizonCombo[ATKCOMBO1])Ghost_Data=HorizonCombo[ATKCOMBO2];
							else Ghost_Data=HorizonCombo[ATKCOMBO1];
						}
						else{
							if(Punches==3){ //Break your lock lmao
								Ghost_Data=HorizonCombo[TELECOMBO];
								ghost->CollDetection=false;
								Game->PlaySound(SFX_HORIZONTELEPORT);
							}
							else{ //Shoot some longshots
								TAngle = Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8);
								for(int i=-45; i<=45; i+=45){
									TX = Ghost_X-16+VectorX(30, TAngle+i);
									TY = Ghost_Y+16+VectorY(30, TAngle+i);
									eweapon e = FireBigEWeapon(EW_SOLAR, TX, TY, DegtoRad(TAngle), 600, ghost->WeaponDamage, SPR_HORIZONSHOT3X1, 0, EWF_UNBLOCKABLE, 3, 1);
									e->CollDetection = false;
									e->DrawYOffset = -1000;
									RunEWeaponScript(e, "HorizonPortalShot", {0});
								}
							}
						}
						
						
						TAngle = Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8);
						Ghost_Dir=AngleDir4(TAngle);
						Offset = Choose(0, 35, 75, 60+90);
						while(Offset==LastChoice)Offset = Choose({0, 0, 35, 75, 60+90});
						LastChoice = Offset;
						
						if(Punches%3==0){ //Double
							Offset=90;
							LastChoice=75;
						}
						Offset *= Choose(-1,1);
						TX = Clamp(Link->X+VectorX(48, TAngle+180+Offset),8,232);
						TY = Clamp(Link->Y+VectorY(48, TAngle+180+Offset),8,168);
						
						eweapon e = FireAimedEWeapon(EW_SOLAR, TX, TY, 0, 0, ghost->Damage/2, 108, 97, EWF_UNBLOCKABLE);
						if(Ghost_Data==HorizonCombo[ATKCOMBO1])e->Tile=TIL_HORIZONFIST1;
						else e->Tile = TIL_HORIZONFIST2;
						e->CSet=3;
						e->DrawYOffset=1000;
						e->CollDetection=false;
						int Goddamnit[8];
						Goddamnit[0]=64;
						Goddamnit[1]=Delay;
						Goddamnit[2]=8;
						Goddamnit[3]=24;
						Goddamnit[4]=12;
						RunEWeaponScript(e, "HorizonWeave", Goddamnit);
						
						if(Punches%3==0){ //Double
							TAngle = Angle(TX, TY, Link->X, Link->Y);
							int Dist = Distance(TX, TY, Link->X, Link->Y);
							int FX = Clamp(TX+VectorX(Dist*2, TAngle), 8, 232);
							int FY = Clamp(TY+VectorY(Dist*2, TAngle), 8, 168);
							
							eweapon e = FireAimedEWeapon(EW_SOLAR, FX, FY, 0, 0, ghost->Damage/2, 108, 97, EWF_UNBLOCKABLE);
							if(Ghost_Data==HorizonCombo[ATKCOMBO1])e->Tile=TIL_HORIZONFIST2;
							else e->Tile = TIL_HORIZONFIST1;
							e->CSet=3;
							e->DrawYOffset=1000;
							e->CollDetection=false;
							Goddamnit[0]=64;
							Goddamnit[1]=Delay;
							Goddamnit[2]=8;
							Goddamnit[3]=24;
							Goddamnit[4]=12;
							RunEWeaponScript(e, "HorizonWeave", Goddamnit);
						}
						
						//int extend, int telegraphTime, int extendTime, int sustainTime, int retractTime
						
						int DelayMod = Rand(16, 32);
						for(int i=0; i<DelayMod; ++i){
							Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y));
							if(Ghost_Data != HorizonCombo[TELECOMBO])Ghost_MoveTowardLink(.5, 2);
							HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
						}
						Delay=36+(24-DelayMod);
					}
					Offset=Choose(0,45);
					for(int i=0; i<4; ++i){
						TX = Ghost_X+VectorX(20, 90*i+Offset);
						TY = Ghost_Y+16+VectorY(20, 90*i+Offset);
						int Goddamnit[8];
						eweapon e = FireEWeapon(EW_SOLAR, TX, TY, DegtoRad(90*i+Offset), 0, ghost->Damage/2, 108, 97, EWF_UNBLOCKABLE);
						if(i%2==0)e->Tile=TIL_HORIZONFIST1;
						else e->Tile = TIL_HORIZONFIST2;
						e->CSet=3;
						e->DrawYOffset=1000;
						e->CollDetection=false;
						Goddamnit[0]=64;
						Goddamnit[1]=Delay+16;
						Goddamnit[2]=8;
						Goddamnit[3]=24;
						Goddamnit[4]=12;
						RunEWeaponScript(e, "HorizonWeave", Goddamnit);
					}
					Ghost_Data = HorizonCombo[BASECOMBO];
					Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 48);
					Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
				}
				else if(GetCharID() == CHAR_KAYLANI){ //Sundog Danmaku
					Ghost_Data = HorizonCombo[HOLDUPCOMBO];
					HorizonArray[_PALETTETARGET]=HORIZON_PAL_LASER;
					int YPos[9]; //Stores if a slot has been taken or not yet
					int Choice;
					int TDir;
					if(Link->X >128){
						TX = 32;
						TDir=DIR_RIGHT;
					}
					else{
						TX = 208;
						TDir = DIR_LEFT;
					}
					
					for(int i=0; i<3; ++i){ //Bias the first 2 towards the side of the screen as the player
						
						if(i!=3){
							if(Link->Y <= 88)Choice = Rand(0,4);
							else Choice = Rand(4,8);
						}
						else Choice = Rand(0,8);
						
						if(YPos[Choice]){ //Slot taken? Try again
							i--;
							continue;
						}
						else{
							YPos[Choice]=1;
							eweapon e = FireNonAngularEWeapon(EW_SOLAR, TX, 24+Choice*16, TDir, 0, ghost->WeaponDamage, 108, 39, EWF_UNBLOCKABLE);
							ConfigureSundog(e, TDir, 150, 3, 90);
							//int FlickerTime, int NumShots, int FiringDelay
						}
					}
					HorizonArray[_HALOYOFFSET]=-1;
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 24);
					HorizonArray[_HALOYOFFSET]=-1;
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 24);
					
					ghost->CollDetection=false;
					Ghost_Data = HorizonCombo[TELECOMBO];
					Game->PlaySound(SFX_HORIZONTELEPORT);
					
					for(int g=0; g<2; ++g){ //2 more waves of 3...
						for(int i=0; i<3; ++i){ 
							Choice = Rand(0,8);
							
							if(YPos[Choice]){
								i--;
								continue;
							}
							else{
								YPos[Choice]=1;
								eweapon e = FireNonAngularEWeapon(EW_SOLAR, TX, 24+Choice*16, TDir, 0, ghost->WeaponDamage, 108, 39, EWF_UNBLOCKABLE);
								ConfigureSundog(e, TDir, 150, 3, 90);
							}
						}	
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 48);
					}
					for(int i=0; i<300; ++i){
						if(i%(60*2)==30){
							eweapon e = FireEWeapon(EW_SOLAR, Link->X-24, 8, DegtoRad(90), 0, ghost->WeaponDamage, 108, 0, EWF_UNBLOCKABLE);
							e->CollDetection = false;
							e->DrawYOffset = -1000;
							e->Misc[HL_WIDTH]=24;
							e->Misc[HL_STARTTIME]=60;
							e->Misc[HL_DURATION]=16;
							e->Misc[HL_LINETELEGRAPH]=1;
							RunEWeaponScript(e, "HorizonLaser", {0});
							
							eweapon e2 = FireEWeapon(EW_SOLAR, Link->X+24, 8, DegtoRad(90), 0, ghost->WeaponDamage, 108, 0, EWF_UNBLOCKABLE);
							e2->CollDetection = false;
							e2->DrawYOffset = -1000;
							e2->Misc[HL_WIDTH]=24;
							e2->Misc[HL_STARTTIME]=60;
							e2->Misc[HL_DURATION]=24;
							e2->Misc[HL_LINETELEGRAPH]=1;
							RunEWeaponScript(e2, "HorizonLaser", {0});
						}
						else if(i%60==30){
							eweapon e = FireEWeapon(EW_SOLAR, Link->X, 8, DegtoRad(90), 0, ghost->WeaponDamage, 108, 0, EWF_UNBLOCKABLE);
							e->CollDetection = false;
							e->DrawYOffset = -1000;
							e->Misc[HL_WIDTH]=24;
							e->Misc[HL_STARTTIME]=60;
							e->Misc[HL_DURATION]=24;
							e->Misc[HL_LINETELEGRAPH]=1;
							RunEWeaponScript(e, "HorizonLaser", {0});
						}
						
						HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 1);
					}
					HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 90);
					ghost->CollDetection=true;
					Ghost_Data = HorizonCombo[BASECOMBO];
					HorizonArray[_HALOYOFFSET]=0;
					Ghost_Dir=AngleDir4(Angle(Ghost_X+8, Ghost_Y+24, Link->X+8, Link->Y+8));
					
				}
				Ghost_Data = HorizonCombo[BASECOMBO];
				HorizonArray[_PALETTETARGET]=HORIZON_PAL_BASE;
				HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 60);
			}
			
			Attackcount++;
		}
		// Game->PlaySound(SFX_HORIZONALARM);
		SodOffSuns(NPCArray);
		ghost->CollDetection=false;
		ClearEWeapons();
		HorizonWaitframe(this, ghost, StarD, StarA, Phase, Form, HorizonArray,HorizonCombo, 200);
		//REPLACE STRINGS HERE
		//Write brief Tango stuff where Chase realizes it's past his bedtime and his mom is going to kill him.
		EndingHandler(this, ghost);
		
		
	}
	void HorizonWaitframe(ffc this, npc ghost, int StarD, int StarA, int Phase, int Form, int HorizonArray, int HorizonCombo, int frames){
		for(int framecount=0; framecount<frames; ++framecount){
			
			if(G[G_ANIM]%2==0 && !HorizonArray[_MANUALCOLORCHANGE]){ //Color FX sync update
				Screen->D[D_HORIZON_FX] = Choose(C_WHITE, Rand(C_GOLD1-3, C_GOLD2-3), Rand(C_GOLD1, C_GOLD2));
			}
			
			if(G[G_ANIM]%HORIZON_PAL_SPEED==0){ //Palette cycler
				PaletteCycler(HorizonArray);
			}
			if(HorizonArray[_BACKGROUNDTOGGLE]){ //Background manager
				int CLR = Choose(C_WHITE, Rand(C_GOLD1, C_GOLD2));
				if(Form<2)CLR=C_WHITE;
				Screen->Rectangle(1, 0, -16, 255, 175+16, C_BLACK, 1, 0, 0, 0, true, OP_TRANS);
				Screen->Circle(1, Ghost_X+8+Rand(-3,3), Ghost_Y+20-Ghost_Z+Rand(-3,3), Rand(-3,3)+16, CLR, 1, 0, 0, 0, true, OP_TRANS);
				if(Form==3){ //Aura draw
					if(Ghost_Data != HorizonCombo[TELECOMBO]){
						int Radius = 4;
						if(Phase>2)Radius=5;
						int Offset = Sin((G[G_ANIM]%9) * 20)*Radius;
						int YOff = 3;
						Screen->DrawCombo(2, Ghost_X-Offset, Ghost_Y-YOff-Offset, CMB_HORIZONAURA+Ghost_Dir, 1, 2, 3, -1, -1, Ghost_X-Offset, Ghost_Y-YOff-Offset, 0, 0, 0, true, OP_OPAQUE);
						Screen->DrawCombo(2, Ghost_X+Offset, Ghost_Y-YOff-Offset, CMB_HORIZONAURA+Ghost_Dir, 1, 2, 3, -1, -1, Ghost_X+Offset, Ghost_Y-YOff-Offset, 0, 0, 0, true, OP_OPAQUE);
						Screen->DrawCombo(2, Ghost_X-Offset, Ghost_Y-YOff+Offset, CMB_HORIZONAURA+Ghost_Dir, 1, 2, 3, -1, -1, Ghost_X-Offset, Ghost_Y-YOff+Offset, 0, 0, 0, true, OP_OPAQUE);
						Screen->DrawCombo(2, Ghost_X+Offset, Ghost_Y-YOff+Offset, CMB_HORIZONAURA+Ghost_Dir, 1, 2, 3, -1, -1, Ghost_X+Offset, Ghost_Y-YOff+Offset, 0, 0, 0, true, OP_OPAQUE);
					}
				}
				
				if(Form>1){
					int Starspeed = 4;
					if(Form==3) Starspeed = 6;
					for(int j=127; j>=0; j--){
						if(StarD[j]<264)
							StarD[j] = Max(0, StarD[j]+Starspeed);
						else{
							StarD[j] = Rand(0, 16);
							StarA[j] = Rand(360);
						}
						int X = Ghost_X+8+VectorX(StarD[j], StarA[j]);
						int Y = Ghost_Y+20-Ghost_Z+VectorY(StarD[j], StarA[j]);
						int CLR2 = Choose(C_WHITE, Rand(C_GOLD1, C_GOLD2));
						if(Form<3)CLR2=C_WHITE;
						Screen->PutPixel(1, X, Y, CLR2, 0, 0, 0, OP_OPAQUE);
						if(Form==3){
							CLR2 = Choose(C_WHITE, Rand(C_GOLD1, C_GOLD2));
							Screen->Circle(1, X, Y, Rand(1,3), CLR2, 1, 0, 0, 0, true, OP_TRANS);
						}
					}
				}
			}
			if(!ghost->CollDetection){
				NSDetatchLockon(ghost);
			}
			
			if(HorizonArray[_SURFBOARD]){ //Surfboard
				int angle = Angle(0, 0, Ghost_Vx, Ghost_Vy);
				
				CenteredDrawCombo2(1, Ghost_X+8, Ghost_Y+28, CMB_HORIZONSURFBOARD, 8, 2, 1, -1, -1, angle, 0, OP_OPAQUE);
			}
			
			if(Ghost_Data == HorizonCombo[HOLDUPCOMBO]){ //Manual halo draw for one specific thing. It's a pain, but it's so fucking cool for the phase 1 transition super
				int offsetX = HorizonArray[_HALOXOFFSET];
				int offsetY = HorizonArray[_HALOYOFFSET];
				Screen->FastCombo(3, Ghost_X+offsetX, this->Y+offsetY, CMB_HORIZONHALO, this->CSet, 128);
			}
			
			if(ghost->CollDetection){ //Burn on contact if the player touches the boss under any circumstances while having a hitbox
				if(Distance(Ghost_X, Ghost_Y+16, Link->X, Link->Y)<13){
					ApplyBurn(HorizonArray);
				}
			}
			int Index = Link->HitBy[1];
			if(Index>0){ //Burn for touching solar weapons
				eweapon e = Screen->LoadEWeapon(Index);
				if(e->ID==EW_SOLAR){
					ApplyBurn(HorizonArray);
				}
			}
			if(Link->Y>152)Link->Y=152;
			
			BurnWard(ghost, HorizonArray); //Handles applied burns
			
			if(ghost->HP < 30000-HORIZON_THIRDHP-1 || Ghost_HP < 30000-HORIZON_THIRDHP-1){ //Cannot die conventionally, special death sequences are handled in the main loop once enough damage is taken
				ghost->HP = 30000-HORIZON_THIRDHP-1;
				Ghost_HP = 30000-HORIZON_THIRDHP-1;
				ghost->Misc[NPCM_DAMAGENUMBERSLASTHP] = ghost->HP;
			}
			Ghost_Waitframe(this, ghost, true, true); //Take a guess what this does?
		}
	}
	float TurnToAngle(float angle1, float angle2, float step){
		if(Abs(AngDiff(angle1, angle2))>Abs(step)){
			return WrapDegrees(angle1 + Sign(AngDiff(angle1, angle2))*step);
		}
		else{
			return angle2;
		}
	}
	void ConfigureSundog(eweapon e, int dir, int flashtime, int shots, int cooldown){
		e->Dir=dir;
		e->CollDetection=false;
		e->DrawYOffset=1000;
		RunEWeaponScript(e, "HorizonCloneShooter", {flashtime, shots, cooldown});
	}
	void PaletteCycler(int HorizonArray){
		int CurPalette = Game->DMapPalette[Game->GetCurDMap()];
		if(CurPalette < HorizonArray[_PALETTETARGET]){
			Game->DMapPalette[Game->GetCurDMap()]++;
		}
		else if(CurPalette > HorizonArray[_PALETTETARGET]){
			Game->DMapPalette[Game->GetCurDMap()]--;
		}
	}
	int Choose(int arr){
		int count = SizeOfArray(arr);
		return arr[Rand(count)];
	}
	void NSDetatchLockon(npc egg){
		if(G[G_TORRINLOCKONTARGET]>0){
			npc target = Screen->LoadNPCByUID(G[G_TORRINLOCKONTARGET]);
			if(target==egg){
				G[G_TORRINLOCKON] = 0;
			}
		}
    }
	void SodOffSuns(npc NPCArray){
		for(int i=0; i<SizeOfArray(NPCArray); ++i){
			if(NPCArray[i]->isValid()){
				NPCArray[i]->ItemSet=0;
				NPCArray[i]->Misc[NPCM_SITSTILLYOULITTLEFUCK]=2;
			}
		}
	}
	void DrawEnergyRing(int layer, int cx, int cy, int radius, int thickness, int variance, int c, int points, int angle){
		int i; int j; 
		int pointX1[512];
		int pointY1[512];
		int pointX2[512];
		int pointY2[512];
	 
		int quadAngle = 360/points;
	 
		for(i=0; i<=points; ++i){
			if(i==points){
				pointX1[i] = pointX1[0];
				pointY1[i] = pointY1[0];
				pointX2[i] = pointX2[0];
				pointY2[i] = pointY2[0];
			}
			else{
				j = Rand(variance)-(variance/2);
				pointX1[i] = cx+VectorX(radius+j-thickness/2, angle+quadAngle*i);
				pointY1[i] = cy+VectorY(radius+j-thickness/2, angle+quadAngle*i);
				pointX2[i] = cx+VectorX(radius+j+thickness/2, angle+quadAngle*i);
				pointY2[i] = cy+VectorY(radius+j+thickness/2, angle+quadAngle*i);
			}
		}
		for(i=0; i<points; ++i){
			Screen->Quad(layer, pointX1[i], pointY1[i], pointX1[i+1], pointY1[i+1], pointX2[i+1], pointY2[i+1], pointX2[i], pointY2[i], 1, 1, c, 0, -1, PT_FLAT);
		}
	}
	void DrawThickLine(int layer,  int x1, int y1, int x2, int y2, int width, int color, bool fill, int op){
		Screen->Rectangle(layer, x1, y1-width/2, x1+Distance(x1, y1, x2, y2), y1+width/2, color, 1, x1, y1, Angle(x1, y1, x2, y2), fill, op);
	}
	void DrawLaser(int layer, int x, int y, int width, int rotation, int color, int Trans){
		Screen->Circle(layer, x+width, y, width, color, 1, x, y, rotation, true, Trans);
		Screen->Rectangle(layer, x+width, y-width, x+width+600, y+width, color, 1, x, y, rotation, true, Trans);
	}
	int HitboxCenterX(npc n){
		return n->X+n->HitXOffset+n->HitWidth/2;
	}
	int HitboxCenterY(npc n){
		return n->Y+n->HitYOffset+n->HitHeight/2;
	}
	void BurnWard(npc ghost, int HorizonArray){
		lweapon burnparticle;
		if(GetCharID() == CHAR_ASHER){
			if(HorizonArray[_BURNCOUNTER_ASHER]>0){
				
				if(HorizonArray[_BURNCOUNTER_ASHER]%20==0){
					if(!G[G_DRAWNHPZERO])Link->HP-=2;
					Game->PlaySound(19);
					
				}
				if(HorizonArray[_BURNCOUNTER_ASHER]%7==1){
					burnparticle=Screen->CreateLWeapon(LW_FIRE);
					Game->PlaySound(Choose(13, 88));
					burnparticle->X=Link->X+8+Rand(-12,12);
					burnparticle->Y=Link->Y+8+Rand(-28,12);
					burnparticle->CollDetection=false;
					burnparticle->UseSprite(SPR_HORIZONBURNFX);
					burnparticle->DeadState=28;
				}
				HorizonArray[_BURNCOUNTER_ASHER]--;
				
				//G[G_DASHINTERRUPT]=1;
			}
			ghost->Misc[NPCM_BURN_ASHER]=HorizonArray[_BURNCOUNTER_ASHER];
			G[G_BURN_ASHER] = HorizonArray[_BURNCOUNTER_ASHER];
		}
		else if(GetCharID() == CHAR_TORRIN){
			if(HorizonArray[_BURNCOUNTER_TORRIN]>0){
				
				if(HorizonArray[_BURNCOUNTER_TORRIN]%20==0){
					if(!G[G_DRAWNHPZERO])Link->HP-=2;
					Game->PlaySound(19);
				}
				if(HorizonArray[_BURNCOUNTER_TORRIN]%7==1){
					burnparticle=Screen->CreateLWeapon(LW_FIRE);
					Game->PlaySound(Choose(13, 88));
					burnparticle->X=Link->X+8+Rand(-12,12);
					burnparticle->Y=Link->Y+8+Rand(-28,12);
					burnparticle->CollDetection=false;
					burnparticle->UseSprite(SPR_HORIZONBURNFX);
					burnparticle->DeadState=28;
				}
				HorizonArray[_BURNCOUNTER_TORRIN]--;
			}
			ghost->Misc[NPCM_BURN_TORRIN]=HorizonArray[_BURNCOUNTER_TORRIN];
			G[G_BURN_TORRIN] = HorizonArray[_BURNCOUNTER_TORRIN];
		}
		else if(GetCharID() == CHAR_KAYLANI){
			if(HorizonArray[_BURNCOUNTER_KAYLANI]>0){
				
				if(HorizonArray[_BURNCOUNTER_KAYLANI]%20==0){
					if(!G[G_DRAWNHPZERO])Link->HP-=2;
					Game->PlaySound(19);
				}
				if(HorizonArray[_BURNCOUNTER_KAYLANI]%7==1){
					burnparticle=Screen->CreateLWeapon(LW_FIRE);
					Game->PlaySound(Choose(13, 88));
					burnparticle->X=Link->X+8+Rand(-12,12);
					burnparticle->Y=Link->Y+8+Rand(-28,12);
					burnparticle->CollDetection=false;
					burnparticle->UseSprite(SPR_HORIZONBURNFX);
					burnparticle->DeadState=28;
				}
				HorizonArray[_BURNCOUNTER_KAYLANI]--;
			}
			ghost->Misc[NPCM_BURN_KAYLANI]=HorizonArray[_BURNCOUNTER_KAYLANI];
			G[G_BURN_KAYLANI] = HorizonArray[_BURNCOUNTER_KAYLANI];
		}
	}
	void ApplyBurn(int HorizonArray){
		//I AM FIRE
		if(GetCharID() == CHAR_ASHER){
			if(HorizonArray[_BURNCOUNTER_ASHER]<40)HorizonArray[_BURNCOUNTER_ASHER]=90;
		}
		//FOR ALL THOSE WHO CARED FOR ME
		else if(GetCharID() == CHAR_TORRIN){
			if(HorizonArray[_BURNCOUNTER_TORRIN]<40)HorizonArray[_BURNCOUNTER_TORRIN]=90;
		}
		//And you thought I wouldn't sneak Ruina references in here? Wrong, fucker.
		else if(GetCharID() == CHAR_KAYLANI){
			if(HorizonArray[_BURNCOUNTER_KAYLANI]<40)HorizonArray[_BURNCOUNTER_KAYLANI]=90;
		}
	}
	void CenteredDrawCombo2(int layer, int x, int y, int combo, int cset, int w, int h, int xs, int ys, int rangle, int flip, int trans){
		int xscale = xs; int yscale = ys;
		if(xs==-1 && ys==-1){
			xscale=16*w;
			yscale=16*h;
		}
		Screen->DrawCombo(layer, x-xscale/2, y-yscale/2, combo, w, h, cset, xscale, yscale, x-xscale/2, y-yscale/2, rangle, -1, flip, true, trans);
	}
	void ApplyActuallyDead(){
		DamageNumbers[_DNUM_LASTLINKHP]=0;
		Link->HP=0;
		G[G_HORIZONINCINERATEFLAG] = 1;
		if(GetCharID() == CHAR_ASHER)G[G_ASHERINCINERATED]=1;
		if(GetCharID() == CHAR_TORRIN)G[G_TORRININCINERATED]=1;
		if(GetCharID() == CHAR_KAYLANI)G[G_KAYLANIINCINERATED]=1;
	}
	void ClearEWeapons(){
		for(int i = Screen->NumEWeapons(); i>1; --i){
			eweapon e = Screen->LoadEWeapon(i);
			e->DeadState=0;
		}
	}
	void ClearSuns(){
		for(int i=Screen->NumNPCs(); i>1; --i){
			npc n = Screen->LoadNPC(i);
			if(n->ID==NPC_SUNFRIEND){
				n->ItemSet=0;
				n->HP=-1000;
				n->Y=1000;
			}
		}
	}
	void InvertedCircle(int layer, int x, int y, int radius, int fillcolor){
		Screen->SetRenderTarget(RT_BITMAP3);     //Set the render target to the bitmap.
		Screen->Rectangle(0, 0, 0, 256, 176, fillcolor, 1, 0, 0, 0, true, 128); //Cover the screen
		Screen->Circle(0, x, y, radius, 0, 1, 0, 0, 0, true, 128); //Draw a transparent circle.
		Screen->SetRenderTarget(RT_SCREEN); //Set the render target back to the screen.
		Screen->DrawBitmap(layer, RT_BITMAP3, 0, 0, 256, 176, 0, 0, 256, 176, 0, true); //Draw the bitmap
	}
	void RNGFlush(){ //This is absolutely a hack and I'm not completely confident it works...
		//If Allegro is doing what I think it's doing, this is necessary sometimes...
		while(Rand(0,6)>0){ //If this doesn't make sense...
		//Take a real good think about how C++'s RNG seeding works, prime numbers, and RNG modulus...
		}//Relish the horror that this might work...
		while(Rand(0,10)<10){ //And bask in the infinite despair...
		//That ZC is so fucking awful that this is necessary
		} //I'm so sorry
	} //There might be better primes with more ideal bit notations for this than these, but it only has to be "good enough" and not be super slow.
	void EndingHandler(ffc this, npc ghost){
		ffc Cutscene = Screen->LoadFFC(1);
		Cutscene->CSet = 1;
		Cutscene->Misc[0] = Ghost_X;
		Cutscene->Misc[1] = Ghost_Y;
		ClearEWeapons();
		KillLWeapons();
		ClearSuns();
		Ghost_Y = -1000;
		ghost->Y = -1000;
		ghost->HP = -1000;
		__GhCleanUp(this);
	}
}
 
eweapon script HorizonPortalShot{
	void DrawPortalShot(eweapon this, bitmap b, int percentRemoved, int c){
		int ang = RadtoDeg(this->Angle);
 
		int x = this->X;
		int y = this->Y;
 
		//All draws to bitmaps go to layer 0. This ensures they happen first in the draw queue.
		b->Clear(0);
		b->DrawTile(0, 0, 0, this->Tile, 3, 1, this->CSet, -1, -1, 0, 0, 0, 0, true, 128);
		//Remove some of the bitmap on the left end
		if(percentRemoved)
			b->Rectangle(0, 0, 0, Lerp(0, 47, percentRemoved), 15, 0x00, 1, 0, 0, 0, true, 128);
 
		//Offset draws by how much of the bitmap was removed
		x -= VectorX(Lerp(0, 48, percentRemoved), ang);
		y -= VectorY(Lerp(0, 48, percentRemoved), ang);
 
		//Draw the portal circle
		int portalX = this->X+24-VectorX(24, ang);
		int portalY = this->Y+8-VectorY(24, ang);
		if(percentRemoved)
			Screen->Circle(2, portalX+Rand(-1, 1), portalY+Rand(-1, 1), Rand(10, 12), c, 1, 0, 0, 0, true, 128);
		//Draw the cropped bitmap to the screen with rotation. Pray it works.
		b->Blit(3, RT_SCREEN, 0, 0, 48, 16, x, y, 48, 16, ang, 0, 0, 0, 0, true);
 
		//Create up to three hitboxes starting from the back end of the rotated bitmap
		int len = Lerp(48, 0, percentRemoved);
		x = this->X+16-VectorX(16, ang);
		y = this->Y-VectorY(16, ang);
		int hitboxes = Clamp(Floor(len/16), 0, 3);
		for(int i=0; i<hitboxes; ++i){
			MakeHitbox(EW_SOLAR, x, y, 16, 16, this->Damage);
			x += VectorX(16, ang);
			y += VectorY(16, ang);
		}
	}
	void DrawExpandingRect(int layer, int x, int y, int angle, int rad, int c){
		int px[4];
		int py[4];
		for(int i=0; i<4; ++i){
			px[i] = x+VectorX(rad, angle+90*i);
			py[i] = y+VectorY(rad, angle+90*i);
		}
		Screen->Quad(layer, px[0], py[0], px[1], py[1], px[2], py[2], px[3], py[3], 1, 1, c, 0, -1, PT_FLAT);
	}
	void run(){
		int step = this->Step;
		this->Step = 0;
		Game->PlaySound(SFX_HORIZONLONGSHOT_APPEAR);
		
		int Telegraph = 28;
		if(this->Misc[0]>28)Telegraph=this->Misc[0];
		
		for(int i=4; i<Telegraph; ++i){
			int ang = RadtoDeg(this->Angle);
			int portalX = this->X+24-VectorX(24, ang);
			int portalY = this->Y+8-VectorY(24, ang);
			int Rad = Min(i/1.5, 19);
			Screen->Circle(2, portalX, portalY, Rad, Screen->D[D_HORIZON_FX], 1, 0, 0, 0, true, 128);
			Waitframe();
		}
		
		Game->PlaySound(78);
		//Create the bitmap and give this script ownership
		bitmap b = Game->CreateBitmap(48, 16);
		b->Own();
 
		int dist = 0;
		while(dist<48){
			int percent = 1-Clamp(dist/48, 0, 1);
			dist += step/100;
			DrawPortalShot(this, b, percent, Screen->D[D_HORIZON_FX]);
			Waitframe();
		}
		this->Step = step;
 
		/* while(true){
			DrawPortalShot(this, b, 0, Choose(0x81, 0x82, 0x83));
			Waitframe();
		} */
		int ColX = this->X+24+VectorX(20, RadtoDeg(this->Angle));
		int ColY = this->Y+8+VectorY(20, RadtoDeg(this->Angle));
		int g;
		while(!Screen->isSolid(ColX, ColY) || g>120){
			++g;
			//this->Rotation = RadtoDeg(this->Angle);
			//this->DeadState = WDS_ALIVE;
			ColX = this->X+24+VectorX(20, RadtoDeg(this->Angle));
			ColY = this->Y+8+VectorY(20, RadtoDeg(this->Angle));
			DrawPortalShot(this, b, 0, Screen->D[D_HORIZON_FX]);
			Waitframe();
		}
		int angle = RadtoDeg(this->Angle);
		this->DrawYOffset = -1000;
		this->CollDetection = false;
		this->Step = 0;
		Game->PlaySound(79);
		int portalX = this->X+24+VectorX(16, angle);
		int portalY = this->Y+8+VectorY(16, angle);
		for(int i=8; i<48; ++i){
			int len = Min(i*1.5, 24);
			if(i<40||i%2==0){
				DrawExpandingRect(3, portalX+VectorX(i/4, angle), portalY+VectorY(i/4, angle), angle+10*i, len, Choose(C_WHITE, Screen->D[D_HORIZON_FX]));
				DrawExpandingRect(3, portalX+VectorX(i/4, angle), portalY+VectorY(i/4, angle), angle+10*i+45, len, Screen->D[D_HORIZON_FX]);
			}
			MakeHitbox(EW_SOLAR, portalX-len*0.75, portalY-len*0.75, len*1.5, len*1.5, this->Damage);
			Waitframe();
		}
		this->DeadState = 0;
	}
}


eweapon script HorizonSpazer{
	void run(){
		while(true){
			float Drift = this->Misc[0];
			this->Angle += DegtoRad(Drift);
			Screen->Circle(1, this->X+8, this->Y+8, Rand(-3,3)+10, C_WHITE, 1, 0, 0, 0, true, OP_TRANS);
			Waitframe();
		}
	}
}

enum{
	HL_LINETELEGRAPH,
	HL_WIDTH, //Standard sizes are 48 and 24. End result of the beam hitbox is this value divided by 3
	HL_STARTTIME, //48 is standard. Less than the Width value results in a smaller beam that hasn't fully formed, but making the telegraph period longer doesn't necessarily have to fatten the beam past its Width.
	HL_DURATION, //Exactly what you think. Stopping this from hitting 0 will prolong the laser without causing the sound to have a stroke. Handy.
	HL_ROTOFFSET, //Does nothing inherently, but this is where we'll store the relative rotational speed the main script will spin these around by or use the autotrack below
	HL_AUTOTRACK //if !=0, makes the laser turn HL_ROTOFFSET degrees each frame towards the player towards the end of the startup animation
};

eweapon script HorizonLaser{
	void run(){
		int Width=0;
		int FX; int FY;
		Game->PlaySound(86);
		
		for(this->Misc[HL_STARTTIME]; this->Misc[HL_STARTTIME]>0; --this->Misc[HL_STARTTIME]){ //Charge up
			if(Width < this->Misc[HL_WIDTH])Width+=2;
			if(Width > this->Misc[HL_WIDTH])Width=this->Misc[HL_WIDTH];
			
			FX = CenterX(this); FY = CenterY(this);
			Screen->Circle(2, FX+Rand(-2,2), FY+Rand(-2,2), Rand(-2,2)+Width/2, Screen->D[D_HORIZON_FX], 1, 0, 0, 0, true, OP_TRANS);
			if(this->Misc[HL_LINETELEGRAPH] && Width>6)DrawLaser(2, FX, FY, 1, RadtoDeg(this->Angle), C_WHITE, OP_TRANS);
			Screen->Circle(3, FX+Rand(-2,2), FY+Rand(-2,2), Rand(-2,2)+Width/3, Screen->D[D_HORIZON_FX], 1, 0, 0, 0, true, OP_OPAQUE);
			
			if(this->Misc[HL_STARTTIME]<20 && this->Misc[HL_AUTOTRACK]){
				this->Angle = DegtoRad( TurnToAngle(RadtoDeg(this->Angle), Angle(CenterX(this), CenterY(this), Link->X+8, Link->Y+8), Abs(this->Misc[HL_ROTOFFSET])));
			}
			
			if(Width>10){
				if(Distance(Link->X+8, Link->Y+8, FX, FY)<Width/3){
					DamageLinkSolar(this->Damage);
				}
			}
			Waitframe();
		}
		int i; //Soundtimer
		for(this->Misc[HL_DURATION]; this->Misc[HL_DURATION]>0; --this->Misc[HL_DURATION]){
			++i;
			if(i%6==1)Game->PlaySound(SFX_HORIZONLASER);
			FX = CenterX(this); FY = CenterY(this);
			int Pulse=Sin(i*15)*3;
			Screen->Circle(2, FX+Rand(-2,2), FY+Rand(-2,2), Width/2+Pulse, Screen->D[D_HORIZON_FX], 1, 0, 0, 0, true, OP_TRANS);
			DrawLaser(2, FX-VectorX(Width/4,RadtoDeg(this->Angle)), FY-VectorY(Width/4,RadtoDeg(this->Angle)), (Width/3)+Pulse, RadtoDeg(this->Angle), C_WHITE, OP_TRANS);
			Laser(3, FX, FY, (Width/3)*.75+Pulse/2, RadtoDeg(this->Angle), this->Damage, Screen->D[D_HORIZON_FX]);
			Screen->Circle(3, FX+Rand(-1,1), FY+Rand(-1,1), Width/3+Pulse+1, Screen->D[D_HORIZON_FX], 1, 0, 0, 0, true, OP_OPAQUE);
			if(Distance(Link->X+8, Link->Y+8, FX, FY)<Width/3){
				DamageLinkSolar(this->Damage);
			}
			
			if(this->Misc[HL_AUTOTRACK]){
				this->Angle = DegtoRad( TurnToAngle(RadtoDeg(this->Angle), Angle(CenterX(this), CenterY(this), Link->X+8, Link->Y+8), Abs(this->Misc[HL_ROTOFFSET])));
			}
			
			Waitframe();
		}
		
		for(Width; Width>0; Width-=6){ //Quick spooldown
			if(Width>1){
				FX = CenterX(this); FY = CenterY(this);
				Screen->Circle(2, FX+Rand(-2,2), FY+Rand(-2,2), Rand(-2,2)+Width/2, Screen->D[D_HORIZON_FX], 1, 0, 0, 0, true, OP_TRANS);
				Screen->Circle(3, FX+Rand(-2,2), FY+Rand(-2,2), Rand(-2,2)+Width/3, Screen->D[D_HORIZON_FX], 1, 0, 0, 0, true, OP_OPAQUE);
			}
			Waitframe();
		}
		
		this->DeadState = 0;
	}
	void DrawLaser(int layer, int x, int y, int width, int rotation, int color, int Trans){
		Screen->Circle(layer, x+width, y, width, color, 1, x, y, rotation, true, Trans);
		Screen->Rectangle(layer, x+width, y-width, x+width+600, y+width, color, 1, x, y, rotation, true, Trans);
	}
	void Laser(int layer, int x, int y, int width, int rotation, int damage, int color){
		DrawLaser(layer, x, y, width, rotation, color, OP_OPAQUE);
		if(damage>0)LaserDetect(x, y, width, rotation, damage);
	}
	void LaserDetect(int x, int y, int width, int rotation, int damage){
		width = Max(1, width-3);
		if(RotRectCollision(x+VectorX(170, rotation), y+VectorY(170, rotation), 340, width, rotation, CenterLinkX(), CenterLinkY(), 7, 7, 0, false)){
			DamageLinkSolar(damage);
		}
	}
}


void DamageLinkSolar(int Damage){
	eweapon e = FireEWeapon(EW_SOLAR, Link->X+InFrontX(Link->Dir, 12), Link->Y+InFrontY(Link->Dir, 12), 0, 0, Damage, -1, -1, EWF_UNBLOCKABLE);
	e->Dir = Link->Dir;
	e->DrawYOffset = -1000;
	SetEWeaponLifespan(e, EWL_TIMER, 1);
	SetEWeaponDeathEffect(e, EWD_VANISH, 0);
}


eweapon script HorizonLargeShot{
	void DrawBigShot(int x, int y, int rad, int damage, int i){
		int r = rad+2*Sin(i);
		
		float Scale = 1.0;
		int ColorOffset=0;
		Screen->Circle(2, x, y, rad*Scale+5*Sin(i*3)+2, C_WHITE, 1, 0, 0, 0, true, OP_TRANS);
		for(Scale = 1.0; Scale>0.46; Scale-=.06){
			Screen->Circle(3, x, y, rad*Scale+2*Sin(i*3), C_GOLD2-ColorOffset, 1, 0, 0, 0, true, 128);
			ColorOffset++;
		}
		/* Screen->Circle(2, x, y, rad+2*Sin(i), clr[0], 1, 0, 0, 0, true, 128);
		Screen->Circle(2, x, y, rad*0.875+2*Sin(i), clr[1], 1, 0, 0, 0, true, 128);
		Screen->Circle(2, x, y, rad*0.625+2*Sin(i), clr[2], 1, 0, 0, 0, true, 128); */
		MakeHitbox(EW_SOLAR, x-r*0.7071, y-r*0.7071, r*2*0.7071, r*2*0.7071, damage);
	}
	void run(){
		int i=0;
		int rad = 8;
		while(this->isValid()){
			++i;
			if(i%3==0 && rad<24)rad++;
			DrawBigShot(CenterX(this), CenterY(this), rad, this->Damage, i);
			Waitframe();
		}
	}
}



void DrawHorizonSword(int sx, int sy, int angle, int dist, int swordlength, int damage, int TrailAngle, int TrailSpacing, int FlareDuration){
	int x = sx + VectorX(dist+(swordlength-1)*8, angle)-(swordlength-1)*8;
	int y = sy + VectorY(dist+(swordlength-1)*8, angle);
	
	if(TrailSpacing){
		int CurrentAngle = TrailAngle;
		int MaxTrailSpacing = TrailSpacing;
		for(int i=1; i<TrailSpacing; ++i){
			//CurrentAngle = TrailAngle+AngDiff(TrailAngle, angle)/TrailSpacing*i;
			CurrentAngle = Lerp(angle, TrailAngle, Lerp(0, i/(TrailSpacing-1), TrailSpacing/(MaxTrailSpacing-1)));
			
			int x2 = sx + VectorX(dist+(swordlength-1)*8, CurrentAngle)-(swordlength-1)*8;
			int y2 = sy + VectorY(dist+(swordlength-1)*8, CurrentAngle);
			Screen->DrawTile(2, x2, y2-32, TIL_HORIZONSWORDTRAIL+4-(swordlength-1)+(G[G_ANIM]%4*100), 5, 5, 3, -1, -1, x2, y2-32, CurrentAngle, 0, true, OP_TRANS); //I fucking hate this program
			if(i>TrailSpacing/2)Screen->DrawTile(2, x2, y2-32, TIL_HORIZONSWORDTRAIL+4-(swordlength-1)+(G[G_ANIM]%4*100), 5, 5, 3, -1, -1, x2, y2-32, CurrentAngle, 0, true, OP_TRANS); //This is so stupid
			
			if(i==1){
				for(int g=swordlength; g>1; --g){
					if(Rand(-2,g)>1 && FlareDuration){
						x2 = sx + Rand(-3,3) + VectorX(dist+(g)*16-4, CurrentAngle);
						y2 = sy + Rand(-3,3) + VectorY(dist+(g)*16-4, CurrentAngle);
						
						eweapon e = FireEWeapon(EW_SOLAR, x2, y2, DegtoRad(CurrentAngle), 0, 2, SPR_HORIZONFIRE, -1, EWF_UNBLOCKABLE);
						e->HitWidth=12; e->HitHeight=12;
						e->HitXOffset=2; e->HitYOffset=2;
						SetEWeaponLifespan(e, EWL_TIMER, FlareDuration);
						SetEWeaponDeathEffect(e, EWD_VANISH, 0);
					}
				}
			}
		}
	}
	
	Screen->DrawTile(2, x, y, TIL_HORIZONSWORD+4-(swordlength-1)+(G[G_ANIM]%4*20), swordlength, 1, 3, -1, -1, x, y, angle, 0, true, 128);
	for(int i=0; i<swordlength; ++i){
		x = sx + VectorX(dist+16*i, angle);
		y = sy + VectorY(dist+16*i, angle);
		MakeHitbox(EW_SOLAR, x, y, 16, 16, damage);
	}
}

/* Uses the weapon's tile, cset, and angle for the graphics and direction of the fist. It's expected that the weapon will be created with -1000 DrawYOffset and no collision
Extend the fist from the center of a 1x1 weapon. So x+8, y+8 is the point of rotation */
eweapon script HorizonWeave{
	void DrawFist(eweapon this, bitmap b, bitmap b2, int tile, int cset, int extend, int multipliers, int percent, bool doColl, bool Push){
		b->Clear(0);
		b2->Clear(0);
		int angle = RadtoDeg(this->Angle);
 
		//Draw the tile to the top half of the bitmap
		b->DrawTile(0, -(80-extend), 0, tile, 5, 2, cset, -1, -1, 0, 0, 0, 0, true, 128);
		//Draw scanlines to the bottom half one by one offset based on multipliers
		for(int i=0; i<32; ++i){
			int len = Clamp(extend*percent*multipliers[i], 0, extend);
			b->Blit(0, b2, 0, i, extend, 1, -(extend-len), i, extend, 1, 0, 0, 0, 0, 0, true);
		}
 
		//Draw the portal circle
		int portalX = this->X+8;
		int portalY = this->Y+8;
		for(int i=1; i>=0.8; i-=0.1){
			int x = portalX+Rand(-1, 1);
			int y = portalY+Rand(-1, 1);
			Screen->Ellipse(2, x, y, 20*i+Rand(2), 7*i+Rand(2), Screen->D[D_HORIZON_FX], 1, x, y, angle+90, true, 128);
		}
		//Draw the cropped bitmap to the screen with rotation. Pray it works.
		int x = this->X+8-40+VectorX(40, angle);
		int y = this->Y+8-16+VectorY(40, angle);
		b2->Blit(2, RT_SCREEN, 0, 0, 80, 32, x, y, 80, 32, angle, 0, 0, 0, 0, true);
 
		//Remove 8 pixels from the end of the hitbox
		extend -= 8;
		//Calculate collisions with the hitbox
		int hitX = this->X+8+VectorX(extend/2, angle);
		int hitY = this->Y+8+VectorY(extend/2, angle);
		if(doColl || Push){
			if(RotRectCollision(hitX, hitY, extend, 20, angle, Link->X+8, Link->Y+8, 8, 8, 0, false)){
				if(Link->InvFrames>16)Link->InvFrames=16;
				if(doColl){
					DamageLink(this->Damage);
					this->Misc[1]=1;
					
				}
				if(Push){
					NoAction();
					LinkMovement_Push2(VectorX(3, angle), VectorY(3, angle));
					Link->HitDir=-1;
				}
			}
		}
	}
	void run(int extend, int telegraphTime, int extendTime, int sustainTime, int retractTime){
		bitmap b = Game->CreateBitmap(80, 32);
		b->Own();
		bitmap b2 = Game->CreateBitmap(80, 32);
		b2->Own();
		bool Collision = (1-this->Misc[1]);
 
		int multipliers[32];
		for(int i=0; i<32; ++i){
			multipliers[i] = Rand(8, 12)*0.1;
		}
		
		for(int i=0; i<telegraphTime; ++i){
			DrawFist(this, b, b2, this->Tile, this->CSet, 0, multipliers, 0, false, false);
			Waitframe();
		}
		Game->PlaySound(Choose(SFX_HORIZONPUNCH, SFX_HORIZONPUNCH2));
		for(int i=0; i<extendTime; ++i){
			Collision = (1-this->Misc[1]);
			DrawFist(this, b, b2, this->Tile, this->CSet, extend, multipliers, i/extendTime, Collision, true);
			Waitframe();
		}
		for(int i=0; i<sustainTime; ++i){
			Collision = (1-this->Misc[1]);
			DrawFist(this, b, b2, this->Tile, this->CSet, extend, multipliers, 2, Collision, true);
			
			Waitframe();
		}
		for(int i=0; i<retractTime; ++i){
			Collision = (1-this->Misc[1]);
			DrawFist(this, b, b2, this->Tile, this->CSet, extend, multipliers, 1-(i/retractTime), Collision, false);
			Waitframe();
		}
		this->DeadState = 0;
	}
}

eweapon script HorizonCloneShooter{
	void run(int FlickerTime, int NumShots, int FiringDelay){
		int i;
		for(i=0; i<FlickerTime; ++i){
			DrawClone(this, false, Choose(OP_OPAQUE, OP_TRANS, OP_TRANS, OP_TRANS)); //1:4
			Waitframe();
		}
		for(int Shots=0; Shots<NumShots; ++Shots){
			for(int g=0; g<FiringDelay; ++g){
				DrawClone(this, true, Choose(OP_OPAQUE, OP_TRANS)); //1:2
				Waitframe();
			}
			for(i=0; i<4; ++i){
				eweapon e = FireNonAngularEWeapon(EW_SOLAR, this->X, this->Y, this->Dir, 450, this->Damage, SPR_HORIZONLIGHTSTREAM, 32, EWF_UNBLOCKABLE);
				//e->MakeDirectional();
				e->Dir=this->Dir;
				e->Rotation = DirAngle(this->Dir);
				e->AutoRotate=true;
				for(int g=0; g<4; ++g){
					DrawClone(this, true, Choose(OP_OPAQUE, OP_OPAQUE, OP_TRANS)); //2:3
					Waitframe();
				}
            }
		}
		this->DeadState = 0;
		
	}
	void DrawClone(eweapon this, bool Collision, int OP){
		if(Collision)Screen->Circle(1, CenterX(this)+Rand(-1,1), CenterY(this)+Rand(-1,1), 6, C_WHITE, 1, 0, 0, 0, true, OP_TRANS);
		Screen->DrawCombo(2, this->X, this->Y-16, CMB_HORIZONCLONE+this->Dir, 1, 2, 3, -1, -1, this->X, this->Y-16, 0, 0, 0, true, OP);
		
		if(LinkCollision(this) && Collision){
			DamageLinkSolar(this->Damage);
		}
	}
}



enum{
	HPT_MODE,
	HPT_FIRINGDELAY,
	HPT_EXTENDINGTIME,
	HPT_AUTOTRACK,
	HPT_TARGETX,
	HPT_TARGETY,
	HPT_CHAINTARGETLENGTH
	
};

eweapon script HorizonGilgameshPosting{ //This is kinda spaghetti after the edits. Sorry.
	void DrawChain(eweapon e, int layer, bitmap b, int x, int y, int angle, int chainDist, int chainMax, int clr, bool chainShake, bool doColl){
		b->Clear(0);
		b->DrawTile(0, chainDist-32, 0, TIL_HORIZONSPEAR, 2, 2, 3, -1, -1, 0, 0, 0, 0, true, 128);
		int links = Ceiling((chainDist-32)/16);
		for(int i=0; i<links; ++i){
			int linkX = chainDist-48-16*i;
			int linkY = 8;
			if(chainShake){
				linkX += Rand(-1, 1);
				linkY += Rand(-1, 1);
			}
			b->FastTile(0, linkX, linkY, TIL_HORIZONSPEAR_CHAIN, 3, 128);
		}
		b->Rectangle(0, chainMax, 0, 255, 31, 0x00, 1, 0, 0, 0, true, 128);
		b->ReplaceColors(0, clr, 0x39, 0x39);
		
		//Draw the portal circle
		int portalX = x+8;
		int portalY = y+8;
		for(int i=1; i>=0.8; i-=0.1){
			int x = portalX+Rand(-1, 1);
			int y = portalY+Rand(-1, 1);
			Screen->Ellipse(layer, x, y, 14*i+Rand(2), 5*i+Rand(2), Screen->D[D_HORIZON_FX], 1, x, y, angle+90, true, 128);
		}
		
		int bX = x+8-128+VectorX(128, angle);
		int bY = y+8-16+VectorY(128, angle);
		b->Blit(layer, RT_SCREEN, 0, 0, 256, 32, bX, bY, 256, 32, angle, 0, 0, 0, 0, true);
		
		chainDist = Min(chainDist, chainMax);
		int collX = x+8+VectorX(chainDist/2, angle);
		int collY = y+8+VectorY(chainDist/2, angle);
		if(doColl&&RotRectCollision(collX, collY, chainDist, 8, angle, Link->X+8, Link->Y+8, 4, 4, angle, false)){
			DamageLinkSolar(e->Damage);
		}
	}
	int GetColor(){
		
		if(G[G_ANIM]%4<2){
			return Choose(Rand(0x36,0x39) , 0x86, 0x87); 
		}
		else{
			return Rand(0x31, 0x33);
		}
	}
	int GetColor2(){
		if(G[G_ANIM]%4<2){
			return Choose(0x88, 0x89); 
		}
		else{
			return Choose(0x86, 0x87);
		}
	}
	void DrawMeteoriteImpact(bitmap impact, int x, int y, int c1, int c2, int scale, bool trans, int removeTop, int damage){
		impact->Clear(0);
		impact->Circle(0, scale, scale, scale, c1, 1, 0, 0, 0, true, 128);
		impact->Rectangle(0, 0, scale, scale*2-1, scale*2-1, 0x00, 1, 0, 0, 0, true, 128);
		impact->Ellipse(0, scale, scale, scale, scale*0.3333, c2, 1, 0, 0, 0, true, 128);
		if(removeTop){
			impact->Ellipse(0, scale, Lerp(0, scale, removeTop), Lerp(0, scale*2, removeTop), Lerp(0, scale, removeTop), 0x00, 1, 0, 0, 0, true, 128);
		}
		int flag;
		if(trans)
			flag = BITDX_TRANS;
		impact->Blit(6, RT_SCREEN, 0, 0, scale*2, scale*1.3333, x-scale, y-scale, scale*2, scale*1.3333, 0, 0, 0, flag, 0, true);
	
	
		// impact->Circle(0, 48, 48, scale, c1, 1, 0, 0, 0, true, 128);
		// impact->Rectangle(0, 0, 48, 95, 63, 0x00, 1, 0, 0, 0, true, 128);
		// impact->Ellipse(0, 48, 48, scale, scale*0.3333, c2, 1, 0, 0, 0, true, 128);
		// if(removeTop){
			// impact->Ellipse(0, 48, Lerp(0, 48, removeTop), Lerp(0, 96, removeTop), Lerp(0, 48, removeTop), 0x00, 1, 0, 0, 0, true, 128);
		// }
		// int flag;
		// if(trans)
			// flag = BITDX_TRANS;
		// impact->Blit(6, RT_SCREEN, 0, 0, 96, 64, x-48, y-48, 96, 64, 0, 0, 0, flag, 0, true);
	
		if(damage)
			MakeHitbox(EW_SOLAR, x-scale, y-scale, scale*2, (scale/48)*64, damage);
		impact->Clear(6);
	}
	void run(){
		bitmap b = Game->CreateBitmap(256, 32);
		b->Own();
		int TX; int TY; int extendDist; int size=42;
		
		Game->PlaySound(86);
		
		if(this->Misc[HPT_MODE]){ //Impact Thorns
			for(this->Misc[HPT_FIRINGDELAY]; this->Misc[HPT_FIRINGDELAY]>0; this->Misc[HPT_FIRINGDELAY]--){
				if(this->Misc[HPT_AUTOTRACK]){
					int TAngle=Angle(TX, TY, Link->X+8, Link->Y+8);
					this->Misc[HPT_TARGETX]+=VectorX(this->Misc[HPT_AUTOTRACK], TAngle);
					this->Misc[HPT_TARGETY]+=VectorY(this->Misc[HPT_AUTOTRACK], TAngle);
				}
				TX = this->Misc[HPT_TARGETX]; TY = this->Misc[HPT_TARGETY];
				
				for(int g=0; g<2; ++g){ //Telegraphing target
					Screen->Circle(1, TX, TY, 2+this->Misc[HPT_FIRINGDELAY]/12+g, Screen->D[D_HORIZON_FX], 1, 0, 0, 0, false, OP_OPAQUE);
				}
				extendDist = Distance(CenterX(this), CenterY(this), TX, TY)+8;
				this->Angle = DegtoRad(TurnToAngle(RadtoDeg(this->Angle), Angle(CenterX(this), CenterY(this), TX, TY), 5));
				
				DrawChain(this, 3, b, this->X, this->Y, RadtoDeg(this->Angle), 12, extendDist, GetColor2(), false, false);
				Waitframe();
			}
			int dist = 12;
			Game->PlaySound(136);
			extendDist = Distance(CenterX(this), CenterY(this), TX, TY)+8;
			while(dist<extendDist+16){
				dist = Min(dist+HORIZONSPEAR_STEP, extendDist+16);
				
				for(int g=0; g<2; ++g){
					Screen->Circle(1, TX, TY, 1+g, Screen->D[D_HORIZON_FX], 1, 0, 0, 0, false, OP_OPAQUE);
				}
				
				DrawChain(this, 3, b, this->X, this->Y, RadtoDeg(this->Angle), dist, extendDist, GetColor2(), false, false);
				Waitframe();
			}
			Game->PlaySound(SFX_HORIZONPURGINGTHORN);
			//int bitid = TempBitmap_Create(0, size*2, size*2);
			//bitmap impact = TempBMP[bitid];
			
			bitmap impact = Game->CreateBitmap(size*2, size*2);
			impact->Own();
			
			Screen->Quake=32;
			for(int i=-4; i<8; ++i){
				DrawChain(this, 3, b, this->X, this->Y, RadtoDeg(this->Angle), dist, extendDist, GetColor2(), true, false);
				if(i>0)DrawMeteoriteImpact(impact, TX, TY+8, 0x01, Screen->D[D_HORIZON_FX], size*(i/16), true, 0, this->Damage);
				Waitframe();
			}
			for(int i=8; i<16; ++i){
				DrawChain(this, 3, b, this->X, this->Y, RadtoDeg(this->Angle), dist, extendDist, GetColor2(), false, false);
				DrawMeteoriteImpact(impact, TX, TY+8, 0x01, Screen->D[D_HORIZON_FX], size*(i/16), true, 0, this->Damage);
				Waitframe();
			}
			for(int i=0; i<12; ++i){
				DrawChain(this, 3, b, this->X, this->Y, RadtoDeg(this->Angle), dist, extendDist, GetColor2(), false, false);
				DrawMeteoriteImpact(impact, TX, TY+8, 0x01, Screen->D[D_HORIZON_FX], size, true, (i/12), 0);
				Waitframe();
			}
			while(dist>-32){
				dist = Max(dist-HORIZONSPEAR_RETRACT_STEP, -32);
				DrawChain(this, 3, b, this->X, this->Y, RadtoDeg(this->Angle), dist, extendDist, GetColor2(), false, false);
				Waitframe();
			}
			//TempBitmap_Free(0, bitid);
		}
		else{ //Used for Horizon's inverse-sun super's "arms"
			
			for(this->Misc[HPT_FIRINGDELAY]; this->Misc[HPT_FIRINGDELAY]>0; this->Misc[HPT_FIRINGDELAY]--){
				DrawChain(this, 2, b, this->X, this->Y, RadtoDeg(this->Angle), 12, 999, GetColor(), false, false);
				Waitframe();
			}
			int dist = 12;
			Game->PlaySound(136);
			while(this->Misc[HPT_EXTENDINGTIME]>0){ //We'll manually set it to 0 after it's done on the boss script end.
				extendDist = this->Misc[HPT_CHAINTARGETLENGTH];
				if(dist< extendDist+12)dist = Min(dist+HORIZONSPEAR_STEP, extendDist+12);
				else if(dist > extendDist+12)dist = Max(dist-HORIZONSPEAR_STEP, extendDist+12);
				
				DrawChain(this, 2, b, this->X, this->Y, RadtoDeg(this->Angle), dist, 999, GetColor(), false, true);
				Waitframe();
			}
			while(dist>-32){
				dist = Max(dist-3, -32);
				DrawChain(this, 2, b, this->X, this->Y, RadtoDeg(this->Angle), dist, 999, GetColor(), true, true);
				Waitframe();
			}
		}
		this->DeadState = 0;
	}
}

generic script BigSwordFall{
	void DrawBitmapEnergyRing(bitmap scrnBuffer, int cx, int cy, int radius, int thickness, int variance, int c, int points, int angle){
		int i; int j; 
		int pointX1[512];
		int pointY1[512];
		int pointX2[512];
		int pointY2[512];
	 
		int quadAngle = 360/points;
	 
		for(i=0; i<=points; ++i){
			if(i==points){
				pointX1[i] = pointX1[0];
				pointY1[i] = pointY1[0];
				pointX2[i] = pointX2[0];
				pointY2[i] = pointY2[0];
			}
			else{
				j = Rand(variance)-(variance/2);
				pointX1[i] = cx+VectorX(radius+j-thickness/2, angle+quadAngle*i);
				pointY1[i] = cy+VectorY(radius+j-thickness/2, angle+quadAngle*i);
				pointX2[i] = cx+VectorX(radius+j+thickness/2, angle+quadAngle*i);
				pointY2[i] = cy+VectorY(radius+j+thickness/2, angle+quadAngle*i);
			}
		}
		for(i=0; i<points; ++i){
			scrnBuffer->Quad(6, pointX1[i], pointY1[i], pointX1[i+1], pointY1[i+1], pointX2[i+1], pointY2[i+1], pointX2[i], pointY2[i], 1, 1, c, 0, -1, PT_FLAT, NULL);
		}
	}
	void DrawBigSword(int layer, bitmap scrnBuffer, bitmap swordA, bitmap swordB, int swordTipX, int swordTipY, int swordAng, int portalX, int portalY, int groundY, bool drawAura, bool toScreen){
		swordA->Clear(0);
		swordB->Clear(0);
 
		int swordX = swordTipX-128-VectorX(128, swordAng);
		int swordY = swordTipY-32-VectorY(128, swordAng);
 
		swordA->DrawTile(0, swordX, swordY, TIL_HORIZONBIGSWORD, 16, 4, 8, -1, -1, swordX, swordY, swordAng-180, 0, true, 128);
		swordX += Rand(-2, 2);
		swordY += Rand(-2, 2);
		swordB->DrawTile(0, swordX, swordY, TIL_HORIZONBIGSWORD+80, 16, 4, 8, -1, -1, swordX, swordY, swordAng-180, 0, true, 128);
 
		int portalMaskXOff = Rand(-4, 4);
		int portalMaskYOff = Rand(-4, 4);
		swordB->Rectangle(0, portalX+portalMaskXOff, portalY-48+portalMaskYOff, portalX+128+portalMaskXOff, portalY+48+portalMaskYOff, 0x00, 1, portalX+portalMaskXOff, portalY+portalMaskYOff, swordAng+180, true, 128);
		swordA->Rectangle(0, portalX+portalMaskXOff, portalY-48+portalMaskYOff, portalX+128+portalMaskXOff, portalY+48+portalMaskYOff, 0x00, 1, portalX+portalMaskXOff, portalY+portalMaskYOff, swordAng+180, true, 128);
 
		swordB->Rectangle(0, 0, groundY, 255, 176, 0x00, 1, 0, 0, 0, true, 128);
		swordA->Rectangle(0, 0, groundY, 255, 176, 0x00, 1, 0, 0, 0, true, 128);
 
		if(toScreen){
			if(drawAura)
				swordB->Blit(layer, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_TRANS, 0, true);
			swordA->Blit(layer, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_NORMAL, 0, true);
		}
		else{
			if(drawAura)
				swordB->Blit(layer, scrnBuffer, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_TRANS, 0, true);
			swordA->Blit(layer, scrnBuffer, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_NORMAL, 0, true);
		}
	}
	void DrawSwordPortal(int layer, bitmap scrnBuffer, int portalX, int portalY, int r, int angle){
		for(int i=1; i>=0.8; i-=0.1){
			int x = portalX+Rand(-1, 1);
			int y = portalY+Rand(-1, 1);
			scrnBuffer->Ellipse(layer, x, y, r*i+Rand(2), r*0.2*i+Rand(2), Rand(0x31, 0x39), 1, x, y, angle+90, true, 128);
		}
	}
	void run(){
		bitmap swordA = Game->CreateBitmap(256, 176);
		swordA->Own();
		bitmap swordB = Game->CreateBitmap(256, 176);
		swordB->Own();
 
		bitmap lowerScreen = Game->CreateBitmap(256, 176);
		lowerScreen->Own();
		bitmap upperScreen = Game->CreateBitmap(256, 176);
		upperScreen->Own();
 
		bitmap scrnBuffer = Game->CreateBitmap(256, 176);
		scrnBuffer->Own();
 
		lowerScreen->Clear(0);
		upperScreen->Clear(0);
		lowerScreen->BlitTo(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_NORMAL, 0, false);
		upperScreen->DrawLayer(6, MAP_HORIZON_SKY, SCREEN_HORIZON_SKY, 0, 0, 0, 0, 128);
 
		for(int scrnY=0; scrnY<176; scrnY+=8){
			lowerScreen->Blit(6, scrnBuffer, 0, 0, 256, 176, 0, scrnY, 256, 176, 0, 0, 0, BITDX_NORMAL, 0, false);
			upperScreen->Blit(6, scrnBuffer, 0, 0, 256, 176, 0, scrnY-176, 256, 176, 0, 0, 0, BITDX_NORMAL, 0, false);
			scrnBuffer->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_NORMAL, 0, false);
			Waitframe();
		}
		int portalX = 160;
		int portalY = 16-176;
		int swordX = portalX;
		int swordY = portalY;
		int swordAng = Angle(portalX, portalY, 128, 96);
		for(int i=0; i<32; ++i){
			upperScreen->Blit(6, scrnBuffer, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_NORMAL, 0, false);
			scrnBuffer->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_NORMAL, 0, false);
			Waitframe();
		}
		int portalScale;
		Game->PlaySound(SFX_HORIZONSWORDAPPEAR);
		for(int i=0; i<3; ++i){ //Portal Growing
			int portalMin = portalScale;
			int portalMax = 32+i*(32+i*8);
			for(int j=0; j<8; ++j){ //Expand in steps
				portalScale = Lerp(portalMin, portalMax, j/7);
				upperScreen->Blit(6, scrnBuffer, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_NORMAL, 0, false);
				DrawSwordPortal(6, scrnBuffer, portalX, portalY+176, portalScale, swordAng);
				scrnBuffer->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_NORMAL, 0, false);
				Waitframe();
			}
			for(int j=0; j<16; ++j){
				upperScreen->Blit(6, scrnBuffer, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_NORMAL, 0, false);
				DrawSwordPortal(6, scrnBuffer, portalX, portalY+176, portalScale, swordAng);
				scrnBuffer->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_NORMAL, 0, false);
				Waitframe();
			}
		}
		for(int i=0; i<24; ++i){
			upperScreen->Blit(6, scrnBuffer, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_NORMAL, 0, false);
			DrawSwordPortal(6, scrnBuffer, portalX, portalY+176, portalScale, swordAng);
			scrnBuffer->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_NORMAL, 0, false);
			Waitframe();
		}
		for(int i=0; i<64; ++i){ //Sword descends slow
			upperScreen->Blit(6, scrnBuffer, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_NORMAL, 0, false);
			DrawSwordPortal(6, scrnBuffer, portalX, portalY+176, portalScale, swordAng);
			swordX += VectorX(0.5, swordAng);
			swordY += VectorY(0.5, swordAng);
			DrawBigSword(6, scrnBuffer, swordA, swordB, swordX+Rand(-4, 4), swordY+Rand(-4, 4)+176, swordAng, portalX, portalY+176, 176, true, false);
			scrnBuffer->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_NORMAL, 0, false);
			Waitframe();
		}
		Game->PlaySound(SFX_HORIZONSWORDDROP);
		for(int i=0; i<32; ++i){ //Sword descends faster
			upperScreen->Blit(6, scrnBuffer, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_NORMAL, 0, false);
			DrawSwordPortal(6, scrnBuffer, portalX, portalY+176, portalScale, swordAng);
			swordX += VectorX(1, swordAng);
			swordY += VectorY(1, swordAng);
			DrawBigSword(6, scrnBuffer, swordA, swordB, swordX+Rand(-2, 2), swordY+Rand(-2, 2)+176, swordAng, portalX, portalY+176, 176, true, false);
			scrnBuffer->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_NORMAL, 0, false);
			Waitframe();
		}
		bool touchedGround;
		int CLR = Choose(0x86, 0x87);
		int ShockwaveRad=0;
		for(int scrnY=176; scrnY>0; scrnY-=4){ //Screen pans back down
			lowerScreen->Blit(6, scrnBuffer, 0, 0, 256, 176, 0, scrnY, 256, 176, 0, 0, 0, BITDX_NORMAL, 0, false);
			upperScreen->Blit(6, scrnBuffer, 0, 0, 256, 176, 0, scrnY-176, 256, 176, 0, 0, 0, BITDX_NORMAL, 0, false);
			DrawSwordPortal(6, scrnBuffer, portalX, portalY+scrnY, portalScale, swordAng);
			if(!touchedGround&&Distance(swordX, swordY, 128, 96)>8){ //The sword has not yet touched the ground
				swordX += VectorX(8, swordAng);
				swordY += VectorY(8, swordAng);
				DrawBigSword(6, scrnBuffer, swordA, swordB, swordX+Rand(-1, 1), swordY+Rand(-1, 1)+scrnY, swordAng, portalX, portalY+scrnY, 96+scrnY, true, false);
			}
			else{ //The sword has touched the ground. [EVAN] start impact animation here. It will need to be a function that draws once per frame to layer 6
				touchedGround = true;
				Game->PlaySound(SFX_HORIZONSWORDIMPACT);
				swordX += VectorX(4, swordAng);
				swordY += VectorY(4, swordAng);
				ShockwaveRad+=6;
				CLR = Choose(C_GOLD1, 0x86, 0x87);
				DrawBitmapEnergyRing(scrnBuffer, 128, 96,  ShockwaveRad, 24, 16, CLR, 24, Rand(-5,5));
				DrawBigSword(6, scrnBuffer, swordA, swordB, swordX+Rand(-3, 3), swordY+Rand(-3, 3)+scrnY, swordAng, portalX, portalY+scrnY, 96+scrnY, true, false);
				
				if(Distance(128, 96, Link->X+8, Link->Y+8)<32)DamageLinkSolar(DMG_SOLARFINALITY/4);
			}
			scrnBuffer->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_NORMAL, 0, false);
			
			Waitframe();
		}
		bool hit=false;
		while(Distance(swordX, swordY, 128, 96)<128){ //Wait for the sword to fully lodge itself in the groun
			
			ShockwaveRad+=6;
			NoAction();
			if(Distance(128, 96, Link->X+8, Link->Y+8)<ShockwaveRad){
				G[G_DRAWNHPZERO]=1;
				if(!hit){
					hit=true;
					DamageNumbers_AddNumberGFX(CenterLinkX(), CenterLinkY()-DAMAGENUMBERS_HEIGHT/2, _DNUM_TYPE_LINKDAMAGE, Round(DMG_SOLARFINALITY/4));
				}
			}
			CLR = Choose(C_GOLD1, 0x86, 0x87);
			
		
			lowerScreen->Blit(6, scrnBuffer, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_NORMAL, 0, false);
			swordX += VectorX(4, swordAng);
			swordY += VectorY(4, swordAng);
			DrawBitmapEnergyRing(scrnBuffer, 128, 96,  ShockwaveRad, 24, 16, CLR, 24, Rand(-5,5));
			DrawBigSword(6, scrnBuffer, swordA, swordB, swordX+Rand(-3, 3), swordY+Rand(-3, 3)+0, swordAng, portalX, portalY+0, 96+0, true, false);
			scrnBuffer->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_NORMAL, 0, false);
			
			Waitframe();
		}
	}
}

void DrawEnergyRing(int layer, int cx, int cy, int radius, int thickness, int variance, int c, int points, int angle){
	int i; int j; 
	int pointX1[512];
	int pointY1[512];
	int pointX2[512];
	int pointY2[512];
 
	int quadAngle = 360/points;
 
	for(i=0; i<=points; ++i){
		if(i==points){
			pointX1[i] = pointX1[0];
			pointY1[i] = pointY1[0];
			pointX2[i] = pointX2[0];
			pointY2[i] = pointY2[0];
		}
		else{
			j = Rand(variance)-(variance/2);
			pointX1[i] = cx+VectorX(radius+j-thickness/2, angle+quadAngle*i);
			pointY1[i] = cy+VectorY(radius+j-thickness/2, angle+quadAngle*i);
			pointX2[i] = cx+VectorX(radius+j+thickness/2, angle+quadAngle*i);
			pointY2[i] = cy+VectorY(radius+j+thickness/2, angle+quadAngle*i);
		}
	}
	for(i=0; i<points; ++i){
		Screen->Quad(layer, pointX1[i], pointY1[i], pointX1[i+1], pointY1[i+1], pointX2[i+1], pointY2[i+1], pointX2[i], pointY2[i], 1, 1, c, 0, -1, PT_FLAT);
	}
}

eweapon script HorizonSwordShockwave{
	//3, 1.085, X, X, 1.2
	
	void run(float InitalRadius, float ExpansionMult, float InitialAngle, float AngleIncrement, float AngleMult){
		float Radius = InitalRadius;
		float TAngle[5];
		for(int i=0; i<5; ++i){
			TAngle[i]=InitialAngle+360/5*i;
		}
		
		bool hit=false;
		//I would kill for an array of Vec3f right now
		int TX1[12];
		int TY1[12];
		
		int TX2[12];
		int TY2[12];
		
		int TX3[12];
		int TY3[12];
		
		int TX4[12];
		int TY4[12];
		
		int TX5[12];
		int TY5[12];
		for(int i=0; i<12; ++i){
			TX1[i]=this->X+8;
			TY1[i]=this->X+8;
			
			TX2[i]=this->X+8;
			TY2[i]=this->X+8;
			
			TX3[i]=this->X+8;
			TY3[i]=this->X+8;
			
			TX4[i]=this->X+8;
			TY4[i]=this->X+8;
			
			TX5[i]=this->X+8;
			TY5[i]=this->X+8;
		}
		
		//This is so stinky
		//2.55 might have a better way to do this, but this isn't getting done tomorrow if I spend the whole night digging through the datatype documentation
		for(int frames=0; frames<60; ++frames){
			if(frames<48){
				Radius= Radius*ExpansionMult;
				for(int i=0; i<5; ++i){
					TAngle[i]= WrapDegrees(TAngle[i]+AngleIncrement+AngleMult*frames);
				}
			}
			if(frames==24)Game->PlaySound(78);
			for(int i=0; i<12; ++i){
				if(i==0){
					for(int g=1; g<12; ++g){
						DrawThickLine(3,  TX1[i], TY1[i], TX1[g], TY1[g], 1, Screen->D[D_HORIZON_FX], true, OP_OPAQUE);
						DrawThickLine(3,  TX2[i], TY2[i], TX2[g], TY2[g], 1, Screen->D[D_HORIZON_FX], true, OP_OPAQUE);
						DrawThickLine(3,  TX3[i], TY3[i], TX3[g], TY3[g], 1, Screen->D[D_HORIZON_FX], true, OP_OPAQUE);
						DrawThickLine(3,  TX4[i], TY4[i], TX4[g], TY4[g], 1, Screen->D[D_HORIZON_FX], true, OP_OPAQUE);
						DrawThickLine(3,  TX5[i], TY5[i], TX5[g], TY5[g], 1, Screen->D[D_HORIZON_FX], true, OP_OPAQUE);
					}
				}
				if(i<11){
					DrawThickLine(3,  TX1[i], TY1[i], TX1[i+1], TY1[i+1], 1, Screen->D[D_HORIZON_FX], true, OP_OPAQUE);
					TX1[i]=TX1[i+1];
					TY1[i]=TY1[i+1];
					DrawThickLine(3,  TX2[i], TY2[i], TX2[i+1], TY2[i+1], 1, Screen->D[D_HORIZON_FX], true, OP_OPAQUE);
					TX2[i]=TX2[i+1];
					TY2[i]=TY2[i+1];
					DrawThickLine(3,  TX3[i], TY3[i], TX3[i+1], TY3[i+1], 1, Screen->D[D_HORIZON_FX], true, OP_OPAQUE);
					TX3[i]=TX3[i+1];
					TY3[i]=TY3[i+1];
					DrawThickLine(3,  TX4[i], TY4[i], TX4[i+1], TY4[i+1], 1, Screen->D[D_HORIZON_FX], true, OP_OPAQUE);
					TX4[i]=TX4[i+1];
					TY4[i]=TY4[i+1];
					DrawThickLine(3,  TX5[i], TY5[i], TX5[i+1], TY5[i+1], 1, Screen->D[D_HORIZON_FX], true, OP_OPAQUE);
					TX5[i]=TX5[i+1];
					TY5[i]=TY5[i+1];
				}
				else{
					TX1[i]=this->X+8+VectorX(Radius+frames, TAngle[0]);
					TY1[i]=this->Y+8+VectorY(Radius+frames, TAngle[0]);
					TX2[i]=this->X+8+VectorX(Radius+frames, TAngle[1]);
					TY2[i]=this->Y+8+VectorY(Radius+frames, TAngle[1]);
					TX3[i]=this->X+8+VectorX(Radius+frames, TAngle[2]);
					TY3[i]=this->Y+8+VectorY(Radius+frames, TAngle[2]);
					TX4[i]=this->X+8+VectorX(Radius+frames, TAngle[3]);
					TY4[i]=this->Y+8+VectorY(Radius+frames, TAngle[3]);
					TX5[i]=this->X+8+VectorX(Radius+frames, TAngle[4]);
					TY5[i]=this->Y+8+VectorY(Radius+frames, TAngle[4]);
				}
			}
			
			if(!hit && Distance(this->X, this->Y, Link->X, Link->Y)<Radius+frames){
				hit=true;
				Game->PlaySound(19);
				DamageNumbers_AddNumberGFX(CenterLinkX(), CenterLinkY()-DAMAGENUMBERS_HEIGHT/2, _DNUM_TYPE_LINKDAMAGE, Round(DMG_SOLARFINALITY/Choose(5,6,7,8,9)));
			}
			
			DrawEnergyRing(3, this->X+8, this->Y+8, Radius, 3, frames/4, Screen->D[D_HORIZON_FX], 5, TAngle[0]);
			Waitframe();
		}
		
	}
}

enum {
	HSS_MAXRADIUS,
	HSS_WANDERTIME,
	HSS_SHOTDELAY,
	HSS_MAXVEER,
	HSS_STEPDECAY
};

eweapon script HorizonSwarmSphere{
	void run(){
		int InitX = this->X;
		int InitY = this->Y;
		int Random;
		Game->PlaySound(94);
		
		for(this->Misc[HSS_WANDERTIME]; this->Misc[HSS_WANDERTIME]>=0; --this->Misc[HSS_WANDERTIME]){
			this->Angle += DegtoRad(Choose(Rand(this->Misc[HSS_MAXVEER]*-1, 0), 0, Rand(0, this->Misc[HSS_MAXVEER])));
			
			while(Distance(InitX, InitY, this->X, this->Y)>this->Misc[HSS_MAXRADIUS]){
				int TAngle = Angle(this->X, this->Y, InitX, InitY);
				this->X += VectorX(2, TAngle);
				this->Y += VectorY(2, TAngle);
			}
			if(this->Step >100)this->Step-= this->Misc[HSS_STEPDECAY];
			Screen->Circle(2, this->X+8, this->Y+8, 6+Rand(1,2), C_WHITE, 1, 0, 0, 0, true, OP_TRANS);
			Screen->Circle(3, this->X+8, this->Y+8, 5, Screen->D[D_HORIZON_FX], 1, 0, 0, 0, true, OP_OPAQUE);
			if(LargeDistance(this->X+8, this->Y+8, Link->X+8, Link->Y+8, 1)<=5){
				DamageLinkSolar(this->Damage);
			}
			Waitframe();
		}
		this->Step=0;
		for(this->Misc[HSS_SHOTDELAY]; this->Misc[HSS_SHOTDELAY]>=0; --this->Misc[HSS_SHOTDELAY]){
			Random = Rand(0,1);
			int CLR = Screen->D[D_HORIZON_FX];
			if(this->Misc[HSS_SHOTDELAY]<=10){
				Screen->Circle(2, this->X+8, this->Y+8, 8+Random, C_WHITE, 1, 0, 0, 0, true, OP_OPAQUE);
				CLR=C_WHITE;
			}
			else Screen->Circle(2, this->X+8, this->Y+8, 6+Random, C_WHITE, 1, 0, 0, 0, true, OP_TRANS);
			Screen->Circle(3, this->X+8, this->Y+8, 5+Random, CLR, 1, 0, 0, 0, true, OP_OPAQUE);
			if(LargeDistance(this->X+8, this->Y+8, Link->X+8, Link->Y+8, 1)<=5){
				DamageLinkSolar(this->Damage);
			}
			Waitframe();
		}
		this->Step=450;
		this->Angle = DegtoRad(Angle(CenterX(this), CenterY(this), Link->X+8, Link->Y+8));
		Game->PlaySound(SFX_HORIZONSHOT);
		int TrailX[8];
		int TrailY[8];
		for(int g=SizeOfArray(TrailX)-1; g>=0; --g){
			TrailX[g]=this->X;
			TrailY[g]=this->Y;
		}
		
		for(int i=0; i<60; ++i){
			Random = Rand(0,1);
			Screen->Circle(2, this->X+8, this->Y+8, 8+Random, C_WHITE, 1, 0, 0, 0, true, OP_TRANS);
			int Opacity = Choose(OP_TRANS, OP_OPAQUE, OP_OPAQUE);
			for(int g=SizeOfArray(TrailX)-1; g>=0; --g){
				int Sizemod = 3;
				if(g<5)Sizemod=2;
				if(g<2)Sizemod=1;
				Screen->Circle(2, TrailX[g]+8, TrailY[g]+8, 6+Random-Sizemod, Screen->D[D_HORIZON_FX], 1, 0, 0, 0, true, Opacity);
				if(g>0){
					TrailX[g]=TrailX[g-1];
					TrailY[g]=TrailY[g-1];
				}
				else{
					TrailX[g]=this->X;
					TrailY[g]=this->Y;
				}
			}
			
			Screen->Circle(3, this->X+8, this->Y+8, 6+Random, Screen->D[D_HORIZON_FX], 1, 0, 0, 0, true, OP_OPAQUE);
			if(LargeDistance(this->X+8, this->Y+8, Link->X+8, Link->Y+8, 1)<=6){
				DamageLinkSolar(this->Damage);
			}
			Waitframe();
		}
		this->DeadState=0;
	}
}

//Set up instructions:

//Make enemy with 30000 HP, 6 damage, 4 Wdamage, and half damage resistances to all solar and stellar damage types
//Copy tiles from Chase's page and the ones after that
//Copy combos from 52224 down
//Suffer palette color and brush torture.
//Wish you'd just ported Yuurand Horizon or something instead jesus fuck
//Keep importing palettes. Yes that many yellows are necessary to make this boss look good in this god forsaken tileset
//Make sure the unwalkable areas on the map are all completely solid so fast-moving projectiles don't clip through corners of collision. Use a layer 2 brush of invisible solid combos. This is extremely important, do not skip this or the fight will be way worse.
//It's still not too late to copypaste Yuurand Horizon...
//Set up sprites
//Export sound effects from the sample quest and change the constants to reflect their new slot order in the final build.
//A few sounds are hardcoded that use existing sounds you've already slotted in to save you some time. If you hate them, I can change them later, but I don't suspect it'll matter much.
//Set up the myriad of eweapon scripts. Don't worry about slot IDs, this calls them by name.
//You'd probably be done setting up Yuurand Horizon by now...
//Make sure Horizon cannot be lifted in the Lunar Battery Exceptions
//Paint the unwalkable areas of the arena in Flag 96. Fucking Cursetelations. Make sure they respect no enemy on this boss screen. I've done this on Layer 2 of the screen the fight actually takes place on. The boss only pulls layers 0 & 1 from the alt screens.
//Speaking of Cursetelations, reimport those as Horizon needs to sometimes give them some ritalin and settle down for certain attacks.
//Make sure the script that spawns this enemy sets "BossType" against whatever global register you wish to store the outcome of the pre-fight dialogue prompts with. It's at the very top of the main script with further instructions and easy to find.
//Search for "CHASE CUTSCENE" in certain points of the script where you launch the cutscene scripts where each branch of the fight ends.
//You could still trade in the skateboard for Yuurand Horizon you know....
//Contemplate suicide over the amount of wasted tilespace the sword trail consumes. I hate this fucking program.
//Make sure Asher can't use Nuke Meteor on the boss DMap or all the palette stuff might break or at the very least look really ugly.
//Integrate Dash/Burn interactions however you see fit.
//Stop the little green "1" from coming up after the player gets exploded by a phase transition. I have no idea why tf this happens.
//Unfuck the Tango at "REPLACE STRINGS HERE"
//