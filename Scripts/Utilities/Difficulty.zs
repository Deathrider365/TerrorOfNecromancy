///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Difficulty ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

const int NPCM_DIFFICULTYFLAG = 14; //npc->Misc[] index used to track enemy difficulty modification. Be sure this doesn't overlap with other scripts.
const int DIFFICULTY_APPLY_NPC_SCALING = 1; //If 1, scaling will be applied to enemies based on settings. If not, that will be skipped completely

//Global damage multipliers for all difficulties
const int DIFFICULTY_VERYEASY_DAMAGE_MULTIPLIER = 1;
const int DIFFICULTY_EASY_DAMAGE_MULTIPLIER = 1;
const int DIFFICULTY_NORMAL_DAMAGE_MULTIPLIER = 1;
const int DIFFICULTY_HARD_DAMAGE_MULTIPLIER = 1;
const int DIFFICULTY_VERYHARD_DAMAGE_MULTIPLIER = 1;

//Enemy base damage multipliers
const int DIFFICULTY_ENEMY_VERYEASY_DAMAGE_MULTIPLIER = 0.5;
const int DIFFICULTY_ENEMY_EASY_DAMAGE_MULTIPLIER = 0.75;
const int DIFFICULTY_ENEMY_NORMAL_DAMAGE_MULTIPLIER = 1;
const int DIFFICULTY_ENEMY_HARD_DAMAGE_MULTIPLIER = 1.25;
const int DIFFICULTY_ENEMY_VERYHARD_DAMAGE_MULTIPLIER = 1.75;

//Enemy base HP multipliers
const int DIFFICULTY_ENEMY_VERYEASY_HP_MULTIPLIER = 0.5;
const int DIFFICULTY_ENEMY_EASY_HP_MULTIPLIER = 0.75;
const int DIFFICULTY_ENEMY_NORMAL_HP_MULTIPLIER = 1;
const int DIFFICULTY_ENEMY_HARD_HP_MULTIPLIER = 1.1;
const int DIFFICULTY_ENEMY_VERYHARD_HP_MULTIPLIER = 1.25;

//Enemy base Step multipliers
const int DIFFICULTY_ENEMY_VERYEASY_STEP_MULTIPLIER = 1; //0.8
const int DIFFICULTY_ENEMY_EASY_STEP_MULTIPLIER = 1; //0.9
const int DIFFICULTY_ENEMY_NORMAL_STEP_MULTIPLIER = 1;
const int DIFFICULTY_ENEMY_HARD_STEP_MULTIPLIER = 1; //1.1
const int DIFFICULTY_ENEMY_VERYHARD_STEP_MULTIPLIER = 1; //1.2

//Item IDs for difficulty selection items
//If using damage divisors for lower difficulties, these should use Peril Ring items for best results
//If 0, that difficulty level will go unused
const int I_DIFF_VERYEASY = 163;
const int I_DIFF_EASY = 160;
const int I_DIFF_NORMAL = 161;
const int I_DIFF_HARD = 162;
const int I_DIFF_VERYHARD = 164;

void DifficultyGlobal_SetEnemyHP(npc n, int val) {
	//If using ghost.zh, uncomment the following and comment out the line below
		SetEnemyProperty(n, ENPROP_HP, val);
		// n->HP = val;
}

int DifficultyGlobal_GetEnemyHP(npc n) {
	//If using ghost.zh, uncomment the following and comment out the line below
		return GetEnemyProperty(n, ENPROP_HP);
		// return n->HP;
} 

