import "std.zh"

bool aquastart;

item script StartBoss
{
	void run()
	{
		aquastart = true;
		this->NumFrames = 20;
		this->ASpeed = 8;
	}
}
		
		
ffc script Aquamentus_Omega
{
	void run()
	{
	aquastart=false;
	while(!aquastart) Waitframe();

	//The fun begins
	Game->PlayMIDI(0);
	Screen->Door[DIR_LEFT] = D_WALL;	// Makes sure Link faces the right direction and that the bomb hole on the left disappears.
	int introcount = -300;  //This is a general frame counter used to time the events in the intro.
	while(introcount<0)
	{
		if(Link->Action!=LA_HOLD2LAND||Link->Action!=LA_HOLD2LAND) {Link->Action=LA_FROZEN; Link->Dir = DIR_LEFT; Game->PlayMIDI(0);}
		introcount++;
		Waitframe(); //Pause the action for dramatic effect. Also freeze Link so he can't be moved.
	}
	
	float lineX1 = (Cos(270)*40)+76; float lineY1 = (Sin(270)*40)+88;
	float lineX2 = (Cos(150)*40)+76; float lineY2 = (Sin(150)*40)+88;
	float lineX3 = (Cos(30)*40)+76; float lineY3 = (Sin(30)*40)+88;
	float lineX4 = Abs(lineX1-lineX2)/2+Min(lineX1,lineX2); float lineY4 = Abs(lineY1-lineY2)/2+Min(lineY1,lineY2); 
	float lineX5 = Abs(lineX1-lineX3)/2+Min(lineX1,lineX3); float lineY5 = Abs(lineY1-lineY3)/2+Min(lineY1,lineY3);
	float lineX6 = Abs(lineX3-lineX2)/2+Min(lineX3,lineX2); float lineY6 = Abs(lineY3-lineY2)/2+Min(lineY3,lineY2); 
	
	Game->PlayMIDI(1);
	while(introcount < 480)
	{
		Link->Action=LA_FROZEN;
		Screen->Quake=200;  //Shake the screen
		if(introcount==180) { Screen->ComboD[41]=164; Screen->ComboD[137]=164; }
		if(introcount==212) { Screen->ComboD[42]=164; Screen->ComboD[138]=164; }
		if(introcount==244) { Screen->ComboD[59]=164; Screen->ComboD[123]=164; }
		if(introcount==276) { Screen->ComboD[76]=164; Screen->ComboD[108]=164; }
		
		if(introcount > 180)
		{
			int currentcolor = (((introcount-180)/4)%4)+37;
			if(introcount<360)
			{
				int count = introcount-180;
				Screen->Arc(1,76,88,40,450-count,450,currentcolor,1,0,0,0,false,false,128);
				Screen->Arc(1,76,88,40,270-count,270,currentcolor,1,0,0,0,false,false,128);
				Screen->Arc(1,76,88,39.5,450-count,450,currentcolor,1,0,0,0,false,false,128);
				Screen->Arc(1,76,88,39.5,270-count,270,currentcolor,1,0,0,0,false,false,128);
				Screen->Arc(1,76,88,39,450-count,450,currentcolor,1,0,0,0,false,false,128);
				Screen->Arc(1,76,88,39,270-count,270,currentcolor,1,0,0,0,false,false,128);
				Screen->Arc(1,76,88,38.5,450-count,450,currentcolor,1,0,0,0,false,false,128);
				Screen->Arc(1,76,88,38.5,270-count,270,currentcolor,1,0,0,0,false,false,128);
				Screen->Arc(1,76,88,38,450-count,450,currentcolor,1,0,0,0,false,false,128);
				Screen->Arc(1,76,88,38,270-count,270,currentcolor,1,0,0,0,false,false,128);
				Screen->Line(1,lineX1,lineY1,Abs(lineX1-lineX4)/180*(180-count)+Min(lineX1,lineX4),
							Abs(lineY1-lineY4)/180*count+Min(lineY1,lineY4),currentcolor,1,0,0,0,128);
				Screen->Line(1,lineX1,lineY1,Abs(lineX1-lineX5)/180*count+Min(lineX1,lineX5),
							Abs(lineY1-lineY5)/180*count+Min(lineY1,lineY5),currentcolor,1,0,0,0,128);
				Screen->Line(1,lineX2,lineY2,Abs(lineX2-lineX4)/180*count+Min(lineX2,lineX4),
							Abs(lineY2-lineY4)/180*(180-count)+Min(lineY2,lineY4),currentcolor,1,0,0,0,128);
				Screen->Line(1,lineX2,lineY2,Abs(lineX2-lineX6)/180*count+Min(lineX2,lineX6),
							Abs(lineY2-lineY6)/180*count+Min(lineY2,lineY6),currentcolor,1,0,0,0,128);
				Screen->Line(1,lineX3,lineY3,Abs(lineX3-lineX5)/180*(180-count)+Min(lineX3,lineX5),
							Abs(lineY3-lineY5)/180*(180-count)+Min(lineY3,lineY5),currentcolor,1,0,0,0,128);
				Screen->Line(1,lineX3,lineY3,Abs(lineX3-lineX6)/180*(180-count)+Min(lineX3,lineX6),
							Abs(lineY3-lineY6)/180*count+Min(lineY3,lineY6),currentcolor,1,0,0,0,128);
				Screen->Line(1,lineX4,lineY4,Abs(lineX4-lineX5)/180*count+Min(lineX4,lineX5),
							Abs(lineY4-lineY5)/180*count+Min(lineY4,lineY5),currentcolor,1,0,0,0,128);
				Screen->Line(1,lineX5,lineY5,Abs(lineX5-lineX6)/180*(180-count)+Min(lineX5,lineX6),
							Abs(lineY5-lineY6)/180*count+Min(lineY5,lineY6),currentcolor,1,0,0,0,128);
				Screen->Line(1,lineX6,lineY6,Abs(lineX6-lineX4)/180*(180-count)+Min(lineX6,lineX4),
							Abs(lineY6-lineY4)/180*(180-count)+Min(lineY6,lineY4),currentcolor,1,0,0,0,128);
			}
			else if(introcount<420)
			{
				Screen->Arc(1,76,88,40,0,359,currentcolor,1,0,0,0,false,false,128);
				Screen->Arc(1,76,88,39.5,0,359,currentcolor,1,0,0,0,false,false,128);
				Screen->Arc(1,76,88,39,0,359,currentcolor,1,0,0,0,false,false,128);
				Screen->Arc(1,76,88,38.5,0,359,currentcolor,1,0,0,0,false,false,128);
				Screen->Arc(1,76,88,38,0,359,currentcolor,1,0,0,0,false,false,128);
				Screen->Line(1,lineX1,lineY1,lineX2,lineY2,currentcolor,1,0,0,0,128);
				Screen->Line(1,lineX2,lineY2,lineX3,lineY3,currentcolor,1,0,0,0,128);
				Screen->Line(1,lineX3,lineY3,lineX1,lineY1,currentcolor,1,0,0,0,128);
				Screen->Line(1,lineX4,lineY4,lineX5,lineY5,currentcolor,1,0,0,0,128);
				Screen->Line(1,lineX5,lineY5,lineX6,lineY6,currentcolor,1,0,0,0,128);
				Screen->Line(1,lineX6,lineY6,lineX4,lineY4,currentcolor,1,0,0,0,128);
			}
			else
			{
				int count = introcount-420;
				Screen->Arc(1,76,88,40,450+(count*3),630,currentcolor,1,0,0,0,false,false,128);
				Screen->Arc(1,76,88,40,270+(count*3),450,currentcolor,1,0,0,0,false,false,128);
				Screen->Arc(1,76,88,39.5,450+(count*3),630,currentcolor,1,0,0,0,false,false,128);
				Screen->Arc(1,76,88,39.5,270+(count*3),450,currentcolor,1,0,0,0,false,false,128);
				Screen->Arc(1,76,88,39,450+(count*3),630,currentcolor,1,0,0,0,false,false,128);
				Screen->Arc(1,76,88,39,270+(count*3),450,currentcolor,1,0,0,0,false,false,128);
				Screen->Arc(1,76,88,38.5,450+(count*3),630,currentcolor,1,0,0,0,false,false,128);
				Screen->Arc(1,76,88,38.5,270+(count*3),450,currentcolor,1,0,0,0,false,false,128);
				Screen->Arc(1,76,88,38,450+(count*3),630,currentcolor,1,0,0,0,false,false,128);
				Screen->Arc(1,76,88,38,270+(count*3),450,currentcolor,1,0,0,0,false,false,128);
				Screen->Line(1,lineX4,lineY4,Abs(lineX1-lineX4)/180*(180-count*3)+Min(lineX1,lineX4),
							Abs(lineY1-lineY4)/180*(count*3)+Min(lineY1,lineY4),currentcolor,1,0,0,0,128);
				Screen->Line(1,lineX5,lineY5,Abs(lineX1-lineX5)/180*(count*3)+Min(lineX1,lineX5),
							Abs(lineY1-lineY5)/180*(count*3)+Min(lineY1,lineY5),currentcolor,1,0,0,0,128);
				Screen->Line(1,lineX4,lineY4,Abs(lineX2-lineX4)/180*(count*3)+Min(lineX2,lineX4),
							Abs(lineY2-lineY4)/180*(180-count*3)+Min(lineY2,lineY4),currentcolor,1,0,0,0,128);
				Screen->Line(1,lineX6,lineY6,Abs(lineX2-lineX6)/180*(count*3)+Min(lineX2,lineX6),
							Abs(lineY2-lineY6)/180*(count*3)+Min(lineY2,lineY6),currentcolor,1,0,0,0,128);
				Screen->Line(1,lineX5,lineY5,Abs(lineX3-lineX5)/180*(180-count*3)+Min(lineX3,lineX5),
							Abs(lineY3-lineY5)/180*(180-count*3)+Min(lineY3,lineY5),currentcolor,1,0,0,0,128);
				Screen->Line(1,lineX6,lineY6,Abs(lineX3-lineX6)/180*(180-count*3)+Min(lineX3,lineX6),
							Abs(lineY3-lineY6)/180*(count*3)+Min(lineY3,lineY6),currentcolor,1,0,0,0,128);
				Screen->Line(1,lineX5,lineY5,Abs(lineX4-lineX5)/180*(count*3)+Min(lineX4,lineX5),
							Abs(lineY4-lineY5)/180*(count*3)+Min(lineY4,lineY5),currentcolor,1,0,0,0,128);
				Screen->Line(1,lineX6,lineY6,Abs(lineX5-lineX6)/180*(180-count*3)+Min(lineX5,lineX6),
							Abs(lineY5-lineY6)/180*(count*3)+Min(lineY5,lineY6),currentcolor,1,0,0,0,128);
				Screen->Line(1,lineX4,lineY4,Abs(lineX6-lineX4)/180*(180-count*3)+Min(lineX6,lineX4),
							Abs(lineY6-lineY4)/180*(180-count*3)+Min(lineY6,lineY4),currentcolor,1,0,0,0,128);
			}
			
			
		}
		
		if(introcount>=240&&introcount<330)
		{
			if((introcount%1)!=0) Screen->DrawTile(2,52,64+56,228,2,2,4,1.5,0,0,0,1,true,128);
		}
		if(introcount>=330&&introcount<420)
		{
			if((introcount%1)!=0) Screen->DrawTile(2,52,64+56,228,2,2,1,1.5,0,0,0,1,true,128);
		}
		if(introcount>=420&&introcount<480)
		{
			int tile = 228-((((introcount-420)/15)%2)*2);
			Screen->DrawTile(2,52,64+56,tile,2,2,1,1.5,0,0,0,1,true,128);
		}
		introcount++;
		Waitframe();
	}
	Link->Action=LA_WALKING;
	Screen->Quake=0;
	int enemyState = 0; //0 - Walking, 1 - Preparing to fire fire pillars, 2 - Preparing to fire Magic, 3 - Preparing to jump, 4 - Jumping
	int fireballFrequency = 90;
	int fireballTimer = 0;
	int curfireball = 3; 
	int attackFrequency = 150;
	int attackTimer = 0;
	int enemyDir = Rand(4);
	int enemySpeed = 2;
	int enemyX=52; int enemyY=64; int enemyZ=0; int enemyJump=0;
	int dead = 0;
	int frameCounter = 0;
	int waitCounter = 0;
	int freezeCounter = 0;
	
	//Spawn the enemy that will act as the guy
	npc main = Screen->CreateNPC(NPC_FIRE);
	main->X = enemyX+32;
	main->Y = enemyY;
	main->HP = 200;
	main->Damage = 16;
	main->Tile = 0;
	main->SFX = SFX_ROAR;
	
	//Spawn the invisible FFC that causes damage.
	ffc dmg = Screen->LoadFFC(2);
	dmg->Data = 168;
	dmg->EffectWidth = 31;
	dmg->EffectHeight = 44;
	dmg->X = enemyX+14;
	dmg->Y = enemyY+2;
	
	
	while(dead==0)
	{
		if(main->HP < 160) {attackFrequency=120; fireballFrequency=70; enemySpeed=2.5;}
		if(main->HP < 120) {attackFrequency=100; fireballFrequency=50; enemySpeed=3;}
		if(main->HP < 80) {attackFrequency=80; fireballFrequency=30; enemySpeed=4;}
		if(enemyState==0)
		{
			attackTimer++;
			fireballTimer++;
		}
		frameCounter=(frameCounter+1)%120;
		freezeCounter=Max(freezeCounter-1,0);
		
		if(Link->Action == LA_FROZEN)
		{
			if(freezeCounter<=0) Link->Action = Walking;
		}
		
		if(fireballTimer>=fireballFrequency)
		{
			ffc fireball = Screen->LoadFFC(curfireball);
			fireball->X = enemyX+32;
			fireball->Y = enemyY;
			fireball->Data = 211;
			fireball->Vx = Cos((-50+(Rand(5)*25))*(PI/180))*5;
			fireball->Vx = Cos((-50+(Rand(5)*25))*(PI/180))*5;
			curfireball++;
			if(curfireball>6) curfireball=3;
		}
		
		if(attackTimer>=attackFrequency)
		{
			if(Rand(60-(attackTimer-attackFrequence))<10)
			{
				int value = 3;
				if(main->HP > 120) value = 2;
				if(main->HP > 160) value = 1;
				enemyState = Rand(value)+1;
				attackTimer = 0;
			}
		}
		
		if(enemyState==0)
		{
			if(enemyDir==0)
			{
				enemyX-=enemySpeed;
				if(enemyX<24) {enemyX=24; enemyDir=4;}
			}
			if(enemyDir==1)
			{
				enemyX+=enemySpeed;
				if(enemyX>80) {enemyX=80; enemyDir=5;}
			}
			if(enemyDir==2)
			{
				enemyY-=enemySpeed;
				if(enemyY<32) {enemyY=32; enemyDir=6;}
			}
			if(enemyDir==3)
			{
				enemyY+=enemySpeed;
				if(enemyY>96) {enemyY=96; enemyDir=7;}
			}
			if(enemyDir==4)
			{
				enemyX-=enemySpeed;
				if(enemyX>52) {enemyX=52; enemyDir=Rand(4);}
			}
			if(enemyDir==1)
			{
				enemyX-=enemySpeed;
				if(enemyX<52) {enemyX=52; enemyDir=Rand(4);}
			}
			if(enemyDir==2)
			{
				enemyY+=enemySpeed;
				if(enemyY>64) {enemyY=64; enemyDir=Rand(4);}
			}
			if(enemyDir==3)
			{
				enemyY-=enemySpeed;
				if(enemyY<64) {enemyY=64; enemyDir=Rand(4);}
			}
			int tile = 228-((((frameCounter)/15)%2)*2);
			Screen->DrawTile(2,enemyX,enemyY+56,tile,2,2,1,1.5,0,0,0,1,true,128);
		}
		if(enemyState==1)
		{
			if(waitCounter>=60)
			{
				enemyState=0;
				eweapon magic = CreateEWeapon(WPN_ENEMYMAGIC);
				magic->X = enemyX+32;
				magic->Y = enemyY;
				magic->Damage = 16;
				magic->Step = 5;
				int tile = 228-((((frameCounter)/15)%2)*2);
				Screen->DrawTile(2,enemyX,enemyY+56,tile,2,2,1,1.5,0,0,0,1,true,128);
				waitCounter=0;
			}
			else
			{
				int cset = waitCounter%1;
				Screen->DrawTile(2,enemyX,enemyY+56,228,2,2,1,1.5,0,0,0,1,true,128);
				Screen->DrawTile(2,enemyX+24,enemyY+56,234,1,1,cset,1.5,0,0,0,1,true,128);
				waitCounter++;
			}
		}
		if(enemyState==2)
		{
			if(waitCounter>=60)
			{
				enemyState=0;
				ffc temp;
				for(int i=0; i<4; i++)
				{
					temp = LoadFFC(7+i);
					temp->X = -32;
					if(i==0)
					{
						temp->Y = Floor((Link->Y+8)/16)*16;
					}
					else
					{
						temp->Y = (Rand(7)*16)+32;
					}
					temp->Data = 170;
					temp->CSet = 8;
					temp->Delay = i*16;
					temp->Vx = 6;
					temp->TileWidth=2;
					temp->TileHeight=1;
					temp->EffectWidth=32;
					temp->EffectHeight=16;
				}
				int tile = 228-((((frameCounter)/15)%2)*2);
				Screen->DrawTile(2,enemyX,enemyY+56,tile,2,2,1,1.5,0,0,0,1,true,128);
			}
			else
			{
				int cset = waitCounter%1;
				Screen->DrawTile(2,enemyX,enemyY+56,228,2,2,1,1.5,0,0,0,1,true,128);
				Screen->DrawTile(2,enemyX+24,enemyY+56,235,1,2,cset,1.5,0,0,0,1,true,128);
				waitCounter++;
			}
		}	
		if(enemyState==3)
		{
			if(waitCounter>=60)
			{
				enemyState=4;
				enemyJump=3;
				int tile = 228-((((frameCounter)/15)%2)*2);
				Screen->DrawTile(2,enemyX,enemyY+56,tile,2,2,1,1.5,0,0,0,1,true,128);
				waitCounter=enemyY;
			}
			else
			{
				int cset = waitCounter%1;
				Screen->DrawTile(2,enemyX,enemyY+56,228,2,2,1,1.5,0,0,0,1,true,128);
				Screen->DrawTile(2,enemyX+24,enemyY+56,236,2,2,cset,1.5,0,0,0,1,true,128);
				waitCounter++;
			}
		}
		if(enemyState==4)
		{
			if(freezeCounter>0)
			{
				if(freezeCounter<=60)
				{
					enemyState = 0;
				}
			}
			else if(enemyY-enemyZ>=waitCounter && enemyJump < 0)
			{
				Screen->Quake = 60;
				freezeCounter=120;
				Link->Action=LA_FROZEN;
				int tile = 228-((((frameCounter)/15)%2)*2);
				Screen->DrawTile(2,enemyX,enemyY+56,tile,2,2,1,1.5,0,0,0,1,true,128);
				
			}
			else
			{
				enemyZ+=enemyJump;
				enemyJump-=0.4;
				int tile = 228-((((frameCounter)/15)%2)*2);
				Screen->DrawTile(2,enemyX,enemyY+56-enemyZ,tile,2,2,1,1.5,0,0,0,1,true,128);
			}
		}	
		main->X=enemyX+32;
		main->Y=enemyY;
		dmg->X=enemyX+14;
		dmg->Y=enemyY+2;
					
		Waitframe();
		if(main->HP < 40) dead=1;
	}
	Screen->Door[DIR_RIGHT] = D_OPEN;
	}
}

