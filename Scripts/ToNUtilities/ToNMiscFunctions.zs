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
	
    for(int i=0; i<numArgs; ++i)
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

//start		CHECK THIS SHUTTER SCRIPT
// After regaining control of Link upon entering a new screen, the number of frames to wait before opening shutters.
const int SHUTTER_DELAY_TIME = 15;

// The screen and map number of the previous frame.
int prevScreen;
int prevDMap;

// Holds shutter combo locations
int shutterPos[176];

// True if there are enemies still on the screen
bool enemiesLeft = true;

// True if enemy, secret, perm secret, and flag shutters are closed, respectively.
bool shuttersEnemyClosed = true;
bool shuttersSecretClosed = true;
bool shuttersPermSecretClosed = true;
bool shuttersFlagClosed = true;

// If set to true by another script, flag shutters will open.
bool shutterFlag = false;

// True while Link is automatically moving out of the way for a shutter to close.
bool shutterRunning = false;

// Records combos on screen 81 for safe keeping so that other combos can be placed and tested there.
int shutterTempCombo[4];

// Array used to count the number of shutters to close after Link steps off of them.
int shutterCheck[2];

// Counter for closing shutters after Link regains control.
int shutterDelay = SHUTTER_DELAY_TIME;

void shutterControl() {

	if(changeScreen()) {
		// The screen has been changed in the last frame. Time to initialize new shutters!

		// Reset the script flag for flag shutters
		shutterFlag = false;

		// Start by saying all shutters are open so that we can close only the ones necessary.
		// This means we'll only have to spend time checking shutter conditions for shutter types that actually exist.
		shuttersEnemyClosed = false;
		shuttersSecretClosed = false;
		shuttersPermSecretClosed = false;
		shuttersFlagClosed = false;

		// The number of shutter combos on the screen.
		int numDoors = 0;

		// The following loop determines the number of shutter combos on the screen. Suppose there are k.
		// It then sets the first k values of ShutterPos[] to the combo locations of those doors, and sets value k+1 to -1.
		// It also determines which types of shutters are in use.

		for(int i=0; i<176; i++) {
			// Looping through all combos on the screen...

			shutterPos[numDoors] = -1;

			if(Screen->ComboT[i] == CT_SCRIPT1 && Screen->ComboF[i] != 100 && 
			(Screen->ComboI[i] != 100 || Screen->ComboF[i] == 98 || Screen->ComboF[i] == 99 || Screen->ComboF[i] == 101)) {
				// The combo is a shutter type AND the combo flag is not a one-way shutter AND
				// either the inherent flag is not a one-way shutter or the combo flag is one one of the other types of shutters.

				shutterPos[numDoors] = i;
				numDoors++;
				if(Screen->ComboF[i] == 98) {
					shuttersSecretClosed = true;
				}
				else if(Screen->ComboF[i] == 99) {
					shuttersPermSecretClosed = true;
				}
				else if(Screen->ComboF[i] == 101) {
					shuttersFlagClosed = true;
				}
				else if(Screen->ComboI[i] == 98) {
					shuttersSecretClosed = true;
				}
				else if(Screen->ComboI[i] == 99) {
					shuttersPermSecretClosed = true;
				}
				else if(Screen->ComboI[i] == 101) {
					shuttersFlagClosed = true;
				}
				else {
					shuttersEnemyClosed = true;
				}
			}
		}

		// Screen has changed, so reset the shutter delay counter.
		shutterDelay = SHUTTER_DELAY_TIME;

		if(Screen->ComboT[ComboAt(Link->X, Link->Y)] == CT_SCRIPT1 || 
		Screen->ComboT[ComboAt(Link->X+15, Link->Y)] == CT_SCRIPT1 || 
		Screen->ComboT[ComboAt(Link->X, Link->Y+15)] == CT_SCRIPT1 || 
		Screen->ComboT[ComboAt(Link->X+15, Link->Y+15)] == CT_SCRIPT1) {
			// If Link is standing on a shutter combo...

			// Link is on a shutter on the first frame of a new screen, so the automatic walking begins...
			shutterRunning = true;

			// Determine which edge Link is on, and make him face the direction he's about to walk.
			// So if he's on the left side of the screen, for instance, make him face right.
			int dir = -1;
			if(Link->Y >= 175) {
				dir = DIR_UP;
			}
			else if(Link->Y <= -1) {
				dir = DIR_DOWN;
			}
			else if(Link->X >= 255) {
				dir = DIR_LEFT;
			}
			else if(Link->X <= -1) {
				dir = DIR_RIGHT;
			}

			Link->Dir = dir;

			// Link will be taking up at most two rows of combos (if moving horizontally) or two columns of combos (if moving vertically).
			// shutterCheck[0] and shutterCheck[1] will count the number of shutter combos his top and bottom (or left and right) halves
			// will touch as he automatically walks away from the shutter combos. Here we initialize the values to 0.
			shutterCheck[0] = 0;
			shutterCheck[1] = 0;

			// Now we actually find those values:
			if(dir == DIR_UP) {
				int y=10;
				while(Screen->ComboT[ComboAt(Link->X, 16*y)] == CT_SCRIPT1) {
					Screen->ComboD[ComboAt(Link->X, 16*y)]++;
					y--;
					shutterCheck[0]++;
				}
				if(Link->X % 16 != 0) {
					y=10;
					while(Screen->ComboT[ComboAt(Link->X+15, 16*y)] == CT_SCRIPT1) {
						Screen->ComboD[ComboAt(Link->X+15, 16*y)]++;
						y--;
						shutterCheck[1]++;
					}
				}
			}

			else if(dir == DIR_DOWN) {
				int y=0;
				while(Screen->ComboT[ComboAt(Link->X, 16*y)] == CT_SCRIPT1) {
					Screen->ComboD[ComboAt(Link->X, 16*y)]++;
					y++;
					shutterCheck[0]++;
				}
				if(Link->X % 16 != 0) {
					y=0;
					while(Screen->ComboT[ComboAt(Link->X+15, 16*y)] == CT_SCRIPT1) {
						Screen->ComboD[ComboAt(Link->X+15, 16*y)]++;
						y++;
						shutterCheck[1]++;
					}
				}
			}

			else if(dir == DIR_LEFT) {
				int x=15;
				while(Screen->ComboT[ComboAt(16*x, Link->Y)] == CT_SCRIPT1) {
					Screen->ComboD[ComboAt(16*x, Link->Y)]++;
					x--;
					shutterCheck[0]++;
				}
				if(Link->Y % 16 != 0) {
					x=15;
					while(Screen->ComboT[ComboAt(16*x, Link->Y+15)] == CT_SCRIPT1) {
						Screen->ComboD[ComboAt(16*x, Link->Y+15)]++;
						x--;
						shutterCheck[1]++;
					}
				}
			}

			else if(dir == DIR_RIGHT) {
				int x=0;
				while(Screen->ComboT[ComboAt(16*x, Link->Y)] == CT_SCRIPT1) {
					Screen->ComboD[ComboAt(16*x, Link->Y)]++;
					x++;
					shutterCheck[0]++;
				}
				if(Link->Y % 16 != 0) {
					x=0;
					while(Screen->ComboT[ComboAt(16*x, Link->Y+15)] == CT_SCRIPT1) {
						Screen->ComboD[ComboAt(16*x, Link->Y+15)]++;
						x++;
						shutterCheck[1]++;
					}
				}
			}

			// If the four corners of Link are standing on combos with combo data a, b, c, and d, then we'll use screen 81 on map 1
			// to place combos a-1, b-1, c-1, and d-1. Then, we can check if those combos are shutter type. These variables hold
			// the original data for the combos on this screen so we can replace them when we're done.
			shutterTempCombo[0] = Game->GetComboData(1, 0x81, 0);
			shutterTempCombo[1] = Game->GetComboData(1, 0x81, 1);
			shutterTempCombo[2] = Game->GetComboData(1, 0x81, 2);
			shutterTempCombo[3] = Game->GetComboData(1, 0x81, 3);
		}
	}
	// End change Screen!

	else if(shutterRunning == true) {
		// We're in the animation mode. Link is auto-walking.

		// If the four corners of Link are standing on combos with combo data a, b, c, and d, then we'll use screen 81 on map 1
		// to place combos a-1, b-1, c-1, and d-1.
		Game->SetComboData(1, 0x81, 0, Screen->ComboD[ComboAt(Link->X, Link->Y)]-1);
		Game->SetComboData(1, 0x81, 1, Screen->ComboD[ComboAt(Link->X+15, Link->Y)]-1);
		Game->SetComboData(1, 0x81, 2, Screen->ComboD[ComboAt(Link->X, Link->Y+15)]-1);
		Game->SetComboData(1, 0x81, 3, Screen->ComboD[ComboAt(Link->X+15, Link->Y+15)]-1);

		// Now we record the types of the combos we just placed.
		int shutterComboType[4];
		shutterComboType[0] = Game->GetComboType(1, 0x81, 0);
		shutterComboType[1] = Game->GetComboType(1, 0x81, 1);
		shutterComboType[2] = Game->GetComboType(1, 0x81, 2);
		shutterComboType[3] = Game->GetComboType(1, 0x81, 3);

		// Get Link's direction which, due to the actions on the change screen frame, should be the direction he's auto-walking.
		int dir = Link->Dir;

		if((shutterComboType[0] == CT_SCRIPT1) || (shutterComboType[1] == CT_SCRIPT1) || 
		(shutterComboType[2] == CT_SCRIPT1) || (shutterComboType[3] == CT_SCRIPT1)) {
			// If the combo Link is walking on WAS a shutter type...
			
			// Disable movement and A+B buttons...
			noMoveAction();

			// ...and auto-walk in the correct direction
			if(dir == DIR_UP) {
				Link->InputUp = true;
			}
			else if(dir == DIR_DOWN) {
				Link->InputDown = true;
			}
			else if(dir == DIR_LEFT) {
				Link->InputLeft = true;
			}
			else if(dir == DIR_RIGHT) {
				Link->InputRight = true;
			}
		}

		else {
			// Link is off the shutter combos and can stop auto-walking! Hooray!

			// Animation is complete, so turn off the shutterRunning flag so we don't enter this if statement again.
			shutterRunning = false;

			// We screwed up screen 81 on map 1 earlier, so let's restore the combos we changed.
			Game->SetComboData(1, 0x81, 0, shutterTempCombo[0]);
			Game->SetComboData(1, 0x81, 1, shutterTempCombo[1]);
			Game->SetComboData(1, 0x81, 2, shutterTempCombo[2]);
			Game->SetComboData(1, 0x81, 3, shutterTempCombo[3]);

			// Now we loop through the combos Link walked over during his journey and subtract one from the combo data
			// So that the shutters are closed. First left half, then right half (or top then bottom)
			for(int i=0; i<shutterCheck[0]; i++) {
				if(dir == DIR_UP) {
					Screen->ComboD[ComboAt(Link->X, 16*(10-i))]--;
				}
				else if(dir == DIR_DOWN) {
					Screen->ComboD[ComboAt(Link->X, 16*i)]--;
				}
				else if(dir == DIR_LEFT) {
					Screen->ComboD[ComboAt(16*(15-i), Link->Y)]--;
				}
				else if(dir == DIR_RIGHT) {
					Screen->ComboD[ComboAt(16*i, Link->Y)]--;
				}
			}

			for(int i=0; i<shutterCheck[1]; i++) {
				if(dir == DIR_UP) {
					Screen->ComboD[ComboAt(Link->X+15, 16*(10-i))]--;
				}
				else if(dir == DIR_DOWN) {
					Screen->ComboD[ComboAt(Link->X+15, 16*i)]--;
				}
				else if(dir == DIR_LEFT) {
					Screen->ComboD[ComboAt(16*(15-i), Link->Y+15)]--;
				}
				else if(dir == DIR_RIGHT) {
					Screen->ComboD[ComboAt(16*i, Link->Y+15)]--;
				}
			}

			// Shutters have closed. Let's make it official by playing the shutter sfx!
			Game->PlaySound(SFX_SHUTTER);
		}
	}
	// End shutter running. Link's auto-walk animation is over!

	// If Link auto-walked, he'll enter this if statement on the frame after completing it. Otherwise, he'll enter this
	// if statement as soon as the screen finishes scrolling. Either way, this is a countdown to when we can begin opening shutters.
	else if(shutterDelay > 0 && Link->Action != LA_SCROLLING) {
		shutterDelay--;
	}

	else if(Link->Action != LA_SCROLLING) {
		// We didn't just change screens, we're not in an auto-walk animation, and the shutter-opening countdown timer has finished!
		// Time to check if we can actually open the shutters!

		// If there are "enemy shutters" on the screen that are closed, check if we can open them.
		if(shuttersEnemyClosed) {
			openShuttersEnemyCheck();
		}

		// If there are "secret shutters" on the screen that are closed, check if we can open them.
		if(shuttersSecretClosed) {
			openShuttersSecretCheck();
		}

		// If there are "permanent secret shutters" on the screen that are closed, check if we can open them.
		if(shuttersPermSecretClosed) {
			openShuttersPermSecretCheck();
		}

		// If there are "script flag shutters" on the screen that are closed, check if we can open them.
		if(shuttersFlagClosed) {
			openShuttersFlagCheck();
		}
	}
}
// End the shutter control script!

