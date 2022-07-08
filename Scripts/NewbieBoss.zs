//Three colors used for the lasers
const int C_EZB_LASER1 = 0x77;
const int C_EZB_LASER2 = 0x76;
const int C_EZB_LASER3 = 0x7C;

//Three colors used for shockwaves
const int C_EZB_SHOCKWAVE1 = 0x77;
const int C_EZB_SHOCKWAVE2 = 0x76;
const int C_EZB_SHOCKWAVE3 = 0x7C;

const int SFX_EZB_TELEPORT = 32; //Sound when a boss teleports
const int SFX_EZB_LASER = 37; //Sound when a laser is fired
const int SFX_EZB_SUMMON = 56; //Sound for summoning enemies
const int SFX_EZB_DASH = 1; //Sound when dashing
const int SFX_EZB_BACKSTEP = 1; //Sound when backstepping
const int SFX_EZB_SHOCKWAVE = 2; //Sound of the boss's shockwaves
const int SFX_EZB_SHAKE = 3; //Sound of the ground shaking after a big jump
const int SFX_EZB_BARRIERSHIFT = 56; //Sound of the enemy changing forms

const int EZB_SUMMON_CAP = 8; //Max number of enemies summoned by each instance of the script
const int EZB_TOTAL_SUMMON_CAP = 40; //Max number of enemies onscreen at a time

const int EZB_DONT_REPEAT_LAST_ATTACK = 1; //If 1, the enemy will try not to repeat attacks
const int EZB_DO_WINDUP_SHAKE = 2; //0 - no shake, 1 - shake on strong attack, 2 - shake on medium attack
const int EZB_TELEPORT_TYPE = 1; //0 - Flicker, 1 - Sprite stretch, 2 - Combo offset
const int EZB_ENABLE_SPEEDTRAILS = 1; //If 1, faster movement attacks will have speed trails behind the enemy
const int EZB_ALWAYS_FAKE_Z = 0; //If 1, the Fake Z axis flag will always be set

const int EZB_WINDUP_ATTACK = 16; //Delay before a weak attack
const int EZB_WINDUP_ATTACK_MED = 32; //Delay before a medium attack
const int EZB_WINDUP_ATTACK_STRONG = 64; //Delay before a stronger attack (the boss shakes)

const int EZB_FLYING_ZPOS = 8; //Z position for flying bosses

const int LAYER_EZB_LASER = 3; //Layer lasers are drawn to

const int SPR_EZB_DEATHEXPLOSION = 0; //Sprite to use for death explosions (0 for ZC default)
const int WIDTH_EZB_DEATHEXPLOSION = 2; //Tile width for death explosions
const int HEIGHT_EZB_DEATHEXPLOSION = 2; //Tile height for death explosions
const int EZB_DEATH_FLASH = 1; //Set to 1 to make the enemy flash during death animations
const int LW_EZB_DEATHEXPLOSION = 40; //LWeapon type used for death explosions. Script 10 by default

const int EZBF_4WAY         = 00000000001b; //1
const int EZBF_8WAY         = 00000000010b; //2
const int EZBF_FLYING       = 00000000100b; //4
const int EZBF_AQUATIC      = 00000001000b; //8
const int EZBF_NOFALL       = 00000010000b; //16
const int EZBF_EXPLODEEATH  = 00000100000b; //32
const int EZBF_FACELINK     = 00001000000b; //64
const int EZBF_UNBLOCKABLE  = 00010000000b; //128
const int EZBF_KNOCKBACK    = 00100000000b; //256
const int EZBF_NOCOLL       = 01000000000b; //512
const int EZBF_NOSTUN       = 10000000000b; //1024

