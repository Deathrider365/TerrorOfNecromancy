import "std.zh"


//¬ Bug: Left centre paddle zone is not hitting ball UUL? Might be fixed now. 
//TODO: 

// Add corner check for WALLS for various angles.
// Implement new angles after collision with walls and bricks.
// Implement enemies. 
// 

	



//Arkanoid script
//v0.34
//19th October, 2018

//////////////////////
/// Script issues: ///
//////////////////////

// We need to either re-arrange the living/dead/death logic, or add another animation phase. 
// May as well set up the Vaus explosion and add it with a SPARKLE LWeapon.


/* ZC issues: 
	Continue script does not run when Init script runs. It NEEDS to do that! Otherwise, settings that affect things such as Link's tile
	don't happen before the opening wipe. 
	
*/

ffc script version_alpha_0_34
{
	void run(){}
}

/// Changes, Revision History
///
///
/// Alpha 0.16: Reverted Alpha 0.15 changes back to before adding any angular physics.
///		Then, re-implemented ONLY the Vaus midpoint physics.
///		Fixed the hack for UID in brick.take_hit(). This means that ZC 2.54 Alpha **32** is now the minimum ZC version.

///Alpha 0.18: Added 'fast mouse' mode, enabled using V to increase the fast mouse speed, and C tpo decrease it.
/// 	The mouse mode must be enabled for this to function!
///	Fast Mouse moves the Vaus N pixels per frame, based on the distance that the mouse travels * fast_mouse. 

///Alpha 0.19: Added a frame check to keyboard keys V and B.

///Alpha 0.20: Added an ffc script that reports the version when assigning slots after compiling. 

///Alpha 0.21: Added code for advancing to the next stage.

///Alpha 0.22: Fixed code for level advancement. Added second stage.
///Alpha 0.23: Fixed brick.all_gone() counting gold bricks. 
///Alpha 0.24: Fixed a bug in ball.check_rightwall() where a right-up moving ball was set to a right-ward angle/dir on contact.
///	     : This was the cause of the ball falling like a stone. 
///	     : Fixed a bug where angles that we were comparing against in ball.check_hitvaus() had the wrong equality constants,
///	     : and thus, were returning false.  
///	     : Added hold_Link_y() to the additional while loops so that the player can't escape that screen by holding directions
///	     : on the single frame where that loop runs. 
///Alpha 0.25: Added capsule class, and set up base functions, to generate capsules and make them fall.
///	     : Capsules now appear int he game, but as of this time, they do not activate any power-ups. 
///
///Alpha 0.26: Added more capsule functions.
///Alpha 0.27: Wrote capsule.check_hitvaus() and polished other capsule functions, adding traces to test them.
///	     : Added drawover() functions to capsule and ball classes. 
///	     : Added extend state capabilities to game. Extend capsules now extend the Vaus.
///	     : Added slow capsule powerups that function.
///	     : Added Extra Vaus powerups that function. 
///Alpha 0.28: Converted capsules to eweapons.
///	     : Fixed extended movement with both KB/JP and Mouse. 
///Alpha 0.29: Added laser sprite change on powerup collection. Refactored powerup sounds.
///	     : Refactor extend status to be controlled by the capsules, and added capsule.alloff(ffc), called on stage end or death.
///	     : Added more sound effects.
///	     : Added POINTS on collecting capsules. Capsule points are set in itemdata->Attributes[1]. 
///	     : Began adding extra life on score reaching certain numbers. 
///	     : Added high_score, and score clear system.
///	     : Extra life from points set to 1000. Capsules award 10 points each. 
///	     : Shift+M now enabled mouse and sets fast_mouse = 2;
///Alpha 0.30: Fixed timing for music playing and vaus spawning, and fixed visual bugs created by calling capsule.alloff() with improper sequencing.
///          : Made Link's base shieldless down tile blank, to hide graphical glitch caused by the continue script not running before Link is drawn.
///Alpha 0.31: Refactored ball.check_hitvaus() to correct angles and locations, adding paddle.centre() and paddle.get_segment() to return areas.
///          : Added paddle zone debug drawlines, enabled using config DEBUG_MIDPOINTS. 
///Alpha 0.32: Added complete laser powerup. 
///Alpha 0.33: Added complete catch powerup. 
///
///Alpha 0.34: PureZC 2018n Fall Expo Build:
///          : Added stages 3, 4, 5, 6, 7 and 8.
///          : Temporarily disabled split ppower capsule, and ball step speed increases.
///          : Added partial Break capsule power. The exits do not appear; the stage auto-advances on collecting them.
///          : Added level intro strings.
///          : Updated display bar (points, players; fonts).
///          : Adjusted Game Over text display and added HACK to force game over to run.
///          : Added HACK to force high score updates. 
///          : Fixed onCOntinue script not resetting Player's score to 0.
/// NOTE:  VAUS BREAK could use 'moving link' to the next screen to scroll it as an effect. 

//! Bug: Right side of vaus angle zones are reversed. RUU is to the right of RU. RRU seems not to exist. 
//! I should be drawing red v-lines over the points where the ball zones are on the paddle. 

typedef const int config;
const int ENABLE = 1;
const int DISABLE = 0;

config DEBUG_MIDPOINTS = DISABLE;
config BRICK_CHANCE_CAPSULE 	= 50;
config FAST_MOUSE_MAX	 	= 6;
config MAX_STAGES 		= 8; //Number of stages/levels in the game.
config MAX_BALL_SPEED 		= 300;
config MIN_ZC_ALPHA_BUILD 	= 41; //Alphas are negatives, so we neex to check maximum, not minimum.
config MIN_ZC_BETA_ID	 	= 1; //Alphas are negatives, so we neex to check maximum, not minimum.
config STARTING_LIVES 		= 5; 
config CAPSULE_FALL_SPEED 	= 1;
config BALL_INITIAL_STEP 	= 90;
config CAPSULE_STEP		= 80;
config LASER_COOLDOWN_TIME	= 20;

const int LASER_LEFT_X_OFS_FROM_MIDPOINT = 6;
const int LASER_RIGHT_X_OFS_FROM_MIDPOINT = 5;
const int LASER_HEIGHT = 10;
const int LASER_WIDTH = 2;
const int SPR_LASER = 95;
const int LASER_STEP = 120;

const int BALL_MISC_CAUGHT = 17;
const int BALL_MISC_OLDSTEP = 18;
const int BALL_MISC_OLDANGULAR = 19;
const int BALL_MISC_OLDANGLE = 20;
const int BALL_MISC_OLDDIR = 21;

int caught_relative_ball_vaus_x;

typedef const int sfx;

sfx SFX_LASER = 3;
sfx SFX_KILLENEMY = 2;
sfx SFX_EXTEND = 4;
sfx SFX_BALL_HIT_VAUS = 6;
sfx SFX_BALL_HIT_BLOCK= 7;
sfx SFX_BALL_HIT_SILVER= 8;
sfx SFX_EXTRA_VAUS = 9;
sfx SFX_VAUS_EXPLODE = 10;
sfx SFX_ESCAPE = 11;
sfx SFX_MATERIALISE = 12;
sfx SFX_BEEP = 1;
sfx SFX_ARK2_LASER = 13;
sfx SFX_ARK2_KILLENEMY = 14;
sfx SFX_ARK2_HITGREY = 15;
sfx SFX_ARK2_HITGOLD = 16;
sfx SFX_ARK2_EXTRAVAUS = 17;

sfx SFX_ARK2_HITVAUS = 18;
sfx SFX_ARK2_HITWALL = 19;
sfx SFX_ARK2_POWERUP = 20;
sfx SFX_ARK2_EXTEND = 21; //too quiet
sfx SFX_ARK2_POWERUP2 = 22; //
sfx SFX_ARK2_VAUSEXPLODE = 23;
sfx SFX_ARK2_WOOSH = 24;
sfx SFX_ARK2_MATERIALISE = 25;
sfx SFX_ARK2_BOSSALERT = 26;
sfx SFX_ARK2_CRYSTAL = 27; 
sfx SFX_ARK2_ESCAPE = 28;
sfx SFX_ARK2_BELLS_CHIMES = 29;

const float ARKANOID_VERSION = 34;

//Radians for special directions. 
const float DIR_UUL = 4.3197;
const float DIR_LUU = 4.3197;
const float DIR_LLU = 3.5343;
const float DIR_ULL = 3.5343;
const float DIR_LLD = 2.7489;
const float DIR_DLL = 2.7489;
const float DIR_DDL = 1.9635;
const float DIR_LDD = 1.9635;
const float DIR_DDR = 1.1781;
const float DIR_RDD = 1.1781;
const float DIR_RRD = 0.3927; 
const float DIR_DRR = 0.3927; 
//const float DIR_RRU = 5.1051;
//const float DIR_URR = 5.1051;
const float DIR_RRU = 5.8905;
const float DIR_URR = 5.8905;
const float DIR_RUU = 5.1141;
const float DIR_UUR = 5.1141;

int last_mouse_x;
int fast_mouse;





int GAME[256];
const int GAME_MISC_FLAGS = 0;
const int GMFS_PLAYED_GAME_OVER_MUSIC = 0x01;

const int FFC_VAUS = 1;
const int CMB_VAUS_EXTENDED = 1528;
const int CMB_VAUS = 1524;
const int CMB_VAUS_DEAD = 1520;
const int CMB_VAUS_LASER = 1532;

const int MID_STAGE_START = 4;
const int NPCM_AWARDED_POINTS = 3; //brick->Misc[], flag to mark if points were awarded to the player. 
const int NPC_ATTRIB_POINTS = 0; //brick->Attributes[], value for score. 
const int CAPS_EW_MISC_POINTS = 6;

//Counters
const int CR_SCORE = CR_SCRIPT1; 
const int CR_LIVES = CR_SCRIPT2; 
const int CR_HIGH_SCORE = CR_SCRIPT3; 

int high_score; //saved with quest.
int last_score_award;
config SCORE_BONUS_LIFE_AT = 1000; 

//game objects
int ball_uid;

//game states
int quit;
int frame;

bool newstage = true;
bool leveldone = false;
int cur_stage;

const int QUIT_TITLE = -1;
const int QUIT_GAME_RUNNING = 0; //i.e., !quit
const int QUIT_GAMEOVER = 1;

const int FRAMES_PER_MOVEMENT = 10; 
int USE_ACCEL = 0; //Do we accelerate KB/JP input?
int USE_MOUSE = 0; //Are we using the mouse?

//Vaus states
bool revive_vaus = false; 
int laser_cooldown;
bool extended;
bool laser;
int caught; //States: 0, none. 1: Vaus can catch ball. 2: Vaus is holding the ball. 
const int CATCH_NONE = 0;
const int CATCH_ALLOW = 1;
const int CATCH_HOLDING_BALL = 2;

//Ball properties (probably unused at this point)
int ball_x;
int ball_y;
int ball_dir;
int ball_angle;
int ball_speed;
int ball_vx;
int ball_vy;
int paddle_x;
int paddle_y;
int paddle_width = 16;
int paddle_speed = 2;

//animation
int death_frame;

const int DEATH_ANIM_MAX = 8;

int death_anim[DEATH_ANIM_MAX]; 
const int DEATH_ANIM_TIMER = 0;
const int DEATH_ANIM_1 = 1; //1-7 Unused 
const int DEATH_ANIM_2 = 2;
const int DEATH_ANIM_3 = 3;
const int DEATH_ANIM_4 = 4;
const int DEATH_ANIM_5 = 5;
const int DEATH_ANIM_6 = 6;
const int DEATH_ANIM_COUNTDOWN_TO_QUIT = 7;

const int COUNTDOWN_TO_QUIT_FRAMES = 289; //36*8+1;

int templayer[4];

int input_accel; //pressing left and right for multiple frames increases this
int frames_pressed[18]; 

//ffc paddle;

int hit_zones[5]; //angle offsets for where the ball strikes the paddle

const int WALL_LEFT = 24;
const int WALL_TOP = 8; //Mix Ball Y
const int WALL_RIGHT = 232;

const int BALL_MIN_Y = 9; //ceiling +1
const int BALL_MAX_Y = 145; //one pixel under paddle top
const int BALL_MIN_X = 25; //left wall +1
const int BALL_MAX_X = 229; //right wall -1



const int START_PADDLE_X = 62;
const int START_PADDLE_Y = 160;
const int START_PADDLE_WIDTH = 32;
const int START_PADDLE_HEIGHT = 8;
const int BALL_WIDTH = 4;
const int BALL_HEIGHT = 4;
const int START_BALL_X = 98; //(START_PADDLE_X + 36);
const int START_BALL_Y = 156; //START_PADDLE_Y - 4;
const int START_BALL_DIR = 5; //DIR_UPRIGHT;
const int START_BALL_RADS = 220; //angle in radians
const int START_BALL_SPEED = 45;
const int START_BALL_VX = 0;
const int START_BALL_VY = 0;

const int PADDLE_MIN_X = 25;
const int PADDLE_MAX_X = 200; //WALL_RIGHT -32; //This one varies as the paddle width may change.
const int PADDLE_MAX_X_EXTENDED = 184; //WALL_RIGHT - 48; //This one varies as the paddle width may change.
const int PADDLE_MIN_X_EXTENDED = 25;

const int _MOUSE_X = 0;
const int _MOUSE_Y = 1;
const int _MOUSE_LCLICK = 2;

//const float ACCEL_FACTOR = 0.25;




/*
const int CB_UP		= 0;
const int CB_DOWN	= 1;
const int CB_LEFT	= 2;
const int CB_RIGHT	= 3;
const int CB_A		= 4;
const int CB_B		= 5;
const int CB_L		= 7;
const int CB_R		= 8;
const int CB_START	= 6;
const int CB_MAP	= 9;
const int CB_EX1	= 10;
const int CB_EX2	= 11;
const int CB_EX3	= 12;
const int CB_EX4	= 13;
const int CB_AXIS_UP	= 14;
const int CB_AXIS_DOWN	= 15;
const int CB_AXIS_LEFT	= 16;
const int CB_AXIS_RIGHT	= 17;

*/

