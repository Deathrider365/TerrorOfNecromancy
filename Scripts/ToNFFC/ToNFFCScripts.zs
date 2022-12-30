///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~~~~The Terror of Necromancy FFC Scripts~~~~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

@Author("Deathrider365")
ffc script ServusSoldier {
   void run(int itemId, int gettingItemString, int alreadyGotItemString, int itemToCheckFor) {
      mapdata template = Game->LoadTempScreen(1);
      int prevData = this->Data;
      
      if (Hero->Item[itemToCheckFor]) {
         this->Data = 0;
         template->ComboD[ComboAt(this->X + 8, this->Y + 8)] = 0;
         Quit();
      }
      
      until(getScreenD(253))  {
         this->Data = 0;
         template->ComboD[ComboAt(this->X + 8, this->Y + 8)] = 0;
         Waitframe();
      }

      template->ComboD[ComboAt(this->X + 8, this->Y + 8)] = COMBO_SOLID;
         
      this->Data = prevData;

      while(true) {
         until (Screen->State[ST_SECRET])
            Waitframe();
         
         this->Data = 6755;
            
         until(againstFFC(this->X, this->Y) && Input->Press[CB_SIGNPOST]) {
            if (againstFFC(this->X, this->Y))
               Screen->FastCombo(7, Link->X - 10, Link->Y - 15, 48, 0, OP_OPAQUE);
            Waitframe();
         }			

         Input->Button[CB_SIGNPOST] = false;

         unless (getScreenD(255)) {
            Screen->Message(gettingItemString);
            Waitframe();
            itemsprite it = CreateItemAt(itemId, Hero->X, Hero->Y);
            it->Pickup = IP_HOLDUP;
            
            Input->Button[CB_SIGNPOST] = false;
            setScreenD(255, true);
         }
         else
            Screen->Message(alreadyGotItemString);

         Waitframe();
      }
   }
}

@Author("Deathrider365")
ffc script GetItemFromSecret {
   void run(int message, int itemId, int itemX, int itemY, int screenD) {
      if (Screen->State[ST_SPECIALITEM])
         Quit();
      
      while (true) {
         if (Screen->State[ST_SECRET]) {
            CreateItemAt(itemId, itemX, itemY)->Pickup = IP_HOLDUP | IP_ST_SPECIALITEM;
            
            unless(getScreenD(screenD))
               Screen->Message(message);
            
            setScreenD(screenD, true);
            Quit();
         }
         Waitframe();
      }
   }
}

