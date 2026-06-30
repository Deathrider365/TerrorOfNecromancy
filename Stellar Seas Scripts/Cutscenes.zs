//START CUTSCENE.ZH
const int CUTSCENE_SANITIZE_ROTATION = 0; //If 1, rx and ry will be treated as the center of the sprite

const int CUTSCENE_MAX_DRAWS = 256; //The max number of draws there can ever be

const int CUTSCENE_GLOBAL_INDICES = 32; //Arbitrary offset, don't change
const int CUTSCENE_DRAW_INDICES = 48; //How many indices are used by each object, don't change

//Array indices, don't change
const int CG_NUMDRAWS        = 0; //How many draws are currently being used
const int CG_BGMAP           = 1; //Which map is being used by the background currently
const int CG_CAMANCHORX      = 2; //X, Y positions of the anchor point (0, 0)
const int CG_CAMANCHORY      = 3; //
const int CG_CAMX            = 4; //X, Y positions of the camera relative to the anchor point
const int CG_CAMY            = 5; //
const int CG_CAMTX           = 6; //Target X, Y point for the camera relative to the anchor point
const int CG_CAMTY           = 7; //
const int CG_STAGEWIDTH      = 8; //Width/Height of the stage, used for keeping the camera constrained
const int CG_STAGEHEIGHT     = 9; //
const int CG_CAMSTEP         = 10; //How fast the camera should move
const int CG_CAMFOLLOWTARGET = 11; //Which draw the camera should follow. -1 for none
const int CG_CAMFOLLOWRANGE  = 12; //How far the camera should follow behind the follow target
const int CG_USEBITMAP       = 13; //Which bmp to use
const int CG_ZOOMCX          = 14; //Center X, Y for the zoom-in effect
const int CG_ZOOMCY          = 15; //
const int CG_ZOOMAMOUNT     = 16; //Amount of zoom-in, 0 being the least, 256 being the most
const int CG_ZOOMMAXAMOUNT  = 17; //Max amount of zoom-in, used to make the end zoom position more accurate when zooming only up to a certain point
const int CG_NUMGLIDING      = 18; //Keeps track of how many sprites are currently gliding into position
const int CG_ACTIVELAYER0    = 19; //Marks which layers are active
const int CG_ACTIVELAYER1    = 20; //
const int CG_ACTIVELAYER2    = 21; //
const int CG_ACTIVELAYER3    = 22; //
const int CG_ACTIVELAYER4    = 23; //
const int CG_ACTIVELAYER5    = 24; //
const int CG_ACTIVELAYER6    = 25; //
const int CG_DRAWSTYLE       = 26; //Pointer for the current draw being drawn, used in for loops and moved back when removing draws
const int CG_BACKUPBITMAP    = 27;
const int CG_MASKED          = 28; //Whether or not to show the transparent color on the final draw

//Draw Styles
const int CGDS_DEFAULT = 0;
const int CGDS_TRUELAYERNOBG = 1;

//Draw Types
const int CGDT_RECTANGLE = 0;
const int CGDT_CIRCLE = 1;
const int CGDT_ARC = 2;
const int CGDT_ELLIPSE = 3;
const int CGDT_SPLINE = 4;
const int CGDT_LINE = 5;
const int CGDT_PIXEL = 6;
const int CGDT_TILE = 7;
const int CGDT_FASTTILE = 8;
const int CGDT_COMBO = 9;
const int CGDT_FASTCOMBO = 10;
const int CGDT_QUAD = 11;
const int CGDT_TRIANGLE = 12;
const int CGDT_BITMAP = 13;
const int CGDT_LAYER = 14;
const int CGDT_SCREEN = 15;
const int CGDT_NPC = 16;
const int CGDT_ANIM = 17;
const int CGDT_BLIT = 18;

//Draw indices, don't change
const int CGI_DRAWTYPE     = 0; //Which type of draw
const int CGI_DRAWLIFESPAN = 1; //How many frames the draw lasts for
const int CGI_LAYER        = 2; //Which layer the draw goes on
const int CGI_X            = 3; //X, Y position of the draw
const int CGI_Y            = 4; //
const int CGI_DIR          = 5; //For NPC draws, the direction it's facing in
const int CGI_MOVEANGLE    = 6; //Which angle the draw is moving in
const int CGI_MOVESTEP     = 7; //How fast, in pixels per frame the draw moves
const int CGI_GFX          = 8; //Combo/Tile of the draw
const int CGI_CLR          = 9; //CSet/Color of the draw
const int CGI_RADIUS       = 10; //Radius for circles, arcs, and ellipses
const int CGI_RADIUS2      = 11; //Second radius for ellipses
const int CGI_TILEWIDTH    = 12; //Tile width, height for tiles/combos
const int CGI_TILEHEIGHT   = 13; //
const int CGI_WIDTH        = 14; //Width, Height for various draws
const int CGI_HEIGHT       = 15; //
const int CGI_ROTX         = 16; //Rotation X, Y position for draws
const int CGI_ROTY         = 17; //
const int CGI_ROT          = 18; //Rotation angle for draws
const int CGI_X2           = 19; //Extra X, Y positions for draws
const int CGI_Y2           = 20; //
const int CGI_X3           = 21; //
const int CGI_Y3           = 22; //
const int CGI_X4           = 23; //
const int CGI_Y4           = 24; //
const int CGI_MISC1        = 25; //Misc values for draws
const int CGI_MISC2        = 26; //
const int CGI_MISC3        = 27; //
const int CGI_MISC4        = 28; //
const int CGI_MISC5        = 29; //
const int CGI_OPACITY      = 30; //Opacity for draws
const int CGI_TX           = 31; //Target X, Y point for gliding
const int CGI_TY           = 32; //
const int CGI_PARENT       = 33; //Which draw to move alongside
const int CGI_PARENTOFFX   = 34; //X, Y offset to put from the parent draw
const int CGI_PARENTOFFY   = 35; //
const int CGI_ACCELSTEP    = 36; //Accelerated step when gliding
const int CGI_TARGETDIST   = 37; //Initial distance to target when gliding
const int CGI_FLAGS        = 47; //CGF_ Flags

const int CGF_FADEDEATH    = 00000000001b; //If lifespan <8, opacity set to 64
const int CGF_HALTDEATH    = 00000000010b; //When lifespan hits 0, stop movement instead of killing the draw
const int CGF_4WAY         = 00000000100b; //For tiles and combos, GFX changes based on movement direction
const int CGF_8WAY         = 00000001000b; //For tiles and combos, GFX changes based on movement direction
const int CGF_SUSPENDED    = 00000010000b; //While set the draw will not update
const int CGF_BS           = 00000100000b; //For NPCs, do BS animation
const int CGF_BIGNPC       = 00001000000b; //For NPCs, make 2 tile
const int CGF_MARKER       = 00010000000b; //For testing purposes
const int CGF_GLIDESUCCESS = 00100000000b; //Set for 1 frame when glide finishes
const int CGF_AUTOCENTER   = 01000000000b; //Tile rotations are automatically centered
const int CGF_NODRAW       = 10000000000b; //Rendered invisible

int cutsceneG[12320]; //CUTSCENE_DRAW_INDICES*CUTSCENE_MAX_DRAWS+CUTSCENE_GLOBAL_INDICES

void Cutscene_Debug_TileRotTest(int x, int y, int w, int h, int rX, int rY, int rAngle){
	Screen->Rectangle(6, x, y, x+w-1, y+h-1, 0x01, 1, rX+w/2, rY+h/2, rAngle, false, 128);
	Screen->PutPixel(6, rX+w/2, rY+h/2, 0x01, 0, 0, 0, 128);
}

//returns the original tile of a combo
int Cutscene_ComboOTile(int cmb){
	combodata cd = Game->LoadComboData(cmb);
	return cd->OriginalTile;
}
//returns the current frame of a combo
int Cutscene_ComboFrame(int cmb){
	combodata cd = Game->LoadComboData(cmb);
	return cd->Frame;
}
//returns the flip of a combo
int Cutscene_ComboFlip(int cmb){
	combodata cd = Game->LoadComboData(cmb);
	return cd->Flip;
}

//rotates X about a center point by an amount of degrees
float Cutscene_RotatePointX(float x, float y, float centerX, float centerY, float degrees) {
	int distance = Cutscene_LargeDistance(centerX, centerY, x, y, 10);
	int angle = Angle(centerX, centerY, x, y);
	
	return centerX+VectorX(distance, angle+degrees);
  // float dx = x - centerX;
  // float dy = y - centerY;
  // return (Cos(degrees) * dx) - (Sin(degrees) * dy) + centerX;
}

//rotates Y about a center point by an amount of degrees
float Cutscene_RotatePointY(float x, float y, float centerX, float centerY, float degrees) {
	int distance = Cutscene_LargeDistance(centerX, centerY, x, y, 10);
	int angle = Angle(centerX, centerY, x, y);
	
	return centerY+VectorY(distance, angle+degrees);
  // float dx = x - centerX;
  // float dy = y - centerY;
  // return (Sin(degrees) * dx) - (Cos(degrees) * dy) + centerY;
}

//Gets draw attributes from the global array
int Cutscene_GetAttr(int index, int attr){
	return cutsceneG[CUTSCENE_GLOBAL_INDICES+CUTSCENE_DRAW_INDICES*index+attr];
}

//Set draw attributes in the global array
void Cutscene_SetAttr(int index, int attr, int val){
	cutsceneG[CUTSCENE_GLOBAL_INDICES+CUTSCENE_DRAW_INDICES*index+attr] = val;
}

//Adds to draw attributes in the global array
void Cutscene_AddAttr(int index, int attr, int val){
	cutsceneG[CUTSCENE_GLOBAL_INDICES+CUTSCENE_DRAW_INDICES*index+attr] += val;
}

//Returns if a draw has a flag
bool Cutscene_HasFlag(int index, int flag){
	return Cutscene_GetAttr(index, CGI_FLAGS)&flag;
}

//Sets a draw flag
void Cutscene_SetFlag(int index, int flag){
	Cutscene_SetAttr(index, CGI_FLAGS, Cutscene_GetAttr(index, CGI_FLAGS) | flag);
}

//Unsets a draw flag
void Cutscene_UnsetFlag(int index, int flag){
	Cutscene_SetAttr(index, CGI_FLAGS, Cutscene_GetAttr(index, CGI_FLAGS) & ~flag);
}

//Sets a draw's lifespan to -1 (immortal)
void Cutscene_MakeImmortal(int index){
	cutsceneG[CUTSCENE_GLOBAL_INDICES+CUTSCENE_DRAW_INDICES*index+CGI_DRAWLIFESPAN] = -1;
}

int __Cutscene_FindUnusedIndex(){
	for(int i=0; i<CUTSCENE_MAX_DRAWS; i++){
		if(cutsceneG[CUTSCENE_GLOBAL_INDICES+CUTSCENE_DRAW_INDICES*i+CGI_DRAWTYPE]==-1){
			if(i+i>cutsceneG[CG_NUMDRAWS])
				cutsceneG[CG_NUMDRAWS] = i+1;
			return i;
		}
	}
	return 0;
}
//Draw functions, instructions pulled from ZScript.txt

// /**
// * Draws a rectangle on the specified layer of the current screen, using
// * (x,y) as the top-left corner and (x2,y2) as the bottom-right corner.
// * Then scales the rectangle uniformly about its center by the given
// * factor.
// * Lastly, a rotation, centered about the point (rx, ry), is performed
// * counterclockwise using an angle of rangle degrees.
// * A filled rectangle is drawn if fill is true; otherwise, this method
// * draws a wireframe.
// * The rectangle is drawn using the specified index into the entire
// * 256-element palette: for instance, passing in a color of 17 would
// * use color 1 of cset 1.
// * Opacity controls how transparent the rectangle will be. Values other
// * than OP_OPAQUE and OP_TRANS are currently undefined.
// */
int Cutscene_NewRectangle(int layer, int x, int y, int x2, int y2, int color, int scale, int rx, int ry, int rangle, bool fill, int opacity){
	int i = __Cutscene_FindUnusedIndex(); //cutsceneG[CG_NUMDRAWS];
	
	Cutscene_SetAttr(i, CGI_DRAWTYPE, CGDT_RECTANGLE);
	Cutscene_SetAttr(i, CGI_LAYER, layer);
	Cutscene_SetAttr(i, CGI_X, x);
	Cutscene_SetAttr(i, CGI_Y, y);
	Cutscene_SetAttr(i, CGI_X2, x2);
	Cutscene_SetAttr(i, CGI_Y2, y2);
	Cutscene_SetAttr(i, CGI_CLR, color);
	Cutscene_SetAttr(i, CGI_WIDTH, scale);
	Cutscene_SetAttr(i, CGI_ROTX, rx);
	Cutscene_SetAttr(i, CGI_ROTY, ry);
	Cutscene_SetAttr(i, CGI_ROT, rangle);
	Cutscene_SetAttr(i, CGI_MISC1, Cond(fill, 1, 0));
	Cutscene_SetAttr(i, CGI_OPACITY, opacity);
	
	Cutscene_SetAttr(i, CGI_DRAWLIFESPAN, 1);
	
	//cutsceneG[CG_NUMDRAWS] = Min(cutsceneG[CG_NUMDRAWS]+1, CUTSCENE_MAX_DRAWS-1);
	return i;
}

// /**
// * Draws a circle on the specified layer of the current screen with
// * center (x,y) and radius scale*radius.
// * Then performs a rotation counterclockwise, centered about the point
// * (rx, ry), using an angle of rangle degrees.
// * A filled circle is drawn if fill is true; otherwise, this method
// * draws a wireframe.
// * The circle is drawn using the specified index into the entire
// * 256-element palette: for instance, passing in a color of 17 would
// * use color 1 of cset 1.
// * Opacity controls how transparent the circle will be. Values other
// * than OP_OPAQUE and OP_TRANS are currently undefined.
// */
int Cutscene_NewCircle(int layer, int x, int y, int radius, int color, int scale, int rx, int ry, int rangle, bool fill, int opacity){
	int i = __Cutscene_FindUnusedIndex(); //cutsceneG[CG_NUMDRAWS];
	
	Cutscene_SetAttr(i, CGI_DRAWTYPE, CGDT_CIRCLE);
	Cutscene_SetAttr(i, CGI_LAYER, layer);
	Cutscene_SetAttr(i, CGI_X, x);
	Cutscene_SetAttr(i, CGI_Y, y);
	Cutscene_SetAttr(i, CGI_RADIUS, radius);
	Cutscene_SetAttr(i, CGI_CLR, color);
	Cutscene_SetAttr(i, CGI_WIDTH, scale);
	Cutscene_SetAttr(i, CGI_ROTX, rx);
	Cutscene_SetAttr(i, CGI_ROTY, ry);
	Cutscene_SetAttr(i, CGI_ROT, rangle);
	Cutscene_SetAttr(i, CGI_MISC1, Cond(fill, 1, 0));
	Cutscene_SetAttr(i, CGI_OPACITY, opacity);
	
	Cutscene_SetAttr(i, CGI_DRAWLIFESPAN, 1);
	
	//cutsceneG[CG_NUMDRAWS] = Min(cutsceneG[CG_NUMDRAWS]+1, CUTSCENE_MAX_DRAWS-1);
	return i;
}

// /**
// * Draws an arc of a circle on the specified layer of the current
// * screen. The circle in question has center (x,y) and radius
// * scale*radius.
// * The arc beings at startangle degrees counterclockwise from standard
// * position, and ends at endangle degress counterclockwise from standard
// * position. The behavior of this function is undefined unless
// * 0 <= endangle-startangle < 360.
// * The arc is then rotated about the point (rx, ry) using an angle of
// * rangle radians.
// * If closed is true, a line is drawn from the center of the circle to
// * each endpoint of the arc, forming a sector of the circle. If fill
// * is also true, a filled sector is drawn instead.
// * The arc or sector is drawn using the specified index into the entire
// * 256-element palette: for instance, passing in a color of 17 would
// * use color 1 of cset 1.
// * Opacity controls how transparent the arc will be. Values other
// * than OP_OPAQUE and OP_TRANS are currently undefined.
// */
int Cutscene_NewArc(int layer, int x, int y, int radius, int startangle, int endangle, int color, int scale, int rx, int ry, int rangle, bool closed, bool fill, int opacity){
	int i = __Cutscene_FindUnusedIndex(); //cutsceneG[CG_NUMDRAWS];
	
	Cutscene_SetAttr(i, CGI_DRAWTYPE, CGDT_ARC);
	Cutscene_SetAttr(i, CGI_LAYER, layer);
	Cutscene_SetAttr(i, CGI_X, x);
	Cutscene_SetAttr(i, CGI_Y, y);
	Cutscene_SetAttr(i, CGI_RADIUS, radius);
	Cutscene_SetAttr(i, CGI_CLR, color);
	Cutscene_SetAttr(i, CGI_WIDTH, scale);
	Cutscene_SetAttr(i, CGI_ROTX, rx);
	Cutscene_SetAttr(i, CGI_ROTY, ry);
	Cutscene_SetAttr(i, CGI_ROT, rangle);
	Cutscene_SetAttr(i, CGI_MISC1, Cond(closed, 1, 0));
	Cutscene_SetAttr(i, CGI_MISC2, Cond(fill, 1, 0));
	Cutscene_SetAttr(i, CGI_MISC3, startangle);
	Cutscene_SetAttr(i, CGI_MISC4, endangle);
	Cutscene_SetAttr(i, CGI_OPACITY, opacity);
	
	Cutscene_SetAttr(i, CGI_DRAWLIFESPAN, 1);
	
	//cutsceneG[CG_NUMDRAWS] = Min(cutsceneG[CG_NUMDRAWS]+1, CUTSCENE_MAX_DRAWS-1);
	return i;
}

// /**
// * Draws an ellipse on the specified layer of the current screen with
// * center (x,y), x-axis radius xradius, and y-axis radius yradius.
// * Then performs a rotation counterclockwise, centered about the point
// * (rx, ry), using an angle of rangle degrees.
// * A filled ellipse is drawn if fill is true; otherwise, this method
// * draws a wireframe.
// * The ellipse is drawn using the specified index into the entire
// * 256-element palette: for instance, passing in a color of 17 would
// * use color 1 of cset 1.
// * Opacity controls how transparent the ellipse will be. Values other
// * than OP_OPAQUE and OP_TRANS are currently undefined.
// */
int Cutscene_NewEllipse(int layer, int x, int y, int xradius, int yradius, int color, int scale, int rx, int ry, int rangle, bool fill, int opacity){
	int i = __Cutscene_FindUnusedIndex(); //cutsceneG[CG_NUMDRAWS];
	
	Cutscene_SetAttr(i, CGI_DRAWTYPE, CGDT_ELLIPSE);
	Cutscene_SetAttr(i, CGI_LAYER, layer);
	Cutscene_SetAttr(i, CGI_X, x);
	Cutscene_SetAttr(i, CGI_Y, y);
	Cutscene_SetAttr(i, CGI_RADIUS, xradius);
	Cutscene_SetAttr(i, CGI_RADIUS2, yradius);
	Cutscene_SetAttr(i, CGI_CLR, color);
	Cutscene_SetAttr(i, CGI_WIDTH, scale);
	Cutscene_SetAttr(i, CGI_ROTX, rx);
	Cutscene_SetAttr(i, CGI_ROTY, ry);
	Cutscene_SetAttr(i, CGI_ROT, rangle);
	Cutscene_SetAttr(i, CGI_MISC1, Cond(fill, 1, 0));
	Cutscene_SetAttr(i, CGI_OPACITY, opacity);
	
	Cutscene_SetAttr(i, CGI_DRAWLIFESPAN, 1);
	
	//cutsceneG[CG_NUMDRAWS] = Min(cutsceneG[CG_NUMDRAWS]+1, CUTSCENE_MAX_DRAWS-1);
	return i;
}

// /**
// * Draws a cardinal spline on the specified layer of the current screen
// * between (x1,y1) and (x4,y4)
// * The spline is drawn using the specified index into the entire
// * 256-element palette: for instance, passing in a color of 17 would
// * use color 1 of cset 1.
// * Opacity controls how transparent the ellipse will be. Values other
// * than OP_OPAQUE and OP_TRANS are currently undefined.
// */
int Cutscene_NewSpline(int layer, int x1, int y1, int x2, int y2, int x3, int y3, int x4, int y4, int color, int opacity){
	int i = __Cutscene_FindUnusedIndex(); //cutsceneG[CG_NUMDRAWS];
	
	Cutscene_SetAttr(i, CGI_DRAWTYPE, CGDT_SPLINE);
	Cutscene_SetAttr(i, CGI_LAYER, layer);
	Cutscene_SetAttr(i, CGI_X, x1);
	Cutscene_SetAttr(i, CGI_Y, y1);
	Cutscene_SetAttr(i, CGI_X2, x2);
	Cutscene_SetAttr(i, CGI_Y2, y2);
	Cutscene_SetAttr(i, CGI_X3, x3);
	Cutscene_SetAttr(i, CGI_Y3, y3);
	Cutscene_SetAttr(i, CGI_X4, x4);
	Cutscene_SetAttr(i, CGI_Y4, y4);
	Cutscene_SetAttr(i, CGI_OPACITY, opacity);
	
	Cutscene_SetAttr(i, CGI_DRAWLIFESPAN, 1);
	
	//cutsceneG[CG_NUMDRAWS] = Min(cutsceneG[CG_NUMDRAWS]+1, CUTSCENE_MAX_DRAWS-1);
	return i;
}

// /**
// * Draws a line on the specified layer of the current screen between
// * (x,y) and (x2,y2).
// * Then scales the line uniformly by a factor of scale about the line's
// * midpoint.
// * Finally, performs a rotation counterclockwise, centered about the

// * point (rx, ry), using an angle of rangle degrees.
// * The line is drawn using the specified index into the entire
// * 256-element palette: for instance, passing in a color of 17 would
// * use color 1 of cset 1.
// * Opacity controls how transparent the line will be. Values other
// * than OP_OPAQUE and OP_TRANS are currently undefined.
// */
int Cutscene_NewLine(int layer, int x, int y, int x2, int y2, int color, int scale, int rx, int ry, int rangle, int opacity){
	int i = __Cutscene_FindUnusedIndex(); //cutsceneG[CG_NUMDRAWS];
	
	Cutscene_SetAttr(i, CGI_DRAWTYPE, CGDT_LINE);
	Cutscene_SetAttr(i, CGI_LAYER, layer);
	Cutscene_SetAttr(i, CGI_X, x);
	Cutscene_SetAttr(i, CGI_Y, y);
	Cutscene_SetAttr(i, CGI_X2, x2);
	Cutscene_SetAttr(i, CGI_Y2, y2);
	Cutscene_SetAttr(i, CGI_CLR, color);
	Cutscene_SetAttr(i, CGI_WIDTH, scale);
	Cutscene_SetAttr(i, CGI_ROTX, rx);
	Cutscene_SetAttr(i, CGI_ROTY, ry);
	Cutscene_SetAttr(i, CGI_ROT, rangle);
	Cutscene_SetAttr(i, CGI_OPACITY, opacity);
	
	Cutscene_SetAttr(i, CGI_DRAWLIFESPAN, 1);
	
	//cutsceneG[CG_NUMDRAWS] = Min(cutsceneG[CG_NUMDRAWS]+1, CUTSCENE_MAX_DRAWS-1);
	return i;
}

// /**
// * Draws a raw pixel on the specified layer of the current screen
// * at (x,y).
// * Then performs a rotation counterclockwise, centered about the point
// * (rx, ry), using an angle of rangle degrees.
// * The point is drawn using the specified index into the entire
// * 256-element palette: for instance, passing in a color of 17 would
// * use color 1 of cset 1.
// * Opacity controls how transparent the point will be. Values other
// * than OP_OPAQUE and OP_TRANS are currently undefined.
// */
int Cutscene_NewPixel(int layer, int x, int y, int color, int rx, int ry, int rangle, int opacity){
	int i = __Cutscene_FindUnusedIndex(); //cutsceneG[CG_NUMDRAWS];
	
	Cutscene_SetAttr(i, CGI_DRAWTYPE, CGDT_PIXEL);
	Cutscene_SetAttr(i, CGI_LAYER, layer);
	Cutscene_SetAttr(i, CGI_X, x);
	Cutscene_SetAttr(i, CGI_Y, y);
	Cutscene_SetAttr(i, CGI_CLR, color);
	Cutscene_SetAttr(i, CGI_ROTX, rx);
	Cutscene_SetAttr(i, CGI_ROTY, ry);
	Cutscene_SetAttr(i, CGI_ROT, rangle);
	Cutscene_SetAttr(i, CGI_OPACITY, opacity);
	
	Cutscene_SetAttr(i, CGI_DRAWLIFESPAN, 1);
	
	//cutsceneG[CG_NUMDRAWS] = Min(cutsceneG[CG_NUMDRAWS]+1, CUTSCENE_MAX_DRAWS-1);
	return i;
}

// /**
// * Draws a block of tiles on the specified layer of the current screen,
// * starting at (x,y), using the specified cset.
// * Starting with the specified tile, this method copies a block of size
// * blockh x blockw from the tile sheet to the screen. This method's
// * behavior is undefined unless 1 <= blockh, blockw <= 20.
// * Scale specifies the actual size in pixels! So scale 1 would mean it is
// * only one pixel in size. To use the default sizes of block w,h you must
// * set xscale and yscale to -1. These values are not independant of one another,
// * so you cannot set xscale and leave yscale at -1.
// * rx, ry : these work now, just like the other primitives.
// * rangle performs a rotation clockwise using an angle of rangle degrees.
// * Flip specifies how the tiles should be flipped when drawn:
// * 0: No flip
// * 1: Horizontal flip
// * 2: Vertical flip
// * 3: Both (180 degree rotation)
// * If transparency is true, the tiles' transparent regions will be
// * respected.
// * Opacity controls how transparent the solid portions of the tiles will
// * be. Values other than OP_OPAQUE and OP_TRANS are currently undefined.
// */
int Cutscene_NewTile(int layer, int x, int y, int tile, int blockw, int blockh, int cset, int xscale, int yscale, int rx, int ry, int rangle, int flip, bool transparency, int opacity){
	int i = __Cutscene_FindUnusedIndex(); //cutsceneG[CG_NUMDRAWS];
	
	Cutscene_SetAttr(i, CGI_DRAWTYPE, CGDT_TILE);
	Cutscene_SetAttr(i, CGI_LAYER, layer);
	Cutscene_SetAttr(i, CGI_X, x);
	Cutscene_SetAttr(i, CGI_Y, y);
	Cutscene_SetAttr(i, CGI_GFX, tile);
	Cutscene_SetAttr(i, CGI_TILEWIDTH, blockw);
	Cutscene_SetAttr(i, CGI_TILEHEIGHT, blockh);
	Cutscene_SetAttr(i, CGI_CLR, cset);
	Cutscene_SetAttr(i, CGI_WIDTH, xscale);
	Cutscene_SetAttr(i, CGI_HEIGHT, yscale);
	Cutscene_SetAttr(i, CGI_ROTX, rx);
	Cutscene_SetAttr(i, CGI_ROTY, ry);
	Cutscene_SetAttr(i, CGI_ROT, rangle);
	Cutscene_SetAttr(i, CGI_MISC1, flip);
	Cutscene_SetAttr(i, CGI_MISC2, Cond(transparency, 1, 0));
	Cutscene_SetAttr(i, CGI_OPACITY, opacity);
	
	Cutscene_SetAttr(i, CGI_DRAWLIFESPAN, 1);
	
	//cutsceneG[CG_NUMDRAWS] = Min(cutsceneG[CG_NUMDRAWS]+1, CUTSCENE_MAX_DRAWS-1);
	return i;
}

// /**
// * Optimized and simpler version of DrawTile()
// * Draws a single tile on the current screen much in the same way as DrawTile().
// * See DrawTile() for an explanation on what these arguments do.
// */
int Cutscene_NewFastTile(int layer, int x, int y, int tile, int cset, int opacity){
	int i = __Cutscene_FindUnusedIndex(); //cutsceneG[CG_NUMDRAWS];
	
	Cutscene_SetAttr(i, CGI_DRAWTYPE, CGDT_FASTTILE);
	Cutscene_SetAttr(i, CGI_LAYER, layer);
	Cutscene_SetAttr(i, CGI_X, x);
	Cutscene_SetAttr(i, CGI_Y, y);
	Cutscene_SetAttr(i, CGI_GFX, tile);
	Cutscene_SetAttr(i, CGI_CLR, cset);
	Cutscene_SetAttr(i, CGI_OPACITY, opacity);
	
	Cutscene_SetAttr(i, CGI_DRAWLIFESPAN, 1);
	
	//cutsceneG[CG_NUMDRAWS] = Min(cutsceneG[CG_NUMDRAWS]+1, CUTSCENE_MAX_DRAWS-1);
	return i;
}

// /**
// * Draws a combo on the specified layer of the current screen,
// * starting at (x,y), using the specified cset.
// * Starting with the specified tile referenced by the combo,
// * this method copies a block of size
// * blockh x blockw from the tile sheet to the screen. This method's
// * behavior is undefined unless 1 <= blockh, blockw <= 20.
// * Scale specifies the actual size in pixels! So scale 1 would mean it is
// * only one pixel in size. To use the default sizes of block w,h you must
// * set xscale and yscale to -1. These values are not independant of one another,
// * so you cannot set xscale and leave yscale at -1.
// * rx, ry : works now :
// * rangle performs a rotation clockwise using an angle of rangle degrees.
// * Flip specifies how the tiles should be flipped when drawn:
// * 0: No flip
// * 1: Horizontal flip
// * 2: Vertical flip
// * 3: Both (180 degree rotation)
// * If transparency is true, the tiles' transparent regions will be
// * respected.
// * Opacity controls how transparent the solid portions of the tiles will
// * be. Values other than OP_OPAQUE and OP_TRANS are currently undefined.
// */
int Cutscene_NewCombo(int layer, int x, int y, int tile, int blockw, int blockh, int cset, int xscale, int yscale, int rx, int ry, int rangle, int frame, int flip, bool transparency, int opacity){
	int i = __Cutscene_FindUnusedIndex(); //cutsceneG[CG_NUMDRAWS];
	
	Cutscene_SetAttr(i, CGI_DRAWTYPE, CGDT_COMBO);
	Cutscene_SetAttr(i, CGI_LAYER, layer);
	Cutscene_SetAttr(i, CGI_X, x);
	Cutscene_SetAttr(i, CGI_Y, y);
	Cutscene_SetAttr(i, CGI_GFX, tile);
	Cutscene_SetAttr(i, CGI_TILEWIDTH, blockw);
	Cutscene_SetAttr(i, CGI_TILEHEIGHT, blockh);
	Cutscene_SetAttr(i, CGI_CLR, cset);
	Cutscene_SetAttr(i, CGI_WIDTH, xscale);
	Cutscene_SetAttr(i, CGI_HEIGHT, yscale);
	Cutscene_SetAttr(i, CGI_ROTX, rx);
	Cutscene_SetAttr(i, CGI_ROTY, ry);
	Cutscene_SetAttr(i, CGI_ROT, rangle);
	Cutscene_SetAttr(i, CGI_MISC1, frame);
	Cutscene_SetAttr(i, CGI_MISC2, flip);
	Cutscene_SetAttr(i, CGI_MISC3, Cond(transparency, 1, 0));
	Cutscene_SetAttr(i, CGI_OPACITY, opacity);
	
	Cutscene_SetAttr(i, CGI_DRAWLIFESPAN, 1);
	
	//cutsceneG[CG_NUMDRAWS] = Min(cutsceneG[CG_NUMDRAWS]+1, CUTSCENE_MAX_DRAWS-1);
	return i;
}

// /**
// * Optimized and simpler version of DrawCombo()
// * Draws a single combo on the current screen much in the same way as DrawCombo().
// * See DrawCombo() for an explanation on what these arguments do.
// */
int Cutscene_NewFastCombo(int layer, int x, int y, int cmb, int cset, int opacity){
	int i = __Cutscene_FindUnusedIndex(); //cutsceneG[CG_NUMDRAWS];
	
	Cutscene_SetAttr(i, CGI_DRAWTYPE, CGDT_FASTCOMBO);
	Cutscene_SetAttr(i, CGI_LAYER, layer);
	Cutscene_SetAttr(i, CGI_X, x);
	Cutscene_SetAttr(i, CGI_Y, y);
	Cutscene_SetAttr(i, CGI_GFX, cmb);
	Cutscene_SetAttr(i, CGI_CLR, cset);
	Cutscene_SetAttr(i, CGI_OPACITY, opacity);
	
	Cutscene_SetAttr(i, CGI_DRAWLIFESPAN, 1);
	
	//cutsceneG[CG_NUMDRAWS] = Min(cutsceneG[CG_NUMDRAWS]+1, CUTSCENE_MAX_DRAWS-1);
	return i;
}

// /**
// * Draws a quad on the specified layer with the corners x1,y1 through x4,y4.
// * Corners are drawn in a counterclockwise order starting from x1,y1. ( So
// * if you draw a "square" for example starting from the bottom-right corner
// * instead of the usual top-left, the the image will be textured onto the
// * quad so it appears upside-down. -yes, these are rotatable. )
// * From there a single or block of tiles or combos is then texture mapped
// * onto the quad using the arguments w, h, cset, flip, and render_mode.
// * A positive vale in texture will draw the image from the tilesheet pages,
// * whereas a negative value will be drawn from the combo page. 0 will draw combo number 0.
// * Both w and h are undefined unless 1 <= blockh, blockw <= 16, and it is a power of
// * two. ie: 1, 2 are acceptable, but 2, 15 are not.

// * Flip specifies how the tiles/combos should be flipped when drawn:
// * 0: No flip
// * 1: Horizontal flip
// * 2: Vertical flip
// * 3: Both (180 degree rotation)
// *** See std.zh for a list of all available render_mode arguments.
// */
int Cutscene_NewQuad(int layer, int x, int y, int x2, int y2, int x3, int y3, int x4, int y4, int w, int h, int cset, int flip, int texture,  int render_mode){
	int i = __Cutscene_FindUnusedIndex(); //cutsceneG[CG_NUMDRAWS];
	
	Cutscene_SetAttr(i, CGI_DRAWTYPE, CGDT_QUAD);
	Cutscene_SetAttr(i, CGI_LAYER, layer);
	Cutscene_SetAttr(i, CGI_X, x);
	Cutscene_SetAttr(i, CGI_Y, y);
	Cutscene_SetAttr(i, CGI_X2, x2);
	Cutscene_SetAttr(i, CGI_Y2, y2);
	Cutscene_SetAttr(i, CGI_X3, x3);
	Cutscene_SetAttr(i, CGI_Y3, y3);
	Cutscene_SetAttr(i, CGI_X4, x4);
	Cutscene_SetAttr(i, CGI_Y4, y4);
	Cutscene_SetAttr(i, CGI_WIDTH, w);
	Cutscene_SetAttr(i, CGI_HEIGHT, h);
	Cutscene_SetAttr(i, CGI_GFX, texture);
	Cutscene_SetAttr(i, CGI_CLR, cset);
	Cutscene_SetAttr(i, CGI_MISC1, flip);
	Cutscene_SetAttr(i, CGI_MISC2, render_mode);
	
	Cutscene_SetAttr(i, CGI_DRAWLIFESPAN, 1);
	
	//cutsceneG[CG_NUMDRAWS] = Min(cutsceneG[CG_NUMDRAWS]+1, CUTSCENE_MAX_DRAWS-1);
	return i;
}

// /**
// * Draws a triangle on the specified layer with the corners x1,y1 through x4,y4.
// * Corners are drawn in a counterclockwise order starting from x1,y1.
// * From there a single or block of tiles or combos is then texture mapped
// * onto the triangle using the arguments w, h, cset, flip, and render_mode.
// * A positive vale in texture will draw the image from the tilesheet pages,
// * whereas a negative value will be drawn from the combo page. 0 will draw combo number 0.
// * Both w and h are undefined unless 1 <= blockh, blockw <= 16, and it is a power of
// * two. ie: 1, 2 are acceptable, but 2, 15 are not.
// * Flip specifies how the tiles/combos should be flipped when drawn:
// * 0: No flip
// * 1: Horizontal flip
// * 2: Vertical flip
// * 3: Both (180 degree rotation)
// *** See std.zh for a list of all available render_mode arguments.
// */
int Cutscene_NewTriangle(int layer, int x, int y, int x2, int y2, int x3, int y3, int w, int h, int cset, int flip, int texture,  int render_mode){
	int i = __Cutscene_FindUnusedIndex(); //cutsceneG[CG_NUMDRAWS];
	
	Cutscene_SetAttr(i, CGI_DRAWTYPE, CGDT_TRIANGLE);
	Cutscene_SetAttr(i, CGI_LAYER, layer);
	Cutscene_SetAttr(i, CGI_X, x);
	Cutscene_SetAttr(i, CGI_Y, y);
	Cutscene_SetAttr(i, CGI_X2, x2);
	Cutscene_SetAttr(i, CGI_Y2, y2);
	Cutscene_SetAttr(i, CGI_X3, x3);
	Cutscene_SetAttr(i, CGI_Y3, y3);
	Cutscene_SetAttr(i, CGI_WIDTH, w);
	Cutscene_SetAttr(i, CGI_HEIGHT, h);
	Cutscene_SetAttr(i, CGI_GFX, texture);
	Cutscene_SetAttr(i, CGI_CLR, cset);
	Cutscene_SetAttr(i, CGI_MISC1, flip);
	Cutscene_SetAttr(i, CGI_MISC2, render_mode);
	
	Cutscene_SetAttr(i, CGI_DRAWLIFESPAN, 1);
	
	//cutsceneG[CG_NUMDRAWS] = Min(cutsceneG[CG_NUMDRAWS]+1, CUTSCENE_MAX_DRAWS-1);
	return i;
}

// /**
// * Draws a source rect from off-screen Bitmap with id of bitmap_id onto
// * an area of the screen described by dest rect at the given layer.
// * *Example:
// * Screen->Bitmap( 6, myBitmapId, 0, 0, 16, 16, 79, 57, 32, 32, 0, true );
// * //Would draw a 16x16 area starting at the upper-left corner of source bmp to
// * //layer 6 of the current screen at coordinates 79,57 with a width and height of 32.
// ***Note* Script drawing functions are enqueued and executed in a frame-by-frame basis 
// based on the order of which layer they need to be drawn to. Drawing to or from
// seperate render tagets or bitmaps is no exception! So keep in mind in order to 
// eliminate unwanted drawing orders or bugs.
// */
int Cutscene_NewBitmap(int layer, int bitmap_id, int source_x, int source_y, int source_w, int source_h, int dest_x, int dest_y, int dest_w, int dest_h, int rotation, bool mask){
	int i = __Cutscene_FindUnusedIndex(); //cutsceneG[CG_NUMDRAWS];
	
	Cutscene_SetAttr(i, CGI_DRAWTYPE, CGDT_BITMAP);
	Cutscene_SetAttr(i, CGI_LAYER, layer);
	Cutscene_SetAttr(i, CGI_MISC1, bitmap_id);
	Cutscene_SetAttr(i, CGI_X, dest_x);
	Cutscene_SetAttr(i, CGI_Y, dest_y);
	Cutscene_SetAttr(i, CGI_WIDTH, dest_w);
	Cutscene_SetAttr(i, CGI_HEIGHT, dest_h);
	Cutscene_SetAttr(i, CGI_X2, source_x);
	Cutscene_SetAttr(i, CGI_Y2, source_y);
	Cutscene_SetAttr(i, CGI_MISC2, source_w);
	Cutscene_SetAttr(i, CGI_MISC3, source_h);
	Cutscene_SetAttr(i, CGI_ROT, rotation);
	Cutscene_SetAttr(i, CGI_MISC4, Cond(mask, 1, 0));
	
	Cutscene_SetAttr(i, CGI_DRAWLIFESPAN, 1);
	
	//cutsceneG[CG_NUMDRAWS] = Min(cutsceneG[CG_NUMDRAWS]+1, CUTSCENE_MAX_DRAWS-1);
	return i;
}

// /**
// * Draws an entire Layer from source_screen on source_map on the specified layer of the current screen at (x,y).
// * If rotation is not zero, it(the entire layer) will rotate about its center.
// * Opacity controls how transparent the solid portions of the tiles will
// * be. Values other than OP_OPAQUE and OP_TRANS are currently
// * undefined.
// */
int Cutscene_NewLayer(int layer, int source_map, int source_screen, int source_layer, int x, int y, int rotation, int opacity){
	int i = __Cutscene_FindUnusedIndex(); //cutsceneG[CG_NUMDRAWS];
	
	Cutscene_SetAttr(i, CGI_DRAWTYPE, CGDT_LAYER);
	Cutscene_SetAttr(i, CGI_LAYER, layer);
	Cutscene_SetAttr(i, CGI_X, x);
	Cutscene_SetAttr(i, CGI_Y, y);
	Cutscene_SetAttr(i, CGI_MISC1, source_map);
	Cutscene_SetAttr(i, CGI_MISC2, source_screen);
	Cutscene_SetAttr(i, CGI_MISC3, source_layer);
	Cutscene_SetAttr(i, CGI_ROT, rotation);
	Cutscene_SetAttr(i, CGI_OPACITY, opacity);
	
	Cutscene_SetAttr(i, CGI_DRAWLIFESPAN, 1);
	
	//cutsceneG[CG_NUMDRAWS] = Min(cutsceneG[CG_NUMDRAWS]+1, CUTSCENE_MAX_DRAWS-1);
	return i;
}

// /**
// * Draws an entire screen from screen on map on the specified layer of the current screen at (x,y).
// * If rotation is not zero, it(the entire screen) will rotate about its center.
// */
int Cutscene_NewScreen(int layer, int source_map, int source_screen, int x, int y, int rotation){
	int i = __Cutscene_FindUnusedIndex(); //cutsceneG[CG_NUMDRAWS];
	
	Cutscene_SetAttr(i, CGI_DRAWTYPE, CGDT_SCREEN);
	Cutscene_SetAttr(i, CGI_LAYER, layer);
	Cutscene_SetAttr(i, CGI_X, x);
	Cutscene_SetAttr(i, CGI_Y, y);
	Cutscene_SetAttr(i, CGI_MISC1, source_map);
	Cutscene_SetAttr(i, CGI_MISC2, source_screen);
	Cutscene_SetAttr(i, CGI_ROT, rotation);
	
	Cutscene_SetAttr(i, CGI_DRAWLIFESPAN, 1);
	
	//cutsceneG[CG_NUMDRAWS] = Min(cutsceneG[CG_NUMDRAWS]+1, CUTSCENE_MAX_DRAWS-1);
	return i;
}

//Works just like Cutscene_NewCombo, but sets the 4-way flag and treats the combo as the first of an 8 combo set that change as it moves
//Combos 0-3: The NPC standing still, up, down, left, right
//Combos 4-7: The NPC walking, up, down, left, right
int Cutscene_NewNPC(int layer, int x, int y, int cmb, int cset, int opacity){
	int i = __Cutscene_FindUnusedIndex(); //cutsceneG[CG_NUMDRAWS];
	
	Cutscene_SetAttr(i, CGI_DRAWTYPE, CGDT_NPC);
	Cutscene_SetAttr(i, CGI_LAYER, layer);
	Cutscene_SetAttr(i, CGI_X, x);
	Cutscene_SetAttr(i, CGI_Y, y);
	Cutscene_SetAttr(i, CGI_GFX, cmb);
	Cutscene_SetAttr(i, CGI_CLR, cset);
	Cutscene_SetAttr(i, CGI_OPACITY, opacity);
	Cutscene_SetAttr(i, CGI_DIR, -1);
	Cutscene_SetAttr(i, CGI_MOVEANGLE, 90);
	Cutscene_SetAttr(i, CGI_MISC1, cmb);
	Cutscene_SetAttr(i, CGI_FLAGS, CGF_4WAY);
	
	Cutscene_SetAttr(i, CGI_DRAWLIFESPAN, -1);
	
	//cutsceneG[CG_NUMDRAWS] = Min(cutsceneG[CG_NUMDRAWS]+1, CUTSCENE_MAX_DRAWS-1);
	return i;
}
int Cutscene_NewNPC(int layer, int x, int y, int cmb, int cset, int opacity, int dir){
	int i = __Cutscene_FindUnusedIndex(); //cutsceneG[CG_NUMDRAWS];
	
	Cutscene_SetAttr(i, CGI_DRAWTYPE, CGDT_NPC);
	Cutscene_SetAttr(i, CGI_LAYER, layer);
	Cutscene_SetAttr(i, CGI_X, x);
	Cutscene_SetAttr(i, CGI_Y, y);
	Cutscene_SetAttr(i, CGI_GFX, cmb);
	Cutscene_SetAttr(i, CGI_CLR, cset);
	Cutscene_SetAttr(i, CGI_OPACITY, opacity);
	Cutscene_SetAttr(i, CGI_DIR, dir);
	Cutscene_SetAttr(i, CGI_MOVEANGLE, 90);
	Cutscene_SetAttr(i, CGI_MISC1, cmb);
	Cutscene_SetAttr(i, CGI_FLAGS, CGF_4WAY);
	
	Cutscene_SetAttr(i, CGI_DRAWLIFESPAN, -1);
	
	//cutsceneG[CG_NUMDRAWS] = Min(cutsceneG[CG_NUMDRAWS]+1, CUTSCENE_MAX_DRAWS-1);
	return i;
}

//Works like DrawTile, but with a number of frames and animation speed. Will animate until finished, then die. 
//Unlike other draws, this persists for more than one frame by default.
int Cutscene_NewAnim(int layer, int x, int y, int tile, int blockw, int blockh, int cset, int xscale, int yscale, int rx, int ry, int rangle, int flip, bool transparency, int opacity, int frames, int aspeed){
	int i = __Cutscene_FindUnusedIndex(); //cutsceneG[CG_NUMDRAWS];
	
	Cutscene_SetAttr(i, CGI_DRAWTYPE, CGDT_ANIM);
	Cutscene_SetAttr(i, CGI_LAYER, layer);
	Cutscene_SetAttr(i, CGI_X, x);
	Cutscene_SetAttr(i, CGI_Y, y);
	Cutscene_SetAttr(i, CGI_GFX, tile);
	Cutscene_SetAttr(i, CGI_TILEWIDTH, blockw);
	Cutscene_SetAttr(i, CGI_TILEHEIGHT, blockh);
	Cutscene_SetAttr(i, CGI_CLR, cset);
	Cutscene_SetAttr(i, CGI_WIDTH, xscale);
	Cutscene_SetAttr(i, CGI_HEIGHT, yscale);
	Cutscene_SetAttr(i, CGI_ROTX, rx);
	Cutscene_SetAttr(i, CGI_ROTY, ry);
	Cutscene_SetAttr(i, CGI_ROT, rangle);
	Cutscene_SetAttr(i, CGI_MISC1, flip);
	Cutscene_SetAttr(i, CGI_MISC2, Cond(transparency, 1, 0));
	Cutscene_SetAttr(i, CGI_OPACITY, opacity);
	Cutscene_SetAttr(i, CGI_MISC3, frames);
	Cutscene_SetAttr(i, CGI_MISC4, aspeed);
	Cutscene_SetAttr(i, CGI_MISC5, 0);
	
	Cutscene_SetAttr(i, CGI_DRAWLIFESPAN, -1);
	
	//cutsceneG[CG_NUMDRAWS] = Min(cutsceneG[CG_NUMDRAWS]+1, CUTSCENE_MAX_DRAWS-1);
	return i;
}

int Cutscene_NewBlit(int layer, bitmap b, int x, int y, int w, int h, int x2, int y2, int w2, int h2, int spec){
	int i = __Cutscene_FindUnusedIndex(); //cutsceneG[CG_NUMDRAWS];
	
	Cutscene_SetAttr(i, CGI_DRAWTYPE, CGDT_BLIT);
	Cutscene_SetAttr(i, CGI_LAYER, layer);
	Cutscene_SetAttr(i, CGI_X, x2);
	Cutscene_SetAttr(i, CGI_Y, y2);
	Cutscene_SetAttr(i, CGI_X2, x);
	Cutscene_SetAttr(i, CGI_Y2, y);
	Cutscene_SetAttr(i, CGI_X3, w);
	Cutscene_SetAttr(i, CGI_Y3, h);
	Cutscene_SetAttr(i, CGI_X4, w2);
	Cutscene_SetAttr(i, CGI_Y4, h2);
	Cutscene_SetAttr(i, CGI_MISC1, <untyped>b);
	Cutscene_SetAttr(i, CGI_MISC2, spec);
	
	Cutscene_SetAttr(i, CGI_DRAWLIFESPAN, 1);
	
	//cutsceneG[CG_NUMDRAWS] = Min(cutsceneG[CG_NUMDRAWS]+1, CUTSCENE_MAX_DRAWS-1);
	return i;
}

//Get the distance between two points, divided up by divisor. This avoids causing problems 
//with the Distance function doing calculations that go over the max constant
int Cutscene_LargeDistance(int x1, int y1, int x2, int y2, int divisor){
	int cx = x1+(x2-x1)/divisor;
	int cy = y1+(y2-y1)/divisor;
	return Distance(x1, y1, cx, cy)*divisor;
}

//Gets the X,Y position of a draw relative to the camera
int Cutscene_GetDrawRelativeX(int index){
	return cutsceneG[CUTSCENE_GLOBAL_INDICES+CUTSCENE_DRAW_INDICES*index+CGI_X]-cutsceneG[CG_CAMX];
}
int Cutscene_GetDrawRelativeY(int index){
	return cutsceneG[CUTSCENE_GLOBAL_INDICES+CUTSCENE_DRAW_INDICES*index+CGI_Y]-cutsceneG[CG_CAMY];
}


//Set the position of a draw basd on an X and Y position within a screen
void Cutscene_SetDrawPosition(int index, int scrn, int drawX, int drawY){
	int x = (scrn%16)*256+drawX-cutsceneG[CG_CAMANCHORX];
	int y = Floor(scrn/16)*176+drawY-cutsceneG[CG_CAMANCHORY];
	int deltaX = x-Cutscene_GetAttr(index, CGI_X);
	int deltaY = y-Cutscene_GetAttr(index, CGI_Y);
	Cutscene_SetAttr(index, CGI_X, x);
	Cutscene_SetAttr(index, CGI_Y, y);
	
	Cutscene_AddAttr(index, CGI_ROTX, deltaX);
	Cutscene_AddAttr(index, CGI_ROTY, deltaY);
}

//Set the position of a draw basd on an X and Y position relative to the anchor point
void Cutscene_SetDrawPosition(int index, int x, int y){
	int deltaX = x-Cutscene_GetAttr(index, CGI_X);
	int deltaY = y-Cutscene_GetAttr(index, CGI_Y);
	Cutscene_SetAttr(index, CGI_X, x);
	Cutscene_SetAttr(index, CGI_Y, y);
	
	Cutscene_AddAttr(index, CGI_ROTX, deltaX);
	Cutscene_AddAttr(index, CGI_ROTY, deltaY);
}
void Cutscene_AddDrawPosition(int index, int x, int y){
	Cutscene_AddAttr(index, CGI_X, x);
	Cutscene_AddAttr(index, CGI_Y, y);
	
	Cutscene_AddAttr(index, CGI_ROTX, x);
	Cutscene_AddAttr(index, CGI_ROTY, y);
}


//Set the position of a draw basd on an X and Y position within a screen
void Cutscene_SetDrawPositionRelative(int index, int index2, int xOff, int yOff){
	int x = Cutscene_GetAttr(index2, CGI_X)+xOff;
	int y = Cutscene_GetAttr(index2, CGI_Y)+yOff;
	int deltaX = x-Cutscene_GetAttr(index, CGI_X);
	int deltaY = y-Cutscene_GetAttr(index, CGI_Y);
	Cutscene_SetAttr(index, CGI_X, x);
	Cutscene_SetAttr(index, CGI_Y, y);
	
	Cutscene_AddAttr(index, CGI_ROTX, deltaX);
	Cutscene_AddAttr(index, CGI_ROTY, deltaY);
}

//Sets a draw's graphic and cset
void Cutscene_SetDrawGraphic(int index, int gfx, int cset){
	Cutscene_SetAttr(index, CGI_GFX, gfx);
	Cutscene_SetAttr(index, CGI_CLR, cset);
}

//Sets an npc's starting combo
void Cutscene_SetNPCGraphic(int index, int gfx){
	Cutscene_SetAttr(index, CGI_GFX, gfx);
	Cutscene_SetAttr(index, CGI_MISC1, gfx);
}

//Sets an npc's starting combo
void Cutscene_SetNPCGraphic(int index, int gfx, bool noStarting){
	if(gfx<0){
		Cutscene_SetAttr(index, CGI_GFX, Cutscene_GetAttr(index, CGI_MISC1));
		return;
	}
	else
		Cutscene_SetAttr(index, CGI_GFX, gfx);
	if(!noStarting)
		Cutscene_SetAttr(index, CGI_MISC1, gfx);
}

//Sets a draw's graphic and cset, also swaps combo and cset draws
void Cutscene_SetDrawGraphicAndSwapType(int index, int gfx, int cset){
	int dt = Cutscene_GetAttr(index, CGI_DRAWTYPE);
	if(dt==CGDT_COMBO)
		dt = CGDT_TILE;
	else if(dt==CGDT_TILE)
		dt = CGDT_COMBO;
	else if(dt==CGDT_FASTCOMBO)
		dt = CGDT_FASTTILE;
	else if(dt==CGDT_FASTTILE)
		dt = CGDT_FASTCOMBO;
	
	if(dt==CGDT_COMBO){
		Cutscene_SetAttr(index, CGI_MISC1, -1);
		Cutscene_SetAttr(index, CGI_MISC2, Cutscene_GetAttr(index, CGI_MISC1));
	}
	else if(dt==CGDT_TILE){
		Cutscene_SetAttr(index, CGI_MISC1, Cutscene_GetAttr(index, CGI_MISC2));
		Cutscene_SetAttr(index, CGI_MISC2, 0);
	}
	Cutscene_SetAttr(index, CGI_DRAWTYPE, dt);
	Cutscene_SetAttr(index, CGI_GFX, gfx);
	Cutscene_SetAttr(index, CGI_CLR, cset);
}

//Set the movement step and angle for a draw
void Cutscene_SetDrawMovement(int index, int step, int angle){
	Cutscene_SetAttr(index, CGI_MOVESTEP, step);
	Cutscene_SetAttr(index, CGI_MOVEANGLE, angle);
	Cutscene_SetAttr(index, CGI_TX, 0);
	Cutscene_SetAttr(index, CGI_TY, 0);
}

//Set a parent draw that the draw is attached to
void Cutscene_SetDrawParent(int index, int parent){
	int xOff = Cutscene_GetAttr(index, CGI_X)-Cutscene_GetAttr(parent, CGI_X);
	int yOff = Cutscene_GetAttr(index, CGI_Y)-Cutscene_GetAttr(parent, CGI_Y);
	Cutscene_SetAttr(index, CGI_PARENT, parent);
	Cutscene_SetAttr(index, CGI_PARENTOFFX, xOff);
	Cutscene_SetAttr(index, CGI_PARENTOFFY, yOff);
}
void Cutscene_SetDrawParent(int index, int parent, int xOff, int yOff){
	Cutscene_SetAttr(index, CGI_PARENT, parent);
	Cutscene_SetAttr(index, CGI_PARENTOFFX, xOff);
	Cutscene_SetAttr(index, CGI_PARENTOFFY, yOff);
}

//Unset a parent from a draw
void Cutscene_UnsetDrawParent(int index){
	Cutscene_SetAttr(index, CGI_PARENT, -1);
	Cutscene_SetAttr(index, CGI_PARENTOFFX, 0);
	Cutscene_SetAttr(index, CGI_PARENTOFFY, 0);
}

//Glide a draw towards a new X and Y position within a screen
void Cutscene_Glide(int index, int newScrn, int tX, int tY, int step){
	cutsceneG[CG_NUMGLIDING]++;
	int x = (newScrn%16)*256+tX-cutsceneG[CG_CAMANCHORX];
	int y = Floor(newScrn/16)*176+tY-cutsceneG[CG_CAMANCHORY];
	if(newScrn==-1){
		x = tX; //-cutsceneG[CG_CAMANCHORX];
		y = tY; //-cutsceneG[CG_CAMANCHORY];
	}
	Cutscene_SetAttr(index, CGI_TX, x);
	Cutscene_SetAttr(index, CGI_TY, y);
	Cutscene_SetAttr(index, CGI_MOVEANGLE, Angle(Cutscene_GetAttr(index, CGI_X), Cutscene_GetAttr(index, CGI_Y), x, y));
	Cutscene_SetAttr(index, CGI_MOVESTEP, step);
	Cutscene_SetAttr(index, CGI_ACCELSTEP, 0);
}
void Cutscene_GlideRelative(int index, int newScrn, int tX, int tY, int step){
	Cutscene_Glide(index, newScrn, CutX(index)+tX, CutY(index)+tY, step);
}
void Cutscene_GlideTimed(int index, int newScrn, int tX, int tY, int time){
	cutsceneG[CG_NUMGLIDING]++;
	int x = (newScrn%16)*256+tX-cutsceneG[CG_CAMANCHORX];
	int y = Floor(newScrn/16)*176+tY-cutsceneG[CG_CAMANCHORY];
	int step = Distance(Cutscene_GetAttr(index, CGI_X), Cutscene_GetAttr(index, CGI_Y), x, y)/time;
	Cutscene_SetAttr(index, CGI_TX, x);
	Cutscene_SetAttr(index, CGI_TY, y);
	Cutscene_SetAttr(index, CGI_MOVEANGLE, Angle(Cutscene_GetAttr(index, CGI_X), Cutscene_GetAttr(index, CGI_Y), x, y));
	Cutscene_SetAttr(index, CGI_MOVESTEP, step);
	Cutscene_SetAttr(index, CGI_ACCELSTEP, 0);
}

//Glide a draw towards a new X and Y position within a screen
void Cutscene_GlideAccel(int index, int newScrn, int tX, int tY, int step, int step2){
	cutsceneG[CG_NUMGLIDING]++;
	int x = (newScrn%16)*256+tX-cutsceneG[CG_CAMANCHORX];
	int y = Floor(newScrn/16)*176+tY-cutsceneG[CG_CAMANCHORY];
	if(newScrn==-1){
		x = tX; //-cutsceneG[CG_CAMANCHORX];
		y = tY; //-cutsceneG[CG_CAMANCHORY];
	}
	Cutscene_SetAttr(index, CGI_TX, x);
	Cutscene_SetAttr(index, CGI_TY, y);
	Cutscene_SetAttr(index, CGI_MOVEANGLE, Angle(Cutscene_GetAttr(index, CGI_X), Cutscene_GetAttr(index, CGI_Y), x, y));
	Cutscene_SetAttr(index, CGI_MOVESTEP, Max(0.0001, step2));
	Cutscene_SetAttr(index, CGI_ACCELSTEP, Max(0.0001, step));
	Cutscene_SetAttr(index, CGI_TARGETDIST, Cutscene_LargeDistance(Cutscene_GetAttr(index, CGI_X), Cutscene_GetAttr(index, CGI_Y), Cutscene_GetAttr(index, CGI_TX), Cutscene_GetAttr(index, CGI_TY), 10));
}
void Cutscene_GlideRelativeAccel(int index, int newScrn, int tX, int tY, int step, int step2){
	Cutscene_GlideAccel(index, newScrn, CutX(index)+tX, CutY(index)+tY, step, step2);
}

//Check if a draw has finished gliding into position
bool Cutscene_FinishedGlide(int index){
	if(Cutscene_GetAttr(index, CGI_TX)==0&&Cutscene_GetAttr(index, CGI_TY)==0)
		return true;
	return false;
}

bool Cutscene_JustFinishedGlide(int index){
	if(Cutscene_HasFlag(index, CGF_GLIDESUCCESS))
		return true;
	return false;
}

//Same as above, but with 2, 3, or 4 arguments for different draws
bool Cutscene_FinishedGlide(int index, int index2){
	if(Cutscene_GetAttr(index, CGI_TX)==0&&Cutscene_GetAttr(index, CGI_TY)==0&&
		Cutscene_GetAttr(index2, CGI_TX)==0&&Cutscene_GetAttr(index2, CGI_TY)==0)
		return true;
	return false;
}
bool Cutscene_FinishedGlide(int index, int index2, int index3){
	if(Cutscene_GetAttr(index, CGI_TX)==0&&Cutscene_GetAttr(index, CGI_TY)==0&&
		Cutscene_GetAttr(index2, CGI_TX)==0&&Cutscene_GetAttr(index2, CGI_TY)==0&&
		Cutscene_GetAttr(index3, CGI_TX)==0&&Cutscene_GetAttr(index3, CGI_TY)==0)
		return true;
	return false;
}
bool Cutscene_FinishedGlide(int index, int index2, int index3, int index4){
	if(Cutscene_GetAttr(index, CGI_TX)==0&&Cutscene_GetAttr(index, CGI_TY)==0&&
		Cutscene_GetAttr(index2, CGI_TX)==0&&Cutscene_GetAttr(index2, CGI_TY)==0&&
		Cutscene_GetAttr(index3, CGI_TX)==0&&Cutscene_GetAttr(index3, CGI_TY)==0&&
		Cutscene_GetAttr(index4, CGI_TX)==0&&Cutscene_GetAttr(index4, CGI_TY)==0)
		return true;
	return false;
}

//Set the camera to center on a draw as it moves
void Cutscene_SetCameraTracking(int index, int step, int trackRadius){
	cutsceneG[CG_CAMFOLLOWTARGET] = index;
	cutsceneG[CG_CAMFOLLOWRANGE] = trackRadius;
	cutsceneG[CG_CAMSTEP] = step;
}

//Set the camera to move towards a target X and Y position
void Cutscene_SetCameraTarget(int tX, int tY, int step){
	cutsceneG[CG_CAMFOLLOWTARGET] = -1;
	cutsceneG[CG_CAMTX] = tX;
	cutsceneG[CG_CAMTY] = tY;
	cutsceneG[CG_CAMSTEP] = step;
}

//Set the camera to move towards a target screen
void Cutscene_SetCameraTarget(int scrn, int step){
	int tX = (scrn%16)*256-cutsceneG[CG_CAMANCHORX];
	int tY = Floor(scrn/16)*176-cutsceneG[CG_CAMANCHORY];
	Cutscene_SetCameraTarget(tX, tY, step);
}

//Set the camera to move towards a target X and Y position over a period of time
void Cutscene_SetCameraTargetTimed(int tX, int tY, int time){
	cutsceneG[CG_CAMFOLLOWTARGET] = -1;
	cutsceneG[CG_CAMTX] = tX;
	cutsceneG[CG_CAMTY] = tY;
	cutsceneG[CG_CAMSTEP] = Cutscene_LargeDistance(cutsceneG[CG_CAMX], cutsceneG[CG_CAMY], tX, tY, 10)/time;
}

//Set the camera to move towards a target screen over a period of time
void Cutscene_SetCameraTargetTimed(int scrn, int time){
	int tX = (scrn%16)*256-cutsceneG[CG_CAMANCHORX];
	int tY = Floor(scrn/16)*176-cutsceneG[CG_CAMANCHORY];
	Cutscene_SetCameraTargetTimed(tX, tY, time);
}

//Check if the camera has finished moving
bool Cutscene_CameraFinishedMoving(){
	if(cutsceneG[CG_CAMSTEP]<=0)
		return true;
	if(cutsceneG[CG_CAMFOLLOWTARGET]>-1){
		int tX = Cutscene_GetAttr(cutsceneG[CG_CAMFOLLOWTARGET], CGI_X)-120;
		int tY = Cutscene_GetAttr(cutsceneG[CG_CAMFOLLOWTARGET], CGI_Y)-80;
		int dist = Cutscene_LargeDistance(cutsceneG[CG_CAMX], cutsceneG[CG_CAMY], tX, tY, 10);
		if(dist<=cutsceneG[CG_CAMFOLLOWRANGE])
			return true;
	}
	return false;
}

//Set the camera zoom
void Cutscene_SetCameraZoom(int x, int y, int zoom){
	cutsceneG[CG_ZOOMCX] = x;
	cutsceneG[CG_ZOOMCY] = y;
	cutsceneG[CG_ZOOMAMOUNT] = Clamp(zoom, 0, 256);
	if(zoom==0)
		cutsceneG[CG_ZOOMMAXAMOUNT] = 256;
}

//Set the camera zoom, and adjust the max zoom for added precision
void Cutscene_SetCameraZoom(int x, int y, int zoom, int maxZoom){
	cutsceneG[CG_ZOOMCX] = x;
	cutsceneG[CG_ZOOMCY] = y;
	cutsceneG[CG_ZOOMAMOUNT] = Clamp(zoom, 0, 256);
	cutsceneG[CG_ZOOMMAXAMOUNT] = Clamp(maxZoom, 0, 256);
	if(zoom==0)
		cutsceneG[CG_ZOOMMAXAMOUNT] = 256;
}

//Wait for a draw to glide into position
void Cutscene_Waitglide(int index){
	while(!Cutscene_FinishedGlide(index)){
		Cutscene_Waitframe();
	}
}

//Same as above, but with 2, 3, or 4 arguments for different draws
void Cutscene_Waitglide(int index, int index2){
	while(!Cutscene_FinishedGlide(index, index2)){
		Cutscene_Waitframe();
	}
}
void Cutscene_Waitglide(int index, int index2, int index3){
	while(!Cutscene_FinishedGlide(index, index2, index3)){
		Cutscene_Waitframe();
	}
}
void Cutscene_Waitglide(int index, int index2, int index3, int index4){
	while(!Cutscene_FinishedGlide(index, index2, index3, index4)){
		Cutscene_Waitframe();
	}
}

//Wait for all draws to glide into position
void Cutscene_Waitglide(){
	while(cutsceneG[CG_NUMGLIDING]>0){
		Cutscene_Waitframe();
	}
}

//Wait for the camera to finish moving
void Cutscene_Waitcamera(){
	while(cutsceneG[CG_CAMSTEP]>0){
		if(cutsceneG[CG_CAMFOLLOWTARGET]>-1){
			int tX = Cutscene_GetAttr(cutsceneG[CG_CAMFOLLOWTARGET], CGI_X)-120;
			int tY = Cutscene_GetAttr(cutsceneG[CG_CAMFOLLOWTARGET], CGI_Y)-80;
			int dist = Cutscene_LargeDistance(cutsceneG[CG_CAMX], cutsceneG[CG_CAMY], tX, tY, 10);
			if(dist<=cutsceneG[CG_CAMFOLLOWRANGE])
				break;
		}
		Cutscene_Waitframe();
	}
}

//Remove a draw
void Cutscene_RemoveDraw(int index){
	if(cutsceneG[CUTSCENE_GLOBAL_INDICES+CUTSCENE_DRAW_INDICES*index+CGI_DRAWTYPE]!=-1){
		for(int i=0; i<CUTSCENE_DRAW_INDICES; i++){
			cutsceneG[CUTSCENE_GLOBAL_INDICES+CUTSCENE_DRAW_INDICES*index+i] = 0;
		}
		cutsceneG[CUTSCENE_GLOBAL_INDICES+CUTSCENE_DRAW_INDICES*index+CGI_DRAWTYPE] = -1;
		cutsceneG[CUTSCENE_GLOBAL_INDICES+CUTSCENE_DRAW_INDICES*index+CGI_PARENT] = -1;
	}
}

//Swap the order of two draws
void Cutscene_SwapDraw(int index, int index2){
	for(int i=0; i<CUTSCENE_DRAW_INDICES; ++i){
		int old = cutsceneG[CUTSCENE_GLOBAL_INDICES+CUTSCENE_DRAW_INDICES*index+i];
		cutsceneG[CUTSCENE_GLOBAL_INDICES+CUTSCENE_DRAW_INDICES*index+i] = cutsceneG[CUTSCENE_GLOBAL_INDICES+CUTSCENE_DRAW_INDICES*index2+i];
		cutsceneG[CUTSCENE_GLOBAL_INDICES+CUTSCENE_DRAW_INDICES*index2+i] = old;
	}
}

//Swap the order of two draws
void Cutscene_SwapDrawPtr(int index, int index2){
	for(int i=0; i<CUTSCENE_DRAW_INDICES; ++i){
		int old = cutsceneG[CUTSCENE_GLOBAL_INDICES+CUTSCENE_DRAW_INDICES*index[0]+i];
		cutsceneG[CUTSCENE_GLOBAL_INDICES+CUTSCENE_DRAW_INDICES*index[0]+i] = cutsceneG[CUTSCENE_GLOBAL_INDICES+CUTSCENE_DRAW_INDICES*index2[0]+i];
		cutsceneG[CUTSCENE_GLOBAL_INDICES+CUTSCENE_DRAW_INDICES*index2[0]+i] = old;
	}
	int old = index[0];
	index[0] = index2[0];
	index2[0] = old;
}

//Draw a map position (used by the camera)
void Cutscene_DrawTrueMapPosition(int layer, int source_map, int source_layer, int X, int Y, int opacity){
	if(G[G_CUTSCENEDEBUG])
		return;
	
	X = Round(X);
	Y = Round(Y);
	int MinScreen = Floor(X/256)+16*Floor(Y/176);
	int TLX = -Floor(X%256);
	int TLY = -Floor(Y%176);
	Screen->DrawLayer(layer, source_map, MinScreen, source_layer, TLX, TLY, 0, opacity);
	Screen->DrawLayer(layer, source_map, MinScreen+1, source_layer, TLX+256, TLY, 0, opacity);
	Screen->DrawLayer(layer, source_map, MinScreen+16, source_layer, TLX, TLY+176, 0, opacity);
	Screen->DrawLayer(layer, source_map, MinScreen+17, source_layer, TLX+256, TLY+176, 0, opacity);
}

//Initialize a cutscene script
void Cutscene_Init(int bmp, int bmp2){
	cutsceneG[CG_NUMDRAWS] = 0;
	cutsceneG[CG_BGMAP] = Game->GetCurMap();
	cutsceneG[CG_CAMANCHORX] = (Game->GetCurScreen()%16)*256;
	cutsceneG[CG_CAMANCHORY] = Floor(Game->GetCurScreen()/16)*176;
	cutsceneG[CG_CAMX] = 0;
	cutsceneG[CG_CAMY] = 0;
	cutsceneG[CG_CAMTX] = 0;
	cutsceneG[CG_CAMTY] = 0;
	cutsceneG[CG_CAMSTEP] = 0;
	cutsceneG[CG_MASKED] = 0;
	
	cutsceneG[CG_STAGEWIDTH] = 0;
	cutsceneG[CG_STAGEHEIGHT] = 0;
	cutsceneG[CG_CAMFOLLOWTARGET] = -1;
	cutsceneG[CG_CAMFOLLOWRANGE] = 0;
	cutsceneG[CG_USEBITMAP] = bmp;
	cutsceneG[CG_BACKUPBITMAP] = bmp2;
	cutsceneG[CG_ZOOMCX] = 128;
	cutsceneG[CG_ZOOMCY] = 88;
	cutsceneG[CG_ZOOMAMOUNT] = 0;
	cutsceneG[CG_ZOOMMAXAMOUNT] = 256;
	cutsceneG[CG_NUMGLIDING] = 0;
	cutsceneG[CG_ACTIVELAYER0] = 1;
	cutsceneG[CG_ACTIVELAYER1] = 1;
	cutsceneG[CG_ACTIVELAYER2] = 1;
	cutsceneG[CG_ACTIVELAYER3] = 1;
	cutsceneG[CG_ACTIVELAYER4] = 1;
	cutsceneG[CG_ACTIVELAYER5] = 1;
	cutsceneG[CG_ACTIVELAYER6] = 1;
	
	cutsceneG[CG_DRAWSTYLE] = CGDS_DEFAULT;
	
	for(int i=0; i<CUTSCENE_MAX_DRAWS; i++){
		for(int j=0; j<CUTSCENE_DRAW_INDICES; j++){
			Cutscene_SetAttr(i, j, 0);
		}
		Cutscene_SetAttr(i, CGI_PARENT, -1);
		Cutscene_SetAttr(i, CGI_DRAWTYPE, -1);
	}
}

//Set which layers are being used (0 is invisible, 1 is solid, 2 is transparent)
void Cutscene_SetActiveLayers(int L0, int L1, int L2, int L3, int L4, int L5, int L6){
	cutsceneG[CG_ACTIVELAYER0] = L0;
	cutsceneG[CG_ACTIVELAYER1] = L1;
	cutsceneG[CG_ACTIVELAYER2] = L2;
	cutsceneG[CG_ACTIVELAYER3] = L3;
	cutsceneG[CG_ACTIVELAYER4] = L4;
	cutsceneG[CG_ACTIVELAYER5] = L5;
	cutsceneG[CG_ACTIVELAYER6] = L6;
}

//Set the current camera screen and anchor position
void Cutscene_AnchorCamera(int scrn, int cam_scrn){
	cutsceneG[CG_CAMANCHORX] = (scrn%16)*256;
	cutsceneG[CG_CAMANCHORY] = Floor(scrn/16)*176;
	cutsceneG[CG_CAMX] = (cam_scrn%16)*256 - cutsceneG[CG_CAMANCHORX];
	cutsceneG[CG_CAMY] = Floor(cam_scrn/16)*176 - cutsceneG[CG_CAMANCHORY];
}

//Set the current camera screen and anchor position
void Cutscene_AnchorCamera(int scrn, int cam_scrn, int stageWidth, int stageHeight){
	cutsceneG[CG_CAMANCHORX] = (scrn%16)*256;
	cutsceneG[CG_CAMANCHORY] = Floor(scrn/16)*176;
	cutsceneG[CG_CAMX] = (cam_scrn%16)*256 - cutsceneG[CG_CAMANCHORX];
	cutsceneG[CG_CAMY] = Floor(cam_scrn/16)*176 - cutsceneG[CG_CAMANCHORY];
	cutsceneG[CG_STAGEWIDTH] = stageWidth*256;
	cutsceneG[CG_STAGEHEIGHT] = stageHeight*176;
}

//Updates the camera anchor screen and adjusts draw positions
void Cutscene_UpdateAnchorScreen(int scrn){
	int newAnchorX = (scrn%16)*256;
	int newAnchorY = Floor(scrn/16)*176;
	
	int diffX = cutsceneG[CG_CAMANCHORX]-newAnchorX;
	int diffY = cutsceneG[CG_CAMANCHORY]-newAnchorY;
	for(int i=0; i<cutsceneG[CG_NUMDRAWS]; i++){
		Cutscene_AddAttr(i, CGI_X, diffX);
		Cutscene_AddAttr(i, CGI_Y, diffY);
		
		Cutscene_AddAttr(i, CGI_X2, diffX);
		Cutscene_AddAttr(i, CGI_Y2, diffY);
		
		Cutscene_AddAttr(i, CGI_X3, diffX);
		Cutscene_AddAttr(i, CGI_Y3, diffY);
		
		Cutscene_AddAttr(i, CGI_X4, diffX);
		Cutscene_AddAttr(i, CGI_Y4, diffY);
		
		Cutscene_AddAttr(i, CGI_ROTX, diffX);
		Cutscene_AddAttr(i, CGI_ROTY, diffY);
		
		Cutscene_AddAttr(i, CGI_TX, diffX);
		Cutscene_AddAttr(i, CGI_TY, diffY);
	}
	
	cutsceneG[CG_CAMX] += diffX;
	cutsceneG[CG_CAMY] += diffY;
	cutsceneG[CG_CAMTX] += diffX;
	cutsceneG[CG_CAMTY] += diffY;
	
	cutsceneG[CG_CAMANCHORX] = newAnchorX;
	cutsceneG[CG_CAMANCHORY] = newAnchorY;
}

//Set the camera to an X and Y position relative to the anchor point
void Cutscene_SetCameraPosition(int x, int y){
	cutsceneG[CG_CAMX] = x;
	cutsceneG[CG_CAMY] = y;
}

//Set the camera to a screen position
void Cutscene_SetCameraPosition(int scrn){
	cutsceneG[CG_CAMX] = (scrn%16)*256 - cutsceneG[CG_CAMANCHORX];
	cutsceneG[CG_CAMY] = Floor(scrn/16)*176 - cutsceneG[CG_CAMANCHORY];
}

//Update all sprites for a given layer
bool __Cutscene_UpdateSprites(int whichLayer){
	int i; int j; int k; int m; int o;
	int x; int y; int x2; int y2; int x3; int y3; int x4; int y4;
	int rX; int rY;
	int width; int height;
	int angle; int step;
	int vX; int vY;
	int gfx; int opacity;
	int flags;
	int lastIndex = -1;
	int layer = 6;
	
	//Cycle through all sprites up to the max being drawn
	for(i=0; i<CUTSCENE_MAX_DRAWS; i++){
		
		if(Cutscene_GetAttr(i, CGI_DRAWTYPE)>-1){
			lastIndex = i;
		}
		else
			continue;
		
		//Check if it's on the right layer
		if(Cutscene_GetAttr(i, CGI_LAYER)==whichLayer||whichLayer==-1){
			if(whichLayer==-1)
				layer = Cutscene_GetAttr(i, CGI_LAYER);
			flags = Cutscene_GetAttr(i, CGI_FLAGS);
			//Debug: Draw numbers
			// x = Cutscene_GetAttr(i, CGI_X)-cutsceneG[CG_CAMX];
			// y = Cutscene_GetAttr(i, CGI_Y)-cutsceneG[CG_CAMY];
			// j = Cutscene_GetAttr(i, CGI_GFX);
			//Screen->DrawInteger(6, x, y, FONT_Z1, 0x01, 0x0F, -1, -1, j, 4, 128);
			//Debug: Draw position
			// Screen->DrawInteger(6, 0, 8*i, FONT_Z1, 0x01, 0x0F, -1, -1, Cutscene_GetAttr(i, CGI_X), 0, 128);
			// Screen->DrawInteger(6, 80, 8*i, FONT_Z1, 0x01, 0x0F, -1, -1, Cutscene_GetAttr(i, CGI_Y), 0, 128);
			//Debug: Check marked draws
			// if(flags&CGF_MARKER){
				// Screen->DrawInteger(6, 0, 0, FONT_Z1, 0x01, 0x0F, -1, -1, i, 4, 128);
				// Screen->DrawInteger(6, 0, 8, FONT_Z1, 0x01, 0x0F, -1, -1, Cutscene_GetAttr(i, CGI_MISC3), 4, 128);
				// Screen->DrawInteger(6, 0, 16, FONT_Z1, 0x01, 0x0F, -1, -1, Cutscene_GetAttr(i, CGI_MISC4), 4, 128);
			// }
			
			Cutscene_UnsetFlag(i, CGF_GLIDESUCCESS);
			flags &= ~CGF_GLIDESUCCESS;
			if(flags&CGF_SUSPENDED)
				continue;
			
			vX = 0;
			vY = 0;
			
			//If the sprite is in motion, update movement stuff
			if(Cutscene_GetAttr(i, CGI_MOVESTEP)>0){
				//Wrap the movement angle
				Cutscene_SetAttr(i, CGI_MOVEANGLE, WrapDegrees(Cutscene_GetAttr(i, CGI_MOVEANGLE)));
			
				x2 = Cutscene_GetAttr(i, CGI_TX);
				y2 = Cutscene_GetAttr(i, CGI_TY);
				//If there's a target position, move towards that
				if(x2>0||y2>0){
					x = Cutscene_GetAttr(i, CGI_X);
					y = Cutscene_GetAttr(i, CGI_Y);
					angle = Angle(x, y, x2, y2);
					step = Cutscene_GetAttr(i, CGI_MOVESTEP);
					if(Cutscene_GetAttr(i, CGI_ACCELSTEP)>0){
						step = Cutscene_GetAttr(i, CGI_ACCELSTEP)+(step-Cutscene_GetAttr(i, CGI_ACCELSTEP))*(1-(Cutscene_LargeDistance(x, y, x2, y2, 10)/Cutscene_GetAttr(i, CGI_TARGETDIST)));
					}
					//If the draw is close enough to the target position, set it to that and unset the target point
					if(Cutscene_LargeDistance(x, y, x2, y2, 10)<=Max(1, step)){
						Cutscene_SetAttr(i, CGI_X, x2);
						Cutscene_SetAttr(i, CGI_Y, y2);
						Cutscene_SetAttr(i, CGI_MOVESTEP, 0);
						Cutscene_SetAttr(i, CGI_TX, 0);
						Cutscene_SetAttr(i, CGI_TY, 0);
						Cutscene_SetFlag(i, CGF_GLIDESUCCESS);
					}
					else{
						//Mark that there's at least one draw approaching a target position
						//This way the Cutscene_Waitglide() function knows to keep waiting on it
						cutsceneG[CG_NUMGLIDING]++;
						vX = VectorX(step, angle);
						vY = VectorY(step, angle);
					}
				}
				//If there's no target position, move based on the movement angle instead
				else{
					angle = Cutscene_GetAttr(i, CGI_MOVEANGLE);
					step = Cutscene_GetAttr(i, CGI_MOVESTEP);
					vX = VectorX(step, angle);
					vY = VectorY(step, angle);
				}
			}
			
			Cutscene_AddAttr(i, CGI_X, vX);
			Cutscene_AddAttr(i, CGI_Y, vY);
			Cutscene_AddAttr(i, CGI_ROTX, vX);
			Cutscene_AddAttr(i, CGI_ROTY, vY);
			
			//If the draw has a parent draw, set its position based on that
			if(Cutscene_GetAttr(i, CGI_PARENT)>-1){
				k = Cutscene_GetAttr(i, CGI_PARENT);
				x = (Cutscene_GetAttr(k, CGI_X) + Cutscene_GetAttr(i, CGI_PARENTOFFX))-Cutscene_GetAttr(i, CGI_X);
				y = (Cutscene_GetAttr(k, CGI_Y) + Cutscene_GetAttr(i, CGI_PARENTOFFY))-Cutscene_GetAttr(i, CGI_Y);
				Cutscene_SetAttr(i, CGI_X, Cutscene_GetAttr(k, CGI_X) + Cutscene_GetAttr(i, CGI_PARENTOFFX));
				Cutscene_SetAttr(i, CGI_Y, Cutscene_GetAttr(k, CGI_Y) + Cutscene_GetAttr(i, CGI_PARENTOFFY));
			
				Cutscene_AddAttr(i, CGI_X2, x);
				Cutscene_AddAttr(i, CGI_Y2, y);
				Cutscene_AddAttr(i, CGI_X3, x);
				Cutscene_AddAttr(i, CGI_Y3, y);
				Cutscene_AddAttr(i, CGI_X4, x);
				Cutscene_AddAttr(i, CGI_Y4, y);
				Cutscene_AddAttr(i, CGI_ROTX, x);
				Cutscene_AddAttr(i, CGI_ROTY, y);
			}
			
			//Set the draw's position within the screen space
			x = Cutscene_GetAttr(i, CGI_X)-Round(cutsceneG[CG_CAMX]);
			y = Cutscene_GetAttr(i, CGI_Y)-Round(cutsceneG[CG_CAMY]);
			rX = Cutscene_GetAttr(i, CGI_ROTX)-Round(cutsceneG[CG_CAMX]);
			rY = Cutscene_GetAttr(i, CGI_ROTY)-Round(cutsceneG[CG_CAMY]);
			
			opacity = Cutscene_GetAttr(i, CGI_OPACITY);
			if(flags&CGF_FADEDEATH){
				if(Cutscene_GetAttr(i, CGI_DRAWLIFESPAN)<8)
					opacity = 64;
			}
			
			k = Cutscene_GetAttr(i, CGI_DRAWTYPE);
			if(!G[G_CUTSCENEDEBUG]){
				switch(k){
					case CGDT_RECTANGLE: //Rectangle
						Cutscene_AddAttr(i, CGI_X2, vX);
						Cutscene_AddAttr(i, CGI_Y2, vY);
						x2 = Cutscene_GetAttr(i, CGI_X2)-Round(cutsceneG[CG_CAMX]);
						y2 = Cutscene_GetAttr(i, CGI_Y2)-Round(cutsceneG[CG_CAMY]);
					
						Screen->Rectangle(layer, x, y, x2, y2, Cutscene_GetAttr(i, CGI_CLR), Cutscene_GetAttr(i, CGI_WIDTH), rX, rY, Cutscene_GetAttr(i, CGI_ROT), Cutscene_GetAttr(i, CGI_MISC1), opacity);
						break;
					case CGDT_CIRCLE: //Circle
						Screen->Circle(layer, x, y, Cutscene_GetAttr(i, CGI_RADIUS), Cutscene_GetAttr(i, CGI_CLR), Cutscene_GetAttr(i, CGI_WIDTH), rX, rY, Cutscene_GetAttr(i, CGI_ROT), Cutscene_GetAttr(i, CGI_MISC1), opacity);
						break;
					case CGDT_ARC: //Arc
						Screen->Arc(layer, x, y, Cutscene_GetAttr(i, CGI_RADIUS), Cutscene_GetAttr(i, CGI_MISC3), Cutscene_GetAttr(i, CGI_MISC4), Cutscene_GetAttr(i, CGI_CLR), Cutscene_GetAttr(i, CGI_WIDTH), rX, rY, Cutscene_GetAttr(i, CGI_ROT), Cutscene_GetAttr(i, CGI_MISC1), Cutscene_GetAttr(i, CGI_MISC2), opacity);
						break;
					case CGDT_ELLIPSE: //Ellipse
						Screen->Ellipse(layer, x, y, Cutscene_GetAttr(i, CGI_RADIUS), Cutscene_GetAttr(i, CGI_RADIUS2), Cutscene_GetAttr(i, CGI_CLR), Cutscene_GetAttr(i, CGI_WIDTH), rX, rY, Cutscene_GetAttr(i, CGI_ROT), Cutscene_GetAttr(i, CGI_MISC1), opacity);
						break;
					case CGDT_SPLINE: //Spline
						Cutscene_AddAttr(i, CGI_X2, vX);
						Cutscene_AddAttr(i, CGI_Y2, vY);
						Cutscene_AddAttr(i, CGI_X3, vX);
						Cutscene_AddAttr(i, CGI_Y3, vY);
						Cutscene_AddAttr(i, CGI_X4, vX);
						Cutscene_AddAttr(i, CGI_Y4, vY);
						x2 = Cutscene_GetAttr(i, CGI_X2)-Round(cutsceneG[CG_CAMX]);
						y2 = Cutscene_GetAttr(i, CGI_Y2)-Round(cutsceneG[CG_CAMY]);
						x3 = Cutscene_GetAttr(i, CGI_X3)-Round(cutsceneG[CG_CAMX]);
						y3 = Cutscene_GetAttr(i, CGI_Y3)-Round(cutsceneG[CG_CAMY]);
						x4 = Cutscene_GetAttr(i, CGI_X4)-Round(cutsceneG[CG_CAMX]);
						y4 = Cutscene_GetAttr(i, CGI_Y4)-Round(cutsceneG[CG_CAMY]);
						Screen->Spline(layer, x, y, x2, y2, x3, y3, x4, y4, Cutscene_GetAttr(i, CGI_CLR), opacity);
						break;
					case CGDT_LINE: //Line
						Cutscene_AddAttr(i, CGI_X2, vX);
						Cutscene_AddAttr(i, CGI_Y2, vY);
						x2 = Cutscene_GetAttr(i, CGI_X2)-Round(cutsceneG[CG_CAMX]);
						y2 = Cutscene_GetAttr(i, CGI_Y2)-Round(cutsceneG[CG_CAMY]);
						Screen->Circle(layer, x, y, x2, y2, Cutscene_GetAttr(i, CGI_CLR), Cutscene_GetAttr(i, CGI_WIDTH), rX, rY, Cutscene_GetAttr(i, CGI_ROT), opacity);
						break;
					case CGDT_PIXEL: //Pixel
						Screen->PutPixel(layer, x, y, Cutscene_GetAttr(i, CGI_CLR), rX, rY, Cutscene_GetAttr(i, CGI_ROT), opacity);
						break;
					case CGDT_TILE: //Tile
						width = Cutscene_GetAttr(i, CGI_WIDTH);
						height = Cutscene_GetAttr(i, CGI_HEIGHT);
						if(width==-1)
							width = Cutscene_GetAttr(i, CGI_TILEWIDTH)*16;
						if(height==-1)
							height = Cutscene_GetAttr(i, CGI_TILEHEIGHT)*16;
						
						if(flags&CGF_AUTOCENTER){
							rX = x;
							rY = y;
						}
						else if(CUTSCENE_SANITIZE_ROTATION){
							rX -= width/2;
							rY -= height/2;
						}
						
						x2 = Cutscene_RotatePointX(x, y, rX, rY, Cutscene_GetAttr(i, CGI_ROT));
						y2 = Cutscene_RotatePointY(x, y, rX, rY, Cutscene_GetAttr(i, CGI_ROT));
					
						gfx = Cutscene_GetAttr(i, CGI_GFX);
						if(Cutscene_GetAttr(i, CGI_DIR)>-1){
							gfx += Cutscene_GetAttr(i, CGI_DIR)*Cutscene_GetAttr(i, CGI_TILEWIDTH);
						}
						else{
							if(flags&CGF_4WAY){
								gfx += AngleDir4(Cutscene_GetAttr(i, CGI_MOVEANGLE))*Cutscene_GetAttr(i, CGI_TILEWIDTH);
							}
							else if(flags&CGF_8WAY){
								gfx += AngleDir8(Cutscene_GetAttr(i, CGI_MOVEANGLE))*Cutscene_GetAttr(i, CGI_TILEWIDTH);
							}
						}
						Screen->DrawTile(layer, x2, y2, gfx, Cutscene_GetAttr(i, CGI_TILEWIDTH), Cutscene_GetAttr(i, CGI_TILEHEIGHT), Cutscene_GetAttr(i, CGI_CLR), Cutscene_GetAttr(i, CGI_WIDTH), Cutscene_GetAttr(i, CGI_HEIGHT), x2, y2, Cutscene_GetAttr(i, CGI_ROT), Cutscene_GetAttr(i, CGI_MISC1), Cutscene_GetAttr(i, CGI_MISC2), opacity);
						//Debug: Rotation test draw
						//Cutscene_Debug_TileRotTest(x, y, width, height, rX, rY, Cutscene_GetAttr(i, CGI_ROT));
						break;
					case CGDT_FASTTILE: //FastTile
						gfx = Cutscene_GetAttr(i, CGI_GFX);
						if(Cutscene_GetAttr(i, CGI_DIR)>-1){
							gfx += Cutscene_GetAttr(i, CGI_DIR);
						}
						else{
							if(flags&CGF_4WAY){
								gfx += AngleDir4(Cutscene_GetAttr(i, CGI_MOVEANGLE));
							}
							else if(flags&CGF_8WAY){
								gfx += AngleDir8(Cutscene_GetAttr(i, CGI_MOVEANGLE));
							}
						}
						Screen->FastTile(layer, x, y, gfx, Cutscene_GetAttr(i, CGI_CLR), opacity);
						break;
					case CGDT_COMBO: //Combo
						width = Cutscene_GetAttr(i, CGI_WIDTH);
						height = Cutscene_GetAttr(i, CGI_HEIGHT);
						if(width==-1)
							width = Cutscene_GetAttr(i, CGI_TILEWIDTH)*16;
						if(height==-1)
							height = Cutscene_GetAttr(i, CGI_TILEHEIGHT)*16;
						
						if(flags&CGF_AUTOCENTER){
							rX = x;
							rY = y;
						}
						else if(CUTSCENE_SANITIZE_ROTATION){
							rX -= width/2;
							rY -= height/2;
						}
						
						x2 = Cutscene_RotatePointX(x, y, rX, rY, Cutscene_GetAttr(i, CGI_ROT));
						y2 = Cutscene_RotatePointY(x, y, rX, rY, Cutscene_GetAttr(i, CGI_ROT));
						
						gfx = Cutscene_GetAttr(i, CGI_GFX);
						if(Cutscene_GetAttr(i, CGI_DIR)>-1){
							gfx += Cutscene_GetAttr(i, CGI_DIR);
						}
						else{
							if(flags&CGF_4WAY){
								gfx += AngleDir4(Cutscene_GetAttr(i, CGI_MOVEANGLE));
							}
							else if(flags&CGF_8WAY){
								gfx += AngleDir8(Cutscene_GetAttr(i, CGI_MOVEANGLE));
							}
						}
						Screen->DrawCombo(layer, x2, y2, gfx, Cutscene_GetAttr(i, CGI_TILEWIDTH), Cutscene_GetAttr(i, CGI_TILEHEIGHT), Cutscene_GetAttr(i, CGI_CLR), Cutscene_GetAttr(i, CGI_WIDTH), Cutscene_GetAttr(i, CGI_HEIGHT), x2, y2, Cutscene_GetAttr(i, CGI_ROT), Cutscene_GetAttr(i, CGI_MISC1), Cutscene_GetAttr(i, CGI_MISC2), Cutscene_GetAttr(i, CGI_MISC3), opacity);
						//Debug: Rotation test draw
						//Cutscene_Debug_TileRotTest(x, y, width, height, rX, rY, Cutscene_GetAttr(i, CGI_ROT));
						break;
					case CGDT_FASTCOMBO: //FastCombo
						gfx = Cutscene_GetAttr(i, CGI_GFX);
						if(Cutscene_GetAttr(i, CGI_DIR)>-1){
							gfx += Cutscene_GetAttr(i, CGI_DIR);
						}
						else{
							if(flags&CGF_4WAY){
								gfx += AngleDir4(Cutscene_GetAttr(i, CGI_MOVEANGLE));
							}
							else if(flags&CGF_8WAY){
								gfx += AngleDir8(Cutscene_GetAttr(i, CGI_MOVEANGLE));
							}
						}
						Screen->FastCombo(layer, x, y, gfx, Cutscene_GetAttr(i, CGI_CLR), opacity);
						break;
					case CGDT_QUAD: //Quad
						Cutscene_AddAttr(i, CGI_X2, vX);
						Cutscene_AddAttr(i, CGI_Y2, vY);
						Cutscene_AddAttr(i, CGI_X3, vX);
						Cutscene_AddAttr(i, CGI_Y3, vY);
						Cutscene_AddAttr(i, CGI_X4, vX);
						Cutscene_AddAttr(i, CGI_Y4, vY);
						x2 = Cutscene_GetAttr(i, CGI_X2)-Round(cutsceneG[CG_CAMX]);
						y2 = Cutscene_GetAttr(i, CGI_Y2)-Round(cutsceneG[CG_CAMY]);
						x3 = Cutscene_GetAttr(i, CGI_X3)-Round(cutsceneG[CG_CAMX]);
						y3 = Cutscene_GetAttr(i, CGI_Y3)-Round(cutsceneG[CG_CAMY]);
						x4 = Cutscene_GetAttr(i, CGI_X4)-Round(cutsceneG[CG_CAMX]);
						y4 = Cutscene_GetAttr(i, CGI_Y4)-Round(cutsceneG[CG_CAMY]);
						Screen->Quad(layer, x, y, x2, y2, x3, y3, x4, y4, Cutscene_GetAttr(i, CGI_WIDTH), Cutscene_GetAttr(i, CGI_HEIGHT), Cutscene_GetAttr(i, CGI_CLR), Cutscene_GetAttr(i, CGI_MISC1), Cutscene_GetAttr(i, CGI_GFX), Cutscene_GetAttr(i, CGI_MISC2));
						break;
					case CGDT_TRIANGLE: //Triangle
						Cutscene_AddAttr(i, CGI_X2, vX);
						Cutscene_AddAttr(i, CGI_Y2, vY);
						Cutscene_AddAttr(i, CGI_X3, vX);
						Cutscene_AddAttr(i, CGI_Y3, vY);
						x2 = Cutscene_GetAttr(i, CGI_X2)-Round(cutsceneG[CG_CAMX]);
						y2 = Cutscene_GetAttr(i, CGI_Y2)-Round(cutsceneG[CG_CAMY]);
						x3 = Cutscene_GetAttr(i, CGI_X3)-Round(cutsceneG[CG_CAMX]);
						y3 = Cutscene_GetAttr(i, CGI_Y3)-Round(cutsceneG[CG_CAMY]);
						Screen->Triangle(layer, x, y, x2, y2, x3, y3, Cutscene_GetAttr(i, CGI_WIDTH), Cutscene_GetAttr(i, CGI_HEIGHT), Cutscene_GetAttr(i, CGI_CLR), Cutscene_GetAttr(i, CGI_MISC1), Cutscene_GetAttr(i, CGI_GFX), Cutscene_GetAttr(i, CGI_MISC2));
						break;
					case CGDT_BITMAP: //Bitmap
						x2 = Cutscene_GetAttr(i, CGI_X2)-Round(cutsceneG[CG_CAMX]);
						y2 = Cutscene_GetAttr(i, CGI_Y2)-Round(cutsceneG[CG_CAMY]);
						Screen->DrawBitmap(layer, Cutscene_GetAttr(i, CGI_MISC1), x2, y2, Cutscene_GetAttr(i, CGI_MISC2), Cutscene_GetAttr(i, CGI_MISC3), x, y, Cutscene_GetAttr(i, CGI_WIDTH), Cutscene_GetAttr(i, CGI_HEIGHT), Cutscene_GetAttr(i, CGI_ROT), Cutscene_GetAttr(i, CGI_MISC4));
						break;
					case CGDT_LAYER: //Layer
						Screen->DrawLayer(layer, Cutscene_GetAttr(i, CGI_MISC1), Cutscene_GetAttr(i, CGI_MISC2), Cutscene_GetAttr(i, CGI_MISC3), x, y, Cutscene_GetAttr(i, CGI_ROT), opacity);
						break;
					case CGDT_SCREEN: //Screen
						Screen->DrawScreen(layer, Cutscene_GetAttr(i, CGI_MISC1), Cutscene_GetAttr(i, CGI_MISC2), x, y, Cutscene_GetAttr(i, CGI_ROT));
						break;
					case CGDT_NPC: //NPC
						gfx = Cutscene_GetAttr(i, CGI_GFX);
						if(gfx==Cutscene_GetAttr(i, CGI_MISC1)){
							if(Cutscene_GetAttr(i, CGI_DIR)>-1){
								gfx += Cutscene_GetAttr(i, CGI_DIR);
							}
							else{
								if(flags&CGF_4WAY){
									gfx += AngleDir4(Cutscene_GetAttr(i, CGI_MOVEANGLE));
								}
								else if(flags&CGF_8WAY){
									gfx += AngleDir8(Cutscene_GetAttr(i, CGI_MOVEANGLE));
								}
							}
							if(Cutscene_GetAttr(i, CGI_MOVESTEP)>0){
								if(flags&CGF_4WAY){
									gfx += 4;
								}
								else if(flags&CGF_8WAY){
									gfx += 8;
								}
							}
						}
						m = Cutscene_ComboFrame(gfx);
						if(Cutscene_HasFlag(i, CGF_BS)){
							if(m==2)
								m = 0;
							else if(m==3)
								m = 2;
						}
						o = Cutscene_ComboFlip(gfx);
						gfx = Cutscene_ComboOTile(gfx)+m;
						if(!(flags&CGF_NODRAW)){
							if(Cutscene_HasFlag(i, CGF_BIGNPC)){
								Screen->DrawTile(layer, x, y-16, gfx, 1, 2, Cutscene_GetAttr(i, CGI_CLR), -1, -1, 0, 0, 0, o, true, opacity);
							}
							else
								Screen->DrawTile(layer, x, y, gfx, 1, 1, Cutscene_GetAttr(i, CGI_CLR), -1, -1, 0, 0, 0, o, true, opacity);
						}
						break;
					case CGDT_ANIM: //Anim
						width = Cutscene_GetAttr(i, CGI_WIDTH);
						height = Cutscene_GetAttr(i, CGI_HEIGHT);
						if(width==-1)
							width = Cutscene_GetAttr(i, CGI_TILEWIDTH)*16;
						if(height==-1)
							height = Cutscene_GetAttr(i, CGI_TILEHEIGHT)*16;
						
						if(CUTSCENE_SANITIZE_ROTATION){
							rX -= width/2;
							rY -= height/2;
						}
					
						x2 = Cutscene_RotatePointX(x, y, rX, rY, Cutscene_GetAttr(i, CGI_ROT));
						y2 = Cutscene_RotatePointY(x, y, rX, rY, Cutscene_GetAttr(i, CGI_ROT));
						
						gfx = Cutscene_GetAttr(i, CGI_GFX);
						m = Floor(Cutscene_GetAttr(i, CGI_MISC5)/Cutscene_GetAttr(i, CGI_MISC4))*Cutscene_GetAttr(i, CGI_TILEWIDTH);
						
						if((gfx%20)+m+(Cutscene_GetAttr(i, CGI_TILEWIDTH)-1)>19){
							m += 20*CGI_TILEHEIGHT;
						}
						if(Cutscene_GetAttr(i, CGI_MISC5)>=Cutscene_GetAttr(i, CGI_MISC3)*Cutscene_GetAttr(i, CGI_MISC4)){
							if(!(flags&CGF_HALTDEATH))
								Cutscene_SetAttr(i, CGI_DRAWLIFESPAN, 1);
						}
						else{
							Cutscene_AddAttr(i, CGI_MISC5, 1);
							Screen->DrawTile(layer, x2, y2, gfx+m, Cutscene_GetAttr(i, CGI_TILEWIDTH), Cutscene_GetAttr(i, CGI_TILEHEIGHT), Cutscene_GetAttr(i, CGI_CLR), Cutscene_GetAttr(i, CGI_WIDTH), Cutscene_GetAttr(i, CGI_HEIGHT), x2, y2, Cutscene_GetAttr(i, CGI_ROT), Cutscene_GetAttr(i, CGI_MISC1), Cutscene_GetAttr(i, CGI_MISC2), opacity);
						}
						break;
					case CGDT_BLIT:
						int misc1 = Cutscene_GetAttr(i, CGI_MISC1);
						bitmap b = <bitmap>misc1; 
						opacity = Cutscene_GetAttr(i, CGI_MISC2);
						x2 = Cutscene_GetAttr(i, CGI_X2);
						y2 = Cutscene_GetAttr(i, CGI_Y2);
						x3 = Cutscene_GetAttr(i, CGI_X3);
						y3 = Cutscene_GetAttr(i, CGI_Y3);
						x4 = Cutscene_GetAttr(i, CGI_X4);
						y4 = Cutscene_GetAttr(i, CGI_Y4);
						b->Blit(layer, RT_CURRENT, x2, y2, x3, y3, x, y, x4, y4, 0, 0, 0, opacity, 0, true);
						break;
				}
			}
			//Countdown lifespan and remove draws
			if(Cutscene_GetAttr(i, CGI_DRAWLIFESPAN)>0){
				Cutscene_AddAttr(i, CGI_DRAWLIFESPAN, -1);
				if(Cutscene_GetAttr(i, CGI_DRAWLIFESPAN)==0){
					if(Cutscene_GetAttr(i, CGI_FLAGS)&CGF_HALTDEATH){
						Cutscene_SetAttr(i, CGI_DRAWLIFESPAN, -1);
						
						Cutscene_SetAttr(i, CGI_MOVESTEP, 0);
					}
					else{
						Cutscene_RemoveDraw(i);
					}
				}
			}
		}
	}

	if(lastIndex+1<cutsceneG[CG_NUMDRAWS])
		cutsceneG[CG_NUMDRAWS] = lastIndex+1;
}

//Update all behind the scenes stuff in a cutscene
void Cutscene_Update(){
	int i;
	int angle; int step; int dist;
	step = cutsceneG[CG_CAMSTEP];
	//If the camera is moving, update camera stuff
	if(step>0){
		//If the cameara is set to follow a target
		if(cutsceneG[CG_CAMFOLLOWTARGET]>-1){
			int tX = Cutscene_GetAttr(cutsceneG[CG_CAMFOLLOWTARGET], CGI_X)-120;
			int tY = Cutscene_GetAttr(cutsceneG[CG_CAMFOLLOWTARGET], CGI_Y)-80;
			angle = Angle(cutsceneG[CG_CAMX], cutsceneG[CG_CAMY], tX, tY);
			dist = Cutscene_LargeDistance(cutsceneG[CG_CAMX], cutsceneG[CG_CAMY], tX, tY, 10);
			if(dist>cutsceneG[CG_CAMFOLLOWRANGE]){
				i = Cutscene_GetAttr(cutsceneG[CG_CAMFOLLOWTARGET], CGI_MOVESTEP);
				if(step>i&&i>0&&Abs(dist-cutsceneG[CG_CAMFOLLOWRANGE])<=step+i)
					step = i;
				cutsceneG[CG_CAMX] += VectorX(step, angle);
				cutsceneG[CG_CAMY] += VectorY(step, angle);
			}
		}
		//If the camera is moving to a point instead
		else{
			angle = Angle(cutsceneG[CG_CAMX], cutsceneG[CG_CAMY], cutsceneG[CG_CAMTX], cutsceneG[CG_CAMTY]);
			dist = Cutscene_LargeDistance(cutsceneG[CG_CAMX], cutsceneG[CG_CAMY], cutsceneG[CG_CAMTX], cutsceneG[CG_CAMTY], 10);
			if(dist<=step){
				cutsceneG[CG_CAMX] = cutsceneG[CG_CAMTX];
				cutsceneG[CG_CAMY] = cutsceneG[CG_CAMTY];
				cutsceneG[CG_CAMSTEP] = 0;
			}
			else{
				cutsceneG[CG_CAMX] += VectorX(step, angle);
				cutsceneG[CG_CAMY] += VectorY(step, angle);
			}
		}
		//If stagewidth/height are greater than 0, keep the camera in bounds
		if(cutsceneG[CG_STAGEWIDTH]>0&&cutsceneG[CG_STAGEHEIGHT]>0){
			cutsceneG[CG_STAGEWIDTH] = Max(cutsceneG[CG_STAGEWIDTH], 256);
			cutsceneG[CG_STAGEHEIGHT] = Max(cutsceneG[CG_STAGEHEIGHT], 176);
			cutsceneG[CG_CAMX] = Clamp(cutsceneG[CG_CAMX], 0, cutsceneG[CG_STAGEWIDTH]-256);
			cutsceneG[CG_CAMY] = Clamp(cutsceneG[CG_CAMY], 0, cutsceneG[CG_STAGEHEIGHT]-176);
		}
	}
	
	if(!G[G_CUTSCENEDEBUG]){
		if(cutsceneG[CG_USEBITMAP]>RT_SCREEN){
			Screen->SetRenderTarget(cutsceneG[CG_USEBITMAP]);
			Screen->Rectangle(0, 0, 0, 511, 511, 0x00, 1, 0, 0, 0, true, 128);
		}
	}
	cutsceneG[CG_NUMGLIDING] = 0;
	bool checkPTR;
	//Cycle through each layer, draw background and sprites
	if(cutsceneG[CG_DRAWSTYLE]==CGDS_DEFAULT){
		for(i=0; i<7; i++){
			int op = 128;
			if(cutsceneG[CG_ACTIVELAYER0+i]>0){
				if(cutsceneG[CG_ACTIVELAYER0+i]==2)
					op = 64;
				Cutscene_DrawTrueMapPosition(6, cutsceneG[CG_BGMAP], i, cutsceneG[CG_CAMANCHORX]+cutsceneG[CG_CAMX], cutsceneG[CG_CAMANCHORY]+cutsceneG[CG_CAMY], op);
			}
			__Cutscene_UpdateSprites(i);
		}
	}
	else if(cutsceneG[CG_DRAWSTYLE]==CGDS_TRUELAYERNOBG){
		for(i=0; i<7; i++){
			__Cutscene_UpdateSprites(-i);
		}
	}
	
	if(!G[G_CUTSCENEDEBUG]){
		bool mask;
		if(cutsceneG[CG_MASKED])
			mask = true;
		//If using a bmp, draw it to the screen and apply zoom
		if(cutsceneG[CG_USEBITMAP]>RT_SCREEN){
			Screen->SetRenderTarget(RT_BITMAP2);
			Screen->DrawBitmap(6, RT_BITMAP1, 0, 0, 256, 176, 0, 0, 256, 176, 0, mask);
			Screen->SetRenderTarget(RT_SCREEN);
			if(cutsceneG[CG_ZOOMAMOUNT]>0){
				Cutscene_DrawZoomBitmap();
			}
			else
				Screen->DrawBitmap(6, cutsceneG[CG_USEBITMAP], 0, 0, 256, 176, 0, 0, 256, 176, 0, mask);
		}
	}
}

//Draw a bmp to the screen with the zoom effect
void Cutscene_DrawZoomBitmap(){
	int multiplier = (256-cutsceneG[CG_ZOOMAMOUNT])/256;
	int width = 256*multiplier;
	int height = 176*multiplier;
	int dist = Distance(128, 88, cutsceneG[CG_ZOOMCX], cutsceneG[CG_ZOOMCY]);
	int angle = Angle(128, 88, cutsceneG[CG_ZOOMCX], cutsceneG[CG_ZOOMCY]);
	int x = Round(128+VectorX(dist*(cutsceneG[CG_ZOOMAMOUNT]/cutsceneG[CG_ZOOMMAXAMOUNT]), angle)-width/2);
	int y = Round(88+VectorY(dist*(cutsceneG[CG_ZOOMAMOUNT]/cutsceneG[CG_ZOOMMAXAMOUNT]), angle)-height/2);
	x = Clamp(x, 0, 255-width);
	y = Clamp(y, 0, 175-height);
	Screen->DrawBitmap(6, cutsceneG[CG_USEBITMAP], x, y, width, height, 0, 0, 256, 176, 0, false);
}

//Wait a single frame in a cutscene
void Cutscene_Waitframe(){
	Cutscene_Update();
	Link->InputMap = false; Link->PressMap = false;
	Link->InputStart = false; Link->PressStart = false;
	NoAction();
	//Skip all waitframes when debug skip is set
	if(!G[G_CUTSCENEDEBUG])
		Waitframe();
}

//Wait a single frame in a cutscene where Link can still act
void Cutscene_Waitframe2(){
	Cutscene_Update();
	Link->InputMap = false; Link->PressMap = false;
	Link->InputStart = false; Link->PressStart = false;
	//Skip all waitframes when debug skip is set
	if(!G[G_CUTSCENEDEBUG])
		Waitframe();
}

//Wait multiple frames while in a cutscene
void Cutscene_Waitframe(int count){
	for(int i=0; i<count; i++){
		Cutscene_Waitframe();
	}
}	
//END CUTSCENE.ZH

enum CutsceneIDs{
	CUTSCENE_NULL,
	CUTSCENE_INTRO,
	CUTSCENE_INTROIRIS,
	CUTSCENE_METTORRIN,
	CUTSCENE_TORRINJOINS,
	CUTSCENE_SELETWAREHOUSE,
	CUTSCENE_SHELRONDINTRO,
	CUTSCENE_POSTSHELROND,
	CUTSCENE_ENTEREDMALKA,
	CUTSCENE_TORRINREJOINS,
	CUTSCENE_SELETMINES,
	CUTSCENE_POSTSELETMINES,
	CUTSCENE_ASHERRESCUED,
	CUTSCENE_CATACOMBS1,
	CUTSCENE_CATACOMBS2,
	CUTSCENE_EXITCATACOMBS,
	CUTSCENE_METGRANDMA,
	CUTSCENE_GRANDMA1,
	CUTSCENE_GRANDMA2,
	CUTSCENE_GRANDMA3,
	CUTSCENE_GRANDMA4,
	CUTSCENE_POHOENTRY1,
	CUTSCENE_POHOENTRY2,
	CUTSCENE_POHO1A,
	CUTSCENE_POHO1B,
	CUTSCENE_POHO2A,
	CUTSCENE_POHO2B,
	CUTSCENE_POHO3,
	CUTSCENE_POHO4,
	CUTSCENE_POHOEND,
	CUTSCENE_ESANENTRY,
	CUTSCENE_POSTESAN,
	CUTSCENE_GRANDMAPOSTPOHO,
	CUTSCENE_OBSERVATORYENTRANCE,
	CUTSCENE_SELETFINAL1,
	CUTSCENE_SELETFINAL2, 
	CUTSCENE_ENDING
};

void NoCarryover(){
	for(int i=1; i<=32; ++i){
		ffc f = Screen->LoadFFC(i);
		f->Flags[FFCF_CARRYOVER] = false;
	}
}

void LinkWarp(int warpReturn, int dmap, int scrn, int effect){
	Link->WarpEx({WT_IWARP, dmap, scrn, -1, warpReturn, effect, 0, 0});
}
void LinkPitWarp(int dmap, int scrn, int effect){
	Link->WarpEx({WT_IWARP, dmap, scrn, -1, -1, effect, 0, 0});
}

void SetCutsceneSkip(int id){
	G[G_CUTSCENESKIPID] = id;
	if(id!=CUTSCENE_NULL)
		G[G_CUTSCENESKIPFIRSTFRAME] = 1;
}

void SkipCutscene(int id){
	G[G_CUTSCENESKIPWARP] = 0;
	Link->Invisible = false;
	Link->CollDetection = true;
	SetCutsceneSkip(CUTSCENE_NULL);
	Tango_ClearSlot(0);
	switch(id){
		case CUTSCENE_INTRO:
			NoCarryover();
			Link->Dir = DIR_DOWN;
			LinkWarp(0, 15, 0x50, WARPEFFECT_INSTANT);
			break;
		case CUTSCENE_INTROIRIS:
			SetDBit(33, true);
			LinkPitWarp(Game->GetCurDMap(), Game->GetCurDMapScreen(), WARPEFFECT_INSTANT);
			break;
		case CUTSCENE_METTORRIN:
			G[G_TIMEFROZEN] = 0;
			G[G_HOURCLAMP] = 18;
			G[G_MINUTECLAMP] = 59;
			Game->Counter[CR_STORYFLAG] = SFLAG_METTORRIN;
			LinkPitWarp(Game->GetCurDMap(), Game->GetCurDMapScreen(), WARPEFFECT_INSTANT);
			break;
		case CUTSCENE_TORRINJOINS:
			Link->Item[150] = true;
			G[G_TIMEFROZEN] = 0;
			G[G_HOURCLAMP] = 22;
			G[G_MINUTECLAMP] = 0;
			Game->Counter[CR_STORYFLAG] = SFLAG_WAREHOUSE;
			DayNight[_DN_SECOND] = 0;
			DayNight[_DN_MINUTE] = 0;
			DayNight[_DN_HOUR] = 21;
			LinkPitWarp(Game->GetCurDMap(), Game->GetCurDMapScreen(), WARPEFFECT_INSTANT);
			break;
		case CUTSCENE_SELETWAREHOUSE:
			Game->Counter[CR_STORYFLAG] = SFLAG_METKAYLANI;
			DayNight[_DN_HOUR] = 3;
			DayNight[_DN_MINUTE] = 0;
			DayNight[_DN_SECOND] = 0;
			G[G_HOURCLAMP] = 0;
			G[G_MINUTECLAMP] = 0;
			Link->Item[I_KAYLANI] = true;
			int x = 80;
			int y = 112;
			int scrn = 0x12;
			
			x += (scrn%16)*256;
			y += Floor(scrn/16)*176;
			if(LargeDistance(G[G_OWBOATX], G[G_OWBOATY], x, y, 16)>=24){
				G[G_OWBOATX] = x;
				G[G_OWBOATY] = y;
			}
			G[G_OWBOATDIR] = DIR_UP;
			LinkWarp(0, 29, 0x11, WARPEFFECT_INSTANT);
			break;
		case CUTSCENE_SHELRONDINTRO:
			Link->X = 32;
			Link->Y = 64;
			Link->Dir = DIR_RIGHT;
			Screen->D[5] = 1;
			LinkWarp(0, Game->GetCurDMap(), Game->GetCurDMapScreen(), WARPEFFECT_INSTANT);
			break;
		case CUTSCENE_POSTSHELROND:
			Link->Item[165] = true;
			FoundItems[165] = true;
			Game->MCounter[CR_SOLARBATTERY] = 20;
			Game->MCounter[CR_LUNARBATTERY] = 20;
			Game->Counter[CR_SOLARBATTERY] = 20;
			Game->Counter[CR_LUNARBATTERY] = 20;
			Game->Counter[CR_STORYFLAG] = SFLAG_LEVEL1;
			DayNight[_DN_HOUR] = 4;
			DayNight[_DN_MINUTE] = 15;
			DayNight[_DN_SECOND] = 0;
			int x = 152;
			int y = 56;
			int scrn = 0x23;
			
			x += (scrn%16)*256;
			y += Floor(scrn/16)*176;
			if(LargeDistance(G[G_OWBOATX], G[G_OWBOATY], x, y, 16)>=24){
				G[G_OWBOATX] = x;
				G[G_OWBOATY] = y;
			}
			G[G_OWBOATDIR] = DIR_UP;
			LinkWarp(0, 29, 0x11, WARPEFFECT_INSTANT);
			break;
		case CUTSCENE_ENTEREDMALKA:
			if(GetCharID() == CHAR_TORRIN){
				G[G_ASHERHP] = G[G_ASHERMAXHP];
				SetCharacter(CHAR_ASHER, false);
			}
			G[G_TIMEFROZEN] = 0;
			Link->Invisible = false;
			Link->Item[I_TORRIN] = false;
			Game->Counter[CR_STORYFLAG] = SFLAG_TORRINMOM;
			if(DayNight_IsBetween(DAYNIGHT_MIDI_NIGHT_START_HOUR, 0, 0, DAYNIGHT_MIDI_NIGHT_END_HOUR, 0, 0))
				Game->PlayEnhancedMusic("SS-MalkaNight.ogg", 0);
			else
				Game->PlayEnhancedMusic("SS-Malka.ogg", 0);
			LinkPitWarp(Game->GetCurDMap(), Game->GetCurDMapScreen(), WARPEFFECT_INSTANT);
			break;
		case CUTSCENE_TORRINREJOINS:
			Link->Item[I_TORRIN] = true;
			Game->Counter[CR_STORYFLAG] = SFLAG_SHOALSOPEN;
			int Music[256];
			Game->GetDMapMusicFilename(Game->GetCurDMap(), Music);
			Game->PlayEnhancedMusic(Music, 0);
			G[G_TIMEFROZEN] = 0;
			LinkPitWarp(Game->GetCurDMap(), Game->GetCurDMapScreen(), WARPEFFECT_INSTANT);
			break;
		case CUTSCENE_SELETMINES:
			LinkWarp(0, 64, 0x0A, WARPEFFECT_INSTANT);
			break;
		case CUTSCENE_POSTSELETMINES:
			Game->Counter[CR_STORYFLAG] = SFLAG_ASHERKIDNAPPED;
			Link->Item[I_ASHER] = false;
			G[G_KAYLANIHP] = G[G_KAYLANIMAXHP];
			G[G_TORRINHP] = G[G_TORRINMAXHP];
			if(GetCharID() == CHAR_ASHER)
				SetCharacter(CHAR_TORRIN, false);
			DayNight[_DN_HOUR] = 1;
			DayNight[_DN_MINUTE] = 0;
			G[G_MAPDISABLED] = 0;
			G[G_TIMEFROZEN] = 0;
			if(Game->GetCurDMap()==14)
				LinkPitWarp(14, 0x16, WARPEFFECT_INSTANT);
			else
				LinkWarp(0, 14, 0x16, WARPEFFECT_INSTANT);
			Waitframe();
			Screen->D[1] = 1;
			break;
		case CUTSCENE_ASHERRESCUED:
			Game->Counter[CR_STORYFLAG] = SFLAG_POSTMANOR;
			Link->Item[I_TORRIN] = false;
			Link->Item[I_KAYLANI] = true;
			Link->HP = Link->MaxHP;
			DamageNumbers[_DNUM_LASTLINKHP] = Link->HP;
			G[G_KAYLANIHP] = G[G_KAYLANIMAXHP];
			G[G_TORRINHP] = G[G_TORRINMAXHP];
			SetCharacter(CHAR_KAYLANI, false);
			LinkWarp(0, 25, 0x43, WARPEFFECT_INSTANT);
			break;
		case CUTSCENE_CATACOMBS1:
		case CUTSCENE_CATACOMBS2:
			if(Game->Counter[CR_CATACOMBSPLOT] & SFLAG_TORRINCONVO){
				DayNight[_DN_HOUR] = 22;
				DayNight[_DN_MINUTE] = 0;
				DayNight[_DN_SECOND] = 0;
			}
			
			if(Game->Counter[CR_CATACOMBSPLOT] & SFLAG_KAYLANICONVOPRIMED){
				SetCharacter(CHAR_TORRIN, false);
				Link->Item[I_KAYLANI] = false;
				Link->Item[I_TORRIN] = true;
				Game->Counter[CR_CATACOMBSPLOT] &= ~SFLAG_KAYLANICONVOPRIMED;
				Game->Counter[CR_CATACOMBSPLOT] |= SFLAG_KAYLANICONVO;
			}
			if(Game->Counter[CR_CATACOMBSPLOT] & SFLAG_TORRINCONVOPRIMED){
				SetCharacter(CHAR_KAYLANI, false);
				Link->Item[I_TORRIN] = false;
				Link->Item[I_KAYLANI] = true;
				Game->Counter[CR_CATACOMBSPLOT] &= ~SFLAG_TORRINCONVOPRIMED;
				Game->Counter[CR_CATACOMBSPLOT] |= SFLAG_TORRINCONVO;
			}
			LinkWarp(0, 25, 0x43, WARPEFFECT_INSTANT);
			break;
		case CUTSCENE_EXITCATACOMBS:
			Game->Counter[CR_STORYFLAG] = SFLAG_ASHERRESCUED;
			Screen->State[ST_SECRET] = true;
			Game->MCounter[CR_STELLARBATTERY] = 20;
			Link->Item[I_ASHER] = true;
			Link->Item[I_TORRIN] = true;
			Link->Item[I_KAYLANI] = true;
			LinkPitWarp(Game->GetCurDMap(), Game->GetCurDMapScreen(), WARPEFFECT_INSTANT);
			break;
		case CUTSCENE_METGRANDMA:
			SetCharacter(CHAR_KAYLANI, false);
			Game->Counter[CR_STORYFLAG] = SFLAG_METGRANDMA;
			LinkPitWarp(Game->GetCurDMap(), Game->GetCurDMapScreen(), WARPEFFECT_INSTANT);
			break;
		case CUTSCENE_GRANDMA1:
			Link->Item[I_ASHER] = false;
			SetCharacter(CHAR_KAYLANI, false);
			Link->Item[I_TORRIN] = false;
			Link->Item[I_KAYLANI] = true;
			G[G_CUTSCENESKIPWARP] = 1;
			LinkPitWarp(32, 0x70, WARPEFFECT_INSTANT);
			WaitNoAction();
			Game->PlayEnhancedMusic("SS-Test.ogg", 0);
			ffc DoorLight = Screen->LoadFFC(1);
			DoorLight->Data = 0;
			DoorLight->Script = 0;
			Screen->ComboD[ComboAt(112, 144)] = 16638;
			Screen->ComboD[ComboAt(128, 144)] = 16639;
			Link->X = 120;
			Link->Y = 128;
			Link->Dir = DIR_UP;
			CreateNPCAt(230, 120, 48);
			Screen->D[0] = 0;
			break;
		case CUTSCENE_GRANDMA2:
			Link->Item[I_ASHER] = false;
			SetCharacter(CHAR_TORRIN, false);
			Link->Item[I_TORRIN] = true;
			Link->Item[I_KAYLANI] = false;
			G[G_CUTSCENESKIPWARP] = 1;
			LinkPitWarp(32, 0x70, WARPEFFECT_INSTANT);
			WaitNoAction();
			Game->PlayEnhancedMusic("SS-Test.ogg", 0);
			ffc DoorLight = Screen->LoadFFC(1);
			DoorLight->Data = 0;
			DoorLight->Script = 0;
			Screen->ComboD[ComboAt(112, 144)] = 16638;
			Screen->ComboD[ComboAt(128, 144)] = 16639;
			Link->X = 120;
			Link->Y = 128;
			Link->Dir = DIR_UP;
			CreateNPCAt(230, 120, 48);
			Screen->D[0] = 1;
			break;
		case CUTSCENE_GRANDMA3:
			Link->Item[I_ASHER] = true;
			SetCharacter(CHAR_ASHER, false);
			Link->Item[I_TORRIN] = false;
			Link->Item[I_KAYLANI] = false;
			G[G_CUTSCENESKIPWARP] = 1;
			LinkPitWarp(32, 0x70, WARPEFFECT_INSTANT);
			WaitNoAction();
			Game->PlayEnhancedMusic("SS-Test.ogg", 0);
			ffc DoorLight = Screen->LoadFFC(1);
			DoorLight->Data = 0;
			DoorLight->Script = 0;
			Screen->ComboD[ComboAt(112, 144)] = 17030;
			Screen->ComboD[ComboAt(128, 144)] = 17031;
			Link->X = 120;
			Link->Y = 128;
			Link->Dir = DIR_UP;
			CreateNPCAt(230, 120, 48);
			Screen->D[0] = 2;
			break;
		case CUTSCENE_GRANDMA4:
			G[G_HOURCLAMP] = 0;
			G[G_MINUTECLAMP] = 00;
			Link->Item[I_ASHER] = true;
			Link->Item[I_TORRIN] = true;
			Link->Item[I_KAYLANI] = true;
			Game->Counter[CR_STORYFLAG] = SFLAG_POSTGRANDMA;
			Link->X = 80;
			Link->Y = 64;
			LinkPitWarp(28, 0x02, WARPEFFECT_INSTANT);
			break;
		case CUTSCENE_POHOENTRY1:
			LinkWarp(0, 53, 0x73, WARPEFFECT_INSTANT);
			WaitNoAction();
			Game->Counter[CR_MISTFLAGS] |= BF_6;
			break;
		case CUTSCENE_POHOENTRY2:
			Link->X = 120;
			Link->Y = 128;
			Game->Counter[CR_STORYFLAG] = SFLAG_MISTENTERED;
			LinkPitWarp(Game->GetCurDMap(), Game->GetCurDMapScreen(), WARPEFFECT_INSTANT);	
			break;
		case CUTSCENE_POHO1A:
			Game->Counter[CR_MISTFLAGS] |= BF_0;
			LinkPitWarp(Game->GetCurDMap(), Game->GetCurDMapScreen(), WARPEFFECT_INSTANT);	
			break;
		case CUTSCENE_POHO1B:
			++Game->LKeys[Game->GetCurLevel()];
			Screen->State[ST_ITEM] = true;
			Game->Counter[CR_MISTFLAGS] |= BF_1;
			LinkPitWarp(Game->GetCurDMap(), Game->GetCurDMapScreen(), WARPEFFECT_INSTANT);	
			break;
		case CUTSCENE_POHO2A:
			Game->Counter[CR_MISTFLAGS] |= BF_2;
			LinkPitWarp(Game->GetCurDMap(), Game->GetCurDMapScreen(), WARPEFFECT_INSTANT);	
			break;
		case CUTSCENE_POHO2B:
			Game->Counter[CR_MISTFLAGS] |= BF_3;
			LinkPitWarp(Game->GetCurDMap(), Game->GetCurDMapScreen(), WARPEFFECT_INSTANT);	
			break;
		case CUTSCENE_POHO3:
			Game->Counter[CR_MISTFLAGS] |= BF_4;
			LinkPitWarp(Game->GetCurDMap(), Game->GetCurDMapScreen(), WARPEFFECT_INSTANT);	
			break;
		case CUTSCENE_POHO4:
			Game->Counter[CR_MISTFLAGS] |= BF_5;
			Screen->State[ST_SECRET] = true;
			LinkPitWarp(Game->GetCurDMap(), Game->GetCurDMapScreen(), WARPEFFECT_INSTANT);	
			break;
		case CUTSCENE_POHOEND:
			Game->Counter[CR_MISTFLAGS] |= BF_7;
			Screen->State[ST_SECRET] = true;
			LinkPitWarp(Game->GetCurDMap(), Game->GetCurDMapScreen(), WARPEFFECT_INSTANT);	
			break;
		case CUTSCENE_ESANENTRY:
			Link->Dir = DIR_UP;
			LinkWarp(0, 67, 0x62, WARPEFFECT_INSTANT);
			break;
		case CUTSCENE_POSTESAN:
			LinkWarp(0, 68, 0x00, WARPEFFECT_INSTANT);
			break;
		case CUTSCENE_GRANDMAPOSTPOHO:
			Game->Counter[CR_STORYFLAG] = SFLAG_ALIIOPEN;
			LinkWarp(0, 28, 0x02, WARPEFFECT_INSTANT);
			break;
		case CUTSCENE_OBSERVATORYENTRANCE:
			Screen->State[ST_SECRET] = true;
			LinkPitWarp(Game->GetCurDMap(), Game->GetCurDMapScreen(), WARPEFFECT_INSTANT);	
			break;
		case CUTSCENE_SELETFINAL1:
			LinkWarp(0, 66, 0x17, WARPEFFECT_INSTANT);
			break;
		case CUTSCENE_SELETFINAL2:
			FullHeal(true, true, true, true);
			LoreTracking[LT_ENEMIES+236] = 1;
			LinkWarp(0, 70, 0x07, WARPEFFECT_INSTANT);
			break;
		case CUTSCENE_ENDING:
			LinkWarp(0, 54, 0x75, WARPEFFECT_INSTANT);
			break;
	}
	Link->InputStart = false; 
	Link->PressStart = false;
	Waitframe();
	WaitTo(SCR_TIMING_POST_POLL_INPUT, false);
	Link->InputStart = false; 
	Link->PressStart = false;
	G[G_MSGACTIVE] = 0;
}

const int SFX_OUCHKAYLANI = SFX_OUCH;

int CutsceneSword(int layer, int who, int offX, int offY, int dir, int frame, int til, int cset, int mult){
	int x = Cutscene_GetAttr(who, CGI_X);
	int y = Cutscene_GetAttr(who, CGI_Y);
	switch(dir){
		case DIR_UP:
			if(frame<5)
				return Cutscene_NewTile(layer, x+16*mult+offX, y+offY, til+1, 1, 1, cset, -1, -1, 0, 0, 0, 0, true, 128);
			else if(frame<9)
				return Cutscene_NewTile(layer, x+12*mult+offX, y-12*mult+offY, til+3, 1, 1, cset, -1, -1, 0, 0, 0, 0, true, 128);
			else if(frame<13)
				return Cutscene_NewTile(layer, x+offX, y-16*mult+offY, til, 1, 1, cset, -1, -1, 0, 0, 0, 0, true, 128);
			break;
		case DIR_DOWN:
			if(frame<5)
				return Cutscene_NewTile(layer, x-16*mult+offX, y+offY, til+1, 1, 1, cset, -1, -1, 0, 0, 0, 1, true, 128);
			else if(frame<9)
				return Cutscene_NewTile(layer, x-12*mult+offX, y+12*mult+offY, til+4, 1, 1, cset, -1, -1, 0, 0, 0, 0, true, 128);
			else if(frame<13)
				return Cutscene_NewTile(layer, x+offX, y+16*mult+offY, til, 1, 1, cset, -1, -1, 0, 0, 0, 2, true, 128);
			break;
		case DIR_LEFT:
			if(frame<5)
				return Cutscene_NewTile(layer, x+offX, y-16*mult+offY, til, 1, 1, cset, -1, -1, 0, 0, 0, 0, true, 128);
			else if(frame<9)
				return Cutscene_NewTile(layer, x-12*mult+offX, y-12*mult+offY, til+5, 1, 1, cset, -1, -1, 0, 0, 0, 0, true, 128);
			else if(frame<13)
				return Cutscene_NewTile(layer, x-16*mult+offX, y+offY, til+1, 1, 1, cset, -1, -1, 0, 0, 0, 1, true, 128);
			break;
		case DIR_RIGHT:
			if(frame<5)
				return Cutscene_NewTile(layer, x+offX, y-16*mult+offY, til, 1, 1, cset, -1, -1, 0, 0, 0, 0, true, 128);
			else if(frame<9)
				return Cutscene_NewTile(layer, x+12*mult+offX, y-12*mult+offY, til+6, 1, 1, cset, -1, -1, 0, 0, 0, 0, true, 128);
			else if(frame<13)
				return Cutscene_NewTile(layer, x+16*mult+offX, y+offY, til+1, 1, 1, cset, -1, -1, 0, 0, 0, 0, true, 128);
			break;
	}
}

bool CutsceneSpriteCollision(int spr1, int spr2, int trim){
	int x1 = CutX(spr1);
	int y1 = CutY(spr1);
	int w1 = Max(Cutscene_GetAttr(spr1, CGI_WIDTH)*16, 16);
	int h1 = Max(Cutscene_GetAttr(spr1, CGI_HEIGHT)*16, 16);
	int x2 = CutX(spr2);
	int y2 = CutY(spr2);
	int w2 = Max(Cutscene_GetAttr(spr2, CGI_WIDTH)*16, 16);
	int h2 = Max(Cutscene_GetAttr(spr2, CGI_HEIGHT)*16, 16);
	// Screen->Rectangle(7, x1, y1, x1+w1-1, y1+h1-1, 0x01, 1, 0, 0, 0, true, 64);
	// Screen->Rectangle(7, x2, y2, x2+w2-1, y2+h2-1, 0x0E, 1, 0, 0, 0, true, 64);
	return RectCollision(x1+trim, y1+trim, x1+w1-1-trim, y1+h1-1-trim, x2+trim, y2+trim, x2+w2-1-trim, y2+h2-1-trim);
}

int CutX(int spr){
	return Cutscene_GetAttr(spr, CGI_X);
}

int CutY(int spr){
	return Cutscene_GetAttr(spr, CGI_Y);
}

int CutCamX(){
	return cutsceneG[CG_CAMX];
}

int CutCamY(){
	return cutsceneG[CG_CAMY];
}

void Cutscene_SetDir(int spr, int dir){
	Cutscene_SetAttr(spr, CGI_DIR, dir);
}

void Cutscene_PlayString(int str, int charID, int emote, int x, int y){
	PlayString(str, charID, emote, x, y);
	while(G[G_MSGACTIVE]){
		G[G_NOACTION] = 1;
		Cutscene_Waitframe2();
	}
}

void Cutscene_WaitString(){
	while(G[G_MSGACTIVE]){
		G[G_NOACTION] = 1;
		Cutscene_Waitframe2();
	}
}

bool WalkLinkToPoint(int tX, int tY){
	NoAction();
	if(Link->X!=tX){
		if(Abs(Link->X-tX)<=2){
			Link->X = tX;
		}
		else{
			if(Link->X<tX)
				Link->InputRight = true;
			else
				Link->InputLeft = true;
		}
	}
	if(Link->Y!=tY){
		if(Abs(Link->Y-tY)<=2){
			Link->Y = tY;
		}
		else{
			if(Link->Y<tY)
				Link->InputDown = true;
			else
				Link->InputUp = true;
		}
	}
	if(Link->X==tX&&Link->Y==tY)
		return true;
}

const int TIL_STARS = 23066;

//Y positions for text boxes
const int YPOS_UPPER = 24;
const int YPOS_LOWER = 112;

void DrawSpaceTunnel(bitmap b, int stars){
	DrawSpaceTunnel(b, stars, true);
}
	
void DrawSpaceTunnel(bitmap b, int stars, bool starsMove){
	int starDist = stars[0];
	int starAng = stars[1];
	int starStep = stars[2];
	
	int numStars = SizeOfArray(starDist);
	
	b->ClearToColor(0, 0x7F);
	
	for(int i=0; i<numStars; ++i){
		int size = 5-Clamp(Floor(starDist[i]/42), 0, 5);
		if(starDist[i]>=8)
			b->FastTile(0, 120+VectorX(starDist[i], starAng[i]), 80+VectorY(starDist[i], starAng[i]), TIL_STARS+size, 7, starDist[i]>=32?128:64);
		if(starsMove)
			starDist[i] += Lerp(starStep[i]/2, starStep[i], starDist[i]/256);
		if(starStep[i]==0){
			starStep[i] = Rand(4, 6);
		}
		if(starDist[i]>=256){
			starDist[i] = 0;
			starAng[i] = Rand(360);
		}
	}
}

ffc script IntroCutscene{
	void ZoomBlur(bitmap b, bitmap b2, bitmap b3, int extend, bool secondBitmap){
		if(secondBitmap){
			b->BlitTo(0, b3, 0, 0, 256, 176, 128-extend/2, 128-extend/2, 256+extend, 176+extend, 0, 0, 0, 0, 0, false);
			b2->BlitTo(0, b3, 0, 0, 256, 176, 128-extend, 128-extend, 256+extend*2, 176+extend*2, 0, 0, 0, 0, 0, false);
			b->Blit(6, RT_SCREEN, 128, 128, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_TRANS, 0, false);
			b2->Blit(6, RT_SCREEN, 128, 128, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_TRANS, 0, false);
		}
		else{
			b->BlitTo(0, RT_BITMAP2, 0, 0, 256, 176, 128-extend/2, 128-extend/2, 256+extend, 176+extend, 0, 0, 0, 0, 0, false);
			b2->BlitTo(0, RT_BITMAP2, 0, 0, 256, 176, 128-extend, 128-extend, 256+extend*2, 176+extend*2, 0, 0, 0, 0, 0, false);
			b->Blit(6, RT_SCREEN, 128, 128, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_TRANS, 0, false);
			b2->Blit(6, RT_SCREEN, 128, 128, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_TRANS, 0, false);
		}
	}
	void DrawCosmicEgg(int layer, bitmap b, int x, int y, int state, int op){
		const int TIL_COSMICEGG = 64005;
		b->Clear(0);
		b->DrawCombo(0, 0, 0, TIL_COSMICEGG, 2, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 128);
		switch(state){
			case 0: //Black
				b->DrawCombo(0, 0, 0, TIL_COSMICEGG+2, 2, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 128);
				break;
			case 1: //2x dark
				b->DrawCombo(0, 0, 0, TIL_COSMICEGG+2, 2, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 64);
				b->DrawCombo(0, 0, 0, TIL_COSMICEGG+2, 2, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 64);
				break;
			case 2: //1x dark
				b->DrawCombo(0, 0, 0, TIL_COSMICEGG+2, 2, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 64);
				break;
			case 4: //1x light
				b->DrawCombo(0, 0, 0, TIL_COSMICEGG+1, 2, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 64);
				break;
			case 5: //2x light
				b->DrawCombo(0, 0, 0, TIL_COSMICEGG+1, 2, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 64);
				b->DrawCombo(0, 0, 0, TIL_COSMICEGG+1, 2, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 64);
				break;
			case 6: //White
				b->DrawCombo(0, 0, 0, TIL_COSMICEGG+1, 2, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 128);
				break;	
		}
		switch(op){
			case 2:
				b->Blit(layer, RT_SCREEN, 0, 0, 32, 32, x, y, 32, 32, 0, 0, 0, 0, 0, true);
				break;
			case 1:
				b->Blit(layer, RT_SCREEN, 0, 0, 32, 32, x, y, 32, 32, 0, 0, 0, BITDX_TRANS, 0, true);
				b->Blit(layer, RT_SCREEN, 0, 0, 32, 32, x, y, 32, 32, 0, 0, 0, BITDX_TRANS, 0, true);
				break;
			case 0:
				b->Blit(layer, RT_SCREEN, 0, 0, 32, 32, x, y, 32, 32, 0, 0, 0, BITDX_TRANS, 0, true);
				break;
		}
	}
	void run(){
		int saveName[9];
		Game->GetSaveName(saveName);
		ltou(saveName);
		if(strcmp(saveName, "SHIRT")==0||strcmp(saveName, "SSRAND")==0){
			Waitframes(8);
			Link->Warp(77, 0x08);
			WaitNoAction();
			Quit();
		}
		if(strcmp(saveName, "SKIP")==0){
			G[G_CUTSCENESKIP] = 1;
		}
		if(strcmp(saveName, "CHORIZO")==0){
			WaitNoAction(2);
			PlayStringAndWait("Oh wow! It's been a while since someone's come over to play. I may be a kid, but don't go easy on me now...", SCHAR_CHASE, EMOTE_NORMAL);
			this->Flags[FFCF_CARRYOVER] = false;
			ChaseDebug();
			WaitNoAction();
			Quit();
		}
		const int TIL_ASHERFACEDOWN = 117140;
		Waitframe();
		Game->PlayEnhancedMusic("SS-Boss.ogg", 0);
		int i; int j; int k; int m;
		int x; int y;
		int angle;
		
		int starDist[128];
		int starAng[128];
		int starStep[128];
		int stars[] = {starDist, starAng, starStep};
		
		for(i=0; i<128; ++i){
			starDist[i] = Rand(256);
			starAng[i] = Rand(360);
		}
		
		SetCutsceneSkip(CUTSCENE_INTRO);
		Cutscene_Init(RT_BITMAP1, RT_BITMAP2);
		Cutscene_SetActiveLayers(1, 1, 1, 1, 1, 1, 0);
		int asher = Cutscene_NewNPC(3, 120, 176, 50944, 6, 128);
		Cutscene_SetFlag(asher, CGF_4WAY|CGF_BS|CGF_BIGNPC);
		Cutscene_SetAttr(asher, CGI_DIR, DIR_UP);
		int npcs[3];
		npcs[0] = Cutscene_NewNPC(2, 96, -16-48, 33372, 0, 128);
		npcs[1] = Cutscene_NewNPC(2, 112, -16, 33340, 0, 128);
		npcs[2] = Cutscene_NewNPC(2, 144, -16-32, 33364, 0, 128);
		Cutscene_SetFlag(npcs[0], CGF_4WAY|CGF_BIGNPC);
		Cutscene_SetFlag(npcs[1], CGF_4WAY|CGF_BIGNPC);
		Cutscene_SetFlag(npcs[2], CGF_4WAY|CGF_BIGNPC);
		Cutscene_Glide(npcs[0], Game->GetCurScreen(), 96, 192, 1.8);
		Cutscene_Glide(npcs[1], Game->GetCurScreen(), 112, 192, 2);
		Cutscene_Glide(npcs[2], Game->GetCurScreen(), 144, 192, 1.6);
		
		Cutscene_Waitglide();
		
		int monsters[6];
		bool monsterDead[6];
		monsters[0] = Cutscene_NewNPC(2, 96, -16-32, 50968, 8, 128);
		monsters[1] = Cutscene_NewNPC(2, 112, -16-32, 50968, 8, 128);
		monsters[2] = Cutscene_NewNPC(2, 128, -16-32, 50968, 8, 128);
		monsters[3] = Cutscene_NewNPC(2, 144, -16-32, 50968, 8, 128);
		monsters[4] = Cutscene_NewNPC(2, 96, -16-48, 50968, 8, 128);
		monsters[5] = Cutscene_NewNPC(2, 144, -16-48, 50968, 7, 128);
		Cutscene_Glide(monsters[0], Game->GetCurScreen(), 96, 80, 1.2);
		Cutscene_Glide(monsters[1], Game->GetCurScreen(), 112, 88, 1);
		Cutscene_Glide(monsters[2], Game->GetCurScreen(), 128, 72, 1.1);
		Cutscene_Glide(monsters[3], Game->GetCurScreen(), 144, 80, 0.9);
		Cutscene_Glide(monsters[4], Game->GetCurScreen(), 112, 64, 0.8);
		Cutscene_Glide(monsters[5], Game->GetCurScreen(), 128, 48, 0.6);
		
		Cutscene_Waitglide();
		
		Cutscene_Glide(asher, Game->GetCurScreen(), 120, 144, 1.1);
		
		Cutscene_Waitglide();
		Cutscene_Waitframe(24);
		
		PlayString("Looks like I got here just in time! Now then...", SCHAR_ASHERARMOR, EMOTE_NORMAL, 68, 24);
		while(G[G_MSGACTIVE]){
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		Game->PlaySound(SFX_SWORD);
		for(i=0; i<16; ++i){
			CutsceneSword(2, asher, 0, 2, Cutscene_GetAttr(asher, CGI_DIR), 0, 117081, 8, 0.8);
			Cutscene_Waitframe2();
		}
		PlayString("Who's first?", SCHAR_ASHERARMOR, EMOTE_NORMAL, 68, 24);
		while(G[G_MSGACTIVE]){
			CutsceneSword(2, asher, 0, 2, Cutscene_GetAttr(asher, CGI_DIR), 0, 117081, 8, 0.8);
			Cutscene_Waitframe2();
		}
		int tx[3];
		int ty[3];
		tx[0] = CutX(monsters[0]);
		ty[0] = CutY(monsters[0]);
		tx[1] = CutX(monsters[3]);
		ty[1] = CutY(monsters[3]);
		tx[2] = CutX(monsters[4]);
		ty[2] = CutY(monsters[4]);
		for(i=0; i<3; ++i){
			x = tx[i];
			y = ty[i];
			angle = Angle(x, y, CutX(asher), CutY(asher));
			Cutscene_SetAttr(asher, CGI_DIR, AngleDir4(WrapDegrees(angle+180)));
			x += VectorX(24, angle);
			y += VectorY(24, angle);
			Cutscene_Glide(asher, Game->GetCurScreen(), x, y, 1.5);
			while(cutsceneG[CG_NUMGLIDING]>0){
				CutsceneSword(2, asher, 0, 2, Cutscene_GetAttr(asher, CGI_DIR), 0, 117081, 8, 0.8);
				Cutscene_Waitframe();
			}
			Game->PlaySound(SFX_SWORD);
			Cutscene_SetNPCGraphic(asher, 50976);
			for(j=0; j<13; ++j){
				k = CutsceneSword(2, asher, 0, 0, Cutscene_GetAttr(asher, CGI_DIR), j, 117081, 8, 1);
				for(m=0; m<6; ++m){
					if(!monsterDead[m]){
						if(CutsceneSpriteCollision(k, monsters[m], 2)){
							Game->PlaySound(SFX_EDEAD);
							Cutscene_NewAnim(2, CutX(monsters[m]), CutY(monsters[m]), 404, 1, 1, 11, -1, -1, 0, 0, 0, 0, true, 128, 4, 4);
							Cutscene_RemoveDraw(monsters[m]);
							monsterDead[m] = true;
						}
					}
				}
				Cutscene_Waitframe();
			}
			Cutscene_SetNPCGraphic(asher, 50944);
		}
		Cutscene_SetAttr(asher, CGI_DIR, DIR_RIGHT);
		Cutscene_SetAttr(monsters[5], CGI_DIR, DIR_DOWN);
		Cutscene_Glide(asher, Game->GetCurScreen(), CutX(asher)-8, CutY(asher)-8, 1.5);
		Cutscene_Glide(monsters[5], Game->GetCurScreen(), CutX(monsters[5]), CutY(monsters[5])+16, 2);
		while(!Cutscene_FinishedGlide(monsters[5])){
			Cutscene_Waitframe();
		}
		Cutscene_SetNPCGraphic(monsters[5], 50984);
		eweapon brang = FireNonAngularEWeapon(EW_BRANG, CutX(monsters[5]), CutY(monsters[5]), DIR_DOWN, 100, 0, -1, -1, 0);
		brang->CollDetection = false;
		while(brang->isValid()){
			Cutscene_NewFastTile(2, brang->X, brang->Y, brang->Tile, brang->CSet, 128);
			Cutscene_Waitframe();
		}
		Cutscene_SetNPCGraphic(monsters[5], 50968);
		Cutscene_SetNPCGraphic(asher, 50976);
		Game->PlaySound(SFX_SWORD);
		for(j=0; j<13; ++j){
			k = CutsceneSword(2, asher, 0, 0, Cutscene_GetAttr(asher, CGI_DIR), j, 117081, 8, 1);
			for(m=0; m<6; ++m){
				if(!monsterDead[m]){
					if(CutsceneSpriteCollision(k, monsters[m], 2)){
						Game->PlaySound(SFX_EDEAD);
						Cutscene_NewAnim(2, CutX(monsters[m]), CutY(monsters[m]), 404, 1, 1, 11, -1, -1, 0, 0, 0, 0, true, 128, 4, 4);
						Cutscene_RemoveDraw(monsters[m]);
						monsterDead[m] = true;
					}
				}
			}
			Cutscene_Waitframe();
		}
		Cutscene_SetNPCGraphic(asher, 50944);
		Cutscene_SetAttr(asher, CGI_DIR, DIR_DOWN);
		Cutscene_Waitframe(32);
		Game->PlayMIDI(0);
		Cutscene_Glide(asher, Game->GetCurScreen(), CutX(asher), CutY(asher)+24, 0.8);
		Cutscene_Waitglide();
		PlayString("And that takes care of that. No need to hide, the situation's under control!", SCHAR_ASHERARMOR, EMOTE_HAPPY, 68, 24);
		while(G[G_MSGACTIVE]){
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		Cutscene_Waitframe(32);
		
		int bitid = TempBitmap_Create(0, 512, 512);
		bitmap b = TempBMP[bitid];
		int bitid2 = TempBitmap_Create(0, 512, 512);
		bitmap b2 = TempBMP[bitid2];
		int bitid3 = TempBitmap_Create(0, 256, 176);
		bitmap b3 = TempBMP[bitid3];
		int bitid4 = TempBitmap_Create(0, 32, 32);
		bitmap b4 = TempBMP[bitid4];
			
		Game->PlaySound(115);
		for(i=0; i<32; ++i){
			Cutscene_Update();
			Link->InputMap = false; Link->PressMap = false;
			Link->InputStart = false; Link->PressStart = false;
			NoAction();
			ZoomBlur(b, b2, b3, 16*Sin(i/32*180), false);
			Waitframe();
		}
		Cutscene_Waitframe(16);
		
		PlayString("Uh... hello?", SCHAR_ASHERARMOR, EMOTE_NORMAL, 68, 24);
		while(G[G_MSGACTIVE]){
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		
		Cutscene_Waitframe(32);
		Game->PlaySound(115);
		for(i=0; i<32; ++i){
			Cutscene_Update();
			Link->InputMap = false; Link->PressMap = false;
			Link->InputStart = false; Link->PressStart = false;
			NoAction();
			ZoomBlur(b, b2, b3, 16*Sin(i/32*180), false);
			Waitframe();
		}
		Cutscene_Waitframe(24);
		Game->PlaySound(115);
		for(i=0; i<32; ++i){
			Cutscene_Update();
			Link->InputMap = false; Link->PressMap = false;
			Link->InputStart = false; Link->PressStart = false;
			NoAction();
			ZoomBlur(b, b2, b3, 24*Sin(i/32*180), false);
			Waitframe();
		}
		int asherX = CutX(asher);
		int asherY = CutY(asher);
		int asherAngle = 0;
		Cutscene_Waitframe(16);
		Game->PlaySound(115);
		for(i=0; i<32; ++i){
			Cutscene_Update();
			DrawSpaceTunnel(b3, stars);
			x = asherX+VectorX(-8, asherAngle+90);
			y = asherY+VectorY(-8, asherAngle+90);
			b3->DrawTile(0, x, y, TIL_ASHERFACEDOWN, 1, 2, 6, -1, -1, x, y, asherAngle, 0, true, 128);
			Link->InputMap = false; Link->PressMap = false;
			Link->InputStart = false; Link->PressStart = false;
			NoAction();
			ZoomBlur(b, b2, b3, 32*Sin(i/32*180), i>16);if(i>16)
				b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
			ZoomBlur(b, b2, b3, 32*Sin(i/32*180), i>16);
			Waitframe();
		}
		for(i=0; i<64; ++i){
			DrawSpaceTunnel(b3, stars);
			x = asherX+VectorX(-8, asherAngle+90);
			y = asherY+VectorY(-8, asherAngle+90);
			b3->DrawTile(0, x, y, TIL_ASHERFACEDOWN, 1, 2, 6, -1, -1, x, y, asherAngle, 0, true, 128);
			b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
			asherAngle = WrapDegrees(asherAngle+2);
			Link->InputMap = false; Link->PressMap = false;
			Link->InputStart = false; Link->PressStart = false;
			NoAction();
			Waitframe();
		}
		PlayString("What on earth? What's going on?", SCHAR_ASHERARMOR, EMOTE_NORMAL, 68, 24);
		while(G[G_MSGACTIVE]){
			G[G_NOACTION] = 1;
			DrawSpaceTunnel(b3, stars);
			x = asherX+VectorX(-8, asherAngle+90);
			y = asherY+VectorY(-8, asherAngle+90);
			b3->DrawTile(0, x, y, TIL_ASHERFACEDOWN, 1, 2, 6, -1, -1, x, y, asherAngle, 0, true, 128);
			b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
			asherAngle = WrapDegrees(asherAngle+2);
			Link->InputMap = false; Link->PressMap = false;
			Link->InputStart = false; Link->PressStart = false;
			Waitframe();
		}
		Game->PlayEnhancedMusic("SS-Cosmic.ogg", 0);
		for(i=0; i<64; ++i){ //Egg appears
			DrawSpaceTunnel(b3, stars);
			x = asherX+VectorX(-8, asherAngle+90);
			y = asherY+VectorY(-8, asherAngle+90);
			b3->DrawTile(0, x, y, TIL_ASHERFACEDOWN, 1, 2, 6, -1, -1, x, y, asherAngle, 0, true, 128);
			b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
			asherAngle = WrapDegrees(asherAngle+2);
			Link->InputMap = false; Link->PressMap = false;
			Link->InputStart = false; Link->PressStart = false;
			DrawCosmicEgg(6, b4, 112, Lerp(-16, 48, i/64), Floor(Lerp(0, 3, i/64)), Floor(Lerp(0, 2, i/64)));
			NoAction();
			Waitframe();
		}
		for(i=0; i<96; ++i){ //Egg slow
			DrawSpaceTunnel(b3, stars);
			x = asherX+VectorX(-8, asherAngle+90);
			y = asherY+VectorY(-8, asherAngle+90);
			b3->DrawTile(0, x, y, TIL_ASHERFACEDOWN, 1, 2, 6, -1, -1, x, y, asherAngle, 0, true, 128);
			b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
			asherAngle = WrapDegrees(asherAngle+2);
			Link->InputMap = false; Link->PressMap = false;
			Link->InputStart = false; Link->PressStart = false;
			DrawCosmicEgg(6, b4, 112, Lerp(48, 64, i/96), 3, 2);
			NoAction();
			Waitframe();
		}
		for(i=0; i<32; ++i){ //Egg disappears
			DrawSpaceTunnel(b3, stars);
			x = asherX+VectorX(-8, asherAngle+90);
			y = asherY+VectorY(-8, asherAngle+90);
			b3->DrawTile(0, x, y, TIL_ASHERFACEDOWN, 1, 2, 6, -1, -1, x, y, asherAngle, 0, true, 128);
			b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
			asherAngle = WrapDegrees(asherAngle+2);
			Link->InputMap = false; Link->PressMap = false;
			Link->InputStart = false; Link->PressStart = false;
			DrawCosmicEgg(6, b4, 112, 64, Floor(Lerp(3, 6, i/32)), Floor(Lerp(2, 0, i/32)));
			NoAction();
			Waitframe();
		}
		PlayString("Whoa... what are you?", SCHAR_ASHERARMOR, EMOTE_NORMAL, 68, 24);
		while(G[G_MSGACTIVE]){
			G[G_NOACTION] = 1;
			DrawSpaceTunnel(b3, stars);
			x = asherX+VectorX(-8, asherAngle+90);
			y = asherY+VectorY(-8, asherAngle+90);
			b3->DrawTile(0, x, y, TIL_ASHERFACEDOWN, 1, 2, 6, -1, -1, x, y, asherAngle, 0, true, 128);
			b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
			asherAngle = WrapDegrees(asherAngle+2);
			Link->InputMap = false; Link->PressMap = false;
			Link->InputStart = false; Link->PressStart = false;
			Waitframe();
		}
		for(i=0; i<64; ++i){ //Egg appears
			DrawSpaceTunnel(b3, stars);
			x = asherX+VectorX(-8, asherAngle+90);
			y = asherY+VectorY(-8, asherAngle+90);
			b3->DrawTile(0, x, y, TIL_ASHERFACEDOWN, 1, 2, 6, -1, -1, x, y, asherAngle, 0, true, 128);
			b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
			asherAngle = WrapDegrees(asherAngle+2);
			Link->InputMap = false; Link->PressMap = false;
			Link->InputStart = false; Link->PressStart = false;
			DrawCosmicEgg(6, b4, Lerp(16, 48, i/64), Lerp(16, 48, i/64), Floor(Lerp(0, 3, i/64)), Floor(Lerp(0, 2, i/64)));
			NoAction();
			Waitframe();
		}
		for(i=0; i<96; ++i){ //Egg slow
			DrawSpaceTunnel(b3, stars);
			x = asherX+VectorX(-8, asherAngle+90);
			y = asherY+VectorY(-8, asherAngle+90);
			b3->DrawTile(0, x, y, TIL_ASHERFACEDOWN, 1, 2, 6, -1, -1, x, y, asherAngle, 0, true, 128);
			b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
			asherAngle = WrapDegrees(asherAngle+2);
			Link->InputMap = false; Link->PressMap = false;
			Link->InputStart = false; Link->PressStart = false;
			DrawCosmicEgg(6, b4, Lerp(48, 64, i/96), Lerp(48, 64, i/96), 3, 2);
			NoAction();
			Waitframe();
		}
		for(i=0; i<32; ++i){ //Egg disappears
			DrawSpaceTunnel(b3, stars);
			x = asherX+VectorX(-8, asherAngle+90);
			y = asherY+VectorY(-8, asherAngle+90);
			b3->DrawTile(0, x, y, TIL_ASHERFACEDOWN, 1, 2, 6, -1, -1, x, y, asherAngle, 0, true, 128);
			b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
			asherAngle = WrapDegrees(asherAngle+2);
			Link->InputMap = false; Link->PressMap = false;
			Link->InputStart = false; Link->PressStart = false;
			DrawCosmicEgg(6, b4, 64, 64, Floor(Lerp(3, 6, i/32)), Floor(Lerp(2, 0, i/32)));
			NoAction();
			Waitframe();
		}
		PlayString("Asher!", SCHAR_UNKNOWN, EMOTE_NORMAL, 68, 24);
		while(G[G_MSGACTIVE]){
			G[G_NOACTION] = 1;
			DrawSpaceTunnel(b3, stars);
			x = asherX+VectorX(-8, asherAngle+90);
			y = asherY+VectorY(-8, asherAngle+90);
			b3->DrawTile(0, x, y, TIL_ASHERFACEDOWN, 1, 2, 6, -1, -1, x, y, asherAngle, 0, true, 128);
			b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
			asherAngle = WrapDegrees(asherAngle+2);
			Link->InputMap = false; Link->PressMap = false;
			Link->InputStart = false; Link->PressStart = false;
			Waitframe();
		}
		for(i=0; i<64; ++i){ //Egg appears
			DrawSpaceTunnel(b3, stars);
			x = asherX+VectorX(-8, asherAngle+90);
			y = asherY+VectorY(-8, asherAngle+90);
			b3->DrawTile(0, x, y, TIL_ASHERFACEDOWN, 1, 2, 6, -1, -1, x, y, asherAngle, 0, true, 128);
			b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
			asherAngle = WrapDegrees(asherAngle+2);
			Link->InputMap = false; Link->PressMap = false;
			Link->InputStart = false; Link->PressStart = false;
			DrawCosmicEgg(6, b4, Lerp(208, 176, i/64), Lerp(16, 48, i/64), Floor(Lerp(0, 3, i/64)), Floor(Lerp(0, 2, i/64)));
			NoAction();
			Waitframe();
		}
		for(i=0; i<96; ++i){ //Egg slow
			DrawSpaceTunnel(b3, stars);
			x = asherX+VectorX(-8, asherAngle+90);
			y = asherY+VectorY(-8, asherAngle+90);
			b3->DrawTile(0, x, y, TIL_ASHERFACEDOWN, 1, 2, 6, -1, -1, x, y, asherAngle, 0, true, 128);
			b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
			asherAngle = WrapDegrees(asherAngle+2);
			Link->InputMap = false; Link->PressMap = false;
			Link->InputStart = false; Link->PressStart = false;
			DrawCosmicEgg(6, b4, Lerp(176, 160, i/96), Lerp(48, 64, i/96), 3, 2);
			NoAction();
			Waitframe();
		}
		for(i=0; i<32; ++i){ //Egg disappears
			DrawSpaceTunnel(b3, stars);
			x = asherX+VectorX(-8, asherAngle+90);
			y = asherY+VectorY(-8, asherAngle+90);
			b3->DrawTile(0, x, y, TIL_ASHERFACEDOWN, 1, 2, 6, -1, -1, x, y, asherAngle, 0, true, 128);
			b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
			asherAngle = WrapDegrees(asherAngle+2);
			Link->InputMap = false; Link->PressMap = false;
			Link->InputStart = false; Link->PressStart = false;
			DrawCosmicEgg(6, b4, 160, 64, Floor(Lerp(3, 6, i/32)), Floor(Lerp(2, 0, i/32)));
			NoAction();
			Waitframe();
		}
		PlayString("Asher! Up!", SCHAR_UNKNOWN, EMOTE_NORMAL, 68, 24);
		while(G[G_MSGACTIVE]){
			G[G_NOACTION] = 1;
			DrawSpaceTunnel(b3, stars);
			x = asherX+VectorX(-8, asherAngle+90);
			y = asherY+VectorY(-8, asherAngle+90);
			b3->DrawTile(0, x, y, TIL_ASHERFACEDOWN, 1, 2, 6, -1, -1, x, y, asherAngle, 0, true, 128);
			b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
			asherAngle = WrapDegrees(asherAngle+2);
			Link->InputMap = false; Link->PressMap = false;
			Link->InputStart = false; Link->PressStart = false;
			Waitframe();
		}
		for(i=0; i<3; ++i){
			for(j=0; j<24; ++j){
				DrawSpaceTunnel(b3, stars);
				x = asherX+VectorX(-8, asherAngle+90);
				y = asherY+VectorY(-8, asherAngle+90);
				b3->DrawTile(0, x, y, TIL_ASHERFACEDOWN, 1, 2, 6, -1, -1, x, y, asherAngle, 0, true, 128);
				b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
				asherAngle = WrapDegrees(asherAngle+2);
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				if(j<12){
					if(j>=8){
						Screen->Rectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
					}
					else{
						if(j>=4)
							Screen->Rectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
						Screen->Rectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
					}
				}
				else{
					if(j<=16){
						Screen->Rectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
					}
					else{
						if(j<=20)
							Screen->Rectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
						Screen->Rectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
					}
				}
				if(j==12)
					++i;
				if(i==2){
					Screen->Rectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
				}
				else{
					if(i>0)
						Screen->Rectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
				}
				NoAction();
				Waitframe();
			}
			--i;
			for(j=0; j<64; ++j){
				DrawSpaceTunnel(b3, stars);
				x = asherX+VectorX(-8, asherAngle+90);
				y = asherY+VectorY(-8, asherAngle+90);
				b3->DrawTile(0, x, y, TIL_ASHERFACEDOWN, 1, 2, 6, -1, -1, x, y, asherAngle, 0, true, 128);
				b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
				asherAngle = WrapDegrees(asherAngle+2);
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				if(i==2){
					Screen->Rectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
				}
				else{
					if(i>0)
						Screen->Rectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
					Screen->Rectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
				}
				NoAction();
				Waitframe();
			}
		}
		this->Flags[FFCF_CARRYOVER] = true;
		Link->Invisible = true;
		Link->Warp(15, 0x50);
		DayNight[_DN_HOUR] = 8;
		DayNight[_DN_MINUTE] = 30;
		DayNight[_DN_SECOND] = 0;
		G[G_HOURCLAMP] = 11;
		G[G_MINUTECLAMP] = 59;
		G[G_TIMEFROZEN] = 1;
		for(int i=0; i<120; ++i){
			if(i<40){
				Screen->Rectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
			}
			else{
				if(i<80)
					Screen->Rectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
				Screen->Rectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
			}
			Screen->DrawTile(2, 32, 48, 33705, 2, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
			Screen->DrawCombo(2, 64, 48, 33510, 1, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 128);
			WaitNoAction();
		}
		PlayString("C'mon Asher, it's past 8 already. Are you planning on sleeping the whole day away?", SCHAR_MOM, EMOTE_NORMAL, 68, 112);
		while(G[G_MSGACTIVE]){
			G[G_NOACTION] = 1;
			Screen->DrawTile(2, 32, 48, 33705, 2, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
			Screen->DrawCombo(2, 64, 48, 33510, 1, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 128);
			Link->InputMap = false; Link->PressMap = false;
			Link->InputStart = false; Link->PressStart = false;
			Waitframe();
		}
		PlayString("I was considering it. Why are you waking me up? It's Iris's turn to unload the boat today.", SCHAR_ASHER, EMOTE_NORMAL, 68, 112);
		while(G[G_MSGACTIVE]){
			G[G_NOACTION] = 1;
			Screen->DrawTile(2, 32, 48, 33705, 2, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
			Screen->DrawCombo(2, 64, 48, 33510, 1, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 128);
			Link->InputMap = false; Link->PressMap = false;
			Link->InputStart = false; Link->PressStart = false;
			Waitframe();
		}
		PlayString("Change of plans. No cargo today. Those damned pirates intercepted it.", SCHAR_MOM, EMOTE_NORMAL, 68, 112);
		while(G[G_MSGACTIVE]){
			G[G_NOACTION] = 1;
			Screen->DrawTile(2, 32, 48, 33705, 2, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
			Screen->DrawCombo(2, 64, 48, 33510, 1, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 128);
			Link->InputMap = false; Link->PressMap = false;
			Link->InputStart = false; Link->PressStart = false;
			Waitframe();
		}
		PlayString("They're hitting the supply ships now? Why isn't anyone doing anything?", SCHAR_ASHER, EMOTE_SURPRISED, 68, 112);
		while(G[G_MSGACTIVE]){
			G[G_NOACTION] = 1;
			Screen->DrawTile(2, 32, 48, 33705, 2, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
			Screen->DrawCombo(2, 64, 48, 33510, 1, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 128);
			Link->InputMap = false; Link->PressMap = false;
			Link->InputStart = false; Link->PressStart = false;
			Waitframe();
		}
		PlayString("That's a great question. Why don't you ask around while you're in Pala Bay?", SCHAR_MOM, EMOTE_NORMAL, 68, 112);
		while(G[G_MSGACTIVE]){
			G[G_NOACTION] = 1;
			Screen->DrawTile(2, 32, 48, 33705, 2, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
			Screen->DrawCombo(2, 64, 48, 33510, 1, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 128);
			Link->InputMap = false; Link->PressMap = false;
			Link->InputStart = false; Link->PressStart = false;
			Waitframe();
		}
		PlayString("Huh? I'm not going to Pala Bay anytime soon.", SCHAR_ASHER, EMOTE_QUESTION, 68, 112);
		while(G[G_MSGACTIVE]){
			G[G_NOACTION] = 1;
			Screen->DrawTile(2, 32, 48, 33705, 2, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
			Screen->DrawCombo(2, 64, 48, 33510, 1, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 128);
			Link->InputMap = false; Link->PressMap = false;
			Link->InputStart = false; Link->PressStart = false;
			Waitframe();
		}
		PlayString("You are now. I've got a list of groceries, and you're picking them up for me.", SCHAR_MOM, EMOTE_NORMAL, 68, 112);
		while(G[G_MSGACTIVE]){
			G[G_NOACTION] = 1;
			Screen->DrawTile(2, 32, 48, 33705, 2, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
			Screen->DrawCombo(2, 64, 48, 33510, 1, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 128);
			Link->InputMap = false; Link->PressMap = false;
			Link->InputStart = false; Link->PressStart = false;
			Waitframe();
		}
		PlayString("What!? Why me? Send Iris instead.", SCHAR_ASHER, EMOTE_ANGRY, 68, 112);
		while(G[G_MSGACTIVE]){
			G[G_NOACTION] = 1;
			Screen->DrawTile(2, 32, 48, 33705, 2, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
			Screen->DrawCombo(2, 64, 48, 33510, 1, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 128);
			Link->InputMap = false; Link->PressMap = false;
			Link->InputStart = false; Link->PressStart = false;
			Waitframe();
		}
		PlayString("I'm not sending someone her age to town unsupervised. Especially not after that stunt you pulled when you were her age. Now up and at 'em.", SCHAR_MOM, EMOTE_NORMAL, 68, 112);
		while(G[G_MSGACTIVE]){
			G[G_NOACTION] = 1;
			Screen->DrawTile(2, 32, 48, 33705, 2, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
			Screen->DrawCombo(2, 64, 48, 33510, 1, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 128);
			Link->InputMap = false; Link->PressMap = false;
			Link->InputStart = false; Link->PressStart = false;
			Waitframe();
		}
		PlayString("Ugh... fine, fine.", SCHAR_ASHER, EMOTE_NORMAL, 68, 112);
		while(G[G_MSGACTIVE]){
			G[G_NOACTION] = 1;
			Screen->DrawTile(2, 32, 48, 33705, 2, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
			Screen->DrawCombo(2, 64, 48, 33510, 1, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 128);
			Link->InputMap = false; Link->PressMap = false;
			Link->InputStart = false; Link->PressStart = false;
			Waitframe();
		}
		for(int i=0; i<16; ++i){
			Screen->Rectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
			WaitNoAction();
		}
		G[G_TIMEFROZEN] = 0;
		Link->Invisible = false;
		Link->Dir = DIR_DOWN;
		this->Flags[FFCF_CARRYOVER] = false;
		SetCutsceneSkip(CUTSCENE_NULL); //CUTSCENE_INTRO
		Link->Warp(Game->GetCurDMap(), Game->GetCurDMapScreen());
	}
}

//Oh man, remember back when individual minor cutscenes were gonna be their own scripts? That's adorable!
ffc script IrisScene{
	void run(){
		if(!GetDBit(33)&&Game->Counter[CR_STORYFLAG]<SFLAG_METTORRIN){
			G[G_TIMEFROZEN] = 1;
			ffc f = Screen->LoadFFC(3);
			int x = f->X;
			int y = f->Y;
			int oldScript = f->Script;
			int initD[8];
			for(int i=0; i<8; ++i){
				initD[i] = f->InitD[i];
			}
			f->Script = 0;
			f->Y = -32;
			this->Data = 32800;
			this->Flags[FFCF_OVERLAY] = true;
			SetCutsceneSkip(CUTSCENE_INTROIRIS);
			WaitNoAction(16);
			
			while(!WalkLinkToPoint(24, 120)){
				Waitframe();
			}
			while(!WalkLinkToPoint(48, 136)){
				Waitframe();
			}
			while(!WalkLinkToPoint(96, 136)){
				Waitframe();
			}
			PlayStringAndWait("Hey, Iris! How'd you like to-", SCHAR_ASHER, EMOTE_NORMAL);
			PlayStringAndWait("I'm not running your errands for you, Asher.", SCHAR_IRIS, EMOTE_NORMAL);
			PlayStringAndWait("Hmf, fine. I'll remember this next time you ask me to take your place.", SCHAR_ASHER, EMOTE_NORMAL);
			PlayStringAndWait("Don't be like that. Just think of it like one of those adventures you're always sleep-talking about.", SCHAR_IRIS, EMOTE_NORMAL);
			PlayStringAndWait("Huh!? I don't sleep talk!", SCHAR_ASHER, EMOTE_ANGRY);
			Game->PlaySound(SFX_JUMP);
			int jump = 1.2;
			int z = 112-16-this->Y;
			this->Data = 33413;
			while(jump>0||z>0){
				z = Max(z+jump, 0);
				jump = Clamp(jump-0.16, -3.2, 3.2);
				this->Y = 112-16-z;
				DrawShadow1x1(this->X, 112);
				WaitNoAction();
			}
			PlayStringAndWait("\"Looks like I got here just in time!\"", SCHAR_IRIS, EMOTE_NORMAL);
			this->Data = 33417;
			while(this->Y<136-16){
				++this->Y;
				WaitNoAction();
			}
			this->Data = 32801;
			PlayStringAndWait("\"No need to worry, I'll save you!\"", SCHAR_IRIS, EMOTE_NORMAL);
			this->Data = 32802;
			PlayString("*Snrk*", SCHAR_IRIS, EMOTE_NORMAL);
			for(int i=0; i<32; ++i){
				G[G_NOACTION] = 1;
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				Waitframe();
			}
			this->Data = 33413;
			while(G[G_MSGACTIVE]){
				G[G_NOACTION] = 1;
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				Waitframe();
			}
			PlayStringAndWait("Okay, okay, I get it!", SCHAR_ASHER, EMOTE_EMBARRASSED);
			this->Data = 33414;
			PlayStringAndWait("Pick me up some muffins while you're there!", SCHAR_IRIS, EMOTE_NORMAL);
			PlayStringAndWait("In your dreams.", SCHAR_ASHER, EMOTE_NORMAL);
			G[G_TIMEFROZEN] = 0;
			f->X = this->X;
			f->Y = this->Y;
			f->Data = this->Data;
			f->Script = oldScript;
			for(int i=0; i<8; ++i){
				f->InitD[i] = initD[i];
			}
			SetDBit(33, true);
			SetCutsceneSkip(CUTSCENE_NULL); //CUTSCENE_INTROIRIS
			Waitframe();
		}
		this->Data = 0;
		this->Flags[FFCF_OVERLAY] = false;
	}
}

ffc script RussScenes{
	void run(int scene){
		int i; int j; int k;
		// Game->Counter[CR_STORYFLAG] = 0;
		if(scene == 0 && Game->Counter[CR_STORYFLAG] < SFLAG_METTORRIN){
			G[G_TIMEFROZEN] = 1;
			SetCutsceneSkip(CUTSCENE_METTORRIN);
			//God damn FFCs drawing under layer 2. Who thought this was a good idea?
			Screen->ComboD[70] = 36078;
			Screen->ComboD[71] = 36079;
			Screen->ComboD[54] = 1;
			mapdata l2 = Game->LoadTempScreen(2);
			l2->ComboD[70] = 0;
			l2->ComboD[71] = 0;
			l2->ComboD[54] = 36059;
			l2->ComboD[86] = 0;
			l2->ComboD[87] = 0;
			Screen->ComboD[86] = 36119;
			Screen->ComboD[87] = 36119;
			ffc dumbnpc = Screen->LoadFFC(2);
			dumbnpc->Y = 300;
			ffc Asher = FindFreeFFC();
			Asher->CSet = 6;
			Asher->Data = 1; //Hold on to this for the moment.
			Asher->TileHeight = 2;
			Asher->Flags[FFCF_OVERLAY] = true;
			ffc Merchant = FindFreeFFC();
			Merchant->Data = 33373;
			Merchant->TileHeight = 2;
			Merchant->X = 96;
			Merchant->Y = 64;
			Merchant->Flags[FFCF_OVERLAY] = true;
			PlayStringAndWait("Step right up, folks! Line up to try the best baked goods in Pala Bay!", SCHAR_MERCHANT, EMOTE_NORMAL, 64, 24);
			if(Link->Y < 48){
				while(Link->Y < 48){
					NoInput();
					Link->InputDown = true;
					Waitframe();
				}
			}
			while(Link->X > 192){
				NoInput();
				Link->InputLeft = true;
				Waitframe();
			}
			while(Link->Y < 112){
				NoInput();
				Link->InputDown = true;
				Waitframe();
			}
			while(Link->X > 96){
				NoInput();
				Link->InputLeft = true;
				Waitframe();
			}
			// while(Link->Y > 96){
				// NoInput();
				// Link->InputUp = true;
				// Waitframe();
			// }
			Asher->X = Link->X;
			Asher->Y = Link->Y-16;
			Asher->Data = 33288;
			Link->Invisible = true;
			while(Asher->Y > 80){
				Asher->Y-=1.5;
				WaitNoAction();
			}
			Asher->Data = 33284;
			WaitNoAction(30);
			PlayStringAndWait("Ah, I see you have an eye for quality, good sir. Can I interest you in some freshly-baked banana bread?", SCHAR_MERCHANT, EMOTE_NORMAL, 64, 24);
			PlayStringAndWait("Actually, I was wondering if you had any muffins.", SCHAR_ASHER, EMOTE_NORMAL, 64, 24);
			PlayStringAndWait("As it so happens, I have muffins in five flavors. The best you'll find anywhere on the island! And they're only-", SCHAR_MERCHANT, EMOTE_NORMAL, 64, 24);
			PlayStringAndWait("Hey, stop!", SCHAR_TORRIN, EMOTE_NORMAL, 64, 24);
			//Time to pan up to Torrin
			ffc Torrin = FindFreeFFC();
			Torrin->Flags[FFCF_OVERLAY] = true;
			Torrin->Data = 33293;
			Torrin->TileHeight = 2;
			Torrin->X = 144;
			Torrin->Y = -52;
			for(i = 0; i<88; i++){
				Screen->DrawScreen(5, 2, 0x1A, 0, -176+i, 0);
				Screen->DrawScreen(5, 2, 0x2A, 0, i, 0);
				WaitNoAction();
				Torrin->Y++;
				Asher->Y++;
				Merchant->Y++;
			}
			for(j = 0; j<90; j++){
				Screen->DrawScreen(5, 2, 0x1A, 0, -176+i, 0);
				Screen->DrawScreen(5, 2, 0x2A, 0, i, 0);
				WaitNoAction();
			}
			Game->PlaySound(SFX_JUMP);
			int jump = 1.2;
			int z = 32-16-Torrin->Y+i;
			j = 0;
			while(i>0){
				i--;
				
				j++;
				Screen->DrawScreen(5, 2, 0x1A, 0, -176+i, 0);
				Screen->DrawScreen(5, 2, 0x2A, 0, i, 0);
				WaitNoAction();
				if(jump>0||z>0){
					z = Max(z+jump, 0);
					jump = Clamp(jump-0.16, -3.2, 3.2);
					Torrin->Y = 32+88-16-z-j;
					DrawShadow1x1L5(Torrin->X, 32+i);
					if(Torrin->Y >= 16 + i){
						Torrin->Data = 50992;
						j = 60;
						Game->PlaySound(16);
						jump = 0;
						z = 0;
						Torrin->Y--;
					}
				}
				else if(Torrin->Data == 33293){
					Torrin->Data = 50992;
					j = 60;
					Game->PlaySound(42);
					Torrin->Y--;
				}
				else
					Torrin->Y--;
				if(j>0){
					j--;
					if(j == 0)
						Torrin->Data = 33293;
				}
				Asher->Y--;
				Merchant->Y--;
			}
			while(j>0){
				j--;
				WaitNoAction();
			}
			Torrin->Data = 33297;
			while(Torrin->Y < 64){
				Torrin->Y++;
				WaitNoAction();
			}
			Torrin->Data = 33298;
			while(Torrin->X > 112){
				Torrin->X--;
				WaitNoAction();
			}
			Torrin->Data-=4;
			Merchant->Data = 33375;
			PlayStringAndWait("Can I help you?", SCHAR_MERCHANT, EMOTE_NORMAL, 64, 24);
			PlayStringAndWait("Yeah, you can stop rippin' off customers with stolen recipes.", SCHAR_TORRIN, EMOTE_NORMAL, 64, 24);
			PlayStringAndWait("Stolen recipes? I have no idea what you're-", SCHAR_MERCHANT, EMOTE_NORMAL, 64, 24);
			PlayStringAndWait("Don't play dumb with me! Fellacino's said their recipes vanished from the shop last week, and now you're sellin' exactly the same foods for twice the price.", SCHAR_TORRIN, EMOTE_ANGRY, 64, 24);
			PlayStringAndWait("You're scamming me?", SCHAR_ASHER, EMOTE_SURPRISED, 64, 24);
			Asher->Data+=4;
			for(i = 0; i<16; i++){
				Asher->Y++;
				WaitNoAction();
			}
			Asher->Data-=4;
			PlayStringAndWait("I guess that's on me for trusting someone baking bread in a tent...", SCHAR_ASHER, EMOTE_EMBARRASSED, 64, 24);
			Asher->Data = 33291;
			for(i = 0; i<16; i++){
				Asher->X++;
				WaitNoAction();
			}
			Asher->Data = 33284;
			Torrin->Data = 33293;
			PlayStringAndWait("Thanks for warning me.", SCHAR_ASHER, EMOTE_NORMAL, 64, 24);
			PlayStringAndWait("Of course! Just lookin' out for-", SCHAR_TORRIN, EMOTE_HAPPY, 64, 24);
			Game->PlaySound(11);
			Merchant->Data = 50993;
			Merchant->X+=4;
			Torrin->Data = 50994;
			for(i = 0; i<4; ++i){
				++Merchant->X;
				++Torrin->X;
				WaitNoAction();
			}
			WaitNoAction(30);
			for(i = 0; i<4; ++i){
				--Merchant->X;
				WaitNoAction();
			}
			Torrin->X -= 4;
			Torrin->Data = 50995;
			Merchant->Data = 33375;
			Merchant->X -= 4;
			PlayStringAndWait("Damned rat, mind your own business, would ya?", SCHAR_MERCHANT, EMOTE_NORMAL, 64, 24);
			Merchant->Data = 33376;
			Merchant->Flags[FFCF_OVERLAY] = false;
			while(Merchant->Y > 24){
				Merchant->Y -= 1.5;
				WaitNoAction();
			}
			ClearFFC(Merchant);
			Asher->Flags[FFCF_OVERLAY] = false;
			Torrin->Flags[FFCF_OVERLAY] = false;
			PlayStringAndWait("Are you alright?", SCHAR_ASHER, EMOTE_NORMAL, 64, 24);
			Torrin->Data = 33293;
			WaitNoAction(10);
			Torrin->Data = 50996;
			WaitNoAction(60);
			Torrin->Data = 33293;
			PlayStringAndWait("Nothin' a little rest won't take care of.", SCHAR_TORRIN, EMOTE_NORMAL, 64, 24);
			PlayStringAndWait("I'm so sorry! If you hadn't warned me-", SCHAR_ASHER, EMOTE_NORMAL, 64, 24);
			PlayStringAndWait("Don't mention it. Just part of my job.", SCHAR_TORRIN, EMOTE_NORMAL, 64, 24);
			PlayStringAndWait("Your job is keeping people from being ripped off?", SCHAR_ASHER, EMOTE_NORMAL, 64, 24);
			PlayStringAndWait("Well, not OFFICIALLY, but I'm not about to sit back and watch it happen.", SCHAR_TORRIN, EMOTE_WINK, 64, 24);
			PlayStringAndWait("Um... do I know you? You seem really familiar for some reason?", SCHAR_ASHER, EMOTE_NORMAL, 64, 24);
			PlayStringAndWait("Now that ya mention it... wait, you're that kid from a few years back! With the cart!", SCHAR_TORRIN, EMOTE_NORMAL, 64, 24);
			PlayStringAndWait("Oh!", SCHAR_ASHER, EMOTE_NORMAL, 64, 24);
			//Mine cart time!
			for(i = 0; i<60; i++){
				BlackishScreenLayerSix();
				WaitNoAction();
			}
			for(i = 0; i<60; i++){
				BlackScreenLayerSix();
				WaitNoAction();
			}
			for(i = 0; i<60; i++){
				BlackishScreenLayerSix();
				Screen->DrawScreen(5, 2, 0x1E, 0, 0, 0);
				WaitNoAction();
			}
			for(i = 0; i<120; i++){
				Screen->DrawScreen(5, 2, 0x1E, 0, 0, 0);
				WaitNoAction();
			}
			ffc Cart = FindFreeFFC();
			Cart->X = 112;
			Cart->Y = -32;
			Cart->TileWidth = 2;
			Cart->TileHeight = 2;
			Cart->Data = 50989;
			Cart->Flags[FFCF_OVERLAY] = true;
			while(Cart->Y < 80){
				Cart->Y+=2.5;
				Screen->DrawScreen(5, 2, 0x1E, 0, 0, 0);
				WaitNoAction();
			}
			Cart->Data--;
			Game->PlaySound(110);
			for(i = 0; i<256; i+=2.5){
				Screen->DrawScreen(5, 2, 0x1E, 0-i, 0, 0);
				Screen->DrawScreen(5, 2, 0x1F, 256-i, 0, 0);
				WaitNoAction();
			}
			Cart->Data++;
			Game->PlaySound(110);
			for(i = 0; i<176; i+=2.5){
				Screen->DrawScreen(5, 2, 0x1F, 0, 0-i, 0);
				Screen->DrawScreen(5, 2, 0x2F, 0, 176-i, 0);
				WaitNoAction();
			}
			j = 0;
			Game->PlaySound(45);
			while(Cart->Y < 176){
				Cart->Y += 1.75;
				j+=2.5;
				Screen->DrawScreen(5, 2, 0x2F, 0, 0, 0);
				Screen->DrawTile(5, 112, 80+j, 53250, 2, 2, 0, -1, -1, 0, 0, 0, 0, true, OP_TRANS);
				WaitNoAction();
			}
			for(i = 0; i<30; i++){
				Screen->DrawScreen(5, 2, 0x2F, 0, 0, 0);
				WaitNoAction();
			}
			Game->PlaySound(3);
			Game->PlaySound(120);
			for(i = 0; i<120; i++){
				BlackScreenLayerSix();
				WaitNoAction();
			}
			Cart->Data++;
			Cart->X = 80;
			Cart->Y = 32;
			j = 0;
			for(i = 0; i<60; i++){
				BlackishScreenLayerSix();
				EarDragDraws(j);
				j+=0.5;
				WaitNoAction();
			}
			for(i = 0; i<360; i++){
				EarDragDraws(j);
				j+=0.5;
				if(i == 60)
					PlayString("I'm sorry, I'm sorry, please let go a' my ear!", SCHAR_TORRINYOUNG, EMOTE_SAD);
				WaitNoAction();
			}
			Tango_ClearSlot(0);
			G[G_MSGACTIVE] = 0;
			for(i = 0; i<60; i++){
				BlackishScreenLayerSix();
				EarDragDraws(j);
				j+=0.5;
				WaitNoAction();
			}
			ClearFFC(Cart);
			Asher->X = 96;
			Asher->Y = 72;
			Asher->Data = 33287;
			Torrin->Y = 72;
			Torrin->Data = 33294;
			for(i = 0; i<60; i++){
				BlackScreenLayerSix();
				WaitNoAction();
			}
			for(i = 0; i<60; i++){
				BlackishScreenLayerSix();
				WaitNoAction();
			}
			PlayStringAndWait("Man, my ma gave me an earful over that. She didn't let me outside a' town for weeks.", SCHAR_TORRIN, EMOTE_NORMAL, 64, 24);
			PlayStringAndWait("At least you got to go outside. My mom didn't let me leave the house for a month.", SCHAR_ASHER, EMOTE_NORMAL, 64, 24);
			PlayStringAndWait("Funny runnin' into you again. What are the odds? It was Ash, right?", SCHAR_TORRIN, EMOTE_HAPPY, 64, 24);
			PlayStringAndWait("Well, Asher, but yeah. I don't remember your name, though.", SCHAR_ASHER, EMOTE_NORMAL, 64, 24);
			PlayStringAndWait("It's Torrin.", SCHAR_TORRIN, EMOTE_NORMAL, 64, 24);
			Asher->Data = 50997;
			Torrin->Data = 50998;
			PlayStringAndWait("Nice to make your acquaintance again, Torrin.", SCHAR_ASHER, EMOTE_HAPPY, 64, 24);
			Asher->Data = 1;
			Torrin->Data = 1;
			for(int i = 0; i < 64; i++){
				Screen->DrawTile(5, Asher->X, Asher->Y, 105603+2*Floor(i/8), 1, 2, 0, -1, -1, 0, 0, 0, 1, true, OP_OPAQUE); 
				Screen->DrawTile(5, Torrin->X, Torrin->Y, 105602+2*Floor(i/8), 1, 2, 0, -1, -1, 0, 0, 0, 1, true, OP_OPAQUE); 
				WaitNoAction();
			}
			for(int i = 0; i < 60; i++){
				Screen->DrawTile(5, Asher->X, Asher->Y, 105654, 1, 2, 0, -1, -1, 0, 0, 0, 1, true, OP_OPAQUE); 
				Screen->DrawTile(5, Torrin->X, Torrin->Y, 105653, 1, 2, 0, -1, -1, 0, 0, 0, 1, true, OP_OPAQUE); 
				WaitNoAction();
			}
			for(int i = 0; i < 60; i++){
				Screen->DrawTile(5, Asher->X, Asher->Y, 105654, 1, 2, 0, -1, -1, 0, 0, 0, 1, true, OP_OPAQUE); 
				Screen->DrawTile(5, Asher->X, Asher->Y-4, 66283, 1, 1, 0, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE); 
				Screen->DrawTile(5, Torrin->X, Torrin->Y, 105653, 1, 2, 0, -1, -1, 0, 0, 0, 1, true, OP_OPAQUE); 
				WaitNoAction();
			}
			for(int i = 0; i < 15; i++){
				Screen->DrawTile(5, Asher->X, Asher->Y, 105656, 1, 2, 0, -1, -1, 0, 0, 0, 1, true, OP_OPAQUE); 
				Screen->DrawTile(5, Torrin->X, Torrin->Y, 105655, 1, 2, 0, -1, -1, 0, 0, 0, 1, true, OP_OPAQUE); 
				WaitNoAction();
			}
			for(int i = 0; i < 30; i++){
				Screen->DrawTile(5, Asher->X, Asher->Y, 105654, 1, 2, 0, -1, -1, 0, 0, 0, 1, true, OP_OPAQUE); 
				Screen->DrawTile(5, Torrin->X, Torrin->Y, 105653, 1, 2, 0, -1, -1, 0, 0, 0, 1, true, OP_OPAQUE); 
				WaitNoAction();
			}
			Game->PlaySound(18);
			for(int i = 0; i < 30; i++){
				Screen->DrawTile(5, Asher->X, Asher->Y, 105654, 1, 2, 0, -1, -1, 0, 0, 0, 1, true, OP_OPAQUE); 
				Screen->DrawTile(5, Asher->X, Asher->Y-4, 66282, 1, 1, 0, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE); 
				Screen->DrawTile(5, Torrin->X, Torrin->Y, 105653, 1, 2, 0, -1, -1, 0, 0, 0, 1, true, OP_OPAQUE); 
				WaitNoAction();
			}
			Game->PlaySound(16);
			for(int i = 0; i < 60; i++){
				Screen->DrawTile(5, Asher->X, Asher->Y, 105619, 1, 2, 0, -1, -1, 0, 0, 0, 1, true, OP_OPAQUE); 
				Screen->DrawTile(5, Torrin->X, Torrin->Y, 105618, 1, 2, 0, -1, -1, 0, 0, 0, 1, true, OP_OPAQUE); 
				WaitNoAction();
			}
			Asher->Data = 33287; 
			Torrin->Data = 33294;
			PlayStringAndWait("Always great to run into an old friend.", SCHAR_TORRIN, EMOTE_HAPPY, 64, 24);
			PlayStringAndWait("What brings you to Pala Bay? Aren't you from Malka?", SCHAR_ASHER, EMOTE_NORMAL, 64, 24);
			PlayStringAndWait("Oh, that?", SCHAR_TORRIN, EMOTE_NORMAL, 64, 24);
			Torrin->Data = 33295;
			WaitNoAction(10);
			Torrin->Data = 33293;
			WaitNoAction(10);
			Torrin->Data = 33294;
			WaitNoAction(10);
			PlayStringAndWait("How'd you like to get in on a secret mission, Ash?", SCHAR_TORRIN, EMOTE_NORMAL, 64, 24);
			PlayStringAndWait("A secret mission?", SCHAR_ASHER, EMOTE_SURPRISED, 64, 24);
			PlayStringAndWait("Er... what kind of mission?", SCHAR_ASHER, EMOTE_NORMAL, 64, 24);
			PlayStringAndWait("Meet me down at the pier, an' I'll show ya.", SCHAR_TORRIN, EMOTE_NORMAL, 64, 24);
			Torrin->Data = 33297;
			while(Torrin->Y < 136){
				Torrin->Y+=1.5;
				if(Torrin->Y >= 112 && Asher->Data == 33287)
					Asher->Data = 33285;
				WaitNoAction();
			}
			Game->PlaySound(SFX_JUMP);
			jump = 1.2;
			z = 208-16-Torrin->Y;
			while(jump>0||z>0){
				z = Max(z+jump, 0);
				jump = Clamp(jump-0.16, -3.2, 3.2);
				Torrin->Y = 208-16-z;
				WaitNoAction();
			}
			Link->Dir = DIR_DOWN;
			Link->Action = LA_ATTACKING;
			WaitNoAction(1);
			Link->Action = LA_NONE;
			Link->X = Asher->X;
			Link->Y = Asher->Y+16;
			Link->Invisible = false;
			ClearFFC(Asher);
			ClearFFC(Torrin);
			Screen->ComboD[70] = 9029;
			Screen->ComboD[71] = 9029;
			Screen->ComboD[54] = 9025;
			l2->ComboD[70] = 36078;
			l2->ComboD[71] = 36079;
			l2->ComboD[54] = 36074;
			l2->ComboD[86] = 36082;
			l2->ComboD[87] = 36083;
			Screen->ComboD[86] = 116;
			Screen->ComboD[87] = 116;
			dumbnpc->Y = 32;
			G[G_TIMEFROZEN] = 0;
			G[G_HOURCLAMP] = 18;
			G[G_MINUTECLAMP] = 59;
			Game->Counter[CR_STORYFLAG] = SFLAG_METTORRIN;
			SetCutsceneSkip(CUTSCENE_NULL); //CUTSCENE_METTORRIN
		}
		if(scene == 1 && Game->Counter[CR_STORYFLAG] == SFLAG_METTORRIN){
			SetCutsceneSkip(CUTSCENE_TORRINJOINS);
			G[G_TIMEFROZEN] = 1;
			ffc Asher = FindFreeFFC();
			Asher->TileHeight = 2;
			Asher->CSet = 6;
			Asher->Data = 1;
			ffc Torrin = FindFreeFFC();
			Torrin->TileHeight = 2;
			Torrin->Data = 33293;
			Torrin->X = 112;
			Torrin->Y = 32;
			PlayStringAndWait("Over here, Ash!", SCHAR_TORRIN, EMOTE_NORMAL, 64, 112);
			while(Link->Y < 64){
				NoInput();
				Link->InputDown = true;
				Waitframe();
			}
			while(Link->X > 112){
				NoInput();
				Link->InputLeft = true;
				Waitframe();
			}
			while(Link->Y > 64){
				NoInput();
				Link->InputUp = true;
				Waitframe();
			}
			Asher->Data = 33284;
			Asher->X = Link->X;
			Asher->Y = Link->Y - 16;
			Link->Invisible = true;
			WaitNoAction(30);
			PlayStringAndWait("Stop keeping me in suspense! What kind of mission?", SCHAR_ASHER, EMOTE_NORMAL, 64, 112);
			PlayStringAndWait("Okay, so the last couple of months, a bunch of pirates have been out harrassin' our fishing boats, stealin' our catches, that kinda stuff.", SCHAR_TORRIN, EMOTE_NORMAL, 64, 112);
			PlayStringAndWait("We've had the same problem. They used to ship goods up from Pala Bay to our village, but the pirates have started intercepting them.", SCHAR_ASHER, EMOTE_NORMAL, 64, 112);
			PlayStringAndWait("Really? Kinda off for them to attack their own, doncha think?", SCHAR_TORRIN, EMOTE_NORMAL, 64, 112);
			PlayStringAndWait("Their own?", SCHAR_ASHER, EMOTE_NORMAL, 64, 112);
			PlayStringAndWait("Yeah, they've all been flyin' the Pala flag.", SCHAR_TORRIN, EMOTE_NORMAL, 64, 112);
			PlayStringAndWait("What!? No, that's not true. They're from Wahiokala.", SCHAR_ASHER, EMOTE_SURPRISED, 64, 112);
			PlayStringAndWait("Huh. Now ain't that strange... I wonder...", SCHAR_TORRIN, EMOTE_SURPRISED, 64, 112);
			PlayStringAndWait("Anyhow, the ones we've seen all fly the Pala flag. So I thought to myself, why not head to Pala and see what they're up ta?", SCHAR_TORRIN, EMOTE_NORMAL, 64, 112);
			PlayStringAndWait("And?", SCHAR_ASHER, EMOTE_NORMAL, 64, 112);
			PlayStringAndWait("Don't be obvious, but look over to the left. See that warehouse back there?", SCHAR_TORRIN, EMOTE_NORMAL, 64, 112);
			mapdata l3 = Game->LoadTempScreen(3);
			mapdata l5 = Game->LoadTempScreen(5);
			l3->ComboD[19] = 0;
			l3->ComboD[20] = 0;
			l3->ComboD[21] = 0;
			l3->ComboD[35] = 0;
			l3->ComboD[36] = 0;
			l3->ComboD[37] = 0;
			l3->ComboD[51] = 0;
			l3->ComboD[52] = 0;
			l3->ComboD[53] = 0;
			l5->ComboD[19] = 0;
			l5->ComboD[20] = 0;
			l5->ComboD[21] = 0;
			l5->ComboD[35] = 0;
			l5->ComboD[36] = 0;
			l5->ComboD[37] = 0;
			l5->ComboD[51] = 0;
			l5->ComboD[52] = 0;
			l5->ComboD[53] = 0;
			for(i = 0; i<256; i++){
				Screen->DrawScreen(1, 2, 0x3A, i, 0, 0); //The screens
				Screen->DrawScreen(1, 2, 0x39, -256+i, 0, 0);
				Screen->DrawTile(1, 64+i, 42, 108320, 1, 2, 0, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE); //Shopkeeper
				Screen->DrawTile(1, 48+i, 16, 78347, 3, 1, 3, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE); //Awning
				Screen->DrawTile(1, 48+i, 32, 78307, 3, 1, 3, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE); 
				Screen->DrawTile(1, 48+i, 48, 78284, 3, 1, 3, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE); 
				G[G_FITNESSGRAMPACEROFFSET] = i;
				Torrin->Data = 33293;
				Asher->Data = 33284;
				WaitNoAction();
				Torrin->X++;
				Asher->X++;
				
			}
			PlayString("There's a ship that matches the description a' the pirate's boat that docks here every week. An' they always unload a whole lot a' boxes and take 'em straight up ta that warehouse.", SCHAR_TORRIN, EMOTE_NORMAL, 64, 112);
			while(G[G_MSGACTIVE]){
				Screen->DrawScreen(1, 2, 0x3A, i, 0, 0); //The screens
				Screen->DrawScreen(1, 2, 0x39, -256+i, 0, 0);
				Screen->DrawTile(1, 64+i, 42, 108320, 1, 2, 0, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE); //Shopkeeper
				Screen->DrawTile(1, 48+i, 16, 78347, 3, 1, 3, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE); //Awning
				Screen->DrawTile(1, 48+i, 32, 78307, 3, 1, 3, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE); 
				Screen->DrawTile(1, 48+i, 48, 78284, 3, 1, 3, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE); 
				G[G_FITNESSGRAMPACEROFFSET] = i;
				G[G_NOACTION] = 1;
				Waitframe();
			}
			for(i = 256; i>0; i--){
				Screen->DrawScreen(1, 2, 0x3A, i, 0, 0); //The screens
				Screen->DrawScreen(1, 2, 0x39, -256+i, 0, 0);
				Screen->DrawTile(1, 64+i, 42, 108320, 1, 2, 0, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE); //Shopkeeper
				Screen->DrawTile(1, 48+i, 16, 78347, 3, 1, 3, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE); //Awning
				Screen->DrawTile(1, 48+i, 32, 78307, 3, 1, 3, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE); 
				Screen->DrawTile(1, 48+i, 48, 78284, 3, 1, 3, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE); 
				Torrin->Data = 33293;
				Asher->Data = 33284;
				G[G_FITNESSGRAMPACEROFFSET] = i;
				WaitNoAction();
				Torrin->X--;
				Asher->X--;
				
			}
			l3->ComboD[19] = 36180;
			l3->ComboD[20] = 36181;
			l3->ComboD[21] = 36182;
			l3->ComboD[35] = 36172;
			l3->ComboD[36] = 36173;
			l3->ComboD[37] = 36174;
			l3->ComboD[51] = 36152;
			l3->ComboD[52] = 36153;
			l3->ComboD[53] = 36154;
			l5->ComboD[19] = 36180;
			l5->ComboD[20] = 36181;
			l5->ComboD[21] = 36182;
			l5->ComboD[35] = 36172;
			l5->ComboD[36] = 36173;
			l5->ComboD[37] = 36174;
			l5->ComboD[51] = 36152;
			l5->ComboD[52] = 36153;
			l5->ComboD[53] = 36154;
			G[G_FITNESSGRAMPACEROFFSET] = 0;
			PlayStringAndWait("You think they're keeping all the stolen goods here, right under everyone's noses?", SCHAR_ASHER, EMOTE_SURPRISED, 64, 112);
			PlayStringAndWait("It's the last place you'd think to check. So, what d'ya say? Wanna break in with me?", SCHAR_TORRIN, EMOTE_NORMAL, 64, 112);
			PlayStringAndWait("What!? That's crazy? That's- I mean, what if you got caught?", SCHAR_ASHER, EMOTE_SURPRISED, 64, 112);
			PlayStringAndWait("I got no plans on getting apprehended. 'course, that'd be a bit easier with a wingman.", SCHAR_TORRIN, EMOTE_NORMAL, 64, 112);
			PlayStringAndWait("I dunno...", SCHAR_ASHER, EMOTE_NORMAL, 64, 112);
			PlayStringAndWait("C'mon Ash, just think of it. You and me would be heroes! Rightin' injustice and sheddin' light on whatever kind of scheme's going on here.", SCHAR_TORRIN, EMOTE_NORMAL, 64, 112);
			PlayStringAndWait("... I guess it wouldn't be too dangerous just to take a look.", SCHAR_ASHER, EMOTE_NORMAL, 64, 112);
			PlayStringAndWait("That's the spirit! I knew sooner or later someone'd see it my way!", SCHAR_TORRIN, EMOTE_HAPPY, 64, 112);
			PlayStringAndWait("Uh huh... So what's the plan?", SCHAR_ASHER, EMOTE_NORMAL, 64, 112);
			PlayStringAndWait("We wait for night, then we sneak in an' verify they're keepin' stolen cargo in there. Then, we look for anything that might point to who's behind this.", SCHAR_TORRIN, EMOTE_NORMAL, 64, 112);
			PlayStringAndWait("Sounds simple enough. How do we get in though?", SCHAR_ASHER, EMOTE_NORMAL, 64, 112);
			PlayStringAndWait("Oh, leave that to me. That silly little lock on the door ain't stoppin' us. Let's you an' me see what else we can find in town, then head in when there's less of a crowd. I might be able to get s'more info outta folks ya already spoke to while we wait for night.", SCHAR_TORRIN, EMOTE_NORMAL, 64, 112);
			PartyPopup(120, 32, "Torrin joined the party!", TIL_DB_DIALOGUE_BOX, CS_DB_DIALOGUE_BOX, C_DB_DIALOGUE_BOX_BG, FONT_P, 0xB2, 390, true);	
			AbilityPopup(128, 88, "Press L or R to switch characters. You can also switch from the subscreen.", TIL_DB_DIALOGUE_BOX, CS_DB_DIALOGUE_BOX, C_DB_DIALOGUE_BOX_BG, FONT_P, 0xB2, 70672, 3, 2, 0, 0, 0);
			AbilityPopup(128, 88, "Use Torrin's fishing rod to pull enemies towards you and stun them. Space your cast just right and hit them with the hook to stun them longer and steal items.", TIL_DB_DIALOGUE_BOX, CS_DB_DIALOGUE_BOX, C_DB_DIALOGUE_BOX_BG, FONT_P, 0xB2, 70460, 5, 3, 70466, 6, 3);			
			Link->Item[150] = true;
			G[G_TIMEFROZEN] = 0;
			G[G_HOURCLAMP] = 22;
			G[G_MINUTECLAMP] = 0;
			Game->Counter[CR_STORYFLAG] = SFLAG_WAREHOUSE;
			Link->Invisible = false;
			ClearFFC(Asher);
			ClearFFC(Torrin);
			SetCutsceneSkip(CUTSCENE_NULL); //CUTSCENE_TORRINJOINS
		}
		if(scene == 2){
			Game->PlayMIDI(0);
			Link->Invisible = true;
			ffc Cultist1 = FindFreeFFC();
			Cultist1->TileHeight = 2;
			Cultist1->Data = 33652;
			Cultist1->X = 80;
			Cultist1->Y = 112;
			ffc Cultist2 = FindFreeFFC();
			Cultist2->TileHeight = 2;
			Cultist2->Data = 33652;
			Cultist2->X = 96;
			Cultist2->Y = 112;
			ffc Asher = FindFreeFFC();
			Asher->TileHeight = 2;
			Asher->CSet = 6;
			Asher->Data = 33289;
			Asher->X = 88;
			Asher->Y = 48;
			ffc Selet = FindFreeFFC();
			Selet->Data = 1;
			ffc Cultist3 = FindFreeFFC();
			Cultist3->Data = 1;
			ffc Cultist4 = FindFreeFFC();
			Cultist4->Data = 1;
			while(Asher->Y < 80){
				Asher->Y++;
				WaitNoAction();
			}
			Game->PlayMIDI(0);
			Asher->Data-=4;
			PlayStringAndWait("Uh... Torrin, we have a problem.", SCHAR_ASHER, EMOTE_DISMAYED, 64, 24);
			Asher->Data = 33291;
			while(Asher->X < 120){
				Asher->X++;
				WaitNoAction();
			}
			Asher->Data = 33285;
			ffc Torrin = FindFreeFFC();
			Torrin->TileHeight = 2;
			Torrin->TileWidth = 2;
			Torrin->Data = 51025;
			Torrin->X = 84;
			Torrin->Y = 48;
			while(Torrin->Y < 80){
				Torrin->Y+=0.5;
				WaitNoAction();
			}
			Torrin->Data++;
			PlayStringAndWait("Well this is a pickle...", SCHAR_TORRIN, EMOTE_ELLIPSES, 64, 24);
			PlayStringAndWait("I have this... step away.", SCHAR_KAYLANI, EMOTE_ANGRY, 64, 24);
			Torrin->TileWidth = 1;
			Torrin->Data = 33295;
			Torrin->X = 91;
			ffc Kaylani = FindFreeFFC();
			Kaylani->TileHeight = 2;
			Kaylani->Data = 33301;
			Kaylani->X = 84;
			Kaylani->Y = 80;
			while(Torrin->X < 104){
				Torrin->X++;
				WaitNoAction();
			}
			Torrin->Data = 33293;
			Kaylani->Data = 51027;
			
			int chargeCounter;
			int ballX;
			int ballY;
			int maxSize = 6;
			int chargeMax1 = 80;
			int chargePercent;
			while(chargeCounter < chargeMax1){
				++chargeCounter;	
				chargePercent = Min(chargeCounter, chargeMax1)/chargeMax1;

				ballX = Kaylani->X+8;
				ballY = Kaylani->Y+16-8-4*chargePercent;
					DrawBigShot(4, ballX, ballY, 2+maxSize*chargePercent, 0, DIR_DOWN, G[G_ANIM]*4, G[G_ANIM]%4);
				WaitNoAction();
			}
			Game->PlaySound(SFX_PHARAOHSHOT_CHARGED);
			for(i = 0; i<60; i++){
				DrawBigShot(4, ballX, ballY, 2+maxSize*chargePercent, 0, DIR_DOWN, G[G_ANIM]*4, G[G_ANIM]%4);
				WaitNoAction();
			}
			
			int ballCurveX = Kaylani->X+8;
			int ballCurveY = Kaylani->Y+8+16;
			int ballDestX = Kaylani->X+8+DirX(DIR_DOWN, 16);
			int ballDestY = Kaylani->Y+16+8+DirY(DIR_DOWN, 16);
			int dir = DIR_DOWN;
			int layer = 4;
			Game->PlaySound(SFX_PHARAOHSHOT_FIRE);
			for(int i=0; i<8; ++i){
				int xy[2];
				BezierQuadFrame(xy, i, 8, ballX, ballY, ballCurveX, ballCurveY, ballDestX, ballDestY);
				DrawBigShot(layer, xy[0], xy[1], 2+maxSize, 0, dir, G[G_ANIM]*4, G[G_ANIM]%4);
				WaitNoAction();
			}
			Kaylani->Data++;
			int scale = 2+maxSize;
			int shotframes = 8;
			ballX = ballDestX;
			ballY = ballDestY; 
			int pointFrames = 8;
			bool hit;
			while(scale>0&&(ballX>0-scale&&ballX<255+scale&&ballY>0-scale&&ballY<175+scale)&&Link->Action!=LA_SCROLLING){
				if(shotframes)
					--shotframes;
				else{
					scale-=1;
				}
				ballX += DirX(dir, 4);
				ballY += DirY(dir, 4);
				if(ballY>=Cultist1->Y+16 && !hit){
					hit = true;
					Game->PlaySound(11); 
					Cultist1->Data = 51031;
					Cultist1->X-=16;
					Cultist1->Y+=16;
					Cultist1->TileHeight = 1;
					Cultist1->TileWidth = 2;
					Cultist2->Data = 51030;
					Cultist2->TileHeight = 1;
					Cultist2->TileWidth = 2;
					Cultist2->Y+=16;
				}
				DrawBigShot(2, ballX, ballY, scale, 0, dir, G[G_ANIM]*4, G[G_ANIM]%4);
				WaitNoAction();
			}
			Kaylani->Data = 51029;
			
			WaitNoAction(60);
			
			PlayStringAndWait("Whoa...", SCHAR_ASHER, EMOTE_SURPRISED, 64, 24);
			PlayStringAndWait("Less gawking, more moving!", SCHAR_KAYLANI, EMOTE_ANGRY, 64, 24);
			Asher->Data = 0;
			Kaylani->Data = 0;
			Torrin->Data = 0;
			for(i = 0; i<60; i++){
				BlackScreenLayerSix();
				WaitNoAction();
			}
			Cultist3->TileHeight = 2;
			Cultist3->Data = 33667;
			Cultist3->X = 128;
			Cultist3->Y = 112;
			Cultist4->TileHeight = 2;
			Cultist4->Data = 33659;
			Cultist4->X = 128;
			Cultist4->Y = 96;
			Cultist3->Vx = 1.5;
			Cultist4->Vx = 1.5;
			Selet->TileHeight = 2;
			Selet->Data = 33311;
			Selet->X = 88;
			Selet->Y = 96;
			Selet->Flags[FFCF_OVERLAY] = true;
			PlayStringAndWait("Find them! Don't let them leave town!", SCHAR_SELETNONAME, EMOTE_ANGRY, 64, 24);
			while(Cultist3->X < 256){
				WaitNoAction();
			}
			ClearFFC(Cultist3);
			ClearFFC(Cultist4);
			Cultist1->Flags[FFCF_OVERLAY] = true;
			Cultist2->Flags[FFCF_OVERLAY] = true;
			Asher->Data = 51022;
			Asher->CSet = 6;
			Asher->TileHeight = 2;
			Asher->X = 120;
			Asher->Y = 208;
			Asher->Flags[FFCF_OVERLAY] = true;
			Torrin->Data = 51032;
			Torrin->X = 136;
			Torrin->Y = 208;
			Torrin->TileHeight = 2;
			Torrin->Flags[FFCF_OVERLAY] = true;
			Kaylani->Data = 51033;
			Kaylani->X = 152;
			Kaylani->Y = 208;
			Kaylani->TileHeight = 2;
			Kaylani->Flags[FFCF_OVERLAY] = true;
			for(i = 0; i<176; i++){
				Screen->DrawScreen(5, 2, 0x0E, 0, 0-i, 0);
				Screen->DrawScreen(5, 2, 0x49, 0, 176-i, 0);
				Asher->Data = 51022;
				Torrin->Data = 51032;
				Kaylani->Data = 51033;
				WaitNoAction();
				Selet->Y--;
				Cultist1->Y--;
				Cultist2->Y--;
				Asher->Y--;
				Torrin->Y--;
				Kaylani->Y--;
			}
			for(i = 0; i<90; i++){
				Screen->DrawScreen(5, 2, 0x49, 0, 0, 0);
				WaitNoAction();
			}
			PlayStringAndWaitAwning("What do we do now?", SCHAR_ASHER, EMOTE_NORMAL, 64, 112);
			PlayStringAndWaitAwning("If we make it out of town, we could hide at your place.", SCHAR_TORRIN, EMOTE_NORMAL, 64, 112);
			PlayStringAndWaitAwning("Ugh... I can't... make it far... too worn out... barely conscious...", SCHAR_KAYLANI, EMOTE_NORMAL, 64, 112);
			PlayStringAndWaitAwning("Roger that. I'll make a run for my boat and pull around to here. If we can sail into open water, we're in the clear.", SCHAR_TORRIN, EMOTE_NORMAL, 64, 112);
			PlayStringAndWaitAwning("And if we can't?", SCHAR_ASHER, EMOTE_NORMAL, 64, 112);
			PlayStringAndWaitAwning("Then we'll make a new plan. Wait here, I'll be right back.", SCHAR_TORRIN, EMOTE_NORMAL, 64, 112);
			for(i = 0; i<60; i++){
				Screen->DrawScreen(5, 2, 0x49, 0, 0, 0);
				BlackishScreenLayerSix();
				WaitNoAction();
			}
			for(i = 0; i<60; i++){
				Screen->DrawScreen(5, 2, 0x49, 0, 0, 0);
				BlackScreenLayerSix();
				WaitNoAction();
			}
			Torrin->Data = 33295;
			Torrin->X = 16;
			Torrin->Y = 100;
			for(i = 0; i<60; i++){
				Screen->DrawScreen(5, 2, 0x49, 0, 0, 0);
				Screen->DrawTile(5, 0, 0, 78521, 3, 10, 4, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
				Screen->DrawTile(5, 0, 32, 78565, 3, 6, 4, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
				BlackishScreenLayerSix();
				WaitNoAction();
			}
			PlayStringAndWaitAwning2("Quick, hop in, let's go!", SCHAR_TORRIN, EMOTE_NORMAL, 64, 112);
			for(i = 0; i<60; i++){
				Screen->DrawScreen(5, 2, 0x49, 0, 0, 0);
				BlackScreenLayerSix();
				WaitNoAction();
			}
			this->Data = CMB_AUTOWARPA;
		}
		if(scene == 3){
			Waitframe();
			if(G[G_RANDOMIZERENABLED]){
				if(!Screen->State[ST_BOSSLOCKBLOCK]){
					npc ShelrondNPC = CreateNPCAt(218, 176, 32);
					while(Link->Y>144){
						NoAction();
						Link->InputUp = true;
						Waitframe();
					}
					Game->PlaySound(SFX_SHUTTER);
					Screen->ComboD[167] = 41410;
					Screen->ComboD[168] = 41411;
					while(ShelrondNPC->isValid()){
						Waitframe();
					}
					Game->PlayMIDI(0);
					Game->PlaySound(SFX_SHUTTER);
					Screen->ComboD[167] = 41418;
					Screen->ComboD[168] = 41419;
					Screen->State[ST_BOSSLOCKBLOCK] = true;
				}
				Quit();
			}
			if(Screen->D[5] == 0){
				SetCutsceneSkip(CUTSCENE_SHELRONDINTRO);
				while(!WalkLinkToPoint(120, 80)){
					Waitframe();
				}
				// ffc Asher = FindFreeFFC();
				// Asher->CSet = 6;
				// Asher->Data = 33290;
				// Asher->X = Link->X;
				// Asher->Y = Link->Y+16;
				// ffc Torrin = FindFreeFFC();
				// Torrin->Data = 33299;
				// Torrin->X = Link->X;
				// Torrin->Y = Link->Y+16;
				// ffc Kaylani = FindFreeFFC();
				// Kaylani->Data = 33304;
				// Kaylani->X = Link->X;
				// Kaylani->Y = Link->Y+16;
				// for(i=0; i<16; i++){
					// Asher->X--;
					// Torrin->X++;
					// Kaylani->Y--;
				// }
				// Asher->Data = 33287;
				// Torrin->Data = 33294;
				// Kaylani->Data = 33301;
				Link->Invisible = true;
				Cutscene_Init(RT_BITMAP1, RT_BITMAP2);
				Cutscene_AnchorCamera(0x1B, 0x1B, 1, 1);
				int kaylani = Cutscene_NewNPC(2, Link->X, Link->Y, 50960, 6, 128);
				Cutscene_SetFlag(kaylani, CGF_4WAY|CGF_BS|CGF_BIGNPC);
				int asher = Cutscene_NewNPC(2, Link->X, Link->Y, 51000, 6, 128);
				Cutscene_SetFlag(asher, CGF_4WAY|CGF_BS|CGF_BIGNPC);
				int torrin = Cutscene_NewNPC(2, Link->X, Link->Y, 50952, 6, 128);
				Cutscene_SetFlag(torrin, CGF_4WAY|CGF_BS|CGF_BIGNPC);
				Cutscene_SetDir(torrin, DIR_RIGHT);
				Cutscene_SetDir(kaylani, DIR_UP);
				Cutscene_SetDir(asher, DIR_LEFT);
				Cutscene_Glide(asher, 0x1B, 104, 80, 1);
				Cutscene_Glide(torrin, 0x1B, 136, 80, 1);
				Cutscene_Glide(kaylani, 0x1B, 120, 58, 1);
				Cutscene_Waitglide();
				Cutscene_SetDir(asher, DIR_RIGHT);
				Cutscene_SetDir(torrin, DIR_LEFT);
				Cutscene_SetDir(kaylani, DIR_DOWN);
				Cutscene_PlayString("So what exactly are we looking for?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_PlayString("Anything to tie the pirates to Selet. That could give us a clue what he's up to.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				// Asher->Data = 33285;
				// Torrin->Data = 33293;
				// Kaylani->Data = 33303;
				// WaitNoAction(30);
				// Asher->Data = 33286;
				// Torrin->Data = 33295;
				// Kaylani->Data = 33300;
				// WaitNoAction(30);
				// Asher->Data = 33287;
				// Torrin->Data = 33294;
				// Kaylani->Data = 33301;
				// WaitNoAction(30);
				Cutscene_SetDir(asher, DIR_LEFT);
				Cutscene_SetDir(kaylani, DIR_UP);
				Cutscene_SetDir(torrin, DIR_DOWN);
				Cutscene_Glide(kaylani, 0x1B, 176, 32, 1);
				Cutscene_Glide(asher, 0x1B, 48, 32, 1);
				Cutscene_Glide(torrin, 0x1B, 192, 144, 1);
				Cutscene_Waitglide();
				Cutscene_SetDir(torrin, DIR_RIGHT);
				for(i=0;i<60;i++){
					NoAction();
					Cutscene_Waitframe();
				}
				Cutscene_PlayString("What are you expecting to find? A receipt for kidnapping with his home address?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_PlayString("There's gotta be SOMETHIN' here. ", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				for(i=0;i<60;i++){
					NoAction();
					Cutscene_Waitframe();
				}
				Game->PlayMIDI(0);
				Cutscene_PlayString("Stop. Do you hear that?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				for(i=0; i<120; i++){
					if(i%39==0)
						Game->PlaySound(Rand(116, 118));
					NoAction();
					Cutscene_Waitframe();
				}
				Cutscene_PlayString("Footsteps! Hide!", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_SetDir(asher, DIR_LEFT);
				Cutscene_SetDir(torrin, DIR_LEFT);
				Cutscene_SetDir(kaylani, DIR_LEFT);
				Cutscene_Glide(kaylani, 0x1B, 16, 48, 2);
				Cutscene_Glide(asher, 0x1B, 16, 48, 2);
				Cutscene_Glide(torrin, 0x1B, 16, 48, 2);
				bool ashdone; bool kaydone;
				while(cutsceneG[CG_NUMGLIDING]>0){
					if(Cutscene_FinishedGlide(asher)){
						if(!ashdone){
							Cutscene_SetDir(asher, DIR_UP);
							Cutscene_Glide(asher, 0x1B, 16, 24, 2);
							ashdone = true;
						}
						else
							Cutscene_SetDir(asher, DIR_RIGHT);
					}
					if(Cutscene_FinishedGlide(torrin)){
						Cutscene_SetDir(torrin, DIR_UP);
						Cutscene_Glide(torrin, 0x1B, 16, 32, 2);
					}
					if(Cutscene_FinishedGlide(kaylani)){
						if(!kaydone){
							Cutscene_SetDir(kaylani, DIR_UP);
							Cutscene_Glide(kaylani, 0x1B, 16, 16, 2);
							kaydone = true;
						}
						else
							Cutscene_SetDir(kaylani, DIR_RIGHT);
					}
					NoAction();
					Cutscene_Waitframe();
				}
				Cutscene_Waitglide();
				// Cutscene_PlayString("Are we all gonna fit back here?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				// Cutscene_PlayString("Not much of a choice!", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				// Cutscene_Glide(kaylani, 0x1B, 16, 16, 2);
				// Cutscene_Glide(asher, 0x1B, 16, 24, 2);
				// Cutscene_Glide(torrin, 0x1B, 16, 32, 2);
				Cutscene_SetDir(torrin, DIR_UP);
				Cutscene_Glide(torrin, 0x1B, 16, 32, 2);
				Cutscene_Waitglide();
				Cutscene_SetDir(kaylani, DIR_RIGHT);
				Cutscene_SetDir(asher, DIR_RIGHT);
				Cutscene_SetDir(torrin, DIR_RIGHT);
				int shelrond = Cutscene_NewNPC(2, 120, 160, 51816, 6, 128);
				Cutscene_SetFlag(shelrond, CGF_4WAY|CGF_BIGNPC);
				int pirate = Cutscene_NewNPC(2, 120, 176, 33772, 6, 128);
				Cutscene_SetFlag(pirate, CGF_4WAY|CGF_BIGNPC);
				Cutscene_Glide(shelrond, 0x1B, 120, 64, 1);
				Cutscene_Glide(pirate, 0x1B, 120, 80, 1);
				Cutscene_Waitglide();
				Cutscene_SetDir(shelrond, DIR_DOWN);
				
				Cutscene_PlayString("Grrr... I know that man. He and I have a score to settle.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_PlayString("Not now! We're here for info, nothing else.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_PlayString("Igorevich has another batch of them batteries ready for us. Take the ship and pick them up.", SCHAR_CAPTAIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_PlayString("I've never been out there before. Got the coordinates?", SCHAR_PIRATE, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_PlayString("Ain't I told you where the mining base is three times already? Wait outside, I'll fish out the map.", SCHAR_CAPTAIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_Glide(pirate, 0x1B, 120, 176, 1);
				Cutscene_Waitglide();
				Cutscene_RemoveDraw(pirate);
				Screen->ComboD[167] = 41410;
				Screen->ComboD[168] = 41411;
				int door1 = Cutscene_NewFastCombo(2, 112, 160, 41410, 2, OP_OPAQUE);
				Cutscene_SetAttr(door1, CGI_DRAWLIFESPAN, -1);
				int door2 = Cutscene_NewFastCombo(2, 128, 160, 41411, 2, OP_OPAQUE);
				Cutscene_SetAttr(door2, CGI_DRAWLIFESPAN, -1);
				Game->PlaySound(9);
				Cutscene_SetDir(shelrond, DIR_RIGHT);
				Cutscene_Glide(shelrond, 0x1B, 176, 32, 1);
				Cutscene_Waitglide();
				Cutscene_SetDir(shelrond, DIR_UP);
				for(i=0;i<60;i++){
					NoAction();
					Cutscene_Waitframe();
				}
				Cutscene_SetDir(torrin, DIR_DOWN);
				Cutscene_Glide(torrin, 0x1B, 16, 48, 1);
				Cutscene_Waitglide();
				Cutscene_SetDir(torrin, DIR_RIGHT);
				Cutscene_Glide(torrin, 0x1B, 48, 48, 1);
				Cutscene_Waitglide();
				Cutscene_PlayString("We'll be takin' that off your hands now.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_SetDir(shelrond, DIR_LEFT);
				Cutscene_PlayString("What's this now? A stowaway?", SCHAR_CAPTAIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_SetDir(asher, DIR_DOWN);
				Cutscene_Glide(asher, 0x1B, 16, 64, 1);
				Cutscene_Waitglide();
				Cutscene_SetDir(asher, DIR_RIGHT);
				Cutscene_Glide(asher, 0x1B, 32, 64, 1);
				Cutscene_Waitglide();
				Cutscene_PlayString("We're not on a boat, so I don't think stowaways is the right word...", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_SetDir(kaylani, DIR_DOWN);
				Cutscene_Glide(kaylani, 0x1B, 16, 80, 1);
				Cutscene_Waitglide();
				Cutscene_SetDir(kaylani, DIR_RIGHT);
				Cutscene_PlayString("We meet again.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_PlayString("Well, if it ain't little Miss Feisty. Back again so soon?", SCHAR_CAPTAIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_PlayString("I promised I'd smash that ugly nose of yours into your throat. I'm here to follow up on that now.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_PlayString("Is that so? Well, it'd be a shame to carve up such a pretty little face, but if you're that hungry for more punishment, I can oblige.", SCHAR_CAPTAIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_SetDir(kaylani, DIR_RIGHT);
				Cutscene_SetDir(torrin, DIR_LEFT);
				Cutscene_Glide(torrin, 0x1B, 32, 64, 1);
				Cutscene_Glide(kaylani, 0x1B, 32, 64, 1);
				Cutscene_Waitglide();
				Link->X = 32;
				Link->Y = 64;
				Link->Invisible = false;
				Cutscene_RemoveDraw(asher);
				Cutscene_RemoveDraw(torrin);
				Cutscene_RemoveDraw(kaylani);
				Cutscene_RemoveDraw(shelrond);
				Screen->D[5] = 1;
				SetCutsceneSkip(CUTSCENE_NULL); //CUTSCENE_SHELRONDINTRO;
			}
			if(Game->Counter[CR_STORYFLAG] < SFLAG_LEVEL1){
				Screen->ComboD[167] = 41410;
				Screen->ComboD[168] = 41411;
				npc ShelrondNPC = CreateNPCAt(218, 176, 32);
				while(ShelrondNPC->HP > 0)
					Waitframe();
				SetCutsceneSkip(CUTSCENE_POSTSHELROND);
				KillEWeapons();
				KillLWeapons();
				Game->PlayMIDI(0);
				for(i=0; i<60; i++){
					BlackScreenLayerSix();
					WaitNoAction();
				}
				Link->Invisible = true;
				ffc Asher = FindFreeFFC();
				Asher->CSet = 6;
				Asher->Data = 33285;
				Asher->X = 104;
				Asher->Y = 48;
				Asher->TileHeight = 2;
				ffc Torrin = FindFreeFFC();
				Torrin->Data = 33293;
				Torrin->X = 136;
				Torrin->Y = 48;
				Torrin->TileHeight = 2;
				ffc Kaylani = FindFreeFFC();
				Kaylani->Data = 33301;
				Kaylani->X = 120;
				Kaylani->Y = 48;
				Kaylani->TileHeight = 2;
				ffc Shelrond = FindFreeFFC();
				Shelrond->TileWidth = 2;
				Shelrond->X = 112;
				Shelrond->Y = 80;
				Shelrond->Data = 51034;
				WaitNoAction(60);
				PlayStringAndWait("I got the map, let's get out of here before more come!", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Hold up a sec, Ash. Somethin's not right. Since when are pirates mages?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("He wasn't casting magic. And yet...", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				Kaylani->Data = 51033;
				PlayStringAndWait("He mentioned Selet has a batch of batteries. Surely they're not...", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				Kaylani->Data = 33301;
				Asher->Data = 33287;
				WaitNoAction(30);
				Kaylani->Data = 33303;
				Torrin->Data = 51032;
				WaitNoAction(30);
				Torrin->Data = 33293;
				PlayStringAndWait("Easy enough to test.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				Torrin->Data = 51035;
				for(i=0;i<60;i++){
					Screen->FastTile(4, Torrin->X-5, Torrin->Y-2, 65112, 8, 128);
					WaitNoAction();
				}
				eweapon e = CreateEWeaponAt(EW_SOLAR, Torrin->X-5, Torrin->Y-2);
				e->CollDetection = false;
				e->DrawYOffset = -1000;
				RunEWeaponScript(e, "GenParticle", {GP_FLASH, -1});
				for(i=0;i<60;i++){
					Screen->FastTile(4, Torrin->X-5, Torrin->Y-2, 65112, 8, 128);
					WaitNoAction();
				}
				Torrin->Data = 33293;
				e->InitD[1] = 0;
				WaitNoAction(60);
				PlayStringAndWait("Magic in a bottle... this could come in handy.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("That's solar magic. Is that-", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("What he stole from me? Most likely. Though I don't understand how he's stored it.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Let's grab all a' them and you can take one apart.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("That is a good call. We don't want these pirates armed with them.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				Torrin->Data = 33294;
				WaitNoAction(30);
				PlayStringAndWait("That smile makes me think we don't want you armed with them either.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("You're worryin' too much. I'll use 'em entirely for good.", SCHAR_TORRIN, EMOTE_WINK, 64, YPOS_LOWER);
				PlayStringAndWait("Your definition of good tends to involve more mayhem than I'd like.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Well it's worked out so far, hasn't it?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("I suppose... Let's get back to the boat and figure out what we're dealing with.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				for(i=0; i<60; i++){
					BlackishScreenLayerSix();
					WaitNoAction();
				}
				for(i=0; i<30; i++){
					BlackScreenLayerSix();
					WaitNoAction();
				}
				Screen->SetSideWarp(3, 0x30, 56, WT_IWARPBLACKOUT);
				this->Data = CMB_AUTOWARPD;
			}
		}
		if(scene == 4 && Game->Counter[CR_STORYFLAG] < SFLAG_TORRINMOM){
			SetCutsceneSkip(CUTSCENE_ENTEREDMALKA);
			Game->PlayMIDI(0);
			G[G_TIMEFROZEN] = 1;
			Link->Invisible = true;
			ffc Asher = FindFreeFFC(); 
			Asher->TileHeight = 2;
			Asher->Data = 33284;
			Asher->CSet = 6;
			Asher->X = 128;
			Asher->Y = 96;
			ffc Kaylani = FindFreeFFC();
			Kaylani->TileHeight = 2;
			Kaylani->Data = 33300;
			Kaylani->X = 144;
			Kaylani->Y = 96;
			ffc Torrin = FindFreeFFC();
			Torrin->TileHeight = 2;
			Torrin->Data = 33293;
			Torrin->X = 136;
			Torrin->Y = 80;
			WaitNoAction(5);
			Game->PlayMIDI(0);
			WaitNoAction(25);
			PlayStringAndWait("Wow! Your village floats?", SCHAR_ASHER, EMOTE_SURPRISED, 64, YPOS_UPPER);
			PlayStringAndWait("Nah, it's just built on top of a reef.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("That's incredible. Which house is yours?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("That's not important. Let's find someone who can read the map and get outta here.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("Torrin?", SCHAR_UNKNOWN, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("... on second thought, looks like no one's here. Let's try Pala Bay instead. C'mon, no use wastin' time, let's leave right now.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("Right now? But we only just arrived. Besides, I can hear someone calling for you.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("That? That's... just the waves! They sound like that sometimes.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("The waves sound like your name?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("Torrin!", SCHAR_UNKNOWN, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("Yup! Was named after that noise. Now let's talk all 'bout that when we're safe an' sound on the boat!", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			ffc Mom = FindFreeFFC();
			Mom->TileHeight = 2;
			Mom->Data = 33609;
			Mom->X = Torrin->X - 5;
			Mom->Y = -32;
			Torrin->Data--;
			while(Mom->Y < 64){
				Mom->Y++;
				WaitNoAction();
			}
			Mom->Data = 33605;
			PlayStringAndWait("Where the hell have you been!?", SCHAR_TALCAY, EMOTE_ANGRY, 64, YPOS_UPPER);
			PlayStringAndWait("Look Mom, I can explain! Ya know those pirates that have been causin' such a ruckus? Well I-", SCHAR_TORRIN, EMOTE_SWEAT, 64, YPOS_UPPER);
			PlayStringAndWait("-decided it wasn't enough that we had to worry about pirates and went an' made me scared for your life instead?", SCHAR_TALCAY, EMOTE_ANGRY, 64, YPOS_UPPER);
			PlayStringAndWait("It's not like that. I-", SCHAR_TORRIN, EMOTE_SWEAT, 64, YPOS_UPPER);
			PlayStringAndWait("Inside. Now.", SCHAR_TALCAY, EMOTE_ANGRY, 64, YPOS_UPPER);
			Mom->Data = 33609;
			while(Mom->Y < Torrin->Y - 7){
				Mom->Y++;
				WaitNoAction();
			}
			Mom->Data = 51036;
			Game->PlaySound(11);
			WaitNoAction(10);
			Torrin->Data = 51037;
			Mom->Data = 33604;
			PlayString("Wait, lemme explain Mom!@delay(60)@26@26Ash, mate, help! You promised you'd stay close!", SCHAR_TORRIN, EMOTE_DISMAYED, 64, YPOS_LOWER);
			while(Mom->Y > 24){
				Mom->Y-=0.5;
				Torrin->Y-=0.5;
				G[G_NOACTION] = 1;
				Waitframe();
			}
			Torrin->Data++;
			while(G[G_MSGACTIVE]){
				G[G_NOACTION] = 1;
				Waitframe();
			}
			Asher->Data+=4;
			for(i=0;i<16;i++){
				Asher->Y--;
				WaitNoAction();
			}
			Asher->Data-=4;
			PlayStringAndWait("Um... ma'am?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
			WaitNoAction(30);
			Mom->Data = 33605;
			WaitNoAction(30);
			PlayStringAndWait("Yes?", SCHAR_TALCAY, EMOTE_FURIOUS, 64, YPOS_LOWER);
			PlayStringAndWait("Um... nevermind, have a nice day.", SCHAR_ASHER, EMOTE_SWEAT, 64, YPOS_UPPER);
			PlayString("Traitor! I thought we were closer than this! Don't leave me, Ash!", SCHAR_TORRIN, EMOTE_DISMAYED, 64, YPOS_LOWER);
			Mom->Data = 33604;
			Torrin->Data--;
			while(Torrin->Y > -32){
				Mom->Y-=0.5;
				Torrin->Y-=0.5;
				G[G_NOACTION] = 1;
				Waitframe();
			}
			while(G[G_MSGACTIVE]){
				G[G_NOACTION] = 1;
				Waitframe();
			}
			Asher->Data=33285;
			for(i=0;i<16;i++){
				Asher->Y++;
				WaitNoAction();
			}
			Asher->Data=33287;
			Kaylani->Data = 33302;
			WaitNoAction(90);
			PlayStringAndWait("And I thought my mom was bad...", SCHAR_ASHER, EMOTE_SWEAT, 64, YPOS_UPPER);
			PlayStringAndWait("He did have it coming.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("A moment of silence.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("Sheesh, you're almost as dramatic as he is. He'll be fine.@26...@26Probably.@26Let's go find someone who can read this chart in the meantime.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			Asher->Data = 33287;
			Kaylani->Data = 33306;
			while(Asher->X < Kaylani->X){
				Asher->X++;
				Kaylani->X--;
				WaitNoAction();
			}
			Link->X = Asher->X;
			Link->Y = Asher->Y+16;
			ClearFFC(Asher);
			ClearFFC(Kaylani);
			ClearFFC(Torrin);
			ClearFFC(Mom);
			if(GetCharID() == CHAR_TORRIN){
				G[G_ASHERHP] = G[G_ASHERMAXHP];
				SetCharacter(CHAR_ASHER, false);
			}
			G[G_TIMEFROZEN] = 0;
			Link->Invisible = false;
			Link->Item[I_TORRIN] = false;
			Game->Counter[CR_STORYFLAG] = SFLAG_TORRINMOM;
			// int Music[256];
			// Game->GetDMapMusicFilename(Game->GetCurDMap(), Music);
			// Game->PlayEnhancedMusic(Music, 0);
			if(DayNight_IsBetween(DAYNIGHT_MIDI_NIGHT_START_HOUR, 0, 0, DAYNIGHT_MIDI_NIGHT_END_HOUR, 0, 0))
				Game->PlayEnhancedMusic("SS-MalkaNight.ogg", 0);
			else
				Game->PlayEnhancedMusic("SS-Malka.ogg", 0);
			SetCutsceneSkip(CUTSCENE_NULL); //CUTSCENE_ENTEREDMALKA
		}
		if(scene == 5 && Game->Counter[CR_STORYFLAG] == SFLAG_SENTTODARI){
			G[G_TIMEFROZEN] = 1;
			Game->PlayEnhancedMusic("SS-Boss.ogg", 0);
			ffc Dari = FindFreeFFC();
			Dari->TileHeight = 2;
			Dari->Data = 33574;
			Dari->X = 192;
			Dari->Y = 16;
			mapdata l2 = Game->LoadTempScreen(2);
			l2->ComboD[ComboAt(192, 32)] = 1;
			CreateNPCAt(232, 176, 48);
			CreateNPCAt(233, 176, 32);
			SuspendGhostZHScripts();
			// ffc Golem1 = FindFreeFFC();
			// Golem1->TileHeight = 2;
			// Golem1->Data = 51251;
			// Golem1->X = 176;
			// Golem1->Y = 32;
			// ffc Golem2 = FindFreeFFC();
			// Golem2->TileHeight = 2;
			// Golem2->Data = 51251;
			// Golem2->X = 176;
			// Golem2->Y = 16;
			PlayStringAndWait("Hey! Some help, please!", SCHAR_DARI, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("On it!", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
			// CreateNPCAt(183, Golem1->X, Golem1->Y+16);
			// CreateNPCAt(183, Golem2->X, Golem2->Y+16);
			// ClearFFC(Golem1);
			// ClearFFC(Golem2);
			ResumeGhostZHScripts();
			Waitframes(8);
			while(Screen->NumNPCs() > 0){
				Waitframe();
			}
			SetCutsceneSkip(CUTSCENE_TORRINREJOINS);
			Game->PlayMIDI(0);
			l2->ComboD[ComboAt(192, 32)] = 0; 
			KillLWeapons();
			KillEWeapons();
			for(i=0;i<60;i++){
				BlackScreenLayerSix();
				WaitNoAction();
			}
			Link->Invisible = true;
			ffc Asher = FindFreeFFC();
			Asher->TileHeight = 2;
			Asher->Data = 33286;
			Asher->CSet = 6;
			Asher->X = 160;
			Asher->Y = 32;
			ffc Kaylani = FindFreeFFC();
			Kaylani->TileHeight = 2;
			Kaylani->Data = 33302;
			Kaylani->X = 160;
			Kaylani->Y = 16;
			Dari->Data++;
			Dari->X = 128;
			Dari->Y = 16;
			PlayStringAndWait("Thank you. They told me something had destroyed the taro last night, but I was expecting boars trampling it, not whatever those things were. Is there any way I can repay you?", SCHAR_DARI, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("Actually, we were seeking your help. There's a sea chart that Torrin can't read, and we were hoping you might be able to help.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
			Kaylani->Data+=4;
			while(Kaylani->X > 144){
				Kaylani->X--;
				WaitNoAction();
			}
			Kaylani->Data-=4;
			WaitNoAction(60);
			PlayStringAndWait("You said Torrin can't read this?@26Ay... this isn't a complex chart at all. That boy, I swear...@26@26I'll go find him and explain this to him. In the meantime, I'd ask you stay out of the fields so they don't suffer any more damage.", SCHAR_DARI, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("Of course! Thank you, sir.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("It's no problem.", SCHAR_DARI, EMOTE_NORMAL, 64, YPOS_LOWER);
			Dari->Data+=3;
			while(Dari->X > -16){
				Dari->X--;
				WaitNoAction();
			}
			Asher->Data+=4;
			while(Asher->X > 144){
				Asher->X--;
				WaitNoAction();
			}
			Asher->Data = 33284;
			Kaylani->Data = 33301;
			WaitNoAction(30);
			PlayStringAndWait("What were those things?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("They're called eaters. They appear when large amounts of magic are released, some of the energy pooling together.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("Large amounts of magic... like drilling through a magic space rock?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("Exactly. I'd suspect Selet's meteor mining operation is to blame for them.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("That's... that's intense.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
			WaitNoAction(60);
			PlayStringAndWait("It is, and it's all my fault.", SCHAR_KAYLANI, EMOTE_SAD, 64, YPOS_LOWER);
			PlayStringAndWait("I should never have let myself get captured in the first place. None of the other astronomers would have. We're BETTER than that!@delay(120)@26@26But I was careless, and now my magic's helping Selet mess with powers he clearly can't contain.", SCHAR_KAYLANI, EMOTE_ANGRY, 64, YPOS_LOWER);
			PlayStringAndWait("That's not your fault at all! Could've happened to anyone. I'm just glad we happened to be there at the right time.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("What WERE you doing there? I can see someone like Torrin getting tangled up in this, but none of this has anything to do with you. Why are you still putting yourself in danger?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("That's a good question.@delay(120)@26@26I don't know for sure, honestly. I guess...@delay(30)@26I know it sounds dumb, but I've always dreamed of going on an adventure, being a hero, all that nonsense. Torrin asked me to come along, and I started going along with him. Then it started getting dangerous, but I felt committed.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("Uh huh. How do you two know each other?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("Huh? Well... like he said, we go way back.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("But no one in his home village knows you?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("Well, uh... we met once, a while ago. And made a bit of a mess. And then I bumped into him again recently.", SCHAR_ASHER, EMOTE_SWEAT, 64, YPOS_LOWER);
			PlayStringAndWait("'Bumped into him'? That's how you're describin' our fateful reunion?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
			Asher->Data = 33286;
			Kaylani->Data = 33302;
			ffc Torrin = Dari;
			Torrin->Data = 33299;
			while(Torrin->X < 128){
				Torrin->X++;
				WaitNoAction();
			}
			Torrin->Data-=4;
			PlayStringAndWait("Torrin! Are you alright?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("'side from the ringin' in my ears, I'm fine.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("I'm really sorry about-", SCHAR_ASHER, EMOTE_EMBARRASSED, 64, YPOS_LOWER);
			PlayStringAndWait("Don't mention it, mate. That woman'd make the spirits run for the hills.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("Did Dari find you?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("Sure did! Turns out the spot's in a patch a' notoriously rough sea, so I might have to park us a little ways away.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("Sounds like a good excuse to get some exercise in. Let's go.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
			if(Game->Counter[CR_TORRINSIDEQUEST] == 10){
				PlayStringAndWait("Oh! By the way, there's a girl looking for you. Blue eyes, same hair color as you, about the same height...", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("You're just now realizing she's his sister, aren't you?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Cut me some slack. I met a lot of people today.", SCHAR_ASHER, EMOTE_EMBARRASSED, 64, YPOS_LOWER);
				PlayStringAndWait("Oh great. Guess I better see what she wants...", SCHAR_TORRIN, EMOTE_SWEAT, 64, YPOS_LOWER);
			}
			Link->X = Kaylani->X;
			Link->Y = Kaylani->Y+16;
			ClearFFC(Asher);
			ClearFFC(Torrin);
			ClearFFC(Kaylani);
			for(i=0;i<60;i++){
				BlackScreenLayerSix();
				WaitNoAction();
			}
			Link->Invisible = false;
			Link->Item[I_TORRIN] = true;
			Game->Counter[CR_STORYFLAG] = SFLAG_SHOALSOPEN;
			int Music[256];
			Game->GetDMapMusicFilename(Game->GetCurDMap(), Music);
			Game->PlayEnhancedMusic(Music, 0);
			G[G_TIMEFROZEN] = 0;
			SetCutsceneSkip(CUTSCENE_NULL); //CUTSCENE_TORRINREJOINS
		}
		if(scene == 6){
			Link->Invisible = true;
			for(i=0;i<60;i++){
				BlackScreenLayerSix();
				WaitNoAction();
			}
			Game->PlayEnhancedMusic("SS-SeaNight.ogg", 0);
			for(i=0;i<60;i++){
				Screen->DrawScreen(2, 9, 0x20, 0, 0, 0);
				BlackishScreenLayerSix();
				WaitNoAction();
			}
			for(i=0;i<60;i++){
				Screen->DrawScreen(2, 9, 0x20, 0, 0, 0);
				WaitNoAction();
			}
			Cutscene_Init(RT_BITMAP1, RT_BITMAP2);
			Cutscene_AnchorCamera(0x20, 0x20, 1, 3);
			// int torrin = Cutscene_NewNPC(2, 128, 120+176, 51041, 6, OP_OPAQUE);
			int torrin = Cutscene_NewNPC(1, 104, 88+176, 33292, 6, OP_OPAQUE);
			Cutscene_SetFlag(torrin, CGF_BIGNPC);
			Cutscene_SetDir(torrin, DIR_RIGHT);
			int asher = Cutscene_NewNPC(1, 128, 120+176, 51040, 6, OP_OPAQUE);
			Cutscene_SetFlag(asher, CGF_BIGNPC);
			int kaylani = Cutscene_NewNPC(1, 120, 88+176, 51043, 6, OP_OPAQUE);
			Cutscene_SetFlag(kaylani, CGF_BIGNPC);
			Cutscene_UnsetFlag(asher, CGF_4WAY);
			Cutscene_UnsetFlag(kaylani, CGF_4WAY);
			Cutscene_SetCameraTarget(0, 104+176, 0.8);
			Cutscene_Waitcamera();
			Cutscene_Waitframe(60);
			Cutscene_SetDir(torrin, DIR_DOWN);
			Cutscene_Glide(torrin, 0x30, 112, 120, 0.8);
			Cutscene_Waitglide();
			Cutscene_Waitframe(60);
			Cutscene_UnsetFlag(torrin, CGF_4WAY);
			Cutscene_SetAttr(torrin, CGI_GFX, 51038);
			Cutscene_Waitframe(30);
			Cutscene_SetAttr(asher, CGI_GFX, 51039);
			Cutscene_Waitframe(15);
			int stringpos = YPOS_LOWER - 24;
			Cutscene_PlayString("She's still out?", SCHAR_ASHER, EMOTE_NORMAL, 64, stringpos);
			Cutscene_PlayString("Yeah. No idea what they put her through, but whatever it was, must've been pretty exhausting.", SCHAR_TORRIN, EMOTE_NORMAL, 64, stringpos);
			Cutscene_SetAttr(torrin, CGI_GFX, 51041);
			Cutscene_Waitframe(30);
			Cutscene_SetAttr(asher, CGI_GFX, 51040);
			Cutscene_Waitframe(30);
			Cutscene_PlayString("We're in way over our heads. What now? Wait til she wakes up, take her home, then... then what?", SCHAR_ASHER, EMOTE_NORMAL, 64, stringpos);
			Cutscene_PlayString("Find out what that creepy merchant's up to, obviously.", SCHAR_TORRIN, EMOTE_NORMAL, 64, stringpos);
			Cutscene_PlayString("Huh!? You're not serious, are you?", SCHAR_ASHER, EMOTE_SURPRISED, 64, stringpos);
			Cutscene_Waitframe(15);
			Cutscene_SetAttr(torrin, CGI_GFX, 51044);
			Cutscene_Waitframe(60);
			Cutscene_SetAttr(torrin, CGI_GFX, 51045);
			Cutscene_Waitframe(30);
			Cutscene_PlayString("I can drop you off back home, if this is too much for ya.", SCHAR_TORRIN, EMOTE_NORMAL, 64, stringpos);
			Cutscene_PlayString("What? N-no, I can't leave you to get in trouble by yourself!", SCHAR_ASHER, EMOTE_SURPRISED, 64, stringpos);
			Cutscene_PlayString("I've gotten in trouble by myself my whole life. I can manage just fine. No sense draggin' you into somethin' you're not okay with.", SCHAR_TORRIN, EMOTE_NORMAL, 64, stringpos);
			Cutscene_PlayString("...", SCHAR_ASHER, EMOTE_NORMAL, 64, stringpos);
			Cutscene_SetAttr(torrin, CGI_GFX, 51041);
			Cutscene_Waitframe(120);
			Cutscene_PlayString("No, you're right. We can't walk away now. I'm sticking with you.", SCHAR_ASHER, EMOTE_NORMAL, 64, stringpos);
			Cutscene_PlayString("Well that's a relief. Truth be told, I wasn't too sure of my odds roughin' it alone.", SCHAR_TORRIN, EMOTE_NORMAL, 64, stringpos);
			Cutscene_PlayString("What!? But you just said-", SCHAR_ASHER, EMOTE_SURPRISED, 64, stringpos);
			Cutscene_PlayString("Yeah, yeah, I know. Didn't want that influencin' your decision.", SCHAR_TORRIN, EMOTE_NORMAL, 64, stringpos);
			Cutscene_SetAttr(torrin, CGI_GFX, 51046);
			Cutscene_Waitframe(60);
			Cutscene_SetAttr(torrin, CGI_GFX, 51044);
			Cutscene_SetAttr(asher, CGI_GFX, 51039);
			Cutscene_Waitframe(60);
			Cutscene_SetAttr(torrin, CGI_GFX, 51041);
			Cutscene_PlayString("Torrin... were you planning on going into that warehouse alone?", SCHAR_ASHER, EMOTE_NORMAL, 64, stringpos);
			Cutscene_SetAttr(torrin, CGI_GFX, 51045);
			Cutscene_PlayString("Huh? What kinda question's that? Wasn't about to announce my intentions to the Portmaster or anythin'.", SCHAR_TORRIN, EMOTE_NORMAL, 64, stringpos);
			Cutscene_PlayString("That's not what I'm asking though. You said you'd been in Pala Bay a month scouting out that warehouse. Wasn't there anyone else close to you who could've come with you?", SCHAR_ASHER, EMOTE_NORMAL, 64, stringpos);
			Cutscene_PlayString("Well when you put it like that... no one I'm super tight with. How'd ya know?", SCHAR_TORRIN, EMOTE_ELLIPSES, 64, stringpos);
			Cutscene_PlayString("I recognize that look on your face. That feeling of getting scared people are gonna walk away, but scared they're only gonna run faster if you ask them to stay.", SCHAR_ASHER, EMOTE_NORMAL, 64, stringpos);
			Cutscene_PlayString("Heh... am I that obvious?", SCHAR_TORRIN, EMOTE_EMBARRASSED, 64, stringpos);
			Cutscene_SetAttr(asher, CGI_GFX, 51040);
			Cutscene_PlayString("I've been there before. It wasn't a fun place, but I eventually met a friend who pulled me out. You looked like you still needed that friend.", SCHAR_ASHER, EMOTE_NORMAL, 64, stringpos);
			Cutscene_SetAttr(torrin, CGI_GFX, 51041);
			Cutscene_PlayString("Well, I appreciate you're stickin' around.", SCHAR_TORRIN, EMOTE_NORMAL, 64, stringpos);
			Cutscene_Waitframe(120);
			Cutscene_PlayString("Anyway, before all that, we were talking about that merchant. Any idea who he is?", SCHAR_ASHER, EMOTE_NORMAL, 64, stringpos);
			Cutscene_PlayString("Selet Igorevich is his name.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, stringpos);
			
			Cutscene_SetAttr(kaylani, CGI_GFX, 33301);
			Cutscene_SetCameraTarget(0, 177, 1);
			Cutscene_Waitcamera();
			Cutscene_Waitframe(60);
			Cutscene_SetFlag(torrin, CGF_4WAY);
			Cutscene_RemoveDraw(asher); //For whatever reason, it wasn't work, but redeclaring it fixed it
			asher = Cutscene_NewNPC(1, 128, 120+176, 33284, 6, OP_OPAQUE);
			Cutscene_SetFlag(asher, CGF_4WAY|CGF_BIGNPC);
			Cutscene_SetAttr(torrin, CGI_GFX, 33292);
			Cutscene_SetDir(torrin, DIR_DOWN);
			Cutscene_SetDir(asher, DIR_DOWN);
			Cutscene_Waitframe(30);
			Cutscene_SetDir(torrin, DIR_UP);
			Cutscene_SetDir(asher, DIR_UP);
			
			Cutscene_PlayString("You're awake! Are you alright?", SCHAR_ASHER, EMOTE_SURPRISED, 64, YPOS_UPPER);
			Cutscene_PlayString("I've been better. Still a little unsteady, but nothing some rest won't fix.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_Waitframe(30);
			Cutscene_SetAttr(kaylani, CGI_GFX, 51028);
			Cutscene_Waitframe(15);
			Cutscene_SetAttr(kaylani, CGI_GFX, 51033);
			Cutscene_Waitframe(30);
			Cutscene_PlayString("Here, come an' lean on the stern.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_RemoveDraw(kaylani); //And again...
			kaylani = Cutscene_NewNPC(1, 120, 88+176, 33300, 6, OP_OPAQUE);
			Cutscene_SetFlag(kaylani, CGF_4WAY|CGF_BIGNPC);
			Cutscene_SetFlag(kaylani, CGF_4WAY);
			Cutscene_SetDir(kaylani, DIR_DOWN);
			Cutscene_SetDir(torrin, DIR_RIGHT);
			Cutscene_SetDir(asher, DIR_LEFT);
			Cutscene_Glide(torrin, 0x30, 104, 120, 0.8);
			Cutscene_Glide(asher, 0x30, 136, 120, 0.8);
			Cutscene_Waitglide();
			Cutscene_Glide(kaylani, 0x30, 120, 124, 0.8);
			Cutscene_Waitglide();
			Cutscene_SetDir(kaylani, DIR_UP);
			Cutscene_Waitframe(30);
			Cutscene_SetDir(torrin, DIR_UP);
			Cutscene_SetDir(asher, DIR_UP);
			Cutscene_Glide(torrin, 0x30, 104, 104, 0.8);
			Cutscene_Glide(asher, 0x30, 136, 104, 0.8);
			Cutscene_Waitglide();
			Cutscene_SetDir(torrin, DIR_RIGHT);
			Cutscene_SetDir(asher, DIR_LEFT);
			Cutscene_Glide(torrin, 0x30, 112, 104, 0.8);
			Cutscene_Glide(asher, 0x30, 128, 104, 0.8);
			Cutscene_Waitglide();
			Cutscene_SetDir(torrin, DIR_DOWN);
			Cutscene_SetDir(asher, DIR_DOWN);
			Cutscene_Waitframe(60);
			Cutscene_PlayString("Thank you.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_Waitframe(60);
			Cutscene_PlayString("I believe you owe us your name.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("Kaylani. And you?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("I'm Asher, and this is Torrin.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("Well, Asher and Torrin, I owe you thanks. Now then, who the Hell are you, and what were you doing in that warehouse?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("Aside from bailing you out? Trackin' some stolen cargo.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("Just the two of you?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("Yeah. Why?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("You don't seem like much of an investigative team.", SCHAR_KAYLANI, EMOTE_EYEBROWRAISED, 64, YPOS_UPPER);
			// int tilething = Cutscene_NewTile(1, 112, 280, 105680, 2, 2, 6, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
			// Cutscene_SetAttr(tilething, CGI_MOVESTEP, 0);
			// Cutscene_SetAttr(asher, CGI_X, 300);
			// Cutscene_SetAttr(torrin, CGI_X, 300);
			// for(i=0;i<4; i++){	
				// TraceToScreen(0, Cutscene_GetAttr(tilething, CGI_Y));
				// TraceToScreen(8, Cutscene_GetAttr(tilething, CGI_GFX));
				// Cutscene_SetAttr(tilething, CGI_Y, 280);
				// Cutscene_SetAttr(tilething, CGI_MOVESTEP, 0);
				// Cutscene_SetAttr(tilething, CGI_GFX, 105682+2*i);
				// Cutscene_Waitframe(6);
			// }
			Cutscene_UnsetFlag(torrin, CGF_4WAY);
			Cutscene_UnsetFlag(asher, CGF_4WAY);
			for(int i = 0; i<4; i++){
				Cutscene_SetAttr(torrin, CGI_GFX, 51047+i);
				Cutscene_SetAttr(asher, CGI_GFX, 51053+i);
				Cutscene_Waitframe(6);
			}
			PlayString("Hey, watch yourself now. Ash and I go way back! You couldn't have asked for a better team!", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_Waitframe(6);
			// Cutscene_SetAttr(tilething, CGI_GFX, 105690);
			Cutscene_SetAttr(torrin, CGI_GFX, 51051);
			Cutscene_SetAttr(asher, CGI_GFX, 51057);
			Cutscene_Waitframe(6);
			// Cutscene_SetAttr(tilething, CGI_GFX, 105692);
			Cutscene_SetAttr(torrin, CGI_GFX, 51052);
			Cutscene_SetAttr(asher, CGI_GFX, 51058);
			Cutscene_WaitString();
			Cutscene_PlayString("Uh... what about you, Kaylani? Selet said you were valuable to him.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("That's right. I'm an astronomer. And a solar mage, to boot.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			// Cutscene_SetAttr(asher, CGI_X, 128);
			// Cutscene_SetAttr(torrin, CGI_X, 112);
			Cutscene_SetAttr(torrin, CGI_GFX, 33293);
			Cutscene_SetAttr(asher, CGI_GFX, 33284);
			// Cutscene_RemoveDraw(tilething);
			Cutscene_PlayString("A what now?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("You've never heard of us? Astronomers are people who can look up at the heavens and make calculations about things on earth. The tides, the storms, the flow of solar and lunar magic, all that kind of stuff.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("Uh huh. And that's important to him cuz?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("I don't know what his plan is, but he's got some way of draining magic from people. He wanted my solar magic, but more than that, he wanted my help finding... something.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("Something?", SCHAR_TORRIN, EMOTE_EYEBROWRAISED, 64, YPOS_UPPER);
			Cutscene_PlayString("The details aren't important. Point is, he's draining and storing magic for something, but I don't know what. And I don't know where to find him.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("The pirates! If they're stashing their stolen cargo in that warehouse, and that's where Selet kept you, then that means they're working together, doesn't it?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("It was pirates who captured me originally. At the very least, it seems likely he hired them. When I was on their ship, one of them let slip that their hideout's in a valley on Kawi Island.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("Really? I know the place! It's just east a' here! I could have us there by mornin'! They're sure to spot us if we just sail up the river toward 'em, but if we tie up in the next valley over and make our way on land, we might be able to get the drop on them.", SCHAR_TORRIN, EMOTE_SURPRISED, 64, YPOS_UPPER);
			Cutscene_PlayString("Hold it right there. The two of you are about to storm a pirate stronghold on a whim, just like that? Are either of you even mages?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("Pft, Ash and I don't need any magic to sneak in. We did just fine back there, didn't we?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("Yes, the way you ran away was very impressive.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("We saved your sorry ass, didn't we?", SCHAR_TORRIN, EMOTE_ANGRY, 64, YPOS_UPPER);
			Cutscene_PlayString("Hey! You're a solar mage, aren't you?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("Glad one of you has some sense. I'd love to give those pirates some proper thanks for earlier. Stick with me and you two oughta be fine.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("Perfect, it's a plan then!", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
			PartyPopupCutscene(120, 32, "Kaylani joined the party!", TIL_DB_DIALOGUE_BOX, CS_DB_DIALOGUE_BOX, C_DB_DIALOGUE_BOX_BG, FONT_P, 0xB2, 390, true);	
			Game->PlayMIDI(0);
			for(i=0;i<60;i++){
				BlackishScreenLayerSix();
				Cutscene_Waitframe();
			}
			Game->Counter[CR_STORYFLAG] = SFLAG_METKAYLANI;
			DayNight[_DN_HOUR] = 3;
			DayNight[_DN_MINUTE] = 0;
			DayNight[_DN_SECOND] = 0;
			G[G_HOURCLAMP] = 0;
			G[G_MINUTECLAMP] = 0;
			Link->Item[I_KAYLANI] = true;
			Link->Invisible = false;
			int x = 80;
			int y = 112;
			int scrn = 0x12;
			
			x += (scrn%16)*256;
			y += Floor(scrn/16)*176;
			if(LargeDistance(G[G_OWBOATX], G[G_OWBOATY], x, y, 16)>=24){
				G[G_OWBOATX] = x;
				G[G_OWBOATY] = y;
			}
			G[G_OWBOATDIR] = DIR_UP;
			SetCutsceneSkip(CUTSCENE_NULL); //CUTSCENE_SELETWAREHOUSE
			this->Data = CMB_AUTOWARPA;
		}
		if(scene == 7){
			Link->Invisible = true;
			for(i=0;i<60;i++){
				BlackScreenLayerSix();
				WaitNoAction();
			}
			Game->PlayEnhancedMusic("SS-SeaNight.ogg", 0);
			ffc Battery = FindFreeFFC();
			Battery->Data = 38471;
			Battery->X = 122;
			Battery->Y = 91;
			ffc Kaylani = FindFreeFFC();
			Kaylani->TileHeight = 2;
			Kaylani->Data = 51059;
			Kaylani->X = 130;
			Kaylani->Y = 74;
			ffc Torrin = FindFreeFFC();
			Torrin->TileHeight = 2;
			Torrin->Data = 33295;
			Torrin->X = 110;
			Torrin->Y = 74;
			ffc Asher = FindFreeFFC();
			Asher->TileHeight = 2;
			Asher->Data = 33287;
			Asher->CSet = 6;
			Asher->X = 136;
			Asher->Y = 100;
			for(i=0;i<60;i++){
				BlackishScreenLayerSix();
				WaitNoAction();
			}
			PlayStringAndWait("Nah, you're doin' it wrong. That doohickey unhooks from that.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("This would be easier with some proper tools.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("Do I look like a mechanic? You're lucky I've got this much lyin' around. Now try-", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("I can handle this.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			ClearFFC(Battery);
			Kaylani->Data = 33300;
			WaitNoAction(90);
			Torrin->Data = 33297;
			while(Torrin->Y < Asher->Y){
				Torrin->Y++;
				WaitNoAction();
			}
			Torrin->Data = 33295;
			WaitNoAction(30);
			PlayStringAndWait("What's up, Ash?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			Asher->Data = 33286;
			WaitNoAction(15);
			PlayStringAndWait("Huh? Nothing, just... thinking. What's going on?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("Whatcha mean?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("Selet's got some way of stealing magic from people. He's turning that into weapons. He's giving those weapons to pirates, who are attacking islands under the flags of other islands. But why?", SCHAR_ASHER, EMOTE_QUESTION, 64, YPOS_UPPER);
			PlayStringAndWait("Perhaps he needed field tests of these batteries?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("But then why the false flag attacks? We're missing something here.", SCHAR_ASHER, EMOTE_QUESTION, 64, YPOS_UPPER);
			Kaylani->Data = 33301;
			PlayStringAndWait("There we go. It's open.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			Asher->Data = 33284;
			Torrin->Data = 33292;
			PlayStringAndWait("What's inside?", SCHAR_ASHER, EMOTE_SURPRISED, 64, YPOS_UPPER);
			PlayStringAndWait("Is that a rock?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("That doesn't make sense. How...", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("Wait!", SCHAR_KAYLANI, EMOTE_SURPRISED, 64, YPOS_UPPER);
			PlayStringAndWait("Yeah? Gonna tell us what it is?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("It's... it's nothing.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("That sure didn't look like nothing.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("It has to do with the astronomers, doesn't it?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("It does... but I can't say anything more.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("What's that supposed to mean? If you know what's goin' on, tell us!", SCHAR_TORRIN, EMOTE_ANGRY, 64, YPOS_UPPER);
			PlayStringAndWait("I can't. These are secrets I swore to keep.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("You can trust us, Kaylani. We won't tell anyone. But we're not gonna be much help if you keep us in the dark about everything.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("Very well... but you can't breathe a word of this to anyone.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			for(i=0;i<60;i++){
				BlackishScreenLayerSix();
				WaitNoAction();
			}
			for(i=0;i<60;i++){
				BlackScreenLayerSix();
				WaitNoAction();
			}
			Game->PlayEnhancedMusic("SS-Cosmic.ogg", 0);
			PlayStringAndWaitBlackout("This rock is a piece of a meteor, a stone that fell from the heavens.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWaitBlackout("As you know, all magic, whether solar or lunar, ultimately comes from above. Meteors, pieces of the sky itself, are intrinsically magical.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWaitBlackout("But they're also very rare. Most ignite during their descent, burning away in a flash of light and magic in the sky, becoming shooting stars.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWaitBlackout("For Selet to be mass producing weapons out of them, there's only one place he could be.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWaitBlackout("Ages ago, before the astronomers even existed as a group, the world was a very different place. The seas were lower, and land was abundant.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWaitBlackout("But that all changed one day... I can't tell you everything, but that day, a large meteor - an asteroid - crashed into the oceans, bringing about a calamity unmatched before or since.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWaitBlackout("Tsunamis swept the world, and dust blotted out the sun. Lowlands flooded, crops withered, masses died. And pieces of the asteroid, which broke apart on impact, were scattered across the ocean floor.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			Kaylani->X = 120;
			Kaylani->Y = 96;
			Kaylani->Data = 33300;
			Torrin->X = 112;
			Torrin->Y = 80;
			Torrin->Data = 33293;
			Asher->X = 128;
			Asher->Y = 80;
			Asher->Data = 33285;
			for(i=0;i<60;i++){
				BlackishScreenLayerSix();
				WaitNoAction();
			}
			WaitNoAction(60);
			PlayStringAndWait("If Selet has large quantities of meteor at his disposal, the only explanation is that he's found the impact site.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("And that means he knows that story.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("Yes... a story lost to history, guarded carefully by the astronomers.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("So one a' your lot musta told him.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("There's more to our secret history than what I've told you here, but it's dangerous, forbidden knowledge. I can't imagine one of our own revealing it to a man like Selet. It would be beyond irresponsible.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("He kidnapped you, didn't he? Maybe he snatched away someone else and tortured it outta them.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("Or maybe they only told him the same part of the story you've told us.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("Perhaps... but something doesn't sit right with me about all of this.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("That's a problem for later. If you're right, and he's mining meteors to make these magic weapons, we need to know why. And to stop him.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("That's the spirit!", SCHAR_TORRIN, EMOTE_HAPPY, 64, YPOS_UPPER);
			
			for(i = 0; i<1; i++){
				Torrin->Data = 51047 + i;
				Asher->Data = 51053 + i;
				WaitNoAction(6);
			}
			for(i = 0; i<3; i++){
				Torrin->Data = 51050 + i;
				Asher->Data = 51056 + i;
				WaitNoAction(6);
			}
			PlayStringAndWait("And ta think sneakin' into a warehouse was almost too much for ya before. Look at you now, Ash! Boldly takin' charge!", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("Oh no... I'm turning into you!", SCHAR_ASHER, EMOTE_DISMAYED, 64, YPOS_UPPER);
			PlayStringAndWait("I wouldn't worry about that. You're right though. We need to head to that mining base and figure out what he's up to. The rest can wait.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			Torrin->Data = 51050;
			PlayStringAndWait("Hehe, so 'bout that. Funny story, actually. I can't read this map.", SCHAR_TORRIN, EMOTE_EMBARRASSED, 64, YPOS_UPPER);
			PlayStringAndWait("What!? Aren't you supposed to be some kind of navigator?", SCHAR_KAYLANI, EMOTE_SURPRISED, 64, YPOS_UPPER);
			PlayStringAndWait("Never said I was a good one.", SCHAR_TORRIN, EMOTE_EMBARRASSED, 64, YPOS_UPPER);
			PlayStringAndWait("Then we should return to Pala Bay and-", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("I don't think that's a good idea. With everything going on in that warehouse, Selet probably paid off multiple people on the docks. It's too risky.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("What other options do we have?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			Torrin->Data = 33293;
			Asher->Data = 33285;
			WaitNoAction(15);
			Asher->Data = 33286;
			WaitNoAction(30);
			Torrin->Data = 33295;
			WaitNoAction(15);
			PlayStringAndWait("Let's head to your village and ask someone else to read it for us.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("Pft, my village? Why'd we wanna stop at a boring ole place like that?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			if(G[G_KENJACONVO] == 2){
				PlayStringAndWait("Are you that scared of your mom?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
				PlayStringAndWait("What, scared? Me? Nah, 'course not!", SCHAR_TORRIN, EMOTE_SWEAT, 64, YPOS_UPPER);
				PlayStringAndWait("... Torrin?", SCHAR_ASHER, EMOTE_QUESTION, 64, YPOS_UPPER);
				PlayStringAndWait("Just stay close to me, okay?", SCHAR_TORRIN, EMOTE_EMBARRASSED, 64, YPOS_UPPER);
			}
			else{
				PlayStringAndWait("Aside from the map, it'd be cool to see where you grew up!", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
				PlayStringAndWait("You think?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
				PlayStringAndWait("Yeah!", SCHAR_ASHER, EMOTE_HAPPY, 64, YPOS_UPPER);
				PlayStringAndWait("I s'pose. Let's just make it quick, alright? And stay close to me. And don't mention me to anyone. No particular reason.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			}
			AbilityPopup(128, 88, "Hit cultists and battery-wielding pirates with the fishing rod's hook to steal batteries. Batteries can also be purchased in Pala Bay.", TIL_DB_DIALOGUE_BOX, CS_DB_DIALOGUE_BOX, C_DB_DIALOGUE_BOX_BG, FONT_P, 0xB2, 70473, 6, 3, 0, 0, 0);
			AbilityPopup(128, 88, "Hold the button to choose a battery type. Press left and right to switch between solar and lunar. Tap the button to fire. You can also press map on the subscreen to switch.", TIL_DB_DIALOGUE_BOX, CS_DB_DIALOGUE_BOX, C_DB_DIALOGUE_BOX_BG, FONT_P, 0xB2, 70612, 1, 2, 70614, 1, 2);
			for(i=0;i<60;i++){
				BlackishScreenLayerSix();
				WaitNoAction();
			}
			Link->Item[165] = true;
			FoundItems[165] = true;
			Game->MCounter[CR_SOLARBATTERY] = 20;
			Game->MCounter[CR_LUNARBATTERY] = 20;
			Game->Counter[CR_SOLARBATTERY] = 20;
			Game->Counter[CR_LUNARBATTERY] = 20;
			Game->Counter[CR_STORYFLAG] = SFLAG_LEVEL1;
			DayNight[_DN_HOUR] = 4;
			DayNight[_DN_MINUTE] = 15;
			DayNight[_DN_SECOND] = 0;
			Link->Invisible = false;
			int x = 152;
			int y = 56;
			int scrn = 0x23;
			
			x += (scrn%16)*256;
			y += Floor(scrn/16)*176;
			if(LargeDistance(G[G_OWBOATX], G[G_OWBOATY], x, y, 16)>=24){
				G[G_OWBOATX] = x;
				G[G_OWBOATY] = y;
			}
			G[G_OWBOATDIR] = DIR_UP;
			SetCutsceneSkip(CUTSCENE_NULL); //CUTSCENE_POSTSHELROND
			this->Data = CMB_AUTOWARPA;
		}
		if(scene == 8){
			if(G[G_RANDOMIZERENABLED]){
				Screen->TriggerSecrets();
				Screen->State[ST_SECRET] = true;
				Quit();
			}
			if(Game->Counter[CR_STORYFLAG] < SFLAG_POSTMANOR){
				Waitframe();
				SetCutsceneSkip(CUTSCENE_ASHERRESCUED);
				while(!WalkLinkToPoint(0, 56)){
					Waitframe();
				}
				while(!WalkLinkToPoint(112, 56)){
					Waitframe();
				}
				Cutscene_Init(RT_BITMAP1, RT_BITMAP2);
				Cutscene_AnchorCamera(0x0D, 0x1D, 2, 2);
				Link->Invisible = true;
				int torrin = Cutscene_NewNPC(2, Link->X, Link->Y+176, 33292, 6, OP_OPAQUE);
				Cutscene_SetFlag(torrin, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(torrin, DIR_RIGHT);
				int kaylani = Cutscene_NewNPC(2, Link->X, Link->Y+176, 33300, 6, OP_OPAQUE);
				Cutscene_SetFlag(kaylani, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(kaylani, DIR_RIGHT);
				Cutscene_Glide(kaylani, 0x1D, Link->X+16, Link->Y, 1);
				Cutscene_Waitglide();
				Cutscene_SetDir(kaylani, DIR_LEFT);
				Cutscene_PlayString("This place's freakin' massive. How're we supposed to find him in all this?", SCHAR_TORRIN, EMOTE_SURPRISED, 64, YPOS_LOWER);
				Cutscene_PlayString("We'll just have to keep searching every room. Hold on...This one's locked.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_PlayString("On it!", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_SetDir(torrin, DIR_UP);
				Cutscene_SetDir(kaylani, DIR_UP);
				Cutscene_Glide(torrin, 0x1D, 120, 32, 1);
				Cutscene_Waitglide();
				Game->PlaySound(79);
				// int door = Cutscene_NewTile(1, 112, 16+176, 32969, 2, 1, 2, -1, -1, 0, 0 , 0, 0, true, OP_OPAQUE);
				// Cutscene_SetAttr(door, CGI_DRAWLIFESPAN, -1);
				int door1 = Cutscene_NewFastTile(1, 112, 16+176, 32969, 2, OP_OPAQUE);
				int door2 = Cutscene_NewFastTile(1, 112+16, 16+176, 32970, 2, OP_OPAQUE);
				Cutscene_SetAttr(door1, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(door2, CGI_DRAWLIFESPAN, -1);
				int punch = Cutscene_NewTile(3, 120, 16+176, 104054, 1, 2, 6, -1, -1, 0, 0 , 0, 0, true, OP_OPAQUE);
				Cutscene_SetAttr(punch, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(torrin, CGI_X, 300);
				Game->PlaySound(SFX_SWORD);
				Cutscene_NewAnim(2, 112+8, 16+176, 65333, 1, 1, 6, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE, 5, 2);
				// lweapon l = CreateLWeaponAt(LW_SCRIPT10, 120, 32);
				// RunLWeaponScript(l, "TorrinPunchWeapon", {false, 0});
				// l->UseSprite(SPR_TORRINPUNCH);
				// l->Damage = 0;
				// l->Dir = DIR_UP;
				// l->CollDetection = false;
				Cutscene_Waitframe(15);
				Cutscene_RemoveDraw(punch);
				Cutscene_SetAttr(torrin, CGI_X, 120);
				Cutscene_Waitframe(60);
				Cutscene_PlayString("Hey, we're supposed to be keeping quiet! If Selet hears us, it's all over.", SCHAR_KAYLANI, EMOTE_ANGRY, 64, YPOS_LOWER);
				Cutscene_SetDir(torrin, DIR_DOWN);
				Cutscene_PlayString("An' this is me at my stealthiest today. I'm worried, okay?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_SetDir(torrin, DIR_UP);
				Cutscene_Glide(kaylani, 0x1D, 120, 48, 1);
				Cutscene_Waitglide();
				
				int asher1 = Cutscene_NewTile(2, 113, 44, 104858, 1, 2, 6, -1, -1, 0, 0 , 0, 0, true, OP_OPAQUE);
				Cutscene_SetAttr(asher1, CGI_DRAWLIFESPAN, -1);
				
				Cutscene_Glide(torrin, 0x0D, 120, 96, 1);
				Cutscene_Glide(kaylani, 0x0D, 120, 112, 1);
				Cutscene_SetCameraTarget(0x0D, 1.5);
				Cutscene_Waitcamera();
				Cutscene_Waitglide();
				
				Game->SetScreenState(24, 0x0D, ST_VISITED, true);
				
				Cutscene_PlayString("Is he alright? ", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_PlayString("Speaking from experience, he'll be fine after some rest. The extraction process is extremely painful and exhausting.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_Glide(torrin, 0x0D, 112, 80, 1);
				Cutscene_Waitglide();
				Cutscene_SetAttr(torrin, CGI_LAYER, 3);
				Cutscene_PlayString("Oi. Ash, speak to me! Are you okay?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_SetAttr(asher1, CGI_GFX, 104857);
				Cutscene_PlayString("...@delay(120)@26@26Mm...@delay(120)@26@26Who-@26Torrin!", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_Glide(kaylani, 0x0D, 126, 58, 2);
				Cutscene_Waitglide();
				Cutscene_SetDir(kaylani, DIR_LEFT);
				Cutscene_PlayString("Quiet, both of you. We still have to break you out of here. Where's Selet? Has he already extracted your magic?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_UnsetFlag(kaylani, CGF_4WAY);
				Cutscene_SetAttr(kaylani, CGI_GFX, 51059);
				Cutscene_PlayString("He did. It was horrible... it felt like...@delay(120)@26@26I'd rather not talk about it...", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_PlayString("Gotcha. Let's get you outta here then. I'm not keen on Selet droppin' a star on us.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_SetFlag(kaylani, CGF_4WAY);
				Cutscene_SetAttr(kaylani, CGI_GFX, 33300);
				Cutscene_SetDir(kaylani, DIR_LEFT);
				Cutscene_SetDir(torrin, DIR_RIGHT);
				Cutscene_Glide(torrin, 0x0D, 128, 80, 1);
				Cutscene_Waitglide();
				Cutscene_SetDir(torrin, DIR_LEFT);
				Cutscene_SetAttr(asher1, CGI_GFX, 104793);
				Cutscene_Glide(asher1, 0x0D, 112, 64, 1);
				Cutscene_SetAttr(asher1, CGI_DRAWLIFESPAN, -1);
				Cutscene_Waitglide();
				Cutscene_SetAttr(asher1, CGI_GFX, 105300);
				Cutscene_SetAttr(asher1, CGI_DRAWLIFESPAN, -1);
				Cutscene_PlayString("Sorry. Still having trouble keeping my balance.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_PlayString("It was like this for me, too. C'mon, give me your arm.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				
				Cutscene_SetCameraTarget(0x1D, 1.5);
				Cutscene_Waitcamera();
				Cutscene_RemoveDraw(torrin);
				Cutscene_RemoveDraw(asher1);
				Cutscene_SetDir(kaylani, DIR_DOWN);
				Cutscene_SetAttr(kaylani, CGI_X, 120);
				Cutscene_SetAttr(kaylani, CGI_Y, 160);
				Cutscene_Glide(kaylani, 0x1D, 120, 80, 1);
				Cutscene_Waitglide();
				Cutscene_SetDir(kaylani, DIR_LEFT);
				Cutscene_Waitframe(30);
				Cutscene_SetDir(kaylani, DIR_RIGHT);
				Cutscene_Waitframe(30);
				Cutscene_SetDir(kaylani, DIR_UP);
				Cutscene_Waitframe(30);
				Cutscene_PlayString("Looks like the coast is clear.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				int help = Cutscene_NewCombo(2, 116, 160, 51060, 2, 2, 6, -1, -1, 0, 0, 0, 0, 0, true, OP_OPAQUE);
				Cutscene_SetAttr(help, CGI_DRAWLIFESPAN, -1);
				Cutscene_Glide(help, 0x1D, 116, 32, 0.5);
				Cutscene_Waitglide();
				Cutscene_Waitframe(30);
				Cutscene_SetDir(kaylani, DIR_RIGHT);
				Cutscene_RemoveDraw(help);
				int asher = Cutscene_NewNPC(1, 116, 48+176, 33284, 6, OP_OPAQUE);
				Cutscene_SetFlag(asher, CGF_4WAY|CGF_BIGNPC);
				torrin = Cutscene_NewNPC(2, 124, 48+176, 33292, 6, OP_OPAQUE);
				Cutscene_SetFlag(torrin, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(asher, DIR_RIGHT);
				Cutscene_SetDir(torrin, DIR_RIGHT);
				
				Game->PlayMIDI(0);
				int selet = Cutscene_NewNPC(1, 104+256, 48+176, 51008, 6, OP_OPAQUE);
				Cutscene_SetFlag(selet, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(selet, DIR_LEFT);
				Cutscene_Glide(selet, 0x1D, 192, 48, 0.5);
				
				int stepTimer = 40+Rand(8);
				while(!Cutscene_FinishedGlide(selet)){
					if(stepTimer)
						--stepTimer;
					else{
						Game->PlaySound(Choose(148, 149));
						stepTimer = 40+Rand(8);
					}
					NoAction();
					Cutscene_Waitframe();
				}
				Game->PlayEnhancedMusic("SS-Selet.ogg", 0);
				Cutscene_Waitframe(32);
				
				Cutscene_PlayString("Ah, I was not expecting you two so soon.", SCHAR_SELET, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_Waitframe(90);
				Cutscene_PlayString("The three of you are free to go. I've gotten what I needed from you all, and I'm in a particularly good mood for now.", SCHAR_SELET, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_SetDir(selet, DIR_UP);
				Cutscene_Glide(selet, 0x1D, 192, 32, 0.5);
				stepTimer = 40+Rand(8);
				while(!Cutscene_FinishedGlide(selet)){
					if(stepTimer)
						--stepTimer;
					else{
						Game->PlaySound(Choose(148, 149));
						stepTimer = 40+Rand(8);
					}
					NoAction();
					Cutscene_Waitframe();
				}
				Cutscene_SetDir(selet, DIR_LEFT);
				Cutscene_Glide(selet, 0x1D, 160, 32, 0.5);
				stepTimer = 40+Rand(8);
				while(!Cutscene_FinishedGlide(selet)){
					if(stepTimer)
						--stepTimer;
					else{
						Game->PlaySound(Choose(148, 149));
						stepTimer = 40+Rand(8);
					}
					NoAction();
					Cutscene_Waitframe();
				}
				Cutscene_PlayString("Why you...", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_SetDir(torrin, DIR_UP);
				Cutscene_Glide(torrin, 0x1D, 124, 32, 1.5);
				Cutscene_Waitglide();
				Cutscene_SetAttr(asher, CGI_LAYER, 3);
				Cutscene_SetDir(torrin, DIR_RIGHT);
				Cutscene_SetDir(asher, DIR_UP);
				Cutscene_SetDir(kaylani, DIR_UP);
				Cutscene_PlayString("Torrin, wait. We don't stand a chance against him like this.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_Waitframe(30);
				// Cutscene_UnsetFlag(torrin, CGF_4WAY);
				Cutscene_SetAttr(torrin, CGI_GFX, 51061);
				Game->PlaySound(30);
				Cutscene_Waitframe(90);
				Cutscene_PlayString("He's right, you know. With a flick of my hand, this manor could become a smoldering pyre. Your stellarist friend would be dead weight, and you could do naught to save him. But despite all that you've done, I hold no ill towards you children. Life is a series of transactions, and you've all paid your dues in full. I have all the stellar magic I'll ever need, so I've decided to set you free.", SCHAR_SELET, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_Waitframe(90);
				Cutscene_PlayString("Is this really the hill you want to die on, boy? I mean that in the most literal sense.", SCHAR_SELET, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_Waitframe(90);
				Cutscene_PlayString("Damn it all...", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				// Cutscene_UnsetFlag(torrin, CGF_4WAY);
				Cutscene_SetAttr(torrin, CGI_LAYER, 3);
				Cutscene_SetAttr(torrin, CGI_GFX, 33292);
				Cutscene_SetDir(torrin, DIR_UP);
				Cutscene_Glide(torrin, 0x1D, 124, 48, 1.5);
				Cutscene_Waitglide();
				Cutscene_PlayString("A wise decision.", SCHAR_SELET, EMOTE_NORMAL, 64, YPOS_LOWER);
				stepTimer = 40+Rand(8);
				Cutscene_Glide(selet, 0x1D, 56, 32, 0.5);
				while(!Cutscene_FinishedGlide(selet)){
					if(stepTimer)
						--stepTimer;
					else{
						Game->PlaySound(Choose(148, 149));
						stepTimer = 40+Rand(8);
					}
					NoAction();
					Cutscene_Waitframe();
				}
				Cutscene_SetDir(asher, DIR_LEFT);
				Cutscene_SetDir(torrin, DIR_LEFT);
				Cutscene_SetDir(kaylani, DIR_LEFT);
				Cutscene_SetDir(selet, DIR_RIGHT);
				Cutscene_PlayString("Ah but one last thing. My men are hunting for you. You had best leave my manor at once. Do not squander my mercy.", SCHAR_SELET, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_SetDir(selet, DIR_LEFT);
				Cutscene_Glide(selet, 0x1D, -16, 32, 0.5);
				while(!Cutscene_FinishedGlide(selet)){
					if(stepTimer)
						--stepTimer;
					else{
						Game->PlaySound(Choose(148, 149));
						stepTimer = 40+Rand(8);
					}
					NoAction();
					Cutscene_Waitframe();
				}
				Cutscene_SetDir(torrin, DIR_RIGHT);
				Cutscene_Glide(torrin, 0x1D, 132, 48, 1.5);
				Cutscene_Waitglide();
				Cutscene_SetDir(torrin, DIR_LEFT);
				Cutscene_SetDir(asher, DIR_RIGHT);
				Cutscene_PlayString("Argh... I feel so useless! He was right there. I just had to slug him one...", SCHAR_TORRIN, EMOTE_FURIOUS, 64, YPOS_LOWER);
				Cutscene_SetDir(kaylani, DIR_DOWN);
				Cutscene_PlayString("It's alright, Torrin. This is my fault, anyway. But we'll get him later. For now, you got me outta that room. I appreciate that.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_UnsetFlag(kaylani, CGF_4WAY);
				Cutscene_SetAttr(kaylani, CGI_GFX, 51062);
				Cutscene_PlayString("Oh, that? Pft, that was nothin'. Just doin' what anyone would do.", SCHAR_TORRIN, EMOTE_EMBARRASSED, 64, YPOS_LOWER);
				Cutscene_SetAttr(kaylani, CGI_GFX, 51173);
				Cutscene_PlayString("I don't think anyone would-", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_SetDir(asher, DIR_DOWN);
				Cutscene_SetDir(torrin, DIR_DOWN);
				Cutscene_PlayString("Uh, Kaylani? What's wrong?", SCHAR_ASHER, EMOTE_ELLIPSES, 64, YPOS_LOWER);
				Cutscene_SetFlag(kaylani, CGF_4WAY);
				Cutscene_SetAttr(kaylani, CGI_GFX, 33300);
				Cutscene_Waitframe(60);
				Cutscene_SetDir(kaylani, DIR_UP);
				Cutscene_PlayString("What Selet said back there, about having all the stellar magic he'd ever need... If there's one thing I'd never underestimate about him, it's his bottomless greed. He'd never give Asher up like this. Something's wrong here...", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				int cultist = Cutscene_NewNPC(1, -16, 56+176, 33660, 6, OP_OPAQUE);
				Cutscene_SetFlag(cultist, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(cultist, DIR_RIGHT);
				Cutscene_Glide(cultist, 0x1D, 16, 46, 1.5);
				Cutscene_Waitglide();
				Cutscene_SetDir(asher, DIR_LEFT);
				Cutscene_SetDir(torrin, DIR_LEFT);
				Cutscene_SetDir(kaylani, DIR_LEFT);
				Cutscene_PlayString("Hey! They're over here! They went this way!", SCHAR_LUNARCULTIST, EMOTE_EXCLAMATION, 64, YPOS_LOWER);
				Cutscene_PlayString("Let's talk about this later. For now, run!", SCHAR_ASHER, EMOTE_EXCLAMATION, 64, YPOS_LOWER);
				Cutscene_SetDir(asher, DIR_RIGHT);
				Cutscene_SetDir(torrin, DIR_RIGHT);
				Cutscene_SetDir(kaylani, DIR_RIGHT);
				Cutscene_Glide(asher, 0x1E, 88, 48, 2);
				Cutscene_Glide(torrin, 0x1E, 104, 48, 2);
				Cutscene_Glide(kaylani, 0x1E, 88, 80, 2);
				Cutscene_SetCameraTarget(0x1E, 2);
				Cutscene_Waitcamera();
				Cutscene_Waitglide();
				Game->SetScreenState(24, 0x1E, ST_VISITED, true);
				Cutscene_SetDir(asher, DIR_DOWN);
				Cutscene_SetDir(torrin, DIR_DOWN);
				Cutscene_SetDir(kaylani, DIR_DOWN);
				Cutscene_PlayString("Down here! Lock the door behind you!", SCHAR_KAYLANI, EMOTE_EXCLAMATION, 64, YPOS_LOWER);
				// Cutscene_PlayString("***", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				this->Data = CMB_AUTOWARPA;
			}
		}
		if(scene == 9 && Game->Counter[CR_STORYFLAG] < SFLAG_POSTMANOR){
			Link->Invisible = true;
			SetCharacter(CHAR_KAYLANI, false);
			ffc Kaylani = FindFreeFFC();
			Kaylani->TileHeight = 2;
			Kaylani->Data = 33300;
			Kaylani->X = 40;
			Kaylani->Y = 48;
			Kaylani->Flags[FFCF_OVERLAY] = true;
			ffc Torrin = FindFreeFFC();
			Torrin->TileHeight = 2;
			Torrin->Data = 33292;
			Torrin->X = 40;
			Torrin->Y = 32;
			Torrin->Flags[FFCF_OVERLAY] = true;
			ffc Asher = FindFreeFFC();
			Asher->TileHeight = 2;
			Asher->Data = 33286;
			Asher->CSet = 6;
			Asher->X = 56;
			Asher->Y = 32;
			Asher->Flags[FFCF_OVERLAY] = true;
			WaitNoAction(60);
			PlayStringAndWait("There, think we lost 'em.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("I think we've lost us as well...", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("You didn't have an exit plan?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
			Torrin->Data = 33295;
			WaitNoAction(60);
			PlayStringAndWait("... You serious?", SCHAR_TORRIN, EMOTE_ELLIPSES, 64, YPOS_LOWER);
			WaitNoAction(60);
			PlayStringAndWait("Nevermind, dumb question.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("I feel like I should be at least slightly surprised that Selet's house is built above an ancient burial site. And yet...", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("It seems like it'd be weirder if he DIDN'T have skeletons in his basement.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("So how're we supposed to get out?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("I bet if we head this way-", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
			Asher->Data = 51075;
			Game->PlaySound(11);
			WaitNoAction(60);
			PlayStringAndWait("Nuh uh mate, you're not goin' anywhere like that.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("We're lucky enough that we're not dragging your unconscious body out with us. You're in no shape to explore right now. Torrin, stay with Asher. I'll look for the exit.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("You expect me to let ya do it all on your own?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("If I need any help, I'll come back and talk with you so we can switch. Until then, someone's gotta make sure those guards don't break through and take Asher.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("Heh, I 'spose I can stay and protect Ash for the time bein'. Holler if ya need me, though.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
			Game->Counter[CR_STORYFLAG] = SFLAG_POSTMANOR;
			Link->Item[I_TORRIN] = false;
			Link->Item[I_KAYLANI] = true;
			Link->HP = Link->MaxHP;
			DamageNumbers[_DNUM_LASTLINKHP] = Link->HP;
			G[G_KAYLANIHP] = G[G_KAYLANIMAXHP];
			G[G_TORRINHP] = G[G_TORRINMAXHP];
			Link->Invisible = false;
			ClearFFC(Asher);
			ClearFFC(Torrin);
			ClearFFC(Kaylani);
			for(i=0;i<60;i++){
				BlackScreenLayerSix();
				WaitNoAction();
			}
			int e = RunFFCScript(54, 0);
			ffc f = Screen->LoadFFC(e);
			f->X = 104;
			f->Y = 33;
			SetCutsceneSkip(CUTSCENE_NULL); //CUTSCENE_ASHERRESCUED
		}
		if(scene == 10){
			if(G[G_RANDOMIZERENABLED]){
				Screen->State[ST_SECRET] = true;
				Screen->TriggerSecrets();
				Quit();
			}
			if(Game->Counter[CR_STORYFLAG] == SFLAG_POSTMANOR){
				Waitframe();
				SetCutsceneSkip(CUTSCENE_EXITCATACOMBS);
				Link->Invisible = true;
				mapdata l3 = Game->LoadTempScreen(3);
				l3->ComboD[45] = 35981;
				l3->ComboD[46] = 35981;
				l3->ComboD[61] = 35893;
				l3->ComboD[62] = 35893;
				l3->ComboD[77] = 35897;
				l3->ComboD[78] = 35897;
				l3->ComboD[93] = 10506;
				l3->ComboD[94] = 10507;
				l3->ComboC[45] = 4;
				l3->ComboC[46] = 4;
				l3->ComboC[61] = 4;
				l3->ComboC[62] = 4;
				l3->ComboC[77] = 4;
				l3->ComboC[78] = 4;
				l3->ComboC[93] = 4;
				l3->ComboC[94] = 4;
				WaitNoAction(60);
				Screen->TriggerSecrets();
				Game->PlaySound(67);
				ffc Kaylani = FFCNPC(CMB_KAYLANI, 216, 56);
				SetFFCDir(Kaylani, DIR_DOWN, true);
				// Trace(Kaylani->Data);
				// Trace(Kaylani->X);
				// Trace(Kaylani->Y);
				ffc Help = FindFreeFFC();
				Help->Data = 51065;
				Help->X = 212;
				Help->Y = 24;
				Help->TileWidth = 2;
				Help->TileHeight = 2;
				while(Kaylani->Y < 112){
					Kaylani->Y+=0.5;
					Help->Y+=0.5;
					WaitNoAction();
				}
				SetFFCDir(Kaylani, DIR_UP, false);
				while(Help->Y < 96){
					Help->Y+=0.5;
					WaitNoAction();
				}
				Help->Data++;
				WaitNoAction(60);
				PlayStringAndWait("The catacombs lead here?", SCHAR_KAYLANI, EMOTE_SURPRISED, 64, YPOS_UPPER);
				PlayStringAndWait("The village elder used to complain that all the new construction was damaging old sites. I guess this is what he meant?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
				ffc Asher = FFCNPC(CMB_ASHER, Help->X, Help->Y);
				SetFFCDir(Asher, DIR_LEFT, true);
				ffc Torrin = FFCNPC(CMB_TORRIN, Help->X, Help->Y);
				SetFFCDir(Torrin, DIR_RIGHT, true);
				ClearFFC(Help);
				while(Asher->X > 208){
					Asher->X--;
					Torrin->X++;
					WaitNoAction();
				}
				SetFFCDir(Asher, DIR_RIGHT, false);
				while(Torrin->X < 224){
					Torrin->X++;
					WaitNoAction();
				}
				SetFFCDir(Torrin, DIR_LEFT, false);
				PlayStringAndWait("I think I'm feeling back to normal now. Thanks. Oh, and you can have the jacket back.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
				Fade(true);
				G[G_CLOTHESSWAP] = 0;
				OutfitSwap();
				Fade(false);				
				PlayStringAndWait("Not a problem. Just glad you're back on your feet.", SCHAR_TORRIN, EMOTE_HAPPY, 64, YPOS_UPPER);
				SetFFCDir(Asher, DIR_DOWN, false);
				SetFFCDir(Torrin, DIR_DOWN, false);
				PlayStringAndWait("Back in the manor, you seemed concerned about something.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
				PlayStringAndWait("Selet had a source of stellar magic. And yet, he let you walk right out. Something isn't right.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
				PlayStringAndWait("Reckon he got enough that he'll be set for life?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
				PlayStringAndWait("No. He's greedy beyond all else. There could never be enough to satisfy him.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
				PlayStringAndWait("That means stellar magic wasn't his goal. Just... a stepping stone.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
				PlayStringAndWait("What's more powerful than stellar magic?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
				PlayStringAndWait("I don't know. But there must be something. Something we're not thinking of. I fear... we'll have to ask the other astronomers.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
				PlayStringAndWait("'bout time we got to see your home! What took ya so long?", SCHAR_TORRIN, EMOTE_HAPPY, 64, YPOS_UPPER);
				PlayStringAndWait("I told myself I wouldn't return until I'd fixed this. But... this is beyond me now.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
				PlayStringAndWait("There's no shame in asking for help.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
				PlayStringAndWait("No, but... the chief astronomer is my grandmother. Having to return to her for help is...", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
				PlayStringAndWait("A big ole welt on your ego?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
				PlayStringAndWait("Something like that.", SCHAR_KAYLANI, EMOTE_ANGRY, 64, YPOS_UPPER);
				PlayStringAndWait("Hey, better a bruised ego than body.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
				PlayStringAndWait("Torrin... is your home situation alright?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
				PlayStringAndWait("I'm kiddin', I'm kiddin'. 'ppreciate the concern though. Off to Wahiokala then?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
				PlayStringAndWait("Yes, but the currents around the village are dangerous to navigate. It's probably best if we approach from the west.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
				PlayStringAndWait("Fine by me. Let's pile in the boat.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
				
				PartyPopup(120, 32, "Asher rejoined the party!", TIL_DB_DIALOGUE_BOX, CS_DB_DIALOGUE_BOX, C_DB_DIALOGUE_BOX_BG, FONT_P, 0xB2, 390, true);
				Link->Item[171] = true; //Stellar Sword
				FoundItems[171] = true;
				if(!FoundItems[170]){ //Dash
					Link->Item[170] = true; //Dash
					FoundItems[170] = true;
					if(Game->Counter[CR_SCRIPT1] > 0)
						Game->Counter[CR_SCRIPT1]--;
					else
						G[G_HYMNSTONEDEBT] = 1;
				}
				Link->Invisible = false;
				Link->X = 216;
				Link->Y = 120;
				ClearFFC(Asher);
				ClearFFC(Torrin);
				ClearFFC(Kaylani);
				Game->Counter[CR_STORYFLAG] = SFLAG_ASHERRESCUED;
				Screen->State[ST_SECRET] = true;
				Game->MCounter[CR_STELLARBATTERY] = 20;
				Link->Item[I_ASHER] = true;
				Link->Item[I_TORRIN] = true;
				Link->Item[I_KAYLANI] = true;
				l3->ComboD[45] = 0;
				l3->ComboD[46] = 0;
				l3->ComboD[61] = 0;
				l3->ComboD[62] = 0;
				l3->ComboD[77] = 0;
				l3->ComboD[78] = 0;
				l3->ComboD[93] = 0;
				l3->ComboD[94] = 0;
				for(i=0;i<60;i++){
					BlackScreenLayerSix();
					WaitNoAction();
				}
				SetCutsceneSkip(CUTSCENE_NULL); //CUTSCENE_EXITCATACOMBS
			}
		}
		if(scene == 11 && Game->Counter[CR_STORYFLAG] == SFLAG_ASHERRESCUED){
			SetCutsceneSkip(CUTSCENE_METGRANDMA);
			Link->Invisible = true;
			DayNight[_DN_HOUR] = 16;
			DayNight[_DN_MINUTE] = 0;
			DayNight[_DN_SECOND] = 0;
			G[G_HOURCLAMP] = 16;
			G[G_MINUTECLAMP] = 0;
			ffc Winno = FFCNPC(CMB_WINNO, 197, 80);
			SetFFCDir(Winno, DIR_RIGHT, false);
			ffc Kaylani = FFCNPC(CMB_KAYLANI, Link->X, Link->Y-16);
			SetFFCDir(Kaylani, DIR_RIGHT, false);
			WaitNoAction(60);
			SetFFCDir(Winno, DIR_LEFT, false);
			WaitNoAction(60);
			PlayStringAndWait("Kaylani!", SCHAR_GRANDMA, EMOTE_EXCLAMATION, 64, YPOS_UPPER);
			PlayStringAndWait("Grandmother!", SCHAR_KAYLANI, EMOTE_EXCLAMATION, 64, YPOS_UPPER);
			SetFFCDir(Kaylani, DIR_RIGHT, true);
			SetFFCDir(Winno, DIR_LEFT, true);
			while(Kaylani->X < 160){
				Kaylani->X+=1.5;
				Winno->X-=1.5;
				WaitNoAction();
			}
			SetFFCDir(Kaylani, DIR_RIGHT, false);
			SetFFCDir(Winno, DIR_LEFT, false);
			Winno->X = 300;
			Kaylani->TileWidth = 2;
			Kaylani->Data = 51067;
			WaitNoAction(120);
			PlayStringAndWait("Where have you been? I was so worried about you.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("It's good to be home, Grandmother.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			WaitNoAction(60);
			SetFFCDir(Kaylani, DIR_RIGHT, false);
			SetFFCDir(Winno, DIR_LEFT, true);
			Kaylani->TileWidth = 1;
			Winno->X = Kaylani->X + 5;
			for(i=0; i<11; i++){
				Winno->X++;
				WaitNoAction();
			}
			SetFFCDir(Winno, DIR_LEFT, false);
			PlayStringAndWait("There's a lot I need to explain.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("Yes, I was worried that would be the case. Come, let's talk at the house.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_UPPER);
			SetFFCDir(Winno, DIR_RIGHT, true);
			while(Winno->X < 256){
				Winno->X++;
				WaitNoAction();
			}
			Link->X = Kaylani->X;
			Link->Y = Kaylani->Y+16;
			Link->Dir = DIR_RIGHT;
			SetCharacter(CHAR_KAYLANI, false);
			ClearFFC(Winno);
			ClearFFC(Kaylani);
			Link->Action = LA_ATTACKING;
			WaitNoAction();
			Link->Action = LA_NONE;
			WaitNoAction();
			Link->Invisible = false;
			Game->Counter[CR_STORYFLAG] = SFLAG_METGRANDMA;
			SetCutsceneSkip(CUTSCENE_NULL); //CUTSCENE_METGRANDMA
		}
		if(scene == 12 && Game->Counter[CR_STORYFLAG] == SFLAG_METGRANDMA){
			if(G[G_GRANDMAPROGRESS] == 0&&!G[G_CUTSCENESKIPWARP]){
				SetCutsceneSkip(CUTSCENE_GRANDMA1);
				ffc Winno = FFCNPC(CMB_WINNO, 120, 32);
				SetFFCDir(Winno, DIR_DOWN, false);
				while(!WalkLinkToPoint(120, 88)){
					Waitframe();
				}
				PlayStringAndWait("Alright Kaylani, let's hear what happened.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				Fade(true);
				G[G_ASHERHP] = G[G_ASHERMAXHP];
				G[G_TORRINHP] = G[G_TORRINMAXHP];
				G[G_KAYLANIHP] = G[G_KAYLANIMAXHP];
				Link->HP = Link->MaxHP;
				DamageNumbers[_DNUM_LASTLINKHP] = Link->HP;
				Link->Invisible = true;
				ffc Kaylani = FFCNPC(CMB_KAYLANI, 120, 64);
				SetFFCDir(Kaylani, DIR_UP, false);
				ffc Asher = FFCNPC(CMB_ASHER, 104, 72);
				SetFFCDir(Asher, DIR_UP, false);
				ffc Torrin = FFCNPC(CMB_TORRIN, 136, 72);
				SetFFCDir(Torrin, DIR_UP, false);
				Fade(false);
				PlayStringAndWait("So this Igorevich has his hands on stores of stellar magic now. This is just as I feared.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("You saw this coming?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Since your disappearance, the pirates have gotten bolder with their attacks. The other astronomers have their hands full investigating the stolen magic. And scanning the skies told me a stellar mage was active, the worst possible scenario.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Grandmother, I'm sorry, this is all my fault. If I'd-", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Nonsense. You've shown remarkable ingenuity so far. All three of you have.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				SetFFCDir(Winno, DIR_UP, false);
				WaitNoAction(60);
				PlayStringAndWait("I believe I know what Igorevich's plan is. But first, I'd like to speak with each of you individually.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("I'll go first.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("I figured you would say that. If the two of you wouldn't mind waiting outside.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Of course.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				SetFFCDir(Asher, DIR_DOWN, true);
				SetFFCDir(Torrin, DIR_DOWN, true);
				while(Asher->Y < 112){
					Asher->Y++;
					Torrin->Y++;
					WaitNoAction();
				}
				SetFFCDir(Asher, DIR_RIGHT, true);
				SetFFCDir(Torrin, DIR_LEFT, false);
				while(Asher->X < 120){
					Asher->X++;
					WaitNoAction();
				}
				SetFFCDir(Asher, DIR_DOWN, true);
				SetFFCDir(Torrin, DIR_LEFT, true);
				while(Torrin->X > 120){
					Asher->Y++;
					Torrin->X--;
					WaitNoAction();
				}
				SetFFCDir(Torrin, DIR_DOWN, true);
				while(Torrin->Y < 176){
					Asher->Y++;
					Torrin->Y++;
					WaitNoAction();
				}
				ClearFFC(Asher);
				ClearFFC(Torrin);
				WaitNoAction(30);
				SetFFCDir(Winno, DIR_DOWN, false);
				PlayStringAndWait("What did you want to talk to me about?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Kaylani, I'm very proud of what you've been able to accomplish. I'm also disappointed in you.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("I understand. If I'd realized what Asher was, or if-", SCHAR_KAYLANI, EMOTE_SAD, 64, YPOS_LOWER);
				PlayStringAndWait("That's not what I meant. You should have returned to me right away. We could have addressed this problem together.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("I know. But after Selet had robbed so much solar magic from me, I felt too ashamed to return without fixing my mistake. How am I supposed to succeed you if I can't take responsibility for my mistakes?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("And coming to seek help would have been the responsible decision. One woman cannot save the world alone. Even if we were to accept your kidnapping as a mistake, which I should be clear was not your fault, it was foolish to try to resolve this on your own.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Perhaps. But... I wanted to show you that I'm capable of being a chief.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("There is so much more to being chief than physical or magical strength, Kaylani. Half of my job is delegating tasks to others. I'd have joined my ancestors long ago if I strove to do everything myself. Even now, while most of the astronomers are fighting these pirates on the front lines, I've stayed behind to coordinate our response and assess the situation.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("I understand.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("So you say. Do you consider your friends out there to be your equals?", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("I'm sorry?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("If the situation called for it, would you trust them with jobs in your stead, knowing they would carry them out just as well as you would?", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("I... I guess?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Being a leader requires full confidence in your team. My task for you is to reflect upon this, to embrace it.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("I understand.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Good. Now then, before you send in the next, I want to see how far your skills have come.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("My skills?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Oh come on, Kaylani. Isn't it obvious? I want you to attack me.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("You're kidding, right?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Do I look like I'm kidding? I'm not going to send you after a dangerous madman without assurance you'll be safe. So come on, I'm waiting.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				Game->PlayEnhancedMusic("SS-Test.ogg", 0);
				SetFFCDir(Kaylani, DIR_DOWN, true);
				while(Kaylani->Y < 112){
					Kaylani->Y++;
					WaitNoAction();
				}
				SetFFCDir(Kaylani, DIR_UP, true);
				PlayStringAndWait("... Alright. Here goes.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				Link->Item[I_ASHER] = false;
				SetCharacter(CHAR_KAYLANI, false);
				Link->Item[I_TORRIN] = false;
				Link->Item[I_KAYLANI] = true;
				ffc DoorLight = Screen->LoadFFC(1);
				DoorLight->Data = 0;
				DoorLight->Script = 0;
				Screen->ComboD[ComboAt(112, 144)] = 16638;
				Screen->ComboD[ComboAt(128, 144)] = 16639;
				Link->X = 120;
				Link->Y = 128;
				Link->Invisible = false;
				Link->Dir = DIR_UP;
				ClearFFC(Kaylani);
				CreateNPCAt(230, 120, 48);
				ClearFFC(Winno);
				Screen->D[0] = 0;
				SetCutsceneSkip(CUTSCENE_NULL); //CUTSCENE_GRANDMA1;
			}
			if(G[G_GRANDMAPROGRESS] == 2&&!G[G_CUTSCENESKIPWARP]){
				ffc Winno = FFCNPC(CMB_WINNO, 120, 32);
				SetFFCDir(Winno, DIR_DOWN, false);
				ffc Torrin = FFCNPC(CMB_TORRIN, 120, 160);
				SetFFCDir(Torrin, DIR_UP, true);
				while(Torrin->Y > 64){
					Torrin->Y--;
					WaitNoAction();
				}
				SetFFCDir(Torrin, DIR_UP, false);
				PlayStringAndWait("You wanted to talk to me?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Yes. I understand I have you to thank for Kaylani's safety.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Oh, that? That was as much Ash as me.", SCHAR_TORRIN, EMOTE_EMBARRASSED, 64, YPOS_LOWER);
				PlayStringAndWait("Nonetheless, it was your idea to snoop around the warehouse. You showed ingenuity and initiative, if not a bit of foolishness as well. I was hoping to ask about your motive.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("There ain't much to it. I was mad that no one seemed to be doin' anything about the pirates, so I figured I'd do some investigatin' myself. An' when I saw Kaylani an' Selet, well, I couldn't just stand by.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("And afterwards? Was it that same sense of frustration that drove your actions?", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Well, sorta. But I also wanted to keep Ash safe. Kaylani seemed more than capable, but I'd dragged him into this mess. Not that he needs much protectin' now.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("You're referring to his magic, I take it. I wouldn't be so quick to sell yourself short. Magic is a tool, just like any other weapon. You seem to have more than made up for any natural deficiencies, especially with those stolen batteries you've stockpiled.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("I s'pose. But it hardly feels the same.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("And yet, you've saved both your teammates, magic or no. Your results speak for themselves. Though if you're still feeling inadequate, I'd like to show you just how strong you are.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("... you're not suggestin' a fight, are you?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("What, do you not feel confident in taking down an old woman?", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("No, that ain't- agh, forget it. You're on!", SCHAR_TORRIN, EMOTE_EMBARRASSED, 64, YPOS_LOWER);
				Game->PlayEnhancedMusic("SS-Test.ogg", 0);
				SetFFCDir(Torrin, DIR_DOWN, true);
				while(Torrin->Y < 112){
					Torrin->Y++;
					WaitNoAction();
				}
				SetFFCDir(Torrin, DIR_UP, true);
				Link->Item[I_ASHER] = false;
				SetCharacter(CHAR_TORRIN, false);
				Link->Item[I_TORRIN] = true;
				Link->Item[I_KAYLANI] = false;
				ffc DoorLight = Screen->LoadFFC(1);
				DoorLight->Data = 0;
				DoorLight->Script = 0;
				Screen->ComboD[ComboAt(112, 144)] = 16638;
				Screen->ComboD[ComboAt(128, 144)] = 16639;
				Link->X = 120;
				Link->Y = 128;
				Link->Invisible = false;
				Link->Dir = DIR_UP;
				ClearFFC(Torrin);
				CreateNPCAt(230, 120, 48);
				ClearFFC(Winno);
				Screen->D[0] = 1;
				SetCutsceneSkip(CUTSCENE_NULL); //CUTSCENE_GRANDMA2;
			}
			if(G[G_GRANDMAPROGRESS] == 4&&!G[G_CUTSCENESKIPWARP]){
				SetCutsceneSkip(CUTSCENE_GRANDMA3);
				ffc Winno = FFCNPC(CMB_WINNO, 120, 32);
				SetFFCDir(Winno, DIR_DOWN, false);
				ffc Asher = FFCNPC(CMB_ASHER, 120, 160);
				SetFFCDir(Asher, DIR_UP, true);
				while(Asher->Y > 64){
					Asher->Y--;
					WaitNoAction();
				}
				SetFFCDir(Asher, DIR_UP, false);
				PlayStringAndWait("Um... I assume you wanted to talk to me about my magic.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Very astute. I understand Kaylani's spoken to you about it already, so I'll be brief. You've inherited an exceptional power, Asher. And along with that, an exceptional burden.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Yeah... Kaylani told me about the war, and how one guy sunk the whole continent.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Yes, that is the risk of stellar magic. In terms of raw, destructive power, nothing else compares. If wielded by someone who is slave to their desires, the results would be catastrophic.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("I won't let that happen. I promise!", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("And I believe you. From what Kaylani tells me, we're quite fortunate that the stars chose you to wield this power. I sense some conflict within you, and yet, you've much stronger convictions than most. I'd like to test those now.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("... They really were serious about fighting you?", SCHAR_ASHER, EMOTE_SWEAT, 64, YPOS_LOWER);
				PlayStringAndWait("Afraid so. Just try not to destroy the house. Consider this a lesson in restraint as well.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("O-of course!", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				Game->PlayEnhancedMusic("SS-Test.ogg", 0);
				SetFFCDir(Asher, DIR_DOWN, true);
				while(Asher->Y < 112){
					Asher->Y++;
					WaitNoAction();
				}
				SetFFCDir(Asher, DIR_UP, true);
				Link->Item[I_ASHER] = true;
				SetCharacter(CHAR_ASHER, false);
				Link->Item[I_TORRIN] = false;
				Link->Item[I_KAYLANI] = false;
				ffc DoorLight = Screen->LoadFFC(1);
				DoorLight->Data = 0;
				DoorLight->Script = 0;
				Screen->ComboD[ComboAt(112, 144)] = 17030;
				Screen->ComboD[ComboAt(128, 144)] = 17031;
				Link->X = 120;
				Link->Y = 128;
				Link->Invisible = false;
				Link->Dir = DIR_UP;
				ClearFFC(Asher);
				CreateNPCAt(230, 120, 48);
				ClearFFC(Winno);
				Screen->D[0] = 2;
				SetCutsceneSkip(CUTSCENE_NULL); //CUTSCENE_GRANDMA3;
			}
		}
		if(scene == 13 && Game->Counter[CR_STORYFLAG] == SFLAG_METGRANDMA){
			if(G[G_GRANDMAPROGRESS] == 1){
				SetCutsceneSkip(CUTSCENE_GRANDMA2);
				Link->Invisible = true;
				ffc Asher = FFCNPC(CMB_ASHER, 80, 21);
				SetFFCDir(Asher, DIR_UP, false);
				ffc Torrin = FFCNPC(CMB_TORRIN, 96, 21);
				SetFFCDir(Torrin, DIR_UP, false);
				WaitNoAction(60);
				PlayStringAndWait("Man, it's amazing here. I've heard stories about the beauty of Wahiokala, but I was starting to worry I'd never get away from home.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("You mean to tell me you'd never actually left the island?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Not before all this. Dreamed about it plenty, but I'd never have the guts to steal a boat like you.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("I told ya, I borrowed it! It was our boat anyways!", SCHAR_TORRIN, EMOTE_ANGRY, 64, YPOS_LOWER);
				PlayStringAndWait("Fine, fine, borrowed. Doesn't matter anyways. No one in town has a boat to borrow.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Well shucks, I shoulda come by and whisked you away a while ago.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("I think if you came anywhere within a year of the cart incident, Mom would've probably shipped you back to Malka herself.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Hah, I'd like to see her try and catch me. They don't call me Torrin the Elusive for nothin'!", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				SetFFCDir(Asher, DIR_RIGHT, false);
				WaitNoAction(30);
				PlayStringAndWait("Does ANYONE call you that?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				SetFFCDir(Torrin, DIR_LEFT, false);
				WaitNoAction(30);
				PlayStringAndWait("I do, and that's good enough for me.", SCHAR_TORRIN, EMOTE_HAPPY, 64, YPOS_LOWER);
				PlayStringAndWait("Haha, if you say so.", SCHAR_ASHER, EMOTE_HAPPY, 64, YPOS_LOWER);
				SetFFCDir(Asher, DIR_UP, false);
				SetFFCDir(Torrin, DIR_UP, false);
				WaitNoAction(120);
				PlayStringAndWait("Hey, Ash? What are you gonna do when all this is over?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Well... for starters, I wanna head back home and spend some time with my family. All the excitement's making me appreciate them a little more. Why?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Well, I was thinkin', it'd be fun to putt aroun' a little once the excitement's died down. Ya know, explore the world a bit, without worryin' about meteors an' evil merchants and all.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("But the boat gets a little lonely, out there on the open sea all by your lonesome. So I was wonderin' if you'd be up for taggin' along. Since ya always talk about wantin' to see the world an' all. ", SCHAR_TORRIN, EMOTE_EMBARRASSED, 64, YPOS_LOWER);
				SetFFCDir(Asher, DIR_RIGHT, false);
				PlayStringAndWait("I'd love to!", SCHAR_ASHER, EMOTE_HAPPY, 64, YPOS_LOWER);
				SetFFCDir(Torrin, DIR_LEFT, false);
				PlayStringAndWait("Really?", SCHAR_TORRIN, EMOTE_EMBARRASSED, 64, YPOS_LOWER);
				PlayStringAndWait("Yeah! Seeing the world at our own pace sounds great! And it'd be way more fun to have a friend like you around for it.", SCHAR_ASHER, EMOTE_HAPPY, 64, YPOS_LOWER);
				SetFFCDir(Torrin, DIR_UP, false);
				WaitNoAction(30);
				PlayStringAndWait("Heh, yeah... a friend would be great.", SCHAR_TORRIN, EMOTE_EMBARRASSED, 64, YPOS_LOWER);
				DayNight[_DN_HOUR] = 18;
				DayNight[_DN_MINUTE] = 00;
				DayNight[_DN_SECOND] = 0;
				G[G_HOURCLAMP] = 18;
				G[G_MINUTECLAMP] = 00;
				WaitNoAction(60);
				Game->PlaySound(67);
				SetFFCDir(Asher, DIR_DOWN, false);
				SetFFCDir(Torrin, DIR_DOWN, false);
				Screen->ComboD[ComboAt(160, 96)] = 8516;
				Screen->ComboD[ComboAt(176, 96)] = 8517;
				mapdata l1 = Game->LoadTempScreen(1);
				l1->ComboD[ComboAt(160, 96)] = 8516;
				l1->ComboD[ComboAt(176, 96)] = 8517;
				ffc Kaylani = FFCNPC(CMB_KAYLANI, 168, 80);
				SetFFCDir(Kaylani, DIR_DOWN, true);
				while(Kaylani->Y < 96){
					Kaylani->Y++;
					WaitNoAction();
				}
				SetFFCDir(Kaylani, DIR_LEFT, true);
				while(Kaylani->X > 88){
					Kaylani->X--;
					WaitNoAction();
				}
				SetFFCDir(Kaylani, DIR_UP, true);
				while(Kaylani->Y > 48){
					Kaylani->Y--;
					WaitNoAction();
				}
				SetFFCDir(Kaylani, DIR_UP, false);
				PlayStringAndWait("How'd the talk go?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("It's given me plenty to think about.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Well, guess that means I'm up. Can't wait to see what your grandma thinks of a charismatic stranger like me.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("You do know astronomers are good at reading people, right?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("All the better! She'll be able to see just how extraordinary I am.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				G[G_GRANDMAPROGRESS] = 2;
				this->Data = CMB_AUTOWARPD;
			}
			if(G[G_GRANDMAPROGRESS] == 3){
				SetCutsceneSkip(CUTSCENE_GRANDMA3);
				Link->Invisible = true;
				ffc Kaylani = FFCNPC(CMB_KAYLANI, 80, 21);
				SetFFCDir(Kaylani, DIR_RIGHT, false);
				ffc Asher = FFCNPC(CMB_ASHER, 96, 21);
				SetFFCDir(Asher, DIR_LEFT, false);
				WaitNoAction(60);
				PlayStringAndWait("I've been thinking a lot about what you said earlier. About Selet, and emotions, and all that. I hate him, but... more than anything else, I want to keep everyone safe. I can't do that if I get swept up in that hatred.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("It sounds like you learned that lesson a lot more quickly than I did.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Don't be so hard on yourself. We're here now, getting the help we need. Better late than never.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("I suppose so. I... also owe you an apology. You and Torrin. I underestimated both of you.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Pft, I'd have underestimated myself too. Don't worry about it.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("There's something I still don't understand about you. You aspire to being a hero, and you've naturally got the heart for it. So why are you so quick to temper your kindness with sarcasm?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("You don't have any siblings, do you?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("No, but I don't see how that's related.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Show any weakness and they'll eat you alive. You've gotta be careful with how you meter out your kindness.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("You're a strange man, Asher. I hope you realize that.", SCHAR_KAYLANI, EMOTE_HAPPY, 64, YPOS_LOWER);
				PlayStringAndWait("Hey, look who's talking.", SCHAR_ASHER, EMOTE_HAPPY, 64, YPOS_LOWER);
				PlayStringAndWait("I never said otherwise.", SCHAR_KAYLANI, EMOTE_HAPPY, 64, YPOS_LOWER);
				Game->PlaySound(67);
				SetFFCDir(Asher, DIR_DOWN, false);
				SetFFCDir(Kaylani, DIR_DOWN, false);
				Screen->ComboD[ComboAt(160, 96)] = 8516;
				Screen->ComboD[ComboAt(176, 96)] = 8517;
				mapdata l1 = Game->LoadTempScreen(1);
				l1->ComboD[ComboAt(160, 96)] = 8516;
				l1->ComboD[ComboAt(176, 96)] = 8517;
				ffc Torrin = FFCNPC(CMB_TORRIN, 168, 80);
				SetFFCDir(Torrin, DIR_DOWN, true);
				while(Torrin->Y < 96){
					Torrin->Y++;
					WaitNoAction();
				}
				SetFFCDir(Torrin, DIR_LEFT, true);
				while(Torrin->X > 96){
					Torrin->X--;
					WaitNoAction();
				}
				SetFFCDir(Torrin, DIR_UP, true);
				while(Torrin->Y > 48){
					Torrin->Y--;
					WaitNoAction();
				}
				SetFFCDir(Torrin, DIR_UP, false);
				PlayStringAndWait("You're up, Ash.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Alright. Any advice?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Watch out, she's got a mean left hook.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("... you're joking, right?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("She's faster than she looks, too.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				SetFFCDir(Asher, DIR_LEFT, false);
				WaitNoAction(60);
				SetFFCDir(Asher, DIR_DOWN, false);
				WaitNoAction(60);
				PlayStringAndWait("... Oh no, you ARE serious.", SCHAR_ASHER, EMOTE_DISMAYED, 64, YPOS_LOWER);
				PlayStringAndWait("Relax, you'll be fine. Good luck, mate.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				SetFFCDir(Torrin, DIR_RIGHT, true);
				while(Torrin->X > 80){
					Torrin->X--;
					WaitNoAction();
				}
				SetFFCDir(Torrin, DIR_RIGHT, false);
				SetFFCDir(Asher, DIR_DOWN, true);
				while(Asher->Y < 96){
					Asher->Y++;
					WaitNoAction();
				}
				SetFFCDir(Torrin, DIR_DOWN, false);
				SetFFCDir(Asher, DIR_RIGHT, true);
				while(Asher->X < 168){
					Asher->X++;
					WaitNoAction();
				}
				SetFFCDir(Asher, DIR_UP, true);
				while(Asher->Y > 80){
					Asher->Y--;
					WaitNoAction();
				}
				ClearFFC(Asher);
				Game->PlaySound(67);
				Screen->ComboD[ComboAt(160, 96)] = 8504;
				Screen->ComboD[ComboAt(176, 96)] = 8505;
				WaitNoAction(120);
				DayNight[_DN_HOUR] = 19;
				DayNight[_DN_MINUTE] = 00;
				DayNight[_DN_SECOND] = 0;
				G[G_HOURCLAMP] = 20;
				G[G_MINUTECLAMP] = 00;
				SetFFCDir(Torrin, DIR_RIGHT, true);
				while(Torrin->X < 96){
					Torrin->X++;
					WaitNoAction();
				}
				SetFFCDir(Torrin, DIR_UP, true);
				while(Torrin->Y > 21){
					Torrin->Y--;
					WaitNoAction();
				}
				SetFFCDir(Torrin, DIR_UP, false);
				WaitNoAction(120);
				SetFFCDir(Kaylani, DIR_RIGHT, false);
				PlayStringAndWait("Planning on telling him? Or just staring at him forever?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				SetFFCDir(Torrin, DIR_LEFT, false);
				WaitNoAction(30);
				PlayStringAndWait("I've got no idea what you're talkin' about.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("If you say so.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				WaitNoAction(60);
				PlayStringAndWait("Ugh, is it that obvious?", SCHAR_TORRIN, EMOTE_EMBARRASSED, 64, YPOS_LOWER);
				PlayStringAndWait("I don't think he's noticed, if that's what you're worried about. But yes, you are a little obvious.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Don't you dare say a word to him about this!", SCHAR_TORRIN, EMOTE_ANGRY, 64, YPOS_LOWER);
				PlayStringAndWait("Relax, I have no intentions of getting mixed up in this. Though I do think you ought to talk to him yourself.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("No way! How am I s'posed to do that?", SCHAR_TORRIN, EMOTE_SWEAT, 64, YPOS_LOWER);
				PlayStringAndWait("You can break into a mansion for him, but you can't tell him how you feel?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("He probably doesn't feel the same way. An' I don't wanna lose him now.", SCHAR_TORRIN, EMOTE_SAD, 64, YPOS_LOWER);
				PlayStringAndWait("I don't think you need to worry about either of those. But it's your problem, not mine. I wouldn't keep wasting time when the person I care about's right there, though.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Speaking from experience there?", SCHAR_TORRIN, EMOTE_EYEBROWRAISED, 64, YPOS_LOWER);
				PlayStringAndWait("Just keep what I said in mind.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				G[G_GRANDMAPROGRESS] = 4;
				this->Data = CMB_AUTOWARPD;
			}
			if(G[G_GRANDMAPROGRESS] == 5){
				SetCutsceneSkip(CUTSCENE_GRANDMA4);
				Link->Invisible = true;
				Screen->ComboD[ComboAt(160, 96)] = 8516;
				Screen->ComboD[ComboAt(176, 96)] = 8517;
				mapdata l1 = Game->LoadTempScreen(1);
				l1->ComboD[ComboAt(160, 96)] = 8516;
				l1->ComboD[ComboAt(176, 96)] = 8517;
				ffc Winno = FFCNPC(CMB_WINNO, 80, 64);
				SetFFCDir(Winno, DIR_UP, false);
				ffc Asher = FFCNPC(CMB_ASHER, 96, 48);
				SetFFCDir(Asher, DIR_DOWN, false);
				ffc Torrin = FFCNPC(CMB_TORRIN, 80, 48);
				SetFFCDir(Torrin, DIR_DOWN, false);
				ffc Kaylani = FFCNPC(CMB_KAYLANI, 64, 48);
				SetFFCDir(Kaylani, DIR_DOWN, false);
				WaitNoAction(60);
				PlayStringAndWait("Does this mean we've passed?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("I never explicitly said it was a test, but yes, the three of you pass.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("So what's Selet up to?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("I believe he likely aims to travel to Kohiko and climb Mauna Poho.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Kohiko? What's there but some old ruins?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("A well crafted trap.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				Game->PlayEnhancedMusic("SS-Cosmic.ogg", 0);
				for(i = 0; i<60; i++){
					BlackishScreenLayerSix();
					WaitNoAction();
				}
				mapdata l5 = Game->LoadTempScreen(5);
				for(i=0; i<176; i++)
					l5->ComboD[i] = 3;
				PlayStringAndWait("By now, you all know of the war that led to the calamity, but not what the war was fought for.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				ffc Egg = FindFreeFFC();
				Egg->TileHeight = 2;
				Egg->TileWidth = 2;
				Egg->Data = 64004;
				Egg->X = 120;
				Egg->Y = -32;
				Egg->Flags[FFCF_OVERLAY] = true;
				while(Egg->Y < 72){
					Egg->Y++;
					WaitNoAction();
				}
				PlayStringAndWait("It's a fragment of a meteor that fell from the sky long ago on the eve of the calamity. We know it as the Cosmic Egg.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Nobody knows what exactly it is or where it came from. Generations of Astronomers have debated this since our founding. However, on one point we all agree: It is powerful and dangerous.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Soon after it was first discovered, people began to develop magic. It's said that those who beheld the Egg could even use all three types.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				Egg->Data++;
				PlayStringAndWait("However this age of rapid growth was short lived. Almost immediately, war broke out as several factions scrambled for possession of the Egg.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				Egg->Data=64008;
				PlayStringAndWait("Of the mages who fought in the war, some rumors say they could hear it whispering to them, urging them to claim it. But not a soul survived to verify these accounts.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				Egg->Data = 64005;
				PlayStringAndWait("In the aftermath of the destruction, the first of the Astronomers gained possession of the Egg. Realizing the threat it posed, they sealed it away and let it fade away into obscurity.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				Egg->Data = 64004;
				PlayStringAndWait("Now, it is known only to eldest of the Astronomers. Or at least, it was.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				while(Egg->Y > -32){
					Egg->Y--;
					WaitNoAction();
				}
				WaitNoAction(60);
				for(i=0; i<176; i++)
					l5->ComboD[i] = 0;
				for(i = 0; i<60; i++){
					BlackishScreenLayerSix();
					WaitNoAction();
				}
				PlayStringAndWait("Igorevich knows so many of our secrets, it is safe to assume he knows of the existence of the Cosmic Egg. And this is where my trap comes into play. All astronomers who know of the Egg are told it is in an ancient temple on Mauna Poho. That is a lie. Only the chiefs are told of the Egg's true hiding place.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("The seal on the temple requires all three types of magic to unlock. This is all consistent with his actions to this point.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("So if he got the Cosmic Egg, he'd be able to use all the stellar magic he wants?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("That and more, possibly. Even I don't know the full extent of the Egg's power, though I imagine he has plans to uncover it himself.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("But ya said the Egg ain't actually there.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Indeed. Mauna Poho has sheer cliff faces on all sides. The only approach is through Kohi Canyon and up the route at the far end. As soon as he enters the canyon, we'll be able to move in. He'll be caught.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Do we have enough astronomers on hand? I thought they were busy fighting the pirates?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Do you not have any faith in my ability to read the sky, Kaylani? I've seen hints of a grand trick for months. I've kept an elite group close at hand for this very reason. I've also sent envoys to Malka and Pala Bay to request aid. By the time Igorevich and his men find the temple is empty, they'll have a large force boxing them in.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("I'd like for you three to accompany this force. You should leave the fighting to them, but you possess invaluable firsthand knowledge of the tactics he and his men use. And, if the worst case scenario comes to pass, your combat skills may be required.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("I... I understand. Don't worry, Grandmother. This ends here. If it comes to it, we'll stop him ourselves. I promise.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("I'm sure you will. I've already let the strike force know of the situation. There's some amount of time before they'll be ready, so if there's anything lying around you still wish to do, this would be the time. Once you're ready, you three should head for Kohiko yourselves. I'll remain here to coordinate our strike efforts. Best of luck to all of you.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
				Game->PlayEnhancedMusic("SS-HokuNight.ogg", 0);
				SetFFCDir(Winno, DIR_DOWN, true);
				while(Winno->Y < 96){
					Winno->Y++;
					WaitNoAction();
				}
				SetFFCDir(Winno, DIR_RIGHT, true);
				while(Winno->X < 168){
					Winno->X++;
					WaitNoAction();
				}
				SetFFCDir(Winno, DIR_UP, true);
				while(Winno->Y > 80){
					Winno->Y--;
					WaitNoAction();
				}
				ClearFFC(Winno);
				Game->PlaySound(67);
				Screen->ComboD[ComboAt(160, 96)] = 8504;
				Screen->ComboD[ComboAt(176, 96)] = 8505;
				PlayStringAndWait("Guess we better head o-", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				i = RunFFCScript(Game->GetFFCScript("CanYouFeelTheJankTonight"), {60});
				ffc stars = Screen->LoadFFC(i);
				Asher->Data = 51068;
				PlayStringAndWait("Whoa... falling stars.", SCHAR_ASHER, EMOTE_SURPRISED, 64, YPOS_LOWER);
				Torrin->Data = 51069;
				Kaylani->Data = 51070;
				PlayStringAndWait("That's right. There's a meteor shower tonight.", SCHAR_KAYLANI, EMOTE_IDEA, 64, YPOS_LOWER);
				WaitNoAction(30);
				SetFFCDir(Torrin, DIR_RIGHT, false);
				PlayStringAndWait("I guess we probably got time to watch them for a few minutes.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				Asher->Data = 51071;
				Kaylani->Data = 51072;
				Torrin->Data = 51038;
				WaitNoAction(60);
				Asher->Data = 51040;
				Kaylani->Data = 51042;
				Torrin->Data = 51041;
				WaitNoAction(60);
				PlayStringAndWait("They're beautiful, aren't they?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				WaitNoAction(30);
				Torrin->Data = 51045;
				WaitNoAction(30);
				PlayStringAndWait("Yeah... beautiful.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				Kaylani->Data = 51073;
				WaitNoAction(30);
				PlayStringAndWait("Looks like the stars aren't the only things falling.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				Torrin->Data = 51074;
				WaitNoAction(30);
				Kaylani->Data = 51042;
				PlayStringAndWait("What was that?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Nothin' worth repeatin'. Let's head out.", SCHAR_TORRIN, EMOTE_EMBARRASSED, 64, YPOS_LOWER);
				
				Link->X = 80;
				Link->Y = 64;
				G[G_HOURCLAMP] = 0;
				G[G_MINUTECLAMP] = 00;
				Link->Item[I_ASHER] = true;
				Link->Item[I_TORRIN] = true;
				Link->Item[I_KAYLANI] = true;
				Link->Invisible = false;
				ClearFFC(Asher);
				ClearFFC(Torrin);
				ClearFFC(Kaylani);
				Game->Counter[CR_STORYFLAG] = SFLAG_POSTGRANDMA;
				stars->Script = 0;
				SetCutsceneSkip(CUTSCENE_NULL); //CUTSCENE_GRANDMA4;
				for(i = 0; i<60; i++){
					BlackScreenLayerSix();
					WaitNoAction();
				}
			}
		}
		if(scene == 14 && Game->Counter[CR_STORYFLAG] == SFLAG_ASHERKIDNAPPED && Screen->D[1] == 0){
			G[G_TIMEFROZEN] = 1;
			Game->PlayMIDI(0);
			Link->Invisible = true;
			ffc Torrin = FFCNPC(CMB_TORRIN, 112, 72);
			SetFFCDir(Torrin, DIR_RIGHT, false);
			ffc Kaylani = FFCNPC(CMB_KAYLANI, 128, 72);
			SetFFCDir(Kaylani, DIR_DOWN, false);
			WaitNoAction(60);
			PlayStringAndWait("Ugh... this is a disaster. But... but I can still fix it. We have a bit of time. We need to hurry, though!", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("Hold it. It's 'bout time you told me what's actually goin' on.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			SetFFCDir(Kaylani, DIR_LEFT, false);
			WaitNoAction(30);
			PlayStringAndWait("You want to do this now? We don't have much time.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("So start talking. You've been stringin' me an' Ash along without tellin' us what's actually happenin', and now he's in trouble cuz of it. And if he ends up hurt, you and Selet both are gonna have hell to pay.", SCHAR_TORRIN, EMOTE_ANGRY, 64, YPOS_UPPER);
			PlayStringAndWait("Selet wouldn't dare hurt him. He's too valuable. But if he gets a stockpile of that magic, we're in a world of trouble, so let's move already!", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			SetFFCDir(Torrin, DIR_RIGHT, true);
			while(Torrin->X < 118){
				Torrin->X++;
				WaitNoAction();
			}
			SetFFCDir(Torrin, DIR_RIGHT, false);
			WaitNoAction(10);
			PlayStringAndWait("I'm not takin' you anywhere til you tell me the truth.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("Fine. I'll go myself then.", SCHAR_KAYLANI, EMOTE_ANGRY, 64, YPOS_UPPER);
			SetFFCDir(Kaylani, DIR_DOWN, true);
			while(Kaylani->Y < 96){
				Kaylani->Y++;
				WaitNoAction();
			}
			SetFFCDir(Torrin, DIR_DOWN, false);
			SetFFCDir(Kaylani, DIR_DOWN, false);
			PlayStringAndWait("You really think you can stop him yourself?", SCHAR_TORRIN, EMOTE_ANGRY, 64, YPOS_UPPER);
			PlayStringAndWait("If I have to.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			WaitNoAction(60);
			PlayStringAndWait("It's my fault this happened. I'll end it myself.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("You weren't strong enough alone. Now you're tryin' that same thing again and expectin' it to turn out different. We can help, but you gotta trust us. Stop tryin' to do everything yourself.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			WaitNoAction(60);
			SetFFCDir(Kaylani, DIR_UP, false);
			PlayStringAndWait("...Damn it. Fine. I've gotten you tangled up in all this. The cat's already out of the bag anyway.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			SetFFCDir(Kaylani, DIR_UP, true);
			SetFFCDir(Torrin, DIR_RIGHT, true);
			while(Kaylani->Y > 72){
				Kaylani->Y--;
				if(Torrin->X > 112)
					Torrin->X--;
				else
					SetFFCDir(Torrin, DIR_RIGHT, false);
				WaitNoAction();
			}
			SetFFCDir(Kaylani, DIR_LEFT, false);
			WaitNoAction(30);
			// mapdata l6 = Game->LoadTempScreen(6);
			// for(j = 0; j<176; j++)
				// l6->ComboD[j] = 3;
			Game->PlayEnhancedMusic("SS-Cosmic.ogg", 0);
			PlayStringAndWait("Everyone knows there are two kinds of magic: solar and lunar. But that's a lie. There are three: solar, lunar, and stellar.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("Stellar? You're tellin' me there's a third magic type out there and no one's heard of it?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("It's very rare. And we've done our best to keep its existence hidden. All magic is powerful. But stellar magic is uniquely destructive. It can cause the heavens themselves to rain down upon the earth.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("The heavens to rain down... you're not tellin' me this meteor Selet's mining-", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("I am. In the past, wars were fought with stellar mages. The last stellar war ended when a stellar mage, seeking victory at any cost, called an asteroid onto the battlefield. That caused the calamity that flooded the continent.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("In the aftermath of that war, a group of mages from all the remaining factions came together. They agreed that stellar magic was too dangerous for human hands. So they ensured its knowledge was lost to time.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("But Selet found out somehow. And that's what he wanted you for. To tell him how to get his hands on a stellar mage.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("Yes... I don't know how he found out about their existence, but that troubled me greatly. I refused, but in the end, that didn't matter. He got his mage.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("An' if he gets his hand on stellar magic... he could make himself a king.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("Or he could sell stellar batteries to warring factions for untold profits. It hardly matters. That magic CAN'T fall into the wrong hands.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			// for(j = 0; j<176; j++)
				// l6->ComboD[j] = 0;
			WaitNoAction(120);
			PlayStringAndWait("... you're sure Ash is gonna be fine?", SCHAR_TORRIN, EMOTE_SAD, 64, YPOS_UPPER);
			PlayStringAndWait("Selet kept me alive and in relatively decent health. And a stellar mage is far more valuable than a solar.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("But what if-", SCHAR_TORRIN, EMOTE_SAD, 64, YPOS_UPPER);
			PlayStringAndWait("I know you're worried. But all we can do is get him back as soon as we can.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWait("...Alright.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			WaitNoAction(60);
			PlayStringAndWait("Let's go find Selet and make him pay.", SCHAR_TORRIN, EMOTE_ANGRY, 64, YPOS_UPPER);
			SetFFCDir(Kaylani, DIR_LEFT, true);
			SetFFCDir(Torrin, DIR_RIGHT, true);
			for(i=0; i<8; i++){
				Torrin->X++;
				Kaylani->X--;
				WaitNoAction();
			}
			Link->X = Torrin->X;
			Link->Y = Torrin->Y+16;
			Link->Invisible = false;
			ClearFFC(Torrin);
			ClearFFC(Kaylani);
			int Music[256];
			Game->GetDMapMusicFilename(Game->GetCurDMap(), Music);
			Game->PlayEnhancedMusic(Music, 0);
			Screen->D[1] = 1;
			G[G_TIMEFROZEN] = 0;
			SetCutsceneSkip(CUTSCENE_NULL); //CUTSCENE_POSTSELETMINES
		}
		if(scene == 15 && Game->Counter[CR_STORYFLAG] == SFLAG_POSTGRANDMA){
			while(true){
				while(Link->Y > 96)
					Waitframe();
				PlayStringAndWait("Hold on. Once we join up with the strike team, there's no turning back until we've caught Selet. Is everyone ready to go?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
				int Affirm[] = "Yes";
				int Deny[] = "No";
				int Options[] = {Affirm, Deny};
				int handler[6];
				while(handler[1] == 0){
					DialogueBox_RunSingleFrame(handler, 128, 8+52, Options, TIL_DB_DIALOGUE_BOX, CS_DB_DIALOGUE_BOX, C_DB_DIALOGUE_BOX_BG, FONT_P, 0xB2, TIL_DB_DIALOGUE_SELECTOR, CS_DB_DIALOGUE_SELECTOR);
					WaitNoAction();
					// G[G_NOACTION] = 1;
					// Waitframe();
				}
				if(handler[0] == 0){
					PlayStringAndWait("Let's do this.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
					PlayStringAndWait("I got a knuckle sandwich with Selet's name on it. Let me at 'im.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
					break;
				}
				else{
					PlayStringAndWait("Uh... let's hold off just a few minutes.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
					while(Link->Y < 128){
						NoInput();
						Link->InputDown = true;
						Link->PressDown = true;
						Waitframe();
					}
				}
				Waitframe();
			}
			SetCutsceneSkip(CUTSCENE_POHOENTRY1);
			int playCMB;
			if(GetCharID() == CHAR_ASHER)
				playCMB = 51000;
			else if(GetCharID() == CHAR_TORRIN)
				playCMB = 50952;
			else
				playCMB = 50960;
			Cutscene_Init(RT_BITMAP1, RT_BITMAP2);
			Cutscene_AnchorCamera(0x44, 0x54, 1, 2);
			int plyr = Cutscene_NewNPC(2, Link->X, Link->Y + 176, playCMB, 6, 128);
			Cutscene_SetFlag(plyr, CGF_4WAY|CGF_BS|CGF_BIGNPC);
			Cutscene_SetDir(plyr, DIR_UP);
			Link->Invisible = true;
			
			int allie = Cutscene_NewNPC(1, 112, 64, 33816, 6, OP_OPAQUE);
			Cutscene_SetFlag(allie, CGF_4WAY|CGF_BIGNPC);
			Cutscene_SetDir(allie, DIR_RIGHT);
			int mort = Cutscene_NewNPC(1, 128, 64, 33748, 6, OP_OPAQUE);
			Cutscene_SetFlag(mort, CGF_4WAY|CGF_BIGNPC);
			Cutscene_SetDir(mort, DIR_LEFT);
			int nell = Cutscene_NewNPC(1, 144, 80, 33716, 6, OP_OPAQUE);
			Cutscene_SetFlag(nell, CGF_4WAY|CGF_BIGNPC);
			Cutscene_SetDir(nell, DIR_DOWN);
			int siyed = Cutscene_NewNPC(1, 72, 96, 33764, 6, OP_OPAQUE);
			Cutscene_SetFlag(siyed, CGF_4WAY|CGF_BIGNPC);
			Cutscene_SetDir(siyed, DIR_DOWN);
			Cutscene_SetCameraTarget(0, 0, 0.8);
			Cutscene_Waitcamera();
			Cutscene_Waitglide();
			Cutscene_Waitframe(30);
			Cutscene_PlayString("What's the status?", SCHAR_ALLIE, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_PlayString("We've seen several of Igorevich's men enter the temple. He hasn't exited himself yet. They didn't reseal the temple behind them, so it seems unlikely they expect our arrival.", SCHAR_MORT, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_PlayString("Excellent. Everyone, prepare yourself. We enter in five minutes.", SCHAR_ALLIE, EMOTE_NORMAL, 64, YPOS_LOWER);
			int torrin = Cutscene_NewNPC(1, 120, 48+176, CMB_TORRIN, 6, OP_OPAQUE);
			Cutscene_SetFlag(torrin, CGF_4WAY|CGF_BIGNPC);
			Cutscene_SetDir(torrin, DIR_UP);
			int asher = Cutscene_NewNPC(1, 136, 48+176, CMB_ASHER, 6, OP_OPAQUE);
			Cutscene_SetFlag(asher, CGF_4WAY|CGF_BIGNPC);
			Cutscene_SetDir(asher, DIR_UP);
			int kaylani = Cutscene_NewNPC(1, 104, 48+176, CMB_KAYLANI, 6, OP_OPAQUE);
			Cutscene_SetFlag(kaylani, CGF_4WAY|CGF_BIGNPC);
			Cutscene_SetDir(kaylani, DIR_UP);
			Cutscene_Glide(torrin, 0x44, 120, 128, 0.8);
			Cutscene_Glide(asher, 0x44, 136, 128, 0.8);
			Cutscene_Glide(kaylani, 0x44, 104, 128, 0.8);
			
			Cutscene_SetCameraTarget(0, 32, 0.8);
			Cutscene_Waitcamera();
			Cutscene_Waitglide();
			Cutscene_SetDir(kaylani, DIR_LEFT);
			Cutscene_Glide(kaylani, 0x44, 64, 112, 1);
			Cutscene_Waitglide();
			Cutscene_SetDir(kaylani, DIR_UP);
			Cutscene_PlayString("Siyed? You're part of this operation?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_PlayString("Well, sort of. You know I'm no good at combat, but if they need a medic, I know some basic first aid.", SCHAR_SIYED, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_SetDir(torrin, DIR_LEFT);
			Cutscene_SetDir(asher, DIR_LEFT);
			Cutscene_Glide(torrin, 0x44, 80, 112, 1);
			Cutscene_Glide(asher, 0x44, 96, 96, 1);
			Cutscene_Waitglide();
			Cutscene_SetDir(torrin, DIR_UP);
			if(Game->Counter[CR_GOLEMSIDEQUEST] > 1){
				Cutscene_PlayString("Sure you're up to it? Fighting like this doesn't seem like your sorta thing.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_PlayString("I'm serious about wanting to do more for the astronomers. This may not be much, but it's something.", SCHAR_SIYED, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_PlayString("Nobody's doubting you. A medic could end up way more important than another fighter.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_PlayString("Indeed. Don't sell yourself short, Siyed. I'm sure having someone who knows first aid around will be a huge help.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
			}
			else{
				Cutscene_PlayString("You two know each other?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_PlayString("We've been friends since we were young. We sparred when we were younger, but, uh...", SCHAR_SIYED, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_PlayString("Let's just say Siyed's talents are better spent on academics than fighting.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_PlayString("I just want to make myself useful to the astronomers in some way!", SCHAR_SIYED, EMOTE_EMBARRASSED, 64, YPOS_LOWER);
				Cutscene_PlayString("I'm sure having someone who knows first aid around will be a huge help.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
			}
			
			int band = Cutscene_NewNPC(1, 128, 64+176, 33824, 6, OP_OPAQUE);
			Cutscene_SetFlag(band, CGF_4WAY|CGF_BIGNPC);
			Cutscene_SetDir(band, DIR_UP);
			int kenja = Cutscene_NewNPC(1, 112, 64+176, 33484, 6, OP_OPAQUE);
			Cutscene_SetFlag(kenja, CGF_4WAY|CGF_BIGNPC);
			Cutscene_SetDir(kenja, DIR_UP);
			Cutscene_Glide(band, 0x44, 128, 176, 1);
			Cutscene_Glide(kenja, 0x44, 112, 176, 1);
			Cutscene_Waitglide();
			Cutscene_Waitframe(30);
			Cutscene_SetDir(mort, DIR_DOWN);
			Cutscene_SetDir(allie, DIR_DOWN);
			Cutscene_SetDir(asher, DIR_DOWN);
			Cutscene_SetDir(torrin, DIR_DOWN);
			Cutscene_SetDir(kaylani, DIR_DOWN);
			Cutscene_Waitframe(30);
			Cutscene_PlayString("Band, you came after all.", SCHAR_ALLIE, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_PlayString("I couldn't convince everyone, but found a few numbskulls who said they'd help.", SCHAR_BAND, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("Well I couldn't exactly let Torrin get 'imself into trouble like this, now could I?", SCHAR_KENJA, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_Glide(torrin, 0x44, 112, 160, 1);
			Cutscene_Waitglide();
			Cutscene_PlayString("Hey, I'll have ya know I can get myself outta situations just fine now.", SCHAR_TORRIN, EMOTE_EMBARRASSED, 64, YPOS_UPPER);
			if(Game->Counter[CR_TORRINSIDEQUEST] == 6){
				Cutscene_PlayString("Really now, Torrin?", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_UPPER);
				G[G_TERRYATTEMPLE] = 1;
			}
			int skai = Cutscene_NewNPC(1, 144, 64+176, 33564, 6, OP_OPAQUE);
			Cutscene_SetFlag(skai, CGF_4WAY|CGF_BIGNPC);
			Cutscene_SetDir(skai, DIR_UP);
			int terry = Cutscene_NewNPC(1, 96, 64+176, 33556, 6, OP_OPAQUE);
			Cutscene_SetFlag(terry, CGF_4WAY|CGF_BIGNPC);
			Cutscene_SetDir(terry, DIR_UP);
			Cutscene_Glide(skai, 0x44, 144, 160, 1);
			if(Game->Counter[CR_TORRINSIDEQUEST] == 6)
				Cutscene_Glide(terry, 0x44, 96, 160, 1);
			Cutscene_Waitglide();
			Cutscene_SetDir(skai, DIR_LEFT);
			Cutscene_SetDir(terry, DIR_RIGHT);
			if(Game->Counter[CR_TORRINSIDEQUEST] == 6){
				Cutscene_SetDir(torrin, DIR_LEFT);
				Cutscene_PlayString("Really! I can handle myself!", SCHAR_TORRIN, EMOTE_ANGRY, 64, YPOS_UPPER);
				Cutscene_PlayString("I'll be the judge of that myself.", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_UPPER);
			}
			Cutscene_PlayString("Would you rather me leave this all to you, then?", SCHAR_KENJA, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_SetDir(torrin, DIR_DOWN);
			Cutscene_Waitframe(45);
			Cutscene_PlayString("Nah, I ain't about to turn down the help. It's great to see ya.", SCHAR_TORRIN, EMOTE_HAPPY, 64, YPOS_UPPER);
			if(Game->Counter[CR_TORRINSIDEQUEST] == 6){
				Cutscene_SetDir(torrin, DIR_LEFT);
				Cutscene_Waitframe(45);
				Cutscene_PlayString("Even you.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			}
			Cutscene_SetDir(torrin, DIR_RIGHT);
			Cutscene_Waitframe(30);
			Cutscene_PlayString("Skai? The heck are you doin' here?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("Who d'ya think's been the mastermind behind Malka's defense, Torrin? I'm the most competent lunar mage our village's had in decades.", SCHAR_SKAI, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_SetDir(band, DIR_DOWN);
			Cutscene_Waitframe(45);
			Cutscene_PlayString("And here comes the rest of the backup I arranged for us.", SCHAR_BAND, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_SetDir(skai, DIR_RIGHT);
			Cutscene_SetDir(kenja, DIR_RIGHT);
			Cutscene_SetDir(band, DIR_RIGHT);
			Cutscene_Glide(skai, 0x44, 208, 112, 1);
			Cutscene_Glide(band, 0x44, 200, 128, 1);
			Cutscene_Glide(kenja, 0x44, 184, 128, 1);
			Cutscene_Glide(torrin, 0x44, 192, 112, 1);
			if(Game->Counter[CR_TORRINSIDEQUEST] == 6)
				Cutscene_Glide(terry, 0x44, 176, 112, 1);
			Cutscene_Waitglide();
			Cutscene_SetDir(torrin, DIR_LEFT);
			Cutscene_SetDir(terry, DIR_LEFT);
			Cutscene_SetDir(skai, DIR_LEFT);
			Cutscene_SetDir(band, DIR_LEFT);
			Cutscene_SetDir(kenja, DIR_LEFT);
			int soren = Cutscene_NewNPC(1, 96, 64+176, 33832, 6, OP_OPAQUE);
			Cutscene_SetFlag(soren, CGF_4WAY|CGF_BIGNPC);
			Cutscene_SetDir(soren, DIR_UP);
			if(Game->Counter[CR_MISCSIDEQUEST] == 8){
				G[G_SORENATTEMPLE] = 1;
				Cutscene_Glide(soren, 0x44, 96, 112, 1);
				Cutscene_Waitglide();
				Cutscene_SetDir(kaylani, DIR_RIGHT);
				Cutscene_PlayString("Soren, you're here too?", SCHAR_ASHER, EMOTE_SURPRISED, 64, YPOS_LOWER);
				Cutscene_PlayString("Like I said, I owe ya big time, Asher. May not be able to drop stars from the sky like I hear you can, but beating up a few goons? That I can handle.", SCHAR_SORENPANTS, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_SetDir(soren, DIR_LEFT);
				Cutscene_Glide(soren, 0x44, 80, 112, 1);
				Cutscene_Waitglide();
				Cutscene_SetDir(soren, DIR_DOWN);
				Cutscene_SetDir(kaylani, DIR_DOWN);
			}
			int tulane = Cutscene_NewNPC(1, 120, 64+176, 33332, 6, OP_OPAQUE);
			Cutscene_SetFlag(tulane, CGF_4WAY|CGF_BIGNPC);
			Cutscene_SetDir(tulane, DIR_UP);
			Cutscene_Glide(tulane, 0x44, 120, 160, 0.8);
			Cutscene_Waitglide();
			if(Game->Counter[CR_MISCSIDEQUEST] == 8){
				Cutscene_PlayString("You!? What are you doing here!?", SCHAR_SORENPANTS, EMOTE_SURPRISED, 64, YPOS_LOWER);
				Cutscene_PlayString("I've heard that Igorevich plans to seize a great deal of power and wealth for himself today.", SCHAR_TULANE, EMOTE_NORMAL, 64, YPOS_UPPER);
			}
			else{
				Cutscene_PlayString("You!? ... Who are you?", SCHAR_ASHER, EMOTE_SURPRISED, 64, YPOS_LOWER);
				Cutscene_PlayString("Madame Tulane. I've heard that Igorevich plans to seize a great deal of power and wealth for himself today.", SCHAR_TULANE, EMOTE_NORMAL, 64, YPOS_UPPER);
			}
			Cutscene_PlayString("And this involves you?", SCHAR_ASHER, EMOTE_EYEBROWRAISED, 64, YPOS_LOWER);
			Cutscene_PlayString("Igorevich thinks himself above all other merchants and traders. I've spent the last several months under his disdainful glare, and I won't stand for it any longer. I'm here to see to it that he exits the market permanently.", SCHAR_TULANE, EMOTE_NORMAL, 64, YPOS_UPPER);
			int pirate1 = Cutscene_NewNPC(1, 104, 64+176, 33772, 6, OP_OPAQUE);
			Cutscene_SetFlag(pirate1, CGF_4WAY|CGF_BIGNPC);
			Cutscene_SetDir(pirate1, DIR_UP);
			int pirate2 = Cutscene_NewNPC(1, 136, 64+176, 33772, 6, OP_OPAQUE);
			Cutscene_SetFlag(pirate2, CGF_4WAY|CGF_BIGNPC);
			Cutscene_SetDir(pirate2, DIR_UP);
			Cutscene_Glide(pirate1, 0x44, 104, 176, 0.8);
			Cutscene_Glide(pirate2, 0x44, 136, 176, 0.8);
			Cutscene_Waitglide();
			Cutscene_PlayString("To that end, I've hired some mercenaries to ensure he doesn't leave this island under his own power.", SCHAR_TULANE, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("I'm not sure I appreciate your motivations, but I'm not about to turn down help at this point.", SCHAR_ALLIE, EMOTE_SWEAT, 64, YPOS_LOWER);
			int micah = Cutscene_NewNPC(1, 152, 64+176, 33908, 6, OP_OPAQUE);
			Cutscene_SetFlag(micah, CGF_4WAY|CGF_BIGNPC);
			Cutscene_SetDir(micah, DIR_UP);
			if(Game->Counter[CR_CULTISTQUEST] == 6){
				Cutscene_Glide(micah, 0x44, 152, 128, 0.8);
				Cutscene_Waitglide();
				Cutscene_PlayString("Don't suppose you have room for one more, sis?", SCHAR_MICAH2, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("Micah, you have a lot of nerve showing up here like this. I have half a mind to-", SCHAR_ALLIE, EMOTE_ANGRY, 64, YPOS_LOWER);
				Cutscene_PlayString("Wait! He helped us keep a dangerous artifact out of Selet's hands. I know he messed up, but he's redeemed himself.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_PlayString("I don't know if I'd say I've redeemed myself just yet. But I want to atone for my mistake. What do you say, Allie?", SCHAR_MICAH2, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("... Very well. But I want you staying outside for now. I'll call on you IF that's required.", SCHAR_ALLIE, EMOTE_ELLIPSES, 64, YPOS_LOWER);
				Cutscene_PlayString("I can accept that.", SCHAR_MICAH2, EMOTE_NORMAL, 64, YPOS_UPPER);
			}
			Cutscene_PlayString("Kaylani, I want you and your friends to stay at the back of the attack force. Siyed, and anyone else who's not trained in fighting, remain outside until you hear my signal. I don't want any of you getting in over your heads.", SCHAR_ALLIE, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_SetDir(allie, DIR_UP);
			Cutscene_PlayString("The rest of you, follow me. Let's put an end to this.", SCHAR_ALLIE, EMOTE_NORMAL, 64, YPOS_LOWER);
			this->Data = CMB_AUTOWARPD;
		}
		if(scene == 16 && Game->Counter[CR_STORYFLAG] == SFLAG_MISTCLEAR){
			SetCutsceneSkip(CUTSCENE_GRANDMAPOSTPOHO);
				
			Cutscene_Init(RT_BITMAP1, RT_BITMAP2);
			Cutscene_AnchorCamera(0x75, 0x75, 1, 1);
			int grandma[1];
			grandma[0] = Cutscene_NewNPC(2, 72+32, 48, 33792, 8, 128);
			Cutscene_SetFlag(grandma[0], CGF_4WAY|CGF_BIGNPC);
			int torrin[1];
			torrin[0] = Cutscene_NewNPC(2, 120, 176+16, 50952, 6, 128);
			Cutscene_SetFlag(torrin[0], CGF_4WAY|CGF_BIGNPC|CGF_BS);
			int asher[1];
			asher[0] = Cutscene_NewNPC(2, 120, 176+16, 51000, 6, 128);
			Cutscene_SetFlag(asher[0], CGF_4WAY|CGF_BIGNPC|CGF_BS);
			int kaylani[1];
			kaylani[0] = Cutscene_NewNPC(2, 120, 176+16, 50960, 6, 128);
			Cutscene_SetFlag(kaylani[0], CGF_4WAY|CGF_BIGNPC|CGF_BS);
			
			//Stupid doors and windows
			int f1 = Cutscene_NewFastCombo(1, 112, 112, 16697, 2, OP_OPAQUE);
			int f2 = Cutscene_NewFastCombo(1, 112, 128, 16697, 2, OP_OPAQUE);
			int f3 = Cutscene_NewFastCombo(1, 128, 112, 16697, 2, OP_OPAQUE);
			int f4 = Cutscene_NewFastCombo(1, 128, 128, 16697, 2, OP_OPAQUE);
			int f5 = Cutscene_NewFastCombo(1, 160, 128, 16697, 2, OP_OPAQUE);
			int f6 = Cutscene_NewFastCombo(1, 176, 128, 16697, 2, OP_OPAQUE);
			int f7 = Cutscene_NewFastCombo(1, 64, 128, 48777, 2, OP_OPAQUE);
			int f8 = Cutscene_NewFastCombo(1, 80, 128, 48777, 2, OP_OPAQUE);
			int w1 = Cutscene_NewFastCombo(1, 64, 144, 16286, 2, OP_OPAQUE);
			int w2 = Cutscene_NewFastCombo(1, 80, 144, 16287, 2, OP_OPAQUE);
			int w3 = Cutscene_NewFastCombo(1, 160, 144, 16286, 2, OP_OPAQUE);
			int w4 = Cutscene_NewFastCombo(1, 176, 144, 16287, 2, OP_OPAQUE);
			int d1 = Cutscene_NewFastCombo(1, 112, 144, 16308, 2, OP_OPAQUE);
			int d2 = Cutscene_NewFastCombo(1, 128, 144, 16309, 2, OP_OPAQUE);
			int d3 = Cutscene_NewFastCombo(4, 112, 160, 16312, 2, OP_OPAQUE);
			int d4 = Cutscene_NewFastCombo(4, 128, 160, 16313, 2, OP_OPAQUE);
			if(DayNight_IsBetween(DAYNIGHT_MIDI_NIGHT_START_HOUR, 0, 0, DAYNIGHT_MIDI_NIGHT_END_HOUR, 0, 0)){
				Cutscene_SetAttr(f1, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(f2, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(f3, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(f4, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(f5, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(f6, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(f7, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(f8, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(w1, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(w2, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(w3, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(w4, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(d1, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(d2, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(d3, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(d4, CGI_DRAWLIFESPAN, -1);
			}
			else{
				Cutscene_RemoveDraw(f1);
				Cutscene_RemoveDraw(f2);
				Cutscene_RemoveDraw(f3);
				Cutscene_RemoveDraw(f4);
				Cutscene_RemoveDraw(f5);
				Cutscene_RemoveDraw(f6);
				Cutscene_RemoveDraw(f7);
				Cutscene_RemoveDraw(f8);
				Cutscene_RemoveDraw(w1);
				Cutscene_RemoveDraw(w2);
				Cutscene_RemoveDraw(w3);
				Cutscene_RemoveDraw(w4);
				Cutscene_RemoveDraw(d1);
				Cutscene_RemoveDraw(d2);
				Cutscene_RemoveDraw(d3);
				Cutscene_RemoveDraw(d4);
			}
			
			Cutscene_SetDir(grandma[0], DIR_LEFT);
			Cutscene_GlideRelative(grandma[0], -1, -32, 0, 0.5);
			Cutscene_Waitglide();
			Cutscene_SetDir(grandma[0], DIR_UP);
			Cutscene_SetDir(kaylani[0], DIR_UP);
			Cutscene_SetDir(asher[0], DIR_UP);
			Cutscene_SetDir(torrin[0], DIR_UP);
			Cutscene_Waitframe(32);
			Cutscene_GlideRelative(grandma[0], -1, 0, -8, 0.5);
			Cutscene_Waitglide();
			Cutscene_Waitframe(16);
			Cutscene_GlideRelative(grandma[0], -1, 0, 8, 0.5);
			Cutscene_Waitglide();
			Cutscene_Waitframe(16);
			Cutscene_SetDir(grandma[0], DIR_RIGHT);
			Cutscene_GlideRelative(grandma[0], -1, 64, 0, 0.5);
			Cutscene_Glide(kaylani[0], -1, 120, 104, 1);
			Cutscene_Waitglide(kaylani[0]);
			Cutscene_SetDrawPosition(asher[0], CutX(kaylani[0]), CutY(kaylani[0]));
			Cutscene_SetDrawPosition(torrin[0], CutX(kaylani[0]), CutY(kaylani[0]));
			Cutscene_GlideRelative(asher[0], -1, -16, 0, 1);
			Cutscene_GlideRelative(torrin[0], -1, 16, 0, 1);
			Cutscene_Waitglide();
			Cutscene_SetDir(grandma[0], DIR_DOWN);
			Cutscene_Waitframe(16);
			Cutscene_Glide(grandma[0], -1, 120, 64, 1);
			Cutscene_PlayString("Back already?", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_PlayString("Selet knew. It was a trap. The strike force is out of commission. Selet's going after the Egg.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("What?", SCHAR_GRANDMA, EMOTE_SURPRISED, 64, YPOS_LOWER);
			Cutscene_Waitframe(64);
			Cutscene_PlayString("I see. It's come to this then...", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_GlideRelative(grandma[0], -1, 0, 16, 1);
			Cutscene_PlayString("The Cosmic Egg is hidden inside the Observatory, at the top of Mauna Ali'i. I don't know how Igorevich found this out, but that is an issue for another time.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_PlayString("Then what are we waitin' for! We should be gettin' up that mountain and takin' the Egg ourselves!", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("Climbing Mauna Ali'i is no easy task. It is the tallest mountain known to us. At its peak, the air is thin and the rain freezes into ice, coating a barren desert. Nonetheless, I have full confidence the three of you will be able to make the ascent.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("Three? Are you not coming with us?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("At my age, my lungs would likely not agree with the thin air at the mountain's peak. I'd only hold you back. Besides, your powers have grown to nearly match my own. I wouldn't ask this of you were I not confident in your abilities.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("Don't worry, Grandmother. We'll stop him, I promise.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_Glide(grandma[0], -1, CutX(kaylani[0]), CutY(kaylani[0])-16, 1);
			Cutscene_Waitglide();
			Cutscene_PlayString("I know you will. Keep my advice in mind. Kaylani, don't be afraid to lean upon your companions for aid.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_Glide(grandma[0], -1, CutX(torrin[0]), CutY(torrin[0])-16, 1);
			Cutscene_SetDir(grandma[0], DIR_RIGHT);
			Cutscene_Waitglide();
			Cutscene_SetDir(grandma[0], DIR_DOWN);
			Cutscene_PlayString("Torrin, don't doubt your own skill and ingenuity.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_Glide(grandma[0], -1, CutX(asher[0]), CutY(asher[0])-16, 1);
			Cutscene_SetDir(grandma[0], DIR_LEFT);
			Cutscene_Waitglide();
			Cutscene_SetDir(grandma[0], DIR_DOWN);
			Cutscene_PlayString("And Asher, stay true to yourself, and hold on to your goals tightly.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_Glide(grandma[0], -1, CutX(kaylani[0]), CutY(kaylani[0])-24, 1);
			Cutscene_SetDir(grandma[0], DIR_RIGHT);
			Cutscene_Waitglide();
			Cutscene_SetDir(grandma[0], DIR_DOWN);
			Cutscene_PlayString("I'm sorry for asking this of you, but there's no time. Go, hurry!", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_Waitframe(16);
			Cutscene_SetDir(kaylani[0], DIR_DOWN);
			Cutscene_Glide(kaylani[0], -1, 120, 176+16, 1);
			Cutscene_SetDir(asher[0], DIR_RIGHT);
			Cutscene_GlideRelative(asher[0], -1, 16, 0, 1);
			Cutscene_Waitframe(16);
			Cutscene_SetDir(asher[0], DIR_DOWN);
			Cutscene_Glide(asher[0], -1, 120, 176+6, 1);
			Cutscene_SetDir(torrin[0], DIR_LEFT);
			Cutscene_GlideRelative(torrin[0], -1, -16, 0, 1);
			Cutscene_Waitframe(16);
			Cutscene_SetDir(torrin[0], DIR_DOWN);
			Cutscene_Glide(torrin[0], -1, 120, 176+6, 1);
			Cutscene_Waitglide();
			for(i=0; i<32; ++i){
				Cutscene_NewRectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
				Cutscene_Waitframe();
			}
			Game->Counter[CR_STORYFLAG] = SFLAG_ALIIOPEN;
			SetCutsceneSkip(CUTSCENE_NULL); //CUTSCENE_GRANDMAPOSTPOHO
			Link->Warp(28, 0x02);
			Cutscene_NewRectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
			Cutscene_Waitframe();
		}
		if(scene == 17){
			if(Game->Counter[CR_STORYFLAG] == SFLAG_POSTGRANDMA){
				if(!(Game->Counter[CR_MISTFLAGS] & BF_6)){
					Game->PlayEnhancedMusic("SS-Warehouse.ogg", 0);
					Link->Invisible = true;
					Link->HP = Link->MaxHP;
					DamageNumbers[_DNUM_LASTLINKHP] = Link->HP;
					G[G_ASHERHP] = G[G_ASHERMAXHP];
					G[G_TORRINHP] = G[G_TORRINMAXHP];
					G[G_KAYLANIHP] = G[G_KAYLANIMAXHP];
					G[G_ASHERMP] = Link->MaxMP;
					G[G_KAYLANIMP] = Link->MaxMP;
					ffc Tulane = FFCNPC(33332, 120, 80);
					SetFFCDir(Tulane, DIR_UP, false);
					Tulane->Misc[1] = 1;
					ffc Pirate1 = FFCNPC(33772, 104, 80);
					SetFFCDir(Pirate1, DIR_UP, false);
					Pirate1->Misc[1] = 1;
					ffc Pirate2 = FFCNPC(33772, 136, 80);
					SetFFCDir(Pirate2, DIR_UP, false);
					Pirate2->Misc[1] = 1;
					ffc Band = FFCNPC(33824, 120, 64);
					SetFFCDir(Band, DIR_UP, false);
					ffc Kenja = FFCNPC(33484, 104, 64);
					SetFFCDir(Kenja, DIR_UP, false);
					Kenja->Misc[1] = 1;
					ffc Skai = FFCNPC(33564, 136, 64);
					SetFFCDir(Skai, DIR_UP, false);
					Skai->Misc[1] = 1;
					ffc Allie = FFCNPC(33816, 120, 48);
					SetFFCDir(Allie, DIR_UP, false);
					Allie->Misc[1] = 1;
					ffc Nell = FFCNPC(33716, 104, 48);
					SetFFCDir(Nell, DIR_UP, false);
					Nell->Misc[1] = 1;
					ffc Mort = FFCNPC(33748, 136, 48);
					SetFFCDir(Mort, DIR_UP, false);
					Mort->Misc[1] = 1;
					
					ffc Kaylani = FFCNPC(CMB_KAYLANI, 136, 112);
					SetFFCDir(Kaylani, DIR_UP, false);
					ffc Asher = FFCNPC(CMB_ASHER, 120, 112);
					SetFFCDir(Asher, DIR_UP, false);
					ffc Torrin = FFCNPC(CMB_TORRIN, 104, 112);
					SetFFCDir(Torrin, DIR_UP, false);
					
					ffc Bane = FFCNPC(33856, 120, -32);
					SetFFCDir(Bane, DIR_DOWN, true);
					WaitNoAction(30);
					while(Bane->Y < 0){
						Bane->Y++;
						WaitNoAction();
					}
					SetFFCDir(Bane, DIR_DOWN, false);
					PlayStringAndWait("And so the astronomers enter.", SCHAR_BANE, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("You didn't think we'd let you come and plunder this temple without putting up a resistance, did you?", SCHAR_ALLIE, EMOTE_NORMAL, 64, YPOS_UPPER);
					PlayStringAndWait("Of course not. Your arrival is exactly as predicted.", SCHAR_BANE, EMOTE_NORMAL, 64, YPOS_LOWER);
					Screen->ComboD[151] = 24490;
					Screen->ComboD[152] = 24491;
					Screen->ComboD[167] = 24494;
					Screen->ComboD[168] = 24495;
					Game->PlaySound(9);
					WaitNoAction(60);
					PlayStringAndWait("I should probably mention that Lord Igorevich isn't here.", SCHAR_BANE, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("I doubt that. He wouldn't trust seizing the Cosmic Egg to mooks like yourself.", SCHAR_ALLIE, EMOTE_NORMAL, 64, YPOS_UPPER);
					Game->PlayEnhancedMusic("SS-Spotted.ogg", 0);
					PlayStringAndWait("Ah, but here is where your trap falls apart. He is aware the Cosmic Egg isn't here, and that this temple exists to trap would be thieves.", SCHAR_BANE, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("What!?", SCHAR_ALLIE, EMOTE_SURPRISED, 64, YPOS_UPPER);
					PlayStringAndWait("Furthermore, we have access to a secret route here unbeknownst to the Astronomers. I'm afraid the forces you saw enter the temple are but a fraction of our total forces here.", SCHAR_BANE, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("... It appears I've underestimated you lot.", SCHAR_ALLIE, EMOTE_NORMAL, 64, YPOS_UPPER);
					PlayStringAndWait("Indeed. And now you shall die, courtesy of Lord Igorevich's strength.", SCHAR_BANE, EMOTE_NORMAL, 64, YPOS_LOWER);
					
					Torrin->Script = 64;
					Torrin->InitD[0] = 48;
					
					Bane->Data = 33865;
					i = 0;
					int x = Bane->X;
					int y = Bane->Y+8;
					int ang;
					while(Distance(x, y, 120, 80)>4){
						++i;
						if(i>16)
							SetFFCDir(Bane, DIR_DOWN, false);
						if(i%2==0)
							ParticleAnim(x+Rand(-3, 3), y+Rand(-3, 3), Choose(54600, 54620), 8, 4, 2);
						ang = Angle(x, y, 120, 80);
						x += VectorX(4, ang);
						y += VectorY(4, ang);
						WaitNoAction();
					}
					int expandTime = 16;
					int expandDist = 48;
					int activateDelay = 64;
					int shrinkTime = 16;
					int bmcX[64];
					int bmcY[64];
					int bmcF[64];
					int bmcT[64];
					int count = Floor((2*PI*expandDist)/8);
					int bmc[] = {0, count, Rand(360), bmcX, bmcY, bmcF, bmcT};
					for(i=0; i<expandTime; ++i){
						DrawBloodMoonCage(0, 4, 120, 80, Lerp(0, expandDist, i/expandTime), bmc);
						WaitNoAction();
					}
					for(i=0; i<activateDelay; ++i){
						DrawBloodMoonCage(0, 4, 120, 80, expandDist, bmc);
						WaitNoAction();
					}
					Game->PlaySound(SFX_BLOODMOONCAGE_ACTIVATE);
					for(int i=0; i<60; ++i){
						DrawBloodMoonCage(1, 4, 120, 80, expandDist, bmc);
						WaitNoAction();
					}
					SetFFCDir(Tulane, DIR_DOWN, false);
					SetFFCDir(Pirate1, DIR_DOWN, false);
					SetFFCDir(Pirate2, DIR_RIGHT, false);
					SetFFCDir(Skai, DIR_RIGHT, false);
					SetFFCDir(Mort, DIR_RIGHT, false);
					SetFFCDir(Nell, DIR_LEFT, false);
					SetFFCDir(Kenja, DIR_LEFT, false);
					PlayStringAndWaitCage("This spell... this is lunar magic, but tainted. What have you done?", SCHAR_SKAI, EMOTE_SURPRISED, 64, YPOS_UPPER, expandDist, bmc);
					Game->PlaySound(68);
					Game->PlaySound(67);
					PlayStringAndWaitCage("Allie, the floor!", SCHAR_BAND, EMOTE_SURPRISED, 64, YPOS_UPPER, expandDist, bmc);
					Screen->ComboD[87] = 27313;
					Screen->ComboD[88] = 27313;
					Screen->ComboC[87] = 3;
					Screen->ComboC[88] = 3;
					Game->PlaySound(38);
					ParticleAnim(Band->X, Band->Y+16, 97);
					ClearFFC(Band);
					for(int i=0; i<60; ++i){
						DrawBloodMoonCage(1, 4, 120, 80, expandDist, bmc);
						WaitNoAction();
					}
					PlayStringAndWaitCage("Enjoy your trip down.", SCHAR_BANE, EMOTE_NORMAL, 64, YPOS_LOWER, expandDist, bmc);
					
					int numfall;
					if(shrinkTime){
						for(int i=0; i<shrinkTime; ++i){
							int tempRad = Lerp(expandDist, 0, i/shrinkTime);
							DrawBloodMoonCage(1, 4, 120, 80, Lerp(expandDist, 0, i/shrinkTime), bmc);
							Waitdraw();
							for(j = 1; j<32; j++){
								ffc DraggedNPC = Screen->LoadFFC(j);
								if(DraggedNPC->Misc[1] == 1){
									if(numfall==7){
										ParticleAnim(Clamp(DraggedNPC->X+8,116,124), Clamp(DraggedNPC->Y+24,78,84), 97);
										ClearFFC(DraggedNPC);
										Game->PlaySound(38);
									}
									int numpush;
									while(Distance(DraggedNPC->X, DraggedNPC->Y+16, 120, 80) > tempRad){
										DraggedNPC->X+=VectorX(1, Angle(DraggedNPC->X, DraggedNPC->Y, 120, 80));
										DraggedNPC->Y+=VectorY(1, Angle(DraggedNPC->X, DraggedNPC->Y, 120, 80));
										numpush++;
										if(numpush>20)
											break;
									}
									if(Distance(DraggedNPC->X+8, DraggedNPC->Y+24, 120, 80) <= 4 || numpush > 20){
										ParticleAnim(Clamp(DraggedNPC->X+8,116,124), Clamp(DraggedNPC->Y+24,78,84), 97);
										ClearFFC(DraggedNPC);
										Game->PlaySound(38);
										numfall++;
									}
								}
							}
							WaitNoAction();
						}
						if(Allie->Data != 0){ //The woman is too damn stubborn to fall in the pit sometimes
							ParticleAnim(Clamp(Allie->X+8,116,124), Clamp(Allie->Y+24,78,84), 97);
							ClearFFC(Allie);
							Game->PlaySound(38);
						}
						for(int i=0; i<8; ++i){
							DrawBloodMoonCage(2, 4, 120, 80, 0, bmc);
							WaitNoAction();
						}
					}
					WaitNoAction(60);
					Game->PlaySound(68);
					Screen->ComboD[87] = 27692;
					Screen->ComboD[88] = 27692;
					Screen->ComboC[87] = 2;
					Screen->ComboC[88] = 2;
					WaitNoAction(60);
					SetFFCDir(Asher, DIR_RIGHT, true);
					SetFFCDir(Torrin, DIR_RIGHT, true);
					SetFFCDir(Kaylani, DIR_RIGHT, true);
					while(Asher->X < 120){
						Asher->X++;
						Torrin->X++;
						Kaylani->X++;
						WaitNoAction();
					}
					SetFFCDir(Asher, DIR_UP, false);
					SetFFCDir(Torrin, DIR_UP, false);
					SetFFCDir(Kaylani, DIR_UP, false);
					WaitNoAction(60);
					PlayStringAndWait("You three again? You've proved to be quite obnoxious. Even if you did lead the astronomers straight into this trap, as Lord Igorevich said you would.", SCHAR_BANE, EMOTE_NORMAL, 64, YPOS_LOWER);
					Bane->Data = 33868;
					WaitNoAction(30);
					ffc Sol1 = FFCNPC(33652, 0, 64);
					SetFFCDir(Sol1, DIR_RIGHT, true);
					ffc Lun1 = FFCNPC(33660, -16, 64);
					SetFFCDir(Lun1, DIR_RIGHT, true);
					// ffc Ste1 = FFCNPC(33668, -32, 64);
					// SetFFCDir(Ste1, DIR_RIGHT, true);
					ffc Sol2 = FFCNPC(33652, 240, 64);
					SetFFCDir(Sol2, DIR_LEFT, true);
					ffc Lun2 = FFCNPC(33660, 256, 64);
					SetFFCDir(Lun2, DIR_LEFT, true);
					// ffc Ste2 = FFCNPC(33668, 272, 64);
					// SetFFCDir(Ste2, DIR_LEFT, true);
					while(Sol1->X < 64){
						Sol1->X++;
						Lun1->X++;
						// Ste1->X++;
						Sol2->X--;
						Lun2->X--;
						// Ste2->X--;
						WaitNoAction();
					}
					SetFFCDir(Sol1, DIR_RIGHT, false);
					SetFFCDir(Lun1, DIR_RIGHT, false);
					// SetFFCDir(Ste1, DIR_RIGHT, false);
					SetFFCDir(Sol2, DIR_LEFT, false);
					SetFFCDir(Lun2, DIR_LEFT, false);
					// SetFFCDir(Ste2, DIR_LEFT, false);
					PlayStringAndWait("Lord Igorevich says he no longer cares if they live or die. Do what you will, men.", SCHAR_BANE, EMOTE_NORMAL, 64, YPOS_LOWER);
					SetFFCDir(Bane, DIR_UP, true);
					while(Bane->Y > -32){
						Bane->Y--;
						WaitNoAction();
					}
					SetFFCDir(Torrin, DIR_RIGHT, true);
					SetFFCDir(Kaylani, DIR_LEFT, true);
					while(Torrin->X < Asher->X){
						Torrin->X++;
						Kaylani->X--;
						WaitNoAction();
					}
					Link->Invisible = false;
					ClearFFC(Asher);
					ClearFFC(Torrin);
					ClearFFC(Kaylani);
					ClearFFC(Bane);
					ClearFFC(Sol1);
					ClearFFC(Lun1);
					// ClearFFC(Ste1);
					ClearFFC(Sol2);
					ClearFFC(Lun2);
					// ClearFFC(Ste2);
					Game->Counter[CR_MISTFLAGS] |= BF_6;
					Screen->D[1] = 1;
				}
				if(Screen->D[1] == 0)
					Game->PlayEnhancedMusic("SS-Spotted.ogg", 0);
				Screen->D[1] = 0;
				Screen->ComboD[151] = 24490;
				Screen->ComboD[152] = 24491;
				Screen->ComboD[167] = 24494;
				Screen->ComboD[168] = 24495;
				
				Game->PlaySound(9);
				Screen->ComboD[64] = 24644;
				Screen->ComboD[65] = 24645;
				Screen->ComboD[80] = 24648;
				Screen->ComboD[81] = 24649;
				Screen->ComboD[96] = 24652;
				Screen->ComboD[97] = 24653;
				
				Screen->ComboD[78] = 24646;
				Screen->ComboD[79] = 24647;
				Screen->ComboD[94] = 24650;
				Screen->ComboD[95] = 24651;
				Screen->ComboD[110] = 24654;
				Screen->ComboD[111] = 24655;
				
				SetCutsceneSkip(CUTSCENE_NULL); //CUTSCENE_POHOENTRY1
				
				CreateNPCAt(186, 64, 80);
				CreateNPCAt(207, 48, 80);
				// CreateNPCAt(211, 32, 80);
				CreateNPCAt(206, 176, 80);
				CreateNPCAt(188, 192, 80);
				// CreateNPCAt(211, 208, 80);
				Waitframes(8);
				while(Screen->NumNPCs() > 0)
					Waitframe();
				
				SetCutsceneSkip(CUTSCENE_POHOENTRY2);
				
				Game->PlayMIDI(0);
				Link->HP = Link->MaxHP;
				DamageNumbers[_DNUM_LASTLINKHP] = Link->HP;
				G[G_ASHERHP] = G[G_ASHERMAXHP];
				G[G_TORRINHP] = G[G_TORRINMAXHP];
				G[G_KAYLANIHP] = G[G_KAYLANIMAXHP];
				G[G_ASHERMP] = Link->MaxMP;
				G[G_KAYLANIMP] = Link->MaxMP;
				Link->Invisible = true;
				
				Game->PlaySound(9);
				Screen->ComboD[64] = 24632;
				Screen->ComboD[65] = 24633;
				Screen->ComboD[80] = 24636;
				Screen->ComboD[81] = 24637;
				Screen->ComboD[96] = 24640;
				Screen->ComboD[97] = 24641;
				
				Screen->ComboD[78] = 24634;
				Screen->ComboD[79] = 24635;
				Screen->ComboD[94] = 24638;
				Screen->ComboD[95] = 24639;
				Screen->ComboD[110] = 24642;
				Screen->ComboD[111] = 24643;
				for(i = 0; i<60; i++){
					BlackScreenLayerSix();
					WaitNoAction();
				}
				ffc Kaylani = FFCNPC(CMB_KAYLANI, 136, 112);
				SetFFCDir(Kaylani, DIR_LEFT, false);
				ffc Asher = FFCNPC(CMB_ASHER, 120, 112);
				SetFFCDir(Asher, DIR_UP, false);
				ffc Torrin = FFCNPC(CMB_TORRIN, 104, 112);
				SetFFCDir(Torrin, DIR_RIGHT, false);
				PlayStringAndWait("Well this went south in a hurry.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
				PlayStringAndWait("We need to find an exit and warn Grandmother, fast!", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
				PlayStringAndWait("What about everyone else? We can't just leave them here!", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
				SetFFCDir(Torrin, DIR_UP, false);
				SetFFCDir(Kaylani, DIR_UP, false);
								
				Game->PlaySound(38);
				int y = -32;
				int accl;
				while(y < 80){
					if(accl < 3.2)
						accl+=0.16;
					y+=accl;
					Screen->DrawTile(2, 120, y, 110660, 1, 2, 6, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
					DrawShadow1x1(120, 96);
					WaitNoAction();
				}
				Game->PlaySound(16);
				ffc Siyed = FFCNPC(33764, 120, 80);
				Siyed->Data = 33869;
				WaitNoAction(45);
				SetFFCDir(Siyed, DIR_DOWN, false);
				
				
				PlayStringAndWait("Kaylani, what happened!? Where is everyone?", SCHAR_SIYED, EMOTE_DISMAYED, 64, YPOS_UPPER);
				PlayStringAndWait("This was a trap. The others were pushed into the basement with magic. We don't know what's become of them, and the door's locked behind us.", SCHAR_KAYLANI, EMOTE_ANGRY, 64, YPOS_UPPER);
				PlayStringAndWait("How'd you get in here?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
				PlayStringAndWait("There's a small hole in the ceiling, but it's pretty much a one way trip...", SCHAR_SIYED, EMOTE_NORMAL, 64, YPOS_UPPER);
				PlayStringAndWait("What are the odds of you bein' able to open that door?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
				PlayStringAndWait("Uh... give me some time and maybe I could get it open.", SCHAR_SIYED, EMOTE_NORMAL, 64, YPOS_UPPER);
				if(Game->Counter[CR_TORRINSIDEQUEST] == 6){
					PlayStringAndWait("I can work on trying to get it open from the outside too. Leave the door to us, Torrin. Go help the others!", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_UPPER);
				}
				if(Game->Counter[CR_CULTISTQUEST] == 6 && Game->Counter[CR_MISCSIDEQUEST] == 8){
					PlayStringAndWait("I heard the lead cultist mention a secret entrance. We can try to locate that in case the door doesn't open.", SCHAR_MICAH2, EMOTE_NORMAL, 64, YPOS_UPPER);
					PlayStringAndWait("Hang tight guys, we'll find it in time!", SCHAR_SORENPANTS, EMOTE_NORMAL, 64, YPOS_UPPER);
				}
				else if(Game->Counter[CR_CULTISTQUEST] == 6){
					PlayStringAndWait("I heard the lead cultist mention a secret entrance. I can try to locate that in case the door doesn't open.", SCHAR_MICAH2, EMOTE_NORMAL, 64, YPOS_UPPER);
				}
				else if(Game->Counter[CR_MISCSIDEQUEST] == 8){
					PlayStringAndWait("That high and mighty guy mentioned a secret entrance. I'll look around for it, in case you can't get the door open.", SCHAR_SORENPANTS, EMOTE_NORMAL, 64, YPOS_UPPER);
				}
				PlayStringAndWait("Alright, here's the plan. We'll go find the others, make sure they're okay, and bring them back here for medical help. You work on getting that door open so we can escape.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
				PlayStringAndWait("So much wasted time... but I concur. Let's hurry!", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
				Link->Invisible = false;
				ClearFFC(Asher);
				ClearFFC(Torrin);
				ClearFFC(Kaylani);
				ClearFFC(Siyed);
				Link->X = 120;
				Link->Y = 128;
				Game->Counter[CR_STORYFLAG] = SFLAG_MISTENTERED;
				ffc NPC = FindFreeFFC();
				NPC->Script = 38;
				NPC->Data = 33764;
				NPC->X = 96;
				NPC->Y = 112;
				NPC->TileHeight = 2;
				NPC->InitD[0] = 85;
				for(i = 0; i<60; i++){
					BlackScreenLayerSix();
					WaitNoAction();
				}
				int Music[256];
				Game->GetDMapMusicFilename(Game->GetCurDMap(), Music);
				Game->PlayEnhancedMusic(Music, 0);
				SetCutsceneSkip(CUTSCENE_NULL); //CUTSCENE_POHOENTRY2
			}
			if(Game->Counter[CR_STORYFLAG] == SFLAG_MISTENTERED){
				Screen->ComboD[151] = 24490;
				Screen->ComboD[152] = 24491;
				Screen->ComboD[167] = 24494;
				Screen->ComboD[168] = 24495;
				Waitframe();
				if(Game->Counter[CR_MISTFLAGS] & BF_4 && Game->Counter[CR_MISTFLAGS] & BF_5 && !(Game->Counter[CR_MISTFLAGS] & BF_7)){
					SetCutsceneSkip(CUTSCENE_POHOEND);
					Link->Invisible = true;
					ffc S1 = Screen->LoadFFC(1);
					S1->Data = 0;
					S1->Script = 0;
					S1->X = 300;
					for(i = 0; i<60; i++){
						BlackScreenLayerSix();
						WaitNoAction();
					}
					ffc Kaylani = FFCNPC(CMB_KAYLANI, 136, 112);
					SetFFCDir(Kaylani, DIR_UP, false);
					ffc Asher = FFCNPC(CMB_ASHER, 120, 112);
					SetFFCDir(Asher, DIR_UP, false);
					ffc Torrin = FFCNPC(CMB_TORRIN, 104, 112);
					SetFFCDir(Torrin, DIR_UP, false);
					ffc Siyed = FFCNPC(33764, 120, 80);
					SetFFCDir(Siyed, DIR_DOWN, false);
					PlayStringAndWait("Siyed! What's the status on the door?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
					PlayStringAndWait("No good. I've figured it out, but it'll take a while to get open.", SCHAR_SIYED, EMOTE_SAD, 64, YPOS_UPPER);
					PlayStringAndWait("Dammit. By the time we get out of here, Selet will have the Egg.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
					if(Game->Counter[CR_CULTISTQUEST] == 6 && Game->Counter[CR_MISCSIDEQUEST] == 8 && Game->Counter[CR_TORRINSIDEQUEST] == 6){
						PlayStringAndWait("Hold on a sec. Soren says he and Micah found another entrance. May not be the easiest to get a bunch of injured folks out, but we can probably get you three out. It's near that hidden entrance they talked about though, and Selet's men are hanging around.", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_UPPER);
						PlayStringAndWait("Of course... that could work.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
						PlayStringAndWait("Tell them to wait by the entrance and stay out of sight. We'll come at it from the other side.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
					}
					else if(Game->Counter[CR_CULTISTQUEST] == 6 && Game->Counter[CR_TORRINSIDEQUEST] == 6){
						PlayStringAndWait("Hold on a sec. Micah says he found another entrance. May not be the easiest to get a bunch of injured folks out, but we can probably get you three out. It's near that hidden entrance they talked about though, and Selet's men are hanging around.", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_UPPER);
						PlayStringAndWait("Of course... that could work.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
						PlayStringAndWait("Tell them to wait by the entrance and stay out of sight. We'll come at it from the other side.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
					}
					else if(Game->Counter[CR_MISCSIDEQUEST] == 8 && Game->Counter[CR_TORRINSIDEQUEST] == 6){
						PlayStringAndWait("Hold on a sec. Soren says he found another entrance. May not be the easiest to get a bunch of injured folks out, but we can probably get you three out. It's near that hidden entrance they talked about though, and Selet's men are hanging around.", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_UPPER);
						PlayStringAndWait("Of course... that could work.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
						PlayStringAndWait("Tell them to wait by the entrance and stay out of sight. We'll come at it from the other side.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
					}
					else if(Game->Counter[CR_CULTISTQUEST] == 6 && Game->Counter[CR_MISCSIDEQUEST] == 8){
						PlayStringAndWait("Hold on a sec. Micah and I found another entrance. May not be the easiest to get a bunch of injured folks out, but we can probably get you three out. It's near that hidden entrance they talked about though, and Selet's men are hanging around.", SCHAR_SORENPANTS, EMOTE_NORMAL, 64, YPOS_UPPER);
						PlayStringAndWait("Of course... that could work.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
						PlayStringAndWait("Tell him to wait by the entrance and stay out of sight. We'll come at it from the other side.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
					}
					else if(Game->Counter[CR_MISCSIDEQUEST] == 8){
						PlayStringAndWait("Hold on a sec. I found another entrance. May not be the easiest to get a bunch of injured folks out, but we can probably get you three out. It's near that hidden entrance they talked about though, and Selet's men are hanging around.", SCHAR_SORENPANTS, EMOTE_NORMAL, 64, YPOS_UPPER);
						PlayStringAndWait("Of course... that could work.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
						PlayStringAndWait("Wait by the entrance and stay out of sight. We'll come at it from the other side.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
					}
					else if(Game->Counter[CR_CULTISTQUEST] == 6){
						PlayStringAndWait("Hold on a moment. I found another entrance. May not be the easiest to get a bunch of injured folks out, but we can probably get you three out. It's near that hidden entrance they talked about though, and Selet's men are hanging around.", SCHAR_MICAH2, EMOTE_NORMAL, 64, YPOS_UPPER);
						PlayStringAndWait("Of course... that could work.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
						PlayStringAndWait("Wait by the entrance and stay out of sight. We'll come at it from the other side.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
					}
					else if(Game->Counter[CR_TORRINSIDEQUEST] == 6){
						PlayStringAndWait("Hold on a sec. That leader guy said there was another entrance, didn't he? May not be the easiest to get a bunch of injured folks out if Selet's goons are hangin' around, but we can probably get you three out.", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_UPPER);
						PlayStringAndWait("Of course... that could work.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
					}
					else{
						PlayStringAndWait("Hold on. That red mask guy said there was another entrance before he disappeared. I bet we could use that to get out in a hurry.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
						PlayStringAndWait("Of course... that could work.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
					}
					PlayStringAndWait("How d'ya suppose we get up there?", SCHAR_TORRIN, EMOTE_QUESTION, 64, YPOS_UPPER);
					PlayStringAndWait("I think I figured that one out, actually.", SCHAR_SIYED, EMOTE_NORMAL, 64, YPOS_UPPER);
					SetFFCDir(Siyed, DIR_UP, true);
					while(Siyed->Y > 32){
						Siyed->Y--;
						WaitNoAction();
					}
					SetFFCDir(Siyed, DIR_UP, false);
					WaitNoAction(20);
					Siyed->Data = 33870;
					WaitNoAction(40);
					Game->PlaySound(9);
					Game->PlaySound(68);
					Screen->TriggerSecrets();
					Screen->State[ST_SECRET] = true;
					WaitNoAction(10);
					SetFFCDir(Siyed, DIR_UP, false);
					WaitNoAction(20);
					SetFFCDir(Siyed, DIR_DOWN, true);
					while(Siyed->Y < 80){
						Siyed->Y++;
						WaitNoAction();
					}
					SetFFCDir(Siyed, DIR_DOWN, false);
					PlayStringAndWait("Looks like we owe you. Thanks.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
					PlayStringAndWait("It was nothing. But... all of you. Be careful, please.", SCHAR_SIYED, EMOTE_NORMAL, 64, YPOS_UPPER);
					PlayStringAndWait("Don't worry about us, Siyed. We'll be fine.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
					Link->Invisible = false;
					ClearFFC(Asher);
					ClearFFC(Torrin);
					ClearFFC(Kaylani);
					ClearFFC(Siyed);
					Link->X = 120;
					Link->Y = 128;
					Game->Counter[CR_MISTFLAGS] |= BF_7;
					ffc NPC = FindFreeFFC();
					NPC->Script = 38;
					NPC->Data = 33764;
					NPC->X = 96;
					NPC->Y = 112;
					NPC->TileHeight = 2;
					NPC->InitD[0] = 85;
					SetCutsceneSkip(CUTSCENE_NULL); //CUTSCENE_POHOEND
					for(i = 0; i<60; i++){
						BlackScreenLayerSix();
						WaitNoAction();
					}
				}
			}
		}
		if(scene == 18){
			if(Distance(Link->X, Link->Y, this->X, this->Y)<16&&Game->Counter[CR_STORYFLAG]<SFLAG_MISTCLEAR){
				SetCutsceneSkip(CUTSCENE_ESANENTRY);
				Cutscene_Init(RT_BITMAP1, RT_BITMAP2);
				Cutscene_AnchorCamera(0x52, 0x52, 1, 2);
				
				int asher[1];
				asher[0] = Cutscene_NewNPC(2, -32, -32, 51000, 6, 128);
				Cutscene_SetFlag(asher[0], CGF_4WAY|CGF_BIGNPC|CGF_BS);
				int torrin[1];
				torrin[0] = Cutscene_NewNPC(2, -32, -32, 50952, 6, 128);
				Cutscene_SetFlag(torrin[0], CGF_4WAY|CGF_BIGNPC|CGF_BS);
				int kaylani[1];
				kaylani[0] = Cutscene_NewNPC(2, -32, -32, 50960, 6, 128);
				Cutscene_SetFlag(kaylani[0], CGF_4WAY|CGF_BIGNPC|CGF_BS);
				
				Cutscene_SetDir(asher[0], DIR_DOWN);
				Cutscene_SetDir(torrin[0], DIR_DOWN);
				Cutscene_SetDir(kaylani[0], DIR_DOWN);
				
				if(GetCharID()==CHAR_ASHER){
					Cutscene_SetDrawPosition(asher[0], 120, 72);
					Cutscene_Glide(asher[0], -1, 120, 128, 1);
				}
				else if(GetCharID()==CHAR_TORRIN){
					Cutscene_SetDrawPosition(torrin[0], 120, 72);
					Cutscene_Glide(torrin[0], -1, 120, 128, 1);
				}
				else if(GetCharID()==CHAR_KAYLANI){
					Cutscene_SetDrawPosition(kaylani[0], 120, 72);
					Cutscene_Glide(kaylani[0], -1, 120, 128, 1);
				}
				Cutscene_Waitglide();
				Cutscene_SetDrawPosition(asher[0], 120, 128);
				Cutscene_SetDrawPosition(torrin[0], 120, 128);
				Cutscene_SetDrawPosition(kaylani[0], 120, 128);
				Cutscene_SetDir(asher[0], DIR_LEFT);
				Cutscene_SetDir(torrin[0], DIR_RIGHT);
				Cutscene_GlideRelative(asher[0], -1, -16, 0, 1);
				Cutscene_GlideRelative(torrin[0], -1, 16, 0, 1);
				Cutscene_Waitglide();
				Cutscene_SetDir(asher[0], DIR_DOWN);
				Cutscene_SetDir(torrin[0], DIR_DOWN);
				
				Cutscene_Waitframe(32);
				
				Cutscene_SetDir(asher[0], DIR_LEFT);
				
				Cutscene_Waitframe(32);
				
				Cutscene_Glide(asher[0], -1, 48, 96, 1);
				Cutscene_Waitglide();
				Cutscene_SetDir(asher[0], DIR_UP);
				
				Cutscene_PlayString("That must be the secret entrance Selet's goon talked about.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
				
				Cutscene_Glide(asher[0], -1, 32, 96, 1);
				Cutscene_SetDir(kaylani[0], DIR_LEFT);
				Cutscene_GlideRelative(kaylani[0], -1, -16, 0, 1);
				Cutscene_Waitglide();
				Cutscene_Glide(kaylani[0], -1, 48, 96, 1);
				Cutscene_SetDir(torrin[0], DIR_LEFT);
				Cutscene_GlideRelative(torrin[0], -1, -40, 0, 1);
				Cutscene_Waitglide();
				Cutscene_SetDir(kaylani[0], DIR_UP);
				
				Cutscene_PlayString("How could they have known this was here? The astronomers built this temple. How would they not know about something like this?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
				
				Cutscene_Waitframe(32);
				
				Cutscene_PlayString("There are a great many things to which the Astronomers are ignorant.", SCHAR_BANE, EMOTE_NORMAL, 64, YPOS_LOWER);
				
				int bane[1];
				bane[0] = Cutscene_NewNPC(2, 40, 40, 33856, 11, 128);
				Cutscene_SetFlag(bane[0], CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(bane[0], DIR_DOWN);
				
				Cutscene_SetDir(torrin[0], DIR_UP);
				Cutscene_GlideRelative(asher[0], -1, 16, 16, 1);
				Cutscene_GlideRelative(kaylani[0], -1, 16, 16, 1);
				Cutscene_Waitglide();
				Cutscene_GlideRelative(asher[0], -1, 16, 0, 1);
				Cutscene_GlideRelative(kaylani[0], -1, 16, 0, 1);
				Cutscene_Waitglide();
				Cutscene_GlideRelative(asher[0], -1, 0, 16, 1);
				Cutscene_GlideRelative(kaylani[0], -1, 0, 16, 1);
				Cutscene_Waitglide();
				
				Cutscene_Waitframe(32);
				
				Cutscene_GlideRelative(bane[0], -1, 0, 48, 0.5);
				Cutscene_GlideRelative(asher[0], -1, 0, 16, 0.5);
				Cutscene_GlideRelative(kaylani[0], -1, 0, 16, 0.5);
				Cutscene_GlideRelative(torrin[0], -1, 0, 16, 0.5);
				
				Cutscene_PlayString("The Astronomers have prided themselves on their knowledge, thinking themselves superior to all others. They have ego with no drive to back it.", SCHAR_BANE, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_Waitglide();
				
				Cutscene_Glide(bane[0], -1, 80, 120, 0.5);
				Cutscene_GlideRelative(asher[0], -1, 0, 32, 0.5);
				Cutscene_GlideRelative(kaylani[0], -1, 0, 32, 0.5);
				Cutscene_GlideRelative(torrin[0], -1, 0, 32, 0.5);
				Cutscene_SetCameraTracking(bane[0], 1, 8);
				Cutscene_Waitglide();
				
				Cutscene_PlayString("You! How do you and Selet know all of this?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("Lord Igorevich has his means. He has spent years researching, learning, finding sources even the Astronomers are not privy to.", SCHAR_BANE, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("And who are you? You sure seem to know a lot about what the Astronomers do and don't know.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_Waitframe(32);
				Cutscene_SetNPCGraphic(bane[0], 33871, true);
				Cutscene_Waitframe(16);
				Cutscene_SetNPCGraphic(bane[0], 33872, true);
				Cutscene_Waitframe(48);
				Cutscene_SetNPCGraphic(bane[0], 33873, true);
				Cutscene_Waitframe(16);
				Cutscene_SetNPCGraphic(bane[0], 33874, true);
				Cutscene_Waitframe(48);
				Cutscene_SetNPCGraphic(bane[0], 51620, false);
				Cutscene_SetDir(bane[0], DIR_DOWN);
				Cutscene_PlayString("You may call me Esan. There was a time, long ago, when I aspired to join the Astronomers. But, in time, I saw through the pretenses. Through the false illusions of control they hold on to. I found new ways to study. New methods to channel magical energy. And in Lord Igorevich, I found a new way to live, say nothing of a source of funding for my research.", SCHAR_ESAN, EMOTE_NORMAL, 64, YPOS_UPPER);
				
				Cutscene_GlideRelative(bane[0], -1, 0, 16, 0.5);
				Cutscene_GlideRelative(asher[0], -1, 0, 16, 0.5);
				Cutscene_GlideRelative(kaylani[0], -1, 0, 16, 0.5);
				Cutscene_GlideRelative(torrin[0], -1, 0, 16, 0.5);
				Cutscene_Waitglide();
				
				Cutscene_SetNPCGraphic(bane[0], 33876, true);
				Cutscene_PlayString("Though I am no mage, I found my own ways to cast magic. And in recognition of that talent, Lord Igorevich trusted me with an extracted sample of his own power. Shall I demonstrate what this fusion of abilities is capable of?", SCHAR_ESAN, EMOTE_NORMAL, 64, YPOS_UPPER);
				
				Cutscene_SetNPCGraphic(bane[0], 33877, true);
				
				int x = CutX(bane[0]);
				int y = CutY(bane[0])+8;
				int ang;
				i = 0;
				while(Distance(x, y, CutX(kaylani[0]), CutY(kaylani[0]))>4){
					++i;
					if(i%2==0)
						Cutscene_NewAnim(2, x+Rand(-3, 3), y+Rand(-3, 3), Choose(54600, 54620), 1, 1, 8, -1, -1, 0, 0, 0, 0, true, 128, 4, 2);
					ang = Angle(x, y, CutX(kaylani[0]), CutY(kaylani[0]));
					x += VectorX(4, ang);
					y += VectorY(4, ang);
					Cutscene_Waitframe();
				}
				int expandTime = 16;
				int expandDist = 24;
				int activateDelay = 32;
				int shrinkTime = 32;
				int bmcX[64];
				int bmcY[64];
				int bmcF[64];
				int bmcT[64];
				int count = Floor((2*PI*expandDist)/8);
				int bmc[] = {0, count, Rand(360), bmcX, bmcY, bmcF, bmcT};
				for(i=0; i<expandTime; ++i){
					Cutscene_DrawBloodMoonCage(0, 4, CutX(kaylani[0]), CutY(kaylani[0]), Lerp(0, expandDist, i/expandTime), bmc);
					Cutscene_Waitframe();
				}
				for(i=0; i<activateDelay; ++i){
					Cutscene_DrawBloodMoonCage(0, 4, CutX(kaylani[0]), CutY(kaylani[0]), expandDist, bmc);
					Cutscene_Waitframe();
				}
				Game->PlaySound(SFX_BLOODMOONCAGE_ACTIVATE);
				Cutscene_GlideTimed(kaylani[0], 0x62, 120, 120, shrinkTime);
				Cutscene_GlideTimed(torrin[0], 0x62, 120, 120, shrinkTime);
				Cutscene_GlideTimed(asher[0], 0x62, 120, 120, shrinkTime);
				Cutscene_SetCameraTarget(0x62, 3);
				int numfall;
				for(int i=0; i<shrinkTime; ++i){
					int tempRad = Lerp(expandDist, 0, i/shrinkTime);
					Cutscene_DrawBloodMoonCage(1, 4, CutX(kaylani[0]), CutY(kaylani[0]), Lerp(expandDist, 0, i/shrinkTime), bmc);
					Cutscene_Waitframe();
				}
				Cutscene_SetAttr(asher[0], CGI_MOVESTEP, 0);
				Cutscene_SetAttr(torrin[0], CGI_MOVESTEP, 0);
				Cutscene_SetAttr(kaylani[0], CGI_MOVESTEP, 0);
				if(GetCharID()==CHAR_ASHER){
					Cutscene_SetDrawPosition(torrin[0], -32, -32);
					Cutscene_SetDrawPosition(kaylani[0], -32, -32);
				}
				else if(GetCharID()==CHAR_TORRIN){
					Cutscene_SetDrawPosition(asher[0], -32, -32);
					Cutscene_SetDrawPosition(kaylani[0], -32, -32);
				}
				else if(GetCharID()==CHAR_KAYLANI){
					Cutscene_SetDrawPosition(asher[0], -32, -32);
					Cutscene_SetDrawPosition(torrin[0], -32, -32);
				}
				for(int i=0; i<8; ++i){
					Cutscene_DrawBloodMoonCage(2, 4, CutX(kaylani[0]), CutY(kaylani[0]), 0, bmc);
					Cutscene_Waitframe();
				}
				Cutscene_SetNPCGraphic(bane[0], -1, true);
				Cutscene_Glide(bane[0], 0x62, 120, 40, 1);
				Cutscene_Waitglide();
				
				int gates[8];
				for(i=0; i<8; ++i){
					gates[i] = Cutscene_NewTile(2, 64+16*i, 176, 70200, 1, 2, 4, -1, -1, 0, 0, 0, 0, true, 128);
					Cutscene_MakeImmortal(gates[i]);
				}
				Game->PlaySound(134);
				for(j=0; j<5; ++j){
					for(i=0; i<8; ++i){
						Cutscene_SetDrawGraphic(gates[i], 70200+1+j, 4);
					}
					Cutscene_Waitframe(4);
				}
				
				SetCutsceneSkip(CUTSCENE_NULL); //CUTSCENE_ESANENTRY
				Link->Dir = DIR_UP;
				Link->Warp(67, 0x62);
				Cutscene_Waitframe();
			}
			else if(Distance(Link->X, Link->Y, 40, 96)<16&&Game->Counter[CR_STORYFLAG]<SFLAG_MISTCLEAR){
				SetCutsceneSkip(CUTSCENE_POSTESAN);
				Cutscene_Init(RT_BITMAP1, RT_BITMAP2);
				Cutscene_AnchorCamera(0x52, 0x62, 1, 2);
				
				Game->PlayEnhancedMusic("SS-Mist.ogg", 0);
				int asher[1];
				asher[0] = Cutscene_NewNPC(2, 120, 176+48, 51000, 6, 128);
				Cutscene_SetFlag(asher[0], CGF_4WAY|CGF_BIGNPC|CGF_BS);
				int torrin[1];
				torrin[0] = Cutscene_NewNPC(2, 136, 176+32, 50952, 6, 128);
				Cutscene_SetFlag(torrin[0], CGF_4WAY|CGF_BIGNPC|CGF_BS);
				int kaylani[1];
				kaylani[0] = Cutscene_NewNPC(2, 104, 176+32, 50960, 6, 128);
				Cutscene_SetFlag(kaylani[0], CGF_4WAY|CGF_BIGNPC|CGF_BS);
				
				int esan[1];
				esan[0] = Cutscene_NewTile(2, 56, 176+96, 111518, 2, 2, 11, -1, -1, 0, 0, 0, 0, true, 128);
				Cutscene_MakeImmortal(esan[0]);
				
				Cutscene_SetDir(asher[0], DIR_UP);
				Cutscene_SetDir(torrin[0], DIR_LEFT);
				Cutscene_SetDir(kaylani[0], DIR_RIGHT);
				
				
				int gates[8];
				for(i=0; i<8; ++i){
					gates[i] = Cutscene_NewTile(2, 64+16*i, 176, 70205, 1, 2, 4, -1, -1, 0, 0, 0, 0, true, 128);
					Cutscene_MakeImmortal(gates[i]);
				}
				Cutscene_Waitframe(32);
				Game->PlaySound(134);
				for(j=0; j<5; ++j){
					for(i=0; i<8; ++i){
						Cutscene_SetDrawGraphic(gates[i], 70205-1-j, 4);
					}
					Cutscene_Waitframe(4);
				}
				
				Cutscene_PlayString("What now?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_PlayString("We need to get back to Hoku Village and let Grandmother know. If Selet knows where the Cosmic Egg truly is, this could be bad.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				if(Game->Counter[CR_TORRINSIDEQUEST] >= 6 || Game->Counter[CR_MISCSIDEQUEST] >= 8 || Game->Counter[CR_CULTISTQUEST] >= 6){
					Cutscene_SetDir(asher[0], DIR_DOWN);
					Cutscene_SetDir(torrin[0], DIR_DOWN);
					Cutscene_SetDir(kaylani[0], DIR_DOWN);
					int x; int y; int tX; int tY; int dir; int cmb; int jump; int z; int t; int dist;
					if(Game->Counter[CR_TORRINSIDEQUEST] >= 6){
						x = 256;
						y = 176+88+Rand(-16, 16);
						tX = 192;
						tY = 176+64;
						dir = DIR_LEFT;
						cmb = 33556;
						jump = 2.4;
						z = 0;
						t = FindJumpLength(jump, false);
						dist = Distance(x, y, tX, tY);
						Game->PlaySound(SFX_JUMP);
						for(i=0; i<t; ++i){
							jump = Clamp(jump-0.16, -3.2, 3.2);
							z += jump;
							int ang = Angle(x, y, tX, tY);
							x += VectorX(dist/t, ang);
							y += VectorY(dist/t, ang);
							Cutscene_NewFastCombo(2, x, y, 107, 7, 64);
							Cutscene_NewCombo(4, x, y-z-16, cmb+4+dir, 1, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 128);
							Cutscene_Waitframe(1);
						}
						int terry = Cutscene_NewNPC(2, x, y, 33556, 6, OP_OPAQUE);
						Cutscene_SetFlag(terry, CGF_4WAY|CGF_BIGNPC);
						Cutscene_SetDir(terry, DIR_LEFT);
					}
					if(Game->Counter[CR_MISCSIDEQUEST] >= 8){
						x = -16;
						y = 176+88+Rand(-16, 16);
						tX = 48;
						tY = 176+64;
						dir = DIR_RIGHT;
						cmb = 33832;
						jump = 2.4;
						z = 0;
						t = FindJumpLength(jump, false);
						dist = Distance(x, y, tX, tY);
						Game->PlaySound(SFX_JUMP);
						for(i=0; i<t; ++i){
							jump = Clamp(jump-0.16, -3.2, 3.2);
							z += jump;
							int ang = Angle(x, y, tX, tY);
							x += VectorX(dist/t, ang);
							y += VectorY(dist/t, ang);
							Cutscene_NewFastCombo(2, x, y, 107, 7, 64);
							Cutscene_NewCombo(4, x, y-z-16, cmb+4+dir, 1, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 128);
							Cutscene_Waitframe(1);
						}
						int soren = Cutscene_NewNPC(2, x, y, 33832, 6, OP_OPAQUE);
						Cutscene_SetFlag(soren, CGF_4WAY|CGF_BIGNPC);
						Cutscene_SetDir(soren, DIR_RIGHT);
					}
					if(Game->Counter[CR_CULTISTQUEST] >= 6){
						x = 256;
						y = 176+88+Rand(-16, 16);
						tX = 176;
						tY = 176+96;
						dir = DIR_LEFT;
						cmb = 33896;
						jump = 2.4;
						z = 0;
						t = FindJumpLength(jump, false);
						dist = Distance(x, y, tX, tY);
						Game->PlaySound(SFX_JUMP);
						for(i=0; i<t; ++i){
							jump = Clamp(jump-0.16, -3.2, 3.2);
							z += jump;
							int ang = Angle(x, y, tX, tY);
							x += VectorX(dist/t, ang);
							y += VectorY(dist/t, ang);
							Cutscene_NewFastCombo(2, x, y, 107, 7, 64);
							Cutscene_NewCombo(4, x, y-z-16, cmb+4+dir, 1, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 128);
							Cutscene_Waitframe(1);
						}
						int micah = Cutscene_NewNPC(2, x, y, 33896, 6, OP_OPAQUE);
						Cutscene_SetFlag(micah, CGF_4WAY|CGF_BIGNPC);
						Cutscene_SetDir(micah, DIR_UP);
					}
					if(Game->Counter[CR_CULTISTQUEST] == 6 && Game->Counter[CR_MISCSIDEQUEST] == 8 && Game->Counter[CR_TORRINSIDEQUEST] == 6){
						Cutscene_PlayString("We'll stay behind and cover your retreat, then make sure everyone's okay and help Siyed get them out safely. You three need to hurry and stop Selet!", SCHAR_MICAH2, EMOTE_NORMAL, 64, YPOS_LOWER);
						Cutscene_PlayString("Will you be able to handle the rest of Selet's men?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
						Cutscene_PlayString("Are you kiddin'? We've been handlin' 'em just fine so far.", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_LOWER);
						Cutscene_PlayString("We'll be fine. And Asher, when you run into the rich bastard behind all this, punch him right in the throat for me, will ya?", SCHAR_SORENPANTS, EMOTE_NORMAL, 64, YPOS_LOWER);
						Cutscene_PlayString("You got it.", SCHAR_ASHER, EMOTE_WINK, 64, YPOS_LOWER);
					}
					else if(Game->Counter[CR_MISCSIDEQUEST] == 8 && Game->Counter[CR_TORRINSIDEQUEST] == 6){
						Cutscene_PlayString("We'll stay behind and make sure Siyed's takin' care of all the wounded. You three need to move!", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_LOWER);
						Cutscene_PlayString("Sure you're alright handlin' the rest of Selet's goons?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
						Cutscene_PlayString("Are you kiddin'? We've been handlin' 'em just fine so far.", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_LOWER);
						Cutscene_PlayString("We'll be fine. And Asher, when you run into the rich bastard behind all this, punch him right in the throat for me, will ya?", SCHAR_SORENPANTS, EMOTE_NORMAL, 64, YPOS_LOWER);
						Cutscene_PlayString("You got it.", SCHAR_ASHER, EMOTE_WINK, 64, YPOS_LOWER);
					}
					else if(Game->Counter[CR_CULTISTQUEST] == 6 && Game->Counter[CR_TORRINSIDEQUEST] == 6){
						Cutscene_PlayString("We'll stay behind and cover your retreat, then make sure everyone's okay and help Siyed get them out safely. You three need to hurry and stop Selet!", SCHAR_MICAH2, EMOTE_NORMAL, 64, YPOS_LOWER);
						Cutscene_PlayString("Sure you're okay handling the rest of Selet's men?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
						Cutscene_PlayString("Are you kiddin'? We've been handlin' 'em just fine so far. Hurry up. And Torrin, give Selet hell for me, will ya?", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_LOWER);
						Cutscene_PlayString("You got it.", SCHAR_TORRIN, EMOTE_WINK, 64, YPOS_LOWER);
					}
					else if(Game->Counter[CR_CULTISTQUEST] == 6 && Game->Counter[CR_MISCSIDEQUEST] == 8){
						Cutscene_PlayString("We'll stay behind and cover your retreat, then make sure everyone's okay and help Siyed get them out safely. You three need to hurry and stop Selet!", SCHAR_MICAH2, EMOTE_NORMAL, 64, YPOS_LOWER);
						Cutscene_PlayString("Will you be able to handle the rest of Selet's men?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
						Cutscene_PlayString("Don't sweat it. Micah and I've got this. But Asher, when you run into the rich bastard behind all this, punch him right in the throat for me, will ya?", SCHAR_SORENPANTS, EMOTE_NORMAL, 64, YPOS_LOWER);
						Cutscene_PlayString("You got it.", SCHAR_ASHER, EMOTE_WINK, 64, YPOS_LOWER);
					}
					else if(Game->Counter[CR_MISCSIDEQUEST] == 8){
						Cutscene_PlayString("I'll stay behind and cover your exit, then see about helping Siyed get all the injured folks outta here. You three need to get outta here while you can!", SCHAR_SORENPANTS, EMOTE_NORMAL, 64, YPOS_LOWER);
						Cutscene_PlayString("Sure you're okay handling the rest of Selet's men?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
						Cutscene_PlayString("Don't sweat it. I've got things under control. But Asher, when you run into the rich bastard behind all this, punch him right in the throat for me, will ya?", SCHAR_SORENPANTS, EMOTE_NORMAL, 64, YPOS_LOWER);
						Cutscene_PlayString("You got it.", SCHAR_ASHER, EMOTE_WINK, 64, YPOS_LOWER);
					}
					else if(Game->Counter[CR_CULTISTQUEST] == 6){
						Cutscene_PlayString("I'll stay behind and cover your retreat, then make sure everyone's okay and help Siyed get them out safely. You three need to hurry and stop Selet!", SCHAR_MICAH2, EMOTE_NORMAL, 64, YPOS_LOWER);
						Cutscene_PlayString("Will you be able to handle the rest of Selet's men?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
						Cutscene_PlayString("I can handle myself. Go, hurry! And give Selet my kindest regards.", SCHAR_MICAH2, EMOTE_NORMAL, 64, YPOS_LOWER);
						Cutscene_PlayString("It would be my pleasure.", SCHAR_KAYLANI, EMOTE_WINK, 64, YPOS_LOWER);
					}
					else if(Game->Counter[CR_TORRINSIDEQUEST] == 6){
						Cutscene_PlayString("I'll stay behind and make sure Siyed's takin' care of all the wounded. You three need to move!", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_LOWER);
						Cutscene_PlayString("Sure you're alright handlin' the rest of Selet's goons?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
						Cutscene_PlayString("Are you kiddin'? We've been handlin' 'em just fine so far. Hurry up. And Torrin, give Selet hell for me, will ya?", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_LOWER);
						Cutscene_PlayString("You got it.", SCHAR_TORRIN, EMOTE_WINK, 64, YPOS_LOWER);
					}
				}
				
				Cutscene_SetCameraTarget(0x52, 1);
				Cutscene_Waitcamera();
				
				Cutscene_SetDir(kaylani[0], DIR_UP);
				Cutscene_SetDir(asher[0], DIR_UP);
				Cutscene_SetDir(torrin[0], DIR_UP);
				
				int glideState[3];
				Cutscene_Glide(kaylani[0], -1, 64, 112, 1);
				Cutscene_Waitframe(16);
				Cutscene_Glide(torrin[0], -1, 64, 112, 1);
				Cutscene_Waitframe(16);
				Cutscene_Glide(asher[0], -1, 64, 112, 1);
				while(glideState[0]<3||glideState[1]<3||glideState[2]<3){
					if(Cutscene_JustFinishedGlide(kaylani[0])){
						if(glideState[0]==0){
							Cutscene_Glide(kaylani[0], -1, 40, 88, 1);
						}
						else if(glideState[0]==1){
							Cutscene_Glide(kaylani[0], -1, 40, 32, 1);
						}
						else if(glideState[0]==2){
							Cutscene_SetDrawPosition(kaylani[0], -32, -32);
						}
						++glideState[0];
					}
					if(Cutscene_JustFinishedGlide(torrin[0])){
						if(glideState[1]==0){
							Cutscene_Glide(torrin[0], -1, 40, 88, 1);
						}
						else if(glideState[1]==1){
							Cutscene_Glide(torrin[0], -1, 40, 32, 1);
						}
						else if(glideState[1]==2){
							Cutscene_SetDrawPosition(torrin[0], -32, -32);
						}
						++glideState[1];
					}
					if(Cutscene_JustFinishedGlide(asher[0])){
						if(glideState[2]==0){
							Cutscene_Glide(asher[0], -1, 40, 88, 1);
						}
						else if(glideState[2]==1){
							Cutscene_Glide(asher[0], -1, 40, 32, 1);
						}
						else if(glideState[2]==2){
							Cutscene_SetDrawPosition(asher[0], -32, -32);
						}
						++glideState[2];
					}
					Cutscene_Waitframe();
				}
				SetCutsceneSkip(CUTSCENE_NULL); //CUTSCENE_POSTESAN
				Link->WarpEx({WT_IWARPBLACKOUT, 68, 0x00, -1, 0, 0, 0, 0});
				Cutscene_Waitframe();
			}
		}
		if(scene == 19){ //Opening the observatory
			mapdata l1 = Game->LoadTempScreen(1);
			mapdata l3 = Game->LoadTempScreen(3);
			if(G[G_RANDOMIZERENABLED]){
				Screen->ComboD[84] = 781;
				Screen->ComboC[84] = 4;
				l1->ComboD[84] = 781;
				l1->ComboC[84] = 4;
				l3->ComboD[68] = 789;
				l3->ComboC[68] = 4;
				l3->ComboD[84] = 793;
				l3->ComboC[84] = 4;
				Game->SetScreenState(16, 0x69, ST_SECRET, true);
				if(!Screen->State[ST_SECRET]){
					if(G[G_RANDOMIZEROBSERVATORYLOCK]==0||G[G_RANDOMIZERMODE]==1){
						Screen->TriggerSecrets();
						Screen->State[ST_SECRET] = true;
					}
					else{
						Waitframe();
						while(true){
							if(Link->Dir==DIR_UP&&Abs(Link->X-this->X)<=8&&Link->Y<=this->Y+10&&Link->Y>this->Y){
								int req[2];
								S19_DrawReq(req);
								if(Link->PressA){
									if(req[0]>=req[1]){
										Game->PlayMIDI(0);
										if(G[G_RANDOMIZEROBSERVATORYLOCK]==1){
											int charTil[6];
											int numChar;
											int charAng;
											
											if(G[G_ASHERINSEED]){
												charTil[numChar] = 104240;
												++numChar;
											}
											if(G[G_TORRININSEED]){
												charTil[numChar] = 104241;
												++numChar;
											}
											if(G[G_KAYLANIINSEED]){
												charTil[numChar] = 104242;
												++numChar;
											}
											if(G[G_SORENINSEED]){
												charTil[numChar] = 104243;
												++numChar;
											}
											if(G[G_TERRYINSEED]){
												charTil[numChar] = 104244;
												++numChar;
											}
											if(G[G_SIYEDINSEED]){
												charTil[numChar] = 104245;
												++numChar;
											}
											
											charAng = 360/numChar;
											int x; int y;
											int angle = -90;
											for(int i=0; i<numChar; ++i){
												Game->PlaySound(80);
												for(int j=0; j<40; ++j){
													for(int k=0; k<=i; ++k){
														x = this->X+VectorX(24, angle+k*charAng);
														y = this->Y+VectorY(24, angle+k*charAng);
														if(k<i||j%4<2)
															Screen->FastTile(6, x, y, charTil[k], 6, 64);
													}
													WaitNoAction();
												}
											}
											for(int j=0; j<120; ++j){
												angle = WrapDegrees(angle+9);
												for(int k=0; k<numChar; ++k){
													x = this->X+VectorX(Lerp(24, 0, j/120), angle+k*charAng);
													y = this->Y+VectorY(Lerp(24, 0, j/120), angle+k*charAng);
													if(j<90||j%4<2)
														Screen->FastTile(6, x, y, charTil[k], 6, 64);
												}
												WaitNoAction();
											}
										}
										else{
											for(int i=0; i<G[G_RANDOMIZERREQUIREDHYMNSTONES]; ++i){
												Game->PlaySound(62);
												int t = Round(Lerp(12, 3, i/(G[G_RANDOMIZERREQUIREDHYMNSTONES]-1)));
												for(int j=0; j<t; ++j){
													Screen->FastTile(2, this->X, this->Y-32+Lerp(0, 32, j/(t-1)), 65900, 7, j<t*0.6666?128:64);
													WaitNoAction();
												}
											}
										}
										WaitNoAction(16);
										Game->PlaySound(86);
										WaitNoAction(32);
										l1->ComboD[71] = 11247;
										for(int i=0; i<3; ++i){
											Game->PlaySound(84);
											l1->ComboD[45] = 11297+i;
											l1->ComboD[46] = 11305+i;
											l1->ComboD[61] = 11301+i;
											l1->ComboD[62] = 11309+i;
											WaitNoAction(48);
										}
										Game->PlaySound(84);
										l1->ComboD[45] = 0;
										l1->ComboD[46] = 0;
										l1->ComboD[61] = 0;
										l1->ComboD[62] = 0;
										Screen->TriggerSecrets();
										Screen->State[ST_SECRET] = true;
										Quit();
									}
									else
										Game->PlaySound(SFX_ERROR);
								}
							}
							Waitframe();
						}
					}
				}
			}
			else{
				if(!Screen->State[ST_SECRET]){
					SetCutsceneSkip(CUTSCENE_OBSERVATORYENTRANCE);
					Waitframe();
					while(!WalkLinkToPoint(48, 144)){
						Waitframe();
					}
					while(!WalkLinkToPoint(96, 144)){
						Waitframe();
					}
					while(!WalkLinkToPoint(96, 96)){
						Waitframe();
					}
					while(!WalkLinkToPoint(112, 96)){
						Waitframe();
					}
					while(!WalkLinkToPoint(112, 88)){
						Waitframe();
					}
					Link->Dir = DIR_UP;
					
					Link->Invisible = true;
					ffc Asher = FFCNPC(CMB_ASHER, Link->X, Link->Y-16);
					Asher->CSet = 6;
					SetFFCDir(Asher, DIR_UP, false);
					ffc Torrin = FFCNPC(CMB_TORRIN, Link->X, Link->Y-16);
					SetFFCDir(Torrin, DIR_RIGHT, true);
					ffc Kaylani = FFCNPC(CMB_KAYLANI, Link->X, Link->Y-16);
					SetFFCDir(Kaylani, DIR_LEFT, true);
					for(i=0; i<16; ++i){
						++Torrin->X;
						--Kaylani->X;
						WaitNoAction();
					}
					SetFFCDir(Torrin, DIR_UP, false);
					SetFFCDir(Kaylani, DIR_UP, false);
					PlayStringAndWait("This must be the seal on the Observatory. I saw similar looking statues back at the Poho Temple as well.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("If it's still locked, does that mean we beat Selet here?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("Perhaps. More likely though, it means he locked it behind him to keep out the astronomers.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("It's a good thing we've got all three kinds of magic with us, then. Let's just hope Selet hasn't already come and gone.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
					SetFFCDir(Torrin, DIR_UP, true);
					SetFFCDir(Kaylani, DIR_UP, true);
					for(i=0; i<24; ++i){
						--Torrin->Y;
						--Kaylani->Y;
						WaitNoAction();
					}
					SetFFCDir(Torrin, DIR_LEFT, false);
					SetFFCDir(Kaylani, DIR_RIGHT, false);
					WaitNoAction(16);
					PlayStringAndWait("A quick kick of solar magic...", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
					Kaylani->Data = 51143;
					Game->PlaySound(86);
					l1->ComboD[71] = 11261;
					WaitNoAction(24);
					SetFFCDir(Kaylani, DIR_RIGHT, false);
					WaitNoAction(16);
					PlayStringAndWait("Lunar magic in a jar, courtesy of Selet 'himself...", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
					Torrin->Data = 51144;
					Game->PlaySound(86);
					l1->ComboD[71] = 11262;
					WaitNoAction(24);
					SetFFCDir(Torrin, DIR_LEFT, false);
					WaitNoAction(16);
					PlayStringAndWait("And magic that isn't even supposed to exist...", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
					Asher->Data = 51104;
					Game->PlaySound(86);
					l1->ComboD[71] = 11263;
					WaitNoAction(24);
					SetFFCDir(Asher, DIR_UP, false);
					WaitNoAction(16);
					l1->ComboD[71] = 11247;
					for(int i=0; i<3; ++i){
						Game->PlaySound(84);
						l1->ComboD[45] = 11297+i;
						l1->ComboD[46] = 11305+i;
						l1->ComboD[61] = 11301+i;
						l1->ComboD[62] = 11309+i;
						WaitNoAction(48);
					}
					Game->PlaySound(84);
					l1->ComboD[45] = 0;
					l1->ComboD[46] = 0;
					l1->ComboD[61] = 0;
					l1->ComboD[62] = 0;
					WaitNoAction(48);
					PlayStringAndWait("An' there we go. Let's get inside, get that Egg, and kick Selet's sorry ass across the ocean 'fore he knows what hit him.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
					SetFFCDir(Torrin, DIR_DOWN, true);
					SetFFCDir(Kaylani, DIR_DOWN, true);
					for(i=0; i<24; ++i){
						++Torrin->Y;
						++Kaylani->Y;
						WaitNoAction();
					}
					SetFFCDir(Torrin, DIR_LEFT, true);
					SetFFCDir(Kaylani, DIR_RIGHT, true);
					for(i=0; i<16; ++i){
						--Torrin->X;
						++Kaylani->X;
						WaitNoAction();
					}
					Link->Invisible = false;
					ClearFFC(Asher);
					ClearFFC(Torrin);
					ClearFFC(Kaylani);
					Screen->TriggerSecrets();
					Screen->State[ST_SECRET] = true;
					SetCutsceneSkip(CUTSCENE_NULL); //CUTSCENE_OBSERVATORYENTRANCE
				}
			}
		}
		if(scene == 20){
			DayNight[_DN_HOUR] = 10;
			DayNight[_DN_MINUTE] = 0;
			DayNight[_DN_SECOND] = 0;
			G[G_TIMEFROZEN] = 1;
			WaitNoAction(2);
			Game->PlayEnhancedMusic("SS-HokuNight.ogg", 0);
			Game->DMapPalette[Game->GetCurDMap()] = 0x0AB;
			Cutscene_Init(RT_BITMAP1, RT_BITMAP2);
			cutsceneG[CG_BGMAP] = 20;
			Cutscene_AnchorCamera(0x75, 0x75, 1, 1);
			int grandma;
			grandma = Cutscene_NewNPC(2, 120, 64, 33792, 8, 128);
			Cutscene_SetFlag(grandma, CGF_4WAY|CGF_BIGNPC);
			int torrin;
			torrin = Cutscene_NewNPC(2, 120, 176+16, 50952, 6, 128);
			Cutscene_SetFlag(torrin, CGF_4WAY|CGF_BIGNPC|CGF_BS);
			int asher;
			asher = Cutscene_NewNPC(2, 120, 176+16, 51000, 6, 128);
			Cutscene_SetFlag(asher, CGF_4WAY|CGF_BIGNPC|CGF_BS);
			int kaylani;
			kaylani = Cutscene_NewNPC(2, 120, 176+16, 50960, 6, 128);
			Cutscene_SetFlag(kaylani, CGF_4WAY|CGF_BIGNPC|CGF_BS);
			
			//Stupid doors and windows
			int f1 = Cutscene_NewFastCombo(1, 112, 112, 16697, 2, OP_OPAQUE);
			int f2 = Cutscene_NewFastCombo(1, 112, 128, 16697, 2, OP_OPAQUE);
			int f3 = Cutscene_NewFastCombo(1, 128, 112, 16697, 2, OP_OPAQUE);
			int f4 = Cutscene_NewFastCombo(1, 128, 128, 16697, 2, OP_OPAQUE);
			int f5 = Cutscene_NewFastCombo(1, 160, 128, 16697, 2, OP_OPAQUE);
			int f6 = Cutscene_NewFastCombo(1, 176, 128, 16697, 2, OP_OPAQUE);
			int f7 = Cutscene_NewFastCombo(1, 64, 128, 48777, 2, OP_OPAQUE);
			int f8 = Cutscene_NewFastCombo(1, 80, 128, 48777, 2, OP_OPAQUE);
			int w1 = Cutscene_NewFastCombo(1, 64, 144, 16286, 2, OP_OPAQUE);
			int w2 = Cutscene_NewFastCombo(1, 80, 144, 16287, 2, OP_OPAQUE);
			int w3 = Cutscene_NewFastCombo(1, 160, 144, 16286, 2, OP_OPAQUE);
			int w4 = Cutscene_NewFastCombo(1, 176, 144, 16287, 2, OP_OPAQUE);
			int d1 = Cutscene_NewFastCombo(1, 112, 144, 16308, 2, OP_OPAQUE);
			int d2 = Cutscene_NewFastCombo(1, 128, 144, 16309, 2, OP_OPAQUE);
			int d3 = Cutscene_NewFastCombo(4, 112, 160, 16312, 2, OP_OPAQUE);
			int d4 = Cutscene_NewFastCombo(4, 128, 160, 16313, 2, OP_OPAQUE);
			Cutscene_SetAttr(f1, CGI_DRAWLIFESPAN, -1);
			Cutscene_SetAttr(f2, CGI_DRAWLIFESPAN, -1);
			Cutscene_SetAttr(f3, CGI_DRAWLIFESPAN, -1);
			Cutscene_SetAttr(f4, CGI_DRAWLIFESPAN, -1);
			Cutscene_SetAttr(f5, CGI_DRAWLIFESPAN, -1);
			Cutscene_SetAttr(f6, CGI_DRAWLIFESPAN, -1);
			Cutscene_SetAttr(f7, CGI_DRAWLIFESPAN, -1);
			Cutscene_SetAttr(f8, CGI_DRAWLIFESPAN, -1);
			Cutscene_SetAttr(w1, CGI_DRAWLIFESPAN, -1);
			Cutscene_SetAttr(w2, CGI_DRAWLIFESPAN, -1);
			Cutscene_SetAttr(w3, CGI_DRAWLIFESPAN, -1);
			Cutscene_SetAttr(w4, CGI_DRAWLIFESPAN, -1);
			Cutscene_SetAttr(d1, CGI_DRAWLIFESPAN, -1);
			Cutscene_SetAttr(d2, CGI_DRAWLIFESPAN, -1);
			Cutscene_SetAttr(d3, CGI_DRAWLIFESPAN, -1);
			Cutscene_SetAttr(d4, CGI_DRAWLIFESPAN, -1);
			
			Cutscene_SetDir(grandma, DIR_UP);
			Cutscene_SetDir(kaylani, DIR_UP);
			Cutscene_SetDir(asher, DIR_LEFT);
			Cutscene_SetDir(torrin, DIR_RIGHT);
			Cutscene_Glide(kaylani, -1, 120, 104, 1);
			Cutscene_Waitglide(kaylani);
			Cutscene_SetDrawPosition(asher, CutX(kaylani), CutY(kaylani));
			Cutscene_SetDrawPosition(torrin, CutX(kaylani), CutY(kaylani));
			Cutscene_GlideRelative(asher, -1, -16, 0, 1);
			Cutscene_GlideRelative(torrin, -1, 16, 0, 1);
			Cutscene_Waitglide();
			Cutscene_SetDir(asher, DIR_UP);
			Cutscene_SetDir(torrin, DIR_UP);
			Cutscene_SetDir(grandma, DIR_DOWN);
			Cutscene_Waitframe(16);
			Cutscene_Glide(grandma, -1, 120, 64, 1);
			Cutscene_PlayString("Thank the stars you're back safely. Do you have the egg?", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_PlayString("Well...", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			for(i = 0; i<60; i++){
				Cutscene_Update();
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				NoAction();
				BlackishScreenLayerSix();
				Waitframe();
			}
			for(i = 0; i<60; i++){
				Cutscene_Update();
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				NoAction();
				BlackScreenLayerSix();
				Waitframe();
			}
			for(i = 0; i<60; i++){
				Cutscene_Update();
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				NoAction();
				BlackishScreenLayerSix();
				Waitframe();
			}
			Cutscene_PlayString("I see... This is a lot to take in.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_PlayString("I'm sorry that-", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("Sorry? Kaylani, you three did what none of us were able to. You kept Selet from getting his hands on the Egg.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_PlayString("But he got away. And we have no idea what was inside the Egg. I think it showed him something... he had a determination in his voice when we spoke inside there.", SCHAR_KAYLANI, EMOTE_SAD, 64, YPOS_UPPER);
			Cutscene_PlayString("I can't imagine anyone could survive a fall from the Observatory's upper floor like you described. And yet... Regardless, the immediate danger has passed.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_PlayString("So... what now?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("For now, I think it's time all three of you got a much needed rest.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_PlayString("But Selet-", SCHAR_KAYLANI, EMOTE_DISMAYED, 64, YPOS_UPPER);
			Cutscene_PlayString("Whether he's alive or dead, your rushing off right now won't change anything. I'm going to have all available astronomers either searching for him or researching the Egg. And, in due time, I expect the three of you to join in that effort. But for now, the three of you have done more than enough. ", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_PlayString("It has been a bit since I've been home...", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("Might be nice to sleep in my own bed again, relax a bit at home, maybe spend some time with my little bro.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("I suppose. But... how am I supposed to relax when there's so much to be done?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("Think of everything you have done. Think of how much better a place the world is for your efforts. Think of the relative tranquility that would soon be destroyed if not for your actions.", SCHAR_GRANDMA, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_RemoveDraw(grandma);
			Cutscene_RemoveDraw(f1);
			Cutscene_RemoveDraw(f2);
			Cutscene_RemoveDraw(f3);
			Cutscene_RemoveDraw(f4);
			Cutscene_RemoveDraw(f5);
			Cutscene_RemoveDraw(f6);
			Cutscene_RemoveDraw(f7);
			Cutscene_RemoveDraw(f8);
			Cutscene_RemoveDraw(w1);
			Cutscene_RemoveDraw(w2);
			Cutscene_RemoveDraw(w3);
			Cutscene_RemoveDraw(w4);
			Cutscene_RemoveDraw(d1);
			Cutscene_RemoveDraw(d2);
			Cutscene_RemoveDraw(d3);
			Cutscene_RemoveDraw(d4);
			Cutscene_SetDrawPosition(asher, 300, 300);
			Cutscene_SetDrawPosition(torrin, 300, 300);
			Cutscene_SetDrawPosition(kaylani, 300, 300);
			if(Game->Counter[CR_MISCSIDEQUEST] == 8){
				Game->DMapPalette[Game->GetCurDMap()] = 0x04F;
				cutsceneG[CG_BGMAP] = 2;
				Cutscene_AnchorCamera(0x4F, 0x4F, 1, 1);
				int soren = Cutscene_NewNPC(2, 80, 112, 33832, 6, OP_OPAQUE);
				Cutscene_SetFlag(soren, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(soren, DIR_UP);
				int misty = Cutscene_NewNPC(2, 64, 112, 33500, 6, OP_OPAQUE);
				Cutscene_SetFlag(misty, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(misty, DIR_UP);
				int dylan = Cutscene_NewNPC(2, 96, 112, 33444, 6, OP_OPAQUE);
				Cutscene_SetFlag(dylan, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(dylan, DIR_UP);
				int mom = Cutscene_NewNPC(2, 64, 80, 33436, 6, OP_OPAQUE);
				Cutscene_SetFlag(mom, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(mom, DIR_DOWN);
				int dad = Cutscene_NewNPC(2, 80, 80, 33388, 6, OP_OPAQUE);
				Cutscene_SetFlag(dad, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(dad, DIR_DOWN);
				
				f1 = Cutscene_NewFastCombo(1, 112, 112, 16717, 2, OP_OPAQUE);
				f2 = Cutscene_NewFastCombo(1, 112, 128, 16721, 2, OP_OPAQUE);
				f3 = Cutscene_NewFastCombo(1, 128, 112, 16717, 2, OP_OPAQUE);
				f4 = Cutscene_NewFastCombo(1, 128, 128, 16721, 2, OP_OPAQUE);
				f5 = Cutscene_NewFastCombo(1, 64, 128, 16721, 2, OP_OPAQUE);
				f6 = Cutscene_NewFastCombo(1, 80, 128, 16721, 2, OP_OPAQUE);
				f7 = Cutscene_NewFastCombo(1, 160, 128, 16721, 2, OP_OPAQUE);
				f8 = Cutscene_NewFastCombo(1, 176, 128, 16721, 2, OP_OPAQUE);
				int f9 = Cutscene_NewFastCombo(1, 112, 32, 16713, 2, OP_OPAQUE);
				int f10 = Cutscene_NewFastCombo(1, 112, 48, 16717, 2, OP_OPAQUE);
				int f11 = Cutscene_NewFastCombo(1, 128, 32, 16713, 2, OP_OPAQUE);
				int f12 = Cutscene_NewFastCombo(1, 128, 48, 16717, 2, OP_OPAQUE);
				w1 = Cutscene_NewFastCombo(1, 64, 144, 16274, 2, OP_OPAQUE);
				w2 = Cutscene_NewFastCombo(1, 80, 144, 16275, 2, OP_OPAQUE);
				w3 = Cutscene_NewFastCombo(1, 160, 144, 16274, 2, OP_OPAQUE);
				w4 = Cutscene_NewFastCombo(1, 176, 144, 16275, 2, OP_OPAQUE);
				d1 = Cutscene_NewFastCombo(1, 112, 144, 16310, 2, OP_OPAQUE);
				d2 = Cutscene_NewFastCombo(1, 128, 144, 16311, 2, OP_OPAQUE);
				d3 = Cutscene_NewFastCombo(3, 112, 160, 16314, 2, OP_OPAQUE);
				d4 = Cutscene_NewFastCombo(3, 128, 160, 16315, 2, OP_OPAQUE);
				int d5 = Cutscene_NewFastCombo(1, 112, 16, 16306, 2, OP_OPAQUE);
				int d6 = Cutscene_NewFastCombo(1, 128, 16, 16307, 2, OP_OPAQUE);
				int d7 = Cutscene_NewFastCombo(3, 112, 0, 16302, 2, OP_OPAQUE);
				int d8 = Cutscene_NewFastCombo(3, 128, 0, 16303, 2, OP_OPAQUE);
				Cutscene_SetAttr(f1, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(f2, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(f3, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(f4, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(f5, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(f6, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(f7, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(f8, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(f9, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(f10, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(f11, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(f12, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(w1, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(w2, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(w3, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(w4, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(d1, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(d2, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(d3, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(d4, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(d5, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(d6, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(d7, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(d8, CGI_DRAWLIFESPAN, -1);
				
				for(i = 0; i<60; i++){
					Cutscene_Update();
					Link->InputMap = false; Link->PressMap = false;
					Link->InputStart = false; Link->PressStart = false;
					NoAction();
					BlackScreenLayerSix();
					Waitframe();
				}
				Cutscene_Waitframe(60);
				Cutscene_PlayString("I know we haven't been... the best of parents recently. But your dad and I are going to be improving. Losing two of you... well, it put things in perspective.", SCHAR_WOMANGREENSKIRTOUTFIT2, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("So no more fighting? No more yelling? No more throwing stuff?", SCHAR_SORENPANTS, EMOTE_SURPRISED, 64, YPOS_UPPER);
				Cutscene_PlayString("All behind us now. Though if you try to run away again Soren, so help me spirits, you'll wish I was only yelling and throwing things.", SCHAR_WOMANGREENSKIRTOUTFIT2, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_RemoveDraw(soren);
				Cutscene_RemoveDraw(misty);
				Cutscene_RemoveDraw(dylan);
				Cutscene_RemoveDraw(mom);
				Cutscene_RemoveDraw(dad);
				Cutscene_RemoveDraw(f1);
				Cutscene_RemoveDraw(f2);
				Cutscene_RemoveDraw(f3);
				Cutscene_RemoveDraw(f4);
				Cutscene_RemoveDraw(f5);
				Cutscene_RemoveDraw(f6);
				Cutscene_RemoveDraw(f7);
				Cutscene_RemoveDraw(f8);
				Cutscene_RemoveDraw(f9);
				Cutscene_RemoveDraw(f10);
				Cutscene_RemoveDraw(f11);
				Cutscene_RemoveDraw(f12);
				Cutscene_RemoveDraw(w1);
				Cutscene_RemoveDraw(w2);
				Cutscene_RemoveDraw(w3);
				Cutscene_RemoveDraw(w4);
				Cutscene_RemoveDraw(d1);
				Cutscene_RemoveDraw(d2);
				Cutscene_RemoveDraw(d3);
				Cutscene_RemoveDraw(d4);
				Cutscene_RemoveDraw(d5);
				Cutscene_RemoveDraw(d6);
				Cutscene_RemoveDraw(d7);
				Cutscene_RemoveDraw(d8);
			}
			if(Game->Counter[CR_ASHERSIDEQUEST] == 4){
				Game->DMapPalette[Game->GetCurDMap()] = 0x0B8;
				cutsceneG[CG_BGMAP] = 2;
				Cutscene_AnchorCamera(0x61, 0x61, 1, 1);
				int iris = Cutscene_NewNPC(2, 192, 128, 33412, 6, OP_OPAQUE);
				Cutscene_SetFlag(iris, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(iris, DIR_LEFT);
				int tim = Cutscene_NewNPC(2, 176, 128, 33404, 6, OP_OPAQUE);
				Cutscene_SetFlag(tim, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(tim, DIR_RIGHT);
				for(i = 0; i<60; i++){
					Cutscene_Update();
					Link->InputMap = false; Link->PressMap = false;
					Link->InputStart = false; Link->PressStart = false;
					NoAction();
					BlackScreenLayerSix();
					Waitframe();
				}
				Cutscene_Waitframe(60);
				Cutscene_PlayString("I don't get it. How'd you get him to bring you a big ole gem like that?", SCHAR_TIM, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("Oh, Tim, you've still got so much to learn about people.", SCHAR_IRIS, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("Can you teach me?", SCHAR_TIM, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("Of course. Oh, but Mom wanted me to head to Pala Bay and buy some muffins for her, and I'll probably be too tired after.", SCHAR_IRIS, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("I'll do it for you! Then you can teach me when I'm back.", SCHAR_TIM, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("If you insist, I GUESS I could let you do that for me.", SCHAR_IRIS, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_RemoveDraw(iris);
				Cutscene_RemoveDraw(tim);
			}
			if(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_12){
				Game->DMapPalette[Game->GetCurDMap()] = 0x091;
				cutsceneG[CG_BGMAP] = 38;
				Cutscene_AnchorCamera(0x5E, 0x5E, 1, 1);
				int shelrond = Cutscene_NewNPC(2, 168, 56, 51816, 6, OP_OPAQUE);
				Cutscene_SetFlag(shelrond, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(shelrond, DIR_DOWN);
				int pirate = Cutscene_NewNPC(2, 168, 128, 33772, 6, OP_OPAQUE);
				Cutscene_SetFlag(pirate, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(pirate, DIR_UP);
				for(i = 0; i<60; i++){
					Cutscene_Update();
					Link->InputMap = false; Link->PressMap = false;
					Link->InputStart = false; Link->PressStart = false;
					NoAction();
					BlackScreenLayerSix();
					Waitframe();
				}
				Cutscene_Waitframe(60);
				Cutscene_PlayString("Let the crew know we're movin' out shortly. We still got plenty a' Igorevich's magic stocked, an' I imagine this oughta fetch a pretty penny in the right ports. It's time we got ourselves a proper 'ideout again. Somethin' a bit less... haunted.", SCHAR_CAPTAIN, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_PlayString("Aye aye, sir!", SCHAR_PIRATE, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_RemoveDraw(shelrond);
				Cutscene_RemoveDraw(pirate);
			}
			if(Game->Counter[CR_TORRINSIDEQUEST] == 6){
				cutsceneG[CG_ACTIVELAYER2] = 2;
				Game->DMapPalette[Game->GetCurDMap()] = 0x100;
				cutsceneG[CG_BGMAP] = 20;
				Cutscene_AnchorCamera(0x2D, 0x2D, 1, 1);
				int zeke = Cutscene_NewNPC(2, 128, 64, 33540, 6, OP_OPAQUE);
				Cutscene_SetFlag(zeke, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(zeke, DIR_RIGHT);
				int caiman = Cutscene_NewNPC(2, 144, 64, 33548, 6, OP_OPAQUE);
				Cutscene_SetFlag(caiman, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(caiman, DIR_LEFT);
				for(i = 0; i<60; i++){
					Cutscene_Update();
					Link->InputMap = false; Link->PressMap = false;
					Link->InputStart = false; Link->PressStart = false;
					NoAction();
					BlackScreenLayerSix();
					Waitframe();
				}
				Cutscene_Waitframe(60);
				Cutscene_PlayString("... What d'ya wanna do with this knife anyway?", SCHAR_CAIMAN, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_PlayString("I dunno... thought it'd be cooler than this.", SCHAR_ZEKE, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_Waitframe(60);
				Cutscene_PlayString("Wanna go hunt a boar with it?", SCHAR_CAIMAN, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_PlayString("Yeah!", SCHAR_ZEKE, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_SetDir(zeke, DIR_LEFT);
				Cutscene_Glide(zeke, -1, 96, 64, 2);
				Cutscene_Glide(caiman, -1, 112, 64, 2);
				Cutscene_Waitglide();
				Cutscene_SetDir(zeke, DIR_UP);
				Cutscene_Glide(zeke, -1, 96, 48, 2);
				Cutscene_Glide(caiman, -1, 96, 64, 2);
				Cutscene_Waitglide();
				Cutscene_SetDir(caiman, DIR_UP);
				Cutscene_Glide(zeke, -1, 96, -16, 2);
				Cutscene_Glide(caiman, -1, 96, -16, 2);
				Cutscene_Waitglide();
				Cutscene_RemoveDraw(caiman);
				Cutscene_RemoveDraw(zeke);
				if(Game->Counter[CR_NIGHTMARCHERQUEST] != 7){
					int terry = Cutscene_NewNPC(2, 240, 96, 33556, 6, OP_OPAQUE);
					Cutscene_SetFlag(terry, CGF_4WAY|CGF_BIGNPC);
					Cutscene_SetDir(terry, DIR_LEFT);
					Cutscene_Glide(terry, -1, 144, 96, 2);
					Cutscene_Waitglide();
					Cutscene_SetDir(terry, DIR_UP);
					Cutscene_PlayString("Get back here, you two!", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_LOWER);
					Cutscene_RemoveDraw(terry);
				}
				cutsceneG[CG_ACTIVELAYER2] = 1;
			}
			if(Game->Counter[CR_GOLEMSIDEQUEST] == 4 && Game->Counter[CR_NIGHTMARCHERQUEST] != 7){
				Game->DMapPalette[Game->GetCurDMap()] = 0x124;
				cutsceneG[CG_BGMAP] = 42;
				Cutscene_AnchorCamera(0x34, 0x34, 1, 1);
				int siyed = Cutscene_NewNPC(2, 120, 128, 33764, 6, OP_OPAQUE);
				Cutscene_SetFlag(siyed, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(siyed, DIR_UP);
				for(i = 0; i<60; i++){
					Cutscene_Update();
					Link->InputMap = false; Link->PressMap = false;
					Link->InputStart = false; Link->PressStart = false;
					NoAction();
					BlackScreenLayerSix();
					Waitframe();
				}
				Cutscene_Waitframe(60);
				Cutscene_PlayString("Alright Siyed, today's the day. No ancient Golems or deranged cultists. Just you and a whole bunch of ruins. Time to prove you're as good an archaeologist as anyone.", SCHAR_SIYED, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_RemoveDraw(siyed);
			}
			if(Game->Counter[CR_GOLEMSIDEQUEST] == 4 && Game->Counter[CR_NIGHTMARCHERQUEST] == 7){
				Game->DMapPalette[Game->GetCurDMap()] = 0x124;
				cutsceneG[CG_BGMAP] = 42;
				Cutscene_AnchorCamera(0x34, 0x34, 1, 1);
				int siyed = Cutscene_NewNPC(2, 112, 128, 33764, 6, OP_OPAQUE);
				Cutscene_SetFlag(siyed, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(siyed, DIR_UP);
				int terry = Cutscene_NewNPC(2, 128, 128, 33556, 6, OP_OPAQUE);
				Cutscene_SetFlag(terry, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(terry, DIR_UP);
				for(i = 0; i<60; i++){
					Cutscene_Update();
					Link->InputMap = false; Link->PressMap = false;
					Link->InputStart = false; Link->PressStart = false;
					NoAction();
					BlackScreenLayerSix();
					Waitframe();
				}
				Cutscene_Waitframe(60);
				Cutscene_PlayString("Sure you wanna come along? It's usually pretty boring.", SCHAR_SIYED, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("That's not what Torrin tells me. He said you had to smash in a bunch a' possessed statues last time.", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("That doesn't usually happen. And I don't really contribute much to the statue smashing.", SCHAR_SIYED, EMOTE_EMBARRASSED, 64, YPOS_UPPER);
				Cutscene_PlayString("Well it's a good thing ya got me aroun' then. Let's roll!", SCHAR_TERRY, EMOTE_HAPPY, 64, YPOS_UPPER);
				Cutscene_RemoveDraw(siyed);
				Cutscene_RemoveDraw(terry);
			}
			if(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_4){
				Game->DMapPalette[Game->GetCurDMap()] = 0x112;
				cutsceneG[CG_BGMAP] = 12;
				Cutscene_AnchorCamera(0x17, 0x17, 1, 1);
				int truf = Cutscene_NewNPC(2, 112, 104, 33628, 6, OP_OPAQUE);
				Cutscene_SetFlag(truf, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(truf, DIR_LEFT);
				
				int t1 = Cutscene_NewCombo(3, 144, 32, 41186, 1, 2, 2, -1, -1, 0, 0, 0, 0, 0, true, OP_OPAQUE);
				Cutscene_SetAttr(t1, CGI_DRAWLIFESPAN, -1);
				
				for(i = 0; i<60; i++){
					Cutscene_Update();
					Link->InputMap = false; Link->PressMap = false;
					Link->InputStart = false; Link->PressStart = false;
					NoAction();
					BlackScreenLayerSix();
					Waitframe();
				}
				Cutscene_Waitframe(60);
				Cutscene_PlayString("I'm sorry I lost your necklace Dad...@pressa()@26@26But I got it back, so it's okay. I know I don't need it to come out and talk to you, but it doesn't feel right without it...", SCHAR_TRUF2, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_Waitframe(60);
				Cutscene_PlayString("I'm really glad you left it for me.", SCHAR_TRUF2, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_RemoveDraw(truf);
				Cutscene_RemoveDraw(t1);
			}
			if(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_2){
				Game->DMapPalette[Game->GetCurDMap()] = 0x0AB;
				cutsceneG[CG_BGMAP] = 20;
				Cutscene_AnchorCamera(0x79, 0x79, 1, 1);
				int namauh = Cutscene_NewNPC(2, 176, 112, 33676, 6, OP_OPAQUE);
				Cutscene_SetFlag(namauh, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(namauh, DIR_UP);
				int laverne = Cutscene_NewNPC(2, 72, 112, 33612, 6, OP_OPAQUE);
				Cutscene_SetFlag(laverne, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(laverne, DIR_RIGHT);
				
				f1 = Cutscene_NewFastCombo(1, 64, 112, 16697, 2, OP_OPAQUE);
				f2 = Cutscene_NewFastCombo(1, 64, 128, 16697, 2, OP_OPAQUE);
				f3 = Cutscene_NewFastCombo(1, 80, 112, 16697, 2, OP_OPAQUE);
				f4 = Cutscene_NewFastCombo(1, 80, 128, 16697, 2, OP_OPAQUE);
				f5 = Cutscene_NewFastCombo(1, 160, 128, 16697, 2, OP_OPAQUE);
				f6 = Cutscene_NewFastCombo(1, 176, 128, 16697, 2, OP_OPAQUE);
				w1 = Cutscene_NewFastCombo(1, 160, 144, 16286, 2, OP_OPAQUE);
				w2 = Cutscene_NewFastCombo(1, 176, 144, 16287, 2, OP_OPAQUE);
				d1 = Cutscene_NewFastCombo(1, 64, 144, 16308, 2, OP_OPAQUE);
				d2 = Cutscene_NewFastCombo(1, 80, 144, 16309, 2, OP_OPAQUE);
				d3 = Cutscene_NewFastCombo(3, 64, 160, 16312, 2, OP_OPAQUE);
				d4 = Cutscene_NewFastCombo(3, 80, 160, 16313, 2, OP_OPAQUE);
				Cutscene_SetAttr(f1, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(f2, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(f3, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(f4, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(f5, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(f6, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(w1, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(w2, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(d1, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(d2, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(d3, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(d4, CGI_DRAWLIFESPAN, -1);
				
				for(i = 0; i<60; i++){
					Cutscene_Update();
					Link->InputMap = false; Link->PressMap = false;
					Link->InputStart = false; Link->PressStart = false;
					NoAction();
					BlackScreenLayerSix();
					Waitframe();
				}
				Cutscene_Waitframe(60);
				Cutscene_PlayString("Honey, I'm home!", SCHAR_LAVERNE, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_SetDir(namauh, DIR_LEFT);
				Cutscene_Waitframe(30);
				Cutscene_PlayString("Laverne! How'd it go?", SCHAR_NAMAUH, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("I got a whole lot of data on the fir trees AND I've got some clippings from a lilikoi passion flower.", SCHAR_LAVERNE, EMOTE_HAPPY, 64, YPOS_UPPER);
				Cutscene_PlayString("If I didn't know better, I'd say you were trying to impress me with that.", SCHAR_NAMAUH, EMOTE_HAPPY, 64, YPOS_UPPER);
				Cutscene_RemoveDraw(laverne);
				Cutscene_RemoveDraw(namauh);
				Cutscene_RemoveDraw(f1);
				Cutscene_RemoveDraw(f2);
				Cutscene_RemoveDraw(f3);
				Cutscene_RemoveDraw(f4);
				Cutscene_RemoveDraw(f5);
				Cutscene_RemoveDraw(f6);
				Cutscene_RemoveDraw(w1);
				Cutscene_RemoveDraw(w2);
				Cutscene_RemoveDraw(d1);
				Cutscene_RemoveDraw(d2);
				Cutscene_RemoveDraw(d3);
				Cutscene_RemoveDraw(d4);
			}
			if(Game->Counter[CR_CULTISTQUEST] == 6){
				Game->DMapPalette[Game->GetCurDMap()] = 0x112;
				cutsceneG[CG_BGMAP] = 12;
				Cutscene_AnchorCamera(0x07, 0x07, 1, 1);
				int allie = Cutscene_NewNPC(2, 80, 96, 33816, 6, OP_OPAQUE);
				Cutscene_SetFlag(allie, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(allie, DIR_LEFT);
				int micah = Cutscene_NewNPC(2, 256, 96, 33908, 6, OP_OPAQUE);
				Cutscene_SetFlag(micah, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(micah, DIR_LEFT);
				
				int t1 = Cutscene_NewCombo(3, 176, 96, 41186, 1, 2, 2, -1, -1, 0, 0, 0, 0, 0, true, OP_OPAQUE);
				int t2 = Cutscene_NewCombo(3, 80, 48, 41186, 1, 2, 2, -1, -1, 0, 0, 0, 0, 0, true, OP_OPAQUE);
				Cutscene_SetAttr(t1, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(t2, CGI_DRAWLIFESPAN, -1);
				
				for(i = 0; i<60; i++){
					Cutscene_Update();
					Link->InputMap = false; Link->PressMap = false;
					Link->InputStart = false; Link->PressStart = false;
					NoAction();
					BlackScreenLayerSix();
					Waitframe();
				}
				Cutscene_Waitframe(60);
				Cutscene_Glide(micah, -1, 192, 96, 1);
				Cutscene_Waitframe(30);
				Cutscene_PlayString("Hey... sis?", SCHAR_MICAH2, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_SetDir(allie, DIR_RIGHT);
				Cutscene_Waitframe(30);
				Cutscene_PlayString("I don't remember saying you were welcome back yet.", SCHAR_ALLIE, EMOTE_ANGRY, 64, YPOS_UPPER);
				Cutscene_PlayString("I'm not here to stay. Just stopping by to say sorry. I shouldn't have left without telling you. And obviously I shouldn't have done the things I did. But I'm not as strong as you. I couldn't just sit by and watch Mom wither away. But... I'm sorry I wasn't there for you.", SCHAR_MICAH2, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_Waitframe(90);
				Cutscene_PlayString("I told myself I'd never forgive you, but you're making that really difficult right now.", SCHAR_ALLIE, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("Just doing my job.", SCHAR_MICAH2, EMOTE_HAPPY, 64, YPOS_UPPER);
				Cutscene_PlayString("Ugh... get over here, you sentimental idiot.", SCHAR_ALLIE, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_RemoveDraw(allie);
				Cutscene_RemoveDraw(micah);
				Cutscene_RemoveDraw(t1);
				Cutscene_RemoveDraw(t2);
			}
			Game->DMapPalette[Game->GetCurDMap()] = 0x112;
			cutsceneG[CG_BGMAP] = 12;
			Cutscene_AnchorCamera(0x09, 0x09, 1, 1);
			int BG[96];
			for(i = 0; i<96; i++){
				if(Game->GetComboData(1, 0x69, i) != 0){
					BG[i] = Cutscene_NewFastCombo(0, ComboX(i), ComboY(i), Game->GetComboData(1, 0x69, i), 4, OP_OPAQUE);
					Cutscene_SetAttr(BG[i], CGI_DRAWLIFESPAN, -1);
				}
			}
			
			int t1 = Cutscene_NewCombo(3, 113, 32, 41186, 1, 2, 2, -1, -1, 0, 0, 0, 0, 0, true, OP_OPAQUE);
			int t2 = Cutscene_NewCombo(3, 48, 64, 41186, 1, 2, 2, -1, -1, 0, 0, 0, 0, 0, true, OP_OPAQUE);
			// int t3 = Cutscene_NewCombo(3, 192, 48, 8644, 1, 1, 4, -1, -1, 0, 0, 0, 0, 0, true, OP_OPAQUE);
			Cutscene_SetAttr(t1, CGI_DRAWLIFESPAN, -1);
			Cutscene_SetAttr(t2, CGI_DRAWLIFESPAN, -1);
			// Cutscene_SetAttr(t3, CGI_DRAWLIFESPAN, -1);
			
			Cutscene_SetDrawPosition(asher, 64, 64);
			Cutscene_SetDrawPosition(torrin, 96, 64);
			Cutscene_SetDrawPosition(kaylani, 80, 48);
			Cutscene_SetDir(asher, DIR_RIGHT);
			Cutscene_SetDir(torrin, DIR_LEFT);
			Cutscene_SetDir(kaylani, DIR_DOWN);
			
			for(i = 0; i<60; i++){
				Cutscene_Update();
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				NoAction();
				BlackScreenLayerSix();
				Waitframe();
			}
			Cutscene_Waitframe(60);
			Cutscene_PlayString("Well... I guess this is where we part ways for now.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_PlayString("Glad to finally be rid of me?", SCHAR_TORRIN, EMOTE_WINK, 64, YPOS_LOWER);
			Cutscene_PlayString("If I didn't know I'd be seeing you again soon, maybe.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_PlayString("How long do you think it'll be before your grandmother wants us back at it?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_PlayString("Who knows. Probably depends on how many people she can spare and how quickly any leads turn up.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_PlayString("All a moot point, cuz I don't intend to sit still any longer than a week or two.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_PlayString("I don't think I can sit still for too long myself. But... a few days of relaxing sounds nice.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_PlayString("Sounds good to me. We'll catch you later, Kaylani.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_PlayString("Safe travels home, both of you.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
			for(i = 0; i<60; i++){
				Cutscene_Update();
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				NoAction();
				BlackishScreenLayerSix();
				Waitframe();
			}
			for(i = 0; i<60; i++){
				Cutscene_Update();
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				NoAction();
				BlackScreenLayerSix();
				Waitframe();
			}
			SetCutsceneSkip(CUTSCENE_NULL); //CUTSCENE_ENDING
			this->Data = CMB_AUTOWARPA;
		}	
		if(scene == 21){
			Game->DMapPalette[Game->GetCurDMap()] = 0x050;
			DayNight[_DN_HOUR] = 10;
			DayNight[_DN_MINUTE] = 0;
			DayNight[_DN_SECOND] = 0;
			if(G[G_RANDOMIZERENABLED]){
				this->Data = CMB_AUTOWARPA;
				while(true){
					this->Data = CMB_AUTOWARPA;
					WaitNoAction();
				}
			}
			G[G_TIMEFROZEN] = 1;
			Game->PlayMIDI(0);
			WaitNoAction(60);
			PlayStringAndWait("Asher!", SCHAR_UNKNOWN, EMOTE_NORMAL, 68, 24);
			WaitNoAction(120);
			PlayStringAndWait("Asher! C'mon mate, wake up!", SCHAR_UNKNOWN, EMOTE_NORMAL, 68, 24);
			Game->PlayEnhancedMusic("SS-Puna.ogg", 0);
			Cutscene_Init(RT_BITMAP1, RT_BITMAP2);
			Cutscene_AnchorCamera(0x58, 0x58, 1, 1);
			int torrin = Cutscene_NewNPC(2, 64, 56, 50952, 6, 128);
			Cutscene_SetFlag(torrin, CGF_4WAY|CGF_BS|CGF_BIGNPC);
			Cutscene_SetDir(torrin, DIR_LEFT);
			int kaylani = Cutscene_NewNPC(2, 64, 72, 50960, 6, 128);
			Cutscene_SetFlag(kaylani, CGF_4WAY|CGF_BS|CGF_BIGNPC);
			Cutscene_SetDir(kaylani, DIR_LEFT);
			int asher = Cutscene_NewTile(2, 32, 48, 33705, 2, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
			Cutscene_SetAttr(asher, CGI_DRAWLIFESPAN, -1);
			for(i = 0; i<60; i++){
				Cutscene_Update();
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				NoAction();
				BlackishScreenLayerSix();
				Waitframe();
			}
			Cutscene_Waitframe(60);
			Cutscene_PlayString("There we go. Told ya you weren't bein' loud 'nough.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_PlayString("Uh... good morning? What are you both doing here?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_PlayString("Is a guy not allowed to visit his best friend?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_PlayString("But this early?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_PlayString("Asher, it's 10 o'clock. We waited outside for a while, until your mom gave up and told us to wake you.", SCHAR_KAYLANI, EMOTE_ELLIPSES, 64, YPOS_LOWER);
			Cutscene_PlayString("Oh...", SCHAR_ASHER, EMOTE_EMBARRASSED, 64, YPOS_LOWER);
			Cutscene_PlayString("'nough about that though. Let's get movin' already!", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_PlayString("Moving? Where to? Did they find Selet?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_PlayString("Grandmother acts calm, but they haven't found a corpse anywhere. I KNOW he's out there, somewhere.", SCHAR_KAYLANI, EMOTE_SAD, 64, YPOS_LOWER);
			Cutscene_PlayString("And it's drivin' me crazy. Winno can't expect us to just sit around for weeks doin' nothin'!", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_PlayString("I've been getting a bit antsy myself. So I figured maybe we should explore a bit. Not that we'll turn up anything, but a little bit of exploring seemed like a good way to my mind off things.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_PlayString("So... basically you're getting as stir-crazy as Torrin is.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_PlayString("More or less.", SCHAR_KAYLANI, EMOTE_EMBARRASSED, 64, YPOS_LOWER);
			Cutscene_PlayString("So what d'ya say, mate? You comin' or what?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_PlayString("Sure thing. Sounds like a fun way to spend the day.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
			Game->LastEntranceDMap = 15;
			Game->LastEntranceScreen = 0x50;
			Game->ContinueDMap = 15;
			Game->ContinueScreen = 0x50;
			G[G_TIMEFROZEN] = 0;
			this->Data = CMB_AUTOWARPA;
		}
		if(scene == 22 && Game->Counter[CR_STORYFLAG] == SFLAG_GAMECLEAR && Screen->State[ST_SECRET] == false){
			if(G[G_RANDOMIZERENABLED])
				Quit();
			G[G_TIMEFROZEN] = 1;
			Cutscene_Init(RT_BITMAP1, RT_BITMAP2);
			cutsceneG[CG_BGMAP] = 20;
			Cutscene_AnchorCamera(0x75, 0x75, 1, 1);
			int grandma;
			grandma = Cutscene_NewNPC(2, 120, 56, 33792, 8, 128);
			Cutscene_SetFlag(grandma, CGF_4WAY|CGF_BIGNPC);
			Cutscene_SetDir(grandma, DIR_DOWN);
			int truf;
			truf = Cutscene_NewNPC(2, 120, 96, Game->Counter[CR_SMALLSIDEQUESTS1] & BF_4?33628:33620, 6, OP_OPAQUE);
			Cutscene_SetFlag(truf, CGF_4WAY|CGF_BIGNPC);
			Cutscene_SetDir(truf, DIR_UP);
			int torrin;
			torrin = Cutscene_NewNPC(2, 120, 176+16, 50952, 6, 128);
			Cutscene_SetFlag(torrin, CGF_4WAY|CGF_BIGNPC|CGF_BS);
			int asher;
			asher = Cutscene_NewNPC(2, 120, 176+16, 51000, 6, 128);
			Cutscene_SetFlag(asher, CGF_4WAY|CGF_BIGNPC|CGF_BS);
			int kaylani;
			kaylani = Cutscene_NewNPC(2, 120, 176+16, 50960, 6, 128);
			Cutscene_SetFlag(kaylani, CGF_4WAY|CGF_BIGNPC|CGF_BS);
			
			//Stupid doors and windows
			int f1 = Cutscene_NewFastCombo(1, 112, 112, 16697, 2, OP_OPAQUE);
			int f2 = Cutscene_NewFastCombo(1, 112, 128, 16697, 2, OP_OPAQUE);
			int f3 = Cutscene_NewFastCombo(1, 128, 112, 16697, 2, OP_OPAQUE);
			int f4 = Cutscene_NewFastCombo(1, 128, 128, 16697, 2, OP_OPAQUE);
			int f5 = Cutscene_NewFastCombo(1, 160, 128, 16697, 2, OP_OPAQUE);
			int f6 = Cutscene_NewFastCombo(1, 176, 128, 16697, 2, OP_OPAQUE);
			int f7 = Cutscene_NewFastCombo(1, 64, 128, 48777, 2, OP_OPAQUE);
			int f8 = Cutscene_NewFastCombo(1, 80, 128, 48777, 2, OP_OPAQUE);
			int w1 = Cutscene_NewFastCombo(1, 64, 144, 16286, 2, OP_OPAQUE);
			int w2 = Cutscene_NewFastCombo(1, 80, 144, 16287, 2, OP_OPAQUE);
			int w3 = Cutscene_NewFastCombo(1, 160, 144, 16286, 2, OP_OPAQUE);
			int w4 = Cutscene_NewFastCombo(1, 176, 144, 16287, 2, OP_OPAQUE);
			int d1 = Cutscene_NewFastCombo(1, 112, 144, 16308, 2, OP_OPAQUE);
			int d2 = Cutscene_NewFastCombo(1, 128, 144, 16309, 2, OP_OPAQUE);
			int d3 = Cutscene_NewFastCombo(4, 112, 160, 16312, 2, OP_OPAQUE);
			int d4 = Cutscene_NewFastCombo(4, 128, 160, 16313, 2, OP_OPAQUE);
			if(DayNight_IsBetween(DAYNIGHT_MIDI_NIGHT_START_HOUR, 0, 0, DAYNIGHT_MIDI_NIGHT_END_HOUR, 0, 0)){
				Cutscene_SetAttr(f1, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(f2, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(f3, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(f4, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(f5, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(f6, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(f7, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(f8, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(w1, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(w2, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(w3, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(w4, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(d1, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(d2, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(d3, CGI_DRAWLIFESPAN, -1);
				Cutscene_SetAttr(d4, CGI_DRAWLIFESPAN, -1);
			}
			else{
				Cutscene_RemoveDraw(f1);
				Cutscene_RemoveDraw(f2);
				Cutscene_RemoveDraw(f3);
				Cutscene_RemoveDraw(f4);
				Cutscene_RemoveDraw(f5);
				Cutscene_RemoveDraw(f6);
				Cutscene_RemoveDraw(f7);
				Cutscene_RemoveDraw(f8);
				Cutscene_RemoveDraw(w1);
				Cutscene_RemoveDraw(w2);
				Cutscene_RemoveDraw(w3);
				Cutscene_RemoveDraw(w4);
				Cutscene_RemoveDraw(d1);
				Cutscene_RemoveDraw(d2);
				Cutscene_RemoveDraw(d3);
				Cutscene_RemoveDraw(d4);
			}
			Cutscene_Waitframe(30);
			Cutscene_PlayString("You've done very well, Truf. A scouting mission like this was no small feat for one of your age. I'm proud of you. Perhaps it's time...", SCHAR_WINNO, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_PlayString("Time for what?", Game->Counter[CR_SMALLSIDEQUESTS1] & BF_4?SCHAR_TRUF2:SCHAR_TRUF, EMOTE_QUESTION, 64, YPOS_UPPER);
			Cutscene_Waitframe(30);
			Game->PlayEnhancedMusic("SS-Test.ogg", 0);
			Cutscene_PlayString("It's time to see how far your training has come. I want you to attack me with everything you have!", SCHAR_WINNO, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_PlayString("What!? I can't fight you!", Game->Counter[CR_SMALLSIDEQUESTS1] & BF_4?SCHAR_TRUF2:SCHAR_TRUF, EMOTE_SURPRISED, 64, YPOS_UPPER);
			Cutscene_PlayString("Your father told me the same when he was your age, but he nearly knocked me out the window. Don't sell yourself short. You'll never know what you're capable of if you hold back!", SCHAR_WINNO, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_SetDir(kaylani, DIR_UP);
			Cutscene_SetDir(asher, DIR_LEFT);
			Cutscene_SetDir(torrin, DIR_RIGHT);
			Cutscene_Glide(kaylani, -1, 120, 112, 1);
			Cutscene_Waitglide(kaylani);
			Cutscene_SetDrawPosition(asher, CutX(kaylani), CutY(kaylani));
			Cutscene_SetDrawPosition(torrin, CutX(kaylani), CutY(kaylani));
			Cutscene_GlideRelative(asher, -1, -16, 0, 1);
			Cutscene_GlideRelative(torrin, -1, 16, 0, 1);
			Cutscene_Waitglide();
			Cutscene_SetDir(asher, DIR_UP);
			Cutscene_SetDir(torrin, DIR_UP);
			Cutscene_Waitframe(32);
			Cutscene_PlayString("Uh... are we interrupting something?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			if(DayNight_IsBetween(DAYNIGHT_MIDI_NIGHT_START_HOUR, 0, 0, DAYNIGHT_MIDI_NIGHT_END_HOUR, 0, 0))
				Game->PlayEnhancedMusic("SS-HokuNight.ogg", 0);
			else
				Game->PlayEnhancedMusic("SS-Hoku.ogg", 0);
			Cutscene_PlayString("Oh, you're all back. It looks like our trial will have to wait, Truf. Wait outside and I'll be with you shortly.", SCHAR_WINNO, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_PlayString("Um... okay?", Game->Counter[CR_SMALLSIDEQUESTS1] & BF_4?SCHAR_TRUF2:SCHAR_TRUF, EMOTE_ELLIPSES, 64, YPOS_UPPER);
			Cutscene_SetDir(truf, DIR_RIGHT);
			Cutscene_Glide(truf, -1, 152, CutY(truf), 1);
			Cutscene_Waitglide();
			Cutscene_SetDir(truf, DIR_DOWN);
			Cutscene_Glide(truf, -1, 152, 128, 1);
			Cutscene_Waitglide();
			Cutscene_SetAttr(truf, CGI_LAYER, 3);
			Cutscene_SetDir(truf, DIR_LEFT);
			Cutscene_Glide(truf, -1, 120, 128, 1);
			Cutscene_Waitglide();
			Cutscene_SetDir(truf, DIR_UP);
			Cutscene_Waitframe(15);
			Cutscene_SetDir(kaylani, DIR_DOWN);
			Cutscene_Waitframe(15);
			Cutscene_PlayString("Your grandmother kinda scares me, Kaylani...", Game->Counter[CR_SMALLSIDEQUESTS1] & BF_4?SCHAR_TRUF2:SCHAR_TRUF, EMOTE_SAD, 64, YPOS_UPPER);
			Cutscene_SetDir(truf, DIR_DOWN);
			Cutscene_Glide(truf, -1, 120, 136, 1);
			Cutscene_Waitglide();
			Cutscene_SetAttr(truf, CGI_LAYER, 2);
			Cutscene_Glide(truf, -1, 120, 176, 1);
			Cutscene_Waitglide();
			Cutscene_SetDir(kaylani, DIR_UP);
			Cutscene_Waitframe(30);
			Cutscene_PlayString("I'd ask what you're up to, but I recognize that look. We still haven't found any sign of Selet.", SCHAR_WINNO, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_PlayString("I figured as much, but I wanted to check.", SCHAR_KAYLANI, EMOTE_SAD, 64, YPOS_UPPER);
			Cutscene_PlayString("I told you already, we're handling the situation. I know it's hard, but the three of you need to take a break from all of this.", SCHAR_WINNO, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_PlayString("We are. We've been relaxing. Sort of.", SCHAR_ASHER, EMOTE_ELLIPSES, 64, YPOS_UPPER);
			Cutscene_PlayString("Pokin' around here and there, ya know, but mostly just 'avin' fun.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("I'm not sure how convinced I am.", SCHAR_WINNO, EMOTE_EYEBROWRAISED, 64, YPOS_LOWER);
			Cutscene_PlayString("Just let us know if you find anything.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("You'll be the first to know. Now please. I'm speaking not as the chief, but as a parent. Go do something to take your mind off things. Catch up with friends, relax in the sun, go explore the world if that's what it takes. But take care of yourselves.", SCHAR_WINNO, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_PlayString("We will, don't worry.", SCHAR_KAYLANI, EMOTE_HAPPY, 64, YPOS_UPPER);
			Cutscene_PlayString("Excellent. Send Truf back in when you leave.", SCHAR_WINNO, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_PlayString("I think he's long gone by now...", SCHAR_TORRIN, EMOTE_ELLIPSES, 64, YPOS_UPPER);
			if(Game->Counter[CR_NIGHTMARCHERQUEST] == 7 && Game->Counter[CR_MISCSIDEQUEST] == 8 && Game->Counter[CR_HELPERQUEST] == 0){
				Cutscene_PlayString("Oh, I know I said to take your mind off things, but there is one thing you might want to hear. While we haven't found Selet, we have something you might be interested in. Siyed can fill you in. He's on an island southeast of here.", SCHAR_WINNO, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_PlayString("Siyed? What's he got to do with this?", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("It's his story to tell, not mine.", SCHAR_WINNO, EMOTE_NORMAL, 64, YPOS_LOWER);
				Cutscene_PlayString("I see. Thank you.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("Of course. Now off with you.", SCHAR_WINNO, EMOTE_NORMAL, 64, YPOS_LOWER);
			}
			for(i=0; i<32; ++i){
				Cutscene_NewRectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
				Cutscene_Waitframe();
			}
			Screen->State[ST_SECRET] = true;
			G[G_TIMEFROZEN] = 0;
			Link->Warp(28, 0x02);
			Cutscene_NewRectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
			Cutscene_Waitframe();
		}
		if(scene == 23 && Game->Counter[CR_STORYFLAG] == SFLAG_GAMECLEAR && Screen->State[ST_SECRET] == false){
			if(G[G_RANDOMIZERENABLED])
				Quit();
			G[G_TIMEFROZEN] = 1;
			Link->Invisible = true;
			ffc Kaylani = FFCNPC(CMB_KAYLANI, 144, 112);
			SetFFCDir(Kaylani, DIR_UP, false);
			ffc Asher = FFCNPC(CMB_ASHER, 128, 112);
			SetFFCDir(Asher, DIR_UP, false);
			ffc Torrin = FFCNPC(CMB_TORRIN, 136, 96);
			SetFFCDir(Torrin, DIR_UP, false);
			
			ffc Talcay = FFCNPC(33604, 136, 64);
			SetFFCDir(Talcay, DIR_UP, false);
			ffc Kenja = FFCNPC(33484, 128, 48);
			SetFFCDir(Kenja, DIR_DOWN, false);
			ffc Skai = FFCNPC(33564, 144, 48);
			SetFFCDir(Skai, DIR_DOWN, false);
			
			Torrin->Flags[FFCF_OVERLAY] = true;
			Kaylani->Flags[FFCF_OVERLAY] = true;
			Asher->Flags[FFCF_OVERLAY] = true;
			Talcay->Flags[FFCF_OVERLAY] = true;
			Skai->Flags[FFCF_OVERLAY] = true;
			Kenja->Flags[FFCF_OVERLAY] = true;
			WaitNoAction(2);
			Game->PlayMIDI(0);
			
			WaitNoAction(60);
			
			PlayStringAndWait("I'm tellin' ya, he saved me. Wouldn't be here today if he 'adn't shown up when he did.", SCHAR_KENJA, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("I admire the way you've always stuck up for him, Kenja, but I'm not a fool.", SCHAR_TALCAY, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("I know it sounds far fetched, Talcay, but it's the truth. Torrin may be reckless an' impulsive, but he's a hero.", SCHAR_SKAI, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("...", SCHAR_TALCAY, EMOTE_ELLIPSES, 64, YPOS_LOWER);
			SetFFCDir(Torrin, DIR_UP, true);
			for(i = 0; i<32; i++){
				Torrin->Y-=0.5;
				WaitNoAction();
			}
			SetFFCDir(Torrin, DIR_UP, false);
			WaitNoAction(60);
			PlayStringAndWait("Uh... hey, Ma.", SCHAR_TORRIN, EMOTE_ELLIPSES, 64, YPOS_UPPER);
			SetFFCDir(Talcay, DIR_DOWN, false);
			WaitNoAction(30);
			PlayStringAndWait("Torrin... I really don't know what to make a' you sometimes. You've given me so much grief over the years. I've spent so much time worryin' you're dead at the bottom of some ditch, or floatin' face down in the waves. An' all you've ever given me in return is half-assed excuses 'bout doin' the right thing.", SCHAR_TALCAY, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("Half-assed? I-", SCHAR_TORRIN, EMOTE_SURPRISED, 64, YPOS_UPPER);
			PlayStringAndWait("An' now, suddenly everyone's tellin' me you're some kind a' hero. What am I supposed to think a' that? That you always had that in ya and only caused trouble 'round me outta spite? Or that a month away from me suddenly turns ya into a better person?", SCHAR_TALCAY, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("Well shucks, that ain't what-", SCHAR_TORRIN, EMOTE_SAD, 64, YPOS_UPPER);
			PlayStringAndWait("I don't know what to do with you, Torrin. I'm proud a' you for savin' everyone. And mad enough at you for waitin' so long that I could slap you.", SCHAR_TALCAY, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("Talcay, maybe ya oughta-", SCHAR_KENJA, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("An' right now, I think I'm more proud than mad. But... stars be damned Torrin, why do you have to make even your good deeds so vexin'?", SCHAR_TALCAY, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("Uh... I don't really know how to answer that.", SCHAR_TORRIN, EMOTE_SURPRISED, 64, YPOS_UPPER);
			PlayStringAndWait("I don't expect ya to. I dunno what I expect from you anymore.", SCHAR_TALCAY, EMOTE_NORMAL, 64, YPOS_LOWER);
			SetFFCDir(Talcay, DIR_UP, false);
			WaitNoAction(15);
			SetFFCDir(Skai, DIR_LEFT, true);
			for(i = 0; i<8; i++){
				Skai->X+=2;
				WaitNoAction();
			}
			SetFFCDir(Skai, DIR_LEFT, false);
			SetFFCDir(Talcay, DIR_RIGHT, true);
			for(i = 0; i<8; i++){
				Talcay->X++;
				WaitNoAction();
			}
			SetFFCDir(Talcay, DIR_UP, true);
			while(Talcay->Y > -32){
				if(Talcay->Y < 30){
					SetFFCDir(Skai, DIR_UP, false);
					SetFFCDir(Kenja, DIR_UP, false);
				}
				Talcay->Y--;
				WaitNoAction();
			}
			ClearFFC(Talcay);
			WaitNoAction(120);
			SetFFCDir(Skai, DIR_DOWN, false);
			SetFFCDir(Kenja, DIR_DOWN, false);
			WaitNoAction(60);
			PlayStringAndWait("Ya know... I think that's the first time she's said she's proud a' me.", SCHAR_TORRIN, EMOTE_ELLIPSES, 64, YPOS_UPPER);
			PlayStringAndWait("Give 'er some space for now. I think she needs some time to adjust to everything.", SCHAR_KENJA, EMOTE_NORMAL, 64, YPOS_LOWER);
			PlayStringAndWait("For what it's worth, we're all proud a' you too, Torrin. Unconditionally.", SCHAR_SKAI, EMOTE_NORMAL, 64, YPOS_LOWER);
			SetFFCDir(Skai, DIR_RIGHT, true);
			SetFFCDir(Kenja, DIR_UP, true);
			while(Skai->X < 272){
				Kenja->Y--;
				Skai->X++;
				WaitNoAction();
			}
			ClearFFC(Skai);
			ClearFFC(Kenja);
			SetFFCDir(Asher, DIR_UP, true);
			SetFFCDir(Kaylani, DIR_UP, true);
			while(Asher->Y > Torrin->Y){
				Asher->Y--;
				Kaylani->Y--;
				WaitNoAction();
			}
			SetFFCDir(Asher, DIR_RIGHT, true);
			SetFFCDir(Kaylani, DIR_LEFT, true);
			while(Kaylani->X > Torrin->X){
				Asher->X++;
				Kaylani->X--;
				WaitNoAction();
			}
			Link->X = Torrin->X;
			Link->Y = Torrin->Y+16;
			ClearFFC(Asher);
			ClearFFC(Torrin);
			ClearFFC(Kaylani);
			Screen->State[ST_SECRET] = true;
			Link->Invisible = false;
			G[G_TIMEFROZEN] = 0;
			if(DayNight_IsBetween(DAYNIGHT_MIDI_NIGHT_START_HOUR, 0, 0, DAYNIGHT_MIDI_NIGHT_END_HOUR, 0, 0))
				Game->PlayEnhancedMusic("SS-MalkaNight.ogg", 0);
			else
				Game->PlayEnhancedMusic("SS-Malka.ogg", 0);
		}
		if(scene == 24){
			if(G[G_CHASEDIFF]==-1){
				ffc Chase = FFCNPC(33848, 120, 72);
				SetFFCDir(Chase, DIR_DOWN, false);
				Link->Action = LA_ATTACKING;
				WaitNoAction();
				Link->Action = LA_NONE;
				WaitNoAction(60);
				int timer;
				while(Link->Y > 144){
					NoAction();
					timer++;
					if(timer % 2 == 0){
						Link->InputUp = true;
						if(Link->X < 120)
							Link->X++;
						if(Link->X > 120)
							Link->X--;
					}
					Waitframe();
				}
				Link->Action = LA_ATTACKING;
				WaitNoAction();
				Link->Action = LA_NONE;
				WaitNoAction(60);
				if(G[G_RANDOMIZERENABLED]){
					PlayStringAndWait("Nice exploit, nerd. Bugger off.", SCHAR_CHASE, EMOTE_EYEBROWRAISED, 64, YPOS_UPPER);
					Game->End();
				}
				PlayStringAndWait("Hey guys!", SCHAR_CHASE, EMOTE_HAPPY, 64, YPOS_UPPER);
				PlayStringAndWait("Chase? What are you doing up here?", SCHAR_ASHER, EMOTE_SURPRISED, 64, YPOS_UPPER);
				PlayStringAndWait("Uncle Dracus thinks he's close to finding the Light of the Heavens and the sun god it's connected to. He was talking about how he thinks this mountain's connected to it. So I snuck into the boat and came along.", SCHAR_CHASE, EMOTE_NORMAL, 64, YPOS_UPPER);
				PlayStringAndWait("And then you climbed all the way up here alone? Chase, that's incredibly dangerous!", SCHAR_KAYLANI, EMOTE_DISMAYED, 64, YPOS_UPPER);
				PlayStringAndWait("It's okay. I've got my solar magic to protect me.", SCHAR_CHASE, EMOTE_HAPPY, 64, YPOS_UPPER);
				PlayStringAndWait("Wait, huh? You're a solar mage?", SCHAR_TORRIN, EMOTE_SURPRISED, 64, YPOS_UPPER);
				PlayStringAndWait("Yeah! I hadn't practiced much before cuz Uncle Dracus told me it's too dangerous, but seeing you save the world made me feel like I wasn't doing enough. I wanted to learn how to use magic and be a hero too!", SCHAR_CHASE, EMOTE_HAPPY, 64, YPOS_UPPER);
				PlayStringAndWait("That's... that very nobel of you, but even with magic, coming up somewhere like this alone is dangerous, Chase.", SCHAR_ASHER, EMOTE_ELLIPSES, 64, YPOS_UPPER);
				PlayStringAndWait("I'm fine! I've gotten really good with it! I bet I'm as strong as you three are!", SCHAR_CHASE, EMOTE_HAPPY, 64, YPOS_UPPER);
				PlayStringAndWait("Is that a challenge?", SCHAR_TORRIN, EMOTE_WINK, 64, YPOS_UPPER);
				PlayStringAndWait("Is it? Can we have a sparring match?", SCHAR_CHASE, EMOTE_HAPPY, 64, YPOS_UPPER);
				PlayStringAndWait("Torrin! Don't encourage this!", SCHAR_KAYLANI, EMOTE_ANGRY, 64, YPOS_UPPER);
				PlayStringAndWait("Oh c'mon, look how excited 'e looks. Are ya really gonna say no to a face like that?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
				PlayStringAndWait("... fine, but I don't condone this.", SCHAR_KAYLANI, EMOTE_ELLIPSES, 64, YPOS_UPPER);
				PlayStringAndWait("Yay! I can't wait! I'm warning you though, I've gotten REALLY good at this. Want me to go easy on you?", SCHAR_CHASE, EMOTE_HAPPY, 64, YPOS_UPPER);
				int Easy[] = "You're DEFINITELY too strong. Please go easy on us!";
				int Medium[] = "Let's have a fair fight.";
				int Hard[] = "Hold back? Hit us with everything you've got!";
				int Options[] = {Easy, Medium, Hard};
				int handler[6];
				while(handler[1] == 0){
					DialogueBox_RunSingleFrame(handler, 128, 8+52, Options, TIL_DB_DIALOGUE_BOX, CS_DB_DIALOGUE_BOX, C_DB_DIALOGUE_BOX_BG, FONT_P, 0xB2, TIL_DB_DIALOGUE_SELECTOR, CS_DB_DIALOGUE_SELECTOR);
					WaitNoAction();
				}
				if(handler[0] == 0){
					PlayStringAndWait("Alright, I'll try not to go too crazy!", SCHAR_CHASE, EMOTE_HAPPY, 64, YPOS_UPPER);
					G[G_CHASEDIFF] = 2;
				}
				else if(handler[0] == 1){
					PlayStringAndWait("That sounds fun! Let's go!", SCHAR_CHASE, EMOTE_HAPPY, 64, YPOS_UPPER);
					G[G_CHASEDIFF] = 1;
				}
				else if(handler[0] == 2){
					PlayStringAndWait("Okay, but you asked for it!", SCHAR_CHASE, EMOTE_HAPPY, 64, YPOS_UPPER);
					G[G_CHASEDIFF] = 0;
				}
				Chase->Data = 0;
				if(Game->Counter[CR_CHASEQUEST] < 8)
					Game->Counter[CR_CHASEQUEST] = 8;
			}
			mapdata l1 = Game->LoadTempScreen(1);
			l1->ComboD[167] = 1;
			l1->ComboD[168] = 1;
			this->Misc[0] = 0;
			this->Misc[1] = 0;
			npc chaseNPC = CreateNPCAt(251, 120, 72+8);
			while(this->CSet == 0)
				Waitframe();
			Game->PlayMIDI(0);
			ffc Chase = FFCNPC(33848, this->Misc[0], this->Misc[1]);
			SetFFCDir(Chase, AngleDir4(Angle(Chase->X, Chase->Y+16, Link->X, Link->Y)), false);
			if(G[G_CHASEDIFF] == 2){
				PlayStringAndWait("Alright, that was fun! But we should stop before someone gets hurt.", SCHAR_CHASE, EMOTE_HAPPY, 64, YPOS_UPPER);
				PlayStringAndWait("Thanks for playing with me! Let's do this again sometime!", SCHAR_CHASE, EMOTE_HAPPY, 64, YPOS_UPPER);
			}
			if(G[G_CHASEDIFF] == 1){
				PlayStringAndWait("Whoa, do you guys smell smoke? Maybe we should stop for now. I'd feel really bad if I set something on fire accidentally. I did that once and Uncle Dracus REALLY chewed me out.", SCHAR_CHASE, EMOTE_SURPRISED, 64, YPOS_UPPER);
				PlayStringAndWait("Thanks for playing with me! I'll see you back in Pala Bay!", SCHAR_CHASE, EMOTE_HAPPY, 64, YPOS_UPPER);
			}
			if(G[G_CHASEDIFF] == 0){
				PlayStringAndWait("Ow! I think I scraped my knee...", SCHAR_CHASE, EMOTE_SAD, 64, YPOS_UPPER);
				PlayStringAndWait("Oh well. That was fun! Here, I've got a present for you.", SCHAR_CHASE, EMOTE_NORMAL, 64, YPOS_UPPER);
				Game->PlaySound(62);
				eweapon e = CreateEWeaponAt(EW_SCRIPT10, 120, 80);
				e->CollDetection = false;
				e->DrawYOffset = -1000;
				int Args[8] = {224};
				RunEWeaponScript(e, "ItemPopup", Args);
				Link->Item[224] = true;
				if(Game->Counter[CR_RUPEES] < 999)
					Game->Counter[CR_RUPEES]++;
				WaitNoAction(210);
				PlayStringAndWait("It's my lucky charm! I got it from a weird frog. Uncle Dracus thinks it's stupid, but I-", SCHAR_CHASE, EMOTE_HAPPY, 64, YPOS_UPPER);
				Game->PlaySound(SFX_HORIZONALARM);
				PlayStringAndWait("Uncle Dracus! I've gotta get down to the boat before he leaves! He's gonna be so mad if he finds out I snuck out here. I'll see you guys later!", SCHAR_CHASE, EMOTE_DISMAYED, 64, YPOS_UPPER);
			}
			SetFFCDir(Chase, AngleDir4(Angle(Chase->X, Chase->Y+16, 120, 144)), false);
			// FFCGlide(Chase, 120, 144, 1, true);
			FFCGlide({Chase}, {120}, {128}, {1}, {true});
			SetFFCDir(Chase, DIR_DOWN, false);
			// FFCGlide(Chase, 120, 176, 1, true);
			FFCGlide({Chase}, {120}, {176}, {1}, {true});
			WaitNoAction(120);
			PlayStringAndWait("What the hell just 'appened?", SCHAR_TORRIN, EMOTE_SWEAT, 64, YPOS_UPPER);
			PlayStringAndWait("Let's agree never to speak of this again.", SCHAR_KAYLANI, EMOTE_SWEAT, 64, YPOS_UPPER);
			PlayStringAndWait("Agreed.", SCHAR_ASHER, EMOTE_SWEAT, 64, YPOS_UPPER);
			for(i=0; i<60; i++){
				BlackishScreenLayerSix();
				WaitNoAction();
			}
			for(i=0; i<60; i++){
				BlackScreenLayerSix();
				WaitNoAction();
			}
			ClearStatus();
			Game->Counter[CR_CHASEQUEST] = 9;
			PlayStringAndWaitBlackout("Extra rewards!", SCHAR_UNKNOWN, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWaitBlackout("Enter the password \"FALSE_LIGHT\" in Yuurand for a special prize!", SCHAR_UNKNOWN, EMOTE_NORMAL, 64, YPOS_UPPER);
			PlayStringAndWaitBlackout("Create a new Stellar Seas file with the file name \"SHIRT\" to play randomizer mode!", SCHAR_UNKNOWN, EMOTE_NORMAL, 64, YPOS_UPPER);
			if(G[G_CHASEDIFF] < 2){
				PlayStringAndWaitBlackout("The quest password is \"Piacere, Girolamo Trombetta!\"", SCHAR_UNKNOWN, EMOTE_NORMAL, 64, YPOS_UPPER);
			}
			if(G[G_CHASEREFIGHT])
				Game->End();
			else
				this->Data = CMB_AUTOWARPA;
		}
		if(scene == 25){
			WaitNoAction();
			G[G_CUTSCENEDEBUG] = 0;
			
			SetCutsceneSkip(CUTSCENE_ENDING);
			Cutscene_Init(RT_BITMAP1, RT_BITMAP2);
			cutsceneG[CG_MASKED] = 1;
			Cutscene_AnchorCamera(0x07, 0x07, 1, 1);
			Game->PlayMIDI(0);
			
			bitmap goop = Game->CreateBitmap(256, 176);
			goop->Own();
			goop->Clear(0);
			bitmap goop2 = Game->CreateBitmap(256, 176);
			goop2->Own();
			goop2->Clear(0);
			bitmap screenMask = Game->CreateBitmap(256, 176);
			screenMask->Own();
			screenMask->Clear(0);
			screenMask->DrawScreen(0, 24, 0x07, 0, 0, 0);
			S25_GoopPuddle(goop, goop2, 128, 80, 76);
			S25_GoopPuddle(goop, goop2, 80, 96, 32);
			S25_GoopPuddle(goop, goop2, 192, 88, 24);
			S25_GoopPuddle(goop, goop2, 210, 108, 12);
			S25_GoopPuddle(goop, goop2, 48, 128, 20);
			S25_GoopPuddle(goop, goop2, 135, 104, 40);
			goop->MaskedDraw(0, screenMask, 0x00, 0x00);
			goop2->MaskedDraw(0, screenMask, 0x00, 0x00);
			goop->Rectangle(0, 0, 0, 31, 175, 0x00, 1, 0, 0, 0, true, 128);
			goop->Rectangle(0, 255-31, 0, 255, 175, 0x00, 1, 0, 0, 0, true, 128);
			goop->Rectangle(0, 0, 175-31, 255, 175, 0x00, 1, 0, 0, 0, true, 128);
			goop2->Rectangle(0, 0, 0, 31, 175, 0x00, 1, 0, 0, 0, true, 128);
			goop2->Rectangle(0, 255-31, 0, 255, 175, 0x00, 1, 0, 0, 0, true, 128);
			goop2->Rectangle(0, 0, 175-31, 255, 175, 0x00, 1, 0, 0, 0, true, 128);
			
			// int ellipse[2];
			// ellipse[0] = Cutscene_NewEllipse(1, 128, 64, 60, 48, 0x0F, 1, 0, 0, 0, true, 128);
			// Cutscene_MakeImmortal(ellipse[0]);
			// ellipse[1] = Cutscene_NewEllipse(1, 128, 64, 68, 56, 0x0F, 1, 0, 0, 0, true, 64);
			// Cutscene_MakeImmortal(ellipse[1]);
			
			int goopLayer = Cutscene_NewBlit(1, goop, 0, 0, 256, 176, 0, 0, 256, 176, 0);
			Cutscene_MakeImmortal(goopLayer);
			int goopLayer2 = Cutscene_NewBlit(1, goop2, 0, 0, 256, 176, 0, 0, 256, 176, BITDX_TRANS);
			Cutscene_MakeImmortal(goopLayer2);
			
			// ellipse[0] = Cutscene_NewEllipse(1, 128, 96, 60, 24, 0x0F, 1, 0, 0, 0, true, 128);
			// Cutscene_MakeImmortal(ellipse[0]);
			// ellipse[1] = Cutscene_NewEllipse(1, 128, 96, 68, 32, 0x0F, 1, 0, 0, 0, true, 64);
			// Cutscene_MakeImmortal(ellipse[1]);
			
			int egg[1];
			egg[0] = Cutscene_NewFastTile(1, 144, 72, 117220, 11, 128);
			Cutscene_MakeImmortal(egg[0]);
			
			int selet2x2[1];
			selet2x2[0] = Cutscene_NewCombo(2, 120-8, 80, 51165, 2, 2, 11, -1, -1, 0, 0, 0, -1, 2, true, 128);
			Cutscene_MakeImmortal(selet2x2[0]);			
			
			int selet[1];
			selet[0] = Cutscene_NewNPC(2, 120, -32, 51088, 11, 128);
			Cutscene_SetFlag(selet[0], CGF_4WAY|CGF_BIGNPC);
			Cutscene_SetDir(selet[0], DIR_UP);
			Cutscene_SetNPCGraphic(selet[0], 51023, true);
			int asher[1];
			asher[0] = Cutscene_NewNPC(2, 136, 128, 51000, 6, 128);
			Cutscene_SetFlag(asher[0], CGF_4WAY|CGF_BIGNPC|CGF_BS);
			Cutscene_SetDir(asher[0], DIR_UP);
			int torrin[1];
			torrin[0] = Cutscene_NewNPC(2, 104, 128, 50952, 6, 128);
			Cutscene_SetFlag(torrin[0], CGF_4WAY|CGF_BIGNPC|CGF_BS);
			Cutscene_SetDir(torrin[0], DIR_UP);
			int kaylani[1];
			kaylani[0] = Cutscene_NewNPC(2, 120, 128, 50960, 6, 128);
			Cutscene_SetFlag(kaylani[0], CGF_4WAY|CGF_BIGNPC|CGF_BS);
			Cutscene_SetDir(kaylani[0], DIR_UP);
			
			int npcDraws[] = {selet, asher, torrin, kaylani};
			// while(true){
				// Screen->DrawInteger(7, Link->InputMouseX, Link->InputMouseY, FONT_Z3SMALL, 0x01, 0x0F, -1, -1, Link->InputMouseX, 0, 128);
				// Screen->DrawInteger(7, Link->InputMouseX, Link->InputMouseY+6, FONT_Z3SMALL, 0x01, 0x0F, -1, -1, Link->InputMouseY, 0, 128);
				// Cutscene_Waitframe();
			// }
			Cutscene_Waitframe(90);
			Cutscene_PlayString("What a pathetic man. He valued his own freedom so highly, but in the end he became a slave to his own way of thinking.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("Serves him right, doesn't it? The bastard got what was comin' for him.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_SetDrawPosition(selet[0], 120, 80);
			Cutscene_SetDrawPosition(selet2x2[0], 112, -32);
			Cutscene_SetNPCGraphic(selet[0], 51167, true);
			S25_Waitframe(goop, npcDraws, 30);
			S25_PlayString("A slave? Me? Never... I stand above all.", SCHAR_SELET, EMOTE_NORMAL, 64, YPOS_UPPER, goop, npcDraws);
			S25_PlayString("Give it up, Selet. It's over!", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER, goop, npcDraws);
			S25_PlayString("Give up? Without my ambitions, I would be no better than you rubble.", SCHAR_SELET, EMOTE_NORMAL, 64, YPOS_UPPER, goop, npcDraws);
			Cutscene_SetNPCGraphic(selet[0], 51168, true);
			S25_Waitframe(goop, npcDraws, 30);
			Cutscene_SetNPCGraphic(selet[0], 51169, true);
			int battery[1];
			int batoff = 8;
			battery[0] = Cutscene_NewFastTile(4, CutX(selet[0])-5, CutY(selet[0])-4-batoff, 65114, 11, 128);
			Cutscene_MakeImmortal(battery[0]);
			S25_PlayString("And I shall not be denied my dream by mere children.", SCHAR_SELET, EMOTE_NORMAL, 64, YPOS_UPPER, goop, npcDraws);
			S25_PlayString("Oh no you don't!", SCHAR_KAYLANI, EMOTE_ANGRY, 64, YPOS_UPPER, goop, npcDraws);
			// PlayString("Oh no you don't!", SCHAR_KAYLANI, EMOTE_ANGRY, 64, YPOS_UPPER);
			// int dat[3];
			// dat[0] = 1;
			// while(dat[0] < 2){
				// KaylaniSunballStuff(kaylani[0], dat);
				// Cutscene_Waitframe();
			// }
			// Cutscene_WaitString();
			Cutscene_Glide(kaylani[0], -1, 120, 104, 2);
			while(cutsceneG[CG_NUMGLIDING]>0){
				Cutscene_Waitframe();
			}
			Game->PlaySound(SFX_JUMP);
			Cutscene_SetNPCGraphic(kaylani[0], 51157, true);
			Cutscene_Glide(kaylani[0], -1, CutX(selet[0]), CutY(selet[0])+4, 2);
			while(cutsceneG[CG_NUMGLIDING]>0){
				Cutscene_Waitframe();
			}
			Game->PlaySound(11);
			Cutscene_RemoveDraw(battery[0]);
			Cutscene_SetNPCGraphic(selet[0], 51139, true);
			int x = CutX(selet[0]); int y = CutY(selet[0]);
			Cutscene_Glide(kaylani[0], -1, x, y-8+4, 1.5);
			Cutscene_Glide(selet[0], -1, x, y-8, 1.5);
			int jump; int rot;
			for(i=0; i<32; i+=jump){
				rot += 10;
				Cutscene_NewTile(4, x-8, y-8-batoff+i, 65114, 1, 1, 9, -1, -1, x-8, y-8-batoff+i, rot, 0, true, 128);
				jump = Min(jump+0.16, 3.2);
				Cutscene_Waitframe();
			}
			Game->PlaySound(90);
			// for(i=0; i<16; ++i){
				// lweapon l = ParticleAnim(x-8+Rand(-8, 8), y-8-batoff+32+Rand(-8, 8), 65360, 9, 8, 1);
				// l->OriginalTile += Rand(8);
				// l->Tile = l->OriginalTile;
				// Cutscene_Waitframe();
			// }
			while(cutsceneG[CG_NUMGLIDING]>0){
				Cutscene_Waitframe();
			}
			Cutscene_SetAttr(kaylani[0], CGI_X, 300);
			Cutscene_SetAttr(selet[0], CGI_X, 300);
			Game->PlaySound(147);
			bitmap blah = Game->CreateBitmap(16, 32);
			blah->Own();
			blah->ClearToColor(0, 0x00);
			blah->DrawTile(0, 0, 0, 105508, 1, 2, 6, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
			for(i=0; i<32; ++i){
				for(j=0; j<2; ++j){
					Cutscene_NewBlit(1, blah, 0, 0, 16, 32, x, y-16+i-i/2, 16, 32, 0);
					S25_GoopOverlay(goop, npcDraws);
					Cutscene_Waitframe();
				}
				blah->Line(0, 0, 32-i, 16, 32-i, 0x00, -1, 0, 0, 0, OP_OPAQUE);
				if(i == 16){
					Cutscene_Glide(asher[0], -1, 136, 80, 1.5);
					Cutscene_Glide(torrin[0], -1, 104, 80, 1.5);
					PlayString("Kaylani!", SCHAR_TORRIN, EMOTE_DISMAYED, 64, YPOS_UPPER);
				}
				if(i>16){
					if(Cutscene_FinishedGlide(asher[0])){
						Cutscene_SetDir(asher[0], DIR_LEFT);
						Cutscene_SetDir(torrin[0], DIR_RIGHT);
					}
				}
			}
			S25_Waitglide(goop, npcDraws);
			Cutscene_SetDir(asher[0], DIR_LEFT);
			Cutscene_SetDir(torrin[0], DIR_RIGHT);
			while(G[G_MSGACTIVE]){
				S25_GoopOverlay(goop, npcDraws);
				G[G_NOACTION] = 1;
				Cutscene_Waitframe2();
			}
			S25_Waitframe(goop, npcDraws, 60);
			
			
			for(int i = 0; i<60; i++){
				S25_GoopOverlay(goop, npcDraws);
				Cutscene_Update();
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				NoAction();
				BlackishScreenLayerSix();
				Waitframe();
			}
			for(int i = 0; i<120; i++){
				S25_GoopOverlay(goop, npcDraws);
				Cutscene_Update();
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				NoAction();
				BlackScreenLayerSix();
				Waitframe();
			}
			// Cutscene_SetAttr(asher[0], CGI_Y, 96);
			// Cutscene_SetAttr(torrin[0], CGI_Y, 96);
			// Cutscene_SetAttr(egg[0], CGI_X, 300);
			
			Game->PlayEnhancedMusic("SS-Cosmic.ogg", 0);
			
			int bitid = TempBitmap_Create(0, 512, 512);
			bitmap b = TempBMP[bitid];
			int bitid2 = TempBitmap_Create(0, 512, 512);
			bitmap b2 = TempBMP[bitid2];
			int bitid3 = TempBitmap_Create(0, 256, 176);
			bitmap b3 = TempBMP[bitid3];
			int bitid4 = TempBitmap_Create(0, 32, 32);
			bitmap b4 = TempBMP[bitid4];
			
			
			int starDist[128];
			int starAng[128];
			int starStep[128];
			int stars[] = {starDist, starAng, starStep};
			
			for(int i=0; i<128; ++i){
				starDist[i] = Rand(256);
				starAng[i] = Rand(360);
			}
			
			int aTimer[3];
			
			int xanch = 120;
			int yanch = 96;
			
			for(int i=0; i<60; ++i){
				aTimer[0] = (aTimer[0]+1)%360;
				b3->Clear(0);
				DrawSpaceTunnel(b3, stars);
				b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
				DrawFloatingNPC(104080, aTimer, xanch, yanch);
				Screen->Rectangle(6, 0, -56, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
				if(i<16)
					Screen->Rectangle(6, 0, -56, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
				if(i<8)
					Screen->Rectangle(6, 0, -56, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				NoAction();
				Waitframe();
			}
			PlayString("Selet? Where did you go?", SCHAR_KAYLANI, EMOTE_SURPRISED, 64, YPOS_UPPER);
			while(G[G_MSGACTIVE]){
				aTimer[0] = (aTimer[0]+1)%360;
				b3->Clear(0);
				DrawSpaceTunnel(b3, stars);
				b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
				DrawFloatingNPC(104080, aTimer, xanch, yanch);
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				G[G_NOACTION] = 1;
				Waitframe();
			}
			for(i=0; i<30; ++i){ //Look left
				aTimer[0] = (aTimer[0]+1)%360;
 				b3->Clear(0);
				DrawSpaceTunnel(b3, stars);
				b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
				DrawFloatingNPC(104084, aTimer, xanch, yanch);
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				G[G_NOACTION] = 1;
				Waitframe();
			}
			for(i=0; i<30; ++i){ //Look up
				aTimer[0] = (aTimer[0]+1)%360;
				b3->Clear(0);
				DrawSpaceTunnel(b3, stars);
				b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
				DrawFloatingNPC(104088, aTimer, xanch, yanch);
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				G[G_NOACTION] = 1;
				Waitframe();
			}
			for(i=0; i<30; ++i){ //Look right
				aTimer[0] = (aTimer[0]+1)%360;
				b3->Clear(0);
				DrawSpaceTunnel(b3, stars);
				b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
				DrawFloatingNPC(105539, aTimer, xanch, yanch);
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				G[G_NOACTION] = 1;
				Waitframe();
			}
			for(i=0; i<30; ++i){ //Look down
				aTimer[0] = (aTimer[0]+1)%360;
				b3->Clear(0);
				DrawSpaceTunnel(b3, stars);
				b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
				DrawFloatingNPC(104080, aTimer, xanch, yanch);
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				G[G_NOACTION] = 1;
				Waitframe();
			}
			PlayString("Anyone?", SCHAR_KAYLANI, EMOTE_DISMAYED, 64, YPOS_UPPER);
			while(G[G_MSGACTIVE]){
				aTimer[0] = (aTimer[0]+1)%360;
				b3->Clear(0);
				DrawSpaceTunnel(b3, stars);
				b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
				DrawFloatingNPC(104080, aTimer, xanch, yanch);
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				G[G_NOACTION] = 1;
				Waitframe();
			}
			for(j=0; j<2; j++){
				Game->PlaySound(115);
				for(i=0; i<32; ++i){
					aTimer[0] = (aTimer[0]+1)%360;
					b3->Clear(0);
					DrawSpaceTunnel(b3, stars, i%2==0);
					ZoomBlur(b, b2, b3, 32*Sin(i/32*180), true);if(i>16)
						b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
					ZoomBlur(b, b2, b3, 64*Sin(i/32*180), true);
					DrawFloatingNPC(105694, aTimer, xanch, yanch);
					Link->InputMap = false; Link->PressMap = false;
					Link->InputStart = false; Link->PressStart = false;
					G[G_NOACTION] = 1;
					Waitframe();
				}
			}
			PlayString("Ugh... who's there!?", SCHAR_KAYLANI, EMOTE_DISMAYED, 64, YPOS_UPPER);
			while(G[G_MSGACTIVE]){
				aTimer[0] = (aTimer[0]+1)%360;
				b3->Clear(0);
				DrawSpaceTunnel(b3, stars);
				b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
				DrawFloatingNPC(104080, aTimer, xanch, yanch);
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				G[G_NOACTION] = 1;
				Waitframe();
			}
			for(i=0; i<64; ++i){ //Egg appears
				aTimer[0] = (aTimer[0]+1)%360;
				DrawSpaceTunnel(b3, stars);
				b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
				DrawFloatingNPC(104088, aTimer, xanch, yanch);
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				DrawCosmicEgg(6, b4, 112, Lerp(-16, 48, i/64), Floor(Lerp(0, 3, i/64)), Floor(Lerp(0, 2, i/64)));
				NoAction();
				Waitframe();
			}
			for(i=0; i<96; ++i){ //Egg slow
				aTimer[0] = (aTimer[0]+1)%360;
				DrawSpaceTunnel(b3, stars);
				b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
				DrawFloatingNPC(104088, aTimer, xanch, yanch);
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				DrawCosmicEgg(6, b4, 112, Lerp(48, 64, i/96), 3, 2);
				NoAction();
				Waitframe();
			}
			for(i=0; i<32; ++i){ //Egg disappears
				aTimer[0] = (aTimer[0]+1)%360;
				DrawSpaceTunnel(b3, stars);
				b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
				DrawFloatingNPC(104088, aTimer, xanch, yanch);
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				DrawCosmicEgg(6, b4, 112, 64, Floor(Lerp(3, 6, i/32)), Floor(Lerp(2, 0, i/32)));
				NoAction();
				Waitframe();
			}
			PlayString("You... haven't you caused enough trouble already?", SCHAR_KAYLANI, EMOTE_ANGRY, 64, YPOS_UPPER);
			while(G[G_MSGACTIVE]){
				aTimer[0] = (aTimer[0]+1)%360;
				b3->Clear(0);
				DrawSpaceTunnel(b3, stars);
				b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
				DrawFloatingNPC(104088, aTimer, xanch, yanch);
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				G[G_NOACTION] = 1;
				Waitframe();
			}
			for(i=0; i<90; ++i){
				aTimer[0] = (aTimer[0]+1)%360;
				b3->Clear(0);
				DrawSpaceTunnel(b3, stars);
				b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
				DrawFloatingNPC(104088, aTimer, xanch, yanch);
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				G[G_NOACTION] = 1;
				Waitframe();
			}
			PlayString("I see... of course.", SCHAR_SELET, EMOTE_NORMAL, 64, YPOS_UPPER);
			while(G[G_MSGACTIVE]){
				aTimer[0] = (aTimer[0]+1)%360;
				b3->Clear(0);
				DrawSpaceTunnel(b3, stars);
				b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
				DrawFloatingNPC(104088, aTimer, xanch, yanch);
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				G[G_NOACTION] = 1;
				Waitframe();
			}
			PlayString("Selet!", SCHAR_KAYLANI, EMOTE_SURPRISED, 64, YPOS_UPPER);
			while(G[G_MSGACTIVE]){
				aTimer[0] = (aTimer[0]+1)%360;
				b3->Clear(0);
				DrawSpaceTunnel(b3, stars);
				b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
				DrawFloatingNPC(104084, aTimer, xanch, yanch);
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				G[G_NOACTION] = 1;
				Waitframe();
			}
			int push = 68;
			for(i = 0; i< push; i++){
				aTimer[0] = (aTimer[0]+1)%360;
				b3->Clear(0);
				DrawSpaceTunnel(b3, stars);
				b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
				DrawFloatingNPC(104084, aTimer, xanch+i, yanch);
				DrawFloatingNPC(109258, aTimer, -16+i, yanch);
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				G[G_NOACTION] = 1;
				Waitframe();
			}
			for(i=0; i<30; ++i){
				aTimer[0] = (aTimer[0]+1)%360;
				b3->Clear(0);
				DrawSpaceTunnel(b3, stars);
				b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
				DrawFloatingNPC(104084, aTimer, xanch+push, yanch);
				DrawFloatingNPC(109258, aTimer, -16+push, yanch);
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				G[G_NOACTION] = 1;
				Waitframe();
			}
			PlayString("It appears I owe you my gratitude after all. Despite refusing all my offers, you've handed everything I've wanted to me.", SCHAR_SELET, EMOTE_NORMAL, 64, YPOS_UPPER);
			while(G[G_MSGACTIVE]){
				aTimer[0] = (aTimer[0]+1)%360;
				b3->Clear(0);
				DrawSpaceTunnel(b3, stars);
				b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
				DrawFloatingNPC(104084, aTimer, xanch+push, yanch);
				DrawFloatingNPC(109258, aTimer, -16+push, yanch);
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				G[G_NOACTION] = 1;
				Waitframe();
			}
			PlayString("You've lost Selet! It's over! You have nothing left!", SCHAR_KAYLANI, EMOTE_ANGRY, 64, YPOS_UPPER);
			while(G[G_MSGACTIVE]){
				aTimer[0] = (aTimer[0]+1)%360;
				b3->Clear(0);
				DrawSpaceTunnel(b3, stars);
				b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
				DrawFloatingNPC(104084, aTimer, xanch+push, yanch);
				DrawFloatingNPC(109258, aTimer, -16+push, yanch);
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				G[G_NOACTION] = 1;
				Waitframe();
			}
			PlayString("You may think what you will. But I intend to depart with the knowledge the Cosmic Egg has imparted to me now.", SCHAR_SELET, EMOTE_NORMAL, 64, YPOS_UPPER);
			while(G[G_MSGACTIVE]){
				aTimer[0] = (aTimer[0]+1)%360;
				b3->Clear(0);
				DrawSpaceTunnel(b3, stars);
				b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
				DrawFloatingNPC(104084, aTimer, xanch+push, yanch);
				DrawFloatingNPC(109258, aTimer, -16+push, yanch);
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				G[G_NOACTION] = 1;
				Waitframe();
			}
			PlayString("You're not going any-", SCHAR_KAYLANI, EMOTE_ANGRY, 64, YPOS_UPPER);
			while(G[G_MSGACTIVE]){
				aTimer[0] = (aTimer[0]+1)%360;
				b3->Clear(0);
				DrawSpaceTunnel(b3, stars);
				b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
				DrawFloatingNPC(104084, aTimer, xanch+push, yanch);
				DrawFloatingNPC(109258, aTimer, -16+push, yanch);
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				G[G_NOACTION] = 1;
				Waitframe();
			}
			for(j=0; j<2; j++){
				Game->PlaySound(115);
				for(i=0; i<32; ++i){
					aTimer[0] = (aTimer[0]+1)%360;
					b3->Clear(0);
					DrawSpaceTunnel(b3, stars, i%2==0);
					ZoomBlur(b, b2, b3, 32*Sin(i/32*180), true);if(i>16)
						b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
					ZoomBlur(b, b2, b3, 64*Sin(i/32*180), true);
					DrawFloatingNPC(105454, aTimer, xanch+push, yanch);
					DrawFloatingNPC(109258, aTimer, -16+push, yanch);
					Link->InputMap = false; Link->PressMap = false;
					Link->InputStart = false; Link->PressStart = false;
					G[G_NOACTION] = 1;
					Waitframe();
				}
			}
			for(i=0; i<64; ++i){ //Egg appears
				DrawSpaceTunnel(b3, stars);
				b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
				DrawFloatingNPC(105454, aTimer, xanch+push, yanch);
				DrawFloatingNPC(109258, aTimer, -16+push, yanch);
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				DrawCosmicEgg(6, b4, Lerp(208, 176, i/64), Lerp(16, 48, i/64), Floor(Lerp(0, 3, i/64)), Floor(Lerp(0, 2, i/64)));
				NoAction();
				Waitframe();
			}
			for(i=0; i<96; ++i){ //Egg slow
				DrawSpaceTunnel(b3, stars);
				b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
				DrawFloatingNPC(104084, aTimer, xanch+push, yanch);
				DrawFloatingNPC(109258, aTimer, -16+push, yanch);
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				DrawCosmicEgg(6, b4, Lerp(176, 160, i/96), Lerp(48, 64, i/96), 3, 2);
				NoAction();
				Waitframe();
			}
			for(i=0; i<32; ++i){ //Egg disappears
				DrawSpaceTunnel(b3, stars);
				b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
				DrawFloatingNPC(105454, aTimer, xanch+push, yanch);
				DrawFloatingNPC(109258, aTimer, -16+push, yanch);
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				DrawCosmicEgg(6, b4, 160, 64, Floor(Lerp(3, 6, i/32)), Floor(Lerp(2, 0, i/32)));
				NoAction();
				Waitframe();
			}
			PlayString("Ugh... get out of my head!", SCHAR_KAYLANI, EMOTE_DISMAYED, 64, YPOS_UPPER);
			while(G[G_MSGACTIVE]){
				aTimer[0] = (aTimer[0]+1)%360;
				b3->Clear(0);
				DrawSpaceTunnel(b3, stars);
				b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
				DrawFloatingNPC(105454, aTimer, xanch+push, yanch);
				DrawFloatingNPC(109258, aTimer, -16+push, yanch);
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				G[G_NOACTION] = 1;
				Waitframe();
			}
			for(int i=60; i>0; --i){
				aTimer[0] = (aTimer[0]+1)%360;
				b3->Clear(0);
				DrawSpaceTunnel(b3, stars);
				b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
				DrawFloatingNPC(105454, aTimer, xanch+push, yanch);
				DrawFloatingNPC(109258, aTimer, -16+push, yanch);
				Screen->Rectangle(6, 0, -56, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
				if(i<16)
					Screen->Rectangle(6, 0, -56, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
				if(i<8)
					Screen->Rectangle(6, 0, -56, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				NoAction();
				Waitframe();
			}
			for(int i = 0; i<60; i++){
				S25_GoopOverlay(goop, npcDraws);
				Cutscene_Update();
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				NoAction();
				BlackScreenLayerSix();
				Waitframe();
			}
			for(int i = 0; i<60; i++){
				S25_GoopOverlay(goop, npcDraws);
				Cutscene_Update();
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				NoAction();
				BlackishScreenLayerSix();
				Waitframe();
			}
			
			S25_PlayString("Kaylani? Can you hear us?", SCHAR_ASHER, EMOTE_DISMAYED, 64, YPOS_UPPER, goop, npcDraws);
			S25_PlayString("C'mon Kaylani, where'd ya go?", SCHAR_TORRIN, EMOTE_DISMAYED, 64, YPOS_UPPER, goop, npcDraws);
			
			x = 120; y = 96;
			blah->ClearToColor(0, 0x00);
			i = Cutscene_NewTile(2, 120-4, 96, 109444, 1, 1, 11, -1, -1, 0, 0, 0, 0, true, 128);
			Cutscene_SetAttr(i, CGI_DRAWLIFESPAN, 16);
			Cutscene_SetAttr(i, CGI_MOVEANGLE, -45);
			Cutscene_SetAttr(i, CGI_MOVESTEP, 0.5);
			i = Cutscene_NewTile(2, 120-4, 96, 109444, 1, 1, 11, -1, -1, 0, 0, 0, 1, true, 128);
			Cutscene_SetAttr(i, CGI_DRAWLIFESPAN, 16);
			Cutscene_SetAttr(i, CGI_MOVEANGLE, 180+45);
			Cutscene_SetAttr(i, CGI_MOVESTEP, 0.5);
			Game->PlaySound(SFX_SPLASH);
			for(i=0; i<16; i+=2){
				S25_GoopOverlay(goop, npcDraws);
				blah->ClearToColor(0, 0x00);
				blah->DrawTile(0, 0, 0, 105523, 1, 1, 6, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
				for(k=i; k<16; ++k)
					blah->Line(0, 0, k, 16, k, 0x00, -1, 0, 0, 0, OP_OPAQUE);
				Cutscene_NewBlit(1, blah, 0, 0, 16, 32, x, y+16-i, 16, 32, 0);
				Cutscene_Waitframe();
			}
			int hand[1];
			hand[0] = Cutscene_NewFastTile(1, x, y, 105523, 6, 128);
			Cutscene_MakeImmortal(hand[0]);
			Cutscene_SetDir(asher[0], DIR_DOWN);
			S25_Waitframe(goop, npcDraws, 10);
			Cutscene_PlayString("There!", SCHAR_ASHER, EMOTE_SURPRISED, 64, YPOS_UPPER);
			Cutscene_SetDir(torrin[0], DIR_DOWN);
			Cutscene_Glide(asher[0], -1, 136, 96, 1.5);
			Cutscene_Glide(torrin[0], -1, 104, 96, 1.5);
			S25_Waitglide(goop, npcDraws);
			Cutscene_SetDir(asher[0], DIR_LEFT);
			Cutscene_SetDir(torrin[0], DIR_RIGHT);
			Cutscene_RemoveDraw(hand[0]);
			blah->ClearToColor(0, 0x00);
			blah->DrawTile(0, 0, 0, 105523, 1, 1, 6, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
			for(i=0; i<7; ++i){
				blah->Line(0, 0, 16-i, 16, 16-i, 0x00, -1, 0, 0, 0, OP_OPAQUE);
				for(j=0; j<2; ++j){
					S25_GoopOverlay(goop, npcDraws);
					Cutscene_NewBlit(1, blah, 0, 0, 16, 32, x, y+i, 16, 32, 0);
					Cutscene_Waitframe();
				}
			}
			Cutscene_SetNPCGraphic(torrin[0], 51158, true);
			Cutscene_AddAttr(torrin[0], CGI_X, 2);
			int blib = Cutscene_NewBlit(1, blah, 0, 0, 16, 32, x, y-16+13, 16, 32, 0);
			Cutscene_MakeImmortal(blib);
			Cutscene_PlayString("I've got ya!", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_AddAttr(torrin[0], CGI_X, 2);
			while(G[G_MSGACTIVE]){
				S25_GoopOverlay(goop, npcDraws);
				Cutscene_NewBlit(1, blah, 0, 0, 16, 32, x, y-16+13, 16, 32, 0);
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				G[G_NOACTION] = 1;
				Cutscene_Waitframe();
			}
			Cutscene_RemoveDraw(blib);
			y-=3;
			Game->PlaySound(147);
			for(i=0; i<12; ++i){
				blah->ClearToColor(0, 0x00);
				blah->DrawTile(0, 0, 0, 105524, 1, 1, 6, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
				for(k=i; k<16; ++k)
					blah->Line(0, 0, k, 16, k, 0x00, -1, 0, 0, 0, OP_OPAQUE);
				if(i == 4){
					Cutscene_AddAttr(torrin[0], CGI_X, -2);
					Cutscene_SetNPCGraphic(torrin[0], 51159, true);
				}
				if(i == 8){
					Cutscene_SetNPCGraphic(torrin[0], 51160, true);
				}
				for(j=0; j<6; ++j){
					S25_GoopOverlay(goop, npcDraws);
					Cutscene_NewBlit(1, blah, 0, 0, 16, 32, x, y+16-i, 16, 32, 0);
					Cutscene_Waitframe();
				}
			}
			blah->ClearToColor(0, 0x00);
			Game->PlaySound(55);
			Cutscene_SetAttr(kaylani[0], CGI_X, 120);
			Cutscene_SetAttr(kaylani[0], CGI_Y, 96);
			Cutscene_SetNPCGraphic(kaylani[0], 51029, true);
			Cutscene_SetNPCGraphic(torrin[0], 33295, true);
			Cutscene_AddAttr(torrin[0], CGI_X, -2);
			S25_Waitframe(goop, npcDraws, 30);
			Cutscene_SetNPCGraphic(kaylani[0], 51128, true);
			S25_Waitframe(goop, npcDraws, 30);
			Cutscene_SetNPCGraphic(kaylani[0], 51028, true);
			S25_Waitframe(goop, npcDraws, 15);
			Cutscene_SetNPCGraphic(kaylani[0], 33301, true);
			S25_Waitframe(goop, npcDraws, 96);
			y = 68;
			
			i = Cutscene_NewTile(2, 120, y, 109444, 1, 1, 11, -1, -1, 0, 0, 0, 0, true, 128);
			Cutscene_SetAttr(i, CGI_DRAWLIFESPAN, 16);
			Cutscene_SetAttr(i, CGI_MOVEANGLE, -45);
			Cutscene_SetAttr(i, CGI_MOVESTEP, 1);
			i = Cutscene_NewTile(2, 120, y, 109444, 1, 1, 11, -1, -1, 0, 0, 0, 0, true, 128);
			Cutscene_SetAttr(i, CGI_DRAWLIFESPAN, 16);
			Cutscene_SetAttr(i, CGI_MOVEANGLE, -60);
			Cutscene_SetAttr(i, CGI_MOVESTEP, 1);
			
			i = Cutscene_NewTile(2, 120, y, 109444, 1, 1, 11, -1, -1, 0, 0, 0, 1, true, 128);
			Cutscene_SetAttr(i, CGI_DRAWLIFESPAN, 16);
			Cutscene_SetAttr(i, CGI_MOVEANGLE, 180+45);
			Cutscene_SetAttr(i, CGI_MOVESTEP, 1);
			i = Cutscene_NewTile(2, 120, y, 109444, 1, 1, 11, -1, -1, 0, 0, 0, 1, true, 128);
			Cutscene_SetAttr(i, CGI_DRAWLIFESPAN, 16);
			Cutscene_SetAttr(i, CGI_MOVEANGLE, 180+60);
			Cutscene_SetAttr(i, CGI_MOVESTEP, 1);
			
			Game->PlaySound(71);
			for(i=0; i<32; i+=2){
				blah->ClearToColor(0, 0x00);
				blah->DrawTile(0, 0, 0, 109374, 1, 2, 6, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
				for(k=i; k<32; ++k)
					blah->Line(0, 0, k, 16, k, 0x00, -1, 0, 0, 0, OP_OPAQUE);
				// for(j=0; j<3; ++j){
				S25_GoopOverlay(goop, npcDraws);
				Cutscene_NewBlit(1, blah, 0, 0, 16, 32, x, y+16-i, 16, 32, 0);
				Cutscene_Waitframe();
				// }
			}
			blah->ClearToColor(0, 0x00);
			Cutscene_SetAttr(selet[0], CGI_X, x);
			Cutscene_SetAttr(selet[0], CGI_Y, y);
			Cutscene_SetNPCGraphic(selet[0], 51170, true);
			S25_Waitframe(goop, npcDraws, 15);
			Cutscene_SetNPCGraphic(kaylani[0], 33300, true);
			Cutscene_SetNPCGraphic(torrin[0], 33292, true);
			Cutscene_SetNPCGraphic(selet[0], 51171, true);
			Cutscene_SetDir(kaylani[0], DIR_UP);
			Cutscene_SetDir(asher[0], DIR_UP);
			Cutscene_SetDir(torrin[0], DIR_UP);
			S25_Waitframe(goop, npcDraws, 45);
			Cutscene_SetNPCGraphic(selet[0], 51172, true);
			Cutscene_Glide(selet[0], -1, x, 52, 0.5);
			S25_Waitglide(goop, npcDraws);
			Cutscene_SetNPCGraphic(selet[0], 51171, true);
			
			S25_PlayString("Farewell, Kaylani. I suspect you and I shall meet again.", SCHAR_SELET, EMOTE_SADISTIC, 64, YPOS_LOWER, goop, npcDraws);
			Cutscene_SetNPCGraphic(selet[0], 51161, true);
			S25_Waitframe(goop, npcDraws, 60);
			Cutscene_SetNPCGraphic(selet[0], 51162, true);
			S25_Waitframe(goop, npcDraws, 15);
			Cutscene_SetNPCGraphic(selet[0], 51163, true);
			S25_Waitframe(goop, npcDraws, 15);
			Cutscene_SetNPCGraphic(selet[0], 51164, true);
			S25_Waitframe(goop, npcDraws, 15);
			Cutscene_SetAttr(selet[0], CGI_LAYER, 0);
			Game->PlaySound(SFX_FALL);
			Cutscene_GlideRelative(kaylani[0], -1, 0, -24, 2);
			for(i=0; i<8; ++i){
				S25_GoopOverlay(goop, npcDraws);
				Cutscene_AddAttr(selet[0], CGI_Y, 2);
				Cutscene_Waitframe();
			}
			Cutscene_RemoveDraw(selet[0]);
			Cutscene_SetNPCGraphic(asher[0], 51000, false); //At some point the trio's combo data got corrupted and I am actually too lazy to find out where
			Cutscene_SetNPCGraphic(torrin[0], 50952, false); 
			Cutscene_SetNPCGraphic(kaylani[0], 50960, false);
			S25_PlayString("Wait! Selet!", SCHAR_KAYLANI, EMOTE_ANGRY, 64, YPOS_LOWER, goop, npcDraws);
			Cutscene_GlideRelative(torrin[0], -1, 0, -40, 1);
			Cutscene_GlideRelative(kaylani[0], -1, 0, 8, 1);
			S25_Waitglide(goop, npcDraws);
			Cutscene_SetNPCGraphic(torrin[0], 51097, true);
			S25_PlayString("Damn! He really jumped, did he? Crazy blighter...", SCHAR_TORRIN, EMOTE_SURPRISED, 64, YPOS_LOWER, goop, npcDraws);
			Cutscene_GlideRelative(asher[0], -1, 0, -8, 1);
			S25_Waitglide(goop, npcDraws);
			Cutscene_SetDir(asher[0], DIR_LEFT);
			S25_PlayString("I guess it's over then. Selet's gone, his mining base is totaled, and we've recaptured the Cosmic Egg. All's well that ends well.", SCHAR_ASHER, EMOTE_ELLIPSES, 64, YPOS_LOWER, goop, npcDraws);
			S25_PlayString("If he's actually gone...", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER, goop, npcDraws);
			Cutscene_SetDir(kaylani[0], DIR_DOWN);
			Cutscene_GlideRelative(kaylani[0], -1, 0, 8, 0.5);
			S25_Waitglide(goop, npcDraws);
			Cutscene_SetNPCGraphic(kaylani[0], 51029, true);
			Game->PlaySound(SFX_SPLASH);
			S25_Waitframe(goop, npcDraws, 8);
			Cutscene_SetNPCGraphic(torrin[0], -1, true);
			Cutscene_Glide(torrin[0], -1, CutX(kaylani[0])-16, CutY(kaylani[0]), 2);
			S25_Waitglide(goop, npcDraws);
			Cutscene_SetDir(torrin[0], DIR_RIGHT);
			S25_PlayString("Ya alright there Kay? Can't have you fallin' back in the...What even is this gunk?", SCHAR_TORRIN, EMOTE_DISMAYED, 64, YPOS_LOWER, goop, npcDraws);
			S25_Waitframe(goop, npcDraws, 30);
			Cutscene_SetNPCGraphic(kaylani[0], 51128, true);
			S25_Waitframe(goop, npcDraws, 30);
			Cutscene_SetNPCGraphic(kaylani[0], 51028, true);
			S25_Waitframe(goop, npcDraws, 15);
			Cutscene_SetNPCGraphic(kaylani[0], 33301, true);
			G[G_CUTSCENEDEBUG] = 0;
			S25_PlayString("I don't know. Inside it, I saw...", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER, goop, npcDraws);
			Cutscene_SetNPCGraphic(kaylani[0], 51173, true);
			S25_Waitframe(goop, npcDraws, 8);
			Cutscene_SetNPCGraphic(kaylani[0], 51174, true);
			b3->Clear(0);
			Game->PlaySound(115);
			for(i=0; i<32; ++i){
				aTimer[0] = (aTimer[0]+1)%360;
				DrawFloatingNPC(105694, aTimer, xanch, yanch);
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				G[G_NOACTION] = 1;
				Cutscene_Update();
				b->Clear(0);
				b2->Clear(0);
				b3->Clear(6);
				b3->BlitTo(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
				b3->MaskedDraw(6, screenMask, 0x00, 0x00); //There was some garbage drawing at the top of the screen. I tried a million different things and drawing over it was the only thing that worked
				ZoomBlur(b, b2, b3, 24*Sin(i/32*180), true);
				Waitframe();
			}
			S25_PlayString("Agh! Whatever it is, it's horrid!", SCHAR_KAYLANI, EMOTE_SAD, 64, YPOS_LOWER, goop, npcDraws);
			S25_PlayString("Will you be alright?", SCHAR_ASHER, EMOTE_DISMAYED, 64, YPOS_LOWER, goop, npcDraws);
			Cutscene_SetNPCGraphic(kaylani[0], -1, true);
			S25_PlayString("I'm fine. Just a headache. But Selet...", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER, goop, npcDraws);
			Cutscene_SetDir(kaylani[0], DIR_UP);
			Cutscene_GlideRelative(kaylani[0], -1, 0, -24, 1);
			S25_Waitglide(goop, npcDraws);
			Cutscene_SetDir(kaylani[0], DIR_RIGHT);
			Cutscene_SetDir(asher[0], DIR_UP);
			S25_PlayString("Right after he broke it, Selet mentioned the Egg being full of stars...But it's completely empty now. It just looks like a big cracked husk of stone.", SCHAR_KAYLANI, EMOTE_QUESTION, 64, YPOS_LOWER, goop, npcDraws);
			S25_PlayString("Reckon what was possessin' Selet was inside? Did we just... kill space?", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_LOWER, goop, npcDraws);
			S25_PlayString("I'm not sure. But looking at this husk makes me uneasy.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER, goop, npcDraws);
			Cutscene_SetDir(kaylani[0], DIR_DOWN);
			S25_PlayString("For now let's seal this place up again. We can talk about this again once we get home. We shouldn't linger here longer than we have to.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER, goop, npcDraws);
			Cutscene_SetDir(asher[0], DIR_DOWN);
			Cutscene_SetDir(torrin[0], DIR_DOWN);
			Cutscene_Glide(asher[0], -1, 128, 128, 0.75);
			Cutscene_Glide(torrin[0], -1, 112, 128, 0.75);
			S25_Waitglide(goop, npcDraws);
			int doorTiles = Cutscene_NewTile(2, 112, 144, 69206, 2, 2, 3, -1, -1, 0, 0, 0, 0, true, 128);
			Cutscene_MakeImmortal(doorTiles);
			int door = Cutscene_NewTile(2, 96, 144, 69380, 4, 2, 2, -1, -1, 0, 0, 0, 0, true, 128);
			Cutscene_MakeImmortal(door);
			int doorFrame = Cutscene_NewTile(4, 80, 144, 69240, 6, 2, 2, -1, -1, 0, 0, 0, 2, true, 128);
			Cutscene_MakeImmortal(doorFrame);
			Game->PlaySound(133);
			Cutscene_GlideRelative(door, -1, 0, 32, 4);
			Cutscene_Glide(kaylani[0], -1, 120, 104, 0.75);
			S25_Waitglide(goop, npcDraws);
			Cutscene_GlideRelative(asher[0], -1, 0, 64, 0.75);
			Cutscene_GlideRelative(torrin[0], -1, 0, 64, 0.75);
			S25_Waitframe(goop, npcDraws, 16);
			Cutscene_SetDir(kaylani[0], DIR_UP);
			Cutscene_GlideRelative(kaylani[0], -1, 0, -8, 0.5);
			S25_Waitglide(goop, npcDraws);
			S25_PlayString("Just what the hell are you...", SCHAR_KAYLANI, EMOTE_DISMAYED, 64, YPOS_LOWER, goop, npcDraws);
			Cutscene_SetDir(kaylani[0], DIR_DOWN);
			Cutscene_GlideRelative(kaylani[0], -1, 0, 80, 1);
			S25_Waitframe(goop, npcDraws, 30);
			for(int i = 0; i<60; i++){
				S25_GoopOverlay(goop, npcDraws);
				Cutscene_Update();
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				NoAction();
				BlackishScreenLayerSix();
				Waitframe();
			}
			for(int i = 0; i<60; i++){
				S25_GoopOverlay(goop, npcDraws);
				Cutscene_Update();
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				NoAction();
				BlackScreenLayerSix();
				Waitframe();
			}
			this->Data = CMB_AUTOWARPA;
			while(true)
				Cutscene_Waitframe();
		}
		if(scene == 26){ //It's a scene featuring Russ. Close enough.
			if(Screen->State[ST_SECRET]){
				ffc MooshNPC = FindFreeFFC();
				MooshNPC->X = 96;
				MooshNPC->Y = 64;
				MooshNPC->Script = Game->GetFFCScript("NPC");
				MooshNPC->Data = 33885;
				MooshNPC->InitD[0] = 111.1;
				ffc RussNPC = FindFreeFFC();
				RussNPC->X = 160;
				RussNPC->Y = 48;
				RussNPC->Script = Game->GetFFCScript("NPC");
				RussNPC->Data = 33937;
				RussNPC->InitD[0] = 111.2;
			}
			else{
				ffc Moosh = FFCNPC(33884, 96, 48);
				SetFFCDir(Moosh, DIR_UP, false);
				ffc Russ = FFCNPC(33936, 144, 48);
				SetFFCDir(Russ, DIR_UP, false);
				
				while(Link->Y>128){
					Waitframe();
				}
				while(!WalkLinkToPoint(120, 112)){
					Waitframe();
				}
				Link->Dir = DIR_UP;
				WaitNoAction(32);
				Game->PlayEnhancedMusic("SS-TheCreators.ogg", 0);
				
				SetFFCDir(Russ, DIR_DOWN, true);
				for(int i=0; i<8; ++i){
					++Russ->Y;
					WaitNoAction();
				}
				SetFFCDir(Russ, DIR_DOWN, false);
				PlayStringAndWait("What!? What's going on? How did THEY get here? That's impossible!", SCHAR_RUSS, EMOTE_EXCLAMATION, 64, YPOS_LOWER);
				
				SetFFCDir(Moosh, DIR_DOWN, true);
				for(int i=0; i<8; ++i){
					++Moosh->Y;
					WaitNoAction();
				}
				SetFFCDir(Moosh, DIR_DOWN, false);
				PlayStringAndWait("I suppose they beat that gauntlet? The one I didn't design to be beaten.", SCHAR_MOOSH, EMOTE_ELLIPSES, 64, YPOS_LOWER);
				
				PlayStringAndWait("But you said it wasn't possible...", SCHAR_RUSS, EMOTE_SURPRISED, 64, YPOS_LOWER);
				PlayStringAndWait("I guess I didn't make it mean enough?", SCHAR_MOOSH, EMOTE_QUESTION, 64, YPOS_LOWER);
				PlayStringAndWait("Excuse me, uh...Who are you two?", SCHAR_ASHER, EMOTE_SWEAT, 64, YPOS_UPPER);
				PlayStringAndWait("Yeah, last I knew we were jus' in a house on an island. Next thing we're whizzing through space.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
				PlayStringAndWait("Oh we're just the creators of this world.", SCHAR_MOOSH, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("You two? Pardon my skepticism but...No way.", SCHAR_KAYLANI, EMOTE_EYEBROWRAISED, 64, YPOS_UPPER);
				PlayStringAndWait("Don't let our appearances fool you. We our the sole creators this world.", SCHAR_RUSS, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Whoa! Getting some real deja vu here...", SCHAR_MOOSH, EMOTE_NORMAL, 64, YPOS_LOWER);
				SetFFCDir(Moosh, DIR_RIGHT, false);
				PlayStringAndWait("Even your typos are the same.", SCHAR_MOOSH, EMOTE_WINK, 64, YPOS_LOWER);
				SetFFCDir(Russ, DIR_LEFT, true);
				PlayStringAndWait("Dammit Moosh! You said you fixed those!", SCHAR_RUSS, EMOTE_NORMAL, 64, YPOS_LOWER);
				SetFFCDir(Moosh, DIR_RIGHT, true);
				PlayStringAndWait("Yeah, yeah. I did...For the first half of the cutscene header at least...", SCHAR_MOOSH, EMOTE_NORMAL, 64, YPOS_LOWER);
				WaitNoAction(24);
				PlayStringAndWait("I'm getting the impression we're being ignored...", SCHAR_ASHER, EMOTE_SWEAT, 64, YPOS_UPPER);
				WaitNoAction(24);
				SetFFCDir(Moosh, DIR_DOWN, false);
				SetFFCDir(Russ, DIR_DOWN, false);
				PlayStringAndWait("Oh well, the scene's gotten all screwed up now. Let's just get to the point. Yadda yadda...Ham-Feels Equilibrium...Yadda yadda...No other option...Cue fight.", SCHAR_RUSS, EMOTE_NORMAL, 64, YPOS_LOWER);
				Game->PlayEnhancedMusic("SS-FinalFinal.ogg", 0);
				WaitNoAction(64);
				SetFFCDir(Moosh, DIR_DOWN, true);
				SetFFCDir(Russ, DIR_DOWN, true);
				FFCGlide({Moosh, Russ}, {120, 120}, {48, 24}, {0.3, 0.3}, {true, true});
				WaitNoAction(64);
				FFCGlide({Russ}, {120}, {44}, {0.5}, {true});
				FFCGlide({Moosh, Russ}, {120, 120}, {48, 48-16}, {0.25, 0.5}, {true, true});
				WaitNoAction(64);
				Moosh->Data = 33893;
				Russ->Data = 33894;
				WaitNoAction(96);
				SetFFCDir(Moosh, DIR_DOWN, false);
				SetFFCDir(Russ, DIR_DOWN, false);
				Game->PlayMIDI(0);
				PlayStringAndWait("Okay yeah, this ain't it. This is just weird in human form.", SCHAR_MOOSH, EMOTE_EMBARRASSED, 64, YPOS_LOWER);
				PlayStringAndWait("Yeah, probably should've thought this through some more.", SCHAR_RUSS, EMOTE_NORMAL, 64, YPOS_LOWER);
				FFCGlide({Russ}, {120}, {44}, {1}, {true});
				FFCGlide({Moosh, Russ}, {120, 120}, {48, 24}, {0.3, 1.5}, {true, true});
				WaitNoAction(32);
				FFCGlide({Moosh, Russ}, {96, 160}, {64, 48}, {1, 1}, {true, true});
				PlayStringAndWait("Okay, so no boss fight. Moosh forgot to script one...And to turn into a bear.", SCHAR_RUSS, EMOTE_SWEAT, 64, YPOS_LOWER);
				PlayStringAndWait("Think if I pay you an excessively large bribe we can just forget this whole thing happened?", SCHAR_MOOSH, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("I don't think anybody would believe us even if you didn't.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("We don't turn down free money though.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_LOWER);
				
				ffc MooshNPC = FindFreeFFC();
				MooshNPC->X = 96;
				MooshNPC->Y = 64;
				MooshNPC->Script = Game->GetFFCScript("NPC");
				MooshNPC->Data = 33885;
				MooshNPC->InitD[0] = 111.1;
				ffc RussNPC = FindFreeFFC();
				RussNPC->X = 160;
				RussNPC->Y = 48;
				RussNPC->Script = Game->GetFFCScript("NPC");
				RussNPC->Data = 33937;
				RussNPC->InitD[0] = 111.2;
				Moosh->Y = -48;
				Russ->Y = -48;
				
				for(int i=0; i<50; ++i){
					itemsprite itm = CreateItemAt(38, MooshNPC->X, MooshNPC->Y+16);
					int angle = Angle(MooshNPC->X, MooshNPC->Y+16, Link->X, Link->Y);
					//itm->Pickup = IP_TIMEOUT;
					itm->Script = Game->GetItemSpriteScript("BounceAndAutoCollect");
					itm->InitD[0] = angle+180+Rand(-60, 60);
					//itm->InitD[1] = i*8;
					itm->MoveFlags[WPNMV_CAN_PITFALL] = false;
					Waitframes(4);
				}
				Screen->TriggerSecrets();
				Screen->State[ST_SECRET] = true;
			}
		}
		if(scene == 27){ //They just keep going. Also this one's a sidequest scene in the main story cutscene script. What's organization? Definitely not something I can do.
			if(Game->Counter[CR_STORYFLAG] >= SFLAG_GAMECLEAR && Game->Counter[CR_NIGHTMARCHERQUEST] == 7 && Game->Counter[CR_MISCSIDEQUEST] == 8 && Game->Counter[CR_HELPERQUEST] == 0){
				G[G_TIMEFROZEN] = 1;
				Cutscene_Init(RT_BITMAP1, RT_BITMAP2);
				Cutscene_AnchorCamera(0x2D, 0x4D, 1, 3);
				int playCMB;
				if(GetCharID() == CHAR_ASHER)
					playCMB = 51000;
				else if(GetCharID() == CHAR_TORRIN)
					playCMB = 50952;
				else
					playCMB = 50960;
				int plyr = Cutscene_NewNPC(2, Link->X, Link->Y + 176*2, playCMB, 6, 128);
				Cutscene_SetFlag(plyr, CGF_4WAY|CGF_BS|CGF_BIGNPC);
				Cutscene_SetDir(plyr, DIR_UP);
				Cutscene_Waitframe(30);
				Cutscene_PlayString("Yo, Asher! Over here!", SCHAR_SORENPANTS, EMOTE_NORMAL, 64, YPOS_UPPER);
				
				int soren = Cutscene_NewNPC(1, 96, 112+176, 33832, 6, OP_OPAQUE);
				Cutscene_SetFlag(soren, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(soren, DIR_DOWN);
				int terry = Cutscene_NewNPC(1, 112, 112+176, 33556, 6, OP_OPAQUE);
				Cutscene_SetFlag(terry, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(terry, DIR_DOWN);
				int siyed = Cutscene_NewNPC(1, 128, 112+176, 33764, 6, OP_OPAQUE);
				Cutscene_SetFlag(siyed, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(siyed, DIR_DOWN);
				
				Cutscene_SetCameraTarget(0, 176, 0.8);
				Cutscene_Waitcamera();
				Cutscene_Waitframe(60);
				int torrin = Cutscene_NewNPC(1, 112, 2*176, CMB_TORRIN, 6, OP_OPAQUE);
				Cutscene_SetFlag(torrin, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(torrin, DIR_UP);
				int asher = Cutscene_NewNPC(1, 96, 2*176, CMB_ASHER, 6, OP_OPAQUE);
				Cutscene_SetFlag(asher, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(asher, DIR_UP);
				int kaylani = Cutscene_NewNPC(1, 128, 2*176, CMB_KAYLANI, 6, OP_OPAQUE);
				Cutscene_SetFlag(kaylani, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(kaylani, DIR_UP);
				Cutscene_Glide(torrin, 0x3D, 112, 136, 0.8);
				Cutscene_Glide(asher, 0x3D, 96, 136, 0.8);
				Cutscene_Glide(kaylani, 0x3D, 128, 136, 0.8);
				Cutscene_Waitglide();
				Cutscene_PlayString("Terry? The 'eck are you doin' out here? I thought you an' Siyed were explorin' ruins or somethin'.", SCHAR_TORRIN, EMOTE_SURPRISED, 64, YPOS_UPPER);
				Cutscene_PlayString("And not that it's bad to see you, but what are you doing here, Soren?", SCHAR_ASHER, EMOTE_SURPRISED, 64, YPOS_UPPER);
				Cutscene_PlayString("Mate, you're not gonna believe what happened. Got a few minutes for a story?", SCHAR_SORENPANTS, EMOTE_NORMAL, 64, YPOS_UPPER);
				
				for(int i = 0; i<60; i++){
					Cutscene_Update();
					Link->InputMap = false; Link->PressMap = false;
					Link->InputStart = false; Link->PressStart = false;
					NoAction();
					BlackishScreenLayerSix();
					Waitframe();
				}
				Cutscene_RemoveDraw(torrin);
				Cutscene_RemoveDraw(asher);
				Cutscene_RemoveDraw(kaylani);
				for(int i = 0; i<120; i++){
					Cutscene_Update();
					Link->InputMap = false; Link->PressMap = false;
					Link->InputStart = false; Link->PressStart = false;
					NoAction();
					BlackScreenLayerSix();
					Waitframe();
				}
				DayNight[_DN_HOUR] = 8;
				DayNight[_DN_MINUTE] = 30;
				DayNight[_DN_SECOND] = 0;
				Game->DMapPalette[Game->GetCurDMap()] = 0x0B0;
				Cutscene_SetDrawPosition(terry, 0x3D, 112, 96);
				Cutscene_SetDrawPosition(soren, 0x3D, 96, 128);
				Cutscene_SetDrawPosition(siyed, 0x3D, 128, 128);
				Cutscene_SetDir(soren, DIR_UP);
				Cutscene_SetDir(siyed, DIR_UP);
				for(int i = 0; i<60; i++){
					Cutscene_Update();
					Link->InputMap = false; Link->PressMap = false;
					Link->InputStart = false; Link->PressStart = false;
					NoAction();
					BlackishScreenLayerSix();
					Waitframe();
				}
				
				Cutscene_Waitframe(60);
				Cutscene_PlayString("Alright, we're all here now. Can you please explain what's going on?", SCHAR_SIYED, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("I've been on the edge of my seat since you dropped by and picked me up. What's this place anyways?", SCHAR_SORENPANTS, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("It's just a little island I come to sometimes when I need to be alone an' think. I'm outta good spots on Malka that Caiman ain't found.", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("Does that mean something's on your mind?", SCHAR_SIYED, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("Yeah... I got a question for ya both. Do ya feel... I dunno, proud a' yourselves? 'ccomplished? That sorta thing?", SCHAR_TERRY, EMOTE_ELLIPSES, 64, YPOS_UPPER);
				Cutscene_Waitframe(60);
				Cutscene_PlayString("Huh. Well...", SCHAR_SORENPANTS, EMOTE_ELLIPSES, 64, YPOS_UPPER);
				Cutscene_Waitframe(120);
				if(G[G_TERRYATTEMPLE] == 1 || G[G_SORENATTEMPLE] == 1){
					Cutscene_PlayString("No... I don't. Seems like I wasn't all that much help to anyone the last few weeks. Even when you were all helping stop Esan on Kohiko, I was stuck trying to open a door.", SCHAR_SIYED, EMOTE_SAD, 64, YPOS_UPPER);
					if(G[G_TERRYATTEMPLE] == 1 && G[G_SORENATTEMPLE] == 1){
						Cutscene_PlayString("Not like I did much better. Got one good punch in on him before he knocked me down into a pit.", SCHAR_SORENPANTS, EMOTE_ELLIPSES, 64, YPOS_UPPER);
						Cutscene_PlayString("Can't say I did any more than that either.", SCHAR_TERRY, EMOTE_ELLIPSES, 64, YPOS_UPPER);
					}
					else if(G[G_SORENATTEMPLE] == 1){
						Cutscene_PlayString("Not like I did much better. Got one good punch in on him before he knocked me down into a pit.", SCHAR_SORENPANTS, EMOTE_ELLIPSES, 64, YPOS_UPPER);
						Cutscene_PlayString("You at least showed up instead a' stayin' home and worryin'.", SCHAR_TERRY, EMOTE_SAD, 64, YPOS_UPPER);
					}
					else if(G[G_TERRYATTEMPLE] == 1){
						Cutscene_PlayString("My fight with 'im ain't exactly a grand story. Decked him in the face, then he knocked me down that stupid hole...", SCHAR_TERRY, EMOTE_ELLIPSES, 64, YPOS_UPPER);
						Cutscene_PlayString("Least you did something there. Band didn't even ask me to come along. Guess he probably didn't expect anything much from a runaway...", SCHAR_SORENPANTS, EMOTE_SAD, 64, YPOS_UPPER);
					}						
				}
				else{
					Cutscene_PlayString("No... I don't. Seems like I wasn't all that much help to anyone the last few weeks. Even when everyone was helping stop Esan on Kohiko, I was stuck trying to open a door.", SCHAR_SIYED, EMOTE_SAD, 64, YPOS_UPPER);
					Cutscene_PlayString("Least you did something there. Band didn't even ask me to come along. Guess he probably didn't expect anything much from a runaway...", SCHAR_SORENPANTS, EMOTE_SAD, 64, YPOS_UPPER);
					Cutscene_PlayString("I don't even have that excuse. I just stayed home and worried.", SCHAR_TERRY, EMOTE_SAD, 64, YPOS_UPPER);
				}
				Cutscene_PlayString("Aside from that, used to be I could keep up with Asher. Stellar magic or no, I don't think I'm a match for him at much of anything anymore.", SCHAR_SORENPANTS, EMOTE_ELLIPSES, 64, YPOS_UPPER);
				Cutscene_PlayString("I know that feeling. I think I gotta admit that Torrin's not the town screw-up anymore. So what's that make me?", SCHAR_TERRY, EMOTE_ELLIPSES, 64, YPOS_UPPER);
				Cutscene_PlayString("Even before all this, I couldn't ever beat Kaylani in a sparring match unless she threw it for me. I can't imagine I'm any closer now than I was then.", SCHAR_SIYED, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_Waitframe(120);
				Cutscene_PlayString("So... what now? You brought us out here so we could feel bad about how none of us are measuring up?", SCHAR_SIYED, EMOTE_ELLIPSES, 64, YPOS_UPPER);
				Cutscene_PlayString("No, but I wanted to make sure we were on the same page first. Dunno about you, but I ain't about to sit aroun' mopin' 'bout a problem that I can fix.", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("What are you getting at?", SCHAR_SORENPANTS, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("Torrin, Asher, an' Kaylani probably saved the world, an' I don't think they're gonna be stoppin' any time soon. I think it's 'bout time we started practicin' to keep up with 'em.", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_UPPER); 
				Cutscene_PlayString("I don't see how we're supposed to do that.", SCHAR_SIYED, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("We start by kickin' that defeatist attitude to the curb. We grew up with 'em, didn't we? We've been through the same scrapes an' misadventures. If they can go from annoyin' brothers an' friends to heroes, why can't we?", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("Yeah, that's right! I'm not about to let Asher pass me up like that!", SCHAR_SORENPANTS, EMOTE_HAPPY, 64, YPOS_UPPER);
				Cutscene_PlayString("An' look at how far we've come already. Siyed, did ya see yourself explorin' old ruins like you've been doin' even a year ago? What would the younger you say if 'e saw ya now. I bet he'd be amazed.", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("I dunno if I'd go that far... but I get your point. Nothing to lose by trying, I guess.", SCHAR_SIYED, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("That's the spirit! I already took the liberty a' askin' Kaylani's grandma for some guidance an' adaptin' her exercises for non-mages. Who's ready for some practice?", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_UPPER);
				
				for(int i = 0; i<60; i++){
					Cutscene_Update();
					Link->InputMap = false; Link->PressMap = false;
					Link->InputStart = false; Link->PressStart = false;
					NoAction();
					BlackishScreenLayerSix();
					Waitframe();
				}
				for(int i = 0; i<120; i++){
					Cutscene_Update();
					Link->InputMap = false; Link->PressMap = false;
					Link->InputStart = false; Link->PressStart = false;
					NoAction();
					BlackScreenLayerSix();
					Waitframe();
				}
				DayNight[_DN_HOUR] = 17;
				DayNight[_DN_MINUTE] = 30;
				DayNight[_DN_SECOND] = 0;
				Game->DMapPalette[Game->GetCurDMap()] = 0x0B3;
				for(int i = 0; i<60; i++){
					Cutscene_Update();
					Link->InputMap = false; Link->PressMap = false;
					Link->InputStart = false; Link->PressStart = false;
					NoAction();
					BlackishScreenLayerSix();
					Waitframe();
				}
				
				Cutscene_PlayString("Alright... not bad... for a start...", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("For a start? Terry, I can't feel my sword arm anymore. And if I get knocked in the head by one more sunball...", SCHAR_SORENPANTS, EMOTE_SURPRISED, 64, YPOS_UPPER);
				Cutscene_PlayString("I concur. Let's call it a day.", SCHAR_SIYED, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("Alright, alright. Let's regroup tomorrow an-", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_UPPER);
				Game->PlayMIDI(0);
				Cutscene_Waitframe(30);
				Cutscene_PlayString("... is that a ship comin' this way?", SCHAR_TERRY, EMOTE_QUESTION, 64, YPOS_UPPER);
				Cutscene_SetDir(soren, DIR_DOWN);
				Cutscene_SetDir(siyed, DIR_DOWN);
				Cutscene_PlayString("Looks like it. And they're all wearing black. Almost looks like...", SCHAR_SORENPANTS, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_Waitframe(30);
				Cutscene_PlayString("Oh!", SCHAR_SORENPANTS, EMOTE_EXCLAMATION, 64, YPOS_UPPER);
				Cutscene_PlayString("Quick, hide over there!", SCHAR_SIYED, EMOTE_EXCLAMATION, 64, YPOS_UPPER);
				Cutscene_SetDrawPosition(terry, 0x3D, 176, 80);
				Cutscene_SetDrawPosition(soren, 0x3D, 192, 104);
				Cutscene_SetDrawPosition(siyed, 0x3D, 224, 168);
				Cutscene_SetDir(terry, DIR_LEFT);
				Cutscene_SetDir(soren, DIR_LEFT);
				Cutscene_SetDir(siyed, DIR_LEFT);
				for(int i = 0; i<120; i++){
					Cutscene_Update();
					Link->InputMap = false; Link->PressMap = false;
					Link->InputStart = false; Link->PressStart = false;
					NoAction();
					BlackScreenLayerSix();
					Waitframe();
				}
				Game->PlayEnhancedMusic("SS-Warehouse.ogg", 0);
				int bane = Cutscene_NewNPC(2, 120, 128+176, 51620, 11, 128);
				Cutscene_SetFlag(bane, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(bane, DIR_UP);
				int cultist1 = Cutscene_NewNPC(2, 120, 128+176+16, 33316, 11, 128);
				Cutscene_SetFlag(cultist1, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(cultist1, DIR_UP);
				int cultist2 = Cutscene_NewNPC(2, 120, 128+176+32, 33316, 11, 128);
				Cutscene_SetFlag(cultist2, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(cultist2, DIR_UP);
				Cutscene_Glide(bane, 0x2D, 120, 160, 0.8);
				Cutscene_Glide(cultist1, 0x2D, 120, 160+16, 0.8);
				Cutscene_Glide(cultist2, 0x2D, 120, 160+32, 0.8);
				Cutscene_SetCameraTarget(0, 32, 0.8);
				Cutscene_Waitglide();
				Cutscene_Waitcamera();
				Cutscene_PlayString("Here we are. The Astronomers's tricks won't hide our goal from us.", SCHAR_ESAN, EMOTE_NORMAL, 64, YPOS_UPPER);
				Game->PlayMIDI(0);
				Cutscene_SetAttr(bane, CGI_GFX, 51636);
				for(i=0; i<120; i++){
					Cutscene_NewCircle(4, 120+10+Rand(-2, 2), 160+5+Rand(-2, 2), Rand(3, 5)+(G[G_ANIM]%6)<4?0:4, Choose(0x83, 0x84, 0x85), 1, 0, 0, 0, true, 64);
					Cutscene_NewCircle(4, 120+10+Rand(-2, 2), 160+5+Rand(-2, 2), Rand(3, 5)+(G[G_ANIM]%6)<4?0:4+2, Choose(0x83, 0x84, 0x85), 1, 0, 0, 0, false, 64);
					Cutscene_Waitframe();
				}
				Game->PlaySound(85);
				int entrance = Cutscene_NewTile(1, 104, 88, 78797, 3, 3, 4, -1, -1, 0, 0, 0, 0, true, 128);
				Cutscene_MakeImmortal(entrance);
				int splash = Cutscene_NewAnim(2, 104, 88, 54640, 3, 3, 4, -1, -1, 0, 0, 0, 0, true, 128, 9, 2);
				for(i = 0; i<4; i++){
					Cutscene_Waitframe(3);
					Cutscene_AddAttr(entrance, CGI_GFX, -3);
					
				}
				Cutscene_Waitframe(60);
				Cutscene_SetAttr(bane, CGI_GFX, 51621);
				Cutscene_Waitframe(30);
				
				Cutscene_PlayString("Listen, men! Lord Igorevich lives, and it is our responsibility to find him. The Astral Compass hidden below will allow us to locate his position. We cannot fail at this task! Fan out and find it!", SCHAR_ESAN, EMOTE_NORMAL, 64, YPOS_UPPER);
				for(int i = 0; i<60; i++){
					Cutscene_Update();
					Link->InputMap = false; Link->PressMap = false;
					Link->InputStart = false; Link->PressStart = false;
					NoAction();
					BlackishScreenLayerSix();
					Waitframe();
				}
				Cutscene_RemoveDraw(bane);
				Cutscene_RemoveDraw(cultist1);
				Cutscene_RemoveDraw(cultist2);
				Cutscene_SetDrawPosition(terry, 0x2D, 120, 160);
				Cutscene_SetDrawPosition(soren, 0x2D, 104, 160);
				Cutscene_SetDrawPosition(siyed, 0x2D, 136, 160);
				Cutscene_SetDir(terry, DIR_UP);
				Cutscene_SetDir(soren, DIR_UP);
				Cutscene_SetDir(siyed, DIR_UP);
				cutsceneG[CG_CAMX] = 0;
				cutsceneG[CG_CAMY] = 0;
				for(int i = 0; i<120; i++){
					Cutscene_Update();
					Link->InputMap = false; Link->PressMap = false;
					Link->InputStart = false; Link->PressStart = false;
					NoAction();
					BlackScreenLayerSix();
					Waitframe();
				}
				Cutscene_PlayString("Well that ain't good.", SCHAR_TERRY, EMOTE_ELLIPSES, 64, YPOS_UPPER);
				Cutscene_PlayString("We need to get to Hoku and warn-", SCHAR_SIYED, EMOTE_SAD, 64, YPOS_UPPER);
				Cutscene_PlayString("No time! They'll have their compass and be gone by the time we're back. We gotta stop them ourselves!", SCHAR_SORENPANTS, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("He's right. Ain't got a choice.", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("... Agh, you're right. I don't favor our odds though.", SCHAR_SIYED, EMOTE_SAD, 64, YPOS_UPPER);
				Cutscene_PlayString("No time to worry 'bout that. Let's go!", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_UPPER);
				SidePartySwap(true);
				G[G_TIMEFROZEN] = 0;
				Game->Counter[CR_HELPERQUEST] = 1;
				this->Data = CMB_AUTOWARPD;
			}
		}
		if(scene == 28){
			if(G[G_RANDOMIZERENABLED]){
				Waitframe();
				if(!Screen->State[ST_BOSSLOCKBLOCK]){
					npc esan = CreateNPCAt(242, 120, 32);
					while(Link->Y>128){
						NoAction();
						Link->InputUp = true;
						Waitframe();
					}
					mapdata l1 = Game->LoadTempScreen(1);
					l1->ComboD[ComboAt(112, 144)] = 1;
					l1->ComboD[ComboAt(128, 144)] = 1;
					while(esan->isValid()){
						Waitframe();
					}
					Game->PlayMIDI(0);
					Screen->State[ST_BOSSLOCKBLOCK] = true;
					l1->ComboD[ComboAt(112, 144)] = 0;
					l1->ComboD[ComboAt(128, 144)] = 0;
				}
				Quit();
			}
			if(Game->Counter[CR_HELPERQUEST] < 2){
				ffc Esan = FindFreeFFC();
				Esan->Data = 51620+DIR_UP;
				Esan->TileHeight = 2;
				Esan->X = 120;
				Esan->Y = 32;
				ffc itm = FindFreeFFC();
				itm->Data = 40847;
				itm->CSet = 7;
				itm->X = 120;
				itm->Y = 32;
				WaitNoAction(15);
				while(Link->Y>128){
					NoAction();
					Link->InputUp = true;
					Waitframe();
				}
				Link->Action = LA_ATTACKING;
				WaitNoAction();
				Link->Action = LA_NONE;
				WaitNoAction(60);
				
				PlayStringAndWait("Finally, the Astral Compass. Lord Igorevich... I may not understand your reasons for vanishing, but I promise, I will find you.", SCHAR_ESAN, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("Where d'ya think you're goin' with that?", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_UPPER);
				Esan->Data = 51620+DIR_DOWN;
				WaitNoAction(60);
				PlayStringAndWait("Is it my lot in life to be hounded by children wherever I go? Of all the nuisances...", SCHAR_ESAN, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("We'll show you nuisances if you don't back away from that compass right now!", SCHAR_SORENPANTS, EMOTE_ANGRY, 64, YPOS_UPPER);
				if(G[G_SORENATTEMPLE] == 1){
					PlayStringAndWait("I recognize you, don't I? I believe I tossed you into a pit before. It would have been better if you'd stayed there.", SCHAR_ESAN, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("Why you...", SCHAR_SORENPANTS, EMOTE_ANGRY, 64, YPOS_UPPER);
				}
				else if(G[G_TERRYATTEMPLE] == 1){
					PlayStringAndWait("Bold words for one entering this conflict at such a late stage. And yet... Girl, I recognize you, don't I? I believe I tossed you into a pit before. It would have been better if you'd stayed there.", SCHAR_ESAN, EMOTE_NORMAL, 64, YPOS_LOWER);
					PlayStringAndWait("Grr...", SCHAR_TERRY, EMOTE_ANGRY, 64, YPOS_UPPER);
				}
				else
					PlayStringAndWait("Forgive me for not feeling intimidated.", SCHAR_ESAN, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("And is that an astronomer with you? I recall seeing you approach the temple with the others, yet you weren't inside with them, nor do I recall fighting you off on the roof. Why is that? Could it be you knew you would only hinder your allies?", SCHAR_ESAN, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("I'll have ya know he's-", SCHAR_TERRY, EMOTE_ANGRY, 64, YPOS_UPPER);
				PlayStringAndWait("That's enough!", SCHAR_SIYED, EMOTE_ANGRY, 64, YPOS_UPPER);
				PlayStringAndWait("Siyed?", SCHAR_TERRY, EMOTE_SURPRISED, 64, YPOS_UPPER);
				PlayStringAndWait("I appreciate it... but I can stand up for myself. You're right, Esan. I stayed behind because I was afraid I'd only slow everyone else down. But I'm tired of hanging back and feeling useless.", SCHAR_SIYED, EMOTE_NORMAL, 64, YPOS_UPPER);
				PlayStringAndWait("And so you've picked now of all times to find self-confidence and prove a point to yourself? I have to commend your bravery, and yet scoff at your foolishness. You're just like all the other Astronomers. This world does not revolve around you, and ill-placed sentiment will offer you no protection.", SCHAR_ESAN, EMOTE_NORMAL, 64, YPOS_LOWER);
				if(G[G_TERRYATTEMPLE] == 1)
					PlayStringAndWait("I've 'ad just about enough a' your prattlin'. An' I still owe ya payback for knockin' me down a hole.", SCHAR_TERRY, EMOTE_ANGRY, 64, YPOS_UPPER);
				else
					PlayStringAndWait("I've 'ad just about enough a' your prattlin'.", SCHAR_TERRY, EMOTE_ANGRY, 64, YPOS_UPPER);
				PlayStringAndWait("Agreed. That pompous attitude's driving me crazy. It's time someone put you in your place.", SCHAR_SORENPANTS, EMOTE_ANGRY, 64, YPOS_UPPER);
				Esan->Data = 33876;
				WaitNoAction(30);
				PlayStringAndWait("Very well. I'll gladly show the three of you the foolishness of your actions.", SCHAR_ESAN, EMOTE_NORMAL, 64, YPOS_LOWER);
				Game->Counter[CR_HELPERQUEST] = 2;
				ClearFFC(Esan);
				ClearFFC(itm);
			}
			if(Game->Counter[CR_HELPERQUEST] == 2){
				ffc Esany = FindFreeFFC();
				Esany->Data = 33876;
				Esany->TileHeight = 2;
				Esany->X = 120;
				Esany->Y = 32;
				WaitNoAction(15);
				while(Link->Y>128){
					NoAction();
					Link->InputUp = true;
					Waitframe();
				}
				ClearFFC(Esany);
				CreateNPCAt(242, 120, 32);
				mapdata l1 = Game->LoadTempScreen(1);
				l1->ComboD[ComboAt(112, 144)] = 1;
				l1->ComboD[ComboAt(128, 144)] = 1;
				Waitframes(10);
				while(Screen->NumNPCs()>0){
					Waitframe();
				}
				Link->Invisible = true;
				Game->PlayMIDI(0);
				for(i = 0; i<60; i++){
					BlackScreenLayerSix();
					WaitNoAction();
				}
				ffc Soren = FFCNPC(33832, 144, 32);
				ffc Terry = FFCNPC(33556, 144, 16);
				ffc Siyed = FFCNPC(33764, 96, 24);
				SetFFCDir(Soren, DIR_LEFT, false);
				SetFFCDir(Terry, DIR_LEFT, false);
				SetFFCDir(Siyed, DIR_RIGHT, false);
				ffc Esan = FindFreeFFC();
				Esan->TileWidth = 2;
				Esan->TileHeight = 2;
				Esan->Data = 33895;
				Esan->X = 112;
				Esan->Y = 32;
				WaitNoAction(60);
				PlayStringAndWait("Holy stars... we actually did it!", SCHAR_SIYED, EMOTE_SURPRISED, 64, YPOS_LOWER);
				PlayStringAndWait("Huh? You're surprised? What happened to all that confidence.", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("That was sort of just for show...", SCHAR_SIYED, EMOTE_EMBARRASSED, 64, YPOS_LOWER);
				PlayStringAndWait("Could of fooled me. And him too, apparently. Felt good knocking some sense into him. I imagine he'll wake up with one hell of a headache.", SCHAR_SORENPANTS, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("And behind bars.", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_LOWER);
				PlayStringAndWait("You two stay and watch him. I'll grab the rest of the astronomers.", SCHAR_SIYED, EMOTE_NORMAL, 64, YPOS_LOWER);
				for(i = 0; i<60; i++){
					BlackScreenLayerSix();
					WaitNoAction();
				}
				ClearFFC(Soren);
				ClearFFC(Terry);
				ClearFFC(Siyed);
				ClearFFC(Esan);
				Link->Invisible = false;
				Cutscene_Init(RT_BITMAP1, RT_BITMAP2);
				cutsceneG[CG_BGMAP] = 42;
				Game->PlayEnhancedMusic("SS-PeacefulIsles.ogg", 0);
				DayNight[_DN_HOUR] = 18;
				DayNight[_DN_MINUTE] = 30;
				DayNight[_DN_SECOND] = 0;
				Game->DMapPalette[Game->GetCurDMap()] = 0x0B5;
				Cutscene_AnchorCamera(0x3D, 0x3D, 1, 1);
				
				int winno = Cutscene_NewNPC(1, 112, 104, CMB_WINNO, 6, OP_OPAQUE);
				Cutscene_SetFlag(winno, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(winno, DIR_DOWN);
				int soren = Cutscene_NewNPC(1, 96, 128, 33832, 6, OP_OPAQUE);
				Cutscene_SetFlag(soren, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(soren, DIR_UP);
				int terry = Cutscene_NewNPC(1, 112, 128, 33556, 6, OP_OPAQUE);
				Cutscene_SetFlag(terry, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(terry, DIR_UP);
				int siyed = Cutscene_NewNPC(1, 128, 128, 33764, 6, OP_OPAQUE);
				Cutscene_SetFlag(siyed, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(siyed, DIR_UP);
				for(int i = 0; i<60; i++){
					Cutscene_Update();
					Link->InputMap = false; Link->PressMap = false;
					Link->InputStart = false; Link->PressStart = false;
					NoAction();
					BlackishScreenLayerSix();
					Waitframe();
				}
				Cutscene_Waitframe(60);
				Cutscene_PlayString("To think these ruins were hidden below our noses this entire time... Clearly, we need to do a more thorough search through our oldest records and make a proper inventory of ancient Astronomer sites. Siyed, I trust you'll be interested in such a project.", SCHAR_WINNO, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("O-of course!", SCHAR_SIYED, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("Excellent. Now then, I owe thanks to all of you. Not only have you stopped Igorevich's men from plundering an ancient artifact, but you've also delivered his highest ranking members to us. Perhaps we can learn something useful from them.", SCHAR_WINNO, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("An' that compass? Reckon that'll help ya find Selet?", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("If he is indeed alive, and I have serious doubts... perhaps.", SCHAR_WINNO, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_Waitframe(60);
				Cutscene_PlayString("Now then.", SCHAR_WINNO, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_Glide(winno, 0x3D, 112, 112, 0.5);
				Cutscene_Waitglide();
				Cutscene_PlayString("Terry, you showed excellent leadership skills, both in organizing training here and in responding rapidly to the threat. While you have the same penchant for trouble as your brother, you also temper it with wisdom. I sense in you the makings of an excellent leader. If you ever wish to discuss the mantle of responsibility with me, my door is always open to you.", SCHAR_WINNO, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("Thanks.", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_SetDir(winno, DIR_LEFT);
				Cutscene_Glide(winno, 0x3D, 96, 112, 0.5);
				Cutscene_Waitglide();
				Cutscene_SetDir(winno, DIR_DOWN);
				Cutscene_PlayString("Soren, quick and rash actions often lead to destruction. Despite that, you've been able to channel those tendencies to protect those around you and help bring down a dangerous man on two occasions now. While I must caution you to exercise restraint, I must also commend your decisive actions. If you wish to employ your strengths for the betterment of our world, or to learn discipline, or simply to relax, Hoku Village is always open to you as well.", SCHAR_WINNO, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("Thank you.", SCHAR_SORENPANTS, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_SetDir(winno, DIR_RIGHT);
				Cutscene_Glide(winno, 0x3D, 128, 112, 0.5);
				Cutscene_Waitglide();
				Cutscene_SetDir(winno, DIR_DOWN);
				Cutscene_PlayString("Siyed, I've been trying to teach you to rely on your strengths for years, and yet a single afternoon seems to have done you more good than years of tutelage. I'm impressed by your quick actions, happy but not surprised by your ability to turn knowledge of ancient architecture into an asset, and incredibly pleased to hear how well you fared in combat. You've grown a great deal. I know you like to compare yourself unfavorably to Kaylani, but I want you to know that I consider you just as talented an Astronomer as she.", SCHAR_WINNO, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("Thank you... it means a lot.", SCHAR_SIYED, EMOTE_EMBARRASSED, 64, YPOS_UPPER);
				Cutscene_SetDir(winno, DIR_UP);
				Cutscene_Glide(winno, 0x3D, 112, 104, 0.5);
				Cutscene_Waitglide();
				Cutscene_SetDir(winno, DIR_DOWN);
				Cutscene_PlayString("I'll oversee Esan's interrogation. If we learn anything useful, I'll be sure to let you all know. Once again, thank you.", SCHAR_WINNO, EMOTE_NORMAL, 64, YPOS_UPPER);
				for(int i = 0; i<60; i++){
					Cutscene_Update();
					Link->InputMap = false; Link->PressMap = false;
					Link->InputStart = false; Link->PressStart = false;
					NoAction();
					BlackishScreenLayerSix();
					Waitframe();
				}
				DayNight[_DN_HOUR] = 12;
				DayNight[_DN_MINUTE] = 0;
				DayNight[_DN_SECOND] = 0;
				Game->DMapPalette[Game->GetCurDMap()] = 0x0B0;
				
				Cutscene_RemoveDraw(winno);
				Cutscene_SetDrawPosition(terry, 0x3D, 112, 112);
				Cutscene_SetDrawPosition(soren, 0x3D, 96, 112);
				Cutscene_SetDrawPosition(siyed, 0x3D, 128, 112);
				Cutscene_SetDir(terry, DIR_DOWN);
				Cutscene_SetDir(soren, DIR_DOWN);
				Cutscene_SetDir(siyed, DIR_DOWN);
				int torrin = Cutscene_NewNPC(1, 112, 136, CMB_TORRIN, 6, OP_OPAQUE);
				Cutscene_SetFlag(torrin, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(torrin, DIR_UP);
				int asher = Cutscene_NewNPC(1, 96, 136, CMB_ASHER, 6, OP_OPAQUE);
				Cutscene_SetFlag(asher, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(asher, DIR_UP);
				int kaylani = Cutscene_NewNPC(1, 128, 136, CMB_KAYLANI, 6, OP_OPAQUE);
				Cutscene_SetFlag(kaylani, CGF_4WAY|CGF_BIGNPC);
				Cutscene_SetDir(kaylani, DIR_UP);
				for(int i = 0; i<60; i++){
					Cutscene_Update();
					Link->InputMap = false; Link->PressMap = false;
					Link->InputStart = false; Link->PressStart = false;
					NoAction();
					BlackScreenLayerSix();
					Waitframe();
				}
				for(int i = 0; i<60; i++){
					Cutscene_Update();
					Link->InputMap = false; Link->PressMap = false;
					Link->InputStart = false; Link->PressStart = false;
					NoAction();
					BlackishScreenLayerSix();
					Waitframe();
				}
				Cutscene_Waitframe(30);
				Cutscene_PlayString("Well dang, the three of you are heroes now!", SCHAR_TORRIN, EMOTE_HAPPY, 64, YPOS_UPPER);
				Cutscene_PlayString("I don't know if I'd go THAT far.", SCHAR_SIYED, EMOTE_EMBARRASSED, 64, YPOS_UPPER);
				Cutscene_PlayString("You absolutely should! Dang right we're heroes!", SCHAR_SORENPANTS, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("I'm impressed, but not surprised.", SCHAR_KAYLANI, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("Oh, almost forgot t'mention. We grabbed a few artifacts down there that oughta do somethin' for you if ya give 'em to that totem. Tried to use 'em myself, but it gave me some nonsense 'bout not bein' the intended recipient a' power or somethin'. I hope you're enjoyin' bein' special, Torrin.", SCHAR_TERRY, EMOTE_NORMAL, 64, YPOS_UPPER);
				Cutscene_PlayString("Oh you know it.", SCHAR_TORRIN, EMOTE_WINK, 64, YPOS_UPPER);
				for(int i = 0; i<60; i++){
					Cutscene_Update();
					Link->InputMap = false; Link->PressMap = false;
					Link->InputStart = false; Link->PressStart = false;
					NoAction();
					BlackScreenLayerSix();
					Waitframe();
				}
				Game->DMapPalette[Game->GetCurDMap()] = 0x081;
				Game->Counter[CR_HELPERQUEST] = 3;
				SidePartySwap(false);
				this->Data = CMB_AUTOWARPA;
			}
		}
	}
	void EarDragDraws(int j){
		Screen->DrawScreen(5, 2, 0x3C, 0, 0, 0);
		Screen->DrawTile(5, 112, 96, 108684, 1, 2, 0, -1, -1, 0, 0, 0, 1, true, OP_OPAQUE); //Asher
		Screen->FastTile(5, 112, 92, 66285, 0, OP_OPAQUE); //Sad emote
		Screen->DrawTile(5, 128, 96, 108584, 1, 2, 0, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE); //Asher's Mom
		Screen->FastTile(5, 128, 88, 66284, 0, OP_OPAQUE); //Angry emote
		Screen->DrawTile(5, 16+j, 128, 110720, 1, 2, 0, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE); //Torrin
		Screen->FastTile(5, 16+j-7, 116, 66285, 0, OP_OPAQUE); //Sad emote
		Screen->DrawCombo(5, 16+9+j, 112, 50991, 1, 2, 0, -1, -1, 0, 0, 0, 0, 0, true, OP_OPAQUE); //Torrin's Mom
		Screen->FastTile(5, 16+9+j, 104, 66284, 0, OP_OPAQUE); //Angry emote
	}
	void DrawBigShot(int layer, int x, int y, int rad, int damage, int dir, int i, int flash){
		int r = rad+2*Sin(i);
		int clr[3] = {0x88, 0x86, 0x81};
		if(flash==0){
			clr[0] = 0x88;
			clr[1] = 0x87;
			clr[2] = 0x86;
		}
		if(flash==2){
			clr[0] = 0x86;
			clr[1] = 0x81;
			clr[2] = 0x81;
		}
		Screen->Circle(layer, x, y, rad+2*Sin(i), clr[0], 1, 0, 0, 0, true, 128);
		Screen->Circle(layer, x, y, rad*0.875+2*Sin(i), clr[1], 1, 0, 0, 0, true, 128);
		Screen->Circle(layer, x, y, rad*0.625+2*Sin(i), clr[2], 1, 0, 0, 0, true, 128);
		if(damage){
			lweapon l = MakeHitboxLW(LW_SOLAR, x-r*0.7071, y-r*0.7071, r*2*0.7071, r*2*0.7071, damage, dir);
		}
		lweapon glow = CreateLWeaponAt(LW_BAIT, x-8, y-8);
		glow->MoveFlags[WPNMV_CAN_PITFALL] = false;
		glow->DrawYOffset = -1000;
		glow->Script = LWS_ONEFRAME;
		glow->CollDetection = false;
	}
	void PlayStringAndWaitAwning(int string, int whichChar, int emote, int x, int y){
		PlayString(string, whichChar, emote, x, y);
		while(G[G_MSGACTIVE]){
			G[G_NOACTION] = 1;
			Screen->DrawScreen(5, 2, 0x49, 0, 0, 0);
			Waitframe();
		}
	}
	void PlayStringAndWaitAwning2(int string, int whichChar, int emote, int x, int y){
		PlayString(string, whichChar, emote, x, y);
		while(G[G_MSGACTIVE]){
			G[G_NOACTION] = 1;
			Screen->DrawScreen(5, 2, 0x49, 0, 0, 0);
			Screen->DrawTile(5, 0, 0, 78521, 3, 10, 4, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
			Screen->DrawTile(5, 0, 32, 78565, 3, 6, 4, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
			Waitframe();
		}
	}
	void PlayStringAndWaitCage(int string, int whichChar, int emote, int x, int y, int rad, int bmc){
		PlayString(string, whichChar, emote, x, y);
		while(G[G_MSGACTIVE]){
			G[G_NOACTION] = 1;
			DrawBloodMoonCage(1, 4, 120, 80, rad, bmc);
			Waitframe();
		}
	}
	void DrawBloodMoonCage(int state, int layer, int cx, int cy, int rad, int bmc){
		//bmc[0] = Anim timer
		//bmc[1] = Particle count
		//bmc[2] = Base angle
		int bmcX = bmc[3];
		int bmcY = bmc[4];
		int bmcF = bmc[5];
		int bmcT = bmc[6];
		
		++bmc[0];
		bmc[0] %= 360;
		bmc[2] = WrapDegrees(bmc[2]+4);
		
		int angSlice = 360/bmc[1];
		if(state==1&&bmc[0]%4<2)
			Screen->Circle(layer, cx+7, cy+7, rad, Choose(0x0E, 0x83, 0x84), 1, 0, 0, 0, true, 64);
		
		for(int i=0; i<bmc[1]; ++i){
			int x = cx+VectorX(rad, bmc[2]+angSlice*i);
			int y = cy+VectorY(rad, bmc[2]+angSlice*i);
			if(bmcF[i]>-1){
				if(state==0){
					int c = Choose(0x0E, 0x83, 0x84);
					int c2 = Choose(0x0E, 0x83, 0x84);
					Screen->PutPixel(layer, x+bmcX[i]+7, y+bmcY[i]+7, c, 0, 0, 0, 128);
					Screen->PutPixel(layer, x+bmcX[i]+7, y+bmcY[i]+7-1, c2, 0, 0, 0, 128);
					Screen->PutPixel(layer, x+bmcX[i]+7, y+bmcY[i]+7+1, c2, 0, 0, 0, 128);
					Screen->PutPixel(layer, x+bmcX[i]+7-1, y+bmcY[i]+7, c2, 0, 0, 0, 128);
					Screen->PutPixel(layer, x+bmcX[i]+7+1, y+bmcY[i]+7, c2, 0, 0, 0, 128);
				
				}
				else{
					if((bmcF[i]<8||bmcF[i]%4<2)&&bmcF[i]<16)
						Screen->FastTile(layer, x+bmcX[i], y+bmcY[i], bmcT[i]+Floor((bmcF[i]%8)/2), 8, 128);
				}
			}
			++bmcF[i];
			if(bmcF[i]>=8){
				if(state<2)
					bmcF[i] = 0;
			}
			if(bmcF[i]==0){
				bmcX[i] = Rand(-3, 3);
				bmcY[i] = Rand(-3, 3);
				bmcT[i] = Choose(54600, 54620);
			}
		}
	}
	void Cutscene_DrawBloodMoonCage(int state, int layer, int cx, int cy, int rad, int bmc){
		//bmc[0] = Anim timer
		//bmc[1] = Particle count
		//bmc[2] = Base angle
		int bmcX = bmc[3];
		int bmcY = bmc[4];
		int bmcF = bmc[5];
		int bmcT = bmc[6];
		
		++bmc[0];
		bmc[0] %= 360;
		bmc[2] = WrapDegrees(bmc[2]+4);
		
		int angSlice = 360/bmc[1];
		if(state==1&&bmc[0]%4<2)
			Cutscene_NewCircle(layer, cx+7, cy+7, rad, Choose(0x0E, 0x83, 0x84), 1, 0, 0, 0, true, 64);
		
		for(int i=0; i<bmc[1]; ++i){
			int x = cx+VectorX(rad, bmc[2]+angSlice*i);
			int y = cy+VectorY(rad, bmc[2]+angSlice*i);
			if(bmcF[i]>-1){
				if(state==0){
					int c = Choose(0x0E, 0x83, 0x84);
					int c2 = Choose(0x0E, 0x83, 0x84);
					Cutscene_NewPixel(layer, x+bmcX[i]+7, y+bmcY[i]+7, c, 0, 0, 0, 128);
					Cutscene_NewPixel(layer, x+bmcX[i]+7, y+bmcY[i]+7-1, c2, 0, 0, 0, 128);
					Cutscene_NewPixel(layer, x+bmcX[i]+7, y+bmcY[i]+7+1, c2, 0, 0, 0, 128);
					Cutscene_NewPixel(layer, x+bmcX[i]+7-1, y+bmcY[i]+7, c2, 0, 0, 0, 128);
					Cutscene_NewPixel(layer, x+bmcX[i]+7+1, y+bmcY[i]+7, c2, 0, 0, 0, 128);
				
				}
				else{
					if((bmcF[i]<8||bmcF[i]%4<2)&&bmcF[i]<16)
						Cutscene_NewFastTile(layer, x+bmcX[i], y+bmcY[i], bmcT[i]+Floor((bmcF[i]%8)/2), 8, 128);
				}
			}
			++bmcF[i];
			if(bmcF[i]>=8){
				if(state<2)
					bmcF[i] = 0;
			}
			if(bmcF[i]==0){
				bmcX[i] = Rand(-3, 3);
				bmcY[i] = Rand(-3, 3);
				bmcT[i] = Choose(54600, 54620);
			}
		}
	}
	void DrawCosmicEgg(int layer, bitmap b, int x, int y, int state, int op){
		const int TIL_COSMICEGG = 64001;
		b->Clear(0);
		b->DrawCombo(0, 0, 0, TIL_COSMICEGG, 2, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 128);
		switch(state){
			case 0: //Black
				b->DrawCombo(0, 0, 0, TIL_COSMICEGG+2, 2, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 128);
				break;
			case 1: //2x dark
				b->DrawCombo(0, 0, 0, TIL_COSMICEGG+2, 2, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 64);
				b->DrawCombo(0, 0, 0, TIL_COSMICEGG+2, 2, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 64);
				break;
			case 2: //1x dark
				b->DrawCombo(0, 0, 0, TIL_COSMICEGG+2, 2, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 64);
				break;
			case 4: //1x light
				b->DrawCombo(0, 0, 0, TIL_COSMICEGG+1, 2, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 64);
				break;
			case 5: //2x light
				b->DrawCombo(0, 0, 0, TIL_COSMICEGG+1, 2, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 64);
				b->DrawCombo(0, 0, 0, TIL_COSMICEGG+1, 2, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 64);
				break;
			case 6: //White
				b->DrawCombo(0, 0, 0, TIL_COSMICEGG+1, 2, 2, 0, -1, -1, 0, 0, 0, -1, 0, true, 128);
				break;	
		}
		switch(op){
			case 2:
				b->Blit(layer, RT_SCREEN, 0, 0, 32, 32, x, y, 32, 32, 0, 0, 0, 0, 0, true);
				break;
			case 1:
				b->Blit(layer, RT_SCREEN, 0, 0, 32, 32, x, y, 32, 32, 0, 0, 0, BITDX_TRANS, 0, true);
				b->Blit(layer, RT_SCREEN, 0, 0, 32, 32, x, y, 32, 32, 0, 0, 0, BITDX_TRANS, 0, true);
				break;
			case 0:
				b->Blit(layer, RT_SCREEN, 0, 0, 32, 32, x, y, 32, 32, 0, 0, 0, BITDX_TRANS, 0, true);
				break;
		}
	}
	void DrawFloatingNPC(int Tile, int aTimer, int x, int y){
		Screen->DrawTile(6, x, y-4*Sin(aTimer[0]), Tile, 1, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
	}
	void ZoomBlur(bitmap b, bitmap b2, bitmap b3, int extend, bool secondBitmap){
		if(secondBitmap){
			b->BlitTo(0, b3, 0, 0, 256, 176, 128-extend/2, 128-extend/2, 256+extend, 176+extend, 0, 0, 0, 0, 0, false);
			b2->BlitTo(0, b3, 0, 0, 256, 176, 128-extend, 128-extend, 256+extend*2, 176+extend*2, 0, 0, 0, 0, 0, false);
			b->Blit(6, RT_SCREEN, 128, 128, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_TRANS, 0, false);
			b2->Blit(6, RT_SCREEN, 128, 128, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_TRANS, 0, false);
		}
		else{
			b->BlitTo(0, RT_BITMAP2, 0, 0, 256, 176, 128-extend/2, 128-extend/2, 256+extend, 176+extend, 0, 0, 0, 0, 0, false);
			b2->BlitTo(0, RT_BITMAP2, 0, 0, 256, 176, 128-extend, 128-extend, 256+extend*2, 176+extend*2, 0, 0, 0, 0, 0, false);
			b->Blit(6, RT_SCREEN, 128, 128, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_TRANS, 0, false);
			b2->Blit(6, RT_SCREEN, 128, 128, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_TRANS, 0, false);
		}
	}
	void S19_DrawReq(int req){
		int til;
		if(G[G_RANDOMIZEROBSERVATORYLOCK]==1){
			req[0] = 0;
			req[1] = 0;
			
			if(G[G_ASHERINSEED])
				++req[1];
			if(G[G_TORRININSEED])
				++req[1];
			if(G[G_KAYLANIINSEED])
				++req[1];
			if(G[G_SORENINSEED])
				++req[1];
			if(G[G_TERRYINSEED])
				++req[1];
			if(G[G_SIYEDINSEED])
				++req[1];
			
			if(Link->Item[I_ASHER])
				++req[0];
			if(Link->Item[I_TORRIN])
				++req[0];
			if(Link->Item[I_KAYLANI])
				++req[0];
			if(Link->Item[I_SOREN])
				++req[0];
			if(Link->Item[I_TERRY])
				++req[0];
			if(Link->Item[I_SIYED])
				++req[0];
			
			til = 247;
		}
		else if(G[G_RANDOMIZEROBSERVATORYLOCK]==2){
			req[0] = Min(Game->Counter[CR_TOTALHYMNSTONES], G[G_RANDOMIZERREQUIREDHYMNSTONES]);
			req[1] = G[G_RANDOMIZERREQUIREDHYMNSTONES];
			til = 241;
		}
		
		int totalStr[16];
		sprintf(totalStr, "%d / %d", req[0], req[1]);
		int xOff = (Text->StringWidth(totalStr, FONT_Z3SMALL))/2-6;
			
		int x = Link->X+8;
		int y = Link->Y-12;
		
		Screen->FastTile(6, x-xOff-12, y, til, 7, 128);
		Screen->DrawString(6, x-xOff, y, FONT_Z3SMALL, 0x01, -1, TF_NORMAL, totalStr, 128, SHD_OUTLINED8, 0x0F);
	}
	void S25_GoopPuddle(bitmap b, bitmap b2, int x, int y, int r){
		//b->Ellipse(1, 128, 96, 60, 24, 0x0F, 1, 0, 0, 0, true, 128);
		b->Ellipse(0, x, y, r, r*0.4, 0x0F, 1, 0, 0, 0, true, 128);
		int dist = Max(r*0.1111, 4);
		b2->Ellipse(0, x, y, r+dist, r*0.4+dist, 0x0F, 1, 0, 0, 0, true, 128);
	}
	void S25_GoopOverlay(bitmap b, int draws){
		int count = SizeOfArray(draws);
		for(int i=0; i<count; ++i){
			int ptr = draws[i];
			if(b->GetPixel(CutX(ptr[0])+8, CutY(ptr[0])+15)==0x0F*0.0001){
				if(Cutscene_GetAttr(ptr[0], CGI_LAYER)>0)
					Cutscene_NewFastCombo(3, CutX(ptr[0]), CutY(ptr[0]), 51166, 0, 128);
			}
		}
	}
	void S25_Waitframe(bitmap goop, int npcDraws, int frames){
		for(int i=0; i<frames; ++i){
			S25_GoopOverlay(goop, npcDraws);
			Cutscene_Waitframe();
		}
	}
	void S25_Waitglide(bitmap goop, int npcDraws){
		while(cutsceneG[CG_NUMGLIDING]>0){
			S25_GoopOverlay(goop, npcDraws);
			Cutscene_Waitframe();
		}
	}
	void S25_PlayString(int str, int charID, int emote, int x, int y, bitmap goop, int npcDraws){
		PlayString(str, charID, emote, x, y);
		while(G[G_MSGACTIVE]){
			S25_GoopOverlay(goop, npcDraws);
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
	}
}

ffc FFCNPC(int data, int x, int y){
	ffc f = FindFreeFFC();
	f->Data = data;
	f->Misc[0] = data;
	f->X = x;
	f->Y = y;
	f->TileHeight = 2;
	f->CSet = 6;
	return f;
}

void FFCNPC(int data, int x, int y, ffc f){
	f->Data = data;
	f->Misc[0] = data;
	f->X = x;
	f->Y = y;
	f->TileHeight = 2;
	f->CSet = 6;
}

void SetFFCDir(ffc f, int dir, bool move){
	f->Data = f->Misc[0] + dir;
	if(move)
		f->Data+=4;
}

void FFCGlide(ffc f, int x, int y, int step, bool doWalk){
	int count = SizeOfArray(f);
	int tempX[32];
	int tempY[32];
	for(int i=0; i<count; ++i){
		tempX[i] = f[i]->X;
		tempY[i] = f[i]->Y;
	}
	int numFinishedGlide;
	while(numFinishedGlide<count){
		numFinishedGlide = 0;
		for(int i=0; i<count; ++i){
			int angle = Angle(tempX[i], tempY[i], x[i], y[i]);
			if(Distance(tempX[i], tempY[i], x[i], y[i])>step[i]){
				tempX[i] += VectorX(step[i], angle);
				tempY[i] += VectorY(step[i], angle);
				if(doWalk){
					SetFFCDir(f[i], f[i]->Data%4, true);
				}
			}
			else{
				tempX[i] = x[i];
				tempY[i] = y[i];
				if(doWalk){
					SetFFCDir(f[i], f[i]->Data%4, false);
				}
				++numFinishedGlide;
			}
			f[i]->X = tempX[i];
			f[i]->Y = tempY[i];
		}
		WaitNoAction();
	}
}

const int CMB_ASHER = 33284;
const int CMB_TORRIN = 33292;
const int CMB_KAYLANI = 33300;
const int CMB_WINNO = 33792;

void Cutscene_DrawLightSwordSlash(int sx, int sy, int angle, int dist, int swordlength, int damage, int slashDir, int slashFrame){
	slashDir = -slashDir; //I got my math backwards and instead of fixing it I'm doing this
	int x = sx+8+VectorX(dist+24, angle)+VectorX(slashDir*32, angle+90)-40;
	int y = sy+8+VectorY(dist+24, angle)+VectorY(slashDir*32, angle+90)-48;
	if(slashDir!=0){
		angle += 45*slashDir;
		Cutscene_NewTile(2, x, y, TIL_STELLARSLASH+5*slashFrame, 5, 6, 9, -1, -1, x, y, angle, slashDir==-1?0:2, true, 128);
	}
	else
		Cutscene_DrawLightSword(sx, sy, angle, dist, swordlength, damage);
}

void Cutscene_DrawLightSword(int sx, int sy, int angle, int dist, int swordlength, int damage){
	int x = sx + VectorX(dist+(swordlength-1)*8, angle)-(swordlength-1)*8;
	int y = sy + VectorY(dist+(swordlength-1)*8, angle);
	Cutscene_NewTile(2, x, y, TIL_STELLARSWORD+4-(swordlength-1)+(G[G_ANIM]%4*20), swordlength, 1, 9, -1, -1, x, y, angle, 0, true, 128);
}

ffc script SeletWarehouseScene{
	void run(){
		if(Game->Counter[CR_STORYFLAG] >=SFLAG_METKAYLANI)
			Quit();
		int i; int j; int k;
		int playerCMB = GetCharID()==CHAR_ASHER?51000:50952;
		SetCutsceneSkip(CUTSCENE_SELETWAREHOUSE);
		Cutscene_Init(RT_BITMAP1, RT_BITMAP2);
		Cutscene_AnchorCamera(0x05, 0x15, 1, 2);
		
		int w1 = Cutscene_NewFastCombo(1, 112, 16, 16288, 2, OP_OPAQUE);
		int w2 = Cutscene_NewFastCombo(1, 128, 16, 16289, 2, OP_OPAQUE);
		Cutscene_SetAttr(w1, CGI_DRAWLIFESPAN, -1);
		Cutscene_SetAttr(w2, CGI_DRAWLIFESPAN, -1);
		
		int plyr = Cutscene_NewNPC(2, 120, 176+160, playerCMB, 6, 128);
		Cutscene_SetFlag(plyr, CGF_4WAY|CGF_BS|CGF_BIGNPC);
		Cutscene_SetDir(plyr, DIR_UP);
		
		Cutscene_Glide(plyr, 0x15, CutX(plyr), 112, 1);
		Cutscene_Waitglide();
		int torrin = Cutscene_NewNPC(2, CutX(plyr), CutY(plyr), 50952, 6, 128);
		Cutscene_SetFlag(torrin, CGF_4WAY|CGF_BS|CGF_BIGNPC);
		int asher = Cutscene_NewNPC(2, CutX(plyr), CutY(plyr), 51000, 6, 128);
		Cutscene_SetFlag(asher, CGF_4WAY|CGF_BS|CGF_BIGNPC);
		Cutscene_RemoveDraw(plyr);
		
		int door1 = Cutscene_NewFastCombo(2, 112, 144+176, 16428, 2, 128);
		Cutscene_SetAttr(door1, CGI_DRAWLIFESPAN, -1);
		int door2 = Cutscene_NewFastCombo(2, 128, 144+176, 16429, 2, 128);
		Cutscene_SetAttr(door2, CGI_DRAWLIFESPAN, -1);
		Game->PlaySound(9);
		
		Cutscene_Glide(asher, 0x15, 112, 96, 1);
		Cutscene_Glide(torrin, 0x15, 128, 96, 1);
		Cutscene_Waitglide();
		Cutscene_SetDir(asher, DIR_RIGHT);
		Cutscene_SetDir(torrin, DIR_LEFT);
		Cutscene_Waitframe(24);
		
		Cutscene_PlayString("Are you sure these are pirates? I mean- The masks, the organized patrols...Something seems off about all this.", SCHAR_ASHER, EMOTE_NORMAL, 68, YPOS_UPPER);
		Cutscene_Waitframe(64);
		Cutscene_PlayString("Ugh...", SCHAR_UNKNOWN, EMOTE_NORMAL, 68, YPOS_UPPER);
		int kaylani = Cutscene_NewNPC(3, 112, 64, 50960, 6, 128, -1);
		Cutscene_SetNPCGraphic(kaylani, 50999, true);
		Cutscene_SetFlag(kaylani, CGF_BIGNPC);
		Cutscene_SetCameraTarget(0x05, 1.5);
		Cutscene_Waitcamera();
		
		Cutscene_PlayString("There's a girl tied up back there.", SCHAR_ASHER, EMOTE_SURPRISED, 68, YPOS_LOWER);
		Cutscene_PlayString("Human trafficking, I reckon. Worse than jus' swindlers or pirates, these lot are the lowest of the bottom feeders.", SCHAR_TORRIN, EMOTE_FURIOUS, 68, YPOS_LOWER);
		Cutscene_Glide(asher, 0x05, 104, 96, 2);
		Cutscene_SetDir(asher, DIR_UP);
		Cutscene_Glide(torrin, 0x05, 120, 96, 2.1);
		Cutscene_SetDir(torrin, DIR_UP);
		Cutscene_Waitglide();
		
		Cutscene_PlayString("You're... not the rescue... I expected.", SCHAR_KAYLANI, EMOTE_NORMAL, 68, YPOS_LOWER);
		Cutscene_PlayString("What's that s'posed to mean?", SCHAR_TORRIN, EMOTE_ELLIPSES, 68, YPOS_LOWER);
		Cutscene_Glide(asher, 0x05, 96, 72, 1);
		Cutscene_Waitglide();
		Cutscene_Glide(asher, 0x05, 104, 56, 1);
		Cutscene_Waitglide();
		Cutscene_SetNPCGraphic(asher, 51017, true);
		Cutscene_SetAttr(asher, CGI_DIR, DIR_RIGHT);
		
		Cutscene_PlayString("Don't worry, we'll get you out of here in a flash.", SCHAR_ASHER, EMOTE_NORMAL, 68, YPOS_LOWER);
		Cutscene_PlayString("And then we'll find the guy who kidnapped you, that sick son of a-", SCHAR_TORRIN, EMOTE_ANGRY, 68, YPOS_LOWER);
		Game->PlayMIDI(0);
		Cutscene_SetCameraTarget(0x15, 8);
		Cutscene_Waitcamera();
		Cutscene_Waitframe(32);
		Game->PlaySound(9);
		Cutscene_RemoveDraw(door1);
		Cutscene_RemoveDraw(door2);
		int selet = Cutscene_NewNPC(3, 120, 176+176, 51008, 6, 128, DIR_UP);
		Cutscene_SetFlag(selet, CGF_4WAY|CGF_BIGNPC);
		Cutscene_Waitframe(128);
		Cutscene_SetDrawPosition(asher, 0x05, 64, 112);
		Cutscene_SetNPCGraphic(asher, -1, true);
		Cutscene_SetDrawPosition(torrin, 0x05, 64, 96);
		Cutscene_SetDir(torrin, DIR_RIGHT);
		Cutscene_Glide(selet, 0x05, 112, 88, 0.8);
		Cutscene_SetCameraTarget(0x05, 0.8);
		int stepTimer = 40+Rand(8);
		while(!Cutscene_FinishedGlide(selet)){
			if(stepTimer)
				--stepTimer;
			else{
				Game->PlaySound(Choose(116, 117, 118));
				stepTimer = 40+Rand(8);
			}
			NoAction();
			Cutscene_Waitframe();
		}
		Game->PlayEnhancedMusic("SS-Selet.ogg", 0);
		Cutscene_Waitframe(32);
		Cutscene_PlayString("Ahh Kaylani, my precious treasure, my guiding star. Tell me, how has the extraction been treating you?", SCHAR_SELETNONAME, EMOTE_NORMAL, 68, YPOS_LOWER);
		Cutscene_SetNPCGraphic(kaylani, 51016, true);
		for(i=0; i<4*16; ++i){
			NoAction();
			Cutscene_Waitframe();
		}
		Cutscene_SetNPCGraphic(kaylani, 50999, true);
		
		Cutscene_PlayString("Screw...Ugh...Screw you!", SCHAR_KAYLANI, EMOTE_ANGRY, 68, YPOS_LOWER);
		Cutscene_PlayString("Oh don't be so hostile, girl. It's all for a good cause. You'll be lining my pockets finely with these goods. And if you agree to my deal, I'll even guarantee your freedom.", SCHAR_SELETNONAME, EMOTE_NORMAL, 68, YPOS_LOWER);
		Cutscene_SetNPCGraphic(kaylani, 51019, true);
		Cutscene_SetNPCGraphic(selet, 51018, true);
		Cutscene_SetAttr(kaylani, CGI_LAYER, 4);
		Cutscene_SetAttr(selet, CGI_LAYER, 5);
		Cutscene_Glide(selet, 0x05, 109, 73, 4);
		Cutscene_PlayString("Of course if you continue to resist, life will be a wee bit...uncomfortable.", SCHAR_SELETNONAME, EMOTE_NORMAL, 68, YPOS_LOWER);
		PlayString("Augh!", SCHAR_KAYLANI, EMOTE_NORMAL, 68, YPOS_LOWER);
		Cutscene_SetDir(torrin, DIR_RIGHT);
		Cutscene_Glide(torrin, 0x05, 64, 72, 0.5);
		Cutscene_SetDir(torrin, -1);
		i = 0;
		k = 0;
		while(G[G_MSGACTIVE]||k<64){
			if(Cutscene_FinishedGlide(torrin))
				Cutscene_SetDir(torrin, DIR_RIGHT);
			if(i%12==0)
				Game->PlaySound(84);
			++i;
			if(i>=24)
				i = 0;
			if(k<64)
				++k;
			j = 10-3*Floor(i/8)+(G[G_ANIM]%4<2?0:2);
			if(i<8)
				Cutscene_NewRectangle(4, 0, 0, 255, 175, 0x72, 1, 0, 0, 0, true, 64);
			if(i<16)
				Cutscene_NewRectangle(4, 0, 0, 255, 175, 0x72, 1, 0, 0, 0, true, 64);
			Cutscene_NewRectangle(4, 0, 0, 255, 175, 0x72, 1, 0, 0, 0, true, 64);
			Cutscene_NewCircle(G[G_ANIM]%4<2?3:4, CutX(selet)+10, CutY(selet)-9, j, 0x01, 1, 0, 0, 0, true, 128);
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		Cutscene_SetDir(torrin, DIR_RIGHT);
		PlayString("This guy looks like trouble, Torrin. What's the plan?", SCHAR_ASHER, EMOTE_NORMAL, 68, YPOS_UPPER);
		k = 32;
		while(G[G_MSGACTIVE]||k){
			if(!G[G_MSGACTIVE])
				Cutscene_SetDir(asher, DIR_UP);
			if(i%12==0)
				Game->PlaySound(84);
			++i;
			if(i>=24)
				i = 0;
			if(k&&!G[G_MSGACTIVE])
				--k;
			j = 10-3*Floor(i/8)+(G[G_ANIM]%4<2?0:2);
			if(i<8)
				Cutscene_NewRectangle(4, 0, 0, 255, 175, 0x72, 1, 0, 0, 0, true, 64);
			if(i<16)
				Cutscene_NewRectangle(4, 0, 0, 255, 175, 0x72, 1, 0, 0, 0, true, 64);
			Cutscene_NewRectangle(4, 0, 0, 255, 175, 0x72, 1, 0, 0, 0, true, 64);
			Cutscene_NewCircle(G[G_ANIM]%4<2?3:4, CutX(selet)+10, CutY(selet)-9, j, 0x01, 1, 0, 0, 0, true, 128);
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		Cutscene_SetDir(asher, DIR_UP);
		PlayString("...Torrin?", SCHAR_ASHER, EMOTE_SWEAT, 68, YPOS_UPPER);
		while(G[G_MSGACTIVE]){
			if(i%12==0)
				Game->PlaySound(84);
			++i;
			if(i>=24)
				i = 0;
			j = 10-3*Floor(i/8)+(G[G_ANIM]%4<2?0:2);
			if(i<8)
				Cutscene_NewRectangle(4, 0, 0, 255, 175, 0x72, 1, 0, 0, 0, true, 64);
			if(i<16)
				Cutscene_NewRectangle(4, 0, 0, 255, 175, 0x72, 1, 0, 0, 0, true, 64);
			Cutscene_NewRectangle(4, 0, 0, 255, 175, 0x72, 1, 0, 0, 0, true, 64);
			Cutscene_NewCircle(G[G_ANIM]%4<2?3:4, CutX(selet)+10, CutY(selet)-9, j, 0x01, 1, 0, 0, 0, true, 128);
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		Cutscene_Glide(torrin, 0x05, 88, 72, 4);
		Cutscene_SetNPCGraphic(torrin, 51020, true);
		Cutscene_Glide(selet, 0x05, 128, 72, 4);
		Cutscene_SetNPCGraphic(selet, -1, true);
		Cutscene_SetDir(selet, DIR_LEFT);
		Cutscene_PlayString("Hey, stop right there!", SCHAR_TORRIN, EMOTE_EXCLAMATION, 68, YPOS_UPPER);
		Cutscene_PlayString("Who are-", SCHAR_SELETNONAME, EMOTE_QUESTION, 68, YPOS_UPPER);
		Cutscene_SetNPCGraphic(kaylani, 50999, true);
		PlayString("I don't know what's going on here, but I know your kind. I'm not gonna let you sell that girl. And I'm gonna give you a wallop if you don't stop hurting her.", SCHAR_TORRIN, EMOTE_NORMAL, 68, YPOS_UPPER);
		int asherMovement;
		while(G[G_MSGACTIVE]||asherMovement<3){
			if(k<64){
				++k;
				if(k==64){
					Cutscene_Glide(asher, 0x05, 32, 128, 1);
					Cutscene_SetDir(asher, -1);
					asherMovement = 1;
				}
			}
			if(asherMovement==1){
				if(Cutscene_FinishedGlide(asher)){
					Cutscene_Glide(asher, 0x15, 32, 32, 1);
					asherMovement = 2;
				}
			}
			else if(asherMovement==2){
				if(Cutscene_FinishedGlide(asher)){
					asherMovement = 3;
				}
			}
			if(asherMovement<1)
				NoAction();
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		Cutscene_SetNPCGraphic(torrin, -1, true);
		Cutscene_PlayString("Sell her? Oh no, no, no. I would never let this one go, in this life or the next.", SCHAR_SELETNONAME, EMOTE_NORMAL, 68, YPOS_LOWER);
		Cutscene_PlayString("You're not? Then what's all this?", SCHAR_TORRIN, EMOTE_NORMAL, 68, YPOS_LOWER);
		asherMovement = 0;
		Cutscene_SetNPCGraphic(selet, 51021, true);
		Cutscene_SetAttr(selet, CGI_LAYER, 3);
		int battery = Cutscene_NewFastTile(4, CutX(selet)-5, CutY(selet)-18, 65112, 8, 128);
		Cutscene_SetAttr(battery, CGI_DRAWLIFESPAN, -1);
		for(i=0; i<32; ++i){
			Cutscene_Waitframe();
		}
		PlayString("See this? This is worth more money than you are. And that girl? She's worth more than you'll ever make in your entire life a thousand times over. I wouldn't dream of selling such a valuable-", SCHAR_SELETNONAME, EMOTE_NORMAL, 68, YPOS_LOWER);
		Cutscene_SetDrawPosition(asher, 0x05, -16, 88);
		Cutscene_SetAttr(asher, CGI_LAYER, 5);
		Cutscene_Glide(asher, 0x05, 48, 24, 0.5);
		asherMovement = 0;
		k = 0;
		while(G[G_MSGACTIVE]||asherMovement<4){
			if(asherMovement==0){
				if(Cutscene_FinishedGlide(asher)){
					Cutscene_Glide(asher, 0x05, CutX(selet), 24, 0.5);
					asherMovement = 1;
				}
			}
			else if(asherMovement==1){
				if(Cutscene_FinishedGlide(asher)){
					Cutscene_SetDir(asher, DIR_DOWN);
					asherMovement = 2;
				}
			}
			else if(asherMovement==2){
				++k;
				if(k>=64){
					Cutscene_SetNPCGraphic(asher, 51022, true);
					k = 0;
					asherMovement = 3;
				}
			}
			else if(asherMovement==3){
				++k;
				if(k>=32){
					asherMovement = 4;
				}
			}
			if(asherMovement<2)
				NoAction();
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		int z = 0;
		int jump = 2.4;
		Cutscene_SetNPCGraphic(asher, -1, true);
		Cutscene_SetDir(asher, DIR_DOWN);
		z = CutY(selet)-CutY(asher);
		Game->PlaySound(SFX_JUMP);
		while(z>0||jump>0){
			jump = Max(jump-0.16, -3.2);
			z = Max(z+jump, 0);
			Cutscene_SetDrawPosition(asher, 0x05, CutX(selet), CutY(selet)-z);
			DrawShadow1x1Cutscene(4, CutX(selet), CutY(selet));
			Cutscene_Waitframe();
		}
		Game->PlaySound(SFX_EHIT);
		Game->PlayMIDI(0);
		Cutscene_SetDrawPosition(asher, 0x05, CutX(selet), CutY(selet));
		Cutscene_AddAttr(selet, CGI_Y, 8);
		Cutscene_SetNPCGraphic(asher, 51022, true);
		Cutscene_SetNPCGraphic(selet, 51023, true);
		Cutscene_GlideAccel(asher, 0x05, CutX(asher), CutY(asher)+32, 2, 0);
		Cutscene_GlideAccel(selet, 0x05, CutX(selet), CutY(selet)+32, 2, 0);
		Cutscene_Glide(battery, 0x05, 112, 96, 2);
		Cutscene_SetAttr(battery, CGI_LAYER, 6);
		while(!Cutscene_FinishedGlide(battery)){
			Cutscene_Waitframe();
		}
		eweapon e = CreateEWeaponAt(EW_SOLAR, CutX(battery), CutY(battery));
		e->CollDetection = false;
		e->DrawYOffset = -1000;
		RunEWeaponScript(e, "GenParticle", {GP_FLASH, -1});
		Cutscene_RemoveDraw(battery);
		Cutscene_Waitframe(64);
		Cutscene_PlayString("Nice one, Ash! I've got the girl, now let's get out of here!", SCHAR_TORRIN, EMOTE_HAPPY, 68, YPOS_UPPER);
		Cutscene_PlayString("\"The girl\"... has a name.", SCHAR_KAYLANI, EMOTE_NORMAL, 68, YPOS_UPPER);
		Cutscene_PlayString("And you can tell me it once we're safe!", SCHAR_TORRIN, EMOTE_NORMAL, 68, YPOS_UPPER);
		Cutscene_Waitframe(64);
		Cutscene_RemoveDraw(asher);
		Cutscene_RemoveDraw(torrin);
		Cutscene_RemoveDraw(kaylani);
		e->InitD[1] = 0;
		Cutscene_SetNPCGraphic(selet, 51024, true);
		Cutscene_Waitframe(32);
		Cutscene_PlayString("These street trash keep cropping up, like rats out of the gutter...Get back here! That does not belong to you!", SCHAR_SELETNONAME, EMOTE_FURIOUS, 68, YPOS_UPPER);
		Cutscene_SetDir(selet, DIR_DOWN);
		Cutscene_SetNPCGraphic(selet, -1, true);
		Cutscene_Waitframe(32);
		Cutscene_Glide(selet, 0x15, 120, 128, 1);
		for(i=0; i<64; ++i){
			if(i>31)
				Cutscene_NewRectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
			if(i>15)
				Cutscene_NewRectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
			Cutscene_NewRectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
			Cutscene_Waitframe();
		}
		Link->Invisible = true;
		Screen->SetSideWarp(3, 0x06, 2, WT_IWARPBLACKOUT);
		this->Data = CMB_AUTOWARPD;
	}
}

ffc script SeletMinesScene{
	void DrawCastingCircle(int selet, int layer, int x, int y){
		Cutscene_NewCircle(2, CutX(selet[0])+x+Rand(-1, 1), CutY(selet[0])+y+Rand(-1, 1), ((G[G_ANIM]%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
	}
	void DrawCastingCircle2(int asher, int layer, int x, int y){
		Cutscene_NewCircle(layer, CutX(asher[0])+x+Rand(-1, 1), CutY(asher[0])+y+Rand(-1, 1)+Sin(G[G_ANIM]*2), ((G[G_ANIM]%6<4)?1:3)+Rand(2), Choose(0x91, 0x96, 0x98), 1, 0, 0, 0, true, 128);
	}
	void DrawSeletTeleport(int selet, bitmap b, int meltSpeed, int percent){
		b->Clear(0);
		int cmb = Cutscene_GetAttr(selet[0], CGI_GFX);
		b->DrawCombo(0, 0, 1, cmb, 1, 2, Ghost_CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
		b->DrawCombo(0, 2, 1, cmb, 1, 2, Ghost_CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
		b->DrawCombo(0, 1, 0, cmb, 1, 2, Ghost_CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
		b->ReplaceColors(0, 0x01, 0x01, 0xBF);
		b->DrawCombo(0, 1, 1, cmb, 1, 2, Ghost_CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
		b->ReplaceColors(0, 0x0F, 0x10, 0xBF);
		b->ReplaceColors(0, 0x75, 0x01, 0x01);
		
		int sX = CutX(selet[0]);
		int sY = CutY(selet[0]);
		int lyr = Cutscene_GetAttr(selet[0], CGI_LAYER);
		
		for(int i=0; i<18; ++i){
			if(meltSpeed[i]==0)
				meltSpeed[i] = Rand(100, 200)/100;
		}
		Cutscene_NewEllipse(0, sX+7, sY+15, 8+4*percent+1, 3+percent+1, 0x75, 1, 0, 0, 0, true, 128);
		Cutscene_NewEllipse(0, sX+7, sY+15, 8+4*percent, 3+percent, 0x0F, 1, 0, 0, 0, true, 128);
		for(int i=0; i<18; ++i){
			int height = Clamp(Lerp(33, 0, meltSpeed[i]*percent), 0, 33);
			if(height>=1){
				Cutscene_NewBlit(lyr, b, i, 0, 1, 33, sX+i, sY-18+(33-height), 1, height, 0);
			}
		}
	}
	void SeletTeleport(int selet, bitmap b, int meltSpeed, int teleport, int destX, int destY, int endDir){
		switch(teleport[0]){
			case 0: //Teleport out
				if(teleport[1]==0){
					Cutscene_SetFlag(selet[0], CGF_NODRAW);
					for(int i=0; i<18; ++i){
						meltSpeed[i] = 0;
					}
				}
				DrawSeletTeleport(selet, b, meltSpeed, teleport[1]/16);
				++teleport[1];
				if(teleport[1]>=16){
					teleport[0] = 1;
					teleport[1] = 0;
					Cutscene_Glide(selet[0], 0x2C, destX, destY, 2);
				}
				break;
			case 1: //Glide
				DrawSeletTeleport(selet, b, meltSpeed, 1);
				if(Cutscene_FinishedGlide(selet[0])){
					teleport[0] = 2;
					teleport[1] = 0;
					for(int i=0; i<18; ++i){
						meltSpeed[i] = 0;
					}
				}
				break;
			case 2: //Teleport in
				DrawSeletTeleport(selet, b, meltSpeed, 1-(teleport[1]/16));
				++teleport[1];
				if(teleport[1]>=16){
					Cutscene_SetDir(selet[0], endDir);
					Cutscene_SetNPCGraphic(selet[0], -1, true);
					Cutscene_UnsetFlag(selet[0], CGF_NODRAW);
					teleport[0] = 3;
					teleport[1] = 0;
				}
				break;
		}
	}
	void DrawATKStun(bitmap b, int asher, int torrin, int kaylani){
		DrawATKStun(b, asher, torrin, kaylani, 0);
	}
	void DrawATKStun(bitmap b, int asher, int torrin, int kaylani, int sword){
		b->Clear(0);
		if(IsValidArray(asher)){
			int cmbAsher = Cutscene_GetAttr(asher[0], CGI_GFX);
			if(cmbAsher==Cutscene_GetAttr(asher[0], CGI_MISC1)||cmbAsher==Cutscene_GetAttr(asher[0], CGI_MISC1)+4)
				cmbAsher += Cutscene_GetAttr(asher[0], CGI_DIR);
			b->DrawCombo(0, 0, 0, cmbAsher, 1, 2, 6, -1, -1, 0, 0, 0, -1, 0, true, 128);
		}
		if(IsValidArray(torrin)){
			int cmbTorrin = Cutscene_GetAttr(torrin[0], CGI_GFX);
			if(cmbTorrin==Cutscene_GetAttr(torrin[0], CGI_MISC1)||cmbTorrin==Cutscene_GetAttr(torrin[0], CGI_MISC1)+4)
				cmbTorrin += Cutscene_GetAttr(torrin[0], CGI_DIR);
			b->DrawCombo(0, 16, 0, cmbTorrin, 1, 2, 6, -1, -1, 0, 0, 0, -1, 0, true, 128);
		}
		if(IsValidArray(kaylani)){
			int cmbKaylani = Cutscene_GetAttr(kaylani[0], CGI_GFX);
			if(cmbKaylani==Cutscene_GetAttr(kaylani[0], CGI_MISC1)||cmbKaylani==Cutscene_GetAttr(kaylani[0], CGI_MISC1)+4)
				cmbKaylani += Cutscene_GetAttr(kaylani[0], CGI_DIR);
			b->DrawCombo(0, 32, 0, cmbKaylani, 1, 2, 6, -1, -1, 0, 0, 0, -1, 0, true, 128);
		}
		if(IsValidArray(sword)){
			int tilSword = Cutscene_GetAttr(sword[0], CGI_GFX);
			b->DrawTile(0, 48, 0, tilSword, 1, 1, 6, -1, -1, 48, 0, Cutscene_GetAttr(sword[0], CGI_ROT), 0, true, 128);
		}
		
		b->ReplaceColors(0, Choose(0x72, 0x73, 0x74), 0x01, 0xBF);
		
		if(IsValidArray(asher))
			Cutscene_NewBlit(1, b, 0, 0, 16, 32, CutX(asher[0])+Choose(-1, 1), CutY(asher[0])-16+Choose(-1, 1), 16, 32, 0);
		if(IsValidArray(torrin))
			Cutscene_NewBlit(1, b, 16, 0, 16, 32, CutX(torrin[0])+Choose(-1, 1), CutY(torrin[0])-16+Choose(-1, 1), 16, 32, 0);
		if(IsValidArray(kaylani))
			Cutscene_NewBlit(1, b, 32, 0, 16, 32, CutX(kaylani[0])+Choose(-1, 1), CutY(kaylani[0])-16+Choose(-1, 1), 16, 32, 0);
		if(IsValidArray(sword))
			Cutscene_NewBlit(1, b, 48, 0, 16, 16, CutX(sword[0])+Choose(-1, 1), CutY(sword[0])+Choose(-1, 1), 16, 16, 0);
	}
	void DrawBigShot(int layer, int x, int y, int rad, int damage, int dir, int i, int flash){
		int r = rad+2*Sin(i);
		int clr[3] = {0x88, 0x86, 0x81};
		if(flash==0){
			clr[0] = 0x88;
			clr[1] = 0x87;
			clr[2] = 0x86;
		}
		if(flash==2){
			clr[0] = 0x86;
			clr[1] = 0x81;
			clr[2] = 0x81;
		}
		Cutscene_NewCircle(layer, x, y, rad+2*Sin(i), clr[0], 1, 0, 0, 0, true, 128);
		Cutscene_NewCircle(layer, x, y, rad*0.875+2*Sin(i), clr[1], 1, 0, 0, 0, true, 128);
		Cutscene_NewCircle(layer, x, y, rad*0.625+2*Sin(i), clr[2], 1, 0, 0, 0, true, 128);
	}
	void KaylaniSunballStuff(int kaylani, int dat){
		switch(dat[0]){
			case 0: //Walking into positionif(Cutscene_FinishedGlide(kaylani[0])){
				if(Cutscene_FinishedGlide(kaylani[0])){
					dat[0] = 1;
					dat[1] = 0;
					Cutscene_SetNPCGraphic(kaylani[0], 51087, true);
				}
				else{
					++dat[1];
					if(dat[1]%80<32){
						Cutscene_SetAttr(kaylani[0], CGI_MOVESTEP, 0.5);
						Cutscene_SetNPCGraphic(kaylani[0], -1, true);
					}
					else{
						Cutscene_SetAttr(kaylani[0], CGI_MOVESTEP, 0);
					}
				}
				break;
			case 1: //Charging
			case 2:
				if(dat[1]<100)
					++dat[1];
				if(dat[0]==1&&dat[1]>=90){
					Game->PlaySound(SFX_CHARGE1);
					dat[0] = 2;
				}
				int chargePercent = Min(dat[1]/80, 1);
				DrawBigShot(4, CutX(kaylani[0])+8, CutY(kaylani[0])-8-4*chargePercent, 2+6*chargePercent, 0, DIR_LEFT, G[G_ANIM]*4, G[G_ANIM]%4);
				break;
			case 3: //Shooting
				int xy[2];
				int ballCurveX = CutX(kaylani[0])+8;
				int ballCurveY = CutY(kaylani[0])+8;
				int ballDestX = CutX(kaylani[0])+8+DirX(DIR_LEFT, 16);
				int ballDestY = CutY(kaylani[0])+8+DirY(DIR_LEFT, 16);
				BezierQuadFrame(xy, dat[1], 8, CutX(kaylani[0])+8, CutY(kaylani[0])-8-4, ballCurveX, ballCurveY, ballDestX, ballDestY);
				DrawBigShot(4, xy[0], xy[1], 2+6, 0, DIR_LEFT, G[G_ANIM]*4, G[G_ANIM]%4);
				++dat[1];
				if(dat[1]>=8)
					dat[0] = 4;
				break;
		}
	}
	void run(){
		if(G[G_RANDOMIZERENABLED]){
			Screen->TriggerSecrets();
			Quit();
		}
		if(Distance(this->X, this->Y, Link->X, Link->Y)<8){
			runPart2();
		}
		else{
			runPart1();
		}
	}
	void runPart1(){
		SetCutsceneSkip(CUTSCENE_SELETMINES);
		bitmap b = Game->CreateBitmap(32, 32);
		b->Own();
		b->Clear(0);
		int i; int j; int k;
		int playerCMB;
		switch(GetCharID()){
			case CHAR_ASHER: playerCMB = 51000; break;
			case CHAR_TORRIN: playerCMB = 50952; break;
			case CHAR_KAYLANI: playerCMB = 50960; break;
		}
		Cutscene_Init(RT_BITMAP1, RT_BITMAP2);
		Cutscene_AnchorCamera(0x19, 0x1A, 2, 3);
		int plyr = Cutscene_NewNPC(2, 256+120, 160, playerCMB, 6, 128);
		Cutscene_SetFlag(plyr, CGF_4WAY|CGF_BS|CGF_BIGNPC);
		Cutscene_SetDir(plyr, DIR_UP);
		Cutscene_Glide(plyr, 0x1A, 120, 128, 1);
		Cutscene_Waitglide();
		int asher[1];
		int torrin[1];
		int kaylani[1];
		asher[0] = Cutscene_NewNPC(2, CutX(plyr), CutY(plyr), 51000, 6, 128);
		Cutscene_SetFlag(asher[0], CGF_4WAY|CGF_BS|CGF_BIGNPC);
		torrin[0] = Cutscene_NewNPC(2, CutX(plyr), CutY(plyr), 50952, 6, 128);
		Cutscene_SetFlag(torrin[0], CGF_4WAY|CGF_BS|CGF_BIGNPC);
		kaylani[0] = Cutscene_NewNPC(2, CutX(plyr), CutY(plyr), 50960, 6, 128);
		Cutscene_SetFlag(kaylani[0], CGF_4WAY|CGF_BS|CGF_BIGNPC);
		
		int door1 = Cutscene_NewFastCombo(2, 256+112, 144, 46338, 3, 128);
		Cutscene_SetAttr(door1, CGI_DRAWLIFESPAN, -1);
		int door2 = Cutscene_NewFastCombo(2, 256+128, 144, 46339, 3, 128);
		Cutscene_SetAttr(door2, CGI_DRAWLIFESPAN, -1);
		Game->PlaySound(9);
		
		Cutscene_RemoveDraw(plyr);
		Cutscene_Glide(asher[0], 0x1A, 120, 104, 1);
		Cutscene_Glide(torrin[0], 0x1A, 104, 120, 1);
		Cutscene_Glide(kaylani[0], 0x1A, 136, 120, 1);
		Cutscene_Waitglide();
		
		for(i=0; i<4; ++i){
			switch(Cutscene_GetAttr(asher[0], CGI_DIR)){
				case DIR_UP: Cutscene_SetDir(asher[0], Choose(DIR_LEFT, DIR_RIGHT)); break;
				case DIR_LEFT: Cutscene_SetDir(asher[0], Choose(DIR_UP, DIR_RIGHT)); break;
				case DIR_RIGHT: Cutscene_SetDir(asher[0], Choose(DIR_UP, DIR_LEFT)); break;
				default: Cutscene_SetDir(asher[0], Choose(DIR_LEFT, DIR_RIGHT)); break;
			}
			Cutscene_Waitframe(32);
		}
		Cutscene_SetDir(asher[0], DIR_DOWN);
		Cutscene_SetDir(torrin[0], DIR_RIGHT);
		Cutscene_SetDir(kaylani[0], DIR_LEFT);
		Cutscene_Waitframe(32);
		Cutscene_PlayString("This generator seems to be powering all that mining equipment out there.", SCHAR_ASHER, EMOTE_NORMAL, 68, YPOS_UPPER);
		Cutscene_PlayString("How're you so sure 'bout that?", SCHAR_TORRIN, EMOTE_NORMAL, 68, YPOS_UPPER);
		Cutscene_PlayString("I'm pretty good with machines. I used to take apart all kinds of things when I was bored, to see how they worked. Even got some of them back together afterwards, after Iris threatened to tell Mom.", SCHAR_ASHER, EMOTE_NORMAL, 68, YPOS_UPPER);
		Cutscene_PlayString("Wait, then why were you staring into space while Torrin and I took apart the battery?", SCHAR_KAYLANI, EMOTE_EYEBROWRAISED, 68, YPOS_UPPER);
		Cutscene_PlayString("... I had a lot on my mind, alright?", SCHAR_ASHER, EMOTE_SWEAT, 68, YPOS_UPPER);
		Cutscene_PlayString("Well lucky for us, we're just in the business of takin' things apart here. An' even I can handle that.", SCHAR_TORRIN, EMOTE_NORMAL, 68, YPOS_UPPER);
		
		Cutscene_SetDir(asher[0], DIR_UP);
		Cutscene_Glide(asher[0], 0x1A, 120, 128, 1);
		Cutscene_SwapDrawPtr(asher, torrin);
		Cutscene_Waitframe(8);
		Cutscene_SetDir(torrin[0], DIR_UP);
		Cutscene_Glide(torrin[0], 0x1A, 120, 104, 0.5);
		Cutscene_Waitglide();
		Cutscene_SetDir(kaylani[0], DIR_LEFT);
		Cutscene_Glide(kaylani[0], 0x1A, 128, 104, 2);
		Cutscene_SetDir(torrin[0], DIR_RIGHT);
		Cutscene_Glide(torrin[0], 0x1A, 112, 104, 1);
		Cutscene_Waitglide();
		
		Cutscene_PlayString("Are you sure that's the best idea? You could hurt yourself.", SCHAR_KAYLANI, EMOTE_DISMAYED, 68, YPOS_UPPER);
		Cutscene_PlayString("Aw, so you DO care about me.", SCHAR_TORRIN, EMOTE_WINK, 68, YPOS_UPPER);
		Cutscene_PlayString("Against my better judgment.", SCHAR_KAYLANI, EMOTE_NORMAL, 68, YPOS_UPPER);
		Cutscene_PlayString("Alright, would you like to do the honors?", SCHAR_TORRIN, EMOTE_NORMAL, 68, YPOS_UPPER);
		Cutscene_PlayString("Destroying equipment that probably cost Selet untold amounts of money? It'd be my pleasure!", SCHAR_KAYLANI, EMOTE_NORMAL, 68, YPOS_UPPER);
	
		Cutscene_SetDir(asher[0], DIR_RIGHT);
		Cutscene_Glide(asher[0], 0x1A, 96, 128, 1);
		Cutscene_Glide(torrin[0], 0x1A, 96, 112, 1);
		Cutscene_SetDir(kaylani[0], DIR_UP);
		Cutscene_Glide(kaylani[0], 0x1A, 120, 120, 1);
		Cutscene_Waitglide();
		
		Cutscene_Waitframe(32);
		
		Cutscene_SetNPCGraphic(kaylani[0], 51076, true);
		for(i=0; i<80; ++i){
			DrawBigShot(4, CutX(kaylani[0])+8, CutY(kaylani[0])-8-4*(i/80), 2+6*(i/80), 0, DIR_UP, G[G_ANIM]*4, G[G_ANIM]%4);
			Cutscene_Waitframe();
		}
		Game->PlaySound(SFX_CHARGE1);
		for(i=0; i<60; ++i){
			DrawBigShot(4, CutX(kaylani[0])+8, CutY(kaylani[0])-8-4, 2+6, 0, DIR_UP, G[G_ANIM]*4, G[G_ANIM]%4);
			Cutscene_Waitframe();
		}
		Game->PlayMIDI(0);
		Game->PlaySound(9);
		Cutscene_RemoveDraw(door1);
		Cutscene_RemoveDraw(door2);
		Cutscene_SetNPCGraphic(kaylani[0], -1, true);
		Cutscene_SetDir(kaylani[0], DIR_DOWN);
		Cutscene_Glide(kaylani[0], 0x1A, 120, 88, 2.5);
		
		int selet[1];
		selet[0] = Cutscene_NewNPC(2, 256+120, 160, 51088, 11, 128);
		Cutscene_SetFlag(selet[0], CGF_4WAY|CGF_BIGNPC);
		Cutscene_Glide(selet[0], 0x1A, 120, 128, 0.5);
		
		Cutscene_Waitglide(kaylani[0]);
		Game->PlaySound(108);
		Cutscene_Waitglide();
		
		Cutscene_PlayString("...Let's step outside.", SCHAR_SELET, EMOTE_NORMAL, 68, YPOS_UPPER);
		
		Cutscene_SetAttr(kaylani[0], CGI_LAYER, 1);
		Cutscene_SwapDrawPtr(asher, selet);
		Cutscene_Glide(selet[0], 0x1A, 120, 120, 0.5);
		Cutscene_Glide(asher[0], 0x1A, 112, 112, 2.5);
		Cutscene_Waitglide();
		Cutscene_SetNPCGraphic(asher[0], 51017, true);
		
		Cutscene_PlayString("I said @delay(120)let's @delay(60)step @delay(60)outside.", SCHAR_SELET, EMOTE_NORMAL, 68, YPOS_UPPER);
		
		Cutscene_SetNPCGraphic(selet[0], 51018, true);
		Cutscene_SetNPCGraphic(asher[0], 51077, true);
		Cutscene_SetDrawPosition(asher[0], CutX(selet[0])+4, CutY(selet[0])-12);
		Game->PlaySound(78);
		for(i=0; i<48; ++i){
			b->Clear(0);
			b->DrawCombo(0, 0, 0, 51077, 1, 2, 6, -1, -1, 0, 0, 0, -1, 0, true, 128);
			b->ReplaceColors(0, Choose(0x72, 0x73, 0x74), 0x01, 0xBF);
			Cutscene_NewBlit(1, b, 0, 0, 16, 32, CutX(asher[0])+Choose(-1, 1), CutY(asher[0])-16+Choose(-1, 1), 16, 32, 0);
			Cutscene_Waitframe();
		}
		Cutscene_SwapDrawPtr(asher, selet);
		Cutscene_SetNPCGraphic(selet[0], 51080, true);
		Cutscene_SetNPCGraphic(asher[0], 51078, true);
		Cutscene_SetDrawPosition(asher[0], CutX(selet[0]), CutY(selet[0])+12);
		Cutscene_SetAttr(asher[0], CGI_LAYER, 3);
		
		Game->PlaySound(SFX_FALL);
		Cutscene_Glide(asher[0], 0x2A, 120, 80, 4);
		Cutscene_SetCameraTarget(0x2A, 4.5);
		bool glideFinished;
		bool camFinished;
		while(!glideFinished||!camFinished){
			if(Cutscene_FinishedGlide(asher[0])&&!glideFinished){
				Game->PlaySound(11);
				Cutscene_Glide(asher[0], 0x3A, 32, 72, 4);
				glideFinished = true;
			}
			if(Cutscene_CameraFinishedMoving()&&!camFinished){
				Cutscene_SetCameraTarget(9*256+128-cutsceneG[CG_CAMANCHORX], 2*176+96-cutsceneG[CG_CAMANCHORY], 4.5);
				camFinished = true;
			}
			int angle = Angle(CutX(asher[0]), CutY(asher[0]), Cutscene_GetAttr(asher[0], CGI_TX), Cutscene_GetAttr(asher[0], CGI_TY));
			b->Clear(0);
			b->DrawCombo(0, 0, 0, 51078, 1, 2, 6, -1, -1, 0, 0, 0, -1, 0, true, 128);
			b->ReplaceColors(0, Choose(0x72, 0x73, 0x74), 0x01, 0xBF);
			Cutscene_NewBlit(1, b, 0, 0, 16, 32, CutX(asher[0])+VectorX(4, angle)+Choose(-1, 1), CutY(asher[0])-16+VectorY(4, angle)+Choose(-1, 1), 16, 32, 0);
			Cutscene_Waitframe();
		}
		while(!Cutscene_FinishedGlide(asher[0])){
			int angle = Angle(CutX(asher[0]), CutY(asher[0]), Cutscene_GetAttr(asher[0], CGI_TX), Cutscene_GetAttr(asher[0], CGI_TY));
			b->Clear(0);
			b->DrawCombo(0, 0, 0, 51078, 1, 2, 6, -1, -1, 0, 0, 0, -1, 0, true, 128);
			b->ReplaceColors(0, Choose(0x72, 0x73, 0x74), 0x01, 0xBF);
			Cutscene_NewBlit(1, b, 0, 0, 16, 32, CutX(asher[0])+VectorX(4, angle)+Choose(-1, 1), CutY(asher[0])-16+VectorY(4, angle)+Choose(-1, 1), 16, 32, 0);
			Cutscene_Waitframe();
		}
		Cutscene_SetAttr(asher[0], CGI_LAYER, 2);
		Game->PlaySound(SFX_BOMB);
		Game->PlaySound(SFX_OUCH);
		
		int asher2x2[1];
		asher2x2[0] = Cutscene_NewCombo(2, CutX(asher[0])-8, CutY(asher[0])-8, 51079, 2, 2, 6, -1, -1, 0, 0, 0, -1, 0, true, 128);
		Cutscene_SetAttr(asher2x2[0], CGI_DRAWLIFESPAN, -1);
		Cutscene_SetDrawPosition(asher[0], -16, -16);
		Cutscene_GlideAccel(asher2x2[0], 0x39, 240, 16, 4, 1);
		Cutscene_Waitglide();
		
		Cutscene_AnchorCamera(0x0A, 0x0A, 1, 1);
		Cutscene_SetDrawPosition(asher2x2[0], 0x0A, 112, 96);
		
		Cutscene_SetDir(kaylani[0], DIR_DOWN);
		Cutscene_SetDir(torrin[0], DIR_DOWN);
		Cutscene_SetDrawPosition(kaylani[0], 0x0A, 168, -16);
		Cutscene_SetDrawPosition(torrin[0], 0x0A, 168, -48);
		Cutscene_Glide(kaylani[0], 0x0A, 168, 48, 2);
		Cutscene_Glide(torrin[0], 0x0A, 168, 48, 2);
		Cutscene_Waitglide(kaylani[0]);
		Cutscene_Glide(kaylani[0], 0x0A, 144, 96, 2);
		while(!Cutscene_FinishedGlide(kaylani[0])){
			if(Cutscene_FinishedGlide(torrin[0])){
				Cutscene_Glide(torrin[0], 0x0A, 120, 80, 2);
			}
			Cutscene_Waitframe();
		}
		Cutscene_SetDir(kaylani[0], DIR_LEFT);
		Cutscene_Waitglide();
		Cutscene_SetNPCGraphic(torrin[0], 51081, true);
		
		Cutscene_PlayString("H-hey! Asher! Ya still with us?", SCHAR_TORRIN, EMOTE_DISMAYED, 68, YPOS_UPPER);
		
		Cutscene_SetDir(selet[0], DIR_DOWN);
		Cutscene_SetDrawPosition(selet[0], 0x0A, 168, -16);
		Cutscene_SetNPCGraphic(selet[0], -1, true);
		Cutscene_Glide(selet[0], 0x0A, 168, 32, 1);
		Game->PlayEnhancedMusic("SS-Selet.ogg", 0);
		Cutscene_Waitglide();
		
		Cutscene_PlayString("I'm sure you know you can't run from me this time. Not with this whole facility on high alert.", SCHAR_SELET, EMOTE_NORMAL, 68, YPOS_LOWER);
		
		Cutscene_SetNPCGraphic(torrin[0], -1, true);
		Cutscene_SetDir(torrin[0], DIR_RIGHT);
		Cutscene_SetDir(kaylani[0], DIR_UP);
		
		Cutscene_PlayString("Who's runnin'? Not us!", SCHAR_TORRIN, EMOTE_ANGRY, 68, YPOS_UPPER);
		Cutscene_PlayString("Very well. I must say, the three of you have caused me quite a deal of grief. My subordinates and business partners are injured, my mining facility in a state of panic. It's left me in quite a foul mood.", SCHAR_SELET, EMOTE_NORMAL, 68, YPOS_LOWER);
		Cutscene_Waitframe(32);
		Cutscene_Glide(selet[0], 0x0A, 160, 48, 0.3333);
		Cutscene_Waitglide();
		Cutscene_PlayString("But I'm a man of reason, and a man of business. You currently have the slightest leverage over me. I don't want those goods you have on you getting damaged, not before she's served her purpose.", SCHAR_SELET, EMOTE_NORMAL, 68, YPOS_LOWER);
		Cutscene_PlayString("The \"goods\" have a name y'know. It's Kaylani.", SCHAR_TORRIN, EMOTE_ANGRY, 68, YPOS_UPPER);
		Cutscene_PlayString("Mmm, quite. Now as I was saying, I would be be willing to strike a deal with you, yes? Hand her over to me, and I'll let the two of you walk free. I think that's awfully generous, considering the circumstances.", SCHAR_SELET, EMOTE_NORMAL, 68, YPOS_LOWER);
		Cutscene_PlayString("Bite me.", SCHAR_TORRIN, EMOTE_ANGRY, 68, YPOS_UPPER);
		Cutscene_PlayString("Go to hell, Selet.", SCHAR_KAYLANI, EMOTE_NORMAL, 68, YPOS_UPPER);
		
		Cutscene_SetNPCGraphic(asher[0], 51096, true);
		Cutscene_SetDrawPosition(asher[0], 0x0A, CutX(asher2x2[0])+8, CutY(asher2x2[0])+8);
		Cutscene_SetDrawPosition(asher2x2[0], -32, -32);
		Cutscene_Waitframe(32);
		Cutscene_SetNPCGraphic(asher[0], -1, true);
		Cutscene_SetDir(asher[0], DIR_UP);
		Cutscene_Waitframe(32);
		
		Cutscene_PlayString("As if we'd just sell her out. We're not like you, you shriveled old creep! We're not leaving anyone behind.", SCHAR_ASHER, EMOTE_ANGRY, 68, YPOS_UPPER);
		Cutscene_PlayString("And I suppose you expect the power of friendship will save you now.", SCHAR_SELET, EMOTE_NORMAL, 68, YPOS_LOWER);
		Cutscene_GlideTimed(torrin[0], 0x0A, 144, 64, 16);
		Cutscene_SetNPCGraphic(selet[0], 51083, true);
		// while(!Cutscene_FinishedGlide(torrin[0])){
			// Cutscene_NewCircle(2, CutX(selet[0])+7+Rand(-1, 1), CutY(selet[0])-5+Rand(-1, 1), ((G[G_ANIM]%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
			// Cutscene_Waitframe();
		// }
							
		Cutscene_SetNPCGraphic(asher[0], 51077, true);
		Cutscene_SetNPCGraphic(torrin[0], 51061, true);
		Cutscene_SetAttr(asher[0], CGI_LAYER, 3);
		Cutscene_GlideTimed(asher[0], 0x0A, CutX(asher[0]), CutY(asher[0])-32, 16);
		Game->PlaySound(78);
		while(!Cutscene_FinishedGlide(asher[0])){
			if(Cutscene_FinishedGlide(torrin[0])){
				Cutscene_SetDir(torrin[0], DIR_DOWN);
				Cutscene_SetNPCGraphic(torrin[0], -1, true);
			}
				
			Cutscene_NewCircle(2, CutX(selet[0])+7+Rand(-1, 1), CutY(selet[0])-5+Rand(-1, 1), ((G[G_ANIM]%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
			int angle = Angle(CutX(asher[0]), CutY(asher[0]), Cutscene_GetAttr(asher[0], CGI_TX), Cutscene_GetAttr(asher[0], CGI_TY));
			b->Clear(0);
			b->DrawCombo(0, 0, 0, 51077, 1, 2, 6, -1, -1, 0, 0, 0, -1, 0, true, 128);
			b->ReplaceColors(0, Choose(0x72, 0x73, 0x74), 0x01, 0xBF);
			Cutscene_NewBlit(1, b, 0, 0, 16, 32, CutX(asher[0])+VectorX(1, angle)+Choose(-1, 1), CutY(asher[0])-16+VectorY(1, angle)+Choose(-1, 1), 16, 32, 0);
			Cutscene_Waitframe();
		}
		Cutscene_Glide(asher[0], 0x0A, CutX(torrin[0]), CutY(torrin[0]), 4);
		int angle2 = Angle(CutX(asher[0]), CutY(asher[0]), Cutscene_GetAttr(asher[0], CGI_TX), Cutscene_GetAttr(asher[0], CGI_TY));
		while(!Cutscene_FinishedGlide(asher[0])){
			Cutscene_NewCircle(2, CutX(selet[0])+7+Rand(-1, 1), CutY(selet[0])-5+Rand(-1, 1), ((G[G_ANIM]%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
			int angle = Angle(CutX(asher[0]), CutY(asher[0]), Cutscene_GetAttr(asher[0], CGI_TX), Cutscene_GetAttr(asher[0], CGI_TY));
			b->Clear(0);
			b->DrawCombo(0, 0, 0, 51077, 1, 2, 6, -1, -1, 0, 0, 0, -1, 0, true, 128);
			b->ReplaceColors(0, Choose(0x72, 0x73, 0x74), 0x01, 0xBF);
			Cutscene_NewBlit(1, b, 0, 0, 16, 32, CutX(asher[0])+VectorX(1, angle)+Choose(-1, 1), CutY(asher[0])-16+VectorY(1, angle)+Choose(-1, 1), 16, 32, 0);
			Cutscene_Waitframe();
		}
		Cutscene_SetNPCGraphic(selet[0], -1, true);
		Cutscene_SetDir(selet[0], DIR_LEFT);
		Cutscene_Glide(selet[0], 0x0A, 160, 80, 2.5);
		Cutscene_SetNPCGraphic(asher[0], 51082, true);
		Cutscene_SetNPCGraphic(torrin[0], 51084, true);
		Game->PlaySound(11);
		Game->PlaySound(SFX_OUCH);
		Cutscene_GlideAccel(asher[0], 0x0A, CutX(asher[0])+VectorX(32, angle2+180), CutY(asher[0])+VectorY(32, angle2+180), 2, 0.05);
		Cutscene_GlideAccel(torrin[0], 0x0A, CutX(torrin[0])+VectorX(32, angle2), CutY(torrin[0])+VectorY(32, angle2), 2, 0.05);
		Cutscene_SwapDrawPtr(torrin, selet);
		Cutscene_Waitglide();
		Cutscene_SetNPCGraphic(asher[0], -1, true);
		Cutscene_SetNPCGraphic(torrin[0], -1, true);
		Cutscene_SetDir(asher[0], DIR_RIGHT);
		Cutscene_SetDir(torrin[0], DIR_DOWN);
		Cutscene_SetNPCGraphic(selet[0], 51085, true);
		
		Cutscene_PlayString("The two of you have just made a very grave mistake. Since negotiations have broken down, allow me to show you my leverage.", SCHAR_SELET, EMOTE_NORMAL, 68, YPOS_LOWER);
		
		Link->X = CutX(asher[0]);
		Link->Y = CutY(asher[0]);
		Link->Dir = DIR_RIGHT;
		for(i=0; i<32; ++i){
			Cutscene_NewRectangle(6, CutCamX()-8, CutCamY()-8, CutCamX()+255+8, CutCamY()+175+8, 0x0F, 1, 0, 0, 0, true, 128);
			Cutscene_Waitframe();
		}
		SetCutsceneSkip(CUTSCENE_NULL); //CUTSCENE_SELETMINES
		//Game->SetDMapEnhancedMusic(Game->GetCurDMap(), "SS-Selet.ogg", 0);
		Link->PitWarp(64, 0x0A);
		// Screen->SetSideWarp(0, 0x0A, 64, WT_IWARP);
		// Screen->ComboD[0] = CMB_AUTOWARPA;
		Cutscene_NewRectangle(6, CutCamX()-8, CutCamY()-8, CutCamX()+255+8, CutCamY()+175+8, 0x0F, 1, 0, 0, 0, true, 128);
		Cutscene_Waitframe();
	}
	void runPart2(){
		//G[G_CUTSCENEDEBUG] = 1;
		SetCutsceneSkip(CUTSCENE_POSTSELETMINES);
		bitmap b = Game->CreateBitmap(64, 32);
		b->Own();
		b->Clear(0);
		int i; int j; int k;
		int x; int y;
		int asherSwordTile = 65001;
		if(Link->Item[I_SWORD2])
			asherSwordTile = 65021;
		
		Cutscene_Init(RT_BITMAP1, RT_BITMAP2);
		Cutscene_AnchorCamera(0x2C, 0x2C, 1, 1);
		
		int selet[1];
		int asher[1];
		int torrin[1];
		int kaylani[1];
		
		selet[0] = Cutscene_NewNPC(2, 120, 48, 51088, 6, 128);
		Cutscene_SetFlag(asher[0], CGF_4WAY|CGF_BIGNPC);
		
		asher[0] = Cutscene_NewNPC(2, 112, 104, 51000, 6, 128);
		Cutscene_SetFlag(asher[0], CGF_4WAY|CGF_BS|CGF_BIGNPC);
		torrin[0] = Cutscene_NewNPC(2, 80, 80, 50952, 6, 128);
		Cutscene_SetFlag(torrin[0], CGF_4WAY|CGF_BS|CGF_BIGNPC);
		kaylani[0] = Cutscene_NewNPC(2, 160, 72, 50960, 6, 128);
		Cutscene_SetFlag(kaylani[0], CGF_4WAY|CGF_BS|CGF_BIGNPC);
		Cutscene_SetDir(asher[0], DIR_UP);
		Cutscene_SetDir(torrin[0], DIR_UP);
		Cutscene_SetDir(kaylani[0], DIR_UP);
		
		Cutscene_Waitframe(32);
		
		Cutscene_PlayString("I must say you boys are quite weak. Against an adept lunar mage, your swords and fists will do you no good.", SCHAR_SELET, EMOTE_NORMAL, 68, YPOS_LOWER);
	
		Cutscene_Waitframe(16);
		Cutscene_SetNPCGraphic(selet[0], 51083, true);
		Cutscene_Waitframe(16);
		for(i=0; i<16; ++i){
			Cutscene_Waitframe();
		}
		Cutscene_SetNPCGraphic(asher[0], 51096, true);
		Cutscene_SetNPCGraphic(torrin[0], 51097, true);
		Cutscene_SetNPCGraphic(kaylani[0], 51098, true);
		// b->Clear(0);
		// b->DrawCombo(0, 0, 0, 51096, 1, 2, 6, -1, -1, 0, 0, 0, -1, 0, true, 128);
		// b->DrawCombo(0, 16, 0, 51097, 1, 2, 6, -1, -1, 0, 0, 0, -1, 0, true, 128);
		// b->DrawCombo(0, 32, 0, 51098, 1, 2, 6, -1, -1, 0, 0, 0, -1, 0, true, 128);
		// b->ReplaceColors(0, Choose(0x72, 0x73, 0x74), 0x01, 0xBF);
		Cutscene_Waitframe(16);
		Game->PlaySound(78);
		for(i=0; i<32; ++i){
			DrawCastingCircle(selet, 3, 7, -5);
			DrawATKStun(b, asher, torrin, kaylani);
			Cutscene_Waitframe();
		}
		PlayString("I don't know what she told you to get you in on this plan, but I take it you now understand the \"gravity\" of your situation. This is the difference between us. ", SCHAR_SELET, EMOTE_NORMAL, 68, YPOS_LOWER);
		while(G[G_MSGACTIVE]){
			DrawCastingCircle(selet, 3, 7, -5);
			DrawATKStun(b, asher, torrin, kaylani);
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		for(i=0; i<16; ++i){
			DrawCastingCircle(selet, 3, 7, -5);
			DrawATKStun(b, asher, torrin, kaylani);
			Cutscene_Waitframe();
		}
		Cutscene_SetNPCGraphic(selet[0], 51086, true);
		
		int angle;
		angle = Angle(CutX(selet[0]), CutY(selet[0]), CutX(asher[0]), CutY(asher[0]));
		Cutscene_Glide(asher[0], 0x2C, CutX(asher[0])+VectorX(16, angle), 128, 2.5);
		angle = Angle(CutX(selet[0]), CutY(selet[0]), CutX(torrin[0]), CutY(torrin[0]));
		Cutscene_Glide(torrin[0], 0x2C, CutX(torrin[0])+VectorX(16, angle), 128, 2.5);
		angle = Angle(CutX(selet[0]), CutY(selet[0]), CutX(kaylani[0]), CutY(kaylani[0]));
		Cutscene_Glide(kaylani[0], 0x2C, CutX(kaylani[0])+VectorX(16, angle), 128, 2.5);
		
		for(i=0; i<16; ++i){
			if(Cutscene_JustFinishedGlide(asher[0])||Cutscene_JustFinishedGlide(torrin[0])||Cutscene_JustFinishedGlide(kaylani[0]))
				Game->PlaySound(108);
			DrawCastingCircle(selet, 3, 8, 12);
			DrawATKStun(b, asher, torrin, kaylani);
			Cutscene_Waitframe();
		}
		Cutscene_SetNPCGraphic(selet[0], 51080, true);
		for(i=0; i<16; ++i){
			if(Cutscene_JustFinishedGlide(asher[0])||Cutscene_JustFinishedGlide(torrin[0])||Cutscene_JustFinishedGlide(kaylani[0]))
				Game->PlaySound(108);
			DrawCastingCircle(selet, 3, 0, 7);
			DrawATKStun(b, asher, torrin, kaylani);
			Cutscene_Waitframe();
		}
		Cutscene_SetNPCGraphic(selet[0], 51099, true);
		Cutscene_Glide(selet[0], 0x2C, CutX(asher[0]), CutY(selet[0])+32, 0.5);
		while(!Cutscene_FinishedGlide(selet[0])){
			if(Cutscene_JustFinishedGlide(asher[0])||Cutscene_JustFinishedGlide(torrin[0])||Cutscene_JustFinishedGlide(kaylani[0]))
				Game->PlaySound(108);
			DrawCastingCircle(selet, 3, 0, 7);
			DrawATKStun(b, asher, torrin, kaylani);
			Cutscene_Waitframe();
		}
		Cutscene_SetNPCGraphic(selet[0], 51080, true);
		PlayString("As I said before, you had some leverage in this exchange. Had. Now that you've thrown that away, I'll make one final offer. Drop your weapons and beg for mercy.", SCHAR_SELET, EMOTE_NORMAL, 68, YPOS_UPPER); //PlayString("But as I said before, I'm a man of trade. Above all else, I look out for me and my own. Lay down your weapons and we can still negotiate terms.", SCHAR_SELET, EMOTE_NORMAL, 68, YPOS_UPPER);
		while(G[G_MSGACTIVE]){
			DrawCastingCircle(selet, 3, 0, 7);
			DrawATKStun(b, asher, torrin, kaylani);
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		Cutscene_SetNPCGraphic(asher[0], -1, true);
		Cutscene_Glide(asher[0], 0x2C, CutX(asher[0]), CutY(asher[0])-16, 0.3);
		while(!Cutscene_FinishedGlide(asher[0])){
			DrawCastingCircle(selet, 3, 0, 7);
			DrawATKStun(b, asher, torrin, kaylani);
			Cutscene_Waitframe();
		}
		for(i=0; i<16; ++i){
			DrawCastingCircle(selet, 3, 0, 7);
			DrawATKStun(b, asher, torrin, kaylani);
			Cutscene_Waitframe();
		}
		int sword[1];
		sword[0] = Cutscene_NewTile(1, CutX(asher[0]), CutY(asher[0])-12, asherSwordTile, 1, 1, 11, -1, -1, 0, 0, 0, 0, true, 128);
		Cutscene_SetAttr(sword[0], CGI_DRAWLIFESPAN, -1);
		Cutscene_SetFlag(sword[0], CGF_AUTOCENTER);
		Cutscene_SetNPCGraphic(asher[0], 51104, true);
		Game->PlaySound(SFX_SWORD);
		for(i=0; i<16; ++i){
			DrawCastingCircle(selet, 3, 0, 7);
			DrawATKStun(b, asher, torrin, kaylani);
			Cutscene_Waitframe();
		}
		PlayString("I'm...not giving up...just yet!", SCHAR_ASHER, EMOTE_NORMAL, 68, YPOS_UPPER);
		while(G[G_MSGACTIVE]){
			DrawCastingCircle(selet, 3, 0, 7);
			DrawATKStun(b, asher, torrin, kaylani);
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		Cutscene_SetNPCGraphic(asher[0], 51096, true);
		Cutscene_AddAttr(asher[0], CGI_Y, -2);
		Cutscene_AddAttr(sword[0], CGI_Y, -1);
		for(i=0; i<24; ++i){
			DrawCastingCircle(selet, 3, 0, 7);
			DrawATKStun(b, asher, torrin, kaylani);
			Cutscene_Waitframe();
		}
		Cutscene_AddAttr(asher[0], CGI_Y, 2);
		Cutscene_AddAttr(sword[0], CGI_Y, 1);
		Cutscene_Glide(sword[0], 0x2C, CutX(sword[0])+16, CutY(sword[0])+24, 1);
		PlayString("Ugh!", SCHAR_ASHER, EMOTE_NORMAL, 68, YPOS_UPPER);
		int kaylaniDat[3];
		Cutscene_Glide(kaylani[0], 0x2C, 160, 80, 0.5);
		Cutscene_SetDir(kaylani[0], DIR_LEFT);
		j = 0;
		k = 0;
		while(G[G_MSGACTIVE]){
			if(!Cutscene_FinishedGlide(sword[0]))
				Cutscene_AddAttr(sword[0], CGI_ROT, 4);
			if(Cutscene_JustFinishedGlide(sword[0]))
				Game->PlaySound(131);
			DrawCastingCircle(selet, 3, 0, 7);
			DrawATKStun(b, asher, torrin, kaylani);
			KaylaniSunballStuff(kaylani, kaylaniDat);
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		while(!Cutscene_FinishedGlide(sword[0])){
			if(Cutscene_JustFinishedGlide(sword[0]))
				Game->PlaySound(131);
			Cutscene_AddAttr(sword[0], CGI_ROT, 4);
			DrawCastingCircle(selet, 3, 0, 7);
			DrawATKStun(b, asher, torrin, kaylani);
			KaylaniSunballStuff(kaylani, kaylaniDat);
			Cutscene_Waitframe();
		}
		if(Cutscene_JustFinishedGlide(sword[0]))
			Game->PlaySound(131);
		PlayString("That's the spirit, Ash! We're gonna wipe that smug grin right off his face!", SCHAR_TORRIN, EMOTE_NORMAL, 68, YPOS_UPPER);
		while(G[G_MSGACTIVE]){
			DrawCastingCircle(selet, 3, 0, 7);
			DrawATKStun(b, asher, torrin, kaylani);
			KaylaniSunballStuff(kaylani, kaylaniDat);
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		Cutscene_Glide(torrin[0], 0x2C, CutX(selet[0]), CutY(selet[0]), 2);
		Cutscene_SetNPCGraphic(torrin[0], 51061, true);
		Cutscene_SetAttr(torrin[0], CGI_LAYER, 4);
		i = 0;
		while(!Cutscene_FinishedGlide(torrin[0])){
			++i;
			if(i==16){
				Cutscene_Glide(selet[0], 0x2C, CutX(selet[0]), CutY(selet[0])-16, 3);
				Cutscene_SetNPCGraphic(selet[0], 51099, true);
			}
			DrawCastingCircle(selet, 3, 0, 7);
			DrawATKStun(b, asher, torrin, kaylani);
			KaylaniSunballStuff(kaylani, kaylaniDat);
			Cutscene_Waitframe();
		}
		Game->PlaySound(SFX_SWORD);
		for(i=0; i<10; ++i){
			if(Cutscene_FinishedGlide(selet[0])){
				Cutscene_SetNPCGraphic(selet[0], 51083, true);
			}
			Cutscene_NewFastTile(2, CutX(torrin[0])+16, CutY(torrin[0]), 65030+Floor(i/2), 7, 128);
			if(Cutscene_GetAttr(selet[0], CGI_GFX)==51083)
				DrawCastingCircle(selet, 3, 7, -5);
			else
				DrawCastingCircle(selet, 3, 0, 7);
			DrawATKStun(b, asher, torrin, kaylani);
			KaylaniSunballStuff(kaylani, kaylaniDat);
			Cutscene_Waitframe();
		}
		Game->PlaySound(SFX_SWORD);
		Cutscene_SetNPCGraphic(selet[0], 51083, true);
		for(i=0; i<8; ++i){
			DrawCastingCircle(selet, 3, 7, -5);
			DrawATKStun(b, asher, torrin, kaylani);
			KaylaniSunballStuff(kaylani, kaylaniDat);
			Cutscene_Waitframe();
		}
		Cutscene_SetNPCGraphic(selet[0], 51086, true);
		Cutscene_SetNPCGraphic(torrin[0], 51097, true);
		Cutscene_Glide(selet[0], 0x2C, CutX(selet[0]), CutY(selet[0])+16, 3);
		Cutscene_GlideAccel(torrin[0], 0x2C, CutX(torrin[0]), CutY(torrin[0])+8, 1.5, 3);
		while(!Cutscene_FinishedGlide(selet[0])){
			DrawCastingCircle(selet, 3, 8, 12);
			DrawATKStun(b, asher, torrin, kaylani);
			KaylaniSunballStuff(kaylani, kaylaniDat);
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		Game->PlaySound(SFX_EHIT);
		Game->PlaySound(SFX_OUCH);
		int torrin2x2[1];
		torrin2x2[0] = Cutscene_NewTile(1, CutX(torrin[0])-8, CutY(torrin[0])-8, 105308, 2, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
		Cutscene_SetDrawPosition(torrin[0], 0x2C, -32, -32);
		Cutscene_SetAttr(torrin2x2[0], CGI_DRAWLIFESPAN, -1);
		Cutscene_SetNPCGraphic(selet[0], 51080, true);
		Cutscene_GlideAccel(torrin2x2[0], 0x2C, CutX(torrin2x2[0])-32, CutY(torrin2x2[0])+8, 2, 1);
		while(kaylaniDat[0]<1){
			DrawCastingCircle(selet, 3, 0, 7);
			DrawATKStun(b, asher, torrin, kaylani);
			KaylaniSunballStuff(kaylani, kaylaniDat);
			Cutscene_Waitframe();
		}
		while(kaylaniDat[0]<2){
			if(kaylaniDat[1]<80)
				kaylaniDat[1] += 4;
			DrawCastingCircle(selet, 3, 0, 7);
			DrawATKStun(b, asher, torrin, kaylani);
			KaylaniSunballStuff(kaylani, kaylaniDat);
			Cutscene_Waitframe();
		}
		kaylaniDat[0] = 3;
		kaylaniDat[1] = 0;
		Cutscene_SetNPCGraphic(kaylani[0], 51108, true);
		while(kaylaniDat[0]==3){
			DrawCastingCircle(selet, 3, 0, 7);
			DrawATKStun(b, asher, torrin, kaylani);
			KaylaniSunballStuff(kaylani, kaylaniDat);
			Cutscene_Waitframe();
		}
		for(i=0; i<24; i+=4){
			DrawCastingCircle(selet, 3, 0, 7);
			DrawATKStun(b, asher, torrin, kaylani);
			DrawBigShot(4, CutX(kaylani[0])-8-i, CutY(kaylani[0])+8, 2+6, 0, DIR_LEFT, G[G_ANIM]*4, G[G_ANIM]%4);
			Cutscene_Waitframe();
		}
		Cutscene_SetNPCGraphic(selet[0], 51109, true);
		for(i=0; i<32; ++i){
			DrawCastingCircle(selet, 3, 0, 7);
			DrawATKStun(b, asher, torrin, kaylani);
			DrawBigShot(4, CutX(selet[0])+24+Rand(-1, 1), CutY(selet[0])+8+Rand(-1, 1), 2+6, 0, DIR_LEFT, G[G_ANIM]*4, G[G_ANIM]%4);
			Cutscene_Waitframe();
		}
		Game->PlaySound(78);
		for(i=0; i<40; i+=4){
			DrawCastingCircle(selet, 3, 0, 7);
			DrawATKStun(b, asher, torrin, kaylani);
			DrawBigShot(4, CutX(selet[0])+24+i, CutY(selet[0])+8, 2+6, 0, DIR_LEFT, G[G_ANIM]*4, G[G_ANIM]%4);
			Cutscene_Waitframe();
		}
		Game->PlaySound(SFX_EHIT);
		Game->PlaySound(SFX_OUCHKAYLANI);
		Cutscene_SetNPCGraphic(selet[0], 51080, true);
		Cutscene_SetNPCGraphic(kaylani[0], 51110, true);
		Cutscene_Glide(kaylani[0], 0x2C, 224, CutY(kaylani[0]), 2.5);
		while(!Cutscene_FinishedGlide(kaylani[0])){
			DrawCastingCircle(selet, 3, 0, 7);
			DrawATKStun(b, asher, torrin, 0);
			Cutscene_Waitframe();
		}
		Game->PlaySound(SFX_BOMB);
		Game->PlaySound(SFX_OUCHKAYLANI);
		int kaylani2x2[1];
		kaylani2x2[0] = Cutscene_NewTile(2, CutX(kaylani[0])-8, CutY(kaylani[0])-8, 105467, 2, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
		Cutscene_SetAttr(kaylani2x2[0], CGI_DRAWLIFESPAN, -1);
		Cutscene_SetDrawPosition(kaylani[0], -16, -16);
		Cutscene_GlideAccel(kaylani2x2[0], 0x2C, CutX(kaylani2x2[0])-32, CutY(kaylani2x2[0])+8, 2, 1);
		while(!Cutscene_FinishedGlide(kaylani2x2[0])){
			DrawCastingCircle(selet, 3, 0, 7);
			DrawATKStun(b, asher, torrin, kaylani);
			Cutscene_Waitframe();
		}
		Cutscene_SetNPCGraphic(selet[0], 51112, true);
		PlayString("Oh who am I kidding? You'd already chosen death.", SCHAR_SELET, EMOTE_NORMAL, 68, YPOS_UPPER);
		while(G[G_MSGACTIVE]){
			DrawCastingCircle(selet, 3, 0, 7);
			DrawATKStun(b, asher, torrin, kaylani);
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		Cutscene_Glide(sword[0], 0x2C, CutX(torrin2x2[0])+8, CutY(torrin2x2[0])-64, 1);
		Cutscene_SetAttr(sword[0], CGI_LAYER, 4);
		Cutscene_SetNPCGraphic(selet[0], 51113, true);
		while(!Cutscene_FinishedGlide(sword[0])){
			Cutscene_SetAttr(sword[0], CGI_ROT, TurnToAngle(Cutscene_GetAttr(sword[0], CGI_ROT), 180, 5));
			DrawCastingCircle(selet, 3, 1, 1);
			DrawATKStun(b, asher, torrin, kaylani, sword);
			Cutscene_Waitframe();
		}
		Cutscene_SetNPCGraphic(asher[0], -1, true);
		for(i=0; i<32; ++i){
			if(i%4==0)
				Cutscene_AddAttr(sword[0], CGI_X, -1);
			else if(i%4==2)
				Cutscene_AddAttr(sword[0], CGI_X, 1);
			DrawCastingCircle(selet, 3, 1, 1);
			DrawATKStun(b, 0, torrin, kaylani, sword);
			Cutscene_Waitframe();
		}
		Game->PlayEnhancedMusic("SS-Loss.ogg", 0);
		PlayString("Don't you DARE touch him!", SCHAR_ASHER, EMOTE_FURIOUS, 68, YPOS_LOWER);
		Cutscene_SetNPCGraphic(asher[0], 51104, true);
		Cutscene_SetAttr(asher[0], CGI_LAYER, 4);
		while(G[G_MSGACTIVE]){
			DrawCastingCircle(selet, 3, 1, 1);
			DrawATKStun(b, 0, torrin, kaylani, sword);
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		
		angle = -90;
		Game->PlaySound(SFX_STELLARSWORD_APPEAR);
		for(i=1; i<6; ++i){
			for(j=0; j<2; ++j){
				Cutscene_DrawLightSwordSlash(CutX(asher[0]), CutY(asher[0]), angle-45, 16, i, 0, 0, 0);
				DrawCastingCircle(selet, 3, 1, 1);
				DrawATKStun(b, 0, torrin, kaylani, sword);
				Cutscene_Waitframe();
			}
		}
		Cutscene_SetNPCGraphic(selet[0], -1, true);
		Cutscene_SetDir(selet[0], DIR_DOWN);
		Cutscene_Glide(selet[0], 0x2C, 144, 40, 2);
		Cutscene_Glide(sword[0], 0x2C, 48, 96, 4);
		for(i=0; i<32; ++i){
			if(!Cutscene_FinishedGlide(sword[0]))
				Cutscene_SetAttr(sword[0], CGI_ROT, TurnToAngle(Cutscene_GetAttr(sword[0], CGI_ROT), 135, 10));
			Cutscene_DrawLightSwordSlash(CutX(asher[0]), CutY(asher[0]), angle-45, 16, 5, 0, 0, 0);
			Cutscene_Waitframe();
		}
		Game->PlaySound(SFX_STELLARSWORD_SLASH);
		Cutscene_GlideRelative(asher[0], 0x2C, 8, -16, 1);
		Cutscene_SetNPCGraphic(selet[0], 51115, true);
		for(i=0; i<13; ++i){
			if(i==7)
				Cutscene_GlideRelativeAccel(selet[0], 0x2C, 4, -8, 4, 1);
			int til = TIL_STELLARSLASH;
			int frame;
			if(i>11)
				frame = 3;
			else if(i>9)
				frame = 2;
			else if(i>7)
				frame = 1;
			Cutscene_DrawLightSwordSlash(CutX(asher[0]), CutY(asher[0]), angle+45, 16, 5, 0, 1, frame);
			Cutscene_Waitframe();
		}
		for(i=4; i>0; --i){
			for(j=0; j<2; ++j){
				Cutscene_DrawLightSwordSlash(CutX(asher[0]), CutY(asher[0]), angle+45, 16, i, 0, 0, 0);
				Cutscene_Waitframe();
			}
		}
		Cutscene_SetDrawPosition(kaylani[0], CutX(kaylani2x2[0])+8, CutY(kaylani2x2[0])+8);
		Cutscene_SetDrawPosition(kaylani2x2[0], -32, -32);
		Cutscene_SetNPCGraphic(kaylani[0], 51029, true);
		Cutscene_SetNPCGraphic(asher[0], -1, true);
		Cutscene_SetDir(asher[0], DIR_RIGHT);
		Cutscene_Glide(asher[0], 0x2C, CutX(torrin2x2[0])+24, CutY(torrin2x2[0])-8, 2);
		Cutscene_Waitframe(16);
		Cutscene_SetDir(selet[0], DIR_LEFT);
		Cutscene_SetNPCGraphic(selet[0], -1, true);
		Cutscene_GlideRelative(selet[0], 0x2C, 16, 32, 2);
		Cutscene_Waitglide();
		PlayString("(It can't be...!)", SCHAR_KAYLANI, EMOTE_SURPRISED, 68, YPOS_UPPER);
		while(G[G_MSGACTIVE]){
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		PlayString("My stars! It's you!? How could you have that power?", SCHAR_SELET, EMOTE_EXCLAMATION, 68, YPOS_UPPER);
		while(G[G_MSGACTIVE]){
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		Cutscene_SetNPCGraphic(asher[0], 51114, true);
		PlayString("That's... that a good question. How...", SCHAR_ASHER, EMOTE_QUESTION, 68, YPOS_UPPER);
		while(G[G_MSGACTIVE]){
			DrawCastingCircle2(asher, 2, 13, 6);
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		for(i=0; i<32; ++i){
			DrawCastingCircle2(asher, 2, 13, 6);
			Cutscene_Waitframe();
		}
		Cutscene_SetNPCGraphic(asher[0], 51116, true);
		for(i=0; i<48; ++i){
			DrawCastingCircle2(asher, 2, 13, 6);
			Cutscene_Waitframe();
		}
		Cutscene_SetNPCGraphic(asher[0], -1, true);
		PlayString("...Doesn't matter. I have to stop him.", SCHAR_ASHER, EMOTE_NORMAL, 68, YPOS_UPPER);
		while(G[G_MSGACTIVE]){
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		Game->PlaySound(72);
		Cutscene_Glide(asher[0], 0x2C, 160, 32, 3);
		Cutscene_Waitglide();
		Cutscene_SetDir(asher[0], DIR_DOWN);
		Cutscene_SetNPCGraphic(asher[0], 51105, true);
		
		Cutscene_SetDir(selet[0], DIR_RIGHT);
		Cutscene_GlideRelative(selet[0], 0x2C, -24, 8, 2);
		
		angle = 90;
		Game->PlaySound(SFX_STELLARSWORD_APPEAR);
		for(i=1; i<6; ++i){
			for(j=0; j<2; ++j){
				Cutscene_DrawLightSwordSlash(CutX(asher[0]), CutY(asher[0]), angle, 16, i, 0, 0, 0);
				Cutscene_Waitframe();
			}
		}
		Cutscene_GlideRelative(asher[0], 0x2C, 0, 64, 4);
		for(i=0; i<16; ++i){
			Cutscene_DrawLightSwordSlash(CutX(asher[0]), CutY(asher[0]), angle, 16, 5, 0, 0, 0);
			Cutscene_Waitframe();
		}
		for(i=4; i>0; --i){
			for(j=0; j<2; ++j){
				Cutscene_DrawLightSwordSlash(CutX(asher[0]), CutY(asher[0]), angle, 16, i, 0, 0, 0);
				Cutscene_Waitframe();
			}
		}
		Cutscene_SetDir(asher[0], DIR_LEFT);
		Cutscene_SetNPCGraphic(asher[0], -1, true);
		Cutscene_GlideRelative(asher[0], 0x2C, -16, -16, 0.5);
		Cutscene_GlideRelative(selet[0], 0x2C, -32, -8, 1);
		
		Cutscene_Waitglide();
		Cutscene_SetNPCGraphic(asher[0], 51106, true);
		
		bitmap melt = Game->CreateBitmap(32, 32);
		melt->Own();
		int meltSpeed[18];
		int seletTeleport[2];
		
		angle = 180;
		Game->PlaySound(SFX_STELLARSWORD_APPEAR);
		for(i=1; i<6; ++i){
			for(j=0; j<2; ++j){
				Cutscene_DrawLightSwordSlash(CutX(asher[0]), CutY(asher[0]), angle-90, 16, i, 0, 0, 0);
				Cutscene_Waitframe();
			}
		}
		for(i=0; i<16; ++i){
			Cutscene_DrawLightSwordSlash(CutX(asher[0]), CutY(asher[0]), angle-90, 16, 5, 0, 0, 0);
			Cutscene_Waitframe();
		}
		Game->PlaySound(SFX_STELLARSWORD_SLASH);
		Cutscene_GlideRelative(asher[0], 0x2C, 8, -32, 1);
		Cutscene_SetNPCGraphic(selet[0], 51117, true);
		for(i=-45; i<90; i+=15){
			if(i==0){
				Cutscene_GlideRelativeAccel(selet[0], 0x2C, -8, -4, 4, 1);
			}
			Cutscene_DrawLightSwordSlash(CutX(asher[0]), CutY(asher[0]), angle+i, 16, 5, 0, 1, 0);
			Cutscene_Waitframe();
		}
		for(i=0; i<13; ++i){
			int til = TIL_STELLARSLASH;
			int frame;
			if(i>11)
				frame = 3;
			else if(i>9)
				frame = 2;
			else if(i>7)
				frame = 1;
			Cutscene_DrawLightSwordSlash(CutX(asher[0]), CutY(asher[0]), angle+90, 16, 5, 0, 1, frame);
			Cutscene_Waitframe();
		}
		for(i=0; i<8; ++i){
			Cutscene_DrawLightSwordSlash(CutX(asher[0]), CutY(asher[0]), angle+90, 16, 5, 0, 0, 0);
			Cutscene_Waitframe();
		}
		Game->PlaySound(SFX_STELLARSWORD_SLASH);
		Cutscene_GlideRelative(asher[0], 0x2C, -16, 0, 1);
		for(i=45; i>-90; i-=15){
			if(i<=0)
				SeletTeleport(selet, melt, meltSpeed, seletTeleport, 120, 128, DIR_UP);
			Cutscene_DrawLightSwordSlash(CutX(asher[0]), CutY(asher[0]), angle+i, 16, 5, 0, -1, 0);
			Cutscene_Waitframe();
		}
		for(i=0; i<13; ++i){
			int til = TIL_STELLARSLASH;
			int frame;
			if(i>11)
				frame = 3;
			else if(i>9)
				frame = 2;
			else if(i>7)
				frame = 1;
			SeletTeleport(selet, melt, meltSpeed, seletTeleport, 120, 128, DIR_UP);
			Cutscene_DrawLightSwordSlash(CutX(asher[0]), CutY(asher[0]), angle-90, 16, 5, 0, -1, frame);
			Cutscene_Waitframe();
		}
		for(i=4; i>0; --i){
			for(j=0; j<2; ++j){
				SeletTeleport(selet, melt, meltSpeed, seletTeleport, 120, 128, DIR_UP);
				Cutscene_DrawLightSwordSlash(CutX(asher[0]), CutY(asher[0]), angle-90, 16, i, 0, 0, 0);
				Cutscene_Waitframe();
			}
		}
		Cutscene_SetDir(asher[0], DIR_DOWN);
		Cutscene_SetNPCGraphic(asher[0], -1, true);
		while(seletTeleport[0]<3){
			SeletTeleport(selet, melt, meltSpeed, seletTeleport, 120, 128, DIR_UP);
			Cutscene_Waitframe();
		}
		
		Cutscene_SetNPCGraphic(selet[0], 51118, true);
		PlayString("Yes! That's it! You're the one I've been searching for. Now come at me! Burn yourself out and relinquish that power to me!", SCHAR_SELET, EMOTE_NORMAL, 68, YPOS_UPPER);
		while(G[G_MSGACTIVE]){
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		Cutscene_SetNPCGraphic(asher[0], 51119, true);
		for(i=0; i<32; ++i){
			DrawCastingCircle2(asher, 5, 0, 2);
			DrawCastingCircle2(asher, 5, 15, 2);
			Cutscene_Waitframe();
		}
		Cutscene_SetNPCGraphic(kaylani[0], -1, true);
		Cutscene_SetDir(kaylani[0], DIR_LEFT);
		Cutscene_GlideRelative(kaylani[0], 0x2C, -16, -16, 1);
		PlayString("Asher, you have to get out of here, now!", SCHAR_KAYLANI, EMOTE_DISMAYED, 68, YPOS_LOWER);
		while(G[G_MSGACTIVE]){
			DrawCastingCircle2(asher, 5, 0, 2);
			DrawCastingCircle2(asher, 5, 15, 2);
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		PlayString("But Torrin an-", SCHAR_ASHER, EMOTE_NORMAL, 68, YPOS_LOWER);
		while(G[G_MSGACTIVE]){
			DrawCastingCircle2(asher, 5, 0, 2);
			DrawCastingCircle2(asher, 5, 15, 2);
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		PlayString("I'll find a way out of this! But you have to trust me, just run!", SCHAR_KAYLANI, EMOTE_NORMAL, 68, YPOS_LOWER);
		while(G[G_MSGACTIVE]){
			DrawCastingCircle2(asher, 5, 0, 2);
			DrawCastingCircle2(asher, 5, 15, 2);
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		for(i=0; i<16; ++i){
			DrawCastingCircle2(asher, 5, 0, 2);
			DrawCastingCircle2(asher, 5, 15, 2);
			Cutscene_Waitframe();
		}
		Cutscene_SetNPCGraphic(asher[0], 51121, true);
		for(i=0; i<64; ++i){
			DrawCastingCircle2(asher, 5, 0, 2);
			DrawCastingCircle2(asher, 5, 15, 2);
			Cutscene_Waitframe();
		}
		Cutscene_SetNPCGraphic(asher[0], 51119, true);
		for(i=0; i<32; ++i){
			DrawCastingCircle2(asher, 5, 0, 2);
			DrawCastingCircle2(asher, 5, 15, 2);
			Cutscene_Waitframe();
		}
		Cutscene_SetNPCGraphic(asher[0], 51122, true);
		for(i=0; i<32; ++i){
			DrawCastingCircle2(asher, 5, 0, 2);
			DrawCastingCircle2(asher, 5, 15, 2);
			Cutscene_Waitframe();
		}
		PlayString("Sorry... but I can't run now. I'm done with running.", SCHAR_ASHER, EMOTE_ANGRY, 68, YPOS_LOWER);
		while(G[G_MSGACTIVE]){
			DrawCastingCircle2(asher, 5, 0, 2);
			DrawCastingCircle2(asher, 5, 15, 2);
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		int glowFrames[1];
		int quakeFrames[1];
		int shadow[1];
		shadow[0] = Cutscene_NewFastTile(0, CutX(asher[0]), CutY(asher[0]), 832, 7, 128);
		Cutscene_SetAttr(shadow[0], CGI_DRAWLIFESPAN, -1);
		Cutscene_SetNPCGraphic(asher[0], 51123, true);
		Cutscene_GlideRelativeAccel(asher[0], 0x2C, 0, -32, 0.5, 0.1);
		while(!Cutscene_FinishedGlide(asher[0])){
			k = Floor(G[G_ANIM]/4)%4;
			if(k==3)
				k = 1;
			Cutscene_NewTile(2, CutX(asher[0])+Rand(-1, 1), CutY(asher[0])+Rand(-1, 1)-16, TIL_ASTER_LUMINAIRE+40-20+40*k, 1, 2, 0, -1, -1, 0, 0, 0, 0, true, 128);
			
			LoopingSFX(glowFrames, 96, SFX_METEORGLOW);
			LoopingSFX(quakeFrames, 64, SFX_METEORSHAKE);
			Cutscene_Waitframe();
		}
		Cutscene_SetNPCGraphic(kaylani[0], 51059, true);
		Cutscene_GlideRelative(kaylani[0], 0x2C, -24, -16, 2);
		Cutscene_SetNPCGraphic(asher[0], 51124, true);
		PlayString("No! Don't do it Asher! You have no idea how to control that magic!", SCHAR_KAYLANI, EMOTE_NORMAL, 68, YPOS_LOWER);
		y = CutY(asher[0]);
		while(G[G_MSGACTIVE]){
			k = Floor(G[G_ANIM]/4)%4;
			if(k==3)
				k = 1;
			Cutscene_SetAttr(asher[0], CGI_Y, y+Sin(G[G_ANIM]*2));
			Cutscene_NewTile(2, CutX(asher[0])+Rand(-1, 1), CutY(asher[0])+Rand(-1, 1)-16, TIL_ASTER_LUMINAIRE+40-20+40*k+1+Floor(G[G_ANIM]/4)%4, 1, 2, 0, -1, -1, 0, 0, 0, 0, true, 128);
			LoopingSFX(glowFrames, 96, SFX_METEORGLOW);
			LoopingSFX(quakeFrames, 64, SFX_METEORSHAKE);
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		Game->PlaySound(75);
		for(i=0; i<256; i+=8){
			Cutscene_SetAttr(asher[0], CGI_Y, y+Sin(G[G_ANIM]*2));
			Cutscene_NewTile(2, CutX(asher[0])+Rand(-1, 1), CutY(asher[0])+Rand(-1, 1)-16, TIL_ASTER_LUMINAIRE+40-20+40*k+1+Floor(G[G_ANIM]/4)%4, 1, 2, 0, -1, -1, 0, 0, 0, 0, true, 128);
			Cutscene_NewEllipse(6, CutX(asher[0])+8, CutY(asher[0])+8, i, i*0.6666, Choose(0x91, 0x96, 0x98), 1, 0, 0, 0, true, 128);
			Cutscene_Waitframe();
		}
		for(i=0; i<16; ++i){
			j = 0x98;
			if(i>=12)
				j = 0x91;
			else if(i>=8)
				j = 0x96;
			else if(i>=4)
				j = 0x97;
			Cutscene_NewRectangle(6, 0, 0, 256, 176, j, 1, 0, 0, 0, true, 128);
			Cutscene_Waitframe();
		}
		PlayString("My precious treasure...My guiding star!", SCHAR_SELET, EMOTE_NORMAL, 68, YPOS_UPPER);
		y = CutY(asher[0]);
		while(G[G_MSGACTIVE]){
			Cutscene_NewRectangle(6, 0, 0, 256, 176, 0x91, 1, 0, 0, 0, true, 128);
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		//G[G_CUTSCENEDEBUG] = 0;
		for(i=0; i<16; ++i){
			j = 0xB2;
			if(i>=12)
				j = 0xB5;
			else if(i>=8)
				j = 0xB4;
			else if(i>=4)
				j = 0xB3;
			Cutscene_NewRectangle(6, 0, 0, 256, 176, j, 1, 0, 0, 0, true, 128);
			Cutscene_Waitframe();
		}
		
		Game->DMapPalette[Game->GetCurDMap()] = 0x0C2;
		
		for(i=0; i<16; ++i){
			Cutscene_NewRectangle(6, 0, 0, 256, 176, 0x0F, 1, 0, 0, 0, true, 128);
			Cutscene_NewScreen(6, 16, 0x13, 0, 0, 0);
			if(i<4)
				Cutscene_NewRectangle(6, 0, 0, 256, 176, 0x0F, 1, 0, 0, 0, true, 64);
			if(i<8)
				Cutscene_NewRectangle(6, 0, 0, 256, 176, 0x0F, 1, 0, 0, 0, true, 64);
			if(i<12)
				Cutscene_NewRectangle(6, 0, 0, 256, 176, 0x0F, 1, 0, 0, 0, true, 64);
			Cutscene_Waitframe();
		}
		int meteor[1];
		meteor[0] = Cutscene_NewFastTile(0, 224, -16, 65456, 0, 128);
		Cutscene_SetAttr(meteor[0], CGI_DRAWLIFESPAN, -1);
		Cutscene_Glide(meteor[0], 0x2C, 176, 96, 0.2);
		
		i = Rand(360);
		while(!Cutscene_FinishedGlide(meteor[0])){
			k = Distance(CutX(meteor[0]), CutY(meteor[0]), Cutscene_GetAttr(meteor[0], CGI_TX), Cutscene_GetAttr(meteor[0], CGI_TY));
			if(Cutscene_GetAttr(meteor[0], CGI_Y)>12){
				Cutscene_SetAttr(meteor[0], CGI_MOVESTEP, Lerp(2, 0.2, (96-CutY(meteor[0]))/84));
			}
			Cutscene_NewRectangle(6, 0, 0, 256, 176, 0x0F, 1, 0, 0, 0, true, 128);
			Cutscene_NewScreen(6, 16, 0x13, 0, 0, 0);
			if(Cutscene_GetAttr(meteor[0], CGI_Y)<12){
				Cutscene_NewFastCombo(6, CutX(meteor[0]), CutY(meteor[0]), 51125, 9, 128);
			}
			else{
				j = Lerp(2, 16, Cutscene_GetAttr(meteor[0], CGI_MOVESTEP)/2);
				Cutscene_NewTile(6, CutX(meteor[0])+8-0.5*j, CutY(meteor[0])+8-0.5*j, 66059, 1, 1, 11, j, j, CutX(meteor[0])+8-0.5*j, CutY(meteor[0])+8-0.5*j, i, 0, true, 128);
			}
			Cutscene_NewLayer(6, 16, 0x82, 0, 0, 0, 0, 128);
			Cutscene_NewLayer(6, 16, 0x13, 1, 0, 0, 0, 128);
			Cutscene_NewLayer(6, 16, 0x13, 3, 0, 0, 0, 128);
			Cutscene_NewLayer(6, 16, 0x13, 4, 0, 0, 0, 128);
			i = WrapDegrees(i+10);
			Cutscene_Waitframe();
		}
		Game->PlaySound(37);
		Game->PlaySound(75);
		Game->PlaySound(26);
		Game->PlaySound(74);
		j = 1;
		for(i=0; i<128; i+=j){
			++j;
			Cutscene_NewRectangle(6, 0, 0, 256, 176, 0x0F, 1, 0, 0, 0, true, 128);
			Cutscene_NewScreen(6, 16, 0x13, 0, 0, 0);
			Cutscene_NewRectangle(6, CutX(meteor[0])+8-i, 0, CutX(meteor[0])+8+i, 176, 0x01, 1, 0, 0, 0, true, 128);
			Cutscene_NewLayer(6, 16, 0x82, 0, 0, 0, 0, 128);
			Cutscene_NewLayer(6, 16, 0x13, 1, 0, 0, 0, 128);
			Cutscene_NewLayer(6, 16, 0x13, 3, 0, 0, 0, 128);
			Cutscene_NewLayer(6, 16, 0x13, 4, 0, 0, 0, 128);
			
			Cutscene_Waitframe();
		}
		Game->DMapPalette[Game->GetCurDMap()] = 0x0A1;
		for(i=0; i<64; ++i){
			Cutscene_NewRectangle(6, 0, 0, 256, 176, 0x0F, 1, 0, 0, 0, true, 128);
			Cutscene_Waitframe();
		}
		
		Cutscene_SetNPCGraphic(kaylani[0], -1, true);
		Cutscene_AddDrawPosition(asher[0], 128, 96);
		Cutscene_AddDrawPosition(torrin2x2[0], 128, 96);
		Cutscene_AddDrawPosition(kaylani[0], 128, 96);
		Cutscene_AddDrawPosition(sword[0], 128, 96);
		Cutscene_AddDrawPosition(selet[0], 128, 96);
		Cutscene_AddDrawPosition(shadow[0], 128, 96);
		
		y = CutY(asher[0]);
		
		Cutscene_AnchorCamera(0x0B, 0x0B, 2, 2);
		Cutscene_SetCameraPosition(128, 96);
		for(i=0; i<16; ++i){
			if(i<4)
				Cutscene_NewRectangle(6, 128, 96, 128+256, 96+176, 0x0F, 1, 0, 0, 0, true, 64);
			if(i<8)
				Cutscene_NewRectangle(6, 128, 96, 128+256, 96+176, 0x0F, 1, 0, 0, 0, true, 64);
			if(i<12)
				Cutscene_NewRectangle(6, 128, 96, 128+256, 96+176, 0x0F, 1, 0, 0, 0, true, 64);
			k = Floor(G[G_ANIM]/4)%4;
			if(k==3)
				k = 1;
			Cutscene_SetAttr(asher[0], CGI_Y, y+Sin(G[G_ANIM]*2));
			Cutscene_NewTile(2, CutX(asher[0])+Rand(-1, 1), CutY(asher[0])+Rand(-1, 1)-16, TIL_ASTER_LUMINAIRE+40-20+40*k+1+Floor(G[G_ANIM]/4)%4, 1, 2, 0, -1, -1, 0, 0, 0, 0, true, 128);
			LoopingSFX(glowFrames, 96, SFX_METEORGLOW);
			Cutscene_Waitframe();
		}
		Cutscene_SetCameraTarget(256, 96, 4);
		while(!Cutscene_CameraFinishedMoving()){
			k = Floor(G[G_ANIM]/4)%4;
			if(k==3)
				k = 1;
			Cutscene_SetAttr(asher[0], CGI_Y, y+Sin(G[G_ANIM]*2));
			Cutscene_NewTile(2, CutX(asher[0])+Rand(-1, 1), CutY(asher[0])+Rand(-1, 1)-16, TIL_ASTER_LUMINAIRE+40-20+40*k+1+Floor(G[G_ANIM]/4)%4, 1, 2, 0, -1, -1, 0, 0, 0, 0, true, 128);
			LoopingSFX(glowFrames, 96, SFX_METEORGLOW);
			Cutscene_Waitframe();
		}
		for(i=0; i<32; ++i){
			k = Floor(G[G_ANIM]/4)%4;
			if(k==3)
				k = 1;
			Cutscene_SetAttr(asher[0], CGI_Y, y+Sin(G[G_ANIM]*2));
			Cutscene_NewTile(2, CutX(asher[0])+Rand(-1, 1), CutY(asher[0])+Rand(-1, 1)-16, TIL_ASTER_LUMINAIRE+40-20+40*k+1+Floor(G[G_ANIM]/4)%4, 1, 2, 0, -1, -1, 0, 0, 0, 0, true, 128);
			LoopingSFX(glowFrames, 96, SFX_METEORGLOW);
			Cutscene_Waitframe();
		}
		int exLayer[16];
		Game->PlaySound(37);
		Game->PlaySound(120);
		Game->PlaySound(105);
		quakeFrames[0] = 0;
		glowFrames[0] = 0;
		
		Cutscene_SetNPCGraphic(selet[0], 51126, -1);
		Cutscene_SetDrawPosition(kaylani2x2[0], CutX(kaylani[0]), CutY(kaylani[0]));
		Cutscene_SetDrawPosition(kaylani[0], -32, -32);
		
		Cutscene_GlideRelative(selet[0], -1, -4, -16, 0.5);
		Cutscene_GlideRelative(torrin2x2[0], -1, -8, -24, 0.75);
		Cutscene_GlideRelative(sword[0], -1, -16, 4, 0.75);
		Cutscene_GlideRelative(kaylani2x2[0], -1, 8, -16, 0.75);
		
		exLayer[0] = Cutscene_NewLayer(1, 20, 0x09, 0, 256, 0, 0, 128);
		Cutscene_SetAttr(exLayer[0], CGI_DRAWLIFESPAN, -1);
		exLayer[1] = Cutscene_NewLayer(1, 20, 0x19, 0, 256, 176, 0, 128);
		Cutscene_SetAttr(exLayer[1], CGI_DRAWLIFESPAN, -1);
		for(i=0; i<128; ++i){
			k = Floor(G[G_ANIM]/4)%4;
			if(k==3)
				k = 1;
			Cutscene_SetAttr(asher[0], CGI_Y, y+Sin(G[G_ANIM]*2));
			Cutscene_NewTile(2, CutX(asher[0])+Rand(-1, 1), CutY(asher[0])+Rand(-1, 1)-16, TIL_ASTER_LUMINAIRE+40-20+40*k+1+Floor(G[G_ANIM]/4)%4, 1, 2, 0, -1, -1, 0, 0, 0, 0, true, 128);
			LoopingSFX(glowFrames, 96, SFX_METEORGLOW);
			Cutscene_SetCameraPosition(256, 96+64*Sin((i/128)*360*16));
			Cutscene_Waitframe();
		}
		Cutscene_SetCameraPosition(256, 96);
		Cutscene_SetCameraTarget(128, 96, 4);
		while(!Cutscene_CameraFinishedMoving()){
			k = Floor(G[G_ANIM]/4)%4;
			if(k==3)
				k = 1;
			Cutscene_SetAttr(asher[0], CGI_Y, y+Sin(G[G_ANIM]*2));
			Cutscene_NewTile(2, CutX(asher[0])+Rand(-1, 1), CutY(asher[0])+Rand(-1, 1)-16, TIL_ASTER_LUMINAIRE+40-20+40*k+1+Floor(G[G_ANIM]/4)%4, 1, 2, 0, -1, -1, 0, 0, 0, 0, true, 128);
			LoopingSFX(glowFrames, 96, SFX_METEORGLOW);
			Cutscene_Waitframe();
		}
		for(i=0; i<32; ++i){
			k = Floor(G[G_ANIM]/4)%4;
			if(k==3)
				k = 1;
			Cutscene_SetAttr(asher[0], CGI_Y, y+Sin(G[G_ANIM]*2));
			Cutscene_NewTile(2, CutX(asher[0])+Rand(-1, 1), CutY(asher[0])+Rand(-1, 1)-16, TIL_ASTER_LUMINAIRE+40-20+40*k+1+Floor(G[G_ANIM]/4)%4, 1, 2, 0, -1, -1, 0, 0, 0, 0, true, 128);
			LoopingSFX(glowFrames, 96, SFX_METEORGLOW);
			Cutscene_Waitframe();
		}
		Cutscene_SetNPCGraphic(asher[0], 51127, true);
		Cutscene_Glide(asher[0], -1, CutX(shadow[0]), CutY(shadow[0]), 2);
		Game->PlaySound(87);
		Audio->EndSound(SFX_METEORGLOW);
		while(!Cutscene_FinishedGlide(asher[0])){
			Cutscene_Waitframe();
		}
		Cutscene_SetDrawPosition(shadow[0], -32, -32);
		Game->PlaySound(SFX_OUCH);
		int asher2x2[1];
		asher2x2[0] = Cutscene_NewTile(2, CutX(asher[0])-8, CutY(asher[0])-8, 105306, 2, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
		Cutscene_SetDrawPosition(asher[0], -32, -32);
		Cutscene_SetAttr(asher2x2[0], CGI_DRAWLIFESPAN, -1);
		Cutscene_Waitframe(32);
		Cutscene_SetNPCGraphic(selet[0], -1, true);
		Cutscene_Waitframe(32);
		Cutscene_SetNPCGraphic(selet[0], 51118, true);
		PlayString("Ahaha! Yes...Magnificent! When these new batteries hit the black market, I'll become rich beyond my wildest dreams. And the best is still yet to come...", SCHAR_SELET, EMOTE_NORMAL, 68, YPOS_UPPER);
		while(G[G_MSGACTIVE]){
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		Cutscene_SetNPCGraphic(selet[0], 51086, true);
		for(i=0; i<16; ++i){
			DrawCastingCircle(selet, 3, 8, 12);
			Cutscene_Waitframe();
		}
		Cutscene_SetNPCGraphic(selet[0], 51083, true);
		Cutscene_SetNPCGraphic(asher[0], 51127, true);
		Cutscene_SetDrawPosition(asher[0], CutX(asher2x2[0])+8, CutY(asher2x2[0])+8);
		Cutscene_SetDrawPosition(asher2x2[0], -32, -32);
		Cutscene_GlideRelative(asher[0], -1, 0, -32, 1);
		Game->PlaySound(78);
		while(!Cutscene_FinishedGlide(asher[0])){
			DrawCastingCircle(selet, 3, 7, -5);
			DrawATKStun(b, asher, 0, 0);
			Cutscene_Waitframe();
		}
		Cutscene_SetNPCGraphic(selet[0], 51080, true);
		Cutscene_Glide(asher[0], -1, CutX(selet[0])+16, CutY(selet[0])-24, 1);
		while(!Cutscene_FinishedGlide(asher[0])){
			DrawCastingCircle(selet, 3, 0, 7);
			DrawATKStun(b, asher, 0, 0);
			Cutscene_Waitframe();
		}
		for(i=0; i<16; ++i){
			DrawCastingCircle(selet, 3, 0, 7);
			DrawATKStun(b, asher, 0, 0);
			Cutscene_Waitframe();
		}
		Cutscene_SetDrawPosition(kaylani[0], CutX(kaylani2x2[0])+8, CutY(kaylani2x2[0])+8);
		Cutscene_SetDrawPosition(kaylani2x2[0], -32, -32);
		Cutscene_SetNPCGraphic(kaylani[0], 51128, true);
		for(i=0; i<16; ++i){
			DrawCastingCircle(selet, 3, 0, 7);
			DrawATKStun(b, asher, 0, 0);
			Cutscene_Waitframe();
		}
		Cutscene_SetNPCGraphic(kaylani[0], -1, true);
		Cutscene_SetDir(kaylani[0], DIR_DOWN);
		PlayString("No...You can't...", SCHAR_KAYLANI, EMOTE_NORMAL, 68, YPOS_LOWER);
		while(G[G_MSGACTIVE]){
			DrawCastingCircle(selet, 3, 0, 7);
			DrawATKStun(b, asher, 0, 0);
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		Cutscene_SetNPCGraphic(selet[0], 51129, true);
		PlayString("Ah, Kaylani...My former treasure. I had almost completely forgotten about you.", SCHAR_SELET, EMOTE_NORMAL, 68, YPOS_UPPER);
		while(G[G_MSGACTIVE]){
			DrawCastingCircle(selet, 3, 0, 7);
			DrawATKStun(b, asher, 0, 0);
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		Cutscene_SetNPCGraphic(selet[0], 51080, true);
		PlayString("But it seems I'll no longer be requiring your services. And since you've been such a great help, I'll even forgive your resistance and careless destruction of my property. Farewell.", SCHAR_SELET, EMOTE_NORMAL, 68, YPOS_UPPER);
		while(G[G_MSGACTIVE]){
			DrawCastingCircle(selet, 3, 0, 7);
			DrawATKStun(b, asher, 0, 0);
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		Cutscene_SetNPCGraphic(selet[0], 51099, true);
		Cutscene_Glide(selet[0], -1, 72+128, 128+96, 0.5);
		Cutscene_Glide(asher[0], -1, 72+128+16, 128+96-24, 0.5);
		while(!Cutscene_FinishedGlide(selet[0])){
			DrawCastingCircle(selet, 3, 0, 7);
			DrawATKStun(b, asher, 0, 0);
			Cutscene_Waitframe();
		}
		Cutscene_SetNPCGraphic(selet[0], 51080, true);
		PlayString("Selet...Get back here...You can't use that magic...", SCHAR_KAYLANI, EMOTE_NORMAL, 68, YPOS_UPPER);
		Cutscene_GlideRelative(kaylani[0], -1, -32, 48, 1);
		while(G[G_MSGACTIVE]){
			if(Cutscene_JustFinishedGlide(kaylani[0]))
				Cutscene_SetNPCGraphic(kaylani[0], 51029, true);
			DrawCastingCircle(selet, 3, 0, 7);
			DrawATKStun(b, asher, 0, 0);
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		Cutscene_SetNPCGraphic(selet[0], 51099, true);
		Cutscene_Glide(selet[0], -1, 72+128, 224+96, 0.5);
		Cutscene_Glide(asher[0], -1, 72+128+16, 224+96-24, 0.5);
		while(!Cutscene_FinishedGlide(selet[0])){
			if(Cutscene_JustFinishedGlide(kaylani[0]))
				Cutscene_SetNPCGraphic(kaylani[0], 51029, true);
			DrawCastingCircle(selet, 3, 0, 7);
			DrawATKStun(b, asher, 0, 0);
			Cutscene_Waitframe();
		}
		for(i=0; i<32; ++i){
			if(i>=8)
				Cutscene_NewRectangle(6, 128, 96, 128+256, 96+176, 0x0F, 1, 0, 0, 0, true, 64);
			if(i>=16)
				Cutscene_NewRectangle(6, 128, 96, 128+256, 96+176, 0x0F, 1, 0, 0, 0, true, 64);
			if(i>=24)
				Cutscene_NewRectangle(6, 128, 96, 128+256, 96+176, 0x0F, 1, 0, 0, 0, true, 64);
			Cutscene_Waitframe();
		}
		Game->PlayMIDI(0);
		for(i=0; i<64; ++i){
			Cutscene_NewRectangle(6, 128, 96, 128+256, 96+176, 0x0F, 1, 0, 0, 0, true, 128);
			Cutscene_Waitframe();
		}
		npc sfx = CreateNPCAt(243, 0, 0);
		exLayer[2] = Cutscene_NewLayer(1, 22, 0x0B, 0, 0, 0, 0, 128);
		Cutscene_SetAttr(exLayer[2], CGI_DRAWLIFESPAN, -1);
		exLayer[3] = Cutscene_NewLayer(1, 22, 0x0C, 0, 256, 0, 0, 128);
		Cutscene_SetAttr(exLayer[3], CGI_DRAWLIFESPAN, -1);
		exLayer[4] = Cutscene_NewLayer(1, 22, 0x1B, 0, 0, 176, 0, 128);
		Cutscene_SetAttr(exLayer[4], CGI_DRAWLIFESPAN, -1);
		exLayer[5] = Cutscene_NewLayer(1, 22, 0x1C, 0, 256, 176, 0, 128);
		Cutscene_SetAttr(exLayer[5], CGI_DRAWLIFESPAN, -1);
		exLayer[6] = Cutscene_NewLayer(1, 20, 0x07, 0, 256, 0, 0, 128);
		Cutscene_SetAttr(exLayer[6], CGI_DRAWLIFESPAN, -1);
		exLayer[7] = Cutscene_NewLayer(1, 20, 0x17, 0, 256, 176, 0, 128);
		Cutscene_SetAttr(exLayer[7], CGI_DRAWLIFESPAN, -1);
		Cutscene_SetCameraPosition(256, 176);
		Cutscene_SetDrawPosition(selet[0], -32, -32);
		Cutscene_SetDrawPosition(asher[0], -32, -32);
		Cutscene_SetDrawPosition(torrin2x2[0], -32, -32);
		Cutscene_SetDrawPosition(torrin[0], 128, 72);
		Cutscene_SetDrawPosition(kaylani[0], 140, 72);
		Cutscene_SetDrawPosition(sword[0], 112, 48);
		Cutscene_SetAttr(sword[0], CGI_ROT, 110);
		Cutscene_SetNPCGraphic(kaylani[0], 51135, true);
		Cutscene_SetNPCGraphic(torrin[0], 51134, true);
		Cutscene_SetCameraTarget(0, 0, 0.5);
		PlayString("Torrin! Wake up! Come on, you've got to wake up!", SCHAR_KAYLANI, EMOTE_NORMAL, 68, YPOS_LOWER);
		while(G[G_MSGACTIVE]){
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		while(!Cutscene_CameraFinishedMoving()){
			Cutscene_Waitframe();
		}
		Cutscene_SetNPCGraphic(kaylani[0], 51133, true);
		Cutscene_SetNPCGraphic(torrin[0], 51130, true);
		PlayString("Mmh...? Kaylani? Where are we...", SCHAR_TORRIN, EMOTE_ELLIPSES, 68, YPOS_LOWER);
		for(i=0; i<32; ++i){
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		Cutscene_SetNPCGraphic(torrin[0], 51131, true);
		for(i=0; i<32; ++i){
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		Cutscene_SetNPCGraphic(torrin[0], 51132, true);
		while(G[G_MSGACTIVE]){
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		Cutscene_SetNPCGraphic(kaylani[0], -1, true);
		Cutscene_SetDir(kaylani[0], DIR_LEFT);
		Cutscene_GlideRelative(kaylani[0], -1, 4, 0, 1);
		Cutscene_SetNPCGraphic(torrin[0], 51081, true);
		PlayString("Where's Asher!?", SCHAR_TORRIN, EMOTE_EXCLAMATION, 68, YPOS_LOWER);
		while(G[G_MSGACTIVE]){
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		PlayString("Gone. Selet has him.", SCHAR_KAYLANI, EMOTE_SAD, 68, YPOS_LOWER);
		while(G[G_MSGACTIVE]){
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		Cutscene_SetNPCGraphic(torrin[0], -1, true);
		Cutscene_SetDir(torrin[0], DIR_RIGHT);
		Cutscene_GlideRelative(torrin[0], -1, 6, 0, 1);
		PlayString("G-Gone!? Th' hell do you mean GONE? You just let him get awa-", SCHAR_TORRIN, EMOTE_FURIOUS, 68, YPOS_LOWER);
		while(G[G_MSGACTIVE]){
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		Game->PlaySound(120);
		Game->PlaySound(74);
		Cutscene_GlideRelative(torrin[0], -1, -6, 0, 1);
		for(i=0; i<128; ++i){
			if(i%12==0&&i<64)
				Game->PlaySound(85);
			Cutscene_SetCameraPosition(0, 32-32*Cos((i/128)*180*8));
			if(i%16==0&&i<48)
				Game->PlaySound(3);
			Cutscene_Waitframe();
		}
		Cutscene_SetCameraPosition(0, 0);
		PlayString("This place is falling apart. Torrin, we need to get out of here now!", SCHAR_KAYLANI, EMOTE_EXCLAMATION, 68, YPOS_LOWER);
		while(G[G_MSGACTIVE]){
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		PlayString("But Ash-", SCHAR_TORRIN, EMOTE_DISMAYED, 68, YPOS_LOWER);
		while(G[G_MSGACTIVE]){
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		PlayString("-is long gone by now. And if we want to help him, our first step is not being buried at the bottom of the sea.", SCHAR_KAYLANI, EMOTE_NORMAL, 68, YPOS_LOWER);
		while(G[G_MSGACTIVE]){
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		PlayString("Ugh... dammit. You're right. Let's get outta here.", SCHAR_TORRIN, EMOTE_ANGRY, 68, YPOS_LOWER);
		while(G[G_MSGACTIVE]){
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		for(i=0; i<96; ++i){
			if(i%8==0)
				Game->PlaySound(SFX_BOMB);
			Cutscene_NewRectangle(6, 0, 0, 256, 176, 0x0F, 1, 0, 0, 0, true, 128);
			Cutscene_Waitframe();
		}
		Game->Counter[CR_STORYFLAG] = SFLAG_ASHERKIDNAPPED;
		Link->Item[I_ASHER] = false;
		G[G_KAYLANIHP] = G[G_KAYLANIMAXHP];
		G[G_TORRINHP] = G[G_TORRINMAXHP];
		if(GetCharID() == CHAR_ASHER)
			SetCharacter(CHAR_TORRIN, false);
		DayNight[_DN_HOUR] = 1;
		DayNight[_DN_MINUTE] = 0;
		G[G_MAPDISABLED] = 0;
		Link->Warp(14, 0x16);
		Cutscene_NewRectangle(6, 0, 0, 256, 176, 0x0F, 1, 0, 0, 0, true, 128);
		Cutscene_Waitframe();
	}
}

ffc script SeletObservatoryScene{
	void DrawCastingCircle(int selet, int layer, int x, int y){
		Cutscene_NewCircle(layer, CutX(selet[0])+x+Rand(-1, 1), CutY(selet[0])+y+Rand(-1, 1), ((G[G_ANIM]%6<4)?2:6)+Rand(2), Choose(0x71, 0x72, 0x73), 1, 0, 0, 0, true, 128);
	}
	void run(int type){
		if(Distance(Link->X, Link->Y, this->X, this->Y)<8){
			if(type==0)
				runFinal1();
			else if(type==1)
				runFinal2();
		}
	}
	void runFinal1(){
		Game->PlayMIDI(0);
		if(G[G_RANDOMIZERENABLED]){
			Link->Warp(66, 0x17);
			Quit();
		}
		SetCutsceneSkip(CUTSCENE_SELETFINAL1);
		int i; int j; int k;
		Cutscene_Init(RT_BITMAP1, RT_BITMAP2);
		cutsceneG[CG_MASKED] = 1;
		Cutscene_AnchorCamera(0x27, 0x27, 1, 1);
		int selet[1];
		
		int darkRect = Cutscene_NewRectangle(0, 112, 48, 112+31, 48+15, 0x0F, 1, 0, 0, 0, true, 128);
		Cutscene_MakeImmortal(darkRect);
		int tiles[2];
		tiles[0] = Cutscene_NewFastTile(0, 112, 48, 68858, 3, 128);
		Cutscene_MakeImmortal(tiles[0]);
		tiles[1] = Cutscene_NewFastTile(0, 128, 48, 68878, 3, 128);
		Cutscene_MakeImmortal(tiles[1]);
		int pedestal = Cutscene_NewTile(2, 120, 32, 117300, 1, 2, 11, -1, -1, 0, 0, 0, 0, true, 128);
		Cutscene_MakeImmortal(pedestal);
		
		selet[0] = Cutscene_NewNPC(2, 120, 64, 51088, 11, 128);
		Cutscene_SetFlag(selet[0], CGF_4WAY|CGF_BIGNPC);
		Cutscene_SetDir(selet[0], DIR_UP);
		int asher[1];
		asher[0] = Cutscene_NewNPC(2, 120, 176+16, 51000, 6, 128);
		Cutscene_SetFlag(asher[0], CGF_4WAY|CGF_BIGNPC|CGF_BS);
		Cutscene_SetDir(asher[0], DIR_UP);
		int torrin[1];
		torrin[0] = Cutscene_NewNPC(2, 120, 176+16, 50952, 6, 128);
		Cutscene_SetFlag(torrin[0], CGF_4WAY|CGF_BIGNPC|CGF_BS);
		Cutscene_SetDir(torrin[0], DIR_UP);
		int kaylani[1];
		kaylani[0] = Cutscene_NewNPC(2, 120, 176+16, 50960, 6, 128);
		Cutscene_SetFlag(kaylani[0], CGF_4WAY|CGF_BIGNPC|CGF_BS);
		Cutscene_SetDir(kaylani[0], DIR_UP);
		
		int door = Cutscene_NewTile(2, 96, 176, 69380, 4, 2, 2, -1, -1, 0, 0, 0, 0, true, 128);
		Cutscene_MakeImmortal(door);
		
		switch(GetCharID()){
			case CHAR_ASHER:
				Cutscene_SetDrawPosition(asher[0], Link->X, 160);
				Cutscene_Glide(asher[0], -1, 120, 128, 1);
				break;
			case CHAR_TORRIN:
				Cutscene_SetDrawPosition(torrin[0], Link->X, 160);
				Cutscene_Glide(torrin[0], -1, 120, 128, 1);
				break;
			default:
				Cutscene_SetDrawPosition(kaylani[0], Link->X, 160);
				Cutscene_Glide(kaylani[0], -1, 120, 128, 1);
				break;
		}
		Cutscene_Waitglide();
		Cutscene_SetDrawPosition(asher[0], 120, 128);
		Cutscene_SetDrawPosition(torrin[0], 120, 128);
		Cutscene_SetDrawPosition(kaylani[0], 120, 128);
		Cutscene_SetDir(asher[0], DIR_LEFT);
		Cutscene_GlideRelative(asher[0], -1, -16, 0, 1);
		Cutscene_SetDir(kaylani[0], DIR_RIGHT);
		Cutscene_GlideRelative(kaylani[0], -1, 16, 0, 1);
		Cutscene_Waitglide();
		Cutscene_SetDir(asher[0], DIR_UP);
		Cutscene_SetDir(kaylani[0], DIR_UP);
		Cutscene_Waitframe(16);
		Game->PlaySound(133);
		Cutscene_GlideRelative(door, -1, 0, -32, 4);
		Cutscene_Waitframe(32);
		Cutscene_SetDir(selet[0], DIR_DOWN);
		Cutscene_GlideRelative(selet[0], -1, 0, 16, 1);
		Cutscene_Waitframe(32);
		Game->PlayEnhancedMusic("SS-Selet.ogg", 0);
		Cutscene_PlayString("And here I thought I told the three of you not to squander my mercy. Why have you come here?", SCHAR_SELET, EMOTE_NORMAL, 68, YPOS_UPPER);
		Cutscene_Waitframe(16);
		Cutscene_GlideRelative(kaylani[0], -1, 0, -8, 1);
		Cutscene_Waitglide();
		Cutscene_PlayString("To stop you, of course. We can't allow someone like you to use something as dangerous as stellar magic. Don't you realize the threat it poses? If another stellarist war breaks out, the world won't survive this time. You'll be destroyed by it as well.", SCHAR_KAYLANI, EMOTE_NORMAL, 68, YPOS_UPPER);
		Cutscene_SetNPCGraphic(selet[0], 51593, true);
		Cutscene_Waitframe(32);
		Cutscene_PlayString("So you see me as a threat, then. But if the world is being destroyed, it will be your world: The one you're accustomed to. Not my world. Will I start wars for profit? Perhaps. And will a couple of countries sink into the ocean as a result? Perhaps. But it will be the expendables like yourselves who foot the bill. I am indispensable, untouchable. In a world of creatures hopelessly mired in the mud, believing they can pull others to heights they have not themselves reached, I alone have reached this summit. Through my own strength, I have surpassed your sad world. So I see no reason to bend to your fear tactics. All of my world is me and mine, and my world is unchanging.", SCHAR_SELET, EMOTE_NORMAL, 68, YPOS_UPPER);
		Cutscene_Waitframe(16);
		Cutscene_GlideRelative(asher[0], -1, 0, -8, 1);
		Cutscene_Waitglide();
		Cutscene_PlayString("But what about everyone else? Can't you see how many people are gonna die? It's so clearly wrong! How can you do something so evil?", SCHAR_ASHER, EMOTE_DISMAYED, 68, YPOS_UPPER);
		Cutscene_SetNPCGraphic(selet[0], 51136, true);
		Cutscene_Waitframe(32);
		Cutscene_SetNPCGraphic(selet[0], 51137, true);
		Cutscene_Waitframe(32);
		Cutscene_SetNPCGraphic(selet[0], 51136, true);
		Cutscene_Waitframe(32);
		Cutscene_SetNPCGraphic(selet[0], 51080, true);
		Cutscene_Waitframe(16);
		Cutscene_PlayString("Wrong? Evil? You're the kind I cannot stand most of all. Your head is haunted by others' ideals, leaving no regard for the self. You so willingly judge the individual without batting an eye at the everyday \"evils\". The \"evils\" of the state. When injustice is handed down by the collective, we call that \"law\". And only through my wealth, influence, and strength can I stand above it. Tell me, why should I submit to your borrowed ideals when they exist beneath me?", SCHAR_SELET, EMOTE_NORMAL, 68, YPOS_UPPER);
		Cutscene_Waitframe(16);
		Cutscene_GlideRelative(torrin[0], -1, 0, -8, 1);
		Cutscene_Waitglide();
		Cutscene_PlayString("Ugh. All this ramblin's givin' me a headache. We're here 'cause we wanna kick your pompous ass halfway across the ocean. Simple enough?", SCHAR_TORRIN, EMOTE_ANGRY, 68, YPOS_UPPER);
		Cutscene_SetNPCGraphic(selet[0], 51138, true);
		Cutscene_Waitframe(32);
		Cutscene_PlayString("Now this is the closest we've come to understanding. If you're to challenge me here, it should be for yourselves. But have you no basic survival instinct? I beat you all within an inch of your lives before. Surely that distance between us should overpower your own convictions. Yet here you are, and when negotiations are turned down, it does always come to blows.", SCHAR_SELET, EMOTE_NORMAL, 68, YPOS_UPPER);
		Cutscene_SetNPCGraphic(selet[0], -1, true);
		Cutscene_Waitframe(32);
		Cutscene_Glide(selet[0], -1, CutX(pedestal)+14, CutY(pedestal)+16, 1);
		Cutscene_Waitglide();
		Cutscene_SetNPCGraphic(selet[0], 51112, true);
		Cutscene_PlayString("From this egg, all magic was born. In the past, some revered it as a god. You, Kaylani, fear it as the devil. But before me it is merely a tool, the final treasure I must open.", SCHAR_SELET, EMOTE_NORMAL, 68, YPOS_LOWER);
		Cutscene_SetNPCGraphic(selet[0], 51139, true);
		PlayString("Cosmic Egg, lend me your blessing. Bestow me with stellar magic as you did for the kings of old!", SCHAR_SELET, EMOTE_NORMAL, 68, YPOS_LOWER);
		while(G[G_MSGACTIVE]){
			DrawCastingCircle(selet, 4, 13, -5);
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		Cutscene_SetNPCGraphic(selet[0], 51140, true);
		Cutscene_PlayString("Behold!", SCHAR_SELET, EMOTE_NORMAL, 68, YPOS_LOWER);
		Cutscene_Waitframe(32);
		Cutscene_SetNPCGraphic(selet[0], -1, true);
		Cutscene_Waitframe(32);
		Cutscene_SetNPCGraphic(selet[0], 51141, true);
		Cutscene_PlayString("...Most disappointing. I should have prepared for this possibility. But all this preparation, all this scheming, for nothing? My ultimate treasure was just a useless rock after all?", SCHAR_SELET, EMOTE_DISMAYED, 68, YPOS_LOWER);
		Cutscene_SetNPCGraphic(selet[0], -1, true);
		Cutscene_PlayString("...No. This must be another of the astronomers' tricks. They've managed to stay one step ahead of me, but the party they sent was these three. Children, Selet. You're fighting children...", SCHAR_SELET, EMOTE_NORMAL, 68, YPOS_LOWER);
		
		Game->PlaySound(89);
		for(i=0; i<11; ++i){
			Cutscene_SetDrawGraphic(pedestal, 117300+i, 3);
			Cutscene_Waitframe(2);
		}
		Game->PlaySound(89);
		for(i=0; i<7; ++i){
			Cutscene_SetDrawGraphic(tiles[0], 68858-i, 3);
			Cutscene_SetDrawGraphic(tiles[1], 68878-i, 3);
			Cutscene_Waitframe(i<5?2:4);
		}
		
		Game->PlayEnhancedMusic("SS-FinalBoss.ogg", 0);
		Cutscene_Glide(selet[0], -1, 120, 64, 1);
		Cutscene_Waitglide();
		Cutscene_SetNPCGraphic(selet[0], 51593, true);
		Cutscene_PlayString("My celebrations may have been premature, but in the absence of my treasure I can still settle for second best. It's time I reclaimed my stolen property.", SCHAR_SELET, EMOTE_NORMAL, 68, YPOS_LOWER);
		for(i=0; i<32; ++i){
			Cutscene_NewRectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
			Cutscene_Waitframe();
		}
		SetCutsceneSkip(CUTSCENE_NULL); //CUTSCENE_SELETFINAL1
		Link->Warp(66, 0x17);
		Cutscene_Waitframe();
		Cutscene_NewRectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
	}
	void runFinal2(){
		SetCutsceneSkip(CUTSCENE_SELETFINAL2);
		Game->PlayEnhancedMusic("SS-Selet.ogg", 0);
		int i; int j; int k;
		int x; int y;
		Cutscene_Init(RT_BITMAP1, RT_BITMAP2);
		cutsceneG[CG_MASKED] = 1;
		Cutscene_AnchorCamera(0x27, 0x27, 1, 1);
		
		int tiles[2];
		tiles[0] = Cutscene_NewFastTile(0, 112, 48, 68858, 3, 128);
		Cutscene_MakeImmortal(tiles[0]);
		tiles[1] = Cutscene_NewFastTile(0, 128, 48, 68878, 3, 128);
		Cutscene_MakeImmortal(tiles[1]);
		int ellipse[2];
		ellipse[0] = Cutscene_NewEllipse(0, 128, -32, 8, 8, 0x0F, 1, 0, 0, 0, true, 128);
		Cutscene_MakeImmortal(ellipse[0]);
		ellipse[1] = Cutscene_NewEllipse(0, 128, -32, 8, 8, 0x0F, 1, 0, 0, 0, true, 64);
		Cutscene_MakeImmortal(ellipse[1]);
		int pedestal = Cutscene_NewTile(2, 120, 32, 117300, 1, 2, 11, -1, -1, 0, 0, 0, 0, true, 128);
		Cutscene_MakeImmortal(pedestal);
		int egg2x2 = Cutscene_NewCombo(2, 104, -32, 51945, 2, 2, 11, -1, -1, 0, 0, 0, -1, 0, true, 128);
		Cutscene_MakeImmortal(egg2x2);
		int spray = Cutscene_NewFastCombo(2, 120, -32, 51946, 0, 128);
		Cutscene_MakeImmortal(spray);
		
		int selet[1];
		selet[0] = Cutscene_NewNPC(2, 120, 72, 51088, 11, 128);
		Cutscene_SetFlag(selet[0], CGF_4WAY|CGF_BIGNPC);
		Cutscene_SetDir(selet[0], DIR_UP);
		Cutscene_SetNPCGraphic(selet[0], 51145, true);
		int selet2x2[1];
		selet2x2[0] = Cutscene_NewCombo(2, 120, -32, 51150, 2, 2, 11, -1, -1, 0, 0, 0, -1, 0, true, 128);
		Cutscene_MakeImmortal(selet2x2[0]);
		int asher[1];
		asher[0] = Cutscene_NewNPC(2, 80, 72, 51000, 6, 128);
		Cutscene_SetFlag(asher[0], CGF_4WAY|CGF_BIGNPC|CGF_BS);
		Cutscene_SetDir(asher[0], DIR_RIGHT);
		int torrin[1];
		torrin[0] = Cutscene_NewNPC(2, 128, 120, 50952, 6, 128);
		Cutscene_SetFlag(torrin[0], CGF_4WAY|CGF_BIGNPC|CGF_BS);
		Cutscene_SetDir(torrin[0], DIR_UP);
		int kaylani[1];
		kaylani[0] = Cutscene_NewNPC(2, 168, 88, 50960, 6, 128);
		Cutscene_SetFlag(kaylani[0], CGF_4WAY|CGF_BIGNPC|CGF_BS);
		Cutscene_SetDir(kaylani[0], DIR_LEFT);
		
		int door = Cutscene_NewTile(2, 96, 144, 69380, 4, 2, 2, -1, -1, 0, 0, 0, 0, true, 128);
		Cutscene_MakeImmortal(door);
		
		Cutscene_Waitframe(48);
		Cutscene_PlayString("No! Such weakness! How could I have fallen so far?", SCHAR_SELET, EMOTE_DISMAYED, 68, YPOS_LOWER);
		Cutscene_SetNPCGraphic(selet[0], 51146, true);
		Cutscene_Glide(selet[0], -1, 120, 60, 1.5);
		Cutscene_Waitglide();
		for(i=0; i<32; ++i){
			NoAction();
			Cutscene_Waitframe();
		}
		Cutscene_SetNPCGraphic(selet[0], -1, true);
		PlayString("Stupid useless stone!@sync(0)@delay(64) Give me your damn blessing! I will not be bested by children!", SCHAR_SELET, EMOTE_FURIOUS, 68, YPOS_LOWER);
		while(!__Tango_FindSyncingStrings(0)){
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		Cutscene_SetNPCGraphic(selet[0], 51147, true);
		for(i=0; i<32; ++i){
			NoAction();
			Cutscene_Waitframe();
		}
		Game->PlaySound(SFX_EHIT);
		Cutscene_SetNPCGraphic(selet[0], 51148, true);
		for(i=0; i<4; ++i){
			NoAction();
			Cutscene_Waitframe();
		}
		Cutscene_SetNPCGraphic(selet[0], 51149, true);
		for(i=0; i<24; ++i){
			NoAction();
			Cutscene_Waitframe();
		}
		Cutscene_SetNPCGraphic(selet[0], -1, true);
		while(G[G_MSGACTIVE]){
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		Cutscene_Waitframe(48);
		PlayString("As my hands drip with blood,@sync(0)@delay(64) as my senses dull,@sync(1)@delay(64) I will not give up on all I've worked for!@sync(2)@delay(64)", SCHAR_SELET, EMOTE_FURIOUS, 68, YPOS_LOWER);
		for(j=0; j<3; ++j){
			while(!__Tango_FindSyncingStrings(j)){
				G[G_NOACTION] = 1;
				Cutscene_Waitframe2();
			}
			Cutscene_SetNPCGraphic(selet[0], 51147, true);
			for(i=0; i<32; ++i){
				NoAction();
				Cutscene_Waitframe();
			}
			Game->PlaySound(SFX_EHIT);
			if(j==2){
				Game->PlaySound(105);
				Cutscene_SetDrawGraphic(pedestal, 117260, 11);
				Cutscene_SetDrawPosition(egg2x2, CutX(pedestal)-9, CutY(pedestal)-1);
			}
			Cutscene_SetNPCGraphic(selet[0], 51148, true);
			for(i=0; i<4; ++i){
				NoAction();
				Cutscene_Waitframe();
			}
			Cutscene_SetNPCGraphic(selet[0], 51149, true);
			for(i=0; i<24; ++i){
				NoAction();
				Cutscene_Waitframe();
			}
			Cutscene_SetNPCGraphic(selet[0], -1, true);
		}
		while(G[G_MSGACTIVE]){
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		Cutscene_Waitframe(48);
		Cutscene_SetDrawPosition(spray, CutX(egg2x2)+8+9, CutY(egg2x2));
		int sfxTimer[1];
		
		Cutscene_SetNPCGraphic(selet[0], 51147, true);
		Cutscene_GlideRelative(selet[0], -1, 0, 16, 1.5);
		Cutscene_GlideRelative(asher[0], -1, -8, 0, 2);
		Cutscene_GlideRelative(torrin[0], -1, 0, 8, 2);
		Cutscene_GlideRelative(kaylani[0], -1, 8, 0, 2);
		
		for(i=0; i<256; ++i){
			LoopingSFX(sfxTimer, 36, 143);
			Cutscene_SetDrawPosition(ellipse[0], CutX(pedestal)+8, CutY(pedestal)+24);
			Cutscene_SetDrawPosition(ellipse[1], CutX(pedestal)+8, CutY(pedestal)+24);
			Cutscene_SetAttr(ellipse[0], CGI_RADIUS, Lerp(0, 32, i/255));
			Cutscene_SetAttr(ellipse[0], CGI_RADIUS2, Lerp(0, 16, i/255));
			Cutscene_SetAttr(ellipse[1], CGI_RADIUS, Lerp(0+4, 32+8, i/255));
			Cutscene_SetAttr(ellipse[1], CGI_RADIUS2, Lerp(0+4, 16+8, i/255));
			Cutscene_Waitframe();
		}
		for(i=0; i<64; ++i){
			LoopingSFX(sfxTimer, 36, 143);
			Cutscene_Waitframe();
		}
		Cutscene_RemoveDraw(spray);
		Cutscene_SetDrawGraphic(egg2x2, 51941, 11);
		for(i=0; i<64; ++i){
			Cutscene_Waitframe();
		}
		Cutscene_SetDrawGraphic(egg2x2, 51942, 11);
		for(i=0; i<64; ++i){
			Cutscene_Waitframe();
		}
		Cutscene_SetDrawGraphic(egg2x2, 51947, 11);
		for(i=0; i<64; ++i){
			Cutscene_Waitframe();
		}
		Cutscene_SetDrawPosition(selet2x2[0], CutX(selet[0])-8, CutY(selet[0])-16);
		Cutscene_RemoveDraw(selet[0]);
		int eggX = CutX(egg2x2);
		int eggY = CutY(egg2x2);
		Game->PlayMIDI(0);
		Game->PlaySound(93);
		for(i=0; i<48; ++i){
			x = Lerp(eggX, CutX(selet2x2[0])+12, i/47);
			y = Lerp(eggY, CutY(selet2x2[0])+12, i/47);
			Cutscene_SetAttr(egg2x2, CGI_X, x);
			Cutscene_SetAttr(egg2x2, CGI_Y, y);
			Cutscene_SetAttr(egg2x2, CGI_WIDTH, Lerp(32, 8, i/47));
			Cutscene_SetAttr(egg2x2, CGI_HEIGHT, Lerp(32, 8, i/47));
			Cutscene_Waitframe();
		}
		Cutscene_RemoveDraw(egg2x2);
		Game->PlaySound(SFX_EHIT);
		Game->PlaySound(144);
		Cutscene_SetDrawGraphic(selet2x2[0], 51151, 11);
		Cutscene_GlideRelative(selet2x2[0], -1, 0, 8, 0.5);
		for(i=0; i<16; ++i){
			Cutscene_Waitframe();
		}
		Cutscene_SetDrawGraphic(selet2x2[0], 51152, 11);
		Cutscene_GlideRelative(selet2x2[0], -1, 0, 8, 0.25);
		for(i=0; i<16; ++i){
			Cutscene_Waitframe();
		}
		Cutscene_Waitframe(32);
		Game->PlaySound(145);
		Cutscene_SetDrawGraphic(selet2x2[0], 51153, 11);
		Cutscene_Waitframe(64);
		Cutscene_SetDrawGraphic(selet2x2[0], 51154, 11);
		int sfxTimerGlow[1];
		int sfxTimerQuake[1];
		for(i=0; i<64; ++i){
			LoopingSFX(sfxTimerGlow, 32, 121);
			Cutscene_Waitframe();
		}
		PlayString("Ahh...My stars! It's full of stars inside. They swirl within me as well...", SCHAR_SELET, EMOTE_NORMAL, 68, YPOS_LOWER);
		while(G[G_MSGACTIVE]){
			LoopingSFX(sfxTimerGlow, 32, 121);
			G[G_NOACTION] = 1;
			Cutscene_Waitframe2();
		}
		
		int tentacleFrames[48];
		int tentacleASpeed[48];
		int tentacleSkip[48];
		for(i=0; i<48; ++i){
			tentacleFrames[i] = Rand(90);
			tentacleASpeed[i] = 1;
			if(i<5)
				tentacleASpeed[i] = 2;
			tentacleSkip[i] = Rand(4, 6);
		}
		
		bitmap buf = Game->CreateBitmap(512, 512);
		bitmap starBG = Game->CreateBitmap(256, 176);
		bitmap starBG2 = Game->CreateBitmap(256, 176);
		bitmap prep = Game->CreateBitmap(256, 176);
		buf->Own();
		starBG->Own();
		starBG2->Own();
		prep->Own();
			
		using namespace NightmareSelet;
		untyped nsd[48];
		nsd[BUFFER] = buf;
		nsd[STARBITMAP] = starBG;
		nsd[STARBITMAP2] = starBG2;
		nsd[PREPBITMAP] = prep;
		
		nsd[HEADANGLE] = 90;
		
		nsd[LHAND_X] = -72;
		nsd[LHAND_Y] = -16;
		nsd[LHAND_ANG] = -45;
		
		nsd[RHAND_X] = 72;
		nsd[RHAND_Y] = -16;
		nsd[RHAND_ANG] = 45;
		
		nsd[HEADSTATE] = 3;
		nsd[HEADTARGETSTATE] = 3;
		
		nsd[LHAND_STATE] = HAND_CLAW;
		nsd[RHAND_STATE] = HAND_CLAW;
		nsd[LHAND_SUBSTATE] = 3;
		nsd[RHAND_SUBSTATE] = 3;
		nsd[LHAND_TARGETSUB] = 3;
		nsd[RHAND_TARGETSUB] = 3;
		
		nsd[TENTACLEFRAMES] = tentacleFrames;
		nsd[TENTACLEASPEED] = tentacleASpeed;
		nsd[TENTACLESKIP] = tentacleSkip;
		nsd[TENTACLEAMULT] = 1;
		
		nsd[SPECIALDRAW] = SD_BLACKOUT;
		nsd[DRAWSCALE] = 0.1;
		nsd[DRAWLAYER] = 7;
		
		Game->PlaySound(75);
		for(i=0.1; i<3; i+=0.1){
			DrawNightmareSelet1(nsd);
			DrawNightmareSelet2(nsd, CutX(selet2x2[0])-16, CutY(selet2x2[0])-16);
			nsd[DRAWSCALE] = i;
			Cutscene_Waitframe();
		}
		Game->PlaySound(120);
		for(i=0; i<32; ++i){
			LoopingSFX(sfxTimerQuake, 48, 74);
			Cutscene_NewRectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
			Cutscene_Waitframe();
		}
		for(i=0; i<24; ++i){
			LoopingSFX(sfxTimerQuake, 48, 74);
			Cutscene_NewRectangle(6, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
			if(i<8)
				Cutscene_NewRectangle(6, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 64);
			if(i<16)
				Cutscene_NewRectangle(6, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 64);
			else
				Cutscene_NewRectangle(6, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 128);
			Cutscene_Waitframe();
		}
		for(i=0; i<32; ++i){
			LoopingSFX(sfxTimerQuake, 48, 74);
			Cutscene_NewRectangle(6, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 128);
			Cutscene_Waitframe();
		}
		PlayString("So this is the power of the cosmos. My treasure and I, together at last...", SCHAR_SELET, EMOTE_NORMAL, 68, YPOS_LOWER);
		while(G[G_MSGACTIVE]){
			LoopingSFX(sfxTimerQuake, 48, 74);
			G[G_NOACTION] = 1;
			Cutscene_NewRectangle(6, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 128);
			Cutscene_Waitframe2();
		}
		for(i=0; i<32; ++i){
			LoopingSFX(sfxTimerQuake, 48, 74);
			Cutscene_NewRectangle(6, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 128);
			Cutscene_Waitframe();
		}
		FullHeal(true, true, true, true);
		LoreTracking[LT_ENEMIES+236] = 1;
		SetCutsceneSkip(CUTSCENE_NULL); //CUTSCENE_SELETFINAL2
		Link->Warp(70, 0x07);
		Cutscene_NewRectangle(6, 0, 0, 255, 175, 0x01, 1, 0, 0, 0, true, 128);
		Cutscene_Waitframe();
	}
}

ffc script Credits{
	void run(){
		if(G[G_RANDOMIZERENABLED]){
			G[G_RANDOMIZERRUNCLEAR] = 1;
			WriteOutfitSaveFile();
		}
		Game->DMapPalette[Game->GetCurDMap()] = 0x0A9;
		Game->PlayEnhancedMusic("SS-Credits.ogg", 0);
		Screen->D[0] = 0;
		
		// int bitid = TempBitmap_Create(0, 256, 176);
		// bitmap wipes = TempBMP[bitid];
		// wipes->Clear(0);
		bitmap wipes = Game->CreateBitmap(256, 176);
		wipes->Own();
		
		CWait(120);
		
		int S1[] = {"Stellar Seas", "A game by Russ and Moosh"};
		int I1[] = {0, 32};
		
		TextFade(S1, I1, 60, 180);
		
		CWait(120);
		
		int S2[] = {"Base Tileset", "DoR Hybrid", "By Radien and Demonlink", "And all contributors to DoR"};
		int I2[] = {0, 32, 48, 48};
		
		TextFade(S2, I2, 60, 180);
		
		CWait(120);
		
		int S3[] = {"Additional Graphics From", "Charas Project", "Chrono Trigger", "Gunple: Gunman's Proof", "Minish Cap"};
		int I3[] = {0, 32, 32, 32, 32};
		
		TextFadeHeader(1, S3, I3, 60, 180);
		
		for(int i = 0; i<60; i++){
			DrawStringOutline(2, 16, 16, FONT_P, 0x01, 0x0F, TF_NORMAL, "Additional Graphics From", OP_OPAQUE);
			CWait(1);
		}
		
		int S4[] = {"Additional Graphics From", "P-47 Aces", "Pokemon Ruby and Sapphire", "RPG Maker", "Trials of Mana"};
		int I4[] = {0, 32, 32, 32, 32};
		
		TextFadeHeader(2, S4, I4, 60, 180);
		
		CWait(120);
		
		int S5[] = {"Additional Graphics Edited By", "Jupiter", "Zemious"};
		int I5[] = {0, 32, 32};
		
		TextFade(S5, I5, 60, 180);
		
		CWait(120);
		
		int S6[] = {"Music From", "Ace Combat 4", "Ace Combat 7", "Apollo Justice: Ace Attorney", "Ao no Kiseki"};
		int I6[] = {0, 32, 32, 32, 32};
		
		TextFadeHeader(1, S6, I6, 60, 180);
		
		for(int i = 0; i<60; i++){
			DrawStringOutline(2, 16, 16, FONT_P, 0x01, 0x0F, TF_NORMAL, "Music From", OP_OPAQUE);
			CWait(1);
		}
		
		int S7[] = {"Music From", "Attack on Titan", "Bayonetta", "Chrono Cross", "Code Vein"};
		int I7[] = {0, 32, 32, 32, 32};
		
		TextFadeHeader(0, S7, I7, 60, 180);
		
		for(int i = 0; i<60; i++){
			DrawStringOutline(2, 16, 16, FONT_P, 0x01, 0x0F, TF_NORMAL, "Music From", OP_OPAQUE);
			CWait(1);
		}
		
		int S8[] = {"Music From", "Dynamite Headdy", "Final Fantasy: Crystal Chronicles", "Great Ace Attorney", "Iconoclasts"};
		int I8[] = {0, 32, 32, 32, 32};
		
		TextFadeHeader(0, S8, I8, 60, 180);
		
		for(int i = 0; i<60; i++){
			DrawStringOutline(2, 16, 16, FONT_P, 0x01, 0x0F, TF_NORMAL, "Music From", OP_OPAQUE);
			CWait(1);
		}
		
		int S9[] = {"Music From", "Kirby Triple Deluxe", "Kingdom Hearts", "La-Mulana 2", "Pokemon Black and White"};
		int I9[] = {0, 32, 32, 32, 32};
		
		TextFadeHeader(0, S9, I9, 60, 180);
		
		for(int i = 0; i<60; i++){
			DrawStringOutline(2, 16, 16, FONT_P, 0x01, 0x0F, TF_NORMAL, "Music From", OP_OPAQUE);
			CWait(1);
		}
		
		int S10[] = {"Music From", "Pokemon Diamond and Pearl", "Pokemon Sun and Moon", "Shiness: The Lightning Kingdom", "Tales of Arise"};
		int I10[] = {0, 32, 32, 32, 32};
		
		TextFadeHeader(0, S10, I10, 60, 180);
		
		for(int i = 0; i<60; i++){
			DrawStringOutline(2, 16, 16, FONT_P, 0x01, 0x0F, TF_NORMAL, "Music From", OP_OPAQUE);
			CWait(1);
		}
		
		int S19[] = {"Music From", "Trails of Cold Steel", "Xenoblade 2", "Xenoblade X", "Ys 4"};
		int I19[] = {0, 32, 32, 32, 32};
		
		TextFadeHeader(0, S19, I19, 60, 180);
		
		int S18[] = {"Music From", "Ys 8", "Zelda: Skyward Sword"};
		int I18[] = {0, 32, 32, 32, 32};
		
		TextFadeHeader(2, S18, I18, 60, 180);
		
		CWait(120);
		
		int S11[] = {"Arrangements By", "Aether and Chaos", "Alouette EXE", "Dreamer's Circus", "Feys"};
		int I11[] = {0, 32, 32, 32, 32};
		
		TextFadeHeader(1, S11, I11, 60, 180);
		
		for(int i = 0; i<60; i++){
			DrawStringOutline(2, 16, 16, FONT_P, 0x01, 0x0F, TF_NORMAL, "Arrangements By", OP_OPAQUE);
			CWait(1);
		}
		
		int S12[] = {"Arrangements By", "PokeMixr92", "Pokestir", "Zame"};
		int I12[] = {0, 32, 32, 32};
		
		TextFadeHeader(2, S12, I12, 60, 180);
		
		CWait(120);
		
		int S13[] = {"Additional Scripting By", "Evan", "Saffith"};
		int I13[] = {0, 32, 32};
		
		TextFade(S13, I13, 60, 180);
		
		CWait(120);
		
		int S14[] = {"Testing By", "Evan"};
		int I14[] = {0, 32, 32};
		
		TextFade(S14, I14, 60, 180);
		
		CWait(120);
		
		int S15[] = {"Special Thanks", "Aevin", "For his work in editing dialogue,", "his suggestions and feedback,", "and his being a general source of", "encouragement and motivation"};
		int I15[] = {0, 32, 48, 48, 48, 48};
		
		TextFadeHeader(1, S15, I15, 60, 180);
		
		for(int i = 0; i<60; i++){
			DrawStringOutline(2, 16, 16, FONT_P, 0x01, 0x0F, TF_NORMAL, "Special Thanks", OP_OPAQUE);
			CWait(1);
		}
		
		int S16[] = {"Special Thanks", "Deedee and Emily", "For quickly fixing the many ZC bugs that arose", "and for developing ZC 2.55"};
		int I16[] = {0, 32, 48, 48};
		
		TextFadeHeader(2, S16, I16, 60, 180);
		
		CWait(180);
		
		int S17[] = {"Thank You For Playing!"};
		int I17[] = {0};
		
		TextFade(S17, I17, 60, 180);
		
		for(int i=32; i>0; i-=0.5){
			wipes->ClearToColor(0, 0x0F);
			wipes->Circle(0, Lerp(120+8, 128, i/32), Lerp(88+8, 88, i/32), Lerp(0, 128, i/32), 0x00, 1, 0, 0, 0, true, 128);
			wipes->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
			CWait(1);
		}
		
		for(int i = 0; i< 90; i++){
			BlackScreenLayerSix();
			WaitNoAction();
		}
		if(!G[G_RANDOMIZERENABLED]){
			Game->PlayEnhancedMusic("SS-PunaNight.ogg", 0);
			Cutscene_Init(RT_BITMAP1, RT_BITMAP2);
			Game->DMapPalette[Game->GetCurDMap()] = 0x0B8;
			cutsceneG[CG_BGMAP] = 2;
			Cutscene_AnchorCamera(0x61, 0x61, 1, 1);
			int asher = Cutscene_NewNPC(2, 144, 128, CMB_ASHER, 6, OP_OPAQUE);
			Cutscene_SetFlag(asher, CGF_4WAY|CGF_BIGNPC);
			Cutscene_SetDir(asher, DIR_RIGHT);
			int torrin = Cutscene_NewNPC(2, 159, 128, CMB_TORRIN, 6, OP_OPAQUE);
			Cutscene_SetFlag(torrin, CGF_4WAY|CGF_BIGNPC);
			Cutscene_SetDir(torrin, DIR_LEFT);
			for(int i = 0; i<60; i++){
				Cutscene_Update();
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				NoAction();
				BlackishScreenLayerSix();
				Waitframe();
			}
			Cutscene_Waitframe(60);
			Cutscene_PlayString("Well... home again, safe and sound. Feels like it's been ages.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("Heh, I know exactly what you mean.", SCHAR_TORRIN, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("It feels... weird. I'm just supposed to go back to life as usual now, knowing all this is gonna start again... eventually?", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
			Cutscene_PlayString("Hey now, it'll hardly be life as usual. Now you gotta contend with me stoppin' by regularly. Say goodbye to your old, boring life!", SCHAR_TORRIN, EMOTE_WINK, 64, YPOS_UPPER);
			Cutscene_PlayString("You're good to stop by as much as you want, as long as you don't drag me into another warehouse infiltration.", SCHAR_ASHER, EMOTE_HAPPY, 64, YPOS_UPPER);
			Cutscene_PlayString("I'll do my best, but no promises.", SCHAR_TORRIN, EMOTE_HAPPY, 64, YPOS_UPPER);
			Cutscene_PlayString("Alright. Have a safe trip home, and stop by soon.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
			// int t2 = Cutscene_NewTile(2, 145, 113, 105773, 2, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
			int t1 = Cutscene_NewFastTile(2, 144, 112, 105773, 6, OP_OPAQUE);
			int t2 = Cutscene_NewFastTile(2, 144, 128, 105793, 6, OP_OPAQUE);
			int t3 = Cutscene_NewFastTile(2, 160, 112, 105774, 6, OP_OPAQUE);
			int t4 = Cutscene_NewFastTile(2, 160, 128, 105794, 6, OP_OPAQUE);
			Cutscene_SetAttr(t1, CGI_DRAWLIFESPAN, -1);
			Cutscene_SetAttr(t2, CGI_DRAWLIFESPAN, -1);
			Cutscene_SetAttr(t3, CGI_DRAWLIFESPAN, -1);
			Cutscene_SetAttr(t4, CGI_DRAWLIFESPAN, -1);
			Cutscene_SetDrawPosition(asher, 300, 300);
			Cutscene_SetDrawPosition(torrin, 300, 300);
			Cutscene_PlayString("See ya 'round, mate.", SCHAR_TORRIN, EMOTE_HAPPY, 64, YPOS_UPPER);
			Cutscene_SetAttr(t1, CGI_GFX, 105775);
			Cutscene_SetAttr(t2, CGI_GFX, 105795);
			Cutscene_SetAttr(t3, CGI_GFX, 105776);
			Cutscene_SetAttr(t4, CGI_GFX, 105796);
			Game->PlaySound(16);
			Cutscene_Waitframe(20);
			Cutscene_SetDrawPosition(asher, 144, 128);
			Cutscene_SetDrawPosition(torrin, 159, 128);
			Cutscene_RemoveDraw(t1);
			Cutscene_RemoveDraw(t2);
			Cutscene_RemoveDraw(t3);
			Cutscene_RemoveDraw(t4);
			Cutscene_SetDir(asher, DIR_LEFT);
			Cutscene_Glide(asher, -1, 64, 128, 1);
			Cutscene_Waitglide();
			Cutscene_PlayString("Hey, Ash?", SCHAR_TORRIN, EMOTE_EMBARRASSED, 64, YPOS_UPPER);
			Cutscene_SetDir(asher, DIR_RIGHT);
			Cutscene_Waitframe(30);
			Cutscene_PlayString("Yeah?", SCHAR_ASHER, EMOTE_QUESTION, 64, YPOS_UPPER);
			Cutscene_Waitframe(60);
			Cutscene_PlayString("Nevermind, answered my own question. Sorry 'bout that. Say hi to your mom for me!", SCHAR_TORRIN, EMOTE_EMBARRASSED, 64, YPOS_UPPER);
			Cutscene_PlayString("No worries! Take care.", SCHAR_ASHER, EMOTE_HAPPY, 64, YPOS_UPPER);
			Cutscene_SetDir(asher, DIR_LEFT);
			Cutscene_Glide(asher, -1, 24, 128, 1);
			Cutscene_Waitglide();
			Cutscene_SetDir(asher, DIR_UP);
			Cutscene_Glide(asher, -1, 24, 96, 1);
			Cutscene_Waitglide();
			Cutscene_Waitframe(30);
			Game->PlaySound(67);
			int off = 1;
			int door = Cutscene_NewTile(1, 16+off, 80+off, 25612, 2, 1, 4, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
			Cutscene_SetAttr(door, CGI_DRAWLIFESPAN, -1);
			// int frame = Cutscene_NewTile(4, 17, 64+off, 25702, 2, 1, 4, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
			// Cutscene_SetAttr(frame, CGI_DRAWLIFESPAN, -1);
			int f1 = Cutscene_NewFastTile(4, 16, 64, 35702, 4, OP_OPAQUE);
			int f2 = Cutscene_NewFastTile(4, 32, 64, 35702, 4, OP_OPAQUE);
			int r1 = Cutscene_NewFastTile(3, 16, 48, 25682, 4, OP_OPAQUE);
			int r2 = Cutscene_NewFastTile(3, 32, 48, 25682, 4, OP_OPAQUE);
			Cutscene_SetAttr(f1, CGI_DRAWLIFESPAN, -1);
			Cutscene_SetAttr(f2, CGI_DRAWLIFESPAN, -1);
			Cutscene_SetAttr(r1, CGI_DRAWLIFESPAN, -1);
			Cutscene_SetAttr(r2, CGI_DRAWLIFESPAN, -1);
			Cutscene_Waitframe(15);
			Cutscene_Glide(asher, -1, 24, 80, 1);
			Cutscene_Waitglide();
			Cutscene_RemoveDraw(asher);
			Cutscene_Waitframe(60);
			Cutscene_PlayString("Ugh... next time, for sure.", SCHAR_TORRIN, EMOTE_EMBARRASSED, 64, YPOS_UPPER);
			Cutscene_RemoveDraw(torrin);
			Cutscene_RemoveDraw(door);
			Cutscene_RemoveDraw(f1);
			Cutscene_RemoveDraw(f2);
			Cutscene_RemoveDraw(r1);
			Cutscene_RemoveDraw(r2);
			
			Game->DMapPalette[Game->GetCurDMap()] = 0x050;
			cutsceneG[CG_BGMAP] = 2;
			Cutscene_AnchorCamera(0x58, 0x58, 1, 1);
			
			asher = Cutscene_NewNPC(2, 192, 128, CMB_ASHER, 6, OP_OPAQUE);
			Cutscene_SetFlag(asher, CGF_4WAY|CGF_BIGNPC);
			Cutscene_SetDir(asher, DIR_UP);
			int mom = Cutscene_NewNPC(2, 192, 64, 33508, 6, OP_OPAQUE);
			Cutscene_SetFlag(mom, CGF_4WAY|CGF_BIGNPC);
			Cutscene_SetDir(mom, DIR_UP);
			
			f1 = Cutscene_NewFastCombo(1, 160, 112, 16697, 2, OP_OPAQUE);
			f2 = Cutscene_NewFastCombo(1, 160, 128, 16697, 2, OP_OPAQUE);
			int f3 = Cutscene_NewFastCombo(1, 176, 112, 16697, 2, OP_OPAQUE);
			int f4 = Cutscene_NewFastCombo(1, 176, 128, 16697, 2, OP_OPAQUE);
			int f5 = Cutscene_NewFastCombo(1, 64, 128, 16697, 2, OP_OPAQUE);
			int f6 = Cutscene_NewFastCombo(1, 80, 128, 16697, 2, OP_OPAQUE);
			int w1 = Cutscene_NewFastCombo(1, 64, 144, 16286, 2, OP_OPAQUE);
			int w2 = Cutscene_NewFastCombo(1, 80, 144, 16287, 2, OP_OPAQUE);
			int d1 = Cutscene_NewFastCombo(1, 160, 144, 16308, 2, OP_OPAQUE);
			int d2 = Cutscene_NewFastCombo(1, 176, 144, 16309, 2, OP_OPAQUE);
			int d3 = Cutscene_NewFastCombo(4, 160, 160, 16312, 2, OP_OPAQUE);
			int d4 = Cutscene_NewFastCombo(4, 176, 160, 16313, 2, OP_OPAQUE);
			Cutscene_SetAttr(f1, CGI_DRAWLIFESPAN, -1);
			Cutscene_SetAttr(f2, CGI_DRAWLIFESPAN, -1);
			Cutscene_SetAttr(f3, CGI_DRAWLIFESPAN, -1);
			Cutscene_SetAttr(f4, CGI_DRAWLIFESPAN, -1);
			Cutscene_SetAttr(f5, CGI_DRAWLIFESPAN, -1);
			Cutscene_SetAttr(f6, CGI_DRAWLIFESPAN, -1);
			Cutscene_SetAttr(w1, CGI_DRAWLIFESPAN, -1);
			Cutscene_SetAttr(w2, CGI_DRAWLIFESPAN, -1);
			Cutscene_SetAttr(d1, CGI_DRAWLIFESPAN, -1);
			Cutscene_SetAttr(d2, CGI_DRAWLIFESPAN, -1);
			Cutscene_SetAttr(d3, CGI_DRAWLIFESPAN, -1);
			Cutscene_SetAttr(d4, CGI_DRAWLIFESPAN, -1);
			
			for(int i = 0; i<60; i++){
				Cutscene_Update();
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				NoAction();
				BlackScreenLayerSix();
				Waitframe();
			}
			Cutscene_Waitframe(60);
			Cutscene_PlayString("Hey Mom...", SCHAR_ASHER, EMOTE_ELLIPSES, 64, YPOS_UPPER);
			Cutscene_SetDir(mom, DIR_DOWN);
			Cutscene_Waitframe(15);
			Cutscene_PlayString("Welcome home, Asher. Iris told me you had a lot on your mind recently. Do you want to talk about things?", SCHAR_MOM, EMOTE_NORMAL, 64, YPOS_LOWER);
			Cutscene_PlayString("Yeah... there's a lot I need to talk about.", SCHAR_ASHER, EMOTE_NORMAL, 64, YPOS_UPPER);
			
			
			for(int i = 0; i<60; i++){
				Cutscene_Update();
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				NoAction();
				BlackishScreenLayerSix();
				Waitframe();
			}
			Cutscene_RemoveDraw(asher);
			Cutscene_RemoveDraw(mom);
			Cutscene_RemoveDraw(f1);
			Cutscene_RemoveDraw(f2);
			Cutscene_RemoveDraw(f3);
			Cutscene_RemoveDraw(f4);
			Cutscene_RemoveDraw(f5);
			Cutscene_RemoveDraw(f6);
			Cutscene_RemoveDraw(w1);
			Cutscene_RemoveDraw(w2);
			Cutscene_RemoveDraw(d1);
			Cutscene_RemoveDraw(d2);
			Cutscene_RemoveDraw(d3);
			Cutscene_RemoveDraw(d4);
			for(int i = 0; i<60; i++){
				Cutscene_Update();
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				NoAction();
				BlackScreenLayerSix();
				Waitframe();
			}
			Game->PlayMIDI(0);
			for(int i = 0; i<60; i++){
				Cutscene_Update();
				Link->InputMap = false; Link->PressMap = false;
				Link->InputStart = false; Link->PressStart = false;
				NoAction();
				BlackScreenLayerSix();
				Waitframe();
			}
	}
		Game->PlayEnhancedMusic("SS-Cosmic.ogg", 0);
		// Game->DMapPalette[Game->GetCurDMap()] = 0x0EE;
		// cutsceneG[CG_BGMAP] = 1;
		// Cutscene_AnchorCamera(0x32, 0x32, 1, 1);
		// int selet = Cutscene_NewNPC(2, 120, 72, 33308, 6, OP_OPAQUE);
		// Cutscene_SetFlag(selet, CGF_4WAY|CGF_BIGNPC);
		// Cutscene_SetDir(selet, DIR_UP);
		// for(int i = 0; i<60; i++){
			// Cutscene_Update();
			// Link->InputMap = false; Link->PressMap = false;
			// Link->InputStart = false; Link->PressStart = false;
			// NoAction();
			// BlackScreenLayerSix();
			// Waitframe();
		// }
		// for(int i = 0; i<60; i++){
			// Cutscene_Update();
			// Link->InputMap = false; Link->PressMap = false;
			// Link->InputStart = false; Link->PressStart = false;
			// NoAction();
			// BlackishScreenLayerSix();
			// Waitframe();
		// }
		// Cutscene_Waitframe(180);
		// Cutscene_PlayString("As promised, I have kept up my end of the bargain. Now then, I believe it's time you answered my questions.", SCHAR_SELET, EMOTE_NORMAL, 64, YPOS_LOWER);
		// for(int i = 0; i<60; i++){
			// Cutscene_Update();
			// Link->InputMap = false; Link->PressMap = false;
			// Link->InputStart = false; Link->PressStart = false;
			// NoAction();
			// BlackishScreenLayerSix();
			// Waitframe();
		// }
		// for(int i = 0; i<120; i++){
			// Cutscene_Update();
			// Link->InputMap = false; Link->PressMap = false;
			// Link->InputStart = false; Link->PressStart = false;
			// NoAction();
			// BlackScreenLayerSix();
			// Waitframe();
		// }
		int bitid3 = TempBitmap_Create(0, 256, 176);
		bitmap b3 = TempBMP[bitid3];
		
		int starDist[128];
		int starAng[128];
		int starStep[128];
		int stars[] = {starDist, starAng, starStep};
		
		for(int i=0; i<128; ++i){
			starDist[i] = Rand(256);
			starAng[i] = Rand(360);
		}
		
		int aTimer[3];
		for(int i=0; i<60; ++i){
			b3->Clear(0);
			DrawSpaceTunnel(b3, stars);
			b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
			Screen->Rectangle(6, 0, -56, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
			if(i<16)
				Screen->Rectangle(6, 0, -56, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
			if(i<8)
				Screen->Rectangle(6, 0, -56, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
			Link->InputMap = false; Link->PressMap = false;
			Link->InputStart = false; Link->PressStart = false;
			NoAction();
			Waitframe();
		}
		for(int i = -32; i<32; i++){
			b3->Clear(0);
			DrawSpaceTunnel(b3, stars);
			b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
			DrawEgg(aTimer, 112, i);
			Link->InputMap = false; Link->PressMap = false;
			Link->InputStart = false; Link->PressStart = false;
			NoAction();
			Waitframe();
		}
		for(int i = 0; i<90; i++){
			b3->Clear(0);
			DrawSpaceTunnel(b3, stars);
			b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
			DrawEgg(aTimer, 112, 32);
			Link->InputMap = false; Link->PressMap = false;
			Link->InputStart = false; Link->PressStart = false;
			NoAction();
			Waitframe();
		}
		for(int i = 0; i<45; i++){
			b3->Clear(0);
			DrawSpaceTunnel(b3, stars);
			b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
			DrawEgg(aTimer, 112, 32);
			Screen->DrawString(6, 128, -8-56+80, FONT_SHERWOOD, 0x01, -1, TF_CENTERED, "The End?", OP_TRANS, SHD_OUTLINED8, 0x0F);
			Link->InputMap = false; Link->PressMap = false;
			Link->InputStart = false; Link->PressStart = false;
			NoAction();
			Waitframe();
		}
		for(int i = 0; i<45; i++){
			b3->Clear(0);
			DrawSpaceTunnel(b3, stars);
			b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
			DrawEgg(aTimer, 112, 32);
			Screen->DrawString(6, 128, -8-56+80, FONT_SHERWOOD, 0x01, -1, TF_CENTERED, "The End?", OP_OPAQUE, SHD_OUTLINED8, 0x0F);
			Link->InputMap = false; Link->PressMap = false;
			Link->InputStart = false; Link->PressStart = false;
			NoAction();
			Waitframe();
		}
		
		int selection = 0;
		int maxSelections = 3;
		for(int i=0; i<12; ++i){
			DragEggBg(aTimer, 112, 32, b3, stars);
			DrawMenuOptions(64, selection, aTimer, false);
			if(i>=4)
				DrawMenuOptions(64, selection, aTimer, false);
			if(i>=8)
				DrawMenuOptions(128, selection, aTimer, false);
			Waitframe();
		}
		while(!Link->PressA){
			DragEggBg(aTimer, 112, 32, b3, stars);
			if(Link->PressUp){
				Game->PlaySound(5);
				--selection;
				if(selection<0){
					selection = maxSelections-1;
				}
			}
			else if(Link->PressDown){
				Game->PlaySound(5);
				++selection;
				if(selection>=maxSelections){
					selection = 0;
				}
			}
			
			DrawMenuOptions(128, selection, aTimer, true);
			NoAction();
			Waitframe();
		}
		for(int i=0; i<12; ++i){
			DrawMenuOptions(128, selection, aTimer, true);
			
			Screen->Rectangle(6, 0, -56, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
			if(i>4)
				Screen->Rectangle(6, 0, -56, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
			if(i>8)
				Screen->Rectangle(6, 0, -56, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
			Waitframe();
		}
		Game->Counter[CR_STORYFLAG] = SFLAG_GAMECLEAR;
		Game->LastEntranceDMap = Game->GetCurDMap();
		Game->LastEntranceScreen = 0x74;
		if(G[G_RANDOMIZERENABLED]){
			switch(GetCharID()){
				case CHAR_ASHER:
					Game->LastEntranceDMap = 1;
					Game->LastEntranceScreen = 0x61;
					break;
				case CHAR_TORRIN:
					Game->LastEntranceDMap = 26;
					Game->LastEntranceScreen = 0x2E;
					break;
				case CHAR_KAYLANI:
					Game->LastEntranceDMap = 28;
					Game->LastEntranceScreen = 0x09;
					break;
				case CHAR_SOREN:
					Game->LastEntranceDMap = 2;
					Game->LastEntranceScreen = 0x1C;
					break;
				case CHAR_TERRY:
					Game->LastEntranceDMap = 26;
					Game->LastEntranceScreen = 0x2E;
					break;
				case CHAR_SIYED:
					Game->LastEntranceDMap = 28;
					Game->LastEntranceScreen = 0x28;
					break;
			}
		}
		Game->ContinueDMap = Game->LastEntranceDMap;
		Game->ContinueScreen = Game->LastEntranceScreen;
		Link->HP = Link->MaxHP;
		DamageNumbers[_DNUM_LASTLINKHP] = Link->HP;
		Link->MP = Link->MaxMP;
		G[G_ASHERHP] = G[G_ASHERMAXHP];
		G[G_TORRINHP] = G[G_TORRINMAXHP];
		G[G_KAYLANIHP] = G[G_KAYLANIMAXHP];
		G[G_ASHERMP] = Link->MaxMP;
		G[G_KAYLANIMP] = Link->MaxMP;
		Link->Invisible = false;
		Screen->Rectangle(6, 0, -56, 255, 175, 0x0F, 1, 0, 0, 0, true, 128);
		G[G_SCREENCHANGED] = 1;
		switch(selection){
			case 0: //Continue
				Link->Warp(Game->LastEntranceDMap, Game->LastEntranceScreen-Game->DMapOffset[Game->LastEntranceDMap]);
				break;
			case 1: //Save and Continue
				Game->Save();
				Link->Warp(Game->LastEntranceDMap, Game->LastEntranceScreen-Game->DMapOffset[Game->LastEntranceDMap]);
				break;
			case 2: //Save and Quit
				Game->Save();
				Game->End();
				break;
		}
		
		while(true){
			b3->Clear(0);
			DrawSpaceTunnel(b3, stars);
			b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
			DrawEgg(aTimer, 112, 32);
			Link->InputMap = false; Link->PressMap = false;
			Link->InputStart = false; Link->PressStart = false;
			NoAction();
			Waitframe();
		}
	}
	void SeaScroll(){
		for(int i = -16; i<=256; i+=16){
			Screen->FastCombo(3, i + Screen->D[0]%16, 96, 42807, 2, OP_OPAQUE);
			for(int j = 112; j<=160; j+=16){
				Screen->FastCombo(3, i + Screen->D[0]%16, j, 42240, 2, OP_OPAQUE);
			}
		}
	}
	void TextFade(int Str, int Indent, int Fade, int Time){
		int Xanch = 16;
		int Yanch = 16;
		int Itr = SizeOfArray(Str);
		for(int i = 0; i < Fade; i++){
			for(int j = 0; j < Itr; j++){
				DrawStringOutline(2, Xanch + Indent[j], Yanch + j*12, FONT_P, 0x01, 0x0F, TF_NORMAL, Str[j], OP_TRANS);
			}
			CWait(1);
		}
		for(int i = 0; i < Time; i++){
			for(int j = 0; j < Itr; j++){
				DrawStringOutline(2, Xanch + Indent[j], Yanch + j*12, FONT_P, 0x01, 0x0F, TF_NORMAL, Str[j], OP_OPAQUE);
			}
			CWait(1);
		}
		for(int i = 0; i < Fade; i++){
			for(int j = 0; j < Itr; j++){
				DrawStringOutline(2, Xanch + Indent[j], Yanch + j*12, FONT_P, 0x01, 0x0F, TF_NORMAL, Str[j], OP_TRANS);
			}
			CWait(1);
		}
	}
	void TextFadeHeader(int W, int Str, int Indent, int Fade, int Time){
		int Xanch = 16;
		int Yanch = 16;
		int Itr = SizeOfArray(Str);
		for(int i = 0; i < Fade; i++){
			for(int j = 0; j < Itr; j++){
				DrawStringOutline(2, Xanch + Indent[j], Yanch + j*12, FONT_P, 0x01, 0x0F, TF_NORMAL, Str[j], (j==0 && W!=1)?OP_OPAQUE:OP_TRANS);
			}
			CWait(1);
		}
		for(int i = 0; i < Time; i++){
			for(int j = 0; j < Itr; j++){
				DrawStringOutline(2, Xanch + Indent[j], Yanch + j*12, FONT_P, 0x01, 0x0F, TF_NORMAL, Str[j], OP_OPAQUE);
			}
			CWait(1);
		}
		for(int i = 0; i < Fade; i++){
			for(int j = 0; j < Itr; j++){
				DrawStringOutline(2, Xanch + Indent[j], Yanch + j*12, FONT_P, 0x01, 0x0F, TF_NORMAL, Str[j], (j==0 && W!=2)?OP_OPAQUE:OP_TRANS);
			}
			CWait(1);
		}
	}
	void DrawEgg(int aTimer, int x, int y){
		int eggTile = 117006;
		++aTimer[2];
		if(aTimer[2]>=48)
			aTimer[2] = 0;
		eggTile += Floor(aTimer[2]/12)*2;
		Screen->DrawTile(6, x, y-4*Sin(aTimer[0]), eggTile, 2, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
	}
	void DragEggBg(int aTimer, int x, int y, bitmap b3, int stars){
		b3->Clear(0);
		DrawSpaceTunnel(b3, stars);
		b3->Blit(6, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
		DrawEgg(aTimer, x, y);
	}
	void DrawMenuOptions(int op, int selection, int aTimer, bool drawSel){
		aTimer[0] = (aTimer[0]+1)%360;
		Screen->DrawString(6, 128, -8-56+80, FONT_SHERWOOD, 0x01, -1, TF_CENTERED, "The End?", op, SHD_OUTLINED8, 0x0F);
	
		int sel1[] = "Continue";
		int sel2[] = "Save and Continue";
		int sel3[] = "Save and Quit";
		
		int selections[4];
		int numSel;
		selections[0] = sel1;
		selections[1] = sel2;
		selections[2] = sel3;
		numSel = 3;
		
		for(int i=0; i<numSel; ++i){
			if(selection==i&&drawSel)
				Screen->DrawString(6, 128, 60-56+80+32+16*i, FONT_Z3SMALL, aTimer[0]%8<2?0x01:0x72, -1, TF_CENTERED, selections[i], op, SHD_OUTLINED8, 0x0F);
			else
				Screen->DrawString(6, 128, 60-56+80+32+16*i, FONT_Z3SMALL, 0x01, -1, TF_CENTERED, selections[i], op, SHD_OUTLINED8, 0x0F);
		}
	}
	void CWait(int frames){
		for(int i = 0; i<frames; i++){
			Screen->D[0]+=0.5;
			SeaScroll();
			Screen->DrawScreen(1, 1, 0x5A, 0, 0, 0);
			Screen->FastCombo(3, 120, 88, 42238, 2, OP_OPAQUE);
			WaitNoAction();
		}
	}
}