///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~The Terror of Necromancy FFC Scripts ~ Secrets, Block ~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

//~~~~~ItemGuySecret~~~~~//
// D0: Number of string to show
// D1: Item to be given
// D2: X position of where the item will appear
// D3: Y position of where the item will appear
@Author("Deathrider365")
ffc script ItemGuySecret //start
{
    void run(int message, int itemID, int x, int y)
    {
        while (true)
        {
            if (Screen->State[ST_SPECIALITEM])
                return;
            
            if (Screen->State[ST_SECRET])
            {
                Waitframes(2);
                itemsprite it = CreateItemAt(itemID, x, y);
                it->Pickup = IP_HOLDUP | IP_ST_SPECIALITEM;
				
				unless(getScreenD(255))
					Screen->Message(message);
				
				setScreenD(255, true);
				
                return;
            }
            Waitframe();
        }
    }
}

//end

//~~~~~SecretGuyWithItem~~~~~//
//D0: String for if you have the required item
//D1: String for if you don't have the required item
//D2: The final message that plays when you wrapped up this guy's significance
//D3: 1 for anySide, 0 for below?
//D4: Id of item to given
//D5: 1 for perm, 0 for temp
@Author("Deathrider365")
ffc script SecretGuyWithItem //start
{
	void run(int hasItemMessage, int hasntItemMessage, int alreadyDidTheThingMessage, bool anySide, int itemId, int perm)
	{
		int loc = ComboAt(this->X, this->Y);
		
		while(true)
		{
			until(AgainstComboBase(loc, anySide) && Input->Press[CB_SIGNPOST]) 
			{
				if (AgainstComboBase(loc, anySide))
					Screen->FastCombo(7, Link->X - 10, Link->Y - 15, 48, 0, OP_OPAQUE);
					
				Waitframe();
			}
			
			if(Link->Item[itemId] && !Screen->State[ST_SECRET])
			{
				Input->Button[CB_SIGNPOST] = false;
				Screen->Message(hasItemMessage);
				
				Waitframes(2);
				
				Screen->TriggerSecrets();
				Audio->PlaySound(SFX_SECRET);
				
				if(perm) 
					Screen->State[ST_SECRET] = true;
			}
			else if (!Link->Item[itemId] && !Screen->State[ST_SECRET])
			{
				Input->Button[CB_SIGNPOST] = false;
				Screen->Message(hasntItemMessage);
			}
			else
			{
				Input->Button[CB_SIGNPOST] = false;
				Screen->Message(alreadyDidTheThingMessage);
			}
			
			Waitframe();
		}
	}
} //end

//~~~~~SecretGuy~~~~~//
//D0: String for if you have the required item
//D1: String for if you don't have the required item
//D2: The final message that plays when you wrapped up this guy's significance
//D3: 1 for anySide, 0 for below?
//D4: Id of item to given
//D5: 1 for perm, 0 for temp
@Author("Deathrider365")
ffc script SecretGuyNoItemVanishes //start
{
	void run(int hasItemMessage, int hasntItemMessage, int itemId, bool anySide, int perm)
	{
		if (Screen->State[ST_SECRET])
			Quit();
		
		int loc = ComboAt(this->X, this->Y);
		
		while(true)
		{
			until(AgainstComboBase(loc, anySide) && Input->Press[CB_SIGNPOST]) 
			{
				if (AgainstComboBase(loc, anySide))
					Screen->FastCombo(7, Link->X - 10, Link->Y - 15, 48, 0, OP_OPAQUE);
					
				Waitframe();
			}
			
			if(Link->Item[itemId])
			{
				Input->Button[CB_SIGNPOST] = false;
				Screen->Message(hasItemMessage);
				
				Waitframes(2);
				
				Screen->TriggerSecrets();
				Audio->PlaySound(SFX_SECRET);
				
				if(perm) 
					Screen->State[ST_SECRET] = true;
					
				Quit();
			}
			else
			{
				Input->Button[CB_SIGNPOST] = false;
				Screen->Message(hasntItemMessage);
			}
			
			Waitframe();
		}
	}
} //end


//~~~~~OpenForItem~~~~~//
//D0: Item number to check for
//D1: 0 for non-perm, 1 for perm
@Author("Moosh")
ffc script OpenForItemID //start
{
	void run(int itemid, bool perm)
	{
		if(Screen->State[ST_SECRET]) 
			Quit();
			
		while(true)
		{
			if(Link->Item[itemid])
			{
				Screen->TriggerSecrets();
				
				if(perm) 
					Screen->State[ST_SECRET] = true;
					
				return;
			}
			Waitframe();
		}
	}
} //end

