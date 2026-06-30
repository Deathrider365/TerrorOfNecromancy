combodata script Bouncepad{
	void run(){
		int element = this->Attribytes[0];
		int active = this->Attribytes[1];
		int flags = 1<<element;
		while(true){
			int levelFlags = CrystalSwitch[CRSW_LSTATES+Game->GetCurLevel()];
			if(!(levelFlags&flags)){
				if(active)
					++Screen->ComboD[this->Pos];
			}
			else{
				if(!active){
					--Screen->ComboD[this->Pos];
				}
				else if(Distance(Link->X, Link->Y, this->X, this->Y-4)<8&&Link->Z==0&&CanAttack()){
					int linkX = Link->X;
					int linkY = Link->Y;
					int frontPos = ComboAt(Link->X+8+DirX(Link->Dir, 16), Link->Y+8+DirY(Link->Dir, 16));
					int dir = Link->Dir;
					if(IsSwitchBlock(frontPos)&&Screen->ComboS[frontPos]==1111b){
						while(Distance(linkX, linkY, this->X, this->Y-4)>2){
							int angle = Angle(linkX, linkY, this->X, this->Y-4);
							linkX += VectorX(2, angle);
							linkY += VectorY(2, angle);
							Link->X = linkX;
							Link->Y = linkY;
							Waitframe();
						}
						Link->X = this->X;
						Link->Y = this->Y-4;
						Game->PlaySound(SFX_JUMP);
						Link->Jump = FindJumpLength(32, true);
						linkX = Link->X;
						linkY = Link->Y;
						int tX = this->X+DirX(dir, 16);
						int tY = this->Y-4+DirY(dir, 16);
						while(Distance(linkX, linkY, tX, tY)>0.5){
							int angle = Angle(linkX, linkY, tX, tY);
							linkX += VectorX(0.5, angle);
							linkY += VectorY(0.5, angle);
							Link->X = linkX;
							Link->Y = linkY;
							Waitframe();
						}
						Link->X = tX;
						Link->Y = tY;
						CrystalSwitch[CRSW_LINKONRAISED] = 1;
					}
				}
			}
			Waitframe();
		}
	}
	bool IsSwitchBlock(int pos){
		int cd = Screen->ComboD[pos];
		switch(cd){
			case 38560:
			case 38568:
				return true;
		}
		return false;
	}
}

combodata script GauntletproofSpike{
	void run(){
		mapdata l1 = Game->LoadTempScreen(1);
		int cmb = l1->ComboD[this->Pos()];
		int cs = l1->ComboC[this->Pos()];
		while(true){
			eweapon hitbox = MakeHitbox(EW_PHYSICAL, this->X, this->Y, 16, 16, GetDamageComboDamage(cmb));
			hitbox->Misc[EWM_FLAGS] |= EWMF_NOCOUNTER;
			hitbox->Z = Link->Z;
			Screen->FastCombo(2, this->X, this->Y, cmb, cs, 128);
			Waitframe();
		}
	}
}

combodata script Barrel{
	void run(){
		mapdata thislayer = Game->LoadTempScreen(this->Layer());
		while(thislayer->ComboF[this->Pos]==0){
			Waitframe();
		}
		int pos = this->Pos;
		if(pos%16>0&&pos%16<15&&pos>15&&pos<160){
			lweapon l = FireLWeapon(LW_SCRIPT10, 120, 80, 0, 0, 0, 0, 0);
			l->DrawYOffset = -1000;
			int dir = AngleDir4(Angle(Link->X, Link->Y, this->X, this->Y));
			if(thislayer->ComboF[this->Pos]==CF_BARRELFLAGTERRY)
				RunLWeaponScript(l, "TelekinesisTerry", {-thislayer->ComboD[this->Pos], 300, thislayer->ComboC[this->Pos], this->PosX(), this->PosY(), dir});
			else
				RunLWeaponScript(l, "Telekinesis", {-thislayer->ComboD[this->Pos], 300, thislayer->ComboC[this->Pos], this->PosX(), this->PosY()});
			l->CollDetection = false;
			thislayer->ComboD[this->Pos] = 0;
			Quit();
		}
	}
}

combodata script OverUnderDoor{
	void run(int state){
		while(true){
			if(state==0){
				if(G[G_OVERUNDERLAYER]==1)
					++Screen->ComboD[this->Pos];
			}
			if(state==1){
				if(G[G_OVERUNDERLAYER]==0)
					--Screen->ComboD[this->Pos];
			}
			Waitframe();
		}
	}
}

combodata script SensitiveStepNext{
	void run(){
		int offset = this->Attributes[0];
		while(true){
			if(RectCollision(this->X, this->Y, this->X+15, this->Y+15, Link->X, Link->Y+8, Link->X+15, Link->Y+15)&&Link->Z==0&&Link->MoveFlags[HEROMV_CAN_PITFALL]){
				Screen->ComboD[this->Pos] += offset;
				Quit();
			}
			Waitframe();
		}
	}
}

combodata script LessDumbCycle{
	void run(){
		int sfx = this->Attribytes[0];
		int noSecret = this->Attribytes[1];
		int delay = this->Attrishorts[0];
		int offset = this->Attributes[0];
		mapdata lyr = Game->LoadTempScreen(this->Layer);
		for(int i = 0; i<delay; i++){
			if(lyr->ComboF[this->Pos] == 99){
				Screen->FastTile(this->Layer, this->PosX(), this->PosY(), this->Tile+20, this->CSet, OP_OPAQUE);
			}
			Waitframe();
		}
		
		if(noSecret&&(Screen->State[ST_SECRET]||Screen->SecretsTriggered()))
			Quit();
		else{
			if(sfx>0)
				Game->PlaySound(sfx);
			lyr->ComboD[this->Pos] += offset;
		}
	}
}