ffc script paddle
{
	void run(){}
	
	int centre(ffc v)
	{
		return (v->X + (v->TileWidth*8));
	}
	//0, left tip [LLU]
	//1, left slice [LU]
	//2, left midpoint [LUU]
	//3, right midpoint [RUU]
	//4, right slice [RU]
	//5, right tip [RRU]
	
	int get_segment(ffc v, int portion)
	{
		int middle_section = Floor((v->TileWidth*16)/6);
		switch(portion)
		{
			case 0:
			{
				return v->X + (Cond(extended,6,4));
			}
			case 1:
			{
				return v->X + (Cond(extended,18,13));
			}
			case 2:
			{
				return ( centre(v) );
			}
			case 3:
			{
				return (centre(v)+1);
			}
			case 4:
			{
				return (v->X+(v->TileWidth*16)-(Cond(extended,18,13)));
				
			}
			case 5:
			{
				return (v->X+(v->TileWidth*16) - (Cond(extended,6,4)));
			}
			default: return 0;
		}
	}
	
	void draw_midpoints(ffc v)
	{
		if ( !DEBUG_MIDPOINTS ) return;
		for ( int q = 0; q < 6; ++q )
		{
			Screen->Line(0, get_segment(v,q), 0, get_segment(v,q), 256, 
				0x02+(q*0x10), -1, 0, 0, 0, 128	);
		}
	}
	
	bool move(bool mouse, bool accel, ffc p)
	{
		int dir; int dist;
		if ( mouse ) 
		{
			Game->ClickToFreezeEnabled = false;
			if ( fast_mouse )
			{
				int distx = Input->Mouse[_MOUSE_X] - last_mouse_x;
				//Trace(distx);
				last_mouse_x = Input->Mouse[_MOUSE_X];
				if ( !extended )
				{
					
					if ( distx < 0 ) 
					{
						//Trace(distx);
						for ( int q = Abs(distx) * fast_mouse; q > 0 ; --q ) 
						{
							
							if ( p->X > PADDLE_MIN_X )
							{
								--p->X;
							}
							
						}
					}
					else if ( distx > 0 )
					{
						//Trace(distx);
						for ( int q = Abs(distx) * fast_mouse; q > 0 ; --q ) 
						{
							
							if ( p->X < PADDLE_MAX_X )
							{
								++p->X;
							}
							
						}
					}
				}
				else //extended
				{
					
					if ( distx < 0 ) 
					{
						for ( int q = Abs(distx); q > 0 ; --q ) 
						{
							for ( int q = fast_mouse; q > 0; --q )
							{
								if ( p->X > PADDLE_MIN_X_EXTENDED+(frame%2) )
								{
									p->X -= (1+(frame%2)); //move left
								}
							}
						}
					}
					else
					{
						for ( int q = Abs(distx); q > 0 ; --q ) 
						{
							for ( int q = fast_mouse; q > 0; --q )
							{
								if ( p->X < PADDLE_MAX_X_EXTENDED-(frame%2) )
								{
									p->X += (1+(frame%2)); //move right
								}
							}
						}
					}
				}
				
			}
			else
			{
				//get the mouse movement this frame and apply a relative amount to the paddle
				//set the dir here
				//set the dist here
				//if moving left
				//if ( p->X > PADDLE_MIN_X ) 
				//{
				//	p->X = Input->Mouse[_MOUSE_X];
					//apply change -- ZC has no special mouse tracking. 
				//}
				//if moving right
				if ( !extended )
				{
					if ( Input->Mouse[_MOUSE_X] <= PADDLE_MAX_X )
					{
						if ( Input->Mouse[_MOUSE_X] >= PADDLE_MIN_X )
						{
							//apply change
							p->X = Input->Mouse[_MOUSE_X];
						}
					}
				}
				else
				{
					if ( Input->Mouse[_MOUSE_X] <= PADDLE_MAX_X_EXTENDED )
					{
						if ( Input->Mouse[_MOUSE_X] >= PADDLE_MIN_X_EXTENDED )
						{
							//apply change
							p->X = Input->Mouse[_MOUSE_X];
						}
					}
				}
			}
		}
		else //using a KB or joypad
		{
			Game->ClickToFreezeEnabled = true;
			//check how long the dir button is held
			if ( accel ) //if we allow acceleratiopn, move N pixeld * accel factor * frames held
			{
				
				if ( !extended )
				{
					if (  Input->Button[CB_LEFT] ) 
					{
						for ( int q = frames_pressed[CB_LEFT]; q > 0 ; --q ) 
						{
							if ( p->X > PADDLE_MIN_X )
							{
								--p->X;
							}
						}
					}
					if (  Input->Button[CB_RIGHT] ) 
					{
						for ( int q = frames_pressed[CB_RIGHT]; q > 0; --q ) 
						{
							if ( p->X < PADDLE_MAX_X )
							{
								++p->X;
							}
						}
					}
				}
				else
				{
					if (  Input->Button[CB_LEFT] ) 
					{
						for ( int q = frames_pressed[CB_LEFT]; q > 0 ; --q ) 
						{
							if ( p->X > PADDLE_MIN_X_EXTENDED )
							{
								--p->X;
							}
						}
					}
					if (  Input->Button[CB_RIGHT] ) 
					{
						for ( int q = frames_pressed[CB_RIGHT]; q > 0; --q ) 
						{
							if ( p->X < PADDLE_MAX_X_EXTENDED )
							{
								++p->X;
							}
						}
					}
					
				}
				
			}
			
			else //no accel offered, move a static number of pixels
			{
				
				if ( !extended )
				{
					if (  Input->Button[CB_LEFT] ) 
					{
						for ( int q = 0; q < paddle_speed; ++q ) 
						{
							if ( p->X > PADDLE_MIN_X )
							{
								--p->X;
							}
						}
					}
					if (  Input->Button[CB_RIGHT] ) 
					{
						for ( int q = 0; q < paddle_speed; ++q ) 
						{
							if ( p->X < PADDLE_MAX_X )
							{
								++p->X;
							}
						}
					}
				}
				else
				{
					if (  Input->Button[CB_LEFT] ) 
					{
						if ( p->X > PADDLE_MIN_X_EXTENDED )
						{
							p->X -= (1+(frame%2));
						}
					}
					if (  Input->Button[CB_RIGHT] ) {
						if ( p->X < PADDLE_MAX_X_EXTENDED )
						{
							p->X += (1+(frame%2));
						}
					}
					
				}
			}
		}
		
	}

	void check_input()
	{
		if ( Input->Button[CB_LEFT] ) ++frames_pressed[CB_LEFT];
		else frames_pressed[CB_LEFT] = 0;
		if ( Input->Button[CB_RIGHT] ) ++frames_pressed[CB_RIGHT];
		else frames_pressed[CB_RIGHT] = 0;
		
	}
	
	void extend(ffc p)
	{
		if ( extended ) 
		{
			if ( p->TileWidth < 3 ) 
			{
				p->Data = CMB_VAUS_EXTENDED;
				p->TileWidth = 3;
			}
		}
		else
		{
			if ( p->TileWidth > 2 ) 
			{
				p->Data = CMB_VAUS;
				p->TileWidth = 2;
			}
		}
	}
	void setup(ffc p)
	{
		Game->PlaySound(SFX_MATERIALISE);
		p->Y = START_PADDLE_Y;
		p->X = START_PADDLE_X;
		Waitframe();
		p->Data = CMB_VAUS;
		p->TileWidth = 2;
		
	}
	void dead(ffc p)
	{
		p->Data = CMB_VAUS_DEAD;
		p->TileWidth = 2;
		death_frame = frame;
	}
	
	bool pressfire()
	{
		for ( int q = CB_A; q < CB_R; ++q ) 
		{
			if ( Input->Press[q] ) { return true; }
		}
		if ( USE_MOUSE ) 
		{
			//if ( Input->Mouse[_MOUSE_LCLICK] )  //Not working?!
			if ( Link->InputMouseB )
				return true;
		}
		return false;
	}
	
	void shoot_laser(ffc v)
	{
		if ( !laser ) return;
		if ( laser_cooldown ) 
		{
			--laser_cooldown;
			return;
		}
		if ( pressfire() )
		{
			lweapon laser[2];
			Game->PlaySound(SFX_LASER);
			laser[0] = Screen->CreateLWeapon(LW_ARROW);
			laser[0]->Y = v->Y-LASER_HEIGHT;
			laser[0]->X = paddle.centre(v) - LASER_LEFT_X_OFS_FROM_MIDPOINT;
			laser[0]->Damage = 1;
			laser[0]->HitWidth = LASER_WIDTH;
			laser[0]->HitHeight = LASER_HEIGHT;
			laser[0]->UseSprite(SPR_LASER);
			laser[0]->Dir = DIR_UP;
			laser[0]->Step = LASER_STEP;
			laser[1] = Screen->CreateLWeapon(LW_ARROW);
			laser[1]->Y = v->Y-LASER_HEIGHT;
			laser[1]->X = paddle.centre(v) + LASER_RIGHT_X_OFS_FROM_MIDPOINT;
			laser[1]->Damage = 1;
			laser[1]->HitWidth = LASER_WIDTH;
			laser[1]->HitHeight = LASER_HEIGHT;
			laser[1]->UseSprite(SPR_LASER);
			laser[1]->Dir = DIR_UP;
			laser[1]->Step = LASER_STEP;
			laser_cooldown = LASER_COOLDOWN_TIME;
		}
		
		
	}
	
}

const int MISC_BALLID = 0; //Misc index of Vaud->Misc[]
const int MISC_DEAD = 1; //Misc index of Vaud->Misc[]
const int MISC_LAUNCHED = 0; //Misc index of ball->Misc[]

const int BALL_MINIMUM_Y = 24; //Invisible line at which point, ball is lost. 

ffc script holdlink
{
	void run()
	{
		while(1)
		{
			Link->Y = START_PADDLE_Y - 4;
			Waitframe();
		}
	}
}
		
const int TEST_254_GETPIXEL = 1;