//~~~~~ScriptWeaponTrigger~~~~~//
// D0: The LW_ weapon type to check for (std_constants.zh)
// D1: The screen flag to check for on layer 0. If 0, the FFC itself is the trigger.
// D2: The type of secret it's using:
//		-0: Self only
//		-1: Trigger Secrets (Temp)
//		-2: Trigger Secrets (Perm)
//		-3: Hit All (Temp)
//		-4: Hit All (Perm)
// D3: The combo to set the trigger combo to. If 0, will increase the combo by 1
// D4: The CSet for the trigger combo
// D5: The sound to play when the secret is triggered
@Author("Moosh")
ffc script ScriptWeaponTrigger //start
{
	void run(int weaponType, int markerFlag, int secretType, int secretCombo, int secretCSet, int sfx)
	{
		int i; int j; int k;
		if (secretType == 4)	//start If a permanent trigger is set
		{
			if (Screen->State[ST_SECRET])
			{
				if (markerFlag == 0)	//If the FFC is the trigger
				{ 
					if (secretCombo > 0)
					{
						this->Data = secretCombo;
						this->CSet = secretCSet;
					}
					else
						this->Data++;
				}
				else //If a combo is the trigger
				{ 
					for (j = 0; j < 176; j++)
					{
						if (ComboFI(j, markerFlag))
						{
							if (secretCombo > 0)
							{
								Screen->ComboD[j] = secretCombo;
								Screen->ComboC[j] = secretCSet;
								Screen->ComboF[j] = 0;
							}
							else
							{
								Screen->ComboD[j]++;
								Screen->ComboF[j] = 0;
							}
						}
					}
				}
			}
		} //end
		
		bool trigger;
		
		until(trigger) //start Cycle through weapons backwards to save the frames
		{
			for (i = Screen->NumLWeapons(); i >= 1; i--)
			{
				lweapon l = Screen->LoadLWeapon(i);
				
				if (l->ID == weaponType) //First check if the weapon is the right type
				{ 
					if (l->CollDetection && l->DeadState < 0) //Then check if it has collision
					{ 
						if (markerFlag == 0) // start If the FFC is the trigger
						{
							if (Collision(this, l))
							{
								Game->PlaySound(sfx);
								SWT_BounceWeapon(l);
								
								if (secretCombo > 0) //If a secret combo is specified, change to that
								{
									this->Data = secretCombo;
									this->CSet = secretCSet;
								}
								else //Else increase by 1
									this->Data++;
								
								if (secretType == 0) //A self only secret quits out here
									Quit();
									
								else if (secretType == 1 || secretType == 2) //A screen secret trigger breaks the loop
									trigger = true;
								
								else if (secretType == 3 || secretType == 4) //A hit all trigger breaks the loop
								{ 
									if (CountFFCsRunning(this->Script) == 1) //Only if it's the last one
										trigger = true;
									else //Otherwise it quits
										Quit();
								}
							}
						} //end
						
						else //start If a combo is the trigger
						{
							int flagCount;
							
							for (j = 0; j < 176; j++)
							{
								if (ComboFI(j, markerFlag))
								{
									flagCount++;
									int x = l->X + l->HitXOffset;
									int y = l->Y + l->HitYOffset;
									
									if (RectCollision(ComboX(j), ComboY(j), ComboX(j) + 15, ComboY(j) + 15, x, y, x + l->HitWidth - 1, y + l->HitHeight - 1))
									{
										Game->PlaySound(sfx);
										SWT_BounceWeapon(l);
										
										if (secretCombo > 0) //If a secret combo is specified, change to that
										{ 
											Screen->ComboD[j] = secretCombo;
											Screen->ComboC[j] = secretCSet;
											Screen->ComboF[j] = 0;
										}
										else //Else increase by 1
										{ 
											Screen->ComboD[j]++;
											Screen->ComboF[j] = 0;
										}
										if (secretType == 1 || secretType == 2) //A screen secret triggers secrets
										{ 
											Screen->TriggerSecrets();
											
											if (secretType == 2)
												Screen->State[ST_SECRET] = true;
										}
									}
								}
							}
							
							if (flagCount == 0) //If all triggers are hit and type is 3 or 4, break out of the loop
								if (secretType == 3 || secretType == 4)
									trigger = true;
						} //end
					}
				}
				
				if (trigger)
					break;
			}
			
			Waitframe();
		} //end
		
		Screen->TriggerSecrets();
		
		if (secretType == 2 || secretType == 4)
			Screen->State[ST_SECRET] = true;
	}
	
	void SWT_BounceWeapon(lweapon l) //start
	{
		if (l->ID == LW_BRANG || l->ID == LW_HOOKSHOT)
			l->DeadState = WDS_BOUNCE;
		else if (l->ID == LW_ARROW)
			l->DeadState = WDS_ARROW;
		else if (l->ID == LW_BEAM)
			l->DeadState = WDS_BEAMSHARDS;
	} //end
}
//end

//~~~~~EnemiesChest~~~~~//
// D0: Flag to trigger 
// D1: Combo to change into
// D2: Whether perm of not
// D3: (used only if perm) ScreenD reg
// D4: CSet
// D5: SFX
@Author("EmilyV99")
ffc script EnemiesChest //start
{
	void run(int flag, int combo, bool perm, int reg, int cset, int sfx)
	{
		if (perm && getScreenD(reg))
		{
			for (int q = 0; q < 176; ++q)
				if (ComboFI(q, flag))
				{
					Screen->ComboD[q] = combo;
					Screen->ComboC[q] = cset;
				}
			return;
		}
		
		Waitframes(6);
		
		while (EnemiesAlive())
			Waitframe();
			
		if (perm)
			setScreenD(reg, true);
		
		for (int q = 0; q < 176; ++q)
			if (ComboFI(q, flag))
			{
				Screen->ComboD[q] = combo;
				Screen->ComboC[q] = cset;
				Audio->PlaySound(sfx);
			}
	}
}
//end

