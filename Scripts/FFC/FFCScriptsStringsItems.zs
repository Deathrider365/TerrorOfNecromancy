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
@InitDHelp5("map.screen - If the trigger type is secrets, and they are on a different screen"),
@InitD6("onlyBottom"),
@InitDHelp6("Is talking to this signpost only from the bottom?"),
@InitD7("secondMessageOnScreenDSet"),
@InitDHelp7("False - sets own screenD from first message then plays second\n True - doesnt set a screenD, relies on external setting")
ffc script Signpost { //TODO bugged, the vanishOnSecondScreen doesnt work, the ffc vanishes BEFORE the second message
   // clang-format on

   CONFIG SMT_SCREEND = 1;
   CONFIG SMT_SECRETS = 2;
   CONFIG SMT_HAS_ITEM = 3;

   void run(int message, int warp, int hasSecondMessage, int secondMessage, bool vanishesOnSecondString, int remoteSecrets, bool onlyBottom, bool secondMessageOnScreenDSet = false) {
      int secondMessageTrigger, secondMessageTriggerValue;

      if (hasSecondMessage) {
         secondMessageTrigger = Floor(hasSecondMessage);
         secondMessageTriggerValue = (hasSecondMessage % 1) / 1L;
      }

      loop () {
         if (vanishesOnSecondString) {
            handleVanishing(this, secondMessageTrigger, secondMessageTriggerValue);
         }

         waitForTalking(this, onlyBottom);

         switch (secondMessageTrigger) {
            case SMT_SCREEND:
               if (secondMessageOnScreenDSet) {
                  if (!getScreenD(secondMessageTriggerValue))
                     Screen->Message(message);
                  else
                     Screen->Message(secondMessage);
               }
               else {
                  unless(getScreenD(secondMessageTriggerValue)) {
                     Screen->Message(message);
                     setScreenD(secondMessageTriggerValue, true);
                  }
                  else
                     Screen->Message(secondMessage);
               }

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

         Waitframe();
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
ffc script MessageOnce { //TODO enhance to have a popup that shows the music playing
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
            Screen->Message(stringGottenItem);
            Waitframe();
         }
         else if (triggerToSetOff == TRIGGER_ITEM && Hero->Item[itemReceiving] && getScreenD(screenDToCheck)) {
            if (selfKill) {
               this->Data = CMB_INVIS;
               this->Flags[FFCF_SOLID] = false;
               Quit();
            }

            waitForTalking(this);
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

                     Input->Button[CB_A] = false;
                     Screen->Message(stringNoItem);
                     Waitframe();
                  }
                  else {
                     unless(justGotItem) waitForTalking(this);

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

                     Input->Button[CB_A] = false;
                     Screen->Message(stringNoItem);
                     Waitframe();
                  }
                  else {
                     unless(justGotItem) waitForTalking(this);

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

                     Input->Button[CB_A] = false;
                     Screen->Message(stringNoItem);
                     Waitframe();
                  }
                  else {
                     unless(justGotItem) waitForTalking(this);

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
      until(againstFFC(this->X, this->Y) && Input->Press[CB_A]) {
         if (isItemCounter ? Game->Counter[itemId] == isItemCounter : Hero->Item[itemId])
            break;

         if (againstFFC(this->X, this->Y))
            Screen->FastCombo(7, Hero->X - 10, Hero->Y - 15, 48, 0, OP_OPAQUE);

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
   void run(int message, int screenD, int screenDToRemove) { //TODO refactor, why am I messing with the location of the ffc and not just removing solidity and hiding?
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

            if (getScreenD(screenD))
               Screen->Message(secondMessage);
            else {
               Screen->Message(message);
               setScreenD(screenD, true);
            }
         }
         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script SignpostRemoveOnSecret {
   // clang-format on
   void run(int initialMessage, int secondaryMessage, int screenDForSecondMessage, bool secretsAreRemote, int map, int screen) {
      if ((secretsAreRemote && Game->LoadMapData(map, screen)->State[ST_SECRET]) || Screen->State[ST_SECRET]) {
         this->Data = CMB_INVIS;
         this->Flags[FFCF_SOLID] = false;
         Quit();
      }

      loop() {
         until(againstFFC(this->X, this->Y) && Input->Press[CB_A]) {
            if ((secretsAreRemote && Game->LoadMapData(map, screen)->State[ST_SECRET]) || Screen->State[ST_SECRET]) {
               this->Data = CMB_INVIS;
               this->Flags[FFCF_SOLID] = false;
               Quit();
            }

            if (againstFFC(this->X, this->Y))
               Screen->FastCombo(7, Hero->X - 10, Hero->Y - 15, 48, 0, OP_OPAQUE);

            Waitframe();
         }

         Input->Button[CB_A] = false;

         if (!getScreenD(screenDForSecondMessage) || !secondaryMessage) {
            Screen->Message(initialMessage);
            setScreenD(screenDForSecondMessage, true);
         }
         else
            Screen->Message(secondaryMessage);

         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script SignpostTriggerOnItemAndVanishOnSecret {
   // clang-format on
   void run(int itemId, int noItemMessage, int hasItemMesssage, int lastMessage, int screenDForSecondMessage, int screenDForLastMessage) {
      if (Screen->State[ST_SECRET]) {
         this->Data = CMB_INVIS;
         this->Flags[FFCF_SOLID] = false;
         Quit();
      }

      loop() {
         until(againstFFC(this->X, this->Y) && Input->Press[CB_A]) {
            if (Screen->State[ST_SECRET]) {
               this->Data = CMB_INVIS;
               this->Flags[FFCF_SOLID] = false;
               Quit();
            }

            if (againstFFC(this->X, this->Y))
               Screen->FastCombo(7, Hero->X - 10, Hero->Y - 15, 48, 0, OP_OPAQUE);

            Waitframe();
         }

         Input->Button[CB_A] = false;

         if (!Hero->Item[itemId])
            Screen->Message(noItemMessage);
         else if (getScreenD(screenDForSecondMessage) && !getScreenD(screenDForLastMessage)) {
            Screen->Message(hasItemMesssage);
            setScreenD(screenDForLastMessage, true);
         }
         else if (getScreenD(screenDForLastMessage))
            Screen->Message(lastMessage);
         else
            Screen->Message(noItemMessage);

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
            Screen->Message(stringGottenItem);
            Waitframe();
         }
         else {
            until(getScreenD(screenDFromExternal)) {
               until(againstFFC(this->X, this->Y) && Input->Press[CB_A]) {
                  if (getScreenD(screenDFromExternal))
                     break;

                  if (againstFFC(this->X, this->Y))
                     Screen->FastCombo(7, Hero->X - 10, Hero->Y - 15, 48, 0, OP_OPAQUE);

                  Waitframe();
               }

               if (getScreenD(screenDFromExternal))
                  break;

               Input->Button[CB_A] = false;
               Screen->Message(stringPreScreenDSet);
               Waitframe();
            }

            waitForTalking(this);

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
            Screen->Message(stringGottenItem);
            Waitframe();
         }
         else {
            until(Screen->State[ST_SECRET]) {
               until(againstFFC(this->X, this->Y) && Input->Press[CB_A]) {
                  if (Screen->State[ST_SECRET])
                     break;

                  if (againstFFC(this->X, this->Y))
                     Screen->FastCombo(7, Hero->X - 10, Hero->Y - 15, 48, 0, OP_OPAQUE);

                  Waitframe();
               }

               if (Screen->State[ST_SECRET])
                  break;

               Input->Button[CB_A] = false;
               Screen->Message(stringPreSecret);
               Waitframe();
            }

            waitForTalking(this);

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
@InitD2("requiredItemBehavior"),
@InitDHelp2("0 - required item does not kill.\n 1 - Kill once it detects you have the required item.\n 2 - Kill after getting their item.\n 3 - Hide until you get the required item"),
@InitD3("gettingItemString"),
@InitDHelp3("String for when you are getting the item"),
@InitD4("gottenItemString"),
@InitDHelp4("String for when you are receiving the item"),
@InitD5("doesntHaveItemString"),
@InitDHelp5("String for when you do not have the required item"),
@InitD6("removeItemId"),
@InitDHelp6("When getting the new item, remove this item"),
@InitD7("setItemState"),
@InitDHelp7("Whether this script should set item state once item is obtained")
ffc script GetItemOnItem { //TODO overhaul this script
   // clang-format on

   void run(int itemIdToReceive, int itemIdRequired, int requiredItemBehavior, int gettingItemString, int gottenItemString, int doesntHaveItemString, int removeItemId, bool setItemState) {
      int prevData = this->Data;

      loop () {
         this->Data = CMB_INVIS;
         this->Flags[FFCF_SOLID] = false;

         if (itemIdRequired) {
            if (requiredItemBehavior > 0) {
               if (requiredItemBehavior == 1 && Hero->Item[itemIdRequired] && getScreenD(itemIdToReceive))
                  Quit();
               if (requiredItemBehavior == 2 && getScreenD(itemIdToReceive)) {
                  if (itemIdToReceive == itemIdRequired && !getScreenD(gottenItemString)) {
                     this->Data = prevData;
                     this->Flags[FFCF_SOLID] = true;
                     waitForTalking(this);
                     Screen->Message(gottenItemString);
                     Waitframe();

                     setScreenD(gottenItemString, true);
                  }

                  this->Data = CMB_INVIS;
                  this->Flags[FFCF_SOLID] = false;

                  Quit();
               }
            }
            else {
               this->Data = prevData;
               this->Flags[FFCF_SOLID] = true;

               while (!Hero->Item[itemIdRequired]) {
                  waitForTalking(this);

                  if (!doesntHaveItemString) {
                     this->Data = CMB_INVIS;
                     this->Flags[FFCF_SOLID] = false;
                     Quit();
                  }
                  else if (getScreenD(itemIdToReceive))
                     Screen->Message(gottenItemString);
                  else
                     Screen->Message(doesntHaveItemString);

                  Waitframe();
               }
            }
         }

         if (requiredItemBehavior == 3)
            until (Hero->Item[itemIdRequired])
               Waitframe();

         this->Data = prevData;
         this->Flags[FFCF_SOLID] = true;

         waitForTalking(this);

         if (getScreenD(itemIdToReceive)) {
            Screen->Message(gottenItemString);
            Waitframe();
         }
         else {
            Screen->Message(gettingItemString);
            Waitframe();

            itemsprite it = CreateItemAt(itemIdToReceive, Hero->X, Hero->Y);
            it->Pickup = IP_HOLDUP;

            if (setItemState)
               Screen->State[ST_ITEM] = true;

            if (removeItemId > 0)
               Hero->Item[removeItemId] = false;

            setScreenD(itemIdToReceive, true);
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
   CONFIG COMBO_A_BUTTON = 48;
   CONFIG COMBO_B_BUTTON = 49;

   void run(int itemId, int basePrice, bool boughtOnce, int noMoneyString, bool activateOnSecrets, int newPriceOnSecrets = -1, int itemInfoMessage = 0) {
      int thisData = this->Data;

      if ((newPriceOnSecrets > -1) && Screen->State[ST_SECRET])
         basePrice = newPriceOnSecrets;

      if (activateOnSecrets) {
         until(Screen->State[ST_SECRET]) {
            this->Data = CMB_INVIS;
            Waitframe();
         }

         this->Data = thisData;
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
         if (boughtOnce && getScreenD(itemId)) {
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
            Screen->FastCombo(7, Hero->X - 10, Hero->Y - 15, COMBO_A_BUTTON, 0, OP_OPAQUE);

            if (itemInfoMessage > 0)
               Screen->FastCombo(7, Hero->X + 10, Hero->Y - 15, COMBO_B_BUTTON, 0, OP_OPAQUE);

            if (Input->Press[CB_A]) {
               if ((Game->Counter[CR_MONEY] + Game->DCounter[CR_MONEY]) >= price) {
                  this->Data = CMB_INVIS;

                  Waitframe();

                  Game->DCounter[CR_MONEY] -= price;

                  int upgradedPotion = itemId;

                  if (Hero->Item[ITEM_POTION1] && itemId == ITEM_POTION2)
                     upgradedPotion = ITEM_POTION3;

                  item itemToBuy = CreateItemAt(upgradedPotion, Hero->X, Hero->Y);
                  itemToBuy->Pickup = IP_HOLDUP;

                  Waitframe();

                  if (boughtOnce && (Hero->Item[itemId] || itemId == ITEM_EXPANSION_QUIVER || itemId == ITEM_EXPANSION_BOMB || itemId == ITEM_HEART_PIECE))
                     setScreenD(itemId, true);

                  switch (itemId) {
                     case ITEM_BATTLE_ARENA_TICKET: {
                        Screen->TriggerSecrets();
                        break;
                     }
                  }
               }
               else
                  Screen->Message(noMoneyString);

               Input->Button[CB_A] = false;
               // this->Data = thisData;
            }
            else if (Input->Press[CB_B] && itemInfoMessage > -1) {
               Screen->Message(itemInfoMessage);
               Input->Button[CB_B] = false;
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
      if (buyOnce && getScreenD(buyOnceScreenD)) {
         this->Data = CMB_INVIS;
         Quit();
      }

      if (itemId == Hero->Item[ITEM_BATTLE_ARENA_TICKET])
         if (Hero->Item[ITEM_BATTLE_ARENA_TICKET])
            Screen->State[ST_SECRET] = false;

      char32 priceBuf[6];
      sprintf(priceBuf, "%d", price);

      Screen->DrawString(7, this->X + 8, this->Y - Text->FontHeight(FONT_LA) - 2, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, priceBuf, OP_OPAQUE, SHD_SHADOWED, C_BLACK);

      unless(getScreenD(entryMessageOnce)) Screen->Message(entryMessage);

      if (entryMessageOnce)
         setScreenD(entryMessageOnce, true);

      Waitframe();

      while (!getScreenD(buyOnceScreenD)) {
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
         else
            Screen->DrawString(7, this->X + 8, this->Y - Text->FontHeight(FONT_LA) - 2, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, priceBuf, OP_OPAQUE, SHD_SHADOWED, C_BLACK);

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
         if (getScreenD(this->ID % 128)) //% 128 for regions
            Screen->DrawString(3, this->X + 8, this->Y - Text->FontHeight(FONT_LA) - 2, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, "Read", OP_OPAQUE, SHD_SHADOWED, C_BLACK);
         else
            Screen->DrawString(3, this->X + 8, this->Y - Text->FontHeight(FONT_LA) - 2, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, priceBuf, OP_OPAQUE, SHD_SHADOWED, C_BLACK);

         if (againstFFC(this->X, this->Y)) {
            Screen->FastCombo(7, Hero->X - 10, Hero->Y - 15, 48, 0, OP_OPAQUE);

            if (Input->Press[CB_A]) {
               Hero->Action = LA_NONE;
               Hero->Stun = 15;

               if (getScreenD(this->ID % 128)) //% 128 for regions
                  Screen->Message(boughtString);
               else if (Game->Counter[CR_MONEY] >= price) {
                  Game->DCounter[CR_MONEY] -= price;
                  Input->Button[CB_A] = false;

                  for (int i = 0; i < price * 2; ++i) {
                     NoAction();
                     Waitframe();
                  }

                  Hero->Action = LA_NONE;
                  Hero->Stun = 15;

                  Screen->Message(boughtString);
                  setScreenD(this->ID, true);
               }
               else
                  Screen->Message(notBoughtMessage);

               Input->Button[CB_A] = false;
            }
         }
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
      if (getScreenD(0))
         Quit();

      unless(Game->Counter[triforceCounter] == 4) Quit();

      Audio->PlayEnhancedMusic("Majora's Mask - Giant's Theme.ogg", 0);

      for (int i = 0; i < 60; ++i) {
         NoAction();
         Hero->PressStart = false;
         Hero->InputStart = false;
         Hero->PressMap = false;
         Hero->InputMap = false;
      }

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

      setScreenD(0, true);
   }
}

ffc script RemoveItemIfHasItem {
   void run(int itemIdTocheck, int itemIdToRemove, int screenDToKill) {
      if (screenDToKill && getScreenD(screenDToKill)) Quit();

      loop() {
         if (Hero->Item[itemIdTocheck]) {
            Hero->Item[itemIdToRemove] = false;

            if (screenDToKill) setScreenD(screenDToKill, true);
         }
         Waitframe();
      }
   }
}