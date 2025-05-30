//~~~~~~~~~~~~~~~~~~~~~The Terror of Necromancy Generic~~~~~~~~~~~~~~~~~~~//

// generic script HeroHurtSound {
   // void run() {
   //    while (true) {
   //       WaitEvent();

   //       unless(Game->EventData[GENEV_HEROHIT_NULLIFY]) Audio->PlaySound(Choose(SFX_HERO_HURT_1, SFX_HERO_HURT_2, SFX_HERO_HURT_3));
   //    }
   // }
// }

generic script HeroGotYeeted {
   void run() {
      this->DataSize = YEET_SIZE;
      this->Data[YEET_DURATION] = 0;

      while (true) {
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
            // TODO add effect here
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
   YEET_SIZE // Setting the size of the data array by position (5th slot)
};

void yeetHero(int angle, int step, int duration, bool noAction, bool stopAtSolid) {
   genericdata gd = Game->LoadGenericData(Game->GetGenericScript("HeroGotYeeted"));
   gd->Data[YEET_ANGLE] = angle;
   gd->Data[YEET_STEP] = step;
   gd->Data[YEET_DURATION] = duration;
   gd->Data[YEET_NOACTION] = noAction;
   gd->Data[YEET_NEW_YEET] = true;
   gd->Data[YEET_STOP_AT_SOLID] = stopAtSolid;
}

// clang-format off
// @Author("EmilyV")
// generic script screenPalette {
//    // clang-format on
//    void run() {
//       this->EventListen[GENSCR_EVENT_CHANGE_SCREEN] = true;
//       int palette = -1;
//       while (true) {
//          if (Screen->Palette != palette) {
//             palette = Screen->Palette;
//             for (int q = 0; q < MAX_DMAPS; ++q)
//                Game->LoadDMapData(q)->Palette = palette;
//          }
//          WaitEvent();
//       }
//    }
// }

// clang-format off
@Author("Moosh")
generic script MinecartGeneric {
   // clang-format on

   using namespace MinecartNamespace;

   void run() {
      if (!GBMinecarts[MCI_FIRSTLOAD]) {
         GBMinecarts[MCI_FIRSTLOAD] = true;
         GBMinecarts[MCI_NOAIRSCROLL_QR] = Game->FFRules[qr_NO_SCROLL_WHILE_IN_AIR];
      }

      int cartScript = Game->GetFFCScript("GBMinecart");
      int trackScript = Game->GetComboScript("GBMinecart_Track");

      GBMinecarts[MCI_INMINECART] = false;

      WaitTo(SCR_TIMING_POST_FFCS);

      Game->FFRules[qr_SCROLLWARP_NO_RESET_FRAME] = true;
      Game->FFRules[qr_NO_SCROLL_WHILE_IN_AIR] = GBMinecarts[MCI_NOAIRSCROLL_QR];

      this->ReloadState[GENSCR_ST_RELOAD] = true;
      this->ReloadState[GENSCR_ST_CONTINUE] = true;

      int lastScreen = -1;
      int lastDMap = -1;

      bool waitRepositionCarts;
      while (true) {
         WaitTo(SCR_TIMING_POST_FFCS);
         if (lastDMap != Game->CurDMap || lastScreen != Game->CurScreen) {
            lastScreen = Game->CurScreen;
            lastDMap = Game->CurDMap;

            // ListMinecartPositions();

            // Tell the script to wait on scrolling to update carts for the new screen
            if (GBMinecarts[MCI_INMINECART]) {
               waitRepositionCarts = true;
            }
            SpawnCarts(cartScript);
         }

         int id = GBMinecarts[MCI_CURRENTID];

         if (waitRepositionCarts && Game->Scrolling[SCROLL_DIR] == -1) {
            if (GBMinecarts[MCI_INMINECART]) {
               GBMinecarts[MCI_CARTX] = Link->X;
               GBMinecarts[MCI_CARTY] = Link->Y;
            }
            waitRepositionCarts = false;
         }

         if (GBMinecarts[MCI_INMINECART]) {
            Game->FFRules[qr_NO_SCROLL_WHILE_IN_AIR] = false;
            ++GBMinecarts[MCI_SFXTIMER];
            if (GBMinecarts[MCI_SFXTIMER] >= MINECART_SFX_FREQ) {
               GBMinecarts[MCI_SFXTIMER] = 0;
               Audio->PlaySound(SFX_MINECART);
            }

            PreventScrolling();

            if (Game->Scrolling[SCROLL_DIR] > -1) {
               WaitTo(SCR_TIMING_POST_PLAYER_ANIMATE); // After Link moves

               SetSpecialLinkSprite();
               int cmb = GBMinecarts[MCI_CARTCOMBO];
               int cs = GBMinecarts[MCI_CARTCSET];
               int dir = GBMinecarts[MCI_CARTDIR];
               Screen->FastCombo(SPLAYER_NPC_DRAW, Link->X, Link->Y, cmb + dir + 4, cs, OP_OPAQUE);
               Screen->FastCombo(SPLAYER_PLAYER_DRAW, Link->X, Link->Y, cmb + dir + 8, cs, OP_OPAQUE);
            }
            else {
               WaitTo(SCR_TIMING_POST_EWPN_SCRIPT); // Before Link moves

               if (!CanUseItemInMinecart(Link->ItemA)) {
                  Link->InputA = false;
                  Link->PressA = false;
               }
               if (!CanUseItemInMinecart(Link->ItemB)) {
                  Link->InputB = false;
                  Link->PressB = false;
               }
               if (!CanUseItemInMinecart(Link->ItemX)) {
                  Link->InputEx1 = false;
                  Link->PressEx1 = false;
               }
               if (!CanUseItemInMinecart(Link->ItemY)) {
                  Link->InputEx2 = false;
                  Link->PressEx2 = false;
               }

               // Move until hitting a platform to get off
               if (MoveCart(cartScript, trackScript)) {
                  SetMinecartVar(id, MCII_MAP, Game->CurMap);
                  SetMinecartVar(id, MCII_SCREEN, Game->CurScreen);
                  SetMinecartVar(id, MCII_X, GBMinecarts[MCI_CARTX]);
                  SetMinecartVar(id, MCII_Y, GBMinecarts[MCI_CARTY]);
                  SetMinecartVar(id, MCII_DIR, OppositeDir(GBMinecarts[MCI_CARTDIR]));
                  SpawnCart(cartScript, GBMinecarts[MCI_CURRENTID], GBMinecarts[MCI_CARTX], GBMinecarts[MCI_CARTY], 1);
                  GBMinecarts[MCI_INMINECART] = false;
                  continue;
               }

               Link->X = GBMinecarts[MCI_CARTX];
               Link->Y = GBMinecarts[MCI_CARTY];
               Link->FakeZ = MINECART_LINKYOFFSET;
               Link->FakeJump = 0;

               WaitTo(SCR_TIMING_POST_PLAYER_ANIMATE); // After Link moves

               Link->X = GBMinecarts[MCI_CARTX];
               Link->Y = GBMinecarts[MCI_CARTY];
               Link->FakeZ = MINECART_LINKYOFFSET;
               Link->FakeJump = 0;

               SetSpecialLinkSprite();
               int cmb = GBMinecarts[MCI_CARTCOMBO];
               int cs = GBMinecarts[MCI_CARTCSET];
               int dir = GBMinecarts[MCI_CARTDIR];
               Screen->FastCombo(SPLAYER_NPC_DRAW, Link->X, Link->Y, cmb + dir + 4, cs, OP_OPAQUE);
               Screen->FastCombo(SPLAYER_PLAYER_DRAW, Link->X, Link->Y, cmb + dir + 8, cs, OP_OPAQUE);
            }
         }

         Waitframe();
      }
   }
   // List off all minecart locations in the console
   void ListMinecartPositions() {
      printf("\nMINECARTS AS OF SCREEN %d\n\n", Game->CurScreen);
      for (int i = 0; i < GBMinecarts[MCI_ACTIVEMINECARTS]; ++i) {
         printf("MINECART %d\n", i);
         int map = GetMinecartVar(i, MCII_MAP);
         int omap = GetMinecartVar(i, MCII_ORIGINALMAP);
         int scrn = GetMinecartVar(i, MCII_SCREEN);
         int oscrn = GetMinecartVar(i, MCII_ORIGINALSCREEN);
         int x = GetMinecartVar(i, MCII_X);
         int ox = GetMinecartVar(i, MCII_ORIGINALX);
         int y = GetMinecartVar(i, MCII_Y);
         int oy = GetMinecartVar(i, MCII_ORIGINALY);
         int dir = GetMinecartVar(i, MCII_DIR);
         printf("  Map %d (%d)\n  Screen %d (%d)\n  X %d (%d)\n  Y %d (%d)\n  Dir %d\n", map, omap, scrn, oscrn, x, ox, y, oy, dir);
      }
   }
   // Move the cart by one step, handling turning. Returns true if dismounting
   bool MoveCart(int cartScript, int trackScript) {
      Link->ShadowXOffset = 1000;
      TempLinkState_UnsetCollDetection(1);
      GBMinecarts[MCI_CARTTEMPSTEP] += GBMinecarts[MCI_CARTSPEED];
      while (GBMinecarts[MCI_CARTTEMPSTEP] >= 1) {
         // When grid aligned, process turns
         if (GBMinecarts[MCI_CARTX] % 16 == 0 && GBMinecarts[MCI_CARTY] % 16 == 0) {
            int dir = GBMinecarts[MCI_CARTDIR];
            int track[4];
            GetTrackData(trackScript, track, GBMinecarts[MCI_CARTX], GBMinecarts[MCI_CARTY]);
            int track_id = track[0];
            int track_canTurn = track[1];
            int track_biasDir = track[2];
            int track_flags = track[3];

            int newdir;
            // Check the track under the cart
            {
               // If you can go straight
               if (track_flags & (1 << dir)) {
                  newdir = dir;
               }
               // Else try the bias direction
               else if (track_biasDir != OppositeDir(dir) && track_biasDir > -1 && track_biasDir < 4 && track_flags & (1 << track_biasDir)) {
                  newdir = track_biasDir;
               }
               // Just try everything man
               else {
                  for (int i = 0; i < 4; ++i) {
                     if (i != OppositeDir(dir) && track_flags & (1 << i)) {
                        newdir = i;
                        break;
                     }
                  }
               }

               // If turning is allowed, let that influence things
               if (track_canTurn) {
                  if (Link->InputUp && track_flags & (1 << DIR_UP) && OppositeDir(dir) != DIR_UP)
                     newdir = DIR_UP;
                  else if (Link->InputDown && track_flags & (1 << DIR_DOWN) && OppositeDir(dir) != DIR_DOWN)
                     newdir = DIR_DOWN;
                  else if (Link->InputLeft && track_flags & (1 << DIR_LEFT) && OppositeDir(dir) != DIR_LEFT)
                     newdir = DIR_LEFT;
                  else if (Link->InputRight && track_flags & (1 << DIR_RIGHT) && OppositeDir(dir) != DIR_RIGHT)
                     newdir = DIR_RIGHT;
               }
            }

            // Next check the track in front of the cart
            int tx = GBMinecarts[MCI_CARTX] + DirX(newdir) * 16;
            int ty = GBMinecarts[MCI_CARTY] + DirY(newdir) * 16;
            GetTrackData(trackScript, track, tx, ty);
            track_id = track[0];
            track_canTurn = track[1];
            track_biasDir = track[2];
            track_flags = track[3];

            // If another cart is in the way, turn around
            if (BlockedByCart(cartScript, tx, ty)) {
               GBMinecarts[MCI_CARTDIR] = OppositeDir(dir);
            }
            // If it's a landing pad, return true
            else if (track_id == MTT_LANDINGPAD) {
               GBMinecarts[MCI_CARTDIR] = newdir;
               GBMinecarts[MCI_CARTTEMPSTEP] = 0;
               Link->ShadowXOffset = 0;
               Game->FFRules[qr_NO_SCROLL_WHILE_IN_AIR] = GBMinecarts[MCI_NOAIRSCROLL_QR];
               return true;
            }
            // If it's not a track at all, turn around
            else if (track_id == -1) {
               GBMinecarts[MCI_CARTDIR] = OppositeDir(dir);
            }
            else
               GBMinecarts[MCI_CARTDIR] = newdir;

            TurnLinkWithCart(dir, GBMinecarts[MCI_CARTDIR]);
         }

         GBMinecarts[MCI_CARTX] += DirX(GBMinecarts[MCI_CARTDIR]);
         GBMinecarts[MCI_CARTY] += DirY(GBMinecarts[MCI_CARTDIR]);

         --GBMinecarts[MCI_CARTTEMPSTEP];
      }

      if (DAMAGE_MINECART_COLLISION) {
         lweapon hitbox = CreateLWeaponAt(LW_MINECART_DAMAGE, GBMinecarts[MCI_CARTX], GBMinecarts[MCI_CARTY]);
         hitbox->Damage = DAMAGE_MINECART_COLLISION;
         hitbox->DrawXOffset = 1000;
         hitbox->Weapon = LW_MINECART_DAMAGE_DEFENSE;
         hitbox->Timeout = 2;
      }

      return false;
   }
   // Goofy function that turns Link by the difference of the cart's old and new directions
   void TurnLinkWithCart(int oldDir, int newDir) {
      if (!MINECART_TURN_LINK_WITH_CART)
         return;
      if (Link->Action != LA_NONE || Link->InputUp || Link->InputDown || Link->InputLeft || Link->InputRight)
         return;

      int sd_old, sd_new;
      switch (oldDir) {
         case DIR_UP: sd_old = 0; break;
         case DIR_RIGHT: sd_old = 1; break;
         case DIR_DOWN: sd_old = 2; break;
         case DIR_LEFT: sd_old = 3; break;
      }
      switch (newDir) {
         case DIR_UP: sd_new = 0; break;
         case DIR_RIGHT: sd_new = 1; break;
         case DIR_DOWN: sd_new = 2; break;
         case DIR_LEFT: sd_new = 3; break;
      }
      int turns = ((sd_new - sd_old) + 4) % 4;
      for (int i = 0; i < turns; ++i) {
         switch (Link->Dir) {
            case DIR_UP: Link->Dir = DIR_RIGHT; break;
            case DIR_DOWN: Link->Dir = DIR_LEFT; break;
            case DIR_LEFT: Link->Dir = DIR_UP; break;
            case DIR_RIGHT: Link->Dir = DIR_DOWN; break;
         }
      }
   }
   // Scans over all the screen's FFCs to see if there's a cart at a position
   bool BlockedByCart(int cartScript, int x, int y) {
      int pos = ComboAt(x, y);
      for (int i = 1; i <= MAX_FFC; ++i) {
         ffc f = Screen->LoadFFC(i);
         if (f->Script == cartScript && ComboAt(f->X + 8, f->Y + 8) == pos)
            return true;
      }
      return false;
   }
   // Try to prevent Link from scrolling off the screen
   void PreventScrolling() {
      if (Link->Y <= 2 && Link->InputUp)
         Link->InputUp = false;
      if (Link->Y >= 158 && Link->InputDown)
         Link->InputDown = false;
      if (Link->X <= 2 && Link->InputLeft)
         Link->InputLeft = false;
      if (Link->X >= 238 && Link->InputRight)
         Link->InputRight = false;
   }
   // Sets Link's sprite when in the minecart
   void SetSpecialLinkSprite() {
      if (MINECART_USE_SPECIAL_RIDING_SPRITES && (Link->Action == LA_NONE || Link->Action == LA_WALKING))
         TempLinkState_SetLinkTileOverride(Game->ComboTile(GBMinecarts[MCI_CARTCOMBO] + 12 + Link->Dir), 2);
   }
   // Gets information about track combos from an xy position
   void GetTrackData(int trackScript, int[] track, int x, int y) {
      int pos = ComboAt(x + 8, y + 8);
      mapdata l1 = Game->LoadTempScreen(1);
      mapdata l2 = Game->LoadTempScreen(2);
      bool found;
      // Check each layer 0-2 for a track
      combodata cd = Game->LoadComboData(Screen->ComboD[pos]);
      if (cd->Script == trackScript)
         found = true;
      if (!found) {
         cd = Game->LoadComboData(l1->ComboD[pos]);
         if (cd->Script == trackScript)
            found = true;
      }
      if (!found) {
         cd = Game->LoadComboData(l2->ComboD[pos]);
         if (cd->Script == trackScript)
            found = true;
      }
      // If found, set the return values
      if (found) {
         track[0] = cd->InitD[0];
         track[1] = cd->InitD[1];
         track[2] = cd->InitD[2];
         switch (track[0]) {
            case MTT_LANDINGPAD: track[3] = 0; break;
            case MTT_VERTICAL: track[3] = 0011b; break;
            case MTT_HORIZONTAL: track[3] = 1100b; break;
            case MTT_RIGHTDOWN: track[3] = 1010b; break;
            case MTT_LEFTDOWN: track[3] = 0110b; break;
            case MTT_RIGHTUP: track[3] = 1001b; break;
            case MTT_LEFTUP: track[3] = 0101b; break;
            case MTT_UPT: track[3] = 1101b; break;
            case MTT_DOWNT: track[3] = 1110b; break;
            case MTT_LEFTT: track[3] = 0111b; break;
            case MTT_RIGHTT: track[3] = 1011b; break;
            case MTT_4WAY: track[3] = 1111b; break;
         }
      }
      else {
         // Default to -1 for a non track combo
         track[0] = -1;
         track[1] = 0;
         track[2] = -1;
         track[3] = 1111b;
      }
   }
   // Tries to spawn a cart FFC where a stationary cart should be, optionally have Link jump out of it
   void SpawnCart(int cartScript, int id, int x, int y, int jumpOut = 0) {
      int ffcSlot = GetMinecartVar(id, MCII_ORIGINALFFC);

      ffc f;
      // If it's already on the screen
      if (GetMinecartVar(id, MCII_ORIGINALMAP) == Game->CurMap && GetMinecartVar(id, MCII_ORIGINALSCREEN) == Game->CurScreen) {
         f = Screen->LoadFFC(ffcSlot);
         if (f->Data && f->Script == cartScript && f->X == GetMinecartVar(id, MCII_ORIGINALX) && f->Y == GetMinecartVar(id, MCII_ORIGINALY)) {
            return;
         }
      }

      // Check if we're reetering the cart's home screen and don't spawn until jumping out
      if (!(GBMinecarts[MCI_INMINECART] && id == GBMinecarts[MCI_CURRENTID]) || jumpOut) {
         // Spawn a new minecart
         int slot = RunFFCScript(cartScript, {GetMinecartVar(id, MCII_SPEED), GetMinecartVar(id, MCII_NORESET), id + 1, jumpOut});
         if (slot > 0) {
            f = Screen->LoadFFC(slot);
            f->Data = GetMinecartVar(id, MCII_COMBO) + GetMinecartVar(id, MCII_DIR);
            f->CSet = GetMinecartVar(id, MCII_CSET);
            f->X = GetMinecartVar(id, MCII_X);
            f->Y = GetMinecartVar(id, MCII_Y);
            f->Flags[FFCF_PRELOAD] = true;
         }
      }
   }
   // Spawn all carts when entering a new screen
   void SpawnCarts(int cartScript) {
      for (int i = 0; i < GBMinecarts[MCI_ACTIVEMINECARTS]; ++i) {
         if (GetMinecartVar(i, MCII_MAP) == Game->CurMap && GetMinecartVar(i, MCII_SCREEN) == Game->CurScreen) {
            SpawnCart(cartScript, i, GetMinecartVar(i, MCII_X), GetMinecartVar(i, MCII_Y));
         }
      }
   }
}

// clang-format off
@Author("Deathrider365")
subscreendata script CyclableTriforceFrames {
   // clang-format on
   using namespace Subscreen;

   void run() {
      int leftArrowCombo = 7746;
      int rightArrowCombo = 7747;
      int LCombo = 7744;
      int RCombo = 7745;
      int drawY = 94;

      loop() {
         magicBar(Game->ActiveSubscreenY + 232);
         minimap(Game->ActiveSubscreenY + 232);
         dmapTitle(Game->ActiveSubscreenY + 232);

         int yOff = Game->ActiveSubscreenY;

         if (Input->Press[CB_L]) {
            Audio->PlaySound(TRIFORCE_CYCLE_SFX);
            --currTriforceIndex;
         }
         else if (Input->Press[CB_R]) {
            Audio->PlaySound(TRIFORCE_CYCLE_SFX);
            ++currTriforceIndex;
         }
         unless(Game->CurDMap <= 2) {
            if (currTriforceIndex == -1)
               currTriforceIndex = 3;
            else if (currTriforceIndex == 4)
               currTriforceIndex = 0;
         }
         else {
            if (currTriforceIndex == -1)
               currTriforceIndex = 2;
            else if (currTriforceIndex == 3)
               currTriforceIndex = 0;
         }

         Screen->FastCombo(7, 4, drawY + yOff, leftArrowCombo, 0, OP_OPAQUE);
         Screen->FastCombo(7, 96, drawY + yOff, rightArrowCombo, 0, OP_OPAQUE);

         Screen->FastCombo(7, 4, 16 + drawY + yOff, LCombo, 0, OP_OPAQUE);
         Screen->FastCombo(7, 96, 16 + drawY + yOff, RCombo, 0, OP_OPAQUE);

         // Triforce Frame Cycling / Drawing
         int stringDrawX = 58;
         int stringDrawY = drawY + yOff - 16;
         if (currTriforceIndex == 0)
            Emily::DrawStrings(4, stringDrawX, stringDrawY, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, "Triforce of Courage", OP_OPAQUE, SHD_SHADOWED, C_BLACK, 0, 120);
         if (currTriforceIndex == 1)
            Emily::DrawStrings(4, stringDrawX, stringDrawY, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, "Triforce of Power", OP_OPAQUE, SHD_SHADOWED, C_BLACK, 0, 120);
         if (currTriforceIndex == 2)
            Emily::DrawStrings(4, stringDrawX, stringDrawY, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, "Triforce of Wisdom", OP_OPAQUE, SHD_SHADOWED, C_BLACK, 0, 120);
         if (currTriforceIndex == 3 && Game->CurDMap != 2)
            Emily::DrawStrings(4, stringDrawX, stringDrawY, FONT_LA, C_WHITE, C_TRANSBG, TF_CENTERED, "Triforce of Death", OP_OPAQUE, SHD_SHADOWED, C_BLACK, 0, 120);

         Screen->DrawTile(0, 10, drawY + yOff - 8, triforceFrames[currTriforceIndex], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);

         switch (currTriforceIndex) {
            case 0:
               for (int i = 0; i < Game->Counter[CR_TRIFORCE_OF_COURAGE]; ++i)
                  Screen->DrawTile(0, 10, drawY + yOff - 8, courageShards[i], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
               break;
            case 1:
               for (int i = 0; i < Game->Counter[CR_TRIFORCE_OF_POWER]; ++i)
                  Screen->DrawTile(0, 10, drawY + yOff - 8, powerShards[i], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
               break;
            case 2:
               for (int i = 0; i < Game->Counter[CR_TRIFORCE_OF_WISDOM]; ++i)
                  Screen->DrawTile(0, 10, drawY + yOff - 8, wisdomShards[i], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
               break;
            case 3:
               for (int i = 0; i < Game->Counter[CR_TRIFORCE_OF_DEATH]; ++i)
                  Screen->DrawTile(0, 10, drawY + yOff - 8, deathShards[i], 6, 3, 0, -1, -1, 0, 0, 0, 0, 1, 128);
               break;
         }

         Waitframe();
      }
   }
}

dmapdata script MagicBar {
   using namespace Subscreen;

   void run() {
      loop() {
         Screen->DrawOrigin = DRAW_ORIGIN_PLAYING_FIELD;
         magicBar(0);
         minimap(0);
         dmapTitle(0);
         Waitframe();
      }
   }
}

void magicBar(int yOff) {
   using namespace Subscreen;

   int y = -12 + yOff;

   int numMagicExpansions = Game->Counter[CR_MAGIC_EXPANSIONS];
   int magicSegmentX = 166;

   int perc = Game->Counter[CR_MAGIC] / Game->MCounter[CR_MAGIC];
   int widthToFill = 10 + (8 * numMagicExpansions);
   int startFillX = 177;
   int startFillY = y + 3;
   int endFillX = 176 + Round(widthToFill * perc);
   int endFillY = y + 4;

   // initial segment
   Screen->DrawTile(7, magicSegmentX, y, TILE_MAGIC_METER + (Game->Generic[GEN_MAGICDRAINRATE] < 2 ? 20 : 0), 1, 1, 0, -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
   magicSegmentX += 8;

   for (int segmentNumber = 1; segmentNumber <= numMagicExpansions; segmentNumber++) {
      int segmentTileMod;
      int segmentCorner;

      // left segment
      if (segmentNumber % 2) {
         segmentTileMod = 3;
         segmentCorner = 0;
         magicSegmentX += 8;
         minitile(RT_SCREEN, 7, magicSegmentX, y, TILE_MAGIC_METER + 3, 0, 0);
      }
      else {
         segmentTileMod = 4;
         segmentCorner = 1;
         magicSegmentX += 8;
         minitile(RT_SCREEN, 7, magicSegmentX, y, TILE_MAGIC_METER + 4, 0, 1);
      }
   }

   // final segment
   minitile(RT_SCREEN, 7, magicSegmentX + 8, y, TILE_MAGIC_METER + 2, 0, 0);

   if (widthToFill * perc >= 0.5)
      Screen->Rectangle(7, startFillX, startFillY, endFillX, endFillY, C_MAGIC_METER_FILL, 1, 0, 0, 0, true, OP_OPAQUE);
}

void minimap(int yOff) {
   using namespace Subscreen;

   int drawX = 0 + 1;
   int drawY = yOff - 48 - 1;

   ScreenType ow = getScreenType(true);
   int minimapTile = ow == DM_OVERWORLD ? TILE_MINIMAP_OW_BG : TILE_MINIMAP_DNGN_BG;
   int cs = 0;
   dmapdata dmap = Game->LoadDMapData(Game->CurDMap);
   bool hasMap = Game->LItems[Game->CurLevel] & LI_MAP;

   if (hasMap && dmap->MiniMapTile[1]) {
      minimapTile = dmap->MiniMapTile[1];
      cs = dmap->MiniMapCSet[1];
   }
   else if (dmap->MiniMapTile[0] && !hasMap) {
      minimapTile = dmap->MiniMapTile[0];
      cs = dmap->MiniMapCSet[0];
   }

   Screen->DrawTile(7, drawX, drawY, minimapTile, 5, 3, cs, -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
   minimap(RT_SCREEN, 7, drawX, drawY, ow);
}

void dmapTitle(int yOff) {
   int drawX = 41;
   int drawY = -55;

   dmapdata dmap = Game->LoadDMapData(Game->CurDMap);
   char32 titlebuf[80];
   dmap->GetTitle(titlebuf);

   int index;
   int lastLetter;
   bool wasSpace = true;

   for (int q = 0; q < SizeOfArray(titlebuf); ++q) {
      if (titlebuf[q] == ' ') {
         unless(wasSpace) wasSpace = true;
         else continue;
      }
      else {
         lastLetter = q;
         wasSpace = false;
      }

      titlebuf[index++] = titlebuf[q];
   }

   for (int q = lastLetter + 1; q < SizeOfArray(titlebuf); ++q)
      titlebuf[q] = 0;

   Emily::DrawStrings(7, drawX, drawY + yOff, SUBSCR_DMAPTITLE_FONT, C_SUBSCR_COUNTER_TEXT, C_SUBSCR_COUNTER_BG, TF_CENTERED, titlebuf, OP_OPAQUE, SHD_SHADOWED, C_BLACK, 1, 64);
}
