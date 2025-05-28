//~~~~~~~~~~~~~~~~~~~~~~~~~~~~ String and Item FFCs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

// clang-format off
@Author("Joe123, Deathrider365"),
@InitD0("message"),
@InitDHelp0("String to play"),
@InitD1("warp"),
@InitDHelp1("dmap.screen"),
@InitD2("hasSecondMessage"),
@InitDHelp2("second message trigger (0: screend, 1: secrets, 2: has item).trigger value (screend register, n/a, itemId)"),
@InitD3("secondMessage"),
@InitDHelp3("String to play"),
@InitD4("vanishesOnSecondString"),
@InitDHelp4("After the second string plays quit the script"),
@InitD5("layerToClearOnVanish"),
@InitDHelp5("Layer to handle solidity combo drawing for the FFC")
ffc script Signpost {
   // clang-format on

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

      while (true) {
         if (vanishesOnSecondString) {
            handleVanishing(this, secondMessageTrigger, secondMessageTriggerValue, layerToClearOnVanish);
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
               unless(Screen->State[ST_SECRET]) Screen->Message(message);
               else Screen->Message(secondMessage);
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

   void handleVanishing(ffc combo, int secondMessageTrigger, int secondMessageTriggerValue, int layerToClearOnVanish) {
      switch (secondMessageTrigger) {
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

   // TODO: remove this since combos can be solid now
   void quitFFC(ffc combo, int layerToClearOnVanish) {
      if (layerToClearOnVanish > -1) {
         combo->Data = COMBO_INVIS;
         mapdata template = Game->LoadTempScreen(layerToClearOnVanish);
         template->ComboD[ComboAt(combo->X + 8, combo->Y + 8)] = COMBO_INVIS;
         Quit();
      }
      Quit();
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
@InitDHelp1("ScreenD register to trigger once you get the item (for item that cannot be checked like rupees)")
ffc script SignpostTriggerFromScreenD {
   // clang-format on
   void run(int message, int screenD) {
      int data = this->Data;
      int x = this->X;
      int y = this->Y;

      while (true) {
         if (getScreenD(screenD)) {
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
@Author("Deathrider365")
ffc script GetItemOnScreenD {
   // clang-format on
   // start Instructions
   // D0: itemIdToReceive      - Item you will receive
   // D1: stringPreSecret      - String that plays before secrets are triggered
   // D2: stringGettingItem    - String for when you are getting the item
   // D3: stringGottenItem     - String for when you are receiving the item
   // D4: screenD              - ScreenD register to trigger once you get the item (for item that cannot be checked like rupees)
   // end
   void run(int itemIdToReceive, int stringPreScreenDSet, int stringGettingItem, int stringGottenItem, int screenDFromExternal, int screenDForThis) {
      while (true) {
         if (getScreenD(screenDFromExternal) && Hero->Item[itemIdToReceive]) {
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
@Author("Deathrider365")
ffc script GetItemOnSecret {
   // clang-format on
   // start Instructions
   // D0: itemIdToReceive      - Item you will receive
   // D1: stringPreSecret      - String that plays before secrets are triggered
   // D2: stringGettingItem    - String for when you are getting the item
   // D3: stringGottenItem     - String for when you are receiving the item
   // D4: screenD              - ScreenD register to trigger once you get the item (for item that cannot be checked like rupees)
   // end
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
         this->Data = COMBO_INVIS;
         template->ComboD[ComboAt(this->X, this->Y)] = COMBO_INVIS;

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
                     this->Data = COMBO_INVIS;
                     template->ComboD[ComboAt(this->X, this->Y)] = COMBO_INVIS;
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

   void run(int itemId, int price, bool boughtOnce, int noMoneyString, bool activateOnSecrets) {
      int originalCombo = this->Data;

      if (activateOnSecrets) {
         until(Screen->State[ST_SECRET]) {
            this->Data = COMBO_INVIS;
            Waitframe();
         }

         this->Data = originalCombo;
      }

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

      while (true) {
         if (boughtOnce && Hero->Item[itemId]) {
            this->Data = noStockCombo;

            while (Hero->Item[itemId])
               Waitframe();

            this->Data = COMBO_INVIS;
         }

         Screen->FastTile(7, this->X, this->Y, itemTile, itemCSet, OP_OPAQUE);
         Screen->DrawString(7, this->X + 8, this->Y - Text->FontHeight(FONT_LA) - 2, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, priceBuf, OP_OPAQUE, SHD_SHADOWED, C_BLACK);

         if (againstItem(this->X, this->Y)) {
            Screen->FastCombo(7, Link->X - 10, Link->Y - 15, 48, 0, OP_OPAQUE);

            if (Input->Press[CB_SIGNPOST]) {
               if (Game->Counter[CR_MONEY] + Game->DCounter[CR_MONEY] >= price) { // TODO is bugged like classic ZC
                  Game->DCounter[CR_MONEY] -= price;
                  item itemToBuy = CreateItemAt(itemId, Hero->X, Hero->Y);

                  switch (itemId) {
                     case ITEM_EXPANSION_BOMB: {
                        Game->Counter[CR_BOMB_BAG_EXPANSIONS]++;
                        break;
                     }
                     case ITEM_EXPANSION_QUIVER: {
                        Game->Counter[CR_QUIVER_EXPANSIONS]++;
                        break;
                     }
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

// clang-format off
@Author("Deathrider365")
ffc script EgentemShrineSoldier {
   // clang-format on
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

// clang-format off
@Author("Deathrider365")
ffc script BuyItem {
   // clang-format on
   void run(int entryMessage, int price, int itemId, bool buyOnce, int entryMessageOnce) {
      bool alreadyBought = false;

      if (buyOnce && Hero->Item[itemId]) {
         this->Data = COMBO_INVIS;
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

      while (!alreadyBought) {
         Screen->DrawString(7, this->X + 8, this->Y - Text->FontHeight(FONT_LA) - 2, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, priceBuf, OP_OPAQUE, SHD_SHADOWED, C_BLACK);

         if (onTop(this->X, this->Y) && Game->Counter[CR_MONEY] >= price) {
            Game->DCounter[CR_MONEY] -= price;

            item itemToBuy = CreateItemAt(itemId, Hero->X, Hero->Y);
            itemToBuy->Pickup = IP_HOLDUP;

            switch (itemId) {
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
               case ITEM_BATTLE_ARENA_TICKET: Screen->TriggerSecrets(); break;
            }

            alreadyBought = true;
            this->Data = COMBO_INVIS;
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
         Screen->DrawString(2, this->X + 8, this->Y - Text->FontHeight(FONT_LA) - 2, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, priceBuf, OP_OPAQUE, SHD_SHADOWED, C_BLACK);

         if (againstFFC(this->X, this->Y)) {
            Screen->FastCombo(7, Link->X - 10, Link->Y - 15, 48, 0, OP_OPAQUE);

            if (Input->Press[CB_SIGNPOST]) {
               Hero->Action = LA_NONE;
               Hero->Stun = 15;

               if (Game->Counter[CR_MONEY] >= price) {
                  Game->DCounter[CR_MONEY] -= price;
                  Input->Button[CB_SIGNPOST] = false;

                  for (int i = 0; i < price * 2; ++i) {
                     NoAction();
                     Waitframe();
                  }

                  Hero->Action = LA_NONE;
                  Hero->Stun = 15;

                  Screen->Message(boughtString);
               }
               else {
                  Input->Button[CB_SIGNPOST] = false;
                  Screen->Message(notBoughtMessage);
               }
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
      mapdata template = Game->LoadTempScreen(1);
      int prevData = this->Data;

      if (Hero->Item[itemToCheckFor]) {
         this->Data = 1;
         template->ComboD[ComboAt(this->X + 8, this->Y + 8)] = 0;
         Quit();
      }

      until(getScreenD(253)) {
         this->Data = 1;
         template->ComboD[ComboAt(this->X + 8, this->Y + 8)] = 0;
         Waitframe();
      }

      this->Data = prevData;
      // template->ComboD[ComboAt(this->X + 8, this->Y + 8)] = COMBO_SOLID;

      while (true) {
         until(Screen->State[ST_SECRET]) Waitframe();

         this->Data = 6755;

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
      while (true) {
         waitForTalking(this);

         Input->Button[CB_SIGNPOST] = false;
         Game->Suspend[susptSCREENDRAW] = true;

         if (getScreenD(0))
            Screen->Message(thirdMessage);
         else if (getScreenD(1)) {
            Screen->Message(secondMessage);
         }
         else {
            Screen->Message(message);
            setScreenD(1, true);
         }

         Game->Suspend[susptSCREENDRAW] = false;
         Waitframe();
      }
   }
}
