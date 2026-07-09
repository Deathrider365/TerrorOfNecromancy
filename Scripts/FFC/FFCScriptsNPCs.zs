//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ NPCS FFCs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

// clang-format off
@Author("Deathrider365"),
@InitD0("triforceToCheck"),
@InitDHelp0("Represents the counter (courage == 7, power == 8, wisdom == 9)"),
@Author("Deathrider365")
ffc script TriforceDeciples {
// clang-format on
   void run(int triforceToCheck, int messageNotComplete, int secondMessageNotComplete, int messageComplete, int secondMessageComplete, int comboPosToChange) {
      loop() {
         if (getScreenD(triforceToCheck)) {
            triggerDoor(comboPosToChange);
         }

         waitForTalking(this);

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
@InitDHelp2("third message"),
@Author("Deathrider365")
ffc script GoronForemanDialogLvl6 {
   // clang-format on
   void run(int message, int secondMessage, int thirdMessage) {
      loop() {
         waitForTalking(this);
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

   CONFIG CMB_SOLDIER_OOF = 6709;
   CONFIG CMB_SOLDIER_WALKING = 6755;

   CONFIG SCREEND_GOT_TOWER_KEY = 1;
   CONFIG SCREEND_FOR_SECOND_STRING = 2;
   CONFIG SCREEND_SOLDIER_IS_OOF = 253;

   void run(int gettingItemString, int alreadyGotItemString) {
      this->Data = CMB_INVIS;
      this->Flags[FFCF_SOLID] = false;

      //This ffc in lvl2 should not appear since you entered the house
      if (getScreenD(SCREEND_GOT_TOWER_KEY))
         Quit();

      // While waiting for soldier to be oof'd
      until(getScreenD(SCREEND_SOLDIER_IS_OOF))
         Waitframe();

      this->Flags[FFCF_SOLID] = true;
      this->Data = CMB_SOLDIER_OOF;

      //Until servus is oof'd, be sad on the ground
      until(Screen->State[ST_SECRET]) Waitframe();

      this->Data = CMB_SOLDIER_WALKING;

      loop() {
         until(againstFFC(this->X, this->Y) && Input->Press[CB_A]) {
            if (againstFFC(this->X, this->Y))
               Screen->FastCombo(7, Hero->X - 10, Hero->Y - 15, 48, 0, OP_OPAQUE);
            Waitframe();
         }

         Input->Button[CB_A] = false;

         unless(getScreenD(SCREEND_FOR_SECOND_STRING)) {
            Screen->Message(gettingItemString);
            Waitframe();

            Input->Button[CB_A] = false;
            setScreenD(SCREEND_FOR_SECOND_STRING, true);
         }
         else Screen->Message(alreadyGotItemString);

         Waitframe();
      }
   }
}

@Author("Deathrider365")
ffc script PhonographMan {
   // clang-format on
   void run(int itemIdToReceive, int stringPreSecret, int stringGettingItem, int stringGottenItem, int screenD) {
      loop () {
         if ((Screen->State[ST_SECRET] && Hero->Item[itemIdToReceive]) || getScreenD(screenD)) {
            waitForTalking(this);
            Screen->Message(stringGottenItem);
            Waitframe();
         }
         else {
            until (Screen->State[ST_SECRET]) {
               until (againstFFC(this->X, this->Y) && Input->Press[CB_A]) {
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
@Author("Deathrider365")
ffc script EscapedEgentemCultist {
// clang-format on
   void run(int initialMessage, int initialItemId, int secondaryMessage, int secondaryItem, int initialScreenD, int secondaryScreenD, int tertiaryMessage, int requiredItem) {
      loop() {
         waitForTalking(this);

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

      CONFIG COMBO_NEPHEW_NOT_SMITHING = 5545;
      CONFIG COMBO_LONELY_ANVIL = 5848;

      loop() {
         mapdata forgeMinesBossRoom = Game->LoadMapData(88, 0x59);

         waitForTalking(this);

         if (!forgeMinesBossRoom->State[ST_SECRET]) {
            Screen->Message(initialMessage);
         } else if (forgeMinesBossRoom->State[ST_SECRET]) {
            Game->LoadTempScreen(3)->ComboD[100] = CMB_INVIS;
            Game->LoadTempScreen(1)->ComboD[117] = COMBO_LONELY_ANVIL;

            this->Data = COMBO_NEPHEW_NOT_SMITHING;
            Waitframes(5);
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

         if (!lvl5BossRoom->State[ST_SECRET]) {
            if (!Hero->Item[ITEM_SCROLL_SPIN_ATTACK]) {
               Screen->Message(initialMessage);
               Waitframe();
               itemsprite it = CreateItemAt(ITEM_SCROLL_SPIN_ATTACK, Hero->X, Hero->Y);
               it->Pickup = IP_HOLDUP;
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

   CONFIG SCREEND_GOT_TOWER_KEY = 1;

   void run(int initialMessage, int secondaryMessage, int tertiaryMessage, int initialScreenD) {
      setScreenD(23, 0x53, SCREEND_GOT_TOWER_KEY, true);

      if (Screen->State[ST_SECRET]) {
         this->Data = CMB_INVIS;
         this->Flags[FFCF_SOLID] = false;
         Quit();
      }

      loop() {
         mapdata lvl5BossRoom = Game->LoadMapData(75, 0x22);

         waitForTalking(this);

         if (!lvl5BossRoom->State[ST_SECRET]) {

            if (!getScreenD(initialScreenD)) {
               Screen->Message(initialMessage);
               Waitframe();
               itemsprite it = CreateItemAt(ITEM_HEART_PIECE, Hero->X, Hero->Y);
               it->Pickup = IP_HOLDUP;
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
   void run(int signetMessage, int secondaryMessage, int tertiaryMessage, int initialScreenD) {
      if (Screen->State[ST_SECRET] || !Hero->Item[ITEM_SIGNET_OF_ALLEGIANCE]) {
         this->Data = CMB_INVIS;
         this->Flags[FFCF_SOLID] = false;
         Quit();
      }

      loop() {
         mapdata lvl5BossRoom = Game->LoadMapData(75, 0x22);

         waitForTalking(this);

         if (!lvl5BossRoom->State[ST_SECRET]) {
            if (!getScreenD(initialScreenD)) {
               Screen->Message(signetMessage);
               Waitframe();
               itemsprite it = CreateItemAt(ITEM_RUPEE_20, Hero->X, Hero->Y);
               it->Pickup = IP_HOLDUP;
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
ffc script EgentemShrineSoldier {
   // clang-format on
   void run(int message) {
      int thisData = this->Data;
      this->Data = CMB_INVIS;
      this->Flags[FFCF_SOLID] = false;

      mapdata towerEntrance = Game->LoadMapData(44, 0x33);
      mapdata egentemRoom = Game->LoadMapData(48, 0x3B);

      if (!egentemRoom->State[ST_SECRET] || towerEntrance->State[ST_SECRET])
         Quit();

      loop () {
         this->Data = thisData;
         this->Flags[FFCF_SOLID] = true;
         waitForTalking(this);
         Screen->Message(message);
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

         if (!zeldaRoom->State[ST_SECRET]) {
            Screen->Message(initialMessage);
         }

         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script Lvl9ServusSoldier {
// clang-format on
   void run(int initialMessage, int secondaryMessage) {
      if (!Game->LoadMapData(16, 0x05)->State[ST_SECRET] || Screen->State[ST_SECRET]) {
         this->Data = CMB_INVIS;
         this->Flags[FFCF_SOLID] = false;
         Quit();
      }

      Waitframes(60);

      Screen->Message(initialMessage);
      Waitframe();

      for (int i = 1; i <= Screen->NumNPCs; ++i) {
         npc enem = Screen->LoadNPC(i);
         enem->HP = 0;
      }

      Screen->TriggerSecrets();
      Screen->State[ST_SECRET] = true;

      loop() {
         waitForTalking(this);
         Screen->Message(secondaryMessage);

         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script Lvl9DuratuElder {
// clang-format on
   void run(int initialMessage, int secondaryMessage, int isHair) {
      CONFIG CMB_CHIEF = 5818;
      CONFIG CMB_RAGIN_CHIEF = 5835;

      if (!Game->LoadMapData(53, 0x3D)->State[ST_SECRET] || Screen->State[ST_SECRET]) {
         this->Data = CMB_INVIS;
         this->Flags[FFCF_SOLID] = false;
         Quit();
      } else if (isHair > 0) {
         loop()
            Waitframe();
      } else {
         Waitframes(180);

         Screen->Message(initialMessage);
         Waitframe();

         this->Data = isHair ? CMB_RAGIN_CHIEF - 4 : CMB_RAGIN_CHIEF;

         for (int i = 1; i <= Screen->NumNPCs; ++i)
            Screen->LoadNPC(i)->HP = 0;

         Waitframes(60);

         this->Data = isHair ? CMB_CHIEF - 4 : CMB_CHIEF;

         Screen->TriggerSecrets();
         Screen->State[ST_SECRET] = true;

         loop() {
            waitForTalking(this);
            Screen->Message(secondaryMessage);

            Waitframe();
         }
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script Lvl9SeizedTowerGuard {
// clang-format on
   void run(int initialMessage, int secondaryMessage) {
      if (!Game->LoadMapData(16, 0x4B)->State[ST_SECRET] || Screen->State[ST_SECRET]) {
         this->Data = CMB_INVIS;
         this->Flags[FFCF_SOLID] = false;
         Quit();
      }

      Waitframes(60);

      // TODO instead of simply killing everything, have him throw his boomerang to all of the enemies, leaving them
      // all stunned for you to kill (since he gave you the soldier's boomerang)

      Screen->Message(initialMessage);
      Waitframe();

      for (int i = 1; i <= Screen->NumNPCs; ++i) {
         npc enem = Screen->LoadNPC(i);
         enem->HP = 0;
      }

      Screen->TriggerSecrets();
      Screen->State[ST_SECRET] = true;

      loop() {
         waitForTalking(this);
         Screen->Message(secondaryMessage);

         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script Lvl9ConflatosNephew {
// clang-format on
   void run(int initialMessage, int secondaryMessage) {
      if (!Game->LoadMapData(53, 0x75)->State[ST_SECRET] || getScreenD(0)) {
         this->Data = CMB_INVIS;
         this->Flags[FFCF_SOLID] = false;
         Quit();
      }

      Waitframes(60);

      // TODO instead of simply killing everything, have him throw his boomerang to all of the enemies, leaving them
      // all stunned for you to kill (since he gave you the soldier's boomerang)

      Screen->Message(initialMessage);
      Waitframe();

      until (Screen->NumNPCs < 1) Waitframe();

      setScreenD(0, true);

      loop() {
         waitForTalking(this);
         Screen->Message(secondaryMessage);
         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script Lvl9CarulemZora {
// clang-format on
   void run(int initialMessage, int secondaryMessage, int tertiaryMessage) {
      if (!Game->LoadMapData(96, 0x21)->State[ST_SECRET] || Screen->State[ST_SECRET]) {
         this->Data = CMB_INVIS;
         this->Flags[FFCF_SOLID] = false;
         Quit();
      }

      Waitframes(60);

      Screen->Message(initialMessage);
      Waitframe();

      zoraSwims(this);

      loop() {
         waitForTalking(this);
         Screen->Message(Hero->Item[ITEM_JEWEL_OF_MARRE] ? tertiaryMessage : secondaryMessage);
         Waitframe();
      }
   }

   void zoraSwims(ffc this) {
      CONFIG CMB_DIVING = 11097;
      CONFIG CMB_SWIMMING = 5808;
      int thisData = this->Data;
      this->Data = CMB_SWIMMING;

      for (int i = 0; i < 104; ++i) {
         this->Y++;

         if (this->Y > 64 && this->Y < 112)
            this->Data = CMB_DIVING;
         else
            this->Data = CMB_SWIMMING;

         Waitframe();
      }

      Screen->TriggerSecrets();
      Screen->State[ST_SECRET] = true;
      Audio->PlaySound(SFX_SECRET);

      for (int i = 0; i < 16; ++i) {
         this->X--;
         Waitframe();
      }

      this->Data = thisData;
   }
}

// clang-format off
@Author("Deathrider365")
ffc script Lvl9HylianGeneral {
// clang-format on
   void run(int initialMessage, int secondaryMessage) {
      if (!Game->LoadMapData(16, 0x3A)->State[ST_SECRET] || Screen->State[ST_SECRET]) {
         this->Data = CMB_INVIS;
         this->Flags[FFCF_SOLID] = false;
         Quit();
      }

      for (int i = 0; i < 60; ++i) {
         for (int i = 1; i <= Screen->NumNPCs; ++i) {
            npc enemy = Screen->LoadNPC(i);
            enemy->Step = 0;
            enemy->Dir = i < 6 ? DIR_RIGHT : DIR_LEFT;
         }
         Waitframe();
      }

      // TODO instead of simply killing everything, have him hurricane spin at the enemies

      Screen->Message(initialMessage);
      Waitframe();

      for (int i = 1; i <= Screen->NumNPCs; ++i) {
         npc enem = Screen->LoadNPC(i);
         enem->HP = 0;
      }

      Screen->TriggerSecrets();
      Screen->State[ST_SECRET] = true;

      loop() {
         waitForTalking(this);
         Screen->Message(secondaryMessage);
         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script Lvl9LobbyNpc {
   // clang-format on
   void run(int map, int screen, int preBossMessage, int postBossMessage, int screenD, int isHair) {
      //if this npc shouldnt appear
      if (!Game->LoadMapData(map, screen)->State[ST_SECRET] || !Hero->Item[ITEM_HOOKSHOT2]) {
         this->Data = CMB_INVIS;
         this->Flags[FFCF_SOLID] = false;
         Quit();
      }

      loop() {
         while (isHair) Waitframe();

         waitForTalking(this);

         if (!Game->LoadMapData(171, 0x3E)->State[ST_SECRET])
            Screen->Message(preBossMessage);
         else
            Screen->Message(postBossMessage);

         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script Lvl9LobbyZelda {
   // clang-format on
   void run() {
      CONFIG MESSAGE_PRE_BOSS_ZELDA_NO_STAGE = 1400;
      CONFIG MESSAGE_PRE_BOSS_ZELDA_FIRST_STAGE = 1401;
      CONFIG MESSAGE_PRE_BOSS_ZELDA_SECOND_STAGE = 1402;
      CONFIG MESSAGE_PRE_BOSS_ZELDA_THIRD_STAGE = 1403;
      CONFIG MESSAGE_PRE_BOSS_ZELDA_FOURTH_STAGE = 1404;
      CONFIG MESSAGE_PRE_BOSS_ZELDA_FINAL_STAGE = 1405;
      CONFIG MESSAGE_LVL9_BOSS_BEATEN = 1406; //TODO write the dialog and set the variables

      int zeldaStage = 0;

      // The way the stages work is each of these indicies correlates to how far you got in the goddess faithful dialog pre lv9
      // so the first stage represents that you only talked to zelda once, so her dialog would vary based on if you never talked
      // to her pre lv9, or if you talked to her completely

      for (int i = 0; i < 4; ++i) { //TODO update these stages
         if (getScreenD(48, 0x02, i))
            zeldaStage = i;
      }

      loop() {
         waitForTalking(this);

         //if the lvl 9 boss was beaten
         if (Game->LoadMapData(171, 0x3E)->State[ST_SECRET]) {
            Screen->Message(MESSAGE_LVL9_BOSS_BEATEN);
         }
         //if you completed all of zelda's stages
         else if (Game->LoadMapData(57, 0x02)->State[ST_SECRET]) {
            Screen->Message(MESSAGE_PRE_BOSS_ZELDA_FINAL_STAGE);
         }
         else {
            switch(zeldaStage) {
               case 1:
                  Screen->Message(MESSAGE_PRE_BOSS_ZELDA_FIRST_STAGE);
                  break;
               case 2:
                  Screen->Message(MESSAGE_PRE_BOSS_ZELDA_SECOND_STAGE);
                  break;
               case 3:
                  Screen->Message(MESSAGE_PRE_BOSS_ZELDA_THIRD_STAGE);
                  break;
               case 4:
                  Screen->Message(MESSAGE_PRE_BOSS_ZELDA_FOURTH_STAGE);
                  break;
               default:
                  Screen->Message(MESSAGE_PRE_BOSS_ZELDA_NO_STAGE);
            }
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
   void run(int initialMessage, int secondaryMessage, int tertiaryMessage, int quartupleMessage, int initialScreenD, int additionalMessage) {
      loop() {
         mapdata ocarinaGuyScreen = Game->LoadMapData(28, 0x65);

         waitForTalking(this);

         if (!getScreenD(initialScreenD)) {
            Screen->Message(initialMessage);
            Waitframe();
            setScreenD(initialScreenD, true);
         }
         else if (Hero->Item[ITEM_OCARINA1] && getScreenD(6, 0x65, 1) && !Screen->State[ST_SECRET])
            Screen->Message(additionalMessage);
         else if (getScreenD(initialScreenD) && !Screen->State[ST_SECRET])
            Screen->Message(secondaryMessage);
         else if (Screen->State[ST_SECRET] && !getScreenD(initialScreenD + 1)) {
            setScreenD(initialScreenD + 1, true);
            Screen->Message(tertiaryMessage);
         }
         else
            Screen->Message(quartupleMessage);

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
ffc script DuratuElder { //Pater Glacies
// clang-format on
   void run(int initialMessage, int secondaryMessage,  int initialScreenD, int tertiaryMessage, int preFeudMessage, bool isHair) {
      CONFIG SCREEND_GORON_FEUD_INITIATED = 0;
      CONFIG SCREEND_GORON_FEUD_STAGE_1 = 1;
      CONFIG SCREEND_GORON_FEUD_STAGE_2 = 2;
      CONFIG SCREEND_GORON_FEUD_STAGE_3 = 3;
      CONFIG SCREEND_LV6_BOSS_BEATEN = 4;

      CONFIG MESSAGE_FEUD1 = 1386;
      CONFIG MESSAGE_FEUD2 = 1388;
      CONFIG MESSAGE_FEUD3 = 1390;

      bool lvl6BossRoomTriggered = Game->LoadMapData(107, 0x48)->State[ST_SECRET];
      bool necromancerBossRoomTriggered = Game->LoadMapData(171, 0x3E)->State[ST_SECRET];

      if ((getScreenD(SCREEND_LV6_BOSS_BEATEN) && !necromancerBossRoomTriggered) || getScreenD(SCREEND_GORON_FEUD_STAGE_2)) {
         this->Data = CMB_INVIS;
         this->Flags[FFCF_SOLID] = false;
         Quit();
      }

      while (isHair) {
         if ((getScreenD(SCREEND_LV6_BOSS_BEATEN) && !necromancerBossRoomTriggered) || getScreenD(SCREEND_GORON_FEUD_STAGE_2)) {
            this->Data = CMB_INVIS;
            this->Flags[FFCF_SOLID] = false;
            Quit();
         }

         Waitframe();
      }

      loop() {
         waitForTalking(this);

         if (getScreenD(SCREEND_GORON_FEUD_INITIATED)) {
            if (!getScreenD(125, 0x42, SCREEND_GORON_FEUD_STAGE_2)) {
               if (getScreenD(SCREEND_GORON_FEUD_STAGE_1))
                  Screen->Message(MESSAGE_FEUD2);
               else {
                  Screen->Message(MESSAGE_FEUD1);
                  setScreenD(SCREEND_GORON_FEUD_STAGE_1, true);
               }
               Waitframe();
            }
            else if (!getScreenD(125, 0x42, SCREEND_GORON_FEUD_STAGE_3)) {
               Screen->Message(MESSAGE_FEUD3);
               Waitframe();
               setScreenD(SCREEND_GORON_FEUD_STAGE_2, true);

               this->Data = CMB_INVIS;
               this->Flags[FFCF_SOLID] = false;
               Quit();
            }
            else if (getScreenD(125, 0x42, SCREEND_GORON_FEUD_STAGE_3)) {
               Screen->Message(MESSAGE_FEUD1);
               Waitframe();
            }
         }
         else {
            if (!lvl6BossRoomTriggered && !necromancerBossRoomTriggered) {
               if (!getScreenD(initialScreenD)) {
                  Screen->Message(initialMessage);
                  Waitframe();
                  setScreenD(initialScreenD, true);
               } else {
                  Screen->Message(secondaryMessage);
                  Waitframe();
               }
            }
            else if (lvl6BossRoomTriggered && !necromancerBossRoomTriggered) {
               Screen->Message(tertiaryMessage);
               Waitframe();

               setScreenD(SCREEND_LV6_BOSS_BEATEN, true);
               Audio->PlaySound(SFX_SECRET);

               this->Data = CMB_INVIS;
               this->Flags[FFCF_SOLID] = false;
               Quit();
            }
            else if (necromancerBossRoomTriggered) {
               Screen->Message(preFeudMessage);
               Waitframe();
            }
         }

         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script CaldumElder { //Pater Ignis
// clang-format on
   void run(int initialMessage, int secondaryMessage, int feudMessageInitiated, int initialScreenD, int feudMessage1, int feudMessage2,  int feudMessage3) {
      CONFIG SCREEND_GORON_FEUD_INITIATED = 0;
      CONFIG SCREEND_GORON_FEUD_STAGE_1 = 1;
      CONFIG SCREEND_GORON_FEUD_STAGE_2 = 2;
      CONFIG SCREEND_GORON_FEUD_STAGE_3 = 3;

      CONFIG COMBO_DURATU_ELDER_BODY = 5818;
      CONFIG COMBO_DURATU_ELDER_HAIR = 5814;

      bool lvl10BossRoomTriggered = false;// = Game->LoadMapData(107, 0x48)->State[ST_SECRET]; //TODO determine this

      loop() {
         until(againstFFC(this->X, this->Y, false) && Input->Press[CB_A]) {
            if (againstFFC(this->X, this->Y, false))
               Screen->FastCombo(7, Hero->X - 10, Hero->Y - 15, 48, 0, OP_OPAQUE);

               if (getScreenD(35, 0x3D, SCREEND_GORON_FEUD_STAGE_2) && !getScreenD(SCREEND_GORON_FEUD_STAGE_3)) {
                  Screen->FastCombo(1, 136, 80, COMBO_DURATU_ELDER_BODY, 0, OP_OPAQUE);
                  Screen->FastCombo(1, 136, 64, COMBO_DURATU_ELDER_HAIR, 0, OP_OPAQUE);
               }

            Waitframe();
         }

         Input->Button[CB_A] = false;

         if (getScreenD(SCREEND_GORON_FEUD_INITIATED)) {
            if (!getScreenD(35, 0x3D, SCREEND_GORON_FEUD_STAGE_1)) {
               Screen->Message(feudMessageInitiated + 5);
               Waitframe();
               setScreenD(SCREEND_GORON_FEUD_STAGE_1, true);
            }
            else if (!getScreenD(35, 0x3D, SCREEND_GORON_FEUD_STAGE_2)) {
               Screen->Message(feudMessage1);
               Waitframe();
               setScreenD(SCREEND_GORON_FEUD_STAGE_2, true);
            }
            else if (!getScreenD(SCREEND_GORON_FEUD_STAGE_3)) {
               if (getScreenD(SCREEND_GORON_FEUD_STAGE_3)) {
                  Screen->Message(feudMessage3);
                  Waitframe();
               }
               else {
                  Screen->Message(feudMessage2);
                  Screen->FastCombo(1, 136, 80, COMBO_DURATU_ELDER_BODY, 0, OP_OPAQUE);
                  Screen->FastCombo(1, 136, 64, COMBO_DURATU_ELDER_HAIR, 0, OP_OPAQUE);
                  Waitframe();
                  setScreenD(SCREEND_GORON_FEUD_STAGE_3, true);

                  item it = CreateItemAt(ITEM_BOMB3, Hero->X, Hero->Y);
                  it->Pickup = IP_HOLDUP;
               }
            }
            else {
               Screen->Message(feudMessage3); //Thanks for helping us!
            }
         }
         else {
            if (!lvl10BossRoomTriggered) {
               if (!getScreenD(initialScreenD)) {
                  Screen->Message(initialMessage);
                  setScreenD(initialScreenD, true);
               }
               else {
                  Screen->Message(secondaryMessage);
                  lvl10BossRoomTriggered = true; //TODO REMOVE ME
               }
            }
            else if (lvl10BossRoomTriggered && !getScreenD(SCREEND_GORON_FEUD_INITIATED)) {
               Screen->Message(feudMessageInitiated);
               setScreenD(SCREEND_GORON_FEUD_INITIATED, true);
               setScreenD(35, 0x3D, SCREEND_GORON_FEUD_INITIATED, true);
            }
         }

         Waitframe();
      }
   }
}

// clang-format off
@Author("Deathrider365")
ffc script CarulemZora {
   // clang-format on
   void run(int initialMessage, int secondaryMessage, int tertiaryMessage, int fourthMessage, int finalMessage, int goddessFaithfulMessage, int initialScreenD) {
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

         if (lvl7BossRoom->State[ST_SECRET]) {
            if (!getScreenD(initialScreenD + 1)) {
               Screen->Message(tertiaryMessage);
               Waitframe();

               CreateItemAt(ITEM_MYSTERIOUS_ZORA_CHARM, Hero->X, Hero->Y)->Pickup = IP_HOLDUP;
               setScreenD(initialScreenD + 1, true);
            }
            else if (!Hero->Item[ITEM_JEWEL_OF_MARRE])
               Screen->Message(fourthMessage);
            else if (Hero->Item[ITEM_JEWEL_OF_MARRE] && !getScreenD(48, 0x02, 0)) {
               Screen->Message(finalMessage);
               Waitframe();
            }
            else if (Hero->Item[ITEM_JEWEL_OF_MARRE] && getScreenD(48, 0x02, 0)) {
               Screen->Message(goddessFaithfulMessage);
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

// clang-format off
@Author("Deathrider365")
ffc script LegendaryArmorer {
// clang-format on

   CONFIG SCREEND_DID_ONE_UPGRADE = 0;
   CONFIG SCREEND_ALREADY_TALKED = 1;
   CONFIG SCREEND_INITIAL_MESSAGE = 2;

   void run() {
      CONFIG MESSAGE_INITIAL = 900;
      CONFIG MESSAGE_SECONDARY = 901;

      CONFIG MESSAGE_UPGRADE_SWORD = 902;
      CONFIG MESSAGE_SWORD_UPGRADED = 903;

      CONFIG MESSAGE_UPGRADE_ARMOR = 904;
      CONFIG MESSAGE_ARMOR_UPGRADED = 905;

      CONFIG MESSAGE_ANOTHER_UPGRADE = 906;
      CONFIG MESSAGE_DONATION = 907;

      CONFIG MESSAGE_NOTHING_TO_UPGRADE = 908;
      CONFIG MESSAGE_NOTHING_LEFT_TO_UPGRADE = 909;
      CONFIG MESSAGE_GET_MORE_SCALES = 910;

      loop() {
         waitForTalking(this);

         if (!getScreenD(SCREEND_INITIAL_MESSAGE)) {
            Screen->Message(MESSAGE_INITIAL);
            setScreenD(SCREEND_INITIAL_MESSAGE, true);
            Waitframe();
         }

         if (Hero->Item[ITEM_LEVIATHAN_SCALE1] || Hero->Item[ITEM_LEVIATHAN_SCALE2]) {
            if (!getScreenD(SCREEND_DID_ONE_UPGRADE))
               Screen->Message(MESSAGE_SECONDARY);

            Waitframe();

            //SCENARIO - nothing to upgrade
            if ((!Hero->Item[ITEM_SWORD4] && !Hero->Item[ITEM_RING3]) || (Hero->Item[ITEM_SWORD4] && Hero->Item[ITEM_SWORD5] && !Hero->Item[ITEM_RING3]) || (Hero->Item[ITEM_RING3] && Hero->Item[ITEM_RING4] && !Hero->Item[ITEM_SWORD4])) {
               Screen->Message(MESSAGE_NOTHING_TO_UPGRADE);
            }
            //SCENARIO - both things to upgrade
            else if ((Hero->Item[ITEM_SWORD4] && !Hero->Item[ITEM_SWORD5]) && (Hero->Item[ITEM_RING3] && !Hero->Item[ITEM_RING4])) {
               if (Hero->Item[ITEM_LEVIATHAN_SCALE1] && Hero->Item[ITEM_LEVIATHAN_SCALE2]) {
                  upgradeSword(MESSAGE_UPGRADE_SWORD, MESSAGE_SWORD_UPGRADED, MESSAGE_DONATION, 0, false);

                  Screen->Message(MESSAGE_ANOTHER_UPGRADE);
                  Waitframe();

                  upgradeArmor(MESSAGE_UPGRADE_ARMOR, MESSAGE_ARMOR_UPGRADED, MESSAGE_DONATION, 50);
               } else {
                  bool choseSword = chooseUpgrade();

                  if (choseSword)
                     upgradeSword(MESSAGE_UPGRADE_SWORD, MESSAGE_SWORD_UPGRADED, MESSAGE_DONATION, 20);
                  else
                     upgradeArmor(MESSAGE_UPGRADE_ARMOR, MESSAGE_ARMOR_UPGRADED, MESSAGE_DONATION, 20);
               }
            }
            //SCENARIO - only one thing to upgrade
            else if ((Hero->Item[ITEM_SWORD4] && !Hero->Item[ITEM_SWORD5]) || (Hero->Item[ITEM_RING3] && !Hero->Item[ITEM_RING4])) {
               if (Hero->Item[ITEM_SWORD4] && !Hero->Item[ITEM_SWORD5])
                  upgradeSword(MESSAGE_UPGRADE_SWORD, MESSAGE_SWORD_UPGRADED, MESSAGE_DONATION, 20);
               if (Hero->Item[ITEM_RING3] && !Hero->Item[ITEM_RING4])
                  upgradeArmor(MESSAGE_UPGRADE_ARMOR, MESSAGE_ARMOR_UPGRADED, MESSAGE_DONATION, 20);
            }
         }
         else if (Hero->Item[ITEM_SWORD5] && Hero->Item[ITEM_RING4])
            Screen->Message(MESSAGE_NOTHING_LEFT_TO_UPGRADE);
         else if (Hero->Item[ITEM_SWORD5] || Hero->Item[ITEM_RING4])
            Screen->Message(MESSAGE_GET_MORE_SCALES);


         Waitframe();
      }
   }

   bool chooseUpgrade() {
      CONFIG TILE_SELECTOR = 46675;

      CONFIG TILE_SWORD_UNCONFIRM1 = 46893;
      CONFIG TILE_SWORD_UNCONFIRM2 = 46894;
      CONFIG TILE_SWORD_UNCONFIRM3 = 46895;

      CONFIG TILE_SWORD_CONFIRM1 = 46913;
      CONFIG TILE_SWORD_CONFIRM2 = 46914;
      CONFIG TILE_SWORD_CONFIRM3 = 46915;

      CONFIG TILE_ARMOR_UNCONFIRM1 = 46896;
      CONFIG TILE_ARMOR_UNCONFIRM2 = 46897;
      CONFIG TILE_ARMOR_UNCONFIRM3 = 46898;

      CONFIG TILE_ARMOR_CONFIRM1 = 46916;
      CONFIG TILE_ARMOR_CONFIRM2 = 46917;
      CONFIG TILE_ARMOR_CONFIRM3 = 46918;

      int message;
      bool chose = false;
      bool choosingSword = true;

      until (chose) {
         notDuringCutsceneLink();

         Screen->FastTile(7, 80, choosingSword ? 16 : 32, TILE_SELECTOR, 0, OP_OPAQUE);

         if (Input->Press[CB_UP] || Input->Press[CB_DOWN]) {
            Audio->PlaySound(SFX_CURSOR_MOVEMENT);
            choosingSword = !choosingSword;
         }

         if (Input->Press[CB_A]) {
            Audio->PlaySound(choosingSword ? 139 : 140);

            for (int i = 0; i < 30; ++i) {
               Screen->FastTile(7, 96, 16, choosingSword ? TILE_SWORD_CONFIRM1 : TILE_SWORD_UNCONFIRM1, 0, OP_OPAQUE);
               Screen->FastTile(7, 112, 16, choosingSword ? TILE_SWORD_CONFIRM2 : TILE_SWORD_UNCONFIRM2, 0, OP_OPAQUE);
               Screen->FastTile(7, 128, 16, choosingSword ? TILE_SWORD_CONFIRM3 : TILE_SWORD_UNCONFIRM3, 0, OP_OPAQUE);

               Screen->FastTile(7, 96, 32, choosingSword ? TILE_ARMOR_UNCONFIRM1 : TILE_ARMOR_CONFIRM1, 0, OP_OPAQUE);
               Screen->FastTile(7, 112, 32, choosingSword ? TILE_ARMOR_UNCONFIRM2 : TILE_ARMOR_CONFIRM2, 0, OP_OPAQUE);
               Screen->FastTile(7, 128, 32, choosingSword ? TILE_ARMOR_UNCONFIRM3 : TILE_ARMOR_CONFIRM3, 0, OP_OPAQUE);

               Waitframe();
            }
            chose = true;
         }

         Screen->FastTile(7, 96, 16, choosingSword ? TILE_SWORD_CONFIRM1 : TILE_SWORD_UNCONFIRM1, 0, OP_OPAQUE);
         Screen->FastTile(7, 112, 16, choosingSword ? TILE_SWORD_CONFIRM2 : TILE_SWORD_UNCONFIRM2, 0, OP_OPAQUE);
         Screen->FastTile(7, 128, 16, choosingSword ? TILE_SWORD_CONFIRM3 : TILE_SWORD_UNCONFIRM3, 0, OP_OPAQUE);

         Screen->FastTile(7, 96, 32, choosingSword ? TILE_ARMOR_UNCONFIRM1 : TILE_ARMOR_CONFIRM1, 0, OP_OPAQUE);
         Screen->FastTile(7, 112, 32, choosingSword ? TILE_ARMOR_UNCONFIRM2 : TILE_ARMOR_CONFIRM2, 0, OP_OPAQUE);
         Screen->FastTile(7, 128, 32, choosingSword ? TILE_ARMOR_UNCONFIRM3 : TILE_ARMOR_CONFIRM3, 0, OP_OPAQUE);

         Waitframe();
      }

      return choosingSword;
   }

   void upgradeSword(int upgradeSwordMessage, int swordUpgradedMessage, int donationMessage, int donationCost, bool doTheDonationString = true) {
      Screen->Message(upgradeSwordMessage);
      Waitframe();

      //TODO perhaps an animation of him turning around and upgrading like excalibur from FF1

      Screen->Message(swordUpgradedMessage);
      Waitframe();

      item it = CreateItemAt(ITEM_SWORD5, Hero->X, Hero->Y);
      it->Pickup = IP_HOLDUP;
      Waitframe();

      if (Hero->Item[ITEM_LEVIATHAN_SCALE1]) Hero->Item[ITEM_LEVIATHAN_SCALE1] = false;
      else Hero->Item[ITEM_LEVIATHAN_SCALE2] = false;

      if (!getScreenD(SCREEND_DID_ONE_UPGRADE))
         setScreenD(SCREEND_DID_ONE_UPGRADE, true);

      if (doTheDonationString) {
         if (Game->Counter[CR_MONEY] >= donationCost) {
            Screen->Message(donationMessage);
            Waitframe();
            Game->DCounter[CR_MONEY] -= donationCost;
         }
      }
   }

   void upgradeArmor(int upgradeArmorMessage, int armorUpgradedMessage, int donationMessage, int donationCost, bool doTheDonationString = true) {
      Screen->Message(upgradeArmorMessage);
      Waitframe();

      //TODO perhaps an animation of him turning around and upgrading like excalibur from FF1

      Screen->Message(armorUpgradedMessage);
      Waitframe();

      item it = CreateItemAt(ITEM_RING4, Hero->X, Hero->Y);
      it->Pickup = IP_HOLDUP;
      Waitframe();

      if (Hero->Item[ITEM_LEVIATHAN_SCALE1]) Hero->Item[ITEM_LEVIATHAN_SCALE1] = false;
      else Hero->Item[ITEM_LEVIATHAN_SCALE2] = false;

      if (!getScreenD(SCREEND_DID_ONE_UPGRADE))
         setScreenD(SCREEND_DID_ONE_UPGRADE, true);

      if (doTheDonationString) {
         if (Game->Counter[CR_MONEY] >= donationCost) {
            Screen->Message(donationMessage);
            Waitframe();
            Game->DCounter[CR_MONEY] -= donationCost;
         }
      }
   }
}

@Author("Deathrider365")
ffc script TeePeeDude {
   void run(int openingMessage, int repeatingMessage, int paladinMessage) {
      loop () {
         waitForTalking(this);

         if (getScreenD(0) && Hero->Item[ITEM_DIFFICULTY_VERY_HARD])
            Screen->Message(paladinMessage);
         else if (!getScreenD(0)) {
            Screen->Message(openingMessage);
            setScreenD(0, true);
         }
         else
            Screen->Message(repeatingMessage);

         Waitframe();
      }
   }
}

@Author("Deathrider365")
ffc script CumpuraKeySoldier {
   void run(int preKeyMessage, int postKeyMessage, int postKeyDidntTalkMessage, int prekeySecondMessage) {
      loop () {
         waitForTalking(this);

         if (Hero->Item[ITEM_CUMPURA_KEY]) {
            if (getScreenD(0))
               Screen->Message(postKeyMessage);
            else {
               Screen->Message(postKeyDidntTalkMessage);
               setScreenD(0, true);
            }
         }
         else {
            if (getScreenD(0))
               Screen->Message(prekeySecondMessage);
            else {
               Screen->Message(preKeyMessage);
               setScreenD(0, true);
            }
         }

         Waitframe();
      }
   }
}


// clang-format off
@Author("Deathrider365")
ffc script SoTranquilLady {
// clang-format on
   void run(int initialMessage, int secondaryMessage, int tertiaryMessage, int initialScreenD) {
      loop() {
         waitForTalking(this);

         if (!getScreenD(initialScreenD)) {
            Screen->Message(initialMessage);

            Waitframes(60);

            setScreenD(initialScreenD, true);
            this->Data++;
            Screen->Message(secondaryMessage);
         }
         else
            Screen->Message(tertiaryMessage);

         Waitframe();
      }
   }
}

@Author("Deathrider365")
ffc script RisingFallingLiquid {
   void run(int combo) {
      loop() {
         for (int i = 0; i < 176; i++) {
            if (Screen->ComboD[i] == combo) {
               // Make the combo rise and fall
            }
         }

         Waitframe();
      }
   }
}