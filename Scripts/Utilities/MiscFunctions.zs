///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Misc Functions~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

void giveStartingCrap() {
   //Have what the player would have at the beginning
}

void removeAllItems() {
   for(int i = 0; i < MAX_ITEMDATA; ++i)
      unless(i == 3 || i == I_DIFF_NORMAL || i == 183 || i == 208)
         Hero->Item[i] = false;
      
   Game->Counter[CR_SBOMBS] = 0;
   Game->Counter[CR_BOMBS] = 0;
   Game->Counter[CR_ARROWS] = 0;
   Game->Counter[CR_RUPEES] = 0;				

   Game->MCounter[CR_SBOMBS] = 0;
   Game->MCounter[CR_BOMBS] = 0;
   Game->MCounter[CR_ARROWS] = 0;
   Game->MCounter[CR_RUPEES] = 255;
   Game->Generic[GEN_MAGICDRAINRATE] = 2;
   
   Game->Counter[CR_MAGIC_EXPANSIONS] = 0;
   Game->Counter[CR_TRIFORCE_OF_COURAGE] = 0;
   Game->Counter[CR_TRIFORCE_OF_POWER] = 0;
   Game->Counter[CR_TRIFORCE_OF_WISDOM] = 0;
   Game->Counter[CR_BOMB_BAG_EXPANSIONS] = 0;
   Game->Counter[CR_QUIVER_EXPANSIONS] = 0;
   
   Hero->MaxHP = 48;
   Hero->MaxMP = 32;

   Hero->HP = Hero->MaxHP;
   Hero->MP = Hero->MaxMP;
}

// Set Screen->D
void setScreenD(int reg, bool state) {
   int d = Div(reg, 32);
   reg %= 32;
   
   if (state) 
      Screen->D[d] |= 1Lb << reg;
   else
      Screen->D[d] ~= 1Lb << reg;
}

// Get Screen->D
bool getScreenD(int reg) {
   int d = Div(reg, 32);
   reg %= 32;
   return Screen->D[d] & (1Lb << reg);
}

// Set Screen->D
void setScreenD(int d, long bit, bool state) {
   if (state)
      Screen->D[d] |= bit;
   else
      Screen->D[d] ~= bit;
}

// Get Screen->D
long getScreenD(int d, long bit) {
   return Screen->D[d] & bit;
}

// Set Screen->D for remote screen
void setScreenD(int dmap, int scr, int reg, bool state) {
   int d = Div(reg, 32);
   reg %= 32;

   long val = Game->GetDMapScreenD(dmap, scr, d);
   
   if (state)
      val |= 1Lb << reg;
   else
      val ~= 1Lb << reg;
   
   Game->SetDMapScreenD(dmap, scr, d, val);
}

// Get Screen->D for remote screen
bool getScreenD(int dmap, int scr, int reg) {
   int d = Div(reg, 32);
   reg %= 32;
   return Game->GetDMapScreenD(dmap, scr, d) & (1Lb << reg);
}

// Set Screen->D for remote screen
void setScreenD(int dmap, int scr, int d, long bit, bool state) {
   long val = Game->GetDMapScreenD(dmap, scr, d);
   
   if (state)
      val |= bit;
   else
      val ~= bit;
   
   Game->SetDMapScreenD(dmap, scr, d, val);
}

// Get Screen->D for remote screen
long getScreenD(int dmap, int scr, int d, long bit) {
   return Game->GetDMapScreenD(dmap, scr, d) & bit;
}

// Calculate difference between 2 angles
float angleDiff(float angle1, float angle2) {
	float dif = angle2 - angle1;

	if (dif >= 180)
      dif -= 360;
	else if (dif <= -180)
		dif += 360;

	return dif;
}

// Turn one angle towards another angle by a fixed amount
float turnToAngle(float angle1, float angle2, float step) {
	if (Abs(angleDiff(angle1, angle2)) > step)
		return angle1 + Sign(angleDiff(angle1, angle2)) * step;
	else
		return angle2;
}

