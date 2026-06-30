dmapdata script StealthRays{
	void run(){
		int warehouse[] = "SS-Warehouse.ogg";
		int spotted[] = "SS-Spotted.ogg";
		G[G_STEALTHSPOTTED] = 0;
		int sightedTracker = G[G_STEALTHSPOTTED];
		if(Game->GetCurDMap()==9){
			if(!G[G_STEALTHSPOTTED]){
				Game->PlayEnhancedMusic(warehouse, 0);
				Game->SetDMapEnhancedMusic(Game->GetCurDMap(), warehouse, 0);
			}
			else{
				Game->PlayEnhancedMusic(spotted, 0);
				Game->SetDMapEnhancedMusic(Game->GetCurDMap(), spotted, 0);
			}
		}
		bool condition;
		if(this->InitD[0] == 1){
			if(Game->Counter[CR_STORYFLAG] >= SFLAG_ASHERKIDNAPPED)
				condition = true;
		}
		if(this->InitD[0] == 2){
			if(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_12)
				condition = true;
		}
		if(G[G_RANDOMIZERENABLED])
			condition = false;
		while(true){
			if(ComboFI(Link->X+8, Link->Y+8, CF_ENDSTEALTH))
				G[G_STEALTHSPOTTED] = 0;
			if(Link->Action!=LA_SCROLLING){
				if(GBMP[BMP_LIGHTRAYS]->isValid()){
					GBMP[BMP_LIGHTRAYS]->Blit(2, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, BITDX_TRANS, 0, true);
					GBMP[BMP_LIGHTRAYS]->Clear(6);
				}
			}
			if(Game->GetCurDMap()==9){
				if(!G[G_STEALTHSPOTTED]&&sightedTracker){
					Game->PlayEnhancedMusic(warehouse, 0);
					Game->SetDMapEnhancedMusic(Game->GetCurDMap(), warehouse, 0);
				}
				else if(G[G_STEALTHSPOTTED]&&!sightedTracker){
					Game->PlayEnhancedMusic(spotted, 0);
					Game->SetDMapEnhancedMusic(Game->GetCurDMap(), spotted, 0);
				}
			}
			sightedTracker = G[G_STEALTHSPOTTED];
			if(condition){
				int newEnemy[10];
				int count;
				for(int i=0; i<10; ++i){
					switch(Screen->Enemy[i]){
						case 0:
						case 191:
						case 192:
						case 193:
						case 231:
						case 186:
						case 188:
							break;
						default:
							newEnemy[count] = Screen->Enemy[i];
							++count;
							break;
					}
				}
				for(int i=0; i<10; ++i){
					Screen->Enemy[i] = newEnemy[i];
				}
			}
			Waitframe();
		}
	}
}

