///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Bosses ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////


@Author("Moosh, modified by Deathrider365")
ffc script Legionnaire {
   CONFIG ATTACK_INITIAL_RUSH = -1;
   CONFIG ATTACK_FIRE_SWORDS = 0;
   CONFIG ATTACK_JUMPS_ON_YOU = 1;
   CONFIG ATTACK_SPRINT_SLASH = 2;
   
   void run(int enemyid) { 
      npc ghost = Ghost_InitAutoGhost(this, enemyid);
      
      if (Screen->State[ST_SECRET]) {
         ghost->Remove();
         Quit();
      }
      
      Ghost_SetFlag(GHF_4WAY);
      
      int screenD = ghost->Attributes[6];
      int startX = ghost->Attributes[7];
      int startY = ghost->Attributes[8];
      int hp = ghost->Attributes[9];
      int combo = ghost->Attributes[10];
      
      int attackCoolDown = 0;
      int attack = -1;
      int startHP = Ghost_HP;
      int movementDirection = Choose(90, -90);
      
      int timeToSpawnAnother, enemyCount;
      int numEnemies = Screen->NumNPCs();
      
      // Intro Animation
      unless (getScreenD(screenD)) {
         Ghost_Y = -32;
         Ghost_X = startX;
         
         for (int i = 0; i < 32; ++i) {
            disableLink();
            Ghost_Waitframe(this, ghost);
         }
         
         Ghost_Y = startY;
         Ghost_Z = 176;
         Ghost_Dir = DIR_DOWN;
         
         while (Ghost_Z) {
            disableLink();
            Ghost_Z -= 4;
            Ghost_Waitframe(this, ghost);
         }
         
         Screen->Quake = 10;
         Audio->PlaySound(SFX_IMPACT_EXPLOSION);
         
         for (int i = 0; i < 32; ++i) {
            disableLink();
            Ghost_Waitframe(this, ghost);
         }
         
         Audio->PlaySound(SFX_STALFOS_GROAN);
         
         setScreenD(screenD, true);
      } 
      else {
         Ghost_X = startX;
         Ghost_Y = startY;
         Ghost_Z = 0;
      }
      
      while(true) {
         Ghost_Data = combo + 4;
         Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Hero->X, Hero->Y));
         int moveAngle = Angle(Ghost_X, Ghost_Y, Hero->X, Hero->Y) + movementDirection;
         numEnemies = Screen->NumNPCs();
         
         Ghost_MoveAtAngle(moveAngle, ghost->Step / 100, 0);
         
         // Calls Reinforcements
         if (timeToSpawnAnother >= 300 && numEnemies < 3) {
            enemyShake(this, ghost, 32, 1);
            Audio->PlaySound(SFX_OOT_WHISTLE);
            
            npc backupLegionnaire = Screen->CreateNPC(ENEMY_LEGIONNAIRE);
            backupLegionnaire->ItemSet = 0;
            backupLegionnaire->HP *= .5;
            backupLegionnaire->Step *= .5;
            backupLegionnaire->Damage *= .5;
            backupLegionnaire->WeaponDamage *= .5;
            
            int pos, x, y;
         
            for (int i = 0; i < 352; ++i) {
               pos = i < 176 ? Rand(176) : i - 176;
                  
               x = ComboX(pos);
               y = ComboY(pos);
               
               if (Distance(Hero->X, Hero->Y, x, y) > 48)
                  if (Ghost_CanPlace(x, y, 16, 16))
                     break;
            }
            
            backupLegionnaire->X = x;
            backupLegionnaire->Y = y;

            timeToSpawnAnother = 0;
         }
         
         if (attackCoolDown)
            --attackCoolDown;
         else {
            attackCoolDown = 90 + Rand(30);
            attack = attackChoice(attack);
            
            switch(attack) {
               case ATTACK_INITIAL_RUSH:
                  jumpsOnYou(this, ghost, combo, Ghost_X, Ghost_X, movementDirection, 32);
                  attackFireSwords(this, ghost, combo, Ghost_X, Ghost_X, movementDirection);
                  attackSprintSlash(this, ghost, combo, Ghost_X, Ghost_X, movementDirection);
                  attack = ATTACK_FIRE_SWORDS;
                  break;
               case ATTACK_FIRE_SWORDS:
                  attackFireSwords(this, ghost, combo, Ghost_X, Ghost_X, movementDirection);
                  break;
               case ATTACK_JUMPS_ON_YOU:
                  jumpsOnYou(this, ghost, combo, Ghost_X, Ghost_X, movementDirection, 32);
                  break;
               case ATTACK_SPRINT_SLASH:
                  attackSprintSlash(this, ghost, combo, Ghost_X, Ghost_X, movementDirection);
                  break;
            }
         }
         
         if (Ghost_HP <= startHP * .5)
            timeToSpawnAnother++;
         
         Ghost_Waitframe(this, ghost);
      }
   }
   
   int attackChoice(int attack) {
      int distanceBetween = Distance(Ghost_X, Ghost_Y, Hero->X, Hero->Y);
      
      if (attack == ATTACK_FIRE_SWORDS) {
         attack = ATTACK_SPRINT_SLASH;
      }
      else if (attack == ATTACK_JUMPS_ON_YOU) {
         if (distanceBetween < 48)
            attack = ATTACK_JUMPS_ON_YOU;
         if (distanceBetween < 64)
            attack = ATTACK_FIRE_SWORDS;
         else
            attack = ATTACK_SPRINT_SLASH;
      }
      else if (attack == ATTACK_SPRINT_SLASH) {
         if (distanceBetween > 64)
            attack = ATTACK_SPRINT_SLASH;
         else if (distanceBetween > 48)
            attack = ATTACK_FIRE_SWORDS;
         else
            attack = ATTACK_JUMPS_ON_YOU;
      }
      return attack;
   }
   
   void attackFireSwords(ffc this, npc ghost, int combo, int ghostX, int ghostY, int movementDirection) {
      Audio->PlaySound(SFX_STALFOS_GROAN_SLOW);
      enemyShake(this, ghost, 48, 1);
      Ghost_Data = combo;
      int weaponDamage = ghost->WeaponDamage + ghost->WeaponDamage * .2;
      
      for (int i = 0; i < 5; ++i) {
         eweapon projectile = FireAimedEWeapon(EW_BEAM, Ghost_X, Ghost_Y, 0, 300, weaponDamage, SPR_LEGIONNAIRESWORD, SFX_SHOOTSWORD, EWF_UNBLOCKABLE);
         Ghost_Waitframes(this, ghost, 16);
      }
      
      Ghost_Waitframes(this, ghost, 16);
      movementDirection = Choose(90, -90);
   }

   void jumpsOnYou(ffc this, npc ghost, int combo, int ghostX, int ghostY, int movementDirection, int shakeDuration) {
      Audio->PlaySound(SFX_STALFOS_GROAN);
      Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Hero->X, Hero->Y));
      enemyShake(this, ghost, shakeDuration, 2);
      Ghost_Data = combo + 8;
      int weaponDamage = ghost->WeaponDamage + ghost->WeaponDamage * .3;
      
      int distance = Distance(Ghost_X, Ghost_Y, Hero->X, Hero->Y);
      int jumpAngle = Angle(Ghost_X, Ghost_Y, Hero->X, Hero->Y);
      
      Ghost_Jump = getJumpLength(distance / 2, true);
      Audio->PlaySound(SFX_JUMP);
      
      while (Ghost_Jump || Ghost_Z) {
         Ghost_MoveAtAngle(jumpAngle, 2, 0);
         Ghost_Waitframe(this, ghost);
      }
      
      Ghost_Data = combo;
      Audio->PlaySound(SFX_IMPACT_EXPLOSION);	
      
      for (int i = 0; i < 24; ++i) {
         makeHitbox(Ghost_X - 12, Ghost_Y - 12, 40, 40, weaponDamage);
         Screen->DrawTile(2, Ghost_X - 16, Ghost_Y - 16, (i > 7 && i <= 15) ? TILE_IMPACT_BIG : TILE_IMPACT_MID, 3, 3, 8, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
         Ghost_Waitframe(this, ghost);
      }
      
      movementDirection = Choose(90, -90);
   }

   void attackSprintSlash(ffc this, npc ghost, int combo, int ghostX, int ghostY, int movementDirection) {
      Audio->PlaySound(SFX_STALFOS_GROAN_FAST);
      enemyShake(this, ghost, 16, 2);
      Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Hero->X, Hero->Y));
      int weaponDamage = ghost->WeaponDamage + ghost->WeaponDamage * .5;
      
      int moveAngle = Angle(Ghost_X, Ghost_Y, Hero->X, Hero->Y);
      int distance = Distance(Ghost_X, Ghost_Y, Hero->X, Hero->Y);
      int dashFrames = Max(6, (distance - 36) / 3);
      
      for (int i = 0; i < dashFrames; ++i) {
         Ghost_MoveAtAngle(moveAngle, 3, 0);
         
         if (i > dashFrames / 2)
            sword1x1(Ghost_X, Ghost_Y, moveAngle - 90, (i - dashFrames / 2) / (dashFrames / 2) * 16, combo + 12, 10, weaponDamage);
            
         Ghost_Waitframe(this, ghost);
      }
      
      Audio->PlaySound(SFX_SWORD);
      
      for (int i = 0; i <= 12; ++i) {
         Ghost_MoveAtAngle(moveAngle, 3, 0);
         sword1x1(Ghost_X, Ghost_Y, moveAngle - 90 + 15 * i, 16, combo + 12, 10, weaponDamage);
         Ghost_Waitframe(this, ghost);
      }
      
      movementDirection = Choose(90, -90);
   }
}

