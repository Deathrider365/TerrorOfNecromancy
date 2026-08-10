
bool OverUnder_Running() : default false;
bool OverUnder_LinkBelow() : default false;
void OverUnder_SetCombosFor(bool under);
void OverUnder_SetNPCIgnoreAll(npc n);
void OverUnder_SetEWeaponIgnore(eweapon e);

namespace Beamos
{
    // Tiles for the start and end point of the beam
    CONFIG CMB_BEAMOS_BEAM_START = 4697;
    CONFIG CMB_BEAMOS_BEAM_END = 4698;
    // CSet: Can also shift the colors of the beamos beam
    CONFIG CS_BEAMOS_BEAM = 8;
    // Colors: Should all be within the same CSet
    CONFIG C_BEAMOS_BEAM1 = 0x82;
    CONFIG C_BEAMOS_BEAM2 = 0x83;

    // Frames the beamos flashes for before firing
    CONFIG BEAMOS_WINDUP = 12;
    // Minimum angle a beamos turns between shots
    CONFIG BEAMOS_SAFETY_ANGLE = 90;
    
    // Sound of a beamos flashing before firing
    CONFIG SFX_BEAMOS_WINDUP = 72;
    // Sound of a beam firing
    CONFIG SFX_BEAMOS_BEAM = 71;

    CONFIG EW_BEAMOS_BEAM = EW_SCRIPT10;

    // Damage the beamos does when not attached to an enemy hitbox
    CONFIG BEAMOS_DEFAULT_DAMAGE = 4;

