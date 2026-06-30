enum {STMD_EMOTE, STMD_EMOTETIME, STMD_CHAR};

int LoadString(int buf, int whichString, int cmb, int til, int cs, int flags, int flip, ffc this){
	LoadString(buf, whichString, 0, cmb, til, cs, flags, flip, this);
}

int LoadString(int buf, int whichString, int metadata, int cmb, int til, int cs, int flags, int flip, ffc this){
	switch(whichString){
		default:
			CopyStringToBuffer(buf, "I AM ERROR. Please report this error string if you encounter it.");
			break;
	}
	return 0;
}

void CopyStringToBuffer(int buf, int str){
	int size = Min(SizeOfArray(buf), SizeOfArray(str));
	for(int i=0; i<size; ++i){
		buf[i] = str[i];
		if(str[i]==0)
			break;
	}
}

void CopyStringToBuffer(int buf, int str, int charID, int emoteID, int metadata){
	++G[G_CONVOLENGTH]; //Find this string's position in the conversation based on order this function is called, also records the total conversation length
	if(G[G_CONVOINCREMENTER]==G[G_CONVOLENGTH]){ //If this is the current string, copy it over
		CopyStringToBuffer(buf, str);
		metadata[STMD_CHAR] = charID;
		metadata[STMD_EMOTE] = emoteID;
	}
}
	
const int SCHAR_NULL = 0;
const int SCHAR_ASHER = 1;
const int SCHAR_TORRIN = 2;
const int SCHAR_KAYLANI = 3;
const int SCHAR_SELET = 4;
const int SCHAR_HENCHMAN = 5;
const int SCHAR_IRIS = 6;
const int SCHAR_TIM = 7;
const int SCHAR_GINA = 8;
const int SCHAR_DRAKE = 9;
const int SCHAR_BOBBY = 10;
const int SCHAR_KELLY = 11;
const int SCHAR_MANBOOK = 12;
const int SCHAR_RICHMAN = 13;
const int SCHAR_RICHWOMAN = 14;
const int SCHAR_BIF = 15;
const int SCHAR_WOMANGREENSKIRTOUTFIT2 = 16;
const int SCHAR_BOYGREENSHORTS = 17;
const int SCHAR_WOMANREDSKIRTOUTFIT1 = 18;
const int SCHAR_MANREDHAIRGREENSHIRT = 19;
const int SCHAR_PORTMASTER = 20;
const int SCHAR_KENJA = 21;
const int SCHAR_MANBLONDHAIRGREENPANTS = 22;
const int SCHAR_MISTY = 23;
const int SCHAR_WOMANWHITEHAIR = 24;
const int SCHAR_WOMANYELLOWHAIRORANGESKIRT = 25;
const int SCHAR_MERCHANT = 26;
const int SCHAR_MANORANGEPANTS = 27;
const int SCHAR_WOMANBLACKHAIRYELLOWSKIRT = 28;
const int SCHAR_BOOKSTOREOWNER = 29;
const int SCHAR_KAVERIBLOND = 30;
const int SCHAR_BOYBLUESHORTS = 31;
const int SCHAR_MANREDSHORTS = 32;
const int SCHAR_TOTEM = 33;
const int SCHAR_ZEKE = 34;
const int SCHAR_CAIMAN = 35;
const int SCHAR_TERRY = 36;
const int SCHAR_SKAI = 37;
const int SCHAR_DARI = 38;
const int SCHAR_SOREN = 39;
const int SCHAR_PHIN = 40;
const int SCHAR_MANCH = 41;
const int SCHAR_TALCAY = 42;
const int SCHAR_BOY = 43;
const int SCHAR_LAVERNE = 44;
const int SCHAR_TRUF = 45;
const int SCHAR_TRUF2 = 46;
const int SCHAR_CULTISTS = 47;
const int SCHAR_CARTOGRAPHER = 48;
const int SCHAR_SOLARCULTIST = 49;
const int SCHAR_LUNARCULTIST = 50;
const int SCHAR_STELLARCULTIST = 51;
const int SCHAR_UNMASKEDCULTIST = 52;
const int SCHAR_MICAH = 53;
const int SCHAR_NAMAUH = 54;
const int SCHAR_NIMO = 55;
const int SCHAR_FAB = 56;
const int SCHAR_LILAH = 57;
const int SCHAR_MADDA = 58;
const int SCHAR_NELL = 59;
const int SCHAR_ALLIE = 60;
const int SCHAR_BAND = 61;
const int SCHAR_DEN = 62;
const int SCHAR_MORT = 63;
const int SCHAR_HANA = 64;
const int SCHAR_SIYED = 65;
const int SCHAR_TULANE = 66;
const int SCHAR_PIRATE = 67;
const int SCHAR_MOM = 68;
const int SCHAR_UNKNOWN = 69;
const int SCHAR_TORRINYOUNG = 70;
const int SCHAR_ASHERARMOR = 71;
const int SCHAR_SELETNONAME = 72;
const int SCHAR_CAPTAIN = 73;
const int SCHAR_WINNO = 74;
const int SCHAR_GRANDMA = 74;
const int SCHAR_ZARATH = 75;
const int SCHAR_POTIONLADY = 76;
const int SCHAR_SORENPANTS = 77;
const int SCHAR_NIGHTMARCHER = 78;
const int SCHAR_CHASE = 79;
const int SCHAR_BANE = 80;
const int SCHAR_ESAN = 81;
const int SCHAR_MOOSH = 82;
const int SCHAR_RUSS = 83;
const int SCHAR_MICAH2 = 84;
const int SCHAR_MICAH3 = 85;
const int SCHAR_EVAN = 86;
const int SCHAR_BOOK = 87;

