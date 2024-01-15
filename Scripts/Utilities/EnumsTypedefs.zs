//~~~~~~~~~~~~~~~~~~~~~~~~~Consts / Typedefs / Enums~~~~~~~~~~~~~~~~~~~~~~~~~//

CONFIGB DEBUG = true; // TODO disable for final release

/*/~~~~~Global Variables~~~~~/*/
bool disableTrans;

bool levelEntries[512];

int onContHP = 0;
int onContMP = 0;
int gameframe = 0;
int lastPal = -1;

int statuses[NUM_STATUSES];
bitmap status_bmp;
bitmap waterfallBitmap;
bitmap darknessBitmap;
bitmap overheadBitmaps[7];
StatusPos statusPos = SP_TOP_RIGHT;

int stolenLinkItems[255];

/*/~~~~~Typedefs~~~~~/*/
typedef const int DEFINE;
typedef const int CONFIG;
typedef const bool CONFIGB;

/*/~~~~~Magnitude~~~~~/*/
CONFIG INTRO_SCENE_TRANSITION_MULT = 8;
CONFIG INTRO_SCENE_TRANSITION_FRAMES = 32;

CONFIG MAX_USED_DMAP = 511;

CONFIG SUB_COOLDOWN_TILE_WIDTH = 9;

CONFIG WIDTH_EZB_DEATHEXPLOSION = 2;  // Tile width for death explosions
CONFIG HEIGHT_EZB_DEATHEXPLOSION = 2; // Tile height for death explosions

DEFINE STATUS_WIDTH = 12;
DEFINE STATUS_HEIGHT = 8;

/*/~~~~~Color~~~~~/*/
Color STATUS_TEXT_COLOR = C_WHITE;

/*/~~~~~CSet~~~~~/*/
CONFIG CSET_CUMPURA_KEY = 8;
CONFIG CSET_GUARD_TOWER_KEY = 8;
CONFIG CSET_BATTLE_ARENA_TICKET = 0;
CONFIG CSET_ALLEGIANCE_SIGNET = 0;
CONFIG CSET_MYSTERIOUS_KEY = 8;
CONFIG CSET_MYSTERIOUS_COFFER = 5;
CONFIG CSET_REALLY_SMALL_KEY = 0;
CONFIG CSET_ENGAGEMENT_RING = 0;
CONFIG CSET_EBRIA_KEY = 10;

/*/~~~~~Item Classes~~~~~/*/
DEFINE IC_GALEBRANG = 256;
DEFINE IC_TRADING_SEQ = 91;

/*/~~~~~FFC~~~~~/*/
CONFIG COMPASS_BEEP = 69;
CONFIG COMPASS_SFX = 20;

CONFIG CB_SIGNPOST = CB_A;

CONFIG ICE_BLOCK_SCRIPT = 1;      // Slot number that the ice_block script is assigned to
CONFIG ICE_BLOCK_SENSITIVITY = 8; // Number of frames the blocks need to be pushed against to begin moving

CONFIG C_LENSBITMAPMARKER = 0xFE;

/*/~~~~~TriggerTypes~~~~~/*/
CONFIG TT_NO_TRIGGER_SET = 1;
CONFIG TT_SCREEND_SET = 2;
CONFIG TT_SCREEND_NOT_SET = 3;
CONFIG TT_SECRETS_TRIGGERED = 4;
CONFIG TT_SECRETS_NOT_TRIGGERED = 5;
CONFIG TT_ITEM_ACQUIRED = 6;
CONFIG TT_ITEM_NOT_ACQUIRED = 7;

/*/~~~~~Itemdata~~~~~/*/
CONFIG SUB_B_X = 94;
CONFIG SUB_B_Y = -10;
CONFIG SUB_A_X = 118;
CONFIG SUB_A_Y = -10;

