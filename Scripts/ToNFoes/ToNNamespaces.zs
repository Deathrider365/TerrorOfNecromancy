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































