//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~Consts / Typedefs / Enums~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

//~~~~~Typedefs~~~~~//
typedef const int DEFINE;
typedef const int CONFIG;
typedef const bool CONFIGB;
typedef const Color COLOR;

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
	C_LGRAY = 0x2B,
	C_DGRAY = 0x28,
	C_TAN = 0x75,
	C_SEABLUE = 0x76,
	C_DARKBLUE = 0x77
}; //end

enum ScreenType //start
{
	DM_DUNGEON,
	DM_OVERWORLD,
	DM_INTERIOR,
	DM_BSOVERWORLD
}; //end
