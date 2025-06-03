import "std.zh"


ffc script storePixels
{
	const int RAMSIZE = 256*176;
	int ram[RAMSIZE+1];
	const int start_x = 0;
	const int start_y = 0;
	const int end_x = 256;
	const int end_y = 176;
	const int NUMS_IN_SET = 16;
	bitmap bmp;
	
	
	
	void run()
	{
		ClearTrace();
		int q = 0;
		
		Screen->SetRenderTarget(RT_BITMAP1);
		Screen->DrawScreen(0, Game->GetCurMap(), Game->GetCurScreen(), 0, 0, 0);
		Screen->SetRenderTarget(RT_SCREEN);
TraceS("Preliminary screen draw complete.");
		//Waitframe(); //not needed, it seems

		//TraceS("Waiting a frame for caution before reading pixel values.");
		
		bmp = Game->LoadBitmapID(RT_BITMAP1);
		for ( int y = start_y; y < end_y; ++y ) 
		{

			for ( int x = start_x; x < end_x; ++x ) 
			{
				ram[q] = bmp->GetPixel(x,y)*10000;
				
				++q;
			}
		}
		
		int TAB[2];
		TAB[0] = CHAR_TAB;
		TraceS("stored all pixel data");

		TraceNL(); TraceNL(); 
		TraceS("int __pixeldata[256*176] = { ");
		TraceNL(); TraceS(TAB);
		for ( int w = 0; w < RAMSIZE; ++w )
		{
			int buffer[4];
			itoa(buffer, ram[w]);
			TraceS(buffer); 
			if ( w < RAMSIZE-1 ) TraceS(",");
			if ( w > 0 )
			{	
				if ( !(w % NUMS_IN_SET) ){ TraceNL(); TraceS(TAB);}
			}
			
		}
		TraceNL(); TraceS(" };"); 
	}
}
