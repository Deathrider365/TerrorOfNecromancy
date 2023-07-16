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
@Author ("Deathrider365")
item script MagicContainerExpansions {
   //clang-format on
   
   void run() {
      Game->Counter[CR_MAGIC_EXPANSIONS]++;
   }
}

// clang-format off
@Author("EmilyV99")
itemdata script GanonRage {
   //clang-format on
   
   //start
   // D0: Duration of ability
   // D1: Duration of cooldown
   // D2: Damage multiplier
   // D3: Cost to use
   //end
   void run(int durationSeconds, int cooldownSeconds, int damageMultiplier, int cost) {
      int itemClasses[] = {
         IC_ARROW, 
         IC_BOW, 
         IC_HAMMER, 
         IC_BRANG, 
         IC_SWORD, 
         IC_GALEBRANG, 
         IC_BRACELET, 
         IC_ROCS, 
         IC_STOMPBOOTS
      };
      
      itemdata itemIds[9];
      int itemStrengths[9];
      
      for (int i = SizeOfArray(itemClasses) - 1; i >= 0; --i) {
         int highestItem = GetHighestLevelItemOwned(itemClasses[i]);
         
         if (highestItem >= 0 && Hero->MP >= cost) {
            itemIds[i] = Game->LoadItemData(highestItem);
            itemStrengths[i] = itemIds[i]->Power;
            itemIds[i]->Power *= damageMultiplier;
            Hero->MP = Hero->MP - cost;
         }
      }
      
      statuses[ATTACK_BOOST] = durationSeconds * 60;
      
      while (statuses[ATTACK_BOOST])
         Waitframe();
      
      for (int i = SizeOfArray(itemClasses) - 1; i >= 0; --i)
         if (itemIds[i])
            itemIds[i]->Power = itemStrengths[i];
      
      for (int i = cooldownSeconds * 60; i > 0; --i) {
         char32 buf[8];
         itoa(buf, Ceiling(i / 60));
         
         if (Hero->ItemB == this->ID) {
            Screen->DrawString(7, SUB_B_X, SUB_B_Y, FONT_LA, C_BLACK, -1, TF_CENTERED, buf, OP_OPAQUE);
            Screen->FastTile(7, SUB_B_X - (Text->StringWidth(buf, FONT_LA) / 2) - SUB_COOLDOWN_TILE_WIDTH, SUB_B_Y, SUB_COOLDOWN_TILE, 0, OP_OPAQUE);
         } else if (Hero->ItemA == this->ID) {
            Screen->DrawString(7, SUB_A_X, SUB_A_Y, FONT_LA, C_BLACK, -1, TF_CENTERED, buf, OP_OPAQUE);
            Screen->FastTile(7, SUB_A_X - (Text->StringWidth(buf, FONT_LA) / 2) - SUB_COOLDOWN_TILE_WIDTH, SUB_A_Y, SUB_COOLDOWN_TILE, 0, OP_OPAQUE);
         }
            
         Waitframe();
      }
   }
}

// clang-format off
@Author("EmilyV99")
itemdata script ScholarsMind {
   //clang-format on
   
   //start Instructions
   // D0: Duration of ability
   // D1: Duration of cooldown
   // D2: Damage multiplier
   // D3: Cost to use
   //end
	void run(int durationSeconds, int cooldownSeconds, int damageMultiplier, int cost) {
		// int itemClasses[] = {/*magic related items*/};
		// itemdata itemIds[9];
		// int itemStrengths[9];
		
		// for (int i = SizeOfArray(itemClasses) - 1; i >= 0; --i)
		// {
			// int highestItem = GetHighestLevelItemOwned(itemClasses[i]);
			
			// if (highestItem >= 0 && Hero->MP >= cost)
			// {
				// itemIds[i] = Game->LoadItemData(highestItem);
				// itemStrengths[i] = itemIds[i]->Power;
				// itemIds[i]->Power *= damageMultiplier;
				// Hero->MP = Hero->MP - cost;
			// }
		// }
		
		// statuses[ATTACK_BOOST] = durationSeconds * 60;
		
		// while (statuses[ATTACK_BOOST])
			// Waitframe();
		
		// for (int i = SizeOfArray(itemClasses) - 1; i >= 0; --i)
			// if (itemIds[i])
				// itemIds[i]->Power = itemStrengths[i];
		
		// for (int i = cooldownSeconds * 60; i > 0; --i)
		// {
			// char32 buf[8];
			// itoa(buf, Ceiling(i / 60));
			
			// if (Hero->ItemB == this->ID)
			// {
				// Screen->DrawString(7, SUB_B_X, SUB_B_Y, SUB_TEXT_FONT, SUB_TEXT_COLOR, -1, TF_CENTERED, buf, OP_OPAQUE);
				// Screen->FastTile(7, SUB_B_X - (Text->StringWidth(buf, SUB_TEXT_FONT) / 2) - SUB_COOLDOWN_TILE_WIDTH, 
					// SUB_B_Y, SUB_COOLDOWN_TILE, 0, OP_OPAQUE);
			// }
			// else if (Hero->ItemA == this->ID)                
			// {
				// Screen->DrawString(7, SUB_A_X, SUB_A_Y, SUB_TEXT_FONT, SUB_TEXT_COLOR, -1, TF_CENTERED, buf, OP_OPAQUE);
				// Screen->FastTile(7, SUB_A_X - (Text->StringWidth(buf, SUB_TEXT_FONT) / 2) - SUB_COOLDOWN_TILE_WIDTH, 
					// SUB_A_Y, SUB_COOLDOWN_TILE, 0, OP_OPAQUE);
			// }
				
			// Waitframe();
		// }
	}
}

// clang-format off
@Author("EmilyV99")
itemdata script LifeRing {
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
      l->CollDetection = false;
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
