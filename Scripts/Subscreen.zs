//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Subscreen ~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

namespace Subscreen {
   Color C_MINIMAP_EXPLORED = C_WHITE;
   Color C_MINIMAP_ROOM = C_BLACK;
   Color C_MINIMAP_LINK = C_DEEPBLUE;
   Color C_MINIMAP_COMPASS = C_RED;
   Color C_MINIMAP_COMPASS_DEFEATED = C_DARKGREEN;

   int currTriforceIndex = 0;
   bitmap minitileBuf;

   void minitile(untyped bit, int layer, int x, int y, int tile, int cset, int corner) {
      // bitmap sub = new bitmap(16, 16);
      // sub->Clear(0);
      // tile(sub, 0, 0, 0, tile, cset);
      // sub->Blit(layer, bit, (corner & 01b) ? 8 : 0, (corner & 10b) ? 8 : 0, 8, 8, x, y, 8, 8, 0, 0, 0, 0, 0, true);
      if (minitileBuf == NULL)
         minitileBuf = new bitmap(16, 16);

      minitileBuf->Clear(layer);
      tile(minitileBuf, layer, 0, 0, tile, cset);
      minitileBuf->Blit(layer, bit, (corner & 01b) ? 8 : 0, (corner & 10b) ? 8 : 0, 8, 8, x, y, 8, 8, 0, 0, 0, 0, 0, true);
   }

   void tile(untyped bit, int layer, int x, int y, int tile, int cset) {
      <bitmap>(bit)->FastTile(layer, x, y, tile, cset, OP_OPAQUE);
   }
} // namespace Subscreen

namespace SubscreenWidgets {
   // clang-format off
   @Author("Deathrider365")
   subscreendata script CyclableTriforceFrames {
      // clang-format on
      using namespace Subscreen;

      CONFIG TILE_COURAGE_FRAME = 320;
      CONFIG TILE_POWER_FRAME = 326;
      CONFIG TILE_WISDOM_FRAME = 380;
      CONFIG TILE_DEATH_FRAME = 386;
      CONFIG COURAGE_SHARD1 = 274;
      CONFIG COURAGE_SHARD2 = 334;
      CONFIG COURAGE_SHARD3 = 394;
      CONFIG COURAGE_SHARD4 = 454;
      CONFIG WISDOM_SHARD1 = 702;
      CONFIG WISDOM_SHARD2 = 522;
      CONFIG WISDOM_SHARD3 = 582;
      CONFIG WISDOM_SHARD4 = 642;
      CONFIG POWER_SHARD1 = 648;
      CONFIG POWER_SHARD2 = 708;
      CONFIG POWER_SHARD3 = 588;
      CONFIG POWER_SHARD4 = 528;
      CONFIG DEATH_SHARD1 = 654;
      CONFIG DEATH_SHARD2 = 534;
      CONFIG DEATH_SHARD3 = 714;
      CONFIG DEATH_SHARD4 = 594;

      CONFIG TRIFORCE_CYCLE_SFX = 124;

      void run() {
         int leftArrowCombo = 7746;
         int rightArrowCombo = 7747;
         int LCombo = 7744;
         int RCombo = 7745;
         int drawY = 84;

         int triforceFrames[] = {TILE_COURAGE_FRAME, TILE_POWER_FRAME, TILE_WISDOM_FRAME, TILE_DEATH_FRAME};
         int courageShards[] = {COURAGE_SHARD1, COURAGE_SHARD2, COURAGE_SHARD3, COURAGE_SHARD4};
         int powerShards[] = {POWER_SHARD1, POWER_SHARD2, POWER_SHARD3, POWER_SHARD4};
         int wisdomShards[] = {WISDOM_SHARD1, WISDOM_SHARD2, WISDOM_SHARD3, WISDOM_SHARD4};
         int deathShards[] = {DEATH_SHARD1, DEATH_SHARD2, DEATH_SHARD3, DEATH_SHARD4};

         loop() {
            Screen->DrawOrigin = DRAW_ORIGIN_PLAYING_FIELD;
            magicBar(Game->ActiveSubscreenY + 232);

            int yOff = Game->ActiveSubscreenY;

            if (Input->Press[CB_L]) {
               Audio->PlaySound(TRIFORCE_CYCLE_SFX);
               --currTriforceIndex;
            }
            else if (Input->Press[CB_R]) {
               Audio->PlaySound(TRIFORCE_CYCLE_SFX);
               ++currTriforceIndex;
            }
            if (Game->CurDMap != 2) {
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

            Screen->DrawTile(0, 10, drawY + yOff - 8, triforceFrames[currTriforceIndex], 6, 3, currTriforceIndex == 3 ? 13 : 0, -1, -1, 0, 0, 0, 0, 1, 128);

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
                     Screen->DrawTile(0, 10, drawY + yOff - 8, deathShards[i], 6, 3, 13, -1, -1, 0, 0, 0, 0, 1, 128);
                  break;
            }

            Waitframe();
         }
      }
   }

   dmapdata script ScriptedSubscreenComponents {
      void run() {
         loop() {
            Screen->DrawOrigin = DRAW_ORIGIN_PLAYING_FIELD;
            magicBar(0);
            Waitframe();
         }
      }
   }

   void magicBar(int yOff) {
      using namespace Subscreen;

      CONFIG TILE_MAGIC_METER = 32527; //32527
      Color C_MAGIC_METER_FILL = C_GREEN;

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
}
