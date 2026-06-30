const bool RANDOMIZER_DEBUG = false;
const bool RANDOMIZER_ENABLE_MULTIWORLD = false;

const int SFX_RANDMENUSELECT = 5;
const int SFX_RANDMENUKEYPRESS = 5;
const int SFX_RANDMENUBACKSPACE = 21;
const int SFX_RANDMENUCONFIRM = 5;

const int FONT_RANDMENU = FONT_Z1;

const int I_LUNARANG = 24;
const int I_HYMNSTONE = 87;

const int I_HC_ASHER = 70;
const int I_HC_TORRIN = 72;
const int I_HC_KAYLANI = 73;
const int I_HC_SOREN = 49;
const int I_HC_TERRY = 112;
const int I_HC_SIYED = 113;

const int I_AUGMENTSLOT_ASHER = 71;
const int I_AUGMENTSLOT_TORRIN = 16;
const int I_AUGMENTSLOT_KAYLANI = 57;
const int I_AUGMENTSLOT_SOREN = 115;
const int I_AUGMENTSLOT_TERRY = 116;
const int I_AUGMENTSLOT_SIYED = 117;

const int WINNO_COOLDOWN = 600;

ffc script RandomizerMenu{
	enum SeedSettings{
		SSET_SEED,
		SSET_STARTINGCHAR,
		SSET_NUMCHARS,
		SSET_BESTIARYRAND,
		SSET_RANDOMODE,
		SSET_OBSERVATORYLOCK,
		SSET_MULTIPLAYER,
		SSET_CONFIRM
	};
	void run(){
		
		//Set these to the proper values here to avoid messing them up in story mode
		G[G_SORENHP] = 64;
		G[G_SORENMAXHP] = 64;
		G[G_TERRYHP] = 64;
		G[G_TERRYMAXHP] = 64;
		G[G_SIYEDHP] = 64;
		G[G_SIYEDMAXHP] = 64;
		G[G_SIYEDMP] = Link->MaxMP;
			
		int digits[6] = {0, 0, 0, 0, 0, 0};
		for(int i=0; i<6; ++i){
			digits[i] = Rand(16);
		}
		int settings[] = {digits, 0, 3, 0, 0, 0, 0};
		int enabled[16];
		AddEnabled(enabled, SSET_SEED);
		AddEnabled(enabled, SSET_STARTINGCHAR);
		AddEnabled(enabled, SSET_NUMCHARS);
		AddEnabled(enabled, SSET_BESTIARYRAND);
		AddEnabled(enabled, SSET_RANDOMODE);
		AddEnabled(enabled, SSET_OBSERVATORYLOCK);
		if(RANDOMIZER_ENABLE_MULTIWORLD)
			AddEnabled(enabled, SSET_MULTIPLAYER);
		AddEnabled(enabled, SSET_CONFIRM);
		int selection = 0;
		int seedDigit = -1;
		bool confirm;
		
		int guyCmb[12];
		int guyDir[12];
		int guyDrawOrder[12];
		int guyScale[12];
		int guyX[12];
		int guyY[12];
		int guyYSpeed[12];
		int guyCombos[] = {33284, 33292, 33300, 33832, 33556, 33764, 33308, 33324, 33332, 33340, 33348, 33356, 33364, 33372, 33380, 33484, 33564, 33572, 33588, 33596, 33604, 33612, 33628, 33636, 33652, 33660, 33668, 33676, 33684, 33692, 33700, 33716, 33772, 33792, 33808, 33848, 51620, 51816, 51776};
		
		int guys[] = {guyCmb, guyDir, guyDrawOrder, guyScale, guyX, guyY, guyYSpeed, guyCombos, DIR_DOWN, 32};
		
		long finalSeed = 0;
		for(int i=0; i<6; ++i){
			finalSeed |= (digits[i]*1L)<<(4*(5-i));
		}
		
		int maxCombos = SizeOfArray(guyCombos);
		for(int i=0; i<12; ++i){
			guyX[i] = Rand(-15, 255);
			guyY[i] = Rand(176);
			guyYSpeed[i] = 0.8; //Rand(4, 12)/10;
			guyScale[i] = Choose(0.5, 0.75, 1, 1, 2, 2);
			guyCmb[i] = NewComboNoDupes(i, guyCombos, maxCombos, guyCmb);
		}
				
		while(!confirm){
			bool exitSeed;
			if(seedDigit<=-1){
				if(Link->PressUp){
					Game->PlaySound(SFX_RANDMENUSELECT);
					
					--selection;
					if(selection<0)
						selection = enabled[0]-1;
				}
				if(Link->PressDown){
					Game->PlaySound(SFX_RANDMENUSELECT);
					
					++selection;
					if(selection>enabled[0]-1)
						selection = 0;
				}
			}
			else{
				if(Link->PressUp){
					Game->PlaySound(SFX_RANDMENUSELECT);
					
					++digits[seedDigit];
					if(digits[seedDigit]>15)
						digits[seedDigit] = 0;
				}
				else if(Link->PressDown){
					Game->PlaySound(SFX_RANDMENUSELECT);
					
					--digits[seedDigit];
					if(digits[seedDigit]<0)
						digits[seedDigit] = 15;
				}
				else{
					if(Input->KeyPress[KEY_DEL]||Input->KeyPress[KEY_BACKSPACE]){
						Game->PlaySound(SFX_RANDMENUBACKSPACE);
						
						digits[seedDigit] = 0;
						if(seedDigit>0)
							--seedDigit;
					}
					for(int i=KEY_0; i<=KEY_9; ++i){
						if(Input->KeyPress[i]){
							Game->PlaySound(SFX_RANDMENUKEYPRESS);
					
							digits[seedDigit] = i-KEY_0;
							if(seedDigit<5)
								++seedDigit;
							else
								exitSeed = true;
						}
					}
					for(int i=KEY_A; i<=KEY_F; ++i){
						if(Input->KeyPress[i]){
							Game->PlaySound(SFX_RANDMENUKEYPRESS);
					
							digits[seedDigit] = i-KEY_A+10;
							if(seedDigit<5)
								++seedDigit;
							else
								exitSeed = true;
						}
					}
				}
			}
			switch(enabled[1+selection]-1){
				case SSET_SEED:
					if(seedDigit<=-1){
						if(Link->PressA){
							Game->PlaySound(SFX_RANDMENUSELECT);
							seedDigit = 0;
						}
					}
					else{
						if(Link->PressLeft){
							Game->PlaySound(SFX_RANDMENUSELECT);
							--seedDigit;
							if(seedDigit<0)
								seedDigit = 5;
						}
						if(Link->PressRight){
							Game->PlaySound(SFX_RANDMENUSELECT);
							++seedDigit;
							if(seedDigit>5)
								seedDigit = 0;
						}
						if(Link->PressA||Input->KeyPress[KEY_ENTER]){
							Game->PlaySound(SFX_RANDMENUSELECT);
							seedDigit = -1;
						}
						if(Link->PressB){
							Game->PlaySound(SFX_RANDMENUSELECT);
							
							for(int i=0; i<6; ++i){
								digits[i] = Rand(16);
							}
						}
						if(exitSeed)
							seedDigit = -1;
						
						if(seedDigit==-1){
							finalSeed = SeedFromDigits(settings);
						}
					}
					break; 
				case SSET_STARTINGCHAR:
					if(Link->PressLeft){
						Game->PlaySound(SFX_RANDMENUSELECT);
						--settings[selection];
						if(settings[selection]<0)
							settings[selection] = 8;
						GetSeededChars(settings, finalSeed, settings[SSET_STARTINGCHAR], settings[SSET_NUMCHARS]);
					}
					if(Link->PressRight){
						Game->PlaySound(SFX_RANDMENUSELECT);
						++settings[selection];
						if(settings[selection]>8)
							settings[selection] = 0;
						GetSeededChars(settings, finalSeed, settings[SSET_STARTINGCHAR], settings[SSET_NUMCHARS]);
					}
					break;
				case SSET_NUMCHARS:
					if(Link->PressLeft){
						Game->PlaySound(SFX_RANDMENUSELECT);
						--settings[selection];
						if(settings[selection]<3)
							settings[selection] = 6;
						GetSeededChars(settings, finalSeed, settings[SSET_STARTINGCHAR], settings[SSET_NUMCHARS]);
					}
					if(Link->PressRight){
						Game->PlaySound(SFX_RANDMENUSELECT);
						++settings[selection];
						if(settings[selection]>6)
							settings[selection] = 3;
						GetSeededChars(settings, finalSeed, settings[SSET_STARTINGCHAR], settings[SSET_NUMCHARS]);
					}
					break;
				case SSET_BESTIARYRAND:
					if(Link->PressLeft||Link->PressRight){
						Game->PlaySound(SFX_RANDMENUSELECT);
						settings[selection] = (settings[selection]==0)?1:0;
					}
					break;
				case SSET_RANDOMODE:
					if(Link->PressLeft){
						Game->PlaySound(SFX_RANDMENUSELECT);
						--settings[selection];
						if(settings[selection]<0)
							settings[selection] = 1;
					}
					if(Link->PressRight){
						Game->PlaySound(SFX_RANDMENUSELECT);
						++settings[selection];
						if(settings[selection]>1)
							settings[selection] = 0;
					}
					if(settings[SSET_RANDOMODE]==1){
						settings[SSET_OBSERVATORYLOCK] = Clamp(settings[SSET_OBSERVATORYLOCK], 1, 10);
					}
					break;
				case SSET_OBSERVATORYLOCK:
					int min = -1;
					if(settings[SSET_RANDOMODE]==1)
						min = 1;
					int hymnstoneCap = RandomizerLogic::GetHymnstoneMax(true)/10;
					if(Link->PressLeft){
						Game->PlaySound(SFX_RANDMENUSELECT);
						--settings[selection];
						if(settings[selection]<min)
							settings[selection] = hymnstoneCap;
					}
					if(Link->PressRight){
						Game->PlaySound(SFX_RANDMENUSELECT);
						++settings[selection];
						if(settings[selection]>hymnstoneCap)
							settings[selection] = min;
					}
					break;
				case SSET_MULTIPLAYER:
				{
					if(Link->PressLeft){
						Game->PlaySound(SFX_RANDMENUSELECT);
						--settings[selection];
						if(settings[selection]<0)
							settings[selection] = 3;
					}
					if(Link->PressRight){
						Game->PlaySound(SFX_RANDMENUSELECT);
						++settings[selection];
						if(settings[selection]>3)
							settings[selection] = 0;
					}
					break;
				}
				case SSET_CONFIRM:
					if(Link->PressA){
						Game->PlaySound(SFX_RANDMENUCONFIRM);
						confirm = true;
					}
					break;
			}
			
			if(settings[SSET_STARTINGCHAR]==7)
				settings[SSET_NUMCHARS] = 3;
			else if(settings[SSET_STARTINGCHAR]==6)
				settings[SSET_NUMCHARS] = 6;
			
			DrawSillyBackground(guys);
			//Screen->Rectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
			DrawRandomizerMenu(selection, settings, enabled, seedDigit);
			
			G[G_RANDOMIZERMODE] = settings[SSET_RANDOMODE];
			G[G_BESTIARYRANDO] = settings[SSET_BESTIARYRAND];
			
			WaitNoAction();
		}
		
		
		G[G_RANDOMIZERSEED] = finalSeed;
		G[G_RANDOMIZERSTARTINGCHARS] = settings[SSET_STARTINGCHAR];
		G[G_RANDOMIZERNUMCHARS] = settings[SSET_NUMCHARS];
		G[G_RANDOMIZERMODE] = settings[SSET_RANDOMODE];
		G[G_BESTIARYRANDO] = settings[SSET_BESTIARYRAND];
		G[G_RANDOMIZERREQUIREDHYMNSTONES] = 0;
		if(settings[SSET_OBSERVATORYLOCK]>0){
			G[G_RANDOMIZERREQUIREDHYMNSTONES] = settings[SSET_OBSERVATORYLOCK]*10;
		}
		if(settings[SSET_OBSERVATORYLOCK]==-1)
			G[G_RANDOMIZEROBSERVATORYLOCK] = 0; //Always Open
		else if(settings[SSET_OBSERVATORYLOCK]==0)
			G[G_RANDOMIZEROBSERVATORYLOCK] = 1; //Characters
		else
			G[G_RANDOMIZEROBSERVATORYLOCK] = 2; //Hymnstones
		
		for(int i=0; i<32; ++i){
			if(i>8)
				BlackishScreenLayerSix();
			if(i>16)
				BlackishScreenLayerSix();
			if(i>24)
				BlackScreenLayerSix();
			WaitNoAction();
		}
		
		ReadOutfitSaveFile();
		
		G[G_MULTIPLAYERACTIVE] = settings[SSET_MULTIPLAYER];
		if(G[G_MULTIPLAYERACTIVE]){
			G[G_MULTIPLAYERFIRSTCONNECT] = 1;
			genericdata gd = Game->LoadGenericData(Game->GetGenericScript("ZLinkWrite"));
			gd->Running = true;
			BlackScreenLayerSix();
			WaitNoAction();
			BlackScreenLayerSix();
			WaitNoAction();
			G[G_MULTIPLAYERFIRSTCONNECT] = 0;
		}
		
		G[G_RANDOMIZERENABLED] = 1;
		
		GetSeededChars(settings, G[G_RANDOMIZERSEED], G[G_RANDOMIZERSTARTINGCHARS], G[G_RANDOMIZERNUMCHARS]);
		//ReadOutfitSaveFile();
		GenerateOutfitShopItems();
		RandomizerLogic::GenerateSeed(G[G_RANDOMIZERSEED]);
		
		Game->Counter[CR_STORYFLAG] = SFLAG_GAMECLEAR;
		Game->Counter[CR_ASHERSIDEQUEST] = 4;
		Game->Counter[CR_TORRINSIDEQUEST] = 6;
		Game->Counter[CR_HELPERQUEST] = 3;
		Game->Counter[CR_MISCSIDEQUEST] = 8;
		Game->Counter[CR_SMALLSIDEQUESTS1] = 0xFFFF;
		Game->Counter[CR_GOLEMSIDEQUEST] = 4;
		Game->Counter[CR_CULTISTQUEST] = 6;
		Game->Counter[CR_MISTFLAGS] = 0xFFFF;
		Game->Counter[CR_NIGHTMARCHERQUEST] = 7;
		Game->Counter[CR_CHASEQUEST] = -1;
		
		Game->MCounter[CR_BOMBS] = 30;
		Game->MCounter[CR_SOLARBATTERY] = 20;
		Game->MCounter[CR_LUNARBATTERY] = 20;
		Game->MCounter[CR_STELLARBATTERY] = 20;
		Game->Counter[CR_BOMBS] = 30;
		Game->Counter[CR_SOLARBATTERY] = 20;
		Game->Counter[CR_LUNARBATTERY] = 20;
		Game->Counter[CR_STELLARBATTERY] = 20;
		
		for(int i=0; i<LOC_SIZE; ++i){
			if(i!=LOC_MUSHRUSH&&i!=LOC_SILVER)
				LoreTracking[LT_LOCATIONS+i] = 2;
		}
		for(int i=0; i<64; ++i){
			Game->LItems[i] |= LI_COMPASS;
		}
		
		Game->SetScreenState(24, 0x7A, ST_SECRET, true); //Catacombs Kaylani Switch
		Game->SetScreenState(24, 0x7B, ST_SECRET, true); //Catacombs Torrin Switch
		Game->SetScreenState(24, 0x7C, ST_SECRET, true); //Catacombs Torrin Switch
		Game->SetScreenState(46, 0x73, ST_SECRET, true); //Poho Progress Check
		
		Game->SetDMapScreenD(37, 0x24, D_LTTPDOORS, 1); //Jungle temple locked door
		
		Link->Item[I_ABILITY_A_SOREN] = false; FoundItems[I_ABILITY_A_SOREN] = false;
		Link->Item[I_ABILITY_B_SOREN] = false; FoundItems[I_ABILITY_B_SOREN] = false;
		Link->Item[I_ABILITY_A_SIYED] = false; FoundItems[I_ABILITY_A_SIYED] = false;
		Link->Item[I_ABILITY_B_SIYED] = false; FoundItems[I_ABILITY_B_SIYED] = false;
		
		InitGlobals();
		Costumes_Update();
		RandomizerCostumeUpdate();
		
		int startScreen;
		int options[6];
		int numOptions;
		if(G[G_ASHERINSEED]==2){
			options[numOptions] = 0;
			++numOptions;
		}
		if(G[G_TORRININSEED]==2){
			options[numOptions] = 1;
			++numOptions;
		}
		if(G[G_KAYLANIINSEED]==2){
			options[numOptions] = 2;
			++numOptions;
		}
		if(G[G_SORENINSEED]==2){
			options[numOptions] = 3;
			++numOptions;
		}
		if(G[G_TERRYINSEED]==2){
			options[numOptions] = 4;
			++numOptions;
		}
		if(G[G_SIYEDINSEED]==2){
			options[numOptions] = 5;
			++numOptions;
		}
		
		randgen genericrand = Game->LoadRNG();
		genericrand->Own();
		genericrand->SRand(G[G_RANDOMIZERSEED]);
		
		startScreen = options[genericrand->Rand(numOptions-1)];
		int secondaryScreen = genericrand->Rand(1);
		
		Waitframe();
		Game->Time = 0;
		G[G_WINNOHINTCOOLDOWN] = WINNO_COOLDOWN;
		switch(startScreen){
			case 0: 
				if(secondaryScreen)
					Link->Warp(24, 0x05);
				else
					Link->Warp(1, 0x61); 
				break;
			case 1: 
				if(secondaryScreen)
					Link->Warp(2, 0x12);
				else
					Link->Warp(26, 0x26); 
				break;
			case 2: 
				if(secondaryScreen)
					Link->Warp(2, 0x31); 
				else
					Link->Warp(28, 0x02); 
				break;
			case 3: 
				if(secondaryScreen)
					Link->Warp(43, 0x74);
				else 
					Link->Warp(2, 0x14); 
				break;
			case 4: 
				if(secondaryScreen)
					Link->Warp(27, 0x44); 
				else
					Link->Warp(26, 0x26); 
				break;
			case 5: 
				if(secondaryScreen)
					Link->Warp(38, 0x64); 
				else
					Link->Warp(28, 0x21);
				break;
		}
	}
	long SeedFromDigits(int settings){
		int digits = settings[0];
		long finalSeed = 0;
		for(int i=0; i<6; ++i){
			finalSeed |= (digits[i]*1L)<<(4*(5-i));
		}
		GetSeededChars(settings, finalSeed, settings[SSET_STARTINGCHAR], settings[SSET_NUMCHARS]);
		return finalSeed;
	}
	void GetSeededChars(int settings, long finalSeed, int startingChars, int numChars){
		randgen randomizerSeed = Game->LoadRNG();
		randomizerSeed->Own();
		randomizerSeed->SRand(finalSeed);
		
		switch(startingChars){
			case 6:
				RandomizerLogic::PickCharacters(numChars, -3, randomizerSeed); //All 6
				break;
			case 7:
				RandomizerLogic::PickCharacters(numChars, -2, randomizerSeed); //Vanilla Trio
				break;
			case 8:
				RandomizerLogic::PickCharacters(numChars, -1, randomizerSeed); //Random
				break;
			default:
				RandomizerLogic::PickCharacters(numChars, startingChars, randomizerSeed);
				break;
		}
		if(settings[SSET_OBSERVATORYLOCK]>0){
			int hymnstoneCap = RandomizerLogic::GetHymnstoneMax(true);
			settings[SSET_OBSERVATORYLOCK] = Min(hymnstoneCap/10, settings[SSET_OBSERVATORYLOCK]);
		}
		randomizerSeed->Free();
	}
	int NewComboNoDupes(int thisGuy, int guyCombos, int maxCombos, int guyCmb){
		int ret;
		bool dupe;
		bool firstTime = true;
		do{
			dupe = false;
			if(firstTime){
				ret = Rand(maxCombos);
				firstTime = false;
			}
			else{
				++ret;
				ret %= maxCombos;
			}
			for(int i=0; i<12; ++i){
				if(i!=thisGuy&&guyCmb[i]==guyCombos[ret])
					dupe = true;
			}
		}while(dupe)
		return guyCombos[ret];
	}
	void DrawSillyBackground(int guys){
		int guyCmb = guys[0];
		int guyDir = guys[1];
		int guyDrawOrder = guys[2];
		int guyScale = guys[3];
		int guyX = guys[4];
		int guyY = guys[5];
		int guyYSpeed = guys[6];
		int guyCombos = guys[7];
		int maxCombos = SizeOfArray(guyCombos);
		
		--guys[9];
		if(guys[9]<0){
			guys[8] = DirCW(guys[8]);
			if(guys[8]==DIR_DOWN)
				guys[9] = 32;
			else
				guys[9] = 8;
		}
		
		SortLowestToHighestAndReturnOrder(guyScale, SizeOfArray(guyScale), guyDrawOrder);
		
		for(int j=0; j<12; ++j){
			int i = guyDrawOrder[j];
			guyY[i] -= guyYSpeed[i];
			
			Screen->DrawCombo(6, guyX[i]+8-8*guyScale[i], guyY[i]-8+16-16*guyScale[i], guyCmb[i]+guys[8], 1, 2, 6, 16*guyScale[i], 32*guyScale[i], 0, 0, 0, -1, 0, true, 128);
			
			if(guyY[i]<-32){
				guyScale[i] = Choose(0.5, 0.75, 1, 1, 2, 2);
				int safety = 128;
				bool collided;
				do{
					--safety;
					guyX[i] = Rand(-8, 248);
					guyY[i] = 176+Rand(32);
					collided = false;
					for(int k=0; k<12; ++k){
						if(i!=k&&Distance(guyX[i], guyY[i], guyX[k], guyY[k])<48&&guyScale[i]==guyScale[k])
							collided = true;
					}
				}while(collided&&safety>0)
					
				guyYSpeed[i] = 0.8;
				guyCmb[i] = NewComboNoDupes(i, guyCombos, maxCombos, guyCmb);
				if(Rand(1024)==0)
					guyCmb[i] = Choose(33884, 33936);
			}
		}
	}
	int AddEnabled(int enabled, int setting){
		enabled[enabled[0]+1] = setting+1;
		++enabled[0];
	}
	void DrawRandomizerMenu(int selection, int settings, int enabled, int seedDigit){
		Screen->DrawString(6, 128, 8, FONT_SHERWOOD, 0x01, -1, TF_CENTERED, "RANDOMIZER SETTINGS", 128, SHD_OUTLINED8, 0x0F);
	
		int offset = Clamp(selection-3, 0, Max(enabled[0]-7, 0));
		for(int j=0; j<7; ++j){
			int i = offset + j;
			int c = 0xB3;
			if(i==selection)
				c = 0x01;
			int x = 8;
			int y = 32+16*j;
			int x2 = x;
			switch(enabled[1+i]-1){
				case SSET_SEED:
					Screen->DrawString(6, x, y, FONT_RANDMENU, c, -1, TF_NORMAL, "SEED:", 128, SHD_OUTLINED8, 0x0F);
					x2 += Text->StringWidth("SEED:", FONT_RANDMENU)+12;
					int digits = settings[i];
					int str[7] = "000000";
					int strDigit[2] = "0";
					int x3 = x2;
					for(int j=0; j<6; ++j){
						str[j] = digits[j]+'0';
						if(digits[j]>9)
							str[j] = digits[j]-10+'A';
						strDigit[0] = str[seedDigit];
						if(j<seedDigit)
							x3 += Text->CharWidth(str[j], FONT_RANDMENU);
					}
					Screen->DrawString(6, x2, y, FONT_RANDMENU, 0xB3, -1, TF_NORMAL, str, 128, SHD_OUTLINED8, 0x0F);
					if(seedDigit>-1)
						Screen->DrawString(6, x3, y, FONT_RANDMENU, 0x01, -1, TF_NORMAL, strDigit, 128, SHD_OUTLINED8, 0x0F);
					break;
				case SSET_STARTINGCHAR:
					Screen->DrawString(6, x, y, FONT_RANDMENU, c, -1, TF_NORMAL, "STARTING CHAR:", 128, SHD_OUTLINED8, 0x0F);
					x2 += Text->StringWidth("STARTING CHAR:", FONT_RANDMENU)+12;
					switch(settings[i]){
						case 0:
							Screen->DrawString(6, x2, y, FONT_RANDMENU, c, -1, TF_NORMAL, "ASHER", 128, SHD_OUTLINED8, 0x0F);
							break;
						case 1:
							Screen->DrawString(6, x2, y, FONT_RANDMENU, c, -1, TF_NORMAL, "TORRIN", 128, SHD_OUTLINED8, 0x0F);
							break;
						case 2:
							Screen->DrawString(6, x2, y, FONT_RANDMENU, c, -1, TF_NORMAL, "KAYLANI", 128, SHD_OUTLINED8, 0x0F);
							break;
						case 3:
							Screen->DrawString(6, x2, y, FONT_RANDMENU, c, -1, TF_NORMAL, "SOREN", 128, SHD_OUTLINED8, 0x0F);
							break;
						case 4:
							Screen->DrawString(6, x2, y, FONT_RANDMENU, c, -1, TF_NORMAL, "TERRY", 128, SHD_OUTLINED8, 0x0F);
							break;
						case 5:
							Screen->DrawString(6, x2, y, FONT_RANDMENU, c, -1, TF_NORMAL, "SIYED", 128, SHD_OUTLINED8, 0x0F);
							break;
						case 6:
							Screen->DrawString(6, x2, y, FONT_RANDMENU, c, -1, TF_NORMAL, "ALL SIX", 128, SHD_OUTLINED8, 0x0F);
							break;
						case 7:
							Screen->DrawString(6, x2, y, FONT_RANDMENU, c, -1, TF_NORMAL, "VANILLA", 128, SHD_OUTLINED8, 0x0F);
							break;
						case 8:
							Screen->DrawString(6, x2, y, FONT_RANDMENU, c, -1, TF_NORMAL, "RANDOM", 128, SHD_OUTLINED8, 0x0F);
							break;
					}
					break;
				case SSET_NUMCHARS:
					Screen->DrawString(6, x, y, FONT_RANDMENU, c, -1, TF_NORMAL, "NUM CHARS:", 128, SHD_OUTLINED8, 0x0F);
					x2 += Text->StringWidth("NUM CHARS:", FONT_RANDMENU)+12;
					int num[16];
					sprintf(num, "%d", settings[i]);
					Screen->DrawString(6, x2, y, FONT_RANDMENU, c, -1, TF_NORMAL, num, 128, SHD_OUTLINED8, 0x0F);
					break;
				case SSET_BESTIARYRAND:
					Screen->DrawString(6, x, y, FONT_RANDMENU, c, -1, TF_NORMAL, "BESTIARY IN POOL:", 128, SHD_OUTLINED8, 0x0F);
					x2 += Text->StringWidth("BESTIARY IN POOL:", FONT_RANDMENU)+12;
					Screen->DrawString(6, x2, y, FONT_RANDMENU, c, -1, TF_NORMAL, settings[i]?"TRUE":"FALSE", 128, SHD_OUTLINED8, 0x0F);
					break;
				case SSET_RANDOMODE:
					Screen->DrawString(6, x, y, FONT_RANDMENU, c, -1, TF_NORMAL, "MODE:", 128, SHD_OUTLINED8, 0x0F);
					x2 += Text->StringWidth("MODE:", FONT_RANDMENU)+12;
					switch(settings[i]){
						case 0:
							Screen->DrawString(6, x2, y, FONT_RANDMENU, c, -1, TF_NORMAL, "STANDARD", 128, SHD_OUTLINED8, 0x0F);
							break;
						case 1:
							Screen->DrawString(6, x2, y, FONT_RANDMENU, c, -1, TF_NORMAL, "HYMNSTONE HUNT", 128, SHD_OUTLINED8, 0x0F);
							break;
					}
					break;
				case SSET_OBSERVATORYLOCK:
					if(settings[SSET_RANDOMODE]==1){
						Screen->DrawString(6, x, y, FONT_RANDMENU, c, -1, TF_NORMAL, "NUMBER:", 128, SHD_OUTLINED8, 0x0F);
						x2 += Text->StringWidth("NUMBER:", FONT_RANDMENU)+12;
					}
					else{
						Screen->DrawString(6, x, y, FONT_RANDMENU, c, -1, TF_NORMAL, "OBSERVATORY:", 128, SHD_OUTLINED8, 0x0F);
						x2 += Text->StringWidth("OBSERVATORY:", FONT_RANDMENU)+12;
					}
					switch(settings[i]){
						case -1:
							Screen->DrawString(6, x2, y, FONT_RANDMENU, c, -1, TF_NORMAL, "ALWAYS OPEN", 128, SHD_OUTLINED8, 0x0F);
							break;
						case 0:
							Screen->DrawString(6, x2, y, FONT_RANDMENU, c, -1, TF_NORMAL, "ALL CHARACTERS", 128, SHD_OUTLINED8, 0x0F);
							break;
						case 1:
							Screen->DrawString(6, x2, y, FONT_RANDMENU, c, -1, TF_NORMAL, "10 HYMNSTONES", 128, SHD_OUTLINED8, 0x0F);
							break;
						case 2:
							Screen->DrawString(6, x2, y, FONT_RANDMENU, c, -1, TF_NORMAL, "20 HYMNSTONES", 128, SHD_OUTLINED8, 0x0F);
							break;
						case 3:
							Screen->DrawString(6, x2, y, FONT_RANDMENU, c, -1, TF_NORMAL, "30 HYMNSTONES", 128, SHD_OUTLINED8, 0x0F);
							break;
						case 4:
							Screen->DrawString(6, x2, y, FONT_RANDMENU, c, -1, TF_NORMAL, "40 HYMNSTONES", 128, SHD_OUTLINED8, 0x0F);
							break;
						case 5:
							Screen->DrawString(6, x2, y, FONT_RANDMENU, c, -1, TF_NORMAL, "50 HYMNSTONES", 128, SHD_OUTLINED8, 0x0F);
							break;
						case 6:
							Screen->DrawString(6, x2, y, FONT_RANDMENU, c, -1, TF_NORMAL, "60 HYMNSTONES", 128, SHD_OUTLINED8, 0x0F);
							break;
						case 7:
							Screen->DrawString(6, x2, y, FONT_RANDMENU, c, -1, TF_NORMAL, "70 HYMNSTONES", 128, SHD_OUTLINED8, 0x0F);
							break;
						case 8:
							Screen->DrawString(6, x2, y, FONT_RANDMENU, c, -1, TF_NORMAL, "80 HYMNSTONES", 128, SHD_OUTLINED8, 0x0F);
							break;
						case 9:
							Screen->DrawString(6, x2, y, FONT_RANDMENU, c, -1, TF_NORMAL, "90 HYMNSTONES", 128, SHD_OUTLINED8, 0x0F);
							break;
						case 10:
							Screen->DrawString(6, x2, y, FONT_RANDMENU, c, -1, TF_NORMAL, "100 HYMNSTONES", 128, SHD_OUTLINED8, 0x0F);
							break;
					}
					break;
				case SSET_MULTIPLAYER:
					Screen->DrawString(6, x, y, FONT_RANDMENU, c, -1, TF_NORMAL, "MULTIPLAYER:", 128, SHD_OUTLINED8, 0x0F);
					x2 += Text->StringWidth("MULTIPLAYER:", FONT_RANDMENU)+12;
					switch(settings[i]){
						case 1:
							Screen->DrawString(6, x2, y, FONT_RANDMENU, c, -1, TF_NORMAL, "GHOSTS", 128, SHD_OUTLINED8, 0x0F);
							break;
						case 2:
							Screen->DrawString(6, x2, y, FONT_RANDMENU, c, -1, TF_NORMAL, "MULTIWORLD", 128, SHD_OUTLINED8, 0x0F);
							break;
						case 3:
							Screen->DrawString(6, x2, y, FONT_RANDMENU, c, -1, TF_NORMAL, "GEODE HUNT", 128, SHD_OUTLINED8, 0x0F);
							break;
						default:
							Screen->DrawString(6, x2, y, FONT_RANDMENU, c, -1, TF_NORMAL, "NONE", 128, SHD_OUTLINED8, 0x0F);
							break;
					}
					break;
				case SSET_CONFIRM:
					Screen->DrawString(6, x+8, y, FONT_RANDMENU, c, -1, TF_NORMAL, "CONFIRM", 128, SHD_OUTLINED8, 0x0F);
					break;
			}
		}
	}
}

