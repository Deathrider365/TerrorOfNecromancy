///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~~~~~~The Terror of Necromancy Scripts~~~~~~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

/*
phantom from the messenger be in the game. In his search to revive Muse, his lover, he come across the necromancer whom
he hears can bring back those who had died. He tasks phantom to kill link in order to help him. 
he will have all the same attacks, sfx, and boss music from the messenger. Have him refer to whatever it was he needed
to get to the music box or whatever since this is before he is trapped there. Have the music that plays outside his boss room play
when you enter the room where you encounter him. and have the sound of hitting him be the same as from the game, basically
mimic to messenger entirely. Find a way to have him drop venser's cane. This will replace the hall of memories from IoR. Perhaps he encounters
link after he killed venser and killed him for venser's cane. For phantom kknew venser as an old friend that attempted to help him
but couldnt help him as much because of the events of IoR
*/

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
import "std.zh"
import "ffcscript.zh"
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
	C_TRANS = 0x00,
	C_BLACK = 0x08,
	C_WHITE = 0x0C,
	C_RED = 0x04,
	C_BLUE = 0x1F,
	C_TAN = 0x75,
	C_SEABLUE = 0x76,
	C_DARKBLUE = 0x77
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

int onContHP = 0;
int onContMP = 0;

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
			
		int frame;
		
		while(true)
		{
			//checkItemCycle();
			//checkDungeon();
			//bitmaps::updatefreed();
			Waitframe();
		}
	}
	
	//~~~~~ItemCycling~~~~~//
	void checkItemCycle()
	{
	    if (Link->PressL) Link->SelectBWeapon(DIR_LEFT);
		if (Link->PressR) Link->SelectBWeapon(DIR_RIGHT);
	}
	
	//~~~~~DungeonMap~~~~~//
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
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Free Form Combos~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//start
//~~~~~Constants/globals~~~~~//
//start
const int COMPASS_BEEP = 93; //Set this to the SFX id you want to hear when you have the compass,

const int COMPASS_SFX = 93; 			//Set this to the SFX id you want to hear when you have the compass.

CONFIG CB_SIGNPOST = CB_A;				//Button to press to read a sign

const int SFX_SWITCH_PRESS = 0; 		//SFX when a switch is pressed
const int SFX_SWITCH_RELEASE = 0; 		//SFX when a switch is released
const int SFX_SWITCH_ERROR = 62; 		//SFX when the wrong switch is pressed

const int ICE_BLOCK_SCRIPT = 1; 		// Slot number that the ice_block script is assigned to
const int ICE_BLOCK_SENSITIVITY = 8; 	// Number of frames the blocks need to be pushed against to begin moving
//end

//~~~~~SwitchPressed (used for switch scripts)~~~~~//
//start
int SwitchPressed(int x, int y, bool noLink)
{
	int xOff = 0;
	int yOff = 4;
	int xDist = 8;
	int yDist = 8;
	
	if (Abs(Link->X + xOff - x) <= xDist && Abs(Link->Y + yOff - y) <= yDist && Link->Z == 0 && !noLink)
		return 1;
		
	if (Screen->MovingBlockX>-1)
		if (Abs(Screen->MovingBlockX - x) <= 8 && Abs(Screen->MovingBlockY - y) <= 8)
			return 1;

	if(Screen->isSolid(x + 4, y + 4) || Screen->isSolid(x + 12, y + 4) || Screen->isSolid(x + 4, y + 12) || Screen->isSolid(x + 12, y + 12))
		return 2;
		
	return 0;
}
//end
//~~~~~~~~~~~~~~~~~~~//

//~~~~~BossNameString~~~~~//
//D0: String number
//start
ffc script BossNameString
{
    void run(int string)
    {
		Waitframes(4);
		if (EnemiesAlive())
			Screen->Message(string);
    }
}

//end

//~~~~~CompassBeep~~~~~//
//start
ffc script CompassBeep
{
     void run()
	 {
          if(!Screen->State[ST_ITEM] && !Screen->State[ST_CHEST] && !Screen->State[ST_LOCKEDCHEST] && !Screen->State[ST_BOSSCHEST] && 
			 !Screen->State[ST_SPECIALITEM] && (Game->LItems[Game->GetCurLevel()] & LI_COMPASS))
			 Audio->PlaySound(COMPASS_BEEP);
     }
}
//end

//~~~~~OpenForItem~~~~~//
//D0: Item number to check for
//D1: 0 for non-perm, 1 for perm
//start
ffc script OpenForItemID
{
    void run(int itemid, bool perm)
    {
        if(Screen->State[ST_SECRET]) 
			Quit();
        while(true)
        {
            if(Link->Item[itemid])
            {
                Screen->TriggerSecrets();
				
                if(perm) 
					Screen->State[ST_SECRET] = true;
					
                return;
            }
            Waitframe();
        }
    }
}
//end

//~~~~~BossMusic~~~~~//
//D0: Number of dmap to play music for
//start
ffc script BossMusic
{
	void run(int dmap)
	{
		int bossMusic[256];
		int areamusic[256];
		
		if (Screen->State[ST_SECRET])
			Quit();
			
		Waitframes(4);
		Game->GetDMapMusicFilename(dmap, bossMusic);
		Audio->PlayEnhancedMusic(bossMusic, 0);
		
		while(ScreenEnemiesAlive())
			Waitframe();

		Game->GetDMapMusicFilename(Game->GetCurDMap(), areamusic);
		Audio->PlayEnhancedMusic(areamusic, 0);
	}
	
	bool ScreenEnemiesAlive()
	{
		for(int i = Screen->NumNPCs(); i >= 1; i--)
		{
			npc n = Screen->LoadNPC(i);
			
			if(n->Type != NPCT_PROJECTILE && n->Type != NPCT_FAIRY && n->Type != NPCT_TRAP && n->Type != NPCT_GUY)
				if(!(n->MiscFlags&(1<<3)))
					return true;
		}
		
		return false;
	}
}