/*/~~~~~Item~~~~~/*/
CONFIG ITEM_RUPEE_1 = 0;
CONFIG ITEM_RUPEE_5 = 1;
CONFIG ITEM_RUPEE_10 = 86;
CONFIG ITEM_RUPEE_20 = 38;
CONFIG ITEM_RUPEE_50 = 39;
CONFIG ITEM_RUPEE_100 = 87;
CONFIG ITEM_RUPEE_200 = 40;
CONFIG ITEM_HEART_1 = 2;
CONFIG ITEM_HEART_3 = 114;
CONFIG ITEM_HEART_5 = 165;
CONFIG ITEM_HEART_PIECE = 49;
CONFIG ITEM_HEART_CONTAINER = 28;
CONFIG ITEM_BOMB1 = 3;
CONFIG ITEM_BOMB2 = 48;
CONFIG ITEM_BOMB_AMMUNITION_1 = 77;
CONFIG ITEM_BOMB_AMMUNITION_4 = 78;
CONFIG ITEM_BOMB_AMMUNITION_8 = 79;
CONFIG ITEM_BOMB_AMMUNITION_30 = 80;
CONFIG ITEM_BOMB_BAG_SMALL = 81;
CONFIG ITEM_SWORD1 = 5;
CONFIG ITEM_SWORD2 = 6;
CONFIG ITEM_SWORD3 = 7;
CONFIG ITEM_SWORD4 = 36;
CONFIG ITEM_SWORD5 = 144;
CONFIG ITEM_SHIELD1 = 93;
CONFIG ITEM_SHIELD2 = 8;
CONFIG ITEM_SHIELD3 = 37;
CONFIG ITEM_SHIELD4 = 54;
CONFIG ITEM_CANDLE1 = 158;
CONFIG ITEM_CANDLE2 = 10;
CONFIG ITEM_CANDLE3 = 11;
CONFIG ITEM_CANDLE4 = 150;
CONFIG ITEM_BRANG1 = 23;
CONFIG ITEM_BRANG2 = 24;
CONFIG ITEM_BRANG3 = 35;
CONFIG ITEM_BRANG4 = 146;
CONFIG ITEM_ARROW1 = 13;
CONFIG ITEM_ARROW2 = 14;
CONFIG ITEM_ARROW3 = 57;
CONFIG ITEM_ARROW4 = 153;
CONFIG ITEM_ARROW5 = 154;
CONFIG ITEM_ARROW_AMMUNITION_1 = 70;
CONFIG ITEM_ARROW_AMMUNITION_5 = 71;
CONFIG ITEM_ARROW_AMMUNITION_10 = 72;
CONFIG ITEM_ARROW_AMMUNITION_30 = 73;
CONFIG ITEM_BOW1 = 15;
CONFIG ITEM_BOW2 = 68;
CONFIG ITEM_BOW3 = 151;
CONFIG ITEM_RING1 = 17;
CONFIG ITEM_RING2 = 18;
CONFIG ITEM_RING3 = 61;
CONFIG ITEM_RING4 = 145;
CONFIG ITEM_BRACELET1 = 107;
CONFIG ITEM_BRACELET2 = 19;
CONFIG ITEM_BRACELET3 = 56;
CONFIG ITEM_LANTERN1 = 208;
CONFIG ITEM_LANTERN2 = 198;
CONFIG ITEM_LANTERN3 = 200;
CONFIG ITEM_LANTERN4 = 201;
CONFIG ITEM_POTION1 = 29;
CONFIG ITEM_POTION2 = 30;
CONFIG ITEM_POTION3 = 123;
CONFIG ITEM_WAND1 = 25;
CONFIG ITEM_WAND2 = 152;
CONFIG ITEM_HAMMER1 = 147;
CONFIG ITEM_HAMMER2 = 148;
CONFIG ITEM_HAMMER3 = 149;
CONFIG ITEM_HAMMER_AND_QUAKE = 167;
CONFIG ITEM_FLIPPERS1 = 51;
CONFIG ITEM_FLIPPERS2 = 199;
CONFIG ITEM_HOOKSHOT1 = 52;
CONFIG ITEM_HOOKSHOT2 = 89;
CONFIG ITEM_WALLET1 = 41;
CONFIG ITEM_WALLET2 = 42;
CONFIG ITEM_OCARINA1 = 31;
CONFIG ITEM_OCARINA2 = 166;
CONFIG ITEM_RAFT = 26;
CONFIG ITEM_LADDER = 27;
CONFIG ITEM_MEDICINAL_HERB = 12;
CONFIG ITEM_SEARED_STEAK = 16;
CONFIG ITEM_MAP = 21;
CONFIG ITEM_COMPASS = 22;
CONFIG ITEM_LENS_OF_TRUTH = 53;
CONFIG ITEM_MAGIC_CONTAINER = 58;
CONFIG ITEM_MAGIC_JAR_SMALL = 59;
CONFIG ITEM_MAGIC_JAR_LARGE = 60;
CONFIG ITEM_DINS_FIRE = 64;
CONFIG ITEM_FARORES_WIND = 65;
CONFIG ITEM_NAYRUS_LOVE = 66;
CONFIG ITEM_KEY_BOSS = 67;
CONFIG ITEM_QUIVER1_SMALL = 74;
CONFIG ITEM_KEY_LEVEL = 84;
CONFIG ITEM_CANE1 = 88;
CONFIG ITEM_SCROLL_SPIN_ATTACK = 94;
CONFIG ITEM_SCROLL_CROSS_BEAMS = 95;
CONFIG ITEM_SCROLL_QUAKE_HAMMER = 96;
CONFIG ITEM_SCROLL_SUPER_QUAKE_HAMMER = 97;
CONFIG ITEM_SCROLL_HURRICANE_SPIN = 98;
CONFIG ITEM_WHISP_RING1 = 99;
CONFIG ITEM_WHISP_RING2 = 100;
CONFIG ITEM_CHARGE_RING1 = 101;
CONFIG ITEM_CHARGE_RING2 = 102;
CONFIG ITEM_SCROLL_PERIL_BEAM = 103;
CONFIG ITEM_WEALTH_MEDAL1 = 109;
CONFIG ITEM_WEALTH_MEDAL2 = 110;
CONFIG ITEM_WEALTH_MEDAL3 = 111;
CONFIG ITEM_HEART_RING1 = 112;
CONFIG ITEM_HEART_RING2 = 113;
CONFIG ITEM_MAGIC_RING1 = 115;
CONFIG ITEM_MAGIC_RING2 = 116;
CONFIG ITEM_MAGIC_RING3 = 117;
CONFIG ITEM_MAGIC_RING4 = 118;
CONFIG ITEM_PERIL_RING = 121;
CONFIG ITEM_WHIMSICAL_RING = 122;
CONFIG ITEM_HAERENS_GRACE = 124;
CONFIG ITEM_GANONS_RAGE = 125;
CONFIG ITEM_HEROS_ARMOR = 126;
CONFIG ITEM_SCHOLARS_MIND = 127;
CONFIG ITEM_DEATHS_AURA = 128;
CONFIG ITEM_CANE2 = 129;
CONFIG ITEM_LEGIONNAIRE_RING = 130;
CONFIG ITEM_PORTAL_SPHERE = 143;
CONFIG ITEM_STRANGE_COFFER = 155;
CONFIG ITEM_REALLY_SMALL_KEY = 156;
CONFIG ITEM_ENGAGEMENT_RING = 157;
CONFIG ITEM_BOSS_HEALTH_BARS = 159;
CONFIG ITEM_ANCIENT_TABLET_PIECE = 182;
CONFIG ITEM_LEVIATHAN_SCALE = 183;
CONFIG ITEM_CUMPURA_KEY = 184;
CONFIG ITEM_TRADING1_SPECIAL_MUSHROOM = 185;
CONFIG ITEM_EXPANSION_BOMB = 186;
CONFIG ITEM_RAFT_ANCIENT_HERO = 189;
CONFIG ITEM_BATTLE_ARENA_TICKET = 191;
CONFIG ITEM_TRADING2_PERFECT_LEAF = 192;
CONFIG ITEM_TRADING3_LADYS_BOW = 193;
CONFIG ITEM_ROCK_PROJECTILE = 195;
CONFIG ITEM_BOULDER_PROJECTILE = 196;
CONFIG ITEM_RACCOON_PROJECTILE = 197;
CONFIG ITEM_GUARD_TOWER_KEY = 202;
CONFIG ITEM_ARROW_AND_QUIVER = 203;
CONFIG ITEM_ARROW_PROJECTILE = 204;
CONFIG ITEM_EXPANSION_QUIVER = 205;
CONFIG ITEM_SIGNET_OF_ALLEGIANCE = 206;
CONFIG ITEM_MYSTERIOUS_KEY = 207;
CONFIG ITEM_TRIFORCE_SHARD_COURAGE = 209;
CONFIG ITEM_TRIFORCE_SHARD_WISDOM = 210;
CONFIG ITEM_TRIFORCE_SHARD_POWER = 211;
CONFIG ITEM_TRIFORCE_SHARD_DEATH = 212;