const int D_ITEMSPAWN = 7;

ffc script ItemLocation{
	enum ItemSpawnType{
		PLACEDITEM = 0,
		SPECIALITEM = 1,
		KILLENEMIES = 2,
		SECRETSITEM = 3,
		MULTIITEM = 4
	};
	void run(int position, int itemType, int itemID, int itemType2, int dbit){
		if(position==-1){ //Position -1 = Fixed keys only found in randomizer
			if(!G[G_RANDOMIZERENABLED])
				Quit();
		}
		else{
			if(G[G_RANDOMIZERENABLED]){
				if(RandomizedItems[position]>0){
					itemID = RandomizedItems[position];
					itemID = Randomizer_ProgressiveItem(itemID);
				}
				else
					itemID = 255;
			}
		}
		
		if(itemID==0)
			Quit();
		
		switch(itemType){
			case PLACEDITEM:
				if(Screen->State[ST_ITEM])
					Quit();
				item itm = SpawnRandomizerItem(position, itemID, this->X, this->Y);
				itm->Pickup |= IP_ST_ITEM;
				itm->MoveFlags[ITEMMV_CAN_PITFALL] = false;
				break;
			case SPECIALITEM:
				if(Screen->State[ST_SPECIALITEM])
					Quit();
				itemID = ProcessRandomizerItem(position, itemID);
				int bestiaryID;
				if(itemID>=1000){
					bestiaryID = itemID-1000;
					itemID = I_BESTIARYENTRY;
				}
				Screen->RoomData = itemID;
				while(!Screen->State[ST_SPECIALITEM]){
					if(itemID==I_BESTIARYENTRY){
						G[G_BESTIARYPAGE] = bestiaryID;
					}
					Waitframe();
				}
				// When the special item flag is set, the randomizer considers it collected
				SendMultiworldItem(position);
				break;
			case KILLENEMIES:
				if(Screen->State[ST_ITEM])
					Quit();
				int delayFrames = 64;
				if(Screen->State[ST_BOSSLOCKBLOCK])
					delayFrames = 4;
				for(int i=0; (i<delayFrames&&!EnemiesAlive())||i<4; ++i)
					Waitframe();
				while(EnemiesAlive()){
					Waitframe();
				}
				Game->PlaySound(7);
				item itm = SpawnRandomizerItem(position, itemID, this->X, this->Y);
				itm->Pickup |= IP_ST_ITEM;
				itm->MoveFlags[ITEMMV_CAN_PITFALL] = false;
				break;
			case SECRETSITEM:
				if(Screen->State[ST_ITEM])
					Quit();
				while(!Screen->SecretsTriggered()){
					Waitframe();
				}
				item itm = SpawnRandomizerItem(position, itemID, this->X, this->Y);
				itm->Pickup |= IP_ST_ITEM;
				itm->MoveFlags[ITEMMV_CAN_PITFALL] = false;
				break;
			case MULTIITEM:
				if(Game->GetCurMap()==42&&Game->GetCurScreen()==0x2E&&Screen->ComboD[152]!=9021) //Tel's Pyramid hardcode
					Quit();
				if(Screen->State[ST_ITEM])
					Quit();
				
				bool isFirst;
				bool firstFound;
				for(int i=1; i<=32; ++i){
					ffc f = Screen->LoadFFC(i);
					if(f->Script==this->Script&&f->InitD[1]==MULTIITEM){
						if(f==this){
							if(!firstFound)
								isFirst = true;
						}
						firstFound = true;
						break;
					}
				}
				int spawnID;
				if(isFirst){
					for(int i=1; i<=32; ++i){
						ffc f = Screen->LoadFFC(i);
						if(f->Script==this->Script&&f->InitD[1]==MULTIITEM){
							f->InitD[4] = spawnID;
							++spawnID;
						}
					}
				}
				int db = 1<<this->InitD[4];
				item itm;
				int itemState[1];
				switch(itemType2){
					case KILLENEMIES:
						Waitframes(4);
						if(EnemiesAlive()){
							while(EnemiesAlive()){
								Waitframe();
							}
							Game->PlaySound(7);
						}
						break;
					case SECRETSITEM:
						if(!Screen->State[ST_SECRET]){
							while(!Screen->SecretsTriggered()){
								Waitframe();
							}
						}
						break;
				}
				if(!(Screen->D[D_ITEMSPAWN]&db)&&itemID){
					itm = SpawnRandomizerItem(position, itemID, this->X, this->Y);
					itemState[0] = 1;
					if(itemType2==KILLENEMIES)
						Game->PlaySound(7);
				}
				while(true){
					UpdateMultiItem(this, itemID, itm, db, isFirst);
					Waitframe();
				}
				break;
		}
	}
	bool UpdateMultiItem(ffc this, int id, item itm, int db, bool isFirst){
		if(isFirst){
			int numItems;
			for(int i=1; i<=32; ++i){
				ffc f = Screen->LoadFFC(i);
				if(f->Script==this->Script&&f->InitD[1]==MULTIITEM){
					if(G[G_RANDOMIZERENABLED]||f->InitD[2]>0){
						int fdb = 1<<f->InitD[4];
						if(!(Screen->D[D_ITEMSPAWN]&fdb))
							++numItems;
					}
				}
			}
			if(!itm->isValid()&&id>0){
				Screen->D[D_ITEMSPAWN] |= db;
			}
			if(numItems==0){
				Screen->State[ST_ITEM] = true;
				Quit();
			}
		}
		else{
			if(!itm->isValid()&&id>0){
				Screen->D[D_ITEMSPAWN] |= db;
				Quit();
			}
		}
	}
}

screendata script RandomizerScreenChange{
	void run(){
		if(!G[G_RANDOMIZERENABLED])
			Quit();
		
		//Softlock prevention
		//Warehouse
		if(Game->GetCurMap()==9&&Game->GetCurScreen()==0x22){
			Screen->State[ST_SECRET] = true;
		}
		//Pirate Fort
		if(Game->GetCurMap()==6&&Game->GetCurScreen()==0x38){
			RandomizerCopyScreen(28, 0x1B);
		}
		if(Game->GetCurMap()==6&&Game->GetCurScreen()==0x6D){
			RandomizerCopyScreen(28, 0x3C);
		}
		//Mines
		if(Game->GetCurMap()==20&&Game->GetCurScreen()==0x22){
			RandomizerCopyScreen(28, 0x0C);
		}
		//Manor
		if(Game->GetCurMap()==24&&Game->GetCurScreen()==0x08){
			Screen->State[ST_SECRET] = true;
		}
		//Poho Temple
		if(Game->GetCurMap()==46&&Game->GetCurScreen()==0x51){
			RandomizerCopyScreen(28, 0x2C);
		}
		
		//Screen Changes
		//Church -> Costume Shop
		if(Game->GetCurMap()==2&&Game->GetCurScreen()==0x19){
			RandomizerCopyScreen(2, 0x18);
			Screen->SetTileWarp(0, 0x20, 4, WT_IWARPBLACKOUT);
		}
		//Bestiary rando special locations
		if(G[G_BESTIARYRANDO]){
			if(Game->GetCurMap()==24&&Game->GetCurScreen()==0x1E){
				Screen->TriggerSecrets();
			}
			if(Game->GetCurMap()==2&&Game->GetCurScreen()==0x2A){
				Screen->TriggerSecrets();
			}
		}
			
		//Wahiokala sword trigger
		if(Game->GetCurMap()==12&&Game->GetCurScreen()==0x76){
			if(!G[G_KAYLANIINSEED]&&!G[G_SIYEDINSEED]){
				RandomizerCopyScreen(28, 0x78);
			}
		}
		//Barrel House
		if(Game->GetCurMap()==2&&Game->GetCurScreen()==0x7B){
			if(!G[G_TORRININSEED]&&!G[G_TERRYINSEED]){
				RandomizerCopyScreen(28, 0x68);
			}
		}
		//Shoals Barrels
		if(Game->GetCurMap()==16&&Game->GetCurScreen()==0x35){
			if(!G[G_TORRININSEED]&&!G[G_TERRYINSEED]){
				RandomizerCopyScreen(28, 0x69);
			}
		}
		//Catacombs Barrels
		if(Game->GetCurMap()==24&&Game->GetCurScreen()==0x5C){
			if(!G[G_TORRININSEED]&&!G[G_TERRYINSEED]){
				RandomizerCopyScreen(28, 0x6A);
			}
		}
		//Catacombs Skulls
		if(Game->GetCurMap()==24&&Game->GetCurScreen()==0x5A){
			if(!G[G_KAYLANIINSEED]&&!G[G_SIYEDINSEED]){
				RandomizerCopyScreen(28, 0x7A);
			}
		}
		//Kawaehae Bush
		if(Game->GetCurMap()==12&&Game->GetCurScreen()==0x1D){
			if(!G[G_KAYLANIINSEED]&&!G[G_SIYEDINSEED]){
				RandomizerCopyScreen(28, 0x4B);
			}
		}
		//Siyed puzzle
		if(Game->GetCurMap()==28&&Game->GetCurScreen()==0x6B){
			if(!G[G_KAYLANIINSEED]&&!G[G_TERRYINSEED]&&!G[G_SIYEDINSEED]){
				RandomizerCopyScreen(28, 0x79);
			}
		}
		//Observatory
		if(Game->GetCurMap()==24){
			//1x2 Key screen
			if(Game->GetCurScreen()==0x52){
				if(!G[G_ASHERINSEED]){
					RandomizerCopyScreen(28, 0x08);
				}
			}
			if(Game->GetCurScreen()==0x62){
				if(!G[G_ASHERINSEED]){
					if(!G[G_SORENINSEED]&&!G[G_TERRYINSEED])
						RandomizerCopyScreen(28, 0x28);
					else
						RandomizerCopyScreen(28, 0x18);
				}
			}
			//F1 bomb wall
			if(Game->GetCurScreen()==0x41){
				if(!G[G_ASHERINSEED]&&!G[G_SORENINSEED]&&!G[G_TERRYINSEED]){
					RandomizerCopyScreen(28, 0x09);
				}
			}
			//F2 Starstone room
			if(Game->GetCurScreen()==0x22){
				RandomizerCopyScreen(28, 0x19);
			}
			//F2 turn corner
			if(Game->GetCurScreen()==0x10){
				if(!G[G_ASHERINSEED]){
					if(!G[G_SORENINSEED]&&!G[G_TERRYINSEED])
						RandomizerCopyScreen(28, 0x39);
					else
						RandomizerCopyScreen(28, 0x29);
				}
			}
			//F2 switches
			if(Game->GetCurScreen()==0x20){
				if(!G[G_ASHERINSEED]&&!G[G_SORENINSEED]&&!G[G_TERRYINSEED]){
					RandomizerCopyScreen(28, 0x38);
				}
			}
			//F3 switches
			if(Game->GetCurScreen()==0x20){
				if(!G[G_ASHERINSEED]&&!G[G_SORENINSEED]&&!G[G_TERRYINSEED]){
					RandomizerCopyScreen(28, 0x38);
				}
			}
			//F3 multilevel 3x1
			if(Game->GetCurScreen()==0x63){
				if(!G[G_ASHERINSEED]&&!G[G_SORENINSEED]&&!G[G_TERRYINSEED]){
					RandomizerCopyScreen(28, 0x48);
				}
			}
			if(Game->GetCurScreen()==0x64){
				if(!G[G_ASHERINSEED]){
					RandomizerCopyScreen(28, 0x49);
				}
			}
			if(Game->GetCurScreen()==0x65){
				if(!G[G_ASHERINSEED]){
					RandomizerCopyScreen(28, 0x4A);
				}
			}
			//F3 platform puzzle
			if(Game->GetCurScreen()==0x54){
				if(!G[G_ASHERINSEED]){
					RandomizerCopyScreen(28, 0x58);
				}
			}
			if(Game->GetCurScreen()==0x55){
				if(!G[G_ASHERINSEED]){
					if(!G[G_SORENINSEED]&&!G[G_TERRYINSEED])
						RandomizerCopyScreen(28, 0x5A);
					else
						RandomizerCopyScreen(28, 0x59);
				}
			}
			//F4 pots
			if(Game->GetCurScreen()==0x45){
				if(!G[G_KAYLANIINSEED]&&!G[G_SIYEDINSEED]){
					RandomizerCopyScreen(28, 0x3A);
				}
			}
			//F5 barrels
			if(Game->GetCurScreen()==0x56){
				if(!G[G_ASHERINSEED]){
					if(!G[G_SORENINSEED]&&!G[G_TERRYINSEED])
						RandomizerCopyScreen(28, 0x2B);
					else
						RandomizerCopyScreen(28, 0x2A);
				}
			}
			//F5 fishing rod
			if(Game->GetCurScreen()==0x57){
				if(!G[G_TORRININSEED])
					RandomizerCopyScreen(28, 0x1A);
			}
			//F5 keyroom
			if(Game->GetCurScreen()==0x67){
				if(!G[G_ASHERINSEED])
					RandomizerCopyScreen(28, 0x0A);
			}
			//F5 cannon
			if(Game->GetCurScreen()==0x77){
				if(!G[G_ASHERINSEED]&&!G[G_SORENINSEED]&&!G[G_TERRYINSEED])
					RandomizerCopyScreen(28, 0x3B);
			}
			//F6 puzzle
			if(Game->GetCurScreen()==0x05){
				if(!G[G_ASHERINSEED])
					RandomizerCopyScreen(28, 0x0B);
			}
		}
	}
	void RandomizerCopyScreen(int map, int scrn){
		for(int i=0; i<7; ++i){
			mapdata lyr = Game->LoadTempScreen(i);
			mapdata ref = Game->LoadMapData(map, scrn);
			if(i>0){
				int lmap = ref->LayerMap[i];
				int lscrn = ref->LayerScreen[i];
				if(lmap>0){
					ref = Game->LoadMapData(lmap, lscrn);
				}
				else
					continue;
			}
			for(int i=0; i<176; ++i){
				lyr->ComboD[i] = ref->ComboD[i];
				lyr->ComboC[i] = ref->ComboC[i];
				lyr->ComboF[i] = ref->ComboF[i];
			}
		}
		mapdata ref = Game->LoadMapData(map, scrn);
		for(int i=1; i<=32; ++i){
			ffc f = Screen->LoadFFC(i);
			if(ref->NumFFCs[i]){
				f->EffectWidth = ref->FFCEffectWidth[i];
				f->EffectHeight = ref->FFCEffectHeight[i];
				f->TileWidth = ref->FFCTileWidth[i];
				f->TileHeight = ref->FFCTileHeight[i];
				f->Data = ref->FFCData[i];
				f->CSet = ref->FFCCSet[i];
				f->Delay = ref->FFCDelay[i];
				f->X = ref->FFCX[i];
				f->Y = ref->FFCY[i];
				f->Vx = ref->FFCVx[i];
				f->Vy = ref->FFCVy[i];
				f->Ax = ref->FFCAx[i];
				f->Ay = ref->FFCAy[i];
				for(int j=0; j<14; ++j){
					int bit = 1<<j;
					f->Flags[j] = (ref->FFCFlags[i]&bit);
				}
				f->Script = ref->FFCScript[i];
				for(int j=0; j<8; ++j){
					f->InitD[j] = ref->GetFFCInitD(i, j);
				}
			}
		}
		for(int i=0; i<128; ++i){
			Screen->SecretCombo[i] = ref->SecretCombo[i];
			Screen->SecretCSet[i] = ref->SecretCSet[i];
			Screen->SecretFlags[i] = ref->SecretFlags[i];
		}
		if(Screen->State[ST_SECRET])
			Screen->TriggerSecrets();
	}
}

