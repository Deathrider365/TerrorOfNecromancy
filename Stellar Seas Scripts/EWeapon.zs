eweapon script LunarSwirl{
	void run(int angle, int dist, int growSpeed, int swirlSpeed, int delay, int reaim, int reaimSpeed){
		if(reaimSpeed==0)
			reaimSpeed = 70;
		int i; int j; int k;
		int startX = this->X;
		int startY = this->Y;
		if(delay)
			Waitframes(delay);
		Game->PlaySound(SFX_WAND);
		for(j=0; j<36; j+=growSpeed){
			int x = VectorX(dist*Sin(j*5), j*swirlSpeed+angle);
			int y = VectorY(dist*Sin(j*5), j*swirlSpeed+angle);
			this->DrawXOffset = x;
			this->DrawYOffset = -2+y;
			this->HitXOffset = x;
			this->HitYOffset = y;
			Waitframe();
		}
		if(reaim){
			this->Angle = DegtoRad(Angle(this->X, this->Y, Link->X, Link->Y));
			this->Step = reaimSpeed;
			int j = 180;
			while(true){
				j = (j+swirlSpeed/2)%360;
				int x = VectorX(8, j+angle);
				int y = VectorY(8, j+angle);
				this->DrawXOffset = x;
				this->DrawYOffset = -2+y;
				this->HitXOffset = x;
				this->HitYOffset = y;
				Waitframe();
			}
		}
		this->DeadState = 0;
	}
}

eweapon script StellarBolt{
	void DrawExpandingRect(int layer, int x, int y, int angle, int rad, int c){
		int px[4];
		int py[4];
		for(int i=0; i<4; ++i){
			px[i] = x+VectorX(rad, angle+90*i);
			py[i] = y+VectorY(rad, angle+90*i);
		}
		Screen->Quad(layer, px[0], py[0], px[1], py[1], px[2], py[2], px[3], py[3], 1, 1, c, 0, -1, PT_FLAT);
	}
	void run(int newStep, int extrabounce){
		if(newStep==0)
			newStep = this->Step;
		int i;
		while(!Screen->isSolid(this->X+8, this->Y+8)){
			this->Rotation = RadtoDeg(this->Angle);
			this->DeadState = WDS_ALIVE;
			Waitframe();
		}
		this->UseSprite(SPR_STELLARRING);
		this->Step = 0;
		this->Rotation = 0;
		for(int i=0; i<32; ++i){
			this->DeadState = WDS_ALIVE;
			Waitframe();
		}
		this->UseSprite(SPR_STELLARSHOT);
		Game->PlaySound(32);
		this->Angle = DegtoRad(Angle(this->X, this->Y, Link->X, Link->Y));
		i = 0;
		this->Step = newStep;
		if(extrabounce){
			while(!Screen->isSolid(this->X+8, this->Y+8)||i<4){
				++i;
				this->Rotation = RadtoDeg(this->Angle);
				this->DeadState = WDS_ALIVE;
				Waitframe();
			}
			this->UseSprite(SPR_STELLARRING);
			this->Step = 0;
			this->Rotation = 0;
			for(int i=0; i<32; ++i){
				this->DeadState = WDS_ALIVE;
				Waitframe();
			}
			this->UseSprite(SPR_STELLARSHOT);
			Game->PlaySound(32);
			this->Angle = DegtoRad(Angle(this->X, this->Y, Link->X, Link->Y));
			i = 0;
			this->Step = newStep;
		}
		while(!Screen->isSolid(this->X+8, this->Y+8)||i<4){
			++i;
			this->Rotation = RadtoDeg(this->Angle);
			this->DeadState = WDS_ALIVE;
			Waitframe();
		}
		int angle = RadtoDeg(this->Angle);
		this->DrawYOffset = -1000;
		this->CollDetection = false;
		this->Step = 0;
		Game->PlaySound(SFX_BOMB);
		for(i=8; i<48; ++i){
			int len = Min(i*1.5, 24);
			if(i<40||i%2==0){
				DrawExpandingRect(4, this->X+8+VectorX(i/2, angle), this->Y+8+VectorY(i/2, angle), angle+10*i, len, Choose(0x91, 0x96, 0x97));
				DrawExpandingRect(4, this->X+8+VectorX(i/2, angle), this->Y+8+VectorY(i/2, angle), angle+10*i+45, len, Choose(0x91, 0x96, 0x97));
			}
			MakeHitbox(EW_STELLAR, this->X+8-len*0.75, this->Y+8-len*0.75, len*1.5, len*1.5, this->Damage);
			Waitframe();
		}
		this->DeadState = 0;
	}
}

const int SPR_STELLARLIGHTNING = 111;
const int SPR_STELLARLIGHTNING2 = 113;

eweapon script StellarLightning{
	void DrawQuadSegment(int layer, int x1, int y1, int a1, int w1, int x2, int y2, int a2, int w2, int c){
		a1 -= 90;
		a2 -= 90;
		if(Abs(AngDiff(a1, a2))>90){
			a2 += 180;
		}
		int verts[8];
		verts[0] = x1+VectorX(w1, a1);
		verts[1] = y1+VectorY(w1, a1);
		
		verts[2] = x2+VectorX(w2, a2);
		verts[3] = y2+VectorY(w2, a2);
		
		verts[4] = x2+VectorX(-w2, a2);
		verts[5] = y2+VectorY(-w2, a2);
		
		verts[6] = x1+VectorX(-w1, a1);
		verts[7] = y1+VectorY(-w1, a1);
		
		Screen->Quad(layer, verts[0], verts[1], verts[2], verts[3], verts[4], verts[5], verts[6], verts[7], 1, 1, c, 0, -1, PT_FLAT);
		// for(int i=0; i<4; ++i){
			// int j = (i+1)%4;
			// Screen->Line(6, verts[i*2+0], verts[i*2+1], verts[j*2+0], verts[j*2+1], Rand(1, 16), 1, 0, 0, 0, 128);
		// }
	}
	void DrawLightning(eweapon this, int layer, int angle, int lX, int lY, int w, int c, bool collideWall){
		int lX2[16];
		int lY2[16];
		for(int i=0; i<16; ++i){
			lX2[i] = this->X+7+VectorX(16*i, angle)+lX[i];
			lY2[i] = this->Y+7+VectorY(16*i, angle)+lY[i];
		}
		
		for(int i=0; i<15; ++i){
			int a1; int a2;
			int w1; int w2;
			
			// int x = this->X+7+VectorX(16*i, angle)+lX[i];
			// int y = this->Y+7+VectorY(16*i, angle)+lY[i];
			// int x2 = this->X+7+VectorX(16+16*i, angle)+lX[i+1];
			// int y2 = this->Y+7+VectorY(16+16*i, angle)+lY[i+1];
			if(i>0){
				a1 = AngleAverage(Angle(lX2[i-1], lY2[i-1], lX2[i], lY2[i]), Angle(lX2[i], lY2[i], lX2[i+1], lY2[i+1]));
				w1 = w;
			}
			if(i<14){
				a2 = AngleAverage(Angle(lX2[i], lY2[i], lX2[i+1], lY2[i+1]), Angle(lX2[i+1], lY2[i+1], lX2[i+2], lY2[i+2]));
				w2 = w;
			}
			bool collided;
			if(collideWall){
				if(Screen->isSolid(lX2[i]-lX[i], lY2[i]-lY[i])){
					w2 = 0;
					collided = true;
				}
			}
			DrawQuadSegment(layer, lX2[i], lY2[i], a1, w1, lX2[i+1], lY2[i+1], a2, w2, c);
			if(collided)
				break;
			// DrawThickLine(layer, x, y, x2, y2, w, c, true, 128);
		}
		int x = this->X+7+VectorX(128, angle);
		int y = this->Y+7+VectorY(128, angle);
		if(this->Damage>0){
			if(RotRectCollision(x, y, 128, 6, angle, Link->X+7, Link->Y+7, 4, 4, 0, false)){
				MakeHitbox(EW_STELLAR, Link->X, Link->Y, 16, 16, this->Damage);
			}
		}
	}
	void FindEndPoint(int xy, int x, int y, int angle){
		for(int i=40; i<256; i+=8){
			x += VectorX(8, angle);
			y += VectorY(8, angle);
			if(Screen->isSolid(x, y)||!InScreen(x, y, 1, 1)){
				break;
			}
		}
		x -= VectorX(8, angle);
		y -= VectorY(8, angle);
		for(int i=0; i<8; ++i){
			x += VectorX(1, angle);
			y += VectorY(1, angle);
			if(Screen->isSolid(x, y)||!InScreen(x, y, 1, 1)){
				xy[0] = x;
				xy[1] = y;
				return;
			}
		}
		xy[0] = x;
		xy[1] = y;
	}
	void run(int altPal, int waitSpawn, int redirects){
		bool hitWall = true;
		while(redirects>=0){
			if(hitWall){
				if(waitSpawn){
					for(int i=0; i<64; ++i){
						if(Floor((i%8)/2)%2==0){
							Screen->Circle(2, this->X+8, this->Y+8, (i%8<4)?8:12, 0x01, 1, 0, 0, 0, true, 128);
						}
						this->DeadState = WDS_ALIVE;
						Waitframe();
					}
					int lX[16];
					int lY[16];
					for(int i=0; i<16; ++i){
						lX[i] = Rand(-8, 8);
						lY[i] = Rand(-8, 8);
					}
					Game->PlaySound(78);
					this->UseSprite(waitSpawn);
					this->CollDetection = true;
					int damage = this->Damage;
					for(int i=0; i<8; ++i){
						int clr = Choose(0x91, 0x96, 0x97);
						if(altPal)
							clr = Choose(0x71, 0x76, 0x77);
						DrawLightning(this, 6, -90, lX, lY, i/2, clr, false);
						this->DeadState = WDS_ALIVE;
						Waitframe();
					}
					this->Damage = damage;
				}
				else{
					while(!Screen->isSolid(this->X+7, this->Y+7)&&this->X>0&&this->X<240&&this->Y>0&&this->Y<160){
						this->DeadState = WDS_ALIVE;
						Waitframe();
					}
					int x = this->X;
					int y = this->Y;
					int ang = RadtoDeg(this->Angle);
					for(int i=0; i<8&&Screen->isSolid(x+7, y+7); ++i){
						x -= VectorX(1, ang);
						y -= VectorY(1, ang);
					}
					this->X = x;
					this->Y = y;
				}
			}
			hitWall = false;
			
			if(!InScreen(this->X, this->Y, 16, 16, true)){
				this->DeadState = 0;
				Quit();
			}
			
			this->Step = 0;
			int lX[16];
			int lY[16];
			for(int i=0; i<16; ++i){
				lX[i] = Rand(-8, 8);
				lY[i] = Rand(-8, 8);
			}
			int tX = Link->X;
			int tY = Link->Y;
			for(int i=0; i<60; ++i){
				tX = Link->X;
				tY = Link->Y;
				int angle = Angle(this->X, this->Y, Link->X, Link->Y);
				int xy[2];
				FindEndPoint(xy, this->X+7, this->Y+7, angle);
				int dist = Distance(this->X+8, this->Y+8, xy[0], xy[1]);
				if(redirects<=0)
					dist = 256;
				if(i%4<2)
					Screen->Line(2, this->X+7, this->Y+7, this->X+7+VectorX(dist, angle), this->Y+7+VectorY(dist, angle), 0x01, 1, 0, 0, 0, 128);
				this->DeadState = WDS_ALIVE;
				Waitframe();
			}
			int angle = Angle(this->X, this->Y, Link->X, Link->Y);
			for(int i=0; i<30; ++i){
				int xy[2];
				FindEndPoint(xy, this->X+7, this->Y+7, angle);
				int dist = Distance(this->X+8, this->Y+8, xy[0], xy[1]);
				if(redirects<=0)
					dist = 256;
				if(i%4<2)
					Screen->Line(2, this->X+7, this->Y+7, this->X+7+VectorX(dist, angle), this->Y+7+VectorY(dist, angle), 0x01, 1, 0, 0, 0, 128);
				this->DeadState = WDS_ALIVE;
				Waitframe();
			}
			Game->PlaySound(78);
			for(int i=0; i<8; ++i){
				int clr = Choose(0x91, 0x96, 0x97);
				if(altPal)
					clr = Choose(0x71, 0x76, 0x77);
				DrawLightning(this, 2, angle, lX, lY, i/2, clr, redirects>0);
				this->DeadState = WDS_ALIVE;
				Waitframe();
			}
			if(redirects>0){
				int xy[2];
				FindEndPoint(xy, this->X+7, this->Y+7, angle);
				if(InScreen(xy[0]-8, xy[1]-8, 16, 16, true)){
					this->X = xy[0]-8;
					this->Y = xy[1]-8;
				}
				else{
					this->DeadState = 0;
					Quit();
				}
			}
			
			--redirects;
		}
		this->DeadState = 0;
	}
}

const int SFX_SOLARBIGSHOT_CHARGE = 35;
const int SFX_SOLARBIGSHOT_FIRE = 40;

//"SolarBigShot"
eweapon script SolarBigShot{
	void DrawBigShot(int x, int y, int rad, int damage, int i, int flash){
		int r = rad+2*Sin(i);
		int clr[3] = {0x88, 0x86, 0x81};
		if(flash==0){
			clr[0] = 0x88;
			clr[1] = 0x87;
			clr[2] = 0x86;
		}
		if(flash==2){
			clr[0] = 0x86;
			clr[1] = 0x81;
			clr[2] = 0x81;
		}
		Screen->Circle(2, x, y, rad+2*Sin(i), clr[0], 1, 0, 0, 0, true, 128);
		Screen->Circle(2, x, y, rad*0.875+2*Sin(i), clr[1], 1, 0, 0, 0, true, 128);
		Screen->Circle(2, x, y, rad*0.625+2*Sin(i), clr[2], 1, 0, 0, 0, true, 128);
		DarkRoom_AddLight(x, y, 0, rad+16, 1, 0, 0, 0);
		MakeHitbox(EW_SOLAR, x-r*0.7071, y-r*0.7071, r*2*0.7071, r*2*0.7071, damage);
	}
	void run(int chargeTime, int growDelay, int growth, int accel, int angleturn, int maxradius){
		this->DrawYOffset = -1000;
		int rad = 0;
		this->CollDetection = false;
		int x = this->X+8;
		int y = this->Y+8;
		int step = 0;
		int anim;
		if(chargeTime==0)
			rad = 8;
		bool maxRadiusActuallyWorks; //I don't know what max radius is doing here, but it sure isn't a max radius sooo...when I want weapons to move and have a max radius, I give them a negative one
		if(maxradius<0){
			maxRadiusActuallyWorks = true;
			maxradius = Abs(maxradius);
		}
		while(x>-rad&&x<255+rad&&y>-rad&&y<175+rad&&(maxRadiusActuallyWorks||(maxradius==0 || (maxradius > 0 && rad < maxradius)))){
			anim = (anim+4)%5040;
			if(chargeTime){
				--chargeTime;
				if(rad<8)
					rad = Min(rad+0.5, 8);
				if(chargeTime==0)
					step = 0;
			}
			else if(growDelay){
				step += accel;
				--growDelay;
				if(!growDelay)
					Game->PlaySound(SFX_SOLARBIGSHOT_FIRE);
			}
			else{
				step += accel;
				rad += growth*step;
			}
			if(maxRadiusActuallyWorks)
				rad = Min(rad, maxradius);
			if(maxradius == 0 || maxRadiusActuallyWorks){
				if(this->Angular){
					this->Angle += DegtoRad(angleturn);
					x += VectorX(step, RadtoDeg(this->Angle));
					y += VectorY(step, RadtoDeg(this->Angle));
				}
				else{
					x += DirX(this->Dir, step);
					y += DirY(this->Dir, step);
				}
			}

			DrawBigShot(x, y, rad, this->Damage, anim, Floor(anim/4)%4);
			Waitframe();
		}
		if(maxradius > 0 && !maxRadiusActuallyWorks){
			int maxrad = rad+8;
			int minrad = rad-8;
			int dir;
			for(int i = 0; i<75; i++){
				if(dir == 0){
					rad++;
					if(rad == maxrad)
						dir = 1;
				}
				else if(dir == 1){
					rad--;
					if(rad == minrad)
						dir = 0;
				}
				DrawBigShot(x, y, rad, this->Damage, anim, Floor(anim/4)%4);
				Waitframe();
			}
			while(rad > 0){
				rad -= growth*step;
				DrawBigShot(x, y, rad, this->Damage, anim, Floor(anim/4)%4);
				Waitframe();
			}
		}
		this->DeadState = 0;
	}
}

