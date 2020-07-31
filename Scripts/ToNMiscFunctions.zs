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

// Does a jump to link
void jumpAttack() //start
{

} //end


























