//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Items ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

// clang-format off
@Author("Deathrider365")
item script LegionRings {
   //clang-format on

   void run() {
      if(Game->Counter[CR_LEGIONNAIRE_RING] == 19) {
         Screen->TriggerSecrets();
         Screen->State[ST_SECRET] = true;
         return;
      }
   }
}

// clang-format off
@Author ("Deathrider365")
item script HeartPieces {
   //clang-format on

	void run() {
		switch(Game->Generic[GEN_HEARTPIECES] + 1) {
			case 1:
				Screen->Message(712);
				break;
			case 2:
				Screen->Message(713);
				break;
			case 3:
				Screen->Message(714);
				break;
			case 4:
				Screen->Message(715);
				break;
		}
	}
}

// clang-format off
@Author ("Deathrider365"),
@InitD0("curShar"),
@InitDHelp0("The current shard being obtained (0 = A, 1 = B, 2 = C, 3 = D)")
item script SummusTabletShards {
   //clang-format on

	void run(int curShard) {
		switch(curShard) {
			case 1:
				Screen->Message(792);
				break;
			case 2:
				Screen->Message(793);
				break;
			case 3:
				Screen->Message(794);
				break;
			case 4:
				Screen->Message(795);
				break;
		}
	}
}

// clang-format off
@Author ("Deathrider365")
item script TriforcePickup {
   //clang-format on

   //TODO pickup cutscene with music

   CONFIG BASE_STRING = 777;
   CONFIG STRING_COMPLETED_TRIFORCE = 919;

	void run(int triforceType, int counterId) {
      //TODO cutscene? cannot get this gradual incrememnting to work

      loop () {
         if (Hero->HP == Hero->MaxHP && Hero->MP == Hero->MaxMP) break;

         if (Hero->HP < Hero->MaxHP) Hero->HP++;
         if (Hero->MP < Hero->MaxMP) Hero->MP++;
      }

      switch(counterId) {
         case CR_TRIFORCE_OF_COURAGE:
            Screen->Message(Game->Counter[CR_TRIFORCE_OF_COURAGE] == 4 ? STRING_COMPLETED_TRIFORCE + triforceType : BASE_STRING + triforceType);
            Waitframe();
            break;
         case CR_TRIFORCE_OF_POWER:
            Screen->Message(Game->Counter[CR_TRIFORCE_OF_POWER] == 4 ? STRING_COMPLETED_TRIFORCE + triforceType : BASE_STRING + triforceType);
            Waitframe();
            break;
         case CR_TRIFORCE_OF_WISDOM:
            Screen->Message(Game->Counter[CR_TRIFORCE_OF_WISDOM] == 4 ? STRING_COMPLETED_TRIFORCE + triforceType : BASE_STRING + triforceType);
            Waitframe();
            break;
         case CR_TRIFORCE_OF_DEATH:
            Screen->Message(Game->Counter[CR_TRIFORCE_OF_DEATH] == 4 ? STRING_COMPLETED_TRIFORCE + triforceType : BASE_STRING + triforceType);
            Waitframe();
            break;
      }
   }
}

// clang-format off
@Author ("Deathrider365")
item script MagicContainerExpansions {
   //clang-format on

   void run() {
      Game->Counter[CR_MAGIC_EXPANSIONS]++;
   }
}

