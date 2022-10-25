///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Misc Functions~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

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

// Function to set Screen->D
void setScreenD(int reg, bool state) //start
{
    int d = Div(reg, 32);
    reg %= 32;
    
    if (state)
        Screen->D[d] |= 1Lb<<reg;
    else
        Screen->D[d] ~= 1Lb<<reg;
}
//end

// Function to get Screen->D
bool getScreenD(int reg) //start
{
    int d = Div(reg, 32);
    reg %= 32;
    
    return Screen->D[d] & (1Lb<<reg);
}
//end

// Function to set Screen->D
void setScreenD(int d, long bit, bool state) //start
{
    if (state)
        Screen->D[d] |= bit;
    else
        Screen->D[d] ~= bit;
}
//end

// Function to get Screen->D
long getScreenD(int d, long bit) //start
{
    return Screen->D[d] & bit;
}
//end

// Function to set Screen->D for remote screen
void setScreenD(int dmap, int scr, int reg, bool state) //start
{
    int d = Div(reg, 32);
    reg %= 32;
    
    long val = Game->GetDMapScreenD(dmap,scr,d);
    if (state)
        val |= 1Lb<<reg;
    else
        val ~= 1Lb<<reg;
    Game->SetDMapScreenD(dmap,scr,d,val);
}
//end

// Function to get Screen->D for remote screen
bool getScreenD(int dmap, int scr, int reg) //start
{
    int d = Div(reg, 32);
    reg %= 32;
    
    return Game->GetDMapScreenD(dmap,scr,d) & (1Lb<<reg);
}
//end

// Function to set Screen->D for remote screen
void setScreenD(int dmap, int scr, int d, long bit, bool state) //start
{
    long val = Game->GetDMapScreenD(dmap,scr,d);
    if (state)
        val |= bit;
    else
        val ~= bit;
    Game->SetDMapScreenD(dmap,scr,d,val);
}
//end

// Function to get Screen->D for remote screen
long getScreenD(int dmap, int scr, int d, long bit) //start
{
    return Game->GetDMapScreenD(dmap,scr,d) & bit;
}
//end

// Converts an 18 bit value to a 32 bit value
int convertBit(int b18) //start
{
	return b18 / 10000;
} //end

// Gets screen type
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

// Checks if overworld
bool isOverworld(bool dmapOnly) //start
{
	switch(getScreenType(dmapOnly))
	{
		case DM_DUNGEON:
		case DM_INTERIOR:
			return false;
	}
	return true;
} //end

// Prioretizes the horizontal direction when dealing with diagonals
int dir8To4(int dir) //start
{
	if (dir <= DIR_RIGHT)
		return dir;
	return remY(dir);
} //end

