//General process
//1. Create a bitmap
//2. Grab the appropriate body sprites and draw to the spot on the bitmap. Apply the skin ton and shirt color recolor functions
//3. Do the same for the leg sprites
//4. Layer in the correct order. For most sprites: Legs, Body, Head. For sunball down and side, Stellaire, richochet, concentration, and holdup sprites, Legs, Head, Body
//5. WriteTile from the bitmap back to the tile pages

const int TIL_HEADSTART = 135200;
const int TIL_BODYSTART = 135720;
const int TIL_LEGSSTART = 136500;

const int LOC_BODYX = 0;
const int LOC_BODYY = 0;
const int LOC_LEGSX = 0;
const int LOC_LEGSY = 32;
const int LOC_HEADX = 0;
const int LOC_HEADY = 64;
const int LOC_DRAWX = 0;
const int LOC_DRAWY = 128;

//This draws accessories that go over the player's head to a bitmap, for later drawing over/under the heads
void DrawAccessoryHeadToBitmap(bitmap b, int ColorArray, int which, int whichChar, int clr, int slot){
	int baseTil = AccessoryTile(which, whichChar);
	int flags = AccessoryFlags(which);
	if(baseTil>0){
		for(int i=0; i<40; ++i){ //Loop through each tile, draw the accessory
			int dir = AccessoryTileDir(i);
			//Holdup sprites need a special flag to have graphics
			//RIP holdup
			if(i==12){
				if(flags&ACF_SPECIALHOLDUP)
					dir = DIR_RIGHT;
				else
					dir = -1;
			}
			
			if(dir>-1){
				int xOff = AccessoryTileXOff(i);
				int yOff = AccessoryGlobalYOff(which) + AccessoryTileYOff(i);
				int yOff2 = yOff;
				
				//If it's drawn behind offset down by 64. Tiles on the bottom half of the bitmap will be drawn before the head
				if(dir==DIR_UP&&(flags&ACF_BEHINDUP))
					yOff += 64;
				if(dir==DIR_DOWN&&(flags&ACF_BEHINDDOWN))
					yOff += 64;
				
				int x = (i%20)*16;
				int y = Floor(i/20)*32;
				int flip = 0;
				//Accessories with the flipslot flag will flip when in slot 2
				if(flags&ACF_FLIPSLOT&&dir<DIR_LEFT&&slot==1)
					flip = 1;
				b->DrawTile(0, x+xOff, y+yOff, baseTil+dir, 1, 1, 0, -1, -1, 0, 0, 0, flip, true, 128);
				if(flags&ACF_CUTHAIR){
					b->Rectangle(0, x, y+yOff+16, x+15, y+yOff+16+(15-yOff2), 0x60, 1, 0, 0, 0, true, 128);
				}
			}
		}
	}
	if(!(flags&ACF_NORECOLOR)){ //Now let's recolor it from red to the proper color
		int specialWhite = ColorSpecialWhite(clr);
		if((flags&ACF_SPECIALWHITE)&&specialWhite>0)
			b->ReplaceColors(0, specialWhite, 0x71, 0x71);
		b->ReplaceColors(0, ColorArray[3*clr], 0x6C, 0x6C);
		b->ReplaceColors(0, ColorArray[3*clr+1], 0x6D, 0x6D);
		b->ReplaceColors(0, ColorArray[3*clr+2], 0x6E, 0x6E);
	}
}
void DrawAccessoryBodyToBitmap(bitmap b, int ColorArray, int which, int whichChar, int clr, int slot){
	int baseTil = AccessoryTile(which, whichChar);
	int flags = AccessoryFlags(which);
	if(baseTil>0){
		b->DrawTile(0, 0, 0, baseTil, 20, 2, 0, -1, -1, 0, 0, 0, 0, true, 128);
	}
	if(!(flags&ACF_NORECOLOR)){ //Now let's recolor it from red to the proper color
		int specialWhite = ColorSpecialWhite(clr);
		if((flags&ACF_SPECIALWHITE)&&specialWhite>0)
			b->ReplaceColors(0, specialWhite, 0x71, 0x71);
		b->ReplaceColors(0, ColorArray[3*clr], 0x6C, 0x6C);
		b->ReplaceColors(0, ColorArray[3*clr+1], 0x6D, 0x6D);
		b->ReplaceColors(0, ColorArray[3*clr+2], 0x6E, 0x6E);
	}
}

int NetSpritesheetX(int which, int id){
	return Floor(id/8)*320+640*which;
}
int NetSpritesheetY(int which, int id){
	return (id%8)*96;
}
int CharLTM(int which){
	switch(which){
		case CHAR_TORRIN:
			return 40;
		case CHAR_KAYLANI:
			return 80;
		case CHAR_SOREN:
			return -2600;
		case CHAR_TERRY:
			return -2560;
		case CHAR_SIYED:
			return -2520;
	}
}
void NetSpriteXY(int xy, int til, int tilchar){
	int abstil = til;
	abstil -= CharLTM(tilchar);
	switch(abstil){
		case 104140...104152: // Walking, Attacking, Holdup
			xy[0] = 16*(abstil-104140);
			xy[1] = 0;
			return;
		case 104280...104292: // Swimming, Diving, Holdup
			xy[0] = 16*(abstil-104280);
			xy[1] = 64;
			return;
	}
	switch(til){
		case 104543...104545: // Asher dash
			xy[0] = 15*16+16*(til-104543);
			xy[1] = 0;
			return;
		case 104546: // Asher rising
			xy[0] = 18*16;
			xy[1] = 0;
			return;
		case 104547...104550: // Asher funny hair
			xy[0] = 19*16;
			xy[1] = 0;
			return;
		case 104540...104542: // Kaylani charge down
			xy[0] = 0*16+16*(til-104540);
			xy[1] = 32;
			return;
		case 104580...104582: // Kaylani charge side
			xy[0] = 3*16+16*(til-104580);
			xy[1] = 32;
			return;
		case 104620...104622: // Kaylani charge up
			xy[0] = 6*16+16*(til-104620);
			xy[1] = 32;
			return;
		case 104660...104662: // Kaylani charge release
			xy[0] = 6*16+16*(til-104660);
			xy[1] = 32;
			return;
		case 104660...104662: // Kaylani charge release
			xy[0] = 6*16+16*(til-104660);
			xy[1] = 32;
			return;
		case 101553...101555: // Soren chuck
			xy[0] = 12*16+16*(til-101553);
			xy[1] = 32;
			return;
		case 101593...101594: // Terry robbery
			xy[0] = 15*16+16*(til-101593);
			xy[1] = 32;
			return;
		case 101599: // Terry toss
			xy[0] = 17*16;
			xy[1] = 32;
			return;
		case 101633: // Siyed cast
			xy[0] = 18*16;
			xy[1] = 32;
			return;
	}
	switch(Link->Dir){
		case DIR_UP:
			xy[0] = 6*16;
			xy[1] = 0;
			break;
		case DIR_LEFT:
			xy[0] = 3*16;
			xy[1] = 0;
			break;
			break;
		default:
			xy[0] = 0*16;
			xy[1] = 0;
			break;
			break;
	}
}
void NetSpritesheetBlit(bitmap b, bitmap swimb, int which, int userID){
	int x = NetSpritesheetX(which, userID);
	int y = NetSpritesheetY(which, userID);
	GBMP[BMP_MULTIPLAYERSPRITES]->Rectangle(0, x, y, x+319, y+95, 0x00, 1, 0, 0, 0, true, 128);
	b->Blit(0, GBMP[BMP_MULTIPLAYERSPRITES], LOC_DRAWX, LOC_DRAWY, 320, 64, x, y, 320, 64, 0, 0, 0, BITDX_NORMAL, 0, true);
	swimb->Blit(0, GBMP[BMP_MULTIPLAYERSPRITES], 0, 0, 208, 32, x, y+64, 208, 32, 0, 0, 0, BITDX_NORMAL, 0, true);
}

