//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~Consts / Typedefs / Enums~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

//~~~~~Typedefs~~~~~//
typedef const int DEFINE;
typedef const int CONFIG;
typedef const bool CONFIGB;
typedef const Color COLOR;


//~~~~~SFX Constants~~~~~//
CONFIG SFX_SUPER_JUMP = 0;
CONFIG SFX_SLAM = 0;
CONFIG SFX_SIZZLE = 128;
CONFIG SFX_ROCKINGSHIP = 9;

//~~~~~Sprite Constants~~~~~//
CONFIG SPR_POISON_CLOUD = 111;

//~~~~~Midi Constants~~~~~//
CONFIG MIDI_GAMEOVER = 1;

//~~~~~Enums~~~~~//
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

enum ArcingWeaponEffects
{
	AE_BOMB,
	AE_SMALLPOISONPOOL,
	AE_LARGEPOISONPOOL,
	AE_PROJECTILEWITHMOMENTUM,
	AE_DEBUG
};