dmapdata script ShallowWaterDraws{
	void StarfallShoalsUpdateBackupBitmaps(mapdata l4temp, mapdata l4tempscroll){
		mapdata l4 = Game->LoadTempScreen(4);
		for(int i=0; i<176; ++i){
			l4tempscroll->ComboD[i] = l4temp->ComboD[i];
			l4tempscroll->ComboC[i] = l4temp->ComboC[i];
			l4tempscroll->ComboF[i] = l4temp->ComboF[i];
			l4temp->ComboD[i] = l4->ComboD[i];
			l4temp->ComboC[i] = l4->ComboC[i];
			l4temp->ComboF[i] = l4->ComboF[i];
			if(!ScreenFlag(SF_MISC, SFM_NOREMOVELAYER4)&&l4->ComboF[i]!=CF_NOREMOVELAYER4)
				l4->ComboD[i] = 0;
		}
	}
	void StarfallShoalsBitmap(bitmap b, mapdata l0, mapdata l1, mapdata l4temp, int blitx, int blity){
		b->Clear(0);
		for(int i=0; i<176; ++i){
			if(l4temp->ComboT[i]==CT_SHALLOWWATER||l4temp->ComboI[i]==98||l4temp->ComboI[i]==99){
				int x = ComboX(i);
				int y = ComboY(i);
				if(l0->ComboD[i]!=l4temp->ComboD[i]){
					l1->ComboD[i] = l0->ComboD[i];
					l1->ComboC[i] = l0->ComboC[i];
					l0->ComboD[i] = l4temp->ComboD[i];
				}
				if(l4temp->ComboI[i]==98&&l4temp->ComboT[i]==CT_SHALLOWWATER){
					b->FastCombo(1, blitx+x, blity+y, l4temp->ComboD[i], l4temp->ComboC[i], 128);
					b->FastCombo(0, blitx+x, blity+y, l1->ComboD[i], l1->ComboC[i], 128);
				}
				else{
					b->FastCombo(0, blitx+x, blity+y, l1->ComboD[i], l1->ComboC[i], 128);
					b->FastCombo(0, blitx+x, blity+y, l4temp->ComboD[i], 0, 128);
				}
			}
		}
		//Mask out white
		b->ReplaceColors(0, 0x00, 0x01, 0x01);
		//Replace colors inside
		b->ReplaceColors(0, 0x26, 0x46, 0x46);
		b->ReplaceColors(0, 0x46, 0x4C, 0x4C);
		b->ReplaceColors(0, 0x4C, 0x4D, 0x4D);
		b->ReplaceColors(0, 0x4D, 0x4E, 0x4E);
	}

	void run(){
		mapdata l4temp = Game->LoadMapData(16, 0x0E);
		mapdata l4tempscroll = Game->LoadMapData(16, 0x0F);
		CopyTileBlock(32270, 32378, 32260);
		int oldscrn = Game->GetCurScreen();
		StarfallShoalsUpdateBackupBitmaps(l4temp, l4tempscroll);
		while(true){
			if(oldscrn!=Game->GetCurScreen())
				StarfallShoalsUpdateBackupBitmaps(l4temp, l4tempscroll);
			oldscrn = Game->GetCurScreen();
			if(Link->Action==LA_SWIMMING||Link->Action==LA_DIVING){
				G[G_STEPMOD] -= 0.2;
			}
			Waitdraw();
			if(Link->Action==LA_SCROLLING&&Game->Scrolling[SCROLL_DIR]>-1){
				mapdata l0 = Game->LoadTempScreen(0);
				mapdata l1 = Game->LoadTempScreen(1);
				mapdata l4 = Game->LoadTempScreen(4);
				if(G[G_SCREENCHANGEDSCROLLING]||G[G_ANIM]%10==0)
					StarfallShoalsBitmap(GBMP[BMP_SHALLOWS], l0, l1, l4temp, 0, 0);
				
				l0 = Game->LoadScrollingScreen(0);
				l1 = Game->LoadScrollingScreen(1);
				l4 = Game->LoadScrollingScreen(4);
				if(G[G_SCREENCHANGEDSCROLLING]||G[G_ANIM]%10==0)
					StarfallShoalsBitmap(GBMP[BMP_SHALLOWS2], l0, l1, l4tempscroll, 0, 0);
				
				GBMP[BMP_SHALLOWS]->Blit(1, RT_SCREEN, 0, 0, 256, 176, Game->Scrolling[SCROLL_NX], Game->Scrolling[SCROLL_NY], 256, 176, 0, 0, 0, 0, 0, true);
				GBMP[BMP_SHALLOWS2]->Blit(1, RT_SCREEN, 0, 0, 256, 176, Game->Scrolling[SCROLL_OX], Game->Scrolling[SCROLL_OY], 256, 176, 0, 0, 0, 0, 0, true);
			}
			else{
				mapdata l0 = Game->LoadTempScreen(0);
				mapdata l1 = Game->LoadTempScreen(1);
				mapdata l4 = Game->LoadTempScreen(4);
				if(!G[G_SCREENCHANGEDSCROLLING]||G[G_ANIM]%10==0)
					StarfallShoalsBitmap(GBMP[BMP_SHALLOWS], l0, l1, l4temp, 0, 0);
				GBMP[BMP_SHALLOWS]->Blit(1, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
			}
			Waitframe();
		}
	}
}

dmapdata script L3TimePassage{
	void run(){
		InitBitmaps();
		int bgX;
		int bgY;
		
		int tH = Floor(G[G_L3TARGETTIME]/3600); //G[G_L3HOURS];
		int tM = Floor(G[G_L3TARGETTIME]/60)%60; //G[G_L3MINUTES];
		int tS = G[G_L3TARGETTIME]%60; //G[G_L3SECONDS];
		int h = G[G_L3HOURS];
		int m = G[G_L3MINUTES];
		int s = G[G_L3SECONDS];
		
		GBMP[BMP_BACKGROUNDLAYER]->Clear(0);
		for(int i=0; i<4; ++i){
			GBMP[BMP_BACKGROUNDLAYER]->DrawLayer(0, 24, 0x84+i, 0, 512*i+0, 0, 0, 128);
			GBMP[BMP_BACKGROUNDLAYER]->DrawLayer(0, 24, 0x84+i, 0, 512*i+256, 0, 0, 128);
			GBMP[BMP_BACKGROUNDLAYER]->DrawLayer(0, 24, 0x84+i, 0, 512*i+0, 176, 0, 128);
			GBMP[BMP_BACKGROUNDLAYER]->DrawLayer(0, 24, 0x84+i, 0, 512*i+256, 176, 0, 128);
		}
		while(true){
			bgX += VectorX(0.5, 30);
			bgY += VectorY(0.5, 30);
			if(bgX<0)
				bgX += 256;
			else if(bgX>=256)
				bgX -= 256;
			if(bgY<0)
				bgY += 176;
			else if(bgY>=176)
				bgY -= 176;
			int x = Floor(bgX)%256;
			int y = Floor(bgY)%176;
			int xoff = 512*3;
			int timediff = DayNight_GetTimeDifference(h, m, s, 0, 0, 0);
			if(Abs(timediff)<18000){
				xoff = 512*2;
				if(Abs(timediff)<10800){
					xoff = 0;
				}
				else if(Abs(timediff)<14400){
					xoff = 512;
				}
			}
			if(Game->GetCurDMap()==70||Game->GetCurDMap()==71||Game->GetCurDMap()==66)
				xoff = 512*3;
			GBMP[BMP_BACKGROUNDLAYER]->Blit(3, RT_SCREEN, x+xoff, y, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
			// Screen->DrawLayer(3, layerMap, layerScrn, 0, x, y, 0, 128);
			// Screen->DrawLayer(3, layerMap, layerScrn, 0, x-256, y, 0, 128);
			// Screen->DrawLayer(3, layerMap, layerScrn, 0, x, y-176, 0, 128);
			// Screen->DrawLayer(3, layerMap, layerScrn, 0, x-256, y-176, 0, 128);
			
			// if(G[G_L3TIMEGEMDIR]!=0){
				// m += 5*G[G_L3TIMEGEMDIR];
				// tH = (Floor((h+3)/6)%4)*6;
			// }
			// else{
			if(G[G_L3TIMEFLOW]){
				m += 2;
			}
			else{
				if(G[G_L3TARGETTIME]>-1){
					tH = Floor(G[G_L3TARGETTIME]/3600);
					tM = Floor(G[G_L3TARGETTIME]/60)%60;
					tS = G[G_L3TARGETTIME]%60;
						
					if(DayNight_GetTimeDifference(h, m, s, tH, tM, tS)>600){
						m -= 10;
					}
					else if(DayNight_GetTimeDifference(h, m, s, tH, tM, tS)<-600){
						m += 10;
					}
					else{
						h = tH;
						m = tM;
						s = tS;
						G[G_L3TARGETTIME] = -1;
					}
				}
			}
			
			// }
			if(m>=60){
				m -= 60;
				++h;
			}
			else if(m<0){
				m += 60;
				--h;
			}
			if(h>=24){
				h -= 24;
			}
			else if(h<0){
				h += 24;
			}
			if(Game->GetCurDMap()==70||Game->GetCurDMap()==71||Game->GetCurDMap()==66){
				h = 0; 
				m = 0;
				s = 0;
			}
			G[G_L3HOURS] = h;
			G[G_L3MINUTES] = m;
			G[G_L3SECONDS] = s;
			G[G_OVERRIDEHOURS] = G[G_L3HOURS];
			G[G_OVERRIDEMINUTES] = G[G_L3MINUTES];
			G[G_OVERRIDESECONDS] = G[G_L3SECONDS];
			Waitframe();
		}
	}
}

const int SFX_SUBSCREEN_CHANGETAB = 1;

dmapdata script ScriptedSubscreen{
	const int TAB_ACTIVE = 0;
	const int TAB_AUGMENT = 1;
	const int TAB_MAP = 2;
	const int TAB_LORE = 3;
	const int TAB_ALTCHARACTIVE = 8;
	
	enum MiscBtn{
		MBTN_PARTYCHAT = 0,
		MBTN_BESTIARY = 1,
		MBTN_LOCATIONS = 2,
		MBTN_QUESTLOG = 3,
		MBTN_RETURNTOSHIP = 4
	};
		
	void UpdateMenuInputBuffer(int inputBuf){
		const int MAXDELAY = 16;
		const int MINDELAY = 4;
		
		if(Link->InputUp)
			++inputBuf[0];
		else{
			inputBuf[0] = 0;
			inputBuf[4] = MAXDELAY;
		}
		if(Link->InputDown)
			++inputBuf[1];
		else{
			inputBuf[1] = 0;
			inputBuf[5] = MAXDELAY;
		}
		if(Link->InputLeft)
			++inputBuf[2];
		else{
			inputBuf[2] = 0;
			inputBuf[6] = MAXDELAY;
		}
		if(Link->InputRight)
			++inputBuf[3];
		else{
			inputBuf[3] = 0;
			inputBuf[7] = MAXDELAY;
		}
		
		inputBuf[8] = 0;
		inputBuf[9] = 0;
		inputBuf[10] = 0;
		inputBuf[11] = 0;
		if(inputBuf[0]>=inputBuf[4]){
			inputBuf[0] = 0;
			inputBuf[4] = Max(inputBuf[4]-1, MINDELAY);
			inputBuf[8] = 1;
		}
		if(inputBuf[1]>=inputBuf[5]){
			inputBuf[1] = 0;
			inputBuf[5] = Max(inputBuf[5]-1, MINDELAY);
			inputBuf[9] = 1;
		}
		if(inputBuf[2]>=inputBuf[6]){
			inputBuf[2] = 0;
			inputBuf[6] = Max(inputBuf[6]-1, MINDELAY);
			inputBuf[10] = 1;
		}
		if(inputBuf[3]>=inputBuf[7]){
			inputBuf[3] = 0;
			inputBuf[7] = Max(inputBuf[7]-1, MINDELAY);
			inputBuf[11] = 1;
		}
	}
	bool PressUp(int inputBuf){ return inputBuf[8]||Link->PressUp; }
	bool PressDown(int inputBuf){ return inputBuf[9]||Link->PressDown; }
	bool PressLeft(int inputBuf){ return inputBuf[10]||Link->PressLeft; }
	bool PressRight(int inputBuf){ return inputBuf[11]||Link->PressRight; }
	void SetMainSubItem(int iData, int spacing, int pos, int id, int x, int y, int up, int down, int left, int right){
		int iID = iData[0];
		int iX = iData[1];
		int iY = iData[2];
		int iUp = iData[3];
		int iDown = iData[4];
		int iLeft = iData[5];
		int iRight = iData[6];
		
		int x2 = spacing[0]*x;
		int y2 = spacing[1]*y;
		
		iID[pos] = id;
		iX[pos] = x2;
		iY[pos] = y2;
		iUp[pos] = up;
		iDown[pos] = down;
		iLeft[pos] = left;
		iRight[pos] = right;
	}
	void UpdateItemArrays(int data, int spacing){
		int iData = data[7];
		untyped dataAug = data[8];
		
		int iID = iData[0];
		int iIDAug = dataAug[0];
		
		if(GetCharID()>=CHAR_SOREN&&!G[G_RANDOMIZERENABLED]){
			if(GetCharID()==CHAR_SOREN){
				//                             INDEX,    ITEM,   X,Y,    Up,   Down, Left, Right
				SetMainSubItem(iData, spacing, 0,        5,      0,0,    0,    0,    2,    1);
				SetMainSubItem(iData, spacing, 1,        215,    1,0,    1,    1,    0,    2);
				SetMainSubItem(iData, spacing, 2,        216,    2,0,    2,    2,    1,    0);
			}
			else if(GetCharID()==CHAR_TERRY){
				//                             INDEX,    ITEM,   X,Y,    Up,   Down, Left, Right
				SetMainSubItem(iData, spacing, 0,        156,    0,0,    0,    0,    2,    1);
				SetMainSubItem(iData, spacing, 1,        217,    1,0,    1,    1,    0,    2);
				SetMainSubItem(iData, spacing, 2,        165,    2,0,    2,    2,    1,    0);
			}
			else if(GetCharID()==CHAR_SIYED){
				//                             INDEX,    ITEM,   X,Y,    Up,   Down, Left, Right
				SetMainSubItem(iData, spacing, 0,        157,    0,0,    0,    0,    2,    1);
				SetMainSubItem(iData, spacing, 1,        218,     1,0,    1,    1,    0,    2);
				SetMainSubItem(iData, spacing, 2,        219,     2,0,    2,    2,    1,    0);
			}
			return;
		}
		switch(GetCharID()){
			case CHAR_ASHER:
				iID[0] = 5;
				if(Link->Item[6]) //L2 Sword
					iID[0] = 6;
				iID[1] = 170;
				iID[2] = 171;
				iID[3] = 172;
					
				iIDAug[5] = 188;
				iIDAug[6] = 189;
				iIDAug[7] = 190;
				iIDAug[8] = 191;
				iIDAug[9] = 192;
				break;
			case CHAR_TORRIN:
				iID[0] = 156;
				if(Link->Item[162]) //L2 Sword
					iID[0] = 162;
					
				iID[1] = 164;
				iID[2] = 165;
				iID[3] = 166;
				
				iIDAug[5] = 193;
				iIDAug[6] = 194;
				iIDAug[7] = 195;
				iIDAug[8] = 196;
				iIDAug[9] = 197;
				break;
			case CHAR_KAYLANI:
				iID[0] = 157;
				if(Link->Item[163]) //L2 Sword
					iID[0] = 163;
				iID[1] = 167;
				iID[2] = 168;
				iID[3] = 169;
				
				iIDAug[5] = 198;
				iIDAug[6] = 199;
				iIDAug[7] = 200;
				iIDAug[8] = 201;
				iIDAug[9] = 202;
				break;
			case CHAR_SOREN:
				iID[0] = 5;
				if(Link->Item[50])
					iID[0] = 50;
				
				iID[1] = 215;
				iID[2] = 216;
				iID[3] = 108;
				
				iIDAug[5] = 227;
				iIDAug[6] = 228;
				iIDAug[7] = 229;
				iIDAug[8] = 230;
				iIDAug[9] = 231;
				break;
			case CHAR_TERRY:
				iID[0] = 156;
				if(Link->Item[63])
					iID[0] = 63;
				
				iID[1] = 217;
				iID[2] = 55;
				iID[3] = 88;
				
				iIDAug[5] = 232;
				iIDAug[6] = 233;
				iIDAug[7] = 234;
				iIDAug[8] = 235;
				iIDAug[9] = 236;
				break;
			case CHAR_SIYED:
				iID[0] = 157;
				if(Link->Item[143])
					iID[0] = 143;
				
				iID[1] = 218;
				iID[2] = 219;
				iID[3] = 226;
				
				iIDAug[5] = 237;
				iIDAug[6] = 238;
				iIDAug[7] = 239;
				iIDAug[8] = 240;
				iIDAug[9] = 241;
				break;
		}
		if(Link->Item[146])
			iID[7] = 146;
		if(Link->Item[30])
			iID[4] = 30;
	}
	void DrawItem(int layer, int x, int y, int itemID, int itemAnim, bool itemDidAnim){
		itemdata id = Game->LoadItemData(itemID);
		
		int frame;
		int totalframes = (id->ASpeed+1)*id->Delay+(id->ASpeed+1)*id->AFrames;
		if(totalframes){
			if(!itemDidAnim[itemID]){
				++itemAnim[itemID];
				itemDidAnim[itemID] = true;
			}
			itemAnim[itemID] %= totalframes;
			if(itemAnim[itemID]>=(id->ASpeed+1)*id->Delay&&id->AFrames>1){
				frame = Floor((itemAnim[itemID]-((id->ASpeed+1)*id->Delay))/(id->ASpeed+1));
			}
		}
		Screen->FastTile(layer, x, y, id->Tile+frame, id->CSet, 128);
	}
	int GetTempAugments(int equippedAugments, int whichChar){
		switch(whichChar){
			case CHAR_ASHER:
				equippedAugments[0] = G[G_ASHERAUGMENT1];
				equippedAugments[1] = G[G_ASHERAUGMENT2];
				equippedAugments[2] = G[G_ASHERAUGMENT3];
				return Game->Counter[CR_ASHERAUGMENTSLOTS];
			case CHAR_TORRIN:
				equippedAugments[0] = G[G_TORRINAUGMENT1];
				equippedAugments[1] = G[G_TORRINAUGMENT2];
				equippedAugments[2] = G[G_TORRINAUGMENT3];
				return Game->Counter[CR_TORRINAUGMENTSLOTS];
			case CHAR_KAYLANI:
				equippedAugments[0] = G[G_KAYLANIAUGMENT1];
				equippedAugments[1] = G[G_KAYLANIAUGMENT2];
				equippedAugments[2] = G[G_KAYLANIAUGMENT3];
				return Game->Counter[CR_KAYLANIAUGMENTSLOTS];
			case CHAR_SOREN:
				equippedAugments[0] = G[G_SORENAUGMENT1];
				equippedAugments[1] = G[G_SORENAUGMENT2];
				equippedAugments[2] = G[G_SORENAUGMENT3];
				return Game->Counter[CR_SORENAUGMENTSLOTS];
			case CHAR_TERRY:
				equippedAugments[0] = G[G_TERRYAUGMENT1];
				equippedAugments[1] = G[G_TERRYAUGMENT2];
				equippedAugments[2] = G[G_TERRYAUGMENT3];
				return Game->Counter[CR_TERRYAUGMENTSLOTS];
			case CHAR_SIYED:
				equippedAugments[0] = G[G_SIYEDAUGMENT1];
				equippedAugments[1] = G[G_SIYEDAUGMENT2];
				equippedAugments[2] = G[G_SIYEDAUGMENT3];
				return Game->Counter[CR_SIYEDAUGMENTSLOTS];
		}
	}
	void AssignTempAugments(int equippedAugments, int whichChar){
		switch(whichChar){
			case CHAR_ASHER:
				G[G_ASHERAUGMENT1] = equippedAugments[0];
				G[G_ASHERAUGMENT2] = equippedAugments[1];
				G[G_ASHERAUGMENT3] = equippedAugments[2];
				break;
			case CHAR_TORRIN:
				G[G_TORRINAUGMENT1] = equippedAugments[0];
				G[G_TORRINAUGMENT2] = equippedAugments[1];
				G[G_TORRINAUGMENT3] = equippedAugments[2];
				break;
			case CHAR_KAYLANI:
				G[G_KAYLANIAUGMENT1] = equippedAugments[0];
				G[G_KAYLANIAUGMENT2] = equippedAugments[1];
				G[G_KAYLANIAUGMENT3] = equippedAugments[2];
				break;
			case CHAR_SOREN:
				G[G_SORENAUGMENT1] = equippedAugments[0];
				G[G_SORENAUGMENT2] = equippedAugments[1];
				G[G_SORENAUGMENT3] = equippedAugments[2];
				break;
			case CHAR_TERRY:
				G[G_TERRYAUGMENT1] = equippedAugments[0];
				G[G_TERRYAUGMENT2] = equippedAugments[1];
				G[G_TERRYAUGMENT3] = equippedAugments[2];
				break;
			case CHAR_SIYED:
				G[G_SIYEDAUGMENT1] = equippedAugments[0];
				G[G_SIYEDAUGMENT2] = equippedAugments[1];
				G[G_SIYEDAUGMENT3] = equippedAugments[2];
				break;
		}
	}
	enum{
		AUG_TOGGLE,
		AUG_EQUIP,
		AUG_UNEQUIP
	};
	void EquipAugment(int itemID, int equippedAugments, int numAugmentSlots, int defaultSlot, int onlyEquip){
		numAugmentSlots = Max(1, numAugmentSlots);
		
		int numEquipped;
		if(equippedAugments[0])
			++numEquipped;
		if(equippedAugments[1])
			++numEquipped;
		if(equippedAugments[2])
			++numEquipped;
		
		if(equippedAugments[0]==itemID){ //Unequip Item 1
			if(onlyEquip!=AUG_EQUIP)
				equippedAugments[0] = 0;
		}
		else if(equippedAugments[1]==itemID){ //Unequip Item 2
			if(onlyEquip!=AUG_EQUIP)
				equippedAugments[1] = 0;
		}
		else if(equippedAugments[2]==itemID){ //Unequip Item 3
			if(onlyEquip!=AUG_EQUIP)
				equippedAugments[2] = 0;
		}
		else if(onlyEquip!=AUG_UNEQUIP){
			if(numEquipped>=numAugmentSlots){ //All slots filled
				if(defaultSlot<numAugmentSlots) //Replace item based on button
					equippedAugments[defaultSlot] = itemID;
				else //Replace item 0 (invalid button)
					equippedAugments[0] = itemID;
			}
			else{ //Find free slot
				for(int i=0; i<numAugmentSlots; ++i){
					if(equippedAugments[i]==0){
						equippedAugments[i] = itemID;
						break;
					}
				}
			}
		}
	}
	void EquipAugmentAll(int itemID, int equippedAugments, int numAugmentSlots, int defaultSlot){
		int toggle = AUG_EQUIP;
		if(equippedAugments[0]==itemID)
			toggle = AUG_UNEQUIP;
		if(equippedAugments[1]==itemID)
			toggle = AUG_UNEQUIP;
		if(equippedAugments[2]==itemID)
			toggle = AUG_UNEQUIP;
		
		int backupAugments[3];
		int backupNumAugmentSlots = numAugmentSlots;
		for(int i=0; i<3; ++i){
			backupAugments[i] = equippedAugments[i];
		}
		for(int i=0; i<6; ++i){
			if(i!=GetCharID()){
				numAugmentSlots = GetTempAugments(equippedAugments, i);
				EquipAugment(itemID, equippedAugments, numAugmentSlots, defaultSlot, toggle);
				AssignTempAugments(equippedAugments, i);
			}
		}
		for(int i=0; i<3; ++i){
			equippedAugments[i] = backupAugments[i];
		}
		numAugmentSlots = backupNumAugmentSlots;
		EquipAugment(itemID, equippedAugments, numAugmentSlots, defaultSlot, toggle);
		AssignTempAugments(equippedAugments, GetCharID());
	}
	void GetDescriptionString(int itemID, int strbuf){
		if(itemID==0||!Link->Item[itemID]){
			CopyStringToBuffer(strbuf, "@84???@01@N Unknown augment.");
			return;
		}
		switch(itemID){
			case 183:
				CopyStringToBuffer(strbuf, "@84Tri Lantern@01@N Lantern shoots three fires.");
				break;
			case 184:
				CopyStringToBuffer(strbuf, "@84Short Fuse@01@N Bombs explode shortly after hitting the ground.");
				break;
			case 185:
				CopyStringToBuffer(strbuf, "@84Magnet+@01@N Tidal Gauntlet moves you slower and enemies faster.");
				break;
			case 186:
				CopyStringToBuffer(strbuf, "@84Stellar Wand+@01@N The wand's projectile speed and damage increase.");
				break;
			case 187:
				CopyStringToBuffer(strbuf, "@84Speed+@01@N Slight increase to step speed.");
				break;
			case 188:
				CopyStringToBuffer(strbuf, "@84Dash Length+@01@N Increases the length of dash.");
				break;
			case 189:
				CopyStringToBuffer(strbuf, "@84Dash Counter+@01@N Slightly increases the window of dash counter.");
				break;
			case 190:
				CopyStringToBuffer(strbuf, "@84Stellar Greatsword@01@N Increases the range and damage of Stellar Sword. Press the button again for a second swing.");
				break;
			case 191:
				CopyStringToBuffer(strbuf, "@84Minior@01@N Stellaire drops smaller meteorites but can be used anywhere.");
				break;
			case 192:
				CopyStringToBuffer(strbuf, "@84Reflect+@01@N Silver Sword duplicates projectiles it reflects.");
				break;
			case 193:
				CopyStringToBuffer(strbuf, "@84Thrown Punches@01@N Punches create a short ranged projectile in front of them.");
				break;
			case 194:
				CopyStringToBuffer(strbuf, "@84Auto Lock@01@N Automatically lock onto the closest enemy on a whiffed punch.");
				break;
			case 195:
				CopyStringToBuffer(strbuf, "@84Alt Solar Battery@01@N Solar battery creates a stationary sunball.");
				break;
			case 196:
				CopyStringToBuffer(strbuf, "@84Alt Lunar Battery@01@N Lunar battery creates a stream of lunar cutters.");
				break;
			case 197:
				CopyStringToBuffer(strbuf, "@84Alt Stellar Battery@01@N Stellar battery drops a rain of targetted arrows that spreads to nearby enemies.");
				break;
			case 198:
				CopyStringToBuffer(strbuf, "@84Range+@01@N Solar Ball and Solar System have increased range.");
				break;
			case 199:
				CopyStringToBuffer(strbuf, "@84Charge Time+@01@N Solar Ball and Solar System have reduced charge time.");
				break;
			case 200:
				CopyStringToBuffer(strbuf, "@84Safe Charge@01@N Solar System no longer breaks on overcharge.");
				break;
			case 201:
				CopyStringToBuffer(strbuf, "@84Wide Mirage@01@N Sun Dog gains two extra hitboxes.");
				break;
			case 202:
				CopyStringToBuffer(strbuf, "@84Targetted Flare@01@N Solar Flare gains slight auto targetting on the current target.");
				break;
			case 227:
				CopyStringToBuffer(strbuf, "@84Flash Charge@01@N The timing window for Engine Cleaver becomes tighter, but it fully charges in one hit.");
				break;
			case 228:
				CopyStringToBuffer(strbuf, "@84Lingering Flame@01@N Engine Cleaver's flames can double hit.");
				break;
			case 229:
				CopyStringToBuffer(strbuf, "@84Slashing Sparks@01@N Sparking Slash shoots spark projectiles during the slash.");
				break;
			case 230:
				CopyStringToBuffer(strbuf, "@84Responsible Ricochet@01@N Reckless Ricochet no longer deals self damage.");
				break;
			case 231:
				CopyStringToBuffer(strbuf, "@84Crippling Hook@01@N Enemies being pulled by Grappling Hook will take 1.5x damage.");
				break;
			case 232:
				CopyStringToBuffer(strbuf, "@84Hadouken@01@N Punches will shoot a projectile at full HP.");
				break;
			case 233:
				CopyStringToBuffer(strbuf, "@84Dire Drops@01@N Enemies will drop batteries when you're low.");
				break;
			case 234:
				CopyStringToBuffer(strbuf, "@84Alt Solar Battery@01@N Solar battery becomes a chasing projectile.");
				break;
			case 235:
				CopyStringToBuffer(strbuf, "@84Alt Lunar Battery@01@N Lunar battery becomes a claw attack.");
				break;
			case 236:
				CopyStringToBuffer(strbuf, "@84Alt Stellar Battery@01@N Stellar battery becomes a projectile that knocks back enemies.");
				break;
			case 237:
				CopyStringToBuffer(strbuf, "@84Range+@01@N Solar Ball has increased range.");
				break;
			case 238:
				CopyStringToBuffer(strbuf, "@84Diagonal Heat@01@N Allows Heatwave to fire at a diagonal.");
				break;
			case 239:
				CopyStringToBuffer(strbuf, "@84Updraft@01@N Gives heatwave a trail behind it that lets you move faster while moving through it.");
				break;
			case 240:
				CopyStringToBuffer(strbuf, "@84Concentration+@01@N Makes Concentration's lens turn to the direction you're facing.");
				break;
			case 241:
				CopyStringToBuffer(strbuf, "@84Orbit+@01@N Unstable orbit gains two extra projectiles.");
				break;
		}
	}
	void GetItemName(int itemID, int strbuf){
		if(itemID==0||(!Link->Item[itemID]&&!FoundItems[itemID])){
			CopyStringToBuffer(strbuf, "???");
			return;
		}
		switch(itemID){
			case 5:
				CopyStringToBuffer(strbuf, "Sword");
				break;
			case 6:
				CopyStringToBuffer(strbuf, "Silver Sword");
				break;
			case 50:
				CopyStringToBuffer(strbuf, "Engine Cleaver");
				break;
			case 156:
				CopyStringToBuffer(strbuf, "Brawler");
				break;
			case 162:
				CopyStringToBuffer(strbuf, "Black Belt");
				break;
			case 63:
				CopyStringToBuffer(strbuf, "Black Belt 2: Terry Boogaloo");
				break;
			case 157:
				CopyStringToBuffer(strbuf, "Solar Ball");
				break;
			case 163:
				CopyStringToBuffer(strbuf, "Solar Might");
				break;
			case 143:
				CopyStringToBuffer(strbuf, "Solar Surge");
				break;
			case 11:
				CopyStringToBuffer(strbuf, "Lantern");
				break;
			case 144:
				CopyStringToBuffer(strbuf, "Lobber Bomb");
				break;
			case 108:
				CopyStringToBuffer(strbuf, "Grappling Hook");
				break;
			case 145:
			case 146:
				CopyStringToBuffer(strbuf, "Tidal Gauntlet");
				break;
			case 25:
				CopyStringToBuffer(strbuf, "Stellar Wand");
				break;
			case 170:
				CopyStringToBuffer(strbuf, "Dash");
				break;
			case 171:
				if(HasAugment(I_AUGMENT_STELLARSWORD))
					CopyStringToBuffer(strbuf, "Stellar Greatsword");
				else
					CopyStringToBuffer(strbuf, "Stellar Sword");
				break;
			case 172:
				if(HasAugment(I_AUGMENT_MINIOR))
					CopyStringToBuffer(strbuf, "Minior");
				else
					CopyStringToBuffer(strbuf, "Stellaire");
				break;
			case 164:
				CopyStringToBuffer(strbuf, "Fishing Rod");
				break;
			case 165:
				switch(G[G_EQUIPPEDBATTERYTYPE]){
					case 0:
						if(HasAugment(I_AUGMENT_ALTBATTERYSOLAR)||GetCharID()==CHAR_TERRY)
							CopyStringToBuffer(strbuf, "Battery (Sunburst)");
						else
							CopyStringToBuffer(strbuf, "Battery (Sunstream)");
						break;
					case 1:
						if(HasAugment(I_AUGMENT_ALTBATTERYLUNAR)||GetCharID()==CHAR_TERRY)
							CopyStringToBuffer(strbuf, "Battery (Phase Cutter)");
						else
							CopyStringToBuffer(strbuf, "Battery (Telekinesis)");
						break;
					case 2:
						if(HasAugment(I_AUGMENT_ALTBATTERYSTELLAR)||GetCharID()==CHAR_TERRY)
							CopyStringToBuffer(strbuf, "Battery (Stellar Rain)");
						else
							CopyStringToBuffer(strbuf, "Battery (Starswell)");
						break;
				}
				break;
			case 55:
				switch(G[G_EQUIPPEDBATTERYTYPETERRY]){
					case 0:
						if(HasAugment(I_AUGMENT_ALTBATTERYSOLARTERRY))
							CopyStringToBuffer(strbuf, "Battery (Sun Chaser)");
						else
							CopyStringToBuffer(strbuf, "Battery (Flash)");
						break;
					case 1:
						if(HasAugment(I_AUGMENT_ALTBATTERYLUNARTERRY))
							CopyStringToBuffer(strbuf, "Battery (Claw)");
						else
							CopyStringToBuffer(strbuf, "Battery (Force Punch)");
						break;
					case 2:
						if(HasAugment(I_AUGMENT_ALTBATTERYSTELLARTERRY))
							CopyStringToBuffer(strbuf, "Battery (Starshock)");
						else
							CopyStringToBuffer(strbuf, "Battery (Plasma Thorns)");
						break;
				}
				break;
			case 166:
				CopyStringToBuffer(strbuf, "Magic Trap");
				break;
			case 88:
				CopyStringToBuffer(strbuf, "Bloodmoon Gauntlet");
				break;
			case 167:
				CopyStringToBuffer(strbuf, "Solar System");
				break;
			case 168:
				CopyStringToBuffer(strbuf, "Sun Dog");
				break;
			case 169:
				CopyStringToBuffer(strbuf, "Solar Flare");
				break;
				
			case 215:
				CopyStringToBuffer(strbuf, "Sparking Slash");
				break;
			case 216:
				CopyStringToBuffer(strbuf, "Reckless Ricochet");
				break;
			case 217:
				CopyStringToBuffer(strbuf, "Just Straight Up Robbery");
				break;
			case 218:
				CopyStringToBuffer(strbuf, "Heatwave");
				break;
			case 219:
				CopyStringToBuffer(strbuf, "Concentration");
				break;
			case 226:
				CopyStringToBuffer(strbuf, "Unstable Orbit");
				break;
				
			case 29:
				CopyStringToBuffer(strbuf, "Revival Potion");
				break;
			case 30:
				CopyStringToBuffer(strbuf, "Regeneration Potion");
				break;
			case 24:
				CopyStringToBuffer(strbuf, "Lunarang");
				break;
				
			//Passives
			case 8:
				CopyStringToBuffer(strbuf, "Iron Shield");
				break;
			case 178:
				CopyStringToBuffer(strbuf, "Starstone");
				break;
			case 182:
				CopyStringToBuffer(strbuf, "Dash Counter");
				break;
			case 208:
				CopyStringToBuffer(strbuf, "Lock-On Punch");
				break;
			
		}
	}
	void GetBestiaryData(int enemyList){
		int npcID = enemyList[G[G_SUBSCREENSEL_BESTIARY]];
		if(LoreTracking[LT_ENEMIES+npcID]==1)
			LoreTracking[LT_ENEMIES+npcID] = 2;
		npcdata npcd = Game->LoadNPCData(npcID);
		BestiaryTiles(npcID);
		BestiaryDefenses(npcID);
		G[G_BESTIARY_ENEMYHP] = npcd->HP;
		if(npcID==236)
			G[G_BESTIARY_ENEMYHP] = -1;
		if(npcID==251){
			if(G[G_CHASEDIFF] == 0)
				G[G_BESTIARY_ENEMYHP] = 40000;
			if(G[G_CHASEDIFF] == 1)
				G[G_BESTIARY_ENEMYHP] = 25000;
			if(G[G_CHASEDIFF] == 2)
				G[G_BESTIARY_ENEMYHP] = 12500;
		}
		G[G_BESTIARY_ENEMYDAMAGE] = npcd->TouchDamage;
		G[G_BESTIARY_ENEMYWDAMAGE] = npcd->WeaponDamage;
		
		if(npcID!=G[G_BESTIARY_ENEMYID]){
			int buf[2048];
			int descbuf[1024];
			BestiaryDescription(descbuf, npcID);
			if(G[G_BESTIARYRANDO]&&LoreTracking[LT_ENEMIESRANDO+npcID]){
				int itembuf[512];
				ItemName(itembuf, RandomizedItems[IL_BES_REDOCTO+G[G_SUBSCREENSEL_BESTIARY]]);
				sprintf(buf, "Had Item: %s@26@26%s", itembuf, descbuf);
			}
			else
				sprintf(buf, "%s", descbuf);
			Tango_ClearSlot(0);
			Tango_LoadString(0, buf);
			Tango_SetSlotStyle(0, STYLE_BESTIARY);
			Tango_SetSlotPosition(0, 13, 83);
			Tango_ActivateSlot(0);
			G[G_BESTIARY_TEXTPLAYING] = 1;
		}
		
		G[G_BESTIARY_ENEMYID] = npcID;
	}
	void GetLocationData(int areaList, int cycleDir){
		int locID = areaList[G[G_SUBSCREENSEL_LOCATION]];
		int size = SizeOfArray(areaList);
		for(int i=0; i<size&&(i==0||LoreTracking[LT_LOCATIONS+locID]==0); ++i){
			G[G_SUBSCREENSEL_LOCATION] += cycleDir;
			if(G[G_SUBSCREENSEL_LOCATION]>=size)
				G[G_SUBSCREENSEL_LOCATION] = 0;
			else if(G[G_SUBSCREENSEL_LOCATION]<0)
				G[G_SUBSCREENSEL_LOCATION] = size-1;
			locID = areaList[G[G_SUBSCREENSEL_LOCATION]];
		}
		
		int buf[1024];
		LocationDescription(buf, locID);
		Tango_ClearSlot(0);
		Tango_LoadString(0, buf);
		Tango_SetSlotStyle(0, STYLE_LOCATION);
		Tango_SetSlotPosition(0, 128, 40);
		Tango_ActivateSlot(0);
		G[G_BESTIARY_TEXTPLAYING] = 1;
		
		LocationScreenPreview(locID);
		GBMP[BMP_GENERIC]->Clear(0);
		GBMP[BMP_GENERIC]->DrawScreen(0, G[G_LOCATIONSUB_MAP], G[G_LOCATIONSUB_SCREEN], 0, 0, 0);
		if(G[G_LOCATIONSUB_FOGTILE])
			GBMP[BMP_GENERIC]->DrawTile(0, G[G_LOCATIONSUB_X], G[G_LOCATIONSUB_Y], G[G_LOCATIONSUB_FOGTILE], 7, 7, 4, -1, -1, 0, 0, 0, 0, true, 64);
		if(locID==LOC_JUNGLECAVE)
			GBMP[BMP_GENERIC]->FastCombo(0, 232, 24, 17816, 2, 128);
		if(LoreTracking[LT_LOCATIONS+locID]==1)
			LoreTracking[LT_LOCATIONS+locID] = 2;
	}
	void LoadRelevantLocation(int areaList){
		int size = SizeOfArray(areaList);
		for(int i=0; i<size; ++i){
			if(LoreTracking[LT_LOCATIONS+areaList[i]]==1){
				G[G_SUBSCREENSEL_LOCATION] = i;
				return;
			}
		}
		for(int i=0; i<size; ++i){
			if(DMapLocation(Game->GetCurDMap())==areaList[i]){
				G[G_SUBSCREENSEL_LOCATION] = i;
				return;
			}
		}
	}
	int CheckPlayerSwap(untyped data, int equippedAugments, int numAugmentSlots, int strDat){
		if(NumCharsAlive()<=1){
			return numAugmentSlots;
		}
		
		int dataAug = data[8];
		int spacing = data[9];
		int iIDAug = dataAug[0];
		int descbuffer = dataAug[6];
		
		int ret;
		int thisChar = GetCharID();
		bool swapped;
		if(Link->PressEx3){
			Game->PlaySound(21);
			SetCharacter(GetSwapCharID(thisChar, -1, false), false);
			ret = GetTempAugments(equippedAugments, GetCharID());
			UpdateItemArrays(data, spacing);
			UpdateHUDCopytiles();
			G[G_SUBSCREENCHARSWAPTIMER] = -4;
			if(G[G_SUBSCREENSEL_AUGMENT]>=5)
				swapped = true;
		}
		else if(Link->PressEx4){
			Game->PlaySound(21);
			SetCharacter(GetSwapCharID(thisChar, 1, false), false);
			ret = GetTempAugments(equippedAugments, GetCharID());
			UpdateItemArrays(data, spacing);
			UpdateHUDCopytiles();
			G[G_SUBSCREENCHARSWAPTIMER] = 4;
			if(G[G_SUBSCREENSEL_AUGMENT]>=5)
				swapped = true;
		}
		
		if(swapped){
			GetDescriptionString(iIDAug[G[G_SUBSCREENSEL_AUGMENT]], descbuffer);
			DrawStringSP_Prep(strDat, 144, FONT_Z3SMALL, descbuffer);
		}
		
		return ret;
	}
	void DrawCharSwap(bitmap b, untyped data, int xOff, int yOff){
		int spacing = data[9];
		if(NumCharsAlive()<=1){
			return;
		}
		
		int thisChar = GetCharID();
		
		int order[3] = {0, 2, 1};
		int til[3];
		til[1] = thisChar;
		til[0] = GetSwapCharID(thisChar, -1, false);
		til[2] = GetSwapCharID(thisChar, 1, false);
		for(int i=0; i<3; ++i){
			int j = order[i];
			int x = 120+(j-1)*4+G[G_SUBSCREENCHARSWAPTIMER];
			int y = 13;
			if(Abs(x-120)<=4)
				b->FastTile(0, x+xOff, y+yOff, 64720+til[j], 0, 128);
		}
		b->DrawTile(0, 112-16+xOff, 13+yOff, 64736, 2, 1, 0, -1, -1, 0, 0, 0, 0, true, 128);
		b->DrawTile(0, 112+16+xOff, 13+yOff, 64738, 2, 1, 0, -1, -1, 0, 0, 0, 0, true, 128);
		if(G[G_SUBSCREENCHARSWAPTIMER]<0)
			++G[G_SUBSCREENCHARSWAPTIMER];
		else if(G[G_SUBSCREENCHARSWAPTIMER]>0)
			--G[G_SUBSCREENCHARSWAPTIMER];
	}		
	void DrawBestiaryWeakness(bitmap b, int x, int y, int bitflags){
		const int PHYSICAL 	= 00000001b;
		const int FIRE 		= 00000010b;
		const int BOMB 		= 00000100b;
		const int SOLAR 	= 00001000b;
		const int LUNAR 	= 00010000b;
		const int STELLAR 	= 00100000b;
		const int GAUNTLET 	= 01000000b;
		
		if(bitflags==0){
			b->FastTile(0, x, y, 62640, 0, 128);
		}
		else{
			int xOff;
			if(bitflags&PHYSICAL){
				b->FastTile(0, x+xOff, y, 62645, 0, 128);
				xOff += 8;
			}
			if(bitflags&FIRE){
				b->FastTile(0, x+xOff, y, 62646, 0, 128);
				xOff += 8;
			}	
			if(bitflags&BOMB){
				b->FastTile(0, x+xOff, y, 62644, 0, 128);
				xOff += 8;
			}
			if(bitflags&SOLAR){
				b->FastTile(0, x+xOff, y, 62641, 0, 128);
				xOff += 8;
			}
			if(bitflags&LUNAR){
				b->FastTile(0, x+xOff, y, 62642, 0, 128);
				xOff += 8;
			}
			if(bitflags&STELLAR){
				b->FastTile(0, x+xOff, y, 62643, 0, 128);
				xOff += 8;
			}
			if(bitflags&GAUNTLET){
				b->FastTile(0, x+xOff, y, 62647, 0, 128);
				xOff += 8;
			}
		}
	}
	void DrawPassiveGarbage(untyped data){
		int itemAnim = data[3];
		bool itemDidAnim = data[4];
		for(int i=0; i<256; ++i)itemDidAnim[i] = false;
		
		int passiveY = -56;
		//Passive Garbage
		FastishTile(7, 175, 19+passiveY, 63556, 2, 2, 0, 128);
		FastishTile(7, 216, 19+passiveY, 63556, 2, 2, 0, 128);
		FastishTile(7, 158, 2+passiveY, 63556, 2, 2, 0, 128);
		FastishTile(7, 198, 2+passiveY, 63556, 2, 2, 0, 128);
		
		if(Link->ItemA>0)
			DrawItem(7, 183, 27+passiveY, Link->ItemA, itemAnim, itemDidAnim);
		if(Link->ItemB>0)
			DrawItem(7, 224, 27+passiveY, Link->ItemB, itemAnim, itemDidAnim);
		if(Link->ItemX>0)
			DrawItem(7, 165, 10+passiveY, Link->ItemX, itemAnim, itemDidAnim);
		if(Link->ItemY>0)
			DrawItem(7, 206, 10+passiveY, Link->ItemY, itemAnim, itemDidAnim);
		
		Screen->DrawString(7, 180, 40+passiveY, FONT_Z1, 0x01, -1, TF_NORMAL, "A", 128, SHD_OUTLINEDX, 0x0F);
		Screen->DrawString(7, 221, 40+passiveY, FONT_Z1, 0x01, -1, TF_NORMAL, "B", 128, SHD_OUTLINEDX, 0x0F);
		Screen->DrawString(7, 163, 23+passiveY, FONT_Z1, 0x01, -1, TF_NORMAL, "X", 128, SHD_OUTLINEDX, 0x0F);
		Screen->DrawString(7, 203, 23+passiveY, FONT_Z1, 0x01, -1, TF_NORMAL, "Y", 128, SHD_OUTLINEDX, 0x0F);
		
		Screen->Rectangle(7, 15, 11+passiveY, 15+82, 11+passiveY+9, 0xB3, 1, 0, 0, 0, true, 128);
		Screen->Rectangle(7, 12, 24+passiveY, 12+94, 24+passiveY+11, 0xB3, 1, 0, 0, 0, true, 128);
		for(int i=0; i<7; ++i)Screen->FastTile(7, 15+12*i, 10+passiveY, 912+i, 8, 128);
		Screen->DrawTile(7, 8, 24+passiveY, 931, 7, 1, 11, -1, -1, 0, 0, 0, 0, true, 128);
		
		Minimap_Update();
	}
	void Draw(int layer, int x, int y, untyped data, int timer, bool drawLR){
		int iID = data[0];
		int iX = data[1];
		int iY = data[2];
		int itemAnim = data[3];
		bool itemDidAnim = data[4];
		int passiveID = data[5];
		int randomizerChars = data[6];
		
		GBMP[BMP_SCRIPTEDSUBSCREEN]->Clear(0);
		
		//Frame
		GBMP[BMP_SCRIPTEDSUBSCREEN]->DrawTile(0, x, y, 62920, 16, 11, 0, -1, -1, 0, 0, 0, 0, true, 128);
		
		if(G[G_RANDOMIZERENABLED]){
			//Seed
			int seedStr[] = "SEED: xxxxxx";
			long seed = G[G_RANDOMIZERSEED];
			for(int i=0; i<6; ++i){
				int digit = (seed>>(i*4))&0xFL;
				digit /= 1L;
				if(digit>9)
					seedStr[11-i] = 'A'+(digit-10);
				else
					seedStr[11-i] = '0'+digit;
			}
			GBMP[BMP_SCRIPTEDSUBSCREEN]->DrawString(0, x+128, y+16, FONT_Z3SMALL, 0x01, -1, TF_CENTERED, seedStr, 128, SHD_OUTLINED8, 0x0F);
		
			int hymnstoneStr[16];
			sprintf(hymnstoneStr, "%d / %d", Game->Counter[CR_TOTALHYMNSTONES], G[G_RANDOMIZERMAXHYMNSTONES]);
			int xOff = (Text->StringWidth(hymnstoneStr, FONT_Z3SMALL))/2-6;
			
			GBMP[BMP_SCRIPTEDSUBSCREEN]->FastTile(0, x+128-xOff-12, y+24-2, 241, 7, 128);
			GBMP[BMP_SCRIPTEDSUBSCREEN]->DrawString(0, x+128-xOff, y+24, FONT_Z3SMALL, 0x01, -1, TF_NORMAL, hymnstoneStr, 128, SHD_OUTLINED8, 0x0F);
		}
		
		//Equipment menu
		GBMP[BMP_SCRIPTEDSUBSCREEN]->DrawString(0, x+46, y+47, FONT_SHERWOOD, 0x01, -1, TF_NORMAL, "Equipment", 128, SHD_OUTLINED8, 0x0F);
		GBMP[BMP_SCRIPTEDSUBSCREEN]->DrawTile(0, x+40, y+64, 62566, 6, 3, 0, -1, -1, 0, 0, 0, 0, true, 128);
		for(int i=0; i<10; ++i){
			if(G[G_SUBSCREENSEL]==i&&G[G_SUBSCREENSEL_ALTERNATE]==0)
				GBMP[BMP_SCRIPTEDSUBSCREEN]->FastTile(0, x+48+iX[i], y+72+iY[i], 553, 0, 128);
			if(iID[i]>0&&Link->Item[iID[i]]){
				itemdata id = Game->LoadItemData(iID[i]);
				
				int frame;
				int totalframes = (id->ASpeed+1)*id->Delay+(id->ASpeed+1)*id->AFrames;
				if(totalframes){
					if(!itemDidAnim[iID[i]])
						++itemAnim[iID[i]];
					itemAnim[iID[i]] %= totalframes;
					if(itemAnim[iID[i]]>=(id->ASpeed+1)*id->Delay&&id->AFrames>1){
						frame = Floor((itemAnim[iID[i]]-((id->ASpeed+1)*id->Delay))/(id->ASpeed+1));
					}
				}
				GBMP[BMP_SCRIPTEDSUBSCREEN]->FastTile(0, x+48+iX[i], y+72+iY[i], id->Tile+frame, id->CSet, 128);
				//GBMP[BMP_SCRIPTEDSUBSCREEN]->DrawInteger(0, x+iX[i], y+iY[i], FONT_Z3SMALL, 0x01, 0x0F, -1, -1, itemAnim[iID[i]], 0, 128);
			}
		}
		
		//Passive Equipables
		if(FoundItems[8]||FoundItems[182]||FoundItems[208]||FoundItems[178]){
			GBMP[BMP_SCRIPTEDSUBSCREEN]->DrawTile(0, x+48, y+121, 62880, 5, 2, 0, -1, -1, 0, 0, 0, 0, true, 128);
			int passiveTil[] = {65084, 65118, 65104, 65064};
			int passiveCS[]  = {11,    10,    8,     9};
			for(int i=0; i<4; ++i){
				if(G[G_SUBSCREENSEL_ALTERNATE]==2&&G[G_SUBSCREENSEL_PASSIVE]==i)
					GBMP[BMP_SCRIPTEDSUBSCREEN]->FastTile(0, x+56+16*i, y+125, 553, 0, 128);
				
				if(FoundItems[passiveID[i]]){
					GBMP[BMP_SCRIPTEDSUBSCREEN]->FastTile(0, x+56+16*i, y+125, passiveTil[i], passiveCS[i], 128);
					if(!Link->Item[passiveID[i]])
						GBMP[BMP_SCRIPTEDSUBSCREEN]->FastTile(0, x+56+16*i, y+125, passiveTil[i]+1, passiveCS[i], 64);
				}
			}
		}
		
		//Boss Key
		if(Game->LItems[Game->GetCurLevel()]&LI_BOSSKEY)
			GBMP[BMP_SCRIPTEDSUBSCREEN]->FastTile(0, x+30, y+125, 64019, 8, 128);
		
		int buf[128];
		if(G[G_SUBSCREENSEL_ALTERNATE]!=1){
			if(G[G_SUBSCREENSEL_ALTERNATE]==0)
				GetItemName(iID[G[G_SUBSCREENSEL]], buf);
			else if(G[G_SUBSCREENSEL_ALTERNATE]==2)
				GetItemName(passiveID[G[G_SUBSCREENSEL_PASSIVE]], buf);
			GBMP[BMP_SCRIPTEDSUBSCREEN]->DrawString(0, x+88, y+114, FONT_Z3SMALL, 0x01, -1, TF_CENTERED, buf, 128, SHD_OUTLINED8, 0x0F);
		}
		
		//Party menu
		GBMP[BMP_SCRIPTEDSUBSCREEN]->DrawString(0, x+155, y+47, FONT_SHERWOOD, 0x01, -1, TF_NORMAL, "Party", 128, SHD_OUTLINED8, 0x0F);
		GBMP[BMP_SCRIPTEDSUBSCREEN]->DrawTile(0, x+144, y+64, 62665, 4, 3, 0, -1, -1, 0, 0, 0, 0, true, 128);
		if(G[G_RANDOMIZERENABLED]){
			int spacing = 17;
			int lineCount = 3;
			int offsets[2] = {0, 0};
			if(randomizerChars[6]==4){
				spacing = 17;
				lineCount = 2;
				offsets[0] = 9;
				offsets[1] = 9;
			}
			else if(randomizerChars[6]==5){
				offsets[0] = 0;
				offsets[1] = 9;
			}
			for(int i=0; i<randomizerChars[6]; ++i){
				int charX = x+151+spacing*(i%lineCount)+offsets[Floor(i/lineCount)];
				int charY = y+72+17*Floor(i/lineCount);
				if(randomizerChars[6]==3)
					charY += 8;
				int layer = 0;
				if(G[G_SUBSCREENSEL_CHARSWAP]==i)
					GBMP[BMP_SCRIPTEDSUBSCREEN]->FastTile(layer, charX, charY, 553, 0, 128);
				if(HasChar(randomizerChars[i])){
					if(randomizerChars[i]==GetCharID()){
						layer = 1;
						charY -= 2;
					}
					GBMP[BMP_SCRIPTEDSUBSCREEN]->FastTile(layer, charX, charY, 104240+randomizerChars[i], 0, 128);
					if(!CharAlive(randomizerChars[i]))
						GBMP[BMP_SCRIPTEDSUBSCREEN]->FastTile(2, charX, charY, 104253, 0, 128);
					if(randomizerChars[i]!=GetCharID()){
						GBMP[BMP_SCRIPTEDSUBSCREEN]->FastTile(0, charX, charY, 104246+randomizerChars[i], 0, 64);
					}
				}
				else{
					GBMP[BMP_SCRIPTEDSUBSCREEN]->FastTile(0, charX, charY, 104252, 0, 128);
				}
			}
		}
		else{
			for(int i=0; i<3; ++i){
				if(G[G_SUBSCREENSEL_ALTERNATE]==1&&G[G_SUBSCREENSEL_CHARSWAP]==i)
					GBMP[BMP_SCRIPTEDSUBSCREEN]->DrawTile(0, x+151+17*i, y+64, 658, 1, 2, 0, -1, -1, 0, 0, 0, 0, true, 128);
				GBMP[BMP_SCRIPTEDSUBSCREEN]->DrawTile(0, x+151+17*i, y+64, 104173, 1, 3, 0, -1, -1, 0, 0, 0, 0, true, 128);
				if(HasChar(i)){
					int playerTil = 104120;
					if(i==1)
						playerTil = 104160;
					else if(i==2)
						playerTil = 104200;
					int aframe = 0;
					if(i==GetCharID()){
						aframe = Floor((timer[0]%48)/12);
						if(aframe==2)
							aframe = 0;
						else if(aframe==3)
							aframe = 2;
					}
					if(!CharAlive(i)&&G[G_ASHERINCINERATED+i])
						GBMP[BMP_SCRIPTEDSUBSCREEN]->FastTile(0, x+151+17*i, y+64+16, 104159, 6, 128);
					else
						GBMP[BMP_SCRIPTEDSUBSCREEN]->DrawTile(0, x+151+17*i, y+64, playerTil+aframe, 1, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
					
					if(!CharAlive(i)){
						if(G[G_ASHERINCINERATED+i]){
							GBMP[BMP_SCRIPTEDSUBSCREEN]->FastTile(0, x+151+17*i+4, y+64+16-3, 1540+Floor((timer[0]%32)/8), 8, 128);
							GBMP[BMP_SCRIPTEDSUBSCREEN]->FastTile(0, x+151+17*i, y+64+16, 104158, 6, 128);
						}
						else
							GBMP[BMP_SCRIPTEDSUBSCREEN]->FastTile(0, x+151+17*i, y+64+16, 104157, 6, 128);
					}
				}
			}
		}
			
		//Battery Counts
		if(FoundItems[I_ABILITY_B_TORRIN]||FoundItems[I_ABILITY_B_TERRY]){
			int xoff = 12;
			if(Game->MCounter[CR_STELLARBATTERY]>0)
				xoff = 0;
			
			for(int i=0; i<3; ++i){
				int bbuf[8];
				if(Game->MCounter[CR_SOLARBATTERY+i]>0){
					GBMP[BMP_SCRIPTEDSUBSCREEN]->FastTile(0, x+142+24*i+xoff, y+130, 242+i, 0, 128);
					int batteryType = -1;
					if(GetCharID()==CHAR_TORRIN || (GetCharID()==CHAR_TERRY&&!G[G_RANDOMIZERENABLED]))
						batteryType = G[G_EQUIPPEDBATTERYTYPE];
					if(GetCharID()==CHAR_TERRY&&G[G_RANDOMIZERENABLED])
						batteryType = G[G_EQUIPPEDBATTERYTYPETERRY];
					if(i==batteryType)
						GBMP[BMP_SCRIPTEDSUBSCREEN]->FastTile(0, x+142+24*i+xoff, y+130+10+Sin(timer[0]*4), 246, 0, 128);
					sprintf(bbuf, "%d", Game->Counter[CR_SOLARBATTERY+i]);
					GBMP[BMP_SCRIPTEDSUBSCREEN]->DrawString(0, x+151+24*i+xoff, y+131, FONT_Z3SMALL, 0x01, -1, TF_NORMAL, bbuf, 128, SHD_OUTLINED8, 0x0F);
				}
			}
		}
		
		//L and R
		if(drawLR){
			int LROffset = 2*Sin(timer[0]*4);
			GBMP[BMP_SCRIPTEDSUBSCREEN]->DrawTile(0, x+4-LROffset, y+68, 63618, 1, 2, 11, -1, -1, 0, 0, 0, 0, true, 128);
			GBMP[BMP_SCRIPTEDSUBSCREEN]->DrawString(0, x+14-LROffset, y+80, FONT_SUBSCREEN3, 0x01, -1, TF_NORMAL, "L", 128, SHD_OUTLINED8, 0x0F);
			GBMP[BMP_SCRIPTEDSUBSCREEN]->DrawTile(0, x+236+LROffset, y+68, 63619, 1, 2, 11, -1, -1, 0, 0, 0, 0, true, 128);
			GBMP[BMP_SCRIPTEDSUBSCREEN]->DrawString(0, x+236+LROffset, y+80, FONT_SUBSCREEN3, 0x01, -1, TF_NORMAL, "R", 128, SHD_OUTLINED8, 0x0F);
		}
		
		GBMP[BMP_SCRIPTEDSUBSCREEN]->Blit(layer, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
	}
	void DrawAltCharSubscreen(int layer, int x, int y, untyped data, int timer, bool drawLR){
		int iID = data[0];
		int iX = data[1];
		int iY = data[2];
		int itemAnim = data[3];
		bool itemDidAnim = data[4];
		int passiveID = data[5];
		
		GBMP[BMP_SCRIPTEDSUBSCREEN]->Clear(0);
		
		//Frame
		GBMP[BMP_SCRIPTEDSUBSCREEN]->DrawTile(0, x, y, 62920, 16, 11, 0, -1, -1, 0, 0, 0, 0, true, 128);
		
		//Equipment menu
		GBMP[BMP_SCRIPTEDSUBSCREEN]->DrawString(0, x+46, y+47, FONT_SHERWOOD, 0x01, -1, TF_NORMAL, "Equipment", 128, SHD_OUTLINED8, 0x0F);
		GBMP[BMP_SCRIPTEDSUBSCREEN]->DrawTile(0, x+40, y+64, 62566, 6, 3, 0, -1, -1, 0, 0, 0, 0, true, 128);
		for(int i=0; i<3; ++i){
			if(G[G_SUBSCREENSEL]==i&&G[G_SUBSCREENSEL_ALTERNATE]==0)
				GBMP[BMP_SCRIPTEDSUBSCREEN]->FastTile(0, x+48+iX[i], y+72+iY[i], 553, 0, 128);
			if(iID[i]>0&&Link->Item[iID[i]]){
				itemdata id = Game->LoadItemData(iID[i]);
				
				int frame;
				int totalframes = (id->ASpeed+1)*id->Delay+(id->ASpeed+1)*id->AFrames;
				if(totalframes){
					if(!itemDidAnim[iID[i]])
						++itemAnim[iID[i]];
					itemAnim[iID[i]] %= totalframes;
					if(itemAnim[iID[i]]>=(id->ASpeed+1)*id->Delay&&id->AFrames>1){
						frame = Floor((itemAnim[iID[i]]-((id->ASpeed+1)*id->Delay))/(id->ASpeed+1));
					}
				}
				GBMP[BMP_SCRIPTEDSUBSCREEN]->FastTile(0, x+48+iX[i], y+72+iY[i], id->Tile+frame, id->CSet, 128);
				//GBMP[BMP_SCRIPTEDSUBSCREEN]->DrawInteger(0, x+iX[i], y+iY[i], FONT_Z3SMALL, 0x01, 0x0F, -1, -1, itemAnim[iID[i]], 0, 128);
			}
		}
		
		//Boss Key
		if(Game->LItems[Game->GetCurLevel()]&LI_BOSSKEY)
			GBMP[BMP_SCRIPTEDSUBSCREEN]->FastTile(0, x+30, y+125, 64019, 8, 128);
		
		int buf[128];
		if(G[G_SUBSCREENSEL_ALTERNATE]!=1){
			if(G[G_SUBSCREENSEL_ALTERNATE]==0)
				GetItemName(iID[G[G_SUBSCREENSEL]], buf);
			else if(G[G_SUBSCREENSEL_ALTERNATE]==2)
				GetItemName(passiveID[G[G_SUBSCREENSEL_PASSIVE]], buf);
			GBMP[BMP_SCRIPTEDSUBSCREEN]->DrawString(0, x+88, y+114, FONT_Z3SMALL, 0x01, -1, TF_CENTERED, buf, 128, SHD_OUTLINED8, 0x0F);
		}
		
		//Party menu
		GBMP[BMP_SCRIPTEDSUBSCREEN]->DrawString(0, x+155, y+47, FONT_SHERWOOD, 0x01, -1, TF_NORMAL, "Party", 128, SHD_OUTLINED8, 0x0F);
		GBMP[BMP_SCRIPTEDSUBSCREEN]->DrawTile(0, x+144, y+64, 62665, 4, 3, 0, -1, -1, 0, 0, 0, 0, true, 128);
		for(int i=0; i<3; ++i){
			if(G[G_SUBSCREENSEL_ALTERNATE]==1&&G[G_SUBSCREENSEL_CHARSWAP]==i)
				GBMP[BMP_SCRIPTEDSUBSCREEN]->DrawTile(0, x+151+17*i, y+64, 658, 1, 2, 0, -1, -1, 0, 0, 0, 0, true, 128);
			GBMP[BMP_SCRIPTEDSUBSCREEN]->DrawTile(0, x+151+17*i, y+64, 104173, 1, 3, 0, -1, -1, 0, 0, 0, 0, true, 128);
			if(HasChar(CHAR_SOREN+i)){
				int playerTil = 101520;
				if(i==1)
					playerTil = 101560;
				else if(i==2)
					playerTil = 101600;
				int aframe = 0;
				if(i==GetCharID()-CHAR_SOREN){
					aframe = Floor((timer[0]%48)/12);
					if(aframe==2)
						aframe = 0;
					else if(aframe==3)
						aframe = 2;
				}
				if(!CharAlive(CHAR_SOREN+i)&&G[G_ASHERINCINERATED+i])
					GBMP[BMP_SCRIPTEDSUBSCREEN]->FastTile(0, x+151+17*i, y+64+16, 104159, 6, 128);
				else
					GBMP[BMP_SCRIPTEDSUBSCREEN]->DrawTile(0, x+151+17*i, y+64, playerTil+aframe, 1, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
				
				if(!CharAlive(CHAR_SOREN+i)){
					if(G[G_ASHERINCINERATED+i]){
						GBMP[BMP_SCRIPTEDSUBSCREEN]->FastTile(0, x+151+17*i+4, y+64+16-3, 1540+Floor((timer[0]%32)/8), 8, 128);
						GBMP[BMP_SCRIPTEDSUBSCREEN]->FastTile(0, x+151+17*i, y+64+16, 104158, 6, 128);
					}
					else
						GBMP[BMP_SCRIPTEDSUBSCREEN]->FastTile(0, x+151+17*i, y+64+16, 104157, 6, 128);
				}
			}
		}
		
		//Battery Counts
		if(FoundItems[I_ABILITY_B_TORRIN]||FoundItems[I_ABILITY_B_TERRY]){
			int xoff = 12;
			if(Game->MCounter[CR_STELLARBATTERY]>0)
				xoff = 0;
			
			for(int i=0; i<3; ++i){
				int bbuf[8];
				if(Game->MCounter[CR_SOLARBATTERY+i]>0){
					GBMP[BMP_SCRIPTEDSUBSCREEN]->FastTile(0, x+142+24*i+xoff, y+130, 242+i, 0, 128);
					int batteryType = -1;
					if(GetCharID()==CHAR_TORRIN || (GetCharID()==CHAR_TERRY&&!G[G_RANDOMIZERENABLED]))
						batteryType = G[G_EQUIPPEDBATTERYTYPE];
					if(GetCharID()==CHAR_TERRY&&G[G_RANDOMIZERENABLED])
						batteryType = G[G_EQUIPPEDBATTERYTYPETERRY];
					if(i==batteryType)
						GBMP[BMP_SCRIPTEDSUBSCREEN]->FastTile(0, x+142+24*i+xoff, y+130+10+Sin(timer[0]*4), 246, 0, 128);
					sprintf(bbuf, "%d", Game->Counter[CR_SOLARBATTERY+i]);
					GBMP[BMP_SCRIPTEDSUBSCREEN]->DrawString(0, x+151+24*i+xoff, y+131, FONT_Z3SMALL, 0x01, -1, TF_NORMAL, bbuf, 128, SHD_OUTLINED8, 0x0F);
				}
			}
		}
		
		//L and R
		if(drawLR){
			int LROffset = 2*Sin(timer[0]*4);
			GBMP[BMP_SCRIPTEDSUBSCREEN]->DrawTile(0, x+4-LROffset, y+68, 63618, 1, 2, 11, -1, -1, 0, 0, 0, 0, true, 128);
			GBMP[BMP_SCRIPTEDSUBSCREEN]->DrawString(0, x+14-LROffset, y+80, FONT_SUBSCREEN3, 0x01, -1, TF_NORMAL, "L", 128, SHD_OUTLINED8, 0x0F);
			GBMP[BMP_SCRIPTEDSUBSCREEN]->DrawTile(0, x+236+LROffset, y+68, 63619, 1, 2, 11, -1, -1, 0, 0, 0, 0, true, 128);
			GBMP[BMP_SCRIPTEDSUBSCREEN]->DrawString(0, x+236+LROffset, y+80, FONT_SUBSCREEN3, 0x01, -1, TF_NORMAL, "R", 128, SHD_OUTLINED8, 0x0F);
		}
		
		GBMP[BMP_SCRIPTEDSUBSCREEN]->Blit(layer, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
	}
	void DrawAugments(int layer, int x, int y, untyped data, int timer, bool drawLR){
		untyped dataAug = data[8];
		
		int iID = dataAug[0];
		int iX = dataAug[1];
		int iY = dataAug[2];
		int itemAnim = dataAug[3];
		bool itemDidAnim = dataAug[4];
		int strDat = dataAug[5];
		int descbuffer = dataAug[6];
		
		int numAugmentSlots;
		int equippedAugments[3];
		numAugmentSlots = GetTempAugments(equippedAugments, GetCharID());
		
		GBMP[BMP_SCRIPTEDSUBSCREEN2]->Clear(0);
		
		//Frame
		GBMP[BMP_SCRIPTEDSUBSCREEN2]->DrawTile(0, x, y, 62920, 16, 11, 0, -1, -1, 0, 0, 0, 0, true, 128);
		
		//Item box
		GBMP[BMP_SCRIPTEDSUBSCREEN2]->DrawString(0, x+89, y+24, FONT_SHERWOOD, 0x01, -1, TF_NORMAL, "Augments", 128, SHD_OUTLINED8, 0x0F);
		GBMP[BMP_SCRIPTEDSUBSCREEN2]->DrawTile(0, x+64, y+43, 62720, 8, 4, 0, -1, -1, 0, 0, 0, 0, true, 128);
		for(int i=0; i<10; ++i){
			if(G[G_SUBSCREENSEL_AUGMENT]==i)
				GBMP[BMP_SCRIPTEDSUBSCREEN2]->FastTile(0, x+iX[i], y+iY[i], 553, 0, 128);
			if(iID[i]>0&&Link->Item[iID[i]]){
				itemdata id = Game->LoadItemData(iID[i]);
				
				int frame;
				int totalframes = (id->ASpeed+1)*id->Delay+(id->ASpeed+1)*id->AFrames;
				if(totalframes){
					if(!itemDidAnim[iID[i]])
						++itemAnim[iID[i]];
					itemAnim[iID[i]] %= totalframes;
					if(itemAnim[iID[i]]>=(id->ASpeed+1)*id->Delay&&id->AFrames>1){
						frame = Floor((itemAnim[iID[i]]-((id->ASpeed+1)*id->Delay))/(id->ASpeed+1));
					}
				}
				GBMP[BMP_SCRIPTEDSUBSCREEN2]->FastTile(0, x+iX[i], y+iY[i], id->Tile+frame, id->CSet, 128);
				if(G[G_SUBSCREENSEL_AUGMENT]==i)
					GBMP[BMP_SCRIPTEDSUBSCREEN2]->FastTile(0, x+iX[i], y+iY[i], (timer[0]%8<4)?66821:66822, 0, 128);
				if(equippedAugments[0]==iID[i]||equippedAugments[1]==iID[i]||equippedAugments[2]==iID[i])
					GBMP[BMP_SCRIPTEDSUBSCREEN2]->FastTile(0, x+iX[i], y+iY[i], 66823, 0, 128);
			}
		}
		
		//Augment Markers
		bool equipped[3];
		int numEquipped;
		for(int i=0; i<3; ++i){
			if(equippedAugments[i]){
				equipped[numEquipped] = true;
				++numEquipped;
			}
		}
		for(int i=0; i<numAugmentSlots; ++i){
			GBMP[BMP_SCRIPTEDSUBSCREEN2]->FastTile(0, x+192, y+56+i*12, 67078+(equipped[i]?1:0), 11, 128);
		}
		
		//Description box
		GBMP[BMP_SCRIPTEDSUBSCREEN2]->DrawTile(0, x+48, y+99, 62669, 10, 4, 0, -1, -1, 0, 0, 0, 0, true, 128);
		BitmapDrawStringSP(GBMP[BMP_SCRIPTEDSUBSCREEN2], strDat, 0, x+48+8, y+99+8, 144, TF_NORMAL, FONT_Z3SMALL, descbuffer);
		
		//Char Swapping
		DrawCharSwap(GBMP[BMP_SCRIPTEDSUBSCREEN2], data, x, y);
		
		//L and R
		if(drawLR){
			int LROffset = 2*Sin(timer[0]*4);
			GBMP[BMP_SCRIPTEDSUBSCREEN2]->DrawTile(0, x+4-LROffset, y+68, 63618, 1, 2, 11, -1, -1, 0, 0, 0, 0, true, 128);
			GBMP[BMP_SCRIPTEDSUBSCREEN2]->DrawString(0, x+14-LROffset, y+80, FONT_SUBSCREEN3, 0x01, -1, TF_NORMAL, "L", 128, SHD_OUTLINED8, 0x0F);
			GBMP[BMP_SCRIPTEDSUBSCREEN2]->DrawTile(0, x+236+LROffset, y+68, 63619, 1, 2, 11, -1, -1, 0, 0, 0, 0, true, 128);
			GBMP[BMP_SCRIPTEDSUBSCREEN2]->DrawString(0, x+236+LROffset, y+80, FONT_SUBSCREEN3, 0x01, -1, TF_NORMAL, "R", 128, SHD_OUTLINED8, 0x0F);
		}
		
		GBMP[BMP_SCRIPTEDSUBSCREEN2]->Blit(layer, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
	}
	void DrawLargeMap(int layer, int x, int y, int timer, bool drawMapBitmap, bool drawLR){
		GBMP[BMP_SCRIPTEDSUBSCREEN3]->Clear(0);
		
		//Frame
		GBMP[BMP_SCRIPTEDSUBSCREEN3]->DrawTile(0, x, y, 62920, 16, 11, 0, -1, -1, 0, 0, 0, 0, true, 128);
		
		//Map frame
		GBMP[BMP_SCRIPTEDSUBSCREEN3]->DrawString(0, x+112, y+13, FONT_SHERWOOD, 0x01, -1, TF_NORMAL, "Map", 128, SHD_OUTLINED8, 0x0F);
		GBMP[BMP_SCRIPTEDSUBSCREEN3]->Rectangle(0, x+29, y+38, x+29+198-1, y+38+109-1, 0x0F, 1, 0, 0, 0, true, 128);
		if(drawMapBitmap)
			Minimap_DrawBitmaps(x, y, LargeMapData[_LMD_MAPVIEWX], LargeMapData[_LMD_MAPVIEWY], timer);
		GBMP[BMP_SCRIPTEDSUBSCREEN3]->DrawTile(0, x+24, y+32, 62400, 13, 8, 0, -1, -1, 0, 0, 0, 0, true, 128);

		//L and R
		if(drawLR){
			int LROffset = 2*Sin(timer[0]*4);
			GBMP[BMP_SCRIPTEDSUBSCREEN3]->DrawTile(0, x+4-LROffset, y+68, 63618, 1, 2, 11, -1, -1, 0, 0, 0, 0, true, 128);
			GBMP[BMP_SCRIPTEDSUBSCREEN3]->DrawString(0, x+14-LROffset, y+80, FONT_SUBSCREEN3, 0x01, -1, TF_NORMAL, "L", 128, SHD_OUTLINED8, 0x0F);
			GBMP[BMP_SCRIPTEDSUBSCREEN3]->DrawTile(0, x+236+LROffset, y+68, 63619, 1, 2, 11, -1, -1, 0, 0, 0, 0, true, 128);
			GBMP[BMP_SCRIPTEDSUBSCREEN3]->DrawString(0, x+236+LROffset, y+80, FONT_SUBSCREEN3, 0x01, -1, TF_NORMAL, "R", 128, SHD_OUTLINED8, 0x0F);
		}
		
		GBMP[BMP_SCRIPTEDSUBSCREEN3]->Blit(layer, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
	}
	void DrawLore(int layer, int x, int y, untyped loreButtons, int timer, bool drawLR){
		GBMP[BMP_SCRIPTEDSUBSCREEN4]->Clear(0);
		
		//Frame
		GBMP[BMP_SCRIPTEDSUBSCREEN4]->DrawTile(0, x, y, 62920, 16, 11, 0, -1, -1, 0, 0, 0, 0, true, 128);
		
		//Label
		GBMP[BMP_SCRIPTEDSUBSCREEN4]->DrawString(0, x+128, y+16, FONT_SHERWOOD, 0x01, -1, TF_CENTERED, "Lore", 128, SHD_OUTLINED8, 0x0F);
		
		int btn0[] = "Party Chat"; //Good night sweet prince
		int btn1[] = "Bestiary";
		int btn2[] = "Locations";
		int btn3[] = "Quest Log";
		int btn4[] = "Return to Ship";
		int buttonLabels[] = {btn0, btn1, btn2, btn3, btn4};
		
		//Buttons
		for(int j=0; j<loreButtons[0]; ++j){
			int i = loreButtons[1+j];
			int newY = y+Lerp(50, 122, j/(loreButtons[0]-1));
			if(j==G[G_SUBSCREENSEL_LORE]){
				if(G[G_RETURNTOSHIPSAFETY]){
					int frame = Floor((timer[0]%12)/2);
					if(frame==4)
						frame = 2;
					if(frame==5)
						frame = 1;
					GBMP[BMP_SCRIPTEDSUBSCREEN4]->DrawTile(0, x+96, newY, 63580+20*frame, 4, 1, 0, -1, -1, 0, 0, 0, 0, true, 128);
					GBMP[BMP_SCRIPTEDSUBSCREEN4]->DrawString(0, x+128, newY+3, FONT_FDSLIKE, 0x01, -1, TF_CENTERED, "You sure?", 128, SHD_OUTLINED8, 0x0F);
				}
				else{
					GBMP[BMP_SCRIPTEDSUBSCREEN4]->DrawTile(0, x+96, newY, (timer[0]%8<4)?63580:63600, 4, 1, 0, -1, -1, 0, 0, 0, 0, true, 128);
					GBMP[BMP_SCRIPTEDSUBSCREEN4]->DrawString(0, x+128, newY+3, FONT_FDSLIKE, 0x01, -1, TF_CENTERED, buttonLabels[i], 128, SHD_OUTLINED8, 0x0F);
				}
			}
			else{
				GBMP[BMP_SCRIPTEDSUBSCREEN4]->DrawTile(0, x+96, newY, 63560, 4, 1, 0, -1, -1, 0, 0, 0, 0, true, 128);
				GBMP[BMP_SCRIPTEDSUBSCREEN4]->DrawString(0, x+128, newY+3, FONT_FDSLIKE, 0x01, -1, TF_CENTERED, buttonLabels[i], 128, SHD_OUTLINED8, 0x0F);
			}
			if(i==MBTN_PARTYCHAT){
				bool drawNotification;
				for(int j=0; j<G[G_MAXBANTER]; ++j){
					if(LoreTracking[LT_BANTER+GetDMapBanter(j)]==0){
						drawNotification = true;
						break;
					}
				}
				if(drawNotification&&timer[0]%16<8)
					GBMP[BMP_SCRIPTEDSUBSCREEN4]->FastTile(0, x+96+48+2, newY-2, 63564, 8, 128);
			}
			if(i==MBTN_BESTIARY){
				bool drawNotification;
				for(int j=0; j<512; ++j){
					if(LoreTracking[LT_ENEMIES+j]==1){
						drawNotification = true;
						break;
					}
				}
				if(drawNotification&&timer[0]%16<8)
					GBMP[BMP_SCRIPTEDSUBSCREEN4]->FastTile(0, x+96+48+2, newY-2, 63564, 8, 128);
			}
			if(i==MBTN_LOCATIONS){
				bool drawNotification;
				for(int j=0; j<512; ++j){
					if(LoreTracking[LT_LOCATIONS+j]==1){
						drawNotification = true;
						break;
					}
				}
				if(drawNotification&&timer[0]%16<8)
					GBMP[BMP_SCRIPTEDSUBSCREEN4]->FastTile(0, x+96+48+2, newY-2, 63564, 8, 128);
			}
			if(i==MBTN_QUESTLOG){
				bool drawNotification;
				for(int j=0; j<9; ++j){
					if(SidequestProgress(j)>LoreTracking[LT_QUEST+j]&&SidequestProgress(j)<SidequestMaxProgress(j))
						drawNotification = true;
				}
				if(drawNotification&&timer[0]%16<8)
					GBMP[BMP_SCRIPTEDSUBSCREEN4]->FastTile(0, x+96+48+2, newY-2, 63564, 8, 128);
			}
		}
		
		//L and R
		if(drawLR){
			int LROffset = 2*Sin(timer[0]*4);
			GBMP[BMP_SCRIPTEDSUBSCREEN4]->DrawTile(0, x+4-LROffset, y+68, 63618, 1, 2, 11, -1, -1, 0, 0, 0, 0, true, 128);
			GBMP[BMP_SCRIPTEDSUBSCREEN4]->DrawString(0, x+14-LROffset, y+80, FONT_SUBSCREEN3, 0x01, -1, TF_NORMAL, "L", 128, SHD_OUTLINED8, 0x0F);
			GBMP[BMP_SCRIPTEDSUBSCREEN4]->DrawTile(0, x+236+LROffset, y+68, 63619, 1, 2, 11, -1, -1, 0, 0, 0, 0, true, 128);
			GBMP[BMP_SCRIPTEDSUBSCREEN4]->DrawString(0, x+236+LROffset, y+80, FONT_SUBSCREEN3, 0x01, -1, TF_NORMAL, "R", 128, SHD_OUTLINED8, 0x0F);
		}
		
		GBMP[BMP_SCRIPTEDSUBSCREEN4]->Blit(layer, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
	}
	void DrawBanter(int layer, int x, int y, int banterStrings, int timer){
		GBMP[BMP_SCRIPTEDSUBSCREEN5]->Clear(0);
	
		//Frame
		GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawTile(0, x, y, 62920, 16, 11, 0, -1, -1, 0, 0, 0, 0, true, 128);
		GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawTile(0, x+8, y+8, 62140, 15, 10, 0, -1, -1, 0, 0, 0, 0, true, 128);
		GBMP[BMP_SCRIPTEDSUBSCREEN5]->Rectangle(0, 17, 18, 17+222-1, 18+133-1, 0x0F, 1, 0, 0, 0, true, 128);
	
		if(G[G_BANTERSTATE]==1||G[G_BANTERSTATE]==2){
			int textBoxY = 24+G[G_BANTERSTRINGPOS]*48;
			GBMP[BMP_GENERIC]->DrawTile(0, 24, textBoxY, 65796, 3, 3, 11, -1, -1, 0, 0, 0, 0, true, 128);
			GetPortraitNameAndTile(banterStrings[0+G[G_BANTERSTRINGPOS]*3]);
			G[G_PORTRAITEMOTETIL] = 0;
			int emote = banterStrings[1+G[G_BANTERSTRINGPOS]*3];
			if(emote>0)
				G[G_PORTRAITEMOTETIL] = TIL_EMOTES+emote;
			if(G[G_PORTRAITTIL]){
				GBMP[BMP_GENERIC]->DrawTile(0, 40, textBoxY+10, G[G_PORTRAITTIL], 1, 2, 6, -1, -1, 0, 0, 0, 0, true, 128);
				if(G[G_PORTRAITEMOTETIL]){
					GBMP[BMP_GENERIC]->FastTile(0, 40, textBoxY+10-8, G[G_PORTRAITEMOTETIL], 0, 128);
				}
			}
			GBMP[BMP_GENERIC]->DrawTile(0, 72, textBoxY, 65907, 10, 3, 11, -1, -1, 0, 0, 0, 0, true, 128);
			GBMP[BMP_GENERIC]->BlitTo(0, __TANGO_BITMAP, 0, 0+Tango_GetSlotScrollPos(0), 140, 32, 256+80, textBoxY+8, 140, 32, 0, 0, 0, 0, 0, false);
		}
		
		GBMP[BMP_GENERIC]->Blit(0, GBMP[BMP_SCRIPTEDSUBSCREEN5], 17, G[G_BANTERSCROLL]+18, 222, 133, 17, 18, 222, 133, 0, 0, 0, 0, 0, true);
		GBMP[BMP_GENERIC]->Blit(0, GBMP[BMP_SCRIPTEDSUBSCREEN5], 256+17, G[G_BANTERSCROLL]+18, 222, 133, 17, 18, 222, 133, 0, 0, 0, 0, 0, true);
		
		if(G[G_BANTERSTATE]==2)
			GBMP[BMP_SCRIPTEDSUBSCREEN5]->FastTile(0, x+24+48+128, y+24+Min(G[G_BANTERSTRINGPOS]*48, 72)+44+2*Sin(G[G_ANIM]*6), 62860, 11, 128);
		
		GBMP[BMP_SCRIPTEDSUBSCREEN5]->Blit(layer, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
		
		if(G[G_BANTERSTATE]==4){
			if(G[G_BANTERSCROLLTIME]>16){
				Screen->Rectangle(layer, 17, 18, 17+222-1, 18+133-1, 0x0F, 1, 0, 0, 0, true, 64);		
			}
			else if(G[G_BANTERSCROLLTIME]>8){
				Screen->Rectangle(layer, 17, 18, 17+222-1, 18+133-1, 0x0F, 1, 0, 0, 0, true, 64);		
				Screen->Rectangle(layer, 17, 18, 17+222-1, 18+133-1, 0x0F, 1, 0, 0, 0, true, 64);		
			}
			else{
				Screen->Rectangle(layer, 17, 18, 17+222-1, 18+133-1, 0x0F, 1, 0, 0, 0, true, 128);		
			}
		}
		else if(G[G_BANTERSTATE]==3){
			Screen->Rectangle(layer, 17, 18, 17+222-1, 18+133-1, 0x0F, 1, 0, 0, 0, true, 64);		
		}	
		else if(G[G_BANTERSTRINGPOS]==1){
			Screen->Rectangle(layer, 17, 18, 17+222-1, 24+48-1, 0x0F, 1, 0, 0, 0, true, 64);			
		}
		else if(G[G_BANTERSTRINGPOS]>0){
			Screen->Rectangle(layer, 17, 18, 17+222-1, 24+72-1, 0x0F, 1, 0, 0, 0, true, 64);			
		}
	}
	void DrawBestiary(int layer, int x, int y, int enemyList, int enemyListLength, int timer){
		GBMP[BMP_SCRIPTEDSUBSCREEN5]->Clear(0);
	
		BestiaryTiles(G[G_BESTIARY_ENEMYID]);
		
		//Frame
		GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawTile(0, x, y, 62920, 16, 11, 0, -1, -1, 0, 0, 0, 0, true, 128);
		
		//Enemy Frame
		GBMP[BMP_SCRIPTEDSUBSCREEN5]->Rectangle(0, x+45, y+13, x+45+64-1, y+13+56-1, 0xB5, 1, 0, 0, 0, true, 128);
		if(G[G_BESTIARY_ENEMYTILE]){
			if(G[G_BESTIARYRANDO]&&LoreTracking[LT_ENEMIES+G[G_BESTIARY_ENEMYID]]==0){
				bitmap blackout = Game->CreateBitmap(64, 64);
				blackout->Own();
				blackout->Clear(0);
				blackout->DrawTile(0, 0, 0, G[G_BESTIARY_ENEMYTILE], G[G_BESTIARY_ENEMYWIDTH], G[G_BESTIARY_ENEMYHEIGHT], G[G_BESTIARY_ENEMYCSET], -1, -1, 0, 0, 0, 0, true, 128);
				blackout->ReplaceColors(0, 0x0F, 0x01, 0xBF);
				GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawTile(0, x+45+32-G[G_BESTIARY_ENEMYWIDTH]*8, y+13+28-G[G_BESTIARY_ENEMYHEIGHT]*8, G[G_BESTIARY_ENEMYTILE], G[G_BESTIARY_ENEMYWIDTH], G[G_BESTIARY_ENEMYHEIGHT], G[G_BESTIARY_ENEMYCSET], -1, -1, 0, 0, 0, 0, true, 128);
				blackout->Blit(0, GBMP[BMP_SCRIPTEDSUBSCREEN5], 0, 0, 64, 64, x+45+32-G[G_BESTIARY_ENEMYWIDTH]*8, y+13+28-G[G_BESTIARY_ENEMYHEIGHT]*8, 64, 64, 0, 0, 0, BITDX_TRANS, 0, true);
				blackout->Free();
			}
			else
				GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawTile(0, x+45+32-G[G_BESTIARY_ENEMYWIDTH]*8, y+13+28-G[G_BESTIARY_ENEMYHEIGHT]*8, G[G_BESTIARY_ENEMYTILE], G[G_BESTIARY_ENEMYWIDTH], G[G_BESTIARY_ENEMYHEIGHT], G[G_BESTIARY_ENEMYCSET], -1, -1, 0, 0, 0, 0, true, 128);
		}
		GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawTile(0, x+45, y+13, 62560, 4, 4, 0, -1, -1, 0, 0, 0, 0, true, 128);
		int fullNameBuf[128];
		BestiaryName(fullNameBuf, enemyList[G[G_SUBSCREENSEL_BESTIARY]], false, true);
		GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawString(0, x+77, y+72, FONT_Z3SMALL, 0x01, -1, TF_CENTERED, fullNameBuf, 128, SHD_OUTLINED8, 0x0F);
		
		//Enemy List
		GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawTile(0, x+138, y+12, 62413, 6, 5, 0, -1, -1, 0, 0, 0, 0, true, 128);
		GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawTile(0, x+233, y+12, 62419, 1, 5, 0, -1, -1, 0, 0, 0, 0, true, 128);
		int listScroll = Clamp(G[G_SUBSCREENSEL_BESTIARY]-3, 0, enemyListLength-7);
		GBMP[BMP_SCRIPTEDSUBSCREEN5]->FastTile(0, x+233, y+Lerp(12, 72, listScroll/(enemyListLength-7)), 62519, 0, 128);
	
		for(int i=0; i<7; ++i){
			int pos = listScroll+i;
			int nameBuf[] = "XX: ";
			nameBuf[1] = '0' + (pos+1)%10;
			nameBuf[0] = '0' + Floor((pos+1)/10)%10;
			// nameBuf[0] = '0' + Floor((pos+1)/100)%10;
			int nameBuf2[128];
			BestiaryName(nameBuf2, enemyList[pos], true, G[G_BESTIARYRANDO]==0);
			int clrUnselected = 0x01;
			int clrFlash = (timer[0]%8<4)?0x01:0x72;
			if(G[G_BESTIARYRANDO]&&!LoreTracking[LT_ENEMIES+enemyList[pos]]){
				clrUnselected = 0x53;
				clrFlash = (timer[0]%8<4)?0x53:0x74;
			}
			int enemyNameX = x+167;
			if(G[G_BESTIARYRANDO]){
				GBMP[BMP_SCRIPTEDSUBSCREEN5]->FastTile(0, enemyNameX - 8, y+19+9*i-1, (LoreTracking[LT_ENEMIESRANDO+enemyList[pos]])?250:249, 0, 128);
			}
			else{
				enemyNameX -= 8;
			}
			if(pos==G[G_SUBSCREENSEL_BESTIARY]){
				GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawString(0, x+146, y+19+9*i, FONT_Z3SMALL, clrFlash, -1, TF_NORMAL, nameBuf, 128, SHD_OUTLINED8, 0x0F);
				GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawString(0, enemyNameX, y+19+9*i, FONT_Z3SMALL, clrFlash, -1, TF_NORMAL, nameBuf2, 128, SHD_OUTLINED8, 0x0F);
			}
			else if(LoreTracking[LT_ENEMIES+enemyList[pos]]==1){
				GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawString(0, x+146, y+19+9*i, FONT_Z3SMALL, 0x82, -1, TF_NORMAL, nameBuf, 128, SHD_OUTLINED8, 0x0F);
				GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawString(0, enemyNameX, y+19+9*i, FONT_Z3SMALL, 0x82, -1, TF_NORMAL, nameBuf2, 128, SHD_OUTLINED8, 0x0F);
			}
			else{
				GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawString(0, x+146, y+19+9*i, FONT_Z3SMALL, clrUnselected, -1, TF_NORMAL, nameBuf, 128, SHD_OUTLINED8, 0x0F);
				GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawString(0, enemyNameX, y+19+9*i, FONT_Z3SMALL, clrUnselected, -1, TF_NORMAL, nameBuf2, 128, SHD_OUTLINED8, 0x0F);
			}
		}
		
		//Text Box
		GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawTile(0, x+13, y+83, 62751, 9, 5, 0, -1, -1, 0, 0, 0, 0, true, 128);
		GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawTile(0, x+148, y+83, 62419, 1, 5, 0, -1, -1, 0, 0, 0, 0, true, 128);
		if(Tango_GetSlotMaxScrollPos(0)>0){
			GBMP[BMP_SCRIPTEDSUBSCREEN5]->FastTile(0, x+148, y+Lerp(83, 143, Tango_GetSlotScrollPos(0)/Tango_GetSlotMaxScrollPos(0)), 62519, 0, 128);
		}
		
		//Stats Box
		GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawTile(0, x+154, y+83, 62513, 6, 5, 0, -1, -1, 0, 0, 0, 0, true, 128);
		GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawString(0, x+161, y+95, FONT_Z3SMALL, 0x01, -1, TF_NORMAL, "HP:", 128, SHD_OUTLINED8, 0x0F);
		if(LoreTracking[LT_ENEMIES+G[G_BESTIARY_ENEMYID]]){
			if(G[G_BESTIARY_ENEMYHP]>0)
				DrawIntOutlineB(GBMP[BMP_SCRIPTEDSUBSCREEN5], 0, x+195, y+95, FONT_Z3SMALL, 0x01, 0x0F, TF_NORMAL, SHD_OUTLINED8, G[G_BESTIARY_ENEMYHP], 128);
			else if(G[G_BESTIARY_ENEMYHP]==-1) //Nightmare Selet
				GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawString(0, x+195, y+95, FONT_Z3SMALL, 0x01, -1, TF_NORMAL, "829000", 128, SHD_OUTLINED8, 0x0F);
			else
				GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawString(0, x+195, y+95, FONT_Z3SMALL, 0x01, -1, TF_NORMAL, "???", 128, SHD_OUTLINED8, 0x0F);
		}
		GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawString(0, x+161, y+106, FONT_Z3SMALL, 0x01, -1, TF_NORMAL, "ATK:", 128, SHD_OUTLINED8, 0x0F);
		if(LoreTracking[LT_ENEMIES+G[G_BESTIARY_ENEMYID]])
			DrawIntOutlineB(GBMP[BMP_SCRIPTEDSUBSCREEN5], 0, x+195, y+106, FONT_Z3SMALL, 0x01, 0x0F, TF_NORMAL, SHD_OUTLINED8, G[G_BESTIARY_ENEMYDAMAGE], 128);
		GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawString(0, x+161, y+117, FONT_Z3SMALL, 0x01, -1, TF_NORMAL, "W. ATK:", 128, SHD_OUTLINED8, 0x0F);
		if(LoreTracking[LT_ENEMIES+G[G_BESTIARY_ENEMYID]])
			DrawIntOutlineB(GBMP[BMP_SCRIPTEDSUBSCREEN5], 0, x+195, y+117, FONT_Z3SMALL, 0x01, 0x0F, TF_NORMAL, SHD_OUTLINED8, G[G_BESTIARY_ENEMYWDAMAGE], 128);
		GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawString(0, x+161, y+128, FONT_Z3SMALL, 0x01, -1, TF_NORMAL, "STRONG:", 128, SHD_OUTLINED8, 0x0F);
		if(LoreTracking[LT_ENEMIES+G[G_BESTIARY_ENEMYID]])
			DrawBestiaryWeakness(GBMP[BMP_SCRIPTEDSUBSCREEN5], x+194, y+127, G[G_BESTIARY_ENEMYRESIST]);
		GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawString(0, x+161, y+139, FONT_Z3SMALL, 0x01, -1, TF_NORMAL, "WEAK:", 128, SHD_OUTLINED8, 0x0F);
		if(LoreTracking[LT_ENEMIES+G[G_BESTIARY_ENEMYID]])
			DrawBestiaryWeakness(GBMP[BMP_SCRIPTEDSUBSCREEN5], x+194, y+138, G[G_BESTIARY_ENEMYWEAKNESS]);
		
		GBMP[BMP_SCRIPTEDSUBSCREEN5]->Blit(layer, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
	}
	void DrawLocations(int layer, int x, int y, int areaList, int areaListLength, int timer){
		GBMP[BMP_SCRIPTEDSUBSCREEN5]->Clear(0);
	
		//Frame
		GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawTile(0, x, y, 62920, 16, 11, 0, -1, -1, 0, 0, 0, 0, true, 128);
		
		//Name
		int buf[128];
		LocationName(buf, areaList[G[G_SUBSCREENSEL_LOCATION]]);
		GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawString(0, x+128, y+22, FONT_SHERWOOD, 0x01, -1, TF_CENTERED, buf, 128, SHD_OUTLINED8, 0x0F);
		int w = GetStringWidth(buf, FONT_SHERWOOD);
		GBMP[BMP_SCRIPTEDSUBSCREEN5]->FastTile(0, x+120-w/2-20, y+21, 61967, 11, 128);
		GBMP[BMP_SCRIPTEDSUBSCREEN5]->FastTile(0, x+120+w/2+20, y+21, 61968, 11, 128);
	
		//Screen
		if(areaList[G[G_SUBSCREENSEL_LOCATION]]==LOC_MUSHRUSH)
			GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawTile(0, 16, y+40, 70993, 7, 7, 0, -1, -1, 0, 0, 0, 0, true, 128);
		else
			GBMP[BMP_SCRIPTEDSUBSCREEN5]->BlitTo(0, GBMP[BMP_GENERIC], G[G_LOCATIONSUB_X], G[G_LOCATIONSUB_Y], 112, 112, 16, 40, 112, 112, 0, 0, 0, 0, 0, false);
		GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawTile(0, x+16, y+40, 61880, 7, 7, 11, -1, -1, 0, 0, 0, 0, true, 128);
		
		GBMP[BMP_SCRIPTEDSUBSCREEN5]->FastTile(0, x+24, y+136, G[G_RANDOMIZERENABLED]?248:241, 7, 128);
		
		int hbuf[128];
		int loc = areaList[G[G_SUBSCREENSEL_LOCATION]];
		int numHymnstones = GetHymnstoneCount(loc);
		int maxHymnstones = GetHymnstoneMax(loc);
		if(Game->LItems[Game->DMapLevel[LocationDMap(loc)]]&LI_COMPASS||numHymnstones>=maxHymnstones){
			sprintf(hbuf, "%d / %d", numHymnstones, maxHymnstones);
			GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawString(0, x+24+12, y+136+1, FONT_Z3SMALL, 0x01, -1, TF_NORMAL, hbuf, 128, SHD_OUTLINED8, 0x0F);
		}
		else{
			sprintf(hbuf, "%d / ?", numHymnstones);
			GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawString(0, x+24+12, y+136+1, FONT_Z3SMALL, 0x01, -1, TF_NORMAL, hbuf, 128, SHD_OUTLINED8, 0x0F);
		}
		
		//Description
		GBMP[BMP_SCRIPTEDSUBSCREEN5]->Rectangle(0, x+128, y+40, x+128+111, y+40+111, 0x0F, 1, 0, 0, 0, true, 128);
		GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawTile(0, x+128, y+40, 61880, 7, 7, 11, -1, -1, 0, 0, 0, 0, true, 128);
		
		GBMP[BMP_SCRIPTEDSUBSCREEN5]->Blit(layer, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
	}
	void LoadQuestProgress(int which){
		GBMP[BMP_GENERIC]->Clear(0);
		
		int buf[2048];
		int lineStart[256];
		int lineEnd[256];
		int lineStartColor[256];
		int strDat[6] = {lineStart, lineEnd, lineStartColor, 0, 8, 1};
		SidequestDescription(buf, which);
		DrawStringSP_Prep(strDat, 206, FONT_Z3SMALL, buf);
		
		BitmapDrawStringSP(GBMP[BMP_GENERIC], strDat, 0, 8, 8, 206, TF_NORMAL, FONT_Z3SMALL, buf);
		int y = 16+strDat[3]*8+4;
		
		SidequestObjectives(GBMP[BMP_GENERIC], y, which);
	}
	void DrawQuests(int layer, int x, int y, int questList, int timer){
		GBMP[BMP_SCRIPTEDSUBSCREEN5]->Clear(0);
	
		if(G[G_SUBSCREENSEL_CURRENTQUEST]==-1){
			//Frame
			GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawTile(0, x, y, 62920, 16, 11, 0, -1, -1, 0, 0, 0, 0, true, 128);
			
			//Label
			GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawString(0, x+128, y+17, FONT_SHERWOOD, 0x01, -1, TF_CENTERED, "Quest Log", 128, SHD_OUTLINED8, 0x0F);
		
			int listScroll = Clamp(G[G_SUBSCREENSEL_QUEST]-4, 0, 11-8);
		
			for(int i=0; i<8; ++i){
				int j = listScroll+i;
				int c = 0x01;
				if(j==G[G_SUBSCREENSEL_QUEST]){
					c = (timer[0]%8<4)?0x01:0x72;
				}
				int strNum[] = " X: ";
				if(j+1>9)
					strNum[0] = '0' + Floor((j+1)/10);
				strNum[1] = '0' + ((j+1)%10);
				int strName[64];
				SidequestName(strName, questList[j]);
				
				if(SidequestProgress(questList[j])>=SidequestMaxProgress(questList[j]))
					GBMP[BMP_SCRIPTEDSUBSCREEN5]->FastTile(0, x+24, y+48+13*i, 63567, 7, 128);
				else if(SidequestProgress(questList[j])>LoreTracking[LT_QUEST+questList[j]])
					GBMP[BMP_SCRIPTEDSUBSCREEN5]->FastTile(0, x+24, y+48+13*i, (timer[0]%8<4)?63566:63570, 7, 128);
				else
					GBMP[BMP_SCRIPTEDSUBSCREEN5]->FastTile(0, x+24, y+48+13*i, 63566, 7, 128);
				GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawString(0, x+37+12, y+50+13*i, FONT_Z3SMALL, c, -1, TF_RIGHT, strNum, 128, SHD_OUTLINED8, 0x0F);
				if(SidequestProgress(questList[j]))
					GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawString(0, x+37+12, y+50+13*i, FONT_Z3SMALL, c, -1, TF_NORMAL, strName, 128, SHD_OUTLINED8, 0x0F);
				else
					GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawString(0, x+37+12, y+50+13*i, FONT_Z3SMALL, c, -1, TF_NORMAL, "???", 128, SHD_OUTLINED8, 0x0F);
			}
		}
		else{
			//Frame
			GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawTile(0, x, y, 62920, 16, 11, 0, -1, -1, 0, 0, 0, 0, true, 128);
			GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawTile(0, x+8, y+40, 61620, 15, 8, 0, -1, -1, 0, 0, 0, 0, true, 128);
			
			//Label
			int strName[64];
			SidequestName(strName, G[G_SUBSCREENSEL_CURRENTQUEST]);
			GBMP[BMP_SCRIPTEDSUBSCREEN5]->DrawString(0, x+128, y+17, FONT_SHERWOOD, 0x01, -1, TF_CENTERED, strName, 128, SHD_OUTLINED8, 0x0F);
		
			GBMP[BMP_GENERIC]->Blit(0, GBMP[BMP_SCRIPTEDSUBSCREEN5], 0, G[G_CURRENTQUESTSCROLL], 222, 101, 17, 50, 222, 101, 0, 0, 0, 0, 0, true);
		}
		
		GBMP[BMP_SCRIPTEDSUBSCREEN5]->Blit(layer, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
	}
	void run(){
		int originalChar = GetCharID();
		int newChar = originalChar;
		int i;
		
		int tab = G[G_SUBSCREENTAB];
		if(G[G_NEWLORE])
			tab = 3;
		if(GetCharID()>CHAR_KAYLANI&&!G[G_RANDOMIZERENABLED]){
			if(tab==0||tab==1)
				tab = 8;
		}
		else{
			if(tab==8)
				tab = 0;
		}
		int timer[1];
		
		//				   Sword,       Ability A,   Ability B,   Ability C,   Potion,     Candle,      Bomb,        Gauntlet,    Wand,        Lunarang
		int iID[10]     = {5,           170,         171,         172,         29,         11,          144,         145,         25,          24};
		int iX[10]      = {0,           16,          32,          48,          64,         0,           16,          32,          48,          64};
		int iY[10]      = {0,           0,           0,           0,           0,          16,          16,          16,          16,          16};
		
		int iUp[10]     = {5,           6,           7,           8,           9,          0,           1,           2,           3,           4};
		int iDown[10]   = {5,           6,           7,           8,           9,          0,           1,           2,           3,           4};
		int iLeft[10]   = {4,           0,           1,           2,           3,          9,           5,           6,           7,           8};
		int iRight[10]  = {1,           2,           3,           4,           0,          6,           7,           8,           9,           5};
		
		int iIDAug[10]	= {183, 184, 185, 186, 187, 188, 189, 190, 191, 192};
		int iXAug[10]	= {72,  96,  120, 144, 168, 72,  96,  120, 144, 168};
		int iYAug[10]	= {51,  51,  51,  51,  51,  75,  75,  75,  75,  75};
		int iData[] = {iID, iX, iY, iUp, iDown, iLeft, iRight};
		
		int spacing[2] = {16, 16};
			
		//				   Octo (R)		Octo (B)	Crab (1)	Crab (2)	Crab (S)	Goriya (1)	Goriya (2)	Goriya (3)	Goriya (L)	Keese		Bat			Spider (1)	Spider (2)	Rat			Rope (1)	Rope (2)	Rope (3)	Rope (St)	Tekt (1)	Tekt (2)	Tekt (St)	Dragon (1) 	Dragon (2)	Puff (S)	Puff (F)	Puff (St)	Hopmaw (R)	Hopmaw (B)	Beehive		Piranha		Zora		Zol			Gel			H. Beetle	Curse (S)	Curse (L)	Curse (St)	Bomb (1)	Bomb (2)	Cannon		Mummy		B. Mummy	Armos		Helmet		Ghost		Cospook		NMarcher	Elem (S)    Elem (L)    Elem (St)   Wizz (S)	Wizz (L)	Wizz (St)	ECrab (S)	ECrab (L)	ECrab (St)	EGolem (S)	EGolem (L) 	EGolem (St)	Pillar (S)	Pillar (L)	Pillar (St)	Pirate (R)	Pirate (B)	Pirate (BB)	Pirate (E)  Mask (S)	Mask (L)	Mask (St)	Mask (SB)	Mask (LB)	Mask (StB)	MiniB (S)	MiniB (L)	MiniB (St)	MiniB (F)	Captain		Digger		Esan		Selet       Selet 3		Chase
		int enemyList[] = {22,			23,			26,			27,			137,		45,			46,			136,		221,		38,			106,		189,		194,		187,		44,			80,			190,		223,		25,			24,			222,		138,		139,		225,		224,		226,		237,		238,		239,		195,		33,			43,			42,			196,		198,		197,		212,		178,		179,		199,		54,			220,		210,		229,		35,			209,		227,		232,		233,		234,		56,			57,			153,		180,		181,		182,		183,		184,		185,		203,		204,		205,		191,		192,		193,		231,		186,		188,		211,		206,		207,		208,		213,		214,		215,		244,		218,		216,		242,		217,		236,		251};	
		int enemyListLength = SizeOfArray(enemyList);
		if(!LoreTracking[LT_ENEMIES+236]&&!G[G_BESTIARYRANDO]) //Nightmare Selet
			enemyListLength-=2;
		else if(!LoreTracking[LT_ENEMIES+251]) //Chase
			enemyListLength-=1;
		
		int areaList[] = {LOC_PUNA, LOC_OMAKA, LOC_PALA, LOC_WAREHOUSE, LOC_MANOR, LOC_CATACOMBS, LOC_KAWI, LOC_PIRATE, LOC_MALKA, LOC_SHOALS, LOC_MINE, LOC_JUNGLE, LOC_HILLSIDE, LOC_LAVAFLOWS, LOC_JUNGLECAVE, LOC_HOKU, LOC_TEMPLEOUTSIDE, LOC_JUNGLETEMPLE, LOC_ALII, LOC_OBSERVATORY, LOC_PONI, LOC_LAKE, LOC_MIST, LOC_KAWAIHAE, LOC_KUKULU, LOC_PIRATE2, LOC_KIKALA, LOC_LEIPAI, LOC_TULANE, LOC_CARN, LOC_PYRAMID, LOC_MIRAGE, LOC_MUSHRUSH, LOC_SILVER};
		int areaListLength = SizeOfArray(areaList);
		
		// int questList[] = {QST_IRIS, QST_TERRY, QST_PIRATE, QST_GOLEM, QST_PLANT, QST_VOLCANO, QST_NIGHTMARCHER, QST_CULTIST, QST_SOREN, QST_HORIZON};
		int questList[] = {QST_IRIS, QST_PLANT, QST_TERRY, QST_SOREN, QST_GOLEM, QST_PIRATE, QST_VOLCANO, QST_CULTIST, QST_NIGHTMARCHER, QST_HELPER, QST_HORIZON};

		int inputBuf[12];
		
		//UpdateItemArrays(data, spacing);
		
		int descbuffer[2048];
		GetDescriptionString(iIDAug[G[G_SUBSCREENSEL_AUGMENT]], descbuffer);
		int lineStart[256];
		int lineEnd[256];
		int lineStartColor[256];
		int strDat[6] = {lineStart, lineEnd, lineStartColor, 0, 8, 1};
		DrawStringSP_Prep(strDat, 144, FONT_Z3SMALL, descbuffer);
		
		int itemAnim[256];
		bool itemDidAnim[256];
		
		int ssString1[1024];
		int ssString2[1024];
		int ssString3[1024];
		int ssString4[1024];
		int ssString5[1024];
		int ssString6[1024];
		int ssStrings[18];
		ssStrings[2] = ssString1;
		ssStrings[5] = ssString2;
		ssStrings[8] = ssString3;
		ssStrings[11] = ssString4;
		ssStrings[14] = ssString5;
		ssStrings[17] = ssString6;
		LoadDMapBanter(Game->GetCurDMap());
		
		int passiveID[]  = {8, 182, 208, 178};
		
		int randomizerChars[7] = {-1, -1, -1, -1, -1, -1, 0};
		//Characters you start with always take slot 1
		for(i=0; i<6; ++i){
			//printf("G[%d] = %d\n", G_ASHERINSEED+i, G[G_ASHERINSEED+i]);
			if(G[G_ASHERINSEED+i]==2){
				randomizerChars[randomizerChars[6]] = CHAR_ASHER+i;
				++randomizerChars[6];
			}
		}
		//The rest fill up after
		for(i=0; i<6; ++i){
			if(G[G_ASHERINSEED+i]==1){
				randomizerChars[randomizerChars[6]] = CHAR_ASHER+i;
				++randomizerChars[6];
			}
		}
		printf("Num chars: %d\n", randomizerChars[6]);
		
		untyped dataAug[] = {iIDAug, iXAug, iYAug, itemAnim, itemDidAnim, strDat, descbuffer};
		untyped data[]  = {iID, iX, iY, itemAnim, itemDidAnim, passiveID, randomizerChars, iData, dataAug, spacing};
		untyped loreButtons[5] = {3, MBTN_BESTIARY, MBTN_LOCATIONS, MBTN_QUESTLOG};
		if(G[G_RANDOMIZERENABLED]){
			loreButtons[0] = 4;
			loreButtons[4] = MBTN_RETURNTOSHIP;
		}
		
		UpdateItemArrays(data, spacing);
		
		//Prepare large map loading
		int currentMap = Minimap_GetCurrentLargeMap();
		for(i=0; i<2304; ++i){
			LargeMapLayout[_LML_LAYOUTCMB+i] = 0;
			LargeMapLayout[_LML_MARKERCMB+i] = 0;
		}
		//If the current DMap isn't in the map array, just load that one
		if(currentMap==-1){
			Minimap_Overlay(Game->GetCurDMap(), 16, 20);
		}
		//Else load every other DMap in the same large map
		else{
			for(i=0; i<32; ++i){
				int dmap = LargeMapData[_LMD_MAPDEFS+_LMD_MAXMAPSECTORS*_LMD_SECTORSIZE*currentMap+_LMD_SECTORSIZE*i+_LMD_DMAP]; 
				if(dmap>-1){
					int xoff = LargeMapData[_LMD_MAPDEFS+_LMD_MAXMAPSECTORS*_LMD_SECTORSIZE*currentMap+_LMD_SECTORSIZE*i+_LMD_XOFF];
					int yoff = LargeMapData[_LMD_MAPDEFS+_LMD_MAXMAPSECTORS*_LMD_SECTORSIZE*currentMap+_LMD_SECTORSIZE*i+_LMD_YOFF];
					Minimap_Overlay(dmap, xoff, yoff);
				}
			}
		}
		GBMP[BMP_LARGEMAP]->Clear(0);
		GBMP[BMP_LARGEMAP2]->Clear(0);
		LargeMapData[_LMD_CURDRAWINDEX] = 0;
		LargeMapData[_LMD_DRAWCOUNT] = 0;
		LargeMapData[_LMD_MINX] = -1;
		LargeMapData[_LMD_MINY] = -1;
		LargeMapData[_LMD_MAXX] = -1;
		LargeMapData[_LMD_MAXY] = -1;
			
		UpdateLunarangTiles(true);
		Game->PlaySound(98);
		for(int i=-176; i<0; i+=16){
			Minimap_LoadLargeMapData();
			
			DrawPassiveGarbage(data);
			switch(tab){
				case 0:
					Draw(6, 0, i, data, timer, false);
					break;
				case 1:
					DrawAugments(7, 0, i, data, timer, false);
					break;
				case 2:
					DrawLargeMap(7, 0, i, timer, false, false);
					break;
				case 3:
					DrawLore(7, 0, i, loreButtons, timer, false);
					break;
				case 8:
					DrawAltCharSubscreen(6, 0, i, data, timer, false);
					break;
			}
			NoAction();
			Waitframe();
		}
		//Position the camera in the center of the map
		LargeMapData[_LMD_MAPVIEWX] = Floor((LargeMapData[_LMD_MINX]+LargeMapData[_LMD_MAXX]+1)*MINIMAP_SQUARESIZE/2)-104;
		LargeMapData[_LMD_MAPVIEWY] = Floor((LargeMapData[_LMD_MINY]+LargeMapData[_LMD_MAXY]+1)*MINIMAP_SQUARESIZE/2)-60;
		int edgeDist = 48;
		if(LargeMapData[_LMD_MAPVIEWX]<LargeMapData[_LMD_MINX]*MINIMAP_SQUARESIZE-edgeDist&&LargeMapData[_LMD_MAPVIEWX]>(LargeMapData[_LMD_MAXX]+1)*MINIMAP_SQUARESIZE+edgeDist-208)
			LargeMapData[_LMD_MAPVIEWX] = Floor((LargeMapData[_LMD_MINX]+LargeMapData[_LMD_MAXX]+1)*MINIMAP_SQUARESIZE/2)-104;
		else if(LargeMapData[_LMD_MAPVIEWX]<LargeMapData[_LMD_MINX]*MINIMAP_SQUARESIZE-edgeDist)
			LargeMapData[_LMD_MAPVIEWX] = LargeMapData[_LMD_MINX]*MINIMAP_SQUARESIZE-edgeDist;
		else if(LargeMapData[_LMD_MAPVIEWX]>(LargeMapData[_LMD_MAXX]+1)*MINIMAP_SQUARESIZE+edgeDist-208)
			LargeMapData[_LMD_MAPVIEWX] = (LargeMapData[_LMD_MAXX]+1)*MINIMAP_SQUARESIZE+edgeDist-208;
		
		if(LargeMapData[_LMD_MAPVIEWY]<LargeMapData[_LMD_MINY]*MINIMAP_SQUARESIZE-edgeDist&&LargeMapData[_LMD_MAPVIEWY]>(LargeMapData[_LMD_MAXY]+1)*MINIMAP_SQUARESIZE+24+edgeDist-120)
			LargeMapData[_LMD_MAPVIEWY] = Floor((LargeMapData[_LMD_MINY]+LargeMapData[_LMD_MAXY]+1)*MINIMAP_SQUARESIZE/2)-60;
		else if(LargeMapData[_LMD_MAPVIEWY]<LargeMapData[_LMD_MINY]*MINIMAP_SQUARESIZE-edgeDist)
			LargeMapData[_LMD_MAPVIEWY] = LargeMapData[_LMD_MINY]*MINIMAP_SQUARESIZE-edgeDist;
		else if(LargeMapData[_LMD_MAPVIEWY]>(LargeMapData[_LMD_MAXY]+1)*MINIMAP_SQUARESIZE+24+edgeDist-120)
			LargeMapData[_LMD_MAPVIEWY] = (LargeMapData[_LMD_MAXY]+1)*MINIMAP_SQUARESIZE+24+edgeDist-120;
		
		const int SCROLLTAB_OLDTAB = 0;
		const int SCROLLTAB_NEWTAB = 1;
		const int SCROLLTAB_DIR = 2;
		int scrollTab[] = {-1, -1, 0};
		bool returnToShip = false;
		G[G_RETURNTOSHIPSAFETY] = 0;
		
		while(true){
			if(G[G_NEWLORE]){
				if(tab<3||tab==8)
					G[G_SUBSCREENTAB] = tab;
			}
			else if(tab<4||tab==8)
				G[G_SUBSCREENTAB] = tab;
			timer[0] = (timer[0]+1)%5040;
			DrawPassiveGarbage(data);
			bool passiveUnlocked = FoundItems[8]||FoundItems[182]||FoundItems[208]||FoundItems[178];
			switch(tab){
				case 0: //{ Item Subscreen
					if(Link->PressMap&&Game->MCounter[CR_SOLARBATTERY]>0){
						if(GetCharID()==CHAR_TORRIN || (GetCharID()==CHAR_TERRY&&!G[G_RANDOMIZERENABLED])){
							Game->PlaySound(5);
							++G[G_EQUIPPEDBATTERYTYPE];
							if(Game->MCounter[CR_STELLARBATTERY]>0){
								if(G[G_EQUIPPEDBATTERYTYPE]>2)
									G[G_EQUIPPEDBATTERYTYPE] = 0;
							}
							else{
								if(G[G_EQUIPPEDBATTERYTYPE]>1)
									G[G_EQUIPPEDBATTERYTYPE] = 0;
							}
							UpdateBatteryTiles();
						}
						else if(GetCharID()==CHAR_TERRY&&G[G_RANDOMIZERENABLED]){
							Game->PlaySound(5);
							++G[G_EQUIPPEDBATTERYTYPETERRY];
							if(Game->MCounter[CR_STELLARBATTERY]>0){
								if(G[G_EQUIPPEDBATTERYTYPETERRY]>2)
									G[G_EQUIPPEDBATTERYTYPETERRY] = 0;
							}
							else{
								if(G[G_EQUIPPEDBATTERYTYPETERRY]>1)
									G[G_EQUIPPEDBATTERYTYPETERRY] = 0;
							}
							UpdateBatteryTiles();
						}
					}
					
					if(G[G_SUBSCREENSEL_ALTERNATE]==0){ //Inventory
						if(Link->PressUp){
							Game->PlaySound(5);
							if(passiveUnlocked&&G[G_SUBSCREENSEL]<5){
								G[G_SUBSCREENSEL_ALTERNATE] = 2;
							}
							else{
								G[G_SUBSCREENSEL] = iUp[G[G_SUBSCREENSEL]];
							}
						}
						if(Link->PressDown){
							Game->PlaySound(5);
							if(passiveUnlocked&&G[G_SUBSCREENSEL]>=5){
								G[G_SUBSCREENSEL_ALTERNATE] = 2;
							}
							else{
								G[G_SUBSCREENSEL] = iDown[G[G_SUBSCREENSEL]];
							}
						}
						if(Link->PressLeft){
							Game->PlaySound(5);
							if(G[G_SUBSCREENSEL]==0||G[G_SUBSCREENSEL]==5){
								G[G_SUBSCREENSEL_CHARSWAP] = randomizerChars[6]==4?1:2;
								G[G_SUBSCREENSEL_ALTERNATE] = 1;
							}
							else
								G[G_SUBSCREENSEL] = iLeft[G[G_SUBSCREENSEL]];
						}
						if(Link->PressRight){
							Game->PlaySound(5);
							if(G[G_SUBSCREENSEL]==4||G[G_SUBSCREENSEL]==9){
								G[G_SUBSCREENSEL_CHARSWAP] = 0;
								G[G_SUBSCREENSEL_ALTERNATE] = 1;
							}
							else
								G[G_SUBSCREENSEL] = iRight[G[G_SUBSCREENSEL]];
						}
						
						if(Link->Item[iID[G[G_SUBSCREENSEL]]]){
							if(Link->PressA){
								Game->PlaySound(21);
								EquipButtonItem(iID[G[G_SUBSCREENSEL]], 0, true);
							}
							if(Link->PressB){
								Game->PlaySound(21);
								EquipButtonItem(iID[G[G_SUBSCREENSEL]], 1, true);
							}
							if(Link->PressEx1){
								Game->PlaySound(21);
								EquipButtonItem(iID[G[G_SUBSCREENSEL]], 2, true);
							}
							if(Link->PressEx2){
								Game->PlaySound(21);
								EquipButtonItem(iID[G[G_SUBSCREENSEL]], 3, true);
							}
						}
					}
					else if(G[G_SUBSCREENSEL_ALTERNATE]==1){ //Char Swap
						if(G[G_RANDOMIZERENABLED]){
							int charColumns = {3, 3};
							int charRows = 2;
							int curRow = 0;
							if(G[G_SUBSCREENSEL_CHARSWAP]>=charColumns[0])
								curRow = 1;
							
							switch(randomizerChars[6]){
								case 3:
									charRows = 1;
									break;
								case 4:
									charColumns[0] = 2;
									charColumns[1] = 2;
									break;
								case 5:
									charColumns[0] = 3;
									charColumns[1] = 2;
									break;
							}
							if(Link->PressUp&&charRows>1){
								Game->PlaySound(5);
								G[G_SUBSCREENSEL_CHARSWAP] -= charColumns[0];
								if(G[G_SUBSCREENSEL_CHARSWAP]<0)
									G[G_SUBSCREENSEL_CHARSWAP] += randomizerChars[6];
							}
							if(Link->PressDown&&charRows>1){
								Game->PlaySound(5);
								G[G_SUBSCREENSEL_CHARSWAP] += charColumns[0];
								if(G[G_SUBSCREENSEL_CHARSWAP]>=randomizerChars[6])
									G[G_SUBSCREENSEL_CHARSWAP] -= randomizerChars[6];
							}
							if(Link->PressLeft){
								Game->PlaySound(5);
								if(G[G_SUBSCREENSEL_CHARSWAP]%charColumns[0]<=0){
									G[G_SUBSCREENSEL_CHARSWAP] = -1;
									G[G_SUBSCREENSEL_ALTERNATE] = 0;
									if(G[G_SUBSCREENSEL]!=4&&G[G_SUBSCREENSEL]!=9)
										G[G_SUBSCREENSEL] = 4;
								}
								else
									--G[G_SUBSCREENSEL_CHARSWAP];
							}
							if(Link->PressRight){
								Game->PlaySound(5);
								if(G[G_SUBSCREENSEL_CHARSWAP]%charColumns[0]>=charColumns[curRow]-1){
									G[G_SUBSCREENSEL_CHARSWAP] = -1;
									G[G_SUBSCREENSEL_ALTERNATE] = 0;
									if(G[G_SUBSCREENSEL]!=0&&G[G_SUBSCREENSEL]!=5)
										G[G_SUBSCREENSEL] = 0;
								}
								else
									++G[G_SUBSCREENSEL_CHARSWAP];
							}
						}
						else{
							if(Link->PressLeft){
								Game->PlaySound(5);
								if(G[G_SUBSCREENSEL_CHARSWAP]>0)
									--G[G_SUBSCREENSEL_CHARSWAP];
								else{
									G[G_SUBSCREENSEL_CHARSWAP] = -1;
									G[G_SUBSCREENSEL_ALTERNATE] = 0;
									if(G[G_SUBSCREENSEL]!=4&&G[G_SUBSCREENSEL]!=9)
										G[G_SUBSCREENSEL] = 4;
								}
							}
							if(Link->PressRight){
								Game->PlaySound(5);
								if(G[G_SUBSCREENSEL_CHARSWAP]<2)
									++G[G_SUBSCREENSEL_CHARSWAP];
								else{
									G[G_SUBSCREENSEL_CHARSWAP] = -1;
									G[G_SUBSCREENSEL_ALTERNATE] = 0;
									if(G[G_SUBSCREENSEL]!=0&&G[G_SUBSCREENSEL]!=5)
										G[G_SUBSCREENSEL] = 0;
								}
							}
						}
						
						if(Link->PressA||Link->PressB||Link->PressEx1||Link->PressEx2){
							if(G[G_RANDOMIZERENABLED]){
								if(CharAlive(randomizerChars[G[G_SUBSCREENSEL_CHARSWAP]])){
									Game->PlaySound(21);
									SetCharacter(randomizerChars[G[G_SUBSCREENSEL_CHARSWAP]], false);
									UpdateItemArrays(data, spacing);
									UpdateHUDCopytiles();
								}
								else{
									Game->PlaySound(69);
								}
							}
							else{
								if(CharAlive(G[G_SUBSCREENSEL_CHARSWAP])){
									Game->PlaySound(21);
									SetCharacter(G[G_SUBSCREENSEL_CHARSWAP], false);
									UpdateItemArrays(data, spacing);
									UpdateHUDCopytiles();
								}
								else{
									Game->PlaySound(69);
								}
							}
						}
					}
					else if(G[G_SUBSCREENSEL_ALTERNATE]==2){ //Passives
						if(Link->PressUp){
							Game->PlaySound(5);
							G[G_SUBSCREENSEL] = 5+G[G_SUBSCREENSEL]%5;
							G[G_SUBSCREENSEL_ALTERNATE] = 0;
						}
						if(Link->PressDown){
							Game->PlaySound(5);
							G[G_SUBSCREENSEL] = G[G_SUBSCREENSEL]%5;
							G[G_SUBSCREENSEL_ALTERNATE] = 0;
						}
						if(Link->PressLeft){
							Game->PlaySound(5);
							if(G[G_SUBSCREENSEL_PASSIVE]>0)
								--G[G_SUBSCREENSEL_PASSIVE];
						}
						if(Link->PressRight){
							Game->PlaySound(5);
							if(G[G_SUBSCREENSEL_PASSIVE]<3)
								++G[G_SUBSCREENSEL_PASSIVE];
						}
						
						if(Link->PressA||Link->PressB||Link->PressEx1||Link->PressEx2){
							if(FoundItems[passiveID[G[G_SUBSCREENSEL_PASSIVE]]]){
								Game->PlaySound(21);
								Link->Item[passiveID[G[G_SUBSCREENSEL_PASSIVE]]] = !Link->Item[passiveID[G[G_SUBSCREENSEL_PASSIVE]]];
							}
						}
					}
					
					UpdateActiveItems();
					Draw(7, 0, 0, data, timer, true);
					if(Link->PressL){ //To Lore
						scrollTab[SCROLLTAB_OLDTAB] = TAB_ACTIVE;
						scrollTab[SCROLLTAB_NEWTAB] = TAB_LORE;
						scrollTab[SCROLLTAB_DIR] = -1;
					}
					else if(Link->PressR){ //To Augments
						scrollTab[SCROLLTAB_OLDTAB] = TAB_ACTIVE;
						scrollTab[SCROLLTAB_NEWTAB] = (GetCharID()>CHAR_KAYLANI&&!G[G_RANDOMIZERENABLED])?TAB_MAP:TAB_AUGMENT;
						scrollTab[SCROLLTAB_DIR] = 1;
					}
					
					break; //}
				case 1: //{ Augment Subscreen
					int numAugmentSlots;
					int equippedAugments[3];
					numAugmentSlots = GetTempAugments(equippedAugments, GetCharID());
					
					bool augmentChanged;
					if(Link->PressUp){
						Game->PlaySound(5);
						augmentChanged = true;
						G[G_SUBSCREENSEL_AUGMENT] -= 5;
					}
					if(Link->PressDown){
						Game->PlaySound(5);
						augmentChanged = true;
						G[G_SUBSCREENSEL_AUGMENT] += 5;
					}
					if(Link->PressLeft){
						Game->PlaySound(5);
						augmentChanged = true;
						--G[G_SUBSCREENSEL_AUGMENT];
					}
					if(Link->PressRight){
						Game->PlaySound(5);
						augmentChanged = true;
						++G[G_SUBSCREENSEL_AUGMENT];
					}
					
					if(G[G_SUBSCREENSEL_AUGMENT]<0)
						G[G_SUBSCREENSEL_AUGMENT] += 10;
					if(G[G_SUBSCREENSEL_AUGMENT]>9)
							G[G_SUBSCREENSEL_AUGMENT] -= 10;
						
					if(augmentChanged){
						GetDescriptionString(iIDAug[G[G_SUBSCREENSEL_AUGMENT]], descbuffer);
						DrawStringSP_Prep(strDat, 144, FONT_Z3SMALL, descbuffer);
					}
					
					if(Link->Item[iIDAug[G[G_SUBSCREENSEL_AUGMENT]]]){
						if(Link->PressA){
							Game->PlaySound(21);
							EquipAugment(iIDAug[G[G_SUBSCREENSEL_AUGMENT]], equippedAugments, numAugmentSlots, 0, AUG_TOGGLE);
						}
						if(Link->PressB){
							Game->PlaySound(21);
							EquipAugment(iIDAug[G[G_SUBSCREENSEL_AUGMENT]], equippedAugments, numAugmentSlots, 1, AUG_TOGGLE);
						}
						if(Link->PressEx1){
							Game->PlaySound(21);
							EquipAugment(iIDAug[G[G_SUBSCREENSEL_AUGMENT]], equippedAugments, numAugmentSlots, 3, AUG_TOGGLE);
						}
						if(Link->PressEx2){
							Game->PlaySound(21);
							EquipAugment(iIDAug[G[G_SUBSCREENSEL_AUGMENT]], equippedAugments, numAugmentSlots, 3, AUG_TOGGLE);
						}
						if(Link->PressMap&&G[G_SUBSCREENSEL_AUGMENT]<5){
							Game->PlaySound(21);
							EquipAugmentAll(iIDAug[G[G_SUBSCREENSEL_AUGMENT]], equippedAugments, numAugmentSlots, 3);
						}
					}
					numAugmentSlots = CheckPlayerSwap(data, equippedAugments, numAugmentSlots, strDat);
					AssignTempAugments(equippedAugments, GetCharID());
					UpdateActiveItems();
					DrawAugments(7, 0, 0, data, timer, true);
					if(Link->PressL){ //To Inventory
						scrollTab[SCROLLTAB_OLDTAB] = TAB_AUGMENT;
						scrollTab[SCROLLTAB_NEWTAB] = TAB_ACTIVE;
						scrollTab[SCROLLTAB_DIR] = -1;
					}
					else if(Link->PressR){ //To Map
						scrollTab[SCROLLTAB_OLDTAB] = TAB_AUGMENT;
						scrollTab[SCROLLTAB_NEWTAB] = TAB_MAP;
						scrollTab[SCROLLTAB_DIR] = 1;
					}
					break; //}
				case 2: //{ Map Subscreen
					//Allow the camera to pan around
					LargeMapData[_LMD_MAPVIEWX] += Cond(Link->InputLeft, -2, 0) + Cond(Link->InputRight, 2, 0);
					LargeMapData[_LMD_MAPVIEWY] += Cond(Link->InputUp, -2, 0) + Cond(Link->InputDown, 2, 0);
					if(LargeMapData[_LMD_MAPVIEWX]<LargeMapData[_LMD_MINX]*MINIMAP_SQUARESIZE-edgeDist&&LargeMapData[_LMD_MAPVIEWX]>(LargeMapData[_LMD_MAXX]+1)*MINIMAP_SQUARESIZE+edgeDist-208)
						LargeMapData[_LMD_MAPVIEWX] = Floor((LargeMapData[_LMD_MINX]+LargeMapData[_LMD_MAXX]+1)*MINIMAP_SQUARESIZE/2)-104;
					else if(LargeMapData[_LMD_MAPVIEWX]<LargeMapData[_LMD_MINX]*MINIMAP_SQUARESIZE-edgeDist)
						LargeMapData[_LMD_MAPVIEWX] = LargeMapData[_LMD_MINX]*MINIMAP_SQUARESIZE-edgeDist;
					else if(LargeMapData[_LMD_MAPVIEWX]>(LargeMapData[_LMD_MAXX]+1)*MINIMAP_SQUARESIZE+edgeDist-208)
						LargeMapData[_LMD_MAPVIEWX] = (LargeMapData[_LMD_MAXX]+1)*MINIMAP_SQUARESIZE+edgeDist-208;
					
					if(LargeMapData[_LMD_MAPVIEWY]<LargeMapData[_LMD_MINY]*MINIMAP_SQUARESIZE-edgeDist&&LargeMapData[_LMD_MAPVIEWY]>(LargeMapData[_LMD_MAXY]+1)*MINIMAP_SQUARESIZE+24+edgeDist-120)
						LargeMapData[_LMD_MAPVIEWY] = Floor((LargeMapData[_LMD_MINY]+LargeMapData[_LMD_MAXY]+1)*MINIMAP_SQUARESIZE/2)-60;
					else if(LargeMapData[_LMD_MAPVIEWY]<LargeMapData[_LMD_MINY]*MINIMAP_SQUARESIZE-edgeDist)
						LargeMapData[_LMD_MAPVIEWY] = LargeMapData[_LMD_MINY]*MINIMAP_SQUARESIZE-edgeDist;
					else if(LargeMapData[_LMD_MAPVIEWY]>(LargeMapData[_LMD_MAXY]+1)*MINIMAP_SQUARESIZE+24+edgeDist-120)
						LargeMapData[_LMD_MAPVIEWY] = (LargeMapData[_LMD_MAXY]+1)*MINIMAP_SQUARESIZE+24+edgeDist-120;
		
					UpdateActiveItems();
					DrawLargeMap(7, 0, 0, timer, true, true);
					if(Link->PressL){ //To Augments
						scrollTab[SCROLLTAB_OLDTAB] = TAB_MAP;
						scrollTab[SCROLLTAB_NEWTAB] = (GetCharID()>CHAR_KAYLANI&&!G[G_RANDOMIZERENABLED])?TAB_ALTCHARACTIVE:TAB_AUGMENT;
						scrollTab[SCROLLTAB_DIR] = -1;
					}
					else if(Link->PressR){ //To Lore
						scrollTab[SCROLLTAB_OLDTAB] = TAB_MAP;
						scrollTab[SCROLLTAB_NEWTAB] = TAB_LORE;
						scrollTab[SCROLLTAB_DIR] = 1;
					}
					
					break; //}
				case 3: //{ Lore Subscreen
					if(Link->PressUp){
						G[G_RETURNTOSHIPSAFETY] = 0;
						Game->PlaySound(5);
						--G[G_SUBSCREENSEL_LORE];
						if(G[G_SUBSCREENSEL_LORE]<0)
							G[G_SUBSCREENSEL_LORE] = loreButtons[0]-1;
					}
					if(Link->PressDown){
						G[G_RETURNTOSHIPSAFETY] = 0;
						Game->PlaySound(5);
						++G[G_SUBSCREENSEL_LORE];
						if(G[G_SUBSCREENSEL_LORE]>loreButtons[0]-1)
							G[G_SUBSCREENSEL_LORE] = 0;
					}
					if(Link->PressA){
						int selected = loreButtons[1+G[G_SUBSCREENSEL_LORE]];
						if(selected==MBTN_PARTYCHAT){
							int whichBanter = GetNextDMapBanter();
							Game->PlaySound(5);
							if(whichBanter>-1){
								GBMP[BMP_GENERIC]->Clear(0);
								G[G_BANTERSTRINGPOS] = 0;
								G[G_BANTERSTATE] = 0;
								G[G_BANTERSCROLL] = 0;
								LoadBanter(ssStrings, whichBanter);
								tab = 4;
							}
							else
								Game->PlaySound(69);
						}
						else if(selected==MBTN_BESTIARY){
							Tango_ClearSlot(0);
							GetBestiaryData(enemyList);
							Game->PlaySound(5);
							tab = 5;
						}
						else if(selected==MBTN_LOCATIONS){
							Tango_ClearSlot(0);
							Game->PlaySound(5);
							LoadRelevantLocation(areaList);
							tab = 6;
							G[G_SUBSCREENOPENDMAP] = Game->GetCurDMap();
							dmapdata d = Game->LoadDMapData(Game->GetCurDMap());
							G[G_SUBSCREENOPENDMAPPALETTE] = d->Palette;
							GetLocationData(areaList, 0);
						}
						else if(selected==MBTN_QUESTLOG){
							Game->PlaySound(5);
							tab = 7;
							G[G_SUBSCREENSEL_CURRENTQUEST] = -1;
						}
						else if(selected==MBTN_RETURNTOSHIP){
							if(Link->Action!=LA_HOLD1LAND&&Link->Action!=LA_HOLD2LAND&&Link->Action!=LA_HOLD1WATER&&Link->Action!=LA_HOLD2WATER){
								if(!G[G_RETURNTOSHIPSAFETY]){
									Game->PlaySound(5);
									G[G_RETURNTOSHIPSAFETY] = 1;
								}
								else
									returnToShip = true;
							}
							else{
								Game->PlaySound(SFX_ERROR);
							}
						}
					}
					DrawLore(7, 0, 0, loreButtons, timer, true);
					if(Link->PressL){ //To Map
						G[G_RETURNTOSHIPSAFETY] = 0;
						scrollTab[SCROLLTAB_OLDTAB] = TAB_LORE;
						scrollTab[SCROLLTAB_NEWTAB] = TAB_MAP;
						scrollTab[SCROLLTAB_DIR] = -1;
					}
					else if(Link->PressR){ //To Inventory
						G[G_RETURNTOSHIPSAFETY] = 0;
						scrollTab[SCROLLTAB_OLDTAB] = TAB_LORE;
						scrollTab[SCROLLTAB_NEWTAB] = (GetCharID()>CHAR_KAYLANI&&!G[G_RANDOMIZERENABLED])?TAB_ALTCHARACTIVE:TAB_ACTIVE;
						scrollTab[SCROLLTAB_DIR] = 1;
					}
					break; //}
				case 4: //{ Banter Subscreen
					if(G[G_BANTERSTATE]==0){ //Loading string
						Tango_ClearSlot(0);
						//Trace(G[G_BANTERSTRINGPOS]);
						Tango_LoadString(0, ssStrings[2+3*G[G_BANTERSTRINGPOS]]);
						Tango_SetSlotStyle(0, STYLE_BANTER);
						Tango_SetSlotPosition(0, 24, 176);
						Tango_ActivateSlot(0);
						G[G_BANTERSTATE] = 1;
					}
					else if(G[G_BANTERSTATE]==1){ //Playing string
						if(Tango_SlotIsFinished(0)){
							G[G_MSGTIMER] = 0;
							G[G_TEXTSCROLLSPEED] = 0;
							G[G_BANTERSTATE] = 2;
						}
					}
					else if(G[G_BANTERSTATE]==2){ //Finished string
						int scroll = (Link->InputUp?-1:0) + (Link->InputDown?1:0);
						if(scroll!=0){
							G[G_TEXTSCROLLSPEED] = Clamp(G[G_TEXTSCROLLSPEED]+0.005, 0.2, 1);
							Tango_ScrollSlot(0, scroll*4*G[G_TEXTSCROLLSPEED]);
						}
						else{
							G[G_TEXTSCROLLSPEED] = 0;
						}
						if(G[G_MSGTIMER]<=50)
							++G[G_MSGTIMER];
						if(Link->PressA && G[G_MSGTIMER] > 50){
							++G[G_BANTERSTRINGPOS];
							if(G[G_BANTERSTRINGPOS]>=G[G_BANTERLENGTH]){
								LoreTracking[LT_BANTER+G[G_BANTERID]] = 1;
								G[G_BANTERSTATE] = 4;
								Tango_ClearSlot(0);
								G[G_BANTERSCROLLTIME] = 24;
							}
							else{
								if(G[G_BANTERSTRINGPOS]>1){
									G[G_BANTERSTATE] = 3;
									if(G[G_BANTERSTRINGPOS]==2)
										G[G_BANTERSCROLLTIME] = 12;
									else
										G[G_BANTERSCROLLTIME] = 24;
								}
								else{
									G[G_BANTERSTATE] = 0;
									Tango_ClearSlot(0);
								}
							}
						}
					}
					else if(G[G_BANTERSTATE]==3){ //Banter is scrolling
						if(G[G_BANTERSCROLLTIME]){
							G[G_BANTERSCROLL] += 2;
							--G[G_BANTERSCROLLTIME];
						}
						else
							G[G_BANTERSTATE] = 0;
					}
					else if(G[G_BANTERSTATE]==4){ //Delay before closing
						if(G[G_BANTERSCROLLTIME])
							--G[G_BANTERSCROLLTIME];
						else{
							Tango_ClearSlot(0);
							tab = 3;
						}
					}
					
					DrawBanter(7, 0, 0, ssStrings, timer);
					if(LoreTracking[LT_BANTER+G[G_BANTERID]]==1&&(Link->PressB||Link->PressStart)){
						Link->PressStart = false; Link->InputStart = false;
						Tango_ClearSlot(0);
						Game->PlaySound(21);
						tab = 3;
					}
					break; //}
				case 5: //{ Bestiary Subscreen
					if(G[G_BESTIARY_TEXTPLAYING]){
						if(Tango_SlotIsFinished(0)){
							G[G_BESTIARY_TEXTPLAYING] = 0;
						}
					}
					else{
						int scroll = (Link->InputL?-1:0) + (Link->InputR?1:0);
						if(scroll!=0){
							G[G_TEXTSCROLLSPEED] = Clamp(G[G_TEXTSCROLLSPEED]+0.005, 0.2, 1);
							Tango_ScrollSlot(0, scroll*4*G[G_TEXTSCROLLSPEED]);
						}
						else{
							G[G_TEXTSCROLLSPEED] = 0;
						}
					}
					if(PressUp(inputBuf)&&G[G_SUBSCREENSEL_BESTIARY]>0){
						Game->PlaySound(5);
						--G[G_SUBSCREENSEL_BESTIARY];
						if(G[G_SUBSCREENSEL_BESTIARY]<0)
							G[G_SUBSCREENSEL_BESTIARY] = 0;
						GetBestiaryData(enemyList);
					}
					if(PressDown(inputBuf)&&G[G_SUBSCREENSEL_BESTIARY]<enemyListLength-1){
						Game->PlaySound(5);
						++G[G_SUBSCREENSEL_BESTIARY];
						if(G[G_SUBSCREENSEL_BESTIARY]>enemyListLength-1)
							G[G_SUBSCREENSEL_BESTIARY] = enemyListLength-1;
						GetBestiaryData(enemyList);
					}
					DrawBestiary(7, 0, 0, enemyList, enemyListLength, timer);
					if(Link->PressB||Link->PressStart){
						Link->PressStart = false; Link->InputStart = false;
						G[G_BESTIARY_ENEMYID] = -1;
						Tango_ClearSlot(0);
						Game->PlaySound(21);
						tab = 3;
					}
					break; //}
				case 6: //{ Location Subscreen
					if(G[G_BESTIARY_TEXTPLAYING]){
						if(Tango_SlotIsFinished(0)){
							G[G_BESTIARY_TEXTPLAYING] = 0;
						}
					}
					else{
						int scroll = (Link->InputUp?-1:0) + (Link->InputDown?1:0);
						if(scroll!=0){
							G[G_TEXTSCROLLSPEED] = Clamp(G[G_TEXTSCROLLSPEED]+0.005, 0.2, 1);
							Tango_ScrollSlot(0, scroll*4*G[G_TEXTSCROLLSPEED]);
						}
						else{
							G[G_TEXTSCROLLSPEED] = 0;
						}
					}
					if(PressLeft(inputBuf)){
						Game->PlaySound(5);
						GetLocationData(areaList, -1);
					}
					if(PressRight(inputBuf)){
						Game->PlaySound(5);
						GetLocationData(areaList, 1);
					}
					DrawLocations(7, 0, 0, areaList, areaListLength, timer);
					if(Link->PressB||Link->PressStart){
						Link->PressStart = false; Link->InputStart = false;
						Tango_ClearSlot(0);
						Game->PlaySound(21);
						tab = 3;
						dmapdata d = Game->LoadDMapData(Game->GetCurDMap());
						d->Palette = G[G_SUBSCREENOPENDMAPPALETTE];
					}
					break; //}
				case 7: //{ Sidequest Subscreen
					if(G[G_SUBSCREENSEL_CURRENTQUEST]==-1){
						if(PressUp(inputBuf)&&G[G_SUBSCREENSEL_QUEST]>0){
							Game->PlaySound(5);
							--G[G_SUBSCREENSEL_QUEST];
							if(G[G_SUBSCREENSEL_QUEST]<0)
								G[G_SUBSCREENSEL_QUEST] = 0;
						}
						if(PressDown(inputBuf)&&G[G_SUBSCREENSEL_QUEST]<10){
							Game->PlaySound(5);
							++G[G_SUBSCREENSEL_QUEST];
							if(G[G_SUBSCREENSEL_QUEST]>10)
								G[G_SUBSCREENSEL_QUEST] = 10;
						}
						if(Link->PressA){
							if(SidequestProgress(questList[G[G_SUBSCREENSEL_QUEST]])){
								Game->PlaySound(5);
								G[G_SUBSCREENSEL_CURRENTQUEST] = questList[G[G_SUBSCREENSEL_QUEST]];
								int questProgress = SidequestProgress(questList[G[G_SUBSCREENSEL_QUEST]]);
								if(LoreTracking[LT_QUEST+questList[G[G_SUBSCREENSEL_QUEST]]]<questProgress)
									LoreTracking[LT_QUEST+questList[G[G_SUBSCREENSEL_QUEST]]] = questProgress;
								LoadQuestProgress(G[G_SUBSCREENSEL_CURRENTQUEST]);
							}
							else{
								Game->PlaySound(69);
							}
						}
					}
					else{
						int scroll = (Link->InputUp?-1:0) + (Link->InputDown?1:0);
						if(scroll!=0){
							G[G_TEXTSCROLLSPEED] = Clamp(G[G_TEXTSCROLLSPEED]+0.005, 0.2, 1);
							G[G_CURRENTQUESTSCROLL] = Clamp(G[G_CURRENTQUESTSCROLL]+scroll*4*G[G_TEXTSCROLLSPEED], 0, G[G_CURRENTQUESTMAXSCROLL]);
						}
						else{
							G[G_TEXTSCROLLSPEED] = 0;
						}
					}
					DrawQuests(7, 0, 0, questList, timer);
					if(Link->PressB||Link->PressStart){
						if(G[G_SUBSCREENSEL_CURRENTQUEST]==-1){
							Link->PressStart = false; Link->InputStart = false;
							Game->PlaySound(21);
							tab = 3;
						}
						else{
							Link->PressStart = false; Link->InputStart = false;
							Game->PlaySound(21);
							G[G_SUBSCREENSEL_CURRENTQUEST] = -1;
							G[G_CURRENTQUESTSCROLL] = 0;
						}
					}
					break; //}
				case 8: //{ Alt Party Item Subscreen
					if(Link->PressMap&&Game->MCounter[CR_SOLARBATTERY]>0){
						if(GetCharID()==CHAR_TORRIN && (GetCharID()==CHAR_TERRY&&!G[G_RANDOMIZERENABLED])){
							Game->PlaySound(5);
							++G[G_EQUIPPEDBATTERYTYPE];
							if(Game->MCounter[CR_STELLARBATTERY]>0){
								if(G[G_EQUIPPEDBATTERYTYPE]>2)
									G[G_EQUIPPEDBATTERYTYPE] = 0;
							}
							else{
								if(G[G_EQUIPPEDBATTERYTYPE]>1)
									G[G_EQUIPPEDBATTERYTYPE] = 0;
							}
							UpdateBatteryTiles();
						}
						else if(GetCharID()==CHAR_TERRY&&G[G_RANDOMIZERENABLED]){
							Game->PlaySound(5);
							++G[G_EQUIPPEDBATTERYTYPETERRY];
							if(Game->MCounter[CR_STELLARBATTERY]>0){
								if(G[G_EQUIPPEDBATTERYTYPETERRY]>2)
									G[G_EQUIPPEDBATTERYTYPETERRY] = 0;
							}
							else{
								if(G[G_EQUIPPEDBATTERYTYPETERRY]>1)
									G[G_EQUIPPEDBATTERYTYPETERRY] = 0;
							}
							UpdateBatteryTiles();
						}
					}
					
					if(G[G_SUBSCREENSEL_ALTERNATE]==0){ //Inventory
						if(Link->PressUp){
							Game->PlaySound(5);
						}
						if(Link->PressDown){
							Game->PlaySound(5);
						}
						if(Link->PressLeft){
							Game->PlaySound(5);
							if(G[G_SUBSCREENSEL]==0){
								G[G_SUBSCREENSEL_CHARSWAP] = 2;
								G[G_SUBSCREENSEL_ALTERNATE] = 1;
							}
							else
								G[G_SUBSCREENSEL] = iLeft[G[G_SUBSCREENSEL]];
						}
						if(Link->PressRight){
							Game->PlaySound(5);
							if(G[G_SUBSCREENSEL]==2){
								G[G_SUBSCREENSEL_CHARSWAP] = 0;
								G[G_SUBSCREENSEL_ALTERNATE] = 1;
							}
							else
								G[G_SUBSCREENSEL] = iRight[G[G_SUBSCREENSEL]];
						}
						
						if(Link->Item[iID[G[G_SUBSCREENSEL]]]){
							if(Link->PressA){
								Game->PlaySound(21);
								EquipButtonItem(iID[G[G_SUBSCREENSEL]], 0, true);
							}
							if(Link->PressB){
								Game->PlaySound(21);
								EquipButtonItem(iID[G[G_SUBSCREENSEL]], 1, true);
							}
							if(Link->PressEx1){
								Game->PlaySound(21);
								EquipButtonItem(iID[G[G_SUBSCREENSEL]], 2, true);
							}
							if(Link->PressEx2){
								Game->PlaySound(21);
								EquipButtonItem(iID[G[G_SUBSCREENSEL]], 3, true);
							}
						}
					}
					else{ //Char Swap
						if(Link->PressLeft){
							Game->PlaySound(5);
							if(G[G_SUBSCREENSEL_CHARSWAP]>0)
								--G[G_SUBSCREENSEL_CHARSWAP];
							else{
								G[G_SUBSCREENSEL_CHARSWAP] = -1;
								G[G_SUBSCREENSEL_ALTERNATE] = 0;
								G[G_SUBSCREENSEL] = 2;
							}
						}
						if(Link->PressRight){
							Game->PlaySound(5);
							if(G[G_SUBSCREENSEL_CHARSWAP]<2)
								++G[G_SUBSCREENSEL_CHARSWAP];
							else{
								G[G_SUBSCREENSEL_CHARSWAP] = -1;
								G[G_SUBSCREENSEL_ALTERNATE] = 0;
								G[G_SUBSCREENSEL] = 0;
							}
						}
						
						if(Link->PressA||Link->PressB||Link->PressEx1||Link->PressEx2){
							if(CharAlive(CHAR_SOREN+G[G_SUBSCREENSEL_CHARSWAP])){
								Game->PlaySound(21);
								SetCharacter(CHAR_SOREN+G[G_SUBSCREENSEL_CHARSWAP], false);
								UpdateItemArrays(data, spacing);
								UpdateHUDCopytiles();
							}
							else{
								Game->PlaySound(69);
							}
						}
					}
					
					UpdateActiveItems();
					DrawAltCharSubscreen(7, 0, 0, data, timer, true);
					if(Link->PressL){ //To Lore
						scrollTab[SCROLLTAB_OLDTAB] = TAB_ALTCHARACTIVE;
						scrollTab[SCROLLTAB_NEWTAB] = TAB_LORE;
						scrollTab[SCROLLTAB_DIR] = -1;
					}
					else if(Link->PressR){ //To Augments
						scrollTab[SCROLLTAB_OLDTAB] = TAB_ALTCHARACTIVE;
						scrollTab[SCROLLTAB_NEWTAB] = TAB_MAP;
						scrollTab[SCROLLTAB_DIR] = 1;
					}
					
					break; //}
				
			}
			
			if(scrollTab[SCROLLTAB_DIR]!=0){
				Game->PlaySound(SFX_SUBSCREEN_CHANGETAB);
				int oldTabX = 0;
				int newTabX = 0;
				if(scrollTab[SCROLLTAB_DIR]==-1){
					oldTabX = 0;
					newTabX = -256;
				}
				else{
					oldTabX = 0;
					newTabX = 256;
				}
				for(int i=0; i<16; ++i){
					Waitframe();
					oldTabX -= scrollTab[SCROLLTAB_DIR]*16;
					newTabX -= scrollTab[SCROLLTAB_DIR]*16;
					DrawPassiveGarbage(data);
					switch(scrollTab[SCROLLTAB_OLDTAB]){
						case 0: //Active
							Draw(7, oldTabX, 0, data, timer, true);
							break;
						case 1: //Augment
							DrawAugments(7, oldTabX, 0, data, timer, true);
							break;
						case 2: //Map
							DrawLargeMap(7, oldTabX, 0, timer, true, true);
							break;
						case 3: // Lore
							DrawLore(7, oldTabX, 0, loreButtons, timer, false);
							break;
						case 8: //Active Alt
							DrawAltCharSubscreen(7, oldTabX, 0, data, timer, true);
							break;
					}
					switch(scrollTab[SCROLLTAB_NEWTAB]){
						case 0: //Active
							Draw(7, newTabX, 0, data, timer, true);
							tab = TAB_ACTIVE;
							break;
						case 1: //Augment
							DrawAugments(7, newTabX, 0, data, timer, true);
							tab = TAB_AUGMENT;
							break;
						case 2: //Map
							DrawLargeMap(7, newTabX, 0, timer, true, true);
							tab = TAB_MAP;
							break;
						case 3: // Lore
							DrawLore(7, newTabX, 0, loreButtons, timer, false);
							tab = TAB_LORE;
							break;
						case 8: //Active Alt
							DrawAltCharSubscreen(7, newTabX, 0, data, timer, true);
							tab = TAB_ALTCHARACTIVE;
							break;
					}
				}
				scrollTab[SCROLLTAB_DIR] = 0;
			}
			else if((Link->PressStart||returnToShip)&&(tab<4||tab==8))
				break;
			
			G[G_ANIM] = (G[G_ANIM]+1)%5040;
			UpdateMenuInputBuffer(inputBuf);
			Tango_Update1();
			NoAction();
			Waitdraw();
			if(G[G_BESTIARY_TEXTPLAYING]){
				Tango_ScrollSlot(0, -120);
			}
			Tango_Update2();
			Waitframe();
		}
		newChar = GetCharID();
		SetCharacter(originalChar, false);
		G[G_BANTERCYCLE] = 0;
		Game->PlaySound(97);
		for(int i=0; i>-176; i-=16){
			DrawPassiveGarbage(data);
			switch(tab){
				case 0:
					Draw(6, 0, i, data, timer, false);
					break;
				case 1:
					DrawAugments(7, 0, i, data, timer, false);
					break;
				case 2:
					DrawLargeMap(7, 0, i, timer, false, false);
					break;
				case 3:
					DrawLore(7, 0, i, loreButtons, timer, false);
					break;
				case 8:
					DrawAltCharSubscreen(6, 0, i, data, timer, false);
					break;
			}
			NoAction();
			Waitframe();
		}
		if(originalChar!=newChar){
			G[G_FORCECHARSWAP] = newChar;
		}
		NoAction();
		if(returnToShip){
			Link->Warp(29, 0x11);
		}
	}
}

dmapdata script BatterySelect{
	void DrawBatteryIcons(int percent, int panelX, int panelY, int selection, bool drawStellar, bool drawCounts){
		int count = 2;
		int offset = 12;
		if(drawStellar){
			count = 3;
			offset = 0;
		}
		
		for(int i=0; i<count; ++i){
			int x = Lerp(Link->X, panelX + offset + 24*i, percent);
			int y = Lerp(Link->Y, panelY, percent);
			
			if(selection==i){
				Screen->FastTile(7, x, y, 65246, 0, 128);
			}
			Screen->FastTile(7, x, y, 65112+i, 0, 128);
			if(drawCounts){
				int countStr[16];
				sprintf(countStr, "%02d", Game->Counter[CR_SOLARBATTERY+i]);
				Screen->DrawString(7, x+3, y+14, FONT_Z3SMALL, 0x01, -1, TF_NORMAL, countStr, 128, SHD_OUTLINEDX, 0x0F);
			}
		}
	}
	void run(){
		int charID = GetCharID();
		if(charID==CHAR_TORRIN||charID==CHAR_TERRY){
			bool drawStellar = Game->MCounter[CR_STELLARBATTERY] > 0;
			int selection = G[G_EQUIPPEDBATTERYTYPE];
			if(charID==CHAR_TERRY&&G[G_RANDOMIZERENABLED])
				selection = G[G_EQUIPPEDBATTERYTYPETERRY];
			int panelX = Clamp(Link->X-24, 8, 232-48);
			int panelY = Clamp(Link->Y-8, 8, 152-16);
			bool hold = true;
			int holdFrames = 16;
			Game->PlaySound(98);
			for(int i=0; i<8; ++i){
				if(!Link->InputMap)
					hold = false;
				Screen->Rectangle(7, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
				if(i>=4)
					Screen->Rectangle(7, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
				
				DrawBatteryIcons(i/7, panelX, panelY, selection, drawStellar, false);
				
				Waitframe();
			}
			while(true){
				if(holdFrames>0){
					if(!Link->InputMap)
						hold = false;
					--holdFrames;
				}
				if(hold){
					if(!Link->InputMap)
						break;
				}
				else if(Link->PressMap||Link->PressA||Link->PressB)
					break;
				
				Screen->Rectangle(7, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
				Screen->Rectangle(7, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
				
				if(Link->PressLeft){
					Game->PlaySound(5);
					--selection;
					if(selection<0){
						if(drawStellar)
							selection = 2;
						else
							selection = 1;
					}
				}
				else if(Link->PressRight){
					Game->PlaySound(5);
					++selection;
					int max = 1;
					if(drawStellar)
						max = 2;
					if(selection>max)
						selection = 0;
				}
				
				DrawBatteryIcons(1, panelX, panelY, selection, drawStellar, true);
				
				Waitframe();
			}
			if(charID==CHAR_TERRY&&G[G_RANDOMIZERENABLED])
				G[G_EQUIPPEDBATTERYTYPETERRY] = selection;
			else
				G[G_EQUIPPEDBATTERYTYPE] = selection;
			Game->PlaySound(97);
			for(int i=7; i>=0; --i){
				if(!Link->InputMap)
					hold = false;
				Screen->Rectangle(7, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
				if(i>=4)
					Screen->Rectangle(7, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
				
				DrawBatteryIcons(i/7, panelX, panelY, selection, drawStellar, false);
				
				Waitframe();
			}
		}
	}
}

int CheckHymnstone(int rMap, int rScreen, bool special){
	if(special){
		if(Game->GetScreenState(rMap, rScreen, ST_SPECIALITEM))
			return 1;
	}
	else{
		if(Game->GetScreenState(rMap, rScreen, ST_ITEM))
			return 1;
	}
	return 0;
}
//Count all dbits used by randomizer items
int CheckHymnstoneDBits(int rDMap, int rScreen){
	int bitflags = Game->GetDMapScreenD(rDMap, rScreen, D_ITEMSPAWN);
	int collected;
	for(int i=0; i<8; ++i){
		if(bitflags&(1<<i))
			++collected;
	}
	return collected;
}
int CheckHymnstoneDBit(int rDMap, int rScreen, int bit){
	int bitflags = Game->GetDMapScreenD(rDMap, rScreen, D_ITEMSPAWN);
	if(bitflags&(1<<bit))
		return 1;
	return 0;
}
//Same as above but uses D[0] and also 32 bit for some reason
int CheckHymnstoneShopDBits(int rDMap, int rScreen){
	long bitflags = Game->GetDMapScreenD(rDMap, rScreen, 0);
	int collected;
	for(int i=0; i<8; ++i){
		if(bitflags&(1L<<i))
			++collected;
	}
	return collected;
}
int GetHymnstoneCount(int loc){
	int count;
	switch(loc){
		case LOC_PUNA:
			count += CheckHymnstone(2, 0x70, true);
			break;
		case LOC_OMAKA:
			count += CheckHymnstone(2, 0x00, false);
			count += CheckHymnstone(2, 0x07, false);
			count += CheckHymnstone(2, 0x11, false);
			count += CheckHymnstone(2, 0x37, false);
			count += CheckHymnstone(2, 0x44, false);
			count += CheckHymnstone(2, 0x46, false);
			count += CheckHymnstone(2, 0x57, false);
			if(G[G_RANDOMIZERENABLED]){
				count += CheckHymnstoneDBits(0, 0x13); //Totems
			}
			break;
		case LOC_PALA:
			count += CheckHymnstone(2, 0x09, false);
			count += CheckHymnstone(2, 0x1D, false);
			count += CheckHymnstone(2, 0x2E, false);
			count += CheckHymnstone(2, 0x3F, false);
			count += CheckHymnstone(2, 0x4B, true);
			count += CheckHymnstone(2, 0x7B, false);
			if(G[G_RANDOMIZERENABLED]){
				count += CheckHymnstone(2, 0x49, false); //Zarath
				count += CheckHymnstoneShopDBits(3, 0x70); //Shop 1
				count += CheckHymnstoneShopDBits(3, 0x72); //Shop 2
			}
			break;
		case LOC_WAREHOUSE:
			count += CheckHymnstone(9, 0x33, false);
			count += CheckHymnstone(9, 0x54, false);
			count += CheckHymnstone(9, 0x56, false);
			if(G[G_RANDOMIZERENABLED]){
				count += CheckHymnstone(9, 0x22, true); //Item chest
				count += CheckHymnstoneDBits(9, 0x05); //End point
			}
			break;
		case LOC_MANOR:
			count += CheckHymnstone(24, 0x0A, false);
			count += CheckHymnstone(24, 0x0C, false);
			count += CheckHymnstone(24, 0x28, false);
			if(G[G_RANDOMIZERENABLED]){
				count += CheckHymnstone(24, 0x08, true); //Stellar wand
				count += CheckHymnstone(24, 0x0D, false); //Asher's room
				count += CheckHymnstone(24, 0x3C, false); //Coins
			}
			break;
		case LOC_CATACOMBS:
			count += CheckHymnstone(24, 0x4D, true);
			count += CheckHymnstone(24, 0x6B, true);
			count += CheckHymnstone(24, 0x6D, true);
			if(G[G_RANDOMIZERENABLED]){
				count += CheckHymnstone(24, 0x7A, false); //Left Switch
				count += CheckHymnstone(24, 0x7C, false); //Right Switch
			}
			break;
		case LOC_KAWI:
			count += CheckHymnstone(6, 0x45, false);
			count += CheckHymnstone(6, 0x56, true);
			count += CheckHymnstone(6, 0x53, false);
			count += CheckHymnstone(6, 0x67, false);
			count += CheckHymnstone(6, 0x75, false);
			count += CheckHymnstone(6, 0x71, false);
			count += CheckHymnstone(6, 0x01, false);
			if(G[G_RANDOMIZERENABLED]){
				count += CheckHymnstoneDBits(6, 0x44); //Totems
			}
			break;
		case LOC_PIRATE:
			count += CheckHymnstone(6, 0x4E, false);
			count += CheckHymnstone(6, 0x4B, false);
			count += CheckHymnstone(6, 0x49, false);
			if(G[G_RANDOMIZERENABLED]){
				count += CheckHymnstone(6, 0x38, true); //Lobber bombs
				count += CheckHymnstoneDBits(16, 0x13); //Shelrond
			}
			break;
		case LOC_MALKA:
			count += CheckHymnstone(20, 0x1E, false);
			count += CheckHymnstone(20, 0x4F, false);
			if(G[G_RANDOMIZERENABLED]){
				count += CheckHymnstoneShopDBits(31, 0x72); //Shop
			}
			break;
		case LOC_SHOALS:
			count += CheckHymnstone(16, 0x04, true);
			count += CheckHymnstone(16, 0x47, false);
			count += CheckHymnstone(16, 0x66, false);
			count += CheckHymnstone(16, 0x74, false);
			if(G[G_RANDOMIZERENABLED]){
				count += CheckHymnstone(16, 0x13, true); //Coins
				count += CheckHymnstoneDBits(14, 0x55); //Totems
			}
			break;
		case LOC_MINE:
			count += CheckHymnstone(20, 0x51, false);
			count += CheckHymnstone(20, 0x44, false);
			count += CheckHymnstone(20, 0x27, false);
			count += CheckHymnstone(20, 0x47, false);
			count += CheckHymnstone(20, 0x55, false);
			if(G[G_RANDOMIZERENABLED]){
				count += CheckHymnstone(20, 0x22, true); //Tidal gauntlet
				count += CheckHymnstoneDBits(64, 0x0A); //Selet
			}
			break;
		case LOC_JUNGLE:
			count += CheckHymnstone(12, 0x40, false);
			count += CheckHymnstone(12, 0x43, false);
			if(G[G_RANDOMIZERENABLED]){
				count += CheckHymnstoneDBits(10, 0x42); //Totems
			}
			break;
		case LOC_HILLSIDE:
			count += CheckHymnstone(12, 0x12, false);
			count += CheckHymnstone(12, 0x67, false);
			count += CheckHymnstone(12, 0x77, true);
			break;
		case LOC_LAVAFLOWS:
			count += CheckHymnstone(12, 0x4A, false);
			count += CheckHymnstone(12, 0x5A, false);
			count += CheckHymnstone(12, 0x25, false);
			count += CheckHymnstoneDBits(12, 0x7B); //Lunar Golem
			count += CheckHymnstone(12, 0x15, false);
			if(G[G_RANDOMIZERENABLED]){
				count += CheckHymnstoneDBits(12, 0x4B); //Truf quest
			}
			break;
		case LOC_JUNGLECAVE:
			count += CheckHymnstone(38, 0x1A, false);
			break;
		case LOC_HOKU:
			if(G[G_RANDOMIZERENABLED]){
				count += CheckHymnstoneShopDBits(32, 0x71); //Shop
			}
			break;
		case LOC_TEMPLEOUTSIDE:
			if(G[G_RANDOMIZERENABLED]){
				count += CheckHymnstone(33, 0x31, false); //Jungle plant
				count += CheckHymnstone(33, 0x41, false); //Jungle coins
				count += CheckHymnstone(12, 0x01, false); //Jungle cave coins
			}
			break;
		case LOC_JUNGLETEMPLE:
			count += CheckHymnstone(33, 0x34, false);
			if(G[G_RANDOMIZERENABLED]){
				count += CheckHymnstoneDBits(37, 0x14); //End
			}
			break;
		case LOC_ALII:
			count += CheckHymnstone(16, 0x1A, true);
			count += CheckHymnstone(16, 0x2D, false);
			count += CheckHymnstone(16, 0x3B, false);
			count += CheckHymnstone(16, 0x48, false);
			count += CheckHymnstone(16, 0x49, false);
			count += CheckHymnstone(16, 0x5F, false);
			break;
		case LOC_OBSERVATORY:
			count += CheckHymnstone(24, 0x05, false);
			count += CheckHymnstone(24, 0x20, false);
			count += CheckHymnstone(24, 0x44, false);
			count += CheckHymnstone(24, 0x53, false);
			count += CheckHymnstone(24, 0x60, false);
			count += CheckHymnstone(24, 0x76, false);
			if(G[G_RANDOMIZERENABLED]){
				count += CheckHymnstone(24, 0x22, true); //Starstone
				if(G[G_RANDOMIZERMODE]==1){
					count += CheckHymnstoneDBits(70, 0x06); //Nightmare Selet
				}
			}
			break;
		case LOC_PONI:
			count += CheckHymnstone(42, 0x15, false);
			count += CheckHymnstone(42, 0x25, false);
			count += CheckHymnstone(42, 0x41, true);
			count += CheckHymnstone(42, 0x47, false);
			count += CheckHymnstone(42, 0x60, false);
			count += CheckHymnstone(42, 0x7A, false);
			break;
		case LOC_LAKE:
			count += CheckHymnstone(42, 0x75, false);
			break;
		case LOC_MIST:
			count += CheckHymnstone(46, 0x3B, false);
			count += CheckHymnstone(46, 0x4B, true);
			count += CheckHymnstone(46, 0x67, false);
			if(G[G_RANDOMIZERENABLED]){
				count += CheckHymnstone(46, 0x51, true); //Lunarang
				count += CheckHymnstone(46, 0x29, false); //Allie and Band
				count += CheckHymnstone(46, 0x2C, false); //Skai and co.
				count += CheckHymnstone(46, 0x6A, false); //Kenja
				count += CheckHymnstoneDBit(53, 0x75, 0); //Tulane
				count += CheckHymnstoneDBits(67, 0x62); //Esan
			}
			break;
		case LOC_KAWAIHAE:
			count += CheckHymnstone(12, 0x1F, false);
			count += CheckHymnstone(12, 0x1D, true);
			count += CheckHymnstoneDBits(30, 0x23); //Stellar Golem
			count += CheckHymnstone(12, 0x3D, true);
			if(G[G_RANDOMIZERENABLED]){
				count += CheckHymnstoneDBits(30, 0x1); //Solar Pillar
			}
			break;
		case LOC_KUKULU:
			count += CheckHymnstone(38, 0x48, false);
			count += CheckHymnstone(38, 0x5B, false);
			break;
		case LOC_PIRATE2:
			if(G[G_RANDOMIZERENABLED]){
				count += CheckHymnstone(38, 0x6E, true); //Coins
				count += CheckHymnstoneDBits(60, 0x56); //Shelrond 2
			}
			break;
		case LOC_KIKALA:
			count += CheckHymnstoneDBits(27, 0x45); //Solar Golem
			count += CheckHymnstone(12, 0x5C, false);
			count += CheckHymnstone(12, 0x7E, false);
			count += CheckHymnstone(12, 0x7C, false);
			if(G[G_RANDOMIZERENABLED]){
				count += CheckHymnstoneDBits(27, 0x46); //Lunar Pillar
			}
			break;
		case LOC_LEIPAI:
			count += CheckHymnstone(9, 0x3A, false);
			count += CheckHymnstone(9, 0x58, false);
			if(G[G_RANDOMIZERENABLED]){
				count += CheckHymnstone(9, 0x49, false); //Coins
			}
			break;
		case LOC_TULANE:
			count += CheckHymnstone(33, 0x56, false);
			count += CheckHymnstone(33, 0x59, true);
			count += CheckHymnstone(6, 0x04, true);
			if(G[G_RANDOMIZERENABLED]){
				count += CheckHymnstoneDBits(44, 0x56); //End
			}
			break;
		case LOC_CARN:
			count += CheckHymnstoneDBits(38, 0x24); //Fusion Golem
			count += CheckHymnstone(33, 0x3E, false);
			count += CheckHymnstone(33, 0x3A, false);
			count += CheckHymnstone(33, 0x6D, false);
			count += CheckHymnstone(33, 0x7D, false);
			break;
		case LOC_PYRAMID:
			count += CheckHymnstone(28, 0x4C, false);
			count += CheckHymnstone(28, 0x6B, false);
			count += CheckHymnstone(28, 0x6F, false);
			if(G[G_RANDOMIZERENABLED]){
				count += CheckHymnstoneDBits(73, 0x45); //Esan 2
			}
			break;
		case LOC_MIRAGE:
			count += CheckHymnstone(24, 0x78, false);
			break;
		case LOC_MUSHRUSH:
			break;
		case LOC_SILVER:
			break;
	}
	return count;
}

int GetHymnstoneMax(int loc){
	switch(loc){
		case LOC_PUNA:
			return 1;
		case LOC_OMAKA:
			if(G[G_RANDOMIZERENABLED]) return 12;
			return 7;
		case LOC_PALA:
			if(G[G_RANDOMIZERENABLED]) return 13;
			return 6;
		case LOC_WAREHOUSE:
			if(G[G_RANDOMIZERENABLED]) return 6;
			return 3;
		case LOC_MANOR:
			if(G[G_RANDOMIZERENABLED]) return 5;
			return 3;
		case LOC_CATACOMBS:
			if(G[G_RANDOMIZERENABLED]) return 5;
			return 3;
		case LOC_KAWI:
			if(G[G_RANDOMIZERENABLED]) return 12;
			return 7;
		case LOC_PIRATE:
			if(G[G_RANDOMIZERENABLED]) return 6;
			return 3;
		case LOC_MALKA:
			if(G[G_RANDOMIZERENABLED]) return 5;
			return 2;
		case LOC_SHOALS:
			if(G[G_RANDOMIZERENABLED]) return 10;
			return 4;
		case LOC_MINE:
			if(G[G_RANDOMIZERENABLED]) return 9;
			return 5;
		case LOC_JUNGLE:
			if(G[G_RANDOMIZERENABLED]) return 7;
			return 2;
		case LOC_HILLSIDE:
			return 3;
		case LOC_LAVAFLOWS:
			if(G[G_RANDOMIZERENABLED]) return 8;
			return 5;
		case LOC_JUNGLECAVE:
			return 1;
		case LOC_HOKU:
			if(G[G_RANDOMIZERENABLED]) return 3;
			return 0;
		case LOC_TEMPLEOUTSIDE:
			if(G[G_RANDOMIZERENABLED]) return 3;
			return 0;
		case LOC_JUNGLETEMPLE:
			if(G[G_RANDOMIZERENABLED]) return 3;
			return 1;
		case LOC_ALII:
			return 6;
		case LOC_OBSERVATORY:
			if(G[G_RANDOMIZERENABLED]){
				if(G[G_RANDOMIZERMODE]==1)
					return 11;
				else
					return 7;
			}
			return 6;
		case LOC_PONI:
			return 6;
		case LOC_LAKE:
			return 1;
		case LOC_MIST:
			if(G[G_RANDOMIZERENABLED]) return 10;
			return 3;
		case LOC_KAWAIHAE:
			if(G[G_RANDOMIZERENABLED]) return 7;
			return 4;
		case LOC_KUKULU:
			return 2;
		case LOC_PIRATE2:
			if(G[G_RANDOMIZERENABLED]) return 3;
			return 0;
		case LOC_KIKALA:
			if(G[G_RANDOMIZERENABLED]) return 7;
			return 4;
		case LOC_LEIPAI:
			if(G[G_RANDOMIZERENABLED]) return 3;
			return 2;
		case LOC_TULANE:
			if(G[G_RANDOMIZERENABLED]) return 5;
			return 3;
		case LOC_CARN:
			if(G[G_RANDOMIZERENABLED]) return 8;
			return 5;
		case LOC_PYRAMID:
			if(G[G_RANDOMIZERENABLED]) return 5;
			return 3;
		case LOC_MIRAGE:
			if(G[G_RANDOMIZERENABLED]) return 1;
			return 0;
		case LOC_MUSHRUSH:
			return 0;
		case LOC_SILVER:
			return 0;
	}
}

dmapdata script TikiTorches{
	void run(){
		bool night;
		while(true){
			if(DayNight[_DN_HOUR] >= DAYNIGHT_MIDI_NIGHT_START_HOUR || DayNight[_DN_HOUR] <= DAYNIGHT_MIDI_NIGHT_END_HOUR){
				night = true;
			}
			else{
				night = false;
			}
			for(int i = 0; i<176; i++){
				if(night){
					if(GetLayerComboD(3, i) == 41187){
						SetLayerComboD(3, i-16, 41186);
						SetLayerComboD(3, i, 41190);
					}
				}
				else{
					if(GetLayerComboD(3, i) == 41190){
						SetLayerComboD(3, i-16, 0);
						SetLayerComboD(3, i, 41187);
					}
				}
			}
			Waitframe();
		}
	}
}

dmapdata script BodyguardBegone{
	void run(){
		bool condition;
		if(this->InitD[0] == 0){
			if(Game->Counter[CR_MISCSIDEQUEST]>=7)
				condition = true;
		}
		if(this->InitD[0] == 1){
			if(Game->Counter[CR_STORYFLAG]>=SFLAG_ASHERKIDNAPPED)
				condition = true;
		}
		if(this->InitD[0] == 2){
			if(Game->Counter[CR_SMALLSIDEQUESTS1] & BF_12)
				condition = true;
		}
		if(G[G_RANDOMIZERENABLED])
			condition = false;
		while(true){
			if(condition){
				int newEnemy[10];
				int count;
				for(int i=0; i<10; ++i){
					switch(Screen->Enemy[i]){
						case 0:
						case 191:
						case 192:
						case 193:
							break;
						default:
							newEnemy[count] = Screen->Enemy[i];
							++count;
							break;
					}
				}
				for(int i=0; i<10; ++i){
					Screen->Enemy[i] = newEnemy[i];
				}
			}
			Waitframe();
		}
	}
}

dmapdata script TheFogOfWar{
	bool IsFogFlag(int flg){
		switch(flg){
			case CF_LAKETEMPLEFOG:
			case CF_LAKETEMPLEFOG2:
			case CF_LAKETEMPLEFOG3:
			case CF_LAKETEMPLEFOG4:
				return true;
		}
		return false;
	}
	bool IsAdjacentFog(mapdata m, int pos, int dir){
		switch(dir){
			case DIR_UP:
				if(pos<16)
					return true;
				return IsFogFlag(m->ComboF[pos-16]);
			case DIR_DOWN:
				if(pos>159)
					return true;
				return IsFogFlag(m->ComboF[pos+16]);
			case DIR_LEFT:
				if(pos%16==0)
					return true;
				return IsFogFlag(m->ComboF[pos-1]);
			case DIR_RIGHT:
				if(pos%16==15)
					return true;
				return IsFogFlag(m->ComboF[pos+1]);
			case DIR_LEFTUP:
				if(pos%16==0||pos<16)
					return false;
				return IsFogFlag(m->ComboF[pos-17]);
			case DIR_LEFTDOWN:
				if(pos%16==0||pos>159)
					return false;
				return IsFogFlag(m->ComboF[pos+15]);
			case DIR_RIGHTUP:
				if(pos%16==15||pos<16)
					return false;
				return IsFogFlag(m->ComboF[pos-15]);
			case DIR_RIGHTDOWN:
				if(pos%16==15||pos>159)
					return false;
				return IsFogFlag(m->ComboF[pos+17]);
		}
	}
	int FogMaskTile(mapdata m, mapdata l3, int pos){
		if(m->ComboF[pos]==CF_LAKETEMPLEFOG2){
			switch(l3->ComboD[pos]){
				case 28452:
					if(!IsAdjacentFog(m, pos, DIR_UP))
						return 44455;
					else
						return 44454;
				case 28661:
					if(!IsAdjacentFog(m, pos, DIR_UP))
						return 44435;
					else
						return 44434;
				
			}
		}
		if(m->ComboF[pos]==CF_LAKETEMPLEFOG3)
			return 44453;
		const int UP 			= 00000001b;
		const int DOWN 			= 00000010b;
		const int LEFT 			= 00000100b;
		const int RIGHT	 		= 00001000b;
		const int DIAG_UL 		= 00010000b;
		const int DIAG_UR 		= 00100000b;
		const int DIAG_DL 		= 01000000b;
		const int DIAG_DR 		= 10000000b;
		
		const int CORNER_UL		= 00000101b;
		const int CORNER_UR		= 00001001b;
		const int CORNER_DL		= 00000110b;
		const int CORNER_DR 	= 00001010b;
		const int CORNER_IN_UL	= 00010101b;
		const int CORNER_IN_UR	= 00101001b;
		const int CORNER_IN_DL	= 01000110b;
		const int CORNER_IN_DR 	= 10001010b;
		int sides;
		if(!IsAdjacentFog(m, pos, DIR_UP))
			sides |= UP;
		
		if(!IsAdjacentFog(m, pos, DIR_DOWN))
			sides |= DOWN;
		
		if(!IsAdjacentFog(m, pos, DIR_LEFT))
			sides |= LEFT;
		
		if(!IsAdjacentFog(m, pos, DIR_RIGHT))
			sides |= RIGHT;
		
		if(!IsAdjacentFog(m, pos, DIR_LEFTUP))
			sides |= DIAG_UL;
		
		if(!IsAdjacentFog(m, pos, DIR_RIGHTUP))
			sides |= DIAG_UR;
		
		if(!IsAdjacentFog(m, pos, DIR_LEFTDOWN))
			sides |= DIAG_DL;
		
		if(!IsAdjacentFog(m, pos, DIR_RIGHTDOWN))
			sides |= DIAG_DR;
		
		//Screen->DrawInteger(6, ComboX(pos), ComboY(pos), FONT_Z3SMALL, 0x01, 0x0F, -1, -1, sides, 0, 128);
		switch(sides){
			case DIAG_UL: 
				return 44445;
			case DIAG_UR: 
				return 44446;
			case DIAG_DL: 
				return 44447;
			case DIAG_DR: 
				return 44448;
		}
		switch(sides&0xF){
			case UP:
				return 44441;
			case DOWN: 
				return 44442;
			case LEFT: 
				return 44443;
			case RIGHT: 
				return 44444;
			case CORNER_UL: 
				return 44449;
			case CORNER_UR: 
				return 44450;
			case CORNER_DL: 
				return 44451;
			case CORNER_DR: 
				return 44452;
			default:
				return 44440;
		}
	}
	void run(){
		int xPos = Rand(256);
		int yPos = Rand(256);
		int LinkAuraTime = 300;
		int damageTimer;
		int brangX; int brangY;
		int brangTimer;
		
		int fogGapX[16];
		int fogGapY[16];
		int fogGapCount;
		
		while(true){
			fogGapCount = 0;
			
			if(brangTimer)
				--brangTimer;
			for(int i=Screen->NumLWeapons(); i>0; --i){
				lweapon l = Screen->LoadLWeapon(i);
				if(l->ID==LW_LUNARANG){
					brangX = l->X;
					brangY = l->Y;
					brangTimer = 32;
				}
			}
			int BrangAuraW = Lerp(16, 96, brangTimer/32);
			bool safeZone;
			if(brangTimer&&Distance(Link->X+8, Link->Y+12, brangX+8, brangY+8)<BrangAuraW/2-8)
				safeZone = true;
			
			if(LinkAuraTime<=0){
				++damageTimer;
				G[G_STEPMOD] -= 0.4;
				if(damageTimer>40){
					damageTimer = 0;
					Game->PlaySound(SFX_OUCH);
					Link->HP -= 4;
				}
			}
			else{
				damageTimer = 0;
			}
			
			Waitdraw();
			
			xPos -= VectorX(0.45, -20);
			yPos -= VectorY(0.45, -20);
			xPos = Wrap(xPos, 0, 256);
			yPos = Wrap(yPos, 0, 256);
			int x = Floor(xPos);
			int y = Floor(yPos);
			GBMP[BMP_FOGLAYER2]->Clear(0);
			GBMP[BMP_FOGLAYER2MASK]->ClearToColor(0, 0x01);
			GBMP[BMP_FOGLAYER2]->BlitTo(0, GBMP[BMP_FOGLAYER], x, y, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
			
			if(G[G_SCREENCHANGED])
				brangTimer = 0;
			if(Game->Scrolling[SCROLL_DIR]>-1){
				mapdata l3 = Game->LoadTempScreen(3);
				mapdata l4 = Game->LoadTempScreen(4);
				mapdata ol3 = Game->LoadScrollingScreen(3);
				mapdata ol4 = Game->LoadScrollingScreen(4);
				for(int i=0; i<176; ++i){
					if(IsFogFlag(l4->ComboF[i])){
						GBMP[BMP_FOGLAYER2MASK]->DrawTile(0, ComboX(i)+Game->Scrolling[SCROLL_NX], ComboY(i)+Game->Scrolling[SCROLL_NY], FogMaskTile(l4, l3, i), 1, 1, 0, -1, -1, 0, 0, 0, 0, false, 128);
					}
					if(IsFogFlag(ol4->ComboF[i])){
						GBMP[BMP_FOGLAYER2MASK]->DrawTile(0, ComboX(i)+Game->Scrolling[SCROLL_OX], ComboY(i)+Game->Scrolling[SCROLL_OY], FogMaskTile(ol4, ol3, i), 1, 1, 0, -1, -1, 0, 0, 0, 0, false, 128);
					}
					
					if(l4->ComboF[i]==CF_LAKETEMPLEFOG4){
						fogGapX[fogGapCount] = ComboX(i)+Game->Scrolling[SCROLL_NX];
						fogGapY[fogGapCount] = ComboY(i)+Game->Scrolling[SCROLL_NY];
						++fogGapCount;
					}
					if(ol4->ComboF[i]==CF_LAKETEMPLEFOG4){
						fogGapX[fogGapCount] = ComboX(i)+Game->Scrolling[SCROLL_OX];
						fogGapY[fogGapCount] = ComboY(i)+Game->Scrolling[SCROLL_OY];
						++fogGapCount;
					}
				}
				brangTimer = 0;
			}
			else{
				mapdata l3 = Game->LoadTempScreen(3);
				mapdata l4 = Game->LoadTempScreen(4);
				for(int i=0; i<176; ++i){
					if(IsFogFlag(l4->ComboF[i])){
						GBMP[BMP_FOGLAYER2MASK]->DrawTile(0, ComboX(i), ComboY(i), FogMaskTile(l4, l3, i), 1, 1, 0, -1, -1, 0, 0, 0, 0, false, 128);
					}
					
					if(l4->ComboF[i]==CF_LAKETEMPLEFOG4){
						fogGapX[fogGapCount] = ComboX(i);
						fogGapY[fogGapCount] = ComboY(i);
						++fogGapCount;
					}
				}
			}
			
			
			GBMP[BMP_FOGLAYER2]->MaskedDraw(0, GBMP[BMP_FOGLAYER2MASK], 0x00);
			int LinkAuraW = Lerp(16, 64, LinkAuraTime/300);
			int LinkAuraTil = Choose(79560, 79568, 79820, 79828);
			if(LinkAuraTime>0)
				GBMP[BMP_FOGLAYER2]->DrawTile(0, Link->X+8-LinkAuraW/2+Rand(-2, 2), Link->Y+8-LinkAuraW/2+Rand(-2, 2), LinkAuraTil, 8, 8, 7, LinkAuraW, LinkAuraW, 0, 0, 0, 0, true, 128);
			LinkAuraTil = Choose(80080, 80088, 80340, 80348);
			if(brangTimer)
				GBMP[BMP_FOGLAYER2]->DrawTile(0, brangX+8-BrangAuraW/2+Rand(-2, 2), brangY+8-BrangAuraW/2+Rand(-2, 2), LinkAuraTil, 8, 8, 7, BrangAuraW, BrangAuraW, 0, 0, 0, 0, true, 128);
			for(int i=0; i<fogGapCount; ++i){
				LinkAuraTil = Choose(79560, 79568, 79820, 79828);
				GBMP[BMP_FOGLAYER2]->DrawTile(0, fogGapX[i]+8-32+Rand(-2, 2), fogGapY[i]+8-32+Rand(-2, 2), LinkAuraTil, 8, 8, 7, 64, 64, 0, 0, 0, 0, true, 128);
				if(Distance(Link->X+8, Link->Y+12, fogGapX[i]+8, fogGapY[i]+8)<32-8)
					safeZone = true;
			}
			
			if(Game->Scrolling[SCROLL_DIR]==-1){
				mapdata l4 = Game->LoadTempScreen(4);
				int cf = l4->ComboF[ComboAt(Link->X+8, Link->Y+12)];
				if((cf==CF_LAKETEMPLEFOG||cf==CF_LAKETEMPLEFOG2||cf==CF_LAKETEMPLEFOG3)&&!safeZone){
					G[G_SCRIPTJINX] = Max(G[G_SCRIPTJINX], 32);
					if(LinkAuraTime)
						--LinkAuraTime;
				}
				else{
					LinkAuraTime = Min(LinkAuraTime+5, 300);
				}
			}
			
			GBMP[BMP_FOGLAYER2]->ReplaceColors(0, 0x00, 0x71, 0x71);
			GBMP[BMP_FOGLAYER2]->Blit(3, RT_SCREEN, 0, 0, 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
			
			Waitframe();
		}
	}
}

dmapdata script StardustSpeedway{
	void run(){
		bitmap b = Game->CreateBitmap(512, 352);
		b->Own();
		b->Clear(0);
		b->DrawLayer(0, 49, 0x86, 0, 0, 0, 0, 128);
		b->DrawLayer(0, 49, 0x86, 0, 256, 0, 0, 128);
		b->DrawLayer(0, 49, 0x86, 0, 0, 176, 0, 128);
		b->DrawLayer(0, 49, 0x86, 0, 256, 176, 0, 128);
		
		bitmap b2 = Game->CreateBitmap(512, 352);
		b2->Own();
		b2->Clear(0);
		b2->DrawLayer(0, 49, 0x83, 0, 0, 0, 0, 128);
		b2->DrawLayer(0, 49, 0x83, 0, 256, 0, 0, 128);
		b2->DrawLayer(0, 49, 0x83, 0, 0, 176, 0, 128);
		b2->DrawLayer(0, 49, 0x83, 0, 256, 176, 0, 128);
		
		int scrollX[2] = {Rand(256), Rand(256)};
		int scrollY[2] = {Rand(176), Rand(176)};
		while(true){
			scrollX[0] -= VectorX(8, 75);
			scrollY[0] -= VectorY(8, 75);
			
			if(scrollX[0]<0)
				scrollX[0] += 256;
			if(scrollY[0]<0)
				scrollY[0] += 176;
			
			scrollX[1] -= VectorX(1, 55);
			scrollY[1] -= VectorY(1, 55);
			
			if(scrollX[1]<0)
				scrollX[1] += 256;
			if(scrollY[1]<0)
				scrollY[1] += 176;
			
			b2->Clear(0);
			b2->DrawLayer(0, 49, 0x83, 0, 0, 0, 0, 128);
			b2->DrawLayer(0, 49, 0x83, 0, 256, 0, 0, 128);
			b2->DrawLayer(0, 49, 0x83, 0, 0, 176, 0, 128);
			b2->DrawLayer(0, 49, 0x83, 0, 256, 176, 0, 128);
		
			b->Blit(3, RT_SCREEN, scrollX[0], scrollY[0], 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, false);
			b2->Blit(3, RT_SCREEN, scrollX[1], scrollY[1], 256, 176, 0, 0, 256, 176, 0, 0, 0, 0, 0, true);
			
			Waitframe();
		}
	}
}