void Randomizer_InitItemData(){
	int slot = Game->GetItemScript("PickupMessage");
	int slotUpgrade = Game->GetItemScript("PickupMessageUpgrade");
	
	Randomizer_SetItemPickupScript(I_SHIELD2, slot);
	Randomizer_SetItemPickupScript(I_AUGMENT_CANDLE, slot);
	Randomizer_SetItemPickupScript(I_AUGMENT_BOMB, slot);
	Randomizer_SetItemPickupScript(I_AUGMENT_MAGNET, slot);
	Randomizer_SetItemPickupScript(I_AUGMENT_WAND, slot);
	Randomizer_SetItemPickupScript(I_AUGMENT_SPEED, slot);
	
	Randomizer_SetItemPickupScript(I_ASHER, slot);
	Randomizer_SetItemPickupScript(I_SWORD2, slot);
	Randomizer_SetItemPickupScript(I_ABILITY_A_ASHER, slotUpgrade);
	Randomizer_SetItemPickupScript(I_ABILITY_B_ASHER, slot);
	Randomizer_SetItemPickupScript(I_ABILITY_C_ASHER, slot);
	Randomizer_SetItemPickupScript(I_DASHUPGRADE, slot);
	Randomizer_SetItemPickupScript(I_AUGMENT_DASHDIST, slot);
	Randomizer_SetItemPickupScript(I_AUGMENT_DASHCOUNTER, slot);
	Randomizer_SetItemPickupScript(I_AUGMENT_STELLARSWORD, slot);
	Randomizer_SetItemPickupScript(I_AUGMENT_MINIOR, slot);
	Randomizer_SetItemPickupScript(I_AUGMENT_REFLECT, slot);
	
	Randomizer_SetItemPickupScript(I_TORRIN, slot);
	Randomizer_SetItemPickupScript(I_SWORD_TORRIN2, slot);
	Randomizer_SetItemPickupScript(I_ABILITY_A_TORRIN, slot);
	Randomizer_SetItemPickupScript(I_ABILITY_B_TORRIN, slot);
	Randomizer_SetItemPickupScript(I_ABILITY_C_TORRIN, slot);
	Randomizer_SetItemPickupScript(I_AUGMENT_THROWPUNCH, slot);
	Randomizer_SetItemPickupScript(I_AUGMENT_AUTOLOCK, slot);
	Randomizer_SetItemPickupScript(I_AUGMENT_ALTBATTERYSOLAR, slot);
	Randomizer_SetItemPickupScript(I_AUGMENT_ALTBATTERYLUNAR, slot);
	Randomizer_SetItemPickupScript(I_AUGMENT_ALTBATTERYSTELLAR, slot);
	
	Randomizer_SetItemPickupScript(I_KAYLANI, slot);
	Randomizer_SetItemPickupScript(I_SWORD_KAYLANI2, slot);
	Randomizer_SetItemPickupScript(I_ABILITY_A_KAYLANI, slot);
	Randomizer_SetItemPickupScript(I_ABILITY_B_KAYLANI, slot);
	Randomizer_SetItemPickupScript(I_ABILITY_C_KAYLANI, slot);
	Randomizer_SetItemPickupScript(I_AUGMENT_RANGE, slot);
	Randomizer_SetItemPickupScript(I_AUGMENT_CHARGE, slot);
	Randomizer_SetItemPickupScript(I_AUGMENT_SPARK, slot);
	Randomizer_SetItemPickupScript(I_AUGMENT_MIRAGE, slot);
	Randomizer_SetItemPickupScript(I_AUGMENT_LASER, slot);
	
	Randomizer_SetItemPickupScript(I_SOREN, slot);
	Randomizer_SetItemPickupScript(I_SWORD_SOREN2, slot);
	Randomizer_SetItemPickupScript(I_ABILITY_A_SOREN, slot);
	Randomizer_SetItemPickupScript(I_ABILITY_B_SOREN, slot);
	Randomizer_SetItemPickupScript(I_ABILITY_C_SOREN, slot);
	Randomizer_SetItemPickupScript(I_AUGMENT_FLASHCHARGE, slot);
	Randomizer_SetItemPickupScript(I_AUGMENT_LINGERINGFLAME, slot);
	Randomizer_SetItemPickupScript(I_AUGMENT_SPARKINGDASH, slot);
	Randomizer_SetItemPickupScript(I_AUGMENT_RESPONSIBLERICOCHET, slot);
	Randomizer_SetItemPickupScript(I_AUGMENT_CRITICALGRAPPLE, slot);
	
	Randomizer_SetItemPickupScript(I_TERRY, slot);
	Randomizer_SetItemPickupScript(I_SWORD_TERRY2, slot);
	Randomizer_SetItemPickupScript(I_ABILITY_A_TERRY, slot);
	Randomizer_SetItemPickupScript(I_ABILITY_B_TERRY, slot);
	Randomizer_SetItemPickupScript(I_ABILITY_C_TERRY, slot);
	Randomizer_SetItemPickupScript(I_AUGMENT_HADOUKEN, slot);
	Randomizer_SetItemPickupScript(I_AUGMENT_DIREDROPS, slot);
	Randomizer_SetItemPickupScript(I_AUGMENT_ALTBATTERYSOLARTERRY, slot);
	Randomizer_SetItemPickupScript(I_AUGMENT_ALTBATTERYLUNARTERRY, slot);
	Randomizer_SetItemPickupScript(I_AUGMENT_ALTBATTERYSTELLARTERRY, slot);
	
	Randomizer_SetItemPickupScript(I_SIYED, slot);
	Randomizer_SetItemPickupScript(I_SWORD_SIYED2, slot);
	Randomizer_SetItemPickupScript(I_ABILITY_A_SIYED, slot);
	Randomizer_SetItemPickupScript(I_ABILITY_B_SIYED, slot);
	Randomizer_SetItemPickupScript(I_ABILITY_C_SIYED, slot);
	Randomizer_SetItemPickupScript(I_AUGMENT_RANGESIYED, slot);
	Randomizer_SetItemPickupScript(I_AUGMENT_DIAGONALHEAT, slot);
	Randomizer_SetItemPickupScript(I_AUGMENT_UPDRAFT, slot);
	Randomizer_SetItemPickupScript(I_AUGMENT_CONCENTRATION, slot);
	Randomizer_SetItemPickupScript(I_AUGMENT_UNSTABLEORBIT, slot);
	
	Randomizer_SetItemPickupScript(I_LEVELKEY, slot);
	Randomizer_SetItemPickupScript(I_BOSSKEY, slot);
}

void Randomizer_SetItemPickupScript(int itemid, int slot){
	itemdata id = Game->LoadItemData(itemid);
	id->PScript = slot;
}

void Randomizer_InitMinimapData(){
	Randomizer_AddMinimapItem(9, 5); //Warehouse
	Randomizer_AddMinimapItem(24, 5); //Manor
	Randomizer_AddMinimapItem(24, 52, 56436, 8); //Manor coins
	Randomizer_AddMinimapItem(25, 114); //Catacombs L
	Randomizer_AddMinimapItem(25, 116); //Catacombs R
	Randomizer_AddMinimapItem(55, 106); //Poho 1
	Randomizer_AddMinimapItem(55, 41); //Poho 2
	Randomizer_AddMinimapItem(55, 44); //Poho 3
	Randomizer_AddMinimapItem(30, 1); //Kawaehae
	Randomizer_AddMinimapItem(36, 49); //Jungle plant
	Randomizer_AddMinimapItem(27, 70); //Kikala
	Randomizer_AddMinimapItem(44, 86); //Villa
	Randomizer_AddMinimapItem(12, 75); //Truf rock
	Randomizer_AddMinimapItem(37, 20); //Jungle Temple
	Randomizer_AddMinimapItem(65, 38); //Tel's Pyramid
	
	Randomizer_AddMinimapItem(33, 65); //Leipai money
	Randomizer_AddMinimapItem(61, 51); //Three brothers money
	Randomizer_AddMinimapItem(61, 33); //Three brothers money (secret)
	Randomizer_AddMinimapItem(63, 0); //Waypoint money 1
	Randomizer_AddMinimapItem(63, 1); //Waypoint money 2
	Randomizer_AddMinimapItem(46, 120); //Mirage money
	Randomizer_AddMinimapItem(45, 47, 56428, 7); //Mirage money (outside)
	Randomizer_AddMinimapItem(36, 65); //Jungle money
	Randomizer_AddMinimapItem(13, 1); //Temple grounds cave money
	Randomizer_AddMinimapItem(36, 18, 56428, 7); //Temple grounds cave money (outside)

	Randomizer_AddMinimapItem(2, 65); //Zarath's life lesson
	
	if(G[G_BESTIARYRANDO])
		ScreenCopy(31, 0x18, 31, 0x86);
}

void Randomizer_AddMinimapItem(int dmap, int scrn, int cmb, int cset){
	Game->SetComboData(32, dmap, scrn, cmb);
	if(cset>0)
		Game->SetComboCSet(32, dmap, scrn, cset);
}
void Randomizer_AddMinimapItem(int dmap, int scrn){
	Randomizer_AddMinimapItem(dmap, scrn, 56416, 7);
}

int Randomizer_ProgressiveItem(int id){
	switch(id){
		case I_ABILITY_A_ASHER:
			if(FoundItems[I_ABILITY_A_ASHER])
				return I_STARSTONE;
			break;
	}
	return id;
}

//Item Locations
enum ItemLocations{
	//Puna
	IL_PUNA_DIVE = 0,
	
	//Omaka
	IL_OMAKA_BURN = 1,
	IL_OMAKA_CLIFF = 2,
	IL_OMAKA_TREE = 3,
	IL_OMAKA_ISLAND = 4,
	IL_OMAKA_THROUGHCAVE = 5,
	IL_OMAKA_ILLUSORYTREE = 6,
	IL_OMAKA_MANORSLOPE = 7,
	
	//Totem 1
	IL_TOTEM1_ASHERHEART1 = 8,
	IL_TOTEM1_TORRINHEART1 = 9,
	IL_TOTEM1_KAYLANIHEART1 = 10,
	IL_TOTEM1_ASHERDASH = 11,
	IL_TOTEM1_SOLARSYSTEM = 12,
	
	//Pala
	IL_PALA_CHAPPINGTON = 13,
	IL_PALA_CONSTRUCTION = 14,
	IL_PALA_SORENHOUSE = 15,
	IL_PALA_BOXES = 16,
	IL_PALA_BARRELHOUSE = 17,
	IL_PALA_DIVE = 18,
	
	//Warehouse
	IL_WAREHOUSE_BIGROOM = 19,
	IL_WAREHOUSE_CANDLE = 20,
	IL_WAREHOUSE_UNDERARCH = 21,
	IL_WAREHOUSE_BOMBWALL = 22,
	
	//Pala Shops
	IL_SHOP1_SILVERSWORD = 23,
	IL_SHOP1_IRONSHIELD = 24,
	IL_SHOP1_STONETRAP = 25,
	IL_SHOP2_AUGCANDLE = 26,
	IL_SHOP2_AUGBOMBS = 27,
	IL_SHOP2_AUGGAUNTLET = 28,
	
	//Selet Manor
	IL_SELET_STARWAND = 29,
	IL_SELET_KILLROOM = 30,
	IL_SELET_DININGROOM = 31,
	IL_SELET_TIMINGPUZZLE = 32,
	
	//Catacombs
	IL_CATACOMBS_STARBLOCKPUZZLE = 33,
	IL_CATACOMBS_DIVESPOT = 34,
	IL_CATACOMBS_LUNARTRIGGER = 35,
	
	//Kikala Hill
	IL_KIKALA_BEHINDTREE = 36,
	IL_KIKALA_SOLARGOLEM = 37,
	IL_KIKALA_MAGNETISLAND = 38,
	IL_KIKALA_STARBLOCK = 39,
	
	//Kawaehae
	IL_KAWAEHAE_DIVE = 40,
	IL_KAWAEHAE_BUSH = 41,
	IL_KAWAEHAE_STARBLOCK = 42,
	IL_KAWAEHAE_STELLARGOLEM = 43,
	
	//Kawi
	IL_KAWI_BURNCACTUS = 44,
	IL_KAWI_BOMBCLIFF = 45,
	IL_KAWI_DIVE = 46,
	IL_KAWI_BOMBCAVE = 47,
	IL_KAWI_BOMBDUNE = 48,
	IL_KAWI_ISLAND = 49,
	IL_KAWI_BEHINDTREE = 147, //Moosh forgot
	
	//Totem 2
	IL_TOTEM2_ASHERHEART2 = 50,
	IL_TOTEM2_TORRINHEART2 = 51,
	IL_TOTEM2_KAYLANIHEART2 = 52,
	IL_TOTEM2_BLACKBELT = 53,
	IL_TOTEM2_SUNDOG = 54,
	
	//Pirate Fort
	IL_PIRATE_BOMBS = 55,
	IL_PIRATE_SWITCHKILLROOM = 56,
	IL_PIRATE_BOMBPUZZLE = 57,
	IL_PIRATE_GAUNTLETPUZZLE = 58,
	
	//Malka
	IL_MALKA_UNDERHOUSE = 59,
	IL_MALKA_TAROFIELD = 60,
	
	//Malka Shop
	IL_SHOP3_AUGAUTOLOCK = 61,
	IL_SHOP3_AUGREFLECT = 62,
	IL_SHOP3_AUGALTLUNAR = 63,
	
	//Shoals
	IL_SHOALS_BURNBUSH = 64,
	IL_SHOALS_DARKCAVE = 65,
	IL_SHOALS_BARRELCAVE = 66,
	IL_SHOALS_MAGNETBUSH = 67,
	IL_SHOALS_CUTSCENESCREEN = 68,
	
	//Totem 3
	IL_TOTEM3_ASHERAUGMENTSLOT1 = 69,
	IL_TOTEM3_TORRINAUGMENTSLOT1 = 70,
	IL_TOTEM3_KAYLANIAUGMENTSLOT1 = 71,
	IL_TOTEM3_DASHCOUNTER = 72,
	IL_TOTEM3_SOLARMIGHT = 73,
	
	//Mines
	IL_MINES_BEETLEGEM = 74,
	IL_MINES_GAUNTLET = 75,
	IL_MINES_GAUNTLETSPIKES = 76,
	IL_MINES_TIMERPUZZLE = 77,
	IL_MINES_GEMHOLE = 78,
	IL_MINES_BEETLEPIT = 79,
	
	//Wahiokala
	IL_WAHI_LUNARTRIGGER = 80,
	IL_WAHI_BURNTREE = 81,
	IL_WAHI_CLOUDTRIGGER = 82,
	IL_WAHI_BUSH = 83,
	IL_WAHI_FOOTHILLSLAVACAVE = 84,
	IL_WAHI_BURNSHRUB = 85,
	IL_WAHI_BEHINDTREE = 86,
	IL_WAHI_VALLEYKILLROOM = 87,
	IL_WAHI_LUNARGOLEM = 88,
	IL_WAHI_HOKUCAVE = 89,
	IL_WAHI_MONEYCAVE = 90,
	
	IL_SHOP4_AUGSTELLARWAND = 91,
	IL_SHOP4_AUGSTELLARSWORD = 92,
	IL_SHOP4_AUGSAFECHARGE = 93,
	
	//Jungle Cave
	IL_JUNGLECAVE_BOMBROCK = 94,
	
	//Jungle Temple
	IL_JUNGLETEMPLE_SOLARPILLAR = 95,
	
	//Totem 4
	IL_TOTEM4_ASHERHEART3 = 96,
	IL_TOTEM4_TORRINHEART3 = 97,
	IL_TOTEM4_KAYLANIHEART3 = 98,
	IL_TOTEM4_STELLAIRE = 99,
	IL_TOTEM4_SOLARFLARE = 100,
	
	//Mauna Ali'i
	IL_ALII_ENTRANCEBOMBWALL = 101, 
	IL_ALII_ENTRNACESPIKEBARRIER = 102,
	IL_ALII_BEHINDTREE = 103,
	IL_ALII_DIVECAVE = 104,
	IL_ALII_DROPINCAVE = 105,
	IL_ALII_STELLARPILLAR = 106,
	
	//Observatory
	IL_OBSERVATORY_ENTRANCE = 107,
	IL_OBSERVATORY_STARSTONE = 190,
	IL_OBSERVATORY_SWITCHROOM  = 108,
	IL_OBSERVATORY_UNDERREDORB = 109,
	IL_OBSERVATORY_COINPOT = 110,
	IL_OBSERVATORY_ORBBOMBWALL = 111,
	IL_OBSERVATORY_CUBBYHOLE = 112,
	IL_OBSERVATORY_STARWANDPUZZLE = 113,
	
	//Kohi Canyon
	IL_KOHI_OVERHANG = 114,
	IL_KOHI_DIVE = 115,
	IL_KOHI_CAVE = 116,
	IL_KOHI_RUINS = 117,
	IL_KOHI_STARWANDPUZZLE = 118,
	IL_KOHI_RAVINE = 119,
	IL_KOHI_LAKE = 120,
	
	//Poho Temple
	IL_POHO_LUNARANG = 121,
	IL_POHO_MISTPOT = 122,
	IL_POHO_BOMBWALLSWITCH = 123,
	IL_POHO_ELEMENTPUZZLE = 124,
	
	//Villa Tulane
	IL_TULANE_SIDEPATH = 125,
	IL_TULANE_CAVE = 126,
	IL_TULANE_WATERSIDE = 127,
	
	//Leipai's Lookout
	IL_LEIPAI_BEHINDTREE = 128,
	IL_LEIPAI_BRIDGE = 129,
	IL_LEIPAI_COINS = 130,
	
	//Kukulu Cliffs
	IL_KUKULU_KILLROOM = 131,
	IL_KUKULU_SWITCHPUZZLE = 132,
	
	//Carn Ruins
	IL_CARN_BOMBROCK = 133,
	IL_CARN_BOMBGEMPUZZLE = 134,
	IL_CARN_BOMBWALL = 135,
	IL_CARN_BLOCKGEMPUZZLE = 136,
	IL_CARN_FUSIONGOLEM = 137,
	
	//Pirate Fort 2
	IL_PIRATE2_COINCHEST = 138,
	
	//Undersea Pyramid
	IL_TOTEM5_ASHERAUGMENTSLOT2 = 139,
	IL_TOTEM5_TORRINAUGMENTSLOT2 = 140,
	IL_TOTEM5_KAYLANIAUGMENTSLOT2 = 141,
	
	//Misc
	IL_TOMBOL = 142,
	IL_THREEBROTHERS = 143,
	IL_THREEBROTHERSCOINS = 188,
	IL_WAYPOINT = 144,
	IL_WAYPOINTSECRET = 145,
	IL_MIRAGE = 146,
	
	//Special randomizer items for bosses and quest locations
	IL_SP_WAREHOUSE1 = 148,
	IL_SP_WAREHOUSE2 = 149,
	IL_SP_PIRATE1 = 150,
	IL_SP_PIRATE2 = 151,
	IL_SP_MINES1 = 152,
	IL_SP_MINES2 = 153,
	IL_SP_MINES3 = 154,
	IL_SP_MANOR = 155,
	IL_SP_CATACOMBS1 = 156,
	IL_SP_CATACOMBS2 = 157,
	IL_SP_POHO1 = 158,
	IL_SP_POHO2 = 159,
	IL_SP_POHO3 = 160,
	IL_SP_POHO4 = 161,
	IL_SP_POHOBOSS1 = 162,
	IL_SP_POHOBOSS2 = 163,
	IL_SP_KAWAEHAE1 = 164,
	IL_SP_KAWAEHAE2 = 165,
	IL_SP_JUNGLEPLANT1 = 166,
	IL_SP_JUNGLEPLANT2 = 167,
	IL_SP_KIKALA1 = 168,
	IL_SP_KIKALA2 = 169,
	IL_SP_TULANE1 = 170,
	IL_SP_TULANE2 = 171,
	IL_SP_SOLARGOLEM = 172,
	IL_SP_LUNARGOLEM = 173,
	IL_SP_STELLARGOLEM = 174,
	IL_SP_FUSIONGOLEM1 = 175,
	IL_SP_FUSIONGOLEM2 = 176,
	IL_SP_FUSIONGOLEM3 = 177,
	IL_SP_PIRATEREMATCH1 = 178,
	IL_SP_PIRATEREMATCH2 = 179,
	IL_SP_NECKLACEROCK1 = 180,
	IL_SP_NECKLACEROCK2 = 181,
	IL_SP_JUNGLETEMPLE1 = 182,
	IL_SP_JUNGLETEMPLE2 = 183,
	IL_SP_TELSPYRAMID1 = 184,
	IL_SP_TELSPYRAMID2 = 185,
	IL_SP_UNDERSEAPYRAMID1 = 186,
	IL_SP_UNDERSEAPYRAMID2 = 187,
	
	IL_ZARATHLIFELESSON = 189,
	
	IL_NIGHTMARESELET1 = 191,
	IL_NIGHTMARESELET2 = 192,
	IL_NIGHTMARESELET3 = 193,
	IL_NIGHTMARESELET4 = 194,
	
	IL_BES_REDOCTO = 195,
	IL_BES_BLUEOCTO,
	IL_BES_CRAB,
	IL_BES_ARMOREDCRAB,
	IL_BES_EMBEDDECRAB,
	IL_BES_REDRATANG,
	IL_BES_BLUERATANG,
	IL_BES_PALERATANG,
	IL_BES_LUNATICRATANG,
	IL_BES_BAT,
	IL_BES_MADBAT,
	IL_BES_SPIDER,
	IL_BES_BLOATEDSPIDER,
	IL_BES_RAT,
	IL_BES_SNAKE,
	IL_BES_JUNGLESNAKE,
	IL_BES_SKULLPENT,
	IL_BES_OSSIFIEDSERPENT,
	IL_BES_SEASTRIDER,
	IL_BES_CLIFFSTRIDER,
	IL_BES_SUNSTRIDER,
	IL_BES_DIMLIT,
	IL_BES_FLAMINGDIMLIT,
	IL_BES_SPINEPUFFER,
	IL_BES_FIREPUFFER,
	IL_BES_STARPUFFER,
	IL_BES_REDHOPMAW,
	IL_BES_BLUEHOPMAW,
	IL_BES_BEEHIVE,
	IL_BES_SAWTOOTH,
	IL_BES_ZOLO,
	IL_BES_DROPLET,
	IL_BES_DRIPLET,
	IL_BES_SPINYBEETLE,
	IL_BES_SOLARCURSTELLATION,
	IL_BES_LUNARCURSTELLATION,
	IL_BES_STELLARCURSTELLATION,
	IL_BES_BOOMBA,
	IL_BES_PLATEDBOOMBA,
	IL_BES_QUADCANNON,
	IL_BES_MUMMY,
	IL_BES_BLOODMUMMY,
	IL_BES_STONEGUARDIAN,
	IL_BES_STONEHELMET,
	IL_BES_GHOST,
	IL_BES_COSMICSPOOK,
	IL_BES_NIGHTMARCHER,
	IL_BES_SUNEATER,
	IL_BES_MOONEATER,
	IL_BES_STAREATER,
	IL_BES_SOLARWIZARD,
	IL_BES_LUNARWIZARD,
	IL_BES_STELLARWIZARD,
	IL_BES_SOLARCRABLIKE,
	IL_BES_LUNARCRABLIKE,
	IL_BES_STELLARCRABLIKE,
	IL_BES_SOLARSTARTOUCHED,
	IL_BES_LUNARSTARTOUCHED,
	IL_BES_STELLARSTARTOUCHED,
	IL_BES_SOLARPILLAR,
	IL_BES_LUNARPILLAR,
	IL_BES_STELLARPILLAR,
	IL_BES_BLADEPIRATE,
	IL_BES_PISTOLPIRATE,
	IL_BES_BATTERYPIRATE,
	IL_BES_ELITEPIRATE,
	IL_BES_SOLARMASK,
	IL_BES_LUNARMASK,
	IL_BES_STELLARMASK,
	IL_BES_SOLARSPELLBEARER,
	IL_BES_LUNARSPELLBEARER,
	IL_BES_STELLARSPELLBEARER,
	IL_BES_SOLARGOLEM,
	IL_BES_LUNARGOLEM,
	IL_BES_STELLARGOLEM,
	IL_BES_FUSIONGOLEM,
	IL_BES_CAPTAINSHELROND,
	IL_BES_BOLIDEBORER2000,
	IL_BES_ESAN,
	IL_BES_SELET,
	IL_BES_NIGHTMARESELET = 275,
	
	IL_THREEBROTHERSCOINSSECRET = 276,
	IL_SELET_COINS = 277,
	
	IL_COUNT
};

//Item Trigger Flags
enum ItemTriggerFlags{
	RFLAG_SPECIAL           = -1,
	RFLAG_INACCESSIBLE 		= 0000000000000001b,
	RFLAG_FIRE  			= 0000000000000010b,
	RFLAG_SOLAR             = 0000000000000100b,
	RFLAG_LUNAR             = 0000000000001000b,
	RFLAG_BOMB              = 0000000000010000b,
	RFLAG_TIDALGAUNTLET     = 0000000000100000b,
	RFLAG_STELLARWAND       = 0000000001000000b,
	RFLAG_LUNARANG          = 0000000010000000b,
	RFLAG_STARSTONE         = 0000000100000000b,
	RFLAG_TELEKINESIS       = 0000001000000000b,
	RFLAG_BOMBPUZZLE        = 0000010000000000b,
	RFLAG_KAYLANI           = 0000100000000000b,
	RFLAG_FINALDUNGEON      = 0001000000000000b
};

int RandomizedItems[65536];

const int RI_FLAGS = 1024;
const int RI_ITEMFLAGS = 2048;

namespace RandomizerLogic{

	enum RandDatIndex{
		NUM_ROOMS,
		ARR_ROOMLIST, //List of all room IDs
		ARR_ROOMFLAGS, //Flags for the above room IDs
		NUM_ACCESSIBLEROOMS,
		ARR_ACCESSIBLEROOMS, //Just the rooms currently accessible
		NUM_ITEMS,
		ARR_ITEMLIST, //List of all item IDs
		ARR_ITEMFLAGS, //Flags gainted for picking up items
		NUM_TRIGGERITEMS,
		ARR_TRIGGERITEMLIST, //List of all trigger items
		NUM_SPECIALITEMS,
		ARR_SPECIALITEMLIST, //List of all special items
		NUM_TRASHITEMS,
		ARR_TRASHITEMLIST, //List of all trash items
		FLAGS_OBTAINED, 
		NUM_PLACEDITEMS,
		RAND_RANDOMIZERSEED,
		IDX_LOCORDER,
		ARR_LOCATIONORDER, //Records the order items were placed (for the spoiler log)
		ARR_ITEMPLACED, //Records how many of each item ID have been placed so far
		MAX_SPECIALITEMS
	};
	
