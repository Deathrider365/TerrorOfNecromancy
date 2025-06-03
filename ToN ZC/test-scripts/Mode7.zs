int VectorX3D(int distance, int yaw, int pitch){
	return distance*Sin(pitch)*Cos(yaw);
}

int VectorY3D(int distance, int yaw, int pitch){
	return distance*Sin(pitch)*Sin(yaw);
}

int VectorZ3D(int distance, int yaw, int pitch){
	return distance*Cos(pitch);
}

void RotateX3D(int angle, int cx, int cy, int cz){
	for(int i=0; i<SizeOfArray(cx); i++){
		int y = cy[i];
		int z = cz[i];
		
		cy[i] = y * Cos(angle) - z * Sin(angle);
		cz[i] = z * Cos(angle) + y * Sin(angle);
	}
}

void RotateY3D(int angle, int cx, int cy, int cz){
	for(int i=0; i<SizeOfArray(cx); i++){
		int x = cx[i];
		int z = cz[i];
		
		cx[i] = x * Cos(angle) - z * Sin(angle);
		cz[i] = z * Cos(angle) + x * Sin(angle);
	}
}

void RotateZ3D(int angle, int cx, int cy, int cz){
	for(int i=0; i<SizeOfArray(cx); i++){
		int x = cx[i];
		int y = cy[i];
		
		cx[i] = x * Cos(angle) - y * Sin(angle);
		cy[i] = y * Cos(angle) + x * Sin(angle);
	}
}

ffc script Bitmap3DTest{
	void run(){
		// bitmap image1 = Game->AllocateBitmap();
		// image1->Read(0,"test.png");
		
		bitmap resized = Game->CreateBitmap(256, 256);
		
		bitmap scrn = Game->CreateBitmap(256, 176);
		
		bitmap fullmap = Game->CreateBitmap(256*16, 176*8);
		
		for(int i=0; i<128; i++){
			fullmap->DrawScreen(6, 1, i, (i%16)*256, Floor(i/16)*176, 0);
		}
		
		scrn->Rectangle(6, 0, 0, 255, 175, 0x00, 1, 0, 0, 0, true, 128);
		scrn->DrawLayer(6, 1, 0x01, 0, 0, 0, 0, 128);
		
		bitmap b = Game->CreateBitmap(256, 176);
		
		Trace(scrn->Width);
		Trace(scrn->Height);
		Trace(resized->Width);
		Trace(resized->Height);
		//resized->BlitTo(6, scrn, 0, 0, scrn->Width, scrn->Height, 0, 0, resized->Width, resized->Height, 0, 0, 0, 0, 0, false);
		
		int xPos; int yPos;
		while(true){
			
			if(Link->InputLeft)
				xPos-=5;
			else if(Link->InputRight)
				xPos+=5;
				
			if(Link->InputUp)
				yPos-=5;
			else if(Link->InputDown)
				yPos+=5;
			
			xPos = Clamp(xPos, 0, 256*15);
			yPos = Clamp(yPos, 0, 176*7);
			
			resized->BlitTo(6, fullmap, xPos, yPos, 256, 176, 0, 0, resized->Width, resized->Height, 0, 0, 0, 0, 0, false);
			
			int sW = 128;
			int sH = 88;
			int pointX[4] = {-sW, -sW*1.4, sW*1.4, sW};
			int pointY[4] = {0, sH, sH, 0};
			int pointZ[4] = {0, 0, 0, 0};
			
			int pos[12] = {pointX[0],pointY[0],pointZ[0],   pointX[1],pointY[1],pointZ[1],   pointX[2],pointY[2],pointZ[2],   pointX[3],pointY[3],pointZ[3]};
			for(int i=0; i<4; i++){
				pos[i*3+0] += this->X+8;
				pos[i*3+1] += this->Y+8;
			}
			
			int w = 256;
			int h = 256;
			int uv[8] = {0,0,   0,h-1,   w-1,h-1,   w-1,0};
			int cset[4] = {0, 0, 0, 0};
			int size[2] = {w,h};
			
			b->Rectangle(6, 0, 0, 255, 175, 0x04, 1, 0, 0, 0, true, 128);
			b->Quad3D(6, pos, uv, cset, size, 0, 0, PT_LITTEXTURE, resized);
			//Screen->Quad(6, quad[0], quad[1], quad[2], quad[3], quad[4], quad[5], quad[6], quad[7], 1, 1, 8, 0, 400, PT_TEXTURE);
			b->Rectangle(6, 0, 88, 255, 96, 0x01, 1, 0, 0, 0, true, 64);
			b->Rectangle(6, 0, 88, 255, 92, 0x01, 1, 0, 0, 0, true, 64);
			b->Rectangle(6, 0, 88, 255, 90, 0x01, 1, 0, 0, 0, true, 128);
			
			b->Blit(2, -2, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
			NoAction();
			
			Waitframe();
		}
	}
}