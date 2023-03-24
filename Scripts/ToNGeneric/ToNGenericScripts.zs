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


