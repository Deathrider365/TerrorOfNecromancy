/*

//Vintage Dreams Codebase


//	-	Importing	-	//

//Libraries
import "Vintage Dreams Tileset\Codebase\std.zh"				//By: Zelda Classic Development Team
import "Vintage Dreams Tileset\Codebase\string.zh"			//By: Zelda Classic Development Team
import "Vintage Dreams Tileset\Codebase\ghost.zh"			//By: Saffith
import "Vintage Dreams Tileset\Codebase\ffcscript.zh"		//By: Saffith
import "Vintage Dreams Tileset\Codebase\stdExtra.zh"		//By: MoscowModder, aaa2, Mero
import "Vintage Dreams Tileset\Codebase\stdCombos.zh"		//By: Alucard648 
import "Vintage Dreams Tileset\Codebase\stdWeapons.zh"		//By: Alucard648 
import "Vintage Dreams Tileset\Codebase\items.zh"			//By: SUCCESSOR
import "Vintage Dreams Tileset\Codebase\laser.zh"			//By: Moosh
import "Vintage Dreams Tileset\Codebase\LinkMovement.zh"	//By: Moosh
import "Vintage Dreams Tileset\Codebase\scrollingDraws.zh"	//By: Moosh


//Scripts
import "Vintage Dreams Tileset\Codebase\MooshNPC.z"			//By: Moosh
import "Vintage Dreams Tileset\Codebase\Newb-boss.z"		//By: Moosh
import "Vintage Dreams Tileset\Codebase\GB_Cliffs2.z"		//By: Moosh
import "Vintage Dreams Tileset\Codebase\GB_Shutter.z"		//By: Moosh
import "Vintage Dreams Tileset\Codebase\MooshPit.z"			//By: Moosh
import "Vintage Dreams Tileset\Codebase\GB_Shovel.z"		//By: Jamian, Lunaria		(Large parts re-written)
import "Vintage Dreams Tileset\Codebase\LunaEvent.z"		//By: Lunaria
import "Vintage Dreams Tileset\Codebase\ExtraTriggers.z"	//By: Lunaria
import "Vintage Dreams Tileset\Codebase\MusicPlayback.z"	//By: Obderhode, Lunaria
import "Vintage Dreams Tileset\Codebase\LockCubes.z"		//By: Lunaria
import "Vintage Dreams Tileset\Codebase\GB_chest.z"			//By: Nimono
import "Vintage Dreams Tileset\Codebase\AutoBTS.z"			//By: Lunaria
import "Vintage Dreams Tileset\Codebase\GB_Seeds.z"			//By: Moosh
import "Vintage Dreams Tileset\Codebase\Sideview_Ladder.z"	//By: Justin
import "Vintage Dreams Tileset\Codebase\GB_PowerBracelet.z"	//By: Zepinho, Lunaria		(Some components re-written)
import "Vintage Dreams Tileset\Codebase\ice_rod.z"			//By: Alucard648, Lunaria	(Reworked how many parts worked)
import "Vintage Dreams Tileset\Codebase\fire_rod.z"			//By: Alucard648, Lunaria	(Lots of changes to make it work)
//import "Vintage Dreams Tileset\Codebase\VD_Pause.z"			//By: Lunaria
import "Vintage Dreams Tileset\Codebase\Hamiltonian_Path.z"	//By: Moosh
import "Vintage Dreams Tileset\Codebase\SimpleShop.z"		//By: a30502355, Lunaria	(Improved visual factor)
import "Vintage Dreams Tileset\Codebase\GB_Minecarts.z"		//By: Moosh
import "Vintage Dreams Tileset\Codebase\bombflowers2.z"
import "Vintage Dreams Tileset\Codebase\Charge Bow.z"
import "Vintage Dreams Tileset\Codebase\GB Shield.z"
import "Vintage Dreams Tileset\Codebase\seedpouch.z"
import "Vintage Dreams Tileset\Codebase\itembundle.z"
//import "Vintage Dreams Tileset\Codebase\"


//Auto Ghost type			//Starts on FFC slot 100 and counts up
import "Vintage Dreams Tileset\Codebase\armos.z"			//By: Saffith 
import "Vintage Dreams Tileset\Codebase\popo.z"				//By: Saffith 
import "Vintage Dreams Tileset\Codebase\helmasaur.z"		//By: Mero		//needs "block" SFX to play on dodge
import "Vintage Dreams Tileset\Codebase\Chaser.z"			//By: Saffith 
import "Vintage Dreams Tileset\Codebase\Goriya.z"			//By: Saffith
import "Vintage Dreams Tileset\Codebase\WallBouncer.z"		//By: Saffith


// 						//Note: Scripts and libraries may contain changes by Lunaria.
//						//	These were if so done to better support the vision of the quest making package,
//						//	or to fix compatibility concerns.







//	- Global Variables -	//

//Item 255 is "No Item" and will be blank and do nothing (But is needed for the Pause menu and L&R items)
const int No_Button_Item = 255;
int L_Button_Item = No_Button_Item;
int R_Button_Item = No_Button_Item;
int Global_Previous_Screen = 0;
int Global_Previous_Dmap = 0;

const int SPRITE_SPARKLE = 0; // Sparkle sprite for when charge bow is finished charging. NOT FOR ARROW SPARKLES!
const int SFX_BOW_CHARGE = 0; // Sound for when charge bow is finished charging.
const int SFX_ERROR = 73; // Error sound for when Link is out of arrows. Set to 0 for no sound.

const int SFX_GBSHIELD = 65; //Shield active SFX
int shieldItem; //Shield item to give (set by item script, reset each frame)
bool shieldButton; //False = B, True = A


int facing_dir;
bool bow_charging[2]; // [0] is true while bow is charging, [1] is true if Link gets hit while charging





//	- Global Script -	//
global script Active{
	void run(){
		
		//Scrolling Draws Library 
		ScrollingDraws_Init();
		
		//GB minecarts
		Minecart_Init();
		
		//VD Scripted subscreen / Pause menu
		//int VD_P_DelayBetween = 0;
		
		//Auto Ghost
		StartGhostZH();
		
		//Moosh Pits
		MooshPit_Init();
		
		//LinkMovement.zh Library init
		LinkMovement_Init();
		
		//Power Bracelet
		PowBra_Holding = 0;

		bool shieldOn;

		
		while(true){
			
			if( !shieldOn && shieldItem ){ //Enable shield when using dummy
				shieldOn=true; //Set shield state to on
				Link->Item[shieldItem]=true; //Give the shield
				Game->PlaySound(SFX_GBSHIELD); //Play the sound
			}
			else if( ( (shieldButton && !Link->InputA)||(!shieldButton && !Link->InputB)) //When button is released
					&& shieldOn){ //And shield is still on
				Link->Item[shieldItem]=false; //Remove shield
				shieldItem = 0; //Reset shield item variable
				shieldOn = false; //Set shield state to off
			}


			//Drawing things while scrolling, should be as far up as possible.
			ScrollingDraws_Update();
			
			
			// Magic Ratio (Item Class 1) managment		//Draw irrelevant
			Dynamic_Mana_Cost_Item();
			
			
			//Once per screen functions		//Should probably be early.
			Global_Once_Per_Screen();
			
			
			
			//L&R Button items		//Before Wait Draw
			//L_and_R_Item_Management();
			//UseEquipmentOnInput(L_Button_Item, EQP_INPUT_L);
			//UseEquipmentOnInput(R_Button_Item, EQP_INPUT_R);
			
			
			
			//AutoGhost
			UpdateGhostZH1();		//Before Wait Draw

			
			//Moosh Pits
			MooshPit_Update();	//Before Wait Draw
			
			
			//Power Bracelet
			PowerBracelet();		//Before Wait Draw	//After L&R Item management
			
			
			//AutoBTS
			AutoBTS(0);			//Before Wait Draw. (But after everything else might be prefered)
			
			
			//LinkMovement.zh
			LinkMovement_Update1();	//Before Wait Draw
			
			
			//Seed shooster
			SeedShooter_Update();	//Before Wait Draw
			
			
			//Sideview Ladder
			GLB_Sideview_Ladder();	//Before Wait Draw
			
			
			
			
			
			//Weapons.std
			UpdateLweaponZH();		// ?
			
			
			
			//VD Scripted subscreen / Pause menu		//Before wait draw maybe?
			//if(VD_P_DelayBetween > 0){
				//VD_P_DelayBetween --;
				//Link->InputStart = false;
				//Link->PressStart = false;		
	
			//}
			//else{
				//VD_P_DelayBetween = VD_Pause_Screen();
			//}
			
			
			
			Waitdraw();	//---------------// Wait Draw //--------///
			
			
			BowAnimation();	

			UpdateLWZH2();		

			//Minecart updates	//After Wait Draw
			Minecart_Update();
			
			
			//L&R Button items
			//ResetEquipment();	//After Wait Draw
			
			
			//Sideview Ladder
			if (onLadder) Link->Dir = DIR_UP;     //After Waitdraw
			
			
			//AutoGhost
			UpdateGhostZH2();	//After Wait Draw
			
			
			//LinkMovement.zh
			LinkMovement_Update2();
			
			
			
			
			
			
			
			//-----BETA TESTING FUNCTIONS, REMOVE WHEN DONE!! ----//
			
			if(Link->Jump > -100 && Link->Jump < 5000)
			Game->MCounter[31] = 5000;
			Game->Counter[31] = Link->Jump + 100;
			
			//Game->MCounter[31] = Game->MCounter[CR_MAGIC];
			//Game->Counter[31] = Game->Counter[CR_MAGIC];
			//Wand magic cost changed from 8 to 1.
			
			Game->MCounter[30] = HighestLevelItemOwned(IC_CUSTOM1);
			Game->Counter[30] = HighestLevelItemOwned(IC_CUSTOM1);
			
			//----------------------------------------------------//
			
			
			
			Waitframe();
			
		}
	}
}
//	- ------------- -	// 

//	- Global Once Per screen -	//
void Global_Once_Per_Screen(){
	
	if(Global_Previous_Screen != Game->GetCurDMapScreen() || Global_Previous_Dmap != Game->GetCurDMap()){
		//Your once per screen functions goes here:
		
		KeyBeep();	//This function is in ExtraTriggers.z if you need to customize it!
		
		
		//Your once per screen function goes above this.
	}
	
	
	Global_Previous_Screen = Game->GetCurDMapScreen();
	Global_Previous_Dmap = Game->GetCurDMap();
	
}

//	- ---------------------- -	// 

//	- Init Script -	//
global script Init{

	void run(){
		
		//Magic configuration
		Game->Generic[GEN_MAGICDRAINRATE] = Init_Base_Magic_Multiplier; // Link's magic usage equals n / 2.
		
		
		//Start up WeaponStd
		InitLweaponZH();
		
		//Set up for Pause menu
		//VD_Pause_Screen_init();
		
		
	}
}
//	- ----------- -	// 

//	- onExit Script -	//
global script onExit{
	void run(){
		
		//GB Power Bracelet
		Link->Item[LTM_CATCHING] = false;
		Link->Item[LTM_HOLDING] = false;
		Link->Item[LTM_PULLING] = false;
		PowBra_Holding = 0;
		PowBra_Bush = false;
		PowBra_Catching = 0;
		
		
	}
}
//	- ------------- -	// 



//	- ----------- -	// 

const int Init_Base_Magic_Multiplier = 10;

void Dynamic_Mana_Cost_Item(){
	
	if(HighestLevelItemOwned(IC_CUSTOM1) < 600 && HighestLevelItemOwned(IC_CUSTOM1) != NULL && HighestLevelItemOwned(IC_CUSTOM1) != -1){
		
		int ItemID = HighestLevelItemOwned(IC_CUSTOM1); //Item class: 67 (Custom itemclass 1)
		itemdata MagicItem_ID = Game->LoadItemData(ItemID);
		
		
		if(Game->Generic[GEN_MAGICDRAINRATE] != MagicItem_ID->Power){
			
			Game->Generic[GEN_MAGICDRAINRATE] = MagicItem_ID->Power;
		}
	}
	else if (Game->Generic[GEN_MAGICDRAINRATE] != Init_Base_Magic_Multiplier){
		
		Game->Generic[GEN_MAGICDRAINRATE] = Init_Base_Magic_Multiplier;
		
	}
	
}

int HighestLevelItemOwned(int itemclass){
	
	itemdata id;
	int ret = -1;
	int curlevel = -1000;
	//143 is default max items, increase if you add lots of your own
	for(int i = 0; i < 256; i++)
	{
		if(Link->Item[i] == true){
			
			id = Game->LoadItemData(i);
			if(id->Family != itemclass)
			continue;
			if(id->Level > curlevel)
			{
				curlevel = id->Level;
				ret = i;
			}
			
		}
	}
	return ret;
}

void NoActionFull(){
	
	Link->InputUp = false; Link->PressUp = false;
	Link->InputDown = false; Link->PressDown = false;
	Link->InputLeft = false; Link->PressLeft = false;
	Link->InputRight = false; Link->PressRight = false;
	
	Link->InputStart = false; Link->PressStart = false;
	Link->InputMap = false; Link->PressMap = false;

	Link->InputR = false; Link->PressR = false;
	Link->InputL = false; Link->PressL = false;
	Link->InputA = false; Link->PressA = false;
	Link->InputB = false; Link->PressB = false;
	
	Link->InputEx1 = false; Link->PressEx1 = false;
	Link->InputEx2 = false; Link->PressEx2 = false;
	Link->InputEx3 = false; Link->PressEx3 = false;
	Link->InputEx4 = false; Link->PressEx4 = false;
	
	Link->InputAxisUp = false; Link->PressAxisUp = false;
	Link->InputAxisDown = false; Link->PressAxisDown = false;
	Link->InputAxisLeft = false; Link->PressAxisLeft = false;
	Link->InputAxisRight = false; Link->PressAxisRight = false;
	
}





//void L_and_R_Item_Management(){
	
	//Creating the items that will carry the drawing to HUD
	//item L_Button_Draw;
	//item R_Button_Draw;
	
	
	//Kills the button item if Link has lost it, somehow.
	//if(Link->Item[L_Button_Item] == false && L_Button_Item != No_Button_Item){
		//L_Button_Item = No_Button_Item;
	//}
	//if(Link->Item[R_Button_Item] == false && L_Button_Item != No_Button_Item){
		//R_Button_Item = No_Button_Item;
	//}
	
	
	//bool LItemSpawned = false;
	//bool RItemSpawned = false;
	
	//for(int l = Screen->NumItems(); l > 0; l--){
		//item ItemCheck = Screen->LoadItem(l);
		
		//if(ItemCheck->ID == L_Button_Item && ItemCheck->Misc[12] == 300){
			
			//L_Button_Draw = ItemCheck;
			//LItemSpawned = true;
			
		//}
		//if(ItemCheck->ID == R_Button_Item && ItemCheck->Misc[12] == 400){
			
			//R_Button_Draw = ItemCheck;
			//RItemSpawned = true;
			
		//}
		
	//}
	
	
	//Creates item to draw to HUD

		//if(L_Button_Item != No_Button_Item && LItemSpawned == false){
	//if(LItemSpawned == false){
		
		//L_Button_Draw = Screen->CreateItem(L_Button_Item);
		
		//L_Button_Draw->Pickup = IP_DUMMY;
		//L_Button_Draw->X = -16;
		//L_Button_Draw->Y = - 3 * 16;
		//L_Button_Draw->Misc[12] = 300;
		
	//}
	
		//if(R_Button_Item != No_Button_Item && RItemSpawned == false){
	//if(RItemSpawned == false){
	
		//R_Button_Draw = Screen->CreateItem(R_Button_Item);
		
		//R_Button_Draw->Pickup = IP_DUMMY;
		//R_Button_Draw->X = -16;
		//R_Button_Draw->Y = - 3 * 16;
		//R_Button_Draw->Misc[12] = 400;
		
	//}
	
	//Draw items
		//if(L_Button_Item != No_Button_Item){
	//if(1 == 1){
		//Screen->FastTile(7, 7 * 16, -42, L_Button_Draw->Tile, L_Button_Draw->CSet, OP_OPAQUE);
	//}
	
		//if(R_Button_Item != No_Button_Item){
	//if(1 == 1){
		//Screen->FastTile(7, 9 * 16, -50, R_Button_Draw->Tile, R_Button_Draw->CSet, OP_OPAQUE);
	//}
	
	//Game->MCounter[31] = Screen->NumItems() + 255;
	//Game->Counter[31] = Screen->NumItems();
	
//}

//void oldLandRfunction(){	//trash this potentially
	
	//item L_Button_Draw;
	//item R_Button_Draw;
	
		//Checks for if the button items are already drawn
	//for(int l = Screen->NumItems(); l > 0; l--){
		//item ItemCheck = Screen->LoadItem(l);
	
		//if(ItemCheck->Misc[10] >= 20 && ItemCheck->Pickup == IP_DUMMY){
			
			//if(ItemCheck->ID == L_Button_Item && ItemCheck->Misc[10] == 20){
				//L_Button_Draw = ItemCheck;
			//}
			//else{
				//ItemCheck->X = -32;
				//ItemCheck->Y = -64;
				//ItemCheck->Pickup = IP_TIMEOUT;
			//}
			
			//if(ItemCheck->ID == R_Button_Item && ItemCheck->Misc[10] == 21){
				//R_Button_Draw = ItemCheck;
			//}
			//else{
				//ItemCheck->X = -32;
				//ItemCheck->Y = -64;
				//ItemCheck->Pickup = IP_TIMEOUT;
			//}
			
		//}

	//}
	
	
	//Creates item to draw to HUD
	//if(L_Button_Draw->Misc[10] != 20){
		
		//item L_Button_Draw = Screen->CreateItem(L_Button_Item);
		//L_Button_Draw->Pickup = IP_DUMMY;
		//L_Button_Draw->X = 7 * 16;
		//L_Button_Draw->Y = - 3 * 16;
		//L_Button_Draw->DrawStyle = DS_LINK;
		//L_Button_Draw->Misc[10] = 20;
		
	//}
	//if(R_Button_Draw->Misc[10] != 20){
		
		//item R_Button_Draw = Screen->CreateItem(R_Button_Item);
		//R_Button_Draw->Pickup = IP_DUMMY;
		//R_Button_Draw->X = 7 * 16;
		//R_Button_Draw->Y = - 3 * 16;
		//R_Button_Draw->DrawStyle = DS_LINK;
		//R_Button_Draw->Misc[10] = 20;
		
	//}
//}




//- Documentation for asignments -//

// -	Dmap Flags	- //
// Script 1 (11): Disable Gale Seed warping
// Script 2 (12):
// Script 3 (13):
// Script 4 (14):
// Script 5 (15):

// -	Screen Flags	- //
// Script 1 (2???): Pit side warp.		(Uses Side Warp A (can be changed))


// -	Screen D Array	- //
// Screen->D[0]: 
// Screen->D[1]: 
// Screen->D[2]: Boss music toggle
// Screen->D[3]: 
// Screen->D[4]: 
// Screen->D[5]: GB Chests
// Screen->D[]: 


// -	Combo Type	- //
// No Ground Enemies (128): Moosh Pits	(Uses Flag for alternative option)
// Script 1 (142): GB Cliffs			(Uses FFC identification)
// Script 2 (143): Shovel				
// Script 3 (144): Sideview Ladder		(Called by FFC with default conf, I believe)
// Script 4 (145):
// Script 5 (146):


// -	Combo Flag	- //
//General Purpose 1 (98): Moosh pits turn into lava (Only on Combo Type "128")
//General Purpose 1 (98): Sideview ladder (Only on Combo Type "144")
//General Purpose 2 (99): Shovel Secrets and Shovel->Undercombo
//General Purpose 3 (100):
//General Purpose 4 (101):
//General Purpose 5 (102): GB Power Bracelet


// -	Item Class	- //
//C-Itemclass 1:  Magic Cost Modifiers (Half magic, etc)
//C-Itemclass 2:  Power Bracelet
//C-Itemclass 3:  Ice Rods
//C-Itemclass 4:  Fire Rods
//C-Itemclass 5:
//C-Itemclass 6:
//C-Itemclass 7:
//C-Itemclass 8:
//C-Itemclass 9:
//C-Itemclass 10: Shovel
//C-Itemclass 11: Seed Satchel
//C-Itemclass 12: Seed Shooter
//C-Itemclass 13:
//C-Itemclass 14:
//C-Itemclass 15:
//C-Itemclass 16:
//C-Itemclass 17:
//C-Itemclass 18:
//C-Itemclass 19: Trade Quest Items		(Aren't really scripted)
//C-Itemclass 20: McGuffin Items		(Aren't really scripted)


// -	Counter	- //
// Script 1   (7):
// Script 2   (8):
// Script 3   (9):
// Script 4  (10):
// Script 5  (11): Ember Seeds
// Script 6  (12): Scent Seeds
// Script 7  (13): Pegasus Seeds
// Script 8  (14): Gale Seeds
// Script 9  (15): Mystery Seeds
// Script 10 (16):
// Script 11 (17):
// Script 12 (18):
// Script 13 (19):
// Script 14 (20):
// Script 15 (21):
// Script 16 (22):
// Script 17 (23):
// Script 18 (24):
// Script 19 (25):
// Script 20 (26): Retrivable Keys (One)
// Script 21 (27):
// Script 22 (28):
// Script 23 (29):
// Script 24 (30):
// Script 25 (31): Beta Testing Features (Currently)


// -	Link->Misc[]	- //
// 0: 
// 1:
// 2:
// 3:
// 4:
// 5:
// 6:
// 7:
// 8:
// 9:
// 10: Roc's Cape.
// 11:
// 12:
// 13:
// 14:
// 15:

*/