void SetUpOutfit(int which, int userID, int outfitOverride){ //0-24
	enum{
		SHIRT,
		SHIRTCOLOR,
		PANTS,
		PANTSCOLOR,
		ACCESSORY1,
		ACCESSORY1COLOR,
		ACCESSORY2,
		ACCESSORY2COLOR
	};
	G[G_TEMPSHIRT] = G[G_SHIRT+which];
	G[G_TEMPSHIRTCOLOR] = G[G_SHIRTCOLOR+which];
	G[G_TEMPPANTS] = G[G_PANTS+which];
	G[G_TEMPPANTSCOLOR] = G[G_PANTSCOLOR+which];
	G[G_TEMPACCESSORY1] = G[G_ACCESSORY1+which];
	G[G_TEMPACCESSORY1COLOR] = G[G_ACCESSORY1COLOR+which];
	G[G_TEMPACCESSORY2] = G[G_ACCESSORY2+which];
	G[G_TEMPACCESSORY2COLOR] = G[G_ACCESSORY2COLOR+which];
	if(userID>-1){
		G[G_TEMPSHIRT] = outfitOverride[0];
		G[G_TEMPSHIRTCOLOR] = outfitOverride[1];
		G[G_TEMPPANTS] = outfitOverride[2];
		G[G_TEMPPANTSCOLOR] = outfitOverride[3];
		G[G_TEMPACCESSORY1] = outfitOverride[4];
		G[G_TEMPACCESSORY1COLOR] = outfitOverride[5];
		G[G_TEMPACCESSORY2] = outfitOverride[6];
		G[G_TEMPACCESSORY2COLOR] = outfitOverride[7];
	}

	int headTil = TIL_HEADSTART+which*80;
	int bodyTil = TIL_BODYSTART+G[G_TEMPSHIRT]*40;
	int legsTil = TIL_LEGSSTART+G[G_TEMPPANTS]*40;
	//printf("LegsTil: %d, ID: %d\n\n", TIL_LEGSSTART, G[G_PANTS+which]);
	//Colors 			Red					Crimson				Pale Pink			Orange				Golden Yellow		Yellow				Green				Pale Green			Dull Green			Forest Green		Blue				Sky Blue			Deep Blue			Denim Blue			Periwinkle			Pale Periwinkle		Purple				Pale Purple			Malka Purple		Mud Brown			White				Light Grey			Dark Grey			Light Black			Dark Black			Nigredo
	int ColorArray[] = {0x6C, 0x6D, 0x6E, 	0x83, 0x84, 0x85,	0xB6, 0xB7, 0xB8,	0x87, 0x88, 0x89,	0x86, 0x87, 0x88,	0x5C, 0x5D, 0xc5E,	0x77, 0x78, 0x79,	0x92, 0x93, 0x94,	0x93, 0x94, 0x95,	0x57, 0x58, 0x59,	0x72, 0x73, 0x74,	0x71, 0x72, 0x73,	0x73, 0x74, 0x75,	0x67, 0x68, 0x69,	0xA3, 0xA4, 0xA5,	0xA2, 0xA3, 0xA4,	0x97, 0x98, 0x99,	0x96, 0x97, 0x98,	0x98, 0x6A, 0x6B,	0x65, 0x5A, 0x5B,	0xB1, 0xB2, 0xB3,	0x7C, 0x7D, 0x7E,	0x7D, 0x7E, 0x7F,	0x52, 0x53, 0x54,	0x53, 0x54, 0x55,	0x54, 0x55, 0x6F};
	bitmap b = Game->CreateBitmap(320,192); //Create the bitmap
	
	bitmap bAcc1 = Game->CreateBitmap(320, 128); //Now begins Moosh's accessory block, with significantly fewer comments
	bitmap bAcc2 = Game->CreateBitmap(320, 128);
	bitmap bAcc1b = Game->CreateBitmap(320, 128); 
	bitmap bAcc2b = Game->CreateBitmap(320, 128);
	
	//Accessories have to be processed first
	int accessory1 = G[G_TEMPACCESSORY1];
	int accessory2 = G[G_TEMPACCESSORY2];
	bool accessory1Body = IsBodyAccessory(accessory1);
	bool accessory2Body = IsBodyAccessory(accessory2);
	int altHeadColor;
	bool headReplaced;
	if(G[G_TEMPACCESSORY1]>ACCESSORY_NONE&&!accessory1Body){
		if(!(AccessoryFlags(accessory1)&ACF_REPLACEHEAD))
			DrawAccessoryHeadToBitmap(bAcc1, ColorArray, G[G_TEMPACCESSORY1], which, G[G_TEMPACCESSORY1COLOR], 0);
		else{
			headTil = AccessoryTile(accessory1, which);
			altHeadColor = G[G_TEMPACCESSORY1COLOR];
			headReplaced = true;
		}
	}
	if(G[G_TEMPACCESSORY2]>ACCESSORY_NONE&&!accessory2Body){
		if(!(AccessoryFlags(accessory2)&ACF_REPLACEHEAD))
			DrawAccessoryHeadToBitmap(bAcc2, ColorArray, G[G_TEMPACCESSORY2], which, G[G_TEMPACCESSORY2COLOR], 1);
		else{
			headTil = AccessoryTile(accessory2, which);
			altHeadColor = G[G_TEMPACCESSORY2COLOR];
			headReplaced = true;
		}
	}
	if(G[G_TEMPSHIRT] == TOP_HOODIE1 && G[G_TEMPACCESSORY1] != ACCESSORY_HOODIE && G[G_TEMPACCESSORY2] != ACCESSORY_HOODIE && which != CHAR_KAYLANI && which != CHAR_TERRY) //Stupid bit for drawing the up facing hoodie
		DrawAccessoryHeadToBitmap(bAcc2, ColorArray, ACCESSORY_HOODIEDOWN, which, G[G_TEMPSHIRTCOLOR], 1);
	if(G[G_TEMPSHIRT] == TOP_HOODIE1 && (G[G_TEMPACCESSORY1] == ACCESSORY_HOODIE || G[G_TEMPACCESSORY2] == ACCESSORY_HOODIE)) //Stupid bit for removing the hood from the hoodie if wearing the hood up
		bodyTil += 40;
	
	//So they can be blitted to the bitmap first and draw under the whole body
	b->BlitTo(0, bAcc1, 0, 64, 320, 64, LOC_DRAWX, LOC_DRAWY, 320, 64, 0, 0, 0, BITDX_NORMAL, 0, true);
	b->BlitTo(0, bAcc2, 0, 64, 320, 64, LOC_DRAWX, LOC_DRAWY, 320, 64, 0, 0, 0, BITDX_NORMAL, 0, true);
	
	bitmap b0 = Game->CreateBitmap(320, 32); //So we can recolor the shirt, we gotta make a separate bitmap;
	b0->DrawTile(0, LOC_BODYX, LOC_BODYY, bodyTil, 20, 2, 0, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE); //Draw the bodies to the proper location	
	if(G[G_TEMPSHIRT] == TOP_HOODIE1 && G[G_TEMPACCESSORY1] != ACCESSORY_HOODIE && G[G_TEMPACCESSORY2] != ACCESSORY_HOODIE && which == CHAR_SIYED){ //Hoodie was a mistake
		b0->DrawTile(0, LOC_BODYX+48, LOC_BODYY+16, 135052, 3, 1, 0, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE); //Draw Siyed's special sunball side sprite with hood molded to his head's silhouette 
	}
	if(G[G_TEMPSHIRTCOLOR] != 0){ //Now let's recolor it from red to the proper color
		b0->ReplaceColors(0, ColorArray[3*G[G_TEMPSHIRTCOLOR]], 0x6C, 0x6C);
		b0->ReplaceColors(0, ColorArray[3*G[G_TEMPSHIRTCOLOR]+1], 0x6D, 0x6D);
		b0->ReplaceColors(0, ColorArray[3*G[G_TEMPSHIRTCOLOR]+2], 0x6E, 0x6E);
	}
	b->BlitTo(0, b0, LOC_BODYX, LOC_BODYY, 320, 32, LOC_BODYX, LOC_BODYY, 320, 32, 0, 0, 0, BITDX_NORMAL, 0, false); //Copy our recolored body to the bitmap in the proper location
	b0->Free();
	
	bitmap b1 = Game->CreateBitmap(320, 32); //So we can recolor the pants, we gotta make a separate bitmap;
	//If the top is fly, legs need not apply
	if(!CostumeChanger.SpecialTop(G[G_TEMPSHIRT])){
		b1->DrawTile(0, 0, 0, legsTil, 20, 2, 0, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE); //Draw the legs to the new bitmap
		if(G[G_TEMPPANTSCOLOR] != 0){ //Now we do the same recolor routine
			b1->ReplaceColors(0, ColorArray[3*G[G_TEMPPANTSCOLOR]], 0x6C, 0x6C);
			b1->ReplaceColors(0, ColorArray[3*G[G_TEMPPANTSCOLOR]+1], 0x6D, 0x6D);
			b1->ReplaceColors(0, ColorArray[3*G[G_TEMPPANTSCOLOR]+2], 0x6E, 0x6E);
		}
		b->BlitTo(0, b1, 0, 0, 320, 32, LOC_LEGSX, LOC_LEGSY, 320, 32, 0, 0, 0, BITDX_NORMAL, 0, false); //Copy our recolored legs and pants to the bitmap in the proper location
	}
	b1->Free(); //Release that bitmap now that we're done with it
	
	//Accessories again, for body accessories this time
	if(G[G_TEMPACCESSORY1]>ACCESSORY_NONE&&accessory1Body){
		DrawAccessoryBodyToBitmap(bAcc1b, ColorArray, G[G_TEMPACCESSORY1], which, G[G_TEMPACCESSORY1COLOR], 0);
	}
	if(G[G_TEMPACCESSORY2]>ACCESSORY_NONE&&accessory2Body){
		DrawAccessoryBodyToBitmap(bAcc2b, ColorArray, G[G_TEMPACCESSORY2], which, G[G_TEMPACCESSORY2COLOR], 1);
	}
	//Oldspice accessory block bodyblits
	b->BlitTo(0, bAcc1b, 0, 0, 320, 32, LOC_BODYX, LOC_BODYY, 320, 32, 0, 0, 0, BITDX_NORMAL, 0, true);
	b->BlitTo(0, bAcc2b, 0, 0, 320, 32, LOC_BODYX, LOC_BODYY, 320, 32, 0, 0, 0, BITDX_NORMAL, 0, true);
	
	
	if(which == CHAR_TORRIN || which == CHAR_TERRY){ //Replace the white skin with tan skin for Torrin and Terry
		b->ShiftColors(0, 1, 0x62, 0x63);
	}
	else if(which == CHAR_KAYLANI || which == CHAR_SIYED){ //Replace the white skin with black skin for Kaylani and Siyed
		b->ShiftColors(0, 2, 0x62, 0x63);
	}
	if(headReplaced){ //If an accessory has changed the head, swap out the normal draws
		bitmap bHead = Game->CreateBitmap(320, 64);
		bHead->DrawTile(0, 0, 0, headTil, 20, 4, 0, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE); //Now that skin tones are replaced, draw the heads to the right location
		if(altHeadColor>0){
			bHead->ReplaceColors(0, ColorArray[3*altHeadColor], 0x6C, 0x6C);
			bHead->ReplaceColors(0, ColorArray[3*altHeadColor+1], 0x6D, 0x6D);
			bHead->ReplaceColors(0, ColorArray[3*altHeadColor+2], 0x6E, 0x6E);
		}
		b->BlitTo(0, bHead, 0, 0, 320, 64, LOC_HEADX, LOC_HEADY, 320, 64, 0, 0, 0, BITDX_NORMAL, 0, true);
		bHead->Free();
	}
	else
		b->DrawTile(0, LOC_HEADX, LOC_HEADY, headTil, 20, 4, 0, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE); //Now that skin tones are replaced, draw the heads to the right location
	
	//Now draw the part of accessories that goes in front of the head
	b->BlitTo(0, bAcc1, 0, 0, 320, 64, LOC_HEADX, LOC_HEADY, 320, 64, 0, 0, 0, BITDX_NORMAL, 0, true);
	b->BlitTo(0, bAcc2, 0, 0, 320, 64, LOC_HEADX, LOC_HEADY, 320, 64, 0, 0, 0, BITDX_NORMAL, 0, true);
	
	b->ReplaceColors(0, 0x00, 0x60, 0x60); //Mask out parts of hair covered by hats
	
	if(altHeadColor){
		b->ReplaceColors(0, ColorArray[3*G[G_TEMPPANTSCOLOR]], 0x6C, 0x6C);
		b->ReplaceColors(0, ColorArray[3*G[G_TEMPPANTSCOLOR]+1], 0x6D, 0x6D);
		b->ReplaceColors(0, ColorArray[3*G[G_TEMPPANTSCOLOR]+2], 0x6E, 0x6E);
	}
	
	if(which == CHAR_TORRIN || which == CHAR_TERRY){ //Now we gotta recolor the skin from alt heads like the cultist hood
		b->ReplaceColors(0, 0x64, 0xBA, 0xBA);
		b->ReplaceColors(0, 0x65, 0xBB, 0xBB);
	}
	else if(which == CHAR_KAYLANI || which == CHAR_SIYED){ //For all three sets of characters
		b->ReplaceColors(0, 0x65, 0xBA, 0xBA);
		b->ReplaceColors(0, 0x5A, 0xBB, 0xBB);
	}
	else{ //Asher and Soren needs shadows from the cultist hood recolored
		b->ReplaceColors(0, 0x63, 0xBA, 0xBA);
		b->ReplaceColors(0, 0x64, 0xBB, 0xBB);
	}
	
	bAcc1->Free();
	bAcc2->Free();
	bAcc1b->Free();
	bAcc2b->Free();
	
	b->BlitTo(0, b, LOC_LEGSX, LOC_LEGSY, 320, 16, LOC_DRAWX, LOC_DRAWY + 16, 320, 16, 0, 0, 0, BITDX_NORMAL, 0, true); //Put the first row of leg tiles in the right position.
	b->BlitTo(0, b, LOC_LEGSX, LOC_LEGSY + 16, 320, 16, LOC_DRAWX, LOC_DRAWY + 48, 320, 16, 0, 0, 0, BITDX_NORMAL, 0, true); //Same for the second
	b->BlitTo(0, b, LOC_BODYX, LOC_BODYY, 320, 16, LOC_DRAWX, LOC_DRAWY + 16, 320, 16, 0, 0, 0, BITDX_NORMAL, 0, true); //Put the first row of body tiles in the right position over the legs.
	b->BlitTo(0, b, LOC_BODYX, LOC_BODYY + 16, 320, 16, LOC_DRAWX, LOC_DRAWY + 48, 320, 16, 0, 0, 0, BITDX_NORMAL, 0, true); //Same for the second
	b->BlitTo(0, b, LOC_HEADX, LOC_HEADY, 320, 64, LOC_DRAWX, LOC_DRAWY, 320, 64, 0, 0, 0, BITDX_NORMAL, 0, true); //Now we paste the head on
	b->BlitTo(0, b, LOC_BODYX+192, LOC_BODYY, 16, 16, LOC_DRAWX+192, LOC_DRAWY+16, 16, 16, 0, 0, 0, BITDX_NORMAL, 0, true); //And now for the ones with arms layered over the head, we have to repaste the body. First: Holdup
	b->BlitTo(0, b, LOC_BODYX+304, LOC_BODYY, 32, 16, LOC_DRAWX+304, LOC_DRAWY+16, 32, 16, 0, 0, 0, BITDX_NORMAL, 0, true); //Next: Stellaire
	b->BlitTo(0, b, LOC_BODYX, LOC_BODYY+16, 96, 16, LOC_DRAWX, LOC_DRAWY+48, 96, 16, 0, 0, 0, BITDX_NORMAL, 0, true); //Next: Sun Ball Charge
	b->BlitTo(0, b, LOC_BODYX+192, LOC_BODYY+16, 48, 16, LOC_DRAWX+192, LOC_DRAWY+48, 48, 16, 0, 0, 0, BITDX_NORMAL, 0, true); //Next: Richochet
	b->BlitTo(0, b, LOC_BODYX+272, LOC_BODYY+16, 32, 16, LOC_DRAWX+272, LOC_DRAWY+48, 32, 16, 0, 0, 0, BITDX_NORMAL, 0, true); //Finally: Battery and Concentration
	
	bitmap swimb = Game->CreateBitmap(256, 32);
	swimb->BlitTo(0, b, LOC_DRAWX, LOC_DRAWY, 48, 32, 0, 8, 48, 32, 0, 0, 0, BITDX_NORMAL, 0, true);
	swimb->BlitTo(0, b, LOC_DRAWX+48, LOC_DRAWY, 48, 32, 47, 8, 48, 32, 0, 0, 0, BITDX_NORMAL, 0, true);
	swimb->BlitTo(0, b, LOC_DRAWX+96, LOC_DRAWY, 48, 32, 96, 6, 48, 32, 0, 0, 0, BITDX_NORMAL, 0, true);
	swimb->DrawTile(0, 144, 16, 104377, 3, 1, 0, -1, -1, 0, 0, 0, 0, true, 128); //Draw dive tiles
	swimb->BlitTo(0, b, LOC_DRAWX+208, LOC_DRAWY, 16, 32, 208, 8, 16, 32, 0, 0, 0, BITDX_NORMAL, 0, true);
	swimb->DrawTile(0, 0, 16, 104500, 13, 1, 0, -1, -1, 0, 0, 0, 0, true, 128); //Draw water overlays
	swimb->ReplaceColors(0, 0x00, 0x60, 0x60);
	//Erase pixels along sides of swimming sprites to fix a drawing bug
	for(int i=0; i<9; ++i){
		swimb->Line(0, 16*i, 0, 16*i, 31, 0x00, 1, 0, 0, 0, 128);
		swimb->Line(0, 16*i+15, 0, 16*i+15, 31, 0x00, 1, 0, 0, 0, 128);
	}
	
	if(which == CHAR_ASHER){ //Now we gotta draw these to the right part of the tile page to overwrite the sprites. This is the annoying part...
		if(userID==-1){
			for(int i = LOC_DRAWX; i< LOC_DRAWX+208; i+=16){ //Walking, attacking, hold up
				for(int j = LOC_DRAWY; j <= LOC_DRAWY+16; j+=16){
					b->WriteTile(0, i, j, 104120 + (i-LOC_DRAWX)/16 + (j-LOC_DRAWY)/16*20, true, false);
				}
			}
			for(int i = 0; i< 192; i+=16){ //Swimming Tiles
				for(int j = 0; j <= 16; j+=16){
					swimb->WriteTile(0, i, j, 104260 + i/16 + j/16*20, true, false);
				}
			}
			for(int j = LOC_DRAWY; j <= LOC_DRAWY+16; j+=16){ //Crouch
				b->WriteTile(0, LOC_DRAWX+208, j, 105300+ (j-LOC_DRAWY)/16*20, true, false);
			}
			for(int j = LOC_DRAWY; j <= LOC_DRAWY+16; j+=16){ //Selet fling
				b->WriteTile(0, LOC_DRAWX+224, j, 105303+ (j-LOC_DRAWY)/16*20, true, false);
			}
			for(int i = LOC_DRAWX+240; i< LOC_DRAWX+288; i+=16){ //Dash first row
				for(int j = LOC_DRAWY; j <= LOC_DRAWY+16; j+=16){
					b->WriteTile(0, i, j, 104523 + (i-LOC_DRAWX-240)/16 + (j-LOC_DRAWY)/16*20, true, false);
				}
			}
			// for(int i = LOC_DRAWX; i< LOC_DRAWX+48; i+=16){ //Dash other rows
				// for(int j = LOC_DRAWY+64; j < LOC_DRAWY+160; j+=16){
					// b->WriteTile(0, i, j, 104563 + (i-LOC_DRAWX)/16 + (j-LOC_DRAWY-64)/16*20, true, false);
				// }
			// }
			for(int j = LOC_DRAWY; j <= LOC_DRAWY+16; j+=16){ //Stellaire first frame
				b->WriteTile(0, LOC_DRAWX+288, j, 104526+ (j-LOC_DRAWY)/16*20, true, false);
			}
			for(int i = 0; i<4; i++){ //Stellaire other frames, we're copying the face 4 times since only the hair (upper tile) changes
				b->WriteTile(0, LOC_DRAWX+304, LOC_DRAWY+16, 104547 + i, true, false);
			}
		}
		else{
			NetSpritesheetBlit(b, swimb, which, userID);
		}
	}
	if(which == CHAR_TORRIN){ //At least Torrin's a lot easier
		if(userID==-1){
			for(int i = LOC_DRAWX; i< LOC_DRAWX+208; i+=16){ //Walking, attacking, hold up
				for(int j = LOC_DRAWY; j <= LOC_DRAWY+16; j+=16){
					b->WriteTile(0, i, j, 104160 + (i-LOC_DRAWX)/16 + (j-LOC_DRAWY)/16*20, true, false);
				}
			}
			for(int i = 0; i< 192; i+=16){ //Swimming Tiles
				for(int j = 0; j <= 16; j+=16){
					swimb->WriteTile(0, i, j, 104300 + i/16 + j/16*20, true, false);
				}
			}
			for(int j = LOC_DRAWY; j <= LOC_DRAWY+16; j+=16){ //Crouch
				b->WriteTile(0, LOC_DRAWX+208, j, 105301+ (j-LOC_DRAWY)/16*20, true, false);
			}
			for(int j = LOC_DRAWY; j <= LOC_DRAWY+16; j+=16){ //Selet fling
				b->WriteTile(0, LOC_DRAWX+224, j, 105304+ (j-LOC_DRAWY)/16*20, true, false);
			}
		}
		else{
			NetSpritesheetBlit(b, swimb, which, userID);
		}
	}
	if(which == CHAR_KAYLANI){ //Kay's got the sunball to deal with, but at least we can reuse some of this for Siyed too
		if(userID==-1){
			for(int i = LOC_DRAWX; i< LOC_DRAWX+208; i+=16){ //Walking, attacking, hold up
				for(int j = LOC_DRAWY; j <= LOC_DRAWY+16; j+=16){
					b->WriteTile(0, i, j, 104200 + (i-LOC_DRAWX)/16 + (j-LOC_DRAWY)/16*20, true, false);
				}
			}
			for(int i = 0; i< 192; i+=16){ //Swimming Tiles
				for(int j = 0; j <= 16; j+=16){
					swimb->WriteTile(0, i, j, 104340 + i/16 + j/16*20, true, false);
				}
			}
			for(int j = LOC_DRAWY; j <= LOC_DRAWY+16; j+=16){ //Crouch
				b->WriteTile(0, LOC_DRAWX+208, j, 105302+ (j-LOC_DRAWY)/16*20, true, false);
			}
			for(int j = LOC_DRAWY; j <= LOC_DRAWY+16; j+=16){ //Selet fling
				b->WriteTile(0, LOC_DRAWX+224, j, 105305+ (j-LOC_DRAWY)/16*20, true, false);
			}
			for(int i = LOC_DRAWX; i< LOC_DRAWX+48; i+=16){ //Sunball tiles down
				for(int j = LOC_DRAWY+32; j <= LOC_DRAWY+48; j+=16){
					b->WriteTile(0, i, j, 104520 + (i-LOC_DRAWX)/16 + (j-LOC_DRAWY-32)/16*20, true, false);
				}
			}
			for(int i = LOC_DRAWX+48; i< LOC_DRAWX+96; i+=16){ //Sunball tiles side
				for(int j = LOC_DRAWY+32; j <= LOC_DRAWY+48; j+=16){
					b->WriteTile(0, i, j, 104560 + (i-LOC_DRAWX-48)/16 + (j-LOC_DRAWY-32)/16*20, true, false);
				}
			}
			for(int i = LOC_DRAWX+96; i< LOC_DRAWX+144; i+=16){ //Sunball tiles side
				for(int j = LOC_DRAWY+32; j <= LOC_DRAWY+48; j+=16){
					b->WriteTile(0, i, j, 104600 + (i-LOC_DRAWX-96)/16 + (j-LOC_DRAWY-32)/16*20, true, false);
				}
			}
			for(int i = LOC_DRAWX+144; i< LOC_DRAWX+192; i+=16){ //Sunball tiles release
				for(int j = LOC_DRAWY+32; j <= LOC_DRAWY+48; j+=16){
					b->WriteTile(0, i, j, 104640 + (i-LOC_DRAWX-144)/16 + (j-LOC_DRAWY-32)/16*20, true, false);
				}
			}
		}
		else{
			NetSpritesheetBlit(b, swimb, which, userID);
		}
	}
	if(which == CHAR_SOREN){ //Soren's got the bomb sprites to worry about
		if(userID==-1){
			for(int i = LOC_DRAWX; i< LOC_DRAWX+208; i+=16){ //Walking, attacking, hold up
				for(int j = LOC_DRAWY; j <= LOC_DRAWY+16; j+=16){
					b->WriteTile(0, i, j, 101520 + (i-LOC_DRAWX)/16 + (j-LOC_DRAWY)/16*20, true, false);
				}
			}
			for(int i = 0; i< 192; i+=16){ //Swimming Tiles
				for(int j = 0; j <= 16; j+=16){
					swimb->WriteTile(0, i, j, 101660 + i/16 + j/16*20, true, false);
				}
			}
			for(int j = LOC_DRAWY; j <= LOC_DRAWY+16; j+=16){ //Crouch
				b->WriteTile(0, LOC_DRAWX+208, j, 105469+ (j-LOC_DRAWY)/16*20, true, false);
			}
			for(int j = LOC_DRAWY; j <= LOC_DRAWY+16; j+=16){ //Selet fling
				b->WriteTile(0, LOC_DRAWX+224, j, 105429+ (j-LOC_DRAWY)/16*20, true, false);
			}
			for(int i = LOC_DRAWX+192; i< LOC_DRAWX+240; i+=16){ //Bomb toss
				for(int j = LOC_DRAWY+32; j <= LOC_DRAWY+48; j+=16){
					b->WriteTile(0, i, j, 101533 + (i-LOC_DRAWX-192)/16 + (j-LOC_DRAWY-32)/16*20, true, false);
				}
			}
		}
		else{
			NetSpritesheetBlit(b, swimb, which, userID);
		}
	}
	if(which == CHAR_TERRY){ //Terry's got two extra animations to copy
		if(userID==-1){
			for(int i = LOC_DRAWX; i< LOC_DRAWX+208; i+=16){ //Walking, attacking, hold up
				for(int j = LOC_DRAWY; j <= LOC_DRAWY+16; j+=16){
					b->WriteTile(0, i, j, 101560 + (i-LOC_DRAWX)/16 + (j-LOC_DRAWY)/16*20, true, false);
				}
			}
			for(int i = 0; i< 192; i+=16){ //Swimming Tiles
				for(int j = 0; j <= 16; j+=16){
					swimb->WriteTile(0, i, j, 101700 + i/16 + j/16*20, true, false);
				}
			}
			for(int j = LOC_DRAWY; j <= LOC_DRAWY+16; j+=16){ //Crouch
				b->WriteTile(0, LOC_DRAWX+208, j, 105470+ (j-LOC_DRAWY)/16*20, true, false);
			}
			for(int j = LOC_DRAWY; j <= LOC_DRAWY+16; j+=16){ //Selet fling
				b->WriteTile(0, LOC_DRAWX+224, j, 105430+ (j-LOC_DRAWY)/16*20, true, false);
			}
			for(int i = LOC_DRAWX+240; i< LOC_DRAWX+272; i+=16){ //Straight up robbery
				for(int j = LOC_DRAWY+32; j <= LOC_DRAWY+48; j+=16){
					b->WriteTile(0, i, j, 101573 + (i-LOC_DRAWX-240)/16 + (j-LOC_DRAWY-32)/16*20, true, false);
				}
			}
			for(int j = LOC_DRAWY+32; j <= LOC_DRAWY+48; j+=16){ //Using a battery
				b->WriteTile(0, LOC_DRAWX+272, j, 101579+ (j-LOC_DRAWY-32)/16*20, true, false);
			}
		}
		else{
			NetSpritesheetBlit(b, swimb, which, userID);
		}
	}
	if(which == CHAR_SIYED){
		if(userID==-1){
			for(int i = LOC_DRAWX; i< LOC_DRAWX+208; i+=16){ //Walking, attacking, hold up
				for(int j = LOC_DRAWY; j <= LOC_DRAWY+16; j+=16){
					// Trace(i);
					// Trace(10);
					b->WriteTile(0, i, j, 101600 + (i-LOC_DRAWX)/16 + (j-LOC_DRAWY)/16*20, true, false);
				}
			}
			for(int i = 0; i< 192; i+=16){ //Swimming Tiles
				for(int j = 0; j <= 16; j+=16){
					swimb->WriteTile(0, i, j, 101740 + i/16 + j/16*20, true, false);
				}
			}
			for(int j = LOC_DRAWY; j <= LOC_DRAWY+16; j+=16){ //Crouch
				b->WriteTile(0, LOC_DRAWX+208, j, 105471+ (j-LOC_DRAWY)/16*20, true, false);
			}
			for(int j = LOC_DRAWY; j <= LOC_DRAWY+16; j+=16){ //Selet fling
				b->WriteTile(0, LOC_DRAWX+224, j, 105431+ (j-LOC_DRAWY)/16*20, true, false);
			}
			for(int i = LOC_DRAWX; i< LOC_DRAWX+192; i+=16){ //Sunball tiles. 
				for(int j = LOC_DRAWY+32; j <= LOC_DRAWY+48; j+=16){
					// Trace(i);
					// Trace(20);
					b->WriteTile(0, i, j, 101480 + (i-LOC_DRAWX)/16 + (j-LOC_DRAWY-32)/16*20, true, false);
				}
			}
			for(int j = LOC_DRAWY+32; j <= LOC_DRAWY+48; j+=16){ //Concentration
				b->WriteTile(0, LOC_DRAWX+288, j, 101613+ (j-LOC_DRAWY-32)/16*20, true, false);
			}
		}
		else{
			NetSpritesheetBlit(b, swimb, which, userID);
		}
	}
	if(userID==-1){
		b1->ReplaceColors(0, 0x60, 0x00, 0x00); //Make the background pink
		b->Write(0, "Test.bmp", true); //Print the image for debugging
	}
	else{
		int str[32];
		sprintf(str, "char%d.bmp", which);
		b->Write(0, str, true); //Print the image for debugging
	}
	b->Free(); //Free the bitmap
	swimb->Free();
	// bitmap b2 = Game->CreateBitmap(320, 208);
	// b2->DrawTile(0, 0, 0, 101400, 20, 13, 0, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE); 
	// b2->Write(0, "Test2.bmp", true); //Print the image for debugging
	// b2->Free(); //Free the bitmap
	// bitmap b3 = Game->CreateBitmap(320, 208);
	// b3->DrawTile(0, 0, 0, 104000, 20, 13, 6, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE); 
	// b3->Write(0, "Test3.bmp", true); //Print the image for debugging
	// b3->Free(); //Free the bitmap
}

