const int BLACK = 0x08;
const int WHITE = 0x0C;
const int SCROLL_SPEED = 2;
const int TEXT_SPACING = 6;	//was 4
const int HEADER_SPACING = 8;
void runCredits(int fadespeed, int font, int fontheight)
{
	int bossMusic[] = "AAA Ninja's Respite (Past) - The Messenger.ogg";
        Game->PlayEnhancedMusic(bossMusic, 0);
	for(int q = 0; q < 129; ++q)
	{
		for(int timer = 0; timer < fadespeed; ++timer)
		{
			Screen->Rectangle(7, 0, -56, q, 168, BLACK, 1, 0, 0, 0, true, OP_OPAQUE);
			Screen->Rectangle(7, 256-q, -56, 256, 168, BLACK, 1, 0, 0, 0, true, OP_OPAQUE);
			TotalNoAction();
			Waitframe();
		}
	}
	Game->Save();
	int authorHeader[] = "Author:";
	int authorName[] = "Deathrider365";
	
	int specialThanksHeader[] = "Advisors and General Help:";
	int specialThanks1[] = "Venrob";
	int specialThanks2[] = "ZoriaRPG";
	int specialThanks3[] = "Dimentio";
	int specialThanks4[] = "Lut";
	int specialThanks5[] = "Mitsukara";
	int specialThanks6[] = "Moosh";
	
	int betaTestersHeader[] = "Beta Testers:";
	int betaTester1[] = "ZachAttack20192001";
	int betaTester2[] = "a30502355";
	int betaTester3[] = "P-Tux7";
	int betaTester4[] = "Weirddud101";
	int betaTester5[] = "Soma C.";
	
	int musicHeader[] = "Music Used (in order of use):";
	int track1[] = "mp2d_TallonOverworld2D";
	int track2[] = "Dark Cave (Future) - The Messenger";	
	int track3[] = "Dark Cave (Past) - The Messenger";
	int track4[] = "Beneath the Tides (Past) - The Messenger";
	int track5[] = "Beneath the Tides (Future) - The Messenger";
	int track6[] = "Phantom of Yore (Past) - The Messenger";	
	int track7[] = "Ninja's Respite (Past) - The Messenger";
	
	int tilesetHeader[] = "Tileset Used (never use this hot garbage):";
	int tileset[] = "ezgbz 1.92";
	
	int end[] = "THE END";
	
	int gametime[32];
	int minutes = (Game->Time / (3600)) * 10000;
	int seconds = ((Game->Time % .3600) / 60) * 10000;
	int frames = (Game->Time % .0060) * 10000;
	int pos = itoa(gametime, 0, minutes);
	gametime[pos] = ':';
	pos += 1 + itoa(gametime, pos+1, seconds);
	gametime[pos] = '.';
	itoa(gametime, pos+1, frames);

	int numText = 23;		//when adding more lines add more to this
	int numHeader = 4;		// if there are to be more headers add more to this
	int VERTICAL_HEIGHT = Max(((fontheight+TEXT_SPACING) * (numText)) + (numHeader*HEADER_SPACING) + (224), 0);
	int q = -168;
	for(; q < VERTICAL_HEIGHT; ++q)
	{
		for(int timer = 0; timer < SCROLL_SPEED; ++timer)
		{
			Screen->Rectangle(7, 0, -56, 256, 176, BLACK, 1, 0, 0, 0, true, OP_OPAQUE);
			int y = 0;
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, authorHeader, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, authorName, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING + HEADER_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, specialThanksHeader, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, specialThanks1, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, specialThanks2, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, specialThanks3, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, specialThanks4, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, specialThanks5, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, specialThanks6, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING + HEADER_SPACING);

			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, betaTestersHeader, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, betaTester1, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, betaTester2, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, betaTester3, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, betaTester4, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, betaTester5, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING + HEADER_SPACING);
			
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, musicHeader, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, track1, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, track2, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, track3, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, track4, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, track5, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, track6, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, track7, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING + HEADER_SPACING);
			
			
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, tilesetHeader, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, tileset, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			
			y += 224;
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, end, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, gametime, OP_OPAQUE);
			TotalNoAction();
			Waitframe();
		}
	}
	--q;
	while(!Link->InputStart)
	{
			Screen->Rectangle(7, 0, -56, 256, 176, BLACK, 1, 0, 0, 0, true, OP_OPAQUE);
			int y = 0;
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, authorHeader, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, authorName, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING + HEADER_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, specialThanksHeader, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, specialThanks1, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, specialThanks2, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, specialThanks3, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, specialThanks4, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, specialThanks5, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, specialThanks6, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING + HEADER_SPACING);

			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, betaTestersHeader, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, betaTester1, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, betaTester2, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, betaTester3, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, betaTester4, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, betaTester5, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING + HEADER_SPACING);
			
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, musicHeader, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, track1, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, track2, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, track3, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, track4, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, track5, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, track6, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, track7, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING + HEADER_SPACING);
			
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, tilesetHeader, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, tileset, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			
			y += 224;
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, end, OP_OPAQUE);
			y += (fontheight + TEXT_SPACING);
			Screen->DrawString(7, 128, y-q, font, WHITE, -1, TF_CENTERED, gametime, OP_OPAQUE);
			TotalNoAction();
			Waitframe();
	}
}

void TotalNoAction()
{
	NoAction();
	Link->PressStart = false;
	Link->InputStart = false;
	Link->PressMap = false;
	Link->InputMap = false;
}