@Author("Deathrider365")
ffc script GetItem {
   void run(int hasItem, int trader, int gettingItemString, int gottenItemString, int scriptSelfTrigger, int selfTriggerValue, int layer, int screenD) {  
      CONFIG TA_KILL_SCRIPT = 1;
      CONFIG TA_START_SCRIPT = 2;
   
      CONFIG SELF_TRIGGER_ITEM = 1;
      CONFIG SELF_TRIGGER_SCREEND = 2;
      CONFIG SELF_TRIGGER_SECRETS = 3;
      
      CONFIG HIDE_FFC_UNTIL_TRIGGERED = 9999;
      
      mapdata template = Game->LoadTempScreen(layer);
      
      int prevData = this->Data;
      int prevCombo = template->ComboD[ComboAt(this->X, this->Y)];
      
      int triggerRequirement;
      
      while(true) {
         if (scriptSelfTrigger) {
            int selfTriggerAction = Floor(scriptSelfTrigger);
            int selfTriggerRequirement = (scriptSelfTrigger % 1) / 1L;
            triggerRequirement = selfTriggerRequirement;
            
            this->Data = 0;
            template->ComboD[ComboAt(this->X, this->Y)] = 0;
            
            // needed is to say you either need it, or CANNOT have it
            int neededToHave = Floor(selfTriggerValue);
            int neededValue = (selfTriggerValue % 1) / 1L;
            
            switch(selfTriggerAction) {
               case TA_KILL_SCRIPT:
                  switch(selfTriggerRequirement) {
                     case SELF_TRIGGER_ITEM:
                        if (neededToHave && Hero->Item[neededValue]) {
                           this->Data = 0;
                           template->ComboD[ComboAt(this->X, this->Y)] = 0;
                        }
                        else if (!neededToHave && !Hero->Item[neededValue]) {
                           this->Data = 0;
                           template->ComboD[ComboAt(this->X, this->Y)] = 0;
                        }
                        else {
                           this->Data = prevData;
                           template->ComboD[ComboAt(this->X, this->Y)] = prevCombo;
                        }
                        break;
                     case SELF_TRIGGER_SCREEND:
                        if (neededToHave && getScreenD(neededValue)) {
                           this->Data = 0;
                           template->ComboD[ComboAt(this->X, this->Y)] = 0;
                        }
                        else if (!neededToHave && !getScreenD(neededValue)) {
                           this->Data = 0;
                           template->ComboD[ComboAt(this->X, this->Y)] = 0;
                        }
                        else {
                           this->Data = prevData;
                           template->ComboD[ComboAt(this->X, this->Y)] = prevCombo;
                        }
                        break;
                     case SELF_TRIGGER_SECRETS:
                        if (neededToHave && Screen->State[ST_SECRET]) {
                           this->Data = 0;
                           template->ComboD[ComboAt(this->X, this->Y)] = 0;
                        }
                        else if (!neededToHave && !Screen->State[ST_SECRET]) {
                           this->Data = 0;
                           template->ComboD[ComboAt(this->X, this->Y)] = 0;
                        }
                        else {
                           this->Data = prevData;
                           template->ComboD[ComboAt(this->X, this->Y)] = prevCombo;
                        }
                  }
                  break;
               case TA_START_SCRIPT:
                  switch(selfTriggerRequirement) {
                     case SELF_TRIGGER_ITEM:
                        if (neededToHave && Hero->Item[neededValue]) {
                           this->Data = prevData;
                           template->ComboD[ComboAt(this->X, this->Y)] = prevCombo;
                        } 
                        else if (!neededToHave && Hero->Item[neededValue]) {
                           this->Data = prevData;
                           template->ComboD[ComboAt(this->X, this->Y)] = prevCombo;
                        } else {
                           this->Data = 0;
                           template->ComboD[ComboAt(this->X, this->Y)] = 0;
                        }
                        break;
                     case SELF_TRIGGER_SCREEND:
                        if (neededToHave && getScreenD(neededValue)) {
                           this->Data = prevData;
                           template->ComboD[ComboAt(this->X, this->Y)] = prevCombo;
                        } 
                        else if (!neededToHave && !getScreenD(neededValue)) {
                           this->Data = prevData;
                           template->ComboD[ComboAt(this->X, this->Y)] = prevCombo;
                        } else {
                           this->Data = 0;
                           template->ComboD[ComboAt(this->X, this->Y)] = 0;
                        }
                        break;
                     case SELF_TRIGGER_SECRETS:
                        if (neededToHave && Screen->State[ST_SECRET]) {
                           this->Data = prevData;
                           template->ComboD[ComboAt(this->X, this->Y)] = prevCombo;
                        } 
                        else if (!neededToHave && !Screen->State[ST_SECRET]) {
                           this->Data = prevData;
                           template->ComboD[ComboAt(this->X, this->Y)] = prevCombo;
                        } 
                        else if (neededValue != HIDE_FFC_UNTIL_TRIGGERED) {
                           this->Data = prevData;
                           template->ComboD[ComboAt(this->X, this->Y)] = prevCombo;
                        } else {
                           this->Data = 0;
                           template->ComboD[ComboAt(this->X, this->Y)] = 0;
                        }
                  }
                  break;
               default:
                  break;
            }
         }
         
         until(againstFFC(this->X, this->Y) && Input->Press[CB_SIGNPOST]) {
            if (againstFFC(this->X, this->Y))
               Screen->FastCombo(7, Link->X - 10, Link->Y - 15, 48, 0, OP_OPAQUE);
            Waitframe();
         }

         Input->Button[CB_SIGNPOST] = false;
         
         int itemIdOrTriggerValue = Floor(hasItem);
         int noItemTrigger = (hasItem % 1) / 1L;
         
         if (triggerRequirement == SELF_TRIGGER_SECRETS && !Screen->State[ST_SECRET]) {
            Screen->Message(gettingItemString);
            Waitframe();
            Input->Button[CB_SIGNPOST] = false;
         } else if (getScreenD(screenD) || Hero->Item[itemIdOrTriggerValue]) {
            Screen->Message(gottenItemString);
            Waitframe();
            Input->Button[CB_SIGNPOST] = false;
         } else {
            if (trader) {
               int requiredItem = Floor(trader);
               int noItemString = (trader % 1) / 1L;
               
               if (Hero->Item[requiredItem]) {
                  Screen->Message(gettingItemString);
                  setScreenD(screenD, true);
                  Waitframe();
                  
                  unless (noItemTrigger) {
                     itemsprite it = CreateItemAt(itemIdOrTriggerValue, Hero->X, Hero->Y);
                     it->Pickup = IP_HOLDUP;
                  } 
                  else
                     executeNoItemTrigger(itemIdOrTriggerValue, noItemTrigger);
                  
                  Input->Button[CB_SIGNPOST] = false;
               } else {
                  Screen->Message(noItemString);
                  Waitframe();
                  Input->Button[CB_SIGNPOST] = false;
               }
            } else {
               if (Screen->State[ST_SECRET])
                  Screen->Message(gottenItemString);
               else
                  Screen->Message(gettingItemString);
                  
               setScreenD(screenD, true);
               Waitframe();
               
               unless (noItemTrigger) {
                  itemsprite it = CreateItemAt(itemIdOrTriggerValue, Hero->X, Hero->Y);
                  it->Pickup = IP_HOLDUP;
               }
               else
                  executeNoItemTrigger(itemIdOrTriggerValue, noItemTrigger);
               
               Input->Button[CB_SIGNPOST] = false;
            }
         }
         
         Waitframe();
      }
   }
   
   void executeNoItemTrigger(int triggerValue, int triggerType) {
      switch (triggerType) {
         case TT_SCREEND_SET:
            setScreenD(triggerValue, true);
            break;
         case TT_SCREEND_NOT_SET:
            setScreenD(triggerValue, false);
            break;
         case TT_SECRETS_TRIGGERED:
            Screen->TriggerSecrets();
            Screen->State[ST_SECRET] = true;
				Audio->PlaySound(SFX_SECRET);
            break;
         default:
            break;
      }
   }
}