//end

//~~~~~Leviathan1Cabin~~~~~//
//D0: Number of dmap to play music for
//start
ffc script Leviathan1Cabin
{
	void run()
	{
		Audio->PlayEnhancedMusic("WW - Ship Theme.ogg", 0);
	}
}
//end

//~~~~~MessageThenWarp~~~~~//
//D0: Message number to show
//D1: Dmap to warp Link to
//D2: Screen on the specified dmap to warp Link to
//start
ffc script MessageThenWarp
{	
    void run(int msg, int dmap, int scr)
    {
		NoAction();
		Link->PressStart = false;
		Link->InputStart = false;
		Link->PressMap = false;
		Link->InputMap = false;
		Screen->Message(msg);
		Waitframe();
		Hero->WarpEx({WT_IWARPBLACKOUT, dmap, scr, -1, WARP_A, WARPFX_NONE, 0, 0, DIR_DOWN});
    }
}
//end

//~~~~~ScreenBeforeLeviathan1~~~~~//
//D0: Message number to show
//D1: Dmap to warp Link to
//D2: Screen on the specified dmap to warp Link to
//start
ffc script ScreenBeforeLeviathan1
{	
    void run(int msg, int dmap, int scr, int timeUntilWarp)
    {
		Audio->PlayEnhancedMusic("WW - The Great Sea.ogg", 0);
		int timer = 0;
		while(true)
		{
			++timer;
			Waitframe();
			
			if (timer == timeUntilWarp)
			{
				NoAction();
				Link->PressStart = false;
				Link->InputStart = false;
				Link->PressMap = false;
				Link->InputMap = false;
				Screen->Message(msg);
				Waitframe();
				
				for (int i = 0; i < 240; ++i)
				{
					if(i % 60 == 0)
					{
						Screen->Quake = 20;
						Audio->PlaySound(SFX_RISE);
					}
					Waitframe();
				}
				
				Screen->Message(msg + 1);
				Waitframe();
				
				Hero->WarpEx({WT_IWARPOPENWIPE, dmap, scr, -1, WARP_A, WARPEFFECT_OPENWIPE, 0, 0, DIR_UP});
				
			}
		}
    }
}
//end

//~~~~~NormalString~~~~~//
//D0: Number of string to show
//start
ffc script NormalString
{
    void run(int m)
    {
		Waitframes(2);
		Screen->Message(m);
    }
}

//end

//~~~~~TradeGuy~~~~~//	In progress
//start
ffc script TradeGuy
{
    void run(int item, int nextString, int defaultString)
    {
		//if (link x and y are next to the NPC)
		//	if (link has correct item in sequence)
		//		Screen->Message(nextString);
		//	else
		//		Screen->Message(defaultString);
    }
}

//end

//~~~~~SignPost~~~~~//
//D0: Number of string to show
//D1: 0 for not anyside 1 for anyside
//start
ffc script Signpost
{
    void run(int msg, bool anySide)
	{
        int loc = ComboAt(this->X, this->Y);
        
		while(true)
		{
            until(AgainstComboBase(loc, anySide) && Input->Press[CB_SIGNPOST]) 
			{
				if (AgainstComboBase(loc, anySide))
					Screen->FastTile(7, Link->X - 10, Link->Y - 15, 1284, 0, OP_OPAQUE);
					
				Waitframe();
			}
			
			Input->Button[CB_SIGNPOST] = false;
            Screen->Message(msg);
            Waitframe();
        }
    }
	
	bool AgainstComboBase(int loc, bool anySide)
	{
		if(Hero->Z) 
			return false;
			
		if(Hero->BigHitbox && !anySide)
			return (Hero->Dir == DIR_UP && Hero->Y == ComboY(loc) + 16 && Abs(Hero->X-ComboX(loc)) < 8);
		else unless(Hero->BigHitbox||anySide)
			return (Hero->Dir == DIR_UP && Hero->Y == ComboY(loc) + 8 && Abs(Hero->X-ComboX(loc)) < 8);
		else if (Hero->BigHitbox && anySide)
			return ((Hero->Dir == DIR_UP && Hero->Y == ComboY(loc) + 16 && Abs(Hero->X-ComboX(loc)) < 8)
			|| (Hero->Dir == DIR_DOWN && Hero->Y == ComboY(loc) - 16 && Abs(Hero->X-ComboX(loc)) < 8) 
			|| (Hero->Dir == DIR_LEFT && Hero->X == ComboX(loc) + 16 && Abs(Hero->Y-ComboY(loc)) < 8)
			|| (Hero->Dir == DIR_RIGHT && Hero->X == ComboX(loc) - 16 && Abs(Hero->Y-ComboY(loc)) < 8));
		else if (!Hero->BigHitbox && anySide)
			return ((Hero->Dir == DIR_UP && Hero->Y == ComboY(loc) + 8 && Abs(Hero->X-ComboX(loc)) < 8) 
			|| (Hero->Dir == DIR_DOWN && Hero->Y == ComboY(loc) - 16 && Abs(Hero->X-ComboX(loc)) < 8) 
			|| (Hero->Dir == DIR_LEFT && Hero->X == ComboX(loc) + 16 && Abs(Hero->Y-ComboY(loc)) < 8)
			|| (Hero->Dir == DIR_RIGHT && Hero->X == ComboX(loc) - 16 && Abs(Hero->Y-ComboY(loc)) < 8));
		else 
			return false;
	}
}

