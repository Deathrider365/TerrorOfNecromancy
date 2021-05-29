///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~~~~~~~~~Consts / Typedefs / Enums~~~~~~~~~~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////


//~~~~~Global Variables~~~~~//
//start
bool disableTrans;

bool levelEntries[512];

int onContHP = 0;
int onContMP = 0;
int gameframe = 0;
int lastPal = -1;

int statuses[NUM_STATUSES];
bitmap status_bmp;
bitmap waterfall_bmp;
bitmap darkness_bmp;
bitmap ohead_bmps[7];
StatusPos statusPos = SP_TOP_RIGHT;

//end

//~~~~~Typedefs~~~~~//
//start
typedef const int DEFINE;
typedef const int CONFIG;
typedef const bool CONFIGB;
typedef const Color COLOR;
//end

//~~~~~Magnitude~~~~~//
//start
CONFIG MAX_USED_DMAP = 511;

CONFIG SUB_COOLDOWN_TILE_WIDTH = 9;

CONFIG WIDTH_EZB_DEATHEXPLOSION = 2; //Tile width for death explosions
CONFIG HEIGHT_EZB_DEATHEXPLOSION = 2; //Tile height for death explosions

DEFINE STATUS_HEIGHT = 8;
DEFINE STATUS_WIDTH = 12;

//end

//~~~~~Color~~~~~//
//start
COLOR STATUS_TEXT_COLOR = C_WHITE;



//end

//~~~~~CSet~~~~~//
//start
CONFIG CSET_LEGIONNAIRE_RING = 5;


//end

//~~~~~Item Classes~~~~~//
//start
DEFINE IC_GALEBRANG = 256;


//end

//~~~~~FFC~~~~~//
//start
CONFIG COMPASS_BEEP = 69; 			//Set this to the SFX id you want to hear when you have the compass
CONFIG COMPASS_SFX = 20; 			//Set this to the SFX id you want to hear when you have the compass

CONFIG CB_SIGNPOST = CB_A;			//Button to press to read a sign

CONFIG SFX_SWITCH_PRESS = 0; 		//SFX when a switch is pressed
CONFIG SFX_SWITCH_RELEASE = 0; 		//SFX when a switch is released
CONFIG SFX_SWITCH_ERROR = 62; 		//SFX when the wrong switch is pressed

CONFIG ICE_BLOCK_SCRIPT = 1; 		// Slot number that the ice_block script is assigned to
CONFIG ICE_BLOCK_SENSITIVITY = 8; 	// Number of frames the blocks need to be pushed against to begin moving

CONFIG MSG_LINK_BEATEN = 23;

CONFIGB DEBUG = true;
//end

//~~~~~Itemdata~~~~~//
//start
CONFIG SUB_B_X = 94;
CONFIG SUB_B_Y = -10;
CONFIG SUB_A_X = 118;
CONFIG SUB_A_Y = -10;


//end

//~~~~~LWeapon~~~~~//
//start
CONFIG LW_EZB_DEATHEXPLOSION = 40; //LWeapon type used for death explosions. Script 10 by default


//end

//~~~~~SFX~~~~~//
//start
CONFIG SFX_SUPER_JUMP = 0;
CONFIG SFX_SLAM = 0;
CONFIG SFX_SIZZLE = 128;
CONFIG SFX_ROCKINGSHIP = 9;
//end

//~~~~~Sprite ~~~~~//
//start
CONFIG SPR_POISON_CLOUD = 111;
CONFIG SPR_FOOTSTEP = 113;

CONFIG SPR_EZB_DEATHEXPLOSION = 0; //Sprite to use for death explosions (0 for ZC default)
CONFIG EZB_DEATH_FLASH = 1; //Set to 1 to make the enemy flash during death animations

//end

//~~~~~Combo~~~~~//
//start
CONFIG COMBO_INVIS = 1;

//end

//~~~~~Tile~~~~~//
//start
CONFIG TILE_INVIS = 196;
CONFIG SUB_COOLDOWN_TILE = 29281;
CONFIG TILE_LEGIONNAIRE_RING = 42700;

CONFIG TILE_ATTACK_BOOST = 38901;
CONFIG TILE_DEFENSE_BOOST = 38902;


//end

//~~~~~Midi~~~~~//
//start
CONFIG MIDI_GAMEOVER = 8;

