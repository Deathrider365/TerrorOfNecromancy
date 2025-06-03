import "std.zh"
import "ffcscript.zh"
import "ghost.zh"
import "string.zh"


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Global Variables
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int SecretArray[65536];		//Array for the secrets that are Linked.
							//Each switch that sets off multiple secrets must share the same value.
							//There is no limit to the number of multiple screens that can be affected this way.
							int MooshPit[16];
//Constants 
//start
const int _MP_LASTX = 0;
const int _MP_LASTY = 1;
const int _MP_LASTDMAP = 2;
const int _MP_LASTSCREEN = 3;
const int _MP_ENTRYX = 4;
const int _MP_ENTRYY = 5;
const int _MP_ENTRYDMAP = 6;
const int _MP_ENTRYSCREEN = 7;
const int _MP_FALLX = 8;
const int _MP_FALLY = 9;
const int _MP_FALLTIMER = 10;
const int _MP_FALLSTATE = 11;
const int _MP_DAMAGETYPE = 12;
const int _MP_SLIDETIMER = 13;

const int MOOSHPIT_NO_GRID_SNAP = 0; //Set to 1 to prevent Link's falling sprite from snapping to the combo grid.
const int MOOSHPIT_ENABLE_SLIDEYPITS = 0; //Set to 1 if Link should slide into pits he's partially on
const int MOOSHPIT_NO_MOVE_WHILE_FALLING = 1; //Set to 1 if you don't want Link able to move while falling
const int MOOSHPIT_NO_REENTER_STAIRS = 1; //Set to 1 to prevent Link reentering stairs when respawning from a pit. This uses an FFC slot to run the script
const int MOOSHPIT_STUN_ENEMIES_WHILE_FALLING = 1; //Set to 1 to stun stunnable enemies while falling in a pit

const int CT_HOLELAVA = 128; //Combo type for pits (No Ground Enemies by default)
const int CF_LAVA = 98; //Combo flag marking pits as lava (Script 1 by default)

const int SPR_FALLHOLE = 88; //Sprite for Link falling in a hole
const int SPR_FALLLAVA = 89; //Sprite for Link falling in lava

const int SFX_FALLHOLE = 97; //Sound for falling in a hole
const int SFX_FALLLAVA = 0; //Sound for falling in lava

const int DAMAGE_FALLHOLE = 8; //How much damage pits deal (1/2 heart default)
const int DAMAGE_FALLLAVA = 16; //How much damage lava deals (1 heart default)

const int FFC_MOOSHPIT_AUTOWARPA = 32; //FFC that turns into an auto side warp combo when you fall in a pit
const int CMB_MOOSHPIT_AUTOWARPA = 2; //Combo number of an invisible Auto Side Warp A combo
const int SF_MISC_MOOSHPITWARP = 2; //Number of the screen flag under the Misc. section that makes pits warp (Script 1 by default)
								    //All pit warps use Side Warp A

const int MOOSHPIT_MIN_FALL_TIME = 60; //Minimum time for the pit's fall animation, to prevent repeated falling in pits
const int MOOSHPIT_EXTRA_FALL_TIME = 0; //Extra frames at the conclusion of the falling animation before Link respawns

//Width and height of Link's hitbox for colliding with pits
const int MOOSHPIT_LINKHITBOXWIDTH = 2;
const int MOOSHPIT_LINKHITBOXHEIGHT = 2;

//Width and height of Link's hitbox for colliding with pits/lava in sideview
const int MOOSHPIT_SIDEVIEW_LINKHITBOXWIDTH = 2;
const int MOOSHPIT_SIDEVIEW_LINKHITBOXHEIGHT = 2;

const int MOOSHPIT_SLIDEYPIT_FREQ = 3; //Link will be pushed into slideypits every 1/n frames
const int MOOSHPIT_SLIDEYPIT_MAXTIME = 20; //Link will be pushed into slideypits more intensely after n frames
const int MOOSHPIT_SLIDEYPIT_ACCELFREQ = 8; //How often Link accelerates when falling in the pit
//end

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Global Scripts
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
global script Active
{
    void run()
	{
		MooshPit_Init();
	    Game->LItems[0] |= LI_MAP;
		StartGhostZH();
        while(true)
		{
			UpdateGhostZH1();
			checkItemCycle();
			checkDungeon();
			MooshPit_Update();
            Waitdraw();
			UpdateGhostZH2();
            Waitframe();
        }
    }
	
//--L/R Item Cycling--//
	void checkItemCycle()
	{
	    if (Link->PressL) Link->SelectBWeapon(DIR_LEFT);
		if (Link->PressR) Link->SelectBWeapon(DIR_RIGHT);
	}
		
//--Checks For Map--//
	void checkDungeon()
	{
		int level = Game->GetCurLevel();
		
		if(!(Game->LItems[level] & LI_MAP))
		{
			Link->InputMap = false;
			Link->PressMap = false;
		}
	}

	
}

//--Moosh Pits--//				
int MooshPit_OnPit(int LinkX, int LinkY, bool countFFCs){ //start
	if(Link->Action==LA_FROZEN||Link->Action==LA_RAFTING||Link->Action==LA_INWIND)
		return -1;
	
	if(countFFCs){
		if(MooshPit_OnFFC(LinkX, LinkY))
			return -1;
	}
	
	bool sideview;
	if(Screen->Flags[SF_ROOMTYPE]&100b)
		sideview = true;
	//wew lad
	int width = MOOSHPIT_LINKHITBOXWIDTH;
	int height = MOOSHPIT_LINKHITBOXHEIGHT;
	
	int total;
	int solidTotal;
	
	for(int x=0; x<=1; x++){
		for(int y=0; y<=1; y++){
			int X; int Y;
			if(sideview){ //Hitbox functions differently in sideview
				width = MOOSHPIT_SIDEVIEW_LINKHITBOXWIDTH;
				height = MOOSHPIT_SIDEVIEW_LINKHITBOXHEIGHT;
				X = Floor(LinkX+7-width/2+(width-1)*x)+1;
				Y = Floor(LinkY+7-height/2+(height-1)*y)+1;
			}
			else{
				X = Floor(LinkX+7-width/2+(width-1)*x)+1;
				Y = Floor(LinkY+11-height/2+(height-1)*y)+1;
			}
			
			//If one corner of Link's hitbox is on a pit, flag that corner as covered
			if(Screen->ComboT[ComboAt(X, Y)]==CT_HOLELAVA){
				total |= 1<<(1+(x+y*2));
			}
			//If Link is on a solid combo, count that corner as a pit
			if(Screen->isSolid(X, Y)){
				solidTotal |= 1<<(x+y*2);
			}
		}
	}
	if(total>0) //Assuming Link is on at least one actual pit, add up the solid and nonsolid pits
		return (total>>1)|(solidTotal<<4);
	return -1;
}