//end

//~~~~~SwitchSecret~~~~~//
//D0: Set to 1 to make the secret permanent
//D1: Set to the switch's ID if the secret is tiered, 0 otherwise.
//D2: If > 0, specifies a special secret sound. 0 for default, -1 for silent.
//start
ffc script SwitchSecret
{
	void run(int perm, int id, int sfx)
	{
		int d;
		int db;
		
		if(id > 0)
		{
			d = Floor((id - 1) / 16);
			db = 1<<((id - 1) % 16);
		}
		
		if(perm)
		{
			if(id > 0)
			{
				if(Screen->D[d] & db)
				{
					this->Data++;
					Screen->TriggerSecrets();
					Quit();
				}
			}
			else if(Screen->State[ST_SECRET])
			{
				this->Data++;
				Quit();
			}
		}
		
		while(!SwitchPressed(this->X, this->Y, false))
			Waitframe();
			
		this->Data++;
		Screen->TriggerSecrets();
		Audio->PlaySound(SFX_SWITCH_PRESS);
		
		if(sfx == 0)
			Audio->PlaySound(SFX_SECRET);
		else if(sfx > 0)
			Audio->PlaySound(sfx);
			
		if(perm)
		{
			if(id > 0)
				Screen->D[d] |= db;
			else
				Screen->State[ST_SECRET] = true;
		}
	}
}
//end

//~~~~~SwitchRemote~~~~~//
//D0: Set to 1 to make the switch a pressure switch (a block or Link must stay on it to keep it triggered). 
//    Set to 2 to make it a pressure switch that only reacts to push blocks.
//D1: Set to the switch's ID. 0 if the secret is temporary or the switch is pressure triggered.
//D2: Set to the flag that specifies the region for the remote secret.
//D3: If > 0, specifies a special secret sound. 0 for default, -1 for silent.
//start
ffc script SwitchRemote
{
	void run(int pressure, int id, int flag, int sfx)
	{
		bool noLink;
		
		if(pressure == 2)
		{
			pressure = 1;
			noLink = true;
		}
		
		int data = this->Data;
		int i; int j; int k;
		int d;
		int db;
		
		if(id > 0)
		{
			d = Floor((id - 1) / 16);
			db = 1<<((id - 1) % 16);
		}
		
		int comboD[176];
		
		for(i = 0; i < 176; i++)
			if(Screen->ComboF[i]==flag)
			{
				comboD[i] = Screen->ComboD[i];
				Screen->ComboF[i] = 0;
			}

		if(id > 0)
		{
			if(Screen->D[d] & db)
			{
				this->Data = data + 1;
				for(i = 0; i < 176; i++)
					if(comboD[i] > 0)
						Screen->ComboD[i] = comboD[i] + 1;
				Quit();
			}
		}
		
		if(pressure)
		{
			while(true)
			{
				while(!SwitchPressed(this->X, this->Y, noLink))
					Waitframe();
				
				this->Data = data + 1;
				Audio->PlaySound(SFX_SWITCH_PRESS);
				
				for(i = 0; i < 176; i++)
					if(comboD[i] > 0)
						Screen->ComboD[i] = comboD[i] + 1;
						
				while(SwitchPressed(this->X, this->Y, noLink))
					Waitframe();
				
				this->Data = data;
				Audio->PlaySound(SFX_SWITCH_RELEASE);
				
				for(i=0; i<176; i++)
					if(comboD[i]>0)
						Screen->ComboD[i] = comboD[i];
			}
		}
		
		else
		{
			while(!SwitchPressed(this->X, this->Y, noLink))
				Waitframe();
			
			this->Data = data + 1;
			Audio->PlaySound(SFX_SWITCH_PRESS);
			
			if(sfx > 0)
				Audio->PlaySound(sfx);
			else
				Audio->PlaySound(SFX_SECRET);
				
			for(i = 0; i < 176; i++)
				if(comboD[i] > 0)
					Screen->ComboD[i] = comboD[i]+1;

			if(id > 0)
				Screen->D[d] |= db;
		}
	}
}
//end