//end

//~~~~~Counters~~~~~//
//start
CONFIG CR_LEGIONNAIRE_RING = CR_SCRIPT1;
CONFIG CR_HEARTPIECES = CR_SCRIPT2;

//end

//~~~~~Fonts~~~~~//
//start
CONFIG STATUS_FONT = FONT_Z3SMALL;

//end

//~~~~~Gale Boomerang~~~~~//
//start
CONFIG CF_BRANG_BOUNCE = CF_SCRIPT20;

CONFIG DEFAULT_SPRITE = 5;
CONFIG DEFAULT_WIND_SPRITE = 13;

CONFIG DEFAULT_SFX = 63;

CONFIG SFX_DELAY = 5;

DEFINE ROTATION_RATE = 40; //degrees

CONFIGB FORCE_QRS_TO_NEEDED_STATE = true;
CONFIGB BOUNCE_OFF_FLAGS_ON_LAYERS_1_AND_2 = true;
CONFIGB STOPS_WHEN_GRABBING_ITEMS = true;

//end


//~~~~~ActiveSubscreen~~~~~//
//start

// Globals start
int subscr_y_offset = -224;

int scrollingOffset;

int itemIDs[] = {IC_SWORD, 		IC_BRANG, 			IC_BOMB, 		IC_ARROW, 
				 IC_CANDLE, 	IC_WHISTLE, 		IC_POTION, 		IC_BAIT,
                 IC_SBOMB, 		IC_HOOKSHOT, 		IC_HAMMER, 		IC_WAND, 
				 IC_LENS, 		IC_WPN_SCRIPT_02, 	IC_CBYRNA, 		-1,
				 IC_DINSFIRE, 	IC_FARORESWIND, 	IC_NAYRUSLOVE, 	IC_CUSTOM4, 
				 IC_CUSTOM1, 	IC_CUSTOM3, 		IC_CUSTOM5, 	IC_CUSTOM6};
				  
int itemLocsX[] = {166, 188, 210, 232,
					166, 188, 210, 232,
					166, 188, 210, 232,
					166, 188, 210, 232,
					166, 188, 210, 232,
					166, 188, 210, 232};
				  
int itemLocsY[] = {32,	32, 32, 32,
				    54,	54, 54, 54,
				    76,	76, 76, 76,
				    98, 98, 98, 98,
					120, 120, 120, 120,
					142, 142, 142, 142};
					
int triforceFrames[] = {TILE_COURAGE_FRAME, TILE_POWER_FRAME, TILE_WISDOM_FRAME, TILE_DEATH_FRAME};

int courageShards[] = {COURAGE_SHARD1, COURAGE_SHARD2, COURAGE_SHARD3, COURAGE_SHARD4};
int powerShards[] = {POWER_SHARD1, POWER_SHARD2, POWER_SHARD3, POWER_SHARD4};
int wisdomShards[] = {WISDOM_SHARD1, WISDOM_SHARD2, WISDOM_SHARD3, WISDOM_SHARD4};
int deathShards[] = {DEATH_SHARD1, DEATH_SHARD2, DEATH_SHARD3, DEATH_SHARD4};

int amountOfShardsToDraw = 0;

int asubscr_pos = 0;
int currTriforceIndex = 0;

int amountOfCourageTriforceShards = 0;
int amountOfPowerTriforceShards = 0;
int amountOfWisdomTriforceShards = 0;
int amountOfDeathTriforceShards = 0;

int numHeartPieces = 0;

bool subscr_open = false;
//end

// Consts start
DEFINE NUM_SUBSCR_SEL_ITEMS = 24;
DEFINE NUM_SUBSCR_INAC_ITEMS = 14;

CONFIG BG_MAP = 6;
CONFIG BG_SCREEN = 0x0E;

CONFIG SCROLL_SPEED = 4;

CONFIG CURSOR_MOVEMENT_SFX = 5;
CONFIG TRIFORCE_CYCLE_SFX = 124;
CONFIG ITEM_SELECTION_SFX = 66;

CONFIG SUBSCR_COUNTER_FONT = FONT_LA;
CONFIG SUBSCR_DMAPTITLE_FONT = FONT_Z3SMALL;


CONFIGB CNTR_USES_0 = true;