bool MooshPit_OnFFC(int LinkX, int LinkY){
	for(int i=1; i<=32; i++){ //Cycle through every FFC
		ffc f = Screen->LoadFFC(i);
		//Check if the FFC is solid
		if(f->Data>0&&!f->Flags[FFCF_CHANGER]&&!f->Flags[FFCF_ETHEREAL]){
			//Check if Link collides with the FFC
			if(RectCollision(LinkX+4, LinkY+9, LinkX+11, LinkY+14, f->X, f->Y, f->X+f->EffectWidth-1, f->Y+f->EffectHeight-1)){
				return true;
			}
		}
	}
	//If Link doesn't collide with any FFC, return false
	return false;
}

void MooshPit_StunEnemies(){
	for(int i=Screen->NumNPCs(); i>=1; i--){ //Cycle through every enemy
		npc n = Screen->LoadNPC(i);
		//Make it so the enemy's stun never falls below 1
		n->Stun = Max(n->Stun, 1);
	}
}

void MooshPit_Init(){
	MooshPit[_MP_LASTX] = Link->X;
	MooshPit[_MP_LASTY] = Link->Y;
	MooshPit[_MP_LASTDMAP] = Game->GetCurDMap();
	MooshPit[_MP_LASTSCREEN] = Game->GetCurDMapScreen();
	MooshPit[_MP_ENTRYX] = Link->X;
	MooshPit[_MP_ENTRYY] = Link->Y;
	MooshPit[_MP_ENTRYDMAP] = Game->GetCurDMap();
	MooshPit[_MP_ENTRYSCREEN] = Game->GetCurDMapScreen();
	MooshPit[_MP_FALLSTATE] = 0;
	MooshPit[_MP_FALLTIMER] = 0;
	Link->CollDetection = true;
	Link->Invisible = false;
}