//~~~~~SwitchHitAll~~~~~//
//D0: Set this to the combo number used for the unpressed switches.
//D1: Set to 1 to make the switch a pressure switch (a block or Link must stay on it to keep it triggered). 
//    Set to 2 to make it a pressure switch that only reacts to push blocks.
//D2: Set to 1 to make the secret that's triggered permanent.
//D3: Set to the controller's ID. Set to 0 if the switch is temporary or you're using screen secrets.
//D4: Set to the flag that specifies the region for the remote secret. If you're using screen secrets instead of remote ones, this can be ignored.
//D5: If > 0, specifies a special secret sound. 0 for default, -1 for silent.
//D6: If you want the script to remember which switches were pressed after leaving the screen, set to the starting ID for the group of switches. This will 
//	  reference this ID as well as the next n-1 ID's after that where n is the number of switches in the group. Be careful to thoroughly test that this doesn't 
//    bleed into other switch ID's or Screen->D used by other scripts. If you don't want to save the switches' states or the switches are pressure switches, this should be 0.
//start
ffc script SwitchHitAll
{
	void run(int switchCmb, int pressure, int perm, int id, int flag, int sfx, int switchID)
	{
		bool noLink;
		
		if(pressure == 2)
		{
			pressure = 1;
			noLink = true;
		}
		
		int i; int j; int k;
		int d;
		int db;
		
		if(flag == 0)
			id = 0;
			
		int comboD[176];
		
		if(id > 0)
		{
			d = Floor((id - 1) / 16);
			db = 1<<((id - 1) % 16);
			for(i = 0; i < 176; i++)
				if(Screen->ComboF[i] == flag)
				{
					comboD[i] = Screen->ComboD[i];
					Screen->ComboF[i] = 0;
				}
		}
		
		int switches[34];
		int switchD[34];
		int switchDB[34];
		switchD[0] = switchID;
		bool switchesPressed[34];
		k = SizeOfArray(switches) - 2;
		
		for(i = 0; i < 176 && switches[0] < k; i++)
			if(Screen->ComboD[i]==switchCmb)
			{
				j = 2 + switches[0];
				switches[j] = i;
				
				if(!pressure && switchID > 0)
				{
					switchD[j] = Floor((switchID + switches[0] - 1) / 16);
					switchDB[j] = 1<<((switchID + switches[0] - 1) % 16);
					if(Screen->D[switchD[j]] & switchDB[j])
					{
						switchesPressed[j] = true;
						Screen->ComboD[i] = switchCmb + 1;
						switches[1]++;
					}
				}
				
				switches[0]++;
			}
			
		if(perm)
		{
			if(id > 0)
				if(Screen->D[d] & db)
				{
					for(i = 2; i < switches[0] + 2; i++)
					{
						Screen->ComboD[switches[i]] = switchCmb + 1;
						switchesPressed[i] = true;
					}
					
					for(i = 0; i < 176; i++)
						if(comboD[i]>0)
							Screen->ComboD[i] = comboD[i] + 1;

					while(true)
					{
						SwitchesUpdate(switches, switchD, switchDB, switchesPressed, switchCmb, false, noLink);
						Waitframe();
					}
				}
			
			if(Screen->State[ST_SECRET])
			{
				for(i = 2; i < switches[0] + 2; i++)
				{
					Screen->ComboD[switches[i]] = switchCmb + 1;
					switchesPressed[i] = true;
				}
				
				while(true)
				{
					SwitchesUpdate(switches, switchD, switchDB, switchesPressed, switchCmb, false, noLink);
					Waitframe();
				}
			}
		}
		
		if(pressure)
		{
			while(switches[1] < switches[0])
			{
				SwitchesUpdate(switches, switchD, switchDB, switchesPressed, switchCmb, true, noLink);
				Waitframe();
			}
			
			if(id > 0)
			{
				if(sfx > 0)
					Audio->PlaySound(sfx);
				else
					Audio->PlaySound(SFX_SECRET);
				for(i = 0; i < 176; i++)
					if(comboD[i] > 0)
						Screen->ComboD[i] = comboD[i] + 1;
			}
			else
			{
				if(sfx > 0)
					Audio->PlaySound(sfx);
				else
					Audio->PlaySound(SFX_SECRET);
				Screen->TriggerSecrets();
			}
			
			if(perm)
			{
				if(id > 0)
					Screen->D[d] |= db;
				else
					Screen->State[ST_SECRET] = true;
			}
		}
		else
		{
			while(switches[1] < switches[0])
			{
				SwitchesUpdate(switches, switchD, switchDB, switchesPressed, switchCmb, false, noLink);
				Waitframe();
			}
			
			if(id > 0)
			{
				if(sfx > 0)
					Audio->PlaySound(sfx);
				else
					Audio->PlaySound(SFX_SECRET);
					
				for(i = 0; i < 176; i++)
					if(comboD[i] > 0)
						Screen->ComboD[i] = comboD[i] + 1;
			}
			else
			{
				if(sfx > 0)
					Audio->PlaySound(sfx);
				else
					Audio->PlaySound(SFX_SECRET);
					
				Screen->TriggerSecrets();
			}
			
			if(perm)
			{
				if(id > 0)
					Screen->D[d] |= db;
				else
					Screen->State[ST_SECRET] = true;
			}
		}
		
		while(true)
		{
			SwitchesUpdate(switches, switchD, switchDB, switchesPressed, switchCmb, false, noLink);
			Waitframe();
		}
	}
	
	void SwitchesUpdate(int switches, int switchD, int switchDB, bool switchesPressed, int switchCmb, bool pressure, bool noLink)
	{
		if(pressure)
			switches[1] = 0;
			
		for(int i = 0; i < switches[0]; i++)
		{
			int j = i + 2;
			int k = switches[j];
			int p = SwitchPressed(ComboX(k), ComboY(k), noLink);
			
			if(p)
			{
				if(p != 2)
					Screen->ComboD[k] = switchCmb + 1;
					
				if(!switchesPressed[j])
				{
					Audio->PlaySound(SFX_SWITCH_PRESS);
					
					if(switchD[0] > 0)
						Screen->D[switchD[j]] |= switchDB[j];
					
					switchesPressed[j] = true;
					if(!pressure)
						switches[1]++;
				}
				
				if(pressure)
					switches[1]++;
			}
			else
			{
				if(switchesPressed[j])
				{
					if(pressure)
					{
						Audio->PlaySound(SFX_SWITCH_RELEASE);
						Screen->ComboD[k] = switchCmb;
						switchesPressed[j] = false;
					}
					else
						if(Screen->ComboD[k] != switchCmb + 1)
							Screen->ComboD[k] = switchCmb + 1;
				}
			}
		}
	}
}
//end

