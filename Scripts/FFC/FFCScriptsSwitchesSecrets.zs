//~~~~~~~~~~~~~~~~~~~~~~~~~~~ Switches & Secrets FFCs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

// clang-format off
@Author("Moosh, Modified by Deathrider365"),
@InitD0("type"),
@InitDHelp0("0 for secrets, 1 for enemy, 2 for screenD -1 for never open"),
@InitD1("perm"),
@InitDHelp1("0 for temp, 1 for perm"),
@InitD2("secretSound"),
@InitDHelp2("0 to not, 1 to play"),
@InitD3("screenD"),
@InitDHelp3("if screenD, this is the register"),
@InitD4("screenDForPermEnemies"),
@InitDHelp4("if type is enemies and is perm, this is the screenD to set to never close after first triggering")
ffc script OLDShutter {
   // clang-format on
   void run(int type, bool perm, int playSecretSound, int screenD, int screenDForPermEnemies) {
      CONFIG OPEN_BY_SECRET = 0;
      CONFIG OPEN_BY_ENEMY = 1;
      CONFIG OPEN_BY_SCREEND = 2;

      int thisData = this->Data;
      this->Data = CMB_INVIS;
      this->Flags[FFCF_SOLID] = false;

      int LinkX = Hero->X;
      int LinkY = Hero->Y;

      //Check whether the shutter should not close at all
      if (perm && type == OPEN_BY_SECRET && (Screen->State[ST_SECRET])) {
         this->Data = 0; //TODO this may not work in the future
         Quit();
      }
      else if (type == OPEN_BY_SCREEND) {
         Waitframe();

         if (type == OPEN_BY_SCREEND && !getScreenD(screenD))
            Quit();
      }
      else if (type == OPEN_BY_ENEMY && perm && getScreenD(screenDForPermEnemies)) {
         Quit();
      }

      //Flip Link's position to where he will be when completely on the screen with the shutter
      if (LinkX <= 0)
         LinkX = 240;
      else if (LinkX >= 240)
         LinkX = 0;

      if (LinkY <= 0)
         LinkY = 160;
      else if (LinkY >= 160)
         LinkY = 0;

		int moveDir = Hero->Dir;

      //Handle moving link when he enters a screen through a shutter
      if (inShutter(this, LinkX, LinkY, 0)) {
			if(LinkY == 0)
				moveDir = DIR_DOWN;
			else if(LinkY == 160)
				moveDir = DIR_UP;
			else if(LinkX == 0)
				moveDir = DIR_RIGHT;
			else if(LinkX == 240)
				moveDir = DIR_LEFT;

			Waitframe();

         //Keep moving link until he is out of the shutter
         while (inShutter(this, Hero->X, Hero->Y, 0) && CanWalk(Hero->X, Hero->Y, Hero->Dir, 1, false)) {
            NoAction();

            if (LinkY == 160)
               Hero->InputUp = true;
            else if (LinkY == 0)
               Hero->InputDown = true;
            else if (LinkX == 240)
               Hero->InputLeft = true;
            else if (LinkX == 0)
               Hero->InputRight = true;

            Waitframe();
         }

         for(int i = 0; i < 4; i++) {
            if(moveDir == DIR_UP)
               Link->Y = Min(Link->Y, 144);
            else if(moveDir == DIR_DOWN)
               Link->Y = Max(Link->Y, 8);
            else if(moveDir == DIR_LEFT)
               Link->X = Min(Link->X, 224);
            else if(moveDir == DIR_RIGHT)
               Link->X = Max(Link->X, 16);

            Waitframe();
         }
      } else {
         if (type != OPEN_BY_ENEMY)
            Waitframe();
      }

      if (type == OPEN_BY_ENEMY)
         Waitframes(8);

      this->Data = thisData;
      this->Flags[FFCF_SOLID] = true;
      Audio->PlaySound(SFX_SHUTTER_CLOSE);

      //Shutter is locked, wait for it to be opened if it can be opened, otherwise stay shut
      loop() {
         if (inShutter(this, LinkX, LinkY, 3)) {
            if(Link->Y == 0)
               moveDir = DIR_DOWN;
            else if(Link->Y == 160)
               moveDir = DIR_UP;
            else if(Link->X == 0)
               moveDir = DIR_RIGHT;
            else if(Link->X == 240)
               moveDir = DIR_LEFT;

            while (inShutter(this, Hero->X, Hero->Y, 0) && CanWalk(Hero->X, Hero->Y, Hero->Dir, 1, false)) {
               NoAction();

               if (moveDir == 160)
                  Hero->InputUp = true;
               else if (moveDir == 0)
                  Hero->InputDown = true;
               else if (moveDir == 240)
                  Hero->InputLeft = true;
               else if (moveDir == 0)
                  Hero->InputRight = true;

               Waitframe();
            }

            for(int i = 0; i < 4; i++) {
               if(moveDir == DIR_UP)
                  Link->Y = Min(Link->Y, 144);
               else if(moveDir == DIR_DOWN)
                  Link->Y = Max(Link->Y, 8);
               else if(moveDir == DIR_LEFT)
                  Link->X = Min(Link->X, 224);
               else if(moveDir == DIR_RIGHT)
                  Link->X = Max(Link->X, 16);

               Waitframe();
            }

				if(moveDir == DIR_UP)
					Link->Y = Min(Link->Y, 144);
				else if(moveDir == DIR_DOWN)
					Link->Y = Max(Link->Y, 8);
				else if(moveDir == DIR_LEFT)
					Link->X = Min(Link->X, 224);
				else if(moveDir == DIR_RIGHT)
					Link->X = Max(Link->X, 16);

				Waitframes(8);
         }

         if (type == OPEN_BY_SECRET && Screen->SecretsTriggered)
            break;
         if (type == OPEN_BY_ENEMY && checkEnemies())
            break;
         if (type == OPEN_BY_SCREEND && !getScreenD(screenD))
            break;

         Waitframe();
      }

      ++this->Data;
      Audio->PlaySound(SFX_SHUTTER_OPEN);

      if (playSecretSound)
         Audio->PlaySound(SFX_OOT_SECRET);

      this->Flags[FFCF_SOLID] = false;

      if (perm) {
         if (type == OPEN_BY_ENEMY)
            setScreenD(screenDForPermEnemies, true);
         else
            Screen->State[ST_SECRET] = true;
      }

      until(this->Data == 1)
         Waitframe();

      this->Data = 0; //TODO this may not work in the future
   }

   bool inShutter(ffc this, int LinkX, int LinkY, int leeway) {
		return Abs(LinkX - this->X) < 16 - leeway && LinkY > this->Y - 16 + leeway && LinkY < this->Y + 8 - leeway;
   }

   bool checkEnemies() {
      // return Screen->NumNPCs > 0;
      for (int i = Screen->NumNPCs; i >= 1; i--) {
         npc n = Screen->LoadNPC(i);
         if (n->Type != NPCT_PROJECTILE && n->Type != NPCT_FAIRY && n->Type != NPCT_TRAP && n->Type != NPCT_GUY)
            if (!(SizeOfArray(n->Flags) & (1 << 3)))
               return false;
      }
      return true;
   }
}