eweapon script MagicBatteryEW{
	void run(int dir, int element, int effect){
		this->OriginalTile = TIL_MAGICBATTERY_PROJECTILE+20*element;
		this->Tile = this->OriginalTile;
		this->NumFrames = 4;
		this->ASpeed = 2;
		int z = 8;
		this->Z = z;
		int jump = 1;
		Game->PlaySound(SFX_JUMP);
		int step = 3;
		if(element==1&&effect==1)
			step = 1;
		int particleTimer;
		while(this->Z>0){
			++particleTimer;
			if(particleTimer%3==0){
				ParticleAnim(this->X+Rand(-4, 4), this->Y+Rand(-4, 4)-this->Z, TIL_MAGICBATTERY_SPARKLES+20*element, 0, 3, 4);
			}
			switch(dir){
				case DIR_UP:
					this->Y -= step;
					break;
				case DIR_DOWN:
					this->Y += step;
					break;
				case DIR_LEFT:
					this->X -= step;
					break;
				case DIR_RIGHT:
					this->X += step;
					break;
			}
			if(Screen->isSolid(this->X+8, this->Y+8)){
				Game->PlaySound(SFX_PLACE);
				dir = OppositeDir(dir);
			}
			z = Max(z+jump, 0);
			jump -= 0.25;
			this->Jump = 0;
			this->Z = z;
			Waitframe();
		}
		if(element==0){
			if(effect==0){ //Solar Chaser
				eweapon e = FireEWeapon(EW_SOLAR, this->X, this->Y, DegtoRad(DirAngle(dir)), 0, this->Damage, SPR_FRIENDBALL, SFX_WAND, 0);
				RunEWeaponScript(e, "SolarChaser", {0.05, 1.5, 60, 0.01});
				this->DeadState = 0;
				Quit();
			}
			else if(effect==1){ //Triple Sun
				this->DrawYOffset = -1000;
				int angle = Rand(360);
				this->CollDetection = false;
				int turnDir = Choose(-1, 1);
				Game->PlaySound(SFX_CHARGE1);
				for(int i=0; i<60; ++i){
					int c = Choose(0x81, 0x86, 0x87);
					angle = WrapDegrees(angle+10*turnDir);
					for(int j=0; j<3; ++j){
						int x = this->X+8+VectorX(8, angle+120*j);
						int y = this->Y+8+VectorY(8, angle+120*j);
						Screen->Circle(2, x+Rand(-1, 1), y+Rand(-1, 1), ((G[G_ANIM]%6<4)?2:6)+Rand(2), c, 1, 0, 0, 0, true, 128);
					}
					Screen->Circle(2, this->X+8+Rand(-1, 1), this->Y+8+Rand(-1, 1), ((G[G_ANIM]%6<4)?2:6)+Rand(2), c, 1, 0, 0, 0, true, 128);
					
					Waitframe();
				}
				for(int i=0; i<30; ++i){
					int c = Choose(0x81, 0x86, 0x87);
					for(int j=0; j<3; ++j){
						int x = this->X+8+VectorX(8, angle+120*j);
						int y = this->Y+8+VectorY(8, angle+120*j);
						Screen->Circle(2, x+Rand(-1, 1), y+Rand(-1, 1), ((G[G_ANIM]%6<4)?2:6)+Rand(2), c, 1, 0, 0, 0, true, 128);
					}
					Screen->Circle(2, this->X+8+Rand(-1, 1), this->Y+8+Rand(-1, 1), ((G[G_ANIM]%6<4)?2:6)+Rand(2), c, 1, 0, 0, 0, true, 128);
					
					Waitframe();
				}
				for(int j=0; j<3; ++j){
					int x = this->X+8+VectorX(8, angle+120*j);
					int y = this->Y+8+VectorY(8, angle+120*j);
					eweapon e = FireEWeapon(EW_SOLAR, x-8, y-8, DegtoRad(angle+120*j), 0, this->Damage, 0, SFX_LIGHTSHOT, EWF_UNBLOCKABLE);
					e->CollDetection = false;
					RunEWeaponScript(e, "SolarBigShot", {0, 8, 0.25, 0.2, 4*turnDir, -32});
				}
			}
		}
		if(element==1){
			if(effect==0){
				this->OriginalTile = TIL_MAGICBATTERY_PROJECTILE+20*element+4;
				this->Tile = this->OriginalTile;
				for(int i=0; i<32; ++i){
					Waitframe();
				}
				int angle = Angle(this->X, this->Y, Link->X, Link->Y)-90;
				for(int i=0; i<4; ++i){
					eweapon e = FireEWeapon(EW_LUNAR, this->X, this->Y, 0, 0, this->Damage, SPR_LUNARSHOT, SFX_FIREBALL, EWF_UNBLOCKABLE);
					RunEWeaponScript(e, "LunarSwirl", {angle, 16+i*4, 1, 20, i*4, 0});
					e = FireEWeapon(EW_LUNAR, this->X, this->Y, 0, 0, this->Damage, SPR_LUNARSHOT, SFX_FIREBALL, EWF_UNBLOCKABLE);
					RunEWeaponScript(e, "LunarSwirl", {angle+180, 16+i*8, 1, 20, i*4, 0});
				}
				this->DeadState = 0;
				Quit();
			}
			else if(effect==1){
				int angle = Angle(this->X, this->Y, Link->X, Link->Y);
				eweapon shot[5];
				this->DrawYOffset = -1000;
				for(int i=0; i<5; ++i){
					shot[i] = FireEWeapon(EW_LUNAR, this->X, this->Y, DegtoRad(angle), 0, this->Damage, SPR_LUNARPHASECUTTER, SFX_WAND, EWF_UNBLOCKABLE);
				}
				for(int j=0; j<12; ++j){
					for(int i=0; i<5; ++i){
						if(shot[i]->isValid()){
							shot[i]->X = this->X+VectorX(j*(i-2), angle+90);
							shot[i]->Y = this->Y+VectorY(j*(i-2), angle+90);
						}
					}
					Waitframe();
				}
				for(int i=0; i<5; ++i){
					if(shot[i]->isValid()){
						RunEWeaponScript(shot[i], "LunarPhaseCutter", {50, 100, 6, 0});
					}
				}
				this->DeadState = 0;
				Quit();
			}
		}
		else if(element==2){
			if(effect==0){
				for(int i=0; i<3; ++i){
					eweapon e = FireEWeapon(EW_STELLAR, this->X, this->Y, DegtoRad(DirAngle(dir)+120*i), 300, this->Damage, SPR_STELLARSHOT, 32, 0);
					e->Rotation = DirAngle(Ghost_Dir);
					RunEWeaponScript(e, "StellarBolt", {0});
				}
				this->DeadState = 0;
				Quit();
			}
			else if(effect==1){
				int num = 5;
				if(IsEasyMode())
					num = 3;
				for(int i=0; i<num; ++i){
					eweapon e = FireEWeapon(EW_STELLAR, this->X, this->Y, DegtoRad(Angle(this->X, this->Y, Link->X, Link->Y)+180+Rand(-165, 165)), 300, this->Damage, SPR_STELLARLIGHTNING, 32, EWF_UNBLOCKABLE);
					RunEWeaponScript(e, "StellarLightning", {0});
				}
				this->DeadState = 0;
				Quit();
			}
		}
	}
}

eweapon script MagicBatteryEWRasu{ //When I found out Moosh's battery script didn't allow for angular movement and had no way of accounting for where the battery would land... I was disappointed.
	void run(int element, int effect, int DestX, int DestY, int Step, npc ghost, int fireangle){
		this->OriginalTile = TIL_MAGICBATTERY_PROJECTILE+20*element;
		if(element==0 && effect==2) //Incoming Russ jank
			this->OriginalTile = 66128; //Ra, ra, hardcoding
		this->Tile = this->OriginalTile;
		this->NumFrames = 4;
		this->ASpeed = 2;
		if(element==0 && effect==2) //Incoming Russ jank
			this->ASpeed = 4; 
		int z = 0;
		this->Z = z;
		Game->PlaySound(SFX_JUMP);
		int particleTimer;
		int ThrowHeight = GetThrowHeight(this->X, this->Y, DestX, DestY, Step);
		int Angle = Angle(this->X, this->Y, DestX, DestY);
		bool bleck;
		int CurX = this->X;
		int CurY = this->Y;
		while(this->Z>0 || !bleck){
			//Moosh's animation  stuff
			++particleTimer;
			if(particleTimer%3==0){
				ParticleAnim(this->X+Rand(-4, 4), this->Y+Rand(-4, 4)-this->Z, TIL_MAGICBATTERY_SPARKLES+20*element, 0, 3, 4);
			}
			//Bouncing off walls
			if(Screen->isSolid(this->X+8, this->Y+8)){
				Game->PlaySound(SFX_PLACE);
				Angle += 180;
			}
			//Z axis movement
			ThrowHeight = Max(ThrowHeight-GH_GRAVITY, -GH_TERMINAL_VELOCITY);
			z += ThrowHeight;
			this->Jump = 0;
			this->Z = z;
			//Translational movement
			CurX += VectorX(Step, Angle);
			CurY += VectorY(Step, Angle);
			this->X = CurX;
			this->Y = CurY;
			//And then this stupidity to make sure it doesn't halt on frame 1
			if(!bleck)
				bleck = true;
			//Finally, a shadow
			Screen->FastTile(6, this->X, this->Y, 833, 0, OP_TRANS);
			Waitframe();
		}
		if(element==0){
			if(effect==1||effect==2){
				this->DrawYOffset = -1000;
				int offset;
				if(effect==2)
					offset = 45;
				if(IsEasyMode()){
					for(int i=0; i<16; ++i){
						for(int j = 0; j<360; j+=90){
							Screen->Circle(4, this->X+8+Rand(-1, 1)+VectorX(12, j+offset), this->Y+8+Rand(-1, 1)+VectorY(12, j+offset), 6, Choose(0x86, 0x87, 0x88), 1, 0, 0, 0, true, 128);
						}
					
						Screen->Circle(4, this->X+8+Rand(-1, 1), this->Y+8+Rand(-1, 1), 12, Choose(0x86, 0x87, 0x88), 1, 0, 0, 0, true, 128);
					
						Waitframe();
					}
				}
				for(int i=0; i<5; ++i){
					for(int j = 0; j<360; j+=90){
						eweapon e = FireEWeapon(EW_SOLAR, this->X, this->Y, DegtoRad(j+offset), 400, ghost->WeaponDamage, SPR_LIGHTSHOT, 32, EWF_UNBLOCKABLE);
						e->Rotation = j+offset;
					}
					for(int j=0; j<4; ++j){
						Screen->Circle(4, this->X+8, this->Y+8, Lerp(12, 4, (i*4+j)/20), Choose(0x86, 0x87, 0x88), 1, 0, 0, 0, true, 128);
						
						Waitframe();
					}
				}
				this->DeadState = 0;
				Quit();
			}
			if(effect==3){
				this->OriginalTile = 66044;
				this->Tile = this->OriginalTile;
				this->NumFrames = 4;
				this->ASpeed = 2;
				Waitframes(Rand(120, 600));
				eweapon e = FireEWeapon(EW_SOLAR, this->X, this->Y,0, 0, ghost->WeaponDamage, 0, SFX_LIGHTSHOT, EWF_UNBLOCKABLE);
				e->CollDetection = false;
				RunEWeaponScript(e, "SolarBigShot", {0, 16, 0.5, 0.2, 0, 32});
				this->DeadState = 0;
				Quit();
			}
			if(effect == 4){
				this->DrawYOffset = -1000;
				int Angle = fireangle;
				if(fireangle == -1)
					Angle = Angle(this->X, this->Y, Link->X, Link->Y);
				if(IsEasyMode()){
					for(int i=0; i<16; ++i){
						Screen->Circle(4, this->X+8+Rand(-1, 1), this->Y+8+Rand(-1, 1), 12, Choose(0x86, 0x87, 0x88), 1, 0, 0, 0, true, 128);
						
						Waitframe();
					}
				}
				for(int i=0; i<5; ++i){
					eweapon e = FireEWeapon(EW_SOLAR, this->X, this->Y, DegtoRad(Angle), 400, ghost->WeaponDamage, SPR_LIGHTSHOT, 32, EWF_UNBLOCKABLE);
					e->Rotation = Angle;
					for(int j=0; j<4; ++j){
						Screen->Circle(4, this->X+8, this->Y+8, Lerp(12, 4, (i*4+j)/20), Choose(0x86, 0x87, 0x88), 1, 0, 0, 0, true, 128);
						
						Waitframe();
					}
				}
				this->DeadState = 0;
				Quit();
			}
		}
	}
}

eweapon script SolarChaser{
	void run(int accel, int topspeed, int time, int topspeedFalloff){
		int x = this->X;
		int y = this->Y;
		int vX = VectorX(topspeed/2, RadtoDeg(this->Angle));
		int vY = VectorY(topspeed/2, RadtoDeg(this->Angle));
		for(int i=0; i<time; ++i){
			vX = LazyChase(vX, this->X, Link->X, accel, topspeed);
			vY = LazyChase(vY, this->Y, Link->Y, accel, topspeed);
			topspeed = Decrement(topspeed, topspeedFalloff);
			x += vX;
			y += vY;
			this->X = x;
			this->Y = y;
			this->DeadState = WDS_ALIVE;
			DarkRoom_AddLight(this->X+8, this->Y+8, 0, 24, 1, 0, 0, 0);
			Waitframe();
		}
		for(int i=0; i<4; ++i){
			eweapon e = FireEWeapon(EW_SOLAR, this->X, this->Y, DegtoRad(-45+90*i), 400, this->Damage, SPR_LIGHTSHOT, 32, 0);
			e->Rotation = -45+90*i;
			RunEWeaponScript(e, "GlowEW", {12});
		}
		this->DeadState = 0;
	}
}

eweapon script StellarAccelerator{
	void run(int delay1, int startingSpeed, int delay2, int endingSpeed){
		for(int i=0; i<delay1; ++i){
			this->DeadState = WDS_ALIVE;
			Waitframe();
		}
		++this->Tile;
		this->Step = startingSpeed;
		for(int i=0; i<delay2; ++i){
			this->DeadState = WDS_ALIVE;
			Waitframe();
		}
		++this->Tile;
		this->Step = endingSpeed;
		while(true){
			this->DeadState = WDS_ALIVE;
			Waitframe();
		}
	}
}

const int SPR_LUNARPHASECUTTER = 98;

eweapon script LunarPhaseCutter{
	void run(int minstep, int maxstep, int sinespeed, int startSineCounter){
		this->Misc[EWM_FLAGS] |= EWMF_NOREFLECT;
		int drawYOff = this->DrawYOffset;
		int sinecounter = startSineCounter;
		while(true){
			sinecounter += sinespeed;
			sinecounter = sinecounter%360;
			int state = sinecounter/360;
			if(state>0.75){
				this->CollDetection = true;
				this->DrawYOffset = drawYOff;
				this->DrawStyle = DS_NORMAL;
			}
			else if(state>0.50||state<=0.25){
				this->CollDetection = false;
				this->DrawYOffset = G[G_ANIM]%4<2?drawYOff:-1000;
				this->DrawStyle = DS_PHANTOM;
			}
			else if(state>0.25){
				this->CollDetection = false;
				this->DrawYOffset = drawYOff;
			}
			this->Step = Lerp(minstep, maxstep, 0.5+0.5*Sin(sinecounter));
			Waitframe();
		}
	}
}

const int TIL_METEORITE = 66048;

const int SFX_METEORITE_FALL = 136;

eweapon script Meteorite{
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
			MakeHitbox(EW_STELLAR, x-scale, y-scale, scale*2, (scale/48)*64, damage);
		impact->Clear(6);
	}
	void run(int drawBeacon, int skipfall, int size, int fallSpeed){
		if(size==0)
			size = 48;
		if(fallSpeed==0)
			fallSpeed = 1;
		if(drawBeacon){
			for(int i=0; i<12; ++i){
				int j = 4*(i/12);
				Screen->Rectangle(4, this->X+8-j, 0, this->X+8+j, this->Y+8, 0x01, 1, 0, 0, 0, true, 128);
				Screen->Circle(4, this->X+8, this->Y+8, j, 0x01, 1, 0, 0, 0, true, 128);
				Waitframe();
			}
			for(int i=4; i>0; --i){
				int j = 4*(i/4);
				Screen->Rectangle(4, this->X+8-j, 0, this->X+8+j, this->Y+8, 0x01, 1, 0, 0, 0, true, 128);
				Screen->Circle(4, this->X+8, this->Y+8, j, 0x01, 1, 0, 0, 0, true, 128);
				Waitframe();
			}
		}
		int bitid = TempBitmap_Create(0, size*2, size*2);
		bitmap impact = TempBMP[bitid];
		if(!skipfall){
			Game->PlaySound(SFX_METEORITE_FALL);
			for(int i=64; i>0; i-=fallSpeed){
				Screen->FastTile(2, this->X, this->Y, 832+Floor(G[G_ANIM]/4)%4, 7, 64);
				Screen->DrawTile(6, this->X+8*i, this->Y-48-16*i, TIL_METEORITE+2*(G[G_ANIM]%4), 2, 4, 9, -1, -1, 0, 0, 0, 0, true, 128);
				Waitframe();
			}
			this->Step = 0;
		}
		Game->PlaySound(SFX_BOMB);
		Screen->Quake = 10;
		for(int i=0; i<16; ++i){
			DrawMeteoriteImpact(impact, this->X+8, this->Y+8, 0x01, 0x96, size*(i/16), true, 0, this->Damage);
			Waitframe();
		}
		for(int i=0; i<16; ++i){
			DrawMeteoriteImpact(impact, this->X+8, this->Y+8, 0x01, 0x01, size, false, (i/16), 0);
			Waitframe();
		}
		TempBitmap_Free(0, bitid);
		this->DeadState = 0;
	}
}

eweapon script LunarShift{
	void run(int angle, int maxstep, int startEndTime, int midTime){
		int particleX[64];
		int particleY[64];
		int particleC[64];
		int particleMult[64];
		int i; int j; int k;
		for(i=0; i<64; ++i){
			particleX[i] = Rand(256);
			particleY[i] = Rand(176);
			particleC[i] = Choose(0x71, 0x72, 0x73, 0x74);
			particleMult[i] = Rand(80, 120)/100;
		}
		int step;
		Game->PlaySound(84);
		for(j=0; j<startEndTime; ++j){
			step = Lerp(0, maxstep, j/startEndTime);
			for(i=0; i<64; ++i){
				k = step*particleMult[i]*4;
				particleX[i] += VectorX(k, angle);
				particleY[i] += VectorY(k, angle);
				if(particleX[i]<-16)
					particleX[i] += 288;
				else if(particleX[i]>272)
					particleX[i] -= 288;
				if(particleY[i]<-16)
					particleY[i] += 208;
				else if(particleY[i]>192)
					particleY[i] -= 208;
				if(k<1){
					Screen->PutPixel(6, particleX[i], particleY[i], particleC[i], 0, 0, 0, 128);
				}
				else{
					Screen->Line(6, particleX[i], particleY[i], particleX[i]+VectorX(k, angle+180), particleY[i]+VectorY(k, angle+180), particleC[i], 1, 0, 0, 0, 128);
				}
			}
			LinkMovement_Push2(VectorX(step, angle), VectorY(step, angle));
			Waitframe();
		}
		for(j=0; j<midTime; ++j){
			step = maxstep;
			for(i=0; i<64; ++i){
				k = step*particleMult[i]*4;
				particleX[i] += VectorX(k, angle);
				particleY[i] += VectorY(k, angle);
				if(particleX[i]<-16)
					particleX[i] += 288;
				else if(particleX[i]>272)
					particleX[i] -= 288;
				if(particleY[i]<-16)
					particleY[i] += 208;
				else if(particleY[i]>192)
					particleY[i] -= 208;
				if(k<1){
					Screen->PutPixel(6, particleX[i], particleY[i], particleC[i], 0, 0, 0, 128);
				}
				else{
					Screen->Line(6, particleX[i], particleY[i], particleX[i]+VectorX(k, angle+180), particleY[i]+VectorY(k, angle+180), particleC[i], 1, 0, 0, 0, 128);
				}
			}
			LinkMovement_Push2(VectorX(step, angle), VectorY(step, angle));
			Waitframe();
		}
		for(j=0; j<startEndTime; ++j){
			step = Lerp(maxstep, 0, j/startEndTime);
			for(i=0; i<64; ++i){
				k = step*particleMult[i]*4;
				particleX[i] += VectorX(k, angle);
				particleY[i] += VectorY(k, angle);
				if(particleX[i]<-16)
					particleX[i] += 288;
				else if(particleX[i]>272)
					particleX[i] -= 288;
				if(particleY[i]<-16)
					particleY[i] += 208;
				else if(particleY[i]>192)
					particleY[i] -= 208;
				if(k<1){
					Screen->PutPixel(6, particleX[i], particleY[i], particleC[i], 0, 0, 0, 128);
				}
				else{
					Screen->Line(6, particleX[i], particleY[i], particleX[i]+VectorX(k, angle+180), particleY[i]+VectorY(k, angle+180), particleC[i], 1, 0, 0, 0, 128);
				}
			}
			LinkMovement_Push2(VectorX(step, angle), VectorY(step, angle));
			Waitframe();
		}
		this->DeadState = 0;
	}
}

eweapon script HomingShot{
	void run(int turnSpeed, int lazyChaseMaxStep, int deathTimer){
		int angle = RadtoDeg(this->Angle);
		int x = this->X;
		int y = this->Y;
		int vX = VectorX(this->Step/100, angle);
		int vY = VectorY(this->Step/100, angle);
		while(true){
			if(deathTimer)
				--deathTimer;
			else
				this->DeadState = 0;
			if(lazyChaseMaxStep){
				this->Step = 0;
				vX = LazyChase(vX, x, Link->X, turnSpeed, lazyChaseMaxStep);
				vY = LazyChase(vY, y, Link->Y, turnSpeed, lazyChaseMaxStep);
				x += vX;
				y += vY;
				this->X = x;
				this->Y = y;
			}
			else{
				angle = TurnToAngle(angle, Angle(this->X, this->Y, Link->X, Link->Y), turnSpeed);
				this->Angle = DegtoRad(angle);
			}
			Waitframe();
		}
	}
}

