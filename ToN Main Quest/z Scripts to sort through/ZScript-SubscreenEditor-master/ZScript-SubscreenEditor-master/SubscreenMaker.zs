#option SHORT_CIRCUIT on
#option HEADER_GUARD on
#include "std.zh"
#include "VenrobSubscreen.zh"
#include "VenrobCursor.zh"
#include "SubscreenMakerGUI.zs"
#include "VenrobBitmaps.zh"

namespace Venrob::SubscreenEditor
{
	using namespace Venrob::Subscreen;
	using namespace Venrob::Subscreen::Internal;
	using namespace Venrob::BitmapRental;
	
	untyped SubEditorData[MAX_INT] = {0, 0, 0, 0, false, false, false, false, false, false, KEY_ENTER, KEY_ESC, 0, 0, 0, NULL, 0, 0, false};
	enum
	{
		SED_HIGHLIGHTED,
		SED_DRAGGING,
		SED_ACTIVE_PANE,
		SED_PANE_MENU_TYPE,
		SED_LCLICKED,
		SED_RCLICKED,
		SED_MCLICKED,
		SED_LCLICKING,
		SED_RCLICKING,
		SED_MCLICKING,
		SED_DEFAULTBTN,
		SED_CANCELBTN,
		SED_LASTMOUSE_X,
		SED_LASTMOUSE_Y,
		SED_GUISTATE,
		SED_GUI_BMP,
		SED_QUEUED_DELETION,
		SED_GLOBAL_TIMER,
		SED_JUST_CLONED
	};
	
	untyped sys_settings[MAX_INT];
	enum sysSetting
	{
		SSET_CURSORTILE, //if >0, tile to draw for cursor
		SSET_CURSOR_VER, //if SED_CURSORTILE <= 0, then which packaged cursor style to draw
		SSET_DELWARN,
		SSET_MAX
	};
	
	global script Init //start
	{
		void run()
		{
			Subscreen::init();
			//loadClassicPal(PAL);
			loadClassicDarkPal(PAL);
			//sys_settings[SSET_CURSORTILE] = 10;
			untyped buf[MAX_MODULE_SIZE];
			MakeBGColorModule(buf);
			add_active_module(buf);
			buf[P1] = DGRAY;
			add_passive_module(buf);
			MakePassiveSubscreen(buf);
			add_active_module(buf);
			//
			MakeSelectableItemID(buf);
			buf[P1] = I_CANDLE1;
			buf[P2] = 0;
			buf[P3+DIR_UP] = -1;
			buf[P3+DIR_DOWN] = -1;
			buf[P3+DIR_LEFT] = 3;
			buf[P3+DIR_RIGHT] = 1;
			buf[M_X] = 32;
			buf[M_Y] = 80;
			add_active_module(buf);
			//
			MakeSelectableItemClass(buf);
			buf[P1] = IC_SWORD;
			buf[P2] = 1;
			buf[P3+DIR_UP] = -1;
			buf[P3+DIR_DOWN] = -1;
			buf[P3+DIR_LEFT] = 0;
			buf[P3+DIR_RIGHT] = 2;
			buf[M_X] = 48;
			buf[M_Y] = 80;
			add_active_module(buf);
			//
			MakeSelectableItemClass(buf);
			buf[P1] = IC_ARROW;
			buf[P2] = 2;
			buf[P3+DIR_UP] = -1;
			buf[P3+DIR_DOWN] = -1;
			buf[P3+DIR_LEFT] = 1;
			buf[P3+DIR_RIGHT] = 3;
			buf[M_X] = 64;
			buf[M_Y] = 80;
			add_active_module(buf);
			//
			MakeSelectableItemClass(buf);
			buf[P1] = IC_BRANG;
			buf[P2] = 3;
			buf[P3+DIR_UP] = -1;
			buf[P3+DIR_DOWN] = -1;
			buf[P3+DIR_LEFT] = 2;
			buf[P3+DIR_RIGHT] = 0;
			buf[M_X] = 80;
			buf[M_Y] = 80;
			add_active_module(buf);
			//
			MakeBButtonItem(buf);
			buf[M_X] = 128;
			buf[M_Y] = 24;
			add_passive_module(buf);
			MakeAButtonItem(buf);
			buf[M_X] = 144;
			buf[M_Y] = 24;
			add_passive_module(buf);
			for(int q = 0; q < CR_SCRIPT1; ++q) Game->Counter[q] = Game->MCounter[q] = MAX_COUNTER;
		}
	} //end Init
	
