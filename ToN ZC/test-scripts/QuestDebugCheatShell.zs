/////////////////////////////////
/// Debug Shell for ZC Quests ///
/// Alpha Version 1.1         ///
/// 15th October, 2018        ///
/// By: ZoriaRPG              ///
/// Requires: ZC Necromancer  ///
/////////////////////////////////
/*
DEFINED INSTRUCTION VALUES
	w WARP: return 2;	//dmap,screen
	p POS: return 2;		//x,y
	mx MOVEX: return 1; 	//pixels (+/-)
	my MOVEY: return 1; 	//pixels (+/-)
	rh REFILLHP: return 0;	//aNONE
	rm REFILLMP: return 0;	//NONE
	rc REFILLCTR: return 1;	//counter
	mh MAXHP: return 1;	//amount
	mm MAXMP: return 1;	//amount
	mc MAXCTR: return 2;	//counter, amount
	
	inv INVINCIBLE: return 1;	//(BOOL) on / off
	itm LINKITEM: return 2;	//item, (BOOL), on / off

//COMMAND LIST
	w: Warp Link to a specific dmap and screen
	p: Reposition Link on the screen.
	mx: Move link by +/-n pixels on the X axis.
	my: Move link by +/-n pixels on the Y axis.
	rh: Refill Link's HP to Max.
	rm: Refill Link's HP to Max.
	rc: Refill a specific counter to Max.
	mh: Set Link's Max HP.
	mm: Set Link's Max MP
	mc: Set the maximum value of a specific counter.
	inv: Set Link's Invisible state.
	itm: Set the state of a specific item in Link's inventory.
//SYNTAX
//command,args
	w,1,2
	p,1,2
	mx,1
	mx,-1
	my,1
	my,-1
	rh
	rm
	rc,1
	mh,1
	mm,1
	mc,1,2
	inv,true
	inv,false
	itm,1,true
	itm,1,false
		
		

*/

script typedef ffc namespace;
typedef const int define;
typedef const int CFG;



namespace script debugshell
{
	define INSTRUCTION_SIZE = 1; //The number of stack registers that any given *instruction* requires.
	define MAX_INSTR_QUEUE = 1; //The number of instructions that can be enqueued. 
	define MAX_ARGS 	= 2; //The maximum number of args that any instruction can use/require. 
	define STACK_SIZE 	= 1 + ((INSTRUCTION_SIZE+MAX_ARGS)*MAX_INSTR_QUEUE); 
	define MAX_TOKEN_LENGTH = 16;
	define BUFFER_LENGTH 	= 42;
	int stack[STACK_SIZE];
	int SP;
	
	int debug_buffer[BUFFER_LENGTH];
	
	define YES = 1;
	define NO = 0;
	
	CFG log_actions = YES;
	CFG WINDOW_F_KEY = 7; //We use F7 to open the debug window. 
	
	
	define FONT = FONT_APPLE2; //Apple II
	define F_COLOUR = 0x01; //font colour, white
	define F_BCOLOUR = 0x00; //font background colour, translucent
	define W_COLOUR = 0x0F; //window colour (background), black
	define CHAR_WIDTH = 6; //5 + one space
	define CHAR_HEIGHT = 9; //8 + one space
	define WINDOW_X = 12; //window indent over screen
	define WINDOW_Y = 16; //window indent over screen
	define WINDOW_H = CHAR_WIDTH * BUFFER_LENGTH;
	define WINDOW_W = CHAR_HEIGHT * 3;
	define CHAR_X = 4; //Initial x indent
	define CHAR_Y = 12; //Initial y indent
	define W_OPACITY = OP_OPAQUE; //Window translucency.
	define F_OPACITY = OP_OPAQUE; //Font translucency.
	define W_LAYER = 6; //window draw layer
	define F_LAYER = 6; //font draw layer
	
	CFG KEY_DELAY = 6; //frames between keystrokes
	
	define TYPESFX = 63;
	
	void process()
	{
		if ( FKey(WINDOW_F_KEY) )
		{
			if ( type() ) 
			{
				read(debug_buffer);
				execute();
			}
		}
	}
	