void Costumes_Reset(int which){
	// if(G[G_RANDOMIZERENABLED])
		// return;
	int AsherBlockTil[] = {130000, 130040, 130080, 130088};
	int AsherDestTil[]  = {104120, 104260, 104523, 104603};
	int AsherBlockW[]   = {13,     13,     8,      3};
	int AsherBlockH[]   = {2,      1,      2,      2};
	int TorrinBlockTil[] = {130260, 130300};
	int TorrinDestTil[]  = {104160, 104300};
	int TorrinBlockW[]   = {13,     13};
	int TorrinBlockH[]   = {2,      1};
	int KaylaniBlockTil[] = {130520, 130560, 130600};
	int KaylaniDestTil[]  = {104200, 104340, 104520};
	int KaylaniBlockW[]   = {13,     13,     3};
	int KaylaniBlockH[]   = {2,      1,      8};
	int SorenBlockTil[] = {131600, 131576};
	int SorenDestTil[]  = {101520, 105429};
	int SorenBlockW[]   = {16,     1};
	int SorenBlockH[]   = {2,      4};
	int TerryBlockTil[] = {131640, 131577};
	int TerryDestTil[]  = {101560, 105430};
	int TerryBlockW[]   = {20,     1};
	int TerryBlockH[]   = {2,      4};
	int SiyedBlockTil[] = {131680, 131578, 131560};
	int SiyedDestTil[]  = {101600, 105431, 101480};
	int SiyedBlockW[]   = {14,     1,      12};
	int SiyedBlockH[]   = {2,      4,      2};
	
	
	if(which == CHAR_ASHER){
		for(int i=0; i<4; ++i){
			CopyTileBlock(AsherBlockTil[i], AsherBlockTil[i]+(AsherBlockW[i]-1)+(AsherBlockH[i]-1)*20, AsherDestTil[i]);
		}
	}
	if(which == CHAR_TORRIN){
		for(int i=0; i<2; ++i){
			CopyTileBlock(TorrinBlockTil[i], TorrinBlockTil[i]+(TorrinBlockW[i]-1)+(TorrinBlockH[i]-1)*20, TorrinDestTil[i]);
		}
	}
	if(which == CHAR_KAYLANI){
		for(int i=0; i<3; ++i){
			CopyTileBlock(KaylaniBlockTil[i], KaylaniBlockTil[i]+(KaylaniBlockW[i]-1)+(KaylaniBlockH[i]-1)*20, KaylaniDestTil[i]);
		}
	}
	if(which == CHAR_SOREN){
		for(int i=0; i<2; ++i){
			CopyTileBlock(SorenBlockTil[i], SorenBlockTil[i]+(SorenBlockW[i]-1)+(SorenBlockH[i]-1)*20, SorenDestTil[i]);
		}
	}
	if(which == CHAR_TERRY){
		for(int i=0; i<2; ++i){
			CopyTileBlock(TerryBlockTil[i], TerryBlockTil[i]+(TerryBlockW[i]-1)+(TerryBlockH[i]-1)*20, TerryDestTil[i]);
		}
	}
	if(which == CHAR_SIYED){
		for(int i=0; i<3; ++i){
			CopyTileBlock(SiyedBlockTil[i], SiyedBlockTil[i]+(SiyedBlockW[i]-1)+(SiyedBlockH[i]-1)*20, SiyedDestTil[i]);
		}
	}
}

void RandomizerCostumeUpdate(){
	if(G[G_RANDOMIZERENABLED]){
		for(int i = 0; i<6; i++){
			if(G[G_USINGCUSTOMOUTFIT+i] == 1){
				SetUpOutfit(CHAR_ASHER + i, -1, 0);
			}
		}
	}
}

bool OptionUnlocked(int Gindex, int id){ //For checking if outfits are unlocked
	if((Gindex == G_ACCESSORY1 || Gindex == G_ACCESSORY2) && id == ACCESSORY_HOODIEDOWN)
		return false;
	if(Gindex == G_SHIRT && id == TOP_HOODIE2)
		return false;
	
	int type = -1;
	if(Gindex==G_SHIRT)
		type = OTYPE_TOP;
	else if(Gindex==G_PANTS)
		type = OTYPE_BOTTOM;
	else if(Gindex==G_ACCESSORY1||Gindex==G_ACCESSORY2)
		type = OTYPE_ACCESSORY;
	if(Gindex==G_SHIRTCOLOR||Gindex==G_PANTSCOLOR||Gindex==G_ACCESSORY1COLOR||Gindex==G_ACCESSORY2COLOR)
		type = OTYPE_COLOR;
	
	switch(GetCharID()){
		case CHAR_ASHER:
			if(type==OTYPE_BOTTOM&&id==BOTTOM_PALA)
				return true;
			break;
		case CHAR_TORRIN:
			if(type==OTYPE_TOP&&id==TOP_MALKAVEST)
				return true;
			if(type==OTYPE_BOTTOM&&id==BOTTOM_MALKA)
				return true;
			if(type==OTYPE_ACCESSORY&&id==ACCESSORY_BRACELETS)
				return true;
			break;
		case CHAR_KAYLANI:
			if(type==OTYPE_TOP&&id==TOP_NOTHING)
				return false;
			if(type==OTYPE_TOP&&id==TOP_MALKAVEST)
				return false;
			if(type==OTYPE_TOP&&id==TOP_TATTOOS)
				return false;
			if(type==OTYPE_TOP&&id==TOP_CAPTAINVEST)
				return false;
			if(type==OTYPE_TOP&&id==TOP_HOKUF)
				return true;
			if(type==OTYPE_TOP&&id==TOP_MALKAVESTF)
				return GetOutfitPiece(type, TOP_MALKAVEST);
			if(type==OTYPE_TOP&&id==TOP_CAPTAINVESTF)
				return GetOutfitPiece(type, TOP_CAPTAINVEST);
			if(type==OTYPE_BOTTOM&&id==BOTTOM_HOKUF)
				return true;
			break;
		case CHAR_SOREN:
			if(type==OTYPE_BOTTOM&&id==BOTTOM_PALA)
				return true;
			break;
		case CHAR_TERRY:
			if(type==OTYPE_TOP&&id==TOP_NOTHING)
				return false;
			if(type==OTYPE_TOP&&id==TOP_MALKAVEST)
				return false;
			if(type==OTYPE_TOP&&id==TOP_TATTOOS)
				return false;
			if(type==OTYPE_TOP&&id==TOP_CAPTAINVEST)
				return false;
			if(type==OTYPE_TOP&&id==TOP_CHESTWRAP)
				return true;
			if(type==OTYPE_TOP&&id==TOP_MALKAVESTF)
				return GetOutfitPiece(type, TOP_MALKAVEST);
			if(type==OTYPE_TOP&&id==TOP_CAPTAINVESTF)
				return GetOutfitPiece(type, TOP_CAPTAINVEST);
			if(type==OTYPE_BOTTOM&&id==BOTTOM_SKIRT)
				return true;
			break;
		case CHAR_SIYED:
			if(type==OTYPE_BOTTOM&&id==BOTTOM_HOKU)
				return true;
			break;
	}
	
	return GetOutfitPiece(type, id);
}

const int OFFSET_PREVIEWY = 20;

void DrawCharacterPreview(int which){
	int layer = 6;
	int BodyTile;
	switch(which){
		case CHAR_ASHER:
			BodyTile = 104120;
			break;
		case CHAR_TORRIN:
			BodyTile = 104160;
			break;
		case CHAR_KAYLANI:
			BodyTile = 104200;
			break;
		case CHAR_SOREN:
			BodyTile = 101520;
			break;
		case CHAR_TERRY:
			BodyTile = 101560;
			break;
		case CHAR_SIYED:
			BodyTile = 101600;
			break;
	}
	//Background
	Screen->Rectangle(layer, -64, -64, 300, 200, 0x00, 1, 0, 0, 0, true, OP_OPAQUE);	

	//BEEG draws
	Screen->Rectangle(layer, 95, 15+OFFSET_PREVIEWY, 160, 112+OFFSET_PREVIEWY, 0x08, -1, 0, 0, 0, false, OP_OPAQUE);
	Screen->DrawTile(layer, 96, 16+OFFSET_PREVIEWY, 6, 1, 1, 0, 64, 96, 0, 0, 0, 0, true, OP_OPAQUE);
	Screen->DrawTile(layer, 96, -16+OFFSET_PREVIEWY, BodyTile, 1, 2, 6, 64, 128, 0, 0, 0, 0, true, OP_OPAQUE);	
}

enum Tops{
	TOP_NOTHING,
	TOP_HOKUF,
	TOP_MALKAVEST,
	TOP_CHESTWRAP,
	TOP_BASICSHIRT,
	TOP_WELLINGTON, 
	TOP_TULANE,
	TOP_CULTIST,
	TOP_ARMOR,
	TOP_HOODIE1,
	TOP_HOODIE2,
	TOP_ZARATH,
	TOP_TATTOOS,
	TOP_JACKET,
	TOP_MALKAVESTF,
	TOP_CAPTAINVEST,
	TOP_CAPTAINVESTF
};
enum Bottoms{
	BOTTOM_HOKU,
	BOTTOM_HOKUF,
	BOTTOM_MALKA,
	BOTTOM_SKIRT,
	BOTTOM_PALA,
	BOTTOM_WELLINGTON,
	BOTTOM_CULTIST,
	BOTTOM_ARMOR
};
enum Accessories{
	ACCESSORY_NONE,
	ACCESSORY_TOPHAT,
	ACCESSORY_HATSTACK,
	ACCESSORY_BONNET,
	ACCESSORY_MOUSTACHE,
	ACCESSORY_GLASSES,
	ACCESSORY_EYEPATCH,
	ACCESSORY_BANDANA,
	ACCESSORY_CAPTAINSHAT,
	ACCESSORY_CULTISTHOOD,
	ACCESSORY_GOLEMHEAD,
	ACCESSORY_NIGHTMAREMASK,
	ACCESSORY_NIGHTMAREEYE,
	ACCESSORY_CIRCLET,
	ACCESSORY_HOODIE,
	ACCESSORY_HOODIEDOWN,
	ACCESSORY_HALO,
	ACCESSORY_BLINDFOLD,
	ACCESSORY_BRACELETS,
	ACCESSORY_HEADBAND,
	ACCESSORY_CROWN,
	ACCESSORY_GOGGLES,
	ACCESSORY_STETSON,
	ACCESSORY_HIBISCUS,
	ACCESSORY_CAP,
	ACCESSORY_SOLARMASK,
	ACCESSORY_LUNARMASK,
	ACCESSORY_STELLARMASK,
	ACCESSORY_TURBAN,
	ACCESSORY_TRUFNECKLACE,
	ACCESSORY_WARRIORNECKLACE,
	ACCESSORY_WARRIORHELMET,
	ACCESSORY_SKULLMASK,
	ACCESSORY_EISENFAUST
};
enum AccessoryFlags{
	ACF_BEHINDUP      = 0x1,
	ACF_BEHINDDOWN    = 0x2,
	ACF_NORECOLOR     = 0x4,
	ACF_SPECIALWHITE  = 0x8,
	ACF_FLIPSLOT      = 0x10,
	ACF_REPLACEHEAD   = 0x20,
	ACF_SPECIALHOLDUP = 0x40,
	ACF_CUTHAIR       = 0x80
};
enum OutfitColor{
	OCLR_RED,
	OCLR_CRIMSON,
	OCLR_PALEPINK,
	OCLR_ORANGE,
	OCLR_GOLDENYELLOW,
	OCLR_YELLOW,
	OCLR_GREEN,
	OCLR_PALEGREEN,
	OCLR_DULLGREEN,
	OCLR_FORESTGREEN,
	OCLR_BLUE,
	OCLR_SKYBLUE,
	OCLR_DEEPBLUE, 
	OCLR_DENIMBLUE,
	OCLR_PERIWINKLE, 
	OCLR_PALEPERIWINKLE,
	OCLR_PURPLE,
	OCLR_PALEPURPLE,
	OCLR_MALKAPURPLE,
	OCLR_MUDBROWN,
	OCLR_WHITE,
	OCLR_LIGHTGREY,
	OCLR_DARKGREY,
	OCLR_LIGHTBLACK,
	OCLR_DARKBLACK,
	OCLR_NIGREDO
};

