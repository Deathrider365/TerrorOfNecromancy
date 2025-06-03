global script a
{
	void run()
	{
		int y;
		TraceS("Executing a.run()");
		while(true)
		{
			if ( Link->PressEx1 )
					b.run(y);
			if ( Link->PressEx3 ) TraceS("Script `a` is running");
			Waitframe();
		}
	}
}

global script b
{
	void run(int b)
	{
		TraceS("Executing b.run()");
		while(1)
		{
			if ( Link->PressEx2 )
			{	TraceS("exiting b.run()"); return;
			}
			Waitframe();
		}
	}
}