	enum ItemType{
		IT_TRIGGER,
		IT_SPECIAL,
		IT_TRASH
	};

	bool GenerateSeed(long seedVal){
		long ogSeedVal = seedVal;
		while(true){
			if(TryGenerateSeed(seedVal, ogSeedVal))
				break;
			seedVal += 1L;
			if(seedVal>=16777216L)
				seedVal = 0;
			WaitNoAction();
		}
	}

	bool TryGenerateSeed(long seedVal, long ogSeedVal){
		ClearTrace();
		untyped dat[32];
		
		int roomList[512];
		long roomFlags[512];
		int accessibleRooms[512];
		int itemList[512];
		long itemFlags[512];
		int triggerItems[512];
		int specialItems[512];
		int trashItems[512];
		bool placedItems[512];
		int locationOrder[512];
		int itemPlaced[1512];
		
		for(int i=0; i<512; ++i) roomList[i] = -1;
		for(int i=0; i<1024; ++i) RandomizedItems[i] = 0;
		
		randgen randomizerSeed = Game->LoadRNG();
		randomizerSeed->Own();
		randomizerSeed->SRand(seedVal);
		
		dat[NUM_ROOMS] = 0;
		dat[ARR_ROOMLIST] = roomList;
		dat[ARR_ROOMFLAGS] = roomFlags;
		dat[NUM_ACCESSIBLEROOMS] = 0;
		dat[ARR_ACCESSIBLEROOMS] = accessibleRooms;
		dat[NUM_ITEMS] = 0;
		dat[ARR_ITEMLIST] = itemList;
		dat[ARR_ITEMFLAGS] = itemFlags;
		dat[NUM_TRIGGERITEMS] = 0;
		dat[ARR_TRIGGERITEMLIST] = triggerItems;
		dat[NUM_SPECIALITEMS] = 0;
		dat[ARR_SPECIALITEMLIST] = specialItems;
		dat[NUM_TRASHITEMS] = 0;
		dat[ARR_TRASHITEMLIST] = trashItems;
		dat[FLAGS_OBTAINED] = 0;
		dat[RAND_RANDOMIZERSEED] = randomizerSeed;
		dat[IDX_LOCORDER] = 0;
		dat[ARR_LOCATIONORDER] = locationOrder;
		dat[ARR_ITEMPLACED] = itemPlaced;
		
		if(G[G_ASHERINSEED]==2)
			++itemPlaced[I_ASHER];
		if(G[G_TORRININSEED]==2)
			++itemPlaced[I_TORRIN];
		if(G[G_KAYLANIINSEED]==2)
			++itemPlaced[I_KAYLANI];
		if(G[G_SORENINSEED]==2)
			++itemPlaced[I_SOREN];
		if(G[G_TERRYINSEED]==2)
			++itemPlaced[I_TERRY];
		if(G[G_SIYEDINSEED]==2)
			++itemPlaced[I_SIYED];
		
		if(G[G_RANDOMIZERMODE]==0){
			if(G[G_RANDOMIZEROBSERVATORYLOCK]==0)
				GiveFlag(dat, RFLAG_FINALDUNGEON);
		}
		else if(G[G_RANDOMIZERMODE]==1)
			GiveFlag(dat, RFLAG_FINALDUNGEON);
		
		AddRooms(dat);
		int hymnstoneCap = GetHymnstoneMax(false);
		G[G_RANDOMIZERMAXHYMNSTONES] = hymnstoneCap;
		AddItems(dat, hymnstoneCap);
		
		printf("Attempting Seed %d\n\nNum Rooms: %d\nNum Items: %d\n\n", seedVal, dat[NUM_ROOMS], dat[NUM_ITEMS]);
		if(dat[NUM_ITEMS]!=dat[NUM_ROOMS]){
			printf("ERROR: Item and room counts mismatch!\n");
			return false;
		}
		
		ScrambleItemPools(dat);
		FindAccessibleRooms(dat);
		
		int majorItemCycle[] = {IT_TRIGGER, IT_SPECIAL, IT_SPECIAL, IT_TRASH, IT_TRASH, IT_TRASH};
		const int ITEMCYCLE_LENGTH = 6;
		int cyclePos;
		
		int totemLocs[] = {IL_TOTEM1_ASHERDASH, IL_TOTEM1_SOLARSYSTEM, IL_TOTEM1_ASHERHEART1, IL_TOTEM1_TORRINHEART1, IL_TOTEM1_KAYLANIHEART1,
							IL_TOTEM2_BLACKBELT, IL_TOTEM2_SUNDOG, IL_TOTEM2_ASHERHEART2, IL_TOTEM2_TORRINHEART2, IL_TOTEM2_KAYLANIHEART2,
							IL_TOTEM3_DASHCOUNTER, IL_TOTEM3_SOLARMIGHT, IL_TOTEM3_ASHERAUGMENTSLOT1, IL_TOTEM3_TORRINAUGMENTSLOT1, IL_TOTEM3_KAYLANIAUGMENTSLOT1,
							IL_TOTEM4_SOLARFLARE, IL_TOTEM4_STELLAIRE, IL_TOTEM4_ASHERHEART3, IL_TOTEM4_TORRINHEART3, IL_TOTEM4_KAYLANIHEART3};
		for(int i=0; i<20; ++i){
			int giveItem;
			if(randomizerSeed->Rand(0,7) == 0)
				giveItem = GetRandoItemFromPool(dat, IT_TRIGGER);
			else
				giveItem = GetRandoItemFromPool(dat, IT_SPECIAL);
			if(!PlaceItem(dat, giveItem, -1, totemLocs[i])){
				printf("ERROR: Could not place item. Trying with next valid seed.\n");
				return false;
			}
		}
		
		dat[MAX_SPECIALITEMS] = dat[NUM_SPECIALITEMS];
		
		while(dat[NUM_PLACEDITEMS]<dat[NUM_ITEMS]){
			int giveItem = GetRandoItemFromPool(dat, majorItemCycle[cyclePos]);		
			
			if(!PlaceItem(dat, giveItem)){
				printf("ERROR: Could not place item. Trying with next valid seed.\n");
				return false;
			}
			
			if(RANDOMIZER_DEBUG)
				printf("RFLAGS: %X\n", dat[FLAGS_OBTAINED]);
			if(dat[NUM_PLACEDITEMS]<dat[NUM_ITEMS]){
				bool poolExhausted;
				do{
					poolExhausted = false;
					++cyclePos;
					if(cyclePos>=ITEMCYCLE_LENGTH*2){
						printf("Ran out of items in pools...somehow. Trying with next valid seed.\n");
						return false;
					}
					switch(majorItemCycle[cyclePos%ITEMCYCLE_LENGTH]){
						case IT_TRIGGER:
							poolExhausted = dat[NUM_TRIGGERITEMS]<=0;
							break;
						case IT_SPECIAL:
							poolExhausted = dat[NUM_SPECIALITEMS]<=0;
							//Don't place the second half of the special items until the trash pool is empty. This should make 100 hymnstone observatory possible
							if(dat[NUM_SPECIALITEMS]<=dat[MAX_SPECIALITEMS]*0.5&&dat[NUM_TRASHITEMS]>0)
								poolExhausted = true;
							break;
						case IT_TRASH:
							poolExhausted = dat[NUM_TRASHITEMS]<=0;
							break;
					}
				}while(poolExhausted)
				cyclePos %= 6;
			}
		}
		
		if(G[G_MULTIPLAYERACTIVE]==2){
			int numPer = Ceiling(dat[NUM_ROOMS] / ZLink::NumUsers());
			int userPos = 0;
			int count = numPer;
			// Assign all item locations to this user in case something screws up
			for(int i=0; i<IL_COUNT; ++i){
				MultiworldData[MD_STARTSPLITS+i] = ZLink::ThisUserID();
			}
			// Now try to assign item locations to users semi evenly
			for(int i=0; i<dat[NUM_ROOMS]; ++i){
				int loc = roomList[i];
				MultiworldData[MD_STARTSPLITS+loc] = ZLink::UserID(userPos);
				--count;
				if(count<=0){
					if(userPos<ZLink::NumUsers()-1)
						++userPos;
					count = numPer;
				}
			}
			// Scramble the item locations
			for(int i=0; i<dat[NUM_ROOMS]*4; ++i){
				int pos1 = randomizerSeed->Rand(dat[NUM_ROOMS]-1);
				int pos2 = randomizerSeed->Rand(dat[NUM_ROOMS]-1);
				SwapArrayIndex(MultiworldData, roomList[pos1], roomList[pos2]);
			}
		}
		
		if(RANDOMIZER_DEBUG)
			printf("SEED GENERATION SUCCESSFUL!\n");
		
		WriteSpoilerLog(dat, ogSeedVal);
		return true;
	}
	
	void PickCharacters(int count, int start, randgen randomizerSeed){
		G[G_ASHERINSEED] = 0;
		G[G_TORRININSEED] = 0;
		G[G_KAYLANIINSEED] = 0;
		G[G_SORENINSEED] = 0;
		G[G_TERRYINSEED] = 0;
		G[G_SIYEDINSEED] = 0;
		
		Link->Item[I_ASHER] = false;
		Link->Item[I_TORRIN] = false;
		Link->Item[I_KAYLANI] = false;
		Link->Item[I_SOREN] = false;
		Link->Item[I_TERRY] = false;
		Link->Item[I_SIYED] = false;
		
		bool randomizeChars;
		int charList[] = {-1, -1, -1, -1, -1, -1};
		if(start==-1){ //Random
			start = randomizerSeed->Rand(0, 5);
			charList[0] = start;
			G[G_ASHERINSEED+charList[0]] = 2;
			randomizeChars = true;
		}
		else if(start==-2){ //Vanilla Trio
			start = CHAR_ASHER;
			G[G_ASHERINSEED] = 2;
			G[G_TORRININSEED] = 2;
			G[G_KAYLANIINSEED] = 2;
			
			Link->Item[I_ASHER] = true;
			Link->Item[I_TORRIN] = true;
			Link->Item[I_KAYLANI] = true;
		}
		else if(start==-3){ //All 6
			start = CHAR_ASHER;
			G[G_ASHERINSEED] = 2;
			G[G_TORRININSEED] = 2;
			G[G_KAYLANIINSEED] = 2;
			G[G_SORENINSEED] = 2;
			G[G_TERRYINSEED] = 2;
			G[G_SIYEDINSEED] = 2;
			
			Link->Item[I_ASHER] = true;
			Link->Item[I_TORRIN] = true;
			Link->Item[I_KAYLANI] = true;
			Link->Item[I_SOREN] = true;
			Link->Item[I_TERRY] = true;
			Link->Item[I_SIYED] = true;
		}
		else{
			charList[0] = start;
			G[G_ASHERINSEED+charList[0]] = 2;
			randomizeChars = true;
		}
		if(randomizeChars){
			for(int i=1; i<count; ++i){
				Trace(i);
				charList[i] = randomizerSeed->Rand(0, 5);
				while(true){
					bool dupe = false;
					for(int j=0; j<6; ++j){
						if(charList[i]==charList[j]&&i!=j){
							dupe = true;
						}
					}
					if(dupe){
						++charList[i];
						charList[i] %= 6;
					}
					else
						break;
				}
				switch(charList[i]){
					case CHAR_ASHER:
						G[G_ASHERINSEED] = 1;
						break;
					case CHAR_TORRIN:
						G[G_TORRININSEED] = 1;
						break;
					case CHAR_KAYLANI:
						G[G_KAYLANIINSEED] = 1;
						break;
					case CHAR_SOREN:
						G[G_SORENINSEED] = 1;
						break;
					case CHAR_TERRY:
						G[G_TERRYINSEED] = 1;
						break;
					case CHAR_SIYED:
						G[G_SIYEDINSEED] = 1;
						break;
				}
			}
		}
		
		printf("START CHARACTER %d\n", start);
		Link->Item[I_ASHER] = (G[G_ASHERINSEED]==2);
		Link->Item[I_TORRIN] = (G[G_TORRININSEED]==2);
		Link->Item[I_KAYLANI] = (G[G_KAYLANIINSEED]==2);
		Link->Item[I_SOREN] = (G[G_SORENINSEED]==2);
		Link->Item[I_TERRY] = (G[G_TERRYINSEED]==2);
		Link->Item[I_SIYED] = (G[G_SIYEDINSEED]==2);
		SetCharacter(start, false);
	}
	
	int GetAllCurrentFlags(){
		int ret;
		
	}
	
	int GetHymnstoneMax(bool safetyNet){
		int itemsCount = 11;
		int roomsCount = IL_COUNT;
		if(G[G_RANDOMIZERMODE]!=1)
			roomsCount -= 4;
		if(!G[G_BESTIARYRANDO])
			roomsCount -= 81;
		
		if(G[G_ASHERINSEED])
			itemsCount += 17;
		if(G[G_TORRININSEED])
			itemsCount += 14;
		if(G[G_KAYLANIINSEED])
			itemsCount += 15;
		if(G[G_SORENINSEED])
			itemsCount += 15;
		if(G[G_TERRYINSEED])
			itemsCount += 14;
		if(G[G_SIYEDINSEED])
			itemsCount += 15;
		if(G[G_RANDOMIZERMODE]==1)
			itemsCount += 4;
		if(G[G_BESTIARYRANDO])
			itemsCount += 81;
		if(safetyNet)
			itemsCount += 10;
		if(roomsCount-itemsCount<100){
			return Floor((roomsCount-itemsCount)/10)*10;
		}
		return 100;
	}
	