const int EMOTE_NORMAL = 0;
const int EMOTE_ELLIPSES = 1;
const int EMOTE_EXCLAMATION = 2;
const int EMOTE_QUESTION = 3;
const int EMOTE_ANGRY = 4;
const int EMOTE_SAD = 5;
const int EMOTE_SADISTIC = 6;
const int EMOTE_HAPPY = 7;
const int EMOTE_SWEAT = 8;
const int EMOTE_FURIOUS = 9;
const int EMOTE_IDEA = 10;
const int EMOTE_EMBARRASSED = 11;
const int EMOTE_SURPRISED = 12;
const int EMOTE_DISMAYED = 13;
const int EMOTE_WINK = 14;
const int EMOTE_EYEBROWRAISED = 15;

void GetPortraitNameAndTile(int whichChar){
	G[G_PORTRAITTIL] = 0;
}

//Get a banter string based on the current DMap
void LoadDMapBanter(int whichDMap){
	G[G_MAXBANTER] = 0;
	AddDMapBanter(StoryBanter());
	switch(whichDMap){
		case 0: //Omaka
			if(Link->Item[I_KAYLANI]){
				AddDMapBanter(100);
			}
			else{
				AddDMapBanter(200);
			}
			break;
	}
}
void AddDMapBanter(int which){
	switch(G[G_MAXBANTER]){
		case 0:
			G[G_BANTER1] = which;
			break;
		case 1:
			G[G_BANTER2] = which;
			break;
		case 2:
			G[G_BANTER3] = which;
			break;
		case 3:
			G[G_BANTER4] = which;
			break;
		case 4:
			G[G_BANTER5] = which;
			break;
		case 5:
			G[G_BANTER6] = which;
			break;
	}
	++G[G_MAXBANTER];
}
int GetDMapBanter(int which){
	switch(which){
		case 0:
			return G[G_BANTER1];
		case 1:
			return G[G_BANTER2];
		case 2:
			return G[G_BANTER3];
		case 3:
			return G[G_BANTER4];
		case 4:
			return G[G_BANTER5];
		case 5:
			return G[G_BANTER6];
	}
}
int GetNextDMapBanter(){
	for(int i=0; i<G[G_MAXBANTER]+1; ++i){
		if(G[G_BANTERCYCLE]>=G[G_MAXBANTER]){
			G[G_BANTERCYCLE] = 0;
		}
		int banter = GetDMapBanter(G[G_BANTERCYCLE]);
		++G[G_BANTERCYCLE];
		if(LoreTracking[LT_BANTER+banter]==0||i==G[G_MAXBANTER]){
			return banter;
		}
	}
	if(G[G_BANTERCYCLE]>=G[G_MAXBANTER]){
		G[G_BANTERCYCLE] = 0;
	}
	int banter = GetDMapBanter(G[G_BANTERCYCLE]);
	++G[G_BANTERCYCLE];
	return banter;
}


//Get a banter string based on story progress
int StoryBanter(){
	switch(Game->Counter[CR_STORYFLAG]){
		case 0:
			return 0;
		case 1:
			return 1;
		case 2...99:
			return 2;
		default:
			return 0;
	}
}

void LoadBanter(int strings, int whichString){
	G[G_BANTERLENGTH] = 0;
	G[G_BANTERSTRINGPOS] = 0;
	G[G_BANTERID] = whichString;
	switch(whichString){
		default:
			break;
	}
}

void BanterString(int strings, int str, int charID, int emoteID){
	int buf = strings[2+G[G_BANTERLENGTH]*3];
	CopyStringToBuffer(buf, str);
	strings[0+G[G_BANTERLENGTH]*3] = charID;
	strings[1+G[G_BANTERLENGTH]*3] = emoteID;
	++G[G_BANTERLENGTH]; //Find this string's position in the conversation based on order this function is called, also records the total conversation length
}

void BestiaryName(int buf, int id, bool shorten){
	if(LoreTracking[LT_ENEMIES+id]==0)
		id = -1;
}