//This function handles exceptions to enemy stat calculation / manual stat assignment based on difficulty
//
//Use the following functions as shown in the example comment.
//All use the same 6 arguments, the Enemy's ID, followed by 5 settings for each of the possible difficulties.
//Entering -1 for an argument will tell the script to defer to the global settings.
//Entering -2 for an argument will tell the script to ignore even the global settings, leaving the stat completely unchanged.
//	EnemyDiff_HP(NPCID, VeryEasy, Easy, Normal, Hard, VeryHard) - Sets enemy HP
//	EnemyDiff_Damage(NPCID, VeryEasy, Easy, Normal, Hard, VeryHard) - Sets contact and weapon damage
//	EnemyDiff_ContactDamage(NPCID, VeryEasy, Easy, Normal, Hard, VeryHard) - Sets only contact damage
//	EnemyDiff_WeaponDamage(NPCID, VeryEasy, Easy, Normal, Hard, VeryHard) - Sets only weapon damage
//	EnemyDiff_Step(NPCID, VeryEasy, Easy, Normal, Hard, VeryHard) - Sets step speed
//	EnemyDiff_RandomRate(NPCID, VeryEasy, Easy, Normal, Hard, VeryHard) - Sets random rate
//	EnemyDiff_HaltRate(NPCID, VeryEasy, Easy, Normal, Hard, VeryHard) - Sets halt rate
//	EnemyDiff_Homing(NPCID, VeryEasy, Easy, Normal, Hard, VeryHard) - Sets homing
//	EnemyDiff_Weapon(NPCID, VeryEasy, Easy, Normal, Hard, VeryHard) - Sets weapon (use WPN_ constants from std_constants.zh)
//	EnemyDiff_ItemSet(NPCID, VeryEasy, Easy, Normal, Hard, VeryHard) - Sets item dropset
void DifficultyGlobal_InitEnemyTables() {
	//Example Enemy Configuration: 
	//This would set the Stalfos 2's HP, beam damage, turns off beams on easy mode, and turns off hearts on higher difficulties
	
	//Stalfos 2
	// EnemyDiff_HP(NPC_STALFOS2, 2, 2, 4, 4, 6);
	// EnemyDiff_WeaponDamage(NPC_STALFOS2, 2, 2, 4, 8, 8);
	// EnemyDiff_Weapon(NPC_STALFOS2, WPN_NONE, WPN_NONE, WPN_ENEMYSWORD, WPN_ENEMYSWORD, WPN_ENEMYSWORD);
	// EnemyDiff_ItemSet(NPC_STALFOS2, 1, 1, 1, 0, 0);
	
	// EnemyDiff_HP(NPC_DARKNUT1, 2, 4, -1, -1, -1);
	// EnemyDiff_RandomRate(NPC_DARKNUT1, 1, 2, -1, -1, -1);
	// EnemyDiff_Damage(NPC_DARKNUT1, -1, -1, -1, 8, 12);
	// EnemyDiff_HP(NPC_DARKNUT2, 6, 12, -1, -1, -1);
	// EnemyDiff_RandomRate(NPC_DARKNUT2, 1, 3, -1, -1, -1);
	// EnemyDiff_Damage(NPC_DARKNUT2, -1, -1, -1, 16, 24);
	
	// EnemyDiff_HP(NPC_KEESE1, -1, -1, -1, 4, 4);
	// EnemyDiff_Damage(NPC_KEESE1, 1, 1, 2, 4, 6);
	// EnemyDiff_HP(NPC_KEESE2, -1, -1, -1, 4, 4);
	// EnemyDiff_Damage(NPC_KEESE2, 1, 1, 2, 4, 6);
	// EnemyDiff_HP(NPC_KEESE3, -1, -1, -1, 4, 4);
	// EnemyDiff_Damage(NPC_KEESE3, 1, 1, 2, 4, 6);
	
	// EnemyDiff_Step(NPC_STALFOS2, -1, -1, -1, 100, 150);
	// EnemyDiff_Weapon(NPC_STALFOS2, WPN_NONE, WPN_NONE, -1, -1, -1);
	
	// EnemyDiff_Damage(NPC_GHINI1, -1, -1, -1, 4, 6);
	
	// EnemyDiff_Damage(NPC_GIBDO, -1, -1, -1, 16, 24);
	
	// EnemyDiff_HP(NPC_SHOOTFBALL, -1000, -1000, -1, -1, -1);
}

//======= INTERNAL CONSTANTS, DO NOT CHANGE ======
const int DIFF_VERYEASY = 0;
const int DIFF_EASY = 1;
const int DIFF_NORMAL = 2;
const int DIFF_HARD = 3;
const int DIFF_VERYHARD = 4;

//Global array indices
const int __DI_CURDIFFICULTY = 0;
const int __DI_LINKLASTHP = 1;
const int __DI_DIFFICULTYOVERRIDE = 2;

//Everything past this in the global array is occupied by the enemy table, size 23040 (512x9*5)
const int __DI_ENEMYTABLES_START = 32;
const int __DI_ENEMYTABLES_SLOTSIZE = 9;
const int __DI_ENEMYTABLES_DIFFSIZE = 4608;
const int __DI_ENEMYTABLES_MAXSIZE = 23040;

//Enemy table sub indices
const int __DIT_HP = 0;
const int __DIT_DAMAGE = 1;
const int __DIT_WDAMAGE = 2;
const int __DIT_STEP = 3;
const int __DIT_RANDRATE = 4;
const int __DIT_HALTRATE = 5;
const int __DIT_HOMING = 6;
const int __DIT_WEAPON = 7; //Use WPN_ constants!
const int __DIT_ITEMSET = 8;

//===============================================

int DifficultyGlobal[65536];

//Init function for the difficulty script. Call once in global script before void run(){
void DifficultyGlobal_Init() {
	DifficultyGlobal_Init(true);
} 

void DifficultyGlobal_Init(bool resetOverride) {
	int i;
	
	for(i=0; i<23040; ++i)
		DifficultyGlobal[__DI_ENEMYTABLES_START+i] = 0;
	
	DifficultyGlobal[__DI_CURDIFFICULTY] = Difficulty_GetDifficulty();
	DifficultyGlobal[__DI_LINKLASTHP] = Link->HP;
	if(resetOverride)
		DifficultyGlobal[__DI_DIFFICULTYOVERRIDE] = 0;
	
	DifficultyGlobal_InitEnemyTables();
}