eweapon script StellarKnockbackBlast{
	void run(int delay, int step){
		Waitframe();
		if(delay){
			Game->PlaySound(SFX_CHARGE1);
			for(int i=0; i<delay&&Distance(this->X, this->Y, Link->X, Link->Y)>20; ++i){
				Screen->Circle(4, this->X+8+Rand(-1, 1), this->Y+8+Rand(-1, 1), Rand(10, 12), Choose(0x96, 0x97, 0x98), 1, 0, 0, 0, true, 128);
				Waitframe();
			}
		}
		this->Extend = 3;
		this->TileWidth = 2;
		this->DrawXOffset = -8;
		this->UseSprite(103);
		this->Step = step;
		eweapon hitbox[2];
		Game->PlaySound(93);
		bool gothit;
		while(this->X>-16&&this->X<256&&this->Y>-16&&this->Y<176&&!gothit){
			for(int i=0; i<2; ++i){
				if(!hitbox[i]->isValid()){
					hitbox[i] = FireEWeapon(EW_STELLAR, this->X+VectorX(-8+16*i, RadtoDeg(this->Angle)), this->Y+VectorY(-8+16*i, RadtoDeg(this->Angle)), this->Angle, 0, this->Damage, 0, 0, EWF_UNBLOCKABLE);
					hitbox[i]->DrawYOffset = -1000;
				}
				hitbox[i]->X = this->X+VectorX(-8+16*i, RadtoDeg(this->Angle));
				hitbox[i]->Y = this->Y+VectorY(-8+16*i, RadtoDeg(this->Angle));
				SetEWeaponLifespan(hitbox[i], EWL_TIMER, 3);
				SetEWeaponDeathEffect(hitbox[i], EWD_VANISH, 0);
				if(LinkCollision(hitbox[i]))
					G[G_DASHINTERRUPT] = 1;
				if(Link->Action==LA_GOTHURTLAND&&LinkCollision(hitbox[i])){
					this->DeadState = WDS_ALIVE;
					this->DrawYOffset = -1000;
					Link->HitDir = -1;
					gothit = true;
				}
			}
			Screen->DrawTile(2, this->X-8, this->Y-2, this->Tile, 2, 1, this->CSet, -1, -1, this->X-8, this->Y-2, RadtoDeg(this->Angle), 0, true, 128);
			Waitframe();
		}
		Game->PlaySound(SFX_BOMB);
		int angle = RadtoDeg(this->Angle);
		this->Step = 0;
		for(int i=0; i<16; ++i){
			LinkMovement_Push2(VectorX(4, angle), VectorY(4, angle));
			DrawStarGlint(4, this->X+8, this->Y+8, Rand(360), i*3, Choose(0x91, 0x96, 0x97, 0x98));
			Waitframe();
		}
		this->DeadState = 0;
	}
}


eweapon script LobBombEW{
	void run(int jump, int rollSpeed){
		this->Jump = jump;
		this->MoveFlags[WPNMV_OBEYS_GRAVITY] = true;
		while(this->Z>0||this->Jump>0){
			if(rollSpeed){
				if(Screen->isSolid(this->X+8, this->Y+8)){
					int vX = VectorX(1, RadtoDeg(this->Angle));
					int vY = -VectorY(1, RadtoDeg(this->Angle));
					if(this->X<240){
						this->Angle = DegtoRad(Angle(0, 0, vX, vY));
						Game->PlaySound(SFX_PLACE);
					}
				}
			}
			Waitframe();
		}
		if(rollSpeed==-1){
			Game->PlaySound(SFX_PLACE);
			Game->PlaySound(91);
			itemsprite itm = CreateItemAt(I_BOMB, this->X, this->Y);
			itm->Pickup = IP_TIMEOUT|IP_ALWAYSGRAB;
			this->DeadState = 0;
		}
		else if(rollSpeed){
			this->Step = rollSpeed;
			while(this->DeadState==WDS_ALIVE){
				if(Screen->isSolid(this->X+8, this->Y+8)){
					int vX = VectorX(1, RadtoDeg(this->Angle));
					int vY = -VectorY(1, RadtoDeg(this->Angle));
					if(this->X<240){
						this->Angle = DegtoRad(Angle(0, 0, vX, vY));
						Game->PlaySound(SFX_PLACE);
					}
				}
				Waitframe();
			}
			if(this->X>0&&this->X<240&&this->Y>0&&this->Y<160){
				Game->PlaySound(SFX_PLACE);
				eweapon boom = FireEWeapon(EW_BOMBBLAST, this->X, this->Y, 0, 0, this->Damage, 0, 0, 0);
				this->DeadState = 0;
			}
		}
		else{
			eweapon boom = FireEWeapon(EW_BOMBBLAST, this->X, this->Y, 0, 0, this->Damage, 0, 0, 0);
			this->DeadState = 0;
		}
	}
}

eweapon script FallingBoulder{
	void run(){
		int r;
		for(int i=0; i<64; ++i){
			this->Jump = 0;
			this->DeadState = WDS_ALIVE;
			r = (1-(this->Z/176))*8+8;
			Screen->Ellipse(2, this->X+16, this->Y+24, r, r*0.5, 0x0F, 1, 0, 0, 0, true, 128);
			Waitframe();
		}
		while(this->Z>0){
			this->Jump = 0;
			this->Z -= 8;
			this->DeadState = WDS_ALIVE;
			r = (1-(this->Z/176))*8+8;
			Screen->Ellipse(2, this->X+16, this->Y+24, r, r*0.5, 0x0F, 1, 0, 0, 0, true, 128);
			Waitframe();
		}
		this->Z = 0;
		this->DrawYOffset = -1000;
		this->DeadState = WDS_ALIVE;
		eweapon split[4];
		int splitAng[4] = {-135, -45, 135, 45};
		for(int i=0; i<4; ++i){
			split[i] = FireEWeapon(EW_PHYSICAL, this->X+(i%2)*16, this->Y+Floor(i/2)*16, DegtoRad(splitAng[i]), 100, this->Damage, 107, SFX_BOMB, EWF_UNBLOCKABLE);
		}
		int jump = 2.4;
		int z = 0;
		while(jump>0||z>0){
			z += jump;
			jump = Clamp(jump-0.16, -3.2, 3.2);
			for(int i=0; i<4; ++i){
				split[i]->DrawYOffset = -2-z;
				split[i]->HitYOffset = -z;
				split[i]->DeadState = WDS_ALIVE;
			}
			Waitframe();
			this->CollDetection = false;
		}
		for(int i=0; i<4; ++i){
			split[i]->DeadState = 0;
		}
		this->DeadState = 0;
	}
}
const int TIL_SLOWHOMINGSICKLE = 70020;

eweapon script SlowHomingSickle{
	void run(int turnSpeed, int turnFrames, int topStep, int delay){
		int step = this->Step;
		this->DrawYOffset = -1000;
		int r;
		int i = 0;
		int t;
		int angle = RadtoDeg(this->Angle);
		if(delay){
			Waitframes(delay);
		}
		this->Step = 0;
		this->CollDetection = false;
		Game->PlaySound(73);
		for(int i=0; i<16; ++i){
			r = WrapDegrees(r+20);
			if(i%4<2)
				Screen->DrawTile(4, this->X-8, this->Y-8, TIL_SLOWHOMINGSICKLE+4, 2, 2, 7, -1, -1, this->X-8, this->Y-8, r, 0, true, 128);
			Waitframe();
		}
		Game->PlaySound(SFX_SPINATTACK);
		this->CollDetection = true;
		this->Step = step;
		while(true){
			this->Step = Lerp(step, topStep, t/turnFrames);
			if(t<turnFrames){
				++t;
				angle = TurnToAngle(angle, Angle(this->X, this->Y, Link->X, Link->Y), turnSpeed);
			}
			this->Dir = AngleDir8(angle);
			this->Angle = DegtoRad(angle);
			r = WrapDegrees(r+20);
			i = (i+1)%4;
			Screen->DrawTile(4, this->X-8, this->Y-8, TIL_SLOWHOMINGSICKLE+2, 2, 2, 7, -1, -1, this->X-8, this->Y-8, r-80+20*i, 0, true, 128);
			Screen->DrawTile(4, this->X-8, this->Y-8, TIL_SLOWHOMINGSICKLE, 2, 2, 7, -1, -1, this->X-8, this->Y-8, r, 0, true, 128);
			Waitframe();
		}
	}
}

eweapon script GrandmaSundog{
	void run(){
		int Dir;
		int timer;
		while(true){
			Dir = AngleDir4(Angle(this->X, this->Y, Link->X, Link->Y));
			if(G[G_ANIM]%4<2){
				Screen->DrawCombo(2, this->X, this->Y-16, 33804 + Dir, 1, 2, 6, -1, -1, 0, 0, 0, 0, 0, true, 128);
			}
			timer++;
			if(timer == 60){
				timer = 0;
				int ang = Angle(this->X, this->Y, Link->X, Link->Y);
				eweapon e = FireEWeapon(EW_SOLAR, this->X, this->Y, DegtoRad(ang), 200, this->Damage, SPR_LIGHTSHOT, 32, EWF_UNBLOCKABLE);
				e->Rotation = ang;
			}
			if(Screen->D[1] == 1)
				break;
			Waitframe();
		}
		eweapon e = FireEWeapon(EW_SOLAR, this->X, this->Y,0, 0, this->Damage, 0, SFX_LIGHTSHOT, EWF_UNBLOCKABLE);
		e->CollDetection = false;
		RunEWeaponScript(e, "SolarBigShot", {0, 16, 0.5, 0.2, 0, 24});
		Quit();
	}
}

eweapon script SporeEW{
	void run(){
		int Z = 0;
		while(Z<48){
			Z += 2;
			this->DrawYOffset = -Z;
			this->HitYOffset = -Z+4;
			this->HitXOffset = 4;
			this->HitWidth = 8;
			this->HitHeight = 8;
			Waitframe();
		}
		int t = Rand(360);
		this->Step = 0;
		int amp;
		int fallSpeed = Rand(40, 50)/100;
		while(Z>0){
			++t;
			Z = Max(Z-fallSpeed, 0);
			if(amp<16)
				++amp;
			this->DrawXOffset = amp*Sin(t*2);
			this->DrawYOffset = -Z;
			this->HitYOffset = -Z+4;
			this->HitXOffset = amp*Sin(t*2)+4;
			this->HitWidth = 8;
			this->HitHeight = 8;
			Waitframe();
		}
		this->DeadState = 0;
	}
}
const int SFX_BLOODMOONCAGE_ACTIVATE = 56;

eweapon script BloodMoonCage{
	//State 0 - Preview 
	//State 1 - Active Flashing
	//State 2 - Active Flickering
	void DrawBloodMoonCage(int state, int layer, int cx, int cy, int rad, int bmc){
		//bmc[0] = Anim timer
		//bmc[1] = Particle count
		//bmc[2] = Base angle
		int bmcX = bmc[3];
		int bmcY = bmc[4];
		int bmcF = bmc[5];
		int bmcT = bmc[6];
		
		++bmc[0];
		bmc[0] %= 360;
		bmc[2] = WrapDegrees(bmc[2]+4);
		
		int angSlice = 360/bmc[1];
		if(state==1&&bmc[0]%4<2||state==3)
			Screen->Circle(layer, cx+7, cy+7, rad, Choose(0x0E, 0x83, 0x84), 1, 0, 0, 0, true, 64);
		
		if(state==4)
			Screen->Circle(layer, cx+7, cy+7, rad, 0x01, 1, 0, 0, 0, true, 128);
		for(int i=0; i<bmc[1]; ++i){
			int x = cx+VectorX(rad, bmc[2]+angSlice*i);
			int y = cy+VectorY(rad, bmc[2]+angSlice*i);
			if(bmcF[i]>-1){
				if(state==0){
					int c = Choose(0x0E, 0x83, 0x84);
					int c2 = Choose(0x0E, 0x83, 0x84);
					Screen->PutPixel(layer, x+bmcX[i]+7, y+bmcY[i]+7, c, 0, 0, 0, 128);
					Screen->PutPixel(layer, x+bmcX[i]+7, y+bmcY[i]+7-1, c2, 0, 0, 0, 128);
					Screen->PutPixel(layer, x+bmcX[i]+7, y+bmcY[i]+7+1, c2, 0, 0, 0, 128);
					Screen->PutPixel(layer, x+bmcX[i]+7-1, y+bmcY[i]+7, c2, 0, 0, 0, 128);
					Screen->PutPixel(layer, x+bmcX[i]+7+1, y+bmcY[i]+7, c2, 0, 0, 0, 128);
				
				}
				else{
					if((bmcF[i]<8||bmcF[i]%4<2)&&bmcF[i]<16)
						Screen->FastTile(layer, x+bmcX[i], y+bmcY[i], bmcT[i]+Floor((bmcF[i]%8)/2), 8, 128);
				}
			}
			++bmcF[i];
			if(bmcF[i]>=8){
				if(state<2||state==3)
					bmcF[i] = 0;
			}
			if(bmcF[i]==0){
				bmcX[i] = Rand(-3, 3);
				bmcY[i] = Rand(-3, 3);
				bmcT[i] = Choose(54600, 54620);
			}
		}
	}
	void run(int tX, int tY, int expandDist, int activateDelay, int activeTime, int fadeOut, int communication){
		int expandTime = 16;
		int shrinkTime = 8;
		if(fadeOut)
			shrinkTime = 0;
		
		int x = this->X;
		int y = this->Y;
		
		this->InitD[6] = 0;
		if(tX>-1000){
			int i = 0;
			while(Distance(x, y, Link->X, Link->Y)>8){
				++i;
				if(i%2==0)
					ParticleAnim(x+Rand(-3, 3), y+Rand(-3, 3), Choose(54600, 54620), 8, 4, 2);
				int ang = Angle(x, y, Link->X, Link->Y);
				x += VectorX(8, ang);
				y += VectorY(8, ang);
				Waitframe();
			}
			x = tX;
			y = tY;
		}
		this->X = x;
		this->Y = y;
		
		int bmcX[256];
		int bmcY[256];
		int bmcF[256];
		int bmcT[256];
		int count = Floor((2*PI*expandDist)/8);
		int bmc[] = {0, count, Rand(360), bmcX, bmcY, bmcF, bmcT};
		for(int i=0; i<count; ++i){
			bmcF[i] = Rand(-8, -1);
		}
		
		for(int i=0; i<expandTime; ++i){
			DrawBloodMoonCage(0, 4, this->X, this->Y, Lerp(0, expandDist, i/expandTime), bmc);
			Waitframe();
		}
		for(int i=0; i<activateDelay; ++i){
			DrawBloodMoonCage(0, 4, this->X, this->Y, expandDist, bmc);
			Waitframe();
		}
		Game->PlaySound(SFX_BLOODMOONCAGE_ACTIVATE);
		bool captured;
		if(Distance(this->X, this->Y, Link->X, Link->Y)<=expandDist-6){
			captured = true;
		}
		this->InitD[6] = 1;
		for(int i=0; i<activeTime&&this->InitD[6]<2; ++i){
			DrawBloodMoonCage(Screen->D[D_ESANSUPERATTACK]?3:1, 4, this->X, this->Y, expandDist, bmc);
			Waitdraw();
			int tX = Link->X;
			int tY = Link->Y;
			int distanceLink = Distance(this->X, this->Y, Link->X, Link->Y);
			int angleLink = Angle(this->X, this->Y, Link->X, Link->Y);
			if(captured){
				if(distanceLink>expandDist-6){
					tX = this->X+VectorX(expandDist-6, angleLink);
					tY = this->Y+VectorY(expandDist-6, angleLink);
				}
			}
			else{
				if(distanceLink<expandDist+6){
					tX = this->X+VectorX(expandDist+6, angleLink);
					tY = this->Y+VectorY(expandDist+6, angleLink);
				}
			}
			if(tX!=Link->X||tY!=Link->Y){
				LinkMovement_Push2(tX-Link->X, tY-Link->Y);
			}
			Waitframe();
			if(Screen->D[D_ESANSUPERATTACK]>1){
				for(i=0; i<8; ++i){
					DrawBloodMoonCage(5, 4, this->X, this->Y, expandDist, bmc);
					Waitframe();
				}
				this->DeadState = 0;
				Quit();
			}
		}
		if(shrinkTime){
			for(int i=0; i<shrinkTime; ++i){
				int tempRad = Lerp(expandDist, 0, i/shrinkTime);
				DrawBloodMoonCage(1, 4, this->X, this->Y, Lerp(expandDist, 0, i/shrinkTime), bmc);
				Waitdraw();
				int tX = Link->X;
				int tY = Link->Y;
				int distanceLink = Distance(this->X, this->Y, Link->X, Link->Y);
				int angleLink = Angle(this->X, this->Y, Link->X, Link->Y);
				if(captured){
					if(distanceLink>tempRad-6&&tempRad>6){
						tX = this->X+VectorX(tempRad-6, angleLink);
						tY = this->Y+VectorY(tempRad-6, angleLink);
					}
				}
				else{
					if(distanceLink<tempRad+6){
						tX = this->X+VectorX(tempRad+6, angleLink);
						tY = this->Y+VectorY(tempRad+6, angleLink);
					}
				}
				if(tX!=Link->X||tY!=Link->Y){
					LinkMovement_Push2(tX-Link->X, tY-Link->Y);
				}
				Waitframe();
			}
			for(int i=0; i<8; ++i){
				DrawBloodMoonCage(2, 4, this->X, this->Y, 0, bmc);
				Waitframe();
			}
		}
		else{
			for(int i=0; i<8; ++i){
				DrawBloodMoonCage(2, 4, this->X, this->Y, expandDist, bmc);
				Waitframe();
			}
		}
		this->DeadState = 0;
	}
}