global script arkanoid
{
	int stage_string[]="STAGE 01";

	const int STAGE_X = 128 - 32; //(1/2 screen width - 1/2 string width in pixels)
	const int STAGE_Y = 170;
	const int STAGE_FONT = FONT_PSTART;
	const int STAGE_BG_COLOUR = 0x5F; //black
	const int STAGE_FG_COLOUR = 0x51; //white
	
	void run()
	{
		Game->Misc[0] = 100;
		TraceS("Game->Misc[0] is: "); Trace(Game->Misc[0]);
		
		shopdata sd = Game->LoadShopData(2);
		for ( int q = 0; q < 3; ++q )
		{
			TraceNL(); TraceS("Shop Item: "); Trace(sd->Item[q]);
			TraceNL(); TraceS("Shop Price: "); Trace(sd->Price[q]);
		}
		
		
		check_min_zc_build();
		
		TraceNL(); TraceS("Starting Arkanoid"); TraceNL(); TraceS("Game 'quit' state: "); Trace(quit);
		TraceNL(); TraceS("Game version, Alpha "); Trace(ARKANOID_VERSION); 
		
		//frame = -1;
		ffc vaus = Screen->LoadFFC(FFC_VAUS);
		lweapon movingball;
		npc vaus_guard; 
		bool ext;
		Link->CollDetection = false;
		Link->DrawYOffset = -32768;
		
		if ( TEST_254_GETPIXEL ) 
		{
			bitmap bmp = Game->LoadBitmapID(RT_SCREEN);
			int col[20];
			for ( int q = 0; q < 20; ++ q )
			{
				col[q] = bmp->GetPixel(10+q*8,10+q*8); 
			}
			TraceNL();
			for ( int q = 0; q < 20; ++q ) 
			{
				TraceS("Bitmap col: "); Trace(col[q]);
			}
			
			Screen->SetRenderTarget(2);
			Screen->Rectangle(0, 0, 0, 256, 256, 0x55, 100, 0, 0, 0, true, 128);
			Screen->SetRenderTarget(RT_SCREEN);
			Waitframe();
			
			bitmap offscreen = Game->LoadBitmapID(2);
			int col2[20];
			for ( int q = 0; q < 20; ++ q )
			{
				col2[q] = offscreen->GetPixel(10+q*8,10+q*8); 
			}
			TraceNL();
			for ( int q = 0; q < 20; ++q ) 
			{
				TraceS("Offscreen Bitmap col: "); Trace(col2[q]);
			}
		}
		
		ball.setup_sprite(SPR_BALL);
		
		while(true)
		{
			while(!quit)
			{
				++frame;
				if ( Game->Counter[CR_HIGH_SCORE] < Game->Counter[CR_SCORE] ) 
				{
					Game->Counter[CR_HIGH_SCORE] = Game->Counter[CR_SCORE];
				}
				if ( Link->PressEx1 ) Graphics->Greyscale(true);
				if ( Link->PressEx2 ) Graphics->Greyscale(false);
				if ( Input->Key[KEY_L] ) ++Game->Counter[CR_LIVES]; 
				hold_Link_y(); //Don't allow Link to leave the screen, bt
					//keep his X and Y matched to the Vaus!
				hold_Link_x(vaus); //Link is used to cause floating enemies to home in on the vaus. 
				while ( newstage ) 
				{
					TraceS(stage_string);
					showStageString(stage_string);
					capsule.all_clear(); //remove visible capsules
					
					hold_Link_y();
					vaus = Screen->LoadFFC(FFC_VAUS);
					//vaus_guard = Screen->CreateNPC(NPC_VAUSGUARD);
					Game->PlayMIDI(MID_STAGE_START);
					
					brick.setup();
					
					Waitframes(6);
					
					brick.clear_combos();
					
					for ( int q = 0; q < 180; ++q ) 
					{
						Screen->DrawString(6,STAGE_X+6,128, FONT_MARIOLAND, 0x5F,-1,0,stage_string, 128);
						Screen->DrawString(6,STAGE_X+6-1,128-1, FONT_MARIOLAND, 0x51,-1,0,stage_string, 128);
						//showStageString(stage_string);
						WaitNoAction();
					}
					TraceS("Setting up Vaus on a new stage"); 
					paddle.setup(vaus);
					capsule.alloff(vaus,movingball); //clear powerup status
					TraceS("Creating a ball on a new stage");
					ball.create(vaus);
					movingball = vaus->Misc[MISC_BALLID];
					vaus->Misc[MISC_DEAD] = 0; 
					newstage = false; //on a new stage, these aren't working right yet.
					
					
					
				}
				while ( leveldone )
				{
					capsule.all_clear();
					hold_Link_y();
					//play stage end music
					//Warp to new screen here.
					if ( cur_stage < MAX_STAGES ) 
					{
					
						Link->PitWarp(Game->GetCurDMap(), Game->GetCurScreen()+1);
						++cur_stage;
						newstage = true;
						//continue;
					}
					else
					{
						Game->PlayMIDI(1);
						while(1)
						{
							Screen->DrawString(6, 113, 80, 1, 0x51, 0x00, 0, "DEMO OVER", 128);
							Waitdraw(); Waitframe();
						}
					}
					setStageString(stage_string);
					leveldone = false;
				}
				//Automatic level skip on F5:
				//if ( Input->ReadKey[46+5] ) leveldone = true;
				if ( revive_vaus ) //when this is called, the ball breaks through all bricks. Something isn't being set. 
				{
					vaus->Data = 0; //make it invisible for the moment, to stop the death anim. 
					capsule.all_clear();
					
					Game->PlayMIDI(MID_STAGE_START);
					for ( int q = 0; q < 180; ++q ) WaitNoAction();
					
					vaus->Misc[MISC_DEAD] = 0; 
					revive_vaus = false;
					
					paddle.setup(vaus);
					capsule.alloff(vaus,movingball);
					ball.create(vaus);
					movingball = vaus->Misc[MISC_BALLID];
				}
				
				if ( !vaus->Misc[MISC_DEAD] )
				{
					if ( !newstage )
					{
						if ( !Screen->NumNPCs() )
						{
							leveldone = true;
							continue;
						}
							
						if ( brick.all_gone() )
						{
						
							leveldone = true;
							continue;
						}
						
						
					}
					if ( Input->Key[KEY_9] )
					{
						bitmap bmp = Game->LoadBitmapID(RT_SCREEN);
						int col[20];
						for ( int q = 0; q < 20; ++ q )
						{
							col[q] = bmp->GetPixel(10+q*8,10+q*8); 
						}
						TraceNL();
						for ( int q = 0; q < 20; ++q ) 
						{
							TraceS("Bitmap col: "); Trace(col[q]);
						}
						
						Screen->SetRenderTarget(2);
						Screen->Rectangle(0, 0, 0, 256, 256, 0x55, 100, 0, 0, 0, true, 128);
						Screen->SetRenderTarget(RT_SCREEN);
						Waitframe();
						
						bitmap offscreen = Game->LoadBitmapID(2);
						int col2[20];
						for ( int q = 0; q < 20; ++ q )
						{
							col2[q] = offscreen->GetPixel(10+q*8,10+q*8); 
						}
						TraceNL();
						for ( int q = 0; q < 20; ++q ) 
						{
							TraceS("Offscreen Bitmap col: "); Trace(col2[q]);
						}
					}	
					
					//if ( Input->Key[KEY_P] ) Trace(movingball->UID); //Frick, I'm an idiot. HIT_BY_LWEAPON is the SCREEN INDEX< not the UID!!
						//2.54 Absolutely needs HitBy_UID!
					if ( Input->Key[KEY_1] ) Trace(frame);
					//if ( frame%60 == 0 ) { Trace(movingball->Step); }
					//Trace(movingball->Step);
					change_setting(); //check for a setting change_setting
					//paddle.extend(vaus);
					paddle.check_input();
					paddle.move(USE_MOUSE, USE_ACCEL, vaus);
					
					ball.launch(movingball);
					if ( !ball.launched(movingball) )
					{
						
						ball.move_with_vaus(movingball, vaus);
							
					}
					
					if ( movingball->Misc[BALL_MISC_CAUGHT] )
					{
						//move relative to vaus
						ball.move_relative_to_vaus(movingball, vaus);
						if ( paddle.pressfire() )
						{
							TraceNL(); TraceS("Pressed fire on caught ball.");
							//ball.launched(movingball,true);
							--movingball->Y;
							movingball->Step = movingball->Misc[BALL_MISC_OLDSTEP];
							/*
							movingball->Angular = (movingball->Misc[BALL_MISC_OLDANGULAR]);
							if ( movingball->Angular )
							{
								movingball->Angle = movingball->Misc[BALL_MISC_OLDANGLE];
								movingball->Dir = movingball->Misc[BALL_MISC_OLDDIR];
							}
							else movingball->Dir = movingball->Misc[BALL_MISC_OLDDIR];
							movingball->Misc[BALL_MISC_OLDSTEP] = 0;
							
							movingball->Misc[BALL_MISC_OLDANGULAR] = 0;
							movingball->Misc[BALL_MISC_OLDANGLE] = 0;
							movingball->Misc[BALL_MISC_OLDDIR] = 0;
							*/
							movingball->Misc[BALL_MISC_CAUGHT] = 0;
							caught = CATCH_ALLOW;
						}
					}
					
					ball.drawover(movingball);
					
					//Shoot lasers
					paddle.shoot_laser(vaus);
					
					//clamp within bounds - MANDATORY because very fast Step speeds can cause the ball
					//to *phase* through pseudo-solid objects, such as walls and the Vaus. 
					ball.clamp_rightwall(movingball);
					ball.clamp_ceiling(movingball);
					ball.clamp_leftwall(movingball);
					ball.clamp_bottom(movingball, vaus); 
					
					
					//ball wall bounce checks
					ball.check_ceiling(movingball);
					ball.check_leftwall(movingball);
					ball.check_rightwall(movingball);
					ball.check_hitvaus(movingball, vaus);
					//ball.set_speed(movingball);
					/*
					
					I moved this to after Waitdraw, because I wanted the post-draw timing for ball bounce, and to ensure that
					the movingball lweapon stayed alive. -Z (Alpha 0.10)
					//Bounce ball on bricks. 
					for ( int q = Screen->NumNPCs(); q > 0; --q )
					{ 
						npc b = Screen->LoadNPC(q);
						if ( b->Type != NPCT_OTHER ) continue;
						TraceNL(); TraceS("movingball->X = "); Trace(movingball->X);
						TraceNL(); TraceS("movingball->Y = "); Trace(movingball->Y);
						brick.take_hit(b, movingball);
					}
					*/
					movingball->DeadState = WDS_ALIVE; //Force it alive at all times if the vaus is alive. 
						//We'll need another solition once we do the 3-way split ball. Bleah. 
				}
				
				//It's probably unwise to run this block twice! Where do I want it, before or after Waitdraw() ? -Z
				else
				{
					paddle.dead(vaus); //Set the death animation here. 
					
					/*
					while ( (frame - 100) < death_frame ) 
					{
						//we should hide the vaus, and restart the stage here. 
						++frame;
						Waitdraw(); //Something is preventing the vaus from changing into the explosion style. S
						Waitframe();
					}
					lweapon deadball = movingball; 
					deadball->DeadState = WDS_DEAD; 
					movingball = vaus->Misc[10];
					if ( Game->Counter[CR_LIVES] ) 
					{
						--Game->Counter[CR_LIVES];
						revive_vaus = true; 
					}
					else
					{
						quit = QUIT_GAMEOVER;
						gameover.run();
						//TraceError("quit state is QUIT_:",QUIT_GAMEOVER);
					}
					*/
					
				}
				
				//Capsule mechanics
				//capsule.all_fall(vaus, movingball); //Handles all capsule interactions. 
				capsule.convert();
				capsule._run(vaus, movingball);
				check_score_extralife();
				if ( !(frame%30) ) capsule.cleanup();
				
				paddle.draw_midpoints(vaus);
				
				Waitdraw();
				
				if ( Input->Key[KEY_7] )
					{
						bitmap bmp = Game->LoadBitmapID(RT_SCREEN);
						int col[20];
						for ( int q = 0; q < 20; ++ q )
						{
							col[q] = bmp->GetPixel(10+q*8,10+q*8); 
						}
						TraceNL();
						for ( int q = 0; q < 20; ++q ) 
						{
							TraceS("Bitmap col: "); Trace(col[q]);
						}
						
						Screen->SetRenderTarget(2);
						Screen->Rectangle(0, 0, 0, 256, 256, 0x55, 100, 0, 0, 0, true, 128);
						Screen->SetRenderTarget(RT_SCREEN);
						Waitframe();
						
						bitmap offscreen = Game->LoadBitmapID(2);
						int col2[20];
						for ( int q = 0; q < 20; ++ q )
						{
							col2[q] = offscreen->GetPixel(10+q*8,10+q*8); 
						}
						TraceNL();
						for ( int q = 0; q < 20; ++q ) 
						{
							TraceS("Offscreen Bitmap col: "); Trace(col2[q]);
						}
					}
					
				if ( Input->Key[KEY_4] )
				{
					TraceNL(); TraceS(" 'vaus' Pointer is: "); Trace(vaus);
					TraceNL(); TraceS(" 'movingball' Pointer is: "); Trace(movingball);
					TraceNL(); TraceS(" 'vaus_guard' Pointer is: "); Trace(vaus_guard);
					
				}
				
				hold_Link_y();
				
				if ( !vaus->Misc[MISC_DEAD] )
				{
					movingball->DeadState = WDS_ALIVE;
					
					//Bounce ball on bricks. 
					for ( int q = Screen->NumNPCs(); q > 0; --q )
					{ 
						npc b = Screen->LoadNPC(q);
						if ( b->Type != NPCT_OTHER ) continue;
						//TraceNL(); TraceS("movingball->X = "); Trace(movingball->X);
						//TraceNL(); TraceS("movingball->Y = "); Trace(movingball->Y);
						movingball->DeadState = WDS_ALIVE;
						//TraceNL(); TraceS("movingball ptr: "); Trace(movingball); 
						brick.take_hit(b, movingball);
					}
					
				}
				else
				{
					paddle.dead(vaus);
					while ( (frame - 100) < death_frame ) 
					{
						//we should hide the vaus, and restart the stage here. 
						++frame;
						Waitdraw();
						Waitframe();
					}
					lweapon deadball = movingball; 
					deadball->DeadState = WDS_DEAD; 
					movingball = Debug->NULL(); //Because = NULL() requires alpha 32. :D
					if ( Game->Counter[CR_LIVES] ) 
					{
						--Game->Counter[CR_LIVES];
						revive_vaus = true; 
					}
					else //Ugh, this is a mess. I might want to rewrite the gane over portion, as it feels as if it'll be a biugger kludge than just calling break.
					{
						gameover.run();
						if ( !death_anim[DEATH_ANIM_COUNTDOWN_TO_QUIT] ) 
						{
							death_anim[DEATH_ANIM_COUNTDOWN_TO_QUIT] = COUNTDOWN_TO_QUIT_FRAMES;
							continue;
						}
						else
						{
							--death_anim[DEATH_ANIM_COUNTDOWN_TO_QUIT];
							if ( death_anim[DEATH_ANIM_COUNTDOWN_TO_QUIT] == 1 ) 
							{
								quit = QUIT_GAMEOVER; //Game over state. 
								TraceNL(); TraceS("Game 'quit' state is now: "); Trace(quit);
							}
						}
					}
						
				}
				
				Waitframe();
			}
			
			while (quit == QUIT_GAMEOVER) //Game Over
			{
				if ( !(GAME[GAME_MISC_FLAGS]&GMFS_PLAYED_GAME_OVER_MUSIC) )
				{
					GAME[GAME_MISC_FLAGS]|=GMFS_PLAYED_GAME_OVER_MUSIC;
					//Play Game over MIDI
					Game->PlayMIDI(1);
					clearscore();
					update_high_score_display();
				}
					
				Screen->DrawString(6, 96, 80, 1, 0x51, 0x00, 0, "GAME OVER", 128);
				
				Waitdraw(); 
				Waitframe();
			}
			//We should never reach here. 
			Waitframe(); 
		}
	}
	void check_score_extralife()
	{
		int score = Game->Counter[CR_SCORE];
		if ( score >= (last_score_award+SCORE_BONUS_LIFE_AT) )
		{
			last_score_award += SCORE_BONUS_LIFE_AT;
			Game->PlaySound(SFX_EXTRA_VAUS);
			++Game->Counter[CR_LIVES];
			
		}
	}
	void clearscore()
	{
		if ( last_score_award > high_score ) high_score = last_score_award;
		last_score_award = 0;
		
	}
	
	void setStageString(int s_ptr)
	{
		int cur[3]="0"; 
		if ( cur_stage < 10 )
			itoa(cur,1,cur_stage);
		else itoa(cur,cur_stage);
		for ( int q = 6; q < 9; ++q ) s_ptr[q] = cur[q-6];
	}


	void showStageString(int s_ptr)
	{
		TraceError("STAGE_X is:", STAGE_X);
		TraceError("STAGE_Y is:", STAGE_Y);
		TraceError("STAGE_FONT is:", STAGE_FONT);
		TraceError("STAGE_FONT is:", STAGE_FONT);
		Screen->DrawString(6,STAGE_X+1,STAGE_Y+1, 0, STAGE_BG_COLOUR,0,0,s_ptr, 128);
		Screen->DrawString(6,STAGE_X,STAGE_Y, STAGE_FONT, STAGE_FG_COLOUR,0,0,s_ptr, 128);	
	}
	
	void update_high_score_display()
	{
		Game->Counter[CR_HIGH_SCORE] = high_score;
	}
	void change_setting()
	{
		if ( Input->Key[KEY_V] && (frame%10 == 0)) { if ( fast_mouse < FAST_MOUSE_MAX ) ++fast_mouse; TraceNL(); TraceS("fast_mouse is now: "); Trace(fast_mouse);  }
		if ( Input->Key[KEY_C] && (frame%10 == 0) ) { if ( fast_mouse > 0 ) --fast_mouse; TraceNL(); TraceS("fast_mouse is now: "); Trace(fast_mouse);  }
		if ( Input->Key[KEY_M] ) 
		{ 
			if ( PressShift() ) 
			{
				USE_MOUSE = 1;
				fast_mouse = 2;
			}
			else 	USE_MOUSE = 1;
		}
		if ( Input->Key[KEY_N] ) USE_MOUSE = 0;
		if ( Input->Key[KEY_F] ) USE_ACCEL = 1;
		if ( Input->Key[KEY_G] ) USE_ACCEL = 0;
		if ( Input->Key[KEY_T] ) --paddle_speed; // paddle_speed = vbound(paddle_speed
		if ( Input->Key[KEY_Y] ) ++paddle_speed; // paddle_speed = vbound(paddle_speed
	}
	void hold_Link_x(ffc v)
	{
		Link->X = v->X+(v->TileWidth*8);
	}
	void hold_Link_y()
	{
		Link->Y = START_PADDLE_Y - 4;
	}
	bool quit() { return ( quit ); }
	
	void check_min_zc_build()
	{
		if ( Game->Build < MIN_ZC_ALPHA_BUILD || Game->Beta < MIN_ZC_BETA_ID )
		{
			Game->PlayMIDI(9);
			int v_too_early = 600; int req_vers[3]; itoa(req_vers, MIN_ZC_ALPHA_BUILD);
			TraceNL(); int vers[3]; itoa(vers,Game->Beta);
			TraceS("This version of Arkanoid.qst requires Zelda Classic v2.55, Alpha (");
			TraceS(req_vers);
			TraceS("), or later.");
			TraceNL();
			TraceS("I'm detecting Zelda Classic v2.55, Alpha (");
			TraceS(vers);
			TraceS(") and therefore, I must refuse to run. :) ");
			TraceNL();
			
			while(v_too_early--)
			{
				//Screen->DrawString(7, 4, 40, 1, 0x04, 0x5F, 0, 
				//"This version of Arkanoid.qst requires Zelda Classic 2.55, Alpha 1", 
				//128);
				Screen->DrawString(7, 15, 40, 1, 0x04, 0x5F, 0, 
				"You are not using a version of ZC adequate to run         ", 
				128);
				
				Screen->DrawString(7, 15, 55, 1, 0x04, 0x5F, 0, 
				"this quest. Please see allegro.log for details.                   ", 
				128);
			
				Waitdraw();
				WaitNoAction();
			}
			Game->End();
			
		}
	}
	
}

