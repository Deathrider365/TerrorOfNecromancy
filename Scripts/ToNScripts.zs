///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~~~~~~The Terror of Necromancy Scripts~~~~~~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////



// if issue with star.t / end, do:
// replace \r?\n with \r\n (must be in Regular Expression mode)

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Imports~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//start
#option SHORT_CIRCUIT on
#option BINARY_32BIT off

#include "std.zh"
#include "ffcscript.zh"
#include "Time.zh"
#include "std_zh/dmapgrid.zh"
#include "LinkMovement.zh"
#include "VenrobMisc.zh"
always using namespace Venrob;

#include "../ToN Main Quest/Scripts/ToNActiveSubscreen.zs"
#include "../ToN Main Quest/Scripts/ToNEnumsTypedefs.zs"
#include "../ToN Main Quest/Scripts/ToNFFCScripts.zs"
#include "../ToN Main Quest/Scripts/ToNGlobalActive.zs"
#include "../ToN Main Quest/Scripts/ToNHealthBars.zs"
#include "../ToN Main Quest/Scripts/ToNMiscFunctions.zs"
#include "../ToN Main Quest/Scripts/ToNNamespaces.zs"
#include "../ToN Main Quest/Scripts/ToNPassiveSubscreen.zs"
#include "../ToN Main Quest/Scripts/ToNDifficulty.zs"
#include "../ToN Main Quest/Scripts/ToNCredits.zh"
#include "ToNGhost.zh"

//end

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Item~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//start

//~~~~~Constants/globals~~~~~//

//~~~~~~~~~~~~~~~~~~~//

//~~~~~LegionRings~~~~~//
//start
item script LegionRings
{
	void run()
	{
		if(Game->Counter[CR_CUSTOM1] == 19)
		{
			Screen->TriggerSecrets();
			Screen->State[ST_SECRET] = true;
			return;	
		}		
	}
}
//end

//~~~~~GanonRage~~~~~//
// D0: Duration of ability
// D1: Duration of cooldown
// D2: Damage multiplier
//start
itemdata script GanonRage
{
	void run(int durationSeconds, int cooldownSeconds, int multiplier, int cost)
	{
		int itemClasses[] = {IC_ARROW, IC_BOW, IC_HAMMER, IC_BRANG, IC_SWORD, IC_GALEBRANG, IC_BRACELET, IC_ROCS, IC_STOMPBOOTS};
		itemdata ids[9];
		int powers[9];
		
		for (int i = SizeOfArray(itemClasses) - 1; i >= 0; --i)
		{
			int it = GetHighestLevelItemOwned(itemClasses[i]);
			
			if (it >= 0 && Hero->MP >= cost)
			{
				ids[i] = Game->LoadItemData(it);
				powers[i] = ids[i]->Power;
				ids[i]->Power *= multiplier;
				Hero->MP = Hero->MP - cost;
			}
		}
		
		statuses[ATTACK_BOOST] = durationSeconds * 60;
		
		while (statuses[ATTACK_BOOST])
			Waitframe();
		
		for (int i = SizeOfArray(itemClasses) - 1; i >= 0; --i)
		{
			if (ids[i])
				ids[i]->Power = powers[i];
		}
		
		for (int i = cooldownSeconds * 60; i > 0; --i)
		{
			char32 buf[8];
			itoa(buf, Ceiling(i / 60));
			
			if (Hero->ItemB == this->ID)
			{
				Screen->DrawString(7, SUB_B_X, SUB_B_Y, SUB_TEXT_FONT, SUB_TEXT_COLOR, -1, TF_CENTERED, buf, OP_OPAQUE);
				Screen->FastTile(7, SUB_B_X - (Text->StringWidth(buf, SUB_TEXT_FONT) / 2) - SUB_COOLDOWN_TILE_WIDTH, 
					SUB_B_Y, SUB_COOLDOWN_TILE, 0, OP_OPAQUE);
			}
			else if (Hero->ItemA == this->ID)                
			{
				Screen->DrawString(7, SUB_A_X, SUB_A_Y, SUB_TEXT_FONT, SUB_TEXT_COLOR, -1, TF_CENTERED, buf, OP_OPAQUE);
				Screen->FastTile(7, SUB_A_X - (Text->StringWidth(buf, SUB_TEXT_FONT) / 2) - SUB_COOLDOWN_TILE_WIDTH, 
					SUB_A_Y, SUB_COOLDOWN_TILE, 0, OP_OPAQUE);
			}
				
			Waitframe();
		}
	}
}
//end