@Author("Tabletpillow, EmilyV99, Deathrider365")
ffc script SimpleShop {
   void run(int itemId, int price, bool boughtOnce) {
      if (!Hero->Item[ITEM_QUIVER1_SMALL] && itemId == ITEM_EXPANSION_QUIVER)
         Quit();
   
      int noStockCombo = this->Data;
      this->Data = COMBO_INVIS;
      
      itemdata itemData = Game->LoadItemData(itemId);
      int itemTile = itemData->Tile;
      int itemCSet = itemData->CSet;

      int loc = ComboAt(this->X + 8, this->Y + 8);
      char32 priceBuf[6];
      sprintf(priceBuf, "%d", price);

      while(true) {
         if(boughtOnce && Hero->Item[itemId]) {
            this->Data = noStockCombo;

            while (Hero->Item[itemId])
               Waitframe();

            this->Data = COMBO_INVIS;
         }

         Screen->FastTile(7, this->X, this->Y, itemTile, itemCSet, OP_OPAQUE);
         Screen->DrawString(7, this->X + 8, this->Y - Text->FontHeight(FONT_LA) - 2, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, priceBuf, OP_OPAQUE, SHD_SHADOWED, C_BLACK);

         if (againstItem(this->X, this->Y)) {
            Screen->FastCombo(7, Link->X - 10, Link->Y - 15, 48, 0, OP_OPAQUE);

            if(Input->Press[CB_SIGNPOST]) {
               if (Game->Counter[CR_RUPEES] >= price) {
                  Game->DCounter[CR_RUPEES] -= price;
                  item itemToBuy = CreateItemAt(itemId, Hero->X, Hero->Y);

                  switch(itemId) {
                     case ITEM_EXPANSION_BOMB:
                        numBombUpgrades++;
                        break;
                     case ITEM_EXPANSION_QUIVER:
                        numQuiverUpgrades++;
                        break;
                     case ITEM_BATTLE_ARENA_TICKET:
                        Screen->TriggerSecrets();
                        break;
                  }

                  itemToBuy->Pickup = IP_HOLDUP;
               } 
               else
                  Screen->Message(123);
               
               Input->Button[CB_SIGNPOST] = false;
            }
         }
         
         Waitframe();
      }
   }
   
   bool againstItem(int ffcX, int ffcY) {
      if (Hero->Z == 0) {
         if (Abs((Hero->X) - (ffcX)) <= 8) {
            if (Hero->Y > ffcY && Hero->Y - ffcY <= 14 && Hero->Dir == DIR_UP)
               return true;
            else if (Hero->Y < ffcY && ffcY - Hero->Y <= 10 && Hero->Dir == DIR_DOWN)
               return true;
         }
         else if (Abs((Hero->Y) - (ffcY)) <= 8) {
            if (Hero->X > ffcX && Hero->X - ffcX <= 16 && Hero->Dir == DIR_LEFT)
               return true;
            else if (Hero->X < ffcX && ffcX - Hero->X <= 16 && Hero->Dir == DIR_RIGHT)
               return true;
         }
      }
      return false;
   }
}

@Author("Deathrider365")
ffc script BuyItem {
   void run(int entryMessage, int price, int itemId, bool buyOnce, int entryMessageOnce) {
      bool alreadyBought = false;

      if (buyOnce && Hero->Item[itemId]) {
         this->Data = COMBO_INVIS;
         Quit();
      }

      char32 priceBuf[6];
      sprintf(priceBuf, "%d", price);

      Screen->DrawString(7, this->X + 8, this->Y - Text->FontHeight(FONT_LA) - 2, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, priceBuf, OP_OPAQUE, SHD_SHADOWED, C_BLACK);
      
      unless (getScreenD(entryMessageOnce))
         Screen->Message(entryMessage);
         
      if (entryMessageOnce) {
         setScreenD(entryMessageOnce, true);
      }
      
      Waitframe();
         
      while(!alreadyBought) {
         Screen->DrawString(7, this->X + 8, this->Y - Text->FontHeight(FONT_LA) - 2, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, priceBuf, OP_OPAQUE, SHD_SHADOWED, C_BLACK);
         
         if (onTop(this->X, this->Y) && Game->Counter[CR_RUPEES] >= price) {
            Game->DCounter[CR_RUPEES] -= price;
            
            item itemToBuy = CreateItemAt(itemId, Hero->X, Hero->Y);
            itemToBuy->Pickup = IP_HOLDUP;
            
            switch(itemId) {
               case ITEM_EXPANSION_BOMB:
                  numBombUpgrades++;
                  break;
               case ITEM_EXPANSION_QUIVER:
                  numQuiverUpgrades++;
                  break;
               case ITEM_BATTLE_ARENA_TICKET:
                  Screen->TriggerSecrets();
                  break;
            }
            
            alreadyBought = true;
            this->Data = COMBO_INVIS;
         }
         Waitframe();
      }
   }
}