//Update function for the difficulty script. Call once in global script before Waitframe();
void DifficultyGlobal_Update() {
	//Update difficulty every frame in case items change
	DifficultyGlobal[__DI_CURDIFFICULTY] = Difficulty_GetDifficulty();
	
	//Apply difficulty override
	if(DifficultyGlobal[__DI_DIFFICULTYOVERRIDE]) {
		//<100 = temporary (1 frame) override
		if(DifficultyGlobal[__DI_DIFFICULTYOVERRIDE]<100) {
			DifficultyGlobal[__DI_CURDIFFICULTY] = DifficultyGlobal[__DI_DIFFICULTYOVERRIDE]-1;
			DifficultyGlobal[__DI_DIFFICULTYOVERRIDE] = 0;
		}
		//>100 = permanent override
		else if(DifficultyGlobal[__DI_DIFFICULTYOVERRIDE]>100)
			DifficultyGlobal[__DI_CURDIFFICULTY] = DifficultyGlobal[__DI_DIFFICULTYOVERRIDE]-101;
	}
	
	//Remember Link's last HP and apply damage modifiers
	if(Link->HP!=DifficultyGlobal[__DI_LINKLASTHP])
	{
		if(Link->HP<DifficultyGlobal[__DI_LINKLASTHP])
		{
			int mult = Difficulty_GetGlobalDamageMultiplier();
			//Multipliers of <1 subtract the remainder of the damage Link has taken, leaving only the amount represented by the multiplier
			//(this does not actually work as intended at <1 HP, but this is how IoR did it and it)
			if(mult<1)
				Link->HP -= Abs(DifficultyGlobal[__DI_LINKLASTHP]-Link->HP)*(1-mult);
			//Multipliers of >1 subtract the multiplier-1, assuming the damage Link took is 1x damage
			else if(mult>1)
				Link->HP -= Abs(DifficultyGlobal[__DI_LINKLASTHP]-Link->HP)*(mult-1);
		}
		DifficultyGlobal[__DI_LINKLASTHP] = Link->HP;
	}
} 

//Enemy update loop for the difficulty script. Call once in global script after DifficultyGlobal_Update();
void DifficultyGlobal_EnemyUpdate() {
	int i;
	for(i=Screen->NumNPCs(); i>=1; --i) {
		npc n = Screen->LoadNPC(i);
		__DifficultyGlobal_EnemyUpdate_Difficulty(n);
	}
} 

//Updates difficulty per enemy as they spawn
void __DifficultyGlobal_EnemyUpdate_Difficulty(npc n) {
	int id = n->ID;
	int stat;
	int mult;
	if(!n->Misc[NPCM_DIFFICULTYFLAG]&&DIFFICULTY_APPLY_NPC_SCALING){
		if(n->Type!=NPCT_GUY&&n->Type!=NPCT_FAIRY) {
			//<< ENEMY HP >>
			stat = __EnemyDiff_GetAttrib(id, __DIT_HP, DifficultyGlobal[__DI_CURDIFFICULTY]); 
			mult = DifficultyGlobal_GetEnemyHPMultiplier();
			//If an override was set, use that
			if(stat>0) {
				//Prevent lowering the HP of a splitter
				if(!__DifficultyGlobal_HPExceptions(n, stat-1))
					DifficultyGlobal_SetEnemyHP(n, stat-1);
			}
			//Else use the base multiplier
			else if(mult>0) {
				if(DifficultyGlobal_GetEnemyHP(n)>0&&stat!=-1) {
					stat = Max(1, Ceiling(DifficultyGlobal_GetEnemyHP(n)*mult));
					//Prevent lowering the HP of a splitter
					if(!__DifficultyGlobal_HPExceptions(n, stat))
						DifficultyGlobal_SetEnemyHP(n, stat);
				}
			}
			
			//<< ENEMY CONTACT DAMAGE >>
			stat = __EnemyDiff_GetAttrib(id, __DIT_DAMAGE, DifficultyGlobal[__DI_CURDIFFICULTY]); 
			mult = Difficulty_GetEnemyDamageMultiplier();
			//If an override was set, use that
			if(stat>0)
				n->Damage = stat-1;
			
			//Else use the base multiplier
			else if(mult>0)
				if(n->Damage>0&&stat!=-1)
					n->Damage =  Max(1, Ceiling(n->Damage*mult));
				
			//<< ENEMY WEAPON DAMAGE >>
			stat = __EnemyDiff_GetAttrib(id, __DIT_WDAMAGE, DifficultyGlobal[__DI_CURDIFFICULTY]); 
			mult = Difficulty_GetEnemyDamageMultiplier();
			//If an override was set, use that
			if(stat>0)
				n->WeaponDamage = stat-1;
			
			//Else use the base multiplier
			else if(mult>0)
				if(n->WeaponDamage>0&&stat!=-1)
					n->WeaponDamage =  Max(1, Ceiling(n->WeaponDamage*mult));
				
			//<< ENEMY STEP SPEED >>
			stat = __EnemyDiff_GetAttrib(id, __DIT_STEP, DifficultyGlobal[__DI_CURDIFFICULTY]); 
			mult = Difficulty_GetEnemyStepMultiplier();
			//If an override was set, use that
			if(stat>0)
				n->Step = stat-1;
			
			//Else use the base multiplier
			else if(mult>0&&stat!=-1)
				n->Step =  Ceiling(n->Step*mult);
		
			//<< ENEMY RANDOM RATE >>
			stat = __EnemyDiff_GetAttrib(id, __DIT_RANDRATE, DifficultyGlobal[__DI_CURDIFFICULTY]); 
			//If an override was set, use that
			if(stat>0)
				n->Rate = stat-1;

			//<< ENEMY HALT RATE >>
			stat = __EnemyDiff_GetAttrib(id, __DIT_HALTRATE, DifficultyGlobal[__DI_CURDIFFICULTY]); 
			//If an override was set, use that
			if(stat>0)
				n->Haltrate = stat-1;

			//<< ENEMY HOMING >>
			stat = __EnemyDiff_GetAttrib(id, __DIT_HOMING, DifficultyGlobal[__DI_CURDIFFICULTY]); 
			//If an override was set, use that
			if(stat>0)
				n->Homing = stat-1;

			//<< ENEMY WEAPON >>
			stat = __EnemyDiff_GetAttrib(id, __DIT_WEAPON, DifficultyGlobal[__DI_CURDIFFICULTY]); 
			//If an override was set, use that
			if(stat>0)
				n->Weapon = stat-1;

			//<< ENEMY ITEM SET >>
			stat = __EnemyDiff_GetAttrib(id, __DIT_ITEMSET, DifficultyGlobal[__DI_CURDIFFICULTY]); 
			//If an override was set, use that
			if(stat>0)
				n->ItemSet = stat-1;
		}
		n->Misc[NPCM_DIFFICULTYFLAG] = 1;
	}
} 