// This function returns true if the current screen is different from the screen in the previous frame.
bool changeScreen() {
	if((Game->GetCurScreen() != prevScreen) || (Game->GetCurDMap() != prevDMap)) {
		return true;
	}
	else {
		return false;
	}
}

// This function checks if all the enemies on the screen are dead, and if so, opens "enemy shutters."
void openShuttersEnemyCheck() {
	npc en;
	bool enemiesLeft = false;

	// Loop through all NPCs on screen. If any of them have ID >=20, they are real enemies, so set enemiesLeft to true and break the loop.
	for(int i=1; i<=Screen->NumNPCs(); i++) {
		en = Screen->LoadNPC(i);
		if(!GetNPCMiscFlag(en,8) && en->ID != NPC_ITEMFAIRY) {
			enemiesLeft = true;
			break;
		}
	}

	if(enemiesLeft == false) {
		// If you got through the loop without seeing any enemies...

		// Open the "enemy shutters."
		openShuttersEnemy();

		// Set this to false so that we don't bother checking this condition anymore.
		shuttersEnemyClosed = false;
	}
}

// This function opens all "enemy shutters."
void openShuttersEnemy() {
	int i=0;

	// Loop through all (non one-way) shutter combos on the screen...
	while(shutterPos[i] >= 0) {

		// If there are no shutter flags on the combo, it's an "enemy shutter," so open it by incrementing the combo data.
		if(Screen->ComboF[shutterPos[i]] != 98 && Screen->ComboI[shutterPos[i]] != 98 && 
		Screen->ComboF[shutterPos[i]] != 99 && Screen->ComboI[shutterPos[i]] != 99 &&
		Screen->ComboF[shutterPos[i]] != 101 && Screen->ComboI[shutterPos[i]] != 101) {
			Screen->ComboD[shutterPos[i]] = Screen->ComboD[shutterPos[i]]+1;
		}

		i++;
	}

	// If there was at least one "enemy shutter," then we closed it, so let's make it official with an SFX!
	if(i > 0) {
		Game->PlaySound(SFX_SHUTTER);
	}
}