// Calculates a jump length
int getJumpLength(int jumpInput, bool inputFrames) {
   //Big ol table of rough jump values and their durations
   int jumpTBL[] = {
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
	};

   //When getting a duration from a jump
   unless (inputFrames) {
      //Keep values between 0 and 10, nothing beyond that would be sensible in most cases
      jumpInput = Clamp(jumpInput, 0, 10);
      
      //Round to the nearest 0.1
      jumpInput *= 10;
      jumpInput = Round(jumpInput);
      jumpInput *= 0.1;

      return jumpTBL[jumpInput * 2 + 1];
   } 
   //When getting a jump from a duration
	else {
      int closestIndex = 0;
      int closest = 0;
      //Cycle through the table to find the closest duration to the desired one
      for (int i = 1; i < 100; ++i) {
         if (Abs(jumpTBL[i * 2 + 1]-jumpInput) < Abs(closest - jumpInput)) {
            closestIndex = i;
            closest = jumpTBL[i * 2 + 1];
         }
      }

      return jumpTBL[closestIndex * 2 + 0];
	}
}

// Converts an 18 bit value to a 32 bit value
int convertBit(int b18) {
	return b18 / 10000;
}

// Gets screen type
ScreenType getScreenType(bool dmapOnly) {
   unless(dmapOnly) {
      if (IsDungeonFlag())
         return DM_DUNGEON;
      if (IsInteriorFlag())
         return DM_INTERIOR;
   }
   
	dmapdata dm = Game->LoadDMapData(Game->GetCurDMap());
	return <ScreenType> (dm->Type & 11b);
}

// Checks if overworld
bool isOverworld(bool dmapOnly) {
   switch(getScreenType(dmapOnly)) {
      case DM_DUNGEON:
      case DM_INTERIOR:
         return false;
   }
	return true;
}

// Prioretizes the horizontal direction when dealing with diagonals
int dir8To4(int dir) {
   return dir <= DIR_RIGHT ? dir : remY(dir);
}