	global script onF6 //start
	{
		void run()
		{
			if(!DEBUG && DIALOG::yesno_dlg("Exit Game","Would you like to save+exit, or just exit?","Save","Quit"))
			{
				Game->SaveAndQuit();
			}
			Game->End();
		}
	} //end
	
	DEFINE PASSIVE_EDITOR_TOP = ((224/2)-(56/2))-56;
	global script Active //Subscreen Editor
	{
		void run()
		{
			Game->DisableActiveSubscreen = true;
			TypeAString::setEnterEndsTyping(false); TypeAString::setAllowBackspaceDelete(true); TypeAString::setOverflowWraps(false);
			int editing = 1;
			Input->DisableKey[KEY_ESC] = editing!=0;
			while(true)
			{
				switch(editing)
				{
					case 0:
						if(Input->Press[CB_START])
						{
							runActiveSubscreen();
						}
						runPassiveSubscreen();
						break;
					case 1:
						runFauxActiveSubscreen();
						if(SubEditorData[SED_QUEUED_DELETION])
						{
							if(SubEditorData[SED_QUEUED_DELETION]<0) //passive
							{
								remove_passive_module(-SubEditorData[SED_QUEUED_DELETION]);
							}
							else //active
							{
								remove_active_module(SubEditorData[SED_QUEUED_DELETION]);
							}
							SubEditorData[SED_QUEUED_DELETION]=0;
						}
						KillButtons();
						break;
					case 2:
						runFauxPassiveSubscreen(true);
						runPreparedSelector(false);
						ColorScreen(PAL[COL_NULL], true);
						getSubscreenBitmap(false)->Blit(7, RT_SCREEN, 0, 0, 256, 56, 0, PASSIVE_EDITOR_TOP, 256, 56, 0, 0, 0, 0, 0, true);
						clearPassive1frame();
						KillButtons();
						break;
				}
				if(handle_data_pane(editing==1)) continue;
				if(editing) DIALOG::runGUI(editing==1);
				if(Input->ReadKey[KEY_P])
				{
					++editing;
					editing %= 3;
					Input->DisableKey[KEY_ESC] = editing!=0;
				}
				subscr_Waitframe();
			}
		}
	}

	void runFauxActiveSubscreen()
	{
		runFauxPassiveSubscreen(false);
		for(int q = 1; q < g_arr[NUM_ACTIVE_MODULES] ; ++q)
		{
			untyped buf[MAX_MODULE_SIZE];
			saveModule(buf, q, true);
			runFauxModule(q, buf, true, true);
		}
		runPreparedSelector(true);
		getSubscreenBitmap(true)->Blit(7, RT_SCREEN, 0, 0, 256, 224, 0, -56, 256, 224, 0, 0, 0, 0, 0, true);
		activetimers();
		clearActive1frame();
	}

	void runFauxPassiveSubscreen(bool interactive)
	{
		++g_arr[PASSIVE_TIMER];
		g_arr[PASSIVE_TIMER]%=3600;
		for(int q = 1; q < g_arr[NUM_PASSIVE_MODULES] ; ++q)
		{
			untyped buf[MAX_MODULE_SIZE];
			saveModule(buf, q, false);
			runFauxModule(q, buf, false, interactive);
		}
		runPreparedSelector(false);
	}

