//////////////////////////////////////////////////
/// Revised String Table Processor for ZScript ///
/// Allows defining custom string tables       ///
/// and displaying fancy messages with custom  ///
/// backgrounds, music and sound effects.      ///
/// v2.1                                       /// 
/// 15th October, 2018                         ///
/// By: ZoriaRPG                               ///
//////////////////////////////////////////////////
/// 1.0 : Rewrote string processor.
///
/// 2.0 : Added Display generation and music playback.
/// 2.1 : Changed str_template.draw(id) to str_template.draw(id, number_of_lines), 
///     : adding in the ability to apeend multiple strings to a single display call.
///

//! STRING TABLE AND PROCESSOR

namespace script strings
{
	const int BUFFER_SIZE = 1024;
	const int MAX_STRINGS = 4096;
	const int CURRENT_STRING_ID = 4095; //The 'TOP'. This will always be the ID of the last string called.
	int buffer[BUFFER_SIZE];
	int ids[MAX_STRINGS];
	
	
	/*List strings in the table using the following format:
	
	$ <NUMBER> : <string>
	
	Tokens:
	$ -- Indicates the beginning of a string ID.
	<NUMBER> a series of numeric characters that represent the numeric ID of the string.
	: -- COlon separator between <NUMBER> and <string>
	<string> The string text.
	*/
	int table[]=
	"$000001:This is a string.
	$000002:This is a second.
	$000003:This is a third.
	$000004:This is a fourth
	$000005:This is a fifth.";
	void run(){}
	
	//stores the initial position of all strings in the table into ids[] 
	//where the index of ids[index] == the string ID.
	void init()
	{
		int token[7]; int token_pos; int table_pos;
		
		for ( table_pos = 0; table[table_pos] != NULL; ++table_pos )
		{
			//find the tokens
			if ( table[table_pos] == '$' )
			{	
				//copy the string ID into the token
				token_pos = 0;
				while( table[table_pos] != ':' )
				{
					token[token_pos] = table[q];
					++token_pos;
					++q;
				}
				//store the index where the token ends + 2
				ids[atoi(token)] = table_pos +2;
			}
		}
	}
	void clear()
	{
		for ( int q = 0; q < BUFFER_SIZE; ++q )
		{
			buffer[q] = 0;
		}
	}
	void fetch(int string_id)
	{
		int table_pos = ids[string_id];
		for ( int buffer_pos = 0; table[table_pos+1] != '$'; ++buffer_pos )
		{
			buffer[buffer_pos] = table[table_pos];
			++table_pos;
			ids[CURRENT_STRING_ID] = string_id;
		}
	}
		
		
	void store(int msg_id)
	{
		if ( msg_id <= 0 ) 
		{
			TraceError("Invalid message ID passed to strings.store()", msg_id);
			return;
		}
		if ( msg_id >= Game->NumMessages )
		{
			TraceError("Invalid message ID passed to strings.store()", msg_id);
			return;
		}
		SetMessage(msg_id, buffer);
	}
	void display(int string_id)
	{
		fetch(string_id);
		store(Game->NumMessages);
		Screen->Message(Game->NumMessages);
	}
	void display(int string_id, int template_message)
	{
		fetch(string_id);
		store(template_message);
		Screen->Message(template_message);
	}
}

//SPECIALTY DRAWING WITH MUSIC AND SOUNDS


namespace script str_template
{
	define FONT 		= l;
		define F_COLOUR 	= 2;
		define F_BCOLOUR	= 3;
		
		//Window, Solid colour
		define W_COLOUR 	= 4;
		
		//Window Tiles
		define TILE		= 5;
		define TILE_W		= 6;
		define TILE_H		= 7;
		define TILE_X		= 8;
		define TILE_Y		= 9;
		
		define CHAR_WIDTH 	= 10;
		define CHAR_HEIGHT 	= 11;
		
		define WINDOW_X 	= 12;
		define WINDOW_Y 	= 13;
		define WINDOW_H 	= 14;
		define WINDOW_W 	= 15;
		define CHAR_X 		= 16;
		define CHAR_Y 		= 17;
		define W_OPACITY 	= 18;
		define T_OPACITY 	= 19;
		define F_OPACITY 	= 20;
		define W_LAYER 		= 21;
		define T_LAYER 		= 22;
		define F_LAYER		= 23;
		
		define SOUND_DISPLAY	= 24;
		define SOUND_EXIT	= 25;
		define MUSIC_SPECIAL	= 26; //This is a ZQuest Message String containing the track filename.
		define MUSIC_TRACK	= 27;
		define MIDI_SPECIAL	= 28;
		
		define TILE_CSET	= 29;
		define TILE_XSCALE	= 30;
		define TILE_YSCALE	= 31;
		
