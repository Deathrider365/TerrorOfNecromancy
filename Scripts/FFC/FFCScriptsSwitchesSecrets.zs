//~~~~~~~~~~~~~~~~~~~~~~~~~~~ Switches & Secrets FFCs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

// clang-format off
@Author("EmilyV99")
ffc script EnemiesChest {
   // clang-format on
   void run(int flag, int newCombo, bool perm, int screenD, int cset, int sfx) {
      if (perm && getScreenD(screenD)) {
         for (int i = 0; i < 176; ++i)
            if (ComboFI(i, flag)) {
               Screen->ComboD[i] = newCombo;
               Screen->ComboC[i] = cset;
            }
         return;
      }

      Waitframes(6);

      while (EnemiesAlive())
         Waitframe();

      if (perm)
         setScreenD(screenD, true);

      for (int i = 0; i < 176; ++i)
         if (ComboFI(i, flag)) {
            Screen->ComboD[i] = newCombo;
            Screen->ComboC[i] = cset;
            Audio->PlaySound(sfx);
         }
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
            if (!(n->MiscFlags & (1 << 3)))
               return false;
      }
      return true;
   }
}

// clang-format off
@Author("Moosh")
ffc script OpenForItemId {
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
ffc script OpenForCounterCount {
   // clang-format on
   void run(int counterId, int counterValue, bool perm) {
      if (Screen->State[ST_SECRET])
         Quit();

      while (true) {
         if (Game->Counter[counterId] == counterValue) {
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
   void run(int flag) {
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
      Game->LoadDMapData(Game->CurDMap)->GetMusic(areaMusic);
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
@Author("Moosh"),
@InitD0("switchCmb"),
@InitDHelp0("Set this to the combo number used for the unpressed switches."),
@InitD1("pressure"),
@InitDHelp1("1 for link to stand on, 2 for a block"),
@InitD2("perm"),
@InitDHelp2("Set to 1 to make the secret that's triggered permanent"),
@InitD3("id"),
@InitDHelp3("Set to the controller's ID. Set to 0 if the switch is temporary or you're using screen secrets."),
@InitD4("flag"),
@InitDHelp4("Set to the flag that specifies the region for the remote secret. If you're using screen secrets instead of remote ones, this can be ignored."),
@InitD5("sfx"),
@InitDHelp5("If > 0, specifies a special secret sound. -1 for default, 0 for silent. 7 for secret sound"),
@InitD6("switchID"),
@InitDHelp6("If you want the script to remember which switches were pressed after leaving the screen, set to the starting ID for the group of switches. This will reference this ID as well as the next n-1 ID's after that where n is the number of switches in the group. Be careful to thoroughly test that this doesn't bleed into other switch ID's or Screen->D used by other scripts. If you don't want to save the switches' states or the switches are pressure switches, this should be 0."),
@InitD7("layer"),
@InitDHelp7("Specifies the layer for the remote secret. Switch combos themselves must still be placed on layer 0.")
ffc script SwitchHitAll {
   // clang-format on

   void run(int switchCmb, int pressure, int perm, int id, int flag, int sfx, int switchID) {
      bool noLink;

      if (pressure == 2) {
         pressure = 1;
         noLink = true;
      }

      int i;
      int j;
      int k;
      int d;
      long db;

      if (flag == 0)
         id = 0;

      int comboD[176];

      if (id > 0) {
         d = Div((id - 1), 32);
         db = 1bL << ((id - 1) % 32);

         for (i = 0; i < 176; i++)
            if (Screen->ComboF[i] == flag) {
               comboD[i] = Screen->ComboD[i];
               Screen->ComboF[i] = 0;
            }
      }

      int switches[34];
      int switchD[34];
      long switchDB[34];
      switchD[0] = switchID;
      bool switchesPressed[34];
      k = SizeOfArray(switches) - 2;

      for (i = 0; i < 176 && switches[0] < k; i++)
         if (Screen->ComboD[i] == switchCmb) {
            j = 2 + switches[0];
            switches[j] = i;

            unless(pressure && switchID > 0) {
               switchD[j] = Div((switchID + switches[0] - 1), 32);
               switchDB[j] = 1bL << ((switchID + switches[0] - 1) % 32);

               if (Screen->D[switchD[j]] & switchDB[j]) {
                  switchesPressed[j] = true;
                  Screen->ComboD[i] = switchCmb + 1;
                  switches[1]++;
               }
            }

            switches[0]++;
         }

      if (perm) {
         if (id > 0) {
            if (Screen->D[d] & db) {
               for (i = 2; i < switches[0] + 2; i++) {
                  Screen->ComboD[switches[i]] = switchCmb + 1;
                  switchesPressed[i] = true;
               }

               for (i = 0; i < 176; i++)
                  if (comboD[i] > 0)
                     Screen->ComboD[i] = comboD[i] + 1;

               while (true) {
                  Switches_Update(switches, switchD, switchDB, switchesPressed, switchCmb, false, noLink);
                  Waitframe();
               }
            }
         }
         else if (Screen->State[ST_SECRET]) {
            for (i = 2; i < switches[0] + 2; i++) {
               Screen->ComboD[switches[i]] = switchCmb + 1;
               switchesPressed[i] = true;
            }

            while (true) {
               Switches_Update(switches, switchD, switchDB, switchesPressed, switchCmb, false, noLink);
               Waitframe();
            }
         }
      }

      if (pressure) {
         while (switches[1] < switches[0]) {
            Switches_Update(switches, switchD, switchDB, switchesPressed, switchCmb, true, noLink);
            Waitframe();
         }

         if (id > 0) {
            if (sfx > 0)
               Audio->PlaySound(sfx);
            else if (sfx == -1)
               Audio->PlaySound(SFX_SECRET);
            for (i = 0; i < 176; i++)
               if (comboD[i] > 0)
                  Screen->ComboD[i] = comboD[i] + 1;
         }
         else {
            if (sfx > 0)
               Audio->PlaySound(sfx);
            else if (sfx == -1)
               Audio->PlaySound(SFX_SECRET);
            Screen->TriggerSecrets();
         }

         if (perm) {
            if (id > 0)
               Screen->D[d] |= db;
            else
               Screen->State[ST_SECRET] = true;
         }
      }
      else {
         while (switches[1] < switches[0]) {
            Switches_Update(switches, switchD, switchDB, switchesPressed, switchCmb, false, noLink);
            Waitframe();
         }

         if (id > 0) {
            if (sfx > 0)
               Audio->PlaySound(sfx);
            else if (sfx == -1)
               Audio->PlaySound(SFX_SECRET);
            for (i = 0; i < 176; i++)
               if (comboD[i] > 0)
                  Screen->ComboD[i] = comboD[i] + 1;
         }
         else {
            if (sfx > 0)
               Audio->PlaySound(sfx);
            else
               Audio->PlaySound(SFX_SECRET);

            Screen->TriggerSecrets();
         }
         if (perm) {
            if (id > 0)
               Screen->D[d] |= db;
            else
               Screen->State[ST_SECRET] = true;
         }
      }

      while (true) {
         Switches_Update(switches, switchD, switchDB, switchesPressed, switchCmb, false, noLink);
         Waitframe();
      }
   }

   void Switches_Update(int[] switches, int[] switchD, int[] switchDB, bool[] switchesPressed, int switchCmb, bool pressure, bool noLink) {
      if (pressure)
         switches[1] = 0;

      for (int i = 0; i < switches[0]; i++) {
         int j = i + 2;
         int k = switches[j];
         int p = switchPressed(ComboX(k), ComboY(k), noLink, false);

         if (p) {
            if (p != 2)
               Screen->ComboD[k] = switchCmb + 1;

            unless(switchesPressed[j]) {
               Audio->PlaySound(SFX_SWITCH_PRESS);

               if (switchD[0] > 0)
                  Screen->D[switchD[j]] |= switchDB[j];

               switchesPressed[j] = true;

               unless(pressure) switches[1]++;
            }

            if (pressure)
               switches[1]++;
         }
         else {
            if (switchesPressed[j]) {
               if (pressure) {
                  Audio->PlaySound(SFX_SWITCH_RELEASE);
                  Screen->ComboD[k] = switchCmb;
                  switchesPressed[j] = false;
               }
               else if (Screen->ComboD[k] != switchCmb + 1)
                  Screen->ComboD[k] = switchCmb + 1;
            }
         }
      }
   }
}

// clang-format off
@Author("Moosh")
ffc script SwitchSequential {
   // clang-format on
   // start Instructions
   //  D0: Set this to the flag marking all the switches on the screen. The order the switches have to be hit in will be determined by their combo numbers.
   //  D1: Set to 1 to make the secret that's triggered permanent.
   //  D2: If > 0, specifies a special secret sound. -1 for default, 0 for silent.
   // end

   void run(int flag, int perm, int sfx) {
      int i;
      int j;
      int k;
      int switches[34];
      int switchCmb[34];
      int switchMisc[8];
      bool switchesPressed[34];
      k = SizeOfArray(switches) - 2;

      for (i = 0; i < 176 && switches[0] < k; i++)
         if (Screen->ComboF[i] == flag) {
            j = 2 + switches[0];
            switches[j] = i;
            switchCmb[j] = Screen->ComboD[i];
            switches[0]++;
         }

      int switchOrder[34];
      Switches_Organize(switches, switchOrder);

      if (perm && Screen->State[ST_SECRET]) {
         for (i = 0; i < switches[0]; i++)
            switchesPressed[i + 2] = true;

         while (true) {
            Switches_Update(switches, switchesPressed, switchOrder, switchCmb, switchMisc, false);
            Waitframe();
         }
      }

      while (switches[1] < switches[0]) {
         Switches_Update(switches, switchesPressed, switchOrder, switchCmb, switchMisc, true);

         if (switchMisc[0] == 1) {
            switchMisc[0] = 0;
            for (i = 0; i < 30; i++) {
               Switches_Update(switches, switchesPressed, switchOrder, switchCmb, switchMisc, false);
               Waitframe();
            }

            while (Switches_LinkOn(switches)) {
               Switches_Update(switches, switchesPressed, switchOrder, switchCmb, switchMisc, false);
               Waitframe();
            }
         }

         Waitframe();
      }

      if (sfx > 0)
         Audio->PlaySound(sfx);
      else if (sfx == -1)
         Audio->PlaySound(SFX_SECRET);
      Screen->TriggerSecrets();

      if (perm)
         Screen->State[ST_SECRET] = true;

      for (i = 0; i < switches[0]; i++)
         switchesPressed[i + 2] = true;

      while (true) {
         Switches_Update(switches, switchesPressed, switchOrder, switchCmb, switchMisc, false);
         Waitframe();
      }
   }

   void Switches_Organize(int[] switches, int[] switchOrder) {
      bool banned[34];

      for (int j = 0; j < switches[0]; j++) {
         int lowest = -1;
         int lowestIndex = -1;

         for (int i = 0; i < switches[0]; i++) {
            int c = Screen->ComboD[switches[i + 2]];

            unless(c == -1 && banned[i + 2]) if (lowest == -1 || c < lowest) {
               lowest = c;
               lowestIndex = i + 2;
            }
         }

         switchOrder[j] = lowestIndex;
         banned[lowestIndex] = true;
      }
   }

   bool Switches_LinkOn(int[] switches) {
      for (int i = 0; i < switches[0]; i++) {
         int j = i + 2;
         int k = switches[j];
         int p = switchPressed(ComboX(k), ComboY(k), false, false);

         if (p == 1)
            return true;
      }
      return false;
   }

   void Switches_Update(int[] switches, bool[] switchesPressed, int[] switchOrder, int[] switchCmb, int[] switchMisc, bool canPress) {
      bool reset;

      for (int i = 0; i < switches[0]; i++) {
         int j = i + 2;
         int k = switches[j];
         int p = switchPressed(ComboX(k), ComboY(k), false, false);

         unless(switchesPressed[j]) {
            unless(p == 2) Screen->ComboD[k] = switchCmb[j];

            if (p && canPress) {
               if (j == switchOrder[switches[1]]) {
                  switches[1]++;
                  Audio->PlaySound(SFX_SWITCH_PRESS);
                  switchesPressed[j] = true;
               }
               else {
                  switches[1] = 0;
                  Audio->PlaySound(SFX_SWITCH_ERROR);
                  reset = true;
               }
            }
         }

         else {
            unless(p == 2) Screen->ComboD[k] = switchCmb[j] + 1;

            if (p == 0 && canPress) {
               Audio->PlaySound(SFX_SWITCH_RELEASE);
               switchesPressed[j] = false;
            }
         }
      }

      if (reset) {
         switchMisc[0] = 1;
         for (int i = 0; i < switches[0]; i++) {
            int j = i + 2;
            int k = switches[j];
            int p = switchPressed(ComboX(k), ComboY(k), false, false);
            switchesPressed[j] = false;
         }
      }
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

ffc script MaraudersCoveOpens {
   void run() {
      if (Game->LoadMapData(89, 0x76)->State[ST_SECRET] && Game->LoadMapData(89, 0x45)->State[ST_SECRET] && Game->LoadMapData(89, 0x25)->State[ST_SECRET]) {
         Screen->Quake = 20;
         Screen->TriggerSecrets();
         Screen->State[ST_SECRET] = true;
         Audio->PlaySound(SFX_OOT_SECRET);
      }
   }
}

ffc script MaraudersTowerStairs1 {
   void run() {
      mapdata mapData = Game->LoadTempScreen(1);

      until(getScreenD(0)) {
         if (mapData->ComboD[33] == 10668 && mapData->ComboD[113] == 10668)
            setScreenD(0, true);

         Waitframe();
      }
   }
}

ffc script MaraudersTowerStairsSecrets {
   void run() {
      mapdata mapData = Game->LoadTempScreen(1);

      until (mapData->ComboD[33] == 10668 && mapData->ComboD[113] == 10668 && getScreenD(95, 70, 0))
         Waitframe();

      Screen->TriggerSecrets();
      Screen->State[ST_SECRET] = true;
      Audio->PlaySound(SFX_OOT_SECRET);
   }
}