//~~~~~SwitchTrap~~~~~//
//D0: Set to the ID of the enemy to drop in
//D1: Set to the number of enemies to drop
//start
ffc script SwitchTrap
{
	void run(int enemyid, int count)
	{
		while(!SwitchPressed(this->X, this->Y, false))
			Waitframe();
		
		this->Data++;
		Audio->PlaySound(SFX_SWITCH_PRESS);
		Audio->PlaySound(SFX_SWITCH_ERROR);
		
		for(int i = 0; i < count; i++)
		{
			int pos = SwitchGetSpawnPos();
			npc n = CreateNPCAt(enemyid, ComboX(pos), ComboY(pos));
			Audio->PlaySound(SFX_FALL);
			n->Z = 176;
			Waitframes(20);
		}
	}
	
	int SwitchGetSpawnPos()
	{
		int pos;
		bool invalid = true;
		int failSafe = 0;
		
		while(invalid && failSafe < 512)
		{
			pos = Rand(176);
			if(SwitchValidSpawn(pos))
				return pos;
		}
		
		for(int i = 0; i < 176; i++)
		{
			pos = i;
			if(SwitchValidSpawn(pos))
				return pos;
		}
	}
	
	bool SwitchValidSpawn(int pos)
	{
		int x = ComboX(pos);
		int y = ComboY(pos);
		
		if(Screen->isSolid(x + 4, y + 4) || Screen->isSolid(x + 12, y + 4) || Screen->isSolid(x + 4, y + 12) || Screen->isSolid(x + 12, y + 12))
			return false;
		
		if(ComboFI(pos, CF_NOENEMY) || ComboFI(pos, CF_NOGROUNDENEMY))
			return false;
		
		int ct = Screen->ComboT[pos];
		
		if(ct == CT_NOENEMY || ct == CT_NOGROUNDENEMY || ct == CT_NOJUMPZONE)
			return false;
			
		if(ct == CT_WATER || ct == CT_LADDERONLY || ct == CT_HOOKSHOTONLY || ct == CT_LADDERHOOKSHOT)
			return false;
			
		if(ct == CT_PIT || ct == CT_PITB || ct == CT_PITC || ct == CT_PITD || ct == CT_PITR)
			return false;
			
		return true;
	}
}
//end

//~~~~~SwitchSequential~~~~~//
//D0: Set this to the flag marking all the switches on the screen. The order the switches have to be hit in will be determined by their combo numbers.
//D1: Set to 1 to make the secret that's triggered permanent.
//D2: If > 0, specifies a special secret sound. 0 for default, -1 for silent.
//start
ffc script SwitchSequential
{
	void run(int flag, int perm, int sfx)
	{
		int i; int j; int k;
		int switches[34];
		int switchCmb[34];
		int switchMisc[8];
		bool switchesPressed[34];
		k = SizeOfArray(switches) - 2;
		
		for(i = 0; i < 176 && switches[0] < k; i++)
			if(Screen->ComboF[i] == flag)
			{
				j = 2 + switches[0];
				switches[j] = i;
				switchCmb[j] = Screen->ComboD[i];
				switches[0]++;
			}
		
		int switchOrder[34];
		SwitchesOrganize(switches, switchOrder);
		
		if(perm && Screen->State[ST_SECRET])
		{
			for(i = 0; i < switches[0]; i++)
				switchesPressed[i + 2] = true;
			
			while(true)
			{
				SwitchesUpdate(switches, switchesPressed, switchOrder, switchCmb, switchMisc, false);
				Waitframe();
			}
		}
		
		while(switches[1] < switches[0])
		{
			SwitchesUpdate(switches, switchesPressed, switchOrder, switchCmb, switchMisc, true);
			
			if(switchMisc[0] == 1)
			{
				switchMisc[0] = 0;
			
				for(i = 0; i < 30; i++)
				{
					SwitchesUpdate(switches, switchesPressed, switchOrder, switchCmb, switchMisc, false);
					Waitframe();
				}
				
				while(SwitchesLinkOn(switches))
				{
					SwitchesUpdate(switches, switchesPressed, switchOrder, switchCmb, switchMisc, false);
					Waitframe();
				}
			}
			
			Waitframe();
		}
		
		if(sfx > 0)
			Audio->PlaySound(sfx);
		else
			Audio->PlaySound(SFX_SECRET);
		
		Screen->TriggerSecrets();
		
		if(perm)
			Screen->State[ST_SECRET] = true;
		
		for(i = 0; i < switches[0]; i++)
			switchesPressed[i+2] = true;
		
		while(true)
		{
			SwitchesUpdate(switches, switchesPressed, switchOrder, switchCmb, switchMisc, false);
			Waitframe();
		}
	}
	
	void SwitchesOrganize(int switches, int switchOrder)
	{
		bool banned[34];
		
		for(int j = 0; j < switches[0]; j++)
		{
			int lowest = -1;
			int lowestIndex = -1;
		
			for(int i = 0; i < switches[0]; i++)
			{
				int c = Screen->ComboD[switches[i + 2]];
				
				if(c != -1 && !banned[i + 2])
					if(lowest == -1 || c < lowest)
					{
						lowest = c;
						lowestIndex = i + 2;
					}
			}
			
			switchOrder[j] = lowestIndex;
			banned[lowestIndex] = true;
		}
	}
	
	bool SwitchesLinkOn(int switches)
	{
		for(int i = 0; i < switches[0]; i++)
		{
			int j = i + 2;
			int k = switches[j];
			int p = SwitchPressed(ComboX(k), ComboY(k), false);
			
			if(p == 1)
				return true;
		}
		
		return false;
	}
	
	void SwitchesUpdate(int switches, bool switchesPressed, int switchOrder, int switchCmb, int switchMisc, bool canPress)
	{
		bool reset;
	
		for(int i = 0; i < switches[0]; i++)
		{
			int j = i + 2;
			int k = switches[j];
			int p = SwitchPressed(ComboX(k), ComboY(k), false);
			
			if(!switchesPressed[j])
			{
				if(p != 2)
					Screen->ComboD[k] = switchCmb[j];
				
				if(p && canPress)
				{
					if(j == switchOrder[switches[1]])
					{
						switches[1]++;
						Audio->PlaySound(SFX_SWITCH_PRESS);
						switchesPressed[j] = true;
					}
					else
					{
						switches[1] = 0;
						Audio->PlaySound(SFX_SWITCH_ERROR);
						reset = true;
					}
				}
			}
			else
			{
				if(p != 2)
					Screen->ComboD[k] = switchCmb[j] + 1;
				
				if(p == 0 && canPress)
				{
					Audio->PlaySound(SFX_SWITCH_RELEASE);
					switchesPressed[j] = false;
				}
			}
		}
		
		if(reset)
		{
			switchMisc[0] = 1;
			
			for(int i = 0; i < switches[0]; i++)
			{
				int j = i + 2;
				int k = switches[j];
				int p = SwitchPressed(ComboX(k), ComboY(k), false);
				switchesPressed[j] = false;
			}
		}
	}
}
//end

