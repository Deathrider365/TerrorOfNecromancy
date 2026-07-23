//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Misc Functions~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

void removeAllItems() {
   // Hero->ItemA = -1;
   // Hero->ItemB = -1;

   for (int i = 0; i < MAX_ITEMDATA; ++i)
      unless(i == ITEM_BOMB1 || i == ITEM_DIFF_NORMAL || i == ITEM_LEVIATHAN_SCALE1 || i == ITEM_LANTERN1) Hero->Item[i] = false;

   Game->Counter[CR_SBOMBS] = 0;
   Game->Counter[CR_BOMBS] = 0;
   Game->Counter[CR_ARROWS] = 0;
   Game->Counter[CR_MONEY] = 0;

   Game->MCounter[CR_SBOMBS] = 0;
   Game->MCounter[CR_BOMBS] = 0;
   Game->MCounter[CR_ARROWS] = 0;
   Game->MCounter[CR_MONEY] = 255;
   Game->Generic[GEN_MAGICDRAINRATE] = 2;

   Game->Counter[CR_MAGIC_EXPANSIONS] = 0;
   Game->Counter[CR_TRIFORCE_OF_COURAGE] = 0;
   Game->Counter[CR_TRIFORCE_OF_POWER] = 0;
   Game->Counter[CR_TRIFORCE_OF_WISDOM] = 0;
   Game->Counter[CR_BOMB_BAG_EXPANSIONS] = 0;
   Game->Counter[CR_QUIVER_EXPANSIONS] = 0;

   Hero->MaxHP = 24;
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
      // clang-format off
      Screen->D[d] ~= 1Lb << reg;
   // clang-format on
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
      // clang-format off
      Screen->D[d] ~= bit;
   // clang-format on
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
      // clang-format off
      val ~= 1Lb << reg;
   // clang-format on

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
      // clang-format off
      val ~= bit;
   // clang-format on

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
   // Big ol table of rough jump values and their durations
   int jumpTBL[] = {0.0, 0, 0.1, 3, 0.2, 4, 0.3, 5, 0.4, 6, 0.5, 8, 0.6, 9, 0.7, 10, 0.8, 11, 0.9, 13, 1.0, 14, 1.1, 15, 1.2, 16, 1.3, 18, 1.4, 19, 1.5, 20, 1.6, 21, 1.7, 23, 1.8, 24, 1.9, 25, 2.0, 26, 2.1, 28, 2.2, 29, 2.3, 30, 2.4, 31, 2.5, 33, 2.6, 34, 2.7, 35, 2.8, 36, 2.9, 38, 3.0, 39, 3.1, 40,
       3.2, 41, 3.3, 43, 3.4, 44, 3.5, 45, 3.6, 47, 3.7, 48, 3.8, 49, 3.9, 51, 4.0, 52, 4.1, 54, 4.2, 55, 4.3, 57, 4.4, 58, 4.5, 60, 4.6, 61, 4.7, 63, 4.8, 64, 4.9, 66, 5.0, 67, 5.1, 69, 5.2, 71, 5.3, 72, 5.4, 74, 5.5, 76, 5.6, 77, 5.7, 79, 5.8, 81, 5.9, 83, 6.0, 85, 6.1, 86, 6.2, 88, 6.3, 90, 6.4,
       92, 6.5, 94, 6.6, 96, 6.7, 98, 6.8, 100, 6.9, 102, 7.0, 104, 7.1, 106, 7.2, 108, 7.3, 110, 7.4, 112, 7.5, 114, 7.6, 116, 7.7, 118, 7.8, 120, 7.9, 123, 8.0, 125, 8.1, 127, 8.2, 129, 8.3, 131, 8.4, 134, 8.5, 136, 8.6, 138, 8.7, 141, 8.8, 143, 8.9, 145, 9.0, 148, 9.1, 150, 9.2, 153, 9.3, 155,
       9.4, 158, 9.5, 160, 9.6, 162, 9.7, 165, 9.8, 168, 9.9, 170, 10.0, 173};

   // When getting a duration from a jump
   unless(inputFrames) {
      // Keep values between 0 and 10, nothing beyond that would be sensible in most cases
      jumpInput = Clamp(jumpInput, 0, 10);

      // Round to the nearest 0.1
      jumpInput *= 10;
      jumpInput = Round(jumpInput);
      jumpInput *= 0.1;

      return jumpTBL[jumpInput * 2 + 1];
   }
   // When getting a jump from a duration
   else {
      int closestIndex = 0;
      int closest = 0;
      // Cycle through the table to find the closest duration to the desired one
      for (int i = 1; i < 100; ++i) {
         if (Abs(jumpTBL[i * 2 + 1] - jumpInput) < Abs(closest - jumpInput)) {
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

   dmapdata dm = Game->LoadDMapData(Game->CurDMap);
   return <ScreenType>(dm->Type & 11b);
}

// Checks if overworld
bool isOverworld(bool dmapOnly) {
   switch (getScreenType(dmapOnly)) {
      case DM_DUNGEON:
      case DM_INTERIOR: return false;
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
   n->NoCollisionTimer = -1;
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

   n->NoCollisionTimer = 0;
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
   return false;
}

// sword1x1 but is 2 wide
void sword2x1(int x, int y, int angle, int dist, int cmb, int cset, int dmg) {
   int hitX = x + VectorX(dist, angle);
   int hitY = y + VectorY(dist, angle);

   x += VectorX(8 + dist, angle) - 8;
   y += VectorY(8 + dist, angle);

   Screen->DrawCombo(2, x, y, cmb, 2, 1, cset, -1, -1, x, y, angle, -1, 0, true, OP_OPAQUE);

   makeHitbox(hitX, hitY, 16, 16, dmg);

   hitX += VectorX(16, angle);
   hitY += VectorY(16, angle);

   makeHitbox(hitX, hitY, 16, 16, dmg);
}

void shadowTrail(npc this, bool addDir, int duration) {
   lweapon trail = CreateLWeaponAt(LW_SCRIPT10, this->X, this->Y);
   trail->OriginalTile = this->Tile;
   trail->Tile = this->Tile;
   trail->CSet = this->CSet;
   trail->Extend = 3;
   trail->TileWidth = this->TileWidth;
   trail->TileHeight = this->TileHeight;
   trail->NoCollisionTimer = -1;
   trail->DeadState = duration;
   trail->DrawStyle = DS_PHANTOM;
}

bool validSpawn(int pos) {
   int x = ComboX(pos);
   int y = ComboY(pos);

   if (Screen->isSolid(x + 4, y + 4) || Screen->isSolid(x + 12, y + 4) || Screen->isSolid(x + 4, y + 12) || Screen->isSolid(x + 12, y + 12))
      return false;

   if (ComboFI(pos, CF_NOENEMY) || ComboFI(pos, CF_NOGROUNDENEMY))
      return false;

   int ct = Screen->ComboT[pos];

   if (ct == CT_NOENEMY || ct == CT_NOGROUNDENEMY || ct == CT_NOJUMPZONE)
      return false;
   if (ct == CT_WATER || ct == CT_LADDERONLY || ct == CT_HOOKSHOTONLY || ct == CT_LADDERHOOKSHOT)
      return false;
   if (ct == CT_PIT || ct == CT_PITB || ct == CT_PITC || ct == CT_PITD || ct == CT_PITR)
      return false;

   return true;
}

// Modifies the game over menu text, background color, and midi
void setGameOverMenu(Color bg, Color text, Color flash, int midi) {
   Game->GameOverScreen[GOS_BACKGROUND] = bg;

   //TODO find this
   // Game->GameOverScreen[GOS_FONT] = 0;

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
   unless(Game->FFRules[qr_OLDCREATEBITMAP_ARGS]) b->Create(0, h, w);
   else b->Create(0, w, h);

   return b;
}

// Calculates the percent that part is of whole
float PercentOfWhole(int part, int whole) {
   return (100 * part) / whole;
}

// Checks if switch is pressed
int switchPressed(int x, int y, bool noLink, bool sensitive) {
   int xOff = 0;
   int yOff = sensitive ? 0 : 4;
   int xDist = 8;
   int yDist = 8;

   if (Abs(Hero->X + xOff - x) <= xDist && Abs(Hero->Y + yOff - y) <= yDist && Hero->Z == 0 && !noLink)
      return 1;

   if (Screen->MovingBlockX > -1)
      if (Abs(Screen->MovingBlockX - x) <= 8 && Abs(Screen->MovingBlockY - y) <= 8)
         return 1;

   if (Screen->isSolid(x + 4, y + 4) || Screen->isSolid(x + 12, y + 4) || Screen->isSolid(x + 4, y + 12) || Screen->isSolid(x + 12, y + 12)) {
      return 2;
   }

   return 0;
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
void traceToScreen(int x, int y, int val) {
   Screen->DrawInteger(7, x, y, FONT_Z3SMALL, 0x01, 0x08, -1, -1, val, 0, 128);
}

// Creats a screenshot of the current map
void takeMapScreenshot() {
   unless(DEBUG) return;

   if (DEBUG && Input->KeyPress[KEY_P]) {
      CONFIG DELAY = 3;

      if (PressControl())
         Emily::doAllMapScreenshots(DELAY);
      else
         Emily::doMapScreenshot(Game->CurMap, DELAY);
   }
}

// Disables Link
void disableLink() {
	for (int i = CB_UP; i < MAX_NOACTION_INPUT; ++i) {
		if (i == CB_MAP && NOACTION_SKIP_MAP) continue;
		if (i == CB_START && NOACTION_SKIP_START) continue;
		Input->Button[i] = false;
		Input->Press[i] = false;
	}
	/*
	Hero->InputUp = false; Hero->PressUp = false;
	Hero->InputDown = false; Hero->PressDown = false;
	Hero->InputLeft = false; Hero->PressLeft = false;
	Hero->InputRight = false; Hero->PressRight = false;
	Hero->InputR = false; Hero->PressR = false;
	Hero->InputL = false; Hero->PressL = false;
	Hero->InputA = false; Hero->PressA = false;
	Hero->InputB = false; Hero->PressB = false;
	Hero->InputEx1 = false; Hero->PressEx1 = false;
	Hero->InputEx2 = false; Hero->PressEx2 = false;
	Hero->InputEx3 = false; Hero->PressEx3 = false;
	Hero->InputEx4 = false; Hero->PressEx4 = false;
	*/

   // Hero->PressStart = false;
   // Hero->InputStart = false;
   // Hero->PressMap = false;
   // Hero->InputMap = false;
}

// Checks if a certain trigger went off
bool wasTriggered(float trigger) {
   CONFIG TT_NO_TRIGGER_SET = 1;
   CONFIG TT_SCREEND_SET = 2;
   CONFIG TT_SCREEND_NOT_SET = 3;
   CONFIG TT_SECRETS_TRIGGERED = 4;
   CONFIG TT_SECRETS_NOT_TRIGGERED = 5;
   CONFIG TT_ITEM_ACQUIRED = 6;
   CONFIG TT_ITEM_NOT_ACQUIRED = 7;

   int triggerType = Floor(trigger);
   int triggerValue = (trigger % 1) / 1L;

   switch (triggerType) {
      case TT_NO_TRIGGER_SET: return false;
      case TT_SCREEND_SET: return getScreenD(triggerValue);
      case TT_SCREEND_NOT_SET: return !getScreenD(triggerValue);
      case TT_SECRETS_TRIGGERED: return Screen->State[ST_SECRET];
      case TT_SECRETS_NOT_TRIGGERED: return !Screen->State[ST_SECRET];
      case TT_ITEM_ACQUIRED: return Hero->Item[triggerValue];
      case TT_ITEM_NOT_ACQUIRED: return !Hero->Item[triggerValue];
      default: return false;
   }
}

void notDuringCutsceneLink() {
   Hero->Stun = 60; //TODO find a better solution
   // Hero->Stun = 999; //TODO find a better solution
   Hero->PressStart = false;
   Hero->InputStart = false;
   Hero->PressMap = false;
   Hero->InputMap = false;
}

// CanWalk() that respects diagonals
bool CanWalk8(int x, int y, int dir, int step, bool full_tile) {
   switch (dir) {
      case DIR_LEFTUP: return CanWalk(x, y, DIR_LEFT, step, full_tile) && CanWalk(x, y, DIR_UP, step, full_tile); break;
      case DIR_RIGHTUP: return CanWalk(x, y, DIR_RIGHT, step, full_tile) && CanWalk(x, y, DIR_UP, step, full_tile); break;
      case DIR_LEFTDOWN: return CanWalk(x, y, DIR_LEFT, step, full_tile) && CanWalk(x, y, DIR_DOWN, step, full_tile); break;
      case DIR_RIGHTDOWN: return CanWalk(x, y, DIR_RIGHT, step, full_tile) && CanWalk(x, y, DIR_DOWN, step, full_tile); break;
      default: return CanWalk(x, y, dir, step, full_tile); break;
   }
}

// Checks if link is against a ffc and looking at it
bool againstFFC(int ffcX, int ffcY, bool onlyBottom = false) { //TODO account for larger FFCs (use this->Width/Height and pass in the ffc to this function)
   if (Hero->Z == 0) {
      if (Abs((Hero->X) - (ffcX)) <= 8) {
         if (Hero->Y >= ffcY && Hero->Y - ffcY <= 14 && Hero->Dir == DIR_UP)
            return true;
         else if (!onlyBottom && Hero->Y < ffcY && ffcY - Hero->Y <= 16 && Hero->Dir == DIR_DOWN)
            return true;
      }
      else if (!onlyBottom && Abs((Hero->Y) - (ffcY)) <= 8) {
         if (Hero->X > ffcX && Hero->X - ffcX <= 16 && Hero->Dir == DIR_LEFT)
            return true;
         else if (Hero->X < ffcX && ffcX - Hero->X <= 16 && Hero->Dir == DIR_RIGHT)
            return true;
      }
   }
   return false;
}

void waitForTalking(ffc this, bool onlyBottom = false) {
   until(againstFFC(this->X, this->Y, onlyBottom) && Input->Press[CB_A]) {
      if (againstFFC(this->X, this->Y, onlyBottom))
         Screen->FastCombo(7, Hero->X - 10, Hero->Y - 15, 48, 0, OP_OPAQUE);

      Waitframe();
   }

   Input->Button[CB_A] = false;
}

void gridLockFFC(ffc this) {
   int remainderX = this->X % 16;
   int remainderY = this->Y % 16;

   if (remainderX) {
      if (remainderX < 8)
         this->X -= remainderX;
      else
         this->X += remainderX;
   }

   if (remainderY) {
      if (remainderY < 8)
         this->Y -= remainderY;
      else
         this->Y += remainderY;
   }
}

void hurtDatHero(int frequency, int damage) {
   if (gameframe % frequency == 0 && !HeroIsScrollingOrWarping()) {
      Hero->HP -= damage;
      Audio->PlaySound(getHeroHitSound());
   }
}

void handleHeatOrCold(int armorLevel, int damage) {
   while (true) {
      int ringLevel = GetHighestLevelItemOwned(IC_RING);

      if (ringLevel < 0)
         hurtDatHero(60, damage);
      else {
         itemdata itemData = Game->LoadItemData(ringLevel);
         int lvl = itemData->Level;

         if (lvl < armorLevel)
            hurtDatHero(60, damage);
      }

      Waitframe();
   }
}

// Use this function to disable some items while in a minecart
bool CanUseItemInMinecart(int itemid) {
   if (itemid == ITEM_HOOKSHOT1 || itemid == ITEM_HOOKSHOT2)
      return false;
   return true;
}

int getHeroHitSound() {
   return Choose(SFX_HERO_HURT_1, SFX_HERO_HURT_2, SFX_HERO_HURT_3, SFX_HERO_HURT_4, SFX_HERO_HURT_5, SFX_HERO_HURT_6);
}

bool viewportContainsRect(int x, int y, int width, int height) {
   if (Viewport->Contains(x, y))
      return true;
   if (Viewport->Contains(x + width - 1, y + height - 1))
      return true;
   if (Viewport->Contains(x, y + height - 1))
      return true;
   if (Viewport->Contains(x + width - 1, y))
      return true;

   return false;
}

void runCredits(int fadespeed, int font, int fontheight) {
   const int BLACK = 0x08;
   const int WHITE = 0x0C;
   const int SCROLL_SPEED = 2;
   const int TEXT_SPACING = 6;	//was 4
   const int HEADER_SPACING = 8;

	int bossMusic[] = "AAA Ninja's Respite (Past) - The Messenger.ogg";
   Audio->PlayEnhancedMusic(bossMusic, 0);

   for(int q = 0; q < 129; ++q) {
		for(int timer = 0; timer < fadespeed; ++timer) {
			Screen->Rectangle(7, 0, -56, q, 168, BLACK, 1, 0, 0, 0, true, OP_OPAQUE);
			Screen->Rectangle(7, 256-q, -56, 256, 168, BLACK, 1, 0, 0, 0, true, OP_OPAQUE);
			disableLink();
			Waitframe();
		}
	}

	Game->Save();
	int authorHeader[] = "Author:";
	int authorName[] = "Deathrider365";

	int specialThanksHeader[] = "Advisors and General Help:";
	int specialThanks1[] = "Venrob";
	int specialThanks2[] = "ZoriaRPG";
	int specialThanks3[] = "Dimentio";
	int specialThanks4[] = "Lut";
	int specialThanks5[] = "Mitsukara";
	int specialThanks6[] = "Moosh";

	int betaTestersHeader[] = "Beta Testers:";
	int betaTester1[] = "ZachAttack20192001";
	int betaTester2[] = "a30502355";
	int betaTester3[] = "P-Tux7";
	int betaTester4[] = "Weirddud101";
	int betaTester5[] = "Soma C.";

	int musicHeader[] = "Music Used (in order of use):";
	int track1[] = "mp2d_TallonOverworld2D";
	int track2[] = "Dark Cave (Future) - The Messenger";
	int track3[] = "Dark Cave (Past) - The Messenger";
	int track4[] = "Beneath the Tides (Past) - The Messenger";
	int track5[] = "Beneath the Tides (Future) - The Messenger";
	int track6[] = "Phantom of Yore (Past) - The Messenger";
	int track7[] = "Ninja's Respite (Past) - The Messenger";

	int tilesetHeader[] = "Tileset Used (never use this hot garbage):";
	int tileset[] = "ezgbz 1.92";

	int end[] = "THE END";

	int gametime[32];
	int minutes = (Game->Time / (3600)) * 10000;
	int seconds = ((Game->Time % .3600) / 60) * 10000;
	int frames = (Game->Time % .0060) * 10000;
	int pos = itoa(gametime, 0, minutes);
	gametime[pos] = ':';
	pos += 1 + itoa(gametime, pos+1, seconds);
	gametime[pos] = '.';
	itoa(gametime, pos+1, frames);

	int numText = 23;		//when adding more lines add more to this
	int numHeader = 4;		// if there are to be more headers add more to this
	int VERTICAL_HEIGHT = Max(((fontheight+TEXT_SPACING) * (numText)) + (numHeader*HEADER_SPACING) + (224), 0);
	int q = -168;
	for (; q < VERTICAL_HEIGHT; ++q) {
		for (int timer = 0; timer < SCROLL_SPEED; ++timer) {
			Screen->Rectangle(7, 0, -56, 256, 176, BLACK, 1, 0, 0, 0, true, OP_OPAQUE);
			int y = 0;
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, authorHeader, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, authorName, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING + HEADER_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, specialThanksHeader, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, specialThanks1, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, specialThanks2, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, specialThanks3, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, specialThanks4, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, specialThanks5, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, specialThanks6, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING + HEADER_SPACING);

			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, betaTestersHeader, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, betaTester1, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, betaTester2, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, betaTester3, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, betaTester4, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, betaTester5, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING + HEADER_SPACING);

			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, musicHeader, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, track1, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, track2, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, track3, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, track4, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, track5, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, track6, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, track7, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING + HEADER_SPACING);


			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, tilesetHeader, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, tileset, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);

			y += 224;
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, end, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, gametime, OP_OPAQUE);
			disableLink();
			Waitframe();
		}
	}
	--q;
	while(!Hero->InputStart)
	{
			Screen->Rectangle(7, 0, -56, 256, 176, BLACK, 1, 0, 0, 0, true, OP_OPAQUE);
			int y = 0;
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, authorHeader, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, authorName, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING + HEADER_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, specialThanksHeader, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, specialThanks1, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, specialThanks2, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, specialThanks3, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, specialThanks4, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, specialThanks5, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, specialThanks6, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING + HEADER_SPACING);

			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, betaTestersHeader, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, betaTester1, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, betaTester2, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, betaTester3, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, betaTester4, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, betaTester5, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING + HEADER_SPACING);

			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, musicHeader, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, track1, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, track2, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, track3, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, track4, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, track5, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, track6, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, track7, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING + HEADER_SPACING);

			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, tilesetHeader, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, tileset, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);

			y += 224;
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, end, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, gametime, OP_OPAQUE);
			disableLink();
			Waitframe();
	}
}

void introSequenceSceneTransitions(int dmap, int screen) {
      for (int i = 0; i < INTRO_SCENE_TRANSITION_FRAMES; ++i) {
         disableLink();
         Screen->Rectangle(7, 0 - i * INTRO_SCENE_TRANSITION_MULT, 0, 256 - i * INTRO_SCENE_TRANSITION_MULT, 176, C_BLACK, 1, 0, 0, 0, true, OP_OPAQUE);
         Waitframe();
      }

      for (int i = 0; i < 180; ++i) {
         disableLink();
         Waitframe();
      }

      for (int i = 0; i < INTRO_SCENE_TRANSITION_FRAMES; ++i) {
         disableLink();
         Screen->Rectangle(7, 256 - i * INTRO_SCENE_TRANSITION_MULT, 0, 512 - i * INTRO_SCENE_TRANSITION_MULT, 176, C_BLACK, 1, 0, 0, 0, true, OP_OPAQUE);
         Waitframe();
      }

      Hero->Warp(dmap, screen);
}