///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~~~~~~The Terror of Necromancy Bosses~~~~~~~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

//~~~~~LegionnaireLevel1~~~~~//
@Author("Moosh")
ffc script LegionnaireLevel1 //start
{
	void run(int enemyid)
	{	//start Set Up
	
		if (Screen->State[ST_SECRET])
			Quit();
	
		npc ghost = Ghost_InitAutoGhost(this, enemyid);			// pairing enemy with ffc
		Ghost_SetFlag(GHF_4WAY);								// 4 way movement
		int combo = ghost->Attributes[10];						// finds enemy first combo
		int attackCoolDown = 90 + Rand(30);
		int attack;
		int startHP = Ghost_HP;
		int movementDirection = Choose(90, -90);
		
		int timeToSpawnAnother, enemyCount;
		
		CONFIG SPR_LEGIONNAIRESWORD = 110;
		CONFIG SFX_SHOOTSWORD = 127;
		CONFIG TIL_IMPACTMID = 955;
		CONFIG TIL_IMPACTBIG = 952;
		//end
		
		//start Appear in
		int numEnemies = Screen->NumNPCs();
		
		if (numEnemies == 1)
		{
			Ghost_Y = -32;
			Ghost_X = 120;
			
			for (int i = 0; i < 32; ++i)
			{
				NoAction();
				Ghost_Waitframe(this, ghost);
			}
			
			Ghost_Y = 80;
			Ghost_Z = 176;
			Ghost_Dir = DIR_DOWN;
			
			while (Ghost_Z)
			{
				NoAction();
				Ghost_Z -= 4;
				Ghost_Waitframe(this, ghost);
			}
			
			Screen->Quake = 10;
			Audio->PlaySound(3);
			
			for (int i = 0; i < 32; ++i)
			{
				NoAction();
				Ghost_Waitframe(this, ghost);
			}
		}
		//end Appear in
		
		while(true) //start Activity Cycle
		{
			Ghost_Data = combo + 4;
			Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Hero->X, Hero->Y));
			
			int moveAngle = Angle(Ghost_X, Ghost_Y, Hero->X, Hero->Y) + movementDirection;
			
			Ghost_MoveAtAngle(moveAngle, ghost->Step / 100, 0);
			
			if (timeToSpawnAnother >= 600 && enemyCount < 2) //start Spawning more
			{
				enemyShake(this, ghost, 32, 1);
				Audio->PlaySound(132); // was 64 (general spawn sfx)
				npc n1 = Screen->CreateNPC(220);
				
				int pos, x, y;
			
				for (int i = 0; i < 352; ++i)
				{
					if (i < 176)
						pos = Rand(176);
					else
						pos = i - 176;
						
					x = ComboX(pos);
					y = ComboY(pos);
					
					if (Distance(Hero->X, Hero->Y, x, y) > 48)
						if (Ghost_CanPlace(x, y, 16, 16))
							break;
				}
				
				n1->X = x;
				n1->Y = y;

				++enemyCount;
				timeToSpawnAnother = 0;
			} //end
			
			if (attackCoolDown)
				--attackCoolDown;
			else
			{				
				attackCoolDown = 90 + Rand(30);
				attack = Rand(3);
				
				switch(attack)
				{
					case 0: //start Fire Swordz
						Ghost_Data = combo;
						int swordDamage = 3;
						
						enemyShake(this, ghost, 16, 1);
				
						for (int i = 0; i < 5; ++i)
						{
							eweapon projectile = FireAimedEWeapon(EW_BEAM, Ghost_X, Ghost_Y, 0, 300, swordDamage, SPR_LEGIONNAIRESWORD, SFX_SHOOTSWORD, EWF_UNBLOCKABLE);
							Ghost_Waitframes(this, ghost, 16);
						}
						
						Ghost_Waitframes(this, ghost, 16);
						
						movementDirection = Choose(90, -90);
						
						break; //end
						
					case 1: //start Jump Essplode
						Ghost_Data = combo + 8;
						int distance = Distance(Ghost_X, Ghost_Y, Hero->X, Hero->Y);
						int jumpAngle = Angle(Ghost_X, Ghost_Y, Hero->X, Hero->Y);
						
						int explosionDamage = 4;
						
						Ghost_Jump = FindJumpLength(distance / 2, true);
						
						Audio->PlaySound(SFX_JUMP);
						
						while (Ghost_Jump || Ghost_Z)
						{
							Ghost_MoveAtAngle(jumpAngle, 2, 0);
							Ghost_Waitframe(this, ghost);
						}
						
						Ghost_Data = combo;
						Audio->PlaySound(3);	
						
						for (int i = 0; i < 24; ++i)
						{
							MakeHitbox(Ghost_X - 12, Ghost_Y - 12, 40, 40, explosionDamage);
							
							if (i > 7 && i <= 15)
								Screen->DrawTile(2, Ghost_X - 16, Ghost_Y - 16, TIL_IMPACTBIG, 3, 3, 8, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
							else	
								Screen->DrawTile(2, Ghost_X - 16, Ghost_Y - 16, TIL_IMPACTMID, 3, 3, 8, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
								
							Ghost_Waitframe(this, ghost);
						}
						
						movementDirection = Choose(90, -90);
						
						break; //end
						
					case 2: //start Sprint slash
						enemyShake(this, ghost, 32, 2);
						Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Hero->X, Hero->Y));
						
						int slashDamage = 3;
						
						int moveAngle = Angle(Ghost_X, Ghost_Y, Hero->X, Hero->Y);
						int distance = Distance(Ghost_X, Ghost_Y, Hero->X, Hero->Y);
						
						int dashFrames = Max(6, (distance - 36) / 3);
						
						for (int i = 0; i < dashFrames; ++i)
						{
							Ghost_MoveAtAngle(moveAngle, 3, 0);
							
							if (i > dashFrames / 2)
								sword1x1(Ghost_X, Ghost_Y, moveAngle - 90, (i - dashFrames / 2) / (dashFrames / 2) * 16, combo + 12, 10, slashDamage);
								
							Ghost_Waitframe(this, ghost);
						}
						
						Audio->PlaySound(SFX_SWORD);
						
						for (int i = 0; i <= 12; ++i)
						{
							Ghost_MoveAtAngle(moveAngle, 3, 0);
							sword1x1(Ghost_X, Ghost_Y, moveAngle - 90 + 15 * i, 16, combo + 12, 10, slashDamage);
							Ghost_Waitframe(this, ghost);
						}
						
						movementDirection = Choose(90, -90);
						
						break; //end
					
				}
			}
			
			if (Ghost_HP <= startHP * 0.30)
				timeToSpawnAnother++;
			
			Ghost_Waitframe(this, ghost);
		} //end
	}
} //end

//~~~~~Demonwall~~~~~//
@Author("Moosh")
npc script Demonwall //start
{
	void run()
	{

		// for (int i = 0; i < roomsize since the wall can squish link for instakill; ++i)
		// {
			// move the guy perhaps 1/8th of a tile every frame 
			// if (demonwall->HP at 70%)
				// move demonwall back 3 tiles if it can, otherwise just back the the left wall
				
			// do some attacks
			
		// }

	}
} //end




