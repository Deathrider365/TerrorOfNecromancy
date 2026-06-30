int SetDBit(int dbit, bool set){
	#option BINARY_32BIT on
	int d = Floor(dbit/32);
	int db = 1b<<(dbit%32);
	
	if(!set){
		Screen->D[d] &= ~db;
	}
	else{
		Screen->D[d] |= db;
	}
}

bool GetDBit(int dbit){
	#option BINARY_32BIT on
	int d = Floor(dbit/32);
	int db = 1b<<(dbit%32);
	
	return Screen->D[d]&db;
}

int Wrap(int val, int min, int max){
	if(val<min){
		val += (max-min);
	}
	else if(val>=max)
		val -= (max-min);
	return val;
}

int DirX(int dir, int step){
	if(dir==DIR_UP)
		return 0;
	else if(dir==DIR_DOWN)
		return 0;
	else if(dir==DIR_LEFT)
		return -step;
	else if(dir==DIR_RIGHT)
		return step;
	else if(dir==DIR_LEFTUP)
		return -step;
	else if(dir==DIR_RIGHTUP)
		return step;
	else if(dir==DIR_LEFTDOWN)
		return -step;
	else if(dir==DIR_RIGHTDOWN)
		return step;
}

int DirY(int dir, int step){
	if(dir==DIR_LEFT)
		return 0;
	else if(dir==DIR_RIGHT)
		return 0;
	else if(dir==DIR_UP)
		return -step;
	else if(dir==DIR_DOWN)
		return step;
	else if(dir==DIR_LEFTUP)
		return -step;
	else if(dir==DIR_RIGHTUP)
		return -step;
	else if(dir==DIR_LEFTDOWN)
		return step;
	else if(dir==DIR_RIGHTDOWN)
		return step;
}

int ComboSCombined(int pos){
	mapdata l1 = Game->LoadTempScreen(1);
	mapdata l2 = Game->LoadTempScreen(2);
	return Screen->ComboS[pos]|l1->ComboS[pos]|l2->ComboS[pos];
}

//Returns true if item button is held on A or B
bool ItemButtonHeld(itemdata idat){
	if(Link->ItemA==idat->ID&&Link->InputA)
		return true;
	if(Link->ItemB==idat->ID&&Link->InputB)
		return true;
	if(Link->ItemX==idat->ID&&Link->InputEx1)
		return true;
	if(Link->ItemY==idat->ID&&Link->InputEx2)
		return true;
}

void NoButton(){
	Link->InputR = false; Link->PressR = false;
	Link->InputL = false; Link->PressL = false;
	Link->InputA = false; Link->PressA = false;
	Link->InputB = false; Link->PressB = false;
	Link->InputEx1 = false; Link->PressEx1 = false;
	Link->InputEx2 = false; Link->PressEx2 = false;
	Link->InputEx3 = false; Link->PressEx3 = false;
	Link->InputEx4 = false; Link->PressEx4 = false;
}
void NoItem(){
	Link->InputA = false; Link->PressA = false;
	Link->InputB = false; Link->PressB = false;
	Link->InputEx1 = false; Link->PressEx1 = false;
	Link->InputEx2 = false; Link->PressEx2 = false;
}
void NoWalk(){
	Link->InputUp = false; Link->PressUp = false;
	Link->InputDown = false; Link->PressDown = false;
	Link->InputLeft = false; Link->PressLeft = false;
	Link->InputRight = false; Link->PressRight = false;
}
void NoMenu(){
	Link->InputStart = false; Link->PressStart = false;
	Link->InputMap = false; Link->PressMap = false;
}

//Makes a hitbox with ghost.zh weapons
eweapon MakeHitbox(int wt, int x, int y, int w, int h, int damage){
	eweapon e = FireEWeapon(wt, 120, 80, 0, 0, damage, 0, 0, EWF_UNBLOCKABLE);
	e->HitXOffset = x-e->X;
	e->HitYOffset = y-e->Y;
	e->DrawYOffset = -1000;
	e->HitWidth = w;
	e->HitHeight = h;
	SetEWeaponLifespan(e, EWL_TIMER, 1);
	SetEWeaponDeathEffect(e, EWD_VANISH, 0);
	return e;
}

eweapon IgnoreLinkZ(npc n){
	eweapon hitbox = MakeHitbox(EW_PHYSICAL, n->X+n->HitXOffset, n->Y+n->HitYOffset, n->HitWidth, n->HitHeight, n->Damage);
	hitbox->Z = Link->Z;
	return hitbox;
}

const int LWS_ONEFRAME = 2;
const int LWS_TIMEOUT = 9;

lweapon FireLWeapon(int type, int x, int y, int angle, int step, int damage, int sprite, int sfx){
	if(sfx)
		Game->PlaySound(sfx);
	lweapon l = CreateLWeaponAt(type, x, y);
	l->Angular = true;
	l->Angle = DegtoRad(angle);
	l->Step = step;
	l->Damage = damage;
	if(sprite>0)
		l->UseSprite(sprite);
	else
		l->DrawYOffset = -1000;
	return l;
}

lweapon ParticleAnim(int x, int y, int w, int h, int tile, int cset, int frames, int aspeed){
	lweapon l = CreateLWeaponAt(LW_SPARKLE, x, y);
	l->OriginalTile = tile;
	l->Tile = l->OriginalTile;
	l->CSet = cset;
	l->NumFrames = frames;
	l->ASpeed = aspeed;
	l->CollDetection = false;
	l->Extend = 3;
	l->TileWidth = w;
	l->TileHeight = h;
	return l;
}
lweapon ParticleAnim(int x, int y, int tile, int cset, int frames, int aspeed){
	lweapon l = CreateLWeaponAt(LW_SPARKLE, x, y);
	l->OriginalTile = tile;
	l->Tile = l->OriginalTile;
	l->CSet = cset;
	l->NumFrames = frames;
	l->ASpeed = aspeed;
	l->CollDetection = false;
	return l;
}
lweapon ParticleAnim(int x, int y, int spr){
	lweapon l = CreateLWeaponAt(LW_SPARKLE, x, y);
	l->UseSprite(spr);
	l->CollDetection = false;
	return l;
}

lweapon ParticleAnimTimed(int x, int y, int tile, int cset, int frames, int aspeed, int deadstate){
	lweapon l = CreateLWeaponAt(LW_SCRIPT10, x, y);
	l->OriginalTile = tile;
	l->Tile = l->OriginalTile;
	l->NumFrames = frames;
	l->ASpeed = aspeed;
	l->CollDetection = false;
	l->Script = LWS_TIMEOUT;
	l->InitD[0] = deadstate;
	return l;
}

//Makes a hitbox with ghost.zh weapons
lweapon MakeHitboxLW(int wt, int x, int y, int w, int h, int damage, int dir){
	int xw = x+w;
	int yh = y+h;
	if(x<0){
		w += x;
		x = 0;
	}
	if(xw>255){
		w -= xw-255;
	}
	if(y<0){
		h += y;
		y = 0;
	}
	if(yh>175){
		h -= yh-175;
	}
	lweapon l = CreateLWeaponAt(wt, 120, 80);
	l->Damage = damage;
	l->Dir = dir;
	l->HitXOffset = x-l->X;
	l->HitYOffset = y-l->Y;
	l->DrawYOffset = -1000;
	l->HitWidth = w;
	l->HitHeight = h;
	l->Script = LWS_ONEFRAME;
	return l;
}

lweapon script OneFrame{
	void run(){
		Waitframe();
		this->DeadState = 0;
	}
}

lweapon script Timeout{
	void run(int frames){
		//This is using InitD[] instead of frames because other scripts can reset the timer
		while(this->InitD[0]>0){
			--this->InitD[0];
			Waitframe();
		}
		this->DeadState = 0;
	}
}

lweapon script LayerSpriteAnim{
	void run(int layer){
		while(true){
			Screen->FastTile(layer, this->X, this->Y, this->Tile, this->CSet, 128);
			Waitframe();
		}
	}
}

void RunEWeaponScript(eweapon e, char32 name, untyped args){
	e->Script = Game->GetEWeaponScript(name);
	int size = SizeOfArray(args);
	for(int i=0; i<size; ++i){
		e->InitD[i] = args[i];
	}
}

void RunLWeaponScript(lweapon l, char32 name, untyped args){
	l->Script = Game->GetLWeaponScript(name);
	int size = SizeOfArray(args);
	for(int i=0; i<size; ++i){
		l->InitD[i] = args[i];
	}
}

eweapon RunEWeaponEffect(eweapon e, char32 name, untyped args){
	e->CollDetection = false;
	e->DrawYOffset = -1000;
	RunEWeaponScript(e, name, args);
}

eweapon RunEWeaponEffect(int x, int y, char32 name, untyped args){
	eweapon e = CreateEWeaponAt(EW_SCRIPT10, x, y);
	e->CollDetection = false;
	e->DrawYOffset = -1000;
	RunEWeaponScript(e, name, args);
}

lweapon RunLWeaponEffect(int x, int y, char32 name, untyped args){
	lweapon l = CreateLWeaponAt(LW_SCRIPT10, x, y);
	l->CollDetection = false;
	l->DrawYOffset = -1000;
	RunLWeaponScript(l, name, args);
}

void RunItemActiveScript(int itemid){
	itemdata id = Game->LoadItemData(itemid);
	id->RunScript(2);
}

bool PressButtonItem(int itm){
	if(Link->ItemA==itm&&Link->PressA)return true;
	else if(Link->ItemB==itm&&Link->PressB)return true;
	else if(Link->ItemX==itm&&Link->PressEx1)return true;
	else if(Link->ItemY==itm&&Link->PressEx2)return true;
	return false;
}
bool InputButtonItem(int itm){
	if(Link->ItemA==itm&&Link->InputA)return true;
	else if(Link->ItemB==itm&&Link->InputB)return true;
	else if(Link->ItemX==itm&&Link->InputEx1)return true;
	else if(Link->ItemY==itm&&Link->InputEx2)return true;
	return false;
}

bool PressButtonItemGlobal(int itm){
	if(Link->ItemA==itm&&G[G_AINPUT]==2)return true;
	else if(Link->ItemB==itm&&G[G_BINPUT]==2)return true;
	else if(Link->ItemX==itm&&G[G_XINPUT]==2)return true;
	else if(Link->ItemY==itm&&G[G_YINPUT]==2)return true;
	return false;
}
bool InputButtonItemGlobal(int itm){
	if(Link->ItemA==itm&&G[G_AINPUT])return true;
	else if(Link->ItemB==itm&&G[G_BINPUT])return true;
	else if(Link->ItemX==itm&&G[G_XINPUT])return true;
	else if(Link->ItemY==itm&&G[G_YINPUT])return true;
	return false;
}

bool InputButtonItemEx(int itm){
	if(Link->ItemA==itm&&Link->InputA)return true;
	else if(Link->ItemB==itm&&Link->InputB)return true;
	else if(Link->ItemX==itm&&Link->InputEx1)return true;
	else if(Link->ItemY==itm&&Link->InputEx2)return true;
	return false;
}

int HitboxCenterX(lweapon l){
	return l->X+l->HitXOffset+l->HitWidth/2;
}

int HitboxCenterY(lweapon l){
	return l->Y+l->HitYOffset+l->HitHeight/2;
}

int HitboxCenterX(npc n){
	return n->X+n->HitXOffset+n->HitWidth/2;
}

int HitboxCenterY(npc n){
	return n->Y+n->HitYOffset+n->HitHeight/2;
}

// Function to get the difference between two angles
float AngDiff(float angle1, float angle2)
{
	// Get the difference between the two angles
	float dif = angle2 - angle1;
	
	// Compensate for the difference being outside of normal bounds
	if(dif >= 180)
		dif -= 360;
	else if(dif <= -180)
		dif += 360;
		
	return dif;
}

// Function to turn one angle towards another angle by a fixed amount
float TurnToAngle(float angle1, float angle2, float step){
	if(Abs(AngDiff(angle1, angle2))>step){
		return angle1 + Sign(AngDiff(angle1, angle2))*step;
	}
	else{
		return angle2;
	}
}

bool CanSeeLink(int x, int y, int dir, int sidedist){
	switch(dir){
		case DIR_UP:
			return Abs(Link->X-x)<sidedist&&Link->Y<y;
			break;
		case DIR_DOWN:
			return Abs(Link->X-x)<sidedist&&Link->Y>y;
			break;
		case DIR_LEFT:
			return Abs(Link->Y-y)<sidedist&&Link->X<x;
			break;
		case DIR_RIGHT:
			return Abs(Link->Y-y)<sidedist&&Link->X>x;
			break;
	}
}

int FindJumpLength(int jumpInput, bool inputFrames){
	//Big ol table of rough jump values and their durations
	int jumpTBL[] = 
	{
		0.0, 0,
		0.1, 3,
		0.2, 4,
		0.3, 5,
		0.4, 6,
		0.5, 8,
		0.6, 9,
		0.7, 10,
		0.8, 11,
		0.9, 13,
		1.0, 14,
		1.1, 15,
		1.2, 16,
		1.3, 18,
		1.4, 19,
		1.5, 20,
		1.6, 21,
		1.7, 23,
		1.8, 24,
		1.9, 25,
		2.0, 26,
		2.1, 28,
		2.2, 29,
		2.3, 30,
		2.4, 31,
		2.5, 33,
		2.6, 34,
		2.7, 35,
		2.8, 36,
		2.9, 38,
		3.0, 39,
		3.1, 40,
		3.2, 41,
		3.3, 43,
		3.4, 44,
		3.5, 45,
		3.6, 47,
		3.7, 48,
		3.8, 49,
		3.9, 51,
		4.0, 52,
		4.1, 54,
		4.2, 55,
		4.3, 57,
		4.4, 58,
		4.5, 60,
		4.6, 61,
		4.7, 63,
		4.8, 64,
		4.9, 66,
		5.0, 67,
		5.1, 69,
		5.2, 71,
		5.3, 72,
		5.4, 74,
		5.5, 76,
		5.6, 77,
		5.7, 79,
		5.8, 81,
		5.9, 83,
		6.0, 85,
		6.1, 86,
		6.2, 88,
		6.3, 90,
		6.4, 92,
		6.5, 94,
		6.6, 96,
		6.7, 98,
		6.8, 100,
		6.9, 102,
		7.0, 104,
		7.1, 106,
		7.2, 108,
		7.3, 110,
		7.4, 112,
		7.5, 114,
		7.6, 116,
		7.7, 118,
		7.8, 120,
		7.9, 123,
		8.0, 125,
		8.1, 127,
		8.2, 129,
		8.3, 131,
		8.4, 134,
		8.5, 136,
		8.6, 138,
		8.7, 141,
		8.8, 143,
		8.9, 145,
		9.0, 148,
		9.1, 150,
		9.2, 153,
		9.3, 155,
		9.4, 158,
		9.5, 160,
		9.6, 162,
		9.7, 165,
		9.8, 168,
		9.9, 170,
		10.0, 173
	};

	//When getting a duration from a jump
	if(!inputFrames){
		//Keep values between 0 and 10, nothing beyond that would be sensible in most cases
		jumpInput = Clamp(jumpInput, 0, 10);
		//Round to the nearest 0.1
		jumpInput *= 10;
		jumpInput = Round(jumpInput);
		//In case there's some stupid reason this was here I'm leaving a comment,
		//but I'm pretty sure I'm just a moron.
		//jumpInput *= 0.1;
		
		return jumpTBL[jumpInput*2+1];
	}
	//When getting a jump from a duration
	else{
		int closestIndex = 0;
		int closest = 0;
		//Cycle through the table to find the closest duration to the desired one
		for(int i=1; i<100; i++){
			if(Abs(jumpTBL[i*2+1]-jumpInput)<Abs(closest-jumpInput)){
				closestIndex = i;
				closest = jumpTBL[i*2+1];
			}
		}
		
		return jumpTBL[closestIndex*2+0];
	}
}

// Stores a curve between three points into two position arrays
void BezierQuad(int arrX, int arrY, int length, int x1, int y1, int x2, int y2, int x3, int y3){
	for(int i=0; i<=length; i++){
		float t = i/length;
		int x = (1-t)*(1-t)*x1 + 2*(1-t)*t*x2 + t*t*x3;
		int y = (1-t)*(1-t)*y1 + 2*(1-t)*t*y2 + t*t*y3;
		
		arrX[i] = x;
		arrY[i] = y;
	}
}

void DrawLineBezier(int layer, int x, int y, int x2, int y2, int x3, int y3, int clr, int segments){
	int arrX[256];
	int arrY[256];
	BezierQuad(arrX, arrY, segments+1, x, y, x2, y2, x3, y3);
	for(int i=0; i<segments; ++i){
		Screen->Line(layer, arrX[i], arrY[i], arrX[i+1], arrY[i+1], clr, 1, 0, 0, 0, 128);
	}
}

// Like the above, put only calculating for one frame of the curve
void BezierQuadFrame(int xy, int frame, int length, int x1, int y1, int x2, int y2, int x3, int y3){
	float t = frame/length;
	int x = (1-t)*(1-t)*x1 + 2*(1-t)*t*x2 + t*t*x3;
	int y = (1-t)*(1-t)*y1 + 2*(1-t)*t*y2 + t*t*y3;
	
	xy[0] = x;
	xy[1] = y;
}


int LinkWalkFrame(){
	int tilemod = Link->Tile%20;
	if(tilemod>=0&&tilemod<=8){
		if(Link->Tile>=104120&&Link->Tile<=104228){
			return tilemod%3;
		}
	}
}

bool CanAttack(){
	return Link->Action==LA_NONE||Link->Action==LA_WALKING;
}
bool CanAttack(bool allowScrolling){
	return Link->Action==LA_NONE||Link->Action==LA_WALKING||(allowScrolling&&Link->Action==LA_SCROLLING);
}

bool CanSwapChar(){
	return Link->Action==LA_NONE||Link->Action==LA_WALKING||Link->Action==LA_SWIMMING;
}

bool CanBeMoved(){
	switch(Link->Action){
		case LA_DROWNING:
		case LA_FALLING:
			return false;
	}
	return true;
}

bool GotHit(){
	return Link->Action==LA_GOTHURTLAND||Link->Action==LA_GOTHURTWATER;
}

bool InWater(){
	return Link->Action==LA_SWIMMING||Link->Action==LA_DROWNING||Link->Action==LA_HOPPING||Link->Action==LA_DIVING;
}

