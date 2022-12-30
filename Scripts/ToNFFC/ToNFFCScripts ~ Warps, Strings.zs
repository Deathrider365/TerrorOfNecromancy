///////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~The Terror of Necromancy FFC Scripts ~ Warps, Strings~~~~~~~~~~~~~~//
///////////////////////////////////////////////////////////////////////////////

@Author("Deathrider365")
ffc script MessageOnce {
   void run(int message, bool dungeonString, int screenD) {
      while(Game->Suspend[susptGUYS]) 
         Waitframe();
      
      if (dungeonString) {
         unless (levelEntries[Game->GetCurLevel()]) {
            levelEntries[Game->GetCurLevel()] = true;
            Waitframe();
            Screen->Message(message);		
         }
      } else {
         unless(getScreenD(screenD))
            Screen->Message(message);
         
         setScreenD(screenD, true);
      }
   }
}

@Author("Joe123, Deathrider365")
ffc script Signpost {
   CONFIG SMT_SCREEND = 1;
   CONFIG SMT_SECRETS = 2;
   CONFIG SMT_HAS_ITEM = 3;

   void run(int message, int warp, int hasSecondMessage, int secondMessage) { 
      int secondMessageTrigger, secondMessageTriggerValue;
      
      if (hasSecondMessage) {
         secondMessageTrigger = Floor(hasSecondMessage);
         secondMessageTriggerValue = (hasSecondMessage % 1) / 1L; 
      }

      while(true) {
         until(againstFFC(this->X, this->Y) && Input->Press[CB_SIGNPOST]) {
            if (againstFFC(this->X, this->Y))
               Screen->FastCombo(7, Link->X - 10, Link->Y - 15, 48, 0, OP_OPAQUE);
            Waitframe();
         }         
         
         Input->Button[CB_SIGNPOST] = false;
         Game->Suspend[susptSCREENDRAW] = true;
         
         switch(secondMessageTrigger) {
            case SMT_SCREEND:
               unless (getScreenD(secondMessageTriggerValue)) {
                  Screen->Message(message);
                  setScreenD(secondMessageTriggerValue, true);
               } else {
                  Screen->Message(secondMessage);
               }
               break;
            case SMT_SECRETS:
               unless (Screen->State[ST_SECRET])
                  Screen->Message(message);
               else
                  Screen->Message(secondMessage);
               break;
            case SMT_HAS_ITEM:
               unless (Hero->Item[secondMessageTriggerValue])
                  Screen->Message(message);
               else
                  Screen->Message(secondMessage);
               break;
            default:
               Screen->Message(message);
               break;
         }
         
         Game->Suspend[susptSCREENDRAW] = false;
         Waitframe();
         
         if (warp) {
            int dmap = Floor(warp);
            int screen = (warp % 1) / 1L;
            Hero->WarpEx({WT_IWARPBLACKOUT, dmap, screen, -1, WARP_A, WARPFX_NONE, 0, 0, DIR_DOWN});
         }
      }
   }
}

@Author("EmilyV99")
ffc script WarpCustomReturn {
   void run(int dmapScreen1, int x1, int y1, int dmapScreen2, int x2, int y2, int sideFacing, int warp) {
      int dmap1 = Floor(dmapScreen1);
      int screen1 = (dmapScreen1 % 1) / 1L;
      int dmap2 = Floor(dmapScreen2);
      int screen2 = (dmapScreen2 % 1) / 1L;
      int warpType = Floor(warp);
      int warpEffect = (warp % 1) / 1L;
      int side = Floor(sideFacing);
      int dir = (sideFacing % 1) / 1L;
      
      switch(side) {
         case DIR_UP:
            while(true) {
               if(Hero->Y <= 1.5 && Hero->InputUp) {
                  if(dmap2 && Hero->X >= this->X)
                     Hero->WarpEx({warpType, dmap2, screen2, x2, y2, warpEffect, 0, 0, dir});
                  else 
                     Hero->WarpEx({warpType, dmap1, screen1, x1, y1, warpEffect, 0, 0, dir});
               }
               Waitframe();
            }
         case DIR_DOWN: 
            while(true) {
               if(Hero->Y >= 158.5 && Hero->InputDown) {
                  if(dmap2 && Hero->X >= this->X)
                     Hero->WarpEx({warpType, dmap2, screen2, x2, y2, warpEffect, 0, 0, dir});
                  else 
                     Hero->WarpEx({warpType, dmap1, screen1, x1, y1, warpEffect, 0, 0, dir});
               }
               Waitframe();
            }
         case DIR_LEFT:
            while(true) {
               if(Hero->X <= 1.5 && Hero->InputLeft) {
                  if(dmap2 && Hero->Y >= this->Y)
                     Hero->WarpEx({warpType, dmap2, screen2, x2, y2, warpEffect, 0, 0, dir});
                  else 
                     Hero->WarpEx({warpType, dmap1, screen1, x1, y1, warpEffect, 0, 0, dir});
               }
               Waitframe();
            }
         case DIR_RIGHT:
            while(true) {
               if(Hero->X >= 238.5 && Hero->InputRight) {
                  if(dmap2 && Hero->Y >= this->Y)
                     Hero->WarpEx({warpType, dmap2, screen2, x2, y2, warpEffect, 0, 0, dir});
                  else 
                     Hero->WarpEx({warpType, dmap1, screen1, x1, y1, warpEffect, 0, 0, dir});
               }
               Waitframe();
            }
         default:
            while(true) {
               if (Abs(Hero->X - this->X) <= 14 && Abs(Hero->Y - this->Y) <= 14)
                  Hero->WarpEx({warpType, dmap1, screen1, x1, y1, warpEffect, 0, 0, dir});
               Waitframe();
            }
      }
   }
}




















