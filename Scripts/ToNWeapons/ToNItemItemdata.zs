///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Item~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

@Author("Deathrider365")
item script LegionRings {
   void run() {
      if(Game->Counter[CR_LEGIONNAIRE_RING] == 19) {
         Screen->TriggerSecrets();
         Screen->State[ST_SECRET] = true;
         return;	
      }		
   }
}

@Author("EmilyV99")
itemdata script GanonRage {
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

@Author("EmilyV99")
itemdata script ScholarsMind {
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

@Author("EmilyV99")
itemdata script LifeRing {
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

@Author("Moosh")
item script HaerenGrace {
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

@Author ("Deathrider365")
item script HeartPieces {
	void run() {
		switch(Game->Generic[GEN_HEARTPIECES] + 1) {
			case 1:
				Screen->Message(115);
				break;
			case 2:
				Screen->Message(116);
				break;
			case 3:
				Screen->Message(117);
				break;
			case 4:
				Screen->Message(118);
				break;			
		}
	}
}

@Author("Moosh")
lweapon script FlamingArrow {
   void run() {
      unless (this->ID == LW_ARROW)
         Quit();

      bool collided;
      
      while(true) {
         unless (collided) 			{
            for (int i = Screen->NumLWeapons(); i > 0; --i) {
               lweapon weapon = Screen->LoadLWeapon(i);
               
               switch(weapon->ID) {
                  case LW_FIRE:
                     if (weapon->CollDetection && Collision(this, weapon)) {
                        collided = true;
                        Audio->PlaySound(SFX_FLAMMING_ARROW);
                     }
                     break;
               }
            }
            for (int i = Screen->NumEWeapons(); i > 0; --i) {
               eweapon weapon = Screen->LoadEWeapon(i);
               
               switch(weapon->ID) {
                  case EW_FIRE:
                  case EW_FIRE2:
                  case EW_FIRETRAIL:
                     if (weapon->CollDetection && Collision(this, weapon)) {
                        collided = true;
                        Audio->PlaySound(SFX_FLAMMING_ARROW);
                     }
                     break;
               }
            }
            
            if (arrowPointCollision(this->X + 7, this->Y + 7)) {
               collided = true;
               Audio->PlaySound(SFX_FLAMMING_ARROW);
            }
         } 
         else if (this->DeadState == WDS_ALIVE) {
            if (gameframe % 4 == 0) {
               lweapon flame = dropFlame(this->X + Rand(-4, 4), this->Y + Rand(-4, 4), SPR_FLAME_TRAIL);
               flame->Script = 0;
            }
            
            lweapon flameHitbox = CreateLWeaponAt(LW_FIRE, this->X, this->Y);
            flameHitbox->DrawYOffset = -1000;
            flameHitbox->Damage = this->Damage;
            flameHitbox->Dir = this->Dir;
            
            flameHitbox->Script = Game->GetLWeaponScript("DieTimeOut");
            flameHitbox->InitD[0] = 1;
         }
         
         Waitframe();
      }
   }
	
	bool arrowPointCollision(int x, int y) {
      int pos = ComboAt(x, y);
      int comboType = Screen->ComboT[pos];
      
      if (comboType == CT_LANTERN)
         return true;
         
      mapdata layer1 = Game->LoadTempScreen(1);
      comboType = layer1->ComboT[pos];
      
      if (comboType == CT_LANTERN)
         return true;
         
      mapdata layer2 = Game->LoadTempScreen(2);
      comboType = layer2->ComboT[pos];
      
      if (comboType == CT_LANTERN)
         return true;
      
      return false;
	}
	
   lweapon dropFlame(int x, int y, int sprite) {
      lweapon sparkle = Screen->CreateLWeapon(LW_FIRESPARKLE);
      sparkle->X = x;
      sparkle->Y = y;
      sparkle->Damage = 2;
      sparkle->UseSprite(sprite);
      sparkle->LightRadius = 12;
      
      return sparkle;
   }
}

@Author("Moosh")
lweapon script DieTimeOut {
   void run(int frames) {
      Waitframes(frames);
      this->DeadState = WDS_DEAD;
   }
}