	void runFauxModule(int mod_indx, untyped module_arr, bool active, bool interactive)
	{
		if(active) interactive = true;
		bitmap bit = getSubscreenBitmap(active);
		switch(module_arr[M_TYPE])
		{
			case MODULE_TYPE_BGCOLOR:
			{
				//Cannot drag
				if(active)
				{
					bit->Rectangle(module_arr[M_LAYER], 0, 0, 256, 224, module_arr[P1], 1, 0, 0, 0, true, OP_OPAQUE);
					if(interactive)
						editorCursor(module_arr[M_LAYER], 0, 0, 255, 223, mod_indx, active, true);
				}
				else
				{
					bit->Rectangle(module_arr[M_LAYER], 0, 0, 256, 56, module_arr[P1], 1, 0, 0, 0, true, OP_OPAQUE);
					if(interactive)
						editorCursor(module_arr[M_LAYER], 0, 0, 254, 55, mod_indx, active, true);
				}
				break;
			}
			
			case MODULE_TYPE_ABUTTONITEM:
			case MODULE_TYPE_BBUTTONITEM:
			{
				int itmid = module_arr[M_TYPE] == MODULE_TYPE_ABUTTONITEM ? I_SWORD1 : I_CANDLE1;
				itemdata id = Game->LoadItemData(itmid);
				int frm = Div(g_arr[active ? ACTIVE_TIMER : PASSIVE_TIMER] % (Max(1,id->ASpeed*id->AFrames)),Max(1,id->ASpeed));
				if(interactive) handleDragging(module_arr, mod_indx, active);
				bit->FastTile(module_arr[M_LAYER], module_arr[M_X], module_arr[M_Y], id->Tile + frm, id->CSet, OP_OPAQUE);
				if(interactive)
				{
					bool hit = activeData[STTNG_FLAGS1]&FLAG_ITEMS_USE_HITBOX_FOR_SELECTOR;
					unless(id->HitWidth) id->HitWidth = 16;
					unless(id->HitHeight) id->HitHeight = 16;
					unless(id->TileWidth) id->TileWidth = 1;
					unless(id->TileHeight) id->TileHeight = 1;
					int tx = module_arr[M_X] + (hit ? id->HitXOffset : id->DrawXOffset),
						ty = module_arr[M_Y] + (hit ? id->HitYOffset : id->DrawYOffset),
						twid = (hit ? id->HitWidth : id->TileWidth*16),
						thei = (hit ? id->HitHeight : id->TileHeight*16);
					editorCursor(module_arr[M_LAYER], tx, ty, twid, thei, mod_indx, active);
				}
				break;
			}
			
			case MODULE_TYPE_SELECTABLE_ITEM_ID:
			case MODULE_TYPE_SELECTABLE_ITEM_CLASS:
			{
				unless(active) break; //Not allowed on passive
				bool class = (module_arr[M_TYPE]==MODULE_TYPE_SELECTABLE_ITEM_CLASS);
				int itmid = (class?(get_item_of_class(module_arr[P1])):(module_arr[P1]));
				if(itmid < 0) itmid = class ? get_item_of_class(module_arr[P1], true) : 0;
				if(itmid < 0) itmid = 0;
				
				itemdata id = Game->LoadItemData(itmid);
				int frm = Div(g_arr[ACTIVE_TIMER] % (Max(1,id->ASpeed*id->AFrames)),Max(1,id->ASpeed));
				if(interactive) handleDragging(module_arr, mod_indx, active);
				bit->FastTile(module_arr[M_LAYER], module_arr[M_X], module_arr[M_Y], id->Tile + frm, id->CSet, OP_OPAQUE);
				if(interactive)
				{
					bool hit = activeData[STTNG_FLAGS1]&FLAG_ITEMS_USE_HITBOX_FOR_SELECTOR;
					unless(id->HitWidth) id->HitWidth = 16;
					unless(id->HitHeight) id->HitHeight = 16;
					unless(id->TileWidth) id->TileWidth = 1;
					unless(id->TileHeight) id->TileHeight = 1;
					int tx = module_arr[M_X] + (hit ? id->HitXOffset : id->DrawXOffset),
					    ty = module_arr[M_Y] + (hit ? id->HitYOffset : id->DrawYOffset),
						twid = (hit ? id->HitWidth : id->TileWidth*16),
						thei = (hit ? id->HitHeight : id->TileHeight*16);
					editorCursor(module_arr[M_LAYER], tx, ty, twid, thei, mod_indx, active);
				}
				break;
			}
			
			case MODULE_TYPE_PASSIVESUBSCREEN:
			{
				if(interactive) handleDragging(module_arr, mod_indx, active);
				bit->BlitTo(module_arr[M_LAYER], getSubscreenBitmap(false), 0, 0, 256, 56, module_arr[M_X], module_arr[M_Y], 256, 56, 0, 0, 0, 0, 0, true);
				if(interactive)
				{
					editorCursor(module_arr[M_LAYER], module_arr[M_X], module_arr[M_Y], 255, 55, mod_indx, active, true);
				}
				break;
			}
			
			//case :
		}
	}
	
