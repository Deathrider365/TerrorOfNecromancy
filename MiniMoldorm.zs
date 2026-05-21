namespace MiniMoldorm
{
	const int C_ENEMYFLICKERCOLOR = 0x00;

	class MiniMoldormData
	{
		npc Owner;
		int TrailX[32];
		int TrailY[32];
		int TempStep;
		int Angle;
		bitmap FlickerBitmap;
		int KnockbackAngle;
		int KnockbackFrames;

		MiniMoldormData(npc owner)
		{
			Owner = owner;
			for(int i=0; i<32; ++i)
			{
				TrailX[i] = Owner->X;
				TrailY[i] = Owner->Y;
			}
			FlickerBitmap = Game->CreateBitmap(48, 16);
			FlickerBitmap->Own();
		}
	}

	npc script Moldorm
	{
		enum VarsIndices
		{
			V_TRAILX,
			V_TRAILY,
			V_TEMPSTEP,
			V_ANGLE,
			V_FLICKERBITMAP,
			V_KNOCKBACKANGLE,
			V_KNOCKBACKFRAMES,
			
			V_MAX
		};
		
		using namespace NPCAnim;
		void run(int turnSpeed, int turnTime1, int turnTime2, bool noStraight)
		{
			if(!turnSpeed)
				turnSpeed = 2;
			if(!turnTime1)
				turnTime1 = 64;
			if(!turnTime2)
				turnTime2 = 32;
				
			Waitspawn(this);
			
			AnimHandler aptr = new AnimHandler(this);
			aptr->AddAnim(0, 0, 1, 1, ADF_8WAY);

			MiniMoldormData mmd = new MiniMoldormData(this);
			
			this->Immortal = true;
			this->Extend = 3;
			
			int moveFrames = turnTime1 + turnTime2*Rand(3);
			int turn = Choose(-1, 1);
			int angle = Rand(360);
			while(true)
			{
				if(moveFrames>0)
					--moveFrames;
				else
				{
					moveFrames = turnTime1 + turnTime2*Rand(3);
					if(noStraight)
						turn = Choose(-1, 1);
					else
						turn = Choose(-1, 0, 1);
				}
				angle = WrapDegrees(angle+turn*turnSpeed);
				MoveAtAngle(mmd, angle, this->Step/100);
				int vX = VectorX(1, angle);
				int vY = VectorY(1, angle);
				bool turned;
				if((vY<0&&!this->CanMove(DIR_UP, 1)) || (vY>0&&!this->CanMove(DIR_DOWN, 1)))
				{
					vY = -vY;
					turned = true;
				}
				if((vX<0&&!this->CanMove(DIR_LEFT, 1)) || (vX>0&&!this->CanMove(DIR_RIGHT, 1)))
				{
					vX = -vX;
					turned = true;
				}
				if(turned)
					angle = Angle(0, 0, vX, vY);
				this->Dir = AngleDir8(WrapDegrees(angle));
				MoldormWaitframe(mmd);
			}
		}
		void MoveAtAngle(MiniMoldormData mmd, int angle, int step)
		{
			npc this = mmd->Owner;
			
			mmd->TempStep += step;
			while(mmd->TempStep>=1)
			{
				--mmd->TempStep;
				if(Round(this->X)!=mmd->TrailX[0]||Round(this->Y)!=mmd->TrailY[0])
				{
					PushTrail(mmd);
				}
				this->MoveAtAngle(angle, 1);
			}
		}
		void PushTrail(MiniMoldormData mmd)
		{
			npc this = mmd->Owner;
			
			for(int i=31; i>=0; --i)
			{
				if(i==0)
				{
					mmd->TrailX[i] = Round(this->X);
					mmd->TrailY[i] = Round(this->Y);
				}
				else
				{
					mmd->TrailX[i] = mmd->TrailX[i-1];
					mmd->TrailY[i] = mmd->TrailY[i-1];
				}
			}
		}
		void Draw(MiniMoldormData mmd)
		{
			npc this = mmd->Owner;
			AnimHandler aptr = GetAnimHandler(this);
			
			this->DrawXOffset = 1000;
			
			bitmap b = mmd->FlickerBitmap;
			int layer = SPLAYER_NPC_DRAW;
			
			if(Link->HP>0)
			{
				b->Clear(0);
				b->FastTile(0, 0, 0, aptr->OriginalTile+9, this->FlashingCSet, OP_OPAQUE);
				b->FastTile(0, 16, 0, aptr->OriginalTile+8, this->FlashingCSet, OP_OPAQUE);
				b->FastTile(0, 32, 0, this->Tile, this->FlashingCSet, OP_OPAQUE);
				if(this->isFlickerFrame())
				{
					if(C_ENEMYFLICKERCOLOR)
						b->ReplaceColors(0, C_ENEMYFLICKERCOLOR, 0x01, 0xFF);
					else
						return;
				}
				
				int x = mmd->TrailX[12];
				int y = mmd->TrailY[12];
				b->Blit(layer, RT_SCREEN, 0, 0, 16, 16, x, y+this->DrawYOffset-this->Z-this->FakeZ, 16, 16, 0, 0, 0, BITDX_NORMAL, 0, true);
				
				x = mmd->TrailX[6];
				y = mmd->TrailY[6];
				b->Blit(layer, RT_SCREEN, 16, 0, 16, 16, x, y+this->DrawYOffset-this->Z-this->FakeZ, 16, 16, 0, 0, 0, BITDX_NORMAL, 0, true);
				
				x = this->X;
				y = this->Y;
				b->Blit(layer, RT_SCREEN, 32, 0, 16, 16, x, y+this->DrawYOffset-this->Z-this->FakeZ, 16, 16, 0, 0, 0, BITDX_NORMAL, 0, true);
			}
		}
		void Knockback(MiniMoldormData mmd)
		{
			npc this = mmd->Owner;
			AnimHandler aptr = GetAnimHandler(this);
			
			if(this->HitBy[HIT_BY_LWEAPON])
			{
				lweapon l = Screen->LoadLWeapon(this->HitBy[HIT_BY_LWEAPON]);
				mmd->KnockbackAngle = DirAngle(l->Dir);
				mmd->KnockbackFrames = 8;
			}
			
			if(mmd->KnockbackFrames)
			{
				--mmd->KnockbackFrames;
				this->MoveFlags[NPCMV_CAN_PIT_WALK] = true;
				this->MoveFlags[NPCMV_CAN_WATER_WALK] = true;
				MoveAtAngle(mmd, mmd->KnockbackAngle, 4);
				this->MoveFlags[NPCMV_CAN_PIT_WALK] = false;
				this->MoveFlags[NPCMV_CAN_WATER_WALK] = false;
			}
		}
		bool Falling(npc this)
		{
			return this->Drowning||this->Falling;
		}
		void MoldormWaitframe(MiniMoldormData mmd, int frames=1)
		{
			npc this = mmd->Owner;
			for(int i=0; i<frames||this->Stun; ++i)
			{
				if(this->HP<=0||Falling(this))
				{
					this->DrawXOffset = 0;
					this->Immortal = false;
					Quit();
				}
				Knockback(mmd);
				Draw(mmd);
				Waitframe(this);
			}
		}
	}
}