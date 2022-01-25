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

	int MSG_BEATEN = 23;
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
				
				dist = Sin(timer) * size;
				
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

namespace Enemy::Manhandala //start
{
	bool firstRun = true;

	enum Attacks //start
	{
		GROUND_POUND,
		OIL_CANNON,
		OIL_SPRAY,
		FLAME_TOSS,
		FLAME_CANNON
	}; //end
	
	npc script Manhandala //start
	{
		CONFIG DEFAULT_COMBO = 10272;
		CONFIG JUMP_PREP_COMBO = 10273;
		CONFIG JUMPING_COMBO = 10274;
		CONFIG JUMP_LANDING_COMBO = 10275;
		
		CONFIG TIME_BETWEEN_ATTACKS = 180;
		
		void run(int hurtCSet, int minion)
		{
			setupNPC(this);
			
			untyped data[SZ_DATA];
			int oCSet = this->CSet;
			int timeSinceLastAttack = 180;
			
			setNPCToCombo(data, this, DEFAULT_COMBO);
			
			npc heads[4];
			
			int ews_stopper = Game->GetEWeaponScript("StopperKiller");
			
			bitmap effectBitmap = create(256, 168);
			this->Immortal = true;
			
			const int maxHp = this->HP;
			
			for (int headIndex = 0; headIndex < 4; ++headIndex)
			{
				heads[headIndex] = Screen->CreateNPC(minion);
				heads[headIndex]->InitD[0] = this;
				heads[headIndex]->Dir = headIndex + 4;
			}
			
			// Intro Sequence
			if (firstRun)
			{
				NoAction();
				commenceIntroSequence(this, heads);
				Screen->Message(402);
				firstRun = false;
			}
			// Audio->PlayEnhancedMusic("The Binding of Isaac - Divine Combat.ogg", 0); //remove if intro is on
			
			NoAction();
				
			while(this->HP > 0)
			{
				int previousAttack;
				
				int angle;
				int headOpen = 20;
				int headOpenIndex;
				
				while(true)
				{
					bool dead = true;
					
					for (int headIndex = 0; headIndex < 4; ++headIndex)
					{
						if (heads[headIndex] && heads[headIndex]->isValid() && heads[headIndex]->HP > 0)
							dead = false;
						else
							heads[headIndex] = NULL;
					}
					
					if (dead)
						break;
					
					for (int i = 0; i < 20; ++i)
						this->Defense[i] = NPCDT_IGNORE;
					
					for (int i = 0; i < 4; ++i)
						if (heads[i])
							heads[i]->CollDetection = true;
					
						
					if (headOpen == 20)
					{
						headOpenIndex = RandGen->Rand(3);
						
						until (heads[headOpenIndex])
							headOpenIndex = RandGen->Rand(3);
					
						if (heads[headOpenIndex])
							heads[headOpenIndex]->OriginalTile -= 1;
					}
					
					if (headOpen == 0)
					{
						if (heads[headOpenIndex])
							heads[headOpenIndex]->OriginalTile += 1;
						
						headOpenIndex = RandGen->Rand(3);
						
						until (heads[headOpenIndex])
							headOpenIndex = RandGen->Rand(3);
							
						if (heads[headOpenIndex])
							heads[headOpenIndex]->OriginalTile -= 1;
							
						headOpen = 20;
					}
						
					angle = RadtoDeg(TurnTowards(CenterX(this), CenterY(this), CenterLinkX(), CenterLinkY(), 0, 1));
					
					// Normal moving towards Link
					unless (data[DATA_CLK] % 3)
						this->MoveAtAngle(angle, 1, SPW_NONE);
					
					bool justSprayed = false;
					
					// Whether he can attack again
					if (TIME_BETWEEN_ATTACKS <= timeSinceLastAttack)
					{
						// int rand = RandGen->Rand(120, 180);
						
						// do
						// {
							// --rand;
							// custom_waitframe(this, data);
						// } until(rand);
						
						// Attack choice
						if (heads[headOpenIndex])
							heads[headOpenIndex]->OriginalTile += 1;
						
						headOpen = 21;
						
						oilSpray(data, this, isDifficultyChange(this, maxHp));
						
						justSprayed = true;
						
						timeSinceLastAttack = 0;
					}
					
					// If Link gets too close he groundPounds
					if (Distance(CenterX(this), CenterY(this), CenterLinkX(), CenterLinkY()) < 32)
					{
						timeSinceLastAttack += 60;
					
						if (heads[headOpenIndex] && timeSinceLastAttack != 0 && !justSprayed)
							heads[headOpenIndex]->OriginalTile += 1;
							
						headOpen = 21;
						
						groundPound(this, data);
						custom_waitframe(this, data, 45);
					}	
					
					// Drop fire
					if (headOpen == 10) //start
					{
						if (heads[headOpenIndex] && heads[headOpenIndex]->isValid())
						{
							eweapon flame = CreateEWeaponAt(EW_SCRIPT1, heads[headOpenIndex]->X, heads[headOpenIndex]->Y + 8);
							flame->Dir = heads[headOpenIndex]->Dir;
							flame->Step = RandGen->Rand(125, 175);
							flame->Angular = true;
							flame->Angle = DirRad(flame->Dir);
							flame->Script = ews_stopper;
							flame->Z = heads[headOpenIndex]->Z + 8;
							flame->InitD[0] = RandGen->Rand(8, 15);
							flame->InitD[1] = RandGen->Rand(60, 180);
							flame->Gravity = true;
							flame->Damage = 2;
							flame->UseSprite(115);						
						}
						
					} //end
					
					++timeSinceLastAttack;
					
					--headOpen;
					
					custom_waitframe(this, data);
				}
				
				for (int i = 0; i < 20; ++i)
					(this->Defense[i] == NPCD_FIRE) ? (this->Defense[i] = NPCDT_IGNORE) : (this->Defense[i] = NPCDT_NONE);
				
				int originalCSet = this->CSet;
				this->CSet = hurtCSet;
				// this->CollDetection = true;
				
				for(int i = 0; i < 10; ++i)
					custom_waitframe(this, data);
				
				// Fleeing from Link
				for (int i = 0; i < (5 * 60); ++i) //start
				{
					if (this->HP <= 0)
						deathAnimation(this, data);
					
					angle = RadtoDeg(TurnTowards(CenterX(this), CenterY(this), CenterLinkX(), CenterLinkY(), 0, 1));
					this->MoveAtAngle(180 + angle, 1, SPW_NONE);
					
					custom_waitframe(this, data);
				} //end
				
				Waitframes(60);
				
				if (this->HP <= 0);
					deathAnimation(this, data);
				
				int centerX = 256 / 2, centerY = 176 / 2 - 16;
				
				// Flees into the center pool to regen
				while(Distance(this->X + this->HitXOffset + this->HitWidth / 2, this->Y + this->HitYOffset + this->HitHeight / 2, centerX, centerY) > 3)
				{
					while (MoveTowardsPoint(this, centerX, centerY, 2, SPW_FLOATER, true))
						custom_waitframe(this, data, 2);
				}
				
				// this->CollDetection = false;
				for (int i = 0; i < 20; ++i)
					this->Defense[i] == NPCDT_IGNORE;
					
				data[DATA_INVIS] = true;
				
				// Falling into the pool
				for (int i = 0; i < 32; ++i) //start
				{
					for(int j = 0; j < 4; ++j)
					{
						effectBitmap->Clear(0);
						effectBitmap->DrawTile(4, this->X, this->Y + i, this->ScriptTile, 2, 2, this->CSet, -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
						effectBitmap->Rectangle(4, this->X - 8, 167, this->X + 39, this->Y + 31, 0, -1, 0, 0, 0, true, OP_OPAQUE);
						effectBitmap->Blit(4, RT_SCREEN, 0, 0, 256, 168, 0, 0, 256, 168, 0, 0, 0, BITDX_NORMAL, 0, true);
						Screen->DrawCombo(4, this->X, this->Y + 22, 6725, 2, 1, 2, -1, -1, 0, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
						
						custom_waitframe(this, data);
					}
				} //end
				
				// Reforming the heads
				for (int headIndex = 0; headIndex < 4; ++headIndex) //start
				{
					heads[headIndex] = Screen->CreateNPC(minion);
					heads[headIndex]->InitD[0] = this;
					heads[headIndex]->Dir = headIndex + 4;
					heads[headIndex]->DrawXOffset = 1000;
					heads[headIndex]->CollDetection = false;
				} //end
				
				this->CSet = originalCSet;
				
				// Rising out from pool
				for (int i = 31; i >= 0; --i) //start
				{				
					for(int j = 0; j < 4; ++j)
					{
						effectBitmap->Clear(0);
						effectBitmap->DrawTile(4, this->X, this->Y + i, this->ScriptTile, 2, 2, this->CSet, -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
						
						for (int headIndex = 0; headIndex < 4; ++headIndex)
						{
							effectBitmap->DrawTile(4, heads[headIndex]->X, heads[headIndex]->Y + i, heads[headIndex]->ScriptTile, 1, 1, heads[headIndex]->CSet, -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
						}
						
						effectBitmap->Rectangle(4, this->X - 8, 167, this->X + 39, this->Y + 31, 0, -1, 0, 0, 0, true, OP_OPAQUE);
						effectBitmap->Blit(4, RT_SCREEN, 0, 0, 256, 168, 0, 0, 256, 168, 0, 0, 0, BITDX_NORMAL, 0, true);
						Screen->DrawCombo(4, this->X, this->Y + 22, 6725, 2, 1, 2, -1, -1, 0, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
						
						custom_waitframe(this, data);
					}
				} //end
				
				data[DATA_INVIS] = false;
				
				
				for (int headIndex = 0; headIndex < 4; ++headIndex)
					heads[headIndex]->DrawXOffset = 0;
				// this->CollDetection = true;
			}
			
			effectBitmap->Free();
			
			this->CollDetection = false;
			deathAnimation(this, data);
		}
		
		void groundPound(npc this, int data) //start
		{
			for (int i = 0; i < 20; ++i)
			{
				this->ScriptTile = this->OriginalTile + 40;
				custom_waitframe(this, data);
			}
		
			const int JUMP_SPEED = 2;
			int lx = CenterLinkX(), ly = CenterLinkY();
			
			this->Jump = 2;
			this->Z = 12.5;
			
			this->ScriptTile = this->OriginalTile + 42;
			
			while(MoveTowardsPoint(this, lx, ly, JUMP_SPEED, SPW_NONE, true))
				Waitframe();
			
			while(this->Z)
				Waitframe();
			
			Screen->Quake = 30;
			
			for (int i = 0; i < 20; ++i)
			{
				this->ScriptTile = this->OriginalTile + 40;
				custom_waitframe(this, data);
			}
			
			this->ScriptTile = this->OriginalTile;
		} //end
		
		void commenceIntroSequence(npc this, npc heads) //start
		{
			bitmap introSequenceBitmap = create(512, 168);
			int panPosition = 0;
			NoAction();
			
			this->X = 432;
			this->Y = 64;
			
			// Silent Pause
			Audio->PlayEnhancedMusic(null, 0);
			introSequenceBitmap->Clear(0);
			
			// Pause
			for (int i = 0; i < 60; ++i)
			{
				NoAction();
				introSequenceBitmap->DrawLayer(7, 37, 43, 3, 0, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 43, 0, 0, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 43, 1, 0, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 43, 2, 0, 0, 0, OP_TRANS);
				introSequenceBitmap->DrawLayer(7, 37, 43, 4, 0, 0, 0, OP_OPAQUE);
				introSequenceBitmap->FastCombo(7, 112, 0, 4632, 2, OP_OPAQUE);
				introSequenceBitmap->FastCombo(7, 128, 0, 4632, 2, OP_OPAQUE);
				introSequenceBitmap->FastCombo(7, 120, 120, 6731, 0, OP_OPAQUE);
			
				introSequenceBitmap->Blit(7, RT_SCREEN, 0, 0, 512, 168, 0, 0, 512, 168, 0, 0, 0, BITDX_NORMAL, 0, true);
				
				Waitframe();
			}
			
			// Start Panning
			until (panPosition == 40)
			{
				NoAction();
				panPosition += 4;
				
				introSequenceBitmap->DrawLayer(7, 37, 43, 3, 0, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 43, 0, 0, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 43, 1, 0, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 43, 2, 0, 0, 0, OP_TRANS);
				introSequenceBitmap->DrawLayer(7, 37, 43, 4, 0, 0, 0, OP_OPAQUE);
				introSequenceBitmap->FastCombo(7, 112, 0, 4632, 2, OP_OPAQUE);
				introSequenceBitmap->FastCombo(7, 128, 0, 4632, 2, OP_OPAQUE);
				introSequenceBitmap->FastCombo(7, 120, 120, 6731, 0, OP_OPAQUE);
				
				introSequenceBitmap->DrawLayer(7, 37, 44, 3, 256, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 44, 0, 256, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 44, 1, 256, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 44, 2, 256, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 44, 4, 256, 0, 0, OP_OPAQUE);
			
				introSequenceBitmap->Blit(7, RT_SCREEN, panPosition, 0, 512, 168, 0, 0, 512, 168, 0, 0, 0, BITDX_NORMAL, 0, true);
				
				Waitframe();
			}
			
			// Panning right
			until (panPosition == 100)
			{
				NoAction();
				panPosition += 6;
				
				introSequenceBitmap->DrawLayer(7, 37, 43, 3, 0, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 43, 0, 0, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 43, 1, 0, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 43, 2, 0, 0, 0, OP_TRANS);
				introSequenceBitmap->DrawLayer(7, 37, 43, 4, 0, 0, 0, OP_OPAQUE);
				introSequenceBitmap->FastCombo(7, 112, 0, 4632, 2, OP_OPAQUE);
				introSequenceBitmap->FastCombo(7, 128, 0, 4632, 2, OP_OPAQUE);
				introSequenceBitmap->FastCombo(7, 120, 120, 6731, 0, OP_OPAQUE);
				
				introSequenceBitmap->DrawLayer(7, 37, 44, 3, 256, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 44, 0, 256, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 44, 1, 256, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 44, 2, 256, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 44, 4, 256, 0, 0, OP_OPAQUE);
			
				introSequenceBitmap->Blit(7, RT_SCREEN, panPosition, 0, 512, 168, 0, 0, 512, 168, 0, 0, 0, BITDX_NORMAL, 0, true);
				
				Waitframe();
			}
			
			// Panning right
			until (panPosition == 180)
			{
				NoAction();
				panPosition += 8;
				
				introSequenceBitmap->DrawLayer(7, 37, 43, 3, 0, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 43, 0, 0, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 43, 1, 0, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 43, 2, 0, 0, 0, OP_TRANS);
				introSequenceBitmap->DrawLayer(7, 37, 43, 4, 0, 0, 0, OP_OPAQUE);
				introSequenceBitmap->FastCombo(7, 112, 0, 4632, 2, OP_OPAQUE);
				introSequenceBitmap->FastCombo(7, 128, 0, 4632, 2, OP_OPAQUE);
				introSequenceBitmap->FastCombo(7, 120, 120, 6731, 0, OP_OPAQUE);
				
				introSequenceBitmap->DrawLayer(7, 37, 44, 3, 256, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 44, 0, 256, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 44, 1, 256, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 44, 2, 256, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 44, 4, 256, 0, 0, OP_OPAQUE);
				
				introSequenceBitmap->DrawTile(7, this->X, this->Y, this->ScriptTile, 2, 2, this->CSet, -1, -1, 0, 0, 0, FLIP_NONE, false, OP_OPAQUE);
				
				for (int headIndex = 0; headIndex < 4; ++headIndex)
				{
					introSequenceBitmap->DrawTile(7, heads[headIndex]->X, heads[headIndex]->Y, heads[headIndex]->ScriptTile, 1, 1, heads[headIndex]->CSet, -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
				}
				
				introSequenceBitmap->Blit(7, RT_SCREEN, panPosition, 0, 512, 168, 0, 0, 512, 168, 0, 0, 0, BITDX_NORMAL, 0, true);
				
				Waitframe();
			}
			
			// Panning right
			until (panPosition == 230)
			{
				NoAction();
				panPosition += 5;
				
				introSequenceBitmap->DrawLayer(7, 37, 43, 3, 0, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 43, 0, 0, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 43, 1, 0, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 43, 2, 0, 0, 0, OP_TRANS);
				introSequenceBitmap->DrawLayer(7, 37, 43, 4, 0, 0, 0, OP_OPAQUE);
				introSequenceBitmap->FastCombo(7, 112, 0, 4632, 2, OP_OPAQUE);
				introSequenceBitmap->FastCombo(7, 128, 0, 4632, 2, OP_OPAQUE);
				introSequenceBitmap->FastCombo(7, 120, 120, 6731, 0, OP_OPAQUE);
				
				introSequenceBitmap->DrawLayer(7, 37, 44, 3, 256, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 44, 0, 256, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 44, 1, 256, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 44, 2, 256, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 44, 4, 256, 0, 0, OP_OPAQUE);
			
				introSequenceBitmap->DrawTile(7, this->X, this->Y, this->ScriptTile, 2, 2, this->CSet, -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
				
				for (int headIndex = 0; headIndex < 4; ++headIndex)
				{
					introSequenceBitmap->DrawTile(7, heads[headIndex]->X, heads[headIndex]->Y, heads[headIndex]->ScriptTile, 1, 1, heads[headIndex]->CSet, -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
				}
			
				introSequenceBitmap->Blit(7, RT_SCREEN, panPosition, 0, 512, 168, 0, 0, 512, 168, 0, 0, 0, BITDX_NORMAL, 0, true);
				
				Waitframe();
			}
			
			// Panning right
			until (panPosition == 256)
			{
				NoAction();
				panPosition += 1;
				
				introSequenceBitmap->DrawLayer(7, 37, 43, 3, 0, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 43, 0, 0, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 43, 1, 0, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 43, 2, 0, 0, 0, OP_TRANS);
				introSequenceBitmap->DrawLayer(7, 37, 43, 4, 0, 0, 0, OP_OPAQUE);
				introSequenceBitmap->FastCombo(7, 112, 0, 4632, 2, OP_OPAQUE);
				introSequenceBitmap->FastCombo(7, 128, 0, 4632, 2, OP_OPAQUE);
				introSequenceBitmap->FastCombo(7, 120, 120, 6731, 0, OP_OPAQUE);
				
				introSequenceBitmap->DrawLayer(7, 37, 44, 3, 256, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 44, 0, 256, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 44, 1, 256, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 44, 2, 256, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 44, 4, 256, 0, 0, OP_OPAQUE);
			
				introSequenceBitmap->DrawTile(7, this->X, this->Y, this->ScriptTile, 2, 2, this->CSet, -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
				
				for (int headIndex = 0; headIndex < 4; ++headIndex)
					introSequenceBitmap->DrawTile(7, heads[headIndex]->X, heads[headIndex]->Y, heads[headIndex]->ScriptTile, 1, 1, heads[headIndex]->CSet, -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
			
				introSequenceBitmap->Blit(7, RT_SCREEN, panPosition, 0, 512, 168, 0, 0, 512, 168, 0, 0, 0, BITDX_NORMAL, 0, true);
				
				Waitframe();
			}
			
			// Pausing on him
			for (int i = 0; i < 60; ++i)
			{
				NoAction();
				introSequenceBitmap->DrawLayer(7, 37, 44, 3, 256, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 44, 0, 256, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 44, 1, 256, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 44, 2, 256, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 44, 4, 256, 0, 0, OP_OPAQUE);
			
				introSequenceBitmap->DrawTile(7, this->X, this->Y, this->ScriptTile, 2, 2, this->CSet, -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
				
				for (int headIndex = 0; headIndex < 4; ++headIndex)
					introSequenceBitmap->DrawTile(7, heads[headIndex]->X, heads[headIndex]->Y, heads[headIndex]->ScriptTile, 1, 1, heads[headIndex]->CSet, -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
			
				introSequenceBitmap->Blit(7, RT_SCREEN, panPosition, 0, 512, 168, 0, 0, 512, 168, 0, 0, 0, BITDX_NORMAL, 0, true);
				
				Waitframe();
			}
			
			int timer = 0;
			int yModifier = 0, xModifier = -1;
			
			// Panning back into boss room
			until (panPosition == 0)
			{
				NoAction();
				--panPosition;
				++timer;
				
				if(timer < 24)
				{
					unless (timer % 3)
						yModifier = -3.5;
					else
						yModifier = 0;
				}
				else if (timer < 112)
					yModifier = 0;
				else if (timer < 148)
				{
					unless (timer % 3)
						yModifier = 2;
					else
						yModifier = 0;
				}
				else if (timer < 232)
					yModifier = 0;
				
				this->X += xModifier;
				this->Y += yModifier;
				
				introSequenceBitmap->DrawLayer(7, 37, 43, 3, 0, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 43, 0, 0, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 43, 1, 0, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 43, 2, 0, 0, 0, OP_TRANS);
				introSequenceBitmap->DrawLayer(7, 37, 43, 4, 0, 0, 0, OP_OPAQUE);
				introSequenceBitmap->FastCombo(7, 112, 0, 4632, 2, OP_OPAQUE);
				introSequenceBitmap->FastCombo(7, 128, 0, 4632, 2, OP_OPAQUE);
				introSequenceBitmap->FastCombo(7, 120, 120, 6731, 0, OP_OPAQUE);
				
				introSequenceBitmap->DrawLayer(7, 37, 44, 3, 256, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 44, 0, 256, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 44, 1, 256, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 44, 2, 256, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 44, 4, 256, 0, 0, OP_OPAQUE);
			
				introSequenceBitmap->DrawTile(7, this->X, this->Y, this->ScriptTile, 2, 2, this->CSet, -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
				
				for (int headIndex = 0; headIndex < 4; ++headIndex)
				{
					introSequenceBitmap->DrawTile(7, heads[headIndex]->X, heads[headIndex]->Y, heads[headIndex]->ScriptTile, 1, 1, heads[headIndex]->CSet, -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
				}
			
				introSequenceBitmap->Blit(7, RT_SCREEN, panPosition, 0, 512, 168, 0, 0, 512, 168, 0, 0, 0, BITDX_NORMAL, 0, true);
				
				Waitframe();
			}
			
			// Wait and Roars
			for (int i = 0; i < 60; ++i)
			{
				NoAction();
				introSequenceBitmap->DrawLayer(7, 37, 43, 3, 0, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 43, 0, 0, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 43, 1, 0, 0, 0, OP_OPAQUE);
				introSequenceBitmap->DrawLayer(7, 37, 43, 2, 0, 0, 0, OP_TRANS);
				introSequenceBitmap->DrawLayer(7, 37, 43, 4, 0, 0, 0, OP_OPAQUE);
				introSequenceBitmap->FastCombo(7, 112, 0, 4632, 2, OP_OPAQUE);
				introSequenceBitmap->FastCombo(7, 128, 0, 4632, 2, OP_OPAQUE);
				introSequenceBitmap->FastCombo(7, 120, 120, 6731, 0, OP_OPAQUE);
			
				introSequenceBitmap->DrawTile(7, this->X, this->Y, this->ScriptTile, 2, 2, this->CSet, -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
				
				for (int headIndex = 0; headIndex < 4; ++headIndex)
					introSequenceBitmap->DrawTile(7, heads[headIndex]->X, heads[headIndex]->Y, heads[headIndex]->ScriptTile, 1, 1, heads[headIndex]->CSet, -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
			
				introSequenceBitmap->Blit(7, RT_SCREEN, panPosition, 0, 512, 168, 0, 0, 512, 168, 0, 0, 0, BITDX_NORMAL, 0, true);
				
				Waitframe();
			}
			
			introSequenceBitmap->Free();
			Audio->PlayEnhancedMusic("The Binding of Isaac - Divine Combat.ogg", 0);
		}
	} //end
	
	npc script ManhandalaHead //start
	{
		void run(npc parent)
		{
			unless(parent)
				this->Remove();
			
			while(true)
			{
				this->X = (parent->X + (parent->HitWidth / 2) + parent->HitXOffset) + getDrawLocationX(this);
				this->Y = (parent->Y + (parent->HitHeight / 2) + parent->HitYOffset) + getDrawLocationY(this);
				this->Z = parent->Z;

				this->ScriptTile = this->OriginalTile + this->Dir * 20 + 1;
				Waitframe();
			}
		}
		
		int getDrawLocationX(npc parent) //start
		{
			if (parent->Dir & 100b)
			{
				if (parent->Dir & 1b)
					return 4;
				else
					return -20;
			}
			else 
			{
				if (parent->Dir == DIR_RIGHT)
					return 8;
				else
				{
					if (parent->Dir == DIR_LEFT)
						return -24;
					else
						return 0;
				}
			}			
		} //end
		
		int getDrawLocationY(npc parent) //start
		{
			if (parent->Dir & 100b)
			{
				if (parent->Dir & 10b)
					return -6;
				else
					return -23;
			}
			else
			{
				if (parent->Dir == DIR_DOWN)
					return -2;
				else if(parent->Dir == DIR_UP)
					return -27;
				else
					return -10;
			}		
		} //end
		
	} //end

} //end

namespace Enemy //start
{	
	void oilSpray(int data, npc this, bool isDifficultyChange) //start
	{
		int attackingCounter = 30;
		bool modTile = false;
		
		this->ScriptTile = this->OriginalTile;
		
		Waitframes(60);
		
		while (--attackingCounter)
		{
			if (this->HP <= 0)
				deathAnimation(this, data);
				
			modTile = attackingCounter % 2;
			
			if (modTile)
				this->ScriptTile = this->OriginalTile + 40;
			else
				this->ScriptTile = this->OriginalTile;
		
			eweapon oilBlob = FireAimedEWeapon(194, CenterX(this) - 8, CenterY(this) - 8, 0, 255, 1, 117, -1, EWF_UNBLOCKABLE | EWF_ROTATE);
			Audio->PlaySound(138);
			RunEWeaponScript(oilBlob, Game->GetEWeaponScript("ArcingWeapon"), {-1, 0, AE_OIL_BLOB});
			custom_waitframe(this, data, 5);
		}
		
		Waitframes(60);
	
	} //end
		
	enum dataInd //start
	{
		DATA_AFRAMES,
		DATA_CLK,
		DATA_FRAME,
		DATA_INVIS,
		SZ_DATA
	}; //end
	
	void setNPCToCombo(int data, npc n, int cid) //start
	{
		setNPCToCombo(data, n, Game->LoadComboData(cid));
	} //end
	
	void setNPCToCombo(int data, npc n, combodata c) //start
	{
		data[DATA_AFRAMES] = c->Frames;
		n->OriginalTile = c->OriginalTile;
		n->ASpeed = c->ASpeed;
		data[DATA_FRAME] = 0;
	} //end
	
	void setupNPC(npc n) //start
	{
		n->Animation = false;
		
		unless(n->TileWidth)
			n->TileWidth = 1;
		unless(n->TileHeight)
			n->TileHeight = 1;
		unless(n->HitWidth)
			n->HitWidth = 16;
		unless(n->HitHeight)
			n->HitHeight = 16;
	} //end
	
	void deathAnimation(npc n, untyped data) //start
	{
	
	} //end
	
	void custom_waitframe(npc n, int data) //start
	{
		if (n->HP <= 0)
			deathAnimation(n, data);
	
		if(++data[DATA_CLK] >= n->ASpeed)
		{
			data[DATA_CLK] = 0;
			
			if(++data[DATA_FRAME] >= data[DATA_AFRAMES])
				data[DATA_FRAME] = 0;
				
			n->ScriptTile = n->OriginalTile + (n->TileWidth * data[DATA_FRAME]);
			int rowdiff = Div(n->ScriptTile-n->OriginalTile, 20);
			
			if(rowdiff)
				n->ScriptTile += (rowdiff * (n->TileHeight - 1));
		}
		
		int tempTile = n->ScriptTile;
		
		if (data[DATA_INVIS])
			n->ScriptTile = TILE_INVIS;
		
		Waitframe();
		
		n->ScriptTile = tempTile;
	} //end
	
	void custom_waitframe(npc n, int data, int frames) //start
	{
		while(frames--)
			custom_waitframe(n, data);
	} //end

	void doWalk(npc n, int rand, int homing, int step) //start
	{
		//rand = n in 1000 to do something
		//homing = n in 1000 to do something
		
		const int ONE_IN_N = 1000;
		
		if (rand >= RandGen->Rand(ONE_IN_N - 1))
		{
			int attemptCounter  = 0;
			
			do
			{
				n->Dir = RandGen->Rand(3);
			} until(n->CanMove(n->Dir, 1, 0) || ++attemptCounter > 500);
		}
		else if (homing >= RandGen->Rand(ONE_IN_N - 1))
			n->Dir = RadianAngleDir4(TurnTowards(n->X, n->Y, Hero->X, Hero->Y, 0, 1));
		
		unless (n->Move(n->Dir, step / 100, SPW_NONE))
		{
			int attemptCounter  = 0;
			
			do
			{
				n->Dir = RandGen->Rand(3);
			} until(n->CanMove(n->Dir, 1, 0) || ++attemptCounter > 500);
			
		}
	} //end

	bool MoveTowardsPoint(npc n, int x, int y, int pxamnt, int special, bool center) //start
	{
		int nx = n->X + n->HitXOffset + (center ? n->HitWidth/2 : 0);
		int ny = n->Y + n->HitYOffset + (center ? n->HitHeight/2 : 0);
		int dist = Distance(nx, ny, x, y);
		
		if(dist < 0.0010) 
			return false;
		
		return n->MoveAtAngle(RadtoDeg(TurnTowards(nx, ny, x, y, 0, 1)), Min(pxamnt, dist), special);
	} //end

	bool isDifficultyChange(npc n, int maxHp) //start
	{
		return n->HP < maxHp * .33;
	} //end
} //end


