	void handleDragging(untyped module_arr, int mod_indx, bool active)
	{
		if(SubEditorData[SED_DRAGGING] == mod_indx)
		{
			clearPreparedSelector();
			int dx = Input->Mouse[MOUSE_X] - SubEditorData[SED_LASTMOUSE_X],
				dy = Input->Mouse[MOUSE_Y] - SubEditorData[SED_LASTMOUSE_Y];
			module_arr[M_X] = VBound(module_arr[M_X]+dx, max_x(module_arr), min_x(module_arr));
			module_arr[M_Y] = VBound(module_arr[M_Y]+dy, max_y(module_arr, active), min_y(module_arr));
			setModX(mod_indx, active, module_arr[M_X]);
			setModY(mod_indx, active, module_arr[M_Y]);
		}
		else if(SubEditorData[SED_HIGHLIGHTED] == mod_indx)
		{
			if(Input->Press[CB_UP])
			{
				module_arr[M_Y] = VBound(module_arr[M_Y]-1, max_y(module_arr, active), min_y(module_arr));
				setModY(mod_indx, active, module_arr[M_Y]);
			}
			else if(Input->Press[CB_DOWN])
			{
				module_arr[M_Y] = VBound(module_arr[M_Y]+1, max_y(module_arr, active), min_y(module_arr));
				setModY(mod_indx, active, module_arr[M_Y]);
			}
			if(Input->Press[CB_LEFT])
			{
				module_arr[M_X] = VBound(module_arr[M_X]-1, max_x(module_arr), min_x(module_arr));
				setModX(mod_indx, active, module_arr[M_X]);
			}
			else if(Input->Press[CB_RIGHT])
			{
				module_arr[M_X] = VBound(module_arr[M_X]+1, max_x(module_arr), min_x(module_arr));
				setModX(mod_indx, active, module_arr[M_X]);
			}
		}
	}
	
