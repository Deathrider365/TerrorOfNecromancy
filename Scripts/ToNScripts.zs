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

lweapon script SineWave
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
}


//start
lweapon script DeathsTouch
{
	void run()
	{
		//an aura n pixel circle around link that does x dps to all enemies in the radius and has a lasting damage effect even after they leave. works on all except undead until
		// the triforce of death is cleansed, then it hurts only undead but for a lot more than before it was cleansed (extremely useful for the legionnaire crypt)
		
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
		this->Angle = DirRad(this->Dir);		//
		this->Angular = true;					//
		
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
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Enemies~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
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

//~~~~~LegionnaireLevel1~~~~~//
// D0: Speed Multiplier
// D1: Fire cooldown (frames)
// D2: Knockback rate in pixels per frame 
npc script LegionnaireLevel1 //start
{
	int xSpeed = 5;
	int ySpeed = 5;
	int count;
	int xStep;
	int yStep;
	int direction;
	int attChoice;
	int posDir = 1;
	int negDir = -1;

	void run()
	{
		while (true)
		{			
			bool randDir = Rand(2);
			
			Waitframe();
				
				
			// Moves around
			while (true)
			{
				int dir = findDir(this->X, this->Y);
				
				if (Input->Key[KEY_P])
					Trace(dir);
				
				this->Dir = dir8To4(dir);				
				
				if (dir <= DIR_RIGHT)
				{
					int x = this->X + dirX(this->Dir);
					int y = this->Y + dirY(this->Dir);
					
					if (x > 16 && x < 225 && y > 16 && y < 145)
					{
						this->X += getXChange(this->Dir, randDir);
						this->Y += getYChange(this->Dir, randDir);
					}
					else
					{
						if (randDir)
							randDir = false;
						else
							randDir = true;
							
						if (x > 16 && x < 225 && y > 16 && y < 145) 
						{
							this->X += getXChange(this->Dir, randDir);
							this->Y += getYChange(this->Dir, randDir);
						}
					}
				}
				Waitframe();
			}
				
			// Decides on an attack
			attChoice = attackChoice();
			
			// Attacks
			switch(attChoice)
			{
			
			
				default:
					break;
			}
			
			
			Waitframe();
		}	
	}
	
	// Determines the direction it must face
	int findDir(int currX, int currY) //start
	{
		#option APPROX_EQUAL_MARGIN 0.5
		// ~~ approximate equal
	
		int dir;
				
		if (Hero->Y ~~ currY)
		{
			if (Hero->X < currX)
				return DIR_LEFT;
			else if (Hero->X > currX)
				return DIR_RIGHT;
			else
				return DIR_DOWN;
		}
		else if (Hero->X ~~ currX)
		{
			if (Hero->Y < currY)
				return DIR_UP;
			else
				return DIR_DOWN;
		}
		
		//Floor truncates
		int dx = Abs(Floor(Hero->X) - currX);
		int dy = Abs(Floor(Hero->Y) - currY);
		
		// Link is top left of enemy
		if (Hero->Y < currY && Hero->X < currX)
		{
			if (dy ~~ dx)
				return DIR_LEFTUP;
			if (dy > dx)
				return DIR_UP;
			return DIR_LEFT;
		}
		
		// Link is top right of enemy
		else if (Hero->Y < currY && Hero->X > currX)
		{
			if (dy ~~ dx)
				return DIR_RIGHTUP;
			if (dy > dx)
				return DIR_UP;
			return DIR_RIGHT;
		}
		
		// Link is below left of enemy
		else if (Hero->Y > currY && Hero->X < currX)
		{
			if (dy ~~ dx)
				return DIR_LEFTDOWN;
			if (dy > dx)
				return DIR_DOWN;
			return DIR_LEFT;
		}
		
		// Link is below right of enemy
		else if (Hero->Y > currY && Hero->X > currX)
		{
			if (dy ~~ dx)
				return DIR_RIGHTDOWN;
			if (dy > dx)
				return DIR_DOWN;
			return DIR_RIGHT;
		}
						
	} //end
	
	// Determines the amount of x to translate
	int getXChange(int direction, bool randDir) //start
	{
		switch (direction)
		{
			case DIR_UP:
				return randDir ? 1 : -1;
					
			case DIR_DOWN:
				return randDir ? -1 : 1;
			
			case DIR_LEFT:
				return -1;
				
			case DIR_RIGHT:
				return 1;
		}
	} //end
	
	// Determines the amount of y to translate
	int getYChange(int direction, bool randDir) //start
	{
		
		switch(direction)
		{	
			case DIR_UP:
				return -1;

			case DIR_DOWN:
				return 1;
					
			case DIR_LEFT:
				return randDir ? 1 : -1;
					
			case DIR_RIGHT:
				return randDir ? -1 : 1;
		}
	} //end

	// Determines which attack to use
	int attackChoice() //start
	{
		int decision;
		
		switch(decision)
		{
			
			
			default:
				break;
		
		}
		
		return decision;
	} //end
	
} //end

//~~~~~Bomber~~~~~//
npc script Bomber //start
{
	void run()
	{
		while (true)
		{
			
		}	
	}
} //end

//~~~~~Beamos~~~~~//
npc script Beamos //start
{
	void run()
	{
		while (true)
		{
			
		}	
	}
} //end

//~~~~~LoSTurret~~~~~//
npc script LoSTurret //start
{
	void run()
	{
		while (true)
		{
			
		}	
	}
} //end

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Bosses~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//start

//~~~~~Constants/globals~~~~~//
//start


//end

//~~~~~Amalgamation of Decay ---Shambles---~~~~~//
npc script Decay //start
{
	void run()
	{
		while (true)
		{
			
		}	
	}
} //end

//~~~~~Demonwall~~~~~//
//start
	/*
npc script Demonwall
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
}
	*/
//end


//end
