//~~~~~LifeRing~~~~~//
//D0: HP to heal while enemies on screen
//D1: How often to heal while enemies on screen
//D2: HP to heal while no enemies on screen
//D3: How often to heal while no enemies on screen
//inspired by James24
//start
itemdata script LifeRing
{
	void run(int hpActive, int timerActive, int hpIdle, int timerIdle)
	{
		int clk;
		while(true)
		{
			while(Hero->Action == LA_SCROLLING)
				Waitframe();
			if(EnemiesAlive())
			{
				clk = (clk + 1) % timerActive;
				unless(clk) 
					Hero->HP += hpActive;
			}
			else
			{
				clk = (clk + 1) % timerIdle;
				unless(clk) 
					Hero->HP += hpIdle;
			}
			Waitframe();
		}
	}
}
//end

//~~~~~HaerenGrace~~~~~//
//D0: SFX # to play when attempting to use while on cooldown
//start
item script HaerenGrace
{
	void run(int errsfx)
	{        
		int percent = PercentOfWhole(Hero->HP, Hero->MaxHP);
	
		if (percent <= 10)
		{
			if (Hero->MP >= 200)
			{
				int mp1 = 200;
				
				for (int hpToRestore = Hero->MaxHP - Hero->HP; hpToRestore > 0;)
				{
					int heal = Min(4, hpToRestore);
					Hero->HP += heal;
					hpToRestore -= heal;
					
					int mpReduction = Min(8, mp1);
					Hero->MP -= mpReduction;
					mp1 -= mpReduction;
					
					if (mp1 > 0)
					{
						Hero->MP -= 5;
					}
					Waitframes(5);
				}
				//Hero->HP += Hero->MaxHP;	//If I want the effect to be instant
				//Hero->MP -= 200;
			}
			else 
				Audio->PlaySound(errsfx);
		}
		else if (percent <= 50)
		{
			if (Hero->MP >= 100)
			{
				int mp2 = 100;
				
				for (int hpToRestore2 = 160; hpToRestore2 > 0;)
				{
					int heal2 = Min(4, hpToRestore2);
					Hero->HP += heal2;
					hpToRestore2 -= heal2;
					
					int mpReduction2 = Min(8, mp2);
					Hero->MP -= mpReduction2;
					mp2 -= mpReduction2;
					
					if (mp2 > 0)
					{
						Hero->MP -= 5;
					}
					Waitframes(5);
				}
				//Hero->HP += Hero->MaxHP / 2;
				//Hero->MP -= 100;
			}
			else 
				Audio->PlaySound(errsfx);
		}
		else if (percent < 100)
		{
			if (Hero->MP >= 50)
			{
				int mp3 = 50;
				
				for (int hpToRestore3 = 120; hpToRestore3 > 0;)
				{
					int heal3 = Min(4, hpToRestore3);
					Hero->HP += heal3;
					hpToRestore3 -= heal3;
					
					int mpReduction3 = Min(8, mp3);
					Hero->MP -= mpReduction3;
					mp3 -= mpReduction3;
					
					if (mp3 > 0)
					{
						Hero->MP -= 5;
					}
					Waitframes(5);
				}
				//Hero->HP += Hero->MaxHP / 4;
				//Hero->MP -= 50;
			}
			else 
				Audio->PlaySound(errsfx);
		}
		//else, hp == maxhp
		else 
			Audio->PlaySound(errsfx);
	}
	
	float PercentOfWhole(int number, int whole)
	{
		return (100*number)/whole;
	}
}
//end

//~~~~~item~~~~~//
//start
item script itemjj
{
	void run()
	{
		// if()
		// {
			// int spitm = Screen->RoomType == RT_SPECIALITEM ? Screen->RoomData : -1;
		// }		
	}
}
//end

