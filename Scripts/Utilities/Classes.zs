//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Classes ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

class Coordinates {
   int X, Y;

   Coordinates() {
      this->X = 0;
      this->Y = 0;
   }

   Coordinates(int x, int y) {
      this->X = x;
      this->Y = y;
   }
}

class ShockwaveType {
   int spr;
   int sfx;
   int delay;
   int detonateSfx;
   int detonateSpr;

   ShockwaveType(int spr, int sfx, int delay, int detonateSfx, int detonateSpr) {
      this->spr = spr;
      this->sfx = spr;
      this->delay = delay;
      this->detonateSfx = detonateSfx;
      this->detonateSpr = detonateSpr;
   }
}