/*/~~~~~SFX~~~~~/*/
CONFIG SFX_SWITCH_RELEASE = 0; // SFX when a switch is released
CONFIG SFX_SUPER_JUMP = 0;
CONFIG SFX_SLAM = 0;

CONFIG SFX_BOMB_BLAST = 3;
CONFIG SFX_SWORD_ROCK3 = 6;
CONFIG SFX_OOT_SECRET = 7;
CONFIG SFX_ROCKINGSHIP = 9;
CONFIG SFX_FLAMMING_ARROW = 13;
CONFIG SFX_SWITCH_PRESS = 17; // SFX when a switch is pressed
CONFIG SFX_MIRROR_SHIELD_ABSORB_LOOP = 60;
CONFIG SFX_POWDER_KEG_BLAST = 61;
CONFIG SFX_SWITCH_ERROR = 62; // SFX when the wrong switch is pressed
CONFIG SFX_SUMMON_MINE = 64;
CONFIG SFX_ONOX_TORNADO = 63;
CONFIG SFX_OOT_ARMOS_DIE = 73;
CONFIG SFX_OOT_BIG_DEKU_BABA_LUNGE = 75;
CONFIG SFX_IRON_KNUCKLE_STEP = 79;
CONFIG SFX_OOT_STALFOS_DIE = 104;
CONFIG SFX_SHOOTSWORD = 127;
CONFIG SFX_SIZZLE = 128;
CONFIG SFX_LAUNCH_BOMBS = 129;
CONFIG SFX_ARIN_SPLAT = 131;
CONFIG SFX_SQUISH = 138;
CONFIG SFX_OOT_WHISTLE = 143;
CONFIG SFX_AXE2 = 145;
CONFIG SFX_MC_BOUNDCHEST_ROAR1 = 146;
CONFIG SFX_MC_BOUNDCHEST_ROAR2 = 147;
CONFIG SFX_GOMESS_DIE = 148;
CONFIG SFX_MC_BOUNDCHEST_ROAR1AND2 = 149;
CONFIG SFX_IRON_KNUCKLE_HIT = 150;
CONFIG SFX_SHUTTER_OPEN = 151;
CONFIG SFX_SHUTTER_CLOSE = 152;
CONFIG SFX_IRON_KNUCKLE_ATTACK = 153;
CONFIG SFX_IRON_KNUCKLE_ATTACK_SWIPE = 154;