eweapon script MagneticEnemyComponent{
	void run(int polarity, int step, int counter){
		int x = this->X;
		int y = this->Y;
		this->CollDetection = false;
		this->DrawYOffset = 0;
		while(counter>0){
			if(RectCollision(x+4, y+4, x+11, y+11, Link->X, Link->Y, Link->X+15, Link->Y+15)){
				if(Game->Counter[CR_CULTISTQUEST]==1){
					if(this->Tile>=TIL_COMPONENT_SUNMASK&&this->Tile<=TIL_COMPONENT_SUNMASK+3){
						if(!G[G_STOLESOLARMASK]){
							Game->PlaySound(25);
							G[G_STOLESOLARMASK] = 1;
							if(G[G_STOLESOLARMASK]&&G[G_STOLELUNARMASK]&&G[G_STOLESTELLARMASK])
								Game->Counter[CR_CULTISTQUEST] = Max(2, Game->Counter[CR_CULTISTQUEST]);
							eweapon e = CreateEWeaponAt(EW_SCRIPT10, 120, 80);
							e->CollDetection = false;
							e->DrawYOffset = -1000;
							RunEWeaponScript(e, "ItemPopupManualName", {1, 50, TIL_COMPONENT_SUNMASK+DIR_DOWN, 8});
							this->DeadState = 0;
							Quit();
						}
					}
					else if(this->Tile>=TIL_COMPONENT_MOONMASK&&this->Tile<=TIL_COMPONENT_MOONMASK+3){
						if(!G[G_STOLELUNARMASK]){
							Game->PlaySound(25);
							G[G_STOLELUNARMASK] = 1;
							if(G[G_STOLESOLARMASK]&&G[G_STOLELUNARMASK]&&G[G_STOLESTELLARMASK])
								Game->Counter[CR_CULTISTQUEST] = Max(2, Game->Counter[CR_CULTISTQUEST]);
							eweapon e = CreateEWeaponAt(EW_SCRIPT10, 120, 80);
							e->CollDetection = false;
							e->DrawYOffset = -1000;
							RunEWeaponScript(e, "ItemPopupManualName", {1, 51, TIL_COMPONENT_MOONMASK+DIR_DOWN, 8});
							this->DeadState = 0;
							Quit();
						}
					}
					else if(this->Tile>=TIL_COMPONENT_STARMASK&&this->Tile<=TIL_COMPONENT_STARMASK+3){
						if(!G[G_STOLESTELLARMASK]){
							Game->PlaySound(25);
							G[G_STOLESTELLARMASK] = 1;
							if(G[G_STOLESOLARMASK]&&G[G_STOLELUNARMASK]&&G[G_STOLESTELLARMASK])
								Game->Counter[CR_CULTISTQUEST] = Max(2, Game->Counter[CR_CULTISTQUEST]);
							eweapon e = CreateEWeaponAt(EW_SCRIPT10, 120, 80);
							e->CollDetection = false;
							e->DrawYOffset = -1000;
							RunEWeaponScript(e, "ItemPopupManualName", {1, 52, TIL_COMPONENT_STARMASK+DIR_DOWN, 8});
							this->DeadState = 0;
							Quit();
						}
					}
				}
			}
			--counter;
			this->Step = 0;
			if(GLW[GL_MAGNETHITBOX]->isValid()){
				if(Collision(GLW[GL_MAGNETHITBOX], this)){
					if(GLW[GL_MAGNETHITBOX]->Damage==STATE_TIDALGAUNTLET_SUN){
						if(polarity==STATE_TIDALGAUNTLET_SUN){
							x += DirX(GLW[GL_MAGNETHITBOX]->Dir, step*MagnetModifier());
							y += DirY(GLW[GL_MAGNETHITBOX]->Dir, step*MagnetModifier());
						}
						else{
							x -= DirX(GLW[GL_MAGNETHITBOX]->Dir, step*MagnetModifier());
							y -= DirY(GLW[GL_MAGNETHITBOX]->Dir, step*MagnetModifier());
						}
					}
					if(GLW[GL_MAGNETHITBOX]->Damage==STATE_TIDALGAUNTLET_MOON){
						if(polarity==STATE_TIDALGAUNTLET_MOON){
							x += DirX(GLW[GL_MAGNETHITBOX]->Dir, step*MagnetModifier());
							y += DirY(GLW[GL_MAGNETHITBOX]->Dir, step*MagnetModifier());
						}
						else{
							x -= DirX(GLW[GL_MAGNETHITBOX]->Dir, step*MagnetModifier());
							y -= DirY(GLW[GL_MAGNETHITBOX]->Dir, step*MagnetModifier());
						}
					}
				}
			}
			
			if(counter<16){
				if(counter%4<2)
					this->DrawYOffset = 0;
				else
					this->DrawYOffset = -1000;
			}
			this->X = x;
			this->Y = y;
			Waitframe();
		}
		this->DeadState = 0;
	}
}

const int SFX_SWAPCHAR = 60;

eweapon script CharacterChange{
	void run(int whichChar, int deathswap){
		if(deathswap){
			genericdata gd = Game->LoadGenericData(Game->GetGenericScript("CharDeathFreeze"));
			gd->RunFrozen();
		}
		this->Step = 0;
		for(int i=0; i<8; ++i){
			if(deathswap){
				G[G_DEATHIFRAMES] = 2;
				G[G_DRAWNHPZERO] = 2;
			}
			if(deathswap&&i%4<2){
				if(i%4==0)
					Screen->Rectangle(7, 0, 0, 255, 175, 0x50, 1, 0, 0, 0, true, 64);
				Screen->Rectangle(7, 0, 0, 255, 175, 0x50, 1, 0, 0, 0, true, 64);
			}
			if(i%2==0){
				switch(Link->Dir){
					case DIR_UP:
						Link->Dir = DIR_RIGHT;
						break;
					case DIR_DOWN:
						Link->Dir = DIR_LEFT;
						break;
					case DIR_LEFT:
						Link->Dir = DIR_UP;
						break;
					case DIR_RIGHT:
						Link->Dir = DIR_DOWN;
						break;
				}
			}
			TurnOffLinkCollision(1);
			if(deathswap)
				Link->HP = Max(Link->HP, 1);
			WaitNoAction();
		}
		Game->PlaySound(SFX_SWAPCHAR);
		if(deathswap&&G[G_FIRSTTODIE]==0)
			G[G_FIRSTTODIE] = GetCharID()+1;
		SetCharacter(whichChar, deathswap);
		for(int i=0; i<8; ++i){
			if(deathswap){
				G[G_DEATHIFRAMES] = 2;
				G[G_DRAWNHPZERO] = 2;
			}
			if(deathswap&&i%4<2){
				if(i%4==0)
					Screen->Rectangle(7, 0, 0, 255, 175, 0x83, 1, 0, 0, 0, true, 64);
				Screen->Rectangle(7, 0, 0, 255, 175, 0x83, 1, 0, 0, 0, true, 64);
			}
			if(i%2==0){
				switch(Link->Dir){
					case DIR_UP:
						Link->Dir = DIR_RIGHT;
						break;
					case DIR_DOWN:
						Link->Dir = DIR_LEFT;
						break;
					case DIR_LEFT:
						Link->Dir = DIR_UP;
						break;
					case DIR_RIGHT:
						Link->Dir = DIR_DOWN;
						break;
				}
			}
			TurnOffLinkCollision(1);
			WaitNoAction();
		}
		if(deathswap){
			G[G_DEATHIFRAMES] = 32;
		}
		this->DeadState = 0;
	}
}

generic script CharDeathFreeze{
	bool OneHigh(){
		switch(Link->Action){
			case LA_DIVING:
				return true;
		}
		return false;
	}
	void run(){
		bitmap b = Game->CreateBitmap(16, 32);
		b->Own();
		b->Clear(0);
		
		int tileOff = -20;
		int tileH = 2;
		int tileYOff = 0;
		if(OneHigh()){
			tileOff = 0;
			tileH = 1;
			tileYOff = 16;
		}
		
		if(Link->ScriptTile>0)
			b->DrawTile(0, 0, tileYOff, Link->ScriptTile+tileOff, 1, tileH, 6, -1, -1, 0, 0, 0, 0, true, 128);
		else
			b->DrawTile(0, 0, tileYOff, Link->Tile+tileOff, 1, tileH, 6, -1, -1, 0, 0, 0, 0, true, 128);
		b->ReplaceColors(0, 0x0F, 0x01, 0xBF);
		int xOff;
		int yOff;
		if(G[G_HORIZONINCINERATEFLAG]){
			G[G_HORIZONINCINERATEFLAG] = 0;
			Game->PlaySound(SFX_OUCH);
			Game->PlaySound(SFX_EDEAD);
			Game->PlaySound(167);
			Game->PlaySound(109);
			for(int i=0; i<64; ++i){
				Screen->Rectangle(6, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 128);
				
				b->Dither(0, b, 0x00, DITH_STATIC, Lerp(0, 255, i/47));
				int k = 0;
				if(i>8)
					k += (i-8)*0.5;
				if(i>16)
					k += (i-16)*0.5;
				if(i>32)
					k += (i-32)*0.5;
				if(i<48){
					for(int j=0; j<4; ++j)
						b->Blit(6, RT_SCREEN, 0, 0, 16, 32, Link->X+VectorX(k, 90+Lerp(-45, 45, j/3)), Link->Y-16+VectorY(k, 90+Lerp(-45, 45, j/3)), 16, 32, 0, 0, 0, (i<40)?BITDX_NORMAL:BITDX_TRANS, 0, true);
				}
				
				Waitframe();
			}
		}
		else{
			Game->PlaySound(SFX_OUCH);
			Game->PlaySound(SFX_EDEAD);
			Game->PlaySound(167);
			for(int i=0; i<24; ++i){
				if(i<4||i>=20)
					Screen->Rectangle(6, 0, 0, 255, 175, 0x50, 1, 0, 0, 0, true, 64);
				else{
					Screen->Rectangle(6, 0, 0, 255, 175, 0x50, 1, 0, 0, 0, true, 64);
					Screen->Rectangle(6, 0, 0, 255, 175, 0x50, 1, 0, 0, 0, true, 64);
				}
				// if(i>=16&&i<32)
					// Screen->Rectangle(6, 0, 0, 255, 175, 0x50, 1, 0, 0, 0, true, 128);
				
				if(i%4==0){
					xOff = Rand(-4, 4);
					yOff = Rand(-4, 4);
				}
				if(i%16<8){
					if(i%8<4)
						Screen->DrawTile(6, Link->X-16+xOff, Link->Y-20+yOff, 104317, 3, 3, 0, -1, -1, 0, 0, 0, 0, true, 128);
					b->Blit(6, RT_SCREEN, 0, 0, 16, 32, Link->X, Link->Y-16, 16, 32, 0, 0, 0, BITDX_NORMAL, 0, true);
				}
				else{
					b->Blit(6, RT_SCREEN, 0, 0, 16, 32, Link->X, Link->Y-16, 16, 32, 0, 0, 0, BITDX_NORMAL, 0, true);
					if(i%8<4)
						Screen->DrawTile(6, Link->X-16+xOff, Link->Y-20+yOff, 104317, 3, 3, 0, -1, -1, 0, 0, 0, 0, true, 128);
				}
				Waitframe();
			}
		}
	}
}

const int TIL_ITEMPOPUP_BOX = 65980;

eweapon script ItemPopup{
	void DrawBox(int x, int y, int tile, int cset, char32 namebuf, int namesize){
		Screen->FastTile(7, x, y+8, TIL_ITEMPOPUP_BOX+24, 11, 128);
		Screen->DrawTile(7, x-(namesize+8), y+8, TIL_ITEMPOPUP_BOX+23, 1, 1, 11, namesize+8, 16, 0, 0, 0, 0, true, 128);
		Screen->DrawTile(7, x-(namesize+8)-38, y-8, TIL_ITEMPOPUP_BOX, 3, 3, 11, -1, -1, 0, 0, 0, 0, true, 128);
		Screen->FastTile(7, x-(namesize+8)-38+16, y+8, tile, cset, 128);
		Screen->DrawString(7, x-4, y+12, FONT_Z3SMALL, 0x01, -1, TF_RIGHT, namebuf, 128, SHD_OUTLINED8, 0x0F);
		
	}
	void run(int itemID, int multiworldID){
		char32 namebuf[512];
		int tile;
		int cset;
		int y = 0;
		y += G[G_ITEMPOPUPS]*24;
		if(itemID>=1000){
			int bestiaryID = BestiaryListNum(itemID-1000);
			int buf[256];
			BestiaryName(buf, itemID-1000, false, false);
			if(multiworldID){
				int username[64];
				ZLink::GetUsername(username, multiworldID);
				sprintf(namebuf, "%s found %s", username, buf);
			}
			else
				sprintf(namebuf, "Bestiary %d: %s", bestiaryID+1, buf);
			tile = 64277;
			cset = 8;
		}
		else if(itemID>0){
			if(G[G_RANDOMIZERENABLED]){
				bool success;
				if(multiworldID){
					int buf[256];
					success = ItemName(buf, itemID);
					int username[64];
					ZLink::GetUsername(username, multiworldID);
					if(success)
						sprintf(namebuf, "%s found %s", username, buf);
					else
						sprintf(namebuf, "%s screwed it all up!", username); // I dunno under what circumstances this would play but if it does it'll be funny
				}
				else
					success = ItemName(namebuf, itemID);
				itemdata id = Game->LoadItemData(itemID);
				tile = id->Tile;
				cset = id->CSet;
				if(id->TileHeight==2)
					tile += 20;
				switch(itemID){
					case 255:
						tile = 65759;
						genericdata gd = Game->LoadGenericData(Game->GetGenericScript("MooshBug"));
						gd->Running = true;
						break;
					case I_ASHER: tile = 104240; break;
					case I_TORRIN: tile = 104241; break;
					case I_KAYLANI: tile = 104242; break;
					case I_SOREN: tile = 104243; break;
					case I_TERRY: tile = 104244; break;
					case I_SIYED: tile = 104245; break;
					case I_ABILITY_B_TORRIN: tile = 64616; break;
					case I_ABILITY_B_TERRY: tile = 64617; break;
					case I_ABILITY_C_TERRY: tile = 67309; break;
				}
					
				if(!success){
					this->DeadState = 0;
					Quit();
				}
			}
			else{
				itemdata id = Game->LoadItemData(itemID);
				id->GetName(namebuf);
				tile = id->Tile;
				cset = id->CSet;
				if(itemID==223)
					tile = 71580;
			}
		}
		else if(itemID==-1){
			if(G[G_NEWLORE]){
				this->DeadState = 0;
				Quit();
			}
			CopyStringToBuffer(namebuf, "New Enemy");
			tile = 63565;
			cset = 8;
		}
		else if(itemID==-2){
			if(G[G_NEWLORE]){
				this->DeadState = 0;
				Quit();
			}
			CopyStringToBuffer(namebuf, "New Area");
			tile = 63565;
			cset = 8;
		}
		else if(itemID==-3){
			if(G[G_NEWLORE]){
				this->DeadState = 0;
				Quit();
			}
			CopyStringToBuffer(namebuf, "New Quest");
			tile = 63565;
			cset = 8;
		}
		else if(itemID==-4){
			if(G[G_NEWLORE]){
				this->DeadState = 0;
				Quit();
			}
			CopyStringToBuffer(namebuf, "Area Investigated");
			tile = 63565;
			cset = 8;
		}
		int namesize = Text->StringWidth(namebuf, FONT_Z3SMALL);
		for(int i=256+namesize+48; i>248; i-=4){
			if(itemID==-1||itemID==-2||itemID==-3){
				G[G_NEWLORE] = 1;
			}
			DrawBox(i, y, tile, cset, namebuf, namesize);
			++G[G_ITEMPOPUPS];
			Waitframe();
		}
		for(int i=0; i<120; ++i){
			if(itemID==-1||itemID==-2||itemID==-3){
				G[G_NEWLORE] = 1;
			}
			DrawBox(248, y, tile, cset, namebuf, namesize);
			++G[G_ITEMPOPUPS];
			Waitframe();
		}
		for(int i=248; i<256+namesize+48; i+=2){
			if(itemID==-1||itemID==-2||itemID==-3){
				G[G_NEWLORE] = 1;
			}
			DrawBox(i, y, tile, cset, namebuf, namesize);
			++G[G_ITEMPOPUPS];
			Waitframe();
		}
		this->DeadState = 0;
	}
}

eweapon script ItemPopupManualName{
	void DrawBox(int x, int y, int tile, int cset, char32 namebuf, int namesize){
		Screen->FastTile(7, x, y+8, TIL_ITEMPOPUP_BOX+24, 11, 128);
		Screen->DrawTile(7, x-(namesize+8), y+8, TIL_ITEMPOPUP_BOX+23, 1, 1, 11, namesize+8, 16, 0, 0, 0, 0, true, 128);
		Screen->DrawTile(7, x-(namesize+8)-38, y-8, TIL_ITEMPOPUP_BOX, 3, 3, 11, -1, -1, 0, 0, 0, 0, true, 128);
		Screen->FastTile(7, x-(namesize+8)-38+16, y+8, tile, cset, 128);
		Screen->DrawString(7, x-4, y+12, FONT_Z3SMALL, 0x01, -1, TF_RIGHT, namebuf, 128, SHD_OUTLINED8, 0x0F);
		
	}
	void run(int itemID, int StringID, int forceTile, int forceCSet, int forceYPos){
		char32 namebuf[512];
		itemdata id = Game->LoadItemData(itemID);
		GetMessage(StringID, namebuf);
		int tile = id->Tile;
		int cset = id->CSet;
		int y = 0;
		y += G[G_ITEMPOPUPS]*24;
		if(forceYPos > 0)
			y = forceYPos;
		if(forceTile>0&&forceCSet>0){
			tile = forceTile;
			cset = forceCSet;
		}
		int namesize = Text->StringWidth(namebuf, FONT_Z3SMALL);
		for(int i=256+namesize+48; i>248; i-=4){
			DrawBox(i, y, tile, cset, namebuf, namesize);
			++G[G_ITEMPOPUPS];
			Waitframe();
		}
		for(int i=0; i<120; ++i){
			DrawBox(248, y, tile, cset, namebuf, namesize);
			++G[G_ITEMPOPUPS];
			Waitframe();
		}
		for(int i=248; i<256+namesize+48; i+=2){
			DrawBox(i, y, tile, cset, namebuf, namesize);
			++G[G_ITEMPOPUPS];
			Waitframe();
		}
		this->DeadState = 0;
	}
}

eweapon script RingParticle{
	void run(int layer, int c, int r1, int r2, int maxscale, int numrings){
		numrings = Max(numrings, 1);
		for(int i=0; i<maxscale; ++i){
			int x = this->X+this->HitXOffset+8;
			int y = this->Y+this->HitYOffset+8;
			for(int j=0; j<numrings; ++j){
				Screen->Ellipse(layer, x, y, r1*(i/maxscale)+j, r2*(i/maxscale)+j, c, 1, x, y, RadtoDeg(this->Angle), false, 128);
			}
			Waitframe();
		}
		this->DeadState = 0;
	}
}

const int DAMAGE_METEORFIRE = 600;

eweapon script MeteorBurning{
	void run(){
		mapdata l1 = Game->LoadTempScreen(1);
		while(G[G_METEOREFFECTSFRAMES]>96){
			if(G[G_ANIM]%16==0){
				int torchPos = -1;
				int pos = Rand(176);
				for(int i=0; i<176; ++i){
					pos = (pos+1)%176;
					
					if(ComboFI(pos, CF_CANDLE1)){
						torchPos = pos;
						break;
					}
					if(l1->ComboD[pos]==40731){ //Kawi Torches
						torchPos = pos;
						break;
					}
				}
				
				lweapon l = FireLWeapon(LW_SCRIPTFIRE, torchPos==-1?Rand(240):ComboX(torchPos), torchPos==-1?Rand(160):ComboY(torchPos), 0, 0, DAMAGE_METEORFIRE, 35, 0);
				l->DrawYOffset = -1000;
				l->CollDetection = false;
				l->Dir = -1;
				l->Weapon = LW_FIRE;
				RunLWeaponScript(l, "MeteorFire", 0);
			}
			
			Screen->Wavy = Max(Screen->Wavy, 4);
			
			Waitframe();
		}
	}
}
const int GP_ARROW = 0;
const int GP_PIXELDRAIN = 1;
const int GP_FLASH = 2;
const int GP_STEAM = 3;
const int GP_MASKSHARDS = 4;
const int GP_GEODEBURST = 5;

