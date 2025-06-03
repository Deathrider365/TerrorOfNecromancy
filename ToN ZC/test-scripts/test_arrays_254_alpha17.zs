import "std.zh"



global script a{
	void run(){
		int walkingtile[2] = { 11720, 11721};
		//Link->ScriptTile = walkingtile[0];
		int frame = -1;
		while(true){
			if ( ++frame >= 60 ) frame = 0;

			if ( Link->InputLeft ) 
			{
				//if ( !(frame % 5) ) Link->ScriptTile = walkingtile[1];
				//else Link->ScriptTile = walkingtile[0];
			}
			if ( Link->InputRight ) 
			{
				//if ( !(frame % 5) ) Link->ScriptTile = walkingtile[1];
				//else Link->ScriptTile = walkingtile[0];
			}
			if ( Link->InputUp ) 
			{
				//if ( !(frame % 5) ) Link->ScriptTile = walkingtile[1];
				//else Link->ScriptTile = walkingtile[0];
			}
			if ( Link->InputDown ) 
			{
				//if ( !(frame % 5) ) Link->ScriptTile = walkingtile[1];
				//else Link->ScriptTile = walkingtile[0];
			}
			if ( Link->PressEx3 ) { Link->ScriptTile = Clamp((Link->ScriptTile-1), 0, MAX_TILES); TraceS("ScriptTile: "); Trace(Link->ScriptTile); }
			if ( Link->PressEx4 ) { Link->ScriptTile = Clamp((Link->ScriptTile+1), 0, MAX_TILES); TraceS("ScriptTile: "); Trace(Link->ScriptTile); }
			
			if ( Link->PressEx1 ) { Link->ScriptFlip = Clamp((Link->ScriptFlip-1), -1, 7); TraceS("ScriptFlip: "); Trace(Link->ScriptFlip); }
			if ( Link->PressEx2 ) { Link->ScriptFlip = Clamp((Link->ScriptFlip+1), -1, 7); TraceS("ScriptFlip: "); Trace(Link->ScriptFlip); }
			switch(Link->Dir)
			{
				case DIR_UP:
					Link->ScriptFlip = FLIP_NONE; 
					break;

				case DIR_DOWN:
					Link->ScriptFlip = FLIP_VERTICAL;  
					break;
				case DIR_LEFT: 
					Link->ScriptFlip = ROT_ACW; 
					break;
				case DIR_RIGHT: 
					Link->ScriptFlip = ROT_CW;
					break;

				default: break;
			}

			Waitdraw(); Waitframe();
		}
	}
}