//end

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Item Descriptions~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//start
@Author ("Deathrider365")
item script HeartPieces //start
{
	void run()
	{
		if (Game->Generic[GEN_HEARTPIECES] + 1 == 1)
			Screen->Message(115);
		else if (Game->Generic[GEN_HEARTPIECES] + 1 == 2)
			Screen->Message(116);
		else if (Game->Generic[GEN_HEARTPIECES] + 1 == 3)
			Screen->Message(117);
		else if (Game->Generic[GEN_HEARTPIECES] + 1 == 4)
			Screen->Message(118);
	}
} //end

@Author ("Deathrider365")
item script DungeonKeys //start
{
	void run()
	{
	
	}
} //end
//end

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~LWeapon~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//start

//~~~~~Constants/globals~~~~~//
typedef const int DEFINE;
typedef const int CONFIG;
typedef const bool CONFIGB;
DEFINE IC_GALEBRANG = 256;

//~~~~~~~~~~~~~~~~~~~//

//~~~~~GaleBoomerang~~~~~//
//REQUIRES: `ZScript>>Quest Script Settings>>Objects` - `Weapons Live One Extra Frame With WDS_DEAD` must be checked.
//InitD[]:
//D0: turn rate (degrees per frame)
//D1: wind drop rate (every x frames, drop wind visual effect)
// Sprites[]:
// -0 = sprite for the weapon
// -1 = sprite for the wind visual effect
//start
lweapon script GaleBRang
{	
	CONFIG CF_BRANG_BOUNCE = CF_SCRIPT20;
	CONFIGB BOUNCE_OFF_FLAGS_ON_LAYERS_1_AND_2 = true;
	CONFIGB STOPS_WHEN_GRABBING_ITEMS = true;
	CONFIG DEFAULT_SPRITE = 5;
	CONFIG DEFAULT_WIND_SPRITE = 13;
	CONFIG DEFAULT_SFX = 63;
	DEFINE ROTATION_RATE = 40; //degrees	20
	CONFIG SFX_DELAY = 5;
	CONFIGB FORCE_QRS_TO_NEEDED_STATE = true;
	
	void run(int turnRate, int wind_drop_rate)
	{
		Game->FFRules[qr_WEAPONS_EXTRA_FRAME] = true;
		Game->FFRules[qr_OLDSPRITEDRAWS] = false;
		Game->FFRules[qr_CHECKSCRIPTWEAPONOFFSCREENCLIP] = true;
		itemdata parent;
		int wind_sprite;
		int wind_clk;
		int sfx_clk;
		int sfx;
		
		if(this->Parent > -1) //Initialize with data from the item that created this.
		{
			parent = Game->LoadItemData(this->Parent);
			this->UseSprite(parent->Sprites[0]);
			wind_sprite = parent->Sprites[1];
			sfx = parent->UseSound;
		}
		else //If this weapon was created by a script, instead of an item, initialize with defaults.
		{
			parent = NULL;
			this->UseSprite(DEFAULT_SPRITE);
			wind_sprite = DEFAULT_WIND_SPRITE;
			sfx = DEFAULT_SFX;
		}
		
		this->Angular = true;
		this->Angle = DirRad(this->Dir);
		int radTurnRate = DegtoRad(turnRate);
		bool controlling = (Input->Button[CB_A] || Input->Button[CB_B]);
		itemsprite dragging = NULL;
		bool collided = false;
		until(this->DeadState == WDS_DEAD || collided)
		{
			if(dragging)
			{
				dragging->X = this->X;
				dragging->Y = this->Y;
			}
			
			if(controlling)
			{
				if(Input->Button[CB_LEFT])
				{
					this->Angle -= radTurnRate;
				}
				else if(Input->Button[CB_RIGHT])
				{
					this->Angle += radTurnRate;
				}
			}
			
			int pos = ComboAt(this->X + 8, this->Y + 8);
			
			for(int q = 0; q <= (BOUNCE_OFF_FLAGS_ON_LAYERS_1_AND_2 ? 2 : 0); ++q)
			{
				mapdata m = Game->LoadTempScreen(q);
				if(m->ComboF[pos] == CF_BRANG_BOUNCE || m->ComboI[pos] == CF_BRANG_BOUNCE)
				{
					collided = true;
				}
			}
			
			for(int q = Screen->NumItems(); q > 0; --q)
			{
				itemsprite it = Screen->LoadItem(q);
				unless(it->Pickup & IP_TIMEOUT) continue;
				if(Collision(it, this))
				{
					dragging = it;
					collided = STOPS_WHEN_GRABBING_ITEMS;
				}
			}
			
			if(this->X < 0 || this->Y < 0 || (this->X + this->HitWidth) > 255 || (this->Y + this->HitHeight) > 175)
				collided = true; //Collide if off-screen
			if(controlling)
				++Hero->Stun;
				
			wind_clk = (wind_clk + 1) % wind_drop_rate;
			sfx_clk = (sfx_clk + 1) % SFX_DELAY;
			unless(wind_clk) drop_sparkle(this->X, this->Y, wind_sprite);
			unless(sfx_clk) Audio->PlaySound(sfx);
			this->Rotation = WrapDegrees(this->Rotation + ROTATION_RATE);
			Waitframe();
			if(controlling) 
				controlling = (Input->Button[CB_A] || Input->Button[CB_B]);
		}
		
		while(true)
		{
			this->DeadState = WDS_ALIVE;
			this->Angle = TurnTowards(this->X, this->Y, Hero->X, Hero->Y, this->Angle, 1); //Turn directly towards the Hero.
			
			if(Collision(this)) //touching the Hero
			{
				this->DeadState = WDS_DEAD;
				if(dragging)
				{
					dragging->X = Hero->X;
					dragging->Y = Hero->Y;
				}
				return;
			}
			
			if(dragging)
			{
				dragging->X = this->X;
				dragging->Y = this->Y;
			}
			
			wind_clk = (wind_clk + 1) % wind_drop_rate;
			sfx_clk = (sfx_clk + 1) % SFX_DELAY;
			unless(wind_clk) drop_sparkle(this->X, this->Y, wind_sprite);
			unless(sfx_clk) Audio->PlaySound(sfx);
			this->Rotation = WrapDegrees(this->Rotation + ROTATION_RATE);
			Waitframe();
		}
	}
	
	void drop_sparkle(int x, int y, int sprite)
	{
		lweapon sparkle = Screen->CreateLWeapon(LW_SPARKLE);
		sparkle->X = x;
		sparkle->Y = y;
		sparkle->UseSprite(sprite);
	}
}