CONFIG MAGIC_METER_TILE_WIDTH = 5;
CONFIG MAGIC_METER_PIX_WIDTH = 63;//55; //-1 from actual
CONFIG MAGIC_METER_PIX_HEIGHT = 1; //-1 from actual
CONFIG MAGIC_METER_FILL_XOFF = 11;
CONFIG MAGIC_METER_FILL_YOFF = 3;

COLOR C_SUBSCR_COUNTER_TEXT = C_WHITE;
COLOR C_SUBSCR_COUNTER_BG = C_TRANSBG;
COLOR C_MAGIC_METER_FILL = C_GREEN;
COLOR BG_COLOR = C_DGRAY;
COLOR C_MINIMAP_EXPLORED = C_WHITE;
COLOR C_MINIMAP_ROOM = C_BLACK;
COLOR C_MINIMAP_LINK = C_DEEPBLUE;//C_DARKGREEN;
COLOR C_MINIMAP_COMPASS = C_RED;
COLOR C_MINIMAP_COMPASS_DEFEATED = C_DARKGREEN;

CONFIG TILE_SUBSCR_BUTTON_FRAME = 1378;
CONFIG TILE_HEARTS = 32420;
CONFIG TILE_MAGIC_METER = 32527;//32520;
CONFIG TILE_MINIMAP_OW_BG = 1220;
CONFIG TILE_MINIMAP_DNGN_BG = 42400;

CONFIG TILE_ZERO_PIECES = 29420;
CONFIG TILE_COURAGE_FRAME = 320;
CONFIG TILE_POWER_FRAME = 326;
CONFIG TILE_WISDOM_FRAME = 380;
CONFIG TILE_DEATH_FRAME = 386;
CONFIG COURAGE_SHARD1 = 274;
CONFIG COURAGE_SHARD2 = 334;
CONFIG COURAGE_SHARD3 = 394;
CONFIG COURAGE_SHARD4 = 454;
CONFIG WISDOM_SHARD1 = 702;
CONFIG WISDOM_SHARD2 = 522;
CONFIG WISDOM_SHARD3 = 582;
CONFIG WISDOM_SHARD4 = 642;
CONFIG POWER_SHARD1 = 648;
CONFIG POWER_SHARD2 = 708;
CONFIG POWER_SHARD3 = 588;
CONFIG POWER_SHARD4 = 528;
CONFIG DEATH_SHARD1 = 654;
CONFIG DEATH_SHARD2 = 534;
CONFIG DEATH_SHARD3 = 714;
CONFIG DEATH_SHARD4 = 594;
//end
//end

//~~~~~PassiveSubscreen~~~~~//
//start
CONFIG BG_MAP1 = 6;
CONFIG BG_SCREEN1 = 0x0F;
CONFIG TILE_DIFF_NORMAL = 32081;
CONFIG TILE_DIFF_HARD = 32141;
CONFIG TILE_DIFF_PALADIN = 32142;

//end

//~~~~~Enums~~~~~//
//start
enum Color //start
{
	C_TRANSBG = -1,
	C_TRANS = 0x00,
	C_GREEN = 0x06,
	C_DARKGREEN = 0x07,
	C_BLACK = 0x08,
	C_RED = 0x04,
	C_WHITE = 0x0C,
	C_BLUE = 0x1F,
	C_GRAY = 0x29,
	C_LGRAY = 0x59,
	C_DGRAY = 0x5A,
	C_TAN = 0x75,
	C_SEABLUE = 0x76,
	C_DARKBLUE = 0x77,
	C_DEEPBLUE = 0x1F
}; //end

enum ScreenType //start
{
	DM_DUNGEON,
	DM_OVERWORLD,
	DM_INTERIOR,
	DM_BSOVERWORLD
}; //end

enum ArcingWeaponEffects //start
{
	AE_BOMB,
	AE_SMALLPOISONPOOL,
	AE_LARGEPOISONPOOL,
	AE_PROJECTILEWITHMOMENTUM,
	AE_DEBUG
}; //end

enum StatusPos //start
{
	SP_ABOVE_HEAD,
	SP_TOP_RIGHT
}; //end

enum Status //start
{
	ATTACK_BOOST, 
	DEFENSE_BOOST, 
	NUM_STATUSES
}; //end
//end