const int TILE_BALL = 50512;
const int SPR_BALL = 100;



//preliminary ball
ffc script ball
{
	void run(){}
	void setup_sprite(int sprite_id)
	{
		spritedata sd = Game->LoadSpriteData(sprite_id);
		sd->Tile = TILE_BALL;
	}
	void set_speed(lweapon b, int speed)
	{
		//Trace(bounces);
		b->Step = speed; // bound(bounces,0,MAX_BOUNCES);
		//Trace(b->Step);
	}
	void create(ffc vaus_id) //send the ball lweapon pointer back to the vaus
	{
		lweapon ball = Screen->CreateLWeapon(LW_SCRIPT1);
		TraceNL(); TraceS("Creating ball with Script UID: "); Trace(ball->UID);
		ball->HitWidth = 6; //Not 4, so that the ball bounces when its edges touch a brick. 
		ball->HitHeight = 6; //Not 4, so that the ball bounces when its edges touch a brick. 
		ball->UseSprite(SPR_BALL);
		ball->X = vaus_id->X+18;
		ball->Y = vaus_id->Y-2;
		ball->Damage = 1;
		ball_uid = ball->UID;
		ball->HitXOffset = -1; //so that the ball bounces when its edges touch a brick. 
		ball->HitYOffset = -1; //so that the ball bounces when its edges touch a brick. 
		vaus_id->Misc[MISC_BALLID] = ball;
		TraceNL();TraceS("ball pointer: "); Trace(ball);
		TraceNL();TraceS("ball Pointer, stored: "); Trace(vaus_id->Misc[MISC_BALLID]);
	}
	void drawover(lweapon b)
	{
		b->DrawYOffset = -32768; //I'm not sure why the script draw for this is mis-drawing relative to the angle of the ball.
		Screen->DrawTile(6,b->X,b->Y,b->Tile,b->TileWidth,b->TileHeight,b->CSet,-1,-1,0,0,0,0,true,128);
	}
	
	void launch(lweapon b)
	{
		if ( b->Misc[MISC_LAUNCHED] ) return;
		bool launched;
		for ( int q = CB_A; q < CB_R; ++q ) 
		{
			if ( Input->Press[q] ) { launched = true; break; }
		}
		if ( USE_MOUSE ) 
		{
			//if ( Input->Mouse[_MOUSE_LCLICK] )  //Not working?!
			if ( Link->InputMouseB )
				launched = true;
		}
		if ( launched ) 
		{
			//b->Angular = true;
			Game->PlaySound(SFX_BALL_HIT_VAUS);
			b->Dir = DIR_RIGHTUP;	
			b->Step = BALL_INITIAL_STEP;
			b->Misc[MISC_LAUNCHED] = 1;
		}
	}
	bool launched(lweapon b) 
	{
		return (b->Misc[MISC_LAUNCHED]);
	}
	void launched(lweapon b, bool state)
	{
		b->Misc[MISC_LAUNCHED] = state;
	}
	void move(lweapon b)
	{
		
	}
	float bound(int val, int min, int max)
	{
		if ( val < min ) return min;
		if ( val > max ) return max;
		return val;
	}
	//Not launched yet.
	void move_with_vaus(lweapon b, ffc v)
	{
		b->X = v->X+18;
	}
	//caught
	void move_relative_to_vaus(lweapon b, ffc v)
	{
		b->X = v->X + caught_relative_ball_vaus_x;
	}
	//ball.clamp*() are needed for when the step speed is so great that the ball skips past the equality checks.
	void clamp_ceiling(lweapon b)
	{
		if ( b->Y < BALL_MIN_Y )			
		{
			b->Y = BALL_MIN_Y;
		}
	}
	void clamp_leftwall(lweapon b)
	{
		if ( caught == CATCH_HOLDING_BALL ) return; //don't do anything while the vaus is holding the ball
		if ( b->X < BALL_MIN_X ) b ->X = BALL_MIN_X;
	}
	void clamp_rightwall(lweapon b)
	{
		if ( caught == CATCH_HOLDING_BALL ) return; //don't do anything while the vaus is holding the ball
		if ( b->X > BALL_MAX_X ) b->X = BALL_MAX_X;
	}
	/*
	void clamp_bottom(lweapon b, ffc v)
	{
		if ( caught == CATCH_HOLDING_BALL ) return; //don't do anything while the vaus is holding the ball
		if ( b->Y+4 > v->Y+8 ) dead(b,v);
	}
	*/
	//A function to check of the bounding will prevent the ball from falling out of field.
	void clamp_bottom(lweapon b, ffc v)
	{
		if ( caught == CATCH_HOLDING_BALL ) return; //don't do anything while the vaus is holding the ball
		if ( b->Y+4 > v->Y ) b->Y = v->Y-4;
	}
	void check_ceiling(lweapon b)
	{
		if ( b->Y == BALL_MIN_Y )			
		{
			Game->PlaySound(SFX_BALL_HIT_BLOCK);
			if ( b->Angular )
			{
				switch(b->Angle)
				{
					case DIR_LLU:
					{
						b->Angular = false;
						b->Dir = DIR_LEFTDOWN;
						///*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
						break;
					}
					case DIR_LUU:
					{
						b->Angular = false;
						b->Dir = DIR_LEFTDOWN;
						///*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
						break;
					}
					case DIR_RRU:
					{
						b->Angular = false;
						b->Dir = DIR_RIGHTDOWN;
						///*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
						break;
					}
					case DIR_RUU:
					{
						b->Angular = false;
						b->Dir = DIR_RIGHTDOWN;
						///*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
						break;
					}
					
				}
			}
			else
			{
				switch(b->Dir)
				{
					case DIR_RIGHTUP: { b->Dir = DIR_RIGHTDOWN; /*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ break; }
					case DIR_LEFTUP: { b->Dir = DIR_LEFTDOWN; /*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ break; }
					default: { 
						TraceNL(); TraceS("Ball direction invalid for ball.check_ceiling()."); 
							TraceNL(); TraceS("Ball Dir is: "); Trace(b->Dir); TraceNL();
						b->Dir = DIR_DOWN; /*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ break; }
				}
			}
		}
	}
	void check_leftwall(lweapon b)
	{
		if ( caught == CATCH_HOLDING_BALL ) return; //don't do anything while the vaus is holding the ball
		if ( b->X == BALL_MIN_X ) 
		{
			Game->PlaySound(SFX_BALL_HIT_BLOCK);
			if ( b->Angular )
			{
				switch(b->Angle)
				{
					case DIR_LLU:
					{
						b->Angular = false;
						b->Dir = DIR_RIGHTUP;
						/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
						break;
					}
					case DIR_LUU:
					{
						b->Angular = false;
						b->Dir = DIR_RIGHTUP;
						/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
						break;
					}
					case DIR_LLD:
					{
						b->Angular = false;
						b->Dir = DIR_RIGHTDOWN;
						/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
						break;
					}
					case DIR_LDD:
					{
						b->Angular = false;
						b->Dir = DIR_RIGHTDOWN;
						/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
						break;
					}
					
				}
			}
			else
			{
				switch(b->Dir)
				{
					case DIR_LEFTDOWN: { b->Dir = DIR_RIGHTDOWN; /*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ break; }
					case DIR_LEFTUP: { b->Dir = DIR_RIGHTUP; /*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ break; }
					default: { 
						TraceNL(); TraceS("Ball direction invalid for ball.check_leftwall()."); 
							TraceNL(); TraceS("Ball Dir is: "); Trace(b->Dir); TraceNL();
						b->Dir = DIR_DOWN; /*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ break; }
				}
			}
		}
	}
	void check_rightwall(lweapon b)
	{
		if ( caught == CATCH_HOLDING_BALL ) return; //don't do anything while the vaus is holding the ball
		if ( b->X == BALL_MAX_X ) 
		{
			Game->PlaySound(SFX_BALL_HIT_BLOCK);
			if ( b->Angular )
			{
				switch(b->Angle)
				{
					case DIR_RRD:
					{
						b->Angular = false;
						b->Dir = DIR_LEFTDOWN;
						/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
						break;
					}
					case DIR_RDD:
					{
						b->Angular = false;
						b->Dir = DIR_LEFTDOWN;
						/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
						break;
					}
					case DIR_RRU:
					{
						b->Angular = false;
						b->Dir = DIR_LEFTUP;
						/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
						break;
					}
					case DIR_RUU:
					{
						b->Angular = false;
						b->Dir = DIR_LEFTUP;
						/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
						break;
					}
					
				}
			}
			else
			{
				switch(b->Dir)
				{
					case DIR_RIGHTDOWN: { b->Dir = DIR_LEFTDOWN; /*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ break; }
					case DIR_RIGHTUP: { b->Dir = DIR_LEFTUP; /*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ break; }
					default: { 
						TraceNL(); TraceS("Ball direction invalid for ball.check_rightwall()."); 
							TraceNL(); TraceS("Ball Dir is: "); Trace(b->Dir); TraceNL();
						b->Dir = DIR_DOWN; /*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ break; }
				}
			}
		}
	}
	void check_hitvaus(lweapon b, ffc v)
	{
		if ( launched(b) )
		{
			
			
			if ( b->Angular )
			{
				if ( b->Angle == DIR_UUR ){ return; }
				if ( b->Angle == DIR_UUL ) { return; }
				if ( b->Angle == DIR_ULL ) { return; }
				if ( b->Angle == DIR_URR ) { return; }
			}
			else
			{
				
				if ( b->Dir == DIR_RIGHTUP ) { return; }
				if ( b->Dir == DIR_LEFTUP ) { return; }
			}
			
			int hit_position; int vaus_midpoint =  v->X+(((v->TileWidth*16)/2)-1);
			int midpoint_segment = v->X+(((v->TileWidth*16)/6));
			int ball_midpoint;
			if ( b->Angular )
			{
				switch(b->Angle)
				{
					case DIR_LLD: { ball_midpoint = b->X+2; break; }
					case DIR_LDD: { ball_midpoint = b->X+2; break; }
					case DIR_RRD: { ball_midpoint = b->X+3; break; }
					case DIR_RDD: { ball_midpoint = b->X+3; break; }
					default: { ball_midpoint = b->X+2; break; }
				}
			}
			else
			{
				switch(b->Dir)
				{
					case DIR_DOWNLEFT: { ball_midpoint = b->X+2; break; }
					case DIR_DOWNRIGHT: { ball_midpoint = b->X+3; break; }
					default: { ball_midpoint = b->X+2; break; }
				}
			}
			if ( b->Y+4 == v->Y )
				//Now we need to check here, if the paddle is under the ball:
			{
				if ( b->X >= v->X-3 ) //-3, because the ball is 4px wide, so we cover the last pixel of the ball against the furst pixel of the Vaus
				{
					if ( b->X <= v->X+((v->TileWidth*16)+4) ) //no +3 here, because it's the actual X, so the first pixel of the ball is covered by the last pixel of the vaus.
					{
						Game->PlaySound(SFX_BALL_HIT_VAUS);
						//b->Y = v->Y-1;
						
						if ( ball_midpoint <= paddle.centre(v) ) //hit left side of vaus
						{
							//more left than up, hit end of Vaus
							if ( ball_midpoint <= paddle.get_segment(v,1)-2 ) //slight adjustment
							//if ( Abs(ball_midpoint-vaus_midpoint) <= 2 )
							{
								//angular up
								TraceNL(); TraceS("Setting ball dir to ANGULAR Left-left-Up");
								
								b->Angular = true;
								b->Angle = DIR_LLU;
								TraceNL(); TraceS("Checking if set angle evals true when compared against: "); TraceB(b->Angle == DIR_LUU);
								try_catch(b,v);
								return;
							}
							
							
							//hit slice between end and centre, LU
							else if ( ball_midpoint <= paddle.get_segment(v,2)+1 ) //slight adjustment
							{
								TraceNL(); TraceS("Setting ball dir to DIGITAL Left-Up");
								//b->Y = v->Y-1;
								b->Angular = false;
								b->Dir = DIR_UPLEFT;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/
								try_catch(b,v);
								return;
							}
							
							//hit close to centre, LUU
							else
							{
							
								//angular up
								TraceNL(); TraceS("Setting ball dir to ANGULAR Left-Up-Up");
								
								b->Angular = true;
								b->Angle = DIR_LUU;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/
								TraceNL(); TraceS("Checking if set angle evals true when compared against: "); TraceB(b->Angle == DIR_LUU);
								try_catch(b,v);
								return;
								
							}
							
						}
						//hit right side of paddle
						else// if ( ball_midpoint > vaus_midpoint ) //hit right side of vaus
						{
							/*
							if ( Abs(ball_midpoint-vaus_midpoint) <= 2 )
							{
								//angular up
								TraceNL(); TraceS("Setting ball dir to ANGULAR RIGHT-Up-Up");
								--b->Y;
								b->Angular = true;
								b->Angle = DIR_RUU;
								TraceNL(); TraceS("Checking if set angle evals true when compared against: "); TraceB(b->Angle == DIR_RUU);
					
							}
							if ( b->X >= (v->X+(v->TileWidth*16)-2) )
							{
								//angular, sideways
								TraceNL(); TraceS("Setting ball dir to ANGULAR right-right-Up");
								--b->Y;
								b->Angular = true;
								b->Angle = DIR_RRU;
								TraceNL(); TraceS("Checking if set angle evals true when compared against: "); TraceB(b->Angle == DIR_RRU);
					
							}
							*/
							//more up then right, hit vaus close to centre
							if ( ball_midpoint < paddle.get_segment(v,4) )
							{
								//angular up
								TraceNL(); TraceS("Setting ball dir to ANGULAR RIGHT-Up-Up");
								
								b->Angular = true;
								b->Angle = DIR_RUU;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/
								TraceNL(); TraceS("Checking if set angle evals true when compared against: "); TraceB(b->Angle == DIR_RUU);
								try_catch(b,v);
								return;
							}
							//more right than up, hit end of vaus
							else if ( ball_midpoint < paddle.get_segment(v,5) ) 
							//else if ( (Abs(vaus_midpoint - b->X)) >= v->X+((v->TileWidth*16)/2)-1 )
							{
								
								
								//hit the centre midpoint
								//set angular = false
								//set DIR_UR
								TraceNL(); TraceS("Setting ball dir to DIGITAL Right-Up");
								//b->Y = v->Y-6;
								b->Angular = false;
								b->Dir = DIR_UPRIGHT;
								//b->Dir = DIR_UPRIGHT;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/
								try_catch(b,v);
								return;
								
							}
							else
							{
								
								//angular up
								TraceNL(); TraceS("Setting ball dir to ANGULAR RIGHT-right-Up");
								
								b->Angular = true;
								b->Angle = DIR_RRU;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/
								try_catch(b,v);
								TraceNL(); TraceS("Checking if set angle evals true when compared against: "); TraceB(b->Angle == DIR_RUU);
								return;
							}
							
						}
						
						
							
					}
					else 
					{
						dead(b,v);
					}
				}
				else 
				{
					dead(b,v);
				}
			}
			
		}
	}
	void try_catch(lweapon b, ffc v)
	{
		//catch mechanics
		if ( caught == CATCH_ALLOW )
		{
			//TraceNL(); TraceS("Ball hit vaus with catch allow status.");
			caught = CATCH_HOLDING_BALL;
			b->Misc[BALL_MISC_CAUGHT] = 1;
			b->Misc[BALL_MISC_OLDSTEP] = b->Step;
			//TraceNL(); TraceS("b->Misc[BALL_MISC_OLDSTEP] is: "); Trace(b->Misc[BALL_MISC_OLDSTEP]);
			//b->Misc[BALL_MISC_OLDANGULAR] = Cond(b->Angular,1,0);
			//b->Misc[BALL_MISC_OLDANGLE] = b->Angle;
			//b->Misc[BALL_MISC_OLDDIR] = b->Dir;
			b->Step = 0;
			//launched(b,false);
			caught_relative_ball_vaus_x = Abs(b->X - v->X);
		}
	}
	void dead(lweapon b, ffc v)
	{
		
		Game->PlayMIDI(5);
		//remove the ball
		b->Y = -32768; b->Step = 0;
		v->Misc[MISC_DEAD] = 1;
		//if there are more balls in play, switch movingball to one of those
		//otherwise,
		//check next life
		//if more lives, reset playfield
		//otherwise game over
		
	}
	
	
	
}