//end

//~~~~~PortalSphere~~~~~//				INCOMPLETE, may not need to be scripted but perhaps a FFC script
//start
lweapon script PortalSphere
{

	void run()
	{

	}
}

//end


// the item that when used on an enemy of boss will display the health bar work where it will be a weapon script that basically checks the id of the enemy
// it hit and if it is a boss then display the health bar for n seconds (perhaps 10)
//~~~~~Scholar's Candelabra~~~~~//
//start
lweapon script ScholarCandelabra
{
	void run()
	{

	}
}
//end

lweapon script SineWave //start
{
	void run(int amp, int freq)
	{
		this->Angle = DirRad(this->Dir);
		this->Angular = true;
		int x = this->X, y = this->Y;
		int clk;
		int dist;
		while(true)
		{
			clk += freq;
			clk %= 360;
			
			x += RadianCos(this->Angle) * this->Step * .01;
			y += RadianSin(this->Angle) * this->Step * .01;
			
			dist = Sin(clk) * amp;
			
			this->X = x + VectorX(dist, RadtoDeg(this->Angle) - 90);
			this->Y = y + VectorY(dist, RadtoDeg(this->Angle) - 90);
			Waitframe();
		}
	}
} //end

lweapon script DeathsTouch //start
{
	void run()
	{
		//an aura n pixel circle around link that does x dps to all enemies in the radius and has a lasting damage effect even after they leave. works on all except undead until
		// the triforce of death is cleansed, then it hurts only undead but for a lot more than before it was cleansed (extremely useful for the legionnaire crypt)
		
		// lweapon deathsAura;
		// deathsAura->X = Hero->X - 8;
		// deathsAura->Y = Hero->Y - 8;
		// deathsAura->LoadSpriteData
		
		for (int i = 0; i < 240; ++i)
		{
			Screen->DrawCombo(7, this->X, this->Y, 6854, 2, 2, 0, 1, 1, 0, 0, 0, 0, 0, true, OP_OPAQUE);
		
			Waitframe();
		}
		
		// void DrawCombo	(int layer, int x, int y, 
		// int combo, int w, int h, 
		// int cset, int xscale, int yscale, 
		// int rx, int ry, int rangle, 
		// int frame, int flip, 
		// bool transparency, int opacity);
		
		//1: draw growing circle
		//2: loop for every enemy on screen and do collision check
		//3: apply damage to enemies touching
		//4: shrink circle when done
	}
}
//end

