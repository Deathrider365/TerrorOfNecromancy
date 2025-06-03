import "std.zh"


ffc script storePixels
{
	const int RAMSIZE = 256*176;
	int ram[RAMSIZE+1];
	const int start_x = 0;
	const int start_y = 0;
	const int end_x = 256;
	const int end_y = 176;
	bitmap bmp;

	int buffer[256];
	
	void run()
	{
		int q = 0;
		
		Screen->SetRenderTarget(RT_BITMAP1);
		Screen->DrawScreen(0, Game->GetCurMap(), Game->GetCurScreen(), 0, 0, 0);
		Screen->SetRenderTarget(RT_SCREEN);
TraceS("Preliminary screen draw complete.");
		Waitframe();

TraceS("Waiting a frame for caution before reading pixel values.");
		
		bmp = Game->LoadBitmapID(RT_BITMAP1);
		for ( int y = stary_y; y < end_y; ++y ) 
		{

			for ( int x = start_x; x < end_x; ++x ) 
			{
				ram[q] = bmp->GetPixel(x,y);
				++q;
			}
		}
		
		TraceS("stored all pixel data");

	
		for ( int w = 0; w < RAMSIZE; ++w )
		{
			itoa(buffer, ram[w]);
			TraceS(buffer); TraceS(",");
			if ( w > 0 }
			{	
				if ( !(w % 256) ) TraceNL();
			}
			
		}
	}
}