@Author ("Moosh")
ffc script DifficultyChoice {
    void run() {
		for (int i = 0; i < 20; ++i) {
         notDuringCutsceneLink();
			Screen->Rectangle(7, 0, 0, 256, 176, C_BLACK, 1, 0, 0, 0, true, OP_OPAQUE);
			Waitframe();
		}

		enteringTransition();
      
      bool cursor = false;

		while(true) {
         notDuringCutsceneLink();
         
         Screen->FastTile(7, 96, !cursor ? 96 : 112, 46675, 0, OP_OPAQUE);
         
         if (Input->Press[CB_DOWN] || Input->Press[CB_UP]) {
            Audio->PlaySound(CURSOR_MOVEMENT_SFX);
            cursor = !cursor;
         }
            
			if (Input->Press[CB_A]) {
            Hero->Item[!cursor ? I_DIFF_NORMAL : I_DIFF_VERYHARD] = true;
            Audio->PlaySound(!cursor ? 139 : 140);

            for (int i = 0; i < 45; ++i) {
               Screen->FastTile(7, 80, !cursor ? 96 : 112, !cursor ? 46594 : 46634, 0, OP_OPAQUE);
               Screen->FastTile(7, 96, !cursor ? 96 : 112, !cursor ? 46595 : 46635, 0, OP_OPAQUE);
               Screen->FastTile(7, 112, !cursor ? 96 : 112, !cursor ? 46596 : 46636, 0, OP_OPAQUE);
               Screen->FastTile(7, 128, !cursor ? 96 : 112, !cursor ? 46597 : 46637, 0, OP_OPAQUE);
               Screen->FastTile(7, 144, !cursor ? 96 : 112, !cursor ? 46598 : 46638, 0, OP_OPAQUE);
               Screen->FastTile(7, 160, !cursor ? 96 : 112, !cursor ? 46599 : 46639, 0, OP_OPAQUE);
               Waitframe();
            }

            Waitframes(30);
            Hero->WarpEx({WT_IWARP, 5, 0x3E, -1, WARP_B, WARPEFFECT_WAVE, 0, 0, DIR_RIGHT});
			}

			Waitframe();
		}
    }
    
    void notDuringCutsceneLink() {    
      Hero->Stun = 999;
      Link->PressStart = false;
      Link->InputStart = false;
      Link->PressMap = false;
      Link->InputMap = false;
   }
}

@Author("Demonlink")
ffc script CompassBeep {
   void run() {
      if(!Screen->State[ST_ITEM] && 
         !Screen->State[ST_CHEST] &&
         !Screen->State[ST_LOCKEDCHEST] &&
         !Screen->State[ST_BOSSCHEST] &&
         !Screen->State[ST_SPECIALITEM] &&
         (Game->LItems[Game->GetCurLevel()] & LI_COMPASS))
         Audio->PlaySound(COMPASS_BEEP);
   }
}

@Author("Deathrider365")
ffc script RemoveItem {
   void run(int itemId) {
      if (Hero->Item[itemId])
         Hero->Item[itemId] = false;
   }
}

@Author("Deathrider365")
ffc script BossMusic {
	void run(int musicChoice) {
      unless(musicChoice)
         Quit();

      if (Screen->State[ST_SECRET])
         Quit();

      until (EnemiesAlive())
         Waitframe();

      switch(musicChoice) {
         case 1:
            Audio->PlayEnhancedMusic("OoT - Middle Boss.ogg", 0);
            break;
         case 2:
            Audio->PlayEnhancedMusic("Metroid Prime - Parasite Queen.ogg", 0);
            break;
         case 3:
            Audio->PlayEnhancedMusic("The Binding of Isaac - Divine Combat.ogg", 0);
            break;
         case 4:
            Audio->PlayEnhancedMusic("The Binding of Isaac - Divine Combat.ogg", 0);
            break;
         default:
            Audio->PlayEnhancedMusic(NULL, 0);
            break;
      }

      while(EnemiesAlive())
         Waitframe();
         
      char32 areaMusic[256];
      Game->GetDMapMusicFilename(Game->GetCurDMap(), areaMusic);
      Audio->PlayEnhancedMusic(areaMusic, 0);

      Quit();
	}
}