// clang-format off
@Author("Moosh")
item script HaerenGrace {
   //clang-format on

   void run(int errsfx) {
      int hpPercent = PercentOfWhole(Hero->HP, Hero->MaxHP);
      int currentMP;
      int heal;
      int mpCost;

      if (hpPercent <= 10) {
         if (Hero->MP >= 200) {
            currentMP = 200;

            for (int hpToRestore = Hero->MaxHP - Hero->HP; hpToRestore > 0;) {
               heal = Min(4, hpToRestore);
               Hero->HP += heal;
               hpToRestore -= heal;

               mpCost = Min(8, currentMP);
               Hero->MP -= mpCost;
               currentMP -= mpCost;

               if (currentMP > 0)
                  Hero->MP -= 5;

               Waitframes(5);
            }
            //Hero->HP += Hero->MaxHP;	//If I want the effect to be instant
            //Hero->MP -= 200;
         }
         else
            Audio->PlaySound(errsfx);
      } else if (hpPercent <= 50) {
         if (Hero->MP >= 100) {
            currentMP = 100;

            for (int hpToRestore = 160; hpToRestore > 0;) {
               heal = Min(4, hpToRestore);
               Hero->HP += heal;
               hpToRestore -= heal;

               mpCost = Min(8, currentMP);
               Hero->MP -= mpCost;
               currentMP -= mpCost;

               if (currentMP > 0)
                  Hero->MP -= 5;

               Waitframes(5);
            }
            //Hero->HP += Hero->MaxHP / 2;
            //Hero->MP -= 100;
         }
         else
            Audio->PlaySound(errsfx);

      } else if (hpPercent < 100) {
         if (Hero->MP >= 50) {
            currentMP = 50;

            for (int hpToRestore = 120; hpToRestore > 0;) {
               heal = Min(4, hpToRestore);
               Hero->HP += heal;
               hpToRestore -= heal;

               mpCost = Min(8, currentMP);
               Hero->MP -= mpCost;
               currentMP -= mpCost;

               if (currentMP > 0)
                  Hero->MP -= 5;

               Waitframes(5);
            }
            //Hero->HP += Hero->MaxHP / 4;
            //Hero->MP -= 50;
         }
         else
            Audio->PlaySound(errsfx);
      }
      //else, hp == maxhp
      else
         Audio->PlaySound(errsfx);
   }
}

// clang-format off
@Author("EmilyV99")
itemdata script DinRage {
   //clang-format on

   void run(int durationSeconds, int cooldownSeconds, int damageMultiplier, int cost) {
      CONFIG COMBO_GANONS_RAGE = 16;

      unless (Hero->MP >= cost)
         Quit();

      Hero->MP = Hero->MP - cost;

      int itemClasses[] = {
         IC_SWORD,
         IC_BRANG,
         IC_ARROW,
         IC_BOW,
         IC_HAMMER,
         IC_SPINSCROLL,
         IC_CROSSSCROLL,
         IC_QUAKESCROLL,
         IC_PERILSCROLL,
         IC_HURRICANESCROLL,
         IC_QUAKESCROLL,
         IC_GALEBRANG,
      };

      itemdata itemIds[9];
      int itemStrengths[9];

      for (int i = SizeOfArray(itemClasses) - 1; i >= 0; --i) {
         int highestItem = GetHighestLevelItemOwned(itemClasses[i]);

         if (highestItem >= 0) {
            itemIds[i] = Game->LoadItemData(highestItem);
            itemStrengths[i] = itemIds[i]->Power;

            itemIds[i]->Power *= damageMultiplier;
         }
      }

      for (int i = cooldownSeconds * 60; i > 0; --i) {
         Screen->FastCombo(SPLAYER_PLAYER_DRAW, Hero->X, Hero->Y, COMBO_GANONS_RAGE, 0, OP_TRANS);
         // Instead of the old archaic status system, just have a graphical representation (like nayrus love), perhaps Link flashes red slowly or has an outline

         Waitframe();
      }

      for (int i = SizeOfArray(itemClasses) - 1; i >= 0; --i)
         if (itemIds[i])
            itemIds[i]->Power = itemStrengths[i];
   }
}

// clang-format off
@Author("EmilyV99")
itemdata script NayruVengeance {
   //clang-format on

	void run(int durationSeconds, int cooldownSeconds, int damageMultiplier, int cost) {
      int itemClasses[] = { //TODO doesnt seem to apply to the want magic
         IC_CANDLE,
         IC_WAND,
         IC_DINSFIRE,
         IC_FARORESWIND,
         IC_NAYRUSLOVE,
         IC_CBYRNA,
         IC_HEARTRING,
         IC_MAGICRING
      };

		itemdata itemIds[9];
		int itemStrengths[9];

      CONFIG COMBO_NAYRUS_VENGEANCE = 16;

      unless (Hero->MP >= cost)
         Quit();

      Hero->MP = Hero->MP - cost;

		for (int i = SizeOfArray(itemClasses) - 1; i >= 0; --i) {
			int highestItem = GetHighestLevelItemOwned(itemClasses[i]);

			if (highestItem >= 0 && Hero->MP >= cost) {
				itemIds[i] = Game->LoadItemData(highestItem);
				itemStrengths[i] = itemIds[i]->Power;

				itemIds[i]->Power *= damageMultiplier;
			}
		}

      for (int i = cooldownSeconds * 60; i > 0; --i) {
         Screen->FastCombo(SPLAYER_PLAYER_DRAW, Hero->X, Hero->Y, COMBO_NAYRUS_VENGEANCE, 7, OP_TRANS);
         // Instead of the old archaic status system, just have a graphical representation (like nayrus love), perhaps Link flashes red slowly or has an outline

         Waitframe();
      }

      for (int i = SizeOfArray(itemClasses) - 1; i >= 0; --i)
         if (itemIds[i])
            itemIds[i]->Power = itemStrengths[i];
	}
}

