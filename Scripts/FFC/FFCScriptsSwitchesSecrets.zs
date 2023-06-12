///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~~~~~~~~~~~ Switches & Secrets ~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

@Author("EmilyV99")
ffc script EnemiesChest {
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

@Author("Moosh")
ffc script Shutter {
   //start Instructions
   // type: 1 for enemy, otherwise secrets
   //end
	void run(int type, int perm, bool playSound) {
		int thisData = this->Data;
		int thisCSet = this->CSet;
		this->Data = FFCS_INVISIBLE_COMBO;
		
		mapdata m = Game->LoadTempScreen(1);
		int cp = ComboAt(this->X + 8, this->Y + 8);
		int underCombo = m->ComboD[cp];
		int underCSet = m->ComboC[cp];
		int LinkX = Link->X;
		
		if(perm && Screen->State[ST_SECRET])
			Quit();
			
		if(LinkX <= 0)
			LinkX = 240;
		else if(LinkX >= 240)
			LinkX = 0;
			
		int LinkY = Link->Y;
		
		if(LinkY <= 0)
			LinkY = 160;
		else if(LinkY >= 160)
			LinkY = 0;
			
		int moveDir = Link->Dir;
				
		if(GB_Shutter_InShutter(this, LinkX, LinkY, 0)) {
			if(LinkY == 0)
				moveDir = DIR_DOWN;
			else if(LinkY == 160)
				moveDir = DIR_UP;
			else if(LinkX == 0)
				moveDir = DIR_RIGHT;
			else if(LinkX == 240)
				moveDir = DIR_LEFT;
				
			Waitframe();
			
			while(GB_Shutter_InShutter(this, Link->X, Link->Y, 0) && CanWalk(Link->X, Link->Y, moveDir, 1, false)) {
				NoAction();
				
				if(moveDir == DIR_UP)
					Link->InputUp = true;
				else if(moveDir == DIR_DOWN)
					Link->InputDown = true;
				else if(moveDir == DIR_LEFT)
					Link->InputLeft = true;
				else if(moveDir == DIR_RIGHT)
					Link->InputRight = true;
					
				Waitframe();
			}
			
			Game->PlaySound(SFX_SHUTTER_CLOSE);
			m->ComboD[cp] = underCombo;
			m->ComboC[cp] = underCSet;
			this->Data = thisData + 1;
			Game->LoadComboData(this->Data)->Frame = 0;
			this->CSet = thisCSet;
			
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
			
			this->Data = FFCS_INVISIBLE_COMBO;
			m->ComboD[cp] = thisData;
			m->ComboC[cp] = thisCSet;
			
			if(type == 1)
				Waitframes(8);
		}
		else {
			m->ComboD[cp] = thisData;
			m->ComboC[cp] = thisCSet;
			
			if(type == 1)
				Waitframes(8);
			else
				Waitframe();
		}
		
		while(true) {
			if(GB_Shutter_InShutter(this, Link->X, Link->Y, 3)) {
				m->ComboD[cp] = underCombo;
				m->ComboC[cp] = underCSet;
				
				if(Link->Y == 0)
					moveDir = DIR_DOWN;
				else if(Link->Y == 160)
					moveDir = DIR_UP;
				else if(Link->X == 0)
					moveDir = DIR_RIGHT;
				else if(Link->X == 240)
					moveDir = DIR_LEFT;
					
				while(GB_Shutter_InShutter(this, Link->X, Link->Y, 0) && CanWalk(Link->X, Link->Y, moveDir, 1, false)) {
					NoAction();
					
					if(moveDir == DIR_UP)
						Link->InputUp = true;
					else if(moveDir == DIR_DOWN)
						Link->InputDown = true;
					else if(moveDir == DIR_LEFT)
						Link->InputLeft = true;
					else if(moveDir == DIR_RIGHT)
						Link->InputRight = true;
						
					Waitframe();
				}
				
				Game->PlaySound(SFX_SHUTTER_CLOSE);
				m->ComboD[cp] = underCombo;
				m->ComboC[cp] = underCSet;
				Game->LoadComboData(thisData + 1)->Frame = 0;
				this->Data = thisData + 1;
				this->CSet = thisCSet;
				
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
				
				this->Data = FFCS_INVISIBLE_COMBO;
				m->ComboD[cp] = thisData;
				m->ComboC[cp] = thisCSet;
				
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
			
			if(type == 0 && Screen->SecretsTriggered())
				break;
			
			if(type == 1)
				unless(GB_Shutter_CheckEnemies())
					break;
					
			Waitframe();
		}
		
		Game->PlaySound(SFX_SHUTTER_OPEN);
      
      if (playSound)
         Game->PlaySound(SFX_OOT_SECRET);
		
      m->ComboD[cp] = underCombo;
		m->ComboC[cp] = underCSet;
		Game->LoadComboData(thisData + 1)->Frame = 0;
		this->Data = thisData + 1;
		this->CSet = thisCSet;
		Waitframes(4);
	
		this->Data = FFCS_INVISIBLE_COMBO;
		if(perm)
			Screen->State[ST_SECRET] = true;
	}
	
	bool GB_Shutter_InShutter(ffc this, int LinkX, int LinkY, int leeway) {
		return Abs(LinkX - this->X) < 16 - leeway && LinkY > this->Y - 16 + leeway && LinkY < this->Y + 8 - leeway;
	}
	
	bool GB_Shutter_CheckEnemies() {
		for(int i = Screen->NumNPCs(); i >= 1; i--) {
			npc n = Screen->LoadNPC(i);
			if(n->Type != NPCT_PROJECTILE && n->Type != NPCT_FAIRY && n->Type != NPCT_TRAP && n->Type != NPCT_GUY)
				if(!(n->MiscFlags & (1 << 3)))
					return true;
		}
		return false;
	}
}

@Author("Moosh")
ffc script OpenForItemId {
   void run(int itemId, bool perm) {
      if(Screen->State[ST_SECRET]) 
         Quit();
         
      while(true) {
         if (Hero->Item[itemId]) {
            Screen->TriggerSecrets();
            
            if(perm) 
               Screen->State[ST_SECRET] = true;
               
            return;
         }
         Waitframe();
      }
   }
}

@Author("Deathrider365")
ffc script OpenForCounterCount {
   void run(int counterId, int counterValue, bool perm) {
      
      unless (Game->Counter[counterId] == counterValue)
         Quit();
         
      while(true) {
         if (Game->Counter[counterId] == counterValue) {
            Screen->TriggerSecrets();
            
            if (perm) 
               Screen->State[ST_SECRET] = true;
               
            return;
         }
         Waitframe();
      }
   }
}

@Author("Deathrider365")
ffc script ScreenQuakeOnSecret {
   void run(int quakePower) {
      if (Screen->State[ST_SECRET])
         Quit();

      until (Screen->State[ST_SECRET])
         Waitframe();

      Screen->Quake = quakePower;
   }
}

@Author("Deathrider365")
ffc script TriggerOnceEnemiesKilled {
   void run(int flag) {
      int comboD[176];
      
      for (int i = 0; i < 176; i++)
         if (Screen->ComboF[i] == flag) {
            comboD[i] = Screen->ComboD[i];
            Screen->ComboF[i] = 0;
         }
         
      until(Screen->NumNPCs())
         Waitframe();
         
      while(Screen->NumNPCs())
         Waitframe();
      
      for (int i = 0; i < 176; i++)
         if (comboD[i] > 0)
            Screen->ComboD[i] = comboD[i] + 1;
   }
}

@Author("Moosh")
ffc script SwitchRemote {
   //start Instructions
   // D0: Set to 0 if no pressure. Set to 1 to make the switch a pressure switch (a block or Link must stay on it to keep it triggered). Set to 2 to make it a pressure switch that only reacts to push blocks.
   // D1: Set to the switch's ID. 0 if the secret is temporary or the switch is pressure triggered.
   // D2: Set to the flag that specifies the region for the remote secret.
   // D3: If > 0, specifies a special secret sound. -1 for default, 0 for silent.
   // D4 (2.55 version only): Specifies the layer for the remote secret.
   // D5: 1 to trigger screen secrets
   //end
   
   void run(int pressure, int id, int flag, int sfx, int nextCombo, int triggerScreenSecrets) {
      bool noLink;
      
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
      
      for (i = 0; i < 176; i++)
         if (Screen->ComboF[i] == flag) {
            comboD[i] = Screen->ComboD[i];
            Screen->ComboF[i] = 0;
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
            unless (switchPressed(this->X, this->Y, noLink))
               Waitframe();
               
            this->Data = data + 1;
            
            Game->PlaySound(SFX_SWITCH_PRESS);
            
            for (i = 0; i < 176; i++)
               if (comboD[i] > 0)
                  Screen->ComboD[i] = nextCombo > 0 ? nextCombo : comboD[i] + 1;;
                  
            while (switchPressed(this->X, this->Y, noLink))
               Waitframe();
               
            this->Data = data;
            Game->PlaySound(SFX_SWITCH_RELEASE);
            
            for (i = 0; i < 176; i++)
               if (comboD[i] > 0)
                  Screen->ComboD[i] = nextCombo > 0 ? nextCombo : comboD[i] + 1;
               
         }
      } else {
         until (switchPressed(this->X, this->Y, noLink))
            Waitframe();
         
         this->Data = data + 1;
         
         Game->PlaySound(SFX_SWITCH_PRESS);
         
         if (triggerScreenSecrets)
            Screen->TriggerSecrets();
         
         if (sfx > 0)
            Game->PlaySound(sfx);
         else if (sfx == -1)
            Game->PlaySound(SFX_SECRET);
            
         for (i = 0; i < 176; i++)
            if (comboD[i] > 0)
               Screen->ComboD[i] = nextCombo > 0 ? nextCombo : comboD[i] + 1;
               
         if (id > 0)
            Screen->D[d] |= db;
      }
   }
}

@Author("Moosh, Modified by Deathrider365")
ffc script SwitchTrap { 
   void run(int enemyid, int count, int fallSpeed, int perm) {
      until(switchPressed(this->X, this->Y, false))
         Waitframe();
      
      this->Data++;
      Game->PlaySound(SFX_SWITCH_PRESS);
      Game->PlaySound(SFX_SWITCH_ERROR);
      
      Audio->PlayEnhancedMusic("FSA - Mini Boss Battle.ogg", 1);
      
      npc npcs[255];
      
      for (int i = 0; i < count; i++) {
         int pos = getSpawnPos();
         npc n = CreateNPCAt(enemyid, ComboX(pos), ComboY(pos));
         npcs[i] = n;
         Game->PlaySound(SFX_FALL);
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
      
      unless (fallSpeed)
         fallSpeed = 5;
      
      for (int i = 0; i < 60; ++i) {
         for (int j = 0; j < count; j++)
            npcs[j]->Z -= npcs[j]->Z < fallSpeed ? npcs[j]->Z : fallSpeed;
         Waitframe();
      }
      
      while(Screen->NumNPCs())
         Waitframe();
      
      char32 areaMusic[256];
      Game->GetDMapMusicFilename(Game->GetCurDMap(), areaMusic);
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
   }
	
   bool validSpawn(int pos) {
      int x = ComboX(pos);
      int y = ComboY(pos);
      
      if (Screen->isSolid(x + 4, y + 4) 
       || Screen->isSolid(x + 12, y + 4) 
       || Screen->isSolid(x + 4, y + 12) 
       || Screen->isSolid(x + 12, y + 12))
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

@Author("Moosh")
ffc script SwitchHitAll {
   //start Instructions
   // D0: Set this to the combo number used for the unpressed switches.
   // D1: Set to 1 to make the switch a pressure switch (a block or Link must stay on it to keep it triggered). 
   // 	Set to 2 to make it a pressure switch that only reacts to push blocks.
   // D2: Set to 1 to make the secret that's triggered permanent.
   // D3: Set to the controller's ID. Set to 0 if the switch is temporary or you're using screen secrets.
   // D4: Set to the flag that specifies the region for the remote secret. If you're using screen secrets instead of remote ones, this can be ignored.
   // D5: If > 0, specifies a special secret sound. -1 for default, 0 for silent.
   // D6: If you want the script to remember which switches were pressed after leaving the screen, 
   // 	set to the starting ID for the group of switches. This will reference this ID as well as the 
   // 	next n-1 ID's after that where n is the number of switches in the group. Be careful to thoroughly 
   // 	test that this doesn't bleed into other switch ID's or Screen->D used by other scripts. 
   // 	If you don't want to save the switches' states or the switches are pressure switches, this should be 0.
   // D7 (2.55 version only): Specifies the layer for the remote secret. Switch combos themselves must still be placed on layer 0.
   //end
   
	void run(int switchCmb, int pressure, int perm, int id, int flag, int sfx, int switchID) {
		bool noLink;
		
		if (pressure == 2) {
			pressure = 1;
			noLink = true;
		}
		
		int i; int j; int k;
		int d;
		long db;
		
		if (flag == 0)
			id = 0;
			
		int comboD[176];
		
		if (id > 0) {
			d = Div((id - 1), 32);
			db = 1bL << ((id - 1) % 32);
			
			for (i = 0; i < 176; i++)
				if (Screen->ComboF[i] == flag){
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
				
				unless (pressure && switchID > 0) {
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
							
					while(true) {
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
				
				while(true) {
					Switches_Update(switches, switchD, switchDB, switchesPressed, switchCmb, false, noLink);
					Waitframe();
				}
			}
		} 
		
		if (pressure) 		{
			while(switches[1] < switches[0]) {
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
			} else {
				if (sfx > 0)
					Game->PlaySound(sfx);
				else if (sfx == -1)
					Game->PlaySound(SFX_SECRET);
				Screen->TriggerSecrets();
			}
			
			if (perm) {
				if (id > 0)
					Screen->D[d] |= db;
				else
					Screen->State[ST_SECRET] = true;
			}
		} else {
			while(switches[1] < switches[0]) 			{
				Switches_Update(switches, switchD, switchDB, switchesPressed, switchCmb, false, noLink);
				Waitframe();
			}
			
			if (id > 0) {
				if (sfx > 0)
					Game->PlaySound(sfx);
				else if (sfx == -1)
					Game->PlaySound(SFX_SECRET);
				for (i = 0; i < 176; i++)
					if (comboD[i] > 0)
						Screen->ComboD[i] = comboD[i] + 1;	
			} else {
				if (sfx > 0)
					Game->PlaySound(sfx);
				else
					Game->PlaySound(SFX_SECRET);
				
				Screen->TriggerSecrets();
			}
			if (perm) {
				if (id > 0)
					Screen->D[d] |= db;
				else
					Screen->State[ST_SECRET] = true;
			}
		} 
		
		while(true) {
			Switches_Update(switches, switchD, switchDB, switchesPressed, switchCmb, false, noLink);
			Waitframe();
		}
	}
	
	void Switches_Update(int switches, int switchD, int switchDB, bool switchesPressed, int switchCmb, bool pressure, bool noLink) {
		if (pressure)
			switches[1] = 0;
			
		for (int i = 0; i < switches[0]; i++) {
			int j = i + 2;
			int k = switches[j];
			int p = switchPressed(ComboX(k), ComboY(k), noLink);
			
			if (p) {
				if (p != 2)
					Screen->ComboD[k] = switchCmb + 1;
				
				unless (switchesPressed[j]) {
					Audio->PlaySound(SFX_SWITCH_PRESS);
					
					if (switchD[0] > 0)
						Screen->D[switchD[j]] |= switchDB[j];
						
					switchesPressed[j] = true;
					
					unless (pressure)
						switches[1]++;
				}
				
				if (pressure)
					switches[1]++;
			} else {
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

@Author("Moosh")
ffc script SwitchSequential {
   //start Instructions
   // D0: Set this to the flag marking all the switches on the screen. The order the switches have to be hit in will be determined by their combo numbers.
   // D1: Set to 1 to make the secret that's triggered permanent.
   // D2: If > 0, specifies a special secret sound. -1 for default, 0 for silent.
   //end
   
	void run(int flag, int perm, int sfx) 	{
		int i; int j; int k;
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
				switchesPressed[i+2] = true;
			
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
			Game->PlaySound(sfx);
		else if (sfx == -1)
			Game->PlaySound(SFX_SECRET);
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
	
	void Switches_Organize(int switches, int switchOrder) {
		bool banned[34];
		
		for (int j = 0; j < switches[0]; j++) {
			int lowest = -1;
			int lowestIndex = -1;
			
			for (int i = 0; i < switches[0]; i++) {
				int c = Screen->ComboD[switches[i + 2]];
				
				unless (c == -1 && banned[i + 2])
					if (lowest == -1 || c < lowest) {
						lowest = c;
						lowestIndex = i + 2;
					}
			}
			
			switchOrder[j] = lowestIndex;
			banned[lowestIndex] = true;
		}
	} 
	
	bool Switches_LinkOn(int switches) {
		for (int i = 0; i < switches[0]; i++) {
			int j = i + 2;
			int k = switches[j];
			int p = switchPressed(ComboX(k), ComboY(k), false);
			
			if (p == 1)
				return true;
		}
		return false;
	} 
	
	void Switches_Update(int switches, bool switchesPressed, int switchOrder, int switchCmb, int switchMisc, bool canPress) {
		bool reset;
		
		for (int i = 0; i < switches[0]; i++) {
			int j = i + 2;
			int k = switches[j];
			int p = switchPressed(ComboX(k), ComboY(k), false);
			
			unless (switchesPressed[j]) {
				unless (p == 2)
					Screen->ComboD[k] = switchCmb[j];
				
				if (p && canPress) {
					if (j == switchOrder[switches[1]]) {
						switches[1]++;
						Game->PlaySound(SFX_SWITCH_PRESS);
						switchesPressed[j] = true;
					} else {
						switches[1] = 0;
						Game->PlaySound(SFX_SWITCH_ERROR);
						reset = true;
					}
				}
			}
			
			else {
				unless (p == 2)
					Screen->ComboD[k] = switchCmb[j] + 1;
					
				if (p == 0 && canPress) {
					Game->PlaySound(SFX_SWITCH_RELEASE);
					switchesPressed[j] = false;
				}
			}
		}
		
		if (reset) {
			switchMisc[0] = 1;
			for (int i = 0; i < switches[0]; i++) {
				int j = i + 2;
				int k = switches[j];
				int p = switchPressed(ComboX(k), ComboY(k), false);
				switchesPressed[j] = false;
			}
		}
	} 
} 

@Author("Colossal")
ffc script IceBlock {
	void run() {
		int undercombo;
		int framecounter = 0;

		Waitframe();
		undercombo = Screen->ComboD[this->Y + (this->X >> 4)];
		Screen->ComboD[this->Y + (this->X >> 4)] = this->Data;

		while(true) {
			// Check if Link is pushing against the block
			if ((Link->X == this->X - 16 && (Link->Y < this->Y + 1 && Link->Y > this->Y - 12) && Link->InputRight && Link->Dir == DIR_RIGHT) || 	// Right
			(Link->X == this->X + 16 && (Link->Y < this->Y + 1 && Link->Y > this->Y - 12) && Link->InputLeft && Link->Dir == DIR_LEFT) || 		// Left
			(Link->Y == this->Y - 16 && (Link->X < this->X + 4 && Link->X > this->X - 4) && Link->InputDown && Link->Dir == DIR_DOWN) || 		// Down
			(Link->Y == this->Y + 8 && (Link->X < this->X + 4 && Link->X > this->X - 4) && Link->InputUp && Link->Dir == DIR_UP)) 				// Up
				framecounter++;
			else 
				framecounter = 0;	// Reset the frame counter
		
			// Once enough frames have passed, move the block
		
			if (framecounter >= ICE_BLOCK_SENSITIVITY) {
				// Check the direction
				if (Link->Dir == DIR_RIGHT) {							// Not at the edge of the screen, Not "No Push Block", // Is walkable			
					while(this->X < 240 && !ComboFI(this->X + 16, this->Y, CF_NOBLOCKS) && Screen->ComboS[this->Y + ((this->X + 16) >> 4)] == 0000b) { 														
						Screen->ComboD[this->Y + (this->X >> 4)] = undercombo;
						this->Vx = 2;
						WaitNoAction(8);
						undercombo = Screen->ComboD[this->Y + (this->X >> 4)];
					}
				
					this->Vx = 0;
					Screen->ComboD[this->Y + (this->X >> 4)] = this->Data;
				}
				else if (Link->Dir == DIR_LEFT) {
					while(this->X > 0 && !ComboFI(this->X - 1, this->Y, CF_NOBLOCKS) && Screen->ComboS[this->Y + ((this->X - 16) >> 4)] == 0000b) { 															
						Screen->ComboD[this->Y + (this->X >> 4)] = undercombo;
						this->Vx = -2;
						WaitNoAction(8);
						undercombo = Screen->ComboD[this->Y + (this->X >> 4)];
					}
				
					this->Vx = 0;
					Screen->ComboD[this->Y + (this->X >> 4)] = this->Data;
				}
				else if (Link->Dir == DIR_DOWN) {
					while(this->Y < 160 && !ComboFI(this->X, this->Y + 16, CF_NOBLOCKS) && Screen->ComboS[(this->Y + 16) + (this->X >> 4)] == 0000b) { 															
						Screen->ComboD[this->Y + (this->X >> 4)] = undercombo;
						this->Vy = 2;
						WaitNoAction(8);
						undercombo = Screen->ComboD[this->Y + (this->X >> 4)];
					}
				
					this->Vy = 0;
					Screen->ComboD[this->Y + (this->X >> 4)] = this->Data;
				}
				else if (Link->Dir == DIR_UP) 				{
					while(this->Y > 0 && !ComboFI(this->X, this->Y - 1, CF_NOBLOCKS) && Screen->ComboS[(this->Y - 16) + (this->X >> 4)] == 0000b) { 														
						Screen->ComboD[this->Y + (this->X >> 4)] = undercombo;
						this->Vy = -2;
						WaitNoAction(8);
						undercombo = Screen->ComboD[this->Y + (this->X >> 4)];
					}
				
					this->Vy = 0;
					Screen->ComboD[this->Y + (this->X >> 4)] = this->Data;
				}
			
				framecounter = 0;		// Reset the frame counter
			}		
		}
		
		Waitframe();
	}
}

@Author("Colossal")
ffc script IceTrigger {
	void run() {
		ffc blocks[31];
		int triggerx[31];
		int triggery[31];
		int num_ice_blocks = 0;
		int num_triggers = 0;
		int good_counter = 0;

		for (int i = 0; i < 176 && num_triggers < 31; i++) {
			if (Screen->ComboF[i] == CF_BLOCKTRIGGER || Screen->ComboI[i] == CF_BLOCKTRIGGER) {
				triggerx[num_triggers] = (i % 16) * 16;
				triggery[num_triggers] = Floor(i / 16) * 16;
				num_triggers++;
			}
		}
		
		if (num_triggers == 0) 
			Quit();

		for (int i = 1; i <= 32; i++) {
			ffc temp = Screen->LoadFFC(i);
			
			if (temp->Script == ICE_BLOCK_SCRIPT) {
				blocks[num_ice_blocks] = temp;
				num_ice_blocks++;
			}
		}
		
		if (num_ice_blocks == 0) 
			Quit();

		while(true) {
			for (int i = 0; i < num_ice_blocks; i++) {
				//Check if blocks are on switches and not moving
				for (int j = 0; j < num_triggers; j++) {
					if (blocks[i]->X == triggerx[j] && blocks[i]->Y == triggery[j] && blocks[i]->Vx == 0 && blocks[i]->Vy == 0) {
						good_counter++;
						break;
					}
				}
			}
			
			if (good_counter == num_triggers) {
				Audio->PlaySound(SFX_SECRET);
				Screen->TriggerSecrets();
				if ((Screen->Flags[SF_SECRETS] & 2) == 0) Screen->State[ST_SECRET] = true;
					Quit();
			}
			
			good_counter = 0;
			Waitframe();
		}
	}
} 