void MooshPit_Update(){
	int i;
	bool isWarp;
	if(Screen->Flags[SF_MISC]&(1<<SF_MISC_MOOSHPITWARP))
		isWarp = true;
	
	bool sideview;
	if(Screen->Flags[SF_ROOMTYPE]&100b)
		sideview = true;
	
	if(Link->Action!=LA_SCROLLING){
		//Update the entry point whenever the screen changes
		if(MooshPit[_MP_ENTRYDMAP]!=Game->GetCurDMap()||MooshPit[_MP_ENTRYSCREEN]!=Game->GetCurDMapScreen()){
			MooshPit[_MP_ENTRYX] = Link->X;
			MooshPit[_MP_ENTRYY] = Link->Y;
			MooshPit[_MP_ENTRYDMAP] = Game->GetCurDMap();
			MooshPit[_MP_ENTRYSCREEN] = Game->GetCurDMapScreen();
		}
		
		if(MooshPit[_MP_FALLSTATE]==0){ //Not falling in pit
			int onPit = MooshPit_OnPit(Link->X, Link->Y, true);
			//Check if slidey pits are enabled and it's not sideview
			if(MOOSHPIT_ENABLE_SLIDEYPITS&&!IsSideview()){
				if(Link->Z<=0&&onPit>-1){ //If Link is partially on a pit
					int slideVx; int slideVy;
					int reps = 1;
					//Check if it's a frame Link should be moved
					if(MooshPit[_MP_SLIDETIMER]%MOOSHPIT_SLIDEYPIT_FREQ==0||MooshPit[_MP_SLIDETIMER]>=MOOSHPIT_SLIDEYPIT_MAXTIME){
						if((onPit&0111b)==0111b){ //Going up-left
							slideVx = -1;
							slideVy = -1;
						}
						else if((onPit&1011b)==1011b){ //Going up-right
							slideVx = 1;
							slideVy = -1;
						}
						else if((onPit&1101b)==1101b){ //Going down-left
							slideVx = -1;
							slideVy = 1;
						}
						else if((onPit&1110b)==1110b){ //Going down-right
							slideVx = 1;
							slideVy = 1;
						}
						else if((onPit&0011b)==0011b){ //Going up
							slideVy = -1;
						}
						else if((onPit&1100b)==1100b){ //Going down
							slideVy = 1;
						}
						else if((onPit&0101b)==0101b){ //Going left
							slideVx = -1;
						}
						else if((onPit&1010b)==1010b){ //Going right
							slideVx = 1;
						}
						else if((onPit&0001b)==0001b){ //Going up-left
							slideVx = -1;
							slideVy = -1;
						}
						else if((onPit&0010b)==0010b){ //Going up-right
							slideVx = 1;
							slideVy = -1;
						}
						else if((onPit&0100b)==0100b){ //Going down-left
							slideVx = -1;
							slideVy = 1;
						}
						else if((onPit&1000b)==1000b){ //Going down-right
							slideVx = 1;
							slideVy = 1;
						}
						
						//DEBUG DRAWS
						//VX
						// Screen->DrawInteger(6, 0, 0, FONT_Z1, 0x01, 0x0F, -1, -1, slideVx, 0, 128);
						//VY
						// Screen->DrawInteger(6, 0, 8, FONT_Z1, 0x01, 0x0F, -1, -1, slideVy, 0, 128);
						//ONPIT BITS
						// Screen->DrawInteger(6, 0, 16, FONT_Z1, 0x01, 0x0F, -1, -1, (onPit&1000b)>>3, 0, 128);
						// Screen->DrawInteger(6, 8, 16, FONT_Z1, 0x01, 0x0F, -1, -1, (onPit&0100b)>>2, 0, 128);
						// Screen->DrawInteger(6, 16, 16, FONT_Z1, 0x01, 0x0F, -1, -1, (onPit&0010b)>>1, 0, 128);
						// Screen->DrawInteger(6, 24, 16, FONT_Z1, 0x01, 0x0F, -1, -1, (onPit&0001b), 0, 128);
						
						//If Link is over the max slide time, increase the speed every 4 frames
						if(MooshPit[_MP_SLIDETIMER]>=MOOSHPIT_SLIDEYPIT_MAXTIME)
							reps += Floor((MooshPit[_MP_SLIDETIMER]-MOOSHPIT_SLIDEYPIT_MAXTIME)/MOOSHPIT_SLIDEYPIT_ACCELFREQ);
					}
					
					for(i=0; i<reps; i++){
						if(slideVx<0&&CanWalk(Link->X, Link->Y, DIR_LEFT, 1, false)){
							Link->X--;
						}
						else if(slideVx>0&&CanWalk(Link->X, Link->Y, DIR_RIGHT, 1, false)){
							Link->X++;
						}
						if(slideVy<0&&CanWalk(Link->X, Link->Y, DIR_UP, 1, false)){
							Link->Y--;
						}
						else if(slideVy>0&&CanWalk(Link->X, Link->Y, DIR_DOWN, 1, false)){
							Link->Y++;
						}
					}
					MooshPit[_MP_SLIDETIMER]++;
				}
				else{
					MooshPit[_MP_SLIDETIMER] = 0;
				}
			}
			if(onPit>-1){
				//Combine solid combo bits with pit bits
				onPit |= (onPit>>4);
				//Remove non pit bits
				onPit &= 1111b;
			}
			if(Link->Z<=0&&onPit==15){ //If Link steps on a pit
				int underLink;
				if(!sideview){
					underLink = ComboAt(Link->X+8, Link->Y+12);
					if(Screen->ComboT[underLink]!=CT_HOLELAVA){
						for(i=0; i<4; i++){
							underLink = ComboAt(Link->X+15*(i%2), Link->Y+8+7*Floor(i/2));
							if(Screen->ComboT[underLink]==CT_HOLELAVA)
								break;
						}
					}
				}
				else{
					underLink = ComboAt(Link->X+8, Link->Y+8);
					if(Screen->ComboT[underLink]!=CT_HOLELAVA){
						for(i=0; i<4; i++){
							underLink = ComboAt(Link->X+15*(i%2), Link->Y+15*Floor(i/2));
							if(Screen->ComboT[underLink]==CT_HOLELAVA)
								break;
						}
					}
				}
			
				lweapon fall;
				
				//Check if the combo is lava
				if(ComboFI(underLink, CF_LAVA)){
					//Play sound and display animation
					Game->PlaySound(SFX_FALLLAVA);
					fall = CreateLWeaponAt(LW_SCRIPT10, Link->X, Link->Y);
					if(!MOOSHPIT_NO_GRID_SNAP){
						fall->X = ComboX(underLink);
						fall->Y = ComboY(underLink);
					}
					fall->UseSprite(SPR_FALLLAVA);
					fall->CollDetection = false;
					fall->DeadState = fall->ASpeed*fall->NumFrames;
				
					//Mark as lava damage
					MooshPit[_MP_DAMAGETYPE] = 1;
				}
				//Otherwise it's a pit
				else{
					//Play sound and display animation
					Game->PlaySound(SFX_FALLHOLE);
					fall = CreateLWeaponAt(LW_SCRIPT10, Link->X, Link->Y);
					if(!MOOSHPIT_NO_GRID_SNAP){
						fall->X = ComboX(underLink);
						fall->Y = ComboY(underLink);
						if(isWarp){
							Link->X = ComboX(underLink);
							Link->Y = ComboY(underLink);
						}
					}
					fall->UseSprite(SPR_FALLHOLE);
					fall->CollDetection = false;
					fall->DeadState = fall->ASpeed*fall->NumFrames;
				
					//Mark as hole damage
					MooshPit[_MP_DAMAGETYPE] = 0;
				}
				
				MooshPit[_MP_FALLX] = Link->X;
				MooshPit[_MP_FALLY] = Link->Y;
				
				//Cooldown should last as long as the fall animation
				MooshPit[_MP_FALLSTATE] = 1;
				MooshPit[_MP_FALLTIMER] = Max(MOOSHPIT_MIN_FALL_TIME, fall->DeadState+MOOSHPIT_EXTRA_FALL_TIME);
				
				//Render Link invisible and intangible
				Link->Invisible = true;
				Link->CollDetection = false;
				
				NoAction();
			}
			else if(MooshPit_OnPit(Link->X, Link->Y, false)==-1&&Link->Action!=LA_FROZEN){ //All other times, while Link is on solid ground, record Link's last position
				if(sideview){
					//Link has no Z value in sideview, so we check if he's on a platform instead
					if(OnSidePlatform(Link->X, Link->Y)){
						MooshPit[_MP_LASTDMAP] = Game->GetCurDMap();
						MooshPit[_MP_LASTSCREEN] = Game->GetCurDMapScreen();
						MooshPit[_MP_LASTX] = Link->X;
						MooshPit[_MP_LASTY] = Link->Y;
					}
				}
				else{
					if(Link->Z<=0){
						MooshPit[_MP_LASTDMAP] = Game->GetCurDMap();
						MooshPit[_MP_LASTSCREEN] = Game->GetCurDMapScreen();
						MooshPit[_MP_LASTX] = Link->X;
						MooshPit[_MP_LASTY] = Link->Y;
					}
				}
			}
		}
		else if(MooshPit[_MP_FALLSTATE]==1){ //Falling animation
			if(MooshPit[_MP_FALLTIMER]>0)
				MooshPit[_MP_FALLTIMER]--;
		
			if(MOOSHPIT_STUN_ENEMIES_WHILE_FALLING)
				MooshPit_StunEnemies();
			
			Link->Jump = 0;
			Link->Z = 0;
			
			//Keep Link invisible just in case
			Link->Invisible = true;
			Link->CollDetection = false;
			NoAction();
			if(MooshPit[_MP_FALLTIMER]==0){
				MooshPit[_MP_SLIDETIMER] = 0;
				if(!isWarp||MooshPit[_MP_DAMAGETYPE]==1){ //If the pit isn't a warp, deal damage and move Link back to the return point
					//If the entry would dump Link back in the pit, dump him out at the failsafe position
					if(MooshPit_OnPit(MooshPit[_MP_ENTRYX], MooshPit[_MP_ENTRYY], false)==15){
						if(MOOSHPIT_NO_REENTER_STAIRS){
							//Call a script to place an FFC under Link to prevent reentering stairs
							int scriptName[] = "MooshPit_StairsFix";
							int ffcNum = RunFFCScript(Game->GetFFCScript(scriptName), 0);
							if(ffcNum>0){
								ffc f = Screen->LoadFFC(ffcNum);
								f->Flags[FFCF_ETHEREAL] = false;
								f->X = MooshPit[_MP_LASTX];
								f->Y = MooshPit[_MP_LASTY];
							}
						}
						
						Link->X = MooshPit[_MP_LASTX];
						Link->Y = MooshPit[_MP_LASTY];
						
						//If the failsafe position was on a different screen, warp there
						if(Game->GetCurDMap()!=MooshPit[_MP_LASTDMAP]||Game->GetCurDMapScreen()!=MooshPit[_MP_LASTSCREEN]){
							Link->PitWarp(MooshPit[_MP_LASTDMAP], MooshPit[_MP_LASTSCREEN]);
						}
				
						Link->Invisible = false;
						Link->CollDetection = true;
					}
					else{
						if(MOOSHPIT_NO_REENTER_STAIRS){
							//Call a script to place an FFC under Link to prevent reentering stairs
							int scriptName[] = "MooshPit_StairsFix";
							int ffcNum = RunFFCScript(Game->GetFFCScript(scriptName), 0);
							if(ffcNum>0){
								ffc f = Screen->LoadFFC(ffcNum);
								f->Flags[FFCF_ETHEREAL] = false;
								f->X = MooshPit[_MP_ENTRYX];
								f->Y = MooshPit[_MP_ENTRYY];
							}
						}
						
						//Move Link to the entry and make him visible
						Link->X = MooshPit[_MP_ENTRYX];
						Link->Y = MooshPit[_MP_ENTRYY];
						
						Link->Invisible = false;
						Link->CollDetection = true;
					}
					
					//Subtract HP based on damage type
					if(MooshPit[_MP_DAMAGETYPE]==1)
						Link->HP -= DAMAGE_FALLLAVA;
					else
						Link->HP -= DAMAGE_FALLHOLE;
					//Play hurt sound and animation
					Link->Action = LA_GOTHURTLAND;
					Link->HitDir = -1;
					Game->PlaySound(SFX_OUCH);
					
					MooshPit[_MP_FALLSTATE] = 0;
				}
				else{
					MooshPit[_MP_FALLSTATE] = 2;
					MooshPit[_MP_FALLTIMER] = 1;
					ffc warp = Screen->LoadFFC(FFC_MOOSHPIT_AUTOWARPA);
					warp->Data = CMB_MOOSHPIT_AUTOWARPA;
					warp->Flags[FFCF_CARRYOVER] = false;
				}
			}
		}
		else if(MooshPit[_MP_FALLSTATE]==2){ //Just warped
			if(sideview){
				Link->X = MooshPit[_MP_FALLX];
				Link->Y = 0;
			}
			else{
				Link->X = MooshPit[_MP_FALLX];
				Link->Y = MooshPit[_MP_FALLY];
				Link->Z = 176;
			}
			Link->Invisible = false;
			Link->CollDetection = true;
			
			if(MOOSHPIT_NO_MOVE_WHILE_FALLING){
				MooshPit[_MP_FALLSTATE] = 3;
				NoAction();
			}
			else
				MooshPit[_MP_FALLSTATE] = 0;
			MooshPit[_MP_FALLTIMER] = 0;
		}
		else if(MooshPit[_MP_FALLSTATE]==3){ //Falling into a new room (no action)
			if(MOOSHPIT_STUN_ENEMIES_WHILE_FALLING)
				MooshPit_StunEnemies();
			
			NoAction();
			if(IsSideview()){
				if(OnSidePlatform(Link->X, Link->Y))
					MooshPit[_MP_FALLSTATE] = 0;
			}
			else{
				if(Link->Z<=0)
					MooshPit[_MP_FALLSTATE] = 0;
			}
		}
	}
}

