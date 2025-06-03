#option SHORT_CIRCUIT on
//Include required headers, without allowing duplication - don't remove these!
#option HEADER_GUARD on
#include "std.zh"
#include "ffcscript.zh"
#include "VenrobMisc.zh"

using namespace Venrob;

/**
* Author: Venrob
* Version: 1.0
* Release: June 24rd, 2019
* Purpose: Stealth system, based off of Wind Waker.
*/
namespace WindWakerStealth
{
	typedef const int DEFINE;
	typedef const int CONFIG;
	CONFIG BARREL_ITEM = 0; //Item ID of item with `barrelItem` script assigned
	CONFIG DRAW_LAYER = 6;
	CONFIG DRAW_OPACITY = OP_TRANS;
	CONFIG WARP_SFX = 0; //Sound to play during warp
	CONFIG WARP_EFFECT = WARPEFFECT_NONE; //Any 'WARPEFFECT_' constant
	CONFIG WARP_FLAGS = 0; //A bitwise-or of any number of 'WARP_FLAG_' constants, or 0 for no flags
	CONFIG CAUGHT_SFX = 0; //A sound for being caught. In Wind Waker, this was a whistle sound.
	ffc script hidableBarrel
	{
		/**
		 * A barrel that can be picked up to hide under.
		 */
		void run()
		{
			while(true)
			{
				ffcSolid(this); //Fake solidity function. Not fully tested.
				if(Input->Press[CB_A] && canPickUpBarrel() && HeroAgainstFFC(this))
				{
					Input->Press[CB_A] = false;
					Input->Button[CB_A] = false;
					Hero->Item[BARREL_ITEM] = true;
					lastHeldBarrelCombo = this->Data;
					this->Data = 0;
					this->Script = 0;
					Quit();
				}
				Waitframe();
			}
		}
		
		bool canPickUpBarrel()
		{
			if(Hero->Item[BARREL_ITEM]) return false;
			switch(Hero->Action)
			{
				//Add more valid actions here, if you wish
				case LA_NONE:
				case LA_WALKING:
					return true;
			}
			return false;
		}
	}


	bool HeroAgainstFFC(ffc f)
	{
		return HeroAgainstFFC(f, 4);
	}

	bool HeroAgainstFFC(ffc f, int sideWeight)
	{
		switch(Hero->Dir)
		{
			case DIR_UP:
				int heightdiff = Hero->BigHitbox ? 16 : 8;
				if(Hero->X > f->X - sideWeight && Hero->X < f->X + 15 - sideWeight)
				{
					return Hero->Y == f->Y + heightdiff;
				}
				break;
			case DIR_DOWN:
				if(Hero->X > f->X - sideWeight && Hero->X < f->X + 15 - sideWeight)
				{
					return Hero->Y == f->Y - 16;
				}
				break;
			case DIR_RIGHT:
				if(Hero->Y > f->Y - sideWeight && Hero->Y < f->Y + 15 - sideWeight)
				{
					return Hero->X == f->X - 16;
				}
				break;
			case DIR_LEFT:
				if(Hero->Y > f->Y - sideWeight && Hero->Y < f->Y + 15 - sideWeight)
				{
					return Hero->X == f->X + 16;
				}
				break;
		}
	}