//NOTE: To set shave offsets, set the enemy's Attribute 5 to (ShaveX+ShaveY*16)
ffc script EZBoss{
	void run(int enemyid){
		int i; int j; int k; int m; int angle; int dist; int x; int y;
		
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		npc summons[256];
		npc enem;
		eweapon e;
		
		int barrierShift[312];
		
		for(i=0; i<12; i++){
			barrierShift[300+i] = ghost->Attributes[i];
		}
		int movementStyle = barrierShift[300];
		int attack1 = barrierShift[301];
		int attack2 = barrierShift[302];
		int attack3 = barrierShift[303];
        int shaveHitbox = barrierShift[304];
		int special = barrierShift[305];
		int size = barrierShift[306];
		int fireSFX = barrierShift[307];
		int fireSPR = barrierShift[308];
		int flags = barrierShift[309];
		
		int constantAttack;
		int doConstantAttack;
		
		//Certain attacks in Attack 1 do a constant attack instead
		//This is triggered at certain parts of the enemy's walk pattern
		if(attack1==44)
			constantAttack = 44;
		else if(attack1==45)
			constantAttack = 45;
		else if(attack1==46)
			constantAttack = 46;
		else if(attack1==47)
			constantAttack = 47;
		else if(attack1==48)
			constantAttack = 48;
		
		if(attack1==50||attack1==51){
			EZB_Barriershift_Store(ghost, special, barrierShift);
			if(attack1==51)
				barrierShift[200] = 2;
		}
		
		//If there's a constant attack, shift all other attacks down
		if(constantAttack>0||barrierShift[200]){
			attack1 = attack2;
			attack2 = attack3;
			attack3 = 0;
		}
		
        int shaveX = shaveHitbox&1111b;
        int shaveY = Floor(shaveHitbox>>4)&1111b;
		
		//An enemy with no collision uses stun to turn it off and so cannot be stunned normally
		if(!(flags&EZBF_NOCOLL)&&!(flags&EZBF_NOSTUN)){
			Ghost_SetFlag(GHF_STUN);
			Ghost_SetFlag(GHF_CLOCK);
		}
		
		int w = size&1111b;
		int h = (size>>4)&1111b;
		if(h==0)
			h = w;
		w = Clamp(w, 1, 4);
		h = Clamp(h, 1, 4);
		
		barrierShift[310] = ghost->Attributes[10];
		int combo = barrierShift[310];
		Ghost_Transform(this, ghost, -1, -1, w, h);
		Ghost_SetHitOffsets(ghost, shaveY, shaveY, shaveX, shaveX);
		
		if(flags&EZBF_8WAY)
			Ghost_SetFlag(GHF_8WAY);
		else if(flags&EZBF_4WAY)
			Ghost_SetFlag(GHF_4WAY);
		if(flags&EZBF_NOFALL)
			Ghost_SetFlag(GHF_NO_FALL);
		if(flags&EZBF_FLYING){
			Ghost_SetFlag(GHF_IGNORE_ALL_TERRAIN);
			Ghost_SetFlag(GHF_FLYING_ENEMY);
			this->Flags[FFCF_OVERLAY] = true;
			if(EZB_FLYING_ZPOS&&(flags&EZBF_NOFALL)&&!IsSideview()){
				Ghost_SetFlag(GHF_FAKE_Z);
				Ghost_Z = 8;
			}
		}
		else if(flags&EZBF_AQUATIC){
			Ghost_SetFlag(GHF_WATER_ONLY);
		}
		if(flags&EZBF_KNOCKBACK){
			Ghost_SetFlag(GHF_KNOCKBACK);
		}
		if(EZB_ALWAYS_FAKE_Z)
			Ghost_SetFlag(GHF_FAKE_Z);
		
		int stepCounter = -1;
		int attackCooldown = ghost->Haltrate*10;
		int stepAngle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
		int stepCooldown = ghost->Rate;
		int vX; int vY;
		int lastAttack = -1;
		
		if(movementStyle==4){
			angle = Rand(360);
			vX = VectorX(ghost->Step/100, angle);
			vY = VectorY(ghost->Step/100, angle);
		}
		if(movementStyle==11){
			stepAngle = Rand(4);
		}
		
		while(true){
			bool attackCond = false;
			//Handle Movement
			if(movementStyle==0){ //4 Way Halting Walk
				stepCounter = Ghost_HaltingWalk4(stepCounter, ghost->Step, ghost->Rate, ghost->Homing, ghost->Hunger, ghost->Haltrate, 48);
				if(stepCounter==16)
					attackCond = true;
			}
			else if(movementStyle==1){ //4 Way Constant Walk
				stepCounter = Ghost_ConstantWalk4(stepCounter, ghost->Step, ghost->Rate, ghost->Homing, ghost->Hunger);
				if(attackCooldown>0)
					attackCooldown--;
				else if(Rand(24)==0)
					attackCond = true;
			}
			else if(movementStyle==2){ //8 Way Constant Walk
				stepCounter = Ghost_ConstantWalk8(stepCounter, ghost->Step, ghost->Rate, ghost->Homing, ghost->Hunger);
				if(attackCooldown>0)
					attackCooldown--;
				else if(Rand(24)==0)
					attackCond = true;
			}
			else if(movementStyle==3){ //Homing in on Link
				if(Distance(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY())>8){
					EZB_FaceLink(this, ghost, barrierShift);
					Ghost_MoveAtAngle(Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY()), ghost->Step/100, 0);
				}
				if(ghost->Homing>0&&Link->Action==LA_ATTACKING&&Distance(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY())<ghost->Homing){
					if(attackCooldown<ghost->Haltrate*5)
						attackCond = true;
				}
				
				if(attackCooldown>0)
					attackCooldown--;
				else if(Rand(24)==0)
					attackCond = true;
			}
			else if(movementStyle==4){ //Wall Bounce
				Ghost_MoveXY(vX, vY, 0);
				if((vX<0&&!Ghost_CanMove(DIR_LEFT, 1, 0)) || (vX>0&&!Ghost_CanMove(DIR_RIGHT, 1, 0))){
					vX = -vX;
					doConstantAttack = 1;
				}
				if((vY<0&&!Ghost_CanMove(DIR_UP, 1, 0)) || (vY>0&&!Ghost_CanMove(DIR_DOWN, 1, 0))){
					vY = -vY;
					if(doConstantAttack==0)
						doConstantAttack = 1;
				}
					
				Ghost_Dir = EZB_AngleDir(this, ghost, barrierShift, Angle(0, 0, vX*10, vY*10));
				if(flags&EZBF_FACELINK)
					EZB_FaceLink(this, ghost, barrierShift);
				if(attackCooldown>0)
					attackCooldown--;
				else if(Rand(24)==0)
					attackCond = true;
			}
			else if(movementStyle==5){ //Periodic Reaim
				Ghost_MoveAtAngle(stepAngle, ghost->Step/100, 0);
				Ghost_Dir = EZB_AngleDir(this, ghost, barrierShift, stepAngle);
				if(flags&EZBF_FACELINK)
					EZB_FaceLink(this, ghost, barrierShift);
					
				if(attackCooldown>0)
					attackCooldown--;
				else if(Rand(24)==0)
					attackCond = true;
					
				stepCounter++;
				if(stepCounter>80&&Rand(10)==0){
					stepAngle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
					stepCounter = 0;
					if(doConstantAttack==0)
						doConstantAttack = 1;
				}
			}
			else if(movementStyle==6){ //Lazy chase
				float homing = ghost->Homing*0.001;
				float topSpeed = ghost->Step*0.01;
				vX = Clamp(vX+Sign(CenterLinkX()-CenterX(ghost))*homing, -topSpeed, topSpeed);
				vY = Clamp(vY+Sign(CenterLinkY()-CenterY(ghost))*homing, -topSpeed, topSpeed);
				Ghost_MoveXY(vX, vY, 0);
				if((vX<0&&!Ghost_CanMove(DIR_LEFT, 1, 0)) || (vX>0&&!Ghost_CanMove(DIR_RIGHT, 1, 0))){
					vX = -vX;
					if(doConstantAttack==0)
						doConstantAttack = 1;
				}
				if((vY<0&&!Ghost_CanMove(DIR_UP, 1, 0)) || (vY>0&&!Ghost_CanMove(DIR_DOWN, 1, 0))){
					vY = -vY;
					if(doConstantAttack==0)
						doConstantAttack = 1;
				}
					
				Ghost_Dir = EZB_AngleDir(this, ghost, barrierShift, Angle(0, 0, vX*10, vY*10));
				if(flags&EZBF_FACELINK)
					EZB_FaceLink(this, ghost, barrierShift);
				if(attackCooldown>0)
					attackCooldown--;
				else if(Rand(24)==0)
					attackCond = true;
			}
			else if(movementStyle==7){ //Hopping
				EZB_Waitframes(this, ghost, barrierShift, ghost->Haltrate*8+Choose(0, 8, 16));
				if(ghost->Homing==0)
					stepAngle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY())+Rand(-30, 30);
				else
					stepAngle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY())+Rand(-ghost->Homing, ghost->Homing);
				Game->PlaySound(SFX_JUMP);
				Ghost_Jump = 2.6;
				while(Ghost_Jump>0||Ghost_Z>0){
					Ghost_Dir = EZB_AngleDir(this, ghost, barrierShift, stepAngle);
					Ghost_MoveAtAngle(stepAngle, ghost->Step/100, 0);
					if(flags&EZBF_FACELINK)
						EZB_FaceLink(this, ghost, barrierShift);
					EZB_Waitframe(this, ghost, barrierShift);
				}
				if(stepCooldown>0)
					stepCooldown--;
				if(stepCooldown<=0||Rand(Max(Ceiling(ghost->Rate*0.5), 2))==0){
					attackCond = true;
					stepCooldown = ghost->Rate;
				}
				if(!attackCond)
					doConstantAttack = 1;
			}
			else if(movementStyle==8){ //Teleport
				EZB_Waitframes(this, ghost, barrierShift, ghost->Haltrate*8+Choose(0, 8, 16));
				EZB_Teleport(this, ghost, barrierShift);
				if(stepCooldown>0)
					stepCooldown--;
				if(stepCooldown<=0||Rand(Max(Ceiling(ghost->Rate*0.5), 2))==0){
					attackCond = true;
					stepCooldown = ghost->Rate;
				}
				if(!attackCond)
					doConstantAttack = 1;
			}
			else if(movementStyle==9){ //Rapid hop
				stepAngle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY())+Rand(-ghost->Haltrate, ghost->Haltrate);
				Game->PlaySound(SFX_JUMP);
				if(ghost->Homing==0)
					Ghost_Jump = 2.6;
				else
					Ghost_Jump = 0.01*ghost->Homing;
				if(ghost->Rate>0){
					k = Ghost_Jump * Clamp(0.01*ghost->Rate, 0, 80);
					Ghost_Jump += Rand(-100, 100)*0.01*k;
				}
				while(Ghost_Jump>0||Ghost_Z>0){
					Ghost_Dir = EZB_AngleDir(this, ghost, barrierShift, stepAngle);
					Ghost_MoveAtAngle(stepAngle, ghost->Step/100, 0);
					if(flags&EZBF_FACELINK)
						EZB_FaceLink(this, ghost, barrierShift);
					
					if(attackCooldown>0)
						attackCooldown--;
					else if(Rand(24)==0)
						attackCond = true;
					
					EZB_Waitframe(this, ghost, barrierShift);
					
					if(attackCond){
						while(Ghost_Z>0){
							Ghost_Dir = EZB_AngleDir(this, ghost, barrierShift, stepAngle);
							Ghost_MoveAtAngle(stepAngle, ghost->Step/100, 0);
							if(flags&EZBF_FACELINK)
								EZB_FaceLink(this, ghost, barrierShift);
							EZB_Waitframe(this, ghost, barrierShift);
						}
					}
				}
				if(!attackCond)
					doConstantAttack = 1;
			}
			else if(movementStyle==10){ //Run away
				if(ghost->Homing==0||Distance(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY())<ghost->Homing){
					angle = Angle(CenterLinkX(), CenterLinkY(), CenterX(ghost), CenterY(ghost));
					x = Ghost_X+VectorX(6, angle);
					y = Ghost_Y+VectorY(6, angle);
					if(stepCounter>0&&stepAngle!=-1000){
						stepCounter--;
						EZB_FaceAngle(this, ghost, barrierShift, stepAngle);
						Ghost_MoveAtAngle(stepAngle, ghost->Step/100, 0);
					}
					else if(EZB_CanPlace(this, ghost, x, y)){
						if(stepCounter>0)
							stepCounter--;
						stepAngle = -1000;
						EZB_FaceAngle(this, ghost, barrierShift, angle);
						Ghost_MoveAtAngle(angle, ghost->Step/100, 0);
					}
					else{
						stepAngle = WrapDegrees(angle + Choose(-140, 140));
						stepCounter = Floor(32/(ghost->Step*0.01));
						if(doConstantAttack==0)
							doConstantAttack = 1;
					}
				}
				else if(Distance(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY())>ghost->Homing+32){
					EZB_FaceLink(this, ghost, barrierShift);
					Ghost_MoveAtAngle(Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY()), ghost->Step/100, 0);
				}
				if(attackCooldown>0)
					attackCooldown--;
				else if(Rand(24)==0)
					attackCond = true;
			}
			else if(movementStyle==11){ //Turn at wall
				if(ghost->Homing>0)
					stepAngle = Ghost_Dir;
				if(!Ghost_CanMove(stepAngle, 1, 0)){
					if(ghost->Rate==0){
						if(stepAngle==DIR_UP)
							stepAngle = DIR_RIGHT;
						else if(stepAngle==DIR_DOWN)
							stepAngle = DIR_LEFT;
						else if(stepAngle==DIR_LEFT)
							stepAngle = DIR_UP;
						else if(stepAngle==DIR_RIGHT)
							stepAngle = DIR_DOWN;
					}
					else if(ghost->Rate==1){
						if(stepAngle==DIR_UP)
							stepAngle = DIR_LEFT;
						else if(stepAngle==DIR_DOWN)
							stepAngle = DIR_RIGHT;
						else if(stepAngle==DIR_LEFT)
							stepAngle = DIR_DOWN;
						else if(stepAngle==DIR_RIGHT)
							stepAngle = DIR_UP;
					}
					else if(ghost->Rate==2){
						if(stepAngle==DIR_UP)
							stepAngle = DIR_DOWN;
						else if(stepAngle==DIR_DOWN)
							stepAngle = DIR_UP;
						else if(stepAngle==DIR_LEFT)
							stepAngle = DIR_RIGHT;
						else if(stepAngle==DIR_RIGHT)
							stepAngle = DIR_LEFT;
					}
					else{
						if(stepAngle==DIR_UP)
							stepAngle = Choose(DIR_LEFT, DIR_RIGHT);
						else if(stepAngle==DIR_DOWN)
							stepAngle = Choose(DIR_LEFT, DIR_RIGHT);
						else if(stepAngle==DIR_LEFT)
							stepAngle = Choose(DIR_UP, DIR_DOWN);
						else if(stepAngle==DIR_RIGHT)
							stepAngle = Choose(DIR_UP, DIR_DOWN);
					}
					if(doConstantAttack==0)
						doConstantAttack = 1;
				}
				Ghost_Dir = stepAngle;
				Ghost_Move(Ghost_Dir, ghost->Step/100, 0);
				if(attackCooldown>0)
					attackCooldown--;
				else if(Rand(24)==0)
					attackCond = true;
			}
			
			if(doConstantAttack==1){
				if(constantAttack==44){ //Fireball (Directional)
					EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, EZB_DirAngle(Ghost_Dir), 150);
				}
				else if(constantAttack==45){ //Fireball (Angular)
					EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY()), 150);
				}
				else if(constantAttack==46){ //Summon
					if ( Screen->NumNPCs() < EZB_TOTAL_SUMMON_CAP && EZB_NumSummons(summons) < EZB_SUMMON_CAP ) {
						Game->PlaySound(SFX_EZB_SUMMON);
						enem = CreateNPCAt(special, CenterX(ghost)-8, CenterY(ghost)-8);
						EZB_AddSummon(enem, summons);
					}
				}
				else if(constantAttack==47){ //4 Way (HV)
					for(i=0; i<4; i++){
						EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, 90*i, 150);
					}
				}
				else if(constantAttack==48){ //4 Way (Diag)
					for(i=0; i<4; i++){
						EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, 45+90*i, 150);
					}
				}
				doConstantAttack = -8;
			}
			if(doConstantAttack<0)
				++doConstantAttack;
			
			if(attackCond&&(attack1||barrierShift[200])){
				//Select an attack
				int attack;
				if(attack2==0)
					attack = attack1;
				else if(attack3==0)
					attack = Choose(attack1, attack2);
				else
					attack = Choose(attack1, attack2, attack3);
				
				if(EZB_DONT_REPEAT_LAST_ATTACK&&attack==lastAttack){
					if(attack3==0){
						for(i=0; i<32&&attack==lastAttack; i++)
							attack = Choose(attack1, attack2);
					}
					else{
						for(i=0; i<32&&attack==lastAttack; i++)
							attack = Choose(attack1, attack2, attack3);
					}
				}
				
				if(attack==1){ //Dash
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 1);
					EZB_FaceLink(this, ghost, barrierShift);
					angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
					k = 2;
					Ghost_Data = combo;
					Game->PlaySound(SFX_EZB_DASH);
					while(EZB_CanMoveAngle(angle)){
						k = Min(k+0.2, 5);
						Ghost_MoveAtAngle(angle, k, 0);
						EZB_Trail(this, ghost, barrierShift);
						EZB_Waitframe(this, ghost, barrierShift);
					}
				}
				if(attack==2){ //Shoot (Directional)
					EZB_FiringAnim(this, ghost, barrierShift, 0);
					EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, EZB_DirAngle(Ghost_Dir), 150);
					EZB_Waitframes(this, ghost, barrierShift, 24);
				}
				if(attack==3){ //Shoot (Angular)
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 0);
					EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY()), 150);
					EZB_Waitframes(this, ghost, barrierShift, 24);
				}
				if(attack==4){ //Tri Shot (Directional)
					EZB_FiringAnim(this, ghost, barrierShift, 0);
					for(i=-1; i<=1; i++){
						EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, EZB_DirAngle(Ghost_Dir)+30*i, 250);
					}
					EZB_Waitframes(this, ghost, barrierShift, 24);
				}
				if(attack==5){ //Tri Shot (Angular)
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 0);
					for(i=-1; i<=1; i++){
						EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY())+30*i, 250);
					}
					EZB_Waitframes(this, ghost, barrierShift, 24);
				}
				if(attack==6){ //Stream (Directional)
					EZB_FiringAnim(this, ghost, barrierShift, 1);
					angle = EZB_DirAngle(Ghost_Dir);
					EZB_Waitframes(this, ghost, barrierShift, 12);
					for(i=0; i<10; i++){
						EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, angle, 350);
						EZB_Waitframes(this, ghost, barrierShift, 8);
					}
					EZB_Waitframes(this, ghost, barrierShift, 12);
				}
				if(attack==7){ //Stream (Angular)
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 1);
					angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
					EZB_Waitframes(this, ghost, barrierShift, 12);
					for(i=0; i<10; i++){
						EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, angle, 350);
						EZB_Waitframes(this, ghost, barrierShift, 8);
					}
					EZB_Waitframes(this, ghost, barrierShift, 12);
				}
				if(attack==8){ //Breath (Directional)
					EZB_FiringAnim(this, ghost, barrierShift, 1);
					angle = EZB_DirAngle(Ghost_Dir);
					EZB_Waitframes(this, ghost, barrierShift, 24);
					for(i=0; i<24; i++){
						EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, angle+Rand(-10-i, 10+i), 250);
						EZB_Waitframes(this, ghost, barrierShift, 4);
					}
				}
				if(attack==9){ //Breath (Angular)
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 1);
					angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
					EZB_Waitframes(this, ghost, barrierShift, 24);
					for(i=0; i<24; i++){
						EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, angle+Rand(-10-i, 10+i), 250);
						EZB_Waitframes(this, ghost, barrierShift, 4);
					}
				}
				if(attack==10){ //Sweep (Directional)
					EZB_FiringAnim(this, ghost, barrierShift, 1);
					k = Choose(-1, 1);
					angle = EZB_DirAngle(Ghost_Dir)-75*k;
					for(i=0; i<7; i++){
						EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, angle, 150);
						angle += k*25;
						EZB_Waitframes(this, ghost, barrierShift, 4);
					}
					EZB_Waitframes(this, ghost, barrierShift, 48);
				}
				if(attack==11){ //Sweep (Angular)
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 1);
					k = Choose(-1, 1);
					angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY())-75*k;
					for(i=0; i<7; i++){
						EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, angle, 150);
						angle += k*25;
						EZB_Waitframes(this, ghost, barrierShift, 2);
					}
					EZB_Waitframes(this, ghost, barrierShift, 48);
				}
				if(attack==12){ //Bullet Barrage
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 2);
					angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY())-45;
					for(i=0; i<3; i++){
						for(j=-4; j<=4; j+=2){
							EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, angle+16*j, 150);
						}
						EZB_Waitframes(this, ghost, barrierShift, 16);
						for(j=-5; j<=5; j+=2){
							EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, angle+16*j, 150);
						}
						EZB_Waitframes(this, ghost, barrierShift, 24);
					}
					EZB_Waitframes(this, ghost, barrierShift, 24);
				}
				if(attack==13){ //Bullet Swirl
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 1);
					k = Choose(-1, 1);
					angle = Rand(360);
					for(i=0; i<15; i++){
						for(j=0; j<5; j++){
							EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, angle+72*j, 150);
						}
						angle += 4*k;
						EZB_Waitframes(this, ghost, barrierShift, 4);
					}
					EZB_Waitframes(this, ghost, barrierShift, 24);
				}
				if(attack==14){ //Bullet Rings
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 2);
					for(i=0; i<3; i++){
						angle = Rand(360);
						for(j=0; j<10; j++){
							EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, angle+360/10*j, 180);
						}
						EZB_Waitframes(this, ghost, barrierShift, 45);
					}
					EZB_Waitframes(this, ghost, barrierShift, 24);
				}
				if(attack==15){ //Laser
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 0);
					angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
					for(i=0; i<30; i++){
						if(i%4<2){
							EZB_DrawLaser(LAYER_EZB_LASER, CenterX(ghost), CenterY(ghost), 8, angle, C_EZB_LASER3);
						}
						EZB_Waitframe(this, ghost, barrierShift);
					}
					Game->PlaySound(SFX_EZB_LASER);
					for(i=0; i<20; i++){
						EZB_Laser3Color(LAYER_EZB_LASER, CenterX(ghost), CenterY(ghost), 8, angle, ghost->WeaponDamage, C_EZB_LASER1, C_EZB_LASER2, C_EZB_LASER3);
						EZB_Waitframe(this, ghost, barrierShift);
					}
				}
				if(attack==16){ //Big Laser
					angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 2);
					for(i=0; i<60; i++){
						if(i%4<2){
							EZB_DrawLaser(LAYER_EZB_LASER, CenterX(ghost), CenterY(ghost), 40, angle, C_EZB_LASER3);
						}
						EZB_Waitframe(this, ghost, barrierShift);
					}
					Game->PlaySound(SFX_EZB_LASER);
					for(i=0; i<40; i++){
						EZB_Laser3Color(LAYER_EZB_LASER, CenterX(ghost), CenterY(ghost), 40, angle, ghost->WeaponDamage*2, C_EZB_LASER1, C_EZB_LASER2, C_EZB_LASER3);
						EZB_Waitframe(this, ghost, barrierShift);
					}
				}
				if(attack==17){ //Laser Spread
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 1);
					angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
					k = (w*8+h*8)/2;
					for(i=0; i<40; i++){
						for(j=-2; j<=2; j++){
							if(i%4<2){
								x = CenterX(ghost)+VectorX(k, angle+30*j);
								y = CenterY(ghost)+VectorY(k, angle+30*j);
								EZB_DrawLaser(LAYER_EZB_LASER, x, y, 6, angle+30*j, C_EZB_LASER3);
							}
						}
						EZB_Waitframe(this, ghost, barrierShift);
					}
					Game->PlaySound(SFX_EZB_LASER);
					for(i=0; i<25; i++){
						for(j=-2; j<=2; j++){
							x = CenterX(ghost)+VectorX(k, angle+30*j);
							y = CenterY(ghost)+VectorY(k, angle+30*j);
							EZB_Laser3Color(LAYER_EZB_LASER, x, y, 6, angle+30*j, ghost->WeaponDamage, C_EZB_LASER1, C_EZB_LASER2, C_EZB_LASER3);
						}
						EZB_Waitframe(this, ghost, barrierShift);
					}
				}
				if(attack==18){ //Laser Cross
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 2);
					k = Choose(-1, 1);
					angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY())+45;
					Game->PlaySound(SFX_EZB_LASER);
					for(i=0; i<40; i++){
						if(Distance(CenterX(ghost), CenterY(ghost), 128, 88)>8){
							Ghost_MoveAtAngle(Angle(CenterX(ghost), CenterY(ghost), 128, 88), 0.8, 0);
						}
						for(j=0; j<4; j++){
							if(i%4<2){
								EZB_DrawLaser(LAYER_EZB_LASER, CenterX(ghost), CenterY(ghost), 6, angle+90*j, C_EZB_LASER3);
							}
						}
						EZB_Waitframe(this, ghost, barrierShift);
					}
					for(i=0; i<30; i++){
						for(j=0; j<4; j++){
							EZB_Laser3Color(LAYER_EZB_LASER, CenterX(ghost), CenterY(ghost), 6, angle+90*j, ghost->WeaponDamage, C_EZB_LASER1, C_EZB_LASER2, C_EZB_LASER3);
						}
						EZB_Waitframe(this, ghost, barrierShift);
					}
					for(i=0; i<30; i++){
						for(j=0; j<4; j++){
							EZB_Laser3Color(LAYER_EZB_LASER, CenterX(ghost), CenterY(ghost), 6, angle+90*j, ghost->WeaponDamage, C_EZB_LASER1, C_EZB_LASER2, C_EZB_LASER3);
						}
						angle += k;
						EZB_Waitframe(this, ghost, barrierShift);
					}
					for(i=0; i<120; i++){
						for(j=0; j<4; j++){
							EZB_Laser3Color(LAYER_EZB_LASER, CenterX(ghost), CenterY(ghost), 6, angle+90*j, ghost->WeaponDamage, C_EZB_LASER1, C_EZB_LASER2, C_EZB_LASER3);
						}
						angle += k*1.25;
						EZB_Waitframe(this, ghost, barrierShift);
					}
					for(i=0; i<30; i++){
						for(j=0; j<4; j++){
							EZB_Laser3Color(LAYER_EZB_LASER, CenterX(ghost), CenterY(ghost), 6, angle+90*j, ghost->WeaponDamage, C_EZB_LASER1, C_EZB_LASER2, C_EZB_LASER3);
						}
						angle += k;
						EZB_Waitframe(this, ghost, barrierShift);
					}
				}
				if(attack==19){ //Summon 1 Enemy
					if ( Screen->NumNPCs() < EZB_TOTAL_SUMMON_CAP && EZB_NumSummons(summons) < EZB_SUMMON_CAP ) {
						EZB_FiringAnim(this, ghost, barrierShift, 0);
						Game->PlaySound(SFX_EZB_SUMMON);
						enem = CreateNPCAt(special, CenterX(ghost)-8, CenterY(ghost)-8);
						EZB_AddSummon(enem, summons);
						EZB_Waitframes(this, ghost, barrierShift, 24);
					}
				}
				if(attack==20){ //Summon 2 Enemies
					if ( Screen->NumNPCs() < EZB_TOTAL_SUMMON_CAP && EZB_NumSummons(summons) < EZB_SUMMON_CAP ) {
						EZB_FiringAnim(this, ghost, barrierShift, 0);
						Game->PlaySound(SFX_EZB_SUMMON);
						for(i=0; i<2; i++){
							enem = CreateNPCAt(special, CenterX(ghost)-8+Rand(-4, 4), CenterY(ghost)-8+Rand(-4, 4));
							EZB_AddSummon(enem, summons);
						}
						EZB_Waitframes(this, ghost, barrierShift, 24);
					}
				}
				if(attack==21){ //Summon 3 Enemies
					if ( Screen->NumNPCs() < EZB_TOTAL_SUMMON_CAP && EZB_NumSummons(summons) < EZB_SUMMON_CAP ) {
						EZB_FiringAnim(this, ghost, barrierShift, 0);
						Game->PlaySound(SFX_EZB_SUMMON);
						for(i=0; i<3; i++){
							enem = CreateNPCAt(special, CenterX(ghost)-8+Rand(-4, 4), CenterY(ghost)-8+Rand(-4, 4));
							EZB_AddSummon(enem, summons);
						}
						EZB_Waitframes(this, ghost, barrierShift, 24);
					}
				}
				if(attack==22){ //Homing Shot
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 0);
					eweapon wpn = EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY()), 100);
					SetEWeaponMovement(wpn, EWM_HOMING, DegtoRad(2), 120);
					EZB_Waitframes(this, ghost, barrierShift, 24);
				}
				if(attack==23){ //5 Aimed Shots (With Delays)
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 0);
					for(i=0; i<5; i++){
						EZB_FaceLink(this, ghost, barrierShift);
						EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY()), 200);
						EZB_Waitframes(this, ghost, barrierShift, 25);
					}
				}
				if(attack==24){ //10 Aimed Shots (Quick)
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 0);
					for(i=0; i<10; i++){
						EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY()), 200);
						EZB_Waitframes(this, ghost, barrierShift, 6);
					}
				}
				if(attack==25){ //Aimed Bullet Circle
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 1);
					for(i=0; i<12; i++){
						eweapon wpn = EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, 360/12*i, 200);
						SetEWeaponMovement(wpn, EWM_HOMING_REAIM, 1, 30);
					}
					EZB_Waitframes(this, ghost, barrierShift, 24);
				}
				if(attack==26){ //4 Way Shot (Normal)
					EZB_FiringAnim(this, ghost, barrierShift, 0);
					for(i=0; i<4; i++){
						EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, 90*i, 150);
					}
					EZB_Waitframes(this, ghost, barrierShift, 24);
				}
				if(attack==27){ //4 Way Shot (Diagonal)
					EZB_FiringAnim(this, ghost, barrierShift, 0);
					for(i=0; i<4; i++){
						EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, 45+90*i, 150);
					}
					EZB_Waitframes(this, ghost, barrierShift, 24);
				}
				if(attack==28){ //8 Way Shot
					EZB_FiringAnim(this, ghost, barrierShift, 1);
					for(i=0; i<8; i++){
						EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, 45*i, 150);
					}
					EZB_Waitframes(this, ghost, barrierShift, 24);
				}
				if(attack==29){ //Bullet Storm
					EZB_FiringAnim(this, ghost, barrierShift, 1);
					angle = 0;
					if ( CenterLinkX() < 128 )
						angle = 180;
					for(i=0; i<20; i++){
						if ( angle == 0 )
							EZB_Fire(this, ghost, barrierShift, 0, Rand(8, 152), angle, 250);
						else
							EZB_Fire(this, ghost, barrierShift, 240, Rand(8, 152), angle, 250);
						EZB_Waitframes(this, ghost, barrierShift, 8);
					}
					EZB_Waitframes(this, ghost, barrierShift, 24);
				}
				if(attack==30){ //Laser Storm
					EZB_FiringAnim(this, ghost, barrierShift, 2);
					k = Rand(8, 152);
					for(i=0; i<35; i++){
						if(i%4<2){
							EZB_DrawLaser(LAYER_EZB_LASER, -32, k, 8, 0, C_EZB_LASER3);
						}
						EZB_Waitframe(this, ghost, barrierShift);
					}
					for(j=0; j<8; j++){
						Game->PlaySound(SFX_EZB_LASER);
						y = k;
						k = Rand(8, 152);
						while(k-y > -40 && k-y < 40) { //make sure next laser is not too close to current laser
							k = Rand(8, 152);
						}
						for(i=0; i<35; i++){
							if(i<20){
								EZB_Laser3Color(LAYER_EZB_LASER, -32, y, 8, 0, ghost->WeaponDamage, C_EZB_LASER1, C_EZB_LASER2, C_EZB_LASER3);
							}
							if(j<7){ //dont show the last laser
								if(i%4<2){
									EZB_DrawLaser(LAYER_EZB_LASER, -32, k, 8, 0, C_EZB_LASER3);
								}
							}
							EZB_Waitframe(this, ghost, barrierShift);
						}
					}
				}
				if(attack==31){ //Laser Expansion
					EZB_FiringAnim(this, ghost, barrierShift, 2);
					k = 0;
					while(true){
						for(i=0; i<30; i++){
							for(j=-1; j<=1; j+=2){
								if(i%4<2){
									EZB_DrawLaser(LAYER_EZB_LASER, CenterX(ghost)+24*k*j, -32, 12, 90, C_EZB_LASER3);
								}
							}
							EZB_Waitframe(this, ghost, barrierShift);
						}
						Game->PlaySound(SFX_EZB_LASER);
						for(i=0; i<20; i++){
							for(j=-1; j<=1; j+=2){
								EZB_Laser3Color(LAYER_EZB_LASER, CenterX(ghost)+24*k*j, -32, 12, 90, ghost->WeaponDamage, C_EZB_LASER1, C_EZB_LASER2, C_EZB_LASER3);
							}
							EZB_Waitframe(this, ghost, barrierShift);
						}
						k++;
						if ( CenterX(ghost)+24*k*-1 < 16 && CenterX(ghost)+24*k > 224 || k > 10 )
							break;
                        //stop if Link has crossed the attack
                        if ( k > 2 && Link->X+8-16 > CenterX(ghost)+24*k*-1 && Link->X+8+16 < CenterX(ghost)+24*k )
                            break;
					}
				}
				if(attack==32){ //2 Shot Spread 40 degrees
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 0);
					for(i=0; i<2; i++){
						EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY())-20+40*i, 250);
					}
					EZB_Waitframes(this, ghost, barrierShift, 24);
				}
				if(attack==33){ //Bash
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 1);
					EZB_FaceLink(this, ghost, barrierShift);
					angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
					k = 1;
					Ghost_Data = combo;
					Game->PlaySound(SFX_EZB_DASH);
					for(i=0; i<10; i++){
						k = Min(k+0.5, 5);
						Ghost_MoveAtAngle(angle, k, 0);
						EZB_Trail(this, ghost, barrierShift);
						EZB_Waitframe(this, ghost, barrierShift);
					}
				}
				if(attack==34){ //Shooting Dash
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 1);
					EZB_FaceLink(this, ghost, barrierShift);
					angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
					k = 2;
					Game->PlaySound(SFX_EZB_DASH);
					i = 0;
					Ghost_Data = combo;
					while(EZB_CanMoveAngle(angle)){
						i++;
						k = Min(k+0.2, 5);
						Ghost_MoveAtAngle(angle, k, 0);
						if(i%4==0){
							if(ghost->Weapon==WPN_ENEMYFLAME||ghost->Weapon==WPN_ENEMYFIRETRAIL){
								EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY()), 0);
							}
							else{
								EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY()), 150);
							}
						}
						EZB_Trail(this, ghost, barrierShift);
						EZB_Waitframe(this, ghost, barrierShift);
					}
				}
				if(attack==35){ //Double Dash
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 1);
					EZB_FaceLink(this, ghost, barrierShift);
					angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
					k = 2;
					Game->PlaySound(SFX_EZB_DASH);
					i = 0;
					Ghost_Data = combo;
					for(i=0; i<40; i++){
						k = Min(k+0.1, 4);
						Ghost_MoveAtAngle(angle, k, 0);
						EZB_Trail(this, ghost, barrierShift);
						EZB_Waitframe(this, ghost, barrierShift);
					}
					EZB_FaceLink(this, ghost, barrierShift);
					angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
					EZB_FiringAnim(this, ghost, barrierShift, 0);
					EZB_FaceLink(this, ghost, barrierShift);
					k = 2;
					Game->PlaySound(SFX_EZB_DASH);
					i = 0;
					Ghost_Data = combo;
					for(i=0; i<40; i++){
						j = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
						if(i<20){
							if(Abs(EZB_AngDiff(angle, j))>1)
								angle = WrapDegrees(angle+1*Sign(EZB_AngDiff(angle, j)));
						}
						k = Min(k+0.1, 4);
						Ghost_MoveAtAngle(angle, k, 0);
						EZB_Trail(this, ghost, barrierShift);
						EZB_Waitframe(this, ghost, barrierShift);
					}
				}
				if(attack==36){ //Jump
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 0);
					EZB_FaceLink(this, ghost, barrierShift);
					angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
					Game->PlaySound(SFX_JUMP);
					Ghost_Jump = 2.6;
					dist = Distance(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
					k = 2;
					if(dist<32)
						k = 0.5;
					else if(dist<64)
						k = 1;
					else if(dist<96)
						k = 2;
					else if(dist<128)
						k = 3;
					else
						k = 4;
					while(Ghost_Jump>0||Ghost_Z>0){
						Ghost_MoveAtAngle(angle, k, 0);
						EZB_Waitframe(this, ghost, barrierShift);
					}
				}
				if(attack==37){ //Double Jump
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 0);
					EZB_FaceLink(this, ghost, barrierShift);
					angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
					Game->PlaySound(SFX_JUMP);
					Ghost_Jump = 2.6;
					dist = Distance(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
					k = 2;
					if(dist<32)
						k = 0.5;
					else if(dist<64)
						k = 1;
					else if(dist<96)
						k = 2;
					else if(dist<128)
						k = 3;
					else
						k = 4;
					Ghost_Data = combo;
					while(Ghost_Jump>0||Ghost_Z>0){
						Ghost_MoveAtAngle(angle, k, 0);
						EZB_Waitframe(this, ghost, barrierShift);
					}
					
					angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
					
					Game->PlaySound(SFX_JUMP);
					Ghost_Jump = 2.6;
					while(Ghost_Jump>0||Ghost_Z>0){
						Ghost_MoveAtAngle(angle, k/2, 0);
						EZB_Waitframe(this, ghost, barrierShift);
					}
				}
				if(attack==38){ //Jump, Shockwave
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 0);
					EZB_FaceLink(this, ghost, barrierShift);
					angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
					
					Game->PlaySound(SFX_JUMP);
					Ghost_Jump = 3.2;
					dist = Distance(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
					k = 2;
					if(dist<32)
						k = 0.5;
					else if(dist<64)
						k = 1;
					else if(dist<96)
						k = 2;
					else if(dist<128)
						k = 3;
					else
						k = 4;
					
					Ghost_Data = combo;
					while(Ghost_Jump>0||Ghost_Z>0){
						Ghost_MoveAtAngle(angle, k, 0);
						EZB_Waitframe(this, ghost, barrierShift);
					}
					Game->PlaySound(SFX_EZB_SHOCKWAVE);
					for(i=0; i<64+32; i+=3){
						EZB_Shockwave(2, CenterX(ghost), CenterY(ghost), i, 64, 12, ghost->WeaponDamage, C_EZB_SHOCKWAVE1, C_EZB_SHOCKWAVE2, C_EZB_SHOCKWAVE3);
						EZB_Waitframe(this, ghost, barrierShift);
					}
					
				}
				if(attack==39){ //High Jump, Shockwave
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 2);
					EZB_FaceLink(this, ghost, barrierShift);
					
					Ghost_Data = combo;
					Game->PlaySound(SFX_JUMP);
					for(i=0; i<176; i+=4){
						if(Distance(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY())>2){
							x = Sign(CenterLinkX()-CenterX(ghost));
							y = Sign(CenterLinkY()-CenterY(ghost));
							Ghost_MoveXY(x, y, 0);
						}
						Ghost_Z += 4;
						Ghost_Jump = 0;
						EZB_Waitframe(this, ghost, barrierShift);
					}
					for(i=0; i<180; i++){
						if(Distance(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY())>2){
							x = Sign(CenterLinkX()-CenterX(ghost))*0.5;
							y = Sign(CenterLinkY()-CenterY(ghost))*0.5;
							Ghost_MoveXY(x, y, 0);
						}
						Ghost_Jump = 0;
						EZB_Waitframe(this, ghost, barrierShift);
					}
					Game->PlaySound(SFX_FALL);
					while(Ghost_Z>0){
						if(Distance(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY())>2){
							x = Sign(CenterLinkX()-CenterX(ghost))*0.2;
							y = Sign(CenterLinkY()-CenterY(ghost))*0.2;
							Ghost_MoveXY(x, y, 0);
						}
						Ghost_Z = Max(Ghost_Z-4, 0);
						EZB_Waitframe(this, ghost, barrierShift);
					}
					Game->PlaySound(SFX_EZB_SHAKE);
					Screen->Quake = 20;
					Game->PlaySound(SFX_EZB_SHOCKWAVE);
					for(i=0; i<80+48; i+=6){
						EZB_Shockwave(2, CenterX(ghost), CenterY(ghost), i, 80, 16, ghost->WeaponDamage, C_EZB_SHOCKWAVE1, C_EZB_SHOCKWAVE2, C_EZB_SHOCKWAVE3);
						EZB_Waitframe(this, ghost, barrierShift);
					}
				}
				if(attack==40){ //High Jump, Rocks Fall
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 2);
					EZB_FaceLink(this, ghost, barrierShift);
					
					Ghost_Data = combo;
					Game->PlaySound(SFX_JUMP);
					for(i=0; i<176; i+=4){
						if(Distance(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY())>2){
							x = Sign(CenterLinkX()-CenterX(ghost));
							y = Sign(CenterLinkY()-CenterY(ghost));
							Ghost_MoveXY(x, y, 0);
						}
						Ghost_Z += 4;
						Ghost_Jump = 0;
						EZB_Waitframe(this, ghost, barrierShift);
					}
					for(i=0; i<120; i++){
						if(Distance(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY())>2){
							x = Sign(CenterLinkX()-CenterX(ghost))*0.5;
							y = Sign(CenterLinkY()-CenterY(ghost))*0.5;
							Ghost_MoveXY(x, y, 0);
						}
						Ghost_Jump = 0;
						EZB_Waitframe(this, ghost, barrierShift);
					}
					Game->PlaySound(SFX_FALL);
					while(Ghost_Z>0){
						if(Distance(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY())>2){
							x = Sign(CenterLinkX()-CenterX(ghost))*0.2;
							y = Sign(CenterLinkY()-CenterY(ghost))*0.2;
							Ghost_MoveXY(x, y, 0);
						}
						Ghost_Z = Max(Ghost_Z-4, 0);
						EZB_Waitframe(this, ghost, barrierShift);
					}
					Game->PlaySound(SFX_EZB_SHAKE);
					Screen->Quake = 20;
					for(i=0; i<30; i++){
						e = EZB_Fire(this, ghost, barrierShift, Rand(16, 224), Rand(16, 144), Rand(360), Rand(50), EWF_SHADOW);
						SetEWeaponMovement(e, EWM_FALL, 176, EWMF_DIE);
						SetEWeaponDeathEffect(e, EWD_EXPLODE, e->Damage);
						EZB_Waitframes(this, ghost, barrierShift, Rand(2, 6));
					}
				}
				if(attack==41){ //High Jump, Enemies Fall
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 2);
					EZB_FaceLink(this, ghost, barrierShift);
					
					Ghost_Data = combo;
					Game->PlaySound(SFX_JUMP);
					for(i=0; i<176; i+=4){
						if(Distance(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY())>2){
							x = Sign(CenterLinkX()-CenterX(ghost));
							y = Sign(CenterLinkY()-CenterY(ghost));
							Ghost_MoveXY(x, y, 0);
						}
						Ghost_Z += 4;
						Ghost_Jump = 0;
						EZB_Waitframe(this, ghost, barrierShift);
					}
					for(i=0; i<120; i++){
						if(Distance(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY())>2){
							x = Sign(CenterLinkX()-CenterX(ghost))*0.5;
							y = Sign(CenterLinkY()-CenterY(ghost))*0.5;
							Ghost_MoveXY(x, y, 0);
						}
						Ghost_Jump = 0;
						EZB_Waitframe(this, ghost, barrierShift);
					}
					Game->PlaySound(SFX_FALL);
					while(Ghost_Z>0){
						if(Distance(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY())>2){
							x = Sign(CenterLinkX()-CenterX(ghost))*0.2;
							y = Sign(CenterLinkY()-CenterY(ghost))*0.2;
							Ghost_MoveXY(x, y, 0);
						}
						Ghost_Z = Max(Ghost_Z-4, 0);
						EZB_Waitframe(this, ghost, barrierShift);
					}
					Game->PlaySound(SFX_EZB_SHAKE);
					Screen->Quake = 20;
					k = Rand(4, 7);
					for(i=0; i<k&&(Screen->NumNPCs() < EZB_TOTAL_SUMMON_CAP && EZB_NumSummons(summons) < EZB_SUMMON_CAP); i++){
						j = Rand(176);
						for(m=0; m<352&&!EZB_CanPlace(this, ghost, ComboX(j), ComboY(j), 16, 16); m++){
							if(k<176)
								j = Rand(176);
							else
								j = m-176;
						}
						Game->PlaySound(SFX_FALL);
						enem = CreateNPCAt(special, ComboX(j), ComboY(j));
						EZB_AddSummon(enem, summons);
						enem->Z = 176;
						EZB_Waitframes(this, ghost, barrierShift, Rand(6, 17));
					}
				}
				if(attack==42){ //Chase
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 1);
					EZB_FaceLink(this, ghost, barrierShift);
					angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
					Ghost_Data = combo;
					for(i=0; i<300; i++){
						angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
						Ghost_MoveAtAngle(angle, 1, 0);
						EZB_Waitframe(this, ghost, barrierShift);
					}
				}
				if(attack==43){ //Backstep
					EZB_FaceLink(this, ghost, barrierShift);
					angle = Angle(CenterLinkX(), CenterLinkY(), CenterX(ghost), CenterY(ghost));
					x = Ghost_X+VectorX(32, angle);
					y = Ghost_Y+VectorY(32, angle);
					if(EZB_CanPlace(this, ghost, x, y)){
						k = 3;
						Ghost_Data = combo;
						Game->PlaySound(SFX_EZB_BACKSTEP);
						for(i=0; i<10&&EZB_CanMoveAngle(angle); i++){
							angle = Angle(CenterLinkX(), CenterLinkY(), CenterX(ghost), CenterY(ghost));
							k = Min(k+0.5, 5);
							Ghost_MoveAtAngle(angle, k, 0);
							EZB_FaceLink(this, ghost, barrierShift);
							EZB_Trail(this, ghost, barrierShift);
							EZB_Waitframe(this, ghost, barrierShift);
						}
					}
					else{
						EZB_FaceLink(this, ghost, barrierShift);
						EZB_FiringAnim(this, ghost, barrierShift, 1);
						EZB_FaceLink(this, ghost, barrierShift);
						angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
						k = 2;
						Ghost_Data = combo;
						Game->PlaySound(SFX_EZB_DASH);
						while(EZB_CanMoveAngle(angle)){
							k = Min(k+0.2, 5);
							Ghost_MoveAtAngle(angle, k, 0);
							EZB_Trail(this, ghost, barrierShift);
							EZB_Waitframe(this, ghost, barrierShift);
						}
					}
				}
				//attack == 44 //Constant Attack (Fireball, Directional)
				//attack == 45 //Constant Attack (Fireball, Angular)
				//attack == 46 //Constant Attack (Summon)
				//attack == 47 //Constant Attack (4 Way, HV)
				//attack == 48 //Constant Attack (4 Way, Diag)
				if(attack==49){ //Mega Laser
					angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 2);
					for(i=0; i<90; i++){
						if(i%4<2){
							EZB_DrawLaser(LAYER_EZB_LASER, CenterX(ghost), CenterY(ghost), 64, angle, C_EZB_LASER3);
						}
						EZB_Waitframe(this, ghost, barrierShift);
					}
					Game->PlaySound(SFX_EZB_LASER);
					for(i=0; i<40; i++){
						for(j=0; j<4; j++){
							x = Ghost_X+Sign(VectorX(1, angle+180));
							y = Ghost_Y+Sign(VectorY(1, angle+180));
							if(EZB_CanPlace(this, ghost, x, y)){
								Ghost_MoveAtAngle(angle+180, 1, 0);
							}
						}
						EZB_Laser3Color(LAYER_EZB_LASER, CenterX(ghost), CenterY(ghost), 64, angle, ghost->WeaponDamage*2, C_EZB_LASER1, C_EZB_LASER2, C_EZB_LASER3);
						EZB_Waitframe(this, ghost, barrierShift);
					}
				}
				//attack = 50 //Barrier Shift
				//attack = 51 //Enemy Shift
				if(attack==52){ //Flying Slam, Shockwave
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 2);
					EZB_FaceLink(this, ghost, barrierShift);
					
					Ghost_Jump = 4;
					Ghost_Data = combo;
					Game->PlaySound(SFX_JUMP);
					while(Ghost_Jump>0){
						if(Distance(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY())>2){
							x = Sign(CenterLinkX()-CenterX(ghost))*1.3;
							y = Sign(CenterLinkY()-CenterY(ghost))*1.3;
							Ghost_MoveXY(x, y, 0);
						}
						EZB_Waitframe(this, ghost, barrierShift);
					}
					k = Ghost_Z;
					for(i=0; i<90; i++){
						if(Distance(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY())>2){
							x = Sign(CenterLinkX()-CenterX(ghost))*0.7;
							y = Sign(CenterLinkY()-CenterY(ghost))*0.7;
							Ghost_MoveXY(x, y, 0);
						}
						Ghost_Jump = 0;
						Ghost_Z = k+2*Sin(16*i);
						EZB_Waitframe(this, ghost, barrierShift);
					}
					Game->PlaySound(SFX_FALL);
					while(Ghost_Z>0){
						if(Distance(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY())>2){
							x = Sign(CenterLinkX()-CenterX(ghost))*0.3;
							y = Sign(CenterLinkY()-CenterY(ghost))*0.3;
							Ghost_MoveXY(x, y, 0);
						}
						Ghost_Z = Max(Ghost_Z-4, 0);
						EZB_Waitframe(this, ghost, barrierShift);
					}
					Game->PlaySound(SFX_EZB_SHAKE);
					Screen->Quake = 4;
					Game->PlaySound(SFX_EZB_SHOCKWAVE);
					for(i=0; i<48+48; i+=6){
						EZB_Shockwave(2, CenterX(ghost), CenterY(ghost), i, 48, 16, ghost->WeaponDamage, C_EZB_SHOCKWAVE1, C_EZB_SHOCKWAVE2, C_EZB_SHOCKWAVE3);
						EZB_Waitframe(this, ghost, barrierShift);
					}
				}
				if(attack==53){ //Flying Slam, Rocks Fall
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 2);
					EZB_FaceLink(this, ghost, barrierShift);
					
					Ghost_Jump = 4;
					Ghost_Data = combo;
					Game->PlaySound(SFX_JUMP);
					while(Ghost_Jump>0){
						if(Distance(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY())>2){
							x = Sign(CenterLinkX()-CenterX(ghost))*1.3;
							y = Sign(CenterLinkY()-CenterY(ghost))*1.3;
							Ghost_MoveXY(x, y, 0);
						}
						EZB_Waitframe(this, ghost, barrierShift);
					}
					k = Ghost_Z;
					for(i=0; i<90; i++){
						if(Distance(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY())>2){
							x = Sign(CenterLinkX()-CenterX(ghost))*0.7;
							y = Sign(CenterLinkY()-CenterY(ghost))*0.7;
							Ghost_MoveXY(x, y, 0);
						}
						Ghost_Jump = 0;
						Ghost_Z = k+2*Sin(16*i);
						EZB_Waitframe(this, ghost, barrierShift);
					}
					Game->PlaySound(SFX_FALL);
					while(Ghost_Z>0){
						if(Distance(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY())>2){
							x = Sign(CenterLinkX()-CenterX(ghost))*0.3;
							y = Sign(CenterLinkY()-CenterY(ghost))*0.3;
							Ghost_MoveXY(x, y, 0);
						}
						Ghost_Z = Max(Ghost_Z-4, 0);
						EZB_Waitframe(this, ghost, barrierShift);
					}
					Game->PlaySound(SFX_EZB_SHAKE);
					Screen->Quake = 4;
					for(i=0; i<10; i++){
						e = EZB_Fire(this, ghost, barrierShift, Rand(16, 224), Rand(16, 144), Rand(360), Rand(50), EWF_SHADOW);
						SetEWeaponMovement(e, EWM_FALL, 176, EWMF_DIE);
						SetEWeaponDeathEffect(e, EWD_EXPLODE, e->Damage);
						EZB_Waitframes(this, ghost, barrierShift, Rand(4, 12));
					}
				}
				if(attack==54){ //Flying Slam, Enemies Fall
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 2);
					EZB_FaceLink(this, ghost, barrierShift);
					
					Ghost_Jump = 4;
					Ghost_Data = combo;
					Game->PlaySound(SFX_JUMP);
					while(Ghost_Jump>0){
						if(Distance(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY())>2){
							x = Sign(CenterLinkX()-CenterX(ghost))*1.3;
							y = Sign(CenterLinkY()-CenterY(ghost))*1.3;
							Ghost_MoveXY(x, y, 0);
						}
						EZB_Waitframe(this, ghost, barrierShift);
					}
					k = Ghost_Z;
					for(i=0; i<90; i++){
						if(Distance(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY())>2){
							x = Sign(CenterLinkX()-CenterX(ghost))*0.7;
							y = Sign(CenterLinkY()-CenterY(ghost))*0.7;
							Ghost_MoveXY(x, y, 0);
						}
						Ghost_Jump = 0;
						Ghost_Z = k+2*Sin(16*i);
						EZB_Waitframe(this, ghost, barrierShift);
					}
					Game->PlaySound(SFX_FALL);
					while(Ghost_Z>0){
						if(Distance(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY())>2){
							x = Sign(CenterLinkX()-CenterX(ghost))*0.3;
							y = Sign(CenterLinkY()-CenterY(ghost))*0.3;
							Ghost_MoveXY(x, y, 0);
						}
						Ghost_Z = Max(Ghost_Z-4, 0);
						EZB_Waitframe(this, ghost, barrierShift);
					}
					Game->PlaySound(SFX_EZB_SHAKE);
					Screen->Quake = 4;
					k = Rand(2, 3);
					for(i=0; i<k&&(Screen->NumNPCs() < EZB_TOTAL_SUMMON_CAP && EZB_NumSummons(summons) < EZB_SUMMON_CAP); i++){
						j = Rand(176);
						for(m=0; m<352&&!EZB_CanPlace(this, ghost, ComboX(j), ComboY(j), 16, 16); m++){
							if(k<176)
								j = Rand(176);
							else
								j = m-176;
						}
						Game->PlaySound(SFX_FALL);
						enem = CreateNPCAt(special, ComboX(j), ComboY(j));
						EZB_AddSummon(enem, summons);
						enem->Z = 176;
						EZB_Waitframes(this, ghost, barrierShift, Rand(6, 17));
					}
				}
				if(attack==55){ //Sine Wave Stream, Directional
					EZB_FiringAnim(this, ghost, barrierShift, 1);
					angle = EZB_DirAngle(Ghost_Dir);
					EZB_Waitframes(this, ghost, barrierShift, 12);
					for(i=0; i<5; i++){
						e = EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, angle, 350);
						SetEWeaponMovement(e, EWM_SINE_WAVE, 16, 16);
						EZB_Waitframes(this, ghost, barrierShift, 8);
					}
					EZB_Waitframes(this, ghost, barrierShift, 12);
				}
				if(attack==56){ //Sine Wave Stream, Angular
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 1);
					angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
					EZB_Waitframes(this, ghost, barrierShift, 12);
					for(i=0; i<5; i++){
						e = EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, angle, 250);
						SetEWeaponMovement(e, EWM_SINE_WAVE, 16, 16);
						EZB_Waitframes(this, ghost, barrierShift, 12);
					}
					EZB_Waitframes(this, ghost, barrierShift, 12);
				}
				if(attack==57){ //Sine Wave, 5 Shot
					EZB_FiringAnim(this, ghost, barrierShift, 1);
					angle = Rand(360);
					EZB_Waitframes(this, ghost, barrierShift, 12);
					j = Choose(-40, 40);
					for(k=0; k<3; k++){
						for(i=0; i<5; i++){
							e = EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, angle+72*i, 250);
							SetEWeaponMovement(e, EWM_SINE_WAVE, j, 4);
						}
						EZB_Waitframes(this, ghost, barrierShift, 4);
					}
					EZB_Waitframes(this, ghost, barrierShift, 32);
				}
				if(attack==58){ //Reaim, Cross, Directional
					EZB_FiringAnim(this, ghost, barrierShift, 1);
					angle = EZB_DirAngle(Ghost_Dir);
					EZB_Waitframes(this, ghost, barrierShift, 12);
					for(i=-1; i<=1; i+=2){
						e = EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, angle+25*i, 300);
						j = 0;
						if(ghost->Weapon==WPN_ENEMYFIREBALL)
							j = 16;
						SetEWeaponLifespan(e, EWL_TIMER, 24+j);
						SetEWeaponDeathEffect(e, EWD_AIM_AT_LINK, 16);
					}
					EZB_Waitframes(this, ghost, barrierShift, 24);
				}
				if(attack==59){ //Reaim, Cross, Angular
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 1);
					angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
					EZB_Waitframes(this, ghost, barrierShift, 12);
					for(i=-1; i<=1; i+=2){
						e = EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, angle+45*i, 300);
						j = 0;
						if(ghost->Weapon==WPN_ENEMYFIREBALL)
							j = 16;
						SetEWeaponLifespan(e, EWL_TIMER, 24+j);
						SetEWeaponDeathEffect(e, EWD_AIM_AT_LINK, 16);
					}
					EZB_Waitframes(this, ghost, barrierShift, 24);
				}
				if(attack==60){ //Throw, Fixed Dist
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 0);
					angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
					EZB_Waitframes(this, ghost, barrierShift, 12);
					
					angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
					e = EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, angle, 150, EWF_UNBLOCKABLE|EWF_SHADOW);
					SetEWeaponMovement(e, EWM_THROW, 3.6, EWMF_DIE);
					EZB_SetEWeaponDeathEffect(e);
					
					EZB_Waitframes(this, ghost, barrierShift, 24);
				}
				if(attack==61){ //Throw, To Link
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 0);
					angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
					EZB_Waitframes(this, ghost, barrierShift, 12);
					
					angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
					e = EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, angle, 200, EWF_UNBLOCKABLE|EWF_SHADOW);
					SetEWeaponMovement(e, EWM_THROW, -1, EWMF_DIE);
					EZB_SetEWeaponDeathEffect(e);
					
					EZB_Waitframes(this, ghost, barrierShift, 24);
				}
				if(attack==62){ //Throw, To Link, Stream
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 1);
					angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
					EZB_Waitframes(this, ghost, barrierShift, 12);
					
					for(i=0; i<16; i++){
						angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
						e = EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, angle, 200, EWF_UNBLOCKABLE|EWF_SHADOW);
						SetEWeaponMovement(e, EWM_THROW, -1, EWMF_DIE);
						EZB_SetEWeaponDeathEffect(e);
						
						EZB_Waitframes(this, ghost, barrierShift, 6);
					}
					EZB_Waitframes(this, ghost, barrierShift, 24);
				}
				if(attack==63){ //Throw, Five Shot
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 1);
					angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
					EZB_Waitframes(this, ghost, barrierShift, 12);
					
					angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
					for(i=-2; i<=2; i++){
						e = EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, angle+20*i, 200, EWF_UNBLOCKABLE|EWF_SHADOW);
						SetEWeaponMovement(e, EWM_THROW, 3.6, EWMF_DIE);
						EZB_SetEWeaponDeathEffect(e);
					}
					EZB_Waitframes(this, ghost, barrierShift, 24);
				}
				if(attack==64){ //Throw, 6 Shot, Volley
					EZB_FaceLink(this, ghost, barrierShift);
					EZB_FiringAnim(this, ghost, barrierShift, 1);
					angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
					EZB_Waitframes(this, ghost, barrierShift, 12);
					
					angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
					for(i=0; i<=6; i++){
						e = EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, angle+Rand(-30, 30), Rand(100, 300), EWF_UNBLOCKABLE|EWF_SHADOW);
						SetEWeaponMovement(e, EWM_THROW, Rand(24, 36)/10, EWMF_DIE);
						EZB_SetEWeaponDeathEffect(e);
					}
					EZB_Waitframes(this, ghost, barrierShift, 24);
				}
				if(attack==65){ //Throw, Splash
					EZB_FiringAnim(this, ghost, barrierShift, 1);
					EZB_Waitframes(this, ghost, barrierShift, 12);
					
					angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
					for(i=0; i<=18; i++){
						e = EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, Rand(360), Rand(100, 400), EWF_UNBLOCKABLE|EWF_SHADOW);
						SetEWeaponMovement(e, EWM_THROW, Rand(24, 36)/10, EWMF_DIE);
						EZB_SetEWeaponDeathEffect(e);
					}
				}
				if(attack==66){ //8 Shots, Line, Directional
					EZB_FiringAnim(this, ghost, barrierShift, 1);
					for(i=0; i<8; i++){
						EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, EZB_DirAngle(Ghost_Dir), 200+400*(i/7));
					}
					EZB_Waitframes(this, ghost, barrierShift, 24);
				}
				if(attack==67){ //8 Shots, Line, Angular
					EZB_FiringAnim(this, ghost, barrierShift, 1);
					EZB_Waitframes(this, ghost, barrierShift, 12);
					angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
					for(i=0; i<8; i++){
						EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, angle, 200+400*(i/7));
					}
					EZB_Waitframes(this, ghost, barrierShift, 24);
				}
				if(attack==68){ //Teleport and Shoot
					EZB_Teleport(this, ghost, barrierShift);
					
					EZB_FiringAnim(this, ghost, barrierShift, 0);
					EZB_Waitframes(this, ghost, barrierShift, 12);
					angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
					EZB_Waitframes(this, ghost, barrierShift, 12);
					EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, angle, 150);
					
					EZB_Waitframes(this, ghost, barrierShift, 24);
				}
				if(attack==69){ //Teleport and Shoot Triple Shot
					EZB_Teleport(this, ghost, barrierShift);
					
					EZB_FiringAnim(this, ghost, barrierShift, 0);
					EZB_Waitframes(this, ghost, barrierShift, 12);
					angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
					EZB_Waitframes(this, ghost, barrierShift, 12);
					for(i=-1; i<=1; i++){
						EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, angle+20*i, 250);
					}
					EZB_Waitframes(this, ghost, barrierShift, 24);
				}
				if(attack==70){ //Teleport 3 Times, Shoot 8 Shots in a line
					for(i=0; i<3; i++){
						EZB_Waitframes(this, ghost, barrierShift, 4);
						EZB_Teleport(this, ghost, barrierShift);
					}
					
					EZB_FiringAnim(this, ghost, barrierShift, 0);
					EZB_Waitframes(this, ghost, barrierShift, 12);
					angle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
					for(i=0; i<8; i++){
						EZB_Fire(this, ghost, barrierShift, CenterX(ghost)-8, CenterY(ghost)-8, angle, 200+400*(i/7));
					}
					EZB_Waitframes(this, ghost, barrierShift, 24);
				}
				
				if(barrierShift[200]){
					Game->PlaySound(SFX_EZB_BARRIERSHIFT);
					if(barrierShift[200]==2)
						EZB_Barriershift_Load(ghost, barrierShift, false);
					else
						EZB_Barriershift_Load(ghost, barrierShift, true);
				
					if(barrierShift[200]==2){
						//When morphing into a different enemy, reload all init stuff
						Ghost_UnsetFlag(GHF_8WAY);
						Ghost_UnsetFlag(GHF_4WAY);
						Ghost_UnsetFlag(GHF_NO_FALL);
						Ghost_UnsetFlag(GHF_IGNORE_ALL_TERRAIN);
						Ghost_UnsetFlag(GHF_FLYING_ENEMY);
						Ghost_UnsetFlag(GHF_FAKE_Z);
						Ghost_UnsetFlag(GHF_WATER_ONLY);
						Ghost_UnsetFlag(GHF_KNOCKBACK);
						Ghost_UnsetFlag(GHF_FAKE_Z);
						Ghost_UnsetFlag(GHF_CLOCK);
						Ghost_UnsetFlag(GHF_STUN);
						
						movementStyle = barrierShift[300];
						attack1 = barrierShift[301];
						attack2 = barrierShift[302];
						attack3 = barrierShift[303];
						shaveHitbox = barrierShift[304];
						special = barrierShift[305];
						size = barrierShift[306];
						fireSFX = barrierShift[307];
						fireSPR = barrierShift[308];
						flags = barrierShift[309];
						
						constantAttack = 0;
						doConstantAttack = 0;
						
						//Certain attacks in Attack 1 do a constant attack instead
						//This is triggered at certain parts of the enemy's walk pattern
						if(attack1==44)
							constantAttack = 44;
						else if(attack1==45)
							constantAttack = 45;
						else if(attack1==46)
							constantAttack = 46;
						else if(attack1==47)
							constantAttack = 47;
						else if(attack1==48)
							constantAttack = 48;
						
						if(attack1==50||attack1==51){
							EZB_Barriershift_Store(ghost, special, barrierShift);
							if(attack1==51)
								barrierShift[200] = 2;
						}
						
						//If there's a constant attack, shift all other attacks down
						if(constantAttack>0||(attack1==50||attack1==51)){
							attack1 = attack2;
							attack2 = attack3;
							attack3 = 0;
						}
						
						shaveX = shaveHitbox&1111b;
						shaveY = Floor(shaveHitbox>>4)&1111b;
						
						//An enemy with no collision uses stun to turn it off and so cannot be stunned normally
						if(!(flags&EZBF_NOCOLL)&&!(flags&EZBF_NOSTUN)){
							Ghost_SetFlag(GHF_STUN);
							Ghost_SetFlag(GHF_CLOCK);
						}
						
						w = size&1111b;
						h = (size>>4)&1111b;
						if(h==0)
							h = w;
						w = Clamp(w, 1, 4);
						h = Clamp(h, 1, 4);
							
						combo = barrierShift[310];
						if(Ghost_TileWidth!=w||Ghost_TileHeight!=h)
							Ghost_Transform(this, ghost, -1, -1, w, h);
						Ghost_SetHitOffsets(ghost, shaveY, shaveY, shaveX, shaveX);
						
						if(flags&EZBF_8WAY)
							Ghost_SetFlag(GHF_8WAY);
						else if(flags&EZBF_4WAY)
							Ghost_SetFlag(GHF_4WAY);
						if(flags&EZBF_NOFALL)
							Ghost_SetFlag(GHF_NO_FALL);
						if(flags&EZBF_FLYING){
							Ghost_SetFlag(GHF_IGNORE_ALL_TERRAIN);
							Ghost_SetFlag(GHF_FLYING_ENEMY);
							this->Flags[FFCF_OVERLAY] = true;
							if(EZB_FLYING_ZPOS&&(flags&EZBF_NOFALL)&&!IsSideview()){
								Ghost_SetFlag(GHF_FAKE_Z);
								Ghost_Z = 8;
							}
						}
						else if(flags&EZBF_AQUATIC){
							Ghost_SetFlag(GHF_WATER_ONLY);
						}
						if(flags&EZBF_KNOCKBACK){
							Ghost_SetFlag(GHF_KNOCKBACK);
						}
						if(EZB_ALWAYS_FAKE_Z)
							Ghost_SetFlag(GHF_FAKE_Z);
						
						stepCounter = -1;
						attackCooldown = ghost->Haltrate*10;
						stepAngle = Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY());
						stepCooldown = ghost->Rate;
						vX = 0; vY = 0;
						int lastAttack = -1;
						
						if(movementStyle==4){
							angle = Rand(360);
							vX = VectorX(ghost->Step/100, angle);
							vY = VectorY(ghost->Step/100, angle);
						}
						if(movementStyle==11){
							stepAngle = Rand(4);
						}
					}
				}
				Ghost_Data = combo;
				
				lastAttack = attack;
				attackCooldown = ghost->Haltrate*10;
				if(movementStyle==4){ //Wall bounce
					angle = Rand(360);
					vX = VectorX(ghost->Step/100, angle);
					vY = VectorY(ghost->Step/100, angle);
				}
			}
			EZB_Waitframe(this, ghost, barrierShift);
		}
	}
	bool EZB_CanMoveAngle(int angle){
		int vx = VectorX(10, angle);
		int vy = VectorY(10, angle);
		if((vx<0&&!Ghost_CanMove(DIR_LEFT, 1, 0))||(vx>0&&!Ghost_CanMove(DIR_RIGHT, 1, 0)))
			return false;
		if((vy<0&&!Ghost_CanMove(DIR_UP, 1, 0))||(vy>0&&!Ghost_CanMove(DIR_DOWN, 1, 0)))
			return false;
		return true;
	}
	void EZB_FiringAnim(ffc this, npc ghost, int barrierShift, int delayType){
		int movementStyle = barrierShift[300];
		int flags = barrierShift[309];
		int combo = barrierShift[310];
		if(flags&EZBF_8WAY)
			Ghost_Data = combo+8;
		else if(flags&EZBF_4WAY)
			Ghost_Data = combo+4;
		else
			Ghost_Data = combo+1;
		
		if(delayType==0){ //Normal delay
			if(movementStyle!=0) //Halting walk doesn't need a delay for most attacks
				EZB_Waitframes(this, ghost, barrierShift, EZB_WINDUP_ATTACK);
		}
		else if(delayType==1){ //Medium delay (shake)
			if(movementStyle!=0){
				int dX = 0;
				int dY = 0;
				for(int i=0; i<EZB_WINDUP_ATTACK_MED; i++){
					if(EZB_DO_WINDUP_SHAKE>1){
						Ghost_X -= dX;
						Ghost_Y -= dY;
						dX = Rand(-1, 1);
						dY = Rand(-1, 1);
						Ghost_X += dX;
						Ghost_Y += dY;
					}
					EZB_Waitframe(this, ghost, barrierShift);
				}
				Ghost_X -= dX;
				Ghost_Y -= dY;
			}
		}
		else if(delayType==2){ //Big delay (shake)
			int dX = 0;
			int dY = 0;
			for(int i=0; i<EZB_WINDUP_ATTACK_STRONG; i++){
				if(EZB_DO_WINDUP_SHAKE>0){
					Ghost_X -= dX;
					Ghost_Y -= dY;
					dX = Rand(-2, 2);
					dY = Rand(-2, 2);
					Ghost_X += dX;
					Ghost_Y += dY;
				}
				EZB_Waitframe(this, ghost, barrierShift);
			}
			Ghost_X -= dX;
			Ghost_Y -= dY;
		}
	}
	void EZB_Trail(ffc this, npc ghost, int barrierShift){
		if(!EZB_ENABLE_SPEEDTRAILS)
			return;
		
		int flags = barrierShift[309];
		int tile = Game->ComboTile(Ghost_Data);
		if(flags&EZBF_4WAY||flags&EZBF_8WAY)
			tile = Game->ComboTile(Ghost_Data+Ghost_Dir);
		lweapon trail = CreateLWeaponAt(LW_SCRIPT10, ghost->X+ghost->DrawXOffset, ghost->Y+ghost->DrawYOffset);
		trail->Extend = 3;
		trail->TileWidth = ghost->TileWidth;
		trail->TileHeight = ghost->TileHeight;
		trail->DrawYOffset = 0;
		trail->CSet = this->CSet;
		trail->Tile = tile;
		trail->OriginalTile = tile;
		trail->DrawStyle = DS_PHANTOM;
		trail->DeadState = 8;
	}
	int EZB_DirAngle(int dir){
		if(dir==DIR_UP)
			return -90;
		else if(dir==DIR_DOWN)
			return 90;
		else if(dir==DIR_LEFT)
			return 180;
		else if(dir==DIR_LEFTUP)
			return -135;
		else if(dir==DIR_RIGHTUP)
			return -45;
		else if(dir==DIR_LEFTDOWN)
			return 135;
		else if(dir==DIR_RIGHTDOWN)
			return 45;
		else
			return 0;
	}
	eweapon EZB_Fire(ffc this, npc ghost, int barrierShift, int x, int y, int angle, int step){
		eweapon e = EZB_Fire(this, ghost, barrierShift, x, y, angle, step, 0);
		return e;
	}
	eweapon EZB_Fire(ffc this, npc ghost, int barrierShift, int x, int y, int angle, int step, int wflags){
		int flags = barrierShift[309];
		int type = EZB_WeaponTypeToID(ghost->Weapon);
		if(flags&EZBF_UNBLOCKABLE)
			wflags |= EWF_UNBLOCKABLE;
		int fireSFX = barrierShift[307];
		int fireSPR = barrierShift[308];
		if(fireSPR==0&&(type==EW_BEAM||type==EW_ARROW||type==EW_MAGIC||type==EW_BOMB||type==EW_SBOMB))
			wflags |= EWF_ROTATE;
		
		if(fireSPR>=2000){
			wflags |= EWF_ROTATE_360;
			fireSPR -= 2000;
		}
		else if(fireSPR>=1000){
			wflags |= EWF_ROTATE;
			fireSPR -= 000;
		}
		int sfx = fireSFX;
		if(fireSFX<=0)
			sfx = -1;
		int spr = fireSPR;
		if(fireSPR<=0)
			spr = -1;
			
		eweapon e = FireEWeapon(type, x, y, DegtoRad(angle), step, ghost->WeaponDamage, spr, sfx, wflags);
		return e;
	}
	int EZB_WeaponTypeToID(int wpnt){
		if(wpnt == WPN_ENEMYFLAME) 		return EW_FIRE;
		else if(wpnt == WPN_ENEMYWIND)		return EW_WIND;
		else if(wpnt == WPN_ENEMYFIREBALL)	return EW_FIREBALL;
		else if(wpnt == WPN_ENEMYARROW)		return EW_ARROW;
		else if(wpnt == WPN_ENEMYBRANG)		return EW_BRANG;
		else if(wpnt == WPN_ENEMYSWORD)		return EW_BEAM;
		else if(wpnt == WPN_ENEMYROCK)		return EW_ROCK;
		else if(wpnt == WPN_ENEMYMAGIC)		return EW_MAGIC;
		else if(wpnt == WPN_ENEMYBOMB)		return EW_BOMBBLAST; //flipped bomb and lit bomb in older versions of this file. -Z ( 12th February, 2019 )
		else if(wpnt == WPN_ENEMYSBOMB)		return EW_SBOMBBLAST;
		else if(wpnt == WPN_ENEMYLITBOMB)	return EW_BOMB;
		else if(wpnt == WPN_ENEMYLITSBOMB)	return EW_SBOMB;
		else if(wpnt == WPN_ENEMYFIRETRAIL)	return EW_FIRETRAIL;
		else if(wpnt == WPN_ENEMYFLAME2)	return EW_FIRE2;
		else if(wpnt == WPN_ENEMYFIREBALL2)	return EW_FIREBALL2;
		return -1;
	}
	void EZB_SetEWeaponDeathEffect(eweapon e){
		if(e->ID==EW_FIRE||e->ID==EW_FIRE2){
			SetEWeaponDeathEffect(e, EWD_8_FIRES, -1);
		}
		else if(e->ID==EW_FIRETRAIL){
			SetEWeaponDeathEffect(e, EWD_FIRE, -1);
		}
		else if(e->ID==EW_BOMB){
			SetEWeaponDeathEffect(e, EWD_EXPLODE, e->Damage);
		}
		else if(e->ID==EW_SBOMB){
			SetEWeaponDeathEffect(e, EWD_SBOMB_EXPLODE, e->Damage);
		}
		else if(e->ID==EW_ARROW){
			SetEWeaponDeathEffect(e, EWD_4_FIREBALLS_HV, -1);
		}
		else if(e->ID==EW_MAGIC){
			SetEWeaponDeathEffect(e, EWD_AIM_AT_LINK, 16);
		}
		else{
			SetEWeaponDeathEffect(e, EWD_VANISH, -1);
		}
	}
	void EZB_DrawTeleport(ffc this, npc ghost, int barrierShift, int x, int y, int frame, int maxFrame){
		int w = Ghost_TileWidth;
		int h = Ghost_TileHeight;
		
		int flags = barrierShift[309];
		
		int cmb = Ghost_Data;
		if(flags&EZBF_4WAY||flags&EZBF_8WAY)
			cmb+=Ghost_Dir;
		
		int layer = 2;
		if(ScreenFlag(1, 4)) //Layer -2
			layer = 1;
		int i = frame/maxFrame;
		int op = 128;
		if(frame>maxFrame-8)
			op = 64;
		Screen->DrawCombo(layer, x+w*8*i, y-h*24*i, cmb, w, h, this->CSet, w*16-w*16*i, h*16+h*24*i, 0, 0, 0, -1, 0, true, op);
	}
	void EZB_Teleport(ffc this, npc ghost, int barrierShift){
		int size = barrierShift[306];
		int flags = barrierShift[309];
		int combo = barrierShift[310];
		int w = size&1111b;
		int h = (size>>4)&1111b;
		if(h==0)
			h = w;
		w = Clamp(w, 1, 4);
		h = Clamp(h, 1, 4);
		
		Game->PlaySound(SFX_EZB_TELEPORT);
		int tc;
		ghost->CollDetection = false;
		ghost->DrawYOffset = -1000;
		int oldCombo = Ghost_Data;
		for(int i=0; i<16; i++){
			if(EZB_TELEPORT_TYPE==1){
				EZB_DrawTeleport(this, ghost, barrierShift, Ghost_X, Ghost_Y-2, i, 16);
			}
			else if(EZB_TELEPORT_TYPE==2){
				ghost->DrawYOffset = -2;
				if(flags&EZBF_4WAY)
					Ghost_Data = combo+8;
				else if(flags&EZBF_8WAY)
					Ghost_Data = combo+16;
				else
					Ghost_Data = combo+2;
			}
			else{
				if(i%2==0)
					ghost->DrawYOffset = -1000;
				else
					ghost->DrawYOffset = -2;
			}
			EZB_Waitframe(this, ghost, barrierShift);
		}
		ghost->DrawYOffset = -1000;
		tc = Rand(176);
		for(int i=0; i<352&&(!EZB_CanPlace(this, ghost, ComboX(tc), ComboY(tc))||Distance(ComboX(tc)+ghost->HitWidth/2, ComboY(tc)+ghost->HitHeight/2, CenterLinkX(), CenterLinkY())<((w+h)/2)*8+32); i++){
			if(i>=176)
				tc = i-176;
			else
				tc = Rand(176);
		}
		Ghost_X = ComboX(tc);
		Ghost_Y = ComboY(tc);
		EZB_Waitframe(this, ghost, barrierShift);
		EZB_FaceLink(this, ghost, barrierShift);
		for(int i=0; i<16; i++){
			if(EZB_TELEPORT_TYPE==1){
				EZB_DrawTeleport(this, ghost, barrierShift, Ghost_X, Ghost_Y-2, 16-i, 16);
			}
			else if(EZB_TELEPORT_TYPE==2){
				ghost->DrawYOffset = -2;
				if(flags&EZBF_4WAY)
					Ghost_Data = combo+8;
				else if(flags&EZBF_8WAY)
					Ghost_Data = combo+16;
				else
					Ghost_Data = combo+2;
			}
			else{
				if(i%2==0)
					ghost->DrawYOffset = -1000;
				else
					ghost->DrawYOffset = -2;
			}
			EZB_Waitframe(this, ghost, barrierShift);
		}
		ghost->DrawYOffset = -2;
		Ghost_Data = oldCombo;
		ghost->CollDetection = true;
	}	
	int EZB_AngleDir(ffc this, npc ghost, int barrierShift, int angle){
		int flags = barrierShift[309];
		if(flags&EZBF_8WAY)
			return AngleDir8(angle);
		else
			return AngleDir4(angle);
	}
	float EZB_AngDiff(float angle1, float angle2){
		// Get the difference between the two angles
		float dif = angle2 - angle1;
		
		// Compensate for the difference being outside of normal bounds
		if(dif >= 180)
			dif -= 360;
		else if(dif <= -180)
			dif += 360;
			
		return dif;
	}
	void EZB_FaceLink(ffc this, npc ghost, int barrierShift){
		int flags = barrierShift[309];
		if(flags&EZBF_8WAY)
			Ghost_Dir = AngleDir8(Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY()));
		else
			Ghost_Dir = AngleDir4(Angle(CenterX(ghost), CenterY(ghost), CenterLinkX(), CenterLinkY()));
	}
	void EZB_FaceAngle(ffc this, npc ghost, int barrierShift, int angle){
		int flags = barrierShift[309];
		if(flags&EZBF_8WAY)
			Ghost_Dir = AngleDir8(angle);
		else
			Ghost_Dir = AngleDir4(angle);
	}
	bool EZB_CanPlace(ffc this, npc ghost, int X, int Y){
		for(int x=ghost->HitXOffset; x<=ghost->HitXOffset+ghost->HitWidth-1; x=Min(x+8, ghost->HitXOffset+ghost->HitWidth-1)){
			for(int y=ghost->HitYOffset; y<=ghost->HitYOffset+ghost->HitHeight-1; y=Min(y+8, ghost->HitYOffset+ghost->HitHeight-1)){
				if(!Ghost_CanMovePixel(X+x, Y+y))
					return false;
				if(y==ghost->HitYOffset+ghost->HitHeight-1)
					break;
			}
			if(x==ghost->HitXOffset+ghost->HitWidth-1)
				break;
		}
		return true;
	}
	bool EZB_CanPlace(ffc this, npc ghost, int X, int Y, int W, int H){
		for(int x=0; x<=W-1; x=Min(x+8, W-1)){
			for(int y=0; y<=H-1; y=Min(y+8, H-1)){
				if(!Ghost_CanMovePixel(X+x, Y+y))
					return false;
				if(y==H-1)
					break;
			}
			if(x==W-1)
				break;
		}
		return true;
	}
	bool EZB_RotRectCollision(float x1c, float y1c, float height1, float width1, float rot1, float x2c, float y2c, float height2, float width2, float rot2){
		float rad1=Sqrt(height1*height1+width1*width1);
		float rad2=Sqrt(height2*height2+width2*width2);
		float angle1=RadtoDeg(ArcSin(height1/rad1));
		float angle2=RadtoDeg(ArcSin(height2/rad2));
		float x1[4];
		float y1[4];
		float x2[4];
		float y2[4];
		float axisX[4];
		float axisY[4];
		float proj;
		float minProj1;
		float maxProj1;
		float minProj2;
		float maxProj2;
		x1[0]=x1c+rad1*Cos(rot1-angle1);
		y1[0]=y1c+rad1*Sin(rot1-angle1);
		x1[1]=x1c+rad1*Cos(rot1+angle1);
		y1[1]=y1c+rad1*Sin(rot1+angle1);
		x1[2]=x1c+rad1*Cos(rot1+180-angle1);
		y1[2]=y1c+rad1*Sin(rot1+180-angle1);
		x1[3]=x1c+rad1*Cos(rot1+180+angle1);
		y1[3]=y1c+rad1*Sin(rot1+180+angle1);
		x2[0]=x2c+rad2*Cos(rot2-angle2);
		y2[0]=y2c+rad2*Sin(rot2-angle2);
		x2[1]=x2c+rad2*Cos(rot2+angle2);
		y2[1]=y2c+rad2*Sin(rot2+angle2);
		x2[2]=x2c+rad2*Cos(rot2+180-angle2);
		y2[2]=y2c+rad2*Sin(rot2+180-angle2);
		x2[3]=x2c+rad2*Cos(rot2+180+angle2);
		y2[3]=y2c+rad2*Sin(rot2+180+angle2);
		axisX[0]=x1[0]-x1[1];
		axisY[0]=y1[0]-y1[1];
		axisX[1]=x1[2]-x1[1];
		axisY[1]=y1[2]-y1[1];
		axisX[2]=x2[0]-x2[1];
		axisY[2]=y2[0]-y2[1];
		axisX[3]=x2[2]-x2[1];
		axisY[3]=y2[2]-y2[1];
		// if(true){ //Debug draws
			// Screen->Rectangle(5, x1c-width1, y1c-height1, x1c+width1, y1c+height1, 1, -1, x1c, y1c, rot1, true, 128);
			// Screen->Rectangle(5, x2c-width2, y2c-height2, x2c+width2, y2c+height2, 2, -1, x2c, y2c, rot2, true, 128);
		// }
		for(int i=0; i<4; i++){
			proj=x1[0]*axisX[i]+y1[0]*axisY[i];
			minProj1=proj;
			maxProj1=proj;
			for(int j=1; j<4; j++){
				proj=x1[j]*axisX[i]+y1[j]*axisY[i];
				if(proj<minProj1)
					minProj1=proj;
				if(proj>maxProj1)
					maxProj1=proj;
			}
			proj=x2[0]*axisX[i]+y2[0]*axisY[i];
			minProj2=proj;
			maxProj2=proj;
			for(int j=1; j<4; j++){
				proj=x2[j]*axisX[i]+y2[j]*axisY[i];
				if(proj<minProj2)
					minProj2=proj;
				if(proj>maxProj2)
					maxProj2=proj;
			}
			if(maxProj2<minProj1 || maxProj1<minProj2)
				return false;
		}
		return true;
	}
	void EZB_DrawLaser(int layer, int x, int y, int width, int angle, int color){
		if(ScreenFlag(1, 4)&&layer==2) //Layer -2
			layer = 1;
		else if(ScreenFlag(1, 5)&&layer==3) //Layer -3
			layer = 4;
		Screen->Circle(layer, x+width, y, width, color, 1, x, y, angle, true, 128);
		Screen->Rectangle(layer, x+width, y-width, x+width+512, y+width, color, 1, x, y, angle, true, 128);
	}
	void EZB_DrawLaser3Color(int layer, int x, int y, int width, int angle, int color1, int color2, int color3){
		EZB_DrawLaser(layer, x, y, width, angle, color1);
		EZB_DrawLaser(layer, x, y, width/4*3, angle, color2);
		EZB_DrawLaser(layer, x, y, width/2, angle, color3);
	}
	bool EZB_LaserCollision(int x, int y, int width, int angle){
		int hitWidth = Max(1, width-3);
		int cX = x+VectorX(width, angle);
		int cY = y+VectorY(width, angle);
		if(Distance(CenterLinkX(), CenterLinkY(), cX, cY)<width)
			return true;
		return EZB_RotRectCollision(x+VectorX(width+128, angle), y+VectorY(width+128, angle), hitWidth, 128, angle, CenterLinkX(), CenterLinkY(), 4, 4, 0);
	}
	void EZB_Laser3Color(int layer, int x, int y, int width, int angle, int damage, int color1, int color2, int color3){
		if(ScreenFlag(1, 4)&&layer==2) //Layer -2
			layer = 1;
		else if(ScreenFlag(1, 5)&&layer==3) //Layer -3
			layer = 4;
		EZB_DrawLaser3Color(layer, x, y, width, angle, color1, color2, color3);
		if(EZB_LaserCollision(x, y, width, angle)){
			EZB_DamageLink(damage);
		}
	}
	void EZB_Shockwave(int layer, int x, int y, int rad1, int rad2, int rings, int damage, int color1, int color2, int color3){
		if(ScreenFlag(1, 4)&&layer==2) //Layer -2
			layer = 1;
		else if(ScreenFlag(1, 5)&&layer==3) //Layer -3
			layer = 4;
		int clr = Choose(color1, color2, color3);
		for(int i=0; i<rings; i++){
			if(rad1-i*2>0&&rad1-i*2<rad2){
				Screen->Circle(layer, x, y, rad1-i*2, clr, 1, 0, 0, 0, false, 128);
			}
		}
		int r = Min(rad1, rad2);
		if(Distance(CenterLinkX(), CenterLinkY(), x, y)<r){
			EZB_DamageLink(damage);
		}
	}
	void EZB_DamageLink(int damage){
		eweapon e = FireEWeapon(EW_SCRIPT10, Link->X+InFrontX(Link->Dir, 12), Link->Y+InFrontY(Link->Dir, 12), 0, 0, damage, -1, -1, EWF_UNBLOCKABLE);
		e->Dir = Link->Dir;
		e->DrawYOffset = -1000;
		SetEWeaponLifespan(e, EWL_TIMER, 1);
		SetEWeaponDeathEffect(e, EWD_VANISH, 0);
	}
	void EZB_Explode(ffc this, npc ghost, bool flash){
		int baseX=Ghost_X+ghost->DrawXOffset;
		int baseY=(Ghost_Y+ghost->DrawYOffset)-(Ghost_Z+ghost->DrawZOffset);
		
		__DeathAnimStart(this, ghost);
		__DeathAnimSFX(ghost->ID, ghost->X);
		
		if(flash)
			__Ghost_FlashCounter=10000;
		else
			__Ghost_FlashCounter=0;
		
		// One explosion every 16 frames, 15 times
		for(int i=0; i<15; i++)
		{
			EZB_CreateDeathExplosion(baseX+Rand(16*Ghost_TileWidth)-8, baseY+Rand(16*Ghost_TileHeight)-8);
			
			for(int j=0; j<16; j++)
			{
				Ghost_SetPosition(this, ghost); // Make sure it doesn't wander off
				if(flash)
					__Ghost_UpdateFlashing(this, ghost);
				Ghost_WaitframeLight(this, ghost);
			}
		}
		
		__DeathAnimEnd(this, ghost);
	}
	void EZB_CreateDeathExplosion(int x, int y){
		Game->PlaySound(SFX_BOMB);
		
		lweapon explosion=Screen->CreateLWeapon(LW_EZB_DEATHEXPLOSION);
		explosion->X = x-(WIDTH_EZB_DEATHEXPLOSION-1)*8;
		explosion->Y = y-(HEIGHT_EZB_DEATHEXPLOSION-1)*8;
		
		explosion->Extend = 3;
		explosion->TileWidth = WIDTH_EZB_DEATHEXPLOSION;
		explosion->TileHeight = HEIGHT_EZB_DEATHEXPLOSION;
		
		explosion->UseSprite(SPR_EZB_DEATHEXPLOSION);
		explosion->CollDetection = false;
		explosion->DeadState = explosion->NumFrames*explosion->ASpeed;
	}
	void EZB_Barriershift_Store(npc ghost, int newForm, int barrierShift){
		int i;
		
		npc n = CreateNPCAt(newForm, 128, -1000);
		
		barrierShift[000] = Ghost_CSet;
		barrierShift[001] = ghost->Damage;
		barrierShift[002] = ghost->WeaponDamage;
		barrierShift[003] = ghost->Hunger;
		barrierShift[004] = ghost->Rate;
		barrierShift[005] = ghost->Haltrate;
		barrierShift[006] = ghost->Homing;
		barrierShift[007] = ghost->Step;
		barrierShift[008] = ghost->Weapon;
		barrierShift[009] = ghost->ItemSet;
		barrierShift[010] = ghost->SFX;
		for(i=0; i<11; i++){
			barrierShift[011+i] = ghost->Attributes[i];
		}
		for(i=0; i<18; i++){
			barrierShift[022+i] = ghost->Defense[i];
		}
		
		barrierShift[100] = n->CSet;
		barrierShift[101] = n->Damage;
		barrierShift[102] = n->WeaponDamage;
		barrierShift[103] = n->Hunger;
		barrierShift[104] = n->Rate;
		barrierShift[105] = n->Haltrate;
		barrierShift[106] = n->Homing;
		barrierShift[107] = n->Step;
		barrierShift[108] = n->Weapon;
		barrierShift[109] = n->ItemSet;
		barrierShift[110] = n->SFX;
		for(i=0; i<11; i++){
			barrierShift[111+i] = n->Attributes[i];
		}
		for(i=0; i<18; i++){
			barrierShift[122+i] = n->Defense[i];
		}
		
		barrierShift[200] = 1;
		barrierShift[201] = 0;
		
		n->HP = -1000;
		n->DrawXOffset = -1000;
		n->DrawYOffset = -1000;
		n->ItemSet = 0;
		n->CollDetection = false;
		
		//Flag the enemy as already used by ghost.zh so it doesn't run a script
		n->Misc[__GHI_NPC_DATA] = 0x10000;
	}
	void EZB_Barriershift_Load(npc ghost, int barrierShift, bool onlyDefenses){
		int i;
		int startIndex = 0;
		if(barrierShift[201]==0)
			startIndex = 100;
		
		Ghost_CSet = barrierShift[startIndex+000];
		if(!onlyDefenses){
			ghost->Damage = barrierShift[startIndex+001];
			ghost->WeaponDamage = barrierShift[startIndex+002];
			ghost->Hunger = barrierShift[startIndex+003];
			ghost->Rate = barrierShift[startIndex+004];
			ghost->Haltrate = barrierShift[startIndex+005];
			ghost->Homing = barrierShift[startIndex+006];
			ghost->Step = barrierShift[startIndex+007];
			ghost->Weapon = barrierShift[startIndex+008];
			ghost->ItemSet = barrierShift[startIndex+009];
			ghost->SFX = barrierShift[startIndex+010];
			
			for(i=0; i<11; i++){
				barrierShift[300+i] = barrierShift[startIndex+011+i];
			}
		}
		
		for(i=0; i<18; i++){
			ghost->Defense[i] = barrierShift[startIndex+022+i];
		}
	
		if(barrierShift[201]==0)
			barrierShift[201] = 1;
		else
			barrierShift[201] = 0;
	}
	int EZB_NumSummons(npc summons){
		int count;
		for(int i=0; i<256; i++){
			if(summons[i]->isValid()){
				count++;
			}
		}
		return count;
	}
	void EZB_AddSummon(npc n, npc summons){
		for(int i=0; i<256; i++){
			if(!summons[i]->isValid()){
				summons[i] = n;
				return;
			}
		}
	}
	void EZB_Waitframes(ffc this, npc ghost, int barrierShift, int frames){
		for(int i=0; i<frames; i++){
			EZB_Waitframe(this, ghost, barrierShift);
		}
	}
	void EZB_Waitframe(ffc this, npc ghost, int barrierShift){
		int flags = barrierShift[309];
		if(flags&EZBF_NOCOLL){
			ghost->Stun = 60;
		}
		if(flags&EZBF_NOSTUN){
			ghost->Stun = 0;
		}
		
		if(flags&EZBF_EXPLODEEATH){
			if(SPR_EZB_DEATHEXPLOSION>0){
				if(!Ghost_Waitframe(this, ghost, false, false)){
					EZB_Explode(this, ghost, EZB_DEATH_FLASH);
					Quit();
				}
			}
			else
				Ghost_Waitframe(this, ghost, 1, true);
		}
		else
			Ghost_Waitframe(this, ghost);
	}
}