//~~~~~IceBlock~~~~~//
//start
ffc script IceBlock 
{
	void run() 
	{
		int undercombo;
		int framecounter = 0;

		Waitframe();
		undercombo = Screen->ComboD[this->Y + (this->X >> 4)];
		Screen->ComboD[this->Y + (this->X >> 4)] = this->Data;

		while(true) 
		{
			// Check if Link is pushing against the block
			if((Link->X == this->X - 16 && (Link->Y < this->Y + 1 && Link->Y > this->Y - 12) && Link->InputRight && Link->Dir == DIR_RIGHT) || 	// Right
			(Link->X == this->X + 16 && (Link->Y < this->Y + 1 && Link->Y > this->Y - 12) && Link->InputLeft && Link->Dir == DIR_LEFT) || 		// Left
			(Link->Y == this->Y - 16 && (Link->X < this->X + 4 && Link->X > this->X - 4) && Link->InputDown && Link->Dir == DIR_DOWN) || 		// Down
			(Link->Y == this->Y + 8 && (Link->X < this->X + 4 && Link->X > this->X - 4) && Link->InputUp && Link->Dir == DIR_UP)) 				// Up
			{ 			
				framecounter++;
			}
			else 
				framecounter = 0;	// Reset the frame counter
		
			// Once enough frames have passed, move the block
		
			if(framecounter >= ICE_BLOCK_SENSITIVITY) 
			{
				// Check the direction
				if(Link->Dir == DIR_RIGHT) 
				{										// Not at the edge of the screen, Not "No Push Block", // Is walkable
					while(this->X < 240 && !ComboFI(this->X + 16, this->Y, CF_NOBLOCKS) && Screen->ComboS[this->Y + ((this->X + 16) >> 4)] == 0000b) 
					{ 														
						Screen->ComboD[this->Y + (this->X >> 4)] = undercombo;
						this->Vx = 2;
						WaitNoAction(8);
						undercombo = Screen->ComboD[this->Y + (this->X >> 4)];
					}
				
					this->Vx = 0;
					Screen->ComboD[this->Y + (this->X >> 4)] = this->Data;
				}
				else if(Link->Dir == DIR_LEFT) 
				{
					while(this->X > 0 && !ComboFI(this->X - 1, this->Y, CF_NOBLOCKS) && Screen->ComboS[this->Y + ((this->X - 16) >> 4)] == 0000b) 
					{ 															
						Screen->ComboD[this->Y + (this->X >> 4)] = undercombo;
						this->Vx = -2;
						WaitNoAction(8);
						undercombo = Screen->ComboD[this->Y + (this->X >> 4)];
					}
				
					this->Vx = 0;
					Screen->ComboD[this->Y + (this->X >> 4)] = this->Data;
				}
				else if(Link->Dir == DIR_DOWN) 
				{
					while(this->Y < 160 && !ComboFI(this->X, this->Y + 16, CF_NOBLOCKS) && Screen->ComboS[(this->Y + 16) + (this->X >> 4)] == 0000b) 
					{ 															
						Screen->ComboD[this->Y + (this->X >> 4)] = undercombo;
						this->Vy = 2;
						WaitNoAction(8);
						undercombo = Screen->ComboD[this->Y + (this->X >> 4)];
					}
				
					this->Vy = 0;
					Screen->ComboD[this->Y + (this->X >> 4)] = this->Data;
				}
				else if(Link->Dir == DIR_UP) 
				{
					while(this->Y > 0 && !ComboFI(this->X, this->Y - 1, CF_NOBLOCKS) && Screen->ComboS[(this->Y - 16) + (this->X >> 4)] == 0000b) 
					{ 														
						Screen->ComboD[this->Y + (this->X >> 4)] = undercombo;
						this->Vy = -2;
						WaitNoAction(8);
						undercombo = Screen->ComboD[this->Y + (this->X >> 4)];
					}
				
					this->Vy = 0;
					Screen->ComboD[this->Y + (this->X >> 4)] = this->Data;
				}
			
				framecounter = 0;		// Reset the frame counter
			}		
		}
		
		Waitframe();
	}
}
//end