int EquippedAccessory(int whichChar, int slot){
	if(slot==0){
		return G[G_ACCESSORY1+whichChar];
	}
	else{
		return G[G_ACCESSORY2+whichChar];
	}
}
bool EquippedAccessoryAnySlot(int whichChar, int whichAccessory){
	return EquippedAccessory(whichChar, 0)==whichAccessory||EquippedAccessory(whichChar, 1)==whichAccessory;
}

bool IsBodyAccessory(int which){
	switch(which){
		case ACCESSORY_BRACELETS:
		case ACCESSORY_TRUFNECKLACE:
		case ACCESSORY_WARRIORNECKLACE:
		case ACCESSORY_EISENFAUST:
			return true;
	}
	return false;
}

int AccessoryTile(int which, int whichChar){
	int accessory1 = G[G_TEMPACCESSORY1];
	int accessory2 = G[G_TEMPACCESSORY2];
	switch(which){
		case ACCESSORY_TOPHAT:
			return 134940;
		case ACCESSORY_MOUSTACHE:
			return 134946;
		case ACCESSORY_BONNET:
			return 134943;
		case ACCESSORY_GLASSES:
			return 134949;
		case ACCESSORY_HATSTACK:
			return 134952;
		case ACCESSORY_EYEPATCH:
			return 134955;
		case ACCESSORY_BANDANA:
			return 134960;
		case ACCESSORY_CAPTAINSHAT:
			return 134963;
		case ACCESSORY_CULTISTHOOD:
			return 134680;
		case ACCESSORY_GOLEMHEAD:
			return 134760;
		case ACCESSORY_NIGHTMAREMASK:
			if(accessory1==ACCESSORY_NIGHTMAREEYE||accessory2==ACCESSORY_NIGHTMAREEYE)
				return 134972;
			return 134966;
		case ACCESSORY_NIGHTMAREEYE:
			if(accessory1==ACCESSORY_NIGHTMAREMASK||accessory2==ACCESSORY_NIGHTMAREMASK)
				return 0;
			return 134969;
		case ACCESSORY_CIRCLET:
			return 134975;
		case ACCESSORY_HOODIE:
			return 134995;
		case ACCESSORY_HOODIEDOWN:
			return 134992;
		case ACCESSORY_HALO:
			return 134989;
		case ACCESSORY_BLINDFOLD:
			if(whichChar==CHAR_ASHER)
				return 135006;
			if(whichChar==CHAR_TERRY)
				return 135026;
			if(whichChar==CHAR_SIYED)
				return 135026;
			return 134986;
		case ACCESSORY_BRACELETS:
			return 134420;
		case ACCESSORY_HEADBAND:
			return 134980;
		case ACCESSORY_CROWN:
			return 134983;
		case ACCESSORY_GOGGLES:
			return 135000;
		case ACCESSORY_STETSON:
			return 135003;
		case ACCESSORY_HIBISCUS:
			return 135020;
		case ACCESSORY_CAP:
			return 135023;
		case ACCESSORY_SOLARMASK:
			return 135009;
		case ACCESSORY_LUNARMASK:
			return 135029;
		case ACCESSORY_STELLARMASK:
			return 135049;
		case ACCESSORY_TURBAN:
			return 135040;
		case ACCESSORY_TRUFNECKLACE:
			return 134460;
		case ACCESSORY_WARRIORNECKLACE:
			return 134500;
		case ACCESSORY_WARRIORHELMET:
			return 135060;
		case ACCESSORY_SKULLMASK: 
			return 135063;
		case ACCESSORY_EISENFAUST:
			return 134540;
	}
}

int AccessoryGlobalYOff(int which){
	switch(which){
		case ACCESSORY_TOPHAT:
			return -4;
		case ACCESSORY_MOUSTACHE:
			return 5;
		case ACCESSORY_BONNET:
			return 0;
		case ACCESSORY_GLASSES:
			return 0;
		case ACCESSORY_HATSTACK:
			return -8;
		case ACCESSORY_EYEPATCH:
			return 0;
		case ACCESSORY_BANDANA:
			return 0;
		case ACCESSORY_CAPTAINSHAT:
			return 0;
		case ACCESSORY_CULTISTHOOD:
			return 0;
		case ACCESSORY_GOLEMHEAD:
			return 0;
		case ACCESSORY_NIGHTMAREMASK:
			return 2;
		case ACCESSORY_NIGHTMAREEYE:
			return 0;
		case ACCESSORY_CIRCLET:
			return 0;
		case ACCESSORY_HOODIE:
			return 0;
		case ACCESSORY_HOODIEDOWN:
			return 1;
		case ACCESSORY_HALO:
			return 0;
		case ACCESSORY_BLINDFOLD:
			return 0;
		case ACCESSORY_BRACELETS:
			return 0;
		case ACCESSORY_BRACELETS:
			return 0;
		case ACCESSORY_HEADBAND:
			return 0;
		case ACCESSORY_CROWN:
			return 0;
		case ACCESSORY_GOGGLES:
			return 0;
		case ACCESSORY_STETSON:
			return 0;
		case ACCESSORY_HIBISCUS:
			return 0;
		case ACCESSORY_CAP:
			return 0;
		case ACCESSORY_SOLARMASK:
			return 0;
		case ACCESSORY_LUNARMASK:
			return 0;
		case ACCESSORY_STELLARMASK:
			return 0;
		case ACCESSORY_TURBAN:
			return 0;
		case ACCESSORY_TRUFNECKLACE:
			return 0;
		case ACCESSORY_WARRIORNECKLACE:
			return 0;
		case ACCESSORY_WARRIORHELMET:
			return 0;
		case ACCESSORY_SKULLMASK: 
			return 0;
		case ACCESSORY_EISENFAUST:
			return 0;
	}
}

int AccessoryFlags(int which){
	switch(which){
		case ACCESSORY_TOPHAT:
			return 0;
		case ACCESSORY_MOUSTACHE:
			return ACF_BEHINDUP;
		case ACCESSORY_BONNET:
			return ACF_SPECIALWHITE;
		case ACCESSORY_GLASSES:
			return 0;
		case ACCESSORY_HATSTACK:
			return 0;
		case ACCESSORY_EYEPATCH:
			return ACF_NORECOLOR|ACF_FLIPSLOT;
		case ACCESSORY_BANDANA:
			return 0;
		case ACCESSORY_CAPTAINSHAT:
			return 0;
		case ACCESSORY_CULTISTHOOD:
			return ACF_REPLACEHEAD;
		case ACCESSORY_GOLEMHEAD:
			return ACF_REPLACEHEAD;
		case ACCESSORY_NIGHTMAREMASK:
			return ACF_BEHINDUP|ACF_NORECOLOR;
		case ACCESSORY_NIGHTMAREEYE:
			return ACF_FLIPSLOT|ACF_NORECOLOR;
		case ACCESSORY_CIRCLET:
			return 0;
		case ACCESSORY_HOODIE:
			return ACF_CUTHAIR|ACF_SPECIALHOLDUP;
		case ACCESSORY_HOODIEDOWN:
			return ACF_CUTHAIR|ACF_BEHINDDOWN;
		case ACCESSORY_HALO:
			return 0;
		case ACCESSORY_BLINDFOLD:
			return 0;
		case ACCESSORY_BRACELETS:
			return 0;
		case ACCESSORY_HEADBAND:
			return 0;
		case ACCESSORY_CROWN:
			return 0;
		case ACCESSORY_GOGGLES:
			return ACF_NORECOLOR;
		case ACCESSORY_STETSON:
			return 0;
		case ACCESSORY_HIBISCUS:
			return ACF_NORECOLOR;
		case ACCESSORY_CAP:
			return 0;
		case ACCESSORY_SOLARMASK:
			return ACF_NORECOLOR;
		case ACCESSORY_LUNARMASK:
			return ACF_NORECOLOR;
		case ACCESSORY_STELLARMASK:
			return ACF_NORECOLOR;
		case ACCESSORY_TURBAN:
			return 0;
		case ACCESSORY_TRUFNECKLACE:
			return 0;
		case ACCESSORY_WARRIORNECKLACE:
			return 0;
		case ACCESSORY_WARRIORHELMET:
			return 0;
		case ACCESSORY_SKULLMASK: 
			return 0;
		case ACCESSORY_EISENFAUST:
			return ACF_NORECOLOR;
	}
}

int AccessoryTileXOff(int tilePos){
	switch(tilePos){
		case 10:
		case 16:
		case 30:
		case 33:
			return -1;
	}
	return 0;
}
int AccessoryTileYOff(int tilePos){
	switch(tilePos){
		case 0:
		case 3:
		case 6:
		case 12:
		case 20:
		case 23:
		case 26:
		case 35:
		case 36:
		case 37:
		case 38:
			return 8;
		case 1:
		case 2:
		case 4:
		case 5:
		case 7:
		case 8:
		case 9:
		case 10:
		case 11:
		case 15:
		case 16:
		case 17:
		case 21:
		case 22:
		case 24:
		case 25:
		case 27:
		case 28:
		case 29:
		case 30:
		case 31:
		case 32:
		case 33:
		case 34:
			return 9;
		case 14:
		case 18:
			return 6;
		case 13:
			return 11;
	}
	return 0;
}

int AccessoryTileDir(int tilePos){
	switch(tilePos){
		case 0:
		case 1:
		case 2:
		case 9:
		case 12:
		case 13:
		case 14:
		case 15:
		case 18:
		case 20:
		case 21:
		case 22:
		case 29:
		case 32:
		case 35:
		case 36:
		case 37:
		case 38:
			return DIR_DOWN;
		case 3:
		case 4:
		case 5:
		case 10:
		case 16:
		case 23:
		case 24:
		case 25:
		case 30:
		case 33:
			return DIR_LEFT;
		case 6:
		case 7:
		case 8:
		case 11:
		case 17:
		case 26:
		case 27:
		case 28:
		case 31:
		case 34:
			return DIR_UP;
	}
	return -1;
}

//Color ramps Russ provided only allow three colors so this is some wack ass shit to add a fourth. 
//Color 0x71 will be replaced by the color this function returns if >0
int ColorSpecialWhite(int clr){
	switch(clr){
		case OCLR_RED:
			return 0xB6;
		case OCLR_CRIMSON:
			return 0x82;
		case OCLR_ORANGE:
			return 0x1A;
		case OCLR_GREEN:
		case OCLR_DULLGREEN:
			return 0x92;
		case OCLR_FORESTGREEN:
			return 0x56;
		case OCLR_BLUE:
			return 0x06;
		case OCLR_DEEPBLUE:
			return 0x72;
		case OCLR_PERIWINKLE:
			return 0xA2;
		case OCLR_PURPLE:
			return 0x96;
		case OCLR_MALKAPURPLE:
			return 0x97;
		case OCLR_MUDBROWN:
			return 0x64;
		case OCLR_DARKGREY:
			return 0x7C;
		case OCLR_LIGHTBLACK:
			return 0x7D;
		case OCLR_DARKBLACK:
			return 0x52;
		case OCLR_NIGREDO:
			return 0x53;
	}
	return 0;
}

void InitCostumes(){
	G[G_SHIRT + CHAR_ASHER] = TOP_NOTHING;
	G[G_PANTS + CHAR_ASHER] = BOTTOM_PALA;
	G[G_PANTSCOLOR + CHAR_ASHER] = OCLR_DENIMBLUE;
	
	G[G_SHIRT + CHAR_TORRIN] = TOP_MALKAVEST;
	G[G_SHIRTCOLOR + CHAR_TORRIN] = OCLR_MALKAPURPLE;
	G[G_PANTS + CHAR_TORRIN] = BOTTOM_MALKA;
	G[G_PANTSCOLOR + CHAR_TORRIN] = OCLR_RED;
	G[G_ACCESSORY1 + CHAR_TORRIN] = ACCESSORY_BRACELETS;
	G[G_ACCESSORY1COLOR + CHAR_TORRIN] = OCLR_MALKAPURPLE;
	
	G[G_SHIRT + CHAR_KAYLANI] = TOP_HOKUF;
	G[G_SHIRTCOLOR + CHAR_KAYLANI] = OCLR_YELLOW;
	G[G_PANTS + CHAR_KAYLANI] = BOTTOM_HOKUF;
	G[G_PANTSCOLOR + CHAR_KAYLANI] = OCLR_YELLOW;
	
	G[G_SHIRT + CHAR_SOREN] = TOP_NOTHING;
	G[G_PANTS + CHAR_SOREN] = BOTTOM_PALA;
	G[G_PANTSCOLOR + CHAR_SOREN] = OCLR_DENIMBLUE;
	
	G[G_SHIRT + CHAR_TERRY] = TOP_CHESTWRAP;
	G[G_SHIRTCOLOR + CHAR_TERRY] = OCLR_MALKAPURPLE;
	G[G_PANTS + CHAR_TERRY] = BOTTOM_SKIRT;
	G[G_PANTSCOLOR + CHAR_TERRY] = OCLR_RED;
	
	G[G_SHIRT + CHAR_SIYED] = TOP_NOTHING;
	G[G_PANTS + CHAR_SIYED] = BOTTOM_HOKU;
	G[G_PANTSCOLOR + CHAR_SIYED] = OCLR_RED;
}

const int SFX_COSTUMECHANGER_CURTAINS = 41;
	