	void editorCursor(int layer, int x, int y, int wid, int hei, int mod_indx, bool active)
	{
		editorCursor(layer, x, y, wid, hei, mod_indx, active, false);
	}
	void editorCursor(int layer, int x, int y, int wid, int hei, int mod_indx, bool active, bool overlapBorder)
	{
		if(SubEditorData[SED_ACTIVE_PANE]) return; //A GUI pane is open, halt all other cursor action
		//bool overlapBorder = (wid >= 16*3 || hei >= 16*3); //Overlap the border on large (3 tile wide/tall or larger) objects
		int sx = overlapBorder ? x+1 : x, sy = overlapBorder ? y+1 : y, swid = overlapBorder ? wid-2 : wid, shei = overlapBorder ? hei-2 : hei;
		bool onGUI = DIALOG::isHoveringGUI();
		bool isHovering = !onGUI && (active ? CursorBox(x, y, x+wid, y+hei, 0, 56) : CursorBox(x, y, x+wid, y+hei, 0, PASSIVE_EDITOR_TOP - 56));
		bool isDragging = SubEditorData[SED_DRAGGING] == mod_indx;
		if(isHovering && SubEditorData[SED_LCLICKED]) //Clicking
		{
			SubEditorData[SED_DRAGGING] = mod_indx;
			if(SubEditorData[SED_HIGHLIGHTED] != mod_indx)
			{
				SubEditorData[SED_HIGHLIGHTED] = mod_indx;
				return;
			}
		}
		if(SubEditorData[SED_HIGHLIGHTED] == mod_indx)
		{
			if(DIALOG::keyproc(KEY_DEL) || DIALOG::keyproc(KEY_DEL_PAD))
			{
				if(mod_indx>1 && (!sys_settings[SSET_DELWARN] || DIALOG::yesno_dlg("Are you sure you want to delete this?")))
				{
					SubEditorData[SED_QUEUED_DELETION] = mod_indx;
					SubEditorData[SED_HIGHLIGHTED] = 0;
					if(isDragging) SubEditorData[SED_DRAGGING] = 0;
				}
			}
			if(!isDragging && isHovering)
			{
				clearPreparedSelector();
				if(SubEditorData[SED_RCLICKED]) //RClick
				{
					open_data_pane(mod_indx, active);
					SubEditorData[SED_RCLICKED] = false;
				}
			}
			else if(SubEditorData[SED_LCLICKED] && !onGUI) //Clicked off
			{
				SubEditorData[SED_HIGHLIGHTED] = 0;
				return;
			}
			DrawSelector(layer, sx, sy, swid, shei, active, false, SEL_RECTANGLE, PAL[COL_HIGHLIGHT]);
		}
		else if(isHovering)
			DrawSelector(layer, sx, sy, swid, shei, active, true, SEL_RECTANGLE, PAL[COL_CURSOR]);
	}
	
	enum
	{
		PANE_T_ACTIVE, PANE_T_PASSIVE, PANE_T_SYSTEM
	};
	
	enum SystemPane
	{
		DLG_LOAD = 1, DLG_SAVEAS, DLG_THEMES, DLG_OPTIONS, DLG_NEWOBJ, DLG_SYSTEM
	};
	
	void open_data_pane(int indx, bool active)
	{
		open_data_pane(indx, active ? PANE_T_ACTIVE : PANE_T_PASSIVE);
	}
	
	void open_data_pane(int indx, int panetype)
	{
		if(SubEditorData[SED_ACTIVE_PANE]) return;
		SubEditorData[SED_ACTIVE_PANE] = indx;
		SubEditorData[SED_PANE_MENU_TYPE] = panetype;
	}
	
	void close_data_pane()
	{
		SubEditorData[SED_ACTIVE_PANE] = NULL;
		SubEditorData[SED_PANE_MENU_TYPE] = false;
	}
	
	bool handle_data_pane(bool active)
	{
		int pane = SubEditorData[SED_ACTIVE_PANE];
		unless(pane) return false;
		int panetype = SubEditorData[SED_PANE_MENU_TYPE];
		untyped module_arr[MAX_MODULE_SIZE];
		close_data_pane(); //here, so that the pane can open another from inside.
		switch(panetype)
		{
			case PANE_T_ACTIVE:
				saveModule(module_arr, pane, true);
				DIALOG::editObj(module_arr, pane, true);
				break;
			
			case PANE_T_PASSIVE:
				saveModule(module_arr, pane, false);
				DIALOG::editObj(module_arr, pane, false);
				break;
			
			case PANE_T_SYSTEM:
				switch(pane)
				{
					//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! UNFINISHED DIALOGUES !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!//
					case DLG_LOAD:
					case DLG_SAVEAS:
						DIALOG::msg_dlg("WIP", "This feature is still under construction. Please wait for an update.");
						break;
						
					case DLG_NEWOBJ:
						DIALOG::new_obj(active);
						break;
					case DLG_SYSTEM:
						DIALOG::sys_dlg();
						break;
					case DLG_OPTIONS:
						DIALOG::opt_dlg(active);
						break;
					case DLG_THEMES:
						DIALOG::editThemes();
						break;
						
					default:
						if(DEBUG) error("Bad SYSTEM type pane opened!");
						break;
				}
				break;
		}
		//close_data_pane();
		return true;
	}
	