CONFIG SFX_HERO_HURT_1 = 157;
CONFIG SFX_HERO_HURT_2 = 158;
CONFIG SFX_HERO_HURT_3 = 159;

CONFIG SFX_SIGHTED = 161;
CONFIG SFX_WATER_DRIPPING = 165;
CONFIG SFX_STALFOS_GROAN = 166;
CONFIG SFX_STALFOS_GROAN_FAST = 167;
CONFIG SFX_STALFOS_GROAN_SLOW = 168;
CONFIG SFX_IMPACT_EXPLOSION = 169;
CONFIG SFX_STALCHILD_ATTACK = 170;

/*/~~~~~Sprite~~~~~/*/
CONFIG SPR_LEGIONNAIRESWORD = 110;
CONFIG SPR_POISON_CLOUD = 111;
CONFIG SPR_FOOTSTEP = 113;

CONFIG SPR_EZB_DEATHEXPLOSION = 0; // Sprite to use for death explosions (0 for ZC default)
CONFIG EZB_DEATH_FLASH = 1;        // Set to 1 to make the enemy flash during death animations

CONFIG SPR_FLAME_TRAIL = 123;

CONFIG SPR_ROTATING_PILLAR = 57;

CONFIG SPR_FLAME_WAX = 12;
CONFIG SPR_FLAME_OIL = 126;
CONFIG SPR_FLAME_INCENDIARY = 115;
CONFIG SPR_FLAME_HELLS = 127;

