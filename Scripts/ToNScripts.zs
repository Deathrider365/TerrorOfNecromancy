///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~~~~~~The Terror of Necromancy Scripts~~~~~~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

#option SHORT_CIRCUIT on
#option BINARY_32BIT off

/*
phantom from the messenger be in the game. In his search to revive Muse, his lover, he come across the necromancer whom
he hears can bring back those who had died. He tasks phantom to kill link in order to help him. 
he will have all the same attacks, sfx, and boss music from the messenger. Have him refer to whatever it was he needed
to get to the music box or whatever since this is before he is trapped there. Have the music that plays outside his boss room play
when you enter the room where you encounter him. and have the sound of hitting him be the same as from the game, basically
mimic to messenger entirely. This will replace the hall of memories from IoR. 


the item that when used on an enemy of boss will display the health bar work where it will be a weapon script that basically checks the id of the enemy
it hit and if it is a boss then display the health bar for n seconds (perhaps 10)


where the necromancer dies (the location where he essentially jumps out of his tower be where you acquire the spectral cane maybe
*/

// if issue with star.t / end, do:
// replace \r?\n with \r\n (must be in Regular Expression mode)

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Authors~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//start
// FFC RemoteSwitches - Moosh
// Leviathan - Moosh

//end

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Imports~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//start
#include "std.zh"
#include "ffcscript.zh"
#include "../ToN Main Quest/Scripts/ToNActiveSubscreen.zs"
#include "../ToN Main Quest/Scripts/ToNPassiveSubscreen.zs"
#include "../ToN Main Quest/Scripts/ToNHealthBars.zs"
#include "../ToN Main Quest/Scripts/ToNFFCScripts.zs"
#include "Time.zh"
#include "std_zh/dmapgrid.zh"

//end

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Typedefs / Enums~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//start

//~~~~~Typedefs~~~~~//
typedef const int DEFINE;
typedef const int CONFIG;
typedef const bool CONFIGB;
typedef const Color COLOR;

//~~~~~Enums~~~~~//
//start
enum Color
{
	C_TRANSBG = -1,
	C_TRANS = 0x00,
	C_GREEN = 0x06,
	C_BLACK = 0x08,
	C_RED = 0x04,
	C_WHITE = 0x0C,
	C_BLUE = 0x1F,
	C_LGRAY = 0x2B,
	C_TAN = 0x75,
	C_SEABLUE = 0x76,
	C_DARKBLUE = 0x77
};

enum ScreenType
{
	DM_DUNGEON,
	DM_OVERWORLD,
	DM_INTERIOR,
	DM_BSOVERWORLD
};

//end

//end

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Global Active~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//start
//~~~~~Constants/globals~~~~~//
//start

CONFIGB DEBUG = true;

int deathCount = 0;

CONFIG SUB_B_X = 94;
CONFIG SUB_B_Y = -10;
CONFIG SUB_A_X = 118;
CONFIG SUB_A_Y = -10;
COLOR SUB_TEXT_COLOR = C_BLACK;
CONFIG SUB_TEXT_FONT = FONT_LA;
CONFIG SUB_COOLDOWN_TILE = 29281;
CONFIG SUB_COOLDOWN_TILE_WIDTH = 9;
CONFIG CR_LEGIONNAIRE_RING = CR_SCRIPT1;

CONFIG TILE_LEGIONNAIRE_RING = 42700;
CONFIG CSET_LEGIONNAIRE_RING = 4;
CONFIG TILE_INVIS = 196;
//CONFIG COMBO_INVIS = ;

int onContHP = 0;
int onContMP = 0;
int gameframe = 0;

//end
//~~~~~~~~~~~~~~~~~~~~~~~~~~~//