void __EnemyDiff_SetAttrib(int npcID, int attrib, int veryEasy, int easy, int normal, int hard, int veryHard) {
	if(veryHard!=-1)
		DifficultyGlobal[__DI_ENEMYTABLES_START+__DI_ENEMYTABLES_DIFFSIZE*DIFF_VERYHARD+__DI_ENEMYTABLES_SLOTSIZE*npcID+attrib] = veryHard+1;
	if(hard!=-1)
		DifficultyGlobal[__DI_ENEMYTABLES_START+__DI_ENEMYTABLES_DIFFSIZE*DIFF_HARD+__DI_ENEMYTABLES_SLOTSIZE*npcID+attrib] = hard+1;
	if(normal!=-1)
		DifficultyGlobal[__DI_ENEMYTABLES_START+__DI_ENEMYTABLES_DIFFSIZE*DIFF_NORMAL+__DI_ENEMYTABLES_SLOTSIZE*npcID+attrib] = normal+1;
	if(easy!=-1)
		DifficultyGlobal[__DI_ENEMYTABLES_START+__DI_ENEMYTABLES_DIFFSIZE*DIFF_EASY+__DI_ENEMYTABLES_SLOTSIZE*npcID+attrib] = easy+1;
	if(veryEasy!=-1)
		DifficultyGlobal[__DI_ENEMYTABLES_START+__DI_ENEMYTABLES_DIFFSIZE*DIFF_VERYEASY+__DI_ENEMYTABLES_SLOTSIZE*npcID+attrib] = veryEasy+1;
	
} 

int __EnemyDiff_GetAttrib(int npcID, int attrib, int diff) {
	return DifficultyGlobal[__DI_ENEMYTABLES_START+__DI_ENEMYTABLES_DIFFSIZE*diff+__DI_ENEMYTABLES_SLOTSIZE*npcID+attrib];
} 

void EnemyDiff_HP(int npcID, int veryEasy, int easy, int normal, int hard, int veryHard) {
	__EnemyDiff_SetAttrib(npcID, __DIT_HP, veryEasy, easy, normal, hard, veryHard);
} 

void EnemyDiff_Damage(int npcID, int veryEasy, int easy, int normal, int hard, int veryHard) {
	__EnemyDiff_SetAttrib(npcID, __DIT_DAMAGE, veryEasy, easy, normal, hard, veryHard);
	__EnemyDiff_SetAttrib(npcID, __DIT_WDAMAGE, veryEasy, easy, normal, hard, veryHard);
} 

void EnemyDiff_ContactDamage(int npcID, int veryEasy, int easy, int normal, int hard, int veryHard) {
	__EnemyDiff_SetAttrib(npcID, __DIT_DAMAGE, veryEasy, easy, normal, hard, veryHard);
} 

void EnemyDiff_WeaponDamage(int npcID, int veryEasy, int easy, int normal, int hard, int veryHard) {
	__EnemyDiff_SetAttrib(npcID, __DIT_WDAMAGE, veryEasy, easy, normal, hard, veryHard);
} 

void EnemyDiff_Step(int npcID, int veryEasy, int easy, int normal, int hard, int veryHard) {
	__EnemyDiff_SetAttrib(npcID, __DIT_STEP, veryEasy, easy, normal, hard, veryHard);
} 

void EnemyDiff_RandomRate(int npcID, int veryEasy, int easy, int normal, int hard, int veryHard) {
	__EnemyDiff_SetAttrib(npcID, __DIT_RANDRATE, veryEasy, easy, normal, hard, veryHard);
} 

void EnemyDiff_HaltRate(int npcID, int veryEasy, int easy, int normal, int hard, int veryHard) {
	__EnemyDiff_SetAttrib(npcID, __DIT_HALTRATE, veryEasy, easy, normal, hard, veryHard);
} 

void EnemyDiff_Homing(int npcID, int veryEasy, int easy, int normal, int hard, int veryHard) {
	__EnemyDiff_SetAttrib(npcID, __DIT_HOMING, veryEasy, easy, normal, hard, veryHard);
} 

void EnemyDiff_Weapon(int npcID, int veryEasy, int easy, int normal, int hard, int veryHard) {
	__EnemyDiff_SetAttrib(npcID, __DIT_WEAPON, veryEasy, easy, normal, hard, veryHard);
} 

void EnemyDiff_ItemSet(int npcID, int veryEasy, int easy, int normal, int hard, int veryHard) {
	__EnemyDiff_SetAttrib(npcID, __DIT_ITEMSET, veryEasy, easy, normal, hard, veryHard);
} 

