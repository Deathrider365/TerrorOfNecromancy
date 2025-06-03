import "std.zh"

global script a
{
	void run()
	{
		while(1)
		{
			int points[16] = { 20,20,3,128, 20,21,4,128, 20,22,0x11,64, 20,23,0x12,128 };
			Screen->PutPixels(5,points,0,0,0);
			Waitframe();
		}
	}
}