//~~~~~Main Global~~~~~//
//start
global script GlobalScripts
{
	void run()
	{	
		if (DEBUG)									//turn off debug when releasing
			debug();
		
		while(true)
		{
			gameframe = (gameframe+1)%3600;	//global timer
			checkDungeon();
			Waitframe();
		}
	}
	
	//~~~~~ItemCycling~~~~~//
	void checkItemCycle()
	{
	    if (Link->PressL) Link->SelectBWeapon(DIR_LEFT);
		if (Link->PressR) Link->SelectBWeapon(DIR_RIGHT);
	}
	
	//~~~~~checkDungeon~~~~~//
	void checkDungeon()
	{
		int level = Game->GetCurLevel();
		unless (Game->LItems[level] & LI_MAP)
		{
			Link->InputMap = false;
			Link->PressMap = false;
		}
	}	
	
	void debug()
	{
		Game->Cheat = 4;
	}
}
//end

//~~~~~OnLaunch~~~~~//
//start
global script OnLaunch
{
    void run()
    {
		if(onContHP != 0)
		{
			Hero->HP = onContHP;
			Hero->MP = onContMP;	
		}
		else
		{
			Hero->HP = Hero->MaxHP;
			Hero->MP = Hero->MaxMP;		
		}
    }
}
//end

//~~~~~OnF6Menu~~~~~//
//start
global script onF6Menu
{
    void run()
    {
		onContHP = Hero->HP;
		onContMP = Hero->MP;	
		printf("%d, %d\n", onContHP, onContMP);
    }
}
//end

//~~~~~OnContGame~~~~~//
//start
global script onContGame
{
    void run()
    {
		if(onContHP != 0)
		{
			Hero->HP = onContHP;
			Hero->MP = onContMP;	
		}
		else
		{
			Hero->HP = Hero->MaxHP;
			Hero->MP = Hero->MaxMP;		
		}
    }
}
//end

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

//end

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~NPC~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//start

//~~~~~Constants/globals~~~~~//

//~~~~~~~~~~~~~~~~~~~//



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
		
		
		Quit();
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

//~~~~~~~~~Sine_Wave~~~~~~~~~~//
//start
eweapon script Sine_Wave
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
hero script HeroInit
{
	void run()
	{
		subscr_y_offset = -224;
	}
}

//end

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~DMap~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//start

//~~~~~Constants/globals~~~~~//


//~~~~~~~~~~~~~~~~~~~//



//end

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Screen~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//start
//~~~~~Constants/globals~~~~~//


//~~~~~~~~~~~~~~~~~~~//



//end

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Item Sprites~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//start

//~~~~~Constants/globals~~~~~//


//~~~~~~~~~~~~~~~~~~~//



//end

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Bosses~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//start

//~~~~~Constants/globals~~~~~//
//start

const int NPC_LEVIATHANHEAD = 177;

CONFIG SFX_RISE = 67;		//9
CONFIG SFX_ROCKINGSHIP = 9;
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

const int LEVIATHAN1_WATERCANNON_DMG = 80;
const int LEVIATHAN1_BURSTCANNON_DMG = 40;
const int LEVIATHAN1_WATERFALL_DMG = 60;

const int MSG_BEATEN = 19;

bool firstRun = true;
//end

//~~~~~Leviathan1~~~~~//
 