//~~~~~EnemiesChest~~~~~//
// D0: Set to 1 to make the secret permanent
// D1: Set to the switch's ID if the secret is tiered, 0 otherwise.
// D2: If > 0, specifies a special secret sound. -1 for default, 0 for silent.
@Author("Moosh")
ffc script SwitchSecret //start
{
	void run(int perm, int id, int sfx)
	{
		int d;
		int db;
		
		if (id > 0)
		{
			d = Floor((id - 1) / 16);
			db = 1 << ((id - 1) % 16);
		}
		
		if (perm)
		{
			if (id > 0)
			{
				if (Screen->D[d] & db)
				{
					this->Data++;
					Screen->TriggerSecrets();
					Quit();
				}
			}
			else if (Screen->State[ST_SECRET])
			{
				this->Data++;
				Quit();
			}
		}
		
		until(SwitchPressed(this->X, this->Y, false))
			Waitframe();
			
		this->Data++;
		Screen->TriggerSecrets();
		Game->PlaySound(SFX_SWITCH_PRESS);
		
		if (sfx > 0)
			Game->PlaySound(sfx);
		else if (sfx == -1)
			Game->PlaySound(SFX_SECRET);
		if (perm)
		{
			if (id > 0)
				Screen->D[d] |= db;
			else
				Screen->State[ST_SECRET] = true;
		}
	}
} //end

//~~~~~SwitchRemote~~~~~//
// D0: Set to 0 if no pressure. Set to 1 to make the switch a pressure switch (a block or Link must stay on it to keep it triggered). Set to 2 to make it a pressure switch that only reacts to push blocks.
// D1: Set to the switch's ID. 0 if the secret is temporary or the switch is pressure triggered.
// D2: Set to the flag that specifies the region for the remote secret.
// D3: If > 0, specifies a special secret sound. -1 for default, 0 for silent.
// D4 (2.55 version only): Specifies the layer for the remote secret.
@Author("Moosh")
ffc script SwitchRemote //start
{ 
	void run(int pressure, int id, int flag, int sfx)
	{
		bool noLink;
		if (pressure == 2)
		{
			pressure = 1;
			noLink = true;
		}
		
		int data = this->Data;
		int i; int j; int k;
		int d;
		int db;
		
		if (id > 0)
		{
			d = Floor((id - 1) / 16);
			db = 1 << ((id - 1) % 16);
		}
		
		int comboD[176];
		
		for (i = 0; i < 176; i++)
			if (Screen->ComboF[i] == flag)
			{
				comboD[i] = Screen->ComboD[i];
				Screen->ComboF[i] = 0;
			}
		
		if (id > 0)
			if (Screen->D[d] & db)
			{
				this->Data = data + 1;
				
				for (i = 0; i < 176; i++)
					if (comboD[i] > 0)
						Screen->ComboD[i] = comboD[i] + 1;
						
				Quit();
			}
			
		if (pressure) //start
		{
			while (true)
			{
				unless (SwitchPressed(this->X, this->Y, noLink))
					Waitframe();
					
				this->Data = data + 1;
				Game->PlaySound(SFX_SWITCH_PRESS);
				
				for (i = 0; i < 176; i++)
					if (comboD[i] > 0)
						Screen->ComboD[i] = comboD[i] + 1;
						
				while (SwitchPressed(this->X, this->Y, noLink))
					Waitframe();
					
				this->Data = data;
				Game->PlaySound(SFX_SWITCH_RELEASE);
				
				for (i = 0; i < 176; i++)
					if (comboD[i] > 0)
						Screen->ComboD[i] = comboD[i];
					
			}
		} //end
		
		else //start
		{
			until (SwitchPressed(this->X, this->Y, noLink))
				Waitframe();
				
			this->Data = data+1;
			Game->PlaySound(SFX_SWITCH_PRESS);
			
			if (sfx > 0)
				Game->PlaySound(sfx);
			else if (sfx == -1)
				Game->PlaySound(SFX_SECRET);
				
			for (i = 0; i < 176; i++)
				if (comboD[i] > 0)
					Screen->ComboD[i] = comboD[i] + 1;
					
			if (id > 0)
				Screen->D[d] |= db;
		} //end
	}
} //end