void BestiaryDescription(int buf, int id){
	if(LoreTracking[LT_ENEMIES+id]==0)
		id = -1;
}

void BestiaryTiles(int id){
	int blinkOffset = 0;
	if((G[G_ANIM]%360)>=348){
		if(G[G_ANIM]%360<352)
			blinkOffset = 1;
		else if(G[G_ANIM]%360<356)
			blinkOffset = 2;
		else
			blinkOffset = 1;
	}
	if(LoreTracking[LT_ENEMIES+id]==0)
		id = -1;
	switch(id){
		case 22: //Red Octo
			SetBestiaryTile(3484, 1, 1, 8);
			break;
		case 23: //Blue Octo
			SetBestiaryTile(3484, 1, 1, 7);
			break;
		case 26: //Crab
			SetBestiaryTile(9566, 1, 1, 8);
			break;
		case 27:
			SetBestiaryTile(9574, 1, 1, 7);
			break;
		case 137:
			SetBestiaryTile(9594, 1, 1, 7);
			break;
		case 45: //Ratang
			SetBestiaryTile(3724, 1, 1, 8);
			break;
		case 46:
			SetBestiaryTile(3724, 1, 1, 7);
			break;
		case 136:
			SetBestiaryTile(8484, 1, 1, 8);
			break;
		case 221:
			SetBestiaryTile(9784, 1, 1, 7);
			break;
		case 38: //Keese
			SetBestiaryTile(1584, 1, 1, 7);
			break;
		case 106: //Bat
			SetBestiaryTile(4884, 1, 1, 11);
			break;
		case 189: //Spider
			SetBestiaryTile(10060, 1, 1, 11);
			break;
		case 194:
			SetBestiaryTile(10100, 1, 1, 11);
			break;
		case 187: //Rat
			SetBestiaryTile(10024, 1, 1, 11);
			break;
		case 44: //Rope
			SetBestiaryTile(2430, 1, 1, 8);
			break;
		case 80:
			SetBestiaryTile(2450, 1, 1, 7);
			break;
		case 190:
			SetBestiaryTile(10089, 1, 1, 11);
			break;	
		case 223:
			SetBestiaryTile(10150, 1, 1, 11);
			break;
		case 25: //Tektite
			SetBestiaryTile(2384, 1, 1, 7);
			break;
		case 24:
			SetBestiaryTile(2344, 1, 1, 8);
			break;
		case 222:
			SetBestiaryTile(9860, 1, 1, 8);
			break;
		case 138: //Dragon
			SetBestiaryTile(8604, 1, 1, 8);
			break;
		case 139:
			SetBestiaryTile(8664, 1, 1, 8);
			break;
		case 224: //Puffer
			SetBestiaryTile(107396, 1, 1, 8);
			break;
		case 225:
			SetBestiaryTile(107136, 1, 1, 8);
			break;
		case 226:
			SetBestiaryTile(107196, 1, 1, 9);
			break;
		case 237: //Hopmaw
			SetBestiaryTile(7748, 1, 1, 8);
			break;
		case 238:
			SetBestiaryTile(7748, 1, 1, 7);
			break;
		case 239: //Beehive
			SetBestiaryTile(7766, 1, 1, 8);
			break;
		case 195: //Piranha
			SetBestiaryTile(107206, 2, 2, 7);
			break;
		case 33: //Zora
			SetBestiaryTile(2484, 1, 1, 9);
			break;
		case 42: //Gel
			SetBestiaryTile(1804, 1, 1, 7);
			break;
		case 43:
			SetBestiaryTile(1784, 1, 1, 7);
			break;
		case 196: //Spiny Beetle
			SetBestiaryTile(7640, 1, 1, 11);
			break;
		case 198: //Cursetellation
			SetBestiaryTile(7677+blinkOffset, 1, 1, 8);
			break;
		case 197:
			SetBestiaryTile(7657+blinkOffset, 1, 1, 7);
			break;
		case 212:
			SetBestiaryTile(7697+blinkOffset, 1, 1, 9);
			break;
		case 178: //Bomb
			SetBestiaryTile(9940, 1, 1, 8);
			break;
		case 179:
			SetBestiaryTile(9980, 1, 1, 7);
			break;
		case 199: //Cannon
			SetBestiaryTile(7700, 2, 2, 11);
			break;
		case 54: //Mummy
			SetBestiaryTile(107340, 1, 2, 7);
			break;
		case 220:
			SetBestiaryTile(107346, 1, 2, 11);
			break;
		case 210: //Armos Knight
			SetBestiaryTile(7360, 1, 2, 11);
			break;
		case 229: //Armos Helmet
			SetBestiaryTile(7361, 1, 1, 11);
			break;
		case 35: //Ghost
			SetBestiaryTile(2200, 1, 1, 7);
			break;
		case 209: //Cosmic Spook
			SetBestiaryTile(106940, 1, 2, 7);
			break;
		case 227: //Nightmarcher
			SetBestiaryTile(106300, 1, 2, 11);
			break;
		case 232: //Suneater
			SetBestiaryTile(7733, 1, 1, 8);
			break;
		case 233: //Mooneater
			SetBestiaryTile(7729, 1, 1, 7);
			break;
		case 234: //Stareater
			SetBestiaryTile(7733, 1, 1, 9);
			break;
		case 56: //Wizard
			SetBestiaryTile(10264, 1, 2, 8);
			break;
		case 57:
			SetBestiaryTile(10304, 1, 2, 7);
			break;
		case 153:
			SetBestiaryTile(10344, 1, 2, 9);
			break;
		case 180: //Crablike
			SetBestiaryTile(9424, 1, 1, 0);
			break;
		case 181:
			SetBestiaryTile(9464, 1, 1, 0);
			break;
		case 182:
			SetBestiaryTile(9504, 1, 1, 0);
			break;
		case 183: //Startouched
			SetBestiaryTile(9664, 1, 2, 0);
			break;
		case 184:
			SetBestiaryTile(9704, 1, 2, 0);
			break;
		case 185:
			SetBestiaryTile(9744, 1, 2, 0);
			break;
		case 203: //Pillar
			SetBestiaryTile(7800, 2, 3, 0);
			break;
		case 204:
			SetBestiaryTile(7860, 2, 3, 0);
			break;
		case 205:
			SetBestiaryTile(7920, 2, 3, 0);
			break;
		case 191:
			SetBestiaryTile(106340, 1, 2, 8);
			break;
		case 192:
			SetBestiaryTile(106380, 1, 2, 7);
			break;
		case 193:
			SetBestiaryTile(106500, 1, 2, 7);
			break;
		case 231:
			SetBestiaryTile(111360, 1, 2, 7);
			break;
		case 186: //Cultist Mask
			SetBestiaryTile(106600, 1, 2, 11);
			break;
		case 188:
			SetBestiaryTile(106640, 1, 2, 11);
			break;
		case 211:
			SetBestiaryTile(106680, 1, 2, 11);
			break;
		case 206: //Cultist Spellbearer
			SetBestiaryTile(106600, 1, 2, 11);
			break;
		case 207:
			SetBestiaryTile(106640, 1, 2, 11);
			break;
		case 208:
			SetBestiaryTile(106680, 1, 2, 11);
			break;
		case 213: //Miniboss Golem
			SetBestiaryTile(8068, 2, 2, 11);
			break;
		case 214:
			SetBestiaryTile(8148, 2, 2, 11);
			break;
		case 215:
			SetBestiaryTile(8228, 2, 2, 11);
			break;
		case 244:
			SetBestiaryTile(60338, 2, 2, 11);
			break;
		case 218: //Captain Shelrond
			SetBestiaryTile(106540, 1, 2, 11);
			break;
		case 216: //Diggernaut
			SetBestiaryTile(79056, 4, 3, 11);
			break;
		case 242: //Esan
			SetBestiaryTile(111140, 1, 2, 11);
			break;
		case 217: //Selet
			SetBestiaryTile(109200, 1, 2, 11);
			break;
		case 236: //Selet Transformed
			SetBestiaryTile(117196, 4, 3, 11);
			break;
		case 251: //Chase
			SetBestiaryTile(111580, 1, 2, 11);
			break;
		default:
			SetBestiaryTile(0, 1, 1, 8);
			break;
	}
}
void SetBestiaryTile(int til, int w, int h, int cs){
	G[G_BESTIARY_ENEMYTILE] = til;
	G[G_BESTIARY_ENEMYCSET] = cs;
	G[G_BESTIARY_ENEMYWIDTH] = w;
	G[G_BESTIARY_ENEMYHEIGHT] = h;
}