	int lastHeldBarrelCombo;
	item script barrelItem
	{
		/**
		 * Setup: The item this is set to should have a tile modifier set, so that the hero looks as though he is under a barrel.
		 * D0: If 0, barrel can only be placed on walkable areas. Else, ignores solidity.
		 * D1: If 0, all graphics are handled by the LTM. If 1, the barrel combo will be drawn over Hero when he is hiding.
		 *     Note: the walking tiles still need to be handled by the LTM.
		 * QRs:
		 * 	`ZScript->Quest Script Settings->Item Scripts Run for Multiple Frames` must be checked
		 */
		void run(bool ignoreSolidity, bool drawComboWhenHiding)
		{
			combodata c = Game->LoadComboData(lastHeldBarrelCombo); //Store the combo data to place the FFC back down later
			lastHeldBarrelCombo = NULL;
			while(true)
			{
				//Prevent using any items
				Hero->ItemJinx = 2;
				Hero->SwordJinx = 2;
				//Is the player attempting to place down the barrel? And can they?
				if(HeroIsHiding())
					Screen->FastCombo(3, Hero->X, Hero->Y, c->ID, c->CSet, OP_OPAQUE);
				if(Input->Press[CB_A] && checkCanPlaceBarrel(ignoreSolidity))
				{
					//Run the barrel script, with this itemID, and load a pointer to it
					int ffcID = RunFFCScript(Game->GetFFCScript("hidableBarrel"), {this->ID});
					if(!ffcID)
					{
						TraceS("Failed to find FFC to place barrel!\n");
					}
					else
					{
						ffc f = Screen->LoadFFC(ffcID);
						f->X = Hero->X + dirX(Hero->Dir) * 16;
						f->Y = Hero->Y + dirY(Hero->Dir) * 16;
						unless(Hero->BigHitbox || Hero->Dir != DIR_UP) f->Y += 8; //Handle normal-hitbox Hero facing up
						f->Data = c->ID;
						f->CSet = c->CSet;
						Hero->Item[this->ID] = false;
						Quit();
					}
				}
				Waitframe();
			}
		}
		
		//Returns true if the 16x16 area directly in front of Hero is walkable.
		//If `ignoreSolidity` is true, only checks that the area is all on-screen.
		bool checkCanPlaceBarrel(bool ignoreSolidity)
		{
			int x = Hero->X + dirX(Hero->Dir) * 16;
			int y = Hero->Y + dirY(Hero->Dir) * 16;
			unless(Hero->BigHitbox || Hero->Dir != DIR_UP) y += 8; //Handle normal-hitbox Hero facing up
			bool ret = true;
			unless(ignoreSolidity) ret = CanWalk(x,y,0,0,true);
			return ret && x >= 0 && x <= 240 && y >= 0 && y <= 160;
		}
	}
	