// clang-format off
@Author("Moosh, Modified by Deathrider365"),
@InitD0("type"),
@InitDHelp0("0 for secrets, 1 for enemy, 2 for screenD -1 for never open"),
@InitD1("perm"),
@InitDHelp1("0 for temp, 1 for perm"),
@InitD2("secretSound"),
@InitDHelp2("0 to not, 1 to play"),
@InitD3("screenD"),
@InitDHelp3("if screenD, this is the register"),
@InitD4("screenDForPermEnemies"),
@InitDHelp4("if type is enemies and is perm, this is the screenD to set to never close after first triggering")
ffc script Shutter {
   // clang-format on
   void run(int type, bool perm, int playSecretSound, int screenD, int screenDForPermEnemies) {
      CONFIG OPEN_BY_SECRET = 0;
      CONFIG OPEN_BY_ENEMY = 1;
      CONFIG OPEN_BY_SCREEND = 2;

      this->EffectWidth = this->TileWidth * 16;
      this->EffectHeight = this->TileHeight * 16;

      if (!this->Flags[FFCF_PRELOAD])
         printf("ERROR: Shutter script must run on screen init!\n");

      int thisData = this->Data;
      this->Data = CMB_INVIS;
      this->Flags[FFCF_SOLID] = false;

      int LinkX = Hero->X;
      int LinkY = Hero->Y;

      if (Game->Scrolling[SCROLL_DIR] > -1) {
         LinkX = Game->Scrolling[SCROLL_NEW_HERO_X];
         LinkY = Game->Scrolling[SCROLL_NEW_HERO_Y];
      }

      int maxX = Region->Width - 16;
      int maxY = Region->Height - 16;

      //Check whether the shutter should not close at all
      if (perm && type == OPEN_BY_SECRET && (Screen->State[ST_SECRET])) {
         this->Data = 0;
         Quit();
      }
      else if (type == OPEN_BY_SCREEND) {
         Waitframe();

         if (type == OPEN_BY_SCREEND && !getScreenD(screenD))
            Quit();
      }
      else if (type == OPEN_BY_ENEMY && perm && getScreenD(screenDForPermEnemies)) {
         Quit();
      }

      if (inShutter(this, LinkX, LinkY, 3)) {
         setFFCData(this, thisData, true);
         this->Flags[FFCF_SOLID] = false;
      }
      else {
         setFFCData(this, thisData, false);
         this->Flags[FFCF_SOLID] = true;
      }

      int moveDir = Hero->Dir;
      int enemySpawnFrames = 4; // Frames the script must wait before enemy shutters can open

      Waitframe();

      //Shutter is locked, wait for it to be opened if it can be opened, otherwise stay shut
      loop() {
         if (enemySpawnFrames)
            --enemySpawnFrames;
         if (inShutter(this, Link->X, Link->Y, 3)) {
            setFFCData(this, thisData, true);
            this->Flags[FFCF_SOLID] = false;

            if(Link->Y < 8)
               moveDir = DIR_DOWN;
            else if(Link->Y > maxY - 16)
               moveDir = DIR_UP;
            else if(Link->X < 16)
               moveDir = DIR_RIGHT;
            else if(Link->X > maxX - 16)
               moveDir = DIR_LEFT;

            while (inShutter(this, Hero->X, Hero->Y, 0) && CanWalk(Hero->X, Hero->Y, Hero->Dir, 1, false)) {
               NoAction();

               if (moveDir == DIR_UP)
                  Hero->InputUp = true;
               else if (moveDir == DIR_DOWN)
                  Hero->InputDown = true;
               else if (moveDir == DIR_LEFT)
                  Hero->InputLeft = true;
               else if (moveDir == DIR_RIGHT)
                  Hero->InputRight = true;

               Waitframe();
            }

            if(moveDir == DIR_UP)
                Link->Y = Min(Link->Y, maxY-16);
            else if(moveDir == DIR_DOWN)
                Link->Y = Max(Link->Y, 8);
            else if(moveDir == DIR_LEFT)
                Link->X = Min(Link->X, maxX-16);
            else if(moveDir == DIR_RIGHT)
                Link->X = Max(Link->X, 16);

            Audio->PlaySound(SFX_SHUTTER_CLOSE);
            playOpenCloseAnim(this, thisData, false);
         }

         if (type == OPEN_BY_SECRET && Screen->SecretsTriggered)
            break;
         if (type == OPEN_BY_ENEMY && checkEnemies() && !enemySpawnFrames)
            break;
         if (type == OPEN_BY_SCREEND && !getScreenD(screenD))
            break;

         Waitframe();
      }

      Audio->PlaySound(SFX_SHUTTER_OPEN);

      if (playSecretSound)
         Audio->PlaySound(SFX_OOT_SECRET);

      playOpenCloseAnim(this, thisData + 2, true);

      if (perm) {
         if (type == OPEN_BY_ENEMY)
            setScreenD(screenDForPermEnemies, true);
         else
            Screen->State[ST_SECRET] = true;
      }
   }

   void setFFCData(ffc this, int combo, bool open) {
      bool big = (this->TileWidth > 1 || this->TileHeight > 1);
      if (open) {
         if (big) {
            mapdata lyr = Game->LoadTempScreen(this->Layer);
            for (int x = 0; x < this->TileWidth; ++x) {
               for(int y=0; y<this->TileHeight; ++y) {
                  int pos = ComboAt(this->X + 8 + x * 16, this->Y + 8 + y * 16);
                  lyr->ComboD[pos] = 0;
                  lyr->ComboC[pos] = this->CSet;
               }
            }
         }
         else {
            this->Data = CMB_INVIS;
         }
      }
      else {
         if (big) {
            mapdata lyr = Game->LoadTempScreen(this->Layer);
            for (int x = 0; x < this->TileWidth; ++x) {
               for(int y = 0; y < this->TileHeight; ++y) {
                  int pos = ComboAt(this->X + 8 + x * 16, this->Y + 8 + y * 16);
                  lyr->ComboD[pos] = combo+1;
                  lyr->ComboC[pos] = this->CSet;
               }
            }
         }
         else {
            this->Data = combo + 1;
         }
      }
   }
   void playOpenCloseAnim(ffc this, int combo, bool opening) {
      setFFCData(this, combo, true);
      this->Flags[FFCF_SOLID] = true;
      combodata cd = Game->LoadComboData(combo);
      int aspeed = cd->ASpeed + 1;
      int frames = Max(cd->Frames, 1) * aspeed;

      bool big = (this->TileWidth > 1 || this->TileHeight > 1);

      for (int i = 0; i < frames; ++i) {
         if (big) {
            for (int x = 0; x < this->TileWidth; ++x) {
               for (int y=0; y<this->TileHeight; ++y) {
                  Screen->DrawCombo(this->Layer, this->X + x * 16, this->Y + y * 16, combo, 1, 1, this->CSet, -1, -1, 0, 0, 0, Floor(i / aspeed), 0, true, OP_OPAQUE);
               }
            }
         }
         else
            Screen->DrawCombo(this->Layer, this->X, this->Y, combo, 1, 1, this->CSet, -1, -1, 0, 0, 0, Floor(i / aspeed), 0, true, OP_OPAQUE);

         Waitframe();
      }

      if (opening) {
         setFFCData(this, combo, true);
         this->Flags[FFCF_SOLID] = false;
      }
      else {
         setFFCData(this, combo, false);
         this->Flags[FFCF_SOLID] = true;
      }
   }

   bool inShutter(ffc this, int LinkX, int LinkY, int leeway) {
      int eL = this->X - 16 + leeway;
      int eR = this->X + this->EffectWidth - leeway;
      int eU = this->Y - 16 + leeway;
      int eD = this->Y + this->EffectHeight - 8 - leeway;
      return (LinkX > eL && LinkX < eR && LinkY > eU && LinkY < eD);
   }

   bool checkEnemies() {
      // return Screen->NumNPCs > 0;
      for (int i = Screen->NumNPCs; i >= 1; i--) {
         npc n = Screen->LoadNPC(i);
         if (n->Type != NPCT_PROJECTILE && n->Type != NPCT_FAIRY && n->Type != NPCT_TRAP && n->Type != NPCT_GUY)
            if (!(SizeOfArray(n->Flags) & (1 << 3)))
               return false;
      }
      return true;
   }
}