	//if ( type() execute() )
	//returns true if the user presses enter
	bool type()
	{
		Game->TypingMode = true;
		int key_timer; int buffer_pos = 0;
		while(!Input->KeyPress[KEY_ENTER] || Input->Key[KEY_ENTER_PAD])
		{
			if ( key_timer <= 0 )
			{
				if ( KeyToChar(CHAR_BACKSPC) ) //backspace
				{
					
					if ( buffer_pos > 0 )
					{
						debug_buffer[buffer_pos] = 0;
						--buffer_pos;
					}
					key_timer = KEY_DELAY;
					continue;
				}
				else if ( Input->Key[KEY_ENTER] || Input->Key[KEY_ENTER_PAD] ) 
				{
					Game->TypingMode = false;
					if ( !buffer_pos ) return false; //do not execute if there are no commands
					return true;
				}
				else if ( EscKey() ) 
				{
					Game->TypingMode = false;
					return false; //exit and do not process.
				}
				
				else
				{
					//else normal key
					int k; 
					int LegalKeys[]= 
					{
						KEY_A, KEY_B, KEY_C, KEY_D, KEY_E, KEY_F, KEY_G, KEY_H, 
						KEY_I, KEY_J, KEY_K, KEY_L, KEY_M, KEY_N, KEY_O, KEY_P, 
						KEY_Q, KEY_R, KEY_S, KEY_T, KEY_U, KEY_V, KEY_W, KEY_X, 
						KEY_Y, KEY_Z, KEY_0, KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, 
						KEY_6, KEY_7, KEY_8, KEY_9, KEY_0_PAD, KEY_1_PAD, KEY_2_PAD, 
						KEY_3_PAD, KEY_4_PAD, KEY_5_PAD,
						KEY_6_PAD, KEY_7_PAD, KEY_8_PAD, KEY_9_PAD, 
						//KEY_TILDE, 
						KEY_MINUS, 
						//KEY_EQUALS, KEY_OPENBRACE, KEY_CLOSEBRACE,
						//KEY_COLON, KEY_QUOTE, KEY_BACKSLASH, KEY_BACKSLASH2, 
						KEY_COMMA, 
						//KEY_SEMICOLON, KEY_SLASH, KEY_SPACE, KEY_SLASH_PAD,
						//KEY_ASTERISK, 
						KEY_MINUS_PAD, 
						//KEY_PLUS_PAD, KEY_CIRCUMFLEX, KEY_COLON2, KEY_EQUALS_PAD, KEY_STOP 
					};

					
					for ( int kk = SizeOfArray(LegalKeys); kk >= 0; --kk )
					{
						k = LegalKeys[kk];
						if ( Input->Key[k] )
						{
							debug_buffer[buffer_pos] = KeyToChar(k); //Warning!: Some masking may occur. :P
						}
					}
					++buffer_pos;
					key_timer = KEY_DELAY;
					continue;
				}
			}
			--key_timer;
			draw();
			Waitframe();
		}
		
	}
	
	void draw()
	{
		Screen->Rectangle(W_LAYER, WINDOW_X, WINDOW_Y, WINDOW_X+WINDOW_W, WINDOW_Y+WINDOW_H, W_COLOUR, 100, 0,0,0,true,W_OPACITY);
		Screen->DrawString(F_LAYER,CHAR_X,CHAR_Y,FONT,F_COLOUR,F_BCOLOUR,0,debug_buffer,F_OPACITY);
	}
	
	void TraceErrorS(int s, int s2)
	{
		int buf[12];
		ftoa(buf,v);
		TraceS(s); TraceS(": "); TraceS(s2); TraceNL();
	}
	
	void TraceError(int s, float v, float v2)
	{
		int buf[12]; int buf2[12];
		ftoa(buf,v);
		ftoa(buf2,v2);
		TraceS(s); TraceS(": "); TraceS(buf); TraceS(", "); TraceS(buf2); TraceNL();
	}
	
	void TraceErrorVS(int s, float v, int s2)
	{
		int buf[12];
		ftoa(buf,v);
		TraceS(s); TraceS(": "); TraceS(buf); TraceS(", "); TraceS(s2); TraceNL();
	}
	
	//instruction		//variables
	define NONE	= 1;	//NONE 
	define WARP 	= 1;	//dmap,screen
	define POS 	= 2;	//x,y
	define MOVEX 	= 3;	//pixels (+/-)
	define MOVEY 	= 4;	//pixels (+/-)
	define REFILLHP = 5;	//aNONE
	define REFILLMP = 6;	//NONE
	define REFILLCTR = 7;	//counter
	define MAXHP 	= 8;	//amount
	define MAXMP 	= 9;	//amount
	define MAXCTR 	= 10;	//counter, amount
	