// Does a jump to link and flies off screen
void jumpOffScreenAttack(npc n, int upTile, int downTile) //start
{
	CONFIG JUMP_RATE = 4;
	CONFIG SLAM_RATE = JUMP_RATE * 3;
	CONFIG EW_SLAM = EW_SCRIPT10;
	CONFIG STUN = 30;
	CONFIG SLAM_COMBO = 6852;
	CONFIG SLAM_COMBO_CSET = 8;
	
	combodata cd = Game->LoadComboData(SLAM_COMBO);

	
	Audio->PlaySound(SFX_SUPER_JUMP);
	
	bool grav = n->Gravity;
	int oTile = n->ScriptTile;
	
	n->Gravity = false;
	n->CollDetection = false;
	
	n->ScriptTile = upTile;
	
	while (n->Z < 256)
	{
		n->Z += JUMP_RATE;
		Waitframe();
	}
	
	n->X = Hero->X;
	n->Y = Hero->Y;
	
	n->ScriptTile = downTile;
	
	while (n->Z > 0)
	{
		n->Z -= SLAM_RATE;
		Waitframe();
	}
	
	Audio->PlaySound(SFX_SLAM);
	eweapon weap = Screen->CreateEWeapon(EW_SLAM);
	weap->ScriptTile = TILE_INVIS;
	weap->HitHeight = 16 * 3;
	weap->HitWidth = 16 * 3;
	weap->HitXOffset = -16;
	weap->HitYOffset = -16;
	weap->X = n->X;
	weap->Y = n->Y;
	weap->Damage = n->Damage * 2;
	
	cd->Frame = 0;
	cd->AClk = 0;
	Screen->DrawCombo(2, n->X - 16, n->Y - 16, SLAM_COMBO, 3, 3, SLAM_COMBO_CSET, -1, -1, 0, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
	
	Waitframe();
	
	Remove(weap);
	
	n->CollDetection = true;
	n->Gravity = grav;
	
	Screen->Quake = STUN;
	
	for (int i = 0; i < STUN; ++i)
	{
		Screen->DrawCombo(2, n->X - 16, n->Y - 16, SLAM_COMBO, 3, 3, SLAM_COMBO_CSET, -1, -1, 0, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
		
		Waitframe();
	}
	
	n->ScriptTile = oTile;
	
} //end

// Charges towards link and slashes
void chargeSlash() //start
{
	
} //end

int FindJumpLength(int jumpInput, bool inputFrames) //start
{
	//Big ol table of rough jump values and their durations
	int jumpTBL[] = //start
	{
		0.0, 0,
		0.1, 3,
		0.2, 4,
		0.3, 5,
		0.4, 6,
		0.5, 8,
		0.6, 9,
		0.7, 10,
		0.8, 11,
		0.9, 13,
		1.0, 14,
		1.1, 15,
		1.2, 16,
		1.3, 18,
		1.4, 19,
		1.5, 20,
		1.6, 21,
		1.7, 23,
		1.8, 24,
		1.9, 25,
		2.0, 26,
		2.1, 28,
		2.2, 29,
		2.3, 30,
		2.4, 31,
		2.5, 33,
		2.6, 34,
		2.7, 35,
		2.8, 36,
		2.9, 38,
		3.0, 39,
		3.1, 40,
		3.2, 41,
		3.3, 43,
		3.4, 44,
		3.5, 45,
		3.6, 47,
		3.7, 48,
		3.8, 49,
		3.9, 51,
		4.0, 52,
		4.1, 54,
		4.2, 55,
		4.3, 57,
		4.4, 58,
		4.5, 60,
		4.6, 61,
		4.7, 63,
		4.8, 64,
		4.9, 66,
		5.0, 67,
		5.1, 69,
		5.2, 71,
		5.3, 72,
		5.4, 74,
		5.5, 76,
		5.6, 77,
		5.7, 79,
		5.8, 81,
		5.9, 83,
		6.0, 85,
		6.1, 86,
		6.2, 88,
		6.3, 90,
		6.4, 92,
		6.5, 94,
		6.6, 96,
		6.7, 98,
		6.8, 100,
		6.9, 102,
		7.0, 104,
		7.1, 106,
		7.2, 108,
		7.3, 110,
		7.4, 112,
		7.5, 114,
		7.6, 116,
		7.7, 118,
		7.8, 120,
		7.9, 123,
		8.0, 125,
		8.1, 127,
		8.2, 129,
		8.3, 131,
		8.4, 134,
		8.5, 136,
		8.6, 138,
		8.7, 141,
		8.8, 143,
		8.9, 145,
		9.0, 148,
		9.1, 150,
		9.2, 153,
		9.3, 155,
		9.4, 158,
		9.5, 160,
		9.6, 162,
		9.7, 165,
		9.8, 168,
		9.9, 170,
		10.0, 173
	}; //end

	//When getting a duration from a jump
	unless (inputFrames)
	{
		//Keep values between 0 and 10, nothing beyond that would be sensible in most cases
		jumpInput = Clamp(jumpInput, 0, 10);
		//Round to the nearest 0.1
		jumpInput *= 10;
		jumpInput = Round(jumpInput);
		jumpInput *= 0.1;
		
		return jumpTBL[jumpInput*2+1];
	}
	//When getting a jump from a duration
	else
	{
		int closestIndex = 0;
		int closest = 0;
		//Cycle through the table to find the closest duration to the desired one
		for(int i=1; i<100; ++i)
		{
			if(Abs(jumpTBL[i*2+1]-jumpInput)<Abs(closest-jumpInput))
			{
				closestIndex = i;
				closest = jumpTBL[i*2+1];
			}
		}
		
		return jumpTBL[closestIndex*2+0];
	}
} //end

//Makes a hitbox with ghost.zh weapons
void MakeHitbox(int x, int y, int w, int h, int damage) //start
{
    eweapon e = FireEWeapon(EW_SCRIPT10, 120, 80, 0, 0, damage, -1, -1, EWF_UNBLOCKABLE);
    e->HitXOffset = x-e->X;
    e->HitYOffset = y-e->Y;
    e->DrawYOffset = -1000;
    e->HitWidth = w;
    e->HitHeight = h;
    SetEWeaponLifespan(e, EWL_TIMER, 1);
    SetEWeaponDeathEffect(e, EWD_VANISH, 0);
} //end

void sword1x1(int x, int y, int angle, int dist, int cmb, int cset, int dmg) //start
{
	x += VectorX(dist, angle);
	y += VectorY(dist, angle);
	
	Screen->DrawCombo(2, x, y, cmb, 1, 1, cset, -1, -1, x, y, angle, -1, 0, true, OP_OPAQUE);
	
	MakeHitbox(x, y, 16, 16, dmg);
	
} //end

void enemyShake(ffc this, npc ghost, int frames, int intensity) //start
{
	for (int i = 0; i < frames; ++i)
	{
		ghost->DrawXOffset = Rand(-intensity, intensity);
		ghost->DrawYOffset = Rand(-intensity, intensity) - 2;
	
		Ghost_Waitframe(this, ghost);
	}

	ghost->DrawXOffset = 0;
	ghost->DrawYOffset = -2;
} //end

void Ghost_ShadowTrail(ffc this, npc ghost, bool addDir, int duration) //start
{
    int til;
    if(addDir)
        til = Game->ComboTile(Ghost_Data+Ghost_Dir);
    else
        til = Game->ComboTile(Ghost_Data);
		
    int cset = this->CSet;
    int w = Ghost_TileWidth;
    int h = Ghost_TileHeight;
    
    lweapon trail = CreateLWeaponAt(LW_SCRIPT10, Ghost_X, Ghost_Y);
    trail->OriginalTile = til;
    trail->Tile = til;
    trail->CSet = cset;
    trail->Extend = 3;
    trail->TileWidth = w;
    trail->TileHeight = h;
    trail->CollDetection = false;
    trail->DeadState = duration;
    trail->DrawStyle = DS_PHANTOM;
} //end

//	Calls an EWeapon script
void RunEWeaponScript(eweapon e, int scr, int args) //start
{
    e->Script = scr;
    int numArgs = SizeOfArray(args);
	
    for(int i = 0; i < numArgs; ++i)
        e->InitD[i] = args[i];
		
} //end

// Returns true if a rectangular section of screen is walkable to a ghosted enemy
bool Ghost_CanPlace(int X, int Y, int w, int h) //start
{
    for(int x=0; x<=w-1; x=Min(x+8, w-1)){
        for(int y=0; y<=h-1; y=Min(y+8, h-1)){
            if(!Ghost_CanMovePixel(X+x, Y+y))
                return false;
            
            if(y==h-1)
                break;
        }
        if(x==w-1)
            break;
    }
    return true;
} //end

// Modifies the game over menu text, background color, and midi
void SetGameOverMenu(Color bg, Color text, Color flash, int midi) //start
{
	Game->GameOverScreen[GOS_BACKGROUND] = bg;
	
	Game->GameOverScreen[GOS_TEXT_COLOUR] = text;
	Game->GameOverScreen[GOS_TEXT_CONTINUE_COLOUR] = text;
	Game->GameOverScreen[GOS_TEXT_SAVE_COLOUR] = text;
	Game->GameOverScreen[GOS_TEXT_RETRY_COLOUR] = text;
	Game->GameOverScreen[GOS_TEXT_DONTSAVE_COLOUR] = text;
	Game->GameOverScreen[GOS_TEXT_SAVEQUIT_COLOUR] = text;
	Game->GameOverScreen[GOS_TEXT_SAVE2_COLOUR] = text;
	Game->GameOverScreen[GOS_TEXT_QUIT_COLOUR] = text;
	
	Game->GameOverScreen[GOS_TEXT_CONTINUE_FLASH] = flash;
	Game->GameOverScreen[GOS_TEXT_SAVE_FLASH] = flash;
	Game->GameOverScreen[GOS_TEXT_RETRY_FLASH] = flash;
	Game->GameOverScreen[GOS_TEXT_DONTSAVE_FLASH] = flash;
	Game->GameOverScreen[GOS_TEXT_SAVEQUIT_FLASH] = flash;
	Game->GameOverScreen[GOS_TEXT_SAVE2_FLASH] = flash;
	Game->GameOverScreen[GOS_TEXT_QUIT_FLASH] = flash;
	
	Game->GameOverScreen[GOS_MIDI] = midi;
} //end

// Creates Bitmap again
bitmap recreate(bitmap b, int w, int h) //start
{
	unless(Game->FFRules[qr_OLDCREATEBITMAP_ARGS])
		b->Create(0, h, w);
	else
		b->Create(0, w, h);
		
	return b;
}
//end

// Calcualtes the percent that part is of whole
float PercentOfWhole(int part, int whole) //start
{
	return (100 * part)/whole;
} //end

//~~~~~SwitchPressed (used for switch scripts)~~~~~//
int SwitchPressed(int x, int y, bool noLink) //start
{
	int xOff = 0;
	int yOff = 4;
	int xDist = 8;
	int yDist = 8;
	
	if(Abs(Link->X+xOff-x)<=xDist&&Abs(Link->Y+yOff-y)<=yDist&&Link->Z==0&&!noLink)
		return 1;
		
	if(Screen->MovingBlockX>-1)
		if(Abs(Screen->MovingBlockX-x)<=8&&Abs(Screen->MovingBlockY-y)<=8)
			return 1;
	
	if(Screen->isSolid(x+4, y+4)||
		Screen->isSolid(x+12, y+4)||
		Screen->isSolid(x+4, y+12)||
		Screen->isSolid(x+12, y+12)){
		return 2;
	}
	
	return 0;
}
//end

bool AgainstComboBase(int loc, bool anySide) //start
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
} //end

void leavingTransition(int dmap, int screen, int usingPresents) //start
{	
	for (int i = 0; i < INTRO_SCENE_TRANSITION_FRAMES; ++i)
	{
		if (usingPresents)
			Screen->DrawTile(6, 24, 24, 42406, 13, 3, 0, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
		Screen->Rectangle(7, 256 - i * INTRO_SCENE_TRANSITION_MULT, 0, 512 - i * INTRO_SCENE_TRANSITION_MULT, 176, C_BLACK, 1, 0, 0, 0, true, OP_OPAQUE);
		Waitframe();
	}
	
	Hero->Warp(dmap, screen);
} //end

void enteringTransition() //start
{	
	for (int i = 0; i < INTRO_SCENE_TRANSITION_FRAMES; ++i)
	{
		Screen->Rectangle(7, 0 - i * INTRO_SCENE_TRANSITION_MULT, 0, 256 - i * INTRO_SCENE_TRANSITION_MULT, 176, C_BLACK, 1, 0, 0, 0, true, OP_OPAQUE);
		Waitframe();
	}
	
} //end

bool onTop(int x, int y) //start
{
	if ((Abs(Hero->X - x) <= 8) && (Abs(Hero->Y - y) <= 8))
		return true;
	else
		return false;
} //end

void takeMapScreenshot() //start
{
	unless(DEBUG) return;
	if(DEBUG && Input->KeyPress[KEY_P])
	{
		CONFIG DELAY = 3;
		if(PressControl())
			Emily::doAllMapScreenshots(DELAY);
		else
			Emily::doMapScreenshot(Game->GetCurMap(),DELAY);
	}
} //end

int lerp(int low, int high, float mult)
{
    if(low > high)
    {
        int temp = low;
        low = high;
        high = temp;
    }
    return low + (mult * (high - low));
}



















