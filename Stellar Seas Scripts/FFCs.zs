
ffc script MagneticSpinBlock{
	void run(int rotDir, int delay, int turnSpeed, int RussNoGetAwayFromThatLedgeOhGodHesDoingItICantWatch){
		int oCombo = this->Data;
		mapdata l1 = Game->LoadTempScreen(1);
		mapdata l2;
		if(Game->GetCurDMap() == 25)
			l2 = Game->LoadTempScreen(2);
		int pos = ComboAt(this->X+8, this->Y+8);
		l1->ComboD[pos] = this->Data;
		l1->ComboC[pos] = this->CSet;
		int CurCmb = l1->ComboD[pos];
		this->Data = GH_INVISIBLE_COMBO;
		int state = 0;
		int frames = delay;
		int angleLink = Angle(this->X, this->Y, Link->X, Link->Y);
		int newAngle;
		int targetAngle;
		int tX = this->X;
		int tY = this->Y;
		bool grabbedBlock;
		bool canGrab; //If this is a block that respects elevation, this flag is only set when Link is at the right elevation
		
		//G[G_OVERUNDERLAYER]
		while(true){
			//Let's get this nonsense out of the way first
			if(RussNoGetAwayFromThatLedgeOhGodHesDoingItICantWatch == 1){
				if(G[G_OVERUNDERLAYER] == 1)
					canGrab = true;
				else
					canGrab = false;
			}
			if(RussNoGetAwayFromThatLedgeOhGodHesDoingItICantWatch == 2){
				if(G[G_OVERUNDERLAYER] == 0)
					canGrab = true;
				else
					canGrab = false;
			}
			if(state==0){
				grabbedBlock = false;
				angleLink = DirAngle(AngleDir4(Angle(this->X, this->Y, Link->X, Link->Y)));
				if(G[G_MAGNETPULL]&&Abs(this->X-Link->X)<=16&&Link->Y>=this->Y-16&&Link->Y<=this->Y+8&&Link->Dir==AngleDir4(Angle(Link->X, Link->Y, this->X, this->Y))){
					grabbedBlock = true;
				}
				if(grabbedBlock){
					tX = this->X+VectorX(24, angleLink);
					tY = this->Y+VectorY(24, angleLink);
					if(tX<this->X-16)
						tX = this->X-16;
					else if(tX>this->X+16)
						tX = this->X+16;
					if(tY<this->Y-16)
						tY = this->Y-16;
					else if(tY>this->Y+8)
						tY = this->Y+8;
					targetAngle = Angle(Link->X, Link->Y, tX, tY);
					if(Distance(Link->X, Link->Y, tX, tY)<2){
						Link->X = tX;
						Link->Y = tY;
					}
					else{
						LinkMovement_Push2(VectorX(2, targetAngle), VectorY(2, targetAngle));
					}
				}
				if(frames>0)
					--frames;
				else{
					frames = turnSpeed;
					state = 1;
				}
			}
			else{
				if(!G[G_MAGNETACTIVE])
					grabbedBlock = false;
				int newAngle = angleLink+rotDir*state*22.5;
				if(grabbedBlock){
					tX = this->X+VectorX(24, newAngle);
					tY = this->Y+VectorY(24, newAngle);
					if(tX<this->X-16)
						tX = this->X-16;
					else if(tX>this->X+16)
						tX = this->X+16;
					if(tY<this->Y-16)
						tY = this->Y-16;
					else if(tY>this->Y+8)
						tY = this->Y+8;
					targetAngle = Angle(Link->X, Link->Y, tX, tY);
					if(Distance(Link->X, Link->Y, tX, tY)<2){
						Link->X = tX;
						Link->Y = tY;
					}
					else{
						LinkMovement_Push2(VectorX(2, targetAngle), VectorY(2, targetAngle));
					}
					Link->Dir = AngleDir4(Angle(Link->X, Link->Y, this->X, this->Y));
					G[G_SPECIALMAGNETPULL] = 2;
					NoWalk(); //Stop the player turning and dumping themselves in a pit
				}
				if(frames>0)
					--frames;
				else{
					frames = turnSpeed;
					++state;
					CurCmb += rotDir;
					if(CurCmb<oCombo)
						CurCmb = oCombo+3;
					else if(CurCmb>oCombo+3)
						CurCmb = oCombo;
					if(RussNoGetAwayFromThatLedgeOhGodHesDoingItICantWatch == 0 || canGrab)
						l1->ComboD[pos] = CurCmb;
					else
						l1->ComboD[pos] = CurCmb + 100;
					if(Game->GetCurDMap() == 25){
						l2->ComboD[pos] = l1->ComboD[pos];
						l2->ComboC[pos] = l1->ComboC[pos];
					}						
				}
				if(state==5){
					frames = delay;
					state = 0;
				}
			}
			if(this->Flags[FFCF_OVERLAY]){
				if(Link->Z<=0)
					Screen->FastCombo(5, ComboX(pos), ComboY(pos), l1->ComboD[pos], l1->ComboC[pos], 128);
			}
			Waitframe();
		}
	}
}

const int FFCS_STARWANDBLOCK = 7;

ffc script StarWandBlock{
	bool StarWandBlock_CheckCollision(int x, int y, int w, int h, bool noLayer1){
		for(int ix=x; ix<=x+w-1; ix=Min(ix+16, x+w-1)){
			for(int iy=y; iy<=y+h-1; iy=Min(iy+16, y+h-1)){
				if(StarWandBlock_CheckPixel(ix, iy, noLayer1))
					return true;
				if(iy==y+h-1)
					break;
			}
			if(ix==x+w-1)
				break;
		}
		return false;
	}
	bool StarWandBlock_CheckPixel(int x, int y, bool noLayer1){
		if(x<0)
			return false;
		if(x>255)
			return false;
		if(y<0)
			return false;
		if(y>175)
			return false;
		int pos = ComboAt(x, y);
		if(ComboFI(pos, CF_SCRIPT5))
			return false;
		if(ComboFI(pos, CF_NOBLOCKS))
			return true;
		if(GetLayerComboF(1,pos) == 102 && Game->GetCurDMap() == 25 && Game->GetCurScreen() == 0x69) //I'm so sorry for what I've yabba dabba done
			return true;
		mapdata l1 = Game->LoadTempScreen(1);
		mapdata l2 = Game->LoadTempScreen(2);
		int l1s;
		if(Screen->LayerMap(1)>-1&&!noLayer1)
			l1s = l1->ComboS[pos];
		int l2s;
		if(Screen->LayerMap(2)>-1)
			l2s = l2->ComboS[pos];
		return Screen->ComboS[pos]|l1s|l2s;
	}
	bool StarWandBlock_CheckCollision2(int x, int y, int w, int h, bool noLayer1){
		for(int ix=x; ix<=x+w-1; ix=Min(ix+16, x+w-1)){
			for(int iy=y; iy<=y+h-1; iy=Min(iy+16, y+h-1)){
				if(StarWandBlock_CheckPixel2(ix, iy, noLayer1))
					return true;
				if(iy==y+h-1)
					break;
			}
			if(ix==x+w-1)
				break;
		}
		return false;
	}
	bool StarWandBlock_CheckPixel2(int x, int y, bool noLayer1){
		if(x<0)
			return false;
		if(x>255)
			return false;
		if(y<0)
			return false;
		if(y>175)
			return false;
		int pos = ComboAt(x, y);
		if(ComboFI(pos, CF_SCRIPT5))
			return false;
		if(ComboFI(pos, CF_NOBLOCKS))
			return true;
		if(GetLayerComboF(1,pos) == 102 && Game->GetCurDMap() == 25 && Game->GetCurScreen() == 0x69) //I'm so sorry for what I've yabba dabba done
			return true;
	}
	void run(int linkFFC, int linkCollision, int remoteTrigger){
		const int REMOTETRIGGER = 2;
		this->InitD[REMOTETRIGGER] = -1;
		this->Flags[FFCF_ETHEREAL] = true;
		int w = this->TileWidth;
		int h = this->TileHeight;
		int cmb = this->Data;
		int pos = ComboAt(this->X+8, this->Y+8);
		this->Data = GH_INVISIBLE_COMBO;
		mapdata l1 = Game->LoadTempScreen(1);
		int impactCooldown;
		int underCombo[16];
		ffc linked;
		int linkedOffX;
		int linkedOffY;
		int x2;
		int y2; 
		int w2;
		int h2;
		if(linkFFC){
			linked = Screen->LoadFFC(linkFFC);
			linkedOffX = linked->X - this->X;
			linkedOffY = linked->Y - this->Y;
			w2 = linked->TileWidth;
			h2 = linked->TileHeight;
		}
		for(int ix=0; ix<w; ++ix){
			for(int iy=0; iy<h; ++iy){
				underCombo[ix+iy*4] = l1->ComboD[pos+ix+iy*16];
				l1->ComboD[pos+ix+iy*16] = cmb+ix+iy*4;
			}
		}
		while(true){
			if(impactCooldown>0)
				--impactCooldown;
			int impactDir = -1;
			for(int i=Screen->NumLWeapons(); i>0; --i){
				lweapon l = Screen->LoadLWeapon(i);
				if(l->ID==LW_STARWANDIMPACT&&l->Damage==1){
					int hOff;
					if(l->Dir==DIR_UP)
						hOff = 8;
					if(RectCollision(l->X+l->HitXOffset, l->Y+l->HitYOffset, l->X+l->HitXOffset+l->HitWidth-1, l->Y+l->HitYOffset+l->HitHeight-1+hOff, ComboX(pos), ComboY(pos), ComboX(pos)+w*16-1, ComboY(pos)+h*16-1-1)){
						if(l->Dir<4){
							impactDir = l->Dir; //AngleDir4(Angle(HitboxCenterX(l), HitboxCenterY(l), this->X+w*8, this->Y+h*8));
							break;
						}
					}
				}
			}
			if(this->InitD[REMOTETRIGGER]>-1){
				impactDir = this->InitD[REMOTETRIGGER];
				this->InitD[REMOTETRIGGER] = -1;
			}
			if(impactDir>-1&&!impactCooldown){
				int x = this->X;
				int y = this->Y;
				if(linkCollision){
					x2 = linked->X;
					y2 = linked->Y;
				}
				if(!StarWandBlock_CheckCollision(x+DirX(impactDir, 4), y+DirY(impactDir, 4), w*16, h*16, true)){
					Game->PlaySound(SFX_STARWANDBLOCK_MOVE);
					for(int ix=0; ix<w; ++ix){
						for(int iy=0; iy<h; ++iy){
							l1->ComboD[pos+ix+iy*16] = underCombo[ix+iy*4];
						}
					}
					while(!StarWandBlock_CheckCollision(x+DirX(impactDir, 4), y+DirY(impactDir, 4), w*16, h*16, false)&&x>-64&&x<256&&y>-64&&y<176 && !(linkCollision && StarWandBlock_CheckCollision2(x2+DirX(impactDir, 4), y2+DirY(impactDir, 4), w2*16, h2*16, false))){
						x += DirX(impactDir, 4);
						y += DirY(impactDir, 4);
						this->X = x;
						this->Y = y;
						Screen->DrawCombo(1, x, y, cmb+w, w, h, this->CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
						SolidObjects_Add(0, x, y, w*16, h*16, DirX(impactDir, 4), DirY(impactDir, 4), 0);
						MakeHitboxLW(LW_STARWANDIMPACT, x, y, w*16, h*16, DAMAGE_STARWAND_BLOCK, impactDir);
						if(linkFFC){
							linked->X = x + linkedOffX;
							linked->Y = y + linkedOffY;
							x2 = linked->X;
							y2 = linked->Y;
						}
						Waitframe();
					}
					if(x>=0&&x<=256-w*16&&y>=0&&y<=176-h*16){
						this->X = GridX(x+8);
						this->Y = GridY(y+8);
						x = GridX(x+8);
						y = GridY(y+8);
						Game->PlaySound(SFX_STARWANDBLOCK_STOP);
						pos = ComboAt(x, y);
						for(int ix=0; ix<w; ++ix){
							for(int iy=0; iy<h; ++iy){
								underCombo[ix+iy*4] = l1->ComboD[pos+ix+iy*16];
								l1->ComboD[pos+ix+iy*16] = cmb+ix+iy*4;
							}
						}
						for(int i=0; i<4; ++i){
							SolidObjects_Add(0, x, y, w*16, h*16, DirX(impactDir, 4), DirY(impactDir, 4), 0);
							Waitframe();
						}
						//Crush Link
						if(RectCollision(Link->X+4, Link->Y+11, Link->X+11, Link->Y+11, x, y, x+w*16-1, y+h*16-1)){
							G[G_ASHERHP] = 0;
							G[G_TORRINHP] = 0;
							G[G_KAYLANIHP] = 0;
							Link->HP = 0;
						}
						MakeHitboxLW(LW_STARWANDIMPACT, x+DirX(impactDir, 4), y+DirY(impactDir, 4), w*16, h*16, DAMAGE_STARWAND_BLOCK, impactDir);
						lweapon core = MakeHitboxLW(LW_STARWANDIMPACT, x+DirX(impactDir, 4), y+DirY(impactDir, 4), w*16, h*16, 1, impactDir);
						core->CollDetection = false;
						impactCooldown = 48;
					}
					else{
						Quit();
					}
				}
			}
			Waitframe();
		}
	}
}


const int SFX_DOOR_OPEN = 67;

ffc script DoorKnock{
	void JesusZCWhy(ffc this, int warpNum){
		if(Distance(Link->X, Link->Y, this->X, this->Y) <=4){
			Screen->SetSideWarp(3, Screen->GetTileWarpScreen(warpNum), Screen->GetTileWarpDMap(warpNum), Screen->GetTileWarpType(warpNum));
			this->Data = CMB_AUTOWARPD;
		}
	}
	void run(int type, int warpNum, int overhead){
		this->Flags[FFCF_ETHEREAL] = true;
		mapdata l1 = Game->LoadTempScreen(1);
		mapdata l2 = Game->LoadTempScreen(2);
		mapdata l4 = Game->LoadTempScreen(4);
		mapdata overundertmp = Game->LoadMapData(MAP_OVERUNDER, SCREEN_OVERUNDER);
		int cd0[176];
		for(int i=0; i<176; ++i){
			cd0[i] = Screen->ComboD[i];
		}
		int pos = ComboAt(this->X, this->Y);
		int cd = l1->ComboD[pos];
		if(type==0){
			switch(cd){
				case 8508: //Wood Starting Town
					type = 1;
					break;
				case 8534: //City Upper
					type = 2;
					break;
				case 8506: //City Lower
					type = 3;
					break;
				case 8502: //City Shop
					type = 4;
					break;
				case 36133: //City Shack
					type = 5;
					break;
			}
		}
		while(true){
			if(Abs(Link->X-this->X)<=8&&Link->Y==this->Y+8&&Link->Dir==DIR_UP&&(Link->PressUp||Link->PressA)&&(!overhead||G[G_OVERUNDERLAYER]==1)){
				if(Game->GetCurMap() == 2 && Game->GetCurScreen() == 0x39 && Game->Counter[CR_STORYFLAG] == SFLAG_WAREHOUSE && DayNight[_DN_HOUR] < 21){
					PlayStringAndWait("Hold on, mate, we can't go bargin' in while folks are watching. Let's wait a bit, at least til it's dark and there's less people scurryin' about.", SCHAR_TORRIN, EMOTE_NORMAL, 64, 112);
				}
				else if(Game->GetCurMap() == 2 && Game->GetCurScreen() == 0x39 && Game->Counter[CR_STORYFLAG] < SFLAG_WAREHOUSE){
					//
				}
				else if(Game->GetCurMap() == 20 && Game->GetCurScreen() == 0x2E && Game->Counter[CR_STORYFLAG] < SFLAG_SHOALSOPEN){
					PlayStringAndWait("Look Ma, I told ya, I'm-", SCHAR_TORRIN, EMOTE_NORMAL, 64, 112);
					PlayStringAndWait("No more excuses, Torrin! I told you last time, I'm done with this!", SCHAR_TALCAY, EMOTE_NORMAL, 64, 112);
					PlayStringAndWait("We should give them their space for now.", SCHAR_KAYLANI, EMOTE_SWEAT, 64, 112);
				}
				else{
					int openCMB = 8516;
					int openCMB2 = 8472;
					switch(type){
						case 1: //Wood Starting Town
							openCMB = 8516;
							if(warpNum==1)
								openCMB = 8518;
							openCMB2 = 8472;
							break;
						case 2: //City Upper
							openCMB = 8544;
							if(warpNum==1)
								openCMB = 8546;
							break;
						case 3: //City Lower
							openCMB = 8516;
							if(warpNum==1)
								openCMB = 8518;
							break;
						case 4: //City Shop
							openCMB = 8516;
							if(warpNum==1)
								openCMB = 8518;
							break;
						case 5: //City Shack
							openCMB = 36141;
							break;
						case 6: //Warehouse
							openCMB = 8474;
							break;
					}
					Screen->ComboD[pos] = openCMB;
					Screen->ComboD[pos+1] = openCMB+1;
					if(overhead){
						l2->ComboD[pos] = openCMB;
						l2->ComboD[pos+1] = openCMB+1;
					}
					else{
						l1->ComboD[pos] = openCMB;
						l1->ComboD[pos+1] = openCMB+1;
					}
					Game->PlaySound(SFX_DOOR_OPEN);
					for(int i=0; i<8; ++i){
						WaitNoAction();
					}
					while(Link->InputA){
						Link->InputA = false; Link->PressA = false;
						Waitframe();
					}
					if(overhead){
						bool suppressA = true;
						while(true){
							overundertmp->ComboD[pos] = openCMB2;
							overundertmp->ComboD[pos+1] = openCMB2+1;
							if(G[G_OVERUNDERLAYER]==1){
								Screen->ComboD[pos] = openCMB;
								Screen->ComboD[pos+1] = openCMB+1;
								l2->ComboD[pos] = openCMB;
								l2->ComboD[pos+1] = openCMB+1;
							}
							else{
								Screen->ComboD[pos] = cd0[pos];
								Screen->ComboD[pos+1] = cd0[pos+1];
								l4->ComboD[pos] = openCMB2;
								l4->ComboD[pos+1] = openCMB2+1;
							}
							if(suppressA&&Link->InputA){
								Link->InputA = false; Link->PressA = false;
							}
							else
								suppressA = false;
							JesusZCWhy(this, warpNum);
							Waitframe();
						}
					}
					else{
						while(Link->InputA){
							Link->InputA = false; Link->PressA = false;
							JesusZCWhy(this, warpNum);
							Waitframe();
						}
						while(true){
							JesusZCWhy(this, warpNum);
							Waitframe();
						}
					}
					Quit();
				}
			}
			Waitframe();
		}
	}
}

const int SFX_SWITCH_PRESS = 68; //SFX when a switch is pressed
const int SFX_SWITCH_RELEASE = 68; //SFX when a switch is released
const int SFX_SWITCH_ERROR = 69; //SFX when the wrong switch is pressed
const int SFX_ERROR = 69;

const int SWITCH_ENABLE_HIDDEN = 1; //If 1, switches can be hidden under pots with the "Only Visible to Lens of Truth" flag

const int SWITCH_INVISIBLE_COMBO = 1; //A combo that appears fully invisible when assigned to a 4x4 FFC

int Switch_Pressed(int x, int y, bool noLink, int specialCase){
	int xOff = 0;
	int yOff = 4;
	int xDist = 8;
	int yDist = 8;
	for(int i=1; i<=32; ++i){
		ffc f = Screen->LoadFFC(i);
		if(f->Script==FFCS_MAGNETGEM||f->Script==FFCS_MICAH){
			if(Abs(f->X+xOff-x)<=xDist&&Abs(f->Y+yOff-y)<=yDist)
				return 1;
		}
	}
	if(specialCase==1&&Link->Action!=LA_DIVING)
		return 0;
	if(Abs(Link->X+xOff-x)<=xDist&&Abs(Link->Y+yOff-y)<=yDist&&Link->Z==0&&!noLink)
		return 1;
	if(Screen->MovingBlockX>-1){
		if(Abs(Screen->MovingBlockX-x)<=8&&Abs(Screen->MovingBlockY-y)<=8)
			return 1;
	}
	if(Screen->isSolid(x+4, y+4)&&
		Screen->isSolid(x+12, y+4)&&
		Screen->isSolid(x+4, y+12)&&
		Screen->isSolid(x+12, y+12)){
		return 2;
	}
	return 0;
}

ffc script Switch_Secret{
	void run(int perm, int id, int sfx, int specialCase, int layer){
		if(SWITCH_ENABLE_HIDDEN&&this->Flags[FFCF_LENSVIS]){
			int oldData = this->Data;
			this->Data = SWITCH_INVISIBLE_COMBO;
			while(Screen->ComboD[ComboAt(this->X+8, this->Y+8)]!=oldData){
				Waitframe();
			}
			this->Data = oldData;
			this->Flags[FFCF_LENSVIS] = false;
		}
		
		int d;
		int db;
		if(id>0){
			d = Floor((id-1)/16);
			db = 1<<((id-1)%16);
		}
		if(perm){
			if(id>0){
				if(Screen->D[d]&db){
					this->Data++;
					Screen->TriggerSecrets();
					Quit();
				}
			}
			else if(Screen->State[ST_SECRET]){
				this->Data++;
				Quit();
			}
		}
		while(!Switch_Pressed(this->X, this->Y, false, specialCase)||(layer>0&&G[G_OVERUNDERLAYER]!=layer-1)){
			Waitframe();
		}
		this->Data++;
		Screen->TriggerSecrets();
		Game->PlaySound(SFX_SWITCH_PRESS);
		if(sfx>0)
			Game->PlaySound(sfx);
		else if(sfx==-1)
			Game->PlaySound(SFX_SECRET);
		if(perm){
			if(id>0)
				Screen->D[d]|=db;
			else
				Screen->State[ST_SECRET] = true;
		}
	}
}

ffc script Switch_Remote{
	void run(int pressure, int id, int flag, int sfx, int layer, int cooldown, int overunderlayer){	
		int data = this->Data;
		int i; int j; int k;
		int d;
		int db;
		int tempCooldown = cooldown;
		if(id>0){
			d = Floor((id-1)/16);
			db = 1<<((id-1)%16);
		}
		mapdata tempLayer = Game->LoadTempScreen(layer);
		int comboD[176];
		for(i=0; i<176; i++){
			if(tempLayer->ComboF[i]==flag){
				comboD[i] = tempLayer->ComboD[i];
				tempLayer->ComboF[i] = 0;
			}
		}
		if(id>0){
			if(Screen->D[d]&db){
				this->Data = data+1;
				for(i=0; i<176; i++){
					if(comboD[i]>0){
						tempLayer->ComboD[i] = comboD[i]+1;
					}
				}
				Quit();
			}
		}
		if(SWITCH_ENABLE_HIDDEN&&this->Flags[FFCF_LENSVIS]){
			int oldData = this->Data;
			this->Data = SWITCH_INVISIBLE_COMBO;
			while(Screen->ComboD[ComboAt(this->X+8, this->Y+8)]!=oldData){
				Waitframe();
			}
			this->Data = oldData;
			this->Flags[FFCF_LENSVIS] = false;
		}
		if(id>0){
			if(Screen->D[d]&db){
				Quit();
			}
		}
		
		bool noLink;
		if(pressure==2){
			pressure = 1;
			noLink = true;
		}
		
		if(pressure){
			while(true){
				tempCooldown = cooldown;
				while(!Switch_Pressed(this->X, this->Y, noLink, 0)||(overunderlayer>0&&G[G_OVERUNDERLAYER]!=overunderlayer-1)){
					Waitframe();
				}
				this->Data = data+1;
				Game->PlaySound(SFX_SWITCH_PRESS);
				for(i=0; i<176; i++){
					if(comboD[i]>0){
						tempLayer->ComboD[i] = comboD[i]+1;
					}
				}
				while(Switch_Pressed(this->X, this->Y, noLink, 0)||tempCooldown){
					if(Switch_Pressed(this->X, this->Y, noLink, 0))
						tempCooldown = cooldown;
					if(tempCooldown)
						--tempCooldown;
					Waitframe();
				}
				this->Data = data;
				Game->PlaySound(SFX_SWITCH_RELEASE);
				for(i=0; i<176; i++){
					if(comboD[i]>0){
						tempLayer->ComboD[i] = comboD[i];
					}
				}
			}
		}
		else{
			while(!Switch_Pressed(this->X, this->Y, noLink, 0)||(overunderlayer>0&&G[G_OVERUNDERLAYER]!=overunderlayer-1)){
				Waitframe();
			}
			this->Data = data+1;
			Game->PlaySound(SFX_SWITCH_PRESS);
			if(sfx>0)
				Game->PlaySound(sfx);
			else if(sfx==-1)
				Game->PlaySound(SFX_SECRET);
			for(i=0; i<176; i++){
				if(comboD[i]>0){
					tempLayer->ComboD[i] = comboD[i]+1;
				}
			}
			if(id>0){
				Screen->D[d] |= db;
			}
		}
	}
}

ffc script Switch_HitAll{
	void run(int switchCmb, int pressure, int perm, int id, int flag, int sfx, int switchID, int layer){
		bool noLink;
		if(pressure==2){
			pressure = 1;
			noLink = true;
		}
		
		bool OhFuckHereComesRuss;
		if(Game->GetCurDMap() == 73)
			OhFuckHereComesRuss = true;
		int spcflag = 98;
		
		int i; int j; int k;
		int d;
		int db;
		if(flag==0)
			id = 0;
		int comboD[176];
		mapdata tempLayer = Game->LoadTempScreen(layer);
		if(id>0){
			d = Floor((id-1)/16);
			db = 1<<((id-1)%16);
			for(i=0; i<176; i++){
				if(tempLayer->ComboF[i]==flag){
					comboD[i] = tempLayer->ComboD[i];
					tempLayer->ComboF[i] = 0;
				}
			}
		}
		int switches[34];
		int switchD[34];
		int switchDB[34];
		int switchsp[34];
		switchD[0] = switchID;
		bool switchesPressed[34];
		k = SizeOfArray(switches)-2;
		for(i=0; i<176&&switches[0]<k; i++){
			if(tempLayer->ComboD[i]==switchCmb || (OhFuckHereComesRuss && tempLayer->ComboF[i] == spcflag)){
				j = 2+switches[0];
				switches[j] = i;
				if(OhFuckHereComesRuss && tempLayer->ComboF[i] == spcflag)
					switchsp[j] = 1;
				if(!pressure&&switchID>0){
					switchD[j] = Floor((switchID+switches[0]-1)/16);
					switchDB[j] = 1<<((switchID+switches[0]-1)%16);
					if(tempLayer->D[switchD[j]]&switchDB[j]){
						switchesPressed[j] = true;
						if(OhFuckHereComesRuss && tempLayer->ComboF[i] == spcflag)
							tempLayer->ComboF[i] = spcflag+1;
						else
							tempLayer->ComboD[i] = switchCmb+1;
						switches[1]++;
					}
				}
				switches[0]++;
			}
		}
		if(perm){
			if(id>0){
				if(tempLayer->D[d]&db){
					for(i=2; i<switches[0]+2; i++){
						if(OhFuckHereComesRuss && tempLayer->ComboF[switches[i]] == spcflag)
							tempLayer->ComboF[switches[i]] = spcflag+1;
						else
							tempLayer->ComboD[switches[i]] = switchCmb+1;
						switchesPressed[i] = true;
					}
					for(i=0; i<176; i++){
						if(comboD[i]>0){
							tempLayer->ComboD[i] = comboD[i]+1;
						}
					}
					while(true){
						Switches_Update(tempLayer, switches, switchD, switchDB, switchsp, switchesPressed, switchCmb, spcflag, false, noLink, 0);
						Waitframe();
					}
				}
			}
			else if(Screen->State[ST_SECRET]){
				for(i=2; i<switches[0]+2; i++){
					if(OhFuckHereComesRuss && tempLayer->ComboF[switches[i]] == spcflag)
							tempLayer->ComboF[switches[i]] = spcflag+1;
						else
							tempLayer->ComboD[switches[i]] = switchCmb+1;
					switchesPressed[i] = true;
				}
				while(true){
					Switches_Update(tempLayer, switches, switchD, switchDB, switchsp, switchesPressed, switchCmb, spcflag, false, noLink, 0);
					Waitframe();
				}
			}
		}
		if(pressure){
			while(switches[1]<switches[0]){
				Switches_Update(tempLayer, switches, switchD, switchDB, switchsp, switchesPressed, switchCmb, spcflag, true, noLink, 0);
				Waitframe();
			}
			if(id>0){
				if(sfx>0)
					Game->PlaySound(sfx);
				else if(sfx==-1)
					Game->PlaySound(SFX_SECRET);
				for(i=0; i<176; i++){
					if(comboD[i]>0){
						tempLayer->ComboD[i] = comboD[i]+1;
					}
				}
			}
			else{
				if(sfx>0)
					Game->PlaySound(sfx);
				else if(sfx==-1)
					Game->PlaySound(SFX_SECRET);
				Screen->TriggerSecrets();
			}
			if(perm){
				if(id>0)
					Screen->D[d] |= db;
				else
					Screen->State[ST_SECRET] = true;
			}
		}
		else{
			while(switches[1]<switches[0]){
				Switches_Update(tempLayer, switches, switchD, switchDB, switchsp, switchesPressed, switchCmb, spcflag, false, noLink, 0);
				Waitframe();
			}
			if(id>0){
				if(sfx>0)
					Game->PlaySound(sfx);
				else if(sfx==-1)
					Game->PlaySound(SFX_SECRET);
				for(i=0; i<176; i++){
					if(comboD[i]>0){
						tempLayer->ComboD[i] = comboD[i]+1;
					}
				}
			}
			else{
				if(sfx>0)
					Game->PlaySound(sfx);
				else if(sfx==-1)
					Game->PlaySound(SFX_SECRET);
				Screen->TriggerSecrets();
			}
			if(perm){
				if(id>0)
					Screen->D[d] |= db;
				else
					Screen->State[ST_SECRET] = true;
			}
		}
		while(true){
			Switches_Update(tempLayer, switches, switchD, switchDB, switchsp, switchesPressed, switchCmb, spcflag, false, noLink, 0);
			Waitframe();
		}
	}
	void Switches_Update(mapdata tempLayer, int switches, int switchD, int switchDB, int switchsp, bool switchesPressed, int switchCmb, int spcflag, bool pressure, bool noLink, int specialCase){
		if(pressure)
			switches[1] = 0;
		for(int i=0; i<switches[0]; i++){
			int j = i+2;
			int k = switches[j];
			int p = Switch_Pressed(ComboX(k), ComboY(k), noLink, 0);
			if(p){
				if(p!=2){
					if(switchsp[j] == 1){
						tempLayer->ComboF[k] = spcflag+1;
						combodata thecombo = Game->LoadComboData(tempLayer->ComboD[k]);
						Screen->FastTile(thecombo->Layer, thecombo->PosX(), thecombo->PosY(), thecombo->Tile+20, thecombo->CSet, OP_OPAQUE);
					}
					else
						tempLayer->ComboD[k] = switchCmb+1;
				}
				if(!switchesPressed[j]){
					Game->PlaySound(SFX_SWITCH_PRESS);
					if(switchD[0]>0){
						tempLayer->D[switchD[j]] |= switchDB[j];
					}
					switchesPressed[j] = true;
					if(!pressure)
						switches[1]++;
				}
				if(pressure)
					switches[1]++;
			}
			else{
				if(switchesPressed[j]){
					if(pressure){
						Game->PlaySound(SFX_SWITCH_RELEASE);
						tempLayer->ComboD[k] = switchCmb;
						switchesPressed[j] = false;
					}
					else{
						if(switchsp[j] == 1){
							if(tempLayer->ComboF[k]!=spcflag+1)
								tempLayer->ComboF[k] = spcflag+1;
							combodata thecombo = Game->LoadComboData(tempLayer->ComboD[k]);
							Screen->FastTile(thecombo->Layer, thecombo->PosX(), thecombo->PosY(), thecombo->Tile+20, thecombo->CSet, OP_OPAQUE);
						}
						else{
							if(tempLayer->ComboD[k]!=switchCmb+1)
								tempLayer->ComboD[k] = switchCmb+1;
						}
					}
				}
			}
		}
	}
}

ffc script Switch_Trap{
	void run(int enemyid, int count){
		if(SWITCH_ENABLE_HIDDEN&&this->Flags[FFCF_LENSVIS]){
			int oldData = this->Data;
			this->Data = SWITCH_INVISIBLE_COMBO;
			while(Screen->ComboD[ComboAt(this->X+8, this->Y+8)]!=oldData){
				Waitframe();
			}
			this->Data = oldData;
			this->Flags[FFCF_LENSVIS] = false;
		}
		
		while(!Switch_Pressed(this->X, this->Y, false, 0)){
			Waitframe();
		}
		this->Data++;
		Game->PlaySound(SFX_SWITCH_PRESS);
		Game->PlaySound(SFX_SWITCH_ERROR);
		for(int i=0; i<count; i++){
			int pos = Switch_GetSpawnPos();
			npc n = CreateNPCAt(enemyid, ComboX(pos), ComboY(pos));
			Game->PlaySound(SFX_FALL);
			n->Z = 176;
			Waitframes(20);
		}
	}
}

int Switch_GetSpawnPos(){
	int pos;
	bool invalid = true;
	int failSafe = 0;
	while(invalid&&failSafe<512){
		pos = Rand(176);
		if(Switch_ValidSpawn(pos))
			return pos;
	}
	for(int i=0; i<176; i++){
		pos = i;
		if(Switch_ValidSpawn(pos))
			return pos;
	}
}
bool Switch_ValidSpawn(int pos){
	int x = ComboX(pos);
	int y = ComboY(pos);
	if(Screen->isSolid(x+4, y+4)||
		Screen->isSolid(x+12, y+4)||
		Screen->isSolid(x+4, y+12)||
		Screen->isSolid(x+12, y+12)){
		return false;
	
	}
	if(ComboFI(pos, CF_NOENEMY)||ComboFI(pos, CF_NOGROUNDENEMY))
		return false;
	int ct = Screen->ComboT[pos];
	if(ct==CT_NOENEMY||ct==CT_NOGROUNDENEMY||ct==CT_NOJUMPZONE)
		return false;
	if(ct==CT_WATER||ct==CT_LADDERONLY||ct==CT_HOOKSHOTONLY||ct==CT_LADDERHOOKSHOT)
		return false;
	if(ct==CT_PIT||ct==CT_PITB||ct==CT_PITC||ct==CT_PITD||ct==CT_PITR)
		return false;
	return true;
}

ffc script Switch_Sequential{
	void run(int flag, int perm, int sfx){
		int i; int j; int k;
		int switches[34];
		int switchCmb[34];
		int switchMisc[8];
		bool switchesPressed[34];
		k = SizeOfArray(switches)-2;
		for(i=0; i<176&&switches[0]<k; i++){
			if(Screen->ComboF[i]==flag){
				j = 2+switches[0];
				switches[j] = i;
				switchCmb[j] = Screen->ComboD[i];
				switches[0]++;
			}
		}
		int switchOrder[34];
		Switches_Organize(switches, switchOrder);
		if(perm&&Screen->State[ST_SECRET]){
			for(i=0; i<switches[0]; i++){
				switchesPressed[i+2] = true;
			}
			while(true){
				Switches_Update(switches, switchesPressed, switchOrder, switchCmb, switchMisc, false);
				Waitframe();
			}
		}
		while(switches[1]<switches[0]){
			Switches_Update(switches, switchesPressed, switchOrder, switchCmb, switchMisc, true);
			if(switchMisc[0]==1){
				switchMisc[0] = 0;
				for(i=0; i<30; i++){
					Switches_Update(switches, switchesPressed, switchOrder, switchCmb, switchMisc, false);
					Waitframe();
				}
				while(Switches_LinkOn(switches)){
					Switches_Update(switches, switchesPressed, switchOrder, switchCmb, switchMisc, false);
					Waitframe();
				}
			}
			Waitframe();
		}
		if(sfx>0)
			Game->PlaySound(sfx);
		else if(sfx==-1)
			Game->PlaySound(SFX_SECRET);
		Screen->TriggerSecrets();
		if(perm)
			Screen->State[ST_SECRET] = true;
		for(i=0; i<switches[0]; i++){
			switchesPressed[i+2] = true;
		}
		while(true){
			Switches_Update(switches, switchesPressed, switchOrder, switchCmb, switchMisc, false);
			Waitframe();
		}
		
	}
	void Switches_Organize(int switches, int switchOrder){
		bool banned[34];
		for(int j=0; j<switches[0]; j++){
			int lowest = -1;
			int lowestIndex = -1;
			for(int i=0; i<switches[0]; i++){
				int c = Screen->ComboD[switches[i+2]];
				if(c!=-1&&!banned[i+2]){
					if(lowest==-1||c<lowest){
						lowest = c;
						lowestIndex = i+2;
					}
				}
			}
			switchOrder[j] = lowestIndex;
			banned[lowestIndex] = true;
		}
	}
	bool Switches_LinkOn(int switches){
		for(int i=0; i<switches[0]; i++){
			int j = i+2;
			int k = switches[j];
			int p = Switch_Pressed(ComboX(k), ComboY(k), false, 0);
			if(p==1)
				return true;
		}
		return false;
	}
	void Switches_Update(int switches, bool switchesPressed, int switchOrder, int switchCmb, int switchMisc, bool canPress){
		bool reset;
		for(int i=0; i<switches[0]; i++){
			int j = i+2;
			int k = switches[j];
			int p = Switch_Pressed(ComboX(k), ComboY(k), false, 0);
			if(!switchesPressed[j]){
				if(p!=2)
					Screen->ComboD[k] = switchCmb[j];
				if(p&&canPress){
					if(j==switchOrder[switches[1]]){
						switches[1]++;
						Game->PlaySound(SFX_SWITCH_PRESS);
						switchesPressed[j] = true;
					}
					else{
						switches[1] = 0;
						Game->PlaySound(SFX_SWITCH_ERROR);
						reset = true;
					}
				}
			}
			else{
				if(p!=2)
					Screen->ComboD[k] = switchCmb[j]+1;
				if(p==0&&canPress){
					Game->PlaySound(SFX_SWITCH_RELEASE);
					switchesPressed[j] = false;
				}
			}
		}
		if(reset){
			switchMisc[0] = 1;
			for(int i=0; i<switches[0]; i++){
				int j = i+2;
				int k = switches[j];
				int p = Switch_Pressed(ComboX(k), ComboY(k), false, 0);
				switchesPressed[j] = false;
			}
		}
	}
}

const int SHUTTER_INVISIBLE_COMBO = 1; //Set this to a combo that when placed on a 4x4 FFC will be invisible.

const int CMB_BOMBWALL_MARKER = 0; //Combo used for the hint marker when using the lens on a bomb wall
const int CS_BOMBWALL_MARKER = 7; //CSet of the hint marker

const int D_LTTPDOORS = 0; //Screen->D[] (0-7) index used for directional doors
const int D_LTTPDOORID = 1; //Screen->D[] (0-7) index used for ID'd doors

const int SHUTTER_USE_FFC_CSET = 0; //If 1, will set shutters to the FFC's CSet. Else keep the CSets below the FFC.

const int SHUTTER_OPEN_FRAMES = 6; //How long in frames (60ths of a second) an animated shutter takes to open
const int SHUTTER_LOCK_OPEN_FRAMES = 12; //How long in frames (60ths of a second) an animated locked door takes to open
const int SHUTTER_BOSS_LOCK_OPEN_FRAMES = 12; //How long in frames (60ths of a second) an animated boss lock door takes to open

const int SHUTTER_REPEAT_DELAY_FRAMES = 12; //Delay between a shutter closing and opening
const int SHUTTER_LOCK_ACTIVATION_FRAMES = 12; //Delay when pushing against a locked door before it opens

const int SFX_SHUTTER_OPEN = 9; //SFX of a shutter opening
const int SFX_SHUTTER_CLOSE = 9; //SFX of a shutter closing
const int SFX_LOCK_OPEN = 9; //SFX of a lock opening
const int SFX_BOSS_LOCK_OPEN = 9; //SFX of a boss lock opening
const int SFX_BOMB_WALL_OPEN = 9; //SFX of a bomb wall being blasted open

const int LENS_MP_COST = 1; //The MP cost of the lens item

//If you have different/more lens items in your quest, this function will need to be changed
bool UsingLens(){
	if(Link->MP<LENS_MP_COST)
		return false;
	if(GetEquipmentA()==I_LENS&&Link->InputA)
		return true;
	if(GetEquipmentB()==I_LENS&&Link->InputB)
		return true;
	return false;
}

bool BombWall_HoldingItemButton(int id){
		if(GetEquipmentA()==id&&Link->InputA)
			return true;
		if(GetEquipmentB()==id&&Link->InputB)
			return true;
		return false;
	}

//LttP Shutter
//D0: Direction to the wall the shutter is on - 0: Up, 1: Down, 2: Left, 3: Right
//D1: Trigger type for the shutter
//		0: One way
//		1: Kill enemies
//		2: Push block
//		3: Combo change
//		4: Perm secret
//		5: One Way (State)
//		6: Temp Secret
//      7: Remote secret (uses dmap.screen)
//		8: Hard-coded golem door
//		9: Kill enemies (or stealth)
//D2: Combo position of the trigger combo for a combo change (3) shutter
//D6: If using an opening animation, this is the first of the combo groups, starting with a closed door.
//	  Opening combo groups should be arranged vertically and be made up of doors the same size as the FFC.
//D7: If using an opening animation, this is the number of frames in the animation.

ffc script LttP_Shutter{
	void DoSpecialAbort(int dir, int openTrigger){
		if(Game->GetCurMap()==33&&Game->GetCurScreen()==0x35&&openTrigger==0){
			if(Game->Counter[CR_CULTISTQUEST]>5){
				Quit();
			}
		}
	}
	void run(int dir, int openTrigger, int triggerPos, int triggerCD, int specialLayer, int layer, int openingCmb, int openingFrames){
		DoSpecialAbort(dir, openTrigger);
		bool open = false;
		if(openTrigger==9)
			open = true;
		
		int comboPos = ComboAt(this->X+8, this->Y+8);
		
		int closedCmb = this->Data;
		int openCmb = this->Data+4*this->TileHeight;
		this->Data = SHUTTER_INVISIBLE_COMBO;
		
		//Uncheck flags that make the FFC invisible during scrolling
		this->Flags[FFCF_LENSVIS] = false;
		this->Flags[FFCF_CHANGER] = false;
		
		//Set opening combo relative to the open and closed states if not set
		if(openingCmb==0&&openingFrames>0){
			openingCmb = closedCmb+2*(4*this->TileHeight);
		}
		
		int d = triggerPos%16;
		int dbit = 1<<Floor(triggerPos/16);
		
		int linkX = Link->X;
		int linkY = Link->Y;
		//If the script is running while the screen is scrolling, Link's position will be flipped.
		if(this->Flags[FFCF_PRELOAD]){
			if(dir==DIR_UP||dir==DIR_DOWN){
				if(linkY<=0)
					linkY = 160;
				else if(linkY>=160)
					linkY = 0;
			}
			else{
				if(linkX<=0)
					linkX = 240;
				else if(linkX>=240)
					linkX = 0;
			}
		}
		
		// >using variables as labels
		// shiggydiggy
		int SHUTTER_STATE = 0; //0 = Closed, 1 = Opening, 2 = Open, 3 = Closing
		int SHUTTER_FRAMES = 1;
		int SHUTTER_OPENCMB = 2;
		int SHUTTER_CLOSEDCMB = 3;
		int SHUTTER_COMBOPOS = 4;
		int shutter[16] = {0, 0, openCmb, closedCmb, comboPos};
		
		if(openTrigger==3){ //Combo change
			if(triggerCD==Screen->ComboD[triggerPos]){
				open = true;
				shutter[SHUTTER_STATE] = 2; //Open
			}
			else{
				if(!Shutter_LinkCollide(this, dir, linkY, linkY, true)){
					open = false;
					shutter[SHUTTER_STATE] = 0; //Closed
				}
			}
		}
		else if(openTrigger==4&&Screen->State[ST_SECRET]){ //Doors triggered by secret state don't need to run if it's already set
			Shutter_SetCombos(this, layer, comboPos, openCmb);
			Quit();
		}
		else if(openTrigger==5&&Screen->D[d]&dbit){ //Doors triggered by secret state don't need to run if it's already set
			Shutter_SetCombos(this, layer, comboPos, openCmb);
			Quit();
		}
		else if(openTrigger==6&&Screen->SecretsTriggered()){
			Shutter_SetCombos(this, layer, comboPos, openCmb);
			Quit();
		}
		else if(openTrigger==7){
			int map = Floor(triggerPos);
			int screen = (triggerPos - map) * 1000;
			if(Game->GetScreenState(map, screen, ST_SECRET)){
				Shutter_SetCombos(this, layer, comboPos, openCmb);
				Quit();
			}
		}
		else if(openTrigger==8&&G[G_GOLEMFLAG]&1&&G[G_GOLEMFLAG]&2&&G[G_GOLEMFLAG]&4){
			Shutter_SetCombos(this, layer, comboPos, openCmb);
			Quit();
		}
			
		int shutterCooldown;
		
		//If Link entered from this shutter, push him out and close it
		if(Shutter_LinkCollide(this, dir, linkX, linkY, false)){
			shutterCooldown = SHUTTER_REPEAT_DELAY_FRAMES;
			shutter[SHUTTER_STATE] = 2; //Open
			Shutter_SetCombos(this, layer, comboPos, openCmb);
			Waitframe();
			while(Link->Action==LA_SCROLLING||Shutter_LinkCollide(this, dir, Link->X, Link->Y, true)){
				if(Link->Action!=LA_SCROLLING)
					Shutter_MoveLink(dir);
				Waitframe();
			}
			if(openTrigger==5){
				Screen->D[d] |= dbit;
				open = true;
			}
			else{
				Shutter_EjectLink(this, dir, specialLayer);
				Shutter_Close(this, layer, shutter, openingFrames);
			}
		}
		else{
			if(this->Flags[FFCF_PRELOAD]){
				if(open){ //Combo change
					Shutter_SetCombos(this, layer, comboPos, openCmb);
				}
				else
					Shutter_SetCombos(this, layer, comboPos, closedCmb);
				//Wait for screen to finish scrolling so Link doesn't get teleported during the animation
				Waitframe();
				while(Link->Action==LA_SCROLLING){
					Waitframe();
				}
			}
			else
				Shutter_Close(this, layer, shutter, openingFrames);
		}
		
		bool wasBlock = false;
		bool blockPuzzle = false;
		if(Shutter_CountBlockTriggers()>0)
			blockPuzzle = true;
			
		int enemyCooldown = 12;
		
		while(true){
			if(openTrigger==1){ //Enemies
				if(enemyCooldown>0)
					enemyCooldown--;
				else{
					if(Shutter_CountNPCs()==0)
						open = true;
				}
			}
			else if(openTrigger==2){ //Block
				if(blockPuzzle){ //Block puzzle secrets should override screens that just have blocks
					if(Shutter_CountBlockTriggers()==0)
						open = true;
				}
				else{
					if(Screen->MovingBlockX>-1||Screen->MovingBlockY>-1)
						wasBlock = true;
					else if(wasBlock)
						open = true;
				}
			}
			else if(openTrigger==3){ //Combo change
				if(triggerCD==Screen->ComboD[triggerPos]){
					open = true;
				}
				else{
					if(!Shutter_LinkCollide(this, dir, Link->X, Link->Y, true))
						open = false;
				}
			}
			else if(openTrigger==4){ //Perm secret
				if(Screen->State[ST_SECRET])
					open = true;
			}
			else if(openTrigger==6){ //Temp Secret
				if(Screen->SecretsTriggered())
					open = true;
			}
			else if(openTrigger==9){ //Enemies (stealth)
				if(enemyCooldown>0)
					enemyCooldown--;
				else{
					if(G[G_STEALTHSPOTTED])
						open = false;
					if(Shutter_CountNPCs()==0)
						open = true;
				}
			}
			if(shutter[SHUTTER_STATE]==0&&Shutter_LinkCollide(this, dir, Link->X, Link->Y, false))
				Shutter_EjectLink(this, dir, specialLayer);
			
			//Open and close the shutter if it should be closed/open but isn't
			if(open&&shutter[SHUTTER_STATE]==0){
				if(shutterCooldown>0)
					shutterCooldown--;
				else
					Shutter_Open(this, layer, shutter, openingFrames);
			}
			else if(!open&&shutter[SHUTTER_STATE]==2){
				Shutter_Close(this, layer, shutter, openingFrames);
				shutterCooldown = SHUTTER_REPEAT_DELAY_FRAMES;
			}
				
			Shutter_Update(this, layer, shutter, openingCmb, openingFrames);
			Waitframe();
		}
	}
	bool Shutter_Update(ffc this, int layer, int shutter, int openingCmb, int openingFrames){
		int SHUTTER_STATE = 0;
		int SHUTTER_FRAMES = 1;
		int SHUTTER_OPENCMB = 2;
		int SHUTTER_CLOSEDCMB = 3;
		int SHUTTER_COMBOPOS = 4;
		int curFrame;
		if(shutter[SHUTTER_STATE]==1){ //Opening
			if(shutter[SHUTTER_FRAMES]>0){
				shutter[SHUTTER_FRAMES]--;
				curFrame = Clamp(Floor((SHUTTER_OPEN_FRAMES-shutter[SHUTTER_FRAMES])/(SHUTTER_OPEN_FRAMES/openingFrames)), 0, openingFrames-1);
				Shutter_SetCombos(this, layer, shutter[SHUTTER_COMBOPOS], openingCmb+curFrame*(4*this->TileHeight));
			}
			else{
				Shutter_SetCombos(this, layer, shutter[SHUTTER_COMBOPOS], shutter[SHUTTER_OPENCMB]);
				shutter[SHUTTER_STATE] = 2; //Open
			}
		}
		else if(shutter[SHUTTER_STATE]==3){ //Closing
			if(shutter[SHUTTER_FRAMES]>0){
				shutter[SHUTTER_FRAMES]--;
				curFrame = Clamp(Floor(shutter[SHUTTER_FRAMES]/(SHUTTER_OPEN_FRAMES/openingFrames)), 0, openingFrames-1);
				Shutter_SetCombos(this, layer, shutter[SHUTTER_COMBOPOS], openingCmb+curFrame*(4*this->TileHeight));
			}
			else{
				Shutter_SetCombos(this, layer, shutter[SHUTTER_COMBOPOS], shutter[SHUTTER_CLOSEDCMB]);
				shutter[SHUTTER_STATE] = 0; //Closed
			}
		}
	}
	void Shutter_Open(ffc this, int layer, int shutter, int openingFrames){
		int SHUTTER_STATE = 0;
		int SHUTTER_FRAMES = 1;
		int SHUTTER_OPENCMB = 2;
		int SHUTTER_CLOSEDCMB = 3;
		int SHUTTER_COMBOPOS = 4;
		Game->PlaySound(SFX_SHUTTER_OPEN);
		if(openingFrames==0){
			Shutter_SetCombos(this, layer, shutter[SHUTTER_COMBOPOS], shutter[SHUTTER_OPENCMB]);
			shutter[SHUTTER_STATE] = 2; //Open
		}
		else{
			shutter[SHUTTER_STATE] = 1; //Opening
			shutter[SHUTTER_FRAMES] = SHUTTER_OPEN_FRAMES;
		}
	}
	void Shutter_Close(ffc this, int layer, int shutter, int openingFrames){
		int SHUTTER_STATE = 0;
		int SHUTTER_FRAMES = 1;
		int SHUTTER_OPENCMB = 2;
		int SHUTTER_CLOSEDCMB = 3;
		int SHUTTER_COMBOPOS = 4;
		Game->PlaySound(SFX_SHUTTER_CLOSE);
		if(openingFrames==0){
			Shutter_SetCombos(this, layer, shutter[SHUTTER_COMBOPOS], shutter[SHUTTER_CLOSEDCMB]);
			shutter[SHUTTER_STATE] = 0; //Closed
		}
		else{
			shutter[SHUTTER_STATE] = 3; //Closing
			shutter[SHUTTER_FRAMES] = SHUTTER_OPEN_FRAMES;
		}
	}
	bool Shutter_SetCombos(ffc this, int layer, int comboPos, int cmb){
		int w = this->TileWidth;
		int h = this->TileHeight;
		for(int x=0; x<w; x++){
			for(int y=0; y<h; y++){
				SetLayerComboD(layer, comboPos+x+y*16, cmb+x+y*4);
				if(SHUTTER_USE_FFC_CSET)
					__SetLayerComboC(layer, comboPos+x+y*16, this->CSet);
				//Screen->ComboD[comboPos+x+y*16] = cmb+x+y*4;
			}
		}
	}
	bool Shutter_LinkCollide(ffc this, int dir, int linkX, int linkY, bool fullTile){
		if(Link->Action==LA_SCROLLING) //||Link->X<0||Link->X>240||Link->Y<0||Link->Y>160)
			return false;
		int w = this->TileWidth;
		int h = this->TileHeight;
		int offset = 0;
		if(fullTile) 
			offset = 16;
		if(dir==DIR_UP){
			return (linkX>=this->X-16 && linkX<=this->X+w*16 && linkY <= Max(this->Y+h*16-16+offset-8, 0));
		}
		else if(dir==DIR_DOWN){
			return (linkX>=this->X-16 && linkX<=this->X+w*16 && linkY >= this->Y-offset);
		}
		else if(dir==DIR_LEFT){
			return (linkY>=this->Y-16 && linkY<=this->Y+h*16 && linkX <= this->X+w*16-16+offset);
		}
		else if(dir==DIR_RIGHT){
			return (linkY>=this->Y-16 && linkY<=this->Y+h*16 && linkX >= this->X-offset);
		}
	}
	bool Shutter_MoveLink(int dir){
		NoAction();
		if(dir==DIR_UP){
			Link->InputDown = true;
			if(!CanWalk(Link->X, Link->Y, DIR_DOWN, 1, false))
				Link->Y++;
		}
		else if(dir==DIR_DOWN){
			Link->InputUp = true;
			if(!CanWalk(Link->X, Link->Y, DIR_UP, 1, false))
				Link->Y--;
		}
		else if(dir==DIR_LEFT){
			Link->InputRight = true;
			if(!CanWalk(Link->X, Link->Y, DIR_RIGHT, 1, false))
				Link->X++;
		}
		else if(dir==DIR_RIGHT){
			Link->InputLeft = true;
			if(!CanWalk(Link->X, Link->Y, DIR_LEFT, 1, false))
				Link->X--;
		}
	}
	bool Shutter_EjectLink(ffc this, int dir, int specialLayer){
		if(specialLayer){
			if(specialLayer-1!=G[G_OVERUNDERLAYER])
				return false;
		}
		if(dir==DIR_UP)
			Link->Y = this->Y+this->TileHeight*16-8;
		else if(dir==DIR_DOWN)
			Link->Y = this->Y-16;
		else if(dir==DIR_LEFT)
			Link->X = this->X+this->TileWidth*16;
		else if(dir==DIR_RIGHT)
			Link->X = this->X-16;
	}
	int Shutter_CountNPCs(){
		int count;
		for(int i=Screen->NumNPCs(); i>=1; i--){
			npc n = Screen->LoadNPC(i);
			if(n->MiscFlags&(1<<3)) //Doesn't count as a beatable enemy flag
				continue;
			if(n->Type==NPCT_GUY||n->Type==NPCT_TRAP||n->Type==NPCT_PROJECTILE||n->Type==NPCT_NONE||n->Type==NPCT_FAIRY)
				continue;
			if(n->Type==NPCT_ZORA) //Borderline if this should be a skippable enemy. I believe most ZC behaviors skip it, so I've put it here
				continue;
			count++;
		}
		return count;
	}
	int Shutter_CountBlockTriggers(){
		int count;
		for(int i=0; i<176; i++){
			if(ComboFI(i, CF_BLOCKTRIGGER))
				count++;
		}
		return count;
	}
	//A shorthand way to set a combo on the current layer.
	//Layer 0 is the screen itself.
	void __SetLayerComboC(int layer, int pos, int cset) {
	  if (layer == 0)
		Screen->ComboC[pos] = cset;
	  else
		Game->SetComboCSet(Screen->LayerMap(layer), Screen->LayerScreen(layer), pos, cset);
	}
}

//LttP Locked Door
//D0: Direction to the wall the door is on - 0: Up, 1: Down, 2: Left, 3: Right
//D1: Special ID of the door (0 for none, 1-16). Be sure to match it with the door on the other side so both open properly.
//D6: If using an opening animation, this is the first of the combo groups, starting with a closed door.
//	  Opening combo groups should be arranged vertically and be made up of doors the same size as the FFC.
//D7: If using an opening animation, this is the number of frames in the animation.
ffc script LttP_LockedDoor{
	void run(int dir, int id, int d2, int d3, int d4, int layer, int openingCmb, int openingFrames){
		int comboPos = ComboAt(this->X+8, this->Y+8);
		
		int closedCmb = this->Data;
		int openCmb = this->Data+4*this->TileHeight;
		this->Data = SHUTTER_INVISIBLE_COMBO;
		
		//Uncheck flags that make the FFC invisible during scrolling
		this->Flags[FFCF_LENSVIS] = false;
		this->Flags[FFCF_CHANGER] = false;
		
		//Set opening combo relative to the open and closed states if not set
		if(openingCmb==0&&openingFrames>0){
			openingCmb = closedCmb+2*(4*this->TileHeight);
		}
		
		// >using variables as labels
		// shiggydiggy
		int SHUTTER_STATE = 0; //0 = Closed, 1 = Opening, 2 = Open, 3 = Closing
		int SHUTTER_FRAMES = 1;
		int SHUTTER_OPENCMB = 2;
		int SHUTTER_CLOSEDCMB = 3;
		int SHUTTER_COMBOPOS = 4;
		int shutter[16] = {0, 0, openCmb, closedCmb, comboPos};
		
		//If screen D bit is set, open the door
		if(LockedDoor_CheckD(dir, id)){
			if(this->Flags[FFCF_PRELOAD]){
				LockedDoor_SetCombos(this, layer, comboPos, openCmb);
				Quit();
			}
			else{
				LockedDoor_Open(this, layer, shutter, openingFrames);
			}
		}
		else{
			LockedDoor_SetCombos(this, layer, comboPos, closedCmb);
		}
		
		int lockCount = SHUTTER_LOCK_ACTIVATION_FRAMES;
		while(true){
			if(shutter[SHUTTER_STATE]==0){ //Closed
				if(LockedDoor_DetectOpen(this, dir)){
					if(lockCount>0)
						lockCount--;
					else if(LockedDoor_HasKey()){
						LockedDoor_Open(this, layer, shutter, openingFrames);
						LockedDoor_SetD(dir, id);
						LockedDoor_TakeKey();
					}
				}
				else
					lockCount = SHUTTER_LOCK_ACTIVATION_FRAMES;
			}
			LockedDoor_Update(this, layer, shutter, openingCmb, openingFrames);
			Waitframe();
		}
	}
	bool LockedDoor_Update(ffc this, int layer, int shutter, int openingCmb, int openingFrames){
		int SHUTTER_STATE = 0;
		int SHUTTER_FRAMES = 1;
		int SHUTTER_OPENCMB = 2;
		int SHUTTER_CLOSEDCMB = 3;
		int SHUTTER_COMBOPOS = 4;
		int curFrame;
		if(shutter[SHUTTER_STATE]==1){ //Opening
			if(shutter[SHUTTER_FRAMES]>0){
				shutter[SHUTTER_FRAMES]--;
				curFrame = Clamp(Floor((SHUTTER_LOCK_OPEN_FRAMES-shutter[SHUTTER_FRAMES])/(SHUTTER_LOCK_OPEN_FRAMES/openingFrames)), 0, openingFrames-1);
				LockedDoor_SetCombos(this, layer, shutter[SHUTTER_COMBOPOS], openingCmb+curFrame*(4*this->TileHeight));
			}
			else{
				LockedDoor_SetCombos(this, layer, shutter[SHUTTER_COMBOPOS], shutter[SHUTTER_OPENCMB]);
				shutter[SHUTTER_STATE] = 2; //Open
			}
		}
	}
	void LockedDoor_Open(ffc this, int layer, int shutter, int openingFrames){
		int SHUTTER_STATE = 0;
		int SHUTTER_FRAMES = 1;
		int SHUTTER_OPENCMB = 2;
		int SHUTTER_CLOSEDCMB = 3;
		int SHUTTER_COMBOPOS = 4;
		Game->PlaySound(SFX_LOCK_OPEN);
		if(openingFrames==0){
			LockedDoor_SetCombos(this, layer, shutter[SHUTTER_COMBOPOS], shutter[SHUTTER_OPENCMB]);
			shutter[SHUTTER_STATE] = 2; //Open
		}
		else{
			shutter[SHUTTER_STATE] = 1; //Opening
			shutter[SHUTTER_FRAMES] = SHUTTER_OPEN_FRAMES;
		}
	}
	bool LockedDoor_SetCombos(ffc this, int layer, int comboPos, int cmb){
		int w = this->TileWidth;
		int h = this->TileHeight;
		for(int x=0; x<w; x++){
			for(int y=0; y<h; y++){
				SetLayerComboD(layer, comboPos+x+y*16, cmb+x+y*4);
				if(SHUTTER_USE_FFC_CSET)
					__SetLayerComboC(layer, comboPos+x+y*16, this->CSet);
				//Screen->ComboD[comboPos+x+y*16] = cmb+x+y*4;
			}
		}
	}
	bool LockedDoor_DetectOpen(ffc this, int dir){
		int hitboxX;
		int hitboxY;
		if(dir==DIR_UP){
			hitboxX = this->X+this->TileWidth*8-8;
			hitboxY = this->Y+this->TileHeight*16-16;
		}
		else if(dir==DIR_DOWN){
			hitboxX = this->X+this->TileWidth*8-8;
			hitboxY = this->Y;
		}
		else if(dir==DIR_LEFT){
			hitboxX = this->X+this->TileWidth*16-16;
			hitboxY = this->Y+this->TileHeight*8-8;
		}
		else if(dir==DIR_RIGHT){
			hitboxX = this->X;
			hitboxY = this->Y+this->TileHeight*8-8;
		}
		
		if(Link->X>=hitboxX-8&&Link->X<=hitboxX+8&&Link->Y>=hitboxY-16&&Link->Y<=hitboxY&&Link->InputDown&&Link->Dir==DIR_DOWN&&dir<2)
			return true;
		if(Link->X>=hitboxX-8&&Link->X<=hitboxX+8&&Link->Y>=hitboxY&&Link->Y<=hitboxY+8&&Link->InputUp&&Link->Dir==DIR_UP&&dir<2)
			return true;
		if(Link->X>=hitboxX-16&&Link->X<=hitboxX&&Link->Y>=hitboxY-8&&Link->Y<=hitboxY+8&&Link->InputRight&&Link->Dir==DIR_RIGHT&&dir>=2)
			return true;
		if(Link->X>=hitboxX&&Link->X<=hitboxX+16&&Link->Y>=hitboxY-8&&Link->Y<=hitboxY+8&&Link->InputLeft&&Link->Dir==DIR_LEFT&&dir>=2)
			return true;
		return false;
	}
	bool LockedDoor_CheckD(int dir, int id){
		if(id>0)
			return Screen->D[D_LTTPDOORID]&(1<<(Clamp(id-1, 0, 15)));
		else
			return Screen->D[D_LTTPDOORS]&(1<<Clamp(dir, 0, 3));
	}
	void LockedDoor_SetD(int dir, int id){
		int offset;
		if(dir==DIR_UP)
			offset = -16;
		else if(dir==DIR_DOWN)
			offset = 16;
		else if(dir==DIR_LEFT)
			offset = -1;
		else
			offset = 1;
		int nextD;
		if(id>0){
			Screen->D[D_LTTPDOORID] |= (1<<(Clamp(id-1, 0, 15)));
			nextD = Game->GetDMapScreenD(Game->GetCurDMap(), Game->GetCurDMapScreen()+offset, D_LTTPDOORID);
			Game->SetDMapScreenD(Game->GetCurDMap(), Game->GetCurDMapScreen()+offset, D_LTTPDOORID, nextD|(1<<(Clamp(id-1, 0, 15))));
		}
		else{
			Screen->D[D_LTTPDOORS] |= (1<<Clamp(dir, 0, 3));
			nextD = Game->GetDMapScreenD(Game->GetCurDMap(), Game->GetCurDMapScreen()+offset, D_LTTPDOORS);
			Game->SetDMapScreenD(Game->GetCurDMap(), Game->GetCurDMapScreen()+offset, D_LTTPDOORS, nextD|(1<<Clamp(OppositeDir(dir), 0, 3)));
		}
	}
	bool LockedDoor_HasKey(){
		if(Link->Item[I_MAGICKEY])
			return true;
		if(Game->Counter[CR_KEYS]>0)
			return true;
		if(Game->LKeys[Game->GetCurLevel()]>0)
			return true;
		return false;
	}
	void LockedDoor_TakeKey(){
		if(Link->Item[I_MAGICKEY])
			return;
		if(Game->LKeys[Game->GetCurLevel()]>0)
			Game->LKeys[Game->GetCurLevel()]--;
		else if(Game->Counter[CR_KEYS]>0)
			Game->Counter[CR_KEYS]--;
	}
	//A shorthand way to set a combo on the current layer.
	//Layer 0 is the screen itself.
	void __SetLayerComboC(int layer, int pos, int cset) {
	  if (layer == 0)
		Screen->ComboC[pos] = cset;
	  else
		Game->SetComboCSet(Screen->LayerMap(layer), Screen->LayerScreen(layer), pos, cset);
	}
}

//LttP Boss Locked Door
//D0: Direction to the wall the door is on - 0: Up, 1: Down, 2: Left, 3: Right
//D1: Special ID of the door (0 for none, 1-16). Be sure to match it with the door on the other side so both open properly.
//D6: If using an opening animation, this is the first of the combo groups, starting with a closed door.
//	  Opening combo groups should be arranged vertically and be made up of doors the same size as the FFC.
//D7: If using an opening animation, this is the number of frames in the animation.
ffc script LttP_BossLockedDoor{
	void run(int dir, int id, int d2, int d3, int d4, int layer, int openingCmb, int openingFrames){
		int comboPos = ComboAt(this->X+8, this->Y+8);
		
		int closedCmb = this->Data;
		int openCmb = this->Data+4*this->TileHeight;
		this->Data = SHUTTER_INVISIBLE_COMBO;
		
		//Uncheck flags that make the FFC invisible during scrolling
		this->Flags[FFCF_LENSVIS] = false;
		this->Flags[FFCF_CHANGER] = false;
		
		//Set opening combo relative to the open and closed states if not set
		if(openingCmb==0&&openingFrames>0){
			openingCmb = closedCmb+2*(4*this->TileHeight);
		}
		
		// >using variables as labels
		// shiggydiggy
		int SHUTTER_STATE = 0; //0 = Closed, 1 = Opening, 2 = Open, 3 = Closing
		int SHUTTER_FRAMES = 1;
		int SHUTTER_OPENCMB = 2;
		int SHUTTER_CLOSEDCMB = 3;
		int SHUTTER_COMBOPOS = 4;
		int shutter[16] = {0, 0, openCmb, closedCmb, comboPos};
		
		//If screen D bit is set, open the door
		if(BossLockedDoor_CheckD(dir, id)){
			if(this->Flags[FFCF_PRELOAD]){
				BossLockedDoor_SetCombos(this, layer, comboPos, openCmb);
				Quit();
			}
			else{
				BossLockedDoor_Open(this, layer, shutter, openingFrames);
			}
		}
		else{
			BossLockedDoor_SetCombos(this, layer, comboPos, closedCmb);
		}
		
		int lockCount = SHUTTER_LOCK_ACTIVATION_FRAMES;
		while(true){
			if(shutter[SHUTTER_STATE]==0){ //Closed
				if(BossLockedDoor_DetectOpen(this, dir)){
					if(lockCount>0)
						lockCount--;
					else if(BossLockedDoor_HasKey()){
						BossLockedDoor_Open(this, layer, shutter, openingFrames);
						BossLockedDoor_SetD(dir, id);
					}
				}
				else
					lockCount = SHUTTER_LOCK_ACTIVATION_FRAMES;
			}
			BossLockedDoor_Update(this, layer, shutter, openingCmb, openingFrames);
			Waitframe();
		}
	}
	bool BossLockedDoor_Update(ffc this, int layer, int shutter, int openingCmb, int openingFrames){
		int SHUTTER_STATE = 0;
		int SHUTTER_FRAMES = 1;
		int SHUTTER_OPENCMB = 2;
		int SHUTTER_CLOSEDCMB = 3;
		int SHUTTER_COMBOPOS = 4;
		int curFrame;
		if(shutter[SHUTTER_STATE]==1){ //Opening
			if(shutter[SHUTTER_FRAMES]>0){
				shutter[SHUTTER_FRAMES]--;
				curFrame = Clamp(Floor((SHUTTER_LOCK_OPEN_FRAMES-shutter[SHUTTER_FRAMES])/(SHUTTER_LOCK_OPEN_FRAMES/openingFrames)), 0, openingFrames-1);
				BossLockedDoor_SetCombos(this, layer, shutter[SHUTTER_COMBOPOS], openingCmb+curFrame*(4*this->TileHeight));
			}
			else{
				BossLockedDoor_SetCombos(this, layer, shutter[SHUTTER_COMBOPOS], shutter[SHUTTER_OPENCMB]);
				shutter[SHUTTER_STATE] = 2; //Open
			}
		}
	}
	void BossLockedDoor_Open(ffc this, int layer, int shutter, int openingFrames){
		int SHUTTER_STATE = 0;
		int SHUTTER_FRAMES = 1;
		int SHUTTER_OPENCMB = 2;
		int SHUTTER_CLOSEDCMB = 3;
		int SHUTTER_COMBOPOS = 4;
		Game->PlaySound(SFX_BOSS_LOCK_OPEN);
		if(openingFrames==0){
			BossLockedDoor_SetCombos(this, layer, shutter[SHUTTER_COMBOPOS], shutter[SHUTTER_OPENCMB]);
			shutter[SHUTTER_STATE] = 2; //Open
		}
		else{
			shutter[SHUTTER_STATE] = 1; //Opening
			shutter[SHUTTER_FRAMES] = SHUTTER_OPEN_FRAMES;
		}
	}
	bool BossLockedDoor_SetCombos(ffc this, int layer, int comboPos, int cmb){
		int w = this->TileWidth;
		int h = this->TileHeight;
		for(int x=0; x<w; x++){
			for(int y=0; y<h; y++){
				SetLayerComboD(layer, comboPos+x+y*16, cmb+x+y*4);
				if(SHUTTER_USE_FFC_CSET)
					__SetLayerComboC(layer, comboPos+x+y*16, this->CSet);
				//Screen->ComboD[comboPos+x+y*16] = cmb+x+y*4;
			}
		}
	}
	bool BossLockedDoor_DetectOpen(ffc this, int dir){
		int hitboxX;
		int hitboxY;
		if(dir==DIR_UP){
			hitboxX = this->X+this->TileWidth*8-8;
			hitboxY = this->Y+this->TileHeight*16-16;
		}
		else if(dir==DIR_DOWN){
			hitboxX = this->X+this->TileWidth*8-8;
			hitboxY = this->Y;
		}
		else if(dir==DIR_LEFT){
			hitboxX = this->X+this->TileWidth*16-16;
			hitboxY = this->Y+this->TileHeight*8-8;
		}
		else if(dir==DIR_RIGHT){
			hitboxX = this->X;
			hitboxY = this->Y+this->TileHeight*8-8;
		}
		
		if(Link->X>=hitboxX-8&&Link->X<=hitboxX+8&&Link->Y>=hitboxY-16&&Link->Y<=hitboxY&&Link->InputDown&&Link->Dir==DIR_DOWN&&dir<2)
			return true;
		if(Link->X>=hitboxX-8&&Link->X<=hitboxX+8&&Link->Y>=hitboxY&&Link->Y<=hitboxY+8&&Link->InputUp&&Link->Dir==DIR_UP&&dir<2)
			return true;
		if(Link->X>=hitboxX-16&&Link->X<=hitboxX&&Link->Y>=hitboxY-8&&Link->Y<=hitboxY+8&&Link->InputRight&&Link->Dir==DIR_RIGHT&&dir>=2)
			return true;
		if(Link->X>=hitboxX&&Link->X<=hitboxX+16&&Link->Y>=hitboxY-8&&Link->Y<=hitboxY+8&&Link->InputLeft&&Link->Dir==DIR_LEFT&&dir>=2)
			return true;
		return false;
	}
	bool BossLockedDoor_CheckD(int dir, int id){
		if(id>0)
			return Screen->D[D_LTTPDOORID]&(1<<(Clamp(id-1, 0, 15)));
		else
			return Screen->D[D_LTTPDOORS]&(1<<(4+Clamp(dir, 0, 3)));
	}
	void BossLockedDoor_SetD(int dir, int id){
		int offset;
		if(dir==DIR_UP)
			offset = -16;
		else if(dir==DIR_DOWN)
			offset = 16;
		else if(dir==DIR_LEFT)
			offset = -1;
		else
			offset = 1;
		int nextD;
		if(id>0){
			Screen->D[D_LTTPDOORID] |= (1<<(Clamp(id-1, 0, 15)));
			nextD = Game->GetDMapScreenD(Game->GetCurDMap(), Game->GetCurDMapScreen()+offset, D_LTTPDOORID);
			Game->SetDMapScreenD(Game->GetCurDMap(), Game->GetCurDMapScreen()+offset, D_LTTPDOORID, nextD|(1<<(Clamp(id-1, 0, 15))));
		}
		else{
			Screen->D[D_LTTPDOORS] |= (1<<(4+Clamp(dir, 0, 3)));
			nextD = Game->GetDMapScreenD(Game->GetCurDMap(), Game->GetCurDMapScreen()+offset, D_LTTPDOORS);
			Game->SetDMapScreenD(Game->GetCurDMap(), Game->GetCurDMapScreen()+offset, D_LTTPDOORS, nextD|(1<<(4+Clamp(OppositeDir(dir), 0, 3))));
		}
	}
	bool BossLockedDoor_HasKey(){
		if(Game->LItems[Game->GetCurLevel()]&LI_BOSSKEY)
			return true;
		return false;
	}
	//A shorthand way to set a combo on the current layer.
	//Layer 0 is the screen itself.
	void __SetLayerComboC(int layer, int pos, int cset) {
	  if (layer == 0)
		Screen->ComboC[pos] = cset;
	  else
		Game->SetComboCSet(Screen->LayerMap(layer), Screen->LayerScreen(layer), pos, cset);
	}
}

//LttP Bomb Wall
//D0: Direction to the wall the door is on - 0: Up, 1: Down, 2: Left, 3: Right
//D1: Special ID of the door (0 for none, 1-16). Be sure to match it with the door on the other side so both open properly.
ffc script LttP_BombWall{
	void run(int dir, int id, int d2, int d3, int d4, int layer, int d6, int d7){
		int comboPos = ComboAt(this->X+8, this->Y+8);
		
		int openCmb = this->Data;
		int rubbleCmb = this->Data+4*this->TileHeight;
		this->Data = SHUTTER_INVISIBLE_COMBO;
		
		//Uncheck flags that make the FFC invisible during scrolling
		this->Flags[FFCF_LENSVIS] = false;
		this->Flags[FFCF_CHANGER] = false;
		
		//If screen D bit is set, open the door
		if(BombWall_CheckD(dir, id)){
			BombWall_SetCombos(this, layer, comboPos, openCmb);
			BombWall_SetRubble(this, dir, rubbleCmb);
			Quit();
		}
		
		while(true){
			//Draw a hint graphic when using the lens
			if(UsingLens()){
				int x;
				int y;
				if(dir==DIR_UP){
					x = this->X+this->TileWidth*8-8;
					y = this->Y+this->TileHeight*16-16;
				}
				else if(dir==DIR_DOWN){
					x = this->X+this->TileWidth*8-8;
					y = this->Y;
				}
				else if(dir==DIR_LEFT){
					x = this->X+this->TileWidth*16-16;
					y = this->Y+this->TileHeight*8-8;
				}
				else if(dir==DIR_RIGHT){
					x = this->X;
					y = this->Y+this->TileHeight*8-8;
				}
				
				if(CMB_BOMBWALL_MARKER>0)
					Screen->FastCombo(6, x, y, CMB_BOMBWALL_MARKER, CS_BOMBWALL_MARKER, 128);
			}
			
			if(BombWall_DetectOpen(this, dir)){
				BombWall_SetCombos(this, layer, comboPos, openCmb);
				BombWall_SetRubble(this, dir, rubbleCmb);
				BombWall_SetD(dir, id);
				Game->PlaySound(SFX_BOMB_WALL_OPEN);
				Quit();
			}
			
			Waitframe();
		}
	}
	bool BombWall_SetCombos(ffc this, int layer, int comboPos, int cmb){
		int w = this->TileWidth;
		int h = this->TileHeight;
		for(int x=0; x<w; x++){
			for(int y=0; y<h; y++){
				SetLayerComboD(layer, comboPos+x+y*16, cmb+x+y*4);
				if(SHUTTER_USE_FFC_CSET)
					__SetLayerComboC(layer, comboPos+x+y*16, this->CSet);
				//Screen->ComboD[comboPos+x+y*16] = cmb+x+y*4;
			}
		}
	}
	void BombWall_SetRubble(ffc this, int dir, int cmb){
		int rubbleX;
		int rubbleY;
		
		if(dir==DIR_UP){
			rubbleX = this->X+this->TileWidth*8-8;
			rubbleY = this->Y+this->TileHeight*16;
		}
		else if(dir==DIR_DOWN){
			rubbleX = this->X+this->TileWidth*8-8;
			rubbleY = this->Y-16;
		}
		else if(dir==DIR_LEFT){
			rubbleX = this->X+this->TileWidth*16;
			rubbleY = this->Y+this->TileHeight*8-8;
		}
		else if(dir==DIR_RIGHT){
			rubbleX = this->X-16;
			rubbleY = this->Y+this->TileHeight*8-8;
		}
		
		this->Data = cmb;
		this->X = rubbleX;
		this->Y = rubbleY;
		this->TileWidth = 1;
		this->TileHeight = 1;
		this->Flags[FFCF_ETHEREAL] = true;
	}
	bool BombWall_DetectOpen(ffc this, int dir){
		int hitboxX;
		int hitboxY;
		if(dir==DIR_UP){
			hitboxX = this->X+this->TileWidth*8-8;
			hitboxY = this->Y+this->TileHeight*16-16;
		}
		else if(dir==DIR_DOWN){
			hitboxX = this->X+this->TileWidth*8-8;
			hitboxY = this->Y;
		}
		else if(dir==DIR_LEFT){
			hitboxX = this->X+this->TileWidth*16-16;
			hitboxY = this->Y+this->TileHeight*8-8;
		}
		else if(dir==DIR_RIGHT){
			hitboxX = this->X;
			hitboxY = this->Y+this->TileHeight*8-8;
		}
		
		for(int i=Screen->NumLWeapons(); i>=1; i--){
			lweapon l = Screen->LoadLWeapon(i);
			if(l->CollDetection&&l->DeadState==WDS_ALIVE){
				if(l->ID==LW_BOMBBLAST||l->ID==LW_SBOMBBLAST){
					if(RectCollision(l->X+l->HitXOffset, l->Y+l->HitYOffset, l->X+l->HitXOffset+l->HitWidth-1, l->Y+l->HitYOffset+l->HitHeight-1, hitboxX, hitboxY, hitboxX+15, hitboxY+15)){
						return true;
					}
				}
			}
		}
		return false;
	}
	bool BombWall_CheckD(int dir, int id){
		if(id>0)
			return Screen->D[D_LTTPDOORID]&(1<<(Clamp(id-1, 0, 15)));
		else
			return Screen->D[D_LTTPDOORS]&(1<<(8+Clamp(dir, 0, 3)));
	}
	void BombWall_SetD(int dir, int id){
		int offset;
		if(dir==DIR_UP)
			offset = -16;
		else if(dir==DIR_DOWN)
			offset = 16;
		else if(dir==DIR_LEFT)
			offset = -1;
		else
			offset = 1;
		int nextD;
		if(id>0){
			Screen->D[D_LTTPDOORID] |= (1<<(Clamp(id-1, 0, 15)));
			nextD = Game->GetDMapScreenD(Game->GetCurDMap(), Game->GetCurDMapScreen()+offset, D_LTTPDOORID);
			Game->SetDMapScreenD(Game->GetCurDMap(), Game->GetCurDMapScreen()+offset, D_LTTPDOORID, nextD|(1<<(Clamp(id-1, 0, 15))));
		}
		else{
			Screen->D[D_LTTPDOORS] |= (1<<(8+Clamp(dir, 0, 3)));
			nextD = Game->GetDMapScreenD(Game->GetCurDMap(), Game->GetCurDMapScreen()+offset, D_LTTPDOORS);
			Game->SetDMapScreenD(Game->GetCurDMap(), Game->GetCurDMapScreen()+offset, D_LTTPDOORS, nextD|(1<<(8+Clamp(OppositeDir(dir), 0, 3))));
		}
	}
	//A shorthand way to set a combo on the current layer.
	//Layer 0 is the screen itself.
	void __SetLayerComboC(int layer, int pos, int cset) {
	  if (layer == 0)
		Screen->ComboC[pos] = cset;
	  else
		Game->SetComboCSet(Screen->LayerMap(layer), Screen->LayerScreen(layer), pos, cset);
	}
}

ffc script StealthShutterTrigger{
	void run(){
		int pos = ComboAt(this->X, this->Y);
		int cmb = this->Data;
		while(true){
			if(G[G_STEALTHSPOTTED]&&EnemiesAlive())
				Screen->ComboD[pos] = cmb+1;
			else
				Screen->ComboD[pos] = cmb;
			Waitframe();
		}
	}
}

ffc script BlockHole{
	void run(){
		while(true){
			if(Screen->MovingBlockX>-1){
				if(Abs(Screen->MovingBlockX-this->X)<2&&Abs(Screen->MovingBlockY-this->Y)<2){
					++Screen->ComboD[ComboAt(this->X+8, this->Y+8)];
					Quit();
				}
			}
			Waitframe();
		}
	}
}

ffc script ContinuePoint{
	bool CompareDMap(int src, int dest){
		//Special exception for Mt. Silver. I didn't need to do this, but I wanted the summit to be a continue point and there's a music transition.
		switch(src){
			case 41: src = 40; break;
		}
		switch(dest){
			case 41: dest = 40; break;
		}
		return src == dest;
	}
	void run(int type, int dmap, int screen){
		if(G[G_MULTIPLAYERACTIVE])
			UpdateDockUserlist(Game->GetCurDMap());
		if(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_13){
			Game->Counter[CR_SMALLSIDEQUESTS1] = Game->Counter[CR_SMALLSIDEQUESTS1] & ~BF_13;
			if(Game->Counter[CR_NIGHTMARCHERQUEST] == 6)
				Game->Counter[CR_NIGHTMARCHERQUEST] = 5;
		}
		if(type == 0){ //Continue here
			if(!CompareDMap(Game->GetCurDMap(), Game->ContinueDMap)){
				G[G_CONTINUEDMAP] = Game->GetCurDMap();
				G[G_CONTINUESCREEN] = Game->GetCurScreen();
				G[G_LASTENTRANCEDMAP] = Game->GetCurDMap();
				G[G_LASTENTRANCESCREEN] = Game->GetCurScreen();
				Game->ContinueDMap = Game->GetCurDMap();
				Game->ContinueScreen = Game->GetCurScreen();
				Game->LastEntranceDMap = Game->GetCurDMap();
				Game->LastEntranceScreen = Game->GetCurScreen();
			}
		}
		if(type == 1){
			G[G_CONTINUEDMAP] = dmap;
			G[G_CONTINUESCREEN] = screen;
			G[G_LASTENTRANCEDMAP] = dmap;
			G[G_LASTENTRANCESCREEN] = screen;
			Game->ContinueDMap = dmap;
			Game->LastEntranceDMap = dmap;
			Game->ContinueScreen = screen;
			Game->LastEntranceScreen = screen;
		}
	}
}

screendata script BossContinue{
	void run(){
		G[G_LASTENTRANCEDMAP] = Game->GetCurDMap();
		G[G_LASTENTRANCESCREEN] = Game->GetCurScreen();
		Game->LastEntranceDMap = Game->GetCurDMap();
		Game->LastEntranceScreen = Game->GetCurScreen();
		G[G_TEMPLASTENTRANCE] = 1;
	}
}

const int MAP_SHOALWAVES1 = 16;
const int SCRN_SHOALWAVES1 = 0x10;
const int MAP_SHOALWAVES2 = 16;
const int SCRN_SHOALWAVES2 = 0x11;

ffc script ShoalWaves{
	bool PushingExceptions(mapdata filter, int pos){
		return (filter->ComboI[pos]==99||filter->ComboD[pos]==7647)&&!(Screen->ComboD[pos]>=7352&&Screen->ComboD[pos]<=7413);
	}
	void DrawWaves(int wavemap, int wavescrn, int x, int y){
		GBMP[BMP_SHALLOWSWAVES]->Clear(0);
		GBMP[BMP_SHALLOWSWAVES2]->Clear(0);
		
		GBMP[BMP_SHALLOWSWAVES]->DrawLayer(0, MAP_SHOALWAVES1, SCRN_SHOALWAVES1, 0, 0, 0, 0, 128);
		GBMP[BMP_SHALLOWSWAVES2]->DrawLayer(0, MAP_SHOALWAVES2, SCRN_SHOALWAVES2, 0, 0, 0, 0, 128);
		GBMP[BMP_SHALLOWSWAVES2]->ReplaceColors(0, 0x00, 0x46, 0x4D);
		
		GBMP[BMP_SHALLOWSWAVES2]->Blit(0, GBMP[BMP_SHALLOWSWAVES], 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
		GBMP[BMP_SHALLOWSWAVES2]->Clear(0);
		
		GBMP[BMP_SHALLOWSWAVES2]->DrawLayer(0, wavemap, wavescrn, 0, x, y, 0, 128);
		GBMP[BMP_SHALLOWSWAVES]->Blit(0, GBMP[BMP_SHALLOWSWAVES2], 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
		
		GBMP[BMP_SHALLOWSWAVES2]->ReplaceColors(1, 0x00, 0x01, 0x01);
		GBMP[BMP_SHALLOWSWAVES2]->Blit(1, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
	}
	int MovingScreenComboPos(int layerX, int layerY, int x, int y){
		x -= layerX;
		y -= layerY;
		if(x<0||x>255||y<0||y>175)
			return -1;
		return ComboAt(x, y);
	}
	bool IsSpecialShallowWater(int x, int y){
		for(int i=0; i<4; ++i){
			int tmpx = x+(i%2);
			int tmpy = y+Floor(i/2);
			switch(Screen->ComboD[ComboAt(tmpx, tmpy)]){
				case 6912...6915:
				case 6924...6926:
				case 6928:
				case 6929:
				case 6932:
				case 6933:
				case 6936:
				case 6937:
					return true;
				default:
					break;
			}
		}
		return false;
	}
	bool IsShoreline(mapdata l1, int x, int y){
		for(int i=0; i<4; ++i){
			int tmpx = x+(i%2);
			int tmpy = y+Floor(i/2);
			int pos = ComboAt(tmpx, tmpy);
			if(isShorelineCombo(Screen->ComboD[pos], false)||isShorelineCombo(l1->ComboD[pos], false)){
				return true;
			}
		}
		return false;
	}
	void run(int dir, int delay, int step){
		int wavemap = 16;
		int wavescrn;
		int waveX; int waveY;
		int frames;
		int vX; int vY;
		switch(dir){
			case DIR_UP:
				wavescrn = 0x00;
				frames = 176+16;
				waveY = 176;
				vY = -step;
				break;
			case DIR_DOWN:
				wavescrn = 0x01;
				frames = 176+16;
				waveY = -16;
				vY = step;
				break;
			case DIR_LEFT:
				wavescrn = 0x02;
				frames = 256+16;
				waveX = 256;
				vX = -step;
				break;
			case DIR_RIGHT:
				wavescrn = 0x03;
				frames = 256+16;
				waveX = -16;
				vX = step;
				break;
		}
		mapdata l1 = Game->LoadTempScreen(1);
		mapdata filter = Game->LoadMapData(MAP_SHOALWAVES1, SCRN_SHOALWAVES1);
		mapdata filter2 = Game->LoadMapData(MAP_SHOALWAVES2, SCRN_SHOALWAVES2);
		// mapdata l6 = Game->LoadTempScreen(6);
		// l6->Valid = 1;
		
		mapdata wavemapscr = Game->LoadMapData(wavemap, wavescrn);
		for(int i=0; i<176; ++i){
			filter2->ComboD[i] = 0;
			if(l1->ComboD[i]>=7352&&l1->ComboD[i]<=7413){
				filter2->ComboD[i] = l1->ComboD[i];
				filter2->ComboC[i] = 4;
			}
			switch(Screen->ComboD[i]){
				case 6932:
				case 6933:
				case 6936:
				case 6937:
					filter->ComboD[i] = 7646;
					filter->ComboC[i] = 0;
					break;
				case 6912:
				case 6913:
				case 6914:
				case 6915:
				case 6916:
				case 6917:
				case 6918:
				case 6919:
				case 6920:
				case 6921:
				case 6922:
				case 6923:
				case 6924:
				case 6925:
				case 6926:
				case 6927:
				case 6928:
				case 6929:
					filter->ComboD[i] = Screen->ComboD[i] + (7632-6912);
					filter->ComboC[i] = 0;
					break;
				default:
					filter->ComboD[i] = 7647;
					filter->ComboC[i] = 0;
					break;
			}
			// l6->ComboD[i] = Rand(100);
			// printf("ComboD[%d] is %d\n", i, l6->ComboD[i]);
		}
		while(true){
			Waitframes(delay);
			waveX = 0; waveY = 0;
			vX = 0; vY = 0;
			Game->PlaySound(26);
			switch(dir){
				case DIR_UP:
					frames = 176+16;
					waveY = 176;
					vY = -step;
					break;
				case DIR_DOWN:
					frames = 176+16;
					waveY = -16;
					vY = step;
					break;
				case DIR_LEFT:
					frames = 256+16;
					waveX = 256;
					vX = -step;
					break;
				case DIR_RIGHT:
					frames = 256+16;
					waveX = -16;
					vX = step;
					break;
			}
			for(int i=0; i<frames; i+=step){
				waveX += vX;
				waveY += vY;
				int poswave = MovingScreenComboPos(waveX, waveY, Link->X+8, Link->Y+12);
				int pos = ComboAt(Link->X+8, Link->Y+12);
				if(poswave>-1){
					if(!InWater()&&(Screen->ComboT[pos]==CT_WATER||Screen->ComboT[pos]==CT_SHALLOWWATER)&&wavemapscr->ComboT[poswave]==CT_SHALLOWWATER&&!(IsShoreline(l1, Link->X+7, Link->Y+11)&&!IsSpecialShallowWater(Link->X+7, Link->Y+11))){ //!(isShorelineCombo(Screen->ComboD[pos], false)||isShorelineCombo(l1->ComboD[pos], false)) ){ //&&!PushingExceptions(filter, pos)
						LinkMovement_Push2NoEdge(vX+Sign(vX)*1.5, vY+Sign(vY)*1.5);
					}
				}
				Waitdraw();
				DrawWaves(wavemap, wavescrn, waveX, waveY);
				Waitframe();
			}
		}
	}
}
	
ffc script CircularMotion{
	void run(int angle, int rot, int dist){
		int centerX = this->X;
		int centerY = this->Y;
		while(true){
			this->X = centerX+VectorX(dist, angle);
			this->Y = centerY+VectorY(dist, angle);
			angle = WrapDegrees(angle+rot);
			if(GetDamageComboDamage(this->Data)>0){
				eweapon hitbox = MakeHitbox(EW_PHYSICAL, this->X, this->Y, 16, 16, GetDamageComboDamage(this->Data));
				hitbox->Z = Link->Z;
			}
			Waitframe();
		}
	}
}

const int D_RANDOTOTEM = 7;

ffc script UpgradeTotems{
	void run(int id){
		
		int nH1[] = "Asher Health Upgrade";
		int nH2[] = "Torrin Health Upgrade";
		int nH3[] = "Kaylani Health Upgrade";
		int nD1[] = "Asher Augment Upgrade";
		int nD2[] = "Torrin Augment Upgrade";
		int nD3[] = "Kaylani Augment Upgrade";
		int nDa1[] = "Dash";
		int nDa2[] = "Counter Dash";
		int nM1[] = "Stellaire";
		int nSt1[] = "Black Belt";
		int nSo1[] = "Solar Might";
		int nO1[] = "Solar System";
		int nDo1[] = "Sun Dog";
		int nL1[] = "Solar Flare";
		
		int H1[] = "An extra health container for Asher.";
		int H2[] = "An extra health container for Torrin.";
		int H3[] = "An extra health container for Kaylani.";
		int D1[] = "An extra augment slot for Asher.";
		int D2[] = "An extra augment slot for Torrin.";
		int D3[] = "An extra augment slot for Kaylani.";
		int Da1[] = "Dash to quickly escape harm.";
		int Da2[] = "Dashing through enemies or projectiles with the right timing will grant brief invulnerability and perform a counter attack.";
		int M1[] = "Drop a meteor from the sky to damage all enemies and set the area aflame for thirty seconds.";
		int St1[] = "Punches deal more damage. Hold the button when attacking to target an enemy, allowing you to strafe around them and auto-aim attacks.";
		int So1[] = "Solar Ball can be charged more to travel further and grow larger with distance.";
		int O1[] = "Hold the button to charge an orbiting attack. The longer the charge, the more obitors, but charging too long will cause it to fail.";
		int Do1[] = "Summon a doppelganger that fires on your command.";
		int L1[] = "Fire a laser that grows in damage the longer it is held on an enemy.";
		
		int String1[] = "You bear traces of something I have not felt in ages. Most unexpected. Bring me Hymnstones, and in return I shall grant you new power.";
		int String2[] = "Can you feel the undercurrents of shifting fate beneath your feet? A time of change approaches.";
		int String3[] = "The Hymnstones sing of the coming shift, and of the fulfillment of their great purpose. Allow me to bestow unto you a portion of that melody.";
		int String4[] = "Even as the tremors foretell something new, I fear one of you has become hopelessly entangled in fate's grand tragedy. Perhaps this can be avoided yet. Perhaps not. Take my power, and let us see how you fare against the inevitable.";
		
		int StringArray[] = {String1, String2, String3, String4};
		
		int String5[] = "I have nothing more to offer you. Go, and bear witness to what shall soon unfold.";
		int String6[] = "At the moment, I can do nothing more for you, though I feel this shall soon change.";
		
		//						 0,   1,   2,   3,   4,   5,   6,   7,   8,   9,   10,  11,  12,   13,      14,     15,     16,       17,    18,     19
		//						Hearts Asher    Torrin         Kaylani        Attack Ups     Dash  Upgrade  Meteor  Strafe  Sound Up  Orbit  Doppel  Laser
		int ItemIDs[] = 		{256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 170,  182,     172,    162,    163,      167,   168,    169};
		int Character[] = 		{0,   0,   0,   1,   1,   1,   2,   2,   2,   0,   1,   2,   0,    0,       0,      1,      2,        2,     2,      2};
		int Cost[] = 			{2,   3,   4,   2,   3,   4,   2,   3,   4,   5,   5,   5,   1,    6,       6,      6,      6,        6,     6,      6};
		// int StoryFlag[] = 		{0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,    0,       1,      0,      0,        0,     0,      0};
		int Descriptions[] = 	{H1,  H1,  H1,  H2,  H2,  H2,  H3,  H3,  H3,  D1,  D2,  D3,  Da1,  Da2,     M1,     St1,    So1,      O1,    Do1,    L1};
		int Names[] = 			{nH1, nH1, nH1, nH2, nH2, nH2, nH3, nH3, nH3, nD1, nD2, nD3, nDa1, nDa2,    nM1,    nSt1,   nSo1,     nO1,   nDo1,   nL1};
		int ItemLocs[20];
		//Only 85 needed now
		
		if(G[G_RANDOMIZERENABLED]){
			//Costs are lowered in randomizer to account for there possibly being fewer hymnstones
			for(int i=0; i<20; ++i){
				Cost[i] = Max(Cost[i]-1, 1);
			}

			ItemIDs[0] = RandomizedItems[IL_TOTEM1_ASHERHEART1];
			ItemLocs[0] = IL_TOTEM1_ASHERHEART1;
			ItemIDs[1] = RandomizedItems[IL_TOTEM2_ASHERHEART2];
			ItemLocs[1] = IL_TOTEM2_ASHERHEART2;
			ItemIDs[2] = RandomizedItems[IL_TOTEM4_ASHERHEART3];
			ItemLocs[2] = IL_TOTEM4_ASHERHEART3;
			ItemIDs[3] = RandomizedItems[IL_TOTEM1_TORRINHEART1];
			ItemLocs[3] = IL_TOTEM1_TORRINHEART1;
			ItemIDs[4] = RandomizedItems[IL_TOTEM2_TORRINHEART2];
			ItemLocs[4] = IL_TOTEM2_TORRINHEART2;
			ItemIDs[5] = RandomizedItems[IL_TOTEM4_TORRINHEART3];
			ItemLocs[5] = IL_TOTEM4_TORRINHEART3;
			ItemIDs[6] = RandomizedItems[IL_TOTEM1_KAYLANIHEART1];
			ItemLocs[6] = IL_TOTEM1_KAYLANIHEART1;
			ItemIDs[7] = RandomizedItems[IL_TOTEM2_KAYLANIHEART2];
			ItemLocs[7] = IL_TOTEM2_KAYLANIHEART2;
			ItemIDs[8] = RandomizedItems[IL_TOTEM4_KAYLANIHEART3];
			ItemLocs[8] = IL_TOTEM4_KAYLANIHEART3;
			ItemIDs[9] = RandomizedItems[IL_TOTEM3_ASHERAUGMENTSLOT1];
			ItemLocs[9] = IL_TOTEM3_ASHERAUGMENTSLOT1;
			ItemIDs[10] = RandomizedItems[IL_TOTEM3_TORRINAUGMENTSLOT1];
			ItemLocs[10] = IL_TOTEM3_TORRINAUGMENTSLOT1;
			ItemIDs[11] = RandomizedItems[IL_TOTEM3_KAYLANIAUGMENTSLOT1];
			ItemLocs[11] = IL_TOTEM3_KAYLANIAUGMENTSLOT1;
			
			ItemIDs[12] = RandomizedItems[IL_TOTEM1_ASHERDASH];
			ItemLocs[12] = IL_TOTEM1_ASHERDASH;
			ItemIDs[13] = RandomizedItems[IL_TOTEM3_DASHCOUNTER];
			ItemLocs[13] = IL_TOTEM3_DASHCOUNTER;
			ItemIDs[14] = RandomizedItems[IL_TOTEM4_STELLAIRE];
			ItemLocs[14] = IL_TOTEM4_STELLAIRE;
			ItemIDs[15] = RandomizedItems[IL_TOTEM2_BLACKBELT];
			ItemLocs[15] = IL_TOTEM2_BLACKBELT;
			ItemIDs[16] = RandomizedItems[IL_TOTEM3_SOLARMIGHT];
			ItemLocs[16] = IL_TOTEM3_SOLARMIGHT;
			ItemIDs[17] = RandomizedItems[IL_TOTEM1_SOLARSYSTEM];
			ItemLocs[17] = IL_TOTEM1_SOLARSYSTEM;
			ItemIDs[18] = RandomizedItems[IL_TOTEM2_SUNDOG];
			ItemLocs[18] = IL_TOTEM2_SUNDOG;
			ItemIDs[19] = RandomizedItems[IL_TOTEM4_SOLARFLARE];
			ItemLocs[19] = IL_TOTEM4_SOLARFLARE;
			
			for(int i=0; i<20; ++i){
				ItemIDs[i] = ProcessRandomizerItem(ItemLocs[i], ItemIDs[i]);
			}
		}
		
		//Totems:
		//1:  AH, TH, KH, Dash, Orbit
		//2:  AH, TH, KH, Strafe, Doppel
		//3:  All augment slots, Dash Upgrade, Sound Up
		//4:  AH, TH, KH, Meteor, Laser
		int Totem1[] = {0, 3, 6, 12, 17};
		int Totem2[] = {1, 4, 7, 15, 18};
		int Totem3[] = {9, 10, 11, 13, 16};
		int Totem4[] = {2, 5, 8, 14, 19};
		int Totems[] = {Totem1, Totem2, Totem3, Totem4};
		
		int rN1[256];
		int rN2[256];
		int rN3[256];
		int rN4[256];
		int rN5[256];
		int randoNames[5] = {rN1, rN2, rN3, rN4, rN5};
		int rD1[512];
		int rD2[512];
		int rD3[512];
		int rD4[512];
		int rD5[512];
		int randoDescs[5] = {rD1, rD2, rD3, rD4, rD5};
		
		if(G[G_RANDOMIZERENABLED]){
			for(int i=0; i<5; ++i){
				int tempTotem = Totems[id];
				ItemName(randoNames[i], ItemIDs[tempTotem[i]]);
				ItemDesc(randoDescs[i], ItemIDs[tempTotem[i]]);
			}
		}
	
	
		int Xoff = -16;
		int comboloc = ComboAt(this->X, this->Y) - 32;
		SetLayerComboD(3, comboloc, 11558);
		SetLayerComboD(3, comboloc+1, 11559);
				
		while(true){
			if(Link->Dir == DIR_UP && Link->Y >= this->Y + 8 && Link->Y <= this->Y + 24 && Link->X >= this->X - 8 && Link->X <= this->X + 8){
				Screen->FastCombo(6, this->X, this->Y-16-8, CMB_CANTALK, 0, 128);
				if(Link->PressA){
					Link->PressA = false;
					Link->InputA = false;
					
					int CurrentOption;
					int CurMax = 4;
					int CurMin = 0;
					int RealMax = 0;
					int TotAv = 0;
					int InvName[5];
					int InvStr[5];
					int InvPrice[5];
					int InvChar[5];
					int InvID[5];
					int InvD[5];
					int InvLoc[5];
					itemsprite InvSprites[5];
					int Pull = Totems[id];
					for(int i = 0; i<5; i++){
						if(!FoundItems[ItemIDs[Pull[i]]])
							TotAv++;
						if(G[G_RANDOMIZERENABLED]){
							if(!(Screen->D[D_RANDOTOTEM]&(1<<i))){
								InvName[RealMax] = randoNames[i];
								InvStr[RealMax] = randoDescs[i];
								InvPrice[RealMax]  = Cost[Pull[i]];
								InvID[RealMax] = ItemIDs[Pull[i]];
								InvChar[RealMax]  = Character[Pull[i]];
								InvLoc[RealMax] = ItemLocs[Pull[i]];
								InvD[RealMax] = i;
								InvSprites[RealMax] = CreateItemAt(InvID[RealMax], 120, -32);
								InvSprites[RealMax]->Pickup = IP_DUMMY;
								RealMax++;
							}
						}
						else{
							if(!FoundItems[ItemIDs[Pull[i]]] && CanUseChar(Character[Pull[i]]) > 0 && !(ItemIDs[Pull[i]] == 172 && !FoundItems[25]) && !(ItemIDs[Pull[i]] == 268 && !FoundItems[170])){
								InvName[RealMax] = Names[Pull[i]];
								InvStr[RealMax]  = Descriptions[Pull[i]];
								InvPrice[RealMax]  = Cost[Pull[i]];
								InvID[RealMax] = ItemIDs[Pull[i]];
								InvChar[RealMax]  = Character[Pull[i]];
								RealMax++;
							}
						}
					}
					
					if(RealMax == 0){
						Game->PlaySound(6);
						//Put a string here saying he has nothing to offer right now. Check TotAv to see if he should say he'll have more in the future
						if(TotAv > 0)
							PlayStringAndWait(String6, SCHAR_TOTEM, EMOTE_NORMAL);
						else
							PlayStringAndWait(String5, SCHAR_TOTEM, EMOTE_NORMAL);
					}
					else{
						Game->PlaySound(86);
						mapdata l3 = Game->LoadTempScreen(3);
						l3->ComboD[comboloc] = 11577;
						l3->ComboD[comboloc+1] = 11578;
						// SetLayerComboD(3, comboloc, 11577);
						// SetLayerComboD(3, comboloc+1, 11578);
						WaitNoAction(60);
						if(Screen->State[ST_SPECIALITEM] == false){
							int String = StringArray[G[G_TOTEMSTRING]];
							PlayStringAndWait(String, SCHAR_TOTEM, EMOTE_NORMAL);
							G[G_TOTEMSTRING]++;
							Screen->State[ST_SPECIALITEM] = true;
						}
						while(true){
							//First, let's draw the frame
							DialogueBox_DrawBox(6, 128, 88, TIL_DB_DIALOGUE_BOX, CS_DB_DIALOGUE_BOX, C_DB_DIALOGUE_BOX_BG, 224, 144);
							Screen->FastTile(6, 128, 16, 65994, 11, OP_OPAQUE);
							for(int i = 32; i<=128; i+=16)
								Screen->FastTile(6, 128, i, 66014, 11, OP_OPAQUE);
							Screen->FastTile(6, 128, 144, 66034, 11, OP_OPAQUE);
							//The price
							if(G[G_RANDOMIZERENABLED]){
								Screen->FastTile(6, 140+24-16, 43, 65900, 7, OP_OPAQUE);
								if(InvPrice[CurrentOption]>-1){
									Screen->DrawInteger(6, 182-16, 40+8, FONT_P, 1, -1, -1, -1, InvPrice[CurrentOption], 0, OP_OPAQUE);
									itemsprite itm = InvSprites[CurrentOption];
									Screen->DrawTile(6, 182+16, 43+itm->DrawYOffset, itm->Tile, itm->TileWidth, itm->TileHeight, itm->CSet, -1, -1, 0, 0, 0, 0, true, 128);
								}
							}
							else{
								Screen->FastTile(6, 140+24, 43, 65900, 7, OP_OPAQUE);
								if(InvPrice[CurrentOption]>-1){
									Screen->DrawInteger(6, 182, 40+8, FONT_P, 1, -1, -1, -1, InvPrice[CurrentOption], 0, OP_OPAQUE);
								}
							}
							//The description string
							if(!Tango_SlotIsActive(0))
								PlayTangoSubscreenMessage(InvStr[CurrentOption], STYLE_SHOP, 0, 112+24,64);
							//The actual buyable things
							for(int i=CurMin; i<=CurMax; i++){
								if(InvName[i] != 0){
									Screen->DrawString(6, 52+Xoff, 48+18*(i-CurMin), FONT_P, 0xB2, -1, TF_NORMAL, InvName[i], OP_OPAQUE);
									if(CurrentOption==i){
										Screen->FastTile(6, 52-8+Xoff, 48+4+18*(i-CurMin)-4, 5, 0, OP_OPAQUE); //Cursor
									}
								}
							}
							
							//Up and down selection
							if(Link->PressUp){
								Tango_ClearSlot(0);
								Game->PlaySound(5);
								CurrentOption--;
								if(CurrentOption<0){
									CurrentOption = RealMax-1;
									CurMax = RealMax;
									CurMin = RealMax-4;
									while(CurMin < 0){
										CurMin++;
										CurMax++;
									}
								}
								if(CurrentOption < CurMin){
									CurMax--;
									CurMin--;
								}
							}
							else if(Link->PressDown){
								Tango_ClearSlot(0);
								Game->PlaySound(5);
								CurrentOption++;
								if(CurrentOption>=RealMax){
									CurrentOption = 0;
									CurMin = 0;
									CurMax = 4;
								}
								if(CurrentOption > CurMax){
									CurMax++;
									CurMin++;
								}
							}
							if(Link->PressA){
								if(Game->Counter[CR_SCRIPT1] < InvPrice[CurrentOption])
									Game->PlaySound(6);
								else{
									Tango_ClearSlot(0);
									if(G[G_RANDOMIZERENABLED]){
										Game->PlaySound(174);
										//Put message here
										for(int i = 0; i<32; i++){
											Screen->FastTile(5, ComboX(comboloc), ComboY(comboloc), 28495, 4, OP_TRANS);
											Screen->FastTile(5, ComboX(comboloc)+16, ComboY(comboloc), 28496, 4, OP_TRANS);
											for(int j = ComboY(comboloc); j>=0; j-=16){
												Screen->FastTile(5, ComboX(comboloc), j, 28515, 4, OP_TRANS);
												Screen->FastTile(5, ComboX(comboloc)+16, j, 28516, 4, OP_TRANS);
											}
											WaitNoAction();
										}
										Game->PlaySound(173);
										int radius;
										for(int i = 0; i<32; i++){
											Screen->Circle(0, Link->X+8, Link->Y+8, 16, 0x01, 1, 0, 0, 0, true, OP_TRANS);
											Screen->Circle(0, Link->X+8, Link->Y+8, 16, 0x01, 1, 0, 0, 0, true, OP_OPAQUE);
											int Color = Choose(0x01, 0x5C, 0x5D);
											if(radius<16)
												radius+=2;
											Screen->Circle(0, Link->X+8, Link->Y+8, radius+Sin(i*8)*8, 0x01, 1, 0, 0, 0, true, OP_TRANS);
											Screen->Circle(4, Link->X+8, Link->Y+8, radius, Color, 1, 0, 0, 0, true, OP_TRANS);
											Screen->Rectangle(4, Link->X+8-radius, 0, Link->X+8+radius, Link->Y+8, Color, 1, 0, 0, 0, true, OP_TRANS);
											if(i==80)
												Game->PlaySound(122);
											WaitNoAction();
										}
									}
									else{
										Game->PlaySound(123);
										//Put message here
										for(int i = 0; i<120; i++){
											Screen->FastTile(5, ComboX(comboloc), ComboY(comboloc), 28495, 4, OP_TRANS);
											Screen->FastTile(5, ComboX(comboloc)+16, ComboY(comboloc), 28496, 4, OP_TRANS);
											for(int j = ComboY(comboloc); j>=0; j-=16){
												Screen->FastTile(5, ComboX(comboloc), j, 28515, 4, OP_TRANS);
												Screen->FastTile(5, ComboX(comboloc)+16, j, 28516, 4, OP_TRANS);
											}
											WaitNoAction();
										}
										WaitNoAction(30);
										Game->PlaySound(121);
										int radius;
										for(int i = 0; i<180; i++){
											Screen->Circle(0, Link->X+8, Link->Y+8, 16, 0x01, 1, 0, 0, 0, true, OP_TRANS);
											Screen->Circle(0, Link->X+8, Link->Y+8, 16, 0x01, 1, 0, 0, 0, true, OP_OPAQUE);
											int Color = Choose(0x01, 0x5C, 0x5D);
											if(radius<16)
												radius++;
											Screen->Circle(0, Link->X+8, Link->Y+8, radius+Sin(i*8)*8, 0x01, 1, 0, 0, 0, true, OP_TRANS);
											Screen->Circle(4, Link->X+8, Link->Y+8, radius, Color, 1, 0, 0, 0, true, OP_TRANS);
											Screen->Rectangle(4, Link->X+8-radius, 0, Link->X+8+radius, Link->Y+8, Color, 1, 0, 0, 0, true, OP_TRANS);
											if(i==80)
												Game->PlaySound(122);
											WaitNoAction();
										}
									}
									Game->Counter[CR_SCRIPT1] -= InvPrice[CurrentOption];
									if(G[G_RANDOMIZERENABLED]){
										itemsprite itm = SpawnRandomizerItem(InvLoc[CurrentOption], InvID[CurrentOption], Link->X, Link->Y);
										itm->Pickup |= IP_HOLDUP;
										while(itm->isValid()){
											itm->X = Link->X;
											itm->Y = Link->Y;
											WaitNoAction();
										}
										switch(id){
											case 0:
												++G[G_OMAKATOTEMCOUNT];
												break;
											case 1:
												++G[G_KAWITOTEMCOUNT];
												break;
											case 2:
												++G[G_SHOALSTOTEMCOUNT];
												break;
											case 3:
												++G[G_WAHIOKALATOTEMCOUNT];
												break;
										}
										Screen->D[D_RANDOTOTEM] |= (1<<InvD[CurrentOption]);
									}
									else{
										FoundItems[InvID[CurrentOption]] = true;
										if(InvID[CurrentOption] < 256)
											Link->Item[InvID[CurrentOption]] = true;
										if(InvID[CurrentOption] >= 256 && InvID[CurrentOption] <= 258){
											if(GetCharID() == CHAR_ASHER){
												Link->MaxHP += 16;
												Link->HP += 16;
											}
											G[G_ASHERMAXHP] += 16;
											if(G[G_ASHERHP] > 0)
												G[G_ASHERHP] += 16;
										}
										if(InvID[CurrentOption] >= 259 && InvID[CurrentOption] <= 261){
											if(GetCharID() == CHAR_TORRIN){
												Link->MaxHP += 16;
												Link->HP += 16;
											}
											G[G_TORRINMAXHP] += 16;
											if(G[G_TORRINHP] > 0)
												G[G_TORRINHP] += 16;
										}
										if(InvID[CurrentOption] >= 262 && InvID[CurrentOption] <= 264){
											if(GetCharID() == CHAR_KAYLANI){
												Link->MaxHP += 16;
												Link->HP += 16;
											}
											G[G_KAYLANIMAXHP] += 16;
											if(G[G_KAYLANIHP] > 0)
												G[G_KAYLANIHP] += 16;
										}
										if(InvID[CurrentOption] == 265){
											Game->Counter[CR_ASHERAUGMENTSLOTS]++;
										}
										if(InvID[CurrentOption] == 266){
											Game->Counter[CR_TORRINAUGMENTSLOTS]++;
										}
										if(InvID[CurrentOption] == 267){
											Game->Counter[CR_KAYLANIAUGMENTSLOTS]++;
										}
										if(InvID[CurrentOption] == 162){
											Link->Item[I_FISTUPGRADE] = true;
											FoundItems[I_FISTUPGRADE] = true;
											if(Link->ItemA == 156)
												EquipButtonItem(162, 0, true);
											if(Link->ItemB == 156)
												EquipButtonItem(162, 1, true);
											if(Link->ItemX == 156)
												EquipButtonItem(162, 2, true);
											if(Link->ItemY == 156)
												EquipButtonItem(162, 3, true);
											if(G[G_ITEMA_TORRIN] == 156)
												G[G_ITEMA_TORRIN] = 162;
											if(G[G_ITEMB_TORRIN] == 156)
												G[G_ITEMB_TORRIN] = 162;
											if(G[G_ITEMX_TORRIN] == 156)
												G[G_ITEMX_TORRIN] = 162;
											if(G[G_ITEMY_TORRIN] == 156)
												G[G_ITEMY_TORRIN] = 162;
										}
										if(InvID[CurrentOption] == 163){
											if(Link->ItemA == 157)
												EquipButtonItem(163, 0, true);
											if(Link->ItemB == 157)
												EquipButtonItem(163, 1, true);
											if(Link->ItemX == 157)
												EquipButtonItem(163, 2, true);
											if(Link->ItemY == 157)
												EquipButtonItem(163, 3, true);
											if(G[G_ITEMA_KAYLANI] == 157)
												G[G_ITEMA_KAYLANI] = 163;
											if(G[G_ITEMB_KAYLANI] == 157)
												G[G_ITEMB_KAYLANI] = 163;
											if(G[G_ITEMX_KAYLANI] == 157)
												G[G_ITEMX_KAYLANI] = 163;
											if(G[G_ITEMY_KAYLANI] == 157)
												G[G_ITEMY_KAYLANI] = 163;
										}
									}
									l3->ComboD[comboloc] = 11558;
									l3->ComboD[comboloc+1] = 11559;
									// SetLayerComboD(3, comboloc, 11558);
									// SetLayerComboD(3, comboloc+1, 11559);
									Game->PlaySound(87);
									Tango_ClearSlot(0);
									WaitNoAction(60);
									break;
								}
							}
							if(Link->PressB){
								l3->ComboD[comboloc] = 11558;
								l3->ComboD[comboloc+1] = 11559;
								// SetLayerComboD(3, comboloc, 11558);
								// SetLayerComboD(3, comboloc+1, 11559);
								Game->PlaySound(87);
								Tango_ClearSlot(0);
								WaitNoAction(60);
								break;
							}
							WaitNoAction();
						}
					}
					for(int i=0; i<5; ++i){
						if(InvSprites[i]->isValid()){
							InvSprites[i]->Remove();
						}
					}
				}
			}
			Waitframe();
		}
	}
}

const int MAP_ELEVATOR = 16;
const int SCRN_ELEVATOR = 0x20;
const int SCRN_ELEVATOR2 = 0x30;

ffc script MiningElevator{
	void DrawElevator(int offset, int doorOffset, int doorCombo){
		offset = (Round(offset+128)-128)%32;
		doorOffset = Round(doorOffset+128)-128;
		GBMP[BMP_ELEVATOR]->Blit(0, RT_SCREEN, offset, offset, 			128, 128,   0, -48, 128, 128, 0, 0, 0, BITDX_NORMAL, 0, false);
		GBMP[BMP_ELEVATOR]->Blit(0, RT_SCREEN, 128-offset+256, offset, 	128, 128, 128, -48, 128, 128, 0, 0, 0, BITDX_NORMAL, 0, false);
		GBMP[BMP_ELEVATOR]->Blit(0, RT_SCREEN, offset, offset, 			128, 128,   0, -48, 128, 128, 0, 0, 0, BITDX_VFLIP, 0, false);
		GBMP[BMP_ELEVATOR]->Blit(0, RT_SCREEN, 128-offset+256, offset, 	128, 128, 128, -48, 128, 128, 0, 0, 0, BITDX_VFLIP, 0, false);
		if(doorOffset>-64&&doorOffset<32){
			int doorX = 112;
			int doorY = 144+doorOffset;
			Screen->FastCombo(0, doorX, doorY, doorCombo, 3, 128);
			Screen->FastCombo(0, doorX+16, doorY, doorCombo+1, 3, 128);
			Screen->FastCombo(0, doorX, doorY+16, doorCombo+4, 3, 128);
			Screen->FastCombo(0, doorX+16, doorY+16, doorCombo+5, 3, 128);
		}
	}
	void run(int speed, int canFlood){
		if(canFlood&&Game->Counter[CR_STORYFLAG]>=SFLAG_ASHERKIDNAPPED&&!G[G_RANDOMIZERENABLED]){
			mapdata ref = Game->LoadMapData(20, 0x0F);
			mapdata l1 = Game->LoadTempScreen(1);
			mapdata l2 = Game->LoadTempScreen(2);
			for(int i=0; i<176; ++i){
				Screen->ComboD[i] = ref->ComboD[i];
				l1->ComboD[i] = 0;
				l2->ComboD[i] = 0;
			}
			Quit();
		}
		if(Game->GetCurScreen() == 0x30)
			Game->SetScreenState(20, 0x32, ST_VISITED, true);
		if(Game->GetCurScreen() == 0x14)
			Game->SetScreenState(20, 0x18, ST_VISITED, true);
		if(Game->GetCurScreen() == 0x48)
			Game->SetScreenState(20, 0x4C, ST_VISITED, true);
		if(Game->GetCurScreen() == 0x4C)
			Game->SetScreenState(20, 0x48, ST_VISITED, true);
		if(Game->GetCurScreen() == 0x45)
			Game->SetScreenState(20, 0x49, ST_VISITED, true);
		if(Game->GetCurScreen() == 0x49)
			Game->SetScreenState(20, 0x45, ST_VISITED, true);
		Waitframe();
		speed -= Sign(speed); //Building around dumb editor bugs until the next build, huzzah
		GBMP[BMP_ELEVATOR]->Clear(0);
		GBMP[BMP_ELEVATOR]->DrawLayer(0, MAP_ELEVATOR, SCRN_ELEVATOR, 0, 0, 0, 0, 128);
		GBMP[BMP_ELEVATOR]->DrawLayer(0, MAP_ELEVATOR, SCRN_ELEVATOR2, 0, 256, 0, 0, 128);
		int offset;
		int doorOffset;
		while(Distance(Link->X, Link->Y, 120, 72)>32){
			Waitframe();
		}
		Screen->TriggerSecrets();
		Game->PlaySound(9);
		Waitframes(10);
		Screen->Quake = 4;
		Game->PlaySound(68);
		Waitframes(20);
		int doorCombo = Screen->ComboD[151];
		int totalMove = 0;
		int sfxTime = 0;
		Game->PlaySound(89);
		while(totalMove<128){
			if(sfxTime%12==0)
				Game->PlaySound(132);
			++sfxTime;
			totalMove += Abs(speed);
			offset += speed;
			if(offset<0)
				offset += 32;
			if(offset>=32)
				offset -= 32;
			doorOffset += speed;
			DrawElevator(offset, doorOffset, doorCombo);
			Waitframe();
		}
		doorOffset = -32;
		if(speed<0)
			doorOffset = 32;
		int doormovetime = 32/Abs(speed);
		for(int i=0; i<doormovetime; ++i){
			if(sfxTime%12==0)
				Game->PlaySound(132);
			++sfxTime;
			offset += speed;
			if(offset<0)
				offset += 32;
			if(offset>=32)
				offset -= 32;
			doorOffset += speed;
			DrawElevator(offset, doorOffset, doorCombo);
			Waitframe();
		}
		Screen->SetSideWarp(0, Screen->GetSideWarpScreen(1), Screen->GetSideWarpDMap(1), WT_IWARPBLACKOUT);
		Screen->Quake = 4;
		Game->PlaySound(68);
		Waitframes(10);
		Screen->TriggerSecrets();
		Game->PlaySound(9);
		Waitframes(20);
	}
}

const int FFCS_MAGNETGEM = 31;
const int DAMAGE_MAGNETGEM = 800;

const int CMB_MAGNETGEM_HOLE = 38419;
const int TIL_MAGNETGEM_SHARDS = 65340;
const int SFX_MAGNETGEM_SHATTER = 90;

ffc script MagnetGem{
	bool OnHole(mapdata l1, int pos){
		switch(Screen->ComboD[pos]){
			case 1023: //Under Bush
				return true;
		}
		switch(l1->ComboD[pos]){
			case CMB_MAGNETGEM_HOLE:
				return true;
		}
		return false;
	}
	void SetNoBlockFlags(ffc f){
		for(int i=0; i<176; ++i){
			if(Screen->ComboF[i]==CF_NOBLOCKS)
				Screen->ComboF[i] = 0;
		}
		for(int i=0; i<4; ++i){
			int x = f->X+3+9*(i%2);
			int y = f->Y+3+9*Floor(i/2);
			int pos = ComboAt(x, y);
			if(f->Data==0)
				Screen->ComboF[pos] = 0;
			else
				Screen->ComboF[pos] = CF_NOBLOCKS;
		}
	}
	void run(int polarity, int itemdrop, int randomizerIndex){
		if(itemdrop){
			if(Screen->State[ST_ITEM]){
				this->Data = 0;
				Quit();
			}
			
			if(G[G_RANDOMIZERENABLED]&&randomizerIndex>0){
				if(RandomizedItems[randomizerIndex]>0){
					itemdrop = RandomizedItems[randomizerIndex];
					itemdrop = Randomizer_ProgressiveItem(itemdrop);
				}
			}
		}
		int vX;
		int vY;
		int x = this->X;
		int y = this->Y;
		int push[2];
		mapdata l1 = Game->LoadTempScreen(1);
		int magnetCooldown;
		//Jank problems call for jank solutions
		bool specialBlockFlags;
		if(Game->GetCurMap()==33&&Game->GetCurScreen()==0x3E){
			specialBlockFlags = true;
		}
		while(true){
			bool accelerate;
			bool noSound;
			bool solid = true;
			bool magnetized;
			int speedUpMod = 1;
			if(HasAugment(I_AUGMENT_SPEED)){
				speedUpMod = 1.1333;
			}
			if(GLW[GL_MAGNETHITBOX]->isValid()){
				if(Collision(this, GLW[GL_MAGNETHITBOX])){
					magnetized = true;
					int moveDirection = -1;
					if(GLW[GL_MAGNETHITBOX]->Damage!=polarity)
						moveDirection = 1;
					int frontX = Link->X+DirX(Link->Dir, 14);
					int frontY = Link->Y+DirY(Link->Dir, 14);
					if(Distance(this->X, this->Y, frontX, frontY)>4||moveDirection==1){
						int sideStep = 1*speedUpMod;
						switch(Link->Dir){
							case DIR_UP:
								vX = 0;
								vY = Clamp(vY-0.1*moveDirection*MagnetModifier(), -2, 2);
								int sideDiff = Link->X-this->X;
								if(Abs(Link->X-this->X)>=1){
									if(CanWalk(this->X, this->Y, DIR_LEFT, 1, true)&&sideDiff<0)
										push[0] -= sideStep;
									else if(CanWalk(this->X, this->Y, DIR_RIGHT, 1, true)&&sideDiff>0)
										push[0] += sideStep;
								}
								break;
							case DIR_DOWN:
								vX = 0;
								vY = Clamp(vY+0.1*moveDirection*MagnetModifier(), -2, 2);
								int sideDiff = Link->X-this->X;
								if(Abs(Link->X-this->X)>=1){
									if(CanWalk(this->X, this->Y, DIR_LEFT, 1, true)&&sideDiff<0)
										push[0] -= sideStep;
									else if(CanWalk(this->X, this->Y, DIR_RIGHT, 1, true)&&sideDiff>0)
										push[0] += sideStep;
								}
								break;
							case DIR_LEFT:
								vX = Clamp(vX-0.1*moveDirection*MagnetModifier(), -2, 2);
								vY = 0;
								int sideDiff = Link->Y-this->Y;
								if(Abs(Link->Y-this->Y)>=1){
									if(CanWalk(this->X, this->Y, DIR_UP, 1, true)&&sideDiff<0)
										push[1] -= sideStep;
									else if(CanWalk(this->X, this->Y, DIR_DOWN, 1, true)&&sideDiff>0)
										push[1] += sideStep;
								}
								break;
							case DIR_RIGHT:
								vX = Clamp(vX+0.1*moveDirection*MagnetModifier(), -2, 2);
								vY = 0;
								int sideDiff = Link->Y-this->Y;
								if(Abs(Link->Y-this->Y)>=1){
									if(CanWalk(this->X, this->Y, DIR_UP, 1, true)&&sideDiff<0)
										push[1] -= sideStep;
									else if(CanWalk(this->X, this->Y, DIR_DOWN, 1, true)&&sideDiff>0)
										push[1] += sideStep;
								}
								break;
						}
					}
					else{
						solid = false;
						x = frontX;
						y = frontY;
						if(!CanWalk(Round(x), Round(y), Link->Dir, 1, true)){
							solid = true;
							for(int i=0; i<12; ++i){
								x += DirX(Link->Dir, -1);
								y += DirY(Link->Dir, -1);
								if(CanWalk(Round(x), Round(y), Link->Dir, 1, true))
									break;
							}
							x += DirX(Link->Dir, 1);
							y += DirY(Link->Dir, 1);
						}
						noSound = true;
					}
				}
			}
			if(!magnetized){
				int pos = ComboAt(this->X+8, this->Y+12);
				if(magnetCooldown>0)
					--magnetCooldown;
				else if(Screen->ComboT[pos]==CT_PITFALL){
					if(Round(x)!=ComboX(pos)||Round(y)!=ComboY(pos)){
						if(Round(x)!=ComboX(pos)){
							x += ComboX(pos)-x;
						}
						if(Round(y)!=ComboY(pos)){
							y += ComboY(pos)-y;
						}
					}
					else{
						if(Screen->ComboD[pos] == 732){
							Game->PlaySound(42);
							Screen->TriggerSecrets();
							Screen->State[ST_SECRET] = true;
							this->Data = 0;
							Quit();
						}
						else{
							Game->PlaySound(SFX_FALL);
							ParticleAnim(x, y, 97);
							this->Data = 0;
							Quit();
						}
					}
				}
				if(itemdrop>0&&OnHole(l1, pos)){
					while(Round(x)!=ComboX(pos)||Round(y)!=ComboY(pos)-4){
						if(Round(x)!=ComboX(pos)){
							x += ComboX(pos)-x;
						}
						if(Round(y)!=ComboY(pos)-4){
							y += ComboY(pos)-4-y;
						}
						if(specialBlockFlags)SetNoBlockFlags(this);
						Waitframe();
					}
					Waitframes(30);
					item i = SpawnRandomizerItem(randomizerIndex, itemdrop, this->X, this->Y);
					i->Pickup |= IP_ST_ITEM|IP_HOLDUP;
					i->Jump = 1;
					i->MoveFlags[ITEMMV_CAN_PITFALL] = false;
					int til = TIL_MAGNETGEM_SHARDS+Rand(8);
					int cs = 7;
					if(polarity==1){
						til += 20;
						cs = 8;
					}
					Game->PlaySound(SFX_MAGNETGEM_SHATTER);
					for(int i=0; i<8; ++i){
						lweapon l = ParticleAnimTimed(this->X+Rand(-8, 8), this->Y+Rand(-8, 8), til, cs, 8, 0, 12);
						l->Angular = true;
						l->Angle = DegtoRad(Rand(360));
						l->Step = Rand(20, 200);
					}
					this->Data = 0;
					SetNoBlockFlags(this);
					Quit();
				}
			}
			else{
				magnetCooldown = 16;
			}
			
			if(solid){
				if(Distance(Link->X, Link->Y, this->X, this->Y)<16){
					if(Abs(AngDiff(Angle(this->X, this->Y, Link->X, Link->Y), Angle(0, 0, vX, vY)))<45){
						vX = 0;
						vY = 0;
					}
				}
				SolidObjects_Add(0, this->X+3, this->Y+3, 14, 14, vX, vY, 0);
			}
			
			if(!accelerate){
				vX = Decrement(vX, 0.05);
				vY = Decrement(vY, 0.05);
			}
			
			if(Distance(0, 0, vX, vY)>1.5){
				lweapon hitbox = MakeHitboxLW(LW_MAGNETGEM, this->X, this->Y, 16, 16, DAMAGE_MAGNETGEM, Link->Dir);
			}
			
			push[0] += vX;
			push[1] += vY;
			int xy[] = {x, y};
			HandlePush(push, xy, 4, true);
			x = xy[0];
			y = xy[1];
			
			if((vX<0&&!CanWalk(x, y, DIR_LEFT, 1, true))||(vX>0&&!CanWalk(x, y, DIR_RIGHT, 1, true))){
				if(Abs(vX)>0.5){
					if(!noSound)
						Game->PlaySound(SFX_TAP1);
					vX = -vX;
				}
				else
					vX = 0;
			}
			if((vY<0&&!CanWalk(x, y, DIR_UP, 1, true))||(vY>0&&!CanWalk(x, y, DIR_DOWN, 1, true))){
				if(Abs(vY)>0.5){
					if(!noSound)
						Game->PlaySound(SFX_TAP1);
					vY = -vY;
				}
				else
					vY = 0;
			}
			
			this->X = x;
			this->Y = y;
			
			for(int i=Screen->NumEWeapons(); i>0; --i){
				eweapon e = Screen->LoadEWeapon(i);
				if(e->Script==EWS_KNOCKBACKSHOT){
					if(Collision(this, e)){
						e->DeadState = 0;
					}
				}
			}
			
			if(specialBlockFlags)SetNoBlockFlags(this);
			Waitframe();
		}
	}
}

ffc script TorchTimer{
	void run(int cmb, int offset, int frames){
		if(Screen->State[ST_SECRET])
			Quit();
		int torchTimer[176];
		for(int i=0; i<176; ++i){
			torchTimer[i] = frames;
		}
		while(true){
			if(frames>0){
				for(int i=0; i<176; ++i){
					if(Screen->ComboD[i]==cmb){
						if(torchTimer[i]){
							--torchTimer[i];
							if(!torchTimer[i]){
								Screen->ComboD[i] += offset;
								Screen->ComboF[i] = 95;
								torchTimer[i] = frames;
							}
						}
					}
				}
			}
			if(Screen->State[ST_SECRET]){
				Game->PlaySound(SFX_SECRET);
				Quit();
			}
			Waitframe();
		}
	}
}

const int SFX_SLIDINGPANEL = 89;
const int SFX_SLIDINGPANEL2 = 89;

ffc script SlidingPanel{
	void DrawSlidingPanel(ffc this, int x, int y, int w, int h, int pixels, int oldPixels, int dir, int bmpOffX, int bmpOffY){
		w = Floor(w);
		h = Floor(h);
		pixels = Floor(pixels);
		int maxPixels = w*16;
		if(dir<2)
			maxPixels = h*16;
		int rectX;
		int rectY;
		int rectW = w*16;
		int rectH = h*16;
		int rectOffX;
		int rectOffY;
		switch(dir){
			case DIR_UP:
				rectY += pixels;
				rectH -= pixels;
				break;
			case DIR_DOWN:
				rectH -= pixels;
				rectOffY += pixels;
				break;
			case DIR_LEFT:
				rectX += pixels;
				rectW -= pixels;
				break;
			case DIR_RIGHT:
				rectW -= pixels;
				rectOffX += pixels;
				break;
		}
		if(RectCollision(Link->X, Link->Y+8, Link->X+15, Link->Y+15, x+rectOffX, y+rectOffY, x+rectOffX+rectW-1, y+rectOffY+rectH-1)){
			this->X = Link->X;
			this->Y = Link->Y;
			this->Flags[FFCF_ETHEREAL] = false;
			if(oldPixels[0]!=pixels&&Abs(oldPixels[0]-pixels)<16){
				int diff = pixels-oldPixels[0];
				switch(dir){
					case DIR_UP:
						LinkMovement_Push2(0, -diff);
						break;
					case DIR_DOWN:
						LinkMovement_Push2(0, diff);
						break;
					case DIR_LEFT:
						LinkMovement_Push2(-diff, 0);
						break;
					case DIR_RIGHT:
						LinkMovement_Push2(diff, 0);
						break;
				}
			}
		}
		else{
			this->Flags[FFCF_ETHEREAL] = true;
		}
		oldPixels[0] = pixels;
		GBMP[BMP_GENERIC]->Blit(1, RT_SCREEN, bmpOffX+rectX, bmpOffY+rectY, rectW, rectH, x+rectOffX, y+rectOffY, rectW, rectH, 0, 0, 0, 0, 0, false);
	}
	bool GetState(int state, int special){
		if(special==0){
			if(state<0)
				return !Screen->State[Abs(state)];
			return Screen->State[state];
		}
		else if(special==1){
			return Screen->State[ST_SPECIALITEM]&&!(Screen->D[0]&(1<<state));
		}
		else if(special==4){
			return !(Screen->D[0]&(1<<state));
		}
	}
	bool SetComboState(ffc this, int startX, int startY, int w, int h, int secrets, bool panelvisible){
		int comboOrig = secrets[0];
		int csetOrig = secrets[1];
		int flagOrig = secrets[2];
		int comboUnder = secrets[3];
		int csetUnder = secrets[4];
		int flagUnder = secrets[5];
		if(panelvisible){
			for(int x=0; x<w; ++x){
				for(int y=0; y<h; ++y){
					int pos = ComboAt(startX+x*16+8, startY+y*16+8);
					Screen->ComboD[pos] = comboOrig[pos];
					Screen->ComboC[pos] = csetOrig[pos];
					Screen->ComboF[pos] = flagOrig[pos];
				}
			}
		}
		else{
			for(int x=0; x<w; ++x){
				for(int y=0; y<h; ++y){
					int pos = ComboAt(startX+x*16+8, startY+y*16+8);
					Screen->ComboD[pos] = comboUnder[pos];
					Screen->ComboC[pos] = csetUnder[pos];
					Screen->ComboF[pos] = flagUnder[pos];
				}
			}
		}
	}
	int GetPixelDist(int dist, int maxDist, int time, int maxtime, int buffertime, bool extend){
		if(buffertime<0)
			buffertime = maxtime-Abs(buffertime);
		if(extend){
			if(time<maxtime-buffertime){
				maxtime -= buffertime;
				dist = maxDist*SafeDiv(time, maxtime);
			}
			else
				dist = maxDist;
		}
		else{
			if(time<maxtime-buffertime){
				maxtime -= buffertime;
				dist = maxDist*SafeDiv((maxtime-time), maxtime);
			}
			else
				dist = 0;
		}
		return dist;
	}
	void run(int w, int h, int slideDir, int slideSpeed, int state, int bmpOffX, int bmpOffY, int special){
		int startX = this->X;
		int startY = this->Y;
		InitBitmaps();
		bool freezeLink = true;
		bool isFirst = IsFirstFFC(this);
		bool isLast = IsLastFFC(this);
		int comboOrig[176];
		int csetOrig[176];
		int flagOrig[176];
		int comboUnder[176];
		int csetUnder[176];
		int flagUnder[176];
		int secrets[] = {comboOrig, csetOrig, flagOrig, comboUnder, csetUnder, flagUnder};
		int oldPixels[1];
		if(isFirst){
			GBMP[BMP_GENERIC]->Clear(0);
		}
		for(int x=0; x<w; ++x){
			for(int y=0; y<h; ++y){
				int pos = ComboAt(this->X+x*16+8, this->Y+y*16+8);
				comboOrig[pos] = Screen->ComboD[pos];
				csetOrig[pos] = Screen->ComboC[pos];
				flagOrig[pos] = Screen->ComboF[pos];
				int flag = Screen->ComboF[pos];
				if(flag>=16&&flag<=31){
					comboUnder[pos] = Screen->SecretCombo[SECCMB_SECRET01+(flag-16)];
					csetUnder[pos] = Screen->SecretCSet[SECCMB_SECRET01+(flag-16)];
					flagUnder[pos] = Screen->SecretFlags[SECCMB_SECRET01+(flag-16)];
				}
			}
		}
		int dist;
		int slideTime = w*16;
		if(slideDir<2)
			slideTime = h*16;
		int prevDist;
		if(special==2||special==3){
			dist = GetPixelDist(dist, slideTime, G[G_TIMER1+state*2], G[G_TIMER1MAX+state*2], slideSpeed, true);
			if(G[G_TIMER1MAX+state*2]==0)
				dist = 0;
			if(special==3){
				dist = GetPixelDist(dist, slideTime, G[G_TIMER1+state*2], G[G_TIMER1MAX+state*2], slideSpeed, false);
				if(G[G_TIMER1MAX+state*2]==0)
					dist = slideTime;
			}
			if(dist==0){
				SetComboState(this, startX, startY, w, h, secrets, true);
			}
			else{
				SetComboState(this, startX, startY, w, h, secrets, false);
			}
		}
		else{
			SetComboState(this, startX, startY, w, h, secrets, !GetState(state, special));
		}
		Waitframe();
		for(int x=0; x<w; ++x){
			for(int y=0; y<h; ++y){
				int pos = ComboAt(this->X+x*16+8, this->Y+y*16+8);
				GBMP[BMP_GENERIC]->FastCombo(0, x*16+bmpOffX, y*16+bmpOffY, comboOrig[pos], csetOrig[pos], 128);
			}
		}
		if(special==2||special==3){
			while(true){
				dist = GetPixelDist(dist, slideTime, G[G_TIMER1+state*2], G[G_TIMER1MAX+state*2], slideSpeed, true);
				if(G[G_TIMER1MAX+state*2]==0)
					dist = 0;
				if(special==3){
					dist = GetPixelDist(dist, slideTime, G[G_TIMER1+state*2], G[G_TIMER1MAX+state*2], slideSpeed, false);
					if(G[G_TIMER1MAX+state*2]==0)
						dist = slideTime;
				}
				dist = Clamp(dist, 0, slideTime);
				if(dist<slideTime){
					DrawSlidingPanel(this, startX, startY, w, h, dist, oldPixels, slideDir, bmpOffX, bmpOffY);
				}
				else
					this->Flags[FFCF_ETHEREAL] = true;
				if(dist!=prevDist){
					if(dist==0){
						SetComboState(this, startX, startY, w, h, secrets, true);
					}
					else{
						SetComboState(this, startX, startY, w, h, secrets, false);
					}
					prevDist = dist;
				}
				Waitframe();
			}
		}
		else{
			while(true){
				if(!GetState(state, special)){
					while(!GetState(state, special)){
						Waitframe();
					}
					int linkX = Link->X;
					int linkY = Link->Y;
					for(int i=0; i<this->Delay; ++i){
						Link->X = linkX;
						Link->Y = linkY;
						if(freezeLink)NoAction();
						Waitframe();
					}
					Game->PlaySound(SFX_SLIDINGPANEL);
					SetComboState(this, startX, startY, w, h, secrets, false);
					int slideTime = w*16;
					if(slideDir<2)
						slideTime = h*16;
					for(int i=0; i<slideTime; i+=slideSpeed){
						DrawSlidingPanel(this, startX, startY, w, h, i, oldPixels, slideDir, bmpOffX, bmpOffY);
						Link->X = linkX;
						Link->Y = linkY;
						if(freezeLink)NoAction();
						Waitframe();
					}
					this->Flags[FFCF_ETHEREAL] = true;
				}
				while(GetState(state, special)){
					Waitframe();
				}
				if(!GetState(state, special)){
					int linkX = Link->X;
					int linkY = Link->Y;
					for(int i=0; i<this->Delay; ++i){
						Link->X = linkX;
						Link->Y = linkY;
						if(freezeLink)NoAction();
						Waitframe();
					}
					Game->PlaySound(SFX_SLIDINGPANEL2);
					int slideTime = w*16;
					if(slideDir<2)
						slideTime = h*16;
					// if(Screen->RoomData==I_TIDALGAUNTLETMOON){
						// Screen->EntryX = linkX;
						// Screen->EntryY = linkY;
					// }
					for(int i=slideTime; i>0; i-=slideSpeed){
						DrawSlidingPanel(this, startX, startY, w, h, i, oldPixels, slideDir, bmpOffX, bmpOffY);
						Link->X = linkX;
						Link->Y = linkY;
						if(freezeLink)NoAction();
						Waitframe();
					}
					this->Flags[FFCF_ETHEREAL] = true;
					SetComboState(this, startX, startY, w, h, secrets, true);
				}
				Waitframe();
			}
		}
	}
}

const int FFCS_WALLGRAPPLE = 34;

ffc script WallGrapple{
	void run(int startX, int startY, int endX, int endY, int step, int delay){
		if(this->Data==38468||this->Data==38469){
			while(true){
				Waitframe();
			}
		}
		while(step==0){
			Waitframe();
		}
		Waitframes(this->Delay);
		while(true){
			while(Distance(this->X, this->Y, startX, startY)>step){
				int angle = Angle(this->X, this->Y, startX, startY);
				this->Vx = VectorX(step, angle);
				this->Vy = VectorY(step, angle);
				Waitframe();
			}
			this->X = startX;
			this->Y = startY;
			this->Vx = 0;
			this->Vy = 0;
			Waitframes(delay);
			while(Distance(this->X, this->Y, endX, endY)>step){
				int angle = Angle(this->X, this->Y, endX, endY);
				this->Vx = VectorX(step, angle);
				this->Vy = VectorY(step, angle);
				Waitframe();
			}
			this->X = endX;
			this->Y = endY;
			this->Vx = 0;
			this->Vy = 0;
			Waitframes(delay);
		}
	}
}

ffc script Wallpulley{
	void run(int element, int whichTimer, int timeValue, int dir, int maxdist, int specialEffect){
		int cmb = this->Data;
		this->Data = GH_INVISIBLE_COMBO;
		Waitframe();
		int x; int y;
		int startX = this->X + DirX(dir, 2);
		int startY = this->Y + DirY(dir, 2);
		int hookX = startX;
		int hookY = startY;
		int triggerState;
		
		int timerTimer;
		while(true){
			bool magnetized;
			if(GLW[GL_MAGNETHITBOX]->isValid()){
				lweapon l = GLW[GL_MAGNETHITBOX];
				if(RectCollision(l->X+l->HitXOffset, l->Y+l->HitYOffset, l->X+l->HitXOffset+l->HitWidth-1, l->Y+l->HitYOffset+l->HitHeight-1, hookX, hookY, hookX+15, hookY+15)){
					if(dir==OppositeDir(Link->Dir)&&l->Damage==element){
						magnetized = true;
					}
				}
			}
			
			int angle = Angle(hookX, hookY, Link->X, Link->Y);
			int dist = Distance(startX, startY, hookX, hookY);
			
			if(magnetized){
				if(Distance(hookX, hookY, Link->X, Link->Y)>20){
					hookX += VectorX(0.75*MagnetModifier(), angle);
					hookY += VectorY(0.75*MagnetModifier(), angle);
				}
			}
			else{
				angle = Angle(hookX, hookY, startX, startY);
				dist = Distance(startX, startY, hookX, hookY);
				if(dist>2){
					hookX += VectorX(2, angle);
					hookY += VectorY(2, angle);
				}
				else{
					hookX = startX;
					hookY = startY;
					triggerState = 0;
					angle = DirAngle(dir);
				}
			}
			
			angle = Angle(startX, startY, hookX, hookY);
			dist = Distance(startX, startY, hookX, hookY);
			if(dist>maxdist){
				x = startX+VectorX(maxdist, angle);
				y = startY+VectorY(maxdist, angle);
				hookX = x;
				hookY = y;
				dist = Distance(startX, startY, hookX, hookY);
				if(!triggerState){
					Game->PlaySound(SFX_SWITCH_PRESS);
					triggerState = 1;
					timerTimer = 30;
					G[G_TIMER1+whichTimer*2] = timeValue*SafeDiv(G[G_TIMER1+whichTimer*2], G[G_TIMER1MAX+whichTimer*2]);
					G[G_TIMER1MAX+whichTimer*2] = timeValue;
				}
			}
			if(Distance(startX, startY, hookX, hookY)>0){
				for(int i=0; i<=4; ++i){
					x = startX+VectorX(dist*(i/4), angle);
					y = startY+VectorY(dist*(i/4), angle);
					Screen->FastCombo(2, x, y, cmb+1, this->CSet, 128);
				}
				x = hookX + VectorX(4, angle);
				y = hookY + VectorY(4, angle);
				Screen->DrawCombo(2, x, y, cmb, 1, 1, this->CSet, -1, -1, x, y, angle, -1, 0, true, 128);
			}
			else{
				Screen->FastCombo(2, hookX, hookY, cmb+1, this->CSet, 128);
				x = hookX + DirX(dir, 4);
				y = hookY + DirY(dir, 4);
				Screen->DrawCombo(2, x, y, cmb, 1, 1, this->CSet, -1, -1, x, y, DirAngle(dir), -1, 0, true, 128);
			}
			
			if(timerTimer){
				--timerTimer;
				int targetTime = timeValue*((30-timerTimer)/30);
				if(G[G_TIMER1+whichTimer]<targetTime)
					G[G_TIMER1+whichTimer*2] = Lerp(G[G_TIMER1+whichTimer*2], targetTime, 0.3);
				if(timerTimer==0)
					G[G_TIMER1+whichTimer*2] = targetTime;
			}
			Waitframe();
		}
	}
}

const int CMB_CANTALK = 33281;
const int CMB_CANTALKQUEST = 33282;

const int CMB_CANHEAL = 41343;

//D6 flags
	const int FLAG_NOTURN			= 000000001b; //1
	const int FLAG_SHOP  			= 000000010b; //2
	const int FLAG_INTENT			= 000000100b; //4
	const int FLAG_APPEAR			= 000001000b; //8
	const int FLAG_DISAPPEAR  		= 000010000b; //16
	const int FLAG_APPEARFLAG 		= 000100000b; //32
	const int FLAG_DISAPPEARFLAG    = 001000000b; //64
	const int FLAG_SCRIPTFLAG    	= 010000000b; //128
	const int FLAG_NOSOLID          = 100000000b; //256

bool IsCovered(ffc this, int flags){
	if(flags&FLAG_INTENT&&Screen->isSolid(this->X+8, this->Y+8))
		return true;
	return false;
}

ffc script NPC{
	bool CanTalk(ffc this){
		if(Link->Dir<2){
			if(Abs(Link->X-this->X)<=8){
				if(Link->Dir==DIR_UP&&Link->Y>this->Y&&Link->Y<this->Y+10)
					return true;
				else if(Link->Dir==DIR_DOWN&&Link->Y<this->Y&&Link->Y>this->Y-20)
					return true;
			}
		}
		else{
			if(Link->Y>=this->Y-12&&Link->Y<=this->Y+4){
				if(Link->Dir==DIR_LEFT&&Link->X>this->X&&Link->X<this->X+18)
					return true;
				else if(Link->Dir==DIR_RIGHT&&Link->X>this->X-18&&Link->X<this->X)
					return true;
			}
		}
		return false;
	}
	bool HasAssociatedCharacter(int itemid){
		switch(itemid){
			case I_ABILITY_A_ASHER:
				return Link->Item[I_ASHER];
			case I_ABILITY_B_TORRIN:
				return Link->Item[I_TORRIN];
			case I_ABILITY_B_SOREN:
				return Link->Item[I_SOREN];
			case I_ABILITY_B_TERRY:
				return Link->Item[I_TERRY];
			case I_ABILITY_C_SOREN:
				return Link->Item[I_SOREN];
			case I_ABILITY_C_TERRY:
				return Link->Item[I_TERRY];
		}
		return true;
	}
	bool DoIVanish(ffc this, int msg, int charID, int flags, int StoryFlagIndex, int StoryFlagValue){
		if(flags&FLAG_DISAPPEAR && Game->Counter[StoryFlagIndex] >= StoryFlagValue){
			this->Data = 0;
			Quit();
		}
		if(flags&FLAG_APPEAR && Game->Counter[StoryFlagIndex] < StoryFlagValue){
			this->Data = 0;
			Quit();
		}
		if(flags&FLAG_DISAPPEARFLAG && Game->Counter[StoryFlagIndex] & StoryFlagValue){
			this->Data = 0;
			Quit();
		}
		if(flags&FLAG_APPEARFLAG && !(Game->Counter[StoryFlagIndex] & StoryFlagValue)){
			this->Data = 0;
			Quit();
		}
		if(charID==SCHAR_MICAH){
			if(Game->GetCurDMap()==28){ //Hoku
				if(!DayNight_IsNight()||Game->Counter[CR_STORYFLAG]<SFLAG_POSTGRANDMA){
					this->Data = 0;
					Quit();
				}
				if(Game->Counter[CR_CULTISTQUEST]>0){ //Moves after first encounter
					this->Data = 0;
					Quit();
				}
			}
			else if(Game->GetCurDMap()==36){ //Temple Grounds
				if(Game->GetCurScreen()==0x30){
					if(Game->Counter[CR_CULTISTQUEST]==0){ //Haven't Encountered
						this->Data = 0;
						Quit();
					}
					if(Game->Counter[CR_CULTISTQUEST]>2){ //In Disguise
						this->Data = 0;
						Quit();
					}
				}
			}
			else if(Game->GetCurDMap()==37){ //Jungle temple
				if(Game->GetCurScreen()==0x64){
					if(Game->Counter[CR_CULTISTQUEST]!=4){
						this->Data = 0;
						Quit();
					}
				}
			}
		}
		if(charID == SCHAR_CAIMAN){
			if(Game->GetCurScreen() == 0x2D){
				if(Game->Counter[CR_TORRINSIDEQUEST] != 6){
					this->Data = 0;
					Quit();
				}
				if(Game->Counter[CR_STORYFLAG] >= SFLAG_MISTCLEAR && Game->Counter[CR_TORRINSIDEQUEST] == 6 && Game->Counter[CR_GOLEMSIDEQUEST] == 4){
					this->Data = 0;
					Quit();
				}
			}
			if(Game->GetCurScreen() == 0x2F){
				if(!(Game->Counter[CR_STORYFLAG] >= SFLAG_MISTCLEAR && Game->Counter[CR_TORRINSIDEQUEST] == 6 && Game->Counter[CR_GOLEMSIDEQUEST] == 4)){
					this->Data = 0;
					Quit();
				}
			}
		}
		if(charID == SCHAR_ZEKE){
			if(Game->GetCurScreen() == 0x2F){
				if(!(Game->Counter[CR_STORYFLAG] >= SFLAG_MISTCLEAR && Game->Counter[CR_TORRINSIDEQUEST] == 6 && Game->Counter[CR_GOLEMSIDEQUEST] == 4)){
					this->Data = 0;
					Quit();
				}
			}
		}
		if(charID == SCHAR_TERRY){
			if(Game->GetCurScreen() == 0x2F){
				if(Game->Counter[CR_STORYFLAG] >= SFLAG_MISTCLEAR && Game->Counter[CR_TORRINSIDEQUEST] == 6 && Game->Counter[CR_GOLEMSIDEQUEST] == 4){
					this->Data = 0;
					Quit();
				}
			}
			if(Game->GetCurDMap() == 74){
				if(G[G_RANDOMIZERENABLED]){
					this->Data = 0;
					Quit();
				}
				if(flags&FLAG_SCRIPTFLAG && Game->Counter[CR_HELPERQUEST] == 0){
					this->Data = 0;
					Quit();
				}
			}
		}
		if(charID == SCHAR_SIYED){
			if(Game->GetCurScreen() == 0x4C){
				if(Game->Counter[CR_GOLEMSIDEQUEST] != 2){
					this->Data = 0;
					Quit();
				}
			}
			if(Game->GetCurDMap() == 49){
				if(Game->Counter[CR_STORYFLAG] < SFLAG_MISTCLEAR || Game->Counter[CR_NIGHTMARCHERQUEST] >= 4){
					this->Data = 0;
					Quit();
				}
			}
			if(Game->GetCurDMap() == 74){
				if(G[G_RANDOMIZERENABLED]){
					this->Data = 0;
					Quit();
				}
				if(flags&FLAG_SCRIPTFLAG){
					if(Game->Counter[CR_HELPERQUEST] == 0){
						this->Data = 0;
						Quit();
					}
					else if(Game->Counter[CR_HELPERQUEST] < 3 && StoryFlagIndex == 1){
						this->Data = 0;
						Quit();
					}
					else if(Game->Counter[CR_HELPERQUEST] >= 3 && StoryFlagIndex == 0){
						this->Data = 0;
						Quit();
					}
				}
			}
		}
		if(charID == SCHAR_SOREN){
			if(Game->GetCurMap() == 2 && Game->GetCurScreen() == 0x3F){
				if(G[G_SORENATTEMPLE] == 1 && Game->Counter[CR_STORYFLAG] >= SFLAG_MISTENTERED && Game->Counter[CR_STORYFLAG] < SFLAG_GAMECLEAR){
					this->Data = 0;
					Quit();
				}
				else if(Game->Counter[CR_NIGHTMARCHERQUEST] == 7 && Game->Counter[CR_STORYFLAG] >= SFLAG_GAMECLEAR){
					this->Data = 0;
					Quit();
				}
			}
			if(Game->GetCurDMap() == 74){
				if(G[G_RANDOMIZERENABLED]){
					this->Data = 0;
					Quit();
				}
				if(flags&FLAG_SCRIPTFLAG && Game->Counter[CR_HELPERQUEST] == 0){
					this->Data = 0;
					Quit();
				}
			}
		}
		if(charID==SCHAR_MICAH3){
			if(Game->Counter[CR_STORYFLAG] < SFLAG_GAMECLEAR || Game->Counter[CR_CULTISTQUEST] < 6){
				this->Data = 0;
				Quit();
			}
		}
		if(charID==SCHAR_BOYGREENSHORTS){
			if(G[G_RANDOMIZERENABLED] && Game->GetCurScreen() == 0x4F){
				this->Data = 0;
				Quit();
			}
		}
		if(charID==SCHAR_BIF){
			if(G[G_RANDOMIZERENABLED] && Game->GetCurScreen() == 0x5E){
				this->Data = 0;
				Quit();
			}
		}
		if(Game->GetCurDMap() == 53){
			if(Game->Counter[CR_STORYFLAG] != SFLAG_MISTENTERED){
				this->Data = 0;
				Quit();
			}
			if(charID == SCHAR_TULANE || charID == SCHAR_PIRATE){
				if(!(Game->Counter[CR_MISTFLAGS] & BF_1)){
					this->Data = 0;
					Quit();
				}
			}
			if(charID == SCHAR_KENJA){
				if(!(Game->Counter[CR_MISTFLAGS] & BF_3)){
					this->Data = 0;
					Quit();
				}
			}
			if(charID == SCHAR_SKAI || charID == SCHAR_NELL || charID == SCHAR_MORT){
				if(!(Game->Counter[CR_MISTFLAGS] & BF_4)){
					this->Data = 0;
					Quit();
				}
			}
			if(charID == SCHAR_ALLIE || charID == SCHAR_BAND){
				if(!(Game->Counter[CR_MISTFLAGS] & BF_5)){
					this->Data = 0;
					Quit();
				}
			}
		}
		switch(msg){
			case 55: //Temple gatekeeper
				if(Game->Counter[CR_CULTISTQUEST]>=4){
					this->X -= 16;
					this->Y += 16;
					this->Data -= 2;
					if(Game->Counter[CR_CULTISTQUEST]>5){
						this->Data = 0;
						Quit();
					}
				}
				else if(Game->Counter[CR_CULTISTQUEST]==0){
					this->Data = 0;
					Quit();
				}
				break;
			case 57...61: //Temple cultists
			case 72...74: //Temple cultists
				if(Game->Counter[CR_CULTISTQUEST]>5){
					this->Data = 0;
					Quit();
				}
				break;
			case 106: //Chase
				if(!(DayNight_IsBetween(5, 0, 0, 13, 0, 0)||DayNight_IsBetween(12, 0, 0, 20, 0, 0))){
					this->Data = 0;
					Quit();
				}
				// if(Game->Counter[CR_STORYFLAG]<SFLAG_WAREHOUSE){
					// this->Data = 0;
					// Quit();
				// }
				if(Game->GetCurScreen()==0x3E&&Game->Counter[CR_CHASEQUEST]>1){
					this->Data = 0;
					Quit();
				}
				if(Game->GetCurScreen()==0x2B&&Game->Counter[CR_CHASEQUEST]!=2){
					this->Data = 0;
					Quit();
				}
				if(Game->GetCurScreen()==0x0D&&Game->Counter[CR_CHASEQUEST]!=3){
					this->Data = 0;
					Quit();
				}
				if(Game->GetCurScreen()==0x2D&&Game->Counter[CR_CHASEQUEST]!=4){
					this->Data = 0;
					Quit();
				}
				if(Game->GetCurScreen()==0x1B&&Game->Counter[CR_CHASEQUEST]!=5){
					this->Data = 0;
					Quit();
				}
				if(Game->GetCurScreen()==0x4E&&Game->Counter[CR_CHASEQUEST]!=6){
					this->Data = 0;
					Quit();
				}
				break;
		}
	}
	int DoIDoAnEvent(ffc this, int msg, int charID, int data, int dir){
		if(msg==55){ //Temple gatekeeper
			if(this->X==208&&Game->Counter[CR_CULTISTQUEST]==4){
				while(Link->X>192){
					DrawNPC(this, 33660, 7, DIR_LEFT);
					NoAction();
					Link->InputLeft = true;
					Waitframe();
				}
				while(Link->Y>80){
					DrawNPC(this, 33660, 7, DIR_LEFT);
					NoAction();
					Link->InputUp = true;
					Waitframe();
				}
				Link->Y = 80;
				Link->Dir = DIR_DOWN;
				for(int i=0; i<32; ++i){
					if(i%2==0)
						--this->X;
					DrawNPC(this, 33664, 7, DIR_LEFT);
					WaitNoAction();
				}
				for(int i=0; i<32; ++i){
					if(i%2==0)
						++this->Y;
					DrawNPC(this, 33664, 7, DIR_DOWN);
					WaitNoAction();
				}
				return DIR_UP;
			}
		}
		else if(msg==56){ //Micah temple switch
			if(Game->GetCurDMap()==37&&Game->GetCurScreen()==0x64){
				while(Link->Y<48){
					DrawNPC(this, 33644, 7, AngleDir4(Angle(this->X, this->Y, Link->X, Link->Y)));
					NoAction();
					Link->InputDown = true;
					Waitframe();
				}
				Link->Y = 48;
				Link->Dir = DIR_UP;
				for(int i=0; i<32; ++i){
					if(i%2==0)
						--this->X;
					DrawNPC(this, 33648, 7, DIR_LEFT);
					WaitNoAction();
				}
				for(int i=0; i<48; ++i){
					DrawNPC(this, 33644, 7, DIR_UP);
					WaitNoAction();
				}
				for(int i=0; i<16; ++i){
					DrawNPC(this, 51880, 7, DIR_UP);
					WaitNoAction();
				}
				Game->PlaySound(68);
				Game->PlaySound(9);
				Screen->TriggerSecrets();
				for(int i=0; i<32; ++i){
					DrawNPC(this, 33644, 7, DIR_UP);
					WaitNoAction();
				}
				for(int i=0; i<32; ++i){
					DrawNPC(this, 33644, 7, DIR_DOWN);
					WaitNoAction();
				}
				PlayString("Follow me. The door will shut behind us so nobody will follow.", SCHAR_MICAH, EMOTE_NORMAL, 68, 24);
				while(G[G_MSGACTIVE]){
					DrawNPC(this, 33644, 7, DIR_DOWN);
					G[G_NOACTION] = 1;
					Waitframe();
				}
				while(this->X>-16){
					--this->X;
					if(this->X<64&&this->Y<40)
						++this->Y;
					DrawNPC(this, 33648, 7, DIR_LEFT, 1);
					WaitNoAction();
				}
				Game->Counter[CR_CULTISTQUEST] = 5;
				Screen->State[ST_SECRET] = true;
				this->Data = 0;
				Quit();
			}
		}
		else if(msg==106){ //Chase
			bool fadeOut;
			int dir;
			if(Game->GetCurScreen()==0x3E&&Game->Counter[CR_CHASEQUEST]>1){
				dir = DIR_UP;
				fadeOut = true;
			}
			if(Game->GetCurScreen()==0x2B&&Game->Counter[CR_CHASEQUEST]>2){
				dir = DIR_DOWN;
				fadeOut = true;
			}
			if(Game->GetCurScreen()==0x0D&&Game->Counter[CR_CHASEQUEST]>3){
				dir = DIR_RIGHT;
				fadeOut = true;
			}
			if(Game->GetCurScreen()==0x2D&&Game->Counter[CR_CHASEQUEST]>4){
				dir = DIR_LEFT;
				fadeOut = true;
			}
			if(Game->GetCurScreen()==0x1B&&Game->Counter[CR_CHASEQUEST]>5){
				dir = DIR_LEFT;
				fadeOut = true;
			}
			if(fadeOut){
				for(int i=0; i<24; ++i){
					DrawNPC(this, 33848, 7, dir);
					Screen->Rectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
					if(i>=8)
						Screen->Rectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
					if(i>=16)
						Screen->Rectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
					NoAction();
					Waitframe();
				}
				for(int i=23; i>0; --i){
					Screen->Rectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
					if(i>=8)
						Screen->Rectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
					if(i>=16)
						Screen->Rectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
					NoAction();
					Waitframe();
				}
				this->Data = 0;
				Quit();
			}
		}
		else if(msg==89){ //Zarath
			if(G[G_RANDOMIZERENABLED]){
				if(!Screen->State[ST_ITEM]){
					int handler[6];
					int Affirm[] = "Yes";
					int Deny[] = "No";
					int Options[] = {Affirm, Deny};
					while(handler[1] == 0){
						DialogueBox_RunSingleFrame(handler, 128, 8+52, Options, TIL_DB_DIALOGUE_BOX, CS_DB_DIALOGUE_BOX, C_DB_DIALOGUE_BOX_BG, FONT_P, 0xB2, TIL_DB_DIALOGUE_SELECTOR, CS_DB_DIALOGUE_SELECTOR);
						DrawNPC(this, data, 7, dir);
						WaitNoAction();
					}
					if(handler[0]==0){
						if(Game->Counter[CR_RUPEES]>=300){
							switch(GetCharID()){
								case CHAR_ASHER:
									PlayString("We got this money by clobbering animals and robbing people. That's fine right?", SCHAR_ASHER, EMOTE_WINK, 68, YPOS_LOWER);
									break;
								case CHAR_TORRIN:
									PlayString("I'm feelin' lucky today. Let's see it.", SCHAR_TORRIN, 0, 68, YPOS_LOWER);
									break;
								case CHAR_KAYLANI:
									PlayString("Seems suspicious, but then again it could be useful...Oh why not?", SCHAR_KAYLANI, EMOTE_ELLIPSES, 68, YPOS_LOWER);
									break;
								case CHAR_SOREN:
									PlayString("I'll bite. Besides, I've got cash for days after that whole kidnapping business.", SCHAR_SORENPANTS, 0, 68, YPOS_LOWER);
									break;
								case CHAR_TERRY:
									PlayString("S'pose it can't hurt. I love a good mystery.", SCHAR_TERRY, 0, 68, YPOS_LOWER);
									break;
								case CHAR_SIYED:
									PlayString("Um...If it costs that much it must be worth something, right?", SCHAR_SIYED, EMOTE_SWEAT, 68, YPOS_LOWER);
									break;
							}
							while(G[G_MSGACTIVE]){
								DrawNPC(this, data, 7, dir);
								G[G_NOACTION] = 1;
								Waitframe();
							}
							if(GetCharID()==CHAR_ASHER){
								PlayString("That works for me. Enjoy your life lesson!", SCHAR_ZARATH, EMOTE_HAPPY, 68, YPOS_LOWER);
							}
							else{
								PlayString("Alright, I've got my money so let's reveal your item...", SCHAR_ZARATH, EMOTE_HAPPY, 68, YPOS_LOWER);
							}
							Game->DCounter[CR_RUPEES] -= 300;
							while(G[G_MSGACTIVE]){
								DrawNPC(this, data, 7, dir);
								G[G_NOACTION] = 1;
								Waitframe();
							}
							int itemid = RandomizedItems[IL_ZARATHLIFELESSON];
							int str[512];
							int itemName[512];
							ItemName(itemName, itemid);
							sprintf(str, "Today you've won...@delay(60)@26@26...@delay(60)@26@26. . .@delay(60)@26@26%s!", itemName);
							PlayString(str, SCHAR_ZARATH, 0, 68, YPOS_LOWER);
							while(G[G_MSGACTIVE]){
								DrawNPC(this, data, 7, dir);
								G[G_NOACTION] = 1;
								Waitframe();
							}
							item itm = SpawnRandomizerItem(IL_ZARATHLIFELESSON, itemid, Link->X, Link->Y);
							itm->Pickup |= IP_HOLDUP|IP_ST_ITEM;
							while(itm->isValid()){
								DrawNPC(this, data, 7, dir);
								G[G_NOACTION] = 1;
								Waitframe();
							}
							while(Link->Action==LA_HOLD1LAND||Link->Action==LA_HOLD2LAND){
								DrawNPC(this, data, 7, dir);
								G[G_NOACTION] = 1;
								Waitframe();
							}
							switch(itemid){
								case I_ASHER:
								case I_TORRIN:
								case I_KAYLANI:
								case I_SOREN:
								case I_TERRY:
								case I_SIYED:
									switch(GetCharID()){
										case CHAR_ASHER:
											PlayString("...Where I come from we call that slavery.", SCHAR_ASHER, EMOTE_ANGRY, 68, YPOS_LOWER);
											break;
										case CHAR_TORRIN:
											PlayString("Oi! What're you trying to play here, mate?", SCHAR_TORRIN, EMOTE_ANGRY, 68, YPOS_LOWER);
											break;
										case CHAR_KAYLANI:
											PlayString("Absolutely unacceptable! I'll see to it the astronomers hear about this activity!", SCHAR_KAYLANI, EMOTE_ANGRY, 68, YPOS_LOWER);
											break;
										case CHAR_SOREN:
											PlayString("Yikes! I didn't realize it was that kind of store.", SCHAR_SORENPANTS, EMOTE_ANGRY, 68, YPOS_LOWER);
											break;
										case CHAR_TERRY:
											PlayString("Y'want a faceful o' pain, pal? What are you pulling here?", SCHAR_TERRY, EMOTE_ANGRY, 68, YPOS_LOWER);
											break;
										case CHAR_SIYED:
											int str2[512];
											int name[16];
											ItemName(name, itemid);
											sprintf(str2, "How terrible! Are you okay, %s?", name);
											PlayString(str2, SCHAR_SIYED, EMOTE_DISMAYED, 68, YPOS_LOWER);
											break;
									}
									while(G[G_MSGACTIVE]){
										DrawNPC(this, data, 7, dir);
										G[G_NOACTION] = 1;
										Waitframe();
									}
									PlayString("Hold on a sec, it was a joke! A joke! Your friend and I were just pulling a prank on you, alright? Here, to make it up, I'll refund the money you gave me.", SCHAR_ZARATH, EMOTE_SWEAT, 68, YPOS_LOWER);
									while(G[G_MSGACTIVE]){
										DrawNPC(this, data, 7, dir);
										G[G_NOACTION] = 1;
										Waitframe();
									}
									Game->DCounter[CR_RUPEES] += 300;
									break;
								case I_CANDLE2:
								case I_LOBBOMB:
								case I_TIDALGAUNTLETMOON:
								case I_WAND:
								case I_LUNARANG:
								case I_ABILITY_A_ASHER:
								case I_ABILITY_B_TORRIN:
								case I_ABILITY_C_SOREN:
								case I_ABILITY_B_TERRY:
								case I_ABILITY_C_TERRY:
								case I_ABILITY_B_SIYED:
									switch(GetCharID()){
										case CHAR_ASHER:
											PlayString("Oh wow! Wasn't expecting it to be worth the price.", SCHAR_ASHER, EMOTE_SURPRISED, 68, YPOS_LOWER);
											break;
										case CHAR_TORRIN:
											PlayString("Blimey! We'd've hated to miss that one!", SCHAR_TORRIN, EMOTE_SURPRISED, 68, YPOS_LOWER);
											break;
										case CHAR_KAYLANI:
											PlayString("Well! Forgive me for my doubts, earlier.", SCHAR_KAYLANI, EMOTE_SURPRISED, 68, YPOS_LOWER);
											break;
										case CHAR_SOREN:
											PlayString("Aha! I knew it'd be worth it!", SCHAR_SORENPANTS, EMOTE_SURPRISED, 68, YPOS_LOWER);
											break;
										case CHAR_TERRY:
											PlayString("Now that was some surprise!", SCHAR_TERRY, EMOTE_SURPRISED, 68, YPOS_LOWER);
											break;
										case CHAR_SIYED:
											PlayString("Phew! It was worth the price after all.", SCHAR_SIYED, EMOTE_SURPRISED, 68, YPOS_LOWER);
											break;
									}
									while(G[G_MSGACTIVE]){
										DrawNPC(this, data, 7, dir);
										G[G_NOACTION] = 1;
										Waitframe();
									}
									break;
								case I_HYMNSTONE:
								case I_RUPEE5:
								case I_RUPEE10:
								case I_RUPEE20:
								case I_AUGMENT_BOMB:
								case I_AUGMENT_MAGNET:
									switch(GetCharID()){
										case CHAR_ASHER:
											PlayString("Figures...", SCHAR_ASHER, EMOTE_SWEAT, 68, YPOS_LOWER);
											break;
										case CHAR_TORRIN:
											PlayString("...I wanna refund!", SCHAR_TORRIN, EMOTE_SAD, 68, YPOS_LOWER);
											break;
										case CHAR_KAYLANI:
											PlayString("Well, we've learned something for next time.", SCHAR_KAYLANI, 0, 68, YPOS_LOWER);
											break;
										case CHAR_SOREN:
											PlayString("Darn.", SCHAR_SORENPANTS, 0, 68, YPOS_LOWER);
											break;
										case CHAR_TERRY:
											PlayString("Aww...Well can't win 'em all.", SCHAR_TERRY, 0, 68, YPOS_LOWER);
											break;
										case CHAR_SIYED:
											PlayString("It's just as I thought...", SCHAR_SIYED, EMOTE_EMBARRASSED, 68, YPOS_LOWER);
											break;
									}
									while(G[G_MSGACTIVE]){
										DrawNPC(this, data, 7, dir);
										G[G_NOACTION] = 1;
										Waitframe();
									}
									break;
								default:
									switch(GetCharID()){
										case CHAR_ASHER:
											PlayString("Could've been worse.", SCHAR_ASHER, EMOTE_SWEAT, 68, YPOS_LOWER);
											break;
										case CHAR_TORRIN:
											PlayString("Yeah, that's alright.", SCHAR_TORRIN, 0, 68, YPOS_LOWER);
											break;
										case CHAR_KAYLANI:
											PlayString("This could prove useful.", SCHAR_KAYLANI, EMOTE_SURPRISED, 68, YPOS_LOWER);
											break;
										case CHAR_SOREN:
											PlayString("A little pricey, but I'll take it.", SCHAR_SORENPANTS, 0, 68, YPOS_LOWER);
											break;
										case CHAR_TERRY:
											PlayString("Been wantin' one o' these.", SCHAR_TERRY, EMOTE_HAPPY, 68, YPOS_LOWER);
											break;
										case CHAR_SIYED:
											PlayString("That's not so bad, right?", SCHAR_SIYED, EMOTE_SWEAT, 68, YPOS_LOWER);
											break;
									}
									while(G[G_MSGACTIVE]){
										DrawNPC(this, data, 7, dir);
										G[G_NOACTION] = 1;
										Waitframe();
									}
									break;
							}
							
						}
						else{
							PlayString("Terribly sorry, this isn't enough. Don't worry though, I'll be here all year.", SCHAR_ZARATH, EMOTE_HAPPY, 68, YPOS_LOWER);
							while(G[G_MSGACTIVE]){
								DrawNPC(this, data, 7, dir);
								G[G_NOACTION] = 1;
								Waitframe();
							}
							PlayString("...Please don't wait an actual year just to test me.", SCHAR_ZARATH, EMOTE_ELLIPSES, 68, YPOS_LOWER);
							while(G[G_MSGACTIVE]){
								DrawNPC(this, data, 7, dir);
								G[G_NOACTION] = 1;
								Waitframe();
							}
						}
					}
					else{
						PlayString("Alright. I'll always be here if you change your mind.", SCHAR_ZARATH, 0, 68, YPOS_LOWER);
						while(G[G_MSGACTIVE]){
							DrawNPC(this, data, 7, dir);
							G[G_NOACTION] = 1;
							Waitframe();
						}
					}
				}
			}
			else if(Game->Counter[CR_STORYFLAG]>=SFLAG_METGRANDMA&&Game->Counter[CR_STORYFLAG]<SFLAG_GAMECLEAR){
				if(Screen->D[0]){
					return dir;
				}
				int handler[6];
				int Affirm[] = "Yes";
				int Deny[] = "No";
				int Options[] = {Affirm, Deny};
				while(handler[1] == 0){
					DialogueBox_RunSingleFrame(handler, 128, 8+52, Options, TIL_DB_DIALOGUE_BOX, CS_DB_DIALOGUE_BOX, C_DB_DIALOGUE_BOX_BG, FONT_P, 0xB2, TIL_DB_DIALOGUE_SELECTOR, CS_DB_DIALOGUE_SELECTOR);
					DrawNPC(this, data, 7, dir);
					WaitNoAction();
				}
				if(handler[0]==0){
					PlayString("Splendid. It's been some time since I've been able to really let loose. Okay then, let's make this a good fair fight.", SCHAR_ZARATH, EMOTE_NORMAL, 68, YPOS_LOWER);
					while(G[G_MSGACTIVE]){
						DrawNPC(this, data, 7, dir);
						G[G_NOACTION] = 1;
						Waitframe();
					}
					Game->PlayEnhancedMusic("SS-Boss.ogg", 0);
					if(Link->X<this->X){
						while(!WalkLinkToPoint(96, 56)){
							DrawNPC(this, data, 7, DIR_DOWN);
							Waitframe();
						}
						Link->Dir = DIR_RIGHT;
						for(int i=0; i<8; ++i){
							++this->Y;
							DrawNPC(this, data+4, 7, DIR_DOWN);
							WaitNoAction();
						}
						dir = DIR_LEFT;
						for(int i=0; i<24; ++i){
							++this->X;
							DrawNPC(this, data+4, 7, dir);
							WaitNoAction();
						}
						for(int i=0; i<96; ++i){
							DrawNPC(this, data, 7, dir);
							WaitNoAction();
						}
					}
					else{
						while(!WalkLinkToPoint(192, 56)){
							DrawNPC(this, data, 7, DIR_DOWN);
							Waitframe();
						}
						Link->Dir = DIR_LEFT;
						for(int i=0; i<8; ++i){
							++this->Y;
							DrawNPC(this, data+4, 7, DIR_DOWN);
							WaitNoAction();
						}
						dir = DIR_RIGHT;
						for(int i=0; i<24; ++i){
							--this->X;
							DrawNPC(this, data+4, 7, dir);
							WaitNoAction();
						}
						for(int i=0; i<96; ++i){
							DrawNPC(this, data, 7, dir);
							WaitNoAction();
						}
					}
					Game->PlayMIDI(0);
					PlayString("Pfft! Okay I can't go on pranking you kids. Have you SEEN the size of this dock? I don't fancy a swim today, no sir.", SCHAR_ZARATH, EMOTE_HAPPY, 68, YPOS_LOWER);
					while(G[G_MSGACTIVE]){
						DrawNPC(this, data, 7, dir);
						G[G_NOACTION] = 1;
						Waitframe();
					}
					PlayString("And who picks a fight with someone in the middle of town anyways? Do I even look like a fighter?", SCHAR_ZARATH, EMOTE_HAPPY, 68, YPOS_LOWER);
					while(G[G_MSGACTIVE]){
						DrawNPC(this, data, 7, dir);
						G[G_NOACTION] = 1;
						Waitframe();
					}
					PlayString("Aww, I kinda wanted to see what fancy moves this guy had.", SCHAR_ASHER, EMOTE_EMBARRASSED, 68, YPOS_LOWER);
					while(G[G_MSGACTIVE]){
						DrawNPC(this, data, 7, dir);
						G[G_NOACTION] = 1;
						Waitframe();
					}
					PlayString("I have this one move where I sell you this floral lampshade at the low, low price of 20 silvers. How's that sound?", SCHAR_ZARATH, EMOTE_WINK, 68, YPOS_LOWER);
					while(G[G_MSGACTIVE]){
						DrawNPC(this, data, 7, dir);
						G[G_NOACTION] = 1;
						Waitframe();
					}
					PlayString("Not interested.", SCHAR_ASHER, EMOTE_NORMAL, 68, YPOS_LOWER);
					while(G[G_MSGACTIVE]){
						DrawNPC(this, data, 7, dir);
						G[G_NOACTION] = 1;
						Waitframe();
					}
					Screen->D[0] = 1;
					return dir;
				}
				else{
					PlayString("Ah, that's a shame. Some other time then.", SCHAR_ZARATH, EMOTE_NORMAL, 68, 24);
					while(G[G_MSGACTIVE]){
						DrawNPC(this, data, 7, dir);
						G[G_NOACTION] = 1;
						Waitframe();
					}
					return dir;
				}
			}
		}
		else if(msg==108){ //Winno
			if(G[G_RANDOMIZERENABLED]){
				if(G[G_WINNOHINTCOOLDOWN]<=0||G[G_WINNOHINTITEM]>0){
					int roomFlags[1024];
					for(int i=0; i<IL_COUNT; ++i){
						roomFlags[i] = RandomizedItems[RI_FLAGS+i];
					}
					int itemPlaced[1512];
					int maxItem[1512];
					
					for(int i=0; i<256; ++i){
						switch(i){
							case 170: //Asher's dash
							case 178:
								if(Link->Item[i]||FoundItems[i]){
									++itemPlaced[170];
									++itemPlaced[178];
								}
								maxItem[i] = 2;
								break;
							case 87: //Hymnstones
								itemPlaced[i] += Game->Counter[CR_TOTALHYMNSTONES];
								break;
							case I_ASHER:
							case I_TORRIN:
							case I_KAYLANI:
							case I_SOREN:
							case I_TERRY:
							case I_SIYED:
								if(Link->Item[i])
									itemPlaced[i] = 1;
								maxItem[i] = 1;
								break;
							default:
								if(Link->Item[i]||FoundItems[i])
									itemPlaced[i] = 1;
								maxItem[i] = 1;
								break;
						}
					}
					untyped dat[32];
					
					dat[RandomizerLogic::ARR_ROOMFLAGS] = roomFlags;
					dat[RandomizerLogic::ARR_ITEMPLACED] = itemPlaced;
					
					for(int i=0; i<256; ++i){
						if(itemPlaced[i]){
							int flag = RandomizedItems[RI_ITEMFLAGS+i];
							if(flag!=-1){
								dat[RandomizerLogic::FLAGS_OBTAINED] |= flag;
							}
							RandomizerLogic::GiveItemFlags(dat, i);
						}
					}
					//Trace(dat[RandomizerLogic::FLAGS_OBTAINED]);
					
					int itemRooms[512];
					int numItemRooms;
					//printf("Items: ");
					for(int i=0; i<IL_COUNT; ++i){
						int itemID = RandomizedItems[i];
						switch(itemID){
							case I_CANDLE2:
							case I_LOBBOMB:
							case I_TIDALGAUNTLETMOON:
							case I_WAND:
							case I_LUNARANG:
							case I_ABILITY_A_ASHER:
							case I_ABILITY_B_TORRIN:
							case I_ABILITY_B_SOREN:
							case I_ABILITY_B_TERRY:
							case I_ABILITY_C_TERRY:
							case I_ABILITY_C_SOREN:
							case I_STARSTONE:
							case I_ASHER:
							case I_TORRIN:
							case I_KAYLANI:
							case I_SOREN:
							case I_TERRY:
							case I_SIYED:
								if(RandomizerLogic::CanAccessRoom(dat, i, false)&&itemPlaced[itemID]<maxItem[itemID]&&HasAssociatedCharacter(itemID)){
									//printf("%d[%d] ", i, itemID);
									itemRooms[numItemRooms] = i;
									++numItemRooms;
								}
								break;
						}
					}
					//printf("(%d)\n", numItemRooms);
					int roomResult = -1;
					int itemResult = -1;
					if(numItemRooms>0){
						roomResult = itemRooms[Rand(numItemRooms)];
						itemResult = RandomizedItems[roomResult];
					}
					if(G[G_WINNOHINTCOOLDOWN]<=0){
						G[G_WINNOHINTROOM] = roomResult;
						G[G_WINNOHINTITEM] = itemResult;
						G[G_WINNOHINTCOOLDOWN] = WINNO_COOLDOWN;
					}
					
					if(G[G_WINNOHINTITEM]==-1){
						PlayString("Ah, the stars told me you'd be coming...@delay(60)@26@26But they failed to divulge anything useful. My apologies.", SCHAR_WINNO, EMOTE_NORMAL, 68, YPOS_LOWER);
						while(G[G_MSGACTIVE]){
							DrawNPC(this, data, 7, dir);
							G[G_NOACTION] = 1;
							Waitframe();
						}
					}
					else{
						int itemStr[512];
						int roomStr[512];
						switch(G[G_WINNOHINTITEM]){
							case I_CANDLE2: CopyStringToBuffer(itemStr, "the lantern is"); break;
							case I_LOBBOMB: CopyStringToBuffer(itemStr, "the lobber bombs are"); break;
							case I_TIDALGAUNTLETMOON: CopyStringToBuffer(itemStr, "the tidal gauntlet is"); break;
							case I_WAND: CopyStringToBuffer(itemStr, "the stellar wand is"); break;
							case I_LUNARANG: CopyStringToBuffer(itemStr, "the lunarang is"); break;
							case I_ABILITY_A_ASHER: CopyStringToBuffer(itemStr, "the dash ability is"); break;
							case I_ABILITY_B_TORRIN: CopyStringToBuffer(itemStr, "Torrin's batteries are"); break;
							case I_ABILITY_B_SOREN: CopyStringToBuffer(itemStr, "the reckless ricochet is"); break;
							case I_ABILITY_B_TERRY: CopyStringToBuffer(itemStr, "Terry's batteries are"); break;
							case I_ABILITY_C_SOREN: CopyStringToBuffer(itemStr, "the grappling hook is"); break;
							case I_ABILITY_C_TERRY: CopyStringToBuffer(itemStr, "the bloodmoon gauntlet is"); break;
							default:
								int tmpstr[256];
								ItemName(tmpstr, G[G_WINNOHINTITEM]);
								sprintf(itemStr, "%s is", tmpstr);
								break;
						}
						RandomizerLogic::ItemLocationNameVague(roomStr, G[G_WINNOHINTROOM]);
						int str[512];
						sprintf(str, "Ah, the stars told me you'd be coming...Let me see...If I can recall, it would seem that %s %s.", itemStr, roomStr);
						PlayString(str, SCHAR_WINNO, EMOTE_NORMAL, 68, YPOS_LOWER);
						while(G[G_MSGACTIVE]){
							DrawNPC(this, data, 7, dir);
							G[G_NOACTION] = 1;
							Waitframe();
						}
					}
				}
				else{
					PlayString("Ah, the stars told me you'd be coming...@delay(60)@26@26But the skies have been too cloudy as of late to get a clear reading. Please have patience, it will clear up soon.", SCHAR_WINNO, EMOTE_NORMAL, 68, YPOS_LOWER);
					while(G[G_MSGACTIVE]){
						DrawNPC(this, data, 7, dir);
						G[G_NOACTION] = 1;
						Waitframe();
					}
				}	
			}
		}
		return -1;
	}
	void DrawNPC(ffc this, int cmb, int cs, int dir){
		combodata cd = Game->LoadComboData(cmb+dir);
		int til = cd->Tile;
		int flip = cd->Flip;
		Screen->DrawTile(2, this->X, this->Y, til+20, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
		Screen->DrawTile(4, this->X, this->Y-16, til, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
	}
	void DrawNPC(ffc this, int cmb, int cs, int dir, int specialLayer){
		combodata cd = Game->LoadComboData(cmb+dir);
		int til = cd->Tile;
		int flip = cd->Flip;
		int layerbottom = 2;
		int layertop = 4;
		if(specialLayer==1)
			layertop = 2;
		Screen->DrawTile(layerbottom, this->X, this->Y, til+20, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
		Screen->DrawTile(layertop, this->X, this->Y-16, til, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
	}
	bool NPCHasQuest(int msg){
		switch(msg){
			case 9: //Iris Quest
				if(Game->Counter[CR_STORYFLAG]>SFLAG_WAREHOUSE){
					unless(Game->Counter[CR_STORYFLAG] >= SFLAG_ASHERKIDNAPPED && Game->Counter[CR_STORYFLAG] < SFLAG_ASHERRESCUED){
						if(Game->Counter[CR_ASHERSIDEQUEST] == 0)
							return true;
					}
				}
				break;
			case 35: //Terry's Quest
				if(Game->Counter[CR_TORRINSIDEQUEST] == 0 || Game->Counter[CR_TORRINSIDEQUEST] == 10){
					if(Game->Counter[CR_STORYFLAG] >= SFLAG_SHOALSOPEN)
						return true;
				}
				break;
			case 75: //Siyed's Quest
				if(Game->Counter[CR_GOLEMSIDEQUEST] == 0)
					return true;
				break;
			case 50: //Laverne's Quest
				mapdata l2 = Game->LoadTempScreen(2);
				if(l2->ComboS[74])
					return false;
				if(!(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_0))
					return true;
				break;
			case 52: //Truf's Quest
				if(!(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_3))
					return true;
				break;
			case 56: //Micah's Quest
				if(Game->Counter[CR_CULTISTQUEST]==0)
					return true;
				break;
			case 40: //Soren's Quest
				if(CanUseChar(CHAR_ASHER) > 0){
					if(Game->Counter[CR_MISCSIDEQUEST] == 0)
						return true;
				}
				break;
			case 100: //Nightmarcher Quest
				if(Game->Counter[CR_NIGHTMARCHERQUEST] == 0)
					return true;
				break;
		}
		return false;
	}
	void run(int msg, int charID, int wanderX, int wanderY, int wanderStep, int delay, int flags, int storyflag){
		int cmb = Floor(this->Data/4)*4;
		int cs = this->CSet;
		this->Y += 16;
		
		int StoryFlagIndex = Floor(storyflag);
		int StoryFlagValue = (storyflag - StoryFlagIndex)*100;
		
		DoIVanish(this, msg, charID, flags, StoryFlagIndex, StoryFlagValue);
		
		if(charID == SCHAR_MOM){
			if(CountFFCsRunning(Game->GetFFCScript("IntroCutscene")) > 0){
				this->Data = 0;
				Quit();
			}
		}
		
		int talkYOff;
		if(charID == SCHAR_EVAN){
			talkYOff = -8;
		}
		
		int startX = this->X;
		int startY = this->Y;
		int startDir = this->Data%4;
		int realStartDir = startDir;
		int dir = startDir;
		int curX = startX;
		int curY = startY;
		bool canWander = (wanderX>0&&wanderY>0);
		bool wanderToStart;
		int wanderCooldown = delay;
		this->Data = GH_INVISIBLE_COMBO;
		this->TileWidth = 1;
		this->TileHeight = 1;
		int til; int flip;
		int vX; int vY;
		int angle;
		bool inMotion;
		bool preload = this->Flags[FFCF_PRELOAD];
		while(true){
			bool inLinkRange = (Abs(curX-Link->X)<24&&Abs(curY-Link->Y)<24);
			if(canWander&&(flags&FLAG_NOTURN))
				inLinkRange = false;
			combodata cd = Game->LoadComboData(cmb+dir);
			if(inMotion)
				cd = Game->LoadComboData(cmb+dir+4);
			til = cd->Tile;
			flip = cd->Flip;
			if(inLinkRange){
				if(!(flags&FLAG_NOTURN))
					dir = AngleDir4(Angle(curX, curY, Link->X, Link->Y));
					
				inMotion = false;
			}
			else{
				if(canWander){
					if(wanderCooldown){
						inMotion = false;
						dir = startDir;
						if((flags&FLAG_NOTURN))
							dir = realStartDir;
						--wanderCooldown;
					}
					else{
						inMotion = true;
						if(wanderToStart){
							angle = Angle(curX, curY, startX, startY);
							startDir = AngleDir4(angle);
							dir = startDir;
							if(Distance(curX, curY, startX, startY)>wanderStep){
								curX += VectorX(wanderStep, angle);
								curY += VectorY(wanderStep, angle);
							}
							else{
								curX = startX;
								curY = startY;
								wanderCooldown = delay;
								wanderToStart = !wanderToStart;
							}
						}
						else{
							angle = Angle(curX, curY, wanderX, wanderY);
							startDir = AngleDir4(angle);
							dir = startDir;
							if(Distance(curX, curY, wanderX, wanderY)>wanderStep){
								curX += VectorX(wanderStep, angle);
								curY += VectorY(wanderStep, angle);
							}
							else{
								curX = wanderX;
								curY = wanderY;
								wanderCooldown = delay;
								wanderToStart = !wanderToStart;
							}
						}
					}
				}
				else
					dir = startDir;
			}
			
			bool hasQuest = NPCHasQuest(msg);
			int talkX = this->X;
			int talkY = this->Y-16-8+talkYOff;
			if(flags&FLAG_SHOP){
				ffc f = Screen->LoadFFC(1);
				talkX = f->X;
				talkY = f->Y-16-8;
			}
			if(CanTalk(this)&&!IsCovered(this, flags)){
				Screen->FastCombo(6, talkX, talkY, CMB_CANTALK, 0, 128);
				if(Link->PressA){
					G[G_DASHINTERRUPT] = 1;
					if(!(flags&FLAG_NOSOLID))
						SolidObjects_Add(0, this->X, this->Y-2, 16, 18, vX, vY, 0);
					int strbuf[2048];
					G[G_CONVOINCREMENTER] = 1;
					do{
						G[G_CONVOLENGTH] = 0;
						int metadata[16];
						int skip = LoadString(strbuf, msg, metadata, cmb, til, cs, flags, flip, this);
						if(skip == 1)
							break;
						int emote = 0;
						int emotetime = 0;
						if(metadata[STMD_CHAR])
							charID = metadata[STMD_CHAR];
						if(metadata[STMD_EMOTE])
							emote = metadata[STMD_EMOTE];
						if(metadata[STMD_EMOTETIME])
							emotetime = metadata[STMD_EMOTETIME];
						PlayString(strbuf, charID, emote, 68, 24);
						G[G_MSGEMOTECOOLDOWN] = emotetime;
						if(G[G_PORTRAITTIL]==0){
							ClearStringPortrait(8, 24);
						}
						NoAction();
						while(G[G_MSGACTIVE]){
							if(cmb>1&&!IsCovered(this, flags)){
								Screen->DrawTile(2, this->X, this->Y, til+20, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
								Screen->DrawTile(4, this->X, this->Y-16, til, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
							}
							G[G_NOACTION] = 1;
							Waitframe();
						}
						++G[G_CONVOINCREMENTER];
					}while(G[G_CONVOINCREMENTER]<=G[G_CONVOLENGTH])
					// while((Link->InputA||Link->InputB)){
						// if(cmb>1&&!IsCovered(this, flags)){
							// Screen->DrawTile(2, this->X, this->Y, til+20, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
							// Screen->DrawTile(4, this->X, this->Y-16, til, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
						// }
						// NoAction();
						// Waitframe();
					// }
					int newDir = DoIDoAnEvent(this, msg, charID, cmb, dir);
					if(newDir>-1){
						startDir = newDir;
						realStartDir = newDir;
						curX = this->X;
						curY = this->Y;
						startX = this->X;
						startY = this->Y;
					}
					G[G_ENDAPRESS] = 1;
					G[G_ENDBPRESS] = 1;
				}
			}
			else{
				if(hasQuest){
					Screen->DrawCombo(6, talkX-8, talkY, CMB_CANTALKQUEST, 2, 1, 8, -1, -1, 0, 0, 0, -1, 0, true, 128);
				}
			}
			
			this->X = curX;
			this->Y = curY;
			if(cmb>1&&!IsCovered(this, flags)&&G[G_FITNESSGRAMPACEROFFSET]==0&&!preload){
				Screen->DrawTile(2, this->X, this->Y, til+20, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
				Screen->DrawTile(4, this->X, this->Y-16, til, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
			}
			if(!(flags&FLAG_NOSOLID))
				SolidObjects_Add(0, this->X, this->Y-2, 16, 18, vX, vY, 0);
			
			preload = false;
			Waitframe();
		}
	}
}

ffc script SecretItem{
	void run(int itemid, int holdup, int fall, int randomizerIndex){
		if(G[G_RANDOMIZERENABLED]&&randomizerIndex>0){
			if(RandomizedItems[randomizerIndex]>0){
				itemid = RandomizedItems[randomizerIndex];
				itemid = Randomizer_ProgressiveItem(itemid);
			}
		}
			
		if(Screen->State[ST_ITEM])
			Quit();
		while(!Screen->State[ST_SECRET]){
			Waitframe();
		}
		itemsprite itm = SpawnRandomizerItem(randomizerIndex, itemid, this->X, this->Y);
		if(holdup)
			itm->Pickup |= IP_HOLDUP;
		itm->Pickup |= IP_ST_ITEM;
		if(fall){
			Game->PlaySound(SFX_FALL);
			itm->Z = 176;
		}
		else{
			Game->PlaySound(7);
		}
	}
}

ffc script MidpointWarp{
	void run(int dmap, int scrn, int id, int trigger, int layer){
		if(!G[G_RANDOMIZERENABLED]&&Game->GetCurDMap()==17&&this->Data==30280&&Game->Counter[CR_STORYFLAG]>=SFLAG_ASHERKIDNAPPED)
			Quit();
		
		int pos = ComboAt(this->X+8, this->Y+8);
		int cmb = this->Data;
		this->Data = GH_INVISIBLE_COMBO;
		bool timeHasPassed;
		
		int d = Floor(id/16);
		int dbit = 1<<(id%16);
		if(trigger>0){
			while(!Screen->State[trigger]){
				timeHasPassed = true;
				Waitframe();
			}
			Screen->D[d] |= dbit;
			Game->SetDMapScreenD(dmap, scrn, d, Game->GetDMapScreenD(dmap, scrn, d)|dbit);
		}
		while(!(Screen->D[d]&dbit)){
			timeHasPassed = true;
			Waitframe();
		}
		int layer0 = 0;
		int layer4 = 4;
		if(layer==1){
			layer0 = 1;
			layer4 = 2;
		}
		else if(layer==2){
			if(timeHasPassed){
				layer0 = 2;
				layer4 = 4;
			}
			else{
				layer0 = 4;
				layer4 = 5;
			}
		}
		bool extraZero;
		if(layer-1==G[G_OVERUNDERLAYER])
			extraZero = true;
		mapdata l0 = Game->LoadTempScreen(layer0);
		mapdata l4 = Game->LoadTempScreen(layer4);
		l0 = Game->LoadTempScreen(layer0);
		l4 = Game->LoadTempScreen(layer4);
		l0->ComboD[pos] = cmb;
		l0->ComboC[pos] = this->CSet;
		if(extraZero){
			Screen->ComboD[pos] = cmb;
			Screen->ComboC[pos] = this->CSet;
		}
		l4->ComboD[pos-16] = cmb+1;
		l4->ComboC[pos-16] = this->CSet;
		l4->ComboD[pos] = cmb+2;
		l4->ComboC[pos] = this->CSet;
	}
}

ffc script PitRespawn{
	void run(int special, int dmap, int scrn, int retX, int retY){
		int returnX = this->X;
		int returnY = this->Y;
		if(special==1){
			while(!Screen->State[ST_SPECIALITEM]){
				Waitframe();
			}
			returnX = Link->X;
			returnY = Link->Y;
			Screen->EntryX = returnX;
			Screen->EntryY = returnY;
		}
		else if(special==2){
			returnX = -1;
			returnY = -1;
		}
		else if(special==3){
			G[G_PITRESPAWNDMAP] = dmap;
			G[G_PITRESPAWNSCREEN] = scrn;
			if(this->X>0||this->Y>0){
				G[G_PITRESPAWNX] = this->X;
				G[G_PITRESPAWNY] = this->Y;
				Screen->EntryX = returnX;
				Screen->EntryY = returnY;
			}
		}
		else if(special==4){
			G[G_PITRESPAWNDMAP] = dmap;
			G[G_PITRESPAWNSCREEN] = scrn;
			G[G_PITRESPAWNX] = retX;
			G[G_PITRESPAWNY] = retY;
		}
		bool frame1 = true;
		while(true){
			while(Link->Action!=LA_FALLING){
				if(special==2){
					combodata cd = Game->LoadComboData(Screen->ComboD[ComboAt(Link->X+8, Link->Y+13)]);
					if(returnX==-1&&!frame1&&!G[G_LINKPITIMMUNITY]&&Link->MoveFlags[HEROMV_CAN_PITFALL]&&cd->Type!=CT_PITFALL&&cd->Type!=CT_STEP&&cd->Script==0){
						returnX = Link->X;
						returnY = Link->Y;
					}
				}
				frame1 = false;
				Waitframe();
			}
			while(Link->Action==LA_FALLING){
				frame1 = false;
				Waitframe();
			}
			//Waitdraw();
			if(special==2){
				if(returnX>-1){
					Link->X = returnX;
					Link->Y = returnY;
				}
				else{
					SetLinkPitImmune(2);
					Link->X = G[G_PITRESPAWNX];
					Link->Y = G[G_PITRESPAWNY];
					Link->PitWarp(G[G_PITRESPAWNDMAP], G[G_PITRESPAWNSCREEN]);
				}
			}
			else if(special==3||special==4){
				if(Game->GetCurDMap()==G[G_PITRESPAWNDMAP]&&Game->GetCurDMapScreen()==G[G_PITRESPAWNSCREEN]){
					Link->X = G[G_PITRESPAWNX];
					Link->Y = G[G_PITRESPAWNY];
					NoAction();
				}
				else{
					SetLinkPitImmune(2);
					Link->X = G[G_PITRESPAWNX];
					Link->Y = G[G_PITRESPAWNY];
					NoAction();
					Link->PitWarp(G[G_PITRESPAWNDMAP], G[G_PITRESPAWNSCREEN]);
				}
			}
			else{
				Link->X = returnX;
				Link->Y = returnY;
			}
		}
	}
}

ffc script TheFitnessGramPacerTest{
	void SpawnNewGuy(int guy, int column, int gIndex, int minStep, int maxStep){
		int count = guy[0];
		int guyX = guy[1];
		int guyY = guy[2];
		int guyDir = guy[3];
		int guyStep = guy[4];
		int guyType = guy[5];
		int guyMoveDir = guy[6];
		int guyTargetColumn = guy[7];
		int guyTargetYPercent = guy[8];
		int guyDelay = guy[9];
		
		int numColumns = column[0];
		int columnX = column[1];
		int columnMinY = column[2];
		int columnMaxY = column[3];
		
		if(columnX[0]!=-16)
			guyTargetColumn[gIndex] = numColumns-1;
		else if(columnX[numColumns-1]!=256)
			guyTargetColumn[gIndex] = 0;
		else
			guyTargetColumn[gIndex] = Choose(0, numColumns-1);
		int cIndex = guyTargetColumn[gIndex];
		if(guyTargetColumn[gIndex]==0){
			guyMoveDir[gIndex] = 1;
			guyDir[gIndex] = DIR_RIGHT;
			++guyTargetColumn[gIndex];
		}
		else{
			guyMoveDir[gIndex] = -1;
			guyDir[gIndex] = DIR_LEFT;
			--guyTargetColumn[gIndex];
		}
		guyDelay[gIndex] = Rand(32, 64);
		guyX[gIndex] = columnX[cIndex];
		guyTargetYPercent[gIndex] = Rand(0, 100)/100;
		guyY[gIndex] = Lerp(columnMinY[cIndex], columnMaxY[cIndex], guyTargetYPercent[gIndex]);
		ChooseGuyType(guy, gIndex, minStep, maxStep);
	}
	void ChooseGuyType(int guy, int index, int minStep, int maxStep){
		int count = guy[0];
		int guyStep = guy[4];
		int guyType = guy[5];
		guyType[index] = Rand(25);
		for(int i=0; i<176; ++i){
			bool alreadyTaken;
			for(int i=0; i<count; ++i){
				if(guyType[i]==guyType[index])
					guyType[index] = Rand(25);
				else
					break;
			}
		}
		guyStep[index] = Rand(minStep, maxStep)/100;
		switch(guyType[index]){
			case 0: //Gentleman
			case 19: //Older woman
				guyStep[index] -= 0.2;
				break;
			case 4: //Boy
			case 10:
			case 16: //Girl
				guyStep[index] += 1;
				break;
		}
	}
	int GetGuyCMBFromID(int id){
		switch(id){
			case 0:
				return 33324;
			case 1:
				return 33332;
			case 2:
				return 33340;
			case 3:
				return 33348;
			case 4:
				return 33356;
			case 5:
				return 33364;
			case 6:
				return 33372;
			case 7:
				return 33380;
			case 7:
				return 33380;
			case 8:
				return 33388;
			case 9:
				return 33396;
			case 10:
				return 33404;
			case 11:
				return 33412;
			case 12:
				return 33420;
			case 13:
				return 33428;
			case 14:
				return 33436;
			case 15:
				return 33444;
			case 16:
				return 33452;
			case 17:
				return 33460;
			case 18:
				return 33468;
			case 19:
				return 33476;
			case 20:
				return 33492;
			case 21:
				return 33500;
			case 22:
				return 33508;
			case 23:
				return 33516;
			case 24:
				return 33524;
		}
	}
	void run(int minStep, int maxStep, int count){
		int i; int j; int k; int m;
		int x; int y;
		bool isFirst = IsFirstFFC(this);
		
		int numColumns;
		int columnX[16];
		int columnMinY[16];
		int columnMaxY[16];
		
		G[G_FITNESSGRAMPACEROFFSET] = 0;
		
		//Find columns for marking NPC min and max Y positions at certain parts of the screen, determining pathing
		for(x=0; x<16; ++x){
			bool foundFlag;
			int min = -1; int max = -1;
			for(y=0; y<11; ++y){
				if(Screen->ComboF[y*16+x]==102){
					if(!foundFlag){
						min = y;
						foundFlag = true;
					}
				}
				else if(foundFlag){
					max = y-1;
					foundFlag = false;
				}
			}
			//If a column of flags has been found, add the data to the array
			if(min>-1&&max>-1){
				columnX[numColumns] = x*16;
				if(x==0)
					columnX[numColumns] = -16;
				else if(x==15)
					columnX[numColumns] = 256;
				columnMinY[numColumns] = min*16;
				columnMaxY[numColumns] = max*16;
				++numColumns;
			}
		}
		
		G[G_PITKIDFLAG] = 0;
		
		int guyX[16];
		int guyY[16];
		int guyDir[16];
		int guyStep[16];
		int guyType[16];
		int guyMoveDir[16];
		int guyTargetColumn[16];
		int guyTargetYPercent[16];
		int guyDelay[16];
		int guy[] = {count, guyX, guyY, guyDir, guyStep, guyType, guyMoveDir, guyTargetColumn, guyTargetYPercent, guyDelay};
		int column[] = {numColumns, columnX, columnMinY, columnMaxY};
		
		for(i=0; i<count; ++i){
			j = Rand(numColumns-1);
			k = Rand(0, 100)/100;
			guyX[i] = Lerp(columnX[j], columnX[j+1], k);
			guyTargetYPercent[i] = Rand(0, 100)/100;
			guyY[i] = Lerp(Lerp(columnMinY[j], columnMaxY[j], guyTargetYPercent[i]), Lerp(columnMinY[j+1], columnMaxY[j+1], guyTargetYPercent[i]), k);
			guyTargetColumn[i] = Choose(j, j+1);
			if(columnX[guyTargetColumn[i]]<guyX[i]){
				guyMoveDir[i] = -1;
				guyDir[i] = DIR_LEFT;
			}
			else{
				guyMoveDir[i] = 1;
				guyDir[i] = DIR_RIGHT;
			}
			ChooseGuyType(guy, i, minStep, maxStep);
			if(DayNight_IsNight()){
				SpawnNewGuy(guy, column, i, minStep, maxStep);
			}
			if(guyType[i]==10&&guyDir[i]==DIR_RIGHT){
				G[G_PITKIDFLAG] = 1;
			}
		}
		
		while(true){
			// for(i=0; i<numColumns; ++i){
				// Screen->Rectangle(6, columnX[i], columnMinY[i], columnX[i]+15, columnMaxY[i]+15, 0x01, 1, 0, 0, 0, true, 64);
			// }
			
			for(i=0; i<count; ++i){
				j = guyTargetColumn[i];
				int tX = columnX[j];
				int tY = Lerp(columnMinY[j], columnMaxY[j], guyTargetYPercent[i]);
				int angle = Angle(guyX[i], guyY[i], tX, tY);
				if(guyDelay[i]){
					if(!DayNight_IsNight())
						--guyDelay[i];
					if(guyDelay[i]==0){
						guyDir[i] = (guyMoveDir[i]==-1)?DIR_LEFT:DIR_RIGHT;
					}
				}
				else{
					if(Distance(guyX[i], guyY[i], tX, tY)<=guyStep[i]){
						guyX[i] = tX;
						guyY[i] = tY;
						if(j==0){
							if(columnX[j]==-16){
								SpawnNewGuy(guy, column, i, minStep, maxStep);
							}
							else{
								guyDelay[i] = 32;
								guyMoveDir[i] = 1;
								++guyTargetColumn[i];
							}
						}
						else if(j==numColumns-1){
							if(columnX[j]==256){
								SpawnNewGuy(guy, column, i, minStep, maxStep);
							}
							else{
								guyDelay[i] = 32;
								guyMoveDir[i] = -1;
								--guyTargetColumn[i];
							}
						}
						else{
							if(guyMoveDir[i]==-1){
								--guyTargetColumn[i];
							}
							else if(guyMoveDir[i]==1){
								++guyTargetColumn[i];
							}
						}
					}
					else{
						guyX[i] += VectorX(guyStep[i], angle);
						guyY[i] += VectorY(guyStep[i], angle);
					}
				}
				if(guyType[i]==10&&guyDir[i]==DIR_RIGHT){
					G[G_PITKIDFLAG] = 1;
				}
			}
			
			int drawOrder[16];
			SortLowestToHighestAndReturnOrder(guyY, count, drawOrder);
			
			for(i=0; i<count; ++i){
				j = drawOrder[i];
				//printf("%d - %d\n", j, guyY[j]);
				//Screen->DrawInteger(6, guyX[j], guyY[j]-8, FONT_Z3SMALL, 0x01, 0x0F, -1, -1, guyStep[j], 4, 128);
				int cmb = GetGuyCMBFromID(guyType[j])+guyDir[j];
				int layer = 2;
				if(guyY[j]>Link->Y)
					layer = 3;
				if(!guyDelay[j])
					cmb += 4;
				Screen->DrawCombo(layer, guyX[j] + G[G_FITNESSGRAMPACEROFFSET], guyY[j]-16, cmb, 1, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 128);
			}
			
			Waitframe();
		}
	}
}

const int I_OUTFIT_PIECE = 35;

ffc script ShopItem{
	int GetCostumePrice(int type, int ID){
		if(type==OTYPE_TOP){
			return 60;
		}
		else if(type==OTYPE_BOTTOM){
			return 60;
		}
		else if(type==OTYPE_ACCESSORY){
			return 50;
		}
		else if(type==OTYPE_COLOR){
			return 30;
		}
	}
	void GetDescriptionStringOutfit(int strbuf, int type, int id){
		int strbuf2[512];
		int nameBuf[512];
		GetOutfitPieceName(nameBuf, type, id);
		int descBuf[512];
		//ItemDesc(descBuf, itemid);
		if(type==OTYPE_TOP){
			switch(id){
				default: sprintf(strbuf2, "@84%s:@01 An outfit piece.", nameBuf); break;
			}
		}
		else if(type==OTYPE_BOTTOM){
			switch(id){
				default: sprintf(strbuf2, "@84%s:@01 An outfit piece.", nameBuf); break;
			}
		}
		else if(type==OTYPE_ACCESSORY){
			switch(id){
				default: sprintf(strbuf2, "@84%s:@01 An accessory for outfits.", nameBuf); break;
			}
		}
		else if(type==OTYPE_COLOR){
			switch(id){
				default: sprintf(strbuf2, "@84%s:@01 A dye for outfits.", nameBuf); break;
			}
		}
		//sprintf(strBuf, "@84%s:@01 %s", nameBuf, descBuf);
		CopyStringToBuffer(strbuf, strbuf2); //"@84Special Deal:@01 Look, it's a randomizer. I'm not being paid enough to tell you what this does. Probably a hymnstone.");
	}
	void GetDescriptionString(int description, int strbuf, int itemid){
		switch(description){
			case -1:
				int strbuf2[512];
				int nameBuf[512];
				ItemName(nameBuf, itemid);
				int descBuf[512];
				ItemDesc(descBuf, itemid);
				sprintf(strbuf2, "@84%s:@01 %s", nameBuf, descBuf);
				CopyStringToBuffer(strbuf, strbuf2); //"@84Special Deal:@01 Look, it's a randomizer. I'm not being paid enough to tell you what this does. Probably a hymnstone.");
				break;
			case 0:
				CopyStringToBuffer(strbuf, "@8410 Lobber Bombs:@01 These things pack quite a punch. They also may or may not strictly speaking be legal... Maybe don't tell anybody I sold you these.");
				break;
			case 1:
				CopyStringToBuffer(strbuf, "@8410 Solar Batteries:@01 These are all the rage these days. Throw them on the ground and they shoot out a beam of concentrated sunlight. Don't look directly into the beam.");
				break;
			case 2:
				CopyStringToBuffer(strbuf, "@8410 Lunar Batteries:@01 These are all the rage these days. Throw them on the ground and things will start floating into the air. Perfect for doing chores around the house. I bear no responsibility for broken dishes.");
				break;
			case 3:
				CopyStringToBuffer(strbuf, "@84Silver Sword:@01 This fine sword crafted from silver supposedly holds an ancient enchantment. I got it off this frightening old man in exchange for some information about these... three... uh forget I said anything.");
				break;
			case 4:
				CopyStringToBuffer(strbuf, "@84Iron Shield:@01 This sturdy iron shield is sure to save your skin in a pinch. A must have for any aspiring adventurer.");
				break;
			case 5:
				CopyStringToBuffer(strbuf, "@84Spell Trap:@01 This is a crazy new discovery that just hit the market. It's powered by an until now undiscovered kind of magic. Knock a stonebeast into it and it'll grind it up into free magic batteries!");
				break;
			case 6:
				CopyStringToBuffer(strbuf, "@84Solar Battery Pouch:@01 This will let you carry 10 more solar batteries for each one carried.");
				break;
			case 7:
				CopyStringToBuffer(strbuf, "@84Lunar Battery Pouch:@01 This will let you carry 10 more lunar batteries for each one carried.");
				break;
			case 8:
				CopyStringToBuffer(strbuf, "@84Stellar Battery Pouch:@01 This will let you carry 10 more stellar batteries for each one carried.");
				break;
			case 9:
				CopyStringToBuffer(strbuf, "@84Lobber Bomb Pouch:@01 This will let you carry 10 more lobber bombs for each one carried.");
				break;
			case 10:
				CopyStringToBuffer(strbuf, "@84Tri Lantern@01 Lantern shoots three fires.");
				break;
			case 11:
				CopyStringToBuffer(strbuf, "@84Short Fuse@01 Bombs explode shortly after hitting the ground.");
				break;
			case 12:
				CopyStringToBuffer(strbuf, "@84Magnet+@01 Tidal Gauntlet moves you slower and enemies faster.");
				break;
			case 13:
				CopyStringToBuffer(strbuf, "@84Auto Lock@01 Automatically lock onto the closest enemy on a whiffed punch.");
				break;
			case 14:
				CopyStringToBuffer(strbuf, "@84Reflect+@01 Silver Sword duplicates projectiles it reflects.");
				break;
			case 15:
				CopyStringToBuffer(strbuf, "@84Alt Lunar Battery@01 Lunar battery has an alternate effect.");
				break;
			case 16:
				CopyStringToBuffer(strbuf, "@84Stellar Wand+@01 The wand's projectile speed and damage increase.");
				break;
			case 17:
				CopyStringToBuffer(strbuf, "@84Stellar Greatsword@01 Increases the range and damage of Stellar Sword.");
				break;
			case 18:
				CopyStringToBuffer(strbuf, "@84Safe Charge@01 Solar System no longer breaks on overcharge.");
				break;
			case 19:
				CopyStringToBuffer(strbuf, "@84Revival Potion@01 Administer this to revive an ally from the brink of exhaustion but just barely.@N @N...You do have a prescription, right?");
				break;
			case 20:
				CopyStringToBuffer(strbuf, "@84Regeneration Potion@01 Drinking this will greatly accelerate your body's regeneration, but any additional stress placed on it will wear out its effectiveness...So don't get hit pretty much.");
				break;
		}
	}
	void run(int itemid, int price, int description, int checkItem, int storyflag, int randomizerIndex, int dbit){
		int startPrice = price;
		
		bool isOutfitShop;
		int outfitType;
		int outfitID;
		int outfitTile;
		itemsprite dummy;
		if(randomizerIndex<0&&randomizerIndex>=-5){
			isOutfitShop = true;
			int i = Abs(randomizerIndex)-1;
			outfitType = Floor(G[G_OUTFITSHOP1+i]/1000)-1;
			outfitID = G[G_OUTFITSHOP1+i]%1000;
			if(GetOutfitPiece(outfitType, outfitID)){
				this->Data = 0;
				Quit();
			}
			outfitTile = GetOutfitPieceTile(outfitType, outfitID);
			price = GetCostumePrice(outfitType, outfitID);
			checkItem = 0;
			storyflag = 0;
			itemid = I_OUTFIT_PIECE;
			dummy = CreateItemAt(I_OUTFIT_PIECE, this->X, this->Y);
			dummy->Pickup = IP_DUMMY;
			dummy->Script = Game->GetItemSpriteScript("DrawOver");
			dummy->InitD[0] = dummy->DrawXOffset;
			dummy->InitD[1] = dummy->DrawYOffset;
			dummy->Tile = outfitTile;
			dummy->DrawYOffset = -1000;
			this->Data = 1;
		}
		else if(randomizerIndex>0&&G[G_RANDOMIZERENABLED]){
			if(GetDBit(dbit)){
				this->Data = 0;
				Quit();
			}
			if(RandomizedItems[randomizerIndex]>0){
				itemid = RandomizedItems[randomizerIndex];
				itemid = Randomizer_ProgressiveItem(itemid);
				itemid = ProcessRandomizerItem(randomizerIndex, itemid);
			}
			else
				itemid = 255;
			if(price>100)
				price = 100;
			description = -1;
			dummy = SpawnRandomizerItem(randomizerIndex, itemid, this->X, this->Y);
			dummy->Pickup = IP_DUMMY;
			dummy->Script = Game->GetItemSpriteScript("DrawOver");
			dummy->InitD[0] = dummy->DrawXOffset;
			dummy->InitD[1] = dummy->DrawYOffset;
			dummy->DrawYOffset = -1000;
			this->Data = 1;
			checkItem = 0;
			storyflag = 0;
		}
		
		this->Flags[FFCF_IGNOREHOLDUP] = true;
		if(checkItem != 0){ //If checkItem is set, the item can't be bought multiple times. If it's <0, also check for another item being found
			if(FoundItems[itemid])
				Quit();
			if(checkItem < 0){
				if(Abs(checkItem) == 145 && !FoundItems[145] && !FoundItems[146])
					Quit();
				else if(!FoundItems[Abs(checkItem)])
					Quit();
			}
		}
		if(storyflag&&Game->Counter[CR_STORYFLAG]<storyflag)
			Quit();
		int descbuffer[2048];
		if(isOutfitShop)
			GetDescriptionStringOutfit(descbuffer, outfitType, outfitID);
		else
			GetDescriptionString(description, descbuffer, itemid);
		int lineStart[256];
		int lineEnd[256];
		int lineStartColor[256];
		int strDat[6] = {lineStart, lineEnd, lineStartColor, 0, 8, 1};
		DrawStringSP_Prep(strDat, 224, FONT_Z3SMALL, descbuffer);
		item itm;
		bool waitItem; //Player has pressed A
		bool pickedUp; //Player has bought the item
		bool noDraw; //Item doesn't draw while Link is holding it up
		while(true){
			if(randomizerIndex<0&&G[G_RANDOMIZERENABLED]&&!dummy->isValid()){
				dummy = SpawnRandomizerItem(randomizerIndex, itemid, this->X, this->Y);
				dummy->Tile = outfitTile;
				dummy->Pickup = IP_DUMMY;
				dummy->Script = Game->GetItemSpriteScript("DrawOver");
				dummy->InitD[0] = dummy->DrawXOffset;
				dummy->InitD[1] = dummy->DrawYOffset;
				dummy->DrawYOffset = -1000;
			}
			else if(randomizerIndex>0&&G[G_RANDOMIZERENABLED]&&!dummy->isValid()){
				dummy = SpawnRandomizerItem(randomizerIndex, itemid, this->X, this->Y);
				dummy->Pickup = IP_DUMMY;
				dummy->Script = Game->GetItemSpriteScript("DrawOver");
				dummy->InitD[0] = dummy->DrawXOffset;
				dummy->InitD[1] = dummy->DrawYOffset;
				dummy->DrawYOffset = -1000;
			}
			if(dummy->isValid()){
				if(noDraw)
					dummy->Y = -32;
				else
					dummy->Y = this->Y;
			}
			
			if(!waitItem){
				if(description==19||description==20){ //Mutually exclusive potions
					if((Link->Item[29]||Link->Item[30])&&Link->Action!=LA_HOLD1LAND)
						Quit();
				}
				if(description==9){ //Dynamic prices for bomb upgrades
					price = startPrice+((Game->MCounter[CR_BOMBS]-30)/10)*20;
					if(Game->MCounter[CR_BOMBS]==99)
						Quit();
				}
				if(description>=6&&description<=8){ //Dymanic prices for battery upgrades
					int counter = CR_SOLARBATTERY;
					if(description==7)
						counter = CR_LUNARBATTERY;
					if(description==8)
						counter = CR_STELLARBATTERY;
					if(description==8){
						if(!FoundItems[I_ABILITY_B_ASHER]&&!G[G_RANDOMIZERENABLED])
							Quit();
						price = startPrice+((Game->MCounter[counter]-20)/10)*50;
					}
					else
						price = startPrice+((Game->MCounter[counter]-20)/10)*30;
					if(Game->MCounter[counter]==99)
						Quit();
				}
			}
			
			if(Abs(Link->X-this->X)<=8&&Link->Y>this->Y&&Link->Y<this->Y+10+16){
				if(Link->Dir==DIR_UP){
					if(!noDraw){
						int drawY = 8;
						if(isOutfitShop)
							drawY = 160-56;
						Screen->Rectangle(6, 8+2, drawY+2, 8+240-2, drawY+56-2, 0xB5, 1, 0, 0, 0, true, 64);
						Screen->DrawTile(6, 8, drawY, 66360, 15, 4, 11, -1, -1, 0, 0, 0, 0, true, 128);
						DrawStringSP(strDat, 6, 16, drawY+8, 224, TF_NORMAL, FONT_Z3SMALL, descbuffer);
						Screen->FastCombo(6, this->X, this->Y-16, 17007, 9, 128);
					}
					if(Link->PressA&&!waitItem){
						Link->PressA = false;
						if(Game->Counter[CR_RUPEES]+Game->DCounter[CR_RUPEES]>=price){
							if(isOutfitShop){
								itemdata idat = Game->LoadItemData(itemid);
								idat->Tile = outfitTile;
							}
							itm = SpawnRandomizerItem(randomizerIndex, itemid, Link->X, Link->Y);
							itm->Pickup |= IP_HOLDUP;
							if(isOutfitShop){
								itm->OriginalTile = outfitTile;
								itm->Tile = outfitTile;
								SetOutfitPiece(outfitType, outfitID, true);
								if(G[G_RANDOMIZERRUNCLEAR])
									WriteOutfitSaveFile();
							}
							Game->DCounter[CR_RUPEES] -= price;
							pickedUp = true;
							if(!(randomizerIndex>0&&G[G_RANDOMIZERENABLED]))
								FoundItems[itemid] = true;
							if(itemid == 6){
								if(Link->ItemA == 5)
									EquipButtonItem(6, 0, true);
								if(Link->ItemB == 5)
									EquipButtonItem(6, 1, true);
								if(Link->ItemX == 55)
									EquipButtonItem(6, 2, true);
								if(Link->ItemY == 5)
									EquipButtonItem(6, 3, true);
								if(G[G_ITEMA_ASHER] == 5)
									G[G_ITEMA_ASHER] = 6;
								if(G[G_ITEMB_ASHER] == 5)
									G[G_ITEMB_ASHER] = 6;
								if(G[G_ITEMX_ASHER] == 5)
									G[G_ITEMX_ASHER] = 6;
								if(G[G_ITEMY_ASHER] == 5)
									G[G_ITEMY_ASHER] = 6;
							}
						}
						else{
							Game->PlaySound(SFX_SWITCH_ERROR);
						}
						G[G_NOACTION] = 1;
						waitItem = true;
					}
				}
			}
			int numStr[8];
			itoa(numStr, price);
			int w = Text->StringWidth(numStr, FONT_Z3SMALL);
			if(!noDraw){
				Screen->FastCombo(6, this->X, this->Y, this->Data, this->CSet, 128);
				Screen->FastTile(6, this->X+8-(w+8)/2, this->Y+16, 33293, 0, 128);
				Screen->DrawString(6, this->X+8-(w+8)/2+8, this->Y+16, FONT_Z3SMALL, 0x01, -1, TF_NORMAL, numStr, 128, SHD_OUTLINED8, 0x0F);
			}
			if(waitItem){ //The item has been bought
				if(Link->Action==LA_HOLD1LAND||Link->Action==LA_HOLD2LAND){
					noDraw = true;
					Link->HeldItem = 176; //-1 wasn't working so Dodongo's Penance it is
					if(randomizerIndex<0&&G[G_RANDOMIZERENABLED]&&dummy->isValid())
						Screen->DrawTile(6, Link->X-4+dummy->InitD[0], Link->Y-17+dummy->InitD[1], dummy->Tile, dummy->TileWidth, dummy->TileHeight, dummy->CSet, -1, -1, 0, 0, 0, 0, true, 128);
					else if(randomizerIndex>0&&G[G_RANDOMIZERENABLED]&&dummy->isValid())
						Screen->DrawTile(6, Link->X-4+dummy->InitD[0], Link->Y-17+dummy->InitD[1], dummy->Tile, dummy->TileWidth, dummy->TileHeight, dummy->CSet, -1, -1, 0, 0, 0, 0, true, 128);
					else
						Screen->FastCombo(6, Link->X-4, Link->Y-17, this->Data, this->CSet, 128);
				}
				bool timetostop = true; //Tracks when holdup ends
				if(Link->InputA&&!(checkItem&&pickedUp)) //Link has to be held in place when pressing A or else holding the button makes him slash
					timetostop = false;
				if(itm->isValid()) //When the item itself isn't valid it's not time yet
					timetostop = false;
				if(Link->Action==LA_HOLD1LAND||Link->Action==LA_HOLD2LAND) //When holding an item it's not time yet
					timetostop = false;
				if(timetostop){
					waitItem = false;
					if(randomizerIndex<0&&G[G_RANDOMIZERENABLED]&&pickedUp){
						if(dummy->isValid()){
							dummy->Pickup = 0;
							dummy->Y = -1000;
						}
						Quit();
					}
					else if(randomizerIndex>0&&G[G_RANDOMIZERENABLED]&&pickedUp){
						if(dummy->isValid()){
							dummy->Pickup = 0;
							dummy->Y = -1000;
						}
						if(dbit)
							SetDBit(dbit, true);
						Quit();
					}
					else if(checkItem&&pickedUp){
						Quit();
					}
					pickedUp = false;
					noDraw = false;
				}
				G[G_NOACTION] = 1;
			}
			Waitframe();
		}
	}
}

ffc script TimeGem{
	void run(){
		this->Flags[FFCF_LENSVIS] = false;
		int pos = ComboAt(this->X+8, this->Y+8);
		mapdata l1 = Game->LoadTempScreen(1);
		int cmb = this->Data;
		l1->ComboD[pos] = GH_INVISIBLE_COMBO;
		l1->ComboC[pos] = this->CSet;
		int aTimer;
		int offset;
		int x = this->X;
		int y = this->Y;
		int floatTimer;
		int timeGemDir;
		int lastTarget = G[G_L3TARGETTIME];
		int gemCooldown;
		while(true){
			if(G[G_L3TARGETTIME]==-1&&lastTarget>-1){
				Game->PlaySound(86);
				gemCooldown = 30;
			}
			if(gemCooldown)
				--gemCooldown;
			if(this->Y>Link->Y)
				this->Flags[FFCF_OVERLAY] = true;
			else
				this->Flags[FFCF_OVERLAY] = false;
			timeGemDir = 0;
			if(!gemCooldown&&!G[G_MAGNETPULLFLOAT]&&GLW[GL_MAGNETHITBOX]->isValid()&&Collision(this, GLW[GL_MAGNETHITBOX])){
				if(GLW[GL_MAGNETHITBOX]->Damage==STATE_TIDALGAUNTLET_SUN){
					timeGemDir = 1;
				}
				else{
					timeGemDir = 1; //-1;
				}
				// ++aTimer;
				// if(aTimer>4){
					// aTimer = 0;
					// offset += timeGemDir;
					// if(offset<0)
						// offset += 8;
					// else if(offset>7)
						// offset -= 8;
				// }
			}
			
			int curTime = G[G_L3HOURS]*3600+G[G_L3MINUTES]*60+G[G_L3SECONDS];
			if(DayNight_IsBetween(G[G_L3HOURS], G[G_L3MINUTES], G[G_L3SECONDS], 0, 0, 0, 6, 0, 0)){
				if(timeGemDir==-1){
					if(G[G_L3HOURS]==0&&G[G_L3MINUTES]==0&&G[G_L3SECONDS]==0)
						G[G_L3TARGETTIME] = 18*60*60;
					else
						G[G_L3TARGETTIME] = 00*60*60;
				}
				else if(timeGemDir==1)
					G[G_L3TARGETTIME] = 06*60*60;
				offset = Floor(Abs(DayNight_GetTimeDifference(G[G_L3HOURS], G[G_L3MINUTES], G[G_L3SECONDS], 0, 0, 0))/21600*7);
			}
			else if(DayNight_IsBetween(G[G_L3HOURS], G[G_L3MINUTES], G[G_L3SECONDS], 6, 0, 0, 12, 0, 0)){
				if(timeGemDir==-1){
					if(G[G_L3HOURS]==6&&G[G_L3MINUTES]==0&&G[G_L3SECONDS]==0)
						G[G_L3TARGETTIME] = 00*60*60;
					else
						G[G_L3TARGETTIME] = 06*60*60;
				}
				else if(timeGemDir==1)
					G[G_L3TARGETTIME] = 12*60*60;
				offset = Floor(Abs(DayNight_GetTimeDifference(G[G_L3HOURS], G[G_L3MINUTES], G[G_L3SECONDS], 6, 0, 0))/21600*7);
			}
			else if(DayNight_IsBetween(G[G_L3HOURS], G[G_L3MINUTES], G[G_L3SECONDS], 12, 0, 0, 18, 0, 0)){
				if(timeGemDir==-1){
					if(G[G_L3HOURS]==12&&G[G_L3MINUTES]==0&&G[G_L3SECONDS]==0)
						G[G_L3TARGETTIME] = 06*60*60;
					else
						G[G_L3TARGETTIME] = 12*60*60;
				}
				else if(timeGemDir==1)
					G[G_L3TARGETTIME] = 18*60*60;
				offset = Floor(Abs(DayNight_GetTimeDifference(G[G_L3HOURS], G[G_L3MINUTES], G[G_L3SECONDS], 12, 0, 0))/21600*7);
			}
			else if(DayNight_IsBetween(G[G_L3HOURS], G[G_L3MINUTES], G[G_L3SECONDS], 18, 0, 0, 0, 0, 0)){
				if(timeGemDir==-1){
					if(G[G_L3HOURS]==18&&G[G_L3MINUTES]==0&&G[G_L3SECONDS]==0)
						G[G_L3TARGETTIME] = 12*60*60;
					else
						G[G_L3TARGETTIME] = 18*60*60;
				}
				else if(timeGemDir==1)
					G[G_L3TARGETTIME] = 00*60*60;
				offset = Floor(Abs(DayNight_GetTimeDifference(G[G_L3HOURS], G[G_L3MINUTES], G[G_L3SECONDS], 18, 0, 0))/21600*7);
			}
			
			this->Data = cmb+offset;
			++floatTimer;
			floatTimer %= 360;
			this->Y = y-8-2*Sin(2*floatTimer);
			Screen->FastTile(1, x, y, GH_SHADOW_TILE+Floor(G[G_ANIM]/4)%4, 7, 128);
			lastTarget = G[G_L3TARGETTIME];
			Waitframe();
		}
	}
}

ffc script OverUnderItem{
	void run(int itemid, int holdup, int overUnderState, int invisible, int randomizerIndex){
		if(G[G_RANDOMIZERENABLED]&&randomizerIndex>0){
			if(RandomizedItems[randomizerIndex]>0){
				itemid = RandomizedItems[randomizerIndex];
				itemid = Randomizer_ProgressiveItem(itemid);
			}
		}
		
		if(!Screen->State[ST_ITEM]){
			itemsprite itm = SpawnRandomizerItem(randomizerIndex, itemid, this->X, this->Y);
			itm->Pickup |= IP_ST_ITEM;
			
			if(invisible){
				itm->DrawYOffset = -1000;
			}
				
			int drawYOff = itm->DrawYOffset;
			if(holdup){
				itm->Pickup |= IP_HOLDUP;
			}
			mapdata l4 = Game->LoadTempScreen(4);
			while(itm->isValid()){
				int overUnderLayer = G[G_OVERUNDERLAYER];
				int linkPos = ComboAt(Link->X+8, Link->Y+12);
				if(l4->ComboF[linkPos]==CF_OVERUNDERABOVELAYER){
					overUnderLayer = 1;
				}
				else if(l4->ComboF[linkPos]==CF_OVERUNDERBELOWLAYER){
					overUnderLayer = 0;
				}
				if(overUnderState==0){
					if(overUnderLayer==0){
						itm->DrawYOffset = drawYOff;
						if(itm->ID!=I_BESTIARYENTRY&&!IsMultiworld())
							itm->Pickup &= ~IP_DUMMY;
						itm->Misc[ITMM_FLAGS] &= ~ITMMF_SUPERDUMMY;
					}
					else if(overUnderLayer==1){
						itm->DrawYOffset = -1000;
						if(!invisible)DrawToLayer(itm, 0, 128);
						if(itm->ID!=I_BESTIARYENTRY&&!IsMultiworld())
							itm->Pickup |= IP_DUMMY;
						itm->Misc[ITMM_FLAGS] |= ITMMF_SUPERDUMMY;
					}
				}
				else if(overUnderState==1){
					if(overUnderLayer==0){
						itm->DrawYOffset = -1000;
						if(!invisible)DrawToLayer(itm, 0, 128);
						if(itm->ID!=I_BESTIARYENTRY&&!IsMultiworld())
							itm->Pickup |= IP_DUMMY;
						itm->Misc[ITMM_FLAGS] |= ITMMF_SUPERDUMMY;
					}
					else if(overUnderLayer==1){
						itm->DrawYOffset = drawYOff;
						if(itm->ID!=I_BESTIARYENTRY&&!IsMultiworld())
							itm->Pickup &= ~IP_DUMMY;
						itm->Misc[ITMM_FLAGS] &= ~ITMMF_SUPERDUMMY;
					}
				}
				Waitframe();
			}
		}
	}
}
/* Putting a pin in this script
ffc script L3PatternSpook{
	void run(int map, int scrn, int pos, int dir, int numObstacles){
		int pointX[32];
		int pointY[32];
		int pointDist[32];
		int numPoints;
		int mX = (scrn%16)*16+(pos%16);
		int mY = Floor(scrn/16)*11+Floor(pos/16);
		int startX = mX;
		int startY = mY;
		int pathMap = Screen->LayerMap(2);
		pointX[0] = mX;
		pointY[0] = mY;
		numPoints = 1;
		do{
			int tX = mX+DirX(dir, 1);
			int tY = mY+DirY(dir, 1);
			if(GetMapComboF(pathMap, tX, tY)==8){
				mX = tX;
				mY = tY;
			}
			else{
				int testDir = -1;
				for(int i=0; i<4; ++i){
					if(i!=OppositeDir(dir)&&i!=dir){
						tX = mX + DirX(dir, 1);
						tY = mY + DirY(dir, 1);
						if(GetMapComboF(pathMap, tX, tY)==8){
							mX = tX;
							mY = tY;
							testDir = i;
							break;
						}
					}
				}
				if(testDir!=-1&&testDir!=dir){
					if(mX!=startX||mY!=startY){
						pointX[numPoints] = mX;
						pointY[numPoints] = mY;
						++numPoints;
					}
				}
			}
		}while(mX!=startX||mY!=startY)
		int maxDist;
		for(int i=0; i<numPoints; ++i){
			pointX[i] *= 16;
			pointY[i] *= 16;
		}
		for(int i=0; i<numPoints; ++i){
			if(i<numPoints-1)
				pointDist[i] = LargeDistance(pointX[i], pointY[i], pointX[i+1], pointY[i+1], 10);
			else
				pointDist[i] = LargeDistance(pointX[i], pointY[i], pointX[0], pointY[0], 10);
			maxDist += pointDist[i];
		}
		for(int i=0; i<numPoints; ++i){
			pointDist[i] *= (86400/maxDist);
		}
		while(true){
			int dat[16];
			Waitframe();
		}
	}
	void GetSpookPosition(int dat, int pointX, int pointY, int pointDist, int numPoints, int time, int numObstacles, int whichObstacle){
		int frame = Floor(time+(whichObstacle/numObstacles)*86400)%86400;
		int whichPoint;
		int totalDist;
		for(int i=0; i<numPoints; ++i){
			if(i<numPoints-1){
				if(frame>=pointDist[i]&&frames<pointDist[i+1]){
					whichPoint = i;
					break;
				}
			}
			else{
				whichPoint = i;
				break;
			}
			totalDist += pointDist[i];
		}
		x = pointX[whichPoint];
		y = pointY[whichPoint];
	}
}*/

ffc script SunMoonBarriers{
	void run(){
		int sunBarriers = 37244;
		int moonBarriers = 37260;
		int sunBarriers2 = 37444;
		int moonBarriers2 = 37460;
		mapdata l4 = Game->LoadTempScreen(4);
		bool layer4Occupied[176];
		for(int i=0; i<176; ++i){
			if(l4->ComboD[i]!=0){
				layer4Occupied[i] = true;
			}
		}
		bool frame1 = true;
		while(true){
			int h = G[G_L3HOURS];
			int m = G[G_L3MINUTES];
			int s = G[G_L3SECONDS];
			int linkPos = ComboAt(Link->X+8, Link->Y+12);
			int sunState = 0;
			if(Abs(DayNight_GetTimeDifference(h, m, s, 12, 0, 0))<=21600)
				sunState = 1;
			int moonState = 0;
			if(Abs(DayNight_GetTimeDifference(h, m, s, 0, 0, 0))<=21600)
				moonState = 1;
			if(!frame1){
				if(Screen->ComboD[linkPos]>=sunBarriers&&Screen->ComboD[linkPos]<=sunBarriers+3)
					sunState = 0;
				if(Screen->ComboD[linkPos]>=moonBarriers&&Screen->ComboD[linkPos]<=moonBarriers+3)
					moonState = 0;
				if(Screen->ComboD[linkPos]>=sunBarriers2&&Screen->ComboD[linkPos]<=sunBarriers2+3)
					sunState = 1;
				if(Screen->ComboD[linkPos]>=moonBarriers2&&Screen->ComboD[linkPos]<=moonBarriers2+3)
					moonState = 1;
			}
			for(int i=0; i<176; ++i){
				int baseCMB;
				int blockType;
				int blockState;
				bool blockBelow;
				if(Screen->ComboD[i]>=sunBarriers&&Screen->ComboD[i]<=sunBarriers+3){
					baseCMB = sunBarriers;
					if(G[G_ANIM]%4==0||frame1){
						if(sunState==1&&Screen->ComboD[i]<sunBarriers+3){
							++Screen->ComboD[i];
							if(frame1)
								Screen->ComboD[i] = sunBarriers+3;
						}
						else if(sunState==0&&Screen->ComboD[i]>sunBarriers){
							--Screen->ComboD[i];
							if(frame1)
								Screen->ComboD[i] = sunBarriers;
						}
					}
				}
				else if(Screen->ComboD[i]>=moonBarriers&&Screen->ComboD[i]<=moonBarriers+3){
					baseCMB = moonBarriers;
					if(G[G_ANIM]%4==0||frame1){
						if(moonState==1&&Screen->ComboD[i]<moonBarriers+3){
							++Screen->ComboD[i];
							if(frame1)
								Screen->ComboD[i] = moonBarriers+3;
						}
						else if(moonState==0&&Screen->ComboD[i]>moonBarriers){
							--Screen->ComboD[i];
							if(frame1)
								Screen->ComboD[i] = moonBarriers;
						}
					}
				}
				if(Screen->ComboD[i]>=sunBarriers2&&Screen->ComboD[i]<=sunBarriers2+3){
					baseCMB = sunBarriers2;
					if(G[G_ANIM]%4==0||frame1){
						if(sunState==1&&Screen->ComboD[i]<sunBarriers2+3){
							++Screen->ComboD[i];
							if(frame1)
								Screen->ComboD[i] = sunBarriers2+3;
						}
						else if(sunState==0&&Screen->ComboD[i]>sunBarriers2){
							--Screen->ComboD[i];
							if(frame1)
								Screen->ComboD[i] = sunBarriers2;
						}
					}
				}
				else if(Screen->ComboD[i]>=moonBarriers2&&Screen->ComboD[i]<=moonBarriers2+3){
					baseCMB = moonBarriers2;
					if(G[G_ANIM]%4==0||frame1){
						if(moonState==1&&Screen->ComboD[i]<moonBarriers2+3){
							++Screen->ComboD[i];
							if(frame1)
								Screen->ComboD[i] = moonBarriers2+3;
						}
						else if(moonState==0&&Screen->ComboD[i]>moonBarriers2){
							--Screen->ComboD[i];
							if(frame1)
								Screen->ComboD[i] = moonBarriers2;
						}
					}
				}
				if(baseCMB){
					if(i<160&&Screen->ComboD[i+16]>=baseCMB&&Screen->ComboD[i+16]<=baseCMB+3){
						blockBelow = true;
					}
					
					if(!layer4Occupied[i-16]){
						l4->ComboD[i-16] = Screen->ComboD[i]-4;
						l4->ComboC[i-16] = Screen->ComboC[i];
					}
					if(!layer4Occupied[i]){
						l4->ComboC[i] = Screen->ComboC[i];
						if(blockBelow){
							l4->ComboD[i] = Screen->ComboD[i]+4;
						}
						else{
							if(Link->Y<ComboY(i))
								l4->ComboD[i] = Screen->ComboD[i]+8;
							else
								l4->ComboD[i] = 0;
						}
					}
				}
			}
			frame1 = false;
			Waitframe();
		}
	}
}

const int FFCS_THEORB = 51;

const int CMB_THEORB = 37272;
const int TIL_THEORBPOP = 69114;

ffc script TheOrb{
	void run(int orbDir, int isSpawn, int layer){
		if(G[G_PITRESPAWNDMAP]==0&&G[G_PITRESPAWNSCREEN]==0){
			G[G_PITRESPAWNX] = this->X;
			G[G_PITRESPAWNY] = this->Y;
			G[G_PITRESPAWNDMAP] = Game->GetCurDMap();
			G[G_PITRESPAWNSCREEN] = Game->GetCurScreen();
		}
		int w; int h;
		int vX; int vY;
		int startX = this->X;
		int startY = this->Y;
		this->Flags[FFCF_ETHEREAL] = true;
		int drawLayer = 4;
		//If the orb came from another screen
		if(orbDir){
			this->X = Link->X;
			this->Y = Link->Y;
		}
		//Otherwise if it's a spawn point Link can appear on top of
		else if(isSpawn){
			//If Link entered the screen on top of the orb
			if(Distance(Link->X, Link->Y, this->X, this->Y)<16){
				//Wait for Link to move out of the way and spawn in
				while(Distance(Link->X, Link->Y, this->X, this->Y)<16){
					Waitframe();
				}
				for(int i=0; i<16; ++i){
					drawLayer = OrbDrawLayer(layer);
					w = (i/16)*(24+2*Sin(G[G_ANIM]*8));
					h = (i/16)*(24+2*Cos(G[G_ANIM]*8));
					Screen->DrawCombo(drawLayer, this->X+8-w/2, this->Y+8-h/2, CMB_THEORB, 2, 2, 8, w, h, 0, 0, 0, -1, 0, true, 128);
					Waitframe();
				}
			}
		}
		drawLayer = (layer==0)?4:(layer==G[G_OVERUNDERLAYER])?4:(layer==1)?1:4;
		while(true){
			//If the orb is stationary
			if(orbDir==0){
				//Wait for Link to collide with it
				while(Distance(Link->X, Link->Y, this->X, this->Y)>12||Link->Action==LA_FALLING||(layer&&G[G_OVERUNDERLAYER]!=layer-1)){
					drawLayer = OrbDrawLayer(layer);
					w = 24+2*Sin(G[G_ANIM]*8);
					h = 24+2*Cos(G[G_ANIM]*8);
					Screen->DrawCombo(drawLayer, this->X+8-w/2, this->Y+8-h/2, CMB_THEORB, 2, 2, 8, w, h, 0, 0, 0, -1, 0, true, 128);
					Waitframe();
				}
				//If it's a spawn point, set the respawn position
				if(isSpawn){
					G[G_PITRESPAWNX] = this->X;
					G[G_PITRESPAWNY] = this->Y;
					G[G_PITRESPAWNDMAP] = Game->GetCurDMap();
					G[G_PITRESPAWNSCREEN] = Game->GetCurScreen();
				}
				SetLinkPitImmune(2);
				G[G_REDORBINTERRUPT] = 2;
				Game->PlaySound(60);
				//Pause and grow after collision
				for(int i=0; i<8; ++i){
					drawLayer = OrbDrawLayer(layer);
					w = 24+(i/8)*8+2*Sin(G[G_ANIM]*8);
					h = 24+(i/8)*8+2*Cos(G[G_ANIM]*8);
					Screen->DrawCombo(drawLayer, this->X+8-w/2, this->Y+8-h/2, CMB_THEORB, 2, 2, 8, w, h, 0, 0, 0, -1, 0, true, 128);
					
					Link->X = this->X;
					Link->Y = this->Y;
					MakeLinkInvisible(2);
					TurnOffLinkCollision(2);
					SetLinkPitImmune(2);
					G[G_NOACTION] = 1;
					Waitframe();
				}
				G[G_REDORBINTERRUPT] = 0;
				int holdTimer;
				//Wait for a new button press or a hold > 48 frames
				while(!Link->PressUp&&!Link->PressDown&&!Link->PressLeft&&!Link->PressRight&&holdTimer<48&&!GotHit()){
					if(Link->InputUp||Link->InputDown||Link->InputLeft||Link->InputRight)
						++holdTimer;
					else
						holdTimer = 0;
					
					w = 32+2*Sin(G[G_ANIM]*8);
					h = 32+2*Cos(G[G_ANIM]*8);
					Screen->DrawCombo(drawLayer, this->X+8-w/2, this->Y+8-h/2, CMB_THEORB, 2, 2, 8, w, h, 0, 0, 0, -1, 0, true, 128);
					Screen->DrawCombo(drawLayer, this->X+8-w/2, this->Y+8-h/2, CMB_THEORB+1, 2, 2, 8, w, h, 0, 0, 0, -1, 0, true, 128);
					
					Link->X = this->X;
					Link->Y = this->Y;
					MakeLinkInvisible(2);
					SetLinkPitImmune(2);
					G[G_NOACTION] = 1;
					Waitframe();
				}
				if(!GotHit()){
					//Set the orb's velocity
					vX = (Link->InputLeft?-1:0) + (Link->InputRight?1:0);
					vY = (Link->InputUp?-1:0) + (Link->InputDown?1:0);
					if(vX==0&&vY==0){
						vX = DirX(Link->Dir, 1);
						vY = DirY(Link->Dir, 1);
					}
					//Wait 4 frames to allow inputting diagonals
					for(int i=0; i<4&&!GotHit(); ++i){
						int tempVX = (Link->InputLeft?-1:0) + (Link->InputRight?1:0);
						int tempVY = (Link->InputUp?-1:0) + (Link->InputDown?1:0);
						if(tempVX!=0||tempVY!=0){
							vX = tempVX;
							vY = tempVY;
						}
						w = 32+2*Sin(G[G_ANIM]*8);
						h = 32+2*Cos(G[G_ANIM]*8);
						Screen->DrawCombo(drawLayer, this->X+8-w/2, this->Y+8-h/2, CMB_THEORB, 2, 2, 8, w, h, 0, 0, 0, -1, 0, true, 128);
						Screen->DrawCombo(drawLayer, this->X+8-w/2, this->Y+8-h/2, CMB_THEORB+1, 2, 2, 8, w, h, 0, 0, 0, -1, 0, true, 128);
						
						Link->X = this->X;
						Link->Y = this->Y;
						MakeLinkInvisible(2);
						TurnOffLinkCollision(2);
						SetLinkPitImmune(2);
						G[G_NOACTION] = 1;
						Waitframe();
					}
				}
				Game->PlaySound(84);
			}
			int dir = AngleDir8(Angle(0, 0, vX, vY));
			if(orbDir>0)
				dir = orbDir-1;
			//While the orb is in motion
			while(CanWalk8NoEdge(Link->X, Link->Y, dir, 1, false, true)&&!G[G_REDORBINTERRUPT]&&!GotHit()){
				vX = DirX(dir, 1);
				vY = DirY(dir, 1);
				if(vX!=0&&vY!=0){
					vX *= 0.7071;
					vY *= 0.7071;
				}
				Link->Dir = Dir8ToDir4(dir, Link->Dir);
				LinkMovement_Push2NoEdge(3*vX, 3*vY);
				
				w = 32+2*Sin(G[G_ANIM]*8);
				h = 32+2*Cos(G[G_ANIM]*8);
				Screen->DrawCombo(drawLayer, this->X+8-w/2, this->Y+8-h/2, CMB_THEORB, 2, 2, 8, w, h, 0, 0, 0, -1, 0, true, 128);
				Screen->DrawCombo(drawLayer, this->X+8-w/2, this->Y+8-h/2, CMB_THEORB+2, 2, 2, 8, w, h, 0, 0, 0, -1, 0, true, 128);
				
				vX = (Link->InputLeft?-1:0) + (Link->InputRight?1:0);
				vY = (Link->InputUp?-1:0) + (Link->InputDown?1:0);
				
				Link->X = this->X;
				Link->Y = this->Y;
				MakeLinkInvisible(2);
				TurnOffLinkCollision(2);
				SetLinkPitImmune(2);
				if(PressButtonItem(I_ABILITY_A_ASHER)&&(vX!=0||vY!=0)){
					SetLinkPitImmune(4);
					G[G_NOACTION] = 0;
					G[G_FORCEDASH] = 1+AngleDir8(Angle(0, 0, vX, vY));
					//This is a really dumb hack.
					//Sometimes, for ungodly reasons I can't comprehend, the dash item script wouldn't run.
					//So I FORCE it to run. And every frame it doesn't run I hold Link in timeout until it does.
					//Fuck you, ZScript.
					while(G[G_FORCEDASH]){
						w = 32+2*Sin(G[G_ANIM]*8);
						h = 32+2*Cos(G[G_ANIM]*8);
						Screen->DrawCombo(drawLayer, this->X+8-w/2, this->Y+8-h/2, CMB_THEORB, 2, 2, 8, w, h, 0, 0, 0, -1, 0, true, 128);
						Screen->DrawCombo(drawLayer, this->X+8-w/2, this->Y+8-h/2, CMB_THEORB+2, 2, 2, 8, w, h, 0, 0, 0, -1, 0, true, 128);
						
						Link->X = this->X;
						Link->Y = this->Y;
						MakeLinkInvisible(2);
						TurnOffLinkCollision(2);
						SetLinkPitImmune(2);
				
						RunItemActiveScript(I_ABILITY_A_ASHER);
						Waitframe();
					}
					break;
				}
				G[G_ORBDIR] = dir+1;
				G[G_ORBLAYER] = layer;
				G[G_NOACTION] = 1;
				Waitframe();
				this->X = Link->X;
				this->Y = Link->Y;
			}
			G[G_ORBDIR] = 0;
			G[G_ORBLAYER] = 0;
			Game->PlaySound(96);
			lweapon poof = ParticleAnim(this->X-8, this->Y-8, 2, 2, TIL_THEORBPOP, 8, 3, 2);
			//If the orb came from another screen, clean up and quit
			if(orbDir){
				this->Data = 0;
				Quit();
			}
			this->X = startX;
			this->Y = startY;
			//Reform animation
			for(int i=0; i<16; ++i){
				w = (i/16)*(24+2*Sin(G[G_ANIM]*8));
				h = (i/16)*(24+2*Cos(G[G_ANIM]*8));
				Screen->DrawCombo(drawLayer, this->X+8-w/2, this->Y+8-h/2, CMB_THEORB, 2, 2, 8, w, h, 0, 0, 0, -1, 0, true, 128);
				Waitframe();
			}
		}
	}
	int OrbDrawLayer(int layer){
		return (layer==0)?4:((layer-1==G[G_OVERUNDERLAYER])?((layer==1)?2:4):((layer==1)?1:4));
	}
}

const int FFCS_MOVINGPLATFORM = 52;

ffc script MovingPlatform{ //AllTheseFeaturesAndIStillHaveToCodeMovingPlatformsMyself
	void run(int d0, int d1, int d2, int d3, int d4, int d5, int d6, bool drawLayer0){
		int lastx = this->X;
		int lasty = this->Y;
		while(true){
			if(FWCLinkCollision(this) && Link->Z <= 2){
				SetLinkPitImmune(2);
				if(Link->Z==0&&(lastx != this->X || lasty != this->Y)){
					LinkMovement_Push2(this->X - lastx, this->Y - lasty);
				}
			}
			for(int i = Screen->NumLWeapons(); i>0; i--){
				lweapon l = Screen->LoadLWeapon(i);
				if(l->ID == LW_LOBBOMB){
					if(l->Z < 2 && Collision(l, this)){
						if(l->MoveFlags[WPNMV_CAN_PITFALL])
							l->MoveFlags[WPNMV_CAN_PITFALL] = false;
						l->X += this->X - lastx;
						l->Y += this->Y - lasty;
					}
				}
			}				
			lastx = this->X;
			lasty = this->Y;
			if(drawLayer0){
				Screen->DrawCombo(0, this->X, this->Y, this->Data, this->TileWidth, this->TileHeight, this->CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
			}
			Waitframe();
		}
	}
}

void BlackScreenLayerSix(){
	Screen->Rectangle(6, -64, -64, 300, 200, 0x00, 1, 0, 0, 0, true, OP_OPAQUE);	
}

void BlackishScreenLayerSix(){
	for(int j = 0; j<176; j++)
		Screen->FastTile(6, ComboX(j), ComboY(j), 19, 0, OP_TRANS);
}

void BlackScreenLayerSeven(){
	Screen->Rectangle(6, 0, 0, 300, 200, 0x00, 1, 0, 0, 0, true, OP_OPAQUE);	
}


void Fade(bool inout){
	if(inout){
		for(int i = 0; i<30; i++){
			BlackishScreenLayerSix();
			WaitNoAction();
		}
		for(int i = 0; i<30; i++){
			BlackScreenLayerSix();
			WaitNoAction();
		}
	}
	else{
		for(int i = 0; i<30; i++){
			BlackScreenLayerSix();
			WaitNoAction();
		}
		for(int i = 0; i<30; i++){
			BlackishScreenLayerSix();
			WaitNoAction();
		}
	}
}

ffc script PartySwapper{
	bool CanTalk(ffc this){
		if(Link->Dir<2){
			if(Abs(Link->X-this->X)<=8){
				if(Link->Dir==DIR_UP&&Link->Y>this->Y&&Link->Y<this->Y+10)
					return true;
				else if(Link->Dir==DIR_DOWN&&Link->Y<this->Y&&Link->Y>this->Y-20)
					return true;
			}
		}
		else{
			if(Link->Y>=this->Y-12&&Link->Y<=this->Y+4){
				if(Link->Dir==DIR_LEFT&&Link->X>this->X&&Link->X<this->X+18)
					return true;
				else if(Link->Dir==DIR_RIGHT&&Link->X>this->X-18&&Link->X<this->X)
					return true;
			}
		}
		return false;
	}
	void run(){
		if(Game->Counter[CR_STORYFLAG] == SFLAG_POSTMANOR){ 
			ffc Asher = Screen->LoadFFC(5);
			ffc Partner = Screen->LoadFFC(6);
			Link->Item[I_ASHER] = false;
			if(G[G_CLOTHESSWAP])
				Asher->Data = 41992;
			else
				Asher->Data = 41984;
			if(GetCharID() == CHAR_TORRIN)
				Partner->Data = 41986;
			else{
				if(G[G_CLOTHESSWAP])
					Partner->Data = 41993;
				else
					Partner->Data = 41985;
			}
			while(true){
				if(CanTalk(this)){
					Screen->FastCombo(6, this->X, this->Y-16-8+4, CMB_CANTALK, 0, 128);
					if(Link->PressA){
						Fade(true);
						FullHeal(true, true, false, false);
						G[G_ASHERHP] = G[G_ASHERMAXHP];
						G[G_TORRINHP] = G[G_TORRINMAXHP];
						G[G_KAYLANIHP] = G[G_KAYLANIMAXHP];
						Link->HP = Link->MaxHP;
						if(GetCharID() == CHAR_TORRIN){
							SetCharacter(CHAR_KAYLANI, false);
							Link->Item[I_TORRIN] = false;
							Link->Item[I_KAYLANI] = true;
							if(G[G_CLOTHESSWAP])
								Partner->Data = 41993;
							else
								Partner->Data = 41985;
						}
						else{
							SetCharacter(CHAR_TORRIN, false);
							Link->Item[I_KAYLANI] = false;
							Link->Item[I_TORRIN] = true;
							Partner->Data = 41986;
						}
						UpdatePartyIcons();
						Fade(false);
						WaitNoAction();
					}
				}
				Waitframe();
			}
		}
	}
}

ffc script Cutscenes{
	void run(int scene){
		if(scene == 0){ //We're starting with the stupid catacombs switches which are baked into here for some reason
			if(G[G_RANDOMIZERENABLED]){
				this->Data++;
				Quit();
			}
			if(Game->GetCurScreen() == 0x7A && Game->Counter[CR_CATACOMBSPLOT] & SFLAG_KAYLANICONVO){
				this->Data++;
				Quit();
			}
			if(Game->GetCurScreen() == 0x7C && Game->Counter[CR_CATACOMBSPLOT] & SFLAG_TORRINCONVO){
				this->Data++;
				Quit();
			}
			int xOff = 0;
			int yOff = 4;
			int xDist = 8;
			int yDist = 8;
			while(true){
				if(Abs(Link->X+xOff-this->X)<=xDist&&Abs(Link->Y+yOff-this->Y)<=yDist&&Link->Z==0){
					Game->PlaySound(68);
					if(Game->GetCurScreen() == 0x7A)
						Game->Counter[CR_CATACOMBSPLOT] |= SFLAG_KAYLANICONVOPRIMED;
					if(Game->GetCurScreen() == 0x7C)
						Game->Counter[CR_CATACOMBSPLOT] |= SFLAG_TORRINCONVOPRIMED;
					Fade(true);
					this->Data = CMB_AUTOWARPA;
				}
				Waitframe();
			}
		}
		if(scene == 1){ //The torches at the Catacombs exit
			if((Game->Counter[CR_CATACOMBSPLOT] & SFLAG_KAYLANICONVO)||G[G_RANDOMIZERENABLED])
				Screen->ComboD[ComboAt(96, 112)] = 20604;
			if((Game->Counter[CR_CATACOMBSPLOT] & SFLAG_TORRINCONVO)||G[G_RANDOMIZERENABLED])
				Screen->ComboD[ComboAt(144, 112)] = 20604;
			if(G[G_RANDOMIZERENABLED])
				Quit();
			if(Game->Counter[CR_CATACOMBSPLOT] & SFLAG_KAYLANICONVO && Game->Counter[CR_CATACOMBSPLOT] & SFLAG_TORRINCONVO){
				Screen->TriggerSecrets();
				Screen->State[ST_SECRET] = true;
			}
			if(Game->Counter[CR_CATACOMBSPLOT] & SFLAG_KAYLANICONVOPRIMED || Game->Counter[CR_CATACOMBSPLOT] & SFLAG_TORRINCONVOPRIMED){
				Link->Invisible = true;
				G[G_INVISTIMER] = 0;
				Fade(false);
				WaitNoAction(60);
				Game->PlaySound(88);
				if(Game->Counter[CR_CATACOMBSPLOT] & SFLAG_KAYLANICONVOPRIMED)
					Screen->ComboD[ComboAt(96, 112)] = 20604;
				if(Game->Counter[CR_CATACOMBSPLOT] & SFLAG_TORRINCONVOPRIMED)
					Screen->ComboD[ComboAt(144, 112)] = 20604;
				WaitNoAction(60);
				if((Game->Counter[CR_CATACOMBSPLOT] & SFLAG_KAYLANICONVO && Game->Counter[CR_CATACOMBSPLOT] & SFLAG_TORRINCONVOPRIMED) || (Game->Counter[CR_CATACOMBSPLOT] & SFLAG_KAYLANICONVOPRIMED && Game->Counter[CR_CATACOMBSPLOT] & SFLAG_TORRINCONVO)){
					Game->PlaySound(9);
					Screen->TriggerSecrets();
					WaitNoAction(60);
				}
				Fade(true);
				this->Data = CMB_AUTOWARPA;
			}
		}
		if(scene == 2){ //The Catacombs entrance
			if(Game->Counter[CR_STORYFLAG] < SFLAG_ASHERRESCUED){
				ffc f = Screen->LoadFFC(1);
				f->Data = 0;
			}
			if(Game->Counter[CR_CATACOMBSPLOT] & SFLAG_KAYLANICONVOPRIMED || Game->Counter[CR_CATACOMBSPLOT] & SFLAG_TORRINCONVOPRIMED){
				Link->Invisible = true;
				G[G_INVISTIMER] = 0;
				Fade(false);
				WaitNoAction(60);
				ffc OtherPartner = FindFreeFFC();
				OtherPartner->TileHeight = 2;
				OtherPartner->X = 96;
					OtherPartner->Y = 170;
				if(Game->Counter[CR_CATACOMBSPLOT] & SFLAG_KAYLANICONVOPRIMED){
					SetCutsceneSkip(CUTSCENE_CATACOMBS1);
					// PlayStringAndWait("Test string. Torrin and Asher will converse about what Asher's been through, Torrin's worry. It will be kind of gay.", SCHAR_TORRIN, 0, 64, 112);
					// PlayStringAndWait("Torrin notices Asher shivering and offers his coat.", SCHAR_ASHER, 0, 64, 112);
					PlayStringAndWait("Hey, Ash? I'm really sorry about everything.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("Sorry? What do you mean?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("I was the one who dragged ya into this mess. You kept on offerin' sensible options, but I kept on persuadin' you to keep at it. Figured I'd be strong enough to head off anything bad that might happen. Instead I just got ya into this heap a' trouble.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("I got myself here. I probably could've gotten away if I'd listened to Kaylani.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("But you didn't, cuz a' me. Cuz I wasn't strong enough to handle myself. You an' Kaylani both got awesome powers, an' I've got a fishin' rod and some stolen rocks. It was different before, when at least I could keep ya outta trouble, but now you're the one riskin' your neck to save me.", SCHAR_TORRIN, EMOTE_SAD, 64, YPOS_LOWER);
					PlayStringAndWait("I see what's happening. Torrin... do you think either of us give a damn if you've got magic powers or not? Do you think dropping some rocks out of the sky compares to anything that you do? Look at yourself! You just broke into a heavily-guarded mansion owned by a powerful mage to save me! You think Kaylani and I can be that reckless?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("That? That was nothin'. I wasn't about to let somethin' as silly as that keep me from savin' you.", SCHAR_TORRIN, EMOTE_EMBARRASSED, 64, YPOS_LOWER);
					PlayStringAndWait("And I really appreciate it. It means a lot having you here. That's not changing just cuz I've got magic now. It wouldn't feel safe without you watching my back.", SCHAR_ASHER, EMOTE_HAPPY, 64, YPOS_LOWER);
					PlayStringAndWait("Heh... guess you wouldn't. That's how you are, isn't it?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("You're not that different, are you? You said it yourself, way back when. Things are easier with a wingman.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("Yeah, sure are. An' I'm glad I convinced you.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
					WaitNoAction(120);
					ffc Asher = Screen->LoadFFC(5);
					Asher->Data = 51064;
					WaitNoAction(60);
					Asher->Data = 41984;
					PlayStringAndWait("It's a little cold down here, isn't it?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("Oh, here, take my jacket!", SCHAR_TORRIN, EMOTE_IDEA, 64, YPOS_LOWER);
					PlayStringAndWait("Are you sure?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("I'm fine! A little chill's nothin'!", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
					Fade(true);
					G[G_CLOTHESSWAP] = 1;
					OutfitSwap();
					// ffc Asher = Screen->LoadFFC(5);
					ffc Partner = Screen->LoadFFC(6);
					Asher->Data = 41992;
					Partner->Data = 41993;
					Fade(false);				
					PlayStringAndWait("Hey Torrin? Thanks. But uh... I don't wanna sound unappreciative, but your jacket's not actually all that warm.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("Yeah... guess not. But I didn't have anythin' else to offer.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("I still appreciate it.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
					WaitNoAction(120);
					PlayStringAndWait("Hey, Ash?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("Yeah?", SCHAR_ASHER, EMOTE_QUESTION, 64, YPOS_LOWER);		
					PlayStringAndWait("... ah, nevermind.", SCHAR_TORRIN, EMOTE_EMBARRASSED, 64, YPOS_LOWER);					
					OtherPartner->Data = 33304;
					while(OtherPartner->Y > 48){
						OtherPartner->Y--;
						WaitNoAction();
					}
					OtherPartner->Data -= 4;
					if(Game->Counter[CR_CATACOMBSPLOT] & SFLAG_TORRINCONVO){
						PlayStringAndWait("I found the other switch.", SCHAR_KAYLANI, 0, 64, 112);
						PlayStringAndWait("Perfect! Let's high-tail it outta here already!", SCHAR_TORRIN, EMOTE_HAPPY, 64, 112);
						DayNight[_DN_HOUR] = 22;
						DayNight[_DN_MINUTE] = 0;
						DayNight[_DN_SECOND] = 0;
					}
					else{
						PlayStringAndWait("I found a switch that seems to be tied to the exit's mechanism.", SCHAR_KAYLANI, 0, 64, 112);
						PlayStringAndWait("Is that so? Reckon that means there's another one. Guess I'm up then.", SCHAR_TORRIN, 0, 64, 112);
						PlayStringAndWait("Let me come with you and-", SCHAR_ASHER, 0, 64, 112);
						PlayStringAndWait("There's no need for that, Asher. We need you to recover your strength. I'll keep you company for a bit.", SCHAR_KAYLANI, 0, 64, 112);
					}
					SetCutsceneSkip(CUTSCENE_NULL); //CUTSCENE_CATACOMBS1
				}
				if(Game->Counter[CR_CATACOMBSPLOT] & SFLAG_TORRINCONVOPRIMED){
					SetCutsceneSkip(CUTSCENE_CATACOMBS2);
					// PlayStringAndWait("Test string. Kaylani and Asher will converse about what Asher's been through, Kaylani's similar experience. They'll follow up on a conversation in Torrin's home town. Talk about their worries, living up to expectations, etc.", SCHAR_KAYLANI, 0, 64, 112);
					PlayStringAndWait("So this whole time, I've had stellar magic and didn't know. When Selet wanted you to find him a stellar mage-", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("One literally fell on top of him, and he didn't recognize it.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("Wow... this is a lot to take in.@delay(120)@26@26I get how you feel now.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("It's not your fault. There's no way you could have-", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("You warned me. I still stayed and tried to fight. Seeing you and Torrin in danger made me feel...", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("Scared.", SCHAR_ASHER, EMOTE_SAD, 64, YPOS_LOWER);
					PlayStringAndWait("Furious.", SCHAR_ASHER, EMOTE_FURIOUS, 64, YPOS_LOWER);
					PlayStringAndWait("Malicious.", SCHAR_ASHER, EMOTE_SADISTIC, 64, YPOS_LOWER);
					PlayStringAndWait("I was worried about you two. But in that moment... I wanted to see Selet stopped. To see him crushed. Splattered against a wall. When I think about that now, and about the powers I have... it makes me scared of myself.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("I think.... Let me be blunt. I think those feelings are good. Since we've met, you've been bottling up your feelings, putting up a neutral front. You've been kind, and helpful, but always careful not to let anything more out. The few times you felt something strongly enough to break through, you tried to hide it with sarcasm or deflection.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("... And how would you know that?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("We're trained to study people too, not just the stars. But you're deflecting again, because this is hitting close to home.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("You're right, Asher. You've been given a very dangerous ability. And you should be scared. But you shouldn't feel guilty about that. You need to acknowledge all those feelings. You told me you always dreamed of being a hero. Now you're confronted with feelings that go against that ideal, and you're mad you can't shove them down like you usually do.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("... I guess? But why does any of that matter?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("Magic isn't as simple as people think. Your emotional state profoundly influences it. Selet, detestable as he is, is single-minded in his goals, and that determination shines through in his magic. If you refuse to even acknowledge the emotions you feel, they'll control you, and that control will extend to your magic. And like it or not, you're not the kind of mage who can let that happen.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("What do you actually want me to do?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("Be honest with yourself. If you feel malice towards Selet, don't ignore it and let it fester because it goes against the idealized image you hold of yourself. Acknowledge it, feel it, and move on it from it, or we'll find ourselves in this situation again.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
					WaitNoAction(60);
					PlayStringAndWait("Sounds like you're talking from experience.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("My grandmother told me once that if you feel like you can't change what you're doing, you should give someone else the advice you'd like to hear.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
					WaitNoAction(60);
					PlayStringAndWait("Thanks.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("Of course.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
					
					OtherPartner->Data = 33296;
					while(OtherPartner->Y > 48){
						OtherPartner->Y--;
						WaitNoAction();
					}
					OtherPartner->Data -= 4;
					if(Game->Counter[CR_CATACOMBSPLOT] & SFLAG_KAYLANICONVO){
						PlayStringAndWait("I found the other switch.", SCHAR_TORRIN, 0, 64, 112);
						PlayStringAndWait("Excellent. This place is really starting to unnerve me.", SCHAR_KAYLANI, EMOTE_HAPPY, 64, 112);
						DayNight[_DN_HOUR] = 22;
						DayNight[_DN_MINUTE] = 0;
						DayNight[_DN_SECOND] = 0;
					}
					else{
						PlayStringAndWait("Hey, miss me yet?", SCHAR_TORRIN, 0, 64, 112);
						PlayStringAndWait("Where have you been? We were getting worried for you.", SCHAR_KAYLANI, 0, 64, 112);
						PlayStringAndWait("I found a switch that made the door down there rumble and shake. Reckon there must be another one to make it fully budge.", SCHAR_TORRIN, 0, 64, 112);
						PlayStringAndWait("Really? Perfect! You should rest now. I'll find the other switch.", SCHAR_KAYLANI, EMOTE_EXCLAMATION, 64, 112);
						PlayStringAndWait("Let me come with you and-", SCHAR_ASHER, 0, 64, 112);
						PlayStringAndWait("Not a chance, mate. Can't have ya gettin' hurt when you're still weak. 'sides, wouldn't you rather hang out with me for a bit?", SCHAR_TORRIN, 0, 64, 112);
					}
					SetCutsceneSkip(CUTSCENE_NULL); //CUTSCENE_CATACOMBS2
				}
				Fade(true);
				OtherPartner->Data = 0;
				if(Game->Counter[CR_CATACOMBSPLOT] & SFLAG_KAYLANICONVOPRIMED){
					SetCharacter(CHAR_TORRIN, false);
					Link->Item[I_KAYLANI] = false;
					Link->Item[I_TORRIN] = true;
					ffc Partner = Screen->LoadFFC(6);
					Partner->Data = 41986;
					Game->Counter[CR_CATACOMBSPLOT] &= ~SFLAG_KAYLANICONVOPRIMED;
					Game->Counter[CR_CATACOMBSPLOT] |= SFLAG_KAYLANICONVO;
				}
				if(Game->Counter[CR_CATACOMBSPLOT] & SFLAG_TORRINCONVOPRIMED){
					SetCharacter(CHAR_KAYLANI, false);
					Link->Item[I_TORRIN] = false;
					Link->Item[I_KAYLANI] = true;
					ffc Partner = Screen->LoadFFC(6);
					if(G[G_CLOTHESSWAP])
						Partner->Data = 41993;
					else
						Partner->Data = 41985;
					Game->Counter[CR_CATACOMBSPLOT] &= ~SFLAG_TORRINCONVOPRIMED;
					Game->Counter[CR_CATACOMBSPLOT] |= SFLAG_TORRINCONVO;
				}
				// for(int i = 0; i<60; i++){
					// BlackScreenLayer6();
					// WaitNoAction();
				// }
				Link->Invisible = false;
				Fade(false);
			}
		}
	}
}

ffc script FunnyPitKid{
	void run(){
		Waitframes(64);
		if((G[G_PITKIDFLAG]==1||Rand(24)==0)&&Screen->D[0]==0&&!DayNight_IsNight()){
			int x;
			int y = this->Y;
			for(x=-16; x<64; x+=2.5){
				int layer = 2;
				if(y>Link->Y)
					layer = 4;
				FastishCombo(layer, x, y, 33411, 1, 2, 0, 128);
				Waitframe();
			}
			int dir;
			for(int i=0; i<4; ++i){
				dir = Rand(4);
				for(int j=0; j<4; ++j){
					int layer = 2;
					if(y>Link->Y)
						layer = 4;
					FastishCombo(layer, x, y, 33404+dir, 1, 2, 0, 128);
					Waitframe();
				}
			}
			for(int i=0; i<16; ++i){
				int layer = 2;
				if(y>Link->Y)
					layer = 4;
				y += 0.25;
				FastishCombo(layer, x, y, 33405, 1, 2, 0, 128);
				Waitframe();
			}
			Game->PlaySound(SFX_FALL);
			Waitframes(64);
			Game->PlaySound(SFX_BOMB);
			Screen->Quake = 10;
			Waitframes(64);
			PlayStringAndWait("I'm okay!", SCHAR_BOYBLUESHORTS, 0, 68, 24);
			Screen->D[0] = 1;
		}
	}
}

ffc script DayNightSwitch{
	void run(){
		int cmb = this->Data;
		while(true){
			while(!G[G_L3TIMEFLOW]){
				this->Data = cmb;
				if(Switch_Pressed(this->X, this->Y, false, 0)){
					this->Data = cmb+1;
					Game->PlaySound(SFX_SWITCH_PRESS);
					Game->PlaySound(86);
					G[G_L3TIMEFLOW] = 1;
					while(Switch_Pressed(this->X, this->Y, false, 0)){
						Waitframe();
					}
				}
				Waitframe();
			}
			while(G[G_L3TIMEFLOW]){
				this->Data = cmb+1;
				if(Switch_Pressed(this->X, this->Y, false, 0)){
					this->Data = cmb;
					Game->PlaySound(SFX_SWITCH_PRESS);
					Game->PlaySound(86);
					G[G_L3TIMEFLOW] = 0;
					while(Switch_Pressed(this->X, this->Y, false, 0)){
						Waitframe();
					}
				}
				Waitframe();
			}
		}
	}
}

ffc script L3BossDoor{
	void Open(){
		mapdata l1 = Game->LoadTempScreen(1);
		for(int x=0; x<4; ++x){
			for(int y=0; y<2; ++y){
				l1->ComboD[22+x+y*16] = 37660+x+y*4;
			}
		}
	}
	void run(){
		if(Screen->State[ST_BOSSLOCKBLOCK]){
			Open();
		}
		else{
			while(!Screen->State[ST_BOSSLOCKBLOCK]){
				Waitframe();
			}
			WaitNoAction(30);
			Open();
			int y = 16;
			for(int i=0; i<4; ++i){
				Game->PlaySound(91);
				for(int j=0; j<4; ++j){
					FastishCombo(2, 96, y, 37653, 4, 2, 2, 128);
					y -= 2;
					WaitNoAction();
				}
				for(int j=0; j<24; ++j){
					FastishCombo(2, 96, y, 37653, 4, 2, 2, 128);
					WaitNoAction();
				}
			}
		}
	}
}

const int HEALTHBAR_DRAW_DAMAGE = 0; //Set to 1 if you want to draw damage numbers
const int HEALTHBAR_DAMAGE_COUNT = 96; //How many frames damage numbers last for

const int HEALTHBAR_DRAW_CHIP = 1; //Set to 1 if you want to draw the health draining away when hit
const int HEALTHBAR_CHIP_RATE = 16; //How fast the damage drains from the bar after a hit

const int HEALTHBAR_ENDDELAY = 40; //How many frames the health bar lasts for after all enemies are dead when disappearOnDeath is set

//Health bar dimensions
const int HEALTHBAR_X = 8;
const int HEALTHBAR_Y = 16;
const int HEALTHBAR_WIDTH = 240;
const int HEALTHBAR_HEIGHT = 4;

//Offsets for the font of the NPC's name
const int HEALTHBAR_FONT_X_OFFSET = 0;
const int HEALTHBAR_FONT_Y_OFFSET = -6;

//Y offset for duplicate health bars
const int HEALTHBAR_DUPE_OFFSET = 12;

const int FONT_HEALTHBAR_TITLE = 2; //Font for the title and damage numbers. See FONT_ in std_constants.zh

const int C_HEALTHBAR_FONT = 0x01; //Color of the health bar's font
const int C_HEALTHBAR_FONTBG = 0x0F; //Color of the health bar's font background

const int C_HEALTHBAR_OUTLINE = 0x0F; //Color of the health bar's outline
const int C_HEALTHBAR_BAR = 0x81; //Color of the health bar
const int C_HEALTHBAR_DRAIN = 0x82; //Color of the section of the health bar being removed
const int C_HEALTHBAR_BG = 0x00; //Color of the health bar's background

int HealthBar_GetHP(npc n){
	//Swap the commented lines if you're not using ghost
	
	return GetEnemyProperty(n, ENPROP_HP);
	// return n->HP;
}

ffc script HealthBar_Single{
	void run(int npcid, int str, int npcNumber, int disappearOnDeath){
		for(int i=0; (i<64&&!Screen->NumNPCs())||i<4; ++i)
			Waitframe();
		npc n = HealthBar_GetNPC(npcid, npcNumber);
		if(!n->isValid()) //If an enemy isn't found, quit out
			Quit();
		
		int hp = HealthBar_GetHP(n);
		int maxHP = HealthBar_GetHP(n);
		int lastHP = HealthBar_GetHP(n);
		int drainHP = HealthBar_GetHP(n);
		int lastDrainHP = HealthBar_GetHP(n);
		int damage;
		int damageCounter;
		
		//If there's more than one enemy with health bars on the screen, offset them by the 
		int ffcCount;
		for(int i=1; i<=32; i++){
			ffc f = Screen->LoadFFC(i);
			if(f->Script==this->Script){
				if(f==this)
					break;
				else
					ffcCount++;
			}
		}
		
		
		int nameString[256];
		if(str>0){ //Get nameString from the string editor
			Game->GetMessage(str, nameString);
		}
		else{ //Get nameString from the enemy editor
			n->GetName(nameString);
		}
		
		HealthBar_CapString(nameString);
		this->InitD[0] = 0; //Mark the FFC as "Alive"
		
		//Begin main loop that runs until HP drains to 0
		while(drainHP>0){
			if(n->isValid()) //If the enemy isn't there, assume it's dead
				hp = Max(HealthBar_GetHP(n), 0);
			else
				hp = 0;
			
			if(damageCounter>0)
				damageCounter--;
			
			//Keep track of when the enemy takes damage
			if(hp!=lastHP){
				if(hp<lastHP){
					if(damageCounter>0)
						damage += lastHP-hp;
					else
						damage = lastHP-hp;
					damageCounter = HEALTHBAR_DAMAGE_COUNT;
				}
				lastDrainHP = lastHP;
				lastHP = hp;
			}
			
			//Decrease drainHP towards the current HP
			if(drainHP!=hp){
				if(drainHP>hp){
					drainHP = Max(drainHP-(Abs(lastDrainHP-hp)/HEALTHBAR_CHIP_RATE), hp);
				}
				else
					drainHP = hp;
			}
			
			HealthBar_Draw(nameString, hp, maxHP, drainHP, damage, damageCounter, HEALTHBAR_DUPE_OFFSET*ffcCount);
			Waitframe();
		}
		
		this->InitD[0] = 1; //Mark the FFC as "Dead"
		
		while(true){ 
			if(damageCounter>0)
				damageCounter--;
			HealthBar_Draw(nameString, 0, maxHP, 0, damage, damageCounter, HEALTHBAR_DUPE_OFFSET*ffcCount);
			
			//If marked to disappear, wait until all health bars are "Dead" before removing
			if(disappearOnDeath){
				if(HealthBar_CheckDone(this)){
					break;
				}
			}
			Waitframe();
		}
		
		//Wait extra frames before quitting out so it doesn't look as abrupt
		for(int i=0; i<HEALTHBAR_ENDDELAY; i++){
			if(damageCounter>0)
				damageCounter--;
			HealthBar_Draw(nameString, 0, maxHP, 0, damage, damageCounter, HEALTHBAR_DUPE_OFFSET*ffcCount);
			Waitframe();
		}
	}
	//Returns true if all FFCs with this script are "Dead"
	bool HealthBar_CheckDone(ffc this){
		for(int i=1; i<=32; i++){
			ffc f = Screen->LoadFFC(i);
			if(f->Script==this->Script){
				if(f->InitD[0]==0)
					return false;
			}
		}
		return true;
	}
	//Returns the nth enemy with a certain ID on the screen
	npc HealthBar_GetNPC(int id, int extra){
		for(int i=Screen->NumNPCs(); i>=1; i--){
			npc n = Screen->LoadNPC(i);
			if(n->ID==id){
				if(extra<=1)
					return n;
				else
					extra--;
			}
		}
	}
	//Draws a string with an outline
	void HealthBar_DrawString(int layer, int x, int y, int font, int c1, int c2, int format, int str){
		Screen->DrawString(layer, x, y-1, font, c2, -1, format, str, 128);
		Screen->DrawString(layer, x, y+1, font, c2, -1, format, str, 128);
		Screen->DrawString(layer, x-1, y, font, c2, -1, format, str, 128);
		Screen->DrawString(layer, x+1, y, font, c2, -1, format, str, 128);
		
		Screen->DrawString(layer, x, y, font, c1, -1, format, str, 128);
	}
	//Draws damage numbers as a string
	void HealthBar_DrawDamage(int layer, int x, int y, int font, int c1, int c2, int number){
		int istr[8];
		int i;
		//Add every digit to the string from largest to smallest
		if(number>=10000){
			istr[i] = '0'+(Floor(number/10000)%10);
			i++;
		}
		if(number>=1000){
			istr[i] = '0'+(Floor(number/1000)%10);
			i++;
		}
		if(number>=100){
			istr[i] = '0'+(Floor(number/100)%10);
			i++;
		}
		if(number>=10){
			istr[i] = '0'+(Floor(number/10)%10);
			i++;
		}
		istr[i] = '0'+(number%10);
		i++;
		istr[i] = 0;
		HealthBar_DrawString(layer, x, y, font, c1, c2, TF_RIGHT, istr);
	}
	//Draws the entire health bar
	void HealthBar_Draw(int str, int HP, int maxHP, int drainHP, int damage, int damageCounter, int offset){
		int x1 = HEALTHBAR_X;
		int y1 = HEALTHBAR_Y+offset;
		int x2 = HEALTHBAR_X+HEALTHBAR_WIDTH-1;
		int y2 = HEALTHBAR_Y+HEALTHBAR_HEIGHT-1+offset;
		int hpLength = (x2-x1-2)*(HP/maxHP);
		int drainLength = (x2-x1-2)*(drainHP/maxHP);
		
		//Draws the main body of the health bar
		Screen->Rectangle(6, x1, y1, x2, y2, C_HEALTHBAR_BG, 1, 0, 0, 0, true, 128);
		if(drainHP>0&&HEALTHBAR_DRAW_CHIP)
			Screen->Rectangle(6, x1+1, y1+1, x1+1+Clamp(drainLength, 0, x2-x1-2), y2-1, C_HEALTHBAR_DRAIN, 1, 0, 0, 0, true, 128);
		if(HP>0)
			Screen->Rectangle(6, x1+1, y1+1, x1+1+Clamp(hpLength, 0, x2-x1-2), y2-1, C_HEALTHBAR_BAR, 1, 0, 0, 0, true, 128);
		Screen->Rectangle(6, x1, y1, x2, y2, C_HEALTHBAR_OUTLINE, 1, 0, 0, 0, false, 128);
	
		//Draw the string
		if(str>0){
			HealthBar_DrawString(6, x1+HEALTHBAR_FONT_X_OFFSET, y1+HEALTHBAR_FONT_Y_OFFSET, FONT_HEALTHBAR_TITLE, C_HEALTHBAR_FONT, C_HEALTHBAR_FONTBG, TF_NORMAL, str);
		}
		
		//Draw the damage
		if(HEALTHBAR_DRAW_DAMAGE){
			if(damageCounter>0){
				HealthBar_DrawDamage(6, x2-HEALTHBAR_FONT_X_OFFSET, y1+HEALTHBAR_FONT_Y_OFFSET, FONT_HEALTHBAR_TITLE, C_HEALTHBAR_FONT, C_HEALTHBAR_FONTBG, damage);
			}
		}
	}
	//Remove trailing spaces from a string
	void HealthBar_CapString(int str){
		for(int i=SizeOfArray(str)-1; i>=0; i--){
			if(str[i]>32){
				str[i+1] = 0;
				return;
			}
		}
	}
}

ffc script HealthBar_Group{
	void run(int npcid1, int npcid2, int npcid3, int npcid4, int npcid5, int npcid6, int str, int disappearOnDeath){
		for(int i=0; (i<64&&!Screen->NumNPCs())||i<4; ++i)
			Waitframe();
		if(HealthBar_GetHPTotal(npcid1, npcid2, npcid3, npcid4, npcid5, npcid6)==0) //If none of the enemies are found, quit out
			Quit();
		
		int hp = HealthBar_GetHPTotal(npcid1, npcid2, npcid3, npcid4, npcid5, npcid6);
		int maxHP = hp;
		int lastHP = hp;
		int drainHP = hp;
		int lastDrainHP = hp;
		int damage;
		int damageCounter;
		
		int nameString[256];
		if(str>0){ //Get nameString from the string editor
			Game->GetMessage(str, nameString);
		}
		
		HealthBar_CapString(nameString);
		
		//Begin main loop that runs until HP drains to 0
		while(drainHP>0){
			hp = HealthBar_GetHPTotal(npcid1, npcid2, npcid3, npcid4, npcid5, npcid6);
			
			//There's really no clean way I can think of to handle enemies that summon more of themselves
			//so in this case we'll count this as healing and increase maxHP when necessary
			if(maxHP<hp)
				maxHP = hp;
			
			if(damageCounter>0)
				damageCounter--;
			
			//Keep track of when the enemy takes damage
			if(hp!=lastHP){
				if(hp<lastHP){
					if(damageCounter>0)
						damage += lastHP-hp;
					else
						damage = lastHP-hp;
					damageCounter = HEALTHBAR_DAMAGE_COUNT;
				}
				lastDrainHP = lastHP;
				lastHP = hp;
			}
			
			//Decrease drainHP towards the current HP
			if(drainHP!=hp){
				if(drainHP>hp){
					drainHP = Max(drainHP-(Abs(lastDrainHP-hp)/HEALTHBAR_CHIP_RATE), hp);
				}
				else
					drainHP = hp;
			}
			
			HealthBar_Draw(nameString, hp, maxHP, drainHP, damage, damageCounter, 0);
			Waitframe();
		}
		
		//If the enemy isn't set to disappear, keep running the empty health bar forever
		if(!disappearOnDeath){
			while(true){ 
				if(damageCounter>0)
					damageCounter--;
				HealthBar_Draw(nameString, 0, maxHP, 0, damage, damageCounter, 0);
				Waitframe();
			}
		}
		
		//Wait extra frames before quitting out so it doesn't look as abrupt
		for(int i=0; i<HEALTHBAR_ENDDELAY; i++){
			if(damageCounter>0)
				damageCounter--;
			HealthBar_Draw(nameString, 0, maxHP, 0, damage, damageCounter, 0);
			Waitframe();
		}
	}
	//Returns the combined HP of up to 6 types of NPCs on the screen for all instances
	int HealthBar_GetHPTotal(int npcid1, int npcid2, int npcid3, int npcid4, int npcid5, int npcid6){
		int total;
		for(int i=Screen->NumNPCs(); i>=1; i--){
			npc n = Screen->LoadNPC(i);
			if(n->ID==npcid1)
				total += Max(HealthBar_GetHP(n), 0);
			if(n->ID==npcid2)
				total += Max(HealthBar_GetHP(n), 0);
			if(n->ID==npcid3)
				total += Max(HealthBar_GetHP(n), 0);
			if(n->ID==npcid4)
				total += Max(HealthBar_GetHP(n), 0);
			if(n->ID==npcid5)
				total += Max(HealthBar_GetHP(n), 0);
			if(n->ID==npcid6)
				total += Max(HealthBar_GetHP(n), 0);
		}
		return total;
	}
	//Draws a string with an outline
	void HealthBar_DrawString(int layer, int x, int y, int font, int c1, int c2, int format, int str){
		Screen->DrawString(layer, x, y-1, font, c2, -1, format, str, 128);
		Screen->DrawString(layer, x, y+1, font, c2, -1, format, str, 128);
		Screen->DrawString(layer, x-1, y, font, c2, -1, format, str, 128);
		Screen->DrawString(layer, x+1, y, font, c2, -1, format, str, 128);
		
		Screen->DrawString(layer, x, y, font, c1, -1, format, str, 128);
	}
	//Draws damage numbers as a string
	void HealthBar_DrawDamage(int layer, int x, int y, int font, int c1, int c2, int number){
		int istr[8];
		int i;
		//Add every digit to the string from largest to smallest
		if(number>=10000){
			istr[i] = '0'+(Floor(number/10000)%10);
			i++;
		}
		if(number>=1000){
			istr[i] = '0'+(Floor(number/1000)%10);
			i++;
		}
		if(number>=100){
			istr[i] = '0'+(Floor(number/100)%10);
			i++;
		}
		if(number>=10){
			istr[i] = '0'+(Floor(number/10)%10);
			i++;
		}
		istr[i] = '0'+(number%10);
		i++;
		istr[i] = 0;
		HealthBar_DrawString(layer, x, y, font, c1, c2, TF_RIGHT, istr);
	}
	//Draws the entire health bar
	void HealthBar_Draw(int str, int HP, int maxHP, int drainHP, int damage, int damageCounter, int offset){
		int x1 = HEALTHBAR_X;
		int y1 = HEALTHBAR_Y+offset;
		int x2 = HEALTHBAR_X+HEALTHBAR_WIDTH-1;
		int y2 = HEALTHBAR_Y+HEALTHBAR_HEIGHT-1+offset;
		int hpLength = (x2-x1-2)*(HP/maxHP);
		int drainLength = (x2-x1-2)*(drainHP/maxHP);
		
		//Draws the main body of the health bar
		Screen->Rectangle(6, x1, y1, x2, y2, C_HEALTHBAR_BG, 1, 0, 0, 0, true, 128);
		if(drainHP>0&&HEALTHBAR_DRAW_CHIP)
			Screen->Rectangle(6, x1+1, y1+1, x1+1+Clamp(drainLength, 0, x2-x1-2), y2-1, C_HEALTHBAR_DRAIN, 1, 0, 0, 0, true, 128);
		if(HP>0)
			Screen->Rectangle(6, x1+1, y1+1, x1+1+Clamp(hpLength, 0, x2-x1-2), y2-1, C_HEALTHBAR_BAR, 1, 0, 0, 0, true, 128);
		Screen->Rectangle(6, x1, y1, x2, y2, C_HEALTHBAR_OUTLINE, 1, 0, 0, 0, false, 128);
	
		//Draw the string
		if(str>0){
			HealthBar_DrawString(6, x1+HEALTHBAR_FONT_X_OFFSET, y1+HEALTHBAR_FONT_Y_OFFSET, FONT_HEALTHBAR_TITLE, C_HEALTHBAR_FONT, C_HEALTHBAR_FONTBG, TF_NORMAL, str);
		}
		
		//Draw the damage
		if(HEALTHBAR_DRAW_DAMAGE){
			if(damageCounter>0){
				HealthBar_DrawDamage(6, x2-HEALTHBAR_FONT_X_OFFSET, y1+HEALTHBAR_FONT_Y_OFFSET, FONT_HEALTHBAR_TITLE, C_HEALTHBAR_FONT, C_HEALTHBAR_FONTBG, damage);
			}
		}
	}
	//Remove trailing spaces from a string
	void HealthBar_CapString(int str){
		for(int i=SizeOfArray(str)-1; i>=0; i--){
			if(str[i]>32){
				str[i+1] = 0;
				return;
			}
		}
	}
}

const int HEALTHBAR_TILED_UNIQUEFIRSTLAST = 1; //Set to 1 if you want to use unique first and last blocks
const int HEALTHBAR_TILED_DRAWCAPS = 1; //Set to 1 if you want to use cap tiles (two states, drawn on either end)
const int HEALTHBAR_TILED_VERTICAL = 0; //Set to 1 if you want the health bar to be vertical

//X and Y position of the tiled health bar
const int HEALTHBAR_TILED_X = 16;
const int HEALTHBAR_TILED_Y = 16;

const int HEALTHBAR_TILED_NUM_BLOCKS = 7; //How many tiles make up the health bar
const int HEALTHBAR_TILED_SPACING = 16; //How many pixels the tiles are spaced apart
const int HEALTHBAR_TILED_STATES = 17; //How many states health bar tiles have, from full to empty

//Offsets for the font of the NPC's name
const int HEALTHBAR_TILED_FONT_X_OFFSET = 0;
const int HEALTHBAR_TILED_FONT_Y_OFFSET = -4;

//Y offset for duplicate health bars
const int HEALTHBAR_TILED_DUPE_OFFSET = 20;

const int FONT_HEALTHBAR_TILED_TITLE = FONT_SUBSCREEN3; //Font for the title and damage numbers. See FONT_ in std_constants.zh

const int C_HEALTHBAR_TILED_FONT = 0x01; //Color of the health bar's font
const int C_HEALTHBAR_TILED_FONTBG = 0x0F; //Color of the health bar's font background

const int CS_HEALTHBAR_TILED = 8; //CSet of the tiled health bar

//Tiles for the main health bar
const int TIL_HEALTHBAR_TILED_MAIN = 66580; //First of the tiles for the main blocks of the health bar
const int TIL_HEALTHBAR_TILED_FIRST = 66560; //First of the tiles for the first block
const int TIL_HEALTHBAR_TILED_LAST = 66600; //First of the tiles for the last block
const int TIL_HEALTHBAR_TILED_FIRSTCAP = 66720; //First of two tiles for the starting cap
const int TIL_HEALTHBAR_TILED_LASTCAP = 66722; //First of two tiles for the end cap

//Tiles for the draining health bar
const int TIL_HEALTHBAR_TILED_DRAIN_MAIN = 66640; //First of the tiles for the main blocks of the health bar
const int TIL_HEALTHBAR_TILED_DRAIN_FIRST = 66620; //First of the tiles for the first block
const int TIL_HEALTHBAR_TILED_DRAIN_LAST = 66660; //First of the tiles for the last block
const int TIL_HEALTHBAR_TILED_DRAIN_FIRSTCAP = 66720; //First of two tiles for the starting cap
const int TIL_HEALTHBAR_TILED_DRAIN_LASTCAP = 66722; //First of two tiles for the end cap


ffc script HealthBar_Tiled_Single{
	void run(int npcid, int str, int npcNumber, int disappearOnDeath){
		Waitframes(4);
		npc n = HealthBar_GetNPC(npcid, npcNumber);
		if(!n->isValid()) //If an enemy isn't found, quit out
			Quit();
		
		int hp = HealthBar_GetHP(n);
		int maxHP = HealthBar_GetHP(n);
		int lastHP = HealthBar_GetHP(n);
		int drainHP = HealthBar_GetHP(n);
		int lastDrainHP = HealthBar_GetHP(n);
		int damage;
		int damageCounter;
		
		//If there's more than one enemy with health bars on the screen, offset them by the 
		int ffcCount;
		for(int i=1; i<=32; i++){
			ffc f = Screen->LoadFFC(i);
			if(f->Script==this->Script){
				if(f==this)
					break;
				else
					ffcCount++;
			}
		}
		
		
		int nameString[256];
		if(str>0){ //Get nameString from the string editor
			Game->GetMessage(str, nameString);
		}
		else{ //Get nameString from the enemy editor
			n->GetName(nameString);
		}
		
		HealthBar_CapString(nameString);
		this->InitD[0] = 0; //Mark the FFC as "Alive"
		
		int shakeTimer;
		int shakeIntensity;
		
		//Begin main loop that runs until HP drains to 0
		while(drainHP>0){
			if(n->isValid()) //If the enemy isn't there, assume it's dead
				hp = Max(HealthBar_GetHP(n), 0);
			else
				hp = 0;
			
			if(damageCounter>0)
				damageCounter--;
			
			if(shakeTimer)
				--shakeTimer;
			
			//Keep track of when the enemy takes damage
			if(hp!=lastHP){
				if(hp<lastHP){
					if(damageCounter>0&&HEALTHBAR_DRAW_DAMAGE==1)
						damage += lastHP-hp;
					else
						damage = lastHP-hp;
					if(damage>300){
						shakeTimer = 48;
						shakeIntensity = Floor(Clamp(2+(damage-300)/100, 2, 6));
					}
					damageCounter = HEALTHBAR_DAMAGE_COUNT;
				}
				lastDrainHP = lastHP;
				lastHP = hp;
			}
			
			//Decrease drainHP towards the current HP
			if(drainHP!=hp){
				if(drainHP>hp){
					drainHP = Max(drainHP-(Abs(lastDrainHP-hp)/HEALTHBAR_CHIP_RATE), hp);
				}
				else
					drainHP = hp;
			}
			
			HealthBar_Draw(nameString, hp, maxHP, drainHP, damage, damageCounter, HEALTHBAR_TILED_DUPE_OFFSET*ffcCount, shakeTimer, 48, shakeIntensity);
			Waitframe();
		}
		
		this->InitD[0] = 1; //Mark the FFC as "Dead"
		
		while(true){ 
			if(damageCounter>0)
				damageCounter--;
			
			if(shakeTimer)
				--shakeTimer;
			
			HealthBar_Draw(nameString, 0, maxHP, 0, damage, damageCounter, HEALTHBAR_TILED_DUPE_OFFSET*ffcCount, shakeTimer, 48, shakeIntensity);
			
			//If marked to disappear, wait until all health bars are "Dead" before removing
			if(disappearOnDeath){
				if(HealthBar_CheckDone(this)){
					break;
				}
			}
			Waitframe();
		}
		
		//Wait extra frames before quitting out so it doesn't look as abrupt
		for(int i=0; i<HEALTHBAR_ENDDELAY; i++){
			if(damageCounter>0)
				damageCounter--;
			
			if(shakeTimer)
				--shakeTimer;
			
			HealthBar_Draw(nameString, 0, maxHP, 0, damage, damageCounter, HEALTHBAR_TILED_DUPE_OFFSET*ffcCount, shakeTimer, 48, shakeIntensity);
			Waitframe();
		}
	}
	//Returns true if all FFCs with this script are "Dead"
	bool HealthBar_CheckDone(ffc this){
		for(int i=1; i<=32; i++){
			ffc f = Screen->LoadFFC(i);
			if(f->Script==this->Script){
				if(f->InitD[0]==0)
					return false;
			}
		}
		return true;
	}
	//Returns the nth enemy with a certain ID on the screen
	npc HealthBar_GetNPC(int id, int extra){
		for(int i=Screen->NumNPCs(); i>=1; i--){
			npc n = Screen->LoadNPC(i);
			if(n->ID==id){
				if(extra<=1)
					return n;
				else
					extra--;
			}
		}
	}
	//Draws a string with an outline
	void HealthBar_DrawString(int layer, int x, int y, int font, int c1, int c2, int format, int str){
		Screen->DrawString(layer, x, y-1, font, c2, -1, format, str, 128);
		Screen->DrawString(layer, x, y+1, font, c2, -1, format, str, 128);
		Screen->DrawString(layer, x-1, y, font, c2, -1, format, str, 128);
		Screen->DrawString(layer, x+1, y, font, c2, -1, format, str, 128);
		
		Screen->DrawString(layer, x, y, font, c1, -1, format, str, 128);
	}
	//Draws damage numbers as a string
	void HealthBar_DrawDamage(int layer, int x, int y, int font, int c1, int c2, int number){
		int istr[8];
		int i;
		//Add every digit to the string from largest to smallest
		if(number>=10000){
			istr[i] = '0'+(Floor(number/10000)%10);
			i++;
		}
		if(number>=1000){
			istr[i] = '0'+(Floor(number/1000)%10);
			i++;
		}
		if(number>=100){
			istr[i] = '0'+(Floor(number/100)%10);
			i++;
		}
		if(number>=10){
			istr[i] = '0'+(Floor(number/10)%10);
			i++;
		}
		istr[i] = '0'+(number%10);
		i++;
		istr[i] = 0;
		HealthBar_DrawString(layer, x, y, font, c1, c2, TF_RIGHT, istr);
	}
	//Draws a tiled health bar
	void HealthBar_DrawTiledHealthBar(int layer, int startX, int startY, int cset, int tilStart, int tilMain, int tilEnd, int tilStartCap, int tilEndCap, int HP, int maxHP){
		int x; int y; int til;
		int blockMaxHP = maxHP/HEALTHBAR_TILED_NUM_BLOCKS; //The total HP per tile in the health bar
		int currentBlock = Clamp(Floor(HP/blockMaxHP), 0, HEALTHBAR_TILED_NUM_BLOCKS); //Which tile of the health bar the enemy's HP falls under
		int blockHP = HP%blockMaxHP; //The HP of the current block
		int blockTil = Clamp(((blockMaxHP-blockHP)/blockMaxHP)*HEALTHBAR_TILED_STATES, 0, HEALTHBAR_TILED_STATES-1); //The tile offset for the current block based on its HP
		
		//Prevent the last tile from appearing as "empty" if the enemy is close to dead
		if(blockTil==HEALTHBAR_TILED_STATES-1&&HP>0&& currentBlock==0)
			blockTil = HEALTHBAR_TILED_STATES-2;
		
		//Cycle through all the blocks
		for(int i=0; i<HEALTHBAR_TILED_NUM_BLOCKS; i++){
			x = startX;
			y = startY;
			if(HEALTHBAR_TILED_VERTICAL)
				y += HEALTHBAR_TILED_SPACING*i;
			else
				x += HEALTHBAR_TILED_SPACING*i;
			til = tilMain;
			//Change the base tile if unique start/end tiles are being used
			if(HEALTHBAR_TILED_UNIQUEFIRSTLAST){
				if(i==0)
					til = tilStart;
				else if(i==HEALTHBAR_TILED_NUM_BLOCKS-1)
					til = tilEnd;
			}
			//Draw different states based on relation to the "current HP" block
			if(i<currentBlock)
				Screen->FastTile(layer, x, y, til, cset, 128);
			else if(i==currentBlock)
				Screen->FastTile(layer, x, y, til+blockTil, cset, 128);
			else
				Screen->FastTile(layer, x, y, til+HEALTHBAR_TILED_STATES-1, cset, 128);
		}
		//If caps are enabled, draw those
		if(HEALTHBAR_TILED_DRAWCAPS){
			if(HEALTHBAR_TILED_VERTICAL){
				if(HP>0) //Caps have two states, depending on whether HP is empty/full and which side of the bar the cap is on
					Screen->FastTile(layer, startX, startY-HEALTHBAR_TILED_SPACING, tilStartCap, cset, 128);
				else
					Screen->FastTile(layer, startX, startY-HEALTHBAR_TILED_SPACING, tilStartCap+1, cset, 128);
				if(HP<maxHP)
					Screen->FastTile(layer, startX, startY+HEALTHBAR_TILED_NUM_BLOCKS*HEALTHBAR_TILED_SPACING, tilEndCap+1, cset, 128);
				else
					Screen->FastTile(layer, startX, startY+HEALTHBAR_TILED_NUM_BLOCKS*HEALTHBAR_TILED_SPACING, tilEndCap, cset, 128);
			}
			else{
				if(HP>0)
					Screen->FastTile(layer, startX-HEALTHBAR_TILED_SPACING, startY, tilStartCap, cset, 128);
				else
					Screen->FastTile(layer, startX-HEALTHBAR_TILED_SPACING, startY, tilStartCap+1, cset, 128);
				if(HP<maxHP)
					Screen->FastTile(layer, startX+HEALTHBAR_TILED_NUM_BLOCKS*HEALTHBAR_TILED_SPACING, startY, tilEndCap+1, cset, 128);
				else
					Screen->FastTile(layer, startX+HEALTHBAR_TILED_NUM_BLOCKS*HEALTHBAR_TILED_SPACING, startY, tilEndCap, cset, 128);
			}
		}
	}
	//Draws the entire health bar
	void HealthBar_Draw(int str, int HP, int maxHP, int drainHP, int damage, int damageCounter, int offset, int shakeTimer, int shakeMaxTimer, int shakeIntensity){
		int main = TIL_HEALTHBAR_TILED_MAIN;
		int first = TIL_HEALTHBAR_TILED_FIRST; 
		int last = TIL_HEALTHBAR_TILED_LAST;
		int firstCap = TIL_HEALTHBAR_TILED_FIRSTCAP;
		int lastCap = TIL_HEALTHBAR_TILED_LASTCAP;
		
		int mainD = TIL_HEALTHBAR_TILED_DRAIN_MAIN;
		int firstD = TIL_HEALTHBAR_TILED_DRAIN_FIRST;
		int lastD = TIL_HEALTHBAR_TILED_DRAIN_LAST;
		int firstCapD = TIL_HEALTHBAR_TILED_DRAIN_FIRSTCAP;
		int lastCapD = TIL_HEALTHBAR_TILED_DRAIN_LASTCAP;
		
		if(G[G_GRAYHEALTHBAR]){
			main += 780;
			first += 780;
			last += 780;
			firstCap += 780;
			lastCap += 780;
			
			mainD += 780;
			firstD += 780;
			lastD += 780;
			firstCapD += 780;
			lastCapD += 780;
			
			G[G_GRAYHEALTHBAR] = 0;
		}

		int x1 = HEALTHBAR_TILED_X;
		int y1 = HEALTHBAR_TILED_Y;
		if(Game->GetCurMap() == 6 && Game->GetCurScreen() == 0x1B)
			y1 = 0;
		int x2 = x1+HEALTHBAR_TILED_SPACING*HEALTHBAR_TILED_NUM_BLOCKS-1;
		
		int offX = 0;
		int offY = 0;
		if(shakeTimer){
			int tempIntensity = Lerp(0, shakeIntensity, shakeTimer/shakeMaxTimer);
			offX = Rand(-tempIntensity, tempIntensity);
			offY = Rand(-tempIntensity, tempIntensity);
		}
		
		//Draws the main body of the health bar
		if(HEALTHBAR_DRAW_CHIP)
			HealthBar_DrawTiledHealthBar(7, x1+offX, y1+offset+offY, CS_HEALTHBAR_TILED, firstD, mainD, lastD, firstCapD, lastCapD, drainHP, maxHP);
		HealthBar_DrawTiledHealthBar(7, x1+offX, y1+offset+offY, CS_HEALTHBAR_TILED, first, main, last, firstCap, lastCap, HP, maxHP);
		
		if(!HEALTHBAR_TILED_VERTICAL){
			//Draw the string
			if(str>0){
				HealthBar_DrawString(7, x1+HEALTHBAR_TILED_FONT_X_OFFSET, y1+HEALTHBAR_TILED_FONT_Y_OFFSET+offset, FONT_HEALTHBAR_TILED_TITLE, C_HEALTHBAR_TILED_FONT, C_HEALTHBAR_TILED_FONTBG, TF_NORMAL, str);
			}
			
			//Draw the damage
			if(HEALTHBAR_DRAW_DAMAGE){
				if(damageCounter>0){
					HealthBar_DrawDamage(7, x2-HEALTHBAR_TILED_FONT_X_OFFSET, y1+HEALTHBAR_TILED_FONT_Y_OFFSET+offset, FONT_HEALTHBAR_TILED_TITLE, C_HEALTHBAR_TILED_FONT, C_HEALTHBAR_TILED_FONTBG, damage);
				}
			}
		}
	}
	//Remove trailing spaces from a string
	void HealthBar_CapString(int str){
		for(int i=SizeOfArray(str)-1; i>=0; i--){
			if(str[i]>32){
				str[i+1] = 0;
				return;
			}
		}
	}
}

ffc script HealthBar_Tiled_Group{
	void run(int npcid1, int npcid2, int npcid3, int npcid4, int npcid5, int npcid6, int str, int disappearOnDeath){
		Waitframes(4);
		if(HealthBar_GetHPTotal(npcid1, npcid2, npcid3, npcid4, npcid5, npcid6)==0) //If none of the enemies are found, quit out
			Quit();
		
		int hp = HealthBar_GetHPTotal(npcid1, npcid2, npcid3, npcid4, npcid5, npcid6);
		int maxHP = hp;
		int lastHP = hp;
		int drainHP = hp;
		int lastDrainHP = hp;
		int damage;
		int damageCounter;
		
		
		int nameString[256];
		if(str>0){ //Get nameString from the string editor
			Game->GetMessage(str, nameString);
		}
		
		HealthBar_CapString(nameString);
		
		//Begin main loop that runs until HP drains to 0
		while(drainHP>0){
			hp = HealthBar_GetHPTotal(npcid1, npcid2, npcid3, npcid4, npcid5, npcid6);
			
			//There's really no clean way I can think of to handle enemies that summon more of themselves
			//so in this case we'll count this as healing and increase maxHP when necessary
			if(maxHP<hp)
				maxHP = hp;
			
			if(damageCounter>0)
				damageCounter--;
			
			//Keep track of when the enemy takes damage
			if(hp!=lastHP){
				if(hp<lastHP){
					if(damageCounter>0)
						damage += lastHP-hp;
					else
						damage = lastHP-hp;
					damageCounter = HEALTHBAR_DAMAGE_COUNT;
				}
				lastDrainHP = lastHP;
				lastHP = hp;
			}
			
			//Decrease drainHP towards the current HP
			if(drainHP!=hp){
				if(drainHP>hp){
					drainHP = Max(drainHP-(Abs(lastDrainHP-hp)/HEALTHBAR_CHIP_RATE), hp);
				}
				else
					drainHP = hp;
			}
			
			HealthBar_Draw(nameString, hp, maxHP, drainHP, damage, damageCounter, 0);
			Waitframe();
		}
		
		if(!disappearOnDeath){
			while(true){ 
				if(damageCounter>0)
					damageCounter--;
				HealthBar_Draw(nameString, 0, maxHP, 0, damage, damageCounter, 0);
				
				Waitframe();
			}
		}
		
		//Wait extra frames before quitting out so it doesn't look as abrupt
		for(int i=0; i<HEALTHBAR_ENDDELAY; i++){
			if(damageCounter>0)
				damageCounter--;
			HealthBar_Draw(nameString, 0, maxHP, 0, damage, damageCounter, 0);
			Waitframe();
		}
	}
	//Returns the combined HP of up to 6 types of NPCs on the screen for all instances
	int HealthBar_GetHPTotal(int npcid1, int npcid2, int npcid3, int npcid4, int npcid5, int npcid6){
		int total;
		for(int i=Screen->NumNPCs(); i>=1; i--){
			npc n = Screen->LoadNPC(i);
			if(n->ID==npcid1)
				total += Max(HealthBar_GetHP(n), 0);
			if(n->ID==npcid2)
				total += Max(HealthBar_GetHP(n), 0);
			if(n->ID==npcid3)
				total += Max(HealthBar_GetHP(n), 0);
			if(n->ID==npcid4)
				total += Max(HealthBar_GetHP(n), 0);
			if(n->ID==npcid5)
				total += Max(HealthBar_GetHP(n), 0);
			if(n->ID==npcid6)
				total += Max(HealthBar_GetHP(n), 0);
		}
		return total;
	}
	//Draws a string with an outline
	void HealthBar_DrawString(int layer, int x, int y, int font, int c1, int c2, int format, int str){
		Screen->DrawString(layer, x, y-1, font, c2, -1, format, str, 128);
		Screen->DrawString(layer, x, y+1, font, c2, -1, format, str, 128);
		Screen->DrawString(layer, x-1, y, font, c2, -1, format, str, 128);
		Screen->DrawString(layer, x+1, y, font, c2, -1, format, str, 128);
		
		Screen->DrawString(layer, x, y, font, c1, -1, format, str, 128);
	}
	//Draws damage numbers as a string
	void HealthBar_DrawDamage(int layer, int x, int y, int font, int c1, int c2, int number){
		int istr[8];
		int i;
		//Add every digit to the string from largest to smallest
		if(number>=10000){
			istr[i] = '0'+(Floor(number/10000)%10);
			i++;
		}
		if(number>=1000){
			istr[i] = '0'+(Floor(number/1000)%10);
			i++;
		}
		if(number>=100){
			istr[i] = '0'+(Floor(number/100)%10);
			i++;
		}
		if(number>=10){
			istr[i] = '0'+(Floor(number/10)%10);
			i++;
		}
		istr[i] = '0'+(number%10);
		i++;
		istr[i] = 0;
		HealthBar_DrawString(layer, x, y, font, c1, c2, TF_RIGHT, istr);
	}
	//Draws a tiled health bar
	void HealthBar_DrawTiledHealthBar(int layer, int startX, int startY, int cset, int tilStart, int tilMain, int tilEnd, int tilStartCap, int tilEndCap, int HP, int maxHP){
		int x; int y; int til;
		int blockMaxHP = maxHP/HEALTHBAR_TILED_NUM_BLOCKS; //The total HP per tile in the health bar
		int currentBlock = Clamp(Floor(HP/blockMaxHP), 0, HEALTHBAR_TILED_NUM_BLOCKS); //Which tile of the health bar the enemy's HP falls under
		int blockHP = HP%blockMaxHP; //The HP of the current block
		int blockTil = Clamp(((blockMaxHP-blockHP)/blockMaxHP)*HEALTHBAR_TILED_STATES, 0, HEALTHBAR_TILED_STATES-1); //The tile offset for the current block based on its HP
		
		//Prevent the last tile from appearing as "empty" if the enemy is close to dead
		if(blockTil==HEALTHBAR_TILED_STATES-1&&HP>0&& currentBlock==0)
			blockTil = HEALTHBAR_TILED_STATES-2;
		
		//Cycle through all the blocks
		for(int i=0; i<HEALTHBAR_TILED_NUM_BLOCKS; i++){
			x = startX;
			y = startY;
			if(HEALTHBAR_TILED_VERTICAL)
				y += HEALTHBAR_TILED_SPACING*i;
			else
				x += HEALTHBAR_TILED_SPACING*i;
			til = tilMain;
			//Change the base tile if unique start/end tiles are being used
			if(HEALTHBAR_TILED_UNIQUEFIRSTLAST){
				if(i==0)
					til = tilStart;
				else if(i==HEALTHBAR_TILED_NUM_BLOCKS-1)
					til = tilEnd;
			}
			//Draw different states based on relation to the "current HP" block
			if(i<currentBlock)
				Screen->FastTile(layer, x, y, til, cset, 128);
			else if(i==currentBlock)
				Screen->FastTile(layer, x, y, til+blockTil, cset, 128);
			else
				Screen->FastTile(layer, x, y, til+HEALTHBAR_TILED_STATES-1, cset, 128);
		}
		//If caps are enabled, draw those
		if(HEALTHBAR_TILED_DRAWCAPS){
			if(HEALTHBAR_TILED_VERTICAL){
				if(HP>0) //Caps have two states, depending on whether HP is empty/full and which side of the bar the cap is on
					Screen->FastTile(layer, startX, startY-HEALTHBAR_TILED_SPACING, tilStartCap, cset, 128);
				else
					Screen->FastTile(layer, startX, startY-HEALTHBAR_TILED_SPACING, tilStartCap+1, cset, 128);
				if(HP<maxHP)
					Screen->FastTile(layer, startX, startY+HEALTHBAR_TILED_NUM_BLOCKS*HEALTHBAR_TILED_SPACING, tilEndCap+1, cset, 128);
				else
					Screen->FastTile(layer, startX, startY+HEALTHBAR_TILED_NUM_BLOCKS*HEALTHBAR_TILED_SPACING, tilEndCap, cset, 128);
			}
			else{
				if(HP>0)
					Screen->FastTile(layer, startX-HEALTHBAR_TILED_SPACING, startY, tilStartCap, cset, 128);
				else
					Screen->FastTile(layer, startX-HEALTHBAR_TILED_SPACING, startY, tilStartCap+1, cset, 128);
				if(HP<maxHP)
					Screen->FastTile(layer, startX+HEALTHBAR_TILED_NUM_BLOCKS*HEALTHBAR_TILED_SPACING, startY, tilEndCap+1, cset, 128);
				else
					Screen->FastTile(layer, startX+HEALTHBAR_TILED_NUM_BLOCKS*HEALTHBAR_TILED_SPACING, startY, tilEndCap, cset, 128);
			}
		}
	}
	//Draws the entire health bar
	void HealthBar_Draw(int str, int HP, int maxHP, int drainHP, int damage, int damageCounter, int offset){
		int x1 = HEALTHBAR_TILED_X;
		int y1 = HEALTHBAR_TILED_Y;
		int x2 = x1+HEALTHBAR_TILED_SPACING*HEALTHBAR_TILED_NUM_BLOCKS-1;
		
		//Draws the main body of the health bar
		if(HEALTHBAR_DRAW_CHIP)
			HealthBar_DrawTiledHealthBar(7, x1, y1+offset, CS_HEALTHBAR_TILED, TIL_HEALTHBAR_TILED_DRAIN_FIRST, TIL_HEALTHBAR_TILED_DRAIN_MAIN, TIL_HEALTHBAR_TILED_DRAIN_LAST, TIL_HEALTHBAR_TILED_DRAIN_FIRSTCAP, TIL_HEALTHBAR_TILED_DRAIN_LASTCAP, drainHP, maxHP);
		HealthBar_DrawTiledHealthBar(7, x1, y1+offset, CS_HEALTHBAR_TILED, TIL_HEALTHBAR_TILED_FIRST, TIL_HEALTHBAR_TILED_MAIN, TIL_HEALTHBAR_TILED_LAST, TIL_HEALTHBAR_TILED_FIRSTCAP, TIL_HEALTHBAR_TILED_LASTCAP, HP, maxHP);
		
		if(!HEALTHBAR_TILED_VERTICAL){
			//Draw the string
			if(str>0){
				HealthBar_DrawString(7, x1+HEALTHBAR_TILED_FONT_X_OFFSET, y1+HEALTHBAR_TILED_FONT_Y_OFFSET+offset, FONT_HEALTHBAR_TILED_TITLE, C_HEALTHBAR_TILED_FONT, C_HEALTHBAR_TILED_FONTBG, TF_NORMAL, str);
			}
			
			//Draw the damage
			if(HEALTHBAR_DRAW_DAMAGE){
				if(damageCounter>0){
					HealthBar_DrawDamage(7, x2-HEALTHBAR_TILED_FONT_X_OFFSET, y1+HEALTHBAR_TILED_FONT_Y_OFFSET+offset, FONT_HEALTHBAR_TILED_TITLE, C_HEALTHBAR_TILED_FONT, C_HEALTHBAR_TILED_FONTBG, damage);
				}
			}
		}
	}
	//Remove trailing spaces from a string
	void HealthBar_CapString(int str){
		for(int i=SizeOfArray(str)-1; i>=0; i--){
			if(str[i]>32){
				str[i+1] = 0;
				return;
			}
		}
	}
}

void TraceToScreen(int y, int i){
	Screen->DrawInteger(7, 8, y, FONT_Z1, 0x01, 0x0F, -1, -1, i, 4, 128);
}

//Returns true if all hymnstone rewards have been bought
bool CheckHymnstoneCompletion(){
	if(G[G_ASHERMAXHP]<16*7||G[G_TORRINMAXHP]<16*7||G[G_KAYLANIMAXHP]<16*7)
		return false;
	if(Game->Counter[CR_ASHERAUGMENTSLOTS]<2||Game->Counter[CR_TORRINAUGMENTSLOTS]<2||Game->Counter[CR_KAYLANIAUGMENTSLOTS]<2)
		return false;
	if(!FoundItems[I_ABILITY_A_ASHER]||!FoundItems[I_DASHUPGRADE]||!FoundItems[I_ABILITY_C_ASHER])
		return false;
	if(!FoundItems[I_SWORD_TORRIN2])
		return false;
	if(!FoundItems[I_SWORD_KAYLANI2]||!FoundItems[I_ABILITY_A_KAYLANI]||!FoundItems[I_ABILITY_B_KAYLANI]||!FoundItems[I_ABILITY_C_KAYLANI])
		return false;
	return true;
}

ffc script CanYouFeelTheJankTonight{ //Russ's misc script of fuck my life why am I doing this
	void run(int JankSelector, int d1, int d2){
		if(JankSelector == 0){  //For the one screen where you can magnet over water to the island
			int ct;
			while(true){
				while(Link->Z == 0 && Link->X >= 161 && Link->X <= 168 && (Link->Action == LA_NONE || Link->Action == LA_WALKING || Link->Action == LA_HOPPING)){
					// Link->Action = LA_SWIMMING;
					Link->X--;
					Waitframe();
				}
				while(Link->Z == 0 && Link->X >=89 && Link->X <= 95 && (Link->Action == LA_NONE || Link->Action == LA_WALKING || Link->Action == LA_HOPPING)){
					// Link->Action = LA_SWIMMING;
					Link->X++;
					Waitframe();
				}
				if(Link->Action == LA_SWIMMING){
					Screen->ComboD[ComboAt(80, 64)] = 5204;
					Screen->ComboD[ComboAt(176, 64)] = 5207;
				}
				Waitframe();
			}
		}
		if(JankSelector == 1){ //Pulling the magnet rock out of the cliff
			int timetime;
			int origx = this->X;
			if(Screen->State[ST_SECRET] == true){
				this->Data = 0;
				Quit();
			}
			// else{
				// Screen->ComboD[ComboAt(128, 16)] = 5989;
				// Screen->ComboD[ComboAt(144, 16)] = 5990;
				// this->Data = 5987;
			// }
			while(true){
				if(GLW[GL_MAGNETHITBOX]->isValid()){
					while(Collision(this, GLW[GL_MAGNETHITBOX]) && GLW[GL_MAGNETHITBOX]->Damage==1 && Link->Dir == DIR_UP){
						timetime++;
						if(timetime % 2 == 1)
							this->X = origx + 1;
						else
							this->X = origx;
						if(timetime == 60){
							this->Data = 0;
							Screen->ComboD[ComboAt(128, 16)] = 5989;
							Screen->ComboD[ComboAt(144, 16)] = 5990;
							CreateLWeaponAt(LW_BOMBBLAST, this->X, this->Y);
							Game->PlaySound(SFX_FALL);
							ffc rock = FindFreeFFC();
							rock->X = this->X;
							rock->Y = this->Y;
							rock->Data = 38406;
							int vel;
							while(rock->Y < 72){
								vel+=0.16;
								if(Abs(rock->Y - 72) <= vel)
									rock->Y = 72;
								else
									rock->Y += vel;
								Screen->FastTile(1, rock->X, 72, 832, 7, OP_OPAQUE);
								Waitframe();
							}
							Game->PlaySound(42);
							rock->InitD[0] = 1;
							rock->Script = 31;
							rock->InitD[0] = 1;
							Quit();
						}
						Waitframe();
					}
					timetime = 0;
				}
				Waitframe();
			}
		}
		if(JankSelector == 2){ //Spawning the miniboss that gives the Kawaihae gem 
			if(G[G_RANDOMIZERENABLED]){
				if(!Screen->State[ST_BOSSLOCKBLOCK]){
					CreateNPCAt(203, 112, 80);
					CreateNPCAt(180, 160, 64);
					CreateNPCAt(180, 192, 112);
					CreateNPCAt(180, 64, 128);
					while(Screen->NumNPCs() > 0){
						Waitframe();
					}
					Screen->State[ST_BOSSLOCKBLOCK] = true;
				}
			}
			if((Game->Counter[CR_ASHERSIDEQUEST] == 1 || Game->Counter[CR_ASHERSIDEQUEST] == 2) && Screen->State[ST_SECRET] == false){
				CreateNPCAt(203, 112, 80);
				CreateNPCAt(180, 160, 64);
				CreateNPCAt(180, 192, 112);
				CreateNPCAt(180, 64, 128);
				Waitframes(60);
				if(Game->Counter[CR_ASHERSIDEQUEST] == 1){
					SuspendGhostZHScripts();
					KillEWeapons();
					if(CanUseChar(CHAR_ASHER) > 0)
						PlayStringAndWait("There's Iris's gem... stuck inside a pillar. This might be a pain.", SCHAR_ASHER, EMOTE_NORMAL);
					else
						PlayStringAndWait("There's the gem Ash's sister asked him for... stuck inside a pillar. Might as well grab it for 'im.", SCHAR_TORRIN, EMOTE_NORMAL);
					ResumeGhostZHScripts();
					Game->Counter[CR_ASHERSIDEQUEST] = 2;
				}
				while(Screen->NumNPCs() > 0){
					Waitframe();
				}
				Screen->TriggerSecrets();
				Screen->State[ST_SECRET] = true;
			}
		}
		if(JankSelector == 3){ //Torrin sidequest stuff - Tent scene
			if(Game->Counter[CR_TORRINSIDEQUEST] == 1){
				ffc Torrin = FindFreeFFC();
				Torrin->Data = 1;
				this->Data = 33541;
				this->X = Link->X;
				this->Y = 80;
				this->TileHeight = 2;
				WaitNoAction(30);
				PlayStringAndWait("Torrin? What are you doin' here?", SCHAR_ZEKE, EMOTE_NORMAL);
				PlayStringAndWait("Zeke!", SCHAR_TORRIN, EMOTE_EXCLAMATION);
				if(GetCharID() == CHAR_TORRIN){
					while(Link->Y > 128){
						NoAction();
						Link->InputUp = true;
						Waitframe();
					}
					Link->Action = LA_ATTACKING;
					Waitframe();
					Link->Action = LA_NONE;
				}
				else{
					Torrin->Data = 33296;
					Torrin->X = Link->X;
					Torrin->Y = Link->Y + 16;
					Torrin->TileHeight = 2;
					while(Torrin->Y > 112){
						Torrin->Y--;
						NoAction();
						WaitNoAction();
					}
					Torrin->Data-=4;
				}
				PlayStringAndWait("What on earth are you doin' here?", SCHAR_TORRIN, EMOTE_NORMAL);
				PlayStringAndWait("It wasn't fair that you left us behind! Caiman an' I wanted to go on an adventure too!", SCHAR_ZEKE, EMOTE_NORMAL);
				PlayStringAndWait("Where's Caiman? Is he alright?", SCHAR_TORRIN, EMOTE_NORMAL);
				PlayStringAndWait("He ran up the hill to get some firewood.", SCHAR_ZEKE, EMOTE_NORMAL);
				PlayStringAndWait("Alright, I'll go fetch 'im. Go wait by the dock and don't run off, ya here me? This place is dangerous.", SCHAR_TORRIN, EMOTE_NORMAL);
				PlayStringAndWait("Aww... we have to leave already?", SCHAR_ZEKE, EMOTE_NORMAL);
				this->Data = 33546;
				for(int i = 0; i<16; i++){
					this->X--;
					WaitNoAction();
				}
				this->Data = 33545;
				while(this->Y < 180){
					this->Y++;
					WaitNoAction();
				}
				if(GetCharID() != CHAR_TORRIN){
					Torrin->Data = 33297;
					while(Torrin->Y < 180){
						Torrin->Y++;
						WaitNoAction();
					}
				}
				this->Data = 0;
				Torrin->Data = 0;
				Game->Counter[CR_TORRINSIDEQUEST] = 2;
			}
		}
		if(JankSelector == 4){ //Torrin sidequest stuff - fight scene
			if(G[G_RANDOMIZERENABLED]){
				if(!Screen->State[ST_BOSSLOCKBLOCK]){
					CreateNPCAt(204, 112, 48);
					CreateNPCAt(181, 176, 16);
					CreateNPCAt(181, 208, 64);
					CreateNPCAt(181, 48, 32);
					while(Screen->NumNPCs() > 0){
						Waitframe();
					}
					Screen->State[ST_BOSSLOCKBLOCK] = true;
				}
				Quit();
			}
			if(Game->Counter[CR_TORRINSIDEQUEST] == 2 || Game->Counter[CR_TORRINSIDEQUEST] == 3){
				this->Data = 33551;
				this->TileHeight = 2;
				mapdata l1 = Game->LoadTempScreen(1);
				l1->ComboD[ComboAt(16, 80)] = 1;
				CreateNPCAt(204, 112, 48);
				CreateNPCAt(181, 176, 16);
				CreateNPCAt(181, 208, 64);
				CreateNPCAt(181, 48, 32);
				Game->PlayEnhancedMusic("SS-Boss.ogg", 0);
				Waitframes(30);
				if(Game->Counter[CR_TORRINSIDEQUEST] == 2){
					SuspendGhostZHScripts();
					KillEWeapons();
					PlayStringAndWait("Torrin, help!", SCHAR_CAIMAN, EMOTE_DISMAYED);
					PlayStringAndWait("Don't worry bro, I got ya!", SCHAR_TORRIN, EMOTE_NORMAL);
					ResumeGhostZHScripts();
					Game->Counter[CR_TORRINSIDEQUEST] = 3;
				}
				while(Screen->NumNPCs() > 0){
					Waitframe();
				}
				KillLWeapons();
				KillEWeapons();
				l1->ComboD[ComboAt(16, 80)] = 0;
				Game->PlayMIDI(0);
				PlayStringAndWait("Alright, that takes care a' that. Now 'bout you, Caiman...", SCHAR_TORRIN, EMOTE_NORMAL);
				Fade(true);
				G[G_TORRINHP] = G[G_TORRINMAXHP];
				SetCharacter(CHAR_TORRIN, false);
				Link->HP = Link->MaxHP;
				Link->Action = LA_ATTACKING;
				BlackScreenLayerSix();
				WaitNoAction();
				Game->Counter[CR_TORRINSIDEQUEST] = 4;
				Link->Action = LA_NONE;
				Link->Dir = DIR_RIGHT;
				this->Data = CMB_AUTOWARPA;
			}
		}
		if(JankSelector == 5){ //Torrin sidequest stuff - dock scene
			if(G[G_RANDOMIZERENABLED])
				Quit();
			if(Game->Counter[CR_TORRINSIDEQUEST] == 4){
				this->Data = 33550;
				this->TileHeight = 2;
				ffc Zeke = FindFreeFFC();
				Zeke->Data = 33542;
				Zeke->X = this->X;
				Zeke->Y = this->Y - 26;
				Zeke->TileHeight = 2;
				WaitNoAction(30);
				PlayStringAndWait("We're really sorry, Torrin...", SCHAR_CAIMAN, EMOTE_SAD);
				PlayStringAndWait("Goin' on an adventure seemed fun. We didn't mean to make trouble.", SCHAR_ZEKE, EMOTE_SAD);
				PlayStringAndWait("I know ya didn't, but it's dangerous to sail off without tellin' anyone like that.", SCHAR_TORRIN, EMOTE_NORMAL);
				PlayStringAndWait("You did though!", SCHAR_CAIMAN, EMOTE_NORMAL);
				PlayStringAndWait("I can take care a' myself in a scrap. When you're older and a little more capable, maybe I'll take you 'round to some safer islands with me. But for now, let's get ya both back home before Mom has our necks.", SCHAR_TORRIN, EMOTE_NORMAL);
				Fade(true);
				Link->Dir = DIR_UP;
				Game->Counter[CR_TORRINSIDEQUEST] = 5;
				this->Data = CMB_AUTOWARPD;
			}
		}
		if(JankSelector == 6){ //Torrin sidequest stuff - last scene
			if(Game->Counter[CR_TORRINSIDEQUEST] == 5){
				Game->ContinueDMap = Game->GetCurDMap();
				Game->LastEntranceDMap = Game->GetCurDMap();
				Game->ContinueScreen = Game->GetCurScreen();
				Game->LastEntranceScreen = Game->GetCurScreen();
				WaitNoAction(30);
				PlayStringAndWait("Thank goodness they're alright. You're lucky you got there in time, Tor. An' that Mom didn't notice Caiman was missin'.", SCHAR_TERRY, EMOTE_NORMAL);
				PlayStringAndWait("I know, I know. I gave 'em both a good talkin' to. They know better now.", SCHAR_TORRIN, EMOTE_NORMAL);
				PlayStringAndWait("I wish you did too.", SCHAR_TERRY, EMOTE_NORMAL);
				PlayStringAndWait("C'mon Terry, ya know I can handle myself.", SCHAR_TORRIN, EMOTE_NORMAL);
				PlayStringAndWait("You're a good fighter, but you gotta stop jumpin' into situations every time ya think somethin's not the way it oughta be.", SCHAR_TERRY, EMOTE_NORMAL);
				PlayStringAndWait("Someone's gotta right the wrongs, don't they?", SCHAR_TORRIN, EMOTE_NORMAL);
				PlayStringAndWait("That someone doesn't have to be you. If you're gonna keep doin' dangerous stuff, at least take this augment I found. Don't die out there.", SCHAR_TERRY, EMOTE_NORMAL);
				AugmentGet(193);
				Game->Counter[CR_TORRINSIDEQUEST] = 6;
				Game->ContinueDMap = Game->GetCurDMap();
				Game->LastEntranceDMap = Game->GetCurDMap();
				Game->ContinueScreen = 0x4E;
				Game->LastEntranceScreen = 0x4E;
			}
		}
		if(JankSelector == 7){ //God-dammned combo scripts not working right
			while(true){
				if(Game->DMapPalette[Game->GetCurDMap()] == 0x11A || Game->DMapPalette[Game->GetCurDMap()] == 0x11B){
					SetLayerComboD(2, 135, 0);
					SetLayerComboD(2, 136, 0);
				}
				else{
					SetLayerComboD(2, 135, 48698);
					SetLayerComboD(2, 136, 48699);
				}
				Waitframe();
			}
		}
		if(JankSelector == 8){ //Block off path to the village
			if(Game->Counter[CR_STORYFLAG] < SFLAG_ASHERRESCUED){
				while(true){
					if(Link->X >= 128 && Link->X <= 224 && Link->Y <=40){
						// SuspendGhostZHScripts();
						// KillEWeapons();
						PlayStringAndWait("Let's not go this way for now.", SCHAR_KAYLANI, EMOTE_NORMAL);
						PlayStringAndWait("Why's that?", SCHAR_TORRIN, EMOTE_NORMAL);
						PlayStringAndWait("This path leads home. I'm... not ready to face them yet. Not until I fix this.", SCHAR_KAYLANI, EMOTE_NORMAL);
						while(Link->Y < 48){
							NoAction();
							Link->InputDown = true;
							Waitframe();
						}
						// ResumeGhostZHScripts();
					}
					Waitframe();
				}
			}
			else{
				Screen->TriggerSecrets();
			}
		}
		if(JankSelector == 9){ //Block off path to the summit
			if(Game->Counter[CR_STORYFLAG] < SFLAG_ALIIOPEN){
				while(true){
					if(Link->X >= 160 && Link->X <= 176 && Link->Y <=40){
						PlayStringAndWait("This path leads to the summit of Mauna Ali'i. It's forbidden for anyone to ascend without a good reason.", SCHAR_KAYLANI, EMOTE_NORMAL);
						PlayStringAndWait("An' wantin' to see what's at the top ain't a good reason?", SCHAR_TORRIN, EMOTE_NORMAL);
						PlayStringAndWait("No.", SCHAR_KAYLANI, EMOTE_NORMAL);
						while(Link->Y < 48){
							NoAction();
							Link->InputDown = true;
							Waitframe();
						}
					}
					Waitframe();
				}
			}
			else{
				Screen->TriggerSecrets();
			}
		}
		if(JankSelector == 10){ //Flower for Laverne's sidequest
			if(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_0 && !(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_1)){
				Waitframes(8);
				// while(Screen->NumNPCs() > 0)
					// Waitframe();
				while(true){
					if(Link->Dir == DIR_UP && Link->Y >= this->Y + 8 && Link->Y <= this->Y + 24 && Link->X >= this->X - 8 && Link->X <= this->X + 8){
						Screen->FastCombo(6, this->X, this->Y-16-8, CMB_CANTALK, 0, 128);
						if(Link->PressA){
							Link->PressA = false;
							Link->InputA = false;
							PlayStringAndWait("This looks like the plant Laverne described. Let's take a few clippings.", SCHAR_KAYLANI, EMOTE_NORMAL);
							for(int i = 0; i<3; i++){
								Game->PlaySound(30);
								WaitNoAction(30);
							}
							PlayStringAndWait("There. Now to return them to her.", SCHAR_KAYLANI, EMOTE_NORMAL);
							Game->Counter[CR_SMALLSIDEQUESTS1] |= BF_1;
							Quit();
						}
					}
					Waitframe();
				}
			}
		}
		if(JankSelector == 11){ //Rock for Truf's sidequest
			if(G[G_RANDOMIZERENABLED]){
				Screen->ItemX = 0;
				Screen->ItemY = 0;
				Screen->Item = 0;
				Screen->HasItem = 0;
				SetLayerComboF(1, ComboAt(this->X, this->Y), 6);
				SetLayerComboF(1, ComboAt(this->X+15, this->Y), 6);
				SetLayerComboF(1, ComboAt(this->X, this->Y+15), 6);
				SetLayerComboF(1, ComboAt(this->X+15, this->Y+15), 6);
				Quit();
			}
			if(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_3 && !(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_4)){
				SetLayerComboF(1, ComboAt(this->X, this->Y), 6);
				SetLayerComboF(1, ComboAt(this->X+15, this->Y), 6);
				SetLayerComboF(1, ComboAt(this->X, this->Y+15), 6);
				SetLayerComboF(1, ComboAt(this->X+15, this->Y+15), 6);
			}
			if(Screen->D[0] == 0 && Game->Counter[CR_SMALLSIDEQUESTS1] & BF_3){
				while(true){
					if(Link->Action == LA_DIVING){
						Game->PlaySound(SFX_SWITCH_ERROR);
						for(int i=0; i<3; i++){
							int pos = Switch_GetSpawnPos();
							npc n = CreateNPCAt(184, ComboX(pos), ComboY(pos));
							Game->PlaySound(SFX_FALL);
							n->Z = 176;
							Waitframes(20);
						}
						Screen->D[0] = 1;
						Quit();
					}
					Waitframe();
				}
			}
		}
		if(JankSelector == 12){ //Entering Golem ruins
			if(Game->GetCurScreen() == 0x5C){
				if(Game->Counter[CR_GOLEMSIDEQUEST] == 1){
					while(Screen->State[ST_SECRET] == false)
						Waitframe();
					while(Link->X < 32){
						NoAction();
						Link->PressRight = true;
						Link->InputRight = true;
						Waitframe();
					}
					ffc Siyed = FindFreeFFC();
					Siyed->Data = 33768;
					Siyed->TileHeight = 2;
					Siyed->X = 120;
					Siyed->Y = 160;
					while(Siyed->Y > Link->Y-16){
						Siyed->Y--;
						WaitNoAction();
					}
					Siyed->Data = 33766;
					PlayStringAndWait("You actually made it in. I was beginning to think this was a lost cause.", SCHAR_SIYED, EMOTE_NORMAL);
					PlayStringAndWait("I thought you agreed to kick that defeatist attitude?", SCHAR_KAYLANI, EMOTE_NORMAL);
					PlayStringAndWait("I'm working on it.", SCHAR_SIYED, EMOTE_SWEAT);
					Siyed->Data = 33764;
					WaitNoAction(60);
					PlayStringAndWait("This is definitely the place I was looking for. Come on!", SCHAR_SIYED, EMOTE_NORMAL);
					Fade(true);
					BlackScreenLayerSix();
					this->Data = CMB_AUTOWARPB;
				}
			}
		}
		if(JankSelector == 13){ //Entering Golem ruins 2
			if(Game->GetCurScreen() == 0x4C){
				if(Game->Counter[CR_GOLEMSIDEQUEST] == 1){
					Link->Invisible = true;
					ffc SiyedNPC = Screen->LoadFFC(4);
					SiyedNPC->X = 300;
					ffc Siyed = FindFreeFFC();
					Siyed->Data = 33764;
					Siyed->TileHeight = 2;
					Siyed->X = 128;
					Siyed->Y = 32-16;
					ffc Torrin = FindFreeFFC();
					Torrin->Data = 33292;
					Torrin->TileHeight = 2;
					Torrin->X = 112;
					Torrin->Y = 88-16;
					ffc Kaylani = FindFreeFFC();
					Kaylani->Data = 33300;
					Kaylani->TileHeight = 2;
					Kaylani->X = 128;
					Kaylani->Y = 88-16;
					ffc Asher = FindFreeFFC();
					Asher->Data = 33284;
					Asher->CSet = 6;
					Asher->TileHeight = 2;
					Asher->X = 112;
					Asher->Y = 72-16;
					Fade(false);
					PlayStringAndWait("Siyed? Do you mind telling us what this place actually is?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, 112);
					Siyed->Data++;
					PlayStringAndWait("Right! I never got to that.", SCHAR_SIYED, EMOTE_EXCLAMATION, 64, 112);
					PlayStringAndWait("So I was digging through a bunch of old records in the library. There was one that mentioned a magic power that the astronomers found sealed inside a temple ages ago.", SCHAR_SIYED, EMOTE_NORMAL, 64, 112);
					PlayStringAndWait("I, uh... Well I got tired of feeling useless to the others. But I figured if I could bring that power back, maybe that'd be something.", SCHAR_SIYED, EMOTE_EMBARRASSED, 64, 112);
					// PlayStringAndWait("Useless? Siyed, you're one of the best scholars we have.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, 112);
					// Siyed->Data--;
					// WaitNoAction(30);
					// PlayStringAndWait("I appreciate the encouragement, but we both know there's nothing I can do that anyone else can't. There's a reason your grandma sends you out on missions so much but keeps me back in Hoku.", SCHAR_SIYED, EMOTE_SAD, 64, 112);
					// PlayStringAndWait("That's not the reason at all. It's not like I'm any better. You beat me at sparring all the time.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, 112);
					// PlayStringAndWait("I know you threw those fights to make me feel good, Kay. It was nice... but I'm not a fool.", SCHAR_SIYED, EMOTE_SAD, 64, 112);
					// Siyed->Data++;
					// WaitNoAction(30);
					// PlayStringAndWait("Maybe I can't fight, but I'm done being useless. I figured out where those records were talking about, and now we're here.", SCHAR_SIYED, EMOTE_NORMAL, 64, 112);
					Siyed->Data--;
					WaitNoAction(30);
					PlayStringAndWait("Except the door here is locked too.", SCHAR_SIYED, EMOTE_SAD, 64, 112);
					PlayStringAndWait("Mind if I take a look? I'm good with machinery.", SCHAR_ASHER, EMOTE_NORMAL, 64, 112);
					PlayStringAndWait("Go ahead. There's a mechanism here, but it doesn't seem to connect to anything.", SCHAR_SIYED, EMOTE_NORMAL, 64, 112);
					Asher->Data +=4;
					while(Asher->Y > Siyed->Y){
						Asher->Y--;
						WaitNoAction();
					}
					Asher->Data-=4;
					WaitNoAction(30);
					PlayStringAndWait("What about this?", SCHAR_ASHER, EMOTE_NORMAL, 64, 112);
					Siyed->Data = 33766;
					WaitNoAction(30);
					PlayStringAndWait("I think it's decorative. Unless... unless it's a relay-", SCHAR_SIYED, EMOTE_NORMAL, 64, 112);
					Asher->Data = 33287;
					WaitNoAction(10);
					PlayStringAndWait("-that connects to the wiring in the wall here!", SCHAR_ASHER, EMOTE_EXCLAMATION, 64, 112);
					PlayStringAndWait("Then this bump in the floor could be-", SCHAR_SIYED, EMOTE_EXCLAMATION, 64, 112);
					Torrin->Data = 33295;
					Kaylani->Data = 33302;
					WaitNoAction(30);
					PlayStringAndWait("Well they sure hit it off fast.", SCHAR_TORRIN, EMOTE_NORMAL, 64, 112);
					PlayStringAndWait("I had a feeling they might. Siyed's got that same stupid earnestness as Asher.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, 112);
					PlayStringAndWait("Stupid? I think it's... endearin'.", SCHAR_TORRIN, EMOTE_NORMAL, 64, 112);
					PlayStringAndWait("Never said it wasn't.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, 112);
					Asher->Data = 33285;
					Siyed->Data = 33765;
					WaitNoAction(30);
					Torrin->Data = 33292;
					Kaylani->Data = 33300;
					PlayStringAndWait("We've got it figured out. There's three circuits leading to this door from other parts of the ruins.", SCHAR_ASHER, EMOTE_NORMAL, 64, 112);
					PlayStringAndWait("And three doors in here. Shut doors.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, 112);
					PlayStringAndWait("I've got that one figured out. One of the books talked about three golems animated by meteor fragments. The symbols on the floor make me think there's a connection.", SCHAR_SIYED, EMOTE_NORMAL, 64, 112);
					PlayStringAndWait("So you want us to beat up on some rock monsters? I can get behind this.", SCHAR_TORRIN, EMOTE_NORMAL, 64, 112);
					PlayStringAndWait("We'll be back once we've beaten them.", SCHAR_ASHER, EMOTE_NORMAL, 64, 112);
					PlayStringAndWait("Sounds good. I'll stay here and see what I can learn from the temple until then.", SCHAR_SIYED, EMOTE_NORMAL, 64, 112);
					for(int i = 0; i<90; i++){
						BlackScreenLayerSix();
						if(i == 89){
							Siyed->Data = 0;
							Asher->Data = 0;
							Torrin->Data = 0;
							Kaylani->Data = 0;
							SiyedNPC->X = 160;
							Link->Invisible = false;
							Game->Counter[CR_GOLEMSIDEQUEST] = 2;
						}
						Waitframe();
					}
					this->Data = CMB_AUTOWARPB;
				}
				else if(Game->Counter[CR_GOLEMSIDEQUEST] == 2 && !(G[G_GOLEMFLAG]&1&&G[G_GOLEMFLAG]&2&&G[G_GOLEMFLAG]&4)){
					ffc Siyed = Screen->LoadFFC(4);
					Siyed->Script = 38;
					Siyed->InitD[0] = 75;
					Siyed->Data = 33767;
					Siyed->X = 160;
					Siyed->Y = 16;
				}
			}
			if(Game->GetCurScreen() == 0x3C){
				if(Game->Counter[CR_GOLEMSIDEQUEST] == 2){
					ffc Siyed = FindFreeFFC();
					Siyed->Data = 33764;
					Siyed->TileHeight = 2;
					Siyed->X = 120;
					Siyed->Y = 48;
					while(Link->Y > 128)
						Waitframe();
					Siyed->Data++;
					WaitNoAction(30);
					PlayStringAndWait("There you are! I found out what the power that was sealed here was.", SCHAR_SIYED, EMOTE_NORMAL, 64, 24);
					PlayStringAndWait("You don't look very excited.", SCHAR_KAYLANI, EMOTE_SWEAT, 64, 24);
					PlayStringAndWait("I was hoping it'd be something useful. As it turns out, it's another golem.", SCHAR_SIYED, EMOTE_NORMAL, 64, 24);
					PlayStringAndWait("Another one?", SCHAR_ASHER, EMOTE_QUESTION, 64, 24);
					PlayStringAndWait("This one's different. It looks... strange. I'm wondering if there's something special about it. But I'm afraid to get near it...", SCHAR_SIYED, EMOTE_NORMAL, 64, 24);
					PlayStringAndWait("Hey, you got us this far. We can take care a' this last bit.", SCHAR_TORRIN, EMOTE_NORMAL, 64, 24);
					PlayStringAndWait("And don't you even start complaining that you're being useless. You're not. You guided us here. Let us handle this, Siyed.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, 24);
					PlayStringAndWait("... thanks.", SCHAR_SIYED, EMOTE_EMBARRASSED, 64, 24);
					Game->Counter[CR_GOLEMSIDEQUEST] = 3;
					Siyed->Data = 0;
				}
				if(Game->Counter[CR_GOLEMSIDEQUEST] == 3){
					ffc Siyed = FindFreeFFC();
					Siyed->Data = 33764;
					Siyed->TileHeight = 2;
					Siyed->X = 120;
					Siyed->Y = 48;
					Siyed->Script = 38;
					Siyed->InitD[0] = 75;
				}
			}
			if(Game->GetCurScreen() == 0x2C){
				if(G[G_RANDOMIZERENABLED])
					Quit();
				if(!Screen->State[ST_SECRET]){
					Waitframes(8);
					while(Screen->NumNPCs() > 0)
						Waitframe();
					int Music[256];
					Game->GetDMapMusicFilename(Game->GetCurDMap(), Music);
					Game->PlayEnhancedMusic(Music, 0);
					Fade(true);
					Link->Invisible = true;
					ffc Asher = FindFreeFFC();
					Asher->Data = 33285;
					Asher->CSet = 6;
					Asher->TileHeight = 2;
					Asher->X = 136;
					Asher->Y = 72-16;
					ffc Siyed = FindFreeFFC();
					Siyed->Data = 33764;
					Siyed->TileHeight = 2;
					Siyed->X = 120;
					Siyed->Y = 128-16;
					ffc Torrin = FindFreeFFC();
					Torrin->Data = 33293;
					Torrin->TileHeight = 2;
					Torrin->X = 104;
					Torrin->Y = 72-16;
					ffc Kaylani = FindFreeFFC();
					Kaylani->Data = 33301;
					Kaylani->TileHeight = 2;
					Kaylani->X = 120;
					Kaylani->Y = 72-16;	
					Fade(false);					
					PlayStringAndWait("That was incredible! I've never seen something like it!", SCHAR_SIYED, EMOTE_EXCLAMATION, 64, 24);
					PlayStringAndWait("But there was nothing here besides the golem. All that searching and you're leaving empty-handed.", SCHAR_ASHER, EMOTE_SAD, 64, 24);
					PlayStringAndWait("Empty-handed? Imagine what we could learn from whatever's left of that thing! This was well worth coming!", SCHAR_SIYED, EMOTE_EXCLAMATION, 64, 24);
					PlayStringAndWait("I've got something for you guys, actually. Three augments I found while exploring the ruins.", SCHAR_SIYED, EMOTE_NORMAL, 64, 24);
					Asher->Data += 4;
					while(Asher->Y < Siyed->Y){
						Asher->Y++;
						WaitNoAction();
					}
					Asher->Data = 33286;
					Siyed->Data = 33767;
					WaitNoAction(30);
					PlayStringAndWait("Thanks, Siyed. These'll be really helpful.", SCHAR_ASHER, EMOTE_NORMAL, 64, 24);
					PlayStringAndWait("Don't mention it. But uh... is it just me, or is your foot on something?", SCHAR_SIYED, EMOTE_NORMAL, 64, 24);
					PlayStringAndWait("Is this... a wire running under the ground? What do you think that leads to?", SCHAR_ASHER, EMOTE_NORMAL, 64, 24);
					PlayStringAndWait("Only one way to find out.", SCHAR_SIYED, EMOTE_NORMAL, 64, 24);
					Asher->Data = 33289;
					Siyed->Data = 33771;
					for(int i = 0; i< 16; i++){
						Asher->Y++;
						Siyed->X++;
						WaitNoAction();
					}
					Siyed->Data = 33769;
					while(Siyed->Y < 176){
						Asher->Y++;
						Siyed->Y++;
						WaitNoAction();
					}
					Torrin->Data = 33295;
					Kaylani->Data = 33302;
					WaitNoAction(30);
					PlayStringAndWait("There they go again.", SCHAR_TORRIN, EMOTE_NORMAL, 64, 112);
					PlayStringAndWait("They're like kids, honestly. It's... sweet.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, 112);
					PlayStringAndWait("I know what you mean.", SCHAR_TORRIN, EMOTE_NORMAL, 64, 112);
					// PlayStringAndWait("I think that excitement and sincerity is why I had a crush on Siyed when we were younger.", SCHAR_KAYLANI, EMOTE_EMBARRASSED, 64, 112);
					// PlayStringAndWait("Come again!?", SCHAR_TORRIN, EMOTE_SURPRISED, 64, 112);
					// PlayStringAndWait("What, is it THAT surprising?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, 112);
					// PlayStringAndWait("More surprised you're actually tellin' me. What ever came of it?", SCHAR_TORRIN, EMOTE_NORMAL, 64, 112);
					// PlayStringAndWait("Nothing. I never felt brave enough to tell him. Don't know if he felt the same way. Now it just seems weird to bring up.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, 112);
					// PlayStringAndWait("Uh huh...", SCHAR_TORRIN, EMOTE_NORMAL, 64, 112);
					// if(Game->Counter[CR_STORYFLAG] > SFLAG_POSTGRANDMA){
						// PlayStringAndWait("What I'm getting at is that you should tell Asher sooner rather than later.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, 112);
						// PlayStringAndWait("If you couldn't muster up the courage, what makes ya think I can. ", SCHAR_TORRIN, EMOTE_NORMAL, 64, 112);
						// PlayStringAndWait("You're more reckless than I ever was. You'll blurt it out on a whim sooner or later.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, 112);
						// PlayStringAndWait("We'll see, I guess...", SCHAR_KAYLANI, EMOTE_NORMAL, 64, 112);
					// }
					// else{
						// WaitNoAction(60);
						// PlayStringAndWait("Not too late now, if you still feel that way.", SCHAR_TORRIN, EMOTE_NORMAL, 64, 112);
						// PlayStringAndWait("I'm not sure what I feel anymore. I hardly have time to think about that with everything else going on now. Maybe when everything's done though...", SCHAR_KAYLANI, EMOTE_NORMAL, 64, 112);
					// }
					Fade(true);
					Link->Invisible = false;
					Siyed->Data = 0;
					Asher->Data = 0;
					Torrin->Data = 0;
					Kaylani->Data = 0;
					Fade(false);
					AugmentGet(191);
					AugmentGetYPos(197, 24);
					AugmentGetYPos(202, 48);
					Screen->TriggerSecrets();
					Screen->State[ST_SECRET] = true;
					Game->Counter[CR_GOLEMSIDEQUEST] = 4;
				}
			}
		}
		if(JankSelector == 14){ //Soren sidequest stuff
			if(Game->Counter[CR_MISCSIDEQUEST] == 2){
				ffc Soren = FindFreeFFC();
				if(Game->GetCurScreen() == 0x1C){
					Soren->Data = 33584;
					Soren->X = 120;
					Soren->Y = 172;
					Soren->TileHeight = 2;
					while(Soren->Y > Link->Y - 16){
						Soren->Y -= 1.5;
						WaitNoAction();
					}
					Soren->Data = 33583;
					Link->Dir = DIR_LEFT;
				}
				else{
					Link->Dir = DIR_RIGHT;
					Soren->Data = 33584;
					Soren->X = Link->X+16;
					Soren->Y = Link->Y-16;
					Soren->TileHeight = 2;
				}
				PlayStringAndWait("Asher, there you are!", SCHAR_SOREN, EMOTE_NORMAL, 64, 112);
				PlayStringAndWait("Soren? What are you doing here?", SCHAR_ASHER, EMOTE_SURPRISED, 64, 112);
				PlayStringAndWait("Manch told me he heard rumors about Misty going missing. I had him bring me straight here. Is it true?", SCHAR_SOREN, EMOTE_DISMAYED, 64, 112);
				PlayStringAndWait("It sounds like no one's seen her in a few days.", SCHAR_ASHER, EMOTE_SAD, 64, 112);
				PlayStringAndWait("Well what are you waiting for? Let's find her!", SCHAR_SOREN, EMOTE_NORMAL, 64, 112);
				if(Game->GetCurScreen() == 0x1C){
					Soren->Data = 33586;
					while(Soren->X > -16){
						Soren->X -= 1.5;
						WaitNoAction();
					}
				}
				if(Game->GetCurScreen() == 0x19){
					Soren->Data = 33587;
					while(Soren->X < 256){
						Soren->X += 1.5;
						WaitNoAction();
					}
				}
				if(Game->GetCurScreen() == 0x0B){
					Soren->Data = 33585;
					while(Soren->Y < 176){
						Soren->Y += 1.5;
						WaitNoAction();
					}
				}
				if(Game->GetCurScreen() == 0x4E){
					Soren->Data = 33584;
					while(Soren->Y < 176){
						Soren->Y += 1.5;
						WaitNoAction();
					}
				}
				if(Game->GetCurScreen() == 0x39){
					Soren->Data = 33585;
					while(Soren->Y < 112){
						Soren->Y += 1.5;
						WaitNoAction();
					}
					Soren->Data = 33586;
					while(Soren->X < 256){
						Soren->X += 1.5;
						WaitNoAction();
					}
				}
				Soren->Data = 0;
				WaitNoAction(30);
				PlayStringAndWait("Is he always this... hasty?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, 112);
				PlayStringAndWait("He did run away from home to start a new life on a whim.", SCHAR_ASHER, EMOTE_NORMAL, 64, 112);
				PlayStringAndWait("Your point is taken. Let's see if we can find any leads to Misty's location.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, 112);
				Game->Counter[CR_MISCSIDEQUEST] = 3;
			}
			if(Game->Counter[CR_MISCSIDEQUEST] == 4){
				Link->Dir = DIR_RIGHT;
				ffc Soren = FindFreeFFC();
				Soren->Data = 33586;
				Soren->X = 256;
				Soren->Y = Link->Y-16;
				Soren->TileHeight = 2;
				while(Soren->X > Link->X + 16){
					Soren->X -= 1.5;
					WaitNoAction();
				}
				Soren->Data = 33582;
				WaitNoAction(15);
				PlayStringAndWait("Nobody has any idea where she is...", SCHAR_SOREN, EMOTE_SAD, 64, 24);
				PlayStringAndWait("I've got a lead. Someone saw one of the rich people here kidnap her!", SCHAR_ASHER, EMOTE_NORMAL, 64, 24);
				PlayStringAndWait("What!? Why would they do that!?", SCHAR_SOREN, EMOTE_SURPRISED, 64, 24);
				PlayStringAndWait("I don't know, but I know where she probably went.", SCHAR_ASHER, EMOTE_NORMAL, 64, 24);
				PlayStringAndWait("Good enough for me! I'll meet you in the boat!", SCHAR_SOREN, EMOTE_NORMAL, 64, 24);
				Soren->Data = 33587;
				while(Soren->X < 256){
					Soren->X += 1.5;
					WaitNoAction();
				}
				Soren->Data = 0;
				Game->Counter[CR_MISCSIDEQUEST] = 5;
			}
		}
		if(JankSelector == 15){ //More Soren stuff, isolated here just in case
			if(Game->GetCurScreen() == 0x78){
				if(Game->Counter[CR_MISCSIDEQUEST] < 5){
					mapdata l1 = Game->LoadTempScreen(1);
					for(int i = 0; i < 16; i++)
						l1->ComboD[i] = 1;
				}
				if(Game->Counter[CR_MISCSIDEQUEST] == 5){
					Game->PlayMIDI(0);
					ffc Soren = FindFreeFFC();
					Soren->TileHeight = 2;
					Soren->Data = 33580;
					Soren->X = 115;
					Soren->Y = 112;
					ffc Pirate = FindFreeFFC();
					Pirate->TileHeight = 2;
					Pirate->Data = 33773;
					Pirate->X = 120;
					Pirate->Y = 80;
					Link->Dir = DIR_UP;
					WaitNoAction(60);
					PlayStringAndWait("Stop right there. What business d'ya have at Villa Tulane?", SCHAR_PIRATE, EMOTE_NORMAL, 64, 24);
					PlayStringAndWait("You have my sister here, don't you!?", SCHAR_SOREN, EMOTE_ANGRY, 64, 24);
					PlayStringAndWait("The dealin's of Madama Tulane ain't any a' yer bus-", SCHAR_PIRATE, EMOTE_NORMAL, 64, 24);
					Soren->Data = 33584;
					int playflag;
					while(Soren->Y > 87){
						if(playflag == 0 && Soren->Y < 104){
							Game->PlaySound(30);
							Soren->Data = 33780;
							playflag = 1;
						}
						Soren->Y -= 2;
						WaitNoAction();
					}
					Pirate->Data = 33784;
					Game->PlaySound(106);
					WaitNoAction(45);
					while(Pirate->Y > -32){
						Pirate->Y-=8;
						WaitNoAction();
					}
					WaitNoAction(30);
					Game->PlaySound(3);
					for(int i = 0; i<30; i++){
						Screen->Quake = 1;
						WaitNoAction();
					}
					Screen->Quake = 0;
					Soren->Data = 33580;
					WaitNoAction(30);
					Soren->Data = 33581;
					PlayStringAndWait("What are you waiting for? Let's go!", SCHAR_SOREN, EMOTE_EXCLAMATION, 64, 24);
					Game->Counter[CR_MISCSIDEQUEST] = 6;
					this->Data = CMB_AUTOWARPD;
				}
			}
			if(Game->GetCurScreen() == 0x5A && Game->Counter[CR_MISCSIDEQUEST] == 6){
				// SetCharacter(CHAR_ASHER, false);
				ffc Soren = FindFreeFFC();
				Soren->TileHeight = 2;
				Soren->Data = 33584;
				Soren->X = -32;
				Soren->Y = -32;
				ffc Pirate1 = FindFreeFFC();
				Pirate1->TileHeight = 2;
				Pirate1->Data = 33775;
				Pirate1->X = 104;
				Pirate1->Y = 40;
				ffc Pirate2 = FindFreeFFC();
				Pirate2->TileHeight = 2;
				Pirate2->Data = 33774;
				Pirate2->X = 152;
				Pirate2->Y = 40;
				ffc Tulane = FindFreeFFC();
				Tulane->TileHeight = 2;
				Tulane->Data = 33332;
				Tulane->X = 128;
				Tulane->Y = 64;
				ffc Misty = FindFreeFFC();
				Misty->TileHeight = 2;
				Misty->Data = 33501;
				Misty->X = 128;
				Misty->Y = 30;
				for(int i = 0; i<60; i++){
					WaitNoAction();
				}
				Soren->X = Link->X;
				Soren->Y = Link->Y;
				PlayStringAndWait("For the last time, tell me why Igorevich sent you!", SCHAR_TULANE, EMOTE_FURIOUS, 64, 112);
				PlayStringAndWait("I told you, I don't know what you're talking about!", SCHAR_MISTY, EMOTE_DISMAYED, 64, 112);
				while(Link->Y > 96){
					NoInput();
					Link->InputUp = true;
					Link->PressUp = true;
					Soren->Y = Link->Y;
					Waitframe();	
				}
				Soren->Data = 33587;
				while(Link->X > 112){
					NoInput();
					Link->InputLeft = true;
					Link->PressLeft = true;
					Soren->X+=1.5;
					Waitframe();
				}
				Link->Dir = DIR_UP;
				Link->Action = LA_ATTACKING;
				WaitNoAction();
				Link->Action = LA_NONE;
				while(Soren->X < 128){
					Soren->X++;
					WaitNoAction();
				}
				Soren->Data = 33584;
				while(Soren->Y > 80){
					Soren->Y--;
					WaitNoAction();
				}
				Soren->Data = 33580;
				Pirate1->Data = 33773;
				WaitNoAction(60);
				PlayStringAndWait("Uh, boss...", SCHAR_PIRATE, EMOTE_EXCLAMATION, 64, 112);
				Tulane->Data++;
				Pirate2->Data = 33773;
				WaitNoAction(30);
				PlayStringAndWait("Intruders!? How did you make it past the guards!?", SCHAR_TULANE, EMOTE_EXCLAMATION, 64, 112);
				PlayStringAndWait("Soren!", SCHAR_MISTY, EMOTE_SURPRISED, 64, 112);
				PlayStringAndWait("You better unhand my sister right now, or I'll throw you out that window into the ocean.", SCHAR_SOREN, EMOTE_ANGRY, 64, 112);
				PlayStringAndWait("Oh, more of Igorevich's spies. I should have suspected.", SCHAR_TULANE, EMOTE_SURPRISED, 64, 112);
				PlayStringAndWait("Whoa whoa whoa, hold on. We're not allied with Igorevich. And neither is Misty.", SCHAR_ASHER, EMOTE_EXCLAMATION, 64, 112);
				PlayStringAndWait("Then why did I find her snooping around my house?", SCHAR_TULANE, EMOTE_SURPRISED, 64, 112);
				PlayStringAndWait("She has an... unfortunate habit involving pianos.", SCHAR_ASHER, EMOTE_SWEAT, 64, 112);
				PlayStringAndWait("Do you expect me to believe such a bad cover?", SCHAR_TULANE, EMOTE_NORMAL, 64, 112);
				PlayStringAndWait("Do you expect Igorevich to send in someone with that bad a cover?", SCHAR_ASHER, EMOTE_NORMAL, 64, 112);
				PlayStringAndWait("... I see.", SCHAR_TULANE, EMOTE_ELLIPSES, 64, 112);
				PlayStringAndWait("You mean to tell me you kidnapped my sister cuz you thought she was working for your business rival?", SCHAR_SOREN, EMOTE_SURPRISED, 64, 112);
				PlayStringAndWait("In hindsight, it does seem rather silly, but Igorevich is not above stooping to such lows.", SCHAR_TULANE, EMOTE_NORMAL, 64, 112);
				PlayStringAndWait("We're aware of the kind of man he is. But kidnapping?", SCHAR_ASHER, EMOTE_NORMAL, 64, 112);
				WaitNoAction(120);
				PlayStringAndWait("I don't suppose you would all be willing to overlook this affair.", SCHAR_TULANE, EMOTE_NORMAL, 64, 112);
				PlayStringAndWait("If you think I'm about to-", SCHAR_SOREN, EMOTE_ANGRY, 64, 112);
				PlayStringAndWait("Hold your tongue for a moment. You two are from the lower tier, yes? Your sister clearly doesn't have everything she wants at home. And judging from your attire, you've sought employment with those peasant fishers from Malka. Am I wrong?", SCHAR_TULANE, EMOTE_NORMAL, 64, 112);
				PlayStringAndWait("Peasant fishers? Now wait just a-", SCHAR_TORRIN, EMOTE_ANGRY, 64, 112);
				PlayStringAndWait("I'll take your silence and your friend's outrage as a confirmation.", SCHAR_TULANE, EMOTE_NORMAL, 64, 112);
				Tulane->Data = 33337;
				while(Tulane->Y < Soren->Y - 12){
					Tulane->Y+=0.75;
					WaitNoAction();
				}
				Tulane->Data = 33333;
				WaitNoAction(60);
				PlayStringAndWait("These pearls are worth more than you'll make in your entire life. Take them and buy yourself and your sister a life of middle class luxury. Then, let's both pretend this whole incident never happened. Do we have a deal?", SCHAR_TULANE, EMOTE_NORMAL, 64, 112);
				PlayStringAndWait("... I don't like you, but I'm not about to turn down that kind of wealth.", SCHAR_SOREN, EMOTE_NORMAL, 64, 112);
				PlayStringAndWait("Excellent. Guards, if you could please escort these children back to the docks.", SCHAR_TULANE, EMOTE_NORMAL, 64, 112);
				Game->Counter[CR_MISCSIDEQUEST] = 7;
				this->Data = CMB_AUTOWARPA;				
			}
			if(Game->GetCurScreen() == 0x4E && Game->Counter[CR_MISCSIDEQUEST] == 7){
				Link->Dir = DIR_UP;
				ffc Soren = FindFreeFFC();
				Soren->TileHeight = 2;
				Soren->Data = 33581;
				Soren->X = 104;
				Soren->Y = 72;
				ffc Misty = FindFreeFFC();
				Misty->TileHeight = 2;
				Misty->Data = 33501;
				Misty->X = 120;
				Misty->Y = 72;
				WaitNoAction(30);
				PlayStringAndWait("I can't thank you enough, Asher. I owe ya big time.", SCHAR_SOREN, EMOTE_NORMAL, 64, 24);
				PlayStringAndWait("Don't worry about it. I'm just happy Misty's safe. Are you gonna stay home now?", SCHAR_ASHER, EMOTE_NORMAL, 64, 24);
				PlayStringAndWait("That's a good question. I don't know... Probably not forever, but catching up with Misty and Dylan for a bit sounds nice. And using some of this money to renovate the house might be nice.", SCHAR_SOREN, EMOTE_NORMAL, 64, 24);
				PlayStringAndWait("Look, it's not much, but I want you to have this augment. Hardly covers everything, but it's the least I can do. And if you need anything, drop me a line. I'll come running.", SCHAR_SOREN, EMOTE_NORMAL, 64, 24);
				Soren->Data = 33584;
				Misty->Data = 33504;
				while(Soren->Y > -32){
					Soren->Y--;
					Misty->Y--;
					WaitNoAction();
				}
				AugmentGet(189);
				Game->Counter[CR_MISCSIDEQUEST] = 8;
				Soren->Data = 0;
				Misty->Data = 0;
			}
			if(Game->GetCurScreen() == 0x1C && Game->Counter[CR_MISCSIDEQUEST] == 8){
				Screen->SetTileWarp(0, 0x47, 4, WT_IWARPBLACKOUT);
			}
		}
		if(JankSelector == 16){ //One more Soren quest thing
			if(Game->Counter[CR_MISCSIDEQUEST] == 3){
				if(!(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_6)){
					Waitframes(45);
					PlayStringAndWait("Hey, there's a piano. Maybe she came here to play it?", SCHAR_TORRIN, EMOTE_NORMAL, 64, 24);
					PlayStringAndWait("It is an empty house with a piano... Maybe one of the neighbors saw her?", SCHAR_ASHER, EMOTE_NORMAL, 64, 24);
					Game->Counter[CR_SMALLSIDEQUESTS1] |= BF_6;
				}
			}
		}
		if(JankSelector == 17){ //Golem trigger
			Waitframes(4);
			while(Screen->NumNPCs()>0){
				Waitframe();
			}
			if(Game->GetCurScreen()==0x4D){
				G[G_GOLEMFLAG] |= 8;
			}
			else if(Game->GetCurScreen()==0x7B){
				G[G_GOLEMFLAG] |= 16;
				
			}
			else if(Game->GetCurScreen()==0x2F){
				G[G_GOLEMFLAG] |= 32;
			}
		}
		if(JankSelector == 18){ //Truf wild goose chase markers
			if(SidequestProgress(QST_VOLCANO)==1&&!(G[G_TRUFQUESTFLAGS]&d1)){
				while(true){
					if(G[G_ANIM]%60==0)
						ParticleAnim(this->X+Rand(-8, 8), this->Y+Rand(-8, 8), 968, 8, 8, 5);
					if(Distance(this->X, this->Y, Link->X, Link->Y)<8){
						if(d1==16){
							if(Link->Action==LA_DIVING)
								break;
						}
						else
							break;
					}
					Waitframe();
				}
				G[G_TRUFQUESTFLAGS] |= d1;
				PopupNotify(4);
			}
		}
		if(JankSelector == 19){ //Magnet was a mistake
			//THE JANK GROWS
			//WITH EACH ITERATION IT BECOMES MORE BLOATED
			//MORE ENGORGED ON HARDCODES
			//THE SCRIPT FILE WRITHES AND TURNS
			//SCRIPTS BEING WRITTEN AND REWRITTEN
			//BUT NO LONGER WILL I FALL DOWN THOSE GODDAMN CLIFFS BY ACCIDENT AND HAVE TO WALK LIKE TWO WHOLE SCREENS TO GET BACK UP
			//I'M GLAD IT TURNED OUT THIS WAY
			//SEE YOU NEXT BUGFIX
			bool fallDown2[176];
			int bridgeCombos2[176];
			mapdata bridgeLayer2 = Game->LoadTempScreen(2);
			bool fallDown4[176];
			int bridgeCombos4[176];
			mapdata bridgeLayer4 = Game->LoadTempScreen(4);
			for(int i=0; i<176; ++i){
				if(bridgeLayer2->ComboT[i]==CT_BRIDGE&&bridgeLayer2->ComboD[i]!=27829){ //This exception still lives to the new one though...
					fallDown2[i] = true;
					bridgeCombos2[i] = bridgeLayer2->ComboD[i];
				}
				if(bridgeLayer4->ComboT[i]==CT_BRIDGE&&bridgeLayer4->ComboD[i]!=27829){ //This exception still lives to the new one though...
					fallDown4[i] = true;
					bridgeCombos4[i] = bridgeLayer4->ComboD[i];
				}
			}
			int fV[2];
			while(true){
				while(Link->Z<=0){
					for(int i=0; i<176; ++i){
						if(fallDown2[i]){
							bridgeLayer2->ComboD[i] = 0;
						}
						if(fallDown4[i]){
							bridgeLayer4->ComboD[i] = 0;
						}
					}
					Waitframe();
				}
				while(Link->Z>0){
					for(int i=0; i<176; ++i){
						if(fallDown2[i]){
							bridgeLayer2->ComboD[i] = bridgeCombos2[i];
						}
						if(fallDown4[i]){
							bridgeLayer4->ComboD[i] = bridgeCombos4[i];
						}
					}
					Waitframe();
				}
				GetFallingJankVel(fV);
				if(fV[0]!=0||fV[1]!=0){
					Game->PlaySound(38);
					int vel = 0;
					int tempVel;
					while(fV[0]!=0||fV[1]!=0){
						if(vel < TERMINAL_VELOCITY)
							vel+=GRAVITY;
						tempVel += vel;
						if(tempVel>=1){
							for(int i=0; i<Floor(tempVel); ++i){
								GetFallingJankVel(fV);
								if(fV[0]==0&&fV[1]==0)
									break;
								else{
									Link->X += fV[0];
									Link->Y += fV[1];
								}
							}
							tempVel -= Floor(tempVel);
						}
						WaitNoAction();
					}
				}
			}
			
			// mapdata l2 = Game->LoadTempScreen(2);
			// while(true){
				// if(Link->Z == 0 && l2->ComboT[ComboAt(Link->X+8, Link->Y+12)] == CT_BRIDGE && l2->ComboD[ComboAt(Link->X+8, Link->Y+12)] != 27829){ //That hardcoded exception is an actual bridge combo, that was used on the same screen as my janky bridge combos to mark fall down walls shenanigans and played a sound effect when you stepped off it.
					// Game->PlaySound(38);
					// int vel = 0;
					// int cmb;
					// while(true){
						// if(vel < TERMINAL_VELOCITY)
							// vel+=GRAVITY;
						// cmb = Screen->ComboD[ComboAt(Link->X+8, Link->Y+12)];
						// if(cmb == 5713 || cmb == 5704 || cmb == 5709 || cmb == 5706 || cmb == 5708 || cmb == 5710 || cmb == 5714 || cmb == 41222 || cmb == 24405 || cmb == 24429 || cmb == 24406)
							// Link->Y+=vel;
						// else if(cmb == 5685 || cmb == 5680 || cmb == 5683 || cmb == 5672 || cmb == 41223 || cmb == 5679 || cmb == 24436 || cmb == 24441)
							// Link->Y-=vel;
						// else if(cmb == 5207 || cmb == 5726 || cmb == 24434 || cmb == 24411)
							// Link->X-=vel;
						// else if(cmb == 5204 || cmb == 5725 || cmb == 24423 || cmb == 24432 || cmb == 24408 || cmb == 24412)
							// Link->X+=vel;
						// else
							// break;
						// WaitNoAction();
					// }
				// }
				// Waitframe();
			// }
		}
		if(JankSelector == 20){ //This one is a new low for me
			while(true){
				if(LinkCollision(this) && G[G_OVERUNDERLAYER] == 1){
					SetLayerComboD(3, ComboAt(160, 96), 9822);
					SetLayerComboD(1, ComboAt(64, 16), 491);
				}
				Waitframe();
			}
		}
		if(JankSelector == 21){ //Jank comes in pairs
			while(true){
				if(LinkCollision(this) && G[G_OVERUNDERLAYER] == 1){
					SetLayerComboD(3, ComboAt(160, 96), 0);
					SetLayerComboD(1, ComboAt(64, 16), 0);
				}
				Waitframe();
			}
		}
		if(JankSelector == 22){ //Why did I hard code this?
			while(true){
				if(LinkCollision(this) && G[G_OVERUNDERLAYER] == 1){
					SetLayerComboD(3, ComboAt(112, 80), 9741);
				}
				Waitframe();
			}
		}
		if(JankSelector == 23){ //Ick. Whatever.
			while(true){
				if(LinkCollision(this) && G[G_OVERUNDERLAYER] == 1){
					SetLayerComboD(3, ComboAt(112, 80), 0);
				}
				Waitframe();
			}
		}
		if(JankSelector == 24){
			mapdata l1 = Game->LoadTempScreen(1);
			while(true){
				if(Screen->State[ST_SECRET] == true){
					if(G[G_OVERUNDERLAYER] == 1){
						if(l1->ComboD[ComboAt(64, 128)] != 38439)
							l1->ComboD[ComboAt(64, 128)] = 38439;
					}
					else{
						if(l1->ComboD[ComboAt(64, 128)] != 38445)
							l1->ComboD[ComboAt(64, 128)] = 38445;
					}
				}
				Waitframe();
			}
		}
		if(JankSelector == 25){ //The room with the enemies that fall from the ceiling in the Mist Temple
			while(true){
				if(Distance(Link->X, Link->Y, this->X, this->Y) <= 4){
					Screen->ComboD[ComboAt(this->X, this->Y)]++;
					Game->PlaySound(68);
					Screen->ComboD[ComboAt(176, 112)] = 29716;
					Screen->ComboD[ComboAt(192, 112)] = 29716;
					for(int i=0; i<3; i++){
						int pos = Switch_GetSpawnPos();
						npc n = CreateNPCAt(54, ComboX(pos), ComboY(pos));
						Game->PlaySound(SFX_FALL);
						n->Z = 176;
						Waitframes(20);
					}
					while(Screen->NumNPCs() > 0)
						Waitframe();
					Screen->TriggerSecrets();
					Screen->State[ST_SECRET] = true;
					Game->PlaySound(SFX_SECRET);
					Quit();
				}
				Waitframe();
			}
		}
		if(JankSelector == 26){
			if(!(Game->Counter[CR_MISTFLAGS] & BF_0)){
				SetCutsceneSkip(CUTSCENE_POHO1A);
				WaitNoAction(30);
				PlayStringAndWait("Hold up, I can 'ear someone coming'.", SCHAR_PIRATE, EMOTE_NORMAL, 64, 112);
				while(!WalkLinkToPoint(112, 104)){
					Waitframe();
				}
				while(!WalkLinkToPoint(112, 120)){
					Waitframe();
				}
				while(!WalkLinkToPoint(176, 120)){
					Waitframe();
				}
				while(!WalkLinkToPoint(176, 80)){
					Waitframe();
				}
				if(Game->Counter[CR_MISCSIDEQUEST] == 8){
					PlayStringAndWait("You again.", SCHAR_ASHER, EMOTE_NORMAL, 64, 112);
					PlayStringAndWait("Well now. It seems I must bargain with the peasants once more. Igorevich has seen fit to make a complete laughing stock of me.", SCHAR_TULANE, EMOTE_NORMAL, 64, 112);
				}
				else{
					PlayStringAndWait("You... you're the merchant woman from earlier.", SCHAR_ASHER, EMOTE_NORMAL, 64, 112);
					PlayStringAndWait("Indeed. Stuck in a cage along with my bodyguards. Igorevich has seen fit to make a complete laughing stock of me.", SCHAR_TULANE, EMOTE_NORMAL, 64, 112);
				}
				PlayStringAndWait("What's wrong with the door right behind ya?", SCHAR_TORRIN, EMOTE_NORMAL, 64, 112);
				PlayStringAndWait("The mist below is... dangerous. I can feel it sapping the life force from my body.", SCHAR_TULANE, EMOTE_NORMAL, 64, 112);
				PlayStringAndWait("An' there's things down there in the mist. Things ya can't fight. The mist keeps you from even lifting your blade!", SCHAR_PIRATE, EMOTE_DISMAYED, 64, 112);
				PlayStringAndWait("There's a switch in here, but it seems you need someone with stellar magic to activate it. If I could trouble you to make the trip around, I could make it worth your while.", SCHAR_TULANE, EMOTE_NORMAL, 64, 112);
				PlayStringAndWait("Are you trying to bribe us to help you?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, 112);
				PlayStringAndWait("I'm saying I have a key here, but it won't slip through the bars, so if you want it, you'll need to help us out.", SCHAR_TULANE, EMOTE_NORMAL, 64, 112);
				PlayStringAndWait("We'd of helped anyhow. Probably.", SCHAR_TORRIN, EMOTE_ELLIPSES, 64, 112);
				Game->Counter[CR_MISTFLAGS] |= BF_0;
				SetCutsceneSkip(CUTSCENE_NULL); //CUTSCENE_POHO1A
				
			}
			if(Distance(Link->X, Link->Y, 200, 32) < 4 && !(Game->Counter[CR_MISTFLAGS] & BF_1)){
				SetCutsceneSkip(CUTSCENE_POHO1B);
				ffc f = Screen->LoadFFC(2);
				f->Data = 33335;
				WaitNoAction(30);
				PlayStringAndWait("You made it!", SCHAR_PIRATE, EMOTE_NORMAL, 64, 112);
				while(!WalkLinkToPoint(192, 32)){
					Waitframe();
				}
				while(!WalkLinkToPoint(192, 48)){
					Waitframe();
				}
				while(!WalkLinkToPoint(160, 48)){
					Waitframe();
				}
				while(!WalkLinkToPoint(160, 32)){
					Waitframe();
				}
				Link->Dir = DIR_RIGHT;
				f->Data = 33334;
				PlayStringAndWait("It appears I owe you a great debt. I don't have many liquid assets on me, but I have the key, as promised.", SCHAR_TULANE, EMOTE_NORMAL, 64, 112);
				CreateItemAt(84, Link->X, Link->Y);
				Screen->State[ST_ITEM] = true;
				Game->Counter[CR_MISTFLAGS] |= BF_1;
				PlayStringAndWait("Thank you. Can you make your way back to the entrance from here?", SCHAR_ASHER, EMOTE_NORMAL, 64, 112);
				PlayStringAndWait("My men are bruised, but not deathly ill. We can manage from here. Thank you.", SCHAR_TULANE, EMOTE_NORMAL, 64, 112);
				f = Screen->LoadFFC(1);
				f->Data = 0;
				f = Screen->LoadFFC(2);
				f->Data = 0;
				f = Screen->LoadFFC(3);
				f->Data = 0;
				SetCutsceneSkip(CUTSCENE_POHO1B); //CUTSCENE_POHO1B
				for(int i = 0; i<60; i++){
					BlackScreenLayerSix();
					WaitNoAction();
				}
			}
			if(Game->Counter[CR_MISTFLAGS] & BF_1){
				ffc f = Screen->LoadFFC(1);
				f->Data = 0;
				f = Screen->LoadFFC(2);
				f->Data = 0;
				f = Screen->LoadFFC(3);
				f->Data = 0;
			}
		}
		if(JankSelector == 27){
			if(!(Game->Counter[CR_MISTFLAGS] & BF_2)){
				SetCutsceneSkip(CUTSCENE_POHO2A);
				WaitNoAction(30);
				PlayStringAndWait("Well... this sure ain't how I pictured the end looking.", SCHAR_KENJA, EMOTE_SAD, 64, 112);
				PlayStringAndWait("Kenja? Is that you?", SCHAR_TORRIN, EMOTE_SURPRISED, 64, 112);
				while(!WalkLinkToPoint(136, 80)){
					Waitframe();
				}
				ffc f = Screen->LoadFFC(1);
				f->Data++;
				PlayStringAndWait("Torrin!? You're alright!? Are your friends with you?", SCHAR_KENJA, EMOTE_SURPRISED, 64, 112);
				PlayStringAndWait("We're safe for the moment. What about you?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, 112);
				PlayStringAndWait("Wish I could say the same. Those goons smashed my leg up pretty bad. Can't do much aside from limp. I got the door to close behind me, but I got myself cornered, it looks like.", SCHAR_KENJA, EMOTE_NORMAL, 64, 112);
				PlayStringAndWait("Hang tight and keep that door shut! We'll take care of Selet's lackies!", SCHAR_TORRIN, EMOTE_NORMAL, 64, 112);
				PlayStringAndWait("Be careful! The mist... it does something to ya. Keeps ya from lifting a fist to defend yourself.", SCHAR_KENJA, EMOTE_NORMAL, 64, 112);
				PlayStringAndWait("I ain't about to let some mist keep me from knockin' some skulls and bailin' you out. Just wait for us!", SCHAR_TORRIN, EMOTE_NORMAL, 64, 112);
				Game->Counter[CR_MISTFLAGS] |= BF_2;
				SetCutsceneSkip(CUTSCENE_NULL); //CUTSCENE_POHO2A
			}
			if(Screen->State[ST_SECRET] && !(Game->Counter[CR_MISTFLAGS] & BF_3)){
				SetCutsceneSkip(CUTSCENE_POHO2B);
				ffc f = Screen->LoadFFC(1);
				f->X = 144;
				f->Y = 16;
				f->Data+=2;
				while(!WalkLinkToPoint(120, 32)){
					Waitframe();
				}
				Link->Dir = DIR_RIGHT;
				PlayStringAndWait("Well I'll be... Looks like I owe ya one, Torrin.", SCHAR_KENJA, EMOTE_SURPRISED, 64, 112);
				PlayStringAndWait("Nah, just payin' ya back for all the times ya bailed me out. Can ya make it back to the entrance?", SCHAR_TORRIN, EMOTE_WINK, 64, 112);
				PlayStringAndWait("As long as there's no more goons along the way, I think so. Should be easier with that cage lowerin' as well. Thanks, mate.", SCHAR_KENJA, EMOTE_NORMAL, 64, 112);
				//PlayStringAndWait("As long as there's no more goons along the way, I think so. Should be easier with that barrier vanishin' as well. Thanks, mate.", SCHAR_KENJA, EMOTE_NORMAL, 64, 112);
				f->Data = 0;
				for(int i = 0; i<60; i++){
					//BlackScreenLayerSeven();
					G[G_BLACKOUTLAYER7] = 128;
					WaitNoAction();
				}
				Game->Counter[CR_MISTFLAGS] |= BF_3;
				SetCutsceneSkip(CUTSCENE_NULL); //CUTSCENE_POHO2B
			}
			if(Game->Counter[CR_MISTFLAGS] & BF_3){
				ffc f = Screen->LoadFFC(1);
				f->Data = 0;
			}
		}
		if(JankSelector == 28){
			if(!(Game->Counter[CR_MISTFLAGS] & BF_4)){
				while(!Screen->State[ST_SECRET])
					Waitframe();
				SetCutsceneSkip(CUTSCENE_POHO3);
				ffc f = Screen->LoadFFC(1);
				f->Data +=2;
				f = Screen->LoadFFC(2);
				f->Data++;
				PlayStringAndWait("Torrin? Is that you?", SCHAR_SKAI, EMOTE_SURPRISED, 64, 112);
				PlayStringAndWait("Kaylani? You're alright?", SCHAR_NELL, EMOTE_SURPRISED, 64, 112);
				PlayStringAndWait("We're fine. What about you, though?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, 112);
				PlayStringAndWait("None of us are in any fighting shape. Igorevich's men separated us and chased us into the mist. I've been holding it off with my lunar magic as best I can... but I was nearly at my limit.", SCHAR_SKAI, EMOTE_DISMAYED, 64, 112);
				PlayStringAndWait("We should be able to make it to the entrance, now that the path is clear. Thank you.", SCHAR_MORT, EMOTE_NORMAL, 64, 112);
				f = Screen->LoadFFC(1);
				f->Data = 0;
				f = Screen->LoadFFC(2);
				f->Data = 0;
				f = Screen->LoadFFC(3);
				f->Data = 0;
				mapdata l4 = Game->LoadTempScreen(4);
				for(int i=0; i<176; ++i){
					if(l4->ComboF[i]==108)
						l4->ComboF[i] = 105;
				}
				for(int i = 0; i<60; i++){
					//BlackScreenLayerSeven();
					G[G_BLACKOUTLAYER7] = 128;
					WaitNoAction();
				}
				Game->Counter[CR_MISTFLAGS] |= BF_4;
				if(Game->Counter[CR_MISTFLAGS] & BF_4 && Game->Counter[CR_MISTFLAGS] & BF_5){
					PlayStringAndWait("I think that's everyone now. We should check how Siyed's doing with the door.", SCHAR_ASHER, EMOTE_NORMAL, 64, 112);
				}
				SetCutsceneSkip(CUTSCENE_NULL); //CUTSCENE_POHO3
			}
			else{
				ffc f = Screen->LoadFFC(1);
				f->Data = 0;
				f = Screen->LoadFFC(2);
				f->Data = 0;
				f = Screen->LoadFFC(3);
				f->Data = 0;
				mapdata l4 = Game->LoadTempScreen(4);
				for(int i=0; i<176; ++i){
					if(l4->ComboF[i]==108)
						l4->ComboF[i] = 105;
				}
			}
		}
		if(JankSelector == 29){
			if(G[G_RANDOMIZERENABLED]){
				Screen->ComboD[39] = 53940;
				Screen->ComboD[40] = 53940;
				if(!Screen->State[ST_SECRET]){
					Waitframe();
					CreateNPCAt(186, 112, 64);
					CreateNPCAt(188, 120, 64);
					CreateNPCAt(211, 64, 16);
					CreateNPCAt(211, 176, 16);
					while(Screen->NumNPCs() > 0)
						Waitframe();
					Screen->TriggerSecrets();
					Screen->State[ST_SECRET] = true;
					Quit();
				}
			}
			if(!(Game->Counter[CR_MISTFLAGS] & BF_5)){
				ffc Allie = FindFreeFFC();
				Allie->X = 128;
				Allie->Y = 16;
				Allie->TileHeight = 2;
				Allie->Data = 33724;
				ffc Band = FindFreeFFC();
				Band->X = 112;
				Band->Y = 16;
				Band->TileHeight = 2;
				Band->Data = 33732;
				ffc Goon1 = FindFreeFFC();
				Goon1->X = 112;
				Goon1->Y = 64;
				Goon1->TileHeight = 2;
				Goon1->Data = 33652;
				ffc Goon2 = FindFreeFFC();
				Goon2->X = 128;
				Goon2->Y = 64;
				Goon2->TileHeight = 2;
				Goon2->Data = 33652;
				ffc Goon3 = FindFreeFFC();
				Goon3->X = 64;
				Goon3->Y = 16;
				Goon3->TileHeight = 2;
				Goon3->Data = 33671;
				ffc Goon4 = FindFreeFFC();
				Goon4->X = 176;
				Goon4->Y = 16;
				Goon4->TileHeight = 2;
				Goon4->Data = 33670;
				Waitframes(60);
				PlayStringAndWait("Well, Band, we put up a good fight.", SCHAR_ALLIE, EMOTE_NORMAL, 64, 112);
				PlayStringAndWait("I can't think of anyone I'd rather go down fighting with. Let's see if we can't down a few more.", SCHAR_BAND, EMOTE_NORMAL, 64, 112);
				PlayStringAndWait("Allie!", SCHAR_KAYLANI, EMOTE_SURPRISED, 64, 112);
				PlayStringAndWait("Kaylani!? How the- nevermind, no time. Help us out with these fiends!", SCHAR_ALLIE, EMOTE_SURPRISED, 64, 112);
				CreateNPCAt(186, 112, 64);
				CreateNPCAt(188, 120, 64);
				CreateNPCAt(211, 64, 16);
				CreateNPCAt(211, 176, 16);
				Goon1->Data = 0;
				Goon2->Data = 0;
				Goon3->Data = 0;
				Goon4->Data = 0;
				while(Screen->NumNPCs() > 0)
					Waitframe();
				SetCutsceneSkip(CUTSCENE_POHO4);
				Allie->Data = 33785;
				Band->Data = 33786;
				Link->X = 120;
				Link->Y = 80;
				Link->Dir = DIR_UP;
				for(int i = 0; i<60; i++){
					G[G_BLACKOUTLAYER7] = 128;
					//BlackScreenLayerSeven();
					WaitNoAction();
				}
				PlayStringAndWait("You made it just in time. The two of us fought off Igorevich's men for hours. But separated from everyone else...", SCHAR_ALLIE, EMOTE_NORMAL, 64, 112);
				PlayStringAndWait("Wasn't expecting to survive that one. Not sure my arm's ever gonna recover from this, but that's the least of our problems. How's the head wound, Allie?", SCHAR_BAND, EMOTE_NORMAL, 64, 112);
				PlayStringAndWait("Still dizzy, but I can stand, at least. We need to regroup and replan. I hate to ask, Kaylani, but can you find the rest of the team?", SCHAR_ALLIE, EMOTE_NORMAL, 64, 112);
				PlayStringAndWait("We've already found several. We'll meet you back at the entrance once we've rescued everyone.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, 112);
				PlayStringAndWait("I think I've been underestimating you. Good work, Kaylani.", SCHAR_ALLIE, EMOTE_NORMAL, 64, 112);
				Allie->Data = 0;
				Band->Data = 0;
				for(int i = 0; i<60; i++){
					G[G_BLACKOUTLAYER7] = 128;
					//BlackScreenLayerSeven();
					WaitNoAction();
				}
				Game->Counter[CR_MISTFLAGS] |= BF_5;
				Screen->TriggerSecrets();
				Screen->State[ST_SECRET] = true;
				if(Game->Counter[CR_MISTFLAGS] & BF_4 && Game->Counter[CR_MISTFLAGS] & BF_5){
					PlayStringAndWait("I think that's everyone now. We should check how Siyed's doing with the door.", SCHAR_ASHER, EMOTE_NORMAL, 64, 112);
				}
				SetCutsceneSkip(CUTSCENE_NULL); //CUTSCENE_POHO4
			}
		}
		if(JankSelector == 30){
			if(Game->Counter[CR_STORYFLAG] >= SFLAG_POSTGRANDMA){
				Screen->TriggerSecrets();
				Screen->State[ST_SECRET] = true;
			}
		}
		if(JankSelector == 31){ //Pirate Quest Secrets Trigger
			if(Game->Counter[CR_STORYFLAG]<SFLAG_ASHERRESCUED){
				Screen->TriggerSecrets();
			}
			else if(!(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_10)){
				Waitframes(30);
				SuspendGhostZHScripts();
				KillEWeapons();
				PlayStringAndWait("That ship... ain't that the pirate's ship?", SCHAR_TORRIN, EMOTE_NORMAL);
				PlayStringAndWait("I'd recognize it anywhere. Shelrond must have moved his base of operations here after we raided the fort on Kawi.", SCHAR_KAYLANI, EMOTE_NORMAL);
				PlayStringAndWait("Hardly seems right to let him rebuild here.", SCHAR_ASHER, EMOTE_NORMAL);
				PlayStringAndWait("I agree. Let's teach him a lesson he won't soon forget.", SCHAR_KAYLANI, EMOTE_NORMAL);
				ResumeGhostZHScripts();
				Game->Counter[CR_SMALLSIDEQUESTS1] |= BF_10;
				PopupNotify(3); //New Quest
			}
		}
		if(JankSelector == 32){
			if(Game->Counter[CR_STORYFLAG] >= SFLAG_MISTCLEAR && Game->Counter[CR_TORRINSIDEQUEST] == 6 && Game->Counter[CR_GOLEMSIDEQUEST] == 4 && Game->Counter[CR_NIGHTMARCHERQUEST] < 2){
				mapdata l1 = Game->LoadTempScreen(1);
				l1->ComboD[ComboAt(112, 64)] = 8516;
				l1->ComboD[ComboAt(128, 64)] = 8517;
				Game->PlaySound(67);
				ffc Terry = FFCNPC(33556, 120, 32);
				SetFFCDir(Terry, DIR_DOWN, true);
				while(Terry->Y < 64){
					Terry->Y++;
					WaitNoAction();
				}
				SetFFCDir(Terry, DIR_UP, false);
				WaitNoAction(30);
				l1->ComboD[ComboAt(112, 64)] = 8502;
				l1->ComboD[ComboAt(128, 64)] = 8503;
				Game->PlaySound(67);
				WaitNoAction(30);
				PlayStringAndWait("Terry?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				if(Link->Y < 128)
					SetFFCDir(Terry, DIR_LEFT, false);
				else
					SetFFCDir(Terry, DIR_DOWN, false);
				WaitNoAction(30);
				PlayStringAndWait("Torrin?", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_LOWER);
				if(Link->Y < 128){
					// while(!WalkLinkToPoint(0, 80)){
						// Waitframe();
					// }
					while(!WalkLinkToPoint(104, 80)){
						Waitframe();
					}
				}
				else{
					// while(!WalkLinkToPoint(0, 80)){
						// Waitframe();
					// }
					while(!WalkLinkToPoint(120, 96)){
						Waitframe();
					}
				}
				Link->Action = LA_ATTACKING;
				WaitNoAction();
				Link->Action = LA_NONE;
				WaitNoAction(60);
				PlayStringAndWait("How'd you find me here?", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_LOWER);
				if(Game->Counter[CR_NIGHTMARCHERQUEST] == 1){
					PlayStringAndWait("Caiman told me you were comin' here.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("I told him not to say anything! Ugh...", SCHAR_TERRY, EMOTE_ANGRY, 64, YPOS_LOWER);
				}
				else
					PlayStringAndWait("Just happened to be in town an' spot you.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("What are you doing here? Didn't you criticize Torrin for running off before?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Yeah! What happened to all that?", SCHAR_TORRIN, EMOTE_ANGRY, 64, YPOS_LOWER);
				PlayStringAndWait("Look, I'm tired a' bein' the good twin! I've tried to be responsible enough to make up for you for years. Can't I come to town and buy a freaking book for once without everyone judging me!?", SCHAR_TERRY, EMOTE_FURIOUS, 64, YPOS_LOWER);
				PlayStringAndWait("Whoa... uh, sorry. Didn't realize-", SCHAR_TORRIN, EMOTE_SURPRISED, 64, YPOS_LOWER);
				PlayStringAndWait("Save it, Torrin. It's fine.", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("So, uh... what's the book?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("It's, uh... a book about the Nightmarchers.", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("The Nightmarchers? Why do you want to read about phantom soldiers?", SCHAR_KAYLANI, EMOTE_SURPRISED, 64, YPOS_LOWER);
				PlayStringAndWait("Well... I don't have much of a connection to my past. Dad died when we were still young. Never knew any of my grandparents. And Ma doesn't like to talk much about 'em. But we've got a great grandpa who died in a battle on Wahiokala. Least, that's what Manch says. I thought... maybe I could see 'im, if he's still marchin' with the rest a' them.", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("I understand where you're coming from, but Terry, the Nightmarchers are very dangerous. They-", SCHAR_KAYLANI, EMOTE_SAD, 64, YPOS_LOWER);
				PlayStringAndWait("I know. But this has been eatin' at me for a while. I gotta see 'im.", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Aw shucks, you're gonna guilt me into helpin' ya now, aren't ya?", SCHAR_TORRIN, EMOTE_SAD, 64, YPOS_LOWER);
				PlayStringAndWait("He's your great grandpa, too. Aren't you interested in meetin' him?", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("More interested in not gettin' clubbed to death by a ghost. But... what the hell, why not? How's this work?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Well, the book says the Astronomers could track when they'd march usin' the night sky.", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Well THIS I can help with.", SCHAR_KAYLANI, EMOTE_EXCLAMATION, 64, YPOS_LOWER);
				PlayStringAndWait("But it also says it's only accurate if you read the sky from Tel's Pyramid.", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("... that one I'm not familiar with.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Do you think Siyed might know about that? He's studied old Astronomer ruins a lot.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("He might. It's worth a shot, at least.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				if(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_9){
					PlayStringAndWait("Let's head back to Kohiko and grab him then.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				}
				else{
					PlayStringAndWait("Any idea where to find him?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("If he's not back at Hoku Village, his sister, Lilah, might know where he is. We should ask her.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				}
				ClearFFC(Terry);
				for(int i = 0; i<60; i++){
					BlackScreenLayerSix();
					WaitNoAction();
				}
				if(Game->Counter[CR_NIGHTMARCHERQUEST] == 0)
					PopupNotify(3); //New Quest
				Game->Counter[CR_NIGHTMARCHERQUEST] = 2;
			}
		}
		if(JankSelector == 33){ //Pirate Quest Secrets Trigger 2
			if(Game->Counter[CR_STORYFLAG]>=SFLAG_ASHERKIDNAPPED){
				Screen->TriggerSecrets();
				Screen->State[ST_SECRET] = true;
			}
		}
		if(JankSelector == 34){ //Laverne Minidungeon Entrance
			if(!(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_0)&&!Screen->State[ST_SECRET]){
				Screen->ComboD[71] = 576;
				Screen->ComboD[72] = 577;
				Screen->ComboD[87] = 580;
				Screen->ComboD[88] = 581;
				
				mapdata l1 = Game->LoadTempScreen(1);
				l1->ComboF[71] = 0;
				l1->ComboF[72] = 0;
				l1->ComboF[87] = 0;
				l1->ComboF[88] = 0;
			}
		}
		if(JankSelector == 35){ //Uncheck the rule that breaks the area
			if(Game->FFRules[qr_WATER_ON_LAYER_1])
				Game->FFRules[qr_WATER_ON_LAYER_1] = false;
		}
		if(JankSelector == 36){ //Confronting Shelrond... again
			if(G[G_RANDOMIZERENABLED]){
				if(!Screen->State[ST_BOSSLOCKBLOCK]){
					npc ShelrondNPC = CreateNPCAt(218, 168, 56);
					ShelrondNPC->HP *= 1.25;
					while(ShelrondNPC->HP > 0)
						Waitframe();
					Game->PlayMIDI(0);
					Screen->State[ST_BOSSLOCKBLOCK] = true;
				}
				Quit();
			}
			int flip;
			ffc Pirate1;
			ffc Pirate2;
			ffc Gun1;
			ffc Gun2;
			ffc Asher;
			ffc Torrin;
			if(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_12){
				
				Quit();
			}
			else if(!(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_11)){
				Link->Invisible = true;
				Pirate2 = FindFreeFFC();
				Pirate2->Data = 1;
				Pirate1 = FindFreeFFC(); //Gotta declare these up here for draw order
				Pirate1->Data = 1;
				Gun1 = FindFreeFFC();
				Gun1->Data = 1;
				Gun2 = FindFreeFFC();
				Gun2->Data = 1;
				ffc Shelrond = FFCNPC(51816, 168, 32);
				SetFFCDir(Shelrond, DIR_UP, false);
				Waitframes(30);
				Torrin = FFCNPC(CMB_TORRIN, 168, 192);
				SetFFCDir(Torrin, DIR_UP, true);
				Asher = FFCNPC(CMB_ASHER, 168, 176);
				SetFFCDir(Asher, DIR_UP, true);
				ffc Kaylani = FFCNPC(CMB_KAYLANI, 168, 160);
				SetFFCDir(Kaylani, DIR_UP, true);
				while(Kaylani->Y > 80){
					Kaylani->Y--;
					Asher->Y--;
					Torrin->Y--;
					WaitNoAction();
				}
				SetFFCDir(Asher, DIR_LEFT, true);
				SetFFCDir(Torrin, DIR_RIGHT, true);
				SetFFCDir(Kaylani, DIR_UP, false);
				for(int i = 0; i<8; i++){
					Asher->X--;
					Torrin->X++;
					WaitNoAction();
				}
				SetFFCDir(Asher, DIR_UP, false);
				SetFFCDir(Torrin, DIR_UP, true);
				while(Torrin->Y > Asher->Y){
					Torrin->Y--;
					WaitNoAction();
				}
				SetFFCDir(Torrin, DIR_UP, false);
				WaitNoAction(60);
				PlayStringAndWait("You don't know when to quit, do you?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
				SetFFCDir(Shelrond, DIR_DOWN, false);
				WaitNoAction(60);
				PlayStringAndWait("Well, if it ain't little Miss Feisty once again? Right on schedule.", SCHAR_CAPTAIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayString("Schedule, what are you talking about?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
				FFCNPC(51932, 168, 160, Pirate1);
				// ffc Pirate1 = FFCNPC(51932, 168, 160);
				// Pirate1->Data = 51936;
				// Pirate1->TileHeight = 2;
				// Pirate1->X = 168;
				// Pirate1->Y = 160;
				SetFFCDir(Pirate1, DIR_UP, true);
				FFCNPC(51932, 168, 176, Pirate2);
				SetFFCDir(Pirate2, DIR_UP, true);
				while(Pirate1->Y > 112){
					Pirate1->Y--;
					Pirate2->Y--;
					G[G_NOACTION] = 1;
					Waitframe();
				}
				SetFFCDir(Pirate1, DIR_LEFT, true);
				// Pirate1->Data = 51936 + DIR_LEFT;
				for(int i = 0; i<8; i++){
					Pirate1->X--;
					Pirate2->Y--;
					G[G_NOACTION] = 1;
					Waitframe();
				}
				SetFFCDir(Pirate1, DIR_UP, false);
				// Pirate1->Data = 51932;
				for(int i = 0; i<8; i++){
					Pirate2->Y--;
					G[G_NOACTION] = 1;
					Waitframe();
				}
				SetFFCDir(Pirate2, DIR_RIGHT, true);
				for(int i = 0; i<8; i++){
					Pirate2->X++;
					G[G_NOACTION] = 1;
					Waitframe();
				}
				SetFFCDir(Pirate2, DIR_UP, false);
				while(G[G_MSGACTIVE]){
					G[G_NOACTION] = 1;
					Waitframe();
				}
				Game->PlaySound(SFX_ARROW);
				Pirate1->Data = 51900;
				Pirate2->Data = 51900;
				Gun1->X = Pirate1->X;
				Gun1->Y = Pirate1->Y;
				Gun1->Data = 51871;
				Gun2->X = Pirate2->X;
				Gun2->Y = Pirate2->Y;
				Gun2->Data = 51871;
				WaitNoAction(90);
				PlayStringAndWait("Uh... I don't suppose the astronomers are trained in hostage negotiations.", SCHAR_ASHER, EMOTE_SWEAT, 64, YPOS_UPPER);
				PlayStringAndWait("You didn't really think my men are so daft that they don't know you're here unless they can see you? Or that they'd forget about you if you hide under some boxes?", SCHAR_CAPTAIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("It did work for us at the warehouse...", SCHAR_TORRIN, EMOTE_SWEAT, 64, YPOS_UPPER);
				PlayStringAndWait("An' my men are more competent than Igorevich's buffoons.", SCHAR_CAPTAIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Get to the point. What do you want? Here to hand us back to Selet? He doesn't-", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
				PlayStringAndWait("Like I give a rat's backside about 'im. My men don't work for Igorevich anymore. No, Miss 'Kaylani', my goal is you. No one's bested me before. No one, until you. But, seems to me the two of us 'aven't had a fair fight. I got the drop on you with my lackies, and you so kindly returned the favor in my own 'ideout.", SCHAR_CAPTAIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("And this is a fair fight? With guns pointed at my friend's heads?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
				PlayStringAndWait("I've no intentions a' shootin' them, so long as you cooperate. You an' me. No fancy tricks, no backup.", SCHAR_CAPTAIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("And what do you get out of this?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
				PlayStringAndWait("A captain's pride is 'is most important asset. I'll not be known as Captain Shelrond, the man who let a teenage girl steal from under his nose.", SCHAR_CAPTAIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("And when I win?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
				PlayStringAndWait("I know when I'm beaten. IF you win, I'll leave the coasts out 'ere alone for the time bein' an' let your friends go safely.", SCHAR_CAPTAIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Fine. If it's a beating you want, I can oblige.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
				flip = 1;
				ClearFFC(Kaylani);
				ClearFFC(Shelrond);
				Game->Counter[CR_SMALLSIDEQUESTS1] |= BF_11;
			}
			if(flip == 0){
				for(int i = 0; i<60; i++){
					BlackScreenLayerSix();
					WaitNoAction();
				}
				Pirate1 = FindFreeFFC();
				Pirate1->Data = 51900;
				Pirate1->TileHeight = 2;
				Pirate1->X = 160;
				Pirate1->Y = 112;
				Pirate2 = FindFreeFFC();
				Pirate2->Data = 51900;
				Pirate2->TileHeight = 2;
				Pirate2->X = 176;
				Pirate2->Y = 112;
				Gun1 = FindFreeFFC();
				Gun1->X = Pirate1->X;
				Gun1->Y = Pirate1->Y;
				Gun1->Data = 51871;
				Gun2 = FindFreeFFC();
				Gun2->X = Pirate2->X;
				Gun2->Y = Pirate2->Y;
				Gun2->Data = 51871;
				// Asher = FindFreeFFC();
				// Asher->Data = CMB_ASHER;
				// Asher->CSet = 6;
				// Asher->TileHeight = 2;
				// Asher->X = 168;
				// Asher->Y = 176;
				// Torrin = FindFreeFFC();
				// Torrin->Data = CMB_ASHER;
				// Torrin->CSet = 6;
				// Torrin->TileHeight = 2;
				// Torrin->X = 160;
				// Torrin->Y = 112;
				Asher = FFCNPC(CMB_ASHER, 160, 96);
				SetFFCDir(Asher, DIR_UP, false);
				Torrin = FFCNPC(CMB_TORRIN, 176, 96);
				SetFFCDir(Torrin, DIR_UP, false);
			}
			Link->HP = Link->MaxHP;
			G[G_ASHERHP] = G[G_ASHERMAXHP];
			G[G_TORRINHP] = G[G_TORRINMAXHP];
			G[G_KAYLANIHP] = G[G_KAYLANIMAXHP];
			Link->MP = Link->MaxMP;
			G[G_ASHERMP] = Link->MaxMP;
			G[G_KAYLANIMP] = Link->MaxMP;
			mapdata l1 = Game->LoadTempScreen(1);
			l1->ComboD[ComboAt(160, 112)] = 1;
			l1->ComboD[ComboAt(176, 112)] = 1;
			l1->ComboD[ComboAt(160, 128)] = 1;
			l1->ComboD[ComboAt(176, 128)] = 1;
			mapdata l3 = Game->LoadTempScreen(3);
			l3->ComboD[ComboAt(160, 96)] = 33284;
			l3->ComboC[ComboAt(160, 96)] = 6;
			l3->ComboD[ComboAt(176, 96)] = 33292;
			Link->Invisible = false;
			Link->Item[I_ASHER] = false;
			SetCharacter(CHAR_KAYLANI, false);
			Link->Item[I_TORRIN] = false;
			Link->Item[I_KAYLANI] = true;
			Link->X = 168;
			Link->Y = 96;
			Link->Dir = DIR_UP;
			npc ShelrondNPC = CreateNPCAt(218, 168, 56);
			while(ShelrondNPC->HP > 0)
				Waitframe();
			KillEWeapons();
			KillLWeapons();
			Game->PlayMIDI(0);
			for(int i=0; i<60; i++){
				BlackScreenLayerSix();
				WaitNoAction();
			}
			l1->ComboD[ComboAt(160, 112)] = 0;
			l1->ComboD[ComboAt(176, 112)] = 0;
			l1->ComboD[ComboAt(160, 128)] = 0;
			l1->ComboD[ComboAt(176, 128)] = 0;
			l3->ComboD[ComboAt(160, 96)] = 0;
			l3->ComboD[ComboAt(176, 96)] = 0;
			Link->Invisible = true;
			ffc Shelrond = FFCNPC(51816, 168, 32);
			SetFFCDir(Shelrond, DIR_DOWN, false);
			ffc Kaylani = FFCNPC(CMB_KAYLANI, 168, 80);
			SetFFCDir(Kaylani, DIR_UP, false);
			PlayStringAndWait("Enough. I know when I'm beaten. Men, lower your weapons.", SCHAR_CAPTAIN, EMOTE_NORMAL, 64, YPOS_LOWER);
			Game->PlaySound(SFX_ARROW);
			ClearFFC(Gun1);
			ClearFFC(Gun2);
			Pirate1->Data = 51932;
			Pirate2->Data = 51932;
			WaitNoAction(60);
			PlayStringAndWait("Pheeeeeeeeeeeeeeeeeeeeew. Can't remember the last time I felt that tense.", SCHAR_TORRIN, EMOTE_SWEAT, 64, YPOS_UPPER);
			PlayStringAndWait("So that's that? You're going to stop the thieving, just because of that fight?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("You seem skeptical.", SCHAR_CAPTAIN, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("Can you blame me for not trusting you?", SCHAR_KAYLANI, EMOTE_ANGRY, 64, YPOS_UPPER);
			PlayStringAndWait("Not at all, and with good reason. We're not stoppin' now. Truth be told, we already did!", SCHAR_CAPTAIN, EMOTE_HAPPY, 64, YPOS_LOWER);
			PlayStringAndWait("Pardon?", SCHAR_KAYLANI, EMOTE_SURPRISED, 64, YPOS_UPPER);
			PlayStringAndWait("This Igorevich is trouble, that much is clear. I decided my men and I didn't need to get wrapped up in 'is nonsense. Not t'mention, I don't want to be bringin' the wrath a' the astronomers down on my crew. So, for now, at least, we've retired from plunderin' and kidnappin'. My crew are hired mercenaries, nothin' more.", SCHAR_CAPTAIN, EMOTE_HAPPY, 64, YPOS_LOWER);
			if(Game->Counter[CR_MISCSIDEQUEST] == 8){
				PlayStringAndWait("You're done kidnapping? Didn't your men work for Madame Tulane and kidnap a girl from Pala Bay?", SCHAR_ASHER, EMOTE_SWEAT, 64, YPOS_UPPER);
				PlayStringAndWait("... Aye, we may still engage in a tad bit a' kidnappin'.", SCHAR_CAPTAIN, EMOTE_NORMAL, 64, YPOS_LOWER);
			}
			PlayStringAndWait("Well in that case, can we maybe persuade you to help us take down Selet?", SCHAR_TORRIN, EMOTE_IDEA, 64, YPOS_UPPER);
			PlayStringAndWait("Hah! Boy, you ain't got nearly the kinda pay to convince me to do somethin' that foolhardy. Though he was a very rude employer. I wouldn't mind given this augment to Miss Kaylani here, if ya promise to give Igorevich a beatdown he won't soon forget.", SCHAR_CAPTAIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("I... thank you, I think? For the record, I still despise you.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("An' I wouldn't 'ave it any other way. Now off ya go, leave my crew in peace.", SCHAR_CAPTAIN, EMOTE_NORMAL, 64, YPOS_LOWER);
			Game->Counter[CR_SMALLSIDEQUESTS1] |= BF_12;
			Link->Invisible = false;
			Link->Item[I_ASHER] = true;
			Link->Item[I_TORRIN] = true;
			Link->Item[I_KAYLANI] = true;
			this->Data = CMB_AUTOWARPA;
		}
		if(JankSelector == 37){ //Failsafe for leaving/F6ing during that part
			if(G[G_RANDOMIZERENABLED])
				Quit();
			Link->Item[I_ASHER] = true;
			Link->Item[I_TORRIN] = true;
			Link->Item[I_KAYLANI] = true;
		}
		if(JankSelector == 38){
			if(G[G_RANDOMIZERENABLED])
				Quit();
			if(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_12 && !FoundItems[199])
				AugmentGet(199);
		}
		if(JankSelector == 39){ //Mirage Island door
			int cooldown;
			int hits;
			if(!Screen->State[ST_SECRET]){
				while(!Screen->State[ST_SECRET]){
					if(Link->Y<this->Y){
						Screen->TriggerSecrets();
						Screen->State[ST_SECRET] = true;
					}
					if(cooldown)
						--cooldown;
					else{
						for(int i=Screen->NumLWeapons(); i>0; --i){
							lweapon l = Screen->LoadLWeapon(i);
							if(Collision(this, l)){
								if(l->ID==LW_BOMBBLAST||l->Weapon==LW_BOMBBLAST){
									if(hits>=10){
										Game->PlaySound(9);
										Screen->TriggerSecrets();
										Screen->State[ST_SECRET] = true;
									}
									else{
										Game->PlaySound(6);
										++hits;
										cooldown = 32;
										break;
									}
								}
							}
						}
					}
					Waitframe();
				}
			}
		}
		if(JankSelector == 40){ //Mirage Island warp change
			if(Link->Y>88){
				G[G_CREATORSREALM_CONTINUESCREEN] = 0;
				G[G_CREATORSREALM_CONTINUEDMAP] = 0;
			}
			else if(Distance(Link->X, Link->Y, this->X, this->Y)<8||(G[G_CREATORSREALM_CONTINUEDMAP]>0||G[G_CREATORSREALM_CONTINUESCREEN]>0)){
				Screen->SetSideWarp(0, G[G_CREATORSREALM_CONTINUESCREEN]-Game->DMapOffset[G[G_CREATORSREALM_CONTINUEDMAP]], G[G_CREATORSREALM_CONTINUEDMAP], WT_IWARPWAVE);
			}
		}
		if(JankSelector == 41){
			if(Game->Counter[CR_NIGHTMARCHERQUEST] == 4){
				WaitNoAction(30);
				PlayStringAndWait("This must be the place.", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("There are torches up here? What on earth are those for?", SCHAR_TORRIN, EMOTE_QUESTION, 64, YPOS_LOWER);
				PlayStringAndWait("Do you still have those books you got in Pala Bay?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Yes. Let's read through them and see what we can find. You and Siyed are both astronomers. You can figure out how to find them, right?", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Assuming there's enough information in these books. We'll need a good view of the night sky, possibly over multiple nights. I'll set up a bed in the cave below where we could pass the time.", SCHAR_SIYED, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Sounds good. Let me know when you've figured it out. We'll need to set out for Wahiokala BEFORE nightfall on the night they'll appear so we have time to get there and prepare.", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_LOWER);
				Game->Counter[CR_NIGHTMARCHERQUEST] = 5;
				for(int i = 0; i<60; i++){
					BlackScreenLayerSix();
					WaitNoAction();
				}
			}
			if(Game->Counter[CR_NIGHTMARCHERQUEST] == 5){
				if(G[G_INUNDERSIDECAVE])
					Quit();
				if(GetCharID() == CHAR_ASHER){
					Link->Item[I_ASHER] = true;
					Link->Item[I_TORRIN] = false;
					Link->Item[I_KAYLANI] = false;
				}
				if(GetCharID() == CHAR_TORRIN){
					Link->Item[I_ASHER] = false;
					Link->Item[I_TORRIN] = true;
					Link->Item[I_KAYLANI] = false;
				}
				if(GetCharID() == CHAR_KAYLANI){
					Link->Item[I_ASHER] = false;
					Link->Item[I_TORRIN] = false;
					Link->Item[I_KAYLANI] = true;
				}
				ffc Siyed = FindFreeFFC();
				Siyed->X = 96;
				Siyed->Y = 32;
				Siyed->TileHeight = 2;
				Siyed->Data = 42002;
				Siyed->Script = 38;
				Siyed->InitD[1] = SCHAR_SIYED;
				Siyed->InitD[0] = 102;
				Siyed->InitD[2] = 0;
				Siyed->InitD[3] = 0;
				Siyed->InitD[4] = 0;
				Siyed->InitD[5] = 0;
				Siyed->InitD[6] = 1;
				
				ffc Party1 = FindFreeFFC();
				Party1->X = 112;
				Party1->Y = 87;
				Party1->TileHeight = 2;
				if(GetCharID() == CHAR_ASHER)
					Party1->Data = 41986;
				else
					Party1->Data = 41984;
				Party1->CSet = 6;
				Party1->Script = 38;
				if(GetCharID() == CHAR_ASHER)
					Party1->InitD[1] = SCHAR_KAYLANI;
				else
					Party1->InitD[1] = SCHAR_ASHER;
				Party1->InitD[0] = 103;
				Party1->InitD[2] = 0;
				Party1->InitD[3] = 0;
				Party1->InitD[4] = 0;
				Party1->InitD[5] = 0;
				Party1->InitD[6] = 1;
				
				ffc Party2 = FindFreeFFC();
				Party2->X = 128;
				Party2->Y = 32;
				Party2->TileHeight = 2;
				if(GetCharID() == CHAR_TORRIN)
					Party2->Data = 42003;
				else
					Party2->Data = 42001;
				Party2->CSet = 6;
				Party2->Script = 38;
				if(GetCharID() == CHAR_TORRIN)
					Party2->InitD[1] = SCHAR_KAYLANI;
				else
					Party2->InitD[1] = SCHAR_TORRIN;
				Party2->InitD[0] = 104;
				Party2->InitD[2] = 0;
				Party2->InitD[3] = 0;
				Party2->InitD[4] = 0;
				Party2->InitD[5] = 0;
				Party2->InitD[6] = 1;
				
				mapdata l2 = Game->LoadTempScreen(2);
				l2->ComboD[ComboAt(128, 96)] = 16765;
				l2->ComboC[ComboAt(128, 96)] = 6;
				
				ffc Terry = FindFreeFFC();
				Terry->X = 176;
				Terry->Y = 16;
				Terry->TileHeight = 2;
				Terry->Data = 33556;
				Terry->Script = 38;
				Terry->InitD[1] = SCHAR_TERRY;
				Terry->InitD[0] = 105;
				// Terry->InitD[2] = 0;
				// Terry->InitD[3] = 0;
				// Terry->InitD[4] = 0;
				// Terry->InitD[5] = 0;
				// Terry->InitD[6] = 1;
			}
		}
		if(JankSelector == 42){ //Time-advance bed
			if(d1 == 1){ //Randomizer bed
				if(!G[G_RANDOMIZERENABLED]){
					this->Data = 0;
					Quit();
				}
			}
			if(Game->GetCurDMap() == 65 && Game->Counter[CR_NIGHTMARCHERQUEST] != 5){
				this->Data = 0;
				Quit();
			}			
			// if(Game->GetCurDMap() == 65 && Game->Counter[CR_NIGHTMARCHERQUEST] == 5){	
				// Screen->ComboD[ComboAt(this->X+16, this->Y)] = 8;
				// Screen->ComboD[ComboAt(this->X+16, this->Y+16)] = 8;
				// Screen->ComboD[ComboAt(this->X, this->Y+16)] = 8;
			// }		
			if(Game->GetCurDMap() == 32 && Game->Counter[CR_STORYFLAG] < SFLAG_POSTGRANDMA){
				this->Data = 0;
				Quit();
			}				
			bool doSpecialHour;
			if(Game->GetCurMap()==24&&Game->GetCurScreen()==0x6F)
				doSpecialHour = true;
			bool specialHour;
			if(doSpecialHour&&G[G_SLEEPPARALYSISSELET])
				specialHour = true;
			if(Game->Counter[CR_STORYFLAG] < SFLAG_METKAYLANI)
				Quit();
			while(true){
				if(Game->GetCurDMap() == 65){
					if(G[G_INUNDERSIDECAVE])
						this->Data = 48738;
					else
						this->Data = 1;
				}
				int bedstyle = 0; //Solid beds
				if(Game->GetCurDMap() == 65 || Game->GetCurDMap() == 31)
					bedstyle = 1; //Malka beds
				if(
				(bedstyle == 1 && LinkCollision(this))
				|| (bedstyle == 0 && Distance(Link->X+8, Link->Y+8, this->X+16, this->Y+16) <= 30)){
				// ((Game->GetCurDMap() == 65 || Game->GetCurDMap() == 31) && LinkCollision(this))
				// || ((d1 == 1 || Game->GetCurDMap() == 32 || Game->GetCurDMap() == 15 || Game->GetCurDMap() == 76) && Distance(Link->X+8, Link->Y+8, this->X+16, this->Y+16) <= 30)){
					if(Game->GetCurDMap() != 65 || G[G_INUNDERSIDECAVE]){
						Screen->DrawCombo(6, this->X, this->Y, CMB_CANTALKQUEST, 2, 1, 8, -1, -1, 0, 0, 0, -1, 0, true, 128);
						if(Link->PressA){
							Link->PressA = false;
							Link->InputA = false;
							G[G_TIMEFROZEN] = 1;
							WaitNoAction();
							int Position;
							int Xoff = 10;
							int Xoff2 = 48;
							int Yoff = 18;
							int NumHours;
							int NumDays;
							int NumMinutes;
							while(true){
								if(Link->PressLeft&&!specialHour){
									Game->PlaySound(21);
									if(Position == 0)
										Position = 2;
									else
										Position--;
								}
								if(Link->PressRight&&!specialHour){
									Game->PlaySound(21);
									if(Position == 2)
										Position = 0;
									else
										Position++;
								}
								if(Link->PressUp){
									if(Position==0){
										if(NumDays==19){
											if(doSpecialHour&&!specialHour)
												specialHour = true;
											else
												NumDays = 0;
										}
										else{
											specialHour = false;
											NumDays++;
										}
									}
									if(Position==1){
										if(NumHours==23)
											NumHours = 0;
										else
											NumHours++;
									}
									if(Position==2){
										if(NumMinutes==59)
											NumMinutes = 0;
										else
											NumMinutes++;
									}
								}
								if(Link->PressDown){
									if(Position==0){
										if(NumDays==0)
											if(doSpecialHour&&!specialHour)
												specialHour = true;
											else
												NumDays = 19;
										else{
											specialHour = false;
											NumDays--;
										}
									}
									if(Position==1){
										if(NumHours==0)
											NumHours = 23;
										else
											NumHours--;
									}
									if(Position==2){
										if(NumMinutes==0)
											NumMinutes = 59;
										else
											NumMinutes--;
									}
								}
								
								if(Link->PressA){
									int fadeSpeed = 8; //Was 60
									int fadeDelay = 64;
									for(int i = 0; i<fadeSpeed; i++){
										BlackishScreenLayerSix();
										WaitNoAction();
									}
									for(int i = 0; i<fadeSpeed; i++){
										BlackishScreenLayerSix();
										BlackishScreenLayerSix();
										WaitNoAction();
									}
									
									for(int i = 0; i<fadeSpeed; i++){
										BlackScreenLayerSix();
										WaitNoAction();
									}
									for(int i = 0; i<fadeDelay; i++){
										BlackScreenLayerSix();
										WaitNoAction();
									}
									
									FullHeal(true, true, false, false);
									Link->HP = Link->MaxHP;
									G[G_ASHERHP] = G[G_ASHERMAXHP];
									G[G_TORRINHP] = G[G_TORRINMAXHP];
									G[G_KAYLANIHP] = G[G_KAYLANIMAXHP];
									Link->MP = Link->MaxMP;
									G[G_ASHERMP] = Link->MaxMP;
									G[G_KAYLANIMP] = Link->MaxMP;
									if(doSpecialHour&&specialHour){
										G[G_SLEEPPARALYSISSELET] = 1;
										Game->DMapPalette[76] = 0x095;
									}
									else{
										if(doSpecialHour){
											G[G_SLEEPPARALYSISSELET] = 0;
											Game->DMapPalette[76] = 0x0AF;
										}
										int time = DayNight[_DN_HOUR]*60+DayNight[_DN_MINUTE];
										DayNight[_DN_MINUTE] += NumMinutes;
										while(DayNight[_DN_MINUTE]>=60){
											DayNight[_DN_MINUTE] -= 60;
											DayNight[_DN_HOUR]++;
										}
										DayNight[_DN_HOUR] += NumHours;
										while(DayNight[_DN_HOUR]>=25){
											DayNight[_DN_HOUR] -= 24;
										}
										int newtime = DayNight[_DN_HOUR]*60+DayNight[_DN_MINUTE];
										if((time < 19*60+0 && newtime < time) || (time < 19*60+0 && newtime >= 19*60+0))
											Nightmarchers_AdvanceDay();
										
										for(int i = 0; i<NumDays; i++){
											Nightmarchers_AdvanceDay();
										}
									}
									
									for(int i = 0; i<fadeSpeed; i++){
										BlackScreenLayerSix();
										WaitNoAction();
									}
									
									for(int i = 0; i<fadeSpeed; i++){
										BlackishScreenLayerSix();
										BlackishScreenLayerSix();
										WaitNoAction();
									}
									for(int i = 0; i<fadeSpeed; i++){
										BlackishScreenLayerSix();
										WaitNoAction();
									}
									break;
								}
								if(Link->PressB){
									Game->PlaySound(6);
									Link->PressB = false;
									Link->InputB = false;
									break;
								}
								
								DialogueBox_DrawBox(6, 128, 88, TIL_DB_DIALOGUE_BOX, CS_DB_DIALOGUE_BOX, C_DB_DIALOGUE_BOX_BG, 144, 64);
								Screen->DrawString(6, 52+Xoff, 48+Yoff, FONT_P, 0xB2, -1, TF_NORMAL, "Sleep for how long?", OP_OPAQUE);
								
								if(specialHour){
									Screen->DrawString(6, 128, 48+18+Yoff, FONT_P, 0xB7, -1, TF_CENTERED, "Why wake up?", OP_OPAQUE);
								}
								else{
									if(Position == 0)
										Screen->DrawString(6, 52+Xoff, 48+18+Yoff, FONT_P, 0xB7, -1, TF_NORMAL, "Days", OP_OPAQUE);
									else
										Screen->DrawString(6, 52+Xoff, 48+18+Yoff, FONT_P, 0xB2, -1, TF_NORMAL, "Days", OP_OPAQUE);
									if(Position == 1)
										Screen->DrawString(6, 52+Xoff+Xoff2, 48+18+Yoff, FONT_P, 0xB7, -1, TF_NORMAL, "Hours", OP_OPAQUE);
									else
										Screen->DrawString(6, 52+Xoff+Xoff2, 48+18+Yoff, FONT_P, 0xB2, -1, TF_NORMAL, "Hours", OP_OPAQUE);
									if(Position == 2)
										Screen->DrawString(6, 52+Xoff+Xoff2*2, 48+18+Yoff, FONT_P, 0xB7, -1, TF_NORMAL, "Minutes", OP_OPAQUE);
									else
										Screen->DrawString(6, 52+Xoff+Xoff2*2, 48+18+Yoff, FONT_P, 0xB2, -1, TF_NORMAL, "Minutes", OP_OPAQUE);
									Screen->DrawInteger(6, 52+Xoff, 48+18+18+Yoff, FONT_P, 1, -1, -1, -1, NumDays, 0, OP_OPAQUE);
									Screen->DrawInteger(6, 52+Xoff+Xoff2, 48+18+18+Yoff, FONT_P, 1, -1, -1, -1, NumHours, 0, OP_OPAQUE);
									Screen->DrawInteger(6, 52+Xoff+Xoff2*2, 48+18+18+Yoff, FONT_P, 1, -1, -1, -1, NumMinutes, 0, OP_OPAQUE);
								}
								
								G[G_NOACTION] = 1;
								Waitframe();
							}
							G[G_TIMEFROZEN] = 0;
						}
					}
				}
				Waitframe();
			}
		}
		if(JankSelector == 43){ //The moon
			while(true){
				int time = DayNight[_DN_HOUR]*60+DayNight[_DN_MINUTE];
				if((time >= 19*60 && time < 20*60) || (time >= 4*60+30 && time < 6*60)){
					if(G[G_NIGHTMARCHEREVENT_DAYCOUNT2] <= 9)
						Screen->DrawTile(0, 112, 0,	45320 + G[G_NIGHTMARCHEREVENT_DAYCOUNT2]*2, 2, 2, 3, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
					else
						Screen->DrawTile(0, 112, 0,	45360 + (G[G_NIGHTMARCHEREVENT_DAYCOUNT2]-10)*2, 2, 2, 3, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
				}
				else if(time >= 20*60 || time < 4*60+30){
					if(G[G_NIGHTMARCHEREVENT_DAYCOUNT2] <= 9)
						Screen->DrawTile(0, 112, 0,	45160 + G[G_NIGHTMARCHEREVENT_DAYCOUNT2]*2, 2, 2, 3, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
					else
						Screen->DrawTile(0, 112, 0,	45200 + (G[G_NIGHTMARCHEREVENT_DAYCOUNT2]-10)*2, 2, 2, 3, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
				}
				Waitframe();
			}
		}
		if(JankSelector == 44){ //Nightmarcher torches
			bool night;
			while(true){
				if(DayNight[_DN_HOUR] >= DAYNIGHT_MIDI_NIGHT_START_HOUR || DayNight[_DN_HOUR] <= DAYNIGHT_MIDI_NIGHT_END_HOUR){
					night = true;
				}
				else{
					night = false;
				}
				if((G[G_NIGHTMARCHEREVENT_DAYCOUNT2] + 2) % 4 == 0){
					for(int i = 0; i<176; i++){
						if(night){
							if(GetLayerComboD(3, i) == 41187){
								SetLayerComboD(3, i-16, 41186);
								SetLayerComboD(3, i, 41190);
							}
						}
						else{
							if(GetLayerComboD(3, i) == 41190){
								SetLayerComboD(3, i-16, 0);
								SetLayerComboD(3, i, 41187);
							}
						}
					}
				}
				else{
					for(int i = 0; i<176; i++){
						if(GetLayerComboD(3, i) == 41190){
							SetLayerComboD(3, i-16, 0);
							SetLayerComboD(3, i, 41187);
						}
					}
				}
				Waitframe();
			}
		}
		if(JankSelector == 45){ //Survive the march
			if(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_13){
				for(int i=0; i<10; ++i){
					Screen->Enemy[i] = 0;
				}
				if(Game->Counter[CR_NIGHTMARCHERQUEST] < 6){
					SuspendGhostZHScripts();
					WaitNoAction(30);
					PlayStringAndWait("Let's hope you're right about this...", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_LOWER);
					G[G_TIMEFROZEN] = 0;
					while(DayNight[_DN_HOUR] < 19)
						WaitNoAction();
					if(G[G_NIGHTMARCHEREVENT_INEVENT] == 1){
						G[G_TIMEFROZEN] = 1;
						WaitNoAction(30);
						PlayStringAndWait("It's them! It worked!", SCHAR_TERRY, EMOTE_EXCLAMATION, 64, YPOS_LOWER);
						PlayStringAndWait("Um... not to say we didn't think this through, but what now?", SCHAR_SIYED, EMOTE_DISMAYED, 64, YPOS_LOWER);
						PlayStringAndWait("My great grandfather'll recognize us! We just gotta survive until he shows up!", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_LOWER);
						ResumeGhostZHScripts();
						Game->Counter[CR_NIGHTMARCHERQUEST] = 6;
						G[G_TIMEFROZEN] = 0;
					}
					else{
						WaitNoAction(30);
						PlayStringAndWait("Well... no marchers.", SCHAR_TERRY, EMOTE_SAD, 64, YPOS_LOWER);
						PlayStringAndWait("That doesn't make sense. I'm sure we had the right date.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
						PlayStringAndWait("I guess we misinterpreted things. Let's regroup at the Pyramid and read over those books again.", SCHAR_SIYED, EMOTE_NORMAL, 64, YPOS_LOWER);
						Game->Counter[CR_SMALLSIDEQUESTS1] = Game->Counter[CR_SMALLSIDEQUESTS1] & ~BF_13;
						Quit();
					}
				}
				DayNight[_DN_MINUTE] = 0;
				DayNight[_DN_HOUR] = 19;
				G[G_NIGHTMARCHEREVENT_CHECKTIME] = DayNight[_DN_HOUR]*60+DayNight[_DN_MINUTE];
				mapdata l2 = Game->LoadTempScreen(2);
				for(int i = 0; i<240; i++){
					l2->ComboD[ComboAt(i, 0)] = 1;
					l2->ComboD[ComboAt(i, 160)] = 1;
				}
				for(int i = 0; i<160; i++){
					l2->ComboD[ComboAt(0, i)] = 1;
					l2->ComboD[ComboAt(240, i)] = 1;
				}
				while(DayNight[_DN_HOUR] < 22)
					Waitframe();
				G[G_TIMEFROZEN] = 1;
				DayNight[_DN_MINUTE] = 59;
				DayNight[_DN_HOUR] = 1;
				for(int i = Screen->NumNPCs(); i>0; i--){
					npc n = Screen->LoadNPC(i);
					n->Y = -1000;
					n->HP = -10000;
				}
				for(int i = Screen->NumItems(); i>0; i--){
					item t = Screen->LoadItem(i);
					Remove(t);
				}
				Link->X = 96;
				Link->Y = 80;
				// npc N1 = CreateNPCAt(NPC_NIGHTMARCHER, 56, 80);
				// N1->Dir = DIR_RIGHT;
				// npc N2 = CreateNPCAt(NPC_NIGHTMARCHER, 184, 80);
				// N2->Dir = DIR_LEFT;
				ffc N1 = FFCNPC(51776, 56, 72);
				N1->Script = 64;
				N1->InitD[0] = 46;
				N1->Misc[0] = 51776;
				N1->Flags[FFCF_LENSVIS] = true;
				SetFFCDir(N1, DIR_RIGHT, false);
				ffc N2 = FFCNPC(51776, 184, 72);
				N2->Script = 64;
				N2->InitD[0] = 46;
				N2->Misc[0] = 51776;
				N2->Flags[FFCF_LENSVIS] = true;
				SetFFCDir(N2, DIR_LEFT, false);
				for(int i = 0; i<60; i++){
					BlackScreenLayerSix();
					WaitNoAction();
				}
				Link->Invisible = true;
				ffc Terry = FFCNPC(33556, 112, 32);
				SetFFCDir(Terry, DIR_UP, false);
				ffc Torrin = FFCNPC(CMB_TORRIN, 128, 32);
				SetFFCDir(Torrin, DIR_UP, false);
				ffc Asher = FFCNPC(CMB_ASHER, 96, 64);
				SetFFCDir(Asher, DIR_LEFT, false);
				ffc Siyed = FFCNPC(33764, 96, 48);
				SetFFCDir(Siyed, DIR_LEFT, false);
				ffc Kaylani = FFCNPC(CMB_KAYLANI, 144, 56);
				SetFFCDir(Kaylani, DIR_RIGHT, false);
				WaitNoAction(30);
				PlayStringAndWait("If we survive, remind me to kill you for suggestin' this.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("I don't get it. He should be here!", SCHAR_TERRY, EMOTE_SAD, 64, YPOS_LOWER);
				SetFFCDir(N1, DIR_RIGHT, true);
				SetFFCDir(N2, DIR_LEFT, true);
				while(N1->X < 72){
					N1->X+=0.5;
					N2->X-=0.5;
					WaitNoAction();
				}
				SetFFCDir(N1, DIR_RIGHT, false);
				SetFFCDir(N2, DIR_LEFT, false);
				PlayStringAndWait("This isn't how I pictured it ending.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Me neither. Always kinda figured I'd spring a trap in an old ruin or get crushed by a falling bookcase.", SCHAR_SIYED, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("... Siyed, WHEN we get out of this, we need to talk about your outlook on life.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				// npc N3 = CreateNPCAt(NPC_NIGHTMARCHER, 120, -16);
				// N3->Dir = DIR_DOWN;
				ffc N3 = FFCNPC(51776, 120, -32);
				N3->Script = 64;
				N3->InitD[0] = 46;
				N3->Misc[0] = 51776;
				N3->Flags[FFCF_LENSVIS] = true;
				SetFFCDir(N3, DIR_DOWN, true);
				while(N3->Y < 24){
					N3->Y+=0.5;
					WaitNoAction();
				}
				SetFFCDir(N3, DIR_DOWN, false);
				WaitNoAction(60);
				Game->PlayMIDI(0);
				PlayStringAndWait("Mine.", SCHAR_NIGHTMARCHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				WaitNoAction(30);
				// N1->Dir = DIR_LEFT;
				// N2->Dir = DIR_RIGHT;
				SetFFCDir(N1, DIR_LEFT, true);
				SetFFCDir(N2, DIR_RIGHT, true);
				while(N1->X > -16){
					N1->X-=0.5;
					N2->X+=0.5;
					WaitNoAction();
				}
				ClearFFC(N1);
				ClearFFC(N2);
				N1->Script = 0;
				N2->Script = 0;
				SetFFCDir(Kaylani, DIR_UP, false);
				SetFFCDir(Asher, DIR_UP, false);
				SetFFCDir(Siyed, DIR_UP, false);
				PlayStringAndWait("... Great Grandpa? Is that you?", SCHAR_TERRY, EMOTE_SURPRISED, 64, YPOS_LOWER);
				PlayStringAndWait("You should not have come here. Only death awaits those foolish enough to interrupt the Night March.", SCHAR_NIGHTMARCHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("I know, but... I had to see you.", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Are you... ya know, really our great grandpa?", SCHAR_TORRIN, EMOTE_QUESTION, 64, YPOS_LOWER);
				PlayStringAndWait("In life, I was a fool. Careless, reckless, and desperate for a break in the mundanity of Malka. I got involved in a conflict. And at this spot, I died in battle. I had hoped my descendants might be more level-headed than I. I see now that was a foolish hope.", SCHAR_NIGHTMARCHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("That, uh... that sounds 'bout right.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("I must return to-", SCHAR_NIGHTMARCHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("So soon? But we just found you!", SCHAR_TERRY, EMOTE_DISMAYED, 64, YPOS_LOWER);
				PlayStringAndWait("The dead and the living should not mingle. I have my sacred duty to attend, and you have premature deaths to avoid. Go in peace.", SCHAR_NIGHTMARCHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				// N3->Dir = DIR_UP;
				//SetFFCDir(N3, DIR_UP, true);
				while(N3->InitD[2]!=0){
					WaitNoAction();
				}
				for(int i=0; i<48; ++i){
					if(i%4<2)
						N3->InitD[1] = 1;
					else
						N3->InitD[1] = 2;
					WaitNoAction();
				}
				for(int i=0; i<48; ++i){
					if(i%4<2)
						N3->InitD[1] = 2;
					else
						N3->InitD[1] = 3;
					WaitNoAction();
				}
				for(int i=0; i<48; ++i){
					if(i%4<2)
						N3->InitD[1] = 3;
					else
						N3->InitD[1] = 4;
					WaitNoAction();
				}
				for(int i=0; i<48; ++i){
					if(i%8>=6)
						N3->InitD[1] = 3;
					else
						N3->InitD[1] = 4;
					WaitNoAction();
				}
				// while(N3->Y > -32){
					// N3->Y-=0.5;
					// WaitNoAction();
				// }
				ClearFFC(N3);
				N3->Script = 0;
				// N1->Y = -1000;
				// N2->Y = -1000;
				// N3->Y = -1000;
				// N1->HP = -1000;
				// N2->HP = -1000;
				// N3->HP = -1000;
				DayNight[_DN_MINUTE] = 0;
				DayNight[_DN_HOUR] = 2;
				G[G_TIMEFROZEN] = 0;
				SetFFCDir(Kaylani, DIR_UP, true);
				SetFFCDir(Asher, DIR_UP, true);
				SetFFCDir(Siyed, DIR_UP, true);
				while(Asher->Y > 24){
					Asher->Y--;
					Siyed->Y--;
					Kaylani->Y--;
					WaitNoAction();
				}
				SetFFCDir(Kaylani, DIR_LEFT, false);
				SetFFCDir(Asher, DIR_RIGHT, false);
				SetFFCDir(Siyed, DIR_RIGHT, false);
				WaitNoAction(45);
				PlayStringAndWait("Not sure what I was 'xpectin', but it wasn't that.", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Hey, uh... I'm sorry it didn't turn out like you were hopin'.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("It's fine. He was right. We're both reckless and desperate for excitement. That's why I'm out here now.", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("No harm in that, long as ya keep your neck, right?", SCHAR_TORRIN, EMOTE_HAPPY, 64, YPOS_LOWER);
				PlayStringAndWait("That was the exact opposite of his point.", SCHAR_KAYLANI, EMOTE_SWEAT, 64, YPOS_LOWER);
				PlayStringAndWait("But you're right, in a way. Long as we're careful an' avoid stupid stuff like this, no use leadin' a boring life.", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("That's the spirit!@delay(60) I think...", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Hey Siyed, don't suppose you could use another set a' hands explorin' those ruins a' yours.", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Are you kidding? I'd love some company!", SCHAR_SIYED, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Perfect. Thanks for doing this for me, everyone. I really appreciate it.", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_LOWER);
				SetFFCDir(Terry, DIR_RIGHT, false);
				WaitNoAction(20);
				SetFFCDir(Torrin, DIR_LEFT, false);
				WaitNoAction(20);
				PlayStringAndWait("An' thanks for the help, Torrin. I'm sorry for bein' so harsh towards ya lately. I meant to get an augment for your trouble, but I'm not sure anyone but Kaylani can use the one I found.", SCHAR_TERRY, EMOTE_EMBARRASSED, 64, YPOS_LOWER);
				PlayStringAndWait("Pft, that ain't any trouble. Anythin' that makes her stronger is only bound to keep me alive longer. Thanks, sis. Good luck out there.", SCHAR_TORRIN, EMOTE_HAPPY, 64, YPOS_LOWER);
				ClearFFC(Asher);
				ClearFFC(Torrin);
				ClearFFC(Kaylani);
				ClearFFC(Siyed);
				ClearFFC(Terry);
				for(int i = 0; i<60; i++){
					BlackScreenLayerSix();
					WaitNoAction();
				}
				Link->Invisible = false;
				Link->X = 120;
				Link->Y = 48;
				AugmentGet(201);
				Game->Counter[CR_SMALLSIDEQUESTS1] = Game->Counter[CR_SMALLSIDEQUESTS1] & ~BF_13;
				Game->Counter[CR_NIGHTMARCHERQUEST] = 7;
				
				for(int i = 0; i<240; i++){
					l2->ComboD[ComboAt(i, 0)] = 0;
					l2->ComboD[ComboAt(i, 160)] = 0;
				}
				for(int i = 0; i<160; i++){
					l2->ComboD[ComboAt(0, i)] = 0;
					l2->ComboD[ComboAt(240, i)] = 0;
				}
			}
		}
		if(JankSelector == 46){ //NPC Nightmarchers
			const int FLAMEDATA = 0;
			const int HOVERTIMER = 1;
			const int SPRITEFRAME = 2;
			const int FLASHTIMER = 3;
			int flameX[5]; 
			int flameY[5];
			int flameT[5];
			for(int i=0; i<5; ++i){
				flameX[i] = Rand(-4, 4);
				flameY[i] = Rand(-20, 4);
				flameT[i] = Rand(128);
			}
			int flame[] = {flameX, flameY, flameT};
			int vars[16];
			vars[FLAMEDATA] = flame;
			vars[HOVERTIMER] = Rand(360);
			vars[FLASHTIMER] = Rand(48);
			int Z = 2;
			int combo = 51776;
			int dir;
			int xOff;
			int yOff;
			while(true){
				dir = this->Data%4;
				int flame = vars[FLAMEDATA];
				
				int flameX = flame[0];
				int flameY = flame[1];
				int flameT = flame[2];
				
				int flashStep = 1;
				
				vars[HOVERTIMER] = (vars[HOVERTIMER]+1)%360;
				vars[FLASHTIMER] = (vars[FLASHTIMER]+flashStep)%48;
				Z = 2+1*Sin(vars[HOVERTIMER]*2);
				
				for(int i=0; i<5; ++i){
					int t = Floor(flameT[i]/4);
					if(t<7){
						Screen->FastTile(4, this->X+flameX[i]+xOff, this->Y+flameY[i]-Z+yOff, TIL_NIGHTMARCHERFLAME+6-t, 10, 128);
					}
					else if(t<12){
						Screen->FastTile(4, this->X+flameX[i]+xOff, this->Y+flameY[i]-Z+yOff, TIL_NIGHTMARCHERFLAME+2+(t-7), 10, 128);
					}
					flameT[i] = (flameT[i]+1)%128;
				}
				
				if(this->Data>=combo+4 && this->Data <= combo+7){
					combodata cd = Game->LoadComboData(this->Data);
					int frame = cd->Tile-cd->OriginalTile;
					if(frame!=vars[SPRITEFRAME]){
						if(frame==1){
							int xy[2];
							GetDirXYOffset(xy, dir, {10,14, 6,15, 5,15, 11,15});
							lweapon l = ParticleAnim(this->X+xy[0]-8+xOff, this->Y+xy[1]-8-Z+yOff, TIL_NIGHTMARCHERIMPACT, 7, 4, 4);
							l->DrawStyle = DS_PHANTOM;
						}
						else if(frame==3){
							int xy[2];
							GetDirXYOffset(xy, dir, {5,14, 9,15, 11,15, 5,15});
							lweapon l = ParticleAnim(this->X+xy[0]-8+xOff, this->Y+xy[1]-8-Z+yOff, TIL_NIGHTMARCHERIMPACT, 7, 4, 4);
							l->DrawStyle = DS_PHANTOM;
						}
					}
					vars[SPRITEFRAME] = frame;
				}
				
				int frame = Floor(vars[FLASHTIMER]/8);
				this->InitD[2] = 0;
				if(frame==0)
					this->InitD[2] = 1;
				
				if(this->InitD[1]==1){
					frame = 0;
				}
				else if(this->InitD[1]==2){
					frame = 1;
				}
				else if(this->InitD[1]==3){
					frame = 2;
				}
				else if(this->InitD[1]==4){
					frame = 3;
				}
				if(frame==0)
					Screen->DrawCombo(2, this->X+xOff, this->Y-16-Z+yOff, this->Data, 1, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 128);
				else if(frame==1||frame==5){
					Screen->DrawCombo(2, this->X+xOff, this->Y-16-Z+yOff, this->Data, 1, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 64);
					Screen->DrawCombo(2, this->X+xOff, this->Y-16-Z+yOff, this->Data, 1, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 64);
				}
				else if(frame==2||frame==4)
					Screen->DrawCombo(2, this->X+xOff, this->Y-16-Z+yOff, this->Data, 1, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 64);	
				
				Waitframe();
			}
		}
		if(JankSelector == 47){ //Silver Totem
			int i; int j; int k;
			
			mapdata l1 = Game->LoadTempScreen(1);
			mapdata l3 = Game->LoadTempScreen(3);
			l3->ComboD[73] = 11558;
			l3->ComboD[74] = 11559;
			l3->ComboD[89] = 11562;
			l3->ComboD[90] = 11563;
			l1->ComboD[105] = 11566;
			l1->ComboD[106] = 11567;
			if(Game->Counter[CR_CHASEQUEST]>=7){
				l3->ComboD[73] = 0;
				l3->ComboD[74] = 0;
				l3->ComboD[89] = 0;
				l3->ComboD[90] = 0;
				l1->ComboD[89] = 11652;
				l1->ComboD[90] = 11653;
				l1->ComboD[105] = 11656;
				l1->ComboD[106] = 11657;
				Quit();
			}
			Waitframe();
			while(true){
				if(Link->Dir == DIR_UP && Link->Y >= this->Y + 8 && Link->Y <= this->Y + 24 && Link->X >= this->X - 8 && Link->X <= this->X + 8){
					Screen->FastCombo(6, this->X, this->Y-16-8, CMB_CANTALK, 0, 128);
					if(Link->PressA){
						Link->PressA = false;
						Link->InputA = false;
						if(Game->Counter[CR_CHASEQUEST]<6){
							PlayStringAndWait("...", SCHAR_TOTEM, EMOTE_NORMAL);
						}
						else{
							if((Game->Counter[CR_TOTALHYMNSTONES]>=100&&CheckHymnstoneCompletion())||(Game->Counter[CR_TOTALHYMNSTONES]==0&&G[G_CHASELOWPERCENTMET])){
								int str[512];
								bool paid;
								if(Game->Counter[CR_TOTALHYMNSTONES]==0&&G[G_CHASELOWPERCENTMET]){
									PlayStringAndWait("Fools are the three, their hands lie empty, victory they shall never now see. The pact of pain sealed, what's done has been done, let these three now burn in the light of the sun.", SCHAR_TOTEM, EMOTE_ELLIPSES);
									PlayStringAndWait("Well that wasn't at all ominous...", SCHAR_ASHER, EMOTE_DISMAYED);
									paid = true;
								}
								else{
									sprintf(str, "My brothers have been paid in full, now relinquish the remaining %d stones.", Game->Counter[CR_HYMNSTONES]);
									PlayStringAndWait(str, SCHAR_TOTEM, EMOTE_NORMAL);
								
									int Affirm[] = "Yes";
									int Deny[] = "No";
									int Options[] = {Affirm, Deny};
									int handler[6];
									while(handler[1] == 0){
										DialogueBox_RunSingleFrame(handler, 128, 8+52, Options, TIL_DB_DIALOGUE_BOX, CS_DB_DIALOGUE_BOX, C_DB_DIALOGUE_BOX_BG, FONT_P, 0xB2, TIL_DB_DIALOGUE_SELECTOR, CS_DB_DIALOGUE_SELECTOR);
										WaitNoAction();
										// G[G_NOACTION] = 1;
										// Waitframe();
									}
									if(handler[0] == 0){
										paid = true;
									}
									else{
										PlayStringAndWait("Greedy though you three may be, the Light of the Heavens ne'er shall you see.", SCHAR_TOTEM, EMOTE_NORMAL);
									}
								}
								if(paid){
									Game->PlayMIDI(0);
									Game->MCounter[CR_HYMNSTONES] = 100;
									Game->DCounter[CR_HYMNSTONES] = -Game->Counter[CR_HYMNSTONES];
									while(Game->Counter[CR_HYMNSTONES]>0){
										WaitNoAction();
									}
									Cutscene_Init(RT_BITMAP1, RT_BITMAP2);
									Cutscene_AnchorCamera(0x09, 0x09, 3, 1);
									
									int plyr = Cutscene_NewNPC(2, Link->X, Link->Y, 51000, 6, 128);
									Cutscene_SetDir(plyr, DIR_UP);
									if(GetCharID()==CHAR_TORRIN)
										Cutscene_SetNPCGraphic(plyr, 50952, false);
									else if(GetCharID()==CHAR_KAYLANI)
										Cutscene_SetNPCGraphic(plyr, 50960, false);
									Cutscene_SetFlag(plyr, CGF_4WAY|CGF_BIGNPC|CGF_BS);
									int firstPillar = Cutscene_NewTile(1, 144+1, 64+1, 31989, 2, 3, 4, -1, -1, 0, 0, 0, 0, true, 128);
									Cutscene_MakeImmortal(firstPillar);
									if(Screen->State[ST_SECRET]){
										int l1 = Cutscene_NewFastCombo(3, 80, 80, 5809, 4, OP_OPAQUE);
										int l2 = Cutscene_NewFastCombo(3, 80, 96, 5813, 4, OP_OPAQUE);
										Cutscene_SetAttr(l1, CGI_DRAWLIFESPAN, -1);
										Cutscene_SetAttr(l2, CGI_DRAWLIFESPAN, -1);
									}
									
									item itm;
									if(Screen->NumItems()>0)
										itm = Screen->LoadItem(1);
									
									for(j=0; j<32; ++j){
										if(itm->isValid()){
											Cutscene_NewFastTile(2, itm->X+itm->DrawXOffset, itm->Y+itm->DrawYOffset, itm->Tile, itm->CSet, 128);
										}
										Cutscene_Waitframe();
									}
									for(i=0; i<4; ++i){
										Game->PlaySound(84);
										Cutscene_SetDrawGraphic(firstPillar, 31989+2+i*2, 4);
										for(j=0; j<32; ++j){
											if(itm->isValid()){
												Cutscene_NewFastTile(2, itm->X+itm->DrawXOffset, itm->Y+itm->DrawYOffset, itm->Tile, itm->CSet, 128);
											}
											Cutscene_Waitframe();
										}
									}
									for(j=0; j<64; ++j){
										if(itm->isValid()){
											Cutscene_NewFastTile(2, itm->X+itm->DrawXOffset, itm->Y+itm->DrawYOffset, itm->Tile, itm->CSet, 128);
										}
										Cutscene_Waitframe();
									}
									
									int pillar[6];
									int pillarX[6];
									int pillarY[6];
									int pillarT[6];
									int pillarBeacon[6];
									for(i=0; i<6; ++i){
										pillarX[i] = 256+48+80*i;
										pillarY[i] = 80;
										pillarT[i] = -48-32*i;
									}
									
									Cutscene_SetCameraTarget(0x0B, 2.5);
									for(j=0; j<300; ++j){
										if(itm->isValid()){
											Cutscene_NewFastTile(2, itm->X+itm->DrawXOffset, itm->Y+itm->DrawYOffset, itm->Tile, itm->CSet, 128);
										}
										for(i=0; i<6; ++i){
											++pillarT[i];
											if(pillarT[i]==0){
												Game->PlaySound(85);
												int puddle = Cutscene_NewCombo(1, pillarX[i]-8, pillarY[i]+4, 11654, 2, 1, 4, -1, -1, 0, 0, 0, -1, 0, true, 128);
												Cutscene_MakeImmortal(puddle);
												pillar[i] = Cutscene_NewTile(1, pillarX[i]-8, pillarY[i]-32, 31997, 2, 3, 4, -1, -1, 0, 0, 0, 0, true, 128);
												Cutscene_MakeImmortal(pillar[i]);
												int splash = Cutscene_NewAnim(2, pillarX[i]-16, pillarY[i]-32, 54640, 3, 3, 4, -1, -1, 0, 0, 0, 0, true, 128, 9, 2);
											}
											else if(pillarT[i]>0&&pillarT[i]%4==0&&pillarT[i]<20){
												Cutscene_AddAttr(pillar[i], CGI_GFX, -2);
											}
										}
										Cutscene_Waitframe();
									}
									for(i=0; i<6; ++i){
										Game->PlaySound(86);
										pillarBeacon[i] = Cutscene_NewCombo(4, pillarX[i]-8, 0, 11655, 2, 4, 0, -1, -1, 0, 0, 0, -1, 0, true, 128);
										Cutscene_MakeImmortal(pillarBeacon[i]);
										Cutscene_Waitframe(8);
									}
									Cutscene_Waitframe(32);
									for(i=0; i<24; ++i){
										Cutscene_NewRectangle(6, 512, 0, 512+256, 176, 0x0F, 1, 0, 0, 0, true, 64);
										if(i>=8)
											Cutscene_NewRectangle(6, 512, 0, 512+256, 176, 0x0F, 1, 0, 0, 0, true, 64);
										if(i>=16)
											Cutscene_NewRectangle(6, 512, 0, 512+256, 176, 0x0F, 1, 0, 0, 0, true, 128);
										Cutscene_Waitframe();
									}
									l3->ComboD[73] = 0;
									l3->ComboD[74] = 0;
									l3->ComboD[89] = 0;
									l3->ComboD[90] = 0;
									l1->ComboD[89] = 11652;
									l1->ComboD[90] = 11653;
									l1->ComboD[105] = 11656;
									l1->ComboD[106] = 11657;
									for(i=23; i>=0; --i){
										Screen->Rectangle(6, 0, 0, 256, 176, 0x0F, 1, 0, 0, 0, true, 64);
										if(i>=8)
											Screen->Rectangle(6, 0, 0, 256, 176, 0x0F, 1, 0, 0, 0, true, 64);
										if(i>=16)
											Screen->Rectangle(6, 0, 0, 256, 176, 0x0F, 1, 0, 0, 0, true, 128);
										WaitNoAction();
									}
									
									Game->Counter[CR_CHASEQUEST] = 7;
									Game->PlayEnhancedMusic("SS-PeacefulIsles.ogg", 0);
									Quit();
								}
							}
							else{
								if(G[G_HYMNSTONEDEBT] == 1)
									PlayStringAndWait("100 stones lie scattered. 85 my brothers require. Bring me the 15 remainder if passage is desired.", SCHAR_TOTEM, EMOTE_NORMAL);
								else
									PlayStringAndWait("100 stones lie scattered. 84 my brothers require. Bring me the 16 remainder if passage is desired.", SCHAR_TOTEM, EMOTE_NORMAL);
							}
						}
					}
				}
				Waitframe();
			}
		}
		if(JankSelector == 48){ //Fishing hook animation for the mist temple cutscene
			ffc Asher;
			ffc Kaylani;
			for(int i = 1; i<32; i++){
				ffc f = Screen->LoadFFC(i);
				if(f->Misc[0] == CMB_ASHER)
					Asher = f;
				if(f->Misc[0] == CMB_KAYLANI)
					Kaylani = f;
			}
			this->Misc[0] = CMB_TORRIN;
			SetFFCDir(this, DIR_LEFT, true);
			while(this->X > 64){
				this->X -= 2;
				G[G_NOACTION] = 1;
				Waitframe();
			}
			SetFFCDir(this, DIR_RIGHT, false);
			
			//Ever just duplicate an entire item animation cuz you're bad at cutscenes?
			int dir = DIR_RIGHT;
			int rodX = this->X+DirX(DIR_RIGHT, 16);
			int rodY = this->Y+16+DirY(DIR_RIGHT, 16);
			int hookX = this->X+DirX(DIR_RIGHT, 16);
			int hookY = this->Y+16+DirY(DIR_RIGHT, 16);
			int hookJump = 2.4;
			int hookZ;
			int tipXY[2];
			for(int i=0; i<3; ++i){
				for(int j=0; j<4; ++j){
					DrawFishingRod(DIR_RIGHT, this->X, this->Y+16, i, tipXY, hookX, hookY, hookZ, false);
					if(i==2){
						this->Data = 33864;
					}
					G[G_NOACTION] = 1;
					Waitframe();
				}
			}
			hookX = tipXY[0]-8;
			hookY = tipXY[1]-8;
			Game->PlaySound(SFX_JUMP);
			
			while(hookJump>0||hookZ>0){
				
				rodX = this->X+DirX(DIR_RIGHT, 16);
				rodY = this->Y+16+DirY(DIR_RIGHT, 16);
				hookZ = Max(0, hookZ+hookJump);
				hookJump = Clamp(hookJump-0.24, -3.2, 3.2);
				hookX += DirX(dir, 3);
				hookY += DirY(dir, 3);
				
				DrawFishingRod(DIR_RIGHT, this->X, this->Y+16, 2, tipXY, hookX, hookY, hookZ, true);
				this->Data = 33864;
				G[G_NOACTION] = 1;
				Waitframe();
			}
			npc target;
			int grabType;
			this->Data = CMB_TORRIN+DIR_RIGHT;
			int timer;
			int withdrawspeed = 3;
			int frametimemult = 6 / withdrawspeed;
			while(Distance(hookX, hookY, rodX, rodY)>6){
				timer++;
				if(timer == 2*frametimemult)
					Kaylani->Data = 33867;
				if(timer == 4*frametimemult)
					Asher->Data = 33866;
				rodX = this->X+DirX(DIR_RIGHT, 16);
				rodY = this->Y+16+DirY(DIR_RIGHT, 16);
				int angle = Angle(hookX, hookY, rodX, rodY);
				hookX += VectorX(withdrawspeed, angle);
				hookY += VectorY(withdrawspeed, angle);
				if(timer>=2*frametimemult){
					Kaylani->X += VectorX(withdrawspeed, angle);
					// Kaylani->Y += VectorY(withdrawspeed, angle);
				}
				if(timer>=4*frametimemult){
					Asher->X += VectorX(withdrawspeed, angle);
					// Asher->Y += VectorY(withdrawspeed, angle);
				}
				DrawFishingRod(DIR_RIGHT, this->X, this->Y+16, 1, tipXY, hookX, hookY, hookZ, true);
				Waitframe();
			}
			// Kaylani->Data = CMB_KAYLANI+DIR_RIGHT;
			// Asher->Data = CMB_ASHER+DIR_RIGHT;
			Kaylani->Data = 51128;
			Asher->Data = 51142;
			for(int j=0; j<4; ++j){
				DrawFishingRod(DIR_RIGHT, this->X, this->Y+16, 0, tipXY, hookX, hookY, hookZ, false);
				Waitframe();
			}
			SetFFCDir(this, DIR_RIGHT, true);
			while(this->X > 48){
				this->X--;
				Waitframe();
			}
			SetFFCDir(this, DIR_RIGHT, false);
			Waitframes(30);
			Kaylani->Data = CMB_KAYLANI+DIR_RIGHT;
			SetFFCDir(Asher, DIR_RIGHT, true);
			while(Asher->X > 64){
				Asher->X--;
				Waitframe();
			}
			SetFFCDir(Asher, DIR_RIGHT, false);
			SetFFCDir(Kaylani, DIR_RIGHT, true);
			while(Kaylani->X > 80){
				Kaylani->X--;
				Waitframe();
			}
			SetFFCDir(Kaylani, DIR_RIGHT, false);
		}
		if(JankSelector == 49){ //Closed door, in its own script to avoid bugs with running the cutscene script at screen init
			if(Game->Counter[CR_STORYFLAG] == SFLAG_MISTENTERED){
				Screen->ComboD[151] = 24490;
				Screen->ComboD[152] = 24491;
				Screen->ComboD[167] = 24494;
				Screen->ComboD[168] = 24495;
			}
		}
		if(JankSelector == 50){
			if(G[G_RANDOMIZERENABLED]){
				if(!Screen->State[ST_BOSSLOCKBLOCK]){
					mapdata l2 = Game->LoadTempScreen(2);
					npc esan;
					int k;
					if(Link->Y<24){
						esan = CreateNPCAt(242, 120, 120);
						while(Link->Y<24){
							NoAction();
							Link->InputDown = true;
							Waitframe();
						}
						Game->PlaySound(126);
						for(int i=0; i<5; ++i){
							for(int j=20; j<=27; ++j){
								l2->ComboD[j] = 10661+k;
								l2->ComboD[j-16] = 10657+k;
							}
							++k;
							if(i==2)
								k += 4;
							Waitframes(2);
						}
					}
					else{
						esan = CreateNPCAt(242, 120, 40);
						for(int j=20; j<=27; ++j){
							l2->ComboD[j] = 10669;
							l2->ComboD[j-16] = 10665;
						}
					}
			
					while(esan->isValid()){
						Waitframe();
					}
					Game->PlayMIDI(0);
					k = 8;
					Game->PlaySound(126);
					for(int i=0; i<6; ++i){
						for(int j=20; j<=27; ++j){
							l2->ComboD[j] = 10661+k;
							l2->ComboD[j-16] = 10657+k;
						}
						--k;
						if(i==1)
							k -= 4;
						Waitframes(2);
					}
					Screen->State[ST_BOSSLOCKBLOCK] = true;
				}
				Quit();
			}
			mapdata l2 = Game->LoadTempScreen(2);
			if(Game->Counter[CR_STORYFLAG] == SFLAG_MISTENTERED){
				CreateNPCAt(242, 120, 40);
				if(Distance(Link->X, Link->Y, this->X, this->Y)<16){
					for(int i=0; i<8; ++i){
						l2->ComboD[4+i] = 10665;
						l2->ComboD[20+i] = 10669;
					}
					Waitframes(10);
					while(Screen->NumNPCs()>0){
						Waitframe();
					}
					Link->WarpEx({WT_IWARPBLACKOUT, 67, 0x52, -1, 2, 0, 0, WARP_FLAG_PLAYMUSIC});
				}
			}
		}
		if(JankSelector == 51){ //Temple exit cave progression
			if(Game->GetCurDMap()==68){
				if(Game->Counter[CR_STORYFLAG]<SFLAG_MISTCLEAR){
					Screen->SetSideWarp(0, 0x52, 67, WT_NOWARP);
					while(true){
						if(Link->Y<8){
							PlayStringAndWait("The others will be fine. We need to hurry back to Hoku Village.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
							while(Link->Y<16){
								NoAction();
								Link->InputDown = true;
								Waitframe();
							}
						}
						Waitframe();
					}
				}
			}
			else{
				if(Game->Counter[CR_STORYFLAG]<SFLAG_MISTCLEAR){
					Game->Counter[CR_STORYFLAG] = SFLAG_MISTCLEAR;
				}
			}
		}
		if(JankSelector == 52){ //Handles the disguises for Micah's quest
			if(Game->Counter[CR_CULTISTQUEST] >= 3 && Game->Counter[CR_CULTISTQUEST] < 6){ 
				G[G_ASHERCOSTUME] = 1;
				G[G_TORRINCOSTUME] = 1;
				G[G_KAYLANICOSTUME] = 1;
			}
		}
		if(JankSelector == 53){ //Item popups
			switch(d1){
				case 1:
					AbilityPopup(128, 88, "Lob bombs will bounce off walls. Toss next to each other and the detonation from one will send the others flying.", TIL_DB_DIALOGUE_BOX, CS_DB_DIALOGUE_BOX, C_DB_DIALOGUE_BOX_BG, FONT_P, 0xB2, 70540, 3, 2, 70544, 3, 2);
					break;
				case 2:
					for(int i = Screen->NumNPCs(); i >0; i--){
						npc enemy = Screen->LoadNPC(i);
						enemy->Stun = 70;
					}
					WaitNoAction(70);
					AbilityPopup(128, 88, "Hold to push or pull yourself from tidally-locked objects. Release and press again to change polarities. Can also pull lighter objects towards you.", TIL_DB_DIALOGUE_BOX, CS_DB_DIALOGUE_BOX, C_DB_DIALOGUE_BOX_BG, FONT_P, 0xB2, 70548, 3, 2, 70610, 1, 4);
					break;
				case 3:
					AbilityPopup(128, 88, "Fire blasts of stellar magic that push star blocks. Hold the button and hold a direction to redirect. Shots can be redirected up to five times. Shot damage increases with each redirect.", TIL_DB_DIALOGUE_BOX, CS_DB_DIALOGUE_BOX, C_DB_DIALOGUE_BOX_BG, FONT_P, 0xB2, 70556, 3, 6, 70552, 3, 2);
					AbilityPopup(128, 88, "Hitting a wall at a diagonal will cause the shot to redirect an additional time. This is useful for fitting into tight spaces and does not count towards the 5 redirect limit.", TIL_DB_DIALOGUE_BOX, CS_DB_DIALOGUE_BOX, C_DB_DIALOGUE_BOX_BG, FONT_P, 0xB2, 71133, 3, 3, 71137, 3, 3);
					//AbilityPopup(int x, int y, int str, int tileDB, int csDB, int colorDB, int font, int cFont, int tile, int tw, int th, int tile2, int tw2, int th2){
					break;
				case 4:
					AbilityPopup(128, 88, "Hold the button to hold the boomerang in place and charge lunar magic. While held in place, it will dispel mist.", TIL_DB_DIALOGUE_BOX, CS_DB_DIALOGUE_BOX, C_DB_DIALOGUE_BOX_BG, FONT_P, 0xB2, 70600, 4, 3, 0, 0, 0);
					break;
				case 5:
					AbilityPopup(128, 88, "Asher can now dash over pits. Hold the button to bounce off walls. Diagonal wall bounces can be chained together as long as the button is held.", TIL_DB_DIALOGUE_BOX, CS_DB_DIALOGUE_BOX, C_DB_DIALOGUE_BOX_BG, FONT_P, 0xB2, 70605, 4, 4, 0, 0, 0);
					break;
				case 6:
					AbilityPopup(128, 88, "Guess what? You found NOTHING! Wow! With this you can do absolutely zip! Oh but that's not all. When this message string closes, you're going to fall in the pit. You've gotta go back. All the way back. Do it again. @26@26You can thank Evan for this one.", TIL_DB_DIALOGUE_BOX, CS_DB_DIALOGUE_BOX, C_DB_DIALOGUE_BOX_BG, FONT_P, 0xB2, 71500, 4, 1, 71540, 2, 2);
					break;
				default:
					break;
			}
		}
		if(JankSelector == 54){
			if(Game->Counter[CR_STORYFLAG] == 0 && G[G_HOURCLAMP] == 11){
				G[G_HOURCLAMP] = 16;
				G[G_MINUTECLAMP] = 29;
			}
		}
		if(JankSelector == 55){ //Level 2 power meters
			int dir = this->Data%4;
			while(true){
				int ang = DirAngle(dir)+90;
				int til = 67588; 
				if(G[G_TIMER1MAX+d1*2]>0)
					til = Round(Lerp(67588, 67581, Clamp(G[G_TIMER1+d1*2]/G[G_TIMER1MAX+d1*2], 0, 1)));
				Screen->DrawTile(2, this->X, this->Y, til, 1, 1, 3, -1, -1, this->X, this->Y, ang, 0, true, 128);
				Waitframe();
			}
		}
		if(JankSelector == 56){ //That one chest in the observatory
			if(!Screen->isSolid(this->X+7, this->Y+7)){
				while(!Screen->isSolid(this->X+7, this->Y+7)){
					Waitframe();
				}
				if(RectCollision(Link->X, Link->Y+8, Link->X+15, Link->Y+15, this->X, this->Y, this->X+15, this->Y+15)){
					Link->Y = this->Y+8;
				}
			}
		}
		if(JankSelector == 57){ //Final boss screen drawing, becuase the screen needed to shake
			bitmap l1 = Game->CreateBitmap(272, 192);
			l1->Clear(0);
			l1->DrawLayer(0, Game->GetCurMap(), Game->GetCurScreen(), 1, 8, 8, 0, 128);
			l1->DrawLayer(0, Game->GetCurMap(), Game->GetCurScreen(), 1, 8-256, 8, 0, 128);
			l1->DrawLayer(0, Game->GetCurMap(), Game->GetCurScreen(), 1, 8+256, 8, 0, 128);
			l1->DrawLayer(0, Game->GetCurMap(), Game->GetCurScreen(), 2, 8, 8, 0, 128);
			
			l1->Own();
			Screen->D[7] = 0;
			while(true){
				Screen->LayerInvisible[1] = false;
				Screen->LayerInvisible[2] = false;
				while(!Screen->D[7]){
					Waitframe();
				}
				Screen->LayerInvisible[1] = true;
				Screen->LayerInvisible[2] = true;
				while(Screen->D[7]){
					l1->Blit(1, RT_SCREEN, 8+Rand(-4, 4), 8+Rand(-4, 4), 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
					Waitframe();
				}
			}
		}
		if(JankSelector == 58){ //Winno NPC
			if(G[G_RANDOMIZERENABLED]){
				ffc NewFFC = FindFreeFFC();
				NewFFC->X = 64;
				NewFFC->Y = 112-16;
				NewFFC->TileHeight = this->TileHeight;
				NewFFC->Data = 33794;
				NewFFC->Script = 38;
				NewFFC->InitD[0] = 108;
				NewFFC->InitD[1] = 74;
			}
			else if(Game->Counter[CR_STORYFLAG] == SFLAG_POSTGRANDMA || Game->Counter[CR_STORYFLAG] == SFLAG_ALIIOPEN || (Game->Counter[CR_STORYFLAG] == SFLAG_GAMECLEAR && Screen->State[ST_SECRET] == true)){
				ffc NewFFC = FindFreeFFC();
				NewFFC->X = this->X;
				NewFFC->Y = this->Y-16;
				NewFFC->TileHeight = this->TileHeight;
				NewFFC->Data = 33792;
				NewFFC->Script = 38;
				NewFFC->InitD[0] = 108;
				NewFFC->InitD[1] = 74;
			}
		}
		if(JankSelector == 59){ //Clear enemies for postgame
			if(Game->Counter[CR_STORYFLAG] >= SFLAG_GAMECLEAR){
				for(int i=0; i<10; ++i){
					Screen->Enemy[i] = 0;
				}
			}
		}
		if(JankSelector == 60){ //Shooting Stars
			int starPos[16] = {8,-16,  36,-4,  97,0,  109,16,  150,-20,  164,19,  171,-8,  221,-3};
			int starT[8];
			for(int i=0; i<8; ++i){
				starT[i] = Rand(-8, -48);
			}
			int nextStar = Rand(8);
			while(true){
				if(starT[nextStar]>=0){
					Screen->DrawTile(0, starPos[nextStar*2+0], starPos[nextStar*2+1], 70140+Floor(starT[nextStar]/8)*2, 2, 2, 7, -1, -1, 0, 0, 0, 0, true, 128);
				}
				++starT[nextStar];
				if(starT[nextStar]>=64){
					starT[nextStar] = Rand(-8, -48);
					int lastStar = nextStar;
					do{
						nextStar = Rand(8);
					}while(lastStar==nextStar)
				}
				Waitframe();
			}
		}
		if(JankSelector == 61){ //Phantom Tree
			int LinkX = Link->X;
			int LinkY = Link->Y;
			if(LinkX==0)
				LinkX = 240;
			else if(LinkX==240)
				LinkX = 0;
			if(LinkY==0)
				LinkY = 160;
			else if(LinkY==160)
				LinkY = 0;
			
			bool visible = true;
			int fadeTimer = 0;
			mapdata l3 = Game->LoadTempScreen(3);
			int pos = ComboAt(this->X+8, this->Y+8);
			if(LinkX>=this->X-16&&LinkY>=this->Y&&LinkX<=this->X+32&&LinkY<=this->Y+24){
				visible = false;
				l3->ComboD[pos] = 0;
				l3->ComboD[pos+1] = 0;
				Screen->ComboD[pos+16] = 66;
				Screen->ComboD[pos+17] = 66;
			}
			Waitframe();
			while(true){
				if(Link->X>=this->X-16&&Link->Y>=this->Y&&Link->X<=this->X+32&&Link->Y<=this->Y+24){
					if(visible){
						Game->PlaySound(56);
						visible = false;
						fadeTimer = 8;
					}
				}
				else{
					if(!visible){
						visible = true;
						fadeTimer = 8;
					}
				}
				if(fadeTimer||!visible){
					l3->ComboD[pos] = 0;
					l3->ComboD[pos+1] = 0;
					Screen->ComboD[pos+16] = 66;
					Screen->ComboD[pos+17] = 66;
				}
				else{
					l3->ComboD[pos] = 1120;
					l3->ComboD[pos+1] = 1121;
					Screen->ComboD[pos+16] = 1140;
					Screen->ComboD[pos+17] = 1141;
				}
				if(fadeTimer){
					Screen->DrawTile(0, this->X, this->Y, 13788, 2, 1, 3, -1, -1, 0, 0, 0, 0, true, 64);
					Screen->DrawTile(0, this->X, this->Y+16, 14028, 2, 1, 3, -1, -1, 0, 0, 0, 0, true, 64);
					--fadeTimer;
				}
				Waitframe();
			}
		}
		if(JankSelector == 62){ //Burn Vine
			if(!Screen->State[ST_SECRET]){
				int posX = ComboX(d1);
				int posY = ComboY(d1);
				int tX = ComboX(d2);
				int tY = ComboY(d2);
				mapdata l1 = Game->LoadTempScreen(1);
				int x = posX;
				int y = posY;
				bool lit;
				while(!lit){
					for(int i=Screen->NumLWeapons(); i>0; --i){
						lweapon l = Screen->LoadLWeapon(i);
						if((l->ID==LW_FIRE||l->Weapon==LW_FIRE)&&RectCollision(l->X+4, l->Y+4, l->X+11, l->Y+11, posX, posY, posX+15, posY+15)){
							lit = true;
							break;
						}
					}
					Waitframe();
				}
				Game->PlaySound(88);
				l1->ComboD[d1] = 40735;
				Screen->State[ST_SECRET] = true;
				int i = 0;
				while(Distance(x, y, tX, tY)>1){
					int ang = Angle(x, y, tX, tY);
					x += VectorX(1, ang);
					y += VectorY(1, ang);
					if(i%8==0){
						lweapon l = CreateLWeaponAt(LW_FIRE, x+Rand(-4, 4), y+Rand(-4, 4));
						Game->PlaySound(SFX_FIRE);
						l->Step = 0;
						l->UseSprite(12);
						l->CollDetection = false;
						
						int x2 = x+8+VectorX(8, ang+180);
						int y2 = y+8+VectorY(8, ang+180);
						if(l1->ComboD[ComboAt(x2, y2)]==6086){
							l1->ComboD[ComboAt(x2, y2)] = 0;
						}
					}
					++i;
					Waitframe();
				}
				for(i=0; i<96; ++i){
					if(i%4==0){
						lweapon l = CreateLWeaponAt(LW_FIRE, this->X+Rand(-4, this->EffectWidth-12), this->Y+Rand(-4, this->EffectHeight-12));
						Game->PlaySound(SFX_FIRE);
						l->Step = 0;
						l->UseSprite(12);
						l->CollDetection = false;
						if(i>80&&Screen->ComboD[ComboAt(x+8, y+8)]==499){
							Screen->ComboD[ComboAt(x+8, y+8)] = 329;
						}
					}
					Waitframe();
				}
				Screen->TriggerSecrets();
			}
		}
		if(JankSelector == 63){ //Evan
			int til = -1; 
			int targetTil = -1;
			int frames;
			while(true){
				if(Distance(this->X, this->Y+16, Link->X, Link->Y)<32)
					targetTil = 5;
				else
					targetTil = -1;
				
				if(frames>0){
					--frames;
				}
				else{
					if(til!=targetTil){
						if(til<targetTil){
							++til;
							frames = 8;
						}
						else{
							--til;
							frames = 8;
						}
					}
				}
				
				if(til>=0){
					Screen->FastTile(4, this->X, this->Y, 108174+til, 0, 128);
				}
				
				Waitframe();
			}
		}
		if(JankSelector == 64){ //Respawning Gem
			ffc gem = Screen->LoadFFC(d1);
			while(true){
				while(gem->Script==FFCS_MAGNETGEM){
					Waitframe();
				}
				Waitframes(120);
				int cmb = Choose(38406, 38407);
				Game->PlaySound(SFX_FALL);
				int z = 176;
				while(z>0){
					z -= 4;
					Screen->FastTile(0, this->X, this->Y, 832, 7, 64);
					Screen->FastCombo(4, this->X, this->Y-z, cmb, 0, 128);
					Waitframe();
				}
				gem->X = this->X;
				gem->Y = this->Y;
				gem->Data = cmb;
				gem->Script = FFCS_MAGNETGEM;
				gem->InitD[0] = 0;
				if(cmb==38406)
					gem->InitD[0] = 1;
			}
		}
		if(JankSelector == 65){
			while(true){
				if(Link->Y >= 152){
					if(Game->Counter[CR_HELPERQUEST] < 3){
						PlayStringAndWait("Want us to finish tellin' the story later?", SCHAR_TERRY, EMOTE_NORMAL);
						int Affirm[] = "Yes";
						int Deny[] = "No";
						int Options[] = {Affirm, Deny};
						int handler[6];
						while(handler[1] == 0){
							DialogueBox_RunSingleFrame(handler, 128, 8+52, Options, TIL_DB_DIALOGUE_BOX, CS_DB_DIALOGUE_BOX, C_DB_DIALOGUE_BOX_BG, FONT_P, 0xB2, TIL_DB_DIALOGUE_SELECTOR, CS_DB_DIALOGUE_SELECTOR);
							WaitNoAction();
							// G[G_NOACTION] = 1;
							// Waitframe();
						}
						if(handler[0] == 0){
							SidePartySwap(false);
							this->Data = CMB_AUTOWARPA;	
						}
						else{
							while(Link->Y > 128){
								NoInput();
								Link->InputUp = true;
								Link->PressUp = true;
								Waitframe();
							}
						}
						Waitframe();
						
					}
					else{
						SidePartySwap(false);
						this->Data = CMB_AUTOWARPB;
					}
				}
				Waitframe();
			}
		}
		if(JankSelector == 66){ //Makes the Undersea Pyramid entrance appear
			if(Game->Counter[CR_HELPERQUEST] < 1)
				Quit();
			Screen->TriggerSecrets();
			Screen->State[ST_SECRET] = true;
			Waitframes(10);
			while(true){
				if(Distance(Link->X, Link->Y, this->X, this->Y) <= 6){
					SidePartySwap(true);
					this->Data = CMB_AUTOWARPD;
				}
				Waitframe();
			}
		}
		if(JankSelector == 67){
			if(G[G_RANDOMIZERENABLED])
				Quit();
			if(G[G_STUPIDSIDEQUESTPOPUPDELAY] == 0){
				G[G_STUPIDSIDEQUESTPOPUPDELAY] = 1;
				Waitframes(210);
				PopupNotify(3); //New Quest
				G[G_STUPIDSIDEQUESTPOPUPDELAY] = -1;
			}
			else
				G[G_STUPIDSIDEQUESTPOPUPDELAY] = -1;
				
		}
		if(JankSelector == 68){ //Reset Chase Difficulty
			G[G_CHASEDIFF] = -1; //Wow what a script
			if(G[G_CHASEREFIGHT]){
				ffc stairs = Screen->LoadFFC(1);
				stairs->Data = 0;
				Screen->ComboD[138] = 4238;
				Screen->ComboD[139] = 4239;
				Screen->ComboD[154] = 4242;
				Screen->ComboD[155] = 4243;
				if(!Link->Item[29]&&!Link->Item[30]){
					itemsprite regen = CreateItemAt(29, 208, 96);
					regen->Pickup = IP_HOLDUP;
					itemsprite revive = CreateItemAt(30, 176, 80);
					revive->Pickup = IP_HOLDUP;
					while(regen->isValid()&&revive->isValid()){
						Waitframe();
					}
					if(regen->isValid())
						regen->Remove();
					if(revive->isValid())
						revive->Remove();
				}
			}
			else{
				Screen->TriggerSecrets();
				Screen->State[ST_SECRET] = true;
			}
		}
		if(JankSelector == 69){ //Nice
			if(G[G_RANDOMIZERENABLED]&&G[G_RANDOMIZERMODE]==1){
				mapdata l1 = Game->LoadTempScreen(1);
				int pos = ComboAt(this->X+8, this->Y+8);
				l1->ComboD[pos] = 971;
				l1->ComboC[pos] = 3;
				Waitframe();
				while(true){
					if(G[G_ANIM]%60==0)
						ParticleAnim(this->X+Rand(-2, 2), this->Y+Rand(-10, 2), 968, 0, 8, 5);
					if(Link->X>=this->X-16&&Link->X<=this->X+16&&Link->Y>=this->Y-16&&Link->Y<=this->Y+8){
						int talkX = this->X;
						int talkY = this->Y-16;
						if(Link->Dir==AngleDir4(Angle(Link->X, Link->Y, this->X, this->Y))){
							Screen->FastCombo(6, talkX, talkY, CMB_CANTALK, 0, 128);
							if(Link->PressA){
								NoAction();
								PlayStringAndWait("Peering into the barrel, you see a swirling vortex of stars reflected within. Reach into the reflection? (Bad idea)", SCHAR_BARREL, 0);
								int Affirm[] = "Yes";
								int Deny[] = "No";
								int Options[] = {Affirm, Deny};
								int handler[6];
								while(handler[1] == 0){
									DialogueBox_RunSingleFrame(handler, 128, 8+52, Options, TIL_DB_DIALOGUE_BOX, CS_DB_DIALOGUE_BOX, C_DB_DIALOGUE_BOX_BG, FONT_P, 0xB2, TIL_DB_DIALOGUE_SELECTOR, CS_DB_DIALOGUE_SELECTOR);
									WaitNoAction();
								}
								if(handler[0] == 0){
									PlayStringAndWait("The vortex leads to the top of the observatory on Mauna Ali'i!", SCHAR_BARREL, 0);
									Link->WarpEx({WT_IWARP, 66, 0x17, -1, 0, WARPEFFECT_ZAP, 0, DIR_UP});
								}
							}
						}
					}
					Waitframe();
				}
			}
		}
		if(JankSelector == 70){
			if(Game->GetCurDMap() == 53){
				if(!G[G_RANDOMIZERENABLED] && Game->Counter[CR_STORYFLAG] < SFLAG_MISTENTERED){
					this->Data = 0;
					Quit();
				}
				else
					this->Data = 41339;
			}
			while(true){
				SolidObjects_Add(0, this->X, this->Y-2, 16, 18, 0, 0, 0);
				if(CanTalk(this)){
					Screen->FastCombo(6, this->X, this->Y-16-8, CMB_CANHEAL, 0, 128);
					if(Link->PressA){
						Link->PressA = false;
						Link->InputA = false;
						Game->PlaySound(112);
						
						int bitid = TempBitmap_Create(0, 16, 32);
						bitmap b = TempBMP[bitid];
						int healColor = 0x83;
						for(int i=0; i<16; ++i){
							b->Clear(0);
							if(SingleTileLinkAction())
								b->DrawTile(0, 0, 16, Link->Tile, 1, 1, 6, -1, -1, 0, 0, 0, Link->Flip, true, 128);
							else
								b->DrawTile(0, 0, 0, Link->Tile-20, 1, 2, 6, -1, -1, 0, 0, 0, Link->Flip, true, 128);
							if(i>3){
								b->Circle(0, 8, 20, (i-4), 0x00, 1, 0, 0, 0, true, 128);
							}
							b->ReplaceColors(0, healColor, 0x01, 0xBF);
							if(Link->Action!=LA_SCROLLING)
								b->Blit(4, RT_SCREEN, 0, 0, 16, 32, Link->X+Link->DrawXOffset, Link->Y+Link->DrawYOffset-16, 16, 32, 0, 0, 0, BITDX_TRANS, 0, true);
							G[G_NOACTION] = 1;
							Waitframe();
						}
						
						Link->HP = Link->MaxHP;
						Link->MP = Link->MaxMP;
						G[G_ASHERHP] = G[G_ASHERMAXHP];
						G[G_TORRINHP] = G[G_TORRINMAXHP];
						G[G_KAYLANIHP] = G[G_KAYLANIMAXHP];
						G[G_ASHERMP] = Link->MaxMP;
						G[G_KAYLANIMP] = Link->MaxMP;
						G[G_SORENHP] = G[G_SORENMAXHP];
						G[G_TERRYHP] = G[G_TERRYMAXHP];
						G[G_SIYEDHP] = G[G_SIYEDMAXHP];
						G[G_SIYEDMP] = Link->MaxMP;
						ClearStatus();
					}
				}
				Waitframe();
			}
		}
	}
	void GetFallingJankVel(int fV){
		fV[0] = 0;
		fV[1] = 0;
		for(int i=0; i<4; ++i){
			int x = Link->X+15*(i%2);
			int y = Link->Y+8+7*Floor(i/2);
			if(IsSolidLayer0(x, y)){
				switch(Screen->ComboD[ComboAt(x, y)]){
					//Up
					case 5685:
					case 5680:
					case 5683:
					case 5672:
					case 41223:
					case 5679:
					case 24436:
					case 24441:
						--fV[1];
						break;
					//Down
					case 5713:
					case 5704:
					case 5709:
					case 5706:
					case 5708:
					case 5710:
					case 5714:
					case 41222:
					case 24405:
					case 24429:
					case 24406:
						++fV[1];
						break;
					//Left
					case 5207:
					case 5726:
					case 24434:
					case 24411:
						--fV[0];
						break;
					//Right
					case 5204:
					case 5725:
					case 24423:
					case 24432:
					case 24408:
					case 24412:
						++fV[0];
						break;
					//Left-Up
					//Right-Up
					case 24441:
						++fV[0];
						--fV[1];
						break;
					//Left-Down
					//Right-Down
				}
			}
		}
		fV[0] = Clamp(fV[0], -1, 1);
		fV[1] = Clamp(fV[1], -1, 1);
	}
	bool CanTalk(ffc this){
		if(Link->Dir<2){
			if(Abs(Link->X-this->X)<=8){
				if(Link->Dir==DIR_UP&&Link->Y>this->Y&&Link->Y<this->Y+10)
					return true;
				else if(Link->Dir==DIR_DOWN&&Link->Y<this->Y&&Link->Y>this->Y-20)
					return true;
			}
		}
		else{
			if(Link->Y>=this->Y-12&&Link->Y<=this->Y+4){
				if(Link->Dir==DIR_LEFT&&Link->X>this->X&&Link->X<this->X+18)
					return true;
				else if(Link->Dir==DIR_RIGHT&&Link->X>this->X-18&&Link->X<this->X)
					return true;
			}
		}
		return false;
	}
}

ffc script IntentsConcentration{
	void run(int width, int height, int entrypos, int entryposy, int entrypos1, int entrypos1y, int RUSSMNACKSTHESCROPT){
		if(Game->GetCurMap()==2&&Game->GetCurScreen()==0x2A){
			if(Distance(Link->X, Link->Y, 80, 48)<24){
				Screen->Rectangle(6, 0, 0, 256, 176, 0x0F, 1, 0, 0, 0, true, 128);
				Waitframe();
				Screen->Rectangle(6, 0, 0, 256, 176, 0x0F, 1, 0, 0, 0, true, 128);
				Waitframe();
			}
			else
				Waitframe();
		}
		
		mapdata l2 = Game->LoadTempScreen(2);
		mapdata l3 = Game->LoadTempScreen(3);
		mapdata l4 = Game->LoadTempScreen(4);
		
		int backupCD2[176];
		int backupCD3[176];
		int backupCD4[176];
		int newCD2[176];
		
		npc MooshIAmSoSoSorry[10];
		
		int bitid = TempBitmap_Create(0, 256, 176);
		bitmap b = TempBMP[bitid];
		b->ClearToColor(0, 0x0F);
		for(int i=0; i<176; ++i){
			backupCD2[i] = l2->ComboD[i];
			backupCD3[i] = l3->ComboD[i];
			backupCD4[i] = l4->ComboD[i];
			int newCD = -1;
			switch(backupCD2[i]){
				case 36058:
					newCD = 36297;
					break;
				case 36061:
					newCD = 36289;
					break;
				case 36062:
					newCD = 36290;
					break;
				case 36063:
					newCD = 36291;
					break;
				case 36064:
					newCD = 36292;
					break;
				case 36065:
					newCD = 36293;
					break;
				case 36066:
					newCD = 36294;
					break;
				case 36067:
					newCD = 36295;
					break;
				case 36088:
					newCD = 36300;
					break;
			}
			newCD2[i] = newCD;
			if(newCD>-1&&RectCollision(this->X-16, this->Y-48, this->X+width-1+16, this->Y+height-1, ComboX(i), ComboY(i), ComboX(i)+15, ComboY(i)+15)){
				b->FastCombo(0, ComboX(i), ComboY(i), newCD, l2->ComboC[i], 128);
			}
		}
		if(RUSSMNACKSTHESCROPT == 1){
			for(int i = 0; i<176; ++i){
				if(l3->ComboF[i] == 100){
					b->Rectangle(0, ComboX(i), ComboY(i), ComboX(i)+15, ComboY(i)+15, 0x00, 1, 0, 0, 0, true, 128);
				}
			}
		}
		else
			b->Rectangle(0, this->X, this->Y, this->X+width-1, this->Y+height-1, 0x00, 1, 0, 0, 0, true, 128);
		if(entryposy != 0)
			b->Ellipse(0, entrypos+8, entryposy, 16, 8, 0x00, 1, 0, 0, 0, true, 128);
		else
			b->Ellipse(0, ComboX(entrypos)+8, ComboY(entrypos), 12, 8, 0x00, 1, 0, 0, 0, true, 128);
		if(entrypos1 != 0)
			b->Ellipse(0, entrypos1+8, entrypos1y, 16, 8, 0x00, 1, 0, 0, 0, true, 128);
		b->ReplaceColors(0, 0x00, 0x10, 0x4F);
		while(true){
			while(!RectCollision(Link->X, Link->Y+8, Link->X+15, Link->Y+15, this->X, this->Y, this->X+width-1, this->Y+height-1) || G[G_OVERUNDERLAYER] == 1){
				Waitframe();
			}
			for(int i=0; i<176; ++i){
				l2->ComboD[i] = 0;
				l4->ComboD[i] = 0;
				if(RectCollision(this->X, this->Y, this->X+width-1, this->Y+height-1, ComboX(i), ComboY(i), ComboX(i)+15, ComboY(i)+15)){
					l3->ComboD[i] = 0;
				}
				if(newCD2[i]>-1){
					l2->ComboD[i] = newCD2[i];
				}
			}
			//What's this? It appears to be a hard code. Oh noes.
			if(Game->GetCurMap() == 42){
				if(Game->GetCurScreen() == 0x34){
					l4->ComboD[26] = 9779; 
					l4->ComboD[27] = 9779; 
					l4->ComboC[26] = 4; 
					l4->ComboC[27] = 4; 
					l4->ComboD[10] = 3; 
					l4->ComboD[11] = 3; 
					CreateNPCAt(96, 160, 8);
					CreateNPCAt(96, 176, 8);
				}
				if(Game->GetCurScreen() == 0x24){
					CreateNPCAt(228, 104, 64);
					MooshIAmSoSoSorry[0] = CreateNPCAt(54, 32, 40);
					MooshIAmSoSoSorry[1] = CreateNPCAt(54, 176, 40);
				}
				if(Game->GetCurScreen() == 0x35){
					CreateNPCAt(219, 32, 80);
					CreateNPCAt(95, 96, 48);
					CreateNPCAt(95, 24, 32);
				}
				if(Game->GetCurScreen() == 0x25){
					CreateNPCAt(54, 184, 80);
					CreateNPCAt(54, 128, 80);
				}
				if(Game->GetCurScreen() == 0x11){
					CreateNPCAt(182, 16, 48);
					CreateNPCAt(223, 168, 32);
					CreateNPCAt(223, 168, 32);
					CreateNPCAt(223, 168, 32);
				}
				if(Game->GetCurScreen() == 0x4E){
					if(!Screen->State[ST_SECRET]){
						MooshIAmSoSoSorry[0] = CreateNPCAt(234, 16, 32);
						MooshIAmSoSoSorry[1] = CreateNPCAt(223, 112, 104);
						MooshIAmSoSoSorry[2] = CreateNPCAt(223, 216, 16);
					}
				}
			}
			while(RectCollision(Link->X, Link->Y+8, Link->X+15, Link->Y+15, this->X, this->Y, this->X+width-1, this->Y+height-1) && G[G_OVERUNDERLAYER] == 0){
				for(int i=Screen->NumLWeapons(); i>0; --i){
					lweapon l = Screen->LoadLWeapon(i);
					// if(l->Type==LW_MAGIC&&Graphics->GetPixel(b, l->X+8, l->Y+8)!=0){
					if(GLW[GL_WANDMAGIC] == l){
						if(G[G_ANIM]%4==0){
							lweapon l = ParticleAnim(l->X+Rand(-8, 8), l->Y+Rand(-8, 8), 968, 9, 8, 5);
							RunLWeaponScript(l, "LayerSpriteAnim", {6});
						}
					}
				}
				b->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
				//I'm sorry Moosh.
				if(Game->GetCurMap() == 42){
					if(Game->GetCurScreen() == 0x34){
						Link->Y = Clamp(Link->Y, 24, 168);
					}
					if(Game->GetCurScreen() == 0x24){
						if(!MooshIAmSoSoSorry[0]->isValid() && !MooshIAmSoSoSorry[1]->isValid()){
							if(Screen->State[ST_SECRET] == false){
								Game->PlaySound(27);
								Screen->TriggerSecrets();
								Screen->State[ST_SECRET] = true;
							}
						}
					}
					if(Game->GetCurScreen() == 0x4E){
						if(!MooshIAmSoSoSorry[0]->isValid() && !MooshIAmSoSoSorry[1]->isValid() && !MooshIAmSoSoSorry[2]->isValid()){
							if(Screen->State[ST_SECRET] == false){
								Game->PlaySound(27);
								Screen->TriggerSecrets();
								Screen->State[ST_SECRET] = true;
							}
						}
					}
				}
				Waitframe();
			}
			for(int i=0; i<176; ++i){
				l2->ComboD[i] = backupCD2[i];
				l4->ComboD[i] = backupCD4[i];
				if(RectCollision(this->X, this->Y, this->X+width-1, this->Y+height-1, ComboX(i), ComboY(i), ComboX(i)+15, ComboY(i)+15)){
					l3->ComboD[i] = backupCD3[i];
				}
				if(Game->GetCurMap() == 42){
					if(Game->GetCurScreen() == 0x25){
						if(Screen->State[ST_SECRET] = true){
							l2->ComboD[ComboAt(80, 144)] = 29799;
						}
					}
				}
			}
			//Let's clean up our mess now
			if(Game->GetCurMap() == 42){
				if(Game->GetCurScreen() == 0x34){
					for(int i = Screen->NumNPCs(); i>0; i--){
						npc n = Screen->LoadNPC(i);
						if(n->ID == 96){
							n->Y = -1000;
							n->HP = -1000;
						}
					}
				}
				if(Game->GetCurScreen() == 0x24 || Game->GetCurScreen() == 0x35 || Game->GetCurScreen() == 0x25 || Game->GetCurScreen() == 0x11 || Game->GetCurScreen() == 0x4E){
					for(int i = Screen->NumNPCs(); i>0; i--){
						npc n = Screen->LoadNPC(i);
						SetEnemyProperty(n, ENPROP_Y, -1000);
						n->Y = -1000;
						n->HP = -1000;
					}
					for(int i = Screen->NumItems(); i>0; i--){
						item tem = Screen->LoadItem(i);
						if(tem->ID!=87) //Hymnstone
							Remove(tem);
					}
				}
				if(Game->GetCurScreen() == 0x25){
					for(int i = Screen->NumNPCs(); i>0; i--){
						npc n = Screen->LoadNPC(i);
						SetEnemyProperty(n, ENPROP_Y, -1000);
						n->Y = -1000;
						n->HP = -1000;
					}
				}
			}
		}
	}
}

const int MAP_OWMAP = 28;
const int CMB_OWBOAT = 42236;

ffc script OverworldMap{
	void run(){
		if(G[G_MULTIPLAYERACTIVE])
			UpdateDockUserlist(-1);
		FullHeal(true, true, false, false);
		Link->HP = Link->MaxHP;
		G[G_ASHERHP] = G[G_ASHERMAXHP];
		G[G_TORRINHP] = G[G_TORRINMAXHP];
		G[G_KAYLANIHP] = G[G_KAYLANIMAXHP];
		Link->MP = Link->MaxMP;
		G[G_ASHERMP] = Link->MaxMP;
		G[G_KAYLANIMP] = Link->MaxMP;
		G[G_OVERUNDERLAYER] = 0;
		G[G_ASHERCOSTUME] = 0;
		G[G_TORRINCOSTUME] = 0;
		G[G_KAYLANICOSTUME] = 0;
		G[G_TIMER1] = 0;
		G[G_TIMER1MAX] = 0;
		G[G_TIMER2] = 0;
		G[G_TIMER2MAX] = 0;
		G[G_TIMER3] = 0;
		G[G_TIMER3MAX] = 0;
		int i; int j; int k;
		int x; int y;
		int vX; int vY;
		int stepX; int stepY;
		int xIterations; int yIterations;
		int dockScript = Game->GetFFCScript("DockPoint");
		int scrn;
		mapdata md;
		repeat(2){
			Screen->Rectangle(7, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
			WaitNoAction();
		}
		
		int dockX[64];
		int dockY[64];
		int dockDMap[64];
		int dockScreen[64];
		int dockLabel[64];
		int dockSpecial[64];
		int dockLabel2[64];
		int docks[] = {dockX, dockY, dockDMap, dockScreen, dockLabel, dockSpecial, dockLabel2};
		int numDocks;
		
		int bitid[5];
		bitid[0] = TempBitmap_Create(0, 2048, 1408);
		bitmap mapLayer0 = TempBMP[bitid[0]];
		mapLayer0->Clear(0);
		
		bitid[1] = TempBitmap_Create(0, 2048, 1408);
		bitmap mapSolid = TempBMP[bitid[1]];
		mapSolid->Clear(0);
		
		bitid[2] = TempBitmap_Create(0, 2048, 1408);
		bitmap mapLayer3 = TempBMP[bitid[2]];
		mapLayer3->Clear(0);
		
		int minimapW = 64;
		int minimapH = 44;
		bitid[3] = TempBitmap_Create(0, minimapW*2, minimapH);
		bitmap minimap = TempBMP[bitid[3]];
		minimap->Clear(0);
		
		bitid[4] = TempBitmap_Create(0, 256, 176);
		bitmap wipes = TempBMP[bitid[4]];
		wipes->Clear(0);
		
		int boatX = G[G_OWBOATX];
		int boatY = G[G_OWBOATY];
		int boatDir = G[G_OWBOATDIR];
		if(G[G_OWBOATX] == 0 && G[G_OWBOATY] == 0){
			boatX = 384;
			boatY = 336;
			G[G_OWBOATX] = 384;
			G[G_OWBOATY] = 336;
		}
		
		bool spawnMirageIsland;
		if(G[G_MIRAGEISLANDX]>0||Rand(16)==0||G[G_MIRAGESAFETY]>=16){
			G[G_MIRAGESAFETY] = 0;
			if(Debug->Testing||G[G_RANDOMIZERENABLED])
				Game->PlaySound(47);
			spawnMirageIsland = true;
		}
		if(G[G_RANDOMIZERENABLED])
			++G[G_MIRAGESAFETY];
		G[G_MIRAGEISLANDX] = 0;
		G[G_MIRAGEISLANDY] = 0;
		int numMirage;
		
		Screen->Rectangle(7, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
		
		int miScrn; int miPos;
		
		if(Game->Counter[CR_CHASEQUEST]>=7&&!G[G_RANDOMIZERENABLED]){
			mapdata md = Game->LoadMapData(28, 0x17);
			for(i=0; i<6; ++i){
				md->ComboD[71+i] = 42376;
			}
		}
		
		for(y=0; y<8; ++y){
			for(x=0; x<8; ++x){
				i = x+y*8;
				scrn = x+y*16;
				mapLayer0->DrawScreen(0, MAP_OWMAP, scrn, x*256, y*176, 0);
				mapLayer3->DrawLayer(0, MAP_OWMAP, scrn, 3, x*256, y*176, 0, 128);
				mapSolid->DrawScreenComboFlags(0, MAP_OWMAP+1, scrn, x*256, y*176, 0);
				md = Game->LoadMapData(MAP_OWMAP, scrn);
				for(i=1; i<=32; ++i){
					if(md->FFCScript[i]==dockScript){
						dockX[numDocks] = md->FFCX[i]+x*256;
						dockY[numDocks] = md->FFCY[i]+y*176;
						dockDMap[numDocks] = md->GetFFCInitD(i, 0);
						dockScreen[numDocks] = md->GetFFCInitD(i, 1);
						dockLabel[numDocks] = md->GetFFCInitD(i, 2);
						dockSpecial[numDocks] = md->GetFFCInitD(i, 3);
						dockLabel2[numDocks] = md->GetFFCInitD(i, 4);
						++numDocks;
					}
				}
				for(int i=0; i<176; ++i){
					if(md->ComboF[i]==98){
						md->ComboD[i] = 42240;
						if(numMirage==G[G_MIRAGEISLANDSPAWN]){
							if(spawnMirageIsland){
								md->ComboD[i] = 42374;
								
								dockX[numDocks] = ComboX(i)+x*256;
								dockY[numDocks] = ComboY(i)+8+y*176;
								dockDMap[numDocks] = 45;
								dockScreen[numDocks] = 0x4F;
								dockLabel[numDocks] = 60;
								dockSpecial[numDocks] = 5;
								dockLabel2[numDocks] = 0;
								miScrn = scrn;
								miPos = i;
								
								++numDocks;
								
							}
						}
						++numMirage;
					}
				}
			}
		}
		
		WaitNoAction();
		Screen->Rectangle(7, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
		
		for(y=0; y<8; ++y){
			for(x=0; x<8; ++x){
				i = x+y*8;
				scrn = x+y*16;
				md = Game->LoadMapData(MAP_OWMAP, scrn);
				for(i=0; i<176; ++i){
					if(md->ComboF[i]){
						bool drawFog;
						switch(md->ComboF[i]){
							case 1:
								if(Game->Counter[CR_STORYFLAG]<SFLAG_SHOALSOPEN)
									drawFog = true;
								break;
							case 2:
								if(Game->Counter[CR_STORYFLAG]<SFLAG_METGRANDMA)
									drawFog = true;
								break;
							case 3:
								if(Game->Counter[CR_STORYFLAG]<SFLAG_POSTGRANDMA)
									drawFog = true;
								break;
							case 4:
								drawFog = true;
								break;
						}
						if(drawFog){
							mapLayer3->DrawTile(0, x*256+ComboX(i)-56+Rand(-8, 8), y*176+ComboY(i)-56+Rand(-8, 8), Choose(79560, 79568, 79820, 79828), 8, 8, 0, -1, -1, 0, 0, 0, 0, true, 128);
						}
					}
				}
			}
		}
		
		mapSolid->Blit(0, minimap, 0, 0, 2048, 1408, 0, 0, minimapW, minimapH, 0, 0, 0, 0, 0, false);
		minimap->ReplaceColors(0, 0xB4, 0x01, 0xFF);
		minimap->ReplaceColors(0, 0x0F, 0x00, 0x00);
		if(miPos>0){
			x = Clamp(Floor(((miScrn%16)*256+(miPos%16)*16)*(minimapW/2048)), 0, minimapW-1);
			y = Clamp(Floor((Floor(miScrn/16)*176+Floor(miPos/16)*16)*(minimapH/1408)), 0, minimapH-1);
			minimap->PutPixel(0, x, y, 0xB4, 0, 0, 0, 128);
		}
		
		int speedTime;
		int warp[2] = {-1, -1};
		for(i=0; i<32; ++i){
			int camX = Clamp(boatX-120, 0, 1792);
			int camY = Clamp(boatY-80, 0, 1232);
			DrawMap(warp, mapLayer0, mapLayer3, minimap, boatX, boatY, boatDir, minimapW, minimapH, docks, numDocks, false);
			
			wipes->ClearToColor(0, 0x0F);
			wipes->Circle(0, Lerp(boatX+8-camX, 128, i/32), Lerp(boatY+8-camY, 88, i/32), Lerp(0, 128, i/32), 0x00, 1, 0, 0, 0, true, 128);
			wipes->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
			
			WaitNoAction();
		}
		while(warp[0]==-1){
			if(!G[G_MSGACTIVE]){
				vX = (Link->InputLeft?-1:0) + (Link->InputRight?1:0);
				vY = (Link->InputUp?-1:0) + (Link->InputDown?1:0);
				if(vX!=0&&vY!=0){
					vX *= 0.7071;
					vY *= 0.7071;
				}
				if(vX!=0||vY!=0)
					boatDir = Dir8ToDir4(AngleDir8(Angle(0, 0, vX, vY)), boatDir);
				int speedMod = 1;
				if(G[G_RANDOMIZERENABLED]){
					speedTime = Clamp(speedTime+((vX!=0||vY!=0)?1:-2), 0, 64);
					speedMod = Lerp(1, 3, speedTime/64);
				}
				
				stepX += vX*1.5*speedMod;
				stepY += vY*1.5*speedMod;
				xIterations = Floor(Abs(stepX));
				yIterations = Floor(Abs(stepY));
				if(xIterations>0){
					for(i=0; i<xIterations; ++i){
						if(stepX<0){
							if(CanMoveBoat(boatX, boatY, DIR_LEFT))
								--boatX;
						}
						else{
							if(CanMoveBoat(boatX, boatY, DIR_RIGHT))
								++boatX;
						}
					}
					stepX -= Sign(stepX)*xIterations;
				}
				if(yIterations>0){
					for(i=0; i<yIterations; ++i){
						if(stepY<0){
							if(CanMoveBoat(boatX, boatY, DIR_UP))
								--boatY;
						}
						else{
							if(CanMoveBoat(boatX, boatY, DIR_DOWN))
								++boatY;
						}
					}
					stepY -= Sign(stepY)*yIterations;
				}
			}
			DrawMap(warp, mapLayer0, mapLayer3, minimap, boatX, boatY, boatDir, minimapW, minimapH, docks, numDocks, true);
			
			if(!G[G_MSGACTIVE])
				NoAction();
			else
				G[G_NOACTION] = 1;
			Waitframe();
		}
		for(i=32; i>0; --i){
			int camX = Clamp(boatX-120, 0, 1792);
			int camY = Clamp(boatY-80, 0, 1232);
			DrawMap(warp, mapLayer0, mapLayer3, minimap, boatX, boatY, boatDir, minimapW, minimapH, docks, numDocks, false);
			
			wipes->ClearToColor(0, 0x0F);
			wipes->Circle(0, Lerp(boatX+8-camX, 128, i/32), Lerp(boatY+8-camY, 88, i/32), Lerp(0, 128, i/32), 0x00, 1, 0, 0, 0, true, 128);
			wipes->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
			
			WaitNoAction();
		}
		
		UpdateDockUserlist(warp[0]);
		Screen->SetSideWarp(0, warp[1], warp[0], WT_IWARPBLACKOUT);
		
		int camX = Clamp(boatX-120, 0, 1792);
		int camY = Clamp(boatY-80, 0, 1232);
		DrawMap(warp, mapLayer0, mapLayer3, minimap, boatX, boatY, boatDir, minimapW, minimapH, docks, numDocks, false);
		
		wipes->ClearToColor(0, 0x0F);
		wipes->Circle(0, Lerp(boatX+8-camX, 128, i/32), Lerp(boatY+8-camY, 88, i/32), Lerp(0, 128, i/32), 0x00, 1, 0, 0, 0, true, 128);
		wipes->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
		
		WaitNoAction();
			
		Link->WarpEx({WT_IWARPOPENWIPE, warp[0], warp[1], -1, 0, 0, 0, 0});
	}
	void DrawMap(int warp, bitmap mapLayer0, bitmap mapLayer3, bitmap minimap, int boatX, int boatY, int boatDir, int minimapW, int minimapH, int docks, int numDocks, bool processDocks){
		int dockX = docks[0];
		int dockY = docks[1];
		int dockDMap = docks[2];
		int dockScreen = docks[3];
		int dockLabel = docks[4];
		int dockSpecial = docks[5];
		int dockLabel2 = docks[6];
		
		int camX = Clamp(boatX-120, 0, 1792);
		int camY = Clamp(boatY-80, 0, 1232);
		mapLayer0->Blit(6, RT_SCREEN, camX, camY, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
		Screen->FastCombo(6, boatX-camX, boatY-camY, CMB_OWBOAT+boatDir, 0, 128);
		mapLayer3->Blit(6, RT_SCREEN, camX, camY, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
		
		minimap->Rectangle(0, minimapW, 0, minimapW*2-1, minimapH-1, 0x00, 1, 0, 0, 0, true, 128);
		for(int i=0; i<numDocks; ++i){
			bool dockExists = true;
			bool showDock = true;
			bool showIcon = true;
			bool markDock = false;
			int dockBlocked;
			switch(dockSpecial[i]){
				case 1:
					if(Game->Counter[CR_STORYFLAG]<SFLAG_LEVEL1)
						dockBlocked = 1;
					break;
				case 2:
					if(Game->Counter[CR_STORYFLAG]<SFLAG_SHOALSOPEN)
						dockExists = false;
					break;
				case 3:
					if(Game->Counter[CR_STORYFLAG]<SFLAG_METGRANDMA)
						dockExists = false;
					break;
				case 4:
					if(Game->Counter[CR_CULTISTQUEST]==0)
						dockExists = false;
					break;
				case 5: //Mirage Island
					showDock = false;
					break;
				case 6:
					if(Game->Counter[CR_STORYFLAG]<SFLAG_POSTGRANDMA)
						dockExists = false;
					break;
				case 7:
					if(Game->Counter[CR_STORYFLAG]==SFLAG_ASHERKIDNAPPED)
						dockBlocked = 2;
					break;
				case 8:
					showDock = false;
					showIcon = false;
					break;
				case 9:
					showDock = false;
					showIcon = false;
					if(Game->Counter[CR_NIGHTMARCHERQUEST] < 4)
						dockBlocked = 3;
					break;
				case 10: //Mt. Silver
					showDock = false;
					showIcon = false;
					if(Game->Counter[CR_CHASEQUEST]<7||G[G_RANDOMIZERENABLED]){
						dockExists = false;
					}
					break;
				case 11: //Waypoint Isle
					if(Game->Counter[CR_CHASEQUEST]==6)
						markDock = true;
					showDock = false;
					showIcon = false;
					break;
				case 12: //Canyon Secret Entrance
					showDock = false;
					showIcon = false;
					if(Game->Counter[CR_STORYFLAG]<SFLAG_MISTCLEAR)
						dockExists = false;
					break;
			}
			if(dockExists){
				if(markDock&&G[G_ANIM]%32<16)
					minimap->PutPixel(0, minimapW+Clamp((dockX[i]/2048)*minimapW, 0, minimapW-1), Clamp((dockY[i]/1408)*minimapH, 0, minimapH-1), 0x83, 0, 0, 0, 128);
				if(showDock)
					minimap->PutPixel(0, minimapW+Clamp((dockX[i]/2048)*minimapW, 0, minimapW-1), Clamp((dockY[i]/1408)*minimapH, 0, minimapH-1), (G[G_ANIM]%8)<4?0x01:0x77, 0, 0, 0, 128);
				if(LargeDistance(dockX[i], dockY[i], boatX, boatY, 16)<24){
					int nameStr[256];
					GetMessage(dockLabel[i], nameStr);
					int nameStr2[256];
					int nameYoff;
					int nameW = Text->StringWidth(nameStr, FONT_SUBSCREEN3);
					int nameW2;
					int lbl1clr = 0x01;
					if(dockLabel2[i]){
						lbl1clr = 0x0B;
						GetMessage(dockLabel2[i], nameStr2);
						nameW2 = Text->StringWidth(nameStr2, FONT_SUBSCREEN3);
						
						nameYoff = -8;
					}
					if(nameW2>nameW)
						nameW = nameW2;
					int nameX = dockX[i]-camX+8;
					nameX = Clamp(nameX, 8+nameW/2, 248-nameW/2);
					Screen->DrawString(6, nameX, dockY[i]-camY+4+nameYoff, FONT_SUBSCREEN3, lbl1clr, -1, TF_CENTERED, nameStr, 128, SHD_OUTLINED8, 0x0F);
					Screen->DrawString(6, nameX, dockY[i]-camY+12+nameYoff, FONT_SUBSCREEN3, 0x01, -1, TF_CENTERED, nameStr2, 128, SHD_OUTLINED8, 0x0F);
					DrawTotemCount(nameX, dockY[i]-camY-8+nameYoff, dockLabel[i], dockLabel2[i]);
					
					if(G[G_MULTIPLAYERACTIVE]){
						int numUsersOnIsland;
						for(int j=0; j<16; ++j){
							int name[33];
							if(MultiworldData[MD_DOCKLISTS+j]==NetGhost_DMapRegion(dockDMap[i])){
								ZLink::GetUsername(name, j+1);
								Screen->DrawString(6, nameX, dockY[i]-camY+4+nameYoff-20-8*numUsersOnIsland, FONT_Z3SMALL, UsernameColor(j), -1, TF_CENTERED, name, 128, SHD_OUTLINED8, 0x0F);
								++numUsersOnIsland;
							}
						}
					}
					
					if(Link->PressA&&!G[G_MSGACTIVE]&&processDocks){
						NoAction();
						if(dockBlocked==1){
							PlayString("I'll sail ya anywhere ya wanna go, Ash. @26@26...Anywhere but here.", SCHAR_TORRIN, EMOTE_SWEAT);
						}
						else if(dockBlocked==2){
							PlayString("There's no way Selet took Ash THERE. We gotta find him!", SCHAR_TORRIN, EMOTE_ANGRY);
						}
						else if(dockBlocked==3){
							PlayString("There's no way I can safely land here. The approach is too rough.", SCHAR_TORRIN, EMOTE_SWEAT);
						}
						else{
							if(dockSpecial[i]==5){ //Flag Mirage Island position
								G[G_MIRAGEISLANDX] = dockX[i];
								G[G_MIRAGEISLANDY] = dockY[i];
							}
							warp[0] = dockDMap[i];
							warp[1] = dockScreen[i];
						}
					}
				}
				else if(showIcon)
					Screen->FastCombo(6, dockX[i]-camX, dockY[i]-camY, 42232, 0, 128);
			}
		}
		minimap->PutPixel(0, minimapW+Clamp((boatX/2048)*minimapW, 0, minimapW-1), Clamp((boatY/1408)*minimapH, 0, minimapH-1), (G[G_ANIM]%8<4)?0x82:0x83, 0, 0, 0, 128);
			
		minimap->Blit(6, RT_SCREEN, 0, 0, minimapW, minimapH, 256-minimapW-8, 8, minimapW, minimapH, 0, 0, 0, BITDX_TRANS, 0, false);
		minimap->Blit(6, RT_SCREEN, minimapW, 0, minimapW, minimapH, 256-minimapW-8, 8, minimapW, minimapH, 0, 0, 0, 0, 0, true);
		
	}
	bool BoatCanMovePixel(int x, int y){
		if(x<0||x>2047||y<0||y>1407)
			return false;
		return !IsSolidMap(MAP_OWMAP, x, y)&&!IsSolidMap(MAP_OWMAP+1, x, y);
	}
	bool CanMoveBoat(int boatX, int boatY, int dir){
		switch(dir){
			case DIR_UP:
				for(int i=4; i<=11; i=Min(i+8, 11)){
					if(!BoatCanMovePixel(boatX+i, boatY+3))
						return false;
					
					if(i==11)
						break;
				}
				break;
			case DIR_DOWN:
				for(int i=4; i<=11; i=Min(i+8, 11)){
					if(!BoatCanMovePixel(boatX+i, boatY+12))
						return false;
					
					if(i==11)
						break;
				}
				break;
			case DIR_LEFT:
				for(int i=4; i<=11; i=Min(i+8, 11)){
					if(!BoatCanMovePixel(boatX+3, boatY+i))
						return false;
					
					if(i==11)
						break;
				}
				break;
			case DIR_RIGHT:
				for(int i=4; i<=11; i=Min(i+8, 11)){
					if(!BoatCanMovePixel(boatX+12, boatY+i))
						return false;
					
					if(i==11)
						break;
				}
				break;
		}
		return true;
	}
	void GetTotemCount(int str1, int str2, int counts){
		//  						 0,   1,   2,   3,   4,   5,   6,   7,   8,   9,   10,  11,  12,   13,      14,     15,     16,       17,    18,     19
		//  						Hearts Asher    Torrin         Kaylani        Attack Ups     Dash  Upgrade  Meteor  Strafe  Sound Up  Orbit  Doppel  Laser
		// int ItemIDs[] =  		{256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 170,  182,     172,    162,    163,      167,   168,    169};
		// int Character[] = 		{0,   0,   0,   1,   1,   1,   2,   2,   2,   0,   1,   2,   0,    0,       0,      1,      2,        2,     2,      2};
		// int Cost[] = 			{2,   3,   4,   2,   3,   4,   2,   3,   4,   5,   5,   5,   1,    6,       6,      6,      6,        6,     6,      6};
		
		//Totems:
		//1:  AH, TH, KH, Dash, Orbit
		//2:  AH, TH, KH, Strafe, Doppel
		//3:  All augment slots, Dash Upgrade, Sound Up
		//4:  AH, TH, KH, Meteor, Laser
		
		counts[0] = 0;
		counts[1] = 0;
		counts[2] = 0;
		switch(str1){
			case 47: //Omaka
				if(G[G_RANDOMIZERENABLED]){
					counts[0] = G[G_OMAKATOTEMCOUNT];
				}
				else{
					//Hearts
					if(FoundItems[256])
						++counts[0];
					if(FoundItems[259])
						++counts[0];
					if(FoundItems[262])
						++counts[0];
					if(FoundItems[170]) //Dash
						++counts[0];
					if(FoundItems[167]) //Orbit
						++counts[0];
				}
				counts[1] = 5;
				if(LoreTracking[LT_LOCATIONS+LOC_OMAKA])
					counts[2] = 1;
				break;
			case 19: //Kawi
				if(G[G_RANDOMIZERENABLED]){
					counts[0] = G[G_KAWITOTEMCOUNT];
				}
				else{
					//Hearts
					if(FoundItems[257])
						++counts[0];
					if(FoundItems[260])
						++counts[0];
					if(FoundItems[263])
						++counts[0];
					if(FoundItems[162]) //Black Belt
						++counts[0];
					if(FoundItems[168]) //Sundog
						++counts[0];
				}
				counts[1] = 5;
				if(LoreTracking[LT_LOCATIONS+LOC_KAWI])
					counts[2] = 1;
				break;
			case 48: //Wahiokala Jungle
				//Hearts
				if(str2==20){
					if(G[G_RANDOMIZERENABLED]){
						counts[0] = G[G_WAHIOKALATOTEMCOUNT];
					}
					else{
						if(FoundItems[258])
							++counts[0];
						if(FoundItems[261])
							++counts[0];
						if(FoundItems[264])
							++counts[0];
						if(FoundItems[172]) //Meteor
							++counts[0];
						if(FoundItems[169]) //Laser
							++counts[0];
					}
					counts[1] = 5;
					if(LoreTracking[LT_LOCATIONS+LOC_JUNGLE])
						counts[2] = 1;
				}
				break;
			case 24: //Starfall Shoals
				if(G[G_RANDOMIZERENABLED]){
					counts[0] = G[G_SHOALSTOTEMCOUNT];
				}
				else{
					//Augment Slots
					if(FoundItems[265])
						++counts[0];
					if(FoundItems[266])
						++counts[0];
					if(FoundItems[267])
						++counts[0];
					if(FoundItems[182]) //Dash Upgrade
						++counts[0];
					if(FoundItems[163]) //Big Bowling Ball
						++counts[0];
				}
				counts[1] = 5;
				if(LoreTracking[LT_LOCATIONS+LOC_SHOALS])
					counts[2] = 1;
				break;
		}
	}
	void DrawTotemCount(int x, int y, int str1, int str2){
		int counts[3];
		GetTotemCount(str1, str2, counts);
		if(counts[2]){
			int str[] = "0/0";
			str[0] = '0'+counts[0];
			str[2] = '0'+counts[1];
			int xoff = (Text->StringWidth(str, FONT_Z3SMALL)+10)/2;
			Screen->FastTile(6, x-xoff, y, 245, 11, 128);
			Screen->DrawString(6, x-xoff+10, y+2, FONT_Z3SMALL, 0x01, -1, TF_NORMAL, str, 128, SHD_OUTLINED8, 0x0F);
		}
	}
}

//Special Cases:
//1 - Malka
//2 - Starfall shoals
//3 - Hoku
//6 - Kohiko
//8 - Unmarked Islands
ffc script DockPoint{
	void run(int destDMap, int destScrn, int label, int special, int sublabel){
		//"lol," said the ZQuest editor, "lmao"
	}
}

ffc script SetOverworldPosition{
	void run(int scrn, int x, int y, int dir, int useFFC){
		if(useFFC==100){ //Mirage Island
			scrn = Floor(G[G_MIRAGEISLANDX]/256)+Floor(G[G_MIRAGEISLANDY]/176)*16;
			x = G[G_MIRAGEISLANDX]%256;
			y = G[G_MIRAGEISLANDY]%176;
		}
		else if(useFFC){
			mapdata md = Game->LoadMapData(MAP_OWMAP, scrn);
			x = md->FFCX[useFFC];
			y = md->FFCY[useFFC];
		}
		x += (scrn%16)*256;
		y += Floor(scrn/16)*176;
		if(LargeDistance(G[G_OWBOATX], G[G_OWBOATY], x, y, 16)>=24){
			G[G_OWBOATX] = x;
			G[G_OWBOATY] = y;
		}
		G[G_OWBOATDIR] = dir;
		if(Game->GetCurMap() == 2 && Game->GetCurScreen() == 0x4E && Game->Counter[CR_STORYFLAG] < SFLAG_METKAYLANI){ //Pala Bay
			while(true){
				if(Link->Y >= 128){
					PlayStringAndWait("There's no reason for me to head down to the docks right now.", SCHAR_ASHER, EMOTE_NORMAL);
					while(Link->Y > 112){
						NoInput();
						Link->InputUp = true;
						Link->PressUp = true;
						Waitframe();
					}
				}
				Waitframe();
			}
		}
		if(Game->GetCurMap() == 20 && Game->GetCurScreen() == 0x4E && Game->Counter[CR_STORYFLAG] < SFLAG_SHOALSOPEN){ //Malka
			while(true){
				if(Link->Y >= 144 && Link->Action != LA_SWIMMING && Link->Action != LA_HOPPING && Link->Action != LA_DIVING){
					PlayStringAndWait("We shouldn't leave town without Torrin.", SCHAR_ASHER, EMOTE_NORMAL);
					while(Link->Y > 128){
						NoInput();
						Link->InputUp = true;
						Link->PressUp = true;
						Waitframe();
					}
				}
				Waitframe();
			}
		}
		if(Game->GetCurMap() == 12 && Game->GetCurScreen() == 0x08 && Game->Counter[CR_STORYFLAG] >= SFLAG_POSTGRANDMA){ //Hoku
			Screen->TriggerSecrets();
			Screen->State[ST_SECRET] = true;
		}
		if(Game->GetCurMap() == 2 && Game->GetCurScreen() == 0x52 && Game->Counter[CR_STORYFLAG] >= SFLAG_METKAYLANI){ //Puna Village
			Screen->TriggerSecrets();
			Screen->State[ST_SECRET] = true;
		}
	}
}

ffc script HokuBG{
	void run(){
		int refMap = 1;
		int initialscreen = 0x65; //Hoku
		if(Game->GetCurDMap() == 18) //Mauna Ali'i
			initialscreen = 0x6A;
		if(Game->GetCurDMap() == 33){ //Leipai
			if(Game->GetCurScreen()==0x3B)
				initialscreen = 0x7A;
			else
				initialscreen = 0x75;
		}
		if(Game->GetCurMap() == 42) //Tel's Pyramid
			initialscreen = 0x55;
		if(Game->GetCurDMap() == 14) //Shoals
			initialscreen = 0x45;
		int scrn = initialscreen;
		while(true){
			scrn = initialscreen;
			int h = DayNight[_DN_HOUR];
			int m = DayNight[_DN_MINUTE];
			int s = DayNight[_DN_SECOND];
			int timediff = DayNight_GetTimeDifference(h, m, s, 0, 0, 0);
			if(DayNight_GetTimeDifference(h, m, s, DAYNIGHT_SUNSET_START_HOUR, 0, 0)>=0&&DayNight_GetTimeDifference(h, m, s, 3, 0, 0)<0){ //Stars coming out at night
				if(Abs(timediff)<=18000){ //7:00
					scrn = initialscreen+1; //First star
					if(Abs(timediff)<=16200){ //7:30
						scrn = initialscreen+2; //More stars, clouds recede
					}
					if(Abs(timediff)<=14400){ //8:00
						scrn = initialscreen+3; //All stars
					}
					if(Abs(timediff)<=10800){ //9:00
						scrn = initialscreen+4; //Stars bright
					}
				}
			}
			else if(DayNight_GetTimeDifference(h, m, s, 3, 0, 0)>=0&&DayNight_GetTimeDifference(h, m, s, DAYNIGHT_SUNRISE_END_HOUR, 0, 0)<0){ //Stars going away at day
				if(Abs(timediff)<19800){ //Until 5:30
					scrn = initialscreen+1; //First star
					if(Abs(timediff)<18000){ //Until 5:00
						scrn = initialscreen+2; //More stars, clouds receed
					}
					if(Abs(timediff)<=16200){ //Until 4:30
						scrn = initialscreen+3; //All stars
					}
					if(Abs(timediff)<=14400){ //Until 4:00
						scrn = initialscreen+4; //Stars bright
					}
				}
			}
			
			mapdata md = Game->LoadMapData(refMap, scrn);
			for(int i=0; i<176; ++i){
				if(md->ComboD[i]!=0)
					Screen->ComboD[i] = md->ComboD[i];
			}
			Waitframe();
		}
	}
}

ffc script BigDumbSwitchStatementAdventure{
	int GetComboReplacement(int id){
		switch(id){
			//Doors Wooden
			//South
			case 16606: return 16308;
			case 16607: return 16309;
			case 16610: return 16312;
			case 16611: return 16313;
			//North
			case 16596: return 16300;
			case 16597: return 16301;
			case 16600: return 16304;
			case 16601: return 16305;
			
			//Doors Stone
			//South
			case 16644: return 16310;
			case 16645: return 16311;
			case 16648: return 16314;
			case 16649: return 16315;
			//North
			case 16652: return 16302;
			case 16653: return 16303;
			case 16656: return 16306;
			case 16657: return 16307;
			
			//Windows Wooden
			//South
			case 16546: return 16286;
			case 16547: return 16287;
			//North
			case 16548: return 16288;
			case 16549: return 16289;
			//West
			case 16553: return 16293;
			case 16557: return 16297;
			//East
			case 16554: return 16294;
			case 16558: return 16298;
			
			//Windows Stone
			//South
			case 16650: return 16274;
			case 16651: return 16275;
			case 16228: return 16278;
			case 16229: return 16279;
			
			//Wooden Floors
			//South
			case 16598: return 16697;
			case 16599: return 16697;
			case 16602: return 16697;
			case 16603: return 16697;
			//North
			case 16604: return 16697;
			case 16605: return 16697;
			case 16608: return 16697;
			case 16609: return 16697;
			
			//Wooden Floors (Warehouse)
			//South
			case 14046: return 13968;
			case 14047: return 13969;
			case 14050: return 13968;
			case 14051: return 13969;
			
			//Carpet Floors (Pala)
			//South
			case 16612: return 16717;
			case 16613: return 16717;
			case 16616: return 16721;
			case 16617: return 16721;
			//North
			case 16618: return 16713;
			case 16619: return 16713;
			case 16622: return 16717;
			case 16623: return 16717;
			
			//Carpet Floors (Window)(Pala)
			//South
			case 16646: return 16721;
			case 16647: return 16721;
			//North
			case 16642: return 16713;
			case 16643: return 16713;
			
			//Carpet Floors (Hoku)
			//Blue South
			case 48908: return 48773;
			case 48909: return 48773;
			case 48912: return 48777;
			case 48913: return 48777;
			//Red South
			case 48910: return 48829;
			case 48911: return 48829;
			case 48914: return 48833;
			case 48915: return 48833;
			
			//Carpet Floors (Window)(Hoku)
			//Blue South
			case 48904: return 48777;
			case 48905: return 48777;
			
			//Red South
			case 48906: return 48833;
			case 48907: return 48833;
		}
		return 0;
	}
	void run(){
		int floorCMB[176];
		int secretCMB[128];
		while(true){
			bool night;
			if(DayNight_IsBetween(DAYNIGHT_MIDI_NIGHT_START_HOUR, 0, 0, DAYNIGHT_MIDI_NIGHT_END_HOUR, 0, 0))
				night = true;
			for(int i=0; i<128; ++i){
				if(GetComboReplacement(Screen->SecretCombo[i])||GetComboReplacement(secretCMB[i])){
					if(secretCMB[i]==0)
						secretCMB[i] = Screen->SecretCombo[i];
					if(night){
						Screen->SecretCombo[i] = GetComboReplacement(secretCMB[i]);
					}
					else{
						Screen->SecretCombo[i] = secretCMB[i];
					}
				}
			}
			for(int i=0; i<176; ++i){
				if((Screen->ComboF[i]<16||Screen->ComboF[i]>31)&&(GetComboReplacement(Screen->ComboD[i])||GetComboReplacement(floorCMB[i]))){
					if(floorCMB[i]==0)
						floorCMB[i] = Screen->ComboD[i];
					if(night){
						Screen->ComboD[i] = GetComboReplacement(floorCMB[i]);
					}
					else{
						Screen->ComboD[i] = floorCMB[i];
					}
				}
			}
			Waitframe();
		}
	}
}

void MapShop(){
	
	int S1[] = "Omaka Map #1"; //17: Puna 1+Island 7+Pala 6+Warehouse 3
	int S2[] = "Omaka Map #2"; //6: Manor 3+ Catacombs 3
	int S3[] = "Kawi Map"; //10: Kawi 7+Pirate Fort 3
	int S4[] = "Starfall Shoals Map"; //9: Shoals 4+Mining Base 5
	int S5[] = "Wahiokala Map #1"; //12: Jungle 2+Jungle Cave 1+Base 2+Crater 3+Caves 3+Temple 1
	int S6[] = "Wahiokala Map #2"; //12: Slopes&Summit 2+Caves 4+Observatory 6
	int S7[] = "Minor Islands Map #1"; //9: Kikala 4+Malka 2+Villa 3+Kukulu 2+Minor 2
	int S8[] = "Minor Islands Map #2"; //11: Kawaihae 4+Leipai 2+Golem 5
	int S9[] = "Kahiko Map"; //10: Kahi Canyon 6+Mauna Poho 1+Poho Temple 3 
	
	int T1[] = "Shows Hymnstone locations for Omaka Island, including Puna Village, Pala Bay, and Selet's Warehouse";
	int T2[] = "Shows Hymnstone locations for Selet's Manor and the Omaka Catacombs";
	int T3[] = "Shows Hymnstone locations for Kawi, including the Pirate Fortress";
	int T4[] = "Shows Hymnstone locations for Starfall Shoals and Selet's Mining Base";
	int T5[] = "Shows Hymnstone locations for the jungle, base of Mauna Ali'i, and volcanic crater";
	int T6[] = "Shows Hymnstone locations for the Mauna Ali'i caves, slopes, summit, and Observatory";
	int T7[] = "Shows Hymnstone locations for Kikala Hill, Kukulu Cliffs, Villa Tulane, Malka, and unmarked islands";
	int T8[] = "Shows Hymnstone locations for Kawaihae Cave, Carn Ruins, and Leipai's Lookout";
	int T9[] = "Shows Hymnstone locations for Kahiko, including the Poho Temple.";

	
	int LevelNum[] = 		{1,   4,   2,   3,   6,   5,   9,   7,  8};
	int Cost[] = 			{120, 50,  75,  75,  75,  75,  75,  75, 75};
	int Names[] = 			{S1,  S2,  S3,  S4,  S5,  S6,  S9,  S7, S8};
	int Descriptions[] = 	{T1,  T2,  T3,  T4,  T5,  T6,  T9,  T7, T8};
	int Counts[] =          {17,  6,   10,  9,   12,  12,  10,  13, 11};
	
	for(int i=0; i<9; ++i){
		if(LevelHymnstonesFound[LevelNum[i]]>=Counts[i])
			Game->LItems[LevelNum[i]] |= LI_COMPASS;
	}
	if(LevelHymnstonesFound[8] + LevelHymnstonesFound[11] >= Counts[8]){ //Stupid hardcoded Carn Ruins exception
		Game->LItems[8] |= LI_COMPASS;
		Game->LItems[11] |= LI_COMPASS;
	}
	
	int Xoff = -16;
			
	int CurrentOption;
	int CurMax = 4;
	int CurMin = 0;
	int RealMax = 0;
	int InvName[9];
	int InvStr[9];
	int InvPrice[9];
	int InvChar[9];
	int InvID[9];
	for(int i = 0; i<9; i++){
		if(!(Game->LItems[LevelNum[i]] & LI_COMPASS)){
			InvName[RealMax] = Names[i];
			InvStr[RealMax]  = Descriptions[i];
			InvPrice[RealMax]  = Cost[i];
			InvID[RealMax] = LevelNum[i];
			RealMax++;
		}
	}
	
	Tango_SetStyleAttribute(STYLE_SHOP, TANGO_STYLE_TEXT_WIDTH, 80);
    Tango_SetStyleAttribute(STYLE_SHOP, TANGO_STYLE_TEXT_HEIGHT, 80);
	
	if(RealMax == 0){
		PlayStringAndWait("Unfortunately, you seem to have purchased all of my maps. There's not much more I can do for you.", SCHAR_CARTOGRAPHER, EMOTE_NORMAL);
	}
	else{
		while(true){
			//First, let's draw the frame
			DialogueBox_DrawBox(6, 128, 88, TIL_DB_DIALOGUE_BOX, CS_DB_DIALOGUE_BOX, C_DB_DIALOGUE_BOX_BG, 224, 144);
			Screen->FastTile(6, 128, 16, 65994, 11, OP_OPAQUE);
			for(int i = 32; i<=128; i+=16)
				Screen->FastTile(6, 128, i, 66014, 11, OP_OPAQUE);
			Screen->FastTile(6, 128, 144, 66034, 11, OP_OPAQUE);
			//The price
			Screen->FastTile(6, 140+24, 43, 65840, 7, OP_OPAQUE);
			if(InvPrice[CurrentOption]>-1){
				Screen->DrawInteger(6, 182, 40+8, FONT_P, 1, -1, -1, -1, InvPrice[CurrentOption], 0, OP_OPAQUE);
			}
			//The description string
			if(!Tango_SlotIsActive(0))
				PlayTangoSubscreenMessage(InvStr[CurrentOption], STYLE_SHOP, 0, 112+24,64);
			//The actual buyable things
			for(int i=CurMin; i<=CurMax; i++){
				if(InvName[i] != 0){
					Screen->DrawString(6, 52+Xoff, 48+18*(i-CurMin), FONT_P, 0xB2, -1, TF_NORMAL, InvName[i], OP_OPAQUE);
					if(CurrentOption==i){
						Screen->FastTile(6, 52-8+Xoff, 48+4+18*(i-CurMin)-4, 5, 0, OP_OPAQUE); //Cursor
					}
				}
			}
			
			//Up and down selection
			if(Link->PressUp){
				Tango_ClearSlot(0);
				Game->PlaySound(5);
				CurrentOption--;
				if(CurrentOption<0){
					CurrentOption = RealMax-1;
					CurMax = RealMax;
					CurMin = RealMax-4;
					while(CurMin < 0){
						CurMin++;
						CurMax++;
					}
				}
				if(CurrentOption < CurMin){
					CurMax--;
					CurMin--;
				}
			}
			else if(Link->PressDown){
				Tango_ClearSlot(0);
				Game->PlaySound(5);
				CurrentOption++;
				if(CurrentOption>=RealMax){
					CurrentOption = 0;
					CurMin = 0;
					CurMax = 4;
				}
				if(CurrentOption > CurMax){
					CurMax++;
					CurMin++;
				}
			}
			if(Link->PressA){
				if(Game->Counter[CR_RUPEES] < InvPrice[CurrentOption])
					Game->PlaySound(6);
				else{
					Tango_ClearSlot(0);
					PlayStringAndWait("Certainly! The map is yours. I hope it serves you well.", SCHAR_CARTOGRAPHER, EMOTE_NORMAL);
					Game->Counter[CR_RUPEES] -= InvPrice[CurrentOption];
					Game->LItems[InvID[CurrentOption]] |= LI_COMPASS;
					if(InvID[CurrentOption] == 8) //Hardcoded exception for Carn Ruins, which needs its own level number to avoid reusing keys
						Game->LItems[11] |= LI_COMPASS;

					Tango_ClearSlot(0);
					WaitNoAction(1);
					break;
				}
			}
			if(Link->PressB){
				Tango_ClearSlot(0);
				WaitNoAction(1);
				break;
			}
			WaitNoAction();
		}
	}
}

const int LAYER_BEAMOS1 = 2; //Beamos use this layer to draw the bottom half
const int LAYER_BEAMOS2 = 4; //Beamos use this layer to draw the top half and eye
const int BEAMOS_IMPRECISION = 6; //How close the beamos must be aiming at Link to shoot
const int BEAMOS_FLASHFRAMES = 16; //How many frames the beamos flashes for before firing
const int BEAMOS_LASER_SPEED = 6; //How fast the laser shoots out
const int BEAMOS_LASER_LENGTH = 80; //How long the laser is
const int BEAMOS_LASER_MINDIST = 16; //How far the beamos can see/shoot through solid objects
const int COLOR_BEAMOS_LASER1 = 0x82; //The color of the inner laser
const int COLOR_BEAMOS_LASER2 = 0x83; //The color of the outer laser
const int CMB_BEAMOS_LASER_ENDPOINT = 51682; //The combo used for the ends of the laser
const int CS_BEAMOS_LASER_ENDPOINT = 8; //The cset used for the ends of the laser
const int SFX_BEAMOS_SIGHT = 40; //The sound that plays when the beamos sees Link
const int SFX_BEAMOS_LASER = 78; //The sound that plays when the beamos fires its laser

//LttP Beamos Script
//Attribute 1: The starting angle of the eye in degrees.
//Attribute 2: How fast the eye turns each frame in degrees. Make negative for a counterclockwise turn.
//Attribute 3: How long the enemy waits before it can fire another laser in frames. (60ths of a second)
//Attribute 4: Whether or not the enemy has collision. 0 = Yes, 1 = No. No collision is mostly for placing over a solid combo.
//Attribute 11: The first of 10 combos. Statue top, statue bottom, eye up, eye down, eye left, eye right, eye left-up, eye right-up, eye left-down, eye right-down
//Attribute 12: The slot this script is loaded into

ffc script Beamos{
	//This function draws the parts of the beamos in the right order
	void Beamos_Draw(ffc this, npc ghost, int Combo, int EyeAngle){
		int EyeX = Ghost_X+VectorX(8, EyeAngle);
		int EyeY = Ghost_Y+4+VectorY(5, EyeAngle);
		int EyeCombo = Combo+2+AngleDir8(EyeAngle);
		if(Link->HP>0){
			if(EyeAngle<=0)
				Screen->FastCombo(LAYER_BEAMOS2, EyeX, EyeY, EyeCombo, this->CSet, 128);
			Screen->FastCombo(LAYER_BEAMOS2, Ghost_X, Ghost_Y, Combo, this->CSet, 128);
			if(EyeAngle>0)
				Screen->FastCombo(LAYER_BEAMOS2, EyeX, EyeY, EyeCombo, this->CSet, 128);
			Screen->FastCombo(LAYER_BEAMOS1, Ghost_X, Ghost_Y+16, Combo+1, this->CSet, 128);
		}
	}
	//This function checks the path of the beamos' laser before firing
	bool CheckPath(int X, int Y, int Angle, int Distance, int SafeDist, int Step){
		for(int i = 0; i<Distance-Step; i+=Step){
			X += VectorX(Step, Angle);
			Y += VectorY(Step, Angle);
			if(!ComboFI(X, Y, 107)){
				if(((Screen->isSolid(X, Y)&&i>SafeDist)||Screen->ComboF[ComboAt(X, Y)]==97))
					return false;
			}
		}
		return true;
	}
	bool Beamos_LaserSolid(int X, int Y){
		if(!ComboFI(X, Y, 107)){
			if(Screen->isSolid(X, Y)||Screen->ComboF[ComboAt(X, Y)]==97)
				return true;
		}
		return false;
	}
	//This function checks if the laser is colliding with Link and deals damage
	void CheckBeamosLaser(npc ghost, int StartX, int StartY, int EndX, int EndY){
		if(lineBoxCollision(StartX, StartY, EndX, EndY, Link->X, Link->Y, Link->X+Link->HitWidth, Link->Y+Link->HitHeight, 0)){
			eweapon e = FireEWeapon(EW_SCRIPT10, Link->X+InFrontX(Link->Dir, 10), Link->Y+InFrontY(Link->Dir, 10), 0, 0, ghost->WeaponDamage, -1, -1, EWF_UNBLOCKABLE);
			SetEWeaponLifespan(e, EWL_TIMER, 1);
			SetEWeaponDeathEffect(e, EWD_VANISH, 0);
			e->DrawYOffset = -1000;
		}
	}
	void Beamos_ConveyorMove(ffc this, npc ghost, bool onConveyor){
		if(onConveyor){
			int vX;
			int vY;
			for(int i=0; i<4; ++i){
				int x = Ghost_X+(i%2)*15;
				int y = Ghost_Y+16+Floor(i/2)*15;
				switch(Screen->ComboT[ComboAt(x, y)]){
					case CT_CVUP:
						vY -= 0.5;
						break;
					case CT_CVDOWN:
						vY += 0.5;
						break;
					case CT_CVLEFT:
						vX -= 0.5;
						break;
					case CT_CVRIGHT:
						vX += 0.5;
						break;
				}
				vX = Clamp(vX, -0.5, 0.5);
				vY = Clamp(vY, -0.5, 0.5);
			}
			Ghost_MoveXY(vX, vY, 0);
			SolidObjects_Add(0, Ghost_X, Ghost_Y+16, 16, 16, 0, 0, 0);
		}
	}
	void run(int enemyid){
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		int StartAngle = ghost->Attributes[0];
		int IncrementAngle = ghost->Attributes[1];
		StartAngle = WrapDegrees(StartAngle);
		if(Abs(AngDiff(StartAngle+22.5*Sign(IncrementAngle), Angle(Ghost_X, Ghost_Y, Link->X, Link->Y)))<=30){
			StartAngle += 90*Sign(IncrementAngle);
		}
		int LaserCooldown = ghost->Attributes[2];
		int NoCollision = ghost->Attributes[3];
		int Combo = ghost->Attributes[10];
		Ghost_Transform(this, ghost, GH_INVISIBLE_COMBO, ghost->CSet, 1, 2);
		Ghost_Y-=8;
		if(NoCollision==1)
			ghost->CollDetection = false;
		Ghost_SetHitOffsets(ghost, 16, 0, 0, 0);
		int EyeAngle = WrapDegrees(StartAngle);
		this->Flags[FFCF_IGNOREHOLDUP] = true;
		bool onConveyor;
		switch(Screen->ComboT[ComboAt(Ghost_X+8, Ghost_Y+24)]){
			case CT_CVUP:
			case CT_CVDOWN: 
			case CT_CVLEFT:
			case CT_CVRIGHT:
				onConveyor = true;
				break;
		}
		if(!onConveyor){
			mapdata l1 = Game->LoadTempScreen(1);
			l1->ComboD[ComboAt(Ghost_X+8, Ghost_Y+24)] = 1;
		}
		while(true){
			Beamos_ConveyorMove(this, ghost, onConveyor);
			EyeAngle = WrapDegrees(EyeAngle+IncrementAngle);
			int EyeX = Ghost_X+VectorX(8, EyeAngle);
			int EyeY = Ghost_Y+4+VectorY(5, EyeAngle);
			int AngleLink = Angle(EyeX+8, EyeY+8, CenterLinkX(), CenterLinkY());
			int DistLink = Distance(EyeX+8, EyeY+8, CenterLinkX(), CenterLinkY());
			//Check if the eye is aimed at Link and there's a clear path before firing
			if(Abs(angleDifference(EyeAngle, AngleLink))<BEAMOS_IMPRECISION&&CheckPath(EyeX+8, EyeY+8, AngleLink, DistLink, BEAMOS_LASER_MINDIST, 6)){
				int Angle = Angle(Ghost_X+8, Ghost_Y+8, CenterLinkX(), CenterLinkY());
				int LStartX = EyeX+8;
				int LStartY = EyeY+8;
				int LEndX = LStartX;
				int LEndY = LStartY;
				int LaserLength = 0;
				bool LaserEnded = false;
				//Play the line of sight sound and flash briefly
				Game->PlaySound(SFX_BEAMOS_SIGHT);
				Ghost_StartFlashing(BEAMOS_FLASHFRAMES);
				for(int i=0; i<BEAMOS_FLASHFRAMES; i++){
					Beamos_ConveyorMove(this, ghost, onConveyor);
					Beamos_Draw(this, ghost, Combo, EyeAngle);
					Ghost_Waitframe(this, ghost, true, true);
				}
				//Fire the laser until it reaches full length or hits a wall
				Game->PlaySound(SFX_BEAMOS_LASER);
				while(Distance(LStartX, LStartY, LEndX, LEndY)<BEAMOS_LASER_LENGTH&&!LaserEnded){
					Beamos_ConveyorMove(this, ghost, onConveyor);
					EyeX = Ghost_X+VectorX(8, EyeAngle);
					EyeY = Ghost_Y+4+VectorY(5, EyeAngle);
					int LDist = Distance(LStartX, LStartY, LEndX, LEndY);
					LEndX += VectorX(BEAMOS_LASER_SPEED, Angle);
					LEndY += VectorY(BEAMOS_LASER_SPEED, Angle);
					LaserLength += BEAMOS_LASER_SPEED;
					if(((Beamos_LaserSolid(LEndX, LEndY))&&Distance(EyeX+8, EyeY+8, LEndX, LEndY)>=BEAMOS_LASER_MINDIST)||(LEndX<-16||LEndX>272||LEndY<-16||LEndY>192))
						LaserEnded = true;
					//Draw everything in order
					int EyeCombo = Combo+2+AngleDir8(EyeAngle);
					if(Link->HP>0){
						if(EyeAngle<=0){
							Screen->FastCombo(LAYER_BEAMOS2, EyeX, EyeY, EyeCombo, this->CSet, 128);
							Screen->Rectangle(LAYER_BEAMOS2, LStartX, LStartY-1, LStartX+LDist, LStartY+1, COLOR_BEAMOS_LASER2, 1, LStartX, LStartY, Angle, true, 128);
							Screen->Line(LAYER_BEAMOS2, LStartX, LStartY, LEndX, LEndY, COLOR_BEAMOS_LASER1, 1, 0, 0, 0, 128);
							Screen->FastCombo(LAYER_BEAMOS2, LStartX-8, LStartY-8, CMB_BEAMOS_LASER_ENDPOINT, CS_BEAMOS_LASER_ENDPOINT, 128);
						}
						Screen->FastCombo(LAYER_BEAMOS2, Ghost_X, Ghost_Y, Combo, this->CSet, 128);
						if(EyeAngle>0){
							Screen->FastCombo(LAYER_BEAMOS2, EyeX, EyeY, EyeCombo, this->CSet, 128);
							Screen->Rectangle(LAYER_BEAMOS2, LStartX, LStartY-1, LStartX+LDist, LStartY+1, COLOR_BEAMOS_LASER2, 1, LStartX, LStartY, Angle, true, 128);
							Screen->Line(LAYER_BEAMOS2, LStartX, LStartY, LEndX, LEndY, COLOR_BEAMOS_LASER1, 1, 0, 0, 0, 128);
							Screen->FastCombo(LAYER_BEAMOS2, LStartX-8, LStartY-8, CMB_BEAMOS_LASER_ENDPOINT, CS_BEAMOS_LASER_ENDPOINT, 128);
						}
						Screen->FastCombo(LAYER_BEAMOS1, Ghost_X, Ghost_Y+16, Combo+1, this->CSet, 128);
					}
					CheckBeamosLaser(ghost, LStartX, LStartY, LEndX, LEndY);
					Ghost_Waitframe(this, ghost, true, true);
				}
				//If it reaches full length
				if(!LaserEnded){
					while((!Beamos_LaserSolid(LEndX, LEndY)&&!(LEndX<-16||LEndX>272||LEndY<-16||LEndY>192))||Distance(EyeX+8, EyeY+8, LEndX, LEndY)<BEAMOS_LASER_MINDIST){
						Beamos_ConveyorMove(this, ghost, onConveyor);
						EyeX = Ghost_X+VectorX(8, EyeAngle);
						EyeY = Ghost_Y+4+VectorY(5, EyeAngle);
						int LDist = Distance(LStartX, LStartY, LEndX, LEndY);
						LStartX += VectorX(BEAMOS_LASER_SPEED, Angle);
						LStartY += VectorY(BEAMOS_LASER_SPEED, Angle);
						LEndX += VectorX(BEAMOS_LASER_SPEED, Angle);
						LEndY += VectorY(BEAMOS_LASER_SPEED, Angle);
						if(Beamos_LaserSolid(LEndX, LEndY))
							LaserEnded = true;
						if(EyeAngle<=0){
							Screen->Rectangle(LAYER_BEAMOS2, LStartX, LStartY-1, LStartX+LDist, LStartY+1, COLOR_BEAMOS_LASER2, 1, LStartX, LStartY, Angle, true, 128);
							Screen->Line(LAYER_BEAMOS2, LStartX, LStartY, LEndX, LEndY, COLOR_BEAMOS_LASER1, 1, 0, 0, 0, 128);
						}
						Beamos_Draw(this, ghost, Combo, EyeAngle);
						if(EyeAngle>0){
							Screen->Rectangle(LAYER_BEAMOS2, LStartX, LStartY-1, LStartX+LDist, LStartY+1, COLOR_BEAMOS_LASER2, 1, LStartX, LStartY, Angle, true, 128);
							Screen->Line(LAYER_BEAMOS2, LStartX, LStartY, LEndX, LEndY, COLOR_BEAMOS_LASER1, 1, 0, 0, 0, 128);
						}
						Screen->Rectangle(LAYER_BEAMOS2, LStartX, LStartY-1, LStartX+LDist, LStartY+1, COLOR_BEAMOS_LASER2, 1, LStartX, LStartY, Angle, true, 128);
						Screen->Line(LAYER_BEAMOS2, LStartX, LStartY, LEndX, LEndY, COLOR_BEAMOS_LASER1, 1, 0, 0, 0, 128);
						CheckBeamosLaser(ghost, LStartX, LStartY, LEndX, LEndY);
						Ghost_Waitframe(this, ghost, true, true);
					}
				}
				//Once the laser has hit a wall, make the ends meet again
				while(Distance(LStartX, LStartY, LEndX, LEndY)>BEAMOS_LASER_SPEED){
					Beamos_ConveyorMove(this, ghost, onConveyor);
					EyeX = Ghost_X+VectorX(8, EyeAngle);
					EyeY = Ghost_Y+4+VectorY(5, EyeAngle);
					int LDist = Distance(LStartX, LStartY, LEndX, LEndY);
					if(LaserLength>BEAMOS_LASER_LENGTH){
						LStartX += VectorX(BEAMOS_LASER_SPEED, Angle);
						LStartY += VectorY(BEAMOS_LASER_SPEED, Angle);
					}
					if(LaserLength<=BEAMOS_LASER_LENGTH)
						LaserLength += BEAMOS_LASER_SPEED;
					//Draw everything in order
					int EyeCombo = Combo+2+AngleDir8(EyeAngle);
					if(Link->HP>0){
						if(EyeAngle<=0){
							Screen->FastCombo(LAYER_BEAMOS2, EyeX, EyeY, EyeCombo, this->CSet, 128);
							Screen->Rectangle(LAYER_BEAMOS2, LStartX, LStartY-1, LStartX+LDist, LStartY+1, COLOR_BEAMOS_LASER2, 1, LStartX, LStartY, Angle, true, 128);
							Screen->Line(LAYER_BEAMOS2, LStartX, LStartY, LEndX, LEndY, COLOR_BEAMOS_LASER1, 1, 0, 0, 0, 128);
							if(LaserLength<=BEAMOS_LASER_LENGTH)
								Screen->FastCombo(LAYER_BEAMOS2, LStartX-8, LStartY-8, CMB_BEAMOS_LASER_ENDPOINT, CS_BEAMOS_LASER_ENDPOINT, 128);
							Screen->FastCombo(LAYER_BEAMOS2, LEndX-8, LEndY-8, CMB_BEAMOS_LASER_ENDPOINT, CS_BEAMOS_LASER_ENDPOINT, 128);
						}
						Screen->FastCombo(LAYER_BEAMOS2, Ghost_X, Ghost_Y, Combo, this->CSet, 128);
						if(EyeAngle>0){
							Screen->FastCombo(LAYER_BEAMOS2, EyeX, EyeY, EyeCombo, this->CSet, 128);
							Screen->Rectangle(LAYER_BEAMOS2, LStartX, LStartY-1, LStartX+LDist, LStartY+1, COLOR_BEAMOS_LASER2, 1, LStartX, LStartY, Angle, true, 128);
							Screen->Line(LAYER_BEAMOS2, LStartX, LStartY, LEndX, LEndY, COLOR_BEAMOS_LASER1, 1, 0, 0, 0, 128);
							if(LaserLength<=BEAMOS_LASER_LENGTH)
								Screen->FastCombo(LAYER_BEAMOS2, LStartX-8, LStartY-8, CMB_BEAMOS_LASER_ENDPOINT, CS_BEAMOS_LASER_ENDPOINT, 128);
							Screen->FastCombo(LAYER_BEAMOS2, LEndX-8, LEndY-8, CMB_BEAMOS_LASER_ENDPOINT, CS_BEAMOS_LASER_ENDPOINT, 128);
						}
						Screen->FastCombo(LAYER_BEAMOS1, Ghost_X, Ghost_Y+16, Combo+1, this->CSet, 128);
					}
					CheckBeamosLaser(ghost, LStartX, LStartY, LEndX, LEndY);
					Ghost_Waitframe(this, ghost, true, true);
				}
				for(int i=0; i<LaserCooldown; i++){
					Beamos_ConveyorMove(this, ghost, onConveyor);
					EyeAngle = WrapDegrees(EyeAngle+IncrementAngle);
					Beamos_Draw(this, ghost, Combo, EyeAngle);
					Ghost_Waitframe(this, ghost, true, true);
				}
			}
			Beamos_Draw(this, ghost, Combo, EyeAngle);
			Ghost_Waitframe(this, ghost, true, true);
		}
	}
}

const int FISTMOS_FLASHFRAMES = 32;
const int SFX_FISTMOS_CHARGE = 94;
const int SFX_FISTMOS_FIRE = 151;

const int CF_RISINGFISTMOS = CF_SCRIPT1;

ffc script FistBeamos{
	void Beamos_FindPosition(){
		int pos;
		for(int i=0; i<176*3; ++i){
			if(i<176*2)
				pos = Rand(176);
			else
				pos = i-(176*2);
			
			if(Screen->ComboF[pos]==CF_RISINGFISTMOS){
				if(i<176*2){
					if(Distance(ComboX(pos), ComboY(pos), Link->X, Link->Y)>32)
						break;
				}
				else{
					break;
				}
			}
		}
		
		Ghost_X = ComboX(pos);
		Ghost_Y = ComboY(pos)-16;
	}
	void Beamos_DrawPanel(bitmap beamos, int x, int y, int cmb, int cs, int panelXOff, int panelYOff){
		beamos->Clear(0);
		beamos->Rectangle(0, 0, 0, 15, 15, 0x0F, 1, 0, 0, 0, true, 128);
		beamos->FastCombo(0, panelXOff, panelYOff, cmb, cs, 128);
		beamos->Blit(0, RT_SCREEN, 0, 0, 16, 16, x, y, 16, 16, 0, 0, 0, BITDX_NORMAL, 0, false);
	}
	//This function draws the parts of the beamos in the right order
	void Beamos_DrawSubmerged(ffc this, npc ghost, bitmap beamos, int Combo, int EyeAngle, bool drawEye, int depth){
		bool eyeUnderneath = (depth>=16);
		
		int EyeX = Ghost_X+VectorX(8, EyeAngle);
		int EyeY = Ghost_Y+4+VectorY(5, EyeAngle);
		int EyeCombo = Combo+2+AngleDir8(EyeAngle);
		
		beamos->Clear(0);
		beamos->Rectangle(0, 0, 16, 15, 31, 0x0F, 1, 0, 0, 0, true, 128);
		if(eyeUnderneath&&EyeAngle<=0&&drawEye)
			beamos->FastCombo(0, EyeX-Ghost_X, EyeY-Ghost_Y+depth, EyeCombo, this->CSet, 128);
		beamos->FastCombo(0, 0, 0+depth, Combo, this->CSet, 128);
		beamos->FastCombo(0, 0, 0+depth+16, Combo+1, this->CSet, 128);
		if(eyeUnderneath&&EyeAngle>0&&drawEye)
			beamos->FastCombo(0, EyeX-Ghost_X, EyeY-Ghost_Y+depth, EyeCombo, this->CSet, 128);
		
		if(Link->HP>0){
			if(!eyeUnderneath&&EyeAngle<=0&&drawEye)
				Screen->FastCombo(LAYER_BEAMOS2, EyeX+ghost->DrawXOffset, EyeY+ghost->DrawYOffset+depth, EyeCombo, this->CSet, 128);
			beamos->Blit(LAYER_BEAMOS2, RT_SCREEN, 0, 0, 16, 16, Ghost_X+ghost->DrawXOffset, Ghost_Y+ghost->DrawYOffset, 16, 16, 0, 0, 0, BITDX_NORMAL, 0, true);
			//Screen->FastCombo(LAYER_BEAMOS2, Ghost_X+ghost->DrawXOffset, Ghost_Y+ghost->DrawYOffset, Combo, this->CSet, 128);
			if(!eyeUnderneath&&EyeAngle>0&&drawEye)
				Screen->FastCombo(LAYER_BEAMOS2, EyeX+ghost->DrawXOffset, EyeY+ghost->DrawYOffset+depth, EyeCombo, this->CSet, 128);
			beamos->Blit(LAYER_BEAMOS1, RT_SCREEN, 0, 16, 16, 16, Ghost_X+ghost->DrawXOffset, Ghost_Y+ghost->DrawYOffset+16, 16, 16, 0, 0, 0, BITDX_NORMAL, 0, true);
			//Screen->FastCombo(LAYER_BEAMOS1, Ghost_X+ghost->DrawXOffset, Ghost_Y+16+ghost->DrawYOffset, Combo+1, this->CSet, 128);
		}
	}
	void Beamos_Draw(ffc this, npc ghost, int Combo, int EyeAngle, bool drawEye){
		int EyeX = Ghost_X+VectorX(8, EyeAngle);
		int EyeY = Ghost_Y+4+VectorY(5, EyeAngle);
		int EyeCombo = Combo+2+AngleDir8(EyeAngle);
		if(Link->HP>0){
			if(EyeAngle<=0&&drawEye)
				Screen->FastCombo(LAYER_BEAMOS2, EyeX+ghost->DrawXOffset, EyeY+ghost->DrawYOffset, EyeCombo, this->CSet, 128);
			Screen->FastCombo(LAYER_BEAMOS2, Ghost_X+ghost->DrawXOffset, Ghost_Y+ghost->DrawYOffset, Combo, this->CSet, 128);
			if(EyeAngle>0&&drawEye)
				Screen->FastCombo(LAYER_BEAMOS2, EyeX+ghost->DrawXOffset, EyeY+ghost->DrawYOffset, EyeCombo, this->CSet, 128);
			Screen->FastCombo(LAYER_BEAMOS1, Ghost_X+ghost->DrawXOffset, Ghost_Y+16+ghost->DrawYOffset, Combo+1, this->CSet, 128);
		}
	}
	//This function checks the path of the beamos' laser before firing
	bool CheckPath(int X, int Y, int Angle, int Distance, int SafeDist, int Step){
		for(int i = 0; i<Distance-Step; i+=Step){
			X += VectorX(Step, Angle);
			Y += VectorY(Step, Angle);
			if(!ComboFI(X, Y, 107)){
				if(((Screen->isSolid(X, Y)&&i>SafeDist)||Screen->ComboF[ComboAt(X, Y)]==97))
					return false;
			}
		}
		return true;
	}
	void Beamos_ConveyorMove(ffc this, npc ghost, bool onConveyor){
		if(onConveyor){
			int vX;
			int vY;
			for(int i=0; i<4; ++i){
				int x = Ghost_X+(i%2)*15;
				int y = Ghost_Y+16+Floor(i/2)*15;
				switch(Screen->ComboT[ComboAt(x, y)]){
					case CT_CVUP:
						vY -= 0.5;
						break;
					case CT_CVDOWN:
						vY += 0.5;
						break;
					case CT_CVLEFT:
						vX -= 0.5;
						break;
					case CT_CVRIGHT:
						vX += 0.5;
						break;
				}
				vX = Clamp(vX, -0.5, 0.5);
				vY = Clamp(vY, -0.5, 0.5);
			}
			Ghost_MoveXY(vX, vY, 0);
			SolidObjects_Add(0, Ghost_X, Ghost_Y+16, 16, 16, 0, 0, 0);
		}
	}
	void run(int enemyid){
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		int StartAngle = ghost->Attributes[0];
		int IncrementAngle = ghost->Attributes[1];
		StartAngle = WrapDegrees(StartAngle);
		if(Abs(AngDiff(StartAngle+22.5*Sign(IncrementAngle), Angle(Ghost_X, Ghost_Y, Link->X, Link->Y)))<=30){
			StartAngle += 90*Sign(IncrementAngle);
		}
		int LaserCooldown = ghost->Attributes[2];
		int NoCollision = ghost->Attributes[3];
		int SubmergeTime = ghost->Attributes[4];
		int SubmergeDelay = ghost->Attributes[5];
		int Combo = ghost->Attributes[10];
		Ghost_Transform(this, ghost, GH_INVISIBLE_COMBO, ghost->CSet, 1, 2);
		Ghost_Y-=8;
		ghost->DrawYOffset = 0;
		if(NoCollision==1)
			ghost->CollDetection = false;
		Ghost_SetHitOffsets(ghost, 16, 0, 0, 0);
		int EyeAngle = WrapDegrees(StartAngle);
		this->Flags[FFCF_IGNOREHOLDUP] = true;
		bool onConveyor;
		bool risingBeamos;
		bool submerged;
		mapdata l1 = Game->LoadTempScreen(1);
		if(SubmergeTime){
			submerged = true;
			risingBeamos = true;
		}
		bitmap beamos = Game->CreateBitmap(16, 32);
		beamos->Own();
		
		switch(Screen->ComboT[ComboAt(Ghost_X+8, Ghost_Y+24)]){
			case CT_CVUP:
			case CT_CVDOWN: 
			case CT_CVLEFT:
			case CT_CVRIGHT:
				onConveyor = true;
				break;
		}
		if(!onConveyor&&!submerged){
			mapdata l1 = Game->LoadTempScreen(1);
			l1->ComboD[ComboAt(Ghost_X+8, Ghost_Y+24)] = 1;
		}
		if(SubmergeDelay)
			Ghost_Waitframes(this, ghost, SubmergeDelay);
		while(true){
			if(submerged){
				Ghost_Waitframes(this, ghost, SubmergeTime);
				Beamos_FindPosition();
				int pos = ComboAt(Ghost_X+8, Ghost_Y+24);
				int panelCMB = Screen->ComboD[pos];
				int panelCS = Screen->ComboC[pos];
				Game->PlaySound(89);
				for(int i=0; i<2; ++i){
					SolidObjects_Add(0, Ghost_X, Ghost_Y+16, 16, 16, 0, 0, 0);
					Beamos_DrawPanel(beamos, Ghost_X, Ghost_Y+16, panelCMB, panelCS, 0, i);
					Ghost_Waitframe(this, ghost);
				}
				for(int i=0; i>-16; --i){
					SolidObjects_Add(0, Ghost_X, Ghost_Y+16, 16, 16, 0, 0, 0);
					Beamos_DrawPanel(beamos, Ghost_X, Ghost_Y+16, panelCMB, panelCS, i, 2);
					Ghost_Waitframe(this, ghost);
				}
				l1->ComboD[pos] = 1;
				EyeAngle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
				for(int i=32; i>0; --i){
					SolidObjects_Add(0, Ghost_X, Ghost_Y+16, 16, 16, 0, 0, 0);
					Beamos_DrawSubmerged(this, ghost, beamos, Combo, EyeAngle, true, i);
					Ghost_Waitframe(this, ghost);
				}
				submerged = false;
			}
			Beamos_ConveyorMove(this, ghost, onConveyor);
			if(!risingBeamos)
				EyeAngle = WrapDegrees(EyeAngle+IncrementAngle);
			int EyeX = Ghost_X+VectorX(8, EyeAngle);
			int EyeY = Ghost_Y+4+VectorY(5, EyeAngle);
			int AngleLink = Angle(EyeX+8, EyeY+8, CenterLinkX(), CenterLinkY());
			int DistLink = Distance(EyeX+8, EyeY+8, CenterLinkX(), CenterLinkY());
			if(risingBeamos)
				EyeAngle = TurnToAngle(EyeAngle, AngleLink, 10);
			//Check if the eye is aimed at Link and there's a clear path before firing
			if(Abs(angleDifference(EyeAngle, AngleLink))<BEAMOS_IMPRECISION&&CheckPath(EyeX+8, EyeY+8, AngleLink, DistLink, BEAMOS_LASER_MINDIST, 6)){
				int Angle = Angle(Ghost_X+8, Ghost_Y+8, CenterLinkX(), CenterLinkY());
				int LStartX = EyeX+8;
				int LStartY = EyeY+8;
				int LEndX = LStartX;
				int LEndY = LStartY;
				int LaserLength = 0;
				bool LaserEnded = false;
				//Play the line of sight sound and flash briefly
				// Game->PlaySound(SFX_BEAMOS_SIGHT);
				// Ghost_StartFlashing(BEAMOS_FLASHFRAMES);
				Game->PlaySound(SFX_FISTMOS_CHARGE);
				for(int i=0; i<FISTMOS_FLASHFRAMES; i++){
					int j = Lerp(3, 1, i/(FISTMOS_FLASHFRAMES-1));
					ghost->DrawXOffset = Rand(-j, j);
					ghost->DrawYOffset = Rand(-j, j);
					Beamos_ConveyorMove(this, ghost, onConveyor);
					Beamos_Draw(this, ghost, Combo, EyeAngle, true);
					Ghost_Waitframe(this, ghost, true, true);
				}
				ghost->DrawXOffset = 0;
				ghost->DrawYOffset = 0;
				//Fire the fist until it goes offscreen or hits a wall
				Game->PlaySound(SFX_FISTMOS_FIRE);
				int layer = (EyeAngle<=0)?1:2;
				eweapon e = CreateEWeaponAt(EW_SCRIPT10, Ghost_X, Ghost_Y+16);
				RunEWeaponEffect(e, "FistmosFist", {EyeX, EyeY, EyeAngle, 4, layer});
				while(e->isValid()){
					Beamos_ConveyorMove(this, ghost, onConveyor);
					Beamos_Draw(this, ghost, Combo, EyeAngle, false);
					Ghost_Waitframe(this, ghost, true, true);
				}
				if(risingBeamos){
					Game->PlaySound(165);
					int pos = ComboAt(Ghost_X+8, Ghost_Y+24);
					int panelCMB = Screen->ComboD[pos];
					int panelCS = Screen->ComboC[pos];
					for(int i=0; i<32; ++i){
						SolidObjects_Add(0, Ghost_X, Ghost_Y+16, 16, 16, 0, 0, 0);
						Beamos_DrawSubmerged(this, ghost, beamos, Combo, EyeAngle, true, i);
						Ghost_Waitframe(this, ghost);
					}
					l1->ComboD[pos] = 0;
					for(int i=-16; i<0; ++i){
						SolidObjects_Add(0, Ghost_X, Ghost_Y+16, 16, 16, 0, 0, 0);
						Beamos_DrawPanel(beamos, Ghost_X, Ghost_Y+16, panelCMB, panelCS, i, 2);
						Ghost_Waitframe(this, ghost);
					}
					for(int i=2; i>0; --i){
						SolidObjects_Add(0, Ghost_X, Ghost_Y+16, 16, 16, 0, 0, 0);
						Beamos_DrawPanel(beamos, Ghost_X, Ghost_Y+16, panelCMB, panelCS, 0, i);
						Ghost_Waitframe(this, ghost);
					}
					submerged = true;
				}
				else{
					for(int i=0; i<LaserCooldown; i++){
						Beamos_ConveyorMove(this, ghost, onConveyor);
						EyeAngle = WrapDegrees(EyeAngle+IncrementAngle);
						Beamos_Draw(this, ghost, Combo, EyeAngle, true);
						Ghost_Waitframe(this, ghost, true, true);
					}
				}
			}
			if(!submerged)
				Beamos_Draw(this, ghost, Combo, EyeAngle, true);
			Ghost_Waitframe(this, ghost, true, true);
		}
	}
}

const int CMB_FISTMOSPROJECTILE = 52092;

eweapon script FistmosFist{
	bool FFIsSolid(int x, int y){
		int pos = ComboAt(x, y);
		// switch(Screen->ComboT[pos]){
			// case CT_LADDERHOOKSHOT:
				// return false;
		// }
		// mapdata l1 = Game->LoadTempScreen(1);
		// switch(l1->ComboT[pos]){
			// case CT_LADDERHOOKSHOT:
				// return false;
		// }
		return Screen->isSolid(x, y);
	}
	void run(int startX, int startY, int angle, int step, int layer){
		int x = startX;
		int y = startY;
		bool grabbedLink;
		eweapon hitbox = CreateEWeaponAt(EW_SCRIPT10, x, y);
		hitbox->DrawYOffset = -1000;
		hitbox->Damage = 0;
		hitbox->Step = 0;
		hitbox->Dir = Link->Dir;
		int safetyFrames = 6;
		while(true){
			if(x<-16||x>256||y<-16||y>176)
				break;
			if(safetyFrames<=0&&FFIsSolid(x+8+VectorX(8, angle), y+8+VectorY(8, angle))){
				Game->PlaySound(SFX_BOMB);
				Screen->Quake = 4;
				break;
			}
			
			if(safetyFrames)
				--safetyFrames;
			
			if(!hitbox->isValid()){
				hitbox = CreateEWeaponAt(EW_SCRIPT10, x, y);
				hitbox->DrawYOffset = -1000;
				hitbox->Damage = 0;
				hitbox->Step = 0;
				hitbox->Dir = Link->Dir;
			}
			
			if(!grabbedLink&&Link->HitBy[1]){ //EWeapon
				eweapon e = Screen->LoadEWeapon(Link->HitBy[1]); //EWeapon
				if(e==hitbox){
					Game->PlaySound(SFX_EHIT);
					grabbedLink = true;
				}
			}
			
			if(grabbedLink){
				Link->HitDir = -1;
				TurnOffLinkCollision(2);
				MakeLinkInvisible(2);
				SetLinkPitImmune(2);
				G[G_NOACTION] = 1;
				NoAction();
			}
			
			angle = TurnToAngle(angle, Angle(x, y, Link->X, Link->Y), 2);
			
			x += VectorX(step, angle);
			y += VectorY(step, angle);
			
			hitbox->X = x;
			hitbox->Y = y;
			hitbox->Dir = Link->Dir;
			hitbox->DeadState = WDS_ALIVE;
			
			for(int i=0; i<10; ++i){
				int tempX = Lerp(startX, x, i/10);
				int tempY = Lerp(startY, y, i/10);
				Screen->FastCombo(layer, tempX, tempY, CMB_FISTMOSPROJECTILE-1, 7, 128);
			}
			if(grabbedLink)
				Screen->FastCombo(layer, x, y, CMB_FISTMOSPROJECTILE+8+AngleDir8(angle), 7, 128);
			else
				Screen->FastCombo(layer, x, y, CMB_FISTMOSPROJECTILE+AngleDir8(angle), 7, 128);
			
			Waitframe();
		}
		if(hitbox->isValid())
			hitbox->DeadState = 0;
		int angleStart;
		while(Distance(x, y, startX, startY)>8){
			if(grabbedLink){
				Link->HitDir = -1;
				TurnOffLinkCollision(2);
				MakeLinkInvisible(2);
				SetLinkPitImmune(2);
				G[G_NOACTION] = 1;
				NoAction();
			}
			
			angleStart = Angle(x, y, startX, startY);
			x += VectorX(8, angleStart);
			y += VectorY(8, angleStart);
			
			for(int i=0; i<10; ++i){
				int tempX = Lerp(startX, x, i/10);
				int tempY = Lerp(startY, y, i/10);
				Screen->FastCombo(layer, tempX, tempY, CMB_FISTMOSPROJECTILE-1, 7, 128);
			}
			Screen->FastCombo(layer, x, y, CMB_FISTMOSPROJECTILE+8+AngleDir8(angle), 7, 128);
			
			Waitframe();
		}
		if(grabbedLink){
			Link->WarpEx({WT_IWARPBLACKOUT, Game->LastEntranceDMap, Game->LastEntranceScreen-Game->DMapOffset[Game->LastEntranceDMap], -1, 0, WARPEFFECT_INSTANT, 0, WARP_FLAG_PLAYMUSIC});
		}
		this->DeadState = 0;
	}
}

//These following two functions are taken from theRandomHeader.zh. If you're using that, you can delete them here.
// Function to see if a box has collided with a line
bool lineBoxCollision(int lineX1, int lineY1, int lineX2, int lineY2, int boxX1, int boxY1, int boxX2, int boxY2, int boxBorder)
{
	// Shrink down the box for the border
	boxX1 += boxBorder; boxY1 += boxBorder;
	boxX2 -= boxBorder; boxY2 -= boxBorder;
	
	// If the line isn't vertical
	if(lineX2!=lineX1)
	{
		
		float i0 = (boxX1 - lineX1)/(lineX2-lineX1);
		float i1 = (boxX2 - lineX1)/(lineX2-lineX1);
		
		float yA = lineY1 + i0*(lineY2-lineY1);
		float yB = lineY1 + i1*(lineY2-lineY1);
		
		
		if(Max(boxX1, boxX2) >= Min(lineX1, lineX2) && Min(boxX1, boxX2) <= Max(lineX1, lineX2) &&
			Max(boxY1, boxY2) >= Min(lineY1, lineY2) && Min(boxY1, boxY2) <= Max(lineY1, lineY2))
		{
			if(Min(boxY1, boxY2) > Max(yA, yB) || Max(boxY1, boxY2) < Min(yA, yB))
				return false;
			else
				return true;
		}
		else
			return false;
	}
	// If the line is vertical
	else if(lineX1 >= boxX1 && lineX1 <= boxX2)
	{
		// Basically we need to find the top and bottom y values of the line to check for intersection
		float lineYMin = lineY1;
		float lineYMax = lineY2;
		
		if(lineYMin > lineYMax)
		{
			lineYMin = lineY2;
			lineYMax = lineY1;
		}
		
		// If either point intersects
		if((boxY1 >= lineYMin && boxY1 <= lineYMax) || (boxY2 >= lineYMin && boxY2 <= lineYMax))
			return true;
	}
	
	return false;
} //! End of lineBoxCollision

// Function to get the difference between two angles
float angleDifference(float angle1, float angle2)
{
	// Get the difference between the two angles
	float dif = angle2 - angle1;
	
	// Compensate for the difference being outside of normal bounds
	if(dif >= PI)
		dif -= 2 * PI;
	else if(dif <= -1 * PI)
		dif += 2 * PI;
		
	return dif;
}

const int FFCS_MICAH = 74;
const int DAMAGE_MICAH_SWORD = 250;
const int DAMAGE_MICAH_MAGIC = 300;

ffc script FriendlyNeighborhoodCultistMan{
	void run(int specialCase, int a1, int a2, int a3, int a4, int a5, int a6, int a7){
		if(Game->GetCurDMap() == 37){
			if(Game->Counter[CR_CULTISTQUEST]>5)
				Quit();
		}
		else{
			if(Game->Counter[CR_MISCSIDEQUEST]!=6)
				Quit();
		}
		switch(specialCase){
			case 0: //Enemy Battle
				runNPCFollower(this, a1);
				break;
			case 1: //Path
				runNPCPath(this, a1, a2, a3);
				break;
		}
	}
	void DrawTheGuyNoHitbox(ffc this, int x, int y, int dir, int cmb){
		x = Round(x);
		y = Round(y);
		this->X = x;
		this->Y = y;
		combodata cd = Game->LoadComboData(cmb+dir);
		Screen->DrawTile(3, x, y-16, cd->Tile, 1, 1, 11, -1, -1, 0, 0, 0, cd->Flip, true, 128);
		Screen->DrawTile(2, x, y, cd->Tile+20, 1, 1, 11, -1, -1, 0, 0, 0, cd->Flip, true, 128);
	}
	void DrawTheGuyNoHitbox(ffc this, int x, int y, int dir, int cmb, int z){
		x = Round(x);
		y = Round(y);
		this->X = x;
		this->Y = y;
		combodata cd = Game->LoadComboData(cmb+dir);
		DrawShadow1x1(x, y);
		Screen->DrawTile(3, x, y-z-16, cd->Tile, 1, 1, 11, -1, -1, 0, 0, 0, cd->Flip, true, 128);
		Screen->DrawTile(2, x, y-z, cd->Tile+20, 1, 1, 11, -1, -1, 0, 0, 0, cd->Flip, true, 128);
	}
	void DrawTheGuy(ffc this, int x, int y, int dir, int cmb){
		x = Round(x);
		y = Round(y);
		this->X = x;
		this->Y = y;
		combodata cd = Game->LoadComboData(cmb+dir);
		Screen->DrawTile(3, x, y-16, cd->Tile, 1, 1, 11, -1, -1, 0, 0, 0, cd->Flip, true, 128);
		Screen->DrawTile(2, x, y, cd->Tile+20, 1, 1, 11, -1, -1, 0, 0, 0, cd->Flip, true, 128);
		SolidObjects_Add(0, x+2, y+2, 12, 12, 0, 0, 0);
	}
	void DrawTheGuy(ffc this, int x, int y, int dir, int cmb, int z){
		x = Round(x);
		y = Round(y);
		this->X = x;
		this->Y = y;
		combodata cd = Game->LoadComboData(cmb+dir);
		DrawShadow1x1(x, y);
		Screen->DrawTile(3, x, y-z-16, cd->Tile, 1, 1, 11, -1, -1, 0, 0, 0, cd->Flip, true, 128);
		Screen->DrawTile(2, x, y-z, cd->Tile+20, 1, 1, 11, -1, -1, 0, 0, 0, cd->Flip, true, 128);
		SolidObjects_Add(0, x+2, y+2, 12, 12, 0, 0, 0);
	}
	int PathWalkable(int x1, int y1, int x2, int y2){
		int x = x1; int y = y1;
		while(Distance(x, y, x2, y2)>8){
			int angle = Angle(x, y, x2, y2);
			x += VectorX(8, angle);
			y += VectorY(8, angle);
			if(Screen->isSolid(x, y))
				return Distance(x, y, x2, y2);
		}
		return 0;
	}
	bool Micah_IsSolid(int x, int y) 
	{
		int pos = ComboAt(x, y);
		if(Screen->ComboT[pos]==CT_PITFALL)
			return true;
		if(Screen->ComboT[pos]==CT_WATER)
			return true;
		return Screen->isSolid(x, y);
	}
	bool Micah_CanWalk(int x, int y, int dir, int step, bool full_tile) 
	{
		int c=8;
		int xx = x+15;
		int yy = y+15;
		if(full_tile) c=0;
		switch(DirNormal(dir))
		{
			case DIR_UP: return !(y-step<0||Micah_IsSolid(x,y+c-step)||Micah_IsSolid(x+8,y+c-step)||Micah_IsSolid(xx,y+c-step));
			case DIR_DOWN: return !(yy+step>=176||Micah_IsSolid(x,yy+step)||Micah_IsSolid(x+8,yy+step)||Micah_IsSolid(xx,yy+step));
			case DIR_LEFT: return !(x-step<0||Micah_IsSolid(x-step,y+c)||Micah_IsSolid(x-step,y+c+7)||Micah_IsSolid(x-step,yy));
			case DIR_RIGHT: return !(xx+step>=256||Micah_IsSolid(xx+step,y+c)||Micah_IsSolid(xx+step,y+c+7)||Micah_IsSolid(xx+step,yy));
			default: { printf("Invalid direction %d passed to CanWalk(x,y,dir,step,bool) \n",dir); return false; } //invalid direction
		}
	}
	void Move(int xy, int angle, int step){
		xy[2] += VectorX(step, angle);
		xy[3] += VectorY(step, angle);
		int stepX = Floor(Abs(xy[2]));
		int stepY = Floor(Abs(xy[3]));
		for(int i=0; i<stepX; ++i){
			if(xy[2]<0){
				if(Micah_CanWalk(xy[0], xy[1], DIR_LEFT, 1, false))
					--xy[0];
			}
			else if(xy[2]>0){
				if(Micah_CanWalk(xy[0], xy[1], DIR_RIGHT, 1, false))
					++xy[0];
			}
		}
		for(int i=0; i<stepY; ++i){
			if(xy[3]<0){
				if(Micah_CanWalk(xy[0], xy[1], DIR_UP, 1, false))
					--xy[1];
			}
			else if(xy[3]>0){
				if(Micah_CanWalk(xy[0], xy[1], DIR_DOWN, 1, false))
					++xy[1];
			}
		}
		xy[2] -= stepX*Sign(xy[2]);
		xy[3] -= stepY*Sign(xy[3]);
	}
	void SmartMove(int xy, int angle, int step, int tX, int tY){
		int dir = AngleDir4(WrapDegrees(angle));
		if(!Micah_CanWalk(xy[0], xy[1], dir, 1, false)){
			int backupXY[4];
			for(int j=0; j<4; ++j)
				backupXY[j] = xy[j];
			int closestDist = Distance(xy[0], xy[1], tX, tY);
			int closestAngle = angle;
			for(int i=-1; i<=1; i+=2){
				int newAngle = DirAngle(dir)+90*i;
				Move(xy, newAngle, step);
				int dist = Distance(xy[0], xy[1], tX, tY);
				for(int j=0; j<4; ++j)
					xy[j] = backupXY[j];
				if(dist<closestDist){
					closestAngle = newAngle;
					closestDist = dist;
				}
			}
			Move(xy, closestAngle, step);
		}
		else
			Move(xy, angle, step);
	}
	void runNPCFollower(ffc this, int specialCase){
		if(specialCase!=2){
			if(Game->GetCurDMap() == 37){
				while(Link->X<32||Link->X>208||Link->Y<24||Link->Y>128){
					Waitframe();
				}
			}
		}
		
		int CMB_FOLLOWERMOVING = 33648;
		int CMB_FOLLOWERATTACKING = 51884;
		if(Game->GetCurDMap() != 37){
			CMB_FOLLOWERMOVING = 33584;
			CMB_FOLLOWERATTACKING = 33780;
		}
		
		int dir = Link->Dir;
		int xy[4];
		int xy2[2];
		xy[0] = Link->X;
		xy[1] = Link->Y;
		if(Screen->ComboT[ComboAt(Link->X, Link->Y)]==CT_WATER || Screen->ComboT[ComboAt(Link->X, Link->Y+8)]==CT_WATER)
			xy[1] -= 24;
		int angle;
		int mode;
		int state; int stateTimer;
		npc target;
		int swordCooldown;
		int magicCooldown;
		if(specialCase==1){
			xy[0] = this->X;
			xy[1] = this->Y-16;
			for(int i=0; i<120; ++i){
				Waitframe();
			}
			for(int i=0; i<11; ++i){
				xy[1] += 1.5;
				DrawTheGuyNoHitbox(this, xy[0], xy[1], DIR_DOWN, CMB_FOLLOWERMOVING);
					Waitframe();
			}
			Game->PlaySound(SFX_JUMP);
			int jump = FindJumpLength(16, true);
			int z;
			for(int i=0; i<16; ++i){
				xy[1] += 2;
				jump = Clamp(jump-0.16, -3.2, 3.2);
				z += jump;
				DrawTheGuyNoHitbox(this, xy[0], xy[1], DIR_DOWN, CMB_FOLLOWERMOVING, z);
				Waitframe();
			}
			dir = DIR_DOWN;
		}
		else if(specialCase==2){
			xy[0] = this->X;
			xy[1] = this->Y;
		}
		int puzzleSolveCooldown = 16;
		while(true){
			int tX; int tY;
			bool walkToPoint;
			if(Game->GetCurDMap() != 37)
				magicCooldown = 9999;
			switch(mode){
				case 0: //Follow Link
					tX = Link->X;
					tY = Link->Y;
					walkToPoint = false;
					//Special exception for the Aevin button
					if(Game->GetCurDMap()==37&&Game->GetCurScreen()==0x33){
						int numUnpressed = NumSwitchesOf(28504);
						int numPressed = NumSwitchesOf(28505);
						if(numUnpressed+numPressed<=2&&(numUnpressed>0||puzzleSolveCooldown)){
							if(RectCollision(Link->X, Link->Y, Link->X+15, Link->Y+15, 32, 32, 111, 79)){
								if(Distance(xy[0], xy[1], ComboX(51), ComboY(51))<Distance(xy[0], xy[1], ComboX(53), ComboY(53))){
									tX = ComboX(51);
									tY = ComboY(51);
									walkToPoint = true;
								}
								else{
									tX = ComboX(53);
									tY = ComboY(53);
									walkToPoint = true;
								}
							}
							if(puzzleSolveCooldown&&numUnpressed==0){
								--puzzleSolveCooldown;
							}
						}
					}
					if(walkToPoint){
						if(Distance(xy[0], xy[1], tX, tY)>1.5){
							SmartMove(xy, Angle(xy[0], xy[1], tX, tY), 1.5, tX, tY);
						}
						else{
							xy[0] = tX;
							xy[1] = tY;
						}
					}
					else if(Distance(xy[0], xy[1], tX, tY)>16){
						SmartMove(xy, Angle(xy[0], xy[1], tX, tY), 1.5, tX, tY);
					}
					if(Distance(xy[0], xy[1], tX, tY)>1)
						dir = AngleDir4(Angle(xy[0], xy[1], tX, tY));
					else
						dir = AngleDir4(Angle(xy[0], xy[1], Link->X, Link->Y));
					DrawTheGuyNoHitbox(this, xy[0], xy[1], dir, CMB_FOLLOWERMOVING);
					npc closestMelee;
					npc closestMagic;
					int closestDistMelee = 1000;
					int closestDistMagic = 0;
					for(int i=Screen->NumNPCs(); i>0; --i){
						npc n = Screen->LoadNPC(i);
						if(n->CollDetection&&!n->InvFrames){
							int dist = Distance(xy[0]+8, xy[1]+8, HitboxCenterX(n), HitboxCenterY(n));
							if(n->Defense[NPCD_SCRIPT3]!=NPCDT_BLOCK&&n->Defense[NPCD_SCRIPT3]!=NPCDT_IGNORE){
								if(dist<closestDistMelee){
									if(PathWalkable(xy[0]+8, xy[1]+8, HitboxCenterX(n), HitboxCenterY(n))<16){
										closestMelee = n;
										closestDistMelee = dist;
									}
								}
							}
							if(n->Defense[NPCD_SCRIPT1]!=NPCDT_BLOCK&&n->Defense[NPCD_SCRIPT1]!=NPCDT_IGNORE){
								if(dist>closestDistMagic){
									closestMagic = n;
									closestDistMagic = dist;
								}
							}
						}
					}
					if(closestMelee->isValid()&&!swordCooldown){
						if(Distance(xy[0]+8, xy[1]+8, HitboxCenterX(closestMelee), HitboxCenterY(closestMelee))<64){
							target = closestMelee;
							mode = 1;
							state = 0;
							stateTimer = 0;
						}
					}
					if(closestMagic->isValid()&&!magicCooldown){
						if(Rand(Max(16, Floor(closestDistMagic*2)))==0){
							target = closestMagic;
							mode = 2;
							state = 0;
							stateTimer = 0;
						}
					}
					break;
				case 1: //Attack (Melee)
					switch(state){
						case 0: //Walk to enemy
							npc closestMelee;
							int closestDistMelee = 1000;
							for(int i=Screen->NumNPCs(); i>0; --i){
								npc n = Screen->LoadNPC(i);
								if(n->CollDetection&&!n->InvFrames){
									int dist = Distance(xy[0]+8, xy[1]+8, HitboxCenterX(n), HitboxCenterY(n));
									if(n->Defense[NPCD_SCRIPT3]!=NPCDT_BLOCK&&n->Defense[NPCD_SCRIPT3]!=NPCDT_IGNORE){
										if(dist<closestDistMelee){
											if(PathWalkable(xy[0]+8, xy[1]+8, HitboxCenterX(n), HitboxCenterY(n))<16){
												closestMelee = n;
												closestDistMelee = dist;
											}
										}
									}
								}
							}
							if(closestMelee->isValid())
								target = closestMelee;
							if(!target->isValid())
								mode = 0;
							else{
								if(Distance(xy[0], xy[1], HitboxCenterX(target)-8, HitboxCenterY(target)-8)>(Max(target->HitHeight, target->HitWidth)/2+16)){
									SmartMove(xy, Angle(xy[0], xy[1], HitboxCenterX(target)-8, HitboxCenterY(target)-8), 1.5, HitboxCenterX(target)-8, HitboxCenterY(target)-8);
								}
								else{
									Game->PlaySound(SFX_SWORD);
									state = 1;
									angle = Angle(xy[0], xy[1], HitboxCenterX(target)-8, HitboxCenterY(target)-8);
									stateTimer = 0;
								}
								dir = AngleDir4(Angle(xy[0], xy[1], HitboxCenterX(target)-8, HitboxCenterY(target)-8));
								
							}
							DrawTheGuyNoHitbox(this, xy[0], xy[1], dir, CMB_FOLLOWERMOVING);
							break;
						case 1: //Slash 1
							QuickSwordLW(LW_PHYSICAL, xy[0], xy[1], angle-60, stateTimer*4, 51466, 9, DAMAGE_MICAH_SWORD);
							++stateTimer;
							if(stateTimer==3){
								state = 2;
								stateTimer = 0;
							}
							DrawTheGuyNoHitbox(this, xy[0], xy[1], dir, CMB_FOLLOWERATTACKING);
							break;
						case 2: //Slash 2
							QuickSwordLW(LW_PHYSICAL, xy[0], xy[1], angle-60+Lerp(0, 120, stateTimer/8), 12, 51466, 9, DAMAGE_MICAH_SWORD);
							++stateTimer;
							if(stateTimer==3){
								state = 3;
								stateTimer = 0;
							}
							DrawTheGuyNoHitbox(this, xy[0], xy[1], dir, CMB_FOLLOWERATTACKING);
							break;
						case 3: //Slash 3
							QuickSwordLW(LW_PHYSICAL, xy[0], xy[1], angle+60, 12-stateTimer*4, 51466, 9, DAMAGE_MICAH_SWORD);
							++stateTimer;
							if(stateTimer==3){
								mode = 0;
								swordCooldown = 64;
							}
							DrawTheGuyNoHitbox(this, xy[0], xy[1], dir, CMB_FOLLOWERATTACKING);
							break;
					}
					break;
				case 2: //Attack Ranged
					switch(state){
						case 0: //Aiming
							if(target->isValid()){
								angle = Angle(xy[0], xy[1], HitboxCenterX(target)-8, HitboxCenterY(target)-8);
								dir = AngleDir4(angle);
								GetDirXYOffset(xy2, dir, {13,1, 8,12, 1,7, 14,7}); //Reach forward
								Screen->Circle(dir==DIR_UP?1:4, xy[0]+xy2[0], xy[1]+xy2[1], Rand(4, 6), Choose(0x86, 0x87, 0x88), 1, 0, 0, 0, true, 128);
								++stateTimer;
								if(stateTimer==32)
									Game->PlaySound(SFX_CHARGE1);
								if(stateTimer==48){
									state = 1;
									stateTimer = 0;
								}
								DrawTheGuyNoHitbox(this, xy[0], xy[1], dir, CMB_FOLLOWERATTACKING);
							}
							else
								mode = 0;
							break;
						case 1: //Firing
							GetDirXYOffset(xy2, dir, {13,1, 8,12, 1,7, 14,7}); //Reach forward
							Screen->Circle(dir==DIR_UP?1:4, xy[0]+xy2[0], xy[1]+xy2[1], Rand(4, 6), Choose(0x86, 0x87, 0x88), 1, 0, 0, 0, true, 128);
								
							if(stateTimer%4==0){
								lweapon l = FireLWeapon(LW_SOLAR, xy[0]+xy2[0]-8, xy[1]+xy2[1]-8, angle+Rand(-10, 10), 300, DAMAGE_MICAH_MAGIC, SPR_LIGHTSHOT, 32);
								l->Rotation = angle;
							}
							
							++stateTimer;
							if(stateTimer==20){
								mode = 0;
								magicCooldown = 180;
							}
							DrawTheGuyNoHitbox(this, xy[0], xy[1], dir, CMB_FOLLOWERATTACKING);
							break;
					}
					break;
			}
			if(swordCooldown)
				--swordCooldown;
			if(magicCooldown && Game->GetCurDMap() == 37)
				--magicCooldown;
			Waitframe();
		}
	}
	void runNPCPath(ffc this, int startDir, int targetX, int targetY){
		int dir = Link->Dir;
		int xy[4];
		int xy2[2];
		while(Link->X<32||Link->X>208||Link->Y<24||Link->Y>128){
			Waitframe();
		}
		xy[0] = this->X;
		xy[1] = this->Y;
		if(targetX>0&&targetY>0){
			while(Distance(xy[0], xy[1], targetX, targetY)>1.5){
				SmartMove(xy, Angle(xy[0], xy[1], targetX, targetY), 1.5, targetX, targetY);
				DrawTheGuy(this, xy[0], xy[1], dir, 33648);
				Waitframe();
			}
			xy[0] = targetX;
			xy[1] = targetY;
		}
		else if(targetX>0){
			targetY = ComboY(targetX);
			targetX = ComboX(targetX);
			while(Distance(xy[0], xy[1], targetX, targetY)>1.5){
				SmartMove(xy, Angle(xy[0], xy[1], targetX, targetY), 1.5, targetX, targetY);
				DrawTheGuy(this, xy[0], xy[1], dir, 33648);
				Waitframe();
			}
			xy[0] = targetX;
			xy[1] = targetY;
		}
		mapdata l1 = Game->LoadTempScreen(1);
		mapdata l4 = Game->LoadTempScreen(4);
		dir = startDir;
		int pos = ComboAt(xy[0]+8, xy[1]+8);
		while(true){
			int nextDir = dir;
			for(int i=0; i<4; ++i){
				int j = GetAdjacentCombo(pos, i);
				if(i!=OppositeDir(dir)){
					if(j>-1){
						if(l4->ComboF[j]!=0)
							nextDir = i;
					}
				}
			}
			int j = GetAdjacentCombo(pos, dir);
			if(j==-1||l4->ComboF[j]==0)
				dir = nextDir;
			int nextPos = GetAdjacentCombo(pos, dir);
			if(nextPos==-1){
				while(xy[0]>-16&&xy[0]<256&&xy[1]>-16&&xy[0]<192){
					xy[0] += DirX(dir, 1.5);
					xy[1] += DirY(dir, 1.5);
					DrawTheGuy(this, xy[0], xy[1], dir, 33648);
					Waitframe();
				}
				Quit();
			}
			else{
				switch(l4->ComboF[nextPos]){
					case 8: //Path
						while(!Micah_CanWalk(xy[0], xy[1], dir, 1, true)){
							DrawTheGuy(this, xy[0], xy[1], dir, 33644);
							Waitframe();
						}
						while(Distance(xy[0], xy[1], ComboX(nextPos), ComboY(nextPos))>1.5){
							Move(xy, Angle(xy[0], xy[1], ComboX(nextPos), ComboY(nextPos)), 1.5);
							DrawTheGuy(this, xy[0], xy[1], dir, 33648);
							Waitframe();
						}
						pos = nextPos;
						xy[0] = GridX(xy[0]+8);
						xy[1] = GridY(xy[1]+8);
						break;
					case 12: //Jump
						Game->PlaySound(SFX_JUMP);
						int jump = FindJumpLength(22, true);
						int z = 0;
						for(int i=0; i<22; ++i){
							xy[0] += DirX(dir, 1.5);
							xy[1] += DirY(dir, 1.5);
							z += jump;
							jump = Clamp(jump-0.16, -3.2, 3.2);
							DrawTheGuy(this, xy[0], xy[1], dir, 33648, z);
							Waitframe();
						}
						pos = ComboAt(xy[0]+8, xy[1]+8);
						xy[0] = GridX(xy[0]+8);
						xy[1] = GridY(xy[1]+8);
						break;
					case 1: //Push
					case 2:
						int x2 = xy[0]+DirX(dir, 32);
						int y2 = xy[1]+DirY(dir, 32);
						if(l4->ComboF[nextPos]==2){
							while(!Screen->isSolid(ComboX(nextPos)+8, ComboY(nextPos)+8)){
								DrawTheGuy(this, xy[0], xy[1], dir, 33644);
								Waitframe();
							}
						}
						while(Screen->isSolid(x2+8, y2+8)||RectCollision(Link->X, Link->Y+8, Link->X+15, Link->Y+15, x2, y2, x2+15, y2+15)){
							DrawTheGuy(this, xy[0], xy[1], dir, 33644);
							Waitframe();
						}
						int cd = l1->ComboD[nextPos];
						int cc = l1->ComboC[nextPos];
						int cf = l1->ComboF[nextPos];
						if(IsPushFlag(cf)){
							for(int i=0; i<8; ++i){
								DrawTheGuy(this, xy[0], xy[1], dir, 33644);
								SolidObjects_Add(0, x2, y2, 16, 16, 0, 0, 0);
								Waitframe();
							}
							Game->PlaySound(SFX_PUSHBLOCK);
							l1->ComboD[nextPos] = 0;
							l1->ComboC[nextPos] = 0;
							l1->ComboF[nextPos] = 0;
							while(Distance(xy[0], xy[1], ComboX(nextPos), ComboY(nextPos))>1.5){
								Move(xy, Angle(xy[0], xy[1], ComboX(nextPos), ComboY(nextPos)), 1.5);
								Screen->FastCombo(2, xy[0]+DirX(dir, 16), xy[1]+DirY(dir, 16), cd, cc, 128);
								DrawTheGuy(this, xy[0], xy[1], dir, 33648);
								SolidObjects_Add(0, x2, y2, 16, 16, 0, 0, 0);
								Waitframe();
							}
							l1->ComboD[ComboAt(x2, y2)] = cd;
							l1->ComboC[ComboAt(x2, y2)] = cc;
							l1->ComboF[ComboAt(x2, y2)] = cf;
						}
						else{
							while(Distance(xy[0], xy[1], ComboX(nextPos), ComboY(nextPos))>1.5){
								Move(xy, Angle(xy[0], xy[1], ComboX(nextPos), ComboY(nextPos)), 1.5);
								DrawTheGuy(this, xy[0], xy[1], dir, 33648);
								SolidObjects_Add(0, x2, y2, 16, 16, 0, 0, 0);
								Waitframe();
							}
						}
						pos = ComboAt(xy[0]+8, xy[1]+8);
						xy[0] = GridX(xy[0]+8);
						xy[1] = GridY(xy[1]+8);
						break;
					case 16: //Wait for position
					case 17:
					case 18:
						int waitflag = 98;
						if(l4->ComboF[nextPos]==17)
							waitflag = 99;
						if(l4->ComboF[nextPos]==18)
							waitflag = 100;
						while(l4->ComboF[ComboAt(Link->X, Link->Y)]!=waitflag){
							DrawTheGuy(this, xy[0], xy[1], AngleDir4(Angle(xy[0], xy[1], Link->X, Link->Y)), 33644);
							Waitframe();
						}
						while(Distance(xy[0], xy[1], ComboX(nextPos), ComboY(nextPos))>1.5){
							Move(xy, Angle(xy[0], xy[1], ComboX(nextPos), ComboY(nextPos)), 1.5);
							DrawTheGuy(this, xy[0], xy[1], dir, 33648);
							Waitframe();
						}
						pos = nextPos;
						xy[0] = GridX(xy[0]+8);
						xy[1] = GridY(xy[1]+8);
						break;
					case 7: //Path (Delayed)
						for(int i=0; i<90; ++i){
							DrawTheGuy(this, xy[0], xy[1], dir, 33644);
							Waitframe();
						}
						while(!Micah_CanWalk(xy[0], xy[1], dir, 1, true)){
							DrawTheGuy(this, xy[0], xy[1], dir, 33644);
							Waitframe();
						}
						while(Distance(xy[0], xy[1], ComboX(nextPos), ComboY(nextPos))>1.5){
							Move(xy, Angle(xy[0], xy[1], ComboX(nextPos), ComboY(nextPos)), 1.5);
							DrawTheGuy(this, xy[0], xy[1], dir, 33648);
							Waitframe();
						}
						pos = nextPos;
						xy[0] = GridX(xy[0]+8);
						xy[1] = GridY(xy[1]+8);
						break;
					case 10: //Attack enemies
						int magicCooldown = 180;
						int oldDir = dir;
						while(NumberEnemies()>0){
							npc closestMagic;
							int closestDistMagic = 0;
							for(int i=Screen->NumNPCs(); i>0; --i){
								npc n = Screen->LoadNPC(i);
								if(n->CollDetection&&!n->InvFrames){
									int dist = Distance(xy[0]+8, xy[1]+8, HitboxCenterX(n), HitboxCenterY(n));
									if(n->Defense[NPCD_SCRIPT1]!=NPCDT_BLOCK&&n->Defense[NPCD_SCRIPT1]!=NPCDT_IGNORE){
										if(dist>closestDistMagic){
											closestMagic = n;
											closestDistMagic = dist;
										}
									}
								}
							}
							if(closestMagic->isValid()&&!magicCooldown){
								int angle = Angle(xy[0]+8, xy[0]+8, HitboxCenterX(closestMagic), HitboxCenterY(closestMagic));
								dir = AngleDir4(angle);
								for(int j=0; j<48; ++j){
									if(closestMagic->isValid())
										angle = Angle(xy[0]+8, xy[0]+8, HitboxCenterX(closestMagic), HitboxCenterY(closestMagic));
									dir = AngleDir4(angle);
									if(j==32)
										Game->PlaySound(SFX_CHARGE1);
									GetDirXYOffset(xy2, dir, {13,1, 8,12, 1,7, 14,7}); //Reach forward
									Screen->Circle(dir==DIR_UP?1:4, xy[0]+xy2[0], xy[1]+xy2[1], Rand(4, 6), Choose(0x86, 0x87, 0x88), 1, 0, 0, 0, true, 128);
									DrawTheGuy(this, xy[0], xy[1], dir, 51344);
									Waitframe();
								}
								for(int j=0; j<20; ++j){
									if(j%4==0){
										lweapon l = FireLWeapon(LW_SOLAR, xy[0]+xy2[0]-8, xy[1]+xy2[1]-8, angle+Rand(-10, 10), 300, DAMAGE_MICAH_MAGIC, SPR_LIGHTSHOT, 32);
										l->Rotation = angle;
									}
									GetDirXYOffset(xy2, dir, {13,1, 8,12, 1,7, 14,7}); //Reach forward
									Screen->Circle(dir==DIR_UP?1:4, xy[0]+xy2[0], xy[1]+xy2[1], Rand(4, 6), Choose(0x86, 0x87, 0x88), 1, 0, 0, 0, true, 128);
									DrawTheGuy(this, xy[0], xy[1], dir, 51344);
									Waitframe();
								}
								magicCooldown = 90;
							}
							
							if(magicCooldown)
								--magicCooldown;
							DrawTheGuy(this, xy[0], xy[1], dir, 33644);
							Waitframe();
						}
						dir = oldDir;
						while(!Micah_CanWalk(xy[0], xy[1], dir, 1, true)){
							DrawTheGuy(this, xy[0], xy[1], dir, 33644);
							Waitframe();
						}
						while(Distance(xy[0], xy[1], ComboX(nextPos), ComboY(nextPos))>1.5){
							Move(xy, Angle(xy[0], xy[1], ComboX(nextPos), ComboY(nextPos)), 1.5);
							DrawTheGuy(this, xy[0], xy[1], dir, 33648);
							Waitframe();
						}
						pos = nextPos;
						xy[0] = GridX(xy[0]+8);
						xy[1] = GridY(xy[1]+8);
						break;
					case 94: //Turn Clockwise
						if(Micah_CanWalk(xy[0], xy[1], dir, 1, true)){
							while(Distance(xy[0], xy[1], ComboX(nextPos), ComboY(nextPos))>1.5){
								Move(xy, Angle(xy[0], xy[1], ComboX(nextPos), ComboY(nextPos)), 1.5);
								DrawTheGuy(this, xy[0], xy[1], dir, 33648);
								Waitframe();
							}
							pos = nextPos;
							xy[0] = GridX(xy[0]+8);
							xy[1] = GridY(xy[1]+8);
						}
						else
							dir = DirCW(dir);
						break;
					case 92: //Follow mode
						this->X = xy[0];
						this->Y = xy[1];
						runNPCFollower(this, 2);
						break;
				}
			}
			DrawTheGuy(this, xy[0], xy[1], dir, 33644);
			Waitframe();
		}
	}
}

ffc script JungleTempleStuff{
	void run(int type, int a1){
		if(type==0){
			if(Game->Counter[CR_CULTISTQUEST]>5){
				if(Game->GetCurScreen()==0x65)
					Screen->TriggerSecrets();
				else{
					int pos = ComboAt(this->X+8, this->Y+8);
					Screen->ComboD[pos] = a1;
					Screen->ComboD[pos+1] = a1+1;
					Screen->ComboD[pos+16] = a1+4;
					Screen->ComboD[pos+17] = a1+5;
				}
				
				if(Game->GetCurScreen()==0x35){
					Screen->ComboD[131] = 29876; //Hardcoding combos? Sure, why not
				}
			}
		}
		else if(type==1){
			if(Game->Counter[CR_CULTISTQUEST]>5){
				Screen->TriggerSecrets();
				Quit();
			}
			else{
				Waitframe();
				while(Link->Y>128){
					Waitframe();
				}
				ffc Micah = Screen->LoadFFC(28);
				ffc itm = Screen->LoadFFC(29);
				itm->Data = 38423;
				itm->CSet = 10;
				itm->X = 120;
				itm->Y = 40;
				Micah->Data = 33648+DIR_RIGHT;
				Micah->TileHeight = 2;
				Micah->X = Link->X;
				Micah->Y = Link->Y-16;
				Micah->Vx = 1.5;
				Link->Dir = DIR_RIGHT;
				while(Micah->X<120){
					WaitNoAction();
				}
				Micah->X = 120;
				Micah->Data = 33648+DIR_UP;
				Micah->Vx = 0;
				Micah->Vy = -1.5;
				while(Micah->Y>80){
					WaitNoAction();
				}
				Micah->Y = 80;
				Micah->Vy = 0;
				Micah->Data = 33644+DIR_UP;
				while(Link->X<120){
					NoAction();
					Link->InputRight = true;
					Waitframe();
				}
				Link->X = 120;
				while(Link->Y>112){
					NoAction();
					Link->InputUp = true;
					Waitframe();
				}
				Link->Y = 112;
				WaitNoAction(16);
				PlayStringAndWait("This is what Selet was after: The Atlas Stone! If he'd gotten his hands on this he'd be able to read our charts freely and divine his path using the stars without needing any training. None of our secrets would elude him anymore. Suffice to say, it would be disastrous.", SCHAR_MICAH, EMOTE_NORMAL, 68, 24);
				WaitNoAction(32);
				for(int i=0; i<96; ++i){
					if(i%8==0){
						Screen->Quake = 10;
						Game->PlaySound(SFX_BOMB);
					}
					WaitNoAction();
				}
				WaitNoAction(32);
				PlayStringAndWait("Seems we made it without a moment to spare. They'll be here soon. Let's make for the exit.", SCHAR_MICAH, EMOTE_SWEAT, 68, 24);
				WaitNoAction(16);
				Micah->Vy = -1.5;
				Micah->Data = 33644+DIR_UP;
				while(Micah->Y>itm->Y-16){
					WaitNoAction();
				}
				itm->Data = 0;
				Game->PlaySound(25);
				Micah->Vy = 0;
				Micah->Y = itm->Y-16;
				Micah->Data = 33644+DIR_UP;
				WaitNoAction(32);
				Screen->TriggerSecrets();
				Game->PlaySound(9);
				WaitNoAction(32);
				Micah->Vy = -1.5;
				Micah->Data = 33644+DIR_UP;
				while(Micah->Y>0){
					WaitNoAction();
				}
				Micah->Vy = 0;
				Micah->Data = 0;
				Game->Counter[CR_CULTISTQUEST] = 5;
				while(true){
					NoAction();
					Link->InputUp = true;
					Link->X = 120;
					Waitframe();
				}
			}
		}
		else if(type==2){
			if(Game->Counter[CR_CULTISTQUEST]==5&&Distance(Link->X, Link->Y, this->X, this->Y)<24){
				for(int i=0; i<10; ++i){
					Screen->Enemy[i] = 0;
				}
				Game->GuyCount[Game->GetCurScreen()] = 0;
				
				Waitframe();
				
				Link->Dir = DIR_LEFT;
				G[G_ASHERCOSTUME] = 0;
				G[G_TORRINCOSTUME] = 0;
				G[G_KAYLANICOSTUME] = 0;
				Costumes_Update();
				ffc Micah = Screen->LoadFFC(16);
				Micah->Data = 33644+DIR_RIGHT;
				Micah->TileHeight = 2;
				Micah->X = Link->X - 40;
				Micah->Y = Link->Y - 16;
				
				int messageY = 112;
				PlayStringAndWait("Phew. Looks like we lost them.", SCHAR_MICAH, EMOTE_NORMAL, 68, messageY);
				PlayStringAndWait("Reckon Selet will be all kinds a' miffed when he finds out another one of his plans got ruined.", SCHAR_TORRIN, EMOTE_HAPPY, 68, messageY);
				PlayStringAndWait("It's a good thing we were here. You still have that artifact, Micah? Didn't drop it in the confusion, right?", SCHAR_ASHER, EMOTE_NORMAL, 68, messageY);
				PlayStringAndWait("It's right here in my pocket. I'll see to it it makes it back to Hoku safely.", SCHAR_MICAH, EMOTE_NORMAL, 68, messageY);
				PlayStringAndWait("What about you then? Are you coming home?", SCHAR_KAYLANI, EMOTE_QUESTION, 68, messageY);
				PlayStringAndWait("I'm...not sure yet. This doesn't make up for everything I've done, but it's a step towards redemption. I think I'll take a journey to discover my own path, but I will return when I'm feeling ready to forgive myself.", SCHAR_MICAH, EMOTE_NORMAL, 68, messageY);
				PlayStringAndWait("So that's it? You're just going to leave? What about your family?", SCHAR_KAYLANI, EMOTE_SAD, 68, messageY);
				PlayStringAndWait("They're in good hands. And I was never the one looking out for them in the first place. But tell them I'm doing alright, would you?", SCHAR_MICAH, EMOTE_NORMAL, 68, messageY);
				PlayStringAndWait("Alright then. If this is your decision I'll respect it. But you'll always be welcome back home. I'd forgiven you from the very start, if that counts for anything.", SCHAR_KAYLANI, EMOTE_NORMAL, 68, messageY);
				PlayStringAndWait("Thanks Kaylani. Oh! And one more thing before I go.", SCHAR_MICAH, EMOTE_NORMAL, 68, messageY);
				
				WaitNoAction(32);
				Micah->Data = 33882;
				WaitNoAction(32);
				Micah->Data = 33883;
				WaitNoAction(32);
				Micah->Data = 33900+DIR_RIGHT;
				for(int i=0; i<16; ++i){
					++Micah->X;
					WaitNoAction();
				}
				Micah->Data = 33892;
				
				AugmentGet(187);
				Game->Counter[CR_CULTISTQUEST] = 6;
				WaitNoAction(30);
				Micah->Data = 33896+DIR_RIGHT;
				PlayStringAndWait("Take this augment. It's the least I can do after all you three have done for me. I hope it serves you well.", SCHAR_MICAH2, EMOTE_NORMAL, 68, messageY);
				Micah->Data = 33900+DIR_LEFT;
				Micah->Vx = -1;
				while(Micah->X>-16){
					WaitNoAction();
				}
				Micah->Vx = 0;
			}
		}
	}
}
	
ffc script RupeeBush{
	#option BINARY_32BIT on
	void run(int spawnItem, int cmb, int alwaysSpawn, int batteryCheck){
		if(batteryCheck==1){
			if(Game->Counter[CR_STORYFLAG]<SFLAG_LEVEL1)
				Quit();
		}
		else if(batteryCheck==2){
			if(Game->Counter[CR_STORYFLAG]<SFLAG_ASHERKIDNAPPED)
				Quit();
		}
		int sparkleT;
		int sparkleC;
		switch(cmb){
			case 1004:
			case 1014:
			case 3570:
				sparkleT = 968;
				sparkleC = 8;
				break;
			case 3574:
				sparkleT = 611;
				sparkleC = 7;
				break;
			case 3578:
				sparkleT = 968;
				sparkleC = 9;
				break;
		}
		
		int d[176];
		int dbit[176];
		int spawned[176];
		item spawnedItem[176];
		for(int i=0; i<176; ++i){
			d[i] = Floor(i/32);
			dbit[i] = 1b<<(i%32);
		}
		while(true){
			for(int i=0; i<176; ++i){
				if(Screen->ComboD[i]==cmb){
					if(!(Screen->D[d[i]]&dbit[i])&&sparkleT){
						if(G[G_ANIM]%24==(i+7*i)%24){
							ParticleAnim(ComboX(i)+Rand(-8, 8), ComboY(i)+Rand(-8, 8), sparkleT, sparkleC, 8, 5);
						}
					}
				}
				else if(Screen->ComboD[i]==cmb+1&&!(Screen->D[d[i]]&dbit[i])){
					if(spawned[i]==0){
						spawnedItem[i] = CreateItemAt(spawnItem, ComboX(i), ComboY(i));
						switch(spawnItem){
							case I_RUPEE5:
								spawnedItem[i]->Misc[ITMM_SPECIALGRAB] = 1;
								break;
						}
						spawned[i] = 1;
					}
					else if(spawned[i]==1){
						if(!spawnedItem[i]->isValid()){
							if(!alwaysSpawn)
								Screen->D[d[i]] |= dbit[i];
							spawned[i] = 2;
						}
					}
				}
			}
			Waitframe();
		}
	}
}

bool OnIce(){
	return Screen->ComboI[ComboAt(Link->X+8, Link->Y+12)]==CF_SCRIPT_ICE;
}

ffc script IceFloors{
	void run(){
		G[G_ONICEPUSH] = 0;
		int iceX = -1000; int iceY = -1000;
		int iceVX; int iceVY;
		int iceStep;
		int pushTimer;
		bool onIce;
		int push[4];
		if(G[G_ICESTEP]!=0&&Screen->ComboI[ComboAt(Link->X+8, Link->Y+12)]==CF_SCRIPT_ICE){
			NoAction();
			onIce = true;
			iceStep = G[G_ICESTEP];
			iceVX = G[G_ICEVX];
			iceVY = G[G_ICEVY];
			iceX = Link->X;
			iceY = Link->Y;
			push[2] = iceX;
			push[3] = iceY;
		}
		G[G_ICESTEP] = 0;
		G[G_ICEVX] = 0;
		G[G_ICEVY] = 0;
		bool wasOnLand;
		while(true){
			G[G_ONICEPUSH] = 0;
			bool slideOffPits;
			if(Screen->ComboT[ComboAt(Link->X+8, Link->Y+12)]==CT_PITFALL&&onIce)
				slideOffPits = true;
			if((Screen->ComboI[ComboAt(Link->X+8, Link->Y+12)]==CF_SCRIPT_ICE||slideOffPits)&&Link->Action!=LA_FALLING){
				if(!onIce){
					onIce = true;
					if(LinkMovement[LM_STICKX]==0&&LinkMovement[LM_STICKY]==0){
						iceVX = DirX(Link->Dir, 1);
						iceVY = DirY(Link->Dir, 1);
					}
					else{
						iceVX = LinkMovement[LM_STICKX];
						iceVY = LinkMovement[LM_STICKY];
					}
					if(!(iceVX!=0&&iceVY!=0)){
						if(Link->Dir<2)
							Link->X = Floor((Link->X+3)/8)*8;
						else
							Link->Y = Floor((Link->Y+3)/8)*8;
					}
					iceX = Link->X;
					iceY = Link->Y;
					push[2] = iceX;
					push[3] = iceY;
					iceStep = 0.5;
					Game->PlaySound(107);
				}
				if(iceStep>0){
					if(iceStep>=1||wasOnLand)
						G[G_ONICEPUSH] = 1;
					if(CanWalk8NoEdge(iceX, iceY, AngleDir8(Angle(0, 0, iceVX, iceVY)), 1, false, true)){
						iceStep = Min(iceStep+0.05, 2);
						push[0] += iceVX*iceStep;
						push[1] += iceVY*iceStep;
						HandlePushArrayNoEdge(push, 2);
						iceX = push[2];
						iceY = push[3];
					}
					else{
						if(AngleDir8(Angle(0, 0, iceVX, iceVY))>DIR_RIGHT){
							iceX = Round((Link->X)/8)*8;
							iceY = Round((Link->Y)/8)*8;
							push[2] = iceX;
							push[3] = iceY;
						}
						wasOnLand = false;
						iceStep = 0;
						iceVX = 0;
						iceVY = 0;
						Game->PlaySound(108);
					}
				}
				else{
					if(LinkMovement[LM_STICKX]!=0||LinkMovement[LM_STICKY]!=0){
						++pushTimer;
						if(pushTimer>=8&&CanWalk8NoEdge(iceX, iceY, AngleDir8(Angle(0, 0, LinkMovement[LM_STICKX], LinkMovement[LM_STICKY])), 1, false, true)){
							iceStep = 0.05;
							Game->PlaySound(107);
							iceVX = LinkMovement[LM_STICKX];
							iceVY = LinkMovement[LM_STICKY];
							pushTimer = 0;
						}
					}
					else
						pushTimer = 0;
				}
			}
			else{
				if(onIce){
					onIce = false;
					wasOnLand = true;
					iceX = -1000;
					iceY = -1000;
				}
			}
			G[G_ICESTEP] = iceStep;
			G[G_ICEVX] = iceVX;
			G[G_ICEVY] = iceVY;
			Waitdraw();
			if(iceX>-1000){
				Link->X = iceX;
				Link->Y = iceY;
			}
			Waitframe();
		}
	}
}

ffc script FrozenEnemy{
	void DrawIceCube(bitmap b, bitmap b2, int layer, int x, int y, int enemy, int scale){
		int tile; int cset; int w=1; int h=1; int xoff=8; int yoff=8;
		switch(enemy){
			case 23:
				tile = 3426;
				cset = 7;
				break;
			//Crablikes
			case 180:
				tile = 9424;
				break;
			case 181:
				tile = 9464;
				break;
			case 182:
				tile = 9504;
				break;
			//Startouched
			case 183:
				tile = 9664;
				h = 2;
				yoff = -4;
				break;
			case 184:
				tile = 9704;
				h = 2;
				yoff = -4;
				break;
			case 185:
				tile = 9744;
				h = 2;
				yoff = -4;
				break;
			//Puffer
			case 226:
				tile = 107256;
				cset = 9;
				break;
			//Icerobe
			case 57:
				tile = 10304;
				h = 2;
				yoff = -4;
				break;
			//Spike Top
			case 196:
				tile = 7640;
				cset = 11;
				break;
			//Mummy
			case 54:
				tile = 107340;
				cset = 7;
				h = 2;
				yoff = -4;
				break;
			//Rope
			case 190:
				tile = 10084;
				cset = 11;
				break;
			case 223:
				tile = 10144;
				cset = 11;
				break;
			//Ratang
			case 136:
				tile = 8484;
				cset = 11;
				break;
			case 221:
				tile = 9784;
				cset = 7;
				break;
		}
		b->Clear(0);
		b2->Clear(0);
		b->DrawTile(0, Lerp(16, 0, scale), 32+Lerp(16, 0, scale), 69176, 2, 2, 0, Lerp(0, 32, scale), Lerp(0, 32, scale), 0, 0, 0, 0, true, 128);
		b->ReplaceColors(0, 0x75, 0x73, 0x74);
		b->ReplaceColors(0, 0x74, 0x72, 0x72);
		b->ReplaceColors(0, 0x73, 0x06, 0x06);
		b->ReplaceColors(0, 0x72, 0x71, 0x71);
		b->DrawTile(0, Lerp(16, 0, scale), Lerp(16, 0, scale), 69176, 2, 2, 0, Lerp(0, 32, scale), Lerp(0, 32, scale), 0, 0, 0, 0, true, 128);
		if(tile){
			b2->DrawTile(0, xoff, yoff, tile, w, h, cset, -1, -1, 0, 0, 0, 0, true, 128);
			b->MaskedDraw(0, b2, 0x00);
			Screen->DrawTile(layer, x+xoff, y+yoff, tile, w, h, cset, -1, -1, 0, 0, 0, 0, true, 128);
			b->Blit(layer, RT_SCREEN, 0, 32, 32, 32, x, y, 32, 32, 0, 0, 0, 0, 0, true);
		}
		b->Blit(layer, RT_SCREEN, 0, 0, 32, 32, x, y, 32, 32, 0, 0, 0, 0, 0, true);
	}
	void run(int enemyID){
		int xoff=8; int yoff=8;
		switch(enemyID){
			case 183:
			case 184:
			case 185:
			case 57:
			case 54:
				yoff = 12;
				break;
		}
		Waitframe();
		int bitid = TempBitmap_Create(0, 32, 64);
		bitmap b = TempBMP[bitid]; 
		int bitid2 = TempBitmap_Create(0, 32, 64);
		bitmap b2 = TempBMP[bitid2]; 
		
		mapdata l2 = Game->LoadTempScreen(2);
		int pos = ComboAt(this->X+8, this->Y+8);
		l2->ComboD[pos] = 1;
		l2->ComboD[pos+1] = 1;
		l2->ComboD[pos+16] = 1;
		l2->ComboD[pos+17] = 1;
		bool thawed;
		while(!thawed){
			DrawIceCube(b, b2, 2, this->X, this->Y, enemyID, 1);
			for(int i=Screen->NumLWeapons(); i>0; --i){
				lweapon l = Screen->LoadLWeapon(i);
				if(l->ID==LW_FIRE){
					if(RectCollision(l->X+4, l->Y+4, l->X+11, l->Y+11, this->X, this->Y, this->X+31, this->Y+31)){
						thawed = true;
						break;
					}
				}
			}
			Waitframe();
		}
		l2->ComboD[pos] = 0;
		l2->ComboD[pos+1] = 0;
		l2->ComboD[pos+16] = 0;
		l2->ComboD[pos+17] = 0;
		Game->PlaySound(109);
		for(int i=32; i>0; --i){
			if(i%4==0){
				int j = Lerp(2, 8, i/32);
				RunEWeaponEffect(this->X+8+Rand(-j, j), this->Y+8+Rand(-j, j), "GenParticle", {GP_STEAM, 24});
			}
			SolidObjects_Add(0, this->X+Lerp(0, 16, i/32), this->Y+Lerp(0, 16, i/32), Lerp(0, 32, i/32), Lerp(0, 32, i/32), 0, 0, 0);
			DrawIceCube(b, b2, 2, this->X, this->Y, enemyID, i/32);
			Waitframe();
		}
		if(enemyID)
			npc n = CreateNPCAt(enemyID, this->X+xoff, this->Y+yoff);
	}
}

ffc script ShapeOrbit{
	void run(int shape, int dist, int baseAngle, int startPoint, int speed, int delay, int baseTurnSpeed, int damage){
		int pointAng[8];
		int numPoints;
		int curStep = startPoint;
		int frame;
		int stepFrames;
		switch(shape){
			case 0: //Triangle;
				pointAng[0] = 0;
				pointAng[1] = 120;
				pointAng[2] = 240;
				numPoints = 3;
				stepFrames = 120;
				break;
			case 1: //Diamond
				pointAng[0] = 0;
				pointAng[1] = 90;
				pointAng[2] = 180;
				pointAng[3] = 270;
				numPoints = 4;
				stepFrames = 90;
				break;
			case 2: //Star
				pointAng[0] = 0;
				pointAng[1] = 144;
				pointAng[2] = 288;
				pointAng[3] = 72;
				pointAng[4] = 216;
				numPoints = 5;
				stepFrames = 72;
				break;
		}
		if(speed<0)
			frame = stepFrames;
		int delayTime = delay;
		int x; int y;
		while(true){
			if(delayTime)
				--delayTime;
			else{
				if(speed>0){
					frame += speed;
					if(frame>=stepFrames){
						frame = 0;
						delayTime = delay;
						++curStep;
						if(curStep>=numPoints)
							curStep = 0;
					}
				}
				else{
					frame += speed;
					if(frame<=0){
						frame = stepFrames;
						delayTime = delay;
						--curStep;
						if(curStep<0)
							curStep = numPoints-1;
					}
				}
			}
			int x1; int y1; int x2; int y2;
			if(curStep<numPoints-1){
				x1 = this->X+VectorX(dist, baseAngle+pointAng[curStep]);
				y1 = this->Y+VectorY(dist, baseAngle+pointAng[curStep]);
				x2 = this->X+VectorX(dist, baseAngle+pointAng[curStep+1]);
				y2 = this->Y+VectorY(dist, baseAngle+pointAng[curStep+1]);
			}
			else{
				x1 = this->X+VectorX(dist, baseAngle+pointAng[curStep]);
				y1 = this->Y+VectorY(dist, baseAngle+pointAng[curStep]);
				x2 = this->X+VectorX(dist, baseAngle+pointAng[0]);
				y2 = this->Y+VectorY(dist, baseAngle+pointAng[0]);
			}
			x = Lerp(x1, x2, frame/stepFrames);
			y = Lerp(y1, y2, frame/stepFrames);
			Screen->FastCombo(4, x, y, this->Data, this->CSet, 128);
			switch(this->Data){
				case 38509:
					if(G[G_ANIM]%2==0){
						ParticleAnim(x+Rand(-8, 8), y+Rand(-8, 8), 968, 8, 8, 2);
					}
					break;
			}
			MakeHitbox(EW_PHYSICAL, x, y, 16, 16, damage);
			baseAngle = WrapDegrees(baseAngle+baseTurnSpeed);
			Waitframe();
		}
	}
}

ffc script IcePushBlock{
	bool CheckSolve(int solveCMB){
		for(int i=0; i<176; ++i){
			if(Screen->ComboD[i]==solveCMB)
				return false;
		}
		return true;
	}
	bool CanMoveIcePushBlock(ffc this, int dir){
		int x = this->X+8;
		int y = this->Y+8;
		switch(dir){
			case DIR_UP:
				y = this->Y-1;
				break;
			case DIR_DOWN:
				y = this->Y+16;
				break;
			case DIR_LEFT:
				x = this->X-1;
				break;
			case DIR_RIGHT:
				x = this->X+16;
				break;	
		}
		if(x<0||x>255||y<0||y>175)
			return true;
		int pos = ComboAt(x, y);
		bool hasFlag;
		bool solid;
		mapdata l1 = Game->LoadTempScreen(1);
		mapdata l2 = Game->LoadTempScreen(2);
		int s = Screen->ComboS[pos]|l1->ComboS[pos]|l2->ComboS[pos];
		if(s>0)
			solid = true;
		if(ComboFI(pos, CF_SCRIPT_ICE)||ComboFI(pos, CF_SCRIPT_ICE_DMG))
			hasFlag = true;
		if(this->InitD[1]>0&&Screen->ComboI[pos]==CF_BLOCKHOLE){
			hasFlag = true;
			solid = false;
		}
		if(!hasFlag||solid)
			return false;
		return true;
	}
	void run(int specialPushFlag, int specialD, int solveCMB){
		int ffcNum = FFCNum(this);
		if(specialD>0){
			--specialD;
			int pos = Screen->D[specialD]&0xFF;
			int ffcInHole = Screen->D[specialD]>>8;
			if(pos>0&&ffcInHole==ffcNum){
				++Screen->ComboD[pos];
				this->Data = 0;
				Quit();
			}
		}
		if(this->Flags[FFCF_PRELOAD])
			Waitframe();
		int pushTime;
		int dir;
		int pos = ComboAt(this->X+8, this->Y+8);
		int underCombo = Screen->ComboD[pos];
		int underCSet = Screen->ComboC[pos];
		int blockData = this->Data;
		int blockCSet = this->CSet;
		mapdata l2 = Game->LoadTempScreen(2);
		// Screen->ComboD[pos] = blockData+1;
		// Screen->ComboC[pos] = blockCSet;
		l2->ComboD[pos] = 1;
		//this->Data = 1;
		int oldLinkX = Link->X; int oldLinkY = Link->Y;
		int LinkVX; int LinkVY;
		while(true){
			bool push = false;
			int noActionFrame;
			while(!push){
				LinkVX = Link->X-oldLinkX;
				LinkVY = Link->Y-oldLinkY;
				oldLinkX = Link->X; 
				oldLinkY = Link->Y;
				if(Link->X>=this->X-16&&Link->X<=this->X+16&&Link->Y>=this->Y-16&&Link->Y<=this->Y+8){
					int pos = ComboAt(Link->X+8, Link->Y+12);
					if(ComboFI(pos, CF_SCRIPT_ICE)){
						dir = -1;
						if(Link->Y==this->Y+8&&Abs(Link->X-this->X)<=6&&LinkVY<0){
							dir = DIR_UP;
						}
						else if(Link->Y==this->Y-16&&Abs(Link->X-this->X)<=6&&LinkVY>0){
							dir = DIR_DOWN;
						}
						else if(Link->X==this->X+16&&Link->Y>=this->Y-11&&Link->Y<=this->Y+3&&LinkVX<0){
							dir = DIR_LEFT;
						}
						else if(Link->X==this->X-16&&Link->Y>=this->Y-11&&Link->Y<=this->Y+3&&LinkVX>0){
							dir = DIR_RIGHT;
						}
						// Screen->DrawInteger(6, this->X, this->Y-8, FONT_Z3SMALL, 0x01, 0x0F, -1, -1, dir, 0, 128);
						if(dir>-1&&CanMoveIcePushBlock(this, dir)&&G[G_ONICEPUSH]){
							push = true;
							noActionFrame = 16;
							Screen->FastCombo(2, this->X, this->Y, blockData, blockCSet, 128);
							Waitframe();
						}
					}
					else{
						dir = -1;
						if(Link->Y==this->Y+8&&Abs(Link->X-this->X)<=6&&Link->Dir==DIR_UP&&Link->InputUp){
							dir = DIR_UP;
							++pushTime;
						}
						else if(Link->Y==this->Y-16&&Abs(Link->X-this->X)<=6&&Link->Dir==DIR_DOWN&&Link->InputDown){
							dir = DIR_DOWN;
							++pushTime;
						}
						else if(Link->X==this->X+16&&Link->Y>=this->Y-11&&Link->Y<=this->Y+3&&Link->Dir==DIR_LEFT&&Link->InputLeft){
							dir = DIR_LEFT;
							++pushTime;
						}
						else if(Link->X==this->X-16&&Link->Y>=this->Y-11&&Link->Y<=this->Y+3&&Link->Dir==DIR_RIGHT&&Link->InputRight){
							dir = DIR_RIGHT;
							++pushTime;
						}
						else
							pushTime = 0;
						
						if(dir>-1&&pushTime>=16&&CanMoveIcePushBlock(this, dir)){
							pushTime = 0;
							push = true;
							noActionFrame = 16;
						}
					}
				}
				// Screen->DrawInteger(6, this->X, this->Y, FONT_Z3SMALL, 0x01, 0x0F, -1, -1, LinkVX, 0, 128);
				// Screen->DrawInteger(6, this->X, this->Y+8, FONT_Z3SMALL, 0x01, 0x0F, -1, -1, LinkVY, 0, 128);
						
				if(this->InitD[0]>0){
					dir = this->InitD[0]-1;
					if(CanMoveIcePushBlock(this, dir)){
						this->InitD[0] = 0;
						push = true;
					}
					else{
						dir = -1;
						this->InitD[0] = 0;
					}
				}
				Screen->FastCombo(2, this->X, this->Y, blockData, blockCSet, 128);
				Waitframe();
			}
			// Screen->ComboD[pos] = underCombo;
			// Screen->ComboC[pos] = underCSet;
			l2->ComboD[pos] = 0;
			int speed = 0.5;
			int steps;
			Game->PlaySound(107);
			//this->Data = blockData;
			while(CanMoveIcePushBlock(this, dir)){
				if(noActionFrame){
					--noActionFrame;
					NoAction();
				}
				speed = Min(speed+0.05, 2);
				steps += speed;
				for(int i=0; i<Floor(steps); ++i){
					if(CanMoveIcePushBlock(this, dir)){
						this->X += DirX(dir, 1);
						this->Y += DirY(dir, 1);
						if(this->X%16==0&&this->Y%16==0){
							if(Screen->ComboI[ComboAt(this->X+8, this->Y+8)]==CF_BLOCKHOLE){
								if(solveCMB==0)
									Screen->D[specialD] = (ComboAt(this->X+8, this->Y+8)&0xFF)|(ffcNum<<8);
								++Screen->ComboD[ComboAt(this->X+8, this->Y+8)];
								Game->PlaySound(SFX_FALL);
								this->Data = 1;
								Waitframes(8);
								Game->PlaySound(110);
								if(solveCMB){
									while(!CheckSolve(solveCMB)){
										Screen->FastCombo(2, this->X, this->Y, blockData, blockCSet, 128);
										Waitframe();
									}
									Screen->D[specialD] = (ComboAt(this->X+8, this->Y+8)&0xFF)|(ffcNum<<8);
								}
								this->Data = 0;
								Quit();
							}
						}
					}
				}
				steps -= Floor(steps);
				if(this->X<-16||this->X>256||this->Y<-16||this->Y>176){
					this->Data = 0;
					Quit();
				}
				Screen->FastCombo(2, this->X, this->Y, blockData, blockCSet, 128);
				Waitframe();
			}
			//this->Data = 1;
			Game->PlaySound(110);
			this->X = GridX(this->X+8);
			this->Y = GridY(this->Y+8);
			pos = ComboAt(this->X+8, this->Y+8);
			underCombo = Screen->ComboD[pos];
			underCSet = Screen->ComboC[pos];
			// Screen->ComboD[pos] = blockData+1;
			// Screen->ComboC[pos] = blockCSet;
			l2->ComboD[pos] = 1;
			for(int i=1; i<=32; ++i){
				ffc f = Screen->LoadFFC(i);
				if(f->Script==this->Script&&f->X==this->X+DirX(dir, 16)&&f->Y==this->Y+DirY(dir, 16)){
					f->InitD[0] = dir+1;
				}
			}
		}
	}
}

ffc script IceJet{
	bool DrawJet(int x, int y, int angle, int steps){
		bool gotHit;
		int w1 = 4;
		int w2 = 24;
		int segmentDist = 8;
		for(int i=0; i<steps; ++i){
			int w = Lerp(w1, w2, i/7);
			int wRand = w*0.25;
			Screen->Circle(4, x+Rand(-wRand, wRand), y+Rand(-wRand, wRand), w+Rand(-2, 2), Choose(0x71, 0x72, 0x73, 0x74), 1, 0, 0, 0, true, 64);
			Screen->Circle(4, x+Rand(-wRand, wRand), y+Rand(-wRand, wRand), w+Rand(-2, 2), Choose(0x71, 0x72, 0x73, 0x74), 1, 0, 0, 0, false, 64);
			if((G[G_ANIM]+i)%8==0){
				int k = Rand(360);
				ParticleAnim(x-8+VectorX(w+Rand(-wRand, wRand), k), y-8+VectorY(w+Rand(-wRand, wRand), k), SPR_SNOWFLAKEPARTICLE);
			}
			if(Distance(Link->X+8, Link->Y+8, x, y)<w)
				gotHit = true;
			x += VectorX(segmentDist, angle);
			y += VectorY(segmentDist, angle);
		}
		return gotHit;
	}
	void IceJetWaitframe(int freezeInvuln){
		if(G[G_FROZENTIMER]>0){
			freezeInvuln[0] = 60;
		}
		if(freezeInvuln[0]){
			--freezeInvuln[0];
		}
		Waitframe();
	}
	void run(int dir){
		int noShootTime;
		int angle = DirAngle(dir);
		int x = this->X+DirX(dir, -4)+8;
		int y = this->Y+DirY(dir, -4)+8;
		int freezeInvuln[1];
		while(true){
			if(noShootTime>0){
				if(G[G_FROZENTIMER]<=0)
					--noShootTime;
			}
			else if(RotRectCollision(x+VectorX(32, angle), y+VectorY(32, angle), 64, 48, angle, Link->X+8, Link->Y+8, 8, 8, 0, false)){
				for(int i=0; i<8; ++i){
					Screen->Circle(4, x+Rand(-2, 2), y+Rand(-2, 2), 8, Choose(0x72, 0x73, 0x74), 1, 0, 0, 0, true, 64);
					Screen->Circle(4, x+Rand(-2, 2), y+Rand(-2, 2), 8, Choose(0x72, 0x73, 0x74), 1, 0, 0, 0, false, 64);
					IceJetWaitframe(freezeInvuln);
				}
				Game->PlaySound(111);
				for(int i=1; i<=8; ++i){
					for(int j=0; j<3; ++j){
						bool hit = DrawJet(x, y, angle, i);
						if(hit&&G[G_FROZENTIMER]<=0&&!freezeInvuln[0]){
							Game->PlaySound(SFX_ICE);
							G[G_FROZENTIMER] = 180;
							RunEWeaponEffect(120, 80, "FrozenStatus", {0});
						}
						IceJetWaitframe(freezeInvuln);
					}
				}
				for(int i=0; i<180; ++i){
					bool hit = DrawJet(x, y, angle, 8);
					if(hit&&G[G_FROZENTIMER]<=0&&!freezeInvuln[0]){
						Game->PlaySound(SFX_ICE);
						G[G_FROZENTIMER] = 180;
						RunEWeaponEffect(120, 80, "FrozenStatus", {0});
					}
					IceJetWaitframe(freezeInvuln);
				}
				for(int i=8; i>=1; --i){
					bool hit = DrawJet(x, y, angle, i);
					if(hit&&G[G_FROZENTIMER]<=0&&!freezeInvuln[0]){
						Game->PlaySound(SFX_ICE);
						G[G_FROZENTIMER] = 180;
						RunEWeaponEffect(120, 80, "FrozenStatus", {0});
					}
					IceJetWaitframe(freezeInvuln);
				}
				noShootTime = 120;
			}
			IceJetWaitframe(freezeInvuln);
		}
	}
}

ffc script HideOverhead{
	void run(int whichLayer, int whichFlag){
		int linkX = Link->X;
		int linkY = Link->Y;
		bool frame1 = true;
		mapdata lyr = Game->LoadTempScreen(whichLayer);
		int backupCD[176];
		for(int i=0; i<176; ++i){
			backupCD[i] = lyr->ComboD[i];
		}
		bool shown = true;
		int fadeTimer = 8;
		
		while(true){
			linkX = Link->X;
			linkY = Link->Y;
			if(frame1){
				if(linkX==0)
					linkX = 240;
				else if(linkX==240)
					linkX = 0;
				if(linkY==0)
					linkY = 160;
				else if(linkY==160)
					linkY = 0;
			}
			if(lyr->ComboF[ComboAt(linkX+8, linkY+8)]==whichFlag){
				shown = false;
				if(frame1)
					fadeTimer = 0;
			}
			else{
				shown = true;
			}
			
			if(shown){
				if(fadeTimer<8)
					++fadeTimer;
				for(int i=0; i<176; ++i){
					if(lyr->ComboF[i]==whichFlag){
						if(fadeTimer==8)
							lyr->ComboD[i] = backupCD[i];
						else{
							Screen->FastCombo(whichLayer, ComboX(i), ComboY(i), backupCD[i], lyr->ComboC[i], 64);
						}
					}
				}
			}
			else{
				if(fadeTimer>0)
					--fadeTimer;
				for(int i=0; i<176; ++i){
					if(lyr->ComboF[i]==whichFlag){
						lyr->ComboD[i] = 0;
						if(fadeTimer>0){
							Screen->FastCombo(whichLayer, ComboX(i), ComboY(i), backupCD[i], lyr->ComboC[i], 64);
						}
					}
				}
			}
			
			frame1 = false;
			Waitframe();
		}
	}
}

ffc script SlowWaterAndLeeches{
	int FindWaterPos(){
		mapdata l1 = Game->LoadTempScreen(1);
		mapdata l2 = Game->LoadTempScreen(2);
		for(int i=0; i<352; ++i){
			int pos = Rand(176);
			if(i>=176)
				pos = i-176;
			if(l1->ComboT[pos]==CT_WATER&&l2->ComboS[pos]==0)
				return pos;
		}
	}
	void run(){
		if(!Game->FFRules[qr_WATER_ON_LAYER_1])
			Game->FFRules[qr_WATER_ON_LAYER_1] = true;
		npc leech[16];
		combodata cd = Game->LoadComboData(19332);
		for(int i=0; i<16; ++i){
			int pos = FindWaterPos();
			leech[i] = CreateNPCAt(241, ComboX(pos), ComboY(pos));
			leech[i]->HitXOffset = 4;
			leech[i]->HitYOffset = 4;
			leech[i]->HitWidth = 8;
			leech[i]->HitHeight = 8;
			leech[i]->CollDetection = false;
			leech[i]->Immortal = true;
			leech[i]->DrawYOffset = -1000;
		}
		bool wasinWater = (Link->Action==LA_SWIMMING||Link->Action==LA_DIVING);
		while(true){
			if(Link->Action==LA_SWIMMING||Link->Action==LA_DIVING){
				G[G_STEPMOD] -= 0.3;
				wasinWater = true;
			}
			else{
				wasinWater = false;
			}
			
			bool collidedLeech;
			
			for(int i=0; i<16; ++i){
				if(leech[i]->isValid()){
					if(RectCollision(Link->X+4, Link->Y+4, Link->X+11, Link->Y+11, leech[i]->X+4, leech[i]->Y+4, leech[i]->X+11, leech[i]->Y+11))
						collidedLeech = true;
				}
			}
			
			if(collidedLeech&&G[G_ANIM]%4==0&&(Link->Action==LA_SWIMMING||Link->Action==LA_DIVING)&&G[G_DRAWNHPZERO]<=0){
				Game->PlaySound(SFX_OUCH);
				DealDirectDamage(4, true);
			}
			
			Waitframe();
		}
	}
}

ffc script UndersideCave{ 
	void UC_StoreScreen(bool validLayers, int cd, int cc, int cf){
		for(int i=0; i<7; ++i){
			if(validLayers[i]){
				mapdata l = Game->LoadTempScreen(i);
				for(int j=0; j<176; ++j){
					cd[i*176+j] = l->ComboD[j];
					cc[i*176+j] = l->ComboC[j];
				}
			}
		}
	}
	void UC_CopyScreen(bool validLayers, int cd, int cc, int cf){
		for(int i=0; i<7; ++i){
			if(validLayers[i]){
				mapdata l = Game->LoadTempScreen(i);
				for(int j=0; j<176; ++j){
					l->ComboD[j] = cd[i*176+j];
					l->ComboC[j] = cc[i*176+j];
					l->ComboF[j] = cf[i*176+j];
				}
			}
			else{
				mapdata l = Game->LoadTempScreen(i);
				for(int j=0; j<176; ++j){
					l->ComboD[j] = 0;
				}
			}
		}
	}
	void run(int refMap, int refScreen){
		mapdata scrn = Game->LoadMapData(Game->GetCurMap(), Game->GetCurScreen());
		mapdata ref = Game->LoadMapData(refMap, refScreen);
		bool validLayers[7];
		int oldCD[1242];
		int oldCC[1242];
		int oldCF[1242];
		
		bool validRefLayers[7];
		int refCD[1242];
		int refCC[1242];
		int refCF[1242];
		
		for(int i=0; i<7; ++i){
			int lm = Game->GetCurMap();
			int ls = Game->GetCurScreen();
			if(i>0){
				if(scrn->LayerMap[i]>0){
					lm = scrn->LayerMap[i];
					ls = scrn->LayerScreen[i];
				}
			}
			if(i==0||scrn->LayerMap[i]>0){
				validLayers[i] = true;
				mapdata l = Game->LoadMapData(lm, ls);
				for(int j=0; j<176; ++j){
					oldCD[i*176+j] = l->ComboD[j];
					oldCC[i*176+j] = l->ComboC[j];
					oldCF[i*176+j] = l->ComboF[j];
				}
			}
			
			lm = refMap;
			ls = refScreen;
			if(i>0){
				if(ref->LayerMap[i]>0){
					lm = ref->LayerMap[i];
					ls = ref->LayerScreen[i];
				}
			}
			if(i==0||ref->LayerMap[i]>0){
				validRefLayers[i] = true;
				mapdata l = Game->LoadMapData(lm, ls);
				for(int j=0; j<176; ++j){
					refCD[i*176+j] = l->ComboD[j];
					refCC[i*176+j] = l->ComboC[j];
					refCF[i*176+j] = l->ComboF[j];
				}
			}
		}
	
		if(G[G_INUNDERSIDECAVE]){
			UC_CopyScreen(validRefLayers, refCD, refCC, refCF);
		}
		
		while(true){
			if(G[G_INUNDERSIDECAVE]){
				if(ComboFI(Link->X+8, Link->Y+12, CF_UNDERCAVEEXIT)){
					UC_StoreScreen(validRefLayers, refCD, refCC, refCF);
					UC_CopyScreen(validLayers, oldCD, oldCC, oldCF);
					G[G_INUNDERSIDECAVE] = 0;
				}
				if(Game->GetCurMap() == 28 && Game->GetCurScreen() == 0x5C){
					if(Screen->State[ST_SECRET]){
						mapdata l = Game->LoadTempScreen(1);
						if(l->ComboD[23] != 0){
							l->ComboD[23] = 0;
							l->ComboD[24] = 0;
						}
					}
					if(Screen->State[ST_LOCKBLOCK]){
						mapdata l = Game->LoadTempScreen(0);
						if(l->ComboD[74] != 29645){
							l->ComboD[74] = 29645;
							l->ComboD[107] = 29647;
							l->ComboD[108] = 29647;
						}
					}
				}
			}
			else{
				if(ComboFI(Link->X+8, Link->Y+12, CF_UNDERCAVEENTRANCE)){
					UC_StoreScreen(validLayers, oldCD, oldCC, oldCF);
					UC_CopyScreen(validRefLayers, refCD, refCC, refCF);
					G[G_INUNDERSIDECAVE] = 1;
				}
			}
			Waitframe();
		}
	}
}

ffc script BossFog{
	void DrawFog(int dist, int anim){
		DrawFogLayer(dist+Sin(anim[0]), 64);
		DrawFogLayer(dist-2+Sin(anim[1]), 64);
		DrawFogLayer(dist-4+Sin(anim[2]), 64);
		anim[0] = (anim[0]+6)%360;
		anim[1] = (anim[1]+6.6)%360;
		anim[2] = (anim[2]+7.2)%360;
	}
	void DrawFogLayer(int dist, int op){
		dist = Round(dist);
		if(dist>=1){
			Screen->Rectangle(6, 0, 0, 255, dist-1, 0x01, 1, 0, 0, 0, true, op);
			Screen->Rectangle(6, 0, 167-dist+1, 255, 167, 0x01, 1, 0, 0, 0, true, op);
			Screen->Rectangle(6, 0, dist, dist-1, 167-dist, 0x01, 1, 0, 0, 0, true, op);
			Screen->Rectangle(6, 255-dist+1, dist, 255, 167-dist, 0x01, 1, 0, 0, 0, true, op);
		}
	}
	void run(){
		Waitframes(10);
		bool bossPresent;
		while(!bossPresent){
			for(int i=Screen->NumNPCs(); i>0; --i){
				npc n = Screen->LoadNPC(i);
				if(n->Defense[NPCD_SWORD]!=NPCDT_BLOCK){
					bossPresent = true;
				}
			}
			Waitframe();
		}
		int fogDist;
		int fogAnim[3];
		for(int i=0; i<3; ++i){
			fogAnim[i] = Rand(360);
		}
		for(int i=0; i<=6; ++i){
			fogDist = i;
			DrawFog(fogDist, fogAnim);
			Waitframe();
		}
		while(true){
			if(Screen->NumNPCs() == 0)
				Quit();
			if(Link->X<2||Link->X>238||Link->Y<2||Link->Y>158){
				if(fogDist>0){
					Link->X = Clamp(Link->X, 2, 238);
					Link->Y = Clamp(Link->Y, 2, 158);
				}
				fogDist = fogDist-0.1;
				if(fogDist<=0)
					fogDist = -4;
			}
			else
				fogDist = Min(fogDist+0.2, 6);
			DrawFog(fogDist, fogAnim);
			Waitframe();
		}
	}
}

const int SFX_HAMILTONIANPATH = 68;

ffc script HamiltonianPath{
	const int LESSDUMBCYCLE = 5;
	void run(int triggerFlag, int layer, int comboCount){
		bool triggered[176];
		
		mapdata lyr = Game->LoadTempScreen(layer);
		
		bool solved;
		if(Screen->State[ST_SECRET]){
			for(int i=0; i<176; ++i){
				triggered[i] = true;
				if(lyr->ComboF[i]==triggerFlag||lyr->ComboI[i]==triggerFlag){
					if(lyr->ComboD[i]%2==0){
						++lyr->ComboD[i];
					}
				}
			}
			solved = true;
		}
		
		int lastPos = -1;
		if(comboCount==0){
			int cd0 = lyr->ComboD[0];
			for(int i=0; i<176; ++i){
				if(lyr->ComboF[i]==triggerFlag||lyr->ComboI[i]==triggerFlag){
					++comboCount;
				}
				else{
					bool hasFlag;
					combodata cdOrig = Game->LoadComboData(lyr->ComboD[i]);
					combodata cd = cdOrig;
					if(cd->Script==LESSDUMBCYCLE){
						do{
							lyr->ComboD[0] = cd->ID;
							if(lyr->ComboI[0]==triggerFlag){
								hasFlag = true;
								break;
							}
							if(cd->Script==LESSDUMBCYCLE){
								cd = Game->LoadComboData(cd->ID+cd->Attributes[0]);
							}
						}while(cd!=cdOrig&&cd->Script==LESSDUMBCYCLE)
					}
					if(hasFlag)
						++comboCount;
				}
			}
			lyr->ComboD[0] = cd0;
		}
		Waitframe();
		while(true){
			bool reset;
			if(!solved){
				int x = Link->X+7;
				int y = Link->Y+12;
					
				if(Link->Z<=0){
					int pos = ComboAt(x, y);
					if(!triggered[pos]){
						if(lyr->ComboF[pos]==triggerFlag||lyr->ComboI[pos]==triggerFlag){
							triggered[pos] = true;
							Game->PlaySound(SFX_HAMILTONIANPATH);
						}
					}
					else{
						if(pos!=lastPos&&(lyr->ComboF[pos]==triggerFlag||lyr->ComboI[pos]==triggerFlag)){
							Game->PlaySound(SFX_HAMILTONIANPATH);
							Game->PlaySound(SFX_ERROR);
							reset = true;
						}
					}
					lastPos = pos;
				}
				else
					lastPos = -1;
			}
			
			int count = 0;
			for(int i=0; i<176; ++i){
				if(reset)
					triggered[i] = false;
				if(triggered[i]){
					++count;
					if(lyr->ComboF[i]==triggerFlag||lyr->ComboI[i]==triggerFlag){
						if(solved){
							if(lyr->ComboD[i]%2==0){
								++lyr->ComboD[i];
							}
						}
						else
							Screen->FastCombo(layer, ComboX(i), ComboY(i), lyr->ComboD[i]+1, lyr->ComboC[i], 128);
					}
				}
			}
			
			if(!solved&&count>=comboCount){
				Screen->TriggerSecrets();
				Game->PlaySound(SFX_SECRET);
				Screen->State[ST_SECRET] = true;
				solved = true;
			}
			Waitframe();
		}
	}
}

ffc script AugmentTotem{ //DId it need a new script slot? No, but I'm lazy...
	void run(int id){
		
		int nD1[] = "Asher Augment Upgrade";
		int nD2[] = "Torrin Augment Upgrade";
		int nD3[] = "Kaylani Augment Upgrade";
		
		int D1[] = "An extra augment slot for Asher.";
		int D2[] = "An extra augment slot for Torrin.";
		int D3[] = "An extra augment slot for Kaylani.";
		
		int String1[] = "Return to me when your quest is complete and the bonds that bind you to friends and family have been fully strengthened.";
		int String2[] = "Return to me when your quest is complete.";
		int String3[] = "Return to me when the bonds that bind you to friends and family have been fully strengthened.";
		
		int String5[] = "I have nothing more to offer you. Go, and bear witness to what shall soon unfold.";
		
		int ItemIDs[] = 		{268, 269, 270};
		int Character[] = 		{0,   1,   2};
		int Cost[] = 			{222, 221, 220};
		int Descriptions[] = 	{D1,  D2,  D3};
		int Names[] = 			{nD1, nD2, nD3};

		
		//Totems:
		//Didn't even bother rewriting to account for only one totem. That's how lazy I am.
		int Totem1[] = {0, 1, 2};
		int Totems[] = {Totem1};
		
		bool QuestClear;
		bool SideClear;
		if(Game->Counter[CR_STORYFLAG] >= SFLAG_GAMECLEAR)
			QuestClear = true;
		if(Game->Counter[CR_NIGHTMARCHERQUEST] == 7 && Game->Counter[CR_MISCSIDEQUEST] == 8)
			SideClear = true;
		
		
	
		
		int Xoff = -16;
		int comboloc = ComboAt(this->X, this->Y) - 32;
		SetLayerComboD(3, comboloc, 11558);
		SetLayerComboD(3, comboloc+1, 11559);
				
		while(true){
			if(Link->Dir == DIR_UP && Link->Y >= this->Y + 8 && Link->Y <= this->Y + 24 && Link->X >= this->X - 8 && Link->X <= this->X + 8 && Game->Counter[CR_HELPERQUEST] != 1 && Game->Counter[CR_HELPERQUEST] != 2){
				Screen->FastCombo(6, this->X, this->Y-16-8, CMB_CANTALK, 0, 128);
				if(Link->PressA){
					Link->PressA = false;
					Link->InputA = false;
					
					int CurrentOption;
					int CurMax = 4;
					int CurMin = 0;
					int RealMax = 0;
					int TotAv = 0;
					int InvName[5];
					int InvStr[5];
					int InvPrice[5];
					int InvChar[5];
					int InvID[5];
					int Pull = Totems[id];
					for(int i = 0; i<5; i++){
						if(!FoundItems[ItemIDs[Pull[i]]])
							TotAv++;
						if(!FoundItems[ItemIDs[Pull[i]]] && CanUseChar(Character[Pull[i]]) > 0 && !(ItemIDs[Pull[i]] == 172 && !FoundItems[25]) && !(ItemIDs[Pull[i]] == 182 && !FoundItems[170])){
							InvName[RealMax] = Names[Pull[i]];
							InvStr[RealMax]  = Descriptions[Pull[i]];
							InvPrice[RealMax]  = Cost[Pull[i]];
							InvID[RealMax] = ItemIDs[Pull[i]];
							InvChar[RealMax]  = Character[Pull[i]];
							RealMax++;
						}
					}
					
					if(G[G_RANDOMIZERENABLED]){
						Game->PlaySound(6);
						PlayStringAndWait("I have nothing to offer, my role long since ended. Go forth and bear witness to the chaos that has unfolded. Avert not your eyes. You've made your choice.", SCHAR_TOTEM, EMOTE_NORMAL);
					}
					else if(!QuestClear && !SideClear){
						Game->PlaySound(6);
						PlayStringAndWait(String1, SCHAR_TOTEM, EMOTE_NORMAL);
					}
					else if(!QuestClear){
						Game->PlaySound(6);
						PlayStringAndWait(String2, SCHAR_TOTEM, EMOTE_NORMAL);
					}
					else if(!SideClear){
						Game->PlaySound(6);
						PlayStringAndWait(String3, SCHAR_TOTEM, EMOTE_NORMAL);
					}
					else if(RealMax == 0){
						Game->PlaySound(6);
						PlayStringAndWait(String5, SCHAR_TOTEM, EMOTE_NORMAL);
					}
					else{
						Game->PlaySound(86);
						mapdata l3 = Game->LoadTempScreen(3);
						l3->ComboD[comboloc] = 11577;
						l3->ComboD[comboloc+1] = 11578;
						// SetLayerComboD(3, comboloc, 11577);
						// SetLayerComboD(3, comboloc+1, 11578);
						WaitNoAction(60);
						while(true){
							//First, let's draw the frame
							DialogueBox_DrawBox(6, 128, 88, TIL_DB_DIALOGUE_BOX, CS_DB_DIALOGUE_BOX, C_DB_DIALOGUE_BOX_BG, 224, 144);
							Screen->FastTile(6, 128, 16, 65994, 11, OP_OPAQUE);
							for(int i = 32; i<=128; i+=16)
								Screen->FastTile(6, 128, i, 66014, 11, OP_OPAQUE);
							Screen->FastTile(6, 128, 144, 66034, 11, OP_OPAQUE);
							//The price
							if(InvPrice[CurrentOption] == 220)
								Screen->FastTile(6, 140+24, 43, 65900, 8, OP_OPAQUE);
							if(InvPrice[CurrentOption] == 221)
								Screen->FastTile(6, 140+24, 43, 65920, 7, OP_OPAQUE);
							if(InvPrice[CurrentOption] == 222)
								Screen->FastTile(6, 140+24, 43, 65900, 9, OP_OPAQUE);
							if(InvPrice[CurrentOption]>-1){
								Screen->DrawInteger(6, 182, 40+8, FONT_P, 1, -1, -1, -1, 1, 0, OP_OPAQUE);
							}
							//The description string
							if(!Tango_SlotIsActive(0))
								PlayTangoSubscreenMessage(InvStr[CurrentOption], STYLE_SHOP, 0, 112+24,64);
							//The actual buyable things
							for(int i=CurMin; i<=CurMax; i++){
								if(InvName[i] != 0){
									Screen->DrawString(6, 52+Xoff, 48+18*(i-CurMin), FONT_P, 0xB2, -1, TF_NORMAL, InvName[i], OP_OPAQUE);
									if(CurrentOption==i){
										Screen->FastTile(6, 52-8+Xoff, 48+4+18*(i-CurMin)-4, 5, 0, OP_OPAQUE); //Cursor
									}
								}
							}
							
							//Up and down selection
							if(Link->PressUp){
								Tango_ClearSlot(0);
								Game->PlaySound(5);
								CurrentOption--;
								if(CurrentOption<0){
									CurrentOption = RealMax-1;
									CurMax = RealMax;
									CurMin = RealMax-4;
									while(CurMin < 0){
										CurMin++;
										CurMax++;
									}
								}
								if(CurrentOption < CurMin){
									CurMax--;
									CurMin--;
								}
							}
							else if(Link->PressDown){
								Tango_ClearSlot(0);
								Game->PlaySound(5);
								CurrentOption++;
								if(CurrentOption>=RealMax){
									CurrentOption = 0;
									CurMin = 0;
									CurMax = 4;
								}
								if(CurrentOption > CurMax){
									CurMax++;
									CurMin++;
								}
							}
							if(Link->PressA){
								if(!Link->Item[InvPrice[CurrentOption]])
									Game->PlaySound(6);
								else{
									Tango_ClearSlot(0);
									if(InvID[CurrentOption] == 269){
										PlayStringAndWait("So how come I gotta trade in a Lunar Hymnstone when I'm not a lunar mage?", SCHAR_TORRIN, EMOTE_NORMAL);
										PlayStringAndWait("Well, it makes sense for me and Asher to have to Solar and Stellar Hymnstones.", SCHAR_KAYLANI, EMOTE_NORMAL);
										PlayStringAndWait("So what, I just get whatever's leftover? I don't even got anything to do with lunar magic.", SCHAR_TORRIN, EMOTE_ANGRY);
										PlayStringAndWait("Well... your village is built on the water, so it's affected by tides, and those come from the moon, so...", SCHAR_ASHER, EMOTE_NORMAL);
										PlayStringAndWait("Feels like I'm bein' badly profiled here.", SCHAR_TORRIN, EMOTE_ELLIPSES);
										PlayStringAndWait("Stop complaining and take your upgrade already!", SCHAR_KAYLANI, EMOTE_NORMAL);
									}
									Game->PlaySound(123);
									for(int i = 0; i<120; i++){
										Screen->FastTile(5, ComboX(comboloc), ComboY(comboloc), 28495, 4, OP_TRANS);
										Screen->FastTile(5, ComboX(comboloc)+16, ComboY(comboloc), 28496, 4, OP_TRANS);
										for(int j = ComboY(comboloc); j>=0; j-=16){
											Screen->FastTile(5, ComboX(comboloc), j, 28515, 4, OP_TRANS);
											Screen->FastTile(5, ComboX(comboloc)+16, j, 28516, 4, OP_TRANS);
										}
										WaitNoAction();
									}
									WaitNoAction(30);
									Game->PlaySound(121);
									int radius;
									for(int i = 0; i<180; i++){
										Screen->Circle(0, Link->X+8, Link->Y+8, 16, 0x01, 1, 0, 0, 0, true, OP_TRANS);
										Screen->Circle(0, Link->X+8, Link->Y+8, 16, 0x01, 1, 0, 0, 0, true, OP_OPAQUE);
										int Color = Choose(0x01, 0x5C, 0x5D);
										if(radius<16)
											radius++;
										Screen->Circle(0, Link->X+8, Link->Y+8, radius+Sin(i*8)*8, 0x01, 1, 0, 0, 0, true, OP_TRANS);
										Screen->Circle(4, Link->X+8, Link->Y+8, radius, Color, 1, 0, 0, 0, true, OP_TRANS);
										Screen->Rectangle(4, Link->X+8-radius, 0, Link->X+8+radius, Link->Y+8, Color, 1, 0, 0, 0, true, OP_TRANS);
										if(i==80)
											Game->PlaySound(122);
										WaitNoAction();
									}
									FoundItems[InvID[CurrentOption]] = true;
									
									if(InvID[CurrentOption] == 268){
										Game->Counter[CR_ASHERAUGMENTSLOTS]++;
									}
									if(InvID[CurrentOption] == 269){
										Game->Counter[CR_TORRINAUGMENTSLOTS]++;
									}
									if(InvID[CurrentOption] == 270){
										Game->Counter[CR_KAYLANIAUGMENTSLOTS]++;
									}
									mapdata l3 = Game->LoadTempScreen(3);
									l3->ComboD[comboloc] = 11558;
									l3->ComboD[comboloc+1] = 11559;
									// SetLayerComboD(3, comboloc, 11558);
									// SetLayerComboD(3, comboloc+1, 11559);
									Game->PlaySound(87);
									Tango_ClearSlot(0);
									WaitNoAction(60);
									break;
								}
							}
							if(Link->PressB){
								l3->ComboD[comboloc] = 11558;
								l3->ComboD[comboloc+1] = 11559;
								// SetLayerComboD(3, comboloc, 11558);
								// SetLayerComboD(3, comboloc+1, 11559);
								Game->PlaySound(87);
								Tango_ClearSlot(0);
								WaitNoAction(60);
								break;
							}
							WaitNoAction();
						}
					}
				}
			}
			Waitframe();
		}
	}
}

const int LTTP_BUMPER_FORCE = 3; //How fast Link gets pushed back when he hits a bumper
const int LTTP_BUMPER_ANIM_SPEED = 4; //How fast the bumpers animate in frames
const int SFX_LTTP_BUMPER = 152; //The sound that plays when Link hits a bumper

//Combo Setup: Each set of bumper combos should be arranged as so: 
//Bumper Frame 1
//Bumper Frame 2
//Bumper Frame 3
//Bumper Frame 4
//Each of the four combos is a frame in the bumper's animation.
//When Link hits the bumper it changes to frame 4 and then goes back a combo every LTTP_BUMPER_ANIM_SPEED frames.
//The FFC should use the first of the four bumper combos.
//D0: How many frames Link gets pushed back for when he hits the bumper

ffc script LttP_Bumper{
	void run(int Bounce){
		int Combo = this->Data;
		int BounceAngle = 0;
		int BounceCounter = 0;
		this->InitD[7] = 0;
		int AnimationCounter = 0;
		while(true){
			if(Distance(CenterX(this), CenterY(this), CenterLinkX(), CenterLinkY())<this->TileWidth*8+2&&Link->Z==0&&!Link->Falling){
				if(this->InitD[7]==0){
					G[G_DASHINTERRUPT] = 1;
					Game->PlaySound(SFX_LTTP_BUMPER);
					BounceAngle = Angle(CenterX(this), CenterY(this), CenterLinkX(), CenterLinkY());
					BounceCounter = Bounce;
					AnimationCounter = LTTP_BUMPER_ANIM_SPEED*4;
				}
				NoAction();
			}
			if(BounceCounter>0){
				LinkMovement_Push2(VectorX(LTTP_BUMPER_FORCE, BounceAngle), VectorY(LTTP_BUMPER_FORCE, BounceAngle));
				// PushX += VectorX(LTTP_BUMPER_FORCE, BounceAngle);
				// PushY += VectorY(LTTP_BUMPER_FORCE, BounceAngle);
				BounceCounter--;
			}
			if(AnimationCounter>0)
				AnimationCounter--;
			this->Data = Combo+Floor(AnimationCounter/LTTP_BUMPER_ANIM_SPEED);
			Waitframe();
		}
	}
}

ffc script ComboCheckTrigger{
	void run(int cmb){
		if(!Screen->State[ST_SECRET]){
			int count = 1;
			while(count>0){
				count = 0;
				for(int i=0; i<176; ++i){
					if(Screen->ComboD[i]==cmb)
						++count;
				}
				Waitframe();
			}
			Screen->TriggerSecrets();
			Screen->State[ST_SECRET] = true;
		}
	}
}

ffc script ForceTempSecret{
	void run(){
		while(true){
			Screen->State[ST_SECRET] = false;
			Waitframe();
		}
	}
}

ffc script Test{
	void run(){
		for(int i=0; i<8; ++i){
			item itm = CreateItemAt(this->InitD[i], this->X+16*i, this->Y);
		}
	}
}