ffc script ball_controller
{
	void run()
	{
		lweapon ball;
		lweapon active_ball; //will be used for when we have multiple balls. 
		lweapon balls[3]; //for divide
		ball = Screen->CreateLWeapon(LW_SCRIPT1);
		ball->X = START_BALL_X;
		ball->Y = START_BALL_Y;
		this->Vx = START_BALL_VX;
		this->Vy = START_BALL_VY;
		bool alive = true;
		int num_balls = 1;
		while(alive)
		{
			if ( ball->Y <= BALL_MIN_Y )
			{
				bounce();
			}
			if ( ball->X <= BALL_MIN_X )
			{
				bounce();
			}
			if ( ball->X >= BALL_MAX_X )
			{
				bounce();
			}
				
			if ( ball->Y >= BALL_MAX_Y )
			{
				if ( num_balls < 2 ) 
				{
					alive = false;
				}
				else 
				{
					kill_ball(ball); //removes this ball, and sets another ball to be the active one
					--num_balls;
				}
			}
			Waitframe();
		}
	}
	void bounce(){}
	void kill_ball(lweapon b){}
	
}

const int BRICK_MAX = 14;

//Layer 1
const int CMB_BRICK_RED		= 1488;
const int CMB_BRICK_WHITE	= 1490;
const int CMB_BRICK_BLUE	= 1492;
const int CMB_BRICK_ORANGE	= 1494;
const int CMB_BRICK_TEAL	= 1496;
const int CMB_BRICK_VIOLET	= 1498;
const int CMB_BRICK_GREEN	= 1500;
const int CMB_BRICK_YELLOW	= 1502;
const int CMB_BRICK_SILVER1	= 1504;
const int CMB_BRICK_SILVER2	= 1506;
const int CMB_BRICK_SILVER3	= 1508;
const int CMB_BRICK_SILVER4	= 1510;
const int CMB_BRICK_GOLD	= 1516;


//layer 2
const int CMB_BRICK_RED_LOW 	= 1489;
const int CMB_BRICK_WHITE_LOW	= 1491;
const int CMB_BRICK_BLUE_LOW 	= 1493;
const int CMB_BRICK_ORANGE_LOW	= 1495;
const int CMB_BRICK_TEAL_LOW	= 1497;
const int CMB_BRICK_VIOLET_LOW	= 1499;
const int CMB_BRICK_GREEN_LOW	= 1501;
const int CMB_BRICK_YELLOW_LOW	= 1503;
const int CMB_BRICK_SILVER1_LOW	= 1505;
const int CMB_BRICK_SILVER2_LOW	= 1507;
const int CMB_BRICK_SILVER3_LOW	= 1509;
const int CMB_BRICK_SILVER4_LOW	= 1511;
const int CMB_BRICK_GOLD_LOW	= 1517;

//enemies
const int NPC_BRICK_RED 	= 181;
const int NPC_BRICK_WHITE 	= 182;
const int NPC_BRICK_BLUE 	= 183;
const int NPC_BRICK_ORANGE	= 184;
const int NPC_BRICK_TEAL 	= 185;
const int NPC_BRICK_VIOLET 	= 186;
const int NPC_BRICK_GREEN 	= 187;
const int NPC_BRICK_YELLOW 	= 188;
const int NPC_BRICK_SILVER1 	= 189;
const int NPC_BRICK_SILVER2 	= 190;
const int NPC_BRICK_SILVER3  	= 255; //not set up yet;
const int NPC_BRICK_SILVER4 	= 255; //not set up yet
const int NPC_BRICK_GOLD 	= 191;


const int HIT_BY_LWEAPON = 2;
const int HIT_BY_LWEAPON_UID = 6; 



const int CAPS_TYPE_EXTEND = 126;
const int CAPS_TYPE_BREAK = 129;
const int CAPS_TYPE_CATCH = 125;
const int CAPS_TYPE_DIVIDE = 128;
const int CAPS_TYPE_LASER = 127;
const int CAPS_TYPE_VAUS = 123;
const int CAPS_TYPE_SLOW = 124;


