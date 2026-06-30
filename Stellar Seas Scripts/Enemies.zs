const int EW_SOLAR = EW_SCRIPT1;
const int EW_LUNAR = EW_SCRIPT2;
const int EW_STELLAR = EW_SCRIPT3;
const int EW_COSMIC = EW_SCRIPT5;
const int EW_PHYSICAL = EW_MAGIC;

const int SPR_LIGHTSHOT = 89;
const int SPR_LUNARSHOT = 90;
const int SPR_STELLARSHOT = 93;
const int SPR_STELLARRING = 94;
const int SPR_RINGSHOT = 102;
const int SPR_LOBBOMB = 104;

const int TIL_COMPONENT_SUNGEM = 9548;
const int TIL_COMPONENT_MOONGEM = 9549;

const int SFX_COMPONENTREMOVED = 10;
const int SFX_MASKREMOVED = 6;
const int SFX_GLOW = 39;

const int SFX_LIGHTSHOT = 32;
const int SFX_RINGSHOT = 32;
const int SFX_CANNON = 84;

bool NPC_MagnetShake(ffc this, npc ghost, int resist, int polarity, bool removed){
	resist = Ceiling(resist/MagnetModifier());
	if(removed)
		return false;
	int x = Ghost_X;
	int y = Ghost_Y;
	bool canPull;
	if(GLW[GL_MAGNETHITBOX]->isValid()){
		canPull = GLW[GL_MAGNETHITBOX]->Damage != polarity;
		if(polarity == STATE_TIDALGAUNTLET_EITHER)
			canPull = true;
		if(Collision(ghost, GLW[GL_MAGNETHITBOX]) && canPull){
			int i;
			if(polarity == STATE_TIDALGAUNTLET_EITHER)
				canPull = true;
			for(i=0; i<resist; ++i){
				if(GLW[GL_MAGNETHITBOX]->isValid()){
					canPull = GLW[GL_MAGNETHITBOX]->Damage != polarity;
					if(!Collision(ghost, GLW[GL_MAGNETHITBOX]) || !canPull)
						break;
				}
				else
					break;
				if(i%4<2)
					Ghost_X = x-1;
				else
					Ghost_X = x+1;
				SSGhost_Waitframe(this, ghost);
			}
			Ghost_X = x;
			Ghost_Y = y;
			if(i==resist)
				return true;
		}
	}
}

eweapon NPC_MakeMagnetizedComponent(int x, int y, int tile, int cset, int args){
	eweapon e = CreateEWeaponAt(LW_SCRIPT10, x, y);
	e->OriginalTile = tile;
	e->Tile = tile;
	e->CSet = cset;
	RunEWeaponScript(e, "MagneticEnemyComponent", args);
	e->CollDetection = false;
	return e;
}

ffc script SolarElemental{
	void run(int enemyid){
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		Ghost_SetFlag(GHF_4WAY);
		Ghost_SetFlag(GHF_NORMAL);
		Ghost_UnsetFlag(GHF_SET_DIRECTION);
		
		int combo = ghost->Attributes[10];
		int counter = -1;
		bool removedGem;
		SetOverUnderLayer(ghost);
		while(true){
			if(removedGem)
				counter = Ghost_ConstantWalk4(counter, 30, ghost->Rate, ghost->Homing, ghost->Hunger);
			else
				counter = Ghost_HaltingWalk4(counter, ghost->Step, ghost->Rate, ghost->Homing, ghost->Hunger, ghost->Haltrate, 48);
			if(counter==16&&!removedGem&&Ghost_OnLinkLayer()){
				Ghost_Data = combo+4;
				for(int i=0; i<5&&!removedGem; ++i){
					eweapon e = FireEWeapon(EW_SOLAR, Ghost_X, Ghost_Y, DegtoRad(DirAngle(Ghost_Dir)), 400, ghost->WeaponDamage, SPR_LIGHTSHOT, 32, 0);
					e->Rotation = DirAngle(Ghost_Dir);
					RunEWeaponScript(e, "GlowEW", {16});
					for(int j=0; j<4; ++j){
						if(NPC_MagnetShake(this, ghost, 48, STATE_TIDALGAUNTLET_SUN, removedGem)){
							Game->PlaySound(SFX_COMPONENTREMOVED);
							removedGem = true;
							combo = 51240;
							Ghost_Data = combo;
							NPC_MakeMagnetizedComponent(Ghost_X, Ghost_Y-4, TIL_COMPONENT_SUNGEM, 0, {STATE_TIDALGAUNTLET_SUN, 1.2, 32});
						}
						SSGhost_Waitframe(this, ghost);
					}
				}
				Ghost_Data = combo;
			}
			if(NPC_MagnetShake(this, ghost, 48, STATE_TIDALGAUNTLET_SUN, removedGem)){
				Game->PlaySound(SFX_COMPONENTREMOVED);
				removedGem = true;
				combo = 51240;
				Ghost_Data = combo;
				NPC_MakeMagnetizedComponent(Ghost_X, Ghost_Y-4, TIL_COMPONENT_SUNGEM, 0, {STATE_TIDALGAUNTLET_SUN, 1.2, 32});
			}
			SSGhost_Waitframe(this, ghost);
		}
	}
}

ffc script LunarElemental{
	void run(int enemyid){
		int i; int j;
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		Ghost_SetFlag(GHF_4WAY);
		Ghost_SetFlag(GHF_NORMAL);
		Ghost_UnsetFlag(GHF_SET_DIRECTION);
		
		int combo = ghost->Attributes[10];
		int counter = -1;
		bool removedGem;
		SetOverUnderLayer(ghost);
		while(true){
			if(removedGem)
				counter = Ghost_ConstantWalk4(counter, 30, ghost->Rate, ghost->Homing, ghost->Hunger);
			else
				counter = Ghost_HaltingWalk4(counter, ghost->Step, ghost->Rate, ghost->Homing, ghost->Hunger, ghost->Haltrate, 48);
			if(counter==16&&!removedGem&&Ghost_OnLinkLayer()){
				Ghost_Data = combo+4;
				eweapon orbit[4];
				for(i=0; i<4; ++i){
					orbit[i] = FireEWeapon(EW_LUNAR, this->X, this->Y, 0, 0, ghost->WeaponDamage, SPR_LUNARSHOT, 40, EWF_UNBLOCKABLE);
					RunEWeaponScript(orbit[i], "LunarSwirl", {i*90, 48, 0.5, 10});
				}
				Ghost_UnsetFlag(GHF_KNOCKBACK);
				SSGhost_Waitframes(this, ghost, 16);
				Ghost_Data = combo;
				while(true){
					int count = 0;
					for(i=0; i<4; ++i){
						if(orbit[i]->isValid())
							++count;
					}
					if(count==0)
						break;
					if(NPC_MagnetShake(this, ghost, 48, STATE_TIDALGAUNTLET_MOON, removedGem)){
						Game->PlaySound(SFX_COMPONENTREMOVED);
						removedGem = true;
						combo = 51240;
						Ghost_Data = combo;
						NPC_MakeMagnetizedComponent(Ghost_X, Ghost_Y-4, TIL_COMPONENT_MOONGEM, 0, {STATE_TIDALGAUNTLET_MOON, 1.2, 32});
					}
					SSGhost_Waitframe(this, ghost);
				}
				Ghost_SetFlag(GHF_KNOCKBACK);
			}
			if(NPC_MagnetShake(this, ghost, 48, STATE_TIDALGAUNTLET_MOON, removedGem)){
				Game->PlaySound(SFX_COMPONENTREMOVED);
				removedGem = true;
				combo = 51240;
				Ghost_Data = combo;
				NPC_MakeMagnetizedComponent(Ghost_X, Ghost_Y-4, TIL_COMPONENT_MOONGEM, 0, {STATE_TIDALGAUNTLET_MOON, 1.2, 32});
			}
			SSGhost_Waitframe(this, ghost);
		}
	}
}

ffc script StellarElemental{
	void run(int enemyid){
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		Ghost_SetFlag(GHF_4WAY);
		Ghost_SetFlag(GHF_NORMAL);
		
		int combo = ghost->Attributes[10];
		int counter = -1;
		SetOverUnderLayer(ghost);
		while(true){
			counter = Ghost_HaltingWalk4(counter, ghost->Step, ghost->Rate, ghost->Homing, ghost->Hunger, ghost->Haltrate, 48);
			if(counter==16&&Ghost_OnLinkLayer()){
				Ghost_Data = combo+4;
				SSGhost_Waitframes(this, ghost, 8);
				eweapon e = FireEWeapon(EW_STELLAR, Ghost_X, Ghost_Y, DegtoRad(DirAngle(Ghost_Dir)), 300, ghost->WeaponDamage, SPR_STELLARSHOT, 32, 0);
				e->Rotation = DirAngle(Ghost_Dir);
				e->Script = Game->GetEWeaponScript("StellarBolt");
				SSGhost_Waitframes(this, ghost, 8);
				Ghost_Data = combo;
			}
			SSGhost_Waitframe(this, ghost);
		}
	}
}

ffc script ScriptedLeever{
	bool IsSandCombo(int cmb){
		switch(cmb){
			case 11:
			case 49:
			case 58:
			case 62:
			case 63:
			case 66:
			case 67:
			case 70:
			case 71:
			case 5697:
			case 5700:
			case 5702:
			case 5705:
				return true;
		}
		return false;
	}
	bool IsSand(int pos){
		int x = ComboX(pos);
		int y = ComboY(pos);
		if(Screen->isSolid(x+4, y+4)||Screen->isSolid(x+12, y+4)||Screen->isSolid(x+4, y+12)||Screen->isSolid(x+12, y+12))
			return false;
		pos = Min(pos, 0xFFFF);
		return IsSandCombo(Screen->ComboD[pos]) && Screen->ComboF[pos] != CF_NOGROUNDENEMY;
	}
	bool CanSubmerge(int x, int y){
		return IsSand(ComboAt(x, y)) && IsSand(ComboAt(x+15, y)) && IsSand(ComboAt(x, y+15)) && IsSand(ComboAt(x+15, y+15)) && !Screen->isSolid(x, y) && !Screen->isSolid(x+15, y+15);
	}
	void run(int enemyid){
		int i; int j;
		// bool sandCombos[0x10000];
		// sandCombos[49] = true;
		// sandCombos[58] = true;
		// sandCombos[62] = true;
		// sandCombos[63] = true;
		// sandCombos[66] = true;
		// sandCombos[67] = true;
		// sandCombos[70] = true;
		// sandCombos[71] = true;
		// sandCombos[5697] = true;
		// sandCombos[5700] = true;
		// sandCombos[5702] = true;
		// sandCombos[5705] = true;
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		
		Ghost_SetFlag(GHF_STUN);
		
		int type = ghost->Attributes[0];
		int minSubmerge = ghost->Attributes[1]*16;
		int maxSubmerge = ghost->Attributes[2]*16;
		int minChase = ghost->Attributes[3]*16;
		int maxChase = ghost->Attributes[4]*16;
		int combo = ghost->Attributes[10];
		
		bool removedGem = false;
		ghost->CollDetection = false;
		ghost->DrawYOffset = -1000;
		bool choosePosition = true;
		int tX; int tY; int pos;
		while(true){
			for(i=Rand(minSubmerge, maxSubmerge); i>0; --i){
				SSGhost_Waitframe(this, ghost);
			}
			if(choosePosition){
				for(i=0; i<528; ++i){
					if(i<176){
						tX = Rand(240);
						tY = Rand(160);
						if(CanSubmerge(tX, tY) && Distance(tX, tY, Link->X, Link->Y)>40)
							break;
					}
					else if(i<352){
						pos = Rand(176);
						tX = ComboX(pos);
						tY = ComboY(pos);
						if(CanSubmerge(tX, tY) && Distance(tX, tY, Link->X, Link->Y)>40)
							break;
					}
					else{
						pos = i-352;
						tX = ComboX(pos);
						tY = ComboY(pos);
						if(CanSubmerge(tX, tY))
							break;
					}
				}
				Ghost_X = tX;
				Ghost_Y = tY;
			}
			if(type==1)
				choosePosition = false;
			Ghost_Data = combo+2;
			ghost->DrawYOffset = -2;
			SSGhost_Waitframes(this, ghost, 32);
			Ghost_Data = combo+1;
			ghost->CollDetection = true;
			SSGhost_Waitframes(this, ghost, 32);
			Ghost_Data = combo;
			if(type <= 1){
				Ghost_SetFlag(GHF_KNOCKBACK_4WAY);
				int chase = Rand(minChase, maxChase);
				while(chase>0||!CanSubmerge(Ghost_X, Ghost_Y)){
					--chase;
					Ghost_MoveTowardLink(ghost->Step/100, 0);
					SSGhost_Waitframe(this, ghost);
				}
				Ghost_UnsetFlag(GHF_KNOCKBACK_4WAY);
			}
			else if(type == 2){
				for(i = 0; i < 60; i++){
					if(NPC_MagnetShake(this, ghost, 16, STATE_TIDALGAUNTLET_SUN, removedGem)){
						Game->PlaySound(SFX_COMPONENTREMOVED);
						removedGem = true;
						combo = 51232;
						Ghost_Data = combo;
						NPC_MakeMagnetizedComponent(Ghost_X, Ghost_Y, TIL_COMPONENT_SUNGEM, 0, {STATE_TIDALGAUNTLET_SUN, 1.2, 32});
					}
					SSGhost_Waitframe(this, ghost);
				}
				int ang = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
				for(i=0; i<2&&!removedGem; ++i){
					eweapon e = FireEWeapon(EW_SOLAR, Ghost_X, Ghost_Y, DegtoRad(ang), 400, ghost->WeaponDamage, SPR_LIGHTSHOT, 32, EWF_UNBLOCKABLE);
					e->Rotation = ang;
					for(j=0; j<4; ++j){
						if(NPC_MagnetShake(this, ghost, 16, STATE_TIDALGAUNTLET_SUN, removedGem)){
							Game->PlaySound(SFX_COMPONENTREMOVED);
							removedGem = true;
							combo = 51232;
							Ghost_Data = combo;
							NPC_MakeMagnetizedComponent(Ghost_X, Ghost_Y, TIL_COMPONENT_SUNGEM, 0, {STATE_TIDALGAUNTLET_SUN, 1.2, 32});
						}
						SSGhost_Waitframe(this, ghost);
					}
				}
				for(i = 0; i < 90; i++){
					if(NPC_MagnetShake(this, ghost, 16, STATE_TIDALGAUNTLET_SUN, removedGem)){
						Game->PlaySound(SFX_COMPONENTREMOVED);
						removedGem = true;
						combo = 51232;
						Ghost_Data = combo;
						NPC_MakeMagnetizedComponent(Ghost_X, Ghost_Y, TIL_COMPONENT_SUNGEM, 0, {STATE_TIDALGAUNTLET_SUN, 1.2, 32});
					}
					SSGhost_Waitframe(this, ghost);
				}
			}
			Ghost_Data = combo+1;
			SSGhost_Waitframes(this, ghost, 32);
			ghost->CollDetection = false;
			Ghost_Data = combo+2;
			SSGhost_Waitframes(this, ghost, 32);
			ghost->DrawYOffset = -1000;
		}
	}
}

ffc script SolarElementalGolem{
	void run(int enemyid){
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		Ghost_SetFlag(GHF_4WAY);
		Ghost_SetFlag(GHF_NORMAL);
		Ghost_UnsetFlag(GHF_SET_DIRECTION);
		
		int combo = ghost->Attributes[10];
		int counter = -1;
		Ghost_Transform(this, ghost, -1, -1, 1, 2);
		Ghost_SetHitOffsets(ghost, 0, 16, 0, 0);
		ghost->DrawYOffset -= 16;
		SetOverUnderLayer(ghost);
		while(true){
			counter = Ghost_HaltingWalk4(counter, ghost->Step, ghost->Rate, ghost->Homing, ghost->Hunger, ghost->Haltrate, 48);
			if(counter==16&&Ghost_OnLinkLayer()){
				Ghost_Data = combo+4;
				Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
				
				Ghost_UnsetFlag(GHF_KNOCKBACK);
				Game->PlaySound(SFX_SOLARBIGSHOT_CHARGE);
				eweapon e = FireNonAngularEWeapon(EW_SOLAR, Ghost_X+DirX(Ghost_Dir, 16), Ghost_Y+DirY(Ghost_Dir, 16), Ghost_Dir, 0, ghost->WeaponDamage, 0, 32, 0);
				e->CollDetection = false;
				RunEWeaponScript(e, "SolarBigShot", {48, 16, 0.2, 0.2});
				SSGhost_Waitframes(this, ghost, 48);
				Ghost_Data = combo;
				Ghost_SetFlag(GHF_KNOCKBACK);
			}
			if(GLW[GL_MAGNETHITBOX]->isValid()&&Collision(GLW[GL_MAGNETHITBOX], ghost)){
				Ghost_SetFlag(GHF_IGNORE_NO_ENEMY);
				Ghost_SetFlag(GHF_IGNORE_PITS);
				while(GLW[GL_MAGNETHITBOX]->isValid()&&Collision(GLW[GL_MAGNETHITBOX], ghost)){
					if(GLW[GL_MAGNETHITBOX]->Damage==STATE_TIDALGAUNTLET_MOON)
						Ghost_MoveXY(-DirX(GLW[GL_MAGNETHITBOX]->Dir, 0.5*MagnetModifier()), -DirY(GLW[GL_MAGNETHITBOX]->Dir, 0.5*MagnetModifier()), 0);
					else
						Ghost_MoveXY(DirX(GLW[GL_MAGNETHITBOX]->Dir, 0.5*MagnetModifier()), DirY(GLW[GL_MAGNETHITBOX]->Dir, 0.5*MagnetModifier()), 0);
					SSGhost_Waitframe(this, ghost);
				}
				Ghost_UnsetFlag(GHF_IGNORE_NO_ENEMY);
				Ghost_UnsetFlag(GHF_IGNORE_PITS);
				Ghost_Pitfall(this, ghost);
				int pos = ComboAt(Ghost_X+8, Ghost_Y+8);
				for(int i=0; i<8; ++i){
					if(Distance(Ghost_X, Ghost_Y, ComboX(pos), ComboY(pos))>2){
						Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, ComboX(pos), ComboY(pos)), 2, 0);
					}
					else{
						Ghost_X = ComboX(pos);
						Ghost_Y = ComboY(pos);
						break;
					}
					if(GLW[GL_MAGNETHITBOX]->isValid()&&Collision(GLW[GL_MAGNETHITBOX], ghost))
						break;
					SSGhost_Waitframe(this, ghost);
				}
				mapdata l1 = Game->LoadTempScreen(1);
				mapdata l3 = Game->LoadTempScreen(3);
				if(l1->ComboD[pos]==CMB_MAGNETGEM_HOLE){
					l1->ComboD[pos] = 41199;
					l3->ComboD[pos-16] = 41195;
					Ghost_X = -10000;
					Ghost_HP = 0;
					Game->PlaySound(68);
				}
			}
			Ghost_Pitfall(this, ghost);
			SSGhost_Waitframe(this, ghost);
		}
	}
}

ffc script LunarElementalGolem{
	void run(int enemyid){
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		Ghost_SetFlag(GHF_4WAY);
		Ghost_SetFlag(GHF_NORMAL);
		Ghost_UnsetFlag(GHF_SET_DIRECTION);
		
		int combo = ghost->Attributes[10];
		int counter = -1;
		Ghost_Transform(this, ghost, -1, -1, 1, 2);
		Ghost_SetHitOffsets(ghost, 0, 16, 0, 0);
		ghost->DrawYOffset -= 16;
		SetOverUnderLayer(ghost);
		while(true){
			counter = Ghost_HaltingWalk4(counter, ghost->Step, ghost->Rate, ghost->Homing, ghost->Hunger, ghost->Haltrate, 48);
			if(counter==16&&Ghost_OnLinkLayer()){
				Ghost_UnsetFlag(GHF_KNOCKBACK);
				Ghost_UnsetFlag(GHF_STUN);
				int angle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
				Ghost_Dir = AngleDir4(angle);
				for(int i=0; i<32; ++i){
					Ghost_MoveAtAngle(angle, 2, 0);
					if(i%8==0){
						eweapon e = FireEWeapon(EW_LUNAR, Ghost_X, Ghost_Y, 0, 0, ghost->WeaponDamage, SPR_LUNARSHOT, SFX_FIREBALL, EWF_UNBLOCKABLE);
						RunEWeaponScript(e, "LunarSwirl", {angle-90, 24, 1, 20, 64, 1});
						e = FireEWeapon(EW_LUNAR, Ghost_X, Ghost_Y, 0, 0, ghost->WeaponDamage, SPR_LUNARSHOT, SFX_FIREBALL, EWF_UNBLOCKABLE);
						RunEWeaponScript(e, "LunarSwirl", {angle+90, 32, 1, 20, 64, 1});
					}
					SSGhost_Waitframe(this, ghost);
				}
				SSGhost_Waitframes(this, ghost, 16);
				Ghost_Data = combo+4;
				SSGhost_Waitframes(this, ghost, 32);
				Game->PlaySound(SFX_GLOW);
				Ghost_Data = combo;
				SSGhost_Waitframes(this, ghost, 16);
				Ghost_SetFlag(GHF_KNOCKBACK);
				Ghost_SetFlag(GHF_STUN);
			}
			if(GLW[GL_MAGNETHITBOX]->isValid()&&Collision(GLW[GL_MAGNETHITBOX], ghost)){
				while(GLW[GL_MAGNETHITBOX]->isValid()&&Collision(GLW[GL_MAGNETHITBOX], ghost)){
					if(GLW[GL_MAGNETHITBOX]->Damage==STATE_TIDALGAUNTLET_SUN)
						Ghost_MoveXY(-DirX(GLW[GL_MAGNETHITBOX]->Dir, 0.5*MagnetModifier()), -DirY(GLW[GL_MAGNETHITBOX]->Dir, 0.5*MagnetModifier()), 0);
					else
						Ghost_MoveXY(DirX(GLW[GL_MAGNETHITBOX]->Dir, 0.5*MagnetModifier()), DirY(GLW[GL_MAGNETHITBOX]->Dir, 0.5*MagnetModifier()), 0);
					SSGhost_Waitframe(this, ghost);
				}
				int pos = ComboAt(Ghost_X+8, Ghost_Y+8);
				for(int i=0; i<8; ++i){
					if(Distance(Ghost_X, Ghost_Y, ComboX(pos), ComboY(pos))>2){
						Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, ComboX(pos), ComboY(pos)), 2, 0);
					}
					else{
						Ghost_X = ComboX(pos);
						Ghost_Y = ComboY(pos);
						break;
					}
					if(GLW[GL_MAGNETHITBOX]->isValid()&&Collision(GLW[GL_MAGNETHITBOX], ghost))
						break;
					SSGhost_Waitframe(this, ghost);
				}
			}
			Ghost_Pitfall(this, ghost);
			SSGhost_Waitframe(this, ghost);
		}
	}
}
const int TIL_STELLARSWORD = 65260;
const int TIL_STELLARSLASH = 65520;

const int SFX_STELLARSWORD_APPEAR = 99;
const int SFX_STELLARSWORD_SLASH = 100;

void DrawLightSwordSlash(int sx, int sy, int angle, int dist, int swordlength, int damage, int slashDir, int slashFrame){
	slashDir = -slashDir; //I got my math backwards and instead of fixing it I'm doing this
	int x = sx+8+VectorX(dist+24, angle)+VectorX(slashDir*32, angle+90)-40;
	int y = sy+8+VectorY(dist+24, angle)+VectorY(slashDir*32, angle+90)-48;
	if(slashDir!=0){
		angle += 45*slashDir;
		Screen->DrawTile(2, x, y, TIL_STELLARSLASH+5*slashFrame, 5, 6, 9, -1, -1, x, y, angle, slashDir==-1?0:2, true, 128);
		if(slashFrame==0){
			for(int j=0; j<=4; ++j){
				for(int k=1; k<6; ++k){
					x = sx+VectorX(k*14, angle-45*slashDir+j*10*slashDir);
					y = sy+VectorY(k*14, angle-45*slashDir+j*10*slashDir);
					MakeHitbox(EW_STELLAR, x, y, 16, 16, damage);
				}
			}
		}
	}
	else
		DrawLightSword(sx, sy, angle, dist, swordlength, damage);
}

void DrawLightSword(int sx, int sy, int angle, int dist, int swordlength, int damage){
	int x = sx + VectorX(dist+(swordlength-1)*8, angle)-(swordlength-1)*8;
	int y = sy + VectorY(dist+(swordlength-1)*8, angle);
	Screen->DrawTile(2, x, y, TIL_STELLARSWORD+4-(swordlength-1)+(G[G_ANIM]%4*20), swordlength, 1, 9, -1, -1, x, y, angle, 0, true, 128);
	for(int i=0; i<swordlength; ++i){
		x = sx + VectorX(dist+16*i, angle);
		y = sy + VectorY(dist+16*i, angle);
		MakeHitbox(EW_STELLAR, x, y, 16, 16, damage);
	}
}

ffc script StellarElementalGolem{
	void run(int enemyid){
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		Ghost_SetFlag(GHF_4WAY);
		Ghost_SetFlag(GHF_NORMAL);
		Ghost_UnsetFlag(GHF_SET_DIRECTION);
		
		int combo = ghost->Attributes[10];
		int counter = -1;
		Ghost_Transform(this, ghost, -1, -1, 1, 2);
		Ghost_SetHitOffsets(ghost, 0, 16, 0, 0);
		ghost->DrawYOffset -= 16;
		SetOverUnderLayer(ghost);
		while(true){
			counter = Ghost_HaltingWalk4(counter, ghost->Step, ghost->Rate, ghost->Homing, ghost->Hunger, ghost->Haltrate, 48);
			if(counter==16&&Ghost_OnLinkLayer()){
				Ghost_UnsetFlag(GHF_KNOCKBACK);
				Ghost_UnsetFlag(GHF_STUN);
				
				Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
				for(int i=0; i<16; ++i){
					Ghost_Move(Ghost_Dir, 3, 0);
					SSGhost_Waitframe(this, ghost);
				}
				Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
				Ghost_Data = combo+4;
				int angle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
				Game->PlaySound(SFX_STELLARSWORD_APPEAR);
				for(int i=1; i<6; ++i){
					for(int j=0; j<2; ++j){
						DrawLightSwordSlash(Ghost_X, Ghost_Y, angle-45, 16, i, ghost->WeaponDamage, 0, 0);
						//DrawLightSword(Ghost_X, Ghost_Y, angle-45, 16, i, ghost->WeaponDamage);
						SSGhost_Waitframe(this, ghost);
					}
				}
				for(int i=0; i<32; ++i){
					DrawLightSwordSlash(Ghost_X, Ghost_Y, angle-45, 16, 5, ghost->WeaponDamage, 0, 0);
					//DrawLightSword(Ghost_X, Ghost_Y, angle-45, 16, 5, ghost->WeaponDamage);
					SSGhost_Waitframe(this, ghost);
				}
				Game->PlaySound(SFX_STELLARSWORD_SLASH);
				for(int i=0; i<13; ++i){
					int til = TIL_STELLARSLASH;
					int frame;
					if(i>11)
						frame = 3;
					else if(i>9)
						frame = 2;
					else if(i>7)
						frame = 1;
					DrawLightSwordSlash(Ghost_X, Ghost_Y, angle+45, 16, 5, ghost->WeaponDamage, 1, frame);
					// int x = Ghost_X+8+VectorX(16+40, angle)-40;
					// int y = Ghost_Y+8+VectorY(16+40, angle)-48;
					// Screen->DrawTile(2, x, y, til, 5, 6, 9, -1, -1, x, y, angle, 0, true, 128);
					// if(i<7){
						// for(int j=0; j<=8; ++j){
							// for(int k=1; k<6; ++k){
								// x = Ghost_X+VectorX(-8+k*16, angle-40+j*10);
								// y = Ghost_Y+VectorY(-8+k*16, angle-40+j*10);
								// MakeHitbox(EW_STELLAR, x, y, 16, 16, ghost->WeaponDamage);
							// }
						// }
					// }
					SSGhost_Waitframe(this, ghost);
				}
				for(int i=4; i>0; --i){
					for(int j=0; j<2; ++j){
						DrawLightSwordSlash(Ghost_X, Ghost_Y, angle+45, 16, i, ghost->WeaponDamage, 0, 0);
						//DrawLightSword(Ghost_X, Ghost_Y, angle+45, 16, i, ghost->WeaponDamage);
						SSGhost_Waitframe(this, ghost);
					}
				}
				Ghost_Data = combo;
				
				Ghost_SetFlag(GHF_KNOCKBACK);
				Ghost_SetFlag(GHF_STUN);
			}
			Ghost_Pitfall(this, ghost);
			SSGhost_Waitframe(this, ghost);
		}
	}
}

bool isSolidLightRay(int x, int y){
	if(Screen->isSolid(x, y)){
		return true;
	}
	int pos = ComboAt(x, y);
	int cd = Screen->ComboD[pos];
	switch(cd){
		case 38560:
		case 38568:
			return true;
	}
	ffc f = Screen->LoadFFC(1);
	if(f->Script==7){ //Star Wand Block
		if(RectCollision(f->X, f->Y, f->X+f->TileWidth*16-1, f->Y+f->TileHeight*16-1, x, y, x, y)){
			return true;
		}
	}
	return false;
}

bool DrawLightRay(int startX, int startY, int angle, int dist, int arc, int iterations, int clr){
	return DrawLightRay(startX, startY, angle, dist, 0, arc, iterations, clr);
}

bool DrawLightRay(int startX, int startY, int angle, int dist, int safeDist, int arc, int iterations, int clr){
	if(Game->GetCurDMap()==60){
		return DrawLightWithFFCs(startX, startY, angle, dist, safeDist, arc, iterations, clr);
	}
	int pointDist[36];
	int pointX[36];
	int pointY[36];
	int arcStep = (arc/iterations);
	bool ret;
	for(int i=0; i<=iterations; ++i){
		int j;
		int x; int y;
		for(j=0; j<dist; j+=8){
			x = startX+VectorX(j, angle-arc/2+i*arcStep);
			y = startY+VectorY(j, angle-arc/2+i*arcStep);
			if(Screen->isSolid(x, y)&&j>=safeDist)
				break;
		}
		int oldJ = j;
		for(j = oldJ-8; j<oldJ+8; ++j){
			x = startX+VectorX(j, angle-arc/2+i*arcStep);
			y = startY+VectorY(j, angle-arc/2+i*arcStep);
			if(Screen->isSolid(x, y))
				break;
		}
		pointDist[i] = j;
		pointX[i] = x;
		pointY[i] = y;
	}
	for(int i=0; i<iterations; ++i){
		GBMP[BMP_LIGHTRAYS]->Triangle(0, startX, startY, pointX[i], pointY[i], pointX[i+1], pointY[i+1], 1, 1, clr, 0, -1, PT_FLAT, NULL);
		int tmpDist = (pointDist[i]+pointDist[i+1])/2;
		int tmpAngle = (angle-arc/2+i*(arc/iterations))+arcStep*0.5;
		int LinkAngle = Angle(startX, startY, Link->X+8, Link->Y+8);
		if(Abs(AngDiff(tmpAngle, LinkAngle))<arcStep*0.5){
			if(tmpDist>Distance(startX, startY, Link->X+8, Link->Y+8))
				ret = true;
		}
	}
	return ret;
}

bool DrawLightWithFFCs(int startX, int startY, int angle, int dist, int safeDist, int arc, int iterations, int clr){
	int pointDist[36];
	int pointX[36];
	int pointY[36];
	int arcStep = (arc/iterations);
	bool ret;
	for(int i=0; i<=iterations; ++i){
		int j;
		int x; int y;
		for(j=0; j<dist; j+=8){
			x = startX+VectorX(j, angle-arc/2+i*arcStep);
			y = startY+VectorY(j, angle-arc/2+i*arcStep);
			if(isSolidLightRay(x, y)&&j>=safeDist)
				break;
		}
		int oldJ = j;
		for(j = oldJ-8; j<oldJ+8; ++j){
			x = startX+VectorX(j, angle-arc/2+i*arcStep);
			y = startY+VectorY(j, angle-arc/2+i*arcStep);
			if(isSolidLightRay(x, y))
				break;
		}
		pointDist[i] = j;
		pointX[i] = x;
		pointY[i] = y;
	}
	for(int i=0; i<iterations; ++i){
		GBMP[BMP_LIGHTRAYS]->Triangle(0, startX, startY, pointX[i], pointY[i], pointX[i+1], pointY[i+1], 1, 1, clr, 0, -1, PT_FLAT, NULL);
		int tmpDist = (pointDist[i]+pointDist[i+1])/2;
		int tmpAngle = (angle-arc/2+i*(arc/iterations))+arcStep*0.5;
		int LinkAngle = Angle(startX, startY, Link->X+8, Link->Y+8);
		if(Abs(AngDiff(tmpAngle, LinkAngle))<arcStep*0.5){
			if(tmpDist>Distance(startX, startY, Link->X+8, Link->Y+8))
				ret = true;
		}
	}
	return ret;
}

const int TIL_CULTISTDAGGER = 106615;
const int TIL_COMPONENT_SUNMASK = 106655;
const int TIL_COMPONENT_MOONMASK = 106675;
const int TIL_COMPONENT_STARMASK = 106735;

ffc script Cultist{
	void run(int enemyid){
		int i;
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		Ghost_SetFlag(GHF_4WAY);
		Ghost_SetFlag(GHF_NORMAL);
		Ghost_UnsetFlag(GHF_SET_DIRECTION);
		int attackType = ghost->Attributes[0];
		int attackSubtype = ghost->Attributes[1];
		int maxHP = ghost->HP;
		int element = 0;
		if(attackType==0){
			element = 1;
		}
		else if(attackType==1){
			element = 2;
		}
		else if(attackType==3){
			if(attackSubtype==0)
				element = 1;
			else if(attackSubtype==1)
				element = 2;
			else if(attackSubtype==2)
				element = 3;
		}
		else if(attackType==4){
			element = 3;
		}
		
		int combo = ghost->Attributes[10];
		int counter = -1;
		Ghost_Transform(this, ghost, -1, -1, 1, 2);
		Ghost_Y += 8;
		Ghost_SetHitOffsets(ghost, 0, 16, 0, 0);
		ghost->DrawYOffset -= 16;
		int lightConeAngle = DirAngle(Ghost_Dir);
		bool doLightCone = true;
		int beamW;
		int sightCooldown = 90;
		bool removedMask;
		bool ignoreStealth;
		if(ignoreStealth)
			Ghost_UnsetFlag(GHF_STUN);
		dmapdata dm = Game->LoadDMapData(Game->GetCurDMap());
		if(dm->Script!=Game->GetDMapScript("StealthRays"))
			ignoreStealth = true;
		SetOverUnderLayer(ghost);
		
		bool noticed;
		if(Game->GetCurDMap()==9){
			Ghost_UnsetFlag(GHF_KNOCKBACK);
			int step = ghost->Step/100;
			int tempStep;
			int cf;
			mapdata l3 = Game->LoadTempScreen(3);
			int newDir = -1;
			for(i=0; i<4; ++i){
				if(l3->ComboF[ComboAt(Ghost_X+8+DirX(i, 16), Ghost_Y+8+DirY(i, 16))]==CF_PIRATEPATHINGTURN){
					newDir = i;
					break;
				}
			}
			lightConeAngle = DirAngle(Ghost_Dir);
			if(newDir>-1){
				Ghost_Dir = newDir;
				int walkDelay;
				while(!G[G_STEALTHSPOTTED]){
					noticed = false;
					tempStep += step;
					if(walkDelay)
						--walkDelay;
					while(tempStep>0){
						if(!walkDelay)
							Ghost_Move(Ghost_Dir, 1, 0);
						--tempStep;
						if(Ghost_X%16==0&&Ghost_Y%16==0){
							newDir = -1;
							cf = l3->ComboF[ComboAt(Ghost_X+8+DirX(Ghost_Dir, 16), Ghost_Y+8+DirY(Ghost_Dir, 16))];
							if(cf!=CF_PIRATEPATHINGTURN&&cf!=CF_PIRATEPATHING){
								for(i=0; i<4; ++i){ //Regular turn points, no 180
									cf = l3->ComboF[ComboAt(Ghost_X+8+DirX(i, 16), Ghost_Y+8+DirY(i, 16))];
									if((cf==CF_PIRATEPATHING||cf==CF_PIRATEPATHINGTURN)&&i!=OppositeDir(Ghost_Dir)){
										newDir = i;
										tempStep = 0;
										break;
									}
								}
								if(newDir>-1){
									Ghost_Dir = newDir;
									tempStep = 0;
								}
								else{
									for(i=0; i<4; ++i){ //Turn points, 180
										cf = l3->ComboF[ComboAt(Ghost_X+8+DirX(i, 16), Ghost_Y+8+DirY(i, 16))];
										if((cf==CF_PIRATEPATHING||cf==CF_PIRATEPATHINGTURN)){
											if(i==OppositeDir(Ghost_Dir))
												walkDelay = 16;
											Ghost_Dir = i;
											tempStep = 0;
											break;
										}
									}
								}
							}
						}
					}
					lightConeAngle = TurnToAngle(lightConeAngle, DirAngle(Ghost_Dir), 5);
					if(beamW<1)
						beamW += 0.05;
					noticed = DrawLightRay(Ghost_X+8, Ghost_Y+8, lightConeAngle, 80*LightRayTurnScale(lightConeAngle, 0), 40*beamW*LightRayTurnScale(lightConeAngle, 0), 8, 0x01);
					if(Ghost_GotHit())
						noticed = true;
					if(noticed){
						Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
						Game->PlaySound(SFX_ALERT);
						for(i=0; i<32; ++i){
							Screen->FastCombo(6, Ghost_X, Ghost_Y-16-Lerp(0, 12, i/32), 32871, 8, 128);
							SSGhost_Waitframe(this, ghost);
						}
						G[G_STEALTHSPOTTED] = 1;
					}
					SSGhost_Waitframe(this, ghost);
				}
			}
			Ghost_SetFlag(GHF_KNOCKBACK);
		}
		
		while(true){
			if(!Ghost_OnLinkLayer()){
				counter = Ghost_ConstantWalk4(counter, ghost->Step, ghost->Rate, ghost->Homing, ghost->Hunger);
				Ghost_Data = combo+4;
			}
			else if(!G[G_STEALTHSPOTTED]&&!ignoreStealth){
				counter = Ghost_ConstantWalk4(counter, ghost->Step, ghost->Rate, ghost->Homing, ghost->Hunger);
				Ghost_Data = combo;
			}
			else{
				int tempstep = 120;
				if(ignoreStealth)
					tempstep = ghost->Step;
				counter = Ghost_ConstantWalk4(counter, tempstep, ghost->Rate, 256, ghost->Hunger);
				if(Abs(Round(Ghost_X)%16)<2&&Abs(Round(Ghost_Y)%16)<2&&G[G_GHOSTWALKLAYER]==0){
					int dirToLink = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
					int oldX = Ghost_X;
					int oldY = Ghost_Y;
					Ghost_X = GridX(Ghost_X+8);
					Ghost_Y = GridY(Ghost_Y+8);
					if(!Ghost_CanMove(dirToLink, 1, 0)){
						int blockedPos = ComboAt(Ghost_X+8+DirX(dirToLink, 16), Ghost_Y+8+DirY(dirToLink, 16));
						int otherSidePos = ComboAt(Ghost_X+8+DirX(dirToLink, 32), Ghost_Y+8+DirY(dirToLink, 32));
						if(ComboSCombined(otherSidePos)==0&&Screen->ComboF[blockedPos]!=CF_NOGROUNDENEMY&&Screen->ComboT[otherSidePos]!=CT_PITFALL&&Screen->ComboT[otherSidePos]!=CT_WATER){
							Game->PlaySound(SFX_JUMP);
							Ghost_SetFlag(GHF_IGNORE_ALL_TERRAIN);
							Ghost_SetFlag(GHF_IGNORE_NO_ENEMY);
							Ghost_Dir = dirToLink;
							Ghost_Jump = 2.0;
							int duration = FindJumpLength(Ghost_Jump, false);
							for(int i=0; i<duration; ++i){
								Ghost_Move(dirToLink, 32/duration, 0);
								SSGhost_Waitframe(this, ghost);
							}
							Ghost_UnsetFlag(GHF_IGNORE_ALL_TERRAIN);
							Ghost_UnsetFlag(GHF_IGNORE_NO_ENEMY);
						}
						else{
							Ghost_X = oldX;
							Ghost_Y = oldY;
						}
					}
					else{
						Ghost_X = oldX;
						Ghost_Y = oldY;
					}
				}
				Ghost_Data = combo+4;
				beamW = 0;
				if(sightCooldown)
					--sightCooldown;
				else{
					Ghost_UnsetFlag(GHF_STUN);
					if(attackType==0&&CanSeeLink(Ghost_X, Ghost_Y, Ghost_Dir, 8)){
						sightCooldown = 60;
						Ghost_Data = combo+8;
						int angle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
						SSGhost_Waitframes(this, ghost, 8);
						Ghost_Data = combo+4;
						for(int i=0; i<16; ++i){
							Ghost_MoveAtAngle(angle, 4, 0);
							SSGhost_Waitframe(this, ghost);
						}
						Game->PlaySound(SFX_SWORD);
						Ghost_Data = combo+12;
						for(int i=0; i<24; ++i){
							int x = Ghost_X+DirX(Ghost_Dir, 12);
							int y = Ghost_Y+DirY(Ghost_Dir, 12);
							Screen->DrawTile(2, x, y, TIL_CULTISTDAGGER+((i<8)?1:0), 1, 1, 0, -1, -1, x, y, DirAngle(Ghost_Dir), 0, true, 128);
							MakeHitbox(EW_PHYSICAL, x, y, 16, 16, ghost->WeaponDamage);
							
							SSGhost_Waitframe(this, ghost);
						}
					}
					else if(attackType==1&&CanSeeLink(Ghost_X, Ghost_Y, Ghost_Dir, 24)){
						sightCooldown = 120;
						int angle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
						Ghost_Dir = AngleDir4(angle);
						Ghost_Data = combo+8;
						SSGhost_Waitframes(this, ghost, 8);
						for(int i=-1; i<=1; ++i){
							eweapon knife = FireEWeapon(EW_PHYSICAL, Ghost_X, Ghost_Y, DegtoRad(angle+7.5*i), 350, ghost->WeaponDamage, 0, SFX_ARROW, 0);
							knife->Rotation = RadtoDeg(knife->Angle);
							knife->OriginalTile = TIL_CULTISTDAGGER;
							knife->Tile = knife->OriginalTile;
						}
						Ghost_Data = combo+12;
						SSGhost_Waitframes(this, ghost, 16);
					}
					else if(attackType==3&&CanSeeLink(Ghost_X, Ghost_Y, Ghost_Dir, 8)){
						sightCooldown = 120;
						Ghost_Data = combo+8;
						int oldDir = Ghost_Dir;
						Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
						if(!Ghost_CanMove(Ghost_Dir, 1, 0))
							Ghost_Dir = oldDir;
						Ghost_UnsetFlag(GHF_STUN);
						if(attackSubtype==0){
							SSGhost_Waitframes(this, ghost, 12);
							Ghost_Data = combo+12;
							eweapon e = FireEWeapon(EW_SCRIPT1, Ghost_X+DirX(Ghost_Dir, 16), Ghost_Y+DirY(Ghost_Dir, 16), 0, 0, ghost->WeaponDamage, 0, 0, 0);
							e->CollDetection = false;
							e->Tile = GH_BLANK_TILE;
							RunEWeaponScript(e, "MagicBatteryEW", {Ghost_Dir, 0, 0});
						}
						else if(attackSubtype==1){
							SSGhost_Waitframes(this, ghost, 6);
							Ghost_Data = combo+12;
							eweapon e = FireEWeapon(EW_SCRIPT1, Ghost_X+DirX(Ghost_Dir, 16), Ghost_Y+DirY(Ghost_Dir, 16), 0, 0, ghost->WeaponDamage, 0, 0, 0);
							e->CollDetection = false;
							e->Tile = GH_BLANK_TILE;
							RunEWeaponScript(e, "MagicBatteryEW", {Ghost_Dir, 1, 1});
						}
						else if(attackSubtype==2){
							SSGhost_Waitframes(this, ghost, 24);
							Ghost_Data = combo+12;
							eweapon e = FireEWeapon(EW_SCRIPT1, Ghost_X+DirX(Ghost_Dir, 16), Ghost_Y+DirY(Ghost_Dir, 16), 0, 0, ghost->WeaponDamage, 0, 0, 0);
							e->CollDetection = false;
							e->Tile = GH_BLANK_TILE;
							RunEWeaponScript(e, "MagicBatteryEW", {Ghost_Dir, 2, 0});
						}
						SSGhost_Waitframes(this, ghost, 24);
						Ghost_Data = combo+8;
						Ghost_SetFlag(GHF_STUN);
					}
					else if(attackType==4&&CanSeeLink(Ghost_X, Ghost_Y, Ghost_Dir, 24)){
						sightCooldown = 180;
						int swingdir = Choose(-1, 1);
						int flip = 0;
						if(swingdir==-1)
							flip = 2;
						int angle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
						Ghost_Dir = AngleDir4(angle);
						Game->PlaySound(SFX_SWORD);
						for(int i=0; i<3; ++i){
							QuickSword(EW_PHYSICAL, Ghost_X, Ghost_Y, angle-60*swingdir, i*4, 51466, 9, flip, ghost->WeaponDamage);
							SSGhost_Waitframe(this, ghost);
						}
						for(int i=0; i<8; ++i){
							QuickSword(EW_PHYSICAL, Ghost_X, Ghost_Y, angle-60*swingdir, 12, 51466, 9, flip, ghost->WeaponDamage);
							SSGhost_Waitframe(this, ghost);
						}
						Game->PlaySound(SFX_SWORD);
						for(int i=-4; i<4; ++i){
							angle = TurnToAngle(angle, Angle(Ghost_X, Ghost_Y, Link->X, Link->Y), 5);
							Ghost_Dir = AngleDir4(angle);
							Ghost_MoveAtAngle(angle, 1.4, 0);
							QuickSword(EW_PHYSICAL, Ghost_X, Ghost_Y, angle+(i/4)*60*swingdir, 12, 51466+1, 9, flip, ghost->WeaponDamage);
							SSGhost_Waitframe(this, ghost);
						}
						swingdir = -swingdir;
						flip = (flip==0)?2:0;
						for(int i=0; i<8; ++i){
							QuickSword(EW_PHYSICAL, Ghost_X, Ghost_Y, angle-60*swingdir, 12, 51466, 9, flip, ghost->WeaponDamage);
							SSGhost_Waitframe(this, ghost);
						}
						Game->PlaySound(SFX_SWORD);
						for(int i=-4; i<4; ++i){
							angle = TurnToAngle(angle, Angle(Ghost_X, Ghost_Y, Link->X, Link->Y), 5);
							Ghost_Dir = AngleDir4(angle);
							Ghost_MoveAtAngle(angle, 1.4, 0);
							QuickSword(EW_PHYSICAL, Ghost_X, Ghost_Y, angle+(i/4)*60*swingdir, 12, 51466+1, 9, flip, ghost->WeaponDamage);
							SSGhost_Waitframe(this, ghost);
						}
						swingdir = -swingdir;
						flip = (flip==0)?2:0;
						Game->PlaySound(SFX_CHARGE1);
						for(int i=0; i<24; ++i){
							QuickSword(EW_PHYSICAL, Ghost_X, Ghost_Y, angle-60*swingdir, 12, 51466, 9, flip, ghost->WeaponDamage);
							SSGhost_Waitframe(this, ghost);
						}
						int moveAngle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y) - swingdir*30;
						int swordAngle = WrapDegrees(angle-60*swingdir);
						Game->PlaySound(SFX_SPINATTACK);
						for(int i=0; i<32; ++i){
							swordAngle = WrapDegrees(swordAngle+20);
							Ghost_Dir = AngleDir4(swordAngle);
							Ghost_MoveAtAngle(moveAngle, 3, 0);
							QuickSword(EW_PHYSICAL, Ghost_X, Ghost_Y, swordAngle, 12, 51466+1, 9, flip, ghost->WeaponDamage);
							SSGhost_Waitframe(this, ghost);
						}
						for(int i=4; i>0; --i){
							QuickSword(EW_PHYSICAL, Ghost_X, Ghost_Y, swordAngle, i*4, 51466, 9, flip, ghost->WeaponDamage);
							SSGhost_Waitframe(this, ghost);
						}
					}
					Ghost_SetFlag(GHF_STUN);
				}
			}
			if(beamW<1)
				beamW += 0.05;
			
			noticed = false;
			if(!ignoreStealth){
				lightConeAngle = TurnToAngle(lightConeAngle, DirAngle(Ghost_Dir), 5);
				if(G[G_STEALTHSPOTTED])
					noticed = true;
				if(!noticed)
					noticed = DrawLightRay(Ghost_X+8, Ghost_Y+8, lightConeAngle, 80, 40*beamW, 8, 0x01);
				if(Ghost_GotHit())
					noticed = true;
				if(ComboFI(Link->X+8, Link->Y+8)==CF_ENDSTEALTH)
					noticed = false;
				if(noticed){
					G[G_STEALTHSPOTTED] = 1;
					Ghost_SetFlag(GHF_STUN);
				}
				
				if(doLightCone&&!G[G_STEALTHSPOTTED]){
					if(Ghost_HP<maxHP)
						Ghost_HP = maxHP;
				}
			}
			
			if(Ghost_OnLinkLayer()){
				if(element==1){
					if(NPC_MagnetShake(this, ghost, 16, STATE_TIDALGAUNTLET_SUN, removedMask)){
						Game->PlaySound(SFX_MASKREMOVED);
						removedMask = true;
						int frame = Ghost_Data-combo;
						combo = 51332;
						Ghost_Data = combo+frame;
						NPC_MakeMagnetizedComponent(Ghost_X, Ghost_Y-8, TIL_COMPONENT_SUNMASK+Ghost_Dir, 0, {STATE_TIDALGAUNTLET_SUN, 1.2, 32});
						SSGhost_Waitframes(this, ghost, 16);
					}
				}
				else if(element==2){
					if(NPC_MagnetShake(this, ghost, 16, STATE_TIDALGAUNTLET_MOON, removedMask)){
						Game->PlaySound(SFX_MASKREMOVED);
						removedMask = true;
						int frame = Ghost_Data-combo;
						combo = 51332;
						Ghost_Data = combo+frame;
						NPC_MakeMagnetizedComponent(Ghost_X, Ghost_Y-8, TIL_COMPONENT_MOONMASK+Ghost_Dir, 0, {STATE_TIDALGAUNTLET_MOON, 1.2, 32});
						SSGhost_Waitframes(this, ghost, 16);
					}
				}
				else if(element==3){
					if(NPC_MagnetShake(this, ghost, 16, STATE_TIDALGAUNTLET_EITHER, removedMask)){
						Game->PlaySound(SFX_MASKREMOVED);
						removedMask = true;
						int frame = Ghost_Data-combo;
						combo = 51332;
						Ghost_Data = combo+frame;
						NPC_MakeMagnetizedComponent(Ghost_X, Ghost_Y-8, TIL_COMPONENT_STARMASK+Ghost_Dir, 0, {STATE_TIDALGAUNTLET_EITHER, 1.2, 32});
						SSGhost_Waitframes(this, ghost, 16);
					}
				}
			}
			Ghost_Pitfall(this, ghost);
			SSGhost_Waitframe(this, ghost);
		}
	}
}

ffc script Spider{
	void run(int enemyid){
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		Ghost_SetFlag(GHF_FULL_TILE_MOVEMENT);
		int WalkFrames = ghost->Attributes[0];
		int PauseFrames = ghost->Attributes[1];
		int L2 = ghost->Attributes[2];
		int SplitID = ghost->Attributes[3];
		int Combo = ghost->Attributes[10];
		Ghost_Transform(this, ghost, Combo, ghost->CSet, 1, 1);
		Ghost_SetHitOffsets(ghost, 4, 4, 4, 4);
		if(Ghost_Z>0){
			int angle = Rand(360);
			Ghost_Jump = 1;
			while(Ghost_Z>0){
				Ghost_MoveAtAngle(angle, 2, 0);
				SSGhost_Waitframe(this, ghost);
			}
		}
		SSGhost_Waitframes(this, ghost, Rand(1, 16));
		int pauseClk;
		int walkClk = WalkFrames;
		int moveAngle = Rand(360);
		while(true){
			if(L2){
				if(Distance(Ghost_X, Ghost_Y, Link->X, Link->Y)<32){
					for(int i=0; i<90; ++i){
						if(i%4==0)
							Ghost_X += 2;
						else if(i%4==2)
							Ghost_X -= 2;
						SSGhost_Waitframe(this, ghost);
					}
					for(int i=0; i<4; ++i){
						npc baby = CreateNPCAt(SplitID, Ghost_X, Ghost_Y);
						baby->Z = 1;
					}
					++Game->GuyCount[Game->GetCurScreen()];
					ghost->CollDetection = false;
					ghost->HP = 0;
					Ghost_HP = 0;
					ghost->ItemSet = 0;
					while(true){
						SSGhost_Waitframes(this, ghost, PauseFrames);
					}
				}
			}
			if(walkClk){
				Ghost_Data = Combo+1;
				Ghost_MoveAtAngle(moveAngle, ghost->Step/100, 0);
				--walkClk;
				if(!walkClk)
					pauseClk = PauseFrames;
			}
			else if(pauseClk){
				Ghost_Data = Combo;
				--pauseClk;
				if(!pauseClk){
					walkClk = WalkFrames;
					moveAngle = Rand(360);
				}
			}
			// Ghost_Data = Combo+1;
			// int Angle = Rand(1, 360);
			// for(int i=0; i<WalkFrames; i++){
				// Ghost_MoveAtAngle(Angle, ghost->Step/100, 0);
				// SSGhost_Waitframe(this, ghost);
			// }
			// Ghost_Data = Combo;
			SSGhost_Waitframe(this, ghost);
		}
	}
}

const int CMB_PIRATE_WEAPONS = 51372;
const int TIL_PIRATE_BULLET = 106426;
const int SFX_PIRATE_BULLET = 84;

const int SFX_ALERT = 125;

int LightRayTurnScale(int angle, int minScale){
	angle = WrapDegrees(angle);
	int dirAngle = DirAngle(AngleDir4(angle));
	return Lerp(1, minScale, Abs(AngDiff(angle, dirAngle))/45);
}

ffc script Pirate{
	void run(int enemyid){
		int i;
		int x; int y;
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		Ghost_SetFlag(GHF_4WAY);
		Ghost_SetFlag(GHF_NORMAL);
		Ghost_UnsetFlag(GHF_SET_DIRECTION);
		int attackType = ghost->Attributes[0];
		
		int enemyNum;
		int numNPC = Screen->NumNPCs();
		for(int i=1; i<=numNPC; ++i){
			npc n = Screen->LoadNPC(i);
			switch(n->ID){
				case 191:
				case 192:
				case 193:
				case 231:
					++enemyNum;
					break;
			}
			if(n==ghost)
				break;
		}
		GRNG->SRand(Game->GetCurMap()*4096+Game->GetCurScreen()*16+enemyNum);
		int combo = ghost->Attributes[GRNG->Rand(8,10)];
		int counter = -1;
		Ghost_Transform(this, ghost, combo, -1, 1, 2);
		Ghost_Y += 8;
		Ghost_SetHitOffsets(ghost, 0, 16, 0, 0);
		ghost->DrawYOffset -= 16;
		int sightCooldown;
		int lightConeAngle = DirAngle(Ghost_Dir);
		bool noticed;
		int beamW;
		if(Game->GetCurDMap()==60){
			Ghost_UnsetFlag(GHF_KNOCKBACK);
			int step = ghost->Step/100;
			int tempStep;
			int cf;
			mapdata l3 = Game->LoadTempScreen(3);
			int newDir = -1;
			for(i=0; i<4; ++i){
				if(l3->ComboF[ComboAt(Ghost_X+8+DirX(i, 16), Ghost_Y+8+DirY(i, 16))]==CF_PIRATEPATHINGTURN){
					newDir = i;
					break;
				}
			}
			lightConeAngle = DirAngle(Ghost_Dir);
			if(newDir>-1){
				Ghost_Dir = newDir;
				int walkDelay;
				while(!G[G_STEALTHSPOTTED]){
					noticed = false;
					tempStep += step;
					if(walkDelay)
						--walkDelay;
					while(tempStep>0){
						if(!walkDelay)
							Ghost_Move(Ghost_Dir, 1, 0);
						--tempStep;
						if(Ghost_X%16==0&&Ghost_Y%16==0){
							newDir = -1;
							cf = l3->ComboF[ComboAt(Ghost_X+8+DirX(Ghost_Dir, 16), Ghost_Y+8+DirY(Ghost_Dir, 16))];
							if(cf!=CF_PIRATEPATHINGTURN&&cf!=CF_PIRATEPATHING){
								for(i=0; i<4; ++i){ //Regular turn points, no 180
									cf = l3->ComboF[ComboAt(Ghost_X+8+DirX(i, 16), Ghost_Y+8+DirY(i, 16))];
									if((cf==CF_PIRATEPATHING||cf==CF_PIRATEPATHINGTURN)&&i!=OppositeDir(Ghost_Dir)){
										newDir = i;
										tempStep = 0;
										break;
									}
								}
								if(newDir>-1){
									Ghost_Dir = newDir;
									tempStep = 0;
								}
								else{
									for(i=0; i<4; ++i){ //Turn points, 180
										cf = l3->ComboF[ComboAt(Ghost_X+8+DirX(i, 16), Ghost_Y+8+DirY(i, 16))];
										if((cf==CF_PIRATEPATHING||cf==CF_PIRATEPATHINGTURN)){
											if(i==OppositeDir(Ghost_Dir))
												walkDelay = 16;
											Ghost_Dir = i;
											tempStep = 0;
											break;
										}
									}
								}
							}
						}
					}
					lightConeAngle = TurnToAngle(lightConeAngle, DirAngle(Ghost_Dir), 5);
					if(beamW<1)
						beamW += 0.05;
					noticed = DrawLightRay(Ghost_X+8, Ghost_Y+8, lightConeAngle, 80*LightRayTurnScale(lightConeAngle, 0), 40*beamW*LightRayTurnScale(lightConeAngle, 0), 8, 0x01);
					if(Ghost_GotHit())
						noticed = true;
					if(noticed){
						Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
						Game->PlaySound(SFX_ALERT);
						for(i=0; i<32; ++i){
							Screen->FastCombo(6, Ghost_X, Ghost_Y-16-Lerp(0, 12, i/32), 32871, 8, 128);
							SSGhost_Waitframe(this, ghost);
						}
						G[G_STEALTHSPOTTED] = 1;
					}
					SSGhost_Waitframe(this, ghost);
				}
			}
			Ghost_SetFlag(GHF_KNOCKBACK);
		}
		while(true){
			int haltRate = ghost->Haltrate;
			if(Distance(Ghost_X, Ghost_Y, Link->X, Link->Y)<32&&attackType==0){
				haltRate = 10;
			}
			if(!G[G_STEALTHSPOTTED]&&Game->GetCurDMap()==60){
				noticed = false;
				counter = Ghost_ConstantWalk4(counter, ghost->Step, ghost->Rate, ghost->Homing, ghost->Hunger);
				lightConeAngle = TurnToAngle(lightConeAngle, DirAngle(Ghost_Dir), 5);
				if(beamW<1)
					beamW += 0.05;
				noticed = DrawLightRay(Ghost_X+8, Ghost_Y+8, lightConeAngle, 80*LightRayTurnScale(lightConeAngle, 0), 40*beamW*LightRayTurnScale(lightConeAngle, 0), 8, 0x01);
				if(Ghost_GotHit())
					noticed = true;
				if(noticed){
					Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
					Game->PlaySound(SFX_ALERT);
					for(i=0; i<32; ++i){
						Screen->FastCombo(6, Ghost_X, Ghost_Y-16-Lerp(0, 12, i/32), 32871, 8, 128);
						SSGhost_Waitframe(this, ghost);
					}
					G[G_STEALTHSPOTTED] = 1;
				}
			}
			else{
				counter = Ghost_HaltingWalk4(counter, ghost->Step, ghost->Rate, ghost->Homing, ghost->Hunger, haltRate, 48);
				if(counter==16){
					if(attackType==0){
						Ghost_Data = combo+4;
						Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
						Ghost_UnsetFlag(GHF_STUN);
						Game->PlaySound(SFX_SWORD);
						for(i=0; i<4; ++i){
							Ghost_Move(Ghost_Dir, 2, 0);
							QuickSword(EW_PHYSICAL, Ghost_X, Ghost_Y, DirAngle(Ghost_Dir)-90, i*4, CMB_PIRATE_WEAPONS, 11, ghost->WeaponDamage);
							SSGhost_Waitframe(this, ghost);
						}
						for(i=0; i<9; ++i){
							QuickSword(EW_PHYSICAL, Ghost_X, Ghost_Y, DirAngle(Ghost_Dir)-90+i*20, 16, CMB_PIRATE_WEAPONS, 11, ghost->WeaponDamage);
							SSGhost_Waitframe(this, ghost);
						}
						for(i=0; i<4; ++i){
							Ghost_Move(OppositeDir(Ghost_Dir), 2, 0);
							QuickSword(EW_PHYSICAL, Ghost_X, Ghost_Y, DirAngle(Ghost_Dir)+90, 16-i*4, CMB_PIRATE_WEAPONS, 11, ghost->WeaponDamage);
							SSGhost_Waitframe(this, ghost);
						}
						Ghost_SetFlag(GHF_STUN);
						Ghost_Data = combo;
					}
					else if(attackType==1){
						Ghost_Data = combo+4;
						Ghost_UnsetFlag(GHF_STUN);
						Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
						Game->PlaySound(SFX_ARROW);
						for(i=0; i<4; ++i){
							Screen->FastCombo(2, Ghost_X+DirX(Ghost_Dir, i*3), Ghost_Y+DirY(Ghost_Dir, i*3), CMB_PIRATE_WEAPONS+2, 11, 128);
							SSGhost_Waitframe(this, ghost);
						}
						for(i=0; i<4; ++i){
							Screen->FastCombo(2, Ghost_X+DirX(Ghost_Dir, 12), Ghost_Y+DirY(Ghost_Dir, 12), CMB_PIRATE_WEAPONS+2, 11, 128);
							SSGhost_Waitframe(this, ghost);
						}
						int r; int flip;
						int layer = 2;
						switch(Ghost_Dir){
							case DIR_UP: r = 90; flip = 1; break;
							case DIR_DOWN: r = 90; layer = 2; break;
							case DIR_LEFT: flip = 1; break;
							case DIR_RIGHT: break;
						}
						for(i=0; i<4; ++i){
							x = Ghost_X+DirX(Ghost_Dir, 12);
							y = Ghost_Y+DirY(Ghost_Dir, 12)-4;
							Screen->DrawCombo(layer, x, y, CMB_PIRATE_WEAPONS+1, 1, 1, 11, -1, -1, x, y, r, -1, flip, true, 128);
							SSGhost_Waitframe(this, ghost);
						}
						eweapon e = FireEWeapon(EW_PHYSICAL, Ghost_X+DirX(Ghost_Dir, 12), Ghost_Y+DirY(Ghost_Dir, 12), DegtoRad(DirAngle(Ghost_Dir)), 300, ghost->WeaponDamage, 0, SFX_PIRATE_BULLET, 0);
						e->HitXOffset = 4;
						e->HitYOffset = 4;
						e->HitWidth = 8;
						e->HitHeight = 8;
						e->OriginalTile = TIL_PIRATE_BULLET;
						e->Tile = e->OriginalTile;
						e->CSet = 11;
						for(int i=0; i<16; ++i){
							x = Ghost_X+DirX(Ghost_Dir, 12);
							y = Ghost_Y+DirY(Ghost_Dir, 12)-4;
							Screen->DrawCombo(layer, x, y, CMB_PIRATE_WEAPONS+1, 1, 1, 11, -1, -1, x, y, r, -1, flip, true, 128);
							SSGhost_Waitframe(this, ghost);
						}
						for(int i=0; i<4; ++i){
							x = Ghost_X+DirX(Ghost_Dir, 12-i*3);
							y = Ghost_Y+DirY(Ghost_Dir, 12-i*3)-4;
							Screen->DrawCombo(layer, x, y, CMB_PIRATE_WEAPONS+1, 1, 1, 11, -1, -1, x, y, r, -1, flip, true, 128);
							SSGhost_Waitframe(this, ghost);
						}
						
						Ghost_SetFlag(GHF_STUN);
						Ghost_Data = combo;
					}
					else if(attackType==2){
						Ghost_Data = combo+4;
						int oldDir = Ghost_Dir;
						Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
						if(!Ghost_CanMove(Ghost_Dir, 1, 0))
							Ghost_Dir = oldDir;
						Ghost_UnsetFlag(GHF_STUN);
						eweapon e = FireEWeapon(EW_SCRIPT1, Ghost_X+DirX(Ghost_Dir, 16), Ghost_Y+DirY(Ghost_Dir, 16), 0, 0, ghost->WeaponDamage, 0, 0, 0);
						e->CollDetection = false;
						e->Tile = GH_BLANK_TILE;
						RunEWeaponScript(e, "MagicBatteryEW", {Ghost_Dir, 1, 0});
						SSGhost_Waitframes(this, ghost, 24);
						
						Ghost_SetFlag(GHF_STUN);
						Ghost_Data = combo;
					}
					else if(attackType==3){
						if(Distance(Ghost_X, Ghost_Y, Link->X, Link->Y)>64){ //Gun
							Ghost_Data = combo+4;
							Ghost_UnsetFlag(GHF_STUN);
							Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
							Game->PlaySound(SFX_ARROW);
							for(i=0; i<4; ++i){
								Screen->FastCombo(2, Ghost_X+DirX(Ghost_Dir, i*3), Ghost_Y+DirY(Ghost_Dir, i*3), CMB_PIRATE_WEAPONS+2, 11, 128);
								SSGhost_Waitframe(this, ghost);
							}
							for(i=0; i<4; ++i){
								Screen->FastCombo(2, Ghost_X+DirX(Ghost_Dir, 12), Ghost_Y+DirY(Ghost_Dir, 12), CMB_PIRATE_WEAPONS+2, 11, 128);
								SSGhost_Waitframe(this, ghost);
							}
							int r; int flip;
							int layer = 2;
							switch(Ghost_Dir){
								case DIR_UP: r = 90; flip = 1; break;
								case DIR_DOWN: r = 90; layer = 2; break;
								case DIR_LEFT: flip = 1; break;
								case DIR_RIGHT: break;
							}
							for(i=0; i<4; ++i){
								x = Ghost_X+DirX(Ghost_Dir, 12);
								y = Ghost_Y+DirY(Ghost_Dir, 12)-4;
								Screen->DrawCombo(layer, x, y, CMB_PIRATE_WEAPONS+1, 1, 1, 11, -1, -1, x, y, r, -1, flip, true, 128);
								SSGhost_Waitframe(this, ghost);
							}
							for(int j=0; j<6; ++j){
								Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
								r = 0;
								flip = 0;
								layer = 2;
								switch(Ghost_Dir){
									case DIR_UP: r = 90; flip = 1; break;
									case DIR_DOWN: r = 90; layer = 2; break;
									case DIR_LEFT: flip = 1; break;
									case DIR_RIGHT: break;
								}
								eweapon e = FireEWeapon(EW_PHYSICAL, Ghost_X+DirX(Ghost_Dir, 12), Ghost_Y+DirY(Ghost_Dir, 12), DegtoRad(DirAngle(Ghost_Dir)), 300, ghost->WeaponDamage, 0, SFX_PIRATE_BULLET, 0);
								e->HitXOffset = 4;
								e->HitYOffset = 4;
								e->HitWidth = 8;
								e->HitHeight = 8;
								e->OriginalTile = TIL_PIRATE_BULLET;
								e->Tile = e->OriginalTile;
								e->CSet = 11;
								int angle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y)+Choose(-60, 60);
								int k = 32+Rand(8);
								for(int i=0; i<k; ++i){
									if(i>=k-8)
										Ghost_MoveAtAngle(angle, 4, 0);
									x = Ghost_X+DirX(Ghost_Dir, 12);
									y = Ghost_Y+DirY(Ghost_Dir, 12)-4;
									Screen->DrawCombo(layer, x, y, CMB_PIRATE_WEAPONS+1, 1, 1, 11, -1, -1, x, y, r, -1, flip, true, 128);
									SSGhost_Waitframe(this, ghost);
								}
							}
							for(int i=0; i<4; ++i){
								x = Ghost_X+DirX(Ghost_Dir, 12-i*3);
								y = Ghost_Y+DirY(Ghost_Dir, 12-i*3)-4;
								Screen->DrawCombo(layer, x, y, CMB_PIRATE_WEAPONS+1, 1, 1, 11, -1, -1, x, y, r, -1, flip, true, 128);
								SSGhost_Waitframe(this, ghost);
							}
							
							Ghost_SetFlag(GHF_STUN);
							Ghost_Data = combo;
						}
						else{ //Sword
							for(int j=0; j<3; ++j){
								int k = Choose(-1, 1);
								int flip = k==-1?2:0;
								int angle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
								Ghost_Data = combo+4;
								Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
								Ghost_UnsetFlag(GHF_STUN);
								Game->PlaySound(SFX_SWORD);
								for(i=0; i<4; ++i){
									Ghost_Move(Ghost_Dir, 2, 0);
									QuickSword(EW_PHYSICAL, Ghost_X, Ghost_Y, DirAngle(Ghost_Dir)-90*k, i*4, CMB_PIRATE_WEAPONS, 11, flip, ghost->WeaponDamage);
									SSGhost_Waitframe(this, ghost);
								}
								for(i=0; i<9; ++i){
									Ghost_MoveAtAngle(angle, 0.75, 0);
									QuickSword(EW_PHYSICAL, Ghost_X, Ghost_Y, DirAngle(Ghost_Dir)-90*k+i*20*k, 16, CMB_PIRATE_WEAPONS, 11, flip, ghost->WeaponDamage);
									SSGhost_Waitframe(this, ghost);
								}
								for(i=0; i<4; ++i){
									Ghost_Move(OppositeDir(Ghost_Dir), 2, 0);
									QuickSword(EW_PHYSICAL, Ghost_X, Ghost_Y, DirAngle(Ghost_Dir)+90*k, 16-i*4, CMB_PIRATE_WEAPONS, 11, flip, ghost->WeaponDamage);
									SSGhost_Waitframe(this, ghost);
								}
								Ghost_SetFlag(GHF_STUN);
								Ghost_Data = combo;
							}
							for(i=0; i<48; ++i){
								Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
								Ghost_MoveAtAngle(Angle(Link->X, Link->Y, Ghost_X, Ghost_Y), 0.75, 0);
								SSGhost_Waitframe(this, ghost);
							}
							int angle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y)+Choose(-45, 45);
							Ghost_Data = combo+4;
							Ghost_Dir = AngleDir4(angle);
							Ghost_UnsetFlag(GHF_STUN);
							Game->PlaySound(SFX_SWORD);
							for(i=0; i<4; ++i){
								Ghost_Move(Ghost_Dir, 2, 0);
								QuickSword(EW_PHYSICAL, Ghost_X, Ghost_Y, DirAngle(Ghost_Dir)-90, i*4, CMB_PIRATE_WEAPONS, 11, 0, ghost->WeaponDamage);
								SSGhost_Waitframe(this, ghost);
							}
							for(i=0; i<9; ++i){
								Ghost_MoveAtAngle(angle, 4, 0);
								QuickSword(EW_PHYSICAL, Ghost_X, Ghost_Y, DirAngle(Ghost_Dir)-90+i*20, 16, CMB_PIRATE_WEAPONS, 11, 0, ghost->WeaponDamage);
								SSGhost_Waitframe(this, ghost);
							}
							for(i=0; i<4; ++i){
								Ghost_Move(OppositeDir(Ghost_Dir), 1, 0);
								QuickSword(EW_PHYSICAL, Ghost_X, Ghost_Y, DirAngle(Ghost_Dir)+90, 16-i*4, CMB_PIRATE_WEAPONS, 11, 0, ghost->WeaponDamage);
								SSGhost_Waitframe(this, ghost);
							}
							Ghost_SetFlag(GHF_STUN);
							Ghost_Data = combo;
							angle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
							Ghost_Data = combo+4;
							Ghost_Dir = AngleDir4(angle);
							for(i=0; i<16; ++i){
								Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
								Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y), 0.25, 0);
								SSGhost_Waitframe(this, ghost);
							}
							Ghost_UnsetFlag(GHF_STUN);
							Game->PlaySound(SFX_SWORD);
							for(i=0; i<4; ++i){
								Ghost_Move(Ghost_Dir, 2, 0);
								QuickSword(EW_PHYSICAL, Ghost_X, Ghost_Y, DirAngle(Ghost_Dir)+90, i*4, CMB_PIRATE_WEAPONS, 11, 2, ghost->WeaponDamage);
								SSGhost_Waitframe(this, ghost);
							}
							for(i=0; i<9; ++i){
								QuickSword(EW_PHYSICAL, Ghost_X, Ghost_Y, DirAngle(Ghost_Dir)+90-i*20, 16, CMB_PIRATE_WEAPONS, 11, 2, ghost->WeaponDamage);
								SSGhost_Waitframe(this, ghost);
							}
							for(i=0; i<4; ++i){
								Ghost_Move(OppositeDir(Ghost_Dir), 2, 0);
								QuickSword(EW_PHYSICAL, Ghost_X, Ghost_Y, DirAngle(Ghost_Dir)-90, 16-i*4, CMB_PIRATE_WEAPONS, 11, 2, ghost->WeaponDamage);
								SSGhost_Waitframe(this, ghost);
							}
							Ghost_SetFlag(GHF_STUN);
							Ghost_Data = combo;
							
						}
					}
				}
			}
			SSGhost_Waitframe(this, ghost);
		}
	}
}

const int SFX_PIRANHASPLASH = 85;

ffc script Piranha{
	void run(int enemyid){
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		int combo = ghost->Attributes[10];
		Ghost_Transform(this, ghost, -1, -1, 2, 2);
		Ghost_SetHitOffsets(ghost, 8, 8, 8, 8);
		Ghost_SetFlag(GHF_4WAY);
		Ghost_SetFlag(GHF_WATER_ONLY);
		Ghost_SetFlag(GHF_FAKE_Z);
		int defs[28];
		Ghost_StoreDefenses(ghost, defs);
		Ghost_SetAllDefenses(ghost, NPCDT_IGNORE);
		
		int moveDir = Rand(8);
		int moveTime = 24;
		int aggroTime;
		int hopcooldown;
		Ghost_Dir = Rand(4);
		Ghost_Dir = Dir8ToDir4(moveDir, Ghost_Dir);
		G[G_GHOSTSPECIALWALKSTYLE] = GST_SAWTOOTH;
		// for(int x=0; x<256; x+=8){
			// for(int y=0; y<176; y+=8){
				// if(Ghost_CanMovePixel(x, y))
					// Screen->PutPixel(6, x, y, 0x50, 0, 0, 0, 128);
			// }
		// }
		mapdata l1 = Game->LoadTempScreen(1);
		while(true){
			if(moveTime){
				--moveTime;
				if(aggroTime)
					Ghost_MoveAtAngle(DirAngle(moveDir), ghost->Step/50, 0);
				else
					Ghost_Move(moveDir, ghost->Step/100, 0);
				if(!Ghost_CanMove8(moveDir, 1, 0, false)){
					moveTime = 0;
				}
			}
			else{
				if(aggroTime){
					moveDir = AngleDir8(Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y));
					moveTime = 8;
				}
				else{
					moveDir = Rand(8);
					moveTime = 24;
				}
				if(!Ghost_CanMove8(moveDir, 1, 0, true))
					moveDir = Rand(8);
				Ghost_Dir = Dir8ToDir4(moveDir, Ghost_Dir);
			}
			if(GLW[GL_TORRINHOOK]->isValid()){
				if(Collision(ghost, GLW[GL_TORRINHOOK])){
					ghost->CollDetection = false;
					Ghost_UnsetFlag(GHF_WATER_ONLY);
					Ghost_SetFlag(GHF_IGNORE_WATER);
					G[G_GHOSTSPECIALWALKSTYLE] = GST_NONE;
					moveDir = AngleDir8(Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y));
					Ghost_Dir = Dir8ToDir4(moveDir, Ghost_Dir);
					Game->PlaySound(SFX_PIRANHASPLASH);
					Game->PlaySound(SFX_JUMP);
					Ghost_Jump = 2.8;
					Ghost_SetDefenses(ghost, defs);
					while(Ghost_Z>0||Ghost_Jump>0){
						Ghost_MoveAtAngle(DirAngle(moveDir), ghost->Step/50, 0);
						if(Ghost_Jump>2)
							Ghost_Data = combo+4;
						else if(Ghost_Jump>1)
							Ghost_Data = combo+8;
						else
							Ghost_Data = combo+12;
						
						SSGhost_Waitframe(this, ghost);
					}
					int pos = ComboAt(this->X+8, this->Y+8);
					int ct = Screen->ComboT[pos];
					if((ct!=CT_WATER&&ct!=CT_SHALLOWWATER)||isShorelineCombo(Screen->ComboD[pos], false)||isShorelineCombo(l1->ComboD[pos], false)){
						Ghost_Data = combo+16;
						ghost->CollDetection = true;
						while(true){
							Game->PlaySound(SFX_SPLASH);
							Game->PlaySound(SFX_JUMP);
							Ghost_Jump = 1.6;
							Ghost_SetDefenses(ghost, defs);
							while(Ghost_Z>0||Ghost_Jump>0){
								ghost->Stun = 10;
								SSGhost_Waitframe(this, ghost);
							}
							Ghost_Dir = Rand(4);
						}
					}
					Ghost_X = ComboX(pos)-8;
					Ghost_Y = ComboY(pos)-8;
					ghost->CollDetection = true;
					Ghost_SetFlag(GHF_WATER_ONLY);
					Ghost_UnsetFlag(GHF_IGNORE_WATER);
					G[G_GHOSTSPECIALWALKSTYLE] = GST_SAWTOOTH;
					Ghost_Data = combo;
					Game->PlaySound(SFX_PIRANHASPLASH);
					Ghost_SetAllDefenses(ghost, NPCDT_IGNORE);
				}
			}
			if(Abs(Link->X+8-Ghost_X)<24&&Abs(Link->Y+8-Ghost_Y)<24&&!hopcooldown&&(Link->Action==LA_SWIMMING||Link->Action==LA_DIVING||(aggroTime>0&&Screen->ComboT[ComboAt(Link->X+8, Link->Y+15)]==CT_SHALLOWWATER))){
				ghost->CollDetection = true;
				moveDir = AngleDir8(Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y));
				Ghost_Dir = Dir8ToDir4(moveDir, Ghost_Dir);
				Game->PlaySound(SFX_PIRANHASPLASH);
				Game->PlaySound(SFX_JUMP);
				Ghost_Jump = 2.8;
				Ghost_SetDefenses(ghost, defs);
				while(Ghost_Z>0||Ghost_Jump>0){
					Ghost_MoveAtAngle(DirAngle(moveDir), ghost->Step/50, 0);
					if(Ghost_Jump>2)
						Ghost_Data = combo+4;
					else if(Ghost_Jump>1)
						Ghost_Data = combo+8;
					else
						Ghost_Data = combo+12;
					SSGhost_Waitframe(this, ghost);
				}
				Ghost_Data = combo;
				Game->PlaySound(SFX_PIRANHASPLASH);
				Ghost_SetAllDefenses(ghost, NPCDT_IGNORE);
				aggroTime = Max(aggroTime-60, 0);
				hopcooldown = 60;
			}
			if(Link->Action==LA_SWIMMING||Link->Action==LA_DIVING)
				aggroTime = 300;
			if(aggroTime)
				--aggroTime;
			if(hopcooldown)
				--hopcooldown;
			Ghost_Data = combo;
			SSGhost_Waitframe(this, ghost);
		}
	}
}

ffc script HardhatBeetle{
	void run(int enemyid){
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		int combo = ghost->Attributes[10];
		
		int hitangle;
		int hitframes;
		int stunframes;
		while(true){
			Ghost_Data = combo;
			if(hitframes){
				Ghost_MoveAtAngle(hitangle, 2, 0);
				--hitframes;
			}
			else{
				for(int i=Screen->NumLWeapons(); i>0; --i){
					lweapon l = Screen->LoadLWeapon(i);
					if((l->ID==LW_SWORD||l->Weapon==LW_SWORD)&&Collision(ghost, l)){
						hitangle = Angle(Link->X, Link->Y, Ghost_X, Ghost_Y);
						hitframes = 12;
						stunframes = 49;
					}
				}
			}
			if(stunframes){
				Ghost_Data = combo+1;
				--stunframes;
				Ghost_SetFlag(GHF_IGNORE_NO_ENEMY);
				Ghost_SetFlag(GHF_IGNORE_PITS);
				if(stunframes==0){
					Ghost_UnsetFlag(GHF_IGNORE_NO_ENEMY);
					Ghost_UnsetFlag(GHF_IGNORE_PITS);
				}
			}
			if(!stunframes)
				Ghost_MoveTowardLink(0.3, 0);
			Ghost_Pitfall(this, ghost);
			SSGhost_Waitframe(this, ghost);
		}
	}
}

ffc script Cursetellation{
	void run(int enemyid){
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		Ghost_SetFlag(GHF_IGNORE_ALL_TERRAIN);
		Ghost_SetFlag(GHF_IGNORE_NO_ENEMY);
		Ghost_SetFlag(GHF_FAKE_Z);
		int element = ghost->Attributes[0];
		int combo = ghost->Attributes[10];
		int moveTime;
		int moveAngle;
		int turnTime;
		int turnFrame;
		int turnDir = Choose(-1, 1);
		int shotTimer = 120;
		while(true){
			if(ghost->Misc[NPCM_SITSTILLYOULITTLEFUCK]==2){
				npc Horizon = Screen->LoadNPC(1);
				int angle = Angle(Horizon->X, Horizon->Y, Ghost_X, Ghost_Y);
				turnTime = 300;
				turnDir = Choose(-1, 1);
				Ghost_SetFlag(GHF_IGNORE_NO_ENEMY);
				Ghost_SetFlag(GHF_FLYING_ENEMY);
				Ghost_SetFlag(GHF_MOVE_OFFSCREEN);
				while(Ghost_X>-16&&Ghost_X<256&&Ghost_Y>-32&&Ghost_Y<176+16){
					if(turnTime){
						if(turnTime%2==0){
							turnFrame += turnDir;
							if(turnFrame<0)
								turnFrame += 12;
							else if(turnFrame>11)
								turnFrame -= 12;
						}
						--turnTime;
					}
					
					Ghost_MoveAtAngle(angle, 2, 0);
					
					Ghost_Data = combo+turnFrame;
					Ghost_Jump = 0;
					Ghost_Z = 8+4*Sin(G[G_ANIM]*2);
					SSGhost_Waitframe(this, ghost);
				}
				ghost->HP = -1000;
				ghost->ItemSet = 0;
				this->Data = 0;
				Quit();
			}
			
			if(shotTimer)
				--shotTimer;
			if(moveTime>0){
				Ghost_MoveAtAngle(moveAngle, ghost->Step/100, 0);
				--moveTime;
			}
			else{
				int dist = Distance(Ghost_X, Ghost_Y, Link->X, Link->Y);
				if((dist<ghost->Homing||Ghost_GotHit()||Rand(512)==0)&&!moveTime && !ghost->Misc[NPCM_SITSTILLYOULITTLEFUCK]){
					moveTime = 24;
					if(Abs(Ghost_X-120)>112||Abs(Ghost_Y-80)>64){
						moveAngle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y)+Choose(-45, 45);
						if(element==2)
							moveAngle = WrapDegrees(Rand(360));
					}
					else{
						moveAngle = Angle(Link->X, Link->Y, Ghost_X, Ghost_Y)+Choose(-45, 45);
						if(element==2)
							moveAngle = WrapDegrees(Rand(360));
					}
					turnDir = Choose(-1, 1);
					turnFrame = 0;
					turnTime = 24;
					Game->PlaySound(60);
					if(element==2&&!shotTimer){
						eweapon e = FireAimedEWeapon(EW_STELLAR, Ghost_X, Ghost_Y, 0, 50, ghost->WeaponDamage, 0, SFX_WAND, 0);
						e->CSet = 10;
						e->Tile = 65015;
						e->OriginalTile = 65015;
						e->Rotation = RadtoDeg(e->Angle);
						RunEWeaponScript(e, "StellarAccelerator", {16, 200, 16, 400});
						shotTimer = 180;
					}
				}
				else if(dist>80 && !ghost->Misc[NPCM_SITSTILLYOULITTLEFUCK]){
					Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y), 0.5, 0);
				}
			}
			if(turnTime){
				if(turnTime%2==0){
					turnFrame += turnDir;
					if(turnFrame<0)
						turnFrame += 12;
					else if(turnFrame>11)
						turnFrame -= 12;
				}
				--turnTime;
			}
			Ghost_Data = combo+turnFrame;
			Ghost_Jump = 0;
			Ghost_Z = 8+4*Sin(G[G_ANIM]*2);
 
			if(GLW[GL_MAGNETHITBOX]->isValid()&&Collision(GLW[GL_MAGNETHITBOX], ghost)){
				bool doPull;
				if(element==0&&GLW[GL_MAGNETHITBOX]->Damage==STATE_TIDALGAUNTLET_MOON)
					doPull = true;
				else if(element==1&&GLW[GL_MAGNETHITBOX]->Damage==STATE_TIDALGAUNTLET_SUN)
					doPull = true;
				while(GLW[GL_MAGNETHITBOX]->isValid()&&Collision(GLW[GL_MAGNETHITBOX], ghost)){
					doPull = false;
					if(element==0&&GLW[GL_MAGNETHITBOX]->Damage==STATE_TIDALGAUNTLET_MOON)
						doPull = true;
					else if(element==1&&GLW[GL_MAGNETHITBOX]->Damage==STATE_TIDALGAUNTLET_SUN)
						doPull = true;
					if(doPull)
						Ghost_MoveXY(-DirX(GLW[GL_MAGNETHITBOX]->Dir, 0.5*MagnetModifier()), -DirY(GLW[GL_MAGNETHITBOX]->Dir, 0.5*MagnetModifier()), 0);
					else
						Ghost_MoveXY(DirX(GLW[GL_MAGNETHITBOX]->Dir, 0.5*MagnetModifier()), DirY(GLW[GL_MAGNETHITBOX]->Dir, 0.5*MagnetModifier()), 0);
					if(turnTime){
						if(turnTime%2==0){
							turnFrame += turnDir;
							if(turnFrame<0)
								turnFrame += 12;
							else if(turnFrame>11)
								turnFrame -= 12;
						}
						--turnTime;
					}
					else{
						turnFrame = 0;
						turnTime = 24;
					}
					Ghost_Data = combo+turnFrame;
					Ghost_Jump = 0;
					Ghost_Z = 8+4*Sin(G[G_ANIM]*2);
					SSGhost_Waitframe(this, ghost);
				}
			}
			SSGhost_Waitframe(this, ghost);
		}
	}
}

ffc script CrossCannon{
	void run(int enemyid){
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		int fireState = ghost->Attributes[0];
		int fireDelay = ghost->Attributes[1];
		int combo = ghost->Attributes[10];
		Ghost_Transform(this, ghost, -1, -1, 2, 2);
		Ghost_SetHitOffsets(ghost, 8, 8, 8, 8);
		SetOverUnderLayer(ghost);
		while(true){
			Ghost_Data = combo;
			SSGhost_Waitframes(this, ghost, fireDelay);
			if(Ghost_OnLinkLayer()){
				if(fireState==0){
					Ghost_Data = combo+1;
					SSGhost_Waitframes(this, ghost, 8);
					for(int i=0; i<2; ++i){
						int angle = -90+180*i;
						eweapon e = FireEWeapon(EW_PHYSICAL, Ghost_X+8+VectorX(8, angle), Ghost_Y+8+VectorY(8, angle), DegtoRad(angle), 400, ghost->WeaponDamage, 0, SFX_PIRATE_BULLET, 0);
						e->HitXOffset = 4;
						e->HitYOffset = 4;
						e->HitWidth = 8;
						e->HitHeight = 8;
						e->OriginalTile = TIL_PIRATE_BULLET+1;
						e->Tile = e->OriginalTile;
						e->CSet = 11;
					}
					SSGhost_Waitframes(this, ghost, 8);
					fireState = 1;
				}
				else{
					Ghost_Data = combo+2;
					SSGhost_Waitframes(this, ghost, 8);
					for(int i=0; i<2; ++i){
						int angle = 180*i;
						eweapon e = FireEWeapon(EW_PHYSICAL, Ghost_X+8+VectorX(8, angle), Ghost_Y+8+VectorY(8, angle), DegtoRad(angle), 400, ghost->WeaponDamage, 0, SFX_PIRATE_BULLET, 0);
						e->HitXOffset = 4;
						e->HitYOffset = 4;
						e->HitWidth = 8;
						e->HitHeight = 8;
						e->OriginalTile = TIL_PIRATE_BULLET+1;
						e->Tile = e->OriginalTile;
						e->CSet = 11;
					}
					SSGhost_Waitframes(this, ghost, 8);
					fireState = 0;
				}
			}
		}
	}
}

ffc script WallChaser{
	void run(int enemyid){
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		int clockwise = ghost->Attributes[0];
		Ghost_SetFlag(GHF_FLYING_ENEMY);
		Ghost_SetFlag(GHF_IGNORE_WATER);
		int dir;
		if(!Ghost_CanMove(DIR_UP, 1, 0))
			dir = DIR_UP;
		else if(!Ghost_CanMove(DIR_DOWN, 1, 0))
			dir = DIR_DOWN;
		else if(!Ghost_CanMove(DIR_LEFT, 1, 0))
			dir = DIR_LEFT;
		else if(!Ghost_CanMove(DIR_RIGHT, 1, 0))
			dir = DIR_RIGHT;
		for(int i=0; i<4; ++i){
			if(Screen->ComboF[ComboAt(Ghost_X+DirX(i, 16)+8, Ghost_Y+DirY(i, 16)+8)]==8){
				dir = i;
				break;
			}
		}
		int adjacentdir = dir;
		int step = ghost->Step/100;
		int substep;
		while(true){
			substep += step;
			if(substep>=1){
				int stepframes = Floor(substep);
				for(int i=0; i<stepframes; ++i){
					int oldX = Ghost_X;
					int oldY = Ghost_Y;
					if(Ghost_CanMove(adjacentdir, 1, 0)){
						Ghost_Move(adjacentdir, 1, 0);
						if(clockwise){
							if(!Ghost_CanMove(OppositeDir(dir), 1, 0)){
								adjacentdir = OppositeDir(dir);
								dir = DirCW(dir);
							}
						}
						else{
							if(!Ghost_CanMove(OppositeDir(dir), 1, 0)){
								adjacentdir = OppositeDir(dir);
								dir = DirCCW(dir);
							}
						}
					}
					else if(!Ghost_CanMove(dir, 1, 0)){
						if(clockwise){
							adjacentdir = dir;
							dir = DirCCW(dir);
						}
						else{
							adjacentdir = dir;
							dir = DirCW(dir);
						}
					}
					
					Ghost_X = oldX;
					Ghost_Y = oldY;
					Ghost_Move(dir, 1, 0);
				}
				substep -= stepframes;
			}
			// Screen->DrawInteger(6, Ghost_X, Ghost_Y, FONT_Z3SMALL, 0x01, 0x0F, -1, -1, dir, 0, 128);
			// Screen->DrawInteger(6, Ghost_X, Ghost_Y+8, FONT_Z3SMALL, 0x01, 0x0F, -1, -1, adjacentdir, 0, 128);
			IgnoreLinkZ(ghost);
			SSGhost_Waitframe(this, ghost);
		}
	}
}

bool DrawSolarLaserEW(bitmap laserbitmap, int x, int y, int angle, int width, int damage, int palshift){
	angle = WrapDegrees(angle);
	int laserAFrame = G[G_ANIM]%8;
	int startX = x;
	int startY = y;
	int dist = 24;
	bool hitLink;
	for(int i=24; i<256; i+=8){
		dist += 8;
		x += VectorX(8, angle);
		y += VectorY(8, angle);
		if(IsSolidNoPit(x, y)){
			break;
		}
		if(RectCollision(x-5, y-5, x+6, y+6, Link->X+4, Link->Y+4, Link->X+11, Link->Y+11)){
			dist = Distance(startX, startY, Link->X+8, Link->Y+8);
			hitLink = true;
			break;
		}
	}
	if(!hitLink){
		dist -= 8;
		x -= VectorX(8, angle);
		y -= VectorY(8, angle);
		for(int i=0; i<8; ++i){
			++dist;
			x += VectorX(1, angle);
			y += VectorY(1, angle);
			if(IsSolidNoPit(x, y)){
				break;
			}
		}
	}
	if(!hitLink)
		dist = Distance(startX, startY, x, y);
	else{
		MakeHitbox(EW_SOLAR, startX-8+VectorX(dist-4, angle), startY-8+VectorY(dist-4, angle), 16, 16, damage);
	}
	dist += 16;
	laserbitmap->Clear(0);
	laserbitmap->FastTile(0, 0, 8, TIL_KAYLANILASER+20+laserAFrame, 8, 128);
	for(int i=0; i<Ceiling(dist/16)-1; ++i){
		laserbitmap->FastTile(0, 16+i*16, 8, TIL_KAYLANILASER+laserAFrame, 8, 128);
	}
	laserbitmap->Rectangle(0, dist-2, 0, 255, 31, 0x00, 1, 0, 0, 0, true, 128);
	laserbitmap->DrawTile(0, dist-16, 0, TIL_KAYLANILASER+40+Floor((G[G_ANIM]%12)/3), 1, 2, 8, -1, -1, 0, 0, 0, 0, true, 128);
	if(palshift==1){
		laserbitmap->ReplaceColors(0, 0x81, 0x88, 0x86);
		laserbitmap->ReplaceColors(0, 0x86, 0x87, 0x87);
		laserbitmap->ReplaceColors(0, 0x87, 0x88, 0x88);
	}
	else if(palshift==2){
		laserbitmap->ReplaceColors(0, 0x81, 0x86, 0x87);
		laserbitmap->ReplaceColors(0, 0x86, 0x88, 0x88);
	}
	laserbitmap->Blit(4, RT_SCREEN, 0, 0, 256, 32, startX-128+VectorX(128, angle)+VectorX(16-(width/2), angle+90), startY-16+VectorY(128, angle)+VectorY(16-(width/2), angle+90), 256, width, angle, 0, 0, BITDX_NORMAL, 0, true);
	return hitLink;
}
	
ffc script ElementalPillar{
	void run(int enemyid){
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		Ghost_Transform(this, ghost, -1, -1, 2, 3);
		Ghost_SetHitOffsets(ghost, 8, 0, 4, 4);
		int type = ghost->Attributes[0];
		int combo = ghost->Attributes[10];
		int c = 0x86;
		if(type==1)
			c = 0x72;
		else if(type==2)
			c = 0x96;
		int bitid = TempBitmap_Create(0, 256, 32);
		bitmap laserbitmap = TempBMP[bitid];
		int sfxTimer[1];
		Ghost_Y -= 8;
		SetOverUnderLayer(ghost);
		while(true){
			Ghost_Data = combo;
			while(!Ghost_OnLinkLayer()){
				SSGhost_Waitframe(this, ghost);
			}
			SSGhost_Waitframes(this, ghost, 120);
			if(Ghost_OnLinkLayer()){
				Game->PlaySound(SFX_CHARGE1);
				for(int i=0; i<120&&Ghost_OnLinkLayer(); ++i){
					Screen->Circle(6, Ghost_X+16, Ghost_Y+8, ((30-(i%30))/30)*32, c+Rand(3), 1, 0, 0, 0, false, 128);
					SSGhost_Waitframe(this, ghost);
				}
				if(!Ghost_OnLinkLayer())
					continue;
				Ghost_Data = combo+1;
				if(type==0){
					int laserAngle = Angle(Ghost_X+16, Ghost_Y+8, Link->X+8, Link->Y+8)+Choose(-40, 40);
					bool collidedLink;
					int laserWidth = 4;
					int level;
					for(int i=0; i<256; ++i){
						if(i<64)
							level = 0;
						else if(i<128)
							level = 1;
						else if(i<192)
							level = 2;
						LoopingSFX(sfxTimer, 6, SFX_LASERBEAM);
						laserWidth = Min(laserWidth+0.5, 32);
						laserAngle = TurnToAngle(WrapDegrees(laserAngle), Angle(Ghost_X+16, Ghost_Y+8, Link->X+8, Link->Y+8), 0.8);
						if(collidedLink)
							laserAngle = Angle(Ghost_X+16, Ghost_Y+8, Link->X+8, Link->Y+8);
						int palshift;
						if(level==2){
							palshift = Floor(G[G_ANIM]/4)%4;
						}
						collidedLink = DrawSolarLaserEW(laserbitmap, Ghost_X+16, Ghost_Y+8, laserAngle, laserWidth, 4, palshift);
						SSGhost_Waitframe(this, ghost);
					}
					while(laserWidth>4){
						LoopingSFX(sfxTimer, 6, SFX_LASERBEAM);
						laserWidth = Max(laserWidth-1, 4);
						laserAngle = TurnToAngle(WrapDegrees(laserAngle), Angle(Ghost_X+16, Ghost_Y+8, Link->X+8, Link->Y+8), 1);
						if(collidedLink)
							laserAngle = Angle(Ghost_X+16, Ghost_Y+8, Link->X+8, Link->Y+8);
						collidedLink = DrawSolarLaserEW(laserbitmap, Ghost_X+16, Ghost_Y+8, laserAngle, laserWidth, 4, 0);
						SSGhost_Waitframe(this, ghost);
					}
				}
				else if(type==1){
					for(int i=0; i<36; ++i){
						eweapon e = FireEWeapon(EW_LUNAR, Ghost_X+8, Ghost_Y, DegtoRad(i*10), 0, ghost->WeaponDamage, SPR_LUNARPHASECUTTER, SFX_WAND, 0);
						RunEWeaponScript(e, "LunarPhaseCutter", {25, 50, 6});
					}
					SSGhost_Waitframes(this, ghost, 60);
				}
				else if(type==2){
					for(int i=0; i<12; ++i){
						eweapon e = FireEWeapon(EW_STELLAR, Rand(8, 232), Rand(8, 152), DegtoRad(i*10), 0, ghost->WeaponDamage, 0, 0, 0);
						if(i%4==0){
							e->X = Link->X;
							e->Y = Link->Y;
						}
						RunEWeaponScript(e, "Meteorite", {0});
						e->CollDetection = false;
						e->DrawYOffset = -1000;
						SSGhost_Waitframes(this, ghost, 16);
					}
				}
			}
		}
	}
}

const int SPR_COSMICSPOOKSPLIT = 100;

ffc script CosmicSpook{
	void run(int enemyid){
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		Ghost_SetFlag(GHF_4WAY);
		Ghost_SetFlag(GHF_KNOCKBACK);
		
		int combo = ghost->Attributes[10];
		int counter = -1;
		Ghost_Transform(this, ghost, -1, -1, 1, 2);
		Ghost_SetHitOffsets(ghost, 0, 16, 0, 0);
		ghost->DrawYOffset = -1000;
		
		int bitid = TempBitmap_Create(0, 32, 32);
		bitmap spr = TempBMP[bitid];
		
		int offsets[3];
		int vars[16] = {offsets};
		int splitcooldown = 120;
		SetOverUnderLayer(ghost);
		while(true){
			if(Ghost_OnLinkLayer()){
				if(splitcooldown>0)
					--splitcooldown;
				else if(Rand(180)==0){
					if(Ghost_CanPlace(Link->X, Link->Y, 16, 16)){
						int targetX = Link->X;
						int targetY = Link->Y;
						Game->PlaySound(10);
						eweapon split[32];
						int splitOffX[32];
						int splitOffY[32];
						int splitX[32];
						int splitY[32];
						int splitAng[32];
						int splitStep[32];
						ghost->CollDetection = false;
						for(int i=0; i<32; ++i){
							splitOffX[i] = Rand(-8, 8);
							splitOffY[i] = Rand(-8, 24);
							splitX[i] = Ghost_X+splitOffX[i];
							splitY[i] = Ghost_Y-16+splitOffY[i];
							splitAng[i] = Angle(0, 0, (splitX[i]-Ghost_X)*2, (splitY[i]-Ghost_Y));
							splitStep[i] = Rand(150, 350)/100;
							split[i] = FireEWeapon(EW_COSMIC, splitX[i], splitY[i], DegtoRad(splitAng[i]), 0, ghost->Damage, SPR_COSMICSPOOKSPLIT, 0, EWF_UNBLOCKABLE);
							split[i]->OriginalTile += 3;
							split[i]->Tile = split[i]->OriginalTile;
							split[i]->Rotation = splitAng[i];
							ResizeHitbox(split[i], 6, 6, 4, 4);
						}
						for(int j=0; j<16; ++j){
							for(int i=0; i<32; ++i){
								splitX[i] += VectorX(splitStep[i], splitAng[i]);
								splitY[i] += VectorY(splitStep[i], splitAng[i]);
								if(split[i]->isValid()){
									split[i]->X = splitX[i];
									split[i]->Y = splitY[i];
								}
								else{
									split[i] = FireEWeapon(EW_COSMIC, splitX[i], splitY[i], DegtoRad(splitAng[i]), 0, ghost->Damage, SPR_COSMICSPOOKSPLIT, 0, EWF_UNBLOCKABLE);
									split[i]->OriginalTile += 3;
									split[i]->Tile = split[i]->OriginalTile;
									split[i]->Rotation = splitAng[i];
									ResizeHitbox(split[i], 6, 6, 4, 4);
								}
							}
							SSGhost_Waitframe(this, ghost);
						}
						for(int i=0; i<32; ++i){
							if(split[i]->isValid()){
								split[i]->UseSprite(SPR_COSMICSPOOKSPLIT);
								split[i]->Rotation = splitAng[i];
							}
						}
						for(int j=0; j<32; ++j){
							for(int i=0; i<32; ++i){
								if(split[i]->isValid()){
									split[i]->X = splitX[i];
									split[i]->Y = splitY[i];
								}
								else{
									split[i] = FireEWeapon(EW_COSMIC, splitX[i], splitY[i], DegtoRad(splitAng[i]), 0, ghost->Damage, SPR_COSMICSPOOKSPLIT, 0, EWF_UNBLOCKABLE);
									split[i]->Rotation = splitAng[i];
									ResizeHitbox(split[i], 6, 6, 4, 4);
								}
							}
							SSGhost_Waitframe(this, ghost);
						}
						for(int i=0; i<32; ++i){
							splitAng[i] = Angle(splitX[i], splitY[i], targetX+splitOffX[i], targetY+splitOffY[i]-16);
							splitStep[i] = Distance(splitX[i], splitY[i], targetX+splitOffX[i], targetY+splitOffY[i]-16)/16;
							if(split[i]->isValid()){
								split[i]->UseSprite(SPR_COSMICSPOOKSPLIT);
								split[i]->OriginalTile += 3;
								split[i]->Tile = split[i]->OriginalTile;
								split[i]->Rotation = splitAng[i];
							}
						}
						Game->PlaySound(93);
						for(int j=0; j<16; ++j){
							for(int i=0; i<32; ++i){
								splitX[i] += VectorX(splitStep[i], splitAng[i]);
								splitY[i] += VectorY(splitStep[i], splitAng[i]);
								if(split[i]->isValid()){
									split[i]->X = splitX[i];
									split[i]->Y = splitY[i];
								}
								else{
									split[i] = FireEWeapon(EW_COSMIC, splitX[i], splitY[i], DegtoRad(splitAng[i]), 0, ghost->Damage, SPR_COSMICSPOOKSPLIT, 0, EWF_UNBLOCKABLE);
									split[i]->OriginalTile += 3;
									split[i]->Tile = split[i]->OriginalTile;
									split[i]->Rotation = splitAng[i];
									ResizeHitbox(split[i], 6, 6, 4, 4);
								}
							}
							SSGhost_Waitframe(this, ghost);
						}
						Game->PlaySound(92);
						for(int i=0; i<32; ++i){
							if(split[i]->isValid()){
								split[i]->UseSprite(SPR_COSMICSPOOKSPLIT);
								split[i]->DeadState = 2;
							}
						}
						Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, targetX, targetY));
						counter = -1;
						Ghost_X = targetX;
						Ghost_Y = targetY;
						ghost->CollDetection = true;
						splitcooldown = 120;
					}
				}
			}
			counter = Ghost_ConstantWalk4(counter, ghost->Step, ghost->Rate, ghost->Homing, ghost->Hunger);
			CS_Waitframe(this, ghost, spr, vars, 1);
		}
	}
	void DrawCosmicSpook(bitmap b, int layer, int x, int y, int cmb, int cset, int shift, int offsets){
		b->Clear(0);
		combodata cd = Game->LoadComboData(cmb+Ghost_Dir);
		int til = cd->Tile;
		int flip = cd->Flip;
		b->DrawTile(0, 0, 0, til+40, 1, 2, cset, -1, -1, 0, 0, 0, flip, true, 128);
		b->DrawTile(0, 16, 0, til+80, 1, 2, cset, -1, -1, 0, 0, 0, flip, true, 128);
		if(shift==1){
			b->ReplaceColors(0, 0x71, 0x76, 0x76);
			b->ShiftColors(0, -1, 0x77, 0x79);
		}
		else if(shift==2){
			b->ReplaceColors(0, 0x71, 0x76, 0x77);
			b->ShiftColors(0, -2, 0x78, 0x79);
		}
		b->Blit(layer, RT_SCREEN, 0, 0, 16, 32, x+offsets[0], y, 16, 32, 0, 0, 0, 0, 0, true);
		b->Blit(layer, RT_SCREEN, 16, 0, 16, 32, x+offsets[1], y, 16, 32, 0, 0, 0, 0, 0, true);
	}
	void CS_Waitframe(ffc this, npc ghost, bitmap spr, int vars, int frames){
		int offsets = vars[0];
		for(int i=0; i<frames; ++i){
			int layer = 2;
			if(!Ghost_OnLinkLayer()){
				if(G[G_GHOSTWALKLAYER]==1){
					layer = 1;
				}
				else{
					layer = 4;
				}
			}
					
			if(G[G_ANIM]%3==0){
				offsets[0] = Rand(-1, 1);
				offsets[1] = Rand(-1, 1);
			}
			if(G[G_ANIM]%2==0){
				offsets[2] = Rand(3);
			}
			if(SSGhost_Waitframe(this, ghost, true, false)){
				DrawCosmicSpook(spr, layer, Ghost_X, Ghost_Y-16-2, Ghost_Data, Ghost_CSet, offsets[2], offsets);
			}
			else{
				ghost->DrawYOffset = -2;
				ghost->Tile = GH_BLANK_TILE;
				Quit();
			}
		}
	}
}

ffc script ArmosNut{
	void run(int enemyid, int detectDist, int type, int HeadX, int HeadY, int layer){
		this->Flags[FFCF_ETHEREAL] = true;
		int cmb = this->Data;
		int pos = ComboAt(this->X+8, this->Y+8);
		mapdata l1 = Game->LoadTempScreen(1);
		mapdata l2 = Game->LoadTempScreen(2);
		mapdata l4 = Game->LoadTempScreen(4);
		mapdata lwhatever = {l1, l2};
		l2->ComboD[pos+16] = this->Data+1;
		l2->ComboC[pos+16] = this->CSet;
		l4->ComboD[pos] = this->Data;
		l4->ComboC[pos] = this->CSet;
		this->Data = 1;
		Waitframe();
		while(Abs(this->X-Link->X)>detectDist||Abs(this->Y+16-Link->Y)>detectDist){
			Waitframe();
		}
		l2->ComboD[pos+16] = 1;
		l4->ComboD[pos] = 0;
		for(int i=0; i<48; ++i){
			int x = this->X;
			if(i%4<2){
				--x;
			}
			else{
				++x;
			}
			Screen->FastCombo(4, x, this->Y, cmb, this->CSet, 128);
			Screen->FastCombo(4, x, this->Y+16, cmb+1, this->CSet, 128);
			Waitframe();
		}
		l2->ComboD[pos+16] = 0;
		if(type == 1){
			npc n = CreateNPCAt(229, this->X, this->Y+3);
		}
		if(type == 2){
			npc n = CreateNPCAt(229, HeadX, HeadY);
			// lwhatever[layer-1]->ComboD[ComboAt(HeadX, HeadY)] = 0;
			l1->ComboD[ComboAt(HeadX, HeadY)] = 0;
		}
		npc ghost = Ghost_InitCreate(this, enemyid);
		Ghost_Y += 16;
		ghost->OriginalTile = GH_BLANK_TILE;
		ghost->Tile = GH_BLANK_TILE;
		Ghost_SetFlag(GHF_4WAY);
		Ghost_SetFlag(GHF_STUN);
		Ghost_Transform(this, ghost, cmb+4, this->CSet, 1, 2);
		Ghost_SetHitOffsets(ghost, 0, 16, 0, 0);
		ghost->DrawYOffset -= 16;
		int counter = -1;
		Ghost_Dir = DIR_DOWN;
		SetOverUnderLayer(ghost);
		while(true){
			counter = Ghost_ConstantWalk4(counter, ghost->Step, ghost->Rate, ghost->Homing, ghost->Hunger);
			if(Game->GetCurDMap() == 55){
				Screen->FastCombo(5, this->X, this->Y, cmb+4+Ghost_Dir, this->CSet, OP_OPAQUE);
			}
			SSGhost_Waitframe(this, ghost);
		}
	}
}

ffc script SolarGolemMiniboss{
	const int LINKANGLE = 0;
	const int STRAFEDEGREES = 1;
	
	void run(int enemyid){
		int i; int j; int k;
		int x; int y;
		int angle;
		eweapon e;
		
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		ghost->Immortal = true;
		int defenses[28];
		Ghost_StoreDefenses(ghost, defenses);
		Ghost_SetAllDefenses(ghost, NPCDT_BLOCK);
		Ghost_Transform(this, ghost, 51484, 8, 2, 2);
		Ghost_SetHitOffsets(ghost, 2, 0, 6, 6);
		while(Distance(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y)>48){
			SSGhost_Waitframe(this, ghost);
		}
		for(i=0; i<32; ++i){
			if(i%2==0){
				Ghost_X += (i%4<2)?-1:1;
			}
			SSGhost_Waitframe(this, ghost);
		}
		Ghost_Data = 51485;
		SSGhost_Waitframes(this, ghost, 16);
		Ghost_Data = 51486;
		SSGhost_Waitframes(this, ghost, 8);
		Game->PlaySound(86);
		for(i=0; i<16; ++i){
			DrawStarGlint(4, Ghost_X+16, Ghost_Y+8, -90+(i/16)*90, 8+i/2, Choose(0x86, 0x87, 0x88));
			SSGhost_Waitframe(this, ghost);
		}
		Ghost_SetDefenses(ghost, defenses);
		Game->PlayEnhancedMusic("SS-Golem.ogg", 0);
		RunFFCScript(Game->GetFFCScript("HealthBar_Tiled_Single"), {ghost->ID, 10, 0, 1});
		int combo = ghost->Attributes[10];
		Ghost_SetFlag(GHF_4WAY);
		Ghost_Data = combo;
		Ghost_Dir = DIR_DOWN;
		int attack;
		int attackDelay;
		int phase;
		int initHP = Ghost_HP;
		int vars[16];
		int bitid = TempBitmap_Create(0, 256, 32);
		bitmap laserbitmap = TempBMP[bitid];
		int bitid2 = TempBitmap_Create(0, 256, 32);
		bitmap laserbitmap2 = TempBMP[bitid2];
		int sfxTimer[1];
		vars[LINKANGLE] = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y);
		vars[STRAFEDEGREES] = 0;
		while(true){
			Ghost_Data = combo;
			if(Ghost_HP<initHP*0.5)
				phase = 1;
			if(attackDelay)
				--attackDelay;
			else{
				if(phase==0){
					attack = Rand(2);
					if(Distance(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y)<48){
						attack = 2;
					}
					if(Abs(vars[STRAFEDEGREES])>=360){
						vars[STRAFEDEGREES] = 0;
						attack = 3;
					}
				}
				else{
					attack = Choose(4, 5);
					if(Distance(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y)>80&&Rand(2)==0){
						attack = 2;
					}
					if(Abs(vars[STRAFEDEGREES])>=360){
						vars[STRAFEDEGREES] = 0;
						attack = 3;
					}
				}
				
				if(attack==0){ //Angled Shots
					Ghost_Data = combo+4;
					angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y)+Rand(-70, 70);
					for(i=0; i<32; ++i){
						Ghost_FaceLink(ghost);
						Ghost_MoveAtAngle(angle, 1.5, 0);
						SGWaitframe(this, ghost, vars, 1);
					}
					Ghost_Data = combo+8;
					for(i=0; i<32; ++i){
						Ghost_FaceLink(ghost);
						SGWaitframe(this, ghost, vars, 1);
					}
					Ghost_Data = combo+12;
					for(i=0; i<48; ++i){
						Ghost_FaceLink(ghost);
						if(i%6==0){
							angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y);
							e = FireEWeapon(EW_SOLAR, Ghost_X+8+VectorX(16, angle), Ghost_Y+8+VectorY(16, angle), DegtoRad(angle), 300, ghost->WeaponDamage, SPR_LIGHTSHOT, SFX_LIGHTSHOT, EWF_UNBLOCKABLE);
							e->Rotation = angle;
						}
						SGWaitframe(this, ghost, vars, 1);
					}
					SGWaitframe(this, ghost, vars, 12);
					for(i=0; i<18; ++i){
						Ghost_FaceLink(ghost);
						if(i%6==0){
							angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y)+i/6*20;
							e = FireEWeapon(EW_SOLAR, Ghost_X+8+VectorX(16, angle), Ghost_Y+8+VectorY(16, angle), DegtoRad(angle), 300, ghost->WeaponDamage, SPR_LIGHTSHOT, SFX_LIGHTSHOT, EWF_UNBLOCKABLE);
							e->Rotation = angle;
							angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y)-i/6*20;
							e = FireEWeapon(EW_SOLAR, Ghost_X+8+VectorX(16, angle), Ghost_Y+8+VectorY(16, angle), DegtoRad(angle), 300, ghost->WeaponDamage, SPR_LIGHTSHOT, SFX_LIGHTSHOT, EWF_UNBLOCKABLE);
							e->Rotation = angle;
						}
						SGWaitframe(this, ghost, vars, 1);
					}
					attackDelay = 60;
				}
				else if(attack==1){ //Expanding wave
					Ghost_Data = combo+8;
					for(i=0; i<64; ++i){
						if(i<8)
							Ghost_MoveAtAngle(Angle(Link->X, Link->Y, Ghost_X+8, Ghost_Y+8), 1, 0);
						Ghost_FaceLink(ghost);
						SGCasting();
						SGWaitframe(this, ghost, vars, 1);
					}
					angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y);
					Ghost_Data = combo+12;
					j = Choose(-1, 1);
					for(i=0; i<5; ++i){
						k = angle-j*60+j*120*(i/4);
						e = FireEWeapon(EW_SOLAR, Ghost_X+8+VectorX(16, k), Ghost_Y+8+VectorY(16, k), DegtoRad(k), 0, ghost->WeaponDamage, 0, SFX_LIGHTSHOT, EWF_UNBLOCKABLE);
						e->CollDetection = false;
						RunEWeaponScript(e, "SolarBigShot", {0, 16, 0.15, 0.2, -j});
						SGWaitframe(this, ghost, vars, 16);
					}
					j = -j;
					for(i=0; i<5; ++i){
						k = angle-j*60+j*120*(i/4);
						e = FireEWeapon(EW_SOLAR, Ghost_X+8+VectorX(16, k), Ghost_Y+8+VectorY(16, k), DegtoRad(k), 0, ghost->WeaponDamage, 0, SFX_LIGHTSHOT, EWF_UNBLOCKABLE);
						e->CollDetection = false;
						RunEWeaponScript(e, "SolarBigShot", {0, 16, 0.15, 0.2, -j});
						SGWaitframe(this, ghost, vars, 16);
					}
					attackDelay = 90;
				}
				else if(attack==2){ //Sunball
					Ghost_Data = combo+16;
					SGWaitframe(this, ghost, vars, 16);
					Game->PlaySound(SFX_CHARGE1);
					for(i=0; i<64; ++i){
						Screen->Circle(4, Ghost_X+16, Ghost_Y+2, 12*(i/64), Choose(0x86, 0x87, 0x88), 1, 0, 0, 0, true, 128);
						SGWaitframe(this, ghost, vars, 1);
					}
					if(phase==0){
						Ghost_Data = combo+20;
						for(i=0; i<12; ++i){
							Screen->Circle(4, Ghost_X+16, Ghost_Y+2+28*(i/12), 12-i, Choose(0x86, 0x87, 0x88), 1, 0, 0, 0, true, 128);
							SGWaitframe(this, ghost, vars, 1);
						}
					}
					else{
						for(i=0; i<12; ++i){
							Screen->Circle(4, Ghost_X+16, Ghost_Y+2, 12-i, Choose(0x86, 0x87, 0x88), 1, 0, 0, 0, true, 128);
							SGWaitframe(this, ghost, vars, 1);
						}
						Ghost_Data = combo+4;
						angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y);
						Ghost_FaceLink(ghost);
						Game->PlaySound(SFX_JUMP);
						Ghost_Jump = 2.6;
						while(Ghost_Z>0||Ghost_Jump>0){
							Ghost_MoveAtAngle(angle, 1.6, 0);
							SGWaitframe(this, ghost, vars, 1);
						}
						Ghost_Data = combo;
						SGWaitframe(this, ghost, vars, 12);
						Ghost_Data = combo+16;
						for(i=0; i<12; ++i){
							Screen->Circle(4, Ghost_X+16, Ghost_Y+2, i, Choose(0x86, 0x87, 0x88), 1, 0, 0, 0, true, 128);
							SGWaitframe(this, ghost, vars, 1);
						}
						Ghost_Data = combo+20;
						for(i=0; i<12; ++i){
							Screen->Circle(4, Ghost_X+16, Ghost_Y+2+28*(i/12), 12-i, Choose(0x86, 0x87, 0x88), 1, 0, 0, 0, true, 128);
							SGWaitframe(this, ghost, vars, 1);
						}
					}
					Game->PlaySound(3);
					Game->PlaySound(78);
					for(i=0; i<80; i+=4){
						DamagingCircle(4, Ghost_X+16, Ghost_Y+30, i, Choose(0x81, 0x86, 0x87, 0x88), 128, LW_SOLAR, ghost->WeaponDamage*2);
						SGWaitframe(this, ghost, vars, 1);
					}
					for(i=0; i<12; ++i){
						if(i%4==0){
							for(j=0; j<6; ++j){
								angle = j*60+i/4*20;
								e = FireEWeapon(EW_SOLAR, Ghost_X+8+VectorX(16, angle), Ghost_Y+8+VectorY(16, angle), DegtoRad(angle), 300, ghost->WeaponDamage, SPR_LIGHTSHOT, SFX_LIGHTSHOT, EWF_UNBLOCKABLE);
								e->Rotation = angle;
							}
						}
						DamagingCircle(4, Ghost_X+16, Ghost_Y+30, 80, Choose(0x81, 0x86, 0x87, 0x88), 128, LW_SOLAR, ghost->WeaponDamage*2);
						SGWaitframe(this, ghost, vars, 1);
					}
					for(i=80; i>0; i-=8){
						DamagingCircle(4, Ghost_X+16, Ghost_Y+30, i, Choose(0x81, 0x86, 0x87, 0x88), 128, LW_SOLAR, ghost->WeaponDamage*2);
						SGWaitframe(this, ghost, vars, 1);
					}
					attackDelay = 60;
				}
				else if(attack==3){ //Laser clap
					angle = Angle(Ghost_X+8, Ghost_Y, Link->X, Link->Y);
					int sfxTimer[1];
					for(i=0; i<32; ++i){
						LoopingSFX(sfxTimer, 6, SFX_LASERBEAM);
						DrawSolarLaserEW(laserbitmap, Ghost_X+16, Ghost_Y+8, angle-90, 16*(i/32), ghost->WeaponDamage, 0);
						DrawSolarLaserEW(laserbitmap2, Ghost_X+16, Ghost_Y+8, angle+90, 16*(i/32), ghost->WeaponDamage, 0);
						SGWaitframe(this, ghost, vars, 1);
					}	
					for(i=0; i<32; ++i){
						LoopingSFX(sfxTimer, 6, SFX_LASERBEAM);
						j = 0;
						if(i>16)
							j = Floor(G[G_ANIM]/4)%4;
						DrawSolarLaserEW(laserbitmap, Ghost_X+16, Ghost_Y+8, angle-90+75*(i/32), 16, ghost->WeaponDamage, j);
						DrawSolarLaserEW(laserbitmap2, Ghost_X+16, Ghost_Y+8, angle+90-75*(i/32), 16, ghost->WeaponDamage, j);
						SGWaitframe(this, ghost, vars, 1);
					}
					for(i=0; i<16; ++i){
						LoopingSFX(sfxTimer, 6, SFX_LASERBEAM);
						j = 0;
						if(i>16)
							j = Floor(G[G_ANIM]/4)%4;
						DrawSolarLaserEW(laserbitmap, Ghost_X+16, Ghost_Y+8, angle-90+75, 16-16*(i/16), ghost->WeaponDamage, j);
						DrawSolarLaserEW(laserbitmap2, Ghost_X+16, Ghost_Y+8, angle+90-75, 16-16*(i/16), ghost->WeaponDamage, j);
						SGWaitframe(this, ghost, vars, 1);
					}	
				}
				else if(attack==4){ //Hopping Shotgun
					Game->PlaySound(SFX_JUMP);
					Ghost_Jump = 1.2;
					Ghost_Data = combo+4;
					angle = Angle(Link->X, Link->Y, Ghost_X+8, Ghost_Y+8);
					while(Ghost_Jump>0||Ghost_Z>0){
						Ghost_FaceLink(ghost);
						Ghost_MoveAtAngle(angle, 2, 0);
						SGWaitframe(this, ghost, vars, 1);
					}
					Ghost_Data = combo+8;
					Ghost_FaceLink(ghost);
					angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y);
					SGWaitframe(this, ghost, vars, 32);
					Ghost_Data = combo+12;
					angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y);
					for(i=0; i<4; ++i){
						j = angle-50+100*(i/3);
						e = FireEWeapon(EW_SOLAR, Ghost_X+8+VectorX(16, j), Ghost_Y+8+VectorY(16, j), DegtoRad(j), 400, ghost->WeaponDamage, SPR_LIGHTSHOT, SFX_LIGHTSHOT, EWF_UNBLOCKABLE);
						e->Rotation = j;
					}
					SGWaitframe(this, ghost, vars, 24);
					for(i=0; i<5; ++i){
						j = angle-60+120*(i/4);
						e = FireEWeapon(EW_SOLAR, Ghost_X+8+VectorX(16, j), Ghost_Y+8+VectorY(16, j), DegtoRad(j), 400, ghost->WeaponDamage, SPR_LIGHTSHOT, SFX_LIGHTSHOT, EWF_UNBLOCKABLE);
						e->Rotation = j;
					}
					SGWaitframe(this, ghost, vars, 24);
					attackDelay = 60;
				}
				else if(attack==5){ //Expanding shot stream
					Ghost_Data = combo+4;
					angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y)+Rand(-70, 70);
					for(i=0; i<16; ++i){
						Ghost_FaceLink(ghost);
						Ghost_MoveAtAngle(angle, 3, 0);
						SGWaitframe(this, ghost, vars, 1);
					}
					angle = Angle(Ghost_X+8, Ghost_Y+8, 112, 56);
					for(i=0; i<12; ++i){
						Ghost_FaceLink(ghost);
						Ghost_MoveAtAngle(angle, 2, 0);
						SGWaitframe(this, ghost, vars, 1);
					}
					Ghost_Data = combo+8;
					for(i=0; i<64; ++i){
						Ghost_FaceLink(ghost);
						SGCasting();
						SGWaitframe(this, ghost, vars, 1);
					}
					Ghost_Data = combo+12;
					j = Choose(-1, 1);
					for(i=0; i<72; ++i){
						Ghost_FaceLink(ghost);
						if(i%9==0){
							angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y);
							e = FireEWeapon(EW_SOLAR, Ghost_X+8+VectorX(16, angle), Ghost_Y+8+VectorY(16, angle), DegtoRad(angle), 0, ghost->WeaponDamage, 0, SFX_LIGHTSHOT, EWF_UNBLOCKABLE);
							e->CollDetection = false;
							RunEWeaponScript(e, "SolarBigShot", {0, 16, 0.5, 0.2});
						}
						SGWaitframe(this, ghost, vars, 1);
					}
					attackDelay = 90;
				}
			}
			SGWaitframe(this, ghost, vars, 1);
		}
	}
	void SGWaitframe(ffc this, npc ghost, int vars, int frames){
		for(int i=0; i<frames; ++i){
			vars[STRAFEDEGREES] += Abs(AngDiff(Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y), vars[LINKANGLE]));
			vars[LINKANGLE] = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y);
			
			if(!SSGhost_Waitframe(this, ghost, false, false)){
				Game->PlayMIDI(0);
				DeathAnimCleanup(ghost);
				Ghost_DeathAnimation(this, ghost, GHD_EXPLODE);
				ffc f = Screen->LoadFFC(FindFFCRunning(Game->GetFFCScript("HealthBar_Tiled_Single")));
				f->Script = 0;
				ClearFFC(f);
				Quit();
			}
		}
	}
	void SGCasting(){
		int x = Ghost_X;
		int y = Ghost_Y;
		switch(Ghost_Dir){
			case DIR_UP:
				x += 15;
				y += 1;
				break;
			case DIR_DOWN:
				x += 15;
				y += 28;
				break;
			case DIR_LEFT:
				x += 4;
				y += 20;
				break;
			case DIR_RIGHT:
				x += 27;
				y += 20;
				break;
		}
		Screen->Circle(4, x+Rand(-1, 1), y+Rand(-1, 1), 2+Rand(4), Choose(0x86, 0x87, 0x88), 1, 0, 0, 0, true, 128);
	}
}

ffc script LunarGolemMiniboss{
	void run(int enemyid){
		int i; int j; int k; int m;
		int x; int y;
		int angle;
		eweapon e;
		
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		ghost->Immortal = true;
		int defenses[28];
		Ghost_StoreDefenses(ghost, defenses);
		Ghost_SetAllDefenses(ghost, NPCDT_BLOCK);
		Ghost_Transform(this, ghost, 51484, 8, 2, 2);
		Ghost_SetHitOffsets(ghost, 2, 0, 6, 6);
		while(Distance(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y)>48){
			SSGhost_Waitframe(this, ghost);
		}
		for(i=0; i<32; ++i){
			if(i%2==0){
				Ghost_X += (i%4<2)?-1:1;
			}
			SSGhost_Waitframe(this, ghost);
		}
		Ghost_Data = 51485;
		SSGhost_Waitframes(this, ghost, 16);
		Ghost_Data = 51486;
		SSGhost_Waitframes(this, ghost, 8);
		Game->PlaySound(86);
		for(i=0; i<16; ++i){
			DrawStarGlint(4, Ghost_X+16, Ghost_Y+8, -90+(i/16)*90, 8+i/2, Choose(0x72, 0x73, 0x74));
			SSGhost_Waitframe(this, ghost);
		}
		Ghost_SetDefenses(ghost, defenses);
		Game->PlayEnhancedMusic("SS-Golem.ogg", 0);
		RunFFCScript(Game->GetFFCScript("HealthBar_Tiled_Single"), {ghost->ID, 11, 0, 1});
		int combo = ghost->Attributes[10];
		Ghost_SetFlag(GHF_4WAY);
		Ghost_Data = combo;
		Ghost_Dir = DIR_DOWN;
		int attack;
		int attackDelay;
		int phase;
		int ringCooldown;
		int attackCycle;
		int initHP = Ghost_HP;
		int vars[16];
		while(true){
			Ghost_Data = combo;
			if(Ghost_HP<initHP*0.5)
				phase = 1;
			if(attackDelay)
				--attackDelay;
			else{
				int numWeapons;
				for(i=Screen->NumEWeapons(); i>0; --i){
					e = Screen->LoadEWeapon(i);
					if(e->Damage>0&&e->CollDetection&&e->Script!=11)
						++numWeapons;
				}
				if(phase==0){
					attack = Choose(0, 1);
					if(numWeapons>8&&Rand(3)==0)
						attack = 3;
					if(attackCycle==6){
						attack = 2;
						attackCycle = 0;
					}
					if(attack==1&&(ringCooldown||numWeapons>32))
						attack = 0;
				}
				else{
					attack = Choose(1, 4, 5);
					if(numWeapons>6&&Rand(3)==0)
						attack = 3;
					if(attackCycle==6){
						attack = 2;
						attackCycle = 0;
					}
					if((attack==1||attack==4)&&(ringCooldown||numWeapons>32))
						attack = 5;
				}
				if(ringCooldown)
					--ringCooldown;
				++attackCycle;
				if(attack==0){ //Dash + Clusters
					k = Choose(-1, 1);
					angle = Angle(Link->X, Link->Y, Ghost_X+8, Ghost_Y+8)+(30)*k;
					m = 0;
					if(!Ghost_CanMove8(AngleDir8(WrapDegrees(angle)), 8, 0, false))
						m = 180;
					for(j=0; j<3; ++j){
						angle = Angle(Link->X, Link->Y, Ghost_X+8, Ghost_Y+8)+(30+20*j)*k+180*m;
						Ghost_Data = combo+4;
						for(i=0; i<32; ++i){
							if(i%16==0){
								eweapon e = FireEWeapon(EW_LUNAR, Ghost_X+8, Ghost_Y+8, 0, 0, ghost->WeaponDamage, SPR_LUNARSHOT, SFX_FIREBALL, EWF_UNBLOCKABLE);
								RunEWeaponScript(e, "LunarSwirl", {angle-90, 48, 0.3, 20, 80, 1, 100});
								e = FireEWeapon(EW_LUNAR, Ghost_X+8, Ghost_Y+8, 0, 0, ghost->WeaponDamage, SPR_LUNARSHOT, SFX_FIREBALL, EWF_UNBLOCKABLE);
								RunEWeaponScript(e, "LunarSwirl", {angle+90, 56, 0.3, 20, 80, 1, 100});
							}
							Ghost_FaceLink(ghost);
							Ghost_MoveAtAngle(angle, 2, 0);
							LGWaitframe(this, ghost, vars, 1);
						}
						if(!Ghost_CanMove8(AngleDir8(WrapDegrees(angle)), 1, 0, false)){
							break;
						}
						k = -k;
					}
					if(j<3){
						angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y);
						Ghost_Jump = 3.4;
						Game->PlaySound(SFX_JUMP);
						while(Ghost_Z>0||Ghost_Jump>0){
							Ghost_FaceLink(ghost);
							Ghost_MoveAtAngle(angle, 2, 0);
							LGWaitframe(this, ghost, vars, 1);
						}
					}
					attackDelay = 90;
				}
				else if(attack==1){ //Expanding rings
					ringCooldown = 2;
					j = Choose(-1, 1);
					Ghost_Data = combo+4;
					for(i=0; i<80&&Distance(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y)>64; ++i){
						Ghost_MoveTowardLink(2, 0);
						Ghost_FaceLink(ghost);
						LGWaitframe(this, ghost, vars, 1);
					}
					for(k=0; k<3; ++k){
						angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y)+50*j;
						if(!Ghost_CanMove8(AngleDir8(WrapDegrees(angle)), 1, 0, false)){
							j = -j;
							angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y)+50*j;
						}
						Ghost_Jump = 2.6;
						Game->PlaySound(SFX_JUMP);
						Ghost_Data = combo+4;
						while(Ghost_Z>0||Ghost_Jump>0){
							Ghost_MoveAtAngle(angle, 3, 0);
							Ghost_FaceLink(ghost);
							LGWaitframe(this, ghost, vars, 1);
						}
						Ghost_Data = combo;
						for(i=0; i<18; ++i){
							e = FireEWeapon(EW_LUNAR, Ghost_X+8+VectorX(8, angle+i*40), Ghost_Y+8+VectorY(8, angle+i*40), 0, 0, ghost->WeaponDamage, SPR_LUNARSHOT, SFX_FIREBALL, EWF_UNBLOCKABLE);
							RunEWeaponScript(e, "LunarSwirl", {angle+i*20, 64, 0.6, 20, 900});
						}
						for(i=0; i<24; ++i){
							Ghost_FaceLink(ghost);
							LGWaitframe(this, ghost, vars, 1);
						}
					}
					attackDelay = 60;
				}
				else if(attack==2){ //Phasing Rings
					Ghost_Data = combo+4;
					while(Distance(Ghost_X+8, Ghost_Y+8, 120, 80)>2){
						Ghost_Dir = AngleDir4(Angle(Ghost_X+8, Ghost_Y+8, 120, 80));
						Ghost_MoveAtAngle(Angle(Ghost_X+8, Ghost_Y+8, 120, 80), 2, 0);
						LGWaitframe(this, ghost, vars, 1);
					}
					Ghost_X = 120-8;
					Ghost_Y = 80-8;
					Ghost_Data = combo+16;
					LGWaitframe(this, ghost, vars, 16);
					Game->PlaySound(SFX_CHARGE1);
					for(i=0; i<64; ++i){
						Screen->Circle(4, Ghost_X+16, Ghost_Y+2, 12*(i/64), Choose(0x72, 0x73, 0x74), 1, 0, 0, 0, true, 128);
						LGWaitframe(this, ghost, vars, 1);
					}
					Ghost_Data = combo+20;
					for(i=0; i<12; ++i){
						Screen->Circle(4, Ghost_X+16, Ghost_Y+2+28*(i/12), 12-i, Choose(0x72, 0x73, 0x74), 1, 0, 0, 0, true, 128);
						LGWaitframe(this, ghost, vars, 1);
					}
					for(i=0; i<32; ++i){
						if(i%16==0){
							for(j=0; j<36; ++j){
								if(i==0){
									e = FireEWeapon(EW_LUNAR, Ghost_X+8, Ghost_Y+22, DegtoRad(j*10), 0, ghost->WeaponDamage, SPR_LUNARPHASECUTTER, SFX_WAND, 0);
									RunEWeaponScript(e, "LunarPhaseCutter", {25, 50, 6});
								}
								else{
									e = FireEWeapon(EW_LUNAR, Ghost_X+8, Ghost_Y+22, DegtoRad(5+j*10), 0, ghost->WeaponDamage, SPR_LUNARPHASECUTTER, SFX_WAND, 0);
									RunEWeaponScript(e, "LunarPhaseCutter", {50, 100, 9});
								}
							}
						}
						DamagingCircle(4, Ghost_X+16, Ghost_Y+30, 16*Sin(180*(i/32)), Choose(0x71, 0x72, 0x73, 0x74), 1, LW_LUNAR, ghost->WeaponDamage*2);
						LGWaitframe(this, ghost, vars, 1);
					}
					if(phase==1){
						LGWaitframe(this, ghost, vars, 112);
						Ghost_Data = combo+16;
						LGWaitframe(this, ghost, vars, 16);
						Game->PlaySound(SFX_CHARGE1);
						for(i=0; i<32; ++i){
							Screen->Circle(4, Ghost_X+16, Ghost_Y+2, 12*(i/32), Choose(0x72, 0x73, 0x74), 1, 0, 0, 0, true, 128);
							LGWaitframe(this, ghost, vars, 1);
						}
						Ghost_Data = combo+20;
						for(i=0; i<12; ++i){
							Screen->Circle(4, Ghost_X+16, Ghost_Y+2+28*(i/12), 12-i, Choose(0x72, 0x73, 0x74), 1, 0, 0, 0, true, 128);
							LGWaitframe(this, ghost, vars, 1);
						}
						for(i=0; i<32; ++i){
							if(i%16==0){
								for(j=0; j<36; ++j){
									if(i==0){
										e = FireEWeapon(EW_LUNAR, Ghost_X+8, Ghost_Y+22, DegtoRad(j*10), 0, ghost->WeaponDamage, SPR_LUNARPHASECUTTER, SFX_WAND, EWF_UNBLOCKABLE);
										RunEWeaponScript(e, "LunarPhaseCutter", {25, 50, 4}); //6
									}
									else{
										e = FireEWeapon(EW_LUNAR, Ghost_X+8, Ghost_Y+22, DegtoRad(5+j*10), 0, ghost->WeaponDamage, SPR_LUNARPHASECUTTER, SFX_WAND, EWF_UNBLOCKABLE);
										RunEWeaponScript(e, "LunarPhaseCutter", {50, 100, 6}); //9
									}
								}
							}
							DamagingCircle(4, Ghost_X+16, Ghost_Y+30, 16*Sin(180*(i/32)), Choose(0x71, 0x72, 0x73, 0x74), 1, LW_LUNAR, ghost->WeaponDamage*2);
							LGWaitframe(this, ghost, vars, 1);
						}
					}
					attackDelay = 180;
				}
				else if(attack==3){ //Lunar Shift
					x = 0;
					y = 0;
					k = 0;
					if(Screen->NumEWeapons()){
						for(i=Screen->NumEWeapons(); i>0; --i){
							e = Screen->LoadEWeapon(i);
							if(e->CollDetection&&e->Damage>0){
								x += CenterX(e);
								y += CenterY(e);
								++k;
							}
						}
						x /= k;
						y /= k;
						angle = Angle(Link->X+8, Link->Y+8, x, y);
					}
					else{
						angle = Angle(Link->X, Link->Y, Ghost_X+8, Ghost_Y+8);
					}
					Ghost_Dir = AngleDir4(angle);
					Ghost_Data = combo+8;
					LGWaitframe(this, ghost, vars, 16);
					e = CreateEWeaponAt(EW_SCRIPT10, 120, 80);
					e->CollDetection = false;
					e->DrawYOffset = -1000;
					RunEWeaponScript(e, "LunarShift", {angle, 1.5, 8, 24});
					Ghost_Data = combo+12;
					LGWaitframe(this, ghost, vars, 16);
					attackDelay = 60;
				}
				else if(attack==4){ //Hops + Clusters
					ringCooldown = 1;
					for(i=0; i<4; ++i){
						if(Distance(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y)>80){
							angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y)+Rand(-30, 30);
						}
						else{
							angle = WrapDegrees(Rand(360));
						}
						Ghost_Jump = 1.8;
						Game->PlaySound(SFX_JUMP);
						while(Ghost_Jump>0||Ghost_Z>0){
							Ghost_FaceLink(ghost);
							Ghost_MoveAtAngle(angle, 3, 0);
							LGWaitframe(this, ghost, vars, 1);
						}
						eweapon e = FireEWeapon(EW_LUNAR, Ghost_X+8, Ghost_Y+8, 0, 0, ghost->WeaponDamage, SPR_LUNARSHOT, SFX_FIREBALL, EWF_UNBLOCKABLE);
						RunEWeaponScript(e, "LunarSwirl", {angle-90, 48, 0.3, 20, 80, 1});
						e = FireEWeapon(EW_LUNAR, Ghost_X+8, Ghost_Y+8, 0, 0, ghost->WeaponDamage, SPR_LUNARSHOT, SFX_FIREBALL, EWF_UNBLOCKABLE);
						RunEWeaponScript(e, "LunarSwirl", {angle+90, 56, 0.3, 20, 80, 1});
					}
					attackDelay = 120;
				}
				else if(attack==5){ //That looks like a homing shot
					Ghost_Data = combo+8;
					for(i=0; i<96; ++i){
						Ghost_FaceLink(ghost);
						LGWaitframe(this, ghost, vars, 1);
					}
					Ghost_Data = combo+12;
					for(i=0; i<32*6; ++i){
						Ghost_FaceLink(ghost);
						if(i%32==0){
							angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y);
							e = FireEWeapon(EW_LUNAR, Ghost_X+8+VectorX(16, angle), Ghost_Y+8+VectorY(16, angle), DegtoRad(angle), 250, ghost->WeaponDamage, SPR_RINGSHOT, SFX_RINGSHOT, EWF_UNBLOCKABLE);
							RunEWeaponScript(e, "HomingShot", {0.05, 2.5, 420});
						}
						LGWaitframe(this, ghost, vars, 1);
					}
					attackDelay = 90;
				}
			}
			LGWaitframe(this, ghost, vars, 1);
		}
	}
	void LGWaitframe(ffc this, npc ghost, int vars, int frames){
		for(int i=0; i<frames; ++i){
			if(!SSGhost_Waitframe(this, ghost, false, false)){
				Game->PlayMIDI(0);
				DeathAnimCleanup(ghost);
				Ghost_DeathAnimation(this, ghost, GHD_EXPLODE);
				ffc f = Screen->LoadFFC(FindFFCRunning(Game->GetFFCScript("HealthBar_Tiled_Single")));
				f->Script = 0;
				ClearFFC(f);
				Quit();
			}
		}
	}
}

ffc script StellarGolemMiniboss{
	void run(int enemyid){
		int i; int j; int k; int m;
		int x; int y;
		int angle;
		eweapon e;
		
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		ghost->Immortal = true;
		int defenses[28];
		Ghost_StoreDefenses(ghost, defenses);
		Ghost_SetAllDefenses(ghost, NPCDT_BLOCK);
		Ghost_Transform(this, ghost, 51484, 8, 2, 2);
		Ghost_SetHitOffsets(ghost, 2, 0, 6, 6);
		while(Distance(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y)>48){
			SSGhost_Waitframe(this, ghost);
		}
		for(i=0; i<32; ++i){
			if(i%2==0){
				Ghost_X += (i%4<2)?-1:1;
			}
			SSGhost_Waitframe(this, ghost);
		}
		Ghost_Data = 51485;
		SSGhost_Waitframes(this, ghost, 16);
		Ghost_Data = 51486;
		SSGhost_Waitframes(this, ghost, 8);
		Game->PlaySound(86);
		for(i=0; i<16; ++i){
			DrawStarGlint(4, Ghost_X+16, Ghost_Y+8, -90+(i/16)*90, 8+i/2, Choose(0x96, 0x97, 0x98));
			SSGhost_Waitframe(this, ghost);
		}
		Ghost_SetDefenses(ghost, defenses);
		Game->PlayEnhancedMusic("SS-Golem.ogg", 0);
		RunFFCScript(Game->GetFFCScript("HealthBar_Tiled_Single"), {ghost->ID, 12, 0, 1});
		int combo = ghost->Attributes[10];
		Ghost_SetFlag(GHF_4WAY);
		Ghost_Data = combo;
		Ghost_Dir = DIR_DOWN;
		int attack;
		int attackDelay = 60;
		int phase;
		int attackCycle;
		int initHP = Ghost_HP;
		int vars[16];
		while(true){
			Ghost_Data = combo;
			if(Ghost_HP<initHP*0.5)
				phase = 1;
			if(attackDelay)
				--attackDelay;
			else{
				if(phase==0){
					if(attackCycle==0)
						attack = 1;
					else if(attackCycle==1)
						attack = Choose(0, 2);
					else if(attackCycle==2)
						attack = 0;
					else if(attackCycle==3){
						attack = 3;
						attackCycle = -1;
					}
				}
				else if(phase==1){
					
					if(attackCycle==0)
						attack = 5;
					else if(attackCycle==1)
						attack = Choose(0, 4);
					else if(attackCycle==2)
						attack = 5;
					else if(attackCycle==3)
						attack = 2;
					else if(attackCycle==4)
						attack = Choose(4, 1);
					else if(attackCycle==5){
						attack = 3;
						attackCycle = -1;
					}
				}
				++attackCycle;
				if(attack==0){ //Sword slashes
					Ghost_Data = combo;
					j = Choose(-1, 1);
					angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y);
					Ghost_FaceLink(ghost);
					Game->PlaySound(SFX_STELLARSWORD_APPEAR);
					Ghost_Data = combo+24;
					for(i=0; i<5; ++i){
						for(k=0; k<2; ++k){
							DrawLightSwordSlash(Ghost_X+8, Ghost_Y+8, angle-90*j, 16, i, ghost->WeaponDamage, 0, 0);
							DrawArm(angle-90*j);
							SGWaitframe(this, ghost, vars, 1);
						}
					}
					for(i=0; i<64; ++i){
						DrawLightSwordSlash(Ghost_X+8, Ghost_Y+8, angle-90*j, 16, 5, ghost->WeaponDamage, 0, 0);
						DrawArm(angle-90*j);
						SGWaitframe(this, ghost, vars, 1);
					}
					Game->PlaySound(SFX_STELLARSWORD_SLASH);
					for(i=45; i<180; i+=15){
						Ghost_MoveAtAngle(angle, 3, 0);
						DrawLightSwordSlash(Ghost_X+8, Ghost_Y+8, angle-90*j+i*j, 16, 5, ghost->WeaponDamage, j, 0);
						DrawArm(angle-90*j+i*j);
						SGWaitframe(this, ghost, vars, 1);
					}
					for(i=0; i>4; ++i){
						for(k=0; k<2; ++k){
							DrawLightSwordSlash(Ghost_X+8, Ghost_Y+8, angle+90*j, 16, 5, ghost->WeaponDamage, j, i);
							DrawArm(angle+90*j);
							SGWaitframe(this, ghost, vars, 0);
						}
					}
					j = -j;
					for(i=0; i<16; ++i){
						DrawLightSwordSlash(Ghost_X+8, Ghost_Y+8, angle-90*j, 16, 5, ghost->WeaponDamage, 0, 0);
						DrawArm(angle-90*j);
						SGWaitframe(this, ghost, vars, 1);
					}
					Game->PlaySound(SFX_STELLARSWORD_SLASH);
					for(i=45; i<180; i+=15){
						Ghost_MoveAtAngle(angle, 4, 0);
						DrawLightSwordSlash(Ghost_X+8, Ghost_Y+8, angle-90*j+i*j, 16, 5, ghost->WeaponDamage, j, 0);
						DrawArm(angle-90*j+i*j);
						SGWaitframe(this, ghost, vars, 1);
					}
					for(i=0; i>4; ++i){
						for(k=0; k<2; ++k){
							DrawLightSwordSlash(Ghost_X+8, Ghost_Y+8, angle+90*j, 16, 5, ghost->WeaponDamage, j, i);
							DrawArm(angle+90*j);
							SGWaitframe(this, ghost, vars, 0);
						}
					}
					for(i=5; i>0; --i){
						for(k=0; k<2; ++k){
							DrawLightSwordSlash(Ghost_X+8, Ghost_Y+8, angle+90*j, 16, i, ghost->WeaponDamage, 0, 0);
							DrawArm(angle+90*j);
							SGWaitframe(this, ghost, vars, 1);
						}
					}
					Ghost_Data = combo;
					attackDelay = 30;
				}
				else if(attack==1){ //Wall redirect
					for(j=0; j<3; ++j){
						Ghost_FaceLink(ghost);
						angle = Angle(Ghost_X, Ghost_Y, Link->X-8, Link->Y-8);
						x = Link->X-8+VectorX(32, angle);
						y = Link->Y-8+VectorY(32, angle);
						Ghost_Data = combo+4;
						for(i=0; i<64&&Distance(Ghost_X, Ghost_Y, x, y)>3; ++i){
							Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, x, y), 3, 0);
							SGWaitframe(this, ghost, vars, 1);
						}
						Ghost_FaceLink(ghost);
						angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y);
						Ghost_Data = combo+8;
						SGWaitframe(this, ghost, vars, 16);
						Ghost_Data = combo+12;
						i = Choose(-1, 1);
						e = FireEWeapon(EW_STELLAR, Ghost_X+8+VectorX(16, angle+45*i), Ghost_Y+VectorY(16, angle+45*i), DegtoRad(angle+45*i), 300, ghost->WeaponDamage, SPR_STELLARSHOT, 32, 0);
						e->Rotation = DirAngle(Ghost_Dir);
						e->Script = Game->GetEWeaponScript("StellarBolt");
						SGWaitframe(this, ghost, vars, 24);
					}
					attackDelay = 60;
				}
				else if(attack==2){ //Wave beam
					Ghost_Data = combo+4;
					for(i=0; i<240; ++i){
						Ghost_FaceLink(ghost);
						Ghost_MoveTowardLink(0.3, 0);
						angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y);
						if(i%40==0&&i>60){
							Ghost_Data = combo+12;
							SGWaitframe(this, ghost, vars, 12);
							for(j=-1; j<=1; ++j){
								e = FireEWeapon(EW_STELLAR, Ghost_X+VectorX(16, angle)+VectorX(12*j, angle+90), Ghost_Y+VectorY(16, angle)+VectorY(12*j, angle+90), DegtoRad(angle), 0, ghost->WeaponDamage, 0, 0, 0);
								e->DrawYOffset = -1000;
								e->CollDetection = false;
								RunEWeaponScript(e, "StellarKnockbackBlast", {0, 300});
							}
							SGWaitframe(this, ghost, vars, 12);
							Ghost_Data = combo+4;
						}
						SGWaitframe(this, ghost, vars, 1);
					}
					attackDelay = 90;
				}
				else if(attack==3){ //Meteors
					Ghost_Data = combo+16;
					SGWaitframe(this, ghost, vars, 16);
					Game->PlaySound(SFX_CHARGE1);
					for(i=0; i<64; ++i){
						Screen->Circle(4, Ghost_X+16, Ghost_Y+2, 12*(i/64), Choose(0x96, 0x97, 0x98), 1, 0, 0, 0, true, 128);
						SGWaitframe(this, ghost, vars, 1);
					}
					Ghost_Data = combo+20;
					for(i=0; i<12; ++i){
						Screen->Circle(4, Ghost_X+16, Ghost_Y+2+28*(i/12), 12-i, Choose(0x96, 0x97, 0x98), 1, 0, 0, 0, true, 128);
						SGWaitframe(this, ghost, vars, 1);

					}
					Game->PlaySound(SFX_BOMB);
					Game->PlaySound(74);
					if(phase==0){
						for(i=0; i<8*32; ++i){
							if(i>32*3){
								Ghost_Data = combo+4;
								Ghost_FaceLink(ghost);
								Ghost_MoveAtAngle(Angle(Link->X, Link->Y, Ghost_X+8, Ghost_Y+8), 0.5, 0);
							}
							if(i%32==0){
								e = FireEWeapon(EW_STELLAR, Rand(8, 232), Rand(8, 152), DegtoRad(i*10), 0, ghost->WeaponDamage, 0, 0, 0);
								e->X = Link->X+Rand(-24, 24);
								e->Y = Link->Y+Rand(-24, 24);
								RunEWeaponScript(e, "Meteorite", {1});
								e->CollDetection = false;
								e->DrawYOffset = -1000;
							}
							Screen->Quake = 10;
							SGWaitframe(this, ghost, vars, 1);
						}
					}
					else{
						for(i=0; i<8*32; ++i){
							if(i>32*3){
								Ghost_Data = combo+4;
								Ghost_FaceLink(ghost);
								Ghost_MoveAtAngle(Angle(Link->X, Link->Y, Ghost_X+8, Ghost_Y+8), 0.5, 0);
							}
							if(i%32==0){
								e = FireEWeapon(EW_STELLAR, Rand(8, 232), Rand(8, 152), DegtoRad(i*10), 0, ghost->WeaponDamage, 0, 0, 0);
								RunEWeaponScript(e, "Meteorite", {1});
								e->CollDetection = false;
								e->DrawYOffset = -1000;
							}
							Screen->Quake = 10;
							SGWaitframe(this, ghost, vars, 1);
						}
					}
					attackDelay = 60;
				}
				else if(attack==4){ //Downstab
					Ghost_Data = combo+20;
					SGWaitframe(this, ghost, vars, 16);
					Ghost_Data = combo+4;
					Ghost_FaceLink(ghost);
					Ghost_Jump = 5.6;
					Game->PlaySound(SFX_JUMP);
					while(Ghost_Jump>0){
						Ghost_FaceLink(ghost);
						if(Distance(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y)>24)
							Ghost_MoveAtAngle(Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y), 1, 0);
						SGWaitframe(this, ghost, vars, 1);
					}
					Game->PlaySound(SFX_STELLARSWORD_APPEAR);
					Ghost_Jump = 0;
					int length;
					for(i=0; i<6; ++i){
						Ghost_Jump = 0;
						if(length<5)
							++length;
						DrawLightSwordSlash(Ghost_X+8, Ghost_Y-Ghost_Z+8, 90, 16, Clamp(Floor(Ghost_Z/16), 0, length), ghost->WeaponDamage, 0, 0);
						SGWaitframe(this, ghost, vars, 1);
					}
					Game->PlaySound(SFX_FALL);
					Ghost_Dir = DIR_DOWN;
					Ghost_Data = combo+20;
					while(Ghost_Z>0){
						Ghost_Jump = 0;
						Ghost_Z -= 8;
						if(length<5)
							++length;
						DrawLightSwordSlash(Ghost_X+8, Ghost_Y-Ghost_Z+8, 90, 16, Clamp(Floor(Ghost_Z/16), 0, length), ghost->WeaponDamage, 0, 0);
						SGWaitframe(this, ghost, vars, 1);
					}
					Ghost_Z = 0;
					e = FireEWeapon(EW_STELLAR, Ghost_X+8, Ghost_Y+8, 0, 0, ghost->WeaponDamage, 0, 0, 0);
					RunEWeaponScript(e, "Meteorite", {0, 1, 64});
					e->CollDetection = false;
					e->DrawYOffset = -1000;
					SGWaitframe(this, ghost, vars, 32);
					angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y);
					Ghost_FaceLink(ghost);
					Ghost_Data = combo+12;
					SGWaitframe(this, ghost, vars, 16);
					for(i=0; i<80; ++i){
						if(i>40)
							Ghost_Data = combo;
						if(i==0||i==4||i==8||i==12)
							Game->PlaySound(SFX_STELLARSWORD_APPEAR);
						for(j=-3; j<=3; ++j){
							k = i-Abs(j)*4;
							if(k>0&&k<24){
								m = 5;
								if(k<2||k>=22)
									m = 1;
								else if(k<4||k>=20)
									m = 2;
								else if(k<6||k>=18)
									m = 3;
								else if(k<8||k>=16)
									m = 4;
								
								x = Ghost_X+8+VectorX(16, angle);
								y = Ghost_Y+8+VectorY(16, angle);
								DrawLightSwordSlash(x, y, angle+j*35, 8, m, ghost->WeaponDamage, 0, 0);
							}
						}
						SGWaitframe(this, ghost, vars, 1);
					}
					attackDelay = 90;
				}
				else if(attack==5){ //Pincer
					Ghost_Data = combo+4;
					Ghost_FaceLink(ghost);
					for(i=0; i<64&&Distance(Ghost_X, Ghost_Y, Link->X, Link->Y)>48; ++i){
						Ghost_FaceLink(ghost);
						Ghost_MoveTowardLink(3, 0);
						SGWaitframe(this, ghost, vars, 1);
					}
					Ghost_Data = combo+8;
					for(i=0; i<16; ++i){
						Ghost_FaceLink(ghost);
						SGWaitframe(this, ghost, vars, 1);
					}
					Ghost_Data = combo+12;
					angle = 15+Rand(24);
					k = Rand(3);
					x = Link->X;
					y = Link->Y;
					for(i=0; i<4; ++i){
						e = FireEWeapon(EW_STELLAR, x+VectorX(48, angle), y+VectorY(48, angle), DegtoRad(angle+180), 0, ghost->WeaponDamage, 0, 0, 0);
						e->DrawYOffset = -1000;
						e->CollDetection = false;
						RunEWeaponScript(e, "StellarKnockbackBlast", {50, 400});
						if(k==0){
							angle += 90;
						}
						else if(k==1){
							if(i==0)
								angle += 135;
							else
								angle += 45;
						}
						else if(k==2){
							if(i%2==0)
								angle += 45;
							else
								angle += 135;
						}
						SGWaitframe(this, ghost, vars, 4);
					}
					SGWaitframe(this, ghost, vars, 30);
					Ghost_Data = combo;
					angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y);
					Ghost_FaceLink(ghost);
					SGWaitframe(this, ghost, vars, 30);
					Ghost_Data = combo+4;
					for(i=0; i<24; ++i){
						Ghost_MoveAtAngle(angle, 3, 0);
						SGWaitframe(this, ghost, vars, 1);
					}
					attackDelay = 30;
				}
				else if(attack==6){ //Some real nonsense (unused)
					angle = Angle(Link->X, Link->Y, Ghost_X+8, Ghost_Y+8);
					Ghost_Data = combo+4;
					for(i=0; i<64; ++i){
						Ghost_FaceLink(ghost);
						Ghost_MoveAtAngle(angle, 2, 0);
						SGWaitframe(this, ghost, vars, 1);
					}
					SGWaitframe(this, ghost, vars, 64);
					angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y);
					Ghost_FaceLink(ghost);
					Ghost_Data = combo+8;
					SGWaitframe(this, ghost, vars, 16);
					Ghost_Data = combo+12;
					for(i=0; i<5; ++i){
						e = FireEWeapon(EW_STELLAR, Ghost_X+8+VectorX(16, angle+20*i), Ghost_Y+VectorY(16, angle+20*i), DegtoRad(angle+20*i), 300, ghost->WeaponDamage, SPR_STELLARSHOT, 32, 0);
						e->Rotation = DirAngle(RadtoDeg(e->Angle));
						RunEWeaponScript(e, "StellarBolt", {200});
						if(i>0){
							e = FireEWeapon(EW_STELLAR, Ghost_X+8+VectorX(16, angle-20*i), Ghost_Y+VectorY(16, angle-20*i), DegtoRad(angle-20*i), 300, ghost->WeaponDamage, SPR_STELLARSHOT, 32, 0);
							e->Rotation = DirAngle(RadtoDeg(e->Angle));
							RunEWeaponScript(e, "StellarBolt", {200});
						}
						SGWaitframe(this, ghost, vars, 8);
					}
					SGWaitframe(this, ghost, vars, 32);
					Ghost_Data = combo;
					SGWaitframe(this, ghost, vars, 32);
					attackDelay = 60;
				}
				SGWaitframe(this, ghost, vars, 1);
			}
			SGWaitframe(this, ghost, vars, 1);
		}
	}
	void DrawArm(int angle){
		angle = WrapDegrees(angle);
		int layer = 4;
		if(Abs(AngDiff(angle, -90))<45)
			layer = 2;
		int x = Ghost_X+8+VectorX(12, angle);
		int y = Ghost_Y+8+VectorY(12, angle);
		Screen->DrawTile(layer, x, y, 8976, 1, 1, 0, -1, -1, x, y, angle, 0, true, 128);
	}
	void SGWaitframe(ffc this, npc ghost, int vars, int frames){
		for(int i=0; i<frames; ++i){
			if(!SSGhost_Waitframe(this, ghost, false, false)){
				Game->PlayMIDI(0);
				DeathAnimCleanup(ghost);
				Ghost_DeathAnimation(this, ghost, GHD_EXPLODE);
				ffc f = Screen->LoadFFC(FindFFCRunning(Game->GetFFCScript("HealthBar_Tiled_Single")));
				f->Script = 0;
				ClearFFC(f);
				Quit();
			}
		}
	}
}

int CMB_SOLARGOLEM = 51488;
int CMB_LUNARGOLEM = 51512;
int CMB_STELLARGOLEM = 51536;

ffc script FinalGolemMiniboss{
	void run(int enemyid){
		int i; int j; int k; int m;
		int x; int y;
		int angle;
		eweapon e;
		
		int cmbOffset = 512;
		
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		ghost->Immortal = true;
		int defenses[28];
		Ghost_StoreDefenses(ghost, defenses);
		Ghost_SetAllDefenses(ghost, NPCDT_BLOCK);
		Ghost_Transform(this, ghost, 51484+cmbOffset, 8, 2, 2);
		Ghost_SetHitOffsets(ghost, 2, 0, 6, 6);
		while(Distance(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y)>48){
			SSGhost_Waitframe(this, ghost);
		}
		for(i=0; i<32; ++i){
			if(i%2==0){
				Ghost_X += (i%4<2)?-1:1;
			}
			SSGhost_Waitframe(this, ghost);
		}
		Ghost_Data = 51485+cmbOffset;
		SSGhost_Waitframes(this, ghost, 16);
		Ghost_Data = 51486+cmbOffset;
		SSGhost_Waitframes(this, ghost, 8);
		Game->PlaySound(86);
		for(i=0; i<32; ++i){
			if(i<16)
				DrawStarGlint(4, Ghost_X+16, Ghost_Y+8, -90+(i/16)*90, 8+i/2, Choose(0x86, 0x87, 0x88));
			if(i>=8 && i<24)
				DrawStarGlint(4, Ghost_X+16, Ghost_Y+8, -90+((i-8)/16)*90, 8+(i-8)/2, Choose(0x72, 0x73, 0x74));
			if(i>=16 && i<32)
				DrawStarGlint(4, Ghost_X+16, Ghost_Y+8, -90+((i-16)/16)*90, 8+(i-16)/2, Choose(0x96, 0x97, 0x98));
			if(i == 8 || i == 16)
				Game->PlaySound(86);
			SSGhost_Waitframe(this, ghost);
		}
		Ghost_SetDefenses(ghost, defenses);
		mapdata l1 = Game->LoadTempScreen(1);
		for(i = 32; i<=208; i++)
			l1->ComboD[ComboAt(i, 160)] = 2;
		Game->PlayEnhancedMusic("SS-Golem.ogg", 0);
		RunFFCScript(Game->GetFFCScript("HealthBar_Tiled_Single"), {ghost->ID, 72, 0, 1});
		int combo = ghost->Attributes[10]+cmbOffset;
		Ghost_SetFlag(GHF_4WAY);
		Ghost_Data = combo;
		Ghost_Dir = DIR_DOWN;
		int attack;
		int lastmix = -1;
		int lastsolo = -1;
		int attackDelay = 60;
		int phase;
		int attackCycle;
		int initHP = Ghost_HP;
		int vars[16];
		int bitid = TempBitmap_Create(0, 256, 32);
		bitmap laserbitmap = TempBMP[bitid];
		int bitid2 = TempBitmap_Create(0, 256, 32);
		bitmap laserbitmap2 = TempBMP[bitid2];
		int bitid3 = TempBitmap_Create(0, 256, 32);
		bitmap laserbitmap3 = TempBMP[bitid3];
		while(true){
			Ghost_Data = combo;
			if(Ghost_HP<initHP*0.5)
				phase = 1;
			if(attackDelay)
				--attackDelay;
			else{
				if(attackCycle == 0 || attackCycle == 2 || attackCycle == 4){
					do{
						attack = Rand(0,2);
					}
					while(attack == lastmix);
					lastmix = attack;
				}
				else if(attackCycle == 1 || attackCycle == 3 || attackCycle == 5){
					do{
						attack = Rand(3,5);
					}
					while(attack == lastsolo);
					lastsolo = attack;
				}
				else{
					attack = 6;
					attackCycle = -1;
				}
				++attackCycle;
				
				if(attack == 0){ //Solar balls + Lunar Gravity OR Lunar Homers
					combo = CMB_SOLARGOLEM+cmbOffset;
					Ghost_Data = combo+8;
					for(i=0; i<64; ++i){
						if(i<8)
							Ghost_MoveAtAngle(Angle(Link->X, Link->Y, Ghost_X+8, Ghost_Y+8), 1, 0);
						Ghost_FaceLink(ghost);
						SGCasting();
						SGWaitframe(this, ghost, vars, 1);
					}
					angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y);
					Ghost_Data = combo+12;
					for(i = 0; i<300; i++){
						if(i%45 == 0){
							Ghost_FaceLink(ghost);
							angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y);
							e = FireEWeapon(EW_SOLAR, Ghost_X+8+VectorX(16, angle), Ghost_Y+8+VectorY(16, angle), DegtoRad(angle), 0, ghost->WeaponDamage, 0, SFX_LIGHTSHOT, EWF_UNBLOCKABLE);
							e->CollDetection = false;
							RunEWeaponScript(e, "SolarBigShot", {0, 16, 0.25, 0.075, 0, -24});
						}
						else if(i%90 == 0){
							Ghost_FaceLink(ghost);
							angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y)-30;
							e = FireEWeapon(EW_SOLAR, Ghost_X+8+VectorX(16, angle), Ghost_Y+8+VectorY(16, angle), DegtoRad(angle), 0, ghost->WeaponDamage, 0, SFX_LIGHTSHOT, EWF_UNBLOCKABLE);
							e->CollDetection = false;
							RunEWeaponScript(e, "SolarBigShot", {0, 16, 0.25, 0.075, 0, -24});
							angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y)+30;
							e = FireEWeapon(EW_SOLAR, Ghost_X+8+VectorX(16, angle), Ghost_Y+8+VectorY(16, angle), DegtoRad(angle), 0, ghost->WeaponDamage, 0, SFX_LIGHTSHOT, EWF_UNBLOCKABLE);
							e->CollDetection = false;
							RunEWeaponScript(e, "SolarBigShot", {0, 16, 0.25, 0.075, 0, -24});
						}
						if(phase == 0){
							if(i%55 == 0){
								angle = Rand(0, 359);
								e = CreateEWeaponAt(EW_SCRIPT10, 120, 80);
								e->CollDetection = false;
								e->DrawYOffset = -1000;
								RunEWeaponScript(e, "LunarShift", {angle, 1.5, 8, 24});
							}
						}
						else{
							if(i%55 == 0){
								angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y);
								e = FireEWeapon(EW_LUNAR, Ghost_X+8+VectorX(16, angle), Ghost_Y+8+VectorY(16, angle), DegtoRad(angle), 150, ghost->WeaponDamage, SPR_RINGSHOT, SFX_RINGSHOT, EWF_UNBLOCKABLE);
								RunEWeaponScript(e, "HomingShot", {0.05, 2.5, 240});
							}
						}
						SGCasting();
						SGWaitframe(this, ghost, vars, 1);
					}
					attackDelay = 90;
				}
				else if(attack == 1){ //Lunar + Stellar
					combo = CMB_LUNARGOLEM+cmbOffset;
					Ghost_Data = combo;
					if(phase == 0){ //Run back and make the slow delayed target lunar shots, then follow up with the stellar cage
						for(int l = 0; l<2; l++){
							k = Choose(-1, 1);
							angle = Angle(Link->X, Link->Y, Ghost_X+8, Ghost_Y+8)+(30)*k;
							m = 0;
							if(!Ghost_CanMove8(AngleDir8(WrapDegrees(angle)), 8, 0, false))
								m = 180;
							for(j=0; j<3; ++j){
								angle = Angle(Link->X, Link->Y, Ghost_X+8, Ghost_Y+8)+(30+20*j)*k+180*m;
								Ghost_Data = combo+4;
								for(i=0; i<32; ++i){
									if(i%16==0){
										eweapon e = FireEWeapon(EW_LUNAR, Ghost_X+8, Ghost_Y+8, 0, 0, ghost->WeaponDamage, SPR_LUNARSHOT, SFX_FIREBALL, EWF_UNBLOCKABLE);
										RunEWeaponScript(e, "LunarSwirl", {angle-90, 48, 0.3, 20, 80, 1, 100});
										e = FireEWeapon(EW_LUNAR, Ghost_X+8, Ghost_Y+8, 0, 0, ghost->WeaponDamage, SPR_LUNARSHOT, SFX_FIREBALL, EWF_UNBLOCKABLE);
										RunEWeaponScript(e, "LunarSwirl", {angle+90, 56, 0.3, 20, 80, 1, 100});
									}
									Ghost_FaceLink(ghost);
									Ghost_MoveAtAngle(angle, 2, 0);
									LGWaitframe(this, ghost, vars, 1);
								}
								if(!Ghost_CanMove8(AngleDir8(WrapDegrees(angle)), 1, 0, false)){
									break;
								}
								k = -k;
							}
							if(j<3){
								angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y);
								Ghost_Jump = 3.4;
								Game->PlaySound(SFX_JUMP);
								while(Ghost_Z>0||Ghost_Jump>0){
									Ghost_FaceLink(ghost);
									Ghost_MoveAtAngle(angle, 2, 0);
									LGWaitframe(this, ghost, vars, 1);
								}
							}
						}
						Ghost_Data = combo;
						SGWaitframe(this, ghost, vars, 30);
						combo = CMB_STELLARGOLEM+cmbOffset;
						Ghost_Data = combo;
						SGWaitframe(this, ghost, vars, 30);
						Ghost_Data = combo+4;
						Ghost_FaceLink(ghost);
						for(i=0; i<64&&Distance(Ghost_X, Ghost_Y, Link->X, Link->Y)>48; ++i){
							Ghost_FaceLink(ghost);
							Ghost_MoveTowardLink(3, 0);
							SGWaitframe(this, ghost, vars, 1);
						}
						Ghost_Data = combo+8;
						for(i=0; i<16; ++i){
							Ghost_FaceLink(ghost);
							SGWaitframe(this, ghost, vars, 1);
						}
						Ghost_Data = combo+12;
						angle = 15+Rand(24);
						k = Rand(3);
						x = Link->X;
						y = Link->Y;
						for(i=0; i<4; ++i){
							e = FireEWeapon(EW_STELLAR, x+VectorX(48, angle), y+VectorY(48, angle), DegtoRad(angle+180), 0, ghost->WeaponDamage, 0, 0, 0);
							e->DrawYOffset = -1000;
							e->CollDetection = false;
							RunEWeaponScript(e, "StellarKnockbackBlast", {50, 400});
							if(k==0){
								angle += 90;
							}
							else if(k==1){
								if(i==0)
									angle += 135;
								else
									angle += 45;
							}
							else if(k==2){
								if(i%2==0)
									angle += 45;
								else
									angle += 135;
							}
							SGWaitframe(this, ghost, vars, 4);
						}
						SGWaitframe(this, ghost, vars, 30);
						Ghost_Data = combo;
						angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y);
						Ghost_FaceLink(ghost);
						SGWaitframe(this, ghost, vars, 30);
						Ghost_Data = combo+4;
						for(i=0; i<24; ++i){
							Ghost_MoveAtAngle(angle, 3, 0);
							SGWaitframe(this, ghost, vars, 1);
						}
						attackDelay = 90;
					}
					else{ //Hop and make some clusters, then chadwalk
						for(i=0; i<4; ++i){
							if(Distance(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y)>80){
								angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y)+Rand(-30, 30);
							}
							else{
								angle = WrapDegrees(Rand(360));
							}
							Ghost_Jump = 1.8;
							Game->PlaySound(SFX_JUMP);
							while(Ghost_Jump>0||Ghost_Z>0){
								Ghost_FaceLink(ghost);
								Ghost_MoveAtAngle(angle, 3, 0);
								LGWaitframe(this, ghost, vars, 1);
							}
							eweapon e = FireEWeapon(EW_LUNAR, Ghost_X+8, Ghost_Y+8, 0, 0, ghost->WeaponDamage, SPR_LUNARSHOT, SFX_FIREBALL, EWF_UNBLOCKABLE);
							RunEWeaponScript(e, "LunarSwirl", {angle-90, 48, 0.3, 20, 80, 1});
							e = FireEWeapon(EW_LUNAR, Ghost_X+8, Ghost_Y+8, 0, 0, ghost->WeaponDamage, SPR_LUNARSHOT, SFX_FIREBALL, EWF_UNBLOCKABLE);
							RunEWeaponScript(e, "LunarSwirl", {angle+90, 56, 0.3, 20, 80, 1});
						}
						// if(Distance(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y)>80){
							// angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y)+Rand(-30, 30);
						// }
						// else{
							// angle = WrapDegrees(Rand(360));
						// }
						angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y);
						Ghost_Jump = 5;
						Game->PlaySound(SFX_JUMP);
						while(Ghost_Jump>0||Ghost_Z>0){
							Ghost_FaceLink(ghost);
							Ghost_MoveAtAngle(angle, 3, 0);
							LGWaitframe(this, ghost, vars, 1);
						}
						combo = CMB_STELLARGOLEM+cmbOffset;
						Ghost_Data = combo+4;
						for(i=0; i<240; ++i){
							Ghost_FaceLink(ghost);
							Ghost_MoveTowardLink(0.3, 0);
							angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y);
							if(i%40==0&&i>60){
								Ghost_Data = combo+12;
								SGWaitframe(this, ghost, vars, 12);
								for(j=-1; j<=1; ++j){
									e = FireEWeapon(EW_STELLAR, Ghost_X+VectorX(16, angle)+VectorX(12*j, angle+90), Ghost_Y+VectorY(16, angle)+VectorY(12*j, angle+90), DegtoRad(angle), 0, ghost->WeaponDamage, 0, 0, 0);
									e->DrawYOffset = -1000;
									e->CollDetection = false;
									RunEWeaponScript(e, "StellarKnockbackBlast", {0, 300});
								}
								SGWaitframe(this, ghost, vars, 12);
								Ghost_Data = combo+4;
							}
							SGWaitframe(this, ghost, vars, 1);
						}
						attackDelay = 120;
					}
				}
				else if(attack == 2){ //Stellar + solar
					combo = CMB_STELLARGOLEM+cmbOffset;
					if(phase == 0){ //Sequential redirects with some solar stream tossed in
						for(j=0; j<3; ++j){
							Ghost_FaceLink(ghost);
							angle = Angle(Ghost_X, Ghost_Y, Link->X-8, Link->Y-8);
							x = Link->X-8+VectorX(32, angle);
							y = Link->Y-8+VectorY(32, angle);
							Ghost_Data = combo+4;
							for(i=0; i<64&&Distance(Ghost_X, Ghost_Y, x, y)>3; ++i){
								Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, x, y), 3, 0);
								SGWaitframe(this, ghost, vars, 1);
							}
							Ghost_FaceLink(ghost);
							angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y);
							Ghost_Data = combo+8;
							SGWaitframe(this, ghost, vars, 16);
							Ghost_Data = combo+12;
							i = Choose(-1, 1);
							e = FireEWeapon(EW_STELLAR, Ghost_X+8+VectorX(16, angle+45*i), Ghost_Y+VectorY(16, angle+45*i), DegtoRad(angle+45*i), 300, ghost->WeaponDamage, SPR_STELLARSHOT, 32, 0);
							e->Rotation = DirAngle(Ghost_Dir);
							// e->Script = Game->GetEWeaponScript("StellarBolt");
							RunEWeaponScript(e, "StellarBolt", {e->Step, 1});
							SGWaitframe(this, ghost, vars, 24);
							combo = CMB_SOLARGOLEM+cmbOffset;
							Ghost_Data = combo+12;
							for(i=0; i<48; ++i){
								Ghost_FaceLink(ghost);
								if(i%6==0){
									angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y);
									e = FireEWeapon(EW_SOLAR, Ghost_X+8+VectorX(16, angle), Ghost_Y+8+VectorY(16, angle), DegtoRad(angle), 300, ghost->WeaponDamage, SPR_LIGHTSHOT, SFX_LIGHTSHOT, EWF_UNBLOCKABLE);
									e->Rotation = angle;
								}
								SGWaitframe(this, ghost, vars, 1);
							}
							combo = CMB_STELLARGOLEM+cmbOffset;
						}
						attackDelay = 90;
					}
					else{ //Redirect blossom + the sunballwall
						angle = Angle(Link->X, Link->Y, Ghost_X+8, Ghost_Y+8);
						Ghost_Data = combo+4;
						for(i=0; i<64; ++i){
							Ghost_FaceLink(ghost);
							Ghost_MoveAtAngle(angle, 2, 0);
							SGWaitframe(this, ghost, vars, 1);
						}
						SGWaitframe(this, ghost, vars, 64);
						angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y);
						Ghost_FaceLink(ghost);
						Ghost_Data = combo+8;
						SGWaitframe(this, ghost, vars, 16);
						Ghost_Data = combo+12;
						j = 30;
						for(i=0; i<4; ++i){
							e = FireEWeapon(EW_STELLAR, Ghost_X+8+VectorX(16, angle+j*i), Ghost_Y+VectorY(16, angle+j*i), DegtoRad(angle+j*i), 300, ghost->WeaponDamage, SPR_STELLARSHOT, 32, 0);
							e->Rotation = DirAngle(RadtoDeg(e->Angle));
							RunEWeaponScript(e, "StellarBolt", {200});
							if(i>0){
								e = FireEWeapon(EW_STELLAR, Ghost_X+8+VectorX(16, angle-j*i), Ghost_Y+VectorY(16, angle-j*i), DegtoRad(angle-j*i), 300, ghost->WeaponDamage, SPR_STELLARSHOT, 32, 0);
								e->Rotation = DirAngle(RadtoDeg(e->Angle));
								RunEWeaponScript(e, "StellarBolt", {200});
							}
							SGWaitframe(this, ghost, vars, 8);
						}
						SGWaitframe(this, ghost, vars, 32);
						Ghost_Data = combo;
						SGWaitframe(this, ghost, vars, 32);
						combo = CMB_SOLARGOLEM+cmbOffset;
						Ghost_Data = combo+8;
						for(i=0; i<64; ++i){
							Ghost_FaceLink(ghost);
							SGCasting();
							SGWaitframe(this, ghost, vars, 1);
						}
						Ghost_Data = combo+12;
						j = Choose(-1, 1);
						for(i=0; i<36; ++i){
							Ghost_FaceLink(ghost);
							if(i%9==0){
								angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y);
								e = FireEWeapon(EW_SOLAR, Ghost_X+8+VectorX(16, angle), Ghost_Y+8+VectorY(16, angle), DegtoRad(angle), 0, ghost->WeaponDamage, 0, SFX_LIGHTSHOT, EWF_UNBLOCKABLE);
								e->CollDetection = false;
								RunEWeaponScript(e, "SolarBigShot", {0, 16, 0.5, 0.15, 0, -24});
							}
							SGWaitframe(this, ghost, vars, 1);
						}
						attackDelay = 90;
					}
				}
				else if(attack==3){ //Expanding shot stream
					combo = CMB_SOLARGOLEM+cmbOffset;
					Ghost_Data = combo+4;
					angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y)+Rand(-70, 70);
					for(i=0; i<16; ++i){
						Ghost_FaceLink(ghost);
						Ghost_MoveAtAngle(angle, 3, 0);
						SGWaitframe(this, ghost, vars, 1);
					}
					angle = Angle(Ghost_X+8, Ghost_Y+8, 112, 56);
					for(i=0; i<12; ++i){
						Ghost_FaceLink(ghost);
						Ghost_MoveAtAngle(angle, 2, 0);
						SGWaitframe(this, ghost, vars, 1);
					}
					Ghost_Data = combo+8;
					for(i=0; i<64; ++i){
						Ghost_FaceLink(ghost);
						SGCasting();
						SGWaitframe(this, ghost, vars, 1);
					}
					Ghost_Data = combo+12;
					j = Choose(-1, 1);
					for(i=0; i<72; ++i){
						Ghost_FaceLink(ghost);
						if(i%9==0){
							angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y);
							e = FireEWeapon(EW_SOLAR, Ghost_X+8+VectorX(16, angle), Ghost_Y+8+VectorY(16, angle), DegtoRad(angle), 0, ghost->WeaponDamage, 0, SFX_LIGHTSHOT, EWF_UNBLOCKABLE);
							e->CollDetection = false;
							RunEWeaponScript(e, "SolarBigShot", {0, 16, 0.25, 0.15, 0, -24});
						}
						SGWaitframe(this, ghost, vars, 1);
					}
					if(phase == 1){
						SGWaitframe(this, ghost, vars, 45);
						for(i=0; i<18; ++i){
							Ghost_FaceLink(ghost);
							if(i%6==0){
								angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y)+i/6*20;
								e = FireEWeapon(EW_SOLAR, Ghost_X+8+VectorX(16, angle), Ghost_Y+8+VectorY(16, angle), DegtoRad(angle), 300, ghost->WeaponDamage, SPR_LIGHTSHOT, SFX_LIGHTSHOT, EWF_UNBLOCKABLE);
								e->Rotation = angle;
								angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y)-i/6*20;
								e = FireEWeapon(EW_SOLAR, Ghost_X+8+VectorX(16, angle), Ghost_Y+8+VectorY(16, angle), DegtoRad(angle), 300, ghost->WeaponDamage, SPR_LIGHTSHOT, SFX_LIGHTSHOT, EWF_UNBLOCKABLE);
								e->Rotation = angle;
							}
							SGWaitframe(this, ghost, vars, 1);
						}
					}
					attackDelay = 90;
				}
				else if(attack==4){ //Expanding rings
					combo = CMB_LUNARGOLEM+cmbOffset;
					j = Choose(-1, 1);
					Ghost_Data = combo+4;
					for(i=0; i<80&&Distance(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y)>64; ++i){
						Ghost_MoveTowardLink(2, 0);
						Ghost_FaceLink(ghost);
						LGWaitframe(this, ghost, vars, 1);
					}
					for(k=0; k<3; ++k){
						angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y)+50*j;
						if(!Ghost_CanMove8(AngleDir8(WrapDegrees(angle)), 1, 0, false)){
							j = -j;
							angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y)+50*j;
						}
						Ghost_Jump = 2.6;
						Game->PlaySound(SFX_JUMP);
						Ghost_Data = combo+4;
						while(Ghost_Z>0||Ghost_Jump>0){
							Ghost_MoveAtAngle(angle, 3, 0);
							Ghost_FaceLink(ghost);
							LGWaitframe(this, ghost, vars, 1);
						}
						Ghost_Data = combo;
						for(i=0; i<18; ++i){
							e = FireEWeapon(EW_LUNAR, Ghost_X+8+VectorX(8, angle+i*40), Ghost_Y+8+VectorY(8, angle+i*40), 0, 0, ghost->WeaponDamage, SPR_LUNARSHOT, SFX_FIREBALL, EWF_UNBLOCKABLE);
							RunEWeaponScript(e, "LunarSwirl", {angle+i*20, 64, 0.6, 20, 900});
						}
						for(i=0; i<24; ++i){
							Ghost_FaceLink(ghost);
							LGWaitframe(this, ghost, vars, 1);
						}
					}
					if(phase == 1){
						Ghost_Data = combo+16;
						LGWaitframe(this, ghost, vars, 16);
						Game->PlaySound(SFX_CHARGE1);
						for(i=0; i<64; ++i){
							Screen->Circle(4, Ghost_X+16, Ghost_Y+2, 12*(i/64), Choose(0x72, 0x73, 0x74), 1, 0, 0, 0, true, 128);
							LGWaitframe(this, ghost, vars, 1);
						}
						Ghost_Data = combo+20;
						for(i=0; i<12; ++i){
							Screen->Circle(4, Ghost_X+16, Ghost_Y+2+28*(i/12), 12-i, Choose(0x72, 0x73, 0x74), 1, 0, 0, 0, true, 128);
							LGWaitframe(this, ghost, vars, 1);
						}
						for(i=0; i<32; ++i){
							if(i==0){
								for(j=0; j<36; ++j){
									e = FireEWeapon(EW_LUNAR, Ghost_X+8, Ghost_Y+22, DegtoRad(j*10), 0, ghost->WeaponDamage, SPR_LUNARPHASECUTTER, SFX_WAND, 0);
									RunEWeaponScript(e, "LunarPhaseCutter", {25, 50, 6});
								}
							}
							DamagingCircle(4, Ghost_X+16, Ghost_Y+30, 16*Sin(180*(i/32)), Choose(0x71, 0x72, 0x73, 0x74), 1, LW_LUNAR, ghost->WeaponDamage*2);
							LGWaitframe(this, ghost, vars, 1);
						}
					}
					attackDelay = 30;
				}
				else if(attack==5){ //Sword slashes
					combo = CMB_STELLARGOLEM+cmbOffset;
					Ghost_Data = combo;
					j = Choose(-1, 1);
					angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y);
					Ghost_FaceLink(ghost);
					Game->PlaySound(SFX_STELLARSWORD_APPEAR);
					Ghost_Data = combo+24;
					for(i=0; i<5; ++i){
						for(k=0; k<2; ++k){
							DrawLightSwordSlash(Ghost_X+8, Ghost_Y+8, angle-90*j, 16, i, ghost->WeaponDamage, 0, 0);
							DrawArm(angle-90*j);
							SGWaitframe(this, ghost, vars, 1);
						}
					}
					for(i=0; i<64; ++i){
						DrawLightSwordSlash(Ghost_X+8, Ghost_Y+8, angle-90*j, 16, 5, ghost->WeaponDamage, 0, 0);
						DrawArm(angle-90*j);
						SGWaitframe(this, ghost, vars, 1);
					}
					Game->PlaySound(SFX_STELLARSWORD_SLASH);
					for(i=45; i<180; i+=15){
						Ghost_MoveAtAngle(angle, 3, 0);
						DrawLightSwordSlash(Ghost_X+8, Ghost_Y+8, angle-90*j+i*j, 16, 5, ghost->WeaponDamage, j, 0);
						DrawArm(angle-90*j+i*j);
						SGWaitframe(this, ghost, vars, 1);
					}
					for(i=0; i>4; ++i){
						for(k=0; k<2; ++k){
							DrawLightSwordSlash(Ghost_X+8, Ghost_Y+8, angle+90*j, 16, 5, ghost->WeaponDamage, j, i);
							DrawArm(angle+90*j);
							SGWaitframe(this, ghost, vars, 0);
						}
					}
					j = -j;
					for(i=0; i<16; ++i){
						DrawLightSwordSlash(Ghost_X+8, Ghost_Y+8, angle-90*j, 16, 5, ghost->WeaponDamage, 0, 0);
						DrawArm(angle-90*j);
						SGWaitframe(this, ghost, vars, 1);
					}
					Game->PlaySound(SFX_STELLARSWORD_SLASH);
					for(i=45; i<180; i+=15){
						Ghost_MoveAtAngle(angle, 4, 0);
						DrawLightSwordSlash(Ghost_X+8, Ghost_Y+8, angle-90*j+i*j, 16, 5, ghost->WeaponDamage, j, 0);
						DrawArm(angle-90*j+i*j);
						SGWaitframe(this, ghost, vars, 1);
					}
					for(i=0; i>4; ++i){
						for(k=0; k<2; ++k){
							DrawLightSwordSlash(Ghost_X+8, Ghost_Y+8, angle+90*j, 16, 5, ghost->WeaponDamage, j, i);
							DrawArm(angle+90*j);
							SGWaitframe(this, ghost, vars, 0);
						}
					}
					for(i=5; i>0; --i){
						for(k=0; k<2; ++k){
							DrawLightSwordSlash(Ghost_X+8, Ghost_Y+8, angle+90*j, 16, i, ghost->WeaponDamage, 0, 0);
							DrawArm(angle+90*j);
							SGWaitframe(this, ghost, vars, 1);
						}
					}
					if(phase == 1){
						Ghost_Data = combo+20;
						SGWaitframe(this, ghost, vars, 16);
						Ghost_Data = combo+4;
						Ghost_FaceLink(ghost);
						Ghost_Jump = 5.6;
						Game->PlaySound(SFX_JUMP);
						while(Ghost_Jump>0){
							Ghost_FaceLink(ghost);
							if(Distance(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y)>24)
								Ghost_MoveAtAngle(Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y), 1, 0);
							SGWaitframe(this, ghost, vars, 1);
						}
						Game->PlaySound(SFX_STELLARSWORD_APPEAR);
						Ghost_Jump = 0;
						int length;
						for(i=0; i<6; ++i){
							Ghost_Jump = 0;
							if(length<5)
								++length;
							DrawLightSwordSlash(Ghost_X+8, Ghost_Y-Ghost_Z+8, 90, 16, Clamp(Floor(Ghost_Z/16), 0, length), ghost->WeaponDamage, 0, 0);
							SGWaitframe(this, ghost, vars, 1);
						}
						Game->PlaySound(SFX_FALL);
						Ghost_Dir = DIR_DOWN;
						Ghost_Data = combo+20;
						while(Ghost_Z>0){
							Ghost_Jump = 0;
							Ghost_Z -= 8;
							if(length<5)
								++length;
							DrawLightSwordSlash(Ghost_X+8, Ghost_Y-Ghost_Z+8, 90, 16, Clamp(Floor(Ghost_Z/16), 0, length), ghost->WeaponDamage, 0, 0);
							SGWaitframe(this, ghost, vars, 1);
						}
						Ghost_Z = 0;
						e = FireEWeapon(EW_STELLAR, Ghost_X+8, Ghost_Y+8, 0, 0, ghost->WeaponDamage, 0, 0, 0);
						RunEWeaponScript(e, "Meteorite", {0, 1, 64});
						e->CollDetection = false;
						e->DrawYOffset = -1000;
						SGWaitframe(this, ghost, vars, 32);
						angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y);
						Ghost_FaceLink(ghost);
						Ghost_Data = combo+12;
						SGWaitframe(this, ghost, vars, 16);
						for(i=0; i<80; ++i){
							if(i>40)
								Ghost_Data = combo;
							if(i==0||i==4||i==8||i==12)
								Game->PlaySound(SFX_STELLARSWORD_APPEAR);
							for(j=-3; j<=3; ++j){
								k = i-Abs(j)*4;
								if(k>0&&k<24){
									m = 5;
									if(k<2||k>=22)
										m = 1;
									else if(k<4||k>=20)
										m = 2;
									else if(k<6||k>=18)
										m = 3;
									else if(k<8||k>=16)
										m = 4;
									
									x = Ghost_X+8+VectorX(16, angle);
									y = Ghost_Y+8+VectorY(16, angle);
									DrawLightSwordSlash(x, y, angle+j*35, 8, m, ghost->WeaponDamage, 0, 0);
								}
							}
							SGWaitframe(this, ghost, vars, 1);
						}
						attackDelay = 90;
					}
					else
						attackDelay = 30;
					Ghost_Data = combo;
				}
				else if(attack == 6){ //Some phase rings, some laser spinnies, and some meteors in phase 2 for good measure 
					combo = CMB_LUNARGOLEM+cmbOffset;
					Ghost_Data = combo+4;
					while(Distance(Ghost_X+8, Ghost_Y+8, 120, 80)>2){
						Ghost_Dir = AngleDir4(Angle(Ghost_X+8, Ghost_Y+8, 120, 80));
						Ghost_MoveAtAngle(Angle(Ghost_X+8, Ghost_Y+8, 120, 80), 2, 0);
						LGWaitframe(this, ghost, vars, 1);
					}
					Ghost_X = 120-8;
					Ghost_Y = 80-8;
					Ghost_Data = combo+16;
					LGWaitframe(this, ghost, vars, 16);
					Game->PlaySound(SFX_CHARGE1);
					for(i=0; i<64; ++i){
						Screen->Circle(4, Ghost_X+16, Ghost_Y+2, 12*(i/64), Choose(0x72, 0x73, 0x74), 1, 0, 0, 0, true, 128);
						LGWaitframe(this, ghost, vars, 1);
					}
					Ghost_Data = combo+20;
					for(i=0; i<12; ++i){
						Screen->Circle(4, Ghost_X+16, Ghost_Y+2+28*(i/12), 12-i, Choose(0x72, 0x73, 0x74), 1, 0, 0, 0, true, 128);
						LGWaitframe(this, ghost, vars, 1);
					}
					if(phase == 1){
						Game->PlaySound(SFX_BOMB);
						Game->PlaySound(74);
					}
					for(i=0; i<32; ++i){
						if(i%16==0){
							for(j=0; j<36; ++j){
								if(i==0){
									e = FireEWeapon(EW_LUNAR, Ghost_X+8, Ghost_Y+22, DegtoRad(j*10), 0, ghost->WeaponDamage, SPR_LUNARPHASECUTTER, SFX_WAND, 0);
									RunEWeaponScript(e, "LunarPhaseCutter", {25, 50, 6});
								}
								else{
									e = FireEWeapon(EW_LUNAR, Ghost_X+8, Ghost_Y+22, DegtoRad(5+j*10), 0, ghost->WeaponDamage, SPR_LUNARPHASECUTTER, SFX_WAND, 0);
									RunEWeaponScript(e, "LunarPhaseCutter", {50, 100, 9});
								}
							}
						}
						DamagingCircle(4, Ghost_X+16, Ghost_Y+30, 16*Sin(180*(i/32)), Choose(0x71, 0x72, 0x73, 0x74), 1, LW_LUNAR, ghost->WeaponDamage*2);
						if(phase == 1){
							if(i%32==0){
								e = FireEWeapon(EW_STELLAR, Rand(8, 232), Rand(8, 152), DegtoRad(i*10), 0, ghost->WeaponDamage, 0, 0, 0);
								RunEWeaponScript(e, "Meteorite", {1});
								e->CollDetection = false;
								e->DrawYOffset = -1000;
							}
							Screen->Quake = 10;
						}
						LGWaitframe(this, ghost, vars, 1);
					}
					angle = Angle(Ghost_X+8, Ghost_Y, Link->X, Link->Y);
					int sfxTimer[1];
					for(i=0; i<32; ++i){
						LoopingSFX(sfxTimer, 6, SFX_LASERBEAM);
						DrawSolarLaserEW(laserbitmap, Ghost_X+16, Ghost_Y+8, angle+60, 24*(i/32), ghost->WeaponDamage, 0);
						DrawSolarLaserEW(laserbitmap2, Ghost_X+16, Ghost_Y+8, angle+180, 24*(i/32), ghost->WeaponDamage, 0);
						DrawSolarLaserEW(laserbitmap3, Ghost_X+16, Ghost_Y+8, angle+300, 24*(i/32), ghost->WeaponDamage, 0);
						if(phase == 1){
							if(i%32==0){
								e = FireEWeapon(EW_STELLAR, Rand(8, 232), Rand(8, 152), DegtoRad(i*10), 0, ghost->WeaponDamage, 0, 0, 0);
								RunEWeaponScript(e, "Meteorite", {1});
								e->CollDetection = false;
								e->DrawYOffset = -1000;
							}
							Screen->Quake = 10;
						}
						SGWaitframe(this, ghost, vars, 1);
					}	
					for(i=0; i<180; ++i){
						angle+=0.5;
						LoopingSFX(sfxTimer, 6, SFX_LASERBEAM);
						j = 0;
						if(i>16)
							j = Floor(G[G_ANIM]/4)%4;
						k = 16;
						if(i>180-16){
							k = 180-i;
						}
						DrawSolarLaserEW(laserbitmap, Ghost_X+16, Ghost_Y+8, angle+60, 24*(k/16), ghost->WeaponDamage, j);
						DrawSolarLaserEW(laserbitmap2, Ghost_X+16, Ghost_Y+8, angle+180, 24*(k/16), ghost->WeaponDamage, j);
						DrawSolarLaserEW(laserbitmap3, Ghost_X+16, Ghost_Y+8, angle+300, 24*(k/16), ghost->WeaponDamage, j);
						if(phase == 1){
							if(i%32==0){
								e = FireEWeapon(EW_STELLAR, Rand(8, 232), Rand(8, 152), DegtoRad(i*10), 0, ghost->WeaponDamage, 0, 0, 0);
								RunEWeaponScript(e, "Meteorite", {1});
								e->CollDetection = false;
								e->DrawYOffset = -1000;
							}
							Screen->Quake = 10;
						}
						SGWaitframe(this, ghost, vars, 1);
					}
					attackDelay = 120;
				}
				SGWaitframe(this, ghost, vars, 1);
			}
			SGWaitframe(this, ghost, vars, 1);
		}
	}
	void DrawArm(int angle){
		angle = WrapDegrees(angle);
		int layer = 4;
		if(Abs(AngDiff(angle, -90))<45)
			layer = 2;
		int x = Ghost_X+8+VectorX(12, angle);
		int y = Ghost_Y+8+VectorY(12, angle);
		Screen->DrawTile(layer, x, y, 8976, 1, 1, 0, -1, -1, x, y, angle, 0, true, 128);
	}
	void SGWaitframe(ffc this, npc ghost, int vars, int frames){
		for(int i=0; i<frames; ++i){
			if(!SSGhost_Waitframe(this, ghost, false, false)){
				Game->PlayMIDI(0);
				DeathAnimCleanup(ghost);
				Ghost_DeathAnimation(this, ghost, GHD_EXPLODE);
				ffc f = Screen->LoadFFC(FindFFCRunning(Game->GetFFCScript("HealthBar_Tiled_Single")));
				f->Script = 0;
				ClearFFC(f);
				KillLWeapons();
				KillEWeapons();
				mapdata l1 = Game->LoadTempScreen(1);
				for(i = 32; i<=208; i++)
					l1->ComboD[ComboAt(i, 160)] = 0;
				Quit();
			}
		}
	}
	void LGWaitframe(ffc this, npc ghost, int vars, int frames){
		SGWaitframe(this, ghost, vars, frames);
	}
	void SGCasting(){
		int x = Ghost_X;
		int y = Ghost_Y;
		switch(Ghost_Dir){
			case DIR_UP:
				x += 15;
				y += 1;
				break;
			case DIR_DOWN:
				x += 15;
				y += 28;
				break;
			case DIR_LEFT:
				x += 4;
				y += 20;
				break;
			case DIR_RIGHT:
				x += 27;
				y += 20;
				break;
		}
		Screen->Circle(4, x+Rand(-1, 1), y+Rand(-1, 1), 2+Rand(4), Choose(0x86, 0x87, 0x88), 1, 0, 0, 0, true, 128);
	}
}

ffc script Diggernaut{
	const int TANKX = 0;
	const int DRILLEXTEND = 1;
	const int TREADSMOVING = 2;
	const int DRILLACTIVE = 3;
	const int LIGHTX = 4;
	const int LIGHTY = 5;
	const int LIGHTON = 6;
	const int LIGHTANGLE = 7;
	const int CANNON1X = 8;
	const int CANNON1Y = 9;
	const int CANNON1ANGLE = 10;
	const int CANNON2X = 11;
	const int CANNON2Y = 12;
	const int CANNON2ANGLE = 13;
	const int TANKSPEED = 14;
	const int SCROLLX = 15;
	const int ANIMS = 16;
	const int WPNPUSH = 17;
	const int DEATHANIMACTIVE = 18;
	const int INITHP = 19;
	const int CRACKS = 20;
	const int FLASHFRAMES = 21;
	void run(int enemyid){
		int i; int j; int k; int m;
		int x; int y;
		int angle;
		eweapon e;
		
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		ghost->Immortal = true;
		Ghost_SetFlag(GHF_MOVE_OFFSCREEN);
		int combo = ghost->Attributes[10];
		untyped vars[32];
		vars[TANKX] = -128;
		vars[TREADSMOVING] = 0;
		vars[DRILLACTIVE] = 0;
		vars[LIGHTON] = 0;
		vars[INITHP] = Ghost_HP;
		int sfxTreads[1];
		int sfxDrill[1];
		int anims[2] = {sfxTreads, sfxDrill};
		vars[ANIMS] = anims;
		Ghost_X = -32;
		while(Link->X<208){
			DNWaitframe(this, ghost, vars, 1);
		}
		Link->Dir = DIR_LEFT;
		int sfxQuake[1];
		vars[TREADSMOVING] = 0;
		while(vars[TANKX]<-2){
			LoopingSFX(sfxQuake, 40, 74);
			++vars[TANKX];
			Screen->Quake = 10;
			NoAction();
			DNWaitframe(this, ghost, vars, 1);
		}
		for(i=0; i<32; ++i){
			NoAction();
			DNWaitframe(this, ghost, vars, 1);
		}
		Game->PlaySound(102);
		vars[LIGHTON] = 1;
		for(i=0; i<32; ++i){
			NoAction();
			DNWaitframe(this, ghost, vars, 1);
		}
		RunFFCScript(Game->GetFFCScript("HealthBar_Tiled_Single"), {ghost->ID, 13, 0, 1});
		vars[TREADSMOVING] = 1;
		vars[TANKSPEED] = 0.5;
		Game->PlayEnhancedMusic("SS-DrillDozer.ogg", 0);
		int sineTime;
		int attackDelay = 90;
		int initHP = Ghost_HP;
		int phase;
		int attack;
		int attackCycle = 0;
		while(true){
			bool spawnBomb = false;
			if(attackDelay)
				--attackDelay;
			else{
				if(attackCycle==2){
					attack = Choose(0, 4);
				}
				else{
					attack = Choose(1, 2);
				}
				++attackCycle;
				if(attackCycle>2)
					attackCycle = 0;
				
				if(phase==0&&Ghost_HP<initHP*0.5){
					phase = 1;
					attack = 3;
					attackCycle = 0;
				}
				
				if(Game->Counter[CR_BOMBS]==0)
					spawnBomb = true;
				
				if(attack==0){ //Chase and bomb
					Ghost_Data = combo+1;
					for(i=0; i<16; ++i){
						++sineTime;
						sineTime %= 360;
						vars[TANKX] = -2+2*Sin(sineTime*2);
						DNWaitframe(this, ghost, vars, 1);
					}
					Ghost_Data = combo;
					for(vars[TANKSPEED]=0.5; vars[TANKSPEED]<1; vars[TANKSPEED]+=0.05){
						++sineTime;
						sineTime %= 360;
						vars[TANKX] = -2+2*Sin(sineTime*2);
						DNWaitframe(this, ghost, vars, 1);
					}
					m = Choose(0, 1);
					Game->PlaySound(89);
					for(i=0; i<4; ++i){
						for(j=0; j<6; ++j){
							if(j>2||(j>1&&i>0)){
								if(i%2==m){
									x = vars[CANNON1X]+8+VectorX(8, vars[CANNON1ANGLE]);
									y = vars[CANNON1Y]+8+VectorY(8, vars[CANNON1ANGLE]);
									angle = vars[CANNON1ANGLE];
								}
								else{
									x = vars[CANNON2X]+8+VectorX(8, vars[CANNON2ANGLE]);
									y = vars[CANNON2Y]+8+VectorY(8, vars[CANNON2ANGLE]);
									angle = vars[CANNON2ANGLE];
								}
								int jumpHeight = 2.6;
								if(IsEasyMode())
									jumpHeight = 2.9;
								e = FireEWeapon(EW_PHYSICAL, x, y, DegtoRad(WrapDegrees(angle)), Distance(x, y, Link->X, Link->Y)*100/FindJumpLength(jumpHeight, false), ghost->WeaponDamage*0.75, SPR_LOBBOMB, SFX_CANNON, EWF_UNBLOCKABLE|EWF_SHADOW);
								RunEWeaponScript(e, "LobBombEW", {jumpHeight, 0});
							}
							for(k=0; k<8; ++k){
								vars[LIGHTANGLE] = TurnToAngle(vars[LIGHTANGLE], Angle(vars[LIGHTX], vars[LIGHTY], Link->X, Link->Y), 5);
								if(i%2==m){
									vars[CANNON1ANGLE] = TurnToAngle(vars[CANNON1ANGLE], Angle(vars[CANNON1X]+8, vars[CANNON1Y]+8, Link->X, Link->Y+16), 5);
								}
								else{
									vars[CANNON2ANGLE] = TurnToAngle(vars[CANNON2ANGLE], Angle(vars[CANNON2X]+8, vars[CANNON2Y]+8, Link->X, Link->Y-16), 5);
								}
								++sineTime;
								sineTime %= 360;
								vars[TANKX] = -2+2*Sin(sineTime*2);
								DNWaitframe(this, ghost, vars, 1);
							}
						}
						for(j=0; j<56; ++j){
							vars[LIGHTANGLE] = TurnToAngle(vars[LIGHTANGLE], Angle(vars[LIGHTX], vars[LIGHTY], Link->X, Link->Y), 5);
							vars[CANNON1ANGLE] = TurnToAngle(vars[CANNON1ANGLE], 45, 5);
							vars[CANNON2ANGLE] = TurnToAngle(vars[CANNON2ANGLE], -45, 5);
							++sineTime;
							sineTime %= 360;
							vars[TANKX] = -2+2*Sin(sineTime*2);
							DNWaitframe(this, ghost, vars, 1);
						}
					}
					for(vars[TANKSPEED]=1; vars[TANKSPEED]>0.5; vars[TANKSPEED]-=0.05){
						++sineTime;
						sineTime %= 360;
						vars[TANKX] = -2+2*Sin(sineTime*2);
						DNWaitframe(this, ghost, vars, 1);
					}
					attackDelay = 90;
				}
				else if(attack==1){ //Drill
					for(i=0; i<64; ++i){
						vars[LIGHTANGLE] = TurnToAngle(vars[LIGHTANGLE], 0, 5);
						vars[CANNON1ANGLE] = TurnToAngle(vars[CANNON1ANGLE], 0, 5);
						vars[CANNON2ANGLE] = TurnToAngle(vars[CANNON2ANGLE], 0, 5);
						++sineTime;
						sineTime %= 360;
						vars[TANKX] = -2+2*Sin(sineTime*2);
						DNWaitframe(this, ghost, vars, 1);
					}
					vars[DRILLACTIVE] = 1;
					for(i=0; i<32+EasyModeFrames(32); ++i){
						++sineTime;
						sineTime %= 360;
						vars[TANKX] = -2+2*Sin(sineTime*2);
						DNWaitframe(this, ghost, vars, 1);
					}
					while(vars[DRILLEXTEND]<128+EasyModeFrames(-16)){
						vars[DRILLEXTEND] += 4;
						++sineTime;
						sineTime %= 360;
						vars[TANKX] = -2+2*Sin(sineTime*2);
						DNWaitframe(this, ghost, vars, 1);
					}
					
					for(i=0; i<32; ++i){
						++sineTime;
						sineTime %= 360;
						vars[TANKX] = -2+2*Sin(sineTime*2);
						DNWaitframe(this, ghost, vars, 1);
					}
					for(i=0; i<64; ++i){
						if(Link->Y<88){
							x = vars[CANNON2X]+8;
							y = vars[CANNON2Y]+8;
							vars[CANNON2ANGLE] = TurnToAngle(vars[CANNON2ANGLE], Angle(x, y, Link->X, Link->Y), 5);
							x += VectorX(8, vars[CANNON2ANGLE]);
							y += VectorY(8, vars[CANNON2ANGLE]);
						}
						else{
							x = vars[CANNON1X]+8;
							y = vars[CANNON1Y]+8;
							vars[CANNON1ANGLE] = TurnToAngle(vars[CANNON1ANGLE], Angle(x, y, Link->X, Link->Y), 5);
							x += VectorX(8, vars[CANNON1ANGLE]);
							y += VectorY(8, vars[CANNON1ANGLE]);
						}
						if(i%8==0){
							if(Link->Y<88){
								e = FireEWeapon(EW_PHYSICAL, x, y, DegtoRad(WrapDegrees(vars[CANNON2ANGLE])), Distance(x, y, Link->X, Link->Y)*100/FindJumpLength(3.0, false), ghost->WeaponDamage*0.75, SPR_LOBBOMB, SFX_CANNON, EWF_UNBLOCKABLE|EWF_SHADOW);
								RunEWeaponScript(e, "LobBombEW", {3.0, 0});
							}
							else{
								e = FireEWeapon(EW_PHYSICAL, x, y, DegtoRad(WrapDegrees(vars[CANNON1ANGLE])), Distance(x, y, Link->X, Link->Y)*100/FindJumpLength(3.0, false), ghost->WeaponDamage*0.75, SPR_LOBBOMB, SFX_CANNON, EWF_UNBLOCKABLE|EWF_SHADOW);
								RunEWeaponScript(e, "LobBombEW", {3.0, 0});
							}
						}
						++sineTime;
						sineTime %= 360;
						vars[TANKX] = -2+2*Sin(sineTime*2);
						DNWaitframe(this, ghost, vars, 1);
					}
					while(vars[DRILLEXTEND]>0){
						vars[DRILLEXTEND] -= 8;
						++sineTime;
						sineTime %= 360;
						vars[TANKX] = -2+2*Sin(sineTime*2);
						DNWaitframe(this, ghost, vars, 1);
					}
					vars[DRILLEXTEND] = 0;
					vars[DRILLACTIVE] = 0;
					attackDelay = 60;
				}
				else if(attack==2){ //Carpet Bombing
					m = Choose(0, 1);
					Game->PlaySound(89);
					for(i=0; i<80+EasyModeFrames(40); ++i){
						if(m==0){
							x = vars[CANNON2X]+8;
							y = vars[CANNON2Y]+8;
							vars[CANNON2ANGLE] = TurnToAngle(vars[CANNON2ANGLE], Angle(x, y, Link->X, Link->Y)+30, 5);
							vars[LIGHTANGLE] = TurnToAngle(vars[LIGHTANGLE], Angle(x, y, Link->X, Link->Y)+15, 5);
							x += VectorX(8, vars[CANNON2ANGLE]);
							y += VectorY(8, vars[CANNON2ANGLE]);
						}
						else{
							x = vars[CANNON1X]+8;
							y = vars[CANNON1Y]+8;
							vars[CANNON1ANGLE] = TurnToAngle(vars[CANNON1ANGLE], Angle(x, y, Link->X, Link->Y)-30, 5);
							vars[LIGHTANGLE] = TurnToAngle(vars[LIGHTANGLE], Angle(x, y, Link->X, Link->Y)-15, 5);
							x += VectorX(8, vars[CANNON1ANGLE]);
							y += VectorY(8, vars[CANNON1ANGLE]);
						}
						++sineTime;
						sineTime %= 360;
						vars[TANKX] = -2+2*Sin(sineTime*2);
						DNWaitframe(this, ghost, vars, 1);
					}
					for(i=0; i<8*12; ++i){
						if(i%8==0){
							e = FireEWeapon(EW_PHYSICAL, vars[CANNON2X]+8, vars[CANNON2Y]+8, DegtoRad(vars[CANNON2ANGLE]+Rand(-15, 15)), Rand(100, 900), ghost->WeaponDamage*0.75, SPR_LOBBOMB, SFX_CANNON, EWF_UNBLOCKABLE|EWF_SHADOW);
							RunEWeaponScript(e, "LobBombEW", {1.6, 0});
							e = FireEWeapon(EW_PHYSICAL, vars[CANNON1X]+8, vars[CANNON1Y]+8, DegtoRad(vars[CANNON1ANGLE]+Rand(-15, 15)), Rand(100, 900), ghost->WeaponDamage*0.75, SPR_LOBBOMB, SFX_CANNON, EWF_UNBLOCKABLE|EWF_SHADOW);
							RunEWeaponScript(e, "LobBombEW", {1.6, 0});
						}
						++sineTime;
						sineTime %= 360;
						vars[TANKX] = -2+2*Sin(sineTime*2);
						DNWaitframe(this, ghost, vars, 1);
					}
					for(i=0; i<32; ++i){
						vars[LIGHTANGLE] = TurnToAngle(vars[LIGHTANGLE], 0, 5);
						vars[CANNON1ANGLE] = TurnToAngle(vars[CANNON2ANGLE], 0, 5);
						vars[CANNON2ANGLE] = TurnToAngle(vars[CANNON2ANGLE], 0, 5);
						
						++sineTime;
						sineTime %= 360;
						vars[TANKX] = -2+2*Sin(sineTime*2);
						DNWaitframe(this, ghost, vars, 1);
					}
					attackDelay = 30;
				}
				else if(attack==3){ //Wall bouncing bombs
					ghost->CollDetection = false;
					for(i=0; i<80; ++i){
						vars[CANNON1ANGLE] = TurnToAngle(vars[CANNON1ANGLE], Angle(vars[CANNON1X]+8, vars[CANNON1Y]+8, (Link->X+vars[CANNON1X])/3, Link->Y), 5);
						vars[CANNON2ANGLE] = TurnToAngle(vars[CANNON2ANGLE], Angle(vars[CANNON2X]+8, vars[CANNON2Y]+8, (Link->X+vars[CANNON2X])/3, Link->Y), 5);
						vars[LIGHTANGLE] = TurnToAngle(vars[LIGHTANGLE], Angle(vars[LIGHTX], vars[LIGHTY], Link->X, Link->Y), 5);
						
						++sineTime;
						sineTime %= 360;
						vars[TANKX] = -2+2*Sin(sineTime*2);
						G[G_GRAYHEALTHBAR] = 1;
						DNWaitframe(this, ghost, vars, 1);
					}
					int numBombs = 6;
					if(IsEasyMode())
						numBombs = 4;
					for(i=0; i<numBombs; ++i){
						e = FireEWeapon(EW_PHYSICAL, vars[CANNON2X]+8, vars[CANNON2Y]+8, DegtoRad(vars[CANNON2ANGLE]), 200, ghost->WeaponDamage*0.75, SPR_LOBBOMB, SFX_CANNON, EWF_UNBLOCKABLE|EWF_SHADOW);
						RunEWeaponScript(e, "LobBombEW", {2.4, 200+EasyModeFrames(-50)});
						e = FireEWeapon(EW_PHYSICAL, vars[CANNON1X]+8, vars[CANNON1Y]+8, DegtoRad(vars[CANNON1ANGLE]), 200, ghost->WeaponDamage*0.75, SPR_LOBBOMB, SFX_CANNON, EWF_UNBLOCKABLE|EWF_SHADOW);
						RunEWeaponScript(e, "LobBombEW", {2.4, 200+EasyModeFrames(-50)});
						for(j=0; j<64+EasyModeFrames(32); ++j){
							vars[CANNON1ANGLE] = TurnToAngle(vars[CANNON1ANGLE], Angle(vars[CANNON1X]+8, vars[CANNON1Y]+8, (Link->X+vars[CANNON1X])/3, Link->Y), 5);
							vars[CANNON2ANGLE] = TurnToAngle(vars[CANNON2ANGLE], Angle(vars[CANNON2X]+8, vars[CANNON2Y]+8, (Link->X+vars[CANNON2X])/3, Link->Y), 5);
							vars[LIGHTANGLE] = TurnToAngle(vars[LIGHTANGLE], Angle(vars[LIGHTX], vars[LIGHTY], Link->X, Link->Y), 5);
							
							++sineTime;
							sineTime %= 360;
							vars[TANKX] = -2+2*Sin(sineTime*2);
							G[G_GRAYHEALTHBAR] = 1;
							DNWaitframe(this, ghost, vars, 1);
						}
					}
					ghost->CollDetection = true;
					attackDelay = 120;
				}
				else if(attack==4){ //Big dash
					Ghost_Data = combo+1;
					for(i=0; i<16; ++i){
						++sineTime;
						sineTime %= 360;
						vars[TANKX] = -2+2*Sin(sineTime*2);
						DNWaitframe(this, ghost, vars, 1);
					}
					Ghost_Data = combo;
					for(i=0; i<48; ++i){
						++sineTime;
						sineTime %= 360;
						vars[TANKX] = -2-i+2*Sin(sineTime*2);
						DNWaitframe(this, ghost, vars, 1);
					}
					vars[TANKSPEED] = 0;
					vars[TREADSMOVING] = 0;
					vars[DRILLACTIVE] = 1;
					for(i=0; i<64; ++i){
						// ++sineTime;
						// sineTime %= 360;
						// vars[TANKX] = -2-i+2*Sin(sineTime*2);
						DNWaitframe(this, ghost, vars, 1);
					}
					vars[TREADSMOVING] = 1;
					for(i=0; i<48; i+=2){
						vars[TANKSPEED] = Min(vars[TANKSPEED]+0.1, 4);
						++sineTime;
						sineTime %= 360;
						vars[TANKX] = -2-48+i+2*Sin(sineTime*2);
						DNWaitframe(this, ghost, vars, 1);
					}
					vars[TANKSPEED] = 0;
					vars[TREADSMOVING] = 0;
					vars[DRILLACTIVE] = 0;
					int rockDelay = 24;
					if(IsEasyMode())
						rockDelay = 32;
					for(i=0; i<8*rockDelay; ++i){
						Screen->Quake = 10;
						LoopingSFX(sfxQuake, 40, 74);
						if(i%rockDelay==0){
							e = FireBigEWeapon(EW_PHYSICAL, Rand(64, 224)-8, Rand(48, 112)-8, 0, 0, ghost->WeaponDamage, 105, SFX_FALL, EWF_UNBLOCKABLE, 2, 2);
							e->MoveFlags[WPNMV_OBEYS_GRAVITY] = true;
							RunEWeaponScript(e, "FallingBoulder", {0});
							e->Z = 176;
						}
						DNWaitframe(this, ghost, vars, 1);
					}
					for(i=0; i<64; ++i){
						DNWaitframe(this, ghost, vars, 1);
					}
					vars[TANKSPEED] = 0.5;
					vars[TREADSMOVING] = 1;
					attackDelay = 60;
				}
				if(spawnBomb){ //Just this once there's refunds
					m = Choose(0, 1);
					for(i=0; i<40; ++i){
						if(m==0)
							vars[CANNON1ANGLE] = TurnToAngle(vars[CANNON1ANGLE], Angle(vars[CANNON1X]+8, vars[CANNON1Y]+8, Link->X, Link->Y), 5);
						else
							vars[CANNON2ANGLE] = TurnToAngle(vars[CANNON2ANGLE], Angle(vars[CANNON2X]+8, vars[CANNON2Y]+8, Link->Y, Link->Y), 5);
						
						++sineTime;
						sineTime %= 360;
						vars[TANKX] = -2+2*Sin(sineTime*2);
						DNWaitframe(this, ghost, vars, 1);
					}
					if(m==0){
						e = FireEWeapon(EW_PHYSICAL, vars[CANNON1X]+8, vars[CANNON1Y]+8, DegtoRad(vars[CANNON1ANGLE]), 400, ghost->WeaponDamage, 106, SFX_CANNON, EWF_UNBLOCKABLE|EWF_SHADOW);
						RunEWeaponScript(e, "LobBombEW", {3.2, -1});
					}
					else{
						e = FireEWeapon(EW_PHYSICAL, vars[CANNON2X]+8, vars[CANNON2Y]+8, DegtoRad(vars[CANNON2ANGLE]), 400, ghost->WeaponDamage, 106, SFX_CANNON, EWF_UNBLOCKABLE|EWF_SHADOW);
						RunEWeaponScript(e, "LobBombEW", {3.2, -1});
					}
					for(j=0; j<32; ++j){
						vars[CANNON1ANGLE] = TurnToAngle(vars[CANNON1ANGLE], 0, 5);
						vars[CANNON2ANGLE] = TurnToAngle(vars[CANNON2ANGLE], 0, 5);
						vars[LIGHTANGLE] = TurnToAngle(vars[LIGHTANGLE], Angle(vars[LIGHTX], vars[LIGHTY], Link->X, Link->Y), 5);
						
						++sineTime;
						sineTime %= 360;
						vars[TANKX] = -2+2*Sin(sineTime*2);
						DNWaitframe(this, ghost, vars, 1);
					}
				}
				if(phase==1&&vars[LIGHTON]){
					Game->PlaySound(102);
					vars[LIGHTON] = 0;
				}
			}
			++sineTime;
			sineTime %= 360;
			vars[TANKX] = -2+2*Sin(sineTime*2);
			DNWaitframe(this, ghost, vars, 1);
		}
	}
	void DNExplode(ffc this, npc ghost, untyped vars)
	{
		lweapon explosion;
		int baseX=Ghost_X+ghost->DrawXOffset;
		int baseY=(Ghost_Y+ghost->DrawYOffset)-(Ghost_Z+ghost->DrawZOffset);
		
		__DeathAnimStart(this, ghost);
		__DeathAnimSFX(ghost->ID, ghost->X);
		
		DeathAnimCleanup(ghost);
		
		int i; int j;
		ghost->CollDetection = false;
		vars[TANKSPEED] = 1;
		vars[TREADSMOVING] = 1;
		vars[DRILLACTIVE] = 0;
		while(vars[SCROLLX]!=0){
			vars[SCROLLX] = Floor(vars[SCROLLX]);
			if(j%16==0){
				explosion=Screen->CreateLWeapon(LW_BOMBBLAST);
				explosion->X=vars[TANKX]+Rand(0, 64);
				explosion->Y=48+Rand(0, 64);
				explosion->CollDetection=false;
			}
			++j;
			DNWaitframe(this, ghost, vars, 1);
		}
		vars[TANKSPEED] = 0;
		vars[TREADSMOVING] = 0;
		for(i=0; i<15*16; ++i){
			if(j%16==0){
				explosion=Screen->CreateLWeapon(LW_BOMBBLAST);
				explosion->X=vars[TANKX]+Rand(0, 64);
				explosion->Y=48+Rand(0, 64);
				explosion->CollDetection=false;
			}
			++j;
			DNWaitframe(this, ghost, vars, 1);
		}
		Game->PlaySound(75);
		Game->PlayMIDI(0);
		for(i=1; i<256; i*=1.5){
			DarkRoom_AddLight(Ghost_X+8, Ghost_Y+8, 0, i+16, 1, 0, 0.01, 64);
			Screen->Circle(6, Ghost_X+8, Ghost_Y+8, i, 0x01, 1, 0, 0, 0, true, 128);
			DNWaitframe(this, ghost, vars, 1);
		}
		Ghost_Data = 1;
		
		ffc Esan = FindFreeFFC();
		Esan->X = 32;
		Esan->Y = 48;
		Esan->Data = 33881;
		Esan->TileWidth = 2;
		Esan->TileHeight = 2;
		
		ffc KO = FindFreeFFC();
		KO->X = 44;
		KO->Y = 45;
		KO->Data = 32857;
		KO->CSet = 8;
		KO->Flags[FFCF_OVERLAY] = true;
		
		for(i=256; i>0; i-=8){
			DarkRoom_AddLight(Ghost_X+8, Ghost_Y+8, 0, i+16, 1, 0, 0.01, 64);
			Screen->Circle(6, Ghost_X+8, Ghost_Y+8, i, 0x01, 1, 0, 0, 0, true, 128);
			Ghost_WaitframeLight(this, ghost);
		}
		
		__DeathAnimEnd(this, ghost);
		Screen->State[ST_SECRET] = true;
		Game->PlaySound(SFX_FALL);
		for(i=176; i>0; i-=8){
			Link->X = Min(Link->X, 208);
			Screen->DrawLayer(4, 20, 0x6F, 0, 0, -i, 0, 128);
			Waitframe();
		}
		Screen->TriggerSecrets();
		Game->PlaySound(3);
		Screen->Quake= 10;
	}
	void DNWaitframe(ffc this, npc ghost, untyped vars, int frames){
		int anims = vars[ANIMS];
		int sfxTreads = anims[0];
		int sfxDrill = anims[1];
		int x; int y;
		int combo = ghost->Attributes[10];
		for(int i=0; i<frames; ++i){
			int speed = vars[TANKSPEED]*EasyModeMultiplier(0.8);
			
			if(vars[TREADSMOVING])
				LoopingSFX(sfxTreads, 25, 103);
			if(vars[DRILLACTIVE])
				LoopingSFX(sfxDrill, 6, 104);
			vars[SCROLLX] -= speed;
			if(vars[SCROLLX]<0){
				if(vars[DEATHANIMACTIVE])
					vars[SCROLLX] = 0; //This is calculated differently during the death animation so it doesn't run forever on easy mode
				else
					vars[SCROLLX] += 256;
			}
			x = Floor(vars[SCROLLX]);
			
			vars[WPNPUSH] += vars[TANKSPEED]; //This isn't affected by easy mode scaling on the boss's speed because that'd work against the player
			if(vars[WPNPUSH]>=1){
				for(int j=Screen->NumLWeapons(); j>0; --j){
					lweapon l = Screen->LoadLWeapon(j);
					if(l->Z==0){
						if(l->ID==LW_LOBBOMB){
							l->X -= Floor(vars[WPNPUSH]);
							if(l->X<vars[TANKX]+24)
								l->Misc[LWM_INSTANTDETONATE] = 1;
						}
						else if(l->ID==LW_FIRE){
							l->X -= Floor(vars[WPNPUSH]);
						}
					}
				}
				for(int j=Screen->NumItems(); j>0; --j){
					itemsprite itm = Screen->LoadItem(j);
					if(itm->Z==0){
						itm->X -= Floor(vars[WPNPUSH]);
					}
				}
				vars[WPNPUSH] -= Floor(vars[WPNPUSH]);
			}
			LinkMovement_Push2(-speed, 0);
			
			Screen->DrawScreen(1, Game->GetCurMap(), Game->GetCurScreen(), x, 0, 0);
			Screen->DrawScreen(1, Game->GetCurMap(), Game->GetCurScreen(), x-256, 0, 0);
			
			int tankX = Floor(vars[TANKX]);
			Screen->DrawCombo(2, tankX+80-208+vars[DRILLEXTEND], 64, combo+5+vars[DRILLACTIVE], 15, 3, 11, -1, -1, 0, 0, 0, -1, 0, true, 128);
			Screen->DrawCombo(2, tankX, 48, combo+2, 5, 5, 11, -1, -1, 0, 0, 0, -1, 0, true, 128);
			Screen->DrawCombo(2, tankX, 32, combo+3+vars[TREADSMOVING], 5, 1, 11, -1, -1, 0, 0, 0, -1, 2, true, 128);
			Screen->DrawCombo(2, tankX, 128, combo+3+vars[TREADSMOVING], 5, 1, 11, -1, -1, 0, 0, 0, -1, 0, true, 128);
			vars[LIGHTX] = tankX+36+VectorX(4, vars[LIGHTANGLE]);
			vars[LIGHTY] = 80+VectorY(4, vars[LIGHTANGLE]);
			Screen->DrawCombo(2, vars[LIGHTX], vars[LIGHTY], combo+7+vars[LIGHTON], 1, 1, 11, -1, -1, vars[LIGHTX], vars[LIGHTY], vars[LIGHTANGLE], -1, 0, true, 128);
			DarkRoom_AddLight(Ghost_X+8, Ghost_Y+8, 0, 40+EasyModeFrames(12), 1, 0, 0.01, 64);
			if(vars[LIGHTON]){
				DarkRoom_AddLight(vars[LIGHTX]+8, vars[LIGHTY]+8, 1, 192, 0.5, vars[LIGHTANGLE], 0.01, 64);
			}
			
			vars[CANNON1X] = tankX+16;
			vars[CANNON1Y] = 104;
			Screen->DrawCombo(2, vars[CANNON1X], vars[CANNON1Y], combo+9, 2, 2, 11, -1, -1, vars[CANNON1X], vars[CANNON1Y], vars[CANNON1ANGLE], -1, 0, true, 128);
			vars[CANNON2X] = tankX+16;
			vars[CANNON2Y] = 32;
			Screen->DrawCombo(2, vars[CANNON2X], vars[CANNON2Y], combo+9, 2, 2, 11, -1, -1, vars[CANNON2X], vars[CANNON2Y], vars[CANNON2ANGLE], -1, 0, true, 128);
			Ghost_X = Max(tankX+11, -64);
			Ghost_Y = 77;
			ghost->DrawYOffset = -1000;
			Screen->FastCombo(2, Ghost_X, Ghost_Y, Ghost_Data, 11, 128);
			int oldcracks = vars[CRACKS];
			vars[CRACKS] = 0;
			if(Ghost_HP<vars[INITHP]*0.25)
				vars[CRACKS] = 3;
			else if(Ghost_HP<vars[INITHP]*0.5)
				vars[CRACKS] = 2;
			else if(Ghost_HP<vars[INITHP]*0.75)
				vars[CRACKS] = 1;
			if(vars[CRACKS]>oldcracks){
				Game->PlaySound(105);
			}
			if(vars[CRACKS]){
				Screen->DrawCombo(2, tankX+3, 65, combo+11+vars[CRACKS]-1, 2, 2, 11, -1, -1, 0, 0, 0, -1, 0, true, 128);
			}
			if(Ghost_GotHit()){
				vars[FLASHFRAMES] = 32;
			}
			if(vars[FLASHFRAMES]){
				--vars[FLASHFRAMES];
				if(vars[FLASHFRAMES]%4<2)
					Screen->DrawCombo(2, tankX+3, 65, combo+10, 2, 2, 11, -1, -1, 0, 0, 0, -1, 0, true, 128);
			}
			if(!vars[DEATHANIMACTIVE]){
				MakeHitbox(EW_PHYSICAL, tankX, 48, 80, 80, ghost->Damage);
				MakeHitbox(EW_PHYSICAL, tankX+80-208+vars[DRILLEXTEND], 72, 240, 32, ghost->Damage);
			}
			SolidObjects_Add(0, tankX, 48, 64, 80, 0, 0, 0);
			if(vars[DEATHANIMACTIVE]){
				Ghost_WaitframeLight(this, ghost);
			}
			else if(!SSGhost_Waitframe(this, ghost, false, false)){
				vars[DEATHANIMACTIVE] = 1;
				DNExplode(this, ghost, vars);
				Quit();
			}
		}
	}
}

const int TIL_PLAYERLEVITATED = 105323;
const int TIL_PLAYERCROUCH = 105320;
const int TIL_PLAYERLEVITATEDALT = 105449;
const int TIL_PLAYERCROUCHALT = 105489;

const int SELET_PERCENT_PHASE1 = 0.75;
const int SELET_PERCENT_PHASE2 = 0.50;
const int SELET_PERCENT_PHASE3 = 0.10;
const int SELET_PERCENT_PHASE4 = 0.40;

const int SFX_SELETCLAW = 138;

ffc script SeletEventBoss{
	//vars
	const int BITMAP = 0;
	const int NUMHITS = 1;
	const int INITHP = 2;
	const int CASTINGSTELLAR = 3;
	const int PHASE4LOCK = 4;
	
	//blockData
	const int FIRSTCHECK = 0;
	const int NUMVALID = 1;
	
	const int ATK_GRAB = -999;
	const int ATK_BATTERYEXPAND = 1;
	const int ATK_BATTERYFLASH = 2;
	const int ATK_BATTERYEXPANDTRI = 3;
	const int ATK_BATTERYLIGHTNING = 4;
	const int ATK_BATTERYSTELLARSWORD = 5;
	const int ATK_BATTERYMETEOR = 6;
	const int ATK_SLASHSIDE = 8;
	const int ATK_SLASHCIRCLE = 9;
	const int ATK_SLASHREPEAT = 10; //Teleport to one side, then do several swipes with alternating patterns while moving across the screen
	const int ATK_SLASHDASH = 11; //Dash towards Link, create three slash marks that converge in front
	const int ATK_SLASHTRIANGLE = 12; //Shoot a triangle of slashes outwards that converge inwards in a spiral pattern and end on a shorter SLASHCIRCLE
	const int ATK_CUTTERSTREAM = 13;
	const int ATK_CUTTERALTERNATING = 14; 
	const int ATK_CUTTERSIDEDASH = 15;
	const int ATK_CUTTERBATTERY = 16;
	const int ATK_BLOCKHV = 17;
	const int ATK_BLOCKBIG = 18;
	const int ATK_BLOCKX4 = 19;
	const int ATK_BLOCKHV2 = 20;
	const int ATK_PHASETRANS1 = 100;
	const int ATK_PHASETRANS2 = 101;
	const int ATK_FINISHER = 102;
	
	void run(int enemyid){
		int i; int j; int k; int m; int o;
		int mi[16];
		int x; int y;
		int angle; int dist; int pos;
		int altLinkTile = 0;
		int xy[2]; int xy2[2];
		eweapon e;
		eweapon eArr[16];
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		ghost->Immortal = true;
		Ghost_SetFlag(GHF_4WAY);
		Ghost_Transform(this, ghost, -1, -1, 1, 2);
		Ghost_SetHitOffsets(ghost, 0, 16, 0, 0);
		ghost->DrawYOffset -= 16;
		int isFinal = ghost->Attributes[0];
		int combo = ghost->Attributes[10];
		int bitid = TempBitmap_Create(0, 18, 33);
		bitmap shadow = TempBMP[bitid];
		Ghost_HP *= EasyModeMultiplier(0.75);
		ghost->HP = Ghost_HP;
		int initHP = Ghost_HP;
		untyped vars[16];
		vars[BITMAP] = shadow;
		vars[INITHP] = initHP;
		int phase;
		int walkFrames;
		int walkStyle;
		int walkAngle;
		int attackDelay = 60;
		int attack;
		int attackCycle;
		int blockCycle;
		int grabCooldown;
		bool grabbed;
		bool grabkilled;
		
		if(!isFinal){
			Ghost_X = 160;
			Ghost_Y = 80;
			Ghost_Dir = DIR_LEFT;
		}
		else{
			Ghost_X = 120;
			Ghost_Y = 64;
			Ghost_Dir = DIR_DOWN;
		}
		
		lweapon validBlocks[18];
		int validIndex[18];
		int validDirs[18];
		int validPos[18];
		bool inUse[18];
		int blockPaths[176];
		untyped blockData[] = {false, 0, validBlocks, validIndex, validDirs, validPos, inUse, blockPaths};
		int telekinesisPos[18] = {34, 44, 114, 124, 36, 37, 38, 41, 66, 82, 98, 77, 93, 109, 134, 137, 138, 139};
		lweapon telekinesisObjects[18];
		if(!isFinal){
			for(i=0; i<18; ++i){
				telekinesisObjects[i] = CreateLWeaponAt(EW_SCRIPT10, ComboX(telekinesisPos[i]), ComboY(telekinesisPos[i]));
				telekinesisObjects[i]->DrawYOffset = -1000;
				telekinesisObjects[i]->CollDetection = false;
				telekinesisObjects[i]->Script = Game->GetLWeaponScript("SeletTelekinesis");
				telekinesisObjects[i]->InitD[0] = 1;
				telekinesisObjects[i]->InitD[1] = 1;
				if(i<4){
					telekinesisObjects[i]->InitD[0] = 2;
					telekinesisObjects[i]->InitD[1] = 2;
					telekinesisObjects[i]->HitWidth = 32;
					telekinesisObjects[i]->HitHeight = 32;
				}
				telekinesisObjects[i]->Damage = ghost->WeaponDamage;
			}
		}
		
		// if(isFinal)
			// Game->PlayEnhancedMusic("SS-FinalBoss.ogg", 0);
		// else
			// Game->PlayEnhancedMusic("SS-Selet.ogg", 0);
		while(false){ //Debug Loop
			SE_Wallhack(true);
			pos = SE_FindSafeSpot(blockPaths);
			Ghost_Data = combo+4;
			while(Ghost_X<64||Ghost_X>176||Ghost_Y<64||Ghost_Y>96){
				Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, 120, 80), 1, 0);
				Ghost_FaceLink(ghost);
				SE_Waitframe(this, ghost, vars, 1);
			}
			
			blockData[FIRSTCHECK] = false;
			blockData[NUMVALID] = 0;
			
			for(i=0; i<4; ++i){
				SE_ActivateMovingBlock(telekinesisObjects, blockData, 0, 1, 0);
				SE_ActivateMovingBlock(telekinesisObjects, blockData, 0, 2, 0);
			}
			
			pos = SE_FindSafeSpot(blockPaths);
			x = ComboX(pos);
			y = ComboY(pos);
			Ghost_SetFlag(GHF_IGNORE_ALL_TERRAIN);
			Ghost_SetFlag(GHF_IGNORE_NO_ENEMY);
			while(Distance(Ghost_X, Ghost_Y, x, y)>1){
				for(i=0; i<176; ++i){
					Screen->DrawInteger(6, ComboX(i), ComboY(i), FONT_Z3SMALL, 0x01, 0x0F, -1, -1, blockPaths[i], 0, 128);
					Screen->DrawInteger(6, ComboX(i), ComboY(i)+6, FONT_Z3SMALL, 0x01, 0x0F, -1, -1, Screen->ComboF[i], 0, 128);
				}
				Screen->FastTile(6, x, y, Link->Tile, 6, 128);
				Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, x, y), 1, 0);
				Ghost_FaceLink(ghost);
				SE_Waitframe(this, ghost, vars, 1);
			}
			SE_Wallhack(false);
			Ghost_Data = combo;
			
			for(i=0; i<128; ++i){
				Ghost_FaceLink(ghost);
				SE_Waitframe(this, ghost, vars, 1);
			}
			
			SE_ActivateMovingBlock(telekinesisObjects, blockData, 1, 0, 0);
			
			for(i=0; i<180; ++i){
				Ghost_FaceLink(ghost);
				SE_Waitframe(this, ghost, vars, 1);
			}
			
			// eweapon e = FireAimedEWeapon(EW_LUNAR, Ghost_X, Ghost_Y, 0, 50, ghost->WeaponDamage, 0, 0, EWF_UNBLOCKABLE);
			// RunEWeaponScript(e, "SlowHomingSickle", {1, 45, 250});
		}
		
		phase = 0;
		if(isFinal){
			phase = 3;
			vars[PHASE4LOCK] = 1;
			RunFFCScript(Game->GetFFCScript("HealthBar_Tiled_Single"), {ghost->ID, 69, 0, 1});
		}
		while(true){
			if(phase==0){
				if(walkStyle==0){
					Ghost_FaceLink(ghost);
					Ghost_Data = combo+12;
					walkFrames = (walkFrames+4)%360;
					Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y), 0.3+0.3*Sin(walkFrames), 0);
				}
				else{
					Ghost_FaceLink(ghost);
					Ghost_Data = combo;
				}
				if(Ghost_GotHit())
					attackDelay = Min(attackDelay, 16);
			}
			else if(phase==1){
				if(walkStyle==0){
					Ghost_FaceLink(ghost);
					Ghost_Data = combo+4;
					if(walkFrames>0){
						Ghost_MoveAtAngle(walkAngle, Lerp(0, 2, walkFrames/32), 0);
						--walkFrames;
					}
					else{
						walkAngle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y)+Choose(-80, 80);
						walkFrames = 32;
					}
				}
				else{
					Ghost_FaceLink(ghost);
					Ghost_Data = combo+12;
					walkFrames = (walkFrames+4)%360;
					Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y), 0.3+0.3*Sin(walkFrames), 0);
				}
				if(Ghost_GotHit())
					attackDelay = Min(attackDelay, 16);
			}
			else if(phase==2||phase==3){
				if(walkStyle==0){ //Teleport
					Ghost_Data = combo;
					Ghost_FaceLink(ghost);
					if(Distance(Ghost_X, Ghost_Y, Link->X, Link->Y)<40){
						i = FarthestCombo(Ghost_X, Ghost_Y, {70, 73, 84, 91, 102, 105});
						SE_Teleport(this, ghost, vars, 16, 3, ComboX(i), ComboY(i));
					}
					else{
						angle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
						xy[0] = Ghost_X;
						xy[1] = Ghost_Y;
						Ghost_X = Link->X;
						Ghost_Y = Link->Y;
						Ghost_MoveAtAngle(angle, 24, 0);
						x = Ghost_X;
						y = Ghost_Y;
						Ghost_X = xy[0];
						Ghost_Y = xy[1];
						SE_Teleport(this, ghost, vars, 16, 3, x, y);
					}
					attackDelay = 0;
				}
				else if(walkStyle==1){ //Chase
					Ghost_Data = combo+4;
					for(i=0; i<120; ++i){
						Ghost_FaceLink(ghost);
						walkAngle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
						if(Distance(Ghost_X, Ghost_Y, Link->X, Link->Y)>64){
							Ghost_MoveAtAngle(walkAngle, 3, 0);
						}
						else if(Distance(Ghost_X, Ghost_Y, Link->X, Link->Y)>8){
							Ghost_MoveAtAngle(walkAngle, 0.75, 0);
						}
						SE_Waitframe(this, ghost, vars, 1);
					}
					attackDelay = 0;
				}
				else if(walkStyle==2){ //Sidestep
					Ghost_Data = combo+4;
					for(i=Choose(2, 4); i>0; --i){
						walkAngle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y)+Choose(-80, 80);
						for(j=0; j<32; ++j){
							Ghost_MoveAtAngle(walkAngle, Lerp(2, 0, j/32), 0);
							Ghost_FaceLink(ghost);
							SE_Waitframe(this, ghost, vars, 1);
						}
					}
					attackDelay = 0;
				}
			}
			else if(phase==4){
				attackDelay = 0;
			}
			if(attackDelay)
				--attackDelay;
			else if(Rand(16)==0||phase>=2){
				if(phase==0){
					if(attackCycle==0)
						attack = Choose(ATK_SLASHSIDE, ATK_SLASHCIRCLE);
					else if(attackCycle==1)
						attack = ATK_BATTERYEXPAND;
					else if(attackCycle==2)
						attack = ATK_CUTTERSTREAM;
					else
						attack = ATK_BATTERYFLASH;
					
					++attackCycle;
					if(attackCycle>=4)
						attackCycle = 0;
				}
				else if(phase==1){
					if(blockCycle==1)
						attack = ATK_BLOCKHV;
					else if(blockCycle==3)
						attack = ATK_BLOCKBIG;
					else{
						if(attackCycle==0)
							attack = Choose(ATK_CUTTERALTERNATING, ATK_CUTTERBATTERY);
						else if(attackCycle==1)
							attack = Choose(ATK_SLASHCIRCLE, ATK_SLASHREPEAT);
						else
							attack = ATK_BATTERYEXPAND;
						
						++attackCycle;
						if(attackCycle>=3)
							attackCycle = 0;
					}
					
					++blockCycle;
					if(blockCycle>=5)
						blockCycle = 0;
				}
				else if(phase==2){
					if(blockCycle==1)
						attack = ATK_BLOCKHV2;
					else if(blockCycle==3)
						attack = ATK_BLOCKX4;
					else if(blockCycle==7)
						attack = Choose(ATK_BLOCKHV2, ATK_BLOCKX4);
					else{
						if(attackCycle==0)
							attack = Choose(ATK_CUTTERALTERNATING, ATK_CUTTERSIDEDASH);
						else if(attackCycle==1)
							attack = Choose(ATK_SLASHDASH, ATK_SLASHTRIANGLE);
						else
							attack = ATK_BATTERYEXPAND;
						
						++attackCycle;
						if(attackCycle>=3)
							attackCycle = 0;
					}
					
					++blockCycle;
					if(blockCycle>=8)
						blockCycle = 0;
				}
				else if(phase==3){
					if(attackCycle==0)
						attack = Choose(ATK_CUTTERALTERNATING, ATK_CUTTERSIDEDASH);
					else if(attackCycle==1)
						attack = Choose(ATK_SLASHDASH, ATK_SLASHTRIANGLE, ATK_BATTERYSTELLARSWORD);
					else if(attackCycle==2)
						attack = Choose(ATK_BATTERYLIGHTNING, ATK_BATTERYEXPANDTRI);
					else if(attackCycle==3)
						attack = ATK_PHASETRANS1;
					else if(attackCycle==4)
						attack = Choose(ATK_BATTERYLIGHTNING, ATK_SLASHCIRCLE);
					
					++attackCycle;
					if(attackCycle>=5)
						attackCycle = 0;
				}
				else if(phase==4){
					if(attackCycle==0)
						attack = Choose(ATK_BATTERYLIGHTNING, ATK_CUTTERSIDEDASH);
					else if(attackCycle==1)
						attack = Choose(ATK_BATTERYSTELLARSWORD, ATK_SLASHTRIANGLE);
					else if(attackCycle==2)
						attack = Choose(ATK_BATTERYLIGHTNING, ATK_SLASHDASH);
					else if(attackCycle==3)
						attack = Choose(ATK_BATTERYEXPANDTRI, ATK_CUTTERALTERNATING);
					else if(attackCycle==4)
						attack = ATK_BATTERYSTELLARSWORD;
					else if(attackCycle==5)
						attack = ATK_PHASETRANS2;
					
					++attackCycle;
					if(attackCycle>=6)
						attackCycle = 0;
				}
				
				// if(grabCooldown)
					// --grabCooldown;
				// else if(Distance(Ghost_X, Ghost_Y, Link->X, Link->Y)<32){
					// attack = 0;
				// }
				
				if(phase==0&&Ghost_HP<initHP*SELET_PERCENT_PHASE1){
					attack = ATK_PHASETRANS1;
					phase = 1;
				}
				else if(phase==1&&Ghost_HP<initHP*SELET_PERCENT_PHASE2){
					attack = ATK_PHASETRANS2;
					phase = 2;
				}
				else if(phase==2&&Ghost_HP<=initHP*SELET_PERCENT_PHASE3){
					attack = ATK_FINISHER;
					phase = 3;
				}
				else if(phase==3&&Ghost_HP<=initHP*SELET_PERCENT_PHASE4){
					phase = 4;
					attack = ATK_BATTERYMETEOR;
				}
				
				if(attack==ATK_GRAB){ //Grab (Deprecated)
					attackDelay = 120;
					grabCooldown = 5;
					Ghost_Data = combo+20;
					for(i=0; i<32; ++i){
						Ghost_FaceLink(ghost);
						GetDirXYOffset(xy, Ghost_Dir, {9,-7, 7,-5, 5,-5, 10,-5});
						SE_CastingCircle(ghost, vars);
						//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
						SE_Waitframe(this, ghost, vars, 1);
					}
					grabbed = false;
					Ghost_Data = combo+16;
					for(i=0; i<8&&!grabbed; ++i){
						Ghost_FaceLink(ghost);
						Ghost_MoveTowardLink(2, 0);
						GetDirXYOffset(xy, Ghost_Dir, {9,-7, 7,-5, 5,-5, 10,-5}); //Reach up
						GetDirXYOffset(xy2, Ghost_Dir, {13,1, 8,12, 1,7, 14,7}); //Reach forward
						x = Ghost_X+Lerp(xy[0], xy2[0], i/8)+Rand(-1, 1);
						y = Ghost_Y+Lerp(xy[1], xy2[1], i/8)+Rand(-1, 1);
						Screen->Circle((Ghost_Dir==DIR_UP)?2:4, x, y, 2+(i/8)*6+((i%6<4)?0:4)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
						if(Distance(x, y, Link->X+8, Link->Y+8)<12)
							grabbed = true;
						SE_Waitframe(this, ghost, vars, 1);
					}
					for(i=0; i<8&&!grabbed; ++i){
						x = Ghost_X+xy2[0]+Rand(-1, 1)+DirX(Ghost_Dir, 8*(i/8));
						y = Ghost_Y+xy2[1]+Rand(-1, 1)+DirY(Ghost_Dir, 8*(i/8));
						Screen->Circle((Ghost_Dir==DIR_UP)?2:4, x, y, 8+((i%6<4)?0:4)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
						if(Distance(x, y, Link->X+8, Link->Y+8)<12)
							grabbed = true;
						SE_Waitframe(this, ghost, vars, 1);
					}
					if(grabbed){
						Ghost_Dir = DIR_DOWN;
						Ghost_Data = combo+16;
						Ghost_X = Clamp(Ghost_X, 32, 208-8);
						Ghost_Y = Clamp(Ghost_Y, 32, 128-8);
						Link->X = Ghost_X+8;
						Link->Y = Ghost_Y+8;
						altLinkTile = 105320;
						if(GetCharID()==CHAR_TORRIN)
							altLinkTile += 2;
						else if(GetCharID()==CHAR_KAYLANI)
							altLinkTile += 4;
						for(i=0; i<32; ++i){
							Link->X = Ghost_X+8;
							Link->Y = Ghost_Y+8;
							TurnOffLinkCollision(2);
							SetLinkScriptTile(altLinkTile, 0, 2);
							NoAction();
							SE_Waitframe(this, ghost, vars, 1);
						}
						Ghost_Data = combo+20;
						GetDirXYOffset(xy, Ghost_Dir, {9,-7, 7,-5, 5,-5, 10,-5});
						e = CreateEWeaponAt(EW_SCRIPT10, Link->X, Link->Y);
						e->DrawYOffset = -1000;
						e->CollDetection = false;
						RunEWeaponScript(e, "GenParticle", {GP_PIXELDRAIN, Link->X, Link->Y, Ghost_X+xy[0], Ghost_Y+xy[1], 120, 128});
						for(i=0; i<128; ++i){
							if(i%8==0){
								Game->PlaySound(SFX_OUCH);
								if(Link->HP>1)
									--Link->HP;
								if(Link->MP>0)
									Link->MP = Max(Link->MP-12, 0);
							}
							Link->X = Ghost_X+8;
							Link->Y = Ghost_Y+8;
							Screen->Circle(4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
							TurnOffLinkCollision(2);
							SetLinkScriptTile(altLinkTile, 0, 2);
							NoAction();
							SE_Waitframe(this, ghost, vars, 1);
						}
						Ghost_Data = combo+24;
						Game->PlaySound(SFX_FALL);
						for(i=0; i<16; ++i){
							Ghost_MoveXY(0, -1, 0);
							LinkMovement_Push2(0, 2);
							TurnOffLinkCollision(2);
							SetLinkScriptTile(altLinkTile, 0, 2);
							NoAction();
							SE_Waitframe(this, ghost, vars, 1);
						}
					}
					else{
						for(i=0; i<4&&!grabbed; ++i){
							Screen->Circle((Ghost_Dir==DIR_UP)?2:4, x, y, 8-2*i, Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
							SE_Waitframe(this, ghost, vars, 1);
						}
					}
				}
				else if(attack==ATK_BATTERYEXPAND){ //Battery (Bigshot)
					SE_UseBattery(this, ghost, vars, 32+EasyModeFrames(32), phase<1?1:2);
					attackDelay = 60;
				}
				else if(attack==ATK_BATTERYFLASH){ //Battery (Flash)
					SE_UseBattery(this, ghost, vars, 32+EasyModeFrames(16), 0);
					attackDelay = 60;
					if(phase==0){
						angle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y)+Choose(-70, 70);
						for(i=0; i<32; ++i){
							Ghost_FaceLink(ghost);
							Ghost_MoveAtAngle(angle, 1.5, 0);
							SE_Waitframe(this, ghost, vars, 1);
						}
					}
				}
				else if(attack==ATK_BATTERYEXPANDTRI){ //Battery (Tri)
					SE_UseBattery(this, ghost, vars, 32+EasyModeFrames(16), 4);
					attackDelay = 60;
				}
				else if(attack==ATK_BATTERYLIGHTNING){ //Battery (Lightning)
					SE_UseBattery(this, ghost, vars, 32+EasyModeFrames(16), 5);
					attackDelay = 60;
				}
				else if(attack==ATK_BATTERYSTELLARSWORD){ //Battery (Stellar Sword)
					attackDelay = 60;
					if(SE_UseBattery(this, ghost, vars, 16+EasyModeFrames(16), 6)){
						j = Choose(-1, 1);
						angle = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y);
						Ghost_FaceLink(ghost);
						Game->PlaySound(SFX_STELLARSWORD_APPEAR);
						Ghost_Data = combo+16;
						for(i=0; i<5; ++i){
							for(k=0; k<2; ++k){
								DrawLightSwordSlash(Ghost_X, Ghost_Y, angle-90*j, 16, i, ghost->WeaponDamage, 0, 0);
								SE_Waitframe(this, ghost, vars, 1);
							}
						}
						for(i=0; i<64+EasyModeFrames(32); ++i){
							DrawLightSwordSlash(Ghost_X, Ghost_Y, angle-90*j, 16, 5, ghost->WeaponDamage, 0, 0);
							SE_Waitframe(this, ghost, vars, 1);
						}
						Game->PlaySound(SFX_STELLARSWORD_SLASH);
						for(i=45; i<180; i+=15){
							Ghost_MoveAtAngle(angle, 3, 0);
							DrawLightSwordSlash(Ghost_X, Ghost_Y, angle-90*j+i*j, 16, 5, ghost->WeaponDamage, j, 0);
							SE_Waitframe(this, ghost, vars, 1);
						}
						for(i=0; i>4; ++i){
							for(k=0; k<2; ++k){
								DrawLightSwordSlash(Ghost_X, Ghost_Y, angle+90*j, 16, 5, ghost->WeaponDamage, j, i);
								SE_Waitframe(this, ghost, vars, 1);
							}
						}
						if(Abs(AngDiff(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y), angle))<80){
							j = -j;
							for(i=0; i<16; ++i){
								DrawLightSwordSlash(Ghost_X, Ghost_Y, angle-90*j, 16, 5, ghost->WeaponDamage, 0, 0);
								SE_Waitframe(this, ghost, vars, 1);
							}
							Game->PlaySound(SFX_STELLARSWORD_SLASH);
							for(i=45; i<180; i+=15){
								Ghost_MoveAtAngle(angle, 4, 0);
								DrawLightSwordSlash(Ghost_X, Ghost_Y, angle-90*j+i*j, 16, 5, ghost->WeaponDamage, j, 0);
								SE_Waitframe(this, ghost, vars, 1);
							}
							for(i=0; i>4; ++i){
								for(k=0; k<2; ++k){
									DrawLightSwordSlash(Ghost_X, Ghost_Y, angle+90*j, 16, 5, ghost->WeaponDamage, j, i);
									SE_Waitframe(this, ghost, vars, 1);
								}
							}
						}
						for(i=5; i>0; --i){
							for(k=0; k<2; ++k){
								DrawLightSwordSlash(Ghost_X, Ghost_Y, angle+90*j, 16, i, ghost->WeaponDamage, 0, 0);
								SE_Waitframe(this, ghost, vars, 1);
							}
						}
						Ghost_Data = combo;
					}
				}
				else if(attack==ATK_BATTERYMETEOR){ //Battery (Meteor shower)
					attackDelay = 60;
				
					xy[0] = Ghost_X;
					xy[1] = Ghost_Y;
					Ghost_MoveAtAngle(Angle(Link->X, Link->Y, Ghost_X, Ghost_Y), 256, 0);
					if(Distance(xy[0], xy[1], Ghost_X, Ghost_Y)>64){
						x = Ghost_X;
						y = Ghost_Y;
						Ghost_X = xy[0];
						Ghost_Y = xy[1];
						SE_Teleport(this, ghost, vars, 16, 3, x, y);
					}
					else{
						Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y), 256, 0);
						x = Ghost_X;
						y = Ghost_Y;
						Ghost_X = xy[0];
						Ghost_Y = xy[1];
						SE_Teleport(this, ghost, vars, 16, 3, x, y);
					}
					
					if(SE_UseBattery(this, ghost, vars, 16+EasyModeFrames(16), 6)){
						Ghost_Data = combo+4;
						Ghost_Dir = DIR_DOWN;
						for(i=0; i<5; ++i){
							for(j=0; j<64-i*8; ++j){
								if(Abs(Ghost_X-Link->X)>2){
									Ghost_MoveXY(Sign(Link->X-Ghost_X), -2, 0);
								}
								SE_Waitframe(this, ghost, vars, 1);
							}
							Ghost_Data = combo+16;
							angle = TurnToAngle(90, Angle(Ghost_X, Ghost_Y, Link->X, Link->Y), 30);
							for(j=-1; j<=1; ++j){
								e = FireEWeapon(EW_STELLAR, Ghost_X+VectorX(16, angle)+VectorX(12*j, angle+90), Ghost_Y+VectorY(16, angle)+VectorY(12*j, angle+90), DegtoRad(angle), 0, ghost->WeaponDamage, 0, 0, 0);
								e->DrawYOffset = -1000;
								e->CollDetection = false;
								RunEWeaponScript(e, "StellarKnockbackBlast", {0, 300});
							}
							SE_Waitframe(this, ghost, vars, 8);
							Ghost_Data = combo+4;
						}
						Ghost_Data = combo+16;
						angle = 90;
						for(i=-2; i<=2; ++i){
							e = FireEWeapon(EW_STELLAR, Ghost_X, Ghost_Y, DegtoRad(angle+25*i), 300, ghost->WeaponDamage, SPR_STELLARLIGHTNING, 32, 0);
							RunEWeaponScript(e, "StellarLightning", {0});
						}
						SE_Waitframe(this, ghost, vars, 16);
						Ghost_Data = combo;
						
						if(SE_UseBattery(this, ghost, vars, 96+EasyModeFrames(48), 6)){
							SE_Waitframe(this, ghost, vars, 8);
							Ghost_Data = combo+20;
							for(i=0; i<32; ++i){
								G[G_GRAYHEALTHBAR] = 1;
								vars[CASTINGSTELLAR] = 1;
								SE_CastingCircle(ghost, vars);
								SE_Waitframe(this, ghost, vars, 1);
							}
							angle = Rand(8)*45;
							for(k=0; k<4; ++k){
								angle += Choose(90, 135);
								for(j=0; j<16; ++j){
									x = Link->X+VectorX(-128+16*j, angle);
									y = Link->Y+VectorY(-128+16*j, angle);
									if(x>=8&&x<=232&&y>=8&&y<=152){
										e = FireEWeapon(EW_STELLAR, x, y, DegtoRad(Rand(360)), 25, ghost->WeaponDamage, 0, 0, 0);
										RunEWeaponScript(e, "Meteorite", {1, 0, 0, 1.5});
										e->CollDetection = false;
										e->DrawYOffset = -1000;
									}
									for(i=0; i<4; ++i){
										G[G_GRAYHEALTHBAR] = 1;
										vars[CASTINGSTELLAR] = 1;
										SE_CastingCircle(ghost, vars);
										SE_Waitframe(this, ghost, vars, 1);
									}
								}
								for(i=0; i<16; ++i){
									G[G_GRAYHEALTHBAR] = 1;
									vars[CASTINGSTELLAR] = 1;
									SE_CastingCircle(ghost, vars);
									SE_Waitframe(this, ghost, vars, 1);
								}
							}
							Ghost_Data = combo+16;
							xy[0] = Rand(32, 208);
							xy[1] = Rand(32, 128);
							for(k=0; k<16; ++k){
								for(j=0; j<3; ++j){
									e = FireEWeapon(EW_STELLAR, Rand(8, 232), Rand(8, 152), DegtoRad(Rand(360)), 25, ghost->WeaponDamage, 0, 0, 0);
									if(j==0){
										e->X = Link->X;
										e->Y = Link->Y;
									}
									if(Distance(e->X, e->Y, xy[0], xy[1])<64){
										for(i=0; i<176&&Distance(e->X, e->Y, xy[0], xy[1])<64; ++i){
											e->X = Rand(8, 232);
											e->Y = Rand(8, 152);
										}
									}
									RunEWeaponScript(e, "Meteorite", {1, 0, 0, Choose(1, 1.5)});
									e->CollDetection = false;
									e->DrawYOffset = -1000;
									for(i=0; i<12; ++i){
										G[G_GRAYHEALTHBAR] = 1;
										vars[CASTINGSTELLAR] = 1;
										if(k<=2)
											SE_CastingCircle(ghost, vars);
										if(k>3){
											if(Distance(Ghost_X, Ghost_Y, xy[0], xy[1])>1){
												Ghost_Data = combo+4;
												Ghost_FaceLink(ghost);
												Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, xy[0], xy[1]), 0.3, 0);
											}
											else{
												Ghost_Data = 51632;
												Ghost_FaceLink(ghost);
											}
										}
										else if(k>2)
											Ghost_Data = combo;
										SE_Waitframe(this, ghost, vars, 1);
									}
								}
							}
							Ghost_Data = combo;
						}
						else{
							Ghost_Data = combo;
							SE_Waitframe(this, ghost, vars, 64);
						}
					}
					vars[PHASE4LOCK] = 0;
				}
				else if(attack==ATK_SLASHSIDE){ //Slash (Side)
					attackDelay = 60;
					Ghost_Data = combo+4;
					k = (Link->X<Ghost_X)?1:-1;
					for(i=0; i<40; ++i){
						Ghost_Dir = k==-1?DIR_RIGHT:DIR_LEFT;
						if(Distance(Ghost_X, Ghost_Y, Link->X+k*64, Link->Y)>1.5){
							Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, Link->X+k*64, Link->Y), 1.5, 0);
						}
						else{
							break;
						}
						SE_Waitframe(this, ghost, vars, 1);
					}
					angle = DirAngle(Ghost_Dir);
					k = Choose(-1, 1);
					Ghost_Data = combo+16;
					j = 120;
					m = 0;
					for(i=0; i<24+EasyModeFrames(16); ++i){
						GetDirXYOffset(xy, Ghost_Dir, {13,1, 8,12, 1,7, 14,7}); //Reach forward
						SE_CastingCircle(ghost, vars);
						//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
						SE_Claw(eArr, 0, 240, 3, angle+j*k, angle-j*k, -90*k, 60, 16, 40, 1, 1, 17, 0);
						SE_Waitframe(this, ghost, vars, 1);
					}
					Game->PlaySound(SFX_SELETCLAW);
					for(i=0; i<240; i+=20){
						m = (i/240)*60;
						GetDirXYOffset(xy, Ghost_Dir, {13,1, 8,12, 1,7, 14,7}); //Reach forward
						SE_CastingCircle(ghost, vars);
						//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
						SE_Claw(eArr, i, 240, 3, angle+j*k, angle-j*k, -90*k, 60, 16, 40, 1, 1, 16, ghost->WeaponDamage);
						SE_Waitframe(this, ghost, vars, 1);
					}
					Ghost_Data = combo;
					for(i=16; i>0; i-=2){
						SE_Claw(eArr, 240, 240, 3, angle+j*k, angle-j*k, -90*k, 60, 16, 40, 1, 1, i, ghost->WeaponDamage);
						SE_Waitframe(this, ghost, vars, 1);
					}
					SE_Claw(eArr, 240, 240, 3, angle+j*k, angle-j*k, -90*k, 60, 16, 40, 1, 1, -1, ghost->WeaponDamage);
				}
				else if(attack==ATK_SLASHCIRCLE){ //Slash (Circle)
					attackDelay = 60;
					Ghost_Data = combo+16;
					Ghost_FaceLink(ghost);
					GetDirXYOffset(xy, Ghost_Dir, {13,1, 8,12, 1,7, 14,7}); //Reach forward
					k = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
					Game->PlaySound(72);
					for(i=0; i<32; ++i){
						SE_CastingCircle(ghost, vars);
						//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
						Ghost_MoveAtAngle(k, 2.5, 0);
						SE_Waitframe(this, ghost, vars, 1);
					}
					for(i=0; i<16+EasyModeFrames(32); ++i){
						SE_CastingCircle(ghost, vars);
						//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
						SE_Waitframe(this, ghost, vars, 1);
					}
					for(i=0; i<360; i+=2){
						if(i%30==0)
							Game->PlaySound(SFX_SELETCLAW);
						x = Ghost_X+VectorX(48*Sin(10*i), i+k);
						y = Ghost_Y+VectorY(48*Sin(10*i), i+k);
						angle = -90+i*10+k;//Angle(VectorX(48*Sin(10*i), i), VectorY(48*Sin(10*i), i), VectorX(48*Sin(10*(i-2)), i-2), VectorY(48*Sin(10*(i-2)), i-2));
						SE_Claw2(eArr, 0, 3, x, y, angle, angle, 16, ghost->WeaponDamage, 16, 1, true);
						SE_CastingCircle(ghost, vars);
						//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
						SE_Waitframe(this, ghost, vars, 1);
					}
					while(SE_Claw2(eArr, 0, 3, x, y, angle, angle, 16, ghost->WeaponDamage, 0, 2, true)){
						SE_Waitframe(this, ghost, vars, 1);
					}
					Ghost_Data = combo;
				}
				else if(attack==ATK_SLASHDASH){ //Slash (Dash)
					attackDelay = 60;
					i = FarthestCombo(Ghost_X, Ghost_Y, {68, 75, 100, 107});
					SE_Teleport(this, ghost, vars, 16, 3, ComboX(i), ComboY(i));
					Ghost_Data = combo+4;
					j = Rand(32, 48);
					for(i=0; i<j+EasyModeFrames(48); ++i){
						Ghost_FaceLink(ghost);
						Ghost_MoveTowardLink(0.2*EasyModeMultiplier(0.5), 0);
						SE_Waitframe(this, ghost, vars, 1);
					}
					angle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
					Ghost_Data = combo+16;
					Game->PlaySound(SFX_SWORD);
					GetDirXYOffset(xy, Ghost_Dir, {13,1, 8,12, 1,7, 14,7}); //Reach forward
					Game->PlaySound(72);
					Game->PlaySound(SFX_SELETCLAW);
					for(i=0; i<40; ++i){
						j = Lerp(-48, 48, i/48);
						SE_Claw2(eArr, 0, 3, Ghost_X+VectorX(j, angle), Ghost_Y+VectorY(j, angle), angle, angle, Lerp(64, 32, i/48), ghost->WeaponDamage, Min(i+1, 16), 1, false);
						SE_CastingCircle(ghost, vars);
						//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
						Ghost_MoveAtAngle(angle, 3, 0);
						SE_Waitframe(this, ghost, vars, 1);
					}
					Ghost_Data = combo;
					for(i=0; i<16; ++i){
						j = 48;
						SE_Claw2(eArr, 0, 3, Ghost_X+VectorX(j, angle), Ghost_Y+VectorY(j, angle), angle, angle, 32, ghost->WeaponDamage, 0, 2, false);
						Ghost_MoveAtAngle(angle, 1, 0);
						SE_Waitframe(this, ghost, vars, 1);
					}
				}
				else if(attack==ATK_SLASHREPEAT){ //Slash (Repeat)
					attackDelay = 60;
					k = Choose(-1, 1);
					x = Ghost_X;
					y = Ghost_Y;
					Ghost_X = (k==-1)?176:64;
					Ghost_Y = 80;
					Ghost_MoveXY(-k*32, 0, 0);
					xy[0] = Ghost_X;
					xy[1] = Ghost_Y;
					Ghost_X = x;
					Ghost_Y = y;
					SE_Teleport(this, ghost, vars, 16, 3, xy[0], xy[1]);
					Ghost_Dir = (k==-1)?DIR_LEFT:DIR_RIGHT;
					k = Choose(-1, 1);
					while((Ghost_Dir==DIR_LEFT&&Ghost_X>112&&Link->X<Ghost_X)||(Ghost_Dir==DIR_RIGHT&&Ghost_X<128&&Link->X>Ghost_X)){
						angle = DirAngle(Ghost_Dir);
						k = -k;
						j = 100;
						mi[0] = 100; //Arc
						mi[1] = Choose(16, 32); //Dist
						mi[2] = 64; //Spacing
						mi[3] = 3; //Count
						mi[4] = 0.75; //ScaleX
						if(Rand(2)==0){
							mi[2] = 12;
							mi[1] = 48;
							mi[3] = 4;
							mi[4] = Choose(0.75, 0.33);
							if(mi[4]==0.33)
								mi[2] = 24;
						}
						Ghost_Data = combo+16;
						for(i=0; i<40+EasyModeFrames(16); ++i){
							GetDirXYOffset(xy, Ghost_Dir, {13,1, 8,12, 1,7, 14,7}); //Reach forward
							SE_CastingCircle(ghost, vars);
							//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
							SE_Claw(eArr, 0, 240, mi[3], angle+mi[0]*k, angle-mi[0]*k, -90*k, 60, mi[1], mi[2], mi[4], 1, 17, 0);
							SE_Waitframe(this, ghost, vars, 1);
						}
						Game->PlaySound(SFX_SELETCLAW);
						for(i=0; i<200; i+=20){
							Ghost_Move(Ghost_Dir, 1.5, 0);
							GetDirXYOffset(xy, Ghost_Dir, {13,1, 8,12, 1,7, 14,7}); //Reach forward
							SE_CastingCircle(ghost, vars);
							//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
							m = (i/240)*60;
							SE_Claw(eArr, i, 200, mi[3], angle+mi[0]*k, angle-mi[0]*k, -90*k, 60, mi[1], mi[2], mi[4], 1, 16, ghost->WeaponDamage);
							SE_Waitframe(this, ghost, vars, 1);
						}
						Ghost_Data = combo;
						for(i=16; i>0; i-=2){
							SE_Claw(eArr, 200, 200, mi[3], angle+mi[0]*k, angle-mi[0]*k, -90*k, 60, mi[1], mi[2], mi[4], 1, i, ghost->WeaponDamage);
							SE_Waitframe(this, ghost, vars, 1);
						}
						SE_Claw(eArr, 240, 240, mi[3], angle+mi[0]*k, angle-mi[0]*k, -90*k, 60, mi[1], mi[2], mi[4], 1, -1, ghost->WeaponDamage);
					}
				}
				else if(attack==ATK_SLASHTRIANGLE){ //Slash (Triangle)
					attackDelay = 60;
					Ghost_Data = combo+20;
					for(i=0; i<24+EasyModeFrames(16); ++i){
						Ghost_FaceLink(ghost);
						GetDirXYOffset(xy, Ghost_Dir, {9,-7, 7,-5, 5,-5, 10,-5}); //Reach up
						SE_CastingCircle(ghost, vars);
						//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
						SE_Waitframe(this, ghost, vars, 1);
					}
					angle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y)+Choose(-30, 30);
					Game->PlaySound(SFX_SELETCLAW);
					for(i=0; i<128; i+=4*EasyModeMultiplier(0.75)){
						for(j=0; j<3; ++j){
							SE_Claw2(eArr, 2*j, 2, Ghost_X+VectorX(i, angle+120*j), Ghost_Y+VectorY(i, angle+120*j), angle+120*j, angle+120*j, 12, ghost->WeaponDamage, 16, 1, false);
						}
						SE_CastingCircle(ghost, vars);
						//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
						SE_Waitframe(this, ghost, vars, 1);
					}
					k = Choose(-1, 1);
					Game->PlaySound(SFX_SELETCLAW);
					for(i=128; i>0; i=Max(i-Lerp(4, 1, i/128), 0)){
						for(j=0; j<3; ++j){
							SE_Claw2(eArr, 2*j, 2, Ghost_X+VectorX(i, angle+256*k-i*2*k+120*j), Ghost_Y+VectorY(i, angle+256*k-i*2*k+120*j), angle+120*j+90, angle+120*j+90, 12, ghost->WeaponDamage, 16, 1, false);
						}
						SE_CastingCircle(ghost, vars);
						//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
						SE_Waitframe(this, ghost, vars, 1);
					}
					for(i=0; i<80; ++i){
						if(i%20==0)
							Game->PlaySound(SFX_SELETCLAW);
						for(j=0; j<3; ++j){
							m = Lerp(32, 56, i/120);
							x = Ghost_X+VectorX(m*Sin(i*30), angle+256*k+16*i*k+120*j);
							y = Ghost_Y+VectorY(m*Sin(i*30), angle+256*k+16*i*k+120*j);
							SE_Claw2(eArr, 2*j, 2, x, y, angle+90+16*i*k, angle+90+16*i*k, 12, ghost->WeaponDamage, j==0?16:0, 1, false);
						}
						SE_CastingCircle(ghost, vars);
						//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
						SE_Waitframe(this, ghost, vars, 1);
					}
					Ghost_Data = combo;
					for(i=0; i<16; ++i){
						for(j=0; j<3; ++j){
							x = Ghost_X;
							y = Ghost_Y;
							SE_Claw2(eArr, 2*j, 2, x, y, angle+90, angle+90, 12, ghost->WeaponDamage, 0, 2, false);
						}
						SE_Waitframe(this, ghost, vars, 1);
					}
				}
				else if(attack==ATK_CUTTERSTREAM){ //Cutter Stream
					attackDelay = 60;
					Ghost_Data = combo+4;
					angle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y)+Rand(-170, 170);
					for(i=0; i<24; ++i){
						Ghost_FaceLink(ghost);
						Ghost_MoveAtAngle(angle, 1, 0);
						SE_Waitframe(this, ghost, vars, 1);
					}
					for(i=0; i<3; ++i){
						Ghost_FaceLink(ghost);
						Ghost_Data = combo+16;
						e = FireAimedEWeapon(EW_LUNAR, Ghost_X+Rand(-4, 4), Ghost_Y+Rand(-4, 4), 0, 50, ghost->WeaponDamage, 0, 0, EWF_UNBLOCKABLE);
						RunEWeaponScript(e, "SlowHomingSickle", {1.5*EasyModeMultiplier(0.6), 45, 250});
						SE_Waitframe(this, ghost, vars, 8);
						Ghost_Data = combo;
						SE_Waitframe(this, ghost, vars, 32+EasyModeFrames(8));
					}
				}
				else if(attack==ATK_CUTTERALTERNATING){ //Cutter Spread
					attackDelay = 60;
					Ghost_Data = combo+4;
					angle = Angle(Link->X, Link->Y, Ghost_X, Ghost_Y)+Rand(-30, 30);
					for(i=0; i<16; ++i){
						Ghost_FaceLink(ghost);
						Ghost_MoveAtAngle(angle, 1.5, 0);
						SE_Waitframe(this, ghost, vars, 1);
					}
					for(m=0; m<2; ++m){
						k = Choose(-1, 1);
						angle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
						Ghost_FaceLink(ghost);
						Ghost_Data = combo+16;
						for(i=0; i<3; ++i){
							switch(i){
								case 0: j = 0; break;
								case 1: j = k; break;
								case 2: j = -k; break;
							}
							x = Ghost_X+VectorX(-16, angle)+VectorX(24*j, angle+90);
							y = Ghost_Y+VectorY(-16, angle)+VectorY(24*j, angle+90);
							e = FireEWeapon(EW_LUNAR, x, y, DegtoRad(angle), 50, ghost->WeaponDamage, 0, 0, EWF_UNBLOCKABLE);
							RunEWeaponScript(e, "SlowHomingSickle", {1.5*EasyModeMultiplier(0.6), 45, 250});
							SE_Waitframe(this, ghost, vars, 24+EasyModeFrames(8));
						}
						Ghost_Data = combo;
						SE_Waitframe(this, ghost, vars, 8);
					}
				}
				else if(attack==ATK_CUTTERBATTERY){ //Cutter W. Battery
					attackDelay = 60;
					xy[0] = Ghost_X;
					xy[1] = Ghost_Y;
					Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y), 128, 0);
					x = Ghost_X;
					y = Ghost_Y;
					Ghost_X = xy[0];
					Ghost_Y = xy[1];
					SE_Teleport(this, ghost, vars, 16, 3, x, y);
					Ghost_FaceLink(ghost);
					SE_Waitframe(this, ghost, vars, 8);
					if(Rand(2)==0){
						for(i=0; i<3; ++i){
							Ghost_FaceLink(ghost);
							angle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
							x = Ghost_X+VectorX(16, angle);
							y = Ghost_Y+VectorY(16, angle);
							e = FireEWeapon(EW_LUNAR, x, y, DegtoRad(angle), 50, ghost->WeaponDamage, 0, 0, EWF_UNBLOCKABLE);
							RunEWeaponScript(e, "SlowHomingSickle", {1.5*EasyModeMultiplier(0.6), 45, 250});
							SE_Waitframe(this, ghost, vars, 16+EasyModeFrames(8));
						}
					}
					else{
						for(i=0; i<3; ++i){
							Ghost_FaceLink(ghost);
							for(j=-1; j<=1; j+=2){
								angle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y)+j*60;
								x = Ghost_X+VectorX(16, angle);
								y = Ghost_Y+VectorY(16, angle);
								e = FireEWeapon(EW_LUNAR, x, y, DegtoRad(angle), 50, ghost->WeaponDamage, 0, 0, EWF_UNBLOCKABLE);
								RunEWeaponScript(e, "SlowHomingSickle", {1.5*EasyModeMultiplier(0.6), 45, 250});
							}
							SE_Waitframe(this, ghost, vars, 16+EasyModeFrames(8));
						}
					}
					SE_UseBattery(this, ghost, vars, 16+EasyModeFrames(16), 0);
				}
				else if(attack==ATK_CUTTERSIDEDASH){ //Cutter Side Dash
					m = Choose(-1, 1);
					for(i=0; i<5; ++i){
						Ghost_FaceLink(ghost);
						Ghost_Data = combo+16;
						
						j = Rand(360);
						x = Ghost_X+VectorX(8, j);
						y = Ghost_Y+VectorY(8, j);
						j = Angle(Ghost_X, Ghost_Y, 120, 80);
						e = FireEWeapon(EW_LUNAR, x, y, DegtoRad(j+Rand(-20, 20)), 50, ghost->WeaponDamage, 0, 0, EWF_UNBLOCKABLE);
						RunEWeaponScript(e, "SlowHomingSickle", {1.5*EasyModeMultiplier(0.6), 45, 250});
						
						SE_Waitframe(this, ghost, vars, 8);
						
						angle = Angle(Ghost_X, Ghost_Y, 240-Link->X, 160-Link->Y);
						Ghost_Data = combo+4;
						for(j=0; j<16+EasyModeFrames(8); ++j){
							Ghost_FaceLink(ghost);
							if(Distance(Ghost_X, Ghost_Y,  240-Link->X, 160-Link->Y))
								Ghost_MoveAtAngle(angle, 1.5, 0);
							SE_Waitframe(this, ghost, vars, 1);
						}
					}
				}
				else if(attack==ATK_BLOCKHV){ //Block HV
					SE_Wallhack(true);
					pos = SE_FindSafeSpot(blockPaths);
					Ghost_Data = combo+4;
					while(Ghost_X<64||Ghost_X>176||Ghost_Y<64||Ghost_Y>96){
						Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, 120, 80), 1, 0);
						Ghost_FaceLink(ghost);
						SE_Waitframe(this, ghost, vars, 1);
					}
					
					blockData[FIRSTCHECK] = false;
					blockData[NUMVALID] = 0;
			
					SE_ActivateMovingBlock(telekinesisObjects, blockData, 0, 1, 32);
					SE_ActivateMovingBlock(telekinesisObjects, blockData, 0, 2, 32);
					
					Ghost_FaceLink(ghost);
					Ghost_Data = combo+20;
					Game->PlaySound(78);
					for(i=0; i<32; ++i){
						Ghost_FaceLink(ghost);
						SE_CastingCircle(ghost, vars);
						GetDirXYOffset(xy, Ghost_Dir, {9,-7, 7,-5, 5,-5, 10,-5}); //Reach up
						k = Choose(0x72, 0x73, 0x74);
						for(j=0; j<6; ++j){
							Screen->Circle(4, Ghost_X+xy[0], Ghost_Y+xy[1], i*6+j*0.5, k, 1, 0, 0, 0, false, i>=16?64:128);
						}
						SE_Waitframe(this, ghost, vars, 1);
					}
					
					pos = SE_FindSafeSpot(blockPaths);
					x = ComboX(pos);
					y = ComboY(pos);
					while(Distance(Ghost_X, Ghost_Y, x, y)>1){
						Ghost_Data = combo+4;
						Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, x, y), 1, 0);
						Ghost_FaceLink(ghost);
						SE_Waitframe(this, ghost, vars, 1);
					}
					SE_Wallhack(false);
					Ghost_Data = combo;
					
					for(i=0; i<32; ++i){
						Ghost_FaceLink(ghost);
						SE_Waitframe(this, ghost, vars, 1);
					}
				}
				else if(attack==ATK_BLOCKBIG){ //Block Big
					SE_Wallhack(true);
					pos = SE_FindSafeSpot(blockPaths);
					Ghost_Data = combo+4;
					while(Ghost_X<64||Ghost_X>176||Ghost_Y<64||Ghost_Y>96){
						Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, 120, 80), 1, 0);
						Ghost_FaceLink(ghost);
						SE_Waitframe(this, ghost, vars, 1);
					}
					SE_Wallhack(false);
					
					blockData[FIRSTCHECK] = false;
					blockData[NUMVALID] = 0;
					
					SE_ActivateMovingBlock(telekinesisObjects, blockData, 1, 0, 32);
			
					Ghost_FaceLink(ghost);
					Ghost_Data = combo+20;
					Game->PlaySound(78);
					for(i=0; i<32; ++i){
						Ghost_FaceLink(ghost);
						SE_CastingCircle(ghost, vars);
						GetDirXYOffset(xy, Ghost_Dir, {9,-7, 7,-5, 5,-5, 10,-5}); //Reach up
						k = Choose(0x72, 0x73, 0x74);
						for(j=0; j<6; ++j){
							Screen->Circle(4, Ghost_X+xy[0], Ghost_Y+xy[1], i*6+j*0.5, k, 1, 0, 0, 0, false, i>=16?64:128);
						}
						SE_Waitframe(this, ghost, vars, 1);
					}
					
					for(i=0; i<32; ++i){
						Ghost_FaceLink(ghost);
						SE_Waitframe(this, ghost, vars, 1);
					}
				}
				else if(attack==ATK_BLOCKX4){ //Block X4
					SE_Wallhack(true);
					pos = SE_FindSafeSpot(blockPaths);
					Ghost_Data = combo+4;
					while(Ghost_X<64||Ghost_X>176||Ghost_Y<64||Ghost_Y>96){
						Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, 120, 80), 1, 0);
						Ghost_FaceLink(ghost);
						SE_Waitframe(this, ghost, vars, 1);
					}
					
					blockData[FIRSTCHECK] = false;
					blockData[NUMVALID] = 0;
					
					SE_ActivateMovingBlock(telekinesisObjects, blockData, 0, 0, 32);
					SE_ActivateMovingBlock(telekinesisObjects, blockData, 0, 0, 32+16);
					SE_ActivateMovingBlock(telekinesisObjects, blockData, 0, 0, 32+32);
					SE_ActivateMovingBlock(telekinesisObjects, blockData, 0, 0, 32+48);
					
					Ghost_FaceLink(ghost);
					Ghost_Data = combo+20;
					Game->PlaySound(78);
					for(i=0; i<32; ++i){
						Ghost_FaceLink(ghost);
						SE_CastingCircle(ghost, vars);
						GetDirXYOffset(xy, Ghost_Dir, {9,-7, 7,-5, 5,-5, 10,-5}); //Reach up
						k = Choose(0x72, 0x73, 0x74);
						for(j=0; j<6; ++j){
							Screen->Circle(4, Ghost_X+xy[0], Ghost_Y+xy[1], i*6+j*0.5, k, 1, 0, 0, 0, false, i>=16?64:128);
						}
						SE_Waitframe(this, ghost, vars, 1);
					}
					
					pos = SE_FindSafeSpot(blockPaths);
					x = ComboX(pos);
					y = ComboY(pos);
					while(Distance(Ghost_X, Ghost_Y, x, y)>1){
						Ghost_Data = combo+4;
						Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, x, y), 1, 0);
						Ghost_FaceLink(ghost);
						SE_Waitframe(this, ghost, vars, 1);
					}
					SE_Wallhack(false);
					Ghost_Data = combo;
					
					for(i=0; i<64; ++i){
						Ghost_FaceLink(ghost);
						SE_Waitframe(this, ghost, vars, 1);
					}
					
					SE_ActivateMovingBlock(telekinesisObjects, blockData, 1, 0, 0);
					SE_ActivateMovingBlock(telekinesisObjects, blockData, 1, 0, 16);
			
					if(Rand(4)==0){
						SE_UseBattery(this, ghost, vars, 16+EasyModeFrames(16), 3);
					}
					
					for(i=0; i<32; ++i){
						Ghost_FaceLink(ghost);
						SE_Waitframe(this, ghost, vars, 1);
					}
				}
				else if(attack==ATK_BLOCKHV2){ //Block HV 2
					SE_Wallhack(true);
					pos = SE_FindSafeSpot(blockPaths);
					Ghost_Data = combo+4;
					while(Ghost_X<64||Ghost_X>176||Ghost_Y<64||Ghost_Y>96){
						Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, 120, 80), 1, 0);
						Ghost_FaceLink(ghost);
						SE_Waitframe(this, ghost, vars, 1);
					}
					
					blockData[FIRSTCHECK] = false;
					blockData[NUMVALID] = 0;
			
					for(m=0; m<2; ++m){
						i = m==0?32:0;
						SE_ActivateMovingBlock(telekinesisObjects, blockData, 0, 1, i);
						SE_ActivateMovingBlock(telekinesisObjects, blockData, 0, 2, i);
						
						if(m==0){
							Ghost_FaceLink(ghost);
							Ghost_Data = combo+20;
							Game->PlaySound(78);
							for(i=0; i<32; ++i){
								Ghost_FaceLink(ghost);
								SE_CastingCircle(ghost, vars);
								GetDirXYOffset(xy, Ghost_Dir, {9,-7, 7,-5, 5,-5, 10,-5}); //Reach up
								k = Choose(0x72, 0x73, 0x74);
								for(j=0; j<6; ++j){
									Screen->Circle(4, Ghost_X+xy[0], Ghost_Y+xy[1], i*6+j*0.5, k, 1, 0, 0, 0, false, i>=16?64:128);
								}
								SE_Waitframe(this, ghost, vars, 1);
							}
						}
						
						pos = SE_FindSafeSpot(blockPaths);
						x = ComboX(pos);
						y = ComboY(pos);
						SE_Wallhack(true);
						while(Distance(Ghost_X, Ghost_Y, x, y)>1){
							Ghost_Data = combo+4;
							Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, x, y), 1, 0);
							Ghost_FaceLink(ghost);
							SE_Waitframe(this, ghost, vars, 1);
						}
						SE_Wallhack(false);
						Ghost_Data = combo;
						
						for(i=0; i<48; ++i){
							Ghost_FaceLink(ghost);
							SE_Waitframe(this, ghost, vars, 1);
						}
					
						if(m==0&&Rand(4)==0){
							SE_UseBattery(this, ghost, vars, 16+EasyModeFrames(16), 3);
						}
					}
					
					for(i=0; i<32; ++i){
						Ghost_FaceLink(ghost);
						SE_Waitframe(this, ghost, vars, 1);
					}
					
					SE_ActivateMovingBlock(telekinesisObjects, blockData, 1, 0, 32);
			
					Ghost_FaceLink(ghost);
					Ghost_Data = combo+20;
					Game->PlaySound(78);
					for(i=0; i<32; ++i){
						Ghost_FaceLink(ghost);
						SE_CastingCircle(ghost, vars);
						GetDirXYOffset(xy, Ghost_Dir, {9,-7, 7,-5, 5,-5, 10,-5}); //Reach up
						k = Choose(0x72, 0x73, 0x74);
						for(j=0; j<6; ++j){
							Screen->Circle(4, Ghost_X+xy[0], Ghost_Y+xy[1], i*6+j*0.5, k, 1, 0, 0, 0, false, i>=16?64:128);
						}
						SE_Waitframe(this, ghost, vars, 1);
					}
				}
				else if(attack==ATK_PHASETRANS1){ //Event grab 1
					grabkilled = false;
					bool collided;
					if(!isFinal){
						Ghost_Data = combo+28;
						for(i=0; i<32; ++i){
							SE_Waitframe(this, ghost, vars, 1);
						}
						Ghost_Data = combo+32;
						for(i=0; i<32; ++i){
							SE_Waitframe(this, ghost, vars, 1);
						}
						Ghost_FaceLink(ghost);
						Ghost_Data = combo+20;
						angle = Angle(Link->X, Link->Y, Ghost_X, Ghost_Y);
						GetDirXYOffset(xy, Ghost_Dir, {9,-7, 7,-5, 5,-5, 10,-5}); //Reach up
						for(i=0; i<64; ++i){
							if(i<16)
								Ghost_MoveAtAngle(angle, 2, 0);
							SE_CastingCircle(ghost, vars);
							//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
							Screen->Circle(4, Link->X+8, Link->Y+8, ((G[G_ANIM]%4<2)?32:16)*(i/64), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 64);
							
							G[G_STEPMOD] -= 0.5;
							NoButton();
							SE_Waitframe(this, ghost, vars, 1);
						}
						Game->PlaySound(78);
						for(i=16; i>0; --i){
							SE_CastingCircle(ghost, vars);
							//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
							Screen->Circle(4, Link->X+8, Link->Y+8, ((G[G_ANIM]%4<2)?32:16)*(i/16), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 64);
							
							G[G_STEPMOD] -= 1;
							NoButton();
							SE_Waitframe(this, ghost, vars, 1);
						}
						collided = true;
					}
					else{
						Ghost_FaceLink(ghost);
						Ghost_Data = combo+20;
						angle = Angle(Link->X, Link->Y, Ghost_X, Ghost_Y);
						GetDirXYOffset(xy, Ghost_Dir, {9,-7, 7,-5, 5,-5, 10,-5}); //Reach up
						xy2[0] = 0;
						xy2[1] = 0;
						x = Link->X+8;
						y = Link->Y+8;
						for(i=0; i<128; ++i){
							SE_SuperattackLazyChase(xy2, x, y);
							
							x += xy2[0];
							y += xy2[1];
							
							if(i<16)
								Ghost_MoveAtAngle(angle, 2, 0);
							SE_CastingCircle(ghost, vars);
							//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
							Screen->Circle(4, x, y, ((G[G_ANIM]%4<2)?32:16)*(i/128), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 64);
							
							G[G_STEPMOD] -= 0.5;
							NoButton();
							SE_Waitframe(this, ghost, vars, 1);
						}
						Game->PlaySound(78);
						for(i=16; i>0; --i){
							SE_SuperattackLazyChase(xy2, x, y);
							
							x += xy2[0];
							y += xy2[1];
							
							SE_CastingCircle(ghost, vars);
							//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
							Screen->Circle(4, x, y, ((G[G_ANIM]%4<2)?32:16)*(i/16), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 64);
							
							G[G_STEPMOD] -= 1;
							NoButton();
							SE_Waitframe(this, ghost, vars, 1);
						}
						if(RectCollision(x, y, x, y, Link->X+2, Link->Y+2, Link->X+13, Link->Y+13))
							collided = true;
					}
					if(collided){
						angle = Angle(Link->X, Link->Y, Ghost_X, Ghost_Y);
						for(i=0; i<24; ++i){
							SE_CastingCircle(ghost, vars);
							//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
							
							if(Distance(Link->X, Link->Y, Ghost_X, Ghost_Y)>24){
								LinkMovement_Push2(VectorX(2, angle), VectorY(2, angle));
							}
							
							SetLinkScriptTile(SE_SpecialLinkTile(0), 0, 2);
							SE_DrawLinkGrabOutline(vars);
							
							Link->Z = i*2;
							Link->Jump = 0;
							
							NoAction();
							SE_Waitframe(this, ghost, vars, 1);
						}
						for(i=0; i<16; ++i){
							SE_CastingCircle(ghost, vars);
							//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
							
							SetLinkScriptTile(SE_SpecialLinkTile(0), 0, 2);
							SE_DrawLinkGrabOutline(vars);
							
							Link->Z = 48;
							Link->Jump = 0;
							
							NoAction();
							SE_Waitframe(this, ghost, vars, 1);
						}
						for(j=0; j<4; ++j){
							for(i=48; i>0; i-=8){
								SE_CastingCircle(ghost, vars);
								//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
							
								SetLinkScriptTile(SE_SpecialLinkTile(0), 0, 2);
								SE_DrawLinkGrabOutline(vars);
								
								Link->Z = i;
								Link->Jump = 0;
								
								NoAction();
								SE_Waitframe(this, ghost, vars, 1);
							}
							Game->PlaySound(SFX_BOMB);
							Screen->Quake = 10;
							Game->PlaySound(SFX_OUCH);
							Link->HP -= 4;
							if(Link->HP<=0){
								grabkilled = true;
								Link->HP = 1;
							}
							for(i=0; i<8; ++i){
								if(i<4)
									Screen->Rectangle(6, 0, 0, 255, 175, 0x84, 1, 0, 0, 0, true, 64);
								SE_CastingCircle(ghost, vars);
								//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
							
								SetLinkScriptTile(SE_SpecialLinkTile(1), 0, 2);
								SE_DrawLinkGrabOutline(vars);
								
								Link->Z = 0;
								Link->Jump = 0;
								
								NoAction();
								SE_Waitframe(this, ghost, vars, 1);
							}
							if(j<3){
								for(i=0; i<48; i+=4){
									SE_CastingCircle(ghost, vars);
									//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
								
									SetLinkScriptTile(SE_SpecialLinkTile(1), 0, 2);
									SE_DrawLinkGrabOutline(vars);
									
									Link->Z = i;
									Link->Jump = 0;
									
									NoAction();
									SE_Waitframe(this, ghost, vars, 1);
								}
							}
						}
						if(grabkilled&&GetSwapCharID(GetCharID(), 1, false)!=GetCharID()){
							Link->HP = 0;
						}
						if(!isFinal){
							Ghost_HP = initHP*SELET_PERCENT_PHASE1;
							ghost->Misc[NPCM_DAMAGENUMBERSLASTHP] = Ghost_HP;
						}
						G[G_DEATHIFRAMES] = 32;
					}
				}
				else if(attack==ATK_PHASETRANS2){ //Event grab 2
					grabkilled = false;
					bool collided;
					if(!isFinal){
						Ghost_Data = combo+28;
						for(i=0; i<32; ++i){
							SE_Waitframe(this, ghost, vars, 1);
						}
						Ghost_Data = combo+32;
						for(i=0; i<32; ++i){
							SE_Waitframe(this, ghost, vars, 1);
						}
						Ghost_FaceLink(ghost);
						Ghost_Data = combo+20;
						angle = Angle(Link->X, Link->Y, Ghost_X, Ghost_Y);
						GetDirXYOffset(xy, Ghost_Dir, {9,-7, 7,-5, 5,-5, 10,-5}); //Reach up
						for(i=0; i<64; ++i){
							if(i<16)
								Ghost_MoveAtAngle(angle, 2, 0);
							SE_CastingCircle(ghost, vars);
							//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
							Screen->Circle(4, Link->X+8, Link->Y+8, ((G[G_ANIM]%4<2)?32:16)*(i/64), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 64);
							
							G[G_STEPMOD] -= 0.5;
							NoButton();
							SE_Waitframe(this, ghost, vars, 1);
						}
						Game->PlaySound(78);
						for(i=16; i>0; --i){
							SE_CastingCircle(ghost, vars);
							//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
							Screen->Circle(4, Link->X+8, Link->Y+8, ((G[G_ANIM]%4<2)?32:16)*(i/16), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 64);
							
							G[G_STEPMOD] -= 1;
							NoButton();
							SE_Waitframe(this, ghost, vars, 1);
						}
						collided = true;
					}
					else{
						Ghost_FaceLink(ghost);
						Ghost_Data = combo+20;
						angle = Angle(Link->X, Link->Y, Ghost_X, Ghost_Y);
						GetDirXYOffset(xy, Ghost_Dir, {9,-7, 7,-5, 5,-5, 10,-5}); //Reach up
						xy2[0] = 0;
						xy2[1] = 0;
						x = Link->X+8;
						y = Link->Y+8;
						for(i=0; i<128; ++i){
							SE_SuperattackLazyChase(xy2, x, y);
							
							x += xy2[0];
							y += xy2[1];
							
							if(i<16)
								Ghost_MoveAtAngle(angle, 2, 0);
							SE_CastingCircle(ghost, vars);
							//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
							Screen->Circle(4, x, y, ((G[G_ANIM]%4<2)?32:16)*(i/128), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 64);
							
							G[G_STEPMOD] -= 0.5;
							NoButton();
							SE_Waitframe(this, ghost, vars, 1);
						}
						Game->PlaySound(78);
						for(i=16; i>0; --i){
							SE_SuperattackLazyChase(xy2, x, y);
							
							x += xy2[0];
							y += xy2[1];
							
							SE_CastingCircle(ghost, vars);
							//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
							Screen->Circle(4, x, y, ((G[G_ANIM]%4<2)?32:16)*(i/16), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 64);
							
							G[G_STEPMOD] -= 1;
							NoButton();
							SE_Waitframe(this, ghost, vars, 1);
						}
						if(RectCollision(x, y, x, y, Link->X+2, Link->Y+2, Link->X+13, Link->Y+13))
							collided = true;
					}
					if(collided){
						angle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
						for(i=0; i<16; ++i){
							SE_CastingCircle(ghost, vars);
							//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
							
							LinkMovement_Push2(VectorX(2, angle), VectorY(2, angle));
							
							SetLinkScriptTile(SE_SpecialLinkTile(0), 0, 2);
							SE_DrawLinkGrabOutline(vars);
							
							Link->Z = i;
							Link->Jump = 0;
							
							NoAction();
							SE_Waitframe(this, ghost, vars, 1);
						}
						for(i=0; i<16; ++i){
							SE_CastingCircle(ghost, vars);
							//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
							
							if(Distance(Link->X, Link->Y, Ghost_X, Ghost_Y)>24){
								LinkMovement_Push2(VectorX(2, angle), VectorY(2, angle));
							}
							
							SetLinkScriptTile(SE_SpecialLinkTile(0), 0, 2);
							SE_DrawLinkGrabOutline(vars);
							
							Link->Z = 16;
							Link->Jump = 0;
							
							NoAction();
							SE_Waitframe(this, ghost, vars, 1);
						}
						for(j=0; j<12; ++j){
							do{
								angle = WrapDegrees(Rand(360));
							}while(!CanWalk8(Link->X, Link->Y, AngleDir8(angle), 1, false, true))
							Ghost_Dir = AngleDir4(angle);
							Ghost_Data = combo+16;
							GetDirXYOffset(xy, Ghost_Dir, {13,1, 8,12, 1,7, 14,7}); //Reach forward
							while(CanWalk8(Link->X, Link->Y, AngleDir8(angle), 1, false, true)){
								SE_CastingCircle(ghost, vars);
								//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
								
								LinkMovement_Push2(VectorX(8, angle), VectorY(8, angle));
								
								SetLinkScriptTile(SE_SpecialLinkTile(0), 0, 2);
								SE_DrawLinkGrabOutline(vars);
								
								Link->Z = 16;
								Link->Jump = 0;
								
								NoAction();
								SE_Waitframe(this, ghost, vars, 1);
							}
							Game->PlaySound(SFX_BOMB);
							Screen->Quake = 10;
							Game->PlaySound(SFX_OUCH);
							Link->HP -= 2;
							if(Link->HP<=0){
								grabkilled = true;
								Link->HP = 1;
							}
							x = Link->X;
							y = Link->Y;
							for(i=0; i<8; ++i){
								Link->X = x+Rand(-2, 2);
								Link->Y = y+Rand(-2, 2);
								
								if(i<4)
									Screen->Rectangle(6, 0, 0, 255, 175, 0x84, 1, 0, 0, 0, true, 64);
								SE_CastingCircle(ghost, vars);
								//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
							
								SetLinkScriptTile(SE_SpecialLinkTile(0), 0, 2);
								SE_DrawLinkGrabOutline(vars);
								
								Link->Z = 16;
								Link->Jump = 0;
								
								NoAction();
								SE_Waitframe(this, ghost, vars, 1);
							}
							Link->X = x;
							Link->Y = y;
						}
						for(i=16; i>0; --i){
							SE_CastingCircle(ghost, vars);
							//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
							
							LinkMovement_Push2(VectorX(2, angle), VectorY(2, angle));
							
							SetLinkScriptTile(SE_SpecialLinkTile(0), 0, 2);
							SE_DrawLinkGrabOutline(vars);
							TurnOffLinkCollision(2);
							
							Link->Z = i;
							Link->Jump = 0;
							
							NoAction();
							SE_Waitframe(this, ghost, vars, 1);
						}
						G[G_DEATHIFRAMES] = 32;
						if(!isFinal){
							Ghost_HP = initHP*SELET_PERCENT_PHASE2;
							ghost->Misc[NPCM_DAMAGENUMBERSLASTHP] = Ghost_HP;
						}
					}
				}
				else if(attack==ATK_FINISHER){ //Event grab 3
					grabkilled = false;
					Ghost_Data = combo+28;
					for(i=0; i<32; ++i){
						SE_Waitframe(this, ghost, vars, 1);
					}
					Ghost_Data = combo+32;
					for(i=0; i<32; ++i){
						SE_Waitframe(this, ghost, vars, 1);
					}
					
					Ghost_Data = combo;
					i = 1;
					while(i>0){
						i = 0;
						for(j=0; j<18; ++j){
							if(telekinesisObjects[j]->InitD[SeletTelekinesis.MOVE])
								++i;
						}
						Ghost_FaceLink(ghost);
						SE_Waitframe(this, ghost, vars, 1);
					}
					Ghost_Data = combo+20;
					for(i=0; i<32; ++i){
						SE_CastingCircle(ghost, vars);
						SE_Waitframe(this, ghost, vars, 1);
					}
					Game->PlaySound(3);
					Screen->Quake = 10;
					for(i=0; i<18; ++i){
						telekinesisObjects[i]->InitD[SeletTelekinesis.MOVE] = 2;
						telekinesisObjects[i]->InitD[SeletTelekinesis.DELAY] = Rand(16);
					}
					Ghost_Dir = DIR_DOWN;
					Ghost_Data = combo+16;
					for(i=0; i<16; ++i){
						SE_CastingCircle(ghost, vars);
						SE_Waitframe(this, ghost, vars, 1);
					}
					SE_Waitframe(this, ghost, vars, 16);
					Ghost_Data = combo;
					SE_Waitframe(this, ghost, vars, 16);
					
					Ghost_FaceLink(ghost);
					Ghost_Data = combo+20;
					angle = Angle(Link->X, Link->Y, Ghost_X, Ghost_Y);
					GetDirXYOffset(xy, Ghost_Dir, {9,-7, 7,-5, 5,-5, 10,-5}); //Reach up
					for(i=0; i<32; ++i){
						SE_CastingCircle(ghost, vars);
						//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
						Screen->Circle(4, Link->X+8, Link->Y+8, ((G[G_ANIM]%4<2)?32:16)*(i/32), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 64);
						
						G[G_STEPMOD] -= 0.5;
						NoButton();
						SE_Waitframe(this, ghost, vars, 1);
					}
					Game->PlaySound(78);
					for(i=8; i>0; --i){
						SE_CastingCircle(ghost, vars);
						//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
						Screen->Circle(4, Link->X+8, Link->Y+8, ((G[G_ANIM]%4<2)?32:16)*(i/8), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 64);
						
						G[G_STEPMOD] -= 1;
						NoButton();
						SE_Waitframe(this, ghost, vars, 1);
					}
					for(i=0; i<32; ++i){
						SE_CastingCircle(ghost, vars);
						//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
						
						SetLinkScriptTile(SE_SpecialLinkTile(1), 0, 2);
						SE_DrawLinkGrabOutline(vars);
						
						NoAction();
						SE_Waitframe(this, ghost, vars, 1);
					}
					Ghost_Data = combo+4;
					Ghost_FaceLink(ghost);
					i = 0;
					G[G_TORRINLOCKON] = 0;
					while(Distance(Ghost_X, Ghost_Y, Link->X, Link->Y)>32&&i<120){
						++i;
						Ghost_MoveTowardLink(1, 0);
						Ghost_FaceLink(ghost);
					
						SetLinkScriptTile(SE_SpecialLinkTile(1), 0, 2);
						SE_DrawLinkGrabOutline(vars);
						
						NoAction();
						SE_Waitframe(this, ghost, vars, 1);
					}
					j = 6;
					Ghost_Data = combo+20;
					for(i=0; i<64; ++i){
						j = Lerp(6, 64, (i/64));
						Screen->Circle(4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1)-j, ((i%6<4)?j*0.6666:j)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
						
						SetLinkScriptTile(SE_SpecialLinkTile(1), 0, 2);
						SE_DrawLinkGrabOutline(vars);
						
						NoAction();
						SE_Waitframe(this, ghost, vars, 1);
					}
					j = 64;
					for(i=0; i<8; ++i){
						Screen->Circle(4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1)-j, ((i%6<4)?j*0.6666:j)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
						
						SetLinkScriptTile(SE_SpecialLinkTile(1), 0, 2);
						SE_DrawLinkGrabOutline(vars);
						
						if(i%4==0)
							Game->PlaySound(78);
						for(k=0; k<3; ++k){
							angle = Rand(360);
							dist = Rand(48);
							x = Ghost_X+xy[0]+Rand(-1, 1)-8+VectorX(dist, angle);
							y = Ghost_Y+xy[1]+Rand(-1, 1)-j-8+VectorY(dist, angle);
							e = CreateEWeaponAt(EW_LUNAR, x, y);
							e->CollDetection = false;
							e->DrawYOffset = -1000;
							dist = Distance(Ghost_X+xy[0]+Rand(-1, 1)-8, Ghost_Y+xy[1]+Rand(-1, 1)-j-8, Link->X, Link->Y)/16;
							RunEWeaponScript(e, "GenParticle", {GP_ARROW, 3, -2, Angle(x, y, Link->X, Link->Y)+Rand(-10, 10), dist, 3, 0.75, 32});
						}
						
						NoAction();
						SE_Waitframe(this, ghost, vars, 1);
					}
					for(i=0; i<128; ++i){
						Screen->Circle(4, Ghost_X+xy[0]+Rand(-3, 3), Ghost_Y+xy[1]+Rand(-3, 3)-j, ((i%6<4)?j*0.6666:j*0.7)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
						
						if(i%4==0){
							Game->PlaySound(78);
							Game->PlaySound(SFX_OUCH);
							Link->HP -= 1;
							if(Link->HP<=0){
								grabkilled = true;
								Link->HP = 1;
							}
						}
						for(k=0; k<3; ++k){
							angle = Rand(360);
							dist = Rand(48);
							x = Ghost_X+xy[0]+Rand(-1, 1)-8+VectorX(dist, angle);
							y = Ghost_Y+xy[1]+Rand(-1, 1)-j-8+VectorY(dist, angle);
							e = CreateEWeaponAt(EW_LUNAR, x, y);
							e->CollDetection = false;
							e->DrawYOffset = -1000;
							dist = Distance(Ghost_X+xy[0]+Rand(-1, 1)-8, Ghost_Y+xy[1]+Rand(-1, 1)-j-8, Link->X, Link->Y)/16;
							RunEWeaponScript(e, "GenParticle", {GP_ARROW, 3, -2, Angle(x, y, Link->X, Link->Y)+Rand(-10, 10), dist, 3, 0.75, 32});
						}
						
						SetLinkScriptTile(SE_SpecialLinkTile(1), 0, 2);
						SE_DrawLinkGrabOutline(vars);
						
						NoAction();
						SE_Waitframe(this, ghost, vars, 1);
					}
					for(i=0; i<32; ++i){
						j = Lerp(64, 6, 1-(i/32));
						Screen->Circle(4, Ghost_X+xy[0]+Rand(-2, 2), Ghost_Y+xy[1]+Rand(-2, 2), (1-i/32)*((i%6<4)?j*0.6666:j*0.7)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
						
						SetLinkScriptTile(SE_SpecialLinkTile(1), 0, 2);
						SE_DrawLinkGrabOutline(vars);
						
						NoAction();
						SE_Waitframe(this, ghost, vars, 1);
					}
					Ghost_FaceLink(ghost);
					Ghost_Data = combo+20;
					angle = Angle(Link->X, Link->Y, Ghost_X, Ghost_Y);
					GetDirXYOffset(xy, Ghost_Dir, {9,-7, 7,-5, 5,-5, 10,-5}); //Reach up
					
					angle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
					for(i=0; i<16; ++i){
						SE_CastingCircle(ghost, vars);
						//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
						
						LinkMovement_Push2(VectorX(2, angle), VectorY(2, angle));
						
						SetLinkScriptTile(SE_SpecialLinkTile(0), 0, 2);
						SE_DrawLinkGrabOutline(vars);
						
						Link->Z = i;
						Link->Jump = 0;
						
						NoAction();
						SE_Waitframe(this, ghost, vars, 1);
					}
					for(i=0; i<16; ++i){
						SE_CastingCircle(ghost, vars);
						//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
						
						if(Distance(Link->X, Link->Y, Ghost_X, Ghost_Y)>24){
							LinkMovement_Push2(VectorX(2, angle), VectorY(2, angle));
						}
						
						SetLinkScriptTile(SE_SpecialLinkTile(0), 0, 2);
						SE_DrawLinkGrabOutline(vars);
						
						Link->Z = 16;
						Link->Jump = 0;
						
						NoAction();
						SE_Waitframe(this, ghost, vars, 1);
					}
					for(j=0; j<12; ++j){
						do{
							angle = WrapDegrees(Rand(360));
						}while(!CanWalk8(Link->X, Link->Y, AngleDir8(angle), 1, false, true))
						Ghost_Dir = AngleDir4(angle);
						Ghost_Data = combo+16;
						GetDirXYOffset(xy, Ghost_Dir, {13,1, 8,12, 1,7, 14,7}); //Reach forward
						while(CanWalk8(Link->X, Link->Y, AngleDir8(angle), 1, false, true)){
							SE_CastingCircle(ghost, vars);
							//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
							
							LinkMovement_Push2(VectorX(8, angle), VectorY(8, angle));
							
							SetLinkScriptTile(SE_SpecialLinkTile(0), 0, 2);
							SE_DrawLinkGrabOutline(vars);
							
							Link->Z = 16;
							Link->Jump = 0;
							
							NoAction();
							SE_Waitframe(this, ghost, vars, 1);
						}
						Game->PlaySound(SFX_BOMB);
						Screen->Quake = 10;
						Game->PlaySound(SFX_OUCH);
						Link->HP -= 2;
						if(Link->HP<=0){
							grabkilled = true;
							Link->HP = 1;
						}
						x = Link->X;
						y = Link->Y;
						for(i=0; i<8; ++i){
							Link->X = x+Rand(-2, 2);
							Link->Y = y+Rand(-2, 2);
							
							if(i<4)
								Screen->Rectangle(6, 0, 0, 255, 175, 0x84, 1, 0, 0, 0, true, 64);
							SE_CastingCircle(ghost, vars);
							//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
						
							SetLinkScriptTile(SE_SpecialLinkTile(0), 0, 2);
							SE_DrawLinkGrabOutline(vars);
							
							Link->Z = 16;
							Link->Jump = 0;
							
							NoAction();
							SE_Waitframe(this, ghost, vars, 1);
						}
						Link->X = x;
						Link->Y = y;
					}
					for(i=16; i>0; --i){
						SE_CastingCircle(ghost, vars);
						//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
						
						LinkMovement_Push2(VectorX(2, angle), VectorY(2, angle));
						
						SetLinkScriptTile(SE_SpecialLinkTile(0), 0, 2);
						SE_DrawLinkGrabOutline(vars);
						
						Link->Z = i;
						Link->Jump = 0;
						
						NoAction();
						SE_Waitframe(this, ghost, vars, 1);
					}
					for(i=0; i<24; ++i){
						SE_CastingCircle(ghost, vars);
						//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
						
						if(Distance(Link->X, Link->Y, Ghost_X, Ghost_Y)>24){
							LinkMovement_Push2(VectorX(2, angle), VectorY(2, angle));
						}
						
						SetLinkScriptTile(SE_SpecialLinkTile(0), 0, 2);
						SE_DrawLinkGrabOutline(vars);
						
						Link->Z = i*2;
						Link->Jump = 0;
						
						NoAction();
						SE_Waitframe(this, ghost, vars, 1);
					}
					for(i=0; i<80; ++i){
						SE_CastingCircle(ghost, vars);
						//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
						
						SetLinkScriptTile(SE_SpecialLinkTile(0), 0, 2);
						SE_DrawLinkGrabOutline(vars);
						
						Link->Z = 48;
						Link->Jump = 0;
						
						NoAction();
						SE_Waitframe(this, ghost, vars, 1);
					}
					for(i=48; i>0; i-=8){
						SE_CastingCircle(ghost, vars);
						//Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((i%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
					
						SetLinkScriptTile(SE_SpecialLinkTile(0), 0, 2);
						SE_DrawLinkGrabOutline(vars);
						
						Link->Z = i;
						Link->Jump = 0;
						
						NoAction();
						SE_Waitframe(this, ghost, vars, 1);
					}
					Game->PlaySound(SFX_BOMB);
					Game->PlaySound(127);
					for(i=0; i<32; ++i){
						Screen->Rectangle(7, 0, -56, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
						NoAction();
						SE_Waitframe(this, ghost, vars, 1);
					}
					
					GiveBestiaryEntry(217, true);
					//LoreTracking[LT_ENEMIES+217] = 1;
					if(G[G_RANDOMIZERENABLED]){
						Game->PlayMIDI(0);
						Screen->TriggerSecrets();
						Screen->State[ST_SECRET] = true;
						Screen->ComboD[39] = 783;
						ghost->HP = -1000;
						Ghost_HP = -1000;
						ghost->DrawYOffset = -1000;
						ghost->Immortal = false;
						while(true){
							ghost->HP = -1000;
							Ghost_HP = -1000;
							SSGhost_Waitframe(this, ghost);
						}
					}
					else{
						G[G_MAPDISABLED] = 1;
						Link->Warp(64, 0x1A);
					}
					// if(grabkilled)
						// Link->HP = 0;
				}
				
				if(!Ghost_CanPlace(Ghost_X, Ghost_Y, 16, 16)){
					SE_Teleport(this, ghost, vars, 16, 3, 120, 80);
				}
				if(phase==0){
					attackDelay += 90;
					if(walkStyle==0){
						walkStyle = 1; 
					}
					else{
						walkStyle = 0;
						walkFrames = 0;
					}
				}
				else if(phase==1){
					attackDelay += 40;
					if(walkStyle==0){
						walkStyle = 1; 
						walkAngle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y)+Choose(-80, 80);
					}
					else{
						walkStyle = 0;
						walkFrames = 0;
					}
				}
				else if(phase==2||phase==3){
					walkStyle = Rand(0, 2);
				}
				if(IsEasyMode())
					attackDelay += 32;
				
				if(vars[NUMHITS]>=3&&phase<2){
					xy[0] = Ghost_X;
					xy[1] = Ghost_Y;
					Ghost_MoveAtAngle(Angle(Link->X, Link->Y, Ghost_X, Ghost_Y), 256, 0);
					if(Distance(xy[0], xy[1], Ghost_X, Ghost_Y)>64){
						x = Ghost_X;
						y = Ghost_Y;
						Ghost_X = xy[0];
						Ghost_Y = xy[1];
						SE_Teleport(this, ghost, vars, 16, 3, x, y);
					}
					else{
						Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y), 256, 0);
						x = Ghost_X;
						y = Ghost_Y;
						Ghost_X = xy[0];
						Ghost_Y = xy[1];
						SE_Teleport(this, ghost, vars, 16, 3, x, y);
					}
				}
				
				vars[NUMHITS] = 0;
				//SE_Teleport(this, ghost, vars, 16, 4, Link->X, Link->Y);
			}
			SE_Waitframe(this, ghost, vars, 1);
		}
	}
	void SE_SuperattackLazyChase(int xy, int x, int y){
		int max = 2;
		int pullMod = 1.2;
		int str = Lerp(0.1, 0.5, Clamp(Distance(x, y, Link->X+8, Link->Y+8)/48, 0, 1));
		if(Round(x)!=Link->X+8){
			xy[0] = Clamp(xy[0]+Sign((Link->X+8)-x)*str*pullMod, -max, max);
		}
		if(Round(y)!=Link->X+8){
			xy[1] = Clamp(xy[1]+Sign((Link->Y+8)-y)*str*pullMod, -max, max);
		}
	}
	void SE_CastingCircle(npc ghost, untyped vars){
		int combo = ghost->Attributes[10];
		int xy[2];
		switch(Ghost_Data-combo){
			case 16:
				GetDirXYOffset(xy, Ghost_Dir, {13,1, 8,12, 1,7, 14,7}); //Reach forward
				break;
			case 20:
				GetDirXYOffset(xy, Ghost_Dir, {9,-7, 7,-5, 5,-5, 10,-5}); //Reach up
				break;
			default:
				return;
		}
		int c = Choose(0x71, 0x72, 0x73);
		if(vars[CASTINGSTELLAR]){
			c = Choose(0x91, 0x96, 0x97);
			vars[CASTINGSTELLAR] = 0;
		}
		Screen->Circle((Ghost_Dir==DIR_UP)?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), ((G[G_ANIM]%6<4)?2:6)+Rand(2), c, 1, 0, 0, 0, true, 128);			
	}
	int SE_ActivateMovingBlock(lweapon telekinesisObjects, untyped blockData, int blockType, int searchType, int delay){
		lweapon validBlocks = blockData[2];
		int validIndex = blockData[3];
		int validDirs = blockData[4];
		int validPos = blockData[5];
		bool inUse = blockData[6];
		int blockPaths = blockData[7];
		if(blockType==0){ //Small
			//Optimization to only calculate valid moves at the start of a series of blocks
			if(!blockData[FIRSTCHECK]){
				for(int i=0; i<18; ++i){
					inUse[i] = 0;
				}
				for(int i=0; i<176; ++i){
					blockPaths[i] = 0;
				}
				//The first four blocks are large and use different calcs
				for(int i=4; i<18; ++i){
					if(!inUse[i]){
						int x = telekinesisObjects[i]->X;
						int y = telekinesisObjects[i]->Y;
						int oldX = x;
						int oldY = y;
						int angle = Angle(x, y, Link->X, Link->Y);
						int blockDir = AngleDir8(angle);
						if(blockDir>DIR_RIGHT)
							blockDir = Dir8ToDir4Random(blockDir);
						//Screen->DrawInteger(6, telekinesisObjects[i]->X, telekinesisObjects[i]->Y, FONT_Z3SMALL, 0x01, 0x0F, -1, -1, blockDir, 0, 128);
						//Trace out the path the block can travel to determine the end point and if it's legal
						for(int i=0; i<16; ++i){
							x += DirX(blockDir, 16);
							y += DirY(blockDir, 16);
							if(!SE_CanPlaceMovingBlock(x, y, false)){
								x -= DirX(blockDir, 16);
								y -= DirY(blockDir, 16);
								break;
							}
						}
						if(SE_CanPlaceMovingBlock(x, y, true)&&(x!=oldX||y!=oldY)){
							validBlocks[blockData[NUMVALID]] = telekinesisObjects[i];
							validIndex[blockData[NUMVALID]] = i;
							validDirs[blockData[NUMVALID]] = blockDir;
							validPos[blockData[NUMVALID]] = ComboAt(x+8, y+8);
							inUse[i] = true;
							++blockData[NUMVALID];
						}
					}
				}
				blockData[FIRSTCHECK] = true;
			}
			
			int theBlock = -1;
			for(int i=0; i<blockData[NUMVALID]*4; ++i){
				int j = Rand(blockData[NUMVALID]);
				if(i<blockData[NUMVALID]*2){
					if(i>=blockData[NUMVALID])
						j = i%blockData[NUMVALID];
				}
				//A block that's already flagged for moving or one such a block will collide with can't be valid
				if(validBlocks[j]->InitD[SeletTelekinesis.MOVE]==0&&blockPaths[ComboAt(validBlocks[j]->X+8, validBlocks[j]->Y+8)]<2&&blockPaths[validPos[j]]<2){
					if(i<blockData[NUMVALID]*2){
						if(Abs(Link->X-validBlocks[j]->X)<=8||Abs(Link->Y-validBlocks[j]->Y)<=8){
							if(searchType==1){ //Horiz
								if(validDirs[j]==DIR_LEFT||validDirs[j]==DIR_RIGHT){
									theBlock = j;
									break;
								}
							}
							else if(searchType==2){ //Vert
								if(validDirs[j]==DIR_UP||validDirs[j]==DIR_DOWN){
									theBlock = j;
									break;
								}
							}
							else{
								theBlock = j;
								break;
							}
						}
					}
					else if(i<blockData[NUMVALID]*3){
						if(searchType==1){ //Horiz
							if(validDirs[j]==DIR_LEFT||validDirs[j]==DIR_RIGHT){
								theBlock = j;
								break;
							}
						}
						else if(searchType==2){ //Vert
							if(validDirs[j]==DIR_UP||validDirs[j]==DIR_DOWN){
								theBlock = j;
								break;
							}
						}
						else{
							theBlock = j;
							break;
						}
					}
					else{
						theBlock = j;
						break;
					}
				}
			}
			if(theBlock>-1){
				telekinesisObjects[validIndex[theBlock]]->InitD[SeletTelekinesis.MOVE] = 1;
				telekinesisObjects[validIndex[theBlock]]->InitD[SeletTelekinesis.TX] = ComboX(validPos[theBlock]);
				telekinesisObjects[validIndex[theBlock]]->InitD[SeletTelekinesis.TY] = ComboY(validPos[theBlock]);
				telekinesisObjects[validIndex[theBlock]]->InitD[SeletTelekinesis.DELAY] = delay;
				int x = validBlocks[theBlock]->X;
				int y = validBlocks[theBlock]->Y;
				//Trace out the path the block will travel to flag where Selet should avoid and the combo that's stopping the block (to prevent that one from moving)
				int blockDir = validDirs[theBlock];
				for(int i=0; i<16; ++i){
					blockPaths[ComboAt(x+8, y+8)] = 1;
					x += DirX(blockDir, 16);
					y += DirY(blockDir, 16);
					blockPaths[ComboAt(x+8, y+8)] = 2;
					if(!SE_CanPlaceMovingBlock(x, y, false)){
						break;
					}
				}
				blockPaths[ComboAt(x+8, y+8)] = 3;
				blockPaths[validPos[theBlock]] = 3;
				return theBlock;
			}
		}
		else{ //Large
			int pos[] = {34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 60, 76, 92, 108, 124, 123, 122, 121, 120, 119, 118, 117, 116, 115, 114, 98, 82, 66, 50};
			int valid2x2Pos[30];
			int numValid2x2;
			for(int i=0; i<30; ++i){
				int x = ComboX(pos[i]);
				int y = ComboY(pos[i]);
				if(SE_CanPlaceMovingBlock2x2(x, y, blockPaths)){ //SE_CanPlaceMovingBlock(x, y, false)&&SE_CanPlaceMovingBlock(x+16, y, false)&&SE_CanPlaceMovingBlock(x, y+16, false)&&SE_CanPlaceMovingBlock(x+16, y+16, false)){
					valid2x2Pos[numValid2x2] = pos[i];
					++numValid2x2;
				}
			}
			if(numValid2x2==0)
				return -1;
			int target = Rand(numValid2x2);
			int targetPos = valid2x2Pos[target];
			int tX = ComboX(targetPos);
			int tY = ComboY(targetPos);
			int closestDist = 0;
			int closest = -1;
			for(int i=0; i<4; ++i){
				if(Distance(telekinesisObjects[i]->X, telekinesisObjects[i]->Y, tX, tY)>closestDist){
					closestDist = Distance(telekinesisObjects[i]->X, telekinesisObjects[i]->Y, tX, tY);
					closest = i;
				}
			}
			if(closest>-1){
				telekinesisObjects[closest]->InitD[SeletTelekinesis.MOVE] = 1;
				telekinesisObjects[closest]->InitD[SeletTelekinesis.TX] = tX;
				telekinesisObjects[closest]->InitD[SeletTelekinesis.TY] = tY;
				telekinesisObjects[closest]->InitD[SeletTelekinesis.DELAY] = delay;
				return closest;
			}
		}
		return -1;
	}
	bool SE_CanPlaceMovingBlock(int x, int y, bool endPoint){
		int pos = ComboAt(x+8, y+8);
		if(endPoint){
			if(Screen->ComboF[pos]==CF_SCRIPT1)
				return false;
		}
		return !Screen->isSolid(x+8, y+8);
	}
	bool SE_CanPlaceMovingBlock2x2(int blkx, int blky, int blockPaths){
		for(int i=0; i<4; ++i){
			int x = blkx+(i%2)*16;
			int y = blky+Floor(i/2)*16;
			if(!SE_CanPlaceMovingBlock(x, y, false))
				return false;
			if(blockPaths[ComboAt(x, y)])
				return false;
		}
		return true;
	}
	int SE_FindSafeSpot(int blockPaths){
		int validX[176];
		int validY[176];
		int numPositions;
		for(int i=0; i<176; ++i){
			int x = ComboX(i);
			int y = ComboY(i);
			if(!Screen->isSolid(x+8, y+8)&&Screen->ComboF[i]!=CF_NOENEMY&&Screen->ComboF[i]!=CF_NOGROUNDENEMY&&blockPaths[i]==0){
				validX[numPositions] = x;
				validY[numPositions] = y;
				++numPositions;
			}
		}
		if(numPositions==0){
			return ComboAt(Ghost_X+8, Ghost_Y+8);
		}
		int closestDist = 1000;
		int closest = 0;
		for(int i=0; i<numPositions; ++i){
			if(Distance(validX[i], validY[i], Ghost_X, Ghost_Y)<closestDist){
				closestDist = Distance(validX[i], validY[i], Ghost_X, Ghost_Y);
				closest = ComboAt(validX[i]+8, validY[i]+8);
			}
		}
		return closest;
	}
	int SE_SpecialLinkTile(int which){
		int offset = 0;
		switch(GetCharID()){
			case CHAR_TORRIN:
			case CHAR_TERRY:
				offset = 1;
				break;
			case CHAR_KAYLANI:
			case CHAR_SIYED:
				offset = 2;
				break;
		}
		switch(which){
			case 0: //Levitate
				if(GetCharID()<CHAR_SOREN)
					return TIL_PLAYERLEVITATED+offset;
				else
					return TIL_PLAYERLEVITATEDALT+offset;
			case 1: //Crouching
				if(GetCharID()<CHAR_SOREN)
					return TIL_PLAYERCROUCH+offset;
				else
					return TIL_PLAYERCROUCHALT+offset;
		}
		return -1;
	}
	bool SE_UseBattery(ffc this, npc ghost, untyped vars, int safeduration, int spell){
		int i; int j; int k;
		int x; int y;
		int xy[2];
		int til; int cset;
		int element;
		int clr;
		int shattertil;
		int shattercs;
		switch(spell){
			case 0:
			case 1:
			case 2:
			case 3:
			case 4:
				til = 65112;
				cset = 8;
				element = 0;
				clr = 0x86;
				shattertil = 65360;
				shattercs = 8;
				break;
			case 5:
			case 6:
			case 7:
				til = 65114;
				cset = 9;
				element = 2;
				clr = 0x96;
				shattertil = 65360;
				shattercs = 9;
				break;
		}
		
		int combo = ghost->Attributes[10];
		Ghost_Dir = DIR_DOWN;
		Ghost_Data = combo+20;
		bool gothit;
		for(i=0; i<safeduration&&!gothit; ++i){
			GetDirXYOffset(xy, Ghost_Dir, {9,-7, 7,-5, 5,-5, 10,-5}); //Reach up
				
			int hitby = ghost->HitBy[2]; //lweapon
			if(hitby){
				lweapon hitbylw = Screen->LoadLWeapon(hitby);
				if(hitbylw->Type==LW_SWORD||hitbylw->Type==LW_PHYSICAL||hitbylw->Type==LW_BOMBBLAST)
					gothit = true;
				if(hitbylw->Weapon==LW_SWORD||hitbylw->Weapon==LW_PHYSICAL||hitbylw->Weapon==LW_BOMBBLAST)
					gothit = true;
			}
			
			if(Ghost_GotHit()){
				for(int j=Screen->NumLWeapons(); j>0; --j){
					lweapon l = Screen->LoadLWeapon(j);
					if(l->Type==LW_SWORD||l->Weapon==LW_SWORD){
						if(Collision(ghost, l))
							gothit = true;
					}
				}
			}
			// if(Ghost_GotHit())
				// gothit = true;
				
			Screen->FastTile(4, Ghost_X+xy[0]-8, Ghost_Y+xy[1]-8, til, cset, 128);
			SE_Waitframe(this, ghost, vars, 1);
		}
		if(gothit){
			int jump = 0;
			int rot = 0;
			for(i=0; i<32; i+=jump){
				rot += 10;
				Screen->DrawTile(4, Ghost_X+xy[0]-8, Ghost_Y+xy[1]-8+i, til, 1, 1, cset, -1, -1, Ghost_X+xy[0]-8, Ghost_Y+xy[1]-8+i, rot, 0, true, 128);
				jump = Min(jump+0.16, 3.2);
				SE_Waitframe(this, ghost, vars, 1);
			}
			Game->PlaySound(90);
			Ghost_Data = combo;
			for(i=0; i<16; ++i){
				lweapon l = ParticleAnim(Ghost_X+xy[0]-8+Rand(-8, 8), Ghost_Y+xy[1]-8+32+Rand(-8, 8), shattertil, shattercs, 8, 1);
				l->OriginalTile += Rand(8);
				l->Tile = l->OriginalTile;
				SE_Waitframe(this, ghost, vars, 1);
			}
		}
		else{
			Ghost_Data = combo+24;
			Game->PlaySound(86);
			for(i=0; i<12; ++i){
				DrawStarGlint(4, Ghost_X+2, Ghost_Y+9, i*10, 8+Lerp(0, 8, i/12), Choose(0x01, clr, clr+1));
				SE_Waitframe(this, ghost, vars, 1);
			}
			switch(spell){
				case 0: //Flash
				case 3:
					eweapon e = CreateEWeaponAt(EW_SOLAR, Ghost_X+2-8, Ghost_Y+9-8);
					e->CollDetection = false;
					e->DrawYOffset = -1000;
					RunEWeaponScript(e, "GenParticle", {GP_FLASH, spell==0?90:20});
					break;
				case 1: //Big Shot
					Ghost_Data = combo+16;
					Ghost_FaceLink(ghost);
					eweapon e = FireEWeapon(EW_SOLAR, Ghost_X, Ghost_Y, DegtoRad(DirAngle(Ghost_Dir)), 0, ghost->WeaponDamage, 0, SFX_LIGHTSHOT, EWF_UNBLOCKABLE);
					e->CollDetection = false;
					RunEWeaponScript(e, "SolarBigShot", {0, 8, 0.25, 0.2, 0, -24});
					//int chargeTime, int growDelay, int growth, int accel, int angleturn, int maxradius){
					//RunEWeaponScript(e, "SolarBigShot", {48, 16, 0.2, 0.2});
					SE_Waitframe(this, ghost, vars, 32);
					Ghost_Data = combo;
					SE_Waitframe(this, ghost, vars, 32+EasyModeFrames(24));
					break;
				case 2: //Big Shot x3
					for(i=0; i<3; ++i){
						Ghost_Data = combo+16;
						Ghost_FaceLink(ghost);
						eweapon e = FireEWeapon(EW_SOLAR, Ghost_X, Ghost_Y, DegtoRad(DirAngle(Ghost_Dir)), 0, ghost->WeaponDamage, 0, SFX_LIGHTSHOT, EWF_UNBLOCKABLE);
						e->CollDetection = false;
						RunEWeaponScript(e, "SolarBigShot", {0, 8, 0.25, 0.2, 0, -24});
						//int chargeTime, int growDelay, int growth, int accel, int angleturn, int maxradius){
						//RunEWeaponScript(e, "SolarBigShot", {48, 16, 0.2, 0.2});
						SE_Waitframe(this, ghost, vars, 32+EasyModeFrames(24));
						Ghost_Data = combo+4;
						if(i<2){
							k = Choose(-1, 1);
							for(j=0; j<32; ++j){
								Ghost_FaceLink(ghost);
								Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y)+45*k, 0.75, 0);
								SE_Waitframe(this, ghost, vars, 1);
							}
						}
					}
					Ghost_Data = combo;
					break;
				case 4: //Triple Suns
					Ghost_Data = combo+16;
					Ghost_FaceLink(ghost);
					eweapon e = FireEWeapon(EW_SCRIPT1, Ghost_X+DirX(Ghost_Dir, 16), Ghost_Y+DirY(Ghost_Dir, 16), 0, 0, ghost->WeaponDamage, 0, 0, 0);
					e->CollDetection = false;
					e->Tile = GH_BLANK_TILE;
					RunEWeaponScript(e, "MagicBatteryEW", {Ghost_Dir, 0, 1});
					SE_Waitframe(this, ghost, vars, 16+EasyModeFrames(48));
					Ghost_Data = combo;
					break;
				case 5: //Lightning
					Ghost_Data = combo+16;
					Ghost_FaceLink(ghost);
					eweapon e = FireEWeapon(EW_SCRIPT1, Ghost_X+DirX(Ghost_Dir, 16), Ghost_Y+DirY(Ghost_Dir, 16), 0, 0, ghost->WeaponDamage, 0, 0, 0);
					e->CollDetection = false;
					e->Tile = GH_BLANK_TILE;
					RunEWeaponScript(e, "MagicBatteryEW", {Ghost_Dir, 2, 1});
					SE_Waitframe(this, ghost, vars, 16+EasyModeFrames(16));
					Ghost_Data = combo;
					break;
				case 6: //Stellar Dummy
					return true;
					break;
			}
		}
		return false;
	}
	void SE_TeleportOut(ffc this, npc ghost, untyped vars, int duration){
		bitmap b = <bitmap>vars[BITMAP];
		b->Clear(0);
		b->DrawCombo(0, 0, 1, Ghost_Data+Ghost_Dir, 1, 2, Ghost_CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
		b->DrawCombo(0, 2, 1, Ghost_Data+Ghost_Dir, 1, 2, Ghost_CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
		b->DrawCombo(0, 1, 0, Ghost_Data+Ghost_Dir, 1, 2, Ghost_CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
		b->ReplaceColors(0, 0x01, 0x01, 0xBF);
		b->DrawCombo(0, 1, 1, Ghost_Data+Ghost_Dir, 1, 2, Ghost_CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
		b->ReplaceColors(0, 0x0F, 0x10, 0xBF);
		b->ReplaceColors(0, 0x75, 0x01, 0x01);
		int meltSpeed[18];
		ghost->CollDetection = false;
		ghost->DrawYOffset = -1000;
		for(int i=0; i<18; ++i){
			meltSpeed[i] = Rand(100, 200)/100;
		}
		for(int j=0; j<duration; ++j){
			Screen->Ellipse(2, Ghost_X+7, Ghost_Y+15, 8+4*(j/duration)+1, 3+(j/duration)+1, 0x75, 1, 0, 0, 0, true, 128);
			Screen->Ellipse(2, Ghost_X+7, Ghost_Y+15, 8+4*(j/duration), 3+(j/duration), 0x0F, 1, 0, 0, 0, true, 128);
			for(int i=0; i<18; ++i){
				int height = Clamp(Lerp(33, 0, meltSpeed[i]*(j/duration)), 0, 33);
				if(height>=1){
					b->Blit(2, RT_SCREEN, i, 0, 1, 33, Ghost_X+i, Ghost_Y-18+(33-height), 1, height, 0, 0, 0, 0, 0, true);
				}
			}
			SE_Waitframe(this, ghost, vars, 1);
		}
	}
	void SE_TeleportIn(ffc this, npc ghost, untyped vars, int duration){
		bitmap b = <bitmap>vars[BITMAP];
		b->Clear(0);
		b->DrawCombo(0, 0, 1, Ghost_Data+Ghost_Dir, 1, 2, Ghost_CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
		b->DrawCombo(0, 2, 1, Ghost_Data+Ghost_Dir, 1, 2, Ghost_CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
		b->DrawCombo(0, 1, 0, Ghost_Data+Ghost_Dir, 1, 2, Ghost_CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
		b->ReplaceColors(0, 0x01, 0x01, 0xBF);
		b->DrawCombo(0, 1, 1, Ghost_Data+Ghost_Dir, 1, 2, Ghost_CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
		b->ReplaceColors(0, 0x0F, 0x10, 0xBF);
		b->ReplaceColors(0, 0x75, 0x01, 0x01);
		int meltSpeed[18];
		for(int i=0; i<18; ++i){
			meltSpeed[i] = Rand(100, 200)/100;
		}
		for(int j=0; j<duration; ++j){
			Screen->Ellipse(2, Ghost_X+7, Ghost_Y+15, 8+4*(1-j/duration)+1, 3+(1-j/duration)+1, 0x75, 1, 0, 0, 0, true, 128);
			Screen->Ellipse(2, Ghost_X+7, Ghost_Y+15, 8+4*(1-j/duration), 3+(1-j/duration), 0x0F, 1, 0, 0, 0, true, 128);
			for(int i=0; i<18; ++i){
				int height = Clamp(Lerp(0, 33, meltSpeed[i]*(j/duration)), 0, 33);
				if(height>=1){
					b->Blit(2, RT_SCREEN, i, 0, 1, 33, Ghost_X+i, Ghost_Y-18+(33-height), 1, height, 0, 0, 0, 0, 0, true);
				}
			}
			SE_Waitframe(this, ghost, vars, 1);
		}
		ghost->CollDetection = true;
		ghost->DrawYOffset = -18;
	}
	void SE_Teleport(ffc this, npc ghost, untyped vars, int duration, int step, int tx, int ty){
		SE_TeleportOut(this, ghost, vars, duration);
		SE_Wallhack(true);
		while(Distance(Ghost_X, Ghost_Y, tx, ty)>step){
			Screen->Ellipse(2, Ghost_X+7, Ghost_Y+15, 12+1, 4+1, 0x75, 1, 0, 0, 0, true, 128);
			Screen->Ellipse(2, Ghost_X+7, Ghost_Y+15, 12, 4, 0x0F, 1, 0, 0, 0, true, 128);
			Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, tx, ty), step, 0);
			SE_Waitframe(this, ghost, vars, 1);
		}
		Ghost_X = tx;
		Ghost_Y = ty;
		Ghost_FaceLink(ghost);
		SE_Wallhack(false);
		SE_TeleportIn(this, ghost, vars, duration);
	}
	void SE_Claw(eweapon eArr, int time, int maxTime, int count, int startAngle, int endAngle, int angle2, int turnAngle, int dist, int spacing, int xScale, int yScale, int state, int damage){
		int x; int y;
		int angle = Lerp(startAngle, endAngle, (time/maxTime));
		angle2 += angle;
		angle2 += Lerp(0, turnAngle, (time/maxTime));
		if(state==17){
			for(int i=0; i<count; ++i){
				int fan = endAngle-startAngle;
				int numParticles = Abs(fan)/20;
				for(int j=0; j<numParticles; ++j){
					x = Ghost_X+VectorX(dist+spacing*i, startAngle+(fan/numParticles)*j)*xScale+8;
					y = Ghost_Y+VectorY(dist+spacing*i, startAngle+(fan/numParticles)*j)*yScale+8;
					Screen->PutPixel(4, x+Rand(-2, 2), y+Rand(-2, 2), Choose(0x71, 0x72, 0x73), 0, 0, 0, 64);
				}
				x = Ghost_X+VectorX(dist+spacing*i, angle)*xScale;
				y = Ghost_Y+VectorY(dist+spacing*i, angle)*yScale;
				Screen->Circle(4, x+8+Rand(-1, 1), y+8+Rand(-1, 1), Rand(3, 6), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, false, 64);
			}
		}
		else if(state==-1){
			for(int i=0; i<count; ++i){
				if(eArr[i]->isValid()){
					eArr[i]->DeadState = 0;
				}
			}
			return;
		}
		for(int i=0; i<count; ++i){
			x = Ghost_X+VectorX(dist+spacing*i, angle)*xScale;
			y = Ghost_Y+VectorY(dist+spacing*i, angle)*yScale;
			if(!eArr[i]->isValid()){
				eArr[i] = CreateEWeaponAt(EW_LUNAR, 120, 80);
				eArr[i]->Damage = damage;
				eArr[i]->CollDetection = false;
				eArr[i]->DrawYOffset = -1000;
				RunEWeaponScript(eArr[i], "VunterSlaush", {state, x, y});
			}
			eArr[i]->Damage = damage;
			eArr[i]->Angle = DegtoRad(angle2);
			eArr[i]->InitD[0] = state;
			eArr[i]->InitD[1] = x;
			eArr[i]->InitD[2] = y;
		}
	}
	bool SE_Claw2(eweapon eArr, int offset, int count, int clawX, int clawY, int angle, int angle2, int spacing, int damage, int targetVertexCount, int vertexGrowth, bool broken){
		int numWeapons = 0;
		for(int i=0; i<count; ++i){
			int i2 = i+offset;
			int dist = -spacing*(count-1)/2;
			if(broken) //I screwed up some calculations but it resulted in a cool looking animation, so this guy's here to re-break it when I want that to stay
				dist = -spacing*(count-1);
			int x = clawX+VectorX(dist+i*spacing, angle-90);
			int y = clawY+VectorY(dist+i*spacing, angle-90);
			if(eArr[i2]->isValid()){
				++numWeapons;
				
				eArr[i2]->Damage = damage;
				eArr[i2]->Angle = DegtoRad(angle2);
				eArr[i2]->InitD[1] = x;
				eArr[i2]->InitD[2] = y;
				
				if(eArr[i2]->InitD[0]<targetVertexCount){
					eArr[i2]->InitD[0] = Min(eArr[i2]->InitD[0]+vertexGrowth, targetVertexCount);
				}
				else if(eArr[i2]->InitD[0]>targetVertexCount){
					eArr[i2]->InitD[0] = Max(eArr[i2]->InitD[0]-vertexGrowth, 0);
					if(eArr[i2]->InitD[0]==0)
						eArr[i2]->DeadState = 0;
				}
			}
			else{
				if(targetVertexCount>0){
					eArr[i2] = CreateEWeaponAt(EW_LUNAR, 120, 80);
					eArr[i2]->Damage = damage;
					eArr[i2]->CollDetection = false;
					eArr[i2]->DrawYOffset = -1000;
					RunEWeaponScript(eArr[i2], "VunterSlaush", {1, x, y});
					
					eArr[i2]->Damage = damage;
					eArr[i2]->Angle = DegtoRad(angle2);
				}
			}
		}
		return numWeapons>0;
	}
	void SE_DrawLinkGrabOutline(untyped vars){
		bitmap b = <bitmap>vars[BITMAP];
		b->Clear(0);
		b->DrawTile(0, 0, 0, Link->Tile-20, 1, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
		b->ReplaceColors(0, Choose(0x71, 0x72, 0x73), 0x01, 0xBF);
		b->Blit(2, RT_SCREEN, 0, 0, 16, 32, Link->X+Rand(-2, 2), Link->Y-Link->Z-16+Rand(-2, 2), 16, 32, 0, 0, 0, 0, 0, true);
	}
	void SE_Wallhack(bool on){
		if(on){
			Ghost_SetFlag(GHF_IGNORE_ALL_TERRAIN);
			Ghost_SetFlag(GHF_IGNORE_NO_ENEMY);
		}
		else{
			Ghost_UnsetFlag(GHF_IGNORE_ALL_TERRAIN);
			Ghost_UnsetFlag(GHF_IGNORE_NO_ENEMY);
		}
	}
	void SE_Waitframe(ffc this, npc ghost, untyped vars, int frames){
		int isFinal = ghost->Attributes[0];
		int combo = ghost->Attributes[10];
		for(int i=0; i<frames; ++i){
			if(Ghost_GotHit())
				++vars[NUMHITS];
			//Screen->DrawInteger(7, 0, 0, FONT_Z3SMALL, 0x01, 0x0F, -1, -1, Screen->NumEWeapons(), 0, 128);
			if(isFinal){
				if(vars[PHASE4LOCK]){
					if(Ghost_HP<=vars[INITHP]*SELET_PERCENT_PHASE4)
						G[G_GRAYHEALTHBAR] = 1;
					Ghost_HP = Clamp(Ghost_HP, vars[INITHP]*SELET_PERCENT_PHASE4, vars[INITHP]);
				}
			}
			else
				Ghost_HP = Clamp(Ghost_HP, vars[INITHP]*SELET_PERCENT_PHASE3, vars[INITHP]);
			if(!SSGhost_Waitframe(this, ghost, false, false)){
				GiveBestiaryEntry(217, true);
				Ghost_HP = 1;
				ghost->HP = 1;
				DeathAnimCleanup(ghost);
				ghost->CollDetection = false;
				Ghost_Data = combo+28;
				for(int j=Screen->NumEWeapons(); j>0; --j){
					eweapon e = Screen->LoadEWeapon(j);
					e->DeadState = 0;
					e->Script = 0;
				}
				for(int j=0; j<32; ++j){
					TurnOffLinkCollision(2);
					NoAction();
					Ghost_Waitframe(this, ghost);
				}
				for(int j=0; j<32; ++j){
					TurnOffLinkCollision(2);
					Screen->Rectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
					NoAction();
					Ghost_WaitframeLight(this, ghost);
				}
				for(int j=0; j<32; ++j){
					TurnOffLinkCollision(2);
					Screen->Rectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
					Screen->Rectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
					NoAction();
					Ghost_WaitframeLight(this, ghost);
				}
				for(int j=0; j<32; ++j){
					TurnOffLinkCollision(2);
					Screen->Rectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
					NoAction();
					Ghost_WaitframeLight(this, ghost);
				}
				if(Game->GetCurMap()==24){
					if(G[G_RANDOMIZERENABLED]){
						FullHeal(true, true, false, false);
						Link->WarpEx({WT_IWARP, 70, 0x07, -1, 1, 0, 0, 0});
					}
					else
						Link->WarpEx({WT_IWARP, 71, 0x27, -1, 1, 0, 0, 0});
				}
				else
					Link->Warp(64, 0x1A);
				ghost->DrawYOffset = -1000;
				// ghost->HP = -1000;
				Quit();
			}
		}
	}
}

lweapon script SeletTelekinesis{
	const int MOVE = 2;
	const int TX = 3;
	const int TY = 4;
	const int DELAY = 5;
	
	bool STCanMoveAtAngle(int x, int y, int dir, int w, int h, int step){
		if(CanWalk8Big(x, y, dir, w*16, h*16, 1, true, true)){
			return true;
		}
		return false;
	}
	void DrawTelekinesisBlock(lweapon this, bitmap b, int layer, int cmb, int cs, int x, int y, int z, int w, int h, int moveAngle){
		int til = Game->ComboTile(cmb);
		
		bool drawAura = true;
		if(z>8)
			layer = 4;
		if(z<0){
			drawAura = false;
			z = 0;
		}
		
		int edgeDist = Clamp(Lerp(0, 8, z/32), 0, 8);
		Screen->Rectangle(0, x+edgeDist, y+edgeDist, x+w*16-1-edgeDist, y+h*16-1-edgeDist, 0x0F, 1, 0, 0, 0, true, 64);
		
		b->ReplaceColors(0, Choose(0x72, 0x73, 0x74), 0x71, 0x7F);
		b->Rectangle(0, 32, 0, 79, 63, 0x00, 1, 0, 0, 0, true, 128);
		b->Blit(0, b, 0, 0, w*16, h*16+16, 32+Choose(0, 1, 3, 4), Choose(0, 1, 3, 4), w*16, h*16+16, 0, 0, 0, 0, 0, true);
		//b->Blit(0, b, 0, 0, w*16, h*16+16, 32+Choose(0, 1, 3, 4), Choose(0, 1, 3, 4), w*16, h*16+16, 0, 0, 0, 0, 0, true);
		if(drawAura){
			b->Blit(layer, RT_SCREEN, 32, 18, w*16+4, h*16+2, x-2, y-z, w*16+4, h*16+2, 0, 0, 0, 0, 0, true);
			b->Blit(4, RT_SCREEN, 32, 0, w*16+4, 18, x-2, y-18-z, w*16+4, 18, 0, 0, 0, 0, 0, true);
		}
		Screen->DrawTile(layer, x, y-z, til, w, h, cs, -1, -1, 0, 0, 0, 0, true, 128);
		Screen->DrawTile(4, x, y-16-z, til-20, w, 1, cs, -1, -1, 0, 0, 0, 0, true, 128);
		
		if(z<=8){
			SolidObjects_Add(0, x, y, w*16, h*16, 0, 0, 0);
			if(moveAngle>-1000)
				MakeHitbox(EW_SCRIPT10, x+VectorX(8, moveAngle), y+VectorY(8, moveAngle), w*16, w*16, this->Damage);
		}
	}
	void GetLinkUnstuck(){
		if(!CanPlace(Link->X, Link->Y+8, 16, 8)){
			Link->X = Clamp(Link->X, 48, 192);
			Link->Y = Clamp(Link->Y, 40, 112);
			if(!CanPlace(Link->X, Link->Y+8, 16, 8)){
				Link->X = Clamp(Link->X, 64, 176);
				Link->Y = Clamp(Link->Y, 56, 96);
			}
		}
	}
	void run(int w, int h, int dir, int move, int tX, int tY, int delay){
		mapdata l2 = Game->LoadTempScreen(2);
		mapdata l4 = Game->LoadTempScreen(4);
		int pos = ComboAt(this->X+8, this->Y+8);
		int cmb = l2->ComboD[pos];
		int x = ComboX(pos);
		int y = ComboY(pos);
		int z = 0;
		bitmap b = Game->CreateBitmap(80, 64);
		b->Clear(0);
		b->DrawTile(0, 0, 0, Game->ComboTile(cmb)-20, w, h+1, 2, -1, -1, 0, 0, 0, 0, true, 128);
		b->ReplaceColors(0, 0x71, 0x01, 0xBF);
		b->Own();
		
		while(true){
			while(this->InitD[DELAY]>0){
				--this->InitD[DELAY];
				Waitframe();
			}
			if(this->InitD[MOVE]){
				for(int i=0; i<w; ++i){
					for(int j=0; j<h; ++j){
						if(j==0)
							l4->ComboD[pos-16+i] = 0;
						l2->ComboD[pos+i+j*16] = 0;
						Screen->ComboF[pos+i+j*16] = CF_NOENEMY;
					}
				}
				for(int i=0; i<8; ++i){
					DrawTelekinesisBlock(this, b, 2, cmb, 2, x+Rand(-1, 1), y+Rand(-1, 1), z, w, h, -1000);
					Waitframe();
				}
				int startX = x;
				int startY = y;
				if(this->InitD[MOVE]==2){
					int moveAngle = Angle(128, 88, startX+w*8, startY+h*8);
					while(x>-32&&x<256&&y-z>-32&&y-z<176){
						z += 1;
						x += VectorX(4, moveAngle);
						y += VectorY(4, moveAngle);
							
						DrawTelekinesisBlock(this, b, 2, cmb, 2, x, y, z, w, h, -1000);
						Waitframe();
					}
					this->DeadState = 0;
					Quit();
				}
				else{
					if(w<2){
						int moveAngle = Angle(x, y, this->InitD[TX], this->InitD[TY]);
						for(int i=0; i<16; ++i){
							z = i/2;
							
							DrawTelekinesisBlock(this, b, 2, cmb, 2, x, y, z, w, h, -1000);
							Waitframe();
						}
						while(Distance(x, y, this->InitD[TX], this->InitD[TY])>=4){
							moveAngle = Angle(x, y, this->InitD[TX], this->InitD[TY]);
							x += VectorX(4, moveAngle);
							y += VectorY(4, moveAngle);
							if(Distance(x, y, this->InitD[TX], this->InitD[TY])<4){
								x = this->InitD[TX];
								y = this->InitD[TY];
								if(!CanPlace(x, y, 16, 16)){
									this->InitD[TX] = startX;
									this->InitD[TY] = startY;
								}
							}
							
							DrawTelekinesisBlock(this, b, 2, cmb, 2, x, y, z, w, h, moveAngle);
							Waitframe();
						}
						for(int i=16; i>0; --i){
							z = i/2;
							
							DrawTelekinesisBlock(this, b, 2, cmb, 2, x, y, z, w, h, -1000);
							Waitframe();
						}
						this->InitD[MOVE] = 0;
						pos = ComboAt(x+8, y+8);
						x = ComboX(pos);
						y = ComboY(pos);
						this->X = x;
						this->Y = y;
						for(int i=0; i<w; ++i){
							for(int j=0; j<h; ++j){
								if(j==0){
									l4->ComboD[pos-16+i] = cmb-4+i;
									l4->ComboC[pos-16+i] = 2;
								}
								l2->ComboD[pos+i+j*16] = cmb+i+4*j;
								l2->ComboC[pos+i+j*16] = 2;
								Screen->ComboF[pos+i+j*16] = 0;
							}
						}
						GetLinkUnstuck();
					}
					else{
						int moveAngle = Angle(x, y, this->InitD[TX], this->InitD[TY]);
						for(int i=0; i<16; ++i){
							z = i/2;
							
							DrawTelekinesisBlock(this, b, 2, cmb, 2, x, y, z, w, h, -1000);
							Waitframe();
						}
						while(Distance(x, y, this->InitD[TX], this->InitD[TY])>=6){
							z = Min(z+3, 64);
							moveAngle = Angle(x, y, this->InitD[TX], this->InitD[TY]);
							x += VectorX(6, moveAngle);
							y += VectorY(6, moveAngle);
							
							DrawTelekinesisBlock(this, b, 2, cmb, 2, x, y, z, w, h, moveAngle);
							Waitframe();
						}
						x = this->InitD[TX];
						y = this->InitD[TY];
						while(z>0){
							z = Max(z-6, 0);
							
							DrawTelekinesisBlock(this, b, 2, cmb, 2, x, y, z, w, h, moveAngle);
							Waitframe();
						}
						for(int i=0; i<16; ++i){
							if(i%4==0){
								eweapon e = FireEWeapon(EW_BOMBBLAST, x+Rand(-8, 24), y+Rand(-8, 24), 0, 0, this->Damage, 0, 0, 0);
							}
							DrawTelekinesisBlock(this, b, 2, cmb, 2, x, y, -1, w, h, moveAngle);
							Waitframe();
						}
						if(!CanPlace(x, y, 32, 32)){
							this->InitD[TX] = startX;
							this->InitD[TY] = startY;
							while(Distance(x, y, this->InitD[TX], this->InitD[TY])>=6){
								z = Min(z+3, 64);
								moveAngle = Angle(x, y, this->InitD[TX], this->InitD[TY]);
								x += VectorX(6, moveAngle);
								y += VectorY(6, moveAngle);
								if(Distance(x, y, this->InitD[TX], this->InitD[TY])<6){
									x = this->InitD[TX];
									y = this->InitD[TY];
									if(!CanPlace(x, y, 16, 16)){
										this->InitD[TX] = startX;
										this->InitD[TY] = startY;
									}
								}
								
								DrawTelekinesisBlock(this, b, 2, cmb, 2, x, y, z, w, h, moveAngle);
								Waitframe();
							}
							x = this->InitD[TX];
							y = this->InitD[TY];
							while(z>0){
								z = Max(z-3, 0);
								
								DrawTelekinesisBlock(this, b, 2, cmb, 2, x, y, z, w, h, moveAngle);
								Waitframe();
							}
						}
						
						this->InitD[MOVE] = 0;
						pos = ComboAt(x+8, y+8);
						x = ComboX(pos);
						y = ComboY(pos);
						this->X = x;
						this->Y = y;
						for(int i=0; i<w; ++i){
							for(int j=0; j<h; ++j){
								if(j==0){
									l4->ComboD[pos-16+i] = cmb-4+i;
									l4->ComboC[pos-16+i] = 2;
								}
								l2->ComboD[pos+i+j*16] = cmb+i+4*j;
								l2->ComboC[pos+i+j*16] = 2;
								Screen->ComboF[pos+i+j*16] = 0;
							}
						}
						GetLinkUnstuck();
					}
				}
			}
			Waitframe();
		}
	}
}

ffc script PirateCaptain{
	void run(int enemyid){
		int i;
		int x; int y;
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		Ghost_SetFlag(GHF_4WAY);
		Ghost_SetFlag(GHF_NORMAL);
		Ghost_UnsetFlag(GHF_SET_DIRECTION);
		Ghost_UnsetFlag(GHF_STUN);
		
		int combo = ghost->Attributes[10];
		int counter = -1;
		Ghost_Transform(this, ghost, -1, -1, 1, 2);
		Ghost_SetHitOffsets(ghost, 0, 16, 0, 0);
		ghost->DrawYOffset -= 16;
		int sightCooldown;
		int Attack= 1;
		if(Game->GetCurMap() == 38)
			Ghost_HP = 8000;
		int MaxHP = Ghost_HP;
		ghost->HP = Ghost_HP;
		ghost->Misc[NPCM_DAMAGENUMBERSLASTHP] = ghost->HP;
		int cycle;
		Game->PlayEnhancedMusic("SS-Boss.ogg", 0);
		RunFFCScript(Game->GetFFCScript("HealthBar_Tiled_Single"), {ghost->ID, 14, 0, 1});
		SSGhost_Waitframes(this, ghost, 90);
		while(true){
			//Walking phase
			Attack = Rand(0,1);
			if(Attack == 0){ //Dash, slashing at the end, 3 times
				for(int j = 0; j<3; j++){
					int angle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
					Ghost_Dir = AngleDir4(angle);
					SSGhost_Waitframes(this, ghost, 8);
					for(int i=0; i<16; ++i){
						Ghost_MoveAtAngle(angle, 3.75, 0);
						SSGhost_Waitframe(this, ghost);
					}
					Game->PlaySound(SFX_SWORD);
					Ghost_Data = combo+4;
					for(i=0; i<4; ++i){
						Ghost_Move(Ghost_Dir, 2, 0);
						QuickSword(EW_PHYSICAL, Ghost_X, Ghost_Y, DirAngle(Ghost_Dir)-90, i*4, CMB_PIRATE_WEAPONS, 11, ghost->WeaponDamage);
						SSGhost_Waitframe(this, ghost);
					}
					for(i=0; i<9; ++i){
						QuickSword(EW_PHYSICAL, Ghost_X, Ghost_Y, DirAngle(Ghost_Dir)-90+i*20, 16, CMB_PIRATE_WEAPONS, 11, ghost->WeaponDamage);
						SSGhost_Waitframe(this, ghost);
					}
					for(i=0; i<4; ++i){
						Ghost_Move(OppositeDir(Ghost_Dir), 2, 0);
						QuickSword(EW_PHYSICAL, Ghost_X, Ghost_Y, DirAngle(Ghost_Dir)+90, 16-i*4, CMB_PIRATE_WEAPONS, 11, ghost->WeaponDamage);
						SSGhost_Waitframe(this, ghost);
					}
					Ghost_Data = combo;
					SSGhost_Waitframes(this, ghost, 10);
				}
				if(Ghost_HP <= MaxHP*0.5){
					Ghost_Data = combo+4;
					Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
					Game->PlaySound(SFX_ARROW);
					for(i=0; i<4; ++i){
						Screen->FastCombo(2, Ghost_X+DirX(Ghost_Dir, i*3), Ghost_Y+DirY(Ghost_Dir, i*3), CMB_PIRATE_WEAPONS+2, 11, 128);
						SSGhost_Waitframe(this, ghost);
					}
					for(i=0; i<4; ++i){
						Screen->FastCombo(2, Ghost_X+DirX(Ghost_Dir, 12), Ghost_Y+DirY(Ghost_Dir, 12), CMB_PIRATE_WEAPONS+2, 11, 128);
						SSGhost_Waitframe(this, ghost);
					}
					int r; int flip;
					int layer = 2;
					for(int j = 0; j<3; j++){
						Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
						switch(Ghost_Dir){
							case DIR_UP: r = 90; flip = 1; break;
							case DIR_DOWN: r = 90; layer = 2; break;
							case DIR_LEFT: flip = 1; break;
							case DIR_RIGHT: break;
						}
						for(i=0; i<4; ++i){
							x = Ghost_X+DirX(Ghost_Dir, 12);
							y = Ghost_Y+DirY(Ghost_Dir, 12)-4;
							Screen->DrawCombo(layer, x, y, CMB_PIRATE_WEAPONS+1, 1, 1, 11, -1, -1, x, y, r, -1, flip, true, 128);
							SSGhost_Waitframe(this, ghost);
						}
						eweapon e = FireAimedEWeapon(EW_PHYSICAL, Ghost_X+DirX(Ghost_Dir, 12), Ghost_Y+DirY(Ghost_Dir, 12), 0, 350, ghost->WeaponDamage, 0, SFX_PIRATE_BULLET, 0);
						e->HitXOffset = 4;
						e->HitYOffset = 4;
						e->HitWidth = 8;
						e->HitHeight = 8;
						e->OriginalTile = TIL_PIRATE_BULLET;
						e->Tile = e->OriginalTile;
						e->CSet = 11;
						for(int i=0; i<5; ++i){
							x = Ghost_X+DirX(Ghost_Dir, 12);
							y = Ghost_Y+DirY(Ghost_Dir, 12)-4;
							Screen->DrawCombo(layer, x, y, CMB_PIRATE_WEAPONS+1, 1, 1, 11, -1, -1, x, y, r, -1, flip, true, 128);
							SSGhost_Waitframe(this, ghost);
						}
					}
					for(int i=0; i<16; ++i){
						x = Ghost_X+DirX(Ghost_Dir, 12);
						y = Ghost_Y+DirY(Ghost_Dir, 12)-4;
						Screen->DrawCombo(layer, x, y, CMB_PIRATE_WEAPONS+1, 1, 1, 11, -1, -1, x, y, r, -1, flip, true, 128);
						SSGhost_Waitframe(this, ghost);
					}
					for(int i=0; i<4; ++i){
						x = Ghost_X+DirX(Ghost_Dir, 12-i*3);
						y = Ghost_Y+DirY(Ghost_Dir, 12-i*3)-4;
						Screen->DrawCombo(layer, x, y, CMB_PIRATE_WEAPONS+1, 1, 1, 11, -1, -1, x, y, r, -1, flip, true, 128);
						SSGhost_Waitframe(this, ghost);
					}
					
					Ghost_Data = combo;
				}
			}
			if(Attack == 1){ //Slowly walking and firing
				Ghost_Data = combo+4;
				Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
				Game->PlaySound(SFX_ARROW);
				for(i=0; i<4; ++i){
					Screen->FastCombo(2, Ghost_X+DirX(Ghost_Dir, i*3), Ghost_Y+DirY(Ghost_Dir, i*3), CMB_PIRATE_WEAPONS+2, 11, 128);
					SSGhost_Waitframe(this, ghost);
				}
				for(i=0; i<4; ++i){
					Screen->FastCombo(2, Ghost_X+DirX(Ghost_Dir, 12), Ghost_Y+DirY(Ghost_Dir, 12), CMB_PIRATE_WEAPONS+2, 11, 128);
					SSGhost_Waitframe(this, ghost);
				}
				Ghost_Data = combo;
				int r; int flip;
				int layer = 2;
				int Angle;
				for(int j = 0; j<240; j++){
					Angle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
					Ghost_Dir = AngleDir4(Angle);
					//Move
					Ghost_MoveAtAngle(Angle, 0.7*EasyModeMultiplier(0.5), 0);
					//Draw gun
					switch(Ghost_Dir){
						case DIR_UP: r = 90; flip = 1; layer = 0; break;
						case DIR_DOWN: r = 90; layer = 2; flip = 0; break;
						case DIR_LEFT: r = 0; flip = 1; layer = 2; break;
						case DIR_RIGHT: r = 0; flip = 0; layer = 2; break;
					}
					x = Ghost_X+DirX(Ghost_Dir, 12);
					y = Ghost_Y+DirY(Ghost_Dir, 12)-4;
					Screen->DrawCombo(layer, x, y, CMB_PIRATE_WEAPONS+1, 1, 1, 11, -1, -1, x, y, r, -1, flip, true, 128);
					int shotFreq = 30;
					int batteryFreq = 75;
					if(IsEasyMode()){
						shotFreq = 60;
						batteryFreq = 175;
					}
					//Fire periodically
					if(j%shotFreq == 0){
						eweapon e = FireAimedEWeapon(EW_PHYSICAL, Ghost_X+DirX(Ghost_Dir, 12), Ghost_Y+DirY(Ghost_Dir, 12), 0, 350, ghost->WeaponDamage, 0, SFX_PIRATE_BULLET, 0);
						e->HitXOffset = 4;
						e->HitYOffset = 4;
						e->HitWidth = 8;
						e->HitHeight = 8;
						e->OriginalTile = TIL_PIRATE_BULLET;
						e->Tile = e->OriginalTile;
						e->CSet = 11;
					}
					//Fire batteries at lower hp
					if(j%batteryFreq == 0){
						if(Ghost_HP < MaxHP * 0.75){
							for(int i = 0; i<1; i++){
								int DestX; int DestY;
								do{
									DestX = Rand(16, 224);
									DestY = Rand(16, 144);
								}
								while(Distance(Link->X, Link->Y, DestX, DestY) < 64);
								int oldDir = Ghost_Dir;
								Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, DestX, DestY));
								if(!Ghost_CanMove(Ghost_Dir, 1, 0))
									Ghost_Dir = oldDir;
								
								eweapon e = FireEWeapon(EW_SCRIPT1, Ghost_X+DirX(Ghost_Dir, 16), Ghost_Y+DirY(Ghost_Dir, 16), DegtoRad(Angle(Ghost_X, Ghost_Y, DestX, DestY)), 0, ghost->WeaponDamage, 0, 0, 0);
								e->CollDetection = false;
								e->Tile = GH_BLANK_TILE;
								RunEWeaponScript(e, "MagicBatteryEWRasu", {0, 4, DestX, DestY, 2, ghost, -1});
							}
						}
					}
					SSGhost_Waitframe(this, ghost);
				}
				if(Ghost_HP > MaxHP *0.5){
					//Put away gun
					for(int i=0; i<16; ++i){
						x = Ghost_X+DirX(Ghost_Dir, 12);
						y = Ghost_Y+DirY(Ghost_Dir, 12)-4;
						Screen->DrawCombo(layer, x, y, CMB_PIRATE_WEAPONS+1, 1, 1, 11, -1, -1, x, y, r, -1, flip, true, 128);
						SSGhost_Waitframe(this, ghost);
					}
					for(int i=0; i<4; ++i){
						x = Ghost_X+DirX(Ghost_Dir, 12-i*3);
						y = Ghost_Y+DirY(Ghost_Dir, 12-i*3)-4;
						Screen->DrawCombo(layer, x, y, CMB_PIRATE_WEAPONS+1, 1, 1, 11, -1, -1, x, y, r, -1, flip, true, 128);
						SSGhost_Waitframe(this, ghost);
					}
				}
				else{
					int angle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
					Ghost_Dir = AngleDir4(angle);
					SSGhost_Waitframes(this, ghost, 8);
					for(int i=0; i<16; ++i){
						Ghost_MoveAtAngle(angle, 4, 0);
						SSGhost_Waitframe(this, ghost);
					}
					Game->PlaySound(SFX_SWORD);
					Ghost_Data = combo+4;
					for(i=0; i<4; ++i){
						Ghost_Move(Ghost_Dir, 2, 0);
						QuickSword(EW_PHYSICAL, Ghost_X, Ghost_Y, DirAngle(Ghost_Dir)-90, i*4, CMB_PIRATE_WEAPONS, 11, ghost->WeaponDamage);
						SSGhost_Waitframe(this, ghost);
					}
					for(i=0; i<9; ++i){
						QuickSword(EW_PHYSICAL, Ghost_X, Ghost_Y, DirAngle(Ghost_Dir)-90+i*20, 16, CMB_PIRATE_WEAPONS, 11, ghost->WeaponDamage);
						SSGhost_Waitframe(this, ghost);
					}
					for(i=0; i<4; ++i){
						Ghost_Move(OppositeDir(Ghost_Dir), 2, 0);
						QuickSword(EW_PHYSICAL, Ghost_X, Ghost_Y, DirAngle(Ghost_Dir)+90, 16-i*4, CMB_PIRATE_WEAPONS, 11, ghost->WeaponDamage);
						SSGhost_Waitframe(this, ghost);
					}
					Ghost_Data = combo;
					SSGhost_Waitframes(this, ghost, 10);
				}
				
				Ghost_Data = combo;
			}
			SSGhost_Waitframes(this, ghost, (Ghost_HP<=(MaxHP*0.5))?60:120);
			//Attacking phase
			Attack = Rand(0,2);
			if(Attack == 0){ //Fire shots that split in + or x shapes
				Ghost_Data = combo+4;
				int type = 1;
				if(Ghost_HP <= MaxHP * 0.5)
					type = Rand(1,2);
				if(type == 2){
					Game->PlaySound(35);
					Ghost_Dir = DIR_UP;
					SSGhost_Waitframes(this, ghost, 2);
					Ghost_Dir = DIR_LEFT;
					SSGhost_Waitframes(this, ghost, 2);
					Ghost_Dir = DIR_DOWN;
					SSGhost_Waitframes(this, ghost, 2);
					Ghost_Dir = DIR_RIGHT;
					SSGhost_Waitframes(this, ghost, 2);
				}
				for(int i = 0; i<3; i++){
					int oldDir = Ghost_Dir;
					Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
					if(!Ghost_CanMove(Ghost_Dir, 1, 0))
						Ghost_Dir = oldDir;
					
					eweapon e = FireAimedEWeapon(EW_SCRIPT1, Ghost_X+DirX(Ghost_Dir, 16), Ghost_Y+DirY(Ghost_Dir, 16), 0, 0, ghost->WeaponDamage, 0, 0, 0);
					e->CollDetection = false;
					e->Tile = GH_BLANK_TILE;
					// RunEWeaponScript(e, "MagicBatteryEWRasu", {0, ((Ghost_HP<=(MaxHP*0.35))?(Rand(1,2)):type), Link->X, Link->Y, 2, ghost}); //This old version would be random below a certain HP. Moosh said very not okay.
					RunEWeaponScript(e, "MagicBatteryEWRasu", {0, type, Link->X, Link->Y, ClampThatThrow(Link->X, Link->Y, 2), ghost});
					SSGhost_Waitframes(this, ghost, 24+EasyModeFrames(40));
				}
				if(Ghost_HP <= MaxHP*0.5 && !IsEasyMode()){
					SSGhost_Waitframes(this, ghost, 24);
					for(int i = 1; i<=2; i++){
						int oldDir = Ghost_Dir;
						Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
						if(!Ghost_CanMove(Ghost_Dir, 1, 0))
							Ghost_Dir = oldDir;
						
						eweapon e = FireAimedEWeapon(EW_SCRIPT1, Ghost_X+DirX(Ghost_Dir, 16), Ghost_Y+DirY(Ghost_Dir, 16), 0, 0, ghost->WeaponDamage, 0, 0, 0);
						e->CollDetection = false;
						e->Tile = GH_BLANK_TILE;
						RunEWeaponScript(e, "MagicBatteryEWRasu", {0, i, Link->X, Link->Y, ClampThatThrow(Link->X, Link->Y, 2), ghost});
					}
				}
				
				Ghost_Data = combo;
			}
			if(Attack == 1){ //A five shot fan
				Ghost_Data = combo+4;
				int oldDir = Ghost_Dir;
				int Angle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
				Ghost_Dir = AngleDir4(Angle);
				if(!Ghost_CanMove(Ghost_Dir, 1, 0))
					Ghost_Dir = oldDir;
				for(int i = 0; i<5; ++i){
					int newAng = Lerp(-60, 60, i/4);
					if(IsEasyMode())
						newAng = Lerp(-80, 80, i/4);
					eweapon e = FireAimedEWeapon(EW_SCRIPT1, Ghost_X+DirX(Ghost_Dir, 16), Ghost_Y+DirY(Ghost_Dir, 16), DegtoRad(Angle+newAng), 0, ghost->WeaponDamage, 0, 0, 0);
					e->CollDetection = false;
					e->Tile = GH_BLANK_TILE;
					RunEWeaponScript(e, "MagicBatteryEWRasu", {0, 4, Ghost_X+VectorX(24, Angle), Ghost_Y + VectorY(24, Angle), ClampThatThrow(Ghost_X+VectorX(24, Angle), Ghost_Y + VectorY(24, Angle), 0.35), ghost, Angle + newAng});
				}
				// if(Ghost_HP <= MaxHP*0.5){
					// SSGhost_Waitframes(this, ghost, 12);
					// eweapon e = FireAimedEWeapon(EW_SCRIPT1, Ghost_X+DirX(Ghost_Dir, 16), Ghost_Y+DirY(Ghost_Dir, 16), 0, 0, ghost->WeaponDamage, 0, 0, 0);
					// e->CollDetection = false;
					// e->Tile = GH_BLANK_TILE;
					// RunEWeaponScript(e, "MagicBatteryEWRasu", {0, Rand(1,2), Link->X, Link->Y, ClampThatThrow(Link->X, Link->Y, 2), ghost});
				// }
				SSGhost_Waitframes(this, ghost, 24);
				Ghost_Data = combo;
			}
			if(Attack == 2){ //Randomly throw batteries that fire homing shots
				Ghost_Data = combo+4;
				int batteryCount = ((Ghost_HP<=(MaxHP*0.5))?5:4);
				if(IsEasyMode())
					batteryCount -= 1;
				for(int i = 0; i<batteryCount; i++){
					int DestX; int DestY;
					do{
						DestX = Rand(16, 224);
						DestY = Rand(16, 144);
					}
					while(Distance(Link->X, Link->Y, DestX, DestY) < 64);
					int oldDir = Ghost_Dir;
					Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, DestX, DestY));
					if(!Ghost_CanMove(Ghost_Dir, 1, 0))
						Ghost_Dir = oldDir;
					
					eweapon e = FireEWeapon(EW_SCRIPT1, Ghost_X+DirX(Ghost_Dir, 16), Ghost_Y+DirY(Ghost_Dir, 16), DegtoRad(Angle(Ghost_X, Ghost_Y, DestX, DestY)), 0, ghost->WeaponDamage, 0, 0, 0);
					e->CollDetection = false;
					e->Tile = GH_BLANK_TILE;
					RunEWeaponScript(e, "MagicBatteryEWRasu", {0, 4, DestX, DestY, 2, ghost, -1});
					SSGhost_Waitframes(this, ghost, (Ghost_HP<=(MaxHP*0.5))?10:20+EasyModeFrames(30));
				}
				Ghost_Data = combo;
			}
			SSGhost_Waitframes(this, ghost, 60);
			
			if(cycle == 0){
				//Refresh the solar batteries
				Ghost_Data = combo+4;
				for(int i = 0; i<((Ghost_HP<=(MaxHP*0.5))?4:3); i++){
					int DestX = Rand(16, 224);
					int DestY = Rand(16, 144);
					int oldDir = Ghost_Dir;
					Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, DestX, DestY));
					if(!Ghost_CanMove(Ghost_Dir, 1, 0))
						Ghost_Dir = oldDir;
					
					eweapon e = FireEWeapon(EW_SCRIPT1, Ghost_X+DirX(Ghost_Dir, 16), Ghost_Y+DirY(Ghost_Dir, 16), DegtoRad(Angle(Ghost_X, Ghost_Y, DestX, DestY)), 0, ghost->WeaponDamage, 0, 0, 0);
					e->CollDetection = false;
					e->Tile = GH_BLANK_TILE;
					RunEWeaponScript(e, "MagicBatteryEWRasu", {0, 3, DestX, DestY, 2, ghost});
					SSGhost_Waitframes(this, ghost, 12);
					Ghost_Data = combo;
				}
				SSGhost_Waitframes(this, ghost, 60);
				cycle = 1;
			}
			else{
				//Stand around and get whacked
				SSGhost_Waitframes(this, ghost, 120);
				cycle = 0;
			}
			
			SSGhost_Waitframes(this, ghost, 60);
		}
	}
}

int ClampThatThrow(int DestX, int DestY, int Step){
	int Dist = Distance(Ghost_X, Ghost_Y, DestX, DestY);
	int Time = Dist / Step;
	if(Time > 30)
		return Step;
	else{
		// Trace(Dist/30);
		// return Dist/30;
		return 0.5;
	}
}

ffc script GhostGhostBroughToYouByGhost{
	void run(int enemyid){
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		int combo = ghost->Attributes[10];
		int cx;
		int cy;
		int vx;
		int vy;
		int sineTime;
		int moveAngle;
		int state;
		int lazyChaseFrames;
		int teleportCooldown = Rand(8)*16;
		bool enteredScreen;
		ghost->CollDetection = false;
		ghost->DrawXOffset = -1000;
		while(true){
			switch(state){
				case 0: //Waiting
					if(teleportCooldown)
						--teleportCooldown;
					else{
						state = 1;
						sineTime = Rand(360);
						if(Rand(2)==0){
							cx = Rand(160);
							cy = Choose(0-48, 160+48);
						}
						else{
							cx = Choose(0-48, 240+48);
							cy = Rand(240);
						}
						moveAngle = Angle(cx, cy, Link->X, Link->Y)+Rand(-30, 30);
						vx = VectorX(0.5, moveAngle);
						vy = VectorY(0.5, moveAngle);
						lazyChaseFrames = 300;
					}
					break;
				case 1:
					if(lazyChaseFrames||Distance(0, 0, vx, vy)<0.4){
						if(Distance(Link->X, Link->Y, cx, cy)>24){
							vx = LazyChase(vx, cx, Link->X, 0.01, 0.5);
							vy = LazyChase(vy, cy, Link->Y, 0.01, 0.5);
						}
						if(lazyChaseFrames)
							--lazyChaseFrames;
					}
					cx += vx;
					cy += vy;
					moveAngle = Angle(0, 0, vx, vy);
					int speed = Distance(0, 0, vx, vy);
					Ghost_X = Clamp(cx+VectorX(Lerp(0, 32, speed/0.5)*Sin(sineTime), moveAngle+90), -16, 256);
					Ghost_Y = Clamp(cy+VectorY(Lerp(0, 32, speed/0.5)*Sin(sineTime), moveAngle+90), -16, 176);
					sineTime = (sineTime+1)%360;
					int dist = Distance(cx, cy, Link->X, Link->Y);
					if(cx<Link->X)
						Ghost_Data = combo+1;
					else
						Ghost_Data = combo;
					if(ghost->HP>0){
						if(dist<48){
							ghost->DrawXOffset = -1000;
							ghost->DrawStyle = DS_NORMAL;
							if(G[G_ANIM]%4<2)
								Screen->FastCombo(2, Ghost_X, Ghost_Y, Ghost_Data, this->CSet, 128);
							ghost->CollDetection = true;
						}
						else if(dist<80){
							ghost->DrawXOffset = -1000;
							ghost->DrawStyle = DS_PHANTOM;
							if(G[G_ANIM]%4<2)
								Screen->FastCombo(2, Ghost_X, Ghost_Y, Ghost_Data, this->CSet, 64);
							ghost->CollDetection = true;
						}
						else{
							ghost->DrawXOffset = -1000;
							ghost->CollDetection = false;
						}
					}
					else
						ghost->DrawXOffset = 0;
					
					
					if(cx<0-48||cx>240+48||cy<0-48||cy>160+48){
						state = 0;
						teleportCooldown = Rand(4)*8;
					}
				
					break;
			}
			Ghost_Waitframe(this, ghost);
		}
	}
}

ffc script MumiWhy{
	void run(int enemyid){
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		Ghost_SetFlag(GHF_4WAY);
		Ghost_SetFlag(GHF_NORMAL);
		Ghost_UnsetFlag(GHF_SET_DIRECTION);
		int level = ghost->Attributes[0];
		int combo = ghost->Attributes[10];
		int counter = -1;
		Ghost_Transform(this, ghost, -1, -1, 1, 2);
		Ghost_SetHitOffsets(ghost, 0, 16, 0, 0);
		ghost->DrawYOffset -= 16;
		SetOverUnderLayer(ghost);
		int dashCooldown = 120;
		while(true){
			if(dashCooldown)
				--dashCooldown;
			else if(CanSeeLink(Ghost_X, Ghost_Y, Ghost_Dir, 48)&&Rand(32)==0){
				Ghost_Data = combo;
				int angle;
				if(level==0){
					for(int i=0; i<8; ++i){
						angle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
						Ghost_Dir = AngleDir4(angle);
						SSGhost_Waitframe(this, ghost);
					}
					Ghost_Data = combo+4;
					for(int i=0; i<32; ++i){
						Ghost_MoveAtAngle(angle, 1.5, 0);
						SSGhost_Waitframe(this, ghost);
					}
				}
				else if(level==1){
					for(int i=0; i<16; ++i){
						angle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
						Ghost_Dir = AngleDir4(angle);
						SSGhost_Waitframe(this, ghost);
					}
					Ghost_Data = combo+4;
					for(int i=0; i<16; ++i){
						Ghost_MoveAtAngle(angle, 3, 0);
						SSGhost_Waitframe(this, ghost);
					}
				}
				counter = -1;
				dashCooldown = 120;
			}
			Ghost_Data = combo+4;
			counter = Ghost_ConstantWalk4(counter, ghost->Step, ghost->Rate, ghost->Homing, ghost->Hunger);
			SSGhost_Waitframe(this, ghost);
		}
	}
}

const int SPRITE_INVISIBLE = 108;

ffc script LunarGoriya{
	void run(int enemyid){
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		Ghost_SetFlag(GHF_4WAY);
		Ghost_SetFlag(GHF_NORMAL);
		Ghost_UnsetFlag(GHF_SET_DIRECTION);
		
		int combo = ghost->Attributes[10];
		int counter = -1;
		SetOverUnderLayer(ghost);
		while(true){
			counter = Ghost_HaltingWalk4(counter, ghost->Step, ghost->Rate, ghost->Homing, ghost->Hunger, ghost->Haltrate, 48);
			if(counter==47&&Ghost_OnLinkLayer()){
				Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
				
				Ghost_UnsetFlag(GHF_KNOCKBACK);
				for(int i=0; i<40; ++i){
					Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
					SSGhost_Waitframe(this, ghost);
				}
				
				Ghost_Data = combo+4;
				eweapon e = FireNonAngularEWeapon(EW_LUNAR, Ghost_X+DirX(Ghost_Dir, 16), Ghost_Y+DirY(Ghost_Dir, 16), Ghost_Dir, 150, ghost->WeaponDamage, 5, 4, 0);
				e->CollDetection = false;
				// RunEWeaponScript(e, "Lunarang", {1, 0});
				// SSGhost_Waitframes(this, ghost, 48);
				for(int i = 0; i<30&&e->isValid(); i++){
					if(Screen->isSolid(e->X+8, e->Y+8)&&i>10){
						break;
					}
					if(i%5==0)
						Game->PlaySound(4);
					eweapon hitbox = FireEWeapon(EW_LUNAR, e->X, e->Y, e->Dir, 0, ghost->WeaponDamage, SPRITE_INVISIBLE, 0, 0);
					SetEWeaponLifespan(hitbox, EWL_TIMER, 2);
					SetEWeaponDeathEffect(hitbox, EWD_VANISH, 0);
					SSGhost_Waitframe(this, ghost);
				}
				int angle = Angle(this->X, this->Y, Link->X, Link->Y)-90;
				for(int i=0; i<4&&e->isValid(); ++i){
					eweapon f = FireEWeapon(EW_LUNAR, e->X, e->Y, 0, 0, e->Damage, SPR_LUNARSHOT, SFX_FIREBALL, EWF_UNBLOCKABLE);
					RunEWeaponScript(f, "LunarSwirl", {angle, 16+i*4, 1, 20, i*4, 0});
					f = FireEWeapon(EW_LUNAR, e->X, e->Y, 0, 0, e->Damage, SPR_LUNARSHOT, SFX_FIREBALL, EWF_UNBLOCKABLE);
					RunEWeaponScript(f, "LunarSwirl", {angle+180, 16+i*8, 1, 20, i*4, 0});
				}
				e->Dir = OppositeDir(e->Dir);
				e->Angular = true;
				e->Angle = DegtoRad(Angle(e->X, e->Y, Ghost_X, Ghost_Y));
				int i = 0;
				while(Distance(e->X, e->Y, Ghost_X, Ghost_Y) > 4&&e->isValid()){
					e->Angle = DegtoRad(Angle(e->X, e->Y, Ghost_X, Ghost_Y));
					i++;
					if(i%5==0)
						Game->PlaySound(4);
					SSGhost_Waitframe(this, ghost);
				}
				Remove(e);
				Ghost_Data = combo;
				Ghost_SetFlag(GHF_KNOCKBACK);
			}
			if(GLW[GL_MAGNETHITBOX]->isValid()&&Collision(GLW[GL_MAGNETHITBOX], ghost)){
				while(GLW[GL_MAGNETHITBOX]->isValid()&&Collision(GLW[GL_MAGNETHITBOX], ghost)){
					if(GLW[GL_MAGNETHITBOX]->Damage==STATE_TIDALGAUNTLET_MOON)
						Ghost_MoveXY(-DirX(GLW[GL_MAGNETHITBOX]->Dir, 0.5*MagnetModifier()), -DirY(GLW[GL_MAGNETHITBOX]->Dir, 0.5*MagnetModifier()), 0);
					else
						Ghost_MoveXY(DirX(GLW[GL_MAGNETHITBOX]->Dir, 0.5*MagnetModifier()), DirY(GLW[GL_MAGNETHITBOX]->Dir, 0.5*MagnetModifier()), 0);
					SSGhost_Waitframe(this, ghost);
				}
				int pos = ComboAt(Ghost_X+8, Ghost_Y+8);
				for(int i=0; i<8; ++i){
					if(Distance(Ghost_X, Ghost_Y, ComboX(pos), ComboY(pos))>2){
						Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, ComboX(pos), ComboY(pos)), 2, 0);
					}
					else{
						Ghost_X = ComboX(pos);
						Ghost_Y = ComboY(pos);
						break;
					}
					if(GLW[GL_MAGNETHITBOX]->isValid()&&Collision(GLW[GL_MAGNETHITBOX], ghost))
						break;
					SSGhost_Waitframe(this, ghost);
				}
			}
			Ghost_Pitfall(this, ghost);
			SSGhost_Waitframe(this, ghost);
		}
	}
}

ffc script SolarTektite{
	void run(int enemyid){
		int i; int j;
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		Ghost_SetFlag(GHF_STUN);
		Ghost_SetFlag(GHF_CLOCK);
		Ghost_SetFlag(GHF_FAKE_Z);
		Ghost_SetFlag(GHF_NO_FALL);
		Ghost_SetFlag(GHF_IGNORE_ALL_TERRAIN);
		Ghost_SetFlag(GHF_SET_OVERLAY);
		
		int combo = ghost->Attributes[10];
		int counter = -1;
		bool removedGem;
		int DestX; int DestY;
		int Step = ghost->Step * 0.01;
		//SetOverUnderLayer(ghost);
		int breakcounter;
		while(true){
			for(int i = Rand(30, 180); i>0; i--){ //Wait around
				if(NPC_MagnetShake(this, ghost, 48, STATE_TIDALGAUNTLET_SUN, removedGem)){
					Game->PlaySound(SFX_COMPONENTREMOVED);
					removedGem = true;
					combo+=4;
					Ghost_Data = combo;
					NPC_MakeMagnetizedComponent(Ghost_X, Ghost_Y-4, TIL_COMPONENT_SUNGEM, 0, {STATE_TIDALGAUNTLET_SUN, 1.2, 32});
				}
				SSGhost_Waitframe(this, ghost);
			}
			//Jump
			breakcounter = 0;
			if(Rand(0,2) == 0){ //Aim at Link
				do{
					DestX = Rand(16, 224);
					DestY = Rand(16, 144);
					breakcounter++;
				}
				while(Distance(Link->X, Link->Y, DestX, DestY) > 16 && breakcounter<100);
			}
			else{
				do{
					DestX = Rand(16, 224);
					DestY = Rand(16, 144);
					breakcounter++;
				}
				while(Distance(Ghost_X, Ghost_Y, DestX, DestY) < 48 || Distance(Ghost_X, Ghost_Y, DestX, DestY) > 100 && breakcounter<100);
			}
			Ghost_Data = combo+1;
			for(int i = 30; i>0; i--){ //Wait 
				if(NPC_MagnetShake(this, ghost, 48, STATE_TIDALGAUNTLET_SUN, removedGem)){
					Game->PlaySound(SFX_COMPONENTREMOVED);
					removedGem = true;
					combo+=4;
					Ghost_Data = combo;
					NPC_MakeMagnetizedComponent(Ghost_X, Ghost_Y-4, TIL_COMPONENT_SUNGEM, 0, {STATE_TIDALGAUNTLET_SUN, 1.2, 32});
				}
				SSGhost_Waitframe(this, ghost);
			}
			Ghost_Data = combo+2;
			int halftrav = Distance(Ghost_X, Ghost_Y, DestX, DestY) * 0.5;
			Ghost_Z = 1;
			int trav;
			while(Ghost_Z > 0){
				Ghost_X += VectorX(Step, Angle(Ghost_X, Ghost_Y, DestX, DestY));
				Ghost_Y += VectorY(Step, Angle(Ghost_X, Ghost_Y, DestX, DestY));
				if(trav > halftrav)
					Ghost_Z--;
				else
					Ghost_Z++;
				trav+=Step;
				SSGhost_Waitframe(this, ghost);
			}
			if(!removedGem){
				Game->PlaySound(3);
				eweapon e = FireEWeapon(EW_SOLAR, Ghost_X, Ghost_Y,0, 0, ghost->WeaponDamage, 0, SFX_LIGHTSHOT, EWF_UNBLOCKABLE);
				e->CollDetection = false;
				RunEWeaponScript(e, "SolarBigShot", {0, 16, 0.5, 0.2, 0, 32});
			}
			Ghost_Data = combo;
			SSGhost_Waitframe(this, ghost);
		}
	}
}

ffc script StellarRope{
	void run(int enemyid){
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		int chargeDelay = Rand(120, 180);
		int chargeChance = 32;
		bool charged;
		int xy[2];
		while(true){
			if(chargeDelay>0)
				--chargeDelay;
			else if(!charged&&Rand(chargeChance)==0){
				charged = true;
				Game->PlaySound(SFX_CHARGE1);
			}
			
			if(charged){
				GetDirXYOffset(xy, Ghost_Dir, {7,1, 7,6, 3,2, 12,2}); //Reach up
				if(G[G_ANIM]%4<2)
					Screen->Circle(Ghost_Dir==DIR_UP?2:4, Ghost_X+xy[0]+Rand(-1, 1), Ghost_Y+xy[1]+Rand(-1, 1), 3, Choose(0x91, 0x96, 0x97), 1, 0, 0, 0, true, 128);
				if(Ghost_GotHit()&&ghost->Stun==0){
					int angle = DirAngle(Ghost_Dir&3);
					for(int i=0; i<2; ++i){
						eweapon e = FireEWeapon(EW_STELLAR, Ghost_X+VectorX(16, angle)+VectorX(-8+16*i, angle-90), Ghost_Y+VectorY(16, angle)+VectorY(-8+16*i, angle-90), DegtoRad(angle), 0, ghost->WeaponDamage, 0, 0, 0);
						e->DrawYOffset = -1000;
						e->CollDetection = false;
						RunEWeaponScript(e, "StellarKnockbackBlast", {0, 300});
					}
					chargeDelay = Rand(120, 180);
					charged = false;
				}
			}
			
			Ghost_Waitframe2(this, ghost);
		}
	}
}

int Wizzrobe_GetTeleportPos(){
	int i;
	int x; int y;
	int pos; int ct;
	
	int linkX = Clamp(GridX(Link->X)+8, 32, 208);
	int linkY = Clamp(GridY(Link->Y)+8, 32, 128);
	
	
	int validPos[176];
	int numValid;
	
	//Find all valid combos to teleport to in all four directions
	
	//Up
	for(i=2; i<11; i++){
		x = linkX;
		y = linkY-16*i;
		pos = ComboAt(x, y);
		ct = Screen->ComboT[pos];
		if(x<32||x>224||y<32||y>144)
			continue;
		if(ComboFI(pos, CF_NOENEMY))
			continue;
		if(ct==CT_NOENEMY||ct==CT_NOFLYZONE)
			continue;
		
		validPos[numValid] = pos;
		numValid++;
	}
	//Down
	for(i=2; i<11; i++){
		x = linkX;
		y = linkY+16*i;
		pos = ComboAt(x, y);
		ct = Screen->ComboT[pos];
		if(x<32||x>224||y<32||y>144)
			continue;
		if(ComboFI(pos, CF_NOENEMY))
			continue;
		if(ct==CT_NOENEMY||ct==CT_NOFLYZONE)
			continue;
		
		validPos[numValid] = pos;
		numValid++;
	}
	//Left
	for(i=2; i<16; i++){
		x = linkX-16*i;
		y = linkY;
		pos = ComboAt(x, y);
		ct = Screen->ComboT[pos];
		if(x<32||x>224||y<32||y>144)
			continue;
		if(ComboFI(pos, CF_NOENEMY))
			continue;
		if(ct==CT_NOENEMY||ct==CT_NOFLYZONE)
			continue;
		
		validPos[numValid] = pos;
		numValid++;
	}
	//Right
	for(i=2; i<16; i++){
		x = linkX+16*i;
		y = linkY;
		pos = ComboAt(x, y);
		ct = Screen->ComboT[pos];
		if(x<32||x>224||y<32||y>144)
			continue;
		if(ComboFI(pos, CF_NOENEMY))
			continue;
		if(ct==CT_NOENEMY||ct==CT_NOFLYZONE)
			continue;
		
		validPos[numValid] = pos;
		numValid++;
	}

	//Default to the top left if there's no valid spots
	if(numValid==0)
		return 0;
	
	return validPos[Rand(numValid)];
}

void Wizzrobe_TeleporterUpdate(ffc this, npc ghost, bitmap b, int wizzData, int invisibleTime, int warpInTime, int activeTime, int warpOutTime){
	const int STATE = 0;
	const int TIMER = 1;
	
	const int STATE_INVISIBLE = 0;
	const int STATE_WARPIN = 1;
	const int STATE_ACTIVE = 2;
	const int STATE_WARPOUT = 3;
	switch(wizzData[STATE]){
		case STATE_INVISIBLE:
			if(wizzData[TIMER])
				--wizzData[TIMER];
			else{
				ghost->CollDetection = true;
				int pos = Wizzrobe_GetTeleportPos();
				Ghost_X = ComboX(pos);
				Ghost_Y = ComboY(pos);
				Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
				wizzData[STATE] = STATE_WARPIN;
				wizzData[TIMER] = warpInTime;
			}
			break;
		case STATE_WARPIN:
			if(wizzData[TIMER])
				--wizzData[TIMER];
			else{
				ghost->DrawXOffset = 0;
				wizzData[STATE] = STATE_ACTIVE;
				wizzData[TIMER] = activeTime;
			}
			break;
		case STATE_ACTIVE:
			if(wizzData[TIMER])
				--wizzData[TIMER];
			else{
				ghost->DrawXOffset = 1000;
				wizzData[STATE] = STATE_WARPOUT;
				wizzData[TIMER] = warpInTime;
			}
			break;
		case STATE_WARPOUT:
			if(wizzData[TIMER])
				--wizzData[TIMER];
			else{
				ghost->CollDetection = false;
				wizzData[STATE] = STATE_INVISIBLE;
				wizzData[TIMER] = invisibleTime;
			}
			break;
	}
}

	
//{ Blue Wizzrobe Movement Functions

const int RSPW_NONE = 0;
const int RSPW_DOOR = 1;
const int RSPW_CLIPRIGHT = 2;
const int RSPW_FLOATER = 3;
const int RSPW_TRAP = 4;
const int RSPW_HALFSTEP = 5;
const int RSPW_WATER = 6;
const int RSPW_WIZZROBE = 7;
const int RSPW_CLIPBOTTOMRIGHT = 8;

const int EWIZZ_TURN = 0;
const int EWIZZ_WALKING = 1;
const int EWIZZ_PHASING = 2;
const int EWIZZ_4DIR = 3;
	bool BlueWizz2_CanWalk(int dir, int step, bool phase){
		Ghost_UnsetFlag(GHF_IGNORE_ALL_TERRAIN);
		Ghost_UnsetFlag(GHF_IGNORE_NO_ENEMY);
		Ghost_UnsetFlag(GHF_FLYING_ENEMY);
		if(phase){
			Ghost_SetFlag(GHF_IGNORE_ALL_TERRAIN);
			Ghost_SetFlag(GHF_IGNORE_NO_ENEMY);
			Ghost_SetFlag(GHF_FLYING_ENEMY);
		}
		return Ghost_CanMove(dir, step, 0);
	}
	void BlueWizz2_Move(int dir, int step, bool phase){
		Ghost_UnsetFlag(GHF_IGNORE_ALL_TERRAIN);
		Ghost_UnsetFlag(GHF_IGNORE_NO_ENEMY);
		Ghost_UnsetFlag(GHF_FLYING_ENEMY);
		if(phase){
			Ghost_SetFlag(GHF_IGNORE_ALL_TERRAIN);
			Ghost_SetFlag(GHF_IGNORE_NO_ENEMY);
			Ghost_SetFlag(GHF_FLYING_ENEMY);
		}
		Ghost_Move(dir, step, 0);
	}
	void BlueWizz2_MoveXY(int vx, int vy, bool phase){
		Ghost_UnsetFlag(GHF_IGNORE_ALL_TERRAIN);
		Ghost_UnsetFlag(GHF_IGNORE_NO_ENEMY);
		Ghost_UnsetFlag(GHF_FLYING_ENEMY);
		if(phase){
			Ghost_SetFlag(GHF_IGNORE_ALL_TERRAIN);
			Ghost_SetFlag(GHF_IGNORE_NO_ENEMY);
			Ghost_SetFlag(GHF_FLYING_ENEMY);
		}
		Ghost_MoveXY(vx, vy, 0);
	}
	void BlueWizz2_Update(ffc this, npc ghost, int vars, bool blink){
		const int GHF_WIZZROBE = GHF_IGNORE_ALL_TERRAIN|GHF_IGNORE_NO_ENEMY;
		
		//vars[0] - Attack Flag
		//vars[1] - Movement Timer
		//vars[2] - Dir
		//vars[3] - Current Behavior 
		//vars[4] - Firing Clock
		//vars[5] - Fake Dir
		//vars[6] - Blink
		
		vars[6] = 0;
		
		if(ghost->HP<=0){
			ghost->DrawYOffset = -2;
			return;
		}
		
		if(blink){
			if(vars[3]==1||vars[3]==3)
				ghost->DrawYOffset = Cond(vars[1]&1, -1000, -2);
			else
				ghost->DrawYOffset = -2;
		}
			
		
		vars[0] = 0;
		
		if(vars[1]<=0 || ((vars[1]&31)==0 && !BlueWizz2_CanWalk(vars[2], 1, false) && !vars[3])){
			Reproduction_BlueWizz_FixCoords();
			
			bool checkMove = false;
			if(vars[3]==EWIZZ_WALKING){ //Was walking
				if(!BlueWizz2_CanWalk(Ghost_X, Ghost_Y, false)){
					vars[3] = 0; //Turning
				}
				else{
					vars[1] = 16;
					if(!BlueWizz2_CanWalk(vars[2], 1, true)){
						Reproduction_BlueWizz_NewDir(vars, 0);
					}
				}
			}
			else if(vars[3]==EWIZZ_PHASING){ //Was about to phase
				int jx = Ghost_X;
				int jy = Ghost_Y;
				int jdir = -1;
				
				int r = Rand(8);
				if(r==0){
					jx -= 32;
					jy -= 32;
					jdir = 15;
				}
				else if(r==1){
					jx += 32;
					jy -= 32;
					jdir = 9;
				}
				else if(r==2){
					jx += 32;
					jy += 32;
					jdir = 11;
				}
				else if(r==3){
					jx -= 32;
					jy += 32;
					jdir = 13;
				}
				
				if(jdir>0&& jx>=32 && jx <= 208 && jy >= 32 && jy <= 128){
					if(jdir==15){ //leftup
						if(vars[2]==DIR_LEFT||vars[2]==DIR_UP)
							vars[5] = vars[2];
						else if(vars[2]==DIR_DOWN)
							vars[5] = DIR_LEFT;
						else if(vars[2]==DIR_RIGHT)
							vars[5] = DIR_UP;
						else
							vars[5] = DIR_LEFT;
					}
					else if(jdir==9){ //rightup
						if(vars[2]==DIR_RIGHT||vars[2]==DIR_UP)
							vars[5] = vars[2];
						else if(vars[2]==DIR_DOWN)
							vars[5] = DIR_RIGHT;
						else if(vars[2]==DIR_LEFT)
							vars[5] = DIR_UP;
						else
							vars[5] = DIR_RIGHT;
					}
					else if(jdir==11){ //right down
						if(vars[2]==DIR_RIGHT||vars[2]==DIR_DOWN)
							vars[5] = vars[2];
						else if(vars[2]==DIR_UP)
							vars[5] = DIR_RIGHT;
						else if(vars[2]==DIR_LEFT)
							vars[5] = DIR_RIGHT;
						else
							vars[5] = DIR_RIGHT;
					}
					else if(jdir==13){ //left down
						if(vars[2]==DIR_LEFT||vars[2]==DIR_DOWN)
							vars[5] = vars[2];
						else if(vars[2]==DIR_UP)
							vars[5] = DIR_LEFT;
						else if(vars[2]==DIR_RIGHT)
							vars[5] = DIR_LEFT;
						else
							vars[5] = DIR_LEFT;
					}
					
					vars[3] = EWIZZ_4DIR; //4-Dir
					vars[1] = 32;
					vars[2] = jdir;
				}
			}
			else if(vars[3]==EWIZZ_4DIR){ //4-Dir
				checkMove = true;
				vars[2] &= 3;
				vars[3] = EWIZZ_TURN; //Turning 0
				vars[5] = -1;
				Reproduction_BlueWizz_NewDir(vars, 64);
			}
			else if(vars[3]==EWIZZ_TURN){ //Turning
				checkMove = true;
				Reproduction_BlueWizz_NewDir(vars, 64);
			}
			if(checkMove){
				//Check if against solidity
				if(!BlueWizz2_CanWalk(vars[2], 1, false)){
					if(BlueWizz2_CanWalk(vars[2], 15, true)){
						vars[3] = EWIZZ_WALKING; //Walking 1
						vars[1] = 16;
					}
					else{
						Reproduction_BlueWizz_NewDir(vars, 64);
						vars[3] = EWIZZ_TURN; //Turning
						vars[1] = 32;
					}
				}
				else{
					vars[1] = 32;
				}
			}
			
			if(vars[3]<0)
				++vars[3];
		}
		//If counter is counting down, flag as blinking
		if(vars[1])
			vars[6] = 1;
		--vars[1];
		
		int step;
		if(vars[3]==EWIZZ_WALKING||vars[3]==EWIZZ_4DIR){
			step = 1;
		}
		else if(vars[3]==2){
			step = 0;
		}
		else{
			step = 0.5;
		}
		
		int vX = DirX(__NormalizeDir(vars[2]), step);
		int vY = DirY(__NormalizeDir(vars[2]), step);
		BlueWizz2_MoveXY(vX, vY, true);
		
		if(vars[3]<=0 && vars[1]==28 ){
			if(__Ghost_LinedUp(8, false)==vars[2]){
				vars[0] = 1;
				vars[4] = 30;
			}
		}
		
		if(vars[3]==EWIZZ_TURN && Rand(128)==0)
			vars[3] = EWIZZ_PHASING;
		
		if(vars[3]==EWIZZ_PHASING && vars[1]==4){
			Reproduction_BlueWizz_FixCoords();
		}
		
		if(vars[4]>0)
			--vars[4];
		
		if(vars[5]>-1)
			Ghost_Dir = vars[5];
		else if(vars[2]<4)
			Ghost_Dir = vars[2];
	}
	void Reproduction_BlueWizz_NewDir(int vars, int homing){
		if(Ghost_X<32)
			vars[2] = DIR_RIGHT;
		else if(Ghost_X>=224)		
			vars[2] = DIR_LEFT;
		else if(Ghost_Y<32)
			vars[2] = DIR_DOWN;
		else if(Ghost_Y>=144)
			vars[2] = DIR_UP;
		else{
			Reproduction_BlueWizzrobe_NewDir4(vars, 4, homing, true, 0);
		}
	}
	int Reproduction_BlueWizz_Lined_Up(int range)
	{
		int lx = Link->X;
		int ly = Link->Y;
		if(Abs(lx-Ghost_X)<=range)
		{
			if(ly<Ghost_Y)
				return DIR_UP;
			return DIR_DOWN;
		}
		if(Abs(ly-Ghost_Y)<=range)
		{
			if(lx<Ghost_X)
				return DIR_LEFT;
			return DIR_RIGHT;
		}
		return -1;
	}
	void Reproduction_BlueWizzrobe_NewDir4(int vars, int rate, int homing, bool phasing, int grumble){
		//Screen->FastTile(6, Ghost_X, Ghost_Y, Link->Tile, 6, 128);
		
		// changes enemy's direction, checking restrictions
		// rate:   0 = no random changes, 16 = always random change
		// homing: 0 = none, 256 = always
		// grumble 0 = none, 4 = strongest appetite
		int ndir;
		if(grumble && Rand(4)<grumble)
		{
			lweapon l = LoadLWeaponOf(LW_BAIT);
			if(l->isValid())
			{
				int bx = l->X;
				int by = l->Y;
				if(Abs(Ghost_Y-by)>14)
				{
					ndir = Cond(by<Ghost_Y, DIR_UP, DIR_DOWN);
					if(BlueWizz2_CanWalk(ndir,1,phasing))
					{
						vars[2]=ndir;
						return;
					}
				}
				ndir = Cond(bx<Ghost_Y, DIR_LEFT, DIR_RIGHT);
				if(BlueWizz2_CanWalk(ndir,1,phasing))
				{
					vars[2]=ndir;
					return;
				}
			}
		}
		if((Rand(256))<homing)
		{
			ndir = Reproduction_BlueWizz_Lined_Up(8);
			if(ndir>=0 && BlueWizz2_CanWalk(ndir,1,phasing))
			{
				vars[2]=ndir;
				return;
			}
		}

		int i=0;
		for(i=0; i<32; i++)
		{
			int r=Rand(16);
			if(r<rate)
				ndir=Rand(4);
			else
				ndir=vars[2];
			if(BlueWizz2_CanWalk(ndir,1,phasing))
				break;
		}
		if(i==32)
		{
			for(ndir=0; ndir<4; ndir++)
			{
				if(BlueWizz2_CanWalk(ndir,1,phasing)){
					vars[2] = ndir;
					return;
				}
			}
			ndir = -1;
		}
		vars[2] = ndir;
	}
	void Reproduction_BlueWizz_FixCoords(){
		Ghost_X=(Ghost_X&0xF0)+Cond((Ghost_X&8),16,0);
		Ghost_Y=(Ghost_Y&0xF0)+Cond((Ghost_Y&8),16,0);
	}
	bool Reproduction_BlueWizz_IsDungeon(){
		return Game->GetCurLevel()>0;
	}
//}

ffc script TeleportingWizzrobe{
	const int STATE = 0;
	const int TIMER = 1;
	
	const int STATE_INVISIBLE = 0;
	const int STATE_WARPIN = 1;
	const int STATE_ACTIVE = 2;
	const int STATE_WARPOUT = 3;
	
	void DrawTeleport(ffc this, npc ghost, bitmap b, int frame, int maxFrame, int clr){
		if(ghost->HP<=0)
			ghost->DrawXOffset = 0;
		else{
			ghost->DrawXOffset = 1000;
			b->Clear(0);
			b->DrawCombo(0, 0, 0, Ghost_Data+Ghost_Dir, 1, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 128);
			if(frame%4<2){
				b->ReplaceColors(0, clr, 0x01, 0xBF);
			}
			if(frame>maxFrame/2-1){
				b->Blit(2, RT_SCREEN, 0, 0, 16, 32, Ghost_X, Ghost_Y+ghost->DrawYOffset, 16, 32, 0, 0, 0, BITDX_TRANS, 0, true);
			}
			else{
				b->Blit(2, RT_SCREEN, 0, 0, 16, 32, Ghost_X, Ghost_Y+ghost->DrawYOffset, 16, 32, 0, 0, 0, BITDX_NORMAL, 0, true);
			}
		}
	}
	void run(int enemyid){
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		int bitid = TempBitmap_Create(0, 16, 32);
		bitmap b = TempBMP[bitid];
		
		int type = ghost->Attributes[0];
		int combo = ghost->Attributes[10];
		
		Ghost_SetFlag(GHF_4WAY);
		Ghost_Transform(this, ghost, -1, -1, 1, 2);
		Ghost_SetHitOffsets(ghost, 0, 16, 0, 0);
		ghost->DrawYOffset -= 16;
		SetOverUnderLayer(ghost);
		
		int wizzData[2];
		ghost->DrawXOffset = 1000;
		ghost->CollDetection = false;
		int telecolor = 0x86;
		if(type==1){ //Stellar Wizzrobe
			telecolor = 0x96;
		}
		while(true){
			Ghost_Data = combo;
			Wizzrobe_TeleporterUpdate(this, ghost, b, wizzData, 120, 32, 80, 32);
			switch(wizzData[STATE]){
				case STATE_WARPIN:
					DrawTeleport(this, ghost, b, wizzData[TIMER], 32, telecolor);
					break;
				case STATE_WARPOUT:
					DrawTeleport(this, ghost, b, 32-wizzData[TIMER], 32, telecolor);
					break;
				case STATE_ACTIVE:
					if(wizzData[TIMER]==64){
						switch(type){
							case 0: //Solar Wizzrobe
								Ghost_Data = combo+4;
								SSGhost_Waitframes(this, ghost, 8);
								for(int i=0; i<12; ++i){
									if(i%4==0){
										eweapon e = FireEWeapon(EW_SOLAR, Ghost_X, Ghost_Y, DegtoRad(DirAngle(Ghost_Dir)), 400, ghost->WeaponDamage, SPR_LIGHTSHOT, 32, 0);
										e->Rotation = DirAngle(Ghost_Dir);
										RunEWeaponScript(e, "GlowEW", {16});
										if(i==8){
											for(int j=-1; j<=1; j+=2){
												e = FireEWeapon(EW_SOLAR, Ghost_X, Ghost_Y, DegtoRad(DirAngle(Ghost_Dir)+10*j), 400, ghost->WeaponDamage, SPR_LIGHTSHOT, 32, 0);
												e->Rotation = DirAngle(Ghost_Dir)+10*j;
												RunEWeaponScript(e, "GlowEW", {16});
											}
										}
									}
									SSGhost_Waitframe(this, ghost);
								}
								SSGhost_Waitframes(this, ghost, 8);
								Ghost_Data = combo;
								break;
							case 1: //Stellar Wizzrobe
								Ghost_Data = combo+4;
								for(int i=0; i<8; ++i){
									Ghost_FaceLink(ghost);
									SSGhost_Waitframe(this, ghost);
								}
								int shotangle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
								eweapon e = FireEWeapon(EW_STELLAR, Ghost_X, Ghost_Y, DegtoRad(shotangle), 50, ghost->WeaponDamage, 0, SFX_SUMMON, 0);
								e->CollDetection = false;
								e->DrawXOffset = -1000;
								e->Rotation = DirAngle(Ghost_Dir);
								RunEWeaponScript(e, "DraculaMeteor", {5, 48});
								SSGhost_Waitframes(this, ghost, 16);
								Ghost_Data = combo;
								SSGhost_Waitframes(this, ghost, Rand(1, 5)*16);
						}
					}
					break;
			}
			SSGhost_Waitframe(this, ghost);
		}
	}
}

const int SPR_SNOWFLAKEPARTICLE = 109;

ffc script FloatingWizzrobe{
	void DrawPhase(ffc this, npc ghost, bitmap b, int frame){
		if(ghost->HP<=0)
			ghost->DrawXOffset = 0;
		else{
			ghost->DrawXOffset = 1000;
			b->Clear(0);
			b->DrawCombo(0, 0, 0, Ghost_Data+Ghost_Dir, 1, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 128);
			if(frame%4<2){
				b->ReplaceColors(0, 0x72, 0x01, 0xBF);
			}
			if(frame%16<8){
				b->Blit(2, RT_SCREEN, 0, 0, 16, 32, Ghost_X, Ghost_Y+ghost->DrawYOffset, 16, 32, 0, 0, 0, BITDX_TRANS, 0, true);
			}
			else{
				b->Blit(2, RT_SCREEN, 0, 0, 16, 32, Ghost_X, Ghost_Y+ghost->DrawYOffset, 16, 32, 0, 0, 0, BITDX_NORMAL, 0, true);
			}
		}
	}
	void run(int enemyid){
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		int bitid = TempBitmap_Create(0, 16, 32);
		bitmap b = TempBMP[bitid];
		
		int combo = ghost->Attributes[10];
		
		Ghost_SetFlag(GHF_4WAY);
		Ghost_Transform(this, ghost, combo+4, -1, 1, 2);
		Ghost_SetHitOffsets(ghost, 0, 16, 0, 0);
		ghost->DrawYOffset -= 16;
		SetOverUnderLayer(ghost);
		
		int vars[7];
		vars[1] = -3;
		vars[2] = Ghost_Dir;
		vars[5] = -1;
		int blinkTimer;
		int attackCooldown = 120;
		
		while(true){
			if(attackCooldown)
				--attackCooldown;
			BlueWizz2_Update(this, ghost, vars, false);
			if((vars[3]==1||vars[3]==3)&&vars[6]){
				DrawPhase(this, ghost, b, blinkTimer);
				++blinkTimer;
			}
			else{
				ghost->DrawXOffset = 0;
				blinkTimer = 0;
			}
			if(vars[0]){
				if(G[G_FROZENTIMER]==0&&!attackCooldown){
					Ghost_Data = combo;
					for(int i=0; i<16; ++i){
						DrawPhase(this, ghost, b, blinkTimer);
						++blinkTimer;
						SSGhost_Waitframe(this, ghost);
					}
					Ghost_Data = combo+4;
					Game->PlaySound(SFX_SUMMON);
					Game->PlaySound(94);
					for(int i=0; i<48&&BlueWizz2_CanWalk(Ghost_Dir, 1, true); ++i){
						BlueWizz2_Move(Ghost_Dir, 1, true);
						DrawPhase(this, ghost, b, blinkTimer);
						++blinkTimer;
						int dist = 48*(i/48);
						for(int j=0; j<3; ++j){
							Screen->Circle(4, Ghost_X+Rand(-8, 8), Ghost_Y+Rand(-8, 8), dist+Rand(-2, 2), Choose(0x71, 0x72, 0x73, 0x74), 1, 0, 0, 0, true, 64);
							Screen->Circle(4, Ghost_X+Rand(-8, 8), Ghost_Y+Rand(-8, 8), dist+Rand(-2, 2), Choose(0x71, 0x72, 0x73, 0x74), 1, 0, 0, 0, false, 64);
							if(i%2==0){
								ParticleAnim(Ghost_X+Rand(-4, 4)+VectorX(dist, -90+120*j+i*8), Ghost_Y+Rand(-4, 4)+VectorY(dist, -90+120*j+i*8), SPR_SNOWFLAKEPARTICLE);
							}
						}
						if(Distance(Link->X, Link->Y, Ghost_X, Ghost_Y)<dist&&G[G_FROZENTIMER]<=0){
							Game->PlaySound(SFX_ICE);
							G[G_FROZENTIMER] = 360;
							RunEWeaponEffect(120, 80, "FrozenStatus", {0});
						}
						SSGhost_Waitframe(this, ghost);
					}
					vars[1] = -3;
					vars[2] = Ghost_Dir;
					vars[5] = -1;
					attackCooldown = 120;
				}
			}
			SSGhost_Waitframe(this, ghost);
		}
	}
}

const int TIL_PUFFERSPIKE = 107255;

ffc script PufferFish{
	void run(int enemyid){
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		Ghost_SetFlag(GHF_4WAY);
		Ghost_SetFlag(GHF_IGNORE_ALL_TERRAIN);
		Ghost_SetFlag(GHF_FLYING_ENEMY);
		Ghost_SetFlag(GHF_FAKE_Z);
		Ghost_SetFlag(GHF_NO_FALL);
		Ghost_SetFlag(GHF_STUN);
		Ghost_Z = 8;
		Ghost_SetHitOffsets(ghost, 8, 8, 8, 8);
		
		int type = ghost->Attributes[0];
		int combo = ghost->Attributes[10];
		
		int angle = WrapDegrees(22.5*Rand(16));
		Ghost_Dir = AngleDir4(angle);
		int floatTimer;
		int floatMult = 2;
		int moveState = 0;
		int moveTime = Rand(4, 8);
	
		while(true){
			floatTimer = (floatTimer+1)%360;
			Ghost_Z = 8+2*Sin(floatTimer*floatMult);
			if(moveState==0){ //Stationary
				if(moveTime)
					--moveTime;
				else{
					moveState = 1;
					moveTime = Rand(16, 32);
					angle = WrapDegrees(angle+Choose(-2, -1, 1, 2)*22.5);
					if(!Ghost_CanMove8(AngleDir8(angle), 1, 0, false)){
						angle += WrapDegrees(angle+180);
					}
					Ghost_Dir = AngleDir4(angle);
				}
			}
			else{ //Moving
				Ghost_MoveAtAngle(angle, 0.25, 0);
				if(moveTime)
					--moveTime;
				else{
					moveState = 0;
					moveTime = Rand(4, 8);
				}
			}
			if(Distance(Link->X, Link->Y, Ghost_X, Ghost_Y)<48||Ghost_GotHit()){
				break;
			}
			SSGhost_Waitframe(this, ghost);
		}
		Ghost_Data = combo+4;
		Ghost_SetHitOffsets(ghost, 0, 0, 0, 0);
		int vX = VectorX(1, Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
		int vY = VectorY(1, Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
		Game->PlaySound(72);
		for(int i=0; i<160; ++i){
			floatTimer = (floatTimer+1)%360;
			Ghost_Z = 8+2*Sin(floatTimer*floatMult);
			int tX = Link->X;
			int tY = Link->Y;
			if(Distance(Ghost_X, Ghost_Y, Link->X, Link->Y)>32){
				tX += DirX(Link->Dir, 32);
				tY += DirY(Link->Dir, 32);
			}
			vX = LazyChase(vX, Ghost_X, tX, 0.05, 1);
			vY = LazyChase(vY, Ghost_Y, tY, 0.05, 1);
			if(vX!=0||vY!=0){
				Ghost_Dir = AngleDir4(Angle(0, 0, vX, vY));
			}
			Ghost_MoveXY(vX, vY, 0);
			SSGhost_Waitframe(this, ghost);
		}
		Ghost_Data = combo+8;
		for(int i=0; i<32; ++i){
			floatTimer = (floatTimer+1)%360;
			Ghost_Z = 8+2*Sin(floatTimer*floatMult);
			Ghost_MoveXY(vX/4, vY/4, 0);
			SSGhost_Waitframe(this, ghost);
		}
		while(Ghost_Z>0){
			Ghost_Z -= 2;
			SSGhost_Waitframe(this, ghost);
		}
		if(type==0){ //Fire
			for(int i=0; i<18; ++i){
				eweapon e = FireEWeapon(EW_FIRE, Ghost_X, Ghost_Y, DegtoRad(20*i), 120, ghost->WeaponDamage, -1, -1, 0);
			}
		}
		else if(type==1){ //Spike
			for(int i=0; i<12; ++i){
				eweapon e = FireEWeapon(EW_SOLAR, Ghost_X, Ghost_Y, DegtoRad(30*i), 400, ghost->WeaponDamage, -1, SFX_ROCK, 0);
				e->HitXOffset = 4;
				e->HitYOffset = 4;
				e->HitWidth = 8;
				e->HitHeight = 8;
				e->Tile = TIL_PUFFERSPIKE;
				e->CSet = 8;
				e->OriginalTile = e->Tile;
				e->Rotation = 30*i;
				SetEWeaponLifespan(e, EWL_TIMER, 16);
				SetEWeaponDeathEffect(e, EWD_VANISH, 0);
			}
		}
		else if(type==2){ //Stellar
			eweapon e = FireEWeapon(EW_STELLAR, this->X, this->Y, 0, 0, ghost->WeaponDamage, 0, 0, 0);
			RunEWeaponScript(e, "Meteorite", {0, 1, 64});
			e->CollDetection = false;
			e->DrawYOffset = -1000;
			for(int i=0; i<8; ++i){
				eweapon e = FireEWeapon(EW_STELLAR, Ghost_X, Ghost_Y, DegtoRad(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y)+45*i), 0, ghost->WeaponDamage, 0, 0, 0);
				e->DrawYOffset = -1000;
				e->CollDetection = false;
				RunEWeaponScript(e, "StellarKnockbackBlast", {0, 300});
			}
		}
		Ghost_HP = 0;
		ghost->ItemSet = 0;
		++Game->GuyCount[Game->GetCurScreen()];
		while(true){
			SSGhost_Waitframe(this, ghost);
		}
	}
}

const int TIL_NIGHTMARCHERFLAME = 106260;
const int TIL_NIGHTMARCHERIMPACT = 106280;

ffc script Nightmarcher{
	const int FLAMEDATA = 0;
	const int HOVERTIMER = 1;
	const int SPRITEFRAME = 2;
	const int FLASHTIMER = 3;
	const int VIBRATIONINTENSITY = 4;
	void run(int enemyid){
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		// int bitid = TempBitmap_Create(0, 16, 32);
		// bitmap b = TempBMP[bitid];
		bitmap b = Game->CreateBitmap(16, 32);
		b->Own();
		if(Game->Counter[CR_NIGHTMARCHERQUEST] == 6){
			ghost->HP = 1200;
			Ghost_HP = 1200;
			ghost->Damage = 4;
			ghost->WeaponDamage = 2;
		}
		
		int combo = ghost->Attributes[10];
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
		
		Ghost_SetFlag(GHF_4WAY);
		Ghost_SetFlag(GHF_FAKE_Z);
		Ghost_SetFlag(GHF_NO_FALL);
		Ghost_SetFlag(GHF_IGNORE_ALL_TERRAIN);
		Ghost_SetFlag(GHF_IGNORE_NO_ENEMY);
		Ghost_SetFlag(GHF_FLYING_ENEMY);
		Ghost_SetFlag(GHF_MOVE_OFFSCREEN);
		
		Ghost_Transform(this, ghost, combo+4, -1, 1, 2);
		Ghost_SetHitOffsets(ghost, 0, 16, 0, 0);
		ghost->DrawYOffset -= 1000;
		SetOverUnderLayer(ghost);
		
		Ghost_Z = 2;
		
		Ghost_Dir = AngleDir4(WrapDegrees(G[G_FOGANGLE]));
		int aggroTime = 48;		
		while(true){
			vars[VIBRATIONINTENSITY] = 0;
			int sightX = Ghost_X+8+VectorX(32, G[G_FOGANGLE]);
			int sightY = Ghost_Y+8-Ghost_Z+VectorY(32, G[G_FOGANGLE]);
			//Screen->DrawInteger(6, Ghost_X, Ghost_Y-Ghost_Z-24, FONT_Z3SMALL, 0x01, 0x0F, -1, -1, aggroTime, 0, 128);
			if(RotRectCollision(sightX, sightY, 80, 16, G[G_FOGANGLE], Link->X+8, Link->Y+8, 16, 16, 0, false)){
				aggroTime = Max(aggroTime-2, 0);
				Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y), 0.1, 0);
			}
			else
				aggroTime = Min(aggroTime+0.5, 48);
			if(aggroTime<8)
				vars[VIBRATIONINTENSITY] = 2;
			else if(aggroTime<24)
				vars[VIBRATIONINTENSITY] = 1;
			
			if(aggroTime<=0||Ghost_GotHit()||LinkCollision(ghost)){
				break;
			}
			
			Ghost_MoveAtAngle(WrapDegrees(G[G_FOGANGLE]), 0.45, 0);
			Ghost_MoveAtAngle(WrapDegrees(G[G_FOGANGLE]+90), 0.1*Sin(vars[HOVERTIMER]*2), 0);
			Nightmarcher_Waitframe(this, ghost, vars, 1);
		}
		int moveAngle;
		vars[VIBRATIONINTENSITY] = 0;
		int weaponType = Rand(3);
		int attackCooldown = 48;
		int strafeDir = Choose(-1, 1);
		while(true){
			if(weaponType==2){ //Sling
				if(Rand(300)==0)
					strafeDir = -strafeDir;
				Ghost_FaceLink(ghost);
				moveAngle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y)+90+180*strafeDir;
				Ghost_MoveAtAngle(moveAngle, 0.4, 0);
				Ghost_MoveAtAngle(moveAngle+90, 0.1*Sin(vars[HOVERTIMER]*2), 0);
			}
			else{
				moveAngle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
				Ghost_Dir = AngleDir4(moveAngle);
				Ghost_MoveAtAngle(moveAngle, 0.45, 0);
				Ghost_MoveAtAngle(moveAngle+90, 0.1*Sin(vars[HOVERTIMER]*2), 0);
			}
			
			if(attackCooldown>0)
				--attackCooldown;
			else{
				if(Rand(16)==0){
					if(weaponType==0){ //Club
						for(int i=0; i<32; ++i){
							moveAngle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
							Ghost_Dir = AngleDir4(moveAngle);
							Ghost_MoveAtAngle(moveAngle, 0.1, 0);
							Ghost_MoveAtAngle(moveAngle+90, 0.03*Sin(vars[HOVERTIMER]*2), 0);
							QuickSword(EW_PHYSICAL, Ghost_X, Ghost_Y-Ghost_Z, moveAngle-90, Min(i/4*14, 14), combo+12, 8, 0, 64, ghost->Damage);
							Nightmarcher_Waitframe(this, ghost, vars, 1);
						}
						Ghost_Data = combo+8;
						Game->PlaySound(SFX_SWORD);
						for(int i=0; i<12; ++i){
							moveAngle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
							Ghost_Dir = AngleDir4(moveAngle);
							Ghost_MoveAtAngle(moveAngle, 2, 0);
							Ghost_MoveAtAngle(moveAngle+90, 0.1*Sin(vars[HOVERTIMER]*2), 0);
							QuickSword(EW_PHYSICAL, Ghost_X, Ghost_Y-Ghost_Z, moveAngle-90+Lerp(0, 180, i/12), 14, combo+13, 8, 0, 64, ghost->Damage);
							Nightmarcher_Waitframe(this, ghost, vars, 1);
						}
						Ghost_Data = combo+4;
						for(int i=0; i<4; ++i){
							moveAngle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
							Ghost_Dir = AngleDir4(moveAngle);
							Ghost_MoveAtAngle(moveAngle, 0.1, 0);
							Ghost_MoveAtAngle(moveAngle+90, 0.03*Sin(vars[HOVERTIMER]*2), 0);
							QuickSword(EW_PHYSICAL, Ghost_X, Ghost_Y-Ghost_Z, moveAngle+90, Lerp(14, 0, i/4), combo+13, 8, 0, 64, ghost->Damage);
							Nightmarcher_Waitframe(this, ghost, vars, 1);
						}
					}
					else if(weaponType==1){ //Spear
						for(int i=0; i<3; ++i){
							int k = (i==2?80:32);
							int spearAngle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
							for(int j=0; j<k; ++j){
								moveAngle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
								Ghost_Dir = AngleDir4(moveAngle);
								Ghost_MoveAtAngle(moveAngle, 0.1, 0);
								Ghost_MoveAtAngle(moveAngle+90, 0.03*Sin(vars[HOVERTIMER]*2), 0);
								spearAngle = TurnToAngle(spearAngle, moveAngle, 2);
								QuickLongSword(EW_PHYSICAL, Ghost_X, Ghost_Y-Ghost_Z, spearAngle, -8, combo+14, 8, 2, 0, 64, ghost->Damage);
								Nightmarcher_Waitframe(this, ghost, vars, 1);
							}	
							Game->PlaySound(SFX_SWORD);
							Ghost_Data = combo+8;
							for(int j=0; j<16; ++j){
								moveAngle = spearAngle;
								Ghost_Dir = AngleDir4(moveAngle);
								Ghost_MoveAtAngle(moveAngle, 3, 0);
								Ghost_MoveAtAngle(moveAngle+90, 0.5*Sin(vars[HOVERTIMER]*2), 0);
								spearAngle = TurnToAngle(spearAngle, moveAngle, 5);
								QuickLongSword(EW_PHYSICAL, Ghost_X, Ghost_Y-Ghost_Z, spearAngle, -8+Lerp(0, 24, j/22), combo+15, 8, 2, 0, 64, ghost->Damage);
								Nightmarcher_Waitframe(this, ghost, vars, 1);
							}	
							Ghost_Data = combo;
							for(int j=0; j<8; ++j){
								moveAngle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
								Ghost_Dir = AngleDir4(moveAngle);
								spearAngle = TurnToAngle(spearAngle, moveAngle, 5);
								QuickLongSword(EW_PHYSICAL, Ghost_X, Ghost_Y-Ghost_Z, spearAngle, -8+Lerp(24, 0, j/8), combo+14, 8, 2, 0, 64, ghost->Damage);
								Nightmarcher_Waitframe(this, ghost, vars, 1);
							}	
							Ghost_Data = combo+4;
						}
					}
					else if(weaponType==2){ //Sling
						for(int i=0; i<24; ++i){
							moveAngle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
							Ghost_Dir = AngleDir4(moveAngle);
							QuickSword(EW_PHYSICAL, Ghost_X, Ghost_Y-Ghost_Z, moveAngle-135, 14, combo+16, 8, 0, 96, 0);
							Nightmarcher_Waitframe(this, ghost, vars, 1);
						}
						bool fired;
						for(int i=0; i<24; ++i){
							moveAngle = Angle(Ghost_X, Ghost_Y-Ghost_Z, Link->X, Link->Y);
							Ghost_Dir = AngleDir4(moveAngle);
							if(!fired){
								QuickSword(EW_PHYSICAL, Ghost_X, Ghost_Y-Ghost_Z, moveAngle-135+Lerp(0, 135+90, i/24), 14, combo+16, 8, 0, 96, 0);
								if(Lerp(0, 135+90, i/24)>135){
									eweapon e = FireEWeapon(EW_PHYSICAL, Ghost_X+VectorX(24, moveAngle), Ghost_Y+VectorX(16, moveAngle), DegtoRad(moveAngle+Rand(-10, 10)), 400, ghost->WeaponDamage, 18, SFX_ROCK, EWF_UNBLOCKABLE);
									fired = true;
								}
							}
							else
								QuickSword(EW_PHYSICAL, Ghost_X, Ghost_Y-Ghost_Z, moveAngle-135+Lerp(0, 135+90, i/24), 14, combo+17, 8, 0, 96, 0);
							Nightmarcher_Waitframe(this, ghost, vars, 1);
						}
					}
					attackCooldown = Rand(24, 64);
				}
			}
			Nightmarcher_Waitframe(this, ghost, vars, 1);
		}
	}
	void Nightmarcher_Waitframe(ffc this, npc ghost, int vars, int frames){
		int combo = ghost->Attributes[10];
		int xOff;
		int yOff;
		for(int i=0; i<frames; ++i){
			if(vars[VIBRATIONINTENSITY]){
				xOff = Rand(-vars[VIBRATIONINTENSITY], vars[VIBRATIONINTENSITY]);
				yOff = Rand(-vars[VIBRATIONINTENSITY], vars[VIBRATIONINTENSITY]);
			}
			
			int flame = vars[FLAMEDATA];
			
			int flameX = flame[0];
			int flameY = flame[1];
			int flameT = flame[2];
			
			vars[HOVERTIMER] = (vars[HOVERTIMER]+1)%360;
			vars[FLASHTIMER] = (vars[FLASHTIMER]+1)%48;
			Ghost_Z = 2+1*Sin(vars[HOVERTIMER]*2);
			
			for(int i=0; i<5; ++i){
				int t = Floor(flameT[i]/4);
				if(t<7){
					Screen->FastTile(4, Ghost_X+flameX[i]+xOff, Ghost_Y+flameY[i]-Ghost_Z+yOff, TIL_NIGHTMARCHERFLAME+6-t, 10, 128);
				}
				else if(t<12){
					Screen->FastTile(4, Ghost_X+flameX[i]+xOff, Ghost_Y+flameY[i]-Ghost_Z+yOff, TIL_NIGHTMARCHERFLAME+2+(t-7), 10, 128);
				}
				flameT[i] = (flameT[i]+1)%128;
			}
			
			if(Ghost_Data==combo+4){
				combodata cd = Game->LoadComboData(Ghost_Data);
				int frame = cd->Tile-cd->OriginalTile;
				if(frame!=vars[SPRITEFRAME]){
					if(frame==1){
						int xy[2];
						GetDirXYOffset(xy, Ghost_Dir, {10,14, 6,15, 5,15, 11,15});
						lweapon l = ParticleAnim(Ghost_X+xy[0]-8+xOff, Ghost_Y+xy[1]-8-Ghost_Z+yOff, TIL_NIGHTMARCHERIMPACT, 7, 4, 4);
						l->DrawStyle = DS_PHANTOM;
					}
					else if(frame==3){
						int xy[2];
						GetDirXYOffset(xy, Ghost_Dir, {5,14, 9,15, 11,15, 5,15});
						lweapon l = ParticleAnim(Ghost_X+xy[0]-8+xOff, Ghost_Y+xy[1]-8-Ghost_Z+yOff, TIL_NIGHTMARCHERIMPACT, 7, 4, 4);
						l->DrawStyle = DS_PHANTOM;
					}
				}
				vars[SPRITEFRAME] = frame;
			}
			
			int frame = Floor(vars[FLASHTIMER]/8);
			if(frame==0)
				Screen->DrawCombo(2, Ghost_X+xOff, Ghost_Y-16-Ghost_Z+yOff, Ghost_Data+Ghost_Dir, 1, 2, Ghost_CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
			else if(frame==1||frame==5){
				Screen->DrawCombo(2, Ghost_X+xOff, Ghost_Y-16-Ghost_Z+yOff, Ghost_Data+Ghost_Dir, 1, 2, Ghost_CSet, -1, -1, 0, 0, 0, -1, 0, true, 64);
				Screen->DrawCombo(2, Ghost_X+xOff, Ghost_Y-16-Ghost_Z+yOff, Ghost_Data+Ghost_Dir, 1, 2, Ghost_CSet, -1, -1, 0, 0, 0, -1, 0, true, 64);
			}
			else if(frame==2||frame==4)
				Screen->DrawCombo(2, Ghost_X+xOff, Ghost_Y-16-Ghost_Z+yOff, Ghost_Data+Ghost_Dir, 1, 2, Ghost_CSet, -1, -1, 0, 0, 0, -1, 0, true, 64);
				
			SSGhost_Waitframe(this, ghost);
		}
	}
}

ffc script HoppingHelmet{
	void run(int enemyid){
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		int i; int j; int k;
		int x; int y;
		int moveDir = Rand(4);
		int fakeZ;
		int jump;
		int dashCooldown;
		Ghost_SetFlag(GHF_4WAY);
		Ghost_SetFlag(GHF_STUN);
		Ghost_SetFlag(GHF_CLOCK);
		Ghost_SetFlag(GHF_REDUCED_KNOCKBACK);
			
		while(true){
			int canMove[4];
			for(i=0; i<4; ++i){
				x = Ghost_X+8+DirX(i, 16);
				y = Ghost_Y+8+DirY(i, 16);
				if(x<0||x>240||y<0||y>160)
					canMove[i] = 0;
				else if(!ComboFI(x, y, CF_NOENEMY)&&!ComboFI(x, y, CF_NOGROUNDENEMY)&&!Screen->isSolid(x, y))
					canMove[i] = 1;
				else
					canMove[i] = 0;
			}
			if(Rand(ghost->Rate)==0||!canMove[moveDir]){
				for(i=0; i<=16; ++i){
					if(i<12)
						moveDir = Rand(4);
					else if(i<16)
						moveDir = i-12;
					else{
						moveDir = -1;
						break;
					}
					if(canMove[moveDir])
						break;
				}
			}
			
			jump = Rand(16, 32)/10;
			j = FindJumpLength(jump, false);
			Ghost_Dir = moveDir;
			while(jump>0||fakeZ>0){
				fakeZ = Max(fakeZ+jump, 0);
				jump = Clamp(jump-0.16, -3.2, 3.2);
				ghost->DrawYOffset = -2-fakeZ;
				ghost->HitYOffset = -fakeZ;
				Ghost_Move(Ghost_Dir, 16/j, 0);
				if(dashCooldown)
					--dashCooldown;
				Ghost_Waitframe(this, ghost);
			}
			fakeZ = 0;
			ghost->DrawYOffset = -2;
			ghost->HitYOffset = 0;
			Ghost_X = GridX(Ghost_X+8);
			Ghost_Y = GridY(Ghost_Y+8);
			
			bool doDash;
			for(i=0; i<16; ++i){
				if(dashCooldown)
					--dashCooldown;
				else{
					if(Abs(Ghost_X-Link->X)<16||Abs(Ghost_Y-Link->Y)<16){
						Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
						moveDir = Ghost_Dir;
						doDash = true;
						break;
					}
				}
				Ghost_Waitframe(this, ghost);
			}
			if(doDash){
				int dashSpeed = 2;
				for(i=0; i<64/dashSpeed; ++i){
					if(fakeZ==0)
						jump = 1.2;
					fakeZ = Max(fakeZ+jump, 0);
					jump = Clamp(jump-0.16, -3.2, 3.2);
					ghost->DrawYOffset = -2-fakeZ;
					ghost->HitYOffset = -fakeZ;
					Ghost_Move(Ghost_Dir, dashSpeed, 0);
					Ghost_Waitframe(this, ghost);
				}
				while(jump>0||fakeZ>0){
					fakeZ = Max(fakeZ+jump, 0);
					jump = Clamp(jump-0.16, -3.2, 3.2);
					ghost->DrawYOffset = -2-fakeZ;
					ghost->HitYOffset = -fakeZ;
					Ghost_Move(Ghost_Dir, dashSpeed, 0);
					Ghost_Waitframe(this, ghost);
				}
				Ghost_X = GridX(Ghost_X+8);
				Ghost_Y = GridY(Ghost_Y+8);
				dashCooldown = 120;
			}
		}
	}
}

ffc script Grandma{
	void run(int enemyid){
		Screen->D[1] = 0;
		int i;
		int x; int y;
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		ghost->Immortal = true;
		Ghost_SetFlag(GHF_4WAY);
		Ghost_SetFlag(GHF_NORMAL);
		Ghost_UnsetFlag(GHF_SET_DIRECTION);
		Ghost_UnsetFlag(GHF_STUN);
		
		int combo = ghost->Attributes[10];
		int counter = -1;
		Ghost_Transform(this, ghost, -1, -1, 1, 2);
		Ghost_SetHitOffsets(ghost, 0, 16, 0, 0);
		ghost->DrawYOffset -= 16;
		int sightCooldown;
		int Attack= 1;
		int LastAttack = -1;
		int MaxHP = Ghost_HP;
		int cycle;
		int vars[10] = {combo, MaxHP};
		int walktimer;
		int Pressure;
		int LinkAngle;
		int bitid = TempBitmap_Create(0, 256, 32);
		bitmap laserbitmap = TempBMP[bitid];
		int VAR_KAYLANI = 0;
		int VAR_TORRIN = 1;
		int VAR_ASHER = 2;
		int Opponent = Screen->D[0];
		// Game->PlayEnhancedMusic("SS-Test.ogg", 0);
		RunFFCScript(Game->GetFFCScript("HealthBar_Tiled_Single"), {ghost->ID, 62, 0, 1});
		while(true){
			//Walk phase
			if(Opponent == VAR_KAYLANI || (Opponent == VAR_ASHER && Rand(0,1) == 0)){
				walktimer = Rand(120, 240);
				Pressure = 0;
				int DashChance = 200;
				Ghost_Data = combo+4;
				while(walktimer >0 && Pressure < 60){
					Ghost_MoveTowardLink(0.75, 2);
					Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
					if(Distance(Ghost_X, Ghost_Y, Link->X, Link->Y) <= 48)
						Pressure++;
					walktimer++;
					if(Opponent != VAR_ASHER){
						if(Ghost_HP < MaxHP * 0.75 && walktimer % 110 == 0){
							int ang = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
							eweapon e = FireEWeapon(EW_SOLAR, Ghost_X, Ghost_Y, DegtoRad(ang), 200, ghost->WeaponDamage, SPR_LIGHTSHOT, 32, EWF_UNBLOCKABLE);
							e->Rotation = ang;
						}
						if(Ghost_HP < MaxHP * 0.25 && walktimer % 55 == 0 && walktimer % 110 != 0){
							int ang = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
							eweapon e = FireEWeapon(EW_SOLAR, Ghost_X, Ghost_Y, DegtoRad(ang), 200, ghost->WeaponDamage, SPR_LIGHTSHOT, 32, EWF_UNBLOCKABLE);
							e->Rotation = ang;
						}
					}
					if(DashChance > 0 && Distance(Ghost_X, Ghost_Y, Link->X, Link->Y) > 48)
						DashChance--;
					if(Opponent == VAR_ASHER && Rand(0, DashChance) == 0){
						Dash(this, ghost, vars, true);
						walktimer = 0;
					}
					Grandma_Waitframe(this, ghost, vars);
				}
			}
			else{
				int ang;
				int rotatedirection = Choose(-1, 1);
				walktimer = Rand(120, 240);
				Pressure = 0;
				int DashChance = 200;
				Ghost_Data = combo+4;
				
				while(walktimer >0){
					if(G[G_ANIM] % 4 == 0)
						ang += rotatedirection;
					int TargetX = Link->X + VectorX(80, ang);
					int TargetY = Link->Y + VectorY(80, ang);
					LinkAngle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
					Ghost_Dir = AngleDir4(LinkAngle);
					int movementangle = Angle(Ghost_X, Ghost_Y, TargetX, TargetY);
					if(CanMoveAtAngle(movementangle, .5, 2)){
						if(Ghost_Data != combo+4)
							Ghost_Data = combo+4;
						Ghost_MoveAtAngle(movementangle, 1, 2);
					}
					else{
						if(Ghost_Data != combo)
							Ghost_Data = combo;
						Pressure++;
					}
					if(Pressure>=60){
						Pressure = 0;
						Ghost_Data = combo + 4;
						Grandma_Waitframes(this, ghost, vars, 30);
						Dash(this, ghost, vars, false);
					}
					Ghost_Dir = AngleDir4(LinkAngle);
					// if(Distance(Ghost_X, Ghost_Y, Link->X, Link->Y) <= 48)
						// Pressure++;
					walktimer--;
					if(Opponent != VAR_ASHER){
						if(Ghost_HP < MaxHP * 0.75 && walktimer % 90 == 0){
							int ang = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
							eweapon e = FireEWeapon(EW_SOLAR, Ghost_X, Ghost_Y, DegtoRad(ang), 200, ghost->WeaponDamage, SPR_LIGHTSHOT, 32, EWF_UNBLOCKABLE);
							e->Rotation = ang;
						}
						if(Ghost_HP < MaxHP * 0.25 && walktimer % 45 == 0 && walktimer % 90 != 0){
							int ang = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
							eweapon e = FireEWeapon(EW_SOLAR, Ghost_X, Ghost_Y, DegtoRad(ang), 200, ghost->WeaponDamage, SPR_LIGHTSHOT, 32, EWF_UNBLOCKABLE);
							e->Rotation = ang;
						}
					}
					if(DashChance > 0 && Distance(Ghost_X, Ghost_Y, Link->X, Link->Y) > 48)
						DashChance--;
					if(Opponent == VAR_ASHER && Rand(0, DashChance) == 0){
						Dash(this, ghost, vars, true);
						walktimer = 0;
					}
					Grandma_Waitframe(this, ghost, vars);
				}
			}
			//Clear any remaining Sun Dogs
			Screen->D[1] = 1;
			Grandma_Waitframes(this, ghost, vars, 60);
			Screen->D[1] = 0;
			//Attack
			do{
				Attack = Rand(0,2);
			}
			while(Attack == LastAttack);
			LastAttack = Attack;
			if(Attack == 0){
				Ghost_Data = combo+8;
				Game->PlaySound(36);
				LinkAngle = Angle(Ghost_X+8, Ghost_Y+8, Link->X+8, Link->Y+8);
				Grandma_Waitframes(this, ghost, vars, 40);
				int sfxTimer[1];
				for(i=0; i<64; ++i){
					Ghost_FaceLink(ghost);
					LinkAngle = TurnToAngle(LinkAngle, Angle(Ghost_X+8, Ghost_Y+8, Link->X+8, Link->Y+8), 0.7);
					LoopingSFX(sfxTimer, 6, SFX_LASERBEAM);
					int j = 0;
					if(i>16)
						j = Floor(G[G_ANIM]/4)%4;
					DrawSolarLaserEW(laserbitmap, Ghost_X+8, Ghost_Y+8, LinkAngle, 16, ghost->WeaponDamage, j);
					Grandma_Waitframe(this, ghost, vars);
				}
				Grandma_Waitframes(this, ghost, vars, 15);
				Ghost_FaceLink(ghost);
				for(i = -60; i<=60; i+=30){
					eweapon e = FireAimedEWeapon(EW_SOLAR, Ghost_X, Ghost_Y, DegtoRad(i), 200, ghost->WeaponDamage, SPR_LIGHTSHOT, 32, EWF_UNBLOCKABLE);
					e->Rotation = RadtoDeg(e->Angle);
					Grandma_Waitframes(this, ghost, vars, 5);
				}
				Ghost_Data = combo;
				Grandma_Waitframes(this, ghost, vars, 60);
			}
			if(Attack == 1){
				Ghost_Data = combo+8;
				Game->PlaySound(35);
				Grandma_Waitframes(this, ghost, vars, 30);
				int numOrbs = 2;
				int orbDist = 32;				
				Ghost_Data = combo;
				if(Ghost_HP <= MaxHP * 0.5){
					numOrbs = 4;
					orbDist = 48;
				}
				eweapon orbs[4];
				int rotAngle = DirAngle(Ghost_Dir);
				for(i=0; i<numOrbs; ++i){
					orbs[i] = FireEWeapon(EW_SOLAR, Ghost_X, Ghost_Y, WrapDegrees(rotAngle+(360/numOrbs)*i), 0, ghost->WeaponDamage, SPR_FRIENDBALL, 0, EWF_UNBLOCKABLE);
					// orbs[i]->Script = LWS_TIMEOUT;
					// orbs[i]->InitD[0] = 2;
				}
				Game->PlaySound(SFX_FRIENDBALLFIRE);
				int accelmult = 1;
				for(int j=0; j<60; ++j){
					accelmult = Max(accelmult-0.1, 1);
					rotAngle = WrapDegrees(rotAngle+6*accelmult);
					for(i=0; i<numOrbs; ++i){
						int orbX = Ghost_X+VectorX(orbDist*Sin(j*(180/240)), rotAngle+(360/numOrbs)*i);
						int orbY = Ghost_Y+VectorY(orbDist*Sin(j*(180/240)), rotAngle+(360/numOrbs)*i);
						if(G[G_ANIM]%5==0)
							ParticleAnim(orbX+Rand(-4, 4), orbY+Rand(-4, 4), 65242, 0, 4, 0);
						if(orbs[i]->isValid()){
							orbs[i]->X = orbX;
							orbs[i]->Y = orbY;
							orbs[i]->DeadState = WDS_ALIVE;
							orbs[i]->Dir = AngleDir4(WrapDegrees(rotAngle+(360/numOrbs)*i));
							// orbs[i]->InitD[0] = 2;
						}
						else{
							orbs[i] = FireEWeapon(EW_SOLAR, Ghost_X, Ghost_Y, WrapDegrees(rotAngle+(360/numOrbs)*i), 0, ghost->WeaponDamage, SPR_FRIENDBALL, 0, EWF_UNBLOCKABLE);
							// orbs[i]->Script = LWS_TIMEOUT;
							// orbs[i]->InitD[0] = 2;
						}
					}
					if(Ghost_HP <= MaxHP * 0.5){
						Ghost_Data = combo+4;
						Ghost_MoveTowardLink(0.5, 2);
						Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
					}
					Grandma_Waitframe(this, ghost, vars);
				}
				Ghost_Data = combo+8;
				Grandma_Waitframes(this, ghost, vars, 30);
				for(i=0; i<numOrbs; ++i){
					if(orbs[i]->isValid()){
						orbs[i]->Angle = DegtoRad(Angle(orbs[i]->X, orbs[i]->Y, Link->X, Link->Y));
						orbs[i]->Step = 300;
					}
				}
				Grandma_Waitframes(this, ghost, vars, 60);
			}
			if(Attack == 2){
				int numclones = 1;
				// if(Ghost_HP <= MaxHP*0.25)
					// numclones = 3;
				if(Ghost_HP <= MaxHP*0.4)
					numclones = 2;
				int TeleX; int TeleY; int incr;
				for(i=0; i<numclones; i++){
					incr = 0;
					do{
						TeleX = Rand(32, 208);
						TeleY = Rand(32, 128); 
						incr++;
					}
					while(Distance(Link->X, Link->Y, TeleX, TeleY) < 32 || Distance(Ghost_X, Ghost_Y, TeleX, TeleY) < 24 || OnSolid(TeleX, TeleY) || incr>100);
					if(incr>100){
						do{
							TeleX = Rand(32, 208);
							TeleY = Rand(32, 128); 
							incr++;
						}
						while(OnSolid(TeleX, TeleY));
					}
					Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
					DashTarget(this, ghost, vars, TeleX, TeleY);
					eweapon e = FireAimedEWeapon(EW_SCRIPT1, Ghost_X, Ghost_Y-2, 0, 0, ghost->WeaponDamage, 0, 0, 0);
					e->CollDetection = false;
					e->Tile = GH_BLANK_TILE;
					RunEWeaponScript(e, "GrandmaSundog", 0); 
					Grandma_Waitframes(this, ghost, vars, 60);
				}
			}
		}
	}
	void Dash(ffc this, npc ghost, int vars, bool Sunball){
		Game->PlaySound(71);
		Ghost_Data = vars[0]+8;
		int LinkAngle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
		for(int i = 0; i < 16; i++){
			if(!CanMoveAtAngle(LinkAngle, 2, 2))
				break;
			else{
				Ghost_MoveAtAngle(LinkAngle, 4, 2);
				if(G[G_ANIM] %2 ==0){
					eweapon copy = CreateEWeaponAt(EW_SCRIPT1,ghost->X, ghost->Y-16);
					copy->CollDetection = false;
					copy->OriginalTile = Game->ComboTile(Ghost_Data+Ghost_Dir);
					copy->Tile = Game->ComboTile(Ghost_Data+Ghost_Dir);
					copy->DrawStyle = DS_PHANTOM;
					copy->DeadState = 8;
					copy = CreateEWeaponAt(EW_SCRIPT1,ghost->X, ghost->Y);
					copy->CollDetection = false;
					copy->OriginalTile = Game->ComboTile(Ghost_Data+Ghost_Dir)+20;
					copy->Tile = Game->ComboTile(Ghost_Data+Ghost_Dir)+20;
					copy->DrawStyle = DS_PHANTOM;
					copy->DeadState = 8;
				}							
			}
			Grandma_Waitframe(this, ghost, vars);
		}
		Grandma_Waitframes(this, ghost, vars, 8);
		Ghost_Data = vars[0];
		if(Sunball){
			eweapon e = FireEWeapon(EW_SOLAR, Ghost_X, Ghost_Y,0, 0, ghost->WeaponDamage, 0, SFX_LIGHTSHOT, EWF_UNBLOCKABLE);
			e->CollDetection = false;
			RunEWeaponScript(e, "SolarBigShot", {0, 16, 0.5, 0.2, 0, 48});
			Grandma_Waitframes(this, ghost, vars, 90);
		}
	}
	void DashTarget(ffc this, npc ghost, int vars, int x, int y){
		Game->PlaySound(71);
		Ghost_Data = vars[0]+8;
		int LinkAngle = Angle(Ghost_X, Ghost_Y, x, y);
		while(Distance(Ghost_X, Ghost_Y, x, y) > 4){
			Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
			if(!CanMoveAtAngle(LinkAngle, 2, 2))
				break;
			else{
				Ghost_MoveAtAngle(LinkAngle, 4, 2);
				if(G[G_ANIM] %2 ==0){
					eweapon copy = CreateEWeaponAt(EW_SCRIPT1,ghost->X, ghost->Y-16);
					copy->CollDetection = false;
					copy->OriginalTile = Game->ComboTile(Ghost_Data+Ghost_Dir);
					copy->Tile = Game->ComboTile(Ghost_Data+Ghost_Dir);
					copy->DrawStyle = DS_PHANTOM;
					copy->DeadState = 8;
					copy = CreateEWeaponAt(EW_SCRIPT1,ghost->X, ghost->Y);
					copy->CollDetection = false;
					copy->OriginalTile = Game->ComboTile(Ghost_Data+Ghost_Dir)+20;
					copy->Tile = Game->ComboTile(Ghost_Data+Ghost_Dir)+20;
					copy->DrawStyle = DS_PHANTOM;
					copy->DeadState = 8;
				}							
			}
			Grandma_Waitframe(this, ghost, vars);
		}
		Ghost_Data = vars[0];
	}
	void Grandma_Waitframe(ffc this, npc ghost, int vars){
		if(Link->HP <= 0){
			Link->HP = Link->MaxHP;
			Link->MP = Link->MaxMP;
			DamageNumbers[_DNUM_LASTLINKHP] = Link->HP;
			KillEWeapons();
			KillLWeapons();
			vars[2]++;
			if(vars[2] >= 5 && vars[2] < 9){
				ghost->HP = vars[1]*0.5;
				Ghost_HP = vars[1]*0.5;
			}
			else if(vars[2] >= 9){
				ghost->HP = vars[1]*0.25;
				Ghost_HP = vars[1]*0.25;
			}
			else{
				ghost->HP = vars[1];
				Ghost_HP = vars[1];
			}
			ghost->Misc[NPCM_DAMAGENUMBERSLASTHP] = ghost->HP;
			RefundCounters();
			Link->CollDetection = false;
			if(GetCharID()==CHAR_KAYLANI){
				PlayString("Come on, Kaylani, I trained you better than that. On your feet, give it another go.", SCHAR_WINNO, EMOTE_NORMAL);
			}
			if(GetCharID()==CHAR_TORRIN){
				PlayString("Are you holding back on me because of my age? I won't stand for that, Torrin. Hit me with everything you have!", SCHAR_WINNO, EMOTE_NORMAL);
			}
			if(GetCharID()==CHAR_ASHER){
				PlayString("My ancestors led me to believe stellar magic was far more impressive than this. Surely you can do better, Asher.", SCHAR_WINNO, EMOTE_NORMAL);
			}
			while(G[G_MSGACTIVE]){
				G[G_NOACTION] = 1;
				SSGhost_Waitframe(this, ghost, false, false);
			}
			Link->CollDetection = true;
		}
		if(!SSGhost_Waitframe(this, ghost, false, false)){
			ghost->HP = vars[1];
			Ghost_HP = vars[1];
			DeathAnimCleanup(ghost);
			Link->HP = Link->MaxHP;
			Link->MP = Link->MaxMP;
			DamageNumbers[_DNUM_LASTLINKHP] = Link->HP;
			KillEWeapons();
			KillLWeapons();
			if(GetCharID()==CHAR_KAYLANI){
				PlayStringAndWait("Excellent. You've grown as a mage so much in such a short time. Send in the next one.", SCHAR_WINNO, EMOTE_NORMAL);
				G[G_GRANDMAPROGRESS] = 1;
				DayNight[_DN_HOUR] = 17;
				DayNight[_DN_MINUTE] = 30;
				DayNight[_DN_SECOND] = 0;
				G[G_HOURCLAMP] = 17;
				G[G_MINUTECLAMP] = 59;
				ffc f = FindFreeFFC();
				f->Data = CMB_AUTOWARPA;
			}
			if(GetCharID()==CHAR_TORRIN){
				PlayStringAndWait("Well Torrin, I'd say you're just as capable as any mage I've met. You may have a propensity for finding trouble, yet you've bailed out Kaylani and Asher before, and I suspect you will continue to. Please send in Asher for me now.", SCHAR_WINNO, EMOTE_NORMAL);
				G[G_GRANDMAPROGRESS] = 3;
				DayNight[_DN_HOUR] = 18;
				DayNight[_DN_MINUTE] = 30;
				DayNight[_DN_SECOND] = 0;
				G[G_HOURCLAMP] = 18;
				G[G_MINUTECLAMP] = 59;
				ffc f = FindFreeFFC();
				f->Data = CMB_AUTOWARPA;
			}
			if(GetCharID()==CHAR_ASHER){
				PlayStringAndWait("Excellent. You demonstrate both the power and the restraint necessary.", SCHAR_WINNO, EMOTE_NORMAL);
				PlayStringAndWait("So what now?", SCHAR_ASHER, EMOTE_NORMAL);
				PlayStringAndWait("Now, it's time to see if my suspicions are correct.", SCHAR_WINNO, EMOTE_NORMAL);
				G[G_GRANDMAPROGRESS] = 5;
				DayNight[_DN_HOUR] = 21;
				DayNight[_DN_MINUTE] = 00;
				DayNight[_DN_SECOND] = 0;
				G[G_HOURCLAMP] = 21;
				G[G_MINUTECLAMP] = 59;
				ffc f = FindFreeFFC();
				f->Data = CMB_AUTOWARPA;
			}
		}
	}
	void Grandma_Waitframes(ffc this, npc ghost, int vars, int frames){
		for(int i=0; i<frames; i++){
			Grandma_Waitframe(this, ghost, vars);
		}
	}
}

bool CanMoveAtAngle(int angle, int step, int imprecision){
	int xstep = VectorX(step,angle);
	int ystep = VectorY(step,angle);
	if(xstep <0){
		if(!Ghost_CanMove(DIR_LEFT, -xstep, imprecision))
			return false;
	}
	else if(xstep >0){
		if(!Ghost_CanMove(DIR_RIGHT, xstep, imprecision))
			return false;
	}
	if(ystep < 0){
		if(!Ghost_CanMove(DIR_UP, -ystep, imprecision))
			return false;
	}
	else if(ystep >0){
		if(!Ghost_CanMove(DIR_DOWN, ystep, imprecision))
			return false;
	}
	return true;	
}

ffc script TrueElemental{
	const int EYEANGLE = 0;
	const int EYESTATE = 1;
	const int FLOATTIME = 2;
	void run(int enemyID){
		npc ghost = Ghost_InitAutoGhost(this, enemyID);
		Ghost_SetFlag(GHF_FLYING_ENEMY);
		Ghost_SetFlag(GHF_IGNORE_ALL_TERRAIN);
		int type = ghost->Attributes[0];
		ghost->DrawYOffset = -1000;
		int vars[16];
		
		
		int timer = Rand(32, 48);
		int angle = Rand(360);
		int attackCooldown = 120;
		int state;
		vars[EYEANGLE] = angle;
		while(true){
			if(state==0){
				if(timer>0)
					--timer;
				else{
					angle = Rand(360);
					if(Ghost_X<32||Ghost_Y<32||Ghost_X>208||Ghost_Y<128)
						angle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y)+Rand(-40, 40);
					state = 1;
					timer = 16; 
				}
			}
			else{
				if(timer>0){
					--timer;
					Ghost_MoveAtAngle(angle, 2, 0);
				}
				else{
					state = 0;
					timer = Rand(32, 48);
				}
			}
			
			if(attackCooldown>0){
				--attackCooldown;
				if(attackCooldown>0&&Distance(Link->X, Link->Y, Ghost_X, Ghost_Y)<64)
					--attackCooldown;
			}
			else if(state==0&&Rand(24)==0&&!TE_ScreenExceptions()){
				vars[EYESTATE] = 1;
				TE_Waitframe(this, ghost, vars, 32);
				
				switch(type){
					case 0: //Solar
						int t;
						angle = Angle(Link->X, Link->Y, Ghost_X, Ghost_Y);
						Game->PlaySound(SFX_SOLARBIGSHOT_FIRE);
						for(int i=0; i<48; ++i){
							if(Distance(Ghost_X, Ghost_Y, Link->X, Link->Y)<48&&i<24)
								Ghost_MoveAtAngle(angle, 1, 0);
							++t;
							SolarBigShot.DrawBigShot(Ghost_X+8, Ghost_Y+8, Lerp(0, 48, i/48), ghost->WeaponDamage*2, t, Floor(t/4)%4);
							TE_Waitframe(this, ghost, vars, 1);
						}
						for(int i=0; i<32; ++i){
							++t;
							SolarBigShot.DrawBigShot(Ghost_X+8, Ghost_Y+8, 48, ghost->WeaponDamage*2, t, Floor(t/4)%4);
							TE_Waitframe(this, ghost, vars, 1);
						}
						Game->PlaySound(78);
						for(int i=0; i<8; ++i){
							++t;
							SolarBigShot.DrawBigShot(Ghost_X+8, Ghost_Y+8, Lerp(48, 8, i/8), ghost->WeaponDamage*2, t, Floor(t/4)%4);
							TE_Waitframe(this, ghost, vars, 1);
						}
						eweapon e = FireEWeapon(EW_SOLAR, Ghost_X, Ghost_Y, DegtoRad(angle+180), 0, ghost->Damage, SPR_FRIENDBALL, SFX_WAND, 0);
						RunEWeaponScript(e, "SolarChaser", {0.05, 1.5, 60, 0.01});
						break;
					case 1: //Lunar
						int spreadDir = Choose(-1, 1);
						int angle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
						for(int i=0; i<12; ++i){
							eweapon e = FireEWeapon(EW_LUNAR, Ghost_X, Ghost_Y, DegtoRad(angle+Lerp(-45, 45, i/11)), 0, ghost->WeaponDamage, SPR_LUNARPHASECUTTER, SFX_WAND, 0);
							RunEWeaponScript(e, "LunarPhaseCutter", {25, 50, 6});
							TE_Waitframe(this, ghost, vars, 3);
						}
						TE_Waitframe(this, ghost, vars, Rand(64, 96));
						eweapon e = CreateEWeaponAt(EW_SCRIPT10, 120, 80);
						e->CollDetection = false;
						e->DrawYOffset = -1000;
						angle = Angle(Link->X, Link->Y, Ghost_X, Ghost_Y);
						RunEWeaponScript(e, "LunarShift", {angle, 1.5, 8, 48});
						TE_Waitframe(this, ghost, vars, 64);
						break;
					case 2: //Stellar
						int strafeDir = Choose(-1, 1);
						for(int i=0; i<5; ++i){
							angle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y)+50*strafeDir+Rand(-20, 20);
							for(int j=0; j<16; ++j){
								Ghost_MoveAtAngle(angle, 2, 0);
								TE_Waitframe(this, ghost, vars, 1);
							}
							TE_Waitframe(this, ghost, vars, Rand(8, 12));
						}
						for(int i=0; i<8; ++i){
							eweapon e = FireEWeapon(EW_STELLAR, Ghost_X, Ghost_Y, DegtoRad(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y)), 0, ghost->WeaponDamage, 0, 0, 0);
							e->DrawYOffset = -1000;
							e->CollDetection = false;
							RunEWeaponScript(e, "StellarKnockbackBlast", {0, 300});
							TE_Waitframe(this, ghost, vars, Rand(8, 10));
						}
						break;
				}
				timer = 48;
				vars[EYESTATE] = 0;
				vars[EYEANGLE] = angle;
				
				attackCooldown = 300;
			}
			
			vars[EYEANGLE] = TurnToAngle(vars[EYEANGLE], angle, 10);
			TE_Waitframe(this, ghost, vars, 1);
		}
	}
	void TE_Waitframe(ffc this, npc ghost, int vars, int frames){
		int type = ghost->Attributes[0];
		int combo = ghost->Attributes[10];
		for(int i=0; i<frames||ghost->Stun; ++i){
			vars[FLOATTIME] = (vars[FLOATTIME]+1)%360;
			int yOff = -2+2*Sin(vars[FLOATTIME]*8);
			if(G[G_ANIM]%16==0){
				switch(type){
					case 0: //Solar
						ParticleAnim(Ghost_X+Rand(-8, 8), Ghost_Y+Rand(-8, 8)+yOff, 968, 8, 8, 5);
						break;
					case 1: //Lunar
						ParticleAnim(Ghost_X+Rand(-8, 8), Ghost_Y+Rand(-8, 8)+yOff, 611, 7, 8, 5);
						break;
					case 2: //Stellar
						ParticleAnim(Ghost_X+Rand(-8, 8), Ghost_Y+Rand(-8, 8)+yOff, 968, 9, 8, 5);
						break;
				}
			}
			Screen->FastCombo(2, Ghost_X, Ghost_Y+yOff, combo, this->CSet, 128);
			if(vars[EYESTATE]==1){ //Flashing
				vars[EYEANGLE] = WrapDegrees(vars[EYEANGLE]+20);
				Screen->FastCombo(2, Ghost_X+VectorX(2, vars[EYEANGLE]), Ghost_Y+yOff-Ghost_Z+VectorY(2, vars[EYEANGLE]), combo+2, this->CSet, 128);
			}
			else //Normal
				Screen->FastCombo(2, Ghost_X+VectorX(4, vars[EYEANGLE]), Ghost_Y+yOff-Ghost_Z+VectorY(4, vars[EYEANGLE]), combo+1, this->CSet, 128);
			DarkRoom_AddLight(Ghost_X+8, Ghost_Y+8, 0, 24, 1, 0, 0, 0);					
			Ghost_Waitframe(this, ghost);
		}
	}
	bool TE_ScreenExceptions(){
		if(Game->GetCurMap()==28&&Game->GetCurScreen()==0x4C)
			return true;
		return false;
	}
}

ffc script HoppingFlytrap{
	void run(int enemyID){
		npc ghost = Ghost_InitAutoGhost(this, enemyID);
		int combo = ghost->Attributes[10];
		int attackCooldown = Rand(1, 3);
		while(true){
			Ghost_Waitframes(this, ghost, 48);
			int hops = Rand(2, 4);
			int baseAngle = Rand(360);
			bool willAttack;
			if(attackCooldown)
				--attackCooldown;
			else if(Rand(4)!=0){
				willAttack = true;
				baseAngle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
			}
			for(int i=0; i<hops; ++i){
				int fakeJump = 0.8;
				int fakeZ = 0;
				//Ghost_Jump = 0.8;
				int angle = baseAngle+Rand(-20, 20);
				int vX = VectorX(1, baseAngle);
				int vY = VectorY(1, baseAngle);
				Ghost_Data = combo+1;
				ghost->DrawYOffset -= 2;
				while(fakeJump>0||fakeZ>0){
					if((vX<0&&!Ghost_CanMove(DIR_LEFT, 1, 0))||(vX>0&&!Ghost_CanMove(DIR_RIGHT, 1, 0))){
						vX = -vX;
						baseAngle = Angle(0, 0, vX, vY);
					}
					if((vY<0&&!Ghost_CanMove(DIR_UP, 1, 0))||(vY>0&&!Ghost_CanMove(DIR_DOWN, 1, 0))){
						vY = -vY;
						baseAngle = Angle(0, 0, vX, vY);
					}
					Ghost_MoveAtAngle(angle, 1, 0);
					fakeZ = Max(fakeZ+fakeJump, 0);
					fakeJump = Max(fakeJump-0.16, -3.2);
					ghost->DrawYOffset = -2-fakeZ;
					ghost->HitYOffset = -fakeZ;
					Ghost_Waitframe(this, ghost);
				}
				ghost->DrawYOffset += 2;
				Ghost_Data = combo;
				Ghost_Waitframes(this, ghost, 4);
			}
			if(willAttack){
				Ghost_Waitframes(this, ghost, 32);
				Ghost_Data = combo+2;
				Ghost_Waitframes(this, ghost, 8);
				Ghost_Data = combo;
				Ghost_Waitframes(this, ghost, 4);
				Ghost_Data = combo+3;
				Ghost_Waitframes(this, ghost, 4);
				Ghost_Data = combo+4;
				Ghost_Waitframes(this, ghost, 4);
				for(int i=0; i<8; ++i){
					eweapon e = FireEWeapon(EW_PHYSICAL, Ghost_X, Ghost_Y-8, DegtoRad(Rand(360)), Rand(100, 150), ghost->WeaponDamage, 0, 0, EWF_UNBLOCKABLE);
					e->OriginalTile = 7751;
					e->Tile = e->OriginalTile;
					e->CSet = 7;
					RunEWeaponScript(e, "SporeEW", {0});
				}
				Ghost_Waitframes(this, ghost, 32);
				Ghost_Data = combo+3;
				Ghost_Waitframes(this, ghost, 4);
				Ghost_Data = combo+2;
				Ghost_Waitframes(this, ghost, 8);
				Ghost_Data = combo;
				Ghost_Waitframes(this, ghost, 32);
				attackCooldown = Rand(2, 3);
			}
		}
	}
}

ffc script Hive{
	void run(int enemyID){
		npc ghost = Ghost_InitAutoGhost(this, enemyID);
		npc bees[16];
		int beeNPC = ghost->Attributes[0];
		int spawnTimer = 120;
		int spawnCooldown = 120;
		int spawnCooldownCooldown;
		for(int i=0; i<16; ++i){
			bees[i] = CreateNPCAt(beeNPC, Ghost_X+Rand(-16, 16), Ghost_Y+Rand(-16, 16));
			bees[i]->InitD[0] = ghost->UID;
		}
		bool onTree = !Ghost_CanPlace(Ghost_X, Ghost_Y+8, 16, 8);
		if(onTree){
			Ghost_SetFlag(GHF_NO_FALL);
			Ghost_SetFlag(GHF_FAKE_Z);
			for(int i=0; i<32; ++i){
				Ghost_Y += 8;
				Ghost_Z += 8;
				if(Ghost_CanPlace(Ghost_X, Ghost_Y+8, 16, 8))
					break;
			}
		}
		while(true){
			if(spawnCooldownCooldown){
				--spawnCooldownCooldown;
				if(spawnCooldownCooldown<=0)
					spawnCooldown = 120;
			}
			
			for(int i=0; i<16; ++i){
				if(!bees[i]->isValid()){
					if(spawnTimer>0){
						--spawnTimer;
					}
					else{
						bees[i] = CreateNPCAt(beeNPC, Ghost_X, Ghost_Y);
						bees[i]->InitD[0] = ghost->UID;
						spawnTimer = spawnCooldown;
					}
					break;
				}
			}
			if(Ghost_GotHit()){
				for(int i=0; i<16; ++i){
					if(bees[i]->isValid()){
						bees[i]->InitD[1] = 20;
					}
				}
				if(onTree){
					Ghost_UnsetFlag(GHF_NO_FALL);
					Game->PlaySound(SFX_FALL);
					spawnCooldown = 30;
					spawnCooldownCooldown = 300;
					while(Ghost_Z>0){
						Ghost_Waitframe(this, ghost);
					}
					onTree = false;
				}
			}
			Ghost_Waitframe(this, ghost);
		}
	}
}

npc script NotTheBees{
	void run(int parentUID){
		npc parent = Screen->LoadNPCByUID(parentUID);
		this->HitXOffset = 7;
		this->HitYOffset = 7;
		this->HitWidth = 2;
		this->HitHeight = 2;
		int oTile = this->Tile;
		int aFrame = Rand(2);
		int aSpeed;
		while(this->HP>0){
			int frames = Rand(12, 18);
			int moveAngle = Rand(360);
			if(parent->isValid()&&this->InitD[1]==0){
				if(Distance(this->X, this->Y, parent->X, parent->Y)>32){
					moveAngle = Angle(this->X, this->Y, parent->X, parent->Y)+Rand(-40, 40);
				}
			}
			else{
				if(Rand(2)==0){
					moveAngle = Angle(this->X, this->Y, Link->X, Link->Y)+Rand(-40, 40);
				}
			}
			if(this->InitD[1]>0)
				--this->InitD[1];
			for(int i=0; i<frames; ++i){
				this->MoveAtAngle(moveAngle, 2, SPW_FLOATER);
				++aSpeed;
				if(aSpeed>=2){
					aSpeed = 0;
					aFrame = (aFrame+1)%2;
					this->ScriptTile = oTile+aFrame;
				}
				Waitframe();
			}
		}
	}
}

npc script CanAevinSue{
	bool LeechCanMove(int xy, int angle, int step){
		mapdata l1 = Game->LoadTempScreen(1);
		mapdata l2 = Game->LoadTempScreen(2);
		int x = xy[0]+7+VectorX(step, angle);
		int y = xy[1]+7+VectorY(step, angle);
		int pos = ComboAt(x, y);
		if(x>0&&x<255&&y>0&&y<175){
			if((Screen->ComboS[pos]|l2->ComboS[pos])==0){
				if(l1->ComboT[pos]==CT_WATER){
					//Screen->PutPixel(6, x, y, Choose(0x01, 0x02), 0, 0, 0, 128);
					return true;
				}
			}
		}
		//Screen->PutPixel(6, x, y, Choose(0x0D, 0x0E), 0, 0, 0, 128);
		return false;
	}
	void LeechMove(int xy, int angle, int step){
		for(int i=0; i<step; ++i){
			if(LeechCanMove(xy, angle, 4)){
				xy[0] += VectorX(1, angle);
				xy[1] += VectorY(1, angle);
			}
		}
	}
	void run(){
		combodata cd = Game->LoadComboData(19332);
		
		int angle = Rand(360);
		int tAngle = angle;
		int moveTime = 8;
		int tracking = 32;
		
		bool wasinWater = Link->Action==LA_SWIMMING||Link->Action==LA_DIVING;
		
		if(wasinWater){
			tAngle = Angle(this->X, this->Y, Link->X, Link->Y);
			tracking = 0;
		}
		
		int xy[2] = {this->X, this->Y};
		
		while(true){
			if(Link->Action==LA_SWIMMING||Link->Action==LA_DIVING){
				if(!wasinWater){
					for(int i=0; i<16; ++i){
						angle = Angle(this->X, this->Y, Link->X, Link->Y);
						tracking = 0;
					}
				}
				wasinWater = true;
			}
			else{
				if(wasinWater){
					for(int i=0; i<16; ++i){
						angle = Rand(360);
						moveTime = 8;
						tracking = Rand(24, 32);
					}
				}
				wasinWater = false;
			}
			
			bool turned;
			
			switch(tracking){
				case 0: //Homing on Link
					tAngle = Angle(this->X, this->Y, Link->X, Link->Y);
					angle = TurnToAngle(angle, tAngle, 20);
					if(!LeechCanMove(xy, angle, 4)){
						angle += 180;
						moveTime = 4;
						tracking += 6;
					}
					else{
						if(Distance(this->X, this->Y, Link->X, Link->Y)>4)
							LeechMove(xy, angle, 3);
						else
							tracking += 8;
					}
					break;
				case 1...15: //Weak homing
					if(moveTime>0){
						--moveTime;
						angle = TurnToAngle(angle, tAngle, 20);
						if(!LeechCanMove(xy, angle, 4)){
							int targetAngle = Angle(this->X, this->Y, Link->X, Link->Y)+Rand(-30, 30);
							tAngle = targetAngle;
							angle = tAngle;
							moveTime = 4;
							tracking += 4;
						}
						else
							LeechMove(xy, angle, 3);
					}
					if(moveTime==0){
						turned = true;
						moveTime = 4;
						int targetAngle = Angle(this->X, this->Y, Link->X, Link->Y)+Rand(-30, 30);
						tAngle = targetAngle;
					}
					break;
				case 16...31: //Weakest homing
					if(moveTime>0){
						--moveTime;
						angle = TurnToAngle(angle, tAngle, 20);
						if(!LeechCanMove(xy, angle, 4)){
							int targetAngle = Angle(this->X, this->Y, Link->X, Link->Y)+Choose(-1, 1)*Rand(30, 90);
							tAngle = targetAngle;
							angle = tAngle;
							moveTime = 6;
							tracking += 2;
						}
						else
							LeechMove(xy, angle, 3);
					}
					if(moveTime==0){
						turned = true;
						moveTime = 6;
						int targetAngle = Angle(this->X, this->Y, Link->X, Link->Y)+Choose(-1, 1)*Rand(30, 90);
						tAngle = targetAngle;
					}
					break;
				case 32: //Random
					if(moveTime>0){
						--moveTime;
						angle = TurnToAngle(angle, tAngle, 20);
						if(!LeechCanMove(xy, angle, 4)){
							int targetAngle = Rand(360);
							tAngle = targetAngle;
							angle = tAngle;
							moveTime = 8;
							tracking += 1;
						}
						else
							LeechMove(xy, angle, 3);
					}
					if(moveTime==0){
						turned = true;
						moveTime = 8;
						int targetAngle = Rand(360);
						tAngle = targetAngle;
					}
					break;
			}
		
			if(turned){
				if(wasinWater){
					--tracking;
				}
				else{
					++tracking;
				}
			}
			tracking = Clamp(tracking, 0, 32);
			
			this->X = xy[0];
			this->Y = xy[1];
			
			Screen->DrawTile(1, this->X, this->Y, cd->Tile, 1, 1, 4, -1, -1, this->X, this->Y, angle, 0, true, 128);
		
			Waitframe();
		}
	}
}

const int DAMAGE_BANESWORD = 4;

const int SFX_BANESWORD_APPEAR = 56;
const int SFX_BANESWORD_SWING = 30;

const int SFX_BANEBOSS_SHOT = 40;

const int SPR_BANEBOSS_SHOT1 = 117;
const int SPR_BANEBOSS_SHOT2 = 116;

const int D_ESANSUPERATTACK = 0;

ffc script BaneBoss{
	const int CHARGEANIM = 0;
	const int LOCKHP = 1;
	const int TERRYPRESENT = 2;
	const int SORENPRESENT = 3;
	const int MICAHPRESENT = 4;
	void run(int enemyID){
		int i; int j; int k;
		int x; int y; int dist; int ang; int ang2;
		int tX; int tY;
		eweapon e;
		
		npc ghost = Ghost_InitAutoGhost(this, enemyID);
		Ghost_SetFlag(GHF_4WAY);
		Ghost_Transform(this, ghost, -1, -1, 1, 2);
		Ghost_Y += 16;
		Ghost_SetHitOffsets(ghost, 0, 16, 0, 0);
		ghost->DrawYOffset -= 16;
		int combo = ghost->Attributes[10];
		untyped vars[16];
		
		Ghost_Dir = DIR_DOWN;
		if(G[G_RANDOMIZERENABLED]){
			if(Ghost_Y>80)
				Ghost_Dir = DIR_UP;
			else
				Ghost_Dir = DIR_DOWN;
		}
		else{
			Ghost_X = 120;
			Ghost_Y = 40;
			if(Game->GetCurDMap() == 73)
				Ghost_Y = 48;
		}
		int attackCycle = 0;
		int cageType = Rand(3);
		Screen->D[D_ESANSUPERATTACK] = 0;
		vars[TERRYPRESENT] = 0;
		if(Game->Counter[CR_TORRINSIDEQUEST] >= 6)
			vars[TERRYPRESENT] = 1;
		vars[SORENPRESENT] = 0;
		if(Game->Counter[CR_MISCSIDEQUEST] >= 8)
			vars[SORENPRESENT] = 1;
		vars[MICAHPRESENT] = 0;
		if(Game->Counter[CR_CULTISTQUEST] >= 6)
			vars[MICAHPRESENT] = 1;
		if(Game->GetCurDMap() == 73){
			vars[TERRYPRESENT] = 0;
			vars[SORENPRESENT] = 0;
			vars[MICAHPRESENT] = 0;
		}
		
		Game->PlayEnhancedMusic("SS-Boss.ogg", 0);
		RunFFCScript(Game->GetFFCScript("HealthBar_Tiled_Single"), {ghost->ID, 73, 0, 1});
		G[G_GRAYHEALTHBAR] = 0;
		
		int phase = 0;
		int initHP = ghost->HP;
		
		BB_Waitframe(this, ghost, vars, 64);
		
		while(true){
			int attack = 0; //Rand(5);
			int cageFreq = 2;
			if(IsEasyMode())
				cageFreq = 3;
			if(attackCycle%cageFreq==1){
				attack = 4;
			}
			else{
				if(Distance(Link->X, Link->Y, Ghost_X, Ghost_Y)<72){
					attack = Choose(0, 3);
				}
				else{
					attack = Choose(1, 2);
				}
			}
			++attackCycle;
			if(attackCycle==6){
				attackCycle = 0;
				attack = 5;
			}
			if(phase==0&&Ghost_HP<initHP*0.75){
				attack = 6;
				phase = 1;
			}
			else if(phase==1&&Ghost_HP<initHP*0.5){
				attack = 7;
				phase = 2;
			}
			else if(phase==2&&Ghost_HP<initHP*0.25){
				attack = 8;
				phase = 3;
			}
			if(attack==0){ //Sword Slashes (Close, Proximity)
				Ghost_FaceLink(ghost);
				for(i=0; i<24; ++i){
					if(Distance(Ghost_X, Ghost_Y, Link->X, Link->Y)>24){
						Ghost_Data = combo+4;
						Ghost_FaceLink(ghost);
						Ghost_MoveTowardLink(1.5, 0);
					}
					else
						Ghost_Data = combo;
					BB_Waitframe(this, ghost, vars, 1);
				}
				Ghost_Data = combo;
				ang = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
				Ghost_FaceLink(ghost);
				Game->PlaySound(SFX_BANESWORD_APPEAR);
				for(i=0; i<8; ++i){
					BB_Sword(111252, ang-90, 12, (i<4)?64:96);
					BB_Waitframe(this, ghost, vars, 1);
				}
				for(i=0; i<16; ++i){
					BB_Sword(111232, ang-90, 12, 128);
					BB_Waitframe(this, ghost, vars, 1);
				}
				Ghost_Data = combo+8;
				Game->PlaySound(SFX_BANESWORD_SWING);
				for(i=0; i<12; ++i){
					BB_Sword(111232, Lerp(ang-90, ang+90, i/11), 12, 128);
					Ghost_MoveAtAngle(ang+180, 1.5, 0);
					BB_Waitframe(this, ghost, vars, 1);
				}
				Ghost_Data = combo;
				for(i=0; i<8; ++i){
					BB_Sword(111252, ang+90, 12, (i<4)?96:64);
					BB_Waitframe(this, ghost, vars, 1);
				}
				j = FarthestCombo(Link->X, Link->Y, {53,58,67,76,99,108,117,122}, 0, 80);
				if(j>-1){
					BB_JumpToPos(this, ghost, vars, ComboX(j), ComboY(j), 32);
				}
				Ghost_Data = combo+8;
				if(!IsEasyMode()){
					for(i=0; i<4; ++i){
						Ghost_FaceLink(ghost);
						e = FireAimedEWeapon(EW_LUNAR, Ghost_X, Ghost_Y, DegtoRad(Rand(-10, 10)), 150, ghost->WeaponDamage, SPR_BANEBOSS_SHOT1, SFX_BANEBOSS_SHOT, EWF_UNBLOCKABLE);
						e->Rotation = RadtoDeg(e->Angle);
						RunEWeaponScript(e, "SpeedChange", {24, 600, SPR_BANEBOSS_SHOT2});
						BB_Waitframe(this, ghost, vars, 4);
					}
				}
				Ghost_FaceLink(ghost);
				Ghost_Data = combo;
			}
			else if(attack==1){ //Sword Slashes (Approach)
				Ghost_Data = combo+4;
				for(i=0; i<48; ++i){
					Ghost_FaceLink(ghost);
					Ghost_MoveTowardLink(1.2, 0);
					BB_Waitframe(this, ghost, vars, 1);
				}
				Ghost_Data = combo;
				ang = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
				Ghost_FaceLink(ghost);
				Game->PlaySound(SFX_BANESWORD_APPEAR);
				for(i=0; i<8; ++i){
					ang = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
					Ghost_FaceLink(ghost);
					BB_Sword(111252, ang-90, 12, (i<4)?64:96);
					BB_Waitframe(this, ghost, vars, 1);
				}
				k = 1;
				for(j=0; j<3; ++j){
					if(!Ghost_CanMove(Ghost_Dir, 1, 0)){
						tX = Link->X; 
						tY = Link->Y;
						Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, tX, tY));
						Ghost_Jump = FindJumpLength(40, true);
						Game->PlaySound(SFX_JUMP);
						dist = Distance(Ghost_X, Ghost_Y, tX, tY);
						Ghost_Data = combo+4;
						for(int i=0; i<40; ++i){
							ang = Angle(Ghost_X, Ghost_Y, tX, tY);
							Ghost_X += VectorX(dist/40, ang);
							Ghost_Y += VectorY(dist/40, ang);
							BB_Sword(111232, ang-90*k, 12, 128);
							BB_Waitframe(this, ghost, vars, 1);
						}
						Ghost_Data = combo;
						Ghost_X = tX;
						Ghost_Y = tY;
						for(i=0; i<16; ++i){
							ang = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
							Ghost_FaceLink(ghost);
							BB_Sword(111232, ang-90*k, 12, 128);
							BB_Waitframe(this, ghost, vars, 1);
						}
					}
					for(i=0; i<8+EasyModeFrames(4); ++i){
						ang = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
						Ghost_FaceLink(ghost);
						BB_Sword(111232, ang-90*k, 12, 128);
						BB_Waitframe(this, ghost, vars, 1);
					}
					Ghost_Data = combo+8;
					Game->PlaySound(SFX_BANESWORD_SWING);
					int dashLength = Clamp(Distance(Ghost_X, Ghost_Y, Link->X, Link->Y)/40, 1, 2.5);
					for(i=0; i<12; ++i){
						ang = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
						Ghost_FaceLink(ghost);
						BB_Sword(111232, Lerp(ang-90*k, ang+90*k, i/11), 12, 128);
						Ghost_MoveAtAngle(ang, dashLength*EasyModeMultiplier(0.7), 0);
						BB_Waitframe(this, ghost, vars, 1);
					}
					Ghost_Data = combo;
					k = -k;
				}
				for(i=0; i<8; ++i){
					BB_Sword(111252, ang+90, 12, (i<4)?96:64);
					BB_Waitframe(this, ghost, vars, 1);
				}
			}
			else if(attack==2){ //Aimed Tri Shots
				Ghost_Data = combo+4;
				BB_Waitframe(this, ghost, vars, 16);
				for(i=0; i<3; ++i){
					Ghost_FaceLink(ghost);
					for(j=-1; j<=1; ++j){
						int angOff = Lerp(40, 10, i/2);
						if(IsEasyMode())
							angOff = Lerp(40, 25, i/2);
						e = FireAimedEWeapon(EW_LUNAR, Ghost_X, Ghost_Y, DegtoRad(j*angOff), 150, ghost->WeaponDamage, SPR_BANEBOSS_SHOT1, SFX_BANEBOSS_SHOT, EWF_UNBLOCKABLE);
						e->Rotation = RadtoDeg(e->Angle);
						RunEWeaponScript(e, "SpeedChange", {24, 600, SPR_BANEBOSS_SHOT2});
					}
					BB_Waitframe(this, ghost, vars, 40);
				}
			}
			else if(attack==3){ //4-way Stream Shots
				k = ClosestCombo(Ghost_X, Ghost_Y, {52,59,116,123});
				Ghost_Data = combo+4;
				for(i=0; i<64&&Distance(Ghost_X, Ghost_Y, ComboX(k), ComboY(k))>2; ++i){
					Ghost_FaceLink(ghost);
					Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, ComboX(k), ComboY(k)), 2, 0);
					BB_Waitframe(this, ghost, vars, 1);
				}
				Ghost_Data = combo+8;
				Ghost_FaceLink(ghost);
				for(i=0; i<64; ++i){
					Ghost_FaceLink(ghost);
					BB_Waitframe(this, ghost, vars, 1);
				}
				ang = DirAngle(Ghost_Dir);
				for(i=0; i<12; ++i){
					Ghost_FaceLink(ghost);
					ang = TurnToAngle(ang, DirAngle(Ghost_Dir), 25-EasyModeFrames(15));
					int streamW = 24;
					if(IsEasyMode())
						streamW = 16;
					for(j=0; j<2; ++j){
						e = FireEWeapon(EW_LUNAR, Ghost_X, Ghost_Y, DegtoRad(ang), 150, ghost->WeaponDamage, SPR_BANEBOSS_SHOT1, SFX_BANEBOSS_SHOT, EWF_UNBLOCKABLE);
						e->X += VectorX(streamW*Sin((360*4/32)*i+180*j), ang+90);
						e->Y += VectorY(streamW*Sin((360*4/32)*i+180*j), ang+90);
						e->Rotation = RadtoDeg(e->Angle);
						RunEWeaponScript(e, "SpeedChange", {24, 600, SPR_BANEBOSS_SHOT2});
					}
					BB_Waitframe(this, ghost, vars, 8);
				}
				Ghost_Data = combo+4;
				for(i=0; i<32; ++i){
					Ghost_Move(Ghost_Dir, 3, 0);
					BB_Waitframe(this, ghost, vars, 1);
				}
				Ghost_Data = combo;
			}
			else if(attack==4){ //Create Cages
				++cageType;
				cageType %= 3;
				switch(cageType){
					case 0:
						Ghost_FaceLink(ghost);
						Ghost_Data = combo+8;
						BB_Waitframe(this, ghost, vars, 8);
						Game->PlaySound(78);
						e = CreateEWeaponAt(EW_SCRIPT10, Ghost_X, Ghost_Y);
						e->CollDetection = false;
						e->Step = 0;
						e->DrawYOffset = -1000;
						RunEWeaponScript(e, "BloodMoonCage", {Link->X+Rand(-24, 24), Link->Y+Rand(-24, 24), 32, 12, 180, 1});
						Ghost_Data = combo;
						BB_Waitframe(this, ghost, vars, 16);
						Ghost_Data = combo;
						BB_Waitframe(this, ghost, vars, 64);
						break;
					case 1:
						for(i=0; i<3; ++i){
							Ghost_FaceLink(ghost);
							Ghost_Data = combo+8;
							BB_Waitframe(this, ghost, vars, 8);
							Game->PlaySound(78);
							e = CreateEWeaponAt(EW_SCRIPT10, Ghost_X, Ghost_Y);
							e->CollDetection = false;
							e->Step = 0;
							e->DrawYOffset = -1000;
							RunEWeaponScript(e, "BloodMoonCage", {Link->X, Link->Y, 64, 8, 180, 1});
							Ghost_Data = combo;
							BB_Waitframe(this, ghost, vars, 16);
							Ghost_Data = combo;
							BB_Waitframe(this, ghost, vars, 16);
						}
						BB_Waitframe(this, ghost, vars, 48);
						break;
					case 2:
						int pos[] = {64,48, 176,48, 64,112, 176,112};
						j = Rand(4);
						for(i=0; i<4; ++i){
							x = pos[2*j+0];
							y = pos[2*j+1];
							j = (j+1)%4;
							Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, x, y));
							Ghost_Data = combo+8;
							BB_Waitframe(this, ghost, vars, 4);
							Game->PlaySound(78);
							e = CreateEWeaponAt(EW_SCRIPT10, Ghost_X, Ghost_Y);
							e->CollDetection = false;
							e->Step = 0;
							e->DrawYOffset = -1000;
							RunEWeaponScript(e, "BloodMoonCage", {x, y, 32, 8, 180, 1});
							Ghost_Data = combo;
							BB_Waitframe(this, ghost, vars, 8);
							Ghost_Data = combo;
							BB_Waitframe(this, ghost, vars, 8);
						}
						break;
				}
			}
			else if(attack==5){ //Skulls
				Ghost_Data = combo+8;
				int variant = Rand(3);
				for(i=0; i<8; ++i){
					ang = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
					ang2 = Angle(120, 80, Link->X, Link->Y);
					x = Link->X;
					y = Link->Y;
					j = Lerp(24, 0, i/7);
					switch(variant){
						case 0:
							x += VectorX(j, ang);
							y += VectorY(j, ang);
							break;
						case 1:
							x += VectorX(j, ang2);
							y += VectorY(j, ang2);
							break;
						case 2:
							x += (VectorX(j, ang)+VectorY(j, ang2))/2;
							y += (VectorY(j, ang)+VectorY(j, ang2))/2;
							break;
					}
					Ghost_FaceLink(ghost);
					e = FireEWeapon(LW_SCRIPT10, x, y, 0, 0, ghost->WeaponDamage, SPRITE_INVISIBLE, 0, EWF_UNBLOCKABLE);
					RunEWeaponEffect(e, "WavySkull", {Lerp(40, 24+EasyModeFrames(16), i/7), 32, 8, 5});
					BB_Waitframe(this, ghost, vars, 16);
				}
				Ghost_Data = combo;
				BB_Waitframe(this, ghost, vars, 48);
			}
			else if(attack==6||attack==7||attack==8){ //Superattack
				j = FarthestCombo(Link->X, Link->Y, {50, 61, 114, 125});
				G[G_TORRINLOCKON] = 0;
				if(j>-1){
					BB_JumpToPos(this, ghost, vars, ComboX(j), ComboY(j), 32);
				}
				Ghost_FaceLink(ghost);
				Ghost_Data = combo+16;
				vars[CHARGEANIM] = 1;
				vars[LOCKHP] = Ghost_HP;
				Screen->D[D_ESANSUPERATTACK] = 1;
				BB_Waitframe(this, ghost, vars, 8);
				Game->PlaySound(78);
				x = (Link->X+120)/2;
				y = (Link->Y+80)/2;
				eweapon cage = CreateEWeaponAt(EW_SCRIPT10, x, y);
				cage->CollDetection = false;
				cage->Step = 0;
				cage->DrawYOffset = -1000;
				RunEWeaponScript(cage, "BloodMoonCage", {x, y, 96, 8, 600, 1});
				BB_Waitframe(this, ghost, vars, 16);
				int skullDir = Choose(-1, 1);
				for(i=0; i<600-EasyModeFrames(180)&&cage->isValid()&&Screen->D[D_ESANSUPERATTACK]==1; ++i){
					if(i==120&&!G[G_RANDOMIZERENABLED]){
						int id = -1;
						if(vars[TERRYPRESENT]){
							id = 0;
							vars[TERRYPRESENT] = 0;
						}
						else if(vars[SORENPRESENT]){
							id = 1;
							vars[SORENPRESENT] = 0;
						}
						else if(vars[MICAHPRESENT]){
							id = 2;
							vars[MICAHPRESENT] = 0;
						}
						if(id>-1){
							RunFFCScript(Game->GetFFCScript("BaneBossNPCs"), {id, ghost});
						}
					}
					
					if(cage->InitD[6]>0){
						if(attack==6){
							int freq = 25;
							if(IsEasyMode())
								freq = 35;
							if(i%freq==0){
								ang = Rand(360);
								x = cage->X+VectorX(96, ang);
								y = cage->Y+VectorY(96, ang);
								for(j=0; j<360&&!InScreen(x, y, 16, 16, true); ++j){
									ang = Rand(360);
									x = cage->X+VectorX(96, ang);
									y = cage->Y+VectorY(96, ang);
								}
								e = FireEWeapon(EW_LUNAR, x, y, DegtoRad(Angle(x, y, cage->X, cage->Y)), 75, ghost->WeaponDamage, SPR_BANEBOSS_SHOT1, SFX_BANEBOSS_SHOT, EWF_UNBLOCKABLE);
								e->Rotation = RadtoDeg(e->Angle);
								RunEWeaponScript(e, "SpeedChange", {40, 450*EasyModeMultiplier(0.9), SPR_BANEBOSS_SHOT2});
							}
						}
						else if(attack==7){
							if(i%16==0){
								j = (i/16)%7;
								if(j==6){
									skullDir = -skullDir;
								}
								else if(j<4){
									ang = Angle(cage->X, cage->Y, Link->X, Link->Y);
									x = Link->X+VectorX(24*skullDir*EasyModeMultiplier(0.5), ang);
									y = Link->Y+VectorY(24*skullDir*EasyModeMultiplier(0.5), ang);
									e = FireEWeapon(LW_SCRIPT10, x, y, 0, 0, ghost->WeaponDamage, SPRITE_INVISIBLE, 0, EWF_UNBLOCKABLE);
									RunEWeaponEffect(e, "WavySkull", {40+EasyModeFrames(16), 32, 8, 5, 4});
								}
							}
						}
						else if(attack==8){
							int freq = 40;
							if(IsEasyMode())
								freq = 60;
							if(i%freq==0){
								ang = Rand(360);
								x = cage->X+VectorX(96, ang);
								y = cage->Y+VectorY(96, ang);
								for(j=0; j<360&&!InScreen(x, y, 16, 16, true); ++j){
									ang = Rand(360);
									x = cage->X+VectorX(96, ang);
									y = cage->Y+VectorY(96, ang);
								}
								e = FireAimedEWeapon(EW_LUNAR, x, y, 0, 150, ghost->WeaponDamage, SPR_BANEBOSS_SHOT1, SFX_BANEBOSS_SHOT, EWF_UNBLOCKABLE);
								e->Rotation = RadtoDeg(e->Angle);
								RunEWeaponScript(e, "SpeedChange", {24, 450*EasyModeMultiplier(0.9), SPR_BANEBOSS_SHOT2});
							}
						}
					}
					BB_Waitframe(this, ghost, vars, 1);
				}
				vars[CHARGEANIM] = 0;
				Ghost_Data = combo;
				Ghost_Dir = DIR_DOWN;
				if(Screen->D[D_ESANSUPERATTACK]==2){
					BB_Waitframe(this, ghost, vars, 64);
					Ghost_Data = combo+20;
					Game->PlaySound(78);
					for(i=0; i<16; ++i){
						if(i==8)
							Screen->D[D_ESANSUPERATTACK] = 3;
						Screen->Circle(4, Ghost_X+8+Rand(-2, 2), Ghost_Y+8+Rand(-2, 2), Lerp(0, 32, i/15)+((G[G_ANIM]%6)<4?0:8), Choose(0x81, 0x82, 0x83, 0x84, 0x85), 1, 0, 0, 0, true, 128);
						BB_Waitframe(this, ghost, vars, 1);
					}
					BB_Waitframe(this, ghost, vars, 32);
					Ghost_Data = combo;
					BB_Waitframe(this, ghost, vars, 96);
				}
				vars[LOCKHP] = 0;
				Screen->D[D_ESANSUPERATTACK] = 0;
			}
			
			if(false){
				Ghost_FaceLink(ghost);
				Ghost_Data = combo+8;
				BB_Waitframe(this, ghost, vars, 16);
				Game->PlaySound(78);
				x = Ghost_X+VectorX(Ghost_Dir, 8);
				y = Ghost_Y+VectorY(Ghost_Dir, 8);
				i = 0;
				while(Distance(x, y, Link->X, Link->Y)>4){
					++i;
					if(i>16)
						Ghost_Data = combo;
					if(i%2==0)
						ParticleAnim(x+Rand(-3, 3), y+Rand(-3, 3), Choose(54600, 54620), 8, 4, 2);
					ang = Angle(x, y, Link->X, Link->Y);
					x += VectorX(4, ang);
					y += VectorY(4, ang);
					BB_Waitframe(this, ghost, vars, 1);
				}
				e = CreateEWeaponAt(EW_SCRIPT10, Link->X, Link->Y);
				e->CollDetection = false;
				e->Step = 0;
				e->DrawYOffset = -1000;
				RunEWeaponScript(e, "BloodMoonCage", {16, Choose(32, 48, 64), 32, 144, 8});
				Ghost_Data = combo;
				BB_Waitframe(this, ghost, vars, 64);
			}
			BB_Waitframe(this, ghost, vars, 32+EasyModeFrames(32));
		}
	}
	void BB_JumpToPos(ffc this, npc ghost, int vars, int tX, int tY, int frames){
		int combo = ghost->Attributes[10];
		Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, tX, tY));
		Ghost_Jump = FindJumpLength(frames, true);
		Game->PlaySound(SFX_JUMP);
		int dist = Distance(Ghost_X, Ghost_Y, tX, tY);
		Ghost_Data = combo+4;
		for(int i=0; i<frames; ++i){
			int ang = Angle(Ghost_X, Ghost_Y, tX, tY);
			Ghost_X += VectorX(dist/frames, ang);
			Ghost_Y += VectorY(dist/frames, ang);
			BB_Waitframe(this, ghost, vars, 1);
		}
		Ghost_Data = combo;
		Ghost_X = tX;
		Ghost_Y = tY;
	}
	void BB_Sword(int til, int ang, int dist, int op){
		int x = Ghost_X-8+VectorX(8+dist, ang);
		int y = Ghost_Y-Ghost_Z+VectorY(8+dist, ang);
		switch(op){
			case 128:
				Screen->DrawTile(2, x, y, til, 2, 1, 0, -1, -1, x, y, ang, 0, true, 128);
				break;
			case 96:
				Screen->DrawTile(2, x, y, til, 2, 1, 0, -1, -1, x, y, ang, 0, true, 64);
				Screen->DrawTile(2, x, y, til, 2, 1, 0, -1, -1, x, y, ang, 0, true, 64);
				break;
			case 64:
				Screen->DrawTile(2, x, y, til, 2, 1, 0, -1, -1, x, y, ang, 0, true, 64);
				break;
		}
		if(Ghost_Z==0){
			for(int i=0; i<2; ++i){
				x = Ghost_X+VectorX(dist+16*i, ang);
				y = Ghost_Y+VectorY(dist+16*i, ang);
				MakeHitbox(EW_SCRIPT10, x, y, 16, 16, DAMAGE_BANESWORD);
			}
		}
	}
	void BB_Waitframe(ffc this, npc ghost, untyped vars, int frames){
		for(int i=0; i<frames; ++i){
			if(vars[LOCKHP]){
				Ghost_HP = vars[LOCKHP];
				ghost->HP = vars[LOCKHP];
				ghost->Misc[NPCM_FLAGS] |= NPCMF_NODAMAGENUMBERS;
				G[G_GRAYHEALTHBAR] = 1;
			}
			if(vars[CHARGEANIM]){
				Screen->Circle(4, Ghost_X+10+Rand(-2, 2), Ghost_Y+5+Rand(-2, 2), Rand(3, 5)+(G[G_ANIM]%6)<4?0:4, Choose(0x83, 0x84, 0x85), 1, 0, 0, 0, true, 64);
				Screen->Circle(4, Ghost_X+10+Rand(-2, 2), Ghost_Y+5+Rand(-2, 2), Rand(3, 5)+(G[G_ANIM]%6)<4?0:4+2, Choose(0x83, 0x84, 0x85), 1, 0, 0, 0, false, 64);
			}
			Ghost_Waitframe(this, ghost);
		}
	}
}

ffc script BaneBossNPCs{
	void run(int id, npc boss){
		int x; int y;
		int tX;
		int tY;
		int dir;
		if(boss->X<120){
			x = -16;
			y = 88+Rand(-16, 16);
			tX = boss->X+16;
			tY = boss->Y;
			dir = DIR_RIGHT;
			G[G_PASSIVESTRINGNAMESIDE] = 1;
		}
		else{
			x = 256;
			y = 88+Rand(-16, 16);
			tX = boss->X-16;
			tY = boss->Y;
			dir = DIR_LEFT;
			G[G_PASSIVESTRINGNAMESIDE] = 0;
		}

		int cmb;
		int atkcmb;
		switch(id){
			case 0: //Terry
				PlayStringCustom("Hands off my bro, ya bloody creep!", "Terry", 0, 0, 16, 128, true);
				cmb = 33556;
				atkcmb = 33788;
				break;
			case 1: //Soren
				PlayStringCustom("Yo, Asher! Could you use a hand?", "Soren", 0, 0, 16, 128, true);
				cmb = 33832;
				atkcmb = 33916;
				break;
			case 2: //Micah
				PlayStringCustom("Esan, buddy! Give Selet my regards!", "Micah", 0, 0, 16, 128, true);
				cmb = 33896;
				atkcmb = 33904;
				break;
		}
		
		int jump = 2.4;
		int z = 0;
		int t = FindJumpLength(jump, false);
		int dist = Distance(x, y, tX, tY);
		Game->PlaySound(SFX_JUMP);
		for(int i=0; i<t; ++i){
			jump = Clamp(jump-0.16, -3.2, 3.2);
			z += jump;
			int ang = Angle(x, y, tX, tY);
			x += VectorX(dist/t, ang);
			y += VectorY(dist/t, ang);
			Screen->FastCombo(2, x, y, 107, 7, 64);
			Screen->DrawCombo(4, x, y-z-16, cmb+4+dir, 1, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 128);
			Waitframe();
		}
		dir = OppositeDir(dir);
		for(int i=0; i<64; ++i){
			Screen->DrawCombo(4, x, y-16, cmb+4+dir, 1, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 128);
			Waitframe();
		}
		Game->PlaySound(SFX_SWORD);
		Screen->D[D_ESANSUPERATTACK] = 2;
		for(int i=0; i<32; ++i){
			if(i<4)
				x += DirX(dir, 1);
			if(i==4)
				Game->PlaySound(SFX_EHIT);
			Screen->DrawCombo(4, x, y-16, atkcmb+dir, 1, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 128);
			Waitframe();
		}
		while(Screen->D[D_ESANSUPERATTACK]==2){
			Screen->DrawCombo(4, x, y-16, cmb+dir, 1, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 128);
			Waitframe();
		}
		while(Distance(x, y, 120, 80)>4){
			int ang = Angle(x, y, 120, 80);
			x += VectorX(4, ang);
			y += VectorY(4, ang);
			Screen->DrawCombo(4, x, y-16, atkcmb+dir, 1, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 128);
			Waitframe();
		}
		ParticleAnim(x, y, 97);
		Game->PlaySound(SFX_FALL);
		Waitframes(64);
		switch(id){
			case 0: //Terry
				PlayStringCustom("Foolishness!", "Esan", 0, 0, 16, 128, true);
				break;
			case 1: //Soren
				PlayStringCustom("Fall!", "Esan", 0, 0, 16, 128, true);
				break;
			case 2: //Micah
				PlayStringCustom("Micah, you traitor-", "Esan", 0, 0, 16, 128, true);
				break;
		}
	}
}

namespace NightmareSelet{
	const int BUFFER 			= 0;
	const int STARBITMAP 		= 1;
	const int STARBITMAP2		= 2;
	const int PREPBITMAP		= 3;
	const int HEADSTATE 		= 4;
	const int HEADANGLE 		= 5;
	const int LHAND_X 			= 6;
	const int LHAND_Y 			= 7;
	const int LHAND_ANG 		= 8;
	const int LHAND_STATE 		= 9;
	const int RHAND_X 			= 10;
	const int RHAND_Y 			= 11;
	const int RHAND_ANG 		= 12;
	const int RHAND_STATE 		= 13;
	const int TENTACLEFRAMES	= 14;
	const int TENTACLEASPEED	= 15;
	const int TENTACLESKIP		= 16;
	const int SPECIALDRAW		= 17;
	const int DRAWSCALE			= 18;
	const int DRAWROTATE		= 19;
	const int DRAWLAYER			= 20;
	const int SHAKETIMER		= 21;
	const int SHAKEINTENSITY	= 22;
	const int LHAND_CASTING     = 23;
	const int RHAND_CASTING     = 24;
	const int HEADTIMER			= 25;
	const int HEADTARGETSTATE	= 26;
	const int LHAND_SUBSTATE	= 27;
	const int RHAND_SUBSTATE	= 28;
	const int LHAND_TARGETSUB 	= 29;
	const int RHAND_TARGETSUB	= 30;
	const int LHAND_TIMER		= 31;
	const int RHAND_TIMER		= 32;
	const int TENTACLEAMULT     = 33;
	const int FACECRACKED       = 34;
	const int HEADDRAWOVER		= 35;
	const int HANDSDRAWOVER     = 36;
	const int SHAKEX            = 37;
	const int SHAKEY            = 38;
	const int TAILCLIPOFFSET    = 39;
	const int HEADXOFF 			= 40;
	const int HEADYOFF			= 41;
	
	const int SD_FG			= 0;
	const int SD_FLIP		= 1;
	const int SD_BG			= 2;
	const int SD_BLACKOUT	= 3;
	const int SD_FLIPBLACKOUT = 4;
	
	const int HAND_OPENBACK = 0;
	const int HAND_FIST = 1;
	const int HAND_OPENFRONT = 2;
	const int HAND_CLAW = 3;
	const int HAND_GRAB = 4;
	
	void UnevenArc(bitmap b, int layer, int x, int y, int rad1, int rad2, int ang1, int ang2, int c, int op){
		int verts[128];
		verts[0] = x;
		verts[1] = y;
		for(int i=0; i<16; ++i){
			verts[2+2*i+0] = x+VectorX(Lerp(rad1, rad2, i/15), Lerp(ang1, ang2, i/15));
			verts[2+2*i+1] = y+VectorY(Lerp(rad1, rad2, i/15), Lerp(ang1, ang2, i/15));
		}
		b->Polygon(layer, 16, verts, c, 128);
	}
	
	void Rotate(int xy, int cx, int cy, int w, int h, int r){
		if(r==0)
			return;
		
		cx -= w/2;
		cy -= h/2;
		
		int distance = LargeDistance(cx, cy, xy[0], xy[1], 10);
		int angle = Angle(cx, cy, xy[0], xy[1]);

		xy[0] = cx+VectorX(distance, angle+r);
		xy[1] = cy+VectorY(distance, angle+r);
	}

	void TentacleLong(bitmap b, int x1, int y1, int x2, int y2, int frame, int cset, int tileW){
		int ang = Angle(x1, y1, x2, y2);
		int dist = Distance(x1, y1, x2, y2);
		switch(tileW){
			case 2:
				int x = x1-dist/2+VectorX(dist/2, ang);
				int y = y1-16+VectorY(dist/2, ang);
				int til = 117780+40*Floor(frame/10)+2*(frame%10);
				b->DrawTile(0, x, y, til, 2, 2, cset, dist, 32, x, y, ang, 0, true, 128);
				break;
			case 3:
				int x = x1-dist/2+VectorX(dist/2, ang);
				int y = y1-16+VectorY(dist/2, ang);
				int til = 118300+40*Floor(frame/5)+4*(frame%5);
				b->DrawTile(0, x, y, til, 3, 2, cset, dist, 32, x, y, ang, 0, true, 128);
				break;
			case 4:
				int x = x1-dist/2+VectorX(dist/2, ang);
				int y = y1-16+VectorY(dist/2, ang);
				int til = 119080+40*Floor(frame/5)+4*(frame%5);
				b->DrawTile(0, x, y, til, 4, 2, cset, dist, 32, x, y, ang, 0, true, 128);
				break;
		}
	}
	void TentacleLong2(bitmap b, int x1, int y1, int dist, int ang, int frame, int cset, int tileW){
		int x2 = x1+VectorX(dist, ang);
		int y2 = y1+VectorY(dist, ang);
		TentacleLong(b, x1, y1, x2, y2, frame, cset, tileW);
	}
	
	void ScreenTentacleLong(int layer, int x1, int y1, int x2, int y2, int frame, int cset, int tileW){
		int ang = Angle(x1, y1, x2, y2);
		int dist = Distance(x1, y1, x2, y2);
		switch(tileW){
			case 2:
				int x = x1-dist/2+VectorX(dist/2, ang);
				int y = y1-16+VectorY(dist/2, ang);
				int til = 117780+40*Floor(frame/10)+2*(frame%10);
				Screen->DrawTile(layer, x, y, til, 2, 2, cset, dist, 32, x, y, ang, 0, true, 128);
				break;
			case 3:
				int x = x1-dist/2+VectorX(dist/2, ang);
				int y = y1-16+VectorY(dist/2, ang);
				int til = 118300+40*Floor(frame/5)+4*(frame%5);
				Screen->DrawTile(layer, x, y, til, 3, 2, cset, dist, 32, x, y, ang, 0, true, 128);
				break;
			case 4:
				int x = x1-dist/2+VectorX(dist/2, ang);
				int y = y1-16+VectorY(dist/2, ang);
				int til = 119080+40*Floor(frame/5)+4*(frame%5);
				Screen->DrawTile(layer, x, y, til, 4, 2, cset, dist, 32, x, y, ang, 0, true, 128);
				break;
		}
	}
	void ScreenTentacleLong2(int layer, int x1, int y1, int dist, int ang, int frame, int cset, int tileW){
		int x2 = x1+VectorX(dist, ang);
		int y2 = y1+VectorY(dist, ang);
		ScreenTentacleLong(layer, x1, y1, x2, y2, frame, cset, tileW);
	}

	
	float LerpAngle(int a1, int a2, int percent){
		int diff = a2-a1;
		while(diff<0)
			diff += 360;
		return Lerp(a1, a1+diff, percent);
	}
	
	int Lerp3(int start, int middle, int end, int i){
		if(i<0.5)
			return Lerp(start, middle, i*2);
		else
			return Lerp(middle, end, (i-0.5)*2);
	}

	int HandFrame(int state){
		switch(state){
			case 0: //Open, back
				return 117660;
			case 1: //Fist, back
				return 117700;
			case 2: //Open, front
				return 117662;
			case 3: //Claw, front
				return 117702;
			case 4: //Grab Ledge
				return 117747;
		}
	}
	
	bool PalmVisible(int state){
		switch(state){
			case HAND_OPENFRONT:
			case HAND_CLAW:
			case HAND_GRAB:
				return true;
		}
		return false;
	}

	int HandYOff(int state){
		switch(state){
			case 0: //Open, back
			case 1: //Fist, back
				return 8;
			case 2: //Open, front
			case 3: //Claw, front
			case 4: //Grab Ledge
				return -8;
		}
	}

	void DrawNightmareSelet1(untyped nsd){
		bitmap nsBuf = nsd[BUFFER];
		
		int tentacleFrames = nsd[TENTACLEFRAMES];
		int tentacleASpeed = nsd[TENTACLEASPEED];
		int tentacleSkip = nsd[TENTACLESKIP];
		
		nsBuf->Clear(0);
		
		int i; int j; int k;
		int til; 
		int x; int y;
		int x2; int y2;
		int ang;
		int xy[2];
		
		int bodyX = 256-32;
		int bodyY = 256-32;
		
		int rX = 256;
		int rY = 256;
		
		int offY = 0;
		if(nsd[SPECIALDRAW]==SD_FLIP||nsd[SPECIALDRAW]==SD_FLIPBLACKOUT)
			offY += 64;
		
		int shakeX = 0;
		int shakeY = 0;
		if(nsd[SHAKETIMER]){
			i = Ceiling(Lerp(0, nsd[SHAKEINTENSITY], nsd[SHAKETIMER]/31));
			shakeX = Rand(-i, i);
			shakeY = Rand(-i, i);
			--nsd[SHAKETIMER];
		}
		nsd[SHAKEX] = shakeX;
		nsd[SHAKEY] = shakeY;
		
		int angLeft = Angle(bodyX+32, bodyY+8, bodyX+32+nsd[LHAND_X], bodyY+nsd[LHAND_Y]+8);
		int angRight = Angle(bodyX+32, bodyY+8, bodyX+32+nsd[RHAND_X], bodyY+nsd[RHAND_Y]+8);
		int distLeft = Distance(bodyX+32, bodyY+8, bodyX+32+nsd[LHAND_X], bodyY+nsd[LHAND_Y])+32;
		int distRight = Distance(bodyX+32, bodyY+8, bodyX+32+nsd[RHAND_X], bodyY+nsd[RHAND_Y])+32;
		
		//Body
		if(nsd[SPECIALDRAW]==SD_FLIP||nsd[SPECIALDRAW]==SD_FLIPBLACKOUT){
			for(i=0; i<5; ++i){
				j = Lerp3(64, 96, 64, i/4);
				xy[0] = bodyX+32;
				xy[1] = bodyY-16+offY;
				Rotate(xy, rX, rY, 0, 0, nsd[DRAWROTATE]);
				TentacleLong2(nsBuf, xy[0], xy[1], j, LerpAngle(75, 115, i/4)+180+nsd[DRAWROTATE], tentacleFrames[28+i], 0, 4);
			}
			for(i=0; i<=20; ++i){
				j = Lerp3(distLeft, 56, distRight, i/20);
				xy[0] = bodyX+32;
				xy[1] = bodyY+offY;
				Rotate(xy, rX, rY, 0, 0, nsd[DRAWROTATE]);
				TentacleLong2(nsBuf, xy[0], xy[1], j, LerpAngle(angLeft, angRight, i/20)+nsd[DRAWROTATE], tentacleFrames[7+i], 1, 4);
			}
		}
		else{
			for(i=0; i<5; ++i){
				j = Lerp3(64, 96, 64, i/4);
				xy[0] = bodyX+32;
				xy[1] = bodyY+16+offY;
				Rotate(xy, rX, rY, 0, 0, nsd[DRAWROTATE]);
				TentacleLong2(nsBuf, xy[0], xy[1], j, LerpAngle(75, 115, i/4)+nsd[DRAWROTATE], tentacleFrames[28+i], 0, 4);
			}
			if(nsd[SPECIALDRAW]==SD_FG){
				xy[0] = bodyX+32;
				xy[1] = bodyY+88+offY;
				Rotate(xy, rX, rY, 0, 0, nsd[DRAWROTATE]);
				nsBuf->Rectangle(0, xy[0]-40, xy[1]-24+nsd[TAILCLIPOFFSET], xy[0]+40, xy[1]+24, 0x00, 1, xy[0], xy[1], nsd[DRAWROTATE], true, 128);
				//nsBuf->Rectangle(0, bodyX-8, bodyY+64, bodyX+64+8, bodyY+64+48, 0x00, 1, 0, 0, 0, true, 128);
				for(i=0; i<8; ++i){
					xy[0] = Lerp(bodyX+8, bodyY+63-8, i/7)+Rand(-2, 2);
					xy[1] = bodyY+64+Rand(-2, 2)+nsd[TAILCLIPOFFSET]+offY;
					Rotate(xy, rX, rY, 0, 0, nsd[DRAWROTATE]);
					nsBuf->Circle(0, xy[0], xy[1], Lerp3(0.5, 1, 0.5, i/7)*Rand(6, 10), 0x0F, 1, 0, 0, 0, true, 128);
				}
			}
			for(i=0; i<=20; ++i){
				j = Lerp3(distRight, 56, distLeft, i/20);
				xy[0] = bodyX+32;
				xy[1] = bodyY+offY;
				Rotate(xy, rX, rY, 0, 0, nsd[DRAWROTATE]);
				TentacleLong2(nsBuf, xy[0], xy[1], j, LerpAngle(angRight, angLeft, i/20)+nsd[DRAWROTATE], tentacleFrames[7+i], 1, 4);
			}
		}
		
		//Head
		x = bodyX+16+VectorX(8, nsd[HEADANGLE])+nsd[HEADXOFF];
		y = bodyY-24-8+VectorY(8, nsd[HEADANGLE])+nsd[HEADYOFF];
		for(i=0; i<5; ++i){
			ang = nsd[HEADANGLE]-180+Lerp(-60, 60, i/4);
			x2 = x+VectorX(-8, nsd[HEADANGLE])+VectorX(20, ang);
			y2 = y+8+VectorY(-8, nsd[HEADANGLE])+VectorY(20, ang);
			j = tentacleFrames[i];
			til = 117780+40*Floor(j/10)+2*(j%10);
			xy[0] = x2+shakeX;
			xy[1] = y2+offY+shakeY;
			Rotate(xy, rX, rY, 32, 32, nsd[DRAWROTATE]);
			nsBuf->DrawTile(0, xy[0], xy[1], til, 2, 2, 0, -1, -1, xy[0], xy[1], ang+nsd[DRAWROTATE], 0, true, 128);
		}
		xy[0] = x+shakeX;
		xy[1] = y+offY+shakeY;
		Rotate(xy, rX, rY, 32, 48, nsd[DRAWROTATE]);
		nsBuf->DrawTile(0, xy[0], xy[1], 117520+nsd[FACECRACKED]*2, 2, 3, 0, -1, -1, xy[0], xy[1], nsd[HEADANGLE]-90+nsd[DRAWROTATE], 0, true, 128);
		if(nsd[HEADSTATE]){
			if(nsd[FACECRACKED]==4)
				nsBuf->DrawTile(0, xy[0], xy[1], 117580+nsd[HEADSTATE]*2, 2, 3, 0, -1, -1, xy[0], xy[1], nsd[HEADANGLE]-90+nsd[DRAWROTATE], 0, true, 128);
			else
				nsBuf->DrawTile(0, xy[0], xy[1], 117534+(nsd[HEADSTATE]-1)*2, 2, 3, 0, -1, -1, xy[0], xy[1], nsd[HEADANGLE]-90+nsd[DRAWROTATE], 0, true, 128);
		}
		//Hands
		x2 = 0;
		y2 = HandYOff(nsd[LHAND_STATE]);
		til = HandFrame(nsd[LHAND_STATE]);
		x = bodyX+32+nsd[LHAND_X]-16+VectorX(y2, nsd[LHAND_ANG]+90)+VectorX(x2, nsd[LHAND_ANG]);
		y = bodyY+nsd[LHAND_Y]-16+VectorY(y2, nsd[LHAND_ANG]+90)+VectorY(x2, nsd[LHAND_ANG]);
		xy[0] = x+shakeX;
		xy[1] = y+offY+shakeY;
		Rotate(xy, rX, rY, 32, 32, nsd[DRAWROTATE]);
		if(nsd[LHAND_CASTING]==1)
			nsBuf->Circle(0, xy[0]+16+Rand(-2, 2), xy[1]+16+Rand(-2, 2), (G[G_ANIM]%6<4)?16:24+Rand(2), Choose(0x71, 0x76, 0x77, 0x78), 1, 0, 0, 0, true, 128);
		nsBuf->DrawTile(0, xy[0], xy[1], til, 2, 2, 0, -1, -1, xy[0], xy[1], nsd[LHAND_ANG]+90+nsd[DRAWROTATE], 0, true, 128);
		if(nsd[LHAND_SUBSTATE]&&PalmVisible(nsd[LHAND_STATE]))
			nsBuf->DrawTile(0, xy[0], xy[1], 117594+nsd[LHAND_SUBSTATE]*2-2, 2, 2, 0, -1, -1, xy[0], xy[1], nsd[LHAND_ANG]+90+nsd[DRAWROTATE], 0, true, 128);
		if(nsd[LHAND_CASTING]==2)
			nsBuf->Circle(0, xy[0]+16+Rand(-2, 2), xy[1]+16+Rand(-2, 2), (G[G_ANIM]%6<4)?8:12+Rand(2), Choose(0x71, 0x76, 0x77, 0x78), 1, 0, 0, 0, true, 128);
		
		x2 = 0;
		y2 = HandYOff(nsd[RHAND_STATE]);
		til = HandFrame(nsd[RHAND_STATE]);
		x = bodyX+32+nsd[RHAND_X]-16+VectorX(y2, nsd[RHAND_ANG]+90)+VectorX(x2, nsd[RHAND_ANG]);
		y = bodyY+nsd[RHAND_Y]-16+VectorY(y2, nsd[RHAND_ANG]+90)+VectorY(x2, nsd[RHAND_ANG]);
		xy[0] = x+shakeX;
		xy[1] = y+offY+shakeY;
		Rotate(xy, rX, rY, 32, 32, nsd[DRAWROTATE]);
		if(nsd[RHAND_CASTING]==1)
			nsBuf->Circle(0, xy[0]+16+Rand(-2, 2), xy[1]+16+Rand(-2, 2), (G[G_ANIM]%6<4)?16:24+Rand(2), Choose(0x71, 0x76, 0x77, 0x78), 1, 0, 0, 0, true, 128);
		nsBuf->DrawTile(0, xy[0], xy[1], til, 2, 2, 0, -1, -1, xy[0], xy[1], nsd[RHAND_ANG]+90+nsd[DRAWROTATE], 2, true, 128);
		if(nsd[RHAND_SUBSTATE]&&PalmVisible(nsd[RHAND_STATE]))
			nsBuf->DrawTile(0, xy[0], xy[1], 117594+nsd[RHAND_SUBSTATE]*2-2, 2, 2, 0, -1, -1, xy[0], xy[1], nsd[RHAND_ANG]+90+nsd[DRAWROTATE], 2, true, 128);
		if(nsd[RHAND_CASTING]==2)
			nsBuf->Circle(0, xy[0]+16+Rand(-2, 2), xy[1]+16+Rand(-2, 2), (G[G_ANIM]%6<4)?8:12+Rand(2), Choose(0x71, 0x76, 0x77, 0x78), 1, 0, 0, 0, true, 128);
		
		for(i=0; i<48; ++i){
			int aSpeed = tentacleASpeed[i];
			aSpeed = Ceiling(aSpeed*nsd[TENTACLEAMULT]);
			if(G[G_ANIM]%tentacleSkip[i]==0)
				tentacleFrames[i] = (tentacleFrames[i]+aSpeed)%90;
			tentacleFrames[i] = (tentacleFrames[i]+aSpeed)%90;
		}
	}

	void DrawNightmareSelet2(untyped nsd, int x, int y){
		int x2; int y2; int x3; int y3;
		int xy[2];
		int til;
		
		bitmap nsBuf = nsd[BUFFER];
		bitmap starBG = nsd[STARBITMAP];
		bitmap starBG2 = nsd[STARBITMAP2];
		bitmap prep = nsd[PREPBITMAP];
		
		int srcW = 256;
		int srcH = 176;
		int srcX = 224;
		int srcY = 224;
		
		if(nsd[DRAWSCALE]!=1){
			srcW /= nsd[DRAWSCALE];
			srcH /= nsd[DRAWSCALE];
		}
		
		srcX = 256 - (32+x) / nsd[DRAWSCALE];
		srcY = 256 - (32+y) / nsd[DRAWSCALE];
		
		// if(nsd[SPECIALDRAW]==SD_BG){
			// SafeBlit(nsBuf, prep, 0, srcX, srcY, srcW, srcH, 0, 0, 256, 176, 0, true);
			// prep->ReplaceColors(0, 0x1E, 0x00, 0x00);
			// prep->ReplaceColors(0, 0x00, 0x1F, 0x1F);
			// starBG->Blit(0, starBG2, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
			// starBG2->MaskedDraw(0, prep, 0x00);
			// SafeBlit(nsBuf, RT_SCREEN, nsd[DRAWLAYER], srcX, srcY, srcW, srcH, 0, 0, 256, 176, 0, true);
			// starBG2->Blit(nsd[DRAWLAYER], RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
		// }
		if(nsd[SPECIALDRAW]==SD_BLACKOUT||nsd[SPECIALDRAW]==SD_FLIPBLACKOUT){
			prep->Clear(0);
			SafeBlit(nsBuf, prep, 0, srcX, srcY, srcW, srcH, 0, 0, 256, 176, 0, false);
			//nsBuf->Blit(0, prep, srcX, srcY, srcW, srcH, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
			prep->ReplaceColors(0, 0x0F, 0x01, 0xBF);
			prep->Blit(nsd[DRAWLAYER], RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
		}
		else{
			SafeBlit(nsBuf, prep, 0, srcX, srcY, srcW, srcH, 0, 0, 256, 176, 0, true);
			//nsBuf->Blit(0, prep, srcX, srcY, srcW, srcH, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
			prep->ReplaceColors(0, 0x1E, 0x00, 0x00);
			prep->ReplaceColors(0, 0x00, 0x1F, 0x1F);
			starBG->Blit(0, starBG2, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
			starBG2->MaskedDraw(0, prep, 0x00);
			SafeBlit(nsBuf, RT_SCREEN, nsd[DRAWLAYER], srcX, srcY, srcW, srcH, 0, 0, 256, 176, 0, true);
			//nsBuf->Blit(layer, RT_SCREEN, srcX, srcY, srcW, srcH, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
			starBG2->Blit(nsd[DRAWLAYER], RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
		}
		
		int offY;
		if(nsd[SPECIALDRAW]==SD_FLIP||nsd[SPECIALDRAW]==SD_FLIPBLACKOUT)
			offY += 64;
		
		int rX = x+32;
		int rY = y+32;
		
		if(nsd[HANDSDRAWOVER]){
			x2 = 0;
			y2 = HandYOff(nsd[LHAND_STATE]);
			til = HandFrame(nsd[LHAND_STATE]);
			if(til==117747)
				til = 117749;
			if(nsd[LHAND_STATE]!=HAND_OPENBACK&&nsd[LHAND_STATE]!=HAND_GRAB)
				til = 0;
			x3 = x+32+nsd[LHAND_X]-16+VectorX(y2, nsd[LHAND_ANG]+90)+VectorX(x2, nsd[LHAND_ANG]);
			y3 = y+nsd[LHAND_Y]-16+VectorY(y2, nsd[LHAND_ANG]+90)+VectorY(x2, nsd[LHAND_ANG]);
			xy[0] = x3+nsd[SHAKEX];
			xy[1] = y3+offY+nsd[SHAKEY];
			Rotate(xy, rX, rY, 32, 32, nsd[DRAWROTATE]);
			if(til)
				Screen->DrawTile(nsd[HANDSDRAWOVER], xy[0], xy[1], til, 2, 2, 0, -1, -1, xy[0], xy[1], nsd[LHAND_ANG]+90+nsd[DRAWROTATE], 0, true, 128);
			
			x2 = 0;
			y2 = HandYOff(nsd[RHAND_STATE]);
			til = HandFrame(nsd[RHAND_STATE]);
			if(til==117747)
				til = 117749;
			if(nsd[RHAND_STATE]!=HAND_OPENBACK&&nsd[RHAND_STATE]!=HAND_GRAB)
				til = 0;
			x3 = x+32+nsd[RHAND_X]-16+VectorX(y2, nsd[RHAND_ANG]+90)+VectorX(x2, nsd[RHAND_ANG]);
			y3 = y+nsd[RHAND_Y]-16+VectorY(y2, nsd[RHAND_ANG]+90)+VectorY(x2, nsd[RHAND_ANG]);
			xy[0] = x3+nsd[SHAKEX];
			xy[1] = y3+offY+nsd[SHAKEY];
			Rotate(xy, rX, rY, 32, 32, nsd[DRAWROTATE]);
			if(til)
				Screen->DrawTile(nsd[HANDSDRAWOVER], xy[0], xy[1], til, 2, 2, 0, -1, -1, xy[0], xy[1], nsd[RHAND_ANG]+90+nsd[DRAWROTATE], 2, true, 128);
		}
		
		if(nsd[HEADDRAWOVER]){
			x3 = x+16+VectorX(8, nsd[HEADANGLE]);
			y3 = y-24-8+VectorY(8, nsd[HEADANGLE]);
			xy[0] = x3+nsd[SHAKEX];
			xy[1] = y3+offY+nsd[SHAKEY];
			Rotate(xy, rX, rY, 32, 48, nsd[DRAWROTATE]);
			Screen->DrawTile(nsd[HEADDRAWOVER], xy[0], xy[1], 117520+nsd[FACECRACKED]*2, 2, 3, 0, -1, -1, xy[0], xy[1], nsd[HEADANGLE]-90+nsd[DRAWROTATE], 0, true, 128);
			if(nsd[HEADSTATE]){
				if(nsd[FACECRACKED]==4)
					Screen->DrawTile(nsd[HEADDRAWOVER], xy[0], xy[1], 117580+nsd[HEADSTATE]*2, 2, 3, 0, -1, -1, xy[0], xy[1], nsd[HEADANGLE]-90+nsd[DRAWROTATE], 0, true, 128);
				else
					Screen->DrawTile(nsd[HEADDRAWOVER], xy[0], xy[1], 117534+(nsd[HEADSTATE]-1)*2, 2, 3, 0, -1, -1, xy[0], xy[1], nsd[HEADANGLE]-90+nsd[DRAWROTATE], 0, true, 128);
			}
		}
	}
	//nsBuf->Blit(layer, RT_SCREEN, srcX, srcY, srcW, srcH, posX, posY, srcW*scale, srcH*scale, 0, 0, 0, 0, 0, true);

	const int _DAMAGE_NIGHTMARESELET_COSMICSUN = 6;
	const int _DAMAGE_NIGHTMARESELET_FIREBALLS = 4;
	const int _DAMAGE_NIGHTMARESELET_SLASH = 4.1;
	const int _DAMAGE_NIGHTMARESELET_LASER = 4.2;
	const int _DAMAGE_NIGHTMARESELET_LIGHTNING = 6.1;
	const int _DAMAGE_NIGHTMARESELET_ASTEROIDS = 4.3;
	const int _DAMAGE_NIGHTMARESELET_SPIKES = 4.4;
	const int _DAMAGE_NIGHTMARESELET_ARROWS = 2;
	const int _DAMAGE_NIGHTMARESELET_MEGALASER = 8;
	
	const int HP_NIGHTMARESELET_PHASE1 = 7000;
	const int HP_NIGHTMARESELET_PHASE2 = 4000;
	const int HP_NIGHTMARESELET_METEOR = 3000;
	const int HP_NIGHTMARESELET_PHASE3 = 4000;
	const int HP_NIGHTMARESELET_PHASE3B = 8000;
	
	const int SPR_COSMICBALL = 112;
	const int SPR_COSMICBALL2 = 115;
	
	const int NPC_NIGHTMARESELETSUMMON = 248;
	
	const int SFX_COSMICBALL = 93;
	const int SFX_NIGHTMARESELET_SWOOSH = 139;
	const int SFX_NIGHTMARESELET_SWOOSH2 = 140;
	const int SFX_NIGHTMARESELET_MASKCRACK = 105;
	const int SFX_NIGHTMARESELET_MASKSMASH = 79;
	
	const int D_EGGCONTROL = 0;
	const int D_EGGCOMBO = 1;
	const int D_EGGFREEZE = 2;
	const int D_STARSBITMAP = 3; //Oh I hate this. Ghost.zh was a mistake
	const int D_EGGPHASE = 4;
		
		
	bool IsSP(){
		return G[G_SLEEPPARALYSISSELET];
	}
	
	int SPFrames(int frames){
		if(IsSP())
			return frames;
		return 0;
	}
	
	int NSDamage(int dmg){
		switch(dmg){
			case _DAMAGE_NIGHTMARESELET_COSMICSUN:
				if(IsSP())
					dmg += 2;
				break;
			case _DAMAGE_NIGHTMARESELET_FIREBALLS:
				if(IsSP())
					dmg += 2;
				break;
			case _DAMAGE_NIGHTMARESELET_SLASH:
				if(IsSP())
					dmg += 2;
				break;
			case _DAMAGE_NIGHTMARESELET_LASER:
				if(IsSP())
					dmg += 2;
				break;
			case _DAMAGE_NIGHTMARESELET_LIGHTNING:
				if(IsSP())
					dmg += 2;
				break;
			case _DAMAGE_NIGHTMARESELET_ASTEROIDS:
				if(IsSP())
					dmg += 2;
				break;
			case _DAMAGE_NIGHTMARESELET_SPIKES:
				if(IsSP())
					dmg += 2;
				break;
			case _DAMAGE_NIGHTMARESELET_ARROWS:
				if(IsSP())
					dmg += 2;
				break;
			case _DAMAGE_NIGHTMARESELET_MEGALASER:
				if(IsSP())
					dmg += 4;
				break;
		}
		return Floor(dmg);
	}
	
	ffc script EvanSkidooWeCanToo{
		const int NV_DAT = 0;
		const int NV_STARS = 1;
		const int NV_HITBOX = 2;
		const int NV_HP = 3;
		const int NV_PHASE = 4;
		const int NV_EGGX = 5;
		const int NV_EGGY = 6;
		const int NV_EGGTX = 7;
		const int NV_EGGTY = 8;
		const int NV_EGGSTATE = 9;
		const int NV_EGGTIMER = 10;
		const int NV_LHAND_TX = 11;
		const int NV_LHAND_TY = 12;
		const int NV_LHAND_STEP = 13;
		const int NV_LHAND_TRUEPOS = 14;
		const int NV_LHAND_TANG = 15;
		const int NV_LHAND_ANGSTEP = 16;
		const int NV_LHAND_MOVING = 17;
		const int NV_RHAND_TX = 18;
		const int NV_RHAND_TY = 19;
		const int NV_RHAND_STEP = 20;
		const int NV_RHAND_TRUEPOS = 21;
		const int NV_RHAND_TANG = 22;
		const int NV_RHAND_ANGSTEP = 23;
		const int NV_RHAND_MOVING = 24;
		const int NV_ASTEROIDS = 25;
		const int NV_ASTEROIDFREQ = 26;
		const int NV_ASTEROIDTIMER = 27;
		const int NV_ASTEROIDTIMER2 = 28;
		const int NV_NOASTEROIDS = 29;
		const int NV_DRAWX = 30;
		const int NV_DRAWY = 31;
		const int NV_HIDEDRAW = 32;
		const int NV_NOCOLL = 33;
		const int NV_PHASE3HP = 34;
		const int NV_CURRENTCYCLE = 35;
		const int NV_CLAWANIM = 36;
		const int NV_MASKBREAKDONE = 37;
		const int NV_DYING = 38;
		
		const int HITBOX_EGG = 0;
		const int HITBOX_HEAD = 1;
		const int HITBOX_LHAND = 2;
		const int HITBOX_RHAND = 3;
		
		const int EGG_INACTIVE = -1;
		const int EGG_FOLLOW = 0;
		const int EGG_FISHED = 1;
		const int EGG_FISHWAIT = 2;
		const int EGG_FISHRETURN = 3;
		const int EGG_STATIONARY = 4;
		const int EGG_LAUNCH = 5;
		const int EGG_UNFURL = 6;
		const int EGG_SCRIPTMANAGED = 7;
		
		void run(int enemyid){
			int i; int j; int k; int m;
			int x; int y; int x2; int y2;
			int xy[2];
			int ang; int dist;
			eweapon e;
			eweapon eArr[16];
			int arr[16];
			
			bitmap buf = Game->CreateBitmap(512, 512);
			bitmap starBG = Game->CreateBitmap(256, 176);
			bitmap starBG2 = Game->CreateBitmap(256, 176);
			bitmap prep = Game->CreateBitmap(256, 176);
			buf->Own();
			starBG->Own();
			starBG2->Own();
			prep->Own();
			
			int tentacleFrames[48];
			int tentacleASpeed[48];
			int tentacleSkip[48];
			for(i=0; i<48; ++i){
				tentacleFrames[i] = Rand(90);
				tentacleASpeed[i] = 1;
				if(i<5)
					tentacleASpeed[i] = 2;
				tentacleSkip[i] = Rand(4, 6);
			}
			
			int starDist[128];
			int starAng[128];
			int starStep[128];
			int stars[] = {starDist, starAng, starStep};
			
			for(i=0; i<128; ++i){
				starDist[i] = Rand(256);
				starAng[i] = Rand(360);
			}
			
			int asteroidX[32];
			int asteroidY[32];
			int asteroidAng[32];
			int asteroidSt[32];
			int asteroidStep[32];
			int asteroidRot[32];
			int asteroids[] = {asteroidX, asteroidY, asteroidAng, asteroidSt, asteroidStep, asteroidRot};
			
			untyped nsd[48];
			nsd[BUFFER] = buf;
			nsd[STARBITMAP] = starBG;
			nsd[STARBITMAP2] = starBG2;
			nsd[PREPBITMAP] = prep;
			
			nsd[HEADANGLE] = 90;
			
			nsd[LHAND_X] = -40;
			nsd[LHAND_Y] = 8;
			nsd[LHAND_ANG] = 0;
			
			nsd[RHAND_X] = 40;
			nsd[RHAND_Y] = 8;
			nsd[RHAND_ANG] = 0;
			
			nsd[TENTACLEFRAMES] = tentacleFrames;
			nsd[TENTACLEASPEED] = tentacleASpeed;
			nsd[TENTACLESKIP] = tentacleSkip;
			nsd[TENTACLEAMULT] = 1;
			
			nsd[SPECIALDRAW] = SD_FG;
			nsd[DRAWSCALE] = 1;
			nsd[DRAWLAYER] = 2;
			while(false){ //Draw Debugging
				if(Link->PressB){
					nsd[LHAND_STATE] = (nsd[LHAND_STATE]+1)%9;
					nsd[RHAND_STATE] = (nsd[RHAND_STATE]+1)%9;
				}
				if(Link->PressL){
					nsd[SPECIALDRAW] = (nsd[SPECIALDRAW]+1)%4;
				}
				if(Link->InputR){
					if(Link->InputUp)
						nsd[DRAWSCALE] += 0.01;
					else if(Link->InputDown)
						nsd[DRAWSCALE] -= 0.01;
					if(Link->InputLeft)
						nsd[DRAWROTATE] -= 2;
					else if(Link->InputRight)
						nsd[DRAWROTATE] += 2;
				}
				else{
					if(Link->InputUp){
						if(Link->InputA){
							nsd[HEADANGLE] = Angle(128, 88, Link->InputMouseX, Link->InputMouseY);
						}
						else{
							this->X = Link->InputMouseX;
							this->Y = Link->InputMouseY;
						}
					}
					if(Link->InputLeft){
						if(Link->InputA){
							nsd[LHAND_ANG] = Angle(128, 88, Link->InputMouseX, Link->InputMouseY);
						}
						else{
							nsd[LHAND_X] = Link->InputMouseX;
							nsd[LHAND_Y] = Link->InputMouseY;
						}
					}
					if(Link->InputRight){
						if(Link->InputA){
							nsd[RHAND_ANG] = Angle(128, 88, Link->InputMouseX, Link->InputMouseY);
						}
						else{
							nsd[RHAND_X] = Link->InputMouseX;
							nsd[RHAND_Y] = Link->InputMouseY;
						}
					}
				}
				//nsd[HEADANGLE] = Angle(128, 88, Link->InputMouseX, Link->InputMouseY);
				DrawSpaceTunnel(starBG, stars);
				DrawNightmareSelet1(nsd);
				DrawNightmareSelet2(nsd, this->X, this->Y);
				NoAction();
				Waitframe();
			}
			
			npc ghost = Ghost_InitAutoGhost(this, enemyid);
			
			npc hitbox[4];
			hitbox[HITBOX_EGG] = CreateNPCAt(247, 120, -32);
			hitbox[HITBOX_EGG]->CollDetection = false;
			hitbox[HITBOX_EGG]->DrawYOffset = -1000;
			
			hitbox[HITBOX_HEAD] = CreateNPCAt(246, 120, -32);
			hitbox[HITBOX_HEAD]->CollDetection = false;
			hitbox[HITBOX_HEAD]->DrawYOffset = -1000;
			hitbox[HITBOX_HEAD]->HitWidth = 32;
			hitbox[HITBOX_HEAD]->HitHeight = 32;
			SetAllDefenses(hitbox[HITBOX_HEAD], NPCDT_IGNORE);
			
			hitbox[HITBOX_LHAND] = CreateNPCAt(245, 120, -32);
			hitbox[HITBOX_LHAND]->DrawYOffset = -1000;
			hitbox[HITBOX_LHAND]->HitWidth = 24;
			hitbox[HITBOX_LHAND]->HitHeight = 24;
			
			hitbox[HITBOX_RHAND] = CreateNPCAt(245, 120, -32);
			hitbox[HITBOX_RHAND]->DrawYOffset = -1000;
			hitbox[HITBOX_RHAND]->HitWidth = 24;
			hitbox[HITBOX_RHAND]->HitHeight = 24;
			
			Ghost_Transform(this, ghost, -1, -1, 4, 4);
			Ghost_SetFlag(GHF_IGNORE_ALL_TERRAIN);
			Ghost_SetFlag(GHF_MOVE_OFFSCREEN);
			ghost->CollDetection = false;
			ghost->DrawYOffset = -1000;
			Ghost_X = 96;
			Ghost_Y = 16;
			untyped vars[48];
			vars[NV_DAT] = nsd;
			vars[NV_STARS] = stars;
			vars[NV_HITBOX] = hitbox;
			vars[NV_EGGX] = 120;
			vars[NV_EGGY] = -32;
			vars[NV_EGGTX] = Ghost_X+Rand(48);
			vars[NV_EGGTY] = Ghost_Y+Rand(48);
			vars[NV_ASTEROIDS] = asteroids;
			vars[NV_ASTEROIDFREQ] = 32;
			vars[NV_DRAWX] = -10000;
			vars[NV_DRAWY] = -10000;
			vars[NV_HIDEDRAW] = 0;
			
			Screen->D[D_EGGCONTROL] = 0;
			Screen->D[D_STARSBITMAP] = nsd[STARBITMAP];
			Screen->D[D_EGGPHASE] = 0;
			
			int attack;
			int attackCycle;
			// flying = true;
			// Screen->D[D_EGGCONTROL] = 1;
			vars[NV_HP] = HP_NIGHTMARESELET_PHASE1*EasyModeMultiplier(0.8); //7000;
			vars[NV_PHASE3HP] = HP_NIGHTMARESELET_PHASE3*EasyModeMultiplier(0.8);
			Screen->D[D_EGGFREEZE] = 0;
			//NSDebugState(vars, 2, 2);
			if(true){
				vars[NV_EGGSTATE] = EGG_INACTIVE;
				nsd[LHAND_STATE] = HAND_OPENFRONT;
				nsd[RHAND_STATE] = HAND_OPENFRONT;
				NSMoveLHand(vars, -72, -16, 2, -60, 2, false);
				NSMoveRHand(vars, 72, -16, 2, 60, 2, false);
				NSGlide(this, ghost, vars, 96, 32, 1);
				NSWaitframe(this, ghost, vars, 16);
				Game->PlaySound(146);
				for(i=0; i<120; ++i){
					nsd[HEADXOFF] = Rand(-2, 2);
					nsd[HEADYOFF] = 8*Sin(360*(i/120))+Rand(-2, 2);
					NSWaitframe(this, ghost, vars, 1);
				}
				vars[NV_EGGSTATE] = EGG_FOLLOW;
				nsd[HEADXOFF] = 0;
				nsd[HEADYOFF] = 0;
				NSMoveLHand(vars, -40, 8, 1, 0, 2, false);
				NSMoveRHand(vars, 40, 8, 1, 0, 2, false);
				NSWaithands(this, ghost, vars);
				NSGlide(this, ghost, vars, 96, 16, 1);
			}
			
			//G[G_SLEEPPARALYSISSELET] = 1;
			
			while(true){
				if(IsSP()){
					
					if(vars[NV_PHASE]==0){
						vars[NV_ASTEROIDTIMER] = 3000;
						vars[NV_NOCOLL] = 0;
						if(vars[NV_CURRENTCYCLE]==0){
							if(attackCycle%2==0)
								attack = 0;
							else
								attack = Choose(1, 4);
							++attackCycle;
							if(attackCycle>=6){
								vars[NV_ASTEROIDTIMER2] = 240;
								attack = 2;
								attackCycle = 0;
							}
						}
						else if(vars[NV_CURRENTCYCLE]==1){
							if(attackCycle%2==0)
								attack = 0;
							else
								attack = Choose(1, 4);
							++attackCycle;
							if(attackCycle>=6){
								vars[NV_ASTEROIDTIMER2] = 240;
								attack = 2;
								attackCycle = 0;
							}
						}
						else{
							if(attackCycle%3==0)
								attack = 0;
							else if(attackCycle%3==1)
								attack = Choose(1, 4);
							else
								attack = 2;
							++attackCycle;
							if(attackCycle>=6){
								vars[NV_ASTEROIDTIMER2] = 240;
								attack = 2;
								attackCycle = 0;
							}
						}
					}
					else if(vars[NV_PHASE]==1){
						vars[NV_NOCOLL] = 1;
						if(vars[NV_CURRENTCYCLE]==0){
							attack = Choose(5, 7);
							++attackCycle;
							if(attackCycle>=4){
								attack = 6;
								attackCycle = 0;
							}
						}
						else if(vars[NV_CURRENTCYCLE]==1){
							attack = Choose(5, 7);
							++attackCycle;
							if(attackCycle>=4){
								attack = 8;
								attackCycle = 0;
							}
						}
						else if(vars[NV_CURRENTCYCLE]==2){
							attack = Choose(5, 7);
							++attackCycle;
							if(attackCycle>=4){
								attack = Choose(6, 8);
								attackCycle = 0;
							}
						}
					}
					else if(vars[NV_PHASE]==2){
						vars[NV_NOCOLL] = 0;
						if(vars[NV_CURRENTCYCLE]==0){
							attack = 9;
							++attackCycle;
							if(attackCycle>=5){
								attack = 12;
								attackCycle = 0;
							}
						}
						else if(vars[NV_CURRENTCYCLE]==1){
							attack = 9;
							if(attackCycle==3)
								attack = 10;
							++attackCycle;
							if(attackCycle>=5){
								attack = 12;
								attackCycle = 0;
							}
						}
						else if(vars[NV_CURRENTCYCLE]==2){
							attack = 9;
							if(attackCycle==3)
								attack = Choose(10, 11, 11);
							else if(attackCycle==0)
								attack = 11;
							++attackCycle;
							if(attackCycle>=5){
								attack = 12;
								attackCycle = 0;
							}
						}
					}
				}
				else{
					if(vars[NV_PHASE]==0){
						vars[NV_NOCOLL] = 0;
						if(vars[NV_CURRENTCYCLE]==0){
							if(attackCycle%2==0)
								attack = 0;
							else
								attack = Choose(1, 4);
							++attackCycle;
							if(attackCycle>=6){
								attack = 3;
								attackCycle = 0;
							}
						}
						else if(vars[NV_CURRENTCYCLE]==1){
							if(attackCycle%2==0)
								attack = 0;
							else
								attack = Choose(1, 2);
							++attackCycle;
							if(attackCycle>=6){
								attack = 3;
								attackCycle = 0;
							}
						}
						else{
							if(attackCycle%3==0)
								attack = 0;
							else if(attackCycle%3==1)
								attack = Choose(1, 4);
							else
								attack = 2;
							++attackCycle;
							if(attackCycle>=6){
								attack = 3;
								attackCycle = 0;
							}
						}
					}
					else if(vars[NV_PHASE]==1){
						vars[NV_NOCOLL] = 1;
						if(vars[NV_CURRENTCYCLE]==0||vars[NV_CURRENTCYCLE]==2){
							attack = Choose(5, 7);
							++attackCycle;
							if(attackCycle>=4){
								if(vars[NV_CURRENTCYCLE]==2)
									attack = Choose(6, 8);
								else
									attack = 6;
								attackCycle = 0;
							}
							if(vars[NV_CURRENTCYCLE]==2&&IsEasyMode()&&attackCycle<4&&attackCycle%2==1)
								attack = 103;
						}
						else{
							attack = 103;
							++attackCycle;
							if(attackCycle>=4){
								attack = 8;
								attackCycle = 0;
							}
						}
					}
					else if(vars[NV_PHASE]==2){
						vars[NV_NOCOLL] = 0;
						if(vars[NV_CURRENTCYCLE]==0){
							attack = 9;
							++attackCycle;
							if(attackCycle>=5){
								attack = 12;
								attackCycle = 0;
							}
						}
						else if(vars[NV_CURRENTCYCLE]==1){
							attack = 9;
							if(attackCycle==3)
								attack = 10;
							++attackCycle;
							if(attackCycle>=5){
								attack = 12;
								attackCycle = 0;
							}
						}
						else if(vars[NV_CURRENTCYCLE]==2){
							attack = 9;
							if(attackCycle==3)
								attack = Choose(10, 11, 11);
							else if(attackCycle==0)
								attack = 11;
							++attackCycle;
							if(attackCycle>=5){
								attack = 12;
								attackCycle = 0;
							}
						}
					}
				}
					
				if(vars[NV_PHASE]==0&&vars[NV_HP]<=HP_NIGHTMARESELET_PHASE2*EasyModeMultiplier(0.8)){
					vars[NV_PHASE] = 1;
					attack = 100;
					attackCycle = 0;
				}
				else if(vars[NV_PHASE]==1&&vars[NV_HP]<=0){
					if(vars[NV_CURRENTCYCLE]==1){
						attack = 12;
						Screen->D[D_EGGCONTROL] = 2;
						while(Screen->D[D_EGGCONTROL]==2){
							NSWaitframe(this, ghost, vars, 1);
						}
						vars[NV_PHASE3HP] = HP_NIGHTMARESELET_PHASE3*EasyModeMultiplier(0.8);
						vars[NV_EGGSTATE] = EGG_FOLLOW;
						vars[NV_EGGTX] = 120;
						vars[NV_EGGTY] = -32;
					}
					else{
						attack = 101;
					}
					attackCycle = 0;
				}
				else if(vars[NV_PHASE]==2&&vars[NV_PHASE3HP]<=0&&vars[NV_CURRENTCYCLE]<2){
					vars[NV_PHASE] = 0;
					SetAllDefenses(hitbox[HITBOX_HEAD], NPCDT_IGNORE);
					attack = 102;
					vars[NV_MASKBREAKDONE] = 0;
					attackCycle = 0;
				}
				
				if(attack==0){ //Hand pound
					int pattern = Rand(4);
					if(IsEasyMode()){
						pattern = Choose(0, 1, 2);
					}
					switch(pattern){
						case 0: //Left hand
							nsd[LHAND_STATE] = HAND_OPENFRONT;
							NSMoveLHand(vars, -56, -16, 2, -30, 1, false);
							NSGlide(this, ghost, vars, 96-32, 32, 1);
							NSWaithands(this, ghost, vars);
							nsd[LHAND_CASTING] = 2;
							NSWaitframe(this, ghost, vars, 16);
							nsd[LHAND_STATE] = HAND_FIST;
							NSMoveLHand(vars, 64, 120, 5, 0, 2, true);
							nsd[LHAND_CASTING] = 1;
							NSWaithands(this, ghost, vars);
							e = FireEWeapon(EW_SCRIPT10, NSHandX(nsd, 0)-8, NSHandY(nsd, 0)-8, 0, 0, NSDamage(_DAMAGE_NIGHTMARESELET_COSMICSUN), SPRITE_INVISIBLE, SFX_BOMB, EWF_UNBLOCKABLE);
							Game->PlaySound(37);
							Screen->Quake = 10;
							e->CollDetection = false;
							RunEWeaponScript(e, "CosmicSun", {56, 4, 32, 8});
							NSWaitframe(this, ghost, vars, 32);
							nsd[RHAND_CASTING] = 0;
							break;
						case 1: //Right hand
							nsd[RHAND_STATE] = HAND_OPENFRONT;
							NSMoveRHand(vars, 56, -16, 2, 30, 1, false);
							NSGlide(this, ghost, vars, 96+32, 32, 1);
							NSWaithands(this, ghost, vars);
							nsd[RHAND_CASTING] = 2;
							NSWaitframe(this, ghost, vars, 16);
							nsd[RHAND_STATE] = HAND_FIST;
							NSMoveRHand(vars, 192, 120, 5, 0, 2, true);
							nsd[RHAND_CASTING] = 1;
							NSWaithands(this, ghost, vars);
							e = FireEWeapon(EW_SCRIPT10, NSHandX(nsd, 1)-8, NSHandY(nsd, 1)-8, 0, 0, NSDamage(_DAMAGE_NIGHTMARESELET_COSMICSUN), SPRITE_INVISIBLE, SFX_BOMB, EWF_UNBLOCKABLE);
							Game->PlaySound(37);
							Screen->Quake = 10;
							e->CollDetection = false;
							RunEWeaponScript(e, "CosmicSun", {56, 4, 32, 8});
							NSWaitframe(this, ghost, vars, 32);
							nsd[LHAND_CASTING] = 0;
							break;
						case 2: //Center
							nsd[LHAND_STATE] = HAND_OPENFRONT;
							nsd[RHAND_STATE] = HAND_OPENFRONT;
							NSMoveLHand(vars, -24, -24, 1, -10, 1, false);
							NSMoveRHand(vars, 24, -24, 1, 10, 1, false);
							NSGlide(this, ghost, vars, 96, 32, 1);
							NSWaithands(this, ghost, vars);
							nsd[LHAND_CASTING] = 2;
							nsd[RHAND_CASTING] = 2;
							NSWaitframe(this, ghost, vars, 32);
							nsd[LHAND_STATE] = HAND_FIST;
							nsd[RHAND_STATE] = HAND_FIST;
							nsd[LHAND_ANG] = 90;
							nsd[RHAND_ANG] = -90;
							nsd[LHAND_CASTING] = 1;
							nsd[RHAND_CASTING] = 1;
							NSMoveLHand(vars, -8, -32, 2, 135, 10, false);
							NSMoveRHand(vars, 8, -32, 2, -135, 10, false);
							NSWaithands(this, ghost, vars);
							NSMoveLHand(vars, 128-8, 128, 5, 0, 10, true);
							NSMoveRHand(vars, 128+8, 128, 5, 0, 10, true);
							NSWaithands(this, ghost, vars);
							e = FireEWeapon(EW_SCRIPT10, 128-8, NSHandY(nsd, 0)-8, 0, 0, NSDamage(_DAMAGE_NIGHTMARESELET_COSMICSUN), SPRITE_INVISIBLE, SFX_BOMB, EWF_UNBLOCKABLE);
							Game->PlaySound(37);
							Screen->Quake = 10;
							e->CollDetection = false;
							RunEWeaponScript(e, "CosmicSun", {72, 4, 32, 8});
							NSWaitframe(this, ghost, vars, 32);
							nsd[RHAND_CASTING] = 0;
							break;
						case 3: //Split
							nsd[LHAND_STATE] = HAND_OPENFRONT;
							nsd[RHAND_STATE] = HAND_OPENFRONT;
							NSMoveLHand(vars, -24, -24, 1, 0, 2, false);
							NSMoveRHand(vars, 24, -24, 1, 0, 2, false);
							NSGlide(this, ghost, vars, 96, 48, 1);
							NSWaithands(this, ghost, vars);
							nsd[LHAND_CASTING] = 2;
							nsd[RHAND_CASTING] = 2;
							nsd[HEADTARGETSTATE] = 3;
							NSWaitframe(this, ghost, vars, 32);
							nsd[LHAND_STATE] = HAND_FIST;
							nsd[RHAND_STATE] = HAND_FIST;
							NSMoveLHand(vars, 72, 128, 5, 45, 2, true);
							NSMoveRHand(vars, 184, 128, 5, -45, 2, true);
							nsd[LHAND_CASTING] = 1;
							nsd[RHAND_CASTING] = 1;
							NSWaithands(this, ghost, vars);
							e = FireEWeapon(EW_SCRIPT10, NSHandX(nsd, 0)-8, NSHandY(nsd, 0)-8, 0, 0, NSDamage(_DAMAGE_NIGHTMARESELET_COSMICSUN), SPRITE_INVISIBLE, SFX_BOMB, EWF_UNBLOCKABLE);
							e->CollDetection = false;
							RunEWeaponScript(e, "CosmicSun", {40, 4, 32, 8});
							e = FireEWeapon(EW_SCRIPT10, NSHandX(nsd, 1)-8, NSHandY(nsd, 1)-8, 0, 0, NSDamage(_DAMAGE_NIGHTMARESELET_COSMICSUN), SPRITE_INVISIBLE, SFX_BOMB, EWF_UNBLOCKABLE);
							e->CollDetection = false;
							Game->PlaySound(37);
							Screen->Quake = 10;
							RunEWeaponScript(e, "CosmicSun", {40, 4, 32, 8});
							nsd[HEADTARGETSTATE] = 0;
							NSWaitframe(this, ghost, vars, 32);
							nsd[RHAND_CASTING] = 0;
							break;
					}
					nsd[LHAND_STATE] = HAND_OPENBACK;
					nsd[RHAND_STATE] = HAND_OPENBACK;
					NSMoveLHand(vars, -40, 8, 2, 0, 2, false);
					NSMoveRHand(vars, 40, 8, 2, 0, 2, false);
					nsd[LHAND_CASTING] = 0;
					nsd[RHAND_CASTING] = 0;
					NSWaithands(this, ghost, vars);
				}
				else if(attack==1){ //Slashes
					k = Choose(-1, 1);
					int pattern = Rand(2);
					int clawSpacing = 36;
					if(IsEasyMode()){
						pattern = 0;
						clawSpacing = 44;
					}
					
					if(k==-1){
						if(pattern==0){
							NSGlide(this, ghost, vars, 96-48, 24, 1);
							nsd[LHAND_STATE] = HAND_CLAW;
							NSMoveLHand(vars, -32, 32, 2, 0, 2, false);
							NSMoveRHand(vars, 40, -24, 2, -45, 2, false);
							NSWaithands(this, ghost, vars);
							NSWaitframe(this, ghost, vars, 8+EasyModeFrames(24));
							x = NSHandX(nsd, 0);
							y = NSHandY(nsd, 0);
							Game->PlaySound(SFX_SELETCLAW);
							for(i=0; i<20; ++i){
								BezierQuadFrame(xy, i, 20, x, y, x, y+32, x+48, y+32);
								ang = Lerp(90, 0, i/19);
								NSSetHand(nsd, 0, xy[0], xy[1], ang-90, true);
								NSClaw2(eArr, 0, 5, xy[0], xy[1], ang, ang, Lerp(0, clawSpacing, i/19), NSDamage(_DAMAGE_NIGHTMARESELET_SLASH), 16, 16);
								NSWaitframe(this, ghost, vars, 1);
							}
							x += 48;
							y += 32;
							ang = 0;
							while(x<256){
								x += 6;
								NSClaw2(eArr, 0, 5, x, y, ang, ang, clawSpacing, NSDamage(_DAMAGE_NIGHTMARESELET_SLASH), 16, 1);
								NSWaitframe(this, ghost, vars, 1);
							}
							while(NSClaw2(eArr, 0, 5, x, y, ang, ang, clawSpacing, NSDamage(_DAMAGE_NIGHTMARESELET_SLASH), 0, 1)){
								NSWaitframe(this, ghost, vars, 1);
							}
						}
						else{
							nsd[HEADTARGETSTATE] = 3;
							NSGlide(this, ghost, vars, 96-48, 24, 1);
							nsd[LHAND_STATE] = HAND_CLAW;
							nsd[RHAND_STATE] = HAND_CLAW;
							NSMoveLHand(vars, -32, -16, 2, -45, 2, false);
							NSMoveRHand(vars, -16, -32, 2, -45, 2, false);
							NSWaithands(this, ghost, vars);
							x = (NSHandX(nsd, 0)+NSHandX(nsd, 1))/2;
							y = (NSHandY(nsd, 0)+NSHandY(nsd, 1))/2;
							ang = Angle(x, y, Link->X+8, Link->Y+8);
							for(i=0; i<16; ++i){
								x = (NSHandX(nsd, 0)+NSHandX(nsd, 1))/2;
								y = (NSHandY(nsd, 0)+NSHandY(nsd, 1))/2;
								ang = Angle(x, y, Link->X+8, Link->Y+8);
								nsd[LHAND_ANG] = ang-90;
								nsd[RHAND_ANG] = ang-90;
								NSWaitframe(this, ghost, vars, 1);
							}
							NSMoveLHand(vars, x+VectorX(80, ang)+VectorX(16, ang+90), y+VectorY(80, ang)+VectorY(16, ang+90), 3, -1000, 2, true);
							NSMoveRHand(vars, x+VectorX(80, ang)+VectorX(-16, ang+90), y+VectorY(80, ang)+VectorY(-16, ang+90), 3, -1000, 2, true);
							Game->PlaySound(SFX_SELETCLAW);
							while(x>0-64&&x<256+64&&y>0-64&&y<176+64){
								x += VectorX(6, ang);
								y += VectorY(6, ang);
								NSClaw2(eArr, 0, 5, x, y, ang, ang, 40, NSDamage(_DAMAGE_NIGHTMARESELET_SLASH), 16, 16);
								NSWaitframe(this, ghost, vars, 1);
							}
							nsd[HEADTARGETSTATE] = 0;
							while(NSClaw2(eArr, 0, 5, x, y, ang, ang, 40, NSDamage(_DAMAGE_NIGHTMARESELET_SLASH), 0, 1)){
								NSWaitframe(this, ghost, vars, 1);
							}
						}
					}
					else{
						if(pattern==0){
							NSGlide(this, ghost, vars, 96+48, 24, 1);
							nsd[RHAND_STATE] = HAND_CLAW;
							NSMoveLHand(vars, -40, -24, 2, 45, 2, false);
							NSMoveRHand(vars, 32, 32, 2, 0, 2, false);
							NSWaithands(this, ghost, vars);
							NSWaitframe(this, ghost, vars, 8+EasyModeFrames(24));
							x = NSHandX(nsd, 1);
							y = NSHandY(nsd, 1);
							Game->PlaySound(SFX_SELETCLAW);
							for(i=0; i<20; ++i){
								BezierQuadFrame(xy, i, 20, x, y, x, y+32, x-48, y+32);
								ang = Lerp(90, 180, i/19);
								NSSetHand(nsd, 1, xy[0], xy[1], ang-90, true);
								NSClaw2(eArr, 0, 5, xy[0], xy[1], ang, ang, Lerp(0, clawSpacing, i/19), NSDamage(_DAMAGE_NIGHTMARESELET_SLASH), 16, 16);
								NSWaitframe(this, ghost, vars, 1);
							}
							x -= 48;
							y += 32;
							ang = 180;
							while(x>0){
								x -= 6;
								NSClaw2(eArr, 0, 5, x, y, ang, ang, clawSpacing, NSDamage(_DAMAGE_NIGHTMARESELET_SLASH), 16, 1);
								NSWaitframe(this, ghost, vars, 1);
							}
							while(NSClaw2(eArr, 0, 5, x, y, ang, ang, clawSpacing, NSDamage(_DAMAGE_NIGHTMARESELET_SLASH), 0, 1)){
								NSWaitframe(this, ghost, vars, 1);
							}
						}
						else{
							nsd[HEADTARGETSTATE] = 3;
							NSGlide(this, ghost, vars, 96+48, 24, 1);
							nsd[LHAND_STATE] = HAND_CLAW;
							nsd[RHAND_STATE] = HAND_CLAW;
							NSMoveLHand(vars, 16, -32, 2, 45, 2, false);
							NSMoveRHand(vars, 32, -16, 2, 45, 2, false);
							NSWaithands(this, ghost, vars);
							x = (NSHandX(nsd, 0)+NSHandX(nsd, 1))/2;
							y = (NSHandY(nsd, 0)+NSHandY(nsd, 1))/2;
							ang = Angle(x, y, Link->X+8, Link->Y+8);
							for(i=0; i<16; ++i){
								x = (NSHandX(nsd, 0)+NSHandX(nsd, 1))/2;
								y = (NSHandY(nsd, 0)+NSHandY(nsd, 1))/2;
								ang = Angle(x, y, Link->X+8, Link->Y+8);
								nsd[LHAND_ANG] = ang-90;
								nsd[RHAND_ANG] = ang-90;
								NSWaitframe(this, ghost, vars, 1);
							}
							NSMoveLHand(vars, x+VectorX(80, ang)+VectorX(16, ang+90), y+VectorY(80, ang)+VectorY(16, ang+90), 3, -1000, 2, true);
							NSMoveRHand(vars, x+VectorX(80, ang)+VectorX(-16, ang+90), y+VectorY(80, ang)+VectorY(-16, ang+90), 3, -1000, 2, true);
							Game->PlaySound(SFX_SELETCLAW);
							while(x>0-64&&x<256+64&&y>0-64&&y<176+64){
								x += VectorX(6, ang);
								y += VectorY(6, ang);
								NSClaw2(eArr, 0, 5, x, y, ang, ang, 40, NSDamage(_DAMAGE_NIGHTMARESELET_SLASH), 16, 16);
								NSWaitframe(this, ghost, vars, 1);
							}
							nsd[HEADTARGETSTATE] = 0;
							while(NSClaw2(eArr, 0, 5, x, y, ang, ang, 40, NSDamage(_DAMAGE_NIGHTMARESELET_SLASH), 0, 1)){
								NSWaitframe(this, ghost, vars, 1);
							}
						}
					}
					nsd[LHAND_STATE] = HAND_OPENBACK;
					nsd[RHAND_STATE] = HAND_OPENBACK;
					NSMoveLHand(vars, -40, 8, 2, 0, 2, false);
					NSMoveRHand(vars, 40, 8, 2, 0, 2, false);
					NSWaithands(this, ghost, vars);
				}
				else if(attack==2){ //Lasers
					vars[NV_NOASTEROIDS] = 1;
					nsd[LHAND_STATE] = HAND_OPENFRONT;
					nsd[RHAND_STATE] = HAND_OPENFRONT;
					nsd[LHAND_TARGETSUB] = 3;
					nsd[RHAND_TARGETSUB] = 3;
					NSMoveLHand(vars, -64, 32, 2, -60, 4, false);
					NSMoveRHand(vars, 64, 32, 2, 60, 4, false);
					NSGlide(this, ghost, vars, Ghost_X, 24, 1);
					k = Rand(4);
					if(IsEasyMode())
						k = Choose(0, 1);
					j = Rand(2);
					if(k==1||k==3)
						nsd[HEADTARGETSTATE] = 3;
					NSWaitframe(this, ghost, vars, 32);
					switch(k){
						case 0:
						case 1:
							if(j==0){
								Game->PlaySound(86);
								for(i=0; i<16; ++i){
									DrawStarGlint(4, NSEyeX(nsd, 0), NSEyeY(nsd, 0), Lerp(-90, 0, i/16), Lerp(16, 4, i/16), Choose(0x71, 0x76, 0x77));
									NSWaitframe(this, ghost, vars, 1);
								}
								e = FireEWeapon(EW_SCRIPT10, 120, 80, 0, 0, NSDamage(_DAMAGE_NIGHTMARESELET_LASER), SPRITE_INVISIBLE, 0, 0);
								e->CollDetection = false;
								RunEWeaponScript(e, "BezierLaser", {0, NSEyeX(nsd, 0), NSEyeY(nsd, 0), k, j, 0});
								while(e->isValid()){
									NSWaitframe(this, ghost, vars, 1);
								}
							}
							else{
								Game->PlaySound(86);
								for(i=0; i<16; ++i){
									DrawStarGlint(4, NSEyeX(nsd, 1), NSEyeY(nsd, 1), Lerp(90, 0, i/16), Lerp(16, 4, i/16), Choose(0x71, 0x76, 0x77));
									NSWaitframe(this, ghost, vars, 1);
								}
								e = FireEWeapon(EW_SCRIPT10, 120, 80, 0, 0, NSDamage(_DAMAGE_NIGHTMARESELET_LASER), SPRITE_INVISIBLE, 0, 0);
								e->CollDetection = false;
								RunEWeaponScript(e, "BezierLaser", {0, NSEyeX(nsd, 1), NSEyeY(nsd, 1), k, j, 0});
								while(e->isValid()){
									NSWaitframe(this, ghost, vars, 1);
								}
							}
							break;
						case 2:
							Game->PlaySound(86);
							for(i=0; i<16; ++i){
								DrawStarGlint(4, NSEyeX(nsd, 0), NSEyeY(nsd, 0), Lerp(-90, 0, i/16), Lerp(16, 4, i/16), Choose(0x71, 0x76, 0x77));
								DrawStarGlint(4, NSEyeX(nsd, 1), NSEyeY(nsd, 1), Lerp(90, 0, i/16), Lerp(16, 4, i/16), Choose(0x71, 0x76, 0x77));
								NSWaitframe(this, ghost, vars, 1);
							}
							e = FireEWeapon(EW_SCRIPT10, 120, 80, 0, 0, NSDamage(_DAMAGE_NIGHTMARESELET_LASER), SPRITE_INVISIBLE, 0, 0);
							e->CollDetection = false;
							RunEWeaponScript(e, "BezierLaser", {0, NSEyeX(nsd, 0), NSEyeY(nsd, 0), k, 0, 0});
							e = FireEWeapon(EW_SCRIPT10, 120, 80, 0, 0, NSDamage(_DAMAGE_NIGHTMARESELET_LASER), SPRITE_INVISIBLE, 0, 0);
							e->CollDetection = false;
							RunEWeaponScript(e, "BezierLaser", {0, NSEyeX(nsd, 1), NSEyeY(nsd, 1), k, 1, 0});
							while(e->isValid()){
								NSWaitframe(this, ghost, vars, 1);
							}
							break;
						case 3:
							Game->PlaySound(86);
							for(i=0; i<16; ++i){
								DrawStarGlint(4, NSEyeX(nsd, 0), NSEyeY(nsd, 0), Lerp(-90, 0, i/16), Lerp(16, 4, i/16), Choose(0x71, 0x76, 0x77));
								DrawStarGlint(4, NSEyeX(nsd, 1), NSEyeY(nsd, 1), Lerp(90, 0, i/16), Lerp(16, 4, i/16), Choose(0x71, 0x76, 0x77));
								NSWaitframe(this, ghost, vars, 1);
							}
							if(j==0){
								e = FireEWeapon(EW_SCRIPT10, 120, 80, 0, 0, NSDamage(_DAMAGE_NIGHTMARESELET_LASER), SPRITE_INVISIBLE, 0, 0);
								e->CollDetection = false;
								RunEWeaponScript(e, "BezierLaser", {0, NSEyeX(nsd, 0), NSEyeY(nsd, 0), k, 0, 0});
								e = FireEWeapon(EW_SCRIPT10, 120, 80, 0, 0, NSDamage(_DAMAGE_NIGHTMARESELET_LASER), SPRITE_INVISIBLE, 0, 0);
								e->CollDetection = false;
								RunEWeaponScript(e, "BezierLaser", {0, NSEyeX(nsd, 1), NSEyeY(nsd, 1), k, 0, 16});
								while(e->isValid()){
									NSWaitframe(this, ghost, vars, 1);
								}
							}
							else{
								e = FireEWeapon(EW_SCRIPT10, 120, 80, 0, 0, NSDamage(_DAMAGE_NIGHTMARESELET_LASER), SPRITE_INVISIBLE, 0, 0);
								e->CollDetection = false;
								RunEWeaponScript(e, "BezierLaser", {0, NSEyeX(nsd, 0), NSEyeY(nsd, 0), k, 1, 16});
								e = FireEWeapon(EW_SCRIPT10, 120, 80, 0, 0, NSDamage(_DAMAGE_NIGHTMARESELET_LASER), SPRITE_INVISIBLE, 0, 0);
								e->CollDetection = false;
								RunEWeaponScript(e, "BezierLaser", {0, NSEyeX(nsd, 1), NSEyeY(nsd, 1), k, 1, 0});
								while(e->isValid()){
									NSWaitframe(this, ghost, vars, 1);
								}
							}
							break;
					}
					nsd[HEADTARGETSTATE] = 0;
					nsd[LHAND_TARGETSUB] = 0;
					nsd[RHAND_TARGETSUB] = 0;
					NSWaitframe(this, ghost, vars, 16);
					nsd[LHAND_STATE] = HAND_OPENBACK;
					nsd[RHAND_STATE] = HAND_OPENBACK;
					NSMoveLHand(vars, -40, 8, 2, 0, 2, false);
					NSMoveRHand(vars, 40, 8, 2, 0, 2, false);
					nsd[LHAND_CASTING] = 0;
					nsd[RHAND_CASTING] = 0;
					NSWaithands(this, ghost, vars);
					vars[NV_NOASTEROIDS] = 0;
				}
				else if(attack==3){ //Asteroid Field
					nsd[LHAND_STATE] = HAND_OPENFRONT;
					nsd[RHAND_STATE] = HAND_OPENFRONT;
					NSMoveLHand(vars, -24, -32, 2, 0, 4, false);
					NSMoveRHand(vars, 24, -32, 2, 0, 4, false);
					NSGlide(this, ghost, vars, Clamp(Link->X-24, 32, 160), 24, 2);
					NSWaithands(this, ghost, vars);
					nsd[HEADTARGETSTATE] = 3;
					nsd[LHAND_TARGETSUB] = 3;
					nsd[RHAND_TARGETSUB] = 3;
					NSMoveLHand(vars, -64, 24, 4, -90, 4, false);
					NSMoveRHand(vars, 64, 24, 4, 90, 4, false);
					NSGlide(this, ghost, vars, Ghost_X, 32, 2);
					NSWaithands(this, ghost, vars);
					vars[NV_ASTEROIDTIMER2] = 240;
					vars[NV_ASTEROIDTIMER] = 1200;
					for(i=0; i<180; ++i){
						if(Abs(Ghost_X+24-Link->X)>4){
							Ghost_X += 0.5*Sign(Link->X-(Ghost_X+24));
							Ghost_X = Clamp(Ghost_X, 32, 160);
						}
						NSWaitframe(this, ghost, vars, 1);
					}
					if(IsEasyMode()){
						vars[NV_ASTEROIDTIMER] = 0;
						vars[NV_ASTEROIDTIMER2] = 0;
					}
					NSMoveLHand(vars, -40, 8, 2, 0, 2, false);
					NSMoveRHand(vars, 40, 8, 2, 0, 2, false);
					nsd[HEADTARGETSTATE] = 0;
					nsd[LHAND_TARGETSUB] = 0;
					nsd[RHAND_TARGETSUB] = 0;
					NSWaithands(this, ghost, vars);
					NSWaitframe(this, ghost, vars, 32);
				}
				else if(attack==4){ //Aimed shots
					x = Clamp(Link->X-24, 32, 160);
					y = Clamp(Link->Y-32, 32, 64);
					k = Link->X;
					if(!IsEasyMode()){
						while(Distance(Ghost_X, Ghost_Y, x, y)>1){
							if(Link->X<Ghost_X+24)
								j = -1;
							else
								j = 1;
							ang = Angle(Ghost_X, Ghost_Y, x, y);
							if(Distance(Ghost_X, Ghost_Y, x, y)>1){
								Ghost_MoveAtAngle(ang, 1, 0);
							}
							if(j==-1){
								nsd[LHAND_STATE] = HAND_OPENFRONT;
								nsd[RHAND_STATE] = HAND_OPENBACK;
								ang = Angle(Ghost_X+32-8, Ghost_Y+8, Link->X+8, Link->Y+8);
								NSMoveLHand(vars, -8+VectorX(48, ang), 8+VectorY(48, ang), 2, ang+180, 4, false);
								NSMoveRHand(vars, 40, 8, 2, 0, 4, false);
							}
							else{
								nsd[LHAND_STATE] = HAND_OPENBACK;
								nsd[RHAND_STATE] = HAND_OPENFRONT;
								ang = Angle(Ghost_X+32+8, Ghost_Y+8, Link->X+8, Link->Y+8);
								NSMoveLHand(vars, -40, 8, 2, 0, 4, false);
								NSMoveRHand(vars, 8+VectorX(48, ang), 8+VectorY(48, ang), 2, ang, 4, false);
							}
							NSWaitframe(this, ghost, vars, 1);
						}
					}
					x = k+ -((Ghost_X+24)-k);
					y = 24;
					x = Clamp(x, 32, 160);
					while(Distance(Ghost_X, Ghost_Y, x, y)>1){
						if(Link->X<Ghost_X+24)
							j = -1;
						else
							j = 1;
						ang = Angle(Ghost_X, Ghost_Y, x, y);
						if(Distance(Ghost_X, Ghost_Y, x, y)>1){
							Ghost_MoveAtAngle(ang, 1, 0);
						}
						if(j==-1){
							nsd[LHAND_STATE] = HAND_OPENFRONT;
							nsd[RHAND_STATE] = HAND_OPENBACK;
							nsd[LHAND_TARGETSUB] = 3;
							nsd[RHAND_TARGETSUB] = 0;
							ang = Angle(Ghost_X+32-8, Ghost_Y+8, Link->X+8, Link->Y+8);
							NSMoveLHand(vars, -8+VectorX(48, ang), 8+VectorY(48, ang), 2, ang+180, 4, false);
							NSMoveRHand(vars, 40, 8, 2, 0, 4, false);
						}
						else{
							nsd[LHAND_STATE] = HAND_OPENBACK;
							nsd[RHAND_STATE] = HAND_OPENFRONT;
							nsd[LHAND_TARGETSUB] = 0;
							nsd[RHAND_TARGETSUB] = 3;
							ang = Angle(Ghost_X+32+8, Ghost_Y+8, Link->X+8, Link->Y+8);
							NSMoveLHand(vars, -40, 8, 2, 0, 4, false);
							NSMoveRHand(vars, 8+VectorX(48, ang), 8+VectorY(48, ang), 2, ang, 4, false);
						}
						NSWaitframe(this, ghost, vars, 1);
					}
					int shotDelay = 40;
					int shots = 4;
					int shotSpacing = 0;
					if(IsEasyMode()){
						shotDelay = 60;
						shots = 3;
					}
					if(IsSP()){
						shotDelay = 20;
						shots = 12;
						shotSpacing = 4;
					}
					for(i=0; i<=shotDelay*shots; ++i){
						if(Link->X<Ghost_X+24)
							j = -1;
						else
							j = 1;
						bool skipFrame = false;
						if(shotSpacing>0&&Ceiling(i/shotDelay)%shotSpacing==shotSpacing-1)
							skipFrame = true;
						if(j==-1){
							nsd[LHAND_STATE] = HAND_OPENFRONT;
							nsd[RHAND_STATE] = HAND_OPENBACK;
							nsd[LHAND_TARGETSUB] = 3;
							nsd[RHAND_TARGETSUB] = 0;
							ang = Angle(Ghost_X+32-8, Ghost_Y+8, Link->X+8, Link->Y+8);
							NSMoveLHand(vars, -8+VectorX(48, ang)-8, 8+VectorY(48, ang)-8, 2, ang+180, 4, false);
							NSMoveRHand(vars, 40, 8, 2, 0, 4, false);
							if(i%shotDelay>shotDelay/2&&!skipFrame)
								nsd[LHAND_CASTING] = 2;
							else
								nsd[LHAND_CASTING] = 0;
							nsd[RHAND_CASTING] = 0;
							if(i==shotDelay/2&&!skipFrame)
								Game->PlaySound(SFX_CHARGE1);
							if(i%shotDelay==0&&i>0&&!skipFrame){
								e = FireAimedEWeapon(EW_SCRIPT10, NSHandX(nsd, 0), NSHandY(nsd, 0), 0, 400, NSDamage(_DAMAGE_NIGHTMARESELET_FIREBALLS), SPR_COSMICBALL, SFX_COSMICBALL, 0);
							}
						}
						else{
							nsd[LHAND_STATE] = HAND_OPENBACK;
							nsd[RHAND_STATE] = HAND_OPENFRONT;
							nsd[LHAND_TARGETSUB] = 0;
							nsd[RHAND_TARGETSUB] = 3;
							ang = Angle(Ghost_X+32+8, Ghost_Y+8, Link->X+8, Link->Y+8);
							NSMoveLHand(vars, -40, 8, 2, 0, 4, false);
							NSMoveRHand(vars, 8+VectorX(48, ang)-8, 8+VectorY(48, ang)-8, 2, ang, 4, false);
							nsd[LHAND_CASTING] = 0;
							if(i%shotDelay>shotDelay/2&&!skipFrame)
								nsd[RHAND_CASTING] = 2;
							else
								nsd[RHAND_CASTING] = 0;
							if(i==shotDelay/2&&!skipFrame)
								Game->PlaySound(SFX_CHARGE1);
							if(i%shotDelay==0&&i>0&&!skipFrame){
								e = FireAimedEWeapon(EW_SCRIPT10, NSHandX(nsd, 1), NSHandY(nsd, 1), 0, 400, NSDamage(_DAMAGE_NIGHTMARESELET_FIREBALLS), SPR_COSMICBALL, SFX_COSMICBALL, 0);
							}
						}
						NSWaitframe(this, ghost, vars, 1);
					}
					NSMoveLHand(vars, -40, 8, 2, 0, 2, false);
					NSMoveRHand(vars, 40, 8, 2, 0, 2, false);
					nsd[HEADTARGETSTATE] = 0;
					nsd[LHAND_TARGETSUB] = 0;
					nsd[RHAND_TARGETSUB] = 0;
					nsd[LHAND_CASTING] = 0;
					nsd[RHAND_CASTING] = 0;
					NSWaithands(this, ghost, vars);
					nsd[LHAND_STATE] = HAND_OPENBACK;
					nsd[RHAND_STATE] = HAND_OPENBACK;
				}
				else if(attack==5){ //Fly over (Spikes)
					k = Choose(-1, 1);
					j = Rand(3);
					
					vars[NV_DRAWX] = 96-320*k;
					vars[NV_DRAWY] = 56;
					vars[NV_HIDEDRAW] = 0;
					vars[NV_NOCOLL] = 1;
					
					nsd[DRAWSCALE] = 2;
					nsd[DRAWROTATE] = 0;
					nsd[LHAND_X] = -64;
					nsd[LHAND_Y] = 32;
					nsd[RHAND_X] = 64;
					nsd[RHAND_Y] = 32;
					nsd[LHAND_STATE] = HAND_OPENBACK;
					nsd[RHAND_STATE] = HAND_OPENBACK;
					nsd[LHAND_ANG] = 45;
					nsd[RHAND_ANG] = -45;
					
					nsd[SPECIALDRAW] = SD_BLACKOUT;
					nsd[DRAWLAYER] = 6;
					nsd[TENTACLEAMULT] = 4;
					
					if(k==-1){
						nsd[DRAWROTATE] = -90;
					}
					else{
						nsd[DRAWROTATE] = 90;
					}
					
					int tempSpike[16*3];
					if(j==0){
						m = Rand(2);
						for(i=0; i<7; ++i){
							tempSpike[3*i+0] = Lerp(40, 216, i/6);
							tempSpike[3*i+1] = i%2==m?136:40;
							tempSpike[3*i+2] = i%2==m?-90:90;
						}
					}
					else if(j==1){
						for(i=0; i<10; ++i){
							tempSpike[3*i+0] = 128+VectorX(88, i*36+45*k);
							tempSpike[3*i+1] = 88+VectorY(48, i*36+45*k);
							tempSpike[3*i+2] = 180+i*36;
						}
					}
					else if(j==2){
						m = Rand(2);
						for(i=0; i<7; ++i){
							tempSpike[3*i+0] = 128+k*(i%2==0?88:48);
							tempSpike[3*i+1] = Lerp(40, 136, i/6);
							tempSpike[3*i+2] = k==-1?0:180;
						}
					}
					
					NSRunSpikeHandler(ghost, starBG);
					Game->PlaySound(SFX_NIGHTMARESELET_SWOOSH);
					for(i=0; i<640; i+=16){
						vars[NV_DRAWX] += 16*k;
						
						for(j=0; j<16; ++j){
							if(tempSpike[3*j+0]>0){
								if((k==-1&&tempSpike[3*j+0]>=vars[NV_DRAWX]+32)||k==1&&tempSpike[3*j+0]<=vars[NV_DRAWX]+32){
									e = FireEWeapon(EW_SCRIPT10, tempSpike[3*j+0]-8, tempSpike[3*j+1]-8, DegtoRad(tempSpike[3*j+2]), 0, NSDamage(_DAMAGE_NIGHTMARESELET_SPIKES), SPRITE_INVISIBLE, 0, 0);
									e->CollDetection = false;
									RunEWeaponScript(e, "VoidSpike", {0, 0, 0, 90, 96, 0, 0});
									tempSpike[3*j+0] = 0;
								}
							}
						}
						NSWaitframe(this, ghost, vars, 1);
					}
					NSWaitframe(this, ghost, vars, 120);
				}
				else if(attack==6){ //Fly over (Slash)
					int attackDir[3] = {Rand(4), Rand(4), Rand(4)};
					if(IsEasyMode()){
						if(attackDir[0]>=2)
							attackDir[0] = Rand(2);
						if(attackDir[1]>=2)
							attackDir[1] = Rand(2);
					}
				
					j = Choose(-1, 1);
					
					if(attackDir[1]==attackDir[0])
						attackDir[1] = OppositeDir(attackDir[1]);
					if(attackDir[2]==attackDir[1])
						attackDir[2] = OppositeDir(attackDir[2]);
					
					if(attackDir[0]==DIR_LEFT)
						j = 1;
					else if(attackDir[0]==DIR_RIGHT)
						j = -1;
					
					vars[NV_DRAWX] = 128-32;
					vars[NV_DRAWY] = 176;
					nsd[DRAWSCALE] = 1.5;
					nsd[DRAWROTATE] = 0;
					vars[NV_HIDEDRAW] = 0;
					vars[NV_NOCOLL] = 1;
					
					nsd[LHAND_X] = -64;
					nsd[LHAND_Y] = -32;
					nsd[RHAND_X] = 64;
					nsd[RHAND_Y] = -32;
					nsd[LHAND_STATE] = HAND_OPENBACK;
					nsd[RHAND_STATE] = HAND_OPENBACK;
					nsd[LHAND_ANG] = 45;
					nsd[RHAND_ANG] = -45;
					
					nsd[SPECIALDRAW] = SD_FLIP;
					nsd[DRAWLAYER] = 6;
					nsd[TENTACLEAMULT] = 4;
					
					Game->PlaySound(SFX_NIGHTMARESELET_SWOOSH2);
					k = 80;
					for(i=0; i<k; ++i){
						BezierQuadFrame(xy, i, k, 128-32, 176, 128-32, -64, 128-32+144*j, 0);
						x = xy[0];
						y = xy[1];
						
						vars[NV_DRAWX] = x;
						vars[NV_DRAWY] = y;
						
						if(i<k-1){
							BezierQuadFrame(xy, i+1, k, 128-32, 176, 128-32, -64, 128-32+144*j, 0);
							nsd[DRAWROTATE] = Angle(x, y, xy[0], xy[1])-90;
						}
						nsd[DRAWSCALE] = Lerp(1.5, 0.2, i/k);
						
						if(i==k/2){
							nsd[DRAWLAYER] = 0;
						}
						
						NSWaitframe(this, ghost, vars, 1);
					}
					
					vars[NV_HIDEDRAW] = 1;
					NSWaitframe(this, ghost, vars, 32);
					nsd[DRAWSCALE] = 0.2;
					nsd[SPECIALDRAW] = SD_FLIPBLACKOUT;
					
					int swoops = 3;
					
					for(i=0; i<swoops; ++i){
						vars[NV_HIDEDRAW] = 0;
						Game->PlaySound(SFX_NIGHTMARESELET_SWOOSH2);
						switch(attackDir[i]){
							case DIR_UP:
								vars[NV_DRAWX] = Rand(64, 128);
								vars[NV_DRAWY] = 64;
								nsd[DRAWROTATE] = 180;
								break;
							case DIR_DOWN:
								vars[NV_DRAWX] = Rand(64, 128);
								vars[NV_DRAWY] = -64;
								nsd[DRAWROTATE] = 0;
								break;
							case DIR_LEFT:
								vars[NV_DRAWX] = 256;
								vars[NV_DRAWY] = Rand(-16, 32);
								nsd[DRAWROTATE] = 90;
								break;
							case DIR_RIGHT:
								vars[NV_DRAWX] = -64;
								vars[NV_DRAWY] = Rand(-16, 32);
								nsd[DRAWROTATE] = -90;
								break;
						}
						for(j=0; j<256+64; j+=8){
							vars[NV_DRAWX] += 8*DirX(attackDir[i], 1);
							vars[NV_DRAWY] += 8*DirY(attackDir[i], 1); 
							NSWaitframe(this, ghost, vars, 1);
						}
						NSWaitframe(this, ghost, vars, 32);
					}
					vars[NV_HIDEDRAW] = 1;
					nsd[DRAWLAYER] = 6;
					nsd[LHAND_STATE] = HAND_FIST;
					nsd[RHAND_STATE] = HAND_FIST;
					nsd[LHAND_ANG] = 0;
					nsd[RHAND_ANG] = 0;
					nsd[DRAWSCALE] = 1;
					nsd[SPECIALDRAW] = SD_FLIP;
					
					NSWaitframe(this, ghost, vars, 32);
					for(i=0; i<swoops; ++i){
						switch(attackDir[i]){
							case DIR_UP:
								vars[NV_DRAWX] = Link->X-24;
								vars[NV_DRAWY] = 176+16;
								nsd[DRAWROTATE] = 180;
								break;
							case DIR_DOWN:
								vars[NV_DRAWX] = Link->X-24;
								vars[NV_DRAWY] = -80;
								nsd[DRAWROTATE] = 0;
								break;
							case DIR_LEFT:
								vars[NV_DRAWX] = 256+16;
								vars[NV_DRAWY] = Link->Y-24;
								if(Abs(vars[NV_DRAWY]-72)<16){
									if(vars[NV_DRAWY]<72)
										vars[NV_DRAWY] = 72-16;
									else
										vars[NV_DRAWY] = 72+16;
								}
								nsd[DRAWROTATE] = 90;
								break;
							case DIR_RIGHT:
								vars[NV_DRAWX] = -80;
								vars[NV_DRAWY] = Link->Y-24;
								if(Abs(vars[NV_DRAWY]-72)<16){
									if(vars[NV_DRAWY]<72)
										vars[NV_DRAWY] = 72-16;
									else
										vars[NV_DRAWY] = 72+16;
								}
								nsd[DRAWROTATE] = -90;
								break;
						}
						Screen->D[D_EGGFREEZE] = 1;
						NSWaitframe(this, ghost, vars, 48);
						Game->PlaySound(SFX_NIGHTMARESELET_SWOOSH);
						vars[NV_HIDEDRAW] = 0;
						for(j=0; j<256+80; j+=6){
							vars[NV_DRAWX] += 6*DirX(attackDir[i], 1);
							vars[NV_DRAWY] += 6*DirY(attackDir[i], 1);
							x = vars[NV_DRAWX]+32;
							y = vars[NV_DRAWY]+32;
							MakeHitbox(EW_SCRIPT10, vars[NV_DRAWX], vars[NV_DRAWY], 64, 64, ghost->Damage);
							m = Lerp(0, 720, j/(256+80));
							NSClaw2(eArr, 0, 5, x, y, nsd[DRAWROTATE]+90, nsd[DRAWROTATE]+90+m, Lerp(20, 12, j/(256+80)), NSDamage(_DAMAGE_NIGHTMARESELET_SLASH), 16, 16);
							NSWaitframe(this, ghost, vars, 1);
						}
						Screen->D[D_EGGFREEZE] = 0;
						vars[NV_HIDEDRAW] = 1;
						for(j=0; j<16; ++j){
							NSClaw2(eArr, 0, 5, x, y, nsd[DRAWROTATE]+90, nsd[DRAWROTATE]+90+m, 12, NSDamage(_DAMAGE_NIGHTMARESELET_SLASH), 0, 1);
							NSWaitframe(this, ghost, vars, 1);
						}
					}
					vars[NV_HIDEDRAW] = 1;
					nsd[DRAWROTATE] = 0;
				}
				else if(attack==7){ //Fly over (Shots)
					vars[NV_HIDEDRAW] = 0;
					
					nsd[DRAWSCALE] = 1;
					nsd[DRAWROTATE] = 0;
					nsd[LHAND_X] = -48;
					nsd[LHAND_Y] = -24;
					nsd[RHAND_X] = 48;
					nsd[RHAND_Y] = -24;
					nsd[LHAND_STATE] = HAND_OPENFRONT;
					nsd[RHAND_STATE] = HAND_OPENFRONT;
					nsd[LHAND_ANG] = 45;
					nsd[RHAND_ANG] = -45;
					
					nsd[SPECIALDRAW] = SD_FLIP;
					nsd[DRAWLAYER] = 5;
					nsd[TENTACLEAMULT] = 4;
					
					i = Choose(-1, 1);
					j = Choose(-1, 1);
					k = Choose(0, 1);
					arr[0] = 96+160*i;
					arr[1] = 56+120*j;
					
					if(k){
						arr[2] = 96-160*i;
						arr[3] = 56+120*j;
					}
					else{
						arr[2] = 96+160*i;
						arr[3] = 56-120*j;
					}
					
					arr[4] = 96-160*i;
					arr[5] = 56-120*j;
					
					k = 256;
					Game->PlaySound(SFX_NIGHTMARESELET_SWOOSH);
					int shotFreq = 40;
					if(IsEasyMode())
						shotFreq = 60;
					for(i=0; i<k; ++i){
						if(i==10){
							Game->PlaySound(SFX_CHARGE1);
						}
						
						BezierQuadFrame(xy, i, k, arr[0], arr[1], arr[2], arr[3], arr[4], arr[5]);
						arr[6] = xy[0];
						arr[7] = xy[1];
						if(i<k-1){
							BezierQuadFrame(xy, i+1, k, arr[0], arr[1], arr[2], arr[3], arr[4], arr[5]);
							nsd[DRAWROTATE] = Angle(arr[6], arr[7], xy[0], xy[1])-90;
						}
						
						vars[NV_DRAWX] = arr[6];
						vars[NV_DRAWY] = arr[7];
						
						NSLinkPosInBitmap(vars, xy, 0);
						j = 0;
						if(LargeDistance(256-8, 256+32, xy[0], xy[1], 10)>LargeDistance(256+8, 256+32, xy[0], xy[1], 10))
							j = 1;
						
						NSMoveLHand(vars, -48, -24, 3, 45, 5, false);
						NSMoveRHand(vars, 48, -24, 3, -45, 5, false);
						
						nsd[LHAND_CASTING] = 0;
						nsd[RHAND_CASTING] = 0;
						if(j==0){
							if(i>=10)
								nsd[LHAND_CASTING] = 2;
							ang = Angle(256-8, 256+32, xy[0], xy[1]);
							NSMoveLHand(vars, -8+VectorX(40, ang), VectorY(40, ang), 3, ang-90, 5, false);
							xy[0] = 256+nsd[LHAND_X];
							xy[1] = 256+32+nsd[LHAND_Y];
							NSRotatedPos(vars, xy);
						}
						else{
							if(i>=10)
								nsd[RHAND_CASTING] = 2;
							ang = Angle(256+8, 256+32, xy[0], xy[1]);
							NSMoveRHand(vars, 8+VectorX(40, ang), VectorY(40, ang), 3, ang-90, 5, false);
							xy[0] = 256+nsd[RHAND_X];
							xy[1] = 256+32+nsd[RHAND_Y];
							NSRotatedPos(vars, xy);
						}
						
						if(i%shotFreq==0&&i>=80){
							if(xy[0]-8>0&&xy[0]-8<240&&xy[1]-8>0&&xy[1]-8<160)
								e = FireAimedEWeapon(EW_SCRIPT10, xy[0]-8, xy[1]-8, 0, 300, NSDamage(_DAMAGE_NIGHTMARESELET_FIREBALLS), SPR_COSMICBALL, SFX_COSMICBALL, 0);
						}
						
						NSWaitframe(this, ghost, vars, 1);
					}
					nsd[LHAND_CASTING] = 0;
					nsd[RHAND_CASTING] = 0;
					vars[NV_HIDEDRAW] = 1;
					NSWaitframe(this, ghost, vars, 48);
				}
				else if(attack==8){ //Fly into background (Arrows)
					vars[NV_DRAWX] = 96;
					vars[NV_DRAWY] = 176;
					vars[NV_HIDEDRAW] = 0;
					vars[NV_NOCOLL] = 1;
					
					nsd[DRAWSCALE] = 0.4;
					nsd[DRAWROTATE] = 0;
					nsd[LHAND_X] = -32;
					nsd[LHAND_Y] = 64;
					nsd[RHAND_X] = 32;
					nsd[RHAND_Y] = 64;
					nsd[LHAND_STATE] = HAND_OPENBACK;
					nsd[RHAND_STATE] = HAND_OPENBACK;
					nsd[LHAND_ANG] = 0;
					nsd[RHAND_ANG] = 0;
					
					nsd[SPECIALDRAW] = SD_BLACKOUT;
					nsd[DRAWLAYER] = 0;
					nsd[TENTACLEAMULT] = 4;
					
					Game->PlaySound(SFX_NIGHTMARESELET_SWOOSH2);
					while(vars[NV_DRAWY]>16){
						vars[NV_DRAWY] -= 4;
						NSWaitframe(this, ghost, vars, 1);
					}
					
					nsd[LHAND_STATE] = HAND_OPENFRONT;
					nsd[RHAND_STATE] = HAND_OPENFRONT;
					NSMoveLHand(vars, -64, -32, 3, -45, 5, false);
					NSMoveRHand(vars, 64, -32, 3, 45, 5, false);
					NSWaithands(this, ghost, vars);
					
					Screen->D[D_EGGFREEZE] = 1;
					
					NSWaitframe(this, ghost, vars, 32);
					
					int numArrows = 10;
					if(IsEasyMode())
						numArrows = 6;
					int arrowX[10];
					j = Rand(2);
					for(i=0; i<numArrows; ++i){
						if(i==9){
							if(j==0)
								arrowX[i] = 16+32;
							else
								arrowX[i] = 224-32;
						}
						else{
							if(j==0)
								arrowX[i] = Rand(16+96, 224);
							else
								arrowX[i] = Rand(16, 224-96);
						}
					}
					
					for(i=0; i<numArrows; ++i){
						Game->PlaySound(93);
						for(j=0; j<6; ++j){
							x = vars[NV_DRAWX]+32+Lerp(-32, 32, arrowX[i]/256);
							Screen->Rectangle(0, x-Lerp(2, 0, j/5), 0, x+Lerp(2, 0, j/5), vars[NV_DRAWY]+16, 0x01, 1, 0, 0, 0, true, 128);
							NSWaitframe(this, ghost, vars, 1);
						}
						NSWaitframe(this, ghost, vars, 2+((i==8)?16:0));
					}
					
					nsd[LHAND_STATE] = HAND_OPENBACK;
					nsd[RHAND_STATE] = HAND_OPENBACK;
					NSMoveLHand(vars, -32, -48, 5, 0, 5, false);
					NSMoveRHand(vars, 32, -48, 5, 0, 5, false);
					while(vars[NV_DRAWY]>-64){
						vars[NV_DRAWY] -= 4;
						NSWaitframe(this, ghost, vars, 1);
					}
					NSWaitframe(this, ghost, vars, 48);
					
					for(i=0; i<numArrows; ++i){
						e = FireEWeapon(EW_SCRIPT10, arrowX[i], -16, DegtoRad(90), 800, NSDamage(_DAMAGE_NIGHTMARESELET_ARROWS), SPRITE_INVISIBLE, 78, EWF_UNBLOCKABLE);
						e->CollDetection = false;
						RunEWeaponScript(e, "CosmicArrow", {16, 20, 6.75, 16, 100, 600});
						NSWaitframe(this, ghost, vars, 40+((i==8)?32:0));
					}
					NSWaitframe(this, ghost, vars, 48);
					Screen->D[D_EGGFREEZE] = 0;
					// e = FireEWeapon(EW_SCRIPT10, Rand(16, 224), -16, DegtoRad(90), 600, ghost->WeaponDamage, SPRITE_INVISIBLE, 0, EWF_UNBLOCKABLE);
					// e->CollDetection = false;
					// RunEWeaponScript(e, "CosmicArrow", {16, 9, 15});
					// NSWaitframe(this, ghost, vars, 128);
				}
				else if(attack==9){ //Background slash
					int pattern = Rand(2);
					if(IsEasyMode())
						pattern = 0;
					if(vars[NV_CURRENTCYCLE]==2){
						if(pattern==0&&!IsEasyMode()){
							nsd[HEADTARGETSTATE] = 0;
						}
					}
					else{
						if(pattern==1){
							nsd[HEADTARGETSTATE] = 3;
						}
					}
					nsd[LHAND_STATE] = HAND_GRAB;
					nsd[RHAND_STATE] = HAND_GRAB;
					for(i=0; i<16; ++i){
						NSMoveLHand(vars, Ghost_X+32-40, 68, 8, 0, 5, true);
						NSMoveRHand(vars, Ghost_X+32+40, 68, 8, 0, 5, true);
						--Ghost_Y;
						NSWaitframe(this, ghost, vars, 1);
					}
					nsd[HEADDRAWOVER] = 0;
					for(i=0; i<48; ++i){
						NSMoveLHand(vars, Ghost_X+32-40, 68, 8, 0, 5, true);
						NSMoveRHand(vars, Ghost_X+32+40, 68, 8, 0, 5, true);
						++Ghost_Y;
						NSWaitframe(this, ghost, vars, 1);
					}
					j = 0;
					while(Ghost_Y>-16){
						Ghost_X += (Clamp(Link->X, 48, 208)-(Ghost_X+24))*0.1;
						if(Ghost_Y<=0)
							Ghost_Y -= 1;
						else
							Ghost_Y -= 4;
						if(Ghost_Y<32){
							nsd[LHAND_STATE] = HAND_OPENFRONT;
							nsd[RHAND_STATE] = HAND_OPENFRONT;
							NSMoveLHand(vars, Ghost_X+32-40, Ghost_Y-32, 8, 0, 5, true);
							NSMoveRHand(vars, Ghost_X+32+40, Ghost_Y-32, 8, 0, 5, true);
						}
						else{
							NSMoveLHand(vars, Ghost_X+32-40, 68, 8, 0, 5, true);
							NSMoveRHand(vars, Ghost_X+32+40, 68, 8, 0, 5, true);
						}
						NSWaitframe(this, ghost, vars, 1);
					}
					nsd[LHAND_STATE] = HAND_GRAB;
					nsd[RHAND_STATE] = HAND_GRAB;
					nsd[HEADDRAWOVER] = 1;
					Game->PlaySound(SFX_SELETCLAW);
					j = 0;
					m = 0;
					if(pattern==1)
						m = 1;
					if(m==0)
						j -= 16;
					while(Ghost_Y<56){
						Ghost_Y += 4;
						if(m)
							j += 2;
						NSClaw2(eArr, 0, 3, Ghost_X+24-24+j, Ghost_Y+nsd[LHAND_Y], 90, 90, 40, NSDamage(_DAMAGE_NIGHTMARESELET_SLASH), 16, 16);
						NSClaw2(eArr, 3, 3, Ghost_X+24+24-j, Ghost_Y+nsd[LHAND_Y], 90, 90, 40, NSDamage(_DAMAGE_NIGHTMARESELET_SLASH), 16, 16);
						NSMoveLHand(vars, Ghost_X+32-24, 68, 4, 0, 5, true);
						NSMoveRHand(vars, Ghost_X+32+24, 68, 4, 0, 5, true);
						NSWaitframe(this, ghost, vars, 1);
					}
					y = Ghost_Y+nsd[LHAND_Y];
					for(i=0; i<8; ++i){
						++Ghost_Y;
						y += 8;
						if(m)
							j += 2;
						NSClaw2(eArr, 0, 3, Ghost_X+24-24+j, y, 90, 90, 40, NSDamage(_DAMAGE_NIGHTMARESELET_SLASH), 16, 16);
						NSClaw2(eArr, 3, 3, Ghost_X+24+24-j, y, 90, 90, 40, NSDamage(_DAMAGE_NIGHTMARESELET_SLASH), 16, 16);
						NSMoveLHand(vars, Ghost_X+32-24, 68, 4, 0, 5, true);
						NSMoveRHand(vars, Ghost_X+32+24, 68, 4, 0, 5, true);
						NSWaitframe(this, ghost, vars, 1);
					}
					for(i=0; i<8; ++i){
						--Ghost_Y;
						y += 8;
						if(m)
							j += 2;
						NSClaw2(eArr, 0, 3, Ghost_X+24-24+j, y, 90, 90, 40, NSDamage(_DAMAGE_NIGHTMARESELET_SLASH), 16, 16);
						NSClaw2(eArr, 3, 3, Ghost_X+24+24-j, y, 90, 90, 40, NSDamage(_DAMAGE_NIGHTMARESELET_SLASH), 16, 16);
						NSMoveLHand(vars, Ghost_X+32-24, 68, 4, 0, 5, true);
						NSMoveRHand(vars, Ghost_X+32+24, 68, 4, 0, 5, true);
						NSWaitframe(this, ghost, vars, 1);
					}
					if(vars[NV_CURRENTCYCLE]==2){
						nsd[HEADTARGETSTATE] = 3;
					}
					else{
						nsd[HEADTARGETSTATE] = 0;
					}
					for(i=0; i<16; ++i){
						y += 8;
						if(m)
							j += 2;
						NSClaw2(eArr, 0, 3, Ghost_X+24-24+j, y, 90, 90, 40, NSDamage(_DAMAGE_NIGHTMARESELET_SLASH), 16, 16);
						NSClaw2(eArr, 3, 3, Ghost_X+24+24-j, y, 90, 90, 40, NSDamage(_DAMAGE_NIGHTMARESELET_SLASH), 16, 16);
						NSWaitframe(this, ghost, vars, 1);
					}
					for(i=0; i<16; ++i){
						y += 8;
						if(m)
							j += 2;
						NSClaw2(eArr, 0, 3, Ghost_X+24-24+j, y, 90, 90, 40, NSDamage(_DAMAGE_NIGHTMARESELET_SLASH), 0, 1);
						NSClaw2(eArr, 3, 3, Ghost_X+24+24-j, y, 90, 90, 40, NSDamage(_DAMAGE_NIGHTMARESELET_SLASH), 0, 1);
						NSWaitframe(this, ghost, vars, 1);
					}
				}
				else if(attack==10){ //Thunder balls
					k = (Ghost_X<96)?1:-1;
					m = 1;
					if(IsEasyMode())
						m = 0;
					for(i=0; i<3; ++i){
						if(k==-1){
							nsd[LHAND_STATE] = HAND_OPENFRONT;
							NSMoveLHand(vars, -Rand(32, 64), Rand(-48, 0), 4, -Rand(30, 60), 5, false);
						}
						else{
							nsd[RHAND_STATE] = HAND_OPENFRONT;
							NSMoveRHand(vars, Rand(32, 64), Rand(-48, 0), 4, Rand(30, 60), 5, false);
						}
						NSWaitframe(this, ghost, vars, 8);
						if(k==-1)
							nsd[LHAND_CASTING] = 2;
						else
							nsd[RHAND_CASTING] = 2;
						NSWaithands(this, ghost, vars);
						NSWaitframe(this, ghost, vars, 32);
						if(k==-1){
							eweapon e = FireAimedEWeapon(EW_STELLAR, NSHandX(nsd, 0), NSHandY(nsd, 0), 0, 300, NSDamage(_DAMAGE_NIGHTMARESELET_LIGHTNING), SPR_STELLARLIGHTNING2, 32, EWF_UNBLOCKABLE);
							if(i==1)
								e->Angle = DegtoRad(Angle(e->X, e->Y, 120, 80)-45);
							e->Extend = 3;
							e->DrawXOffset = -8;
							e->DrawYOffset = -8;
							e->TileWidth = 2;
							e->TileHeight = 2;
							e->HitXOffset = -4;
							e->HitYOffset = -4;
							e->HitWidth = 24;
							e->HitHeight = 24;
							RunEWeaponScript(e, "StellarLightning", {1});
							if(m)
								e->InitD[2] = 1;
							nsd[LHAND_CASTING] = 0;
							ang = Angle(Link->X+8, Link->Y+8, NSHandX(nsd, 0), NSHandY(nsd, 0));
							NSMoveLHand(vars, nsd[LHAND_X]+VectorX(16, ang), nsd[LHAND_Y]+VectorY(16, ang), 4, -1000, 0, false);
						}
						else{
							eweapon e = FireAimedEWeapon(EW_STELLAR, NSHandX(nsd, 1), NSHandY(nsd, 1), 0, 300, NSDamage(_DAMAGE_NIGHTMARESELET_LIGHTNING), SPR_STELLARLIGHTNING2, 32, EWF_UNBLOCKABLE);
							if(i==1)
								e->Angle = DegtoRad(Angle(e->X, e->Y, 120, 80)+45);
							e->Extend = 3;
							e->DrawXOffset = -8;
							e->DrawYOffset = -8;
							e->TileWidth = 2;
							e->TileHeight = 2;
							e->HitXOffset = -4;
							e->HitYOffset = -4;
							e->HitWidth = 24;
							e->HitHeight = 24;
							RunEWeaponScript(e, "StellarLightning", {1});
							if(m)
								e->InitD[2] = 1;
							nsd[RHAND_CASTING] = 0;
							ang = Angle(Link->X+8, Link->Y+8, NSHandX(nsd, 1), NSHandY(nsd, 1));
							NSMoveRHand(vars, nsd[RHAND_X]+VectorX(16, ang), nsd[RHAND_Y]+VectorY(16, ang), 4, -1000, 0, false);
						}
						NSWaitframe(this, ghost, vars, 8);
					}
					nsd[LHAND_STATE] = HAND_GRAB;
					nsd[RHAND_STATE] = HAND_GRAB;
					NSMoveLHand(vars, Ghost_X+32-24, 68, 4, 0, 5, true);
					NSMoveRHand(vars, Ghost_X+32+24, 68, 4, 0, 5, true);
					NSWaithands(this, ghost, vars);
				}
				else if(attack==11){ //Megalaser
					vars[NV_CLAWANIM] = 0;
					x = -1000;
					if(Rand(2)==0)
						x = 120+(120-Link->X);
					for(i=0; i<60; ++i){
						if(i%12==0)
							Game->PlaySound(141);
						if(x>-1000){
							if(Abs((Ghost_X+24)-x)>8){
								Ghost_X += 2*Sign(x-(Ghost_X+24));
								Ghost_X = Clamp(Ghost_X, 32, 160);
							}
						}
						else{
							if(Abs((Ghost_X+24)-Link->X)>8){
								Ghost_X += 2*Sign(Link->X-(Ghost_X+24));
								Ghost_X = Clamp(Ghost_X, 32, 160);
							}
						}
						NSClawMove(vars);
						
						NSWaitframe(this, ghost, vars, 1);
					}
					NSMoveLHand(vars, Ghost_X+32-48, 68, 4, 0, 5, true);
					NSMoveRHand(vars, Ghost_X+32+48, 68, 4, 0, 5, true);
					for(i=0; i<8; ++i){
						nsd[HEADANGLE] = TurnToAngle(nsd[HEADANGLE], Angle(Ghost_X+32, Ghost_Y-16, Link->X+8, Link->Y+8), 4);
						++Ghost_Y;
						NSWaitframe(this, ghost, vars, 1);
					}
					for(i=0; i<96; ++i){
						if(i%40==0){
							arr[(i/40)*2+0] = Link->X;
							arr[(i/40)*2+1] = Link->Y;
							for(j=0; j<3; ++j){
								e = FireAimedEWeapon(EW_SCRIPT10, NSHeadX(nsd)-8+Rand(-16, 16), NSHeadY(nsd)-8+Rand(-16, 16), 0, Rand(300, 400), NSDamage(_DAMAGE_NIGHTMARESELET_FIREBALLS), SPR_COSMICBALL2, SFX_COSMICBALL, EWF_UNBLOCKABLE);
							}
							x = Ghost_X;
							y = Ghost_Y;
							for(j=0; j<8; ++j){
								Ghost_X = x-VectorX(8*Sin(Lerp(0, 180, j/7)), nsd[HEADANGLE]);
								Ghost_Y = y-VectorY(8*Sin(Lerp(0, 180, j/7)), nsd[HEADANGLE]);
								
								NSMoveLHand(vars, x+32-48, 68, 10, 0, 5, true);
								NSMoveRHand(vars, x+32+48, 68, 10, 0, 5, true);
								NSWaitframe(this, ghost, vars, 1);
							}
							Ghost_X = x;
							Ghost_Y = y;
							NSMoveLHand(vars, x+32-48, 68, 10, 0, 5, true);
							NSMoveRHand(vars, x+32+48, 68, 10, 0, 5, true);	
						}
						nsd[HEADANGLE] = TurnToAngle(nsd[HEADANGLE], Angle(Ghost_X+32, Ghost_Y-16, Link->X+8, Link->Y+8), 4);
						NSWaitframe(this, ghost, vars, 1);
					}
					arr[14] = (((arr[0]+arr[2]+arr[4])/3)+Link->X)/2;
					arr[15] = (((arr[1]+arr[3]+arr[5])/3)+Link->Y)/2;
					for(i=0; i<3; ++i){
						for(j=0; j<4; ++j){
							arr[j*2+0] = Rand(360);
							arr[j*2+1] = Rand(16, 24);
						}
						Game->PlaySound(SFX_CHARGE2);
						for(j=0; j<12; ++j){
							for(k=0; k<4; ++k){
								x = NSHeadX(nsd)+VectorX(Lerp(24, 0, j/11), arr[k*2+0]); 
								y = NSHeadY(nsd)+VectorY(Lerp(24, 0, j/11), arr[k*2+0]); 
								Screen->Circle(4, x, y, Lerp(4, 0, j/11), 0x01, 1, 0, 0, 0, true, 128);
							}
							nsd[HEADANGLE] = TurnToAngle(nsd[HEADANGLE], Angle(Ghost_X+32, Ghost_Y-16, arr[14]+8, arr[15]+8), 4);
							NSWaitframe(this, ghost, vars, 1);
						}
					}
					e = FireEWeapon(EW_SCRIPT10, NSHeadX(nsd)-8, NSHeadY(nsd)-8, 0, 0, NSDamage(_DAMAGE_NIGHTMARESELET_MEGALASER), SPRITE_INVISIBLE, 0, 0);
					e->CollDetection = false;
					RunEWeaponScript(e, "MegaLaser", {16, 128, nsd[HEADANGLE], 8, 64, 40});
					Game->PlaySound(37);
					x = Ghost_X;
					y = Ghost_Y;
					while(e->isValid()){
						Ghost_X = x + Rand(-2, 2);
						Ghost_Y = y + Rand(-2, 2);
						NSMoveLHand(vars, x+32-48, 68, 10, 0, 5, true);
						NSMoveRHand(vars, x+32+48, 68, 10, 0, 5, true);
						NSWaitframe(this, ghost, vars, 1);
					}
					Ghost_X = x;
					Ghost_Y = y;
					for(i=0; i<8; ++i){
						--Ghost_Y;
						NSMoveLHand(vars, Ghost_X+32-48, 68, 10, 0, 5, true);
						NSMoveRHand(vars, Ghost_X+32+48, 68, 10, 0, 5, true);	
						nsd[HEADANGLE] = TurnToAngle(nsd[HEADANGLE], 90, 10);
						NSWaitframe(this, ghost, vars, 1);
					}
					nsd[HEADANGLE] = 90;
				}
				else if(attack==12){ //Mega slash
					bool phaseTransition;
					vars[NV_NOCOLL] = 0;
					if(vars[NV_PHASE]==1){
						phaseTransition = true;
						nsd[HEADDRAWOVER] = 0;
						nsd[HANDSDRAWOVER] = 0;
						vars[NV_HIDEDRAW] = 0;
						Ghost_X = 96;
						Ghost_Y = 0;
						
						Game->PlaySound(SFX_NIGHTMARESELET_SWOOSH);
						x = Choose(-80, 256+16);
						y = 56;
						nsd[LHAND_X] -48;
						nsd[LHAND_Y] = 32;
						nsd[LHAND_ANG] = 45;
						nsd[LHAND_STATE] = HAND_OPENFRONT;
						nsd[RHAND_X] = 48;
						nsd[RHAND_Y] = 32;
						nsd[RHAND_ANG] = -45;
						nsd[RHAND_STATE] = HAND_OPENFRONT;
						nsd[DRAWSCALE] = 0.5;
						nsd[DRAWLAYER] = 0;
						
						NSMoveLHand(vars, -16, -16, 2, -45, 4, false);
						NSMoveRHand(vars, 16, -16, 2, 45, 4, false);
						for(i=0; i<48; ++i){
							BezierQuadFrame(xy, i, 48, x, y, 96, 56, 96, 0);
							arr[0] = xy[0];
							arr[1] = xy[1];
							if(i<47){
								BezierQuadFrame(xy, i+1, 48, x, y, 96, 56, 96, 0);
								nsd[DRAWROTATE] = Angle(arr[0], arr[1], xy[0], xy[1])+90;
							}
							vars[NV_DRAWX] = arr[0];
							vars[NV_DRAWY] = arr[1];
							NSWaitframe(this, ghost, vars, 1);
						}
						nsd[LHAND_STATE] = HAND_CLAW;
						nsd[RHAND_STATE] = HAND_CLAW;
						vars[NV_DRAWX] = -10000;
						vars[NV_DRAWY] = -10000;
						nsd[DRAWROTATE] = 0;
					}
					else{
						nsd[HEADDRAWOVER] = 0;
						nsd[HANDSDRAWOVER] = 0;
						
						nsd[LHAND_STATE] = HAND_CLAW;
						nsd[RHAND_STATE] = HAND_CLAW;
						dist = Distance(Ghost_X, Ghost_Y, 96, 0);
						x = Ghost_X;
						y = Ghost_Y;
						
						NSMoveLHand(vars, -16, -16, 2, -45, 4, false);
						NSMoveRHand(vars, 16, -16, 2, 45, 4, false);
						Game->PlaySound(SFX_NIGHTMARESELET_SWOOSH);
						for(i=0; i<64; ++i){
							Ghost_X = Lerp(x, 96, i/63);
							Ghost_Y = Lerp(y, 0, i/63)+32*Sin(i/63*180);
							nsd[DRAWSCALE] = Lerp(1, 0.5, i/63);
							NSWaitframe(this, ghost, vars, 1);
						}
					}
					NSMoveLHand(vars, -56, -24, 2, -45, 4, false);
					NSMoveRHand(vars, 56, -24, 2, 45, 4, false);
					for(i=0; i<64; ++i){
						if(i<32){
							if(!IsEasyMode()||i==0){
								arr[0] = Clamp(Link->X-24, 32, 160);
								arr[1] = 56;
								arr[2] = Link->Y;
							}
						}
						Screen->DrawCombo(2, arr[0]+16, arr[2]-8, 51951, 2, 2, 7, -1, -1, 0, 0, 0, -1, 0, true, 128);
						Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, arr[0], arr[1]), Lerp(0, 0.5, i/63), 0);
						NSWaitframe(this, ghost, vars, 1);
					}
					x = Ghost_X;
					y = Ghost_Y;
					NSMoveLHand(vars, -24, 16, 2, 0, 4, false);
					NSMoveRHand(vars, 24, 16, 2, 0, 4, false);
					nsd[SPECIALDRAW] = SD_FLIP;
					nsd[DRAWROTATE] = Angle(Ghost_X, Ghost_Y, arr[0], arr[1])-90;
					Game->PlaySound(SFX_NIGHTMARESELET_SWOOSH2);
					for(i=0; i<40; ++i){
						Screen->DrawCombo(2, arr[0]+16, arr[2]-8, 51951, 2, 2, 7, -1, -1, 0, 0, 0, -1, 0, true, 128);
						Ghost_X = Lerp(x, arr[0], i/39);
						Ghost_Y = Lerp(y, arr[1], i/39)+16*Sin(i/39*180);
						nsd[DRAWSCALE] = Lerp(0.5, 1, i/39);
						NSWaitframe(this, ghost, vars, 1);
					}
					nsd[HEADDRAWOVER] = 2;
					nsd[DRAWROTATE] = 0;
					nsd[SPECIALDRAW] = SD_BG;
					k = Angle(Ghost_X+24, Ghost_Y+24, Link->X, Link->Y);
					for(i=0; i<360; i+=2){
						if(i%20==0){
							NSMoveLHand(vars, Rand(-32, 32), Rand(-32, 32), 10, -45+Rand(-25, 25), 10, false);
							NSMoveRHand(vars, Rand(-32, 32), Rand(-32, 32), 10, 45+Rand(-25, 25), 10, false);
						}
						if(i%30==0)
							Game->PlaySound(SFX_SELETCLAW);
						x = Ghost_X+24+VectorX(48*Sin(10*i), i+k);
						y = Ghost_Y+40+VectorY(48*Sin(10*i), i+k);
						ang = -90+i*10+k;//Angle(VectorX(48*Sin(10*i), i), VectorY(48*Sin(10*i), i), VectorX(48*Sin(10*(i-2)), i-2), VectorY(48*Sin(10*(i-2)), i-2));
						NSClaw2(eArr, 0, 5, x, y, ang, ang, 20, NSDamage(_DAMAGE_NIGHTMARESELET_SLASH), 16, 16);
						NSWaitframe(this, ghost, vars, 1);
					}
					if(vars[NV_CURRENTCYCLE]<2&&Game->Counter[CR_BOMBS]==0){
						npc n = CreateNPCAt(NPC_NIGHTMARESELETSUMMON, Ghost_X+24+Rand(-4, 4), Ghost_Y+Rand(-4, 4));
						n->InitD[0] = Rand(32, 208);
						n->InitD[1] = Rand(64, 128);
						n->InitD[2] = Rand(15, 25)/10;
						n->InitD[3] = 3; //Bomb Ammo
					}
					nsd[LHAND_STATE] = HAND_GRAB;
					nsd[RHAND_STATE] = HAND_GRAB;
					NSMoveLHand(vars, Ghost_X+32-24, 68, 10, 0, 10, true);
					NSMoveRHand(vars, Ghost_X+32+24, 68, 10, 0, 10, true);
					for(i=0; i<16; ++i){
						NSClaw2(eArr, 0, 5, x, y, ang, ang, 20, NSDamage(_DAMAGE_NIGHTMARESELET_SLASH), 0, 1);
						NSWaitframe(this, ghost, vars, 1);
					}
					NSWaithands(this, ghost, vars);
					nsd[HANDSDRAWOVER] = 2;
					vars[NV_PHASE] = 2;
					if(phaseTransition){
						vars[NV_EGGSTATE] = EGG_INACTIVE;
						vars[NV_EGGY] = -32;
						
						vars[NV_PHASE3HP] = HP_NIGHTMARESELET_PHASE3*EasyModeMultiplier(0.8);						
						SetAllDefenses(hitbox[HITBOX_HEAD], NPCDT_BLOCK);
						hitbox[HITBOX_HEAD]->Defense[NPCD_BOMB] = NPCDT_NONE;
						hitbox[HITBOX_HEAD]->Defense[NPCD_STARWANDIMPACT] = NPCDT_HALFDAMAGE;
						
						
						nsd[TENTACLEAMULT] = 1;
					}
				}
				else if(attack==100){ //Fly Off
					vars[NV_ASTEROIDTIMER] = 0;
					vars[NV_ASTEROIDTIMER2] = 0;
					
					Screen->D[D_EGGPHASE] = vars[NV_CURRENTCYCLE];
						
					nsd[LHAND_STATE] = HAND_CLAW;
					nsd[RHAND_STATE] = HAND_CLAW;
					NSMoveLHand(vars, -24, 24, 2, -90, 2, false);
					NSMoveRHand(vars, 24, 24, 2, 90, 2, false);
					NSWaithands(this, ghost, vars);
					vars[NV_EGGSTATE] = EGG_STATIONARY;
					while(Distance(vars[NV_EGGX], vars[NV_EGGY], Ghost_X+24, Ghost_Y+32)>2){
						ang = Angle(vars[NV_EGGX], vars[NV_EGGY], Ghost_X+24, Ghost_Y+32);
						vars[NV_EGGX] += VectorX(2, ang);
						vars[NV_EGGY] += VectorY(2, ang);
						NSWaitframe(this, ghost, vars, 1);
					}
					vars[NV_EGGX] = Ghost_X+24;
					vars[NV_EGGY] = Ghost_Y+32;
					Game->PlaySound(74);
					for(i=0; i<64; ++i){
						NSMoveLHand(vars, -24+Rand(-1, 1), 24+Rand(-1, 1), 2, -90+Rand(-10, 10), 2, false);
						NSMoveRHand(vars, 24+Rand(-1, 1), 24+Rand(-1, 1), 2, 90+Rand(-10, 10), 2, false);
						vars[NV_EGGX] = Ghost_X+24+Rand(-1, 1);
						vars[NV_EGGY] = Ghost_Y+32+Lerp(0, -4, i/64)+Rand(-1, 1);
						NSWaitframe(this, ghost, vars, 1);
					}
					NSMoveLHand(vars, -40, 24, 2, -90, 2, false);
					NSMoveRHand(vars, 40, 24, 2, 90, 2, false);
					nsd[LHAND_STATE] = HAND_FIST;
					nsd[RHAND_STATE] = HAND_FIST;
					vars[NV_EGGX] = Ghost_X+24;
					vars[NV_EGGY] = Ghost_Y+28;
					
					npc n = CreateNPCAt(NPC_NIGHTMARESELETSUMMON, Ghost_X+24+Rand(-4, 4), Ghost_Y+28+Rand(-4, 4));
					n->InitD[0] = Rand(32, 112);
					n->InitD[1] = Rand(64, 128);
					n->InitD[2] = Rand(15, 25)/10;
					n->InitD[3] = 1; //Magic Jar (Large)
					if(vars[NV_CURRENTCYCLE]==1)
						n->InitD[3] = 0; //Heart
					
					n = CreateNPCAt(NPC_NIGHTMARESELETSUMMON, Ghost_X+24+Rand(-4, 4), Ghost_Y+28+Rand(-4, 4));
					n->InitD[0] = Rand(128, 208);
					n->InitD[1] = Rand(64, 128);
					n->InitD[2] = Rand(15, 25)/10;
					n->InitD[3] = 2; //Magic Jar (Small)
					if(vars[NV_CURRENTCYCLE]==1)
						n->InitD[3] = 0; //Heart
					
					vars[NV_EGGSTATE] = EGG_LAUNCH;
					SetAllDefenses(hitbox[HITBOX_EGG], NPCDT_BLOCK);
					Game->PlaySound(84);
					while(vars[NV_EGGSTATE]!=EGG_SCRIPTMANAGED){
						NSWaitframe(this, ghost, vars, 1);
					}
					SetAllDefenses(hitbox[HITBOX_EGG], NPCDT_NONE);
					nsd[LHAND_STATE] = HAND_OPENBACK;
					nsd[RHAND_STATE] = HAND_OPENBACK;
					NSMoveLHand(vars, -48, 48, 4, 45, 10, false);
					NSMoveRHand(vars, 48, 48, 4, -45, 10, false);
					NSWaithands(this, ghost, vars);
					Game->PlaySound(SFX_NIGHTMARESELET_SWOOSH);
					nsd[DRAWLAYER] = 4;
					nsd[SPECIALDRAW] = SD_BG;
					vars[NV_DRAWX] = Ghost_X;
					vars[NV_DRAWY] = Ghost_Y;
					while(vars[NV_DRAWY]>-128){
						vars[NV_DRAWY] -= 8;
						NSWaitframe(this, ghost, vars, 1);
					}
				}
				else if(attack==101){ //Meteor Super
					vars[NV_DRAWX] = 96;
					vars[NV_DRAWY] = 176;
					vars[NV_HIDEDRAW] = 0;
					vars[NV_NOCOLL] = 1;
					
					nsd[DRAWSCALE] = 0.5;
					nsd[DRAWROTATE] = 0;
					nsd[LHAND_X] = -64;
					nsd[LHAND_Y] = 8;
					nsd[RHAND_X] = 64;
					nsd[RHAND_Y] = 8;
					nsd[LHAND_STATE] = HAND_OPENBACK;
					nsd[RHAND_STATE] = HAND_OPENBACK;
					nsd[LHAND_ANG] = 0;
					nsd[RHAND_ANG] = 0;
					
					nsd[SPECIALDRAW] = SD_BLACKOUT;
					nsd[DRAWLAYER] = 0;
					nsd[TENTACLEAMULT] = 4;
					
					Screen->D[D_EGGCONTROL] = 2;
					while(Screen->D[D_EGGCONTROL]==2){
						NSWaitframe(this, ghost, vars, 1);
					}
					vars[NV_EGGSTATE] = EGG_FOLLOW;
					vars[NV_EGGTX] = 120;
					vars[NV_EGGTY] = -32;
					NSDetatchLockon(hitbox[HITBOX_EGG]);
					
					Game->PlaySound(SFX_NIGHTMARESELET_SWOOSH2);
					while(vars[NV_DRAWY]>32){
						vars[NV_DRAWY] -= 4;
						NSWaitframe(this, ghost, vars, 1);
					}
					
					nsd[LHAND_STATE] = HAND_OPENFRONT;
					nsd[RHAND_STATE] = HAND_OPENFRONT;
					NSMoveLHand(vars, -32, -48, 3, -45, 5, false);
					NSMoveRHand(vars, 32, -48, 3, 45, 5, false);
					NSWaithands(this, ghost, vars);
					
					k = 0;
					for(i=0; i<240; ++i){
						j = 0x01;
						
						if(i%60==0){
							if(i<180)
								Game->PlaySound(SFX_CHARGE1);
							else
								Game->PlaySound(SFX_CHARGE2);
							++k;
						}
						
						if(i>=30&&i<42){
							j = 0x0F;
							if(i==30)
								Game->PlaySound(77);
							if(i<38)
								Screen->Rectangle(0, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 128);
							else
								Screen->Rectangle(0, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 64);
						}
						if(i>=120&&i<132){
							j = 0x0F;
							if(i==120)
								Game->PlaySound(77);
							if(i<128)
								Screen->Rectangle(0, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 128);
							else
								Screen->Rectangle(0, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 64);
						}
						if(i>=140&&i<152){
							j = 0x0F;
							if(i==140)
								Game->PlaySound(77);
							if(i<148)
								Screen->Rectangle(0, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 128);
							else
								Screen->Rectangle(0, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 64);
						}	
						
						m = (i/240)*0.5+(k/4)*0.5;
						Screen->Circle(2, 128+Rand(-1, 1), Lerp(32, 0, i/240)+Rand(-1, 1), i%6<4?Lerp(0, 32, m):Lerp(8, 34, m), j, 1, 0, 0, 0, true, 128);
						
						NSWaitframe(this, ghost, vars, 1);
					}
					Game->PlaySound(SFX_NIGHTMARESELET_SWOOSH);
					for(i=0; i<48; ++i){
						Screen->Circle(2, 128+Rand(-1, 1), 0-i*4, i%6<4?32:34, j, 1, 0, 0, 0, true, 128);
						vars[NV_DRAWY] -= 4;
						NSWaitframe(this, ghost, vars, 1);
					}
					vars[NV_HIDEDRAW] = 1;
					Game->PlaySound(136);
					Game->PlaySound(SFX_NIGHTMARESELET_SWOOSH2);
					
					e = FireEWeapon(EW_SCRIPT10, 120, 88, 0, 0, 0, SPRITE_INVISIBLE, 0, 0);
					e->CollDetection = false;
					if(vars[NV_CURRENTCYCLE]==0)
						i = RunFFCScript(Game->GetFFCScript("NSMeteorSuper"), {0.1, 0});
					else
						i = RunFFCScript(Game->GetFFCScript("NSMeteorSuper"), {0.2, 1});
					ffc meteor = Screen->LoadFFC(i);
					while(meteor->Script>0){
						NSWaitframe(this, ghost, vars, 1);
					}
					
					vars[NV_DRAWX] = 96;
					vars[NV_DRAWY] = -80;
					vars[NV_HIDEDRAW] = 0;
					vars[NV_NOCOLL] = 1;
					
					nsd[DRAWSCALE] = 1;
					nsd[DRAWROTATE] = 0;
					nsd[LHAND_X] = -16;
					nsd[LHAND_Y] = -48;
					nsd[RHAND_X] = 16;
					nsd[RHAND_Y] = -48;
					nsd[LHAND_STATE] = HAND_OPENFRONT;
					nsd[RHAND_STATE] = HAND_OPENFRONT;
					nsd[LHAND_ANG] = 0;
					nsd[RHAND_ANG] = 0;
					
					nsd[SPECIALDRAW] = SD_BG;
					nsd[DRAWLAYER] = 0;
					nsd[TENTACLEAMULT] = 4;
					
					nsd[HEADDRAWOVER] = 2;
					
					vars[NV_EGGSTATE] = EGG_INACTIVE;
					vars[NV_EGGY] = -32;
					if(vars[NV_CURRENTCYCLE]<2)
						Game->PlaySound(SFX_NIGHTMARESELET_MASKCRACK);
					while(vars[NV_DRAWY]<56){
						vars[NV_DRAWY] += 4;
						NSWaitframe(this, ghost, vars, 1);
					}
					++nsd[FACECRACKED];
					nsd[FACECRACKED] = Clamp(nsd[FACECRACKED], 0, 4);
					if(nsd[FACECRACKED]==4){
						nsd[HEADTARGETSTATE] = 3;
						RunEWeaponEffect(NSHeadX(nsd)-8, NSHeadY(nsd)-8, "GenParticle", {GP_MASKSHARDS});
						Game->PlaySound(SFX_NIGHTMARESELET_MASKSMASH);
					}
					nsd[HEADANGLE] = 135;
					Screen->Quake = 10;
					Game->PlaySound(SFX_BOMB);
					vars[NV_NOCOLL] = 0;
					if(vars[NV_CURRENTCYCLE]==2){
						vars[NV_PHASE3HP] = HP_NIGHTMARESELET_PHASE3B*EasyModeMultiplier(0.8);
						SetAllDefenses(hitbox[HITBOX_HEAD], NPCDT_NONE);
					}
					else{
						vars[NV_PHASE3HP] = HP_NIGHTMARESELET_PHASE3*EasyModeMultiplier(0.8);						
						SetAllDefenses(hitbox[HITBOX_HEAD], NPCDT_BLOCK);
						hitbox[HITBOX_HEAD]->Defense[NPCD_BOMB] = NPCDT_NONE;
						hitbox[HITBOX_HEAD]->Defense[NPCD_STARWANDIMPACT] = NPCDT_HALFDAMAGE;
					}
					vars[NV_PHASE] = 2;
					
					Ghost_X = vars[NV_DRAWX];
					Ghost_Y = vars[NV_DRAWY];
					vars[NV_DRAWX] = -10000;
					vars[NV_DRAWY] = -10000;
					
					nsd[LHAND_STATE] = HAND_GRAB;
					nsd[RHAND_STATE] = HAND_GRAB;
					nsd[HANDSDRAWOVER] = 2;
					
					NSMoveLHand(vars, Ghost_X+32-48, 68, 3, -1000, 0, true);
					NSMoveRHand(vars, Ghost_X+32+48, 68, 3, -1000, 0, true);
					k = 4;
					if(vars[NV_CURRENTCYCLE]==2)
						k = 3;
					for(i=0; i<k; ++i){
						npc n = CreateNPCAt(NPC_NIGHTMARESELETSUMMON, Ghost_X+24+Rand(-4, 4), Ghost_Y+Rand(-4, 4));
						n->InitD[0] = Rand(32, 208); //112
						n->InitD[1] = Rand(64, 128);
						n->InitD[2] = Rand(15, 25)/10;
						n->InitD[3] = 0; //Heart
						if(i==0)
							n->InitD[3] = 4; //Heart x3
						if(i==3)
							n->InitD[3] = 3; //Bomb Ammo
						
						// n = CreateNPCAt(NPC_NIGHTMARESELETSUMMON, Ghost_X+24+Rand(-4, 4), Ghost_Y+Rand(-4, 4));
						// n->InitD[0] = Rand(128, 208);
						// n->InitD[1] = Rand(64, 128);
						// n->InitD[2] = Rand(15, 25)/10;
						// n->ItemSet = 17;
						// if(i==2)
							// n->ItemSet = 18;
						
						NSWaitframe(this, ghost, vars, 16);
					}
					NSWaithands(this, ghost, vars);
					
					k = vars[NV_PHASE3HP];
					nsd[TENTACLEAMULT] = 1;
					for(i=0; i<300&&vars[NV_PHASE3HP]>=k; ++i){//vars[NV_PHASE3HP]>=k){
						NSWaitframe(this, ghost, vars, 1);
					}
					if(i<300){
						if(vars[NV_CURRENTCYCLE]==0){
							for(i=0; i<300; ++i){
								NSWaitframe(this, ghost, vars, 1);
							}
						}
						else{
							for(i=0; i<300&&vars[NV_PHASE3HP]>=k*0.5; ++i){
								NSWaitframe(this, ghost, vars, 1);
							}
						}
					}
					
					// nsd[HEADDRAWOVER] = 0;
					// nsd[HANDSDRAWOVER] = 0;
					
					for(i=0; i<12; ++i){
						nsd[HEADANGLE] = Lerp(135, 90, (i/12));
						NSWaitframe(this, ghost, vars, 1);
					}
					nsd[HEADANGLE] = 90;
				}
				else if(attack==102){ //Fly to FG
					nsd[LHAND_STATE] = HAND_OPENBACK;
					nsd[RHAND_STATE] = HAND_OPENBACK;
					NSMoveLHand(vars, -24, -16, 2, 0, 4, false);
					NSMoveRHand(vars, 24, -16, 2, 0, 4, false);
					Game->PlaySound(SFX_NIGHTMARESELET_SWOOSH);
					while(Ghost_Y>-48){
						Ghost_Y -= 3;
						NSWaitframe(this, ghost, vars, 1);
					}
					nsd[HEADDRAWOVER] = 0;
					nsd[HANDSDRAWOVER] = 0;
					nsd[DRAWLAYER] = 2;
					NSMoveLHand(vars, -40, 8, 2, 0, 4, false);
					NSMoveRHand(vars, 40, 8, 2, 0, 4, false);
					while(Ghost_Y<24){
						if(Ghost_Y>-24){
							nsd[SPECIALDRAW] = SD_FG;
							nsd[TAILCLIPOFFSET] = 24-Ghost_Y;
						}
						Ghost_Y += 2;
						NSWaitframe(this, ghost, vars, 1);
					}
					nsd[TAILCLIPOFFSET] = 0;
					nsd[SPECIALDRAW] = SD_FG;
					
					vars[NV_PHASE] = 0;
					++vars[NV_CURRENTCYCLE];
					vars[NV_HP] = HP_NIGHTMARESELET_PHASE1*EasyModeMultiplier(0.8);
					
					vars[NV_EGGX] = 120;
					vars[NV_EGGY] = -32;
					vars[NV_EGGTX] = Ghost_X+Rand(48);
					vars[NV_EGGTY] = Ghost_Y+Rand(48);
					vars[NV_EGGSTATE] = EGG_FOLLOW;
				}
				else if(attack==103){ //Do Nothing
					
				}
				if(vars[NV_PHASE]==1){
					k = 96;
					if(vars[NV_CURRENTCYCLE]==2)
						k = 64;
					k += Rand(8);
				}
				else{	
					k = 64;
					if(vars[NV_CURRENTCYCLE]==1)
						k = 48;
					else if(vars[NV_CURRENTCYCLE]==2)
						k = 32;
					k += Rand(8);
				}
				NSWaitframe(this, ghost, vars, k+EasyModeFrames(32)-SPFrames(24));
			}
		}
		int NSHandX(untyped nsd, int hand){
			if(hand==0)return nsd[LHAND_X]+(Ghost_X+32);
			if(hand==1)return nsd[RHAND_X]+(Ghost_X+32);
		}
		int NSHandY(untyped nsd, int hand){
			if(hand==0)return nsd[LHAND_Y]+Ghost_Y;
			if(hand==1)return nsd[RHAND_Y]+Ghost_Y;
		}
		int NSHeadX(untyped nsd){
			int x = Ghost_X;
			return x+16+16+VectorX(8, nsd[HEADANGLE]);
		}
		int NSHeadY(untyped nsd){
			int y = Ghost_Y;
			return y-24-8+16+VectorY(8, nsd[HEADANGLE]);
		}
		int NSEyeX(untyped nsd, int eye){
			if(eye==0)return Ghost_X+16+8;
			if(eye==1)return Ghost_X+16+24;
		}
		int NSEyeY(untyped nsd, int eye){
			if(eye==0)return Ghost_Y-24+18;
			if(eye==1)return Ghost_Y-24+18;
		}
		//Converts a point in bitmap space to a point in screen space
		void NSRotatedPos(untyped vars, int xy){
			untyped nsd = vars[NV_DAT];
			
			int drawX = Ghost_X;
			int drawY = Ghost_Y;
			if(vars[NV_DRAWX]>-10000){
				drawX = vars[NV_DRAWX];
				drawY = vars[NV_DRAWY];
			}
			int rX = 256;
			int rY = 256;
			int srcX = 256 - (32+drawX) / nsd[DRAWSCALE];
			int srcY = 256 - (32+drawY) / nsd[DRAWSCALE];
			Rotate(xy, rX, rY, 0, 0, nsd[DRAWROTATE]);
			xy[0] -= srcX;
			xy[1] -= srcY;
		}
		//Same as above but converting screen space to bitmap space
		void NSRotatedPosInverse(untyped vars, int xy){
			untyped nsd = vars[NV_DAT];
			
			int drawX = Ghost_X;
			int drawY = Ghost_Y;
			if(vars[NV_DRAWX]>-10000){
				drawX = vars[NV_DRAWX];
				drawY = vars[NV_DRAWY];
			}
			int rX = 256;
			int rY = 256;
			int srcX = 256 - (32+drawX) / nsd[DRAWSCALE];
			int srcY = 256 - (32+drawY) / nsd[DRAWSCALE];
			xy[0] += srcX;
			xy[1] += srcY;
			Rotate(xy, rX, rY, 0, 0, -nsd[DRAWROTATE]);
		}
		void NSLinkPosInBitmap(untyped vars, int xy, int yoff){
			untyped nsd = vars[NV_DAT];
			
			int drawX = Ghost_X;
			int drawY = Ghost_Y;
			if(vars[NV_DRAWX]>-10000){
				drawX = vars[NV_DRAWX];
				drawY = vars[NV_DRAWY];
			}
			int rX = 256;
			int rY = 256;
			int srcX = 256 - (32+drawX) / nsd[DRAWSCALE];
			int srcY = 256 - (32+drawY) / nsd[DRAWSCALE];
			xy[0] = Link->X+8;
			xy[1] = Link->Y+8+yoff;
			xy[0] += srcX;
			xy[1] += srcY;
			Rotate(xy, rX, rY, 0, 0, -nsd[DRAWROTATE]);
		}
		void NSSetHand(untyped nsd, int hand, int x, int y, int ang, bool truePos){
			if(truePos){
				x -= Ghost_X+32;
				y -= Ghost_Y;
			}
			if(hand==0){
				nsd[LHAND_X] = x;
				nsd[LHAND_Y] = y;
				if(ang>-1000)
					nsd[LHAND_ANG] = ang;
			}
			else{
				nsd[RHAND_X] = x;
				nsd[RHAND_Y] = y;
				if(ang>-1000)
					nsd[RHAND_ANG] = ang;
			}
		}
		void NSUpdateEgg(npc ghost, untyped vars){
			// Screen->DrawInteger(6, 0, 0, FONT_Z3SMALL, 0x01, 0x0F, -1, -1, vars[NV_HP], 0, 128);
			// Screen->DrawInteger(6, 0, 8, FONT_Z3SMALL, 0x01, 0x0F, -1, -1, vars[NV_PHASE3HP], 0, 128);
			
			untyped nsd = vars[NV_DAT];
			npc hitbox = vars[NV_HITBOX];
			
			bitmap nsBuf = nsd[BUFFER];
			bitmap starBG = nsd[STARBITMAP];
			
			int bestiaryMultiplier = 1;
			if(G[G_BESTIARYRANDO]&&LoreTracking[LT_ENEMIES+236])
				bestiaryMultiplier = 1.5;
			if(GLOBAL_DEBUG)
				bestiaryMultiplier = 10;
			
			int cmb;
			bool checkInBG;
			bool inFG;
			switch(vars[NV_EGGSTATE]){
				case EGG_INACTIVE:
					NSDetatchLockon(hitbox[HITBOX_EGG]);
					break;
				case EGG_FOLLOW:
					int ang = Angle(vars[NV_EGGX], vars[NV_EGGY], vars[NV_EGGTX], vars[NV_EGGTY]);
					int dist = Distance(vars[NV_EGGX], vars[NV_EGGY], vars[NV_EGGTX], vars[NV_EGGTY]);
					if(dist>1){
						vars[NV_EGGX] += VectorX(1, ang);
						vars[NV_EGGY] += VectorY(1, ang);
					}
					else{
						vars[NV_EGGX] = vars[NV_EGGTX];
						vars[NV_EGGY] = vars[NV_EGGTY];
						vars[NV_EGGTX] = Ghost_X+Rand(0, 47);
						vars[NV_EGGTY] = Ghost_Y+Rand(-16, 47);
					}
					if(GLW[GL_TORRINHOOK]->isValid()){
						if(Collision(hitbox[HITBOX_EGG], GLW[GL_TORRINHOOK])){
							vars[NV_EGGTX] = Link->X+DirX(Link->Dir, 16);
							vars[NV_EGGTY] = Link->Y+DirY(Link->Dir, 16);
							vars[NV_EGGSTATE] = EGG_FISHED;
						}
					}
					cmb = 51944;
					checkInBG = true;
					break;
				case EGG_FISHED:
					int ang = Angle(vars[NV_EGGX], vars[NV_EGGY], vars[NV_EGGTX], vars[NV_EGGTY]);
					int dist = Distance(vars[NV_EGGX], vars[NV_EGGY], vars[NV_EGGTX], vars[NV_EGGTY]);
					if(dist>2){
						vars[NV_EGGX] += VectorX(2, ang);
						vars[NV_EGGY] += VectorY(2, ang);
					}
					else{
						vars[NV_EGGX] = vars[NV_EGGTX];
						vars[NV_EGGY] = vars[NV_EGGTY];
						vars[NV_EGGSTATE] = EGG_FISHWAIT;
						vars[NV_EGGTIMER] = 96;
					}
					cmb = 51943;
					if(vars[NV_EGGY]>Ghost_Y+24)
						inFG = true;
					checkInBG = true;
					break;
				case EGG_FISHWAIT:
					if(vars[NV_EGGTIMER])
						--vars[NV_EGGTIMER];
					else{
						vars[NV_EGGSTATE] = EGG_FISHRETURN;
						vars[NV_EGGTIMER] = 0;
					}
					cmb = 51943;
					inFG = true;
					break;
				case EGG_FISHRETURN:
					vars[NV_EGGTX] = Ghost_X+24;
					vars[NV_EGGTY] = Ghost_Y+24;
					int ang = Angle(vars[NV_EGGX], vars[NV_EGGY], vars[NV_EGGTX], vars[NV_EGGTY]);
					int dist = Distance(vars[NV_EGGX], vars[NV_EGGY], vars[NV_EGGTX], vars[NV_EGGTY]);
					if(dist>vars[NV_EGGTIMER]){
						vars[NV_EGGX] += VectorX(vars[NV_EGGTIMER], ang);
						vars[NV_EGGY] += VectorY(vars[NV_EGGTIMER], ang);
					}
					else{
						vars[NV_EGGX] = vars[NV_EGGTX];
						vars[NV_EGGY] = vars[NV_EGGTY];
						vars[NV_EGGSTATE] = EGG_FOLLOW;
					}
					vars[NV_EGGTIMER] = Min(vars[NV_EGGTIMER]+0.1, 4);
					cmb = 51943;
					inFG = true;
					break;
				case EGG_STATIONARY:
					cmb = 51944;
					break;
				case EGG_LAUNCH:
					vars[NV_EGGY] += 4;
					cmb = 51940;
					inFG = true;
					if(vars[NV_EGGY]>=128){
						vars[NV_EGGSTATE] = EGG_UNFURL;
						vars[NV_EGGY] = 128;
						vars[NV_EGGTIMER] = 36;
					}
					break;
				case EGG_UNFURL:
					if(vars[NV_EGGTIMER]<=12)
						cmb = 51942;
					else if(vars[NV_EGGTIMER]<=24)
						cmb = 51941;
					else
						cmb = 51940;
					inFG = true;
					--vars[NV_EGGTIMER];
					if(vars[NV_EGGTIMER]<=0){
						vars[NV_EGGSTATE] = EGG_SCRIPTMANAGED;
						Screen->D[D_EGGCONTROL] = 1;
						Screen->D[D_EGGCOMBO] = 51943;
					}
					break;
				case EGG_SCRIPTMANAGED:
					vars[NV_EGGX] = hitbox[HITBOX_EGG]->X;
					vars[NV_EGGY] = hitbox[HITBOX_EGG]->Y-hitbox[HITBOX_EGG]->Z;
					inFG = true;
					cmb = Screen->D[D_EGGCOMBO];
					break;
			}
			
			if(vars[NV_EGGY]<-16){
				NSDetatchLockon(hitbox[HITBOX_EGG]);
			}
			
			if(cmb>0){
				int shakeX = 0;
				int shakeY = 0;
				if(nsd[SHAKETIMER]){
					int i = Ceiling(Lerp(0, nsd[SHAKEINTENSITY], nsd[SHAKETIMER]/31));
					shakeX = Rand(-i, i);
					shakeY = Rand(-i, i);
				}
				if(inFG)
					Screen->DrawCombo(4, vars[NV_EGGX]-8+shakeX, vars[NV_EGGY]-8+shakeY, cmb, 2, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 128);
				else
					starBG->DrawCombo(0, vars[NV_EGGX]-8+shakeX, vars[NV_EGGY]-8+shakeY, cmb, 2, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 128);
			}
			
			if(inFG)
				hitbox[HITBOX_EGG]->Stun = 0;
			else
				hitbox[HITBOX_EGG]->Stun = 8;
			if(vars[NV_EGGSTATE]!=EGG_SCRIPTMANAGED){
				hitbox[HITBOX_EGG]->X = Clamp(vars[NV_EGGX], -32, 272);
				hitbox[HITBOX_EGG]->Y = Clamp(vars[NV_EGGY], -32, 192);
				hitbox[HITBOX_EGG]->CollDetection = false;
			}
			if(hitbox[HITBOX_EGG]->HP<10000){
				nsd[SHAKEINTENSITY] = 3;
				nsd[SHAKETIMER] = 32;
				Game->PlaySound(137);
				int dnX = Ghost_X+32;
				int dnY = Ghost_Y+32;
				if(vars[NV_EGGSTATE]==EGG_SCRIPTMANAGED){
					dnX = vars[NV_EGGX]+8;
					dnY = vars[NV_EGGY]+4;
				}
				int damage = (10000-hitbox[HITBOX_EGG]->HP)*bestiaryMultiplier;
				DamageNumbers_AddNumberGFX(dnX+Rand(-4, 4), dnY+Rand(-8, 8)-DAMAGENUMBERS_HEIGHT/2, _DNUM_TYPE_ENEMYDAMAGE, damage);
				vars[NV_HP] -= damage;
				hitbox[HITBOX_EGG]->HP = 10000;
				hitbox[HITBOX_EGG]->Misc[NPCM_DAMAGENUMBERSLASTHP] = hitbox[HITBOX_EGG]->HP;
			}
			if(checkInBG){
				int count;
				int srcX = 256 - (32+Ghost_X) / nsd[DRAWSCALE];
				int srcY = 256 - (32+Ghost_Y) / nsd[DRAWSCALE];
				int eX = srcX + vars[NV_EGGX];
				int eY = srcY + vars[NV_EGGY];
				for(int i=0; i<4; ++i){
					int x = eX+3+9*(i%2);
					int y = eY+3+9*Floor(i/2);
					if(x>=0&&y>=0&&x<nsBuf->Width&&y<nsBuf->Height){
						if(Graphics->GetPixel(nsBuf, x, y)*10000==0x1F)
							++count;
					}
				}
				if(count>=2)
					hitbox[HITBOX_EGG]->CollDetection = true;
			}
			if(inFG&&vars[NV_EGGSTATE]!=EGG_SCRIPTMANAGED)
				hitbox[HITBOX_EGG]->CollDetection = true;
		}
		void NSDetatchLockon(npc egg){
			if(G[G_TORRINLOCKONTARGET]>0){
				npc target = Screen->LoadNPCByUID(G[G_TORRINLOCKONTARGET]);
				if(target==egg){
					G[G_TORRINLOCKON] = 0;
				}
			}
		}
		void NSMoveLHand(untyped vars, int tX, int tY, int step, int tAngle, int angStep, bool truePos){
			untyped nsd = vars[NV_DAT];
			
			vars[NV_LHAND_TANG] = tAngle;
			vars[NV_LHAND_ANGSTEP] = angStep;
			vars[NV_LHAND_TX] = tX;
			vars[NV_LHAND_TY] = tY;
			vars[NV_LHAND_STEP] = step;
			vars[NV_LHAND_TRUEPOS] = truePos?1:0;
			vars[NV_LHAND_MOVING] = 1;
		}
		void NSMoveRHand(untyped vars, int tX, int tY, int step, int tAngle, int angStep, bool truePos){
			untyped nsd = vars[NV_DAT];
			
			vars[NV_RHAND_TANG] = tAngle;
			vars[NV_RHAND_ANGSTEP] = angStep;
			vars[NV_RHAND_TX] = tX;
			vars[NV_RHAND_TY] = tY;
			vars[NV_RHAND_STEP] = step;
			vars[NV_RHAND_TRUEPOS] = truePos?1:0;
			vars[NV_RHAND_MOVING] = 1;
		}
		void NSClawMove(untyped vars){
			++vars[NV_CLAWANIM];
			vars[NV_CLAWANIM] %= 24;
			
			int i = vars[NV_CLAWANIM]%12;
			if(vars[NV_CLAWANIM]>=12)
				i = 12-i;
			NSMoveLHand(vars, Ghost_X+32-24, 68-i+4, 4, -1000, 0, true);
			
			i = vars[NV_CLAWANIM]%12;
			if(vars[NV_CLAWANIM]<12)
				i = 12-i;
			NSMoveRHand(vars, Ghost_X+32+24, 68-i+4, 4, -1000, 0, true);
		}
		void NSWaithands(ffc this, npc ghost, untyped vars){
			while(vars[NV_LHAND_MOVING]||vars[NV_RHAND_MOVING]){
				NSWaitframe(this, ghost, vars, 1);
			}
		}
		void NSGlide(ffc this, npc ghost, untyped vars, int tX, int tY, int step){
			while(Distance(Ghost_X, Ghost_Y, tX, tY)>step){
				int angle = Angle(Ghost_X, Ghost_Y, tX, tY);
				Ghost_MoveAtAngle(angle, step, 0);
				NSWaitframe(this, ghost, vars, 1);
			}
			Ghost_X = tX;
			Ghost_Y = tY;
		}
		void NSUpdateHands(untyped vars){
			untyped nsd = vars[NV_DAT];
			npc hitbox = vars[NV_HITBOX];
			
			int bestiaryMultiplier = 1;
			if(G[G_BESTIARYRANDO]&&LoreTracking[LT_ENEMIES+236])
				bestiaryMultiplier = 1.5;
			if(GLOBAL_DEBUG)
				bestiaryMultiplier = 10;
			
			if(hitbox[HITBOX_LHAND]->HP<10000){
				int damage = (10000-hitbox[HITBOX_LHAND]->HP)*bestiaryMultiplier;
				DamageNumbers_AddNumberGFX(NSHandX(nsd, 0)+Rand(-4, 4), NSHandY(nsd, 0)+Rand(-8, 8)-DAMAGENUMBERS_HEIGHT/2, _DNUM_TYPE_ENEMYDAMAGE, damage*0.2);
				vars[NV_HP] -= (10000-hitbox[HITBOX_LHAND]->HP)*0.2;
				hitbox[HITBOX_LHAND]->HP = 10000;
				hitbox[HITBOX_LHAND]->Misc[NPCM_DAMAGENUMBERSLASTHP] = hitbox[HITBOX_LHAND]->HP;
			}
			
			if(hitbox[HITBOX_RHAND]->HP<10000){
				int damage = (10000-hitbox[HITBOX_RHAND]->HP)*bestiaryMultiplier;
				DamageNumbers_AddNumberGFX(NSHandX(nsd, 1)+Rand(-4, 4), NSHandY(nsd, 1)+Rand(-8, 8)-DAMAGENUMBERS_HEIGHT/2, _DNUM_TYPE_ENEMYDAMAGE, damage*0.2);
				vars[NV_HP] -= damage*0.2;
				hitbox[HITBOX_RHAND]->HP = 10000;
				hitbox[HITBOX_RHAND]->Misc[NPCM_DAMAGENUMBERSLASTHP] = hitbox[HITBOX_RHAND]->HP;
			}
			
			hitbox[HITBOX_LHAND]->HitHeight = 24;
			hitbox[HITBOX_RHAND]->HitHeight = 24;
			if(nsd[DRAWLAYER]==0){
				hitbox[HITBOX_LHAND]->Stun = 8;
				hitbox[HITBOX_RHAND]->Stun = 8;
				hitbox[HITBOX_LHAND]->HitHeight = Clamp(64-(hitbox[HITBOX_LHAND]->Y+4), 1, 24);
				hitbox[HITBOX_RHAND]->HitHeight = Clamp(64-(hitbox[HITBOX_RHAND]->Y+4), 1, 24);
			}
			else{
				hitbox[HITBOX_LHAND]->Stun = 0;
				hitbox[HITBOX_RHAND]->Stun = 0;
			}
			
			if(vars[NV_LHAND_MOVING]){
				vars[NV_LHAND_MOVING] = 0;
				
				int tX = vars[NV_LHAND_TX];
				int tY = vars[NV_LHAND_TY];
				if(vars[NV_LHAND_TRUEPOS]){
					tX -= (Ghost_X+32);
					tY -= Ghost_Y;
				}
				
				if(vars[NV_LHAND_TANG]>-1000){
					nsd[LHAND_ANG] = TurnToAngle(nsd[LHAND_ANG], vars[NV_LHAND_TANG], vars[NV_LHAND_ANGSTEP]);
					if(nsd[LHAND_ANG]!=vars[NV_LHAND_TANG])
						vars[NV_LHAND_MOVING] = 1;
				}
				
				int ang = Angle(nsd[LHAND_X], nsd[LHAND_Y], tX, tY);
				int dist = Distance(nsd[LHAND_X], nsd[LHAND_Y], tX, tY);
				if(dist<vars[NV_LHAND_STEP]){
					nsd[LHAND_X] = tX;
					nsd[LHAND_Y] = tY;
				}
				else{
					nsd[LHAND_X] += VectorX(vars[NV_LHAND_STEP], ang);
					nsd[LHAND_Y] += VectorY(vars[NV_LHAND_STEP], ang);
					vars[NV_LHAND_MOVING] = 1;
				}
			}
			
			if(vars[NV_RHAND_MOVING]){
				vars[NV_RHAND_MOVING] = 0;
				
				int tX = vars[NV_RHAND_TX];
				int tY = vars[NV_RHAND_TY];
				if(vars[NV_RHAND_TRUEPOS]){
					tX -= (Ghost_X+32);
					tY -= Ghost_Y;
				}
				
				if(vars[NV_RHAND_TANG]>-1000){
					nsd[RHAND_ANG] = TurnToAngle(nsd[RHAND_ANG], vars[NV_RHAND_TANG], vars[NV_RHAND_ANGSTEP]);
					if(nsd[RHAND_ANG]!=vars[NV_RHAND_TANG])
						vars[NV_RHAND_MOVING] = 1;
				}
				
				int ang = Angle(nsd[RHAND_X], nsd[RHAND_Y], tX, tY);
				int dist = Distance(nsd[RHAND_X], nsd[RHAND_Y], tX, tY);
				if(dist<vars[NV_RHAND_STEP]){
					nsd[RHAND_X] = tX;
					nsd[RHAND_Y] = tY;
				}
				else{
					nsd[RHAND_X] += VectorX(vars[NV_RHAND_STEP], ang);
					nsd[RHAND_Y] += VectorY(vars[NV_RHAND_STEP], ang);
					vars[NV_RHAND_MOVING] = 1;
				}
			}
		}
		void NSUpdateHead(untyped vars){
			untyped nsd = vars[NV_DAT];
			npc hitbox = vars[NV_HITBOX];
			
			int bestiaryMultiplier = 1;
			if(G[G_BESTIARYRANDO]&&LoreTracking[LT_ENEMIES+236])
				bestiaryMultiplier = 1.5;
			if(GLOBAL_DEBUG)
				bestiaryMultiplier = 10;
			
			if(hitbox[HITBOX_HEAD]->CollDetection){
				for(int i=Screen->NumLWeapons(); i>0; --i){
					lweapon l = Screen->LoadLWeapon(i);
					if(l->ID==LW_LOBBOMB&&!l->Falling){
						if(RectCollision(hitbox[HITBOX_HEAD]->X, hitbox[HITBOX_HEAD]->Y, hitbox[HITBOX_HEAD]->X+31, hitbox[HITBOX_HEAD]->Y+31, l->X+7, l->Y-l->Z+7, l->X+8, l->Y-l->Z+8)){
							int damage = l->Damage;
							LobBombLW.MakeExplosion(l->X, l->Y-l->Z, damage, DIR_UP);
							l->Script = 0;
							l->DeadState = 0;
						}
					}
					if(l->Script==LWS_RECKLESSRICOCHET){
						if(RectCollision(hitbox[HITBOX_HEAD]->X, hitbox[HITBOX_HEAD]->Y, hitbox[HITBOX_HEAD]->X+31, hitbox[HITBOX_HEAD]->Y+31, l->X+7, l->Y-l->Z+7, l->X+8, l->Y-l->Z+8)){
							int damage = l->Damage;
							RecklessRicochetLW.MakeExplosion(l->X, l->Y-l->Z, damage, DIR_UP);
							l->Script = 0;
							l->DeadState = 0;
						}
					}
				}
			}
			
			if(hitbox[HITBOX_HEAD]->HP<10000){
				if(vars[NV_CURRENTCYCLE]==2)
					nsd[SHAKEINTENSITY] = 6;
				else
					nsd[SHAKEINTENSITY] = 3;
				nsd[SHAKETIMER] = 32;
				Game->PlaySound(137);
				int dnX = Ghost_X+32;
				int dnY = Ghost_Y-16;
				if(vars[NV_CURRENTCYCLE]==2)
					DamageNumbers_AddNumberGFX(dnX+Rand(-4, 4), dnY+Rand(-8, 8)-DAMAGENUMBERS_HEIGHT/2, _DNUM_TYPE_ENEMYDAMAGE, (10000-hitbox[HITBOX_HEAD]->HP)*100*bestiaryMultiplier);
				else
					DamageNumbers_AddNumberGFX(dnX+Rand(-4, 4), dnY+Rand(-8, 8)-DAMAGENUMBERS_HEIGHT/2, _DNUM_TYPE_ENEMYDAMAGE, (10000-hitbox[HITBOX_HEAD]->HP)*bestiaryMultiplier);
				vars[NV_PHASE3HP] -= (10000-hitbox[HITBOX_HEAD]->HP)*bestiaryMultiplier;
				if(vars[NV_PHASE3HP]<=0&&!vars[NV_MASKBREAKDONE]&&vars[NV_CURRENTCYCLE]<2){
					vars[NV_MASKBREAKDONE] = 1;
					++nsd[FACECRACKED];
					Game->PlaySound(SFX_NIGHTMARESELET_MASKCRACK);
				}
				hitbox[HITBOX_HEAD]->HP = 10000;
				hitbox[HITBOX_HEAD]->Misc[NPCM_DAMAGENUMBERSLASTHP] = hitbox[HITBOX_HEAD]->HP;
			}
			
			if(nsd[DRAWLAYER]==0){
				hitbox[HITBOX_HEAD]->Stun = 8;
			}
			else{
				hitbox[HITBOX_HEAD]->Stun = 0;
			}
		}
		void NSUpdateAsteroids(untyped vars){
			untyped nsd = vars[NV_DAT];
			bitmap nsBuf = nsd[BUFFER];
			bitmap starBG = nsd[STARBITMAP];
			
			int asteroids = vars[NV_ASTEROIDS];
			int asteroidX = asteroids[0];
			int asteroidY = asteroids[1];
			int asteroidAng = asteroids[2];
			int asteroidSt = asteroids[3];
			int asteroidStep = asteroids[4];
			int asteroidRot = asteroids[5];
			
			bool createNew;
			
			if(vars[NV_ASTEROIDTIMER])
				--vars[NV_ASTEROIDTIMER];
			if(vars[NV_ASTEROIDTIMER2])
				--vars[NV_ASTEROIDTIMER2];
			
			
			int freq = vars[NV_ASTEROIDFREQ];
			if(!vars[NV_ASTEROIDTIMER])
				freq = 0;
			else if(vars[NV_ASTEROIDTIMER2])
				freq *= 0.5;
			
			freq = Ceiling(freq);
			
			if(freq>0){
				if(G[G_ANIM]%freq==0&&!vars[NV_NOASTEROIDS])
					createNew = true;
			}
			
			int srcX = 256 - (32+Ghost_X) / nsd[DRAWSCALE];
			int srcY = 256 - (32+Ghost_Y) / nsd[DRAWSCALE];
			
			for(int i=0; i<32; ++i){
				if(asteroidSt[i]!=0){
					asteroidX[i] += VectorX(asteroidStep[i], asteroidAng[i]);
					asteroidY[i] += VectorY(asteroidStep[i], asteroidAng[i]);
					asteroidRot[i] = WrapDegrees(asteroidRot[i]+3*asteroidStep[i]);
					int collisionPoints;
					if(asteroidY[i]>Ghost_Y+32){
						for(int j=0; j<4; ++j){
							int x = asteroidX[i]+2+11*(j%2);
							int y = asteroidY[i]+2+11*Floor(j/2);
							if(Graphics->GetPixel(nsBuf, srcX+x, srcY+y)*10000==0x1F){
								++collisionPoints;
							}
						}
					}
					if(collisionPoints>=3){
						eweapon e = FireEWeapon(EW_SCRIPT10, asteroidX[i], asteroidY[i], DegtoRad(asteroidAng[i]), asteroidStep[i]*100, NSDamage(_DAMAGE_NIGHTMARESELET_ASTEROIDS), 0, 0, EWF_UNBLOCKABLE);
						e->OriginalTile = 66059+20*(asteroidSt[i]-1);
						e->Tile = e->OriginalTile;
						e->CSet = 11;
						e->Rotation = asteroidRot[i];
						RunEWeaponScript(e, "AsteroidChunk", {0});
						asteroidSt[i] = 0;
					}
					else{
						starBG->DrawTile(0, asteroidX[i], asteroidY[i], 66059+20*(asteroidSt[i]-1), 1, 1, 11, -1, -1, asteroidX[i], asteroidY[i], asteroidRot[i], 0, true, 128);
					}
					if(asteroidY[i]>176)
						asteroidSt[i] = 0;
				}
				else if(createNew){
					if(vars[NV_ASTEROIDTIMER2])
						asteroidX[i] = Rand(Max(Ghost_X-16, 64), Min(Ghost_X+64, 192));
					else
						asteroidX[i] = Rand(64, 192);
					asteroidY[i] = -16;
					asteroidAng[i] = 90+Rand(-10, 10);
					asteroidStep[i] = Rand(10, 16)/10;
					asteroidRot[i] = Rand(360);
					asteroidSt[i] = Rand(1, 4);
					createNew = false;
				}
			}
		}
		void NSDraw(npc ghost, untyped vars){
			untyped nsd = vars[NV_DAT];
			npc hitbox = vars[NV_HITBOX];
			
			int drawX = Ghost_X;
			int drawY = Ghost_Y;
			if(vars[NV_DRAWX]>-10000&&vars[NV_DRAWY]>-10000){
				drawX = vars[NV_DRAWX];
				drawY = vars[NV_DRAWY];
				Ghost_X = Clamp(drawX, -64, 256);
				Ghost_Y = Clamp(drawY, -64, 176);
			}
			
			if(!vars[NV_HIDEDRAW]){
				DrawNightmareSelet1(nsd);
				DrawNightmareSelet2(nsd, drawX, drawY);
			}
			
			int xy[2];
			int offY = 0;
			if(nsd[SPECIALDRAW]==SD_FLIP||nsd[SPECIALDRAW]==SD_FLIPBLACKOUT)
				offY += 64;
			xy[0] = 256;
			xy[1] = 256-32+offY;
			NSRotatedPos(vars, xy);
			hitbox[HITBOX_HEAD]->X = Clamp(xy[0]-16, -64, 256+32);//Ghost_X+16;
			hitbox[HITBOX_HEAD]->Y = Clamp(xy[1]-16, -64, 176+32);//Ghost_Y-16;
			
			if(nsd[LHAND_SUBSTATE]!=nsd[LHAND_TARGETSUB]){
				++nsd[LHAND_TIMER];
				if(nsd[LHAND_TIMER]>4){
					if(nsd[LHAND_TARGETSUB]==0){
						--nsd[LHAND_SUBSTATE];
						if(nsd[LHAND_SUBSTATE]==0)
							SetAllDefenses(hitbox[HITBOX_LHAND], NPCDT_BLOCK);
					}
					if(nsd[LHAND_TARGETSUB]==3){
						++nsd[LHAND_SUBSTATE];
						if(nsd[LHAND_SUBSTATE]==3)
							SetAllDefenses(hitbox[HITBOX_LHAND], NPCDT_NONE);
					}
					nsd[LHAND_TIMER] = 0;
				}
			}
			if(nsd[RHAND_SUBSTATE]!=nsd[RHAND_TARGETSUB]){
				++nsd[RHAND_TIMER];
				if(nsd[RHAND_TIMER]>4){
					if(nsd[RHAND_TARGETSUB]==0){
						--nsd[RHAND_SUBSTATE];
						if(nsd[RHAND_SUBSTATE]==0)
							SetAllDefenses(hitbox[HITBOX_RHAND], NPCDT_BLOCK);
					}
					if(nsd[RHAND_TARGETSUB]==3){
						++nsd[RHAND_SUBSTATE];
						if(nsd[RHAND_SUBSTATE]==3)
							SetAllDefenses(hitbox[HITBOX_RHAND], NPCDT_NONE);
					}
					nsd[RHAND_TIMER] = 0;
				}
			}
			if(nsd[HEADSTATE]!=nsd[HEADTARGETSTATE]){
				++nsd[HEADTIMER];
				if(nsd[HEADTIMER]>4){
					if(nsd[HEADTARGETSTATE]==0)
						--nsd[HEADSTATE];
					if(nsd[HEADTARGETSTATE]==3)
						++nsd[HEADSTATE];
					nsd[HEADTIMER] = 0;
				}
			}
			
			xy[0] = 256+nsd[LHAND_X];
			xy[1] = 256+nsd[LHAND_Y]-32+offY;
			NSRotatedPos(vars, xy);
			hitbox[HITBOX_LHAND]->X = Clamp(xy[0]-12, -64, 256+32); //Ghost_X+32+nsd[LHAND_X]-12;
			hitbox[HITBOX_LHAND]->Y = Clamp(xy[1]-12, -64, 256+32); //Ghost_Y+nsd[LHAND_Y]-12;
			
			xy[0] = 256+nsd[RHAND_X];
			xy[1] = 256+nsd[RHAND_Y]-32+offY;
			NSRotatedPos(vars, xy);
			hitbox[HITBOX_RHAND]->X = Clamp(xy[0]-12, -64, 256+32); //Ghost_X+32+nsd[RHAND_X]-12;
			hitbox[HITBOX_RHAND]->Y = Clamp(xy[1]-12, -64, 256+32); //Ghost_Y+nsd[RHAND_Y]-12;
			
			hitbox[HITBOX_HEAD]->CollDetection = true;
			hitbox[HITBOX_LHAND]->CollDetection = true;
			hitbox[HITBOX_RHAND]->CollDetection = true;
			if(nsd[DRAWSCALE]!=1||nsd[DRAWROTATE]||vars[NV_HIDEDRAW]||vars[NV_NOCOLL]||vars[NV_DYING]){
				hitbox[HITBOX_HEAD]->CollDetection = false;
				hitbox[HITBOX_LHAND]->CollDetection = false;
				hitbox[HITBOX_RHAND]->CollDetection = false;
			}
		}
		void NSCapeCollision(npc ghost, untyped vars){
			untyped nsd = vars[NV_DAT];
			if(vars[NV_NOCOLL]||nsd[DRAWLAYER]==0||vars[NV_DYING])
				return;
			bitmap nsBuf = nsd[BUFFER];
			
			int collisionPoints;
			int srcX = 256 - (32+Ghost_X) / nsd[DRAWSCALE];
			int srcY = 256 - (32+Ghost_Y) / nsd[DRAWSCALE];
			for(int i=0; i<4; ++i){
				int x = Link->X+6+3*(i%2);
				int y = Link->Y+10+3*Floor(i/2);
				if(Graphics->GetPixel(nsBuf, srcX+x, srcY+y)*10000==0x1F){
					++collisionPoints;
				}
			}
			if(collisionPoints>1){
				int ang = Angle(Link->X-24, Link->Y-24, Ghost_X, Ghost_Y);
				MakeHitbox(EW_SCRIPT10, Link->X-24+VectorX(16, ang), Link->Y-24+VectorY(16, ang), 64, 64, ghost->Damage);
			}
		}
		bool NSClaw2(eweapon eArr, int offset, int count, int clawX, int clawY, int angle, int angle2, int spacing, int damage, int targetVertexCount, int vertexGrowth){
			int numWeapons = 0;
			for(int i=0; i<count; ++i){
				int i2 = i+offset;
				int dist = -spacing*(count-1)/2;
				int x = clawX+VectorX(dist+i*spacing, angle-90);
				int y = clawY+VectorY(dist+i*spacing, angle-90);
				if(eArr[i2]->isValid()){
					++numWeapons;
					
					eArr[i2]->Damage = damage;
					eArr[i2]->Angle = DegtoRad(angle2);
					eArr[i2]->InitD[1] = x;
					eArr[i2]->InitD[2] = y;
					
					if(eArr[i2]->InitD[0]<targetVertexCount){
						eArr[i2]->InitD[0] = Min(eArr[i2]->InitD[0]+vertexGrowth, targetVertexCount);
					}
					else if(eArr[i2]->InitD[0]>targetVertexCount){
						eArr[i2]->InitD[0] = Max(eArr[i2]->InitD[0]-vertexGrowth, 0);
						if(eArr[i2]->InitD[0]==0)
							eArr[i2]->DeadState = 0;
					}
				}
				else{
					if(targetVertexCount>0){
						eArr[i2] = CreateEWeaponAt(EW_SCRIPT10, 120, 80);
						eArr[i2]->Damage = damage;
						eArr[i2]->CollDetection = false;
						eArr[i2]->DrawYOffset = -1000;
						RunEWeaponScript(eArr[i2], "VunterSlaush", {1, x, y, 1, 18});
						
						eArr[i2]->Damage = damage;
						eArr[i2]->Angle = DegtoRad(angle2);
					}
				}
			}
			return numWeapons>0;
		}
		void NSRunSpikeHandler(npc ghost, bitmap starBG){
			int scr = Game->GetEWeaponScript("VoidSpike");
			for(int i=Screen->NumEWeapons(); i>0; --i){
				eweapon e = Screen->LoadEWeapon(i);
				if(e->Script==scr&&e->InitD[0]==1)
					return;
			}
			eweapon e = FireEWeapon(EW_SCRIPT10, 120, 80, 0, 0, NSDamage(_DAMAGE_NIGHTMARESELET_SPIKES), SPRITE_INVISIBLE, 0, 0);
			e->CollDetection = false;
			RunEWeaponScript(e, "VoidSpike", {1, <untyped>starBG});
		}
		void NSDebugState(untyped vars, int state, int cycle){
			untyped nsd = vars[NV_DAT];
			npc hitbox = vars[NV_HITBOX];
			vars[NV_CURRENTCYCLE] = cycle;
			switch(state){
				case 1: //Flying
					break;
				case 2: //Crash
					vars[NV_PHASE] = 2;
				
					Ghost_X = 96;
					Ghost_Y = 56;
					vars[NV_DRAWX] = -10000;
					vars[NV_DRAWY] = -10000;
					vars[NV_HIDEDRAW] = 0;
					
					nsd[DRAWSCALE] = 1;
					nsd[DRAWROTATE] = 0;
					nsd[LHAND_X] = -48;
					nsd[LHAND_Y] = 68;
					nsd[RHAND_X] = 48;
					nsd[RHAND_Y] = 68;
					nsd[LHAND_STATE] = HAND_GRAB;
					nsd[RHAND_STATE] = HAND_GRAB;
					nsd[LHAND_ANG] = 0;
					nsd[RHAND_ANG] = 0;
					
					nsd[SPECIALDRAW] = SD_BG;
					nsd[DRAWLAYER] = 0;
					nsd[TENTACLEAMULT] = 1;
					
					nsd[HANDSDRAWOVER] = 2;
					nsd[HEADDRAWOVER] = 2;
					
					vars[NV_EGGSTATE] = EGG_INACTIVE;
					vars[NV_EGGY] = -32;
					
					if(cycle==2){
						nsd[FACECRACKED] = 4;
						nsd[HEADSTATE] = 3;
						nsd[HEADTARGETSTATE] = 3;
					}
					
					if(vars[NV_CURRENTCYCLE]==2){
						vars[NV_PHASE3HP] = HP_NIGHTMARESELET_PHASE3B*EasyModeMultiplier(0.8);
						SetAllDefenses(hitbox[HITBOX_HEAD], NPCDT_NONE);
					}
					else{
						vars[NV_PHASE3HP] = HP_NIGHTMARESELET_PHASE3*EasyModeMultiplier(0.8);						
						SetAllDefenses(hitbox[HITBOX_HEAD], NPCDT_BLOCK);
						hitbox[HITBOX_HEAD]->Defense[NPCD_BOMB] = NPCDT_NONE;
						hitbox[HITBOX_HEAD]->Defense[NPCD_STARWANDIMPACT] = NPCDT_HALFDAMAGE;
					}
					break;
			}
		}
		void NSUpdateDeathAnimTentacles(int vars, int tentacle){
			untyped nsd = vars[NV_DAT];
			int tentacleA = tentacle[0];
			int tentacleD = tentacle[1];
			int tentacleMaxD = tentacle[2];
			int tentacleActive = tentacle[3];
			int tentacleLayer = tentacle[4];
			int tentacleFrame = tentacle[5];
			for(int i=0; i<36; ++i){
				if(tentacleActive[i]){
					int x = NSHeadX(nsd)+Rand(-2, 2);
					int y = NSHeadY(nsd)+32+Rand(-2, 2);
					
					tentacleFrame[i] = (tentacleFrame[i]+10)%90;
					tentacleD[i] = Min(tentacleD[i]+8, tentacleMaxD[i]);
					ScreenTentacleLong2(4, x, y, tentacleD[i], tentacleA[i], tentacleFrame[i], 0, 4);
				}
			}
		}
		void NSDeathAnimation(ffc this, npc ghost, untyped vars){
			if(G[G_RANDOMIZERENABLED])
				GiveBestiaryEntry(236, true);
			for(int i=Screen->NumEWeapons(); i>0; --i){
				eweapon e = Screen->LoadEWeapon(i);
				e->Remove();
			}
			int i; int j; int k;
			vars[NV_DYING] = 1;
			untyped nsd = vars[NV_DAT];
			nsd[HEADDRAWOVER] = 0;
			nsd[HANDSDRAWOVER] = 0;
			nsd[TENTACLEAMULT] = 8;
			int posX = Ghost_X;
			int posY = Ghost_Y;
			int moveAngle = Angle(posX, posY, 96, 24);
			Game->PlayMIDI(0);
			Game->PlaySound(77);
			for(i=0; i<12; ++i){
				if(Distance(posX, posY, 96, 24)>2){
					posX += VectorX(0.5, moveAngle);
					posY += VectorY(0.5, moveAngle);
				}
				Ghost_X = posX+Rand(-2, 2);
				Ghost_Y = posY+Rand(-2, 2);
				if(i<8)
					Screen->Rectangle(2, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 128);
				else
					Screen->Rectangle(2, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 64);
				NSWaitframe(this, ghost, vars, 1);
			}
			for(i=0; i<48; ++i){
				if(Distance(posX, posY, 96, 24)>2){
					posX += VectorX(0.5, moveAngle);
					posY += VectorY(0.5, moveAngle);
				}
				Ghost_X = posX+Rand(-2, 2);
				Ghost_Y = posY+Rand(-2, 2);
				NSWaitframe(this, ghost, vars, 1);
			}
			Game->PlaySound(77);
			for(i=0; i<12; ++i){
				if(Distance(posX, posY, 96, 24)>2){
					posX += VectorX(0.5, moveAngle);
					posY += VectorY(0.5, moveAngle);
				}
				Ghost_X = posX+Rand(-1, 1);
				Ghost_Y = posY+Rand(-1, 1);
				if(i<8)
					Screen->Rectangle(2, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 128);
				else
					Screen->Rectangle(2, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 64);
				NSWaitframe(this, ghost, vars, 1);
			}
			for(i=0; i<24; ++i){
				if(Distance(posX, posY, 96, 24)>2){
					posX += VectorX(0.5, moveAngle);
					posY += VectorY(0.5, moveAngle);
				}
				Ghost_X = posX+Rand(-1, 1);
				Ghost_Y = posY+Rand(-1, 1);
				NSWaitframe(this, ghost, vars, 1);
			}
			Game->PlaySound(77);
			Game->DMapPalette[Game->GetCurDMap()] = 0x08D;
			for(i=0; i<12; ++i){
				if(Distance(posX, posY, 96, 24)>2){
					posX += VectorX(0.5, moveAngle);
					posY += VectorY(0.5, moveAngle);
				}
				Ghost_X = posX+Rand(-1, 1);
				Ghost_Y = posY+Rand(-1, 1);
				if(i<8)
					Screen->Rectangle(2, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 128);
				else
					Screen->Rectangle(2, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 64);
				NSWaitframe(this, ghost, vars, 1);
			}
			nsd[HEADTARGETSTATE] = 0;
			NSWaitframe(this, ghost, vars, 32);
			nsd[SPECIALDRAW] = SD_BLACKOUT;
			
			int tentacleOrder[36];
			int tentacleA[36];
			int tentacleD[36];
			int tentacleMaxD[36];
			int tentacleActive[36];
			int tentacleLayer[36];
			int tentacleFrame[36];
			int tentacle[] = {tentacleA, tentacleD, tentacleMaxD, tentacleActive, tentacleLayer, tentacleFrame};
			for(i=0; i<36; ++i){
				tentacleOrder[i] = i;
				tentacleFrame[i] = Rand(90);
			}
			for(i=0; i<72; ++i){
				int r1 = Rand(36);
				int r2 = Rand(36);
				int old = tentacleOrder[r1];
				tentacleOrder[r1] = tentacleOrder[r2];
				tentacleOrder[r2] = old;
			}
			for(i=0; i<36; ++i){
				tentacleA[i] = -180+(tentacleOrder[i]%18)*10+Rand(-2, 2);
				if(tentacleOrder[i]<18){
					tentacleLayer[i] = 0;
					tentacleA[i] += 10;
				}
				else{
					tentacleLayer[i] = 4;
					tentacleA[i] += 180;
				}
				tentacleMaxD[i] = Rand(192, 256);
			}
			int maxTentacles;
			int headAngle = nsd[HEADANGLE];
			for(i=0; i<3; ++i){
				Game->PlaySound(78);
				Game->PlaySound(137);
				nsd[HEADANGLE] = headAngle + Rand(-45, 45);
				tentacleActive[maxTentacles] = 1;
				++maxTentacles;
				for(j=0; j<48; ++j){
					NSUpdateDeathAnimTentacles(vars, tentacle);
					NSWaitframe(this, ghost, vars, 1);
				}
			}
			for(i=0; i<6; ++i){
				Game->PlaySound(78);
				Game->PlaySound(137);
				nsd[HEADANGLE] = headAngle + Rand(-45, 45);
				tentacleActive[maxTentacles] = 1;
				++maxTentacles;
				for(j=0; j<24; ++j){
					NSUpdateDeathAnimTentacles(vars, tentacle);
					NSWaitframe(this, ghost, vars, 1);
				}
			}
			Game->PlaySound(142);
			for(i=0; i<9; ++i){
				Game->PlaySound(78);
				nsd[HEADANGLE] = headAngle + Rand(-45, 45);
				tentacleActive[maxTentacles] = 1;
				++maxTentacles;
				for(j=0; j<8; ++j){
					NSUpdateDeathAnimTentacles(vars, tentacle);
					NSWaitframe(this, ghost, vars, 1);
				}
			}
			for(i=0; i<18; ++i){
				Game->PlaySound(78);
				nsd[HEADANGLE] = headAngle + Rand(-45, 45);
				tentacleActive[maxTentacles] = 1;
				++maxTentacles;
				for(j=0; j<4; ++j){
					NSUpdateDeathAnimTentacles(vars, tentacle);
					NSWaitframe(this, ghost, vars, 1);
				}
			}
			for(i=0; i<8; ++i){
				NSUpdateDeathAnimTentacles(vars, tentacle);
				NSWaitframe(this, ghost, vars, 1);
			}
			for(i=0; i<256; i+=8){
				Screen->Circle(6, NSHeadX(nsd)+Rand(-2, 2), NSHeadY(nsd)+32+Rand(-2, 2), i+Rand(4), 0x0F, 1, 0, 0, 0, true, 128);
				NSUpdateDeathAnimTentacles(vars, tentacle);
				NSWaitframe(this, ghost, vars, 1);
			}
			
			if(G[G_RANDOMIZERENABLED]){
				Game->DMapPalette[70] = 0x08F;
				if(G[G_RANDOMIZERMODE]==1)
					Link->Warp(70, 0x06);
				else
					Link->Warp(54, 0x75);
			}
			else
				Screen->ComboD[0] = CMB_AUTOWARPA;
			while(true){
				Screen->Rectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
				NSWaitframe(this, ghost, vars, 1);
			}
			
			
			npc hitbox = vars[NV_HITBOX];
			ghost->HP = 0;
			
			hitbox[HITBOX_EGG]->HP = -1000;
			hitbox[HITBOX_HEAD]->HP = -1000;
			hitbox[HITBOX_LHAND]->HP = -1000;
			hitbox[HITBOX_RHAND]->HP = -1000;
			Quit();
		}
		void NSWaitframe(ffc this, npc ghost, untyped vars, int frames){
			for(int i=0; i<frames; ++i){
				untyped nsd = vars[NV_DAT];
				int stars = vars[NV_STARS];
				DrawSpaceTunnel(nsd[STARBITMAP], stars);
				NSUpdateEgg(ghost, vars);
				NSUpdateAsteroids(vars);
				NSUpdateHands(vars);
				NSUpdateHead(vars);
				NSDraw(ghost, vars);
				NSCapeCollision(ghost, vars);
				if(!vars[NV_DYING]){
					if(vars[NV_CURRENTCYCLE]==2&&vars[NV_PHASE]==2&&vars[NV_PHASE3HP]<0){
						NSDeathAnimation(this, ghost, vars);
					}
				}
				Ghost_Waitframe(this, ghost);
			}
		}
	}

	ffc script LeggoMyControllerScript{
		void Close(ffc this, npc ghost){
			Screen->D[D_EGGCOMBO] = 51942;
			SSGhost_Waitframes(this, ghost, 8);
			Screen->D[D_EGGCOMBO] = 51941;
			SSGhost_Waitframes(this, ghost, 8);
			Screen->D[D_EGGCOMBO] = 51940;
			SetAllDefenses(ghost, NPCDT_BLOCK);
		}
		void Open(ffc this, npc ghost, int defs){
			SetDefenses(ghost, defs);
			Screen->D[D_EGGCOMBO] = 51941;
			SSGhost_Waitframes(this, ghost, 8);
			Screen->D[D_EGGCOMBO] = 51942;
			SSGhost_Waitframes(this, ghost, 8);
			Screen->D[D_EGGCOMBO] = 51943;
		}
		void DrawPortal(bitmap stars, bitmap portal, bitmap scrn, int x, int y, int rad, int damage){
			portal->ClearToColor(0, 0x01);
			stars->Blit(0, scrn, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
			int angle = Rand(360);
			int verts[72];
			int dist = rad;
			for(int i=0; i<36; ++i){
				dist = Clamp(dist+Rand(-2, 2), rad, rad+8);
				verts[2*i+0] = x+VectorX(dist, angle+i*10);
				verts[2*i+1] = y+VectorY(dist, angle+i*10);
			}
			portal->Polygon(0, 36, verts, 0x00, 128);
			portal->Blit(0, scrn, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
			scrn->ReplaceColors(0, 0x00, 0x01, 0x01);
			scrn->Blit(2, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
			
			if(damage>0){
				int collisionPoints;
				for(int i=0; i<4; ++i){
					int x = Link->X+6+3*(i%2);
					int y = Link->Y+10+3*Floor(i/2);
					if(Graphics->GetPixel(portal, x, y)*10000==0x00){
						++collisionPoints;
					}
				}
				if(collisionPoints>1){
					DamageLink(damage);
				}
			}
		}
		void run(int enemyid){
			int i; int j; int k; int m;
			int ang; int dist;
			int x; int y;
			npc ghost = Ghost_InitAutoGhost(this, enemyid);
			ghost->DrawYOffset = -1000;
			int defs[MAX_DEFENSE];
			StoreDefenses(ghost, defs);
			int hopCount = 3;
			int attack; int lastAttack = -1;
			int sfxTimer[1];
			
			untyped bmp = Screen->D[D_STARSBITMAP];
			bitmap stars = <bitmap>bmp;
			bitmap portal = Game->CreateBitmap(256, 176);
			bitmap scrn = Game->CreateBitmap(256, 176);
			portal->Own();
			scrn->Own();
			portal->ClearToColor(0, 0x01);
			
			bitmap laserbitmap = Game->CreateBitmap(256, 32);
			laserbitmap->Own();
			while(true){
				while(Screen->D[D_EGGCONTROL]>0){
					if(Screen->D[D_EGGCONTROL]==2){
						int shakeX = Ghost_X;
						int shakeY = Ghost_Y;
						for(i=0; i<32; ++i){
							Ghost_X = shakeX+Rand(-2, 2);
							Ghost_Y = shakeY+Rand(-2, 2);
							SSGhost_Waitframe(this, ghost);
						}
						for(i=0; i<48; ++i){
							DrawPortal(stars, portal, scrn, shakeX+8, shakeY+8, Lerp(0, 24, i/48), ghost->Damage);
							Ghost_X = shakeX+Rand(-2, 2);
							Ghost_Y = shakeY+Rand(-2, 2);
							SSGhost_Waitframe(this, ghost);
						}
						ghost->X = shakeX;
						ghost->Y = shakeY;
						Screen->D[D_EGGCONTROL] = 0;
						for(i=0; i<16; ++i){
							DrawPortal(stars, portal, scrn, shakeX+8, shakeY+8, Lerp(24, 0, i/16), ghost->Damage);
							SSGhost_Waitframe2(this, ghost);
						}
					}
					else{
						bool canAttack;
						if(Screen->D[D_EGGPHASE]!=0||IsSP())
							canAttack = true;
						if(!Screen->D[D_EGGFREEZE]){
							int speedMult = 1;
							if(Screen->D[D_EGGPHASE]<2)
								speedMult = 1.5;
							Ghost_Jump = Rand(8, 12)*0.1;
							ang = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
							while(Ghost_Z>0||Ghost_Jump>0){
								Ghost_MoveAtAngle(ang, 0.75*speedMult, 0);
								SSGhost_Waitframe(this, ghost);
							}
							--hopCount;
							if(!hopCount){
								if(!Screen->D[D_EGGFREEZE]&&canAttack){
									do{
										attack = Rand(3);
									}while(attack==lastAttack)
									if(attack==0){
										Game->PlaySound(86);
										for(i=0; i<16; ++i){
											Screen->Circle(2, Ghost_X+8+Rand(-2, 2), Ghost_Y+8+Rand(-2, 2), Rand(14, 18), Choose(0x86, 0x87, 0x88), 1, 0, 0, 0, true, 128);
											SSGhost_Waitframe(this, ghost);
										}
										
										j = -Sign(AngDiff(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y), Angle(Ghost_X, Ghost_Y, 120, 96)));
										ang = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y)+60*j;
										for(i=0; i<32; ++i){
											LoopingSFX(sfxTimer, 6, SFX_LASERBEAM);
											DrawSolarLaserEW(laserbitmap, Ghost_X+8+VectorX(8, ang), Ghost_Y+8+VectorY(8, ang), ang, Lerp(0, 24, i/32), ghost->WeaponDamage, Floor(G[G_ANIM]/4)%4);
											SSGhost_Waitframe(this, ghost);
										}
										int level;
										for(i=0; i<128&&!(i>32&&Screen->D[D_EGGFREEZE]); ++i){
											if(i<32)
												level = 0;
											else if(i<64)
												level = 1;
											else if(i<96)
												level = 2;
											if(Abs(AngDiff(ang, Angle(Ghost_X, Ghost_Y, Link->X, Link->Y)))<30)
												ang = TurnToAngle(ang, Angle(Ghost_X, Ghost_Y, Link->X, Link->Y), 0.5*speedMult);
											else
												ang = TurnToAngle(ang, Angle(Ghost_X, Ghost_Y, Link->X, Link->Y), 1*speedMult);
											LoopingSFX(sfxTimer, 6, SFX_LASERBEAM);
											int palshift;
											if(level==2){
												palshift = Floor(G[G_ANIM]/4)%4;
											}
											DrawSolarLaserEW(laserbitmap, Ghost_X+8+VectorX(8, ang), Ghost_Y+8+VectorY(8, ang), ang, 24, ghost->WeaponDamage, palshift);
											SSGhost_Waitframe(this, ghost);
										}
										for(i=0; i<8; ++i){
											LoopingSFX(sfxTimer, 6, SFX_LASERBEAM);
											int palshift;
											if(level==2){
												palshift = Floor(G[G_ANIM]/4)%4;
											}
											DrawSolarLaserEW(laserbitmap, Ghost_X+8+VectorX(8, ang), Ghost_Y+8+VectorY(8, ang), ang, Lerp(24, 0, i/8), ghost->WeaponDamage, palshift);
											SSGhost_Waitframe(this, ghost);
										}
									}
									else if(attack==1){
										Game->PlaySound(86);
										for(i=0; i<16; ++i){
											Screen->Circle(2, Ghost_X+8+Rand(-2, 2), Ghost_Y+8+Rand(-2, 2), Rand(14, 18), Choose(0x72, 0x73, 0x74), 1, 0, 0, 0, true, 128);
											SSGhost_Waitframe(this, ghost);
										}
										for(i=0; i<32; ++i){
											Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, 120, 88), 1, 0);
											Ghost_MoveTowardLink(-2, 0);
											SSGhost_Waitframe(this, ghost);
										}
										j = Sign(AngDiff(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y), Angle(Ghost_X, Ghost_Y, 120, 96)));
										ang = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y)+(Screen->D[D_EGGPHASE]==2?45*j:0);
										j = Choose(-1, 1);
										k = 28;
										i = 360/(2*k*PI)*16;
										x = Ghost_X-8+VectorX(k, ang+j*i/2);
										y = Ghost_Y-8+VectorY(k, ang+j*i/2);
										while(x>-40&&x<256&&y>-40&&y<176){
											eweapon e = FireEWeapon(EW_LUNAR, x+8, y+8, 0, 0, ghost->WeaponDamage, SPRITE_INVISIBLE, 0, 0);
											e->CollDetection = false;
											RunEWeaponScript(e, "MoonFlashEW", {40, 180});
											SSGhost_Waitframes(this, ghost, Floor(16/speedMult));
											j = -j;
											k += 40;
											i = 360/(2*k*PI)*16;
											x = Ghost_X-8+VectorX(k, ang+j*i);
											y = Ghost_Y-8+VectorY(k, ang+j*i);
										}
									}
									else if(attack==2){
										Game->PlaySound(86);
										for(i=0; i<16; ++i){
											Screen->Circle(2, Ghost_X+8+Rand(-2, 2), Ghost_Y+8+Rand(-2, 2), Rand(14, 18), Choose(0x96, 0x97, 0x98), 1, 0, 0, 0, true, 128);
											SSGhost_Waitframe(this, ghost);
										}
										Close(this, ghost);
										ang = Angle(Ghost_X, Ghost_Y, 120, 96);
										int dashDist = Distance(Ghost_X, Ghost_Y, 120, 96)+48;
										Game->PlaySound(72);
										for(int i=0; i<dashDist&&Ghost_CanMove8(AngleDir8(ang), 1, 0, true); i+=3){
											Ghost_MoveAtAngle(ang, 3, 0);
											SSGhost_Waitframe(this, ghost);
										}
										Ghost_Waitframes(this, ghost, 16);
										ang = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
										dashDist = Distance(Ghost_X, Ghost_Y, Link->X, Link->Y)+48;
										Game->PlaySound(72);
										for(int i=0; i<dashDist&&Ghost_CanMove8(AngleDir8(ang), 1, 0, true); i+=3){
											Ghost_MoveAtAngle(ang, 3, 0);
											SSGhost_Waitframe(this, ghost);
										}
										Ghost_Waitframes(this, ghost, 32);
										if(!Screen->D[D_EGGFREEZE]){
											ang = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
											Screen->D[D_EGGCOMBO] = 51941;
											SetDefenses(ghost, defs);
											for(i=0; i<80; ++i){
												if(i==8)
													Screen->D[D_EGGCOMBO] = 51942;
												else if(i==16)
													Screen->D[D_EGGCOMBO] = 51943;
												if(i==0||i==4||i==8||i==12)
													Game->PlaySound(SFX_STELLARSWORD_APPEAR);
												for(j=-3; j<=3; ++j){
													k = i-Abs(j)*4;
													if(k>0&&k<24){
														m = 5;
														if(k<2||k>=22)
															m = 1;
														else if(k<4||k>=20)
															m = 2;
														else if(k<6||k>=18)
															m = 3;
														else if(k<8||k>=16)
															m = 4;
														
														x = Ghost_X+8+VectorX(8, ang);
														y = Ghost_Y+8+VectorY(8, ang);
														DrawLightSwordSlash(x, y, ang+j*35, 8, m, ghost->WeaponDamage, 0, 0);
													}
												}
												SSGhost_Waitframe(this, ghost);
											}
										}
									}
								}
								hopCount = 3;
							}
						}
						else{
							if(Screen->D[D_EGGCOMBO]!=51940)
								Close(this, ghost);
							while(Screen->D[D_EGGFREEZE]){
								SSGhost_Waitframe(this, ghost);
							}
							Open(this, ghost, defs);
						}
						SSGhost_Waitframes(this, ghost, 32);
					}
				}
				while(Screen->D[D_EGGCONTROL]<=0){
					SSGhost_Waitframe2(this, ghost);
				}
			}
		}
	}
	
	ffc script NSMeteorSuper{
		const int METEORBITMAP = 0;
		const int YDIST = 1;
		const int WEAKPOINT = 2;
		const int WEAKPOINTANGLE = 3;
		const int EMBERS = 4;
		const int WEAKPOINTFLASH = 5;
		const int WEAKPOINTSTALE = 6;
		const int METEORHP = 7;
		const int METEORSPEED = 8;
		const int METEORVY = 9;
		const int SHOTANG = 10;
		const int CHARGESHOTS = 11;
		
		const int MAX_EMBER = 32;
			
		void DrawNSMeteor(untyped vars){
			bitmap meteorEnergy = vars[METEORBITMAP];
			npc weakPoints = vars[WEAKPOINT];
			int weakPointAngle = vars[WEAKPOINTANGLE];
			int weakPointFlash = vars[WEAKPOINTFLASH];
			int weakPointStale = vars[WEAKPOINTSTALE];
			
			int offX = Rand(-2, 2);
			int offY = Rand(-2, 2);
			int clr = Choose(0x76, 0x77, 0x78, 0x79);
			meteorEnergy->ReplaceColors(0, clr, 0x01, 0xBF);
			meteorEnergy->Blit(4, RT_SCREEN, 0, 128, 288, 48, -16+offX, -176+vars[YDIST]+128+4+offY, 288, 48, 0, 0, 0, 0, 0, true);
			
			if(vars[CHARGESHOTS]){
				for(int i=0; i<9; ++i){
					int ang = vars[SHOTANG]+Lerp(-18, 18, i/8);
					if(vars[CHARGESHOTS]==2)
						ang = vars[SHOTANG]+Lerp(-5, 5, i/8);
					int x = 128+VectorX(384+4, ang);
					int y = -384+VectorY(384+4, ang)+vars[YDIST];
					Screen->Circle(4, x+offX, y+offY, Rand(8, 12), clr, 1, 0, 0, 0, true, 128);
				}
			}
			
			offX = Rand(-2, 2);
			offY = Rand(-2, 2);
			Screen->DrawTile(4, -16+offX, -176+vars[YDIST]+offY, 122200, 18, 11, 0, -1, -1, 0, 0, 0, 0, true, 128);
		
			int stale[3];
			for(int i=0; i<3; ++i){
				weakPointStale[i] = Clamp(weakPointStale[i], 0, 5);
			}
			
			for(int i=0; i<3; ++i){
				int x = 120+VectorX(364, weakPointAngle[i]);
				int y = -376+vars[YDIST]+VectorY(364, weakPointAngle[i]);
				weakPoints[i]->X = Clamp(x, -16, 256);
				weakPoints[i]->Y = Clamp(y, -16, 176);
				weakPoints[i]->Stun = 64;
				int cmb = 51948;
				if(weakPointFlash[i]){
					++cmb;
					--weakPointFlash[i];
				}
				Screen->DrawCombo(4, x+offX, y+offY, cmb, 1, 1, 0, -1, -1, x, y, -90+weakPointAngle[i], -1, 0, true, 128);
				// Screen->DrawInteger(4, x, y, FONT_Z3SMALL, 0x01, 0x0F, -1, -1, weakPointStale[i], 0, 128);
				if(weakPoints[i]->HP<10000){
					int damage = 10000-weakPoints[i]->HP;
					damage = Ceiling(Lerp(damage, damage*0.1, Clamp(weakPointStale[i]/5, 0, 1)));
					
					DamageNumbers_AddNumberGFX(x+Rand(-4, 4), y+4+Rand(-4, 4)-DAMAGENUMBERS_HEIGHT/2, _DNUM_TYPE_ENEMYDAMAGE, damage);
					vars[METEORHP] -= damage;
					
					int vY = Lerp(vars[METEORSPEED]*2, vars[METEORSPEED]*10, Clamp(damage, 0, 800)/800);
					if(vars[YDIST]<80){
						vY = Lerp(0, vY, vars[YDIST]/80);
					}
					if(vars[METEORVY]>-vY)
						vars[METEORVY] = -vY;
					
					weakPoints[i]->HP = 10000;
					weakPoints[i]->Misc[NPCM_DAMAGENUMBERSLASTHP] = 10000;
					weakPointFlash[i] = 32;
					
					weakPointStale[i] += 2;
					for(int j=0; j<3; ++j){
						if(j!=i){
							if(weakPointStale[j]>2&&weakPointStale[i]<=2){
								if(vars[YDIST]>112)
									weakPointStale[j] -= 3;
								else
									weakPointStale[j] -= 2;
							}
							else{
								if(vars[YDIST]>112)
									weakPointStale[j] -= 2;
								else
									--weakPointStale[j];
							}
						}
					}
				}
			}
			
			int embers = vars[EMBERS];
			int emberAngles = embers[0];
			int emberT = embers[1];
			int emberMaxT = embers[2];
			int emberMult = embers[3];
			int emberAmp = embers[4];
			int emberYOff = embers[5];
			
			for(int i=0; i<MAX_EMBER; ++i){
				if(emberT[i]<emberMaxT[i]){
					if(emberT[i]>=0){
						int x = 128+VectorX(384-4, emberAngles[i])+emberAmp[i]*Sin(emberT[i]*4*emberMult[i])+offX;
						int y = -376+vars[YDIST]+VectorY(384-4, emberAngles[i])-Lerp(0, 48, emberT[i]/32)+offY+emberYOff[i];
						int r = Lerp(3, 0, emberT[i]/emberMaxT[i]);
						if(emberYOff[i]!=0){
							if(emberT[i]<8)
								r = Lerp(0, r, emberT[i]/8);
							
							r *= Lerp(0, 2, Abs(emberYOff[i]/120));
						}
						Screen->Circle(4, x, y, r, clr, 1, 0, 0, 0, true, 128);
					}
					++emberT[i];
				}
				else{
					emberAngles[i] = 90+(360/(768*PI))*Rand(-144, 144);
					emberT[i] = Rand(-4, 0);
					emberMaxT[i] = Rand(24, 96);
					emberMult[i] = Rand(8, 16)*0.1*Choose(-1, 1);
					emberAmp[i] = Rand(8, 16);
					emberYOff[i] = 0;
					if(Rand(2))
						emberYOff[i] = Rand(-120, 0);
				}
			}
		}
		void run(int meteorSpeed, int phase){
			int i; int j; int k;
			int quakeTimer[1];
			bitmap meteorEnergy = Game->CreateBitmap(288, 176);
			meteorEnergy->Own();
			meteorEnergy->Clear(0);
			meteorEnergy->DrawTile(0, 0, 0, 122200, 18, 11, 0, -1, -1, 0, 0, 0, 0, true, 128);
			
			npc weakPoints[3];
			int weakPointAngle[3];
			int weakPointFlash[3];
			int weakPointStale[3];
			
			for(i=0; i<3; ++i){
				weakPoints[i] = CreateNPCAt(246, 120, -32);
				weakPointAngle[i] = Lerp(90+10, 90-10, i/2)+Rand(-2, 2);
				weakPoints[i]->DrawYOffset = -1000;
			}
			
			int emberAngles[MAX_EMBER];
			int emberT[MAX_EMBER];
			int emberMaxT[MAX_EMBER];
			int emberMult[MAX_EMBER];
			int emberAmp[MAX_EMBER];
			int emberYOff[MAX_EMBER];
			
			for(i=0; i<MAX_EMBER; ++i){
				emberAngles[i] = 90+(360/(768*PI))*Rand(-144, 144);
				emberMaxT[i] = Rand(24, 96);
				emberT[i] = Rand(0, emberMaxT);
				emberMult[i] = Rand(8, 16)*0.1*Choose(-1, 1);
				emberAmp[i] = Rand(8, 16);
				emberYOff[i] = 0;
				if(Rand(2))
					emberYOff[i] = Rand(-120, 0);
			}
			
			int embers[] = {emberAngles, emberT, emberMaxT, emberMult, emberAmp, emberYOff};
			
			untyped vars[16];
			vars[METEORBITMAP] = meteorEnergy;
			vars[YDIST] = 0;
			vars[WEAKPOINT] = weakPoints;
			vars[WEAKPOINTANGLE] = weakPointAngle;
			vars[EMBERS] = embers;
			vars[WEAKPOINTFLASH] = weakPointFlash;
			vars[WEAKPOINTSTALE] = weakPointStale;
			vars[METEORHP] = HP_NIGHTMARESELET_METEOR;//3000;
			vars[METEORSPEED] = meteorSpeed;
			int meteorDecay = vars[METEORSPEED]/8;
			
			for(i=0; i<16; ++i){
				vars[YDIST] = Lerp(0, 56, i/15);
				LoopingSFX(quakeTimer, 30, 74);
				DrawNSMeteor(vars);
				Waitframe();
			}
			Screen->D[7] = 1;
			
			int attackTimer = 180;
			int attackAlternate;
			int lightningCycle;
			while(vars[METEORHP]>0){
				if(attackTimer){
					--attackTimer;
					if(attackTimer==120&&phase==1){
						if(lightningCycle==1||!IsEasyMode()){
							eweapon e = FireEWeapon(EW_STELLAR, Link->X, Link->Y, 0, 0, NSDamage(_DAMAGE_NIGHTMARESELET_LIGHTNING), SPRITE_INVISIBLE, 0, EWF_UNBLOCKABLE);
							e->CollDetection = false;
							e->Extend = 3;
							e->DrawXOffset = -8;
							e->DrawYOffset = -8;
							e->TileWidth = 2;
							e->TileHeight = 2;
							e->HitXOffset = -4;
							e->HitYOffset = -4;
							e->HitWidth = 24;
							e->HitHeight = 24;
							RunEWeaponScript(e, "StellarLightning", {1, SPR_STELLARLIGHTNING2});
						}
						lightningCycle = (lightningCycle+1)%2;
					}
						
					if(attackTimer==60){
						Game->PlaySound(SFX_CHARGE1);
						if(attackAlternate==0){
							vars[SHOTANG] = 90+Rand(-20, 20)/10;
							vars[CHARGESHOTS] = 1;
						}
						else{
							vars[SHOTANG] = Angle(120, -384, Link->X+8, Link->Y+8);
							vars[CHARGESHOTS] = 2;
						}
						attackAlternate = (attackAlternate+1)%2;
						if(IsEasyMode())
							attackAlternate = 0;
					}
				}
				else{
					for(int i=0; i<9; ++i){
						int ang = vars[SHOTANG]+Lerp(-18, 18, i/8);
						if(vars[CHARGESHOTS]==2)
							ang = vars[SHOTANG]+Lerp(-5, 5, i/8);
						int x = 128+VectorX(384+4, ang);
						int y = -384+VectorY(384+4, ang)+vars[YDIST];
						for(int j=0; j<3; ++j){
							eweapon e = FireEWeapon(EW_SCRIPT10, x-8, y-8, DegtoRad(ang), 400+50*j, NSDamage(_DAMAGE_NIGHTMARESELET_FIREBALLS), SPR_COSMICBALL2, SFX_COSMICBALL, EWF_UNBLOCKABLE);
						}
					}
					attackTimer = 180;
					vars[CHARGESHOTS] = 0;
				}
				
				vars[YDIST] += meteorSpeed;
				vars[YDIST] += vars[METEORVY];
				if(vars[METEORVY]<0){
					vars[METEORVY] = Min(vars[METEORVY]+meteorDecay, 0);
				}
				vars[YDIST] = Min(vars[YDIST], 168);
				if(vars[YDIST]>=168-32){
					Game->PlaySound(SFX_BOMB);
					Game->PlaySound(79);
					Game->PlaySound(75);
					for(i=0; i<16; ++i){
						Screen->Ellipse(6, 128, vars[YDIST], Lerp(0, 256, i/16), Lerp(0, 176, i/16), 0x01, 1, 0, 0, 0, true, 128);
						DrawNSMeteor(vars);
						NoAction();
						Waitframe();
					}
					Link->HP = 0;
					G[G_ASHERHP] = 0;
					G[G_TORRINHP] = 0;
					G[G_KAYLANIHP] = 0;
					for(i=0; i<8; ++i){
						Screen->Rectangle(6, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 128);
						NoAction();
						Waitframe();
					}
				}
				LoopingSFX(quakeTimer, 30, 74);
				DrawNSMeteor(vars);
				
				Waitdraw();
				int y = -376+vars[YDIST]+VectorY(384-8, Angle(120, -376-8, Link->X, Link->Y));
				Link->Y = Min(Max(Link->Y, y), 128);
				Waitframe();
			}
			Screen->D[7] = 0;
			Game->PlaySound(139);
			Game->PlaySound(93);
			vars[CHARGESHOTS] = 0;
			for(i=0; i<32; ++i){
				vars[YDIST] -= 8;
				
				DrawNSMeteor(vars);
				Waitframe();
			}
			Game->PlaySound(137);
			Game->PlaySound(79);
			Game->PlaySound(105);
			ClearEWeapons();
			for(i=0; i<32; ++i){
				if(i<24)
					Screen->Rectangle(6, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 128);
				else if(i<28){
					Screen->Rectangle(6, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 64);
					Screen->Rectangle(6, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 64);
				}
				else
					Screen->Rectangle(6, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 64);
				Waitframe();
			}
		}
	}

	npc script NightmareFragment{
		const int EYESTATE = 0;
		const int DEFS = 1;
		const int ANGLE = 2;
		const int ARMEXTEND = 3;
		const int BODYSCALE = 4;
		const int TENTACLEFRAMES = 5;
		const int SPAWNTYPE = 6;
		
		void NFDraw(npc this, untyped vars){
			int tentacleFrames = vars[TENTACLEFRAMES];
			
			Screen->Circle(2, this->X+8+Rand(-1, 1), this->Y+8+Rand(-1, 1), Lerp(0, Rand(6, 8), vars[BODYSCALE]), 0x0F, 1, 0, 0, 0, true, 128);
			if(vars[ARMEXTEND]){
				for(int j=0; j<3; ++j){
					int ang = vars[ANGLE]+120*j;
					int extend = Lerp(0, 24, vars[ARMEXTEND]);
					ScreenTentacleLong2(2, this->X+8+Rand(-1, 1), this->Y+8+Rand(-1, 1), extend, ang, tentacleFrames[j], 0, 2);
					tentacleFrames[j] = (tentacleFrames[j]+3)%90;
					if(this->CollDetection&&RotRectCollision(this->X+8+VectorX(extend/2, ang), this->Y+8+VectorY(extend/2, ang), extend/2, 3, ang, Link->X+8, Link->Y+8, 4, 4, 0, false)){
						DamageLink(this->Damage, this->X, this->Y);
					}
				}
			}
			if(vars[EYESTATE]>0){
				Screen->DrawTile(2, this->X, this->Y, 117742+vars[EYESTATE]-1, 1, 1, 7, -1, -1, this->X, this->Y, vars[ANGLE], 0, true, 128);
			}
		}
		void NFWaitframe(npc this, untyped vars, int frames){
			for(int i=0; i<frames; ++i){
				if(this->HP<=0){
					this->CollDetection = false;
					for(int i=0; i<3; ++i){
						--vars[EYESTATE];
						for(int j=0; j<2; ++j){
							if(Screen->isSolid(this->X+8, this->Y+8)){
								this->MoveAtAngle(Angle(this->X, this->Y, 120, 88), 1, SPW_FLOATER);
							}
							NFDraw(this, vars);
							Waitframe();
						}
					}
					for(int i=0; i<8; ++i){
						if(Screen->isSolid(this->X+8, this->Y+8)){
							this->MoveAtAngle(Angle(this->X, this->Y, 120, 88), 1, SPW_FLOATER);
						}
						vars[ARMEXTEND] = 1-i/7;
						NFDraw(this, vars);
						Waitframe();
					}
					int id = I_HEART;
					int count = 1;
					int angle = 0;
					if(vars[SPAWNTYPE]==1)
						id = I_MAGICJAR2;
					else if(vars[SPAWNTYPE]==2)
						id = I_MAGICJAR1;
					else if(vars[SPAWNTYPE]==3)
						id = 79; //Bomb ammo
					else if(vars[SPAWNTYPE]==4){
						id = I_HEART;
						count = 3;
						angle = -90;
					}
					for(int i=0; i<count; ++i){
						int x = Clamp(this->X, 32+4, 208-4);
						int y = Clamp(this->Y, 64+4, 128-4);
						if(count>1){
							x += VectorX(4, angle+(360/count)*i);
							y += VectorY(4, angle+(360/count)*i);
						}
						item itm = CreateItemAt(id, x, y);
						itm->Pickup = IP_TIMEOUT;
						for(int i=0; i<8; ++i){
							vars[BODYSCALE] = 1-i/7;
							NFDraw(this, vars);
							Waitframe();
						}
					}
					this->HP = -1000;
					this->Immortal = false;
					Quit();
				}
				NFDraw(this, vars);
				Waitframe();
			}
		}
		void run(int tX, int tY, int step, int spawnType){
			int i; int j; int k;
			untyped vars[16];
			int tentacleFrames[3];
			int defenses[MAX_DEFENSE];
			vars[DEFS] = defenses;
			vars[TENTACLEFRAMES] = tentacleFrames;
			vars[ANGLE] = Rand(360);
			vars[SPAWNTYPE] = spawnType;
			StoreDefenses(this, defenses);
			SetAllDefenses(this, NPCDT_IGNORE);
			for(i=0; i<3; ++i){
				tentacleFrames[i] = Rand(90);
			}
			this->HitXOffset = -1;
			this->HitYOffset = -1;
			this->HitWidth = 18;
			this->HitHeight = 18;
			
			this->DrawYOffset = -1000;
			this->Immortal = true;
			this->CollDetection = false;
			int dist = Distance(this->X, this->Y, tX, tY);
			while(Distance(this->X, this->Y, tX, tY)>step){
				vars[BODYSCALE] = 1-(Distance(this->X, this->Y, tX, tY)/dist);
				this->MoveAtAngle(Angle(this->X, this->Y, tX, tY), step, SPW_FLOATER);
				NFWaitframe(this, vars, 1);
			}
			this->CollDetection = true;
			vars[BODYSCALE] = 1;
			this->X = tX;
			this->Y = tY;
			j = Rand(12, 20);
			for(i=0; i<j; ++i){
				vars[ARMEXTEND] = i/(j-1);
				NFWaitframe(this, vars, 1);
			}
			vars[ARMEXTEND] = 1;
			for(i=0; i<3; ++i){
				++vars[EYESTATE];
				NFWaitframe(this, vars, 3);
			}
			SetDefenses(this, defenses);
			while(true){
				int frames = Rand(128, 192);
				int turnDir = Choose(-1, 1);
				for(i=0; i<frames; ++i){
					vars[ANGLE] = WrapDegrees(vars[ANGLE]+0.5*turnDir);
					NFWaitframe(this, vars, 1);
				}
				int angle = Angle(this->X, this->Y, Link->X, Link->Y)+Choose(-30, 30, -20, 20, 0);
				frames = Rand(48, 96);
				for(i=0; i<frames; ++i){
					this->MoveAtAngle(angle, Lerp(2, 0, i/frames), SPW_FLOATER);
					vars[ANGLE] = WrapDegrees(vars[ANGLE]+4*turnDir);
					NFWaitframe(this, vars, 1);
				}
			}
		}
	}
}

npc script ConstantTrap{
	void run(){
		Waitframes(4);
		int udlr = this->Attributes[0];
		if(udlr==0)
			udlr = Choose(1, 2);
		switch(udlr){
			case 1: this->Dir = (this->X<=112)?DIR_RIGHT:DIR_LEFT; break;
			case 2: this->Dir = (this->Y<=72)?DIR_DOWN:DIR_UP; break;
		}
		int stepBuf[1];
		while(true){
			if(CrystalSwitch[CRSW_LINKONRAISED])
				this->HitXOffset = -1000;
			else
				this->HitXOffset = 0;
			TrapMove(this, stepBuf, this->Dir, this->Step/100);
			if(!TrapCanWalk(this->X, this->Y, this->Dir)){
				if(!TrapCanWalk(this->X, this->Y, OppositeDir(this->Dir))){
					int oldX = this->X;
					int oldY = this->Y;
					this->X = GridX(this->X+8);
					this->Y = GridY(this->Y+8);
					if(!TrapCanWalk(this->X, this->Y, this->Dir)&&!TrapCanWalk(this->X, this->Y, OppositeDir(this->Dir))){
						if(TrapIsSolid(this->X+8, this->Y+8)){
							this->X = oldX;
							this->Y = oldY;
							this->HP = 0;
							Quit();
						}
						else{
							this->X = oldX;
							this->Y = oldY;
						}
					}
				}
				else{
					Game->PlaySound(SFX_TAP1);
					this->Dir = OppositeDir(this->Dir);
				}
			}
			Waitframe();
		}
	}
	void TrapMove(npc this, int stepBuf, int dir, int step){
		stepBuf[0] += step;
		int steps = Floor(stepBuf[0]);
		for(int i=0; i<steps; ++i){
			if(TrapCanWalk(this->X, this->Y, dir)){
				this->X += DirX(dir, 1);
				this->Y += DirY(dir, 1);
			}
		}
		stepBuf[0] -= steps;
	}
	bool TrapCanWalk(int x, int y, int dir){
		switch(dir){
			case DIR_UP:
				for(int i=0; i<=15; i=Min(i+8, 15)){
					if(TrapIsSolid(x+i, y-1))
						return false;
					if(i==15)
						return true;
				}
				break;
			case DIR_DOWN:
				for(int i=0; i<=15; i=Min(i+8, 15)){
					if(TrapIsSolid(x+i, y+16))
						return false;
					if(i==15)
						return true;
				}
				break;
			case DIR_LEFT:
				for(int i=0; i<=15; i=Min(i+8, 15)){
					if(TrapIsSolid(x-1, y+i))
						return false;
					if(i==15)
						return true;
				}
				break;
			case DIR_RIGHT:
				for(int i=0; i<=15; i=Min(i+8, 15)){
					if(TrapIsSolid(x+16, y+i))
						return false;
					if(i==15)
						return true;
				}
				break;
		}
		return true;
	}
	bool TrapIsSolid(int x, int y){
		if(x<0||x>255||y<0||y>175)
			return true;
		if(Screen->isSolid(x, y)){
			return true;
		}
		int pos = ComboAt(x, y);
		int cd = Screen->ComboD[pos];
		switch(cd){
			case 38560:
			case 38568:
				return true;
		}
		return false;
	}
}

ffc script Podoboo{ //This terrible script is unused. Yay.
	void run(int enemyid){
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		
		int combo = ghost->Attributes[10];
		
		Ghost_Transform(this, ghost, -1, -1, 1, 2);
		Ghost_SetHitOffsets(ghost, 0, 16, 0, 0);
		ghost->DrawYOffset -= 16;
		SetOverUnderLayer(ghost);
		
		// ghost->CollDetection = false;
		// ghost->DrawXOffset = 300;
		
		int Step = 2;
		int Jumpdist;
		
		int angle;
		int DestX;
		int DestY;
		int breakcounter;
		
		// for(int i = Rand(30, 180); i>0; i--){ //Wait around
			// SSGhost_Waitframe(this, ghost);
		// }
		// ghost->DrawXOffset = 0;
		// ghost->CollDetection = true;
		Ghost_Data = combo;

		while(true){
			
			
			for(int i = 30; i>0; i--){ //Wait around
				SSGhost_Waitframe(this, ghost);
			}
			//Jump
			breakcounter = 0;
			if(Rand(0,4) != 0){ //Aim at Link
				do{
					angle = Rand(0,359);
					breakcounter++;
				}
				while(AngDiffDeg(angle, Angle(Ghost_X, Ghost_Y, Link->X, Link->Y)) > 15 && breakcounter<100);
			}
			else{
				angle = Rand(0,359);
			}
			Jumpdist = Rand(16, 64);
			DestX = Ghost_X + VectorX(Jumpdist, angle);
			DestY = Ghost_Y + VectorY(Jumpdist, angle);
			
			for(int i = 30; i>0; i--){ //Wait 
				SSGhost_Waitframe(this, ghost);
			}
			
			int halftrav = Distance(Ghost_X, Ghost_Y, DestX, DestY) * 0.5;
			Ghost_Z = 1;
			int trav;
			while(Ghost_Z > 0){
				if(!isSolidForNPCs(Ghost_X + VectorX(Step, Angle(Ghost_X, Ghost_Y, DestX, DestY)), Ghost_Y + VectorY(Step, Angle(Ghost_X, Ghost_Y, DestX, DestY)))){
					Ghost_X += VectorX(Step, Angle(Ghost_X, Ghost_Y, DestX, DestY));
					Ghost_Y += VectorY(Step, Angle(Ghost_X, Ghost_Y, DestX, DestY));
				}
				if(trav > halftrav)
					Ghost_Z--;
				else
					Ghost_Z++;
				trav+=Step;
				SSGhost_Waitframe(this, ghost);
			}
			
		}
	}
}

//List Horizon Chase's HP as 12,500, 25,000 or 40,000 in the logbook depending on the most difficult version beaten

const int HORIZON_FIRSTHP = 12500;
const int HORIZON_SECONDHP = 12500;
const int HORIZON_THIRDHP = 15000;

const int HORIZON_PAL_BASE = 0x1C0; //The first of 13 palettes for Mt Silver Summit Night
const int HORIZON_PAL_LASER = 0x1C4; //The brightness laser attacks produce. I suggest putting all 13 of these in order so you don't have to redo any offsets
const int HORIZON_PAL_BRIGHT = 0x1C8; //Brightness the gameplay-super attacks produce. 
const int HORIZON_PAL_YEET = 0x1CC; //Brightness the phase transition supers create before annihilating the current character

const int HORIZON_PAL_SPEED = 8; //Cycle speed palletes interpolate at

const int D_HORIZON_FX = 1; //Screen D register that's used to synchronize colors of various FX

const int NPC_SUNFRIEND = 198; //Sun Cursetellation

const int NPCM_BURN_ASHER = 23; //These counters store the burn counters of each character for other scripts to reference
const int NPCM_BURN_TORRIN = 24; //By design, they do not clear when the player switches characters, so be mindful of that when referencing them; they will persist until the burn has expired or the boss uses an instakill super
const int NPCM_BURN_KAYLANI = 25; //They're read-only however and only exist for other scripts to detect and debugging purposes.

const int ITEMSET_HEART = 16; //100% heart droprate set
const int ITEMSET_MAGIC = 17; //100% small magic jar set
//If you want, you can make solar canisters come out of fishing the Cursetellations in this fight, but I'm not super picky either way

const int SFX_HORIZONLONGSHOT_APPEAR = 80; //Fuck man, I'm normally good with sounds but idfk what to do with this. Normal charges are too dramatic, most sounds are too subtle.
const int SFX_HORIZONSHOT = 153;
const int SFX_HORIZONLASER = 154;
const int SFX_HORIZONTELEPORT = 94; //Sor of a soundalike for the UC one.
const int SFX_HORIZONPUNCH = 155;
const int SFX_HORIZONPUNCH2 = 156; //Randomized sounds for the repeated impacts
const int SFX_HORIZONGIGASHOCKWAVE = 157; //First phase transition
const int SFX_HORIZONBEEGRUMBLE = 158; //Death approaches...
const int SFX_HORIZONPURGINGTHORN = 159;
const int SFX_HORIZONBEEGLASER = 160;
const int SFX_HORIZONSWORDAPPEAR = 161; //For the beeeg sword
const int SFX_HORIZONSWORDDROP = 162; //Beeeg sword dropping
const int SFX_HORIZONSWORDIMPACT = 163; 
const int SFX_HORIZONALARM = 164;

const int CMB_HORIZONHALO = 52223; //CSet doesn't matter because it's 8bit
const int CMB_HORIZONCLONE = 52260;
const int CMB_HORIZONSURFBOARD = 52219; //CS8
const int CMB_HORIZONAURA = 52256; //Final phase aura, 4 combos coinciding with direction

const int SPR_HORIZONSHOT3X1 = 114;
const int SPR_HORIZONBARRAGE = 120;
const int SPR_HORIZONSPAZER = 121;
const int SPR_HORIZONBURNFX = 122; //For characters on fire
const int SPR_HORIZONLIGHTSTREAM = 123; //4 frames of animation, 1 speed, CSet 3
const int SPR_HORIZONFIRE = 124; //Alt fire graphic for ground flames

const int TIL_HORIZONFIST1 = 111800;
const int TIL_HORIZONFIST2 = 111805; //lol 8bit
const int TIL_HORIZONSWORD = 111920; //CS3
const int TIL_HORIZONSWORDTRAIL = 112060; //Fuck you ZC. Refer to the sample quest. Yes it has to be like this, ZC doesn't draw transparent tiles that are not the same width/height.
const int TIL_HORIZONSPEAR = 112001; //Crystal tipped funny thing
const int TIL_HORIZONSPEAR_CHAIN = 112000;
const int TIL_HORIZONBIGSWORD = 112580; //YEETUS


const int MAP_HORIZON_SKY = 38; //Used for sword super
const int SCREEN_HORIZON_SKY = 0x77;

const int HORIZONSPEAR_STEP = 6;
const int HORIZONSPEAR_RETRACT_STEP = 8;

//Copyscreen templates
const int HORIZON_SCREEN_BASE = 0x03; //Base snowy screen.
const int HORIZON_SCREEN_MELTED = 0x04; //Melted barren mountaintop. Screen is ywkls-tier right now, but can easily be prettied up later.
const int HORIZON_SCREEN_DESTROYED = 0x05; //Another layer of destruction if you wish for the final phase. I have no idea how to DoR, but make it suitably fucked up!

const int C_BLACK = 0x0F;
const int C_WHITE = 0x01; 
const int C_GOLD1 = 0x34; //This color is the lower bound for yellows and golds used. Not actually the first one in the ramp, just the first "gold"looking one.
const int C_GOLD2 = 0x39; //This color is the upper bound for yellows and golds used


//Just for fun, you can adjust the displayed damage value of the instakill supers
const int DMG_SHOCKWAVESUPER = 9216; //Enough to oneshot a full 24 health gold tunic'd Link in an ordinary quest thrice over
const int DMG_BEEGLASERSUPER = 24740; //We Disgaea now
const int DMG_SOLARFINALITY = 182718; //THAT'S A LOTTA DAMAGE