//Returns true if an enemy has problems with lowering HP
bool __DifficultyGlobal_HPExceptions(npc n, int targetHP) {
	int hp = DifficultyGlobal_GetEnemyHP(n);
	if(n->Type==NPCT_WALK&&n->Attributes[1]==1)
		return true;
	if(n->Type==NPCT_GLEEOK&&targetHP<hp)
		return true;
	return false;
} 

void DifficultyGlobal_SetDifficulty(int diffLevel) {
	//Remove items for all active levels of difficulty
	if(I_DIFF_VERYEASY)
		Link->Item[I_DIFF_VERYEASY] = false;
	if(I_DIFF_EASY)
		Link->Item[I_DIFF_EASY] = false;
	if(I_DIFF_NORMAL)
		Link->Item[I_DIFF_NORMAL] = false;
	if(I_DIFF_HARD)
		Link->Item[I_DIFF_HARD] = false;
	if(I_DIFF_VERYHARD)
		Link->Item[I_DIFF_VERYHARD] = false;

	//Give the item for the current difficulty level
	if(diffLevel==0)
		Link->Item[I_DIFF_VERYEASY] = true;
	else if(diffLevel==1)
		Link->Item[I_DIFF_EASY] = true;
	else if(diffLevel==2)
		Link->Item[I_DIFF_NORMAL] = true;
	else if(diffLevel==3)
		Link->Item[I_DIFF_HARD] = true;
	else if(diffLevel==4)
		Link->Item[I_DIFF_VERYHARD] = true;
	else
		Link->Item[I_DIFF_NORMAL] = true;
} 

//Returns a numbered value for the current difficulty level
//Based on items in Link's inventory
int Difficulty_GetDifficulty() {
	if(DifficultyGlobal[__DI_DIFFICULTYOVERRIDE]) {
		//<100 = temporary (1 frame) override
		if(DifficultyGlobal[__DI_DIFFICULTYOVERRIDE]<100)
			return DifficultyGlobal[__DI_DIFFICULTYOVERRIDE]-1;
		
		//>100 = permanent override
		else if(DifficultyGlobal[__DI_DIFFICULTYOVERRIDE]>100)
			return DifficultyGlobal[__DI_DIFFICULTYOVERRIDE]-101;
		
	}
	
	if(I_DIFF_VERYHARD)
		if(Link->Item[I_DIFF_VERYHARD])
			return DIFF_VERYHARD;
	
	if(I_DIFF_HARD)
		if(Link->Item[I_DIFF_HARD])
			return DIFF_HARD;
	
	if(I_DIFF_NORMAL)
		if(Link->Item[I_DIFF_NORMAL])
			return DIFF_NORMAL;
	
	if(I_DIFF_EASY)
		if(Link->Item[I_DIFF_EASY])
			return DIFF_EASY;
	
	if(I_DIFF_VERYEASY)
		if(Link->Item[I_DIFF_VERYEASY])
			return DIFF_VERYEASY;
} 

//Returns one of 5 options based on the current difficulty, starting from easy and going to very hard
int Difficulty_DiffMod(int dVeryEasy, int dEasy, int dNormal, int dHard, int dVeryHard) {
	if(DifficultyGlobal[__DI_CURDIFFICULTY]==DIFF_VERYHARD)
		return dVeryHard;
	if(DifficultyGlobal[__DI_CURDIFFICULTY]==DIFF_HARD)
		return dHard;
	if(DifficultyGlobal[__DI_CURDIFFICULTY]==DIFF_NORMAL)
		return dNormal;
	if(DifficultyGlobal[__DI_CURDIFFICULTY]==DIFF_EASY)
		return dEasy;
	if(DifficultyGlobal[__DI_CURDIFFICULTY]==DIFF_VERYEASY)
		return dVeryEasy;
	return dNormal;
} 

//Returns the global damage multiplier, which all Link's damage is multiplied by
int Difficulty_GetGlobalDamageMultiplier() {
	if(DifficultyGlobal[__DI_CURDIFFICULTY]==DIFF_VERYHARD)
		return DIFFICULTY_VERYHARD_DAMAGE_MULTIPLIER;
	if(DifficultyGlobal[__DI_CURDIFFICULTY]==DIFF_HARD)
		return DIFFICULTY_HARD_DAMAGE_MULTIPLIER;
	if(DifficultyGlobal[__DI_CURDIFFICULTY]==DIFF_NORMAL)
		return DIFFICULTY_NORMAL_DAMAGE_MULTIPLIER;
	if(DifficultyGlobal[__DI_CURDIFFICULTY]==DIFF_EASY)
		return DIFFICULTY_EASY_DAMAGE_MULTIPLIER;
	if(DifficultyGlobal[__DI_CURDIFFICULTY]==DIFF_VERYEASY)
		return DIFFICULTY_VERYEASY_DAMAGE_MULTIPLIER;
	return DIFFICULTY_NORMAL_DAMAGE_MULTIPLIER;
} 