// clang-format off
@Author("Moosh")
ffc script OpenForItemId { //TODO Delete? Unused
   // clang-format on
   void run(int itemId, bool perm) {
      if (Screen->State[ST_SECRET])
         Quit();

      while (true) {
         if (Hero->Item[itemId]) {
            Screen->TriggerSecrets();

            if (perm)
               Screen->State[ST_SECRET] = true;

            Audio->PlaySound(SFX_SECRET);
            return;
         }
         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script ScreenQuakeOnSecret {
   // clang-format on
   void run(int quakePower) {
      if (Screen->State[ST_SECRET])
         Quit();

      until(Screen->State[ST_SECRET]) Waitframe();

      Screen->Quake = quakePower;
   }
}

// clang-format off
@Author("Deathrider365")
ffc script TriggerOnceEnemiesKilled {
   // clang-format on
   void run() {
      until(Screen->NumNPCs) Waitframe();
      while (Screen->NumNPCs) Waitframe();

      Screen->TriggerSecrets();
      Screen->State[ST_SECRET];
   }
}

// clang-format off
@Author("Moosh"),
@InitD0("pressure"),
@InitDHelp0("Set to 0 if no pressure. Set to 1 to make the switch a pressure switch (a block or Link must stay on it to keep it triggered). Set to 2 to make it a pressure switch that only reacts to push blocks."),
@InitD1("id"),
@InitDHelp1("Set to the switch's ID. 0 if the secret is temporary or the switch is pressure triggered."),
@InitD2("flag"),
@InitDHelp2("Set to the flag that specifies the region for the remote secret."),
@InitD3("sfx"),
@InitDHelp3("If > 0, specifies a special secret sound. -1 for default, 0 for silent."),
@InitD4("nextCombo"),
@InitDHelp4("The combo this ffc will assume"),
@InitD5("triggerScreenSecrets"),
@InitDHelp5("1 to trigger screen secrets")
ffc script SwitchRemote {
   // clang-format on

   void run(int pressure, int id, int flag, int sfx, int nextCombo, int triggerScreenSecrets, int layer) {
      bool noLink;
      int secretCombo = 0;

      if (pressure == 2) {
         pressure = 1;
         noLink = true;
      }

      int data = this->Data;
      int i, j, k, d, db;

      if (id > 0) {
         d = Floor((id - 1) / 16);
         db = 1 << ((id - 1) % 16);
      }

      int comboD[176];

      // TODO enhance to enable checking on all layers
      // mapdata mapData = Game->CurScreen;

      for (i = 0; i < 176; i++)
         if (Screen->ComboF[i] == flag) {
            comboD[i] = Screen->ComboD[i];
            secretCombo = Screen->ComboD[i];

            if (!pressure) {
               Screen->ComboF[i] = 0;
            }
         }

      if (id > 0)
         if (Screen->D[d] & db) {
            this->Data = data + 1;

            for (i = 0; i < 176; i++)
               if (comboD[i] > 0)
                  Screen->ComboD[i] = nextCombo > 0 ? nextCombo : comboD[i] + 1;

            Quit();
         }

      if (pressure) {
         while (true) {
            until(switchPressed(this->X, this->Y, noLink, false)) Waitframe();

            this->Data = data + 1;

            Audio->PlaySound(SFX_SWITCH_PRESS);

            if (triggerScreenSecrets) {
               Screen->State[ST_SECRET] = true;
               Screen->TriggerSecrets();
            }

            if (sfx > 0)
               Audio->PlaySound(sfx);
            else if (sfx == -1)
               Audio->PlaySound(SFX_SECRET);

            for (i = 0; i < 176; i++)
               if (comboD[i] > 0)
                  Screen->ComboD[i] = nextCombo >= 0 ? nextCombo : comboD[i] + 1;

            while (switchPressed(this->X, this->Y, noLink, false))
               Waitframe();

            this->Data = data;
            Audio->PlaySound(SFX_SWITCH_RELEASE);

            for (i = 0; i < 176; i++)
               if (comboD[i] > 0) {
                  if (pressure)
                     Screen->ComboD[i] = secretCombo;
                  else
                     Screen->ComboD[i] = nextCombo >= 0 ? nextCombo : comboD[i] + 1;
               }
         }
      }
      else {
         until(switchPressed(this->X, this->Y, noLink, false)) Waitframe();

         this->Data = data + 1;

         Audio->PlaySound(SFX_SWITCH_PRESS);

         if (triggerScreenSecrets) {
            Screen->State[ST_SECRET] = true;
            Screen->TriggerSecrets();
         }

         if (sfx > 0)
            Audio->PlaySound(sfx);
         else if (sfx == -1)
            Audio->PlaySound(SFX_SECRET);

         for (i = 0; i < 176; i++)
            if (comboD[i] > 0)
               Screen->ComboD[i] = nextCombo > 0 ? nextCombo : comboD[i] + 1;

         if (id > 0)
            Screen->D[d] |= db;
      }
   }
}

// clang-format off
@Author("Moosh, Modified by Deathrider365")
ffc script SwitchTrap {
   // clang-format on
   void run(int enemyid, int count, int fallSpeed, int perm, int sensitive) {
      if (getScreenD(0)) {
         this->Data++;
         Quit();
      }

      until(switchPressed(this->X, this->Y, false, true)) Waitframe();

      setScreenD(0, true);

      this->Data++;
      Audio->PlaySound(SFX_SWITCH_PRESS);
      Audio->PlaySound(SFX_SWITCH_ERROR);

      Audio->PlayEnhancedMusic("FSA - Mini Boss Battle.ogg", 1);

      npc npcs[255];

      for (int i = 0; i < count; i++) {
         int pos = getSpawnPos();
         npc n = CreateNPCAt(enemyid, ComboX(pos), ComboY(pos));
         npcs[i] = n;
         Audio->PlaySound(SFX_FALL);
         n->Z = 176;

         for (int j = 0; j < 20; j++) {
            for (int k = 0; k < count; k++) {
               if (npcs[k])
                  npcs[k]->Z -= npcs[k]->Z < fallSpeed ? npcs[k]->Z : fallSpeed;
            }
            Waitframe();
         }
         Waitframe();
      }

      unless(fallSpeed) fallSpeed = 5;

      for (int i = 0; i < 60; ++i) {
         for (int j = 0; j < count; j++)
            npcs[j]->Z -= npcs[j]->Z < fallSpeed ? npcs[j]->Z : fallSpeed;
         Waitframe();
      }

      while (Screen->NumNPCs)
         Waitframe();

      char32 areaMusic[256];
      Game->LoadDMapData(Game->CurDMap)->Music->GetPath(areaMusic);
      Audio->PlayEnhancedMusic(areaMusic, 0);
   }

   int getSpawnPos() {
      int pos;
      bool invalid = true;
      int failSafe = 0;

      while (invalid && failSafe < 512) {
         pos = Rand(176);

         if (validSpawn(pos))
            return pos;
      }

      for (int i = 0; i < 176; i++) {
         pos = i;

         if (validSpawn(pos))
            return pos;
      }

      return 0;
   }

   bool validSpawn(int pos) {
      int x = ComboX(pos);
      int y = ComboY(pos);

      if (Screen->isSolid(x + 4, y + 4) || Screen->isSolid(x + 12, y + 4) || Screen->isSolid(x + 4, y + 12) || Screen->isSolid(x + 12, y + 12))
         return false;

      if (ComboFI(pos, CF_NOENEMY) || ComboFI(pos, CF_NOGROUNDENEMY))
         return false;

      int ct = Screen->ComboT[pos];

      if (ct == CT_NOENEMY || ct == CT_NOGROUNDENEMY || ct == CT_NOJUMPZONE)
         return false;
      if (ct == CT_WATER || ct == CT_LADDERONLY || ct == CT_HOOKSHOTONLY || ct == CT_LADDERHOOKSHOT)
         return false;
      if (ct == CT_PIT || ct == CT_PITB || ct == CT_PITC || ct == CT_PITD || ct == CT_PITR)
         return false;

      return true;
   }
}

// clang-format off
@Author("Deathrider365"),
@InitD0("map"),
@InitDHelp0("map to set screenD"),
@InitD1("screen"),
@InitDHelp1("screen to set screenD"),
@InitD2("screenD"),
@InitDHelp2("screenD to set")
ffc script TriggerScreenDFromSecretsElsewhere {
// clang-format on
   void run(int map, int screen, int screenD) {
      mapdata mapData = Game->LoadMapData(map, screen);

      if (mapData->State[ST_SECRET]) {
         setScreenD(screenD, true);
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script MaraudersCoveOpens {
// clang-format on
   void run() {
      if (Game->LoadMapData(89, 0x76)->State[ST_SECRET] && Game->LoadMapData(89, 0x45)->State[ST_SECRET] && Game->LoadMapData(89, 0x25)->State[ST_SECRET]) {
         Screen->Quake = 20;
         Screen->TriggerSecrets();
         Screen->State[ST_SECRET] = true;
         Audio->PlaySound(SFX_OOT_SECRET);
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script MaraudersTowerStairs1 {
// clang-format on
   void run() {
      mapdata mapData = Game->LoadTempScreen(1);

      until(getScreenD(0)) {
         if (mapData->ComboD[33] == 10668 && mapData->ComboD[113] == 10668)
            setScreenD(0, true);

         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script MaraudersTowerStairsSecrets {
// clang-format on
   void run() {
      mapdata mapData = Game->LoadTempScreen(1);

      until (mapData->ComboD[33] == 10668 && mapData->ComboD[113] == 10668 && getScreenD(95, 70, 0))
         Waitframe();

      Screen->TriggerSecrets();
      Screen->State[ST_SECRET] = true;
      Audio->PlaySound(SFX_OOT_SECRET);
   }
}

// clang-format off
@Author("Deathrider365")
ffc script HiddenBooks {
// clang-format on
   void run(int triggerMessage, int doneMessage) {
      loop() {
         waitForTalking(this, true);

         unless (Screen->State[ST_SECRET]) {
            Screen->Message(triggerMessage);
            Waitframe();

            Screen->TriggerSecrets();
            Screen->State[ST_SECRET] = true;
            Audio->PlaySound(SFX_SWITCH_PRESS);
            Audio->PlaySound(SFX_SECRET);
         } else
            Screen->Message(doneMessage);

         Waitframe();
      }
   }
}

// clang-format off
@InitD0("mapScreen1"),
@InitDHelp0("map.screen - same for all D#"),
@Author("Deathrider365")
ffc script TriggerSecretsFromSecretsElsewhere {
// clang-format on
   void run(int mapScreen1, int mapScreen2, int mapScreen3, int mapScreen4, int mapScreen5, int mapScreen6, int mapScreen7, int mapScreen8) {
      int mapScreens[] = {mapScreen1, mapScreen2, mapScreen3, mapScreen4, mapScreen5, mapScreen6, mapScreen7, mapScreen8};
      bool allSecretsTriggered = true;

      for (int i = 0; i < 8; ++i) {
         if (mapScreens[i] > 0) {
            int map = Floor(mapScreens[i]);
            int screen = (mapScreens[i] % 1) / 1L;

            unless(Game->LoadMapData(map, screen)->State[ST_SECRET])
               allSecretsTriggered = false;
         }
      }

      if (allSecretsTriggered) {
         Screen->TriggerSecrets();
         Screen->State[ST_SECRET];
         Audio->PlaySound(SFX_SECRET);
      }
   }
}