CONFIG SPR_FLAME_WAX2X2 = 129;
CONFIG SPR_FLAME_OIL2X2 = 130;
CONFIG SPR_FLAME_INCENDIARY2X2 = 131;
CONFIG SPR_FLAME_HELLS2X2 = 132;

CONFIG SPR_SMALL_ROCK = 118;
CONFIG SPR_SUPER_SMALL_ROCK = 18;

/*/~~~~~Combo~~~~~/*/
CONFIG COMBO_INVIS = 1;
CONFIG COMBO_SOLID = 39;

CONFIG COMBO_L = 7744;
CONFIG COMBO_R = 7745;
CONFIG COMBO_LEFT_ARROW = 7746;
CONFIG COMBO_RIGHT_ARROW = 7747;

/*/~~~~~Combo Types~~~~~/*/
CONFIG CT_SCRIPT_TORCH = CT_SCRIPT19;

/*/~~~~~Tile~~~~~/*/
CONFIG TILE_INVIS = 196;

CONFIG TILE_IMPACT_MID = 955;
CONFIG TILE_IMPACT_BIG = 952;

CONFIG SUB_COOLDOWN_TILE = 29281;

CONFIG TILE_ATTACK_BOOST = 38901;
CONFIG TILE_DEFENSE_BOOST = 38902;

CONFIG TILE_CUMPURA_KEY = 31442;
CONFIG TILE_GUARD_TOWER_KEY = 31421;
CONFIG TILE_BATTLE_ARENA_TICKET = 31803;
CONFIG TILE_ALLEGIANCE_SIGNET = 29141;
CONFIG TILE_MYSTERIOUS_KEY = 31440;
CONFIG TILE_STRANGE_COFFER = 21493;
CONFIG TILE_REALLY_SMALL_KEY = 31444;
CONFIG TILE_ENGAGEMENT_RING = 29224;
CONFIG TILE_EBRIA_KEY = 31428;

CONFIG TILE_BOMB_BAG = 30080;
CONFIG TILE_QUIVER = 30260;
CONFIG TILE_BOMB_BAG_UPGRADE = 30060;
CONFIG TILE_QUIVER_UPGRADE = 30264;
CONFIG TILE_MAGIC_CONTAINER_UPGRADE = 29565;

/*/~~~~~Midi~~~~~/*/
CONFIG MIDI_GAMEOVER = 8;

/*/~~~~~Counters~~~~~/*/
CONFIG CR_TRIFORCE_OF_COURAGE = CR_CUSTOM1; // 7
CONFIG CR_TRIFORCE_OF_POWER = CR_CUSTOM2;   // 8
CONFIG CR_TRIFORCE_OF_WISDOM = CR_CUSTOM3;  // 9
CONFIG CR_TRIFORCE_OF_DEATH = CR_CUSTOM4;   // 10
CONFIG CR_LEGIONNAIRE_RING = CR_CUSTOM5;    // 11
CONFIG CR_HEARTPIECES = CR_CUSTOM6;         // 12
CONFIG CR_MAGIC_EXPANSIONS = CR_CUSTOM7;    // 13
CONFIG CR_BOMB_BAG_EXPANSIONS = CR_CUSTOM8; // 14
CONFIG CR_QUIVER_EXPANSIONS = CR_CUSTOM9;   // 15

/*/~~~~~Footprints~~~~~/*/
CONFIG CT_FOOTPRINT = CT_SCRIPT20;

/*/~~~~~Fonts~~~~~/*/
CONFIG STATUS_FONT = FONT_Z3SMALL;

/*/~~~~~ActiveSubscreen~~~~~/*/
int subscreenYOffset = -224;

char32 numBombUpgradesBuf[6];
char32 numQuiverUpgradesBuf[6];
char32 numMagicUpgradesBuf[6];

int scrollingOffset;

// Active Items
int activeItemIDs[] = {IC_SWORD, IC_BRANG, IC_BOMB, IC_ARROW, IC_CANDLE, IC_WHISTLE, IC_POTION, IC_BAIT, IC_SBOMB, IC_HOOKSHOT, IC_HAMMER, IC_WAND, IC_LENS, IC_WPN_SCRIPT_02, IC_CBYRNA, -1, IC_DINSFIRE, IC_FARORESWIND, IC_NAYRUSLOVE, IC_CUSTOM4, IC_CUSTOM1, IC_CUSTOM3, IC_CUSTOM5, IC_CUSTOM6};