combodata script ScriptWeaponTrigger{
	bool CanTrigger(lweapon l, int wType, int specialType){
		bool collision = l->CollDetection;
		int damage = l->Damage;
		if(specialType==1){ //Trigger
			switch(l->Type){
				case LW_SWORD:
				case LW_PHYSICAL:
				case LW_BOMBBLAST:
				case LW_LUNARANG:
				case LW_MAGNETGEM:
				case LW_STARWANDIMPACT:
					return true;
			}
			switch(l->Weapon){
				case LW_SWORD:
				case LW_PHYSICAL:
				case LW_BOMBBLAST:
				case LW_LUNARANG:
				case LW_MAGNETGEM:
				case LW_STARWANDIMPACT:
					return true;
			}
		}
		else if(specialType==2){ //Star Wand Exception
			if(l->Damage!=1) //Only detect the center of the star wand hitbox
				return false;
			else
				collision = true;
		}
		else if(specialType==3){ //Star Wand Block Exception
			if(l->Damage==DAMAGE_STARWAND_BLOCK)
				collision = true;
			else
				return false;
		}
		return (l->Type==wType||l->Weapon==wType)&&collision&&damage>0;
	}
	void run(){
		mapdata lyr = Game->LoadTempScreen(this->Layer);
		if(Screen->State[ST_SECRET]){
			if(lyr->ComboF[this->Pos]>=16&&lyr->ComboF[this->Pos]<=31)
				Quit();
			else
				++lyr->ComboD[this->Pos];
			Quit();
		}
		if(lyr->ComboF[this->Pos]>=16&&lyr->ComboF[this->Pos]<=31)
			lyr->ComboF[this->Pos] = 0;
		int sfxTrigger = this->Attribytes[0];
		int sfxSolve = this->Attribytes[1];
		int wType = this->Attribytes[2];
		int perm = this->Attribytes[3];
		int flag = this->Attribytes[4]; //Unused?
		int specialType = this->Attribytes[5];
		bool triggered;
		while(!triggered){
			for(int i=Screen->NumLWeapons(); i>0; --i){
				lweapon l = Screen->LoadLWeapon(i);
				if(CanTrigger(l, wType, specialType)&&RectCollision(l, this->X, this->Y, 16, 16)){
					l->Misc[LWM_FLAGS] |= LWMF_DEFLECT;
					triggered = true;
					Game->PlaySound(sfxTrigger);
					break;
				}
			}
			Waitframe();
		}
		int count;
		if(specialType == 4){ //Hardcoded Russ exception! Woot woot!
			for(int i=0; i<176; ++i){
				if(lyr->ComboD[i]==lyr->ComboD[this->Pos] || lyr->ComboD[i]== 30108 || lyr->ComboD[i]== 30110 || lyr->ComboD[i]==30112)
					++count;
			}
		}
		else{
			for(int i=0; i<176; ++i){
				if(lyr->ComboD[i]==lyr->ComboD[this->Pos])
					++count;
			}
		}
		if(count==1){
			Game->PlaySound(sfxSolve);
			if(perm)
				Screen->State[ST_SECRET] = true;
			Screen->TriggerSecrets();
		}
		++lyr->ComboD[this->Pos];
	}
}

const int SPR_KNOCKBACKSHOT = 101;

combodata script PushbackStatue{
	void run(){
		int dir = this->Attribytes[0];
		int element = this->Attribytes[1];
		int delay = this->Attribytes[2];
		if(delay==0)
			delay = 8;
		while(true){
			int h = G[G_L3HOURS];
			int m = G[G_L3MINUTES];
			int s = G[G_L3SECONDS];
			bool canFire;
			if(element==0&&DayNight_GetTimeDifference(h, m, s, 12, 0, 0)<=21600)
				canFire = true;
			else if(element==1&&DayNight_GetTimeDifference(h, m, s, 0, 0, 0)<=21600)
				canFire = true;
			if(canFire){
				eweapon e = FireEWeapon(element==0?EW_SOLAR:EW_LUNAR, this->X, this->Y, DegtoRad(DirAngle(dir)), 400, 2, SPR_KNOCKBACKSHOT, SFX_FIREBALL, EWF_UNBLOCKABLE);
				e->Rotation = DirAngle(dir);
				if(element==1){
					++e->Tile;
					e->CSet = 7;
				}
				RunEWeaponScript(e, "KnockbackShot", {8});
			}
			Waitframes(delay);
		}
	}
}