//end

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~EWeapon~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//start

//~~~~~Constants/globals~~~~~//


//~~~~~~~~~~~~~~~~~~~//

//~~~~~~~~~SignWave~~~~~~~~~~//
//start
eweapon script SignWave
{
	void run(int size, int speed, bool noBlock, int step)
	{
		this->Angle = DirRad(this->Dir);
		this->Angular = true;
		
		int x = this->X;
		int y = this->Y;
		this->Step = step;
		
		if (this->Parent)
			this->UseSprite(this->Parent->WeaponSprite);
		
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

//~~~~~~~~~PoisonDamage~~~~~~~~~~//
//start
eweapon script PoisonDamage
{
	void run(int dps)
	{
		// The sprinting zombies will apply this
	}
}
//end

//~~~~~~~~~ArcingWeapon~~~~~~~~~~//
//start
eweapon script ArcingWeapon
{
	void run(int initJump, int gravity, int effect)
	{
		int jump = initJump;
		int linkDistance = Distance(Hero->X, Hero->Y, this->X, this->Y);
		
		if (initJump == -1 && gravity == 0)
			jump = FindJumpLength(linkDistance / (this->Step / 100), true);
		
		if (gravity == 0)
			gravity = 0.16;

		while (jump > 0 || this->Z > 0)
		{
			this->Z += jump;
			this->Jump = 0;
			jump -= gravity;
			
			this->DeadState = WDS_ALIVE;
			
			CustomWaitframe(this, 1);
		}
		
		this->DrawYOffset = -1000;
		this->CollDetection = false;
		
		switch(effect)
		{
			case AE_SMALLPOISONPOOL:
				this->Step = 0;
				
				Audio->PlaySound(SFX_BOMB);
				
				for (int i = 0; i < 12; ++i)
				{
					int distance = 24 * i / 12;
					int angle = Rand(360);
					
					eweapon poisonTrail = FireEWeapon(EW_SCRIPT10, this->X + VectorX(distance, angle), this->Y + VectorY(distance, angle), 0, 0, this->Damage, 
														SPR_POISON_CLOUD, SFX_SIZZLE, EWF_UNBLOCKABLE);

					SetEWeaponLifespan(poisonTrail, EWL_TIMER, 90);
					SetEWeaponDeathEffect(poisonTrail, EWD_VANISH, 0);
					
					CustomWaitframe(this, 4);
				}
				break;
				
			case AE_LARGEPOISONPOOL:
				this->Step = 0;
				
				Audio->PlaySound(SFX_BOMB);
				
				for (int i = 0; i < 18; ++i)
				{
					int distance = 40 * i / 18;
					int angle = Rand(360);
					
					eweapon poisonTrail = FireEWeapon(EW_SCRIPT10, this->X + VectorX(distance, angle), this->Y + VectorY(distance, angle), 0, 0, this->Damage, 
														SPR_POISON_CLOUD, SFX_SIZZLE, EWF_UNBLOCKABLE);

					SetEWeaponLifespan(poisonTrail, EWL_TIMER, 90);
					SetEWeaponDeathEffect(poisonTrail, EWD_VANISH, 0);
					
					CustomWaitframe(this, 4);
				}
				break;
				
			case AE_PROJECTILEWITHMOMENTUM:
				for (int i = 0; i < 12; ++i)
				{
					int distance = 24 * i / 12;
					int angle = Rand(360);
					
					eweapon poisonTrail = FireEWeapon(EW_SCRIPT10, this->X + VectorX(distance, angle), this->Y + VectorY(distance, angle), 0, 0, this->Damage, 
														SPR_POISON_CLOUD, SFX_SIZZLE, EWF_UNBLOCKABLE);

					SetEWeaponLifespan(poisonTrail, EWL_TIMER, 90);
					SetEWeaponDeathEffect(poisonTrail, EWD_VANISH, 0);
					
					CustomWaitframe(this, 4);
				}
					break;
				
			case AE_DEBUG:
				this->Step = 0;
				
				for(int i = 0; i < 90; ++i)
				{
					Screen->DrawInteger(6, this->X, this->Y, FONT_Z1, C_WHITE, C_BLACK, -1, -1, i, 0, 128);
					this->DeadState = WDS_ALIVE;
					CustomWaitframe(this, 1);
				}
				break;
		}
		
		this->DeadState = WDS_DEAD;
	}
	
	void CustomWaitframe(eweapon this, int frames)
	{
		for (int i = 0; i < frames; ++i)
		{
			this->DeadState = WDS_ALIVE;
			Waitframe();
		}
	}
}
//end

//end

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Hero~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//start

//~~~~~Constants/globals~~~~~//
//start
int statuses[NUM_STATUSES];
bitmap status_bmp;
bitmap waterfall_bmp;
StatusPos statusPos = SP_TOP_RIGHT;

enum StatusPos
{
	SP_ABOVE_HEAD,
	SP_TOP_RIGHT
};

enum Status
{
	ATTACK_BOOST, 
	DEFENSE_BOOST, 
	NUM_STATUSES
};

CONFIG TILE_ATTACK_BOOST = 38901;
CONFIG TILE_DEFENSE_BOOST = 38902;
CONFIG STATUS_FONT = FONT_Z3SMALL;
DEFINE STATUS_HEIGHT = 8;
DEFINE STATUS_WIDTH = 12;
COLOR STARUS_TEXT_COLOR = C_WHITE;

//end
//~~~~~~~~~~~~~~~~~~~//

//~~~~~HeroActive~~~~~//
//start
hero script HeroActive
{
	void run()
	{
		clearStatuses();
					
		if (status_bmp && status_bmp->isAllocated())
			status_bmp->Free();
		
		DEFINE WIDTH = NUM_STATUSES * STATUS_WIDTH;
		DEFINE FONT_HEIGHT = Text->FontHeight(STATUS_FONT);
		DEFINE HEIGHT = STATUS_HEIGHT + FONT_HEIGHT;
		status_bmp = Game->CreateBitmap(WIDTH, HEIGHT);	
		
		while(true)
		{
			status_bmp->Clear(0);
			updateStatuses();
			
			int activeStatuses = 0;
			int statusSeconds[NUM_STATUSES];
			
			for (int i = 0; i < NUM_STATUSES; ++i)
			{
				if (statuses[i])
				{
					++activeStatuses;
					statusSeconds[i] = Ceiling(statuses[i] / 60);
				}
			}
			
			int index;
			DEFINE START_X = (NUM_STATUSES - activeStatuses) * (STATUS_WIDTH / 2);
			
			for (int i = 0; i < NUM_STATUSES; ++i)
			{
				unless (statuses[i])
					continue;
					
				status_bmp->FastTile(0, START_X + (index * STATUS_WIDTH), FONT_HEIGHT, getTile(<Status> i), 0, OP_OPAQUE);
				char32 buff[8];
				itoa(buff, statusSeconds[i]);
				status_bmp->DrawString(0, START_X + (index * STATUS_WIDTH) + (STATUS_WIDTH / 2), 
					0, STATUS_FONT, STARUS_TEXT_COLOR, -1, TF_CENTERED, buff, OP_OPAQUE);
			}
			
			status_bmp->Blit(7, -2, 0, 0, WIDTH, HEIGHT, getStatusX(statusPos, WIDTH), 
				getStatusY(statusPos, HEIGHT), WIDTH, HEIGHT, 0, 0, 0, BITDX_NORMAL, 0, true);
			
				
			Waitframe();
		}
	}
	
	void updateStatuses()
	{
		if (statuses[ATTACK_BOOST])
			--statuses[ATTACK_BOOST];
		if (statuses[DEFENSE_BOOST])
			--statuses[DEFENSE_BOOST];
	}
	
	void clearStatuses()
	{
		memset(statuses, 0, NUM_STATUSES); 
	}
	
	int getTile(Status s)
	{
		switch(s)
		{
			case ATTACK_BOOST:
				return TILE_ATTACK_BOOST;
			
			case DEFENSE_BOOST:
				return TILE_DEFENSE_BOOST;
		}
		
		return NULL;
	}	
	
	int getStatusX(StatusPos pos, int width)
	{
		switch(pos)
		{
			case SP_ABOVE_HEAD:
				return Hero->X + 8 - (width / 2);
			case SP_TOP_RIGHT:
				return 256 - width;
		}
	}
	
	int getStatusY(StatusPos pos, int height)
	{
		switch(pos)
		{
			case SP_ABOVE_HEAD:
				return Hero->Y - height - 4;
			case SP_TOP_RIGHT:
				return 0;
		}
	}

}
//end

//~~~~~OnDeath~~~~~//
//start
hero script OnDeath
{
	void run()
	{
		onContHP = Hero->MaxHP;
		onContMP = Hero->MaxMP;	
	}
}
//end

//~~~~~HeroInit~~~~~//
//start
hero script HeroInit
{
	void run()
	{
		subscr_y_offset = -224;
	}
}
//end

//end
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Enemies~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//start
//~~~~~Constants/globals~~~~~//
//start

//end
//~~~~~~~~~~~~~~~~~~~//

//~~~~~Mimic~~~~~//
// D0: Speed Multiplier
// D1: Fire cooldown (frames)
// D2: Knockback rate in pixels per frame 
npc script Mimic //start
{
	void run(int speedMult, int fireRate, int knockbackDist)
	{
		unless (speedMult)
			speedMult = 1;
			
		unless (fireRate)
			fireRate = 30;
			
		unless (knockbackDist)
			knockbackDist = 4;
			
		int fireClk;
		
		if (knockbackDist < 0)
			this->NoSlide = true;
		else
			this->SlideSpeed = knockbackDist;	// 4 is default
			
			
		eweapon e;
		
		while (true)
		{
			while (this->Stun)
			{
				this->Slide();
				
				Waitframe();
			}
			
			this->Slide();
				
			int xStep = -LinkMovement[LM_STICKX] * Hero->Step / 100 * speedMult;			
			int yStep = -LinkMovement[LM_STICKY] * Hero->Step / 100 * speedMult;
			
			this->Dir = OppositeDir(Hero->Dir);
			int step = Max(Abs(xStep), Abs(yStep));
			
			int mDir = (yStep ? (yStep < 0 ? DIR_UP : DIR_DOWN) : -1);
			mDir = Venrob::addX(mDir, (xStep ? (xStep < 0 ? DIR_LEFT : DIR_RIGHT) : -1));
			
			
			unless (fireClk)
			{
				if (this->Dir == this->LinedUp(12, false))
				{
					this->Attack();
					fireClk = fireRate;
				}
			}
			else
				--fireClk;
			
			if (mDir != -1)
			{
				while(true)
				{					
					if (this->CanMove({mDir, step, 0}))
					{
						this->X += xStep;
						this->Y += yStep;
						break;
					}
					
					if (--step <= 0)
						break;
					
					if (xStep)
						xStep > 0 ? --xStep : ++xStep;
					if (yStep)
						yStep > 0 ? --yStep : ++yStep;
				}
			}
			
			Waitframe();
		}	
	}
} //end

//~~~~~Bomber~~~~~//
ffc script Bomber //start
{
	void run()
	{
		while (true)
		{
			
		}	
	}
} //end

//~~~~~Beamos~~~~~//
ffc script Beamos //start
{
	void run()
	{
		while (true)
		{
			
		}	
	}
} //end

//~~~~~LoSTurret~~~~~//
ffc script LoSTurret //start
{
	void run()
	{
		while (true)
		{
			
		}	
	}
} //end

//end
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Bosses~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//start

//~~~~~Constants/globals~~~~~//
//start


//end


//~~~~~LegionnaireLevel1~~~~~//
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
				Audio->PlaySound(64);
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

//~~~~~Amalgamation of Decay ---Shambles---~~~~~//

namespace Shambles//start
{
	bool firstRun = true;

	ffc script Decay 
	{
		void run(int enemyid)
		{
			npc ghost = Ghost_InitAutoGhost(this, enemyid);
			int combo = ghost->Attributes[10];
			int attackCoolDown = 90;
			int attack;
			int startHP = Ghost_HP;
			int bombsToLob = 3;
			int difficultyMultiplier = 0.33;
			
			Audio->PlayEnhancedMusic(NULL, 0);
			
			//start spawning animation
			Ghost_X = 128;				// sets him off screen as a time buffer
			Ghost_Y = -32;
			Ghost_Dir = DIR_DOWN;

			Hero->Stun = 270;
			
			Screen->Quake = 90;
			ShamblesWaitframe(this, ghost, 90, SFX_ROCKINGSHIP);
			
			Ghost_X = 120;
			Ghost_Y = 80;
			Ghost_Data = combo + 4;
			
			Screen->Quake = 60;
			ShamblesWaitframe(this, ghost, 60, SFX_ROCKINGSHIP);
			
			Ghost_Data = combo + 5;
			
			Screen->Quake = 60;
			ShamblesWaitframe(this, ghost, 60, SFX_ROCKINGSHIP);
			
			Ghost_Data = combo + 6;
			
			Screen->Quake = 60;
			ShamblesWaitframe(this, ghost, 60, SFX_ROCKINGSHIP);

			if (firstRun)
			{
				Screen->Message(45);
				firstRun = false;
			}
			//end spawning animation

			submerge(this, ghost, 8);

			while (true) //start Activity Cycle
			{		
				int choice = chooseAttack();
				
				ShamblesWaitframe(this, ghost, 120);
				
				int pos = moveMe();
				Ghost_X = ComboX(pos);
				Ghost_Y = ComboY(pos);
				
				if (Ghost_HP < startHP * difficultyMultiplier)
				{
					emerge(this, ghost, 4);
					bombsToLob = 5;
				}
				else
					emerge(this, ghost, 8);
				
				switch(choice) 
				{
					case 0:	//start LinkCharge
						Waitframes(30);
						for (int i = 0; i < 5; ++i)
						{
							int moveAngle = Angle(Ghost_X, Ghost_Y, Hero->X, Hero->Y);
							
							Audio->PlaySound(SFX_SWORD);
							
							for (int j = 0; j < 22; ++j)
							{
								// if (Ghost_HP < startHP * difficultyMultiplier && j % 3 == 0)		//Save for the Boss rush at the tailend of the game
								// {
									// eweapon poisonTrail = FireEWeapon(EW_SCRIPT10, Ghost_X + Rand(-2, 2), Ghost_Y + Rand(-2, 2), 0, 0, ghost->WeaponDamage, 
																		// SPR_POISON_CLOUD, SFX_SIZZLE, EWF_UNBLOCKABLE);

									// SetEWeaponLifespan(poisonTrail, EWL_TIMER, 180);
									// SetEWeaponDeathEffect(poisonTrail, EWD_VANISH, 0);
								// }
								
								Ghost_ShadowTrail(this, ghost, false, 4);
								Ghost_MoveAtAngle(moveAngle, 3, 0);
								ShamblesWaitframe(this, ghost, 1);
							}
							
							ShamblesWaitframe(this, ghost, 30);
						}
							
						break; //end
					
					case 1:	//start Poison Bombs
						for (int i = 0; i < bombsToLob; ++i)
						{
							ShamblesWaitframe(this, ghost, 16);
							eweapon bomb = FireAimedEWeapon(EW_BOMB, Ghost_X, Ghost_Y, 0, 200, ghost->WeaponDamage, -1, -1, EWF_UNBLOCKABLE | EWF_ROTATE);
							Audio->PlaySound(129);
							RunEWeaponScript(bomb, Game->GetEWeaponScript("ArcingWeapon"), {-1, 0, (Ghost_HP < (startHP * difficultyMultiplier)) ? AE_LARGEPOISONPOOL : AE_SMALLPOISONPOOL});
							Waitframes(6);
						}
						break; //end
					
					case 2: //start Spawn Zambos
						spawnZambos(this, ghost);
						break; //end
				}
				
				if (Ghost_HP < startHP * 0.50)
					submerge(this, ghost, 4);
				else
					submerge(this, ghost, 8);
				
				pos = moveMe();
				Ghost_X = ComboX(pos);
				Ghost_Y = ComboY(pos);
			} //end
		
		}
		
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
	}
} //end

//~~~~~Demonwall~~~~~//
/*
npc script Demonwall //start
{
	
	void run()
	{

		for (int i = 0; i < roomsize since the wall can squish link for instakill; ++i)
		{
			move the guy perhaps 1/8th of a tile every frame 
			if (demonwall->HP at 70%)
				move demonwall back 3 tiles if it can, otherwise just back the the left wall
				
			do some attacks
			
		}

	{
} //end
*/

//end
