//~~~~~SwitchHitAll~~~~~//
// D0: Set this to the combo number used for the unpressed switches.
// D1: Set to 1 to make the switch a pressure switch (a block or Link must stay on it to keep it triggered). Set to 2 to make it a pressure switch that only reacts to push blocks.
// D2: Set to 1 to make the secret that's triggered permanent.
// D3: Set to the controller's ID. Set to 0 if the switch is temporary or you're using screen secrets.
// D4: Set to the flag that specifies the region for the remote secret. If you're using screen secrets instead of remote ones, this can be ignored.
// D5: If > 0, specifies a special secret sound. -1 for default, 0 for silent.
// D6: If you want the script to remember which switches were pressed after leaving the screen, set to the starting ID for the group of switches. This will reference this ID as well as the next n-1 ID's after that where n is the number of switches in the group. Be careful to thoroughly test that this doesn't bleed into other switch ID's or Screen->D used by other scripts. If you don't want to save the switches' states or the switches are pressure switches, this should be 0.
// D7 (2.55 version only): Specifies the layer for the remote secret. Switch combos themselves must still be placed on layer 0.
@Author("Moosh")
ffc script SwitchHitAll //start
{
	void run(int switchCmb, int pressure, int perm, int id, int flag, int sfx, int switchID) //start
	{
		bool noLink;
		
		if (pressure == 2)
		{
			pressure = 1;
			noLink = true;
		}
		
		int i; int j; int k;
		int d;
		long db;
		
		if (flag == 0)
			id = 0;
			
		int comboD[176];
		
		if (id > 0)
		{
			d = Div((id - 1), 32);
			db = 1bL << ((id - 1) % 32);
			
			for (i = 0; i < 176; i++)
				if (Screen->ComboF[i] == flag)
				{
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
			if (Screen->ComboD[i] == switchCmb)
			{
				j = 2 + switches[0];
				switches[j] = i;
				
				unless (pressure && switchID > 0)
				{
					switchD[j] = Div((switchID + switches[0] - 1), 32);
					switchDB[j] = 1bL << ((switchID + switches[0] - 1) % 32);
					
					if (Screen->D[switchD[j]] & switchDB[j])
					{
						switchesPressed[j] = true;
						Screen->ComboD[i] = switchCmb + 1;
						switches[1]++;
					}
				}
				
				switches[0]++;
			}
			
		if (perm) //start
		{
			if (id > 0)
			{
				if (Screen->D[d] & db)
				{
					for (i = 2; i < switches[0] + 2; i++)
					{
						Screen->ComboD[switches[i]] = switchCmb + 1;
						switchesPressed[i] = true;
					}
					
					for (i = 0; i < 176; i++)
						if (comboD[i] > 0)
							Screen->ComboD[i] = comboD[i] + 1;
							
					while(true)
					{
						Switches_Update(switches, switchD, switchDB, switchesPressed, switchCmb, false, noLink);
						Waitframe();
					}
				}
			}
			else if (Screen->State[ST_SECRET])
			{
				for (i = 2; i < switches[0] + 2; i++)
				{
					Screen->ComboD[switches[i]] = switchCmb + 1;
					switchesPressed[i] = true;
				}
				
				while(true)
				{
					Switches_Update(switches, switchD, switchDB, switchesPressed, switchCmb, false, noLink);
					Waitframe();
				}
			}
		} //end
		
		if (pressure) //start
		{
			while(switches[1] < switches[0])
			{
				Switches_Update(switches, switchD, switchDB, switchesPressed, switchCmb, true, noLink);
				Waitframe();
			}
			
			if (id > 0)
			{
				if (sfx > 0)
					Game->PlaySound(sfx);
				else if (sfx == -1)
					Game->PlaySound(SFX_SECRET);
				for (i = 0; i < 176; i++)
					if (comboD[i] > 0)
						Screen->ComboD[i] = comboD[i] + 1;
			}
			else
			{
				if (sfx > 0)
					Game->PlaySound(sfx);
				else if (sfx == -1)
					Game->PlaySound(SFX_SECRET);
				Screen->TriggerSecrets();
			}
			
			if (perm)
			{
				if (id > 0)
					Screen->D[d] |= db;
				else
					Screen->State[ST_SECRET] = true;
			}
		} //end
		
		else //start
		{
			while(switches[1] < switches[0])
			{
				Switches_Update(switches, switchD, switchDB, switchesPressed, switchCmb, false, noLink);
				Waitframe();
			}
			
			if (id > 0)
			{
				if (sfx > 0)
					Game->PlaySound(sfx);
				else if (sfx == -1)
					Game->PlaySound(SFX_SECRET);
				for (i = 0; i < 176; i++)
					if (comboD[i] > 0)
						Screen->ComboD[i] = comboD[i] + 1;
						
			}
			else
			{
				if (sfx > 0)
					Game->PlaySound(sfx);
				else
					Game->PlaySound(SFX_SECRET);
				
				Screen->TriggerSecrets();
			}
			if (perm)
			{
				if (id > 0)
					Screen->D[d] |= db;
				else
					Screen->State[ST_SECRET] = true;
			}
		} //end
		
		while(true)
		{
			Switches_Update(switches, switchD, switchDB, switchesPressed, switchCmb, false, noLink);
			Waitframe();
		}
	} //end
	
	void Switches_Update(int switches, int switchD, int switchDB, bool switchesPressed, int switchCmb, bool pressure, bool noLink) //start
	{
		if (pressure)
			switches[1] = 0;
			
		for (int i = 0; i < switches[0]; i++)
		{
			int j = i + 2;
			int k = switches[j];
			int p = SwitchPressed(ComboX(k), ComboY(k), noLink);
			
			if (p)
			{
				if (p != 2)
					Screen->ComboD[k] = switchCmb + 1;
				
				unless (switchesPressed[j])
				{
					Audio->PlaySound(SFX_SWITCH_PRESS);
					
					if (switchD[0] > 0)
						Screen->D[switchD[j]] |= switchDB[j];
						
					switchesPressed[j] = true;
					
					unless (pressure)
						switches[1]++;
				}
				
				if (pressure)
					switches[1]++;
			}
			else
			{
				if (switchesPressed[j])
				{
					if (pressure
					){
						Audio->PlaySound(SFX_SWITCH_RELEASE);
						Screen->ComboD[k] = switchCmb;
						switchesPressed[j] = false;
					}
					else
						if (Screen->ComboD[k] != switchCmb + 1)
							Screen->ComboD[k] = switchCmb + 1;
				}
			}
		}
	} //end
} //end

//~~~~~SwitchTrap~~~~~//
// D0: Set to the ID of the enemy to drop in
// D1: Set to the number of enemies to drop
@Author("Moosh")
ffc script SwitchTrap //start
{ 
	void run(int enemyid, int count) //start
	{
		until(SwitchPressed(this->X, this->Y, false))
			Waitframe();
		
		this->Data++;
		Game->PlaySound(SFX_SWITCH_PRESS);
		Game->PlaySound(SFX_SWITCH_ERROR);
		
		for (int i = 0; i < count; i++)
		{
			int pos = Switch_GetSpawnPos();
			npc n = CreateNPCAt(enemyid, ComboX(pos), ComboY(pos));
			Game->PlaySound(SFX_FALL);
			n->Z = 176;
			Waitframes(20);
		}
	} //end
	
	int Switch_GetSpawnPos() //start
	{
		int pos;
		bool invalid = true;
		int failSafe = 0;
		while(invalid && failSafe < 512)
		{
			pos = Rand(176);
			
			if (Switch_ValidSpawn(pos))
				return pos;
		}
		
		for (int i = 0; i < 176; i++)
		{
			pos = i;
			
			if (Switch_ValidSpawn(pos))
				return pos;
		}
	} //end
	
	bool Switch_ValidSpawn(int pos) //start
	{
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
	} //end
} //end

//~~~~~SwitchSequential~~~~~//
// D0: Set this to the flag marking all the switches on the screen. The order the switches have to be hit in will be determined by their combo numbers.
// D1: Set to 1 to make the secret that's triggered permanent.
// D2: If > 0, specifies a special secret sound. -1 for default, 0 for silent.
@Author("Moosh")
ffc script SwitchSequential //start
{
	void run(int flag, int perm, int sfx) //start
	{
		int i; int j; int k;
		int switches[34];
		int switchCmb[34];
		int switchMisc[8];
		bool switchesPressed[34];
		k = SizeOfArray(switches) - 2;
		
		for (i = 0; i < 176 && switches[0] < k; i++)
			if (Screen->ComboF[i] == flag)
			{
				j = 2 + switches[0];
				switches[j] = i;
				switchCmb[j] = Screen->ComboD[i];
				switches[0]++;
			}
			
		int switchOrder[34];
		Switches_Organize(switches, switchOrder);
		
		if (perm && Screen->State[ST_SECRET])
		{
			for (i = 0; i < switches[0]; i++)
				switchesPressed[i+2] = true;
			
			while (true)
			{
				Switches_Update(switches, switchesPressed, switchOrder, switchCmb, switchMisc, false);
				Waitframe();
			}
		}
		
		while (switches[1] < switches[0])
		{
			Switches_Update(switches, switchesPressed, switchOrder, switchCmb, switchMisc, true);
			
			if (switchMisc[0] == 1)
			{
				switchMisc[0] = 0;
				for (i = 0; i < 30; i++)
				{
					Switches_Update(switches, switchesPressed, switchOrder, switchCmb, switchMisc, false);
					Waitframe();
				}
				
				while (Switches_LinkOn(switches))
				{
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
			
		while (true)
		{
			Switches_Update(switches, switchesPressed, switchOrder, switchCmb, switchMisc, false);
			Waitframe();
		}
	} //end
	
	void Switches_Organize(int switches, int switchOrder) //start
	{
		bool banned[34];
		
		for (int j = 0; j < switches[0]; j++)
		{
			int lowest = -1;
			int lowestIndex = -1;
			
			for (int i = 0; i < switches[0]; i++)
			{
				int c = Screen->ComboD[switches[i + 2]];
				
				unless (c == -1 && banned[i + 2])
					if (lowest == -1 || c < lowest)
					{
						lowest = c;
						lowestIndex = i + 2;
					}
			}
			
			switchOrder[j] = lowestIndex;
			banned[lowestIndex] = true;
		}
	} //end
	
	bool Switches_LinkOn(int switches) //start
	{
		for (int i = 0; i < switches[0]; i++)
		{
			int j = i + 2;
			int k = switches[j];
			int p = SwitchPressed(ComboX(k), ComboY(k), false);
			
			if (p == 1)
				return true;
		}
		return false;
	} //end
	
	void Switches_Update(int switches, bool switchesPressed, int switchOrder, int switchCmb, int switchMisc, bool canPress) //start
	{
		bool reset;
		
		for (int i = 0; i < switches[0]; i++)
		{
			int j = i + 2;
			int k = switches[j];
			int p = SwitchPressed(ComboX(k), ComboY(k), false);
			
			unless (switchesPressed[j])
			{
				unless (p == 2)
					Screen->ComboD[k] = switchCmb[j];
				
				if (p && canPress)
				{
					if (j == switchOrder[switches[1]])
					{
						switches[1]++;
						Game->PlaySound(SFX_SWITCH_PRESS);
						switchesPressed[j] = true;
					}
					else
					{
						switches[1] = 0;
						Game->PlaySound(SFX_SWITCH_ERROR);
						reset = true;
					}
				}
			}
			
			else
			{
				unless (p == 2)
					Screen->ComboD[k] = switchCmb[j] + 1;
					
				if (p == 0 && canPress)
				{
					Game->PlaySound(SFX_SWITCH_RELEASE);
					switchesPressed[j] = false;
				}
			}
		}
		
		if (reset)
		{
			switchMisc[0] = 1;
			for (int i = 0; i < switches[0]; i++)
			{
				int j = i + 2;
				int k = switches[j];
				int p = SwitchPressed(ComboX(k), ComboY(k), false);
				switchesPressed[j] = false;
			}
		}
	} //end
} //end

//~~~~~BlockPermSecrets~~~~~//
//1. Make a new combo with inherent flag 16 (or any secret flag)
//2. Set this FFC to the above combo
//3. When secrets are triggered by blocks, this script will make it permanent
@Author("MoscowModder")
ffc script BlockPermSecrets //start
{
	void run()
	{
		int thisCombo = this->Data;
	
		until(Screen->State[ST_SECRET])
		{
			if(this->Data != thisCombo) 
				Screen->State[ST_SECRET] = true;
				
			Waitframe();
		}
	}
} //end

//~~~~~IceBlock~~~~~//
@Author("Colossal")
ffc script IceBlock //start
{
	void run() 
	{
		int undercombo;
		int framecounter = 0;

		Waitframe();
		undercombo = Screen->ComboD[this->Y + (this->X >> 4)];
		Screen->ComboD[this->Y + (this->X >> 4)] = this->Data;

		while(true) 
		{
			// Check if Link is pushing against the block
			if ((Link->X == this->X - 16 && (Link->Y < this->Y + 1 && Link->Y > this->Y - 12) && Link->InputRight && Link->Dir == DIR_RIGHT) || 	// Right
			(Link->X == this->X + 16 && (Link->Y < this->Y + 1 && Link->Y > this->Y - 12) && Link->InputLeft && Link->Dir == DIR_LEFT) || 		// Left
			(Link->Y == this->Y - 16 && (Link->X < this->X + 4 && Link->X > this->X - 4) && Link->InputDown && Link->Dir == DIR_DOWN) || 		// Down
			(Link->Y == this->Y + 8 && (Link->X < this->X + 4 && Link->X > this->X - 4) && Link->InputUp && Link->Dir == DIR_UP)) 				// Up
				framecounter++;
			else 
				framecounter = 0;	// Reset the frame counter
		
			// Once enough frames have passed, move the block
		
			if (framecounter >= ICE_BLOCK_SENSITIVITY) 
			{
				// Check the direction
				if (Link->Dir == DIR_RIGHT) 
				{							// Not at the edge of the screen, Not "No Push Block", // Is walkable			
					while(this->X < 240 && !ComboFI(this->X + 16, this->Y, CF_NOBLOCKS) && Screen->ComboS[this->Y + ((this->X + 16) >> 4)] == 0000b) 
					{ 														
						Screen->ComboD[this->Y + (this->X >> 4)] = undercombo;
						this->Vx = 2;
						WaitNoAction(8);
						undercombo = Screen->ComboD[this->Y + (this->X >> 4)];
					}
				
					this->Vx = 0;
					Screen->ComboD[this->Y + (this->X >> 4)] = this->Data;
				}
				else if (Link->Dir == DIR_LEFT) 
				{
					while(this->X > 0 && !ComboFI(this->X - 1, this->Y, CF_NOBLOCKS) && Screen->ComboS[this->Y + ((this->X - 16) >> 4)] == 0000b) 
					{ 															
						Screen->ComboD[this->Y + (this->X >> 4)] = undercombo;
						this->Vx = -2;
						WaitNoAction(8);
						undercombo = Screen->ComboD[this->Y + (this->X >> 4)];
					}
				
					this->Vx = 0;
					Screen->ComboD[this->Y + (this->X >> 4)] = this->Data;
				}
				else if (Link->Dir == DIR_DOWN) 
				{
					while(this->Y < 160 && !ComboFI(this->X, this->Y + 16, CF_NOBLOCKS) && Screen->ComboS[(this->Y + 16) + (this->X >> 4)] == 0000b) 
					{ 															
						Screen->ComboD[this->Y + (this->X >> 4)] = undercombo;
						this->Vy = 2;
						WaitNoAction(8);
						undercombo = Screen->ComboD[this->Y + (this->X >> 4)];
					}
				
					this->Vy = 0;
					Screen->ComboD[this->Y + (this->X >> 4)] = this->Data;
				}
				else if (Link->Dir == DIR_UP) 
				{
					while(this->Y > 0 && !ComboFI(this->X, this->Y - 1, CF_NOBLOCKS) && Screen->ComboS[(this->Y - 16) + (this->X >> 4)] == 0000b) 
					{ 														
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
//end

//~~~~~IceTrigger~~~~~//
@Author("Colossal")
ffc script IceTrigger //start
{
	void run() 
	{
		ffc blocks[31];
		int triggerx[31];
		int triggery[31];
		int num_ice_blocks = 0;
		int num_triggers = 0;
		int good_counter = 0;

		for (int i = 0; i < 176 && num_triggers < 31; i++) 
		{
			if (Screen->ComboF[i] == CF_BLOCKTRIGGER || Screen->ComboI[i] == CF_BLOCKTRIGGER) 
			{
				triggerx[num_triggers] = (i % 16) * 16;
				triggery[num_triggers] = Floor(i / 16) * 16;
				num_triggers++;
			}
		}
		
		if (num_triggers == 0) 
			Quit();

		for (int i = 1; i <= 32; i++) 
		{
			ffc temp = Screen->LoadFFC(i);
			
			if (temp->Script == ICE_BLOCK_SCRIPT) 
			{
				blocks[num_ice_blocks] = temp;
				num_ice_blocks++;
			}
		}
		
		if (num_ice_blocks == 0) 
			Quit();

		while(true) 
		{
			for (int i = 0; i < num_ice_blocks; i++) 
			{
				//Check if blocks are on switches and not moving
				for (int j = 0; j < num_triggers; j++) 
				{
					if (blocks[i]->X == triggerx[j] && blocks[i]->Y == triggery[j] && blocks[i]->Vx == 0 && blocks[i]->Vy == 0) 
					{
						good_counter++;
						break;
					}
				}
			}
			
			if (good_counter == num_triggers) 
			{
				Audio->PlaySound(SFX_SECRET);
				Screen->TriggerSecrets();
				if ((Screen->Flags[SF_SECRETS] & 2) == 0) Screen->State[ST_SECRET] = true;
					Quit();
			}
			
			good_counter = 0;
			Waitframe();
		}
	}
} //end

//~~~~~GB_Shutter~~~~~//
// D0: Set to 1 if it's an enemy shutter, otherwise it will open when the secret combo underneath it is changed
// D1: Set to 1 if the secret should be permanent.
@Author("Moosh")
ffc script GB_Shutter //start
{
	void run(int type, int perm) //start
	{
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
				
		if(GB_Shutter_InShutter(this, LinkX, LinkY, 0))
		{
			if(LinkY == 0)
				moveDir = DIR_DOWN;
			else if(LinkY == 160)
				moveDir = DIR_UP;
			else if(LinkX == 0)
				moveDir = DIR_RIGHT;
			else if(LinkX == 240)
				moveDir = DIR_LEFT;
				
			Waitframe();
			
			while(GB_Shutter_InShutter(this, Link->X, Link->Y, 0) && CanWalk(Link->X, Link->Y, moveDir, 1, false))
			{
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
			
			//MooshPit_ResetEntry();
			Game->PlaySound(SFX_SHUTTER);
			m->ComboD[cp] = underCombo;
			m->ComboC[cp] = underCSet;
			Game->LoadComboData(thisData + 1)->Frame = 0;
			this->Data = thisData + 1;
			this->CSet = thisCSet;
			
			for(int i = 0; i < 4; i++)
			{
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
		else
		{
			m->ComboD[cp] = thisData;
			m->ComboC[cp] = thisCSet;
			
			if(type == 1)
				Waitframes(8);
			else
				Waitframe();
		}
		
		while(true)
		{
			if(GB_Shutter_InShutter(this, Link->X, Link->Y, 3))
			{
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
					
				while(GB_Shutter_InShutter(this, Link->X, Link->Y, 0) && CanWalk(Link->X, Link->Y, moveDir, 1, false))
				{
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
				
				Game->PlaySound(SFX_SHUTTER);
				m->ComboD[cp] = underCombo;
				m->ComboC[cp] = underCSet;
				Game->LoadComboData(thisData + 1)->Frame = 0;
				this->Data = thisData + 1;
				this->CSet = thisCSet;
				
				for(int i = 0; i < 4; i++)
				{
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
		
		Game->PlaySound(SFX_SHUTTER);
		m->ComboD[cp] = underCombo;
		m->ComboC[cp] = underCSet;
		Game->LoadComboData(thisData + 1)->Frame = 0;
		this->Data = thisData + 1;
		this->CSet = thisCSet;
		Waitframes(4);
	
		this->Data = FFCS_INVISIBLE_COMBO;
		if(perm)
			Screen->State[ST_SECRET] = true;
	} //end
	
	bool GB_Shutter_InShutter(ffc this, int LinkX, int LinkY, int leeway) //start
	{
		if(Abs(LinkX - this->X) < 16 - leeway && LinkY > this->Y - 16 + leeway && LinkY < this->Y + 8 - leeway)
			return true;
		return false;
	} //end
	
	bool GB_Shutter_CheckEnemies() //start
	{
		for(int i = Screen->NumNPCs(); i >= 1; i--)
		{
			npc n = Screen->LoadNPC(i);
			if(n->Type != NPCT_PROJECTILE && n->Type != NPCT_FAIRY && n->Type != NPCT_TRAP && n->Type != NPCT_GUY)
				if(!(n->MiscFlags&(1<<3)))
					return true;
		}
		return false;
	} //end
} //end

ffc script TorchFirePaths //start
{
	using namespace WaterPaths;
	
	void run(int layers)
	{
		while(true)
		{
			for(int q = Screen->NumLWeapons(); q > 0; --q)
			{
				lweapon wep = Screen->LoadLWeapon(q);
				
				unless (wep->Type == LW_FIRE && GetHighestLevelItemOwned(IC_CANDLE) != 158)
					continue;
					
				int l1, l2;

				for(int q = 6; q >= 0; --q) //start calculate layers
				{
					if(layers & (1b << q))
					{
						if(l2)
						{
							l1 = q;
							break;
						}
						else 
							l2 = q;
					}
				} //end

				mapdata template = Game->LoadMapData(Game->GetCurMap(), Game->GetCurScreen());
				mapdata t1 = Emily::loadLayer(template, l1), t2 = Emily::loadLayer(template, l2);
				int cmb[4] = {ComboAt(wep->X,wep->Y),
							  ComboAt(wep->X+15, wep->Y),
							  ComboAt(wep->X, wep->Y+15),
							  ComboAt(wep->X+15, wep->Y+15)};
							  
				for(int p = 0; p < 4; ++p)
				{
					combodata cd = Game->LoadComboData(t1->ComboD[cmb[p]]);
					
					if(cd->Type == CT_FLUID)
					{
						int flag = cd->Attributes[ATTBU_FLUIDPATH];
						
						if(flag > 0)
						{
							Fluid f = getFluid(flag);
							
							if(f == FL_PURPLE)
								connectRoots(flag, FL_PURPLE, 32);
						}
					}
				}
			}
			
			Waitframe();
		}
	}
	void connectRoots(int path, Fluid sourcetype, int connectTo) //start
    {
        //start calculate pairs
        DEFINE MAX_PATH_PAIRS = MAX_PATHS * (MAX_PATHS - 1) + 1;
        int v1[MAX_PATH_PAIRS];
        int v2[MAX_PATH_PAIRS];
        
        //Cache the pairs of connected paths
        int ind = 0;
        
        for(int q = 0; q < MAX_PATHS; ++q)
        {
            int c = getConnection(Game->GetCurLevel(), q+1);
            
            unless(c)
                continue;
                
            for(int p = q+1; p < MAX_PATHS; ++p)
            {
                unless(c & (1L << p))
                    continue;
                v1[ind] = q;
                v2[ind++] = p;
            }
        }
        
        v1[ind] = -1;
        //end calculate pairs
        //start Find connections
        bool isConnected[MAX_PATHS];
		bool didSomething;
        isConnected[path-1] = true;
        do
        {
            didSomething = false;
            
            for(int q = 0; v1[q] > -1; ++q)
            {
                if(isConnected[v1[q]] ^^ isConnected[v2[q]])
                {
                    isConnected[v1[q]] = true;
                    isConnected[v2[q]] = true;
                    didSomething = true;
                }
            }
        }
        while(didSomething);
        //end Find connections
        for(int q = 0; q < MAX_PATHS; ++q)
        {
            if(isConnected[q])
            {
                if(getSource(q + 1) == FL_PURPLE)
                {
                    setConnection(Game->GetCurLevel(), q + 1, connectTo, true);
                }
            }
        }
		
		updateFluidFlow();
    } //end
} //end

// Set in rooms where fire activates the paths
ffc script TorchLight //start
{
    using namespace WaterPaths;
	
    void run(int litCombo, int path)
    {
		until(getFluid(path) == FL_FLAMING)
			Waitframe();
			
        this->Data = litCombo;
    }
} //end

// p1-p4 represent the paths that would activate the torches
ffc script ActivateTorches //start
{
	using namespace WaterPaths;
	
	void run(int p1, int p2, int p3, int p4)
	{
		if (Screen->State[ST_SECRET])
			return;
			
		until(getFluid(p1) == FL_FLAMING && getFluid(p2) == FL_FLAMING && getFluid(p3) == FL_FLAMING && getFluid(p4) == FL_FLAMING)
			Waitframe();
			
		Screen->TriggerSecrets();
		Screen->State[ST_SECRET] = true;
		Audio->PlaySound(SFX_SECRET);
	}
} //end


//~~~~~ScreenQuakeOnSecret~~~~~//
//D0: Power of the quake
@Author("Deathrider365")
ffc script ScreenQuakeOnSecret //start
{
	void run(int quakePower)
	{
		if (Screen->State[ST_SECRET])
			Quit();

		until (Screen->State[ST_SECRET])
			Waitframe();

		Screen->Quake = quakePower;
	}
} //end

ffc script TriggerSignpostsOnOtherScreens
{
	void run(int msg, bool anySide)
	{
		int loc = ComboAt(this->X, this->Y);
		
		while(true)
		{
			until(AgainstComboBase(loc, anySide) && Input->Press[CB_SIGNPOST]) 
			{
				if (AgainstComboBase(loc, anySide))
					Screen->FastCombo(7, Link->X - 10, Link->Y - 15, 48, 0, OP_OPAQUE);
					
				Waitframe();
			}			
			
			Input->Button[CB_SIGNPOST] = false;
			Game->Suspend[susptSCREENDRAW] = true;
			Screen->Message(msg);
			Game->Suspend[susptSCREENDRAW] = false;
			
			int curPosOfKid = 38;
			int curMapOfKid = 40;
			int curScrOfKid = 94;
			
			int curPosOfDad = 109;
			int curMapOfDad = 9;
			int curScrOfDad = 7;
			
			int newPosOfKid = 119;
			int newPosOfDad = 135;
			int newMapOfBoth = 9;
			
			mapdata mapOfKid = Game->LoadMapData(curMapOfKid, curScrOfKid);
			mapdata mapOfDad = Game->LoadMapData(curMapOfDad, curScrOfDad);
			
			
			
			Waitframe();
		}
	}
}





























