import "std.zh"
int loop;

npc script N
{
	void run(){TraceToBase(64,10,2); this->X = 16;}
	
}
/*
lweapon script L
{
	void run(){}
}

eweapon script E
{
	void run(){}
}

screendata script S
{
	void run(){}
}
dmapdata script D
{
	void run(){}
}
*/
item script TEST
{
	void run()
	{
		lweapon l[16]; lweapon l2; 
		for ( int q = 0; q < 16; ++q ) 
		{
			l[q] = Screen->CreateLWeapon(13);
			//TraceS("Creating sixteen weapons");
			l[q]->X = Link->X + (Rand(-40,40));
			l[q]->Y = Link->Y + (Rand(-40,40));
			l[q]->UseSprite(87);
			l[q]->Dir = Rand(0,7);
			//l2->X - 40;
			//l2->Y - 40;
			//l2->UseSprite(87);
			//l2->Dir = Rand(0,7);	
		//l->Angular = true;
			//l->Angle = DegtoRad(Rand(0,359));
			l[q]->Step = Rand(30,140);
			//l2->Step = Rand(40,60);
		}

		while(1)
		{
			
			++loop;
			if ( !(loop%60))
			{
				TraceS("Item script is running"); TraceNL();
				Trace(loop); TraceNL(); 
			}
			if ( loop %30 == 0 )
			{
			for ( int q = 0; q < 16; ++q ) 
			{
				l[q]->Dir = Rand(0,7);
				l->Step += Rand(-5,5);
				//l[q] = Screen->CreateLWeapon(LW_SCRIPT1);
				//l[q]->UseSprite(9);
				//l->Angular = true;
				//l->Angle = DegtoRad(Rand(0,359));
				//l->Step = Rand(6,60);

			}
}
			Waitframe();
		}

	}
}