@Author ("Deathrider365")
ffc script BattleArena {
   void run(int arenaListNum, int screenD) {
      unless (Hero->Item[191]) {
         Screen->TriggerSecrets();
         setScreenD(screenD, true);
         Quit();
      }

      setScreenD(screenD, false);
      Hero->Item[191] = false;

      int round = 0;

      until (spawnEnemies(arenaListNum, round++)) {
         while(EnemiesAlive())
            Waitframe();

         Waitframes(120);
      }

      while(EnemiesAlive())
         Waitframe();

      Screen->TriggerSecrets();
      setScreenD(screenD, true);

      char32 areaMusic[256];
      Game->GetDMapMusicFilename(Game->GetCurDMap(), areaMusic);
      Audio->PlayEnhancedMusic(areaMusic, 0);
   }

   bool spawnEnemies(int arenaListNum, int round) {
      int enemyList[50];
      bool shouldReturn;

      switch(arenaListNum)
      {
         case 0: {
            Screen->Pattern = PATTERN_CEILING;
            
            switch(round) {
               case 0:
                  playBattleTheme(arenaListNum);
                  setEnemies({
                     ENEMY_OCTOROCK_LV1_SLOW, 
                     ENEMY_OCTOROCK_LV1_SLOW, 
                     ENEMY_OCTOROCK_LV1_FAST,
                     ENEMY_OCTOROCK_LV1_FAST, 
                     ENEMY_OCTOROCK_LV1_FAST, 
                     ENEMY_OCTOROCK_LV2_FAST
                  });
                  break;
               case 1:
                  setEnemies({
                     ENEMY_MOBLIN_LV1,
                     ENEMY_MOBLIN_LV1,
                     ENEMY_MOBLIN_LV1,
                     ENEMY_STALFOS_LV1,
                     ENEMY_STALFOS_LV1,
                     ENEMY_STALFOS_LV1,
                     ENEMY_ROPE_LV1,
                     ENEMY_ROPE_LV1
                  });
                  break;
               case 2:
                  setEnemies({
                     ENEMY_MOBLIN_LV2,
                     ENEMY_MOBLIN_LV2,
                     ENEMY_OCTOROCK_LV2_FAST,
                     ENEMY_OCTOROCK_LV2_FAST,
                     ENEMY_OCTOROCK_LV2_FAST,
                     ENEMY_GORIYA_LV1,
                     ENEMY_GORIYA_LV1
                  });
                  break;
               case 3:
                  setEnemies({
                     ENEMY_LEEVER_LV1_INSIDE,
                     ENEMY_LEEVER_LV1_INSIDE,
                     ENEMY_LEEVER_LV1_INSIDE,
                     ENEMY_LEEVER_LV1_INSIDE,
                     ENEMY_LEEVER_LV2_INSIDE,
                     ENEMY_LEEVER_LV2_INSIDE,
                     ENEMY_LEEVER_LV2_INSIDE
                  });
                  break;
               case 4:
                  setEnemies({
                     ENEMY_CANDLEHEAD,
                     ENEMY_CANDLEHEAD,
                     ENEMY_CANDLEHEAD
                  });
                  break;
               case 5:
                  playBossTheme(arenaListNum);
                  setEnemies({ ENEMY_OVERGROWN_RACCOON });
                  shouldReturn = true;
                  break;
            }
            break;
         }
      }
      
      Screen->SpawnScreenEnemies();
      
      return shouldReturn;
   }

   void setEnemies(int arr) {
      int enemyArray[10];

      memcpy(enemyArray, arr, SizeOfArray(arr));

      for(int q = 0; q < 10; ++q)
         Screen->Enemy[q] = enemyArray[q];
   }

   void playBattleTheme(int arenaListNum) {
      switch(arenaListNum) {
         case 0:
            Audio->PlayEnhancedMusic("Romancing Saga, MS - ACTGFKB.ogg", 0);
            break;
      }
   }
	
   void playBossTheme(int arenaListNum) {
      switch(arenaListNum) {
         case 0:
            Audio->PlayEnhancedMusic("Skies of Arcadia - Bombardment.ogg", 0);
            break;
      }
   }
}

@Author("Emily")
ffc script DisableRadialTransparency {
   void run(int pos) {
      while(true) {
         disableTrans = Screen->ComboD[pos] ? true : false;
         Waitframe();
      }
   }
}

@Author("Deathrider365")
ffc script InfoShop {
   void run(int boughtString, int price, int notBoughtMessage) {
      char32 priceBuf[6];
      sprintf(priceBuf, "%d", price);

      while(true) {
         Screen->DrawString(2, this->X + 8, this->Y - Text->FontHeight(FONT_LA) - 2, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, priceBuf, OP_OPAQUE, SHD_SHADOWED, C_BLACK);

         if (againstFFC(this->X, this->Y)) {
            Screen->FastCombo(7, Link->X - 10, Link->Y - 15, 48, 0, OP_OPAQUE);

            if(Input->Press[CB_SIGNPOST]) {
               Hero->Action = LA_NONE;
               Hero->Stun = 15;

               if (Game->Counter[CR_RUPEES] >= price) {
                  Game->DCounter[CR_RUPEES] -= price;
                  Input->Button[CB_SIGNPOST] = false;

                  for (int i = 0; i < price * 2; ++i) {
                     NoAction();
                     Waitframe();
                  }

                  Hero->Action = LA_NONE;
                  Hero->Stun = 15;

                  Screen->Message(boughtString);
               } else {
                  Input->Button[CB_SIGNPOST] = false;
                  Screen->Message(notBoughtMessage);
               }
            }
         }
         Waitframe();
      }
   }
}

@Author("Moosh")
ffc script PoisonWater {
   void run() {
      while(true) {
         until(Link->Action == LA_SWIMMING && Link->Action == LA_DIVING && Screen->ComboT[ComboAt(Link->X + 8, Link->Y + 12)] == CT_SHALLOWWATER)
            Waitframe();

         int maxDamageTimer = 120;
         int damageTimer = maxDamageTimer;

         while(Link->Action == LA_SWIMMING || Link->Action == LA_DIVING || (Screen->ComboT[ComboAt(Link->X + 8, Link->Y + 12)] == CT_SHALLOWWATER)) {
            damageTimer--;

            if(damageTimer <= 0) 
               if(Screen->ComboT[ComboAt(Link->X + 8, Link->Y + 12)] == CT_SHALLOWWATER || Link->Action == LA_SWIMMING) {
                  Link->HP -= 8;
                  Game->PlaySound(SFX_OUCH);
                  damageTimer = maxDamageTimer;
               }

            Waitframe();
         }
      }
   }
} //end