ffc script capsule
{
	void run(ffc v, lweapon b)
	{
		for ( int q = Screen->NumLWeapons(); q > 0; --q )
		{
			lweapon c = Screen->LoadLWeapon(q);
			if ( c->ID == LW_SCRIPT2 )
			{
				if ( check_hitvaus(c,v,b) ) Remove(c);
				if ( c->Y > 256 ) Remove(c);
			}
		}
	}
	void _run(ffc v, lweapon b)
	{
		for ( int q = Screen->NumLWeapons(); q > 0; --q )
		{
			lweapon c = Screen->LoadLWeapon(q);
			if ( c->ID == LW_SCRIPT2 )
			{
				if ( check_hitvaus(c,v,b) ) Remove(c);
				if ( c->Y > 256 ) Remove(c);
			}
		}
	}
	void create(int x, int y)
	{
		int type = choosetype();
		if ( type > 0 ) 
		{
			item capsule = Screen->CreateItem(type);
			capsule->X = x;
			capsule->Y = y;
		}
	}
	void convert()
	{
		const int CAPS_EW_MISC_TYPE = 5;
		const int CAPS_ITEM_ATTRIB_TYPE = 0;
		const int CAPS_ITEM_SPRITE = 0;
		//const int CAPS_EW_MISC_POINTS = 6; //global
		const int CAPS_ITEM_ATTRIB_POINTS = 1;
		item c; itemdata id;
		for ( int q = Screen->NumItems(); q > 0; --q )
		{
			c = Screen->LoadItem(q);
			id = Game->LoadItemData(c->ID);
			if ( id->Family == IC_CUSTOM1 )
			{
				lweapon cap = Screen->CreateLWeapon(EW_SCRIPT2);
				cap->X = c->X;
				cap->Y = c->Y;
				cap->Misc[CAPS_EW_MISC_TYPE] = id->Attributes[CAPS_ITEM_ATTRIB_TYPE];
				cap->UseSprite(id->Sprites[CAPS_ITEM_SPRITE]);
				cap->Misc[CAPS_EW_MISC_POINTS] = id->Attributes[CAPS_ITEM_ATTRIB_POINTS];
				//c->DrawYOffset = -16000;
				cap->HitWidth = c->HitWidth;
				cap->HitHeight = c->HitHeight;
				Remove(c);
				
				cap->Dir = DIR_DOWN;
				
				cap->Step = CAPSULE_STEP;
				cap->CollDetection = false;
				cap->Behind = false; 
				TraceNL(); TraceS("Behind is: "); TraceB(cap->Behind);
			}
		}
	}
	int get_type(lweapon c)
	{
		const int CAPS_EW_MISC_TYPE = 5;
		return c->Misc[CAPS_EW_MISC_TYPE];
	}
	void drawover(item c)
	{
		DrawToLayer(c, 5, 128);
	}
	bool check_hitvaus(lweapon c, ffc v, lweapon b)
	{
		//mask out the area of the screen where the Vaus paddle isn't located, relative to the capsule hitbox. 
		if ( (c->Y+c->HitHeight) < START_PADDLE_Y ) return false;
		if ( c->Y > (START_PADDLE_Y+START_PADDLE_HEIGHT-2) ) return false; //last two pixels of vaus
		if ( (c->X+c->HitWidth) < v->X ) return false;
		if ( c->X > (v->X+(v->TileWidth*16)) ) return false; 
		//if it hits, check the type
		int captype = c->ID;
		switch(get_type(c))
		{
			case CAPS_TYPE_EXTEND: { extend(v,b); Game->Counter[CR_SCORE] += c->Misc[CAPS_EW_MISC_POINTS]; return true; }
			case CAPS_TYPE_BREAK: { escape(v,b); Game->Counter[CR_SCORE] += c->Misc[CAPS_EW_MISC_POINTS]; return true; }
			case CAPS_TYPE_CATCH: { catchball(v,b); Game->Counter[CR_SCORE] += c->Misc[CAPS_EW_MISC_POINTS]; return true; }
			case CAPS_TYPE_DIVIDE: { split(v,b); Game->Counter[CR_SCORE] += c->Misc[CAPS_EW_MISC_POINTS]; return true; }
			case CAPS_TYPE_LASER: { laser(v,b); Game->Counter[CR_SCORE] += c->Misc[CAPS_EW_MISC_POINTS]; return true; }
			case CAPS_TYPE_VAUS:{ extravaus(v,b); Game->Counter[CR_SCORE] += c->Misc[CAPS_EW_MISC_POINTS]; return true; }
			case CAPS_TYPE_SLOW:{ slow(v,b); Game->Counter[CR_SCORE] += c->Misc[CAPS_EW_MISC_POINTS]; return true; }
			default: break;
		}
				
		return false;		
			
			
	}
	bool check_hitvaus(item c, ffc v, lweapon b)
	{
		//mask out the area of the screen where the Vaus paddle isn't located, relative to the capsule hitbox. 
		if ( (c->Y+c->HitHeight) < START_PADDLE_Y ) return false;
		if ( c->Y > (START_PADDLE_Y+START_PADDLE_HEIGHT-2) ) return false; //last two pixels of vaus
		if ( (c->X+c->HitWidth) < v->X ) return false;
		if ( c->X > (v->X+(v->TileWidth*16)) ) return false; 
		//if it hits, check the type
		int captype = c->ID;
		switch(captype)
		{
			case CAPS_TYPE_EXTEND: { extend(v,b); return true; }
			case CAPS_TYPE_BREAK: { escape(v,b); return true; }
			case CAPS_TYPE_CATCH: { catchball(v,b); return true; }
			case CAPS_TYPE_DIVIDE: { split(v,b); return true; }
			case CAPS_TYPE_LASER: { laser(v,b); return true; }
			case CAPS_TYPE_VAUS:{ extravaus(v,b); return true; }
			case CAPS_TYPE_SLOW:{ slow(v,b); return true; }
			default: break;
		}
				
		return false;		
			
			
	}
	void laser(ffc v, lweapon b)
	{
		TraceNL(); TraceS("Capsule LASER struck vaus!!");
		extended = false;
		Game->PlaySound(SFX_ARK2_POWERUP2);
		v->Data = CMB_VAUS_LASER;
		v->TileWidth = 2;
		//Game->PlaySound(capsule)
		//change the vaus data to the laser
		laser = true;
		caught = CATCH_NONE;
		if ( b->Misc[BALL_MISC_CAUGHT] ) 
		{
			b->Misc[BALL_MISC_CAUGHT] = 0;
			b->Step = b->Misc[BALL_MISC_OLDSTEP];
		}
		
	}
	void extend(ffc v, lweapon b)
	{
		TraceNL(); TraceS("Capsule EXTEND struck vaus!!");
		Game->PlaySound(SFX_EXTEND);
		//change the vaus data to the default
		//this is needed because collecting any powerup after
		//a laser capsule reverts fromt he laser status
		laser = false;
		extended = true;
		v->Data = CMB_VAUS_EXTENDED;
		v->TileWidth = 3;
		caught = CATCH_NONE;
		if ( b->Misc[BALL_MISC_CAUGHT] ) 
		{
			b->Misc[BALL_MISC_CAUGHT] = 0;
			b->Step = b->Misc[BALL_MISC_OLDSTEP];
		}
	}
	void slow(ffc v, lweapon b)
	{
		TraceNL(); TraceS("Capsule SLOW struck vaus!!");;
		Game->PlaySound(SFX_ARK2_POWERUP2);
		laser = false;
		extended = false;
		v->Data = CMB_VAUS;
		v->TileWidth = 2;
		caught = CATCH_NONE;
		if ( b->Misc[BALL_MISC_CAUGHT] ) 
		{
			b->Misc[BALL_MISC_CAUGHT] = 0;
		}
		b->Step = BALL_INITIAL_STEP;
	}
	void escape(ffc v, lweapon b)
	{
		Game->PlaySound(SFX_ARK2_POWERUP);
		TraceNL(); TraceS("Capsule BREAK struck vaus!!");
		extended = false;
		v->Data = CMB_VAUS;
		v->TileWidth = 2;
		////Game->PlaySound(capsule)
		laser = false;
		caught = CATCH_NONE;
		if ( b->Misc[BALL_MISC_CAUGHT] ) 
		{
			b->Misc[BALL_MISC_CAUGHT] = 0;
			b->Step = b->Misc[BALL_MISC_OLDSTEP];
		}
		//create exit
		leveldone = true;
	}
	void extravaus(ffc v, lweapon b)
	{
		TraceNL(); TraceS("Capsule VAUS struck vaus!!");
		Game->PlaySound(SFX_EXTRA_VAUS);
		laser = false;
		extended = false;
		caught = CATCH_NONE;
		v->Data = CMB_VAUS;
		v->TileWidth = 2;
		++Game->Counter[CR_LIVES];
		if ( b->Misc[BALL_MISC_CAUGHT] ) 
		{
			b->Misc[BALL_MISC_CAUGHT] = 0;
			b->Step = b->Misc[BALL_MISC_OLDSTEP];
		}
	}
	void split(ffc v, lweapon b)
	{
		Game->PlaySound(SFX_ARK2_POWERUP2);
		TraceNL(); TraceS("Capsule SPLIT struck vaus!!");
		extended = false;
		v->Data = CMB_VAUS;
		v->TileWidth = 2;
		////Game->PlaySound(capsule)
		laser = false;
		caught = CATCH_NONE;
		if ( b->Misc[BALL_MISC_CAUGHT] ) 
		{
			b->Misc[BALL_MISC_CAUGHT] = 0;
			b->Step = b->Misc[BALL_MISC_OLDSTEP];
		}
		
		//! fuck this is going to be hard to add
		
	}
	void catchball(ffc v, lweapon b)
	{
		Game->PlaySound(SFX_ARK2_POWERUP2);
		TraceNL(); TraceS("Capsule CATCH struck vaus!!");
		extended = false;
		v->Data = CMB_VAUS;
		v->TileWidth = 2;
		////Game->PlaySound(capsule)
		laser = false;
		extended = false;
		caught = CATCH_ALLOW;
		
		/* For catching the ball:
			When the catch state is 1, then if the ball strikes the vaus **AND** the vaus state is NOT HOLDING_BALL, 
			then its Step is saved to a misc index (MISC_CAUGHT_STEP) for its lweapon, and its Step is set to 0.
			Then, its catch state is set to 2, and a Vaus misc index is set to HOLDING_BALL. 
			When the player presses a LAUNCH button, the Step speed recorded to b->Misc[MISC_CAUGHT_STEP] is set
			to b->Step, the Misc[] index is cleared, v->Misc[HOLDING_BALL] is set to 0, and catch is set back to 1. 
		*/
		
	}
	void alloff(ffc v, lweapon b)
	{
		TraceNL(); TraceS("Clearing all power-up conditions.");
		laser = false;
		extended = false;
		v->Data = CMB_VAUS;
		v->TileWidth = 2;
		caught = CATCH_NONE;
		if ( b->Misc[BALL_MISC_CAUGHT] ) 
		{
			b->Misc[BALL_MISC_CAUGHT] = 0;
			b->Step = b->Misc[BALL_MISC_OLDSTEP];
		}
	}
	int choosetype()
	{
		int typetable[] =
		{
			CAPS_TYPE_EXTEND, CAPS_TYPE_EXTEND, CAPS_TYPE_EXTEND, CAPS_TYPE_EXTEND, CAPS_TYPE_EXTEND, CAPS_TYPE_EXTEND, CAPS_TYPE_EXTEND, CAPS_TYPE_EXTEND, CAPS_TYPE_EXTEND, CAPS_TYPE_EXTEND,
			CAPS_TYPE_CATCH, CAPS_TYPE_CATCH, CAPS_TYPE_CATCH, 
			/* turning off during Fall Expo CAPS_TYPE_DIVIDE, CAPS_TYPE_DIVIDE, CAPS_TYPE_DIVIDE, */
			CAPS_TYPE_LASER, CAPS_TYPE_LASER, CAPS_TYPE_LASER, 
			CAPS_TYPE_SLOW, CAPS_TYPE_SLOW, CAPS_TYPE_SLOW, CAPS_TYPE_SLOW, CAPS_TYPE_SLOW, 
			CAPS_TYPE_VAUS, CAPS_TYPE_BREAK
			
			
		}; //each index is equal to a 1% chance
		//return ( typetable[Rand(0,99)] );
		//return CAPS_TYPE_EXTEND; //Testing this with one type, first. 
		return ( typetable[Rand(0,SizeOfArray(typetable)-1)] );
		
	}
	void fall(item c)
	{
		for ( int q = 0; q < CAPSULE_FALL_SPEED; ++q )
		{
			++c->Y;
		}
	}
	void all_fall(ffc v, lweapon b)
	{
		for ( int q = Screen->NumItems(); q > 0; --q )
		{
			item c = Screen->LoadItem(q);
			fall(c);
			drawover(c);
			if ( check_hitvaus(c, v, b) ) Remove(c);
			//TraceNL(); TraceS("Capsule Hit State: "); TraceB(hit);
			if ( c->Y > 256 ) Remove(c);
		}
	}
	void _do(ffc v, lweapon b)
	{
		for ( int q = Screen->NumLWeapons(); q > 0; --q )
		{
			lweapon c = Screen->LoadLWeapon(q);
			if ( c->ID == EW_SCRIPT2 )
			{
				if ( check_hitvaus(c,v,b) ) Remove(c);
				if ( c->Y > 256 ) Remove(c);
			}
		}
	}
	void cleanup()
	{
		for ( int q = Screen->NumLWeapons(); q > 0; --q )
		{
			lweapon c = Screen->LoadLWeapon(q);
			if ( c->ID == EW_SCRIPT2 )
			{
				if ( c->Y > 256 ) Remove(c);
			}
		}
	}
	void cleanup(item c)
	{
		if ( c->Y > 256 ) Remove(c);
	}
	void all_clear()
	{
		for ( int q = Screen->NumLWeapons(); q > 0; --q )
		{
			lweapon c = Screen->LoadLWeapon(q);
			if ( c->ID == EW_SCRIPT2 )
			{
				Remove(c);
			}
		}
	}
	
}





