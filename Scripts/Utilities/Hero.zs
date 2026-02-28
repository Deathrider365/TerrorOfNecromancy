//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Hero ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

// clang-format off
@Author("EmilyV99")
hero script HeroInit {
   // clang-format on

   void run() {}
}

// clang-format off
@Author("EmilyV99")
hero script HeroActive {
   // clang-format on

   void run() {
   }
}

// clang-format off
@Author("Deathrider365")
hero script OnDeath {
   // clang-format on

   void run() {
      onContHP = Hero->MaxHP;
      onContMP = Hero->MaxMP;
   }
}

//clang-format off
@Author("Deathrider365")
hero script OnWin {
   // clang-format on

   void run() {
      onContHP = Hero->MaxHP;
      onContMP = Hero->MaxMP;
   }
}