@Author("Moosh")
ffc script BurningOilandBushes {
	//start constants
	const int OILBUSH_LAYER = 2; //Layer to which burning is drawn
	const int OILBUSH_DAMAGE = 2; //Damage dealt by burning oil/bushes

	const int OILBUSH_CANTRIGGER = 1; //Set to 1 if burning objects can trigger adjacent burn triggers
	const int OILBUSH_DAMAGEENEMIES = 1; //Set to 1 if burning objects can damage enemies standing on them
	const int OILBUSH_BUSHESSTILLDROPITEMS = 1; //Set to 1 if burning bushes should still drop their items

	const int NPC_BUSHDROPSET = 177; //The ID of an Other type enemy with the tall grass dropset

	const int OILBUSH_OIL_DURATION = 180; //Duration oil burns for in frames
	const int OILBUSH_BUSH_DURATION = 60; //Duration bushes/grass burn for in frames

	const int OILBUSH_OIL_SPREAD_FREQ = 2; //How frequently burning oil spreads (should be shorter than burn duration)
	const int OILBUSH_BUSH_SPREAD_FREQ = 10; //How frequently burning bushes/grass spread

	const int CS_OIL_BURNING = 7; //was 8 CSet for burning oil
	const int OILBUSH_ENDFRAMES_OILBURN = 4; //Number of combos for oil burning out
	const int OILBUSH_ENDDURATION_OILBURN = 16; //Duration of the burning out animation

	const int CMB_BUSH_BURNING = 6344; //First combo for burning oil
	const int CS_BUSH_BURNING = 0; //CSet for burning oil (I set this to 0 since the combos are 8 bit anyway)
	const int OILBUSH_ENDFRAMES_BUSHBURN = 4; //Number of combos for bushes/grass burning out
	const int OILBUSH_ENDDURATION_BUSHBURN = 16; //Duration of the burning out animation

	const int SFX_OIL_BURN = 13; //Sound when oil catches fire
	const int SFX_BUSH_BURN = 13; //Sound when bushes catch fire

	//EWeapon and LWeapon IDs used for burning stuff.
	const int EW_OILBUSHBURN = 40; //EWeapon ID. Script 10 by default
	const int LW_OILBUSHBURN = 9; //LWeapon ID. Fire by default
	//end constants

	void run(int noOil, int noBushes, int advanceOil, int burnCSet) {
		int i; int j;
		int c;
		int ct;
		int burnTimers[176];
		int burnTypes[176];
		lweapon burnHitboxes[176];

		while(true) {
			//start Loop through all EWeapons
			for(i = Screen->NumEWeapons(); i >= 1; i--)
			{
				eweapon e = Screen->LoadEWeapon(i);

				//Only fire weapons can burn oil/bushes
				if((e->ID == EW_FIRE || e->ID == EW_FIRE2 || e->OriginalTile == 800) && GetHighestLevelItemOwned(IC_CANDLE) != 158)
				{
					c = ComboAt(CenterX(e), CenterY(e));
					//Check to make sure it isn't already burning

					if(burnTimers[c] <= 0)
					{
						//Check if oil is allowed and if the combo is a water combo
						if(!noOil && OilBush_IsWater(c))
						{
							if(SFX_OIL_BURN > 0)
								Game->PlaySound(SFX_OIL_BURN);

							burnTimers[c] = OILBUSH_OIL_DURATION;
							burnTypes[c] = 0; //Mark as an oil burn
						}
						//Else check if bushes are allowd and if the combo is a bush
						else if(!noBushes && OilBush_IsBush(c))
						{
							if(SFX_BUSH_BURN > 0)
								Game->PlaySound(SFX_BUSH_BURN);

							burnTimers[c] = OILBUSH_BUSH_DURATION;
							burnTypes[c] = 1; //Mark as a bush burn
							Screen->ComboD[c]++; //Advance to the next combo

							//If item drops are allowed, create and kill a dummy enemy
							if(OILBUSH_BUSHESSTILLDROPITEMS)
							{
								npc n = CreateNPCAt(NPC_BUSHDROPSET, ComboX(c), ComboY(c));
								n->HP = -1000;
								n->DrawYOffset = -1000;
							}
						}
					}
				}
			}//end

			if (GetHighestLevelItemOwned(IC_CANDLE) != 158) {
				//start Loop through all LWeapons
				for(i = Screen->NumLWeapons(); i >= 1; i--)
				{
					lweapon l = Screen->LoadLWeapon(i);
					//Only fire weapons can burn oil/bushes
					if(l->ID == LW_FIRE)
					{
						c = ComboAt(CenterX(l), CenterY(l));
						//Check to make sure it isn't already burning
						if(burnTimers[c] <= 0)
						{
							//Check if oil is allowed and if the combo is a water combo
							if(!noOil && OilBush_IsWater(c))
							{
								if(SFX_OIL_BURN > 0)
									Game->PlaySound(SFX_OIL_BURN);

								burnTimers[c] = OILBUSH_OIL_DURATION;
								burnTypes[c] = 0; //Mark as an oil burn
							}
							//Else check if bushes are allowd and if the combo is a bush
							else if(!noBushes && OilBush_IsBush(c))
							{
								if(SFX_BUSH_BURN > 0)
									Game->PlaySound(SFX_BUSH_BURN);

								burnTimers[c] = OILBUSH_BUSH_DURATION;
								burnTypes[c] = 1; //Mark as a bush burn
								Screen->ComboD[c]++; //Advance to the next combo

								if(OILBUSH_BUSHESSTILLDROPITEMS)
								{ //If item drops are allowed, create and kill a dummy enemy
									npc n = CreateNPCAt(NPC_BUSHDROPSET, ComboX(c), ComboY(c));
									n->HP = -1000;
									n->DrawYOffset = -1000;
								}
							}
						}
					}
				} //end
			}

			//start Loop through all Combos (spread the fire around)
			for(i = 0; i < 176; i++) {
				//If you're on fire raise your hand
				if(burnTimers[i] > 0)
				{
					int burnDuration = OILBUSH_OIL_DURATION;
					int spreadFreq = OILBUSH_OIL_SPREAD_FREQ;
					int burnEndFrames = OILBUSH_ENDFRAMES_OILBURN;
					int burnEndDuration = OILBUSH_ENDDURATION_OILBURN;

					//Bushes have different burning properties from oil
					if(burnTypes[i] == 1)
					{
						burnDuration = OILBUSH_BUSH_DURATION;
						spreadFreq = OILBUSH_BUSH_SPREAD_FREQ;
						burnEndFrames = OILBUSH_ENDFRAMES_BUSHBURN;
						burnEndDuration = OILBUSH_ENDDURATION_BUSHBURN;
					}

					//start If it has been spreadFreq frames since the burning started, spread to adjacent combos
					if(burnTimers[i] == burnDuration - spreadFreq)
					{
						//Check all four adjacent combos
						for(j = 0; j < 4; j++)
						{
							c = i; //Target combo is set to i and moved based on direction or j

							if(j == DIR_UP)
							{
								c -= 16;
								if(i < 16) //Prevent checking combo above along top edge
									continue;
							}
							else if(j == DIR_DOWN)
							{
								c += 16;

								if(i > 159) //Prevent checking combo below along bottom edge
									continue;
							}
							else if(j == DIR_LEFT)
							{
								c--;

								if(i % 16 == 0) //Prevent checking combo to the left along left edge
									continue;
							}
							else if(j == DIR_RIGHT)
							{
								c++; //Name drop

								if(i % 16 == 15) //Prevent checking combo to the right along right edge
									continue;
							}

							//If the adjacent combo isn't already burning
							if(burnTimers[c] <= 0)
							{
								//If the burning combo at i is oil
								if(burnTypes[i] == 0)
								{
									//If the adjacent combo is water, light it on fire
									if(OilBush_IsWater(c))
									{
										if(SFX_OIL_BURN > 0)
											Game->PlaySound(SFX_OIL_BURN);

										burnTimers[c] = OILBUSH_OIL_DURATION;
										burnTypes[c] = 0;
									}
									//If there's an adjacent fire trigger and the script is allowed to trigger them
									else if(ComboFI(c, CF_CANDLE1) && OILBUSH_CANTRIGGER)
									{
										lweapon l = CreateLWeaponAt(LW_FIRE, ComboX(c), ComboY(c)); //Make a weapon on top of the combo to trigger it
										l->CollDetection = 0; //Turn off its collision
										l->Step = 0; //Make it stationary
										l->DrawYOffset = -1000; //Make it invisible
									}
								}

								//Otherwise if it's a bush
								else if(burnTypes[i] == 1)
								{
									//If the adjancent combo is a bush, light it on fire
									if(OilBush_IsBush(c))
									{
										if(SFX_BUSH_BURN > 0)
											Game->PlaySound(SFX_BUSH_BURN);

										burnTimers[c] = OILBUSH_BUSH_DURATION;
										burnTypes[c] = 1; //Mark as a bush burn
										Screen->ComboD[c]++; //Advance to the next combo

										//If item drops are allowed, create and kill a dummy enemy
										if(OILBUSH_BUSHESSTILLDROPITEMS)
										{
											npc n = CreateNPCAt(NPC_BUSHDROPSET, ComboX(c), ComboY(c));
											n->HP = -1000;
											n->DrawYOffset = -1000;
										}
									}

									//If there's an adjacent fire trigger and the script is allowed to trigger them
									else if(ComboFI(c, CF_CANDLE1) && OILBUSH_CANTRIGGER)
									{
										lweapon l = CreateLWeaponAt(LW_FIRE, ComboX(c), ComboY(c)); //Make a weapon on top of the combo to trigger it
										l->CollDetection = 0; //Turn off its collision
										l->Step = 0; //Make it stationary
										l->DrawYOffset = -1000; //Make it invisible
									}
								}
							}
						}
					} //end
				}
			} //end

			//start Loop through all Combos again (actually draw the fire)
			for(i = 0; i < 176; i++)
			{
				//Check through all burning combos
				if(burnTimers[i] > 0)
				{
					//Only if enemy damaging is on
					if(OILBUSH_DAMAGEENEMIES)
					{
						//If the hitbox for the tile isn't there, recreate it
						if(!burnHitboxes[i]->isValid())
						{
							burnHitboxes[i] = CreateLWeaponAt(LW_SCRIPT10, ComboX(i), ComboY(i));
							burnHitboxes[i]->Step = 0; //Make it stationary
							burnHitboxes[i]->Dir = 8; //Make it pierce
							burnHitboxes[i]->DrawYOffset = -1000; //Make it invisible
							burnHitboxes[i]->Damage = OILBUSH_DAMAGE; //Make it deal damage
						}
					}

					//If Link is close enough, create fire hitboxes
					if(Distance(ComboX(i), ComboY(i), Link->X, Link->Y) < 48)
					{
						eweapon e = FireEWeapon(EW_SCRIPT10, ComboX(i), ComboY(i), 0, 0, OILBUSH_DAMAGE, 0, 0, EWF_UNBLOCKABLE);
						//Make the hitbox invisible
						e->DrawYOffset = -1000;
						//Make the hitbox last for one frame
						SetEWeaponLifespan(e, EWL_TIMER, 1);
						SetEWeaponDeathEffect(e, EWD_VANISH, 0);
					}

					burnTimers[i]--; //This ain't no Bible. Bushes burn up eventually.

					if (burnTimers[i] == 0 && advanceOil && Screen->ComboT[i] == CT_SHALLOWWATER)
						++Screen->ComboD[i];

					int cmbBurn;

					// if(burnTypes[i] == 0)
					// {
						// Set animation for oil burning out
						// cmbBurn = CMB_OIL_BURNING + Clamp(OILBUSH_ENDFRAMES_OILBURN - 1 - Floor(burnTimers[i] / (OILBUSH_ENDDURATION_OILBURN / OILBUSH_ENDFRAMES_OILBURN)), 0, OILBUSH_ENDFRAMES_OILBURN - 1);
						// Screen->FastCombo(OILBUSH_LAYER, ComboX(i), ComboY(i), cmbBurn, burnCSet ? burnCSet : CS_OIL_BURNING, 128);
					// }
					// else
					// {
						// Set animation for bush burning out
						// cmbBurn = CMB_BUSH_BURNING + Clamp(OILBUSH_ENDFRAMES_BUSHBURN - 1 - Floor(burnTimers[i] / (OILBUSH_ENDDURATION_BUSHBURN/OILBUSH_ENDFRAMES_BUSHBURN)), 0, OILBUSH_ENDFRAMES_BUSHBURN - 1);
						Screen->FastCombo(OILBUSH_LAYER, ComboX(i), ComboY(i), getBurningCombo(), CS_BUSH_BURNING, 128);
					// }
				}
				else
				{
					//Clean up any leftover hitboxes
					if(burnHitboxes[i]->isValid())
						burnHitboxes[i]->DeadState = 0;
				}
			} //end

			Waitframe();
		}
	}
   
   bool OilBush_IsWater(int pos) {
      int combo = Screen->ComboT[pos];
      return (combo == CT_SHALLOWWATER || combo == CT_WATER || combo == CT_SWIMWARP || combo == CT_DIVEWARP || (combo >= CT_SWIMWARPB && combo <= CT_DIVEWARPD));
   }

   bool OilBush_IsBush(int pos) {
      int combo = Screen->ComboT[pos];
      return (combo == CT_BUSHNEXT || combo == CT_BUSHNEXTC || combo == CT_TALLGRASSNEXT);
   }

   int getBurningCombo() {
      switch(GetHighestLevelItemOwned(IC_CANDLE)) {
         case 158:
            return 6344;
         case 10:
            return 6345;
         case 11:
            return 6346;
         case 150:
            return 6347;
      }
   }
}