combodata script CharSwapBlock{
	void run(){
		while(true){
			if(G[G_RANDOMIZERENABLED]){
				if(CharsDead()){
					Screen->FastCombo(2, this->X, this->Y, 38523, 10, 128);
					if(Abs(this->X-Link->X)<8&&Abs(this->Y-Link->Y)<8){
						int prevChar = GetCharID();
						int newChar = NextDeadChar(prevChar);
						
						if(newChar!=prevChar){
							Game->PlaySound(86);
							
							eweapon e = CreateEWeaponAt(EW_SCRIPT10, 120, 80);
							e->CollDetection = false;
							e->DrawYOffset = -1000;
							
							switch(newChar){
								case CHAR_ASHER:
									G[G_ASHERHP] = Link->HP;
									break;
								case CHAR_TORRIN:
									G[G_TORRINHP] = Link->HP;
									break;
								case CHAR_KAYLANI:
									G[G_KAYLANIHP] = Link->HP;
									break;
								case CHAR_SOREN:
									G[G_SORENHP] = Link->HP;
									break;
								case CHAR_TERRY:
									G[G_TERRYHP] = Link->HP;
									break;
								case CHAR_SIYED:
									G[G_SIYEDHP] = Link->HP;
									break;
							}
							RunEWeaponScript(e, "CharacterChange", {newChar, 0});
							while(GetCharID()!=newChar){
								Screen->FastCombo(2, this->X, this->Y, 38519, 10, 128);
								NoMenu();
								NoAction();
								Waitframe();
							}
							switch(prevChar){
								case CHAR_ASHER:
									G[G_ASHERHP] = 0;
									break;
								case CHAR_TORRIN:
									G[G_TORRINHP] = 0;
									break;
								case CHAR_KAYLANI:
									G[G_KAYLANIHP] = 0;
									break;
								case CHAR_SOREN:
									G[G_SORENHP] = 0;
									break;
								case CHAR_TERRY:
									G[G_TERRYHP] = 0;
									break;
								case CHAR_SIYED:
									G[G_SIYEDHP] = 0;
									break;
							}
							while(Abs(this->X-Link->X)<8&&Abs(this->Y-Link->Y)<8){
								Screen->FastCombo(2, this->X, this->Y, 38519, 10, 128);
								Waitframe();
							}
						}
					}
				}
			}
			else{
				if(G[G_ASHERHP]<=0||G[G_TORRINHP]<=0||G[G_KAYLANIHP]<=0){
					Screen->FastCombo(2, this->X, this->Y, 38523, 10, 128);
					if(Abs(this->X-Link->X)<8&&Abs(this->Y-Link->Y)<8){
						int prevChar = GetCharID();
						int newChar = prevChar;
						switch(newChar){
							case CHAR_ASHER:
								if(G[G_TORRINHP]<=0)
									newChar = CHAR_TORRIN;
								else if(G[G_KAYLANIHP]<=0)
									newChar = CHAR_KAYLANI;
								break;
							case CHAR_TORRIN:
								if(G[G_KAYLANIHP]<=0)
									newChar = CHAR_KAYLANI;
								else if(G[G_ASHERHP]<=0)
									newChar = CHAR_ASHER;
								break;
							case CHAR_KAYLANI:
								if(G[G_ASHERHP]<=0)
									newChar = CHAR_ASHER;
								else if(G[G_TORRINHP]<=0)
									newChar = CHAR_TORRIN;
								break;
						}
						if(newChar!=prevChar){
							Game->PlaySound(86);
							
							eweapon e = CreateEWeaponAt(EW_SCRIPT10, 120, 80);
							e->CollDetection = false;
							e->DrawYOffset = -1000;
							
							switch(newChar){
								case CHAR_ASHER:
									G[G_ASHERHP] = Link->HP;
									break;
								case CHAR_TORRIN:
									G[G_TORRINHP] = Link->HP;
									break;
								case CHAR_KAYLANI:
									G[G_KAYLANIHP] = Link->HP;
									break;
							}
							RunEWeaponScript(e, "CharacterChange", {newChar, 0});
							while(GetCharID()!=newChar){
								Screen->FastCombo(2, this->X, this->Y, 38519, 10, 128);
								NoMenu();
								NoAction();
								Waitframe();
							}
							switch(prevChar){
								case CHAR_ASHER:
									G[G_ASHERHP] = 0;
									break;
								case CHAR_TORRIN:
									G[G_TORRINHP] = 0;
									break;
								case CHAR_KAYLANI:
									G[G_KAYLANIHP] = 0;
									break;
							}
							while(Abs(this->X-Link->X)<8&&Abs(this->Y-Link->Y)<8){
								Screen->FastCombo(2, this->X, this->Y, 38519, 10, 128);
								Waitframe();
							}
						}
					}
				}
				if(Game->GetCurDMap() == 73){
					if(G[G_SORENHP]<=0||G[G_TERRYHP]<=0||G[G_SIYEDHP]<=0){
						Screen->FastCombo(2, this->X, this->Y, 38523, 10, 128);
						if(Abs(this->X-Link->X)<8&&Abs(this->Y-Link->Y)<8){
							int prevChar = GetCharID();
							int newChar = prevChar;
							switch(newChar){
								case CHAR_SOREN:
									if(G[G_TERRYHP]<=0)
										newChar = CHAR_TERRY;
									else if(G[G_SIYEDHP]<=0)
										newChar = CHAR_SIYED;
									break;
								case CHAR_TERRY:
									if(G[G_SIYEDHP]<=0)
										newChar = CHAR_SIYED;
									else if(G[G_SORENHP]<=0)
										newChar = CHAR_SOREN;
									break;
								case CHAR_SIYED:
									if(G[G_SORENHP]<=0)
										newChar = CHAR_SOREN;
									else if(G[G_TERRYHP]<=0)
										newChar = CHAR_TERRY;
									break;
							}
							if(newChar!=prevChar){
								Game->PlaySound(86);
								
								eweapon e = CreateEWeaponAt(EW_SCRIPT10, 120, 80);
								e->CollDetection = false;
								e->DrawYOffset = -1000;
								
								switch(newChar){
									case CHAR_SOREN:
										G[G_SORENHP] = Link->HP;
										break;
									case CHAR_TERRY:
										G[G_TERRYHP] = Link->HP;
										break;
									case CHAR_SIYED:
										G[G_SIYEDHP] = Link->HP;
										break;
								}
								RunEWeaponScript(e, "CharacterChange", {newChar, 0});
								while(GetCharID()!=newChar){
									Screen->FastCombo(2, this->X, this->Y, 38519, 10, 128);
									NoMenu();
									NoAction();
									Waitframe();
								}
								switch(prevChar){
									case CHAR_SOREN:
										G[G_SORENHP] = 0;
										break;
									case CHAR_TERRY:
										G[G_TERRYHP] = 0;
										break;
									case CHAR_SIYED:
										G[G_SIYEDHP] = 0;
										break;
								}
								while(Abs(this->X-Link->X)<8&&Abs(this->Y-Link->Y)<8){
									Screen->FastCombo(2, this->X, this->Y, 38519, 10, 128);
									Waitframe();
								}
							}
						}
					}
				}
			}
			Waitframe();
		}
	}
	bool CharsDead(){
		for(int i=0; i<6; ++i){
			if(CharAlive(i)==1)
				return true;
		}
	}
	int CharAlive(int charID){ //Returns 2 if alive, 1 if dead, 0 if not in party
		switch(charID){
			case CHAR_ASHER: 
				if(Link->Item[I_ASHER]){
					if(G[G_ASHERHP]>0)
						return 2;
					return 1;
				}
				return 0;
			case CHAR_TORRIN: 
				if(Link->Item[I_TORRIN]){
					if(G[G_TORRINHP]>0)
						return 2;
					return 1;
				}
				return 0;
			case CHAR_KAYLANI: 
				if(Link->Item[I_KAYLANI]){
					if(G[G_KAYLANIHP]>0)
						return 2;
					return 1;
				}
				return 0;
			case CHAR_SOREN: 
				if(Link->Item[I_SOREN]){
					if(G[G_SORENHP]>0)
						return 2;
					return 1;
				}
				return 0;
			case CHAR_TERRY: 
				if(Link->Item[I_TERRY]){
					if(G[G_TERRYHP]>0)
						return 2;
					return 1;
				}
				return 0;
			case CHAR_SIYED:
				if(Link->Item[I_SIYED]){
					if(G[G_SIYEDHP]>0)
						return 2;
					return 1;
				}
				return 0;
		}
	}
	int NextChar(int charID){
		switch(charID){
			case CHAR_ASHER: return CHAR_TORRIN;
			case CHAR_TORRIN: return CHAR_KAYLANI;
			case CHAR_KAYLANI: return CHAR_SOREN;
			case CHAR_SOREN: return CHAR_TERRY;
			case CHAR_TERRY: return CHAR_SIYED;
			case CHAR_SIYED: return CHAR_ASHER;
		}
	}
	int NextDeadChar(int charID){
		for(int i=0; i<6; ++i){
			charID = NextChar(charID);
			if(CharAlive(charID)==1)
				break;
		}
		return charID;
	}
}