void MakeSwordHitbox(int x, int y){
	lweapon l = CreateLWeaponAt(LW_SCRIPT10, x, y);
	l->Weapon = LW_SWORD;
	l->CollDetection = false;
	l->DrawYOffset = -1000;
	l->DeadState = 1;
	GrabItems(l);
}


// void MakeFireHitbox(int x, int y){
	// lweapon l = CreateLWeaponAt(LW_FIRE, x, y);
	// l->CollDetection = false;
	// l->DrawYOffset = -1000;
	// l->Script = LWS_ONEFRAME;
// }

bool IsBlockable(eweapon e){
	if(!e->CollDetection)
		return false;
	if(e->Misc[__EWI_LIFESPAN]==EWL_TIMER&&e->Misc[__EWI_LIFESPAN_ARG]<=2)
		return false;
	return (e->Misc[__EWI_FLAGS]&EWF_UNBLOCKABLE)==0;
}

int Dir8ToDir4(int dir8, int dir4){
	if(dir8<4)
		return dir8;
	switch(dir8){
		case DIR_LEFTUP:
			if(dir4==DIR_UP||dir4==DIR_LEFT)
				dir8 = dir4;
			else
				dir8 = DIR_LEFT;
			break;
		case DIR_RIGHTUP:
			if(dir4==DIR_UP||dir4==DIR_RIGHT)
				dir8 = dir4;
			else
				dir8 = DIR_RIGHT;
			break;
		case DIR_LEFTDOWN:
			if(dir4==DIR_DOWN||dir4==DIR_LEFT)
				dir8 = dir4;
			else
				dir8 = DIR_LEFT;
			break;
		case DIR_RIGHTDOWN:
			if(dir4==DIR_DOWN||dir4==DIR_RIGHT)
				dir8 = dir4;
			else
				dir8 = DIR_RIGHT;
			break;
	}
	return dir8;
}

int Dir8ToDir4Random(int dir8){
	switch(dir8){
		case DIR_LEFTUP:
			return Choose(DIR_LEFT, DIR_UP);
		case DIR_LEFTDOWN:
			return Choose(DIR_LEFT, DIR_DOWN);
		case DIR_RIGHTUP:
			return Choose(DIR_RIGHT, DIR_UP);
		case DIR_RIGHTDOWN:
			return Choose(DIR_RIGHT, DIR_DOWN);
		default:
			return dir8;
	}
}

void LoopingSFX(int timer, int looptime, int sfx){
	if(timer[0]==0)
		Game->PlaySound(sfx);
	++timer[0];
	if(timer[0]>=looptime)
		timer[0] = 0;
}

void QuadRay(int layer, int x1, int y1, int w1, int a1, int x2, int y2, int w2, int a2, int c){
	int x[4]; int y[4];
	x[0] = x1+VectorX(w1/2, a1-90);
	y[0] = y1+VectorY(w1/2, a1-90);
	x[1] = x1+VectorX(w1/2, a1+90);
	y[1] = y1+VectorY(w1/2, a1+90);
	x[2] = x2+VectorX(w2/2, a2+90);
	y[2] = y2+VectorY(w2/2, a2+90);
	x[3] = x2+VectorX(w2/2, a2-90);
	y[3] = y2+VectorY(w2/2, a2-90);
	Screen->Quad(layer, x[0], y[0], x[1], y[1], x[2], y[2], x[3], y[3], 1, 1, c, 0, -1, PT_FLAT);
}

int LightningBolt(int arr, int index, int layer, int x, int y, int angle, int startW, int segmentLen, int turnAngle, int segments, int c, bool generateNew){
	if(generateNew){
		int x1 = x;
		int y1 = y;
		for(int i=0; i<segments; ++i){
			int x2 = x1+VectorX(segmentLen, angle);
			int y2 = y1+VectorY(segmentLen, angle);
			int w1 = startW-startW*(i/segments);
			int w2 = startW-startW*((i+1)/segments);
			int angle2 = angle + Choose(-1, 1)*turnAngle;
			arr[index+4*i+0] = x1;
			arr[index+4*i+1] = y1;
			arr[index+4*i+2] = w1;
			arr[index+4*i+3] = angle;
			x1 = x2;
			y1 = y2;
			angle = angle2;
		}
		arr[index+4*segments+0] = x1;
		arr[index+4*segments+1] = y1;
		arr[index+4*segments+2] = 0;
		arr[index+4*segments+3] = angle;
	}
	for(int i=0; i<segments; ++i){
		QuadRay(layer, arr[index+4*i+0], arr[index+4*i+1], arr[index+4*i+2], arr[index+4*i+3], arr[index+4*(i+1)+0], arr[index+4*(i+1)+1], arr[index+4*(i+1)+2], arr[index+4*(i+1)+3], c);	
	}
}

const int GG_X = 0;
const int GG_Y = 1;
const int GG_Z = 2;
const int GG_JUMP = 3;
const int GG_VX = 4;
const int GG_VY = 5;
const int GG_AX = 6;
const int GG_AY = 7;
const int GG_PREVX = 8;
const int GG_PREVY = 9;
const int GG_CSET = 10;
const int GG_DIR = 11;
const int GG_DATA = 12;
const int GG_TILEWIDTH = 13;
const int GG_TILEHEIGHT = 14;
const int GG_FLAGS = 15;
const int GG_FLAGS2 = 16;
const int GG_INTFLAGS = 17;
const int GG_FLASHCOUNTER = 18;
const int GG_KNOCKBACKCOUNTER = 19;
const int GG_HP = 20;
const int GG_XOFFSETS = 21;
const int GG_YOFFSETS = 22;
		
bool IsGhosted(npc n){
	return (n->Misc[__GHI_NPC_DATA]&0x10000)!=0;
}	

int GhostGet(npc n, int index){
	if((n->Misc[__GHI_NPC_DATA]&0x10000)!=0){ //This flag is a check that what we're about to do is valid
		float aptr=n->Misc[__GHI_NPC_DATA]&0xFFFF; //This pulls the pointer for a size 24 array. That array is or'd with 0x10000 to form this misc value.
		if(aptr > 0){ //Make sure we have a valid array as an extra failsafe
			return aptr[index];
		}
	}
	else{
		switch(index){
			case GG_X: return n->X;
			case GG_Y: return n->Y;
			case GG_Z: return n->Z;
			case GG_JUMP: return n->Jump;
			case GG_CSET: return n->CSet;
			case GG_DIR: return n->Dir;
			case GG_DATA: return -n->Tile;
			case GG_TILEWIDTH: return n->TileWidth;
			case GG_TILEHEIGHT: return n->TileHeight;
			case GG_HP: return n->HP;
		}
	}
}

void GhostSet(npc n, int index, int val){
	if((n->Misc[__GHI_NPC_DATA]&0x10000)!=0){ //This flag is a check that what we're about to do is valid
		float aptr=n->Misc[__GHI_NPC_DATA]&0xFFFF; //This pulls the pointer for a size 24 array. That array is or'd with 0x10000 to form this misc value.
		if(aptr > 0){ //Make sure we have a valid array as an extra failsafe
			aptr[index] = val;
		}
	}
	else{
		switch(index){
			case GG_X: n->X = val; break;
			case GG_Y: n->Y = val; break;
			case GG_Z: n->Z = val; break;
			case GG_JUMP: n->Jump = val; break;
			case GG_CSET: n->CSet = val; break;
			case GG_DIR: n->Dir = val; break;
			case GG_DATA: n->Tile = Game->ComboTile(val); break;
			case GG_TILEWIDTH: n->TileWidth = val; break;
			case GG_TILEHEIGHT: n->TileHeight = val; break;
			case GG_HP: n->HP = val; break;
		}
	}
}

bool NPCSolidPixel(npc ghost, int x, int y){
	int pos = ComboAt(x, y);
	if(!ghost->MoveFlags[NPCMV_CAN_WATER_WALK]&&IsWater(pos))
		return true;
	if(!ghost->MoveFlags[NPCMV_CAN_PIT_WALK]&&IsPit(pos))
		return true;
	
	return Screen->isSolid(x, y);
}

bool NPCCanWalkX(npc ghost, int vX){
	int x;
	if(vX<0)
		x = ghost->X+ghost->HitXOffset+vX;
	else if(vX>0)
		x = ghost->X+ghost->HitXOffset+ghost->HitWidth-1+vX;
	else
		return true;
	int minY = ghost->Y+ghost->HitYOffset;
	int maxY = minY+ghost->HitHeight-1;
	for(int y=minY; y<maxY; y=Min(y+8, maxY)){
		if(NPCSolidPixel(ghost, x, y)||x<0||x>255||y<0||y>175)
			return false;
		if(y==maxY)
			break;
	}
	return true;
}

bool NPCCanWalkY(npc ghost, int vY){
	int y;
	if(vY<0)
		y = ghost->Y+ghost->HitYOffset+vY;
	else if(vY>0)
		y = ghost->Y+ghost->HitYOffset+ghost->HitHeight-1+vY;
	else
		return true;
	int minX = ghost->X+ghost->HitXOffset;
	int maxX = minX+ghost->HitWidth-1;
	for(int x=minX; x<maxX; x=Min(x+8, maxX)){
		if(NPCSolidPixel(ghost, x, y)||x<0||x>255||y<0||y>175)
			return false;
		if(y==maxX)
			break;
	}
	return true;
}

bool IsSolidLayer0(int x, int y){
	if(x<0||x>255||y<0||y>175)
		return false;
	int pos = ComboAt(x, y);
	int s = Screen->ComboS[pos];
	x %= 16;
	y %= 16;
	if(x<8){
		if(y<8){
			return s&0001b;
		}
		else{
			return s&0010b;
		}
	}
	else{
		if(y<8){
			return s&0100b;
		}
		else{
			return s&1000b;
		}
	}
}

bool IsSolidNoPit(int x, int y){
	int ct = Screen->ComboT[ComboAt(x, y)];
	switch(ct){
		case CT_LADDERHOOKSHOT:
		case CT_LADDERONLY:
		case CT_HOOKSHOTONLY:
			return false;
	}
	return Screen->isSolid(x, y);
}

eweapon QuickSword(int type, int x, int y, int angle, int step, int cmb, int cset, int damage){
	x += VectorX(step, angle);
	y += VectorY(step, angle);
	Screen->DrawCombo(2, x, y, cmb, 1, 1, cset, -1, -1, x, y, angle, -1, 0, true, 128);
	eweapon e = MakeHitbox(type, x, y, 16, 16, damage);
	return e;
}

eweapon QuickSword(int type, int x, int y, int angle, int step, int cmb, int cset, int flip, int damage){
	x += VectorX(step, angle);
	y += VectorY(step, angle);
	Screen->DrawCombo(2, x, y, cmb, 1, 1, cset, -1, -1, x, y, angle, -1, flip, true, 128);
	eweapon e = MakeHitbox(type, x, y, 16, 16, damage);
	return e;
}

eweapon QuickSword(int type, int x, int y, int angle, int step, int cmb, int cset, int flip, int op, int damage){
	x += VectorX(step, angle);
	y += VectorY(step, angle);
	if(op==96){
		Screen->DrawCombo(2, x, y, cmb, 1, 1, cset, -1, -1, x, y, angle, -1, flip, true, 64);
		Screen->DrawCombo(2, x, y, cmb, 1, 1, cset, -1, -1, x, y, angle, -1, flip, true, 64);
	}
	else
		Screen->DrawCombo(2, x, y, cmb, 1, 1, cset, -1, -1, x, y, angle, -1, flip, true, op);
	if(damage){
		eweapon e = MakeHitbox(type, x, y, 16, 16, damage);
		return e;
	}
}

eweapon QuickLongSword(int type, int x, int y, int angle, int step, int cmb, int cset, int len, int flip, int op, int damage){
	x += VectorX(step, angle);
	y += VectorY(step, angle);
	int rX = x-(8*(len-1))+VectorX(8*(len-1), angle);
	int rY = y+VectorY(8*(len-1), angle);
	if(op==96){
		Screen->DrawCombo(2, rX, rY, cmb, len, 1, cset, -1, -1, rX, rY, angle, -1, flip, true, 64);
		Screen->DrawCombo(2, rX, rY, cmb, len, 1, cset, -1, -1, rX, rY, angle, -1, flip, true, 64);
	}
	else
		Screen->DrawCombo(2, rX, rY, cmb, len, 1, cset, -1, -1, rX, rY, angle, -1, flip, true, op);
	if(damage){
		for(int i=0; i<len; ++i){
			eweapon e = MakeHitbox(type, x+VectorX(i*16, angle), y+VectorY(i*16, angle), 16, 16, damage);
		}
	}
}

lweapon QuickSwordLW(int type, int x, int y, int angle, int step, int cmb, int cset, int damage){
	x += VectorX(step, angle);
	y += VectorY(step, angle);
	Screen->DrawCombo(2, x, y, cmb, 1, 1, cset, -1, -1, x, y, angle, -1, 0, true, 128);
	lweapon l = MakeHitboxLW(type, x, y, 16, 16, damage, AngleDir4(angle));
	return l;
}

bool Ghost_CanMove8(int dir, int step, int imprecision, bool requireboth){
	if(requireboth){
		switch(dir){
			case DIR_LEFTUP:
				return Ghost_CanMove(DIR_LEFT, step, imprecision)&&Ghost_CanMove(DIR_UP, step, imprecision);
			case DIR_RIGHTUP:
				return Ghost_CanMove(DIR_RIGHT, step, imprecision)&&Ghost_CanMove(DIR_UP, step, imprecision);
			case DIR_LEFTDOWN:
				return Ghost_CanMove(DIR_LEFT, step, imprecision)&&Ghost_CanMove(DIR_DOWN, step, imprecision);
			case DIR_RIGHTDOWN:
				return Ghost_CanMove(DIR_RIGHT, step, imprecision)&&Ghost_CanMove(DIR_DOWN, step, imprecision);
			default:
				return Ghost_CanMove(dir, step, imprecision);
		}
	}
	else{
		switch(dir){
			case DIR_LEFTUP:
				return Ghost_CanMove(DIR_LEFT, step, imprecision)||Ghost_CanMove(DIR_UP, step, imprecision);
			case DIR_RIGHTUP:
				return Ghost_CanMove(DIR_RIGHT, step, imprecision)||Ghost_CanMove(DIR_UP, step, imprecision);
			case DIR_LEFTDOWN:
				return Ghost_CanMove(DIR_LEFT, step, imprecision)||Ghost_CanMove(DIR_DOWN, step, imprecision);
			case DIR_RIGHTDOWN:
				return Ghost_CanMove(DIR_RIGHT, step, imprecision)||Ghost_CanMove(DIR_DOWN, step, imprecision);
			default:
				return Ghost_CanMove(dir, step, imprecision);
		}
	}
}

bool Ghost_FindEdge(int xy, int angle){
	angle = WrapDegrees(angle);
	int startX = Ghost_X;
	int startY = Ghost_Y;
	int lastX = Ghost_X;
	int lastY = Ghost_Y;
	for(int i=0; i<256&&Ghost_CanMove8(AngleDir4(angle), 1, 0, true); i+=8){
		lastX = Ghost_X;
		lastY = Ghost_Y;
		Ghost_MoveAtAngle(angle, 8, 0);
	}
	Ghost_X = lastX;
	Ghost_Y = lastY;
	for(int i=0; i<8&&Ghost_CanMove8(AngleDir4(angle), 1, 0, true); ++i){
		lastX = Ghost_X;
		lastY = Ghost_Y;
		Ghost_MoveAtAngle(angle, i, 0);
	}
	xy[0] = Ghost_X;
	xy[1] = Ghost_Y;
	Ghost_X = startX;
	Ghost_Y = startY;
}

bool CanWalk8(int x, int y, int dir, int step, bool full_tile, bool requireboth){
	if(requireboth){
		switch(dir){
			case DIR_LEFTUP:
				return CanWalk(x, y, DIR_LEFT, step, full_tile)&&CanWalk(x, y, DIR_UP, step, full_tile);
			case DIR_RIGHTUP:
				return CanWalk(x, y, DIR_RIGHT, step, full_tile)&&CanWalk(x, y, DIR_UP, step, full_tile);
			case DIR_LEFTDOWN:
				return CanWalk(x, y, DIR_LEFT, step, full_tile)&&CanWalk(x, y, DIR_DOWN, step, full_tile);
			case DIR_RIGHTDOWN:
				return CanWalk(x, y, DIR_RIGHT, step, full_tile)&&CanWalk(x, y, DIR_DOWN, step, full_tile);
			default:
				return CanWalk(x, y, dir, step, full_tile);
		}
	}
	else{
		switch(dir){
			case DIR_LEFTUP:
				return CanWalk(x, y, DIR_LEFT, step, full_tile)||CanWalk(x, y, DIR_UP, step, full_tile);
			case DIR_RIGHTUP:
				return CanWalk(x, y, DIR_RIGHT, step, full_tile)||CanWalk(x, y, DIR_UP, step, full_tile);
			case DIR_LEFTDOWN:
				return CanWalk(x, y, DIR_LEFT, step, full_tile)||CanWalk(x, y, DIR_DOWN, step, full_tile);
			case DIR_RIGHTDOWN:
				return CanWalk(x, y, DIR_RIGHT, step, full_tile)||CanWalk(x, y, DIR_DOWN, step, full_tile);
			default:
				return CanWalk(x, y, dir, step, full_tile);
		}
	}
}

bool CanWalk8NoEdge(int x, int y, int dir, int step, bool full_tile, bool requireboth){
	if(requireboth){
		switch(dir){
			case DIR_LEFTUP:
				return CanWalkNoEdge(x, y, DIR_LEFT, step, full_tile)&&CanWalkNoEdge(x, y, DIR_UP, step, full_tile);
			case DIR_RIGHTUP:
				return CanWalkNoEdge(x, y, DIR_RIGHT, step, full_tile)&&CanWalkNoEdge(x, y, DIR_UP, step, full_tile);
			case DIR_LEFTDOWN:
				return CanWalkNoEdge(x, y, DIR_LEFT, step, full_tile)&&CanWalkNoEdge(x, y, DIR_DOWN, step, full_tile);
			case DIR_RIGHTDOWN:
				return CanWalkNoEdge(x, y, DIR_RIGHT, step, full_tile)&&CanWalkNoEdge(x, y, DIR_DOWN, step, full_tile);
			default:
				return CanWalkNoEdge(x, y, dir, step, full_tile);
		}
	}
	else{
		switch(dir){
			case DIR_LEFTUP:
				return CanWalkNoEdge(x, y, DIR_LEFT, step, full_tile)||CanWalkNoEdge(x, y, DIR_UP, step, full_tile);
			case DIR_RIGHTUP:
				return CanWalkNoEdge(x, y, DIR_RIGHT, step, full_tile)||CanWalkNoEdge(x, y, DIR_UP, step, full_tile);
			case DIR_LEFTDOWN:
				return CanWalkNoEdge(x, y, DIR_LEFT, step, full_tile)||CanWalkNoEdge(x, y, DIR_DOWN, step, full_tile);
			case DIR_RIGHTDOWN:
				return CanWalkNoEdge(x, y, DIR_RIGHT, step, full_tile)||CanWalkNoEdge(x, y, DIR_DOWN, step, full_tile);
			default:
				return CanWalkNoEdge(x, y, dir, step, full_tile);
		}
	}
}

