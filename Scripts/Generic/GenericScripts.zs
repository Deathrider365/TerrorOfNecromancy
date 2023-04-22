///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~~~~~The Terror of Necromancy Generic~~~~~~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

generic script HeroHurtSound {
   void run() {
      while(true) {
         WaitEvent();
         
         unless (Game->EventData[GENEV_HEROHIT_NULLIFY])
            Audio->PlaySound(Choose(SFX_HERO_HURT_1, SFX_HERO_HURT_2, SFX_HERO_HURT_3));
      }
   }
}

generic script HeroGotYeeted {
   void run() {
      this->DataSize = YEET_SIZE;
      this->Data[YEET_DURATION] = 0;
      
      while(true) {
         if (this->Data[YEET_DURATION]) {
            --this->Data[YEET_DURATION];
            
            if (this->Data[YEET_NOACTION])
               disableLink();
            
            if (CanWalk8(Hero->X, Hero->Y, AngleDir8(WrapDegrees(this->Data[YEET_ANGLE])), 1, false)) {
               int vx = VectorX(this->Data[YEET_STEP], this->Data[YEET_ANGLE]);
               int vy = VectorY(this->Data[YEET_STEP], this->Data[YEET_ANGLE]);
               LinkMovement_Push2(vx, vy);
            }
            else {
               this->Data[YEET_DURATION] = 0;
            }
         }
         
         if (this->Data[YEET_NEW_YEET]) {
            //TODO add effect here 
         }
         
         this->Data[YEET_NEW_YEET] = false;
         
         Waitframe();
      }
   }
}

enum HERO_YEET_DATA {
   YEET_ANGLE,
   YEET_STEP,
   YEET_DURATION,
   YEET_NOACTION,
   YEET_NEW_YEET,
   YEET_STOP_AT_SOLID,
   YEET_SIZE //Setting the size of the data array by position (5th slot)
};

void yeetHero(int angle, int step, int duration, bool noAction, bool stopAtSolid) {
   genericdata gd = Game->LoadGenericData(Game->GetGenericScript("HeroGotYeeted"));
   gd->Data[YEET_ANGLE] = angle;
   gd->Data[YEET_STEP] = step;
   gd->Data[YEET_DURATION] = duration;
   gd->Data[YEET_NOACTION] = noAction;
   gd->Data[YEET_NEW_YEET] = true;
   gd->Data[YEET_STOP_AT_SOLID] = stopAtSolid;
   
   Trace(duration);
   Trace(gd->Data[YEET_DURATION]);
}