void BestiaryDefenses(int id){
	const int PHYSICAL 	= 00000001b;
	const int FIRE 		= 00000010b;
	const int BOMB 		= 00000100b;
	const int SOLAR 	= 00001000b;
	const int LUNAR 	= 00010000b;
		  int STELLAR 	= 00100000b;
	const int GAUNTLET 	= 01000000b;
	
	if(Game->Counter[CR_STORYFLAG]<SFLAG_ASHERRESCUED)
		STELLAR = 0;
	
	G[G_BESTIARY_ENEMYRESIST] = 0;
	G[G_BESTIARY_ENEMYWEAKNESS] = 0;
	switch(id){
		//Octo
		case 20:
		case 21:
		case 22:
		case 23:
			G[G_BESTIARY_ENEMYWEAKNESS] = FIRE;
			break;
		//Crab
		case 26:
		case 27:
			G[G_BESTIARY_ENEMYWEAKNESS] = FIRE|BOMB;
			break;
		//Solar crab
		case 137:
			G[G_BESTIARY_ENEMYRESIST] = SOLAR;
			G[G_BESTIARY_ENEMYWEAKNESS] = FIRE|BOMB|LUNAR|GAUNTLET;
			break;
		//Ratang
		case 45:
		case 46:
		case 136:
			G[G_BESTIARY_ENEMYRESIST] = LUNAR;
			break;
		//Lunatic ratang
		case 221:
			G[G_BESTIARY_ENEMYRESIST] = LUNAR;
			G[G_BESTIARY_ENEMYWEAKNESS] = SOLAR|GAUNTLET;
			break;
		//Ropes
		case 44:
		case 80:
			G[G_BESTIARY_ENEMYWEAKNESS] = LUNAR;
			break;
		case 190:
			G[G_BESTIARY_ENEMYRESIST] = FIRE;
			G[G_BESTIARY_ENEMYWEAKNESS] = LUNAR;
			break;
		//Ossified serpent
		case 223:
			G[G_BESTIARY_ENEMYRESIST] = FIRE|STELLAR;
			G[G_BESTIARY_ENEMYWEAKNESS] = LUNAR;
			break;
		//Strider
		case 24:
		case 25:
			G[G_BESTIARY_ENEMYRESIST] = FIRE;
			break;
		//Sun strider
		case 222:
			G[G_BESTIARY_ENEMYRESIST] = SOLAR|FIRE;
			G[G_BESTIARY_ENEMYWEAKNESS] = LUNAR|BOMB|GAUNTLET;
			break;
		//Dimlit
		case 138:
		case 139:
			G[G_BESTIARY_ENEMYRESIST] = FIRE;
			break;
		//Puffer
		case 225:
			G[G_BESTIARY_ENEMYWEAKNESS] = BOMB;
			break;
		//Fire puffer
		case 224:
			G[G_BESTIARY_ENEMYRESIST] = FIRE;
			G[G_BESTIARY_ENEMYWEAKNESS] = BOMB;
			break;
		//Stellar puffer
		case 226:
			G[G_BESTIARY_ENEMYRESIST] = PHYSICAL|SOLAR|LUNAR|STELLAR;
			G[G_BESTIARY_ENEMYWEAKNESS] = BOMB;
			break;
		//Hopmaw
		case 237:
			G[G_BESTIARY_ENEMYWEAKNESS] = FIRE;
			break;
		case 238:
			G[G_BESTIARY_ENEMYWEAKNESS] = FIRE;
			break;
		//Beehive
		case 239:
			G[G_BESTIARY_ENEMYWEAKNESS] = FIRE|BOMB;
			break;
		//Zolo
		case 33:
			G[G_BESTIARY_ENEMYRESIST] = FIRE|LUNAR;
			break;
		//Droplet
		case 42:
		case 43:
			G[G_BESTIARY_ENEMYRESIST] = SOLAR;
			G[G_BESTIARY_ENEMYWEAKNESS] = FIRE;
			break;
		//Spiny beetle
		case 196:
			G[G_BESTIARY_ENEMYRESIST] = SOLAR|LUNAR|STELLAR|FIRE|BOMB;
			break;
		//Cursetellation (Solar)
		case 198:
			G[G_BESTIARY_ENEMYRESIST] = SOLAR|FIRE;
			G[G_BESTIARY_ENEMYWEAKNESS] = BOMB|GAUNTLET;
			break;
		//Cursetellation (Lunar)
		case 197:
			G[G_BESTIARY_ENEMYRESIST] = LUNAR|FIRE;
			G[G_BESTIARY_ENEMYWEAKNESS] = BOMB|GAUNTLET;
			break;
		//Cursetellation (Stellar)
		case 212:
			G[G_BESTIARY_ENEMYRESIST] = STELLAR|FIRE;
			G[G_BESTIARY_ENEMYWEAKNESS] = BOMB;
			break;
		//Boomba
		case 178:
		case 179:
			G[G_BESTIARY_ENEMYRESIST] = PHYSICAL;
			G[G_BESTIARY_ENEMYWEAKNESS] = BOMB|FIRE;
			break;
		//Cannon
		case 199: 
			G[G_BESTIARY_ENEMYRESIST] = PHYSICAL|FIRE|SOLAR|LUNAR|STELLAR;
			G[G_BESTIARY_ENEMYWEAKNESS] = BOMB;
			break;
		//Mummy
		case 54:
			G[G_BESTIARY_ENEMYRESIST] = SOLAR|LUNAR;
			G[G_BESTIARY_ENEMYWEAKNESS] = STELLAR|FIRE;
			break;
		//Blood Mummy
		case 220:
			G[G_BESTIARY_ENEMYRESIST] = SOLAR|LUNAR|FIRE;
			G[G_BESTIARY_ENEMYWEAKNESS] = STELLAR;
			break;
		//Stone Guardian
		case 220:
			G[G_BESTIARY_ENEMYRESIST] = SOLAR|LUNAR|STELLAR|FIRE;
			G[G_BESTIARY_ENEMYWEAKNESS] = BOMB;
			break;
		//Ghost
		case 35:
			G[G_BESTIARY_ENEMYRESIST] = PHYSICAL|FIRE|BOMB;
			G[G_BESTIARY_ENEMYWEAKNESS] = STELLAR;
			break;
		//Cosmic spook
		case 209:
			G[G_BESTIARY_ENEMYRESIST] = SOLAR|LUNAR|STELLAR;
			break;
		//Nightmarcher
		case 227:
			G[G_BESTIARY_ENEMYRESIST] = PHYSICAL|SOLAR|LUNAR|FIRE;
			G[G_BESTIARY_ENEMYWEAKNESS] = STELLAR;
			break;
		//Suneater
		case 232:
			G[G_BESTIARY_ENEMYRESIST] = PHYSICAL|SOLAR;
			G[G_BESTIARY_ENEMYWEAKNESS] = LUNAR|STELLAR;
			break;
		//Mooneater
		case 233:
			G[G_BESTIARY_ENEMYRESIST] = PHYSICAL|LUNAR;
			G[G_BESTIARY_ENEMYWEAKNESS] = SOLAR|STELLAR;
			break;
		//Stareater
		case 234:
			G[G_BESTIARY_ENEMYRESIST] = PHYSICAL|STELLAR;
			G[G_BESTIARY_ENEMYWEAKNESS] = SOLAR|LUNAR;
			break;
		//Solar Wizard
		case 56:
			G[G_BESTIARY_ENEMYRESIST] = SOLAR;
			G[G_BESTIARY_ENEMYWEAKNESS] = STELLAR;
			break;
		//Lunar Wizard
		case 57:
			G[G_BESTIARY_ENEMYRESIST] = LUNAR;
			G[G_BESTIARY_ENEMYWEAKNESS] = STELLAR;
			break;
		//Solar Elementals
		case 180:
		case 183:
			G[G_BESTIARY_ENEMYWEAKNESS] |= GAUNTLET;
		case 203:
			G[G_BESTIARY_ENEMYRESIST] = SOLAR|FIRE;
			G[G_BESTIARY_ENEMYWEAKNESS] |= LUNAR|BOMB;
			break;
		//Lunar Elementals
		case 181:
		case 184:
			G[G_BESTIARY_ENEMYWEAKNESS] |= GAUNTLET;
		case 204:
			G[G_BESTIARY_ENEMYRESIST] = LUNAR|FIRE;
			G[G_BESTIARY_ENEMYWEAKNESS] |= SOLAR|BOMB;
			break;
		//Stellar Elementals
		case 182:
		case 185:
		case 205:
			G[G_BESTIARY_ENEMYRESIST] = STELLAR|FIRE;
			G[G_BESTIARY_ENEMYWEAKNESS] = SOLAR|LUNAR|BOMB;
			break;
		//Solar Golem
		case 213:
			G[G_BESTIARY_ENEMYRESIST] = SOLAR|FIRE;
			break;
		//Lunar Golem
		case 214:
			G[G_BESTIARY_ENEMYRESIST] = LUNAR|FIRE;
			break;
		//Stellar Golem
		case 215:
			G[G_BESTIARY_ENEMYRESIST] = STELLAR|FIRE;
			break;
		//Fusion Golem
		case 244:
			G[G_BESTIARY_ENEMYRESIST] = FIRE;
			break;
		//Bolide Borer
		case 216:
			G[G_BESTIARY_ENEMYRESIST] = SOLAR|LUNAR|FIRE;
			G[G_BESTIARY_ENEMYWEAKNESS] = BOMB;
			break;
		//Nightmare Selet
		case 236:
			G[G_BESTIARY_ENEMYWEAKNESS] = BOMB;
			break;
		//Chase
		case 251:
			G[G_BESTIARY_ENEMYRESIST] = SOLAR|STELLAR;
			break;
	}
}