	//Functions for defining room locations
	void AddRoom(untyped dat, int id, int flags){
		int roomList = dat[ARR_ROOMLIST];
		int roomFlags = dat[ARR_ROOMFLAGS];
		
		roomList[dat[NUM_ROOMS]] = id;
		roomFlags[id] = flags;
		RandomizedItems[RI_FLAGS+id] = flags;
		++dat[NUM_ROOMS];
	}
	void AddRooms(untyped dat){
		AddRoom(dat, IL_PUNA_DIVE, 0);
		AddRoom(dat, IL_OMAKA_BURN, RFLAG_FIRE);
		AddRoom(dat, IL_OMAKA_CLIFF, 0);
		AddRoom(dat, IL_OMAKA_ILLUSORYTREE, 0);
		AddRoom(dat, IL_OMAKA_ISLAND, 0);
		AddRoom(dat, IL_OMAKA_MANORSLOPE, RFLAG_TIDALGAUNTLET|RFLAG_BOMB);
		AddRoom(dat, IL_OMAKA_THROUGHCAVE, RFLAG_BOMB);
		AddRoom(dat, IL_OMAKA_TREE, 0);
		AddRoom(dat, IL_TOTEM1_ASHERHEART1, 0);
		AddRoom(dat, IL_TOTEM1_TORRINHEART1, 0);
		AddRoom(dat, IL_TOTEM1_KAYLANIHEART1, 0);
		AddRoom(dat, IL_TOTEM1_ASHERDASH, 0);
		AddRoom(dat, IL_TOTEM1_SOLARSYSTEM, 0);
		AddRoom(dat, IL_PALA_BARRELHOUSE, RFLAG_SPECIAL);
		AddRoom(dat, IL_PALA_BOXES, 0);
		AddRoom(dat, IL_PALA_CHAPPINGTON, RFLAG_FIRE);
		AddRoom(dat, IL_PALA_CONSTRUCTION, RFLAG_TIDALGAUNTLET);
		AddRoom(dat, IL_PALA_DIVE, 0);
		AddRoom(dat, IL_PALA_SORENHOUSE, 0);
		AddRoom(dat, IL_WAREHOUSE_BIGROOM, 0);
		AddRoom(dat, IL_WAREHOUSE_BOMBWALL, RFLAG_FIRE|RFLAG_BOMB);
		AddRoom(dat, IL_WAREHOUSE_CANDLE, 0);
		AddRoom(dat, IL_WAREHOUSE_UNDERARCH, 0);
		AddRoom(dat, IL_SHOP1_IRONSHIELD, 0);
		AddRoom(dat, IL_SHOP1_SILVERSWORD, 0);
		AddRoom(dat, IL_SHOP1_STONETRAP, 0);
		AddRoom(dat, IL_SHOP2_AUGBOMBS, 0);
		AddRoom(dat, IL_SHOP2_AUGCANDLE, 0);
		AddRoom(dat, IL_SHOP2_AUGGAUNTLET, 0);
		AddRoom(dat, IL_SELET_DININGROOM, RFLAG_TIDALGAUNTLET|RFLAG_STELLARWAND);
		AddRoom(dat, IL_SELET_KILLROOM, RFLAG_TIDALGAUNTLET);
		AddRoom(dat, IL_SELET_STARWAND, RFLAG_TIDALGAUNTLET);
		AddRoom(dat, IL_SELET_TIMINGPUZZLE, RFLAG_TIDALGAUNTLET|RFLAG_STELLARWAND);
		AddRoom(dat, IL_SELET_COINS, RFLAG_TIDALGAUNTLET);
		AddRoom(dat, IL_CATACOMBS_DIVESPOT, RFLAG_SPECIAL);
		AddRoom(dat, IL_CATACOMBS_LUNARTRIGGER, RFLAG_STELLARWAND|RFLAG_LUNAR);
		AddRoom(dat, IL_CATACOMBS_STARBLOCKPUZZLE, RFLAG_STELLARWAND|RFLAG_BOMB);
		AddRoom(dat, IL_KIKALA_BEHINDTREE, RFLAG_FIRE);
		AddRoom(dat, IL_KIKALA_MAGNETISLAND, RFLAG_TIDALGAUNTLET);
		AddRoom(dat, IL_KIKALA_SOLARGOLEM, 0);
		AddRoom(dat, IL_KIKALA_STARBLOCK, RFLAG_STELLARWAND);
		AddRoom(dat, IL_KAWAEHAE_BUSH, RFLAG_SPECIAL);
		AddRoom(dat, IL_KAWAEHAE_DIVE, 0);
		AddRoom(dat, IL_KAWAEHAE_STARBLOCK, RFLAG_STELLARWAND);
		AddRoom(dat, IL_KAWAEHAE_STELLARGOLEM, RFLAG_BOMBPUZZLE|RFLAG_STELLARWAND);
		AddRoom(dat, IL_KAWI_BOMBCAVE, RFLAG_BOMB);
		AddRoom(dat, IL_KAWI_BOMBCLIFF, RFLAG_BOMB);
		AddRoom(dat, IL_KAWI_BOMBDUNE, RFLAG_BOMB);
		AddRoom(dat, IL_KAWI_BURNCACTUS, RFLAG_FIRE);
		AddRoom(dat, IL_KAWI_BEHINDTREE, 0);
		AddRoom(dat, IL_KAWI_DIVE, 0);
		AddRoom(dat, IL_KAWI_ISLAND, 0);
		AddRoom(dat, IL_TOTEM2_ASHERHEART2, RFLAG_FIRE);
		AddRoom(dat, IL_TOTEM2_TORRINHEART2, RFLAG_FIRE);
		AddRoom(dat, IL_TOTEM2_KAYLANIHEART2, RFLAG_FIRE);
		AddRoom(dat, IL_TOTEM2_BLACKBELT, RFLAG_FIRE);
		AddRoom(dat, IL_TOTEM2_SUNDOG, RFLAG_FIRE);
		AddRoom(dat, IL_PIRATE_BOMBPUZZLE, RFLAG_FIRE|RFLAG_BOMBPUZZLE);
		AddRoom(dat, IL_PIRATE_BOMBS, RFLAG_FIRE);
		AddRoom(dat, IL_PIRATE_GAUNTLETPUZZLE, RFLAG_FIRE|RFLAG_TIDALGAUNTLET|RFLAG_BOMB);
		AddRoom(dat, IL_PIRATE_SWITCHKILLROOM, RFLAG_FIRE|RFLAG_BOMBPUZZLE);
		AddRoom(dat, IL_MALKA_UNDERHOUSE, 0);
		AddRoom(dat, IL_MALKA_TAROFIELD, 0);
		AddRoom(dat, IL_SHOP3_AUGALTLUNAR, 0);
		AddRoom(dat, IL_SHOP3_AUGAUTOLOCK, 0);
		AddRoom(dat, IL_SHOP3_AUGREFLECT, 0);
		AddRoom(dat, IL_SHOALS_BARRELCAVE, RFLAG_SPECIAL);
		AddRoom(dat, IL_SHOALS_BURNBUSH, RFLAG_FIRE);
		AddRoom(dat, IL_SHOALS_CUTSCENESCREEN, 0);
		AddRoom(dat, IL_SHOALS_DARKCAVE, RFLAG_BOMB|RFLAG_FIRE);
		AddRoom(dat, IL_SHOALS_MAGNETBUSH, RFLAG_TIDALGAUNTLET);
		AddRoom(dat, IL_TOTEM3_ASHERAUGMENTSLOT1, 0);
		AddRoom(dat, IL_TOTEM3_TORRINAUGMENTSLOT1, 0);
		AddRoom(dat, IL_TOTEM3_KAYLANIAUGMENTSLOT1, 0);
		AddRoom(dat, IL_TOTEM3_DASHCOUNTER, 0);
		AddRoom(dat, IL_TOTEM3_SOLARMIGHT, 0);
		AddRoom(dat, IL_MINES_BEETLEGEM, RFLAG_BOMB|RFLAG_TIDALGAUNTLET);
		AddRoom(dat, IL_MINES_BEETLEPIT, RFLAG_FIRE|RFLAG_BOMB|RFLAG_TIDALGAUNTLET);
		AddRoom(dat, IL_MINES_GAUNTLET, RFLAG_FIRE|RFLAG_BOMB);
		AddRoom(dat, IL_MINES_GAUNTLETSPIKES, RFLAG_FIRE|RFLAG_BOMB|RFLAG_TIDALGAUNTLET);
		AddRoom(dat, IL_MINES_GEMHOLE, RFLAG_FIRE|RFLAG_BOMB|RFLAG_TIDALGAUNTLET);
		AddRoom(dat, IL_MINES_TIMERPUZZLE, RFLAG_FIRE|RFLAG_BOMB|RFLAG_TIDALGAUNTLET);
		AddRoom(dat, IL_WAHI_BEHINDTREE, 0);
		AddRoom(dat, IL_WAHI_BURNSHRUB, RFLAG_FIRE);
		AddRoom(dat, IL_WAHI_BURNTREE, RFLAG_BOMB|RFLAG_FIRE);
		AddRoom(dat, IL_WAHI_BUSH, 0);
		AddRoom(dat, IL_WAHI_CLOUDTRIGGER, RFLAG_SPECIAL);
		AddRoom(dat, IL_WAHI_FOOTHILLSLAVACAVE, RFLAG_BOMB);
		AddRoom(dat, IL_WAHI_HOKUCAVE, RFLAG_BOMB);
		AddRoom(dat, IL_WAHI_LUNARGOLEM, RFLAG_BOMB);
		AddRoom(dat, IL_WAHI_LUNARTRIGGER, RFLAG_LUNAR);
		AddRoom(dat, IL_WAHI_MONEYCAVE, RFLAG_BOMB);
		AddRoom(dat, IL_WAHI_VALLEYKILLROOM, RFLAG_BOMB);
		AddRoom(dat, IL_SHOP4_AUGSAFECHARGE, 0);
		AddRoom(dat, IL_SHOP4_AUGSTELLARSWORD, 0);
		AddRoom(dat, IL_SHOP4_AUGSTELLARWAND, 0);
		AddRoom(dat, IL_JUNGLECAVE_BOMBROCK, RFLAG_BOMB);
		AddRoom(dat, IL_JUNGLETEMPLE_SOLARPILLAR, RFLAG_STELLARWAND);
		AddRoom(dat, IL_TOTEM4_ASHERHEART3, RFLAG_TIDALGAUNTLET);
		AddRoom(dat, IL_TOTEM4_TORRINHEART3, RFLAG_TIDALGAUNTLET);
		AddRoom(dat, IL_TOTEM4_KAYLANIHEART3, RFLAG_TIDALGAUNTLET);
		AddRoom(dat, IL_TOTEM4_STELLAIRE, RFLAG_TIDALGAUNTLET);
		AddRoom(dat, IL_TOTEM4_SOLARFLARE, RFLAG_TIDALGAUNTLET);
		AddRoom(dat, IL_ALII_BEHINDTREE, 0);
		AddRoom(dat, IL_ALII_DIVECAVE, RFLAG_BOMB);
		AddRoom(dat, IL_ALII_DROPINCAVE, RFLAG_BOMB|RFLAG_TIDALGAUNTLET);
		AddRoom(dat, IL_ALII_ENTRANCEBOMBWALL, RFLAG_BOMB);
		AddRoom(dat, IL_ALII_ENTRNACESPIKEBARRIER, 0);
		AddRoom(dat, IL_ALII_STELLARPILLAR, RFLAG_TIDALGAUNTLET);
		AddRoom(dat, IL_OBSERVATORY_STARSTONE, RFLAG_SPECIAL);
		AddRoom(dat, IL_OBSERVATORY_COINPOT, RFLAG_SPECIAL);
		AddRoom(dat, IL_OBSERVATORY_CUBBYHOLE, RFLAG_SPECIAL);
		AddRoom(dat, IL_OBSERVATORY_ENTRANCE, RFLAG_SPECIAL);
		AddRoom(dat, IL_OBSERVATORY_ORBBOMBWALL, RFLAG_SPECIAL);
		AddRoom(dat, IL_OBSERVATORY_STARWANDPUZZLE, RFLAG_SPECIAL);
		AddRoom(dat, IL_OBSERVATORY_SWITCHROOM, RFLAG_SPECIAL);
		AddRoom(dat, IL_OBSERVATORY_UNDERREDORB, RFLAG_SPECIAL);
		AddRoom(dat, IL_KOHI_CAVE, 0);
		AddRoom(dat, IL_KOHI_DIVE, 0);
		AddRoom(dat, IL_KOHI_LAKE, RFLAG_TIDALGAUNTLET);
		AddRoom(dat, IL_KOHI_OVERHANG, 0);
		AddRoom(dat, IL_KOHI_RAVINE, RFLAG_TIDALGAUNTLET);
		AddRoom(dat, IL_KOHI_RUINS, RFLAG_TIDALGAUNTLET);
		AddRoom(dat, IL_KOHI_STARWANDPUZZLE, RFLAG_TIDALGAUNTLET|RFLAG_STELLARWAND);
		AddRoom(dat, IL_POHO_BOMBWALLSWITCH, RFLAG_TIDALGAUNTLET|RFLAG_SOLAR|RFLAG_BOMB|RFLAG_LUNARANG);
		AddRoom(dat, IL_POHO_ELEMENTPUZZLE, RFLAG_SPECIAL);
		AddRoom(dat, IL_POHO_LUNARANG, RFLAG_SOLAR|RFLAG_TIDALGAUNTLET);
		AddRoom(dat, IL_POHO_MISTPOT, RFLAG_LUNARANG);
		AddRoom(dat, IL_TULANE_CAVE, 0);
		AddRoom(dat, IL_TULANE_SIDEPATH, 0);
		AddRoom(dat, IL_TULANE_WATERSIDE, 0);
		AddRoom(dat, IL_LEIPAI_BEHINDTREE, RFLAG_TIDALGAUNTLET);
		AddRoom(dat, IL_LEIPAI_BRIDGE, RFLAG_TIDALGAUNTLET);
		AddRoom(dat, IL_LEIPAI_COINS, RFLAG_TIDALGAUNTLET);
		AddRoom(dat, IL_KUKULU_KILLROOM, 0);
		AddRoom(dat, IL_KUKULU_SWITCHPUZZLE, RFLAG_BOMBPUZZLE|RFLAG_LUNARANG);
		AddRoom(dat, IL_CARN_BLOCKGEMPUZZLE, RFLAG_FIRE|RFLAG_BOMBPUZZLE|RFLAG_TIDALGAUNTLET|RFLAG_STELLARWAND);
		AddRoom(dat, IL_CARN_BOMBGEMPUZZLE, RFLAG_FIRE|RFLAG_BOMBPUZZLE|RFLAG_TIDALGAUNTLET);
		AddRoom(dat, IL_CARN_BOMBROCK, RFLAG_BOMB);
		AddRoom(dat, IL_CARN_BOMBWALL, RFLAG_FIRE|RFLAG_BOMB);
		AddRoom(dat, IL_CARN_FUSIONGOLEM, RFLAG_FIRE|RFLAG_BOMBPUZZLE|RFLAG_TIDALGAUNTLET|RFLAG_STELLARWAND);
		AddRoom(dat, IL_PIRATE2_COINCHEST, RFLAG_TIDALGAUNTLET|RFLAG_STELLARWAND);
		AddRoom(dat, IL_TOTEM5_ASHERAUGMENTSLOT2, RFLAG_BOMB);
		AddRoom(dat, IL_TOTEM5_TORRINAUGMENTSLOT2, RFLAG_SPECIAL);
		AddRoom(dat, IL_TOTEM5_KAYLANIAUGMENTSLOT2, RFLAG_SPECIAL);
		AddRoom(dat, IL_TOMBOL, RFLAG_FIRE|RFLAG_SOLAR);
		AddRoom(dat, IL_THREEBROTHERS, RFLAG_TIDALGAUNTLET);
		AddRoom(dat, IL_THREEBROTHERSCOINS, 0);
		AddRoom(dat, IL_THREEBROTHERSCOINSSECRET, 0);
		AddRoom(dat, IL_WAYPOINT, 0);
		AddRoom(dat, IL_WAYPOINTSECRET, RFLAG_SPECIAL);
		AddRoom(dat, IL_MIRAGE, RFLAG_BOMB);
		
		AddRoom(dat, IL_SP_WAREHOUSE1, RFLAG_FIRE);
		AddRoom(dat, IL_SP_WAREHOUSE2, RFLAG_FIRE);
		AddRoom(dat, IL_SP_PIRATE1, RFLAG_FIRE|RFLAG_BOMBPUZZLE);
		AddRoom(dat, IL_SP_PIRATE2, RFLAG_FIRE|RFLAG_BOMBPUZZLE);
		AddRoom(dat, IL_SP_MINES1, RFLAG_FIRE|RFLAG_BOMB|RFLAG_TIDALGAUNTLET);
		AddRoom(dat, IL_SP_MINES2, RFLAG_FIRE|RFLAG_BOMB|RFLAG_TIDALGAUNTLET);
		AddRoom(dat, IL_SP_MINES3, RFLAG_FIRE|RFLAG_BOMB|RFLAG_TIDALGAUNTLET);
		AddRoom(dat, IL_SP_MANOR, 0);
		AddRoom(dat, IL_SP_CATACOMBS1, RFLAG_SPECIAL);
		AddRoom(dat, IL_SP_CATACOMBS2, RFLAG_SPECIAL);
		AddRoom(dat, IL_SP_POHO1, RFLAG_LUNARANG);
		AddRoom(dat, IL_SP_POHO2, RFLAG_SOLAR);
		AddRoom(dat, IL_SP_POHO3, RFLAG_SOLAR|RFLAG_LUNARANG|RFLAG_STELLARWAND|RFLAG_BOMB);
		AddRoom(dat, IL_SP_POHO4, RFLAG_SOLAR|RFLAG_LUNARANG|RFLAG_STELLARWAND|RFLAG_BOMB);
		AddRoom(dat, IL_SP_POHOBOSS1, 0);
		AddRoom(dat, IL_SP_POHOBOSS2, 0);
		AddRoom(dat, IL_SP_KAWAEHAE1, RFLAG_BOMBPUZZLE);
		AddRoom(dat, IL_SP_KAWAEHAE2, RFLAG_BOMBPUZZLE);
		AddRoom(dat, IL_SP_JUNGLEPLANT1, RFLAG_BOMB);
		AddRoom(dat, IL_SP_JUNGLEPLANT2, RFLAG_BOMB);
		AddRoom(dat, IL_SP_KIKALA1, 0);
		AddRoom(dat, IL_SP_KIKALA2, 0);
		AddRoom(dat, IL_SP_TULANE1, 0);
		AddRoom(dat, IL_SP_TULANE2, 0);
		AddRoom(dat, IL_SP_SOLARGOLEM, 0);
		AddRoom(dat, IL_SP_LUNARGOLEM, RFLAG_BOMB);
		AddRoom(dat, IL_SP_STELLARGOLEM, RFLAG_BOMBPUZZLE|RFLAG_TIDALGAUNTLET);
		AddRoom(dat, IL_SP_FUSIONGOLEM1, RFLAG_FIRE|RFLAG_BOMBPUZZLE|RFLAG_TIDALGAUNTLET|RFLAG_STELLARWAND);
		AddRoom(dat, IL_SP_FUSIONGOLEM2, RFLAG_FIRE|RFLAG_BOMBPUZZLE|RFLAG_TIDALGAUNTLET|RFLAG_STELLARWAND);
		AddRoom(dat, IL_SP_FUSIONGOLEM3, RFLAG_FIRE|RFLAG_BOMBPUZZLE|RFLAG_TIDALGAUNTLET|RFLAG_STELLARWAND);
		AddRoom(dat, IL_SP_PIRATEREMATCH1, RFLAG_TIDALGAUNTLET|RFLAG_STELLARWAND);
		AddRoom(dat, IL_SP_PIRATEREMATCH2, RFLAG_TIDALGAUNTLET|RFLAG_STELLARWAND);
		AddRoom(dat, IL_SP_NECKLACEROCK1, RFLAG_BOMB);
		AddRoom(dat, IL_SP_NECKLACEROCK2, RFLAG_BOMB);
		AddRoom(dat, IL_SP_JUNGLETEMPLE1, RFLAG_STELLARWAND);
		AddRoom(dat, IL_SP_JUNGLETEMPLE2, RFLAG_STELLARWAND);
		AddRoom(dat, IL_SP_TELSPYRAMID1, 0);
		AddRoom(dat, IL_SP_TELSPYRAMID2, 0);
		AddRoom(dat, IL_SP_UNDERSEAPYRAMID1, RFLAG_BOMB);
		AddRoom(dat, IL_SP_UNDERSEAPYRAMID2, RFLAG_BOMB);
		AddRoom(dat, IL_ZARATHLIFELESSON, RFLAG_FIRE|RFLAG_BOMB);
		
		if(G[G_RANDOMIZERMODE]==1){
			AddRoom(dat, IL_NIGHTMARESELET1, RFLAG_FIRE|RFLAG_BOMBPUZZLE|RFLAG_TIDALGAUNTLET|RFLAG_STELLARWAND);
			AddRoom(dat, IL_NIGHTMARESELET2, RFLAG_FIRE|RFLAG_BOMBPUZZLE|RFLAG_TIDALGAUNTLET|RFLAG_STELLARWAND);
			AddRoom(dat, IL_NIGHTMARESELET3, RFLAG_FIRE|RFLAG_BOMBPUZZLE|RFLAG_TIDALGAUNTLET|RFLAG_STELLARWAND);
			AddRoom(dat, IL_NIGHTMARESELET4, RFLAG_FIRE|RFLAG_BOMBPUZZLE|RFLAG_TIDALGAUNTLET|RFLAG_STELLARWAND);
		}
		
		if(G[G_BESTIARYRANDO]){
			AddRoom(dat, IL_BES_REDOCTO, 0);
			AddRoom(dat, IL_BES_BLUEOCTO, 0);
			AddRoom(dat, IL_BES_CRAB, 0);
			AddRoom(dat, IL_BES_ARMOREDCRAB, 0);
			AddRoom(dat, IL_BES_EMBEDDECRAB, 0);
			AddRoom(dat, IL_BES_REDRATANG, 0);
			AddRoom(dat, IL_BES_BLUERATANG, 0);
			AddRoom(dat, IL_BES_PALERATANG, 0);
			AddRoom(dat, IL_BES_LUNATICRATANG, 0);
			AddRoom(dat, IL_BES_BAT, 0);
			AddRoom(dat, IL_BES_MADBAT, 0);
			AddRoom(dat, IL_BES_SPIDER, 0);
			AddRoom(dat, IL_BES_BLOATEDSPIDER, RFLAG_FIRE);
			AddRoom(dat, IL_BES_RAT, 0);
			AddRoom(dat, IL_BES_SNAKE, 0);
			AddRoom(dat, IL_BES_JUNGLESNAKE, 0);
			AddRoom(dat, IL_BES_SKULLPENT, 0);
			AddRoom(dat, IL_BES_OSSIFIEDSERPENT, 0);
			AddRoom(dat, IL_BES_SEASTRIDER, 0);
			AddRoom(dat, IL_BES_CLIFFSTRIDER, 0);
			AddRoom(dat, IL_BES_SUNSTRIDER, 0);
			AddRoom(dat, IL_BES_DIMLIT, 0);
			AddRoom(dat, IL_BES_FLAMINGDIMLIT, 0);
			AddRoom(dat, IL_BES_SPINEPUFFER, 0);
			AddRoom(dat, IL_BES_FIREPUFFER, 0);
			AddRoom(dat, IL_BES_STARPUFFER, 0);
			AddRoom(dat, IL_BES_REDHOPMAW, 0);
			AddRoom(dat, IL_BES_BLUEHOPMAW, 0);
			AddRoom(dat, IL_BES_BEEHIVE, RFLAG_BOMB);
			AddRoom(dat, IL_BES_SAWTOOTH, RFLAG_FIRE|RFLAG_BOMB);
			AddRoom(dat, IL_BES_ZOLO, 0);
			AddRoom(dat, IL_BES_DROPLET, RFLAG_FIRE);
			AddRoom(dat, IL_BES_DRIPLET, RFLAG_FIRE);
			AddRoom(dat, IL_BES_SPINYBEETLE, RFLAG_FIRE|RFLAG_BOMB|RFLAG_TIDALGAUNTLET);
			AddRoom(dat, IL_BES_SOLARCURSTELLATION, RFLAG_BOMB|RFLAG_STELLARWAND);
			AddRoom(dat, IL_BES_LUNARCURSTELLATION, RFLAG_BOMB|RFLAG_STELLARWAND);
			AddRoom(dat, IL_BES_STELLARCURSTELLATION, RFLAG_SPECIAL);
			AddRoom(dat, IL_BES_BOOMBA, 0);
			AddRoom(dat, IL_BES_PLATEDBOOMBA, RFLAG_TIDALGAUNTLET);
			AddRoom(dat, IL_BES_QUADCANNON, RFLAG_FIRE|RFLAG_BOMB);
			AddRoom(dat, IL_BES_MUMMY, 0);
			AddRoom(dat, IL_BES_BLOODMUMMY, 0);
			AddRoom(dat, IL_BES_STONEGUARDIAN, 0);
			AddRoom(dat, IL_BES_STONEHELMET, RFLAG_STELLARWAND|RFLAG_LUNARANG);
			AddRoom(dat, IL_BES_GHOST, 0);
			AddRoom(dat, IL_BES_COSMICSPOOK, RFLAG_SPECIAL);
			AddRoom(dat, IL_BES_NIGHTMARCHER, RFLAG_FINALDUNGEON|RFLAG_FIRE|RFLAG_BOMB|RFLAG_TIDALGAUNTLET|RFLAG_STELLARWAND|RFLAG_LUNARANG);
			AddRoom(dat, IL_BES_SUNEATER, 0);
			AddRoom(dat, IL_BES_MOONEATER, 0);
			AddRoom(dat, IL_BES_STAREATER, 0);
			AddRoom(dat, IL_BES_SOLARWIZARD, 0);
			AddRoom(dat, IL_BES_LUNARWIZARD, 0);
			AddRoom(dat, IL_BES_STELLARWIZARD, 0);
			AddRoom(dat, IL_BES_SOLARCRABLIKE, 0);
			AddRoom(dat, IL_BES_LUNARCRABLIKE, 0);
			AddRoom(dat, IL_BES_STELLARCRABLIKE, 0);
			AddRoom(dat, IL_BES_SOLARSTARTOUCHED, 0);
			AddRoom(dat, IL_BES_LUNARSTARTOUCHED, 0);
			AddRoom(dat, IL_BES_STELLARSTARTOUCHED, RFLAG_TIDALGAUNTLET);
			AddRoom(dat, IL_BES_SOLARPILLAR, RFLAG_BOMBPUZZLE);
			AddRoom(dat, IL_BES_LUNARPILLAR, 0);
			AddRoom(dat, IL_BES_STELLARPILLAR, RFLAG_TIDALGAUNTLET);
			AddRoom(dat, IL_BES_BLADEPIRATE, 0);
			AddRoom(dat, IL_BES_PISTOLPIRATE, 0);
			AddRoom(dat, IL_BES_BATTERYPIRATE, 0);
			AddRoom(dat, IL_BES_ELITEPIRATE, RFLAG_STELLARWAND);
			AddRoom(dat, IL_BES_SOLARMASK, 0);
			AddRoom(dat, IL_BES_LUNARMASK, 0);
			AddRoom(dat, IL_BES_STELLARMASK, 0);
			AddRoom(dat, IL_BES_SOLARSPELLBEARER, 0);
			AddRoom(dat, IL_BES_LUNARSPELLBEARER, 0);
			AddRoom(dat, IL_BES_STELLARSPELLBEARER, 0);
			AddRoom(dat, IL_BES_SOLARGOLEM, 0);
			AddRoom(dat, IL_BES_LUNARGOLEM, RFLAG_BOMB);
			AddRoom(dat, IL_BES_STELLARGOLEM, RFLAG_BOMBPUZZLE|RFLAG_TIDALGAUNTLET);
			AddRoom(dat, IL_BES_FUSIONGOLEM, RFLAG_FIRE|RFLAG_BOMBPUZZLE|RFLAG_TIDALGAUNTLET|RFLAG_STELLARWAND);
			AddRoom(dat, IL_BES_CAPTAINSHELROND, RFLAG_FIRE|RFLAG_BOMBPUZZLE);
			AddRoom(dat, IL_BES_BOLIDEBORER2000, RFLAG_FIRE|RFLAG_BOMB|RFLAG_TIDALGAUNTLET);
			AddRoom(dat, IL_BES_ESAN, 0);
			AddRoom(dat, IL_BES_SELET, RFLAG_FIRE|RFLAG_BOMB|RFLAG_TIDALGAUNTLET);
			AddRoom(dat, IL_BES_NIGHTMARESELET, RFLAG_SPECIAL);
		}
	}
	
	//Functions for defining room items
	void AddItem(untyped dat, int id, int flags, int itemType){
		int itemList = dat[ARR_ITEMLIST];
		long itemFlags = dat[ARR_ITEMFLAGS];
		int triggerItems = dat[ARR_TRIGGERITEMLIST];
		int specialItems = dat[ARR_SPECIALITEMLIST];
		int trashItems = dat[ARR_TRASHITEMLIST];
		
		itemList[dat[NUM_ITEMS]] = id;
		itemFlags[id] = flags;
		RandomizedItems[RI_ITEMFLAGS+id] = flags;
		
		switch(itemType){
			case IT_TRIGGER:
				triggerItems[dat[NUM_TRIGGERITEMS]] = id;
				//printf("Added item %d to triggerItems[%d]\n", id, dat[NUM_TRIGGERITEMS]);
				++dat[NUM_TRIGGERITEMS];
				break;
			case IT_SPECIAL:
				specialItems[dat[NUM_SPECIALITEMS]] = id;
				//printf("Added item %d to specialItems[%d]\n", id, dat[NUM_SPECIALITEMS]);
				++dat[NUM_SPECIALITEMS];
				break;
			default:
				trashItems[dat[NUM_TRASHITEMS]] = id;
				//printf("Added item %d to trashItems[%d]\n", id, dat[NUM_TRASHITEMS]);
				++dat[NUM_TRASHITEMS];
				break;
		}
		++dat[NUM_ITEMS];
	}
	void AddItems(untyped dat, int hymnstoneCap){
		randgen randomizerSeed = <randgen>dat[RAND_RANDOMIZERSEED];
		
		AddItem(dat, I_CANDLE2, RFLAG_FIRE, IT_TRIGGER);
		AddItem(dat, I_LOBBOMB, RFLAG_BOMB|RFLAG_BOMBPUZZLE, IT_TRIGGER);
		AddItem(dat, I_TIDALGAUNTLETMOON, RFLAG_TIDALGAUNTLET, IT_TRIGGER);
		AddItem(dat, I_WAND, RFLAG_STELLARWAND, IT_TRIGGER);
		AddItem(dat, I_LUNARANG, RFLAG_LUNARANG|RFLAG_LUNAR, IT_TRIGGER);
		AddItem(dat, I_SHIELD2, 0, IT_SPECIAL);
		
		if(G[G_ASHERINSEED]){
			if(G[G_ASHERINSEED]!=2)
				AddItem(dat, I_ASHER, RFLAG_SPECIAL, IT_TRIGGER);
			
			AddItem(dat, I_SWORD2, 0, IT_SPECIAL);
			AddItem(dat, I_DASHUPGRADE, 0, IT_SPECIAL);
		
			AddItem(dat, I_ABILITY_A_ASHER, RFLAG_SPECIAL, IT_TRIGGER);
			AddItem(dat, I_ABILITY_A_ASHER, RFLAG_SPECIAL, IT_TRIGGER);
			AddItem(dat, I_ABILITY_B_ASHER, 0, IT_SPECIAL);
			AddItem(dat, I_ABILITY_C_ASHER, 0, IT_SPECIAL);
			
			AddItem(dat, I_HC_ASHER, 0, IT_SPECIAL);
			AddItem(dat, I_HC_ASHER, 0, IT_SPECIAL);
			AddItem(dat, I_HC_ASHER, 0, IT_SPECIAL);
			AddItem(dat, I_AUGMENTSLOT_ASHER, 0, IT_SPECIAL);
			AddItem(dat, I_AUGMENTSLOT_ASHER, 0, IT_SPECIAL);
			
			AddItem(dat, I_AUGMENT_DASHDIST, 0, IT_SPECIAL);
			AddItem(dat, I_AUGMENT_DASHCOUNTER, 0, IT_SPECIAL);
			AddItem(dat, I_AUGMENT_STELLARSWORD, 0, IT_SPECIAL);
			AddItem(dat, I_AUGMENT_MINIOR, 0, IT_SPECIAL);
			AddItem(dat, I_AUGMENT_REFLECT, 0, IT_SPECIAL);
		}
		if(G[G_TORRININSEED]){
			if(G[G_TORRININSEED]!=2)
				AddItem(dat, I_TORRIN, RFLAG_SPECIAL, IT_TRIGGER);
			
			AddItem(dat, I_SWORD_TORRIN2, 0, IT_SPECIAL);
			AddItem(dat, I_ABILITY_B_TORRIN, RFLAG_SPECIAL, IT_SPECIAL);
			AddItem(dat, I_ABILITY_C_TORRIN, 0, IT_SPECIAL);
		
			AddItem(dat, I_HC_TORRIN, 0, IT_SPECIAL);
			AddItem(dat, I_HC_TORRIN, 0, IT_SPECIAL);
			AddItem(dat, I_HC_TORRIN, 0, IT_SPECIAL);
			AddItem(dat, I_AUGMENTSLOT_TORRIN, 0, IT_SPECIAL);
			AddItem(dat, I_AUGMENTSLOT_TORRIN, 0, IT_SPECIAL);
			
			AddItem(dat, I_AUGMENT_THROWPUNCH, 0, IT_SPECIAL);
			AddItem(dat, I_AUGMENT_AUTOLOCK, 0, IT_SPECIAL);
			AddItem(dat, I_AUGMENT_ALTBATTERYSOLAR, 0, IT_TRIGGER);
			AddItem(dat, I_AUGMENT_ALTBATTERYLUNAR, RFLAG_SPECIAL, IT_TRIGGER);
			AddItem(dat, I_AUGMENT_ALTBATTERYSTELLAR, 0, IT_TRIGGER);
		}
		if(G[G_KAYLANIINSEED]){
			if(G[G_KAYLANIINSEED]!=2)
				AddItem(dat, I_KAYLANI, RFLAG_SPECIAL, IT_TRIGGER);
			else
				GiveItemFlags(dat, I_KAYLANI);
			
			AddItem(dat, I_SWORD_KAYLANI2, 0, IT_TRIGGER);
			AddItem(dat, I_ABILITY_A_KAYLANI, 0, IT_SPECIAL);
			AddItem(dat, I_ABILITY_B_KAYLANI, 0, IT_TRIGGER);
			AddItem(dat, I_ABILITY_C_KAYLANI, 0, IT_SPECIAL);
			
			AddItem(dat, I_HC_KAYLANI, 0, IT_SPECIAL);
			AddItem(dat, I_HC_KAYLANI, 0, IT_SPECIAL);
			AddItem(dat, I_HC_KAYLANI, 0, IT_SPECIAL);
			AddItem(dat, I_AUGMENTSLOT_KAYLANI, 0, IT_SPECIAL);
			AddItem(dat, I_AUGMENTSLOT_KAYLANI, 0, IT_SPECIAL);
			
			AddItem(dat, I_AUGMENT_RANGE, 0, IT_SPECIAL);
			AddItem(dat, I_AUGMENT_CHARGE, 0, IT_SPECIAL);
			AddItem(dat, I_AUGMENT_SPARK, 0, IT_SPECIAL);
			AddItem(dat, I_AUGMENT_MIRAGE, 0, IT_TRIGGER);
			AddItem(dat, I_AUGMENT_LASER, 0, IT_SPECIAL);
		}
		if(G[G_SORENINSEED]){
			if(G[G_SORENINSEED]!=2)
				AddItem(dat, I_SOREN, RFLAG_SPECIAL, IT_TRIGGER);
			
			AddItem(dat, I_SWORD_SOREN2, 0, IT_SPECIAL);
			AddItem(dat, I_ABILITY_A_SOREN, 0, IT_SPECIAL);
			AddItem(dat, I_ABILITY_B_SOREN, RFLAG_SPECIAL, IT_TRIGGER);
			AddItem(dat, I_ABILITY_C_SOREN, 0, IT_TRIGGER);
			
			AddItem(dat, I_HC_SOREN, 0, IT_SPECIAL);
			AddItem(dat, I_HC_SOREN, 0, IT_SPECIAL);
			AddItem(dat, I_HC_SOREN, 0, IT_SPECIAL);
			AddItem(dat, I_AUGMENTSLOT_SOREN, 0, IT_SPECIAL);
			AddItem(dat, I_AUGMENTSLOT_SOREN, 0, IT_SPECIAL);
			
			AddItem(dat, I_AUGMENT_FLASHCHARGE, 0, IT_SPECIAL);
			AddItem(dat, I_AUGMENT_LINGERINGFLAME, 0, IT_SPECIAL);
			AddItem(dat, I_AUGMENT_SPARKINGDASH, 0, IT_SPECIAL);
			AddItem(dat, I_AUGMENT_RESPONSIBLERICOCHET, 0, IT_SPECIAL);
			AddItem(dat, I_AUGMENT_CRITICALGRAPPLE, 0, IT_SPECIAL);
		}
		if(G[G_TERRYINSEED]){
			if(G[G_TERRYINSEED]!=2)
				AddItem(dat, I_TERRY, RFLAG_SPECIAL, IT_TRIGGER);
			
			AddItem(dat, I_SWORD_TERRY2, 0, IT_SPECIAL);
			AddItem(dat, I_ABILITY_B_TERRY, RFLAG_SPECIAL, IT_TRIGGER);
			AddItem(dat, I_ABILITY_C_TERRY, 0, IT_TRIGGER);
			
			AddItem(dat, I_HC_TERRY, 0, IT_SPECIAL);
			AddItem(dat, I_HC_TERRY, 0, IT_SPECIAL);
			AddItem(dat, I_HC_TERRY, 0, IT_SPECIAL);
			AddItem(dat, I_AUGMENTSLOT_TERRY, 0, IT_SPECIAL);
			AddItem(dat, I_AUGMENTSLOT_TERRY, 0, IT_SPECIAL);
			
			AddItem(dat, I_AUGMENT_HADOUKEN, 0, IT_SPECIAL);
			AddItem(dat, I_AUGMENT_DIREDROPS, 0, IT_SPECIAL);
			AddItem(dat, I_AUGMENT_ALTBATTERYSOLARTERRY, 0, IT_SPECIAL);
			AddItem(dat, I_AUGMENT_ALTBATTERYLUNARTERRY, RFLAG_SPECIAL, IT_TRIGGER);
			AddItem(dat, I_AUGMENT_ALTBATTERYSTELLARTERRY, 0, IT_SPECIAL);
		}
		if(G[G_SIYEDINSEED]){
			if(G[G_SIYEDINSEED]!=2)
				AddItem(dat, I_SIYED, RFLAG_SPECIAL, IT_TRIGGER);
			else
				GiveItemFlags(dat, I_KAYLANI);
			
			AddItem(dat, I_SWORD_SIYED2, 0, IT_SPECIAL);
			AddItem(dat, I_ABILITY_A_SIYED, 0, IT_TRIGGER);
			AddItem(dat, I_ABILITY_B_SIYED, 0, IT_TRIGGER);
			AddItem(dat, I_ABILITY_C_SIYED, 0, IT_SPECIAL);
			
			AddItem(dat, I_HC_SIYED, 0, IT_SPECIAL);
			AddItem(dat, I_HC_SIYED, 0, IT_SPECIAL);
			AddItem(dat, I_HC_SIYED, 0, IT_SPECIAL);
			AddItem(dat, I_AUGMENTSLOT_SIYED, 0, IT_SPECIAL);
			AddItem(dat, I_AUGMENTSLOT_SIYED, 0, IT_SPECIAL);
			
			AddItem(dat, I_AUGMENT_RANGESIYED, 0, IT_SPECIAL);
			AddItem(dat, I_AUGMENT_DIAGONALHEAT, 0, IT_SPECIAL);
			AddItem(dat, I_AUGMENT_UPDRAFT, 0, IT_SPECIAL);
			AddItem(dat, I_AUGMENT_CONCENTRATION, 0, IT_SPECIAL);
			AddItem(dat, I_AUGMENT_UNSTABLEORBIT, 0, IT_SPECIAL);
		}
		
		
		AddItem(dat, I_AUGMENT_CANDLE, 0, IT_SPECIAL);
		AddItem(dat, I_AUGMENT_BOMB, 0, IT_SPECIAL);
		AddItem(dat, I_AUGMENT_MAGNET, 0, IT_SPECIAL);
		AddItem(dat, I_AUGMENT_WAND, 0, IT_SPECIAL);
		AddItem(dat, I_AUGMENT_SPEED, 0, IT_SPECIAL);
		
		if(G[G_BESTIARYRANDO]){
			for(int i=0; i<81; ++i){
				AddItem(dat, 1000+BestiaryEnemyID(i), 0, IT_TRASH);
			}
		}
		
		for(int i=0; i<hymnstoneCap; ++i){
			AddItem(dat, I_HYMNSTONE, RFLAG_SPECIAL, IT_TRASH);
		}
		
		for(int i=dat[NUM_ITEMS]; i<dat[NUM_ROOMS]; ++i){
			int pool[] = {I_RUPEE5, I_RUPEE10, I_RUPEE10, I_RUPEE20};
			AddItem(dat, pool[randomizerSeed->Rand(0, 3)], 0, IT_TRASH);
		}
		
		if(dat[NUM_ITEMS]>dat[NUM_ROOMS]){
			printf("ERROR: Number of items (%d) exceeds number of rooms (%d)", dat[NUM_ITEMS], dat[NUM_ROOMS]);
			return;
		}
	}
	