// This function checks if temporary secrets have been activated, and if so, opens "secret shutters."
void openShuttersSecretCheck() {

	if(GetLayerComboF(1,0) < 16 || GetLayerComboF(1,0) > 31) {
		// If the combo in the top-left corner of layer 1 either doesn't have a flag or has a non-secret flag (not flags 16-31)...

		// Open the "secret shutters."
		openShuttersSecret();

		// Set this to false so that we don't bother checking this condition anymore.
		shuttersSecretClosed = false;
	}
}

// This function opens all "secret shutters."
void openShuttersSecret() {
	int i=0;

	// Loop through all (non one-way) shutter combos on the screen...
	while(shutterPos[i] >= 0) {

		// If either:
		//   The combo flag on the shutter is a "secret shutter" flag OR
		//   The inherent flag is a "secret shutter" flag and the combo flag on the shutter is not another type of shutter flag...
		// It's a "secret shutter," so open it by incrementing the combo data.
		if(Screen->ComboF[shutterPos[i]] == 98 || 
		(Screen->ComboI[shutterPos[i]] == 98 && Screen->ComboF[shutterPos[i]] != 99 && Screen->ComboF[shutterPos[i]] != 101)) {
			Screen->ComboD[shutterPos[i]] = Screen->ComboD[shutterPos[i]]+1;
		}

		i++;
	}

	// If there was at least one "secret shutter," then we closed it, so let's make it official with an SFX!
	if(i > 0) {
		Game->PlaySound(SFX_SHUTTER);
	}
}