ffc script brick
{
	void run()
	{
	}
	bool drop_capsule(npc a)
	{
		if ( Rand(1,100) <= BRICK_CHANCE_CAPSULE )
		{
			capsule.create(a->X, a->Y);
		}
	}
	bool all_gone()
	{
		npc n; int count;
		for ( int q = Screen->NumNPCs(); q > 0; --q )
		{
			n = Screen->LoadNPC(q);
			if ( n->Type == NPCT_OTHER ) 
			{
				if ( n->HP < 1000 ) ++count;
			}
		}
		return ( count <= 0 );
	}
	float bound(int val, int min, int max)
	{
		if ( val < min ) return min;
		if ( val > max ) return max;
		return val;
	}
	bool hit(npc a, lweapon v)
	{
		/*
		if ( a->HitBy[HIT_BY_LWEAPON] < 1 ) return false; 
		a->Misc[12] = Screen->LoadLWeapon(a->HitBy[HIT_BY_LWEAPON]);
		lweapon hitwpn = a->Misc[12];
		return ( hitwpn->UID == v->UID );
		*/
		if ( a->HitBy[HIT_BY_LWEAPON_UID] == v->UID )
		{
			
			
			TraceNL(); TraceS("Brick hit by Weapon Type: "); Trace(a->HitBy[12]);
			TraceNL(); TraceS("Brick hit by Weapon from Item ID: "); Trace(a->HitBy[15]);
			
			return true;
		}
		return ( a->HitBy[HIT_BY_LWEAPON_UID] == v->UID );
		//int indx; //Until we have UIDs working for HitBy[], we need to do it this way. 
		//for ( int q = Screen->NumLWeapons(); q > 0; --q ) 
		//{
		//	lweapon temp = Screen->LoadLWeapon(q);
		//	if ( temp->UID == v->UID ) 
		//	{ 
		//		indx = q; break;
		//	}
		//}
		//Link->Misc[0] = v; //We'll use this as scratch untyped space for the moment. -Z
		//TraceS("brick.hit() Link->Misc[] is: "); Trace(Link->Misc[0]);
		//TraceS("brick.hit() v is: "); Trace(v);
		//int temp_UID = v->UID * 10000; //this is a bug in HITBY[]. The HitBy value being stored is being multiplied by 10000, and it should not be.
			//as UID is not, and NEVER should be!!!
		//TraceNL(); TraceS("v->UID is: "); Trace(v->UID);
		/*
		To determine where a brick was hit, we first scan each brick and look to see which was
		hit at all, by our lweapon.
		
		The, we check if that ball is belove, above, right of, or left of the brick,
		and we read its direction.
		
		Using a logic chain from this data, we determine the direction that the ball should next 
		take, when it bounces.
		
		*/
		//HitBy[]
		
		//if ( a->HitBy[HIT_BY_LWEAPON] ) 
		//{ 
		//	TraceNL(); TraceS("a->HitBy[HIT_BY_LWEAPON] id: "); Trace(a->HitBy[HIT_BY_LWEAPON]); 
		//	TraceNL();
		//	TraceS("Our Link->Misc scratch value `is: "); Trace((Link->Misc[0]+1));
		//}
		
		//! We'll use this method again when we add UIDs to HitBy[] ! -Z
		//return ( a->HitBy[HIT_BY_LWEAPON] == temp_UID ); 
		//return ( a->HitBy[HIT_BY_LWEAPON] == indx ); //(Link->Misc[0]+1) ); 
		
	}
	bool hit_below(npc a, lweapon v)
	{
		if ( v->Y == (a->Y + 8) ) return true; //we could do bounce here. 
	}
	bool hit_above(npc a, lweapon v)
	{
		if ( v->Y == (a->Y - 4) ) return true; //we could do bounce here. 
	}
	bool hit_left(npc a, lweapon v)
	{
		if ( v->X == (a->X - 4) ) return true; //we could do bounce here. 
	}
	bool hit_right(npc a, lweapon v)
	{
		if ( v->X == (a->X + 16 ) ) return true; //we could do bounce here. 
	}
	
	void take_hit(npc a, lweapon b)
	{
		if ( hit(a,b) )
		{
			//TraceNL(); TraceS("Brick hit!"); 
			b->DeadState = WDS_ALIVE; 
			//TraceNL(); TraceS("brick->X = "); Trace(a->X);
			//TraceNL(); TraceS("brick->Y = "); Trace(a->Y);
			//TraceNL(); TraceS("ball->X = "); Trace(v->X);
			//TraceNL(); TraceS("ball->Y = "); Trace(v->Y);
			if ( hit_below(a,b) )
			{
				//check the corners:
				//lower-left corner
				if ( hit_left(a,b) )
				{
					
					if ( b->Angular )
					{
						switch(b->Angle)
						{
							case DIR_RRU:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_RRD:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_RUU:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_RDD:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LLU:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LUU:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LLD:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LDD:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							
						}
					}
					else
					{
						switch(b->Dir)
						{
							case DIR_DOWNRIGHT:
							{
								b->Angular = false;
								b->Dir = DIR_UPLEFT;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_DOWNLEFT:
							{
								b->Angular = false;
								b->Dir = DIR_UPRIGHT;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_UPRIGHT:
							{
								b->Angular = false;
								b->Dir = DIR_DOWNLEFT;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_UPLEFT:
							{
								b->Angular = false;
								b->Dir = DIR_DOWNRIGHT;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}	
							
						}
					}
					
				}//end lower-left corner
				
				else if ( hit_right(a,b) )
					//lower-right corner
				{
					
					if ( b->Angular )
					{
						switch(b->Angle)
						{
							case DIR_LLU:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LLD:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_RUU:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_RDD:
							{
								b->Angular = false;
								b->Dir = DIR_LEFTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LLU:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LUU:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LLD:
							{
								b->Angular = false;
								b->Dir = DIR_LEFTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LDD:
							{
								b->Angular = false;
								b->Dir = DIR_LEFTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							
						}
					}
					else
					{
						switch(b->Dir)
						{
							case DIR_DOWNRIGHT:
							{
								b->Angular = false;
								b->Dir = DIR_UPLEFT;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_DOWNLEFT:
							{
								b->Angular = false;
								b->Dir = DIR_UPRIGHT;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_UPRIGHT:
							{
								b->Angular = false;
								b->Dir = DIR_DOWNLEFT;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_UPLEFT:
							{
								b->Angular = false;
								b->Dir = DIR_DOWNRIGHT;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}	
							
						}
					}
					
					
				}//end lower-right corner
				
				
				else
				{
				
					if ( b->Angular )
					{
						switch(b->Angle)
						{
							case DIR_LLU:
							{
								b->Angular = false;
								b->Dir = DIR_LEFTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LUU:
							{
								b->Angular = false;
								b->Dir = DIR_LEFTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_RRU:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_RUU:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							
						}
					}
					else
					{
						switch(b->Dir)
						{
							case DIR_RIGHTUP: { b->Dir = DIR_RIGHTDOWN; /*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ break; }
							case DIR_LEFTUP: { b->Dir = DIR_LEFTDOWN; /*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ break; }
							default: { TraceNL(); TraceS("Ball direction invalid for brick.take_hit(hit_below())."); 
								TraceNL(); TraceS("Ball Dir is: "); Trace(b->Dir); TraceNL();
								b->Dir = DIR_DOWN; /*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ break; }
						}
					}
				}
				/*
				switch ( v->Dir ) 
				{
					case DIR_UPRIGHT: { v->Dir = DIR_DOWNRIGHT; v->Step = bound(v->Step+2, 0, MAX_BALL_SPEED); break; }
					case DIR_UPLEFT: { v->Dir = DIR_DOWNLEFT; v->Step = bound(v->Step+2, 0, MAX_BALL_SPEED); break; }
					default: { TraceS("hit_below() found an illegal ball direction"); break; }
				}
				*/
				if ( a->HP <= 0 ) 
				{ 
					//TraceS("Brick is dead. "); TraceNL();
					//TraceS("a->Misc[NPCM_AWARDED_POINTS] is: "); Trace(a->Misc[NPCM_AWARDED_POINTS]); TraceNL();
					if ( !a->Misc[NPCM_AWARDED_POINTS] )
					{
						//TraceS("Can award points!"); TraceNL();
						a->Misc[18] = 1;
						//TraceS("The points for this brick are: "); Trace(a->Attributes[NPC_ATTRIB_POINTS]); TraceNL();
						Game->Counter[CR_SCRIPT1] += a->Attributes[NPC_ATTRIB_POINTS];
						drop_capsule(a); 
					}
				}
			}
			
			else if ( hit_above(a,b) )
			{
				//upper-left corner
				if ( hit_left(a,b) )
				{
					
					if ( b->Angular )
					{
						switch(b->Angle)
						{
							case DIR_RRD:
							{
								b->Angular = false;
								b->Dir = DIR_LEFTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_RDD:
							{
								b->Angular = false;
								b->Dir = DIR_LEFTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_RUU:
							{
								b->Angular = false;
								b->Dir = DIR_LEFTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_RDD:
							{
								b->Angular = false;
								b->Dir = DIR_LEFTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LLU:
							{
								b->Angular = false;
								b->Dir = DIR_LEFTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LUU:
							{
								b->Angular = false;
								b->Dir = DIR_LEFTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LLD:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LDD:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							
						}
					}
					else
					{
						switch(b->Dir)
						{
							case DIR_DOWNRIGHT:
							{
								b->Angular = false;
								b->Dir = DIR_UPLEFT;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_DOWNLEFT:
							{
								b->Angular = false;
								b->Dir = DIR_UPRIGHT;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_UPRIGHT:
							{
								b->Angular = false;
								b->Dir = DIR_DOWNLEFT;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_UPLEFT:
							{
								b->Angular = false;
								b->Dir = DIR_DOWNRIGHT;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							
						}
					}
					
				}//end upper-left corner
				
				//upper-right corner
				else if ( hit_right(a,b) )
				{
					
					if ( b->Angular )
					{
						switch(b->Angle)
						{
							case DIR_RRD:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_RDD:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_RUU:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_RDD:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LLU:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LUU:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LLD:
							{
								b->Angular = false;
								b->Dir = DIR_LEFTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LDD:
							{
								b->Angular = false;
								b->Dir = DIR_LEFTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							
						}
					}
					else
					{
						switch(b->Dir)
						{
							case DIR_DOWNRIGHT:
							{
								b->Angular = false;
								b->Dir = DIR_UPLEFT;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_DOWNLEFT:
							{
								b->Angular = false;
								b->Dir = DIR_UPRIGHT;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_UPRIGHT:
							{
								b->Angular = false;
								b->Dir = DIR_DOWNLEFT;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_UPLEFT:
							{
								b->Angular = false;
								b->Dir = DIR_DOWNRIGHT;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							
						}
					}
					
				}
				//end upper-right corners
				
				//
				else
				{
					if ( b->Angular )
					{
						switch(b->Angle)
						{
							case DIR_LLD:
							{
								b->Angular = false;
								b->Dir = DIR_LEFTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LDD:
							{
								b->Angular = false;
								b->Dir = DIR_LEFTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_RRD:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_RDD:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							
						}
					}
					else
					{
						switch(b->Dir)
						{
							case DIR_DOWNLEFT: { b->Dir = DIR_UPLEFT; b->Step = bound(b->Step+2, 0, MAX_BALL_SPEED); break; }
							case DIR_DOWNRIGHT: { b	->Dir = DIR_UPRIGHT; b->Step = bound(b->Step+2, 0, MAX_BALL_SPEED); break; } 
							default: { 
								TraceNL(); TraceS("Ball direction invalid for brick.take_hit(hit_above())."); 
								TraceNL(); TraceS("Ball Dir is: "); Trace(b->Dir); TraceNL();
								
								b->Dir = DIR_DOWN; /*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ break; }
						}
					}
					
					if ( a->HP <= 0 ) 
					{ 
						if ( !a->Misc[NPCM_AWARDED_POINTS] )
						{
							a->Misc[NPCM_AWARDED_POINTS] = 1;
							Game->Counter[CR_SCRIPT1] += a->Attributes[NPC_ATTRIB_POINTS];
							drop_capsule(a);
						}
					}
				}
			}
			
			else if ( hit_left(a,b) )
			{
				//upper corners
				
				//upper-left corner
				if ( hit_above(a,b) )
				{
					
					if ( b->Angular )
					{
						switch(b->Angle)
						{
							case DIR_RRD:
							{
								b->Angular = false;
								b->Dir = DIR_LEFTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_RDD:
							{
								b->Angular = false;
								b->Dir = DIR_LEFTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_RUU:
							{
								b->Angular = false;
								b->Dir = DIR_LEFTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_RDD:
							{
								b->Angular = false;
								b->Dir = DIR_LEFTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LLU:
							{
								b->Angular = false;
								b->Dir = DIR_LEFTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LUU:
							{
								b->Angular = false;
								b->Dir = DIR_LEFTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LLD:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LDD:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							
						}
					}
					else
					{
						switch(b->Dir)
						{
							case DIR_DOWNRIGHT:
							{
								b->Angular = false;
								b->Dir = DIR_UPLEFT;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_DOWNLEFT:
							{
								b->Angular = false;
								b->Dir = DIR_UPRIGHT;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_UPRIGHT:
							{
								b->Angular = false;
								b->Dir = DIR_DOWNLEFT;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_UPLEFT:
							{
								b->Angular = false;
								b->Dir = DIR_DOWNRIGHT;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							
						}
					}
					
				}//end upper-left corner
				
				else if ( hit_below(a,b) )
					//lower-left corner
				{
					
					if ( b->Angular )
					{
						switch(b->Angle)
						{
							case DIR_RRU:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_RRD:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_RUU:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_RDD:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LLU:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LUU:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LLD:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LDD:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							
						}
					}
					else
					{
						switch(b->Dir)
						{
							case DIR_DOWNRIGHT:
							{
								b->Angular = false;
								b->Dir = DIR_UPLEFT;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_DOWNLEFT:
							{
								b->Angular = false;
								b->Dir = DIR_UPRIGHT;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_UPRIGHT:
							{
								b->Angular = false;
								b->Dir = DIR_DOWNLEFT;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_UPLEFT:
							{
								b->Angular = false;
								b->Dir = DIR_DOWNRIGHT;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}	
							
						}
					}
									
				}//end lower-left corner
				
				else
				{
					if ( b->Angular )
					{
						switch(b->Angle)
						{
							case DIR_LLU:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LUU:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LLD:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LDD:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							
						}
					}
					else
					{
						switch(b->Dir)
						{
							case DIR_RIGHTDOWN: { b->Dir = DIR_LEFTDOWN; /*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ break; }
							case DIR_RIGHTUP: { b->Dir = DIR_LEFTUP; /*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ break; }
							default: { 
								TraceNL(); TraceS("Ball direction invalid for brick.take_hit(hit(left))."); 
								TraceNL(); TraceS("Ball Dir is: "); Trace(b->Dir); TraceNL();
								b->Dir = DIR_DOWN; /*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ break; }
						}
					}
					/*
					switch ( v->Dir ) 
					{
						case DIR_UPRIGHT: { v->Dir = DIR_UPLEFT; v->Step = bound(v->Step+2, 0, MAX_BALL_SPEED); break; }
						case DIR_DOWNRIGHT: { v->Dir = DIR_DOWNLEFT; v->Step = bound(v->Step+2, 0, MAX_BALL_SPEED);  break; }
						default: { TraceS("hit_left() found an illegal ball direction"); break; }
					}
					*/
				}
				if ( a->HP <= 0 ) 
				{ 
					if ( !a->Misc[NPCM_AWARDED_POINTS] )
					{
						a->Misc[NPCM_AWARDED_POINTS] = 1;
						Game->Counter[CR_SCRIPT1] += a->Attributes[NPC_ATTRIB_POINTS];
						drop_capsule(a);
					}
				}
			}
			else if ( hit_right(a,b) )
			{
				//lower-right corners
				if ( hit_below(a,b) )
					//lower-right corner
				{
					
					if ( b->Angular )
					{
						switch(b->Angle)
						{
							case DIR_LLU:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LLD:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_RUU:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_RDD:
							{
								b->Angular = false;
								b->Dir = DIR_LEFTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LLU:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LUU:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LLD:
							{
								b->Angular = false;
								b->Dir = DIR_LEFTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LDD:
							{
								b->Angular = false;
								b->Dir = DIR_LEFTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							
						}
					}
					else
					{
						switch(b->Dir)
						{
							case DIR_DOWNRIGHT:
							{
								b->Angular = false;
								b->Dir = DIR_UPLEFT;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_DOWNLEFT:
							{
								b->Angular = false;
								b->Dir = DIR_UPRIGHT;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_UPRIGHT:
							{
								b->Angular = false;
								b->Dir = DIR_DOWNLEFT;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_UPLEFT:
							{
								b->Angular = false;
								b->Dir = DIR_DOWNRIGHT;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}	
							
						}
					}
					
				}//end lower-right corner
				
				//upper-right corner
				else if ( hit_above(a,b) )
				{
					
					if ( b->Angular )
					{
						switch(b->Angle)
						{
							case DIR_RRD:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_RDD:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_RUU:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_RDD:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LLU:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LUU:
							{
								b->Angular = false;
								b->Dir = DIR_RIGHTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LLD:
							{
								b->Angular = false;
								b->Dir = DIR_LEFTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_LDD:
							{
								b->Angular = false;
								b->Dir = DIR_LEFTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							
						}
					}
					else
					{
						switch(b->Dir)
						{
							case DIR_DOWNRIGHT:
							{
								b->Angular = false;
								b->Dir = DIR_UPLEFT;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_DOWNLEFT:
							{
								b->Angular = false;
								b->Dir = DIR_UPRIGHT;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_UPRIGHT:
							{
								b->Angular = false;
								b->Dir = DIR_DOWNLEFT;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_UPLEFT:
							{
								b->Angular = false;
								b->Dir = DIR_DOWNRIGHT;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							
						}
					}
				}
				//end upper-right corners
				else
				{
					if ( b->Angular )
					{
						switch(b->Angle)
						{
							case DIR_RRD:
							{
								b->Angular = false;
								b->Dir = DIR_LEFTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_RDD:
							{
								b->Angular = false;
								b->Dir = DIR_LEFTDOWN;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_RRU:
							{
								b->Angular = false;
								b->Dir = DIR_LEFTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							case DIR_RUU:
							{
								b->Angular = false;
								b->Dir = DIR_LEFTUP;
								/*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ 
								break;
							}
							
						}
					}
					else
					{
						switch(b->Dir)
						{
							case DIR_LEFTDOWN: { b->Dir = DIR_RIGHTDOWN; /*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ break; }
							case DIR_LEFTUP: { b->Dir = DIR_RIGHTUP; /*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ break; }
							default: { 
								TraceNL(); TraceS("Ball direction invalid for brick.take_hit(hit_right())."); 
								TraceNL(); TraceS("Ball Dir is: "); Trace(b->Dir); TraceNL();
								b->Dir = DIR_DOWN; /*b->Step = bound(b->Step+1, 0, MAX_BALL_SPEED);*/ break; }
						}
					}
					/*
					switch ( v->Dir ) 
					{
						case DIR_UPLEFT: { v->Dir = DIR_UPRIGHT; v->Step = bound(v->Step+2, 0, MAX_BALL_SPEED); break; }
						case DIR_DOWNLEFT: { v->Dir = DIR_DOWNRIGHT; v->Step = bound(v->Step+2, 0, MAX_BALL_SPEED); break; }
						default: { TraceS("hit_below() found an illegal ball direction"); break; }
					}
					*/
					if ( a->HP <= 0 ) 
					{ 
						if ( !a->Misc[NPCM_AWARDED_POINTS] )
						{
							a->Misc[NPCM_AWARDED_POINTS] = 1;
							Game->Counter[CR_SCRIPT1] += a->Attributes[NPC_ATTRIB_POINTS];
							drop_capsule(a);
						}
					}
				}
			}
			
			else
			{
				TraceS("brick.hit() returned true, but couldn't determine a valid ball location!");
				return;
			}
		}
					
			
	}
	//turns layer objects into npc bricks. 
	void setup()
	{
		int tempenem; npc bricks[1024]; int temp;
		for ( int q = 0; q < 176; ++q )
		{
			//bricks on layer 1
			//Trace(GetLayerComboD(1,q));
			//while(!Input->Press[CB_A]) Waitframe();
			tempenem = brick_to_npc(GetLayerComboD(1,q),false);
			//TraceS("tempenem is: "); Trace(tempenem);
			//while(!Input->Press[CB_A]) Waitframe();
			if ( tempenem ) 
			{
				bricks[temp] = Screen->CreateNPC(tempenem); 
				//TraceS("Created npc: "); Trace(tempenem);
				bricks[temp]->X = ComboX(q); 
				bricks[temp]->Y = ComboY(q);
				//TraceS("Brick defence is: "); Trace(bricks[temp]->Defense[20]);
				tempenem = 0; ++temp;
				
			}
			//bricks on layer 2, Y+8px
			tempenem = brick_to_npc(GetLayerComboD(2,q),true);
			//Trace(tempenem);
			if ( tempenem ) 
			{
				bricks[temp] = Screen->CreateNPC(tempenem); 
				//TraceS("Created npc: "); Trace(tempenem);
				bricks[temp]->X = ComboX(q); 
				bricks[temp]->Y = ComboY(q)+8;
				//TraceS("Brick defence is: "); Trace(bricks[temp]->Defense[20]);
				tempenem = 0; ++temp;
			}
		}
		
	}
	void clear_combos()
	{
		templayer[0] = Screen->LayerOpacity[0];
		templayer[1] = Screen->LayerOpacity[1];
		templayer[2] = Screen->LayerMap[0];
		templayer[3] = Screen->LayerMap[1];
		Screen->LayerOpacity[0] = 0;
		Screen->LayerOpacity[1] = 0;
		Screen->LayerMap[0] = 0;
		Screen->LayerMap[1] = 0;
	}
	
	int brick_to_npc(int combo_id, bool layer2)
	{
		
		if ( !layer2 ) 
		{
			int brick_to_enemy[BRICK_MAX*2] =
			{ 	CMB_BRICK_RED, CMB_BRICK_WHITE, CMB_BRICK_BLUE, CMB_BRICK_ORANGE, CMB_BRICK_TEAL, 
				CMB_BRICK_VIOLET, CMB_BRICK_GREEN, CMB_BRICK_YELLOW, CMB_BRICK_SILVER1, CMB_BRICK_SILVER2,
				CMB_BRICK_SILVER3, CMB_BRICK_SILVER4, CMB_BRICK_GOLD, 

				NPC_BRICK_RED, NPC_BRICK_WHITE, NPC_BRICK_BLUE, NPC_BRICK_ORANGE, NPC_BRICK_TEAL,
				NPC_BRICK_VIOLET, NPC_BRICK_GREEN, NPC_BRICK_YELLOW, NPC_BRICK_SILVER1, NPC_BRICK_SILVER2,
				NPC_BRICK_SILVER3, NPC_BRICK_SILVER4, NPC_BRICK_GOLD 
			};
			for ( int q = 0; q < BRICK_MAX; ++q ) 
			{ 
				if ( brick_to_enemy[q] == combo_id ) 
				{
					//	TraceS("brick_to_npc : combo input: "); Trace(combo_id);
					//TraceS("brick_to_npc : enemy output: "); Trace(brick_to_enemy[BRICK_MAX+q]);
					
					return ( brick_to_enemy[BRICK_MAX+q-1] );
				}
			}
		}
		else
		{
			int brick_to_enemy2[BRICK_MAX*2] =
			{ 	CMB_BRICK_RED_LOW, CMB_BRICK_WHITE_LOW, CMB_BRICK_BLUE_LOW, CMB_BRICK_ORANGE_LOW, CMB_BRICK_TEAL_LOW, 
				CMB_BRICK_VIOLET_LOW, CMB_BRICK_GREEN_LOW, CMB_BRICK_YELLOW_LOW, CMB_BRICK_SILVER1_LOW, CMB_BRICK_SILVER2_LOW,
				CMB_BRICK_SILVER3_LOW, CMB_BRICK_SILVER4_LOW, CMB_BRICK_GOLD_LOW, 

				NPC_BRICK_RED, NPC_BRICK_WHITE, NPC_BRICK_BLUE, NPC_BRICK_ORANGE, NPC_BRICK_TEAL,
				NPC_BRICK_VIOLET, NPC_BRICK_GREEN, NPC_BRICK_YELLOW, NPC_BRICK_SILVER1, NPC_BRICK_SILVER2,
				NPC_BRICK_SILVER3, NPC_BRICK_SILVER4, NPC_BRICK_GOLD 
			};
			for ( int q = 0; q < BRICK_MAX; ++q ) 
			{ 
				if ( brick_to_enemy2[q] == combo_id ) 
				{
					//TraceS("brick_to_npc : combo input: "); Trace(combo_id);
					//TraceS("brick_to_npc : enemy output: "); Trace(brick_to_enemy2[BRICK_MAX+q-1]);
					return ( brick_to_enemy2[BRICK_MAX+q-1] );
				}
			}
		}
		return 0; //error
	}
}

//The global script arkanoid calls the run function of this script to replace its run on GameOver
//This is a HACK for the 2018 PureZC Fall Expo demo.
ffc script gameover
{
	void run()
	{
		TraceS("Game Over");
		/*
		if ( Game->Counter[CR_HIGH_SCORE] < Game->Counter[CR_SCORE] ) 
		{
			TraceS("Saving High Score");
			Game->Counter[CR_HIGH_SCORE] = Game->Counter[CR_SCORE];
			Game->Counter[CR_SCORE] = 0;
			Game->Save();
		}
		*/
		while (1) //Game Over
		{
			if ( !(GAME[GAME_MISC_FLAGS]&GMFS_PLAYED_GAME_OVER_MUSIC) )
			{
				GAME[GAME_MISC_FLAGS]|=GMFS_PLAYED_GAME_OVER_MUSIC;
				//Play Game over MIDI
				Game->PlayMIDI(1);
				arkanoid.clearscore();
				arkanoid.update_high_score_display();
			}
			
			//Screen->DrawString(6, arkanoid.STAGE_X, 80, FONT_LISA, 0x08, 0x00, 0, "  GAME OVER  ", 128);
			Screen->DrawString(6, 111-13-1, 96-1, FONT_MANA, 0x95, -1, 0, "GAME OVER", 128);
			Screen->DrawString(6, 111-13+1, 96+1, FONT_MANA, 0x95, -1, 0, "GAME OVER", 128);
			Screen->DrawString(6, 111-13, 96, FONT_MANA, 0x08, -1, 0, "GAME OVER", 128);
			
			//Waitdraw(); 
			Waitframe();
		}
		//We should never reach here. 
	}
}

global script onExit
{
	void run()
	{
		Screen->LayerOpacity[0] = templayer[0];
		Screen->LayerOpacity[1] = templayer[1];
		Screen->LayerMap[0] = templayer[2];
		Screen->LayerMap[1] = templayer[3];
		newstage = true;
		//Hack for 2018 PureZC Fall Expo
		/*
		if ( Game->Counter[CR_HIGH_SCORE] < Game->Counter[CR_SCORE] ) 
		{
			Game->Counter[CR_HIGH_SCORE] = Game->Counter[CR_SCORE];
			Game->Save();
		}
		*/
		arkanoid.clearscore();
		arkanoid.update_high_score_display();
		//vaus->Misc[MISC_DEAD] = 0;

	}
}	

global script init
{
	void run()
	{
		quit = 0;
		frame = -1;
		cur_stage = 1;
		laser_cooldown = 0;
		caught_relative_ball_vaus_x = 0;
		Game->Counter[CR_LIVES] = STARTING_LIVES;
		Link->CollDetection = false;
		Link->DrawYOffset = -32768;
	}
}

global script Init
{
	void run()
	{
		quit = 0;
		frame = -1;
		cur_stage = 1;
		laser_cooldown = 0;
		caught_relative_ball_vaus_x= 0;
		Game->Counter[CR_LIVES] = STARTING_LIVES;
		Link->CollDetection = false;
		Link->DrawYOffset = -32768;
	}
}

global script onContinue
{
	void run()
	{
		quit = 0;
		frame = -1;
		laser_cooldown = 0;
		caught_relative_ball_vaus_x = 0;
		//cur_stage = 1;
		//ffc vaus = Screen->LoadFFC(FFC_VAUS);
		//paddle.setup(vaus);
		Game->Counter[CR_LIVES] = STARTING_LIVES;
		//Game->Counter[CR_HIGHSCORE] = high_score;
		Game->Counter[CR_SCORE] = 0;
		Link->Invisible = true; 
		Link->CollDetection = false;
		Link->DrawYOffset = -32768;
	}
}

/////////////////////////
/// DEAD Script Bugs: ///
/////////////////////////

/*
//FIXED with ball.clamp(). 
//There's a step speed at which the ball phases *through* the vaus! 
					//Perhaps we should make the vaus an enemy, too? An invisible enemy to act as a failsafe?
					//if the ball hits the vaus, it bounces.
					//Or just scrap the vaus ffc, and use an npc for it in general?

//BALL NEEDS TO HAVE A 6PX BY 6PX HITBOX, AND THUS A HIT OFFSET OF -1,-1, so that ->HitBy[] returns when the ball hits a block, and
//the ball is still not yet inside that object
*/

//////////////////////
/// DEAD ZC Issues //////////////////////////////////////////////////////////////////////////////
/// I fixed these issues, in specific Alphas of ZC 2.55, noted below for historical purposes: ///
/////////////////////////////////////////////////////////////////////////////////////////////////


/*
FIXED in Alpha 32
I forgot to expand ->Misc[] in sprite.cpp, which should be fixed int he source for Alpha 32. 
	This meant that r/w to ptr->Misc[>15] would use invalid data, or overwrite other data. bad, bad, bad. 
	
	FIXED in Alpha 32
	//Note: We also need to store the UID of each ball, as HitBy[] works from the UID, not the pointer. 
	
*/

ffc script TestGetPixel
{
	void run()
	{
		while(1)
		{
			
			if ( Input->Key[KEY_8] )
			{
				bitmap bmp = Game->LoadBitmapID(RT_SCREEN);
				int col[20];
				for ( int q = 0; q < 20; ++ q )
				{
					col[q] = bmp->GetPixel(40, 0+q*8); 
				}
				TraceNL();
				for ( int q = 0; q < 20; ++q ) 
				{
					TraceS("Bitmap col: "); Trace(col[q]);
				}
				
				Screen->SetRenderTarget(2);
				Screen->Rectangle(0, 0, 0, 256, 256, 0x55, 100, 0, 0, 0, true, 128);
				Screen->SetRenderTarget(RT_SCREEN);
				Waitframe();
				
				bitmap offscreen = Game->LoadBitmapID(2);
				int col2[20];
				for ( int q = 0; q < 20; ++ q )
				{
					col2[q] = offscreen->GetPixel(10+q*8,10+q*8); 
				}
				TraceNL();
				for ( int q = 0; q < 20; ++q ) 
				{
					TraceS("Offscreen Bitmap col: "); Trace(col2[q]);
				}
			}	
			Waitframe();
		}
	}
}


/* Catch Mechanics
	
	
	1. Each capsule must have lweapon b
	2. Add ball->Misc[CAUGHT]
	3. Add ball->Misc[OLDSTEP]


	4. In ball.check_hitvaus 
		if it hits the vaus, check: if ( catch == cancatch )
		then
			if !launched
			b->Misc[CAUGHT] = 1
			b->Misc[OLDSTEP] - b->Step
			b->Step = 0
			launched = false
    
	5. In movevaus, 
		if !launched
			if b->Misc[CAUGHT]
			when launching
        
			b->Step = b->Misc[OLDSTEP]
			b->Misc[CAUGHT] = 0
			when launched = false,
    
        6. If a powerup --other than another catch-- hits the vaus, restore b->Step from Misc[OLDSTEP]
		!! This is why powerups all need a param of lweapon b

	7. Store the difference between v>X and b->X when catching, and save it in b->Misc[CAUGHT_dist], then
		when !launched, instead of the normal position on the vaus, reposition the ball, using this value. 

	/*



	/*Capsule Rewrite


	1. Use itemdata->attribs for caps type
	2. Use itemdata->sprites for the sprite to use on an eweapon
	3. If the item appears, spawn an eweapon in its place and remove the item
	4. Apply the itemdata->id to ew->Misc[] and read it in place of the item id
		4(a). 	eweapons wouldnt need to be manually moved:
			Just set their dir = down and a step speed
		4(b).	Blocks can use item dropsets for pills to drop
	5. Set the default item drawyoffset to offscreen, so that eweapon spawns aren't visible
		5(a).	Now we can rid ourselves of the script draws and the loops to move everything
	6. Perform removal of eweapons every 10 frames with capsule.cleanup() called if !(frame%10)
	*/