	void subscr_Waitframe()
	{
		handleEndFrame();
		Waitframe();
		handleStartFrame();
	}
	
	void handleStartFrame()
	{
		++SubEditorData[SED_GLOBAL_TIMER];
		SubEditorData[SED_GLOBAL_TIMER]%=3600;
		SubEditorData[SED_LCLICKED] = Input->Mouse[MOUSE_LEFT] && !SubEditorData[SED_LCLICKING];
		SubEditorData[SED_RCLICKED] = Input->Mouse[MOUSE_RIGHT] && !SubEditorData[SED_RCLICKING];
		SubEditorData[SED_MCLICKED] = Input->Mouse[MOUSE_MIDDLE] && !SubEditorData[SED_MCLICKING];
		SubEditorData[SED_LCLICKING] = Input->Mouse[MOUSE_LEFT];
		SubEditorData[SED_RCLICKING] = Input->Mouse[MOUSE_RIGHT];
		SubEditorData[SED_MCLICKING] = Input->Mouse[MOUSE_MIDDLE];
		unless(Input->Mouse[MOUSE_LEFT]) SubEditorData[SED_DRAGGING] = 0;
		pollKeys();
	}
	
	void handleEndFrame()
	{
		SubEditorData[SED_LASTMOUSE_X] = Input->Mouse[MOUSE_X];
		SubEditorData[SED_LASTMOUSE_Y] = Input->Mouse[MOUSE_Y];
		if(sys_settings[SSET_CURSORTILE])
		{
			Screen->FastTile(7, Input->Mouse[MOUSE_X], Input->Mouse[MOUSE_Y], sys_settings[SSET_CURSORTILE], 0, OP_OPAQUE);
		}
		else
		{
			DrawCursor(sys_settings[SSET_CURSOR_VER], Input->Mouse[MOUSE_X], Input->Mouse[MOUSE_Y]);
		}
		
		if(Input->Key[KEY_G])
		{
			if(PressShift())
			{
				for(int x = 0; x <= 256; x += 16)
				{
					Screen->Line(7, x, -56, x, 176, PAL[COL_HIGHLIGHT], 1, 0, 0, 0, OP_OPAQUE);
					Screen->Line(7, x-1, -56, x-1, 176, PAL[COL_HIGHLIGHT], 1, 0, 0, 0, OP_OPAQUE);
				}
				for(int y = -56; y <= 168; y += 16)
				{
					Screen->Line(7, 0, y, 256, y, PAL[COL_HIGHLIGHT], 1, 0, 0, 0, OP_OPAQUE);
					Screen->Line(7, 0, y-1, 256, y-1, PAL[COL_HIGHLIGHT], 1, 0, 0, 0, OP_OPAQUE);
				}
			}
			else
			{
				Screen->Line(7, 127, -56, 127, 176, PAL[COL_HIGHLIGHT], 1, 0, 0, 0, OP_OPAQUE);
				Screen->Line(7, 128, -56, 128, 176, PAL[COL_HIGHLIGHT], 1, 0, 0, 0, OP_OPAQUE);
				Screen->Line(7, 0, 56, 256, 56, PAL[COL_HIGHLIGHT], 1, 0, 0, 0, OP_OPAQUE);
				Screen->Line(7, 0, 55, 256, 55, PAL[COL_HIGHLIGHT], 1, 0, 0, 0, OP_OPAQUE);
			}
		}
	}
	enum CursorType
	{
		CT_BASIC, CT_STICK
	};
	void DrawCursor(CursorType type, int x, int y)
	{
		switch(type)
		{
			case CT_STICK:
				Screen->Line(7, x, y, x+3, y, PAL[COL_CURSOR], 1, 0, 0, 0, OP_OPAQUE);
				Screen->Line(7, x, y, x, y+3, PAL[COL_CURSOR], 1, 0, 0, 0, OP_OPAQUE);
				Screen->Line(7, x, y, x+4, y+4, PAL[COL_CURSOR], 1, 0, 0, 0, OP_OPAQUE);
				break;
			case CT_BASIC:
			default:
				Screen->Triangle(7, x, y, x+4, y, x, y+4, 0, 0, PAL[COL_CURSOR], 0, 0, 0);
				Screen->Line(7, x, y, x+5, y+5, PAL[COL_CURSOR], 1, 0, 0, 0, OP_OPAQUE);
				break;
		}
	}
	