combodata script Torch{
	void run(){
		while(true){
			DarkRoom_AddLight(this->X+8, this->Y+8, 0, this->Attribytes[0], 1, 0, 0, 0);
			//DarkRoom_AddLight(this->X+8, this->Y+8, 1, this->Attribytes[0]*4, 0.6, Angle(this->X, this->Y, Link->X, Link->Y), 0.01, 64);
			Waitframe();
		}
	}
}

combodata script DoorwayLightStrip{
	void run(){
		int Orig = this->Tile;
		
		while(true){
			TraceToScreen(0, Orig);
			if(Game->DMapPalette[Game->GetCurDMap()] == 0x11A || Game->DMapPalette[Game->GetCurDMap()] == 0x11B){
				this->OriginalTile = 20;
				this->Tile = 20;
			}
			else{
				this->OriginalTile = Orig;
				this->Tile = Orig;
			}
			Waitframe();
		}
	}
}

combodata script TimedShooter{
	void run(){
		int damage = this->Attribytes[0];
		int wt = this->Attribytes[1];
		int sprite = this->Attribytes[2];
		int sfx = this->Attribytes[3];
		int delay = this->Attributes[0];
		int startdelay = this->Attributes[1];
		int step = this->Attributes[2];
		if(startdelay){
			for(int i=0; i<startdelay; ++i){
				while(Link->Action==LA_HOLD1LAND||Link->Action==LA_HOLD2LAND)
					Waitframe();
				Waitframe();
			}
			Waitframes(startdelay);
		}
		while(true){
			for(int i=0; i<delay; ++i){
				while(Link->Action==LA_HOLD1LAND||Link->Action==LA_HOLD2LAND)
					Waitframe();
				Waitframe();
			}
			eweapon e = FireAimedEWeapon(wt, this->X, this->Y, 0, step, damage, sprite, sfx, 128);
		}
	}
}

combodata script GolemSwitch{
	void run(int flag){
		mapdata l1 = Game->LoadTempScreen(1);
		if(G[G_GOLEMFLAG] & flag){
			l1->ComboD[this->Pos]++;
			Quit();
		}
		while(true){
			if(Distance(Link->X, Link->Y, this->X, this->Y) <= 4){
				G[G_GOLEMFLAG] |= flag;
				Game->PlaySound(68);
				l1->ComboD[this->Pos]++;
				Quit();
			}
			Waitframe();
		}
	}
}