//~~~~~IceTrigger~~~~~//
//start
ffc script IceTrigger 
{
	void run() 
	{
		ffc blocks[31];
		int triggerx[31];
		int triggery[31];
		int num_ice_blocks = 0;
		int num_triggers = 0;
		int good_counter = 0;

		for(int i = 0; i < 176 && num_triggers < 31; i++) 
		{
			if(Screen->ComboF[i] == CF_BLOCKTRIGGER || Screen->ComboI[i] == CF_BLOCKTRIGGER) 
			{
				triggerx[num_triggers] = (i % 16) * 16;
				triggery[num_triggers] = Floor(i / 16) * 16;
				num_triggers++;
			}
		}
		
		if(num_triggers == 0) 
			Quit();

		for(int i = 1; i <= 32; i++) 
		{
			ffc temp = Screen->LoadFFC(i);
			
			if(temp->Script == ICE_BLOCK_SCRIPT) 
			{
				blocks[num_ice_blocks] = temp;
				num_ice_blocks++;
			}
		}
		
		if(num_ice_blocks == 0) 
			Quit();

		while(true) 
		{
			for(int i = 0; i < num_ice_blocks; i++) 
			{
				//Check if blocks are on switches and not moving
				for(int j = 0; j < num_triggers; j++) 
				{
					if(blocks[i]->X == triggerx[j] && blocks[i]->Y == triggery[j] && blocks[i]->Vx == 0 && blocks[i]->Vy == 0) 
					{
						good_counter++;
						break;
					}
				}
			}
			
			if(good_counter == num_triggers) 
			{
				Audio->PlaySound(SFX_SECRET);
				Screen->TriggerSecrets();
				if((Screen->Flags[SF_SECRETS] & 2) == 0) Screen->State[ST_SECRET] = true;
					Quit();
			}
			
			good_counter = 0;
			Waitframe();
		}
	}
}
//end

//~~~~~sfxPlay~~~~~//
//D0: The sound effect to play.
//D1: How many frames to wait until the sound effect plays.
//D2: Set this to anything other than 0 to have the sound effect loop.
//start
ffc script sfxplay
{
    void run(int sound, int wait, int r)
	{
        if (r == 0)
		{
            Waitframes(wait);
            Audio->PlaySound(sound);
        }
        else
		{
            while(true)
			{
				Waitframes(wait);
				Audio->PlaySound(sound);
            }
        }
    }
}

//end


//~~~~~BattleArena1~~~~~//
//D0: Num of attempts until failure is determined
//D1: Dmap to warp to
//D2: screen to warp to
//start
ffc script BattleArena1
{
	void run()
	{

		//spawn enemies
		
		npc n = Screen->CreateNPC(37);
		n->X = 64;
		n->Y = 80;
		round();
		
		//spawn enemies
		round();
	}
	
	void round()
	{
		while(EnemiesAlive())
		{
			Waitframe();
		}
	}

}

//end

//~~~~~LeviathanFailureP1~~~~~//
//D0: Num of attempts until failure is determined
//D1: Dmap to warp to
//D2: screen to warp to
//start

const int D_DEATHS = 0;
const int MSG_LINK_BEATEN = 23;

ffc script LeviathanFailureP1
{
    void run(int numAttempts, int dmap, int scrn)
	{
		while (true)
		{
			if (Hero->HP <= 0)
			{
				++Screen->D[D_DEATHS];
				if (Screen->D[D_DEATHS] < numAttempts)
					Quit();
				else
				{
					Hero->HP = 1;
					Hero->Warp(dmap, scrn);					
				}	
			}
			Waitframe();
		}
    }
}

//end

//~~~~~LeviathanFailureP2~~~~~//
//D0: Dmap to warp to
//D1: screen to warp to

//start
ffc script LeviathanFailureP2 
{
    void run(int dmap, int scrn)
	{
		Screen->Message(MSG_LINK_BEATEN);
		
		for (int i = 0; i < 120; ++i)
		{					
			NoAction();
			Screen->DrawTile(0, 50, 32, 45760, 9, 6, 0, -1, -1, 0, 0, 0, 0, 1, 128);	
			Waitframe();
		}
		
		Hero->WarpEx({WT_IWARPOPENWIPE, dmap, scrn, -1, WARP_A, WARPEFFECT_OPENWIPE, 0, 0, DIR_UP});
    }
}

//end

//~~~~~Leviathan1Ending~~~~~//
//D0: Dmap to warp to
//D1: screen to warp to