namespace Leviathan //start
{
	const int CMB_WATERFALL = 6828; //Leviathan's waterfall combos: Up (BG, middle) Up, (BG, foam) Down (FG, middle), Down (FG, foam)
	const int CS_WATERFALL = 0;
	
	
	npc script Leviathan1 //start
	{	
		const int VARS_HEADNPC = 0;
		const int VARS_HEADCX = 1;
		const int VARS_HEADCY = 2;
		const int VARS_FLIP = 3;
		const int VARS_BODYHP = 8;
		const int VARS_FLASHTIMER = 5;
		const int VARS_INITHP = 6;
		
		void run(int fight)
		{		
			Hero->Dir = DIR_UP;
			if (waterfall_bmp && waterfall_bmp->isAllocated())
				waterfall_bmp->Free();
				
			waterfall_bmp = Game->CreateBitmap(32, 176);
			
			int i; int j; int k;
			int x; int y;
			int x2; int y2;
			int angle; int dist;
			
			eweapon e;
			
			untyped vars[16];
			npc head = CreateNPCAt(NPC_LEVIATHANHEAD, this->X, this->Y);

			vars[VARS_HEADNPC] = head;
			vars[VARS_BODYHP] = this->HP;
			vars[VARS_INITHP] = this->HP;
			
			this->HitXOffset = 64;
			this->HitYOffset = 32;
			
			this->HitWidth = 48;
			this->HitHeight = 48;
			
			this->X = 52;
			this->Y = 112;
			
			int attack;	
			
			Audio->PlayEnhancedMusic(NULL, 0);
			
			//
			//    The leviathan is rising and screen is quaking
			//
			for(i = 0; i < 180; ++i)        
			{
				Hero->Dir = DIR_UP;
				NoAction();
				GlideFrame(this, vars, 52, 112, 52, 32, 180, i);
				
				if(i % 40 == 0)
				{
					Audio->PlaySound(SFX_ROCKINGSHIP);
					Screen->Quake = 20;
				}

				Waitframe(this, vars);
			}
			
			//
			//    The leviathan pauses, roars, then pauses
			//			
			for(i = 0; i < 120; ++i)
			{
				NoAction();
				if (i == 60)
				{
				   Audio->PlaySound(SFX_ROAR);
				   Audio->PlayEnhancedMusic("DS3 - Old Demon King.ogg", 0);
				   if (firstRun)
				   {
						Screen->Message(16);
						firstRun = false;
				   }
				}
				 
				Waitframe(this, vars);
			}
			
			//
			//    The leviathan dives
			//
			for(i = 0; i < 20; ++i)
			{
				GlideFrame(this, vars, 52, 32, 52, 112, 20, i);
				Waitframe(this, vars);
			}
			
			//
			//    The splash SFX he makes when diving
			//
			Audio->PlaySound(SFX_SPLASH);
			Splash(this->X + 64, 100);
					
			//
			//    Leviathan's behavior loop
			//
			while(true)
			{
				attack = attackChoice(this, vars);
				
				int riseAnim = 120;
				if(this->HP < vars[VARS_INITHP] * 0.3)	//was 0.5
					riseAnim = 40;
					
				switch(attack)
				{
					// Waterfall Attack
					case 0:
						x = Link->X-64;
						x2 = x + Choose(-8, 8);
					
						Glide(this, vars, x, 112, x2, 32, riseAnim);
						Waitframe(this, vars, 40);
						
						for(i = 0; i < 20; ++i)
						{
							GlideFrame(this, vars, x2, 32, x2, 112, 20, i);
							Audio->PlaySound(SFX_WATERFALL);
							if(i == 3)
							{
								int cx = this->X + this->HitXOffset + this->HitWidth / 2;
								eweapon waterfall = CreateEWeaponAt(EW_SCRIPT10, cx - 8, 112);
								waterfall->Damage = LEVIATHAN1_WATERFALL_DMG;
								waterfall->Script = Game->GetEWeaponScript("Waterfall");
								waterfall->DrawYOffset = -1000;
								waterfall->InitD[0] = 3;
								waterfall->InitD[1] = 64;
							}
							
							Waitframe(this, vars);
						}			
						
						Audio->PlaySound(SFX_SPLASH);
						break;
					
					// Water Cannon
					case 1:
						x = Rand(-32, 144);
						x2 = x + Choose(-8, 8);
						
						if(x < 56)
							vars[VARS_FLIP] = 0;
						else
							vars[VARS_FLIP] = 1;
					
						// Rise out of water
						Glide(this, vars, x, 112, x2, 32, riseAnim);
						
						x = vars[VARS_HEADCX];
						y = vars[VARS_HEADCY];
						Audio->PlaySound(SFX_CHARGE);
						
						// Charge animation
						Charge(this, vars, x, y, 60, 24);
						
						angle = Angle(x, y, Link->X + 8, Link->Y + 8);
						
						int wSizes[4] = {-24, 24, -12, 12};
						int wSpeeds[4] = {16, 16, 12, 12};
						
						// Shooting loop
						for(i = 0; i < 32; ++i)
						{
							if(this->HP < vars[VARS_INITHP]*0.3)
								angle = TurnToAngle(angle, Angle(x, y, Link->X + 8, Link->Y + 8), 1.5);
							
							Audio->PlaySound(SFX_SHOT);
							
							for(j = 0; j < 4; ++j)
							{
								e = CreateEWeaponAt(EW_SCRIPT1, x - 8, y - 8);
								e->Damage = LEVIATHAN1_WATERCANNON_DMG;
								e->UseSprite(SPR_WATERBALL);
								e->Angular = true;
								e->Angle = DegtoRad(angle);
								e->Dir = AngleDir4(angle);
								e->Step = 300;
								e->Script = Game->GetEWeaponScript("Sine_Wave");
								e->InitD[0] = wSizes[j] * (0.5 + 0.5 * (i / 32));
								e->InitD[1] = wSpeeds[j];
								e->InitD[2] = true;
							}
							
							Waitframe(this, vars, 4);
						}
						
						// Splashing animation
						Glide(this, vars, x2, 32, x2, 112, 20);
						Audio->PlaySound(SFX_SPLASH);
						Splash(this->X + 64, 100);
						
						break;
					
					// Water Cannon (Burst)
					case 2:
						x = Rand(-32, 144);
						x2 = x + Choose(-8, 8);
						
						if(x < 56)
							vars[VARS_FLIP] = 0;
						else
							vars[VARS_FLIP] = 1;
					
						// Rise out of water
						Glide(this, vars, x, 112, x2, 32, riseAnim);
						
						x = vars[VARS_HEADCX];
						y = vars[VARS_HEADCY];
						Audio->PlaySound(SFX_CHARGE);
						
						int wSizes[2] = {-32, 32};
						int wSpeeds[2] = {6, 6};
						
						int numBursts = 3;
						if(this->HP < vars[VARS_INITHP]*0.3)
							numBursts = 5;
						int burstDelay = 40;
						if(this->HP < vars[VARS_INITHP]*0.3)
							burstDelay = 24;
							
						// Shooting loop
						for(i = 0; i < numBursts; ++i)
						{
							// Charge animation
							Charge(this, vars, x, y, 20, 16);
							
							angle = Angle(x, y, Link->X + 8, Link->Y + 8) + Rand(-20, 20);
							
							for(j = 0; j < 3; ++j)
							{
								Audio->PlaySound(SFX_SHOT);
								
								for(k = 0; k < 2; ++k)
								{
									e = CreateEWeaponAt(EW_SCRIPT1, x - 8, y - 8);
									e->Damage = LEVIATHAN1_BURSTCANNON_DMG; //this->WeaponDamage;
									e->UseSprite(SPR_WATERBALL);
									e->Angular = true;
									e->Angle = DegtoRad(angle);
									e->Dir = AngleDir4(angle);
									e->Step = 200;
									e->Script = Game->GetEWeaponScript("Sine_Wave");
									e->InitD[0] = wSizes[k]-Rand(-4, 4);
									e->InitD[1] = wSpeeds[k];
									e->InitD[2] = true;
								}
								Waitframe(this, vars, 4);
							}
							
							Waitframe(this, vars, 16);
							
							for(j = 0; j < 2; ++j)
							{
								e = CreateEWeaponAt(EW_SCRIPT1, x - 8, y - 8);
								e->Damage = LEVIATHAN1_BURSTCANNON_DMG; //this->WeaponDamage;
								e->UseSprite(SPR_WATERBALL);
								e->Angular = true;
								e->Angle = DegtoRad(angle);
								e->Dir = AngleDir4(angle);
								e->Step = 150;
								e->Script = Game->GetEWeaponScript("Sine_Wave");
								e->InitD[0] = 4;
								e->InitD[1] = 16;
								e->InitD[2] = true;
								Waitframe(this, vars, 4);
							}
							
							Waitframe(this, vars, burstDelay);
						}
						
						// Splashing animation
						Glide(this, vars, x2, 32, x2, 112, 20);
						Audio->PlaySound(SFX_SPLASH);
						Splash(this->X + 64, 100);
						
						break;
					
					// Side Swap
					case 3:
						int side = Choose(-1, 1);
						
						x = side == -1 ? -32 : 144;
						x2 = x + 32*side;
						
						if(x < 56)
							vars[VARS_FLIP] = 0;
						else
							vars[VARS_FLIP] = 1;
					
						// Rise out of water
						Glide(this, vars, x, 112, x2, 32, riseAnim);
						
						for(i = 0; i < 64; ++i)
						{
							this->X += side * 0.25;
							this->Y -= 0.125;
							Waitframe(this, vars);
						}
						
						j = 8;
						k = 8;
						for(i=0; i<64; ++i)
						{
							this->X -= side*4;
							this->Y += 0.5;
							
							eweapon waterfall = CreateEWeaponAt(EW_SCRIPT10, this->X + 80, 112);
							waterfall->Damage = LEVIATHAN1_WATERFALL_DMG + 20;
							waterfall->Script = Game->GetEWeaponScript("Waterfall");
							waterfall->DrawYOffset = -1000;
							waterfall->InitD[0] = 1;
							waterfall->InitD[1] = 64-i*0.5;
							
							Waitframe(this, vars);
						}
						
						// Splashing animation
						Glide(this, vars, this->X, this->Y, this->X, 112, 20);
						Audio->PlaySound(SFX_SPLASH);
						Splash(this->X + 64, 100);
						
						break;
				}
				
				Waitframe(this, vars);
			}
		}
		
		int attackChoice(npc this, untyped vars)
		{
			if(this->HP < vars[VARS_INITHP]*0.3)
			{
				//Do stream at left and right sides
				if(Link->X<48||Link->X>192)
				{
					if(Rand(2)==0)
						return 1;
				}
				//Don't do bursts near the top of the arena
				if(Link->Y>=118)
				{
					if(Rand(2)==0)
						return Choose(1, 3);
				}
				return Choose(1, 2, 3);
			}
			else
			{
				//Do stream at left and right sides
				if(Link->X<48||Link->X>192)
				{
					if(Rand(2)==0)
						return 1;
				}
				//Don't do bursts near the top of the arena
				if(Link->Y>=118)
				{
					if(Rand(2)==0)
						return Choose(0, 1);
				}
				return Choose(0, 1, 2);
			}
		}
		
		void Glide(npc this, untyped vars, int x1, int y1, int x2, int y2, int numFrames)
		{
			int angle = Angle(x1, y1, x2, y2);
			int dist = Distance(x1, y1, x2, y2);
			
			for(int i = 0; i < numFrames; ++i)
			{
				int x = x1 + VectorX(dist * (i / numFrames), angle);
				int y = y1 + VectorY(dist * (i / numFrames), angle);
				this->X = x;
				this->Y = y;
				Waitframe(this, vars);
			}
		}
		
		void GlideFrame(npc this, untyped vars, int x1, int y1, int x2, int y2, int numFrames, int i)
		{
			int angle = Angle(x1, y1, x2, y2);
			int dist = Distance(x1, y1, x2, y2);
			int x = x1 + VectorX(dist * (i / numFrames), angle);
			int y = y1 + VectorY(dist * (i / numFrames), angle);
			this->X = x;
			this->Y = y;
		}
		
		void Charge(npc this, untyped vars, int x, int y, int chargeFrames, int chargeMaxSize)
		{
			Audio->PlaySound(SFX_CHARGE);
						
			// Charge animation
			for(int i = 0; i < chargeFrames; ++i)
			{
				Screen->Circle(4, x + Rand(-2, 2), y + Rand(-2, 2), (i / chargeFrames) * chargeMaxSize, Choose(C_CHARGE1, C_CHARGE2, C_CHARGE3), 1, 0, 0, 0, true, OP_OPAQUE);
				Waitframe(this, vars);
			}
		}
		
		void Splash(int x, int y)
		{
			lweapon l;
			
			for(int i = 0; i < 5; ++i)
			{
				for(int j=1; j<=2; ++j)
				{
					l = CreateLWeaponAt(LW_SPARKLE, x - 4 - 4 * i, y);
					l->UseSprite(SPR_SPLASH);
					l->ASpeed += Rand(3);
					l->Step = Rand(100, 200)*j*0.5;
					l->Angular = true;
					l->Angle = DegtoRad( - 90 - 5 - 15 * i + Rand(-5, 5));
					l->CollDetection = false;
					
					l = CreateLWeaponAt(LW_SPARKLE, x + 4 + 4 * i, y);
					l->UseSprite(SPR_SPLASH);
					l->ASpeed += Rand(3);
					l->Step = Rand(100, 200)*j*0.5;
					l->Angular = true;
					l->Angle = DegtoRad( - 90 + 5 + 15 * i + Rand(-5, 5));
					l->CollDetection = false;
					l->Flip = 1;
				}
			}
		}
		
		void Waitframe(npc this, untyped vars, int frames)
		{
			for(int i = 0; i < frames; ++i)
				Waitframe(this, vars);
		}	
		
		void UpdateWaterfallBitmap()
		{
			int cmb;
			waterfall_bmp->Clear(0);
			int ptr[5 * 22];
			for(int i = 0; i < 11; ++i)
			{
				cmb = CMB_WATERFALL;
				if(i == 0)
					cmb = CMB_WATERFALL + 1;
				waterfall_bmp->FastCombo(0, 0, 16 * i, cmb, CS_WATERFALL, 128);
				
				cmb = CMB_WATERFALL + 2;
				if(i == 10)
					cmb = CMB_WATERFALL + 3;
				waterfall_bmp->FastCombo(0, 16, 16 * i, cmb, CS_WATERFALL, 128);
			}
		}
		
		void Waitframe(npc this, untyped vars)
		{
			this->DrawYOffset = -1000;
			this->Stun = 10;
			this->Immortal = true;
			
			if(vars[VARS_FLIP])
				this->HitXOffset = 32;
			else
				this->HitXOffset = 64;
		
			if(this->Y+this->HitYOffset+this->HitHeight-1 <= 112 && vars[VARS_FLASHTIMER] == 0)
				this->CollDetection = true;
			else
				this->CollDetection = false;
			
			npc head = <npc>vars[VARS_HEADNPC];
			
			if(head->isValid())
			{
				if(head->Y+head->HitYOffset+head->HitHeight-1 <= 112 && vars[VARS_FLASHTIMER] == 0)
					head->CollDetection = true;
				else
					head->CollDetection = false;
					
				head->DrawYOffset = -1000;
				head->Stun = 10;
				
				if(vars[VARS_FLIP])
					vars[VARS_HEADCX] = this->X + 16 + 12;
				else
					vars[VARS_HEADCX] = this->X + 104 + 12;
				
				vars[VARS_HEADCY] = this->Y + 48 + 8;
				head->X = vars[VARS_HEADCX] - 12;
				head->Y = vars[VARS_HEADCY] - 8;
				head->HitWidth = 24;
				head->HitHeight = 16;
				
				if(head->HP < 1000)
				{
					this->HP -= 1000 - head->HP;
					head->HP = 1000;
				}
			}
			
			if(vars[VARS_BODYHP]!=this->HP)
			{
				if(vars[VARS_BODYHP]>this->HP)
					vars[VARS_FLASHTIMER] = 32;
				
				vars[VARS_BODYHP] = this->HP;
			}
			
			if(this->HP<=0)
				DeathAnim(this, vars);
			WaitframeLite(this, vars);
		}
		
		void WaitframeLite(npc this, untyped vars)
		{
			int cset = this->CSet;
			if(vars[VARS_FLASHTIMER])
				cset = 9-(vars[VARS_FLASHTIMER]>>1);
			
			if(vars[VARS_FLASHTIMER])
				--vars[VARS_FLASHTIMER];
			
			Screen->DrawTile(0, this->X, this->Y, this->OriginalTile, 9, 6, cset, -1, -1, 0, 0, 0, vars[VARS_FLIP], 1, 128);
			
			UpdateWaterfallBitmap();
			Waitframe();
		}
		
		void DeathAnim(npc this, untyped vars)
		{
			npc head = vars[VARS_HEADNPC];
			Remove(head);
			this->CollDetection = false;
			
			int i;
			int x = this->X;

			Screen->Message(MSG_BEATEN);
			vars[VARS_FLASHTIMER] = 0;
			WaitframeLite(this, vars);
			
			while(this->Y<112)
			{
				this->Y += 0.5;
				++i;
				i %= 360;
				this->X = x+12*Sin(i*8);
				Audio->PlaySound(SFX_RISE);
				Screen->Quake = 20;
				WaitframeLite(this, vars);
			}
			
			Hero->WarpEx({WT_IWARPOPENWIPE, 2, 11, -1, WARP_A, WARPEFFECT_OPENWIPE, 0, 0, DIR_LEFT});
				
			this->Immortal = false;
			this->Remove();

		}
	} //end
	