combodata script RupeeBushC{
    #option BINARY_32BIT on
    void run(int spawnItem){
        int anim;
        int d = Floor(this->Pos/32);
        int dbit = 1b<<(this->Pos%32);
        if(Screen->D[d]&dbit){
            Quit();
        }
        
        printf("Combo %d Item %d\n", this->Pos, spawnItem);
        
        if(spawnItem){
            item itm = CreateItemAt(spawnItem, this->X, this->Y);
            while(itm->isValid()){
                Waitframe();
            }
            Screen->D[d] |= dbit;
        }
        else{
            int anim;
            while(true){
                anim = (anim+1)%360;
                if(anim%24==(this->Pos+7)%24){
                    ParticleAnim(this->X+Rand(-8, 8), this->Y+Rand(-8, 8), 968, 8, 8, 5);
                }
                Waitframe();
            }
        }
    }
}

combodata script DerFlipFlopSwitch{
	void run(){
		mapdata lyr = Game->LoadTempScreen(this->Layer);
		mapdata lyr1 = Game->LoadTempScreen(1);
		int Raised = this->Attributes[0];
		int Lowered = this->Attributes[1];
		while(true){
			if(Distance(Link->X, Link->Y, this->PosX(), this->PosY()) <= 4){
				Game->PlaySound(68);
				lyr1->ComboD[this->Pos] = lyr->ComboD[this->Pos]+1;
				lyr1->ComboC[this->Pos] = lyr->ComboC[this->Pos];
				for(int i = 0; i<176; i++){
					if(lyr->ComboD[i] == Raised)
						lyr->ComboD[i] = Lowered;
					else if(lyr->ComboD[i] == Lowered)
						lyr->ComboD[i] = Raised;
				}
				while(Distance(Link->X, Link->Y, this->PosX(), this->PosY()) <= 4){
					Waitframe();
				}
				Game->PlaySound(68);
				lyr1->ComboD[this->Pos] = 0;
				for(int i = 0; i<176; i++){
					if(lyr->ComboD[i] == Raised)
						lyr->ComboD[i] = Lowered;
					else if(lyr->ComboD[i] == Lowered)
						lyr->ComboD[i] = Raised;
				}
			}
			Waitframe();
		}
	}
}

combodata script MultiStepSwitch{
	void run(){
		
		int sfxTrigger = this->Attribytes[0];
		int sfxSolve = this->Attribytes[1];
		int perm = this->Attribytes[2];
		int potStyle = this->Attribytes[3];
		int potFlag;
		switch(potStyle){
			case 1:	potFlag = 103; break;
		}
		
		mapdata lyr = Game->LoadTempScreen(this->Layer);
		if(potFlag&&lyr->ComboF[this->Pos]==potFlag){
			Game->PlaySound(150);
			
			lweapon effect = CreateLWeaponAt(LW_SPARKLE, this->X, this->Y);
			effect->DrawXOffset = -8;
			effect->DrawYOffset = -8;
			effect->Extend = 3;
			effect->TileWidth = 2;
			effect->TileHeight = 2;
			effect->UseSprite(119);
			effect->CollDetection = false;
		}
		if(Screen->State[ST_SECRET]){
			++lyr->ComboD[this->Pos];
			Quit();
		}
		while(true){
			if(Distance(Link->X, Link->Y, this->PosX(), this->PosY()) <= 4){
				Game->PlaySound(sfxTrigger);
				int count;
				for(int i=0; i<176; ++i){
					if(lyr->ComboD[i]==lyr->ComboD[this->Pos] || lyr->ComboD[i]== 28872)
						++count;
				}
				if(count==1){
					Game->PlaySound(sfxSolve);
					if(perm)
						Screen->State[ST_SECRET] = true;
					Screen->TriggerSecrets();
				}
				++lyr->ComboD[this->Pos];
			}
			Waitframe();
		}
	}
}

combodata script EyeSearcher{
	void run(){
		if(this->Layer>0)
			Quit();
		int oData = Floor(this->ID/4)*4;
		int state = this->ID%4;
		int delay = 120;
		int beamW;
		mapdata l1 = Game->LoadTempScreen(1);
		l1->ComboD[this->Pos] = oData+state;
		l1->ComboC[this->Pos] = Screen->ComboC[this->Pos];
		int dir = this->Attribytes[0];
		int noOpen = this->Attribytes[1];
		while(true){
			bool noticed;
			if(G[G_STEALTHSPOTTED]){
				int originalState = state;
				if(state==4)
					state = 2;
				if(state==5)
					state = 1;
				while(state>0){
					--state;
					int tempState = state;
					if(tempState==4)
						tempState = 2;
					if(tempState==5)
						tempState = 1;
					l1->ComboD[this->Pos] = oData+tempState;
					Waitframes(8);
				}
				int shotDelay = 90;
				while(G[G_STEALTHSPOTTED]){
					if(shotDelay>0){
						if(shotDelay<16)
							Screen->Circle(4, this->X+8, this->Y+8, 4+Rand(4), Choose(0x86, 0x87, 0x88), 1, 0, 0, 0, true, 128);
						--shotDelay;
					}
					else{
						shotDelay = 90+Rand(16);
						eweapon e = FireEWeapon(EW_SOLAR, this->X, this->Y, DegtoRad(Angle(this->X, this->Y, Link->X, Link->Y)), 400, 4, SPR_LIGHTSHOT, 32, EWF_UNBLOCKABLE);
						e->Rotation = RadtoDeg(e->Angle);
					}
					Waitframe();
				}
				int targetState = originalState;
				if(targetState==4)
					targetState = 2;
				if(targetState==5)
					targetState = 1;
				while(state<targetState){
					++state;
					int tempState = state;
					if(tempState==4)
						tempState = 2;
					if(tempState==5)
						tempState = 1;
					l1->ComboD[this->Pos] = oData+tempState;
					Waitframes(8);
				}
				state = originalState;
			}
			else{
				if(delay){
					if(!noOpen)
						--delay;
				}
				else{
					++state;
					if(state>=6)
						state = 0;
					delay = 8;
					if(state==0||state==3)
						delay = 120;
				}
				int tempState = state;
				if(tempState==4)
					tempState = 2;
				if(tempState==5)
					tempState = 1;
				l1->ComboD[this->Pos] = oData+tempState;
				if(state==0){
					if(beamW<1)
						beamW += 0.05;
				}
				else if(state==3){
					if(beamW>0)
						beamW -= 0.05;
				}
				if(beamW>0){
					noticed = DrawLightRay(this->X+8, this->Y+8, DirAngle(dir), 80, 16, 25*beamW, 8, 0x01);
					if(noticed){
						Game->PlaySound(SFX_ALERT);
						G[G_STEALTHSPOTTED] = 1;
					}
				}
			}
			Waitframe();
		}
	}
}