	void KillClicks()
	{
		SubEditorData[SED_LCLICKED] = false;
		SubEditorData[SED_RCLICKED] = false;
		SubEditorData[SED_MCLICKED] = false;
		SubEditorData[SED_LCLICKING] = false;
		SubEditorData[SED_RCLICKING] = false;
		SubEditorData[SED_MCLICKING] = false;
		Input->Mouse[MOUSE_LEFT] = false;
		Input->Mouse[MOUSE_RIGHT] = false;
		Input->Mouse[MOUSE_MIDDLE] = false;
	}
	
	//start module_limits
	int max_x(untyped module_arr)
	{
		itemdata id;
		switch(module_arr[M_TYPE])
		{
			case MODULE_TYPE_ABUTTONITEM:
			case MODULE_TYPE_BBUTTONITEM:
			case MODULE_TYPE_SELECTABLE_ITEM_ID:
			case MODULE_TYPE_SELECTABLE_ITEM_CLASS:
				int itm = (module_arr[M_TYPE]==MODULE_TYPE_ABUTTONITEM?I_SWORD1:(module_arr[M_TYPE]==MODULE_TYPE_BBUTTONITEM?I_CANDLE1:(module_arr[M_TYPE]==MODULE_TYPE_SELECTABLE_ITEM_ID?module_arr[P1]:get_item_of_class(module_arr[P1]))));
				unless(itm > 0) return 256-16;
				itemdata id = Game->LoadItemData(itm);
				//
				bool hit = activeData[STTNG_FLAGS1]&FLAG_ITEMS_USE_HITBOX_FOR_SELECTOR;
				unless(id->HitWidth) id->HitWidth = 16;
				unless(id->TileWidth) id->TileWidth = 1;
				int xoffs = (hit ? id->HitXOffset : id->DrawXOffset),
					twid = (hit ? id->HitWidth : id->TileWidth*16);
				return 256 - xoffs - twid;
			case MODULE_TYPE_PASSIVESUBSCREEN:
				return 0;
			case MODULE_TYPE_BGCOLOR:
				return 0;
		}
		return 256-16;
	}
	
	int min_x(untyped module_arr)
	{
		itemdata id;
		switch(module_arr[M_TYPE])
		{
			case MODULE_TYPE_ABUTTONITEM:
			case MODULE_TYPE_BBUTTONITEM:
			case MODULE_TYPE_SELECTABLE_ITEM_ID:
			case MODULE_TYPE_SELECTABLE_ITEM_CLASS:
				int itm = (module_arr[M_TYPE]==MODULE_TYPE_ABUTTONITEM?I_SWORD1:(module_arr[M_TYPE]==MODULE_TYPE_BBUTTONITEM?I_CANDLE1:(module_arr[M_TYPE]==MODULE_TYPE_SELECTABLE_ITEM_ID?module_arr[P1]:get_item_of_class(module_arr[P1]))));
				unless(itm > 0) return 0;
				itemdata id = Game->LoadItemData(itm);
				//
				bool hit = activeData[STTNG_FLAGS1]&FLAG_ITEMS_USE_HITBOX_FOR_SELECTOR;
				int xoffs = (hit ? id->HitXOffset : id->DrawXOffset);
				return 0 - xoffs;
			case MODULE_TYPE_PASSIVESUBSCREEN:
				return 0;
			case MODULE_TYPE_BGCOLOR:
				return 0;
		}
		return 0;
	}
	