	void ScrambleItemPools(untyped dat){
		int itemList = dat[ARR_ITEMLIST];
		int triggerItems = dat[ARR_TRIGGERITEMLIST];
		int specialItems = dat[ARR_SPECIALITEMLIST];
		int trashItems = dat[ARR_TRASHITEMLIST];
		
		randgen randomizerSeed = <randgen>dat[RAND_RANDOMIZERSEED];
		
		for(int i=0; i<dat[NUM_TRIGGERITEMS]*4; ++i){
			int oldPos = randomizerSeed->Rand(dat[NUM_TRIGGERITEMS]-1);
			int newPos = randomizerSeed->Rand(dat[NUM_TRIGGERITEMS]-1);
			int old = triggerItems[oldPos];
			triggerItems[oldPos] = triggerItems[newPos];
			triggerItems[newPos] = old;
		}
		for(int i=0; i<dat[NUM_SPECIALITEMS]*4; ++i){
			int oldPos = randomizerSeed->Rand(dat[NUM_SPECIALITEMS]-1);
			int newPos = randomizerSeed->Rand(dat[NUM_SPECIALITEMS]-1);
			int old = specialItems[oldPos];
			specialItems[oldPos] = specialItems[newPos];
			specialItems[newPos] = old;
		}
		// for(int i=0; i<dat[NUM_TRASHITEMS]*4; ++i){
			// int oldPos = randomizerSeed->Rand(dat[NUM_TRASHITEMS]-1);
			// int newPos = randomizerSeed->Rand(dat[NUM_TRASHITEMS]-1);
			// int old = trashItems[oldPos];
			// trashItems[oldPos] = trashItems[newPos];
			// trashItems[newPos] = old;
		// }
	}
	int GetRandoItemFromPool(untyped dat, int pool){
		int triggerItems = dat[ARR_TRIGGERITEMLIST];
		int specialItems = dat[ARR_SPECIALITEMLIST];
		int trashItems = dat[ARR_TRASHITEMLIST];
		randgen randomizerSeed = <randgen>dat[RAND_RANDOMIZERSEED];
		
		int chosenItemIndex;
		int chosenItem;
		switch(pool){
			case IT_TRIGGER:
				chosenItemIndex = randomizerSeed->Rand(dat[NUM_TRIGGERITEMS]-1);
				chosenItem = triggerItems[chosenItemIndex];
				triggerItems[chosenItemIndex] = triggerItems[dat[NUM_TRIGGERITEMS]-1];
				--dat[NUM_TRIGGERITEMS];
				return chosenItem;
			case IT_SPECIAL:
				chosenItemIndex = randomizerSeed->Rand(dat[NUM_SPECIALITEMS]-1);
				chosenItem = specialItems[chosenItemIndex];
				specialItems[chosenItemIndex] = specialItems[dat[NUM_SPECIALITEMS]-1];
				--dat[NUM_SPECIALITEMS];
				return chosenItem;
			case IT_TRASH:
				chosenItemIndex = randomizerSeed->Rand(dat[NUM_TRASHITEMS]-1);
				chosenItem = trashItems[chosenItemIndex];
				trashItems[chosenItemIndex] = trashItems[dat[NUM_TRASHITEMS]-1];
				--dat[NUM_TRASHITEMS];
				return chosenItem;
		}
	}
	
	bool CanAccessRoom(untyped dat, int room){
		return CanAccessRoom(dat, room, true);
	}
	bool CanAccessRoom(untyped dat, int room, bool checkObtained){
		long roomFlags = dat[ARR_ROOMFLAGS];
		int itemPlaced = dat[ARR_ITEMPLACED];
		int reqFlags;
		if(checkObtained&&RandomizedItems[room])
			return false;
		if(roomFlags[room]==RFLAG_SPECIAL){
			switch(room){
				case IL_WAHI_CLOUDTRIGGER:
				case IL_WAYPOINTSECRET:
					if(G[G_KAYLANIINSEED]||G[G_SIYEDINSEED])
						return HasFlag(dat, RFLAG_KAYLANI);
					else
						return HasFlag(dat, RFLAG_LUNARANG);
					break;
				case IL_PALA_BARRELHOUSE:
					if(G[G_TORRININSEED]||G[G_TERRYINSEED])
						return HasFlag(dat, RFLAG_TELEKINESIS);
					else
						return HasFlag(dat, RFLAG_FIRE);
					break;
				case IL_SHOALS_BARRELCAVE:
					reqFlags = RFLAG_TIDALGAUNTLET;
					if(G[G_TORRININSEED]||G[G_TERRYINSEED])
						reqFlags |= RFLAG_TELEKINESIS;
					return HasFlag(dat, reqFlags);
					break;
				case IL_SP_CATACOMBS1:
					reqFlags = RFLAG_FIRE|RFLAG_BOMBPUZZLE|RFLAG_TIDALGAUNTLET|RFLAG_STELLARWAND;
					if(G[G_KAYLANIINSEED]||G[G_SIYEDINSEED])
						reqFlags |= RFLAG_KAYLANI;
					return HasFlag(dat, reqFlags);
					break;
				case IL_KAWAEHAE_BUSH:
					reqFlags = RFLAG_BOMB;
					if(G[G_KAYLANIINSEED]||G[G_SIYEDINSEED])
						reqFlags |= RFLAG_KAYLANI;
					return HasFlag(dat, reqFlags);
					break;
				case IL_SP_CATACOMBS2:
					reqFlags = RFLAG_BOMB|RFLAG_TIDALGAUNTLET|RFLAG_STELLARWAND;
					if(G[G_TORRININSEED]||G[G_TERRYINSEED])
						reqFlags |= RFLAG_TELEKINESIS;
					return HasFlag(dat, reqFlags);
					break;
				case IL_CATACOMBS_DIVESPOT:
					reqFlags = RFLAG_BOMB|RFLAG_STELLARWAND;
					if(G[G_TORRININSEED]||G[G_TERRYINSEED])
						reqFlags |= RFLAG_TELEKINESIS;
					return HasFlag(dat, reqFlags);
					break;
				case IL_BES_COSMICSPOOK:
					reqFlags = RFLAG_FINALDUNGEON;
					return HasFlag(dat, reqFlags);
					break;
				case IL_OBSERVATORY_ENTRANCE:
					reqFlags = RFLAG_FINALDUNGEON|RFLAG_TIDALGAUNTLET;
					return HasFlag(dat, reqFlags);
					break;
				case IL_OBSERVATORY_STARSTONE:
					reqFlags = RFLAG_FINALDUNGEON|RFLAG_BOMB|RFLAG_TIDALGAUNTLET|RFLAG_STELLARWAND;
					return HasFlag(dat, reqFlags);
					break;
				case IL_OBSERVATORY_COINPOT:
				case IL_OBSERVATORY_SWITCHROOM:
				case IL_OBSERVATORY_UNDERREDORB:
				case IL_BES_STELLARCURSTELLATION:
					reqFlags = RFLAG_FINALDUNGEON|RFLAG_BOMB|RFLAG_TIDALGAUNTLET|RFLAG_STELLARWAND;
					if(G[G_ASHERINSEED])
						return HasFlag(dat, reqFlags|RFLAG_STARSTONE);
					else if(G[G_SORENINSEED]||G[G_TERRYINSEED]){
						if(itemPlaced[I_SOREN]&&itemPlaced[I_ABILITY_C_SOREN]&&HasFlag(dat, reqFlags))
							return true;
						if(itemPlaced[I_TERRY]&&itemPlaced[I_ABILITY_C_TERRY]&&HasFlag(dat, reqFlags))
							return true;
					}
					break;
				case IL_OBSERVATORY_ORBBOMBWALL:
					reqFlags = RFLAG_FINALDUNGEON|RFLAG_BOMB|RFLAG_TIDALGAUNTLET|RFLAG_STELLARWAND;
					if(G[G_KAYLANIINSEED]||G[G_SIYEDINSEED])
						reqFlags |= RFLAG_KAYLANI;
					if(G[G_ASHERINSEED])
						return HasFlag(dat, reqFlags|RFLAG_STARSTONE);
					else if(G[G_SORENINSEED]||G[G_TERRYINSEED]){
						if(itemPlaced[I_SOREN]&&itemPlaced[I_ABILITY_C_SOREN]&&HasFlag(dat, reqFlags))
							return true;
						if(itemPlaced[I_TERRY]&&itemPlaced[I_ABILITY_C_TERRY]&&HasFlag(dat, reqFlags))
							return true;
					}
					break;
				case IL_OBSERVATORY_CUBBYHOLE:
				case IL_OBSERVATORY_STARWANDPUZZLE:
				case IL_BES_NIGHTMARESELET:
					reqFlags = RFLAG_FINALDUNGEON|RFLAG_BOMB|RFLAG_TIDALGAUNTLET|RFLAG_STELLARWAND;
					if(G[G_TORRININSEED]||G[G_TERRYINSEED])
						reqFlags |= RFLAG_TELEKINESIS;
					if(G[G_ASHERINSEED])
						return HasFlag(dat, reqFlags|RFLAG_STARSTONE);
					else if(G[G_SORENINSEED]||G[G_TERRYINSEED]){
						if(itemPlaced[I_SOREN]&&itemPlaced[I_ABILITY_C_SOREN]&&HasFlag(dat, reqFlags))
							return true;
						if(itemPlaced[I_TERRY]&&itemPlaced[I_ABILITY_C_TERRY]&&HasFlag(dat, reqFlags))
							return true;
					}
					break;
				case IL_POHO_ELEMENTPUZZLE:
					if(itemPlaced[I_WAND]){
						if(itemPlaced[I_TORRIN]&&itemPlaced[I_ABILITY_B_TORRIN]&&itemPlaced[I_LUNARANG])
							return true;
						if(itemPlaced[I_KAYLANI]&&itemPlaced[I_ABILITY_B_KAYLANI]&&itemPlaced[I_LUNARANG])
							return true;
						if(itemPlaced[I_TERRY]&&itemPlaced[I_ABILITY_B_TERRY]&&itemPlaced[I_LUNARANG])
							return true;
						if(itemPlaced[I_SIYED]&&itemPlaced[I_ABILITY_A_SIYED]&&itemPlaced[I_LUNARANG])
							return true;
					}
					break;
				case IL_TOTEM5_TORRINAUGMENTSLOT2:
					if(itemPlaced[I_TORRIN]&&itemPlaced[I_ABILITY_B_TORRIN]&&itemPlaced[I_AUGMENT_ALTBATTERYSOLAR]&&itemPlaced[I_AUGMENT_ALTBATTERYSTELLAR])
						return true;
					if(itemPlaced[I_KAYLANI]&&itemPlaced[I_ABILITY_B_KAYLANI])
						return true;
					if(itemPlaced[I_TERRY]&&itemPlaced[I_ABILITY_B_TERRY])
						return true;
					if(itemPlaced[I_WAND])
						return true;
					if(itemPlaced[I_LUNARANG])
						return true;
					break;
				case IL_TOTEM5_KAYLANIAUGMENTSLOT2:
					if(!G[G_KAYLANIINSEED]&&!G[G_TERRYINSEED]&&!G[G_SIYEDINSEED]){
						if(itemPlaced[I_TORRIN]&&itemPlaced[I_ABILITY_B_TORRIN]&&itemPlaced[I_AUGMENT_ALTBATTERYSOLAR])
							return true;
					}
					else{
						if(itemPlaced[I_KAYLANI]&&itemPlaced[I_ABILITY_B_KAYLANI]&&itemPlaced[I_SWORD_KAYLANI2])
							return true;
						if(itemPlaced[I_KAYLANI]&&itemPlaced[I_ABILITY_B_KAYLANI]&&itemPlaced[I_AUGMENT_MIRAGE])
							return true;
						if(itemPlaced[I_TERRY]&&itemPlaced[I_ABILITY_B_TERRY])
							return true;
						if(itemPlaced[I_SIYED]&&itemPlaced[I_ABILITY_A_SIYED]&&itemPlaced[I_ABILITY_B_SIYED])
							return true;
					}
					break;
			}
			return false;
		}
		else{
			return HasFlag(dat, roomFlags[room]);
		}
	}
	void FindAccessibleRooms(untyped dat){
		int roomList = dat[ARR_ROOMLIST];
		long roomFlags = dat[ARR_ROOMFLAGS];
		int accessibleRooms = dat[ARR_ACCESSIBLEROOMS];
		
		dat[NUM_ACCESSIBLEROOMS] = 0;
		for(int i=0; i<dat[NUM_ROOMS]; ++i){
			if(roomList[i]>-1){
				if(CanAccessRoom(dat, roomList[i])){
					int nextRoomidx = dat[NUM_ACCESSIBLEROOMS];
					accessibleRooms[nextRoomidx] = roomList[i];
					++dat[NUM_ACCESSIBLEROOMS];
				}	
			}
		}
		
		if(RANDOMIZER_DEBUG){
			printf("\n\nUpdating accessible rooms. Found rooms: %d\n", dat[NUM_ACCESSIBLEROOMS]);
			for(int i=0; i<dat[NUM_ACCESSIBLEROOMS]; ++i){
				int str[512];
				int nameStr[512];
				ItemLocationName(nameStr, accessibleRooms[i]);
				sprintf(str, "%s (%d)\n", nameStr, accessibleRooms[i]);
				printf(str);
			}
			printf("\n\n");
			Waitframe();
		}
	}
	
	bool GiveObservatoryFlag(untyped dat){
		int itemPlaced = dat[ARR_ITEMPLACED];
		if(G[G_RANDOMIZERMODE]==0){
			if(G[G_RANDOMIZEROBSERVATORYLOCK]==1){ //Characters
				int reqChars;
				int partyChars;
				if(G[G_ASHERINSEED])
					++reqChars;
				if(G[G_TORRININSEED])
					++reqChars;
				if(G[G_KAYLANIINSEED])
					++reqChars;
				if(G[G_SORENINSEED])
					++reqChars;
				if(G[G_TERRYINSEED])
					++reqChars;
				if(G[G_SIYEDINSEED])
					++reqChars;
				
				if(itemPlaced[I_ASHER])
					++partyChars;
				if(itemPlaced[I_TORRIN])
					++partyChars;
				if(itemPlaced[I_KAYLANI])
					++partyChars;
				if(itemPlaced[I_SOREN])
					++partyChars;
				if(itemPlaced[I_TERRY])
					++partyChars;
				if(itemPlaced[I_SIYED])
					++partyChars;
				
				if(partyChars>=reqChars)
					GiveFlag(dat, RFLAG_FINALDUNGEON);
			}
			if(G[G_RANDOMIZEROBSERVATORYLOCK]==2&&itemPlaced[I_HYMNSTONE]>=G[G_RANDOMIZERREQUIREDHYMNSTONES]) //Hymnstones
				GiveFlag(dat, RFLAG_FINALDUNGEON);
		}
	}
	void GiveItemFlags(untyped dat, int id){
		int itemPlaced = dat[ARR_ITEMPLACED];
		//Special Logic
		switch(id){
			//Having Asher and dash lets you dash
			case I_ASHER:
				GiveObservatoryFlag(dat);
			case I_ABILITY_A_ASHER:
				if(itemPlaced[I_ASHER]&&itemPlaced[I_ABILITY_A_ASHER]>=2){
					GiveFlag(dat, RFLAG_STARSTONE);
				}
				break;
			//Having torrin gives solar and lunar (with the augment
			case I_TORRIN:
				GiveObservatoryFlag(dat);
			case I_ABILITY_B_TORRIN:
				if(itemPlaced[I_TORRIN]&&itemPlaced[I_ABILITY_B_TORRIN]){
					GiveFlag(dat, RFLAG_SOLAR);
				}
				if(itemPlaced[I_TORRIN]&&itemPlaced[I_ABILITY_B_TORRIN]&&itemPlaced[I_AUGMENT_ALTBATTERYLUNAR]){
					GiveFlag(dat, RFLAG_LUNAR);
				}
				if(itemPlaced[I_TORRIN]&&itemPlaced[I_ABILITY_B_TORRIN]){
					GiveFlag(dat, RFLAG_TELEKINESIS);
				}
				break;
			//Having terry gives solar and lunar (with the augment)
			case I_TERRY:
				GiveObservatoryFlag(dat);
			case I_ABILITY_B_TERRY:
				if(itemPlaced[I_TERRY]&&itemPlaced[I_ABILITY_B_TERRY]){
					GiveFlag(dat, RFLAG_SOLAR);
				}
				if(itemPlaced[I_TERRY]&&itemPlaced[I_ABILITY_B_TERRY]&&itemPlaced[I_AUGMENT_ALTBATTERYLUNARTERRY]){
					GiveFlag(dat, RFLAG_LUNAR);
				}
				if(itemPlaced[I_TERRY]&&itemPlaced[I_ABILITY_B_TERRY]){
					GiveFlag(dat, RFLAG_TELEKINESIS);
				}
				break;
			//Soren's bombs can trigger most bomb spots
			case I_SOREN:
				GiveObservatoryFlag(dat);
				if(itemPlaced[I_SOREN]&&itemPlaced[I_ABILITY_B_SOREN]){
					GiveFlag(dat, RFLAG_BOMB);
				}
				break;
			//Kaylani can always use solar magic
			case I_KAYLANI:
				GiveObservatoryFlag(dat);
				if(itemPlaced[I_KAYLANI]){
					GiveFlag(dat, RFLAG_SOLAR);
				}
				GiveFlag(dat, RFLAG_KAYLANI);
				break;
			//Siyed can always use solar magic
			case I_SIYED:
				GiveObservatoryFlag(dat);
				if(itemPlaced[I_SIYED]){
					GiveFlag(dat, RFLAG_SOLAR);
				}
				GiveFlag(dat, RFLAG_KAYLANI);
				break;
			case I_HYMNSTONE:
				GiveObservatoryFlag(dat);
				break;
		}
	}
	bool PlaceItem(untyped dat, int id, int roomidx, int room){
		int roomList = dat[ARR_ROOMLIST];
		long roomFlags = dat[ARR_ROOMFLAGS];
		int accessibleRooms = dat[ARR_ACCESSIBLEROOMS];
		int locationOrder = dat[ARR_LOCATIONORDER];
		int itemPlaced = dat[ARR_ITEMPLACED];
		
		int itemList = dat[ARR_ITEMLIST]; //Do I actually need this for anything?
		long itemFlags = dat[ARR_ITEMFLAGS];
		
		if(RandomizedItems[room]>0){
			printf("ERROR: Tried to place an item in the same location twice!\n");
		}
		
		RandomizedItems[room] = id;
		locationOrder[dat[IDX_LOCORDER]] = room;
		++dat[IDX_LOCORDER];
		++itemPlaced[id];
		
		if(RANDOMIZER_DEBUG){
			int itemStr[512];
			int locStr[512];
			ItemName(itemStr, id);
			ItemLocationName(locStr, room);
			printf("%s (%d) - %s (%d) [%d] - %d placed\n", locStr, room, itemStr, id, RandomizedItems[room], itemPlaced[id]);
		}
		
		int oldFlags = dat[FLAGS_OBTAINED];
		
		if(itemFlags[id]==RFLAG_SPECIAL){
			GiveItemFlags(dat, id);
		}
		else if(itemFlags[id]>0){
			if((dat[FLAGS_OBTAINED]|itemFlags[id])!=dat[FLAGS_OBTAINED]){
				GiveFlag(dat, itemFlags[id]);
			}
		}
		
		if(oldFlags!=dat[FLAGS_OBTAINED]){
			FindAccessibleRooms(dat);
		}
		else{
			if(roomidx>-1){
				accessibleRooms[roomidx] = accessibleRooms[dat[NUM_ACCESSIBLEROOMS]-1];
				--dat[NUM_ACCESSIBLEROOMS];
			}
			else{
				//If no room index is given, we have to look for it in the array
				for(int i=0; i<dat[NUM_ACCESSIBLEROOMS]; ++i){
					if(accessibleRooms[i]==room){
						accessibleRooms[i] = accessibleRooms[dat[NUM_ACCESSIBLEROOMS]-1];
						--dat[NUM_ACCESSIBLEROOMS];
						break;
					}
				}
			}
		}
		
		++dat[NUM_PLACEDITEMS];
	}
	bool PlaceItem(untyped dat, int id){
		randgen randomizerSeed = <randgen>dat[RAND_RANDOMIZERSEED];
		int accessibleRooms = dat[ARR_ACCESSIBLEROOMS];
		
		if(dat[NUM_ACCESSIBLEROOMS]<=0){
			printf("ERROR: Out of valid locations to place items.\n");
			PrintInvalidLocations(dat);
			return false;
		}
		
		int roomidx = randomizerSeed->Rand(dat[NUM_ACCESSIBLEROOMS]-1);
		int room = accessibleRooms[roomidx];
		if(RANDOMIZER_DEBUG)
			printf("Placing %d (%d) [%d] / %d\n", roomidx, room, RandomizedItems[room], dat[NUM_ACCESSIBLEROOMS]);
		return PlaceItem(dat, id, roomidx, room);
	}
	
