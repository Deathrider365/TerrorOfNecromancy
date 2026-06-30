const int GLOBAL_DEBUG = 0; //If this is on, Moosh fucked up

void DebugDraw(){
	// for(int i=0; i<176; ++i){
		// Screen->DrawInteger(6, ComboX(i), ComboY(i), FONT_Z3SMALL, 0x01, 0x0F, -1, -1, ScreenWalkFlags[i+352], 0, 128);
	// }
}

bool SSGhost_Waitframe(ffc this, npc ghost, bool clearOnDeath, bool quitOnDeath){
	//Screen->DrawInteger(6, Ghost_X, Ghost_Y, FONT_Z3SMALL, 0x01, 0x0F, -1, -1, ghost->Misc[NPCM_MOVELAYER], 0, 128);
	
	ghost->Extend = 4; 
	ghost->Misc[NPCM_GFX] = Ghost_Data;
	if(Ghost_FlagIsSet(GHF_8WAY)||Ghost_FlagIsSet(GHF_4WAY))
		ghost->Misc[NPCM_GFX] += Ghost_Dir;
	if(Ghost_FlagIsSet(GHF_STUN))
		ghost->Misc[NPCM_CANSTUN] = 1;
	ghost->Misc[NPCM_MOVELAYER] = G[G_GHOSTWALKLAYER];
	if(!Ghost_OnLinkLayer()){
		NPC_SetNoColl(ghost);
	}
	return Ghost_Waitframe(this, ghost, clearOnDeath, quitOnDeath);
}

bool SSGhost_Waitframe(ffc this, npc ghost){
	return SSGhost_Waitframe(this, ghost, true, true);
}

bool SSGhost_Waitframe2(ffc this, npc ghost, bool clearOnDeath, bool quitOnDeath){
	ghost->Extend = 4; 
	ghost->Misc[NPCM_GFX] = Ghost_Data;
	if(Ghost_FlagIsSet(GHF_8WAY)||Ghost_FlagIsSet(GHF_4WAY))
		ghost->Misc[NPCM_GFX] += Ghost_Dir;
	if(Ghost_FlagIsSet(GHF_STUN))
		ghost->Misc[NPCM_CANSTUN] = 1;
	ghost->Misc[NPCM_MOVELAYER] = G[G_GHOSTWALKLAYER];
	if(!Ghost_OnLinkLayer()){
		NPC_SetNoColl(ghost);
	}
	return Ghost_Waitframe2(this, ghost, clearOnDeath, quitOnDeath);
}

bool SSGhost_Waitframe2(ffc this, npc ghost){
	return SSGhost_Waitframe2(this, ghost, true, true);
}

void SSGhost_Waitframes(ffc this, npc ghost, int frames){
	for(int i=0; i<frames; ++i){
		SSGhost_Waitframe(this, ghost);
	}
}

int G[1024];
bool FoundItems[512];
int LoreTracking[4096];

const int LT_BANTER = 0;
const int LT_ENEMIES = 1000;
const int LT_LOCATIONS = 2000;
const int LT_QUEST = 3000;
const int LT_ENEMIESRANDO = 3100;

const int G_FORCEDIR = 0;
const int G_STEPMOD = 1;
const int G_MAGNETPULL = 2;
const int G_MAGNETPULLFLOAT = 3;
const int G_SPECIALMAGNETPULL = 4;
const int G_MAGNETACTIVE = 5;
const int G_NOWALK = 6;
const int G_UPINPUT = 7;
const int G_DOWNINPUT = 8;
const int G_LEFTINPUT = 9;
const int G_RIGHTINPUT = 10;
const int G_ANIM = 11;
const int G_STEALTHSPOTTED = 12;
const int G_ASHERHP = 13;
const int G_TORRINHP = 14;
const int G_KAYLANIHP = 15;
const int G_ASHERMAXHP = 16;
const int G_TORRINMAXHP = 17;
const int G_KAYLANIMAXHP = 18;
const int G_ASHERMP = 19;
const int G_TORRINMP = 20;
const int G_KAYLANIMP = 21;
const int G_COLLTIMER = 22;
const int G_INVISTIMER = 23;
const int G_PARTY_ASHER = 24;
const int G_PARTY_TORRIN = 25;
const int G_PARTY_KAYLANI = 26;
const int G_ALIVE_ASHER = 27;
const int G_ALIVE_TORRIN = 28;
const int G_ALIVE_KAYLANI = 29;
const int G_SCRIPTTILETIMER = 30;
const int G_ITEMA_ASHER = 31;
const int G_ITEMB_ASHER = 32;
const int G_ITEMX_ASHER = 33;
const int G_ITEMY_ASHER = 34;
const int G_ITEMA_TORRIN = 35;
const int G_ITEMB_TORRIN = 36;
const int G_ITEMX_TORRIN = 37;
const int G_ITEMY_TORRIN = 38;
const int G_ITEMA_KAYLANI = 39;
const int G_ITEMB_KAYLANI = 40;
const int G_ITEMX_KAYLANI = 41;
const int G_ITEMY_KAYLANI = 42;
const int G_FIRSTLOAD = 43;
const int G_NOACTION = 44;
const int G_DRAWNHPZERO = 45;
const int G_TORRINLOCKON = 46;
const int G_TORRINLOCKONTARGET = 47;
const int G_TORRINLOCKONTARGETX = 48;
const int G_TORRINLOCKONTARGETY = 49;
const int G_TORRINLOCKONWALKCOUNTER = 50;
const int G_LASTSCREEN = 51;
const int G_LASTDMAP = 52;
const int G_SCREENCHANGEDSCROLLING = 53;
const int G_METEOREFFECTSFRAMES = 54;
const int G_SCREENCHANGED = 55;
const int G_EQUIPPEDBATTERYTYPE = 56;
const int G_TORRINLOCKONDISABLEMOVE = 57;
const int G_TORRINTELEKINESIS = 58;
const int G_FIRSTTODIE = 59;
const int G_TIMER1 = 60;
const int G_TIMER1MAX = 61;
const int G_TIMER2 = 62;
const int G_TIMER2MAX = 63;
const int G_TIMER3 = 64;
const int G_TIMER3MAX = 65;
const int G_MSGACTIVE = 80;
const int G_MSGX = 81;
const int G_MSGY = 82;
const int G_PORTRAITTIL = 83;
const int G_PORTRAITEMOTETIL = 84;
const int G_MSGTIMER = 85;
const int G_MSGEMOTECOOLDOWN = 86;
const int G_TEXTSCROLLSPEED = 87;
const int G_MAGNETPULLATTACKLENIENCY = 88;
const int G_CONVOINCREMENTER = 89;
const int G_CONVOLENGTH = 90;
const int G_LINKPITIMMUNITY = 91;
const int G_AINPUT = 92;
const int G_BINPUT = 93;
const int G_XINPUT = 94;
const int G_YINPUT = 95;
const int G_OVERRIDEHOURS = 96;
const int G_OVERRIDEMINUTES = 97;
const int G_OVERRIDESECONDS = 98;
const int G_L3HOURS = 99;
const int G_L3MINUTES = 100;
const int G_L3SECONDS = 101;
const int G_L3TIMEGEMDIR = 102;
const int G_OVERUNDERLAYER = 103;
const int G_GHOSTWALKLAYER = 104;
const int G_ORBDIR = 105;
const int G_DASHINTERRUPT = 106;
const int G_PITRESPAWNX = 107;
const int G_PITRESPAWNY = 108;
const int G_PITRESPAWNDMAP = 109;
const int G_PITRESPAWNSCREEN = 110;
const int G_L3TARGETTIME = 111;
const int G_OVERUNDERSCREEN = 112;
const int G_CLOTHESSWAP = 113;
const int G_ORBLAYER = 113;
const int G_L3TIMEFLOW = 114;
const int G_SUBSCREENSEL = 115;
const int G_TORRINWALKING = 116;
const int G_DARKROOM_SCROLLSTATE = 117;
const int G_DARKROOM_NUMLIGHTS = 118;
const int G_DARKROOM_NUMOLDLIGHTS = 119;
const int G_DARKROOM_SCROLLFRAMES = 120;
const int G_DARKROOM_ENTERING = 121;
const int G_OWBOATX = 122;
const int G_OWBOATY = 123;
const int G_OWBOATDIR = 124;
const int G_PITKIDFLAG = 125;
const int G_TOTEMSTRING = 126;
const int G_ASHERAUGMENT1 = 127;
const int G_ASHERAUGMENT2 = 128;
const int G_TORRINAUGMENT1 = 129;
const int G_TORRINAUGMENT2 = 130;
const int G_KAYLANIAUGMENT1 = 131;
const int G_KAYLANIAUGMENT2 = 132;
const int G_SUBSCREENSEL_AUGMENT = 133;
const int G_KENJACONVO = 134;
const int G_SUBSCREENTAB = 135;
const int G_STOLESOLARMASK = 136;
const int G_STOLELUNARMASK = 137;
const int G_STOLESTELLARMASK = 138;
const int G_ASHERCOSTUME = 139;
const int G_TORRINCOSTUME = 140;
const int G_KAYLANICOSTUME = 141;
const int G_GOLEMFLAG = 142;
const int G_FROZENTIMER = 143;
const int G_FOGACTIVE = 144;
const int G_FOGX = 145;
const int G_FOGY = 146;
const int G_FOGANGLE = 147;
const int G_FOGSPREAD = 148;
const int G_FOGSPREADSTATE = 149;
const int G_NIGHTMARCHEREVENT_DMAP = 150; 
const int G_NIGHTMARCHEREVENT_DAYCOUNT = 151;
const int G_NIGHTMARCHEREVENT_SPAWNFRAMES = 152;
const int G_NIGHTMARCHEREVENT_CHECKTIME = 153;
const int G_NIGHTMARCHEREVENT_INEVENT = 154;
const int G_SUBSCREENSEL_LORE = 155;
const int G_BANTERCYCLE = 156; //Which conversation in the banter cycle is playing
const int G_BANTERLENGTH = 157; //How many strings are in the current party banter conversation
const int G_BANTERID = 158; //The current banter converastion
const int G_MAXBANTER = 159; //How many banter conversations are in the cycle
const int G_BANTERSTRINGPOS = 160; //Which banter string 0-5 is currently playing
const int G_BANTERSTATE = 161; //0 - Loading string, 1 - Playing string, 2 - String has ended, 3 - Scrolling up, 4 - Coversation has ended
const int G_BANTERSCROLL = 162; 
const int G_BANTERSCROLLTIME = 163;
const int G_SUBSCREENSEL_BESTIARY = 164;
const int G_BESTIARY_ENEMYID = 165;
const int G_BESTIARY_ENEMYHP = 166;
const int G_BESTIARY_ENEMYDAMAGE = 167;
const int G_BESTIARY_ENEMYWDAMAGE = 168;
const int G_BESTIARY_ENEMYRESIST = 169;
const int G_BESTIARY_ENEMYWEAKNESS = 170;
const int G_BESTIARY_ENEMYWIDTH = 171;
const int G_BESTIARY_ENEMYHEIGHT = 172;
const int G_BESTIARY_ENEMYTILE = 173;
const int G_BESTIARY_ENEMYCSET = 174;
const int G_BESTIARY_TEXTPLAYING = 175;
const int G_NEWLORE = 176;
const int G_BANTER1 = 177; 
const int G_BANTER2 = 178; 
const int G_BANTER3 = 179; 
const int G_BANTER4 = 180; 
const int G_BANTER5 = 181; 
const int G_BANTER6 = 182; 
const int G_SUBSCREENSEL_LOCATION = 183;
const int G_SUBSCREENOPENDMAP = 184; //DMap when the subscreen was opened
const int G_SUBSCREENOPENDMAPPALETTE = 185; //DMap palette when the subscreen was opened
const int G_LOCATIONSUB_MAP = 186;
const int G_LOCATIONSUB_SCREEN = 187;
const int G_LOCATIONSUB_X = 188;
const int G_LOCATIONSUB_Y = 189;
const int G_MIRAGEISLANDSPAWN = 190;
const int G_MIRAGEISLANDX = 191;
const int G_MIRAGEISLANDY = 192;
const int G_SUBSCREENSEL_QUEST = 193;
const int G_SUBSCREENSEL_CURRENTQUEST = 194;
const int G_CURRENTQUESTSCROLL = 195;
const int G_CURRENTQUESTMAXSCROLL = 196;
const int G_TRUFQUESTFLAGS = 197;
const int G_ICEVX = 198;
const int G_ICEVY = 199;
const int G_ICESTEP = 200;
const int G_FOGSPTILE = 201;
const int G_LOCATIONSUB_FOGTILE = 202;
const int G_LUNARANGCOOLDOWN = 203;
const int G_SCRIPTJINX = 204;
const int G_SCRIPTJINXRUNNING = 205;
const int G_POTIONACTIVE = 206;
const int G_POTIONTIMER = 207;
const int G_POTIONCHAR = 208;
const int G_SUBSCREENSEL_CHARSWAP = 209;
const int G_FORCECHARSWAP = 210;
const int G_ONICEPUSH = 211;
const int G_TIMEFROZEN = 212;
const int G_FITNESSGRAMPACEROFFSET = 213;
const int G_HOURCLAMP = 214;
const int G_MINUTECLAMP = 215;
const int G_HYMNSTONEDEBT = 216;
const int G_GRANDMAPROGRESS = 217;
const int G_DIENEXTFRAME = 218;
const int G_CONTINUEDMAP = 219;
const int G_CONTINUESCREEN = 220;
const int G_ENTRYBOMBS = 221;
const int G_ENTRYSOLARBATTERY = 222;
const int G_ENTRYLUNARBATTERY = 223;
const int G_ENTRYSTELLARBATTERY = 224;
const int G_ENTRYPOTION = 225;
const int G_MAPDISABLED = 226;
const int G_ASHERINCINERATED = 227;
const int G_TORRININCINERATED = 228;
const int G_KAYLANIINCINERATED = 229;
const int G_SUBSCREENSEL_ALTERNATE = 230;
const int G_SUBSCREENSEL_PASSIVE = 231;
const int G_NIGHTMARCHEREVENT_DAYCOUNT2 = 232;
const int G_CUTSCENEDEBUG = 233;
const int G_INUNDERSIDECAVE = 234;
const int G_ROBBEDSELET = 235;
const int G_RERUNTIDALGAUNTLET = 236;
const int G_DMAPCHANGED = 237;
const int G_MUSICCHANGECOOLDOWN = 238; //Hack fix to a bug with continuing
const int G_GRAYHEALTHBAR = 239;
const int G_HORIZONFIGHTDIFFICULTY = 240;
const int G_LASTENTRANCEDMAP = 241;
const int G_LASTENTRANCESCREEN = 242;
const int G_TEMPLASTENTRANCE = 243;
const int G_SORENATTEMPLE = 244; //So that a single NPC can change his dialogue ever so slightly. Efficient variable usage.
const int G_PASSIVESTRINGDISPLAY = 245;
const int G_PASSIVESTRINGNAMESIDE = 246;
const int G_BLACKOUTLAYER7 = 247;
const int G_REDORBINTERRUPT = 248;
const int G_SIDECHARACTERQUESTACTIVE = 249; //For tracking when in the side character quest
const int G_SORENHP = 250;
const int G_SORENMAXHP = 251;
const int G_TERRYHP = 252;
const int G_TERRYMAXHP = 253;
const int G_SIYEDHP = 254;
const int G_SIYEDMAXHP = 255;
const int G_ITEMA_SOREN = 256;
const int G_ITEMB_SOREN = 257;
const int G_ITEMX_SOREN = 258;
const int G_ITEMY_SOREN = 259;
const int G_ITEMA_TERRY = 260;
const int G_ITEMB_TERRY = 261;
const int G_ITEMX_TERRY = 262;
const int G_ITEMY_TERRY = 263;
const int G_ITEMA_SIYED = 264;
const int G_ITEMB_SIYED = 265;
const int G_ITEMX_SIYED = 266;
const int G_ITEMY_SIYED = 267;
const int G_PARTY_SOREN = 268;
const int G_PARTY_TERRY = 269;
const int G_PARTY_SIYED = 270;
const int G_SIYEDMP = 271;
const int G_DEATHIFRAMES = 272;
const int G_VUNTERSLAUSHCOLLISIONS = 273;
const int G_ASHERAUGMENT3 = 274;
const int G_TORRINAUGMENT3 = 275;
const int G_KAYLANIAUGMENT3 = 276;
const int G_TERRYATTEMPLE = 277; //Another one!
const int G_CREATORSREALM_CONTINUEDMAP = 278;
const int G_CREATORSREALM_CONTINUESCREEN = 279;
const int G_SOLARBATTERYSTORAGE = 280;
const int G_LUNARBATTERYSTORAGE = 281;
const int G_STELLARBATTERYSTORAGE = 282;
const int G_SOLARBATTERYSTORAGE_TERRY = 283;
const int G_LUNARBATTERYSTORAGE_TERRY = 284;
const int G_STELLARBATTERYSTORAGE_TERRY = 285;
const int G_STUPIDSIDEQUESTPOPUPDELAY = 286;
const int G_CHASEDIFF = 287;
const int G_CHASELOWPERCENTMET = 288;
const int G_HORIZONCURRENTFORM = 289;
const int G_BURN_ASHER = 290;
const int G_BURN_TORRIN = 291;
const int G_BURN_KAYLANI = 292;
const int G_GHOSTSPECIALWALKSTYLE = 293; //Ghost script flag for special walk scenarios injected into CanMovePixel()
const int G_HORIZONINCINERATEFLAG = 294; //Flag for character death effect to play the incinerate animation in place of the usual one
const int G_BOSSDEATHS = 295; 
const int G_BOSSEASYMODE = 296;
const int G_SLEEPPARALYSISSELET = 297;
const int G_CUTSCENESKIP = 298; //TODO: Make this actually skip cutscenes
const int G_RANDOMIZERENABLED = 299;
const int G_RANDOMIZERSEED = 300;
const int G_ASHERINSEED = 301;
const int G_TORRININSEED = 302;
const int G_KAYLANIINSEED = 303;
const int G_SORENINSEED = 304;
const int G_TERRYINSEED = 305;
const int G_SIYEDINSEED = 306;
const int G_SORENCHARGE = 307;
const int G_TERRYSPEEDTIMER = 308;
const int G_SORENAUGMENT1 = 309;
const int G_SORENAUGMENT2 = 310;
const int G_SORENAUGMENT3 = 311;
const int G_TERRYAUGMENT1 = 312;
const int G_TERRYAUGMENT2 = 313;
const int G_TERRYAUGMENT3 = 314;
const int G_SIYEDAUGMENT1 = 315;
const int G_SIYEDAUGMENT2 = 316;
const int G_SIYEDAUGMENT3 = 317;
const int G_HADOUKENCOOLDOWN = 318;
const int G_SIYEDUPDRAFT = 319;
const int G_OMAKATOTEMCOUNT = 320;
const int G_KAWITOTEMCOUNT = 321;
const int G_SHOALSTOTEMCOUNT = 322;
const int G_WAHIOKALATOTEMCOUNT = 323;
const int G_ITEMPOPUPS = 324;
const int G_RANDOMIZERREQUIREDHYMNSTONES = 325; //Required hymnstones for Observatory or Hymnstone Hunt
const int G_RANDOMIZERMODE = 326; //0 - Standard, 1 - Hymnstone Hunt
const int G_RANDOMIZEROBSERVATORYLOCK = 327; //0 - Always Open, 1 - Characters, 2 - Hymnstones
const int G_RANDOMIZERMAXHYMNSTONES = 328; //Max hymnstones that appear in a seed
const int G_WONHYMNSTONEHUNT = 329;
const int G_SWIMCOUNTER = 330;
const int G_SWIMDIR = 331;
const int G_RETURNTOSHIPSAFETY = 332;
const int G_SHIRT = 333;
const int G_SHIRTCOLOR = 339;
const int G_PANTS = 345;
const int G_PANTSCOLOR = 351;
const int G_USINGCUSTOMOUTFIT = 357;
const int G_ACCESSORY1 = 363;
const int G_ACCESSORY1COLOR = 369;
const int G_ACCESSORY2 = 375;
const int G_ACCESSORY2COLOR = 381;
const int G_STARTED = 387;
const int G_OUTFITMENUOPEN = 388;
const int G_SHIRTBYTE1 = 389;
const int G_SHIRTBYTE2 = 390;
const int G_SHIRTBYTE3 = 391;
const int G_SHIRTBYTE4 = 392;
const int G_SHIRTBYTE5 = 393;
const int G_SHIRTBYTE6 = 394;
const int G_SHIRTBYTE7 = 395;
const int G_SHIRTBYTE8 = 396;
const int G_PANTSBYTE1 = 397;
const int G_PANTSBYTE2 = 398;
const int G_PANTSBYTE3 = 399;
const int G_PANTSBYTE4 = 400;
const int G_PANTSBYTE5 = 401;
const int G_PANTSBYTE6 = 402;
const int G_PANTSBYTE7 = 403;
const int G_PANTSBYTE8 = 404;
const int G_ACCESSORYBYTE1 = 405;
const int G_ACCESSORYBYTE2 = 406;
const int G_ACCESSORYBYTE3 = 407;
const int G_ACCESSORYBYTE4 = 408;
const int G_ACCESSORYBYTE5 = 409;
const int G_ACCESSORYBYTE6 = 410;
const int G_ACCESSORYBYTE7 = 411;
const int G_ACCESSORYBYTE8 = 412;
const int G_COLORBYTE1 = 413;
const int G_COLORBYTE2 = 414;
const int G_COLORBYTE3 = 415;
const int G_COLORBYTE4 = 416;
const int G_COLORBYTE5 = 417;
const int G_COLORBYTE6 = 418;
const int G_COLORBYTE7 = 419;
const int G_COLORBYTE8 = 420;
const int G_OUTFITSHOP1 = 421;
const int G_OUTFITSHOP2 = 422;
const int G_OUTFITSHOP3 = 423;
const int G_OUTFITSHOP4 = 424;
const int G_OUTFITSHOP5 = 425;
const int G_RANDOMIZERRUNCLEAR = 426;
const int G_GLOBALFRAMES = 427;
const int G_GLOBALSECONDS = 428;
const int G_GLOBALMINUTES = 429;
const int G_GLOBALHOURS = 430;
const int G_BESTIARYRANDO = 431;
const int G_BESTIARYPAGE = 432;
const int G_BESTIARYCOOLDOWN = 433;
const int G_MIRAGESAFETY = 434;
const int G_CLANKTIMER = 435;
const int G_NOOUTFITEFFECTS = 436;
const int G_CUTSCENESKIPID = 437;
const int G_CUTSCENESKIPWARP = 438;
const int G_CUTSCENESKIPFIRSTFRAME = 439;
const int G_ENDAPRESS = 440;
const int G_ENDBPRESS = 441;
const int G_ENDXPRESS = 442;
const int G_ENDYPRESS = 443;
const int G_WINNOHINTROOM = 444;
const int G_WINNOHINTITEM = 445;
const int G_WINNOHINTCOOLDOWN = 446;
const int G_EQUIPPEDBATTERYTYPETERRY = 447;
const int G_FORCEDASH = 448;
const int G_MULTIPLAYERACTIVE = 449;
const int G_RANDOMIZERSTARTINGCHARS = 450;
const int G_RANDOMIZERNUMCHARS = 451;
const int G_CURRENTGEODE = 452;
const int G_MULTIPLAYERFIRSTCONNECT = 453;
const int G_TEMPSHIRT = 454;
const int G_TEMPSHIRTCOLOR = 455;
const int G_TEMPPANTS = 456;
const int G_TEMPPANTSCOLOR = 457;
const int G_TEMPACCESSORY1 = 458;
const int G_TEMPACCESSORY1COLOR = 459;
const int G_TEMPACCESSORY2 = 460;
const int G_TEMPACCESSORY2COLOR = 461;
const int G_QUEUEDGEODEANIMSENDER = 462;
const int G_QUEUEDGEODEANIMEFFECT = 463;
const int G_QUEUEDGEODEANIMCHAR = 464;
const int G_CHASEREFIGHT = 465;
const int G_SUBSCREENCHARSWAPTIMER = 466;

int NameBuf[32];

lweapon GLW[256];
const int GL_MAGNETHITBOX = 0;
const int GL_TORRINHOOK = 1;
const int GL_WANDMAGIC = 2;

bitmap GBMP[32];
const int BMP_GENERIC = 0;
const int BMP_LIGHTRAYS = 1;
const int BMP_ASHERMETEOR = 2;
const int BMP_TORRINSHOCKTRAP = 3;
const int BMP_PLAYEREFFECTS = 4;
const int BMP_KAYLANILASER = 5;
const int BMP_KAYLANILASER2 = 6;
const int BMP_SHALLOWS = 7;
const int BMP_SHALLOWS2 = 8;
const int BMP_SHALLOWSWAVES = 9;
const int BMP_SHALLOWSWAVES2 = 10;
const int BMP_ELEVATOR = 11;
const int BMP_BACKGROUNDLAYER = 12;
const int BMP_SCRIPTEDSUBSCREEN = 13;
const int BMP_DARKROOM = 14;
const int BMP_DARKROOM2 = 15;
const int BMP_SCRIPTEDSUBSCREEN2 = 15;
const int BMP_LARGEMAP = 16;
const int BMP_LARGEMAP2 = 17;
const int BMP_SCRIPTEDSUBSCREEN3 = 18;
const int BMP_FOGLAYER = 19;
const int BMP_SCRIPTEDSUBSCREEN4 = 20;
const int BMP_SCRIPTEDSUBSCREEN5 = 21;
const int BMP_FOGLAYER2 = 22;
const int BMP_FOGLAYER2MASK = 23;
const int BMP_MULTIPLAYERSPRITES = 24;

bitmap TempBMP[100];
int TempBMPFree[100];

randgen GRNG;

const int NPCMF_HASROBBED       = 00000001b;
const int NPCMF_TELEKINESIS     = 00000010b;
const int NPCMF_GHOSTDEATHFLAG  = 00000100b;
const int NPCMF_SIYEDMARKED     = 00001000b;
const int NPCMF_NODAMAGENUMBERS = 00010000b;

const int NPCM_FLAGS = 0;
const int NPCM_GFX = 1;
const int NPCM_CANSTUN = 2;
const int NPCM_TELEKINESIS = 3;
// const int NPCM_MOVELAYER = 4;
const int NPCM_NOCOLL = 4;
const int NPCM_MOVELAYER = 5;
const int NPCM_PITIMMUNITY = 6;
const int NPCM_STUNCOOLDOWN = 7;
const int NPCM_OLDHP = 8;
const int NPCM_SITSTILLYOULITTLEFUCK = 9;
const int NPCM_DAMAGEBONUSFRAMES = 10;

const int CF_ENDSTEALTH = CF_NOENEMY; //Used by stealth dmap (layer 0)
const int CF_SAFEGROUND = CF_SCRIPT1; //Used by shoals
const int CF_BARRELFLAG = CF_SCRIPT1; //Used by barrels
const int CF_BARRELFLAGTERRY = CF_SCRIPT2; //Used by barrels
const int CF_OVERUNDERABOVELAYER = CF_SCRIPT1; //Used by Over/Under
const int CF_OVERUNDERBELOWLAYER = CF_SCRIPT2; //Used by Over/Under
const int CF_OVERUNDERBRIDGE = CF_SCRIPT3; //Used by Over/Under
const int CF_NOREMOVELAYER4 = CF_SCRIPT5; //Used by Shoals
const int CF_LAKETEMPLEFOG = CF_SCRIPT6; //Used by lake temple
const int CF_LAKETEMPLEFOG2 = CF_SCRIPT7; //Used by lake temple
const int CF_LAKETEMPLEFOG3 = CF_SCRIPT8; //Used by lake temple
const int CF_LAKETEMPLEFOG4 = CF_SCRIPT9; //Used by lake temple
const int CF_PIRATEPATHING = CF_SCRIPT7; //Used by pirate pathing
const int CF_PIRATEPATHINGTURN = CF_SCRIPT8; //Used by pirate pathing
const int CF_UNDERCAVEENTRANCE = CF_SCRIPT10; //Used by under caves
const int CF_UNDERCAVEEXIT = CF_SCRIPT11; //Used by under caves

const int CR_HYMNSTONES = CR_SCRIPT1;
const int CR_SOLARBATTERY = CR_SCRIPT2;
const int CR_LUNARBATTERY = CR_SCRIPT3;
const int CR_STELLARBATTERY = CR_SCRIPT4;
const int CR_ASHERAUGMENTSLOTS = CR_SCRIPT5;
const int CR_TORRINAUGMENTSLOTS = CR_SCRIPT6;
const int CR_KAYLANIAUGMENTSLOTS = CR_SCRIPT7;
const int CR_STORYFLAG = CR_SCRIPT10;
const int CR_CATACOMBSPLOT = CR_SCRIPT11; //Used for tracking the catacombs events
const int CR_ASHERSIDEQUEST = CR_SCRIPT12; //Used for the sidequest where Asher finds a gem for Iris
const int CR_TORRINSIDEQUEST = CR_SCRIPT13; //Used for the sidequest where Torrin saves Caiman and Zeke
const int CR_HELPERQUEST = CR_SCRIPT14; //Used for the sidequest where the side characters fight Esan
const int CR_MISCSIDEQUEST = CR_SCRIPT15; //Used for the sidequest Russ tossed all the misc NPCs into.
const int CR_SMALLSIDEQUESTS1 = CR_SCRIPT16; //Full of bit flags. Yummy yummy bitflags.
const int CR_GOLEMSIDEQUEST = CR_SCRIPT17; //Siyed and the three golems
const int CR_CULTISTQUEST = CR_SCRIPT18;
const int CR_MISTFLAGS = CR_SCRIPT19; //Used by the Mist Temple cutscenes
const int CR_NIGHTMARCHERQUEST = CR_SCRIPT20; //Used by the Nightmarcher sidequest
const int CR_CHASEQUEST = CR_SCRIPT21; //Used by Chase's sidequest
const int CR_SORENAUGMENTSLOTS = CR_SCRIPT22;
const int CR_TERRYAUGMENTSLOTS = CR_SCRIPT23;
const int CR_SIYEDAUGMENTSLOTS = CR_SCRIPT24;
const int CR_TOTALHYMNSTONES = CR_SCRIPT25;

const int SFM_NOREMOVELAYER4 = SFM_SCRIPT1;
const int SFM_DARKROOM = SFM_SCRIPT2;
const int SFM_BOSSROOM = SFM_SCRIPT3;

const int SFLAG_START = 0; //Start of the game up to Pala Bay
const int SFLAG_IRIS = 1; //Iris's brief conversation with Asher
const int SFLAG_METTORRIN = 2; //Met Torrin in Pala Bay
const int SFLAG_WAREHOUSE = 3; //Warehouse Invasion, set after second scene with Torrin
const int SFLAG_METKAYLANI = 4; //After escaping warehouse; boat becomes usable in Puna Village and Pala Bay after this is set
const int SFLAG_LEVEL1 = 5; //After clearing the pirate hideout; Malka is open
const int SFLAG_TORRINMOM = 6; //After landing in Malka and losing Torrin
const int SFLAG_SENTTODARI = 7; //After talking to the NPC in Malka who sends you to Dari; path to Taro fields opens
const int SFLAG_SHOALSOPEN = 8; //After visiting Malka; Starfall Shoal opens
const int SFLAG_ASHERKIDNAPPED = 9; //After clearing the deepsea mine
const int SFLAG_POSTMANOR = 10; //For starting Catacombs scenes.
const int SFLAG_ASHERRESCUED = 11; //After rescuing Asher and exiting the Catacombs
const int SFLAG_METGRANDMA = 12; //After entering Hoku Village and meeting Kaylani's grandma; Hoku Dock becomes accessible
const int SFLAG_POSTGRANDMA = 13; //After the several conversations with Grandma; Kohiko opens
const int SFLAG_MISTENTERED = 14; //After the cutscenes at the start of the Mist Temple
const int SFLAG_MISTCLEAR = 15; //After clearing the Mist Temple
const int SFLAG_ALIIOPEN = 16; //After talking to Grandma again; Ali'i climb opens
const int SFLAG_GAMECLEAR = 17; //After beating the game

const int SFLAG_TORRINCONVO 		= 0000000000000001b;
const int SFLAG_KAYLANICONVO		= 0000000000000010b;
const int SFLAG_TORRINCONVOPRIMED 	= 0000000000000100b;
const int SFLAG_KAYLANICONVOPRIMED	= 0000000000001000b;

const int BF_0		= 0000000000000001b;	//A series of generic binary flags
const int BF_1		= 0000000000000010b;	
const int BF_2		= 0000000000000100b;	
const int BF_3		= 0000000000001000b;	
const int BF_4		= 0000000000010000b;
const int BF_5		= 0000000000100000b;
const int BF_6		= 0000000001000000b;
const int BF_7		= 0000000010000000b;	
const int BF_8		= 0000000100000000b;	
const int BF_9		= 0000001000000000b;	
const int BF_10 	= 0000010000000000b;	
const int BF_11 	= 0000100000000000b;	
const int BF_12 	= 0001000000000000b;	
const int BF_13 	= 0010000000000000b;	
const int BF_14 	= 0100000000000000b;	
const int BF_15 	= 1000000000000000b;

int ScreenWalkFlags[528];

const int SWF_SOLIDUNDERBRIDGE = 0;
const int SWF_BRIDGE = 1;
const int SWF_ABOVE = 2;
const int SWF_BELOW = 3;
const int SWF_FULLSOLID = 4;

const int CMB_AUTOWARPA = 41224;
const int CMB_AUTOWARPB = 41225;
const int CMB_AUTOWARPC = 41226;
const int CMB_AUTOWARPD = 41227;

// const int EMOTE_ = ;
// const int EMOTE_ = ;
// const int EMOTE_ = ;
// const int EMOTE_ = ;


bool IsSolidLayer(int x, int y, int lyr){
	int index;
	if(lyr==1)
		index = 176;
	else if(lyr==2)
		index = 352;
	else
		return Screen->isSolid(x, y);
		
	if(x<0||x>255||y<0||y>175)
		return true;
	int pos = ComboAt(x, y);
	int s = ScreenWalkFlags[pos+index];
	if(s==16)
		return Screen->isSolid(x, y);
	if(lyr-1==G[G_OVERUNDERLAYER]){
		if(lyr==1&&ScreenWalkFlags[pos]==SWF_BELOW||ScreenWalkFlags[pos]==SWF_BRIDGE){
			return Screen->isSolid(x, y);
		}
		else if(lyr==2&&ScreenWalkFlags[pos]==SWF_ABOVE||ScreenWalkFlags[pos]==SWF_BRIDGE){
			return Screen->isSolid(x, y);
		}
	}
	if(x%16<=7){
		if(y%16<=7)
			return s&0001b;
		else
			return s&0010b;
			
	}
	else{
		if(y%16<=7)
			return s&0100b;
		else
			return s&1000b;
	}
}

global script Init{
	void run(){
		genericdata gd = Game->LoadGenericData(Game->GetGenericScript("GlobalContinue"));
		gd->ReloadState[GENSCR_ST_CONTINUE] = true;
		gd->ReloadState[GENSCR_ST_RELOAD] = true;
		gd->Running = true;
		
		gd = Game->LoadGenericData(Game->GetGenericScript("CutsceneSkipping"));
		gd->ReloadState[GENSCR_ST_CONTINUE] = true;
		gd->ReloadState[GENSCR_ST_RELOAD] = true;
		gd->Running = true;
	}
}

generic script GlobalContinue{
	void run(){
		InitBitmaps();
		DMapPal_Init();
		DayNight_InitDMaps();
		InitGlobals();
		UpdateHUDCopytiles();
		UpdateOverUnderScreens();
		if(G[G_STARTED] == 0){
			G[G_STARTED] = 1;
			InitCostumes();
		}
		Costumes_Update();
		RandomizerCostumeUpdate();
		if(G[G_SUBSCREENOPENDMAP]!=0||G[G_SUBSCREENOPENDMAPPALETTE]!=0){
			dmapdata d = Game->LoadDMapData(G[G_SUBSCREENOPENDMAP]);
			if(GLOBAL_DEBUG)printf("[PAL CHANGE] SUBSCREEN: %d, %X->%X\n", Game->GetCurDMap(), d->Palette, G[G_SUBSCREENOPENDMAPPALETTE]);
			d->Palette = G[G_SUBSCREENOPENDMAPPALETTE];
			G[G_SUBSCREENOPENDMAP] = 0;
			G[G_SUBSCREENOPENDMAPPALETTE] = 0;
		}
		NoAction();
		while(true){
			Waitframe();
		}
	}
}

generic script MooshBug{
	void run(){
		bitmap b = Game->CreateBitmap(256, 176);
		b->Clear(0);
		b->Own();
		int redrawDelay;
		for(int i=0; i<3600; ++i){
			if(redrawDelay){
				--redrawDelay;
				b->Blit(7, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
			}
			if(redrawDelay==0&&Rand(64)==0){
				redrawDelay = 4;
				b->BlitTo(7, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
			}
			Waitframe();
		}
	}
}

generic script CutsceneSkipping{
	void DrawSkip(int percent){
		if(percent>0){
			int x = 8;
			int y = 168-8-6;
			Screen->DrawString(7, x, y-7, FONT_Z3SMALL, 0x01, -1, TF_NORMAL, "SKIP CUTSCENE", 128, SHD_OUTLINED8, 0x0F); 
			int w = Text->StringWidth("SKIP CUTSCENE", FONT_Z3SMALL);
			Screen->Rectangle(7, x, y, x+w-1, y+5, 0x85, 1, 0, 0, 0, true, 128);
			Screen->Rectangle(7, x, y, x+w-1, y+5, 0x0F, 1, 0, 0, 0, false, 128);
			Screen->Rectangle(7, x+1, y+1, Lerp(x+1, x+w-2, percent), y+4, 0x83, 1, 0, 0, 0, true, 128);
		}
	}
	void run(){
		int skipTime;
		bool noStart;
		while(true){
			WaitTo(SCR_TIMING_POST_POLL_INPUT, false);
			
			bool inputStart = Link->InputStart;
			if(G[G_CUTSCENESKIPID]>CUTSCENE_NULL){
				if(Link->InputStart&&G[G_CUTSCENESKIP]){
					noStart = true;
					++skipTime;
				}
				else
					skipTime = Max(skipTime-1.5, 0);
				if(skipTime>=60){
					SkipCutscene(G[G_CUTSCENESKIPID]);
				}
				
				Link->InputStart = false;
				Link->PressStart = false;
			}
			else
				skipTime = 0;
			
			if(noStart){
				if(inputStart){
					Link->InputStart = false;
					Link->PressStart = false;
				}
				else
					noStart = false;
			}
				
			WaitTo(SCR_TIMING_POST_GLOBAL_ACTIVE, false);
			
			DrawSkip(Min(skipTime/40, 1));
			
			Waitframe();
		}
	}
}

global script OnLaunch{
	void run(){
		DayNight_Init();
		DayNight_Update();
		DMapPal_Init();
		if(true){
			DMapPal_Init();
			DayNight_InitDMaps();
			//InitGlobals();
			UpdateHUDCopytiles();
			//UpdateOverUnderScreens();
			Costumes_Update();
			RandomizerCostumeUpdate();
			if(G[G_SUBSCREENOPENDMAP]!=0||G[G_SUBSCREENOPENDMAPPALETTE]!=0){
				dmapdata d = Game->LoadDMapData(G[G_SUBSCREENOPENDMAP]);
				if(GLOBAL_DEBUG)printf("[PAL CHANGE] SUBSCREEN: %d, %X->%X\n", Game->GetCurDMap(), d->Palette, G[G_SUBSCREENOPENDMAPPALETTE]);
				d->Palette = G[G_SUBSCREENOPENDMAPPALETTE];
				G[G_SUBSCREENOPENDMAP] = 0;
				G[G_SUBSCREENOPENDMAPPALETTE] = 0;
			}
			//InitBitmaps();
		}
	}
}

void InitDebug(bool firstLoad){
	if(Debug->Testing&&firstLoad&&GLOBAL_DEBUG){
		Game->Counter[CR_STORYFLAG] = SFLAG_GAMECLEAR;
			// Game->Counter[CR_STORYFLAG] = SFLAG_METTORRIN;
		switch(Game->Counter[CR_STORYFLAG]){
			case SFLAG_POSTGRANDMA...99:
				Link->Item[178] = true; //Starstone
				Link->Item[24] = true; //Lunarang
				Link->Item[I_ABILITY_C_KAYLANI] = true;
				for(int i=183; i<=202; ++i){ //Augments
					Link->Item[i] = true;
				}
				//				   Octo (R)		Octo (B)	Crab (1)	Crab (2)	Crab (S)	Goriya (1)	Goriya (2)	Goriya (3)	Goriya (L)	Keese		Bat			Spider (1)	Spider (2)	Rat			Rope (1)	Rope (2)	Rope (3)	Rope (St)	Tekt (1)	Tekt (2)	Tekt (St)	Dragon (1) 	Dragon (2)	Puff (S)	Puff (F)	Puff (St)	Hopmaw (R)	Hopmaw (B)	Beehive		Piranha		Zora		Zol			Gel			H. Beetle	Curse (S)	Curse (L)	Curse (St)	Bomb (1)	Bomb (2)	Cannon		Mummy		B. Mummy	Armos		Helmet		Ghost		Cospook		NMarcher	Elem (S)    Elem (L)    Elem (St)   Wizz (S)	Wizz (L)	Wizz (St)	ECrab (S)	ECrab (L)	ECrab (St)	EGolem (S)	EGolem (L) 	EGolem (St)	Pillar (S)	Pillar (L)	Pillar (St)	Pirate (R)	Pirate (B)	Pirate (BB)	Pirate (E)  Mask (S)	Mask (L)	Mask (St)	Mask (SB)	Mask (LB)	Mask (StB)	MiniB (S)	MiniB (L)	MiniB (St)	MiniB (F)	Captain		Digger		Esan		Selet       Selet 3		Chase
				int enemyList[] = {22,			23,			26,			27,			137,		45,			46,			136,		221,		38,			106,		189,		194,		187,		44,			80,			190,		223,		25,			24,			222,		138,		139,		225,		224,		226,		237,		238,		239,		195,		33,			43,			42,			196,		198,		197,		212,		178,		179,		199,		54,			220,		210,		229,		35,			209,		227,		232,		233,		234,		56,			57,			153,		180,		181,		182,		183,		184,		185,		203,		204,		205,		191,		192,		193,		231,		186,		188,		211,		206,		207,		208,		213,		214,		215,		244,		218,		216,		242,		217,		236,		251};	
				for(int i=SizeOfArray(enemyList)-1; i>=0; --i){
					LoreTracking[LT_ENEMIES+enemyList[i]] = Max(LoreTracking[LT_ENEMIES+i], 1);
				}
				for(int i=0; i<LOC_SIZE; ++i){
					LoreTracking[LT_LOCATIONS+i] = Max(LoreTracking[LT_LOCATIONS+i], 1);
				}
				SetPartyMaxHP(7);
			case SFLAG_ASHERRESCUED:
			case SFLAG_METGRANDMA:
			case SFLAG_POSTMANOR:
				Link->Item[I_WAND] = true;
				Link->Item[I_ABILITY_B_ASHER] = true;
				Link->Item[I_ABILITY_C_ASHER] = true;
				Link->Item[I_ABILITY_C_TORRIN] = true;
			case SFLAG_ASHERKIDNAPPED:
				Link->Item[145] = true; //Tidal Gauntlet
				Link->Item[I_SWORD_KAYLANI2] = true;
				Link->Item[I_ABILITY_B_KAYLANI] = true;
				SetPartyMaxHP(6);
				SetAmmoMax(0, 0, 0, 30);
			case SFLAG_LEVEL1:
			case SFLAG_TORRINMOM:
			case SFLAG_SENTTODARI:
			case SFLAG_SHOALSOPEN:
				Game->Counter[CR_ASHERAUGMENTSLOTS] = 2;
				Game->Counter[CR_TORRINAUGMENTSLOTS] = 2;
				Game->Counter[CR_KAYLANIAUGMENTSLOTS] = 2;
				Link->Item[I_SWORD2] = true;
				Link->Item[I_SWORD_TORRIN2] = true;
				Link->Item[I_FISTUPGRADE] = true;
				Link->Item[I_ABILITY_A_TORRIN] = true;
				Link->Item[I_ABILITY_B_TORRIN] = true;
				SetAmmoMax(30, 30, 30, 0);
				Link->Item[I_ABILITY_A_KAYLANI] = true;
				Link->Item[182] = true; //Dash Upgrade
				Link->Item[I_LOBBOMB] = true;
				SetPartyMaxHP(5);
			case SFLAG_WAREHOUSE:
			case SFLAG_METKAYLANI:
				Link->Item[I_KAYLANI] = true;
				Link->Item[I_CANDLE2] = true;
				Link->Item[155] = true; //Dark Room Effect
				Link->Item[I_ABILITY_A_ASHER] = true;
				Link->Item[I_SHIELD2] = true;
				Link->Item[29] = true; //Revive Potion
			case SFLAG_METTORRIN:
				Link->Item[I_TORRIN] = true;
		}
	}
}

void ChaseDebug(){
	Game->Counter[CR_STORYFLAG] = SFLAG_GAMECLEAR;
	
	Link->Item[178] = true; //Starstone
	Link->Item[24] = true; //Lunarang
	Link->Item[I_ABILITY_C_KAYLANI] = true;
	for(int i=183; i<=202; ++i){ //Augments
		Link->Item[i] = true;
	}
	//				   Octo (R)		Octo (B)	Crab (1)	Crab (2)	Crab (S)	Goriya (1)	Goriya (2)	Goriya (3)	Goriya (L)	Keese		Bat			Spider (1)	Spider (2)	Rat			Rope (1)	Rope (2)	Rope (3)	Rope (St)	Tekt (1)	Tekt (2)	Tekt (St)	Dragon (1) 	Dragon (2)	Puff (S)	Puff (F)	Puff (St)	Hopmaw (R)	Hopmaw (B)	Beehive		Piranha		Zora		Zol			Gel			H. Beetle	Curse (S)	Curse (L)	Curse (St)	Bomb (1)	Bomb (2)	Cannon		Mummy		B. Mummy	Armos		Helmet		Ghost		Cospook		NMarcher	Elem (S)    Elem (L)    Elem (St)   Wizz (S)	Wizz (L)	Wizz (St)	ECrab (S)	ECrab (L)	ECrab (St)	EGolem (S)	EGolem (L) 	EGolem (St)	Pillar (S)	Pillar (L)	Pillar (St)	Pirate (R)	Pirate (B)	Pirate (BB)	Pirate (E)  Mask (S)	Mask (L)	Mask (St)	Mask (SB)	Mask (LB)	Mask (StB)	MiniB (S)	MiniB (L)	MiniB (St)	MiniB (F)	Captain		Digger		Esan		Selet       Selet 3		Chase
	int enemyList[] = {22,			23,			26,			27,			137,		45,			46,			136,		221,		38,			106,		189,		194,		187,		44,			80,			190,		223,		25,			24,			222,		138,		139,		225,		224,		226,		237,		238,		239,		195,		33,			43,			42,			196,		198,		197,		212,		178,		179,		199,		54,			220,		210,		229,		35,			209,		227,		232,		233,		234,		56,			57,			153,		180,		181,		182,		183,		184,		185,		203,		204,		205,		191,		192,		193,		231,		186,		188,		211,		206,		207,		208,		213,		214,		215,		244,		218,		216,		242,		217,		236,		251};	
	for(int i=SizeOfArray(enemyList)-1; i>=0; --i){
		LoreTracking[LT_ENEMIES+enemyList[i]] = Max(LoreTracking[LT_ENEMIES+i], 2);
	}
	for(int i=0; i<LOC_SIZE; ++i){
		LoreTracking[LT_LOCATIONS+i] = Max(LoreTracking[LT_LOCATIONS+i], 2);
	}
	LoreTracking[LT_LOCATIONS+LOC_MUSHRUSH] = 0;
	
	for(int i=0; i<11; ++i){
		ClearSidequest(i);
		LoreTracking[LT_QUEST+i] = SidequestProgress(i);
	}
	Game->Counter[CR_CHASEQUEST] = SidequestMaxProgress(QST_HORIZON)-3;
	LoreTracking[LT_QUEST+QST_HORIZON] = SidequestProgress(QST_HORIZON);
	
	SetPartyMaxHP(7);
	
	Link->Item[I_WAND] = true;
	Link->Item[I_ABILITY_B_ASHER] = true;
	Link->Item[I_ABILITY_C_ASHER] = true;
	Link->Item[I_ABILITY_C_TORRIN] = true;
	Link->Item[145] = true; //Tidal Gauntlet
	Link->Item[I_SWORD_KAYLANI2] = true;
	Link->Item[I_ABILITY_B_KAYLANI] = true;
	
	Game->Counter[CR_ASHERAUGMENTSLOTS] = 3;
	Game->Counter[CR_TORRINAUGMENTSLOTS] = 3;
	Game->Counter[CR_KAYLANIAUGMENTSLOTS] = 3;
	Link->Item[I_SWORD2] = true;
	Link->ItemA = I_SWORD2;
	G[G_ITEMA_ASHER] = I_SWORD2;
	Link->Item[I_SWORD_TORRIN2] = true;
	Link->Item[I_FISTUPGRADE] = true;
	Link->Item[I_ABILITY_A_TORRIN] = true;
	Link->Item[I_ABILITY_B_TORRIN] = true;
	SetAmmoMax(99, 99, 99, 99);
	Link->Item[I_ABILITY_A_KAYLANI] = true;
	Link->Item[182] = true; //Dash Upgrade
	Link->Item[I_LOBBOMB] = true;
	
	Link->Item[I_KAYLANI] = true;
	Link->Item[I_CANDLE2] = true;
	Link->Item[155] = true; //Dark Room Effect
	Link->Item[I_ABILITY_A_ASHER] = true;
	Link->Item[I_SHIELD2] = true;
	
	Link->Item[I_TORRIN] = true;
	
	G[G_CHASEREFIGHT] = 1;
	
	for(int i=0; i<256; ++i){
		if(Link->Item[i])
			FoundItems[i] = true;
	}
	Link->Warp(57, 0x16);
}

global script Active{
	void run(){
		Trace(1);
		Trace(G[G_ASHERMAXHP]);
		DMapPal_Init();
		DayNight_InitDMaps();
		DayNight_Init();
		InitGlobals();
		InitGenericScripts();
		ClearPickupGraphics();
		GRNG = Game->LoadRNG();
		InitBitmaps();
		StartGhostZH();
		SolidObjects_Init();
		LinkMovement_Init();
		SetUpStyles();
		UpdateOverUnderScreens();
		Tango_Start();
		DarkRoom_Init();
		MiniMap_Init();
		DamageNumbers_Init();
		CrystalSwitch_Init();
		
		G[G_FITNESSGRAMPACEROFFSET] = 0; //Behold, the collection of Gvars for Russ to reset
		G[G_GRANDMAPROGRESS] = 0;
		G[G_INUNDERSIDECAVE ] = 0; //Actually, this one's Moosh's fault
		Game->DMapPalette[73] = 0x081; //Look this was easier than the alternative, alright?
		LoreTracking[LT_LOCATIONS + LOC_PUNA] = Max(LoreTracking[LT_LOCATIONS + LOC_PUNA], 1);
		
		UpdateCharacterItems(GetCharID(), GetCharID(), true);
		while(true){
			//Link->InputMap = false; Link->PressMap = false; //BLAH
			DebugDraw();
			G[G_ANIM] = (G[G_ANIM]+1)%5040;
			UpdateTangoStringContainer();
			UpdateTimers();

			Update_LWeapon();
			Update_NPC();
			Update_Itemsprite();
			
			DayNight_Update();
			UpdateScreenChange();
			UpdateCharSwap();
			UpdateMagnet();
			UpdateBitmaps();
			UpdateGhostZH1();
			Tango_Update1();
			UpdateGlobalInput();
			UpdateSwimming();
			UpdateStepMod();
			if(Link->Action!=LA_SCROLLING){
				SolidObjects_Update1();
				LinkMovement_Update1();
			}
			UpdateReplacementSwords();
			UpdateActiveItems();
			UpdateTorrinLockon();
			UpdateTorrinTelekinesis();
			UpdateHUDCopytiles();
			UpdateOverUnder();
			Nightmarchers_Update();
			UpdateStatus();
			UpdatePotion();
			DamageNumbers_UpdateLink();
			DamageNumbers_UpdateNumberGFX();
			UpdateDeath();
			Minimap_Update();
			UpdateContinue();
			CrystalSwitch_Update();
			Layer7Blackout_Update();
			
			Waitdraw();
			
			UpdateTempState();
			UpdateGhostZH2();
			if(Link->Action!=LA_SCROLLING){
				SolidObjects_Update2();
				LinkMovement_Update2();
			}
			UpdateForceDir();
			Tango_Update2();
			DarkRoom_Update();
			FogGFX_Update();
			CleanUpGlobals();
			
			Waitframe();
		}
	}
}

generic script GameOver{
	void DrawSlashLine(bitmap scrn, int anchorX, int anchorY, int angle, int w, int op){
		if(w){
			if(w<1){
				scrn->Line(0, anchorX+8+VectorX(-160, angle), anchorY+VectorY(-160, angle), anchorX+8+VectorX(160, angle), anchorY+VectorY(160, angle), 0x0F, 1, 0, 0, 0, op);
			}
			else{
				DrawThickLine(scrn, 0,  anchorX+8+VectorX(-160, angle), anchorY+VectorY(-160, angle), anchorX+8+VectorX(160, angle), anchorY+VectorY(160, angle), w/2, 0x0F, true, op);
			}
		}
	}
	void DrawSplatter(bitmap scrn, int anchorX, int anchorY, int splatter, int moveSpeed){
		int splatterX = splatter[0];
		int splatterY = splatter[1];
		int splatterA = splatter[2];
		int splatterSt = splatter[3];
		int splatterT = splatter[4];
		
		for(int i=0; i<8; ++i){
			splatterX[i] += VectorX(splatterSt[i]*moveSpeed, splatterA[i]);
			splatterY[i] += VectorY(splatterSt[i]*moveSpeed, splatterA[i]);
			int x = anchorX+splatterX[i];
			int y = anchorY+splatterY[i];
			scrn->DrawTile(0, x, y, 105312+splatterT[i], 1, 1, 0, -1, -1, x, y, splatterA[i], 0, true, 128);
		}
	}
	void DrawSpaceTunnel2(bitmap b, int stars){
		int starDist = stars[0];
		int starAng = stars[1];
		int starStep = stars[2];
		
		int numStars = SizeOfArray(starDist);
		
		b->ClearToColor(0, 0x7F);
		
		for(int i=0; i<numStars; ++i){
			int size = 5-Clamp(Floor(starDist[i]/42), 0, 5);
			if(starDist[i]>=8)
				b->FastTile(0, 120+VectorX(starDist[i], starAng[i]), 120+VectorY(starDist[i], starAng[i]), TIL_STARS+size, 7, starDist[i]>=32?128:64);
			starDist[i] += Lerp(starStep[i]/2, starStep[i], starDist[i]/256);
			if(starStep[i]==0){
				starStep[i] = Rand(4, 6);
			}
			if(starDist[i]>=256){
				starDist[i] = 0;
				starAng[i] = Rand(360);
			}
		}
	}
	void DrawChaseTunnel2(bitmap b, int stars){
		int starDist = stars[0];
		int starAng = stars[1];
		int starStep = stars[2];
		
		int numStars = SizeOfArray(starDist);
		
		for(int i=0; i<numStars; ++i){
			int size = 5-Clamp(Floor(starDist[i]/42), 0, 5);
			int x = 128+VectorX(starDist[i], starAng[i])+VectorX(8*Sin(starDist[i]*4), starAng[i]+90);
			int y = 48+VectorY(starDist[i], starAng[i])+VectorY(8*Sin(starDist[i]*4), starAng[i]+90);
			b->Circle(0, x, y, 3, Rand(C_GOLD1, C_GOLD2), 1, 0, 0, 0, true, 128);
			b->PutPixel(0, x, y, 0x01, 0, 0, 0, 128);
			b->Circle(0, 128+VectorX(starDist[i], starAng[i]+180), 48+VectorY(starDist[i], starAng[i]+180), 1, Rand(C_GOLD1, C_GOLD2), 1, 0, 0, 0, true, 128);
			//b->FastTile(0, 120+VectorX(starDist[i], starAng[i]), 120+VectorY(starDist[i], starAng[i]), TIL_STARS+size, 7, starDist[i]>=32?128:64);
			starDist[i] += Lerp(starStep[i]/2, starStep[i], starDist[i]/256);
			if(starStep[i]==0){
				starStep[i] = Rand(4, 6);
			}
			if(starDist[i]>=256){
				starDist[i] = 0;
				starAng[i] = Rand(360);
			}
		}
	}
	void DrawPlayerAndEgg(int linkTiles, int aTimer){
		Screen->DrawTile(6, 120, 72+32+4*Sin(aTimer[0]), linkTiles[0], 1, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
		if(Game->Counter[CR_STORYFLAG]>=SFLAG_LEVEL1){
			int eggTile = 117018;
			if(Game->Counter[CR_STORYFLAG]>=SFLAG_GAMECLEAR){
				eggTile = 117006;
				++aTimer[2];
				if(aTimer[2]>=48)
					aTimer[2] = 0;
				eggTile += Floor(aTimer[2]/12)*2;
			}
			else if(Game->Counter[CR_STORYFLAG]>=SFLAG_ALIIOPEN){
				eggTile = 117000;
				++aTimer[1];
				if(aTimer[1]>=90)
					aTimer[1] = 0;
				if(aTimer[1]>90-16)
					eggTile = 117002;
			}
			else if(Game->Counter[CR_STORYFLAG]>=SFLAG_MISTCLEAR){
				eggTile = 117000;
				++aTimer[1];
				if(aTimer[1]>=300)
					aTimer[1] = 0;
				if(aTimer[1]>300-16)
					eggTile = 117002;
			}
			else if(Game->Counter[CR_STORYFLAG]>=SFLAG_ASHERRESCUED)
				eggTile = 117000;
			else if(Game->Counter[CR_STORYFLAG]>=SFLAG_ASHERKIDNAPPED)
				eggTile = 117014;
			else if(Game->Counter[CR_STORYFLAG]>=SFLAG_SHOALSOPEN)
				eggTile = 117016;
			Screen->DrawTile(6, 112, 72-32-48-4*Sin(aTimer[0]), eggTile, 2, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
		}
	}
	void DrawMenuBG(bitmap scrn, int aTimer, int stars, int linkTiles, int bgScroll, untyped nsd){
		using namespace NightmareSelet;
		aTimer[0] = (aTimer[0]+1)%360;
		if(Game->GetCurDMap()==57&&Game->GetCurScreen()==0x06){ //Chase
			scrn->ClearToColor(0, 0x01);
			DrawChaseTunnel2(scrn, stars);
			int auraClr = Rand(C_GOLD1, C_GOLD2);
			scrn->Circle(0, 128+Rand(-2, 2), 48+Rand(-2, 2), (((aTimer[0]%8)<4)?32:56)+8, auraClr, 1, 0, 0, 0, true, 64);
			scrn->Circle(0, 128+Rand(-2, 2), 48+Rand(-2, 2), ((aTimer[0]%8)<4)?32:56, auraClr, 1, 0, 0, 0, true, 128);
			for(int i=0; i<12; ++i){
				int tX[3];
				int tY[3];
				int ang = WrapDegrees((aTimer[0]*4)+30*i);
				int w = Rand(3, 16);
				int len = Rand(80, 128);
				tX[0] = 128+VectorX(w/2, ang+90);
				tY[0] = 48+VectorY(w/2, ang+90);
				tX[1] = 128+VectorX(-w/2, ang+90);
				tY[1] = 48+VectorY(-w/2, ang+90);
				tX[2] = 128+VectorX(len, ang);
				tY[2] = 48+VectorY(len, ang);
				scrn->Triangle(0, tX[0], tY[0], tX[1], tY[1], tX[2], tY[2], 1, 1, auraClr, 0, -1, PT_FLAT, NULL);
			}
			scrn->DrawTile(0, 120, 32+4*Sin(aTimer[0]+45), 111819, 1, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
			scrn->DrawTile(0, 120, 72+32+4*Sin(aTimer[0]), linkTiles[0], 1, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
			scrn->Blit(6, RT_SCREEN, 0, 0, 256, 256, 0, -56, 256, 256, 0, 0, 0, 0, 0, true);
		}
		else if(Game->GetCurDMap()==70){ //NightmareSelet
			bgScroll[0] += VectorX(0.5, 30);
			bgScroll[1] += VectorY(0.5, 30);
			if(bgScroll[0]<0)
				bgScroll[0] += 256;
			else if(bgScroll[0]>=256)
				bgScroll[0] -= 256;
			if(bgScroll[1]<0)
				bgScroll[1] += 176;
			else if(bgScroll[1]>=176)
				bgScroll[1] -= 176;
			int xoff = 512*3;
			GBMP[BMP_BACKGROUNDLAYER]->Blit(6, RT_SCREEN, bgScroll[0]+xoff, bgScroll[1], 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
		
			DrawSpaceTunnel(nsd[STARBITMAP], stars);
			bitmap starBG = nsd[STARBITMAP];
			starBG->DrawTile(0, 120, 72+32+4*Sin(aTimer[0]), linkTiles[0], 1, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
			DrawNightmareSelet1(nsd);
			DrawNightmareSelet2(nsd, 96, 56+24);
		}
		else{
			scrn->Clear(0);
			DrawSpaceTunnel2(scrn, stars);
			scrn->Blit(6, RT_SCREEN, 0, 0, 256, 256, 0, -56, 256, 256, 0, 0, 0, 0, 0, true);
			DrawPlayerAndEgg(linkTiles, aTimer);
		}
	}
	enum SelectionResults {SR_CONTINUE, SR_SAVECONTINUE, SR_SAVEQUIT, SR_CONTINUEBOSS, SR_CONTINUEENTRNACE, SR_CONTINUEBOSSEASY};
	void DrawMenuOptions(int selectionResult, int op, int selection, int aTimer, bool rematch, bool easyMode, bool drawSel){
		Screen->DrawString(6, 128, -56+80, FONT_SHERWOOD, 0x01, -1, TF_CENTERED, "GAME OVER", op, SHD_OUTLINED8, 0x0F);
	
		int sel1[] = "Continue";
		int sel2[] = "Save and Continue";
		int sel3[] = "Save and Quit";
		int sel1a[] = "Continue from Boss";
		int sel1b[] = "Continue from Entrance";
		int sel1c[] = "Reduce Boss Difficulty";
		
		int selections[5];
		int numSel;
		if(rematch&&easyMode){
			selections[0] = sel1a;
			selectionResult[0] = SR_CONTINUEBOSS;
			selections[1] = sel1c;
			selectionResult[1] = SR_CONTINUEBOSSEASY;
			selections[2] = sel1b;
			selectionResult[2] = SR_CONTINUEENTRNACE;
			selections[3] = sel2;
			selectionResult[3] = SR_SAVECONTINUE;
			selections[4] = sel3;
			selectionResult[4] = SR_SAVEQUIT;
			numSel = 5;
		}
		else if(rematch){
			selections[0] = sel1a;
			selectionResult[0] = SR_CONTINUEBOSS;
			selections[1] = sel1b;
			selectionResult[1] = SR_CONTINUEENTRNACE;
			selections[2] = sel2;
			selectionResult[2] = SR_SAVECONTINUE;
			selections[3] = sel3;
			selectionResult[3] = SR_SAVEQUIT;
			numSel = 4;
		}
		else{
			selections[0] = sel1;
			selectionResult[0] = SR_CONTINUE;
			selections[1] = sel2;
			selectionResult[1] = SR_SAVECONTINUE;
			selections[2] = sel3;
			selectionResult[2] = SR_SAVEQUIT;
			numSel = 3;
		}
		
		for(int i=0; i<numSel; ++i){
			if(selection==i&&drawSel)
				Screen->DrawString(6, 128, -56+80+32+16*i, FONT_Z3SMALL, aTimer[0]%8<2?0x01:0x72, -1, TF_CENTERED, selections[i], op, SHD_OUTLINED8, 0x0F);
			else
				Screen->DrawString(6, 128, -56+80+32+16*i, FONT_Z3SMALL, 0x01, -1, TF_CENTERED, selections[i], op, SHD_OUTLINED8, 0x0F);
		}
	}
	enum BossRoom {BOSS_NONE, BOSS_SHELROND, BOSS_BOLIDEBORER, BOSS_SELET1, BOSS_ESAN, BOSS_SELET2, BOSS_NIGHTMARESELET};
	int GetBossRoom(){
		if(Game->GetCurMap()==6&&Game->GetCurScreen()==0x1B)
			return BOSS_SHELROND;
		if(Game->GetCurMap()==20){
			if(Game->GetCurScreen()==0x5F)
				return BOSS_BOLIDEBORER;
			else if(Game->GetCurScreen()==0x0A)
				return BOSS_SELET1;
		}	
		if(Game->GetCurMap()==46&&Game->GetCurScreen()==0x62)
			return BOSS_ESAN;
		if(Game->GetCurMap()==24){
			if(Game->GetCurScreen()==0x17)
				return BOSS_SELET2;
			else if(Game->GetCurScreen()==0x07)
				return BOSS_NIGHTMARESELET;
		}
		return BOSS_NONE;
	}
	void run(){
		int i; int j; int k;
		G[G_DIENEXTFRAME] = 0;
		Game->PlayMIDI(0);
		Game->PlaySound(127);
		int linkTiles[2];
		switch(GetCharID()){
			case CHAR_ASHER:
				linkTiles[0] = 105303;
				linkTiles[1] = 105306;
				break;
			case CHAR_TORRIN:
				linkTiles[0] = 105304;
				if(G[G_CLOTHESSWAP] == 1)
					linkTiles[0] = 105316;
				linkTiles[1] = 105308;
				break;
			case CHAR_KAYLANI:
				linkTiles[0] = 105305;
				linkTiles[1] = 105310;
				break;
			case CHAR_SOREN:
				linkTiles[0] = 105429;
				break;
			case CHAR_TERRY:
				linkTiles[0] = 105430;
				break;
			case CHAR_SIYED:
				linkTiles[0] = 105431;
				break;
		}
		//int bitID = TempBitmap_Create(0, 48, 32);
		bitmap b = Game->CreateBitmap(48, 32); //TempBMP[bitID];
		b->Own();
		b->Clear(0);
		b->DrawTile(0, 0, 0, linkTiles[0], 1, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
		b->DrawTile(0, 16, 0, linkTiles[1], 2, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
		b->ReplaceColors(0, 0x0F, 0x01, 0xBF);
		//int bitID2 = TempBitmap_Create(0, 256, 256);
		bitmap scrn = Game->CreateBitmap(256, 256); //TempBMP[bitID2];
		scrn->Own();
		int splatterX[8];
		int splatterY[8];
		int splatterA[8];
		int splatterSt[8];
		int splatterT[8];
		
		int splatter[] = {splatterX, splatterY, splatterA, splatterSt, splatterT};
		
		int slashAng = -40+Rand(-8, 8);
		for(i=0; i<8; ++i){
			splatterX[i] = Rand(-1, 1);
			splatterY[i] = Rand(-1, 1);
			splatterA[i] = slashAng+Rand(-20, 20);
			splatterSt[i] = Rand(30, 40)*0.1;
			splatterT[i] = Rand(4);
		}
		int anchorX = Link->X;
		int anchorY = Link->Y;
		if(Game->GetCurDMap()==57&&Game->GetCurScreen()==0x06){
			for(i=0; i<24; ++i){
				scrn->Clear(0);
				if(i<8){
					Screen->Rectangle(6, 0, 0, 255, 175, 0x50, 1, 0, 0, 0, true, 64);
					scrn->DrawTile(0, anchorX, anchorY-16, linkTiles[0], 1, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
				}
				else if(i<16){
					scrn->Rectangle(0, 0, 0, 255, 175, 0x50, 1, 0, 0, 0, true, 64);
					scrn->Rectangle(0, 0, 0, 255, 175, 0x50, 1, 0, 0, 0, true, 64);
					scrn->DrawTile(0, anchorX, anchorY-16, linkTiles[0], 1, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
					b->Blit(0, scrn, 0, 0, 16, 32, anchorX, anchorY-16, 16, 32, 0, 0, 0, BITDX_TRANS, 0, true);
				}
				else if(i<24){
					Screen->Rectangle(6, 0, 0, 255, 175, 0x50, 1, 0, 0, 0, true, 128);
					scrn->DrawTile(0, anchorX, anchorY-16, linkTiles[0], 1, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
					b->Blit(0, scrn, 0, 0, 16, 32, anchorX, anchorY-16, 16, 32, 0, 0, 0, BITDX_TRANS, 0, true);
					b->Blit(0, scrn, 0, 0, 16, 32, anchorX, anchorY-16, 16, 32, 0, 0, 0, BITDX_TRANS, 0, true);
				}
				scrn->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
				Waitframe();
			}
			bitmap mask = Game->CreateBitmap(16, 32);
			mask->Own();
			mask->ClearToColor(0, 0x01);
			bitmap plyr = Game->CreateBitmap(16, 32);
			plyr->Own();
			plyr->Clear(0);
			plyr->DrawTile(0, 0, 0, linkTiles[0], 1, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
			plyr->ReplaceColors(0, 0x0F, 0x01, 0xBF);
			int w;
			Game->PlaySound(153);
			for(i=0; i<24; ++i){
				scrn->Clear(0);
				int cx = 128+Rand(-2, 2);
				int cy = 88+Rand(-2, 2);
				scrn->Rectangle(0, 0, 0, 255, 175, 0x50, 1, 0, 0, 0, true, 128);
				w = Clamp(Lerp(0, 256, i/24), 0, 256);
				scrn->Rectangle(0, cx-w/2, 0, cx+w/2, 176, 0x01, 1, 0, 0, 0, true, 128);
				scrn->Rectangle(0, 0, cy-w/2*0.6875, 256, cy+w/2*0.6875, 0x01, 1, 0, 0, 0, true, 128);
				w = Clamp(Lerp(0, 256, i/24), 0, 256)*1.2;
				scrn->Rectangle(0, 0, cy-w/2*0.6875, 256, cy+w/2*0.6875, 0x01, 1, 0, 0, 0, true, 64);
				plyr->Blit(0, scrn, 0, 0, 16, 32, anchorX, anchorY-16, 16, 32, 0, 0, 0, BITDX_NORMAL, 0, true);
				if(i<16&&i%8<4)
					scrn->Rectangle(0, 0, 0, 255, 175, Rand(C_GOLD1, C_GOLD2), 1, 0, 0, 0, true, 128);
				scrn->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
				Waitframe();
			}
			Game->PlaySound(109);
			for(i=0; i<48; ++i){
				scrn->Clear(0);
				scrn->Rectangle(0, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 128);
				plyr->Dither(0, mask, 0x00, DITH_STATIC, Lerp(0, 255, i/47));
				k = 0;
				if(i>16)
					k += (i-16)*0.5;
				if(i>32)
					k += (i-32)*0.5;
				for(j=0; j<4; ++j)
					plyr->Blit(0, scrn, 0, 0, 16, 32, anchorX+VectorX(k, 90+Lerp(-45, 45, j/3)), anchorY-16+VectorY(k, 90+Lerp(-45, 45, j/3)), 16, 32, 0, 0, 0, BITDX_NORMAL, 0, true);
				scrn->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
				Waitframe();
			}
			for(i=0; i<24; ++i){
				Screen->Rectangle(6, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 128);
				Screen->Rectangle(6, 0, -56, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
				if(i>=8)
					Screen->Rectangle(6, 0, -56, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
				if(i>=16)
					Screen->Rectangle(6, 0, -56, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
				Waitframe();
			}
		}
		else{
			for(i=0; i<48; ++i){
				scrn->Clear(0);
				int angCenter = Angle(anchorX, anchorY, 120, 80);
				if(Distance(anchorX, anchorY, 120, 80)>2){
					anchorX += VectorX(Lerp(1, 0.5, i/48), angCenter);
					anchorY += VectorY(Lerp(1, 0.5, i/48), angCenter);
				}
				int w;
				if(i>=24){
					w = Lerp(0, 2, (i-24)/24);
				}
				if(i<8){
					Screen->Rectangle(6, 0, 0, 255, 175, 0x50, 1, 0, 0, 0, true, 64);
					scrn->DrawTile(0, anchorX, anchorY-16, linkTiles[0], 1, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
				}
				else if(i<16){
					scrn->Rectangle(0, 0, 0, 255, 175, 0x50, 1, 0, 0, 0, true, 64);
					scrn->Rectangle(0, 0, 0, 255, 175, 0x50, 1, 0, 0, 0, true, 64);
					scrn->DrawTile(0, anchorX, anchorY-16, linkTiles[0], 1, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
					b->Blit(0, scrn, 0, 0, 16, 32, anchorX, anchorY-16, 16, 32, 0, 0, 0, BITDX_TRANS, 0, true);
				}
				else if(i<24){
					Screen->Rectangle(6, 0, 0, 255, 175, 0x50, 1, 0, 0, 0, true, 128);
					DrawSlashLine(scrn, anchorX, anchorY, slashAng, w, 128);
					scrn->DrawTile(0, anchorX, anchorY-16, linkTiles[0], 1, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
					b->Blit(0, scrn, 0, 0, 16, 32, anchorX, anchorY-16, 16, 32, 0, 0, 0, BITDX_TRANS, 0, true);
					b->Blit(0, scrn, 0, 0, 16, 32, anchorX, anchorY-16, 16, 32, 0, 0, 0, BITDX_TRANS, 0, true);
				}
				else if(i<32){
					Screen->Rectangle(6, 0, 0, 255, 175, 0x50, 1, 0, 0, 0, true, 128);
					Screen->Rectangle(6, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 64);
					DrawSlashLine(scrn, anchorX, anchorY, slashAng, w, 128);
					DrawSlashLine(scrn, anchorX, anchorY, slashAng, w, 128);
					b->Blit(6, scrn, 0, 0, 16, 32, anchorX, anchorY-16, 16, 32, 0, 0, 0, 0, 0, true);
				}
				else if(i<40){
					Screen->Rectangle(6, 0, 0, 255, 175, 0x50, 1, 0, 0, 0, true, 128);
					Screen->Rectangle(6, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 64);
					Screen->Rectangle(6, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 64);
					DrawSlashLine(scrn, anchorX, anchorY, slashAng, w, 128);
					DrawSplatter(scrn, anchorX, anchorY, splatter, 1);
					b->Blit(0, scrn, 0, 0, 16, 32, anchorX, anchorY-16, 16, 32, 0, 0, 0, 0, 0, true);
				}
				else if(i<48){
					Screen->Rectangle(6, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 128);
					DrawSlashLine(scrn, anchorX, anchorY, slashAng, w, 128);
					DrawSplatter(scrn, anchorX, anchorY, splatter, Lerp(1, 0.1, (i-40)/8));
					b->Blit(0, scrn, 0, 0, 16, 32, anchorX, anchorY-16, 16, 32, 0, 0, 0, 0, 0, true);
				}
				scrn->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
				Waitframe();
			}
			for(i=0; i<32; ++i){
				scrn->Clear(0);
				Screen->Rectangle(6, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 128);
				DrawSplatter(scrn, anchorX, anchorY, splatter, 0.1);
				b->Blit(0, scrn, 0, 0, 16, 32, anchorX, anchorY-16, 16, 32, 0, 0, 0, 0, 0, true);
				scrn->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
				Waitframe();
			}
			for(i=0; i<24; ++i){
				scrn->Clear(0);
				Screen->Rectangle(6, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 128);
				DrawSplatter(scrn, anchorX, anchorY, splatter, 0.1);
				b->Blit(0, scrn, 0, 0, 16, 32, anchorX, anchorY-16, 16, 32, 0, 0, 0, 0, 0, true);
				scrn->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
				Screen->Rectangle(6, 0, -56, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
				if(i>=8)
					Screen->Rectangle(6, 0, -56, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
				if(i>=16)
					Screen->Rectangle(6, 0, -56, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
				Waitframe();
			}
		}
		int starDist[128];
		int starAng[128];
		int starStep[128];
		int stars[] = {starDist, starAng, starStep};
		for(i=0; i<128; ++i){
			starDist[i] = Rand(256);
			starAng[i] = Rand(360);
		}
		int aTimer[3];
		
		int tentacleFrames[48];
		int tentacleASpeed[48];
		int tentacleSkip[48];
		for(i=0; i<48; ++i){
			tentacleFrames[i] = Rand(90);
			tentacleASpeed[i] = 1;
			if(i<5)
				tentacleASpeed[i] = 2;
			tentacleSkip[i] = Rand(4, 6);
		}
			
		GBMP[BMP_BACKGROUNDLAYER]->Clear(0);
		for(int i=0; i<4; ++i){
			GBMP[BMP_BACKGROUNDLAYER]->DrawLayer(0, 24, 0x84+i, 0, 512*i+0, 0, 0, 128);
			GBMP[BMP_BACKGROUNDLAYER]->DrawLayer(0, 24, 0x84+i, 0, 512*i+256, 0, 0, 128);
			GBMP[BMP_BACKGROUNDLAYER]->DrawLayer(0, 24, 0x84+i, 0, 512*i+0, 176, 0, 128);
			GBMP[BMP_BACKGROUNDLAYER]->DrawLayer(0, 24, 0x84+i, 0, 512*i+256, 176, 0, 128);
		}
		
		int bgScroll[2];
		
		bitmap buf = Game->CreateBitmap(512, 512);
		bitmap starBG = Game->CreateBitmap(256, 176);
		bitmap starBG2 = Game->CreateBitmap(256, 176);
		bitmap prep = Game->CreateBitmap(256, 176);
		buf->Own();
		starBG->Own();
		starBG2->Own();
		prep->Own();
			
		using namespace NightmareSelet;
		untyped nsd[48];
		nsd[BUFFER] = buf;
		nsd[STARBITMAP] = starBG;
		nsd[STARBITMAP2] = starBG2;
		nsd[PREPBITMAP] = prep;
		
		nsd[HEADANGLE] = 90;
		
		nsd[LHAND_X] = -72;
		nsd[LHAND_Y] = -16;
		nsd[LHAND_ANG] = -45;
		
		nsd[RHAND_X] = 72;
		nsd[RHAND_Y] = -16;
		nsd[RHAND_ANG] = 45;
		
		nsd[HEADSTATE] = 3;
		nsd[HEADTARGETSTATE] = 3;
		
		nsd[LHAND_STATE] = HAND_CLAW;
		nsd[RHAND_STATE] = HAND_CLAW;
		nsd[LHAND_SUBSTATE] = 3;
		nsd[RHAND_SUBSTATE] = 3;
		nsd[LHAND_TARGETSUB] = 3;
		nsd[RHAND_TARGETSUB] = 3;
		
		nsd[TENTACLEFRAMES] = tentacleFrames;
		nsd[TENTACLEASPEED] = tentacleASpeed;
		nsd[TENTACLESKIP] = tentacleSkip;
		nsd[TENTACLEAMULT] = 1;
		
		nsd[SPECIALDRAW] = SD_BG;
		nsd[DRAWSCALE] = 1;
		nsd[DRAWLAYER] = 6;
		for(i=0; i<24; ++i){
			DrawMenuBG(scrn, aTimer, stars, linkTiles, bgScroll, nsd);
			Screen->Rectangle(6, 0, -56, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
			if(i<16)
				Screen->Rectangle(6, 0, -56, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
			if(i<8)
				Screen->Rectangle(6, 0, -56, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
			Waitframe();
		}
		int selectionResult[6];
		int selection = 0;
		bool rematch = ScreenFlag(SF_MISC, SFM_BOSSROOM);
		if(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_13)
			rematch = true;
		int whichBoss = GetBossRoom();
		bool easyMode = false;
		if(!G[G_BOSSEASYMODE]&&(G[G_BOSSDEATHS]>=2||G[G_RANDOMIZERENABLED])){
			//This is a nasty ass or chain just in case I want to remove one or more of these from being difficulty lowerable at a later point
			if(whichBoss==BOSS_SHELROND||whichBoss==BOSS_BOLIDEBORER||whichBoss==BOSS_SELET1||whichBoss==BOSS_ESAN||whichBoss==BOSS_SELET2||whichBoss==BOSS_NIGHTMARESELET)
				easyMode = true;
		}
		int maxSelections = 3;
		if(rematch&&easyMode)
			maxSelections = 5;
		else if(rematch)
			maxSelections = 4;
		for(i=0; i<12; ++i){
			DrawMenuBG(scrn, aTimer, stars, linkTiles, bgScroll, nsd);
			DrawMenuOptions(selectionResult, 64, selection, aTimer, rematch, easyMode, false);
			if(i>=4)
				DrawMenuOptions(selectionResult, 64, selection, aTimer, rematch, easyMode, false);
			if(i>=8)
				DrawMenuOptions(selectionResult, 128, selection, aTimer, rematch, easyMode, false);
			Waitframe();
		}
		if(Game->GetCurDMap()==57&&Game->GetCurScreen()==0x06){
			G[G_PASSIVESTRINGNAMESIDE] = 0;
			if(G[G_HORIZONCURRENTFORM]==0){
				if(GetCharID()==CHAR_ASHER)
					PlayStringCustom("C'mon Asher! Let me see more of your cool stellar magic!", "Chase", 0, 0, 16, 128, true);
				else if(GetCharID()==CHAR_TORRIN)
					PlayStringCustom("Let's go again! Show me why they call you Torrin the Incombustible!", "Chase", 0, 0, 16, 128, true);
				else if(GetCharID()==CHAR_KAYLANI)
					PlayStringCustom("I know you're stronger than this, Kaylani. Let's see what the strongest astronomer can do!", "Chase", 0, 0, 16, 128, true);
			}
			else if(G[G_HORIZONCURRENTFORM]==1){
				if(GetCharID()==CHAR_ASHER)
					PlayStringCustom("You're pretty good. But I'm just getting warmed up.", "Chase", 0, 0, 16, 128, true);
				else if(GetCharID()==CHAR_TORRIN)
					PlayStringCustom("Darn, ya almost had me on the ropes!", "Chase", 0, 0, 16, 128, true);
				else if(GetCharID()==CHAR_KAYLANI)
					PlayStringCustom("Aww, I wanted to keep playing a while longer...", "Chase", 0, 0, 16, 128, true);
			}
			else if(G[G_HORIZONCURRENTFORM]==2){
				if(GetCharID()==CHAR_ASHER)
					PlayStringCustom("How disappointing. I suppose even a star can't outshine the sun...", "Chase?", 0, 0, 16, 128, true);
				else if(GetCharID()==CHAR_TORRIN)
					PlayStringCustom("It was an impressive effort, but you are only human after all...", "Chase?", 0, 0, 16, 128, true);
				else if(GetCharID()==CHAR_KAYLANI)
					PlayStringCustom("It was well fought, but my power was simply superior...", "Chase?", 0, 0, 16, 128, true);
			}
		}
		Game->PlayEnhancedMusic("SS-Cosmic.ogg", 0);
		while(!Link->PressA){
			DrawMenuBG(scrn, aTimer, stars, linkTiles, bgScroll, nsd);
			if(Link->PressUp){
				Game->PlaySound(5);
				--selection;
				if(selection<0){
					selection = maxSelections-1;
				}
			}
			else if(Link->PressDown){
				Game->PlaySound(5);
				++selection;
				if(selection>=maxSelections){
					selection = 0;
				}
			}
			
			DrawMenuOptions(selectionResult, 128, selection, aTimer, rematch, easyMode, true);
			UpdateTangoStringContainer();
			Tango_Update1();
			Tango_Update2();
			Waitframe();
		}
		G[G_MSGACTIVE] = 0;
		Tango_ClearSlot(0);
		for(i=0; i<12; ++i){
			DrawMenuBG(scrn, aTimer, stars, linkTiles, bgScroll, nsd);
			DrawMenuOptions(selectionResult, 128, selection, aTimer, rematch, easyMode, true);
			
			Screen->Rectangle(6, 0, -56, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
			if(i>4)
				Screen->Rectangle(6, 0, -56, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
			if(i>8)
				Screen->Rectangle(6, 0, -56, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
			UpdateTangoStringContainer();
			Tango_Update1();
			Tango_Update2();
			Waitframe();
		}
		Game->LastEntranceDMap = G[G_LASTENTRANCEDMAP];
		Game->LastEntranceScreen = G[G_LASTENTRANCESCREEN];
		Game->ContinueDMap = G[G_CONTINUEDMAP];
		Game->ContinueScreen = G[G_CONTINUESCREEN];
		Link->HP = Link->MaxHP;
		Link->MP = Link->MaxMP;
		G[G_ASHERHP] = G[G_ASHERMAXHP];
		G[G_TORRINHP] = G[G_TORRINMAXHP];
		G[G_KAYLANIHP] = G[G_KAYLANIMAXHP];
		G[G_ASHERMP] = Link->MaxMP;
		G[G_KAYLANIMP] = Link->MaxMP;
		G[G_SORENHP] = G[G_SORENMAXHP];
		G[G_TERRYHP] = G[G_TERRYMAXHP];
		G[G_SIYEDHP] = G[G_SIYEDMAXHP];
		G[G_SIYEDMP] = Link->MaxMP;
		ClearStatus();
		DamageNumbers_Init();
		SolidObjects_Init();
		DMapPal_Init();
		if(G[G_FIRSTTODIE]&&CanUseChar(G[G_FIRSTTODIE]-1)){
			SetCharacter(G[G_FIRSTTODIE]-1, false);
		}
		G[G_FIRSTTODIE] = 0;
		Link->Invisible = false;
		Screen->Rectangle(6, 0, -56, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
		G[G_SCREENCHANGED] = 1;
		switch(selectionResult[selection]){
			case SR_CONTINUEBOSS: //Retry Boss
				++G[G_BOSSDEATHS];
				Game->LastEntranceDMap = Game->GetCurDMap();
				Game->LastEntranceScreen = Game->GetCurScreen();
				Game->ContinueDMap = Game->GetCurDMap();
				Game->ContinueScreen = Game->GetCurScreen();
				RefundCounters();
				Link->Warp(Game->LastEntranceDMap, Game->LastEntranceScreen-Game->DMapOffset[Game->LastEntranceDMap]);
				break;
			case SR_CONTINUEBOSSEASY: //Retry Boss (Easy Difficulty)
				if(G[G_RANDOMIZERENABLED]){
					Game->PlaySound(172);
					for(int i=0; i<180; ++i){
						DrawMenuBG(scrn, aTimer, stars, linkTiles, bgScroll, nsd);
						DrawMenuOptions(selectionResult, 128, selection, aTimer, rematch, easyMode, true);
						
						Screen->Rectangle(6, 0, -56, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
						UpdateTangoStringContainer();
						Tango_Update1();
						Tango_Update2();
						Waitframe();
					}
				}
				Game->LastEntranceDMap = Game->GetCurDMap();
				Game->LastEntranceScreen = Game->GetCurScreen();
				Game->ContinueDMap = Game->GetCurDMap();
				Game->ContinueScreen = Game->GetCurScreen();
				RefundCounters();
				G[G_BOSSEASYMODE] = 1;
				Link->Warp(Game->LastEntranceDMap, Game->LastEntranceScreen-Game->DMapOffset[Game->LastEntranceDMap]);
				break;
			case SR_CONTINUE: //Retry Area
			case SR_CONTINUEENTRNACE: //Retry Area
				Link->Warp(Game->ContinueDMap, Game->ContinueScreen-Game->DMapOffset[Game->ContinueDMap]);
				break;
			case SR_SAVECONTINUE: //Save and Continue
				Game->Save();
				Link->Warp(Game->ContinueDMap, Game->ContinueScreen-Game->DMapOffset[Game->ContinueDMap]);
				break;
			case SR_SAVEQUIT: //Save and Quit
				Game->Save();
				Game->End();
				break;
		}
	}
}

//Refunds counters when dying on a boss screen
void RefundCounters(){
	Game->Counter[CR_BOMBS] = G[G_ENTRYBOMBS];
	Game->Counter[CR_SOLARBATTERY] = G[G_ENTRYSOLARBATTERY];
	Game->Counter[CR_LUNARBATTERY] = G[G_ENTRYLUNARBATTERY];
	Game->Counter[CR_STELLARBATTERY] = G[G_ENTRYSTELLARBATTERY];
	if(G[G_ENTRYPOTION]==1)
		Link->Item[29] = true;
	else if(G[G_ENTRYPOTION]==2)
		Link->Item[30] = true;
}

generic script CounterTracker{
	void run(){
		G[G_ENTRYBOMBS] = Game->Counter[CR_BOMBS];
		G[G_ENTRYSOLARBATTERY] = Game->Counter[CR_SOLARBATTERY];
		G[G_ENTRYLUNARBATTERY] = Game->Counter[CR_LUNARBATTERY];
		G[G_ENTRYSTELLARBATTERY] = Game->Counter[CR_STELLARBATTERY];
		G[G_ENTRYPOTION] = 0;
		if(Link->Item[29]) //Revive
			G[G_ENTRYPOTION] = 1;
		else if(Link->Item[30]) //Regen
			G[G_ENTRYPOTION] = 2;
		while(true){
			Waitframe();
		}
	}
}

// generic script DeathToSpacebarMap{
	// void run(){
		// while(true){
			// WaitTo(SCR_TIMING_POST_OLD_ITEMDATA_SCRIPT, false);
			// Link->InputMap = false; Link->PressMap = false; //BLAH
			// Waitframe();
		// }
	// }
// }

void Update_NPC(){
	for(int i=Screen->NumNPCs(); i>0; --i){
		npc n = Screen->LoadNPC(i);
		NPC_HitBy(n);
		NPC_WandMagicCollision(n);
		NPC_GhostTile(n);
		NPC_NoCollCounter(n);
		NPC_StunCooldown(n);
		NPC_FlagSeen(n);
		NPC_Dropsets(n);
		DamageNumbers_UpdateEnemyDamage(n);
		//Screen->DrawInteger(6, n->X, n->Y, FONT_Z3SMALL, 0x01, 0x0F, -1, -1, n->Script, 0, 128);
	}
}

void NPC_HitBy(npc n){
	int hit = n->HitBy[6]; //lweapon uid
	if(n->Misc[NPCM_DAMAGEBONUSFRAMES])
		--n->Misc[NPCM_DAMAGEBONUSFRAMES];
	if(hit>0){
		lweapon l = Screen->LoadLWeaponByUID(hit);
		l->Misc[LWM_HITBY] = n->UID;
	}
	hit = n->HitBy[2]; //lweapon screen ID
	if(hit>0){
		lweapon l = Screen->LoadLWeapon(hit);
		NPC_AlterDamage(n, l); //This is in a different category because sword collision didn't want to work with the other
	}
}

int NPC_AlterDamage(npc n, lweapon l){
	const int HALF = 1;
	const int DOUBLE = 2;
	
	int defMod = 0;
	switch(l->ID){
		case LW_SOLAR:
			if(n->Defense[NPCD_SCRIPT1]==NPCDT_HALFDAMAGE)
				defMod = HALF;
			else if(n->Defense[NPCD_SCRIPT1]==NPCDT_2XDAMAGE)
				defMod = DOUBLE;
			break;
		case LW_LUNAR:
			if(n->Defense[NPCD_SCRIPT2]==NPCDT_HALFDAMAGE)
				defMod = HALF;
			else if(n->Defense[NPCD_SCRIPT2]==NPCDT_2XDAMAGE)
				defMod = DOUBLE;
			break;
		case LW_STELLAR:
		case LW_STARWANDIMPACT:
			if(n->Defense[NPCD_MAGIC]==NPCDT_HALFDAMAGE)
				defMod = HALF;
			else if(n->Defense[NPCD_MAGIC]==NPCDT_2XDAMAGE)
				defMod = DOUBLE;
			break;
	}
	int alterMult = 1;
	if(n->Misc[NPCM_DAMAGEBONUSFRAMES]){
		Game->PlaySound(171);
		alterMult *= 1.5;
		for(int i=0; i<3; ++i){
			int offs = Rand(5);
			ParticleAnim(HitboxCenterX(n)-8+Rand(-8, 8), HitboxCenterY(n)-8+Rand(-8, 8), 69644-offs, 8, 8+offs, 1);
		}
	}
	if(G[G_BESTIARYRANDO]){
		int defenseID = BestiaryLegalID(n->ID);
		if(LoreTracking[LT_ENEMIES+defenseID]){
			if(defenseID!=236)
				alterMult *= 1.5;
		}
	}
	if(GLOBAL_DEBUG)
		alterMult = 10;
	if(defMod==HALF){
		switch(n->ID){
			default:
				alterMult *= 0.75;
				break;
		}
		if(alterMult!=1){
			// Trace(l->Damage);
			// Trace(GetEnemyProperty(n, ENPROP_HP)+Ceiling(l->Damage / 2)-(l->Damage * alterMult));
			SetEnemyProperty(n, ENPROP_HP, GetEnemyProperty(n, ENPROP_HP)+Ceiling(l->Damage / 2)-(l->Damage * alterMult));
			// n->HP += Ceiling(l->Damage / 2);
			// n->HP -= l->Damage * alterMult;
		}
	}
	else if(defMod==DOUBLE){
		switch(n->ID){
			default:
				alterMult *= 1.5;
				break;
		}
		if(alterMult!=1){
			SetEnemyProperty(n, ENPROP_HP, GetEnemyProperty(n, ENPROP_HP)+(l->Damage * 2)-(l->Damage * alterMult));
			// n->HP += l->Damage * 2;
			// n->HP -= l->Damage * alterMult;
		}
	}
	else{
		int damage = l->Damage;
		if(l->ID==LW_SWORD) //swords for whatever reason use a different damage scale from everything else
			damage *= 2;
		if(alterMult!=1){
			SetEnemyProperty(n, ENPROP_HP, GetEnemyProperty(n, ENPROP_HP)+(damage)-(damage * alterMult));
		}
	}
}

void NPC_GhostTile(npc n){
	int gfx = GhostGet(n, GG_DATA);
	if(gfx<0){
		n->Misc[NPCM_GFX] = gfx;
		n->Misc[NPCM_CANSTUN] = 1;
	}
}

void NPC_SetNoColl(npc n){
	if(!n->Misc[NPCM_NOCOLL]){
		n->HitXOffset += 1000;
	}
	n->Misc[NPCM_NOCOLL] = 2;
}

void NPC_StunCooldown(npc n){
	if(n->Stun>0)
		n->Misc[NPCM_STUNCOOLDOWN] = 32;
	else if(n->Misc[NPCM_STUNCOOLDOWN])
		--n->Misc[NPCM_STUNCOOLDOWN];
}

void NPC_NoCollCounter(npc n){
	if(n->Misc[NPCM_NOCOLL]){
		--n->Misc[NPCM_NOCOLL];
		if(!n->Misc[NPCM_NOCOLL])
			n->HitXOffset -= 1000;
	}
	if(n->Misc[NPCM_PITIMMUNITY]){
		--n->Misc[NPCM_PITIMMUNITY];
		n->MoveFlags[NPCMV_CAN_PITFALL] = false;
		if(!n->Misc[NPCM_PITIMMUNITY])
			n->MoveFlags[NPCMV_CAN_PITFALL] = true;
	}
}

int BestiaryLegalID(int id){
	switch(id){
		//Enemy redirects
		//Fast Octoroks
		case 20:
			return 22;
		case 21:
			return 23;
			break;
		//Cannon
		case 200:
			return 199;
		case 247:
		case 246:
		case 245:
			return 236;
		
		//Banned enemies
		//Beamos
		case 219:
		case 228:
		//Trap
		case 47:
		case 95...98:
		case 201:
		case 202:
		//Fire
		case 85:
		//Winno
		case 230:
		//Bee
		case 240:
		//Selet
		case 217:
		case 235:
		case 248:
		return -1;
	}
	return id;
}

void GiveBestiaryEntry(int id, bool skipNotify){
	if(G[G_BESTIARYRANDO]){
		if(LoreTracking[LT_ENEMIESRANDO+id]==0&&G[G_BESTIARYCOOLDOWN]<=0){
			LoreTracking[LT_ENEMIESRANDO+id] = 1;
			int itemID = RandomizedItems[IL_BES_REDOCTO+BestiaryListNum(id)];
			// item itm = SpawnRandomizerItem(itemID, Link->X, Link->Y+32);
			lweapon l = CreateLWeaponAt(LW_SCRIPT10, 120, 80);
			l->CollDetection = false;
			l->DrawYOffset = -1000;
			RunLWeaponScript(l, "BestiaryDropManager", {itemID, id});
		}
	}
	else{
		if(LoreTracking[LT_ENEMIES+id]==0){
			if(skipNotify)
				LoreTracking[LT_ENEMIES+id] = 2;
			else
				LoreTracking[LT_ENEMIES+id] = 1;
			if(!G[G_NEWLORE]&&!skipNotify){
				PopupNotify(1); //New enemy
			}
		}
	}
}

void NPC_FlagSeen(npc n){
	if(n->HP<=0){
		int id = BestiaryLegalID(n->ID);
		if(id==-1)
			return;
		GiveBestiaryEntry(id, false);
	}
}

void NPC_Dropsets(npc n){
	if(n->HP<=0&&GetCharID()==CHAR_TERRY&&HasAugment(I_AUGMENT_DIREDROPS)){
		if(n->ItemSet>0){
			if(Game->Counter[CR_SOLARBATTERY]<5)
				n->ItemSet = 19;
			else if(Game->Counter[CR_LUNARBATTERY]<5)
				n->ItemSet = 20;
			else if(Game->Counter[CR_STELLARBATTERY]<5)
				n->ItemSet = 21;
		}
	}
}

void NPC_WandMagicCollision(npc n){
	if(n->Defense[NPCD_STELLAR]==NPCDT_BLOCK&&GLW[GL_WANDMAGIC]->isValid()){
		if(Collision(n, GLW[GL_WANDMAGIC])){
			GLW[GL_WANDMAGIC]->Misc[LWM_INSTANTDETONATE] = 1;
		}
	}
}

const int LWM_HITBY = 0;
const int LWM_SOLIDITYLAYER = 1;
const int LWM_INSTANTDETONATE = 2;
const int LWM_FLAGS = 3;

const int LWMF_DEFLECT = 1b;

const int EWM_FLAGS = 16;
const int EWMF_NOCOUNTER = 001b; //Doesn't trigger dash counter
const int EWMF_REFLECTED = 010b; //Reflected by silver sword
const int EWMF_NOREFLECT = 100b; //Can't be reflected by silver sword

void Update_LWeapon(){
	for(int i=Screen->NumLWeapons(); i>0; --i){
		lweapon l = Screen->LoadLWeapon(i);
		LWeapon_HitBy(l);
	}
}

void LWeapon_HitBy(lweapon l){
	l->Misc[LWM_HITBY] = 0;
}

void LWeapon_FirePits(lweapon l){
	if(l->ID==LW_FIRE){
		l->MoveFlags[WPNMV_CAN_PITFALL] = false;
	}
}

const int ITMM_FORCEGRAB = 0;
const int ITMM_SPECIALGRAB = 1;
const int ITMM_SPAWNSAFETY = 2;
const int ITMM_FLAGS = 3;

const int ITMMF_SUPERDUMMY = 0x1;

void Update_Itemsprite(){
	for(int i=Screen->NumItems(); i>0; --i){
		itemsprite itm = Screen->LoadItem(i);
		Itemsprite_PickupTimer(itm);
		Itemsprite_Grabbed(itm);
	}
}

void Itemsprite_Grabbed(itemsprite itm){
	if(itm->Misc[ITMM_FORCEGRAB]){
		itm->X = Link->X;
		itm->Y = Link->Y;
	}
}

void Itemsprite_PickupTimer(itemsprite itm){
	if(itm->Pickup&IP_TIMEOUT){
		if(itm->Misc[ITMM_SPAWNSAFETY]>0){
			if(itm->Misc[ITMM_SPAWNSAFETY]>1)
				--itm->Misc[ITMM_SPAWNSAFETY];
		}
		else{
			itm->Misc[ITMM_SPAWNSAFETY] = 32;
		}
	}
}

void InitBitmaps(){
	if(!GBMP[BMP_GENERIC]->isAllocated()){
		GBMP[BMP_GENERIC] = Game->AllocateBitmap();
		GBMP[BMP_GENERIC]->Create(0, 1024, 1024);
		GBMP[BMP_GENERIC]->Clear(0);
		
		GBMP[BMP_LIGHTRAYS] = Game->AllocateBitmap();
		GBMP[BMP_LIGHTRAYS]->Create(0, 256, 176);
		GBMP[BMP_LIGHTRAYS]->Clear(0);
		GBMP[BMP_ASHERMETEOR] = Game->AllocateBitmap();
		GBMP[BMP_ASHERMETEOR]->Create(0, 256, 176);
		GBMP[BMP_ASHERMETEOR]->Clear(0);
		GBMP[BMP_TORRINSHOCKTRAP] = Game->AllocateBitmap();
		GBMP[BMP_TORRINSHOCKTRAP]->Create(0, 64, 64);
		GBMP[BMP_TORRINSHOCKTRAP]->Clear(0);
		GBMP[BMP_PLAYEREFFECTS] = Game->AllocateBitmap();
		GBMP[BMP_PLAYEREFFECTS]->Create(0, 64, 64);
		GBMP[BMP_PLAYEREFFECTS]->Clear(0);
		GBMP[BMP_KAYLANILASER] = Game->AllocateBitmap();
		GBMP[BMP_KAYLANILASER]->Create(0, 48, 32);
		GBMP[BMP_KAYLANILASER]->Clear(0);
		GBMP[BMP_KAYLANILASER2] = Game->AllocateBitmap();
		GBMP[BMP_KAYLANILASER2]->Create(0, 16, 16);
		GBMP[BMP_KAYLANILASER2]->Clear(0);
		GBMP[BMP_SHALLOWS] = Game->AllocateBitmap();
		GBMP[BMP_SHALLOWS]->Create(0, 256, 176);
		GBMP[BMP_SHALLOWS]->Clear(0);
		GBMP[BMP_SHALLOWS2] = Game->AllocateBitmap();
		GBMP[BMP_SHALLOWS2]->Create(0, 256, 176);
		GBMP[BMP_SHALLOWS2]->Clear(0);
		GBMP[BMP_SHALLOWSWAVES] = Game->AllocateBitmap();
		GBMP[BMP_SHALLOWSWAVES]->Create(0, 256, 176);
		GBMP[BMP_SHALLOWSWAVES]->Clear(0);
		GBMP[BMP_SHALLOWSWAVES2] = Game->AllocateBitmap();
		GBMP[BMP_SHALLOWSWAVES2]->Create(0, 256, 176);
		GBMP[BMP_SHALLOWSWAVES2]->Clear(0);
		GBMP[BMP_ELEVATOR] = Game->AllocateBitmap();
		GBMP[BMP_ELEVATOR]->Create(0, 512, 256);
		GBMP[BMP_ELEVATOR]->Clear(0);
		GBMP[BMP_BACKGROUNDLAYER] = Game->AllocateBitmap();
		GBMP[BMP_BACKGROUNDLAYER]->Create(0, 2048, 352);
		GBMP[BMP_BACKGROUNDLAYER]->Clear(0);
		GBMP[BMP_SCRIPTEDSUBSCREEN] = Game->AllocateBitmap();
		GBMP[BMP_SCRIPTEDSUBSCREEN]->Create(0, 256, 176);
		GBMP[BMP_SCRIPTEDSUBSCREEN]->Clear(0);
		GBMP[BMP_DARKROOM] = Game->AllocateBitmap();
		GBMP[BMP_DARKROOM]->Create(0, 512, 352);
		GBMP[BMP_DARKROOM]->Clear(0);
		GBMP[BMP_DARKROOM2] = Game->AllocateBitmap();
		GBMP[BMP_DARKROOM2]->Create(0, 512, 352);
		GBMP[BMP_DARKROOM2]->Clear(0);
		GBMP[BMP_SCRIPTEDSUBSCREEN2] = Game->AllocateBitmap();
		GBMP[BMP_SCRIPTEDSUBSCREEN2]->Create(0, 256, 176);
		GBMP[BMP_SCRIPTEDSUBSCREEN2]->Clear(0);
		GBMP[BMP_LARGEMAP] = Game->AllocateBitmap();
		GBMP[BMP_LARGEMAP]->Create(0, 512, 512);
		GBMP[BMP_LARGEMAP]->Clear(0);
		GBMP[BMP_LARGEMAP2] = Game->AllocateBitmap();
		GBMP[BMP_LARGEMAP2]->Create(0, 512, 512);
		GBMP[BMP_LARGEMAP2]->Clear(0);
		GBMP[BMP_SCRIPTEDSUBSCREEN3] = Game->AllocateBitmap();
		GBMP[BMP_SCRIPTEDSUBSCREEN3]->Create(0, 256, 176);
		GBMP[BMP_SCRIPTEDSUBSCREEN3]->Clear(0);
		GBMP[BMP_FOGLAYER] = Game->AllocateBitmap();
		GBMP[BMP_FOGLAYER]->Create(0, 768, 512);
		GBMP[BMP_FOGLAYER]->Clear(0);
		FogGFX_Init();
		GBMP[BMP_SCRIPTEDSUBSCREEN4] = Game->AllocateBitmap();
		GBMP[BMP_SCRIPTEDSUBSCREEN4]->Create(0, 256, 176);
		GBMP[BMP_SCRIPTEDSUBSCREEN4]->Clear(0);
		GBMP[BMP_SCRIPTEDSUBSCREEN5] = Game->AllocateBitmap();
		GBMP[BMP_SCRIPTEDSUBSCREEN5]->Create(0, 256, 176);
		GBMP[BMP_SCRIPTEDSUBSCREEN5]->Clear(0);
		GBMP[BMP_FOGLAYER2] = Game->AllocateBitmap();
		GBMP[BMP_FOGLAYER2]->Create(0, 256, 176);
		GBMP[BMP_FOGLAYER2]->Clear(0);
		GBMP[BMP_FOGLAYER2MASK] = Game->AllocateBitmap();
		GBMP[BMP_FOGLAYER2MASK]->Create(0, 256, 176);
		GBMP[BMP_FOGLAYER2MASK]->Clear(0);
		GBMP[BMP_MULTIPLAYERSPRITES] = Game->AllocateBitmap();
		GBMP[BMP_MULTIPLAYERSPRITES]->Create(0, 640*6, 768);
		GBMP[BMP_MULTIPLAYERSPRITES]->Clear(0);
		
		for(int i=0; i<100; ++i){
			TempBMP[i] = Game->AllocateBitmap();
			TempBMP[i]->Create(0, 1, 1);
			TempBMPFree[i] = 2;
		}
	}
}

void UpdateBitmaps(){
	for(int i=0; i<100; ++i){
		if(TempBMPFree[i]==1)
			TempBMPFree[i] = 2;
	}
}

int TempBitmap_Create(int layer, int w, int h){
	int which;
	for(int i=0; i<100; ++i){
		which = i;
		if(TempBMPFree[i]==2){
			TempBMP[i]->Create(layer, w, h);
			TempBMPFree[i] = 0;
			break;
		}
	}
	//Trace(which);
	return which;
}

void TempBitmap_Free(int layer, int which){
	TempBMP[which]->Create(layer, 1, 1);
	TempBMPFree[which] = 1;
}

const int I_ASHER = 149;
const int I_TORRIN = 150;
const int I_KAYLANI = 151;
const int I_SOREN = 212;
const int I_TERRY = 213;
const int I_SIYED = 214;

const int I_TORRIN_MOD = 147;
const int I_KAYLANI_MOD = 148;
const int I_SOREN_MOD = 209;
const int I_TERRY_MOD = 210;
const int I_SIYED_MOD = 211;

void InitGlobals(){
	bool firstLoad;
	G[G_LASTSCREEN] = Game->GetCurScreen();
	G[G_LASTDMAP] = Game->GetCurDMap();
	Link->MP = Link->MaxMP;
	if(!G[G_FIRSTLOAD]){
		firstLoad = true;
		G[G_L3HOURS] = 24;
		G[G_L3MINUTES] = 0;
		G[G_L3SECONDS] = 0;
		Link->Item[I_SWORD1] = true;
		FoundItems[I_SWORD1] = true;
		FoundItems[I_SWORD_TORRIN] = true;
		FoundItems[I_SWORD_KAYLANI] = true;
		G[G_ITEMA_ASHER] = I_SWORD1;
		G[G_ITEMA_TORRIN] = I_SWORD_TORRIN;
		G[G_ITEMB_TORRIN] = I_ABILITY_A_TORRIN;
		G[G_ITEMA_KAYLANI] = I_SWORD_KAYLANI;
		G[G_ITEMA_SOREN] = I_SWORD1;
		G[G_ITEMA_TERRY] = I_SWORD_TORRIN;
		G[G_ITEMA_SIYED] = I_SWORD_KAYLANI;
		G[G_SUBSCREENSEL_CHARSWAP] = -1;
		G[G_FIRSTLOAD] = 1;
	}
	//UpdatePartyIcons();
	G[G_STEALTHSPOTTED] = 0;
	G[G_DRAWNHPZERO] = 0;
	G[G_METEOREFFECTSFRAMES] = 0;
	G[G_MSGACTIVE] = 0;
	G[G_TIMER1] = 0;
	G[G_TIMER1MAX] = 0;
	G[G_TIMER2] = 0;
	G[G_TIMER2MAX] = 0;
	G[G_TIMER3] = 0;
	G[G_TIMER3MAX] = 0;
	G[G_OVERRIDEHOURS] = -1;
	G[G_OVERUNDERLAYER] = 0;
	G[G_ORBDIR] = 0;
	
	if(G[G_ASHERMAXHP]==0){
		Link->HP = 64;
		Link->MaxHP = 64;
		G[G_ASHERHP] = 64;
		G[G_ASHERMAXHP] = 64;
		G[G_TORRINHP] = 64;
		G[G_TORRINMAXHP] = 64;
		G[G_KAYLANIHP] = 64;
		G[G_KAYLANIMAXHP] = 64;
		G[G_ASHERMP] = Link->MaxMP;
		G[G_KAYLANIMP] = Link->MaxMP;
		G[G_SORENHP] = 112;
		G[G_SORENMAXHP] = 112;
		G[G_TERRYHP] = 112;
		G[G_TERRYMAXHP] = 112;
		G[G_SIYEDHP] = 112;
		G[G_SIYEDMAXHP] = 112;
		G[G_SIYEDMP] = Link->MaxMP;
	}
	else{
		G[G_ASHERHP] = G[G_ASHERMAXHP];
		G[G_TORRINHP] = G[G_TORRINMAXHP];
		G[G_KAYLANIHP] = G[G_KAYLANIMAXHP];
		G[G_SORENHP] = G[G_SORENMAXHP];
		G[G_TERRYHP] = G[G_TERRYMAXHP];
		G[G_SIYEDHP] = G[G_SIYEDMAXHP];
		G[G_ASHERMP] = Link->MaxMP;
		G[G_KAYLANIMP] = Link->MaxMP;
		G[G_SIYEDMP] = Link->MaxMP;
	}
	ClearStatus();
	
	if(G[G_FIRSTTODIE]&&CanUseChar(G[G_FIRSTTODIE]-1)){
		SetCharacter(G[G_FIRSTTODIE]-1, false);
	}
	G[G_FIRSTTODIE] = 0;
	G[G_FOGACTIVE] = 0;
	G[G_FOGX] = 0;
	G[G_FOGY] = 0;
	G[G_FOGANGLE] = Rand(360);
	G[G_FOGSPREAD] = 128;
	G[G_FOGSPREADSTATE] = -1;
	G[G_NIGHTMARCHEREVENT_INEVENT] = 0;
	if(Game->GetCurDMap()!=45){
		G[G_MIRAGEISLANDSPAWN] = Rand(8);
	}
	G[G_POTIONACTIVE] = -1;
	G[G_FORCECHARSWAP] = -1;
	G[G_DIENEXTFRAME] = 0;
	G[G_MAPDISABLED] = 0;
	G[G_GRAYHEALTHBAR] = 0;
	G[G_HORIZONINCINERATEFLAG] = 0;
	if(!G[G_CUTSCENESKIPFIRSTFRAME])
		G[G_CUTSCENESKIPID] = 0;
	
	//Soren's Sword
	G[G_SORENCHARGE] = 0;
	CopyTile(67280+G[G_SORENCHARGE], 67320);
	
	if(G[G_CONTINUEDMAP]==0&&G[G_CONTINUESCREEN]==0){
		G[G_CONTINUEDMAP] = Game->GetCurDMap();
		G[G_CONTINUESCREEN] = Game->GetCurScreen();
		G[G_LASTENTRANCEDMAP] = Game->GetCurDMap();
		G[G_LASTENTRANCESCREEN] = Game->GetCurScreen();
	}
	Game->LastEntranceDMap = G[G_LASTENTRANCEDMAP];
	Game->LastEntranceScreen = G[G_LASTENTRANCESCREEN];
	Game->ContinueDMap = G[G_CONTINUEDMAP];
	Game->ContinueScreen = G[G_CONTINUESCREEN];
	// int subscrn = Game->GetDMapScript("ScriptedSubscreen");
	// for(int i=0; i<512; ++i){
		// dmapdata dmd = Game->LoadDMapData(i);
		// dmd->SubscreenScripts[DMD_SUBSCREEN_ACTIVE] = subscrn;
	// }
	InitDebug(firstLoad);
	if(G[G_RANDOMIZERENABLED]){
		Randomizer_InitItemData();
		Randomizer_InitMinimapData();
	}
	
	int subscreenScriptSlot = Game->GetDMapScript("ScriptedSubscreen");
	int batterySwitchScriptSlot = Game->GetDMapScript("BatterySelect");
	for(int i=0; i<512; ++i){
		dmapdata dmd = Game->LoadDMapData(i);
		if(dmd->ASubScript==subscreenScriptSlot)
			dmd->MapScript = batterySwitchScriptSlot;
	}
}

void InitGenericScripts(){
	genericdata gd = Game->LoadGenericData(Game->GetGenericScript("CounterTracker"));
	gd->ReloadState[GENSCR_ST_CHANGE_SCREEN] = true;
	gd->Running = true;
	
	gd = Game->LoadGenericData(Game->GetGenericScript("DeathToSpacebarMap"));
	gd->Running = true;
	
	gd = Game->LoadGenericData(Game->GetGenericScript("GlobalContinue"));
	gd->ReloadState[GENSCR_ST_CONTINUE] = true;
	gd->ReloadState[GENSCR_ST_RELOAD] = true;
	gd->Running = true;
	
	gd = Game->LoadGenericData(Game->GetGenericScript("CutsceneSkipping"));
	gd->ReloadState[GENSCR_ST_CONTINUE] = true;
	gd->ReloadState[GENSCR_ST_RELOAD] = true;
	gd->Running = true;
	
	gd = Game->LoadGenericData(Game->GetGenericScript("ZLinkRead"));
	gd->ReloadState[GENSCR_ST_RELOAD] = true;
	gd->Running = true;
	
	gd = Game->LoadGenericData(Game->GetGenericScript("ZLinkWrite"));
	gd->ReloadState[GENSCR_ST_RELOAD] = true;
	gd->Running = true;
}

void CleanUpGlobals(){
	G[G_NEWLORE] = 0;
}

void ClearPickupGraphics(){
	itemdata id;
	id = Game->LoadItemData(2); //Heart
	id->Tile = GH_BLANK_TILE;
	id = Game->LoadItemData(59); //Magic Jar (Small)
	id->Tile = GH_BLANK_TILE;
	id = Game->LoadItemData(60); //Magic Jar (Large)
	id->Tile = GH_BLANK_TILE;
	id = Game->LoadItemData(78); //Bomb Ammo (5)
	id->Tile = GH_BLANK_TILE;
	id = Game->LoadItemData(79); //Bomb Ammo (10)
	id->Tile = GH_BLANK_TILE;
}

const int TIL_PARTYICONS = 104173;
const int TIL_PARTYICONS_DEAD = 104157;

bool UpdatePartyIcons(){
	for(int i=0; i<3; ++i){
		if(Link->Item[I_ASHER])
			CopyTile(TIL_PARTYICONS+4+i*20, TIL_PARTYICONS+i*20);
		else
			CopyTile(TIL_PARTYICONS+3+i*20, TIL_PARTYICONS+i*20);
		if(Link->Item[I_TORRIN])
			CopyTile(TIL_PARTYICONS+5+i*20, TIL_PARTYICONS+1+i*20);
		else
			CopyTile(TIL_PARTYICONS+3+i*20, TIL_PARTYICONS+1+i*20);
		if(Link->Item[I_KAYLANI])
			CopyTile(TIL_PARTYICONS+6+i*20, TIL_PARTYICONS+2+i*20);
		else
			CopyTile(TIL_PARTYICONS+3+i*20, TIL_PARTYICONS+2+i*20);
	}
	if(Link->Item[I_ASHER]&&G[G_ASHERHP]<=0)
		OverlayTile(TIL_PARTYICONS+20, TIL_PARTYICONS_DEAD);
	if(Link->Item[I_TORRIN]&&G[G_TORRINHP]<=0)
		OverlayTile(TIL_PARTYICONS+21, TIL_PARTYICONS_DEAD);
	if(Link->Item[I_KAYLANI]&&G[G_KAYLANIHP]<=0)
		OverlayTile(TIL_PARTYICONS+22, TIL_PARTYICONS_DEAD);
}

int CanUseChar(int id){
	switch(id){
		case CHAR_ASHER:
			if(Link->Item[I_ASHER]&&G[G_ASHERHP]<=0)
				return 1;
			else if(Link->Item[I_ASHER])
				return 2;
			else
				return 0;
		case CHAR_TORRIN:
			if(Link->Item[I_TORRIN]&&G[G_TORRINHP]<=0)
				return 1;
			else if(Link->Item[I_TORRIN])
				return 2;
			else
				return 0;
		case CHAR_KAYLANI:
			if(Link->Item[I_KAYLANI]&&G[G_KAYLANIHP]<=0)
				return 1;
			else if(Link->Item[I_KAYLANI])
				return 2;
			else
				return 0;
		case CHAR_SOREN:
			if(Link->Item[I_SOREN]&&G[G_SORENHP]<=0)
				return 1;
			else if(Link->Item[I_SOREN])
				return 2;
			else
				return 0;
		case CHAR_TERRY:
			if(Link->Item[I_TERRY]&&G[G_TERRYHP]<=0)
				return 1;
			else if(Link->Item[I_TERRY])
				return 2;
			else
				return 0;
		case CHAR_SIYED:
			if(Link->Item[I_SIYED]&&G[G_SIYEDHP]<=0)
				return 1;
			else if(Link->Item[I_SIYED])
				return 2;
			else
				return 0;
	}
}

const int CHAR_ASHER = 0;
const int CHAR_TORRIN = 1;
const int CHAR_KAYLANI = 2;
const int CHAR_SOREN = 3;
const int CHAR_TERRY = 4;
const int CHAR_SIYED = 5;

void UpdateCharSwap(){
	bool charsChanged;
	if(CanUseChar(CHAR_ASHER)!=G[G_PARTY_ASHER]){
		G[G_PARTY_ASHER] = CanUseChar(CHAR_ASHER);
		charsChanged = true;
	}
	if(CanUseChar(CHAR_TORRIN)!=G[G_PARTY_TORRIN]){
		G[G_PARTY_TORRIN] = CanUseChar(CHAR_TORRIN);
		charsChanged = true;
	}
	if(CanUseChar(CHAR_KAYLANI)!=G[G_PARTY_KAYLANI]){
		G[G_PARTY_KAYLANI] = CanUseChar(CHAR_KAYLANI);
		charsChanged = true;
	}
	if(CanUseChar(CHAR_SOREN)!=G[G_PARTY_SOREN]){
		G[G_PARTY_SOREN] = CanUseChar(CHAR_SOREN);
		charsChanged = true;
	}
	if(CanUseChar(CHAR_TERRY)!=G[G_PARTY_TERRY]){
		G[G_PARTY_TERRY] = CanUseChar(CHAR_TERRY);
		charsChanged = true;
	}
	if(CanUseChar(CHAR_SIYED)!=G[G_PARTY_SIYED]){
		G[G_PARTY_SIYED] = CanUseChar(CHAR_SIYED);
		charsChanged = true;
	}
	// if(charsChanged)
		// UpdatePartyIcons();
	
	bool deathSwap;
	if(Link->HP<=0&&NumPlayableChars()>1){
		deathSwap = true;
		Link->HP = 1;
	}
	if(deathSwap||G[G_FORCECHARSWAP]>-1||((CanSwapChar())&&Link->CollDetection)){
		if(Link->PressL||Link->PressR||deathSwap||G[G_FORCECHARSWAP]>-1){
			int oldID = GetCharID();
			int newID = oldID;
			bool breakloop;
			int swapdir;
			if(Link->PressL)
				swapdir = -1;
			else if(Link->PressR||deathSwap)
				swapdir = 1;
			if(G[G_FORCECHARSWAP]>-1){
				eweapon e = CreateEWeaponAt(EW_SCRIPT10, 120, 80);
				e->CollDetection = false;
				e->DrawYOffset = -1000;
					
				RunEWeaponScript(e, "CharacterChange", {G[G_FORCECHARSWAP], 0});
				G[G_FORCECHARSWAP] = -1;
			}
			else{
				newID = GetSwapCharID(oldID, swapdir, false);
				if(newID != oldID){
					eweapon e = CreateEWeaponAt(EW_SCRIPT10, 120, 80);
					e->CollDetection = false;
					e->DrawYOffset = -1000;
						
					RunEWeaponScript(e, "CharacterChange", {newID, deathSwap?1:0});
				}
			}
		}
	}
}

void UpdateDeath(){
	if(G[G_DIENEXTFRAME]){
		genericdata gd = Game->LoadGenericData(Game->GetGenericScript("GameOver"));
		gd->RunFrozen();
	}
	else if(Link->HP<=0){
		for(int i=Screen->NumNPCs(); i>0; --i){
			npc n = Screen->LoadNPC(i);
			if(n->ID==240){
				n->StopBGSFX();
			}
		}
		Link->Invisible = true;
		G[G_DRAWNHPZERO] = 8;
		Link->HP = 1;
		G[G_DIENEXTFRAME] = 1;
	}
}

void UpdateContinue(){
	Game->LastEntranceDMap = G[G_LASTENTRANCEDMAP];
	Game->LastEntranceScreen = G[G_LASTENTRANCESCREEN];
	Game->ContinueDMap = G[G_CONTINUEDMAP];
	Game->ContinueScreen = G[G_CONTINUESCREEN];
}

void Layer7Blackout_Update(){
	if(G[G_BLACKOUTLAYER7]){
		switch(G[G_BLACKOUTLAYER7]){
			case 64:
				Screen->Rectangle(7, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
				break;
			case 96:
				Screen->Rectangle(7, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
				Screen->Rectangle(7, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
				break;
			case 128:
				Screen->Rectangle(7, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
				break;
		}
		G[G_BLACKOUTLAYER7] = 0;
	}
}

int GetCharID(){
	if(Link->Item[I_SIYED_MOD])
		return CHAR_SIYED;
	if(Link->Item[I_TERRY_MOD])
		return CHAR_TERRY;
	if(Link->Item[I_SOREN_MOD])
		return CHAR_SOREN;
	if(Link->Item[I_KAYLANI_MOD])
		return CHAR_KAYLANI;
	if(Link->Item[I_TORRIN_MOD])
		return CHAR_TORRIN;
	return CHAR_ASHER;
}

int GetSwapCharID(int oldID, int swapdir, bool noFullHP){
	bool breakloop;
	int newID = oldID;
	for(int i=0; i<6&&!breakloop; ++i){
		newID += swapdir;
		if(newID<0)
			newID = 5;
		if(newID>5)
			newID = 0;
		switch(newID){
			case CHAR_ASHER:
				if(Link->Item[I_ASHER]&&G[G_ASHERHP]>0&&(!noFullHP||G[G_ASHERHP]<G[G_ASHERMAXHP]))
					breakloop = true;
				break;
			case CHAR_TORRIN:
				if(Link->Item[I_TORRIN]&&G[G_TORRINHP]>0&&(!noFullHP||G[G_TORRINHP]<G[G_TORRINMAXHP]))
					breakloop = true;
				break;
			case CHAR_KAYLANI:
				if(Link->Item[I_KAYLANI]&&G[G_KAYLANIHP]>0&&(!noFullHP||G[G_KAYLANIHP]<G[G_KAYLANIMAXHP]))
					breakloop = true;
				break;
			case CHAR_SOREN:
				if(Link->Item[I_SOREN]&&G[G_SORENHP]>0&&(!noFullHP||G[G_SORENHP]<G[G_SORENMAXHP]))
					breakloop = true;
				break;
			case CHAR_TERRY:
				if(Link->Item[I_TERRY]&&G[G_TERRYHP]>0&&(!noFullHP||G[G_TERRYHP]<G[G_TERRYMAXHP]))
					breakloop = true;
				break;
			case CHAR_SIYED:
				if(Link->Item[I_SIYED]&&G[G_SIYEDHP]>0&&(!noFullHP||G[G_SIYEDHP]<G[G_SIYEDMAXHP]))
					breakloop = true;
				break;
		}
	}
	return newID;
}

bool HasChar(int id){
	switch(id){
		case CHAR_ASHER:
			return Link->Item[I_ASHER];
		case CHAR_TORRIN:
			return Link->Item[I_TORRIN];
		case CHAR_KAYLANI:
			return Link->Item[I_KAYLANI];
		case CHAR_SOREN:
			return Link->Item[I_SOREN];
		case CHAR_TERRY:
			return Link->Item[I_TERRY];
		case CHAR_SIYED:
			return Link->Item[I_SIYED];
	}
	return false;
}

int NumCharsAlive(){
	int count;
	for(int i=0; i<6; ++i){
		if(CharAlive(i))
			++count;
	}
	return count;
}

bool CharAlive(int id){
	switch(id){
		case CHAR_ASHER:
			return Link->Item[I_ASHER]&&G[G_ASHERHP]>0;
		case CHAR_TORRIN:
			return Link->Item[I_TORRIN]&&G[G_TORRINHP]>0;
		case CHAR_KAYLANI:
			return Link->Item[I_KAYLANI]&&G[G_KAYLANIHP]>0;
		case CHAR_SOREN:
			return Link->Item[I_SOREN]&&G[G_SORENHP]>0;
		case CHAR_TERRY:
			return Link->Item[I_TERRY]&&G[G_TERRYHP]>0;
		case CHAR_SIYED:
			return Link->Item[I_SIYED]&&G[G_SIYEDHP]>0;
	}
	return false;
}

void SetCharacter(int id, bool deathSwap){
	int oldID = GetCharID();
	switch(oldID){
		case CHAR_ASHER:
			G[G_ASHERHP] = Link->HP;
			G[G_ASHERMP] = Link->MP;
			if(deathSwap)
				G[G_ASHERHP] = 0;
			G[G_ASHERMAXHP] = Link->MaxHP;
			break;
		case CHAR_TORRIN:
			G[G_TORRINHP] = Link->HP;
			G[G_TORRINMP] = 0;
			if(deathSwap)
				G[G_TORRINHP] = 0;
			G[G_TORRINMAXHP] = Link->MaxHP;
			break;
		case CHAR_KAYLANI:
			G[G_KAYLANIHP] = Link->HP;
			G[G_KAYLANIMP] = Link->MP;
			if(deathSwap)
				G[G_KAYLANIHP] = 0;
			G[G_KAYLANIMAXHP] = Link->MaxHP;
			break;
		case CHAR_SOREN:
			G[G_SORENHP] = Link->HP;
			if(deathSwap)
				G[G_SORENHP] = 0;
			G[G_SORENMAXHP] = Link->MaxHP;
			break;
		case CHAR_TERRY:
			G[G_TERRYHP] = Link->HP;
			if(deathSwap)
				G[G_TERRYHP] = 0;
			G[G_TERRYMAXHP] = Link->MaxHP;
			break;
		case CHAR_SIYED:
			G[G_SIYEDHP] = Link->HP;
			G[G_SIYEDMP] = Link->MP;
			if(deathSwap)
				G[G_SIYEDHP] = 0;
			G[G_SIYEDMAXHP] = Link->MaxHP;
			break;
	}
	Link->Item[I_TORRIN_MOD] = false;
	Link->Item[I_KAYLANI_MOD] = false;
	Link->Item[I_SOREN_MOD] = false;
	Link->Item[I_TERRY_MOD] = false;
	Link->Item[I_SIYED_MOD] = false;
	switch(id){
		case CHAR_ASHER:
			Link->MaxHP = G[G_ASHERMAXHP];
			Link->HP = G[G_ASHERHP];
			Link->MP = G[G_ASHERMP];
			break;
		case CHAR_TORRIN:
			Link->MaxHP = G[G_TORRINMAXHP];
			Link->HP = G[G_TORRINHP];
			Link->MP = 0;
			Link->Item[I_TORRIN_MOD] = true;
			break;
		case CHAR_KAYLANI:
			Link->MaxHP = G[G_KAYLANIMAXHP];
			Link->HP = G[G_KAYLANIHP];
			Link->MP = G[G_KAYLANIMP];
			Link->Item[I_KAYLANI_MOD] = true;
			break;
		case CHAR_SOREN:
			Link->MaxHP = G[G_SORENMAXHP];
			Link->HP = G[G_SORENHP];
			Link->MP = 0;
			Link->Item[I_SOREN_MOD] = true;
			break;
		case CHAR_TERRY:
			Link->MaxHP = G[G_TERRYMAXHP];
			Link->HP = G[G_TERRYHP];
			Link->MP = 0;
			Link->Item[I_TERRY_MOD] = true;
			break;
		case CHAR_SIYED:
			Link->MaxHP = G[G_SIYEDMAXHP];
			Link->HP = G[G_SIYEDHP];
			Link->MP = G[G_SIYEDMP];
			Link->Item[I_SIYED_MOD] = true;
			break;
	}
	DamageNumbers[_DNUM_LASTLINKHP] = Link->HP;
	UpdateCharacterItems(id, oldID, true);
}

const int I_NOTHING = 176;

bool CheckInvalidItem(int which){
	switch(which){
		case 152: //Abilities
		case 153:
		case 154:
		case 10: //Candle
		case 159: //Bomb
		case 160: //Gauntlet
		case 161: //Wand
			return true;
	}
	if(which<0)
		return true;
	return false;
}

bool ItemOnTwoButtons(int which){
	int count;
	if(Link->ItemA==which)
		++count;
	if(Link->ItemB==which)
		++count;
	if(Link->ItemX==which)
		++count;
	if(Link->ItemY==which)
		++count;
	return count>1;
}

bool CharacterSpecificItem(int charID, int itemID, int itemChars){
	switch(itemID){
		case I_ABILITY_A_ASHER:
			if(charID==CHAR_SOREN)
				return true;
			break;
		case I_SWORD_TORRIN:
		case I_ABILITY_A_TORRIN:
		case I_ABILITY_B_TORRIN:
			if(charID==CHAR_TERRY)
				return true;
			break;
		case I_SWORD_SOREN2:
			if(charID==CHAR_SOREN)
				return true;
			break;
		case I_SWORD_TERRY2:
			if(charID==CHAR_TERRY)
				return true;
			break;
		case I_SWORD_KAYLANI:
			if(charID==CHAR_SIYED)
				return true;
			break;
	}
	return itemChars[itemID]==charID;
}

bool UpdateCharacterItems(int id, int oldID, bool trackFound){
	if(trackFound){
		int itemChars[256];
		for(int i=0; i<256; ++i)
			itemChars[i] = -1;
		itemChars[I_SWORD_TORRIN] = CHAR_TORRIN;
		itemChars[I_SWORD_TORRIN2] = CHAR_TORRIN;
		itemChars[I_SWORD_KAYLANI] = CHAR_KAYLANI;
		itemChars[I_SWORD_KAYLANI2] = CHAR_KAYLANI;
		
		itemChars[I_ABILITY_A_ASHER] = CHAR_ASHER;
		itemChars[I_ABILITY_B_ASHER] = CHAR_ASHER;
		itemChars[I_ABILITY_C_ASHER] = CHAR_ASHER;
		
		itemChars[I_ABILITY_A_TORRIN] = CHAR_TORRIN;
		itemChars[I_ABILITY_B_TORRIN] = CHAR_TORRIN;
		itemChars[I_ABILITY_C_TORRIN] = CHAR_TORRIN;
		
		itemChars[I_ABILITY_A_KAYLANI] = CHAR_KAYLANI;
		itemChars[I_ABILITY_B_KAYLANI] = CHAR_KAYLANI;
		itemChars[I_ABILITY_C_KAYLANI] = CHAR_KAYLANI;
		
		for(int i=0; i<256; ++i){
			if(Link->Item[i])
				FoundItems[i] = true;
			if(CharacterSpecificItem(id, i, itemChars)){
				if(FoundItems[i])
					Link->Item[i] = true;
			}
			else if(itemChars[i]>-1)
				Link->Item[i] = false;
		}
	}
	if(CheckInvalidItem(Link->ItemY)||ItemOnTwoButtons(Link->ItemY))
		Link->ItemY = I_NOTHING;
	if(CheckInvalidItem(Link->ItemX)||ItemOnTwoButtons(Link->ItemX))
		Link->ItemX = I_NOTHING;
	if(CheckInvalidItem(Link->ItemB)||ItemOnTwoButtons(Link->ItemB))
		Link->ItemB = I_NOTHING;
	if(CheckInvalidItem(Link->ItemA)||ItemOnTwoButtons(Link->ItemA))
		Link->ItemA = I_NOTHING;
	switch(id){
		case CHAR_ASHER:
			SetButtonItem(0, G[G_ITEMA_ASHER]);
			SetButtonItem(1, G[G_ITEMB_ASHER]);
			SetButtonItem(2, G[G_ITEMX_ASHER]);
			SetButtonItem(3, G[G_ITEMY_ASHER]);
			break;
		case CHAR_TORRIN:
			SetButtonItem(0, G[G_ITEMA_TORRIN]);
			SetButtonItem(1, G[G_ITEMB_TORRIN]);
			SetButtonItem(2, G[G_ITEMX_TORRIN]);
			SetButtonItem(3, G[G_ITEMY_TORRIN]);
			break;
		case CHAR_KAYLANI:
			SetButtonItem(0, G[G_ITEMA_KAYLANI]);
			SetButtonItem(1, G[G_ITEMB_KAYLANI]);
			SetButtonItem(2, G[G_ITEMX_KAYLANI]);
			SetButtonItem(3, G[G_ITEMY_KAYLANI]);
			break;
		case CHAR_SOREN:
			SetButtonItem(0, G[G_ITEMA_SOREN]);
			SetButtonItem(1, G[G_ITEMB_SOREN]);
			SetButtonItem(2, G[G_ITEMX_SOREN]);
			SetButtonItem(3, G[G_ITEMY_SOREN]);
			break;
		case CHAR_TERRY:
			SetButtonItem(0, G[G_ITEMA_TERRY]);
			SetButtonItem(1, G[G_ITEMB_TERRY]);
			SetButtonItem(2, G[G_ITEMX_TERRY]);
			SetButtonItem(3, G[G_ITEMY_TERRY]);
			break;
		case CHAR_SIYED:
			SetButtonItem(0, G[G_ITEMA_SIYED]);
			SetButtonItem(1, G[G_ITEMB_SIYED]);
			SetButtonItem(2, G[G_ITEMX_SIYED]);
			SetButtonItem(3, G[G_ITEMY_SIYED]);
			break;
	}
}

int NumPlayableChars(){
	int numChars;
	if(Link->Item[I_ASHER]&&G[G_ASHERHP]>0)
		++numChars;
	if(Link->Item[I_TORRIN]&&G[G_TORRINHP]>0)
		++numChars;
	if(Link->Item[I_KAYLANI]&&G[G_KAYLANIHP]>0)
		++numChars;
	if(Link->Item[I_SOREN]&&G[G_SORENHP]>0)
		++numChars;
	if(Link->Item[I_TERRY]&&G[G_TERRYHP]>0)
		++numChars;
	if(Link->Item[I_SIYED]&&G[G_SIYEDHP]>0)
		++numChars;
	return numChars;
}

void UpdateForceDir(){
	if(G[G_FORCEDIR]>-1){
		if(Link->Action==LA_WALKING)
			G[G_TORRINWALKING] = 1;
		if(Link->Action==LA_NONE||Link->Action==LA_WALKING)
			Link->Dir = G[G_FORCEDIR];
		G[G_FORCEDIR] = -1;
	}
}

void UpdateSwimming(){
	if(Link->Action==LA_SWIMMING){
		if(G[G_SWIMCOUNTER]){
			int step = Lerp(0, 1.5, G[G_SWIMCOUNTER]/32);
			LinkMovement_Push2(VectorX(step, DirAngle(G[G_SWIMDIR])), VectorY(step, DirAngle(G[G_SWIMDIR])));
			--G[G_SWIMCOUNTER];
		}
		if(Link->PressB&&G[G_SWIMCOUNTER]<=16){
			int vX = (Link->InputLeft?-1:0) + (Link->InputRight?1:0);
			int vY = (Link->InputUp?-1:0) + (Link->InputDown?1:0);
			if(vX==0&&vY==0)
				G[G_SWIMDIR] = Link->Dir;
			else
				G[G_SWIMDIR] = AngleDir8(Angle(0, 0, vX, vY));
			Game->PlaySound(175);
			G[G_SWIMCOUNTER] = 32;
		}
	}
	else{
		G[G_SWIMCOUNTER] = 0;
	}
}

void UpdateStepMod(){
	if(G[G_SIYEDUPDRAFT]){
		G[G_STEPMOD] += 1.5;
		G[G_SIYEDUPDRAFT] = 0;
	}
	if(GetCharID()==CHAR_TERRY){
		if(G[G_TERRYSPEEDTIMER]){
			--G[G_TERRYSPEEDTIMER];
			G[G_STEPMOD] += Lerp(1, 0.2, 1-(G[G_TERRYSPEEDTIMER]/90));
		}
	}
	else
		G[G_TERRYSPEEDTIMER] = 0;
	if(HasAugment(I_AUGMENT_SPEED))
		G[G_STEPMOD] += 0.2;
	if(G[G_STEPMOD]!=0){
		G[G_STEPMOD] = Clamp(G[G_STEPMOD], -1.4, 2);
		LinkMovement_SetLinkSpeedBoost(G[G_STEPMOD]);
	}
	G[G_STEPMOD] = 0;
}

void GlobalNoWalkWithTurning(){
	int inputX = (G[G_LEFTINPUT]?-1:0) + (G[G_RIGHTINPUT]?1:0);
	int inputY = (G[G_UPINPUT]?-1:0) + (G[G_DOWNINPUT]?1:0);
	int dir8 = AngleDir8(Angle(0, 0, inputX, inputY));
	if((inputX!=0||inputY!=0)&&CanAttack()){
		Link->Dir = Dir8ToDir4(dir8, Link->Dir);
	}
	G[G_NOWALK] = 1;
}

void UpdateMagnet(){
	if(G[G_RERUNTIDALGAUNTLET]){
		if(Link->Item[I_TIDALGAUNTLETSUN])
			RunItemActiveScript(I_TIDALGAUNTLETSUN);
		else 
			RunItemActiveScript(I_TIDALGAUNTLETMOON);
	}
	if(G[G_MAGNETPULL]!=0||G[G_SPECIALMAGNETPULL]){
		G[G_MAGNETPULLFLOAT] = TIDALGAUNTLET_FLOATFRAMES;
		G[G_MAGNETPULLATTACKLENIENCY] = 1;
	}
	if(G[G_MAGNETPULLFLOAT]){
		if(Link->Action==LA_ATTACKING&&G[G_MAGNETPULLATTACKLENIENCY]){
			G[G_MAGNETPULLFLOAT] = TIDALGAUNTLET_FLOATFRAMES;
			G[G_MAGNETPULLATTACKLENIENCY] = 0;
		}
		Link->Z = 2;
		Link->Jump = 0;
		GlobalNoWalkWithTurning();
		--G[G_MAGNETPULLFLOAT];
	}
	if(G[G_SPECIALMAGNETPULL])
		--G[G_SPECIALMAGNETPULL];
	if(G[G_MAGNETACTIVE])
		--G[G_MAGNETACTIVE];
	G[G_MAGNETPULL] = 0;
}

void MakeLinkInvisible(int frames){
	Link->Invisible = true;
	G[G_INVISTIMER] = Max(G[G_INVISTIMER], frames);
}

void TurnOffLinkCollision(int frames){
	Link->CollDetection = false;
	G[G_COLLTIMER] = Max(G[G_COLLTIMER], frames);
}

void SetLinkScriptTile(int tile, int flip, int frames){
	Link->ScriptTile = tile;
	Link->ScriptFlip = flip;
	G[G_SCRIPTTILETIMER] = Max(G[G_SCRIPTTILETIMER], frames);
}

void SetLinkPitImmune(int frames){
	Link->MoveFlags[HEROMV_CAN_PITFALL] = false;
	G[G_LINKPITIMMUNITY] = Max(G[G_LINKPITIMMUNITY], frames);
}

void UpdateTempState(){
	if(G[G_INVISTIMER]&&Link->Action!=LA_SCROLLING){
		--G[G_INVISTIMER];
		if(!G[G_INVISTIMER])
			Link->Invisible = false;
	}
	if(G[G_COLLTIMER]){
		--G[G_COLLTIMER];
		if(!G[G_COLLTIMER])
			Link->CollDetection = true;
	}
	if(G[G_SCRIPTTILETIMER]){
		--G[G_SCRIPTTILETIMER];
		if(!G[G_SCRIPTTILETIMER]){
			Link->ScriptTile = -1;
			Link->ScriptFlip = -1;
		}
	}
	if(G[G_LINKPITIMMUNITY]){
		--G[G_LINKPITIMMUNITY];
		if(!G[G_LINKPITIMMUNITY]){
			Link->MoveFlags[HEROMV_CAN_PITFALL] = true;
		}
	}
	if(G[G_DRAWNHPZERO]>0)
		--G[G_DRAWNHPZERO];
	if(G[G_DASHINTERRUPT])
		--G[G_DASHINTERRUPT];
	if(G[G_REDORBINTERRUPT])
		--G[G_REDORBINTERRUPT];
	if(G[G_DEATHIFRAMES]){
		if(G[G_ANIM]%4<2)
			MakeLinkInvisible(1);
		TurnOffLinkCollision(1);
		--G[G_DEATHIFRAMES];
	}
	G[G_VUNTERSLAUSHCOLLISIONS] = 0;
	if(G[G_BURN_ASHER])
		--G[G_BURN_ASHER];
	if(G[G_BURN_TORRIN])
		--G[G_BURN_TORRIN];
	if(G[G_BURN_KAYLANI])
		--G[G_BURN_KAYLANI];
	G[G_ITEMPOPUPS] = 0;
	if(G[G_OUTFITMENUOPEN])
		--G[G_OUTFITMENUOPEN];
	if(G[G_BESTIARYCOOLDOWN])
		--G[G_BESTIARYCOOLDOWN];
	G[G_CUTSCENESKIPFIRSTFRAME] = 0;
}

void UpdateGlobalInput(){
	if(G[G_ENDAPRESS]){
		if(!Link->InputA)
			G[G_ENDAPRESS] = 0;
		else{
			Link->PressA = false;
			Link->InputA = false;
		}
	}
	if(G[G_ENDBPRESS]){
		if(!Link->InputB)
			G[G_ENDBPRESS] = 0;
		else{
			Link->PressB = false;
			Link->InputB = false;
		}
	}
	if(G[G_ENDXPRESS]){
		if(!Link->InputEx1)
			G[G_ENDXPRESS] = 0;
		else{
			Link->PressEx1 = false;
			Link->InputEx1 = false;
		}
	}
	if(G[G_ENDYPRESS]){
		if(!Link->InputEx2)
			G[G_ENDYPRESS] = 0;
		else{
			Link->PressEx2 = false;
			Link->InputEx2 = false;
		}
	}
	
	G[G_UPINPUT] = Link->InputUp?(Link->PressUp?2:1):0;
	G[G_DOWNINPUT] = Link->InputDown?(Link->PressDown?2:1):0;
	G[G_LEFTINPUT] = Link->InputLeft?(Link->PressLeft?2:1):0;
	G[G_RIGHTINPUT] = Link->InputRight?(Link->PressRight?2:1):0;
	G[G_AINPUT] = Link->InputA?(Link->PressA?2:1):0;
	G[G_BINPUT] = Link->InputB?(Link->PressB?2:1):0;
	G[G_XINPUT] = Link->InputEx1?(Link->PressEx1?2:1):0;
	G[G_YINPUT] = Link->InputEx2?(Link->PressEx2?2:1):0;
	if(G[G_NOWALK])
		NoWalk();
	if(G[G_NOACTION])
		NoAction();
	G[G_NOWALK] = 0;
	G[G_NOACTION] = 0;
}

void UpdateReplacementSwords(){
	if(!CanAttack())
		return;
	if(Link->PressA){
		switch(Link->ItemA){
			case I_SWORD_TORRIN:
			case I_SWORD_TORRIN2:
			case I_SWORD_KAYLANI:
			case I_SWORD_KAYLANI2:
			case I_SWORD_TERRY2:
			case I_SWORD_SIYED2:
				RunItemActiveScript(Link->ItemA);
				break;
		}
	}
	if(Link->PressB){
		switch(Link->ItemB){
			case I_SWORD_TORRIN:
			case I_SWORD_TORRIN2:
			case I_SWORD_KAYLANI:
			case I_SWORD_KAYLANI2:
			case I_SWORD_TERRY2:
			case I_SWORD_SIYED2:
				RunItemActiveScript(Link->ItemB);
				break;
		}
	}
	if(Link->PressEx1){
		switch(Link->ItemX){
			case I_SWORD_TORRIN:
			case I_SWORD_TORRIN2:
			case I_SWORD_KAYLANI:
			case I_SWORD_KAYLANI2:
			case I_SWORD_TERRY2:
			case I_SWORD_SIYED2:
				RunItemActiveScript(Link->ItemX);
				break;
		}
	}
	if(Link->PressEx2){
		switch(Link->ItemY){
			case I_SWORD_TORRIN:
			case I_SWORD_TORRIN2:
			case I_SWORD_KAYLANI:
			case I_SWORD_KAYLANI2:
			case I_SWORD_TERRY2:
			case I_SWORD_SIYED2:
				RunItemActiveScript(Link->ItemY);
				break;
		}
	}
}

void UpdateActiveItems(){
	switch(GetCharID()){
		case CHAR_ASHER:
			SetButtonItem(0, G[G_ITEMA_ASHER]);
			SetButtonItem(1, G[G_ITEMB_ASHER]);
			SetButtonItem(2, G[G_ITEMX_ASHER]);
			SetButtonItem(3, G[G_ITEMY_ASHER]);
			break;
		case CHAR_TORRIN:
			SetButtonItem(0, G[G_ITEMA_TORRIN]);
			SetButtonItem(1, G[G_ITEMB_TORRIN]);
			SetButtonItem(2, G[G_ITEMX_TORRIN]);
			SetButtonItem(3, G[G_ITEMY_TORRIN]);
			break;
		case CHAR_KAYLANI:
			SetButtonItem(0, G[G_ITEMA_KAYLANI]);
			SetButtonItem(1, G[G_ITEMB_KAYLANI]);
			SetButtonItem(2, G[G_ITEMX_KAYLANI]);
			SetButtonItem(3, G[G_ITEMY_KAYLANI]);
			break;
		case CHAR_SOREN:
			SetButtonItem(0, G[G_ITEMA_SOREN]);
			SetButtonItem(1, G[G_ITEMB_SOREN]);
			SetButtonItem(2, G[G_ITEMX_SOREN]);
			SetButtonItem(3, G[G_ITEMY_SOREN]);
			break;
		case CHAR_TERRY:
			SetButtonItem(0, G[G_ITEMA_TERRY]);
			SetButtonItem(1, G[G_ITEMB_TERRY]);
			SetButtonItem(2, G[G_ITEMX_TERRY]);
			SetButtonItem(3, G[G_ITEMY_TERRY]);
			break;
		case CHAR_SIYED:
			SetButtonItem(0, G[G_ITEMA_SIYED]);
			SetButtonItem(1, G[G_ITEMB_SIYED]);
			SetButtonItem(2, G[G_ITEMX_SIYED]);
			SetButtonItem(3, G[G_ITEMY_SIYED]);
			break;
	}
}

const int TIL_TORRINLOCKON = 65050;

void UpdateTorrinLockon(){
	bool scriptWalking;
	if(G[G_TORRINLOCKON]){
		if(G[G_TORRINLOCKONTARGET]>0&&GetCharID()==CHAR_TORRIN){
			npc target = Screen->LoadNPCByUID(G[G_TORRINLOCKONTARGET]);
			if(target->isValid()){
				int tX = HitboxCenterX(target)-8;
				int tY = HitboxCenterY(target)-8-GhostGet(target, GG_Z);
				Screen->FastTile(6, tX, tY, TIL_TORRINLOCKON+Floor((G[G_ANIM]%4)/2), 8, 128);
				G[G_FORCEDIR] = AngleDir4(Angle(Link->X, Link->Y, tX, tY));
				int vX = (HitboxCenterX(target)-8)-G[G_TORRINLOCKONTARGETX];
				int vY = (HitboxCenterY(target)-8)-G[G_TORRINLOCKONTARGETY];
				vX = (Abs(vX)<=8)?Min(vX, 4):0;
				vY = (Abs(vY)<=8)?Min(vY, 4):0;
				int frame = (Floor(G[G_TORRINLOCKONWALKCOUNTER]/7)%4);
				if(Link->Action==LA_NONE||Link->Action==LA_WALKING){
					if(frame==2)
						frame = 0;
					if(frame==3)
						frame = 2;
					switch(Link->Dir){
						case DIR_UP:
							SetLinkScriptTile(104186+frame, 0, 2);
							break;
						case DIR_DOWN:
							SetLinkScriptTile(104180+frame, 0, 2);
							break;
						case DIR_LEFT:
							SetLinkScriptTile(104183+frame, 0, 2);
							break;
						case DIR_RIGHT:
							SetLinkScriptTile(104183+frame, 1, 2);
							break;
					}
				}
				if(vX!=0||vY!=0){
					scriptWalking = true;
					if((Link->Action==LA_NONE||Link->Action==LA_WALKING)&&!G[G_TORRINLOCKONDISABLEMOVE]){
						LinkMovement_Push2(vX, vY);
						G[G_STEPMOD] += 0.5;
					}
				}
				G[G_TORRINLOCKONDISABLEMOVE] = 0;
				G[G_TORRINLOCKONTARGETX] = HitboxCenterX(target)-8;
				G[G_TORRINLOCKONTARGETY] = HitboxCenterY(target)-8;
			}
			else
				G[G_TORRINLOCKON] = 0;
		}
		else
			G[G_TORRINLOCKON] = 0;
	}
	if(G[G_TORRINWALKING]||scriptWalking){
		G[G_TORRINLOCKONWALKCOUNTER] = (G[G_TORRINLOCKONWALKCOUNTER]+1)%28;
	}
	G[G_TORRINWALKING] = 0;
}

void UpdateTorrinTelekinesis(){
	if(G[G_TORRINTELEKINESIS]){
		G[G_STEPMOD] -= 0.7;
	}
	G[G_TORRINTELEKINESIS] = 0;
}

const int TIL_LIFEMETER = 912;
const int TIL_LIFEMETER_PIECES = 892;

const int TIL_MAGICMETER = 932;
const int TIL_MAGICMETER_PIECES = 1020;

void UpdateHUDCopytiles(){
	if(FoundItems[I_ABILITY_C_ASHER]){
		if(Meteor.CanCast()||HasAugment(I_AUGMENT_MINIOR)){
			CopyTile(65138, 65130);
		}
		else{
			CopyTile(65137, 65130);
		}
	}
	
	UpdateBatteryTiles();
	if(G[G_LUNARANGCOOLDOWN]){
		--G[G_LUNARANGCOOLDOWN];
		UpdateLunarangTiles(false);
	}
	
	int hp = Link->HP;
	if(G[G_DRAWNHPZERO])
		hp = 0;
	int maxHearts = Floor(Link->MaxHP/16);
	int currentHeart = Floor(hp/16);
	for(int i=0; i<7; ++i){
		if(i==currentHeart&&i<maxHearts){
			if(hp<=0)
				CopyTile(TIL_LIFEMETER_PIECES+4, TIL_LIFEMETER+i);
			else
				CopyTile(TIL_LIFEMETER_PIECES+4-Ceiling((hp%16)/4), TIL_LIFEMETER+i);
		}
		else if(i<currentHeart){
			CopyTile(TIL_LIFEMETER_PIECES, TIL_LIFEMETER+i);
		}
		else if(i<maxHearts){
			CopyTile(TIL_LIFEMETER_PIECES+4, TIL_LIFEMETER+i);
		}
		else{
			CopyTile(TIL_LIFEMETER_PIECES+5, TIL_LIFEMETER+i);
		}
	}
	
	int currentBar = Floor(Link->MP/64);
	bool noMagic;
	if(GetCharID()==CHAR_TORRIN||(GetCharID()==CHAR_ASHER&&!Link->Item[I_ABILITY_B_ASHER]&&!G[G_RANDOMIZERENABLED])||GetCharID()==CHAR_SOREN||GetCharID()==CHAR_TERRY)
		noMagic = true;
	if(noMagic){
		CopyTile(GH_BLANK_TILE, TIL_MAGICMETER-1);
		CopyTile(GH_BLANK_TILE, TIL_MAGICMETER+5);
	}
	else{
		CopyTile(TIL_MAGICMETER_PIECES+18, TIL_MAGICMETER-1);
		CopyTile(TIL_MAGICMETER_PIECES+19, TIL_MAGICMETER+5);
	}
	for(int i=0; i<5; ++i){
		if(i==currentBar){
			if(Link->MP==0)
				CopyTile(TIL_MAGICMETER_PIECES+17, TIL_MAGICMETER+i);
			else
				CopyTile(TIL_MAGICMETER_PIECES+16-Floor((Link->MP%64)/4), TIL_MAGICMETER+i);
			
		}
		else if(i<currentBar){
			CopyTile(TIL_MAGICMETER_PIECES, TIL_MAGICMETER+i);
		}
		else{
			CopyTile(TIL_MAGICMETER_PIECES+17, TIL_MAGICMETER+i);
		}
		if(noMagic)
			CopyTile(GH_BLANK_TILE, TIL_MAGICMETER+i);
	}
}

void UpdateScreenChange(){
	G[G_SCREENCHANGED] = 0;
	G[G_DMAPCHANGED] = 0;
	if(G[G_LASTSCREEN]!=Game->GetCurScreen()||G[G_LASTDMAP]!=Game->GetCurDMap()){
		G[G_SCREENCHANGED] = 1;
		if(G[G_LASTDMAP]!=Game->GetCurDMap())
			G[G_DMAPCHANGED] = 1;
		for(int i=0; i<100; ++i){
			TempBMP[i]->Create(0, 1, 1);
			TempBMPFree[i] = 2;
		}
		
		if(Link->Action==LA_SCROLLING){
			G[G_SCREENCHANGEDSCROLLING] = 1;
		}
		else{
			UpdateMeteorBurning();
			UpdateAreaLoreTracking();
		}
		if(G[G_TEMPLASTENTRANCE]){
			if(Game->GetCurDMap()!=G[G_LASTENTRANCEDMAP]||Game->GetCurScreen()!=G[G_LASTENTRANCESCREEN]){
				G[G_TEMPLASTENTRANCE] = 0;
				G[G_LASTENTRANCEDMAP] = G[G_CONTINUEDMAP];
				G[G_LASTENTRANCESCREEN] = G[G_CONTINUESCREEN];
			}
		}
		UpdateOverUnderScreens();
		G[G_FROZENTIMER] = 0;
		G[G_BOSSDEATHS] = 0;
		G[G_BOSSEASYMODE] = 0;
		
		G[G_LASTSCREEN] = Game->GetCurScreen();
		G[G_LASTDMAP] = Game->GetCurDMap();
	}
	if(G[G_SCREENCHANGEDSCROLLING]){
		if(Link->Action!=LA_SCROLLING){
			UpdateFFCCarryover();
			UpdateMeteorBurning();
			UpdateAreaLoreTracking();
			
			G[G_SCREENCHANGEDSCROLLING] = 0;
		}
	}
	if(G[G_DMAPCHANGED]){
		Costumes_Update();
	}
	UpdateMeteorBurningConstant();
}

void UpdateMeteorBurning(){
	if(G[G_METEOREFFECTSFRAMES]&&Game->DMapFlags[Game->GetCurDMap()]&DMF_IS_OVERWORLD){
		eweapon e = CreateEWeaponAt(EW_SCRIPT10, 120, 80);
		e->CollDetection = false;
		e->DrawYOffset = -1000;
		RunEWeaponScript(e, "MeteorBurning", 0);
	}
}

void UpdateMeteorBurningConstant(){
	if(G[G_METEOREFFECTSFRAMES])
		--G[G_METEOREFFECTSFRAMES];
	if(Game->DMapFlags[Game->GetCurDMap()]&DMF_IS_OVERWORLD){
		if(G[G_METEOREFFECTSFRAMES]>=64||G[G_METEOREFFECTSFRAMES]%4>=2){
			Screen->Rectangle(6, 0, 0, 255, 175, 0x83, 1, 0, 0, 0, true, 64);
		}
	}
}

void UpdateFFCCarryover(){
	if(G[G_ORBDIR]){
		RunFFCScript(Game->GetFFCScript("TheOrb"), {G[G_ORBDIR], 0, G[G_ORBLAYER]});
		SetLinkPitImmune(2);
		NoAction();
		G[G_ORBDIR] = 0;
	}
}

void DMapPal_Init(){
	Game->DMapPalette[64] = 0x0A1;
	Game->DMapPalette[70] = 0x08F;
	Game->DMapPalette[57] = 0x1C0;
	if(G[G_SLEEPPARALYSISSELET])
		Game->DMapPalette[76] = 0x095;
	else
		Game->DMapPalette[76] = 0x0AF;
}

const int DAYNIGHT_USE_SYSTEM_CLOCK = 0; //Set to 1 to use the system clock instead of a simulated one

const int DMF_IS_OVERWORLD = DMF_SCRIPT1; //DMap flag used to flag overworld DMaps
const int DMF_TIME_CAN_ADVANCE = DMF_SCRIPT2; //DMap flag used to flag DMaps where time advances

//Hour to start the clock on
const int DAYNIGHT_STARTING_HOUR = 8;

//Timing for sunset transitions
const int DAYNIGHT_SUNSET_START_HOUR = 16;
const int DAYNIGHT_SUNSET_MID_HOUR = 18;
const int DAYNIGHT_SUNSET_END_HOUR = 20;

//Timing for sunrise transitions
const int DAYNIGHT_SUNRISE_START_HOUR = 4;
const int DAYNIGHT_SUNRISE_MID_HOUR = 6;
const int DAYNIGHT_SUNRISE_END_HOUR = 8;

//Timing for midi change
//The mid time needs to be set because otherwise a night period of >12 hours would break
const int DAYNIGHT_MIDI_NIGHT_START_HOUR = 19;
const int DAYNIGHT_MIDI_NIGHT_MID_HOUR = 24;
const int DAYNIGHT_MIDI_NIGHT_END_HOUR = 6;

//Number of transitional palettes for the sunrise and sunset transitions. Negative numbers mean the palettes with cycle backwards
const int SUNSET_START_PALETTES = 3;
const int SUNSET_END_PALETTES = 3;

const int SUNRISE_START_PALETTES = -3;
const int SUNRISE_END_PALETTES = -3; 

//How often to increment the clock in frames
const int DAYNIGHT_TIME_INCREMENT_FRAMES = 45; //10
// const int DAYNIGHT_TIME_INCREMENT_FRAMES = 5;
//How long in seconds, minutes, and hours to increment it by
const int DAYNIGHT_TIME_INCREMENT_SECONDS = 0;
const int DAYNIGHT_TIME_INCREMENT_MINUTES = 1;
const int DAYNIGHT_TIME_INCREMENT_HOURS = 0;

//Position for the timer onscreen (Top of the subscreen is at Y = -56)
const int DAYNIGHT_DRAW_CLOCK = 1; 
const int DAYNIGHT_CLOCK_LAYER = 7;
const int DAYNIGHT_CLOCK_X = 104;
const int DAYNIGHT_CLOCK_Y = -48;
const int DAYNIGHT_CLOCK_PLACES = 1; //0 - Hours only, 1 - Hours:Minutes, 2 - Hours:Minutes:Seconds
const int DAYNIGHT_CLOCK_HIDE_AM_PM = 0; //0 - AM and PM are visible, 1 - AM and PM are not visible, 2 - Military time

//Font, colors, and shadow type for drawing the clock
const int FONT_DAYNIGHT_CLOCK = FONT_S;
const int C_DAYNIGHT_CLOCK = 0x01;
const int C_DAYNIGHT_CLOCK_SHADOW = 0x0F;
const int SHD_DAYNIGHT_CLOCK_SHADOWTYPE = SHD_OUTLINED8; 

int DayNight[_DN_START + 512 * _DN_BLOCK];

const int _DN_HOUR = 0;
const int _DN_MINUTE = 1;
const int _DN_SECOND = 2;
const int _DN_FRAMECOUNTER = 3;
const int _DN_FIRSTLOAD = 4;

//Start index of the 2D part of the global array and block size
const int _DN_START = 16;
const int _DN_BLOCK = 8;

const int _DN_DAYPAL = 0;
const int _DN_SUNSETPAL = 1;
const int _DN_NIGHTPAL = 2;
const int _DN_SUNRISEPAL = 3;
const int _DN_MIDIDAY = 4;
const int _DN_MIDINIGHT = 5;
const int _DN_MIDICURRENT = 6;

global script DayNight_Example{
	void run(){
		DayNight_Init();
		while(true){
			DayNight_Update();
			
			Waitdraw();
			Waitframe();
		}
	}
}

void DayNight_Init(){
	G[G_TIMEFROZEN] = 0;
	unless(DayNight[_DN_FIRSTLOAD]){
		DayNight[_DN_HOUR] = DAYNIGHT_STARTING_HOUR;
		
		DayNight[_DN_FIRSTLOAD] = 1;
	}
	DayNight_SetEnhancedMusic();
}

void DayNight_SetEnhancedMusic(){
	int h = DayNight[_DN_HOUR];
	int m = DayNight[_DN_MINUTE];
	int s = DayNight[_DN_SECOND];
	if(G[G_OVERRIDEHOURS]>-1){
		h = G[G_OVERRIDEHOURS];
		m = G[G_OVERRIDEMINUTES];
		s = G[G_OVERRIDESECONDS];
	}
	
	for(int whichDMap=0; whichDMap<512; ++whichDMap){
		int newMid;
		int i = _DN_START+_DN_BLOCK*whichDMap;
		if(DayNight[i+_DN_MIDIDAY]){
			//Night
			if(DayNight_GetTimeDifference(h, m, s, DAYNIGHT_MIDI_NIGHT_START_HOUR, 0, 0)>0&&DayNight_GetTimeDifference(h, m, s, DAYNIGHT_MIDI_NIGHT_MID_HOUR, 0, 0)<=0){
				newMid = DayNight[i+_DN_MIDINIGHT];
			}
			else if(DayNight_GetTimeDifference(h, m, s, DAYNIGHT_MIDI_NIGHT_MID_HOUR, 0, 0)>=0&&DayNight_GetTimeDifference(h, m, s, DAYNIGHT_MIDI_NIGHT_END_HOUR, 0, 0)<0){
				newMid = DayNight[i+_DN_MIDINIGHT];
			}
			//Day
			else{
				newMid = DayNight[i+_DN_MIDIDAY];
			}
			if(G[G_NIGHTMARCHEREVENT_INEVENT]&&whichDMap==Nightmarchers_ActiveDMap())
				newMid = -55;
			
			//Updating midi
			if(newMid>0){
				Game->DMapMIDI[whichDMap] = newMid;
				if(whichDMap==Game->GetCurDMap())
					Game->PlayMIDI(newMid);
			}
			//Updating enhanced music
			else if(newMid<0){
				int enhMusic = Floor(Abs(newMid));
				int enhTrack = (Abs(newMid)-enhMusic)*10000;
				int buf[256];
				GetMessage(enhMusic, buf);
				Game->SetDMapEnhancedMusic(whichDMap, buf, enhTrack);
				if(Game->GetCurDMap()==whichDMap&&G[G_MUSICCHANGECOOLDOWN]<=0){
					Game->PlayEnhancedMusic(buf, enhTrack);
					G[G_MUSICCHANGECOOLDOWN] = 1;
				}
			}
			
			DayNight[i+_DN_MIDICURRENT] = newMid;
		}
	}
}

void DayNight_Update(){
	int i;
	int tmpDMap;
	
	if(Game->DMapFlags[Game->GetCurDMap()]&DMF_TIME_CAN_ADVANCE&&!G[G_TIMEFROZEN] && !(G[G_HOURCLAMP]!=0 && DayNight[_DN_HOUR] == G[G_HOURCLAMP] && DayNight[_DN_MINUTE] == G[G_MINUTECLAMP])){
		if(DAYNIGHT_USE_SYSTEM_CLOCK){
			DayNight[_DN_HOUR] = GetSystemTime(RTC_HOUR);
			DayNight[_DN_MINUTE] = GetSystemTime(RTC_MINUTE);
			DayNight[_DN_SECOND] = GetSystemTime(RTC_SECOND);
		}
		// else if(!G[G_MSGACTIVE]){
			++DayNight[_DN_FRAMECOUNTER];
			if(DayNight[_DN_FRAMECOUNTER]>=DAYNIGHT_TIME_INCREMENT_FRAMES){
				DayNight[_DN_HOUR] += DAYNIGHT_TIME_INCREMENT_HOURS;
				DayNight[_DN_MINUTE] += DAYNIGHT_TIME_INCREMENT_MINUTES;
				DayNight[_DN_SECOND] += DAYNIGHT_TIME_INCREMENT_SECONDS;
				if(GLOBAL_DEBUG){
					if(Link->InputEx4){
						DayNight[_DN_HOUR] += 1;
						DayNight[_DN_MINUTE] = 0;
					}
					else if(Link->InputEx3)
						DayNight[_DN_MINUTE] += 10;
				}
				
				while(DayNight[_DN_SECOND]>=60){
					DayNight[_DN_SECOND] -= 60;
					++DayNight[_DN_MINUTE];
				}
				while(DayNight[_DN_MINUTE]>=60){
					DayNight[_DN_MINUTE] -= 60;
					++DayNight[_DN_HOUR];
				}
				while(DayNight[_DN_HOUR]>=25){
					DayNight[_DN_HOUR] -= 24;
				}
				
				DayNight[_DN_FRAMECOUNTER] = 0;
			}
		// }
	}


	//Update the palette for the current DMap
	DayNight_UpdateDMapPalette(Game->GetCurDMap());
	//Also update for side warp and tile warp DMaps
	for(i=0; i<4; ++i){
		tmpDMap = Screen->GetSideWarpDMap(i);
		DayNight_UpdateDMapPalette(tmpDMap);
		tmpDMap = Screen->GetTileWarpDMap(i);
		DayNight_UpdateDMapPalette(tmpDMap);
	}
	
	if(DAYNIGHT_DRAW_CLOCK){
		DayNight_DrawClock();
	}
	G[G_OVERRIDEHOURS] = -1;
}

void DayNight_UpdateDMapPalette(int whichDMap){
	int h = DayNight[_DN_HOUR];
	int m = DayNight[_DN_MINUTE];
	int s = DayNight[_DN_SECOND];
	if(G[G_OVERRIDEHOURS]>-1){
		h = G[G_OVERRIDEHOURS];
		m = G[G_OVERRIDEMINUTES];
		s = G[G_OVERRIDESECONDS];
	}
	
	int curTime;
	int chunkTime;
	int newPal;
	int newMid;

	int i = _DN_START+_DN_BLOCK*whichDMap;
	//Updating Palettes
	if(DayNight[i+_DN_DAYPAL]){
		//Day
		if(DayNight_GetTimeDifference(h, m, s, DAYNIGHT_SUNRISE_END_HOUR, 0, 0)>=0&&DayNight_GetTimeDifference(h, m, s, DAYNIGHT_SUNSET_START_HOUR, 0, 0)<0){
			newPal = DayNight[i+_DN_DAYPAL];
		}
		//Start of sunset
		else if(DayNight_GetTimeDifference(h, m, s, DAYNIGHT_SUNSET_START_HOUR, 0, 0)>=0&&DayNight_GetTimeDifference(h, m, s, DAYNIGHT_SUNSET_MID_HOUR, 0, 0)<0){
			if(Abs(SUNSET_START_PALETTES)>0){
				curTime = Abs(DayNight_GetTimeDifference(h, m, s, DAYNIGHT_SUNSET_START_HOUR, 0, 0));
				chunkTime = Abs(DayNight_GetTimeDifference(DAYNIGHT_SUNSET_START_HOUR, 0, 0, DAYNIGHT_SUNSET_MID_HOUR, 0, 0))/(Abs(SUNSET_START_PALETTES)+1);
				newPal = DayNight[i+_DN_DAYPAL]+Sign(SUNSET_START_PALETTES)*Floor(curTime/chunkTime);
			}
			else{
				newPal = DayNight[i+_DN_SUNSETPAL];
			}
		}
		//End of sunset
		else if(DayNight_GetTimeDifference(h, m, s, DAYNIGHT_SUNSET_MID_HOUR, 0, 0)>=0&&DayNight_GetTimeDifference(h, m, s, DAYNIGHT_SUNSET_END_HOUR, 0, 0)<0){
			if(Abs(SUNSET_END_PALETTES)>0){
				curTime = Abs(DayNight_GetTimeDifference(h, m, s, DAYNIGHT_SUNSET_MID_HOUR, 0, 0));
				chunkTime = Abs(DayNight_GetTimeDifference(DAYNIGHT_SUNSET_MID_HOUR, 0, 0, DAYNIGHT_SUNSET_END_HOUR, 0, 0))/(Abs(SUNSET_END_PALETTES)+1);
				newPal = DayNight[i+_DN_SUNSETPAL]+Sign(SUNSET_END_PALETTES)*Floor(curTime/chunkTime);
			}
			else{
				newPal = DayNight[i+_DN_SUNSETPAL];
			}
		}
		//Night
		else if(DayNight_GetTimeDifference(h, m, s, DAYNIGHT_SUNSET_END_HOUR, 0, 0)>=0&&DayNight_GetTimeDifference(h, m, s, DAYNIGHT_SUNRISE_START_HOUR, 0, 0)<0){
			newPal = DayNight[i+_DN_NIGHTPAL];
		}
		//Start of sunrise
		else if(DayNight_GetTimeDifference(h, m, s, DAYNIGHT_SUNRISE_START_HOUR, 0, 0)>=0&&DayNight_GetTimeDifference(h, m, s, DAYNIGHT_SUNRISE_MID_HOUR, 0, 0)<0){
			if(Abs(SUNRISE_START_PALETTES)>0){
				curTime = Abs(DayNight_GetTimeDifference(h, m, s, DAYNIGHT_SUNRISE_START_HOUR, 0, 0));
				chunkTime = Abs(DayNight_GetTimeDifference(DAYNIGHT_SUNRISE_START_HOUR, 0, 0, DAYNIGHT_SUNRISE_MID_HOUR, 0, 0))/(Abs(SUNRISE_START_PALETTES)+1);
				newPal = DayNight[i+_DN_NIGHTPAL]+Sign(SUNRISE_START_PALETTES)*Floor(curTime/chunkTime);
			}
			else{
				newPal = DayNight[i+_DN_SUNRISEPAL];
			}
		}
		//End of sunrise
		else if(DayNight_GetTimeDifference(h, m, s, DAYNIGHT_SUNRISE_MID_HOUR, 0, 0)>=0&&DayNight_GetTimeDifference(h, m, s, DAYNIGHT_SUNRISE_END_HOUR, 0, 0)<0){
			if(Abs(SUNRISE_END_PALETTES)>0){
				curTime = Abs(DayNight_GetTimeDifference(h, m, s, DAYNIGHT_SUNRISE_MID_HOUR, 0, 0));
				chunkTime = Abs(DayNight_GetTimeDifference(DAYNIGHT_SUNRISE_MID_HOUR, 0, 0, DAYNIGHT_SUNRISE_END_HOUR, 0, 0))/(Abs(SUNRISE_END_PALETTES)+1);
				newPal = DayNight[i+_DN_SUNRISEPAL]+Sign(SUNRISE_END_PALETTES)*Floor(curTime/chunkTime);
			}
			else{
				newPal = DayNight[i+_DN_SUNRISEPAL];
			}
		}
		
		if(newPal!=0){
			if(Game->DMapPalette[whichDMap]!=newPal){
				if(GLOBAL_DEBUG)printf("[PAL CHANGE] DAYNIGHT: %d, %X->%X\n", whichDMap, Game->DMapPalette[whichDMap], newPal);
				Game->DMapPalette[whichDMap] = newPal;
			}
		}
	}
	//Updating Music
	if(DayNight[i+_DN_MIDIDAY]!=0||G[G_NIGHTMARCHEREVENT_INEVENT]){
		//Night
		if(DayNight_GetTimeDifference(h, m, s, DAYNIGHT_MIDI_NIGHT_START_HOUR, 0, 0)>0&&DayNight_GetTimeDifference(h, m, s, DAYNIGHT_MIDI_NIGHT_MID_HOUR, 0, 0)<=0){
			newMid = DayNight[i+_DN_MIDINIGHT];
		}
		else if(DayNight_GetTimeDifference(h, m, s, DAYNIGHT_MIDI_NIGHT_MID_HOUR, 0, 0)>=0&&DayNight_GetTimeDifference(h, m, s, DAYNIGHT_MIDI_NIGHT_END_HOUR, 0, 0)<0){
			newMid = DayNight[i+_DN_MIDINIGHT];
		}
		//Day
		else{
			newMid = DayNight[i+_DN_MIDIDAY];
		}
		if(G[G_NIGHTMARCHEREVENT_INEVENT]&&whichDMap==Nightmarchers_ActiveDMap())
			newMid = -55;
		
		//If the midi has changed, update things
		if(newMid!=DayNight[i+_DN_MIDICURRENT]){
			//Updating midi
			if(newMid>0){
				Game->DMapMIDI[whichDMap] = newMid;
				if(whichDMap==Game->GetCurDMap())
					Game->PlayMIDI(newMid);
			}
			//Updating enhanced music
			else if(newMid<0){
				int enhMusic = Floor(Abs(newMid));
				int enhTrack = (Abs(newMid)-enhMusic)*10000;
				int buf[256];
				GetMessage(enhMusic, buf);
				Game->SetDMapEnhancedMusic(whichDMap, buf, enhTrack);
				if(Game->GetCurDMap()==whichDMap&&G[G_MUSICCHANGECOOLDOWN]<=0){
					Game->PlayEnhancedMusic(buf, enhTrack);
					G[G_MUSICCHANGECOOLDOWN] = 1;
				}
			}
			
			DayNight[i+_DN_MIDICURRENT] = newMid;
		}
	}
}

bool DayNight_IsNight(){
	if(DayNight_GetTimeDifference(DayNight[_DN_HOUR], DayNight[_DN_MINUTE], DayNight[_DN_SECOND], DAYNIGHT_SUNSET_MID_HOUR, 0, 0)>0&&DayNight_GetTimeDifference(DayNight[_DN_HOUR], DayNight[_DN_MINUTE], DayNight[_DN_SECOND], DAYNIGHT_SUNRISE_END_HOUR, 0, 0)<0);
}

bool DayNight_IsBetween(int h, int m, int s, int h1, int m1, int s1, int h2, int m2, int s2){
	return DayNight_GetTimeDifference(h, m, s, h1, m1, s1)>=0&&DayNight_GetTimeDifference(h, m, s, h2, m2, s2)<0;
}

bool DayNight_IsBetween(int h1, int m1, int s1, int h2, int m2, int s2){
	return DayNight_IsBetween(DayNight[_DN_HOUR], DayNight[_DN_MINUTE], DayNight[_DN_SECOND], h1, m2, s1, h2, m2, s2);
}

int DayNight_GetTimeDifference(int h1, int m1, int s1, int h2, int m2, int s2){
	--h1; --h2;
	int hDiff = h1-h2;
	int mDiff = m1-m2;
	int sDiff = s1-s2;
	
	while(hDiff>=12)
		hDiff -= 24;
	while(hDiff<=-12)
		hDiff += 24;
	
	return hDiff*3600+mDiff*60+sDiff;
}

void DayNight_DrawClock(){
	int h = DayNight[_DN_HOUR]-1;
	int m = DayNight[_DN_MINUTE];
	int s = DayNight[_DN_SECOND];
	if(G[G_OVERRIDEHOURS]>-1){
		h = G[G_OVERRIDEHOURS]-1;
		m = G[G_OVERRIDEMINUTES];
		s = G[G_OVERRIDESECONDS];
	}
	
	if(Game->GetCurDMap()==19){ //Mauna Ali'i summit
		h = -1;
		m = 0;
		s = 0;
	}
	if(Game->GetCurDMap()==40||Game->GetCurDMap()==41){ //Mt. Silver
		h = 11;
		m = 0;
		s = 0;
	}
	
	int militaryTimeOffset;
	if(DAYNIGHT_CLOCK_HIDE_AM_PM==2){
		militaryTimeOffset = -1;
		if(h>11)
			militaryTimeOffset = 11;
	}
	
	int clockStr[12] = "00:00:00 AM";
	
	clockStr[0] = '0'+Floor(((h%12)+1+militaryTimeOffset)/10);
	clockStr[1] = '0'+(((h%12)+1+militaryTimeOffset)%10);
	clockStr[3] = '0'+Floor(m/10);
	clockStr[4] = '0'+(m%10);
	clockStr[6] = '0'+Floor(s/10);
	clockStr[7] = '0'+(s%10);
	
	int clrPos;
	switch(DAYNIGHT_CLOCK_PLACES){
		case 2:
			clrPos = 8;
			break;
		case 1: 
			clrPos = 5;
			break;
		default:
			clrPos = 2;
	}
	
	clockStr[clrPos] = ' ';
	if(DAYNIGHT_CLOCK_HIDE_AM_PM)
		clockStr[clrPos] = 0;
	clockStr[clrPos+1] = 'A';
	if((Floor(h/12)>0||h==11)&&h!=23){
		clockStr[clrPos+1] = 'P';
	}
	clockStr[clrPos+2] = 'M';
	clockStr[clrPos+3] = 0;
	
	Screen->DrawString(DAYNIGHT_CLOCK_LAYER, DAYNIGHT_CLOCK_X, DAYNIGHT_CLOCK_Y, FONT_DAYNIGHT_CLOCK, C_DAYNIGHT_CLOCK, -1, TF_NORMAL, clockStr, 128, SHD_DAYNIGHT_CLOCK_SHADOWTYPE, C_DAYNIGHT_CLOCK_SHADOW);
}

//Place this FFC to configure Day/Night settings for the current DMap
//D0: Which DMap to configure settings for (-1 for the current DMap)
//D1: Palette for daytime
//D2: Palette for sunset
//D3: Palette for nighttime
//D4: Palette for sunrise
//D5: Midi for daytime music (negative for enhanced music, using a ZQuest string)
//D6: Midi for nighttime music (negative for enhanced music, using a ZQuest string)

void DayNight_InitDMaps(){
	//Starting Island
	DayNight_SetUpDMap(0, 0x0B0, 0x0B4, 0x0B8, -56, -56);
	//Hometown
	DayNight_SetUpDMap(1, 0x0B0, 0x0B4, 0x0B8, -6, -7);
	DayNight_SetUpDMap(15, 0, 0, 0, -6, -7);
	//Pala Bay
	DayNight_SetUpDMap(2, 0x0B0, 0x0B4, 0x0B8, -4, -5);
	DayNight_SetUpDMap(3, 0, 0, 0, -4, -5);
	DayNight_SetUpDMap(4, 0, 0, 0, -4, -5);
	DayNight_SetUpDMap(5, 0, 0, 0, -4, -5);
	DayNight_SetUpDMap(78, 0, 0, 0, -4, -5);
	//Desert Island
	DayNight_SetUpDMap(6, 0x0B9, 0x0BD, 0x0C1, -57, -57);
	//Pirate Fort
	DayNight_SetUpDMap(16, 0x126, 0x129, 0x12D, 0, 0);
	//Starfall Shoals
	DayNight_SetUpDMap(14, 0x0C2, 0x0C6, 0x0CA, 0, 0);
	//Mauna Alii
	DayNight_SetUpDMap(10, 0x0CB, 0x0CF, 0x0D3, -58, -58);
	DayNight_SetUpDMap(11, 0x0D4, 0x0D8, 0x0DC, -58, -58);
	DayNight_SetUpDMap(12, 0x0DD, 0x0E1, 0x0E5, -58, -58);
	DayNight_SetUpDMap(18, 0x0E6, 0x0EA, 0x0EE, 0, 0);
	DayNight_SetUpDMap(36, 0x0CB, 0x0CF, 0x0D3, 0, 0);
	//Observatory
	DayNight_SetUpDMap(23, 0x0EF, 0x0F3, 0x0F7, 0, 0);
	//Malka
	DayNight_SetUpDMap(26, 0x0F8, 0x0FC, 0x100, -8, -9);
	DayNight_SetUpDMap(31, 0x113, 0x117, 0x11B, -8, -9);
	//Pine Island
	DayNight_SetUpDMap(27, 0x0B0, 0x0B4, 0x0B8, -56, -56);
	//Tent Island
	DayNight_SetUpDMap(33, 0x0B9, 0x0BD, 0x0C1, 0, 0);
	//Carn Ruins
	DayNight_SetUpDMap(38, 0x12E, 0x132, 0x136, 0, 0);
	//Hoku
	DayNight_SetUpDMap(28, 0x10A, 0x10E, 0x112, -15, -16);
	DayNight_SetUpDMap(32, 0, 0, 0, -15, -16);
	//Villa Tulane
	DayNight_SetUpDMap(43, 0x0B0, 0x0B4, 0x0B8, -57, -57);
	//Poni Canyon
	DayNight_SetUpDMap(49, 0x11C, 0x120, 0x124, 0, 0);
	DayNight_SetUpDMap(51, 0x11C, 0x120, 0x124, 0, 0);
	//Kukulu Cliffs
	DayNight_SetUpDMap(58, 0x0B0, 0x0B4, 0x0B8, -56, -56);
	//Small Islands
	DayNight_SetUpDMap(61, 0x0B0, 0x0B4, 0x0B8, -67, -67);
	DayNight_SetUpDMap(63, 0x0B0, 0x0B4, 0x0B8, -67, -67);
	DayNight_SetUpDMap(69, 0x0B0, 0x0B4, 0x0B8, -67, -67);
	DayNight_SetUpDMap(74, 0x0B0, 0x0B4, 0x0B8, -67, -67);
	//Tel's Pyramid
	DayNight_SetUpDMap(65, 0x0D4, 0x0D8, 0x0DC, -67, -67);
	//Overworld
	DayNight_SetUpDMap(29, 0x101, 0x105, 0x109, 0, 0);
}

void DayNight_SetUpDMap(int which, int dayPal, int sunrisePal, int nightPal, int dayMusic, int nightMusic){
	int i = _DN_START+_DN_BLOCK*which;
	DayNight[i+_DN_DAYPAL] = dayPal;
	DayNight[i+_DN_SUNSETPAL] = sunrisePal;
	DayNight[i+_DN_NIGHTPAL] = nightPal;
	DayNight[i+_DN_SUNRISEPAL] = sunrisePal;
	DayNight[i+_DN_MIDIDAY] = dayMusic;
	DayNight[i+_DN_MIDINIGHT] = nightMusic;
}

ffc script DayNight_ConfigureDMap{
	void run(int whichDMap, int dayPal, int sunsetPal, int nightPal, int sunrisePal, int dayMusic, int nightMusic){
		if(whichDMap<0)
			whichDMap = Game->GetCurDMap();
		
		int i = _DN_START+_DN_BLOCK*whichDMap;
		
		DayNight[i+_DN_DAYPAL] = dayPal;
		DayNight[i+_DN_SUNSETPAL] = sunrisePal;
		DayNight[i+_DN_NIGHTPAL] = nightPal;
		DayNight[i+_DN_SUNRISEPAL] = sunrisePal;
		DayNight[i+_DN_MIDIDAY] = dayMusic;
		DayNight[i+_DN_MIDINIGHT] = nightMusic;
	}
}

//Place down on a screen to change warps based on the time of day
//D0: If 0, change a tile warp, if 1 change a side warp
//D1: Which warp to change:
//		0 - A
//		1 - B
//		2 - C
//		3 - D
//D2: Starting time for the warp change (decimal places are used for minutes)
//D3: Ending time for the warp change (decimal places are used for minutes)
//D4: Which DMap to warp to (-1 to leave unchanged)
//D5: Which screen to warp to (in decimal) (-1 to leave unchanged)
ffc script DayNight_ChangeWarp{
	void run(int tileOrSideWarp, int warpID, int startTime, int endTime, int whichDMap, int whichScreen){
		warpID = Clamp(warpID, 0, 3);
		
		int startingDMap;
		int startingScreen;
		if(tileOrSideWarp){
			startingDMap = Screen->GetSideWarpDMap(warpID);
			startingScreen = Screen->GetSideWarpScreen(warpID);
		}
		else{
			startingDMap = Screen->GetTileWarpDMap(warpID);
			startingScreen = Screen->GetTileWarpScreen(warpID);
		}
		int newDMap = startingDMap;
		int newScreen = startingScreen;
		if(whichDMap>-1)
			newDMap = whichDMap;
		if(whichScreen>-1)
			newScreen = whichScreen;
		
		int startHour = Clamp(Floor(startTime), 1, 24);
		int startMinute = Clamp(Floor(((startTime-startHour)*100)), 0, 59);
		
		int endHour = Clamp(Floor(endTime), 1, 24);
		int endMinute = Clamp(Floor(((endTime-endHour)*100)), 0, 59);
		
		bool useNew;
		bool wasNew;
		
		int h; int m; int s;
		while(true){
			h = DayNight[_DN_HOUR];
			m = DayNight[_DN_MINUTE];
			s = DayNight[_DN_SECOND];
			if(DayNight_GetTimeDifference(h, m, s, startHour, startMinute, 0)>0&&DayNight_GetTimeDifference(h, m, s, endHour, endMinute, 0)<0){
				useNew = true;
			}
			else{
				useNew = false;
			}
			
			if(useNew&&!wasNew){
				if(tileOrSideWarp){
					Screen->SetSideWarp(warpID, newScreen, newDMap, Screen->GetSideWarpType(warpID));
				}
				else{
					Screen->SetTileWarp(warpID, newScreen, newDMap, Screen->GetTileWarpType(warpID));
				}
				wasNew = true;
			}
			else if(!useNew&&wasNew){
				if(tileOrSideWarp){
					Screen->SetSideWarp(warpID, startingScreen, startingDMap, Screen->GetSideWarpType(warpID));
				}
				else{
					Screen->SetTileWarp(warpID, startingScreen, startingDMap, Screen->GetTileWarpType(warpID));
				}
				wasNew = false;
			}
			
			Waitframe();
		}
	}
}

//Place down on a screen to trigger screen secrets based on the time of day
//D0: Starting time for the secret (decimal places are used for minutes)
//D1: Ending time for the secret (decimal places are used for minutes)
//D2: Set to 1 if the secret is permanent
//D3: Sound to play when the secret triggers
ffc script DayNight_TriggerSecrets{
	void run(int startTime, int endTime, int perm, int sfx){
		int h = DayNight[_DN_HOUR];
		int m = DayNight[_DN_MINUTE];
		int s = DayNight[_DN_SECOND];
		
		int startHour = Clamp(Floor(startTime), 1, 24);
		int startMinute = Clamp(Floor(((startTime-startHour)*100)), 0, 59);
		
		int endHour = Clamp(Floor(endTime), 1, 24);
		int endMinute = Clamp(Floor(((endTime-endHour)*100)), 0, 59);
		
		bool triggered;
		if(DayNight_GetTimeDifference(h, m, s, startHour, startMinute, 0)>0&&DayNight_GetTimeDifference(h, m, s, endHour, endMinute, 0)<0){
			triggered = true;
		}
		else{
			triggered = false;
		}
		
		if(triggered){
			Screen->TriggerSecrets();
			if(perm)
				Screen->State[ST_SECRET] = true;
			Quit();
		}
		
		while(true){
			h = DayNight[_DN_HOUR];
			m = DayNight[_DN_MINUTE];
			s = DayNight[_DN_SECOND];
			
			if(DayNight_GetTimeDifference(h, m, s, startHour, startMinute, 0)>0&&DayNight_GetTimeDifference(h, m, s, endHour, endMinute, 0)<0){
				triggered = true;
			}
			else{
				triggered = false;
			}
			
			if(triggered){
			Screen->TriggerSecrets();
			if(perm)
				Screen->State[ST_SECRET] = true;
			if(sfx>0)
				Game->PlaySound(sfx);
			Quit();
		}
			
			Waitframe();
		}
	}
}

//This script sets the clock to a certain time when you enter the screen, for use in cutscenes
//D0: Hour
//D1: Minute
//D2: Second
ffc script DayNight_SetTime{
	void run(int hours, int minutes, int seconds){
		DayNight[_DN_HOUR] = Clamp(hours, 1, 24);
		DayNight[_DN_MINUTE] = Clamp(minutes, 0, 59);
		DayNight[_DN_SECOND] = Clamp(seconds, 0, 59);
	}
}

const int STYLE_ASHER = 0; //UNUSED
const int STYLE_TORRIN = 1; //UNUSED
const int STYLE_KAYLANI = 2; //UNUSED
const int STYLE_SELET = 3; //UNUSED
const int STYLE_NPC = 4;
const int STYLE_SHOP = 5;
const int STYLE_MENU = 6;
const int STYLE_BANTER = 7;
const int STYLE_BESTIARY = 8;
const int STYLE_LOCATION = 9;
const int STYLE_PASSIVETEXT = 0;

void SetUpStyles(){
	//Menu
    // Tango_SetStyleAttribute(STYLE_MENU, TANGO_STYLE_BACKDROP_TYPE, TANGO_BACKDROP_TILE);
    // Tango_SetStyleAttribute(STYLE_MENU, TANGO_STYLE_BACKDROP_CSET, 6);
    // Tango_SetStyleAttribute(STYLE_MENU, TANGO_STYLE_BACKDROP_TILE, 8788);
    // Tango_SetStyleAttribute(STYLE_MENU, TANGO_STYLE_BACKDROP_WIDTH, 10);
    // Tango_SetStyleAttribute(STYLE_MENU, TANGO_STYLE_BACKDROP_HEIGHT, 2);

    // Tango_SetStyleAttribute(STYLE_MENU, TANGO_STYLE_TEXT_FONT, TANGO_FONT_LTTP_SMALL);
    // Tango_SetStyleAttribute(STYLE_MENU, TANGO_STYLE_TEXT_CSET, 6);
    // Tango_SetStyleAttribute(STYLE_MENU, TANGO_STYLE_TEXT_COLOR, 8);
    // Tango_SetStyleAttribute(STYLE_MENU, TANGO_STYLE_TEXT_X, 8);
    // Tango_SetStyleAttribute(STYLE_MENU, TANGO_STYLE_TEXT_Y, 8);
    // Tango_SetStyleAttribute(STYLE_MENU, TANGO_STYLE_TEXT_WIDTH, 140);
    // Tango_SetStyleAttribute(STYLE_MENU, TANGO_STYLE_TEXT_HEIGHT, 18);
    // Tango_SetStyleAttribute(STYLE_MENU, TANGO_STYLE_TEXT_SPEED, 2);
    // Tango_SetStyleAttribute(STYLE_MENU, TANGO_STYLE_TEXT_SFX, 0);
	
	// Tango_SetStyleAttribute(STYLE_MENU, TANGO_STYLE_FLAGS, TANGO_FLAG_PERSISTENT);
	
	//Shop
    Tango_SetStyleAttribute(STYLE_SHOP, TANGO_STYLE_TEXT_FONT, TANGO_FONT_GUI_NARROW);
    Tango_SetStyleAttribute(STYLE_SHOP, TANGO_STYLE_TEXT_CSET, 11);
    Tango_SetStyleAttribute(STYLE_SHOP, TANGO_STYLE_TEXT_COLOR, 0x02);
    Tango_SetStyleAttribute(STYLE_SHOP, TANGO_STYLE_TEXT_X, 8);
    Tango_SetStyleAttribute(STYLE_SHOP, TANGO_STYLE_TEXT_Y, 8);
    Tango_SetStyleAttribute(STYLE_SHOP, TANGO_STYLE_TEXT_WIDTH, 80);
    Tango_SetStyleAttribute(STYLE_SHOP, TANGO_STYLE_TEXT_HEIGHT, 80);
    Tango_SetStyleAttribute(STYLE_SHOP, TANGO_STYLE_TEXT_SPEED, 5);
    Tango_SetStyleAttribute(STYLE_SHOP, TANGO_STYLE_TEXT_SFX, 18);
    Tango_SetStyleAttribute(STYLE_NPC, TANGO_STYLE_TEXT_END_SFX, 119);
	
	Tango_SetStyleAttribute(STYLE_SHOP, TANGO_STYLE_FLAGS, TANGO_FLAG_INSTANTANEOUS);
	
	//NPC
	Tango_SetStyleAttribute(STYLE_NPC, TANGO_STYLE_BACKDROP_TYPE, TANGO_BACKDROP_CLEAR);
    Tango_SetStyleAttribute(STYLE_NPC, TANGO_STYLE_BACKDROP_CSET, 11);
    Tango_SetStyleAttribute(STYLE_NPC, TANGO_STYLE_BACKDROP_TILE, 65907);
    Tango_SetStyleAttribute(STYLE_NPC, TANGO_STYLE_BACKDROP_WIDTH, 10);
    Tango_SetStyleAttribute(STYLE_NPC, TANGO_STYLE_BACKDROP_HEIGHT, 3);

    Tango_SetStyleAttribute(STYLE_NPC, TANGO_STYLE_TEXT_FONT, TANGO_FONT_GUI_NARROW);
    Tango_SetStyleAttribute(STYLE_NPC, TANGO_STYLE_TEXT_CSET, 11);
    Tango_SetStyleAttribute(STYLE_NPC, TANGO_STYLE_TEXT_COLOR, 0x02);
    Tango_SetStyleAttribute(STYLE_NPC, TANGO_STYLE_TEXT_X, 8);
    Tango_SetStyleAttribute(STYLE_NPC, TANGO_STYLE_TEXT_Y, 8);
    Tango_SetStyleAttribute(STYLE_NPC, TANGO_STYLE_TEXT_WIDTH, 140);
    Tango_SetStyleAttribute(STYLE_NPC, TANGO_STYLE_TEXT_HEIGHT, 32);
    Tango_SetStyleAttribute(STYLE_NPC, TANGO_STYLE_TEXT_SPEED, 5);
    Tango_SetStyleAttribute(STYLE_NPC, TANGO_STYLE_TEXT_SFX, 18);
    Tango_SetStyleAttribute(STYLE_NPC, TANGO_STYLE_TEXT_END_SFX, 119);
	
	Tango_SetStyleAttribute(STYLE_NPC, TANGO_STYLE_FLAGS, TANGO_FLAG_ENABLE_SPEEDUP);
	
	//Banter
	Tango_SetStyleAttribute(STYLE_BANTER, TANGO_STYLE_BACKDROP_TYPE, TANGO_BACKDROP_TILE);
    Tango_SetStyleAttribute(STYLE_BANTER, TANGO_STYLE_BACKDROP_CSET, 11);
    Tango_SetStyleAttribute(STYLE_BANTER, TANGO_STYLE_BACKDROP_TILE, 65907);
    Tango_SetStyleAttribute(STYLE_BANTER, TANGO_STYLE_BACKDROP_WIDTH, 10);
    Tango_SetStyleAttribute(STYLE_BANTER, TANGO_STYLE_BACKDROP_HEIGHT, 3);

    Tango_SetStyleAttribute(STYLE_BANTER, TANGO_STYLE_TEXT_FONT, TANGO_FONT_GUI_NARROW);
    Tango_SetStyleAttribute(STYLE_BANTER, TANGO_STYLE_TEXT_CSET, 11);
    Tango_SetStyleAttribute(STYLE_BANTER, TANGO_STYLE_TEXT_COLOR, 0x02);
    Tango_SetStyleAttribute(STYLE_BANTER, TANGO_STYLE_TEXT_X, 8);
    Tango_SetStyleAttribute(STYLE_BANTER, TANGO_STYLE_TEXT_Y, 8);
    Tango_SetStyleAttribute(STYLE_BANTER, TANGO_STYLE_TEXT_WIDTH, 140);
    Tango_SetStyleAttribute(STYLE_BANTER, TANGO_STYLE_TEXT_HEIGHT, 32);
    Tango_SetStyleAttribute(STYLE_BANTER, TANGO_STYLE_TEXT_SPEED, 3);
    Tango_SetStyleAttribute(STYLE_BANTER, TANGO_STYLE_TEXT_SFX, 18);
    Tango_SetStyleAttribute(STYLE_NPC, TANGO_STYLE_TEXT_END_SFX, 119);
	
	Tango_SetStyleAttribute(STYLE_BANTER, TANGO_STYLE_FLAGS, TANGO_FLAG_ENABLE_SPEEDUP|TANGO_FLAG_PERSISTENT);
	
	//Bestiary
	Tango_SetStyleAttribute(STYLE_BESTIARY, TANGO_STYLE_BACKDROP_TYPE, TANGO_BACKDROP_CLEAR);

    Tango_SetStyleAttribute(STYLE_BESTIARY, TANGO_STYLE_TEXT_FONT, TANGO_FONT_GUI_NARROW);
    Tango_SetStyleAttribute(STYLE_BESTIARY, TANGO_STYLE_TEXT_CSET, 11);
    Tango_SetStyleAttribute(STYLE_BESTIARY, TANGO_STYLE_TEXT_COLOR, 0x02);
    Tango_SetStyleAttribute(STYLE_BESTIARY, TANGO_STYLE_TEXT_X, 8);
    Tango_SetStyleAttribute(STYLE_BESTIARY, TANGO_STYLE_TEXT_Y, 8);
    Tango_SetStyleAttribute(STYLE_BESTIARY, TANGO_STYLE_TEXT_WIDTH, 120);
    Tango_SetStyleAttribute(STYLE_BESTIARY, TANGO_STYLE_TEXT_HEIGHT, 56);
    Tango_SetStyleAttribute(STYLE_BESTIARY, TANGO_STYLE_TEXT_SPEED, 3);
    Tango_SetStyleAttribute(STYLE_BESTIARY, TANGO_STYLE_TEXT_SFX, 0);
	
	Tango_SetStyleAttribute(STYLE_BESTIARY, TANGO_STYLE_FLAGS, TANGO_FLAG_LINE_BY_LINE|TANGO_FLAG_PERSISTENT);
	
	//Location
	Tango_SetStyleAttribute(STYLE_LOCATION, TANGO_STYLE_BACKDROP_TYPE, TANGO_BACKDROP_CLEAR);

    Tango_SetStyleAttribute(STYLE_LOCATION, TANGO_STYLE_TEXT_FONT, TANGO_FONT_GUI_NARROW);
    Tango_SetStyleAttribute(STYLE_LOCATION, TANGO_STYLE_TEXT_CSET, 11);
    Tango_SetStyleAttribute(STYLE_LOCATION, TANGO_STYLE_TEXT_COLOR, 0x02);
    Tango_SetStyleAttribute(STYLE_LOCATION, TANGO_STYLE_TEXT_X, 8);
    Tango_SetStyleAttribute(STYLE_LOCATION, TANGO_STYLE_TEXT_Y, 8);
    Tango_SetStyleAttribute(STYLE_LOCATION, TANGO_STYLE_TEXT_WIDTH, 96);
    Tango_SetStyleAttribute(STYLE_LOCATION, TANGO_STYLE_TEXT_HEIGHT, 96);
    Tango_SetStyleAttribute(STYLE_LOCATION, TANGO_STYLE_TEXT_SPEED, 3);
    Tango_SetStyleAttribute(STYLE_LOCATION, TANGO_STYLE_TEXT_SFX, 0);
	
	Tango_SetStyleAttribute(STYLE_LOCATION, TANGO_STYLE_FLAGS, TANGO_FLAG_LINE_BY_LINE|TANGO_FLAG_PERSISTENT);

	//NPC (Passive)
	Tango_SetStyleAttribute(STYLE_PASSIVETEXT, TANGO_STYLE_BACKDROP_TYPE, TANGO_BACKDROP_CLEAR);
    Tango_SetStyleAttribute(STYLE_PASSIVETEXT, TANGO_STYLE_BACKDROP_CSET, 11);
    Tango_SetStyleAttribute(STYLE_PASSIVETEXT, TANGO_STYLE_BACKDROP_TILE, 61360);
    Tango_SetStyleAttribute(STYLE_PASSIVETEXT, TANGO_STYLE_BACKDROP_WIDTH, 14);
    Tango_SetStyleAttribute(STYLE_PASSIVETEXT, TANGO_STYLE_BACKDROP_HEIGHT, 2);

    Tango_SetStyleAttribute(STYLE_PASSIVETEXT, TANGO_STYLE_TEXT_FONT, TANGO_FONT_GUI_NARROW);
    Tango_SetStyleAttribute(STYLE_PASSIVETEXT, TANGO_STYLE_TEXT_CSET, 11);
    Tango_SetStyleAttribute(STYLE_PASSIVETEXT, TANGO_STYLE_TEXT_COLOR, 0x02);
    Tango_SetStyleAttribute(STYLE_PASSIVETEXT, TANGO_STYLE_TEXT_X, 8);
    Tango_SetStyleAttribute(STYLE_PASSIVETEXT, TANGO_STYLE_TEXT_Y, 8);
    Tango_SetStyleAttribute(STYLE_PASSIVETEXT, TANGO_STYLE_TEXT_WIDTH, 208);
    Tango_SetStyleAttribute(STYLE_PASSIVETEXT, TANGO_STYLE_TEXT_HEIGHT, 8);
    Tango_SetStyleAttribute(STYLE_PASSIVETEXT, TANGO_STYLE_TEXT_SPEED, 5);
    Tango_SetStyleAttribute(STYLE_PASSIVETEXT, TANGO_STYLE_TEXT_SFX, 18);
    Tango_SetStyleAttribute(STYLE_PASSIVETEXT, TANGO_STYLE_TEXT_END_SFX, 119);
	
	Tango_SetStyleAttribute(STYLE_PASSIVETEXT, TANGO_STYLE_FLAGS, TANGO_FLAG_AUTO_ADVANCE);
}

const int SPR_LINKCRUSH = 88; //Sprite of Link being crushed
const int SFX_LINKCRUSH = 11; //Sound that plays when Link gets crushed
const int SFX_ENEMYCRUSH = 11; //Sound that plays when an enemy gets crushed
const int DAMAGE_LINKCRUSH = 8; //Damage taken from being crushed

const int DELAY_CRUSH = 40; //Delay before Link respawns after being crushed
const int DELAYMAX_CRUSH = 300; //Max delay before Link respawns

const int SOLIDOBJ_MAX = 32; //Maximum number of solid objects
const int SOLIDOBJ_CRUSH_BEHAVIOR = 0; //How solid objects behave with crushing Link (0=No interaction, 1=Return to screen entrance, 2=Instant death)
const int SOLIDOBJ_CRUSH_REPOSITION = 1; //If crushing Link should move him to the room entrance
const int SOLIDOBJ_COMPLEX_CRUSH_ANIM = 1; //If crushing animation should have 6 animations or just 2
const int SOLIDOBJ_PUSH_NPC = 0; //Whether or not to push NPCs

const int SOLIDOBJ_CRUSH_SAFETY = 4; //Safety pixels before being crushed

const int SOLIDOBJ_LINKXTRIM = 3; //Amount trimmed from the sides of Link's hitbox
const int SOLIDOBJ_LINKYTRIM = 0; //Amount trimmed from the top of Link's hitbox in sideview

//Internal constants - Please don't change these

const int __SOLIDOBJ_COUNT = 0; //Array index keeping track of the number of solid objects
const int __SOLIDOBJ_STARTLINKX = 1; //Link's starting X position
const int __SOLIDOBJ_STARTLINKY = 2; //Link's starting Y position
const int __SOLIDOBJ_CRUSHCOUNTER = 3; //Array index for the timer keeping track of Link getting crushed
const int __SOLIDOBJ_LASTDMAP = 4; //Last DMap visited
const int __SOLIDOBJ_LASTSCREEN = 5; //Last screen visited
const int __SOLIDOBJ_ONPLATFORM = 6; //The current platform Link is on
const int __SOLIDOBJ_FORCERESPAWNCOUNTER = 7; //How many frames until Link is force to respawn, regardless of if a block is covering him
const int __SOLIDOBJ_FORCELINKX = 8; //X position where Link got crushed
const int __SOLIDOBJ_FORCELINKY = 9; //Y position where Link got crushed
const int __SOLIDOBJ_LINKLASTX = 10; //Link's last X position
const int __SOLIDOBJ_LINKLASTY = 11; //Link's last Y position

const int __SOLIDOBJ_STARTINDEX = 12; //Starting index for objects in the array
const int __SOLIDOBJ_NUMATTRIBINDEX = 8; //Number of indices in an object

//Array indices (__SOLIDOBJ_STARTINDEX+__SOLIDOBJ_NUMATTRIBINDEX*y+x) for various attributes of each object 
//where y is the object ID and x is the property
const int __SOLIDOBJ_OBJ_X = 0;
const int __SOLIDOBJ_OBJ_Y = 1;
const int __SOLIDOBJ_OBJ_WIDTH = 2;
const int __SOLIDOBJ_OBJ_HEIGHT = 3;
const int __SOLIDOBJ_OBJ_VX = 4;
const int __SOLIDOBJ_OBJ_VY = 5;
const int __SOLIDOBJ_OBJ_ID = 6;
const int __SOLIDOBJ_OBJ_FLAGS = 7;

const int SFFCF_TOPONLY = 00000001b; //Only the top face of the FFC is solid
const int SFFCF_PUSHNPC = 00000010b; //Can push NPCs

int SolidObjects[268]; //Buffer for the solid object. Size should be 12+SOLIDOBJ_MAX*8

void SolidObjects_Add(int ID, int x, int y, int width, int height, int vX, int vY, int flags){
	int i = __SOLIDOBJ_STARTINDEX+SolidObjects[__SOLIDOBJ_COUNT]*__SOLIDOBJ_NUMATTRIBINDEX; //Get the starting index of the object
	
	//Set all the object's attributes
	SolidObjects[i+__SOLIDOBJ_OBJ_X] = x;
	SolidObjects[i+__SOLIDOBJ_OBJ_Y] = y;
	SolidObjects[i+__SOLIDOBJ_OBJ_WIDTH] = width;
	SolidObjects[i+__SOLIDOBJ_OBJ_HEIGHT] = height;
	SolidObjects[i+__SOLIDOBJ_OBJ_VX] = vX;
	SolidObjects[i+__SOLIDOBJ_OBJ_VY] = vY;
	SolidObjects[i+__SOLIDOBJ_OBJ_ID] = ID;
	SolidObjects[i+__SOLIDOBJ_OBJ_FLAGS] = flags;
	
	//Increment the count so the script knows where to add the next object
	SolidObjects[__SOLIDOBJ_COUNT] = Min(SolidObjects[__SOLIDOBJ_COUNT]+1, SOLIDOBJ_MAX);
}

void SolidObjects_Init(){
	//Reset global variables to their default states
	SolidObjects[__SOLIDOBJ_COUNT] = 0;
	SolidObjects[__SOLIDOBJ_STARTLINKX] = Link->X;
	SolidObjects[__SOLIDOBJ_STARTLINKY] = Link->Y;
	SolidObjects[__SOLIDOBJ_CRUSHCOUNTER] = 0;
	SolidObjects[__SOLIDOBJ_LASTDMAP] = Game->GetCurDMap();
	SolidObjects[__SOLIDOBJ_LASTSCREEN] = Game->GetCurScreen();
	SolidObjects[__SOLIDOBJ_ONPLATFORM] = 0;
	
	for(int i=0; i<SOLIDOBJ_MAX; i++){ //Cycle through all possible objects
		SolidObjects[__SOLIDOBJ_STARTINDEX+i*__SOLIDOBJ_NUMATTRIBINDEX+__SOLIDOBJ_OBJ_WIDTH] = 0;
	}
}

void SolidObjects_Update1(){
	if(Link->Action != LA_SCROLLING){
		//If Link is currently being crushed
		if(SolidObjects[__SOLIDOBJ_CRUSHCOUNTER]>0){
			NoAction();
			Link->Jump = 0;
			SolidObjects[__SOLIDOBJ_CRUSHCOUNTER]--;
			Link->CollDetection = false;
			Link->Invisible = true;
			Link->X = SolidObjects[__SOLIDOBJ_FORCELINKX];
			Link->Y = SolidObjects[__SOLIDOBJ_FORCELINKY];
			//When the counter hits 0
			if(SolidObjects[__SOLIDOBJ_CRUSHCOUNTER]==0){
				if(SOLIDOBJ_CRUSH_REPOSITION){
					Link->X = SolidObjects[__SOLIDOBJ_STARTLINKX];
					Link->Y = SolidObjects[__SOLIDOBJ_STARTLINKY];
				}
				//If Link isn't colliding with a solid object
				if(!SolidObjects_CollideWithLink(Link->X, Link->Y)||SolidObjects[__SOLIDOBJ_FORCERESPAWNCOUNTER]>=DELAYMAX_CRUSH){
					SolidObjects[__SOLIDOBJ_FORCERESPAWNCOUNTER] = 0;
					Link->CollDetection = true;
					Link->Invisible = false;
					Link->HP -= DAMAGE_LINKCRUSH;
					Link->Action = LA_GOTHURTLAND;
					Link->HitDir = -1;
					Game->PlaySound(SFX_OUCH);
				}
				//Otherwise raise the crush counter so it checks again next frame
				else{
					SolidObjects[__SOLIDOBJ_CRUSHCOUNTER] = 1;
					SolidObjects[__SOLIDOBJ_FORCERESPAWNCOUNTER]++;
				}
			}
		}
	}
}

void SolidObjects_Update2(){
	if(Link->Action != LA_SCROLLING){
		//If Link has moved to a different DMap or screen, update the starting position
		if(SolidObjects[__SOLIDOBJ_LASTDMAP]!=Game->GetCurDMap()||SolidObjects[__SOLIDOBJ_LASTSCREEN]!=Game->GetCurScreen()){
			SolidObjects[__SOLIDOBJ_LASTDMAP] = Game->GetCurDMap();
			SolidObjects[__SOLIDOBJ_LASTSCREEN] = Game->GetCurScreen();
			
			SolidObjects[__SOLIDOBJ_STARTLINKX] = Link->X;
			SolidObjects[__SOLIDOBJ_STARTLINKY] = Link->Y;
		}
		
		//Only move Link around if he's not currently being crushed
		if(SolidObjects[__SOLIDOBJ_CRUSHCOUNTER]==0&&CanBeMoved())
			SolidObjects_UpdateLink();
		
		//SFX: Demonic chanting as enemies twitch around awkwardly
		if(SOLIDOBJ_PUSH_NPC){
			for(int i=Screen->NumNPCs(); i>=1; i--){
				npc n = Screen->LoadNPC(i);
				if(!SolidObjects_CanPushEnemy(n))
					continue;
				SolidObjects_UpdateEnemy(n);
			}
		}
		
		//Clear solid object slots to be set by scripts again the next frame
		SolidObjects_ClearObjects();
		
		SolidObjects[__SOLIDOBJ_LINKLASTX] = Link->X;
		SolidObjects[__SOLIDOBJ_LINKLASTY] = Link->Y;
	}
}

//Returns true if an object being pushed around can move in a direction
bool SolidObjects_CanWalk(int x, int y, int dir, int width, int height, int xoff, int yoff, bool noEdge) {
    int i; int xx; int yy;
	bool offscreen;
	if(dir==DIR_UP||dir==DIR_DOWN){
		for(i=0; i<=width-1; i=Min(i+8, width-1)){
			xx = x+xoff+i;
			if(dir==DIR_UP)
				yy = y+yoff-1;
			else
				yy = y+yoff+height;
			if(xx<0||xx>255||yy<0||yy>175){
				if(noEdge)
					offscreen = true;
				else
					return false;
			}
			if(Screen->isSolid(xx, yy)&&!offscreen)
				return false;
			if(i==width-1)
				break;
		}
		return true;
	}
	else if(dir==DIR_LEFT||dir==DIR_RIGHT){
		for(i=0; i<=height-1; i=Min(i+8, height-1)){
			yy = y+yoff+i;
			if(dir==DIR_LEFT)
				xx = x+xoff-1;
			else
				xx = x+xoff+width;
			if(xx<0||xx>255||yy<0||yy>175){
				if(noEdge)
					offscreen = true;
				else
					return false;
			}
			if(Screen->isSolid(xx, yy)&&!offscreen)
				return false;
			if(i==height-1)
				break;
		}
		return true;
	}
	return false;
}

void SolidObjects_UpdateLink(){
	int totalUp;
	int totalDown;
	int totalLeft;
	int totalRight;
	
	int tempVx;
	int tempVy;
	
	int x; int y; int width; int height; int vX; int vY; int flags;
	
	int linkX = Link->X+SOLIDOBJ_LINKXTRIM;
	int linkY = Link->Y+8;
	int linkWidth = 16-SOLIDOBJ_LINKXTRIM*2;
	int linkHeight = 8;
	
	int platID; //A unique number given to solid objects treated as platforms, to keep track of them between frames
	int platformCandidate = -1; //The platform under Link as found when he steps on it for the first time
	int platformIndex = -1; //The platform under Link as found by its ID
	int platformY;
	int platformPushX;
	int platformPushY;
	
	bool crushDir[4];
	//Link's hitbox is different in sideview
	if(IsSideview()){
		linkX = Link->X+SOLIDOBJ_LINKXTRIM;
		linkY = Link->Y+SOLIDOBJ_LINKYTRIM;
		linkWidth = 16-SOLIDOBJ_LINKXTRIM*2;
		linkHeight = 16-SOLIDOBJ_LINKYTRIM;
	}
	
	for(int i=0; i<SOLIDOBJ_MAX; i++){ //Cycle through all possible objects
		x = SolidObjects[__SOLIDOBJ_STARTINDEX+i*__SOLIDOBJ_NUMATTRIBINDEX+__SOLIDOBJ_OBJ_X];
		y = SolidObjects[__SOLIDOBJ_STARTINDEX+i*__SOLIDOBJ_NUMATTRIBINDEX+__SOLIDOBJ_OBJ_Y];
		width = SolidObjects[__SOLIDOBJ_STARTINDEX+i*__SOLIDOBJ_NUMATTRIBINDEX+__SOLIDOBJ_OBJ_WIDTH];
		height = SolidObjects[__SOLIDOBJ_STARTINDEX+i*__SOLIDOBJ_NUMATTRIBINDEX+__SOLIDOBJ_OBJ_HEIGHT];
		platID = SolidObjects[__SOLIDOBJ_STARTINDEX+i*__SOLIDOBJ_NUMATTRIBINDEX+__SOLIDOBJ_OBJ_ID];
		vX = SolidObjects[__SOLIDOBJ_STARTINDEX+i*__SOLIDOBJ_NUMATTRIBINDEX+__SOLIDOBJ_OBJ_VX];
		vY = SolidObjects[__SOLIDOBJ_STARTINDEX+i*__SOLIDOBJ_NUMATTRIBINDEX+__SOLIDOBJ_OBJ_VY];
		flags = SolidObjects[__SOLIDOBJ_STARTINDEX+i*__SOLIDOBJ_NUMATTRIBINDEX+__SOLIDOBJ_OBJ_FLAGS];
		
		if(width>0){ //Check if there's a solid object at the current index
			if(IsSideview()){
				//If Link is standing on the same platform as his current platform ID
				//Update platform index to that object
				if(SolidObjects[__SOLIDOBJ_ONPLATFORM]==platID&&platID>0){
					platformIndex = i;
				}
			}
			
			if(RectCollision(x, y, x+width-1, y+height-1, linkX, linkY, linkX+linkWidth-1, linkY+linkHeight-1)){
				//Find Link and the object's center points
				int cx1 = x+width/2;
				int cy1 = y+height/2;
				int cx2 = linkX+linkWidth/2;
				int cy2 = linkY+linkHeight/2;
				
				if(cy2<cy1){ //Link is above the object
					tempVy = cy1-cy2-(height+linkHeight)/2;
					if(vY<0)
						crushDir[DIR_UP] = true;
				}
				else{ //Link is below the object
					tempVy = cy1-cy2+(height+linkHeight)/2;
					if(vY>0)
						crushDir[DIR_DOWN] = true;
				}
				
				if(cx2<cx1){ //Link is left of the object
					tempVx = cx1-cx2-(width+linkWidth)/2;
					if(vX<0)
						crushDir[DIR_LEFT] = true;
				}
				else{
					tempVx = cx1-cx2+(width+linkWidth)/2;
					if(vX>0)
						crushDir[DIR_RIGHT] = true;
				}
				
				//Prevent jump-through platforms pushing in any direction but up
				if(flags&SFFCF_TOPONLY){
					tempVx = 1000; //We're setting Vx/Vy to 1000 to cancel them out from calculations
					if(tempVy>0)
						tempVy = 1000;
					if(Link->Y<SolidObjects[__SOLIDOBJ_LINKLASTY])
						tempVy = 1000;
				}
				//If both vectors are cancelled, set them to 0
				if(tempVx==1000&&tempVy==1000){
					tempVx = 0;
					tempVy = 0;
				}
				if(Abs(tempVy)<Abs(tempVx)){ //Find out which push would take less effort
					if(tempVy<0){ //If it's an upwards push
						if(totalUp>tempVy){ //If it's larger than the current max
							totalUp = tempVy; //Update the current max
							//If the platform is going up and has an ID >0, update platformCandidate
							if(IsSideview()&&platID>0){
								platformCandidate = i;
							}
						}
					}
					else if(tempVy>0){ //If it's a downwards push
						if(totalDown<tempVy) //If it's larger than the current max
							totalDown = tempVy; //Update the current max
					}
				}
				else{
					if(tempVx<0){ //If it's a left push
						if(totalLeft>tempVx) //If it's larger than the current max
							totalLeft = tempVx; //Update the current max
					}
					else if(tempVx>0){ //If it's a right push
						if(totalRight<tempVx) //If it's larger than the current max
							totalRight = tempVx; //Update the current max
					}
				}
			}
			//Detect collision with FFCs while Link is standing on the ground next to them
			else if(IsSideview()&&!SolidObjects_CanWalk(Link->X, Link->Y, DIR_DOWN, 8, 16, 4, 0, true)){
				if(RectCollision(x, y, x+width-1, y+height-1, linkX, linkY, linkX+linkWidth-1, linkY+linkHeight-1+2)){
					if(platID>0)
						platformCandidate = i;
				}
			}
		}
	}
	
	if(IsSideview()){
		//If Link isn't on a platform yet
		if(SolidObjects[__SOLIDOBJ_ONPLATFORM]==0){
			//If there's a candidate available and he's going down,
			//set his current platform to that platform's ID
			if(platformCandidate>-1&&Link->Jump<=0){
				SolidObjects[__SOLIDOBJ_ONPLATFORM] = SolidObjects[__SOLIDOBJ_STARTINDEX+platformCandidate*__SOLIDOBJ_NUMATTRIBINDEX+__SOLIDOBJ_OBJ_ID];
				platformY = SolidObjects[__SOLIDOBJ_STARTINDEX+platformCandidate*__SOLIDOBJ_NUMATTRIBINDEX+__SOLIDOBJ_OBJ_Y]-16;
				Link->Jump = 0;
			}
		}
		else{
			//If the platform Link is on has been found
			if(platformIndex>-1){
				if(platformCandidate>-1){
					//If there's a platform candidate and it has a higher Y velocity
					if(SolidObjects[__SOLIDOBJ_STARTINDEX+platformCandidate*__SOLIDOBJ_NUMATTRIBINDEX+__SOLIDOBJ_OBJ_VY]<SolidObjects[__SOLIDOBJ_STARTINDEX+platformIndex*__SOLIDOBJ_NUMATTRIBINDEX+__SOLIDOBJ_OBJ_VY]){
						platformIndex = platformCandidate;
						SolidObjects[__SOLIDOBJ_ONPLATFORM] = SolidObjects[__SOLIDOBJ_STARTINDEX+platformIndex*__SOLIDOBJ_NUMATTRIBINDEX+__SOLIDOBJ_OBJ_ID];
						Link->Jump = 0;
					}
				}
				x = SolidObjects[__SOLIDOBJ_STARTINDEX+platformIndex*__SOLIDOBJ_NUMATTRIBINDEX+__SOLIDOBJ_OBJ_X];
				y = SolidObjects[__SOLIDOBJ_STARTINDEX+platformIndex*__SOLIDOBJ_NUMATTRIBINDEX+__SOLIDOBJ_OBJ_Y];
				width = SolidObjects[__SOLIDOBJ_STARTINDEX+platformIndex*__SOLIDOBJ_NUMATTRIBINDEX+__SOLIDOBJ_OBJ_WIDTH];
				height = SolidObjects[__SOLIDOBJ_STARTINDEX+platformIndex*__SOLIDOBJ_NUMATTRIBINDEX+__SOLIDOBJ_OBJ_HEIGHT];
				platformY = y-16;
				platformPushX = SolidObjects[__SOLIDOBJ_STARTINDEX+platformIndex*__SOLIDOBJ_NUMATTRIBINDEX+__SOLIDOBJ_OBJ_VX];
				platformPushY = platformY-Link->Y; //Link's Y push is based on the difference between Link's position and the position above the platform
				Link->Jump = 0;
				//If Link isn't touching the platform, detach him from it
				if(!RectCollision(x, y, x+width-1, y+height-1, linkX+platformPushX, linkY+platformPushY, linkX+linkWidth-1+platformPushX, linkY+linkHeight-1+4+platformPushY)){
					SolidObjects[__SOLIDOBJ_ONPLATFORM] = 0;
				}
			}
			//If the platform Link is on doesn't exist, detach him
			else{
				SolidObjects[__SOLIDOBJ_ONPLATFORM] = 0;
			}
		}
	}
	
	//Debug draws
	// Screen->DrawInteger(6, 8, 8, FONT_Z1, 0x01, 0x0F, -1, -1, totalUp, 0, 128);
	// Screen->DrawInteger(6, 8, 16, FONT_Z1, 0x01, 0x0F, -1, -1, totalDown, 0, 128);
	// Screen->DrawInteger(6, 8, 24, FONT_Z1, 0x01, 0x0F, -1, -1, totalLeft, 0, 128);
	// Screen->DrawInteger(6, 8, 32, FONT_Z1, 0x01, 0x0F, -1, -1, totalRight, 0, 128);
	
	//Get which directions Link can go in
	//This is based on the speed of Link being pushed out of the platform as well as its current velocity
	bool canGoUp = (totalDown==0)||!crushDir[DIR_DOWN];
	bool canGoDown = (totalUp==0)||!crushDir[DIR_UP];
	bool canGoLeft = (totalRight==0)||!crushDir[DIR_RIGHT];
	bool canGoRight = (totalLeft==0)||!crushDir[DIR_LEFT];
	
	//Add rough offsets to cancel out Link's movement
	int cancelMoveX = -LinkMovement[LM_STICKX];
	int cancelMoveY = -LinkMovement[LM_STICKY];
	if(IsSideview())
		cancelMoveY = 0;
	
	//Update the valid directions based on screen solidity in the way
	if(IsSideview()){ //Link's hitbox is different in sideview
		if(!SolidObjects_CanWalk(Link->X+cancelMoveX, Link->Y+cancelMoveY, DIR_UP, 8, 16, 4, 0, true))
			canGoUp = false;
		if(!SolidObjects_CanWalk(Link->X+cancelMoveX, Link->Y+cancelMoveY, DIR_DOWN, 8, 16, 4, 0, true)){
			canGoDown = false;
			//Detach Link from a platform if he's on the ground and not directly above the platform
			if(Abs(platformY-Link->Y)>2)
				SolidObjects[__SOLIDOBJ_ONPLATFORM] = 0;
		}
		if(!SolidObjects_CanWalk(Link->X+cancelMoveX, Link->Y+cancelMoveY, DIR_LEFT, 16, 16, 0, 0, true))
			canGoLeft = false;
		if(!SolidObjects_CanWalk(Link->X+cancelMoveX, Link->Y+cancelMoveY, DIR_RIGHT, 16, 16, 0, 0, true))
			canGoRight = false;
	}
	else{
		if(!SolidObjects_CanWalk(Link->X+cancelMoveX, Link->Y+cancelMoveY, DIR_UP, 16, 8, 0, 8, true))
			canGoUp = false;
		if(!SolidObjects_CanWalk(Link->X+cancelMoveX, Link->Y+cancelMoveY, DIR_DOWN, 16, 8, 0, 8, true))
			canGoDown = false;
		if(!SolidObjects_CanWalk(Link->X+cancelMoveX, Link->Y+cancelMoveY, DIR_LEFT, 16, 8, 0, 8, true))
			canGoLeft = false;
		if(!SolidObjects_CanWalk(Link->X+cancelMoveX, Link->Y+cancelMoveY, DIR_RIGHT, 16, 8, 0, 8, true))
			canGoRight = false;
	}
	//Set Link's jump to 0 if he's jumping up into a ceiling
	if(Link->Jump>0&&totalDown>0&&IsSideview())
		Link->Jump = 0;
	
	int crush = -1;
	if(SOLIDOBJ_CRUSH_BEHAVIOR){
		int crushStrengthX = Max(Abs(totalLeft), Abs(totalRight));
		int crushStrengthY = Max(Abs(totalUp), Abs(totalDown));
		//Detect if Link is between two walls
		if(!canGoUp&&!canGoDown){
			//Detect if he's far enough in to be crushed
			if(crushStrengthY>=SOLIDOBJ_CRUSH_SAFETY){
				crush = 4;
				//Set crush direction if Link is pushed against a wall
				if(Abs(totalUp)>0&&totalDown==0)
					crush = DIR_UP;
				else if(Abs(totalDown)>0&&totalUp==0)
					crush = DIR_DOWN;
			}
		}
		if(!canGoLeft&&!canGoRight){
			if(crushStrengthX>=SOLIDOBJ_CRUSH_SAFETY){
				//If he's being more crushed vertically than horizontally, prioritize that
				if((crush==DIR_UP||crush==DIR_DOWN||crush==4)&&crushStrengthY>crushStrengthX){
					crush = 4;
					if(Abs(totalUp)>0&&totalDown==0)
						crush = DIR_UP;
					else if(Abs(totalDown)>0&&totalUp==0)
						crush = DIR_DOWN;
				}
				else{
					crush = 5;
					if(Abs(totalLeft)>0&&totalRight==0)
						crush = DIR_LEFT;
					else if(Abs(totalRight)>0&&totalLeft==0)
						crush = DIR_RIGHT;
				}
			}
		}
	}
	
	//If Link is being crushed
	if(crush>-1&&Link->CollDetection){
		if(SOLIDOBJ_CRUSH_BEHAVIOR==2){ //Instant death crush
			Link->HP = 0;
		}
		else{ //Teleport crush
			SolidObjects[__SOLIDOBJ_FORCELINKX] = Link->X;
			SolidObjects[__SOLIDOBJ_FORCELINKY] = Link->Y;
			lweapon lcrush = CreateLWeaponAt(LW_SPARKLE, Link->X, Link->Y);
			lcrush->UseSprite(SPR_LINKCRUSH);
			lcrush->DeadState = Max(lcrush->ASpeed*lcrush->NumFrames-1, 1);
			if(SOLIDOBJ_COMPLEX_CRUSH_ANIM){
				lcrush->OriginalTile += crush*20;
				lcrush->Tile = lcrush->OriginalTile;
			}
			else{
				if(crush==DIR_LEFT||crush==DIR_RIGHT||crush==5){ //Offset tiles based on direction of the crushing
					lcrush->OriginalTile += 20;
					lcrush->Tile = lcrush->OriginalTile;
				}
			}
			Link->Invisible = true;
			Link->CollDetection = false;
			SolidObjects[__SOLIDOBJ_CRUSHCOUNTER] = lcrush->DeadState+DELAY_CRUSH;
			Game->PlaySound(SFX_LINKCRUSH);
			SolidObjects[__SOLIDOBJ_ONPLATFORM] = 0;
		}
	}
	else{ //Otherwise, move him around
		if(IsSideview()&&(totalUp+totalDown)<0&&SolidObjects[__SOLIDOBJ_ONPLATFORM]>0)
			Link->Jump = 0;
		SolidObjects_SafePush2NoEdge(totalLeft+totalRight+platformPushX, totalUp+totalDown+platformPushY); //Move Link by the combination of strongest inputs. Opposing Left/Right, Up/Down should cancel out
	}
}

//This function prevents the script from overfilling the push counter
void SolidObjects_SafePush2NoEdge(int vX, int vY){
	if(Abs(LinkMovement[LM_PUSHX2B])>=1)
		vX = 0;
	if(Abs(LinkMovement[LM_PUSHY2B])>=1)
		vY = 0;
	LinkMovement_Push2NoEdge(vX, vY);
}

bool SolidObjects_CollideWithLink(int checkX, int checkY){
	int x; int y; int width; int height; int vX; int vY;
	int linkX = checkX+SOLIDOBJ_LINKXTRIM;
	int linkY = checkY+8;
	int linkWidth = 16-SOLIDOBJ_LINKXTRIM*2;
	int linkHeight = 8;
	if(IsSideview()){
		linkX = Link->X+SOLIDOBJ_LINKXTRIM;
		linkY = Link->Y+SOLIDOBJ_LINKYTRIM;
		linkWidth = 16-SOLIDOBJ_LINKXTRIM*2;
		linkHeight = 16-SOLIDOBJ_LINKYTRIM;
	}
	for(int i=0; i<SOLIDOBJ_MAX; i++){ //Cycle through all possible objects
		x = SolidObjects[__SOLIDOBJ_STARTINDEX+i*__SOLIDOBJ_NUMATTRIBINDEX+__SOLIDOBJ_OBJ_X];
		y = SolidObjects[__SOLIDOBJ_STARTINDEX+i*__SOLIDOBJ_NUMATTRIBINDEX+__SOLIDOBJ_OBJ_Y];
		width = SolidObjects[__SOLIDOBJ_STARTINDEX+i*__SOLIDOBJ_NUMATTRIBINDEX+__SOLIDOBJ_OBJ_WIDTH];
		height = SolidObjects[__SOLIDOBJ_STARTINDEX+i*__SOLIDOBJ_NUMATTRIBINDEX+__SOLIDOBJ_OBJ_HEIGHT];
		//If one of them collides with Link, return true
		if(RectCollision(x, y, x+width-1, y+height-1, linkX, linkY, linkX+linkWidth-1, linkY+linkHeight-1)){
			return true;
		}
	}
	return false;
}

void SolidObjects_UpdateEnemy(npc n){
	int totalUp;
	int totalDown;
	int totalLeft;
	int totalRight;
	
	int tempVx;
	int tempVy;
	
	int x; int y; int width; int height;
	int nX = n->X+n->HitXOffset;
	int nY = n->Y+n->HitYOffset;
	int nWidth = n->HitWidth;
	int nHeight = n->HitHeight;
	for(int i=0; i<SOLIDOBJ_MAX; i++){ //Cycle through all possible objects
		x = SolidObjects[__SOLIDOBJ_STARTINDEX+i*__SOLIDOBJ_NUMATTRIBINDEX+__SOLIDOBJ_OBJ_X];
		y = SolidObjects[__SOLIDOBJ_STARTINDEX+i*__SOLIDOBJ_NUMATTRIBINDEX+__SOLIDOBJ_OBJ_Y];
		width = SolidObjects[__SOLIDOBJ_STARTINDEX+i*__SOLIDOBJ_NUMATTRIBINDEX+__SOLIDOBJ_OBJ_WIDTH];
		height = SolidObjects[__SOLIDOBJ_STARTINDEX+i*__SOLIDOBJ_NUMATTRIBINDEX+__SOLIDOBJ_OBJ_HEIGHT];
		int flags = SolidObjects[__SOLIDOBJ_STARTINDEX+i*__SOLIDOBJ_NUMATTRIBINDEX+__SOLIDOBJ_OBJ_FLAGS];
		if(width>0&&flags&SFFCF_PUSHNPC){ //Check if there's a solid object at the current index
			//Debug hitbox draw
			//Screen->Rectangle(2, x, y, x+width-1, y+height-1, 0x01, 1, 0, 0, 0, true, 64);
			if(RectCollision(x, y, x+width-1, y+height-1, nX, nY, nX+nWidth-1, nY+nHeight-1)){
				//Find NPC and the object's center points
				int cx1 = x+width/2;
				int cy1 = y+height/2;
				int cx2 = nX+nWidth/2;
				int cy2 = nY+nHeight/2;
				
				if(cy2<cy1){ //NPC is above the object
					tempVy = cy1-cy2-(height+nHeight)/2;
				}
				else{ //NPC is below the object
					tempVy = cy1-cy2+(height+nHeight)/2;
				}
				
				if(cx2<cx1){ //NPC is left of the object
					tempVx = cx1-cx2-(width+nWidth)/2;
				}
				else{
					tempVx = cx1-cx2+(width+nWidth)/2;
				}
				
				//Prevent jump-through platforms pushing in any direction but up
				if(flags&SFFCF_TOPONLY){
					tempVx = 1000; //We're setting Vx/Vy to 1000 to cancel them out from calculations
					if(tempVy>0)
						tempVy = 1000;
				}
				//If both vectors are cancelled, set them to 0
				if(tempVx==1000&&tempVy==1000){
					tempVx = 0;
					tempVy = 0;
				}
				if(Abs(tempVy)<Abs(tempVx)){ //Find out which push would take less effort
					if(tempVy<0){ //If it's an upwards push
						if(totalUp>tempVy) //If it's larger than the current max
							totalUp = tempVy; //Update the current max
					}
					else if(tempVy>0){ //If it's a downwards push
						if(totalDown<tempVy) //If it's larger than the current max
							totalDown = tempVy; //Update the current max
					}
				}
				else{
					if(tempVx<0){ //If it's a left push
						if(totalLeft>tempVx) //If it's larger than the current max
							totalLeft = tempVx; //Update the current max
					}
					else if(tempVx>0){ //If it's a right push
						if(totalRight<tempVx) //If it's larger than the current max
							totalRight = tempVx; //Update the current max
					}
				}
			}
		}
	}
	//Debug draws
	// Screen->DrawInteger(6, 8, 8, FONT_Z1, 0x01, 0x0F, -1, -1, totalUp, 0, 128);
	// Screen->DrawInteger(6, 8, 16, FONT_Z1, 0x01, 0x0F, -1, -1, totalDown, 0, 128);
	// Screen->DrawInteger(6, 8, 24, FONT_Z1, 0x01, 0x0F, -1, -1, totalLeft, 0, 128);
	// Screen->DrawInteger(6, 8, 32, FONT_Z1, 0x01, 0x0F, -1, -1, totalRight, 0, 128);
	
	bool canGoUp = (totalDown==0);
	bool canGoDown = (totalUp==0);
	bool canGoLeft = (totalRight==0);
	bool canGoRight = (totalLeft==0);
	
	if(!SolidObjects_CanWalk(n->X, n->Y, DIR_UP, n->HitWidth, n->HitHeight, n->HitXOffset, n->HitYOffset, true))
		canGoUp = false;
	if(!SolidObjects_CanWalk(n->X, n->Y, DIR_DOWN, n->HitWidth, n->HitHeight, n->HitXOffset, n->HitYOffset, true))
		canGoDown = false;
	if(!SolidObjects_CanWalk(n->X, n->Y, DIR_LEFT, n->HitWidth, n->HitHeight, n->HitXOffset, n->HitYOffset, true))
		canGoLeft = false;
	if(!SolidObjects_CanWalk(n->X, n->Y, DIR_RIGHT, n->HitWidth, n->HitHeight, n->HitXOffset, n->HitYOffset, true))
		canGoRight = false;
	
	int crush = 0;
	if(SOLIDOBJ_CRUSH_BEHAVIOR){
		int crushStrengthX = Max(Abs(totalLeft), Abs(totalRight));
		int crushStrengthY = Max(Abs(totalUp), Abs(totalDown));
		//Detect if NPC is between two walls
		if(!canGoUp&&!canGoDown){
			//Detect if it's far enough in to be crushed
			if(crushStrengthY>=SOLIDOBJ_CRUSH_SAFETY){
				crush = 1;
			}
		}
		if(!canGoLeft&&!canGoRight){
			if(crushStrengthX>=SOLIDOBJ_CRUSH_SAFETY){
				crush = 1;
			}
		}
	}
	if(crush&&n->CollDetection){
		n->HP = 0;
		Game->PlaySound(SFX_ENEMYCRUSH);
	}
	else
		SolidObjects_PushEnemy(n, totalLeft+totalRight, totalUp+totalDown);//Move NPC by the combination of strongest inputs. Opposing Left/Right, Up/Down should cancel out
}

void SolidObjects_PushEnemy(npc n, int pushX, int pushY){
	pushX = Round(pushX);
	pushY = Round(pushY);
	//Until both pushX and pushY are drained down to 0, continue to push the enemy
	while(pushX!=0||pushY!=0){
		if(pushX<0){
			//But not through solid objects
			if(SolidObjects_CanWalk(n->X, n->Y, DIR_LEFT, n->HitWidth, n->HitHeight, n->HitXOffset, n->HitYOffset, true))
				SetEnemyProperty(n, ENPROP_X, GetEnemyProperty(n, ENPROP_X)-1);
			pushX++;
		}
		else if(pushX>0){
			if(SolidObjects_CanWalk(n->X, n->Y, DIR_RIGHT, n->HitWidth, n->HitHeight, n->HitXOffset, n->HitYOffset, true))
				SetEnemyProperty(n, ENPROP_X, GetEnemyProperty(n, ENPROP_X)+1);
			pushX--;
		}
		if(pushY<0){
			if(SolidObjects_CanWalk(n->X, n->Y, DIR_UP, n->HitWidth, n->HitHeight, n->HitXOffset, n->HitYOffset, true))
				SetEnemyProperty(n, ENPROP_Y, GetEnemyProperty(n, ENPROP_Y)-1);
			pushY++;
		}
		else if(pushY>0){
			if(SolidObjects_CanWalk(n->X, n->Y, DIR_DOWN, n->HitWidth, n->HitHeight, n->HitXOffset, n->HitYOffset, true))
				SetEnemyProperty(n, ENPROP_Y, GetEnemyProperty(n, ENPROP_Y)+1);
			pushY--;
		}
	}
	//If the enemy gets pushed off the screen, kill it
	if(GetEnemyProperty(n, ENPROP_X)<-n->HitXOffset-n->HitWidth ||
		GetEnemyProperty(n, ENPROP_X)>256 ||
		GetEnemyProperty(n, ENPROP_Y)<-n->HitYOffset-n->HitHeight ||
		GetEnemyProperty(n, ENPROP_Y)>176 ){
			
		SetEnemyProperty(n, ENPROP_HP, -1000);
		n->ItemSet = -1000;
		n->DrawYOffset = -1000;
	}
}

bool SolidObjects_CanPushEnemy(npc n){
	int type = n->Type;
	//If the enemy is invulnerable, don't push it
	if(Abs(n->HitXOffset)>=1000||Abs(n->HitYOffset)>=1000)
		return false;
	//If the enemy is in the air, don't push it
	if(n->Z>0)
		return false;
	//Check if the enemy is a type that can be pushed
	if(type==NPCT_WALK)
		return true;
	if(type==NPCT_TEKTITE)
		return true;
	if(type==NPCT_LEEVER)
		return true;
	if(type==NPCT_ZORA)
		return true;
	if(type==NPCT_GHINI)
		return true;
	if(type==NPCT_ARMOS)
		return true;
	if(type==NPCT_WIZZROBE)
		return true;
	if(type==NPCT_OTHERFLOAT)
		return true;
	if(type==NPCT_OTHER)
		return true;
	
	return false;
}

void SolidObjects_ClearObjects(){
	for(int i=0; i<SOLIDOBJ_MAX; i++){ //Cycle through all possible objects
		//Clear the properties
		SolidObjects[__SOLIDOBJ_STARTINDEX+i*__SOLIDOBJ_NUMATTRIBINDEX+__SOLIDOBJ_OBJ_X] = 0;
		SolidObjects[__SOLIDOBJ_STARTINDEX+i*__SOLIDOBJ_NUMATTRIBINDEX+__SOLIDOBJ_OBJ_Y] = 0;
		SolidObjects[__SOLIDOBJ_STARTINDEX+i*__SOLIDOBJ_NUMATTRIBINDEX+__SOLIDOBJ_OBJ_WIDTH] = 0;
		SolidObjects[__SOLIDOBJ_STARTINDEX+i*__SOLIDOBJ_NUMATTRIBINDEX+__SOLIDOBJ_OBJ_HEIGHT] = 0;
		SolidObjects[__SOLIDOBJ_STARTINDEX+i*__SOLIDOBJ_NUMATTRIBINDEX+__SOLIDOBJ_OBJ_FLAGS] = 0;
	}
	//Reset the count
	SolidObjects[__SOLIDOBJ_COUNT] = 0;
}

//D0: Width of the hitbox
//D1: Height of the hitbox
//D2: X offset from the FFC's position for the hitbox
//D3: Y offset from the FFC's position for the hitbox
//D4: Flags. Add these together to get the result:
//		1 - Only the top of the FFC is solid
//		2 - The FFC pushes enemies
//D5: FFC to link movement to
//D6: Combo ID that makes the FFC nonsolid when it switches to
ffc script Solid_FFC{
	void run(int width, int height, int xoff, int yoff, int flags, int refFFC, int nonSolidCMB){
		//Default width/height
		if(width==0){
			width = this->TileWidth*16;
			height = this->TileHeight*16;
		}
		
		//Set the platform ID to this FFC's number
		int ID;
		for(int i=1; i<=32; i++){
			ffc f = Screen->LoadFFC(i);
			if(f==this)
				ID = i;
		}
		int lastX = this->X;
		int lastY = this->Y;
		ffc ref;
		if(refFFC>0)
			ref = Screen->LoadFFC(refFFC);
		while(true){
			//Handle scripted FFC linking
			if(refFFC>0){
				if(ref->Delay==0){
					this->Vx = ref->Vx;
					this->Vy = ref->Vy;
				}
				else{
					this->Vx = 0;
					this->Vy = 0;
				}
			}
			//We're using difference in position instead of the FFC's Vx and Vy
			//because of float imprecision. Doing it the other way caused Link to get
			//desynced from the FFC
			int vX = this->X-lastX;
			int vY = this->Y-lastY;
			lastX = this->X;
			lastY = this->Y;
			if(this->Delay>0){
				vX = 0;
				vY = 0;
			}
			if(width>0&&this->Data!=nonSolidCMB){
				SolidObjects_Add(ID, this->X+xoff, this->Y+yoff, width, height, vX, vY, flags);
			}
			Waitframe();
		}
	}
}

//D0: Radius to put the platform at
//D1: Starting angle for the platform
//D2: Rotation speed of the platform
//D3: Flags. Add these together to get the result:
//		1 - Only the top of the FFC is solid
//		2 - The FFC pushes enemies
ffc script Moving_Platform_Circular{
	void run(int r, int ang, int rot, int flags){
		//Set the platform ID to this FFC's number
		int ID;
		for(int i=1; i<=32; i++){
			ffc f = Screen->LoadFFC(i);
			if(f==this)
				ID = i;
		}
		int startX = this->X;
		int startY = this->Y;
		int lastX = this->X;
		int lastY = this->Y;
		while(true){
			int x = startX+VectorX(r, ang);
			int y = startY+VectorY(r, ang);
			this->X = x;
			this->Y = y;
			//We're using difference in position instead of the FFC's Vx and Vy
			//because of float imprecision. Doing it the other way caused Link to get
			//desynced from the FFC
			int vX = this->X-lastX;
			int vY = this->Y-lastY;
			lastX = this->X;
			lastY = this->Y;
			ang = WrapDegrees(ang+rot);
			SolidObjects_Add(ID, this->X, this->Y, this->EffectWidth, this->EffectHeight, vX, vY, flags);
			Waitframe();
		}
	}
}

//D0: How many frames to shake for
//D1: Flags. Add these together to get the result:
//		1 - Only the top of the FFC is solid
//		2 - The FFC pushes enemies
ffc script Moving_Platform_StepActivate{
	void run(int shakeFrames, int flags){
		//Set the platform ID to this FFC's number
		int ID;
		for(int i=1; i<=32; i++){
			ffc f = Screen->LoadFFC(i);
			if(f==this)
				ID = i;
		}
		//Store the FFC's starting state
		int startX = this->X;
		int startY = this->Y;
		int savedVX = this->Vx;
		int savedVY = this->Vy;
		int savedAX = this->Ax;
		int savedAY = this->Ay;
		int savedDelay = this->Delay;
		//Clear the FFC's state
		this->Vx = 0;
		this->Vy = 0;
		this->Ax = 0;
		this->Ay = 0;
		this->Delay = 0;
		//If __SOLIDOBJ_ONPLATFORM doesn't equal this FFC's number, Link hasn't stepped on the platform yet
		while(SolidObjects[__SOLIDOBJ_ONPLATFORM]!=ID){
			SolidObjects_Add(ID, this->X, this->Y, this->EffectWidth, this->EffectHeight, 0, 0, flags);
			Waitframe();
		}
		int lastX = this->X;
		int lastY = this->Y;
		int vX; int vY;
		//Play a shake animation for the specified number of frames before "falling"
		if(shakeFrames>0){
			for(int i=0; i<shakeFrames; i++){
				if(i%8<2){
					this->X = startX-1;
				}
				else if(i%8>=4&&i%8<6){
					this->X = startX+1;
				}
				else{
					this->X = startX;
				}
				
				vX = this->X-lastX;
				vY = this->Y-lastY;
				lastX = this->X;
				lastY = this->Y;
				
				SolidObjects_Add(ID, this->X, this->Y, this->EffectWidth, this->EffectHeight, vX, vY, flags);
				Waitframe();
			}
			this->X = startX;
			this->Y = startY;
		}
		//Restore the FFC to the starting state when it "falls"
		this->Vx = savedVX;
		this->Vy = savedVY;
		this->Ax = savedAX;
		this->Ay = savedAY;
		this->Delay = savedDelay;
		while(true){
			//We're using difference in position instead of the FFC's Vx and Vy
			//because of float imprecision. Doing it the other way caused Link to get
			//desynced from the FFC
			vX = this->X-lastX;
			vY = this->Y-lastY;
			lastX = this->X;
			lastY = this->Y;
			
			SolidObjects_Add(ID, this->X, this->Y, this->EffectWidth, this->EffectHeight, vX, vY, flags);
			Waitframe();
		}
	}
}


item script FeatherAction{
	void run(){
		//This script makes Link able to jump with Roc's feather when on a sideview platform
		if(SolidObjects[__SOLIDOBJ_ONPLATFORM]){
			Game->PlaySound(SFX_JUMP);
			Link->Jump = (this->Power+2)*0.8;
			SolidObjects[__SOLIDOBJ_ONPLATFORM] = 0;
		}
	}
}

//Example global script combined with ghost and LinkMovement
global script SolidObject_Example_Combined{
	void run(){
		StartGhostZH();
		LinkMovement_Init();
		SolidObjects_Init();
		while(true){
			UpdateGhostZH1();
			SolidObjects_Update1();
			LinkMovement_Update1();
			Waitdraw();
			UpdateGhostZH2();
			SolidObjects_Update2();
			LinkMovement_Update2();
			Waitframe();
		}
	}
}

//Example global script with just this script's functions
global script SolidObject_Example{
	void run(){
		SolidObjects_Init();
		while(true){
			SolidObjects_Update1();
			Waitdraw();
			SolidObjects_Update2();
			Waitframe();
		}
	}
}

const int SFX_TIMERTICK = 57;

void UpdateTimers(){
	if(G[G_TIMER1]){
		if(G[G_TIMER1]<=60){
			if(G[G_TIMER1]%10==0)
				Game->PlaySound(SFX_TIMERTICK);
		}
		else{
			if(G[G_TIMER1]%60==0)
				Game->PlaySound(SFX_TIMERTICK);
		}
		--G[G_TIMER1];
	}
	if(G[G_TIMER2]){
		if(G[G_TIMER2]<=60){
			if(G[G_TIMER2]%10==0)
				Game->PlaySound(SFX_TIMERTICK);
		}
		else{
			if(G[G_TIMER2]%60==0)
				Game->PlaySound(SFX_TIMERTICK);
		}
		--G[G_TIMER2];
	}
	if(G[G_TIMER3]){
		if(G[G_TIMER3]<=60){
			if(G[G_TIMER3]%10==0)
				Game->PlaySound(SFX_TIMERTICK);
		}
		else{
			if(G[G_TIMER3]%60==0)
				Game->PlaySound(SFX_TIMERTICK);
		}
		--G[G_TIMER3];
	}
	if(G[G_MUSICCHANGECOOLDOWN])
		--G[G_MUSICCHANGECOOLDOWN];
	if(G[G_HADOUKENCOOLDOWN])
		--G[G_HADOUKENCOOLDOWN];
	
	++G[G_GLOBALFRAMES];
	if(G[G_GLOBALFRAMES]>=60){
		if(G[G_WINNOHINTCOOLDOWN])
			--G[G_WINNOHINTCOOLDOWN];
		++G[G_GLOBALSECONDS];
		G[G_GLOBALFRAMES] = 0;
	}
	if(G[G_GLOBALSECONDS]>=60){
		++G[G_GLOBALMINUTES];
		G[G_GLOBALSECONDS] = 0;
	}
	if(G[G_GLOBALMINUTES]>=60){
		++G[G_GLOBALHOURS];
		if(G[G_RANDOMIZERENABLED]){
			for(int i=0; i<8; ++i){
				Game->SetDMapScreenD(45, 0x2E, i, 0);
				Game->SetDMapScreenD(45, 0x2F, i, 0);
				Game->SetDMapScreenD(45, 0x3E, i, 0);
				Game->SetDMapScreenD(45, 0x3F, i, 0);
			}
		}
		G[G_GLOBALMINUTES] = 0;
	}
	if(!G[G_NOOUTFITEFFECTS]&&Link->Action==LA_WALKING&&G[G_PANTS+GetCharID()]==BOTTOM_ARMOR){
		++G[G_CLANKTIMER];
		if(G[G_CLANKTIMER]==32){
			G[G_CLANKTIMER] = 0;
			Game->PlaySound(176);
		}
	}
}

void UpdateTangoStringContainer(){
	if(!G[G_MSGACTIVE])
		return;
	int scroll = (Link->InputUp?-1:0) + (Link->InputDown?1:0);
	int flags = TANGO_FLAG_ENABLE_SPEEDUP | TANGO_FLAG_PERSISTENT;
	if(Link->InputB)
		flags |= TANGO_FLAG_LINE_BY_LINE;
	if(G[G_MSGTIMER] > 50 || Link->InputB)
		flags &= ~TANGO_FLAG_PERSISTENT;
	if(!G[G_PASSIVESTRINGDISPLAY])
		KillDirInput();
	//I think this is trying to prevent ending the message prematurely before the 50 frames.
	if(Link->InputA && !Tango_SlotIsFinished(0)){
		if(!G[G_PASSIVESTRINGDISPLAY])Link->PressA = false;
	}
	if(Tango_SlotIsFinished(0)){
		if(scroll!=0&&!G[G_PASSIVESTRINGDISPLAY]){
			G[G_TEXTSCROLLSPEED] = Clamp(G[G_TEXTSCROLLSPEED]+0.005, 0.2, 1);
			Tango_ScrollSlot(0, scroll*4*G[G_TEXTSCROLLSPEED]);
		}
		else{
			G[G_TEXTSCROLLSPEED] = 0;
		}
		if(G[G_MSGTIMER]<=50)
			G[G_MSGTIMER]++;
	}
	if((Link->PressA || Link->PressB) && G[G_MSGTIMER] > 50){
		Tango_ClearSlot(0);
		G[G_MSGACTIVE] = 0;
	}
	//Something can seriously fuck up here and I don't know why, but this should fix
	if(!Tango_SlotIsActive(0)){
		G[G_MSGACTIVE] = 0;
		return;
	}
		
	if(G[G_MSGEMOTECOOLDOWN]>0){
		--G[G_MSGEMOTECOOLDOWN];
		if(G[G_MSGEMOTECOOLDOWN]==0){
			G[G_PORTRAITEMOTETIL] = 0;
		}
	}
	Tango_SetStyleAttribute(STYLE_NPC, TANGO_STYLE_FLAGS, flags);
	if(G[G_PASSIVESTRINGDISPLAY])
		DrawNameboxPassive(G[G_MSGX], G[G_MSGY], NameBuf);
	else
		DrawNamebox(G[G_MSGX], G[G_MSGY], G[G_PORTRAITTIL], G[G_PORTRAITEMOTETIL], NameBuf);
}

const int MAP_OVERUNDER = 1;
const int SCREEN_OVERUNDER = 0x71;

void OverUnderExceptionsL2(int pos, mapdata l2){
	if(l2->ComboT[pos]==CT_SLASHNEXTITEM){
		Screen->ComboD[pos] = l2->ComboD[pos];
		Screen->ComboC[pos] = l2->ComboC[pos];
		l2->ComboD[pos] = 0;
	}
	if(l2->ComboT[pos]==CT_CHEST){
		Screen->ComboD[pos] = l2->ComboD[pos];
		Screen->ComboC[pos] = l2->ComboC[pos];
		l2->ComboD[pos] = 0;
	}
}

bool OverUnderNoUpdateL4(int pos, mapdata l4){
	int cd = l4->ComboD[pos];
	if(cd>=37240&&cd<=37271)
		return true;
	if(cd>=37440&&cd<=37471)
		return true;
	return false;
}

bool IsOverUnderBridge(mapdata lyr, int i){
	return lyr->ComboT[i]==CT_BRIDGE||lyr->ComboF[i]==CF_OVERUNDERBRIDGE||lyr->ComboI[i]==CF_OVERUNDERBRIDGE||(lyr->ComboF[i]==CF_OVERUNDERBELOWLAYER&&lyr->ComboS[i]>0);
}

void UpdateOverUnderScreens(){
	mapdata newbuffer = Game->LoadMapData(MAP_OVERUNDER, SCREEN_OVERUNDER);
	mapdata l1 = Game->LoadTempScreen(1);
	mapdata l2new = Game->LoadTempScreen(2);
	mapdata l4new = Game->LoadTempScreen(4);
	G[G_OVERUNDERSCREEN] = 0;
	
	for(int i=0; i<176; ++i){
		ScreenWalkFlags[i] = SWF_FULLSOLID; //Fully Solid
		ScreenWalkFlags[i+176] = 16; 
		ScreenWalkFlags[i+352] = 16;
		newbuffer->ComboD[i] = 0;
		newbuffer->ComboF[i] = 0;
		if(l4new->ComboT[i]==CT_BRIDGE||l4new->ComboF[i]==CF_OVERUNDERBRIDGE||l4new->ComboI[i]==CF_OVERUNDERBRIDGE){
			G[G_OVERUNDERSCREEN] = 1;
			ScreenWalkFlags[i] = SWF_SOLIDUNDERBRIDGE; //Wall under bridge
			ScreenWalkFlags[i+176] = Screen->ComboS[i]|l1->ComboS[i]|l2new->ComboS[i];
			ScreenWalkFlags[i+352] = l4new->ComboS[i];
			// if(Screen->ComboS[i]==0){
			if(l4new->ComboS[i]!=0)
				ScreenWalkFlags[i] = SWF_BELOW; //Below (guard rails)
			else
				ScreenWalkFlags[i] = SWF_BRIDGE; //Bridge
			// }
			// else{
				// if(l4new->ComboS[i]!=0)
					// ScreenWalkFlags[i] = SWF_FULLSOLID; //Fully Solid
			// }
			newbuffer->ComboD[i] = l4new->ComboD[i];
			newbuffer->ComboC[i] = l4new->ComboC[i];
			newbuffer->ComboF[i] = l4new->ComboF[i];
			if(G[G_OVERUNDERLAYER]==1){
				if(!OverUnderNoUpdateL4(i, l4new)&&!OverUnderNoUpdateL4(i, newbuffer))
					l4new->ComboD[i] = 0;
				l2new->ComboD[i] = newbuffer->ComboD[i];
				l2new->ComboC[i] = newbuffer->ComboC[i];
				l2new->ComboF[i] = newbuffer->ComboF[i];
				OverUnderExceptionsL2(i, l2new);
			}
		}
		else if(l4new->ComboF[i]==CF_OVERUNDERABOVELAYER){
			G[G_OVERUNDERSCREEN] = 1;
			ScreenWalkFlags[i] = SWF_ABOVE; //Above
			ScreenWalkFlags[i+176] = 1111b;
			ScreenWalkFlags[i+352] = Screen->ComboS[i]|l1->ComboS[i]|l2new->ComboS[i];
		}
		else if(l4new->ComboF[i]==CF_OVERUNDERBELOWLAYER){
			G[G_OVERUNDERSCREEN] = 1;
			ScreenWalkFlags[i] = SWF_BELOW; //Below
			ScreenWalkFlags[i+176] = Screen->ComboS[i]|l1->ComboS[i]|l2new->ComboS[i];
			ScreenWalkFlags[i+352] = l4new->ComboS[i];
			if(l4new->ComboS[i]>0&&!OverUnderNoUpdateL4(i, l4new)&&!OverUnderNoUpdateL4(i, newbuffer)){
				newbuffer->ComboD[i] = l4new->ComboD[i];
				newbuffer->ComboC[i] = l4new->ComboC[i];
				newbuffer->ComboF[i] = l4new->ComboF[i];
				if(G[G_OVERUNDERLAYER]==1){
					l4new->ComboD[i] = 0;
					l2new->ComboD[i] = newbuffer->ComboD[i];
					l2new->ComboC[i] = newbuffer->ComboC[i];
					l2new->ComboF[i] = newbuffer->ComboF[i];
					OverUnderExceptionsL2(i, l2new);
				}
			}
		}
	}
}

void UpdateOverUnder(){
	mapdata newbuffer = Game->LoadMapData(MAP_OVERUNDER, SCREEN_OVERUNDER);
	mapdata l2new = Game->LoadTempScreen(2);
	mapdata l4new = Game->LoadTempScreen(4);
	
	bool swappedFloors;
	int linkPos = ComboAt(Link->X+8, Link->Y+12);
	if(Link->Z == 0){
		if(l4new->ComboF[linkPos]==CF_OVERUNDERABOVELAYER){
			if(G[G_OVERUNDERLAYER]==0)
				swappedFloors = true;
			G[G_OVERUNDERLAYER] = 1;
		}
		else if(l4new->ComboF[linkPos]==CF_OVERUNDERBELOWLAYER){
			if(G[G_OVERUNDERLAYER]==1)
				swappedFloors = true;
			G[G_OVERUNDERLAYER] = 0;
		}
	}
	
	if(swappedFloors){
		for(int i=0; i<176; ++i){
			if(IsOverUnderBridge(newbuffer, i)){
				if(G[G_OVERUNDERLAYER]==0){
					l2new->ComboD[i] = 0;
					l2new->ComboF[i] = 0;
					l4new->ComboD[i] = newbuffer->ComboD[i];
					l4new->ComboC[i] = newbuffer->ComboC[i];
					l4new->ComboF[i] = newbuffer->ComboF[i];
				}
				else if(G[G_OVERUNDERLAYER]==1){
					l4new->ComboD[i] = 0;
					l4new->ComboF[i] = 0;
					l2new->ComboD[i] = newbuffer->ComboD[i];
					l2new->ComboC[i] = newbuffer->ComboC[i];
					l2new->ComboF[i] = newbuffer->ComboF[i];
					OverUnderExceptionsL2(i, l2new);
				}
			}
		}
	}
	// for(int i=0; i<176; ++i){
		// Screen->DrawInteger(6, ComboX(i), ComboY(i), FONT_Z3SMALL, 0x01, 0x0F, -1, -1, ScreenWalkFlags[i], 0, 128);
	// }
}

void UpdateAreaLoreTracking(){
	int loc = DMapLocation(Game->GetCurDMap());
	if(loc>-1){
		if(LoreTracking[LT_LOCATIONS+loc]==0){
			if(loc==LOC_TEMPLEOUTSIDE&&Game->GetCurScreen()!=0x20)
				return;
			LoreTracking[LT_LOCATIONS+loc] = 1;
			if(!G[G_NEWLORE]){
				PopupNotify(2); //New Area
			}
		}
	}
	for(int i=0; i<512; ++i){
		if(LoreTracking[LT_ENEMIESRANDO+i]==1)
			LoreTracking[LT_ENEMIESRANDO+i] = 0;
	}
}

void WeaponLoopFuckWeaponScripts(){
	for(int i = Screen->NumLWeapons(); i>0; i--){
		lweapon l = Screen->LoadLWeapon(i);
		if(l->ID == LW_FIRE)
			l->MoveFlags[WPNMV_CAN_PITFALL] = false;
	}
}

void OutfitSwap(){ //This probably isn't the function you're looking for. This is for niche catacombs cases, since it updates cutscene tiles too. Check the function below for the more generalized one. 
	if(G[G_CLOTHESSWAP] == 1){
		CopyTileBlock(105040, 105114, 104000); //Cutscene sprites
		CopyTileBlock(105120, 105192, 104120); //Player sprites
	}
	else{
		CopyTileBlock(104880, 104954, 104000); //Cutscene sprites
		CopyTileBlock(104960, 105032, 104120); //Player sprites
	}
}

void Costumes_Update(){
	if(G[G_RANDOMIZERENABLED])
		return;
	int asherCostume = G[G_ASHERCOSTUME];
	int torrinCostume = G[G_TORRINCOSTUME];
	int kaylaniCostume = G[G_KAYLANICOSTUME];
	if(asherCostume==1){
		switch(Game->GetCurDMap()){
			case 36:
			case 37:
				break;
			case 13:
				if(Game->GetCurScreen()!=0x01){
					asherCostume = 0;
					torrinCostume = 0;
					kaylaniCostume = 0;
				}
				break;
			default:
				asherCostume = 0;
				torrinCostume = 0;
				kaylaniCostume = 0;
				break;
		}
	}
	
	int AsherBlockTil[] = {130000, 130040, 130080, 130088};
	int AsherDestTil[]  = {104120, 104260, 104523, 104603};
	int AsherBlockW[]   = {13,     13,     8,      3};
	int AsherBlockH[]   = {2,      2,      2,      2};
	int TorrinBlockTil[] = {130260, 130300};
	int TorrinDestTil[]  = {104160, 104300};
	int TorrinBlockW[]   = {13,     13};
	int TorrinBlockH[]   = {2,      2};
	int KaylaniBlockTil[] = {130520, 130560, 130600};
	int KaylaniDestTil[]  = {104200, 104340, 104520};
	int KaylaniBlockW[]   = {13,     13,     3};
	int KaylaniBlockH[]   = {2,      2,      8};
	
	//Screen->DrawTile(6, 0, 0, 104260, 16, 11, 0, -1, -1, 0, 0, 0, 0, false, 64);
	// G[G_ASHERCOSTUME] = 0;
	// G[G_TORRINCOSTUME] = 0;
	// G[G_KAYLANICOSTUME] = 0;
	switch(asherCostume){
		case 1:
			AsherBlockTil[0] = 130780;
			AsherBlockTil[1] = 130820;
			AsherBlockTil[2] = 130840;
			AsherBlockTil[3] = 130848;
			break;
	}
	switch(torrinCostume){
		case 1:
			TorrinBlockTil[0] = 131040;
			TorrinBlockTil[1] = 131080;
			break;
	}
	switch(kaylaniCostume){
		case 1:
			KaylaniBlockTil[0] = 131300;
			KaylaniBlockTil[1] = 131340;
			KaylaniBlockTil[2] = 131360;
			break;
	}
	
	for(int i=0; i<4; ++i){
		CopyTileBlock(AsherBlockTil[i], AsherBlockTil[i]+(AsherBlockW[i]-1)+(AsherBlockH[i]-1)*20, AsherDestTil[i]);
	}
	for(int i=0; i<2; ++i){
		CopyTileBlock(TorrinBlockTil[i], TorrinBlockTil[i]+(TorrinBlockW[i]-1)+(TorrinBlockH[i]-1)*20, TorrinDestTil[i]);
	}
	for(int i=0; i<3; ++i){
		CopyTileBlock(KaylaniBlockTil[i], KaylaniBlockTil[i]+(KaylaniBlockW[i]-1)+(KaylaniBlockH[i]-1)*20, KaylaniDestTil[i]);
	}
	
	//Russ merge from previous function cuz too lazy to edit it into this framework in case something breaks
	if(G[G_CLOTHESSWAP] == 1){
		CopyTileBlock(105040, 105114, 104000); //Cutscene sprites
		CopyTileBlock(105120, 105192, 104120); //Player sprites
	}
}

enum {
	_DRI_X,
	_DRI_Y,
	_DRI_TYPE,
	_DRI_RAD,
	_DRI_ANGLE,
	_DRI_W,
	_DRI_FLICKERSIZE,
	_DRI_FLICKERSPEED,
	_DRI_LAST
};

int DarkRoom[_DRI_LAST*128];

void DarkRoom_Init(){
	G[G_DARKROOM_NUMLIGHTS] = 0;
	G[G_DARKROOM_NUMOLDLIGHTS] = 0;
	G[G_DARKROOM_SCROLLSTATE] = 0;
}

void DarkRoom_AddLight(int x, int y, int type, int rad, int w, int angle, int flickerSize, int flickerSpeed){
	if(G[G_DARKROOM_SCROLLSTATE])
		return;
	if(G[G_DARKROOM_NUMLIGHTS]>=64){
		printf("ERROR: Dark room doesn't have enough space for lights\n");
		return;
	}
	
	if(flickerSize==0)
		flickerSize = 0.2;
	if(flickerSpeed==0)
		flickerSpeed = 4;
	
	DarkRoom[_DRI_LAST*G[G_DARKROOM_NUMLIGHTS]+_DRI_X] = x;
	DarkRoom[_DRI_LAST*G[G_DARKROOM_NUMLIGHTS]+_DRI_Y] = y;
	DarkRoom[_DRI_LAST*G[G_DARKROOM_NUMLIGHTS]+_DRI_TYPE] = type;
	DarkRoom[_DRI_LAST*G[G_DARKROOM_NUMLIGHTS]+_DRI_RAD] = rad;
	DarkRoom[_DRI_LAST*G[G_DARKROOM_NUMLIGHTS]+_DRI_ANGLE] = angle;
	DarkRoom[_DRI_LAST*G[G_DARKROOM_NUMLIGHTS]+_DRI_W] = w;
	DarkRoom[_DRI_LAST*G[G_DARKROOM_NUMLIGHTS]+_DRI_FLICKERSIZE] = flickerSize;
	DarkRoom[_DRI_LAST*G[G_DARKROOM_NUMLIGHTS]+_DRI_FLICKERSPEED] = flickerSpeed;
	++G[G_DARKROOM_NUMLIGHTS];
}

const int CT_LANTERNCOMBO = 169;

void DarkRoom_Update(){
	bool isDarkRoom = ScreenFlag(SF_MISC, SFM_DARKROOM);
	if(!G[G_NOOUTFITEFFECTS]&&EquippedAccessoryAnySlot(GetCharID(), ACCESSORY_BLINDFOLD)&&!G[G_OUTFITMENUOPEN])
		isDarkRoom = true;
	// Screen->DrawInteger(7, 0, G[G_DARKROOM_SCROLLFRAMES]*8, FONT_Z3SMALL, 0x01, 0x0F, -1, -1, G[G_DARKROOM_SCROLLFRAMES], 0, 128);
	// Screen->DrawInteger(7, 32, G[G_DARKROOM_SCROLLSTATE], FONT_Z3SMALL, 0x01, 0x0F, -1, -1, G[G_DARKROOM_SCROLLSTATE], 0, 128);
	// Screen->DrawInteger(7, 64, G[G_DARKROOM_SCROLLSTATE], FONT_Z3SMALL, 0x01, 0x0F, -1, -1, G[G_DARKROOM_NUMLIGHTS], 0, 128);
	if(Link->Action==LA_SCROLLING){
		if(isDarkRoom){
			if(G[G_DARKROOM_ENTERING]==0||G[G_DARKROOM_ENTERING]==-1){ //Out of dark room
				G[G_DARKROOM_ENTERING] = 1; //Entering dark room
			}
		}
		else{
			if(G[G_DARKROOM_ENTERING]==2||G[G_DARKROOM_ENTERING]==1){ //In dark room
				G[G_DARKROOM_ENTERING] = -1; //Exiting dark room
			}
		}
	}
	else{
		if(isDarkRoom){
			G[G_DARKROOM_ENTERING] = 2; //In dark room
		}
		else{
			G[G_DARKROOM_ENTERING] = 0; //Out of dark room
		}
	}
	int flicker = (1+0.1+0.1*Sin(G[G_ANIM]*4));
	int innerRing = 0.9;
	int maxScrollFrames = 18;
	switch(Game->Scrolling[SCROLL_DIR]){
		case DIR_UP:
		case DIR_DOWN:
			maxScrollFrames = 17;
			break;
	}
	int opacity = 0;
	switch(G[G_DARKROOM_ENTERING]){
		case -1:
			opacity = 3;
			if(G[G_DARKROOM_SCROLLFRAMES]>maxScrollFrames-4)
				opacity = 1;
			else if(G[G_DARKROOM_SCROLLFRAMES]>maxScrollFrames-8)
				opacity = 2;
			break;
		case 1:
			opacity = 3;
			if(G[G_DARKROOM_SCROLLFRAMES]<4)
				opacity = 1;
			else if(G[G_DARKROOM_SCROLLFRAMES]<8)
				opacity = 2;
			break;
		case 2:
			opacity = 3;
			break;
	}
	if(G[G_DARKROOM_SCROLLSTATE])
		++G[G_DARKROOM_SCROLLFRAMES];
	else{
		if(isDarkRoom){
			opacity = 3;
		}
		else{
			opacity = 0;
		}
	}
	
	int linkRad = Link->Item[177]?128:(Link->Item[155]?48:8)*flicker;
	
	mapdata l0 = Game->LoadTempScreen(0);
	mapdata l1 = Game->LoadTempScreen(1);
	mapdata sl0 = Game->LoadScrollingScreen(0);
	mapdata sl1 = Game->LoadScrollingScreen(1);
	if(opacity){
		GBMP[BMP_DARKROOM]->ClearToColor(0, 0x0F);
		GBMP[BMP_DARKROOM2]->ClearToColor(0, 0x0F);
		if(G[G_DARKROOM_SCROLLSTATE]==1){
			int orX = 0;
			int orY = 0;
			int nrX = 0;
			int nrY = 0;
			switch(Game->Scrolling[SCROLL_DIR]){
				case DIR_UP:
					orY = 176;
					break;
				case DIR_DOWN:
					nrY = 176;
					break;
				case DIR_LEFT:
					orX = 256;
					break;
				case DIR_RIGHT:
					nrX = 256;
					break;
					
			}
			
			GBMP[BMP_DARKROOM]->Circle(0, Link->X+8+nrX, Link->Y+8+nrY, linkRad, 0x00, 1, 0, 0, 0, true, 128);
			GBMP[BMP_DARKROOM2]->Circle(0, Link->X+8+nrX, Link->Y+8+nrY, linkRad*innerRing, 0x00, 1, 0, 0, 0, true, 128);
			if(!G[G_NOOUTFITEFFECTS]&&EquippedAccessoryAnySlot(GetCharID(), ACCESSORY_HALO)){
				GBMP[BMP_DARKROOM]->Circle(0, Link->X+8+nrX, Link->Y-4+nrY, 24*flicker, 0x00, 1, 0, 0, 0, true, 128);
				GBMP[BMP_DARKROOM2]->Circle(0, Link->X+8+nrX, Link->Y-4+nrY, 24*innerRing*flicker, 0x00, 1, 0, 0, 0, true, 128);
			}
			for(int i=0; i<176; ++i){
				int rad;
				combodata cd;
				rad = 0;
				if(l0->ComboT[i]==CT_LANTERNCOMBO){
					cd = Game->LoadComboData(l0->ComboD[i]);
					rad = cd->Attribytes[0];
				}
				if(l1->ComboT[i]==CT_LANTERNCOMBO){
					cd = Game->LoadComboData(l1->ComboD[i]);
					rad = cd->Attribytes[0];
				}
				if(rad){
					GBMP[BMP_DARKROOM]->Circle(0, ComboX(i)+8+nrX, ComboY(i)+8+nrY, rad*flicker, 0x00, 1, 0, 0, 0, true, 128);
					GBMP[BMP_DARKROOM2]->Circle(0, ComboX(i)+8+nrX, ComboY(i)+8+nrY, rad*flicker*innerRing, 0x00, 1, 0, 0, 0, true, 128);
				}
				//Near the end of scrolling, SCROLL_DIR becomes -1 and the draws for both screens overlap and use the same screen. This should hopefully fix that issue
				if(Game->Scrolling[SCROLL_DIR]>-1){
					rad = 0;
					if(sl0->ComboT[i]==CT_LANTERNCOMBO){
						cd = Game->LoadComboData(sl0->ComboD[i]);
						rad = cd->Attribytes[0];
					}
					if(sl1->ComboT[i]==CT_LANTERNCOMBO){
						cd = Game->LoadComboData(sl1->ComboD[i]);
						rad = cd->Attribytes[0];
					}
					if(rad){
						GBMP[BMP_DARKROOM]->Circle(0, ComboX(i)+8+orX, ComboY(i)+8+orY, rad*flicker, 0x00, 1, 0, 0, 0, true, 128);
						GBMP[BMP_DARKROOM2]->Circle(0, ComboX(i)+8+orX, ComboY(i)+8+orY, rad*flicker*innerRing, 0x00, 1, 0, 0, 0, true, 128);
					}
				}
			}
			switch(opacity){
				case 1:
					if(Game->Scrolling[SCROLL_DIR]>-1)
						GBMP[BMP_DARKROOM]->Blit(6, RT_SCREEN, orX, orY, 256, 176, Game->Scrolling[SCROLL_OX], Game->Scrolling[SCROLL_OY], 256, 176, 0, 0, 0, BITDX_TRANS , 0, true);
					GBMP[BMP_DARKROOM]->Blit(6, RT_SCREEN, nrX, nrY, 256, 176, Game->Scrolling[SCROLL_NX], Game->Scrolling[SCROLL_NY], 256, 176, 0, 0, 0, BITDX_TRANS , 0, true);
					break;
				case 2:
					if(Game->Scrolling[SCROLL_DIR]>-1)
						GBMP[BMP_DARKROOM2]->Blit(6, RT_SCREEN, orX, orY, 256, 176, Game->Scrolling[SCROLL_OX], Game->Scrolling[SCROLL_OY], 256, 176, 0, 0, 0, BITDX_TRANS , 0, true);
					GBMP[BMP_DARKROOM2]->Blit(6, RT_SCREEN, nrX, nrY, 256, 176, Game->Scrolling[SCROLL_NX], Game->Scrolling[SCROLL_NY], 256, 176, 0, 0, 0, BITDX_TRANS , 0, true);
					if(Game->Scrolling[SCROLL_DIR]>-1)
						GBMP[BMP_DARKROOM]->Blit(6, RT_SCREEN, orX, orY, 256, 176, Game->Scrolling[SCROLL_OX], Game->Scrolling[SCROLL_OY], 256, 176, 0, 0, 0, BITDX_TRANS , 0, true);
					GBMP[BMP_DARKROOM]->Blit(6, RT_SCREEN, nrX, nrY, 256, 176, Game->Scrolling[SCROLL_NX], Game->Scrolling[SCROLL_NY], 256, 176, 0, 0, 0, BITDX_TRANS , 0, true);
					break;
				case 3:
					if(Game->Scrolling[SCROLL_DIR]>-1)
						GBMP[BMP_DARKROOM2]->Blit(6, RT_SCREEN, orX, orY, 256, 176, Game->Scrolling[SCROLL_OX], Game->Scrolling[SCROLL_OY], 256, 176, 0, 0, 0, BITDX_TRANS, 0, true);
					GBMP[BMP_DARKROOM2]->Blit(6, RT_SCREEN, nrX, nrY, 256, 176, Game->Scrolling[SCROLL_NX], Game->Scrolling[SCROLL_NY], 256, 176, 0, 0, 0, BITDX_TRANS, 0, true);
					if(Game->Scrolling[SCROLL_DIR]>-1)
						GBMP[BMP_DARKROOM]->Blit(6, RT_SCREEN, orX, orY, 256, 176, Game->Scrolling[SCROLL_OX], Game->Scrolling[SCROLL_OY], 256, 176, 0, 0, 0, 0, 0, true);
					GBMP[BMP_DARKROOM]->Blit(6, RT_SCREEN, nrX, nrY, 256, 176, Game->Scrolling[SCROLL_NX], Game->Scrolling[SCROLL_NY], 256, 176, 0, 0, 0, 0, 0, true);
					break;
			}
			G[G_DARKROOM_NUMLIGHTS] = 0;
		}
		else{
			GBMP[BMP_DARKROOM2]->Circle(0, Link->X+8, Link->Y+8, linkRad*innerRing, 0x00, 1, 0, 0, 0, true, 128);
			GBMP[BMP_DARKROOM]->Circle(0, Link->X+8, Link->Y+8, linkRad, 0x00, 1, 0, 0, 0, true, 128);
			if(!G[G_NOOUTFITEFFECTS]&&EquippedAccessoryAnySlot(GetCharID(), ACCESSORY_HALO)){
				GBMP[BMP_DARKROOM]->Circle(0, Link->X+8, Link->Y-4, 24*flicker, 0x00, 1, 0, 0, 0, true, 128);
				GBMP[BMP_DARKROOM2]->Circle(0, Link->X+8, Link->Y-4, 24*innerRing*flicker, 0x00, 1, 0, 0, 0, true, 128);
			}
			for(int i=0; i<G[G_DARKROOM_NUMLIGHTS]; ++i){
				int x = DarkRoom[_DRI_LAST*i+_DRI_X];
				int y = DarkRoom[_DRI_LAST*i+_DRI_Y];
				int angle = DarkRoom[_DRI_LAST*i+_DRI_ANGLE];
				int w = DarkRoom[_DRI_LAST*i+_DRI_W];
				int flickerSize = DarkRoom[_DRI_LAST*i+_DRI_FLICKERSIZE];
				int flickerSpeed = DarkRoom[_DRI_LAST*i+_DRI_FLICKERSPEED];
				int flickerTmp = (1+flickerSize/2+flickerSize*Sin(G[G_ANIM]*flickerSpeed));
				int rad = DarkRoom[_DRI_LAST*i+_DRI_RAD]*flickerTmp;
				switch(DarkRoom[_DRI_LAST*i+_DRI_TYPE]){
					case 0:
						GBMP[BMP_DARKROOM]->Circle(0, x, y, rad, 0x00, 1, 0, 0, 0, true, 128);
						GBMP[BMP_DARKROOM2]->Circle(0, x, y, rad*innerRing, 0x00, 1, 0, 0, 0, true, 128);
						break;
					case 1:
						DarkRoom_DrawLightCone(GBMP[BMP_DARKROOM], x, y, rad, w, angle);
						DarkRoom_DrawLightCone(GBMP[BMP_DARKROOM2], x, y, rad*innerRing, w, angle);
						break;
				}
			}
			GBMP[BMP_DARKROOM2]->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_TRANS, 0, true);
			GBMP[BMP_DARKROOM]->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
			G[G_DARKROOM_NUMLIGHTS] = 0;
		}
	}
	else
		G[G_DARKROOM_NUMLIGHTS] = 0;
	
	if(Game->Scrolling[SCROLL_DIR]>-1){
		if(G[G_DARKROOM_SCROLLSTATE]==0){
			G[G_DARKROOM_SCROLLSTATE] = 1;
			G[G_DARKROOM_SCROLLFRAMES] = 0;
		}
	}
	else{
		if(G[G_DARKROOM_SCROLLSTATE]){
			G[G_DARKROOM_SCROLLSTATE] = 0;
			G[G_DARKROOM_ENTERING] = 0;
			G[G_DARKROOM_SCROLLFRAMES] = 0;
		}
	}
}

void DarkRoom_DrawLightCone(bitmap b, int sx, int sy, int rad, int w, int angle){
	int vert[22] = {sx, sy};
	
	int offX = -rad*0.1;
	vert[2] = sx+Ceiling((8.0/66.0)*rad);
	vert[3] = sy-Ceiling((17.0/66.0)*rad)*w;
	//
	vert[4] = vert[2]+Ceiling((31.0/66.0)*rad);
	vert[5] = vert[3]-Ceiling((16.0/66.0)*rad)*w;
	//
	vert[6] = vert[4]+Ceiling((4.0/66.0)*rad);
	vert[7] = vert[5];
	//
	vert[8] = vert[6]+Ceiling((15.0/66.0)*rad);
	vert[9] = vert[7]+Ceiling((8.0/66.0)*rad)*w;
	//
	vert[10] = vert[8]+Ceiling((8.0/66.0)*rad);
	vert[11] = vert[9]+Ceiling((15.0/66.0)*rad)*w;
	//
	vert[12] = vert[10];
	vert[13] = vert[11]+Ceiling((19.0/66.0)*rad)*w;
	//
	vert[14] = vert[12]-Ceiling((8.0/66.0)*rad);
	vert[15] = vert[13]+Ceiling((15.0/66.0)*rad)*w;
	//
	vert[16] = vert[14]-Ceiling((15.0/66.0)*rad);
	vert[17] = vert[15]+Ceiling((8.0/66.0)*rad)*w;
	//
	vert[18] = vert[16]-Ceiling((4.0/66.0)*rad);
	vert[19] = vert[17];
	//
	vert[20] = sx+Ceiling((8.0/66.0)*rad);
	vert[21] = sy+Ceiling((17.0/66.0)*rad)*w;
	
	for(int i=0; i<11; ++i){
		int x = RotatePointX(vert[2*i+0]+offX, vert[2*i+1], sx, sy, angle); 
		int y = RotatePointY(vert[2*i+0]+offX, vert[2*i+1], sx, sy, angle); 
		vert[2*i+0] = x;
		vert[2*i+1] = y;
	}
	
	// int vert2[24];
	// for(int i=0; i<8; ++i){
		// vert2[2*i+0] = sx+VectorX(24, i*45);
		// vert2[2*i+1] = sy+VectorY(24, i*45);
	// }
	// b->Polygon(0, 12, vert2, 0x00, 128);
	b->Polygon(0, 11, vert, 0x00, 128);
}

int Nightmarchers_ActiveDMap(){
	switch(G[G_NIGHTMARCHEREVENT_DMAP]){
		case 0: //Omaka
			return 0;
		case 1: //Wahiokala Jungle
			return 10;
		case 2: //Wahiokala Lava Flows
			return 12;
		case 3: //Kawi
			return 6;
		case 4: //Kikala Hill
			return 27;
	}
}

const int NPC_NIGHTMARCHER = 227;

void Nightmarchers_Spawn(int enemyID){
	bool horizontal;
	int chance = Floor(Abs(VectorX(100, G[G_FOGANGLE])));
	if(Rand(100)<chance){
		horizontal = true;
	}
	int x; int y;
	int vX = -VectorX(1, G[G_FOGANGLE]);
	int vY = -VectorY(1, G[G_FOGANGLE]);
	if(horizontal){
		if(vX<0){
			x = -32;
			y = Rand(160);
		}
		else{
			x = 272;
			y = Rand(160);
		}
	}
	else{
		if(vY<0){
			x = Rand(240);
			y = -32;
		}
		else{
			x = Rand(240);
			y = 192;
		}
	}
	npc n = CreateNPCAt(enemyID, x, y);
}

void Nightmarchers_Update(){
	int time = DayNight[_DN_HOUR]*60+DayNight[_DN_MINUTE];
	G[G_NIGHTMARCHEREVENT_INEVENT] = 0;
	if(time!=G[G_NIGHTMARCHEREVENT_CHECKTIME]){
		if(time==19*60+0){
			Nightmarchers_AdvanceDay();
		}
		else if(time==2*60+0){
			G[G_FOGSPREADSTATE] = 1;
		}
		else if(time==2*60+10){
			G[G_NIGHTMARCHEREVENT_DMAP] = -1;
		}
	}
	G[G_NIGHTMARCHEREVENT_CHECKTIME] = DayNight[_DN_HOUR]*60+DayNight[_DN_MINUTE];
	
	if(G[G_NIGHTMARCHEREVENT_DAYCOUNT]<3)
		G[G_NIGHTMARCHEREVENT_DMAP] = -1;
	else{
		if(Game->GetCurDMap()==Nightmarchers_ActiveDMap()){
			if(DayNight_IsBetween(19, 0, 0, 2, 0, 0)){
				G[G_NIGHTMARCHEREVENT_INEVENT] = 1;
				if(Link->Action!=LA_SCROLLING){
					int count = Rand(3, 5);
					for(int i=0; i<10; ++i){
						if(i<count)
							Screen->Enemy[i] = NPC_NIGHTMARCHER;
						else
							Screen->Enemy[i] = 0;
					}
				}
				if(G[G_TIMEFROZEN]  == 0){
					if(G[G_NIGHTMARCHEREVENT_SPAWNFRAMES])
						--G[G_NIGHTMARCHEREVENT_SPAWNFRAMES];
					else if(Screen->NumNPCs()<20&&Link->Action!=LA_SCROLLING){
						G[G_NIGHTMARCHEREVENT_SPAWNFRAMES] = 90;
						Nightmarchers_Spawn(NPC_NIGHTMARCHER);
					}
				}
				G[G_FOGACTIVE] = 1;
			}
		}
	}
}

void Nightmarchers_AdvanceDay(){
	++G[G_NIGHTMARCHEREVENT_DAYCOUNT];
	if(G[G_NIGHTMARCHEREVENT_DAYCOUNT]==4){
		G[G_NIGHTMARCHEREVENT_DAYCOUNT] = 0;
		G[G_NIGHTMARCHEREVENT_DMAP] = -1;
	}
	++G[G_NIGHTMARCHEREVENT_DAYCOUNT2];
	if(G[G_NIGHTMARCHEREVENT_DAYCOUNT2]==20){
		G[G_NIGHTMARCHEREVENT_DAYCOUNT2] = 0;
		G[G_NIGHTMARCHEREVENT_DMAP] = -1;
	}
	else if(G[G_NIGHTMARCHEREVENT_DAYCOUNT]==3){
		G[G_NIGHTMARCHEREVENT_DMAP] = Floor(G[G_NIGHTMARCHEREVENT_DAYCOUNT2]/4);
		G[G_FOGANGLE] = Rand(360);
		if(Game->GetCurDMap()==Nightmarchers_ActiveDMap()){
			// Game->PlayMIDI(0);
			G[G_FOGSPREAD] = 128;
			G[G_FOGSPREADSTATE] = -1;
		}
		else{
			G[G_FOGSPREAD] = 0;
			G[G_FOGSPREADSTATE] = 0;
		}
	}
	// printf("Day %d: DMap %d\n", G[G_NIGHTMARCHEREVENT_DAYCOUNT2], G[G_NIGHTMARCHEREVENT_DMAP]);
}

void UpdateStatus(){
	if(G[G_SCRIPTJINX]>0){
		Link->SwordJinx = 2;
		Link->ItemJinx = 2;
		NoItem();
		if(!G[G_SCRIPTJINXRUNNING]){
			if(Link->Action!=LA_SCROLLING){
				eweapon e = CreateEWeaponAt(EW_SCRIPT10, 120, 80);
				e->CollDetection = false;
				e->DrawYOffset = -1000;
				RunEWeaponScript(e, "ScriptJinxStatus", {0});
			}
		}
		--G[G_SCRIPTJINX];
	}
	G[G_SCRIPTJINXRUNNING] = 0;
}

void UpdatePotion(){
	if(G[G_POTIONACTIVE]>-1){
		switch(G[G_POTIONACTIVE]){
			case 0: //Revive
				if(G[G_POTIONTIMER]>0){
					if(G[G_POTIONTIMER]%48==0)
						Game->PlaySound(114);
				}
				else
					G[G_POTIONACTIVE] = -1;
				break;
			case 1: //Regen
				if(G[G_POTIONCHAR]!=GetCharID()){
					G[G_POTIONACTIVE] = -1;
				}
				else{
					if(G[G_POTIONTIMER]>0){
						if(Link->Action==LA_GOTHURTLAND||Link->Action==LA_GOTHURTWATER)
							G[G_POTIONACTIVE] = -1;
						if(G[G_POTIONTIMER]%120==0){
							Game->PlaySound(113);
						}
						if(G[G_POTIONTIMER]%120>=104){
							Link->HP = Min(Link->HP+1, Link->MaxHP);
							if(Link->HP==Link->MaxHP)
								G[G_POTIONACTIVE] = -1;
						}
					}
					else
						G[G_POTIONACTIVE] = -1;
				}
				break;
		}
		if(G[G_POTIONTIMER]){
			--G[G_POTIONTIMER];
		}
	}
}

const int TIL_FOG = 44460;

void FogGFX_Init(){
	int til = TIL_FOG;
	if(G[G_FOGSPTILE]) //Horrible hacks ahoy
		til = G[G_FOGSPTILE];
	GBMP[BMP_FOGLAYER]->Clear(0);
	GBMP[BMP_FOGLAYER]->DrawTile(0, 0, 0, til, 16, 16, 4, -1, -1, 0, 0, 0, 0, true, 128);
	GBMP[BMP_FOGLAYER]->DrawTile(0, 256, 0, til, 16, 16, 4, -1, -1, 0, 0, 0, 0, true, 128);
	GBMP[BMP_FOGLAYER]->DrawTile(0, 0, 256, til, 16, 16, 4, -1, -1, 0, 0, 0, 0, true, 128);
	GBMP[BMP_FOGLAYER]->DrawTile(0, 256, 256, til, 16, 16, 4, -1, -1, 0, 0, 0, 0, true, 128);
}

void FogGFX_Update(){
	int oldSPFog = G[G_FOGSPTILE];
	if(Game->GetCurDMap()==45||Game->GetCurDMap()==52||Game->GetCurDMap()==55||Game->GetCurDMap()==67){
		G[G_FOGACTIVE] = 1;
		G[G_FOGSPREADSTATE] = 0;
		G[G_FOGSPREAD] = 0;
		if(Game->GetCurDMap()==52){
			G[G_FOGANGLE] = Angle(4, 3, Game->GetCurScreen()%16, Floor(Game->GetCurScreen()/16));
			G[G_FOGSPTILE] = 44780;
		}
		else if(Game->GetCurDMap()==55){
			G[G_FOGANGLE] = -30;
			G[G_FOGSPTILE] = 44780;
		}
		else if(Game->GetCurDMap()==67){
			G[G_FOGANGLE] = 90;
			G[G_FOGSPTILE] = 44780;
		}
	}
	else{
		G[G_FOGSPTILE] = 0;
	}
	if(G[G_FOGSPTILE]!=oldSPFog){
		FogGFX_Init();
	}
	if(G[G_FOGACTIVE]){
		G[G_FOGX] -= VectorX(0.25, G[G_FOGANGLE]);
		G[G_FOGY] -= VectorY(0.25, G[G_FOGANGLE]);
		if(G[G_FOGX]<0)
			G[G_FOGX] += 256;
		else if(G[G_FOGX]>=256)
			G[G_FOGX] -= 256;
		if(G[G_FOGY]<0)
			G[G_FOGY] += 256;
		else if(G[G_FOGY]>=256)
			G[G_FOGY] -= 256;
		int x = Floor(G[G_FOGX]%256);
		int y = Floor(G[G_FOGY]%256);
		switch(G[G_FOGSPREADSTATE]){
			case -1:
				if(G[G_FOGSPREAD]>0)
					G[G_FOGSPREAD] = Clamp(G[G_FOGSPREAD]-1, 0, 128);
				else
					G[G_FOGSPREADSTATE] = 0;
				break;
			case 1:
				if(G[G_FOGSPREAD]<128)
					G[G_FOGSPREAD] = Clamp(G[G_FOGSPREAD]+1, 0, 128);
				else
					G[G_FOGSPREADSTATE] = 2;
				break;
		}
		if(G[G_FOGSPREADSTATE]!=2){
			if(G[G_FOGSPREAD]){
				GBMP[BMP_FOGLAYER]->Blit(0, <untyped>GBMP[BMP_FOGLAYER], x, y, 256, 176, 512, 0, 256, 176, 0, 0, 0, 0, 0, false);
				for(int i=0; i<176; ++i){
					int fogamp = Min(Lerp(((128-G[G_FOGSPREAD])/128), 0, 256), 80);
					int xOff = 512+128+fogamp*Sin(G[G_ANIM]*2+i*7);
					int w = G[G_FOGSPREAD]+(i%2==0?0:-16*(0.5+0.5*Sin(G[G_ANIM]+i*8)));
					int x1 = Clamp(xOff-w, 512, 767);
					int x2 = Clamp(xOff+w, 512, 767);
					if(w>0){
						GBMP[BMP_FOGLAYER]->Line(0, x1, i, x2, i, 0x00, 1, 0, 0, 0, 128);
					}
				}
				GBMP[BMP_FOGLAYER]->Blit(6, RT_SCREEN, 512, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_TRANS, 0, true);
			}
			else
				GBMP[BMP_FOGLAYER]->Blit(6, RT_SCREEN, x, y, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_TRANS, 0, true);
		}
	}
	G[G_FOGACTIVE] = 0;
}

//Used for defining minimap sectors on a large map
void Minimap_GetSectorDefinitions(){
	//MiniMap_DefineSector(int map, int sector, int dmap, int xoff, int yoff)
	//Safe ranges for 16x8 maps:
	//		X: -16, 16
	//		Y: -20, 20
	
	//Start Island
	MiniMap_DefineSector(0, 0, 0, 0, 0);
	MiniMap_DefineSector(0, 1, 1, 4, -8);
	MiniMap_DefineSector(0, 2, 2, 0, 6);
	
	//Wahiokala
	MiniMap_DefineSector(1, 0, 10, 0, 0);
	MiniMap_DefineSector(1, 1, 11, 0, 0);
	MiniMap_DefineSector(1, 2, 12, 0, 0);
	MiniMap_DefineSector(1, 3, 28, 8, 0);
	
	//Poni Canyon
	MiniMap_DefineSector(2, 0, 49, 0, 0);
	MiniMap_DefineSector(2, 1, 51, -8, -8);
	MiniMap_DefineSector(2, 2, 52, 0, -11);
	
}

const int MINIMAP_LAYER = 7; //Layer the minimap is drawn to
//X and Y position of the minimap on the subscreen
const int MINIMAP_X = 113;
const int MINIMAP_Y = 17;
const int MINIMAP_SQUARESIZE = 6; //Width/Height of a minimap square in pixels
//Width and height of the minimap in screens
const int MINIMAP_TILEWIDTH = 7;
const int MINIMAP_TILEHEIGHT = 5;

const int MINIMAP_MAPWIDTH = 16; //Max width of a map 

const int MINIMAP_MAPS = 31; //First of 4 maps used for minimaps
const int MINIMAP_MARKERMAPS = 32; //First of 4 maps used for minimap markers

const int MINIMAP_USELEVELNUM = 0; //Set to 1 to use level numbers instead of DMaps for getting reference maps
const int MINIMAP_CLAMPPOSITION = 0; //Set to 1 to clamp the position of the minimap to the play area, if 0, Link's position will always be centered
const int MINIMAP_MARKERSREQUIREVISITED = 1; //Set to 1 to make it so markers require you have visited the screen to display
const int MINIMAP_REQUIREDUNGEONMAP = 1; //Set to 1 to require the dungeon map to view unexplored (not hidden) rooms
const int MINIMAP_REQUIRECOMPASS = 1; //Set to 1 to require the compass to view map markers

const int MINIMAP_LARGEMAP_ENABLED = 1; //Set to 1 to enable opening the large map with the "Map" button
const int MINIMAP_LARGEMAP_OPENCLOSEFRAMES = 32; //Frames taken to open the large map
const int MINIMAP_LARGEMAP_FRAMEDRAWCAP = 500; //Rough maximum of draw instructions to run per frame when loading the large map
const int MINIMAP_LARGEMAP_DEBUG = 0; //Set to 1 to show all hidden squares on the large map

const int C_MINIMAP_OUTLINE = 0xB5; //Outline color for the minimap
const int C_MINIMAP_BG = 0x0F; //Background color for the minimap
const int C_MINIMAP_DEBUG = 0x02; //Color used for debug draws

const int CF_HIDDENROOM = 98; //Combo flag marking minimap screens as hidden

const int DMF_ENABLEMINIMAP = DMF_SCRIPT5; //DMap flag used for minimaps (1-5, Script 1 by default)

//Two off-screen bitmaps (0-6) to use for drawing the large map
//const int RT_LARGEMAP1 = 0;
//const int RT_LARGEMAP2 = 1;

// const int FFC_SCREENFREEZEA = 31;
// const int CMB_SCREENFREEZEA = 2;
// const int FFC_SCREENFREEZEB = 32;
// const int CMB_SCREENFREEZEB = 3;

//Functions for freezing/unfreezing the screen
void FreezeScreen(){
	for(int i=0; i<susptLAST; ++i){
		switch(i){
			case susptCONTROLSTATE:
			case susptGLOBALGAME:
			case susptSCRIPDRAWCLEAR:
			case susptSCREENDRAW:
			case susptCOMBOANIM:
				break;
			default:
				Game->Suspend[i] = true;
		}
	}
	// ffc a = Screen->LoadFFC(FFC_SCREENFREEZEA);
	// a->Data = CMB_SCREENFREEZEA;
	// ffc b = Screen->LoadFFC(FFC_SCREENFREEZEB);
	// b->Data = CMB_SCREENFREEZEB;
}
void UnfreezeScreen(){
	for(int i=0; i<susptLAST; ++i){
		switch(i){
			case susptCONTROLSTATE:
			case susptGLOBALGAME:
			case susptSCRIPDRAWCLEAR:
			case susptSCREENDRAW:
			case susptCOMBOANIM:
				break;
			default:
				Game->Suspend[i] = false;
		}
	}
	// ffc a = Screen->LoadFFC(FFC_SCREENFREEZEA);
	// a->Data = 0;
	// ffc b = Screen->LoadFFC(FFC_SCREENFREEZEB);
	// b->Data = 0;
}

const int _LML_BGCMB = 0;
const int _LML_BGCS = 2304;
const int _LML_LAYOUTCMB = 4608;
const int _LML_LAYOUTCS = 6912;
const int _LML_MARKERCMB = 9216;
const int _LML_MARKERCS = 11520;

int LargeMapLayout[13824]; //Size should be 48*48*6

//Indices for global variables
const int _LMD_CURDRAWINDEX = 0;
const int _LMD_DRAWCOUNT = 1;
const int _LMD_MINX = 2;
const int _LMD_MAXX = 3;
const int _LMD_MINY = 4;
const int _LMD_MAXY = 5;
const int _LMD_LINKPOS = 6;
const int _LMD_LARGEMAPSTATE = 7;
const int _LMD_LARGEMAPFRAMES = 8;
const int _LMD_MAPVIEWX = 9;
const int _LMD_MAPVIEWY = 10;
const int _LMD_MAPDEFS = 16;

//Indices for map sectors (3-dimensional, map x sector x index)
const int _LMD_DMAP = 0;
const int _LMD_XOFF = 1;
const int _LMD_YOFF = 2;
const int _LMD_SECTORSIZE = 3;
//
const int _LMD_MAXMAPS = 4; //Max number of large maps
const int _LMD_MAXMAPSECTORS = 32; //Max number of sectors for maps

int LargeMapData[65536]; //Size should be at least _LMD_MAPDEFS+_LMD_MAXMAPS*_LMD_MAXMAPSECTORS*_LMD_SECTORSIZE
int LevelHymnstonesFound[1024]; 

void MiniMap_Init(){
	LargeMapData[_LMD_LARGEMAPSTATE] = 0;
	for(int i=0; i<_LMD_MAXMAPS*_LMD_MAXMAPSECTORS; ++i){
		LargeMapData[_LMD_MAPDEFS+_LMD_SECTORSIZE*i+_LMD_DMAP] = -1;
	}
	Minimap_GetSectorDefinitions();
}

//Defines a single sector in the large map
void MiniMap_DefineSector(int map, int sector, int dmap, int xoff, int yoff){
	LargeMapData[_LMD_MAPDEFS+_LMD_MAXMAPSECTORS*_LMD_SECTORSIZE*map+_LMD_SECTORSIZE*sector+_LMD_DMAP] = dmap;
	LargeMapData[_LMD_MAPDEFS+_LMD_MAXMAPSECTORS*_LMD_SECTORSIZE*map+_LMD_SECTORSIZE*sector+_LMD_XOFF] = 16+xoff;
	LargeMapData[_LMD_MAPDEFS+_LMD_MAXMAPSECTORS*_LMD_SECTORSIZE*map+_LMD_SECTORSIZE*sector+_LMD_YOFF] = 20+yoff;
}

void Minimap_Update(){
	//Link->InputMap = false; Link->PressMap = false; //Commented out because of the active subscreen script

	//Minimap_UpdateMapSubscreen();
	
	int refMap; int refMarkerMap; int refScrn;
	//Get the maps to reference for map drawing
	if(MINIMAP_USELEVELNUM){
		refMap = MINIMAP_MAPS+Floor(Game->GetCurLevel()/128);
		refMarkerMap = MINIMAP_MARKERMAPS+Floor(Game->GetCurLevel()/128);
		refScrn = Game->GetCurLevel()%128;
	}
	else{
		refMap = MINIMAP_MAPS+Floor(Game->GetCurDMap()/128);
		refMarkerMap = MINIMAP_MARKERMAPS+Floor(Game->GetCurDMap()/128);
		refScrn = Game->GetCurDMap()%128;
	}
	
	int dmapOffset = Game->DMapOffset[Game->GetCurDMap()];
	
	//Get the map X and Y position of the top-left corner of the minimap
	int offX = (Game->GetCurDMapScreen()%16)-Floor((MINIMAP_TILEWIDTH-1)/2);
	int offY = Floor(Game->GetCurDMapScreen()/16)-Floor((MINIMAP_TILEHEIGHT-1)/2);
	if(MINIMAP_CLAMPPOSITION){
		offX = Clamp(offX, 0, MINIMAP_MAPWIDTH-MINIMAP_TILEWIDTH);
		offY = Clamp(offY, 0, 8-MINIMAP_TILEHEIGHT);
	}
	
	int bgCD = Game->GetComboData(refMap, refScrn, 160);
	
	int roomX; int roomY; int roomPos; 
	int roomVisited; int markerState;
	int roomCD; int roomCS; int roomCF;
	int markerCD; int markerCS; int markerCT;
	
	//Draw the rectangle background
	if(C_MINIMAP_BG)
		Screen->Rectangle(MINIMAP_LAYER, MINIMAP_X, MINIMAP_Y-56, MINIMAP_X+MINIMAP_SQUARESIZE*MINIMAP_TILEWIDTH, MINIMAP_Y-56+MINIMAP_SQUARESIZE*MINIMAP_TILEHEIGHT, C_MINIMAP_BG, 1, 0, 0, 0, true, 128);
	
	//Draw the rectangle outline
	if(C_MINIMAP_OUTLINE)
		Screen->Rectangle(MINIMAP_LAYER, MINIMAP_X, MINIMAP_Y-56, MINIMAP_X+MINIMAP_SQUARESIZE*MINIMAP_TILEWIDTH, MINIMAP_Y-56+MINIMAP_SQUARESIZE*MINIMAP_TILEHEIGHT, C_MINIMAP_OUTLINE, 1, 0, 0, 0, false, 128);
		
	int floorFlag;
	mapdata room;
	mapdata marker = Game->LoadMapData(refMarkerMap, refScrn);
	roomPos = Game->GetCurDMapScreen();
	floorFlag = marker->ComboF[roomPos];
	
	if(Game->DMapFlags[Game->GetCurDMap()]&DMF_ENABLEMINIMAP&&!G[G_MAPDISABLED]){
		//Cycle through all minimap squares to draw
		for(int x=0; x<MINIMAP_TILEWIDTH; ++x){
			for(int y=0; y<MINIMAP_TILEHEIGHT; ++y){
				roomX = offX+x;
				roomY = offY+y;
				roomPos = roomX+roomY*16;
				room = Game->LoadMapData(refMap, refScrn);
				marker = Game->LoadMapData(refMarkerMap, refScrn);
				if(roomX>=0&&roomX<=MINIMAP_MAPWIDTH-1&&roomY>=0&&roomY<=7&&marker->ComboF[roomPos]==floorFlag){
					roomCD = room->ComboD[roomPos]; //Game->GetComboData(refMap, refScrn, roomPos);
					roomCS = room->ComboC[roomPos]; //Game->GetComboCSet(refMap, refScrn, roomPos);
					roomCF = room->ComboF[roomPos]; //Game->GetComboFlag(refMap, refScrn, roomPos);
					markerCD = marker->ComboD[roomPos]; //Game->GetComboData(refMarkerMap, refScrn, roomPos);
					markerCS = marker->ComboC[roomPos]; //Game->GetComboCSet(refMarkerMap, refScrn, roomPos);
					markerCT = marker->ComboT[roomPos]; //Game->GetComboType(refMarkerMap, refScrn, roomPos);
					roomVisited = 0;
					markerState = 0;
					
					//Check if Link has visited or is in this screen
					if(roomPos==Game->GetCurDMapScreen())
						roomVisited = 2;
					else if(roomPos+dmapOffset<0x80&&Game->GetScreenState(Game->GetCurMap(), roomPos+dmapOffset, ST_VISITED))
						roomVisited = 1;
					//Hidden rooms are marked with a flag so they're visible in the editor but not in normal play until visited
					if(roomCF==CF_HIDDENROOM&&roomVisited==0)
						roomCD = 0;
					//Prevent showing unvisited rooms without the map
					if(!(Game->LItems[Game->GetCurLevel()]&LI_MAP)&&MINIMAP_REQUIREDUNGEONMAP&&roomVisited==0)
						roomCD = 0;
					//If the combo at that position >0, this is a valid screen to draw
					if(roomCD){
						//If the background combo was set, draw that under the screen first
						if(bgCD){
							Screen->FastCombo(MINIMAP_LAYER, MINIMAP_X+x*MINIMAP_SQUARESIZE, MINIMAP_Y-56+y*MINIMAP_SQUARESIZE, bgCD-1+roomVisited, roomCS, 128);
							Screen->FastCombo(MINIMAP_LAYER, MINIMAP_X+x*MINIMAP_SQUARESIZE, MINIMAP_Y-56+y*MINIMAP_SQUARESIZE, roomCD, roomCS, 128);
						}
						else
							Screen->FastCombo(MINIMAP_LAYER, MINIMAP_X+x*MINIMAP_SQUARESIZE, MINIMAP_Y-56+y*MINIMAP_SQUARESIZE, roomCD+roomVisited, roomCS, 128);
						bool noDrawMarker;
						//Check for markers on the layer screen
						if(markerCD&&(roomVisited||!MINIMAP_MARKERSREQUIREVISITED)&&roomPos+dmapOffset<0x80){
							//Item or Special Item
							if(markerCT==CT_CHEST){
								if(Game->GetScreenState(Game->GetCurMap(), roomPos+dmapOffset, ST_ITEM)||Game->GetScreenState(Game->GetCurMap(), roomPos+dmapOffset, ST_SPECIALITEM))
									markerState = 1;
								if(markerState!=1&&!(Game->LItems[Game->GetCurLevel()]&LI_COMPASS||!MINIMAP_REQUIRECOMPASS))
									noDrawMarker = true;
								if(markerCD==56418)
									noDrawMarker = false;
							}
							//Item and Special Item (4 states)
							else if(markerCT==CT_BOSSCHEST){
								if(Game->GetScreenState(Game->GetCurMap(), roomPos+dmapOffset, ST_SPECIALITEM))
									++markerState;
								if(Game->GetScreenState(Game->GetCurMap(), roomPos+dmapOffset, ST_ITEM))
									markerState += 2;
								if(markerState!=3&&!(Game->LItems[Game->GetCurLevel()]&LI_COMPASS||!MINIMAP_REQUIRECOMPASS))
									noDrawMarker = true;
							}
							//Boss level state
							else if(markerCT==CT_DAMAGE1){
								if(Game->LItems[Game->GetCurLevel()]&LI_BOSS)
									markerState = 1;
								// if(markerState!=1&&!(Game->LItems[Game->GetCurLevel()]&LI_COMPASS||!MINIMAP_REQUIRECOMPASS))
									// noDrawMarker = true;
							}
							//Lock block
							else if(markerCT==CT_LOCKBLOCK){
								if(Game->GetScreenState(Game->GetCurMap(), roomPos+dmapOffset, ST_LOCKBLOCK))
									markerState = 1;
								if(markerState!=1&&!(Game->LItems[Game->GetCurLevel()]&LI_COMPASS||!MINIMAP_REQUIRECOMPASS))
									noDrawMarker = true;
							}
							//Boss lock
							else if(markerCT==CT_BOSSLOCKBLOCK){
								if(Game->GetScreenState(Game->GetCurMap(), roomPos+dmapOffset, ST_BOSSLOCKBLOCK))
									markerState = 1;
								if(markerState!=1&&!(Game->LItems[Game->GetCurLevel()]&LI_COMPASS||!MINIMAP_REQUIRECOMPASS))
									noDrawMarker = true;
							}
							//Secret combo
							else if(markerCT==CT_STEP){
								if(Game->GetScreenState(Game->GetCurMap(), roomPos+dmapOffset, ST_SECRET))
									markerState = 1;
								if(markerState!=1&&!(Game->LItems[Game->GetCurLevel()]&LI_COMPASS||!MINIMAP_REQUIRECOMPASS))
									noDrawMarker = true;
								if(markerCD==56426)
									noDrawMarker = false;
								if(markerCD==56430){ //Laverne Quest Marker
									if((Game->Counter[CR_SMALLSIDEQUESTS1] & BF_0))
										noDrawMarker = false;
									else
										noDrawMarker = true;
								}
							}
							if(!noDrawMarker)
								Screen->FastCombo(MINIMAP_LAYER, MINIMAP_X+x*MINIMAP_SQUARESIZE, MINIMAP_Y-56+y*MINIMAP_SQUARESIZE, markerCD+markerState, markerCS, 128);
						}
					}
				}
			}
		}
	}
}

void Minimap_UpdateMapSubscreen(){
	int i; int j;
	if(!MINIMAP_LARGEMAP_ENABLED)
		return;
	if(LargeMapData[_LMD_LARGEMAPSTATE]==0){ //Map is closed
		if(Link->PressMap){
			LargeMapData[_LMD_LARGEMAPSTATE] = 1;
			LargeMapData[_LMD_LARGEMAPFRAMES] = 0;
			FreezeScreen();
			int currentMap = Minimap_GetCurrentLargeMap();
			for(i=0; i<2304; ++i){
				LargeMapLayout[_LML_LAYOUTCMB+i] = 0;
			}
			//If the current DMap isn't in the map array, just load that one
			if(currentMap==-1){
				Minimap_Overlay(Game->GetCurDMap(), 16, 20);
			}
			//Else load every other DMap in the same large map
			else{
				for(i=0; i<32; ++i){
					int dmap = LargeMapData[_LMD_MAPDEFS+_LMD_MAXMAPSECTORS*_LMD_SECTORSIZE*currentMap+_LMD_SECTORSIZE*i+_LMD_DMAP]; 
					if(dmap>-1){
						int xoff = LargeMapData[_LMD_MAPDEFS+_LMD_MAXMAPSECTORS*_LMD_SECTORSIZE*currentMap+_LMD_SECTORSIZE*i+_LMD_XOFF];
						int yoff = LargeMapData[_LMD_MAPDEFS+_LMD_MAXMAPSECTORS*_LMD_SECTORSIZE*currentMap+_LMD_SECTORSIZE*i+_LMD_YOFF];
						Minimap_Overlay(dmap, xoff, yoff);
					}
				}
			}
			//Screen->SetRenderTarget(RT_LARGEMAP1);
			GBMP[BMP_LARGEMAP]->Clear(0);
			//Screen->SetRenderTarget(RT_LARGEMAP2);
			GBMP[BMP_LARGEMAP2]->Clear(0);
			LargeMapData[_LMD_CURDRAWINDEX] = 0;
			LargeMapData[_LMD_DRAWCOUNT] = 0;
			LargeMapData[_LMD_MINX] = -1;
			LargeMapData[_LMD_MINY] = -1;
			LargeMapData[_LMD_MAXX] = -1;
			LargeMapData[_LMD_MAXY] = -1;
		}
	}
	else if(LargeMapData[_LMD_LARGEMAPSTATE]==1){ //Map is opening
		Minimap_LoadLargeMapData();
		if(LargeMapData[_LMD_LARGEMAPFRAMES]>MINIMAP_LARGEMAP_OPENCLOSEFRAMES*0.6666){
			Screen->Rectangle(MINIMAP_LAYER, 0, -56, 255, 175, C_MINIMAP_BG, 1, 0, 0, 0, true, 128);
		}
		else{
			if(LargeMapData[_LMD_LARGEMAPFRAMES]>MINIMAP_LARGEMAP_OPENCLOSEFRAMES*0.3333)
				Screen->Rectangle(MINIMAP_LAYER, 0, -56, 255, 175, C_MINIMAP_BG, 1, 0, 0, 0, true, 64);
			Screen->Rectangle(MINIMAP_LAYER, 0, -56, 255, 175, C_MINIMAP_BG, 1, 0, 0, 0, true, 64);
		}
		if(LargeMapData[_LMD_LARGEMAPFRAMES]<MINIMAP_LARGEMAP_OPENCLOSEFRAMES)
			++LargeMapData[_LMD_LARGEMAPFRAMES];
		else{
			LargeMapData[_LMD_LARGEMAPSTATE] = 2;
			//Position the camera in the center of the map
			LargeMapData[_LMD_MAPVIEWX] = Floor((LargeMapData[_LMD_MINX]+LargeMapData[_LMD_MAXX]+1)*MINIMAP_SQUARESIZE/2)-128;
			LargeMapData[_LMD_MAPVIEWY] = Floor((LargeMapData[_LMD_MINY]+LargeMapData[_LMD_MAXY]+1)*MINIMAP_SQUARESIZE/2)-128;
		}
	}
	else if(LargeMapData[_LMD_LARGEMAPSTATE]==2){ //Map is open
		Screen->Rectangle(MINIMAP_LAYER, 0, -56, 255, 175, C_MINIMAP_BG, 1, 0, 0, 0, true, 128);
		//Minimap_DrawBitmaps(LargeMapData[_LMD_MAPVIEWX], LargeMapData[_LMD_MAPVIEWY]);
		if(Link->PressMap){
			LargeMapData[_LMD_LARGEMAPSTATE] = 3;
			LargeMapData[_LMD_LARGEMAPFRAMES] = MINIMAP_LARGEMAP_OPENCLOSEFRAMES;
		}
		//Allow the camera to pan around
		LargeMapData[_LMD_MAPVIEWX] += Cond(Link->InputLeft, -2, 0) + Cond(Link->InputRight, 2, 0);
		LargeMapData[_LMD_MAPVIEWY] += Cond(Link->InputUp, -2, 0) + Cond(Link->InputDown, 2, 0);
		int edgeDist = 48;
		if(LargeMapData[_LMD_MAPVIEWX]<LargeMapData[_LMD_MINX]*MINIMAP_SQUARESIZE-edgeDist&&LargeMapData[_LMD_MAPVIEWX]>(LargeMapData[_LMD_MAXX]+1)*MINIMAP_SQUARESIZE+edgeDist-256)
			LargeMapData[_LMD_MAPVIEWX] = Floor((LargeMapData[_LMD_MINX]+LargeMapData[_LMD_MAXX]+1)*MINIMAP_SQUARESIZE/2)-128;
		else if(LargeMapData[_LMD_MAPVIEWX]<LargeMapData[_LMD_MINX]*MINIMAP_SQUARESIZE-edgeDist)
			LargeMapData[_LMD_MAPVIEWX] = LargeMapData[_LMD_MINX]*MINIMAP_SQUARESIZE-edgeDist;
		else if(LargeMapData[_LMD_MAPVIEWX]>(LargeMapData[_LMD_MAXX]+1)*MINIMAP_SQUARESIZE+edgeDist-256)
			LargeMapData[_LMD_MAPVIEWX] = (LargeMapData[_LMD_MAXX]+1)*MINIMAP_SQUARESIZE+edgeDist-256;
		
		if(LargeMapData[_LMD_MAPVIEWY]<LargeMapData[_LMD_MINY]*MINIMAP_SQUARESIZE-edgeDist&&LargeMapData[_LMD_MAPVIEWY]>(LargeMapData[_LMD_MAXY]+1)*MINIMAP_SQUARESIZE+24+edgeDist-256)
			LargeMapData[_LMD_MAPVIEWY] = Floor((LargeMapData[_LMD_MINY]+LargeMapData[_LMD_MAXY]+1)*MINIMAP_SQUARESIZE/2)-128;
		else if(LargeMapData[_LMD_MAPVIEWY]<LargeMapData[_LMD_MINY]*MINIMAP_SQUARESIZE-edgeDist)
			LargeMapData[_LMD_MAPVIEWY] = LargeMapData[_LMD_MINY]*MINIMAP_SQUARESIZE-edgeDist;
		else if(LargeMapData[_LMD_MAPVIEWY]>(LargeMapData[_LMD_MAXY]+1)*MINIMAP_SQUARESIZE+24+edgeDist-256)
			LargeMapData[_LMD_MAPVIEWY] = (LargeMapData[_LMD_MAXY]+1)*MINIMAP_SQUARESIZE+24+edgeDist-256;
		
	}
	else if(LargeMapData[_LMD_LARGEMAPSTATE]==3){ //Map is closed
		if(LargeMapData[_LMD_LARGEMAPFRAMES]>MINIMAP_LARGEMAP_OPENCLOSEFRAMES*0.6666){
			Screen->Rectangle(MINIMAP_LAYER, 0, -56, 255, 175, C_MINIMAP_BG, 1, 0, 0, 0, true, 128);
		}
		else{
			if(LargeMapData[_LMD_LARGEMAPFRAMES]>MINIMAP_LARGEMAP_OPENCLOSEFRAMES*0.3333)
				Screen->Rectangle(MINIMAP_LAYER, 0, -56, 255, 175, C_MINIMAP_BG, 1, 0, 0, 0, true, 64);
			Screen->Rectangle(MINIMAP_LAYER, 0, -56, 255, 175, C_MINIMAP_BG, 1, 0, 0, 0, true, 64);
		}
		if(LargeMapData[_LMD_LARGEMAPFRAMES])
			--LargeMapData[_LMD_LARGEMAPFRAMES];
		else{
			LargeMapData[_LMD_LARGEMAPSTATE] = 0;
			UnfreezeScreen();
		}
	}
	//Screen->SetRenderTarget(RT_SCREEN);
	//Link->InputMap = false; Link->PressMap = false;
}

void Minimap_DrawBitmaps(int baseX, int baseY, int x, int y, int timer){
	int origX = x;
	int origY = y;
	int sx = 0;
	int sy = 0;
	int w = 208; //256
	int h = 120; //256
	int offsc;
	//Allow the bitmap draws to go off the edges of the bitmap.
	//I don't like this math and I don't trust it.
	//Me and spatial awareness never got along great.
	if(x<0){
		offsc = -x;
		x = 0;
		sx += offsc;
		w -= offsc;
	}
	else if(x+w-1>511){
		offsc = ((x+w-1)-511);
		w -= offsc;
	}
	if(y<0){
		offsc = -y;
		y = 0;
		sy += offsc;
		h -= offsc;
	}
	else if(y+h-1>511){
		offsc = ((y+h-1)-511);
		h -= offsc;
	}
		
	//Draw Link's position to the bitmap so it can animate (this is the only exception for animated icons on the large map)
	//Screen->SetRenderTarget(RT_LARGEMAP1);
	int linkPos = LargeMapData[_LMD_LINKPOS];
	int roomX = (linkPos%48)*MINIMAP_SQUARESIZE;
	int roomY = Floor(linkPos/48)*MINIMAP_SQUARESIZE;
	Screen->FastCombo(0, roomX, roomY, 2654, 7, 128);
	if(LargeMapLayout[_LML_LAYOUTCMB+linkPos]){
		if(LargeMapLayout[_LML_BGCMB+linkPos]){
			GBMP[BMP_LARGEMAP]->FastCombo(0, roomX, roomY, LargeMapLayout[_LML_BGCMB+linkPos]+1, LargeMapLayout[_LML_LAYOUTCS+linkPos], 128);
			GBMP[BMP_LARGEMAP]->FastCombo(0, roomX, roomY, LargeMapLayout[_LML_LAYOUTCMB+linkPos], LargeMapLayout[_LML_LAYOUTCS+linkPos], 128);
		}
		else{
			GBMP[BMP_LARGEMAP]->FastCombo(0, roomX, roomY, LargeMapLayout[_LML_LAYOUTCMB+linkPos]+1, LargeMapLayout[_LML_LAYOUTCS+linkPos], 128);
		}
	}
	//Screen->SetRenderTarget(RT_SCREEN);
	GBMP[BMP_LARGEMAP]->Blit(0, GBMP[BMP_SCRIPTEDSUBSCREEN3], x, y, w, h, baseX+sx+24, baseY+sy+32, w, h, 0, 0, 0, 0, 0, true);
	//Screen->DrawBitmap(MINIMAP_LAYER, RT_LARGEMAP1, x, y, w, h, sx, -56+sy, w, h, 0, true);
	GBMP[BMP_LARGEMAP2]->Blit(0, GBMP[BMP_SCRIPTEDSUBSCREEN3], x, y, w, h, baseX+sx+24, baseY+sy+32, w, h, 0, 0, 0, 0, 0, true);
	//Screen->DrawBitmap(MINIMAP_LAYER, RT_LARGEMAP2, x, y, w, h, sx, -56+sy, w, h, 0, true);
}

int Minimap_GetCurrentLargeMap(){
	for(int i=0; i<_LMD_MAXMAPS; ++i){
		for(int j=0; j<_LMD_MAXMAPSECTORS; ++j){
			if(LargeMapData[_LMD_MAPDEFS+_LMD_MAXMAPSECTORS*_LMD_SECTORSIZE*i+_LMD_SECTORSIZE*j+_LMD_DMAP]==Game->GetCurDMap())
				return i;
		}
	}
	return -1;
}

void Minimap_Overlay(int dmap, int xoff, int yoff){
	int refMap; int refMarkerMap; int refScrn;
	int level = Game->DMapLevel[dmap];
	//Get the maps to reference for map drawing
	if(MINIMAP_USELEVELNUM){
		refMap = MINIMAP_MAPS+Floor(level/128);
		refMarkerMap = MINIMAP_MARKERMAPS+Floor(level/128);
		refScrn = level%128;
	}
	else{
		refMap = MINIMAP_MAPS+Floor(dmap/128);
		refMarkerMap = MINIMAP_MARKERMAPS+Floor(dmap/128);
		refScrn = dmap%128;
	}
	
	int map = Game->DMapMap[dmap];
	int dmapOffset = Game->DMapOffset[dmap];
	
	int bgCD = Game->GetComboData(refMap, refScrn, 160);
	
	int xpos;
	int totalX; int totalY;
	int roomX;
	int roomVisited; int markerState;
	int roomCD; int roomCS; int roomCF;
	int markerCD; int markerCS; int markerCT;
	
	mapdata room = Game->LoadMapData(refMap, refScrn);
	mapdata marker = Game->LoadMapData(refMarkerMap, refScrn);
	
	
	int roomPos = Game->GetCurDMapScreen();
	int floorFlag = marker->ComboF[roomPos];
	
	for(int i=0; i<128; ++i){
		xpos = i%16+dmapOffset;
		roomCD = Game->GetComboData(refMap, refScrn, i);
		if(roomCD&&xpos>=0&&xpos<=15){
			totalX = (i%16)+xoff;
			totalY = Floor(i/16)+yoff;
			roomX = (i%16)+dmapOffset;
			room = Game->LoadMapData(refMap, refScrn);
			marker = Game->LoadMapData(refMarkerMap, refScrn);
			if(totalX>=0&&totalX<=47&&totalY>=0&&totalY<=47&&roomX>=0&&roomX<=15&&marker->ComboF[i]==floorFlag){
				roomCD = room->ComboD[i]; //Game->GetComboData(refMap, refScrn, roomPos);
				roomCS = room->ComboC[i]; //Game->GetComboCSet(refMap, refScrn, roomPos);
				roomCF = room->ComboF[i]; //Game->GetComboFlag(refMap, refScrn, roomPos);
				markerCD = marker->ComboD[i]; //Game->GetComboData(refMarkerMap, refScrn, roomPos);
				markerCS = marker->ComboC[i]; //Game->GetComboCSet(refMarkerMap, refScrn, roomPos);
				markerCT = marker->ComboT[i]; //Game->GetComboType(refMarkerMap, refScrn, roomPos);
				roomVisited = 0;
				markerState = 0;
				//Check if Link has visited or is in this screen
				if(dmap==Game->GetCurDMap()&&i==Game->GetCurDMapScreen())
					LargeMapData[_LMD_LINKPOS] = ((i%16)+xoff)+48*(Floor(i/16)+yoff);
				if(Game->GetScreenState(map, i+dmapOffset, ST_VISITED)&&i+dmapOffset>-1)
					roomVisited = 1;
				//Hidden rooms are marked with a flag so they're visible in the editor but not in normal play until visited
				if(roomCF==CF_HIDDENROOM&&roomVisited==0)
					roomCD = 0;
				//Prevent showing unvisited rooms without the map
				if(!(Game->LItems[level]&LI_MAP)&&MINIMAP_REQUIREDUNGEONMAP&&roomVisited==0)
					roomCD = 0;
				if(roomCD){
					//If the background combo was set, draw that under the screen first
					if(bgCD){
						LargeMapLayout[_LML_BGCMB+totalX+48*totalY] = bgCD-1+roomVisited;
						LargeMapLayout[_LML_LAYOUTCMB+totalX+48*totalY] = roomCD;
						LargeMapLayout[_LML_LAYOUTCS+totalX+48*totalY] = roomCS;
					}
					else{
						LargeMapLayout[_LML_LAYOUTCMB+totalX+48*totalY] = roomCD+roomVisited;
						LargeMapLayout[_LML_LAYOUTCS+totalX+48*totalY] = roomCS+roomVisited;
					}
					bool noDrawMarker;
					//Check for markers on the layer screen
					if(markerCD&&(roomVisited||!MINIMAP_MARKERSREQUIREVISITED)){
						//Item or Special Item
						if(markerCT==CT_CHEST){
							if(Game->GetScreenState(map, i+dmapOffset, ST_ITEM)||Game->GetScreenState(map, i+dmapOffset, ST_SPECIALITEM))
								markerState = 1;
							if(markerState!=1&&!(Game->LItems[level]&LI_COMPASS)||!MINIMAP_REQUIRECOMPASS)
								noDrawMarker = true;
							if(markerCD==56418)
								noDrawMarker = false;
						}
						//Item and Special Item (4 states)
						else if(markerCT==CT_BOSSCHEST){
							if(Game->GetScreenState(map, i+dmapOffset, ST_SPECIALITEM))
								++markerState;
							if(Game->GetScreenState(map, i+dmapOffset, ST_ITEM))
								markerState += 2;
							if(markerState!=3&&!(Game->LItems[level]&LI_COMPASS)||!MINIMAP_REQUIRECOMPASS)
								noDrawMarker = true;
						}
						//Boss level state
						else if(markerCT==CT_DAMAGE1){
							if(Game->LItems[Game->DMapLevel[dmap]]&LI_BOSS)
								markerState = 1;
							// if(markerState!=1&&!(Game->LItems[level]&LI_COMPASS)||!MINIMAP_REQUIRECOMPASS)
								// noDrawMarker = true;
						}
						//Lock block
						else if(markerCT==CT_LOCKBLOCK){
							if(Game->GetScreenState(map, i+dmapOffset, ST_LOCKBLOCK))
								markerState = 1;
							if(markerState!=1&&!(Game->LItems[level]&LI_COMPASS)||!MINIMAP_REQUIRECOMPASS)
								noDrawMarker = true;
						}
						//Boss lock
						else if(markerCT==CT_BOSSLOCKBLOCK){
							if(Game->GetScreenState(map, i+dmapOffset, ST_BOSSLOCKBLOCK))
								markerState = 1;
							if(markerState!=1&&!(Game->LItems[level]&LI_COMPASS)||!MINIMAP_REQUIRECOMPASS)
								noDrawMarker = true;
						}
						//Secret combo
						else if(markerCT==CT_STEP){
							if(Game->GetScreenState(map, i+dmapOffset, ST_SECRET))
								markerState = 1;
							if(markerState!=1&&!(Game->LItems[level]&LI_COMPASS)||!MINIMAP_REQUIRECOMPASS)
								noDrawMarker = true;
							if(markerCD==56426)
								noDrawMarker = false;
							if(markerCD==56430){ //Laverne Quest Marker
								if((Game->Counter[CR_SMALLSIDEQUESTS1] & BF_0))
									noDrawMarker = false;
								else
									noDrawMarker = true;
							}
						}
						if(!noDrawMarker){
							LargeMapLayout[_LML_MARKERCMB+totalX+48*totalY] = markerCD+markerState;
							LargeMapLayout[_LML_MARKERCS+totalX+48*totalY] = markerCS;
						}
					}
				}
			}
		}
	}
}

void Minimap_LoadLargeMapData(){
	//No need to keep drawing if everything has already been drawn
	if(LargeMapData[_LMD_CURDRAWINDEX]==4608)
		return;
	int i;
	int x; int y;
	
	//Start with the layout layer
	//Screen->SetRenderTarget(RT_LARGEMAP1);
	for(i=LargeMapData[_LMD_CURDRAWINDEX]; i<2304&&LargeMapData[_LMD_DRAWCOUNT]<=MINIMAP_LARGEMAP_FRAMEDRAWCAP; ++i){
		if(LargeMapLayout[_LML_LAYOUTCMB+i]){
			x = i%48;
			y = Floor(i/48);
			//If this is the first room discovered, set the edges up
			//This should prevent it from reading the top left corner as the edge when there's nothing there
			if(LargeMapData[_LMD_MINX]==-1){
				LargeMapData[_LMD_MINX] = x;
				LargeMapData[_LMD_MAXX] = x;
				LargeMapData[_LMD_MINY] = y;
				LargeMapData[_LMD_MAXY] = y;
			}
			//Record edges of the map space
			if(x<LargeMapData[_LMD_MINX])
				LargeMapData[_LMD_MINX] = x;
			if(x>LargeMapData[_LMD_MAXX])
				LargeMapData[_LMD_MAXX] = x;
			if(y<LargeMapData[_LMD_MINY])
				LargeMapData[_LMD_MINY] = y;
			if(y>LargeMapData[_LMD_MAXY])
				LargeMapData[_LMD_MAXY] = y;
			
			x = i%48*MINIMAP_SQUARESIZE;
			y = Floor(i/48)*MINIMAP_SQUARESIZE;
			if(LargeMapLayout[_LML_BGCMB+i]){
				GBMP[BMP_LARGEMAP]->FastCombo(0, x, y, LargeMapLayout[_LML_BGCMB+i], LargeMapLayout[_LML_LAYOUTCS+i], 128);
				++LargeMapData[_LMD_DRAWCOUNT];
			}
			GBMP[BMP_LARGEMAP]->FastCombo(0, x, y, LargeMapLayout[_LML_LAYOUTCMB+i], LargeMapLayout[_LML_LAYOUTCS+i], 128);
			++LargeMapData[_LMD_DRAWCOUNT];
		}
		else if(MINIMAP_LARGEMAP_DEBUG){
			x = i%48;
			y = Floor(i/48);
			//If this is the first room discovered, set the edges up
			//This should prevent it from reading the top left corner as the edge when there's nothing there
			if(LargeMapData[_LMD_MINX]==-1){
				LargeMapData[_LMD_MINX] = x;
				LargeMapData[_LMD_MAXX] = x;
				LargeMapData[_LMD_MINY] = y;
				LargeMapData[_LMD_MAXY] = y;
			}
			//Record edges of the map space
			if(x<LargeMapData[_LMD_MINX])
				LargeMapData[_LMD_MINX] = x;
			if(x>LargeMapData[_LMD_MAXX])
				LargeMapData[_LMD_MAXX] = x;
			if(y<LargeMapData[_LMD_MINY])
				LargeMapData[_LMD_MINY] = y;
			if(y>LargeMapData[_LMD_MAXY])
				LargeMapData[_LMD_MAXY] = y;
			
			x *= MINIMAP_SQUARESIZE;
			y *= MINIMAP_SQUARESIZE;
			GBMP[BMP_LARGEMAP]->Rectangle(0, x+2, y+2, x+MINIMAP_SQUARESIZE-2, y+MINIMAP_SQUARESIZE-2, C_MINIMAP_DEBUG, 1, 0, 0, 0, false, 128);
			++LargeMapData[_LMD_DRAWCOUNT];
		}
	}
	LargeMapData[_LMD_CURDRAWINDEX] = i;
	if(LargeMapData[_LMD_DRAWCOUNT]>MINIMAP_LARGEMAP_FRAMEDRAWCAP){
		//Screen->SetRenderTarget(RT_SCREEN);
		LargeMapData[_LMD_DRAWCOUNT] = 0;
		return;
	}
	
	//Next draw the marker layer
	//Screen->SetRenderTarget(RT_LARGEMAP2);
	for(i=LargeMapData[_LMD_CURDRAWINDEX]-2304; i<2304&&LargeMapData[_LMD_DRAWCOUNT]<=MINIMAP_LARGEMAP_FRAMEDRAWCAP; ++i){
		if(LargeMapLayout[_LML_MARKERCMB+i]){
			x = i%48*MINIMAP_SQUARESIZE;
			y = Floor(i/48)*MINIMAP_SQUARESIZE;
			GBMP[BMP_LARGEMAP2]->FastCombo(0, x, y, LargeMapLayout[_LML_MARKERCMB+i], LargeMapLayout[_LML_MARKERCS+i], 128);
			++LargeMapData[_LMD_DRAWCOUNT];
		}
	}
	LargeMapData[_LMD_CURDRAWINDEX] = 2304+i;
	//Screen->SetRenderTarget(RT_SCREEN);
	LargeMapData[_LMD_DRAWCOUNT] = 0;
}

global script MetroidvaniaMinimap_Example{
	void run(){
		MiniMap_Init();
		while(true){
			Minimap_Update();
			Waitdraw();
			Waitframe();
		}
	}
}

int DamageNumbers[65536];

const int NPCM_DAMAGENUMBERSLASTHP = 12; //npc->Misc[] index tracking the enemy's last HP

//Tile and CSet for the first of 8 tiles for enemy damage numbers
const int GFX_DAMAGENUMBERS_ENEMY = 54280;
const int CS_DAMAGENUMBERS_ENEMY = 8;

//Tile and CSet for the first of 8 tiles for enemy healing numbers
const int GFX_DAMAGENUMBERS_ENEMYHEAL = 54300;
const int CS_DAMAGENUMBERS_ENEMYHEAL = 7;

//Tile and CSet for the first of 8 tiles for Link damage numbers
const int GFX_DAMAGENUMBERS_LINK = 54320;
const int CS_DAMAGENUMBERS_LINK = 8;

//Tile and CSet for the first of 8 tiles for Link healing numbers
const int GFX_DAMAGENUMBERS_LINKHEAL = 54300;
const int CS_DAMAGENUMBERS_LINKHEAL = 7;

//Width and height of damage number tiles in pixels
const int DAMAGENUMBERS_WIDTH = 4;
const int DAMAGENUMBERS_HEIGHT = 7;

//Multiplier and number of decimal places shown for enemies
const int DAMAGENUMBERS_ENEMY_MULTIPLIER = 1;
const int DAMAGENUMBERS_ENEMY_DECIMAL_PLACES = -1;

//Multiplier and number of decimal places shown for Link
const int DAMAGENUMBERS_LINK_MULTIPLIER = 6.25;
const int DAMAGENUMBERS_LINK_DECIMAL_PLACES = -1;

const int DAMAGENUMBERS_MAX = 32; //The max number of damage numbers drawn to the screen at once
const int DAMAGENUMBERS_FRAMES = 40; //How many frames the damage numbers last for
const int DAMAGENUMBERS_SPAWNFRAMES = 24; //How many frames the damage numbers to appear (0 for instant)
const int DAMAGENUMBERS_XOFF = 0; //X offset for the spawning point of the numbers
const int DAMAGENUMBERS_YOFF = -8; //Y offset for the spawning point of the numbers
const int DAMAGENUMBERS_YSPEED = -0.1; //The speed the number moves on the Y-axis (negative = upwards)
const int DAMAGENUMBERS_BOUNCEHEIGHT = 6; //How high in pixels the numbers bounce on the Y axis
const int DAMAGENUMBERS_LINKDAMAGECOOLDOWN = 16; //How often in frames the script can detect Link taking damage
const int DAMAGENUMBERS_LINKHEALCOOLDOWN = 16; //How often in frames the script can detect Link healing HP
const int DAMAGENUMBERS_ALLOW_LARGE_NEGATIVE = 0; //If 1, enemies with <-1000 HP can still draw damage numbers. This is usually used by scripts to kill enemies without making a death sound

//Internal constants used by the script, don't change
const int _DNUM_STARTINDEX = 16;
const int _DNUM_INDICES = 5;

const int _DNUM_LASTLINKHP = 0;
const int _DNUM_LINKDAMAGECOOLDOWN = 1;
const int _DNUM_LINKHEALCOOLDOWN = 2;
const int _DNUM_LASTDMAP = 3;
const int _DNUM_LASTSCREEN = 4;

const int _DNUMI_X = 0;
const int _DNUMI_Y = 1;
const int _DNUMI_TYPE = 2;
const int _DNUMI_DAMAGE = 3;
const int _DNUMI_TIMER = 4;

const int _DNUM_TYPE_ENEMYDAMAGE = 0;
const int _DNUM_TYPE_ENEMYHEAL = 1;
const int _DNUM_TYPE_LINKDAMAGE = 2;
const int _DNUM_TYPE_LINKHEAL = 3;

//Init function, clears the DamageNumbers[] array on every load
void DamageNumbers_Init(){
	int size = SizeOfArray(DamageNumbers);
	for(int i=0; i<size; i++){
		DamageNumbers[i] = 0;
	}
	
	DamageNumbers[_DNUM_LASTLINKHP] = Link->HP;
	DamageNumbers[_DNUM_LASTDMAP] = Game->GetCurDMap();
	DamageNumbers[_DNUM_LASTSCREEN] = Game->GetCurScreen();
}

//Update function for enemies. This can be combined with your own if you have one
void DamageNumbers_UpdateEnemies(){
	for(int i=Screen->NumNPCs(); i>0; i--){
		npc n = Screen->LoadNPC(i);
		DamageNumbers_UpdateEnemyDamage(n);
	}
}

//Update function for individual enemies
void DamageNumbers_UpdateEnemyDamage(npc n){
	//Detect when the enemy's HP has changed
	if(n->HP!=n->Misc[NPCM_DAMAGENUMBERSLASTHP]){
		//Ignore enemies that don't have conventional HP
		if(DamageNumbers_IgnoreEnemyType(n))
			return;
		
		//NPCs with -1000 HP have usually been killed by scripts
		if(n->HP>-1000||DAMAGENUMBERS_ALLOW_LARGE_NEGATIVE){
			//If it's less make a damage number
			if(n->HP<n->Misc[NPCM_DAMAGENUMBERSLASTHP]){
				if(GFX_DAMAGENUMBERS_ENEMY!=0){
					DamageNumbers_AddNumberGFX(CenterX(n), CenterY(n)-DAMAGENUMBERS_HEIGHT/2, _DNUM_TYPE_ENEMYDAMAGE, Abs(n->HP-n->Misc[NPCM_DAMAGENUMBERSLASTHP]));
				}
			}
			//else if it wasn't 0 (just spawned in) make a healing number
			else if(n->Misc[NPCM_DAMAGENUMBERSLASTHP]){
				if(GFX_DAMAGENUMBERS_ENEMYHEAL!=0){
					DamageNumbers_AddNumberGFX(CenterX(n), CenterY(n)-DAMAGENUMBERS_HEIGHT/2, _DNUM_TYPE_ENEMYHEAL, Abs(n->HP-n->Misc[NPCM_DAMAGENUMBERSLASTHP]));
				}
			}
		}
			
		//Update the change in HP
		n->Misc[NPCM_DAMAGENUMBERSLASTHP] = n->HP;
	}
	n->Misc[NPCM_FLAGS] &= ~NPCMF_NODAMAGENUMBERS;
}

//Function for finding enemies that should never show damage numbers
bool DamageNumbers_IgnoreEnemyType(npc n){
	bool invalidTypes[256];
	
	invalidTypes[NPCT_GUY] = true;
	invalidTypes[NPCT_ROCK] = true;
	invalidTypes[NPCT_TRAP] = true;
	invalidTypes[NPCT_PROJECTILE] = true;
	invalidTypes[NPCT_NONE] = true;
	invalidTypes[NPCT_FAIRY] = true;
	
	switch(n->ID){
		case 236:
		case 245:
		case 246:
		case 247:
		case 248:
			return true;
	}
	
	if(n->Misc[NPCM_FLAGS]&NPCMF_NODAMAGENUMBERS)
		return true;
	
	return invalidTypes[n->Type];
}

//Update function for Link
void DamageNumbers_UpdateLink(){
	//Cooldown timer for Link taking damage (for things that damage him every frame)
	if(DamageNumbers[_DNUM_LINKDAMAGECOOLDOWN]>0)
		DamageNumbers[_DNUM_LINKDAMAGECOOLDOWN]--;
	//Cooldown timer for Link healing (for things that heal him every frame)
	if(DamageNumbers[_DNUM_LINKHEALCOOLDOWN]>0)
		DamageNumbers[_DNUM_LINKHEALCOOLDOWN]--;
	
	//Whenever Link's HP changes
	int LinkHP = Link->HP;
	if(LinkHP==1) //Awkward hack for things that kill Link but not quite
		LinkHP = 0; //I could've used immortal but I am exceptionally lazy right now
	if(LinkHP!=DamageNumbers[_DNUM_LASTLINKHP]){
		//If he took damage and isn't on cooldown
		if(LinkHP<DamageNumbers[_DNUM_LASTLINKHP]){
			if(DamageNumbers[_DNUM_LINKDAMAGECOOLDOWN]<=0){
				if(GFX_DAMAGENUMBERS_LINK!=0)
					DamageNumbers_AddNumberGFX(CenterLinkX(), CenterLinkY()-DAMAGENUMBERS_HEIGHT/2, _DNUM_TYPE_LINKDAMAGE, Abs(LinkHP-DamageNumbers[_DNUM_LASTLINKHP]));
				
				DamageNumbers[_DNUM_LINKDAMAGECOOLDOWN] = DAMAGENUMBERS_LINKDAMAGECOOLDOWN;
			
				DamageNumbers[_DNUM_LASTLINKHP] = LinkHP;
			}
		}
		//otherwise if he healed and isn't on cooldown
		else{
			if(DamageNumbers[_DNUM_LINKHEALCOOLDOWN]<=0){
				if(GFX_DAMAGENUMBERS_LINKHEAL!=0)
					DamageNumbers_AddNumberGFX(CenterLinkX(), CenterLinkY()-DAMAGENUMBERS_HEIGHT/2, _DNUM_TYPE_LINKHEAL, Abs(LinkHP-DamageNumbers[_DNUM_LASTLINKHP]));
				
				DamageNumbers[_DNUM_LINKHEALCOOLDOWN] = DAMAGENUMBERS_LINKHEALCOOLDOWN;
			
				DamageNumbers[_DNUM_LASTLINKHP] = LinkHP;
			}
		}
	}
}

//Update function for scripted damage number draws
void DamageNumbers_UpdateNumberGFX(){
	int j;
	
	//If the screen has changed, reset all damage numbers
	if(Game->GetCurDMap()!=DamageNumbers[_DNUM_LASTDMAP]||Game->GetCurScreen()!=DamageNumbers[_DNUM_LASTSCREEN]){
		DamageNumbers_Init();
	}
	
	//Cycle through all number indices
	for(int i=0; i<DAMAGENUMBERS_MAX; i++){
		j = _DNUM_STARTINDEX+_DNUM_INDICES*i;
		//If >0, is valid
		if(DamageNumbers[j+_DNUMI_TIMER]>0){
			int type = DamageNumbers[j+_DNUMI_TYPE];
			
			int damage = DamageNumbers[j+_DNUMI_DAMAGE];
			
			//Draw all numbers based on type
			if(type==_DNUM_TYPE_ENEMYDAMAGE){
				if(DAMAGENUMBERS_ENEMY_MULTIPLIER>0)
					damage *= DAMAGENUMBERS_ENEMY_MULTIPLIER;
				DamageNumbers_Draw(DamageNumbers[j+_DNUMI_X]+DAMAGENUMBERS_XOFF, DamageNumbers[j+_DNUMI_Y]+DAMAGENUMBERS_YOFF, GFX_DAMAGENUMBERS_ENEMY, CS_DAMAGENUMBERS_ENEMY, damage, DamageNumbers[j+_DNUMI_TIMER], DAMAGENUMBERS_ENEMY_DECIMAL_PLACES);
			}
			else if(type==_DNUM_TYPE_ENEMYHEAL){
				if(DAMAGENUMBERS_ENEMY_MULTIPLIER>0)
					damage *= DAMAGENUMBERS_ENEMY_MULTIPLIER;
				DamageNumbers_Draw(DamageNumbers[j+_DNUMI_X]+DAMAGENUMBERS_XOFF, DamageNumbers[j+_DNUMI_Y]+DAMAGENUMBERS_YOFF, GFX_DAMAGENUMBERS_ENEMYHEAL, CS_DAMAGENUMBERS_ENEMYHEAL, damage, DamageNumbers[j+_DNUMI_TIMER], DAMAGENUMBERS_ENEMY_DECIMAL_PLACES);
			}
			else if(type==_DNUM_TYPE_LINKDAMAGE){
				if(DAMAGENUMBERS_LINK_MULTIPLIER>0)
					damage *= DAMAGENUMBERS_LINK_MULTIPLIER;
				damage = Ceiling(damage);
				DamageNumbers_Draw(DamageNumbers[j+_DNUMI_X]+DAMAGENUMBERS_XOFF, DamageNumbers[j+_DNUMI_Y]+DAMAGENUMBERS_YOFF, GFX_DAMAGENUMBERS_LINK, CS_DAMAGENUMBERS_LINK, damage, DamageNumbers[j+_DNUMI_TIMER], DAMAGENUMBERS_LINK_DECIMAL_PLACES);
			}
			else if(type==_DNUM_TYPE_LINKHEAL){
				if(DAMAGENUMBERS_LINK_MULTIPLIER>0)
					damage *= DAMAGENUMBERS_LINK_MULTIPLIER;
				damage = Ceiling(damage);
				DamageNumbers_Draw(DamageNumbers[j+_DNUMI_X]+DAMAGENUMBERS_XOFF, DamageNumbers[j+_DNUMI_Y]+DAMAGENUMBERS_YOFF, GFX_DAMAGENUMBERS_LINKHEAL, CS_DAMAGENUMBERS_LINKHEAL, damage, DamageNumbers[j+_DNUMI_TIMER], DAMAGENUMBERS_LINK_DECIMAL_PLACES);
			}
			
			DamageNumbers[j+_DNUMI_Y] += DAMAGENUMBERS_YSPEED;
			DamageNumbers[j+_DNUMI_TIMER]--;
		}
	}
}

//Function to add scripted damage number draws
void DamageNumbers_AddNumberGFX(int x, int y, int type, int damage){
	int j;
	//Cycle through all number indices
	for(int i=0; i<DAMAGENUMBERS_MAX; i++){
		j = _DNUM_STARTINDEX+_DNUM_INDICES*i;
		//If <= 0, is invalid
		if(DamageNumbers[j+_DNUMI_TIMER]<=0){
			DamageNumbers[j+_DNUMI_X] = x;
			DamageNumbers[j+_DNUMI_Y] = y;
			DamageNumbers[j+_DNUMI_TYPE] = type;
			DamageNumbers[j+_DNUMI_DAMAGE] = damage;
			DamageNumbers[j+_DNUMI_TIMER] = DAMAGENUMBERS_FRAMES;
			return;
		}
	}
}

//Function to draw scripted damage number draws for one frame
void DamageNumbers_Draw(int x, int y, int gfx, int cs, int num, int frame, int numDecimalPlaces){
	int i; int j; int k;
	
	//Frames normally count down, but this function calculates stuff as if they're counting up
	frame = DAMAGENUMBERS_FRAMES-frame;
	
	num = Clamp(num, 0, MAX_INT);
	int drawX = Floor(x-DAMAGENUMBERS_WIDTH/2);
	int drawY = Floor(y-DAMAGENUMBERS_HEIGHT/2);
	int digitsWh[7];
	
	//Get each digit of the number
	digitsWh[0] = Floor(num)%10;
	digitsWh[1] = Floor(num/10)%10;
	digitsWh[2] = Floor(num/100)%10;
	digitsWh[3] = Floor(num/1000)%10;
	digitsWh[4] = Floor(num/10000)%10;
	digitsWh[5] = Floor(num/100000)%10;
	
	int digitsDc[6] = {-1, -1, -1, -1, -1};
	
	//If decimal places should be drawn
	if(numDecimalPlaces!=0){
		digitsDc[0] = 10; //Add the decimal point character
		
		//Get the digits of each decimal place
		i = (num-Floor(num))*10000;
		digitsDc[4] = Floor(i)%10;
		digitsDc[3] = Floor(i/10)%10;
		digitsDc[2] = Floor(i/100)%10;
		digitsDc[1] = Floor(i/1000)%10;
		
		//If there's a fixed number of decimal places, clear the unused ones
		if(numDecimalPlaces>0){
			for(i=4; i>numDecimalPlaces; i--)
				digitsDc[i] = -1;
		}
		//Else (-1) clear the unused ones
		else{
			for(i=1; digitsDc[i]==0&&i<=4; i++)
				digitsDc[i] = -1;
			//If all decimal places are empty, the number is whole. Remove the decimal point
			if(digitsDc[1]==-1)
				digitsDc[0] = -1;
		}
	}
	
	//Find how many whole number places should be visible
	int placesWh = 1;
	if(num>=100000)
		placesWh = 6;
	else if(num>=10000)
		placesWh = 5;
	else if(num>=1000)
		placesWh = 4;
	else if(num>=100)
		placesWh = 3;
	else if(num>=10)
		placesWh = 2;
	
	int digits[11];
	int numDigits;
	
	//Put the whole and decimal digits into one array
	for(i=4; i>=0; i--){
		if(digitsDc[i]>0){
			digits[numDigits] = digitsDc[i];
			numDigits++;
		}
	}
	for(i=0; i<placesWh; i++){
		digits[numDigits] = digitsWh[i];
		numDigits++;
	}
	
	//Center the starting position of the number
	//(this gets added instead of subtracted because the numbers are drawn right to left)
	drawX += Floor(-DAMAGENUMBERS_WIDTH/2+(numDigits-1)*DAMAGENUMBERS_WIDTH/2);
	
	int tmpX; int tmpY;
	
	int spawnFreq;
	if(DAMAGENUMBERS_SPAWNFRAMES==0)
		spawnFreq = 0;
	else 
		spawnFreq = (360/DAMAGENUMBERS_SPAWNFRAMES);
	int spawnFreq2 = (180/numDigits);
	
	//Draw each digit in sequence
	for(i=0; i<numDigits; i++){
		k = frame*spawnFreq-i*spawnFreq2;
		j = Abs(Sin(Clamp(k, 0, 180)));
		tmpX = drawX-i*DAMAGENUMBERS_WIDTH;
		tmpY = drawY-DAMAGENUMBERS_BOUNCEHEIGHT*j;
		//Check if each digit should be drawn
		//When k>0, the Abs(Sin(k)) bounce animation has started. k is clamped so it only plays once.
		//Otherwise if spawnFreq is 0, all digits appear instantly
		if(k>=0||spawnFreq==0){
			if(gfx>0)
				Screen->FastTile(6, tmpX, tmpY, gfx+digits[i], cs, 128);
			else
				Screen->FastCombo(6, tmpX, tmpY, Abs(gfx)+digits[i], cs, 128);
		}
	}
}

global script DamageNumbers_ExampleGlobal{
	void run(){
		DamageNumbers_Init();
		while(true){
			DamageNumbers_UpdateEnemies();
			DamageNumbers_UpdateLink();
			DamageNumbers_UpdateNumberGFX();
			
			Waitdraw();
			Waitframe();
		}
	}
}

const int CRYSTALSWITCH_CAN_WALK_ON_TOP = 1; //If 1, Link can walk on top of raised crystal switches when they raise while under him
const int CRYSTALSWITCH_RESET_ON_F6 = 1; //If 1, switch states will reset to their defaults when F6 is pressed. Else they'll only be set when the save file is first loaded.
const int CRYSTALSWITCH_USE_BLANK_TRIGGER = 1; //If 1, the switch uses color neutral tiles when there's more than two possible color states
const int CRYSTALSWITCH_USE_FFC_GRAPHICS = 0; //If 1, the switch graphics are set to the FFC instead of the combo beneath it
const int CRYSTALSWITCH_RAISELINK = 5; //If >1 Link will be pushed up that many pixels with the block

const int CRYSTALSWITCH_NUM_COLORS = 4; //How many colors of switches are enabled
const int CRYSTALSWITCH_RISINGCOMBOS = 3; //How many combos are used in the switch rising animation
const int CRYSTALSWITCH_RISINGASPEED = 4; //A.Speed for the rising animation

const int CMB_CRYSTALSWITCH_BLOCKS = 38556; //SET TO: The first of the combos for your first set of raising/lowering blocks
const int CMB_CRYSTALSWITCH_TRIGGERS = 38588; //SET TO: The first of the combos for crystal switch triggers
const int CMB_CRYSTALSWITCH_STATICBLOCKS = 38600; //SET TO: The first of the combos for static (gray) blocks that you can walk over from 

const int CRYSTALSWITCH_OFFSET = 0; //How spaced apart switch combos are in the combo table. If 0, this is calculated automatically.

const int SFX_CRYSTALSWITCH_TRIGGER = 6; //Sound when the Crystal Switch is hit

//Array indices. Don't change.
const int CRSW_FIRSTLOAD = 0;
const int CRSW_ANIM = 1;
const int CRSW_LINKONRAISED = 2;
const int CRSW_LASTDMAP = 3;
const int CRSW_LASTSCREEN = 4;
const int CRSW_JUMPOFF = 5;
const int CRSW_STATICBLOCKANIM = 6;
const int CRSW_WASFALLING = 7;
const int CRSW_LSTATES = 10;
const int CRSW_SCRNDAT = 522;
int CrystalSwitch[698];

void CrystalSwitch_Init(){
	CrystalSwitch[CRSW_ANIM] = 0;
	CrystalSwitch[CRSW_LINKONRAISED] = 0;
	CrystalSwitch[CRSW_JUMPOFF] = 0;
	CrystalSwitch[CRSW_STATICBLOCKANIM] = 0;
	
	int ss[512];
	for(int i=0; i<512; i++)ss[i] = 10101010b; //Crystal switches default to every other color being raised
	
	//%FINDME CrystalSwitch Init States
	//Define special starting states for the levels in your quest here.
	//True = Raised. False = Lowered.
	//                 ss, Level, Color1, Color2, Color3, Color4, Color5, Color6, Color7, Color8
	//CS_StartingState(ss, 1,     true,   false,  true,   true,   false,  true,   true,   true);
	
	//Set switch array for the first time the quest is loaded
	if(CrystalSwitch[CRSW_FIRSTLOAD]==0 || CRYSTALSWITCH_RESET_ON_F6){
		for(int i=0; i<512; i++){
			CrystalSwitch[CRSW_LSTATES+i] = ss[i];
		}
		CrystalSwitch[CRSW_FIRSTLOAD] = 1;
	}
	if(CrystalSwitch_OnRaised(true)){
		CrystalSwitch[CRSW_LINKONRAISED] = 1;
	}
}

void CS_StartingState(int startingStates, int levelNum, bool s1up, bool s2up, bool s3up, bool s4up, bool s5up, bool s6up, bool s7up, bool s8up){
	startingStates[levelNum] = 0;
	
	if(s1up)
		startingStates[levelNum] |= 1;
	if(s2up)
		startingStates[levelNum] |= 1<<1;
	if(s3up)
		startingStates[levelNum] |= 1<<2;
	if(s4up)
		startingStates[levelNum] |= 1<<3;
	if(s5up)
		startingStates[levelNum] |= 1<<4;
	if(s6up)
		startingStates[levelNum] |= 1<<5;
	if(s7up)
		startingStates[levelNum] |= 1<<6;
	if(s8up)
		startingStates[levelNum] |= 1<<7;
}
void CS_StartingState(int startingStates, int levelNum, bool s1up, bool s2up, bool s3up, bool s4up, bool s5up, bool s6up, bool s7up){
	startingStates[levelNum] = 0;
	
	if(s1up)
		startingStates[levelNum] |= 1;
	if(s2up)
		startingStates[levelNum] |= 1<<1;
	if(s3up)
		startingStates[levelNum] |= 1<<2;
	if(s4up)
		startingStates[levelNum] |= 1<<3;
	if(s5up)
		startingStates[levelNum] |= 1<<4;
	if(s6up)
		startingStates[levelNum] |= 1<<5;
	if(s7up)
		startingStates[levelNum] |= 1<<6;
}
void CS_StartingState(int startingStates, int levelNum, bool s1up, bool s2up, bool s3up, bool s4up, bool s5up, bool s6up){
	startingStates[levelNum] = 0;
	
	if(s1up)
		startingStates[levelNum] |= 1;
	if(s2up)
		startingStates[levelNum] |= 1<<1;
	if(s3up)
		startingStates[levelNum] |= 1<<2;
	if(s4up)
		startingStates[levelNum] |= 1<<3;
	if(s5up)
		startingStates[levelNum] |= 1<<4;
	if(s6up)
		startingStates[levelNum] |= 1<<5;
}
void CS_StartingState(int startingStates, int levelNum, bool s1up, bool s2up, bool s3up, bool s4up, bool s5up){
	startingStates[levelNum] = 0;
	
	if(s1up)
		startingStates[levelNum] |= 1;
	if(s2up)
		startingStates[levelNum] |= 1<<1;
	if(s3up)
		startingStates[levelNum] |= 1<<2;
	if(s4up)
		startingStates[levelNum] |= 1<<3;
	if(s5up)
		startingStates[levelNum] |= 1<<4;
}
void CS_StartingState(int startingStates, int levelNum, bool s1up, bool s2up, bool s3up, bool s4up){
	startingStates[levelNum] = 0;
	
	if(s1up)
		startingStates[levelNum] |= 1;
	if(s2up)
		startingStates[levelNum] |= 1<<1;
	if(s3up)
		startingStates[levelNum] |= 1<<2;
	if(s4up)
		startingStates[levelNum] |= 1<<3;
}
void CS_StartingState(int startingStates, int levelNum, bool s1up, bool s2up, bool s3up){
	startingStates[levelNum] = 0;
	
	if(s1up)
		startingStates[levelNum] |= 1;
	if(s2up)
		startingStates[levelNum] |= 1<<1;
	if(s3up)
		startingStates[levelNum] |= 1<<2;
}
void CS_StartingState(int startingStates, int levelNum, bool s1up, bool s2up){
	startingStates[levelNum] = 0;
	
	if(s1up)
		startingStates[levelNum] |= 1;
	if(s2up)
		startingStates[levelNum] |= 1<<1;
}

void CrystalSwitch_Update(){
	int i; int j; int k;
	if(Link->Action==LA_SCROLLING){
		//Wipe static block data when scrolling
		for(int i=0; i<176; i++){
			CrystalSwitch[CRSW_SCRNDAT+i] = 0;
		}
	}
	
	if(CrystalSwitch[CRSW_WASFALLING]){
		if(CrystalSwitch_OnRaised(true)){
			CrystalSwitch[CRSW_LINKONRAISED] = 1;
		}
		CrystalSwitch[CRSW_WASFALLING] = 0;
	}
	if(Link->Falling)
		CrystalSwitch[CRSW_WASFALLING] = 1;
	
	int swCMBOffset;
	if(CRYSTALSWITCH_OFFSET)
		swCMBOffset = CRYSTALSWITCH_OFFSET;
	else
		swCMBOffset = Ceiling((2+CRYSTALSWITCH_RISINGCOMBOS)*0.25)*4;
	int lv = Game->GetCurLevel();
	//TraceBint(6, 0, 0, CrystalSwitch[CRSW_LSTATES+lv]);
	int linkColl = CrystalSwitch_OnRaised(true);
	for(i=0; i<176; i++){
		int cd = Screen->ComboD[i];
		for(j=0; j<CRYSTALSWITCH_NUM_COLORS; j++){
			//Check if each combo is one of the switch combos
			if(cd>=CMB_CRYSTALSWITCH_BLOCKS+swCMBOffset*j&&cd<CMB_CRYSTALSWITCH_BLOCKS+swCMBOffset*j+2+CRYSTALSWITCH_RISINGCOMBOS){
				//Up/Down state of blocks
				int swst = ((CrystalSwitch[CRSW_LSTATES+lv]&(1<<j)))>>j;
				bool animating;
				//Whether blocks are animating
				if(CrystalSwitch[CRSW_ANIM]>0&&CrystalSwitch[CRSW_LSTATES+lv]&(1<<(j+8)))
					animating = true;
				
				//Place the combo based on raising/lowering animation
				if(animating){
					int aframe = Clamp(Floor(CrystalSwitch[CRSW_ANIM]/CRYSTALSWITCH_RISINGASPEED), 0, CRYSTALSWITCH_RISINGCOMBOS-1);
					if(swst){
						aframe = CRYSTALSWITCH_RISINGCOMBOS-1-aframe;
					}
					Screen->ComboD[i] = CMB_CRYSTALSWITCH_BLOCKS+j*swCMBOffset+1+aframe;
				}
				else{
					//Place the raised combo
					if(swst){
						Screen->ComboD[i] = CMB_CRYSTALSWITCH_BLOCKS+j*swCMBOffset+1+CRYSTALSWITCH_RISINGCOMBOS;
					}
					//Place the lowered combo
					else{
						Screen->ComboD[i] = CMB_CRYSTALSWITCH_BLOCKS+j*swCMBOffset;
					}
				}
				
				//If Link can walk on combos, alter the solidity based on that
				if(CRYSTALSWITCH_CAN_WALK_ON_TOP){
					if((!swst&&!animating)||CrystalSwitch[CRSW_LINKONRAISED])
						Screen->ComboS[i] = 0000b;
					else
						Screen->ComboS[i] = 1111b;
				}
			}
		}
		if(cd>=CMB_CRYSTALSWITCH_STATICBLOCKS&&cd<CMB_CRYSTALSWITCH_STATICBLOCKS+2+CRYSTALSWITCH_RISINGCOMBOS){
			int cd2 = cd-CMB_CRYSTALSWITCH_STATICBLOCKS;
			k = (CrystalSwitch[CRSW_SCRNDAT+i]&(0xFF<<8))>>8; //Left 8 bits: Timer. 
			
			if(CRYSTALSWITCH_CAN_WALK_ON_TOP){
				if(linkColl&(1<<9))
					CrystalSwitch[CRSW_LINKONRAISED] = 1;
			}
			
			if(k>0){
				k--;
				if(k==0){
					//Moving Down
					if(CrystalSwitch[CRSW_SCRNDAT+i]&1){
						Screen->ComboD[i] = Clamp(Screen->ComboD[i]-1, CMB_CRYSTALSWITCH_STATICBLOCKS, CMB_CRYSTALSWITCH_STATICBLOCKS+2+CRYSTALSWITCH_RISINGCOMBOS-1);
						if(Screen->ComboD[i]==CMB_CRYSTALSWITCH_STATICBLOCKS){
							k = -1; //Done animating
						}
					}
					//Moving Up
					else{
						Screen->ComboD[i] = Clamp(Screen->ComboD[i]+1, CMB_CRYSTALSWITCH_STATICBLOCKS, CMB_CRYSTALSWITCH_STATICBLOCKS+2+CRYSTALSWITCH_RISINGCOMBOS-1);
						if(Screen->ComboD[i]==CMB_CRYSTALSWITCH_STATICBLOCKS+2+CRYSTALSWITCH_RISINGCOMBOS-1){
							k = -1; //Done animating
						}
					}
					
					if(k==-1){
						k = 0;
					}
					else{
						k = CRYSTALSWITCH_RISINGASPEED;
					}
				}
				CrystalSwitch[CRSW_SCRNDAT+i] &= 0xFF;
				CrystalSwitch[CRSW_SCRNDAT+i] |= k<<8;
			}
			else{
				if(cd2==0){
					CrystalSwitch[CRSW_SCRNDAT+i] &= ~1;
				}
				else if(cd2==2+CRYSTALSWITCH_RISINGCOMBOS-1){
					CrystalSwitch[CRSW_SCRNDAT+i] |= 1;
				}
				else{
					//Moving Down
					if(CrystalSwitch[CRSW_SCRNDAT+i]&1){
						CrystalSwitch[CRSW_SCRNDAT+i] = 1;
						CrystalSwitch[CRSW_SCRNDAT+i] |= CRYSTALSWITCH_RISINGASPEED<<8;
					}
					//Moving Up
					else{
						CrystalSwitch[CRSW_SCRNDAT+i] = 0;
						CrystalSwitch[CRSW_SCRNDAT+i] |= CRYSTALSWITCH_RISINGASPEED<<8;
					}
				}
			}
			
			//If Link can walk on combos, alter the solidity based on that
			if(CRYSTALSWITCH_CAN_WALK_ON_TOP){
				if(linkColl&(1<<9))
					CrystalSwitch[CRSW_LINKONRAISED] = 1;
				if(cd2==0||CrystalSwitch[CRSW_LINKONRAISED])
					Screen->ComboS[i] = 0000b;
				else
					Screen->ComboS[i] = 1111b;
			}
		}
	}
	
	if(CRYSTALSWITCH_CAN_WALK_ON_TOP){
		if(Link->Action!=LA_SCROLLING&&!IsSideview()){
			//When entering a screen on a raised block
			if(Game->GetCurDMap()!=CrystalSwitch[CRSW_LASTDMAP]||Game->GetCurDMapScreen()!=CrystalSwitch[CRSW_LASTSCREEN]){
				if(CrystalSwitch_OnRaised(true)){
					CrystalSwitch[CRSW_LINKONRAISED] = 1;
				}
				CrystalSwitch[CRSW_LASTDMAP] = Game->GetCurDMap();
				CrystalSwitch[CRSW_LASTSCREEN] = Game->GetCurDMapScreen();
			}
			//Else detect Link stepping off a block
			else if(CrystalSwitch[CRSW_LINKONRAISED]){
				if(Link->Z==0&&Link->Action!=LA_FROZEN&&!CrystalSwitch_OnRaised(true)){
					Game->PlaySound(SFX_JUMP);
					Link->Jump = 1;
					Link->Z = 4;
					CrystalSwitch[CRSW_JUMPOFF] = 1;
					CrystalSwitch[CRSW_LINKONRAISED] = 0;
				}
				//If he's not stepping off but the block is animating, move him with it
				else if(CRYSTALSWITCH_RAISELINK){
					if(CrystalSwitch[CRSW_ANIM]>0&&!IsSideview()){
						linkColl = CrystalSwitch_OnRaised(false);
						int movement = -1;
						//Find the sum of movement up/down of the blocks Link is standing on
						for(j=0; j<CRYSTALSWITCH_NUM_COLORS; j++){
							//Check if Link is touching the block
							if(linkColl&(1<<j)){
								//Raised block
								if(CrystalSwitch[CRSW_LSTATES+Game->GetCurLevel()]&(1<<j)){
									//Is it currently animating?
									if(CrystalSwitch[CRSW_LSTATES+Game->GetCurLevel()]&(1<<(j+8))){
										if(movement==-1)
											movement = 2;
										//Cancel out conflicting movements
										else if(movement==1)
											movement = 0;
									}
									//Link is on an unmoving raised block and cannot be affected by others
									else{
										movement = 0;
									}
								}
								//Lowered block
								else{
									//Is it currently animating?
									if(CrystalSwitch[CRSW_LSTATES+Game->GetCurLevel()]&(1<<(j+8))){
										if(movement==-1)
											movement = 1;
										//Cancel out conflicting movements
										else if(movement==2)
											movement = 0;
									}
								}
							}
						}
						if(movement==-1)
							movement = 0;
						if(movement>0){
							j = CrystalSwitch[CRSW_ANIM]/(CRYSTALSWITCH_RISINGASPEED*CRYSTALSWITCH_RISINGCOMBOS)*CRYSTALSWITCH_RAISELINK;
							k = Min(CrystalSwitch[CRSW_ANIM]+1, (CRYSTALSWITCH_RISINGASPEED*CRYSTALSWITCH_RISINGCOMBOS))/(CRYSTALSWITCH_RISINGASPEED*CRYSTALSWITCH_RISINGCOMBOS)*CRYSTALSWITCH_RAISELINK;
							
							j = Abs(Round(j)-Round(k));
							for(i=0; i<j; i++){
								if(movement==2){
									if(CanWalk(Link->X, Link->Y, DIR_UP, 1, false)){
										Link->Y--;
										if(!CrystalSwitch_OnRaised(true))
											Link->Y++;
									}
								}
								else{
									if(CanWalk(Link->X, Link->Y, DIR_DOWN, 1, false)){
										Link->Y++;
										if(!CrystalSwitch_OnRaised(true))
											Link->Y--;
									}
								}
							}
						}
					}
				}
			}
		}
		else
			CrystalSwitch[CRSW_LINKONRAISED] = 0;
	}
	
	//Prevent movement while jumping off a block
	if(CrystalSwitch[CRSW_JUMPOFF]){
		if(Link->Z>0)
			NoAction();
		else
			CrystalSwitch[CRSW_JUMPOFF] = 0;
	}
	
	if(CrystalSwitch[CRSW_ANIM]>0)
		CrystalSwitch[CRSW_ANIM]--;
	else{
		CrystalSwitch[CRSW_LSTATES+Game->GetCurLevel()] &= 0xFF;
	}
}

//Return sum of all bits for blocks Link is standing on
int CrystalSwitch_OnRaised(bool onlyRaised){
	int swCMBOffset;
	if(CRYSTALSWITCH_OFFSET)
		swCMBOffset = CRYSTALSWITCH_OFFSET;
	else
		swCMBOffset = Ceiling((2+CRYSTALSWITCH_RISINGCOMBOS)*0.25)*4;
	int ret;
	bool blockLowering;
	for(int x=0; x<2; x++){
		for(int y=0; y<2; y++){
			int cd = Screen->ComboD[ComboAt(Link->X+2+x*12, Link->Y+10+y*4)];
			//Check if Link is on colored blocks
			for(int j=0; j<CRYSTALSWITCH_NUM_COLORS; j++){
				if(cd>=CMB_CRYSTALSWITCH_BLOCKS+swCMBOffset*j&&cd<CMB_CRYSTALSWITCH_BLOCKS+swCMBOffset*j+2+CRYSTALSWITCH_RISINGCOMBOS){
					if(onlyRaised){
						int lstate = CrystalSwitch[CRSW_LSTATES+Game->GetCurLevel()];
						//Animated combos
						if(lstate&(1<<(j+8))){
							//Lowered, raising
							if(lstate&(1<<j)){
								ret |= (1<<j);
							}
							//Raised, lowering, last frame
							else if(CrystalSwitch[CRSW_LINKONRAISED]&&CrystalSwitch[CRSW_ANIM]==1){
								blockLowering = true;
							}
							else{
								ret |= (1<<j);
							}
								
						}
						else if(lstate&(1<<j)){
							ret |= (1<<j);
						}
					}
					else{
						ret |= (1<<j);
					}
				}
			}
			//Check if Link is on gray blocks
			if(cd>=CMB_CRYSTALSWITCH_STATICBLOCKS&&cd<CMB_CRYSTALSWITCH_STATICBLOCKS+2+CRYSTALSWITCH_RISINGCOMBOS){
				int cd2 = cd-CMB_CRYSTALSWITCH_STATICBLOCKS;
				if(onlyRaised){
					if(cd2==0){
						//blockLowering = true;
					}
					else{
						ret |= 1<<9;
					}
				}
				else{
					ret |= (1<<9);
				}
			}
		}
	}
	
	//Unset on block variable if Link is standing on a block during its last lowering frame
	if(ret==0&&blockLowering){
		CrystalSwitch[CRSW_LINKONRAISED] = 0;
		return 1<<15; //Return a value just to prevent the hopping code from running. 
	}
	return ret;
}

//D0-D3: Switch colors (1-8) to toggle. 0 for none.
//D6: If >0, forces the switch to use a custom pair of combos. Based on the state of D0. Raised combo, followed by lowered.
//D7: Special behaviors
//		0 - Standard operations. D0-D4 toggle between lowered and raised.
//		1 - Lower D0, raise all others
//		2 - Cycle between lowered color, raise all others
ffc script CrystalSwitch_Trigger{
	void run(int toggleA, int toggleB, int toggleC, int toggleD, int d4, int d5, int forceCombo, int specialBehavior){
		if(toggleA==toggleB){
			if(toggleA==0&&toggleB==0){
				toggleA = 1;
				toggleB = 2;
			}
			else
				toggleB = toggleA+1;
		}
		if(toggleA>0)
			toggleA = Clamp(toggleA-1, 0, CRYSTALSWITCH_NUM_COLORS-1);
		else
			toggleA = -1;
		if(toggleB>0)
			toggleB = Clamp(toggleB-1, 0, CRYSTALSWITCH_NUM_COLORS-1);
		else
			toggleB = -1;
		if(toggleC>0)
			toggleC = Clamp(toggleC-1, 0, CRYSTALSWITCH_NUM_COLORS-1);
		else
			toggleC = -1;
		if(toggleD>0)
			toggleD = Clamp(toggleD-1, 0, CRYSTALSWITCH_NUM_COLORS-1);
		else
			toggleD = -1;
		
		int toggleCount;
		if(toggleA>-1)
			toggleCount++;
		if(toggleB>-1)
			toggleCount++;
		if(toggleC>-1)
			toggleCount++;
		if(toggleD>-1)
			toggleCount++;
		
		
		int pos = ComboAt(this->X+8, this->Y+8);
		this->X = ComboX(pos);
		this->Y = ComboY(pos);
		
		lweapon lastTrigger[1];
		this->Data = 0;
		
		int strikeCooldown;
		while(true){
			int lstate = CrystalSwitch[CRSW_LSTATES+Game->GetCurLevel()];
			
			int loweredState = -1;
			//Find the first state that's lowered
			if(loweredState==-1){
				if(!(lstate&(1<<toggleA)))
					loweredState = toggleA;
			}
			if(loweredState==-1){
				if(!(lstate&(1<<toggleB)))
					loweredState = toggleB;
			}
			if(loweredState==-1){
				if(!(lstate&(1<<toggleC)))
					loweredState = toggleC;
			}
			if(loweredState==-1){
				if(!(lstate&(1<<toggleD)))
					loweredState = toggleD;
			}
			
			bool canHit = true;
			//In Special Behavior 1: The switch cannot be hit if A is already lowered
			if(specialBehavior==1&&!(lstate&(1<<toggleA)))
				canHit = false;
			if(CrystalSwitch_CheckCollision(this, lastTrigger)){
				if(strikeCooldown==0&&canHit&&CrystalSwitch[CRSW_ANIM]==0){
					Game->PlaySound(SFX_CRYSTALSWITCH_TRIGGER);
					
					int linkColl = CrystalSwitch_OnRaised(false)&0xFF; //Function returns sum of all bits for blocks Link is on
					
					int newState = 0; //Flag which block states are being changed
					int newStateMask = 0; //Mask used for combining new states with the existing level states
					
					//Raise all, lower A
					if(specialBehavior==1){
						newStateMask |= 1<<toggleA;
						if(toggleB>-1){
							newState |= 1<<toggleB;
							newStateMask |= 1<<toggleB;
						}
						if(toggleC>-1){
							newState |= 1<<toggleC;
							newStateMask |= 1<<toggleC;
						}
						if(toggleD>-1){
							newState |= 1<<toggleD;
							newStateMask |= 1<<toggleD;
						}
					}
					//Alternate A-D lowered
					else if(specialBehavior==2){
						int nextState = toggleA;
						if(loweredState==toggleA){
							if(toggleB>-1)
								nextState = toggleB;
							else if(toggleC>-1)
								nextState = toggleC;
							else if(toggleD>-1)
								nextState = toggleD;
						}
						if(loweredState==toggleB){
							if(toggleC>-1)
								nextState = toggleC;
							else if(toggleD>-1)
								nextState = toggleD;
							else if(toggleA>-1)
								nextState = toggleA;
						}
						if(loweredState==toggleC){
							if(toggleD>-1)
								nextState = toggleD;
							else if(toggleA>-1)
								nextState = toggleA;
							else if(toggleB>-1)
								nextState = toggleB;
						}
						if(loweredState==toggleD){
							if(toggleA>-1)
								nextState = toggleA;
							else if(toggleB>-1)
								nextState = toggleB;
							else if(toggleC>-1)
								nextState = toggleC;
						}
						
						if(toggleA>-1){
							newState |= 1<<toggleA;
							newStateMask |= 1<<toggleA;
						}
						if(toggleB>-1){
							newState |= 1<<toggleB;
							newStateMask |= 1<<toggleB;
						}
						if(toggleC>-1){
							newState |= 1<<toggleC;
							newStateMask |= 1<<toggleC;
						}
						if(toggleD>-1){
							newState |= 1<<toggleD;
							newStateMask |= 1<<toggleD;
						}
						
						newState &= ~(1<<nextState);
					}
					//Toggle all
					else{
						if(toggleA>-1){
							if(!(lstate&(1<<toggleA)))
								newState |= 1<<toggleA;
							newStateMask |= 1<<toggleA;
						}
						if(toggleB>-1){
							if(!(lstate&(1<<toggleB)))
								newState |= 1<<toggleB;
							newStateMask |= 1<<toggleB;
						}
						if(toggleC>-1){
							if(!(lstate&(1<<toggleC)))
								newState |= 1<<toggleC;
							newStateMask |= 1<<toggleC;
						}
						if(toggleD>-1){
							if(!(lstate&(1<<toggleD)))
								newState |= 1<<toggleD;
							newStateMask |= 1<<toggleD;
						}
					}
					
					if(CRYSTALSWITCH_CAN_WALK_ON_TOP){
						if(!IsSideview()&&(linkColl&newState)){
							CrystalSwitch[CRSW_LINKONRAISED] = 1;
						}
					}
					
					int astate = (((lstate&0xFF)^newState)&newStateMask)<<8; //Find bits that have changed to determine which combos should animate
					
					lstate &= ~newStateMask; //Unset bits affected by new state
					lstate |= newState; //Combine new state with the current one
					
					lstate &= 0xFF; //Clear old animation data
					lstate |= astate; //Set new animation bits
					
					CrystalSwitch[CRSW_LSTATES+Game->GetCurLevel()] = lstate;
					
					CrystalSwitch[CRSW_ANIM] = CRYSTALSWITCH_RISINGCOMBOS*CRYSTALSWITCH_RISINGASPEED;
					strikeCooldown = 40;
				}
			}
			
			int switchColor = 0;
			if(loweredState>-1)
				switchColor = 4+loweredState*2;
			if(specialBehavior==1){
				if(lstate&(1<<toggleA))
					switchColor = 4+toggleA*2;
				else
					switchColor = 4+toggleA*2+1;
			}
			if(toggleCount>2){
				if(specialBehavior==0&&CRYSTALSWITCH_USE_BLANK_TRIGGER){
					if(lstate&(1<<toggleA))
						switchColor = 1;
					else
						switchColor = 0;
				} 
			}
			
			int switchCMB = CMB_CRYSTALSWITCH_TRIGGERS+switchColor;
			if(forceCombo){
				if(lstate&(1<<toggleA))
					switchCMB = forceCombo+1;
				else
					switchCMB = forceCombo;
			}
			
			if(CRYSTALSWITCH_USE_FFC_GRAPHICS)
				this->Data = switchCMB;
			else
				Screen->ComboD[pos] = switchCMB;
			
			if(strikeCooldown>0){
				Screen->FastCombo(2, ComboX(pos), ComboY(pos), 38590, 2, 128);
				strikeCooldown--;
			}
			Waitframe();
		}
	}
	bool CrystalSwitch_CheckCollision(ffc this, lweapon lastTrigger){
		bool excludedTypes[41];
		//Define all weapon types that can't hit the switch here
		excludedTypes[LW_CANEOFBYRNA] = true;
		excludedTypes[LW_BOMB] = true;
		excludedTypes[LW_SBOMB] = true;
		excludedTypes[LW_FIRE] = true;
		excludedTypes[LW_WHISTLE] = true;
		excludedTypes[LW_BAIT] = true;
		excludedTypes[LW_MAGIC] = true;
		excludedTypes[LW_WIND] = true;
		excludedTypes[LW_REFMAGIC] = true;
		excludedTypes[LW_REFFIREBALL] = true;
		excludedTypes[LW_SPARKLE] = true;
		excludedTypes[LW_FIRESPARKLE] = true;
		
		for(int i=Screen->NumLWeapons(); i>=1; i--){
			lweapon l = Screen->LoadLWeapon(i);
			if(l!=lastTrigger[0]){
				if(!excludedTypes[l->ID]&&l->CollDetection&&l->DeadState==WDS_ALIVE){
					if(Collision(this, l)){
						lastTrigger[0] = l;
						if(l->ID==LW_BRANG||l->ID==LW_HOOKSHOT)
							l->DeadState = WDS_BOUNCE;
						else if(l->ID==LW_ARROW)
							l->DeadState = WDS_ARROW;
						else if(l->ID==LW_BEAM)
							l->DeadState = WDS_BEAMSHARDS;
						else if(l->ID==LW_MAGIC||l->ID==LW_REFMAGIC||l->ID==LW_REFROCK||l->ID==LW_REFFIREBALL)
							l->DeadState = 0;
						return true;
					}
				}
			}
		}
	}
}

global script CrystalSwitch_Example{
	void run(){
		CrystalSwitch_Init();
		while(true){
			CrystalSwitch_Update();
			Waitdraw();
			Waitframe();
		}
	}
}

generic script LastHymnstoneGet{
	void run(){
		Game->PlayMIDI(0);
		Waitheal(32);
		Game->PlaySound(77);
		for(int i=0; i<16; ++i){
			Screen->Rectangle(7, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 64);
			if(i<2||i>=14)
				Screen->Rectangle(7, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 64);
			if(i<4||i>=12)
				Screen->Rectangle(7, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 128);
			Waitheal(1);
		}
		Waitheal(32);
		Game->PlaySound(77);
		for(int i=0; i<16; ++i){
			Screen->Rectangle(7, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 64);
			if(i<2||i>=14)
				Screen->Rectangle(7, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 64);
			if(i<4||i>=12)
				Screen->Rectangle(7, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 128);
			Waitheal(1);
		}
		Waitheal(8);
		Game->PlaySound(77);
		for(int i=0; i<16; ++i){
			Screen->Rectangle(7, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 64);
			if(i<2||i>=14)
				Screen->Rectangle(7, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 64);
			if(i<4||i>=12)
				Screen->Rectangle(7, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 128);
			Waitheal(1);
		}
		Waitheal(8);
		genericdata gd = Game->LoadGenericData(Game->GetGenericScript("HymnstoneWinscreen"));
		gd->RunFrozen();
		G[G_WONHYMNSTONEHUNT] = 1;
		Screen->Rectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
		Link->Warp(54, 0x75);
		Screen->Rectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
		Waitframe();
	}
	void Waitheal(int frames){
		for(int i=0; i<frames; ++i){
			if(Link->HP<1)
				Link->HP = 1;
			Waitframe();
		}
	}
}

generic script HymnstoneWinscreen{
	void run(){
		int timeF = (Game->Time%60L)*10000;
		int timeS = ((Game->Time/60)%60L)*10000;
		int timeM = ((Game->Time/60/60)%60L)*10000;
		int timeH = (Game->Time/60/60/60)*10000;
		
		for(int i=0; i<16; ++i){
			Screen->Rectangle(6, 0, 0, 255, 175, 0x71, 1, 0, 0, 0, true, 64);
			Waitframe();
		}
		for(int i=0; i<16; ++i){
			Screen->Rectangle(6, 0, 0, 255, 175, 0x77, 1, 0, 0, 0, true, 64);
			Waitframe();
		}
		for(int i=0; i<16; ++i){
			Screen->Rectangle(6, 0, 0, 255, 175, 0x77, 1, 0, 0, 0, true, 64);
			Screen->Rectangle(6, 0, 0, 255, 175, 0x77, 1, 0, 0, 0, true, 64);
			Waitframe();
		}
		for(int i=0; i<16; ++i){
			Screen->Rectangle(6, 0, 0, 255, 175, 0x77, 1, 0, 0, 0, true, 128);
			Waitframe();
		}
		for(int i=0; i<16; ++i){
			Screen->Rectangle(6, 0, 0, 255, 175, 0x78, 1, 0, 0, 0, true, 128);
			Waitframe();
		}
		for(int i=0; i<16; ++i){
			Screen->Rectangle(6, 0, 0, 255, 175, 0x79, 1, 0, 0, 0, true, 128);
			Waitframe();
		}
		for(int i=0; i<16; ++i){
			Screen->Rectangle(6, 0, 0, 255, 175, 0x95, 1, 0, 0, 0, true, 128);
			Waitframe();
		}
		Game->PlaySound(110);
		for(int i=0; i<96; ++i){
			Screen->Rectangle(6, 0, 0, 255, 175, 0x95, 1, 0, 0, 0, true, 128);
			Screen->DrawString(6, 128, 48, FONT_LISA, 0x01, -1, TF_CENTERED, "HYMNSTONE HUNT CLEAR!", 128, SHD_OUTLINED8, 0x0F);
			Waitframe();
		}
		Game->PlaySound(110);
		for(int i=0; i<96; ++i){
			Screen->Rectangle(6, 0, 0, 255, 175, 0x95, 1, 0, 0, 0, true, 128);
			Screen->DrawString(6, 128, 48, FONT_LISA, 0x01, -1, TF_CENTERED, "HYMNSTONE HUNT CLEAR!", 128, SHD_OUTLINED8, 0x0F);
			Screen->DrawString(6, 128, 72, FONT_LISA, 0x01, -1, TF_CENTERED, "FINAL TIME:", 128, SHD_OUTLINED8, 0x0F);
			Waitframe();
		}
		int tStr[32];
		sprintf(tStr, "%d:%02d:%02d.%02d", timeH, timeM, timeS, timeF);
		Game->PlaySound(110);
		for(int i=0; i<96; ++i){
			Screen->Rectangle(6, 0, 0, 255, 175, 0x95, 1, 0, 0, 0, true, 128);
			Screen->DrawString(6, 128, 48, FONT_LISA, 0x01, -1, TF_CENTERED, "HYMNSTONE HUNT CLEAR!", 128, SHD_OUTLINED8, 0x0F);
			Screen->DrawString(6, 128, 72, FONT_LISA, 0x01, -1, TF_CENTERED, "FINAL TIME:", 128, SHD_OUTLINED8, 0x0F);
			Screen->DrawString(6, 128, 88, FONT_GAIA, 0x01, -1, TF_CENTERED, tStr, 128, SHD_OUTLINED8, 0x0F);
			Waitframe();
		}
		int aTimer;
		while(!Link->PressA){
			Screen->Rectangle(6, 0, 0, 255, 175, 0x95, 1, 0, 0, 0, true, 128);
			Screen->DrawString(6, 128, 48, FONT_LISA, 0x01, -1, TF_CENTERED, "HYMNSTONE HUNT CLEAR!", 128, SHD_OUTLINED8, 0x0F);
			Screen->DrawString(6, 128, 72, FONT_LISA, 0x01, -1, TF_CENTERED, "FINAL TIME:", 128, SHD_OUTLINED8, 0x0F);
			Screen->DrawString(6, 128, 88, FONT_GAIA, 0x01, -1, TF_CENTERED, tStr, 128, SHD_OUTLINED8, 0x0F);
			if(aTimer<16)
				Screen->DrawString(6, 128, 112, FONT_SUBSCREEN3, 0x01, -1, TF_CENTERED, "PRESS A", 128, SHD_OUTLINED8, 0x0F);
			aTimer = (aTimer+1)%32;
			Waitframe();
		}
		for(int i=0; i<32; ++i){
			Screen->Rectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
			Waitframe();
		}
	}
}