int activeItemLocsX[] = {166, 188, 210, 232, 166, 188, 210, 232, 166, 188, 210, 232, 166, 188, 210, 232, 166, 188, 210, 232, 166, 188, 210, 232};

int activeItemLocsY[] = {32, 32, 32, 32, 54, 54, 54, 54, 76, 76, 76, 76, 98, 98, 98, 98, 120, 120, 120, 120, 142, 142, 142, 142};

// Inactive Items
int inactiveItemIDs[] = {IC_SHIELD, IC_RING, IC_RAFT, IC_LADDER, IC_BRACELET, IC_FLIPPERS, IC_BOMBBAG, IC_QUIVER, IC_LANTERN};

int inactiveItemLocsX[] = {4, 22, 40, 58, 4, 22, 40, 58, 4};

int inactiveItemLocsY[] = {4, 4, 4, 4, 22, 22, 22, 22, 40};

int dungeonItemIds[] = {IC_COMPASS, IC_MAP, IC_BOSSKEY};
int dungeonItemX[] = {133, 132, 133};
int dungeonItemY[] = {108, 125, 142};

int triforceFrames[] = {TILE_COURAGE_FRAME, TILE_POWER_FRAME, TILE_WISDOM_FRAME, TILE_DEATH_FRAME};

int courageShards[] = {COURAGE_SHARD1, COURAGE_SHARD2, COURAGE_SHARD3, COURAGE_SHARD4};
int powerShards[] = {POWER_SHARD1, POWER_SHARD2, POWER_SHARD3, POWER_SHARD4};
int wisdomShards[] = {WISDOM_SHARD1, WISDOM_SHARD2, WISDOM_SHARD3, WISDOM_SHARD4};
int deathShards[] = {DEATH_SHARD1, DEATH_SHARD2, DEATH_SHARD3, DEATH_SHARD4};

int activeSubscreenPosition = 0;
int currTriforceIndex = 0;

int numHeartPieces = 0;

bool subscreenOpen = false;

// Constants
DEFINE NUM_SUBSCR_SEL_ITEMS = 24;
DEFINE NUM_SUBSCR_INAC_ITEMS = 9;
DEFINE NUM_SUBSCR_DUNGEON_ITEMS = 3;

CONFIG BG_MAP = 6;
CONFIG BG_SCREEN = 0x0E;

CONFIG SCROLL_SPEED = 4;

CONFIG CURSOR_MOVEMENT_SFX = 5;
CONFIG TRIFORCE_CYCLE_SFX = 124;
CONFIG ITEM_SELECTION_SFX = 66;

CONFIG SUBSCR_COUNTER_FONT = FONT_LA;
CONFIG SUBSCR_DMAPTITLE_FONT = FONT_Z3SMALL;

CONFIG CSET_LEGIONNAIRE_RING = 7;
CONFIG CSET_LEVIATHAN_SCALE = 0;
CONFIG CSET_SPECIAL_MUSHROOM = 0;

CONFIGB CNTR_USES_0 = true;

CONFIG HEART_VALUE = 8; // default was 16

Color C_SUBSCR_COUNTER_TEXT = C_WHITE;
Color C_SUBSCR_COUNTER_BG = C_TRANSBG;
Color C_MAGIC_METER_FILL = C_GREEN;
Color BG_COLOR = C_DGRAY;

Color C_MINIMAP_EXPLORED = C_WHITE;
Color C_MINIMAP_ROOM = C_BLACK;
Color C_MINIMAP_LINK = C_DEEPBLUE;
Color C_MINIMAP_COMPASS = C_RED;
Color C_MINIMAP_COMPASS_DEFEATED = C_DARKGREEN;

CONFIG TILE_SUBSCR_BUTTON_FRAME = 1378;
CONFIG TILE_HEARTS = 32440;
CONFIG TILE_MAGIC_METER = 32527;
CONFIG TILE_MINIMAP_OW_BG = 1220;
CONFIG TILE_MINIMAP_DNGN_BG = 42400;
CONFIG TILE_LEGIONNAIRE_RING = 42700;
CONFIG TILE_LEVIATHAN_SCALE = 32082;
CONFIG TILE_SPECIAL_MUSHROOM = 30665;

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