	bool GiveFlag(untyped dat, int flag){
		if(RANDOMIZER_DEBUG && (dat[FLAGS_OBTAINED] | flag) != dat[FLAGS_OBTAINED]){
			TraceFlagChange(dat[FLAGS_OBTAINED], flag);
		}
		dat[FLAGS_OBTAINED] |= flag;
	}
	bool HasFlag(untyped dat, int flag){
		return (dat[FLAGS_OBTAINED]&flag)==flag;
	}
	
	void ItemLocationName(int buf, int loc){
		switch(loc){
			case IL_PUNA_DIVE: CopyStringToBuffer(buf, "PUNA dive pond"); return;
			case IL_OMAKA_BURN: CopyStringToBuffer(buf, "OMAKA burnable tree cave"); return;
			case IL_OMAKA_CLIFF: CopyStringToBuffer(buf, "OMAKA seaside cliff"); return;
			case IL_OMAKA_TREE: CopyStringToBuffer(buf, "OMAKA seaside behind the tree"); return;
			case IL_OMAKA_ISLAND: CopyStringToBuffer(buf, "OMAKA enemies island"); return;
			case IL_OMAKA_THROUGHCAVE: CopyStringToBuffer(buf, "OMAKA bombable cave"); return;
			case IL_OMAKA_ILLUSORYTREE: CopyStringToBuffer(buf, "OMAKA illusory tree"); return;
			case IL_OMAKA_MANORSLOPE: CopyStringToBuffer(buf, "OMAKA slope by Selet manor"); return;
			case IL_TOTEM1_ASHERHEART1: 
			case IL_TOTEM1_TORRINHEART1:
			case IL_TOTEM1_KAYLANIHEART1: 
			case IL_TOTEM1_ASHERDASH:
			case IL_TOTEM1_SOLARSYSTEM: CopyStringToBuffer(buf, "OMAKA totem"); return;
			case IL_PALA_CHAPPINGTON: CopyStringToBuffer(buf, "PALA house with fireplace"); return;
			case IL_PALA_CONSTRUCTION: CopyStringToBuffer(buf, "PALA construction site"); return;
			case IL_PALA_SORENHOUSE: CopyStringToBuffer(buf, "PALA Soren's house"); return;
			case IL_PALA_BOXES: CopyStringToBuffer(buf, "PALA behind the crates"); return;
			case IL_PALA_BARRELHOUSE: CopyStringToBuffer(buf, "PALA barrel house"); return;
			case IL_PALA_DIVE: CopyStringToBuffer(buf, "PALA dive spot"); return;
			case IL_WAREHOUSE_BIGROOM: CopyStringToBuffer(buf, "WAREHOUSE big room"); return;
			case IL_WAREHOUSE_CANDLE: CopyStringToBuffer(buf, "WAREHOUSE lantern chest"); return;
			case IL_WAREHOUSE_UNDERARCH: CopyStringToBuffer(buf, "WAREHOUSE under archway"); return;
			case IL_WAREHOUSE_BOMBWALL: CopyStringToBuffer(buf, "WAREHOUSE bomb wall"); return;
			case IL_SHOP1_SILVERSWORD: 
			case IL_SHOP1_IRONSHIELD:
			case IL_SHOP1_STONETRAP:
			case IL_SHOP2_AUGCANDLE:
			case IL_SHOP2_AUGBOMBS:
			case IL_SHOP2_AUGGAUNTLET: CopyStringToBuffer(buf, "PALA shops"); return;
			case IL_SELET_STARWAND: CopyStringToBuffer(buf, "SELET MANOR star wand room"); return;
			case IL_SELET_KILLROOM: CopyStringToBuffer(buf, "SELET MANOR master bedroom"); return;
			case IL_SELET_DININGROOM: CopyStringToBuffer(buf, "SELET MANOR dining room"); return;
			case IL_SELET_TIMINGPUZZLE: CopyStringToBuffer(buf, "SELET MANOR timing puzzle"); return;
			case IL_CATACOMBS_STARBLOCKPUZZLE: CopyStringToBuffer(buf, "CATACOMBS star block puzzle"); return;
			case IL_CATACOMBS_DIVESPOT: CopyStringToBuffer(buf, "CATACOMBS dive spot"); return;
			case IL_CATACOMBS_LUNARTRIGGER: CopyStringToBuffer(buf, "CATACOMBS under the pot in the center"); return;
			case IL_KIKALA_BEHINDTREE: CopyStringToBuffer(buf, "KIKALA burn path behind a tree"); return;
			case IL_KIKALA_SOLARGOLEM: CopyStringToBuffer(buf, "KIKALA Solar Golem"); return;
			case IL_KIKALA_MAGNETISLAND: CopyStringToBuffer(buf, "KIKALA magnet island"); return;
			case IL_KIKALA_STARBLOCK: CopyStringToBuffer(buf, "KIKALA star block"); return;
			case IL_KAWAEHAE_DIVE: CopyStringToBuffer(buf, "KAWAEHAE dive spot"); return;
			case IL_KAWAEHAE_BUSH: CopyStringToBuffer(buf, "KAWAEHAE bush by the falls"); return;
			case IL_KAWAEHAE_STARBLOCK: CopyStringToBuffer(buf, "KAWAEHAE star block"); return;
			case IL_KAWAEHAE_STELLARGOLEM: CopyStringToBuffer(buf, "KAWAEHAE Stellar Golem"); return;
			case IL_KAWI_BURNCACTUS: CopyStringToBuffer(buf, "KAWI red cactus"); return;
			case IL_KAWI_BOMBCLIFF: CopyStringToBuffer(buf, "KAWI bombable cliff tunnel"); return;
			case IL_KAWI_DIVE: CopyStringToBuffer(buf, "KAWI oasis dive spot"); return;
			case IL_KAWI_BOMBCAVE: CopyStringToBuffer(buf, "KAWI northeast bomb cave"); return;
			case IL_KAWI_BOMBDUNE: CopyStringToBuffer(buf, "KAWI bombable dune"); return;
			case IL_KAWI_ISLAND: CopyStringToBuffer(buf, "KAWI enemy island"); return;
			case IL_KAWI_BEHINDTREE: CopyStringToBuffer(buf, "KAWI behind the trees"); return;
			case IL_TOTEM2_ASHERHEART2: 
			case IL_TOTEM2_TORRINHEART2:
			case IL_TOTEM2_KAYLANIHEART2:
			case IL_TOTEM2_BLACKBELT:
			case IL_TOTEM2_SUNDOG: CopyStringToBuffer(buf, "KAWI totem"); return;
			case IL_PIRATE_BOMBS: CopyStringToBuffer(buf, "PIRATE FORT bomb chest"); return;
			case IL_PIRATE_SWITCHKILLROOM: CopyStringToBuffer(buf, "PIRATE FORT killroom north of the switch"); return;
			case IL_PIRATE_BOMBPUZZLE: CopyStringToBuffer(buf, "PIRATE FORT simultaneous bomb switch"); return;
			case IL_PIRATE_GAUNTLETPUZZLE: CopyStringToBuffer(buf, "PIRATE FORT tidal gauntlet puzzle"); return;
			case IL_MALKA_UNDERHOUSE: CopyStringToBuffer(buf, "MALKA under the house"); return;
			case IL_MALKA_TAROFIELD: CopyStringToBuffer(buf, "MALKA behind Torrin's house"); return;
			case IL_SHOP3_AUGAUTOLOCK: 
			case IL_SHOP3_AUGREFLECT:
			case IL_SHOP3_AUGALTLUNAR: CopyStringToBuffer(buf, "MALKA shops"); return;
			case IL_SHOALS_BURNBUSH: CopyStringToBuffer(buf, "STARFALL SHOALS burnable bush cave"); return;
			case IL_SHOALS_DARKCAVE: CopyStringToBuffer(buf, "STARFALL SHOALS dark cave torches"); return;
			case IL_SHOALS_BARRELCAVE: CopyStringToBuffer(buf, "STARFALL SHOALS barrel cave"); return;
			case IL_SHOALS_MAGNETBUSH: CopyStringToBuffer(buf, "STARFALL SHOALS tidal gauntlet by the mines"); return;
			case IL_SHOALS_CUTSCENESCREEN: CopyStringToBuffer(buf, "STARFALL SHOALS mountaintop"); return;
			case IL_TOTEM3_ASHERAUGMENTSLOT1:
			case IL_TOTEM3_TORRINAUGMENTSLOT1:
			case IL_TOTEM3_KAYLANIAUGMENTSLOT1: 
			case IL_TOTEM3_DASHCOUNTER: 
			case IL_TOTEM3_SOLARMIGHT: CopyStringToBuffer(buf, "STARFALL SHOALS totem"); return;
			case IL_MINES_BEETLEGEM: CopyStringToBuffer(buf, "MINES 1F beetle gem room"); return;
			case IL_MINES_GAUNTLET: CopyStringToBuffer(buf, "MINES B1F tidal gauntlet chest"); return;
			case IL_MINES_GAUNTLETSPIKES: CopyStringToBuffer(buf, "MINES B1F gauntlet / spike navigation room"); return;
			case IL_MINES_TIMERPUZZLE: CopyStringToBuffer(buf, "MINES B2F timer puzzle"); return;
			case IL_MINES_GEMHOLE: CopyStringToBuffer(buf, "MINES B2F gem hole"); return;
			case IL_MINES_BEETLEPIT: CopyStringToBuffer(buf, "MINES B2F beetle pits room"); return;
			case IL_WAHI_LUNARTRIGGER: CopyStringToBuffer(buf, "WAHIOKALA JUNGLE lunar trigger"); return;
			case IL_WAHI_BURNTREE: CopyStringToBuffer(buf, "WAHIOKALA JUNGLE burn tree"); return;
			case IL_WAHI_CLOUDTRIGGER: CopyStringToBuffer(buf, "WAHIOKALA HILLSIDE trigger behind the clouds"); return;
			case IL_WAHI_BUSH: CopyStringToBuffer(buf, "WAHIOKALA HILLSIDE under the bush"); return;
			case IL_WAHI_FOOTHILLSLAVACAVE: CopyStringToBuffer(buf, "WAHIOKALA HILLSIDE bomb cave near Ali'i ascent"); return;
			case IL_WAHI_BURNSHRUB: CopyStringToBuffer(buf, "WAHIOKALA LAVAFLOWS burnable shrub cave"); return;
			case IL_WAHI_BEHINDTREE: CopyStringToBuffer(buf, "WAHIOKALA LAVAFLOWS cliff behind the tree"); return;
			case IL_WAHI_VALLEYKILLROOM: CopyStringToBuffer(buf, "WAHIOKALA LAVAFLOWS killroom by the lava river"); return;
			case IL_WAHI_LUNARGOLEM: CopyStringToBuffer(buf, "WAHIOKALA LAVAFLOWS Lunar Golem"); return;
			case IL_WAHI_HOKUCAVE: CopyStringToBuffer(buf, "WAHIOKALA LAVAFLOWS bomb wall on the path to Hoku"); return;
			case IL_WAHI_MONEYCAVE: CopyStringToBuffer(buf, "WAHIOKALA TEMPLE GROUNDS bombable money cave"); return;
			case IL_SHOP4_AUGSTELLARWAND:
			case IL_SHOP4_AUGSTELLARSWORD:
			case IL_SHOP4_AUGSAFECHARGE: CopyStringToBuffer(buf, "HOKU shop"); return;
			case IL_JUNGLECAVE_BOMBROCK: CopyStringToBuffer(buf, "JUNGLE CAVE bombable rock"); return;
			case IL_JUNGLETEMPLE_SOLARPILLAR: CopyStringToBuffer(buf, "JUNGLE TEMPLE solar pillar"); return;
			case IL_TOTEM4_ASHERHEART3:
			case IL_TOTEM4_TORRINHEART3:
			case IL_TOTEM4_KAYLANIHEART3:
			case IL_TOTEM4_STELLAIRE:
			case IL_TOTEM4_SOLARFLARE: CopyStringToBuffer(buf, "WAHIOKALA JUNGLE totem"); return;
			case IL_ALII_ENTRANCEBOMBWALL: CopyStringToBuffer(buf, "ALI'I ASCENT bomb wall by the entrance"); return;
			case IL_ALII_ENTRNACESPIKEBARRIER: CopyStringToBuffer(buf, "ALI'I ASCENT spike ledge by the entrance"); return;
			case IL_ALII_BEHINDTREE: CopyStringToBuffer(buf, "ALI'I ASCENT behind the tree on the side"); return;
			case IL_ALII_DIVECAVE: CopyStringToBuffer(buf, "ALI'I ASCENT dive spot bomb cave"); return;
			case IL_ALII_DROPINCAVE: CopyStringToBuffer(buf, "ALI'I ASCENT drop-in cave from the summit"); return;
			case IL_ALII_STELLARPILLAR: CopyStringToBuffer(buf, "ALI'I ASCENT stellar pillar"); return;
			case IL_OBSERVATORY_ENTRANCE: CopyStringToBuffer(buf, "OBSERVATORY 1F entrance room"); return;
			case IL_OBSERVATORY_STARSTONE: CopyStringToBuffer(buf, "OBSERVATORY 2F starstone chest"); return;
			case IL_OBSERVATORY_SWITCHROOM: CopyStringToBuffer(buf, "OBSERVATORY 2F behind the stairs in the room with switches"); return;
			case IL_OBSERVATORY_UNDERREDORB: CopyStringToBuffer(buf, "OBSERVATORY 3F walkway under the red orb"); return;
			case IL_OBSERVATORY_COINPOT: CopyStringToBuffer(buf, "OBSERVATORY 3F coin pot on the right end"); return;
			case IL_OBSERVATORY_ORBBOMBWALL: CopyStringToBuffer(buf, "OBSERVATORY 4F bomb wall side path"); return;
			case IL_OBSERVATORY_CUBBYHOLE: CopyStringToBuffer(buf, "OBSERVATORY 5F cubbyhole with shooting statues"); return;
			case IL_OBSERVATORY_STARWANDPUZZLE: CopyStringToBuffer(buf, "OBSERVATORY star wand puzzle"); return;
			case IL_KOHI_OVERHANG: CopyStringToBuffer(buf, "KOHI CANYON overhang by the dock point"); return;
			case IL_KOHI_DIVE: CopyStringToBuffer(buf, "KOHI CANYON purple tree dive puzzle"); return;
			case IL_KOHI_CAVE: CopyStringToBuffer(buf, "KOHI CANYON spikes in the cave"); return;
			case IL_KOHI_RUINS: CopyStringToBuffer(buf, "KOHI CANYON atop the ruins"); return;
			case IL_KOHI_STARWANDPUZZLE: CopyStringToBuffer(buf, "KOHI CANYON ruins star wand puzzle"); return;
			case IL_KOHI_RAVINE: CopyStringToBuffer(buf, "KOHI CANYON in the ravine"); return;
			case IL_KOHI_LAKE: CopyStringToBuffer(buf, "KOHI CANYON magnet gem by the foggy lake"); return;
			case IL_POHO_LUNARANG: CopyStringToBuffer(buf, "POHO TEMPLE 1F lunarang chest"); return;
			case IL_POHO_MISTPOT: CopyStringToBuffer(buf, "POHO TEMPLE B1F under a pot in the mists"); return;
			case IL_POHO_BOMBWALLSWITCH: CopyStringToBuffer(buf, "POHO TEMPLE switch puzzle behind a bomb wall"); return;
			case IL_POHO_ELEMENTPUZZLE: CopyStringToBuffer(buf, "POHO TEMPLE three element puzzle"); return;
			case IL_TULANE_SIDEPATH: CopyStringToBuffer(buf, "VILLA TULANE side path behind the trees"); return;
			case IL_TULANE_CAVE: CopyStringToBuffer(buf, "VILLA TULANE secret cave entrance"); return;
			case IL_TULANE_WATERSIDE: CopyStringToBuffer(buf, "VILLA TULANE behind a tree by the water"); return;
			case IL_LEIPAI_BEHINDTREE: CopyStringToBuffer(buf, "LEIPAI'S LOOKOUT behind a tree on the lone pillar"); return;
			case IL_LEIPAI_BRIDGE: CopyStringToBuffer(buf, "LEIPAI'S LOOKOUT across the rope bridge"); return;
			case IL_LEIPAI_COINS: CopyStringToBuffer(buf, "LEIPAI'S LOOKOUT coins on the ledge"); return;
			case IL_KUKULU_KILLROOM: CopyStringToBuffer(buf, "KUKULU CLIFFS killroom by the water"); return;
			case IL_KUKULU_SWITCHPUZZLE: CopyStringToBuffer(buf, "KUKULU CLIFFS multi switch puzzle"); return;
			case IL_CARN_BOMBROCK: CopyStringToBuffer(buf, "CARN RUINS entrance bomb rock"); return;
			case IL_CARN_BOMBGEMPUZZLE: CopyStringToBuffer(buf, "CARN RUINS lob bomb magnet gem puzzle"); return;
			case IL_CARN_BOMBWALL: CopyStringToBuffer(buf, "CARN RUINS bombable wall in the dark"); return;
			case IL_CARN_BLOCKGEMPUZZLE: CopyStringToBuffer(buf, "CARN RUINS star block magnet gem puzzle"); return;
			case IL_CARN_FUSIONGOLEM: CopyStringToBuffer(buf, "CARN RUINS Fusion Golem"); return;
			case IL_PIRATE2_COINCHEST: CopyStringToBuffer(buf, "KUKULU HIDEAWAY chest before the boss"); return;
			case IL_TOTEM5_ASHERAUGMENTSLOT2: CopyStringToBuffer(buf, "UNDERSEA PYRAMID bomb redirecting puzzle"); return;
			case IL_TOTEM5_TORRINAUGMENTSLOT2: CopyStringToBuffer(buf, "UNDERSEA PYRAMID battery puzzle"); return;
			case IL_TOTEM5_KAYLANIAUGMENTSLOT2: CopyStringToBuffer(buf, "UNDERSEA PYRAMID solar trigger puzzle"); return;
			case IL_TOMBOL: CopyStringToBuffer(buf, "TOMBOL REEF"); return;
			case IL_THREEBROTHERS: CopyStringToBuffer(buf, "THREE BROTHERS caves"); return;
			case IL_THREEBROTHERSCOINS: CopyStringToBuffer(buf, "THREE BROTHERS coins"); return;
			case IL_WAYPOINT: CopyStringToBuffer(buf, "WAYPOINT ISLE coins"); return;
			case IL_WAYPOINTSECRET: CopyStringToBuffer(buf, "WAYPOINT ISLE secret coins"); return;
			case IL_MIRAGE: CopyStringToBuffer(buf, "MIRAGE ISLE"); return;
			case IL_SP_WAREHOUSE1: 
			case IL_SP_WAREHOUSE2: CopyStringToBuffer(buf, "WAREHOUSE end"); return;
			case IL_SP_PIRATE1:
			case IL_SP_PIRATE2: CopyStringToBuffer(buf, "PIRATE FORT boss"); return;
			case IL_SP_MINES1: 
			case IL_SP_MINES2:
			case IL_SP_MINES3: CopyStringToBuffer(buf, "MINES B3F boss"); return;
			case IL_SP_MANOR: CopyStringToBuffer(buf, "SELET MANOR Asher's cell"); return;
			case IL_SP_CATACOMBS1: CopyStringToBuffer(buf, "CATACOMBS left switch"); return;
			case IL_SP_CATACOMBS2: CopyStringToBuffer(buf, "CATACOMBS right switch"); return;
			case IL_SP_POHO1: CopyStringToBuffer(buf, "POHO TEMPLE Tulane's cell"); return;
			case IL_SP_POHO2: CopyStringToBuffer(buf, "POHO TEMPLE Kenja's cell"); return;
			case IL_SP_POHO3: CopyStringToBuffer(buf, "POHO TEMPLE Skai's cell"); return;
			case IL_SP_POHO4: CopyStringToBuffer(buf, "POHO TEMPLE Allie and Band's cell"); return;
			case IL_SP_POHOBOSS1:
			case IL_SP_POHOBOSS2: CopyStringToBuffer(buf, "POHO TEMPLE boss"); return;
			case IL_SP_KAWAEHAE1:
			case IL_SP_KAWAEHAE2: CopyStringToBuffer(buf, "KAWAEHAE solar pillar"); return;
			case IL_SP_JUNGLEPLANT1: CopyStringToBuffer(buf, "WAHIOKALA TEMPLE GROUNDS jungle plant"); return;
			case IL_SP_JUNGLEPLANT2: CopyStringToBuffer(buf, "WAHIOKALA TEMPLE GROUNDS coins behind a tree by the jungle plant"); return;
			case IL_SP_KIKALA1:
			case IL_SP_KIKALA2: CopyStringToBuffer(buf, "KIKALA lunar pillar"); return;
			case IL_SP_TULANE1:
			case IL_SP_TULANE2: CopyStringToBuffer(buf, "VILLA TULANE end"); return;
			case IL_SP_SOLARGOLEM: CopyStringToBuffer(buf, "KIKALA Solar Golem"); return;
			case IL_SP_LUNARGOLEM: CopyStringToBuffer(buf, "WAHIOKALA LAVAFLOWS Lunar Golem"); return;
			case IL_SP_STELLARGOLEM: CopyStringToBuffer(buf, "KAWAEHAE Stellar Golem"); return;
			case IL_SP_FUSIONGOLEM1:
			case IL_SP_FUSIONGOLEM2:
			case IL_SP_FUSIONGOLEM3: CopyStringToBuffer(buf, "CARN RUINS Fusion Golem"); return;
			case IL_SP_PIRATEREMATCH1:
			case IL_SP_PIRATEREMATCH2: CopyStringToBuffer(buf, "KUKULU HIDEAWAY boss"); return;
			case IL_SP_NECKLACEROCK1:
			case IL_SP_NECKLACEROCK2: CopyStringToBuffer(buf, "WAHIOKALA LAVAFLOWS necklace rock"); return;
			case IL_SP_JUNGLETEMPLE1:
			case IL_SP_JUNGLETEMPLE2: CopyStringToBuffer(buf, "JUNGLE TEMPLE end"); return;
			case IL_SP_TELSPYRAMID1:
			case IL_SP_TELSPYRAMID2: CopyStringToBuffer(buf, "TEL'S PYRAMID cave"); return;
			case IL_SP_UNDERSEAPYRAMID1: 
			case IL_SP_UNDERSEAPYRAMID2: CopyStringToBuffer(buf, "UNDERSEA PYRAMID boss"); return;
			case IL_ZARATHLIFELESSON: CopyStringToBuffer(buf, "PALA Zarath item"); return;
			case IL_NIGHTMARESELET1:
			case IL_NIGHTMARESELET2:
			case IL_NIGHTMARESELET3:
			case IL_NIGHTMARESELET4: CopyStringToBuffer(buf, "OBSERVATORY Nightmare Selet"); return;
			
			case IL_THREEBROTHERSCOINSSECRET: CopyStringToBuffer(buf, "THREE BROTHERS secret coins"); return;
			case IL_SELET_COINS: CopyStringToBuffer(buf, "SELET MANOR coins"); return;
			
			case IL_BES_REDOCTO...IL_BES_NIGHTMARESELET: 
				int name[256];
				int enemyID = BestiaryEnemyID(loc-IL_BES_REDOCTO);
				BestiaryName(name, enemyID, false, false);
				sprintf(buf, "BESTIARY #%d %s", loc-IL_BES_REDOCTO, name);
				return;
			default:
				sprintf("UNKNOWN LOCATION %d\n", loc);
		}
	}
	void ItemLocationNameVague(int buf, int loc){
		switch(loc){
			case IL_PUNA_DIVE: CopyStringToBuffer(buf, "in Puna Village"); return;
			case IL_OMAKA_BURN: 
			case IL_OMAKA_CLIFF:
			case IL_OMAKA_TREE: 
			case IL_OMAKA_ISLAND: 
			case IL_OMAKA_THROUGHCAVE: 
			case IL_OMAKA_ILLUSORYTREE: 
			case IL_OMAKA_MANORSLOPE: CopyStringToBuffer(buf, "on Omaka"); return;
			case IL_TOTEM1_ASHERHEART1: 
			case IL_TOTEM1_TORRINHEART1:
			case IL_TOTEM1_KAYLANIHEART1: 
			case IL_TOTEM1_ASHERDASH:
			case IL_TOTEM1_SOLARSYSTEM: CopyStringToBuffer(buf, "within a totem on Omaka"); return;
			case IL_PALA_CHAPPINGTON: 
			case IL_PALA_CONSTRUCTION: 
			case IL_PALA_SORENHOUSE: 
			case IL_PALA_BOXES:
			case IL_PALA_BARRELHOUSE: 
			case IL_PALA_DIVE: CopyStringToBuffer(buf, "in Pala Bay"); return;
			case IL_WAREHOUSE_BIGROOM:
			case IL_WAREHOUSE_CANDLE:
			case IL_WAREHOUSE_UNDERARCH:
			case IL_WAREHOUSE_BOMBWALL: CopyStringToBuffer(buf, "in Selet's warehouse"); return;
			case IL_SHOP1_SILVERSWORD: 
			case IL_SHOP1_IRONSHIELD:
			case IL_SHOP1_STONETRAP:
			case IL_SHOP2_AUGCANDLE:
			case IL_SHOP2_AUGBOMBS:
			case IL_SHOP2_AUGGAUNTLET: CopyStringToBuffer(buf, "in a shop in Pala Bay"); return;
			case IL_SELET_STARWAND:
			case IL_SELET_KILLROOM: 
			case IL_SELET_DININGROOM: 
			case IL_SELET_TIMINGPUZZLE: CopyStringToBuffer(buf, "in Selet's manor"); return;
			case IL_CATACOMBS_STARBLOCKPUZZLE: 
			case IL_CATACOMBS_DIVESPOT:
			case IL_CATACOMBS_LUNARTRIGGER: CopyStringToBuffer(buf, "in the Pala Catacombs"); return;
			case IL_KIKALA_BEHINDTREE:
			case IL_KIKALA_SOLARGOLEM: 
			case IL_KIKALA_MAGNETISLAND:
			case IL_KIKALA_STARBLOCK: CopyStringToBuffer(buf, "on Kikala Hill"); return;
			case IL_KAWAEHAE_DIVE: 
			case IL_KAWAEHAE_BUSH: 
			case IL_KAWAEHAE_STARBLOCK: 
			case IL_KAWAEHAE_STELLARGOLEM: CopyStringToBuffer(buf, "in Kawaehae Cave"); return;
			case IL_KAWI_BURNCACTUS: 
			case IL_KAWI_BOMBCLIFF: 
			case IL_KAWI_DIVE: 
			case IL_KAWI_BOMBCAVE: 
			case IL_KAWI_BOMBDUNE: 
			case IL_KAWI_ISLAND: 
			case IL_KAWI_BEHINDTREE: CopyStringToBuffer(buf, "in Kawi Canyon"); return;
			case IL_TOTEM2_ASHERHEART2: 
			case IL_TOTEM2_TORRINHEART2:
			case IL_TOTEM2_KAYLANIHEART2:
			case IL_TOTEM2_BLACKBELT:
			case IL_TOTEM2_SUNDOG: CopyStringToBuffer(buf, "within a totem on Kawi"); return;
			case IL_PIRATE_BOMBS: 
			case IL_PIRATE_SWITCHKILLROOM: 
			case IL_PIRATE_BOMBPUZZLE: 
			case IL_PIRATE_GAUNTLETPUZZLE: CopyStringToBuffer(buf, "in a pirate stronghold"); return;
			case IL_MALKA_UNDERHOUSE: 
			case IL_MALKA_TAROFIELD: CopyStringToBuffer(buf, "in Malka Village"); return;
			case IL_SHOP3_AUGAUTOLOCK: 
			case IL_SHOP3_AUGREFLECT:
			case IL_SHOP3_AUGALTLUNAR: CopyStringToBuffer(buf, "in a shop on Malka"); return;
			case IL_SHOALS_BURNBUSH: 
			case IL_SHOALS_DARKCAVE: 
			case IL_SHOALS_BARRELCAVE:
			case IL_SHOALS_MAGNETBUSH: 
			case IL_SHOALS_CUTSCENESCREEN: CopyStringToBuffer(buf, "at the Starfall Shoals"); return;
			case IL_TOTEM3_ASHERAUGMENTSLOT1:
			case IL_TOTEM3_TORRINAUGMENTSLOT1:
			case IL_TOTEM3_KAYLANIAUGMENTSLOT1: 
			case IL_TOTEM3_DASHCOUNTER: 
			case IL_TOTEM3_SOLARMIGHT: CopyStringToBuffer(buf, "within a totem at the Starfall Shoals"); return;
			case IL_MINES_BEETLEGEM: 
			case IL_MINES_GAUNTLET: 
			case IL_MINES_GAUNTLETSPIKES: 
			case IL_MINES_TIMERPUZZLE: 
			case IL_MINES_GEMHOLE: 
			case IL_MINES_BEETLEPIT: CopyStringToBuffer(buf, "in Selet's mining base"); return;
			case IL_WAHI_LUNARTRIGGER: 
			case IL_WAHI_BURNTREE: 
			case IL_WAHI_CLOUDTRIGGER: CopyStringToBuffer(buf, "in the jungles of Wahiokala"); return;
			case IL_WAHI_BUSH: 
			case IL_WAHI_FOOTHILLSLAVACAVE: CopyStringToBuffer(buf, "at the base of Mauna Ali'i"); return;
			case IL_WAHI_BURNSHRUB: 
			case IL_WAHI_BEHINDTREE: 
			case IL_WAHI_VALLEYKILLROOM: 
			case IL_WAHI_LUNARGOLEM: 
			case IL_WAHI_HOKUCAVE: CopyStringToBuffer(buf, "in the lava flows of Wahiokala"); return;
			case IL_WAHI_MONEYCAVE: CopyStringToBuffer(buf, "in the jungles of Wahiokala"); return;
			case IL_SHOP4_AUGSTELLARWAND:
			case IL_SHOP4_AUGSTELLARSWORD:
			case IL_SHOP4_AUGSAFECHARGE: CopyStringToBuffer(buf, "in a shop in Hoku Village"); return;
			case IL_JUNGLECAVE_BOMBROCK: CopyStringToBuffer(buf, "in the Overgrown Passage"); return;
			case IL_JUNGLETEMPLE_SOLARPILLAR: CopyStringToBuffer(buf, "in the Jungle Temple"); return;
			case IL_TOTEM4_ASHERHEART3:
			case IL_TOTEM4_TORRINHEART3:
			case IL_TOTEM4_KAYLANIHEART3:
			case IL_TOTEM4_STELLAIRE:
			case IL_TOTEM4_SOLARFLARE: CopyStringToBuffer(buf, "within a totem in the Wahiokala jungles"); return;
			case IL_ALII_ENTRANCEBOMBWALL: 
			case IL_ALII_ENTRNACESPIKEBARRIER:
			case IL_ALII_BEHINDTREE: 
			case IL_ALII_DIVECAVE: 
			case IL_ALII_DROPINCAVE: 
			case IL_ALII_STELLARPILLAR: CopyStringToBuffer(buf, "on Mauna Ali'i"); return;
			case IL_OBSERVATORY_ENTRANCE:
			case IL_OBSERVATORY_STARSTONE: 
			case IL_OBSERVATORY_SWITCHROOM: 
			case IL_OBSERVATORY_UNDERREDORB: 
			case IL_OBSERVATORY_COINPOT:
			case IL_OBSERVATORY_ORBBOMBWALL: 
			case IL_OBSERVATORY_CUBBYHOLE: 
			case IL_OBSERVATORY_STARWANDPUZZLE: CopyStringToBuffer(buf, "in the Ancient Observatory"); return;
			case IL_KOHI_OVERHANG: 
			case IL_KOHI_DIVE: 
			case IL_KOHI_CAVE: 
			case IL_KOHI_RUINS: 
			case IL_KOHI_STARWANDPUZZLE: 
			case IL_KOHI_RAVINE: 
			case IL_KOHI_LAKE: CopyStringToBuffer(buf, "in Kohi Canyon"); return;
			case IL_POHO_LUNARANG: 
			case IL_POHO_MISTPOT: 
			case IL_POHO_BOMBWALLSWITCH: 
			case IL_POHO_ELEMENTPUZZLE: CopyStringToBuffer(buf, "in the Poho Temple"); return;
			case IL_TULANE_SIDEPATH: 
			case IL_TULANE_CAVE: 
			case IL_TULANE_WATERSIDE: CopyStringToBuffer(buf, "in a wealthy woman's villa"); return;
			case IL_LEIPAI_BEHINDTREE: 
			case IL_LEIPAI_BRIDGE: 
			case IL_LEIPAI_COINS: CopyStringToBuffer(buf, "on Leipai's Lookout"); return;
			case IL_KUKULU_KILLROOM: 
			case IL_KUKULU_SWITCHPUZZLE: CopyStringToBuffer(buf, "at Kukulu Cliffs"); return;
			case IL_CARN_BOMBROCK: 
			case IL_CARN_BOMBGEMPUZZLE: 
			case IL_CARN_BOMBWALL: 
			case IL_CARN_BLOCKGEMPUZZLE: 
			case IL_CARN_FUSIONGOLEM: CopyStringToBuffer(buf, "in Carn Ruins"); return;
			case IL_PIRATE2_COINCHEST: CopyStringToBuffer(buf, "in a slightly haunted hideout"); return;
			case IL_TOTEM5_ASHERAUGMENTSLOT2: 
			case IL_TOTEM5_TORRINAUGMENTSLOT2: 
			case IL_TOTEM5_KAYLANIAUGMENTSLOT2: CopyStringToBuffer(buf, "in the Undersea Pyramid"); return;
			case IL_TOMBOL: CopyStringToBuffer(buf, "at Tombol Reef"); return;
			case IL_THREEBROTHERS: 
			case IL_THREEBROTHERSCOINS: CopyStringToBuffer(buf, "at the Three Brothers Rock"); return;
			case IL_WAYPOINT: 
			case IL_WAYPOINTSECRET: CopyStringToBuffer(buf, "on Waypoint Isle"); return;
			case IL_MIRAGE: CopyStringToBuffer(buf, "on Mirage Isle"); return;
			case IL_SP_WAREHOUSE1: 
			case IL_SP_WAREHOUSE2: CopyStringToBuffer(buf, "in Selet's warehouse"); return;
			case IL_SP_PIRATE1:
			case IL_SP_PIRATE2: CopyStringToBuffer(buf, "held by a powerful foe"); return;
			case IL_SP_MINES1: 
			case IL_SP_MINES2:
			case IL_SP_MINES3: CopyStringToBuffer(buf, "held by a powerful foe"); return;
			case IL_SP_MANOR: CopyStringToBuffer(buf, "in Selet's manor"); return;
			case IL_SP_CATACOMBS1: 
			case IL_SP_CATACOMBS2: CopyStringToBuffer(buf, "in the Pala Catacombs"); return;
			case IL_SP_POHO1: 
			case IL_SP_POHO2: 
			case IL_SP_POHO3: 
			case IL_SP_POHO4: CopyStringToBuffer(buf, "in the Poho Temple"); return;
			case IL_SP_POHOBOSS1:
			case IL_SP_POHOBOSS2: CopyStringToBuffer(buf, "held by a powerful foe"); return;
			case IL_SP_KAWAEHAE1:
			case IL_SP_KAWAEHAE2: CopyStringToBuffer(buf, "in Kawaehae Cave"); return;
			case IL_SP_JUNGLEPLANT1: 
			case IL_SP_JUNGLEPLANT2: CopyStringToBuffer(buf, "in the jungles of Wahiokala"); return;
			case IL_SP_KIKALA1:
			case IL_SP_KIKALA2: CopyStringToBuffer(buf, "on Kikala Hill"); return;
			case IL_SP_TULANE1:
			case IL_SP_TULANE2: CopyStringToBuffer(buf, "in a wealthy woman's villa"); return;
			case IL_SP_SOLARGOLEM: CopyStringToBuffer(buf, "held by a powerful foe"); return;
			case IL_SP_LUNARGOLEM: CopyStringToBuffer(buf, "held by a powerful foe"); return;
			case IL_SP_STELLARGOLEM: CopyStringToBuffer(buf, "held by a powerful foe"); return;
			case IL_SP_FUSIONGOLEM1:
			case IL_SP_FUSIONGOLEM2:
			case IL_SP_FUSIONGOLEM3: CopyStringToBuffer(buf, "held by a powerful foe"); return;
			case IL_SP_PIRATEREMATCH1:
			case IL_SP_PIRATEREMATCH2: CopyStringToBuffer(buf, "held by a powerful foe"); return;
			case IL_SP_NECKLACEROCK1:
			case IL_SP_NECKLACEROCK2: CopyStringToBuffer(buf, "in the lava flows of Wahiokala"); return;
			case IL_SP_JUNGLETEMPLE1:
			case IL_SP_JUNGLETEMPLE2: CopyStringToBuffer(buf, "in the Jungle Temple"); return;
			case IL_SP_TELSPYRAMID1:
			case IL_SP_TELSPYRAMID2: CopyStringToBuffer(buf, "on Tel's Pyramid"); return;
			case IL_SP_UNDERSEAPYRAMID1: 
			case IL_SP_UNDERSEAPYRAMID2: CopyStringToBuffer(buf, "in the Undersea Pyramid"); return;
			case IL_ZARATHLIFELESSON: CopyStringToBuffer(buf, "in the possession of a suspicious merchant"); return;
			case IL_NIGHTMARESELET1:
			case IL_NIGHTMARESELET2:
			case IL_NIGHTMARESELET3:
			case IL_NIGHTMARESELET4: CopyStringToBuffer(buf, "in the clutches of the cosmic eagle"); return;
			
			case IL_BES_REDOCTO...IL_BES_NIGHTMARESELET: 
				int name[256];
				int enemyID = BestiaryEnemyID(loc-IL_BES_REDOCTO);
				switch(enemyID){
					case 236: //Nightmare Selet
						CopyStringToBuffer(buf, "in the clutches of the cosmic eagle"); return;
					case 218: //Shelrond
					case 216: //Diggernaut
					case 217: //Selet
					case 235:
					case 242: //Esan
					case 213: //Golems
					case 214:
					case 215:
					case 244:
						CopyStringToBuffer(buf, "held by a powerful foe"); return;
				}
				CopyStringToBuffer(buf, "held by an enemy"); return;
				return;
			default:
				sprintf("outside the reaches of time and space. It might be time to contact Moosh. D:", loc);
		}
	}
	