void MooshPit_ResetEntry(){
	MooshPit[_MP_ENTRYX] = Link->X;
	MooshPit[_MP_ENTRYY] = Link->Y;
	MooshPit[_MP_ENTRYDMAP] = Game->GetCurDMap();
	MooshPit[_MP_ENTRYSCREEN] = Game->GetCurDMapScreen();
}

ffc script MooshPit_StairsFix{
	void run(){
		this->Flags[FFCF_ETHEREAL] = false;
		while(LinkCollision(this)){
			Waitframe();
		}
		this->X = 0;
		this->Y = 0;
		this->Data = 0;
	}
}
//end

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Free Form Combos
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//start Linked_Secrets
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Using ffc script Linked_Secrets
// --------------------------------------------------------------------------------------------------------------------
// Below: use with FFC to activate secret arrays across multiple screens and add secret activation sound
// FFCs can be configured as senders, receivers, or triggers
// When configured as sender:
// D0 = 1 (marks as sender)
// D1 = 0 (sets D2 to use combo numbers)
// D2 = Combo number that activates secret array (must be a trigger combo, i.e. weapon flag, step switch, treasure chest, lock block, etc.)
// D3 = Secret array (range of 0 - 65535; all FFCs connected to this number will be activated when one FFC with this number is triggered)
// D4 = 0 (not used for senders; standard secret flags and combo advancements still apply)
// D5 = Sound to play when triggered

// When configured as receiver:
// D0 = 0 (marks as receiver)
// D1 = 1 (enables receiver, sets D2 to use combo flags)
// D2 = Combo flag activated by secret array (99-102 are safest)
// D3 = Secret array (same as above)
// D4 = Distance in combo list from current combo to secret combo (ex: entering 3 changes combo 124 to 127, -11 changes combo 232 to 221, etc.)
// D5 = 0 (sound should be attached to senders and triggers)

// When configured as trigger:
// D0 = 1 (marks as trigger)
// D1 = LWeapon ID
// See LW_* in std_constants.zh for LWeapon types
// D2 = Combo flag activated by secret array (same as above)
// D3 = Secret array (same as above)
// D4 = Distance in combo list from current combo to secret combo (same as above)
// D5 = Sound to play when triggered
// Senders and receivers require no interaction; triggers must be placed where they can be hit by Link's weapon
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