bool CanWalkBig(int x, int y, int dir, int w, int h, int step, bool checkEdge){
	switch(dir){
		case DIR_UP:
			if(checkEdge&&y-step<0)
				return false;
			for(int i=0; i<=w-1; i=Min(i+8, w-1)){
				if(Screen->isSolid(x+i, y-step))
					return false;
				if(i==w-1)
					break;
			}
			return true;
		case DIR_DOWN:
			if(checkEdge&&y+h-1+step>175)
				return false;
			for(int i=0; i<=w-1; i=Min(i+8, w-1)){
				if(Screen->isSolid(x+i, y+h-1+step))
					return false;
				if(i==w-1)
					break;
			}
			return true;
		case DIR_LEFT:
			if(checkEdge&&x-step<0)
				return false;
			for(int i=0; i<=h-1; i=Min(i+8, h-1)){
				if(Screen->isSolid(x-step, y+i))
					return false;
				if(i==h-1)
					break;
			}
			return true;
		case DIR_RIGHT:
			if(checkEdge&&x+w-1+step>255)
				return false;
			for(int i=0; i<=h-1; i=Min(i+8, h-1)){
				if(Screen->isSolid(x+w-1+step, y+i))
					return false;
				if(i==h-1)
					break;
			}
			return true;
	}
}

bool CanWalk8Big(int x, int y, int dir, int w, int h, int step, bool checkEdge, bool requireboth){
	if(requireboth){
		switch(dir){
			case DIR_LEFTUP:
				return CanWalkBig(x, y, DIR_LEFT, w, h, step, checkEdge)&&CanWalkBig(x, y, DIR_UP, w, h, step, checkEdge);
			case DIR_RIGHTUP:
				return CanWalkBig(x, y, DIR_RIGHT, w, h, step, checkEdge)&&CanWalkBig(x, y, DIR_UP, w, h, step, checkEdge);
			case DIR_LEFTDOWN:
				return CanWalkBig(x, y, DIR_LEFT, w, h, step, checkEdge)&&CanWalkBig(x, y, DIR_DOWN, w, h, step, checkEdge);
			case DIR_RIGHTDOWN:
				return CanWalkBig(x, y, DIR_RIGHT, w, h, step, checkEdge)&&CanWalkBig(x, y, DIR_DOWN, w, h, step, checkEdge);
			default:
				return CanWalkBig(x, y, dir, w, h, step, checkEdge);
		}
	}
	else{
		switch(dir){
			case DIR_LEFTUP:
				return CanWalkBig(x, y, DIR_LEFT, w, h, step, checkEdge)||CanWalkBig(x, y, DIR_UP, w, h, step, checkEdge);
			case DIR_RIGHTUP:
				return CanWalkBig(x, y, DIR_RIGHT, w, h, step, checkEdge)||CanWalkBig(x, y, DIR_UP, w, h, step, checkEdge);
			case DIR_LEFTDOWN:
				return CanWalkBig(x, y, DIR_LEFT, w, h, step, checkEdge)||CanWalkBig(x, y, DIR_DOWN, w, h, step, checkEdge);
			case DIR_RIGHTDOWN:
				return CanWalkBig(x, y, DIR_RIGHT, w, h, step, checkEdge)||CanWalkBig(x, y, DIR_DOWN, w, h, step, checkEdge);
			default:
				return CanWalkBig(x, y, dir, w, h, step, checkEdge);
		}
	}
}

// bool IsWatersEdge(int pos){
	// int cd = Screen->ComboD[pos];
	// return cd>=7352&&cd<=7413&&Screen->ComboT[pos]!=CT_WATER;
// }

void GrabItems(lweapon hitbox){
	for(int i=Screen->NumItems(); i>0; --i){
		itemsprite itm = Screen->LoadItem(i);
		bool canGrab;
		if(itm->Pickup&IP_TIMEOUT&&!(itm->Pickup&IP_FADE))
			canGrab = true;
		if(itm->Misc[ITMM_SPECIALGRAB])
			canGrab = true;
		if(itm->Pickup&IP_DUMMY)
			canGrab = false;
		if(itm->Misc[ITMM_SPAWNSAFETY]!=1)
			canGrab = false;
		if(canGrab){
			if(Collision(itm, hitbox)){
				itm->Misc[ITMM_FORCEGRAB] = 1;
				itm->Pickup |= IP_FADE;
			}
		}
	}
}

int Decrement(int val, int amount){
	if(val>0)
		return Max(val-amount, 0);
	if(val<0)
		return Min(val+amount, 0);
	return 0;
}

int LazyChase(int val, int pos, int target, int accel, int topspeed){
	return Clamp(val+Sign(target-pos)*accel, -topspeed, topspeed);
}

void HandlePushArray(int PushArray, int Imprecision){
	for(int i=0; i<MAX_PUSH&&PushArray[0]<=-1; i++){
		if(CanWalk(PushArray[2], PushArray[3], DIR_LEFT, 1, false)){
			PushArray[2]--;
			PushArray[0]++;
		}
		else if(Imprecision>0&&Abs(GridY(PushArray[3]+8)-PushArray[3])<Imprecision&&CanWalk(PushArray[2], GridY(PushArray[3]+8), DIR_LEFT, 1, false)){
			PushArray[3] = GridY(PushArray[3]+8);
			PushArray[2]--;
			PushArray[0]++;
		}
		else{
			PushArray[0] = 0;
		}
	}
	for(int i=0; i<MAX_PUSH&&PushArray[0]>=1; i++){
		if(CanWalk(PushArray[2], PushArray[3], DIR_RIGHT, 1, false)){
			PushArray[2]++;
			PushArray[0]--;
		}
		else if(Imprecision>0&&Abs(GridY(PushArray[3]+8)-PushArray[3])<Imprecision&&CanWalk(PushArray[2], GridY(PushArray[3]+8), DIR_RIGHT, 1, false)){
			PushArray[3] = GridY(PushArray[3]+8);
			PushArray[2]++;
			PushArray[0]--;
		}
		else{
			PushArray[0] = 0;
		}
	}
	for(int i=0; i<MAX_PUSH&&PushArray[1]<=-1; i++){
		if(CanWalk(PushArray[2], PushArray[3], DIR_UP, 1, false)){
			PushArray[3]--;
			PushArray[1]++;
		}
		else if(Imprecision>0&&Abs(GridX(PushArray[2]+8)-PushArray[2])<Imprecision&&CanWalk(GridX(PushArray[2]+8), PushArray[3], DIR_UP, 1, false)){
			PushArray[2] = GridX(PushArray[2]+8);
			PushArray[3]--;
			PushArray[1]++;
		}
		else{
			PushArray[1] = 0;
		}
	}
	for(int i=0; i<MAX_PUSH&&PushArray[1]>=1; i++){
		if(CanWalk(PushArray[2], PushArray[3], DIR_DOWN, 1, false)){
			PushArray[3]++;
			PushArray[1]--;
		}
		else if(Imprecision>0&&Abs(GridX(PushArray[2]+8)-PushArray[2])<Imprecision&&CanWalk(GridX(PushArray[2]+8), PushArray[3], DIR_DOWN, 1, false)){
			PushArray[2] = GridX(PushArray[2]+8);
			PushArray[3]++;
			PushArray[1]--;
		}
		else{
			PushArray[1] = 0;
		}
	}
}

void HandlePushArrayNoEdge(int PushArray, int Imprecision){
	for(int i=0; i<MAX_PUSH&&PushArray[0]<=-1; i++){
		if(CanWalkNoEdge(PushArray[2], PushArray[3], DIR_LEFT, 1, false)){
			PushArray[2]--;
			PushArray[0]++;
		}
		else if(Imprecision>0&&Abs(GridY(PushArray[3]+8)-PushArray[3])<Imprecision&&CanWalkNoEdge(PushArray[2], GridY(PushArray[3]+8), DIR_LEFT, 1, false)){
			PushArray[3] = GridY(PushArray[3]+8);
			PushArray[2]--;
			PushArray[0]++;
		}
		else{
			PushArray[0] = 0;
		}
	}
	for(int i=0; i<MAX_PUSH&&PushArray[0]>=1; i++){
		if(CanWalkNoEdge(PushArray[2], PushArray[3], DIR_RIGHT, 1, false)){
			PushArray[2]++;
			PushArray[0]--;
		}
		else if(Imprecision>0&&Abs(GridY(PushArray[3]+8)-PushArray[3])<Imprecision&&CanWalkNoEdge(PushArray[2], GridY(PushArray[3]+8), DIR_RIGHT, 1, false)){
			PushArray[3] = GridY(PushArray[3]+8);
			PushArray[2]++;
			PushArray[0]--;
		}
		else{
			PushArray[0] = 0;
		}
	}
	for(int i=0; i<MAX_PUSH&&PushArray[1]<=-1; i++){
		if(CanWalkNoEdge(PushArray[2], PushArray[3], DIR_UP, 1, false)){
			PushArray[3]--;
			PushArray[1]++;
		}
		else if(Imprecision>0&&Abs(GridX(PushArray[2]+8)-PushArray[2])<Imprecision&&CanWalkNoEdge(GridX(PushArray[2]+8), PushArray[3], DIR_UP, 1, false)){
			PushArray[2] = GridX(PushArray[2]+8);
			PushArray[3]--;
			PushArray[1]++;
		}
		else{
			PushArray[1] = 0;
		}
	}
	for(int i=0; i<MAX_PUSH&&PushArray[1]>=1; i++){
		if(CanWalkNoEdge(PushArray[2], PushArray[3], DIR_DOWN, 1, false)){
			PushArray[3]++;
			PushArray[1]--;
		}
		else if(Imprecision>0&&Abs(GridX(PushArray[2]+8)-PushArray[2])<Imprecision&&CanWalkNoEdge(GridX(PushArray[2]+8), PushArray[3], DIR_DOWN, 1, false)){
			PushArray[2] = GridX(PushArray[2]+8);
			PushArray[3]++;
			PushArray[1]--;
		}
		else{
			PushArray[1] = 0;
		}
	}
}

bool IsFirstFFC(ffc this){
	for(int i=1; i<=32; ++i){
		ffc f = Screen->LoadFFC(i);
		if(f->Script==this->Script){
			if(f==this)
				return true;
			else
				return false;
		}
	}
	return false;
}

bool IsLastFFC(ffc this){
	ffc last;
	for(int i=1; i<=32; ++i){
		ffc f = Screen->LoadFFC(i);
		if(f->Script==this->Script){
			last = f;
		}
	}
	if(last==this)
		return true;
	return false;
}

int GetDamageComboDamage(int cmb){
	combodata cdat = Game->LoadComboData(cmb);
	switch(cdat->Type){
		case CT_DAMAGE1:
			return 2;
		case CT_DAMAGE2:
			return 4;
		case CT_DAMAGE3:
			return 8;	
		case CT_DAMAGE4:
			return 16;	
		case CT_DAMAGE5:
			return 32;
		case CT_DAMAGE6:
			return 64;
		case CT_DAMAGE7:
			return 128;
	}
}

//fuck math, yeah?
int SafeDiv(int a, int b){
	if(b==0)
		return 0;
	return a/b;
}

int DirCW(int dir){
	switch(dir){
		case DIR_UP: return DIR_RIGHT;
		case DIR_DOWN: return DIR_LEFT;
		case DIR_LEFT: return DIR_UP;
		case DIR_RIGHT: return DIR_DOWN;
	}
}

int DirCCW(int dir){
	switch(dir){
		case DIR_UP: return DIR_LEFT;
		case DIR_DOWN: return DIR_RIGHT;
		case DIR_LEFT: return DIR_DOWN;
		case DIR_RIGHT: return DIR_UP;
	}
}


bool CanWalkPush(int xy, int dir, int specialDir, int imprecision, bool fulltile){
	if(imprecision&&specialDir==dir&&!CanWalk(xy[0], xy[1], dir, 1, fulltile)){
		int sideDir = DirCW(dir);
		int oldX = xy[0];
		int oldY = xy[1];
		for(int i=0; i<imprecision; ++i){
			//Screen->PutPixel(6, xy[0]+DirX(dir, 16), xy[1]+DirY(dir, 16), 0x01+i, 0, 0, 0, 128);
			xy[0] += DirX(sideDir, 1);
			xy[1] += DirY(sideDir, 1);
			if(CanWalk(xy[0], xy[1], dir, 1, fulltile))
				return true;
		}
		xy[0] = oldX;
		xy[1] = oldY;
		for(int i=0; i<imprecision; ++i){
			//Screen->PutPixel(6, xy[0]+DirX(dir, 16), xy[1]+DirY(dir, 16), 0x01+i, 0, 0, 0, 128);
			xy[0] -= DirX(sideDir, 1);
			xy[1] -= DirY(sideDir, 1);
			if(CanWalk(xy[0], xy[1], dir, 1, fulltile))
				return true;
		}
		xy[0] = oldX;
		xy[1] = oldY;
	}
	return CanWalk(xy[0], xy[1], dir, 1, fulltile);
}

void HandlePush(int push, int xy, int imprecision, bool fulltile){
	int specialDir = AngleDir4(Angle(0, 0, push[0], push[1]));
	for(int i=0; i<Abs(Floor(push[0])); ++i){
		if(push[0]<0){
			if(CanWalkPush(xy, DIR_LEFT, specialDir, imprecision, fulltile)) //CanWalk(x, y, DIR_LEFT, 1, true))
				--xy[0];
			++push[0];
		}
		else if(push[0]>0){
			if(CanWalkPush(xy, DIR_RIGHT, specialDir, imprecision, fulltile)) //CanWalk(x, y, DIR_RIGHT, 1, true))
				++xy[0];
			--push[0];
		}
		else
			break;
	}
	for(int i=0; i<Abs(Floor(push[1])); ++i){
		if(push[1]<0){
			if(CanWalkPush(xy, DIR_UP, specialDir, imprecision, fulltile)) //CanWalk(x, y, DIR_UP, 1, true))
				--xy[1];
			++push[1];
		}
		else if(push[1]>0){
			if(CanWalkPush(xy, DIR_DOWN, specialDir, imprecision, fulltile)) //CanWalk(x, y, DIR_DOWN, 1, true))
				++xy[1];
			--push[1];
		}
		else
			break;
	}
}

void FastishTile(int layer, int x, int y, int til, int w, int h, int cset, int op){
	Screen->DrawTile(layer, x, y, til, w, h, cset, -1, -1, 0, 0, 0, 0, true, op);
}

void FastishCombo(int layer, int x, int y, int cmb, int w, int h, int cset, int op){
	Screen->DrawCombo(layer, x, y, cmb, w, h, cset, -1, -1, 0, 0, 0, -1, 0, true, op);
}

void KillDirInput(){
	Link->InputUp = false;
	Link->InputDown = false;
	Link->InputLeft = false;
	Link->InputRight = false;
	Link->InputR = false; 
	Link->InputL = false; 
	Link->InputEx1 = false; 
	Link->InputEx2 = false; 
	Link->InputEx3 = false; 
	Link->InputEx4 = false; 
	Link->PressEx1 = false; 
	Link->PressEx2 = false; 
	Link->PressEx3 = false; 
	Link->PressEx4 = false; 
	Link->InputStart = false;
	Link->PressStart = false;
	Link->PressMap = false;
	Link->InputMap = false;
}

void PlayTangoSubscreenMessage(int message, int style, int slot, int x, int y){
	Tango_ClearSlot(slot);
	Tango_LoadString(slot, message);
	Tango_SetSlotStyle(slot, style);
	Tango_SetSlotPosition(slot, x, y);
	Tango_ActivateSlot(slot);
}

void PlayTangoString(int string, int style, int x, int y){
	Tango_ClearSlot(0);
	Tango_LoadString(0, string);
	Tango_SetSlotStyle(0, style);
	Tango_SetSlotPosition(0, x, y);
	Tango_ActivateSlot(0);
	int timer;
	while(Tango_SlotIsActive(0)){
		KillDirInput();
		if(Link->InputA && !Tango_SlotIsFinished(0))
			Link->PressA;
		if(Tango_SlotIsFinished(0))
			timer++;
		if((Link->PressA || Link->PressB) && timer > 50){
			Tango_ClearSlot(0);
			break;
		}
		Waitframe();
	}
}