//Returns the enemy HP multiplier, which all enemy HP is multiplied by
int DifficultyGlobal_GetEnemyHPMultiplier() {
	if(DifficultyGlobal[__DI_CURDIFFICULTY]==DIFF_VERYHARD)
		return DIFFICULTY_ENEMY_VERYHARD_HP_MULTIPLIER;
	if(DifficultyGlobal[__DI_CURDIFFICULTY]==DIFF_HARD)
		return DIFFICULTY_ENEMY_HARD_HP_MULTIPLIER;
	if(DifficultyGlobal[__DI_CURDIFFICULTY]==DIFF_NORMAL)
		return DIFFICULTY_ENEMY_NORMAL_HP_MULTIPLIER;
	if(DifficultyGlobal[__DI_CURDIFFICULTY]==DIFF_EASY)
		return DIFFICULTY_ENEMY_EASY_HP_MULTIPLIER;
	if(DifficultyGlobal[__DI_CURDIFFICULTY]==DIFF_VERYEASY)
		return DIFFICULTY_ENEMY_VERYEASY_HP_MULTIPLIER;
	return DIFFICULTY_ENEMY_NORMAL_HP_MULTIPLIER;
} 

//Returns the enemy damage multiplier, which all enemy damage to Link is multiplied by
int Difficulty_GetEnemyDamageMultiplier() {
	if(DifficultyGlobal[__DI_CURDIFFICULTY]==DIFF_VERYHARD)
		return DIFFICULTY_ENEMY_VERYHARD_DAMAGE_MULTIPLIER;
	if(DifficultyGlobal[__DI_CURDIFFICULTY]==DIFF_HARD)
		return DIFFICULTY_ENEMY_HARD_DAMAGE_MULTIPLIER;
	if(DifficultyGlobal[__DI_CURDIFFICULTY]==DIFF_NORMAL)
		return DIFFICULTY_ENEMY_NORMAL_DAMAGE_MULTIPLIER;
	if(DifficultyGlobal[__DI_CURDIFFICULTY]==DIFF_EASY)
		return DIFFICULTY_ENEMY_EASY_DAMAGE_MULTIPLIER;
	if(DifficultyGlobal[__DI_CURDIFFICULTY]==DIFF_VERYEASY)
		return DIFFICULTY_ENEMY_VERYEASY_DAMAGE_MULTIPLIER;
	return DIFFICULTY_ENEMY_NORMAL_DAMAGE_MULTIPLIER;
} 

//Returns the enemy step multiplier, which all enemy step speed is multiplied by
int Difficulty_GetEnemyStepMultiplier() {
	if(DifficultyGlobal[__DI_CURDIFFICULTY]==DIFF_VERYHARD)
		return DIFFICULTY_ENEMY_VERYHARD_STEP_MULTIPLIER;
	if(DifficultyGlobal[__DI_CURDIFFICULTY]==DIFF_HARD)
		return DIFFICULTY_ENEMY_HARD_STEP_MULTIPLIER;
	if(DifficultyGlobal[__DI_CURDIFFICULTY]==DIFF_NORMAL)
		return DIFFICULTY_ENEMY_NORMAL_STEP_MULTIPLIER;
	if(DifficultyGlobal[__DI_CURDIFFICULTY]==DIFF_EASY)
		return DIFFICULTY_ENEMY_EASY_STEP_MULTIPLIER;
	if(DifficultyGlobal[__DI_CURDIFFICULTY]==DIFF_VERYEASY)
		return DIFFICULTY_ENEMY_VERYEASY_STEP_MULTIPLIER;
	return DIFFICULTY_ENEMY_NORMAL_STEP_MULTIPLIER;
} 

//Item script for difficulty pickups (for removing other difficulty items)
//D0: ID of this item
item script Difficulty_PickupItem {
	void run(int itemID)	{
		//Remove items for all active levels of difficulty
		if(I_DIFF_VERYEASY)
			Link->Item[I_DIFF_VERYEASY] = false;
		if(I_DIFF_EASY)
			Link->Item[I_DIFF_EASY] = false;
		if(I_DIFF_NORMAL)
			Link->Item[I_DIFF_NORMAL] = false;
		if(I_DIFF_HARD)
			Link->Item[I_DIFF_HARD] = false;
		if(I_DIFF_VERYHARD)
			Link->Item[I_DIFF_VERYHARD] = false;
	
		//Give Link the item for the currently selected difficulty
		Link->Item[itemID] = true;
		
		DifficultyGlobal_Init();
	}
} 

//Forces difficulty on a screen to the desired level
//D0: Level to set difficulty to. 0 = Very Easy, 4 = Very Hard. -1 = Unset Override
//D1: Whether to make the change permanent
//		If 1, the difficulty change will give Link the actual difficulty item and apply forever.
//		If 2, it will persist until F6 or encountering another instance of this script
ffc script Difficulty_Override {
	void run(int diffLevel, int perm) {
		if(perm) {
			//Give item permanently
			if(perm==1) {
				diffLevel = Clamp(diffLevel, 0, 4);
				
				DifficultyGlobal_SetDifficulty(diffLevel);
				
				//Initialize the difficulty global to update enemy data
				DifficultyGlobal_Init();
			}
			//Turn on long term override
			else if(perm==2) {
				diffLevel = Clamp(diffLevel, -1, 4);
				
				//Turn off long term override
				if(diffLevel==-1)
					DifficultyGlobal[__DI_DIFFICULTYOVERRIDE] = 0;
				else
					//Difficulty Override >100 means temporary override is on until turned off
					DifficultyGlobal[__DI_DIFFICULTYOVERRIDE] = 101+diffLevel;
				
				//Initialize the difficulty global to update enemy data
				DifficultyGlobal_Init(false);
			}
		} else {
			diffLevel = Clamp(diffLevel, 0, 4);
			
			DifficultyGlobal[__DI_DIFFICULTYOVERRIDE] = 1+diffLevel;
			
			//Initialize the difficulty global to update enemy data
			DifficultyGlobal_Init(false);
			
			while(true) {
				//Difficulty Override >1 means temporary override is on for that frame
				DifficultyGlobal[__DI_DIFFICULTYOVERRIDE] = 1+diffLevel;
				Waitframe();
			}
		}
	}
} 

