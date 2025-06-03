global script a
{
	void run()
	{
		int q; int w; int e; int r; int t; int y; int u; int i; int o; int p;
		TraceS("Executing a.run()");
		while(true)
		{
			if ( Link->PressEx1 )
					b.run();
			Waitframe();
		}
	}
}

global script b
{
	void run()
	{
		int q; int w; int e; int r; int t; int y; int u; int i; int o; int p;
		TraceS("Executing b.run()");
		while(1)
		{
			if ( Link->PressEx2 )
				a.run();
			Waitframe();
		}
	}

	void changex(int n)
	{
		n += 16; 
	}
}

ffc script f
{
	void run()
	{
		int x;
		changex(16); //if we call a.run(), then this will still call b.changex()
	}
	void changex(int n)
	{
		n -= 16;
	}
}