// This function checks if the screen secrets flag has been activated, and if so, opens "permanent secret shutters."
void openShuttersPermSecretCheck() {
	if(Screen->State[ST_SECRET] == true) {
		// If the secret state has been set to true...

		// Open the "permanent secret shutters."
		openShuttersPermSecret();

		// Set this to false so that we don't bother checking this condition anymore.
		shuttersPermSecretClosed = false;
	}
}

// This function opens all "permanent secret shutters."
void openShuttersPermSecret() {
	int i=0;

	// Loop through all (non one-way) shutter combos on the screen...
	while(shutterPos[i] >= 0) {

		// If either:
		//   The combo flag on the shutter is a "permanent secret shutter" flag OR
		//   The inherent flag is a "permanent secret shutter" flag and the combo flag on the shutter is not another type of shutter flag...
		// It's a "permanent secret shutter," so open it by incrementing the combo data.
		if(Screen->ComboF[shutterPos[i]] == 99 || 
		(Screen->ComboI[shutterPos[i]] == 99 && Screen->ComboF[shutterPos[i]] != 98 && Screen->ComboF[shutterPos[i]] != 101)) {
			Screen->ComboD[shutterPos[i]] = Screen->ComboD[shutterPos[i]]+1;
		}

		i++;
	}

	// If there was at least one "permanent secret shutter," then we closed it, so let's make it official with an SFX!
	if(i > 0) {
		Game->PlaySound(SFX_SHUTTER);
	}
}

