//~~~~~~~~~~~~~~~~~~~~~~~~~~~~ String and Item FFCs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

@Author("Joe123, Deathrider365")
ffc script Signpost {
   CONFIG SMT_SCREEND = 1;
   CONFIG SMT_SECRETS = 2;
   CONFIG SMT_HAS_ITEM = 3;

   void run(int message, int warp, int hasSecondMessage, int secondMessage, bool vanishesOnSecondString, int layerToClearOnVanish) {
      int secondMessageTrigger, secondMessageTriggerValue;
      
      if (hasSecondMessage) {
         secondMessageTrigger = Floor(hasSecondMessage);
         secondMessageTriggerValue = (hasSecondMessage % 1) / 1L; 
      }
      
      if (vanishesOnSecondString) {
         handleVanishing(this, secondMessageTrigger, secondMessageTriggerValue, layerToClearOnVanish);
      }

      while(true) {
         if (vanishesOnSecondString) {
            handleVanishing(this, secondMessageTrigger, secondMessageTriggerValue, layerToClearOnVanish);
         }
         
         waitForTalking(this);
         
         // until(againstFFC(this->X, this->Y) && Input->Press[CB_SIGNPOST]) {
            // if (againstFFC(this->X, this->Y))
               // Screen->FastCombo(7, Link->X - 10, Link->Y - 15, 48, 0, OP_OPAQUE);
            // Waitframe();
         // }         
         
         Input->Button[CB_SIGNPOST] = false;
         Game->Suspend[susptSCREENDRAW] = true;
         
         switch(secondMessageTrigger) {
            case SMT_SCREEND:
               unless (getScreenD(secondMessageTriggerValue)) {
                  Screen->Message(message);
                  setScreenD(secondMessageTriggerValue, true);
               }
               else
                  Screen->Message(secondMessage);
               break;
            case SMT_SECRETS:
               unless (Screen->State[ST_SECRET])
                  Screen->Message(message);
               else
                  Screen->Message(secondMessage);
               break;
            case SMT_HAS_ITEM:
               unless (Hero->Item[secondMessageTriggerValue] || Screen->State[ST_ITEM])
                  Screen->Message(message);
               else
                  Screen->Message(secondMessage);
               break;
            default:
               Screen->Message(message);
               break;
         }
         
         Game->Suspend[susptSCREENDRAW] = false;
         Waitframe();
         
         if (warp) {
            int dmap = Floor(warp);
            int screen = (warp % 1) / 1L;
            Hero->WarpEx({WT_IWARPBLACKOUT, dmap, screen, -1, WARP_A, WARPFX_NONE, 0, 0, DIR_DOWN});
         }
      }
   }
   
   void handleVanishing(ffc combo, int secondMessageTrigger, int secondMessageTriggerValue, int layerToClearOnVanish) {
      switch(secondMessageTrigger) {
         case SMT_SCREEND:
            if (getScreenD(secondMessageTriggerValue))
               quitFFC(combo, layerToClearOnVanish);
            break;
         case SMT_SECRETS:
            if (Screen->State[ST_SECRET])
               quitFFC(combo, layerToClearOnVanish);
            break;
         case SMT_HAS_ITEM:
            if (Hero->Item[secondMessageTriggerValue] || Screen->State[ST_ITEM])
               quitFFC(combo, layerToClearOnVanish);
            break;
      }
   }
   
   void quitFFC(ffc combo, int layerToClearOnVanish) {
      combo->Data = COMBO_INVIS;
      mapdata template = Game->LoadTempScreen(layerToClearOnVanish);
      template->ComboD[ComboAt(combo->X + 8, combo->Y + 8)] = COMBO_INVIS;
      Quit();
   }
}

@Author("Deathrider365")
ffc script MessageOnce {
   void run(int message, bool dungeonString, int screenD) {
      while(Game->Suspend[susptGUYS]) 
         Waitframe();
      
      if (dungeonString) {
         unless (levelEntries[Game->GetCurLevel()]) {
            levelEntries[Game->GetCurLevel()] = true;
            Waitframe();
            Screen->Message(message);		
         }
      } else {
         unless(getScreenD(screenD))
            Screen->Message(message);
         
         setScreenD(screenD, true);
      }
   }
}