ffc script CostumeChanger{
	bool SpecialTop(int whichTop){
		switch(whichTop){
			case TOP_TULANE:
				return true;
			case TOP_ZARATH:
				return true;
		}
		return false;
	}
	void run(int curtainPos){
		mapdata l2 = Game->LoadTempScreen(2);
		mapdata l4 = Game->LoadTempScreen(4);
		
		int MenuOptions[] = {"Default Outfit", "Top", "Top Color", "Bottom", "Bottom Color", "Accessory #1", "Accessory #1 Color", "Accessory #2", "Accessory #2 Color", "Extra Effects"};
		int Values[] = {0, G_SHIRT, G_SHIRTCOLOR, G_PANTS, G_PANTSCOLOR, G_ACCESSORY1, G_ACCESSORY1COLOR, G_ACCESSORY2, G_ACCESSORY2COLOR};
		int Tops[] = {"Nothing", "Hoku Top", "Malka Vest", "Chest Wrap", "Basic Shirt", "Wellington's Tux", "Tulane's Dress", "Cultist Cloak", "Chest Plate", "Hoodie", "Hoodie 2", "Plated Robe", "Temporary Tattoos", "Buttoned Jacket", "Malka Vest", "Captain's Vest", "Captain's Vest"};
		int Bottoms[] = {"Pareo", "Tupenu", "Malkan Wrap", "Skirt", "Pala Pants", "Wellington's Trousers", "Cultist Poofy Pants", "Leg Plate"};
		int Accessories[] = {"None", "Stove Top", "Double Burner", "Bonnet", "Fake Moustache", "Glasses", "Eyepatch", "Bandana", "Captain's Hat", "Cultist Hood", "Golem Head", "Nightmare Mask", "Cosmic Sight", "Circlet", "Hoodie", "Hoodie (Lowered)", "Halo", "Blindfold", "Bracelets", "Headband", "Crown", "Goggles", "Stetson", "Hibiscus", "Cap", "Solar Mask", "Lunar Mask", "Stellar Mask", "Turban", "Truf's Necklace", "Warrior Necklace", "Warrior Helmet", "Skull Mask", "Eisenfaust"};
		int Colors[] = {"Red", "Crimson", "Pale Pink", "Orange", "Golden Yellow", "Yellow", "Green", "Pale Green", "Dull Green", "Forest Green", "Blue", "Sky Blue", "Deep Blue", "Denim Blue", "Periwinkle", "Pale Periwinkle", "Purple", "Pale Purple", "Malka Purple", "Mud Brown", "White", "Light Grey", "Dark Grey", "Light Black", "Dark Black", "Nigredo"};
		int ValueNames[] = {0, Tops, Colors, Bottoms, Colors, Accessories, Colors, Accessories, Colors};
		int Max[] = {0, SizeOfArray(Tops)-1, SizeOfArray(Colors)-1, SizeOfArray(Bottoms)-1, SizeOfArray(Colors)-1, SizeOfArray(Accessories)-1, SizeOfArray(Colors)-1, SizeOfArray(Accessories)-1, SizeOfArray(Colors)-1};
		
		int MaxOptions = SizeOfArray(MenuOptions)-1;
		int CursorYPosition = 0;
		int CurrentOption = 0;
		int CurNameArray;
		int layer = 6;
		
		bool curtainsOpen;
		bool waitPress;
		bool waitCollide;
		
		while(true){
			if(Link->InputDown)
				waitPress = false;
			if(!waitPress){
				if(Abs(Link->X-this->X)<8&&Link->Y<this->Y+24&&Link->Y>this->Y-8){
					if(!curtainsOpen)
						Game->PlaySound(SFX_COSTUMECHANGER_CURTAINS);
					curtainsOpen = true;
				}
				else{
					if(curtainsOpen)
						Game->PlaySound(SFX_COSTUMECHANGER_CURTAINS);
					curtainsOpen = false;
				}
			}
			if(waitPress){
				l2->ComboD[curtainPos] = 0;
				l2->ComboD[curtainPos+1] = 0;
				l4->ComboD[curtainPos] = 16280;
				l4->ComboD[curtainPos+1] = 16281;
			}
			else if(!curtainsOpen){
				l2->ComboD[curtainPos] = 16280;
				l2->ComboD[curtainPos+1] = 16281;
				l4->ComboD[curtainPos] = 0;
				l4->ComboD[curtainPos+1] = 0;
			}
			else{
				l2->ComboD[curtainPos] = 0;
				l2->ComboD[curtainPos+1] = 0;
				l4->ComboD[curtainPos] = 16282;
				l4->ComboD[curtainPos+1] = 0;
			}
			
			if(Distance(this->X, this->Y, Link->X, Link->Y) <=4){
				if(waitCollide)
					G[G_OUTFITMENUOPEN] = 2;
				else{
					curtainsOpen = false;
					waitPress = true;
					waitCollide = true;
					Link->X = this->X;
					Link->Y = this->Y;
					while(true){
						bool noCycle;
						bool invalid;
						int accessory1 = G[G_ACCESSORY1 + GetCharID()];
						int accessory1c = G[G_ACCESSORY1COLOR + GetCharID()];
						int accessory2 = G[G_ACCESSORY2 + GetCharID()];
						int accessory2c = G[G_ACCESSORY2COLOR + GetCharID()];
						//No cycling on costume reset
						if(CurrentOption==0)
							noCycle = true;
						//No cycling bottoms if the top is fancy
						else if((CurrentOption==3||CurrentOption==4)&&SpecialTop(G[G_SHIRT + GetCharID()])){
							noCycle = true;
							invalid = true;
						}
						//No cycling on color if wearing nothing
						else if(CurrentOption==2&&G[G_SHIRT + GetCharID()]==TOP_NOTHING){
							noCycle = true;
							invalid = true;
						}
						//No cycling on color for accessories that don't recolor
						else if(CurrentOption==6&&AccessoryFlags(accessory1)&ACF_NORECOLOR){
							noCycle = true;
							invalid = true;
						}
						else if(CurrentOption==8&&AccessoryFlags(accessory2)&ACF_NORECOLOR){
							noCycle = true;
							invalid = true;
						}
						Link->Invisible = true;
						
						DrawCharacterPreview(GetCharID());
						
						//Text
						Screen->DrawString(layer, 96+12, 112+10+OFFSET_PREVIEWY, FONT_Z3SMALL, 0x0A, -1, TF_NORMAL, MenuOptions[CurrentOption], OP_OPAQUE); //The name of the option we're in
						CurNameArray = ValueNames[CurrentOption];
						if(CurNameArray == 0)	//Default option, display prompt
							Screen->DrawString(layer, 96+12, 122+10+OFFSET_PREVIEWY, FONT_Z3SMALL, 0x0D, -1, TF_NORMAL, "Press A To Restore Default Outfit", OP_OPAQUE);
						else if((CurrentOption==5&&accessory1==ACCESSORY_BANDANA&&accessory1c==OCLR_YELLOW)||(CurrentOption==7&&accessory2==ACCESSORY_BANDANA&&accessory2c==OCLR_YELLOW)) //Dumb joke if you equip a yellow bandana
							Screen->DrawString(layer, 96+12, 122+10+OFFSET_PREVIEWY, FONT_Z3SMALL, 0x0D, -1, TF_NORMAL, "Banana", OP_OPAQUE);
						else if(CurrentOption==9) //Effect toggle
							Screen->DrawString(layer, 96+12, 122+10+OFFSET_PREVIEWY, FONT_Z3SMALL, 0x0D, -1, TF_NORMAL, G[G_NOOUTFITEFFECTS]?"Disabled":"Enabled", OP_OPAQUE);
						else //Display the options
							Screen->DrawString(layer, 96+12, 122+10+OFFSET_PREVIEWY, FONT_Z3SMALL, 0x0D, -1, TF_NORMAL, invalid?"N/A":CurNameArray[G[Values[CurrentOption] + GetCharID()]], OP_OPAQUE);
						
						if(Link->PressUp || Link->PressDown){
							if(CursorYPosition == 0)
								CursorYPosition = 1;
							else
								CursorYPosition = 0;
						}
						
						if(CursorYPosition == 0){
							Screen->DrawTile(layer, 90+12, 111+10+OFFSET_PREVIEWY, 5, 1, 1, 6, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE); //Cursor
							if(Link->PressRight){
								if(CurrentOption == MaxOptions)	
									CurrentOption = 0;
								else
									CurrentOption++;
							}
							if(Link->PressLeft){
								if(CurrentOption == 0){
									CurrentOption = MaxOptions;
								}
								else
									CurrentOption--;
							}
							
						}
						else{
							Screen->DrawTile(layer, 90+12, 121+10+OFFSET_PREVIEWY, 5, 1, 1, 6, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE); //Cursor
							if(CurrentOption==9){
								if(Link->PressLeft || Link->PressRight){
									G[G_NOOUTFITEFFECTS] = G[G_NOOUTFITEFFECTS]?0:1;
								}
							}
							else if(!noCycle&&(Link->PressLeft || Link->PressRight)){
								if(Link->PressRight){
									do{
										if(G[Values[CurrentOption] + GetCharID()] == Max[CurrentOption])
											G[Values[CurrentOption] + GetCharID()] = 0;
										else
											G[Values[CurrentOption] + GetCharID()]++;
									}
									while(!OptionUnlocked(Values[CurrentOption], G[Values[CurrentOption] + GetCharID()]));
								}
								if(Link->PressLeft){
									do{
										if(G[Values[CurrentOption] + GetCharID()] == 0)
											G[Values[CurrentOption] + GetCharID()] = Max[CurrentOption];
										else
											G[Values[CurrentOption] + GetCharID()]--;
									}
									while(!OptionUnlocked(Values[CurrentOption], G[Values[CurrentOption] + GetCharID()]));
								}
								G[G_USINGCUSTOMOUTFIT+GetCharID()] = 1;
								SetUpOutfit(GetCharID(), -1, 0);
							}
						}
						if(Link->PressA && CurNameArray == 0){
							G[G_USINGCUSTOMOUTFIT+GetCharID()] = 0;
							Costumes_Reset(GetCharID());
						}
						if(Link->PressB){
							l2->ComboD[curtainPos] = 0;
							l2->ComboD[curtainPos+1] = 0;
							l4->ComboD[curtainPos] = 16282;
							l4->ComboD[curtainPos+1] = 0;
							Game->PlaySound(SFX_COSTUMECHANGER_CURTAINS);
							curtainsOpen = true;
							Link->PressB = false;
							Link->InputB = false;
							Link->Invisible = false;
							while(Link->Y < 48){
								NoAction();
								Link->InputDown = true;
								if(Abs(Link->X-this->X)<8&&Link->Y<this->Y+24&&Link->Y>this->Y-8){
									if(!curtainsOpen)
										Game->PlaySound(SFX_COSTUMECHANGER_CURTAINS);
									curtainsOpen = true;
								}
								else{
									if(curtainsOpen)
										Game->PlaySound(SFX_COSTUMECHANGER_CURTAINS);
									curtainsOpen = false;
									l2->ComboD[curtainPos] = 0;
									l2->ComboD[curtainPos+1] = 0;
									l4->ComboD[curtainPos] = 16280;
									l4->ComboD[curtainPos+1] = 16281;
								}
								Waitframe();
							}
							ZLink::OpenPacket();
							ZLink::OUT_SendCostumes(0);
							ZLink::SendPacket();
							Link->Action = LA_ATTACKING;
							WaitNoAction();
							Link->Action = LA_NONE;
							WaitNoAction(30);
							PickOutfitCommentary(GetCharID());
							while(G[G_MSGACTIVE]){
								G[G_NOACTION] = 1;
								Waitframe();
							}
							waitCollide = false;
							waitPress = false;
							if(G[G_RANDOMIZERRUNCLEAR])
								WriteOutfitSaveFile();
							break;
						}
						Link->InputA = false;
						Link->PressA = false;
						Link->PressStart = false;
						Link->InputStart = false;
						Link->PressL = false;
						Link->PressR = false;
						Link->InputL = false;
						Link->InputR = false;
						Link->InputUp = false;
						Link->InputDown = false;
						Link->InputLeft = false;
						Link->InputRight = false;
						G[G_OUTFITMENUOPEN] = 2;
						
						Waitframe();
					}
				}
			}
			else
				waitCollide = false;
			Waitframe();
		}
	}
}

enum OutfitType{
	OTYPE_TOP,
	OTYPE_BOTTOM,
	OTYPE_ACCESSORY,
	OTYPE_COLOR
};

//Gets the ID for an outfit piece in the save system
int GetOutfitPieceSaveID(int type, int id){
	if(type==OTYPE_TOP){
		switch(id){
			case TOP_HOKUF: return 0;
			case TOP_MALKAVEST: return 1;
			case TOP_CHESTWRAP: return 2;
			case TOP_BASICSHIRT: return 3;
			case TOP_WELLINGTON: return 4;
			case TOP_TULANE: return 5;
			case TOP_CULTIST: return 6;
			case TOP_ARMOR: return 7;
			case TOP_HOODIE1: return 8;
			case TOP_HOODIE2: return 9;
			case TOP_ZARATH: return 10;
			case TOP_TATTOOS: return 11;
			case TOP_JACKET: return 12;
			case TOP_MALKAVESTF: return 13;
			case TOP_CAPTAINVEST: return 14;
			case TOP_CAPTAINVESTF: return 15;
		}
	}
	else if(type==OTYPE_BOTTOM){
		switch(id){
			case BOTTOM_HOKU: return 0;
			case BOTTOM_HOKUF: return 1;
			case BOTTOM_MALKA: return 2;
			case BOTTOM_SKIRT: return 3;
			case BOTTOM_PALA: return 4;
			case BOTTOM_WELLINGTON: return 5;
			case BOTTOM_CULTIST: return 6;
			case BOTTOM_ARMOR: return 7;
		}
	}
	else if(type==OTYPE_ACCESSORY){
		switch(id){
			case ACCESSORY_TOPHAT: return 0;
			case ACCESSORY_HATSTACK: return 1;
			case ACCESSORY_BONNET: return 2;
			case ACCESSORY_MOUSTACHE: return 3;
			case ACCESSORY_GLASSES: return 4;
			case ACCESSORY_EYEPATCH: return 5;
			case ACCESSORY_BANDANA: return 6;
			case ACCESSORY_CAPTAINSHAT: return 7;
			case ACCESSORY_CULTISTHOOD: return 8;
			case ACCESSORY_GOLEMHEAD: return 9;
			case ACCESSORY_NIGHTMAREMASK: return 10;
			case ACCESSORY_NIGHTMAREEYE: return 11;
			case ACCESSORY_CIRCLET: return 12;
			case ACCESSORY_HOODIE: return 13;
			case ACCESSORY_HOODIEDOWN: return 14;
			case ACCESSORY_HALO: return 15;
			case ACCESSORY_BLINDFOLD: return 16;
			case ACCESSORY_BRACELETS: return 17;
			case ACCESSORY_HEADBAND: return 18;
			case ACCESSORY_CROWN: return 19;
			case ACCESSORY_GOGGLES: return 20;
			case ACCESSORY_STETSON: return 21;
			case ACCESSORY_HIBISCUS: return 22;
			case ACCESSORY_CAP: return 23;
			case ACCESSORY_SOLARMASK: return 24;
			case ACCESSORY_LUNARMASK: return 25;
			case ACCESSORY_STELLARMASK: return 26;
			case ACCESSORY_TURBAN: return 27;
			case ACCESSORY_TRUFNECKLACE: return 28;
			case ACCESSORY_WARRIORNECKLACE: return 29;
			case ACCESSORY_WARRIORHELMET: return 30;
			case ACCESSORY_SKULLMASK: return 31;
			case ACCESSORY_EISENFAUST: return 32;
		}
	}
	else if(type==OTYPE_COLOR){
		switch(id){
			case OCLR_CRIMSON: return 0;
			case OCLR_PALEPINK: return 1;
			case OCLR_GOLDENYELLOW: return 2;
			case OCLR_PALEGREEN: return 3;
			case OCLR_DULLGREEN: return 4;
			case OCLR_FORESTGREEN: return 5;
			case OCLR_SKYBLUE: return 6;
			case OCLR_DEEPBLUE: return 7;
			case OCLR_PERIWINKLE: return 8;
			case OCLR_PALEPERIWINKLE: return 9;
			case OCLR_PURPLE: return 10;
			case OCLR_PALEPURPLE: return 11;
			case OCLR_MUDBROWN: return 12;
			case OCLR_WHITE: return 13;
			case OCLR_LIGHTGREY: return 14;
			case OCLR_DARKGREY: return 15;
			case OCLR_DARKBLACK: return 16;
			case OCLR_NIGREDO: return 17;
		}
	}
	return -1;
}
//Sets or returns the value of global bits for an outfit piece
bool GetOutfitPiece(int type, int id){
	return __GetSetOutfitPiece(type, id, false, false);
}
bool SetOutfitPiece(int type, int id, bool val){
	return __GetSetOutfitPiece(type, id, true, val);
}
//This one is internal, not to be called except by the other two functions
bool __GetSetOutfitPiece(int type, int id, bool set, bool val){
	int sid = GetOutfitPieceSaveID(type, id);
	if(sid==-1){
		return true;
	}
	
	int idx = Floor(id/8);
	int idxbit = 1<<(id%8);
	//Update idx to the appropriate G_ indices
	if(type==OTYPE_TOP){
		switch(idx){
			case 0:	idx = G_SHIRTBYTE1; break;
			case 1:	idx = G_SHIRTBYTE2; break;
			case 2:	idx = G_SHIRTBYTE3; break;
			case 3:	idx = G_SHIRTBYTE4; break;
			case 4:	idx = G_SHIRTBYTE5; break;
			case 5:	idx = G_SHIRTBYTE6; break;
			case 6:	idx = G_SHIRTBYTE7; break;
			default: idx = G_SHIRTBYTE8; break;
		}
	}
	else if(type==OTYPE_BOTTOM){
		switch(idx){
			case 0:	idx = G_PANTSBYTE1; break;
			case 1:	idx = G_PANTSBYTE2; break;
			case 2:	idx = G_PANTSBYTE3; break;
			case 3:	idx = G_PANTSBYTE4; break;
			case 4:	idx = G_PANTSBYTE5; break;
			case 5:	idx = G_PANTSBYTE6; break;
			case 6:	idx = G_PANTSBYTE7; break;
			default: idx = G_PANTSBYTE8; break;
		}
	}
	else if(type==OTYPE_ACCESSORY){
		switch(idx){
			case 0:	idx = G_ACCESSORYBYTE1; break;
			case 1:	idx = G_ACCESSORYBYTE2; break;
			case 2:	idx = G_ACCESSORYBYTE3; break;
			case 3:	idx = G_ACCESSORYBYTE4; break;
			case 4:	idx = G_ACCESSORYBYTE5; break;
			case 5:	idx = G_ACCESSORYBYTE6; break;
			case 6:	idx = G_ACCESSORYBYTE7; break;
			default: idx = G_ACCESSORYBYTE8; break;
		}
	}
	else if(type==OTYPE_COLOR){
		switch(idx){
			case 0:	idx = G_COLORBYTE1; break;
			case 1:	idx = G_COLORBYTE2; break;
			case 2:	idx = G_COLORBYTE3; break;
			case 3:	idx = G_COLORBYTE4; break;
			case 4:	idx = G_COLORBYTE5; break;
			case 5:	idx = G_COLORBYTE6; break;
			case 6:	idx = G_COLORBYTE7; break;
			default: idx = G_COLORBYTE8; break;
		}
	}

	if(set){
		if(val)
			G[idx] |= idxbit;
		else
			G[idx] &= ~idxbit;
		return true;
	}
	else
		return G[idx] & idxbit;
}