combodata script StealthTrigger{
	void run(int sfx){
		bool frame1 = true;
		while(!G[G_STEALTHSPOTTED]){
			Waitframe();
			frame1 = false;
		}
		if(!frame1)
			Game->PlaySound(sfx);
		++Screen->ComboD[this->Pos];
	}
}

combodata script BounceLily{
	bool BL_isSolid(int x, int y, bool jumpOver){
		mapdata l1 = Game->LoadTempScreen(1);
		mapdata l2 = Game->LoadTempScreen(2);
		int pos = ComboAt(x, y);
		bool jumpable;
		switch(l2->ComboD[pos]){
			case 7503:
			case 7507:
			case 7518:
				jumpable = true;
				break;
		}
		if(Screen->isSolid(x, y)){
			if(jumpOver&&jumpable)//l1->ComboT[pos]==CT_WATER)
				return false;
			return true;
		}
		return false;
	}
	bool BL_CanWalk(int x, int y, int dir, int step, bool full_tile, bool jumpOver){
		int c=8;
		int xx = x+15;
		int yy = y+15;
		if(full_tile) c=0;
		switch(DirNormal(dir))
		{
			case DIR_UP: return !(BL_isSolid(x,y+c-step,jumpOver)||BL_isSolid(x+8,y+c-step,jumpOver)||BL_isSolid(xx,y+c-step,jumpOver));
			case DIR_DOWN: return !(BL_isSolid(x,yy+step,jumpOver)||BL_isSolid(x+8,yy+step,jumpOver)||BL_isSolid(xx,yy+step,jumpOver));
			case DIR_LEFT: return !(BL_isSolid(x-step,y+c,jumpOver)||BL_isSolid(x-step,y+c+7,jumpOver)||BL_isSolid(x-step,yy,jumpOver));
			case DIR_RIGHT: return !(BL_isSolid(xx+step,y+c,jumpOver)||BL_isSolid(xx+step,y+c+7,jumpOver)||BL_isSolid(xx+step,yy,jumpOver));
			default: return false;
		}
	}
	bool BL_CanPlace(int x, int y, int w, int h, bool jumpOver){
		for(int xx=x; xx<=x+w-1; xx=Min(xx+8, x+w-1)){
			for(int yy=y; y<=y+h-1; yy=Min(yy+8, y+h-1)){
				if(BL_isSolid(xx, yy, jumpOver)){
					return false;
				}
				if(yy==y+h-1)
					break;
			}
			if(xx==x+w-1)
				break;
		}
		return true;
	}
	void run(){
		mapdata l1 = Game->LoadTempScreen(1);
		mapdata l2 = Game->LoadTempScreen(2);
		int delay = this->Attrishorts[0];
		int offset = this->Attributes[0];
		while(true){
			if(ComboAt(Link->X+8, Link->Y+12)==this->Pos&&Link->Jump==0&&Link->Z==0){
				int x = Link->X;
				int y = Link->Y;
				while(x!=this->X||y!=this->Y-4){
					if(Distance(x, y, this->X, this->Y-4)>1){
						int angle = Angle(x, y, this->X, this->Y-4);
						x += VectorX(1, angle);
						y += VectorY(1, angle);
					}
					else{
						x = this->X;
						y = this->Y-4;
					}
					Waitdraw();
					
					Link->X = x;
					Link->Y = y;
					Waitframe();
				}
				for(int i=0; i<16; ++i){
					int j = Floor(Lerp(0, 2, i/15));
					
					Screen->FastCombo(2, this->X, this->Y, Screen->ComboD[this->Pos], Screen->ComboC[this->Pos], 128);
					Screen->FastCombo(2, this->X, this->Y, l1->ComboD[this->Pos], l1->ComboC[this->Pos], 128);
					Screen->FastCombo(2, this->X, this->Y+j, l2->ComboD[this->Pos], l2->ComboC[this->Pos], 128);
					Waitdraw();
					
					Link->X = x;
					Link->Y = y;
					
					Waitframe();
				}
				Game->PlaySound(55);
				for(int i=0; i<8; ++i){
					int j = Floor(Lerp(2, -4, i/7));
					if(j<0)
						Link->Z = -j;
					Link->Jump = 0;
					
					Screen->FastCombo(2, this->X, this->Y, Screen->ComboD[this->Pos], Screen->ComboC[this->Pos], 128);
					Screen->FastCombo(2, this->X, this->Y, l1->ComboD[this->Pos], l1->ComboC[this->Pos], 128);
					Screen->FastCombo(2, this->X, this->Y+j, l2->ComboD[this->Pos], l2->ComboC[this->Pos], 128);
					Waitdraw();
					
					Link->X = x;
					Link->Y = y;
					
					G[G_NOACTION] = 1;
					Waitframe();
				}
				Game->PlaySound(SFX_JUMP);
				Link->Jump = 2.4;
				int jumpLen = FindJumpLength(2.4, false);
				int i = 0;
				bool jumpOver = true;
				if(!BL_CanPlace(this->X+DirX(Link->Dir, 32), this->Y+DirY(Link->Dir, 32), 16, 16, false)){
					jumpLen *= 2;
					jumpOver = false;
				}
				while(Link->Jump>0||Link->Z>4){
					if(i<8)
						++i;
					int j = Floor(Lerp(-4, 0, i/7));
					if(BL_CanWalk(x, y, Link->Dir, 1, false, (i<jumpLen/2)&&jumpOver)){
						x += DirX(Link->Dir, 32/jumpLen);
						y += DirY(Link->Dir, 32/jumpLen);
					}
					
					Screen->FastCombo(2, this->X, this->Y, Screen->ComboD[this->Pos], Screen->ComboC[this->Pos], 128);
					Screen->FastCombo(2, this->X, this->Y, l1->ComboD[this->Pos], l1->ComboC[this->Pos], 128);
					Screen->FastCombo(2, this->X, this->Y+j, l2->ComboD[this->Pos], l2->ComboC[this->Pos], 128);
					Waitdraw();
					
					Link->X = x;
					Link->Y = y;
					
					G[G_NOACTION] = 1;
					Waitframe();
				}
				Link->X = GridX(Link->X+8);
				Link->Y = GridY(Link->Y+12)-4;
				while(Link->Z>4){
					G[G_NOACTION] = 1;
					Waitframe();
				}
			}
			
			if(delay){
				--delay;
				if(!delay){
					l2->ComboD[this->Pos] += offset;
				}
			}
			Waitframe();
		}
	}
}