	npc script patrollingJailer
	{
		/**
		 * Setup:
		 * 	Place the enemy using an inherent enemy placement flag, on a path of placed flags (of any type, preferrably a scripted flag)
		 * 	Or, spawn the enemy using a script, on a placed path of flags (instead of using an inherent placement flag).
		 * 	The included `ffc script enemyPlacement` can be used for this.
		 * 	It will follow these flags in a path, and if it sees Hero, it will play a cutscene of running towards him and then jail him.
		 * 	The enemy will ignore all solidity, to follow this path.
		 * D0: The color to use to draw the line of sight. Use `0` for no drawing.
		 * D1: DMap to warp to
		 * D2: Screen to warp to
		 * D3: Warp return square to use. 0-3 for A-D, -1 for pit warp
		 * D4: Forward sight range, in pixels
		 * D5: Forward sight angle (between 0 and 90, inclusive. 0/1 are tunnel vision, 89/90 are wide vision). Recommended: 45.
		 * D6: If 0, will prefer clockwise movement at turns, else, counterclockwise.
		 * D7: Flag to follow. If 0, uses placed flag being stood on. Reading `npc->InitD[7]` will tell you what flag is being used.
		 * 
		 * Enemy Editor data:
		 * 	Enemy type should be "Other"
		 * 	Step speed will be used for the movement
		 *	Defenses should ALL be set to "Block", unless you want the guard to be killable of course.
		 * 	If you set it to be unkillable, be sure to set "Doesn't count as beatable enemy"
		 * 	Homing Factor / Halt Rate / Random Rate / Hunger are totally ignored.
		 * 	Damage will be forcibly set to 0. Weapon damage is unaffected.
		 * 
		 * QRs:
		 * 	`ZScript->Quest Script Settings->Sprite Coordinates are Float` must be checked
		 */
		void run(int drawColor, int warpDMap, int warpScreen, int warpReturn, int sightPix, int sightAngle, bool counterClock, int flag)
		{
			if(sightAngle < 0 || sightAngle > 90)
			{
				printf("User error: `sightAngle` must be between 0 and 90, inclusive! Angle %d is invalid, and will be bounded to %d.\n", sightAngle, VBound(sightAngle, 90, 0));
				sightAngle = VBound(sightAngle, 90, 0);
			}
			unless(flag) flag = this->InitD[7] = Screen->ComboF[ComboAt(this->X+8, this->Y+8)];
			int stepRate = this->Step / 100;
			this->Damage = 0; //Don't hurt Hero when you touch him, just jail him!
			while(true)
			{
				while(flagInDir(this->X, this->Y, this->Dir, flag))
				{
					//Moving straight
					this->X += dirX(this->Dir) * stepRate;
					this->Y += dirY(this->Dir) * stepRate;
					if(catchHeroTrapezoid(this, sightPix, sightAngle, drawColor)) npcCatchesHero(this, warpDMap, warpScreen, warpReturn);
					Waitframe();
				}
				//Turn
				int recursionSafeguard = 8;
				do
				{
					this->Dir = SpinDir8(this->Dir, counterClock ? -2 : 2);
					--recursionSafeguard;
				}
				until(flagInDir(this->X, this->Y, this->Dir, flag) || !recursionSafeguard);
				unless(recursionSafeguard)
				{
					//Something went wrong if this runs; someone modified the flags on the screen, and broke the path!
					//This will still work, though; the enemy just won't move. Or turn. At least, until a flag is placed next to it to move to.
					TraceS("Failed to find direction!\n");
					while(true)
					{
						repeat(4)
						{
							this->Dir = SpinDir8(this->Dir, counterClock ? -2 : 2);
							if(flagInDir(this->X, this->Y, this->Dir, flag)) break;
						}
						if(catchHeroTrapezoid(this, sightPix, sightAngle, drawColor)) npcCatchesHero(this, warpDMap, warpScreen, warpReturn);
						Waitframe();
					}
				}
			}
		}
		
		bool flagInDir(int x, int y, int dir, int flag)
		{
			x += Venrob::InFrontCenteredX(dir,1);
			y += Venrob::InFrontCenteredY(dir,1);
			if(x < 0 || x > 255 || y < 0 || y > 175) return false;
			return ComboFI(ComboAt(x, y), flag);
		}
		
		bool catchHeroTrapezoid(npc n, int pixlength, int angle, int drawColor)
		{
			if(HeroIsScrolling()) return false; //Don't do catch stuff while scrolling!
			//Angles <2 or >88 can have issues with the standard collision.
			//Treat these specially, as rectangles instead of trapezoids.
			if(angle > 88) return catchHeroRect(n, pixlength, drawColor, true); //Wide rect
			if(angle < 2) return catchHeroRect(n, pixlength, drawColor, false); //Narrow rect (tunnel vision)
			int x1, y1, x2, y2, x3, y3, x4, y4, len;
			//1 is NPC's left, based on facing
			//2 is NPC's left, pixlength in front of npc, at angle, based on facing
			//3 is NPC's right, based on facing
			//4 is NPC's right, pixlength in front of npc, at angle, based on facing
			switch(n->Dir)
			{
				case DIR_UP:
					angle = 90 - angle;
					x1 = n->X; y1 = n->Y;
					x4 = n->X + 15; y4 = n->Y;
					len = InvVectorY(pixlength, angle);
					y2 = y3 = y1 - pixlength;
					x2 = Round(x1 - VectorX(len, angle));
					x3 = Round(x4 + VectorX(len, angle));
					break;
				case DIR_DOWN:
					angle = 90 - angle;
					x1 = n->X + 15; y1 = n->Y + 15;
					x4 = n->X; y4 = n->Y + 15;
					len = InvVectorY(pixlength, angle);
					y2 = y3 = y1 + pixlength;
					x2 = Round(x1 + VectorX(len, angle));
					x3 = Round(x4 - VectorX(len, angle));
					break;
				case DIR_LEFT:
					x1 = n->X; y1 = n->Y + 15;
					x4 = n->X; y4 = n->Y;
					len = InvVectorX(pixlength, angle);
					x2 = x3 = x1 - pixlength;
					y2 = Round(y1 + VectorY(len, angle));
					y3 = Round(y4 - VectorY(len, angle));
					break;
				case DIR_RIGHT:
					x1 = n->X + 15; y1 = n->Y;
					x4 = n->X + 15; y4 = n->Y + 15;
					len = InvVectorX(pixlength, angle);
					x2 = x3 = x1 + pixlength;
					y2 = Round(y1 - VectorY(len, angle));
					y3 = Round(y4 + VectorY(len, angle));
					break;
			}
			//printf("Drawing Polygon (%d,%d), (%d,%d), (%d,%d), (%d,%d) of color %d\n", x1, y1, x2, y2, x3, y3, x4, y4, drawColor);
			if(drawColor)
				Screen->Polygon(DRAW_LAYER, 4, {x1, y1, x2, y2, x3, y3, x4, y4}, drawColor, DRAW_OPACITY);
			
			return !HeroIsHiding() && (HeroTriangleCollision(x1, y1, x2, y2, x3, y3, true) || HeroTriangleCollision(x4, y4, x2, y2, x3, y3));
		}
		
		bool catchHeroRect(npc n, int length, int drawColor, bool wide)
		{
			int x1, y1, x2, y2;
			if(wide)
				switch(n->Dir)
				{
					case DIR_UP:
						x1 = n->X - length;
						y1 = n->Y;
						x2 = n->X + 15 + length;
						y2 = n->Y - length;
						break;
					case DIR_DOWN:
						x1 = n->X - length;
						y1 = n->Y + 15;
						x2 = n->X + 15 + length;
						y2 = n->Y + 15 + length;
						break;
					case DIR_LEFT:
						x1 = n->X;
						y1 = n->Y - length;
						x2 = n->X - length;
						y2 = n->Y + 15 + length;
						break;
					case DIR_RIGHT:
						x1 = n->X + 15;
						y1 = n->Y - length;
						x2 = n->X + 15 + length;
						y2 = n->Y + 15 + length;
						break;
				}
			else
				switch(n->Dir)
				{
					case DIR_UP:
						x1 = n->X;
						y1 = n->Y;
						x2 = n->X + 15;
						y2 = n->Y - length;
						break;
					case DIR_DOWN:
						x1 = n->X;
						y1 = n->Y + 15;
						x2 = n->X + 15;
						y2 = n->Y + 15 + length;
						break;
					case DIR_LEFT:
						x1 = n->X;
						y1 = n->Y;
						x2 = n->X - length;
						y2 = n->Y + 15;
						break;
					case DIR_RIGHT:
						x1 = n->X + 15;
						y1 = n->Y;
						x2 = n->X + 15 + length;
						y2 = n->Y + 15;
						break;
				}
				
			Screen->Rectangle(DRAW_LAYER, x1, y1, x2, y2, drawColor, 1, 0, 0, 0, true, DRAW_OPACITY);
			return !HeroIsHiding() && RectCollision(x1, y1, x2, y2, Hero->X, Hero->Y, Hero->X + 15, Hero->Y + 15);
		}
	}
	
