//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Global Active ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

// clang-format off
@Author("Deathrider365")
global script Init {
   // clang-format off
   
	void run() {
      giveStartingCrap();
	}
}

// clang-format off
@Author("EmilyV99, Moosh, Deathrider365")
global script GlobalScripts {
   // clang-format off
   
	void run() {
      if (DEBUG)
         debug();
         
      
      int map = -1, dmap = -1, screen = -1;
      
      LinkMovement_Init();
      StartGhostZH();
      DifficultyGlobal_Init();
      
      Game->MaxLWeapons(1024);
      Game->MaxEWeapons(1024);
      
      mapdata mapData[6];
      
      int footprintArray[3] = {1, 0, 0};
		
      Hero->HurtSound = 0;
      
      while(true) {
         gameframe = (gameframe + 1) % 3600;
         
         checkDungeon();
         
         LinkMovement_Update1();
         UpdateGhostZH1();
         
         DifficultyGlobal_Update();
         DifficultyGlobal_EnemyUpdate();
         
         setupTransparentLayers();
         Waitdraw();
         drawRadialTransparency(mapData);
         
         checkFootprints(footprintArray);
         
         if (map != Game->GetCurMap() || screen != Game->GetCurScreen()) {
            map = Game->GetCurMap();
            screen = Game->GetCurScreen();
            onScreenChange(mapData);
         }
         
         if (dmap != Game->GetCurDMap()) {
            dmap = Game->GetCurDMap();
            onDMapChange();
         }
         
         LinkMovement_Update2();
         UpdateGhostZH2();
         
         Waitframe();
      }
	}
	
   void setupTransparentLayers() {
      int layers = getTransLayers(Game->GetCurDMap(), Game->GetCurScreen());
      
      for (int l = 1; l < 6; ++l) {
         unless(layers & (1b << (l - 1)))
            continue;
         
         Screen->LayerInvisible[l] = (HeroIsScrollingOrWarping() || disableTrans) ? false : true;
      }
      
      return;
   }
   
   void drawRadialTransparency(mapdata mapData) {
      CONFIG TRANS_RADIUS = 36;
      
      unless(IsValidArray(mapData))
         return;
         
      int layers = getTransLayers(Game->GetCurDMap(), Game->GetCurScreen());
      
      for (int l = 1; l < 6; ++l) {
         unless(layers & (1b << (l - 1)))
            continue;
         unless (mapData[l])
            continue;
         
         overheadBitmaps[l]->Clear(0);
         
         for (int q = 0; q < 176; ++q) {
            if (HeroIsScrollingOrWarping())
               overheadBitmaps[l]->FastCombo(l, ComboX(q) + Game->Scrolling[SCROLL_NX], ComboY(q) + Game->Scrolling[SCROLL_NY], mapData[l]->ComboD[q], mapData[l]->ComboC[q], OP_OPAQUE);
            else
               overheadBitmaps[l]->FastCombo(l, ComboX(q), ComboY(q), mapData[l]->ComboD[q], mapData[l]->ComboC[q], OP_OPAQUE);
         }
         
         if (HeroIsScrollingOrWarping())
            overheadBitmaps[l]->Circle(l, Hero->X + 8 + Game->Scrolling[SCROLL_NX], Hero->Y + 8 + Game->Scrolling[SCROLL_NY], TRANS_RADIUS, 0, 1, 0, 0, 0, true, OP_OPAQUE);
         else
            overheadBitmaps[l]->Circle(l, Hero->X + 8, Hero->Y + 8, TRANS_RADIUS, 0, 1, 0, 0, 0, true, OP_OPAQUE);
         
         for (int q = 0; q < 176; ++q) {
            if (HeroIsScrollingOrWarping())
               Screen->FastCombo(l, ComboX(q) + Game->Scrolling[SCROLL_NX], ComboY(q) + Game->Scrolling[SCROLL_NY], mapData[l]->ComboD[q], mapData[l]->ComboC[q], OP_TRANS);
            else
               Screen->FastCombo(l, ComboX(q), ComboY(q), mapData[l]->ComboD[q], mapData[l]->ComboC[q], OP_TRANS);
         }
            
         overheadBitmaps[l]->Blit(l, -1, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
      }
   }
		
   void onScreenChange(mapdata mapData) {
      disableTrans = false;
      int layers = getTransLayers(Game->GetCurDMap(), Game->GetCurScreen());
      
      for (int l = 1; l < 6; ++l) {
         unless(overheadBitmaps[l]->isValid())
            overheadBitmaps[l] = create(256, 176);
            
         overheadBitmaps[l]->Clear(0);
            
         unless(layers & (1b << (l - 1)))
            continue;
         
         Screen->LayerInvisible[l] = true;
         
         mapData[l] = Game->LoadTempScreen(l);
      }
      
      if (Screen->Palette != lastPal) {
         lastPal = Screen->Palette;
         
         for (int i = 0; i <= MAX_USED_DMAP; ++i)
            Game->DMapPalette[i] = Screen->Palette;
      }
   }
	
   // 654321
   int getTransLayers(int dmap, int screen) {
      switch(dmap) {
         case 4:
            switch(screen) {
               case 0x26:
                  return 011000b;
               case 0x38:
               case 0x39:
                  return 001000b;
            }
            break;
         case 5:
            switch(screen) {
               case 0x1c:
               case 0x63:
                  return 000100;
            }
            break;
         case 6:
            switch(screen) {
               case 0x08:
               case 0x17:
                  return 000100;
            }
            break;
         case 15:
            switch(screen) {
               case 0x55:
                  return 001100;
            }
            break;
         case 21:
            switch(screen) {
               case 0x77:
                  return 000100;
            }
            break;
         case 31:
            switch(screen) {
               case 0x4a:
               case 0x59:
               case 0x5b:
               case 0x5d:
               case 0x7c:
               case 0x5D:
                  return 001000b;
            }
            break;
         case 32:
            switch(screen) {
               case 0x06:
                  return 011000b;
               case 0x07:
                  return 001100b;
            }
            break;
            break;
         case 34:
            switch(screen) {
               case 0x20:
               case 0x21:
                  return 011000b;
            }
            break;
         case 36:
            switch(screen) {
               case 0x76:
                  return 001000b;
            }
            break;
         case 43:
            switch(screen) {
               case 0x0F:
                  return 001000b;
            }
            break;
         case 47:
            switch(screen) {
               case 0x35:
                  return 000100b;
            }
            break;
      }
      return 0;
   }
	
   void checkFootprints(int footprints) {
      int fadeMult = getFadeMult();
      
      unless(fadeMult)
         fadeMult = 1;
      
      if (!HeroIsScrolling() && Hero->Action == LA_WALKING && ((footprints[1] == Hero->X && footprints[2] == Hero->Y) ? false : true)) {
         footprints[1] = Hero->X;
         footprints[2] = Hero->Y;
         
         unless (--footprints[0]) {	
            int pos = ComboAt(Link->X + 4, Link->Y + 4);
            int comboT = Screen->ComboT[pos]; 
            
            for (int i = 1; i < 3; ++i)
               if (Screen->LayerMap[i]) {
                  mapdata mapData = Game->LoadTempScreen(i);
                  
                  if (mapData->ComboD[pos])
                     comboT = mapData->ComboT[pos];
               }
            
            if (comboT == CT_FOOTPRINT)
               createFootprint(fadeMult);
               
            footprints[0] = 12;
         }
      }
   }
   
   int getFadeMult() {
      switch(Game->GetCurDMap()) {
         case 0:
            return .5;
         case 1:
            return 1;
         case 3:
            return 2;
         case 4:
            return 1;
         case 5...6:
            return 2;
         case 7:
            return .2;
         case 8:
            return 1;
         case 9:
            return .2;
         case 10...13:
            return 1;
         case 18...23:
            return 2;
      }
      
      return 0;
   }
	
   void createFootprint(int fadeMult) {
      if (int scr = CheckLWeaponScript("CustomSparkle")) {
         lweapon footprint = RunLWeaponScriptAt(LW_SCRIPT1, scr, Hero->X, Hero->Y, {SPR_FOOTSTEP, fadeMult});
         footprint->Behind = true;
         footprint->Dir = Hero->Dir;
         footprint->ScriptTile = TILE_INVIS;
         footprint->CollDetection = false;
      }	
   }
	
   void onDMapChange() {

   }
	
   void checkDungeon() {
      int level = Game->GetCurLevel();
      unless (Game->LItems[level] & LI_MAP) {
         Link->InputMap = false;
         Link->PressMap = false;
      }
   }
	
   void debug() {
      Game->Cheat = 4;
   }
}

// clang-format off
@Author("EmilyV99, Deathrider365")
global script OnLaunch {
   // clang-format off
   
   void run() {
      lastPal = -1;
      subscreenYOffset = -224;
      subscreenOpen = false;

      setGameOverMenu(C_TAN, C_BLACK, C_RED, MIDI_GAMEOVER);

      if (onContHP != 0) {
         Hero->HP = onContHP;
         Hero->MP = onContMP;	
      } else {
         Hero->HP = Hero->MaxHP;
         Hero->MP = Hero->MaxMP;		
      }		
   }
}

// clang-format off
@Author("Deathrider365")
global script onF6Menu {
   // clang-format off
   
   void run() {
      onContHP = Hero->HP;
      onContMP = Hero->MP;
      
      if (SizeOfArray(stolenLinkItems))
         for (int i = 0; i < SizeOfArray(stolenLinkItems); ++i)
            Hero->Item[stolenLinkItems[i]] = true;
   }
}

// clang-format off
@Author("Deathrider365")
global script onContGame {
   // clang-format off
   
   void run() {
      subscreenYOffset = -224;
      
      if(onContHP != 0) {
         Hero->HP = onContHP;
         Hero->MP = onContMP;	
      } else {
         Hero->HP = Hero->MaxHP;
         Hero->MP = Hero->MaxMP;		
      }
      
      if (SizeOfArray(stolenLinkItems))
         for (int i = 0; i < SizeOfArray(stolenLinkItems); ++i)
            Hero->Item[stolenLinkItems[i]] = true;
   }
}

// clang-format off
@Author("Deathrider365")
global script onSave {
   // clang-format off
   
   void run() {
      if (SizeOfArray(stolenLinkItems))
         for (int i = 0; i < SizeOfArray(stolenLinkItems); ++i)
            Hero->Item[stolenLinkItems[i]] = true;
   }
}

// clang-format off
@Author("Deathrider365")
global script onSaveLoad {
   // clang-format off
   
   void run() {

   }
}

// clang-format off
@Author("Deathrider365")
global script onExit {
   // clang-format off
   
   void run() {

   }
}