// clang-format off
@Author("EmilyV99")
itemdata script LifeRing { //TODO keep?
   //clang-format on

   //start Instructions
   //D0: HP to heal while enemies on screen
   //D1: How often to heal while enemies on screen
   //D2: HP to heal while no enemies on screen
   //D3: How often to heal while no enemies on screen
   //inspired by James24
   //end
   void run(int hpActive, int timerActive, int hpIdle, int timerIdle) {
      int clock;

      while(true) {
         while(Hero->Action == LA_SCROLLING)
            Waitframe();

         if(EnemiesAlive()) {
            clock = (clock + 1) % timerActive;

            unless(clock)
               Hero->HP += hpActive;
         } else {
            clock = (clock + 1) % timerIdle;

            unless(clock)
               Hero->HP += hpIdle;
         }
         Waitframe();
      }
   }
}

itemsprite script ArcingItemSprite {
   void run(int angle, int step, int initJump, int gravity) {
      int x = this->X;
      int y = this->Y;
      int jump = initJump;
      bool timeout = this->Pickup & IP_TIMEOUT;
      int linkDistance = Distance(Hero->X + Rand(-16, 16), Hero->Y + Rand(-16, 16), this->X, this->Y);

      this->Gravity = false;
      this->Pickup ~= IP_TIMEOUT;

      if (initJump == -1 && gravity == 0)
         jump = getJumpLength(linkDistance / (step), true);

      unless (gravity)
         gravity = Game->Gravity[GR_STRENGTH];

      while(jump > 0 || this->Z > 0) {
         x += VectorX(step, angle);
         y += VectorY(step, angle);
         this->X = x;
         this->Y = y;
         this->Z += jump;
         jump -= gravity;
         Waitframe();
      }

      if (timeout)
      this->Pickup |= IP_TIMEOUT;
   }
}

itemsprite script ArcingItemSprite2 {
   void run(int angle, int step, int initJump, int gravity) {
      int x = this->X;
      int y = this->Y;
      int jump = initJump;
      bool timeout = this->Pickup & IP_TIMEOUT;
      int linkDistance = Distance(Hero->X + Rand(-16, 16), Hero->Y + Rand(-16, 16), this->X, this->Y);

      this->Gravity = false;
      this->Pickup ~= IP_TIMEOUT;
      this->Pickup |= IP_DUMMY;

      if (initJump == -1 && gravity == 0)
         jump = getJumpLength(linkDistance / (step), true);

      unless (gravity)
         gravity = Game->Gravity[GR_STRENGTH];

      lweapon l = Screen->CreateLWeapon(LW_SCRIPT1);
      l->Flags[WFLAG_BREAKS_ON_SOLID] = true;
      l->NoCollisionTimer = -1;
      l->DrawXOffset = 9999;

      while(jump > 0 || this->Z > 0) {
         x += VectorX(step, angle);
         y += VectorY(step, angle);
         l->X = x + VectorX(step, angle) * 3;
         l->Y = y + VectorY(step, angle) * 3;
         this->X = x;
         this->Y = y;
         this->Z += jump;
         jump -= gravity;
         Waitframe();

         unless (l->isValid())
            break;
      }

      this->Pickup ~= IP_DUMMY;
      this->Gravity = true;

      if (l->isValid())
         l->Remove();

      if (timeout)
         this->Pickup |= IP_TIMEOUT;
   }
}

item script ExpansionPickup {
   void run() {
      switch(this->ID) {
         case ITEM_EXPANSION_BOMB:
            Game->Counter[CR_BOMB_BAG_EXPANSIONS]++;
            break;
         case ITEM_EXPANSION_QUIVER:
            Game->Counter[CR_QUIVER_EXPANSIONS]++;
            break;

      }
   }
}

item script HalfMagicPickup {
   void run() {
      Game->Generic[GEN_MAGICDRAINRATE] /= 2;
   }
}