	/**
	 * An NPC saw the Hero! Catch him and send him to jail!
	 */
	void npcCatchesHero(npc this, int warpDMap, int warpScreen, int warpReturn)
	{
		//Put whatever you want into this function, this will run when Hero is caught.
		//Anything here only runs when an NPC sees the Hero, not when a spotlight does.
		
		//start Default implementation - freeze Hero, play sound, NPC runs to hero
		Audio->PlaySound(CAUGHT_SFX);
		Hero->Stun = 500;
		//
		Waitframes(5); //Pause for a moment, when noticing Hero
		int angle = RadtoDeg(TurnTowards(CenterX(this), CenterY(this), Hero->X + 8, Hero->Y + 8, 0, 1));
		this->Dir = AngleDir4(angle); //Make the npc face in a way that makes sense
		int dX = VectorX(this->Step / 100, angle);
		int dY = VectorY(this->Step / 100, angle);
		this->CollDetection = false; //Don't hit Hero (if don't do this, will repeatedly knock him back while trying to walk towards him)
		until(Distance(Hero->X + 8, Hero->Y + 8, CenterX(this), CenterY(this)) <= 8) //Walk towards Hero to catch him
		{
			unless(Hero->Stun) {Hero->Stun += 100; break;} //Make sure it doesn't somehow get stuck in an infinite loop, due to a weird angle or something
			this->X += dX;
			this->Y += dY;
			Waitframe();
		}
		if(Hero->Item[BARREL_ITEM]) //If Hero had a barrel, spend a few frames to break it. No animation, but you could add one here.
		{
			Waitframes(2);
			Hero->Item[BARREL_ITEM] = false;
			Waitframes(2);
		}
		//
		Hero->Stun = 0;
		//end Default Implementation
		
		jailHero(warpDMap, warpScreen, warpReturn);
	}
	