enum{
	LOC_PUNA,
	LOC_OMAKA,
	LOC_PALA,
	LOC_WAREHOUSE,
	LOC_KAWI,
	LOC_PIRATE,
	LOC_MALKA,
	LOC_JUNGLE,
	LOC_HILLSIDE,
	LOC_LAVAFLOWS,
	LOC_JUNGLECAVE,
	LOC_TEMPLEOUTSIDE,
	LOC_JUNGLETEMPLE,
	LOC_HOKU,
	LOC_ALII,
	LOC_SHOALS,
	LOC_MINE,
	LOC_MANOR,
	LOC_CATACOMBS,
	LOC_OBSERVATORY,
	LOC_KAWAIHAE,
	LOC_KUKULU,
	LOC_PIRATE2,
	LOC_KIKALA,
	LOC_LEIPAI,
	LOC_TULANE,
	LOC_CARN,
	LOC_PYRAMID,
	LOC_MIRAGE,
	LOC_MUSHRUSH,
	LOC_SILVER,
	LOC_PONI,
	LOC_LAKE,
	LOC_MIST,
	
	LOC_SIZE
};

void LocationName(int buf, int id){

}

void LocationDescription(int buf, int id){

}

void LocationScreenPreview(int id){

}
void LocationConfigureScreenPreview(int dmap, int scrn, int x, int y){
	dmapdata curDMap = Game->LoadDMapData(Game->GetCurDMap());
	dmapdata targetDMap = Game->LoadDMapData(dmap);
	
	DayNight_UpdateDMapPalette(dmap);
	if(dmap==Game->GetCurDMap())
		curDMap->Palette = G[G_SUBSCREENOPENDMAPPALETTE];
	else
		curDMap->Palette = targetDMap->Palette;
	G[G_LOCATIONSUB_MAP] = Game->DMapMap[dmap];
	G[G_LOCATIONSUB_SCREEN] = scrn;
	G[G_LOCATIONSUB_X] = x;
	G[G_LOCATIONSUB_Y] = y;
	G[G_LOCATIONSUB_FOGTILE] = 0;
	if(dmap==45)
		G[G_LOCATIONSUB_FOGTILE] = 44521;
	else if(dmap==52)
		G[G_LOCATIONSUB_FOGTILE] = 44804;
		
}

