import "std.zh"

global script a
{
	void run()
	{
		bool c = true;
		int x = 2;
		while(1)
		{
			if ( Input->Key[KEY_5] ) test(x,c);
			Waitdraw();
			Waitframe();
		}
		
		
	}
	
	void test(int b, bool cond)
	{
		switch(b)
		{
			
			case 1: 
			{
				int x;
				for ( ; x > 0; ++x ) { Waitframe(); }
			
				for( ; cond; cond = (cond) ) Waitframe();
				break;
			}
			case 2: 
			{
				while(cond) Waitframe();
				break;
			}
			case 3:
			{
				while(!cond) Waitframe();
				break;
			}
			default: break;
		}
		
		
	}
}