int GetOutfitPieceTile(int type, int id){
	if(type==OTYPE_TOP){
		switch(id){
			case TOP_HOKUF: return 133940;
			case TOP_MALKAVEST: return 133941;
			case TOP_CHESTWRAP: return 133942;
			case TOP_BASICSHIRT: return 133943;
			case TOP_WELLINGTON: return 133944;
			case TOP_TULANE: return 133945;
			case TOP_CULTIST: return 133946;
			case TOP_ARMOR: return 133947;
			case TOP_HOODIE1: return 133948;
			case TOP_HOODIE2: return 133949;
			case TOP_ZARATH: return 133950;
			case TOP_TATTOOS: return 133951;
			case TOP_JACKET: return 133952;
			case TOP_MALKAVESTF: return 133941;
			case TOP_CAPTAINVEST: return 133953;
			case TOP_CAPTAINVESTF: return 133953;
		}
	}
	else if(type==OTYPE_BOTTOM){
		switch(id){
			case BOTTOM_HOKU: return 133960;
			case BOTTOM_HOKUF: return 133961;
			case BOTTOM_MALKA: return 133962;
			case BOTTOM_SKIRT: return 133963;
			case BOTTOM_PALA: return 133964;
			case BOTTOM_WELLINGTON: return 133965;
			case BOTTOM_CULTIST: return 133966;
			case BOTTOM_ARMOR: return 133967;
		}
	}
	else if(type==OTYPE_ACCESSORY){
		switch(id){
			case ACCESSORY_TOPHAT: return 133980;
			case ACCESSORY_HATSTACK: return 133984;
			case ACCESSORY_BONNET: return 133981;
			case ACCESSORY_MOUSTACHE: return 133982;
			case ACCESSORY_GLASSES: return 133983;
			case ACCESSORY_EYEPATCH: return 133985;
			case ACCESSORY_BANDANA: return 133986;
			case ACCESSORY_CAPTAINSHAT: return 133987;
			case ACCESSORY_CULTISTHOOD: return 134000;
			case ACCESSORY_GOLEMHEAD: return 134001;
			case ACCESSORY_NIGHTMAREMASK: return 133988;
			case ACCESSORY_NIGHTMAREEYE: return 133989;
			case ACCESSORY_CIRCLET: return 133990;
			case ACCESSORY_HOODIE: return 133995;
			case ACCESSORY_HOODIEDOWN: return 133995;
			case ACCESSORY_HALO: return 133994;
			case ACCESSORY_BLINDFOLD: return 133993;
			case ACCESSORY_BRACELETS: return 134002;
			case ACCESSORY_HEADBAND: return 133991;
			case ACCESSORY_CROWN: return 133992;
			case ACCESSORY_GOGGLES: return 133996;
			case ACCESSORY_STETSON: return 133997;
			case ACCESSORY_HIBISCUS: return 133998;
			case ACCESSORY_CAP: return 133999;
			case ACCESSORY_SOLARMASK: return 134003;
			case ACCESSORY_LUNARMASK: return 134004;
			case ACCESSORY_STELLARMASK: return 134005;
			case ACCESSORY_TURBAN: return 134006;
			case ACCESSORY_TRUFNECKLACE: return 134007;
			case ACCESSORY_WARRIORNECKLACE: return 134008;
			case ACCESSORY_WARRIORHELMET: return 134009;
			case ACCESSORY_SKULLMASK: return 134010;
			case ACCESSORY_EISENFAUST: return 134011;
		}
	}
	else if(type==OTYPE_COLOR){
		switch(id){
			case OCLR_CRIMSON: return 133901;
			case OCLR_PALEPINK: return 133902;
			case OCLR_GOLDENYELLOW: return 133904;
			case OCLR_PALEGREEN: return 133907;
			case OCLR_DULLGREEN: return 133908;
			case OCLR_FORESTGREEN: return 133909;
			case OCLR_SKYBLUE: return 133911;
			case OCLR_DEEPBLUE: return 133912;
			case OCLR_PERIWINKLE: return 133914;
			case OCLR_PALEPERIWINKLE: return 133915;
			case OCLR_PURPLE: return 133916;
			case OCLR_PALEPURPLE: return 133917;
			case OCLR_MUDBROWN: return 133919;
			case OCLR_WHITE: return 133920;
			case OCLR_LIGHTGREY: return 133921;
			case OCLR_DARKGREY: return 133922;
			case OCLR_DARKBLACK: return 133924;
			case OCLR_NIGREDO: return 133925;
		}
	}
	return 0;
}

void GetOutfitPieceName(int buf, int type, int id){
	if(type==OTYPE_TOP){
		switch(id){
			case TOP_HOKUF: CopyStringToBuffer(buf, "Hoku Top"); return;
			case TOP_MALKAVEST: CopyStringToBuffer(buf, "Malka Vest"); return;
			case TOP_CHESTWRAP: CopyStringToBuffer(buf, "Chest Wrap"); return;
			case TOP_BASICSHIRT: CopyStringToBuffer(buf, "Basic Shirt"); return;
			case TOP_WELLINGTON: CopyStringToBuffer(buf, "Wellington's Tux"); return;
			case TOP_TULANE: CopyStringToBuffer(buf, "Tulane's Dress"); return;
			case TOP_CULTIST: CopyStringToBuffer(buf, "Cultist Cloak"); return;
			case TOP_ARMOR: CopyStringToBuffer(buf, "Chest Plate"); return;
			case TOP_HOODIE1: CopyStringToBuffer(buf, "Hoodie"); return;
			case TOP_HOODIE2: CopyStringToBuffer(buf, "Hoodie"); return;
			case TOP_ZARATH: CopyStringToBuffer(buf, "Plated Robe"); return;
			case TOP_TATTOOS: CopyStringToBuffer(buf, "Temporary Tattoos"); return;
			case TOP_JACKET: CopyStringToBuffer(buf, "Buttoned Jacket"); return;
			case TOP_MALKAVESTF: CopyStringToBuffer(buf, "Malka Vest"); return;
			case TOP_CAPTAINVEST: CopyStringToBuffer(buf, "Captain's Vest"); return;
			case TOP_CAPTAINVESTF: CopyStringToBuffer(buf, "Captain's Vest"); return;
		}
	}
	else if(type==OTYPE_BOTTOM){
		switch(id){
			case BOTTOM_HOKU: CopyStringToBuffer(buf, "Pareo"); return;
			case BOTTOM_HOKUF: CopyStringToBuffer(buf, "Tupenu"); return;
			case BOTTOM_MALKA: CopyStringToBuffer(buf, "Malkan Wrap"); return;
			case BOTTOM_SKIRT: CopyStringToBuffer(buf, "Skirt"); return;
			case BOTTOM_PALA: CopyStringToBuffer(buf, "Pala Pants"); return;
			case BOTTOM_WELLINGTON: CopyStringToBuffer(buf, "Wellington's Trousers"); return;
			case BOTTOM_CULTIST: CopyStringToBuffer(buf, "Cultist Poofy Pants"); return;
			case BOTTOM_ARMOR: CopyStringToBuffer(buf, "Leg Plate"); return;
		}
	}
	else if(type==OTYPE_ACCESSORY){
		switch(id){
			case ACCESSORY_TOPHAT: CopyStringToBuffer(buf, "Stove Top"); return;
			case ACCESSORY_HATSTACK: CopyStringToBuffer(buf, "Double Burner"); return;
			case ACCESSORY_BONNET: CopyStringToBuffer(buf, "Bonnet"); return;
			case ACCESSORY_MOUSTACHE: CopyStringToBuffer(buf, "Fake Moustache"); return;
			case ACCESSORY_GLASSES: CopyStringToBuffer(buf, "Glasses"); return;
			case ACCESSORY_EYEPATCH: CopyStringToBuffer(buf, "Eyepatch"); return;
			case ACCESSORY_BANDANA: CopyStringToBuffer(buf, "Bandana"); return;
			case ACCESSORY_CAPTAINSHAT: CopyStringToBuffer(buf, "Captain's Hat"); return;
			case ACCESSORY_CULTISTHOOD: CopyStringToBuffer(buf, "Cultist Hood"); return;
			case ACCESSORY_GOLEMHEAD: CopyStringToBuffer(buf, "Golem Head"); return;
			case ACCESSORY_NIGHTMAREMASK: CopyStringToBuffer(buf, "Nightmare Mask"); return;
			case ACCESSORY_NIGHTMAREEYE: CopyStringToBuffer(buf, "Cosmic Sight"); return;
			case ACCESSORY_CIRCLET: CopyStringToBuffer(buf, "Circlet"); return;
			case ACCESSORY_HOODIE: CopyStringToBuffer(buf, "Hoodie"); return;
			case ACCESSORY_HOODIEDOWN: CopyStringToBuffer(buf, "Hoodie"); return;
			case ACCESSORY_HALO: CopyStringToBuffer(buf, "Halo"); return;
			case ACCESSORY_BLINDFOLD: CopyStringToBuffer(buf, "Blindfold"); return;
			case ACCESSORY_BRACELETS: CopyStringToBuffer(buf, "Bracelets"); return;
			case ACCESSORY_HEADBAND: CopyStringToBuffer(buf, "Headband"); return;
			case ACCESSORY_CROWN: CopyStringToBuffer(buf, "Crown"); return;
			case ACCESSORY_GOGGLES: CopyStringToBuffer(buf, "Goggles"); return;
			case ACCESSORY_STETSON: CopyStringToBuffer(buf, "Stetson"); return;
			case ACCESSORY_HIBISCUS: CopyStringToBuffer(buf, "Hibiscus"); return;
			case ACCESSORY_CAP: CopyStringToBuffer(buf, "Cap"); return;
			case ACCESSORY_SOLARMASK: CopyStringToBuffer(buf, "Solar Mask"); return;
			case ACCESSORY_LUNARMASK: CopyStringToBuffer(buf, "Lunar Mask"); return;
			case ACCESSORY_STELLARMASK: CopyStringToBuffer(buf, "Stellar Mask"); return;
			case ACCESSORY_TURBAN: CopyStringToBuffer(buf, "Turban"); return;
			case ACCESSORY_TRUFNECKLACE: CopyStringToBuffer(buf, "Truf's Necklace"); return;
			case ACCESSORY_WARRIORNECKLACE: CopyStringToBuffer(buf, "Warrior Necklace"); return;
			case ACCESSORY_WARRIORHELMET: CopyStringToBuffer(buf, "Warrior Helmet"); return;
			case ACCESSORY_SKULLMASK: CopyStringToBuffer(buf, "Skull Mask"); return;
			case ACCESSORY_EISENFAUST: CopyStringToBuffer(buf, "Eisenfaust"); return;
		}
	}
	else if(type==OTYPE_COLOR){
		switch(id){
			case OCLR_CRIMSON: CopyStringToBuffer(buf, "Crimson Dye"); return;
			case OCLR_PALEPINK: CopyStringToBuffer(buf, "Pale Pink Dye"); return;
			case OCLR_GOLDENYELLOW: CopyStringToBuffer(buf, "Golden Yellow Dye"); return;
			case OCLR_PALEGREEN: CopyStringToBuffer(buf, "Pale Green Dye"); return;
			case OCLR_DULLGREEN: CopyStringToBuffer(buf, "Dull Green Dye"); return;
			case OCLR_FORESTGREEN: CopyStringToBuffer(buf, "Forest Green Dye"); return;
			case OCLR_SKYBLUE: CopyStringToBuffer(buf, "Sky Blue Dye"); return;
			case OCLR_DEEPBLUE: CopyStringToBuffer(buf, "Deep Blue Dye"); return;
			case OCLR_PERIWINKLE: CopyStringToBuffer(buf, "Periwinkle Dye"); return;
			case OCLR_PALEPERIWINKLE: CopyStringToBuffer(buf, "Pale Periwinkle Dye"); return;
			case OCLR_PURPLE: CopyStringToBuffer(buf, "Purple Dye"); return;
			case OCLR_PALEPURPLE: CopyStringToBuffer(buf, "Pale Purple Dye"); return;
			case OCLR_MUDBROWN: CopyStringToBuffer(buf, "Mud Brown Dye"); return;
			case OCLR_WHITE: CopyStringToBuffer(buf, "White Dye"); return;
			case OCLR_LIGHTGREY: CopyStringToBuffer(buf, "Light Grey Dye"); return;
			case OCLR_DARKGREY: CopyStringToBuffer(buf, "Dark Grey Dye"); return;
			case OCLR_DARKBLACK: CopyStringToBuffer(buf, "Dark Black Dye"); return;
			case OCLR_NIGREDO: CopyStringToBuffer(buf, "Nigredo Dye"); return;
		}
	}
}

void ReadOutfitSaveFile(){
	int buf[128];
	
	file outfitSave;
	bool success = outfitSave->Open("PersistentData.sssave");
	if(success){
		outfitSave->ReadBytes(buf, -1, 0);
		
		for(int i=0; i<6; ++i){
			G[G_SHIRT+i] = buf[i];
			G[G_SHIRTCOLOR+i] = buf[6+i];
			G[G_PANTS+i] = buf[12+i];
			G[G_PANTSCOLOR+i] = buf[18+i];
			G[G_USINGCUSTOMOUTFIT+i] = buf[24+i];
			G[G_ACCESSORY1+i] = buf[30+i];
			G[G_ACCESSORY1COLOR+i] = buf[36+i];
			G[G_ACCESSORY2+i] = buf[42+i];
			G[G_ACCESSORY2COLOR+i] = buf[48+i];
		}
		
		int extraFlags = buf[54];
		if(extraFlags&0x1)
			G[G_NOOUTFITEFFECTS] = 1;
		else
			G[G_NOOUTFITEFFECTS] = 0;
		
		for(int i=0; i<8; ++i)
			G[G_SHIRTBYTE1+i] = buf[64+i];
		
		for(int i=0; i<8; ++i)
			G[G_PANTSBYTE1+i] = buf[72+i];
		
		for(int i=0; i<8; ++i)
			G[G_ACCESSORYBYTE1+i] = buf[80+i];
		
		for(int i=0; i<8; ++i)
			G[G_COLORBYTE1+i] = buf[88+i];
		
	}
	outfitSave->Free();
}
void WriteOutfitSaveFile(){
	int buf[128];
	
	for(int i=0; i<6; ++i){
		buf[i] = G[G_SHIRT+i];
		buf[6+i] = G[G_SHIRTCOLOR+i];
		buf[12+i] = G[G_PANTS+i];
		buf[18+i] = G[G_PANTSCOLOR+i];
		buf[24+i] = G[G_USINGCUSTOMOUTFIT+i];
		buf[30+i] = G[G_ACCESSORY1+i];
		buf[36+i] = G[G_ACCESSORY1COLOR+i];
		buf[42+i] = G[G_ACCESSORY2+i];
		buf[48+i] = G[G_ACCESSORY2COLOR+i];
	}
	
	int extraFlags;
	if(G[G_NOOUTFITEFFECTS])
		extraFlags |= 0x1;
	buf[54] = extraFlags;
	
	for(int i=0; i<8; ++i)
		buf[64+i] = G[G_SHIRTBYTE1+i];
	
	for(int i=0; i<8; ++i)
		buf[72+i] = G[G_PANTSBYTE1+i];
	
	for(int i=0; i<8; ++i)
		buf[80+i] = G[G_ACCESSORYBYTE1+i];
	
	for(int i=0; i<8; ++i)
		buf[88+i] = G[G_COLORBYTE1+i];
	
	file outfitSave;
	outfitSave->Create("PersistentData.sssave");
	
	outfitSave->WriteBytes(buf, 128, 0);
	
	outfitSave->Free();
}