//Get the main DMap for each location
int LocationDMap(int loc){
	switch(loc){
		case LOC_PUNA:
			return 1;
		case LOC_OMAKA:
			return 0;
		case LOC_PALA:
			return 2;
		case LOC_WAREHOUSE:
			return 9;
		case LOC_MANOR:
			return 24;
		case LOC_CATACOMBS:
			return 25;
		case LOC_KAWI:
			return 6;
		case LOC_PIRATE:
			return 16;
		case LOC_MALKA:
			return 26;
		case LOC_SHOALS:
			return 14;
		case LOC_MINE:
			return 17;
		case LOC_JUNGLE:
			return 10;
		case LOC_HILLSIDE:
			return 11;
		case LOC_LAVAFLOWS:
			return 12;
		case LOC_JUNGLECAVE:
			return 62;
		case LOC_HOKU:
			return 28;
		case LOC_TEMPLEOUTSIDE:
			return 36;
		case LOC_JUNGLETEMPLE:
			return 37;
		case LOC_ALII:
			return 20;
		case LOC_OBSERVATORY:
			return 23;
		case LOC_PONI:
			return 49;
		case LOC_LAKE:
			return 52;
		case LOC_MIST:
			return 53;
		case LOC_KAWAIHAE:
			return 30;
		case LOC_KUKULU:
			return 58;
		case LOC_PIRATE2:
			return 60;
		case LOC_KIKALA:
			return 27;
		case LOC_LEIPAI:
			return 33;
		case LOC_TULANE:
			return 43;
		case LOC_CARN:
			return 38;
		case LOC_PYRAMID:
			return 73;
		case LOC_MIRAGE:
			return 45;
		case LOC_MUSHRUSH:
			return 75;
		case LOC_SILVER:
			return 40;
	}
}

