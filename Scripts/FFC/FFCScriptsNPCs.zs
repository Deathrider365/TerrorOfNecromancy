//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ NPCS FFCs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

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

      if (getScreenD(67, 0x13, 84)) {
         setScreenD(0, true);
         ++goronsSaved;
      }
      if (getScreenD(67, 0x44, 84)) {
         setScreenD(1, true);
         ++goronsSaved;
      }
      if (getScreenD(68, 0x41, 84)) {
         setScreenD(2, true);
         ++goronsSaved;
      }
      if (getScreenD(68, 0x14, 84)) {
         setScreenD(3, true);
         ++goronsSaved;
      }
      if (getScreenD(69, 0x12, 84)) {
         setScreenD(4, true);
         ++goronsSaved;
      }
      if (getScreenD(69, 0x75, 84)) {
         setScreenD(5, true);
         ++goronsSaved;
      }

      return goronsSaved;
   }
}

// clang-format off
@Author("Deathrider365")
ffc script ServusSoldier {
   // clang-format on
   void run(int itemId, int gettingItemString, int alreadyGotItemString) {
      this->Data = CMB_INVIS;
      this->Flags[FFCF_SOLID] = false;

      if (getScreenD(itemId)) {
         Quit();
      }

      // While waiting for the torches to be lit
      until(getScreenD(253))
         Waitframe();

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

         unless(getScreenD(itemId)) {
            Screen->Message(gettingItemString);
            Waitframe();
            itemsprite it = CreateItemAt(itemId, Hero->X, Hero->Y);
            it->Pickup = IP_HOLDUP;

            Input->Button[CB_SIGNPOST] = false;
            setScreenD(itemId, true);
         }
         else Screen->Message(alreadyGotItemString);

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
   void run(int initialMessage, int secondaryMessage, int tertiaryMessage, int fourthMessage, int fifthMessage, int initialScreenD) {
      loop() {
         waitForTalking(this);
         Input->Button[CB_SIGNPOST] = false;

         mapdata forgeBossRoom = Game->LoadMapData(61, 0x43);
         mapdata forgeMinesBossRoom = Game->LoadMapData(88, 0x59);

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
         } else if (getScreenD(initialScreenD + 1) && !forgeMinesBossRoom->State[ST_SECRET]) {
            Screen->Message(fourthMessage);
         } else if (forgeMinesBossRoom->State[ST_SECRET] && !getScreenD(initialScreenD + 2)) {
            Screen->Message(fifthMessage);
            setScreenD(initialScreenD + 2, true);
         } else {
            Screen->Message(fifthMessage + 2);
         }

         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script ConflatosNephew {
// clang-format on
   void run(int initialMessage, int secondaryMessage, int initialScreenD) {
      if (Screen->State[ST_SECRET]) {
         this->Data = CMB_INVIS;
         this->Flags[FFCF_SOLID] = false;
         Quit();
      }

      loop() {
         mapdata forgeMinesBossRoom = Game->LoadMapData(88, 0x59);

         waitForTalking(this);
         Input->Button[CB_SIGNPOST] = false;

         if (!forgeMinesBossRoom->State[ST_SECRET]) {
            Screen->Message(initialMessage);
         } else if (forgeMinesBossRoom->State[ST_SECRET]) {
            Screen->Message(secondaryMessage);
            Waitframe();

            Screen->TriggerSecrets();
            Screen->State[ST_SECRET] = true;
            Audio->PlaySound(SFX_SECRET);

            this->Data = CMB_INVIS;
            this->Flags[FFCF_SOLID] = false;
            Quit();
         }

         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script DefectedHylianGeneral {
// clang-format on
   void run(int initialMessage, int secondaryMessage, int tertiaryMessage, int initialScreenD) {
      if (Screen->State[ST_SECRET]) {
         this->Data = CMB_INVIS;
         this->Flags[FFCF_SOLID] = false;
         Quit();
      }

      loop() {
         mapdata lvl5BossRoom = Game->LoadMapData(75, 0x22);

         waitForTalking(this);
         Input->Button[CB_SIGNPOST] = false;

         if (!lvl5BossRoom->State[ST_SECRET]) {
            if (!Hero->Item[ITEM_SCROLL_SPIN_ATTACK]) {
               Screen->Message(initialMessage);
               Waitframe();
               CreateItemAt(ITEM_SCROLL_SPIN_ATTACK, Hero->X, Hero->Y);
            } else {
               Screen->Message(secondaryMessage);
            }
         } else {
            Screen->Message(tertiaryMessage);
            Waitframe();

            Screen->TriggerSecrets();
            Screen->State[ST_SECRET] = true;
            Audio->PlaySound(SFX_SECRET);

            this->Data = CMB_INVIS;
            this->Flags[FFCF_SOLID] = false;
            Quit();
         }

         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script ServusSoldier2 {
// clang-format on
   void run(int initialMessage, int secondaryMessage, int tertiaryMessage, int initialScreenD) {
      if (Screen->State[ST_SECRET]) {
         this->Data = CMB_INVIS;
         this->Flags[FFCF_SOLID] = false;
         Quit();
      }

      loop() {
         mapdata lvl5BossRoom = Game->LoadMapData(75, 0x22);

         waitForTalking(this);
         Input->Button[CB_SIGNPOST] = false;

         if (!lvl5BossRoom->State[ST_SECRET]) {
            if (!getScreenD(initialScreenD)) {
               Screen->Message(initialMessage);
               Waitframe();

               CreateItemAt(ITEM_HEART_PIECE, Hero->X, Hero->Y);
               setScreenD(initialScreenD, true);
            } else {
               Screen->Message(secondaryMessage);
            }
         } else {
            Screen->Message(tertiaryMessage);
            Waitframe();

            Screen->TriggerSecrets();
            Screen->State[ST_SECRET] = true;
            Audio->PlaySound(SFX_SECRET);

            this->Data = CMB_INVIS;
            this->Flags[FFCF_SOLID] = false;
            Quit();
         }

         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script SeizedTowerSoldier {
// clang-format on
   void run(int initialMessage, int secondaryMessage, int tertiaryMessage, int initialScreenD) {
      if (Screen->State[ST_SECRET]) {
         this->Data = CMB_INVIS;
         this->Flags[FFCF_SOLID] = false;
         Quit();
      }

      loop() {
         mapdata lvl5BossRoom = Game->LoadMapData(75, 0x22);

         waitForTalking(this);
         Input->Button[CB_SIGNPOST] = false;

         if (!lvl5BossRoom->State[ST_SECRET]) {
            if (!getScreenD(initialScreenD)) {
               Screen->Message(initialMessage);
               Waitframe();

               CreateItemAt(ITEM_HEART_PIECE, Hero->X, Hero->Y);
               setScreenD(initialScreenD, true);
            } else {
               Screen->Message(secondaryMessage);
            }
         } else {
            Screen->Message(tertiaryMessage);
            Waitframe();

            Screen->TriggerSecrets();
            Screen->State[ST_SECRET] = true;
            Audio->PlaySound(SFX_SECRET);

            this->Data = CMB_INVIS;
            this->Flags[FFCF_SOLID] = false;
            Quit();
         }

         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script PreSiegeNPC {
// clang-format on
   void run(int initialMessage, int map, int screen) {
      mapdata screenThatTriggersThis = Game->LoadMapData(map, screen);
      mapdata zeldaRoom = Game->LoadMapData(57, 0x02);

      if (!screenThatTriggersThis->State[ST_SECRET] || zeldaRoom->State[ST_SECRET]) {
         this->Data = CMB_INVIS;
         this->Flags[FFCF_SOLID] = false;
         Quit();
      }

      loop() {
         waitForTalking(this);
         Input->Button[CB_SIGNPOST] = false;

         if (!zeldaRoom->State[ST_SECRET]) {
            Screen->Message(initialMessage);
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
@Author("Deathrider365")
ffc script DuratuElder {
// clang-format on
   void run(int initialMessage, int secondaryMessage, int tertiaryMessage, int initialScreenD) {
      if (Screen->State[ST_SECRET]) {
         this->Data = CMB_INVIS;
         this->Flags[FFCF_SOLID] = false;
         Quit();
      }

      loop() {
         mapdata lvl6BossRoom = Game->LoadMapData(107, 0x48);

         waitForTalking(this);
         Input->Button[CB_SIGNPOST] = false;

         if (!lvl6BossRoom->State[ST_SECRET]) {
            if (!getScreenD(initialScreenD)) {
               Screen->Message(initialMessage);
               setScreenD(initialScreenD, true);
            } else {
               Screen->Message(secondaryMessage);
            }
         } else {
            Screen->Message(tertiaryMessage);
            Waitframe();

            Screen->TriggerSecrets();
            Screen->State[ST_SECRET] = true;
            Audio->PlaySound(SFX_SECRET);

            this->Data = CMB_INVIS;
            this->Flags[FFCF_SOLID] = false;
            Quit();
         }

         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script CarulemZora {
   // clang-format on
   void run(int initialMessage, int secondaryMessage, int tertiaryMessage, int fourthMessage, int finalMessage, int initialScreenD) {
      int prevData = this->Data;
      mapdata lvl7BossRoom = Game->LoadMapData(132, 0x6B);

      if (Screen->State[ST_SECRET]) {
         this->Flags[FFCF_SOLID] = false;
         this->Data = CMB_INVIS;
         Quit();
      }

      loop () {
         if (Screen->State[ST_SECRET]) {
            this->Flags[FFCF_SOLID] = false;
            this->Data = CMB_INVIS;
            Quit();
         }

         waitForTalking(this);
         Input->Button[CB_SIGNPOST] = false;

         if (lvl7BossRoom->State[ST_SECRET]) {
            if (!getScreenD(initialScreenD + 1)) {
               Screen->Message(tertiaryMessage);
               Waitframe();

               CreateItemAt(ITEM_MYSTERIOUS_ZORA_CHARM, Hero->X, Hero->Y)->Pickup = IP_HOLDUP;
               setScreenD(initialScreenD + 1, true);
            } else if (!Hero->Item[ITEM_JEWEL_OF_MARRE])
               Screen->Message(fourthMessage);
            else if (Hero->Item[ITEM_JEWEL_OF_MARRE]) {
               Screen->Message(finalMessage);
               Waitframe();

               Screen->TriggerSecrets();
               Screen->State[ST_SECRET] = true;
               this->Flags[FFCF_SOLID] = false;
               this->Data = CMB_INVIS;
            }
         } else {
            if (!getScreenD(initialScreenD)) {
               Screen->Message(initialMessage);
               setScreenD(initialScreenD, true);
            } else if (getScreenD(initialScreenD) && !lvl7BossRoom->State[ST_SECRET]) {
               Screen->Message(secondaryMessage);
            }
         }

         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script CarulemPrince {
   // clang-format on
   void run(int initialMessage, int secondaryMessage, int tertiaryMessage, int fourthMessage, int initialScreenD) {
      int prevData = this->Data;
      mapdata lvl7BossRoom = Game->LoadMapData(132, 0x6B);

      loop () {
         waitForTalking(this);
         Input->Button[CB_SIGNPOST] = false;

         if (lvl7BossRoom->State[ST_SECRET]) {
            if (!getScreenD(initialScreenD + 1)) {
               Screen->Message(tertiaryMessage);
               setScreenD(initialScreenD + 1, true);
            } else if (getScreenD(initialScreenD + 1))
               Screen->Message(fourthMessage);
         } else {
            if (!getScreenD(initialScreenD)) {
               Screen->Message(initialMessage);
               setScreenD(initialScreenD, true);
            } else if (getScreenD(initialScreenD) && !lvl7BossRoom->State[ST_SECRET]) {
               Screen->Message(secondaryMessage);
            }
         }

         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script EbrianZora {
// clang-format on
   void run(int initialMessage, int secondaryMessage, int tertiaryMessage, int fourthMessage, int initialScreenD, int itemId) {
      this->Flags[FFCF_SOLID] = false;
      int thisData = this->Data;
      this->Data = CMB_INVIS;

      until (Hero->Item[ITEM_MYSTERIOUS_ZORA_CHARM] || getScreenD(initialScreenD + 2))
         Waitframe();

      int count = 240;

      until(count)
         Waitframe();

      this->Flags[FFCF_SOLID] = true;

      for (int i = 0; i < 180; ++i) {
         this->Data = CMB_INVIS;

         if (i < 60 && (i % 10 == 0))
            this->Data = thisData;
         if (i < 120 && (i % 5 == 0))
            this->Data = thisData;
         else if (i > 120 && (i % 3 == 0))
            this->Data = thisData;

         Waitframe();
      }

      loop() {
         this->Data = thisData;

         waitForTalking(this);
         Input->Button[CB_SIGNPOST] = false;

         if (!getScreenD(initialScreenD)) {
            Screen->Message(initialMessage);
            Waitframe();
            CreateItemAt(itemId, Hero->X, Hero->Y)->Pickup = IP_HOLDUP;
            setScreenD(initialScreenD, true);
         } else if (getScreenD(initialScreenD) && !getScreenD(initialScreenD + 1)) {
            Screen->Message(secondaryMessage);
            setScreenD(initialScreenD + 1, true);
         } else if (getScreenD(initialScreenD + 1) && !Hero->Item[ITEM_JEWEL_OF_MARRE]) {
            Screen->Message(tertiaryMessage);
         } else if (Hero->Item[ITEM_JEWEL_OF_MARRE]) {
            Screen->Message(fourthMessage);
            Waitframe();

            for (int i = 0; i < 180; ++i) {
               this->Data = CMB_INVIS;

               if (i > 120 && (i % 3 == 0))
                  this->Data = thisData;
               else if (i < 120 && (i % 5 == 0))
                  this->Data = thisData;
               else if (i < 60 && (i % 10 == 0))
                  this->Data = thisData;

               Waitframe();
            }
            this->Flags[FFCF_SOLID] = false;
            this->Data = CMB_INVIS;
            setScreenD(initialScreenD + 2, true);
         }

         Waitframe();
      }
   }
}