    ffc script Beamos
    {
        void run(int turnSpeed, int startAngle, int beamLength, int beamStep, int beamBounces, int beamCSet, int hitboxEnemy, bool isBelow)
        {
            if(!beamStep)
                beamStep = 8;
            if(!beamCSet)
                beamCSet = CS_BEAMOS_BEAM;
            int slot_BeamosBeam = Game->GetEWeaponScript("BeamosBeam");
            int angle = startAngle;
            combodata cd = Game->LoadComboData(this->Data);
            int oTile = cd->OriginalTile;
            untyped eyeXY[3];
            int maxCooldown = Ceiling(BEAMOS_SAFETY_ANGLE/Abs(turnSpeed));
            int cooldown = maxCooldown;
            // This draw call doesn't actually do any drawing, just sets the FFC's layer on init
            Draw(this, NULL, eyeXY, oTile, angle, isBelow, false);
            if(this->Flags[FFCF_PRELOAD])
                Waitframe();
            npc hitbox;
            ffc solidhitbox = LoadSolidHitboxFFC(this);
            if(hitboxEnemy)
            {
                hitbox = CreateNPCAt(hitboxEnemy, this->X, this->Y+16);
                hitbox->DrawXOffset = -10000;
                OverUnder_SetNPCIgnoreAll(hitbox);
            }
            while(true)
            {
                angle = WrapDegrees(angle+turnSpeed);
                if(OverUnder_Running())
                    OverUnder_SetCombosFor(isBelow);
                Update(this, solidhitbox, hitbox, eyeXY, oTile, angle, isBelow);
                if(!cooldown&&Sighted(eyeXY, angle, turnSpeed, beamStep, isBelow))
                {
                    int angleLink = Angle(eyeXY[0], eyeXY[1], Link->X, Link->Y);
                    int cs = this->CSet;
                    Audio->PlaySound(SFX_BEAMOS_WINDUP);
                    for(int i=0; i<BEAMOS_WINDUP; ++i)
                    {
                        this->CSet = 9-(i>>1);
                        Update(this, solidhitbox, hitbox, eyeXY, oTile, angle, isBelow);
                        Waitframe();
                    }
                    this->CSet = cs;
                    eweapon e = FireEWeaponDegAngle(EW_BEAMOS_BEAM, eyeXY[0], eyeXY[1], angleLink, 0, hitbox?hitbox->WeaponDamage:BEAMOS_DEFAULT_DAMAGE, 0, 0, slot_BeamosBeam, {beamLength, beamStep, beamBounces, beamCSet, isBelow, 4});
                    int beamFrames = Ceiling(beamLength/beamStep);
                    for(int i=0; i<beamFrames; ++i)
                    {
                        Update(this, solidhitbox, hitbox, eyeXY, oTile, angle, isBelow);
                        Waitframe();
                    }
                    Update(this, solidhitbox, hitbox, eyeXY, oTile, angle, isBelow);
                    cooldown = maxCooldown;
                }
                if(cooldown)
                    --cooldown;
                Waitframe();
            }
        }
        ffc LoadSolidHitboxFFC(ffc this)
        {
            for(int i=1; i<=MAX_FFC; ++i)
            {
                ffc f = Screen->LoadFFC(i);
                if(f->Data==0&&f->Script==0)
                {
                    f->Data = this->Data;
                    f->Flags[FFCF_LENSINVIS] = true;
                    f->Flags[FFCF_LENSVIS] = true;
                    f->X = this->X;
                    f->Y = this->Y+16;
                    f->EffectWidth = 16;
                    f->EffectHeight = 16;
                    f->Flags[FFCF_SOLID] = true;
                    f->Flags[FFCF_ETHEREAL] = true;
                    return f;
                }
            }
            return NULL;
        }
        bool Sighted(untyped[] eyeXY, int angle, int turnSpeed, int beamStep, bool isBelow)
        {
            if(OverUnder_Running())
            {
                if(isBelow!=OverUnder_LinkBelow())
                    return false;
            }
            if(eyeXY[0]<Viewport->X-8||eyeXY[1]<Viewport->Y-8||eyeXY[0]>Viewport->X+Viewport->Width-8||eyeXY[1]>Viewport->Y+Viewport->Height-8)
                return false;
            int angleLink = Angle(eyeXY[0], eyeXY[1], Link->X, Link->Y);
            if(Abs(WrapDegrees(angle-angleLink))<=Ceiling(Abs(turnSpeed)))
            {
                int dist = Distance(eyeXY[0], eyeXY[1], Link->X, Link->Y)-8;
                int x = eyeXY[0];
                int y = eyeXY[1];
                for(int i=0; i<dist; i+=beamStep)
                {
                    if(i>BEAMOS_BEAM_LENIENCY&&BeamosBeam.isSolid(x, y))
                    {
                        return false;
                    }
                    x += VectorX(beamStep, angleLink);
                    y += VectorY(beamStep, angleLink);
                }
                return true;
            }
            return false;
        }
        void Draw(ffc this, npc hitbox, untyped[] eyeXY, int oTile, int angle, bool isBelow, bool actuallyDraw)
        {
            int underLayer = SPLAYER_NPC_DRAW;
            int overLayer = 4;
            int ffcLayer = 2;
            if(OverUnder_Running())
            {
                if(isBelow)
                {
                    if(OverUnder_LinkBelow())
                    {
                        overLayer = 3;
                    }
                    else
                    {
                        underLayer = 1;
                        overLayer = 1;
                        ffcLayer = 0;
                    }
                }
                else
                {
                    if(OverUnder_LinkBelow())
                    {
                        underLayer = 5;
                        overLayer = 5;
                        ffcLayer = 4;
                    }
                }
                this->Layer = ffcLayer;
            }
            if(actuallyDraw)
            {
                int cs = this->CSet;
                if(hitbox->isValid())
                {
                    if(hitbox->InvFrames)
                        cs = hitbox->FlashingCSet;
                }
                Screen->DrawTile(underLayer, this->X, this->Y, oTile, 1, 2, cs, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
                int tilEye = oTile+2+AngleDir8(angle);
                if(eyeXY[2])
                    Screen->FastTile(overLayer, eyeXY[0], eyeXY[1], tilEye, cs, OP_OPAQUE);
                Screen->DrawTile(overLayer, this->X, this->Y, oTile+1, 1, 2, cs, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
                if(!eyeXY[2])
                    Screen->FastTile(overLayer, eyeXY[0], eyeXY[1], tilEye, cs, OP_OPAQUE);
            }
        }
        void Update(ffc this, ffc solidHitbox, npc hitbox, untyped[] eyeXY, int oTile, int angle, bool isBelow)
        {
            solidHitbox->X = this->X;
            solidHitbox->Y = this->Y+16;
            eyeXY[0] = this->X+VectorX(8, angle);
            eyeXY[1] = this->Y+4+VectorY(5, angle);
            eyeXY[2] = VectorY(5, angle)<0;
            if(hitbox&&hitbox->isValid())
            {
                hitbox->Stun = 60;
                hitbox->NoCollisionTimer = (isBelow==OverUnder_LinkBelow()?0:-1);
                if(hitbox->HP<=0)
                {
                    hitbox->DrawXOffset = 0;
                    solidHitbox->Flags[FFCF_SOLID] = false;
                    solidHitbox->Data = 0;
                    this->Data = 0;
                    Quit();
                }
            }
            if(!hitbox||(hitbox->isValid()&&hitbox->HP>0))
                Draw(this, hitbox, eyeXY, oTile, angle, isBelow, true);
        }
    }

    // How many pixels the beam travels through solidity
    CONFIG BEAMOS_BEAM_LENIENCY = 32;

    eweapon script BeamosBeam
    {
        void run(int length, int step, int bounces, int cset, bool isBelow, int sensitivity)
        {
            Audio->PlaySound(SFX_BEAMOS_BEAM);
            this->HitXOffset = -10000;
            this->DrawXOffset = -10000;
            int pierceFrames = Ceiling(BEAMOS_BEAM_LENIENCY/step);
            int startX = this->X+8;
            int startY = this->Y+8;
            int x = startX;
            int y = startY;
            int bounceX[1] = {startX};
            int bounceY[1] = {startY};
            int vX = VectorX(step, this->DegAngle);
            int vY = VectorY(step, this->DegAngle);
            int curLength;
            bool wasSolid = isSolid(x, y);
            bool spawning = true;
            bool died;
            int c1 = cset*16+C_BEAMOS_BEAM1%16;
            int c2 = cset*16+C_BEAMOS_BEAM2%16;
            while(true)
            {
                if(OverUnder_Running())
                {
                    OverUnder_SetCombosFor(isBelow);
                }
                if(died)
                    curLength = Max(curLength-step, 0);
                else
                {
                    curLength = Min(curLength+step, length);
                    if(curLength>=length)
                        spawning = false;
                }
                if(!died)
                {
                    bool doBounceX, doBounceY;
                    if(curLength>BEAMOS_BEAM_LENIENCY)
                    {
                        doBounceX = isSolid(x+vX, y);
                        doBounceY = isSolid(x, y+vY);
                    }
                    x += vX;
                    y += vY;
                    if(!isSolid(x, y))
                    {
                        doBounceX = false;
                        doBounceY = false;
                    }
                    if(doBounceX||doBounceY)
                    {
                        if(bounces>0)
                        {
                            ArrayPushBack(bounceX, x);
                            ArrayPushBack(bounceY, y);
                            --bounces;
                        }
                        else
                            died = true;
                    }
                    if(doBounceX)
                        vX = -vX;
                    else if(doBounceY)
                        vY = -vY;
                }
                if(curLength==0)
                    break;
                DrawAndCollide(x, y, bounceX, bounceY, cset, c1, c2, this->Damage, curLength, spawning, died, isBelow, sensitivity);
                this->DeadState = WDS_ALIVE;
                Waitframe();
            }
            this->Remove();
        }
        void DrawAndCollide(int x, int y, int[] bounceX, int[] bounceY, int cset, int c1, int c2, int damage, int curLength, bool spawning, bool died, bool isBelow, int sensitivity)
        {
            int layer = BeamDrawLayer(isBelow);
            int sz = SizeOfArray(bounceX);
            int tailX, tailY;
            for(int i=sz-1; i>=0; --i)
            {
                if(curLength>0)
                {
                    int startX, startY;
                    int endX, endY;
                    if(i==sz-1)
                    {
                        startX = x;
                        startY = y;
                        endX = bounceX[i];
                        endY = bounceY[i];
                    }
                    else
                    {
                        startX = bounceX[i+1];
                        startY = bounceY[i+1];
                        endX = bounceX[i];
                        endY = bounceY[i];
                    }
                    int ang = Angle(startX, startY, endX, endY);
                    int dist = Distance(startX, startY, endX, endY);
                    if(dist>0)
                    {
                        if(curLength<dist)
                        {
                            endX = startX+VectorX(curLength, ang);
                            endY = startY+VectorY(curLength, ang);
                        }
                        int newDist = Distance(startX, startY, endX, endY);
                        Screen->Rectangle(layer, startX, startY-1, startX+newDist, startY+1, c1, 1, startX, startY, ang, true, OP_OPAQUE);
                        Screen->Line(layer, startX, startY, endX, endY, c2, 1, 0, 0, 0, OP_OPAQUE);
                        if(BeamosLaserCollision(startX, startY, endX, endY, Link->X, Link->Y, Link->X+15, Link->Y+15, sensitivity, isBelow))
                        {
                            int angLink = Angle(endX, endY, Link->X, Link->Y);
                            int ex = Link->X-VectorX(4, angLink);
                            int ey = Link->Y-VectorY(4, angLink);
                            eweapon e = CreateEWeaponAt(EW_BEAMOS_BEAM, ex, ey);
                            e->DrawXOffset = -10000;
                            e->Dir = AngleDir4(angLink);
                            e->Damage = damage;
                            e->Unblockable = UNBLOCK_ALL;
                            e->Timeout = 2;
                            OverUnder_SetEWeaponIgnore(e);
                        }
                        tailX = endX;
                        tailY = endY;
                    }
                    curLength -= dist;
                }
            }
            if(died)
                Screen->FastCombo(layer, x-8, y-8, CMB_BEAMOS_BEAM_END, cset, OP_OPAQUE);
            if(spawning)
                Screen->FastCombo(layer, tailX-8, tailY-8, CMB_BEAMOS_BEAM_START, cset, OP_OPAQUE);
        }
        bool BeamosLaserCollision(int lineX1, int lineY1, int lineX2, int lineY2, int boxX1, int boxY1, int boxX2, int boxY2, int boxBorder, bool isBelow)
        {
            if(OverUnder_Running()&&isBelow!=OverUnder_LinkBelow())
                return false;
            // Shrink down the box for the border
            boxX1 += boxBorder; boxY1 += boxBorder;
            boxX2 -= boxBorder; boxY2 -= boxBorder;
            
            // If the line isn't vertical
            if(lineX2!=lineX1)
            {
                
                float i0 = (boxX1 - lineX1)/(lineX2-lineX1);
                float i1 = (boxX2 - lineX1)/(lineX2-lineX1);
                
                float yA = lineY1 + i0*(lineY2-lineY1);
                float yB = lineY1 + i1*(lineY2-lineY1);
                
                
                if(Max(boxX1, boxX2) >= Min(lineX1, lineX2) && Min(boxX1, boxX2) <= Max(lineX1, lineX2) &&
                    Max(boxY1, boxY2) >= Min(lineY1, lineY2) && Min(boxY1, boxY2) <= Max(lineY1, lineY2))
                {
                    if(Min(boxY1, boxY2) > Max(yA, yB) || Max(boxY1, boxY2) < Min(yA, yB))
                        return false;
                    else
                        return true;
                }
                else
                    return false;
            }
            // If the line is vertical
            else if(lineX1 >= boxX1 && lineX1 <= boxX2)
            {
                // Basically we need to find the top and bottom y values of the line to check for intersection
                float lineYMin = lineY1;
                float lineYMax = lineY2;
                
                if(lineYMin > lineYMax)
                {
                    lineYMin = lineY2;
                    lineYMax = lineY1;
                }
                
                // If either point intersects
                if((boxY1 >= lineYMin && boxY1 <= lineYMax) || (boxY2 >= lineYMin && boxY2 <= lineYMax))
                    return true;
            }
            
            return false;
        }
        bool isSolid(int x, int y)
        {
            if(x<0||y<0||x>Region->Width||y>Region->Height)
            {
                if(x<-16||y<-16||x>Region->Width+16||y>Region->Height+16)
                    return true;
                return false;
            }
            int pos = ComboAt(x, y);
            bool passThru;
            bool solid;
            int q;
            if(x%16<8)
            {
                if(y%16<8)
                    q = 0x1;
                else
                    q = 0x2;
            }
            else
            {
                if(y%16<8)
                    q = 0x4;
                else
                    q = 0x8;
            }
            for(int i=0; i<=2; ++i)
            {
                mapdata lyr = Game->LoadTempScreen(i);
                bool checkSolid = true;
                if(lyr->ComboE[pos]&q)
                {
                    switch(lyr->ComboT[pos])
                    {
                        case CT_WATER:
                        case CT_DIVEWARP:
                        case CT_DIVEWARPB...CT_DIVEWARPD:
                        case CT_SWIMWARP:
                        case CT_SWIMWARPB...CT_SWIMWARPD:
                        case CT_LADDERHOOKSHOT:
                        case CT_LADDERONLY:
                        case CT_HOOKSHOTONLY:
                            passThru = true;
                            checkSolid = false;
                            break;
                        case CT_BRIDGE:
                            solid = false;
                    }
                }
                if(checkSolid)
                {
                    if(lyr->ComboS[pos]&q)
                        solid = true;
                }
            }
            if(!passThru)
                return Screen->isSolid(x, y);
            return solid;
        }
        int BeamDrawLayer(bool isBelow)
        {
            if(OverUnder_Running())
            {
                if(isBelow)
                    return OverUnder_LinkBelow()?3:1;
                else
                    return 4;
            }
            return 4;
        }
    }
}