@Author("Moosh, modified by Deathrider365")
ffc script Shambles {
   using namespace ShamblesNamespace;

   void run(int enemyid) {
      npc ghost = Ghost_InitAutoGhost(this, enemyid);
      int combo = ghost->Attributes[10];
      int attackCoolDown = 90;
      int startHP = Ghost_HP;
      int bombsToLob = 3;
      int difficultyMultiplier = 0.5;
      int attack = -1;
      
      Ghost_X = 128;
      Ghost_Y = -32;
      Ghost_Dir = DIR_DOWN;

      if (firstRun) {
         Hero->Stun = 270;
         
         Screen->Quake = 90;
         ShamblesWaitframe(this, ghost, 90, SFX_ROCKINGSHIP);
         
         Ghost_X = 120;
         Ghost_Y = 80;
         Ghost_Data = combo + 4;
         
         Screen->Quake = 60;
         ShamblesWaitframe(this, ghost, 60, SFX_ROCKINGSHIP);
         
         Ghost_Data = combo + 5;
         
         Screen->Quake = 60;
         ShamblesWaitframe(this, ghost, 60, SFX_ROCKINGSHIP);
         
         Ghost_Data = combo + 6;
         
         Screen->Quake = 60;
         ShamblesWaitframe(this, ghost, 60, SFX_ROCKINGSHIP);
      
         Screen->Message(803);
         submerge(this, ghost, 8);
         
         firstRun = false;
      }

      while (true) {
         attack = chooseAttack(attack);
         
         ShamblesWaitframe(this, ghost, 120);
         
         int pos = moveMe();
         Ghost_X = ComboX(pos);
         Ghost_Y = ComboY(pos);
         
         if (Ghost_HP < startHP * difficultyMultiplier) {
            emerge(this, ghost, 4);
            bombsToLob = 5;
         }
         else
            emerge(this, ghost, 8);
         
         switch(attack) {
            case ATTACK_INITIAL_RUSH:
               spawnZambos(this, ghost);
               attackBombLob(this, ghost, startHP, bombsToLob, Ghost_X, Ghost_Y, difficultyMultiplier);
               break;
            case ATTACK_LINK_CHARGE:
               Audio->PlaySound(SFX_MIRROR_SHIELD_ABSORB_LOOP);
               Waitframes(30);
               
               for (int i = 0; i < 5; ++i) {
                  int moveAngle = Angle(Ghost_X, Ghost_Y, Hero->X, Hero->Y);
                  Audio->PlaySound(SFX_SWORD);
                  
                  for (int j = 0; j < 22; ++j) {
                     if (Ghost_HP < startHP * difficultyMultiplier && j % 3 == 0) {
                        eweapon poisonTrail = FireEWeapon(EW_SCRIPT10, Ghost_X + Rand(-2, 2), Ghost_Y + Rand(-2, 2), 0, 0, 1, SPR_POISON_CLOUD, SFX_SIZZLE, EWF_UNBLOCKABLE);
                        SetEWeaponLifespan(poisonTrail, EWL_TIMER, 120);
                        SetEWeaponDeathEffect(poisonTrail, EWD_VANISH, 0);
                     }
                     
                     Ghost_ShadowTrail(this, ghost, false, 4);
                     Ghost_MoveAtAngle(moveAngle, 3, 0);
                     ShamblesWaitframe(this, ghost, 1);
                  }
                  
                  ShamblesWaitframe(this, ghost, 30);
               }
               break;
            case ATTACK_BOMB_LOB:
               attackBombLob(this, ghost, startHP, bombsToLob, Ghost_X, Ghost_Y, difficultyMultiplier);
               break;
            case ATTACK_SPAWN_ZAMBIES:
               spawnZambos(this, ghost);
               break;
         }
         
         if (Ghost_HP < startHP * 0.50)
            submerge(this, ghost, 4);
         else
            submerge(this, ghost, 8);
         
         pos = moveMe();
         Ghost_X = ComboX(pos);
         Ghost_Y = ComboY(pos);
      }
   }
   
   void attackBombLob(ffc this, npc ghost, int startHP, int bombsToLob, int Ghost_X, int Ghost_Y, int difficultyMultiplier) {
      Audio->PlaySound(SFX_OOT_BIG_DEKU_BABA_LUNGE);
      Waitframes(30);
      
      for (int i = 0; i < bombsToLob; ++i) {
         ShamblesWaitframe(this, ghost, 16);
         eweapon bomb = FireAimedEWeapon(EW_BOMB, Ghost_X, Ghost_Y, 0, 200, ghost->WeaponDamage, -1, -1, EWF_UNBLOCKABLE | EWF_ROTATE);
         Audio->PlaySound(SFX_LAUNCH_BOMBS);
         runEWeaponScript(bomb, Game->GetEWeaponScript("ArcingWeapon"), {-1, 0, (Ghost_HP < (startHP * difficultyMultiplier)) ? AE_LARGEPOISONPOOL : AE_SMALLPOISONPOOL});
         Waitframes(6);
      }
   }

   void spawnZambos(ffc this, npc ghost) {
      for (int i = 0; i < 3; ++i) {
         Audio->PlaySound(SFX_SUMMON_MINE);
         int zamboChoice = Rand(0, 2);
         npc zambo;
         
         if (zamboChoice == 0)
            zambo = Screen->CreateNPC(ENEMY_ZOMBIE_LV1_POPUP);
         else if (zamboChoice == 1)
            zambo = Screen->CreateNPC(ENEMY_ZOMBIE_LV1);
         else
            zambo = Screen->CreateNPC(ENEMY_ZOMBIE_LV1_SPRINTING);
            
         int pos = moveMe();
         
         zambo->X = ComboX(pos);
         zambo->Y = ComboY(pos);
         
         ShamblesWaitframe(this, ghost, 30);
      
      }	
   }
}