/*/~~~~~PassiveSubscreen~~~~~/*/
CONFIG BG_MAP1 = 6;
CONFIG BG_SCREEN1 = 0x0F;
CONFIG TILE_DIFF_NORMAL = 32081;
CONFIG TILE_DIFF_HARD = 32141;
CONFIG TILE_DIFF_PALADIN = 32142;

/*/~~~~~Enemies~~~~~/*/
// start
CONFIG ENEMY_OCTOROCK_LV1_SLOW = 20;
CONFIG ENEMY_OCTOROCK_LV1_FAST = 22;
CONFIG ENEMY_OCTOROCK_LV2_SLOW = 21;
CONFIG ENEMY_OCTOROCK_LV2_FAST = 23;

CONFIG ENEMY_MOBLIN_LV1 = 28;
CONFIG ENEMY_MOBLIN_LV2 = 29;

CONFIG ENEMY_STALFOS_LV1 = 41;
CONFIG ENEMY_STALFOS_LV2 = 79;

CONFIG ENEMY_ROPE_LV1 = 44;
CONFIG ENEMY_ROPE_LV2 = 80;

CONFIG ENEMY_GORIYA_LV1 = 45;
CONFIG ENEMY_GORIYA_LV2 = 46;

CONFIG ENEMY_ARMOS_LV1 = 37;
CONFIG ENEMY_ARMOS_LV2 = 179;

CONFIG ENEMY_LEEVER_LV1_INSIDE = 190;
CONFIG ENEMY_LEEVER_LV2_INSIDE = 27;

CONFIG ENEMY_BAT = 198;

CONFIG ENEMY_THIEF_LV1 = 213;
CONFIG ENEMY_THIEF_LV2 = 214;

CONFIG ENEMY_CANDLEHEAD_LV1 = 237;
CONFIG ENEMY_CANDLEHEAD_CHUNGO = 238;

CONFIG ENEMY_ZOMBIE_LV1 = 222;
CONFIG ENEMY_ZOMBIE_LV1_POPUP = 225;
CONFIG ENEMY_ZOMBIE_LV1_SPRINTING = 228;

CONFIG ENEMY_GHINI_SERVUS_SUMMON = 243;

CONFIG ENEMY_LEGIONNAIRE = 220;

CONFIG ENEMY_SOLDIER_LEVEL2 = 205;
CONFIG ENEMY_SOLDIER_LEVEL2_HALTED = 255;

CONFIG ENEMY_BUBBLE_TEMP_LV1 = 118;
CONFIG ENEMY_BUBBLE_TEMP_LV2 = 251;

CONFIG ENEMY_GRAVE_KEEPER_GONE_APE = 259;

CONFIG ENEMY_OVERGROWN_RACCOON = 235;
CONFIG ENEMY_THIEF_BOSS = 263;

/*/~~~~~Enums~~~~~/*/

enum Color {
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
};

enum ScreenType {
   DM_DUNGEON,
   DM_OVERWORLD,
   DM_INTERIOR,
   DM_BSOVERWORLD
};

enum ArcingWeaponEffects {
   AE_NONE,
   // Shambles
   AE_BOMB,
   AE_SMALLPOISONPOOL,
   AE_LARGEPOISONPOOL,
   AE_PROJECTILE_WITH_MOMENTUM,

   // Hazarond
   AE_OIL_BLOB,
   AE_OIL_DEATH_BLOB,

   // Overgrown Raccoon
   AE_ROCK_PROJECTILE,
   AE_BOULDER_PROJECTILE,
   AE_RACCOON_PROJECTILE,

   // Egentem
   AE_EGENTEM_HAMMER,

   // Misc
   AE_BOMB_EXPLOSION,
   AE_ARROW,

   AE_DEBUG
};

enum StatusPos {
   SP_ABOVE_HEAD,
   SP_TOP_RIGHT
};

enum Status {
   ATTACK_BOOST,
   DEFENSE_BOOST,
   NUM_STATUSES
};

enum TriggerAction {
   TA_KILL_SCRIPT,
   TA_START_SCRIPT
};