// This function checks if the script flag has been activated by another script, and if so, opens "flag shutters."
void openShuttersFlagCheck() {
	if(shutterFlag) {
		// If the shutter flag has been set to true by another script...

		// Open the "flag shutters."
		openShuttersFlag();

		// Set this to false so that we don't bother checking this condition anymore.
		shuttersFlagClosed = false;
	}
}

// This function opens all "flag shutters."
void openShuttersFlag() {
	int i=0;

	// Loop through all (non one-way) shutter combos on the screen...
	while(shutterPos[i] >= 0) {

		// If either:
		//   The combo flag on the shutter is a "flag shutter" flag OR
		//   The inherent flag is a "flag shutter" flag and the combo flag on the shutter is not another type of shutter flag...
		// It's a "flag shutter," so open it by incrementing the combo data.
		if(Screen->ComboF[shutterPos[i]] == 101 || 
		(Screen->ComboI[shutterPos[i]] == 101 && Screen->ComboF[shutterPos[i]] != 98 && Screen->ComboF[shutterPos[i]] != 99)) {
			Screen->ComboD[shutterPos[i]] = Screen->ComboD[shutterPos[i]]+1;
		}

		i++;
	}
	
	// If there was at least one "flag shutter," then we closed it, so let's make it official with an SFX!
	if(i > 0) {
		Game->PlaySound(SFX_SHUTTER);
	}
}

// This function updates the prevScreen and prevDMap to reflect the current screen and dmap.
void updatePrev() {
	prevScreen = Game->GetCurScreen();
	prevDMap = Game->GetCurDMap();
}

// This function kills movement inputs plus A+B inputs.
void noMoveAction() {
	Link->InputUp = false;
	Link->InputDown = false;
	Link->InputLeft = false;
	Link->InputRight = false;
	Link->InputA = false;
	Link->InputB = false;
	Link->PressUp = false;
	Link->PressDown = false;
	Link->PressLeft = false;
	Link->PressRight = false;
	Link->PressA = false;
	Link->PressB = false;
}

//end

// Creates Bitmap
bitmap create(int w, int h) //start
{
	unless(Game->FFRules[qr_OLDCREATEBITMAP_ARGS])
		return Game->CreateBitmap(h, w);
	else
		return Game->CreateBitmap(w, h);
} 
 //end

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
	if(Screen->MovingBlockX>-1){
		if(Abs(Screen->MovingBlockX-x)<=8&&Abs(Screen->MovingBlockY-y)<=8)
			return 1;
	}
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



