eweapon script GenParticle{
	int SpecialColor(int oc, int c, bool firstFrame){
		switch(oc){
			case -1:
				if(firstFrame)
					return Choose(0x86, 0x87, 0x88);
					break;
			case -2:
				return Choose(0x71, 0x72, 0x73);
				break;
		}
		return c;
	}
	void run(int effect, int a1, int a2, int a3, int a4, int a5, int a6, int a7){
		switch(effect){
			case GP_ARROW:
				runArrowParticle(this, a1, a2, a3, a4, a5, a6, a7);
				break;
			case GP_PIXELDRAIN:
				runPixelDrain(this, a1, a2, a3, a4, a5, a6);
				break;
			case GP_FLASH:
				runFlash(this, a1);
				break;
			case GP_STEAM:
				runSteam(this, a1);
				break;
			case GP_MASKSHARDS:
				runNSMask(this);
				break;
			case GP_GEODEBURST:
				runGeodeBurst(this, a1, a2);
				break;
		}
	}
	void runArrowParticle(eweapon this, int layer, int c, int angle, int step, int maxW, int wGrow, int len){
		bool explode;
		if(c==-2)
			explode = true;
		int oc = c;
		int size1;
		int size2;
		int x1 = this->X+8;
		int y1 = this->Y+8;
		int x2 = x1+VectorX(len, angle);
		int y2 = y1+VectorY(len, angle);
		c = SpecialColor(oc, c, true);
		while(size2<maxW){
			x1 += VectorX(step, angle);
			y1 += VectorY(step, angle);
			x2 += VectorX(step, angle);
			y2 += VectorY(step, angle);
			size2 = Min(size2+wGrow, maxW);
			c = SpecialColor(oc, c, false);
			QuadRay(layer, x1, y1, size1, angle, x2, y2, size2, angle, c);
			Waitframe();
		}
		while(size1<maxW){
			x1 += VectorX(step, angle);
			y1 += VectorY(step, angle);
			x2 += VectorX(step, angle);
			y2 += VectorY(step, angle);
			size1 = Min(size1+wGrow, maxW);
			size2 = Max(size2-wGrow, 0);
			c = SpecialColor(oc, c, false);
			QuadRay(layer, x1, y1, size1, angle, x2, y2, size2, angle, c);
			Waitframe();
		}
		while(size1>0){
			x1 += VectorX(step, angle);
			y1 += VectorY(step, angle);
			x2 += VectorX(step, angle);
			y2 += VectorY(step, angle);
			size1 = Max(size1-wGrow, 0);
			size2 = Max(size2-wGrow, 0);
			c = SpecialColor(oc, c, false);
			QuadRay(layer, x1, y1, size1, angle, x2, y2, size2, angle, c);
			Waitframe();
		}
		if(explode){
			for(int i=0; i<8; ++i){
				c = SpecialColor(oc, c, false);
				Screen->Circle(layer, x2, y2, Lerp(0, maxW*2, i/8), c, 1, 0, 0, 0, true, 128);
				Waitframe();
			}
			for(int i=0; i<4; ++i){
				c = SpecialColor(oc, c, false);
				Screen->Circle(layer, x2, y2, Lerp(0, maxW*2, 1-i/4), c, 1, 0, 0, 0, true, 128);
				Waitframe();
			}
		}
		this->DeadState = 0;
	}
	void runPixelDrain(eweapon this, int x1, int y1, int x3, int y3, int fan, int frames){
		int pX[64];
		int pY[64];
		int pAng[64];
		int pDist[64];
		int pStep[64];
		int pStep2[64];
		int pC[64];
		int xy[2];
		for(int i=0; i<64; ++i){
			pX[i] = -1000;
		}
		int count = 64;
		for(int j=0; j<frames-40; ++j){
			bool spawned;
			Screen->Rectangle(3, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
			for(int i=0; i<64; ++i){
				int x2 = pX[i]+VectorX(pDist[i], pAng[i]);
				int y2 = pY[i]+VectorY(pDist[i], pAng[i]);
				pStep2[i] = Clamp(pStep2[i]+pStep[i], 0, 1);
				BezierQuadFrame(xy, pStep2[i], 1, pX[i], pY[i], x2, y2, x3, y3);
				Screen->PutPixel(4, xy[0], xy[1], 0x01, 0, 0, 0, 128);
				if(pStep2[i]>=1||(pX[i]==-1000&&!spawned)){
					spawned = true;
					pX[i] = x1+Rand(16);
					pY[i] = y1+Rand(16);
					pAng[i] = -90+Rand(-fan/2, fan/2);
					pDist[i] = Rand(80, 128);
					pStep[i] = Rand(2, 5)/100;
					pStep2[i] = 0;
					pC[i] = Choose(0xB1, 0xB2, 0xB3);
				}
			}
			Waitframe();
		}
		while(count>0){
			Screen->Rectangle(3, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
			count = 0;
			for(int i=0; i<64; ++i){
				if(pX[i]>-1000){
					++count;
					int x2 = pX[i]+VectorX(pDist[i], pAng[i]);
					int y2 = pY[i]+VectorY(pDist[i], pAng[i]);
					pStep2[i] = Clamp(pStep2[i]+pStep[i], 0, 1);
					BezierQuadFrame(xy, pStep2[i], 1, pX[i], pY[i], x2, y2, x3, y3);
					Screen->PutPixel(4, xy[0], xy[1], 0x01, 0, 0, 0, 128);
					if(pStep2[i]>=1){
						pX[i] = -1000;
					}
				}
			}
			Waitframe();
		}
		this->DeadState = 0;
	}
	void runFlash(eweapon this, int duration){
		int bitid = TempBitmap_Create(0, 256, 176);
		bitmap b = TempBMP[bitid];
		int clr;
		Game->PlaySound(75);
		for(int i=8; i<128; i+=8){
			clr = Choose(0x81, 0x86, 0x87);
			Screen->Circle(6, this->X+8, this->Y+8, i, clr, 1, 0, 0, 0, true, 128);
			for(int j=0; j<6; ++j){
				int vert[6];
				vert[0] = this->X+8+VectorX(i-8, j*60-30);
				vert[1] = this->Y+8+VectorY(i-8, j*60-30);
				vert[2] = this->X+8+VectorX(i-8+i*0.6666, j*60);
				vert[3] = this->Y+8+VectorY(i-8+i*0.6666, j*60);
				vert[4] = this->X+8+VectorX(i-8, j*60+30);
				vert[5] = this->Y+8+VectorY(i-8, j*60+30);
				Screen->Triangle(6, vert[0], vert[1], vert[2], vert[3], vert[4], vert[5], 1, 1, clr, 0, -1, PT_FLAT);
			}
			Waitframe();
		}
		for(int i=0; i<duration||duration==-1; ++i){
			if(duration==-1)
				duration = this->InitD[1];
			clr = Choose(0x81, 0x86, 0x87);
			if(duration==-1)
				clr = 0x81;
			Screen->Rectangle(6, 0, 0, 255, 175, clr, 1, 0, 0, 0, true, 128);
			Waitframe();
		}
		for(int i=8; i<128; i+=8){
			clr = Choose(0x81, 0x86, 0x87);
			b->ClearToColor(0, clr);
			clr = Choose(0x81, 0x86, 0x87);
			b->Circle(0, this->X+8, this->Y+8, i, 0x00, 1, 0, 0, 0, true, 128);
			for(int j=0; j<6; ++j){
				int vert[6];
				vert[0] = this->X+8+VectorX(i-8, j*60-30);
				vert[1] = this->Y+8+VectorY(i-8, j*60-30);
				vert[2] = this->X+8+VectorX(i-8+i*0.6666, j*60);
				vert[3] = this->Y+8+VectorY(i-8+i*0.6666, j*60);
				vert[4] = this->X+8+VectorX(i-8, j*60+30);
				vert[5] = this->Y+8+VectorY(i-8, j*60+30);
				b->Triangle(0, vert[0], vert[1], vert[2], vert[3], vert[4], vert[5], 1, 1, 0x00, 0, -1, PT_FLAT, NULL);
			}
			b->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
			Waitframe();
		}
		TempBitmap_Free(0, bitid);
		this->DeadState = 0;
	}
	void runSteam(eweapon this, int duration){
		int ang = Rand(360);
		for(int i=0; i<duration; ++i){
			int x = this->X+Lerp(0, 7, i/duration);
			int y = this->Y-i+Lerp(0, 7, i/duration);
			Screen->DrawTile(4, x, y, 69219, 1, 1, 11, Lerp(16, 2, i/duration), Lerp(16, 2, i/duration), x, y, ang, 0, true, 64);
			Waitframe();
		}
		this->DeadState = 0;
	}
	void runNSMask(eweapon this){
		int sX[16];
		int sY[16];
		int sA[16];
		int sR[16];
		int sRt[16];
		int sSt[16];
		int sT[16];
		int sTl[16];
		
		for(int i=0; i<16; ++i){
			sX[i] = this->X-4+Lerp(0, 24, (i%4)/3)+Rand(-2, 2);
			sY[i] = this->Y-4+Lerp(0, 24, Floor(i/4)/3)+Rand(-2, 2);
			sA[i] = Angle(this->X+8, this->Y+8, sX[i], sY[i]);
			sR[i] = Rand(360);
			sRt[i] = Rand(5, 10)*Choose(-1, 1);
			sSt[i] = Rand(20, 30)/10;
			sT[i] = Rand(24, 32);
			sTl[i] = Rand(6);
		}
		
		int count = 16;
		while(count>0){
			count = 0;
			for(int i=0; i<16; ++i){
				if(sT[i]>0){
					++count;
					sX[i] += VectorX(sSt[i], sA[i]);
					sY[i] += VectorY(sSt[i], sA[i]);
					sR[i] = WrapDegrees(sR[i]+sRt[i]);
					--sT[i];
					if(sT[i]>8||sT[i]%4<2)
						Screen->FastTile(4, sX[i]-8, sY[i]-8, 1468+sTl[i], 11, 128);
				}
			}
			Waitframe();
		}
	}
	void runGeodeBurst(eweapon this, int element, int anim){
		int particleX[16];
		int particleY[16];
		int particleTX[16];
		int particleTY[16];
		int particleCMB[16];
		for(int i=0; i<16; ++i){
			if(anim==0||anim==2){ // Absorb/fizzle
				particleX[i] = 0;
				particleY[i] = 0;
				int ang = Rand(360);
				int dist = Rand(8, 40);
				particleTX[i] = VectorX(dist, ang);
				particleTY[i] = VectorY(dist, ang);
			}
			else if(anim==1){ // Respawn
				int ang = Rand(360);
				int dist = Rand(8, 40);
				particleX[i] = VectorX(dist, ang);
				particleY[i] = VectorY(dist, ang);
				particleTX[i] = 0;
				particleTY[i] = 0;
			}
			switch(element){
				case 1:
					particleCMB[i] = 38544;
					break;
				case 2:
					particleCMB[i] = 38545;
					break;
				case 3:
					particleCMB[i] = 38546;
					break;
				case 4:
					particleCMB[i] = Choose(38544, 38545);
					break;
				case 5:
					particleCMB[i] = Choose(38545, 38546);
					break;
				case 6:
					particleCMB[i] = Choose(38546, 38544);
					break;
			}
		}
		if(anim==0){ // Absorb
			Game->PlaySound(94);
			for(int i=0; i<16; ++i){
				for(int j=0; j<16; ++j){
					int x = Lerp(this->X+particleX[j], (this->X+Link->X)/2+particleTX[j], i/16);
					int y = Lerp(this->Y+particleY[j], (this->Y+Link->Y)/2+particleTY[j], i/16);
					Screen->FastCombo(6, x, y, particleCMB[j], 0, 128);
				}
				Waitframe();
			}
			for(int i=0; i<16; ++i){
				for(int j=0; j<16; ++j){
					int x = Lerp((this->X+Link->X)/2+particleTX[j], Link->X, i/16);
					int y = Lerp((this->Y+Link->Y)/2+particleTY[j], Link->Y, i/16);
					Screen->FastCombo(6, x, y, particleCMB[j], 0, 128);
				}
				Waitframe();
			}
		}
		else if(anim==1){ // Respawn
			Game->PlaySound(80);
			for(int i=0; i<16; ++i){
				for(int j=0; j<16; ++j){
					int x = Lerp(this->X+particleX[j], this->X+particleTX[j], i/16);
					int y = Lerp(this->Y+particleY[j], this->Y+particleTY[j], i/16);
					Screen->FastCombo(6, x, y, particleCMB[j], 0, 128);
				}
				Waitframe();
			}
		}
		else if(anim==2){ // Fizzle
			Game->PlaySound(124);
			for(int i=0; i<16; ++i){
				for(int j=0; j<16; ++j){
					int x = Lerp(this->X+particleX[j], this->X+particleTX[j], i/16);
					int y = Lerp(this->Y+particleY[j], this->Y+particleTY[j], i/16);
					Screen->FastCombo(6, x, y, particleCMB[j], 0, 128);
				}
				Waitframe();
			}
		}
		this->DeadState = 0;
	}
}

const int EWS_KNOCKBACKSHOT = 14;

eweapon script KnockbackShot{
	void run(int pushframes){
		int solidImmune = 16/(this->Step/100);
		while(true){
			if(solidImmune)
				--solidImmune;
			else if(Screen->isSolid(this->X+8, this->Y+8)){
				this->DeadState = 0;
				Quit();
			}
			int i = Link->HitBy[1];
			eweapon hitlink;
			if(i)
				hitlink = Screen->LoadEWeapon(i);
			if(LinkCollision(this))
				G[G_DASHINTERRUPT] = 1;
			if(hitlink->isValid()&&hitlink==this){
				this->DeadState = WDS_ALIVE;
				this->DrawYOffset = -1000;
				Link->HitDir = -1;
				for(int i=0; i<pushframes; ++i){
					LinkMovement_Push(VectorX(this->Step/50, RadtoDeg(this->Angle)), VectorY(this->Step/50, RadtoDeg(this->Angle)));
					this->DeadState = WDS_ALIVE;
					this->DrawYOffset = -1000;
					Waitframe();
				}
				this->DeadState = 0;
			}
			Waitframe();
		}
	}
}

const int EWS_GLOW = 19;

eweapon script GlowEW{
	void run(int scale){
		while(true){
			DarkRoom_AddLight(CenterX(this), CenterY(this), 0, scale, 1, 0, 0, 0);
			Waitframe();
		}
	}
}

const int EWS_SELETDAGGER = 22;

eweapon script SeletDagger{
	void DrawDaggerAura(eweapon this, bitmap b, int layer, int x, int y){
		b->Clear(0);
		b->DrawTile(0, 0, 0, this->Tile, 1, 1, this->CSet, -1, -1, 0, 0, this->Rotation, 0, true, 128);
		b->ReplaceColors(0, Choose(0x71, 0x72, 0x73), 0x01, 0xBF);
		b->Blit(layer, RT_SCREEN, 0, 0, 16, 16, x+this->DrawXOffset, y+this->DrawYOffset, 16, 16, 0, 0, 0, 0, 0, true);
	}
	void run(int daggerstate, int returnX, int returnY){
		int bitid = TempBitmap_Create(0, 16, 16);
		bitmap b = TempBMP[bitid];
		int collideFrames;
		while(collideFrames<4){
			if(Screen->isSolid(this->X+8, this->Y+8))
				++collideFrames;
			this->DeadState = WDS_ALIVE;
			Waitframe();
		}
		this->Step = 0;
		this->Tile = 106618;
		while(this->InitD[0]==0){
			this->DeadState = WDS_ALIVE;
			Waitframe();
		}
		int x = this->X;
		int y = this->Y;
		for(int i=0; i<24; ++i){
			this->X = x+Rand(-1, 1);
			this->Y = y+Rand(-1, 1);
			this->DeadState = WDS_ALIVE;
			DrawDaggerAura(this, b, 2, this->X+Choose(-1, 1), this->Y+Choose(-1, 1));
			Waitframe();
		}
		Game->PlaySound(SFX_SPINATTACK);
		this->X = x;
		this->Y = y;
		this->Step = this->InitD[0];
		this->Angle = DegtoRad(Angle(this->X, this->Y, this->InitD[1], this->InitD[2]));
		this->Tile = 106616;
		while(Distance(this->X, this->Y, this->InitD[1], this->InitD[2])>this->Step/100){
			this->Angle = DegtoRad(Angle(this->X, this->Y, this->InitD[1], this->InitD[2]));
			this->DeadState = WDS_ALIVE;
			this->Rotation = WrapDegrees(this->Rotation-20);
			DrawDaggerAura(this, b, 2, this->X+Choose(-1, 1), this->Y+Choose(-1, 1));
			Waitframe();
		}
		TempBitmap_Free(0, bitid);
		this->DeadState = 0;
	}
}

eweapon script VunterSlaush{
	void run(int _vertices, int _x, int _y, int special, int maxW){
		int i;
		
		int clrs[] = {0x73, 0x72, 0x71};
		if(maxW==0)
			maxW = 12;
		
		int pointX[16];
		int pointY[16];
		int pointScales[16];
		int pointAngle[16];
		int vertices = this->InitD[0];
		int x = this->InitD[1];
		int y = this->InitD[2];
		for(i=0; i<16; ++i){
			pointX[i] = x+8;
			pointY[i] = y+8;
			pointAngle[i] = RadtoDeg(this->Angle);
		}
		while(true){
			if(special==1){
				if(G[G_ANIM]%8<4){
					clrs[0] = 0x77;
					clrs[1] = 0x76;
					clrs[2] = 0x71;
				}
				else{
					clrs[0] = 0x78;
					clrs[1] = 0x77;
					clrs[2] = 0x76;
				}
			}
			
			vertices = this->InitD[0];
			x = this->InitD[1];
			y = this->InitD[2];
			if(vertices>1&&vertices<17){
				for(i=0; i<vertices; ++i){
					pointScales[i] = TrapezoidCurve(i, vertices-1, 0.3, 0.3, maxW);
					if(special==1&&i%2==0)
						pointScales[i] *= 0.25;
				}
				if(vertices==16){
					for(i=vertices-1; i>0; --i){
						pointX[i] = pointX[i-1];
						pointY[i] = pointY[i-1];
						pointAngle[i] = pointAngle[i-1];
					}
					pointX[0] = x+8;
					pointY[0] = y+8;
					pointAngle[0] = WrapDegrees(RadtoDeg(this->Angle));
				}
				
				DrawPolyTrail(4, vertices, pointX, pointY, pointScales, pointAngle, 0, clrs[0], this->Damage);
				DrawPolyTrail(4, vertices, pointX, pointY, pointScales, pointAngle, 0.6, clrs[1], 0);
				DrawPolyTrail(4, vertices, pointX, pointY, pointScales, pointAngle, 0.9, clrs[2], 0);
			}
			Waitframe();
		}
	}
}

const int TIL_LINKFROZENICE = 69176;

eweapon script FrozenStatus{
	void run(){
		//int bitid = TempBitmap_Create(0, 16, 32);
		bitmap b = Game->CreateBitmap(16, 32);
		b->Own();
		int til = Link->Tile-20;
		int flip = Link->Flip;
		int shakeDir = -1;
		int shakeTimer;
		int damageTimer;
		Link->HP -= 8;
		Game->PlaySound(SFX_OUCH);
		int x = Link->X;
		int y = Link->Y;
		while(G[G_FROZENTIMER]>0){
			if(Link->Falling){
				G[G_FROZENTIMER] = 0;
				this->DeadState = 0;
				Quit();
			}
			Link->HitDir = -1;
			// Link->X = x;
			// Link->Y = y;
			int offX = 0;
			int offY = 0;
			if(shakeTimer){
				offX += DirX(shakeDir, shakeTimer);
				offY += DirY(shakeDir, shakeTimer);
			}
			MakeLinkInvisible(2);
			TurnOffLinkCollision(2);
			Screen->DrawTile(2, Link->X-8+offX, Link->Y-12+offY, TIL_LINKFROZENICE, 2, 2, 7, -1, -1, 0, 0, 0, 0, true, 128);
			b->Clear(0);
			b->DrawTile(0, 0, 0, til, 1, 2, 6, -1, -1, 0, 0, 0, flip, true, 128);
			b->ReplaceColors(0, 0x7F, 0x01, 0xBF);
			b->Blit(2, RT_SCREEN, 0, 0, 16, 32, Link->X+offX/2, Link->Y-16+offY/2, 16, 32, 0, 0, 0, BITDX_TRANS, 0, true);
			if(shakeTimer){
				--shakeTimer;
			}
			else{
				if(G[G_UPINPUT]==2){
					Game->PlaySound(58);
					shakeDir = DIR_UP;
					shakeTimer = 4;
					G[G_FROZENTIMER] -= 10;
				}
				else if(G[G_DOWNINPUT]==2){
					Game->PlaySound(58);
					shakeDir = DIR_DOWN;
					shakeTimer = 4;
					G[G_FROZENTIMER] -= 10;
				}
				else if(G[G_LEFTINPUT]==2){
					Game->PlaySound(58);
					shakeDir = DIR_LEFT;
					shakeTimer = 4;
					G[G_FROZENTIMER] -= 10;
				}
				else if(G[G_RIGHTINPUT]==2){
					Game->PlaySound(58);
					shakeDir = DIR_RIGHT;
					shakeTimer = 4;
					G[G_FROZENTIMER] -= 10;
				}
			}
			
			G[G_NOACTION] = 1;
			--G[G_FROZENTIMER];
			++damageTimer;
			if(damageTimer>60){
				damageTimer = 0;
				Link->HP -= 4;
				Game->PlaySound(SFX_OUCH);
			}
			WaitNoAction();
		}
		G[G_FROZENTIMER] = 0;
		Game->PlaySound(90);
		for(int i=0; i<16; ++i){
			ParticleAnim(Link->X+Rand(-16, 16), Link->Y+Rand(-16, 16), SPR_SNOWFLAKEPARTICLE);
			Waitframes(2);
		}
	}
}

eweapon script ScriptJinxStatus{
	void AddSkullParticle(int sp, int x, int y, int lyr){
		int spX = sp[0];
		int spY = sp[1];
		int spF = sp[2];
		int spA = sp[3];
		int spL = sp[4];
		for(int i=0; i<16; ++i){
			if(spF[i]==0){
				spX[i] = x;
				spY[i] = y;
				spF[i] = 1;
				spA[i] = 0;
				spL[i] = lyr;
				return;
			}
		}
	}
	void UpdateSkullParticles(int sp){
		int spX = sp[0];
		int spY = sp[1];
		int spF = sp[2];
		int spA = sp[3];
		int spL = sp[4];
		for(int i=0; i<16; ++i){
			if(spF[i]>0){
				if(G[G_ANIM]%4<2||G[G_SCRIPTJINX]>16)
					Screen->FastTile(spL[i], spX[i], spY[i], 69252+spF[i]-1, 11, 128);
				++spA[i];
				if(spA[i]>4){
					++spF[i];
					if(spF[i]>6)
						spF[i] = 0;
					spA[i] = 0;
				}
			}
		}
	}
	void run(){
		int bitid = TempBitmap_Create(0, 16, 32);
		bitmap b = TempBMP[bitid];
		
		int spX[32];
		int spY[32];
		int spF[32];
		int spA[32];
		int spL[32];
		int sp[] = {spX, spY, spF, spA, spL};
		
		int t = Rand(360);
		while(G[G_SCRIPTJINX]!=0){
			b->Clear(0);
			if(SingleTileLinkAction())
				b->DrawTile(0, 0, 16, Link->Tile, 1, 1, 6, -1, -1, 0, 0, 0, Link->Flip, true, 128);
			else
				b->DrawTile(0, 0, 0, Link->Tile-20, 1, 2, 6, -1, -1, 0, 0, 0, Link->Flip, true, 128);
			b->ReplaceColors(0, G[G_ANIM]%4<2?0xB6:0xB8, 0x01, 0xBF);
			b->Blit(2, RT_SCREEN, 0, 0, 16, 32, Link->X+Link->DrawXOffset+Rand(-1, 1), Link->Y+Link->DrawYOffset-16+Rand(-1, 1), 16, 32, 0, 0, 0, 0, 0, true);
			++G[G_SCRIPTJINXRUNNING];
			
			t = (t+4)%360;
			UpdateSkullParticles(sp);
			for(int i=0; i<2; ++i){
				int x = VectorX(12, t+180*i);
				int y = VectorY(6, t+180*i);
				int lyr = (y>0?3:2);
				x += Link->X;
				y += Link->Y-4;
				if(G[G_ANIM]%4<2||G[G_SCRIPTJINX]>16)
					Screen->FastTile(lyr, x+Rand(-1, 1), y+Rand(-1, 1), G[G_ANIM]%4<2?69250:69251, 11, 128);
				if(G[G_ANIM]%4==0){
					AddSkullParticle(sp, x+Rand(-2, 2), y+Rand(-2, 2), lyr);
				}
			}
			
			Waitframe();
		}
	}
}

const int TIL_DRACULAMETEOR = 66148;

eweapon script DraculaMeteor{
	void run(int accel, int explosionradius){
		int angles[16];
		int dists[16];
		for(int i=0; i<16; ++i){
			angles[i] = Rand(360);
			dists[i] = Rand(16, 24);
		}
		int oldstep = this->Step;
		this->Step = 0;
		this->DrawXOffset = -1000;
		this->CollDetection = false;
		for(int i=0; i<16; ++i){
			int c = Choose(0x91, 0x96, 0x97);
			for(int j=0; j<16; ++j){
				Screen->Line(4, this->X+8, this->Y+8, this->X+8+VectorX(Lerp(dists[j], 0, i/16), angles[j]), this->Y+8+VectorY(Lerp(dists[j], 0, i/16), angles[j]), c, 1, 0, 0, 0, 128);
			}
			Screen->Circle(4, this->X+8, this->Y+8, Lerp(0, 8, i/16), c, 1, 0, 0, 0, true, 128);
			Screen->Circle(4, this->X+8, this->Y+8, Lerp(0, 24, i/16), c, 1, 0, 0, 0, false, i>8?64:128);
			
			Waitframe();
		}
		this->Tile = 66148;
		this->OriginalTile = this->Tile;
		this->CSet = 8;
		this->DrawXOffset = 0;
		this->Rotation = Rand(360);
		this->Step = oldstep;
		this->CollDetection = true;
		bool waitCollide = true;
		while(true){
			this->Rotation = WrapDegrees(this->Rotation+5);
			this->Step += accel;
			if(waitCollide){
				if(!IsSolidNoPit(this->X+8, this->Y+8))
					waitCollide = false;
			}
			if(this->DeadState!=WDS_ALIVE||(!waitCollide&&IsSolidNoPit(this->X+8, this->Y+8))){
				break;
			}
			Waitframe();
		}
		if(!(this->Misc[EWM_FLAGS]&EWMF_REFLECTED)){
			if(this->X>0&&this->X<240&&this->Y>0&&this->Y<160){
				eweapon e = FireEWeapon(EW_STELLAR, this->X, this->Y, 0, 0, this->Damage, 0, 0, 0);
				RunEWeaponScript(e, "Meteorite", {0, 1, explosionradius});
				e->CollDetection = false;
				e->DrawYOffset = -1000;
				for(int i=0; i<16; ++i){
					this->DeadState = WDS_ALIVE;
					this->Step = 0;
					this->Rotation = WrapDegrees(this->Rotation+20);
					Waitframe();
				}
			}
		}
		this->DeadState = 0;
	}
}

eweapon script CosmicSun{
	void Draw(bitmap b, int layer, int x, int y, int r, int ang, int numTentacle, int tentaFrames, int damage){
		b->Clear(0);
		for(int i=0; i<numTentacle; ++i){
			int a = ang+Lerp(0, 360, i/numTentacle);
			int x2 = 128+VectorX(r, a);
			int y2 = 128+VectorY(r, a);
			NightmareSelet::TentacleLong2(b, x2, y2, 16, a, tentaFrames[i], 0, 2);
		}
		b->Circle(0, 128, 128, r+4, 0x0F, 1, 0, 0, 0, true, 128);
		b->ReplaceColors(0, Choose(0x71, 0x76, 0x77, 0x78), 0x0F, 0x0F);
		b->Blit(layer, RT_SCREEN, 0, 0, 256, 256, x-128, y-128, 256, 256, 0, 0, 0, 0, 0, true);
		if(damage>0){
			r += 16;
			MakeHitbox(EW_SCRIPT10, x-r*0.7071, y-r*0.7071, r*2*0.7071, r*2*0.7071, damage);
		}
	}
	void run(int rad, int growSpeed, int pauseFrames, int shrinkSpeed){
		bitmap b = Game->CreateBitmap(256, 256);
		b->Own();
		int baseAng = Rand(360);
		int numTentacle = Ceiling(2*PI*rad/16);
		int tentaFrames[128];
		int tentaSkip[128];
		for(int i=0; i<128; ++i){
			tentaFrames[i] = Rand(90);
			tentaSkip[i] = Rand(4, 8);
		}
		for(int i=0; i<rad; i=Min(i+growSpeed, rad)){
			baseAng = WrapDegrees(baseAng+2);
			for(int j=0; j<128; ++j){
				tentaFrames[j] = (tentaFrames[j]+8)%90;
				if(G[G_ANIM]%tentaSkip[j])
					tentaFrames[j] = (tentaFrames[j]+2)%90;
			}
			Draw(b, 4, this->X+8, this->Y+8, i, baseAng, numTentacle, tentaFrames, this->Damage);
			Waitframe();
		}
		for(int i=0; i<pauseFrames; ++i){
			baseAng = WrapDegrees(baseAng+2);
			for(int j=0; j<128; ++j){
				tentaFrames[j] = (tentaFrames[j]+8)%90;
				if(G[G_ANIM]%tentaSkip[j])
					tentaFrames[j] = (tentaFrames[j]+2)%90;
			}
			Draw(b, 4, this->X+8, this->Y+8, rad, baseAng, numTentacle, tentaFrames, this->Damage);
			Waitframe();
		}
		for(int i=rad; i>0; i=Max(i-shrinkSpeed, 0)){
			baseAng = WrapDegrees(baseAng+2);
			for(int j=0; j<128; ++j){
				tentaFrames[j] = (tentaFrames[j]+8)%90;
				if(G[G_ANIM]%tentaSkip[j])
					tentaFrames[j] = (tentaFrames[j]+2)%90;
			}
			Draw(b, 4, this->X+8, this->Y+8, i, baseAng, numTentacle, tentaFrames, this->Damage);
			Waitframe();
		}
		this->DeadState = 0;
	}
}

eweapon script AsteroidChunk{
	void run(){
		int step = this->Step/100;
		while(true){
			this->Rotation = WrapDegrees(this->Rotation+step*3);
			if(this->DeadState!=WDS_ALIVE||Screen->isSolid(this->X+8, this->Y+8))
				break;
			Waitframe();
		}
		this->DeadState = WDS_ALIVE;
		this->CollDetection = false;
		this->DrawYOffset = -1000;
		if(LinkCollision(this)){
			for(int i=0; i<3; ++i){
				int j = i*4;
				eweapon e = FireEWeapon(EW_BOMBBLAST, this->X+Rand(-j, j), this->Y+Rand(-j, j), 0, 0, this->Damage, 0, 0, 0);
				Waitframes(4);
			}
		}
		else{
			int offX[3];
			offX[1] = Choose(-8, 8);
			offX[2] = -offX[1];
			for(int i=0; i<3; ++i){
				eweapon e = FireEWeapon(EW_BOMBBLAST, this->X+offX[i], this->Y, 0, 0, this->Damage, 0, 0, 0);
				Waitframes(4);
			}
		}
		this->DeadState = 0;
	}
}

eweapon script BezierLaser{
	void GetSplinePoint(int xy, int pointX, int pointY, int t){
		int p1 = Floor(t)+1;
		int p2 = p1+1;
		int p3 = p2+1;
		int p0 = p1-1;
		
		t -= Floor(t);
		
		int tt = t*t;
		int ttt = tt*t;
		
		int q1 = -ttt + 2*tt - t;
		int q2 = 3*ttt - 5*tt + 2;
		int q3 = -3*ttt + 4*tt + t;
		int q4 = ttt - tt;
		
		xy[0] = 0.5*(pointX[p0]*q1 + pointX[p1]*q2 + pointX[p2]*q3 + pointX[p3]*q4);
		xy[1] = 0.5*(pointY[p0]*q1 + pointY[p1]*q2 + pointY[p2]*q3 + pointY[p3]*q4);
	}
	void SplinePath(int arrX, int arrY, int numPath, int pointX, int pointY, int numPoints){
		int slice = numPath/(numPoints-3);
		for(int i=0; i<numPath; ++i){
			int t = i/slice;
			int xy[2];
			GetSplinePoint(xy, pointX, pointY, t);
			arrX[i] = xy[0];
			arrY[i] = xy[1];
		}
	}
	int TracePath(int arrX, int arrY, int numPath, int pathX, int pathY){
		int len;
		int oldX = arrX[0];
		int oldY = arrY[0];
		for(int i=0; i<numPath-1; ++i){
			int x = oldX;
			int y = oldY;
			int x2 = arrX[i+1];
			int y2 = arrY[i+1];
			int dist = Distance(x, y, x2, y2);
			int ang = Angle(x, y, x2, y2);
			// Trace(arrX[i]);
			// Trace(arrY[i]);
			// Trace(dist);
			if(dist>=1){
				for(int j=0; j<Floor(dist); ++j){
					pathX[len] = x;
					pathY[len] = y;
					x += VectorX(1, ang);
					y += VectorY(1, ang);
					++len;
				}
				oldX = x2;
				oldY = y2;
			}
		}
		return len;
	}
	int SetPoints(int points, int pointX, int pointY){
		int size = SizeOfArray(points)/2;
		
		for(int i=0; i<size; ++i){
			pointX[i] = points[i*2+0];
			pointY[i] = points[i*2+1];
		}
		return size;
	}
	void run(int isIgnition, int sourceX, int sourceY, int pattern, int flip, int offset){
		if(isIgnition)
			runIgnition(this);
		//runDebug();
		int pointX[64];
		int pointY[64];
		int numPoints;
		int arrX[128];
		int arrY[128];
		int pathX[2048];
		int pathY[2048];
		int pathLength;
		
		switch(pattern){
			case 0: //Single, A
				numPoints = SetPoints({110,73, 110,73, 44,75, 46,133, 195,81, 215,109, 199,133, 99,129, 55,106, 142,81, 217,138, 217,138}, pointX, pointY);
				break;
			case 1: //Single, B
				numPoints = SetPoints({110,137, 110,137, 47,138, 48,80, 86,80, 88,125, 126,125, 127,79, 167,78, 167,132, 210,137, 216,77, 216,77}, pointX, pointY);
				break;
			case 2: //Double, A
			
				numPoints = SetPoints({111,78, 111,78, 78,136, 41,79, 127,138, 174,80, 183,133, 140,81, 140,81}, pointX, pointY);
				break;
			case 3: //Double, B
				numPoints = SetPoints({111,77, 111,77, 60,78, 59,101, 189,100, 189,124, 57,123, 116,136, 178,79, 112,77, 112,77}, pointX, pointY);
				break;
		}
		
		for(int i=0; i<numPoints; ++i){
			if(offset){
				pointX[i] += offset;
			}
			if(flip)
				pointX[i] = 255-pointX[i];
		}
		pointX[0] = (pointX[0]+sourceX)/2;
		pointX[1] = pointX[0];
		
		SplinePath(arrX, arrY, 128, pointX, pointY, numPoints);
		pathLength = TracePath(arrX, arrY, 128, pathX, pathY);
		// Trace(numPoints);
		// Trace(pathLength);
		
		bitmap b = Game->CreateBitmap(256, 176);
		b->Own();
		bitmap b2 = Game->CreateBitmap(256, 176);
		b2->Own();
		b2->ClearToColor(0, 0x01);
		b->Clear(0);
		
		int laserDist;
		bool laserDone;
		int explosionDist = -88;
		int laserStep = 3;
		if(IsEasyMode())
			laserStep = 2.5;
		if(NightmareSelet::IsSP())
			laserStep = 5;
		int sfxTimer[1];
		for(int i=0; laserDist<pathLength-1||explosionDist<pathLength-1; ++i){
			laserDist = Min(laserDist+laserStep, pathLength-1);
			explosionDist = Min(explosionDist+laserStep, pathLength-1);
			if(!laserDone){
				DrawThickLine(4, sourceX, sourceY, pathX[laserDist], pathY[laserDist], G[G_ANIM]%4<2?1:3, Choose(0x71, 0x76, 0x77, 0x78), true, 128);
				Screen->Circle(4, sourceX+Rand(-1, 1), sourceY+Rand(-1, 1), Rand(4, 6)+(G[G_ANIM]%6<4?0:4), Choose(0x71, 0x76, 0x77, 0x78), 1, 0, 0, 0, true, 128);
				Screen->Circle(4, pathX[laserDist]+Rand(-1, 1), pathY[laserDist]+Rand(-1, 1), Rand(4, 6)+(G[G_ANIM]%6<4?0:4), Choose(0x71, 0x76, 0x77, 0x78), 1, 0, 0, 0, true, 128);
				MakeHitbox(EW_SCRIPT10, pathX[laserDist]-4, pathY[laserDist]-4, 8, 8, this->Damage);
				LoopingSFX(sfxTimer, 6, SFX_LASERBEAM+1);
				for(int j=0; j<4; ++j){
					int k = laserDist-4+j;
					b->Circle(0, pathX[k], pathY[k], 2, 0x76, 1, 0, 0, 0, true, 128);
				}
				if(laserDist>=pathLength-1)
					laserDone = true;
			}
			for(int j=0; j<4; ++j){
				int k = explosionDist-4+j;
				if(k>=0)
					b->Circle(0, pathX[k], pathY[k], 2, 0x0F, 1, 0, 0, 0, true, 128);
			}
			if(explosionDist>=0&&explosionDist<pathLength&&i%4==0){
				eweapon e = FireEWeapon(EW_SCRIPT10, pathX[explosionDist]-8, pathY[explosionDist]-8, 0, 0, this->Damage, SPRITE_INVISIBLE, 0, EWF_UNBLOCKABLE);
				e->HitXOffset = 4;
				e->HitYOffset = 4;
				e->HitWidth = 8;
				e->HitHeight = 8;
				RunEWeaponScript(e, "BezierLaser", {1});
			}
			if(explosionDist+1>=0&&explosionDist+1<pathLength)
				b->Circle(0, pathX[explosionDist+1], pathY[explosionDist+1], 2, 0x76, 1, 0, 0, 0, true, 128);
			b->Blit(1, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_TRANS, 0, true);
			Waitframe();
		}
		b->Dither(0, b2, 0x00, DITH_GRID_INV, 2);
		for(int i=0; i<8; ++i){
			b->Blit(1, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_TRANS, 0, true);
			Waitframe();
		}
		b->Dither(0, b2, 0x00, DITH_CHECKER, 0);
		for(int i=0; i<8; ++i){
			b->Blit(1, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_TRANS, 0, true);
			Waitframe();
		}
		b->Dither(0, b2, 0x00, DITH_GRID, 4);
		for(int i=0; i<8; ++i){
			b->Blit(1, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_TRANS, 0, true);
			Waitframe();
		}
		this->DeadState = 0;
	}
	void runIgnition(eweapon this){
		Game->PlaySound(73);
		this->DeadState = WDS_ALIVE;
		int w;
		for(int i=0; i<16; ++i){
			w = Lerp(4, 0, i/16);
			Screen->Rectangle(5, this->X+8-w, 0, this->X+8+w, this->Y+8, 0x01, 1, 0, 0, 0, true, 128);
			Screen->Ellipse(5, this->X+8, this->Y+8, w, 3, 0x01, 1, 0, 0, 0, true, 128);
			this->DeadState = WDS_ALIVE;
			Waitframe();
		}
		this->DeadState = 0;
		Quit();
	}
	void runDebug(){
		int pointX[64];
		int pointY[64];
		int numPoints;
		//numPoints = SetPoints({111,78, 111,78, 78,136, 43,78, 127,138, 174,80, 215,137, 140,81, 140,81}, pointX, pointY);
		while(true){
			if(numPoints>3){
				int arrX[128];
				int arrY[128];
				SplinePath(arrX, arrY, 128, pointX, pointY, numPoints);
				for(int i=0; i<127; ++i){
					Screen->Line(6, arrX[i], arrY[i], arrX[i+1], arrY[i+1], 0x0D, 1, 0, 0, 0, 128);
				}
			}
			if(Link->PressA){
				if(numPoints==0){
					pointX[numPoints] = Link->InputMouseX;
					pointY[numPoints] = Link->InputMouseY;
					++numPoints;
				}
				pointX[numPoints] = Link->InputMouseX;
				pointY[numPoints] = Link->InputMouseY;
				++numPoints;
			}
			if(Link->PressB){
				printf("{");
				for(int i=0; i<numPoints; ++i){
					if(i<numPoints-1)
						printf("%d,%d, ", pointX[i], pointY[i]);
					else
						printf("%d,%d}\n", pointX[i], pointY[i]);
				}
			}
			
			int closestPoint;
			int closestDist = 1000;
			for(int i=0; i<numPoints; ++i){
				int dist = Distance(pointX[i], pointY[i], Link->InputMouseX, Link->InputMouseY);
				if(dist<closestDist){
					closestPoint = i;
					closestDist = dist;
				}
				Screen->Circle(6, pointX[i], pointY[i], 2, 0x0D, 1, 0, 0, 0, true, 128);
			}
			if(Link->InputMouseB&&numPoints>0){
				pointX[closestPoint] = Link->InputMouseX;
				pointY[closestPoint] = Link->InputMouseY;
			}
			
			Screen->Circle(6, Link->InputMouseX, Link->InputMouseY, 2, Rand(16), 1, 0, 0, 0, true, 128);
			
			Waitframe();
		}
	}
}

const int SFX_VOIDSPIKE_APPEAR = 80;
const int SFX_VOIDSPIKE_STAB = 78;

eweapon script VoidSpike{
	const int STATE = 2;
	const int TIMER = 3;
	const int LENGTH = 4;
	const int WSCALE = 5;
	const int SCALE = 6;
	void run(int controller, untyped bmp, int state, int timer, int length, int wScale, int scale){
		if(controller==1){
			runController(this, bmp);
		}
		else{
			runSpike(this);
		}
	}
	
	void runController(eweapon this, untyped bmp){
		bool noSpikes = true;
		
		bitmap stars = <bitmap>bmp;
		bitmap spikes = Game->CreateBitmap(256, 176);
		bitmap hitboxes = Game->CreateBitmap(256, 176);
		bitmap scrn = Game->CreateBitmap(256, 176);
		spikes->Own();
		hitboxes->Own();
		scrn->Own();
		spikes->ClearToColor(0, 0x01);
		hitboxes->Clear(0);
		scrn->Clear(0);
		
		while(noSpikes){
			for(int i=Screen->NumEWeapons(); i>0; --i){
				eweapon e = Screen->LoadEWeapon(i);
				if(e->Script==this->Script&&e->InitD[0]!=1){
					noSpikes = false;
					break;
				}
			}
			Waitframe();
		}
		int anim;
		int noSpikeFrames = 64;
		while(noSpikeFrames>0){
			anim = (anim+1)%360;
			noSpikes = true;
			stars->Blit(0, scrn, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
			spikes->ClearToColor(0, 0x01);
			hitboxes->Clear(0);
			for(int i=Screen->NumEWeapons(); i>0; --i){
				eweapon e = Screen->LoadEWeapon(i);
				if(e->Script==this->Script&&e->InitD[0]!=1&&e->InitD[STATE]<4){
					noSpikes = false;
					
					int angle = RadtoDeg(e->Angle);
					int size = Lerp(0, 16, e->InitD[SCALE]);
					DrawSpike(spikes, e->X+8, e->Y+8, size, size*0.6666, angle, e->InitD[LENGTH]*e->InitD[WSCALE], e->InitD[WSCALE], anim, 0x00);
					if(e->InitD[STATE]>0)
						DrawSpike(hitboxes, e->X+8, e->Y+8, size, size*0.6666, angle, e->InitD[LENGTH]*e->InitD[WSCALE], e->InitD[WSCALE], anim, 0x01);
				}
			}
			if(noSpikes)
				--noSpikeFrames;
			else
				noSpikeFrames = 64;
			
			int collisionPoints;
			for(int i=0; i<4; ++i){
				int x = Link->X+6+3*(i%2);
				int y = Link->Y+10+3*Floor(i/2);
				if(Graphics->GetPixel(hitboxes, x, y)*10000==0x01){
					++collisionPoints;
				}
			}
			if(collisionPoints>1){
				DamageLink(this->Damage);
			}
			
			scrn->MaskedDraw(0, spikes, 0x00);
			scrn->Blit(4, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
			Waitframe();
		}
		this->DeadState = 0;
	}
	void runSpike(eweapon this){
		Game->PlaySound(SFX_VOIDSPIKE_APPEAR);
		while(true){
			this->InitD[SCALE] = Min(this->InitD[SCALE]+0.05, 1);
			switch(this->InitD[STATE]){
				case 0: //Waiting
					if(this->InitD[TIMER])
						--this->InitD[TIMER];
					else{
						Game->PlaySound(SFX_VOIDSPIKE_STAB);
						this->InitD[STATE] = 1;
						this->InitD[TIMER] = 8;
					}
					break;
				case 1: //Spike growing
					this->InitD[WSCALE] = Lerp(1, 0, this->InitD[TIMER]/8);
					if(this->InitD[TIMER])
						--this->InitD[TIMER];
					else{
						this->InitD[STATE] = 2;
						this->InitD[TIMER] = 32;
					}
					break;
				case 2: //Spike out
					this->InitD[WSCALE] = 1;
					if(this->InitD[TIMER])
						--this->InitD[TIMER];
					else{
						this->InitD[STATE] = 3;
						this->InitD[TIMER] = 16;
					}
					break;
				case 3: //Spike retracting
					this->InitD[WSCALE] = Lerp(0, 1, this->InitD[TIMER]/16);
					if(this->InitD[TIMER])
						--this->InitD[TIMER];
					else{
						this->InitD[STATE] = 4;
						this->DeadState = 0;
					}
					break;
			}
			Waitframe();
		}
	}
	void DrawSpike(bitmap b, int x, int y, int r1, int r2, int angle, int dist, int wScale, int frame, int clr){
		int verts[20];
		
		int tmpX;
		int tmpY;
		
		for(int i=0; i<10; ++i){
			int mult = 1;
			if(i%2==1)
				mult = 0.618; //0.382 for regular star
			tmpX = x+VectorX(r2*mult, 36*i+20*frame);
			tmpY = y+VectorY(r1*mult, 36*i+20*frame);
			
			int d = LargeDistance(x, y, tmpX, tmpY, 10);
			int a = Angle(x, y, tmpX, tmpY);
			
			a += angle;
			verts[i*2+0] = x+VectorX(d, a);
			verts[i*2+1] = y+VectorY(d, a);
		}
		
		b->Polygon(0, 10, verts, clr, 128);
		
		if(wScale>0){
			int verts2[10];
			
			verts2[0] = x+VectorX(r2*0.6*wScale, angle-90);
			verts2[1] = y+VectorY(r2*0.6*wScale, angle-90);
			
			verts2[2] = x+VectorX(r2*0.4*wScale, angle-90)+VectorX(dist*0.6666, angle);
			verts2[3] = y+VectorY(r2*0.4*wScale, angle-90)+VectorY(dist*0.6666, angle);
			
			verts2[4] = x+VectorX(dist, angle);
			verts2[5] = y+VectorY(dist, angle);
			
			verts2[6] = x+VectorX(r2*0.4*wScale, angle+90)+VectorX(dist*0.6666, angle);
			verts2[7] = y+VectorY(r2*0.4*wScale, angle+90)+VectorY(dist*0.6666, angle);
			
			verts2[8] = x+VectorX(r2*0.6*wScale, angle+90);
			verts2[9] = y+VectorY(r2*0.6*wScale, angle+90);
			
			b->Polygon(0, 5, verts2, clr, 128);
		}
	}
}

eweapon script CosmicArrow{
	void run(int w, int trackingFrames, int trackSpeed, int earlyTurn, int step2, int step3){
		int i;
		
		int clrs[] = {0x77, 0x76, 0x71};
		
		int trailX[128];
		int trailY[128];
		int pointX[16];
		int pointY[16];
		int pointAngle[16];
		int pointSpacing[16] = {0, 12, 2, 12, 2, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8};
		int pointScales[16];
		
		int stepData[2] = {0, 1000};
		
		for(i=0; i<128; ++i){
			trailX[i] = this->X;
			trailY[i] = this->Y;
		}
		
		for(i=0; i<16; ++i){
			pointX[i] = trailX[i*8];
			pointY[i] = trailY[i*8];
		}
		pointScales[0] = 0;
		pointScales[1] = w;
		pointScales[2] = w*0.4444;
		pointScales[3] = w*0.6666;
		pointScales[4] = w*0.4444;
		
		for(i=0; i<11; ++i){
			pointScales[5+i] = Lerp(w*0.3333, 0, i/10)*(i%2==0?1:0.9);
		}
		
		bool enteredScreen;
		bool leftScreen;
		bool passedLink;
		int angle = RadtoDeg(this->Angle);
		
		int trackingFramesMax = trackingFrames;
		int step = this->Step;
		
		while(!enteredScreen||!leftScreen){
			if(Abs(AngDiff(angle, Angle(this->X+VectorX(earlyTurn, angle), this->Y+VectorY(earlyTurn, angle), Link->X, Link->Y)))>90)
				passedLink = true;
			
			if(this->X>-16&&this->X<256&&this->Y>-16&&this->Y<176)
				enteredScreen = true;
			
			if(passedLink){
				if(trackingFrames>0){
					--trackingFrames;
					angle = TurnToAngle(angle, Angle(this->X, this->Y, Link->X, Link->Y), trackSpeed);
				}
				if(trackingFrames>trackingFramesMax/2)
					this->Step = Lerp(step, step2, Sin((trackingFramesMax-trackingFrames)/trackingFramesMax*180));
				else
					this->Step = Lerp(step3, step2, Sin((trackingFramesMax-trackingFrames)/trackingFramesMax*180));
			}
			this->Angle = DegtoRad(angle);
			
			leftScreen = true;
			this->DeadState = WDS_ALIVE;
			
			if(G[G_ANIM]%8<4){
				clrs[0] = 0x77;
				clrs[1] = 0x76;
				clrs[2] = 0x71;
			}
			else{
				clrs[0] = 0x78;
				clrs[1] = 0x77;
				clrs[2] = 0x76;
			}
			
			UpdateWormTrailsXY(this->X, this->Y, trailX, trailY, stepData);
			
			int spacing;
			for(i=0; i<16; ++i){
				spacing += pointSpacing[i];
				pointX[i] = trailX[spacing]+8;
				pointY[i] = trailY[spacing]+8;
				if(i==0){
					pointAngle[i] = RadtoDeg(this->Angle);
				}
				else{
					pointAngle[i] = Angle(pointX[i], pointY[i], pointX[i-1], pointY[i-1]);
				}
				if(pointX[i]-8>-16&&pointX[i]-8<256&&pointY[i]-8>-16&&pointY[i]-8<176)
					leftScreen = false;
			}
			
			DrawPolyTrail(4, 16, pointX, pointY, pointScales, pointAngle, 0, clrs[0], this->Damage);
			DrawPolyTrail(4, 16, pointX, pointY, pointScales, pointAngle, 0.6, clrs[1], 0);
			DrawPolyTrail(4, 16, pointX, pointY, pointScales, pointAngle, 0.9, clrs[2], 0);

			Waitframe();
		}
		this->DeadState = 0;
	}
}

eweapon script MoonFlashEW{
	void run(int size, int delay){
		int angle = Rand(360);
		for(int i=0; i<delay; ++i){
			angle += 4;
			int c = Choose(0x71, 0x72, 0x73);
			for(int j=0; j<18; ++j){
				Screen->PutPixel(6, this->X+8+VectorX(size/2, angle+20*j)+Rand(-2, 2), this->Y+8+VectorY(size/2, angle+20*j)+Rand(-2, 2), c, 0, 0, 0, 128);
			}
			Waitframe();
		}
		Game->PlaySound(SFX_SUMMON);
		for(int i=0; i<16; ++i){
			int til;
			int cs;
			bool draw;
			if(i<6||i>=13){
				til = 66196;
				cs = 11;
			}
			else{
				til = 66256;
				cs = 7;
			}
			if(i<4||i>=11){
				if(i%4<2)
					draw = true;
			}
			else
				draw = true;
			if(draw)
				Screen->DrawTile(6, this->X+8-size/2, this->Y+8-size/2, til, 3, 3, cs, size, size, 0, 0, 0, 0, true, 128);
			int hSize = size*0.7071;
			MakeHitbox(EW_LUNAR, this->X+8-hSize/2, this->Y+8-hSize/2, hSize, hSize, this->Damage);
			Waitframe();
		}
		this->DeadState = 0;
	}
}

eweapon script MegaLaser{
	void LaserQuad(bitmap b, int layer, int x, int y, int w1, int w2, int angle, int c, bool drawToScreen){
		int qX[4];
		int qY[4];
		
		qX[0] = x+VectorX(w1/2, angle-90);
		qY[0] = y+VectorY(w1/2, angle-90);
		
		qX[1] = x+VectorX(256, angle)+VectorX(w2/2, angle-90);
		qY[1] = y+VectorY(256, angle)+VectorY(w2/2, angle-90);
		
		qX[2] = x+VectorX(256, angle)+VectorX(w2/2, angle+90);
		qY[2] = y+VectorY(256, angle)+VectorY(w2/2, angle+90);
		
		qX[3] = x+VectorX(w1/2, angle+90);
		qY[3] = y+VectorY(w1/2, angle+90);
		
		if(drawToScreen)
			Screen->Quad(layer, qX[0], qY[0], qX[1], qY[1], qX[2], qY[2], qX[3], qY[3], 1, 1, c, 0, -1, PT_FLAT);
		else
			b->Quad(layer, qX[0], qY[0], qX[1], qY[1], qX[2], qY[2], qX[3], qY[3], 1, 1, c, 0, -1, PT_FLAT, NULL);
	}
	void DrawLaser(bitmap bg, bitmap erase, bitmap prt, bitmap final, int particle, int x, int y, int wStart, int wEnd, int angle, int timer, int scale, int damage){
		timer[0] = (timer[0]+1)%360;
		
		int w1 = Lerp(0, wStart*1+6+6*Sin(timer[0]*35), scale);
		int w2 = Lerp(0, wEnd*1+6+6*Sin(timer[0]*35), scale);
		
		for(int i=0; i<3; ++i){
			int elX = x+Rand(-1, 1);
			int elY = y+Rand(-1, 1);
			int scale = Lerp(1, 0.6, i/2);
			Screen->Ellipse(4, elX, elY, (w1*1.1+Rand(2)+((G[G_ANIM]%16>=12)?4:0))*scale, (w1*0.5+Rand(2))*scale, Choose(0x71, 0x76, 0x77, 0x78), 1, elX, elY, angle-90, true, 128);
		}
		
		if(QuadLaserCollision(x, y, x+VectorX(256, angle), y+VectorY(256, angle), w1, w2, 0)){
			int angLink = Angle(x-8, y-8, Link->X, Link->Y);
			// int vX = VectorX(1, angle);
			// int vY = VectorY(1, angle);
			// LinkMovement_Push(vX, vY);
			DamageLink(damage, x-8, y-8);
		}
		
		int particleDist = particle[0];
		int particleStep = particle[1];
		int particleOff = particle[2];
		
		final->Clear(0);
		prt->Clear(0);
		int particleLen = 48;
		for(int i=0; i<32; ++i){
			particleDist[i] += particleStep[i];
			
			int w = Lerp(w1, w2, particleDist[i]/256);
			int x1 = x+VectorX(-particleLen+particleDist[i], angle)+VectorX(-w/2+particleOff[i]*w, angle-90);
			int y1 = y+VectorY(-particleLen+particleDist[i], angle)+VectorY(-w/2+particleOff[i]*w, angle-90);
			
			w = Lerp(w1, w2, (particleDist[i]+particleLen)/256);
			int x2 = x+VectorX(-particleLen+particleDist[i]+particleLen, angle)+VectorX(-w/2+particleOff[i]*w, angle-90);
			int y2 = y+VectorY(-particleLen+particleDist[i]+particleLen, angle)+VectorY(-w/2+particleOff[i]*w, angle-90);
			
			DrawDiamondLine(prt, 0, x1, y1, x2, y2, 1, 0x0E, true, 128);
			
			if(particleDist[i]>256){
				particleDist[i] = 0;
				particleStep[i] = Rand(120, 160)/10;
				particleOff[i] = Rand(0, 100)/100;
			}
		}
		
		erase->ClearToColor(0, 0x0F);
		LaserQuad(erase, 0, x, y, w1, w2, angle, 0x00, false); //Choose(0x94, 0x95)
		bg->ClearToColor(0, Choose(0x94, 0x95));
		prt->Blit(0, bg, 0, 0, 256, 176, 0, 0, 265, 176, 0, 0, 0, 0, 0, true);
		bg->MaskedDraw(0, erase, 0x00);
		bg->ReplaceColors(0, Choose(0x0F, 0x95), 0x0E, 0x0E);
		bg->Blit(0, final, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
		
		w1 = Lerp(0, wStart*0.8+5+5*-Sin(timer[0]*40), scale);
		w2 = Lerp(0, wEnd*0.8+5+5*-Sin(timer[0]*40), scale);
		
		erase->ClearToColor(0, 0x0F);
		LaserQuad(erase, 0, x, y, w1, w2, angle, 0x00, false); //Choose(0x77, 0x78)
		bg->ClearToColor(0, Choose(0x77, 0x78));
		prt->Blit(0, bg, 0, 0, 256, 176, 0, 0, 265, 176, 0, 0, 0, 0, 0, true);
		bg->MaskedDraw(0, erase, 0x00);
		bg->ReplaceColors(0, Choose(0x94, 0x95), 0x0E, 0x0E);
		bg->Blit(0, final, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
		
		w1 = Lerp(0, wStart*0.4+4+4*Sin(timer[0]*45), scale);
		w2 = Lerp(0, wEnd*0.4+4+4*Sin(timer[0]*45), scale);
		
		erase->ClearToColor(0, 0x0F);
		LaserQuad(erase, 0, x, y, w1, w2, angle, 0x00, false); //Choose(0x77, 0x78)
		bg->ClearToColor(0, Choose(0x71, 0x76));
		if(timer[0]%4<2)
			prt->Blit(0, bg, 0, 0, 256, 176, 0, 0, 265, 176, 0, 0, 0, 0, 0, true);
		bg->MaskedDraw(0, erase, 0x00);
		if(timer[0]%4<2)
			bg->ReplaceColors(0, Choose(0x77, 0x78), 0x0E, 0x0E);
		bg->Blit(0, final, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
		
		//LaserQuad(NULL, 4, x, y, w1, w2, angle, Choose(0x71, 0x76), true);
		final->Blit(4, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
	}
	void run(int wStart, int wEnd, int angle, int openTime, int sustainTime, int closeTime){
		int particleDist[32];
		int particleStep[32];
		int particleOff[32];
		int particle[] = {particleDist, particleStep, particleOff};
		for(int i=0; i<32; ++i){
			particleDist[i] = Rand(256);
			particleStep[i] = Rand(120, 160)/10;
			particleOff[i] = Rand(0, 100)/100;
		}
		
		bitmap b = Game->CreateBitmap(256, 176);
		bitmap b2 = Game->CreateBitmap(256, 176);
		bitmap b3 = Game->CreateBitmap(256, 176);
		bitmap b4 = Game->CreateBitmap(256, 176);
		b->Own();
		b2->Own();
		b3->Own();
		b4->Own();
		b->Clear(0);
		b2->Clear(0);
		b3->Clear(0);
		b4->Clear(0);
		
		int timer[1];
		for(int i=0; i<openTime; ++i){
			DrawLaser(b, b2, b3, b4, particle, this->X+8, this->Y+8, wStart, wEnd, angle, timer, i/(openTime-1), this->Damage);
			Waitframe();
		}
		for(int i=0; i<sustainTime; ++i){
			DrawLaser(b, b2, b3, b4, particle, this->X+8, this->Y+8, wStart, wEnd, angle, timer, 1, this->Damage);
			Waitframe();
		}
		for(int i=0; i<closeTime; ++i){
			DrawLaser(b, b2, b3, b4, particle, this->X+8, this->Y+8, wStart, wEnd, angle, timer, 1-i/(closeTime-1), this->Damage);
			Waitframe();
		}
		this->DeadState = 0;
	}
}

eweapon script HERECOMESTHEGIANTFIST{
	void DrawFist(eweapon this, bitmap b, bitmap b2, int tile, int cset, int extend, int multipliers, int percent, bool doColl){
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
			Screen->Ellipse(2, x, y, 20*i+Rand(2), 7*i+Rand(2), Rand(0x31, 0x39), 1, x, y, angle+90, true, 128);
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
		if(doColl){
			if(RotRectCollision(hitX, hitY, extend, 20, angle, Link->X+8, Link->Y+8, 8, 8, 0, false)){
				DamageLink(this->Damage, this->X, this->Y);
			}
		}
	}
	void run(int extend, int extendTime, int sustainTime, int retractTime){
		bitmap b = Game->CreateBitmap(80, 32);
		b->Own();
		bitmap b2 = Game->CreateBitmap(80, 32);
		b2->Own();
		
		int multipliers[32];
		for(int i=0; i<32; ++i){
			multipliers[i] = Rand(8, 12)*0.1;
		}
		
		for(int i=0; i<extendTime; ++i){
			DrawFist(this, b, b2, this->Tile, this->CSet, extend, multipliers, i/extendTime, false);
			Waitframe();
		}
		for(int i=0; i<sustainTime; ++i){
			DrawFist(this, b, b2, this->Tile, this->CSet, extend, multipliers, 2, true);
			Waitframe();
		}
		for(int i=0; i<retractTime; ++i){
			DrawFist(this, b, b2, this->Tile, this->CSet, extend, multipliers, 1-(i/retractTime), false);
			Waitframe();
		}
		this->DeadState = 0;
	}
}

eweapon script SpeedChange{
	void run(int delay, int newSpeed, int newSprite){
		Waitframes(delay);
		this->Step = newSpeed;
		if(newSprite>0)
			this->UseSprite(newSprite);
	}
}

eweapon script WavySkull{
	const int AMP = 0;
	const int ANGLE = 1;
	const int ANGLECHANGE = 2;
	void DrawWavySkull(bitmap b, int layer, int x, int y, int waveH, int waveV, int scale, int op){
		b->Clear(0);
		
		b->DrawTile(0, 64+8, 8, 111037, 3, 3, 0, -1, -1, 0, 0, 0, 0, true, 128);
		
		for(int i=0; i<64; i+=4){
			b->Blit(0, b, 64+i, 8, 4, 48, 128+i, 8+waveV[AMP]*Sin(waveV[ANGLE]+waveV[ANGLECHANGE]*i/4), 4, 48, 0, 0, 0, 0, 0, true);
		}
		
		for(int i=0; i<64; i+=4){
			b->Blit(0, b, 128, i, 64, 4, waveV[AMP]*Sin(waveV[ANGLE]+waveV[ANGLECHANGE]*i/4), i, 64, 4, 0, 0, 0, 0, 0, true);
		}
		
		int off = 32-32*scale;
		int w = 64*scale;
		switch(op){
			case 64:
				b->Blit(layer, RT_SCREEN, 0, 0, 64, 64, x+off, y+off, w, w, 0, 0, 0, BITDX_TRANS, 0, true);
				break;
			case 96:
				b->Blit(layer, RT_SCREEN, 0, 0, 64, 64, x+off, y+off, w, w, 0, 0, 0, BITDX_TRANS, 0, true);
				b->Blit(layer, RT_SCREEN, 0, 0, 64, 64, x+off, y+off, w, w, 0, 0, 0, BITDX_TRANS, 0, true);
				break;
			case 128:
				b->Blit(layer, RT_SCREEN, 0, 0, 64, 64, x+off, y+off, w, w, 0, 0, 0, BITDX_NORMAL, 0, true);
				break;
		}
	}
	void run(int appearTime, int sustainTime, int fadeTime, int aSpeed, int specialLayer){
		bitmap b = Game->CreateBitmap(64*3, 128);
		b->Own();
		
		int waveH[4];
		int waveV[4];
		
		waveH[AMP] = 8;
		waveH[ANGLE] = 0;
		waveH[ANGLECHANGE] = 10;
		
		waveV[AMP] = 8;
		waveV[ANGLE] = 90;
		waveV[ANGLECHANGE] = 10;
		
		int layer = 2;
		if(specialLayer)
			layer = specialLayer;
		for(int i=0; i<appearTime; ++i){
			waveH[ANGLE] = WrapDegrees(waveH[ANGLE]+aSpeed);
			waveV[ANGLE] = WrapDegrees(waveH[ANGLE]+aSpeed);
			
			waveH[AMP] = Lerp(8, 2, i/appearTime);
			waveV[AMP] = Lerp(8, 2, i/appearTime);
			
			if(G[G_ANIM]%4<2)
				DrawWavySkull(b, layer, this->X-24, this->Y-24, waveH, waveV, 1, (i<appearTime/2)?64:96);
			
			Waitframe();
		}
		
		waveH[AMP] = 2;
		waveV[AMP] = 2;
		
		this->CollDetection = true;
		this->HitWidth = 48;
		this->HitHeight = 48;
		this->HitXOffset = -16;
		this->HitYOffset = -16;
		
		Game->PlaySound(144);
		for(int i=0; i<sustainTime; ++i){
			waveH[ANGLE] = WrapDegrees(waveH[ANGLE]+aSpeed);
			waveV[ANGLE] = WrapDegrees(waveH[ANGLE]+aSpeed);
			
			int ew = Link->HitBy[1];
			if(ew>0){
				eweapon e = Screen->LoadEWeapon(ew);
				if(e==this){
					G[G_SCRIPTJINX] = 300;
				}
			}
			this->DeadState = WDS_ALIVE;
			//MakeHitbox(EW_SCRIPT10, this->X-16, this->Y-16, 48, 48, this->Damage);
			
			DrawWavySkull(b, layer, this->X-24, this->Y-24, waveH, waveV, 1, 128);
			
			Waitframe();
		}
		
		this->CollDetection = false;
		Game->PlaySound(93);
		for(int i=0; i<fadeTime; ++i){
			waveH[ANGLE] = WrapDegrees(waveH[ANGLE]+aSpeed);
			waveV[ANGLE] = WrapDegrees(waveH[ANGLE]+aSpeed);
			
			waveH[AMP] = Lerp(8, 2, i/appearTime);
			waveV[AMP] = Lerp(8, 2, i/appearTime);
			
			DrawWavySkull(b, layer, this->X-24, this->Y-24, waveH, waveV, Lerp(1, 1.5, i/(fadeTime-1)), (i<fadeTime/2)?96:64);
			
			Waitframe();
		}
		this->DeadState = 0;
	}
}

//I don't actually know what this is. What was this for?
eweapon script HomingShotAngular{
	void run(int homingSpeed, int maxAng){
		int angle = this->Angle;
		int totalTurn;
		while(true){
			int targetAngle = Angle(this->X, this->Y, Link->X, Link->Y);
			if(maxAng==0||totalTurn<maxAng){
				int prevAngle = angle;
				angle = TurnToAngle(angle, targetAngle, homingSpeed);
				int diff = Abs(angle-prevAngle);
			}
			this->Angle = DegtoRad(angle);
			Waitframe();
		}
	}
}

eweapon script GeodeCollision{
	void run(int type, int d1, int d2, int d3){
		switch(type){
			case 0:
				runExplosion(this, d1, d2, d3);
				break;
			case 1:
				runEnergyTrail(this, d1, d2, d3);
				break;
			case 2:
				runKnockback(this, d1, d2, d3);
				break;
		}
	}
	void runExplosion(eweapon this, int element, int maxRad, int friendly){
		int ang = Rand(360);
		if(element==0)
			Game->PlaySound(78);
		else
			Game->PlaySound(79);
		int cooldown[1];
		for(int i=0; i<12; ++i){
			ang = WrapDegrees(ang + 4);
			DrawExplosion(cooldown, element, this->X+8, this->Y+8, Lerp(0, maxRad, i/11), ang, i/11, friendly);
			if(i%4==0&&element!=0){
				eweapon e = CreateEWeaponAt(EW_SCRIPT10, this->X, this->Y);
				e->CollDetection = false;
				e->DrawYOffset = -1000;
				RunEWeaponScript(e, "GeodeCollision", {1, element, Rand(360), Rand(2, 4)});
			}
			Waitframe();
		}
		for(int i=0; i<48; ++i){
			ang = WrapDegrees(ang + 4);
			DrawExplosion(cooldown, element, this->X+8, this->Y+8, Lerp(maxRad, 0, i/48), ang, 1-i/47, friendly);
			if(i%4==0&&i<32&&element!=0){
				eweapon e = CreateEWeaponAt(EW_SCRIPT10, this->X, this->Y);
				e->CollDetection = false;
				e->DrawYOffset = -1000;
				RunEWeaponScript(e, "GeodeCollision", {1, element, Rand(360), Rand(2, 4)});
			}
			Waitframe();
		}
		this->DeadState = 0;
	}
	int GetElementColor(int element, int lightness, int ringOffset){
		int rampNeutral[] = {0x01, 0xB2, 0xB3};
		int rampSolar[] = {0x01, 0x86, 0x87, 0x88, 0x89};
		int rampLunar[] = {0x01, 0x72, 0x73, 0x74, 0x75};
		int rampStellar[] = {0x01, 0x96, 0x97, 0x98, 0x99};
		switch(element){
			case 0: // Neutral
				if(ringOffset==0||ringOffset==2)
					return ElementColorRamp(Choose(0xB2, 0xB3), lightness, rampNeutral);
				else
					return ElementColorRamp(Choose(0x01, 0xB2), lightness, rampNeutral);
				break;
			case 1: // Solar
				if(ringOffset==0)
					return ElementColorRamp(Choose(0x87, 0x88, 0x89), lightness, rampSolar);
				if(ringOffset==1)
					return ElementColorRamp(Choose(0x86, 0x87, 0x88), lightness, rampSolar);
				else
					return ElementColorRamp(Choose(0x01, 0x86, 0x87), lightness, rampSolar);
				break;
			case 2: // Lunar
				if(ringOffset==0)
					return ElementColorRamp(Choose(0x73, 0x74, 0x75), lightness, rampLunar);
				if(ringOffset==1)
					return ElementColorRamp(Choose(0x72, 0x73, 0x74), lightness, rampLunar);
				else
					return ElementColorRamp(Choose(0x01, 0x72, 0x73), lightness, rampLunar);
				break;
			case 3: // Stellar
				if(ringOffset==0)
					return ElementColorRamp(Choose(0x97, 0x98, 0x99), lightness, rampStellar);
				if(ringOffset==1)
					return ElementColorRamp(Choose(0x96, 0x97, 0x98), lightness, rampStellar);
				else
					return ElementColorRamp(Choose(0x01, 0x96, 0x97), lightness, rampStellar);
				break;
			case 4: // Solar + Lunar
				if(ringOffset==0)
					return ElementColorRamp(Choose(0x87, 0x88, 0x89), lightness, rampSolar);
				if(ringOffset==1)
					return ElementColorRamp(Choose(0x72, 0x73, 0x74), lightness, rampLunar);
				else
					return ElementColorRamp(Choose(0x86, 0x87, 0x88), lightness, rampSolar);
				break;
			case 5: // Lunar + Stellar
				if(ringOffset==0)
					return ElementColorRamp(Choose(0x73, 0x74, 0x75), lightness, rampLunar);
				if(ringOffset==1)
					return ElementColorRamp(Choose(0x96, 0x97, 0x98), lightness, rampStellar);
				else
					return ElementColorRamp(Choose(0x72, 0x73, 0x74), lightness, rampLunar);
				break;
			case 6: // Stellar + Solar
				if(ringOffset==0)
					return ElementColorRamp(Choose(0x97, 0x98, 0x99), lightness, rampStellar);
				if(ringOffset==1)
					return ElementColorRamp(Choose(0x86, 0x87, 0x88), lightness, rampSolar);
				else
					return ElementColorRamp(Choose(0x96, 0x97, 0x98), lightness, rampStellar);
				break;
		}
	}
	int ElementColorRamp(int clr, int lightness, int ramp){
		int clrPos;
		int rampSize = SizeOfArray(ramp);
		for(int i=0; i<rampSize; ++i){
			if(clr==ramp[i]){
				clrPos = i;
				break;
			}
		}
		int newpos = Clamp(Floor(Lerp(clrPos, 0, lightness)), 0, rampSize-1);
		return ramp[newpos];
	}
	void DrawExplosion(int cooldown, int element, int x, int y, int rad, int angle, int lightness, bool friendly){
		int clr = GetElementColor(element, lightness, 0);
		Screen->Circle(4, x+Rand(-2, 2), y+Rand(-2, 2), rad+Rand(-4, 4), clr, 1, 0, 0, 0, true, 128);
		
		if(!friendly&&!cooldown[0]&&Link->Action!=LA_GOTHURTLAND&&Distance(Link->X+8, Link->Y+8, x, y)<rad+8){
			Game->PlaySound(SFX_OUCH);
			Link->Action = LA_GOTHURTLAND;
			Link->HitDir = -1;
			if(NumCharsAlive()>1)
				Link->HP = 0;
			else
				Link->HP = 1;
			cooldown[0] = 32;
			int ang = Angle(x, y, Link->X+8, Link->Y+8);
			eweapon e = CreateEWeaponAt(EW_SCRIPT10, 120, 80);
			e->CollDetection = false;
			e->DrawYOffset = -1000;
			RunEWeaponScript(e, "GeodeCollision", {2, ang, 8, 0.5});
		}
		if(cooldown[0])
			--cooldown[0];
		
		clr = GetElementColor(element, lightness, 1);
		int tmpRad = rad;
		DrawStar(4, x, y, angle, 5, tmpRad, tmpRad*0.382, clr, 128);
		clr = GetElementColor(element, lightness, 2);
		tmpRad = rad*0.8;
		DrawStar(4, x, y, -angle+36, 5, tmpRad, tmpRad*0.382, clr, 128);
		clr = GetElementColor(element, lightness, 1);
		tmpRad = rad*0.6;
		DrawStar(4, x, y, angle, 5, tmpRad, tmpRad*0.382, clr, 128);
		tmpRad = rad*0.4;
		DrawStar(4, x, y, -angle+36, 5, tmpRad, tmpRad*0.382, clr, 128);
		clr = GetElementColor(element, lightness, 2);
	}
	void runEnergyTrail(eweapon this, int element, int angle, int step){
		int sp = Choose(1, 2);
		int trailX[16];
		int trailY[16];
		int trailA[16];
		int trailW[16];
		int x = this->X+8;
		int y = this->Y+8;
		int x2,y2;
		int rot = Rand(360);
		int t = Rand(360);
		for(int i=0; i<16; ++i){
			trailY[i] = -1000;
		}
		for(int i=0; i<24+16; ++i){
			int amp = Lerp(4, 24, i/23);
			int sc = Lerp(0, 4, i/23);
			++t;
			t %= 360;
			x += VectorX(step, angle);
			y += VectorY(step, angle);
			if(i>=24)
				y = -1000;
			rot = WrapDegrees(rot+4);
			for(int j=15; j>=0; --j){
				if(j>0){
					x2 = trailX[j];
					y2 = trailY[j];
					trailX[j] = trailX[j-1];
					trailY[j] = trailY[j-1];
					trailA[j] = trailA[j-1];
					trailW[j] = trailW[j-1];
				}
				else{
					x2 = x+VectorX(amp*Sin(t*4), angle+90);
					y2 = y+VectorY(amp*Sin(t*4), angle+90);
					trailX[j] = x2;
					trailY[j] = y2;
					trailA[j] = rot;
					trailW[j] = sc;
				}
				trailA[j] = WrapDegrees(trailA[j]+4);
				if(y2>-1000){
					Screen->Rectangle(2, x2-trailW[j], y2-trailW[j], x2+trailW[j], y2+trailW[j], GetElementColor(element, i/47, sp), 1, x2, y2, trailA[j], false, 128);
				}
			}
			Waitframe();
		}
		this->DeadState = 0;
	}
	void runKnockback(eweapon this, int angle, int intensity, int decay){
		while(intensity>0){
			LinkMovement_Push(VectorX(intensity, angle), VectorY(intensity, angle));
			intensity -= decay;
			Waitframe();
		}
		this->DeadState = 0;
	}
}