//start
ffc script Leviathan1Ending 
{
	using namespace Leviathan;
	
    void run(int dmap, int scrn)
	{
	
		Audio->PlayEnhancedMusic(NULL, 0);
	
		if (waterfall_bmp && waterfall_bmp->isAllocated())
			waterfall_bmp->Free();
			
		waterfall_bmp = Game->CreateBitmap(32, 176);
		
		Leviathan1.UpdateWaterfallBitmap();
		
		Hero->Dir = DIR_UP;
		NoAction();
		
		Screen->Message(MSG_LINK_BEATEN + 1);
		
		// Buffer
		for (int i = 0; i < 60; ++i)
		{					
			NoAction();
			Screen->DrawTile(0, 16, 4, 45760, 9, 6, 0, -1, -1, 0, 0, 0, 0, 1, 128);
			Waitframe();			
		}
		
		// Rising
		for (int i = 0; i < 32; ++i)
		{					
			NoAction();
			Screen->DrawTile(0, 16, 4 - (i / 2), 45760, 9, 6, 0, -1, -1, 0, 0, 0, 0, 1, 128);			
			Waitframe();
		}
		
		Screen->Message(MSG_LINK_BEATEN + 2);
		
		// Buffer
		for (int i = 0; i < 60; ++i)
		{					
			NoAction();
			Screen->DrawTile(0, 16, -11, 45760, 9, 6, 0, -1, -1, 0, 0, 0, 0, 1, 128);
			Waitframe();			
		}
		
		Hero->HP = Hero->MaxHP;
		
		//Falling
		for (int i = 0; i < 32; ++i)
		{					
			NoAction();
			Screen->DrawTile(0, 16, -11 + (i * 2), 45760, 9, 6, 0, -1, -1, 0, 0, 0, 0, 1, 128);		
			
			if (i == 10)
			{
				eweapon waterfallLeft = CreateEWeaponAt(EW_SCRIPT10, 76, 64);
				waterfallLeft->Damage = LEVIATHAN1_WATERFALL_DMG;
				waterfallLeft->Script = Game->GetEWeaponScript("Waterfall");
				waterfallLeft->DrawYOffset = -1000;
				waterfallLeft->InitD[0] = 3;
				waterfallLeft->InitD[1] = 64;	
				
				eweapon waterfallRight = CreateEWeaponAt(EW_SCRIPT10, 124, 64);
				waterfallRight->Damage = LEVIATHAN1_WATERFALL_DMG;
				waterfallRight->Script = Game->GetEWeaponScript("Waterfall");
				waterfallRight->DrawYOffset = -1000;
				waterfallRight->InitD[0] = 3;
				waterfallRight->InitD[1] = 64;	
			}
			
			if (i == 31)
			{
				for(int q = 0; q < MAX_ITEMDATA; ++q)
					Hero->Item[q] = false;
		
				Hero->MaxHP = 48;
				Hero->MaxMP = 32;
		
				Hero->HP = Hero->MaxHP;
				Hero->MP = Hero->MaxMP;
		
				Hero->WarpEx({WT_IWARPOPENWIPE, dmap, scrn, -1, WARP_A, WARPEFFECT_OPENWIPE, 0, 0, DIR_UP});	
			}
			
			Waitframe();
		}		
		

		
		//Waitframes(60);
		
		// for(int q = 0; q < MAX_ITEMDATA; ++q)
			// Hero->Item[q] = false;
		
		// Hero->MaxHP = 48;
		// Hero->MaxMP = 32;
		
		// Hero->HP = Hero->MaxHP;
		// Hero->MP = Hero->MaxMP;
		
		// Hero->WarpEx({WT_IWARPOPENWIPE, dmap, scrn, -1, WARP_A, WARPEFFECT_OPENWIPE, 0, 0, DIR_UP});
    }
}

//end

//~~~~~ContinuePoint~~~~~//
//start
ffc script ContinuePoint
{
	void run(int dmap, int scrn)
	{
		unless (dmap || scrn)
		{
			dmap = Game->GetCurDMap();
			scrn = Game->GetCurScreen();
		}
		
		Game->LastEntranceDMap = dmap;
		Game->LastEntranceScreen = scrn;
		Game->ContinueDMap = dmap;
		Game->ContinueScreen = scrn;
	}
}
//end

//~~~~~Shutter~~~~~//
//D0: Direction when entering the screen
//start
ffc script Shutter
{
	void run(int direction)
	{
		direction = VBound(direction, 3, 0);	//Param boundary check
		
		if (direction != Hero->Dir)
			return;
		
		for(int i = 0; i < 11; ++i)
		{
			for (int j = 0; j < 4; ++j)
			{
				Input->Button[CB_UP + j] = j == direction;	//j == direction is true
				Input->Press[CB_UP + j] = j == direction;	//j == direction is true
			}
			Waitframe();
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
StatusPos statusPos = SP_ABOVE_HEAD;

enum StatusPos
{
	SP_ABOVE_HEAD,
	SP_TOP_RIGHT
};

enum Status
{
	ATTACK_BOOST, DEFENSE_BOOST, 
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

CONFIG SFX_RISE = 9;
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
					Audio->PlaySound(SFX_RISE);
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
						TraceS("Start Waterfall \n");
						x = Link->X-64;
						x2 = x + Choose(-8, 8);
					
						Glide(this, vars, x, 112, x2, 32, riseAnim);
						Waitframe(this, vars, 40);
						
						for(i = 0; i < 20; ++i)
						{
							GlideFrame(this, vars, x2, 32, x2, 112, 20, i);
							
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