ffc script Linked_Secrets
{		
	void run(bool first, int type, int Trigger, int index, int secret_offset, int sfx)
	{
		bool isHit = false;
		int ComboD[176];
		if(type == 0)
			for(int i = 0; i < 176; i++)
				if(Screen->ComboD[i] == Trigger)ComboD[i] = Screen->ComboD[i];
			//Wait for it to be triggered.
		if(first)
		{
			if(SecretArray[index])
				isHit = true;
			while(!isHit)
			{
				if(type == 0)
					for(int i = 0; i < 176; i++)
						if(Screen->ComboD[i] != Trigger && ComboD[i] == Trigger)isHit = true;
				else if(type != 0)
				{
					//Scan lweapons and wait for right one to impact.
					for (int i = 1; i <= Screen->NumLWeapons(); i++)
					{
						lweapon w = Screen->LoadLWeapon(i);
						if (w->ID == type && Collision(this, w))isHit = true;
					}
				}
				Waitframe();
			}
		}
		else
			while(SecretArray[index] == 0)
			{
				Waitframe();
			}
		//Play secret sound.
		if(sfx != 0 && !SecretArray[index])
			Game->PlaySound(sfx);
		if(!SecretArray[index])
			SecretArray[index]=1;			//Change all flagged combos by offset amount.
		if(type!=0)
		{
		for (int i = 0; i < 175; i++ )
			if(ComboFI(i,Trigger))
			{
				Screen->ComboD[i] += secret_offset;
				Screen->ComboF[i] = 0;
				Screen->ComboI[i] = 0;
			}
		}
		
		else
		{	
			Screen->TriggerSecrets();
			Screen->State[ST_SECRET]= true;
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//end

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



int Switch_Pressed(int x, int y, bool noLink) //start
{
	int xOff = 0;
	int yOff = 4;
	int xDist = 8;
	int yDist = 8;
	if(Abs(Link->X + xOff - x) <= xDist && Abs(Link->Y + yOff - y) <= yDist && Link->Z == 0 && !noLink)
		return 1;
	if(Screen->MovingBlockX > -1)
	{
		if(Abs(Screen->MovingBlockX - x) <= 8 && Abs(Screen->MovingBlockY - y) <= 8)
			return 1;
	}
	
	if(Screen->isSolid(x+4, y+4) || Screen->isSolid(x+12, y+4) ||
	   Screen->isSolid(x+4, y+12) || Screen->isSolid(x+12, y+12))
	{
		return 2;
	}
	
	return 0;
} //end

ffc script Switch_Secret //start
{
	void run(int perm, int id, int sfx)
	{
		int d;
		int db;
		if(id > 0)
		{
			d = Floor((id - 1) / 16);
			db = 1<<((id - 1) % 16);
		}
		
		if(perm)
		{
			if(id > 0)
			{
				if(Screen->D[d]&db)
				{
					this->Data++;
					Screen->TriggerSecrets();
					Quit();
				}
			}
			
			else if(Screen->State[ST_SECRET])
			{
				this->Data++;
				Quit();
			}
		}
		
		while(!Switch_Pressed(this->X, this->Y, false))
		{
			Waitframe();
		}
		
		this->Data++;
		Screen->TriggerSecrets();
		Game->PlaySound(SFX_SWITCH_PRESS);
		if(sfx == 0)
			Game->PlaySound(SFX_SECRET);
		else if(sfx > 0)
			Game->PlaySound(sfx);
		if(perm)
		{
			if(id > 0)
				Screen->D[d]|=db;
			else
				Screen->State[ST_SECRET] = true;
		}
	}
} //end

ffc script Switch_Remote //start
{
	void run(int pressure, int id, int flag, int sfx)
	{
		bool noLink;
		if (pressure == 2)
		{
			pressure = 1;
			noLink = true;
		}
		
		if (pressure == 3)
		{
			pressure = 0;
			noLink = true;
		}
		
		int data = this->Data;
		int i; int j; int k;
		int d;
		int db;
		if(id > 0)
		{
			d = Floor((id - 1) / 16);
			db = 1<<((id - 1) % 16);
		}
		
		int comboD[176];
		for(i = 0; i < 176; i++)
			if(Screen->ComboF[i] == flag)
			{
				comboD[i] = Screen->ComboD[i];
				Screen->ComboF[i] = 0;
			}
		
		if(id > 0)
			if(Screen->D[d]&db)
			{
				this->Data = data + 1;
				for(i = 0; i < 176; i++)
					if(comboD[i] > 0)
						Screen->ComboD[i] = comboD[i] + 1;
				Quit();
			}
		
		if(pressure)
			while(true)
			{
				while(!Switch_Pressed(this->X, this->Y, noLink))
				{
					Waitframe();
				}
				this->Data = data + 1;
				Game->PlaySound(SFX_SWITCH_PRESS);
				for(i = 0; i < 176; i++)
					if(comboD[i] > 0)
						Screen->ComboD[i] = comboD[i] + 1;
						
				while(Switch_Pressed(this->X, this->Y, noLink))
				{
					Waitframe();
				}
				this->Data = data;
				Game->PlaySound(SFX_SWITCH_RELEASE);
				for(i = 0; i < 176; i++)
					if(comboD[i] > 0)
						Screen->ComboD[i] = comboD[i];
			}
		
		else
		{
			while(!Switch_Pressed(this->X, this->Y, noLink))
			{
				Waitframe();
			}
			this->Data = data+1;
			Game->PlaySound(SFX_SWITCH_PRESS);
			if(sfx >= 0)
				Game->PlaySound(sfx);
			else
				Game->PlaySound(SFX_SECRET);
			for(i = 0; i < 176; i++)
				if(comboD[i] > 0)
					Screen->ComboD[i] = comboD[i] + 1;
			if(id > 0)
				Screen->D[d] |= db;
		}
	}
} //end

ffc script Switch_HitAll //start
{
	void run(int switchCmb, int pressure, int perm, int id, int flag, int sfx, int switchID)
	{
		bool noLink;
		if(pressure == 2)
		{
			pressure = 1;
			noLink = true;
		}
		
		int i; 
		int j; 
		int k;
		int d;
		int db;
		
		if(flag == 0)
			id = 0;
			
		int comboD[176];
		if(id > 0)
		{
			d = Floor((id - 1) / 16);
			db = 1<<((id - 1) % 16);
			for(i = 0; i < 176; i++)
				if(Screen->ComboF[i] == flag)
				{
					comboD[i] = Screen->ComboD[i];
					Screen->ComboF[i] = 0;
				}
		}
		
		int switches[34];
		int switchD[34];
		int switchDB[34];
		
		switchD[0] = switchID;
		bool switchesPressed[34];
		k = SizeOfArray(switches) - 2;
		
		for(i = 0; i < 176 && switches[0] < k; i++)
			if(Screen->ComboD[i] == switchCmb)
			{
				j = 2 + switches[0];
				switches[j] = i;
				if(!pressure && switchID > 0)
				{
					switchD[j] = Floor((switchID + switches[0] - 1) / 16);
					switchDB[j] = 1<<((switchID + switches[0] - 1) % 16);
					if(Screen->D[switchD[j]]&switchDB[j])
					{
						switchesPressed[j] = true;
						Screen->ComboD[i] = switchCmb+1;
						switches[1]++;
					}
				}
				switches[0]++;
			}
		
		if(perm)
		{
			if(id > 0)
			{
				if(Screen->D[d]&db)
					for(i = 2; i < switches[0] + 2; i++)
					{
						Screen->ComboD[switches[i]] = switchCmb + 1;
						switchesPressed[i] = true;
					}
					for(i = 0; i < 176; i++)
						if(comboD[i] > 0)
							Screen->ComboD[i] = comboD[i] + 1;

					while(true)
					{
						Switches_Update(switches, switchD, switchDB, switchesPressed, switchCmb, false, noLink);
						Waitframe();
					}
			}
			if(Screen->State[ST_SECRET])
			{
				for(i = 2; i < switches[0] + 2; i++)
				{
					Screen->ComboD[switches[i]] = switchCmb + 1;
					switchesPressed[i] = true;
				}
				while(true)
				{
					Switches_Update(switches, switchD, switchDB, switchesPressed, switchCmb, false, noLink);
					Waitframe();
				}
			}
		}
		
		if(pressure)
		{
			while(switches[1] < switches[0])
			{
				Switches_Update(switches, switchD, switchDB, switchesPressed, switchCmb, true, noLink);
				Waitframe();
			}
			if(id > 0)
			{
				if(sfx>0)
					Game->PlaySound(sfx);
				else
					Game->PlaySound(SFX_SECRET);
				for(i = 0; i < 176; i++)
					if(comboD[i] > 0)
						Screen->ComboD[i] = comboD[i] + 1;
			}
			
			else
			{
				if(sfx > 0)
					Game->PlaySound(sfx);
				else
					Game->PlaySound(SFX_SECRET);
				Screen->TriggerSecrets();
			}
			if(perm)
				if(id > 0)
					Screen->D[d] |= db;
				else
					Screen->State[ST_SECRET] = true;
		}
		
		else
		{
			while(switches[1] < switches[0])
			{
				Switches_Update(switches, switchD, switchDB, switchesPressed, switchCmb, false, noLink);
				Waitframe();
			}
			
			if(id > 0)
			{
				if(sfx > 0)
					Game->PlaySound(sfx);
				else
					Game->PlaySound(SFX_SECRET);
				for(i = 0; i < 176; i++)
					if(comboD[i] > 0)
						Screen->ComboD[i] = comboD[i] + 1;
			}
			
			else
			{
				if(sfx > 0)
					Game->PlaySound(sfx);
				else
					Game->PlaySound(SFX_SECRET);
				Screen->TriggerSecrets();
			}
			
			if(perm)
				if(id > 0)
					Screen->D[d] |= db;
				else
					Screen->State[ST_SECRET] = true;
		}
		
		while(true)
		{
			Switches_Update(switches, switchD, switchDB, switchesPressed, switchCmb, false, noLink);
			Waitframe();
		}
	}
	
	void Switches_Update(int switches, int switchD, int switchDB, bool switchesPressed, int switchCmb, bool pressure, bool noLink)
	{
		if(pressure)
			switches[1] = 0;
			
		for(int i = 0; i < switches[0]; i++)
		{
			int j = i + 2;
			int k = switches[j];
			int p = Switch_Pressed(ComboX(k), ComboY(k), noLink);
			if(p)
			{
				if(p != 2)
					Screen->ComboD[k] = switchCmb + 1;
				if(!switchesPressed[j])
				{
					Game->PlaySound(SFX_SWITCH_PRESS);
					if(switchD[0] > 0)
						Screen->D[switchD[j]] |= switchDB[j];
						
					switchesPressed[j] = true;
					if(!pressure)
						switches[1]++;
				}
				if(pressure)
					switches[1]++;
					
			}
			else
				if(switchesPressed[j])
					if(pressure)
					{
						Game->PlaySound(SFX_SWITCH_RELEASE);
						Screen->ComboD[k] = switchCmb;
						switchesPressed[j] = false;
					}
					else
						if(Screen->ComboD[k] != switchCmb + 1)
							Screen->ComboD[k] = switchCmb + 1;
		}
	}
} //end

ffc script Switch_Trap //start
{
	void run(int enemyid, int count)
	{
		while(!Switch_Pressed(this->X, this->Y, false))
		{
			Waitframe();
		}
		
		this->Data++;
		Game->PlaySound(SFX_SWITCH_PRESS);
		Game->PlaySound(SFX_SWITCH_ERROR);
		for(int i = 0; i < count; i++)
		{
			int pos = Switch_GetSpawnPos();
			npc n = CreateNPCAt(enemyid, ComboX(pos), ComboY(pos));
			Game->PlaySound(SFX_FALL);
			n->Z = 176;
			Waitframes(20);
		}
	}
	
	int Switch_GetSpawnPos()
	{
		int pos;
		bool invalid = true;
		int failSafe = 0;
		while(invalid && failSafe < 512)
		{
			pos = Rand(176);
			if(Switch_ValidSpawn(pos))
				return pos;
		}
		for(int i = 0; i < 176; i++)
		{
			pos = i;
			if(Switch_ValidSpawn(pos))
				return pos;
		}
	}
	
	bool Switch_ValidSpawn(int pos)
	{
		int x = ComboX(pos);
		int y = ComboY(pos);
		if(Screen->isSolid(x+4, y+4) || Screen->isSolid(x+12, y+4) 
		   || Screen->isSolid(x+4, y+12) || Screen->isSolid(x+12, y+12))
		{
			return false;
		
		}
		if(ComboFI(pos, CF_NOENEMY)||ComboFI(pos, CF_NOGROUNDENEMY))
			return false;
		int ct = Screen->ComboT[pos];
		
		if(ct == CT_NOENEMY || ct == CT_NOGROUNDENEMY || ct == CT_NOJUMPZONE)
			return false;
			
		if(ct == CT_WATER || ct == CT_LADDERONLY || ct == CT_HOOKSHOTONLY || ct == CT_LADDERHOOKSHOT)
			return false;
			
		if(ct == CT_PIT || ct == CT_PITB || ct == CT_PITC || ct == CT_PITD || ct == CT_PITR)
			return false;
			
		return true;
	}
} //end

ffc script Switch_Sequential //start
{
	void run(int flag, int perm, int sfx)
	{
		int i; int j; int k;
		int switches[34];
		int switchCmb[34];
		int switchMisc[8];
		
		bool switchesPressed[34];
		k = SizeOfArray(switches) - 2;
		
		for(i = 0; i < 176 && switches[0] < k; i++)
		{
			if(Screen->ComboF[i] == flag)
			{
				j = 2 + switches[0];
				switches[j] = i;
				switchCmb[j] = Screen->ComboD[i];
				switches[0]++;
			}
		}
		
		int switchOrder[34];
		Switches_Organize(switches, switchOrder);
		if(perm && Screen->State[ST_SECRET])
		{
			for(i=0; i<switches[0]; i++)
				switchesPressed[i+2] = true;

			while(true)
			{
				Switches_Update(switches, switchesPressed, switchOrder, switchCmb, switchMisc, false);
				Waitframe();
			}
		}
		
		while(switches[1] < switches[0])
		{
			Switches_Update(switches, switchesPressed, switchOrder, switchCmb, switchMisc, true);
			if(switchMisc[0] == 1)
			{
				switchMisc[0] = 0;
				for(i = 0; i < 30; i++)
				{
					Switches_Update(switches, switchesPressed, switchOrder, switchCmb, switchMisc, false);
					Waitframe();
				}
				while(Switches_LinkOn(switches))
				{
					Switches_Update(switches, switchesPressed, switchOrder, switchCmb, switchMisc, false);
					Waitframe();
				}
			}
			
			Waitframe();
		}
		
		if(sfx > 0)
			Game->PlaySound(sfx);
			
		else
			Game->PlaySound(SFX_SECRET);
			
		Screen->TriggerSecrets();
		
		if(perm)
			Screen->State[ST_SECRET] = true;
			
		for(i = 0; i < switches[0]; i++)
			switchesPressed[i+2] = true;
			
		while(true)
		{
			Switches_Update(switches, switchesPressed, switchOrder, switchCmb, switchMisc, false);
			Waitframe();
		}
		
	}
	
	void Switches_Organize(int switches, int switchOrder)
	{
		bool banned[34];
		for(int j = 0; j < switches[0]; j++)
		{
			int lowest = -1;
			int lowestIndex = -1;
			for(int i = 0; i < switches[0]; i++)
			{
				int c = Screen->ComboD[switches[i + 2]];
				if(c != -1 && !banned[i + 2])
					if(lowest == -1 || c < lowest)
					{
						lowest = c;
						lowestIndex = i + 2;
					}
			}
			
			switchOrder[j] = lowestIndex;
			banned[lowestIndex] = true;
		}
	}
	
	bool Switches_LinkOn(int switches)
	{
		for(int i = 0; i < switches[0]; i++)
		{
			int j = i + 2;
			int k = switches[j];
			int p = Switch_Pressed(ComboX(k), ComboY(k), false);
			if(p == 1)
				return true;
		}
		return false;
	}
	
	void Switches_Update(int switches, bool switchesPressed, int switchOrder, int switchCmb, int switchMisc, bool canPress)
	{
		bool reset;
		for(int i = 0; i < switches[0]; i++)
		{
			int j = i+2;
			int k = switches[j];
			int p = Switch_Pressed(ComboX(k), ComboY(k), false);
			if(!switchesPressed[j])
			{
				if(p != 2)
					Screen->ComboD[k] = switchCmb[j];
					
				if(p && canPress)
					if(j == switchOrder[switches[1]])
					{
						switches[1]++;
						Game->PlaySound(SFX_SWITCH_PRESS);
						switchesPressed[j] = true;
					}
					
					else
					{
						switches[1] = 0;
						Game->PlaySound(SFX_SWITCH_ERROR);
						reset = true;
					}
			}
			
			else
			{
				if(p != 2)
					Screen->ComboD[k] = switchCmb[j] + 1;
				if(p == 0 && canPress)
				{
					Game->PlaySound(SFX_SWITCH_RELEASE);
					switchesPressed[j] = false;
				}
			}
		}
		
		if(reset)
		{
			switchMisc[0] = 1;
			for(int i = 0; i < switches[0]; i++)
			{
				int j = i + 2;
				int k = switches[j];
				int p = Switch_Pressed(ComboX(k), ComboY(k), false);
				switchesPressed[j] = false;
			}
		}
	}
} //end

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Handles changing combos from one to another.
//D0 What weapon triggers this ffc. See std_constants for list of lweapons.
//D1 What flag is triggered by this ffc. All combos with this flag will be changed whether flag is inherent or placed.
//D2 Whether change is permanent. Set to non-zero for permanence.
//   Can have up to 8 permanent changes per screen.
//D3 How many combos between original combo and desired combo. Can be positive or negative.
//   Done this way so you don't have to place the combo next in the list. 
//   It can be anywhere, even before the original combo.
//    Example: You mark a 2x2 group of shutter combos with flag 16.
// Next to those wall combos in the combo list is a 2 x 2 group of door combos.
// Each door combo is 2 greater than the original, so secret_offset would be 2.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

ffc script Secret_Combo
{
	void run(int lw, int flag, int perm, int secret_offset)
	{
        bool isHit;								//If this combo has already been triggered, run the script.
        if(Screen->D[perm])isHit= true;			//Wait for it to be triggered.
			while(!isHit)						//Scan lweapons and wait for right one to impact.
			{
				for (int i = 1; i <= Screen->NumLWeapons(); i++)
				{
					lweapon w = Screen->LoadLWeapon(i);
					if (w->ID == lw && Collision(this, w))isHit = true;
				}
				Waitframe();
			}

        Game->PlaySound(SFX_SECRET);	  		//Play secret sound.
        for (int i = 0; i < 175; i++)           //Change all flagged combos by offset amount.
		{
            if(ComboFI(i, flag))
			{
				Screen->ComboD[i] += secret_offset;
				Screen->ComboF[i] = 0;
				Screen->ComboI[i] = 0;
            }
        }
	    //If not permanent, reset script.
        if(!perm)isHit = false;					//Otherwise, save its activation.
        else
            Screen->D[perm] = 1;
    }
} 

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//D0- Combo ID to watch. Events happen if it changes.
//D1- Sound to be made, if any. Set to zero for no sound.
//D2- Number of triggers in the room.
//D3- Whether screen secrets are triggered.
//D4- Screen->D register to store secrets in.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

ffc script Combo_Change
{
    void run(int comboid, int sfx, int numTriggers, bool secret,int perm)
	{
        bool isBlock[176];
        bool SoundMade[176];
        bool playSound=false;
        int numChanged;
		bool triggered = false;
        //Store current location of correct combos.
        //Make sure it knows sound hasn't been made.
		
        for(int i = 0; i < 176; i++)
		{
            SoundMade[i] = false;
            if(Screen->ComboD[i] == comboid)isBlock[i]= true;
        }
		
        //Secrets have been triggered, so do that.
		if (Screen->D[perm])triggered = true;
		
        while(!triggered)
		{
            //Scan all combos.
            //If combo at position is no longer the right combo and a sound hasn't been made, make one if desired.            
            for(int i = 0; i < 176; i++)
			{
                if(isBlock[i] && !SoundMade[i] && Screen->ComboD[i] != comboid)
				{
                    SoundMade[i] = true;
                    if(sfx > 0)playSound = true;
                    //If secrets should be triggered, track how many have been switched.
					if(secret)numChanged++;
                }
            }
			
            //Make a sound if you want.
            if(playSound)
			{
                Game->PlaySound(sfx);
                playSound = false;
            }
            //If all triggers have been hit and secrets should be activated.
			if(numChanged == numTriggers && secret)
			triggered = true;
            Waitframe();
        }
		
        //Trigger screen secrets, save permanence.
		Game->PlaySound(SFX_SECRET);
		Screen->TriggerSecrets();
		Screen->State[ST_SECRET] = true;
		Screen->D[perm]= 1;
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Compass Beep
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
const int COMPASS_BEEP = 93; //Set this to the SFX id you want to hear when you have the compass,

//Instructions:
//1.- Compile and add this to your ZQuest buffer.
//2.- Add an FFC with this script attached to the screen where you want to hear the compass beep. 
//3.- Let the script do the rest.

//How does it work:
//The script checks if ANY of the following has been done:
//a) Item or Special Item has been picked up.
//b) Any type of chest has been opened.
//c) If NOTHING of the above has been done, the script runs. Otherwise, no SFX is heard. 

ffc script CompassBeep
{
     void run()
	 {
          if(!Screen->State[ST_ITEM] &&
             !Screen->State[ST_CHEST] &&
             !Screen->State[ST_LOCKEDCHEST] &&
             !Screen->State[ST_BOSSCHEST] &&
             !Screen->State[ST_SPECIALITEM] && (Game->LItems[Game->GetCurLevel()] & LI_COMPASS))
		  { 
               Game->PlaySound(COMPASS_BEEP);
          }
     }
}
 
//Instructions:
//1.- Compile and add this to your ZQuest buffer.
//2.- Add an FFC with this script attached to the screen where you want to hear the compass beep. 
//3.- The following arguments are for cases where you have more than one item on a same screen (YES, it is possible).
 
// D0: Set this to 1 if you have a Normal Item set.
// D1: Set this to 1 if you have a Special Item set.
// D2: Set this to 1 if you have a Normal Chest set.
// D3: Set this to 1 if you have a Locked Chest set.
// D4: Set this to 1 if you have a Boss Chest set.
 
//How does it work:
//The script checks if ANY of the following is true.
//a) Depending on the Argument settings, it will check if the condition is met.
//b) If so, it will play the sound.
 
//const int COMPASS_SFX = 93; //Set this to the SFX id you want to hear when you have the compass.
ffc script NyroxCompassBeep
{
     void run(int normalItem, int specialItem, int normalChest, int lockedChest, int bossChest)
	 {
          if(GetLevelItem(LI_COMPASS))
               if(!Screen->State[ST_ITEM] && (normalItem == 1))
                    Game->PlaySound(COMPASS_SFX);
               else if(!Screen->State[ST_SPECIALITEM]&& (specialItem == 1))
					Game->PlaySound(COMPASS_SFX);
               else if(!Screen->State[ST_CHEST]&& (normalChest == 1))
                    Game->PlaySound(COMPASS_SFX);
               else if (!Screen->State[ST_LOCKEDCHEST] && (lockedChest == 1))
                    Game->PlaySound(COMPASS_SFX);
               else if(!Screen->State[ST_BOSSCHEST]&& (bossChest == 1))
                    Game->PlaySound(COMPASS_SFX);
     }
}

ffc script OpenForItemID
{
    void run(int itemid, bool perm)
    {
        if(Screen->State[ST_SECRET]) Quit(); //already triggered
        while(true)
        {
            if(Link->Item[itemid])
            {
                Screen->TriggerSecrets();
                if(perm) Screen->State[ST_SECRET] = true;
                return;
            }
            Waitframe();
        }
    }
}

ffc script EndCutscene
{
    void run(int msgid, int startdmap, int startscreen)
    {
        Link->Y = 96;
        Link->X = 120;
        Link->Dir = DIR_UP;
        Screen->Message(msgid);
		Waitframe();
        Game->ContinueDMap = startdmap;
        Game->ContinueScreen = startscreen;
		runCredits(1, FONT_Z3, 16);
        Game->End();
    }

}

ffc script bossstring
{
    void run(int m)
    {
		Waitframes(4);
		if (EnemiesAlive())
			Screen->Message(m);
    }
}