	define INVINCIBLE = 11;	//(BOOL) on / off
	define LINKITEM = 12;	//item, (BOOL), on / off
	
	
	
	
	
	int num_instruction_params(int instr)
	{
		switch(instr)
		{
			//instruction		//variables
			case NONE: return 0;
			case WARP: return 2;	//dmap,screen
			case POS: return 2;		//x,y
			case MOVEX: return 1; 	//pixels (+/-)
			case MOVEY: return 1; 	//pixels (+/-)
			case REFILLHP: return 0;	//aNONE
			case REFILLMP: return 0;	//NONE
			case REFILLCTR: return 1;	//counter
			case MAXHP: return 1;	//amount
			case MAXMP: return 1;	//amount
			case MAXCTR: return 2;	//counter, amount
			
			case INVINCIBLE: return 1;	//(BOOL) on / off
			case LINKITEM: return 2;	//item, (BOOL), on / off
			default: 
			{
				
				TraceError("Invalid instruction passed to stack",instr); 
				return 0;
			}
		}
	}
	
	
	
	int match_instruction(int token)
	{
		if ( strcmp(token,"w")) return WARP;
		if ( strcmp(token,"P")) return POS;
		if ( strcmp(token,"mx")) return MOVEX;
		if ( strcmp(token,"my")) return MOVEY;
		if ( strcmp(token,"rh")) return REFILLHP;
		if ( strcmp(token,"rm")) return REFILLMP;
		if ( strcmp(token,"rc")) return REFILLCTR;
		if ( strcmp(token,"mh")) return MAXHP;
		if ( strcmp(token,"mm")) return MAXMP;
		if ( strcmp(token,"mc")) return MAXCTR;
		if ( strcmp(token,"inv")) return INVINCIBLE;
		if ( strcmp(token,"itm")) return LINKITEM;
		TraceErrorS("match_instruction(TOKEN) could not evaluate the instruction:",token); 
		return 0;
	}
	
	int read(int str)
	{
		int token[16]; int input_string_pos; 
		int e; int token_pos; int current_param;
		for ( input_string_pos = 0; input_string_pos < MAX_TOKEN_LENGTH; ++input_string_pos )
		{
			while(buffer[input_string_pos] != ',')
			{
				if ( token[input_string_pos] == NULL ) break;
				token[input_string_pos] = str[input_string_pos];
			}
			++input_string_pos; //skip the comma now. If there are no params, we'll be on NULL.
		}
		
		//put the instruction onto the stack.
		//Right now, we are only allowing one instruction at a time.
		//This allows for future expansion.
		stack[SP] = match_instruction(token);
		int num_params = num_instruction_params(stack[SP]);
		
		if ( num_params )
		{
			if ( str[input_string_pos] == NULL ) 
			{
				//no params.
				TraceErrorS("Input string is missing params. Token was:", "token");
			}
		}
		
		++SP; //get the stack ready for the next instruction.
		//push the variables onto the stack.
		while ( current_param <= num_params )  //repeat this until we are out of params
			//NOT a Do loop, because some instructions have no params!
		{
			for ( token_pos = MAX_TOKEN_LENGTH-1; token_pos >= 0; --token_pos ) token[token_pos] = 0; //clear the token
			
			//copy over new token
			while( buffer[input_string_pos] != ',' || buffer[input_string_pos] != NULL || param >= num_params ) //token terminates on a comma, or the end of the string
			{
				token[token_pos] = str[input_string_pos]; //store the variable into a new token
				++token_pos;
			}
			int tval; //value of the param
			//first check the boolean types:
			if ( strcmp(token,"true") ) tval = 1;
			else if ( strcmp(token,"T") ) tval = 1;
			else if ( strcmp(token,"false") ) tval = 0;
			else if ( strcmp(token,"F") ) tval = 0;
			else //literals
			{
				tval = atof(token);
				
			}
			//push the token value onto the stack
			stack[SP] = tval; 
		
			//now out stack looks like:
			
			//: PARAMn where n is the loop iteration
			//: PARAMn where n is the loop iteration
			//: PARAMn where n is the loop iteration
			//: INSTRUCTION
			
			++SP; //this is why the stack size must be +1 larger than the3 total number of instructions and
			//params that it can hold. 
			++current_param;
			
		} //repeat this until we are out of params
		
	}
	