	void WriteSpoilerLog(untyped dat, long seed){
		int fname[] = "xxxxxx - SPOILER.txt";
		for(int i=0; i<6; ++i){
			int digit = (seed>>(i*4))&0xFL;
			digit /= 1L;
			if(digit>9)
				fname[5-i] = 'A'+(digit-10);
			else
				fname[5-i] = '0'+digit;
		}
		int fpath[256];
		sprintf(fpath, "%s\\%s", "spoiler_logs", fname);
		file spoilerLog;
		spoilerLog->Create(fpath);
		spoilerLog->Own();
		int locationOrder = dat[ARR_LOCATIONORDER];
		int headerBuf[512];
		sprintf(headerBuf, "Total Item Locations: %d / %d\n\n", dat[NUM_ROOMS], IL_COUNT);
		spoilerLog->WriteString(headerBuf);
		for(int i=0; i<dat[NUM_ROOMS]; ++i){
			int j = locationOrder[i];
			int lineBuf[512];
			int areaBuf[512];
			ItemLocationName(areaBuf, j);
			int itemBuf[512];
			ItemName(itemBuf, RandomizedItems[j]>0?RandomizedItems[j]:255);
			if(G[G_MULTIPLAYERACTIVE]==2){
				int username[33];
				ZLink::GetUsername(username, MultiworldData[MD_STARTSPLITS+j]);
				sprintf(lineBuf, "[%s] %s - %s\n", username, areaBuf, itemBuf);
			}
			else
				sprintf(lineBuf, "%s - %s\n", areaBuf, itemBuf);
			spoilerLog->WriteString(lineBuf);
		}
		spoilerLog->Flush();
	}
	
	void PrintInvalidLocations(untyped dat){
		int roomList = dat[ARR_ROOMLIST];
		int roomFlags = dat[ARR_ROOMFLAGS];
		int accessibleRooms = dat[ARR_ACCESSIBLEROOMS];
		printf("\nFlags: %X\nInvalid Locations:\n\n", dat[FLAGS_OBTAINED]);
		for(int i=0; i<dat[NUM_ROOMS]; ++i){
			if(RandomizedItems[roomList[i]]==0){
				int locName[512];
				ItemLocationName(locName, roomList[i]);
				int req = roomFlags[roomList[i]];
				printf("%s (%X / %X)\n", locName, dat[FLAGS_OBTAINED]&req, req);
			}
		}
		printf("\n\n");
	}
	
	void TraceFlagChange(int flags, int newFlags){
		printf("dat[FLAGS_OBTAINED] Updated: %X | %X = %X\n", flags, newFlags, flags|newFlags);
	}
}

const int I_BESTIARYENTRY = 14;
itemsprite SpawnRandomizerItem(int loc, int itemid, int x, int y){
	itemid = ProcessRandomizerItem(loc, itemid);
	if(itemid>1000){
		int bestiaryID = itemid-1000;
		item itm = CreateItemAt(I_BESTIARYENTRY, x, y);
		itm->Pickup |= IP_DUMMY;
		itm->Script = Game->GetItemSpriteScript("BestiaryEntry");
		itm->InitD[0] = bestiaryID;
		itm->InitD[1] = loc;
		return itm;
	}
	item itm = CreateItemAt(itemid, x, y);
	itm->Script = Game->GetItemSpriteScript("RandomizerItem");
	itm->InitD[0] = loc;
	itm->Pickup |= IP_DUMMY;
	return itm;
}

int ProcessRandomizerItem(int loc, int itemid){
	printf("This Item: %d This User: %d\n", MultiworldData[MD_STARTSPLITS+loc], ZLink::ThisUserID());
	if(G[G_MULTIPLAYERACTIVE]==2&&MultiworldData[MD_STARTSPLITS+loc]!=ZLink::ThisUserID()){
		itemid = 1;
	}
	return itemid;
}

int GetRandomOutfitShopItem(int currentIndex, int arrays, int arrayMax, int order, int startingType){
	for(int i=0; i<7; ++i){
		int type = order[startingType];
		int arr = arrays[type];
		int max = arrayMax[type];
		if(currentIndex[type]<max){
			int ret = arr[currentIndex[type]]+1000*(type+1);
			++currentIndex[type];
			return ret;
		}
		
		++startingType;
		startingType %= 7;
	}
	return 0;
}
void GenerateOutfitShopItems(){
	int tops[] = {
		TOP_NOTHING,
		TOP_HOKUF,
		TOP_MALKAVEST,
		TOP_CHESTWRAP,
		TOP_BASICSHIRT,
		TOP_WELLINGTON, 
		TOP_TULANE,
		TOP_CULTIST,
		TOP_ARMOR,
		TOP_HOODIE1,
		TOP_ZARATH,
		TOP_TATTOOS,
		TOP_JACKET,
		TOP_CAPTAINVEST
	};
	int numTops = SizeOfArray(tops);
	
	int bottoms[] = {
		BOTTOM_HOKU,
		BOTTOM_HOKUF,
		BOTTOM_MALKA,
		BOTTOM_SKIRT,
		BOTTOM_PALA,
		BOTTOM_WELLINGTON,
		BOTTOM_CULTIST,
		BOTTOM_ARMOR
	};
	int numBottoms = SizeOfArray(bottoms);
	
	int accessories[] = {
		ACCESSORY_NONE,
		ACCESSORY_TOPHAT,
		ACCESSORY_HATSTACK,
		ACCESSORY_BONNET,
		ACCESSORY_MOUSTACHE,
		ACCESSORY_GLASSES,
		ACCESSORY_EYEPATCH,
		ACCESSORY_BANDANA,
		ACCESSORY_CAPTAINSHAT,
		ACCESSORY_CULTISTHOOD,
		ACCESSORY_GOLEMHEAD,
		ACCESSORY_NIGHTMAREMASK,
		ACCESSORY_NIGHTMAREEYE,
		ACCESSORY_CIRCLET,
		ACCESSORY_HOODIE,
		ACCESSORY_HALO,
		ACCESSORY_BLINDFOLD,
		ACCESSORY_BRACELETS,
		ACCESSORY_HEADBAND,
		ACCESSORY_CROWN,
		ACCESSORY_GOGGLES,
		ACCESSORY_STETSON,
		ACCESSORY_HIBISCUS,
		ACCESSORY_CAP,
		ACCESSORY_SOLARMASK,
		ACCESSORY_LUNARMASK,
		ACCESSORY_STELLARMASK,
		ACCESSORY_TURBAN,
		ACCESSORY_TRUFNECKLACE,
		ACCESSORY_WARRIORNECKLACE,
		ACCESSORY_WARRIORHELMET,
		ACCESSORY_SKULLMASK,
		ACCESSORY_EISENFAUST
	};
	int numAccessories = SizeOfArray(accessories);
	
	int colors[] = {
		OCLR_RED,
		OCLR_CRIMSON,
		OCLR_PALEPINK,
		OCLR_ORANGE,
		OCLR_GOLDENYELLOW,
		OCLR_YELLOW,
		OCLR_GREEN,
		OCLR_PALEGREEN,
		OCLR_DULLGREEN,
		OCLR_FORESTGREEN,
		OCLR_BLUE,
		OCLR_SKYBLUE,
		OCLR_DEEPBLUE, 
		OCLR_DENIMBLUE,
		OCLR_PERIWINKLE, 
		OCLR_PALEPERIWINKLE,
		OCLR_PURPLE,
		OCLR_PALEPURPLE,
		OCLR_MALKAPURPLE,
		OCLR_MUDBROWN,
		OCLR_WHITE,
		OCLR_LIGHTGREY,
		OCLR_DARKGREY,
		OCLR_LIGHTBLACK,
		OCLR_DARKBLACK,
		OCLR_NIGREDO
	};
	int numColors = SizeOfArray(colors);
	
	Shuffle(tops);
	Shuffle(bottoms);
	Shuffle(accessories);
	Shuffle(colors);
	
	for(int i=0; i<numTops; ++i){
		if(GetOutfitPiece(OTYPE_TOP, tops[i])){
			tops[i] = tops[numTops-1];
			--numTops;
			--i;
		}
	}
	for(int i=0; i<numBottoms; ++i){
		if(GetOutfitPiece(OTYPE_BOTTOM, bottoms[i])){
			bottoms[i] = bottoms[numBottoms-1];
			--numBottoms;
			--i;
		}
	}
	for(int i=0; i<numAccessories; ++i){
		if(GetOutfitPiece(OTYPE_ACCESSORY, accessories[i])){
			accessories[i] = accessories[numAccessories-1];
			--numAccessories;
			--i;
		}
	}
	for(int i=0; i<numColors; ++i){
		if(GetOutfitPiece(OTYPE_COLOR, colors[i])){
			colors[i] = colors[numColors-1];
			--numColors;
			--i;
		}
	}
	
	int currentIndex[] = {0, 0, 0, 0};
	int arrays[] = {tops, bottoms, accessories, colors};
	int arrayMax[] = {numTops, numBottoms, numAccessories, numColors};
	int order[] = {0, 1, 0, 2, 0, 1, 3};
	
	G[G_OUTFITSHOP5] = GetRandomOutfitShopItem(currentIndex, arrays, arrayMax, order, 6);
	G[G_OUTFITSHOP4] = GetRandomOutfitShopItem(currentIndex, arrays, arrayMax, order, 6);
	G[G_OUTFITSHOP3] = GetRandomOutfitShopItem(currentIndex, arrays, arrayMax, order, 3);
	G[G_OUTFITSHOP2] = GetRandomOutfitShopItem(currentIndex, arrays, arrayMax, order, Choose(0, 1));
	G[G_OUTFITSHOP1] = GetRandomOutfitShopItem(currentIndex, arrays, arrayMax, order, Choose(0, 1));
}