void PickOutfitCommentary(int which){
	int top = -1; int bottom = -1; int string = -1;
	if(which == CHAR_ASHER){
		switch(G[G_SHIRT+which]){
			case TOP_BASICSHIRT:
				top = 1;
				break;
			case TOP_MALKAVEST:
				top = 3;
				break;
			case TOP_WELLINGTON:
			case TOP_TULANE:
			case TOP_ZARATH:
				top = 4;
				break;
			case TOP_CULTIST:
				top = 5;
				break;
			case TOP_ARMOR:
				top = 6;
				break;
			case TOP_HOODIE1:
			case TOP_JACKET:
				top = 7;
				break;
			case TOP_TATTOOS:
				top = 8;
				break;
		}
		switch(G[G_PANTS+which]){
			case BOTTOM_HOKU:
				bottom = 2;
				break;
			case BOTTOM_MALKA:
				bottom = 3;
				break;
			case BOTTOM_WELLINGTON:
				bottom = 4;
				break;
			case BOTTOM_CULTIST:
				bottom = 5;
				break;
			case BOTTOM_ARMOR:
				bottom = 6;
				break;
		}
		if((top == -1 && G[G_PANTS+which] == BOTTOM_PALA) || G[G_USINGCUSTOMOUTFIT+which] == 0)
			string = 0;
		else if(top == -1 && bottom != -1)
			string = bottom;
		else if(top != -1 && bottom == -1)
			string = top;
		else
			string = Choose(top, bottom);
		switch(string){
			case 0:
				PlayStringAndWaitLower("Feels nice to be back in my own clothes again.", SCHAR_ASHER, EMOTE_NORMAL);
				break;
			case 1:
				PlayStringAndWaitLower("Alright, climbing the social ladder now.", SCHAR_ASHER, EMOTE_NORMAL);
				PlayStringAndWaitLower("I think ya looked better without.", SCHAR_TORRIN, EMOTE_NORMAL);
				PlayStringAndWaitLower("What was that?", SCHAR_ASHER, EMOTE_NORMAL);
				PlayStringAndWaitLower("Nothin'.", SCHAR_TORRIN, EMOTE_EMBARRASSED);
				break;
			case 2:
				PlayStringAndWaitLower("Get me a star chart and I'd look just like an astronomer.", SCHAR_ASHER, EMOTE_NORMAL);
				PlayStringAndWaitLower("Mate, your skin tone's about 20 shades too light to ever pass as an astronomer.", SCHAR_TORRIN, EMOTE_NORMAL);
				PlayStringAndWaitLower("Not necessarily. There used to be Omakan Astronomers, way back when.", SCHAR_SIYED, EMOTE_NORMAL);
				PlayStringAndWaitLower("Alright, just gotta find a way to go back in time an' you're all set.", SCHAR_TORRIN, EMOTE_NORMAL);
				break;
			case 3:
				PlayStringAndWaitLower("I'm feeling a little silly in this, Torrin.", SCHAR_ASHER, EMOTE_EMBARRASSED);
				PlayStringAndWaitLower("Silly? You look like a practiced sailor, Ash! Master of the seas! Striking fear into the hearts of fish whereever you sail!", SCHAR_TORRIN, EMOTE_NORMAL);
				PlayStringAndWaitLower("Said with absolutely no bias.", SCHAR_KAYLANI, EMOTE_NORMAL);
				PlayStringAndWaitLower("Oh quiet, you.", SCHAR_TORRIN, EMOTE_NORMAL);
				break;
			case 4:
				PlayStringAndWaitLower("Be honest, how do I look?", SCHAR_ASHER, EMOTE_NORMAL);
				PlayStringAndWaitLower("Kinda like a scarecrow that got dragged through a rich folk's closet, then tossed into the ocean, then washed ashore a few days later.", SCHAR_TERRY, EMOTE_NORMAL);
				PlayStringAndWaitLower("... Maybe a little less honesty.", SCHAR_ASHER, EMOTE_EMBARRASSED);
				break;
			case 5:
				PlayStringAndWaitLower("Back in disguise again? As long as I don't have to wear that ridiculous mask this time...", SCHAR_ASHER, EMOTE_NORMAL);
				break;
			case 6:
				PlayStringAndWaitLower("I had a dream like this once. Never thought it'd actually come true.", SCHAR_ASHER, EMOTE_NORMAL);
				PlayStringAndWaitLower("Are you sure an outfit like that is wise? If you fall off the boat, I don't know if we could pull you back in.", SCHAR_KAYLANI, EMOTE_NORMAL);
				PlayStringAndWaitLower("That's a good point...", SCHAR_ASHER, EMOTE_NORMAL);
				break;
			case 7:
				PlayStringAndWaitLower("Apparently stuff like this is really popular in some parts of the world.", SCHAR_ASHER, EMOTE_NORMAL);
				PlayStringAndWaitLower("It seems a little warm.", SCHAR_KAYLANI, EMOTE_EYEBROWRAISED);
				PlayStringAndWaitLower("Colder parts of the world.", SCHAR_ASHER, EMOTE_NORMAL);
				break;
			case 8:
				PlayStringAndWaitLower("Whoa. What kinds of designs are those?", SCHAR_SIYED, EMOTE_NORMAL);
				PlayStringAndWaitLower("I have no idea. The guy said people used to have tattoos like this back in the day on Omaka. Except those weren't temporary.", SCHAR_ASHER, EMOTE_NORMAL);
				break;
		}
	}
	if(which == CHAR_TORRIN){
		switch(G[G_SHIRT+which]){
			case TOP_WELLINGTON:
			case TOP_TULANE:
			case TOP_ZARATH:
				top = 4;
				break;
			case TOP_CULTIST:
				top = 5;
				break;
			case TOP_ARMOR:
				top = 6;
				break;
			case TOP_HOODIE1:
			case TOP_JACKET:
				top = 7;
				break;
			case TOP_TATTOOS:
				top = 8;
				break;
		}
		switch(G[G_PANTS+which]){
			case BOTTOM_PALA:
				bottom = 1;
				break;
			case BOTTOM_HOKU:
				bottom = 2;
				break;
			case BOTTOM_WELLINGTON:
				bottom = 4;
				break;
			case BOTTOM_CULTIST:
				bottom = 5;
				break;
			case BOTTOM_ARMOR:
				bottom = 6;
				break;
		}
		if((G[G_SHIRT+which] == TOP_MALKAVEST && G[G_PANTS+which] == BOTTOM_MALKA) || G[G_USINGCUSTOMOUTFIT+which] == 0)
			string = 0;
		else if(top == -1 && bottom != -1)
			string = bottom;
		else if(top != -1 && bottom == -1)
			string = top;
		else
			string = Choose(top, bottom);
		switch(string){
			case 0:
				PlayStringAndWaitLower("Dress up's fun an' all, but nothin' like the feelin' a' your own shirt on your back.", SCHAR_TORRIN, EMOTE_NORMAL);
				break;
			case 1:
				PlayStringAndWaitLower("Ash, how d'ya move around in these?", SCHAR_TORRIN, EMOTE_NORMAL);
				PlayStringAndWaitLower("What do you mean?", SCHAR_ASHER, EMOTE_NORMAL);
				PlayStringAndWaitLower("It feels like these are suffocatin' my legs. No idea how ya manage to walk aroun' in 'em.", SCHAR_TORRIN, EMOTE_NORMAL);
				break;
			case 2:
				PlayStringAndWaitLower("Okay, why am I wearin' one a' my sister's skirts?", SCHAR_TORRIN, EMOTE_NORMAL);
				PlayStringAndWaitLower("Skirt? It's a pareo! It's completely different!", SCHAR_SIYED, EMOTE_NORMAL);
				PlayStringAndWaitLower("Yeah Torrin, it's totally different! Definitely doesn't look like you're wearin' my skirt!", SCHAR_TERRY, EMOTE_HAPPY);
				PlayStringAndWaitLower("You ain't even tryin' to hide that smirk, sis!", SCHAR_TORRIN, EMOTE_ANGRY);
				break;
			case 4:
				PlayStringAndWaitLower("Well well, wot a fine day it is, if I do say so.", SCHAR_TORRIN, EMOTE_NORMAL);
				PlayStringAndWaitLower("Is that supposed to be a fancy accent?", SCHAR_KAYLANI, EMOTE_EYEBROWRAISED);
				PlayStringAndWaitLower("What d'ya mean 'supposed' t'be. I've been practicin' it!", SCHAR_TORRIN, EMOTE_ANGRY);
				PlayStringAndWaitLower("Sounds like you got a sinus cold.", SCHAR_TERRY, EMOTE_NORMAL);
				break;
			case 5:
				PlayStringAndWaitLower("Sure it ain't practical, but ya gotta admit, Selet's uniforms are a little snazzy.", SCHAR_TORRIN, EMOTE_NORMAL);
				PlayStringAndWaitLower("Never figured I'd hear that from you of all people.", SCHAR_ASHER, EMOTE_NORMAL);
				PlayStringAndWaitLower("What? Don't have to be a fashion king to admire a cool outfit.", SCHAR_TORRIN, EMOTE_NORMAL);
				break;
			case 6:
				PlayStringAndWaitLower("Evil doers, beware! Torrin the Indestructible has arrived!", SCHAR_TORRIN, EMOTE_NORMAL);
				PlayStringAndWaitLower("... Torrin? Can you move in that?", SCHAR_SORENPANTS, EMOTE_ELLIPSES);
				PlayStringAndWaitLower("That ain't the point!", SCHAR_TORRIN, EMOTE_NORMAL);
				break;
			case 7:
				PlayStringAndWaitLower("Check it out, Ash! Next time you need me to lend you my jacket, you don't gotta worry about it bein' chilly!", SCHAR_TORRIN, EMOTE_NORMAL);
				PlayStringAndWaitLower("I appreciate it, but aren't you gonna be a little warm in that?", SCHAR_ASHER, EMOTE_NORMAL);
				PlayStringAndWaitLower("Pft, as if a little heat would get to me. They don't call me Torrin the Incombustible for nothin'!", SCHAR_TORRIN, EMOTE_NORMAL);
				PlayStringAndWaitLower("Only one person has ever called you that. And he proved it wasn't a very apt description.", SCHAR_KAYLANI, EMOTE_NORMAL);
				break;
			case 8:
				PlayStringAndWaitLower("Torrin, Mom's gonna flay you if she sees that you got a tattoo.", SCHAR_TERRY, EMOTE_NORMAL);
				PlayStringAndWaitLower("Relax, it's just paint. Don't tell her that though. I wanna see her lose it first.", SCHAR_TORRIN, EMOTE_WINK);
				PlayStringAndWaitLower("The more you talk, the more I sympathize with her instead of you.", SCHAR_KAYLANI, EMOTE_NORMAL);
				break;
		}
	}
	if(which == CHAR_KAYLANI){
		switch(G[G_SHIRT+which]){
			case TOP_CHESTWRAP:
				top = 3;
				break;
			case TOP_WELLINGTON:
			case TOP_TULANE:
			case TOP_ZARATH:
				top = 4;
				break;
			case TOP_CULTIST:
				top = 5;
				break;
			case TOP_ARMOR:
				top = 6;
				break;
			case TOP_HOODIE1:
			case TOP_JACKET:
				top = 7;
				break;
		}
		switch(G[G_PANTS+which]){
			case BOTTOM_PALA:
				bottom = 1;
				break;
			case BOTTOM_SKIRT:
				bottom = 3;
				break;
			case BOTTOM_WELLINGTON:
				bottom = 4;
				break;
			case BOTTOM_CULTIST:
				bottom = 5;
				break;
			case BOTTOM_ARMOR:
				bottom = 6;
				break;
		}
		if((G[G_SHIRT+which] == TOP_HOKUF && G[G_PANTS+which] == BOTTOM_HOKUF) || G[G_USINGCUSTOMOUTFIT+which] == 0)
			string = 0;
		else if(top == -1 && bottom != -1)
			string = bottom;
		else if(top != -1 && bottom == -1)
			string = top;
		else
			string = Choose(top, bottom);
		switch(string){
			case 0:
				PlayStringAndWaitLower("They may have fallen out of fashion here in Pala, but I still prefer the styles of Hoku.", SCHAR_KAYLANI, EMOTE_NORMAL);
				break;
			case 1:
				PlayStringAndWaitLower("I have to admit, the pockets sewn into these are nice. I could get used to this.", SCHAR_KAYLANI, EMOTE_NORMAL);
				break;
			case 3:
				PlayStringAndWaitLower("Not bad, Kaylani, those look great on you.", SCHAR_TERRY, EMOTE_NORMAL);
				PlayStringAndWaitLower("They don't coordinate as well as Hoku's tupenas, but they do look quite nice.", SCHAR_KAYLANI, EMOTE_NORMAL);
				PlayStringAndWaitLower("Coordinate?", SCHAR_TORRIN, EMOTE_NORMAL);
				PlayStringAndWaitLower("Yes. Making the top and bottom half of your outfit match.", SCHAR_KAYLANI, EMOTE_NORMAL);
				PlayStringAndWaitLower("Wait, that's a thing? Man, why'd you have to go and make something as simple as clothes complicated?", SCHAR_TORRIN, EMOTE_NORMAL);
				break;
			case 4:
				PlayStringAndWaitLower("I've been told that across cultures, formal outfits tend to prioritize appearance over function.", SCHAR_KAYLANI, EMOTE_NORMAL);
				PlayStringAndWaitLower("... but?", SCHAR_SIYED, EMOTE_NORMAL);
				PlayStringAndWaitLower("But even so, this feels a bit much. I'm afraid I'm going to trip over my outfit if we get into a fight.", SCHAR_KAYLANI, EMOTE_NORMAL);
				break;
			case 5:
				PlayStringAndWaitLower("Even pretending to be one of Selet's men makes me feel angry with myself.", SCHAR_KAYLANI, EMOTE_NORMAL);
				PlayStringAndWaitLower("That's the spirit. Now take all that anger and shove it their way!", SCHAR_SORENPANTS, EMOTE_NORMAL);
				break;
			case 6:
				PlayStringAndWaitLower("Whoever this armor was built for was clearly not a solar mage.", SCHAR_KAYLANI, EMOTE_NORMAL);
				PlayStringAndWaitLower("What makes you say that?", SCHAR_ASHER, EMOTE_NORMAL);
				PlayStringAndWaitLower("The heat from all my spells is getting trapped inside. I'm slowly cooking myself.", SCHAR_KAYLANI, EMOTE_NORMAL);
				break;
			case 7:
				PlayStringAndWaitLower("This feels surprisingly comfortable.", SCHAR_KAYLANI, EMOTE_NORMAL);
				PlayStringAndWaitLower("Looks like any other shirt to me. Just a bit warmer.", SCHAR_TERRY, EMOTE_NORMAL);
				PlayStringAndWaitLower("Warmer, sure, but softer too. I could get used to this.", SCHAR_KAYLANI, EMOTE_NORMAL);
				break;
		}
	}
	if(which == CHAR_SOREN){
		switch(G[G_SHIRT+which]){
			case TOP_BASICSHIRT:
				top = 1;
				break;
			case TOP_MALKAVEST:
				top = 3;
				break;
			case TOP_WELLINGTON:
			case TOP_TULANE:
			case TOP_ZARATH:
				top = 4;
				break;
			case TOP_CULTIST:
				top = 5;
				break;
			case TOP_ARMOR:
				top = 6;
				break;
			case TOP_HOODIE1:
			case TOP_JACKET:
				top = 7;
				break;
			case TOP_TATTOOS:
				top = 8;
				break;
		}
		switch(G[G_PANTS+which]){
			case BOTTOM_HOKU:
				bottom = 2;
				break;
			case BOTTOM_MALKA:
				bottom = 3;
				break;
			case BOTTOM_WELLINGTON:
				bottom = 4;
				break;
			case BOTTOM_CULTIST:
				bottom = 5;
				break;
			case BOTTOM_ARMOR:
				bottom = 6;
				break;
		}
		if((top == -1 && G[G_PANTS+which] == BOTTOM_PALA) || G[G_USINGCUSTOMOUTFIT+which] == 0)
			string = 0;
		else if(top == -1 && bottom != -1)
			string = bottom;
		else if(top != -1 && bottom == -1)
			string = top;
		else
			string = Choose(top, bottom);
		switch(string){
			case 0:
				PlayStringAndWaitLower("Simple's best, as far as I'm concerned. Let's stop messing with outfits and get back out there!", SCHAR_SORENPANTS, EMOTE_NORMAL);
				break;
			case 1:
				PlayStringAndWaitLower("Ugh, this shirt makes me look like one of THEM.", SCHAR_SORENPANTS, EMOTE_NORMAL);
				PlayStringAndWaitLower("I mean, you do have a lot of money now. Might as well dress the part, right?", SCHAR_ASHER, EMOTE_NORMAL);
				PlayStringAndWaitLower("Asher, how could you say something so horrible?", SCHAR_SORENPANTS, EMOTE_NORMAL);
				break;
			case 2:
				PlayStringAndWaitLower("Does it ever seem funny to you that we all wear different things even though all our islands are so close?", SCHAR_SORENPANTS, EMOTE_NORMAL);
				PlayStringAndWaitLower("Actually, Omakan men used to dress just like we do. That only changed recently, when all the traders from afar arrived in Pala.", SCHAR_SIYED, EMOTE_NORMAL);
				PlayStringAndWaitLower("Wait, really? Huh... guess I'm connecting with my roots then?", SCHAR_SORENPANTS, EMOTE_NORMAL);
				break;
			case 3:
				PlayStringAndWaitLower("Alright, who's ready to hit the sand?", SCHAR_SORENPANTS, EMOTE_NORMAL);
				PlayStringAndWaitLower("You really liked it in Malka, huh?", SCHAR_TORRIN, EMOTE_NORMAL);
				PlayStringAndWaitLower("Can't even begin to tell you how nice it was to be away from the hustle and bustle in Pala.", SCHAR_SORENPANTS, EMOTE_NORMAL);
				PlayStringAndWaitLower("Says the most husttling, bustling thing in Malka.", SCHAR_TERRY, EMOTE_NORMAL);
				break;
			case 4:
				PlayStringAndWaitLower("PLEASE don't make me wear this.", SCHAR_SORENPANTS, EMOTE_NORMAL);
				PlayStringAndWaitLower("Sorry mate, them's the rules. You're richer than all of us now, ya gotta dress the part.", SCHAR_TORRIN, EMOTE_NORMAL);
				PlayStringAndWaitLower("C'mon, Asher, hasn't this gone far enough?", SCHAR_SORENPANTS, EMOTE_NORMAL);
				PlayStringAndWaitLower("Probably, but it's too funny to stop now. I've never seen an outfit look less fitting on someone before.", SCHAR_ASHER, EMOTE_NORMAL);
				break;
			case 5:
				PlayStringAndWaitLower("Ooh, espionage. Oughta be convenient for getting close to some of Selet's lackies and knocking their skulls together.", SCHAR_SORENPANTS, EMOTE_NORMAL);
				break;
			case 6:
				PlayStringAndWaitLower("I don't know about this one. It's pretty hard to run with this much weight.", SCHAR_SORENPANTS, EMOTE_NORMAL);
				PlayStringAndWaitLower("That's sort of the point.", SCHAR_SIYED, EMOTE_SWEAT);
				break;
			case 7:
				PlayStringAndWaitLower("This feels awful close to the outfits the rich folk up there wear... but I do like the extra pockets for hiding explosives in.", SCHAR_SORENPANTS, EMOTE_NORMAL);
				break;
			case 8:
				PlayStringAndWaitLower("Asher, I may have made a mistake. How mad do you think my parents are gonna be?", SCHAR_SORENPANTS, EMOTE_NORMAL);
				PlayStringAndWaitLower("How mad can they get over some temporary tattoos?", SCHAR_ASHER, EMOTE_NORMAL);
				PlayStringAndWaitLower("Uh...", SCHAR_SORENPANTS, EMOTE_ELLIPSES);
				PlayStringAndWaitLower("... They are temporary, right?", SCHAR_ASHER, EMOTE_SWEAT);
				break;
		}
	}
	if(which == CHAR_TERRY){
		switch(G[G_SHIRT+which]){
			case TOP_WELLINGTON:
			case TOP_TULANE:
			case TOP_ZARATH:
				top = 4;
				break;
			case TOP_CULTIST:
				top = 5;
				break;
			case TOP_ARMOR:
				top = 6;
				break;
			case TOP_HOODIE1:
			case TOP_JACKET:
				top = 7;
				break;
		}
		switch(G[G_PANTS+which]){
			case BOTTOM_PALA:
				bottom = 1;
				break;
			case BOTTOM_HOKUF:
				bottom = 2;
				break;
			case BOTTOM_WELLINGTON:
				bottom = 4;
				break;
			case BOTTOM_CULTIST:
				bottom = 5;
				break;
			case BOTTOM_ARMOR:
				bottom = 6;
				break;
		}
		if((G[G_SHIRT+which] == TOP_CHESTWRAP && G[G_PANTS+which] == BOTTOM_SKIRT) || G[G_USINGCUSTOMOUTFIT+which] == 0)
			string = 0;
		else if(top == -1 && bottom != -1)
			string = bottom;
		else if(top != -1 && bottom == -1)
			string = top;
		else
			string = Choose(top, bottom);
		switch(string){
			case 0:
				PlayStringAndWaitLower("If it ain't broke, don't fix it.", SCHAR_TERRY, EMOTE_NORMAL);
				break;
			case 1:
				PlayStringAndWaitLower("Good-bye backwater fishin' girl, hello 'phisticated tradeswoman.", SCHAR_TERRY, EMOTE_NORMAL);
				PlayStringAndWaitLower("It's gonna take way more than a change a' costume to make you sophisticated, sis.", SCHAR_TORRIN, EMOTE_NORMAL);
				PlayStringAndWaitLower("Uh huh, and you're eyein' all the cool lookin' outfits for no 'ticular reason, then?", SCHAR_TERRY, EMOTE_NORMAL);
				PlayStringAndWaitLower("Hey now, that's different.", SCHAR_TORRIN, EMOTE_EMBARRASSED);
				break;
			case 2:
				PlayStringAndWaitLower("Huh. These are a lot easier to move 'round in than I figured.", SCHAR_TERRY, EMOTE_NORMAL);
				PlayStringAndWaitLower("Well of course. How did you think I've been fighting in them?", SCHAR_KAYLANI, EMOTE_NORMAL);
				PlayStringAndWaitLower("Dunno. Guess I figured havin' ranged magic meant you didn't need to move very quickly or anythin'.", SCHAR_TERRY, EMOTE_NORMAL);
				break;
			case 4:
				PlayStringAndWaitLower("Soren, honest 'pinion. Think I could pull off a lost royal heir scheme with some rich sucker here in this getup?", SCHAR_TERRY, EMOTE_NORMAL);
				PlayStringAndWaitLower("Ya know... maybe. If we found the right one.", SCHAR_SORENPANTS, EMOTE_NORMAL);
				PlayStringAndWaitLower("Here, toss on this servant's outfit and let's scout it out.", SCHAR_TERRY, EMOTE_NORMAL);
				PlayStringAndWaitLower("This seems unwise for several reasons...", SCHAR_KAYLANI, EMOTE_NORMAL);
				break;
			case 5:
				PlayStringAndWaitLower("Wow, had no idea those cultists had so many pockets for batteries. Ya know what this outfit smells like?", SCHAR_TERRY, EMOTE_NORMAL);
				PlayStringAndWaitLower("Moths and dust?", SCHAR_ASHER, EMOTE_NORMAL);
				PlayStringAndWaitLower("Opportunity.", SCHAR_TERRY, EMOTE_NORMAL);
				break;
			case 6:
				PlayStringAndWaitLower("Hey, someone grab me a glass bowl. I bet we could rig this into a diving suit.", SCHAR_TERRY, EMOTE_NORMAL);
				PlayStringAndWaitLower("I really don't think that's smart. If you got stuck down there-.", SCHAR_SIYED, EMOTE_NORMAL);
				PlayStringAndWaitLower("I can swim a good hundred feet up in on breath. Ain't that right, Torrin.", SCHAR_TERRY, EMOTE_NORMAL);
				PlayStringAndWaitLower("Eighty feet, an' that was only once. So it sounds like a great idea to me!", SCHAR_TORRIN, EMOTE_NORMAL);
				PlayStringAndWaitLower("I worry about you two...", SCHAR_SIYED, EMOTE_DISMAYED);
				break;
			case 7:
				PlayStringAndWaitLower("Why's this one so baggy? What's the point of a cool shirt if it hides my natural beauty?", SCHAR_TERRY, EMOTE_NORMAL);
				PlayStringAndWaitLower("Ain't much to hide, last I checked.", SCHAR_TORRIN, EMOTE_NORMAL);
				PlayStringAndWaitLower("You're just jealous I got all the looks for the both of us.", SCHAR_TERRY, EMOTE_NORMAL);
				PlayStringAndWaitLower("An' I got the smarts for us both, so it evens out.", SCHAR_TORRIN, EMOTE_NORMAL);
				PlayStringAndWaitLower("You'll be smartin' for sure if you keep that up.", SCHAR_TERRY, EMOTE_NORMAL);
				break;
		}
	}
	if(which == CHAR_SIYED){
		switch(G[G_SHIRT+which]){
			case TOP_BASICSHIRT:
				top = 2;
				break;
			case TOP_MALKAVEST:
				top = 3;
				break;
			case TOP_WELLINGTON:
			case TOP_TULANE:
			case TOP_ZARATH:
				top = 4;
				break;
			case TOP_CULTIST:
				top = 5;
				break;
			case TOP_ARMOR:
				top = 6;
				break;
			case TOP_HOODIE1:
			case TOP_JACKET:
				top = 7;
				break;
			case TOP_TATTOOS:
				top = 8;
				break;
		}
		switch(G[G_PANTS+which]){
			case BOTTOM_PALA:
				bottom = 1;
				break;
			case BOTTOM_WELLINGTON:
				bottom = 4;
				break;
			case BOTTOM_CULTIST:
				bottom = 5;
				break;
			case BOTTOM_ARMOR:
				bottom = 6;
				break;
		}
		if((top == -1 && G[G_PANTS+which] == BOTTOM_HOKU) || G[G_USINGCUSTOMOUTFIT+which] == 0)
			string = 0;
		else if(top == -1 && bottom != -1)
			string = bottom;
		else if(top != -1 && bottom == -1)
			string = top;
		else
			string = Choose(top, bottom);
		switch(string){
			case 0:
				PlayStringAndWaitLower("Maybe a little out of place here, but I think I like my own clothes best.", SCHAR_SIYED, EMOTE_NORMAL);
				break;
			case 1:
				PlayStringAndWaitLower("Having all these pockets is more convenient than I thought.", SCHAR_SIYED, EMOTE_NORMAL);
				PlayStringAndWaitLower("They're great for holding snacks! I've got some nuts and yogurt in mine.", SCHAR_SORENPANTS, EMOTE_NORMAL);
				PlayStringAndWaitLower("That's not a bad- wait, yogurt?", SCHAR_SIYED, EMOTE_NORMAL);
				PlayStringAndWaitLower("He's just messing with you. ... I think. I hope.", SCHAR_ASHER, EMOTE_NORMAL);
				break;
			case 2:
				PlayStringAndWaitLower("Honest question. What's the point of these shirts? They don't seem to have much utility here. Is it really just fashion?", SCHAR_SIYED, EMOTE_NORMAL);
				PlayStringAndWaitLower("It's apparently colder where most of the Pala upper class come from, and they wear shirts like these, but with longer sleeves, to stay warm.", SCHAR_ASHER, EMOTE_NORMAL);
				PlayStringAndWaitLower("Here, though? Just a status symbol for them. A way of settin' them apart from us.", SCHAR_SORENPANTS, EMOTE_NORMAL);
				PlayStringAndWaitLower("I didn't realize politics came into it.", SCHAR_SIYED, EMOTE_NORMAL);
				PlayStringAndWaitLower("Welcome to Pala Bay. Everything's politics here, even the freaking clothes.", SCHAR_SORENPANTS, EMOTE_NORMAL);
				break;
			case 3:
				PlayStringAndWaitLower("I've never understood, why the vests?", SCHAR_SIYED, EMOTE_NORMAL);
				PlayStringAndWaitLower("Keeps the sun off your back when you're hunched over the water, but doesn't get you all hot and sweaty.", SCHAR_TORRIN, EMOTE_NORMAL);
				PlayStringAndWaitLower("Wouldn't it make more sense to make them white then, instead of vibrant colors that absorb sunlight?", SCHAR_SIYED, EMOTE_NORMAL);
				PlayStringAndWaitLower("I guess, but ain't that kinda borin'?", SCHAR_TORRIN, EMOTE_NORMAL);
				break;
			case 4:
				PlayStringAndWaitLower("What do you think? Do I look like a proper Pala academic now?", SCHAR_SIYED, EMOTE_NORMAL);
				PlayStringAndWaitLower("Uh... Sure, yeah, let's go with that.", SCHAR_TERRY, EMOTE_NORMAL);
				PlayStringAndWaitLower("That bad?", SCHAR_SIYED, EMOTE_NORMAL);
				PlayStringAndWaitLower("It looks a little awkward on you. But the good kind of awkward. The... authentically you kind of awkward.", SCHAR_KAYLANI, EMOTE_NORMAL);
				PlayStringAndWaitLower("Thanks? I think?", SCHAR_SIYED, EMOTE_NORMAL);
				break;
			case 5:
				PlayStringAndWaitLower("Does it seem weird to anyone else that this shop's just selling these outfits?", SCHAR_SIYED, EMOTE_NORMAL);
				PlayStringAndWaitLower("I heard they found a whole stache of them in Selet's warehouse when they finally raided it. Best not to let them go to waste, right?", SCHAR_ASHER, EMOTE_NORMAL);
				PlayStringAndWaitLower("Given how many crimes were committed in these outfits, maybe it is?", SCHAR_SIYED, EMOTE_NORMAL);
				break;
			case 6:
				PlayStringAndWaitLower("What d'ya say, Siyed? Feelin' more confident for a fight in that?", SCHAR_TERRY, EMOTE_NORMAL);
				PlayStringAndWaitLower("I don't know. The reflection of my magic off the metal is blinding me.", SCHAR_SIYED, EMOTE_NORMAL);
				PlayStringAndWaitLower("Just close your eyes when ya fight then!", SCHAR_TORRIN, EMOTE_WINK);
				PlayStringAndWaitLower("I'm not sure that will make me feels more confident...", SCHAR_SIYED, EMOTE_SWEAT);
				break;
			case 7:
				PlayStringAndWaitLower("Hey, that one actually looks great on you!", SCHAR_KAYLANI, EMOTE_NORMAL);
				PlayStringAndWaitLower("You think? It's a little hot.", SCHAR_SIYED, EMOTE_NORMAL);
				PlayStringAndWaitLower("An' you're gonna let personal discomfort get in the way a' fashion?", SCHAR_TORRIN, EMOTE_NORMAL);
				PlayStringAndWaitLower("Says the guy rejecting fashion for comfortable clothes?", SCHAR_SIYED, EMOTE_NORMAL);
				PlayStringAndWaitLower("Who says I'm rejectin' fashion? Gotta keep up the rebellious appearance.", SCHAR_TORRIN, EMOTE_NORMAL);
				break;
			case 8:
				PlayStringAndWaitLower("Whoa, looking great, mate!", SCHAR_SORENPANTS, EMOTE_NORMAL);
				PlayStringAndWaitLower("My studies say the design is called a pe'a, and it used to be-", SCHAR_SIYED, EMOTE_NORMAL);
				PlayStringAndWaitLower("Stop when you're ahead, Siyed. Don't turn something cool into something boring.", SCHAR_SORENPANTS, EMOTE_NORMAL);
				break;
		}
	}
}