@Author("Deathrider365")
ffc script Thrower {
   void run(int coolDown, int variance, float trigger, bool throwsItem, int projectile, int sprite, int hasArc, int sfx) {
      int lowVariance = Floor(variance);
      int highVariance = -(variance % 1) / 1L;
      
      int projectileId = Floor(projectile);
      int projectileType = (projectile % 1) / 1L;
         
      unless(coolDown)
         coolDown = 120;
         
      while (true) {
         if (wasTriggered(trigger))
            Quit();
         
         unless (coolDown) {
            if (throwsItem) {
               if (int scr = CheckItemSpriteScript("ArcingItemSprite")) {
                  itemsprite it = RunItemSpriteScriptAt(projectileId, scr, this->X, this->Y, {
                     Angle(this->X + 8, this->Y + 8, Hero->X + 8, Hero->Y + 8), 
                     5, -1, 0
                  });
                  
                  it->Pickup |= IP_TIMEOUT;
               }
            } else {
               if (!projectileType)
                  projectileType = AE_DEBUG;

               eweapon projectile = FireAimedEWeapon(projectileId, CenterX(this) - 8, CenterY(this) - 8, 0, 255, 3, sprite, -1, EWF_UNBLOCKABLE | EWF_ROTATE);

               if (hasArc) {
                  if (int scr = CheckEWeaponScript("ArcingWeapon")) {
                     if (sfx)
                        Game->PlaySound(sfx);
                     runEWeaponScript(projectile, scr, {-1, 0, projectileType});
                  }
               }
            }

            coolDown = 120 + Rand(lowVariance, highVariance);
         }

         coolDown--;
         Waitframe();
      }
   }
}