void DrawNamebox(int x, int y, int playertil, int emotetil, int namestr){
	int namesize = Text->StringWidth(namestr, FONT_Z3SMALL);
	//Portrait frame
	if(playertil>0)
		Screen->DrawTile(7, x-48, y, 65796, 3, 3, 11, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
	//Name frame
	Screen->FastTile(7, x-12, y-16, 65983, 11, OP_OPAQUE);
	Screen->DrawTile(7, x+4, y-16, TIL_ITEMPOPUP_BOX+23, 1, 1, 11, namesize+8, 16, 0, 0, 0, 0, true, OP_OPAQUE);
	Screen->FastTile(7, x+namesize+8+4, y-16, TIL_ITEMPOPUP_BOX+24, 11, 128);
	
	//Portrait
	if(playertil>0){
		Screen->DrawTile(7, x-32, y+10, playertil, 1, 2, 6, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
		if(emotetil)
			Screen->FastTile(7, x-32, y+10-8, emotetil, 0, 128);
	}
	//Name
	Screen->DrawString(7, x+8, y-12, FONT_Z3SMALL, 0xB2, -1, TF_NORMAL, namestr, OP_OPAQUE, SHD_OUTLINED8, 0x0F);

	//Backdrop
	Screen->DrawTile(7, x, y, 65907, 10, 3, 11, -1, -1, 0, 0, 0, 0, true, 128);
	
	if(Tango_SlotIsFinished(0))
		Screen->FastTile(7, x+128, y+44+2*Sin(G[G_ANIM]*6), 62860, 11, 128);
}

void DrawNameboxPassive(int x, int y, int namestr){
	int namesize = Text->StringWidth(namestr, FONT_Z3SMALL);
	
	//Name frame
	int nameX = x;
	if(G[G_PASSIVESTRINGNAMESIDE])
		nameX = x+224-namesize-8-4-4;
	Screen->FastTile(7, nameX-12, y-16, 65983, 11, OP_OPAQUE);
	Screen->DrawTile(7, nameX+4, y-16, TIL_ITEMPOPUP_BOX+23, 1, 1, 11, namesize+8, 16, 0, 0, 0, 0, true, OP_OPAQUE);
	Screen->FastTile(7, nameX+namesize+8+4, y-16, TIL_ITEMPOPUP_BOX+24, 11, 128);
	
	//Name
	Screen->DrawString(7, nameX+8, y-12, FONT_Z3SMALL, 0xB2, -1, TF_NORMAL, namestr, OP_OPAQUE, SHD_OUTLINED8, 0x0F);

	//Backdrop
	Screen->DrawTile(7, x, y, 61360, 14, 2, 11, -1, -1, 0, 0, 0, 0, true, 128);
	
	// if(Tango_SlotIsFinished(0))
		// Screen->FastTile(7, x+128, y+44+2*Sin(G[G_ANIM]*6), 62860, 11, 128);
}

const int TIL_EMOTES = 66280;

void AssignPortraitName(int str){
	int size = Min(32, SizeOfArray(str));
	for(int i=0; i<size; ++i){
		NameBuf[i] = str[i];
		if(str[i]==0)
			break;
	}
}
void PlayString(int string, int whichChar, int emote){
	PlayString(string, whichChar, emote, 64, 24);
}
void PlayString(int string, int whichChar, int emote, int x, int y){
	GetPortraitNameAndTile(whichChar);
	PlayStringCustom(string, -1, G[G_PORTRAITTIL], emote, x, y, false);
}
void PlayStringCustom(int string, int name, int portrait, int emote, int x, int y, bool passive){
	//Strings are skipped over during cutscene debug
	if(G[G_CUTSCENEDEBUG])
		return;
	
	if(emote)
		G[G_PORTRAITEMOTETIL] = TIL_EMOTES+emote;
	else
		G[G_PORTRAITEMOTETIL] = 0;
	
	if(portrait>-1)
		G[G_PORTRAITTIL] = portrait;
	if(name>-1)
		AssignPortraitName(name);
	
	Tango_SetStyleAttribute(STYLE_NPC, TANGO_STYLE_BACKDROP_TILE, 65907);
    Tango_SetStyleAttribute(STYLE_NPC, TANGO_STYLE_BACKDROP_WIDTH, 10);
    Tango_SetStyleAttribute(STYLE_NPC, TANGO_STYLE_BACKDROP_HEIGHT, 3);

	Tango_SetStyleAttribute(STYLE_NPC, TANGO_STYLE_TEXT_WIDTH, 140);
    Tango_SetStyleAttribute(STYLE_NPC, TANGO_STYLE_TEXT_HEIGHT, 32);
	
	int style = STYLE_NPC;
	if(passive)
		style = STYLE_PASSIVETEXT;
	
	Tango_ClearSlot(0);
	Tango_LoadString(0, string);
	Tango_SetSlotStyle(0, style);
	Tango_SetSlotPosition(0, x, y);
	Tango_ActivateSlot(0);
	G[G_MSGACTIVE] = 1;
	G[G_PASSIVESTRINGDISPLAY] = 0;
	if(passive)
		G[G_PASSIVESTRINGDISPLAY] = 1;
	G[G_MSGTIMER] = 0;
	G[G_MSGX] = x;
	G[G_MSGY] = y;
	G[G_TEXTSCROLLSPEED] = 0;
	G[G_MSGEMOTECOOLDOWN] = 0;
}

void PlayStringAndWait(int string, int whichChar, int emote){
	PlayString(string, whichChar, emote, 64, 24);
	while(G[G_MSGACTIVE]){
		G[G_NOACTION] = 1;
		Waitframe();
	}
}
void PlayStringAndWait(int string, int whichChar, int emote, int x, int y){
	PlayString(string, whichChar, emote, x, y);
	while(G[G_MSGACTIVE]){
		G[G_NOACTION] = 1;
		Waitframe();
	}
}
void PlayStringAndWaitCustom(int string, int name, int portrait, int emote, int x, int y){
	PlayStringCustom(string, name, portrait, emote, x, y, false);
	while(G[G_MSGACTIVE]){
		G[G_NOACTION] = 1;
		Waitframe();
	}
}
void PlayStringAndWaitLower(int string, int whichChar, int emote){
	PlayString(string, whichChar, emote, 64, YPOS_LOWER);
	while(G[G_MSGACTIVE]){
		G[G_NOACTION] = 1;
		Waitframe();
	}
}
void PlayStringAndWaitForNPCs(int string, int whichChar, int emote, int x, int y, int cmb, int til, int cs, int flags, int flip, ffc this){
	PlayString(string, whichChar, emote, x, y);
	while(G[G_MSGACTIVE]){
		if(cmb>1&&!IsCovered(this, flags)){
			Screen->DrawTile(2, this->X, this->Y, til+20, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
			Screen->DrawTile(3, this->X, this->Y-16, til, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
		}
		G[G_NOACTION] = 1;
		Waitframe();
	}
}

void PlayStringAndWaitForNPCsWFade(int string, int whichChar, int emote, int x, int y, int cmb, int til, int cs, int flags, int flip, ffc this){
	for(int i=0; i<24; ++i){
		if(cmb>1&&!IsCovered(this, flags)){
			Screen->DrawTile(2, this->X, this->Y, til+20, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
			Screen->DrawTile(3, this->X, this->Y-16, til, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
		}
		Screen->Rectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
		if(i>=8)
			Screen->Rectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);	
		if(i>=16)
			Screen->Rectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
		WaitNoAction();
	}
	PlayString(string, whichChar, emote, x, y);
	while(G[G_MSGACTIVE]){
		if(cmb>1&&!IsCovered(this, flags)){
			Screen->DrawTile(2, this->X, this->Y, til+20, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
			Screen->DrawTile(3, this->X, this->Y-16, til, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
		}
		Screen->Rectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
		G[G_NOACTION] = 1;
		Waitframe();
	}
	for(int i=23; i>=0; --i){
		if(cmb>1&&!IsCovered(this, flags)){
			Screen->DrawTile(2, this->X, this->Y, til+20, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
			Screen->DrawTile(3, this->X, this->Y-16, til, 1, 1, cs, -1, -1, 0, 0, 0, flip, true, 128);
		}
		Screen->Rectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
		if(i>=8)
			Screen->Rectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);	
		if(i>=16)
			Screen->Rectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
		WaitNoAction();
	}
}

void PlayStringAndWaitBlackout(int string, int whichChar, int emote, int x, int y){
	PlayString(string, whichChar, emote, x, y);
	while(G[G_MSGACTIVE]){
		BlackScreenLayerSix();
		G[G_NOACTION] = 1;
		Waitframe();
	}
}


void ClearStringPortrait(int x, int y){
	Tango_SetStyleAttribute(STYLE_NPC, TANGO_STYLE_BACKDROP_TILE, 66300);
    Tango_SetStyleAttribute(STYLE_NPC, TANGO_STYLE_BACKDROP_WIDTH, 15);
    Tango_SetStyleAttribute(STYLE_NPC, TANGO_STYLE_BACKDROP_HEIGHT, 3);

    Tango_SetStyleAttribute(STYLE_NPC, TANGO_STYLE_TEXT_WIDTH, 224);
    Tango_SetStyleAttribute(STYLE_NPC, TANGO_STYLE_TEXT_HEIGHT, 32);
	
	Tango_SetSlotPosition(0, x, y);
	
	G[G_MSGX] = 8;
}

void Ghost_Pitfall(ffc this, npc ghost){
	int pos = ComboAt(HitboxCenterX(ghost), HitboxCenterY(ghost));
	int ct = Screen->ComboT[pos];
	mapdata l1 = Game->LoadTempScreen(1);
	mapdata l2 = Game->LoadTempScreen(2);
	if(l1->ComboT[pos]==CT_BRIDGE||l2->ComboT[pos]==CT_BRIDGE)
		ct = 0;
	if(ct==CT_PITFALL&&Ghost_Z==0&&G[G_GHOSTWALKLAYER]!=2){
		ghost->DrawYOffset = -1000;
		Ghost_HP = -1000;
		ghost->HP = -1000;
		ghost->ItemSet = 0;
		ghost->CollDetection = false;
		Game->PlaySound(SFX_FALL);
		ParticleAnim(ComboX(pos), ComboY(pos), 97);
		while(true){
			ghost->HP = -1000;
			SSGhost_Waitframe(this, ghost);
		}
	}
}

bool Ghost_CanPlace(int X, int Y, int w, int h){
	for(int x=0; x<=w-1; x=Min(x+8, w-1)){
		for(int y=0; y<=h-1; y=Min(y+8, h-1)){
			if(!Ghost_CanMovePixel(X+x, Y+y)){
				return false;
			}
			if(y==h-1)
				break;
		}
		if(x==w-1)
			break;
	}
	return true;
}

bool CanPlace(int X, int Y, int w, int h){
	for(int x=0; x<=w-1; x=Min(x+8, w-1)){
		for(int y=0; y<=h-1; y=Min(y+8, h-1)){
			if(Screen->isSolid(X+x, Y+y)){
				return false;
			}
			if(y==h-1)
				break;
		}
		if(x==w-1)
			break;
	}
	return true;
}

bool CanPlaceOnscreen(int X, int Y, int w, int h){
	for(int x=0; x<=w-1; x=Min(x+8, w-1)){
		for(int y=0; y<=h-1; y=Min(y+8, h-1)){
			if(X+x<0||X+x>255||Y+y<0||Y+y>175)
				return false;
			if(Screen->isSolid(X+x, Y+y)){
				return false;
			}
			if(y==h-1)
				break;
		}
		if(x==w-1)
			break;
	}
	return true;
}

int SwordUpgrade(int itemid){
	switch(itemid){
		case I_SWORD1:
			if(GetCharID()==CHAR_SOREN){
				if(FoundItems[I_SWORD_SOREN2])
					itemid = I_SWORD_SOREN2;
			}
			else{
				if(FoundItems[I_SWORD2])
					itemid = I_SWORD2;
			}
			break;
		case I_SWORD_TORRIN:
			if(GetCharID()==CHAR_TERRY){
				if(FoundItems[I_SWORD_TERRY2])
					itemid = I_SWORD_TERRY2;
			}
			else{
				if(FoundItems[I_SWORD_TORRIN2])
					itemid = I_SWORD_TORRIN2;
			}
			break;
		case I_SWORD_KAYLANI:
			if(GetCharID()==CHAR_SIYED){
				if(FoundItems[I_SWORD_SIYED2])
					itemid = I_SWORD_SIYED2;
			}
			else{
				if(FoundItems[I_SWORD_KAYLANI2])
					itemid = I_SWORD_KAYLANI2;
			}
			break;
	}
	return itemid;
}

void SetButtonItem(int btn, int itemid){
	itemid = SwordUpgrade(itemid);
	if(itemid==I_TIDALGAUNTLETMOON||itemid==I_TIDALGAUNTLETSUN){
		if(Link->Item[I_TIDALGAUNTLETSUN])
			itemid = I_TIDALGAUNTLETSUN;
		else
			itemid = I_TIDALGAUNTLETMOON;
	}
	switch(btn){
		case 0:
			Link->ItemA = itemid;
			break;
		case 1:
			Link->ItemB = itemid;
			break;
		case 2:
			Link->ItemX = itemid;
			break;
		case 3:
			Link->ItemY = itemid;
			break;
	}
}

void RemoveButtonItem(int itemID){
	if(Link->ItemA==itemID)
		EquipButtonItem(176, 0, false);
	if(Link->ItemB==itemID)
		EquipButtonItem(176, 1, false);
	if(Link->ItemX==itemID)
		EquipButtonItem(176, 2, false);
	if(Link->ItemY==itemID)
		EquipButtonItem(176, 3, false);
	for(int i=G_ITEMA_ASHER; i<=G_ITEMY_KAYLANI; ++i){
		if(G[i]==itemID)
			G[i] = 176;
	}
	for(int i=G_ITEMA_SOREN; i<=G_ITEMY_SIYED; ++i){
		if(G[i]==itemID)
			G[i] = 176;
	}
}

bool CanWalkNoEdge(int x, int y, int dir, int step, bool full_tile) 
{
	int c=8;
	int xx = x+15;
	int yy = y+15;
	if(full_tile) c=0;
	switch(DirNormal(dir))
	{
		case DIR_UP: return !(Screen->isSolid(x,y+c-step)||Screen->isSolid(x+8,y+c-step)||Screen->isSolid(xx,y+c-step));
		case DIR_DOWN: return !(Screen->isSolid(x,yy+step)||Screen->isSolid(x+8,yy+step)||Screen->isSolid(xx,yy+step));
		case DIR_LEFT: return !(Screen->isSolid(x-step,y+c)||Screen->isSolid(x-step,y+c+7)||Screen->isSolid(x-step,yy));
		case DIR_RIGHT: return !(Screen->isSolid(xx+step,y+c)||Screen->isSolid(xx+step,y+c+7)||Screen->isSolid(xx+step,yy));
		default: return false;
	}
}

void SortLowestToHighestAndReturnOrder(int arrayold, int sizeold, int arrayorder){
	int lowest = 214747;
	int lowestindex = 0;
	bool used[256];
	int size = sizeold;
	int size2 = sizeold;
	for(int i=0; i<size; i++){
		for(int j=0; j<size2; j++){
			if(arrayold[j]<=lowest&&!used[j]){
				lowest = arrayold[j];
				lowestindex = j;
			}
		}
		arrayorder[i] = lowestindex;
		used[lowestindex] = true;
		lowest = 214747;
	}
}

void DrawStringSP(int strDat, int layer, int x, int y, int w, int format, int font, int str){
	int i;
	
	int lineStart = strDat[0];
	int lineEnd = strDat[1];
	int lineStartColor = strDat[2];
	int numLines = strDat[3];
	int vSpacing = strDat[4];
	bool outline;
	if(strDat[5])
		outline = true;
	int curColor = 0x01;
	int lastWordIndex;
	int lineW;
	int tmpY;
	
	for(i=0; i<numLines; i++){
		tmpY = y+i*vSpacing;
		if(tmpY>-8&&tmpY<176){
			if(lineStart[i]!=lineEnd[i]){
				if(format==TF_CENTERED){
					int wLine = DrawStringSP_GetLineLength(lineStart[i], lineEnd[i], font, str);
					DrawStringSP_Line(layer, x-wLine/2, tmpY, font, str, lineStart[i], lineEnd[i], lineStartColor[i], outline);
				}
				else
					DrawStringSP_Line(layer, x, tmpY, font, str, lineStart[i], lineEnd[i], lineStartColor[i], outline);
			}
		}
	}
}

void BitmapDrawStringSP(bitmap b, int strDat, int layer, int x, int y, int w, int format, int font, int str){
	int i;
	
	int lineStart = strDat[0];
	int lineEnd = strDat[1];
	int lineStartColor = strDat[2];
	int numLines = strDat[3];
	int vSpacing = strDat[4];
	bool outline;
	if(strDat[5])
		outline = true;
	int curColor = 0x01;
	int lastWordIndex;
	int lineW;
	int tmpY;
	
	for(i=0; i<numLines; i++){
		tmpY = y+i*vSpacing;
		if(tmpY>-8&&tmpY<176){
			if(lineStart[i]!=lineEnd[i]){
				if(format==TF_CENTERED){
					int wLine = DrawStringSP_GetLineLength(lineStart[i], lineEnd[i], font, str);
					BitmapDrawStringSP_Line(b, layer, x-wLine/2, tmpY, font, str, lineStart[i], lineEnd[i], lineStartColor[i], outline);
				}
				else
					BitmapDrawStringSP_Line(b, layer, x, tmpY, font, str, lineStart[i], lineEnd[i], lineStartColor[i], outline);
			}
		}
	}
}

void DrawStringSP_Prep(int strDat, int w, int font, int str){
	int i;
	
	int lineStart = strDat[0];
	int lineEnd = strDat[1];
	int lineStartColor = strDat[2];
	int numLines;
	int curColor = 0x01;
	int lastWordIndex;
	bool inWord = true;
	int lineW; //Current width of the line
	int spaceW; //Width of the current block of whitespace in the line
	int prevLineW; //Width of the line not counting trailing whitespace
	int lineDatLen = SizeOfArray(lineStart);
	
	lineStart[0] = 0;
	lineEnd[0] = 0;
	lineStartColor[0] = 0x01;
	
	int len = SizeOfArray(str);
	int n[3];
	for(i=0; i<len; i++){
		//End of string
		if(str[i]==0){
			lineEnd[numLines] = i;
			numLines++;
			if(numLines>=lineDatLen){
				int err[] = "ERROR: lineStart[] is not big enough to hold this string! (Size is %i) \n";
				printf(err, lineDatLen);
				return;
			}
			break;
		}
		//Text color
		if(str[i]=='@'){
			//@N - new line
			if(str[i+1]=='N'){
				lineEnd[numLines] = i;
				numLines++;
				i += 2;
				lineStart[numLines] = i;
				lineEnd[numLines] = i;
				lineStartColor[numLines] = curColor;
				
				lineW = 0;
				spaceW = 0;
				continue;
			}
			//@XX - Change color
			n[0] = str[i+1];
			n[1] = str[i+2];
			curColor = FWCxtoi(n);
			i += 2;
			continue;
		}
		
		if(str[i]==' '){
			spaceW += Text->CharWidth(' ', font);
			inWord = false;
		}
		else{
			lineW += Text->CharWidth(str[i], font);
			lineW += spaceW;
			spaceW = 0;
			if(!inWord)
				lastWordIndex = i;
			inWord = true;
		}
		//When wrapping to a new line
		if(lineW>w-8){
			//Go back to the start of the last word (non space)
			i = lastWordIndex;
			//Set the end of the previous line to the start of this one
			lineEnd[numLines] = i;
			
			numLines++;
			
			//Set the new line to start at the current index
			lineStart[numLines] = i;
			lineEnd[numLines] = i;
			lineStartColor[numLines] = curColor;
			
			lineW = 0;
			spaceW = 0;
			if(numLines>=lineDatLen){
				int err[] = "ERROR: lineStart[] is not big enough to hold this string! (Size is %i) \n";
				printf(err, lineDatLen);
				return;
			}
		}
	}
	strDat[3] = numLines;
}

void DrawStringSP_Line(int layer, int x, int y, int font, int str, int lineStart, int lineEnd, int lineColor, bool outline){
	int i = lineStart;
	while(str[i]==' ')
		i++;
	int strLine[2048];
	int sli;
	int tmpX = x;
	int oldTmpX = x;
	int clr = lineColor;
	int n[3];
	while(i<lineEnd){
		if(str[i]==0){
			strLine[sli] = 0;
			sli = 0;
			if(outline)
				Screen->DrawString(layer, oldTmpX, y, font, clr, -1, TF_NORMAL, strLine, 128, SHD_OUTLINED8, 0x0F);
			else
				Screen->DrawString(layer, oldTmpX, y, font, clr, -1, TF_NORMAL, strLine, 128);
			oldTmpX = tmpX;
			return;
		}
		else if(str[i]=='@'){
			strLine[sli] = 0;
			sli = 0;
			if(outline)
				Screen->DrawString(layer, oldTmpX, y, font, clr, -1, TF_NORMAL, strLine, 128, SHD_OUTLINED8, 0x0F);
			else
				Screen->DrawString(layer, oldTmpX, y, font, clr, -1, TF_NORMAL, strLine, 128);
			oldTmpX = tmpX;
			n[0] = str[i+1];
			n[1] = str[i+2];
			clr = FWCxtoi(n);
			i += 3;
			continue;
		}
		else{
			strLine[sli] = str[i];
			sli++;
			tmpX += Text->CharWidth(str[i], font);
		}
		
		i++;
	}
	
	if(sli>0){
		while(strLine[sli-1]==' '){
			sli--;
			if(sli<=0)
				break;
		}
	}
	strLine[sli] = 0;
	sli = 0;
	if(outline)
		Screen->DrawString(layer, oldTmpX, y, font, clr, -1, TF_NORMAL, strLine, 128, SHD_OUTLINED8, 0x0F);
	else
		Screen->DrawString(layer, oldTmpX, y, font, clr, -1, TF_NORMAL, strLine, 128);
}

void BitmapDrawStringSP_Line(bitmap b, int layer, int x, int y, int font, int str, int lineStart, int lineEnd, int lineColor, bool outline){
	int i = lineStart;
	while(str[i]==' ')
		i++;
	int strLine[2048];
	int sli;
	int tmpX = x;
	int oldTmpX = x;
	int clr = lineColor;
	int n[3];
	while(i<lineEnd){
		if(str[i]==0){
			strLine[sli] = 0;
			sli = 0;
			if(outline)
				b->DrawString(layer, oldTmpX, y, font, clr, -1, TF_NORMAL, strLine, 128, SHD_OUTLINED8, 0x0F);
			else
				b->DrawString(layer, oldTmpX, y, font, clr, -1, TF_NORMAL, strLine, 128);
			oldTmpX = tmpX;
			return;
		}
		else if(str[i]=='@'){
			strLine[sli] = 0;
			sli = 0;
			if(outline)
				b->DrawString(layer, oldTmpX, y, font, clr, -1, TF_NORMAL, strLine, 128, SHD_OUTLINED8, 0x0F);
			else
				b->DrawString(layer, oldTmpX, y, font, clr, -1, TF_NORMAL, strLine, 128);
			oldTmpX = tmpX;
			n[0] = str[i+1];
			n[1] = str[i+2];
			clr = FWCxtoi(n);
			i += 3;
			continue;
		}
		else{
			strLine[sli] = str[i];
			sli++;
			tmpX += Text->CharWidth(str[i], font);
		}
		
		i++;
	}
	
	if(sli>0){
		while(strLine[sli-1]==' '){
			sli--;
			if(sli<=0)
				break;
		}
	}
	strLine[sli] = 0;
	sli = 0;
	if(outline)
		b->DrawString(layer, oldTmpX, y, font, clr, -1, TF_NORMAL, strLine, 128, SHD_OUTLINED8, 0x0F);
	else
		b->DrawString(layer, oldTmpX, y, font, clr, -1, TF_NORMAL, strLine, 128);
}

int DrawStringSP_GetLineLength(int lineStart, int lineEnd, int font, int str){
	int lineW;
	int lineWNoSpace;
	for(int i=lineStart; i<lineEnd; i++){
		if(str[i]==0){
			return lineW;
		}
		
		if(str[i]=='@'){
			if(str[i+1]=='N')
				i += 1;
			else
				i += 2;
			continue;
		}
		else{
			lineW += Text->CharWidth(str[i], font);
			if(str[i]!=' ')
				lineWNoSpace = lineW;
		}
	}
	return lineWNoSpace;
}

int GetStringWidth(int str, int font){
	int w;
	int size = SizeOfArray(str)-1;
	int i = size;
	while(i>0&&str[i]==0){
		--i;
	}
	for(; i>=0; --i){
		w += Text->CharWidth(str[i], font);
	}
	return w;
}

//Hexadecimal ASCII to Integer
//Returns the (positive) hexadecimal integer pointed by 'string'
int FWCxtoi(int string, int pos)
{
	int ret = 0;
	for(int i = 0; isHex(string[pos + i]); ++i)
		ret = ret*0x10 + Cond(isNumber(string[pos + i]), string[pos + i] - '0', LowerToUpper(string[pos + i]) - 'A' + 0xA);
	return ret;
}
int FWCxtoi(int string)
{
	return FWCxtoi(string, 0);
}

bool FWCLinkCollision(ffc f){
	int ax = Link->X + Link->HitXOffset;
	int ay = Link->Y + Link->HitYOffset;
	return RectCollision(f->X, f->Y, f->X+(f->TileWidth*16)-1, f->Y+(f->TileHeight*16)-1, ax, ay+8, ax+Link->HitWidth-1, ay+Link->HitHeight-1);
}

void SetOverUnderLayer(npc ghost){
	int pos = ComboAt(HitboxCenterX(ghost), HitboxCenterY(ghost));
	//mapdata newbuffer = Game->LoadMapData(MAP_OVERUNDER, SCREEN_OVERUNDER);
	switch(ScreenWalkFlags[pos]){
		case SWF_SOLIDUNDERBRIDGE: 
		case SWF_ABOVE: //Above
			G[G_GHOSTWALKLAYER] = 2;
			return;
		case SWF_BELOW: //Below
			G[G_GHOSTWALKLAYER] = 1;
			return;
		case SWF_BRIDGE: //Bridge
			if(Screen->ComboI[pos]==103)
				G[G_GHOSTWALKLAYER] = 1;
			else
				G[G_GHOSTWALKLAYER] = 2;
			return;
	}
}

bool Ghost_OnLinkLayer(){
	if(G[G_GHOSTWALKLAYER]==0)
		return true;
	if(G[G_OVERUNDERLAYER]==0&&G[G_GHOSTWALKLAYER]==1)
		return true;
	if(G[G_OVERUNDERLAYER]==1&&G[G_GHOSTWALKLAYER]==2)
		return true;
	return false;
}

bool RectCollision(lweapon a, int x, int y, int w, int h){
	return RectCollision(a->X+a->HitXOffset, a->Y+a->HitYOffset, a->X+a->HitXOffset+a->HitWidth-1, a->Y+a->HitYOffset+a->HitHeight-1, x, y, x+w-1, y+h-1);
}

bool RectCollision(eweapon a, int x, int y, int w, int h){
	return RectCollision(a->X+a->HitXOffset, a->Y+a->HitYOffset, a->X+a->HitXOffset+a->HitWidth-1, a->Y+a->HitYOffset+a->HitHeight-1, x, y, x+w-1, y+h-1);
}

bool RectCollision(npc a, int x, int y, int w, int h){
	return RectCollision(a->X+a->HitXOffset, a->Y+a->HitYOffset, a->X+a->HitXOffset+a->HitWidth-1, a->Y+a->HitYOffset+a->HitHeight-1, x, y, x+w-1, y+h-1);
}

// Returns true if two rotated hitboxes collide
// float x1c,y1c        - Center point of the first hitbox
// float width1,height1 - Width/Height of the first hitbox
// float rot1           - Rotation of the first hitbox
// float x2c,y2c        - Center point of the second hitbox
// float width2,height2 - Width/Height of the second hitbox
// float rot2           - Rotation of the second hitbox
// bool debug   		- If true, draws both hitboxes to the screen for debugging collisions
bool RotRectCollision(float x1c, float y1c, float width1, float height1, float rot1, float x2c, float y2c, float width2, float height2, float rot2, bool debug){
	width1 *= 0.5;
	height1 *= 0.5;
	width2 *= 0.5;
	height2 *= 0.5;
	
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
	if(debug){
		Screen->Rectangle(5, x1c-width1, y1c-height1, x1c+width1, y1c+height1, 1, -1, x1c, y1c, rot1, true, 64);
		Screen->Rectangle(5, x2c-width2, y2c-height2, x2c+width2, y2c+height2, 2, -1, x2c, y2c, rot2, true, 64);
	}
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


void ResizeHitbox(eweapon a, int xOff, int yOff, int w, int h){
	a->HitXOffset = xOff;
	a->HitYOffset = yOff;
	a->HitWidth = w;
	a->HitHeight = h;
}

int GetMapComboF(int map, int x, int y){
	int scrn = Floor(x/16)+Floor(y/11)*16;
	mapdata m = Game->LoadMapData(map, scrn);
	return m->ComboF[(x%16)+(y%11)*16];
}

ffc FindFreeFFC(){ //A function modified from FFC Script to grab unused FFCs, but not necessarily do anything with them.
	for(int i=FFCS_MIN_FFC; i<=FFCS_MAX_FFC; i++){
        ffc theFFC=Screen->LoadFFC(i);
        if(theFFC->Script==0 && theFFC->Data==0 && i!=24){
			theFFC->Vx = 0;
			theFFC->Vy = 0;
			theFFC->TileWidth = 1;
			theFFC->TileHeight = 1;
			theFFC->EffectWidth = 16;
			theFFC->EffectHeight = 16;
			for(int i = 0; i < 8; i++){
				theFFC->InitD[i] = 0;
			}
			for(int i = 0; i < 16; i++){
				theFFC->Misc[i] = 0;
			}
			for(int i = 0; i < 11; i++){
				theFFC->Flags[i] = 0;
			}
			theFFC->Link = GetFFCNumber(theFFC);
			return(theFFC);
			break;
		}
	}
}

int GetFFCNumber(ffc testffc){
	for(int i = 1; i <= 32; i++){
		ffc f = Screen->LoadFFC(i);
		if(f == testffc)
			return i;
	}
}

//Like SetButtonItem() but with logic for swapping buttons
void EquipButtonItem(int itemID, int btn, bool doSwap){
	if(itemID==I_TIDALGAUNTLETMOON||itemID==I_TIDALGAUNTLETSUN){
		if(Link->Item[I_TIDALGAUNTLETSUN])
			itemID = I_TIDALGAUNTLETSUN;
		else
			itemID = I_TIDALGAUNTLETMOON;
	}
	switch(GetCharID()){
		case CHAR_ASHER:
			switch(btn){
				case 0: EquipButtonItemPart2(itemID, G_ITEMA_ASHER, doSwap); return;
				case 1: EquipButtonItemPart2(itemID, G_ITEMB_ASHER, doSwap); return;
				case 2: EquipButtonItemPart2(itemID, G_ITEMX_ASHER, doSwap); return;
				case 3: EquipButtonItemPart2(itemID, G_ITEMY_ASHER, doSwap); return;
			}
			return;
		case CHAR_TORRIN:
			switch(btn){
				case 0: EquipButtonItemPart2(itemID, G_ITEMA_TORRIN, doSwap); return;
				case 1: EquipButtonItemPart2(itemID, G_ITEMB_TORRIN, doSwap); return;
				case 2: EquipButtonItemPart2(itemID, G_ITEMX_TORRIN, doSwap); return;
				case 3: EquipButtonItemPart2(itemID, G_ITEMY_TORRIN, doSwap); return;
			}
			return;
		case CHAR_KAYLANI:
			switch(btn){
				case 0: EquipButtonItemPart2(itemID, G_ITEMA_KAYLANI, doSwap); return;
				case 1: EquipButtonItemPart2(itemID, G_ITEMB_KAYLANI, doSwap); return;
				case 2: EquipButtonItemPart2(itemID, G_ITEMX_KAYLANI, doSwap); return;
				case 3: EquipButtonItemPart2(itemID, G_ITEMY_KAYLANI, doSwap); return;
			}
			return;
		case CHAR_SOREN:
			switch(btn){
				case 0: EquipButtonItemPart2(itemID, G_ITEMA_SOREN, doSwap); return;
				case 1: EquipButtonItemPart2(itemID, G_ITEMB_SOREN, doSwap); return;
				case 2: EquipButtonItemPart2(itemID, G_ITEMX_SOREN, doSwap); return;
				case 3: EquipButtonItemPart2(itemID, G_ITEMY_SOREN, doSwap); return;
			}
			return;
		case CHAR_TERRY:
			switch(btn){
				case 0: EquipButtonItemPart2(itemID, G_ITEMA_TERRY, doSwap); return;
				case 1: EquipButtonItemPart2(itemID, G_ITEMB_TERRY, doSwap); return;
				case 2: EquipButtonItemPart2(itemID, G_ITEMX_TERRY, doSwap); return;
				case 3: EquipButtonItemPart2(itemID, G_ITEMY_TERRY, doSwap); return;
			}
			return;
		case CHAR_SIYED:
			switch(btn){
				case 0: EquipButtonItemPart2(itemID, G_ITEMA_SIYED, doSwap); return;
				case 1: EquipButtonItemPart2(itemID, G_ITEMB_SIYED, doSwap); return;
				case 2: EquipButtonItemPart2(itemID, G_ITEMX_SIYED, doSwap); return;
				case 3: EquipButtonItemPart2(itemID, G_ITEMY_SIYED, doSwap); return;
			}
			return;
	}
}

bool CompareButtonItem(int id1, int id2){
	switch(id1){
		case 145:
		case 146:
			return id2==145||id2==146;
			break;
	}
	return id1==id2;
}

void EquipButtonItemPart2(int itemID, int gindex, bool doSwap){
	int iA; int iB; int iX; int iY;
	switch(GetCharID()){
		case CHAR_ASHER:
			iA = G_ITEMA_ASHER;
			iB = G_ITEMB_ASHER;
			iX = G_ITEMX_ASHER;
			iY = G_ITEMY_ASHER;
			break;
		case CHAR_TORRIN:
			iA = G_ITEMA_TORRIN;
			iB = G_ITEMB_TORRIN;
			iX = G_ITEMX_TORRIN;
			iY = G_ITEMY_TORRIN;
			break;
		case CHAR_KAYLANI:
			iA = G_ITEMA_KAYLANI;
			iB = G_ITEMB_KAYLANI;
			iX = G_ITEMX_KAYLANI;
			iY = G_ITEMY_KAYLANI;
			break;
		case CHAR_SOREN:
			iA = G_ITEMA_SOREN;
			iB = G_ITEMB_SOREN;
			iX = G_ITEMX_SOREN;
			iY = G_ITEMY_SOREN;
			break;
		case CHAR_TERRY:
			iA = G_ITEMA_TERRY;
			iB = G_ITEMB_TERRY;
			iX = G_ITEMX_TERRY;
			iY = G_ITEMY_TERRY;
			break;
		case CHAR_SIYED:
			iA = G_ITEMA_SIYED;
			iB = G_ITEMB_SIYED;
			iX = G_ITEMX_SIYED;
			iY = G_ITEMY_SIYED;
			break;
	}
	if(doSwap){
		if(CompareButtonItem(G[iA], itemID)){
			int backup = G[iA];
			G[iA] = G[gindex];
			G[gindex] = itemID;
		}
		if(CompareButtonItem(G[iB], itemID)){
			int backup = G[iB];
			G[iB] = G[gindex];
			G[gindex] = itemID;
		}
		if(CompareButtonItem(G[iX], itemID)){
			int backup = G[iX];
			G[iX] = G[gindex];
			G[gindex] = itemID;
		}
		if(CompareButtonItem(G[iY], itemID)){
			int backup = G[iY];
			G[iY] = G[gindex];
			G[gindex] = itemID;
		}
	}
	G[gindex] = itemID;
}

void DrawStarGlint(int layer, int x, int y, int angle, int rad, int c){
	int px[4]; int py[4];
	for(int i=0; i<4; ++i){
		px[i] = x+VectorX((i%2==0)?rad:rad*0.25, angle+90*i);
		py[i] = y+VectorY((i%2==0)?rad:rad*0.25, angle+90*i);
	}
	Screen->Quad(layer, px[0], py[0], px[1], py[1], px[2], py[2], px[3], py[3], 1, 1, c, 0, -1, PT_FLAT);
	for(int i=0; i<4; ++i){
		px[i] = x+VectorX((i%2==0)?rad:rad*0.25, angle+90+90*i);
		py[i] = y+VectorY((i%2==0)?rad:rad*0.25, angle+90+90*i);
	}
	Screen->Quad(layer, px[0], py[0], px[1], py[1], px[2], py[2], px[3], py[3], 1, 1, c, 0, -1, PT_FLAT);
	Screen->Circle(layer, x, y, rad*0.35, c, 1, 0, 0, 0, true, 128);
}

void Ghost_FaceLink(npc ghost){
	Ghost_Dir = AngleDir4(Angle(HitboxCenterX(ghost), HitboxCenterY(ghost), CenterLinkX(), CenterLinkY()));
}

void DamagingCircle(int layer, int x, int y, int rad, int c, int op, int wt, int damage){
	Screen->Circle(2, x, y, rad, c, 1, 0, 0, 0, true, 128);
	if(Distance(x, y, Link->X+8, Link->Y+8)<rad) 
		MakeHitbox(wt, x-rad, y-rad, rad*2, rad*2, damage);
}

void GetDirXYOffset(int xy, int dir, int arrXY){
	xy[0] = arrXY[2*dir+0];
	xy[1] = arrXY[2*dir+1];
	return;
}

int TrapezoidCurve(int time, int maxTime, int leadPercent, int trailPercent, int width){
	if(time==0||time==maxTime)
		return 0;
	int leadTime = Floor(maxTime*leadPercent);
	int endTime = Floor(maxTime*trailPercent);
	if(time<leadTime){
		return Lerp(0, width, (time/leadTime));
	}
	else if(time>maxTime-endTime){
		return Lerp(0, width, 1-(time-(maxTime-endTime))/endTime);
	}
	return width;
}

void DrawPolyTrail(int layer, int count, int xPos, int yPos, int widths, int angles, int sideTrim, int clr, int damage){
	int x[4];
	int y[4];
	int xOff1; int yOff1; int xOff2; int yOff2;
	int angle; int angle1; int angle2;
	if(false){
		for(int i=0; i<count-1; ++i){
			if(i==0){
				angle = Angle(xPos[i], yPos[i], xPos[i+1], yPos[i+1]);
				angle1 = angles[i];
				angle2 = angles[i+1]; //(angles[i]+angles[i+1])/2;
				int dist = Distance(xPos[i], yPos[i], xPos[i+1], yPos[i+1]);
				xOff1 = VectorX(dist*sideTrim, angle);
				yOff1 = VectorY(dist*sideTrim, angle);
			}
			else if(i==count-2){
				angle = Angle(xPos[i], yPos[i], xPos[i+1], yPos[i+1]);
				angle1 = angles[i]; //(angles[i]+angles[i+1])/2;
				angle2 = angles[i+1];
				int dist = Distance(xPos[i], yPos[i], xPos[i+1], yPos[i+1]);
				xOff2 = VectorX(dist*sideTrim, angle+180);
				yOff2 = VectorY(dist*sideTrim, angle+180);
			}
			else{
				angle1 = angles[i]; //(angles[i-1]+angles[i])/2;
				angle2 = angles[i+1]; //(angles[i]+angles[i+1])/2;
			}
			x[0] = xPos[i]+VectorX((widths[i]/2)*(1-sideTrim), angle1-90)+xOff1;
			y[0] = yPos[i]+VectorY((widths[i]/2)*(1-sideTrim), angle1-90)+yOff1;
			x[1] = xPos[i+1]+VectorX((widths[i+1]/2)*(1-sideTrim), angle2-90)+xOff2;
			y[1] = yPos[i+1]+VectorY((widths[i+1]/2)*(1-sideTrim), angle2-90)+yOff2;
			x[2] = xPos[i+1]+VectorX((widths[i+1]/2)*(1-sideTrim), angle2+90)+xOff2;
			y[2] = yPos[i+1]+VectorY((widths[i+1]/2)*(1-sideTrim), angle2+90)+yOff2;
			x[3] = xPos[i]+VectorX((widths[i]/2)*(1-sideTrim), angle1+90)+xOff1;
			y[3] = yPos[i]+VectorY((widths[i]/2)*(1-sideTrim), angle1+90)+yOff1;
			
			//Debugging
			// int tempQuad[8] = {x[0], y[0], x[1], y[1], x[2], y[2], x[3], y[3]};
			// for(int j=0; j<8; ++j){
				// tempQuad[j] += Rand(-1, 1);
			// }
			// int c = Rand(1, 15);
			// Screen->Line(6, tempQuad[0], tempQuad[1], tempQuad[2], tempQuad[3], c, 1, 0, 0, 0, 128);
			// Screen->Line(6, tempQuad[2], tempQuad[3], tempQuad[4], tempQuad[5], c, 1, 0, 0, 0, 128);
			// Screen->Line(6, tempQuad[4], tempQuad[5], tempQuad[6], tempQuad[7], c, 1, 0, 0, 0, 128);
			// Screen->Line(6, tempQuad[6], tempQuad[7], tempQuad[0], tempQuad[1], c, 1, 0, 0, 0, 128);
			
			//Screen->Quad(layer, x[0], y[0], x[1], y[1], x[2], y[2], x[3], y[3], 1, 1, clr, 0, -1, PT_FLAT); 
			QuadFix(layer, {x[0], y[0], x[1], y[1], x[2], y[2], x[3], y[3]}, clr); 
		}
	}

	int verts[128];
	int numVerts;
	for(int i=0; i<count; ++i){
		xOff1 = 0;
		yOff1 = 0;
		if(i==0){
			angle = Angle(xPos[i], yPos[i], xPos[i+1], yPos[i+1]);
			angle1 = angles[i];
			int dist = Distance(xPos[i], yPos[i], xPos[i+1], yPos[i+1]);
			xOff1 = VectorX(dist*sideTrim, angle);
			yOff1 = VectorY(dist*sideTrim, angle);
		}
		else if(i==count-1){
			angle = Angle(xPos[i-1], yPos[i-1], xPos[i], yPos[i]);
			angle1 = angles[i];
			int dist = Distance(xPos[i], yPos[i], xPos[i-1], yPos[i-1]);
			xOff1 = VectorX(dist*sideTrim, angle+180);
			yOff1 = VectorY(dist*sideTrim, angle+180);
		}
		else{
			angle1 = angles[i];
		}
		if(damage>0){
			int hitX = xPos[i]-(widths[i]/2);
			int hitY = yPos[i]-(widths[i]/2);
			if(RectCollision(Link->X, Link->Y, Link->X+15, Link->Y+15, hitX, hitY, hitX+widths[i]-1, hitY+widths[i]-1)){
				if(G[G_VUNTERSLAUSHCOLLISIONS]<32){
					eweapon e = MakeHitbox(EW_LUNAR, hitX, hitY, widths[i], widths[i], damage);
					e->CSet = 7;
					if(i<count-1){
						int tmpx = (xPos[i]+xPos[i+1])/2;
						int tmpy = (yPos[i]+yPos[i+1])/2;
						int tmpw = (widths[i]+widths[i+1])/2;
						e = MakeHitbox(EW_LUNAR, tmpx-(tmpw/2), tmpy-(tmpw/2), tmpw, tmpw, damage);
						e->CSet = 7;
					}
					++G[G_VUNTERSLAUSHCOLLISIONS];
				}
			}
		}
		else if(damage<0){
			int hitX = xPos[i]-(widths[i]/2);
			int hitY = yPos[i]-(widths[i]/2);
			if(G[G_ANIM]%4==i%4){
				lweapon l = MakeHitboxLW(LW_LUNAR, hitX, hitY, widths[i], widths[i], Abs(damage), -1);
			}
		}
		verts[2*numVerts+0] = xPos[i]+VectorX((widths[i]/2)*(1-sideTrim), angle1-90)+xOff1;
		verts[2*numVerts+1] = yPos[i]+VectorY((widths[i]/2)*(1-sideTrim), angle1-90)+yOff1;
		++numVerts;
	}
	xOff1 = 0;
	yOff1 = 0;
	for(int i=count-1; i>0; --i){
		angle1 = angles[i];
		verts[2*numVerts+0] = xPos[i]+VectorX((widths[i]/2)*(1-sideTrim), angle1+90)+xOff1;
		verts[2*numVerts+1] = yPos[i]+VectorY((widths[i]/2)*(1-sideTrim), angle1+90)+yOff1;
		++numVerts;
	}
	
	Screen->Polygon(layer, numVerts, verts, clr, 128);
}

// Swaps the values of a range between two arrays (why?)
void SwapArray(int array1, int array2, int minIndex, int maxIndex){
	for(int i=minIndex; i<maxIndex+1; ++i){
		int j = array1[i];
		array1[i] = array2[i];
		array2[i] = j;
	}
}

// Swaps the value of two indices of an array
void SwapArrayIndex(int arr, int ind1, int ind2){
	int backup = arr[ind1];
	arr[ind1] = arr[ind2];
	arr[ind2] = backup;
}

bool LineCollision(int x1, int y1, int x2, int y2, int x3, int y3, int x4, int y4){
	int x[4];
	int y[4];
	if(x1>x2){
		x[0] = x2;
		y[0] = y2;
		x[1] = x1;
		y[1] = y1;
	}
	else{
		x[0] = x1;
		y[0] = y1;
		x[1] = x2;
		y[1] = y2;
	}
	if(x3>x4){
		x[2] = x4;
		y[2] = y4;
		x[3] = x3;
		y[3] = y3;
	}
	else{
		x[2] = x3;
		y[2] = y3;
		x[3] = x4;
		y[3] = y4;
	}
	float risea = y[1]-y[0];
	float runa = x[1]-x[0];
	float riseb = y[3]-y[2];
	float runb = x[3]-x[2];
	int intersectx;
	int intersecty;
	float slopea;
	float slopeb;
	int startya;
	int startyb;
	if(Abs(runa)>0&&Abs(runb)>0){
		slopea = risea/runa;
		slopeb = riseb/runb;
		startya = y[0]-(slopea*x[0]);
		startyb = y[2]-(slopeb*x[2]);
		if(slopea==slopeb)
			return false;
		
		intersectx = (startya-startyb)/(slopeb-slopea);
		intersecty = slopea*intersectx+startya;
		if(intersectx>=x[0]&&intersectx<=x[1]&&intersectx>=x[2]&&intersectx<=x[3]){
			return true;
		}
	}
	else{
		int minxa = Min(x1, x2);
		int minya = Min(y1, y2);
		int maxxa = Max(x1, x2);
		int maxya = Max(y1, y2);
		int minxb = Min(x3, x4);
		int minyb = Min(y3, y4);
		int maxxb = Max(x3, x4);
		int maxyb = Max(y3, y4);
		if(Abs(runa)>0){
			slopea = risea/runa;
			startya = y[0]-(slopea*x[0]);
			intersectx = x[2];
			intersecty = startya+slopea*x[2];
			if(minxa<=intersectx&&maxxa>=intersectx&&minyb<=intersecty&&maxyb>=intersecty)
				return true;
		}
		else if(Abs(runb)>0){
			slopeb = riseb/runb;
			startyb = y[2]-(slopeb*x[2]);
			intersectx = x[0];
			intersecty = startyb+slopeb*x[0];
			if(minxb<=intersectx&&maxxb>=intersectx&&minya<=intersecty&&maxya>=intersecty)
				return true;
		}
		else if(x[0]==x[2]&&((minya<=maxyb&&minya>=minyb)||(minyb<=maxya&&minyb>=minya)))
			return true;
	}
	return false;
}

void QuadFix(int layer, int verts, int clr){
	int i; int j;
	int cX = (verts[0]+verts[2]+verts[4]+verts[6])/4;
	int cY = (verts[1]+verts[3]+verts[5]+verts[7])/4;
	int newverts[8];
	int count;
	int xy[2];
	
	for(i=0; i<8; ++i){
		newverts[i] = verts[i];
	}
	if(LineCollision(verts[0], verts[1], verts[2], verts[3], verts[6], verts[7], verts[4], verts[5])){
		xy[0] = newverts[2];
		xy[1] = newverts[3];
		newverts[2] = newverts[4];
		newverts[3] = newverts[5];
		newverts[4] = xy[0];
		newverts[5] = xy[1];
	}
	else if(LineCollision(verts[0], verts[1], verts[6], verts[7], verts[2], verts[3], verts[4], verts[5])){
		xy[0] = newverts[4];
		xy[1] = newverts[5];
		newverts[4] = newverts[6];
		newverts[5] = newverts[7];
		newverts[6] = xy[0];
		newverts[7] = xy[1];
	}
	
	// Debugging
	// int tempQuad[8] = {newverts[0], newverts[1], newverts[2], newverts[3], newverts[4], newverts[5], newverts[6], newverts[7]};
	// for(int j=0; j<8; ++j){
		// tempQuad[j] += Rand(-1, 1);
	// }
	// int c = Rand(1, 15);
	// Screen->Line(6, newverts[0], newverts[1], newverts[2], newverts[3], c, 1, 0, 0, 0, 128);
	// Screen->Line(6, newverts[2], newverts[3], newverts[4], newverts[5], c, 1, 0, 0, 0, 128);
	// Screen->Line(6, newverts[4], newverts[5], newverts[6], newverts[7], c, 1, 0, 0, 0, 128);
	// Screen->Line(6, newverts[6], newverts[7], newverts[0], newverts[1], c, 1, 0, 0, 0, 128);
	Screen->Quad(layer, newverts[0], newverts[1], newverts[2], newverts[3], newverts[4], newverts[5], newverts[6], newverts[7], 1, 1, clr, 0, -1, PT_FLAT); 
}

//Modified from a ghost.zh function
float GetThrowHeight(int startx, int starty, int endx, int endy, int step)
{
    if(step<=0)
        return 1;
    
    float dist=Distance(startx, starty, endx, endy);
    if(dist<1)
        return 1;
    
    float travelTime=dist/step;
    float ret=0;
    
    // Every increase in velocity of GH_GRAVITY means two frames in the air.
    // This might overshoot by a frame, but that's all right.
    while(ret<=GH_TERMINAL_VELOCITY)
    {
        ret+=GH_GRAVITY;
        travelTime-=2;
        if(travelTime<=0)
            return ret;
    }
    
    // Needs to exceed terminal velocity. Slightly trickier here, because
    // an increase of GH_GRAVITY may mean more than two more frames in the air.
    float excess=0; // Distance left to fall after reaching TV
    while(travelTime>excess/GH_TERMINAL_VELOCITY)
    {
        ret+=GH_GRAVITY;
        excess+=ret-GH_TERMINAL_VELOCITY;
        travelTime-=2;
    }
    
    return ret;
}

bool IsSolidMap(int map, int x, int y){
	int scrn = Floor(x/256)+Floor(y/176)*16;
	mapdata md = Game->LoadMapData(map, scrn);
	int pos = Floor((x%256)/16)+Floor((y%176)/16)*16;
	if(x%16<8){
		if(y%16<8)
			return md->ComboS[pos]&0001b;
		else
			return md->ComboS[pos]&0010b;
	}
	else{
		if(y%16<8)
			return md->ComboS[pos]&0100b;
		else
			return md->ComboS[pos]&1000b;
	}
}

void KillEWeapons(){
	for(int i = Screen->NumEWeapons(); i>0; i--){
		eweapon e = Screen->LoadEWeapon(i);
		Remove(e);
	}
}

bool HasAugment(int itemID){
	switch(GetCharID()){
		case CHAR_ASHER:
			if(G[G_ASHERAUGMENT1]==itemID||G[G_ASHERAUGMENT2]==itemID||G[G_ASHERAUGMENT3]==itemID)
				return true;
			break;
		case CHAR_TORRIN:
			if(G[G_TORRINAUGMENT1]==itemID||G[G_TORRINAUGMENT2]==itemID||G[G_TORRINAUGMENT3]==itemID)
				return true;
			break;
		case CHAR_KAYLANI:
			if(G[G_KAYLANIAUGMENT1]==itemID||G[G_KAYLANIAUGMENT2]==itemID||G[G_KAYLANIAUGMENT3]==itemID)
				return true;
			break;
		case CHAR_SOREN:
			if(G[G_SORENAUGMENT1]==itemID||G[G_SORENAUGMENT2]==itemID||G[G_SORENAUGMENT3]==itemID)
				return true;
			break;
		case CHAR_TERRY:
			if(G[G_TERRYAUGMENT1]==itemID||G[G_TERRYAUGMENT2]==itemID||G[G_TERRYAUGMENT3]==itemID)
				return true;
			break;
		case CHAR_SIYED:
			if(G[G_SIYEDAUGMENT1]==itemID||G[G_SIYEDAUGMENT2]==itemID||G[G_SIYEDAUGMENT3]==itemID)
				return true;
			break;
	}
	return false;
}

//Modifier when pulling things to Link
int MagnetModifier(){
	if(HasAugment(I_AUGMENT_MAGNET))
		return 2;
	return 1;
}

//Modifier when pulling Link to things
int MagnetModifier2(){
	if(HasAugment(I_AUGMENT_MAGNET))
		return 0.5;
	return 1;
}

int StickX(){
	return (Link->InputLeft?-1:0)+(Link->InputRight?1:0);
}

int StickY(){
	return (Link->InputUp?-1:0)+(Link->InputDown?1:0);
}

void AugmentGet(int Augment){
	eweapon e = CreateEWeaponAt(EW_SCRIPT10, 120, 80);
	e->CollDetection = false;
	e->DrawYOffset = -1000;
	int Args[8] = {Augment, 27+Augment-183};
	RunEWeaponScript(e, "ItemPopupManualName", Args);
	Link->Item[Augment] = true;
}

void AugmentGetYPos(int Augment, int YPos){
	eweapon e = CreateEWeaponAt(EW_SCRIPT10, 120, 80);
	e->CollDetection = false;
	e->DrawYOffset = -1000;
	int Args[8] = {Augment, 27+Augment-183, 0, 0, YPos};
	RunEWeaponScript(e, "ItemPopupManualName", Args);
	Link->Item[Augment] = true;
}

int GetAdjacentCombo(int pos, int dir){
	switch(dir){
		case DIR_UP:
			if(pos<16)
				return -1;
			return pos-16;
		case DIR_DOWN:
			if(pos>159)
				return -1;
			return pos+16;
		case DIR_LEFT:
			if(pos%16<1)
				return -1;
			return pos-1;
		case DIR_RIGHT:
			if(pos%16>14)
				return -1;
			return pos+1;
	}
	return -1;
}

void DrawShadow1x1(int x, int y)
{
    int tile;
    int size;
    
	y += 8;
	
	size=1;
	tile=GH_SHADOW_TILE+Floor((G[G_ANIM]%16)/4);
	
    if(GH_SHADOW_TRANSLUCENT>0)
    {
        Screen->DrawTile(1, x, y, tile, size, size, GH_SHADOW_CSET,
                         -1, -1, 0, 0, 0, 0, true, OP_TRANS);
    }
    else
    {
        Screen->DrawTile(1, x, y, tile, size, size, GH_SHADOW_CSET,
                         -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
    }
}

void DrawShadow1x1Cutscene(int layer, int x, int y)
{
    int tile;
    int size;
    
	y += 8;
	
	size=1;
	tile=GH_SHADOW_TILE+Floor((G[G_ANIM]%16)/4);
	
    if(GH_SHADOW_TRANSLUCENT>0)
    {
		Cutscene_NewTile(layer, x, y, tile, size, size, GH_SHADOW_CSET,
                         -1, -1, 0, 0, 0, 0, true, OP_TRANS);
    }
    else
    {
        Cutscene_NewTile(layer, x, y, tile, size, size, GH_SHADOW_CSET,
                         -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
    }
}

void DrawShadow1x1L5(int x, int y)
{
    int tile;
    int size;
    
	y += 8;
	
	size=1;
	tile=GH_SHADOW_TILE+Floor((G[G_ANIM]%16)/4);
	
    if(GH_SHADOW_TRANSLUCENT>0)
    {
        Screen->DrawTile(5, x, y, tile, size, size, GH_SHADOW_CSET,
                         -1, -1, 0, 0, 0, 0, true, OP_TRANS);
    }
    else
    {
        Screen->DrawTile(5, x, y, tile, size, size, GH_SHADOW_CSET,
                         -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
    }
}

bool IsPushFlag(int flag){
	switch(flag){
		case 1...2:
		case 47...65:
			return true;
	}
	return false;
}

int NumCombosOf(int comboID){
	int count;
	for(int i=0; i<176; ++i){
		if(Screen->ComboD[i]==comboID)
			++count;
	}
	return count;
}

int NumSwitchesOf(int comboID){
	int count;
	mapdata l1 = Game->LoadTempScreen(1);
	mapdata l2 = Game->LoadTempScreen(2);
	for(int i=0; i<176; ++i){
		if(Screen->ComboD[i]==comboID){
			if((Screen->ComboS[i]|l1->ComboS[i]|l2->ComboS[i])==0)
				++count;
		}
	}
	return count;
}

void DrawIntOutline(int layer, int x, int y, int font, int c, int c2, int tf, int outline, int num, int op){
	int str[8];
	itoa(str, num);
	Screen->DrawString(layer, x, y, font, c, -1, tf, str, 128, outline, c2);
}

void DrawIntOutlineB(bitmap b, int layer, int x, int y, int font, int c, int c2, int tf, int outline, int num, int op){
	int str[8];
	itoa(str, num);
	b->DrawString(layer, x, y, font, c, -1, tf, str, 128, outline, c2);
}

void SetPartyMaxHP(int val){
	Link->MaxHP = Max(Link->MaxHP, val*16);
	Link->HP = Link->MaxHP;
	G[G_ASHERMAXHP] = Max(G[G_ASHERMAXHP], val*16);
	G[G_ASHERHP] = G[G_ASHERMAXHP];
	G[G_TORRINMAXHP] = Max(G[G_TORRINMAXHP], val*16);
	G[G_TORRINHP] = G[G_TORRINMAXHP];
	G[G_KAYLANIMAXHP] = Max(G[G_KAYLANIMAXHP], val*16);
	G[G_KAYLANIHP] = G[G_KAYLANIMAXHP];
}

void SetAmmoMax(int bombs, int solar, int lunar, int stellar){
	Game->MCounter[CR_BOMBS] = Max(Game->MCounter[CR_BOMBS], bombs);
	Game->Counter[CR_BOMBS] = Game->MCounter[CR_BOMBS];
	Game->MCounter[CR_SOLARBATTERY] = Max(Game->MCounter[CR_SOLARBATTERY], solar);
	Game->Counter[CR_SOLARBATTERY] = Game->MCounter[CR_SOLARBATTERY];
	Game->MCounter[CR_LUNARBATTERY] = Max(Game->MCounter[CR_LUNARBATTERY], lunar);
	Game->Counter[CR_LUNARBATTERY] = Game->MCounter[CR_LUNARBATTERY];
	Game->MCounter[CR_STELLARBATTERY] = Max(Game->MCounter[CR_STELLARBATTERY], stellar);
	Game->Counter[CR_STELLARBATTERY] = Game->MCounter[CR_STELLARBATTERY];
}

void PopupNotify(int val){
	eweapon e = CreateEWeaponAt(EW_SCRIPT10, 120, 80);
	e->CollDetection = false;
	e->DrawYOffset = -1000;
	RunEWeaponScript(e, "ItemPopup", {-val});
}

bool SingleTileLinkAction(){
	switch(Link->Action){
		case LA_SWIMMING:
		case LA_DIVING:
		case LA_HOLD1WATER:
		case LA_HOLD2WATER:
			return true;
	}
	return false;
}

void ClearFFC(ffc f){
	f->Data = 0;
	f->CSet = 0;
	f->TileHeight = 0;
	f->TileWidth = 0;
	f->X = 0;
	f->Y = 0;
	f->Vx = 0;
	f->Vy = 0;
	f->Flags[FFCF_OVERLAY] = false;
}

void KillLWeapons(){
	for(int i = Screen->NumLWeapons(); i >0; i--){
		lweapon l = Screen->LoadLWeapon(i);
		l->DeadState = WDS_DEAD;
	}
}

bool OnSolid(int TeleX, int TeleY){
	if(Screen->isSolid(TeleX, TeleY))
		return true;
	if(Screen->isSolid(TeleX+15, TeleY))
		return true;
	if(Screen->isSolid(TeleX, TeleY+15))
		return true;
	if(Screen->isSolid(TeleX+15, TeleY+15))
		return true;
	else
		return false;	
}

int GetItemFromPool(int pool){
	int size = SizeOfArray(pool)/2;
	int weights[32];
	int maxWeight;
	for(int i=0; i<size; ++i){
		maxWeight += pool[i*2+1];
		weights[i] = maxWeight;
		printf("Weights %d: %d\n", i, weights[i]);
	}
	int r = Rand(maxWeight);
	//Trace(r);
	for(int i=0; i<size; ++i){
		if(r<weights[i])
			return pool[i*2];
	}
}

void DrawThickLine(int layer,  int x1, int y1, int x2, int y2, int width, int color, bool fill, int op){
	Screen->Rectangle(layer, x1, y1-width, x1+Distance(x1, y1, x2, y2), y1+width, color, 1, x1, y1, Angle(x1, y1, x2, y2), fill, op);
}

void DrawThickLine(bitmap b, int layer,  int x1, int y1, int x2, int y2, int width, int color, bool fill, int op){
	b->Rectangle(layer, x1, y1-width, x1+Distance(x1, y1, x2, y2), y1+width, color, 1, x1, y1, Angle(x1, y1, x2, y2), fill, op);
}

void DrawDiamondLine(bitmap b, int layer,  int x1, int y1, int x2, int y2, int width, int color, bool fill, int op){
	int qX[2];
	int qY[2];
	int angle = Angle(x1, y1, x2, y2);
	qX[0] = (x1+x2)/2+VectorX(-width, angle+90);
	qY[0] = (y1+y2)/2+VectorY(-width, angle+90);
	qX[1] = (x1+x2)/2+VectorX(width, angle+90);
	qY[1] = (y1+y2)/2+VectorY(width, angle+90);
	b->Quad(layer, x1, y1, qX[0], qY[0], x2, y2, qX[1], qY[1], 1, 1, color, 0, -1, PT_FLAT, NULL);
}

void DealDirectDamage(int damage, bool noNumber){
	Link->HP -= damage;
	if(noNumber)
		DamageNumbers[_DNUM_LASTLINKHP] = Link->HP;
}

int ClosestCombo(int thisX, int thisY, int positions, int minDist, int maxDist){
	int closest = -1;
	int closestDist = 1000;
	int num = SizeOfArray(positions);
	for(int i=0; i<num; ++i){
		int x = ComboX(positions[i]);
		int y = ComboY(positions[i]);
		int dist = Distance(thisX, thisY, x, y);
		if(dist<closestDist&&dist>=minDist&&dist<=maxDist){
			closest = i;
			closestDist = dist;
		}
	}
	if(closest==-1)
		return -1;
	return positions[closest];
}

int ClosestCombo(int thisX, int thisY, int positions){
	return ClosestCombo(thisX, thisY, positions, 0, 1000);
}


int FarthestCombo(int thisX, int thisY, int positions, int minDist, int maxDist){
	int farthest = -1;
	int farthestDist = 0;
	int num = SizeOfArray(positions);
	for(int i=0; i<num; ++i){
		int x = ComboX(positions[i]);
		int y = ComboY(positions[i]);
		int dist = Distance(thisX, thisY, x, y);
		if(dist>farthestDist&&dist>=minDist&&dist<=maxDist){
			farthest = i;
			farthestDist = dist;
		}
	}
	if(farthest==-1)
		return -1;
	return positions[farthest];
}

int FarthestCombo(int thisX, int thisY, int positions){
	return FarthestCombo(thisX, thisY, positions, 0, 1000);
}


void PartyPopup(int x, int y, int str, int tileDB, int csDB, int colorDB, int font, int cFont, int timer, bool music){
	int time;
	
	Game->PlayEnhancedMusic("SS-Party.ogg", 0);
	
	int tempX; int tempY;
	int strHeight = DialogueBox_GetStringHeight(font);
	int dimensions[2];
	dimensions[0] = DialogueBox_GetStringLength(str, font)+48;
	dimensions[1] = 24 + strHeight+2;
	for(int i=0; i<24; i++){
		time++;
		DialogueBox_DrawBox(6, x, y, tileDB, csDB, colorDB, Round(dimensions[0]*(i/24)), Round(dimensions[1]*(i/24)));
		WaitNoAction();
	}
	while(time < timer){
		time++;
		DialogueBox_DrawBox(6, x, y, tileDB, csDB, colorDB, dimensions[0], dimensions[1]);
		Screen->DrawString(6, x, y-(strHeight/2+1), font, cFont, -1, TF_CENTERED, str, 128);
		WaitNoAction();
	}
	if(music){
		int Music[256];
		Game->GetDMapMusicFilename(Game->GetCurDMap(), Music);
		Game->PlayEnhancedMusic(Music, 0);
	}
	for(int i=24; i>0; i--){
		DialogueBox_DrawBox(6, x, y, tileDB, csDB, colorDB, Round(dimensions[0]*(i/24)), Round(dimensions[1]*(i/24)));
		WaitNoAction();
	}
}

void PartyPopupCutscene(int x, int y, int str, int tileDB, int csDB, int colorDB, int font, int cFont, int timer, bool music){
	int time;
	
	Game->PlayEnhancedMusic("SS-Party.ogg", 0);
	
	int tempX; int tempY;
	int strHeight = DialogueBox_GetStringHeight(font);
	int dimensions[2];
	dimensions[0] = DialogueBox_GetStringLength(str, font)+48;
	dimensions[1] = 24 + strHeight+2;
	for(int i=0; i<24; i++){
		time++;
		DialogueBox_DrawBox(7, x, y, tileDB, csDB, colorDB, Round(dimensions[0]*(i/24)), Round(dimensions[1]*(i/24)));
		Cutscene_Waitframe();
	}
	while(time < timer){
		time++;
		DialogueBox_DrawBox(7, x, y, tileDB, csDB, colorDB, dimensions[0], dimensions[1]);
		Screen->DrawString(7, x, y-(strHeight/2+1), font, cFont, -1, TF_CENTERED, str, 128);
		Cutscene_Waitframe();
	}
	if(music){
		int Music[256];
		Game->GetDMapMusicFilename(Game->GetCurDMap(), Music);
		Game->PlayEnhancedMusic(Music, 0);
	}
	for(int i=24; i>0; i--){
		DialogueBox_DrawBox(7, x, y, tileDB, csDB, colorDB, Round(dimensions[0]*(i/24)), Round(dimensions[1]*(i/24)));
		Cutscene_Waitframe();
	}
}

void AbilityPopup(int x, int y, int str, int tileDB, int csDB, int colorDB, int font, int cFont, int tile, int tw, int th, int tile2, int tw2, int th2){
	int tempX; int tempY;
	int timer;
	int dimensions[2];
	
	int spec;
	bool maskBG = false;
	if(tile == 71500){
		spec = 1;
		maskBG = true;
	}
	
	//Let's do some math...
	//The picture width and string width should be the same, except string width min is 80
	//There should  be an 8 pixel buffer from the sides of the box and between the string and image
	//That means width should be Clamp(tw*16, 80, 10000)*2 + 24
	//Similarly, an 8 pixel buffer should be over the top and bottom
	//8 pixels should separate the two images
	//So height should be Clamp(th*16, StringHeight+16, 1000) + 16 for a single image, Clamp(th*16 + 8 + th2*16, StringHeight + 16, 1000) + 16 for two
	if(tile2 != 0){
		dimensions[0] = tw>tw2?Clamp(tw*16, 80, 10000)*2 + 24:Clamp(tw2*16, 80, 10000)*2 + 24;
		if(spec==1)
			dimensions[0] += 48;
		Tango_SetStyleAttribute(STYLE_SHOP, TANGO_STYLE_TEXT_WIDTH, tw>tw2?Clamp(tw*16, 80, 10000):Clamp(tw2*16, 80, 10000));
		dimensions[1] = th*16 + 8 + th2*16 + 16;
		if(spec==1){
			dimensions[1] += 16;
			Tango_SetStyleAttribute(STYLE_SHOP, TANGO_STYLE_TEXT_WIDTH, (tw>tw2?Clamp(tw*16, 80, 10000):Clamp(tw2*16, 80, 10000))+48);
			Tango_SetStyleAttribute(STYLE_SHOP, TANGO_STYLE_TEXT_HEIGHT, 120);
		}
	}
	else{
		dimensions[0] = Clamp(tw*16, 80, 10000)*2 + 24;
		Tango_SetStyleAttribute(STYLE_SHOP, TANGO_STYLE_TEXT_WIDTH, Clamp(tw*16, 80, 10000));
		dimensions[1] = th*16 + 16;
	}
	
	int topx = x-dimensions[0]/2; int topy = y-dimensions[1]/2;
	
	for(int i=0; i<24; i++){
		DialogueBox_DrawBox(6, x, y, tileDB, csDB, colorDB, Round(dimensions[0]*(i/24)), Round(dimensions[1]*(i/24)));
		if(tile == 70548){
			for(int i = Screen->NumNPCs(); i >0; i--){
				npc enemy = Screen->LoadNPC(i);
				enemy->Stun = 2;
			}
		}
		SetLinkPitImmune(2);
		WaitNoAction();
	}
	while(true){
		timer++;
		DialogueBox_DrawBox(6, x, y, tileDB, csDB, colorDB, dimensions[0], dimensions[1]);
		if(!Tango_SlotIsActive(0))
			PlayTangoSubscreenMessage(str, STYLE_SHOP, 0, topx, topy);
		
		//First, let's find the width of our half of the box
		int width = (dimensions[0]-24) / 2;
		if(width == tw*16) //This picture determined width
			tempX = x + 4; //So set it to draw at midpoint + 4
		else //The textbox or other image set the width
			tempX = x + 4 + (width-tw*16)/2; //So center it
		Screen->DrawTile(6, tempX, topy+8, tile, tw, th, 0, -1, -1, 0, 0, 0, 0, maskBG, OP_OPAQUE); 
		
		if(tile == 70672){ //The one animated one
			Screen->DrawCombo(6, tempX+16, topy+8, 33878, 1, 2, 0, -1, -1, 0, 0, 0, 0, 0, true, OP_OPAQUE); 
			Screen->DrawCombo(6, tempX, topy+24, 33879, 1, 1, 11, -1, -1, 0, 0, 0, 0, 0, true, OP_OPAQUE); 
			Screen->DrawCombo(6, tempX+32, topy+24, 33880, 1, 1, 11, -1, -1, 0, 0, 0, 0, 0, true, OP_OPAQUE); 
		}
		if(tile == 71500){ //The other animated one
			Screen->DrawCombo(6, tempX, topy+8, 38479, tw, th, 0, -1, -1, 0, 0, 0, 0, 0, true, OP_OPAQUE); 
		}
		
		if(tile2 != 0){
			//Same deal here
			if(width == tw2*16) //This picture determined width
				tempX = x + 4; //So set it to draw at midpoint + 4
			else //The textbox or other image set the width
				tempX = x + 4 + (width-tw2*16)/2; //So center it
			Screen->DrawTile(6, tempX, topy+8 + th*16 + 8, tile2, tw2, th2, 0, -1, -1, 0, 0, 0, 0, maskBG, OP_OPAQUE); 
		
			if(tile2 == 71540){ //The other animated one
				Screen->DrawCombo(6, tempX, topy+8 + th*16 + 8, 38478, tw2, th2, 0, -1, -1, 0, 0, 0, 0, 0, true, OP_OPAQUE); 
			}
		}
		
		if(timer > 30 && Link->PressA)
			break;
		if(tile == 70548){
			for(int i = Screen->NumNPCs(); i >0; i--){
				npc enemy = Screen->LoadNPC(i);
				enemy->Stun = 2;
			}
		}
		SetLinkPitImmune(2);
		WaitNoAction();
	}
	Tango_ClearSlot(0);
	for(int i=24; i>0; i--){
		DialogueBox_DrawBox(6, x, y, tileDB, csDB, colorDB, Round(dimensions[0]*(i/24)), Round(dimensions[1]*(i/24)));
		if(tile == 70548){
			for(int i = Screen->NumNPCs(); i >0; i--){
				npc enemy = Screen->LoadNPC(i);
				enemy->Stun = 2;
			}
		}
		SetLinkPitImmune(2);
		WaitNoAction();
	}
}

void SafeBlit(bitmap src, untyped dest, int layer, int srcX, int srcY, int srcW, int srcH, int destX, int destY, int destW, int destH, int sp, bool mask){
	int sW = src->Width;
	int sH = src->Height;
	
	int dW = 256;
	int dH = 176;
	if(dest!=RT_SCREEN){
		<bitmap>dest->Width;
		<bitmap>dest->Height;
	}
	
	int ratioW = destW/srcW;
	int ratioH = destH/srcH;
	
	int diff;
	
	int shaveX = 0;
	if(srcX<0){
		diff = Abs(srcX);
		destW -= diff*ratioW;
		destX += diff*ratioW;
		srcX += diff;
		srcW -= diff;
	}
	if(srcY<0){
		diff = Abs(srcY);
		destH -= diff*ratioH;
		destY += diff*ratioH;
		srcY += diff;
		srcH -= diff;
	}
	if(srcX+srcW-1>sW){
		diff = Abs(sW-(srcX+srcW-1));
		destW -= diff*ratioW;
		srcW -= diff;
	}
	if(srcY+srcH-1>sH){
		diff = Abs(sH-(srcY+srcH-1));
		destH -= diff*ratioH;
		srcH -= diff;
	}
	destW = Ceiling(destW);
	destH = Ceiling(destH);
	
	if(srcW<1||srcH<1||destW<1||destH<1)
		return;
	
	src->Blit(layer, dest, srcX, srcY, srcW, srcH, destX, destY, destW, destH, 0, 0, 0, sp, 0, mask);
}

void SetAllDefenses(npc n, int dt){
	for(int i=0; i<MAX_DEFENSE; ++i){
		n->Defense[i] = dt;
	}
}

void StoreDefenses(npc n, int arr){
	for(int i=0; i<MAX_DEFENSE; ++i){
		arr[i] = n->Defense[i];
	}
}

void SetDefenses(npc n, int arr){
	for(int i=0; i<MAX_DEFENSE; ++i){
		n->Defense[i] = arr[i];
	}
}

void DrawStringOutline(int layer, int x, int y, int font, int clr1, int clr2, int format, int ptr, int op){
	Screen->DrawString(layer, x, y-1, font, clr2, -1, format, ptr, op);
	Screen->DrawString(layer, x, y+1, font, clr2, -1, format, ptr, op);
	Screen->DrawString(layer, x-1, y, font, clr2, -1, format, ptr, op);
	Screen->DrawString(layer, x+1, y, font, clr2, -1, format, ptr, op);
	Screen->DrawString(layer, x, y, font, clr1, -1, format, ptr, op);
}

void DamageLink(int damage, int objX, int objY){
	int ang = Angle(Link->X, Link->Y, objX, objY);
	MakeHitbox(EW_SCRIPT10, Link->X-16+VectorX(16, ang), Link->Y-16+VectorY(16, ang), 48, 48, damage);
}
void DamageLink(int damage){
	MakeHitbox(EW_SCRIPT10, Link->X-16+DirX(Link->Dir, 16), Link->Y-16+DirY(Link->Dir, 16), 48, 48, damage);
}

//X,Y - New position of the worm enemy
//WormX[],WormY[] - Arrays containing old positions of the worm enemy
//stepData[] - An array containg data used frame to frame
//	stepData[0] - The current substep value of the enemy
//	stepData[1] - The max step value for the enemy, if the enemy moves more than this much at once it will teleport
void UpdateWormTrailsXY(int X, int Y, int WormX, int WormY, int stepData){
	X = Floor(X);
	Y = Floor(Y);
	
	int Length = SizeOfArray(WormX);
	int OldX = WormX[0];
	int OldY = WormY[0];
	stepData[0] += Floor(Distance(X, Y, WormX[0], WormY[0]));
	int Step = Floor(stepData[0]);
	if(Step>stepData[1]){
		for(int i=Length-1; i>0; i--){
			WormX[i] = WormX[i-1];
			WormY[i] = WormY[i-1];
		}
		WormX[0] = X;
		WormY[0] = Y;
	}
	else if(Step>0){
		for(int i=Length-1; i>Step; i--){
			WormX[i] = WormX[i-Step];
			WormY[i] = WormY[i-Step];
		}
		for(int i=0; i<=Step; i++){
			WormX[i] = Floor(X+VectorX(i, Angle(X, Y, OldX, OldY)));
			WormY[i] = Floor(Y+VectorY(i, Angle(X, Y, OldX, OldY)));
		}
		stepData[0] -= Step;
	}
}

int AngleAverage(int ang1, int ang2){
	return WrapDegrees(ang1+Abs(AngDiff(ang2, ang1))/2);
}

void ClearEWeapons(){
	for(int i=Screen->NumEWeapons(); i>0; --i){
		eweapon e = Screen->LoadEWeapon(i);
		e->Script = 0;
		e->DeadState = 0;
	}
}

bool InScreen(int x, int y, int w, int h){
	return x>-w&&x<256&&y>-h&&y<176;
}

bool InScreen(int x, int y, int w, int h, bool no_offscreen){
	if(no_offscreen)
		return x>=0&&x<256-w&&y>=0&&y<176-h;
	else
		return x>-w&&x<256&&y>-h&&y<176;
}

int AbsAngDiff(int a1, int a2){
	return Abs(AngDiff(a1, a2));
}

bool TrianglePointCollision(int X, int Y, int TriX1, int TriY1, int TriX2, int TriY2, int TriX3, int TriY3){
	int Angle1 = Angle(TriX1, TriY1, X, Y);
	int Angle1A = Angle(TriX1, TriY1, TriX2, TriY2);
	int Angle1B = Angle(TriX1, TriY1, TriX3, TriY3);
	int Diff1 = AbsAngDiff(Angle1A, Angle1B);
	int Angle2 = Angle(TriX2, TriY2, X, Y);
	int Angle2A = Angle(TriX2, TriY2, TriX1, TriY1);
	int Angle2B = Angle(TriX2, TriY2, TriX3, TriY3);
	int Diff2 = AbsAngDiff(Angle2A, Angle2B);
	int Angle3 = Angle(TriX3, TriY3, X, Y);
	int Angle3A = Angle(TriX3, TriY3, TriX1, TriY1);
	int Angle3B = Angle(TriX3, TriY3, TriX2, TriY2);
	int Diff3 = AbsAngDiff(Angle3A, Angle3B);
	if(AbsAngDiff(Angle1, Angle1A)>Diff1||AbsAngDiff(Angle1, Angle1B)>Diff1)
		return false;
	if(AbsAngDiff(Angle2, Angle2A)>Diff2||AbsAngDiff(Angle2, Angle2B)>Diff2)
		return false;
	if(AbsAngDiff(Angle3, Angle3A)>Diff3||AbsAngDiff(Angle3, Angle3B)>Diff3)
		return false;
	return true;
}

bool QuadLaserCollision(int x1, int y1, int x2, int y2, int width1, int width2, int extend){
	width1 /= 2;
	width2 /= 2;
	int dist = Distance(x1, y1, x2, y2);
	int rotation = Angle(x1, y1, x2, y2);
	int QuadX[4];
	int QuadY[4];
	QuadX[0] = x1+VectorX(width1+extend, rotation-90);
	QuadY[0] = y1+VectorY(width1+extend, rotation-90);
	QuadX[1] = x1+VectorX(width1+extend, rotation+90);
	QuadY[1] = y1+VectorY(width1+extend, rotation+90);
	QuadX[2] = x2+VectorX(width2+extend, rotation-90);
	QuadY[2] = y2+VectorY(width2+extend, rotation-90);
	QuadX[3] = x2+VectorX(width2+extend, rotation+90);
	QuadY[3] = y2+VectorY(width2+extend, rotation+90);
	return TrianglePointCollision(Link->X+8, Link->Y+8, QuadX[0], QuadY[0], QuadX[1], QuadY[1], QuadX[2], QuadY[2]) || TrianglePointCollision(Link->X+8, Link->Y+8, QuadX[1], QuadY[1], QuadX[2], QuadY[2], QuadX[3], QuadY[3]);
}

void DeathAnimCleanup(npc ghost){
	ghost->Immortal = false;
	if(ghost->HP<0){
		ghost->HP = 1;
		Ghost_HP = 1;
	}
	ghost->Misc[NPCM_DAMAGENUMBERSLASTHP] = ghost->HP;
	ghost->CollDetection = false;
}

int Choose(int arr){
	int count = SizeOfArray(arr);
	return arr[Rand(count)];
}

void FullHeal(bool HP, bool MP, bool batteries, bool bombs){
	if(HP){
		Link->HP = Link->MaxHP;
		G[G_ASHERHP] = G[G_ASHERMAXHP];
		G[G_TORRINHP] = G[G_TORRINMAXHP];
		G[G_KAYLANIHP] = G[G_KAYLANIMAXHP];
		G[G_SORENHP] = G[G_SORENMAXHP];
		G[G_TERRYHP] = G[G_TERRYMAXHP];
		G[G_SIYEDHP] = G[G_SIYEDMAXHP];
	}
	if(MP){
		Link->MP = Link->MaxMP;
		G[G_ASHERMP] = Link->MaxMP;
		G[G_KAYLANIMP] = Link->MaxMP;
		G[G_SIYEDMP] = Link->MaxMP;
	}
	if(batteries){
		Game->Counter[CR_SOLARBATTERY] = Game->MCounter[CR_SOLARBATTERY];
		Game->Counter[CR_LUNARBATTERY] = Game->MCounter[CR_LUNARBATTERY];
	}
	if(bombs){
		Game->Counter[CR_BOMBS] = Game->MCounter[CR_BOMBS];
	}
}

void ClearStatus(){
	G[G_ASHERINCINERATED] = 0;
	G[G_TORRININCINERATED] = 0;
	G[G_KAYLANIINCINERATED] = 0;
	G[G_SCRIPTJINX] = 0;
	G[G_FROZENTIMER] = 0;
}

bool isSolidForNPCs(int x, int y){
	if(Screen->isSolid(x, y))
		return true;
	if(ComboFI(x, y, 96) || ComboFI(x, y, 97))
		return true;
	return false;
}

bool CanWalkNPC(int x, int y, int dir, int step, bool full_tile) {
    int c=8;
    int xx = x+15;
    int yy = y+15;
    if(full_tile) c=0;
    if(dir==0) return !(y-step<0||isSolidForNPCs(x,y+c-step)||isSolidForNPCs(x+8,y+c-step)||isSolidForNPCs(xx,y+c-step));
    else if(dir==1) return !(yy+step>=176||isSolidForNPCs(x,yy+step)||isSolidForNPCs(x+8,yy+step)||isSolidForNPCs(xx,yy+step));
    else if(dir==2) return !(x-step<0||isSolidForNPCs(x-step,y+c)||isSolidForNPCs(x-step,y+c+7)||isSolidForNPCs(x-step,yy));
    else if(dir==3) return !(xx+step>=256||isSolidForNPCs(xx+step,y+c)||isSolidForNPCs(xx+step,y+c+7)||isSolidForNPCs(xx+step,yy));
    return false; //invalid direction
}
 
float AngDiffDeg(float angle1, float angle2){
    return RadtoDeg(AngDiff(DegtoRad(angle1), DegtoRad(angle2)));
}

void SidePartySwap(bool swap){
	if(G[G_RANDOMIZERENABLED])
		return;
		
	Link->Item[I_SWORD1] = true; //For fixing a bug that broke only on my save file -Moosh
	
	Link->HP = Link->MaxHP;
	G[G_ASHERHP] = G[G_ASHERMAXHP];
	G[G_TORRINHP] = G[G_TORRINMAXHP];
	G[G_KAYLANIHP] = G[G_KAYLANIMAXHP];
	G[G_SORENHP] = G[G_SORENMAXHP];
	G[G_TERRYHP] = G[G_TERRYMAXHP];
	G[G_SIYEDHP] = G[G_SIYEDMAXHP];
	Link->MP = Link->MaxMP;
	G[G_ASHERMP] = Link->MaxMP;
	G[G_KAYLANIMP] = Link->MaxMP;
	G[G_SIYEDMP] = Link->MaxMP;
	if(swap){
		if(G[G_SOLARBATTERYSTORAGE_TERRY]==0){
			G[G_SOLARBATTERYSTORAGE_TERRY] = (10<<8)|10;
			G[G_LUNARBATTERYSTORAGE_TERRY] = (10<<8)|10;
			G[G_STELLARBATTERYSTORAGE_TERRY] = (10<<8)|10;
		}
		G[G_SOLARBATTERYSTORAGE] = (Game->MCounter[CR_SOLARBATTERY]<<8)|Game->Counter[CR_SOLARBATTERY];
		G[G_LUNARBATTERYSTORAGE] = (Game->MCounter[CR_LUNARBATTERY]<<8)|Game->Counter[CR_LUNARBATTERY];
		G[G_STELLARBATTERYSTORAGE] = (Game->MCounter[CR_STELLARBATTERY]<<8)|Game->Counter[CR_STELLARBATTERY];
		
		Game->MCounter[CR_SOLARBATTERY] = (G[G_SOLARBATTERYSTORAGE_TERRY]>>8)&0xFF;
		Game->Counter[CR_SOLARBATTERY] = (G[G_SOLARBATTERYSTORAGE_TERRY])&0xFF;
		Game->MCounter[CR_LUNARBATTERY] = (G[G_LUNARBATTERYSTORAGE_TERRY]>>8)&0xFF;
		Game->Counter[CR_LUNARBATTERY] = (G[G_LUNARBATTERYSTORAGE_TERRY])&0xFF;
		Game->MCounter[CR_STELLARBATTERY] = (G[G_STELLARBATTERYSTORAGE_TERRY]>>8)&0xFF;
		Game->Counter[CR_STELLARBATTERY] = (G[G_STELLARBATTERYSTORAGE_TERRY])&0xFF;
		
		Link->Item[I_ASHER] = false;
		Link->Item[I_TORRIN] = false;
		Link->Item[I_KAYLANI] = false;
		Link->Item[I_SOREN] = true;
		Link->Item[I_TERRY] = true;
		Link->Item[I_SIYED] = true;
		if(GetCharID() == CHAR_ASHER)
			SetCharacter(CHAR_SOREN, false);
		if(GetCharID() == CHAR_TORRIN)
			SetCharacter(CHAR_TERRY, false);
		if(GetCharID() == CHAR_KAYLANI)
			SetCharacter(CHAR_SIYED, false);
		
		G[G_SUBSCREENSEL_ALTERNATE] = 0;
		G[G_SUBSCREENSEL] = Clamp(G[G_SUBSCREENSEL], 0, 2);
	}
	else{
		G[G_SOLARBATTERYSTORAGE_TERRY] = (10<<8)|Min(Game->Counter[CR_SOLARBATTERY], 10);
		G[G_LUNARBATTERYSTORAGE_TERRY] = (10<<8)|Min(Game->Counter[CR_LUNARBATTERY], 10);
		G[G_STELLARBATTERYSTORAGE_TERRY] = (10<<8)|Min(Game->Counter[CR_STELLARBATTERY], 10);
		
		Game->MCounter[CR_SOLARBATTERY] = (G[G_SOLARBATTERYSTORAGE]>>8)&0xFF;
		Game->Counter[CR_SOLARBATTERY] = (G[G_SOLARBATTERYSTORAGE])&0xFF;
		Game->MCounter[CR_LUNARBATTERY] = (G[G_LUNARBATTERYSTORAGE]>>8)&0xFF;
		Game->Counter[CR_LUNARBATTERY] = (G[G_LUNARBATTERYSTORAGE])&0xFF;
		Game->MCounter[CR_STELLARBATTERY] = (G[G_STELLARBATTERYSTORAGE]>>8)&0xFF;
		Game->Counter[CR_STELLARBATTERY] = (G[G_STELLARBATTERYSTORAGE])&0xFF;
		
		Link->Item[I_ASHER] = true;
		Link->Item[I_TORRIN] = true;
		Link->Item[I_KAYLANI] = true;
		Link->Item[I_SOREN] = false;
		Link->Item[I_TERRY] = false;
		Link->Item[I_SIYED] = false;
		if(GetCharID() == CHAR_SOREN)
			SetCharacter(CHAR_ASHER, false);
		if(GetCharID() == CHAR_TERRY)
			SetCharacter(CHAR_TORRIN, false);
		if(GetCharID() == CHAR_SIYED)
			SetCharacter(CHAR_KAYLANI, false);
	}
}

bool isShorelineCombo(int cmb, bool allowDeep){
	switch(cmb){
		case 7352...7359:
		case 7361:
		case 7362:
		case 7364...7379:
		case 7381:
		case 7382:
		case 7384...7415:
			combodata cd = Game->LoadComboData(cmb);
			if(allowDeep)
				return true;
			else if(cd->Type!=CT_WATER)
				return true;
			break;
		default:
			return false;
	}
	return false;
}

enum GhostSpecialType {
						GST_NONE, 
						GST_SAWTOOTH
					  };

bool Ghost_SpecialSolid(int x, int y, bool inAir, int specialType){
	switch(specialType){
		case GST_SAWTOOTH:
			mapdata l1 = Game->LoadTempScreen(1);
			return isShorelineCombo(Screen->ComboD[ComboAt(x, y)], false)||isShorelineCombo(l1->ComboD[ComboAt(x, y)], false);
			break;
	}
	return false;
}

bool IsEasyMode(){
	return G[G_BOSSEASYMODE];
}
int EasyModeFrames(int frames){
	if(IsEasyMode())return frames;
	return 0;
}

int EasyModeMultiplier(int mult){
	if(IsEasyMode())return mult;
	return 1;
}

void ClampLinkToScreen(){
	Link->X = Clamp(Link->X, 4, 236);
	Link->Y = Clamp(Link->Y, 4, 156);
}

bool AccurateLinkCollision(itemsprite itm){
	return Link->X>=itm->X-13&&Link->X<=itm->X+8&&Link->Y>=itm->Y-17&&Link->Y<=itm->Y+7;
}

float VectorXSkew(int distx, int disty, int ang, int axisAng){
	int axisx = VectorX(distx, ang);
	int axisy = VectorY(disty, ang);
	return VectorX(axisx, axisAng)+VectorX(axisy, axisAng+90);
}

float VectorYSkew(int distx, int disty, int ang, int axisAng){
	int axisx = VectorX(distx, ang);
	int axisy = VectorY(disty, ang);
	return VectorY(axisx, axisAng)+VectorY(axisy, axisAng+90);
}

void DrawStar(int layer, int cx, int cy, int angle, int numPoints, int rad1, int rad2, int clr, int op){
	int verts[64];
	int angPoints = 360/numPoints;
	for(int i=0; i<numPoints; ++i){
		verts[4*i+0] = cx+VectorX(rad1, angle+angPoints*i);
		verts[4*i+1] = cy+VectorY(rad1, angle+angPoints*i);
		verts[4*i+2] = cx+VectorX(rad2, angle+angPoints*i+angPoints*0.5);
		verts[4*i+3] = cy+VectorY(rad2, angle+angPoints*i+angPoints*0.5);
	}
	Screen->Polygon(layer, numPoints*2, verts, clr, op);
}

int TraceToScreen(int x, int y, int val){
	Screen->DrawInteger(7, x, y, FONT_Z3SMALL, 0x01, 0x0F, -1, -1, val, 0, 128);
}
int TraceToScreen(int label, int x, int y, int val){
	int buf[128];
	sprintf(buf, "%s: %d", label, val);
	Screen->DrawString(7, x, y, FONT_Z3SMALL, 0x01, 0x0F, TF_NORMAL, buf, 128);
}