//Dummy combodata script for things that check if a combo has a script
combodata script WowItsNothing{
	void run(){
		while(true){
			Waitframe();
		}
	}
}

const bool SLOPE_FIX_MISALIGNS = true; //Setting for correcting SCREEN CRIMES if you're having slopes cross a screen border

//InitD[0] - Horizontal steepness of the slope. If it's a left facing slope, this number is negative
//InitD[1] - Vertical steepness of the slope
combodata script Slope{
	bool SlopeCanPlaceLink(int linkX, int linkY){
		for(int i=0; i<4; ++i){
			int x = linkX+(i%2)*15;
			int y = linkY+8+Floor(i/2)*7;
			if(x<0||x>255||y<0||y>175)
				return false;
			if(Screen->isSolid(x, y))
				return false;
		}
		return true;
	}
	void run(int vY){
		mapdata lyr = Game->LoadTempScreen(this->Layer);
		
		//Only the first instance of the script keeps running
		for(int i=0; i<176; ++i){
			combodata cd = Game->LoadComboData(lyr->ComboD[i]);
			if(cd->Script==this->Script){
				if(i!=this->Pos)
					Quit();
				else
					break;
			}
		}
		
		if(SLOPE_FIX_MISALIGNS){
			if(!SlopeCanPlaceLink(Link->X, Link->Y)){
				int gridY = Round(Link->Y/8)*8;
				int yOffs[] = {0, -8, 8, -16, 16};
				for(int i=0; i<5; ++i){
					if(SlopeCanPlaceLink(Link->X, gridY+yOffs[i])){
						Link->Y = gridY+yOffs[i];
						break;
					}
				}
			}
		}
		
		while(true){
			if(Link->Action==LA_NONE||Link->Action==LA_WALKING){
				int vY;
				int vY2;
				//Check two combo positions to find the slope Link is standing on
				//Since Link's center is between two pixels, this is necessary so he can walk against the edge of half tile solids and still be pushed upward
				for(int i=0; i<2; ++i){
					combodata cd = Game->LoadComboData(lyr->ComboD[ComboAt(Link->X+7+i, Link->Y+12)]);
					if(cd->Script==this->Script){
						int slope = cd->InitD[0];
						if(vY==0||Sign(vY)==Sign(slope)){
							if(Abs(slope)>Abs(vY))
								vY = slope;
						}
						else
							vY = 0;
						
						int slope2 = cd->InitD[1];
						if(vY2==0||Sign(vY2)==Sign(slope2)){
							if(Abs(slope2)>Abs(vY2))
								vY2 = slope2;
						}
						else
							vY2 = 0;
					}
				}
				
				//Change vY based on Link's step speed. Link moves slower on each axis when moving at a diagonal
				vY *= Link->Step/100;
				if(LinkMovement_StickX()!=0&&LinkMovement_StickY()!=0)
					vY *= 0.7071;
				
				vY2 *= Link->Step/100;
				if(LinkMovement_StickX()!=0&&LinkMovement_StickY()!=0)
					vY2 *= 0.7071;
				
				LinkMovement_Push(0, vY*LinkMovement_StickX()+vY2*Abs(LinkMovement_StickY()));
			}
			
			Waitframe();
		}
	}
}

//Attribytes[0] - Visual Sprite
//Attribytes[1] - Sprite Width
//Attribytes[2] - Sprite Height
//Attribytes[3] - SFX
//Attribytes[4] - Frames before the effect spawns
//Attribytes[5] - Copy CSet
//Attribytes[6] - Tile Offset
//Attribytes[7] - Exclude Flag

