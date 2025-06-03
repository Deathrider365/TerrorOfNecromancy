int oldaudio = FadeMidi(120, 4);
int FadeMIDI(int time, int ticks_per_decrement)
{
	int oldaudio = Volume[VOL_MIDI]; //Store the ore-fade setting.
	for ( int q = 0; q < fade ; ++q )
	{
		if ( !(q%ticks_per_decrement) ) Audio->Volume[VOL_MIDI] = Clamp((Audio->Volume[VOL_MIDI]-1), 0, 255); 
		//Do not decrease below 0. 
		Waitframe();
	}
	return oldaudio;
}


int oldaudio = FadeMidi(120, 4);
//FadeOut
int FadeMIDI(int time, int ticks_per_decrement)
{
    int oldvol = Volume[VOL_MIDI]; //Store the ore-fade setting.
    for ( int q = 0; q < fade ; ++q )
    {
        if ( !(q%ticks_per_decrement) ) --(Audio->Volume[VOL_MIDI]);
	if ( Audio->Volume[VOL_MIDI] < 1 ) return oldvol; 
        //Do not waste frames if we reach 0!
        Waitframe();
    }
    return oldvol;
}

//FadeIn to the old volume
void FadeMIDI(int time, int ticks_per_decrement, int oldsetting)
{
    int oldvol = Volume[VOL_MIDI]; //Store the ore-fade setting.
    int q;
    while( Audio->Volume[VOL_MIDI] < oldsetting ) 
    {
        if ( !(q%ticks_per_decrement) ) ++(Audio->Volume[VOL_MIDI]);
        ++q;
        Waitframe();
    }
}