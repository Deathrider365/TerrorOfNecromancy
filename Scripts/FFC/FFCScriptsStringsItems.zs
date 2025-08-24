//~~~~~~~~~~~~~~~~~~~~~~~~~~~~ String and Item FFCs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

// clang-format off
@Author("Joe123, Deathrider365"),
@InitD0("message"),
@InitDHelp0("String to play"),
@InitD1("warp"),
@InitDHelp1("dmap.screen"),
@InitD2("hasSecondMessage"),
@InitDHelp2("second message trigger (1: screend, 2: secrets, 3: has item).trigger value (screend register, n/a, itemId)"),
@InitD3("secondMessage"),
@InitDHelp3("String to play"),
@InitD4("vanishesOnSecondString"),
@InitDHelp4("After the second string plays quit the script"),
@InitD5("remoteSecrets"),
@InitDHelp5("map.screen - If the trigger type is secrets, and they are on a different screen")
ffc script Signpost {
   // clang-format on

   CONFIG SMT_SCREEND = 1;
   CONFIG SMT_SECRETS = 2;
   CONFIG SMT_HAS_ITEM = 3;

   void run(int message, int warp, int hasSecondMessage, int secondMessage, bool vanishesOnSecondString, int remoteSecrets) {
      int secondMessageTrigger, secondMessageTriggerValue;

      if (hasSecondMessage) {
         secondMessageTrigger = Floor(hasSecondMessage);
         secondMessageTriggerValue = (hasSecondMessage % 1) / 1L;
      }

      while (true) {
         if (vanishesOnSecondString) {
            handleVanishing(this, secondMessageTrigger, secondMessageTriggerValue);
         }

         waitForTalking(this);

         Input->Button[CB_SIGNPOST] = false;
         Game->Suspend[susptSCREENDRAW] = true;

         switch (secondMessageTrigger) {
            case SMT_SCREEND:
               unless(getScreenD(secondMessageTriggerValue)) {
                  Screen->Message(message);
                  setScreenD(secondMessageTriggerValue, true);
               }
               else Screen->Message(secondMessage);
               break;
            case SMT_SECRETS:
               mapdata mapData;

               if (remoteSecrets) {
                  mapData = Game->LoadMapData(Floor(remoteSecrets), (remoteSecrets % 1) / 1L);
               }

               if ((!remoteSecrets && Screen->State[ST_SECRET]) || (remoteSecrets && mapData->State[ST_SECRET]))
                  Screen->Message(secondMessage);
               else
                  Screen->Message(message);

               break;
            case SMT_HAS_ITEM:
               unless(Hero->Item[secondMessageTriggerValue] || Screen->State[ST_ITEM]) Screen->Message(message);
               else Screen->Message(secondMessage);
               break;
            default: Screen->Message(message); break;
         }

         Game->Suspend[susptSCREENDRAW] = false;
         Waitframe();

         if (warp) {
            int dmap = Floor(warp);
            int screen = (warp % 1) / 1L;
            Hero->WarpEx({WT_IWARPBLACKOUT, dmap, screen, -1, WARP_A, 0, 0, 0, DIR_DOWN}); // TODO what is the constant for WARPFX_NONE
         }
      }
   }

   void handleVanishing(ffc this, int secondMessageTrigger, int secondMessageTriggerValue) {
      switch (secondMessageTrigger) {
         case SMT_SCREEND:
            if (getScreenD(secondMessageTriggerValue)) {
               this->Data = CMB_INVIS;
               this->Flags[FFCF_SOLID] = false;
               Quit();
            }
            break;
         case SMT_SECRETS:
            if (Screen->State[ST_SECRET]) {
               this->Data = CMB_INVIS;
               this->Flags[FFCF_SOLID] = false;
               Quit();
            }
         case SMT_HAS_ITEM:
            if (Hero->Item[secondMessageTriggerValue] || Screen->State[ST_ITEM]) {
               this->Data = CMB_INVIS;
               this->Flags[FFCF_SOLID] = false;
               Quit();
            }
            break;
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script MessageOnce {
   // clang-format on
   void run(int message, bool dungeonString, int screenD) {
      while (Game->Suspend[susptGUYS])
         Waitframe();

      if (dungeonString) {
         unless(levelEntries[Game->CurLevel]) {
            levelEntries[Game->CurLevel] = true;
            Waitframe();
            Screen->Message(message);
         }
      }
      else {
         unless(getScreenD(screenD)) Screen->Message(message);

         setScreenD(screenD, true);
      }
   }
}

// clang-format off
@Author("Deathrider365"),
@InitD0("itemIdToCheckFor"),
@InitDHelp0("Item (or counter id) to set off the script"),
@InitD1("stringNoItem"),
@InitDHelp1("string that plays when you do not have the item"),
@InitD2("stringHasItem"),
@InitDHelp2("string that plays when you have the item and are setting off the script"),
@InitD3("stringGottenItem"),
@InitDHelp3("string that plays when you already set off the script"),
@InitD4("triggerToSetOff"),
@InitDHelp4("indicates the trigger this ffc will do (0 = secrets, 1 = screend, 2 = item(trader)"),
@InitD5("triggerValue"),
@InitDHelp5("Used for ScreenD and items, secrets dont need a value to use when triggered"),
@InitD6("selfKill"),
@InitDHelp6("Used for does this script kill itself once triggered"),
@InitD7("isItemCounter"),
@InitDHelp7("For items, if triggering on an item counter this is the counter value to trigger")
ffc script SignpostTriggerFromItem {
   // clang-format on
   void run(int itemIdToCheckFor, int stringNoItem, int stringHasItem, int stringGottenItem, int triggerToSetOff, int triggerValue, int selfKill, int isItemCounter) {
      CONFIG TRIGGER_SECRET = 0;
      CONFIG TRIGGER_SCREEND = 1;
      CONFIG TRIGGER_ITEM = 2;

      // Specifically for TRIGGER_ITEM
      int itemReceiving = Floor(triggerValue);
      int screenDToCheck = -(triggerValue % 1) / 1L;

      while (true) {
         if (triggerToSetOff == TRIGGER_SECRET && Screen->State[ST_SECRET]) {
            if (selfKill) {
               this->Data = CMB_INVIS;
               this->Flags[FFCF_SOLID] = false;
               Quit();
            }

            waitForTalking(this);
            Input->Button[CB_SIGNPOST] = false;
            Screen->Message(stringGottenItem);
            Waitframe();
         }
         else if (triggerToSetOff == TRIGGER_SCREEND && getScreenD(triggerValue)) {
            if (selfKill) {
               this->Data = CMB_INVIS;
               this->Flags[FFCF_SOLID] = false;
               Quit();
            }

            waitForTalking(this);
            Input->Button[CB_SIGNPOST] = false;
            Screen->Message(stringGottenItem);
            Waitframe();
         }
         else if (triggerToSetOff == TRIGGER_ITEM && Hero->Item[itemReceiving] && getScreenD(screenDToCheck)) {
            if (selfKill) {
               this->Data = CMB_INVIS;
               Quit();
            }

            waitForTalking(this);
            Input->Button[CB_SIGNPOST] = false;
            Screen->Message(stringGottenItem);
            Waitframe();
         }
         else {
            bool justGotItem;

            switch (triggerToSetOff) {
               case TRIGGER_SECRET:
                  until(isItemCounter ? Game->Counter[itemIdToCheckFor] == isItemCounter : Hero->Item[itemIdToCheckFor]) {
                     justGotItem = waitForTalkingJustGotItem(this, itemIdToCheckFor, isItemCounter);

                     if (justGotItem)
                        break;

                     Input->Button[CB_SIGNPOST] = false;
                     Screen->Message(stringNoItem);
                     Waitframe();
                  }
                  else {
                     unless(justGotItem) waitForTalking(this);

                     Input->Button[CB_SIGNPOST] = false;
                     Screen->Message(stringHasItem);
                     Waitframe();

                     Screen->State[ST_SECRET] = true;
                     Screen->TriggerSecrets();
                     Audio->PlaySound(SFX_SECRET);
                  }
                  break;
               case TRIGGER_SCREEND:
                  until(isItemCounter ? Game->Counter[itemIdToCheckFor] == isItemCounter : Hero->Item[itemIdToCheckFor]) {
                     justGotItem = waitForTalkingJustGotItem(this, itemIdToCheckFor, isItemCounter);

                     if (justGotItem)
                        break;

                     Input->Button[CB_SIGNPOST] = false;
                     Screen->Message(stringNoItem);
                     Waitframe();
                  }
                  else {
                     unless(justGotItem) waitForTalking(this);

                     Input->Button[CB_SIGNPOST] = false;
                     Screen->Message(stringHasItem);
                     Waitframe();

                     setScreenD(triggerValue, true);
                     Audio->PlaySound(SFX_SECRET);
                  }
                  break;
               case TRIGGER_ITEM:
                  until(isItemCounter ? Game->Counter[itemIdToCheckFor] == isItemCounter : Hero->Item[itemIdToCheckFor]) {
                     justGotItem = waitForTalkingJustGotItem(this, itemIdToCheckFor, isItemCounter);

                     if (justGotItem)
                        break;

                     Input->Button[CB_SIGNPOST] = false;
                     Screen->Message(stringNoItem);
                     Waitframe();
                  }
                  else {
                     unless(justGotItem) waitForTalking(this);

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

   bool waitForTalkingJustGotItem(ffc this, int itemId, int isItemCounter) {
      until(againstFFC(this->X, this->Y) && Input->Press[CB_SIGNPOST]) {
         if (isItemCounter ? Game->Counter[itemId] == isItemCounter : Hero->Item[itemId])
            break;

         if (againstFFC(this->X, this->Y))
            Screen->FastCombo(7, Link->X - 10, Link->Y - 15, 48, 0, OP_OPAQUE);

         Waitframe();
      }

      if (isItemCounter ? Game->Counter[itemId] == isItemCounter : Hero->Item[itemId])
         return true;
      return false;
   }
}

// clang-format off
@Author("Deathrider365"),
@InitD0("message"),
@InitDHelp0("String to play once screenD set"),
@InitD1("screenD"),
@InitDHelp1("ScreenD register to trigger once you get the item (for item that cannot be checked like rupees)"),
@InitD2("screenDToRemove"),
@InitDHelp2("ScreenD register to check if this FFC is to vanish ")
ffc script SignpostTriggerFromScreenD {
   // clang-format on
   void run(int message, int screenD, int screenDToRemove) {
      int data = this->Data;
      int x = this->X;
      int y = this->Y;

      loop() {
         if (getScreenD(screenD)) {
            if (getScreenD(screenDToRemove)) {
               this->X = -1000;
               this->Y = -1000;
               Quit();
            }

            this->Data = data;
            this->X = x;
            this->Y = y;
            waitForTalking(this);
            Input->Button[CB_SIGNPOST] = false;
            Screen->Message(message);
            Waitframe();
         }
         else {
            until(getScreenD(screenD)) {
               this->X = -1000;
               this->Y = -1000;
               Waitframe();
            }
         }
         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365"),
@InitD0("message"),
@InitDHelp0("String to play before secrets are triggered"),
@InitD1("secondMessage"),
@InitDHelp1("String to play once secrets are triggered"),
@InitD2("screenD"),
@InitDHelp2("ScreenD to set to play the second message"),
@InitD3("isRemote"),
@InitDHelp3("Flag indicating that the secrets are on another screen"),
@InitD4("map"),
@InitDHelp4("Map of the remote secret"),
@InitD5("screen"),
@InitDHelp5("Screen of the remote secret"),
@InitD6("invisibleBeforeSecrets"),
@InitDHelp6("Whether the FFC is dormant before secrets are triggered")
ffc script SignpostTriggerFromSecret {
   // clang-format on
   void run(int message, int secondMessage, int screenD, bool isRemote, int map, int screen) {
      int data = this->Data;
      this->Flags[FFCF_SOLID] = false;
      this->Data = CMB_INVIS;

      if (isRemote && map < 1 && screen < 1) {
         Trace("Invalid map and screen provided to the FFC, quitting script");
         Quit();
      }

      if (map < 1)
         map = 1;
      if (screen < 1)
         screen = 1;

      mapdata mapData = Game->LoadMapData(map, screen);

      loop() {
         if ((isRemote && mapData->State[ST_SECRET]) || (!isRemote && Screen->State[ST_SECRET])) {
            this->Data = data;
            this->Flags[FFCF_SOLID] = true;

            waitForTalking(this);
            Input->Button[CB_SIGNPOST] = false;

            if (getScreenD(screenD))
               Screen->Message(secondMessage);
            else {
               Screen->Message(message);
               setScreenD(screenD, 1);
            }
         }
         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365"),
@InitD0("itemIdToReceive"),
@InitDHelp0("Item you will receive"),
@InitD1("stringPreScreenDSet"),
@InitDHelp1("String that plays before the screenD is set"),
@InitD2("stringGettingItem"),
@InitDHelp2("String for when you are getting the item"),
@InitD3("stringGottenItem"),
@InitDHelp3("String for when you already got the item"),
@InitD4("screenDFromExternal"),
@InitDHelp4("ScreenD that the external screen should set to trigger this"),
@InitD5("screenDForThis"),
@InitDHelp5("ScreenD on this screen that resolves the events of this NPC")
ffc script GetItemOnScreenD {
   // clang-format on
   void run(int itemIdToReceive, int stringPreScreenDSet, int stringGettingItem, int stringGottenItem, int screenDFromExternal, int screenDForThis) {
      while (true) {
         if (getScreenD(screenDFromExternal) && getScreenD(screenDForThis)) {
            waitForTalking(this);
            Input->Button[CB_SIGNPOST] = false;
            Screen->Message(stringGottenItem);
            Waitframe();
         }
         else {
            until(getScreenD(screenDFromExternal)) {
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

// clang-format off
@Author("Deathrider365"),
@InitD0("itemIdToReceive"),
@InitDHelp0("Item you will receive"),
@InitD1("stringPreSecret"),
@InitDHelp1("String that plays before secrets are triggered"),
@InitD2("stringGettingItem"),
@InitDHelp2("String for when you are getting the item"),
@InitD3("stringGottenItem"),
@InitDHelp3("String for when you already got the item"),
@InitD4("screenD"),
@InitDHelp4("ScreenD register to trigger once you get the item (for item that cannot be checked like rupees)"),

@Author("Deathrider365")
ffc script GetItemOnSecret {
   // clang-format on
   void run(int itemIdToReceive, int stringPreSecret, int stringGettingItem, int stringGottenItem, int screenD) {
      while (true) {
         if ((Screen->State[ST_SECRET] && Hero->Item[itemIdToReceive]) || getScreenD(screenD)) {
            waitForTalking(this);
            Input->Button[CB_SIGNPOST] = false;
            Screen->Message(stringGottenItem);
            Waitframe();
         }
         else {
            until(Screen->State[ST_SECRET]) {
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

// clang-format off
@Author("Deathrider365"),
@InitD0("itemIdToReceive"),
@InitDHelp0("Item you will receive"),
@InitD1("itemIdRequired"),
@InitDHelp1("A required item that can either kill the script or make the script wait until you have it"),
@InitD2("requiredItemKills"),
@InitDHelp2("0 - required item does not kill. 1 - Kill once it detects you have the item. 2 - Kill after getting the item"),
@InitD3("gettingItemString"),
@InitDHelp3("String for when you are getting the item"),
@InitD4("gottenItemString"),
@InitDHelp4("String for when you are receiving the item"),
@InitD5("layer"),
@InitDHelp5("Layer to handle solidity combo drawing for the FFC"),
@InitD6("screenD"),
@InitDHelp6("ScreenD set once got item (needed if the ffc give a rupee and cannot be checked with Hero->Item[])"),
@InitD7("doesntHaveItemString"),
@InitDHelp7("String for when you do not have the required item")
ffc script GetItemOnItem {
   // clang-format on

   void run(int itemIdToReceive, int itemIdRequired, int requiredItemKills, int gettingItemString, int gottenItemString, int layer, int screenD, int doesntHaveItemString) { // TODO refactor
      mapdata template = Game->LoadTempScreen(layer);

      int prevData = this->Data;
      int prevCombo = template->ComboD[ComboAt(this->X, this->Y)];

      while (true) {
         this->Data = CMB_INVIS;
         template->ComboD[ComboAt(this->X, this->Y)] = CMB_INVIS;

         if (itemIdRequired) {
            if (requiredItemKills > 0) {
               if (requiredItemKills == 1 && Hero->Item[itemIdRequired] && getScreenD(screenD)) {
                  hideSolidFFC(this, template);
               }
               if (requiredItemKills == 2 && getScreenD(screenD)) {
                  hideSolidFFC(this, template);
               }
            }
            else {
               this->Data = prevData;
               template->ComboD[ComboAt(this->X, this->Y)] = prevCombo;
               int doesntHaveItemStringString = Floor(doesntHaveItemString);
               int hideMe = (doesntHaveItemString % 1) / 1L;

               while (!Hero->Item[itemIdRequired]) {
                  if (hideMe) {
                     this->Data = CMB_INVIS;
                     template->ComboD[ComboAt(this->X, this->Y)] = CMB_INVIS;
                     this->Flags[FFCF_SOLID] = false;
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
         }
         else {
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


// clang-format off
@Author("Deathrider365"),
@InitD0("itemIdToReceive"),
@InitDHelp0("Item you will receive"),
@InitD1("screenD"),
@InitDHelp1("ScreenD to check"),
@InitD2("gettingItemString"),
@InitDHelp2("String for when you are getting the item"),
@InitD3("gottenItemString"),
@InitDHelp3("String for when you are receiving the item"),
@InitD4("screenDForThis"),
@InitDHelp4("ScreenD set once got item (needed if the ffc give a rupee and cannot be checked with Hero->Item[])")
ffc script GetItemOnScreenDHiddenBefore {
   // clang-format on
   void run(int itemIdToReceive, int screenD, int gettingItemString, int gottenItemString, int screenDForThis) {
      int prevData = this->Data;

      loop () {
         this->Data = CMB_INVIS;
         this->Flags[FFCF_SOLID] = false;

         if (getScreenD(screenD)) {
            this->Data = prevData;
            this->Flags[FFCF_SOLID] = true;

            waitForTalking(this);
            Input->Button[CB_SIGNPOST] = false;

            if (getScreenD(screenDForThis)) {
               Screen->Message(gottenItemString);
               Waitframe();
            }
            else {
               Screen->Message(gettingItemString);
               Waitframe();

               itemsprite it = CreateItemAt(itemIdToReceive, Hero->X, Hero->Y);
               it->Pickup = IP_HOLDUP;
               setScreenD(screenDForThis, true);
            }
         }
         Waitframe();
      }
   }
}

@Author("Deathrider365")
ffc script PhonogramMan {
   // clang-format on
   void run(int itemIdToReceive, int stringPreSecret, int stringGettingItem, int stringGottenItem, int screenD) {
      while (true) {
         if ((Screen->State[ST_SECRET] && Hero->Item[itemIdToReceive]) || getScreenD(screenD)) {
            waitForTalking(this);
            Input->Button[CB_SIGNPOST] = false;
            Screen->Message(stringGottenItem);
            Waitframe();
         }
         else {
            until(Screen->State[ST_SECRET]) {
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

// clang-format off
@Author("Deathrider365")
ffc script EscapedEgentemCultist {
// clang-format on
   void run(int initialMessage, int initialItemId, int secondaryMessage, int secondaryItem, int initialScreenD, int secondaryScreenD, int tertiaryMessage, int requiredItem) {
      loop() {
         waitForTalking(this);
         Input->Button[CB_SIGNPOST] = false;

         if (!getScreenD(initialScreenD)) {
            Screen->Message(initialMessage);
            Waitframe();

            itemsprite it = CreateItemAt(initialItemId, Hero->X, Hero->Y);
            it->Pickup = IP_HOLDUP;
            setScreenD(initialScreenD, true);
         } else if (getScreenD(initialScreenD) && !Hero->Item[requiredItem] && !getScreenD(secondaryScreenD)) {
            Screen->Message(secondaryMessage);
         } else if (Hero->Item[requiredItem]) {
            Screen->Message(tertiaryMessage);

            Waitframe();

            itemsprite it = CreateItemAt(secondaryItem, Hero->X, Hero->Y);
            it->Pickup = IP_HOLDUP;

            setScreenD(secondaryScreenD, true);
            Hero->Item[requiredItem] = false;
         } else {
            Screen->Message(tertiaryMessage + 1);
         }

         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script ConflatosElder {
// clang-format on
   void run(int initialMessage, int secondaryMessage, int tertiaryMessage, int initialScreenD, int requiredItemForTertiary) {
      loop() {
         waitForTalking(this);
         Input->Button[CB_SIGNPOST] = false;

         mapdata forgeBossRoom = Game->LoadMapData(61, 0x43);

         if (!getScreenD(initialScreenD)) {
            Screen->Message(initialMessage);
            Waitframe();
            setScreenD(initialScreenD, true);

            Audio->PlaySound(SFX_SECRET);
            mapdata forgeEntrance = Game->LoadMapData(20, 0x70);
            forgeEntrance->State[ST_SECRET] = true;

         } else if (getScreenD(initialScreenD) && !forgeBossRoom->State[ST_SECRET]) {
            Screen->Message(secondaryMessage);
         } else if (forgeBossRoom->State[ST_SECRET] && !Hero->Item[ITEM_RING2]) {
            Screen->Message(tertiaryMessage);
         } else if (Hero->Item[ITEM_RING2] && !getScreenD(initialScreenD + 1)) {
            Screen->Message(tertiaryMessage + 1);
            Waitframe();

            Audio->PlaySound(SFX_SECRET);
            mapdata forgeDepthsDoor = Game->LoadMapData(61, 0x16);
            forgeDepthsDoor->State[ST_SECRET] = true;
            setScreenD(initialScreenD + 1, true);
         } else if (getScreenD(initialScreenD + 1)) {
            Screen->Message(tertiaryMessage + 2);
            setScreenD(initialScreenD + 2, true);
         } else {
            Screen->Message(tertiaryMessage + 3);
         }

         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script CeloElder {
// clang-format on
   void run(int initialMessage, int messageWaiting, int messageTriggering, int messageDoneAll, int initialScreenD, int secondaryScreenD) {

      mapdata quickknifeScreen = Game->LoadMapData(66, 0x23);
      mapdata entranceToGoddessFaithfulScreen = Game->LoadMapData(20, 0x00);

      loop() {
         waitForTalking(this);
         Input->Button[CB_SIGNPOST] = false;

         if (!getScreenD(initialScreenD) && !quickknifeScreen->State[ST_SECRET]) {
            Screen->Message(initialMessage);
            Waitframe();
            setScreenD(initialScreenD, true);
         } else if (getScreenD(initialScreenD) && !quickknifeScreen->State[ST_SECRET]) {
            Screen->Message(messageWaiting);
         } else if (quickknifeScreen->State[ST_SECRET] && !entranceToGoddessFaithfulScreen->State[ST_SECRET]) {
            Screen->Message(messageTriggering);
            Waitframe();
            entranceToGoddessFaithfulScreen->State[ST_SECRET] = true;
            Audio->PlaySound(SFX_SECRET);
         } else if (entranceToGoddessFaithfulScreen->State[ST_SECRET]) {
            Screen->Message(messageDoneAll);
            Waitframe();
         }
         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script AuriElder {
// clang-format on
   void run(int initialMessage, int secondaryMessage, int tertiaryMessage, int quartupleMessage, int initialScreenD) {
      loop() {
         waitForTalking(this);
         Input->Button[CB_SIGNPOST] = false;

         if (!getScreenD(initialScreenD)) {
            Screen->Message(initialMessage);
            Waitframe();

            itemsprite it = CreateItemAt(207, Hero->X, Hero->Y);
            it->Pickup = IP_HOLDUP;
            setScreenD(initialScreenD, true);
         } else if (getScreenD(initialScreenD) && !Screen->State[ST_SECRET]) {
            Screen->Message(secondaryMessage);
         } else if (Screen->State[ST_SECRET] && !getScreenD(initialScreenD + 1)) {
            setScreenD(initialScreenD + 1, true);
            Screen->Message(tertiaryMessage);
         } else {
            Screen->Message(quartupleMessage);
         }

         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script PalusElder {
// clang-format on
   void run(int initialMessage, int secondaryMessage, int tertiaryMessage, int quartupleMessage, int initialScreenD) {
      loop() {
         waitForTalking(this);
         Input->Button[CB_SIGNPOST] = false;

         mapdata gamothRoom = Game->LoadMapData(75, 0x22);

         if (!getScreenD(initialScreenD)) {
            Screen->Message(initialMessage);
            setScreenD(initialScreenD, true);
         } else if (getScreenD(initialScreenD) && !gamothRoom->State[ST_SECRET]) {
            Screen->Message(secondaryMessage);
         } else if (gamothRoom->State[ST_SECRET] && !getScreenD(initialScreenD + 1)) {
            Screen->Message(tertiaryMessage);
            setScreenD(initialScreenD + 1, true);
         } else {
            Screen->Message(quartupleMessage);
         }

         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365"),
@InitD0("triforceToCheck"),
@InitDHelp0("Represents the counter (courage == 7, power == 8, wisdom == 9)")
ffc script TriforceDeciples {
// clang-format on
   void run(int triforceToCheck, int messageNotComplete, int secondMessageNotComplete, int messageComplete, int secondMessageComplete, int comboPosToChange) {
      loop() {
         if (getScreenD(triforceToCheck)) {
            triggerDoor(comboPosToChange);
         }

         waitForTalking(this);
         Input->Button[CB_SIGNPOST] = false;

         if (getScreenD(triforceToCheck)) {
            Screen->Message(secondMessageComplete);
         } else {
            if (!getScreenD(triforceToCheck + 10) && Game->Counter[triforceToCheck] < 4) {
               Screen->Message(messageNotComplete);
               setScreenD(triforceToCheck + 10, true);
            } else if (Game->Counter[triforceToCheck] < 4) {
               Screen->Message(secondMessageNotComplete);
               //TODO enhance to say how many shards are missing and the area where they are
               // Waitframe();
               // Screen->Message(getRemainingTriforceString(triforceToCheck));
            } else if (Game->Counter[triforceToCheck] == 4 && !getScreenD(triforceToCheck)) {
               Screen->Message(messageComplete);

               Waitframe();

               setScreenD(triforceToCheck, true);
               triggerDoor(comboPosToChange);
               Audio->PlaySound(SFX_SHUTTER_OPEN);
            }
         }
         Waitframe();
      }
   }

   // char32[] getRemainingTriforceString(int triforceToCheck) {
   //    char32 buf[16] = "hello";
   //    return buf;
   // }

   void triggerDoor(int pos) {
      mapdata mapDataLayer1 = Game->LoadTempScreen(1);
      mapDataLayer1->ComboD[pos] = 1;
      mapDataLayer1->ComboD[pos + 1] = 1;
   }
}

// clang-format off
@Author("Deathrider365")
ffc script GetItemFromSecretAtLocation {
   // clang-format on
   void run(int message, int itemId, int itemX, int itemY, int screenD) {
      if (Screen->State[ST_SPECIALITEM])
         Quit();

      while (true) {
         if (Screen->State[ST_SECRET]) {
            CreateItemAt(itemId, itemX, itemY)->Pickup = IP_HOLDUP | IP_ST_SPECIALITEM;

            unless(getScreenD(screenD)) Screen->Message(message);

            setScreenD(screenD, true);
            Quit();
         }
         Waitframe();
      }
   }
}

// clang-format off
@Author("Tabletpillow, EmilyV99, Deathrider365")
ffc script Shop {
   // clang-format on

   void run(int itemId, int basePrice, bool boughtOnce, int noMoneyString, bool activateOnSecrets) {
      int originalCombo = this->Data;

      if (activateOnSecrets) {
         until(Screen->State[ST_SECRET]) {
            this->Data = CMB_INVIS;
            Waitframe();
         }

         this->Data = originalCombo;
      }

      if (!Hero->Item[ITEM_QUIVER1_SMALL] && itemId == ITEM_EXPANSION_QUIVER
         || (itemId == ITEM_EXPANSION_QUIVER && getScreenD(ITEM_EXPANSION_QUIVER))
         || (itemId == ITEM_EXPANSION_BOMB && getScreenD(ITEM_EXPANSION_BOMB))
         )
         Quit();

      int noStockCombo = this->Data;
      this->Data = CMB_INVIS;

      itemdata itemData = Game->LoadItemData(itemId);
      int itemTile = itemData->Tile;
      int itemCSet = itemData->CSet;

      int loc = ComboAt(this->X + 8, this->Y + 8);
      char32 priceBuf[6];

      loop() {
         // if ((itemId == ITEM_EXPANSION_QUIVER || itemId == ITEM_EXPANSION_BOMB) && getScreenD(itemId)) {
         //    Quit();
         // }
         if (boughtOnce && getScreenD(itemId)) { // (Hero->Item[itemId] || itemId == ITEM_EXPANSION_QUIVER || itemId == ITEM_EXPANSION_BOMB || itemId == ITEM_HEART_PIECE)) {
            this->Data = noStockCombo;

            while (Hero->Item[itemId] || getScreenD(itemId))
               Waitframe();

            this->Data = CMB_INVIS;
         }

         int price = basePrice;

         if (!price == 0) {
            int wealthMedalId = Game->CurrentItemID(IC_WEALTHMEDAL);

            if (wealthMedalId > -1) {
               itemdata wealthMedal = Game->LoadItemData(wealthMedalId);

               if (wealthMedal->Flags[0])
                  price *= wealthMedal->Attributes[0] / 100;
               else
                  price += wealthMedal->Attributes[0];
            }

            price = Max(1, Ceiling(price));
         }

         if (price == 0)
            sprintf(priceBuf, "Free");
         else
            sprintf(priceBuf, "%d", price);

         Screen->FastTile(7, this->X, this->Y, itemTile, itemCSet, OP_OPAQUE);
         Screen->DrawString(7, this->X + 8, this->Y - Text->FontHeight(FONT_LA) - 2, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, priceBuf, OP_OPAQUE, SHD_SHADOWED, C_BLACK);

         if (againstFFC(this->X, this->Y)) {
            Screen->FastCombo(7, Link->X - 10, Link->Y - 15, 48, 0, OP_OPAQUE);

            if (Input->Press[CB_SIGNPOST]) {
               if (Game->Counter[CR_MONEY] + Game->DCounter[CR_MONEY] >= price) {
                  Game->DCounter[CR_MONEY] -= price;
                  item itemToBuy = CreateItemAt(itemId, Hero->X, Hero->Y);
                  itemToBuy->Pickup = IP_HOLDUP;

                  Waitframe();

                  if (boughtOnce && (Hero->Item[itemId] || itemId == ITEM_EXPANSION_QUIVER || itemId == ITEM_EXPANSION_BOMB || itemId == ITEM_HEART_PIECE))
                     setScreenD(itemId, 1);

                  switch (itemId) {
                     case ITEM_BATTLE_ARENA_TICKET: {
                        Screen->TriggerSecrets();
                        break;
                     }
                     case ITEM_POTION2: {
                        if (Hero->Item[30] == true)
                           Screen->Message(726);
                        else
                           Screen->Message(725);
                     }
                  }
               }
               else
                  Screen->Message(noMoneyString);

               Input->Button[CB_SIGNPOST] = false;
            }
         }

         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script BuyItem {
   // clang-format on
   void run(int entryMessage, int price, int itemId, bool buyOnce, int entryMessageOnce, int buyOnceScreenD = 0) {
      if (buyOnce && getScreenD(0)) {
         this->Data = CMB_INVIS;
         Quit();
      }

      char32 priceBuf[6];
      sprintf(priceBuf, "%d", price);

      Screen->DrawString(7, this->X + 8, this->Y - Text->FontHeight(FONT_LA) - 2, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, priceBuf, OP_OPAQUE, SHD_SHADOWED, C_BLACK);

      unless(getScreenD(entryMessageOnce)) Screen->Message(entryMessage);

      if (entryMessageOnce) {
         setScreenD(entryMessageOnce, true);
      }

      Waitframe();

      while (!getScreenD(buyOnceScreenD)) {
         Screen->DrawString(7, this->X + 8, this->Y - Text->FontHeight(FONT_LA) - 2, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, priceBuf, OP_OPAQUE, SHD_SHADOWED, C_BLACK);

         if (onTop(this->X, this->Y) && Game->Counter[CR_MONEY] >= price) {
            Game->DCounter[CR_MONEY] -= price;

            item itemToBuy = CreateItemAt(itemId, Hero->X, Hero->Y);
            itemToBuy->Pickup = IP_HOLDUP;

            if (buyOnce)
               setScreenD(buyOnceScreenD, true);

            switch (itemId) {
               case ITEM_BATTLE_ARENA_TICKET:
                  this->Data = CMB_INVIS;
                  Screen->TriggerSecrets();
                  Quit();
                  break;
            }

            this->Data = CMB_INVIS;
         }
         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script InfoShop {
   // clang-format on
   void run(int boughtString, int price, int notBoughtMessage) {
      char32 priceBuf[6];
      sprintf(priceBuf, "%d", price);

      while (true) {
         if (getScreenD(this->ID))
            Screen->DrawString(2, this->X + 8, this->Y - Text->FontHeight(FONT_LA) - 2, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, "Read", OP_OPAQUE, SHD_SHADOWED, C_BLACK);
         else
            Screen->DrawString(2, this->X + 8, this->Y - Text->FontHeight(FONT_LA) - 2, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, priceBuf, OP_OPAQUE, SHD_SHADOWED, C_BLACK);

         if (againstFFC(this->X, this->Y)) {
            Screen->FastCombo(7, Link->X - 10, Link->Y - 15, 48, 0, OP_OPAQUE);

            if (Input->Press[CB_SIGNPOST]) {
               Hero->Action = LA_NONE;
               Hero->Stun = 15;

               if (getScreenD(this->ID))
                  Screen->Message(boughtString);
               else if (Game->Counter[CR_MONEY] >= price) {
                  Game->DCounter[CR_MONEY] -= price;
                  Input->Button[CB_SIGNPOST] = false;

                  for (int i = 0; i < price * 2; ++i) {
                     NoAction();
                     Waitframe();
                  }

                  Hero->Action = LA_NONE;
                  Hero->Stun = 15;

                  Screen->Message(boughtString);
                  setScreenD(this->ID, 1);
               }
               else
                  Screen->Message(notBoughtMessage);

               Input->Button[CB_SIGNPOST] = false;
            }
         }
         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script ServusSoldier {
   // clang-format on
   void run(int itemId, int gettingItemString, int alreadyGotItemString, int itemToCheckFor) {
      if (Hero->Item[itemToCheckFor]) {
         this->Data = 0;
         Quit();
      }

      // While waiting for the torches to be lit
      until(getScreenD(253)) {
         this->Data = 1;
         this->Flags[FFCF_SOLID] = false;
         Waitframe();
      }

      this->Flags[FFCF_SOLID] = true;
      this->Data = 6709;

      until(Screen->State[ST_SECRET]) Waitframe();

      this->Data = 6755;

      loop() {
         until(againstFFC(this->X, this->Y) && Input->Press[CB_SIGNPOST]) {
            if (againstFFC(this->X, this->Y))
               Screen->FastCombo(7, Link->X - 10, Link->Y - 15, 48, 0, OP_OPAQUE);
            Waitframe();
         }

         Input->Button[CB_SIGNPOST] = false;

         unless(getScreenD(255)) {
            Screen->Message(gettingItemString);
            Waitframe();
            itemsprite it = CreateItemAt(itemId, Hero->X, Hero->Y);
            it->Pickup = IP_HOLDUP;

            Input->Button[CB_SIGNPOST] = false;
            setScreenD(255, true);
         }
         else Screen->Message(alreadyGotItemString);

         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script RemoveItem {
   // clang-format on
   void run(int itemId) {
      if (Hero->Item[itemId])
         Hero->Item[itemId] = false;
   }
}

// clang-format off
@Author("Deathrider365")
ffc script GettingGoddessJewels {
   // clang-format on
   void run(int message, int x, int y, int itemId, int triforceCounter) {
      if (getScreenD(254))
         Quit();

      unless(Game->Counter[triforceCounter] == 4) Quit();

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
         // link should walk up
         disableLink();

         Waitframe();
      }

      Screen->Message(message); // message about assembling the triforce

      // Link holds up all 4 shards and they assemble in the air splendidly, then the
      // triforce appears on top of the pedestal spinning and shining
      // then a message is played about how one is rewarded for assembling the triforce
      // then that respective goddess jewel appears in front of the pedestal from above the screen

      itemsprite it = CreateItemAt(itemId, x, y);
      it->Pickup = IP_HOLDUP | IP_ST_SPECIALITEM;

      setScreenD(254, true);
   }
}

// clang-format off
@Author("Deathrider365"),
@InitD0("message"),
@InitDHelp0("first message"),
@InitD1("secondMessage"),
@InitDHelp1("second message"),
@InitD2("thirdMessage"),
@InitDHelp2("third message")
ffc script GoronForemanDialogLvl6 {
   // clang-format on
   void run(int message, int secondMessage, int thirdMessage) {
      loop() {
         waitForTalking(this);
         Input->Button[CB_SIGNPOST] = false;
         mapdata mapData = Game->LoadMapData(107, 0x48);

         if (mapData->State[ST_SECRET] == true)
            Screen->Message(thirdMessage);
         else if (getScreenD(1)) {
            int savedGorons = getRemaingingGorons();

            Trace(secondMessage + savedGorons);

            Screen->Message(secondMessage + savedGorons);
         }
         else {
            Screen->Message(message);
            setScreenD(1, true);
         }

         Waitframe();
      }
   }

   int getRemaingingGorons() {
      int goronsSaved = 0;

      if (getScreenD(67, 0x13, 0)) {
         setScreenD(0, true);
         ++goronsSaved;
      }
      if (getScreenD(67, 0x44, 1)) {
         setScreenD(1, true);
         ++goronsSaved;
      }
      if (getScreenD(68, 0x41, 2)) {
         setScreenD(2, true);
         ++goronsSaved;
      }
      if (getScreenD(68, 0x14, 3)) {
         setScreenD(3, true);
         ++goronsSaved;
      }
      if (getScreenD(69, 0x12, 4)) {
         setScreenD(4, true);
         ++goronsSaved;
      }
      if (getScreenD(69, 0x75, 5)) {
         setScreenD(5, true);
         ++goronsSaved;
      }

      return goronsSaved;
   }
}