@Author("EmilyV99, Deathrider365")
npc script Hazarond {
   using namespace EnemyNamespace;
   using namespace HazarondNamespace;
   
   CONFIG DEFAULT_COMBO = 10272;
   CONFIG JUMP_PREP_COMBO = 10273;
   CONFIG JUMPING_COMBO = 10274;
   CONFIG JUMP_LANDING_COMBO = 10275;
   
   CONFIG TIME_BETWEEN_ATTACKS = 180;
   
   void run(int hurtCSet, int minion) {
      if (firstRun)
         disableLink();
         
      setupNPC(this);
      
      untyped data[SZ_DATA];
      int oCSet = this->CSet;
      int timeSinceLastAttack = 180;
      
      setNPCToCombo(data, this, DEFAULT_COMBO);
      
      npc heads[4];
      
      int eweaponStopper = Game->GetEWeaponScript("StopperKiller");
      
      bitmap effectBitmap = create(256, 168);
      this->Immortal = true;
      
      const int maxHp = this->HP;
      
      for (int headIndex = 0; headIndex < 4; ++headIndex) {
         heads[headIndex] = Screen->CreateNPC(minion);
         heads[headIndex]->InitD[0] = this;
         heads[headIndex]->Dir = headIndex + 4;
      }
      
      if (firstRun) {
         disableLink();
         commenceIntroSequence(this, data, heads);
         Screen->Message(804);
         firstRun = false;
      }
      else
         Audio->PlayEnhancedMusic("The Binding of Isaac - Divine Combat.ogg", 0);
      
      disableLink();
      
      while(this->HP > 0) {
         int previousAttack;
         
         int angle;
         int headOpen = 20;
         int headOpenIndex;
         
         while(true) {
            if (isHeadsDead(heads))
               break;
            
            for (int i = 0; i < 20; ++i)
               this->Defense[i] = NPCDT_IGNORE;
            
            for (int i = 0; i < 4; ++i)
               if (heads[i])
                  heads[i]->CollDetection = true;
               
            if (headOpen == 20) {
               headOpenIndex = RandGen->Rand(3);
               
               until (heads[headOpenIndex])
                  headOpenIndex = RandGen->Rand(3);
            
               if (heads[headOpenIndex])
                  heads[headOpenIndex]->OriginalTile -= 1;
            }
            
            if (headOpen == 0) {
               if (heads[headOpenIndex])
                  heads[headOpenIndex]->OriginalTile += 1;
               
               headOpenIndex = RandGen->Rand(3);
               
               until (heads[headOpenIndex])
                  headOpenIndex = RandGen->Rand(3);
                  
               if (heads[headOpenIndex])
                  heads[headOpenIndex]->OriginalTile -= 1;
                  
               headOpen = 20;
            }
               
            angle = RadtoDeg(TurnTowards(CenterX(this), CenterY(this), CenterLinkX(), CenterLinkY(), 0, 1));
            
            unless (data[DATA_CLK] % 3)
               this->MoveAtAngle(angle, 1, SPW_NONE);
            
            bool justSprayed = false;
            
            if (TIME_BETWEEN_ATTACKS <= timeSinceLastAttack) {
               if (heads[headOpenIndex])
                  heads[headOpenIndex]->OriginalTile += 1;
                  
               oilSpray(data, this, heads, isDifficultyChange(this, maxHp));
               
               headOpen = 21;
               justSprayed = true;
               timeSinceLastAttack = 0;
            }
            
            if (this->HP <= 0)
               deathAnimation(this, 142);
               
            if (isHeadsDead(heads))
               break;
            
            if (linkClose(this, 32)) {
               timeSinceLastAttack += 60;
            
               if (heads[headOpenIndex] && timeSinceLastAttack != 0 && !justSprayed)
                  heads[headOpenIndex]->OriginalTile += 1;
                  
               headOpen = 21;
               
               groundPound(this, data, heads, headOpenIndex);
               
               if (HazarondWaitframe(this, data, 45, heads))
                  break;
            }
            
            if (headOpen == 10)
               if (heads[headOpenIndex] && heads[headOpenIndex]->isValid())
                  dropFlame(heads, headOpenIndex, eweaponStopper);
            
            ++timeSinceLastAttack;
            --headOpen;
            
            EnemyWaitframe(this, data);
         }
         
         this->CollDetection = true;
         int originalCSet = this->CSet;
         this->CSet = hurtCSet;
         
         for (int i = 0; i < 20; ++i) {
            if (i == NPCD_FIRE)
               this->Defense[i] = NPCDT_IGNORE;
            else if(i == NPCD_ARROW)
               this->Defense[i] = NPCDT_BLOCK;
            else
               this->Defense[i] = NPCDT_NONE;
         }
         
         for(int i = 0; i < 10; ++i)
            EnemyWaitframe(this, data);
         
         int previousX, previousY, prevIndex;
         
         int fleeDuration = 5 * 60;
         
         while (fleeDuration) {
            if (this->HP <= 0)
               deathAnimation(this, 142);
            
            angle = RadtoDeg(TurnTowards(CenterX(this), CenterY(this), CenterLinkX(), CenterLinkY(), 0, 1));
            
            if ((!(this->CanMove(this->Dir, 1, 0)) || (this->X == previousX && this->Y == previousY)) && linkClose(this, 48))
               stuckAction(this, data, fleeDuration);
            
            previousX = this->X;
            previousY = this->Y;
            
            this->MoveAtAngle(180 + angle, 1, SPW_NONE);
            
            --fleeDuration;
            EnemyWaitframe(this, data);
         }
         
         EnemyWaitframe(this, data, 60);
         
         if (this->HP <= 0)
            deathAnimation(this, 142);
         
         int centerX = 256 / 2;
         int centerY = 176 / 2 - 16;
         
         while(Distance(this->X + this->HitXOffset + this->HitWidth / 2, this->Y + this->HitYOffset + this->HitHeight / 2, centerX, centerY) > 3)
            while (MoveTowardsPoint(this, centerX, centerY, 2, SPW_FLOATER, true))
               EnemyWaitframe(this, data, 2);
         
         this->CollDetection = false;
         
         for (int i = 0; i < 20; ++i)
            this->Defense[i] == NPCDT_IGNORE;
            
         data[DATA_INVIS] = true;
         
         for (int i = 0; i < 32; ++i) {
            for(int j = 0; j < 4; ++j) {
               effectBitmap->Clear(0);
               effectBitmap->DrawTile(4, this->X, this->Y + i, this->ScriptTile, 2, 2, this->CSet, -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
               effectBitmap->Rectangle(4, this->X - 8, 167, this->X + 39, this->Y + 31, 0, -1, 0, 0, 0, true, OP_OPAQUE);
               effectBitmap->Blit(4, RT_SCREEN, 0, 0, 256, 168, 0, 0, 256, 168, 0, 0, 0, BITDX_NORMAL, 0, true);
               Screen->DrawCombo(4, this->X, this->Y + 24, 6725, 1, 1, 2, -1, -1, 0, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
               Screen->DrawCombo(4, this->X + 16, this->Y + 24, 6725, 1, 1, 2, -1, -1, 0, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
               
               EnemyWaitframe(this, data);
            }
         }
         
         for (int headIndex = 0; headIndex < 4; ++headIndex) {
            heads[headIndex] = Screen->CreateNPC(minion);
            heads[headIndex]->InitD[0] = this;
            heads[headIndex]->Dir = headIndex + 4;
            heads[headIndex]->DrawXOffset = 1000;
            heads[headIndex]->CollDetection = false;
         }
         
         this->CSet = originalCSet;
         
         for (int i = 31; i >= 0; --i) {				
            for(int j = 0; j < 4; ++j) {
               effectBitmap->Clear(0);
               effectBitmap->DrawTile(4, this->X, this->Y + i, this->ScriptTile, 2, 2, this->CSet, -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
               
               for (int headIndex = 0; headIndex < 4; ++headIndex)
                  effectBitmap->DrawTile(4, heads[headIndex]->X, heads[headIndex]->Y + i - 2, heads[headIndex]->ScriptTile, 1, 1, heads[headIndex]->CSet, -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
               
               effectBitmap->Rectangle(4, this->X - 8, 167, this->X + 39, this->Y + 31, 0, -1, 0, 0, 0, true, OP_OPAQUE);
               effectBitmap->Blit(4, RT_SCREEN, 0, 0, 256, 168, 0, 0, 256, 168, 0, 0, 0, BITDX_NORMAL, 0, true);
               Screen->DrawCombo(4, this->X, this->Y + 24, 6725, 1, 1, 2, -1, -1, 0, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
               Screen->DrawCombo(4, this->X + 16, this->Y + 24, 6725, 1, 1, 2, -1, -1, 0, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
               
               EnemyWaitframe(this, data);
            }
         }
         
         this->HP += 6;
         data[DATA_INVIS] = false;
         this->CollDetection = true;
         
         for (int headIndex = 0; headIndex < 4; ++headIndex)
            heads[headIndex]->DrawXOffset = 0;		
      }
      
      effectBitmap->Free();
      this->CollDetection = false;
      deathAnimation(this, 142);
   }
}

@Author("EmilyV99, Deathrider365")
npc script OvergrownRaccoon {
   using namespace OvergrownRaccoonNamespace;
   using namespace EnemyNamespace;
   
   void run() {
      disableLink();
      State state = STATE_NORMAL;
      State previousState = state;
      const int maxHp = this->HP;
      int timer;
      
      this->Dir = faceLink(this);
      
      until (this->Z == 0)
         Waitframe();
      
      Screen->Quake = 60;
      Audio->PlaySound(SFX_IMPACT_EXPLOSION);
      
      Waitframes(30);
      
      disableLink();
      
      unless (getScreenD(255)) {
         Screen->Message(805);
         setScreenD(255, true);
      }
         
      while(true) {
         if (this->HP <= 0)
            deathAnimation(this, 136);
            
         int randModifier = isDifficultyChange(this, maxHp) ? Rand(-90, 30) : Rand(-60, 60);
         
         if (++timer > 120 + randModifier) {
            timer = 0;
            int attackChoice = 0;
            
            if (Screen->NumNPCs() > 5 && Screen->NumNPCs() < 10)
               attackChoice = STATE_RACCOON_THROW;
            else if (previousState == STATE_SMALL_ROCKS_THROW)
               attackChoice = RandGen->Rand(1, 4);
            else if (previousState == STATE_CHARGE)
               attackChoice = RandGen->Rand(2, 4);
            else
               attackChoice = RandGen->Rand(4);
               
            state = parseAttackChoice(attackChoice);
         }
         
         switch(state) {
            case STATE_NORMAL: {
               previousState = state;
               this->ScriptTile = -1;
               doWalk(this, 5, 10, this->Step);
               break;
            }
            case STATE_LARGE_ROCK_THROW: {
               previousState = state;
               
               Waitframes(60);
               
               eweapon rockProjectile = FireBigAimedEWeapon(196, CenterX(this) - 8, CenterY(this) - 8, 0, 255, 6, 119, -1, EWF_UNBLOCKABLE, 2, 2);
               Audio->PlaySound(SFX_LAUNCH_BOMBS);
               runEWeaponScript(rockProjectile, Game->GetEWeaponScript("ArcingWeapon"), {-1, 0, AE_BOULDER_PROJECTILE});
               state = STATE_NORMAL;
               break;
            }
            case STATE_SMALL_ROCKS_THROW: {
               previousState = state;
               
               Waitframes(30);
               
               for(int i = 0; i < 60; ++i) {
                  if (this->HP <= 0)
                     deathAnimation(this, 136);
                     
                  this->ScriptTile = this->OriginalTile + (this->Tile % 8) + 52;
                  
                  unless (i % 20) {
                     eweapon rockProjectile = FireAimedEWeapon(195, CenterX(this) - 8, CenterY(this) - 8, 0, 255, 3, SPR_SMALL_ROCK, -1, EWF_UNBLOCKABLE | EWF_ROTATE);
                     Audio->PlaySound(SFX_LAUNCH_BOMBS);
                     runEWeaponScript(rockProjectile, Game->GetEWeaponScript("ArcingWeapon"), {-1, 0, AE_ROCK_PROJECTILE});
                  }
                  
                  Waitframe();
               }
               
               state = STATE_NORMAL;
               break;
            }
            case STATE_RACCOON_THROW: {
               previousState = state;
               
               Waitframes(60);
               
               for (int i = 0; i < 2; ++i) {
                  if (this->HP <= 0)
                     deathAnimation(this, 136);
                     
                  Waitframes(5);
                  
                  eweapon raccoonProjectile = FireAimedEWeapon(197, CenterX(this) - 8, CenterY(this) - 8, 0, 255, 1, 121, -1, EWF_UNBLOCKABLE | EWF_ROTATE_360);
                  Audio->PlaySound(SFX_LAUNCH_BOMBS);
                  runEWeaponScript(raccoonProjectile, Game->GetEWeaponScript("ArcingWeapon"), {-1, 0, AE_RACCOON_PROJECTILE});
               }
               
               state = STATE_NORMAL;
               break;
            }
            case STATE_CHARGE: {
               previousState = state;
               
               int angle = RadtoDeg(TurnTowards(CenterX(this), CenterY(this), CenterLinkX(), CenterLinkY(), 0, 1));
               this->Dir = AngleDir4(angle);
               this->ScriptTile = -1;
               
               this->Jump = 2.5;
               
               do Waitframe(); while(this->Z);
               
               while(this->MoveAtAngle(angle, 4, SPW_NONE))
                  Waitframe();
               
               this->Jump = 2;
               Screen->Quake = 30;
               Audio->PlaySound(SFX_IMPACT_EXPLOSION);
               
               do Waitframe(); while(this->Z);
               
               state = STATE_NORMAL;
               break;
            }
         }
         
         Waitframe();
      }
   }
}

@Author("EmilyV99, Moosh, Deathrider365")
npc script ServusMalus {
   using namespace EnemyNamespace;
   using namespace ServusMalusNamespace;
   
   void run() {
      CONFIG originalTile = this->OriginalTile;
      CONFIG attackingTile = 49660;
      CONFIG unarmedTile = 49740;
      
      bool gettingDesperate = false;
      bool torchesLit = false;
      int unlitTorch = 7156;
      int litTorch = 7157;
      
      int upperLeftTorchLoc = 36;
      int upperRightTorchLoc = 43;
      int lowerLeftTorchLoc = 132;
      int lowerRightTorchLoc = 139;
      
      int bigSummerBlowout = 6928;
      int invisibleTile = 49220;
      
      int attackCooldown, timer;
      
      combodata cmbLitTorch = Game->LoadComboData(litTorch);
      cmbLitTorch->Attribytes[0] = 32;
      
      mapdata mapData, template;
      
      this->X = -32;
      this->Y = -32;
      int maxHp = this->HP;
      
      Audio->PlayEnhancedMusic(NULL, 0);
      
      if (getScreenD(254))
         Audio->PlayEnhancedMusic("Bloodborne PSX - Cleric Beast.ogg", 0);
         
      until (getScreenD(254)) {
         int litTorchCount = 0;
      
         template = Game->LoadTempScreen(1);
         
         litTorchCount += <int> (template->ComboD[upperLeftTorchLoc] == litTorch);
         litTorchCount += <int> (template->ComboD[upperRightTorchLoc] == litTorch);
         litTorchCount += <int> (template->ComboD[lowerLeftTorchLoc] == litTorch);
         litTorchCount += <int> (template->ComboD[lowerRightTorchLoc] == litTorch);
         
         checkTorchBrightness(litTorchCount, cmbLitTorch);
            
         if (litTorchCount == 4) {
            torchesLit = true;
            setScreenD(254, true);
            commenceIntroCutscene(this, template, unlitTorch, cmbLitTorch, bigSummerBlowout, upperLeftTorchLoc, upperRightTorchLoc, lowerLeftTorchLoc, lowerRightTorchLoc, originalTile, attackingTile);
            
            Audio->PlayEnhancedMusic("Bloodborne PSX - Cleric Beast.ogg", 0);
            Screen->Message(806);
         }
         
         Waitframe();
      }
      
      this->X = 128;
      this->Y = 32;
      
      while(true) {
         this->Z = 20;
         this->CollDetection = false;
         this->OriginalTile = invisibleTile;
         
         int blowOutRandomTorchTimer = 180;
         int chosenTorch;
         int spawnTimer = 90;
         int maxEnemies = 5;
         
         torchesLit = false;
         int vectorX, vectorY;
         
         until (torchesLit) {
            template = Game->LoadTempScreen(1);
            
            int litTorchCount = 0;
            
            int litTorches[4];
            int allTorches[4] = {upperLeftTorchLoc, upperRightTorchLoc, lowerLeftTorchLoc, lowerRightTorchLoc};

            for (int q = 0; q < 4; ++q)
               if (template->ComboD[allTorches[q]] == litTorch)
                  litTorches[litTorchCount++] = allTorches[q];
            
            ResizeArray(litTorches, litTorchCount);
            
            checkTorchBrightness(litTorchCount, cmbLitTorch);
            
            unless (chosenTorch || --blowOutRandomTorchTimer) {
               for (int i = 0; i < SizeOfArray(litTorches); i++) {
                  if (!chosenTorch) 
                     chosenTorch = litTorches[0];
                  
                  int selectedTorchDistance = Distance(this->X - 12, this->Y - 12, ComboX(litTorches[i]) - 8, ComboY(litTorches[i]) - 8);
                  int chosenTorchDistance = Distance(this->X - 12, this->Y - 12, ComboX(chosenTorch) - 8, ComboY(chosenTorch) - 8);
                  chosenTorch = (chosenTorchDistance < selectedTorchDistance) ? chosenTorch : litTorches[i];
               }
            
               blowOutRandomTorchTimer = 120;
            }
            
            if (chosenTorch) {
               int moveAngle = Angle(this->X + 12, this->Y + 12, ComboX(chosenTorch) + 8, ComboY(chosenTorch) + 8);
               
               vectorX = VectorX(Hero->Step / 100, moveAngle);
               vectorY = VectorY(Hero->Step / 100, moveAngle);
               
               if (Distance(this->X + 12, this->Y + 12, ComboX(chosenTorch) + 8, ComboY(chosenTorch) + 8) < 16) {
                  if (int escr = CheckEWeaponScript("StopperKiller")) {
                     eweapon ewind = RunEWeaponScriptAt(EW_SCRIPT2, escr, ComboX(chosenTorch), ComboY(chosenTorch), {0, 60});
                     ewind->Unblockable = UNBLOCK_ALL;
                     ewind->UseSprite(128);
                     ewind->Damage = 2;
                  }
                  
                  Audio->PlaySound(SFX_ONOX_TORNADO);
                  chosenTorch = 0;
               }
            } else {
               vectorX = lazyChase(vectorX, this->X + 12, Hero->X - 8, .05, Hero->Step / 100);
               vectorY = lazyChase(vectorY, this->Y + 12, Hero->Y - 8, .05, Hero->Step / 100);
            }
            
            unless(spawnTimer) {
               spawnEnemy(this);
               spawnTimer = 90;
            }

            this->MoveXY(vectorX, vectorY, SPW_FLOATER);
            this->Dir = faceLink(this);
            
            if (litTorchCount == 4)	
               torchesLit = true;
            
            if ((Screen->NumNPCs() - 1) < maxEnemies && chosenTorch == 0)
               --spawnTimer;
            
            Waitframe();
         }
         
         Audio->PlaySound(SFX_MC_BOUNDCHEST_ROAR2);
         
         this->CollDetection = true;
         this->OriginalTile = originalTile;
         
         for (int i = 0; i < 90; ++i)
            Waitframe();
         
         vectorX = 0;
         vectorY = 0;
         
         attackCooldown = gettingDesperate ? 60 : 90;
         timer = 0;
         CONFIG START_TIMER = 600;
         int dodgeTimer;
         
         while(timer < START_TIMER) {
            if (this->HP <= maxHp * .3)
               gettingDesperate = true;
               
            float percent = timer / START_TIMER;
               
            cmbLitTorch->Attribytes[0] = Lerp(24, 50, 1 - percent);
            
            if (this->HP <= 0)
               deathAnimation(this, SFX_GOMESS_DIE);
               
            if (this->Z > 0 && !(gameframe % 2))
               this->Z -= 1;
            
            unless (attackCooldown) {
               chooseAttack(this, originalTile, attackingTile, unarmedTile, gettingDesperate);
               attackCooldown = gettingDesperate ? 60 : 90;
            }
            
            int angle = Angle(Hero->X - 8, Hero->Y - 8, this->X, this->Y);
            
            int tX = Hero->X - 8 + VectorX(30, angle);
            int tY = Hero->Y - 8 + VectorY(30, angle);
            
            if (dodgeTimer)
               --dodgeTimer;
               
            if (dodgeTimer || tX < 0 || tX > 255 - 32 || tY < 0 || tY > 175 - 32) {
               tX = 128 - 16;
               tY = 88 - 16;
               
               unless (dodgeTimer) {
                  int dodgeAngle = Angle(this->X, this->Y, tX, tY);
                  int diff = angleDiff(dodgeAngle, angle);
                  
                  dodgeAngle += diff < 0 ? -90 : 90;
                  
                  vectorX = VectorX(Hero->Step / 100, dodgeAngle);
                  vectorY = VectorY(Hero->Step / 100, dodgeAngle);
                  dodgeTimer = 90;
               }
            }
            
            vectorX = lazyChase(vectorX, this->X, tX, .05, Hero->Step / 100);
            vectorY = lazyChase(vectorY, this->Y, tY, .05, Hero->Step / 100);
            this->MoveXY(vectorX, vectorY, SPW_FLOATER);
            this->Dir = faceLink(this);
            
            --attackCooldown;
            ++timer;
            Waitframe();
         }
         
         while (Distance(this->X, this->Y, 128, 88) > 64) {
            if (this->HP <= 0)
               deathAnimation(this, 148);
               
            int angle = Angle(Hero->X - 8, Hero->Y - 8, this->X - 12, this->Y - 12);
            
            int tX = Hero->X - 8 + VectorX(30, angle);
            int tY = Hero->Y - 8 + VectorY(30, angle);
            
            if (dodgeTimer)
               --dodgeTimer;
               
            if (dodgeTimer || tX < 0 || tX > 255 - 32 || tY < 0 || tY > 175 - 32) {
               tX = 128 - 16;
               tY = 88 - 16;
               
               unless (dodgeTimer) {
                  int dodgeAngle = Angle(this->X, this->Y, tX, tY);
                  int diff = angleDiff(dodgeAngle, angle);
                  
                  dodgeAngle += diff < 0 ? -90 : 90;
                  
                  vectorX = VectorX(Hero->Step / 100, dodgeAngle);
                  vectorY = VectorY(Hero->Step / 100, dodgeAngle);
                  dodgeTimer = 90;
               }
            }
            
            vectorX = lazyChase(vectorX, this->X, tX, .05, Hero->Step / 100);
            vectorY = lazyChase(vectorY, this->Y, tY, .05, Hero->Step / 100);
            this->MoveXY(vectorX, vectorY, SPW_FLOATER);
            this->Dir = faceLink(this);
            
            Waitframe();
         }
         
         int unlitTorchCount = 0;
         
         int multipler = 1;
            
         do {
            if (this->HP <= 0)
               deathAnimation(this, 148);
               
            unlitTorchCount = 0;
            
            unless(gameframe % 60) {
               windBlast(this, originalTile, attackingTile, multipler);
               ++multipler;
            }
            
            unlitTorchCount += <int> (template->ComboD[upperLeftTorchLoc] == litTorch);
            unlitTorchCount += <int> (template->ComboD[upperRightTorchLoc] == litTorch);
            unlitTorchCount += <int> (template->ComboD[lowerLeftTorchLoc] == litTorch);
            unlitTorchCount += <int> (template->ComboD[lowerRightTorchLoc] == litTorch);
            
            checkTorchBrightness(unlitTorchCount, cmbLitTorch, 1);
            
            Waitframe();
            
         } while(unlitTorchCount)

         Waitframe();
      }
   }

   void commenceIntroCutscene(
      npc this, 
      mapdata template, 
      int unlitTorch, 
      combodata cmbLitTorch, 
      int bigSummerBlowout, 
      int upperLeftTorchLoc,  
      int upperRightTorchLoc, 
      int lowerLeftTorchLoc, 
      int lowerRightTorchLoc, 
      int originalTile, 
      int attackingTile
   ) {
      int soldierLeftFast = 6715;
      int soldierUpStunned = 6714;
      int soldierUpLaying = 6709;
      int soldierUp = 6722;
      int soldierDown = 6723;
      int soldierLeft = 6726;
      int soldierRight = 6727;
      int servusFullStartingCombo = 6916;
      int servusTransStartingCombo = 6920;
      int servusAttackingStartingCombo = 6924;
      int servusMovingUpStartingCombo = 6932;
      int servusVanishingStartingCombo = 6936;
      int servusTurningStartingCombo = 6940;
      
      // Buffer
      for (int i = 0; i < 120; ++i) {
         disableLink();
         Waitframe();
      }
   
      Hero->X = 32;
      Hero->Y = 80;
      Hero->Dir = DIR_RIGHT;
      
      int xLocation = 256;
      
      // Soldier walks in from right
      until (xLocation == 120) {
         disableLink();
         Screen->FastCombo(2, xLocation, 80, soldierLeftFast, 0, OP_OPAQUE);
         --xLocation;
         
         Waitframe();
      }
      
      // Turns up 
      for (int i = 0; i < 120; ++i) {
         disableLink();
         Screen->FastCombo(2, 120, 80, soldierUp, 0, OP_OPAQUE);
         
         if (i == 60) 
            Screen->Message(167);

         Waitframe();
      }
      
      // Turns left
      for (int i = 0; i < 120; ++i) {
         disableLink();
         Screen->FastCombo(2, 120, 80, soldierLeft, 0, OP_OPAQUE);
         
         if (i == 60) 
            Screen->Message(168);
            
         Waitframe();
      }
      
      // Turns right
      for (int i = 0; i < 120; ++i) {
         disableLink();
         Screen->FastCombo(2, 120, 80, soldierRight, 0, OP_OPAQUE);
         
         if (i == 60) 
            Screen->Message(169);
         
         Waitframe();
      }
      
      int modifier;
      int counter;
      bool alternate;
      
      // Turns up and buffer
      for (int i = 0; i < 60; ++i) {
         disableLink();
         if (i % 4) {				
            Screen->FastCombo(2, 112, 32, servusTransStartingCombo, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 32, servusTransStartingCombo + 1, 3, OP_OPAQUE);
            Screen->FastCombo(2, 112, 48, servusTransStartingCombo + 2, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 48, servusTransStartingCombo + 3, 3, OP_OPAQUE);
         }
         
         Screen->FastCombo(1, 120, 80, soldierUp, 0, OP_OPAQUE);
         Waitframe();
      }
      
      Audio->PlayEnhancedMusic("Metroid Fusion - Environmental Intrigue.ogg", 0);

      // Servus apparates in 
      for (int i = 0; i < 300; ++i) {
         disableLink();
         
         if (i < 120)
            modifier = 1;
         else if (i < 210) 
            modifier = 2;
         else if (i < 270) 
            modifier = 4;
         else if (i < 300) 
            modifier = 8;
         
         if (counter > modifier) {
            counter = 0;
            alternate = !alternate;
         }
         
         if (alternate) {
            Screen->FastCombo(2, 112, 32, servusFullStartingCombo, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 32, servusFullStartingCombo + 1, 3, OP_OPAQUE);
            Screen->FastCombo(2, 112, 48, servusFullStartingCombo + 2, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 48, servusFullStartingCombo + 3, 3, OP_OPAQUE);
         }
         else {
            Screen->FastCombo(2, 112, 32, servusTransStartingCombo, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 32, servusTransStartingCombo + 1, 3, OP_OPAQUE);
            Screen->FastCombo(2, 112, 48, servusTransStartingCombo + 2, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 48, servusTransStartingCombo + 3, 3, OP_OPAQUE);
         }
         
         Screen->FastCombo(2, 120, 80, soldierUp, 0, OP_OPAQUE);
         
         counter++;
         Waitframe();
      }
      
      Screen->Message(170);
      
      // Servus fully appears
      for (int i = 0; i < 60; ++i) {
         disableLink();
         
         Screen->FastCombo(2, 112, 32, servusFullStartingCombo, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 32, servusFullStartingCombo + 1, 3, OP_OPAQUE);
         Screen->FastCombo(2, 112, 48, servusFullStartingCombo + 2, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 48, servusFullStartingCombo + 3, 3, OP_OPAQUE);
         
         Screen->FastCombo(2, 120, 80, soldierUp, 0, OP_OPAQUE);
         
         Waitframe();
      }
      
      Screen->Message(172);
      
      // Buffer
      for (int i = 0; i < 60; ++i) {
         disableLink();
         
         Screen->FastCombo(2, 112, 32, servusFullStartingCombo, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 32, servusFullStartingCombo + 1, 3, OP_OPAQUE);
         Screen->FastCombo(2, 112, 48, servusFullStartingCombo + 2, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 48, servusFullStartingCombo + 3, 3, OP_OPAQUE);
         
         Screen->FastCombo(2, 120, 80, soldierUp, 0, OP_OPAQUE);
         
         if (i == 59)
            Screen->Message(174);
         
         Waitframe();
      }
      
      // Turns around
      for (int i = 0; i < 15; ++i) {
         disableLink();
         
         if (i < 8) {
            Screen->FastCombo(2, 112, 32, servusTurningStartingCombo, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 32, servusTurningStartingCombo + 1, 3, OP_OPAQUE);
            Screen->FastCombo(2, 112, 48, servusTurningStartingCombo + 2, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 48, servusTurningStartingCombo + 3, 3, OP_OPAQUE);
         }
         else {
            Screen->FastCombo(2, 112, 32, servusMovingUpStartingCombo, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 32, servusMovingUpStartingCombo + 1, 3, OP_OPAQUE);
            Screen->FastCombo(2, 112, 48, servusMovingUpStartingCombo + 2, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 48, servusMovingUpStartingCombo + 3, 3, OP_OPAQUE);
         }
         
         Screen->FastCombo(2, 120, 80, soldierUp, 0, OP_OPAQUE);
         
         Waitframe();
      }
      
      Screen->Message(177);
      
      // Turns around
      for (int i = 0; i < 15; ++i) {
         disableLink();
         
         if (i < 8) {
            Screen->FastCombo(2, 112, 32, servusMovingUpStartingCombo, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 32, servusMovingUpStartingCombo + 1, 3, OP_OPAQUE);
            Screen->FastCombo(2, 112, 48, servusMovingUpStartingCombo + 2, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 48, servusMovingUpStartingCombo + 3, 3, OP_OPAQUE);
         } else {
            Screen->FastCombo(2, 112, 32, servusFullStartingCombo, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 32, servusFullStartingCombo + 1, 3, OP_OPAQUE);
            Screen->FastCombo(2, 112, 48, servusFullStartingCombo + 2, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 48, servusFullStartingCombo + 3, 3, OP_OPAQUE);
         }
         
         Screen->FastCombo(2, 120, 80, soldierUp, 0, OP_OPAQUE);
         
         Waitframe();
      }
      
      // Servus about to charge
      for (int i = 0; i < 30; ++i) {
         disableLink();
         
         Screen->FastCombo(2, 112, 32, servusFullStartingCombo, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 32, servusFullStartingCombo + 1, 3, OP_OPAQUE);
         Screen->FastCombo(2, 112, 48, servusFullStartingCombo + 2, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 48, servusFullStartingCombo + 3, 3, OP_OPAQUE);
         
         Screen->FastCombo(2, 120, 80, soldierUp, 0, OP_OPAQUE);
         Waitframe();
      }
      
      // Servus charges at soldier
      for (int i = 0; i < 30; ++i) {
         disableLink();
         
         Screen->FastCombo(2, 112, 32 + i, servusAttackingStartingCombo, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 32 + i, servusAttackingStartingCombo + 1, 3, OP_OPAQUE);
         Screen->FastCombo(2, 112, 48 + i, servusAttackingStartingCombo + 2, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 48 + i, servusAttackingStartingCombo + 3, 3, OP_OPAQUE);
         
         Screen->FastCombo(2, 120, 80, soldierUp, 0, OP_OPAQUE);
         Waitframe();
      }
      
      Audio->PlaySound(144);

      // Soldier flies back
      int distanceTraveled = 2;
      
      until (distanceTraveled == 64) {
         disableLink();
         
         Screen->FastCombo(2, 112, 62, servusFullStartingCombo, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 62, servusFullStartingCombo + 1, 3, OP_OPAQUE);
         Screen->FastCombo(2, 112, 78, servusFullStartingCombo + 2, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 78, servusFullStartingCombo + 3, 3, OP_OPAQUE);
         
         Screen->FastCombo(2, 120, 80 + distanceTraveled, soldierUpStunned, 0, OP_OPAQUE);
         
         distanceTraveled += 2;
         Waitframe();
      }

      Audio->PlaySound(121);
      Screen->Quake = 20;
      setScreenD(253, true);
      
      // Buffer as soldier is against the wall
      for (int i = 0; i < 30; ++i) {
         disableLink();
         
         Screen->FastCombo(2, 112, 62, servusFullStartingCombo, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 62, servusFullStartingCombo + 1, 3, OP_OPAQUE);
         Screen->FastCombo(2, 112, 78, servusFullStartingCombo + 2, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 78, servusFullStartingCombo + 3, 3, OP_OPAQUE);
         
         Waitframe();
      }
      
      Screen->Message(179);
      
      // Link intervenes
      until (Hero->X >= 120) {
         disableLink();
         
         if (Hero->Y <= 96) {
            Hero->InputRight = true;
            Hero->InputDown = true;
         }
         else
            Hero->InputRight = true;
         
         Screen->FastCombo(2, 112, 62, servusFullStartingCombo, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 62, servusFullStartingCombo + 1, 3, OP_OPAQUE);
         Screen->FastCombo(2, 112, 78, servusFullStartingCombo + 2, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 78, servusFullStartingCombo + 3, 3, OP_OPAQUE);
         
         Waitframe();
      }
      
      Hero->Dir = DIR_UP;
      
      // Buffer as link just got in front of Servus
      for (int i = 0; i < 30; ++i) 			{
         disableLink();
         
         Screen->FastCombo(2, 112, 62, servusFullStartingCombo, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 62, servusFullStartingCombo + 1, 3, OP_OPAQUE);
         Screen->FastCombo(2, 112, 78, servusFullStartingCombo + 2, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 78, servusFullStartingCombo + 3, 3, OP_OPAQUE);
         
         Waitframe();
      }
      
      Screen->Message(180);
      
      // Buffer before Big Summer Blowout
      for (int i = 0; i < 30; ++i) {
         disableLink();
         
         Screen->FastCombo(2, 112, 62, servusFullStartingCombo, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 62, servusFullStartingCombo + 1, 3, OP_OPAQUE);
         Screen->FastCombo(2, 112, 78, servusFullStartingCombo + 2, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 78, servusFullStartingCombo + 3, 3, OP_OPAQUE);
         
         Waitframe();
      }
      
      // Servus moves up for the Big Summer Blowout
      for (int i = 0; i < 48; ++i) {
         disableLink();
         
         Screen->FastCombo(2, 112, 62 - i, servusMovingUpStartingCombo, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 62 - i, servusMovingUpStartingCombo + 1, 3, OP_OPAQUE);
         Screen->FastCombo(2, 112, 78 - i, servusMovingUpStartingCombo + 2, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 78 - i, servusMovingUpStartingCombo + 3, 3, OP_OPAQUE);
         
         Waitframe();
      }
      
      // Buffer before Big Summer Blowout
      for (int i = 0; i < 30; ++i) {
         disableLink();
         
         Screen->FastCombo(2, 112, 16, servusFullStartingCombo, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 16, servusFullStartingCombo + 1, 3, OP_OPAQUE);
         Screen->FastCombo(2, 112, 30, servusFullStartingCombo + 2, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 30, servusFullStartingCombo + 3, 3, OP_OPAQUE);
         
         Waitframe();
      }
      
      for (int i = 0; i < 60; ++i) {
         disableLink();
         
         Screen->FastCombo(2, 112, 14, servusAttackingStartingCombo, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 14, servusAttackingStartingCombo + 1, 3, OP_OPAQUE);
         Screen->FastCombo(2, 112, 30, servusAttackingStartingCombo + 2, 3, OP_OPAQUE);
         Screen->FastCombo(2, 128, 30, servusAttackingStartingCombo + 3, 3, OP_OPAQUE);
         
         Waitframe();
      }
      
      // Big Summer Blowout
      Audio->PlaySound(SFX_ONOX_TORNADO);
      this->X = 112;
      this->Y = 16;
      windBlast(this, originalTile, attackingTile, 2);
      
      // Servus vanishes
      for (int i = 0; i < 20; ++i) {
         disableLink();
         
         if (i < 10) {
            Screen->FastCombo(2, 112, 14, servusVanishingStartingCombo, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 14, servusVanishingStartingCombo + 1, 3, OP_OPAQUE);
            Screen->FastCombo(2, 112, 30, servusVanishingStartingCombo + 2, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 30, servusVanishingStartingCombo + 3, 3, OP_OPAQUE);
         } else {
            Screen->FastCombo(2, 112, 14, servusTransStartingCombo, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 14, servusTransStartingCombo + 1, 3, OP_OPAQUE);
            Screen->FastCombo(2, 112, 30, servusTransStartingCombo + 2, 3, OP_OPAQUE);
            Screen->FastCombo(2, 128, 30, servusTransStartingCombo + 3, 3, OP_OPAQUE);
         }
         
         Waitframe();
      }         
   }
}

@Author("Moosh")
npc script TurnedHylianElite {
   using namespace NPCAnim;
   using namespace NPCAnim::Legacy;

   enum Animations {
      WALKING,
      ATTACK
   };

   void run(int introMessage) {
      AnimHandler aptr = new AnimHandler(this);
      
      AddAnim(aptr, WALKING, 0, 4, 8, ADF_4WAY);
      AddAnim(aptr, ATTACK, 20, 2, 16, ADF_4WAY | ADF_NOLOOP);
      
      int maxHp = this->HP;
      Audio->PlayEnhancedMusic("OoT - Middle Boss.ogg", 0);
      
      unless (getScreenD(0)) {
         Screen->Message(introMessage);
         setScreenD(0, true);
      }
      
      while(true) {
         int movementDirection = Choose(90, -90);
         int attackCoolDown = 120;
         
         PlayAnim(this, WALKING);
         
         int tooCloseBoiCounter = 0;
         
         while (attackCoolDown) {
            this->Immortal = true;
            int moveAngle = Angle(this->X + 8, this->Y + 8, Hero->X + 8, Hero->Y + 8);
            int distance = Distance(this->X, this->Y, Hero->X, Hero->Y);
            
            if (distance < 48)
               tooCloseBoiCounter++;
            else
               tooCloseBoiCounter = 0;
               
            if (tooCloseBoiCounter == 60) {
               Audio->PlaySound(SFX_IRON_KNUCKLE_ATTACK);
               Audio->PlaySound(SFX_IRON_KNUCKLE_ATTACK_SWIPE);

               for (int i = 0; i < 15; ++i) {
                  FaceLink(this);
                  sword1x1(this->X, this->Y, moveAngle - 90 + 15 * i, 16, 10252, 10, this->WeaponDamage + this->WeaponDamage * .33);
                  CustomWaitframe(this);
               }
               
               tooCloseBoiCounter = 0;
            }
            
            int angle = Angle(this->X + 8, this->Y + 8, Hero->X + 8, Hero->Y + 8) + movementDirection;
            this->MoveAtAngle(angle, this->Step / (gettingDesperate(this, maxHp) ? 75 : 100), SPW_NONE);
            --attackCoolDown;
            
            FaceLink(this);
            CustomWaitframe(this);
         }
         
         int moveAngle = Angle(this->X + 8, this->Y + 8, Hero->X + 8, Hero->Y + 8);
         int distance = Distance(this->X + 8, this->Y + 8, Hero->X + 8, Hero->Y + 8);
         int dashFrames = Max(2, (distance - 36) / 3);
         
         bool swordCollided;
         PlayAnim(this, ATTACK);
         
         Audio->PlaySound(SFX_IRON_KNUCKLE_ATTACK);
         
         for (int i = 0; i < dashFrames; ++i) {
            this->MoveAtAngle(moveAngle, this->Step / (gettingDesperate(this, maxHp) ? 20 : 25), SPW_NONE);
            FaceLink(this);
            
            if (i > dashFrames / 2)
               sword1x1(this->X, this->Y, moveAngle - 90, (i - dashFrames / 2) / (dashFrames / 2) * 16, 10252, 10, this->WeaponDamage* .4);
               
            CustomWaitframe(this);
         }
         
         Audio->PlaySound(SFX_IRON_KNUCKLE_ATTACK_SWIPE);
         distance = Distance(this->X + 8, this->Y + 8, Hero->X + 8, Hero->Y + 8);
         
         for (int i = 0; i <= 12 && !swordCollided; ++i) {
            this->MoveAtAngle(moveAngle, this->Step / (gettingDesperate(this, maxHp) ? 25 : 30), SPW_NONE);
            FaceLink(this);
            swordCollided = sword1x1Collision(this->X, this->Y, moveAngle - 90 + 15 * i, 16, 10252, 10, this->WeaponDamage);
            CustomWaitframe(this);
         }
         
         if (swordCollided) {
            Audio->PlaySound(SFX_SWORD_ROCK3);
            
            for(int i = 0; i < 12; ++i) {
               FaceLink(this);
               this->MoveAtAngle(moveAngle + 180, this->Step / 30, SPW_NONE);
               CustomWaitframe(this);
            }
            
            CustomWaitframe(this, 40);
         }
         
         attackCoolDown = 90;
            CustomWaitframe(this);
      }	
   }

   bool gettingDesperate(npc this, int maxHp) {
      return this->HP < maxHp * .4;
   }

   void CustomWaitframe(npc n) {
      if (n->HP <= 0) {
         PlayDeathAnim(n);
         n->Immortal = false;
      }

      Waitframe(n);
   }

   void CustomWaitframe(npc n, int frames) {
      for (int i = 0; i < frames; ++i)
         CustomWaitframe(n);
   }
}

@Author("Moosh, Deathrider365")
npc script Egentem {
   using namespace GhostBasedMovement;
   using namespace EnemyNamespace;
   using namespace NPCAnim;
   using namespace EgentemNamespace;
   
   void run() {
      AnimHandler aptr = new AnimHandler(this);
      
      aptr->AddAnim(WALKING, 20, 4, ANIM_SPEED, ADF_4WAY);
      aptr->AddAnim(STANDING, 44, 1, ANIM_SPEED, ADF_4WAY);
      aptr->AddAnim(WALKING_SH, 0, 4, ANIM_SPEED, ADF_4WAY);
      aptr->AddAnim(STANDING_SH, 40, 1, ANIM_SPEED, ADF_4WAY);

      Egentem egentem = new Egentem(this);
      
      this->X = -32;
      this->Y = -32;
      int maxHp = this->HP;
      this->CollDetection = false;
      
      // Not yet activated Egentem yet
      until (getScreenD(31, 0x43, 0)) {
         this->X = -32;
         this->Y = -32;
         Waitframe();
      }
      
      // You already triggered his trap and failed to defeat him once
      if (getScreenD(31, 0x23, 0) && getScreenD(31, 0x43, 0)) {
         Audio->PlayEnhancedMusic("Dragon Quest IV - Boss Battle.ogg", 0);
         this->X = 120;
         this->Y = 128;
         this->Dir = DIR_UP;
         aptr->PlayAnim(STANDING_SH);
      }
      
      // You activated his triforce trap, do intro
      else if (!getScreenD(0)) {
         introCutscene(this);
         setScreenD(0, true);
      }
      
      closeShutters(this);
      this->CollDetection = true;
      
      for (int i = 0; i < 20; ++i)
         this->Defense[i] = NPCDT_QUARTERDAMAGE;
      
      this->Defense[NPCD_BRANG] = NPCDT_BLOCK;
      this->Defense[NPCD_WHISTLE] = NPCDT_IGNORE;

      int heroDistances[10];
      int heroActiveAItems[10];
      int heroActiveBItems[10];
      
      attackThrowHammers(this, egentem, 10, 15);
      
      while(true) {
         int trackerCount;
         aptr->PlayAnim(egentem->shieldHp <= 0 ? WALKING : WALKING_SH);
         
         for (int i = 0; i < 180; ++i) {
            egentem->MoveMe();
         
            unless (i % 18) {
               heroDistances[trackerCount] = Distance(Hero->X, Hero->Y, this->X, this->Y);
               heroActiveAItems[trackerCount] = Hero->ItemA;
               heroActiveBItems[trackerCount] = Hero->ItemB;
               trackerCount++;
            }
         
            EgentemWaitframe(this, egentem);
         }
         
         EgentemWaitframe(this, egentem, 60);
         
         trackerCount = 0;
         int avgDistances;
         int totalDistances;
         int meleeCount;
         int aggressiveCount;
         int candleCount;
         
         for (int i = 0; i < 10; ++i)
            totalDistances += heroDistances[i];
         
         avgDistances = totalDistances / 10;
         
         for (int i = 0; i < 10; ++i) {
            if (heroActiveAItems[i] == 10 || heroActiveBItems[i] == 10)
               candleCount++;
               
            if (heroActiveAItems[i] == 3 || heroActiveAItems[i] == 5 || heroActiveAItems[i] == 10 || heroActiveAItems[i] == 147)
               meleeCount++;
            else if (heroActiveBItems[i] == 3 || heroActiveBItems[i] == 5 || heroActiveBItems[i] == 10 || heroActiveBItems[i] == 147)
               meleeCount++;
         }
         
         for (int i = 0; i < 10; ++i) {
            if (heroActiveAItems[i] == 3 || heroActiveAItems[i] == 5 || heroActiveAItems[i] == 10 || heroActiveAItems[i] == 147)
               aggressiveCount++;
            else if (heroActiveBItems[i] == 3 || heroActiveBItems[i] == 5 || heroActiveBItems[i] == 10 || heroActiveBItems[i] == 147)
               aggressiveCount++;
         }
         
         if (candleCount == 10) {
            aptr->PlayAnim(egentem->shieldHp <= 0 ? STANDING : STANDING_SH);
            attackHammerEruption(this, egentem);
            attackThrowHammers(this, egentem, 5, 1);
         }
         
         if (numPillars() > 15) {
            aptr->PlayAnim(egentem->shieldHp ? WALKING : WALKING_SH);
            
            for (int i = 0; i < (numPillars() * .9); ++i)
               attackJumpToPillar(this, egentem);
         }
         
         if (egentem->shieldHp > 0) {
            if (avgDistances > 48) {
               attackHammerSpin(this, egentem);
               attackThrowHammers(this, egentem, 5, 10);
               
               for (int i = 0; i < numPillars() / 2; ++i)
                  attackJumpToPillar(this, egentem);
            }
            else if (meleeCount > 7) {
               attackHammerSpin(this, egentem);
               attackHammerEruption(this, egentem);
            }
            else {
               attackThrowHammers(this, egentem, 15, 10);
               
               for (int i = 0; i < numPillars() / 2; ++i)
                  attackJumpToPillar(this, egentem);
            }
         }
         else {
            if (avgDistances > 48) {
               attackHammerSpin(this, egentem);
               attackThrowHammers(this, egentem, 5, 10);
               
               for (int i = 0; i < numPillars() / 2; ++i)
                  attackJumpToPillar(this, egentem);
            }
            else if (meleeCount > 7) {
               attackHammerEruption(this, egentem);
               attackHammerSpin(this, egentem);
               attackHammerEruption(this, egentem);
               attackThrowHammers(this, egentem, 5, 10);
            }
            else {
               attackThrowHammers(this, egentem, 15, 10);
               
               for (int i = 0; i < numPillars() / 2; ++i)
                  attackJumpToPillar(this, egentem);
            }
         }
         
         EgentemWaitframe(this, egentem, 1);
      }
   } 
}

@Author("EmilyV99, Deathrider365")
npc script Latros {
   using namespace EnemyNamespace;
   using namespace LatrosNamespace;
   using namespace NPCAnim;
   
   void run() {
      disableLink();
      AnimHandler aptr = new AnimHandler(this);
      Latros latros = new Latros(this);
      CONFIG WALKING = 0;
      CONFIG ANIM_SPEED = 4;
      CONFIG UNCHANGED_HP_COUNTER_VALUE = 300;
      
      FaceLink(this);
      
      until (this->Z == 0) {
         disableLink();
         FaceLink(this);
         Waitframe(this);
      }
      
      Screen->Quake = 20;
      Audio->PlaySound(SFX_IMPACT_EXPLOSION);
      FaceLink(this);
      
      for (int i = 0; i < 30; ++i) {
         disableLink();
         LatrosWaitframe(this, latros);
      }
      
      unless (getScreenD(255)) {
         Screen->Message(809);
         setScreenD(255, true);
      }
      
      aptr->AddAnim(WALKING, 0, 4, ANIM_SPEED, ADF_4WAY);
      int heroHp = Hero->HP;
      int latrosHealth = this->HP;
      int hpUnchangedCounter = UNCHANGED_HP_COUNTER_VALUE;
      int attackCooldown = 120;
      int attackAttemptCounter = 10;
      
      while(true) {
         doWalk(this, this->Random, this->Homing, this->Step);
         
         unless (hpUnchangedCounter) {
            if (latros->numItems)
               latros->dropItem();
            
            latrosHealth = this->HP;
            hpUnchangedCounter = UNCHANGED_HP_COUNTER_VALUE;
         }
         
         unless (attackCooldown) {
            int validItem = 0;

            if (latros->numItems > 4) {
               int possessingItems[5];
               int possessingItemsIndex;
               
               for (int i = 0; i < SizeOfArray(latros->stolenItems); ++i)
                  if (latros->stolenItems[i])
                     possessingItems[possessingItemsIndex++] = latros->stolenItems[i];
                     
               
               while (!validItem && attackAttemptCounter) {
                  validItem = possessingItems[Rand(0, latros->numItems - 1)];
                  --attackAttemptCounter;
               }
               
               attackAttemptCounter = 10;
               attackWithItem(this, latros, validItem);
            }
            else {
               charge(this, latros);
               
               if (Screen->NumItems())
                  seekItem(this, latros);
                  
               int possessingItems[5];
               int possessingItemsIndex;
               
               for (int i = 0; i < SizeOfArray(latros->stolenItems); ++i)
                  if (latros->stolenItems[i]) 
                     possessingItems[possessingItemsIndex++] = latros->stolenItems[i];
               
               while (!validItem && attackAttemptCounter) {
                  validItem = possessingItems[Rand(0, latros->numItems - 1)];
                  --attackAttemptCounter;
               }
               
               attackAttemptCounter = 10;
               attackWithItem(this, latros, validItem);
            }
            
            attackCooldown = 120;
            LatrosWaitframe(this, latros, 30);
         }
         
         if (this->HP == latrosHealth)
            --hpUnchangedCounter;
         else {
            latrosHealth = this->HP;
            hpUnchangedCounter = UNCHANGED_HP_COUNTER_VALUE;
         }
            
         --attackCooldown;
         LatrosWaitframe(this, latros);
      }
   }
}


@Author("Deathrider365")
npc script Demonwall {
   void run() {
      // for (int i = 0; i < roomsize since the wall can squish link for instakill; ++i)
      // {
         // move the guy perhaps 1/8th of a tile every frame 
         // if (demonwall->HP at 70%)
            // move demonwall back 3 tiles if it can, otherwise just back the the left wall
            
         // do some attacks
         
      // }
   }
}