	/**
	 * A spotlight saw the Hero! Catch him and send him to jail!
	 */
	void spotlightCatchHero(ffc this, int warpDMap, int warpScreen, int warpReturn, int drawColor, int radius)
	{
		//Put whatever you want into this function, this will run when Hero is caught.
		//Anything here only runs when the spotlight sees the Hero, not when an NPC does.
		
		//start Default implementation - freeze Hero, play sound, NPC runs to hero
		Audio->PlaySound(CAUGHT_SFX);
		//
		if(drawColor) //Don't do anything for invisible spotlights.
		{
			Hero->Stun = 500; //Prevent all action by the player.
			int angle = RadtoDeg(TurnTowards(CenterX(this), CenterY(this), Hero->X + 8, Hero->Y + 8, 0, 1));
			int speed = Max(Abs(Round((this->Vx + this->Vy) / 2)), 1); //The average of the FFC's x/y speed, or 1, whichever is higher.
			int dX = VectorX(speed, angle);
			int dY = VectorY(speed, angle);
			haltFFC(this); //Stop the spotlight's movement, if it has normal movement.
			this->Flags[FFCF_IGNORECHANGER] = true; //Prevent changers from changing it's movement during the following animation
			until(Distance(Hero->X + 8, Hero->Y + 8, CenterX(this), CenterY(this)) < 1) //Pan the spotlight onto the hero, centered within 1 pixel
			{
				unless(Hero->Stun) {Hero->Stun += 100; break;} //Make sure it doesn't somehow get stuck in an infinite loop, due to a weird angle or something
				this->X += dX;
				this->Y += dY;
				Waitframe();
				Waitdraw();
				Screen->Circle(DRAW_LAYER, CenterX(this), CenterY(this), radius, drawColor, 1, 0, 0, 0, true, DRAW_OPACITY);
			}
			this->X = Floor(this->X);
			this->Y = Floor(this->Y);
			for(int q = 0; q < 20; ++q)
			{
				Waitframe();
				Waitdraw();
				Screen->Circle(DRAW_LAYER, CenterX(this), CenterY(this), radius, drawColor, 1, 0, 0, 0, true, DRAW_OPACITY);
			}
			//Spotlights can't break barrels, so don't spend time removing it like NPCs do.
			//
			Hero->Stun = 0;
		}
		//end Default Implementation
		
		jailHero(warpDMap, warpScreen, warpReturn);
	}

	/**
	 * Send the Hero to jail.
	 */
	void jailHero(int warpDMap, int warpScreen, int warpReturn)
	{
		//Put whatever you want into this function, this will run when Hero is caught.
		//Anything here will run either when an NPC or a spotlight catches him, but after their specific handlings.
		
		//Don't remove/modify the following:
		Hero->Item[BARREL_ITEM] = false; //Make sure the Hero is out of his barrel.
		Hero->WarpEx({WT_IWARP, warpDMap, warpScreen, -1, warpReturn, WARP_EFFECT, WARP_SFX, WARP_FLAGS});
	}

	/**
	 * Returns true if Hero is hiding in a barrel, and should not be seen by guards
	 */
	bool HeroIsHiding()
	{
		unless(Hero->Item[BARREL_ITEM]) return false;
		if(Hero->Stun) return false; //If Hero->Stun, another guard caught the hero!
		switch(Hero->Action)
		{
			//Add more valid actions here, if you wish
			case LA_NONE:
				return true;
		}
		return false;
	}

	ffc script enemyPlacement
	{
		/**
		 * Spawns an enemy at the FFC location, every time you enter the screen (even if it was killed previously)
		 * D0: Enemy ID
		 * D1: Direction to face enemy. If -1, will not set specific direction. Valid values: -1 through 3. Values >3 will be modulo'd.
		 */
		void run(int enemyId, int forceDir)
		{
			npc n = CreateNPCAt(enemyId, this->X, this->Y);
			unless(forceDir < 0)
				n->Dir = forceDir % 4;
		}
	}

	ffc script spotlight
	{
		/**
		 * Creates a spotlight which will catch Hero
		 * Setup: Place FFC on screen, give it this script, fill in the parameters.
		 * 		For a moving spotlight, you can use FFC changers- no scripting required.
		 * D0: The color to use to draw the spotlight. Use `0` for no drawing.
		 * D1: DMap to warp to
		 * D2: Screen to warp to
		 * D3: Warp return square to use. 0-3 for A-D, -1 for pit warp
		 * D4: Radius of circle, from center of FFC, to be a spotlight.
		 */
		void run(int drawColor, int warpDMap, int warpScreen, int warpReturn, int radius)
		{
			while(true)
			{
				Waitframe(); //Waitframe at the top so `continue` below works
				if(HeroIsScrolling()) continue; //Don't do catch stuff while scrolling!
				Waitdraw();
				if(drawColor)
					Screen->Circle(DRAW_LAYER, CenterX(this), CenterY(this), radius, drawColor, 1, 0, 0, 0, true, DRAW_OPACITY);
				if(!HeroIsHiding() && Distance(Hero->X + 8, Hero->Y + 8, CenterX(this), CenterY(this)) <= radius + 8) //+8 to catch any corner of Hero's hitbox, not just his center
					spotlightCatchHero(this, warpDMap, warpScreen, warpReturn, drawColor, radius);
			}
		}
	}
}