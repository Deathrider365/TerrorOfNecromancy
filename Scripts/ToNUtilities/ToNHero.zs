//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Hero~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//~~~~~HeroInit~~~~~//
@Author("EmilyV99")
hero script HeroInit //start
{
	void run()
	{
		subscr_y_offset = -224;
	}
}
//end

//~~~~~HeroActive~~~~~//
@Author("EmilyV99")
hero script HeroActive //start
{
	void run()
	{
		clearStatuses();
		
		if (status_bmp && status_bmp->isAllocated())
			status_bmp->Free();
		
		DEFINE WIDTH = NUM_STATUSES * STATUS_WIDTH;
		DEFINE FONT_HEIGHT = Text->FontHeight(STATUS_FONT);
		DEFINE HEIGHT = STATUS_HEIGHT + FONT_HEIGHT;
		status_bmp = Game->CreateBitmap(WIDTH, HEIGHT);	
		
		while(true)
		{
			status_bmp->Clear(0);
			updateStatuses();
			
			int activeStatuses = 0;
			int statusSeconds[NUM_STATUSES];
			
			DEFINE START_X = (NUM_STATUSES - activeStatuses) * (STATUS_WIDTH / 2);
			
			for (int i = 0; i < NUM_STATUSES; ++i)
			{
				if (statuses[i])
				{
					++activeStatuses;
					statusSeconds[i] = Ceiling(statuses[i] / 60);
				}
			}
			
			int index;
			
			for (int i = 0; i < NUM_STATUSES; ++i)
			{
				unless (statuses[i])
					continue;
					
				status_bmp->FastTile(0, START_X + (index * STATUS_WIDTH), FONT_HEIGHT, getTile(<Status> i), 0, OP_OPAQUE);
				char32 buff[8];
				itoa(buff, statusSeconds[i]);
				status_bmp->DrawString(0, START_X + (index * STATUS_WIDTH) + (STATUS_WIDTH / 2), 
					0, STATUS_FONT, STATUS_TEXT_COLOR, -1, TF_CENTERED, buff, OP_OPAQUE);
			}
			
			status_bmp->Blit(7, -2, 0, 0, WIDTH, HEIGHT, getStatusX(statusPos, WIDTH), 
				getStatusY(statusPos, HEIGHT), WIDTH, HEIGHT, 0, 0, 0, BITDX_NORMAL, 0, true);
			
				
			Waitframe();
		}
	}
	
	void updateStatuses() //start
	{
		if (statuses[ATTACK_BOOST])
			--statuses[ATTACK_BOOST];
		if (statuses[DEFENSE_BOOST])
			--statuses[DEFENSE_BOOST];
	} //end
	
	void clearStatuses() //start
	{
		memset(statuses, 0, NUM_STATUSES); 
	} //end
	
	int getTile(Status status) //start
	{
		switch(status)
		{
			case ATTACK_BOOST:
				return TILE_ATTACK_BOOST;
			
			case DEFENSE_BOOST:
				return TILE_DEFENSE_BOOST;
		}
		
		return NULL;
	} //end
	
	int getStatusX(StatusPos position, int width) //start
	{
		switch(position)
		{
			case SP_ABOVE_HEAD:
				return Hero->X + 8 - (width / 2);
			case SP_TOP_RIGHT:
				return 256 - width;
		}
	} //end
	
	int getStatusY(StatusPos position, int height) //start
	{
		switch(position)
		{
			case SP_ABOVE_HEAD:
				return Hero->Y - height - 4;
			case SP_TOP_RIGHT:
				return 0;
		}
	} //end

}
//end

//~~~~~OnDeath~~~~~//
@Author("Deathrider365")
hero script OnDeath //start
{
	void run()
	{
		onContHP = Hero->MaxHP;
		onContMP = Hero->MaxMP;	
	}
}
//end