@Author("Deathrider365")
ffc script GetItemOLD {
   void run(
      int hasItem, 
      int trader, 
      int gettingItemString, 
      int gottenItemString, 
      int scriptSelfTrigger, 
      int selfTriggerValue, 
      int layer, 
      int screenD
   ) {  
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
      int finalStringForSecrets;
      
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
            
            finalStringForSecrets = neededValue;
            
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
                           Quit();
                        }
                        else if (!neededToHave && !Screen->State[ST_SECRET]) {
                           this->Data = 0;
                           template->ComboD[ComboAt(this->X, this->Y)] = 0;
                        }
                        else {
                           this->Data = prevData;
                           template->ComboD[ComboAt(this->X, this->Y)] = prevCombo;
                        }
                        break;
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
         
         if (!trader && triggerRequirement == SELF_TRIGGER_SECRETS && !Screen->State[ST_SECRET]) {
            Screen->Message(gettingItemString);
            Waitframe();
         } else if (getScreenD(screenD) || Hero->Item[itemIdOrTriggerValue]) {
            int oneFinalString = (gottenItemString % 1) / 1L;
            
            if (oneFinalString)
               Screen->Message(oneFinalString);
            else
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
                  setScreenD(layer, true);
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

@Author("Deathrider365")
ffc script SignpostTriggerFromItem {
   //D0: itemIdToCheckFor     - Item to set off the script
   //D1: stringNoItem         - string that plays when you do not have the item
   //D2: stringHasItem        - string that plays when you have the item and are setting off the script
   //D3: stringGottenItem     - string that plays when you already set off the script
   //D4: triggerToSetOff      - indicates the trigger this ffc will do (0 = secrets, 1 = screend, 2 = item(trader))
   //D4: triggerValue         - Used for ScreenD and items, secrets dont need a value to use when triggered
   //D5: selfKill             - Used for does this script kill itself once triggered
   void run(int itemIdToCheckFor, int stringNoItem, int stringHasItem, int stringGottenItem, int triggerToSetOff, int triggerValue, int selfKill) {
      CONFIG TRIGGER_SECRET = 0;
      CONFIG TRIGGER_SCREEND = 1;
      CONFIG TRIGGER_ITEM = 2;
      
      // Specifically for TRIGGER_ITEM
      int itemReceiving = Floor(triggerValue);
      int screenDToCheck = -(triggerValue % 1) / 1L;
      
      while(true) {
         if (triggerToSetOff == TRIGGER_SECRET && Screen->State[ST_SECRET]) {
            if (selfKill) {
               this->Data = COMBO_INVIS;
               Quit();
            }
            
            waitForTalking(this);
            Input->Button[CB_SIGNPOST] = false;
            Screen->Message(stringGottenItem);
            Waitframe();
         }
         else if (triggerToSetOff == TRIGGER_SCREEND && getScreenD(triggerValue)) {
            if (selfKill) {
               this->Data = COMBO_INVIS;
               Quit();
            }
            
            waitForTalking(this);
            Input->Button[CB_SIGNPOST] = false;
            Screen->Message(stringGottenItem);
            Waitframe();
         }
         else if (triggerToSetOff == TRIGGER_ITEM && Hero->Item[itemReceiving] && getScreenD(screenDToCheck)) {
            if (selfKill) {
               this->Data = COMBO_INVIS;
               Quit();
            }
            
            waitForTalking(this);
            Input->Button[CB_SIGNPOST] = false;
            Screen->Message(stringGottenItem);
            Waitframe();
         } else {
            bool justGotItem;
            
            switch(triggerToSetOff) {
               case TRIGGER_SECRET:
                  until (Hero->Item[itemIdToCheckFor]) {
                     justGotItem = waitForTalkingJustGotItem(this, itemIdToCheckFor);
                     
                     if (justGotItem)
                        break;
                        
                     Input->Button[CB_SIGNPOST] = false;
                     Screen->Message(stringNoItem);
                     Waitframe();
                  } else {
                     unless (justGotItem)
                        waitForTalking(this);
                     
                     Input->Button[CB_SIGNPOST] = false;
                     Screen->Message(stringHasItem);
                     Waitframe();
                     
                     Screen->State[ST_SECRET] = true;
                     Screen->TriggerSecrets();
                     Audio->PlaySound(SFX_SECRET);
                  }
                  break;
               case TRIGGER_SCREEND:
                  until (Hero->Item[itemIdToCheckFor]) {
                     justGotItem = waitForTalkingJustGotItem(this, itemIdToCheckFor);
                     
                     if (justGotItem)
                        break;
                     
                     Input->Button[CB_SIGNPOST] = false;
                     Screen->Message(stringNoItem);
                     Waitframe();
                  } else {
                     unless (justGotItem)
                        waitForTalking(this);
                     
                     Input->Button[CB_SIGNPOST] = false;
                     Screen->Message(stringHasItem);
                     Waitframe();
                     
                     setScreenD(triggerValue, true);
                     Audio->PlaySound(SFX_SECRET);                
                  }
                  break;
               case TRIGGER_ITEM:
                  until (Hero->Item[itemIdToCheckFor]) {
                     justGotItem = waitForTalkingJustGotItem(this, itemIdToCheckFor);
                     
                     if (justGotItem)
                        break;
                        
                     Input->Button[CB_SIGNPOST] = false;
                     Screen->Message(stringNoItem);
                     Waitframe();
                  } else {
                     unless (justGotItem)
                        waitForTalking(this);
                     
                     Input->Button[CB_SIGNPOST] = false;
                     Screen->Message(stringHasItem);
                     Waitframe();
                     
                     setScreenD(screenDToCheck, true);
                     itemsprite it = CreateItemAt(itemReceiving, Hero->X, Hero->Y);
                     it->Pickup = IP_HOLDUP;
                  }
                  break;
            }
         }
         
         Waitframe();
      }
   }
   
   bool waitForTalkingJustGotItem(ffc this, int itemId) {
      until(againstFFC(this->X, this->Y) && Input->Press[CB_SIGNPOST]) {
         if (Hero->Item[itemId]) 
            break;
            
         if (againstFFC(this->X, this->Y))
            Screen->FastCombo(7, Link->X - 10, Link->Y - 15, 48, 0, OP_OPAQUE);
         
         Waitframe();
      }
      
      if (Hero->Item[itemId]) 
         return true;
   }
}

@Author("Deathrider365")
ffc script GetItemOnScreenD {
   //start Instructions
   //D0: itemIdToReceive      - Item you will receive
   //D1: stringPreSecret      - String that plays before secrets are triggered
   //D2: stringGettingItem    - String for when you are getting the item
   //D3: stringGottenItem     - String for when you are receiving the item
   //D4: screenD              - ScreenD register to trigger once you get the item (for item that cannot be checked like rupees)
   //end
   void run(int itemIdToReceive, int stringPreScreenDSet, int stringGettingItem, int stringGottenItem, int screenDFromExternal, int screenDForThis) {
      while(true) {
         if (getScreenD(screenDFromExternal) && Hero->Item[itemIdToReceive]) {
            waitForTalking(this);
            Input->Button[CB_SIGNPOST] = false;
            Screen->Message(stringGottenItem);
            Waitframe();
         }
         else {
            until (getScreenD(screenDFromExternal)) {
               until(againstFFC(this->X, this->Y) && Input->Press[CB_SIGNPOST]) {
                  if (getScreenD(screenDFromExternal))
                     break;
                  
                  if (againstFFC(this->X, this->Y))
                     Screen->FastCombo(7, Link->X - 10, Link->Y - 15, 48, 0, OP_OPAQUE);
                     
                  Waitframe();
               }
               
               if (getScreenD(screenDFromExternal))
                  break;
               
               Input->Button[CB_SIGNPOST] = false;
               Screen->Message(stringPreScreenDSet);
               Waitframe();
            }
            
            waitForTalking(this);
            
            Input->Button[CB_SIGNPOST] = false;
            Screen->Message(stringGettingItem);
            Waitframe();
            
            itemsprite it = CreateItemAt(itemIdToReceive, Hero->X, Hero->Y);
            it->Pickup = IP_HOLDUP;
            setScreenD(screenDForThis, true);
            
            Waitframe();
         }
         
      }
   }
}

@Author("Deathrider365")
ffc script GetItemOnSecret {
   //start Instructions
   //D0: itemIdToReceive      - Item you will receive
   //D1: stringPreSecret      - String that plays before secrets are triggered
   //D2: stringGettingItem    - String for when you are getting the item
   //D3: stringGottenItem     - String for when you are receiving the item
   //D4: screenD              - ScreenD register to trigger once you get the item (for item that cannot be checked like rupees)
   //end
   void run(int itemIdToReceive, int stringPreSecret, int stringGettingItem, int stringGottenItem, int screenD) {
      while(true) {
         if ((Screen->State[ST_SECRET] && Hero->Item[itemIdToReceive]) || getScreenD(screenD)) {
            waitForTalking(this);
            Input->Button[CB_SIGNPOST] = false;
            Screen->Message(stringGottenItem);
            Waitframe();
         }
         else {
            until (Screen->State[ST_SECRET]) {
               until(againstFFC(this->X, this->Y) && Input->Press[CB_SIGNPOST]) {
                  if (Screen->State[ST_SECRET])
                     break;
                  
                  if (againstFFC(this->X, this->Y))
                     Screen->FastCombo(7, Link->X - 10, Link->Y - 15, 48, 0, OP_OPAQUE);
                     
                  Waitframe();
               }
               
               if (Screen->State[ST_SECRET])
                  break;
               
               Input->Button[CB_SIGNPOST] = false;
               Screen->Message(stringPreSecret);
               Waitframe();
            }
            
            waitForTalking(this);
            
            Input->Button[CB_SIGNPOST] = false;
            Screen->Message(stringGettingItem);
            Waitframe();
            
            itemsprite it = CreateItemAt(itemIdToReceive, Hero->X, Hero->Y);
            it->Pickup = IP_HOLDUP;
            setScreenD(screenD, true);
            
            Waitframe();
         }
         
      }
   }
}

@Author("Deathrider365")
ffc script GetItemOnItem {
   //D0: itemIdToReceive      - Item you will receive
   //D1: itemIdRequired       - A required item that can either kill the script or make the script wait until you have it
   //D2: requiredItemKills    - Whether the required item kills the script or makes it wait //TODO no it doesnt
   //D3: gettingItemString    - String for when you are getting the item
   //D4: gottenItemString     - String for when you are receiving the item
   //D5: layer                - Layer to handle solidity combo drawing for the FFC
   //D6: screenD              - ScreenD set once got item (needed if the ffc give a rupee and cannot be checked with Hero->Item[])
   //D7: doesntHaveItemString - String for when you do not have the required item
   void run(int itemIdToReceive, int itemIdRequired, int requiredItemKills, int gettingItemString, int gottenItemString, int layer, int screenD, int doesntHaveItemString) { //TODO refactor
      mapdata template = Game->LoadTempScreen(layer);
      
      int prevData = this->Data;
      int prevCombo = template->ComboD[ComboAt(this->X, this->Y)];
      
      while(true) {
         this->Data = COMBO_INVIS;
         template->ComboD[ComboAt(this->X, this->Y)] = COMBO_INVIS;
         
         if (itemIdRequired) {       
            if (requiredItemKills) {
               if (Hero->Item[itemIdRequired])
                  Quit();
            }
            else {
               this->Data = prevData;
               template->ComboD[ComboAt(this->X, this->Y)] = prevCombo;
               int doesntHaveItemStringString = Floor(doesntHaveItemString);
               int hideMe = (doesntHaveItemString % 1) / 1L;
               
               while (!Hero->Item[itemIdRequired]) {
                  if (hideMe) {
                     this->Data = COMBO_INVIS;
                     template->ComboD[ComboAt(this->X, this->Y)] = COMBO_INVIS;
                     Quit();
                  }
                  else {
                     waitForTalking(this);
                     Input->Button[CB_SIGNPOST] = false;
                     Screen->Message(doesntHaveItemStringString);
                  }
                  
                  Waitframe();
               }
            }
         }
         
         this->Data = prevData;
         template->ComboD[ComboAt(this->X, this->Y)] = prevCombo;
         
         waitForTalking(this);
         Input->Button[CB_SIGNPOST] = false;

         if (Hero->Item[itemIdToReceive] || getScreenD(screenD)) {
            Screen->Message(gottenItemString);
            Waitframe();
         } else {
            Screen->Message(gettingItemString);
            Waitframe();
            
            itemsprite it = CreateItemAt(itemIdToReceive, Hero->X, Hero->Y);
            it->Pickup = IP_HOLDUP;
            setScreenD(screenD, true);
         }
         
         Waitframe();
      }
   }
}

@Author("Deathrider365")
ffc script GetItemFromSecretAtLocation {
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

@Author("Tabletpillow, EmilyV99, Deathrider365")
ffc script Shop {
   void run(int itemId, int price, bool boughtOnce, int noMoneyString) {
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
               if (Game->Counter[CR_RUPEES] >= price) { //TODO is bugged like classic ZC
                  Game->DCounter[CR_RUPEES] -= price;
                  item itemToBuy = CreateItemAt(itemId, Hero->X, Hero->Y);

                  switch(itemId) {
                     case ITEM_EXPANSION_BOMB:
                        Game->Counter[CR_BOMB_BAG_EXPANSIONS]++;
                        break;
                     case ITEM_EXPANSION_QUIVER:
                        Game->Counter[CR_QUIVER_EXPANSIONS]++;
                        break;
                     case ITEM_BATTLE_ARENA_TICKET:
                        Screen->TriggerSecrets();
                        break;
                  }

                  itemToBuy->Pickup = IP_HOLDUP;
               } 
               else
                  Screen->Message(noMoneyString);
               
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
ffc script EgentemShrineSoldier {
   void run(int message) {
      mapdata m = Game->LoadMapData(44, 0x33);
      
      if (Game->Counter[CR_TRIFORCE_OF_COURAGE] != 2 || m->State[ST_SECRET]) {
         this->Data = COMBO_INVIS;
         mapdata template = Game->LoadTempScreen(2);
         template->ComboD[ComboAt(this->X + 8, this->Y + 8)] = COMBO_INVIS;
         Quit();
      }
      
      while (true) {
         until(againstFFC(this->X, this->Y) && Input->Press[CB_SIGNPOST]) {
            if (againstFFC(this->X, this->Y))
               Screen->FastCombo(7, Link->X - 10, Link->Y - 15, 48, 0, OP_OPAQUE);
            Waitframe();
         }         
         
         Input->Button[CB_SIGNPOST] = false;
         Game->Suspend[susptSCREENDRAW] = true;
         
         Screen->Message(message);
         Game->Suspend[susptSCREENDRAW] = false;      
         Waitframe();
      }
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
                  Game->Counter[CR_BOMB_BAG_EXPANSIONS]++;
                  Hero->Item[ITEM_EXPANSION_BOMB] = false;
                  Screen->State[ST_ITEM] = true;
                  break;
               case ITEM_EXPANSION_QUIVER:
                  Game->Counter[CR_QUIVER_EXPANSIONS]++;
                  Hero->Item[ITEM_EXPANSION_QUIVER] = false;
                  Screen->State[ST_ITEM] = true;
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

@Author("Deathrider365")
ffc script ServusSoldier {
   void run(int itemId, int gettingItemString, int alreadyGotItemString, int itemToCheckFor) {
      mapdata template = Game->LoadTempScreen(1);
      int prevData = this->Data;
      
      if (Hero->Item[itemToCheckFor]) {
         this->Data = 1;
         template->ComboD[ComboAt(this->X + 8, this->Y + 8)] = 0;
         Quit();
      }
      
      until (getScreenD(253))  {
         this->Data = 1;
         template->ComboD[ComboAt(this->X + 8, this->Y + 8)] = 0;
         Waitframe();
      }

      this->Data = prevData;
      template->ComboD[ComboAt(this->X + 8, this->Y + 8)] = COMBO_SOLID;
      
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
ffc script RemoveItem {
   void run(int itemId) {
      if (Hero->Item[itemId])
         Hero->Item[itemId] = false;
   }
}

@Author("Deathrider365")
ffc script GettingGoddessJewels {
   void run(int message, int x, int y, int itemId, int triforceCounter) {
      if (getScreenD(254))
         Quit();
      
      unless (Game->Counter[triforceCounter] == 4)
         Quit();
         
      Audio->PlayEnhancedMusic("Majora's Mask - Giant's Theme.ogg", 0);
         
      NoAction();
      Link->PressStart = false;
      Link->InputStart = false;
      Link->PressMap = false;
      Link->InputMap = false;
      
      for (int i = 120; i > 0; --i) {
         disableLink();
         Waitframe();
      }
      
      for (int i = 0; i < 32; ++i) {
         //link should walk up
         disableLink();
         
         Waitframe();
      }
      
      Screen->Message(message); //message about assembling the triforce
      
      //Link holds up all 4 shards and they assemble in the air splendidly, then the
      //triforce appears on top of the pedestal spinning and shining
      //then a message is played about how one is rewarded for assembling the triforce
      //then that respective goddess jewel appears in front of the pedestal from above the screen
      
      itemsprite it = CreateItemAt(itemId, x, y);
      it->Pickup = IP_HOLDUP | IP_ST_SPECIALITEM;
      
      setScreenD(254, true);
   }
}




