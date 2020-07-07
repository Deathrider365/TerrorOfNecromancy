///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~The Terror of Necromancy Passive Subscreen~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

#option SHORT_CIRCUIT on

CONFIG BG_MAP1 = 6;
CONFIG BG_SCREEN1 = 0x0F;

dmapdata script PassiveSubscreen
{
	void run()
	{
		bitmap bm = Game->CreateBitmap(256,224);
		bm->Clear(0);
		bm->Rectangle(0, 0, 0, 256, 56, BG_COLOR, 1, 0, 0, 0, true, OP_OPAQUE); //BG Color
		bm->DrawScreen(0, BG_MAP1, BG_SCREEN1, 0, 56, 0); //Draw BG screen
		//Do any other draws to the bitmap here
	
	}
	
	void translatePass(bitmap bm, int y, bool isActive)
	{
		bm->Blit(0, RT_SCREEN, 0, 0, 256, 224, 0, y - 56, 256, 224, 0, 0, 0, BITDX_NORMAL, 0, true); //Draw the BG bitmap to the screen
	}
}






































