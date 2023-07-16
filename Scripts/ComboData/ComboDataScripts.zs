//~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Combo Data Scripts~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

// clang-format off
@Attribyte0("X Sensitivity"),
@AttribyteHelp0("Horizontal sensitivity in pixels (16 is full sensitivity)"),
@Attribyte1("Y Sensitivity"),
@AttribyteHelp1("Vertical sensitivity in pixels (16 is full sensitivity)")
combodata script SemiSensitiveSwitch {
   // clang-format on
   CONFIGB DEBUG = false;

   void run() {
      int xSens = this->Attribytes[0];
      int ySens = this->Attribytes[1];
      int xOff = (16 - xSens) / 2;
      int yOff = (16 - ySens) / 2;

      while (true) {
         if (RectCollision(Hero->X, Hero->Y + 8, Hero->X + 15, Hero->Y + 15, this->X + xOff, this->Y + yOff, this->X + xOff + xSens - 1, this->Y + yOff + ySens - 1)) {
            Screen->TriggerSecrets();
            Quit();
         }

         if (DEBUG)
            Screen->Rectangle(6, this->X + xOff, this->Y + yOff, this->X + xOff + xSens - 1, this->Y + yOff + ySens - 1, C_WHITE, 1, 0, 0, 0, true, OP_TRANS);

         Waitframe();
      }
   }
}

// clang-format off
@Attribyte0("Direction"),
@AttribyteHelp0("0 = Up,\n 1 = Down,\n 2 = Left,\n 3 = Right")
combodata script ICanSeeYou {
   // clang-format on
   CONFIGB DEBUG = false;

   void run() {
      int dir = this->Attribytes[0];

      while (true) {
         int sightDist = getSightDist(this, dir);

         if (canSeeLink(this, dir, sightDist)) {
            Audio->PlaySound(SFX_SIGHTED);
            Screen->TriggerSecrets();

            for (int i = 0; i < 16; ++i) {
               Screen->FastCombo(this->Layer, this->X, this->Y, this->ID + 4, 1, OP_OPAQUE);
               Waitframe();
            }

            while (canSeeLink(this, dir, sightDist)) {
               sightDist = getSightDist(this, dir);
               Screen->FastCombo(this->Layer, this->X, this->Y, this->ID + 4, 1, OP_OPAQUE);

               Waitframe();
            }
         }

         Waitframe();
      }
   }

   bool isSolid(int x, int y) {
      if (Screen->MovingBlockX > -1) {
         if (x >= Screen->MovingBlockX && x <= Screen->MovingBlockX + 15 && y >= Screen->MovingBlockY && y <= Screen->MovingBlockY + 15) {
            return true;
         }
      }
      return Screen->isSolid(x, y);
   }

   int getSightDist(combodata this, int dir) {
      int x = this->X + 8;
      int y = this->Y + 8;
      int i = 0;

      for (i = 0; i < 256; i += 8) {
         x += DirX(dir) * 8;
         y += DirY(dir) * 8;
         int pos = ComboAt(x, y);

         unless(pos == this->Pos) {
            if (Screen->isSolid(x, y))
               break;
         }
      }

      return i;
   }

   bool canSeeLink(combodata this, int dir, int sightDist) {
      int x = this->X;
      int y = this->Y;
      int width, height;

      switch (dir) {
         case DIR_UP:
            x += 4;
            y -= sightDist;
            width = 8;
            height = sightDist;
            break;
         case DIR_DOWN:
            x += 4;
            y += 16;
            width = 8;
            height = sightDist;
            break;
         case DIR_LEFT:
            x -= sightDist;
            y += 4;
            width = sightDist;
            height = 8;
            break;
         case DIR_RIGHT:
            x += 16;
            y += 4;
            width = sightDist;
            height = 8;
            break;
      }

      if (DEBUG)
         Screen->Rectangle(6, x, y, x + width - 1, y + height - 1, C_WHITE, 1, 0, 0, 0, true, OP_TRANS);

      return RectCollision(Hero->X, Hero->Y + 8, Hero->X + 15, Hero->Y + 15, x, y, x + width - 1, y + height - 1);
   }
}