const int SFX_DIFFICULTY_SELECT = 6; //Sound when moving difficulty selection cursor
const int CMB_AUTOWARPA = 32; //An invisible combo with the Auto Side Warp A type

//Colors for black, white, and gray. Used for selection menu drawing.
// const int C_WHITE = 0x01;
// const int C_GRAY = 0x02;
// const int C_BLACK = 0x0F;

//Very basic script for a difficulty selection menu:
//D0: The default difficulty. See DIFF_ constants.
//D3-D7: Editor strings containing the names of each difficulty level from Very Easy (D3) to Very Hard (D7). If 0, that difficulty will be skipped
ffc script DifficultySelectionScreen {
	void run(int defaultDifficulty, int dummy1, int dummy2, int msgVeryEasy, int msgEasy, int msgNormal, int msgHard, int msgVeryHard) {
		bool chosen = false;
		
		while(!false) {
			if((Hero->X >= 140 && Hero->X <= 156) && (Hero->Y >= 100 && Hero->Y <= 116)) {
				if (Hero->Item[164]) {
					Screen->Message(msgVeryHard);
					Quit();
				} else {
               msgVeryHard = 0;
            }
			
				int i;
				
				int sSelect[] = "SELECT YOUR DIFFICULTY:";
				
				int sVeryEasy[256];
				int sEasy[256];
				int sNormal[256];
				int sHard[256];
				int sVeryHard[256];
				
				int options[5];
				int optionValues[5];
				int selection;
				int numOptions;
				
				if(msgVeryEasy) {
					GetMessage(msgVeryEasy, sVeryEasy);
					if(defaultDifficulty==DIFF_VERYEASY)
						selection = numOptions;
					options[numOptions] = sVeryEasy;
					optionValues[numOptions] = 0;
					++numOptions;
				}
				if(msgEasy) {
					GetMessage(msgEasy, sEasy);
					if(defaultDifficulty==DIFF_EASY)
						selection = numOptions;
					options[numOptions] = sEasy;
					optionValues[numOptions] = 1;
					++numOptions;
				}
				if(msgNormal) {
					GetMessage(msgNormal, sNormal);
					if(defaultDifficulty==DIFF_NORMAL)
						selection = numOptions;
					options[numOptions] = sNormal;
					optionValues[numOptions] = 2;
					++numOptions;
				}
				if(msgHard) {
					GetMessage(msgHard, sHard);
					if(defaultDifficulty==DIFF_HARD)
						selection = numOptions;
					options[numOptions] = sHard;
					optionValues[numOptions] = 3;
					++numOptions;
				}
				if(msgVeryHard) {
					GetMessage(msgVeryHard, sVeryHard);
					if(defaultDifficulty==DIFF_VERYHARD)
						selection = numOptions;
					options[numOptions] = sVeryHard;
					optionValues[numOptions] = 4;
					++numOptions;
				}
				
				if(numOptions) {
					while(true) {
						DiffMenu_DrawString(6, 128, 32, FONT_GBLA, C_WHITE, C_BLACK, TF_CENTERED, sSelect, 128);
						
						if(Link->PressUp) 						{
							Game->PlaySound(SFX_DIFFICULTY_SELECT);
							--selection;
							if(selection<0)
								selection = numOptions-1;
						}
						else if(Link->PressDown) {
							Game->PlaySound(SFX_DIFFICULTY_SELECT);
							++selection;
							if(selection>numOptions-1)
								selection = 0;
						}
						
						for(i=0; i<numOptions; ++i) {
							if(selection==i)
								DiffMenu_DrawString(6, 128, 64+12*i, FONT_GBLA, C_WHITE, C_BLACK, TF_CENTERED, options[i], 128);
							else
								DiffMenu_DrawString(6, 128, 64+12*i, FONT_GBLA, C_GRAY, C_BLACK, TF_CENTERED, options[i], 128);
						}
						
						if(Link->PressA){
							DifficultyGlobal_SetDifficulty(optionValues[selection]);
							chosen = true;
							Audio->PlaySound(20);
							//this->Data = CMB_AUTOWARPA;
						}
						else if (Link->PressB)
							Quit();
						
						Link->PressStart = false; Link->InputStart = false;
						Link->PressMap = false; Link->InputMap = false;
						NoAction();
						Waitframe();
					}
				}
			}
			Waitframe();
		}
	}
   
	void DiffMenu_DrawString(int layer, int x, int y, int font, int c1, int c2, int tf, int str, int op) {
		Screen->DrawString(layer, x-1, y, font, c2, -1, tf, str, op);
		Screen->DrawString(layer, x+1, y, font, c2, -1, tf, str, op);
		Screen->DrawString(layer, x, y-1, font, c2, -1, tf, str, op);
		Screen->DrawString(layer, x, y+1, font, c2, -1, tf, str, op);
		
		Screen->DrawString(layer, x, y, font, c1, -1, tf, str, op);
	}
} 