int DMapLocation(int dmap){
	switch(dmap){
		case 0:
		case 7:
			return LOC_OMAKA;
		case 1:
		case 15:
			return LOC_PUNA;
		case 2:
		case 3:
		case 4:
		case 5:
			return LOC_PALA;
		case 9:
			return LOC_WAREHOUSE;
		case 6:
		case 8:
			return LOC_KAWI;
		case 16:
			return LOC_PIRATE;
		case 26:
		case 31:
			return LOC_MALKA;
		case 10:
			return LOC_JUNGLE;
		case 11:
			return LOC_HILLSIDE;
		case 12:
		case 13:
			return LOC_LAVAFLOWS;
		case 62:
			return LOC_JUNGLECAVE;
		case 36:
			return LOC_TEMPLEOUTSIDE;
		case 37:
			return LOC_JUNGLETEMPLE;
		case 28:
		case 32:
			return LOC_HOKU; 
		case 18:
		case 19:
		case 20:
			return LOC_ALII;
		case 14:
		case 22:
			return LOC_SHOALS;
		case 17:
		case 21:
			return LOC_MINE;
		case 24:
			return LOC_MANOR;
		case 25:
			return LOC_CATACOMBS;
		case 23:
		case 66:
		case 70:
		case 71:
			return LOC_OBSERVATORY;
		case 30:
			return LOC_KAWAIHAE;
		case 27:
			return LOC_KIKALA;
		case 33:
		case 34:
		case 35:
			return LOC_LEIPAI;
		case 43:
		case 44:
			return LOC_TULANE;
		case 38:
		case 39:
		case 42:
			return LOC_CARN;
		case 73:
			return LOC_PYRAMID;
		case 45:
		case 46:
			return LOC_MIRAGE;
		case 75:
			return LOC_MUSHRUSH;
		case 40:
		case 41:
		case 72:
			return LOC_SILVER;
		case 49:
		case 50:
		case 51:
			return LOC_PONI;
		case 52:
			return LOC_LAKE;
		case 53:
		case 55:
			return LOC_MIST;
		case 58:
		case 59:
			 return LOC_KUKULU;
		case 60:
			 return LOC_PIRATE2;
	}
	return -1;
}