	void getVarValue(int str)
	{
		variables[VP] = atof(str);
		++VP;
	}
	
	void execute()
	{
		int reg_ptr = 0; //read the stack starting here, until we reach TOP.
		int args[MAX_ARGS];
		//evaluate the instruction:
		int instr = stack[reg_ptr];
		int current_arg = 0;
		int num_of_params = num_instruction_params(instr);
		while( num_of_params > 0 )
		{
			++reg_ptr;
			args[current_arg] = stack[reg_ptr];
		}
		switch(instr)
		{
			case NONE: 
				TraceError("STACK INSTRUCTION IS INVALID: ", instr); break;
			case WARP: 
			{
				Link->Warp(args[0],args[1]); 
				if ( log_actions ) TraceError("Cheat System Warped Link to dmap,screen:",args[0],args[1]);
				break;
			}
			case POS: 
			{
				Link->X = args[0];
				Link->X = args[1];
				if ( log_actions ) TraceError("Cheat System repositioned Link to X,Y:",args[0],args[1]);
				break;
			}
			
			case MOVEX:
			{
				Link->X += args[0];
				if ( log_actions ) TraceError("Cheat system moved Link on his X axis by: ", args[0]);
				break, 
			}
			case MOVEY: 
			{
				Link->Y += args[0];
				if ( log_actions ) TraceError("Cheat system moved Link on his Y axis by", args[0]);
				break, 
			}
			case REFILLHP: 
			{
				Link->HP =  Link->MaxHP;
				if ( log_actions ) TraceError("Cheat system refilled Link's HP to", Link->MaxHP);
				break, 
			}
			case REFILLMP: 
			{
				Link->MP =  Link->MaxMP;
				if ( log_actions ) TraceError("Cheat system refilled Link's MP to", Link->MaxHP);
				break, 
			}
			case REFILLCTR: 
			{
				Game->Counter[args[0]] =  Game->MCounter[args[0]];
				if ( log_actions ) TraceError("Cheat system refilled Counter", args[0]);
				break, 
			}
			case MAXHP:
			{
				Game->MCounter[CR_HP] = args[0];
				if ( log_actions ) TraceError("Cheat system set Link's Max HP to:",args[0]);
				break, 
			}
			case MAXMP:
			{
				Game->MCounter[CR_MP] = args[0];
				if ( log_actions ) TraceError("Cheat system set Link's Max MP to:",args[0]);
				break, 
			}
			case MAXCTR:
			{
				Game->Counter[args[0]] = args[1];
				if ( log_actions ) TraceError("Cheat system refilled Counter (id, amount):",args[0],args[1]);
				break, 
			}
			
			case INVINCIBLE
			{
				if ( args[0] )
				{
					Link->Invisible = true;
					if ( log_actions ) TraceErrorS("Cheat system set Link's Invisibility state to ","true");
					break, 
				}
				else
				{
					Link->Invisible = false;
					if ( log_actions ) TraceErrorS("Cheat system set Link's Invisibility state to ","false");
					break, 
					
				}
				
			}
			case LINKITEM: 
			{
				if ( args[1] )
				{
					Link->Item[args[0]] = true;
					if ( log_actions ) TraceErrorVS("Cheat system set Link's Inventory Item to (item, state)","true");
					break, 
				}
				else
				{
					Link->Item[args[0]] = false;
					if ( log_actions ) TraceErrorVS("Cheat system set Link's Inventory Item to (item, state)","false");
					break, 
					
				}
			}
			default: 
			{
				
				TraceError("Invalid instruction passed to stack",instr); 
				break;
			}
			
			
		}
		///-----later, we'll add this: //pop everything off of the stack
		//just wipe the stack for now, as we only support one command at this time
		for ( int q = 0; q < 3; ++q ) stack[q] = 0; 
		SP = 0;
		
		
	}
		
	void run()
	{
	
		
		
	}
}

global script test
{
	void run()
	{
		while(1)
		{
			debugshell.process();
			Waitdraw(); 
			Waitframe();
		}
		
	}
}