		define NUM_SETTINGS	= 32;
	void run(){}
	//Define a tyle ID
	define BLACK = 1;
	//Declare a function for the style, and list all of the atyle attributes, assigning their data. 
	void black(int style_ptr)
	{
		style_ptr[FONT] 	= FONT_APPLE2; //Apple II
		style_ptr[F_COLOUR] 	= 0x01; //font colour, white
		style_ptr[F_BCOLOUR] 	= 0x00; //font background colour, translucent
		style_ptr[W_COLOUR] 	= 0x0F; //window colour (background), black
		style_ptr[TILE]		= 0;
		style_ptr[TILE_W]	= 0;
		style_ptr[TILE_H]	= 0;
		style_ptr[TILE_X]	= 0;
		style_ptr[TILE_Y]	= 0;
		
		style_ptr[TILE_CSET]	= 0;
		style_ptr[TILE_XSCALE]	= -1;
		style_ptr[TILE_YSCALE]	= -1;
		
		style_ptr[CHAR_WIDTH] 	= 6; //5 + one space
		style_ptr[CHAR_HEIGHT] 	= 9; //8 + one space
		style_ptr[WINDOW_X] 	= 12; //window indent over screen
		style_ptr[WINDOW_Y] 	= 16; //window indent over screen
		style_ptr[WINDOW_H] 	= 180; //style_ptr[CHAR_WIDTH * style_ptr[BUFFER_LENGTH;
		style_ptr[WINDOW_W] 	= 60; //style_ptrCHAR_HEIGHT * 3;
		style_ptr[CHAR_X] 	= 4; //Initial x indent
		style_ptr[CHAR_Y] 	= 12; //Initial y indent
		style_ptr[W_OPACITY] 	= OP_OPAQUE; //Window translucency.
		style_ptr[F_OPACITY] 	= OP_OPAQUE; //Font translucency.
		style_ptr[T_OPACITY] 	= OP_OPAQUE; //Font translucency.
		style_ptr[W_LAYER] 	= 6; //window draw layer
		style_ptr[T_LAYER] 	= 6; //font draw layer
		style_ptr[F_LAYER] 	= 6; //font draw layer
		
		style_ptr[SOUND_EXIT]	= 63;
		style_ptr[NUM_SETTINGS]	= 64;
		
		style_ptr[MUSIC_SPECIAL]= 0; //Needs a function call assign. May not work. 
		style_ptr[MIDI_SPECIAL]	= 0; 
		
	}
	
	//! We need a way to append messages without restarting the music or closing the box entirely. 
	//! perhaps in the function to press a button? Or some kind of CALLBACK. 
	void draw(int mode, int number_of_lines) //number_of_lines is to append more strings, to advance
	{
		
		int style[NUM_SETTINGS]; //The mode arg will call a function to populate this.
		
		//! List all STYLE CASEs here, and call their functions. 
		switch(mode)
		{
			//Populate the 'style' array with attributed defined in the 
			//style population function for the CASE value.
			case BLACK: black(style); break; //'style' is the pointer to our array 
					
			default: TraceError("Invalid Message Style passed to str_template.draw()", mode); break;
		}
		
		
		//STORE OLD MIDI AND MUSIC
		
		int old_music[256]; int old_track = Game->GetDMapMusicTrack(Game->GetCurDMap());
		GetDMapMusicFilename(Game->GetCurDMap(), old_music);
		
		int old_midi = Game->GetMIDI();
		
		//Play the display sound.
		Audio->PlaySound(style[SOUND_DISPLAY]);
		
		//IF SET, PLAY SPECIAL MIDI OR MUSIC
		bool playing = false;
		if ( style[MUSIC_SPECIAL] ) 
		{
			//! This is tricky, because we need to pass the name of the track without wasying a variable.
			//! Let's use a message for it!
			int music_buf[256]; GetMessage(style[MUSIC_SPECIAL], music_buf);
			playing = PlayEnhancedMusic(music_buf, style[MUSIC_TRACK]);
		}
		
		if ( !playing )
		{	//if the enhanced muwsic failed, or we are only using MIDIs, 
			if ( style[MIDI_SPECIAL] ) 
			{
				//and we have set a MIDI to play, 
				//PLAY IT HERE
				Audio->PlayMIDI(style[MIDI_SPECIAL]);
			}
		}
		
		//Do the drawing
		do
		{
			Screen->Rectangle(style[W_LAYER], style[WINDOW_X], style[WINDOW_Y], style[WINDOW_X+WINDOW_W], 
			style[WINDOW_Y+WINDOW_H], style[W_COLOUR], 100, 0,0,0,true,style[W_OPACITY]);
			
			//if we are overlaying a tile block, or just using that:
			if ( style[TILE] )
			{
				Screen->DrawTile(style[T_LAYER], style[TILE_X], style[TILE_Y], style[TILE],
					style[TILE_W], style[TILE_H], style[TILE_CSET], style[TILE_XSCALE],
					style[TILE_YSCALE], 0, 0, 0, 0, false, T_OPACITY);
			}
			Screen->DrawString(F_LAYER,CHAR_X,CHAR_Y,FONT,F_COLOUR,F_BCOLOUR,0,strings.buffer,F_OPACITY);
			if ( Input->Press[CB_A] || Input->Press[CB_B] ) //advance the message
			{
				strings.fetch(strings.ids[CURRENT_STRING_ID]+1); //Get the next string in the sequence. 
				--number_of_lines
			}
			Waitframe();
		}while(waiting_for_press() && number_of_lines > 0); //
		
		//Play the exit sound, for closing the display.
		Audio->PlaySound(style[SOUND_EXIT]);
		playing = false; //Restore its state to reuse it.
		
		//RESTORE OLD MIDI OR MUSIC
		if ( old_music[4] ) //if there was ednhanced music, restore it 
			//using the 4th character to avoid error return data being read.
			//IDR what GetDMapMusicFilename() stores in the array if there is no enhanced music. 
			//if there is music playing, it will need at least four characters (1.mp3, the fourth character is 'p').
		{
			playing = Game->PlayEnhancedMusic(old_music, old_track);
			
		}
		if ( !playing ) //Either the restored music did not load, or there was none.
		{
			Game->PlayMIDI(old_midi); //Restore the MIDI
		}
	}
	bool waiting_for_press()
	{
		if ( Input->Pres[CB_A] ) return false;
		if ( Input->Pres[CB_B] ) return false;
		return true;
	}
		
}