//Attrishorts[0] - Secondary Effect
//					0 - None
//					1 - LWeapon
//					2 - EWeapon
//					3 - Enemy
//Attrishorts[1] - Effect ID
//Attrishorts[2] - Effect Sprite
//Attrishorts[3] - Effect Damage
//Attrishorts[4] - Effect Step
//Attrishorts[5] - Effect Delay
//Attrishorts[6] - Effect Angle

combodata script ComboSprite{
	void run(){
		int visualSprite = this->Attribytes[0];
		int spriteW = this->Attribytes[1];
		int spriteH = this->Attribytes[2];
		int spriteSFX = this->Attribytes[3];
		int staggerEffect = this->Attribytes[4];
		int copyCSet = this->Attribytes[5];
		int offset = this->Attribytes[6];
		int excludeFlag = this->Attribytes[7];
		if(spriteW==0) spriteW = 1;
		if(spriteH==0) spriteH = 1;
		
		if(excludeFlag>0&&Screen->ComboF[this->Pos]==excludeFlag)
			Quit();
			
		int effectType = this->Attrishorts[0];
		int effectID = this->Attrishorts[1];
		int effectSprite = this->Attrishorts[2];
		int effectDamage = this->Attrishorts[3];
		int effectStep = this->Attrishorts[4];
		int effectDelay = this->Attrishorts[5];
		int effectAngle = this->Attrishorts[6];
		
		mapdata lyr = Game->LoadTempScreen(this->Layer);
		
		if(visualSprite){
			lweapon effect = CreateLWeaponAt(LW_SPARKLE, this->X, this->Y);
			effect->DrawXOffset = -(spriteW-1)*8;
			effect->DrawYOffset = -(spriteH-1)*8;
			effect->Extend = 3;
			effect->TileWidth = spriteW;
			effect->TileHeight = spriteH;
			effect->UseSprite(visualSprite);
			if(copyCSet){
				effect->CSet = lyr->ComboC[this->Pos];
			}
			if(offset){
				effect->OriginalTile += offset;
				effect->Tile = effect->OriginalTile;
			}
			effect->CollDetection = false;
			
		}
		if(spriteSFX)
			Game->PlaySound(spriteSFX);
		
		if(staggerEffect){
			for(int i=0; i<staggerEffect; ++i){
				Waitframe();
			}
		}
		
		switch(effectType){
			case 1: //LWeapon
				lweapon l = CreateLWeaponAt(effectID, this->X, this->Y);
				l->UseSprite(effectSprite);
				l->Step = 0;
				l->Dir = -1;
				l->Damage = effectDamage;
				l->Angular = true;
				int angle = Angle(this->X, this->Y, Link->X, Link->Y);
				if(effectAngle>0)
					angle = effectAngle;
				if(effectStep<0){
					angle += 180;
					effectStep = Abs(effectStep);
				}
				l->Angle = DegtoRad(angle);
				if(effectDelay>0){
					for(int i=0; i<effectDelay; ++i){
						Waitframe();
					}
				}
				l->Step = effectStep;
				break;
			case 2: //EWeapon
				eweapon e = CreateEWeaponAt(effectID, this->X, this->Y);
				e->UseSprite(effectSprite);
				e->Step = 0;
				e->Dir = -1;
				e->Damage = effectDamage;
				e->Angular = true;
				int angle = Angle(this->X, this->Y, Link->X, Link->Y);
				if(effectAngle>0)
					angle = effectAngle;
				if(effectStep<0){
					angle += 180;
					effectStep = Abs(effectStep);
				}
				e->Angle = DegtoRad(angle);
				if(effectDelay>0){
					for(int i=0; i<effectDelay; ++i){
						Waitframe();
					}
				}
				e->Step = effectStep;
				break;
			case 3: //NPC
				npc n = CreateNPCAt(effectID, this->X, this->Y);
				if(effectDamage>0)
					n->Damage = effectDamage;
				if(effectDelay>0){
					int oldStep = n->Step;
					n->Step = 0;
					for(int i=0; i<effectDelay; ++i){
						n->Step = 0;
						Waitframe();
					}
					n->Step = oldStep;
					if(effectStep>0)
						n->Step = effectStep;
				}
				break;
		}
	}
}

combodata script RedrawCombo{
	void run(){
		mapdata lyr = Game->LoadTempScreen(this->Layer);
		while(true){
			Screen->FastCombo(this->Layer, this->X, this->Y, this->ID, lyr->ComboC[this->Pos], 128);
			Waitframe();
		}
	}
}

combodata script StepNextSwitchTimed{
	void run(int timer){
		if(timer){
			int temp_timer = timer;
			while(true){
				if(Switch_Pressed(this->X, this->Y, false, 0)){
					temp_timer = timer;
				}
				if(temp_timer>0){
					--temp_timer;
					if(temp_timer<=0){
						Game->PlaySound(SFX_SWITCH_RELEASE);
						--Screen->ComboD[this->Pos];
					}
				}
				if(Screen->State[ST_SECRET]){
					Quit();
				}
				Waitframe();
			}
		}
		else{
			while(true){
				if(Switch_Pressed(this->X, this->Y, false, 0)||Screen->State[ST_SECRET]){
					Game->PlaySound(SFX_SWITCH_PRESS);
					++Screen->ComboD[this->Pos];
				}
				Waitframe();
			}
		}
	}
}