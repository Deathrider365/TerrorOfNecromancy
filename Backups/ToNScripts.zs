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

//end

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Imports~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//start
import "std.zh"
import "ffcscript.zh"
import "bitmap.zh"
//end

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Global Active~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//start
//~~~~~Constants/globals~~~~~//
//start
int onContHP = 0;
int onContMP = 0;
int deathCount = 0;

enum Color
{
	C_TRANS = 0x00,
	C_BLACK = 0x08,
	C_WHITE = 0x0C,
	C_RED = 0x04,
	C_BLUE = 0x1F
};

typedef const Color COLOR;
CONFIG SUB_B_X = 94;
CONFIG SUB_B_Y = -10;
CONFIG SUB_A_X = 118;
CONFIG SUB_A_Y = -10;
COLOR SUB_TEXT_COLOR = C_BLACK;
CONFIG SUB_TEXT_FONT = FONT_LA;
CONFIG SUB_COOLDOWN_TILE = 29281;
CONFIG SUB_COOLDOWN_TILE_WIDTH = 9;

//end
//~~~~~~~~~~~~~~~~~~~~~~~~~~~//

//~~~~~Main Global~~~~~//
//start
global script GlobalScripts
{
	void run()
	{
		int frame;
		
		while(true)
		{
			//checkItemCycle();
			//checkDungeon();
			bitmaps::updatefreed();
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
}
//end

//~~~~~OnSaveLoad~~~~~//
//start
global script OnSaveLoad
{
    void run()
    {
		status_bmp = NULL;
		bitmaps::refresh_pointers();
		
		if(!onContHP == 0)
		{
			Hero->HP = onContHP;
			Hero->MP = onContMP;	
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
    }
}
//end

//~~~~~OnContGame~~~~~//
//start
global script onContGame
{
    void run()
    {
//		Hero->HP = onContHP;
//		Hero->MP = onContMP;
    }
}
//end

//end

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Free Form Combos~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//	Finish trading guy and perhaps normal NPC
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//start
//~~~~~Constants/globals~~~~~//
const int COMPASS_BEEP = 93; //Set this to the SFX id you want to hear when you have the compass,

const int COMPASS_SFX = 93; 			//Set this to the SFX id you want to hear when you have the compass.

CONFIG CB_SIGNPOST = CB_A;				//Button to press to read a sign

const int SFX_SWITCH_PRESS = 61; 		//SFX when a switch is pressed
const int SFX_SWITCH_RELEASE = 61; 		//SFX when a switch is released
const int SFX_SWITCH_ERROR = 62; 		//SFX when the wrong switch is pressed

const int ICE_BLOCK_SCRIPT = 1; 		// Slot number that the ice_block script is assigned to
const int ICE_BLOCK_SENSITIVITY = 8; 	// Number of frames the blocks need to be pushed against to begin moving

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
    void run(int m)
    {
		Waitframes(4);
		if (EnemiesAlive())
			Screen->Message(m);
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
			 Game->PlaySound(COMPASS_BEEP);
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
		int bossmusic[256];
		int areamusic[256];
		
		if (Screen->State[ST_SECRET])
			Quit();
			
		Waitframes(4);
		Game->GetDMapMusicFilename(dmap, bossmusic);
		Game->PlayEnhancedMusic(bossmusic, 0);
		
		while(ScreenEnemiesAlive())
			Waitframe();

		Game->GetDMapMusicFilename(Game->GetCurDMap(), areamusic);
		Game->PlayEnhancedMusic(areamusic, 0);
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

//~~~~~IntroSceneWarping~~~~~//
//D0: Message number to show
//D1: Dmap to warp Link to
//D2: Screen on the specified dmap to warp Link to
//start
ffc script IntroSceneWarping
{	
	bool firstRun = true;
	
    void run(int msg, int dmap, int scr, int lastWarp)
    {
		if (firstRun)
		{
			//NoAction();
			Screen->Message(msg);
			Waitframe();
			Hero->WarpEx({WT_IWARPBLACKOUT, dmap, scr, -1, WARP_A, WARPEFFECT_INSTANT, 0, 
				WARP_FLAG_SETCONTINUESCREEN | WARP_FLAG_SETCONTINUEDMAP, DIR_DOWN});
		}
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
	bool firstRun = true;
	
    void run(int msg, int dmap, int scr)
    {
		if (firstRun)
		{
			firstRun = false;
			NoAction();
			Screen->Message(msg);
			Waitframe();
			Hero->WarpEx({WT_IWARPBLACKOUT, dmap, scr, -1, WARP_A, WARPFX_NONE, 0, 
				WARP_FLAG_SETCONTINUESCREEN | WARP_FLAG_SETCONTINUEDMAP, DIR_DOWN});
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

//~~~~~NormalGuy~~~~~//	In progress
//start
ffc script NormalGuy
{
    void run(int string)
    {
		//if (link x and y are next to the NPC)
		//	Screen->Message(string);
		//	MAYBE JUST USE SIGN POST
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
		Game->PlaySound(SFX_SWITCH_PRESS);
		
		if(sfx == 0)
			Game->PlaySound(SFX_SECRET);
		else if(sfx > 0)
			Game->PlaySound(sfx);
			
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
				Game->PlaySound(SFX_SWITCH_PRESS);
				
				for(i = 0; i < 176; i++)
					if(comboD[i] > 0)
						Screen->ComboD[i] = comboD[i] + 1;
						
				while(SwitchPressed(this->X, this->Y, noLink))
					Waitframe();
				
				this->Data = data;
				Game->PlaySound(SFX_SWITCH_RELEASE);
				
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
			Game->PlaySound(SFX_SWITCH_PRESS);
			
			if(sfx > 0)
				Game->PlaySound(sfx);
			else
				Game->PlaySound(SFX_SECRET);
				
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
					Game->PlaySound(sfx);
				else
					Game->PlaySound(SFX_SECRET);
				for(i = 0; i < 176; i++)
					if(comboD[i] > 0)
						Screen->ComboD[i] = comboD[i] + 1;
			}
			else
			{
				if(sfx > 0)
					Game->PlaySound(sfx);
				else
					Game->PlaySound(SFX_SECRET);
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
					Game->PlaySound(sfx);
				else
					Game->PlaySound(SFX_SECRET);
					
				for(i = 0; i < 176; i++)
					if(comboD[i] > 0)
						Screen->ComboD[i] = comboD[i] + 1;
			}
			else
			{
				if(sfx > 0)
					Game->PlaySound(sfx);
				else
					Game->PlaySound(SFX_SECRET);
					
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
					Game->PlaySound(SFX_SWITCH_PRESS);
					
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
						Game->PlaySound(SFX_SWITCH_RELEASE);
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
		Game->PlaySound(SFX_SWITCH_PRESS);
		Game->PlaySound(SFX_SWITCH_ERROR);
		
		for(int i = 0; i < count; i++)
		{
			int pos = SwitchGetSpawnPos();
			npc n = CreateNPCAt(enemyid, ComboX(pos), ComboY(pos));
			Game->PlaySound(SFX_FALL);
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
			Game->PlaySound(sfx);
		else
			Game->PlaySound(SFX_SECRET);
		
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
						Game->PlaySound(SFX_SWITCH_PRESS);
						switchesPressed[j] = true;
					}
					else
					{
						switches[1] = 0;
						Game->PlaySound(SFX_SWITCH_ERROR);
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
					Game->PlaySound(SFX_SWITCH_RELEASE);
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
				Game->PlaySound(SFX_SECRET);
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
			TraceS("DO SOMETHING HERE!!\n");
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
    void run(int durationSeconds, int cooldownSeconds, int multiplier)
    {
		int itemClasses[] = {IC_ARROW, IC_BOW, IC_HAMMER, IC_BRANG, IC_SWORD, IC_GALEBRANG, IC_BRACELET, IC_ROCS, IC_STOMPBOOTS};
		itemdata ids[9];
		int powers[9];
		
		for (int i = SizeOfArray(itemClasses) - 1; i >= 0; --i)
		{
			int it = GetHighestLevelItemOwned(itemClasses[i]);
			
			if (it >= 0)
			{
				ids[i] = Game->LoadItemData(it);
				powers[i] = ids[i]->Power;
				ids[i]->Power *= multiplier;
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
//D0: Number of SFX to play when attempting to use while on cooldown
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
	CONFIG DEFAULT_SFX = 4;
	DEFINE ROTATION_RATE = 20; //degrees
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
			if(controlling) controlling = (Input->Button[CB_A] || Input->Button[CB_B]);
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



//end

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Hero~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//start

//~~~~~Constants/globals~~~~~//
int statuses[NUM_STATUSES];
bitmap status_bmp;
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
CONFIG STATUS_FONT = FONT_Z3SMALL;		//can be changed
DEFINE STATUS_HEIGHT = 8;
DEFINE STATUS_WIDTH = 12;
COLOR STARUS_TEXT_COLOR = C_WHITE;

//~~~~~~~~~~~~~~~~~~~//

//~~~~~HeroActive~~~~~//
//start
hero script HeroActive
{
	void run()
	{
		clearStatuses();
					
		if (status_bmp && bitmaps::inuse(status_bmp))
			bitmaps::release(status_bmp);
		
		DEFINE WIDTH = NUM_STATUSES * STATUS_WIDTH;
		DEFINE FONT_HEIGHT = Text->FontHeight(STATUS_FONT);
		DEFINE HEIGHT = STATUS_HEIGHT + FONT_HEIGHT;
		status_bmp = bitmaps::acquire(WIDTH, HEIGHT);	
		
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
			
			status_bmp->Blit(7, RT_SCREEN, 0, 0, WIDTH, HEIGHT, getStatusX(statusPos, WIDTH), 
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
const int NPC_LEVIATHANHEAD = 177;

const int SFX_LEVIATHAN_RISE = 9;
const int SFX_LEVIATHAN_ROAR = 24;
const int SFX_LEVIATHAN_SPLASH = 55;

const int SPR_LEVIATHAN_SPLASH = 93;

//~~~~~~~~~~~~~~~~~~~//
npc script Leviathan1
{
	
	void run()
	{
		int i; int j; int k;
		int x; int y;
		int x2; int y2;
		
		untyped vars[16];
		npc head = CreateNPCAt(NPC_LEVIATHANHEAD, this->X, this->Y);
		vars[0] = head;
		
		this->HitXOffset = 64;
		this->HitYOffset = 32;
		
		this->HitWidth = 48;
		this->HitHeight = 48;
		
		this->X = 52;
		this->Y = 112;
		
		int attack;
	
		Game->PlayEnhancedMusic(" ", 0);		
		
		
		//
		//	The leviathan is rising and screen is quaking
		//
		for(i=0; i<180; ++i)		
		{
			Leviathan_GlideFrame(this, vars, 52, 112, 52, 32, 180, i);
			
			if(i % 40 == 0)
			{
				Game->PlaySound(SFX_LEVIATHAN_RISE);
				Screen->Quake = 20;
			}


			Leviathan_Waitframe(this, vars);
		}
		
		//
		//	The leviathan pauses, roars, then pauses
		//
		for(i = 0; i < 120; ++i)
		{
			if(i == 60)
				Game->PlaySound(SFX_LEVIATHAN_ROAR);
			
			Leviathan_Waitframe(this, vars);
		}
		
		//
		//	The leviathan dives
		//
		for(i = 0; i < 20; ++i)
		{
			Leviathan_GlideFrame(this, vars, 52, 32, 52, 112, 20, i);
			Leviathan_Waitframe(this, vars);
		}
		
		//
		//	The splash SFX he makes when diving
		//
		Game->PlaySound(SFX_LEVIATHAN_SPLASH);
		Leviathan_Splash(this->X + 64, 100);
				
		//
		// Leviathan behavior loop
		//
		while(true)
		{
			attack = 0;
			switch(attack)
			{
				case 0:
					x = Rand(-32, 160);
					x2 = x + Choose(-8, 8);
				
					Leviathan_Glide(this, vars, x, 112, x2, 32, 120);
					Leviathan_Waitframe(this, vars, 40);
					Leviathan_Glide(this, vars, x2, 32, x2, 112, 20);
					break;
			}
			
			Leviathan_Waitframe(this, vars);
		}
	}
	
	void Leviathan_Glide(npc this, untyped vars, int x1, int y1, int x2, int y2, int numFrames)
	{
		int angle = Angle(x1, y1, x2, y2);
		int dist = Distance(x1, y1, x2, y2);
		for(int i = 0; i < numFrames; ++i)
		{
			int x = x1 + VectorX(dist * (i / numFrames), angle);
			int y = y1 + VectorY(dist * (i / numFrames), angle);
			this->X = x;
			this->Y = y;
			Leviathan_Waitframe(this, vars);
		}
	}
	void Leviathan_GlideFrame(npc this, untyped vars, int x1, int y1, int x2, int y2, int numFrames, int i)
	{
		int angle = Angle(x1, y1, x2, y2);
		int dist = Distance(x1, y1, x2, y2);
		int x = x1 + VectorX(dist * (i / numFrames), angle);
		int y = y1 + VectorY(dist * (i / numFrames), angle);
		this->X = x;
		this->Y = y;
	}
	void Leviathan_Splash(int x, int y)
	{
		lweapon l;
		for(int i=0; i<5; ++i)
		{
			l = CreateLWeaponAt(LW_SPARKLE, x - 4 - 4 * i, y);
			l->UseSprite(SPR_LEVIATHAN_SPLASH);
			l->ASpeed += Rand(3);
			l->Step = Rand(100, 200);
			l->Angular = true;
			l->Angle = DegtoRad( - 90 - 5 - 15 * i + Rand(-5, 5));
			l->CollDetection = false;
			
			l = CreateLWeaponAt(LW_SPARKLE, x + 4 + 4 * i, y);
			l->UseSprite(SPR_LEVIATHAN_SPLASH);
			l->ASpeed += Rand(3);
			l->Step = Rand(100, 200);
			l->Angular = true;
			l->Angle = DegtoRad( - 90 + 5 + 15 * i + Rand(-5, 5));
			l->CollDetection = false;
			l->Flip = 1;
		}
	}
	void Leviathan_Waitframe(npc this, untyped vars, int frames)
	{
		for(int i = 0; i < frames; ++i)
		{
			Leviathan_Waitframe(this, vars);
		}
	}
	void Leviathan_Waitframe(npc this, untyped vars)
	{
		this->DrawYOffset = -1000;
		this->Stun = 10;
		
		if(this->Y <= 112 - 80)
			this->CollDetection = true;
		else
			this->CollDetection = false;
		
		Screen->DrawTile(0, this->X, this->Y, this->OriginalTile, 9, 6, this->CSet, -1, -1, 0, 0, 0, 0, 1, 128);
		npc head = <npc>vars[0];
		
		if(head->isValid())
		{
			if(head->Y <= 112 - 16)
				head->CollDetection = true;
			else
				head->CollDetection = false;
				
			head->DrawYOffset = -1000;
			head->Stun = 10;
			head->X = this->X + 104;
			head->Y = this->Y + 42;
			head->HitWidth = 24;
			head->HitHeight = 16;
			
			if(head->HP < 1000)
			{
				this->HP -= 1000 - head->HP;
				head->HP = 1000;
			}
		}
		
		Waitframe();
	}
}

eweapon script Leviathan_Waterfall
{
	void run()
	{
		
	}
}


//end

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Enemy~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//start

//~~~~~Constants/globals~~~~~//


//~~~~~~~~~~~~~~~~~~~//



//end












