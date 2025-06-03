ffc script BossEnemyMusic
{
	void run(int dmap)
	{
		int bossmusic[256];
		int areamusic[256];
			
		if ( Screen->State[ST_SECRET] )
			Quit();
			
		Waitframes(4);
		Game->GetDMapMusicFilename(dmap, bossmusic);
		Game->PlayEnhancedMusic(bossmusic, 0);
		
		while(ScreenEnemiesAlive())
			Waitframe();

		Game->GetDMapMusicFilename(Game->GetCurDMap(), areamusic);
		Game->PlayEnhancedMusic(areamusic, 0);
	}
	
	bool ScreenEnemiesAlive()
	{
		for(int i = Screen->NumNPCs(); i >= 1; i--)
		{
			npc n = Screen->LoadNPC(i);
			if(n->Type != NPCT_PROJECTILE && n->Type != NPCT_FAIRY && n->Type != NPCT_TRAP && n->Type != NPCT_GUY)
				if(!(n->MiscFlags&(1<<3)))
					return true;
		}
		return false;
	}
}