enum{
	QST_IRIS,
	QST_TERRY,
	QST_PIRATE,
	QST_GOLEM,
	QST_PLANT,
	QST_VOLCANO,
	QST_NIGHTMARCHER,
	QST_CULTIST,
	QST_SOREN,
	QST_HORIZON,
	QST_HELPER
};

void SidequestName(int buf, int id){
	int progress = SidequestProgress(id);
}

int SidequestProgress(int id){
	switch(id){
		case QST_IRIS:
			return Game->Counter[CR_ASHERSIDEQUEST];
			break;
		case QST_TERRY:
			if(Game->Counter[CR_TORRINSIDEQUEST]==10)
				return 0;
			return Game->Counter[CR_TORRINSIDEQUEST];
			break;
		case QST_PIRATE:
			if(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_12) //Cleared the quest
				return 3;
			if(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_11) //Found Shelrond
				return 2;
			if(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_10) //Got quest
				return 1;
			break;
		case QST_GOLEM:
			return Game->Counter[CR_GOLEMSIDEQUEST];
			break;
		case QST_PLANT:
			if(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_2) //Gave the plant
				return 4;
			if(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_1) //Found the plant
				return 3;
			if(LoreTracking[LT_LOCATIONS+LOC_JUNGLECAVE])
				return 2;
			if(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_0) //Met Laverne
				return 1;
			break;
		case QST_VOLCANO:
			if(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_4) //Turned in necklace
				return 3;
			if(Link->Item[207]) //Has necklace
				return 2;
			if(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_3) //Met Truf
				return 1;
			break;
		case QST_NIGHTMARCHER:
			return Game->Counter[CR_NIGHTMARCHERQUEST];
			break;
		case QST_CULTIST:
			switch(Game->Counter[CR_CULTISTQUEST]){
				case 3:
				case 4:
					return 3;
			}
			return Game->Counter[CR_CULTISTQUEST];
			break;
		case QST_SOREN:
			switch(Game->Counter[CR_MISCSIDEQUEST]){
				case 1:
				case 2:
					return 1;
				case 3:
				case 4:
					return 3;
			}
			return Game->Counter[CR_MISCSIDEQUEST];
		case QST_HORIZON:
			if(Game->Counter[CR_CHASEQUEST]<6){
				return Game->Counter[CR_CHASEQUEST];
			}
			else{
				if(Game->Counter[CR_CHASEQUEST]==9)
					return 10;
				if(Game->Counter[CR_CHASEQUEST]==8)
					return 9;
				if(Game->Counter[CR_CHASEQUEST]==7)
					return 8;
				if(Game->Counter[CR_TOTALHYMNSTONES]>=100)
					return 7;
				else
					return 6;
			}
			break;
		case QST_HELPER:
			return Game->Counter[CR_HELPERQUEST];
			break;
		default:
			return 99;
			break;
	}
}
int SidequestMaxProgress(int id){
	switch(id){
		case QST_IRIS:
			return 4;
			break;
		case QST_TERRY:
			return 4;
			break;
		case QST_PIRATE:
			return 3;
			break;
		case QST_GOLEM:
			return 4;
			break;
		case QST_PLANT:
			return 4;
			break;
		case QST_VOLCANO:
			return 3;
			break;
		case QST_NIGHTMARCHER:
			return 7;
			break;
		case QST_CULTIST:
			return 6;
			break;
		case QST_SOREN:
			return 7;
		case QST_HORIZON:
			return 10;
		case QST_HELPER:
			return 3;
		default:
			return 99;
			break;
	}
}

void SidequestDescription(int buf, int id){
	int progress = SidequestProgress(id);
}
void SidequestObjectives(bitmap b, int y, int id){
	int progress = SidequestProgress(id);
	G[G_CURRENTQUESTMAXSCROLL] = Max(y-101, 0);
}
int AddSidequestObjective(bitmap b, int y, bool completed, int str){
	b->FastTile(0, 6, y-2, completed?63569:63568, 7, 128);
	b->DrawString(0, 18, y, FONT_Z3SMALL, completed?0x0B:0x01, -1, TF_NORMAL, str, 128, SHD_OUTLINED8, 0x0F);
	return y + 12;
}