ffc script fireball_spawn
{
	void run()
	{
		while(true)
		{
			while(this->Data==1) Waitframe();
			
			int count=45;
			while(count>15) count--;
			this->Vx=0;
			this->Vy=0;
			
			// Spawn the three fireballs
			eweapon ball1 = Screen->CreateEWeapon(WPN_ENEMYFIREBALL);
			ball1->DeadState=-1;
			ball1->X=this->X;
			ball1->Y=this->Y;
			ball1->Damage=4;
			ball1->Tile=57;
			ball1->CSet=6;
			ball1->OriginalCSet=6;
			ball1->Flash=1;
			ball1->Angular=true;
			ball1->Angle=0;
			
			eweapon ball2 = Screen->CreateEWeapon(WPN_ENEMYFIREBALL);
			ball2->DeadState=-1;
			ball2->X=this->X;
			ball2->Y=this->Y;
			ball2->Damage=4;
			ball2->Tile=57;
			ball2->CSet=6;
			ball2->OriginalCSet=6;
			ball2->Flash=1;
			ball2->Angular=true;
			ball2->Angle=-30 * (PI/180);
			
			eweapon ball3 = Screen->CreateEWeapon(WPN_ENEMYFIREBALL);
			ball3->DeadState=-1;
			ball3->X=this->X;
			ball3->Y=this->Y;
			ball3->Damage=4;
			ball3->Tile=57;
			ball3->CSet=6;
			ball3->OriginalCSet=6;
			ball3->Flash=1;
			ball3->Angular=true;
			ball3->Angle=30 * (PI/180);
			
			Game->PlaySound(SFX_FIREBALL);
			
			this->X = -16;
			this->Y = -16;
			this->Data = 1;
		}
	}
}