	int max_y(untyped module_arr, bool active)
	{
		itemdata id;
		switch(module_arr[M_TYPE])
		{
			case MODULE_TYPE_ABUTTONITEM:
			case MODULE_TYPE_BBUTTONITEM:
			case MODULE_TYPE_SELECTABLE_ITEM_ID:
			case MODULE_TYPE_SELECTABLE_ITEM_CLASS:
				int itm = (module_arr[M_TYPE]==MODULE_TYPE_ABUTTONITEM?I_SWORD1:(module_arr[M_TYPE]==MODULE_TYPE_BBUTTONITEM?I_CANDLE1:(module_arr[M_TYPE]==MODULE_TYPE_SELECTABLE_ITEM_ID?module_arr[P1]:get_item_of_class(module_arr[P1]))));
				unless(itm > 0) return (active ? 224 : 56)-16;
				itemdata id = Game->LoadItemData(itm);
				//
				bool hit = activeData[STTNG_FLAGS1]&FLAG_ITEMS_USE_HITBOX_FOR_SELECTOR;
				unless(id->HitHeight) id->HitHeight = 16;
				unless(id->TileHeight) id->TileHeight = 1;
				int yoffs = (hit ? id->HitYOffset : id->DrawYOffset),
					thei = (hit ? id->HitHeight : id->TileHeight*16);
				return (active ? 224 : 56) - yoffs - thei;
			case MODULE_TYPE_PASSIVESUBSCREEN:
				return 224-56;
			case MODULE_TYPE_BGCOLOR:
				return 0;
		}
		return (active ? 224 : 56)-16;
	}
	
	int min_y(untyped module_arr)
	{
		itemdata id;
		switch(module_arr[M_TYPE])
		{
			case MODULE_TYPE_ABUTTONITEM:
			case MODULE_TYPE_BBUTTONITEM:
			case MODULE_TYPE_SELECTABLE_ITEM_ID:
			case MODULE_TYPE_SELECTABLE_ITEM_CLASS:
				int itm = (module_arr[M_TYPE]==MODULE_TYPE_ABUTTONITEM?I_SWORD1:(module_arr[M_TYPE]==MODULE_TYPE_BBUTTONITEM?I_CANDLE1:(module_arr[M_TYPE]==MODULE_TYPE_SELECTABLE_ITEM_ID?module_arr[P1]:get_item_of_class(module_arr[P1]))));
				unless(itm > 0) return 0;
				itemdata id = Game->LoadItemData(itm);
				//
				bool hit = activeData[STTNG_FLAGS1]&FLAG_ITEMS_USE_HITBOX_FOR_SELECTOR;
				int yoffs = (hit ? id->HitYOffset : id->DrawYOffset);
				return 0 - yoffs;
			case MODULE_TYPE_PASSIVESUBSCREEN:
				return 0;
			case MODULE_TYPE_BGCOLOR:
				return 0;
		}
		return 0;
	}
	//end module_limits

	bitmap getGUIBitmap()
	{
		unless((<bitmap>SubEditorData[SED_GUI_BMP])->isAllocated()) SubEditorData[SED_GUI_BMP] = Game->AllocateBitmap();
		unless((<bitmap>SubEditorData[SED_GUI_BMP])->isValid()) generate((<bitmap>SubEditorData[SED_GUI_BMP]), DIALOG::MAIN_GUI_WIDTH, DIALOG::MAIN_GUI_HEIGHT);
		return (<bitmap>SubEditorData[SED_GUI_BMP]);
	}
}