//Script to copy an entire screen onto another screen or layer based on difficulty.
//This cannot change enemy lists or FFC data. Sorry.
//D0: Map to copy screens from
//D1: If >0, copy to that layer on this screen (this change is permanent until save/load)
//D3-D7: Screens on the map (in decimal) to copy from for difficulties Very Easy (D3) to Very Hard (D7). If -1, don't copy screen
ffc script Difficulty_ReplaceScreen {
	void run(int map, int layer, int dummy1, int scrnVeryEasy, int scrnEasy, int scrnNormal, int scrnHard, int scrnVeryHard) {
		layer = Clamp(layer, 0, 6);
		int diff = Difficulty_GetDifficulty();
		if(diff==DIFF_VERYEASY)
			if(scrnVeryEasy>-1)
				ChangeScreen_CopyScreen(map, scrnVeryEasy, layer);
		else if(diff==DIFF_EASY)
			if(scrnEasy>-1)
				ChangeScreen_CopyScreen(map, scrnEasy, layer);
		else if(diff==DIFF_NORMAL) 
			if(scrnNormal>-1)
				ChangeScreen_CopyScreen(map, scrnNormal, layer);
		else if(diff==DIFF_HARD) 
			if(scrnHard>-1)
				ChangeScreen_CopyScreen(map, scrnHard, layer);
      else if(diff==DIFF_VERYHARD)
			if(scrnVeryHard>-1)
				ChangeScreen_CopyScreen(map, scrnVeryHard, layer);
	}
	
	void ChangeScreen_CopyScreen(int map, int scrn, int layer)
	{
		layer = Clamp(layer, 0, 6);
		if(layer==0)
			for(int i=0; i<176; ++i)
			{
				Screen->ComboD[i] = Game->GetComboData(map, scrn, i);
				Screen->ComboC[i] = Game->GetComboCSet(map, scrn, i);
				Screen->ComboF[i] = Game->GetComboFlag(map, scrn, i);
			}
		else
		{
			int layerMap = Screen->LayerMap(layer);
			int layerScreen = Screen->LayerScreen(layer);
			if(layerMap>-1&&layerScreen>-1)
				for(int i=0; i<176; ++i)
				{
					Game->SetComboData(layerMap, layerScreen, i, Game->GetComboData(map, scrn, i));
					Game->SetComboCSet(layerMap, layerScreen, i, Game->GetComboCSet(map, scrn, i));
					Game->SetComboFlag(layerMap, layerScreen, i, Game->GetComboFlag(map, scrn, i));
				}
		}
	}
} 

//Script to replace all instances of a combo onscreen based on difficulty
//D0: A combo to search for on layer 0
//D3-D7: Combos to replace it with on each difficulty from Very Easy (D3) to Very Hard (D7). If 0, don't replace for that difficulty.
ffc script Difficulty_ReplaceCombo {
	void run(int srcCombo, int dummy1, int dummy2, int destVeryEasy, int destEasy, int destNormal, int destHard, int destVeryHard) {
		int diff = Difficulty_GetDifficulty();
		int destCombo = -1;
		if(diff==DIFF_VERYEASY)
			destCombo = destVeryEasy;

		else if(diff==DIFF_EASY)
			destCombo = destEasy;
			
		else if(diff==DIFF_NORMAL)
			destCombo = destNormal;
		
		else if(diff==DIFF_HARD)
			destCombo = destHard;
		
		else if(diff==DIFF_VERYHARD)
			destCombo = destVeryHard;
		
		
		if(destCombo>0)
			for(int i=0; i<176; ++i)
				if(Screen->ComboD[i]==srcCombo)
					Screen->ComboD[i] = destCombo;
	}
} 

//Script to change a warp based on difficulty
//D0: Warp DMap
//D1: Warp Screen
//D2: Whether to change a tile warp or side warp. 0 = Tile Warp, 1 = Side Warp
//D3: Which warp to change (0 = A, 1 = B, 2 = C, 3 = D)
//D4: Difficulty level to activate the warp (See DIFF_ constants)
ffc script Difficulty_ChangeWarp {
	void run(int dmap, int scrn, int sideWarp, int whichWarp, int warpDifficulty) {
		int warpType;
		int diff = Difficulty_GetDifficulty();
		
		if(diff==warpDifficulty) {
			if(sideWarp==0) {
				warpType = Screen->GetTileWarpType(whichWarp);
				if(warpType==WT_CAVE)
					warpType = WT_IWARPBLACKOUT;
				Screen->SetTileWarp(whichWarp, scrn, dmap, warpType);
			} else {
				warpType = Screen->GetSideWarpType(whichWarp);
				if(warpType==WT_CAVE)
					warpType = WT_IWARPBLACKOUT;
				Screen->SetSideWarp(whichWarp, scrn, dmap, warpType);
			}
		}
	}
} 

//Example global script
// global script Difficulty_Example
// {
	// void run()
	// {
		// DifficultyGlobal_Init();
		// while(true)
		// {
			// DifficultyGlobal_Update();
			// DifficultyGlobal_EnemyUpdate();
			// Waitframe();
		// }
	// }
// }