	//~~~~~Leviathan1_Waterfall~~~~~//
	eweapon script Waterfall //start
	{
		void run(int width, int peakHeight)
		{
			TraceS("Start eweapon Waterfall \n");
		
			this->UseSprite(94);
			
			int i;
			int x;
			if(!waterfall_bmp->isAllocated())
			{
				if(DEBUG)
					printf("Waterfall bitmap is not initialized!\n");
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
	
} 

//end

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

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Enemy~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//start

//~~~~~Constants/globals~~~~~//


//~~~~~~~~~~~~~~~~~~~//



//end

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Misc Functions~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

// Function to get the difference between two angles
float AngDiff(float angle1, float angle2) //start
{
	// Get the difference between the two angles
	float dif = angle2 - angle1;
	
	// Compensate for the difference being outside of normal bounds
	if(dif >= 180)
		dif -= 360;
	else if(dif <= -180)
		dif += 360;
		
	return dif;
}
//end

// Function to turn one angle towards another angle by a fixed amount
float TurnToAngle(float angle1, float angle2, float step) //start
{
	if(Abs(AngDiff(angle1, angle2)) > step)
		return angle1 + Sign(AngDiff(angle1, angle2)) * step;
	else
		return angle2;
}
//end
//}

// Function to set Screen->D
void setScreenD(int reg, bool state) //start
{
	#option BINARY_32BIT on
	
	int d = Div(reg, 32);
	reg %= 32;
	
	if (state)
		Screen->D[d] |= 1b<<reg;
	else
		Screen->D[d] ~= 1b<<reg;
	
}
//end

// Function to get Screen->D
bool getScreenD(int reg) //start
{
	#option BINARY_32BIT on
	
	int d = Div(reg, 32);
	reg %= 32;
	
	return Screen->D[d] & (1b<<reg);
	
}
//end

// Function to set Screen->D
void setScreenD(int d, int bit, bool state) //start
{
	#option BINARY_32BIT on
	
	if (state)
		Screen->D[d] |= bit;
	else
		Screen->D[d] ~= bit;
}
//end

// Function to get Screen->D
int getScreenD(int d, int bit) //start
{
	#option BINARY_32BIT on
	
	return Screen->D[d] & bit;
}
//end

// Converts an 18 bit value to a 32 bit value
int convertBit(int b18) 
{
	return b18 / 10000;
}

ScreenType getScreenType(bool dmapOnly)//start
{
	unless(dmapOnly)
	{
		if(IsDungeonFlag())return DM_DUNGEON;
		if(IsInteriorFlag())return DM_INTERIOR;
	}
	dmapdata dm = Game->LoadDMapData(Game->GetCurDMap());
	return <ScreenType> (dm->Type & 11b);
}//end





