// Does a jump to link and flies off screen
void jumpOffScreenAttack(npc n, int upTile, int downTile) {
   CONFIG JUMP_RATE = 4;
   CONFIG SLAM_RATE = JUMP_RATE * 3;
   CONFIG EW_SLAM = EW_SCRIPT10;
   CONFIG STUN = 30;
   CONFIG SLAM_COMBO = 6852;
   CONFIG SLAM_COMBO_CSET = 8;
   
   combodata cd = Game->LoadComboData(SLAM_COMBO);
   bool grav = n->Gravity;
   int oTile = n->ScriptTile;
   
   Audio->PlaySound(SFX_SUPER_JUMP);
   
   n->Gravity = false;
   n->CollDetection = false;
   n->ScriptTile = upTile;
   
   while (n->Z < 256) {
      n->Z += JUMP_RATE;
      Waitframe();
	}
   
   n->X = Hero->X;
   n->Y = Hero->Y;
   n->ScriptTile = downTile;
   
   while (n->Z > 0) {
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

   for (int i = 0; i < STUN; ++i) {
      Screen->DrawCombo(2, n->X - 16, n->Y - 16, SLAM_COMBO, 3, 3, SLAM_COMBO_CSET, -1, -1, 0, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
      Waitframe();
	}

   n->ScriptTile = oTile;

}

// sword1x1 but checks for lweapon sword collision
bool sword1x1Collision(int x, int y, int angle, int dist, int cmb, int cset, int dmg) {
   eweapon hitbox = sword1x1(x, y, angle, dist, cmb, cset, dmg);
   lweapon sword = LoadLWeaponOf(LW_SWORD);

   if (sword->isValid())
      return Collision(sword, hitbox) && (Hero->Action == LA_ATTACKING || Hero->Action == LA_SPINNING);
}

// sword1x1 but is 2 wide
void sword2x1(int x, int y, int angle, int dist, int cmb, int cset, int dmg) {
   int hitX = x;
   int hitY = y;

   x += VectorX(8 + dist, angle) - 8;
   y += VectorY(8 + dist, angle);

   Screen->DrawCombo(2, x, y, cmb, 2, 1, cset, -1, -1, x, y, angle, -1, 0, true, OP_OPAQUE);

   makeHitbox(x, y, 16, 16, dmg);

   hitX += VectorX(16, angle);
   hitY += VectorY(16, angle);

   makeHitbox(x, y, 16, 16, dmg);
}

// Ghost enemees beh shakin
void enemyShake(ffc this, npc ghost, int frames, int intensity) {
   for (int i = 0; i < frames; ++i) {
      ghost->DrawXOffset = Rand(-intensity, intensity);
      ghost->DrawYOffset = Rand(-intensity, intensity) - 2;
      
      Ghost_Waitframe(this, ghost);
   }

   ghost->DrawXOffset = 0;
   ghost->DrawYOffset = -2;
}

// Ghost enemy shadowtrail
void Ghost_ShadowTrail(ffc this, npc ghost, bool addDir, int duration) {
   int tile = addDir ? Game->ComboTile(Ghost_Data + Ghost_Dir) : Game->ComboTile(Ghost_Data);

   int cset = this->CSet;
   int w = Ghost_TileWidth;
   int h = Ghost_TileHeight;

   lweapon trail = CreateLWeaponAt(LW_SCRIPT10, Ghost_X, Ghost_Y);
   trail->OriginalTile = tile;
   trail->Tile = tile;
   trail->CSet = cset;
   trail->Extend = 3;
   trail->TileWidth = w;
   trail->TileHeight = h;
   trail->CollDetection = false;
   trail->DeadState = duration;
   trail->DrawStyle = DS_PHANTOM;
}

//	Calls an EWeapon script
void runEWeaponScript(eweapon e, int scr, int args) {
   e->Script = scr;
   int numArgs = SizeOfArray(args);

   for (int i = 0; i < numArgs; ++i)
      e->InitD[i] = args[i];
}

// Checks if ghost enemy can move
bool Ghost_CanPlace(int X, int Y, int w, int h) {
   for (int x = 0; x <= w - 1; x = Min(x + 8, w - 1)) {
      for(int y = 0; y <= h - 1; y = Min(y + 8, h - 1)) {
         if (!Ghost_CanMovePixel(X + x, Y + y))
            return false;
         if (y == h - 1)
            break;
      }
      if (x == w - 1)
         break;
   }
   return true;
}

// Modifies the game over menu text, background color, and midi
void setGameOverMenu(Color bg, Color text, Color flash, int midi) {
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
}

// Creates Bitmap again
bitmap recreate(bitmap b, int w, int h) {
   unless (Game->FFRules[qr_OLDCREATEBITMAP_ARGS])
      b->Create(0, h, w);
   else
      b->Create(0, w, h);

   return b;
}

// Calcualtes the percent that part is of whole
float PercentOfWhole(int part, int whole) //start
{
	return (100 * part)/whole;
} //end

// Checks if switch is pressed
int switchPressed(int x, int y, bool noLink) {
   int xOff = 0;
   int yOff = 4;
   int xDist = 8;
   int yDist = 8;

   if (Abs(Link->X + xOff - x) <= xDist && Abs(Link->Y + yOff - y) <= yDist && Link->Z == 0 && !noLink)
      return 1;

   if (Screen->MovingBlockX >- 1)
      if(Abs(Screen->MovingBlockX - x) <= 8 && Abs(Screen->MovingBlockY - y) <= 8)
         return 1;

   if (Screen->isSolid(x + 4, y + 4) ||
      Screen->isSolid(x + 12, y + 4) ||
      Screen->isSolid(x + 4, y + 12) ||
      Screen->isSolid(x + 12, y + 12)) {
      return 2;
   }

   return 0;
}

// Checks if link is against a combo and looking at it
bool againstCombo(int loc) {
   if (Hero->Z == 0) {
      if (Abs((Hero->X + 8) - (ComboX(loc) + 8)) <= 8) {
         if (Hero->Y > ComboY(loc) && Hero->Y - ComboY(loc) <= 8 && Hero->Dir == DIR_UP)
            return true;
         else if (Hero->Y < ComboY(loc) && ComboY(loc) - Hero->Y <= 16 && Hero->Dir == DIR_DOWN)
            return true;
      }
      else if (Abs((Hero->Y + 8) - (ComboY(loc) + 8)) <= 8) {
         if (Hero->X > ComboX(loc) && Hero->X - ComboX(loc) <= 16 && Hero->Dir == DIR_LEFT)
            return true;
         else if (Hero->X < ComboX(loc) && ComboX(loc) - Hero->X <= 16 && Hero->Dir == DIR_RIGHT)
            return true;
      }
   }
   return false;
}

// Checks if link is against a ffc and looking at it
bool againstFFC(int ffcX, int ffcY) {
   if (Hero->Z == 0) {
      if (Abs((Hero->X) - (ffcX)) <= 8) {
         if (Hero->Y > ffcY && Hero->Y - ffcY <= 8 && Hero->Dir == DIR_UP)
            return true;
         else if (Hero->Y < ffcY && ffcY - Hero->Y <= 16 && Hero->Dir == DIR_DOWN)
            return true;
      }
      else if (Abs((Hero->Y) - (ffcY)) <= 8) {
         if (Hero->X > ffcX && Hero->X - ffcX <= 16 && Hero->Dir == DIR_LEFT)
            return true;
         else if (Hero->X < ffcX && ffcX - Hero->X <= 16 && Hero->Dir == DIR_RIGHT)
            return true;
      }
   }
   return false;
}

// TODO not a misc function
void leavingTransition(int dmap, int screen, int usingPresents) {
   for (int i = 0; i < INTRO_SCENE_TRANSITION_FRAMES; ++i) {
      disableLink();
      
      if (usingPresents)
         Screen->DrawTile(6, 24, 24, 42406, 13, 3, 0, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
         
      Screen->Rectangle(7, 256 - i * INTRO_SCENE_TRANSITION_MULT, 0, 512 - i * INTRO_SCENE_TRANSITION_MULT, 176, C_BLACK, 1, 0, 0, 0, true, OP_OPAQUE);
      Waitframe();
   }

   Hero->Warp(dmap, screen);
}

// TODO not a misc function
void enteringTransition() {
   for (int i = 0; i < INTRO_SCENE_TRANSITION_FRAMES; ++i) {
      Screen->Rectangle(7, 0 - i * INTRO_SCENE_TRANSITION_MULT, 0, 256 - i * INTRO_SCENE_TRANSITION_MULT, 176, C_BLACK, 1, 0, 0, 0, true, OP_OPAQUE);
      Waitframe();
   }
}

// Checks if FFC is on top of link
bool onTop(int ffcX, int ffcY) {
   return (Abs(Hero->X - ffcX) <= 8 && Abs(Hero->Y - ffcY) <= 8);
}

// Chooses a random value from a give array
untyped chooseArray(untyped arr) {
   return arr[Rand(SizeOfArray(arr))];
}

// Draws a given integer to the screen
void traceToScreen(int x, int y, int val){
   Screen->DrawInteger(7, x, y, FONT_Z3SMALL, 0x01, 0x08, -1, -1, val, 0, 128);
}

// Creats a screenshot of the current map 
void takeMapScreenshot() {
   unless(DEBUG) return;
   
   if(DEBUG && Input->KeyPress[KEY_P]) {
      CONFIG DELAY = 3;
      
      if (PressControl()) 
         Emily::doAllMapScreenshots(DELAY); 
      else
         Emily::doMapScreenshot(Game->GetCurMap(), DELAY);
   }
}

// Disables Link	
void disableLink() {
   NoAction();
   Link->PressStart = false;
   Link->InputStart = false;
   Link->PressMap = false;
   Link->InputMap = false;
}

// Checks if a certain trigger went off
bool wasTriggered(float trigger) {
   int triggerType = Floor(trigger);
   int triggerValue = (trigger % 1) / 1L;
   
   switch (triggerType) {
      case TT_NO_TRIGGER_SET:
         return false;
      case TT_SCREEND_SET:
         return getScreenD(triggerValue);
      case TT_SCREEND_NOT_SET:
         return !getScreenD(triggerValue);
      case TT_SECRETS_TRIGGERED:
         return Screen->State[ST_SECRET];
      case TT_SECRETS_NOT_TRIGGERED:
         return !Screen->State[ST_SECRET];
      case TT_ITEM_ACQUIRED:
         return Hero->Item[triggerValue];
      case TT_ITEM_NOT_ACQUIRED:
         return !Hero->Item[triggerValue];
      default:
         return false;
   }
}

 void notDuringCutsceneLink() {    
   Hero->Stun = 999;
   Link->PressStart = false;
   Link->InputStart = false;
   Link->PressMap = false;
   Link->InputMap = false;
}




