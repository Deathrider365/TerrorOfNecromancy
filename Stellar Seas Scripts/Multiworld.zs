const bool MAPPOS_DEBUG = true;

int MultiworldData[65536];

enum MDIndices{
	MD_STARTSPLITS = 0, // Owners of each item location
	MD_STARTBITFLAGS = IL_COUNT, // Groups of bitflags representing collected items
	MD_STARTPLAYERDAT = MD_STARTBITFLAGS + ((IL_COUNT / 32 + .9999)<<0), // Groups of bitflags representing player ghost data
	MD_STARTITEMQUEUE = MD_STARTPLAYERDAT + (GP_SIZE * 16), // Queue of item locations to give to the player sent from other players
	MD_STARTGEODE = MD_STARTITEMQUEUE + 512, // Geode cooldowns
	MD_DOCKLISTS = MD_STARTGEODE + 64, // Dock point listings
	MD_STARTVARS = MD_DOCKLISTS + 16, // Misc variables
	MD_ITEMQUEUESIZE,
	MD_CHECKIN // Number of users that have checked in
};

enum GhostProperties{
	GP_X,
	GP_Y,
	GP_TILE,
	GP_FLIP, 
	GP_DMAP,
	GP_SCREEN,
	GP_GEODE,
	GP_CHARID,
	
	// Tween position
	GP_TWEENX,
	GP_TWEENY,
	GP_TWEENDMAP,
	GP_TWEENSCREEN,
	
	// Targetting position when player is in another map
	GP_REMOTEX,
	GP_REMOTEY,
	GP_REMOTEDMAP,
	GP_REMOTESCREEN,
	GP_SIZE
};

generic script ZLinkRead{
	using namespace ZLink;
	void run(){
		int itemCooldown;
		int lastDMap = Game->GetCurDMap();
		int lastScreen = Game->GetCurScreen();
		int entranceData[65535];
		Init();
		while(true){
			WaitTo(SCR_TIMING_POST_POLL_INPUT, true);
			if(G[G_MULTIPLAYERACTIVE]){
				bool thisChangedScreen;
				int thisLoc = NetGhost_DMapRegion(Game->GetCurDMap());
				Update();
				if(lastDMap!=Game->GetCurDMap()||lastScreen!=Game->GetCurScreen()){
					EntranceData_Load(thisLoc, entranceData);
					lastDMap = Game->GetCurDMap();
					lastScreen = Game->GetCurScreen();
					thisChangedScreen = true;
				}
				if(itemCooldown>0){
					--itemCooldown;
				}
				else{
					if(MultiworldData[MD_ITEMQUEUESIZE]>0){
						Game->PlaySound(25);
						// Get the item at the front of the queue
						int loc = MultiworldData[MD_STARTITEMQUEUE];
						int id = MultiworldData[MD_STARTITEMQUEUE+1];
						GiveItemAtLocSilent(loc);
						eweapon e = CreateEWeaponAt(EW_SCRIPT10, 120, 80);
						e->CollDetection = false;
						e->DrawYOffset = -1000;
						RunEWeaponScript(e, "ItemPopup", {RandomizedItems[loc], id});
						// Copy the end of the queue to the front and reduce the size
						MultiworldData[MD_STARTITEMQUEUE] = MultiworldData[MD_STARTITEMQUEUE] + MultiworldData[MD_ITEMQUEUESIZE] * 2 - 2;
						MultiworldData[MD_STARTITEMQUEUE+1] = MultiworldData[MD_STARTITEMQUEUE+1] + MultiworldData[MD_ITEMQUEUESIZE] * 2 - 2;
						--MultiworldData[MD_ITEMQUEUESIZE];
					}
					itemCooldown = 10;
				}
				if(Game->Scrolling[SCROLL_DIR] == -1 && !NoDrawGhosts()){
					int ghostsOnScreen[17];
					for(int i=0; i<16; ++i){
						int til = MultiworldData[MD_STARTPLAYERDAT + GP_SIZE * i + GP_TILE];
						// Tile 0 = Ghost deactivated
						if(til){
							bool theyChangedScreen;
							
							int dmap = MultiworldData[MD_STARTPLAYERDAT + GP_SIZE * i + GP_DMAP];
							int scrn = MultiworldData[MD_STARTPLAYERDAT + GP_SIZE * i + GP_SCREEN];
							int x = MultiworldData[MD_STARTPLAYERDAT + GP_SIZE * i + GP_X];
							int y = MultiworldData[MD_STARTPLAYERDAT + GP_SIZE * i + GP_Y];
							int tweenX = MultiworldData[MD_STARTPLAYERDAT + GP_SIZE * i + GP_TWEENX];
							int tweenY = MultiworldData[MD_STARTPLAYERDAT + GP_SIZE * i + GP_TWEENY];
							int tweendmap = MultiworldData[MD_STARTPLAYERDAT + GP_SIZE * i + GP_TWEENDMAP];
							int tweenscreen = MultiworldData[MD_STARTPLAYERDAT + GP_SIZE * i + GP_TWEENSCREEN];
							
							// When ghosts change screens, set their tween position to their new position
							if(dmap!=tweendmap||scrn!=tweenscreen){
								theyChangedScreen = true;
								tweenX = x;
								tweenY = y;
								MultiworldData[MD_STARTPLAYERDAT + GP_SIZE * i + GP_TWEENDMAP] = dmap;
								MultiworldData[MD_STARTPLAYERDAT + GP_SIZE * i + GP_TWEENSCREEN] = scrn;
							}
							// Otherwise if they're away from their intended position, move them towards it
							int ang = Angle(tweenX, tweenY, x, y);
							int dist = Distance(tweenX, tweenY, x, y);
							if(dist<=1.5){
								tweenX = x;
								tweenY = y;
							}
							else if(dist<=8){
								tweenX += VectorX(1.5, ang);
								tweenY += VectorY(1.5, ang);
							}
							else if(dist<=32){
								tweenX += VectorX(2, ang);
								tweenY += VectorY(2, ang);
							}
							else{
								tweenX += VectorX(4, ang);
								tweenY += VectorY(4, ang);
							}
							MultiworldData[MD_STARTPLAYERDAT + GP_SIZE * i + GP_TWEENX] = tweenX;
							MultiworldData[MD_STARTPLAYERDAT + GP_SIZE * i + GP_TWEENY] = tweenY;
							
							// If the ghost is on the screen with the player, draw them
							if(dmap==Game->GetCurDMap()&&scrn==Game->GetCurDMapScreen()){
								ghostsOnScreen[ghostsOnScreen[16]] = i+1;
								++ghostsOnScreen[16];
								
								int which = MultiworldData[MD_STARTPLAYERDAT + GP_SIZE * i + GP_CHARID];
								
								if(til && Rand(3)!=0){
									int flip = MultiworldData[MD_STARTPLAYERDAT + GP_SIZE * i + GP_FLIP];
									int xoff = 0;
									if(Rand(8)==0)
										xoff = Choose(-2, 2);
									int xy[2];
									NetSpriteXY(xy, til, which);
									bitmap plyr = Game->CreateBitmap(16, 32);
									plyr->Clear(0);
									GBMP[BMP_MULTIPLAYERSPRITES]->Blit(2, plyr, NetSpritesheetX(which, i)+xy[0], NetSpritesheetY(which, i)+xy[1], 16, 32, 0, 0, 16, 32, 0, 0, 0, BITDX_NORMAL, 0, true);
									int bflip = BITDX_TRANS;
									if(flip)
										bflip |= BITDX_HFLIP;
									plyr->Blit(2, RT_SCREEN, 0, 0, 16, 32, tweenX+xoff, tweenY-16, 16, 32, 0, 0, 0, bflip, 0, true);
									plyr->Free();
								}
								int geode = MultiworldData[MD_STARTPLAYERDAT + GP_SIZE * i + GP_GEODE];
								if(til){
									int username[33];
									ZLink::GetUsername(username, i+1);
									Screen->DrawString(6, tweenX+8, tweenY-12, FONT_Z3SMALL, UsernameColor(i), -1, TF_CENTERED, username, 128, SHD_OUTLINED8, 0x0F);
									if(geode){
										Screen->FastTile(6, tweenX+8-10-Text->StringWidth(username, FONT_Z3SMALL)/2, tweenY-14, 72024+20*(geode-1), 0, 128);
									}
								}
								if(G[G_CURRENTGEODE]){
									int weakness = ResolveGeodeElementWeakness(G[G_CURRENTGEODE], geode);
									if(weakness>-1&&RectCollision(Link->X+2, Link->Y+2, Link->X+13, Link->Y+13, tweenX+2, tweenY+2, tweenX+13, tweenY+13)){
										int element = G[G_CURRENTGEODE];
										MakeGeodeExplosion(i+1, weakness==0?0:element, (Link->X+tweenX)/2, (Link->Y+tweenY)/2, weakness!=0, true);
										G[G_CURRENTGEODE] = 0;
									}
								}
							}
							else{
								// If the player has a geode they can still track them though
								if(G[G_CURRENTGEODE]){
									int theirLoc = NetGhost_DMapRegion(dmap);
									TraceToScreen("thisLoc", 0, 32+16*i, thisLoc);
									TraceToScreen("theirLoc", 0, 40+16*i, theirLoc);
									// Both players are on the same island
									if(thisLoc==theirLoc){
										int thisSection = NetGhost_DMapSubRegion(Game->GetCurDMap(), Game->GetCurScreen());
										int theirSection = NetGhost_DMapSubRegion(dmap, DMapToMap(scrn, dmap));
										TraceToScreen("thisSection", 128, 32+16*i, thisSection);
										TraceToScreen("theirSection", 128, 40+16*i, theirSection);
										// And on the same submap, we can point to the player directly
										if(thisSection==theirSection){
											int x = MultiworldData[MD_STARTPLAYERDAT + GP_SIZE * i + GP_X];
											int y = MultiworldData[MD_STARTPLAYERDAT + GP_SIZE * i + GP_Y];
											int xyThis[2];
											int xyTheirs[2];
											NetGhost_GetTrueMapPos(xyThis, Game->GetCurDMap(), Game->GetCurDMapScreen(), Link->X, Link->Y);
											NetGhost_GetTrueMapPos(xyTheirs, dmap, scrn, x, y);
											int dist = LargeDistance(xyThis[0], xyThis[1], xyTheirs[0], xyTheirs[1], 16);
											int ang = Angle(xyThis[0], xyThis[1], xyTheirs[0], xyTheirs[1]);
											int ratio;
											if(dist<256){
												ratio = 1;
											}
											else if(dist<256*2){
												ratio = 3;
											}
											else{
												ratio = 6;
											}
											if(ratio==1||G[G_ANIM]%ratio==0){
												int geode = MultiworldData[MD_STARTPLAYERDAT + GP_SIZE * i + GP_GEODE];
												int markerTil = 72025;
												if(geode)
													markerTil = 72024+20*(geode-1);
												Screen->FastTile(2, Link->X+4+VectorX(24, ang), Link->Y+4+VectorY(24, ang), markerTil, 0, 128);
											}
										}
										// ...Or they're on another submap. Things get trickier
										else{
											int tweendmap = MultiworldData[MD_STARTPLAYERDAT + GP_SIZE * i + GP_TWEENDMAP];
											int tweenscreen = MultiworldData[MD_STARTPLAYERDAT + GP_SIZE * i + GP_TWEENSCREEN];
											int dsxy[4];
											// If they've changed screens or we've changed screens...
											if(theyChangedScreen || thisChangedScreen){
												// Calculate the location of the nearest entrance
												EntranceData_GetNearest(entranceData, dsxy, thisSection, theirSection);
												MultiworldData[MD_STARTPLAYERDAT + GP_SIZE * i + GP_TWEENDMAP] = dmap;
												MultiworldData[MD_STARTPLAYERDAT + GP_SIZE * i + GP_TWEENSCREEN] = scrn;
												
												// Store that in the global array for later
												MultiworldData[MD_STARTPLAYERDAT + GP_SIZE * i + GP_REMOTEDMAP] = dsxy[0];
												MultiworldData[MD_STARTPLAYERDAT + GP_SIZE * i + GP_REMOTESCREEN] = dsxy[1];
												MultiworldData[MD_STARTPLAYERDAT + GP_SIZE * i + GP_REMOTEX] = dsxy[2];
												MultiworldData[MD_STARTPLAYERDAT + GP_SIZE * i + GP_REMOTEY] = dsxy[3];
											}
											else{
												// Otherwise, load the position from the global array, this is faster
												dsxy[0] = MultiworldData[MD_STARTPLAYERDAT + GP_SIZE * i + GP_REMOTEDMAP];
												dsxy[1] = MultiworldData[MD_STARTPLAYERDAT + GP_SIZE * i + GP_REMOTESCREEN];
												dsxy[2] = MultiworldData[MD_STARTPLAYERDAT + GP_SIZE * i + GP_REMOTEX];
												dsxy[3] = MultiworldData[MD_STARTPLAYERDAT + GP_SIZE * i + GP_REMOTEY];
											}
											
											int xyThis[2];
											int xyTheirs[2];
											NetGhost_GetTrueMapPos(xyThis, Game->GetCurDMap(), Game->GetCurDMapScreen(), Link->X, Link->Y);
											NetGhost_GetTrueMapPos(xyTheirs, dsxy[0], MapToDMap(dsxy[1], dsxy[0]), dsxy[2], dsxy[3]);
											TraceToScreen("xTheirs", 128, 80+16*i, xyTheirs[0]);
											TraceToScreen("yTheirs", 128, 88+16*i, xyTheirs[1]);
											TraceToScreen("d", 128+64, 80+16*i, dsxy[0]);
											TraceToScreen("s", 128+64, 88+16*i, dsxy[1]);
											TraceToScreen("x", 128+64+32, 80+16*i, dsxy[2]);
											TraceToScreen("y", 128+64+32, 88+16*i, dsxy[3]);
											// If the entrance is on the current DMap, draw a marker below it
											if(dsxy[0]==Game->GetCurDMap()&&dsxy[1]==Game->GetCurScreen()){
												if(G[G_ANIM]%8==0){
													int geode = MultiworldData[MD_STARTPLAYERDAT + GP_SIZE * i + GP_GEODE];
													int markerTil = 72025;
													if(geode)
														markerTil = 72024+20*(geode-1);
													Screen->FastTile(2, dsxy[2]+4, dsxy[3]+4, markerTil, 0, 128);
												}
											}
											// Otherwise draw a marker pointing to it
											else{
												int dist = LargeDistance(xyThis[0], xyThis[1], xyTheirs[0], xyTheirs[1], 16);
												int ang = Angle(xyThis[0], xyThis[1], xyTheirs[0], xyTheirs[1]);
												if(G[G_ANIM]%8==0){
													int geode = MultiworldData[MD_STARTPLAYERDAT + GP_SIZE * i + GP_GEODE];
													int markerTil = 72025;
													if(geode)
														markerTil = 72024+20*(geode-1);
													Screen->FastTile(2, Link->X+4+VectorX(24, ang), Link->Y+4+VectorY(24, ang), markerTil, 0, 128);
												}
											}
										}
									}
								}
							}
						}
					}
					if(G[G_MULTIPLAYERACTIVE]==3){
						if(G[G_CURRENTGEODE]){
							Screen->FastTile(7, 4, 4, 72024+20*(G[G_CURRENTGEODE]-1), 0, 128);
							int label[64];
							switch(G[G_CURRENTGEODE]){
								case 1:
									strcpy(label, "EX3: Flash");
									break;
								case 2:
									strcpy(label, "EX3: Telekinesis");
									break;
								case 3:
									strcpy(label, "EX3: Starfall");
									break;
								case 4:
									strcpy(label, "EX3: ???");
									break;
								case 5:
									strcpy(label, "EX3: Warp");
									break;
								case 6:
									strcpy(label, "EX3: Black Hole");
									break;
							}
							Screen->DrawString(6, 4+10, 6, FONT_Z3SMALL, 0x01, -1, TF_NORMAL, label, 128, SHD_OUTLINED8, 0x0F);
						
							if(Link->PressEx3&&(Link->Action==LA_NONE||Link->Action==LA_WALKING)){
								ZLink::OpenPacket();
								SendGeodeEffect(ghostsOnScreen, G[G_CURRENTGEODE]);
								ZLink::SendPacket();
								UseGeodeAnimation(ThisUserID(), G[G_CURRENTGEODE], GetCharID());
								G[G_CURRENTGEODE] = 0;
							}
						}
						for(int i=0; i<64; ++i){
							if(MultiworldData[MD_STARTGEODE+i])
								--MultiworldData[MD_STARTGEODE+i];
						}
						if(G[G_QUEUEDGEODEANIMSENDER]){
							UseGeodeAnimation(G[G_QUEUEDGEODEANIMSENDER], G[G_QUEUEDGEODEANIMEFFECT], G[G_QUEUEDGEODEANIMCHAR]);
							G[G_QUEUEDGEODEANIMSENDER] = 0;
						}
					}
				}
			}
			Waitframe();
		}
	}
}

int UsernameColor(int id){
	switch(id%8){
		case 0:
			return 0x83;
		case 1:
			return 0x73;
		case 2:
			return 0x93;
		case 3:
			return 0x88;
		case 4:
			return 0x78;
		case 5:
			return 0x98;
		case 6:
			return 0xA3;
		case 7:
			return 0xB8;
	}
}

bool NoDrawGhosts(){
	switch(Game->GetCurDMap()){
		case 29:
			return true;
	}
	return false;
}

generic script ZLinkWrite{
	using namespace ZLink;
	void run(){
		if(!G[G_MULTIPLAYERACTIVE])
			Quit();
		FreezeAndWaitForServer();
		UpdateDockUserlist(Game->GetCurDMap());
		int timeout;
		while(true){
			OpenPacket(true);
			OUT_SendPosition();
			OUT_SendReady(ThisUserID());
			SendPacket();
			Waitframe();
			while(!InstructionReceived(MSG_SENDREADY)&&timeout<60){
				++timeout;
				Waitframe();
			}
			timeout = 0;
			Waitframe();
		}
	}
}

void FreezeAndWaitForServer(){
	Waitframes(2);
	genericdata gd = Game->LoadGenericData(Game->GetGenericScript("FreezeWaitConnect"));
	gd->RunFrozen();
}

generic script FreezeWaitConnect{
	using namespace ZLink;
	void run(){
		int t[1];
		if(G[G_MULTIPLAYERFIRSTCONNECT]){
			DrawWaitForServer(t);
			Waitframe();
			// Wait for the output file to be freed
			while(FlaggedOutput()){
				DrawWaitForServer(t);
				Update();
				Waitframe();
			}
			printf("PASS 1: Wait for lock...\n");
			// PASS 1: Wait for the server to lock
			while(!IsServerLocked()){
				OpenPacket();
				OUT_IsServerLocked();
				SendPacket();
				while(!InstructionReceived(MSG_ISSERVERLOCKED)){
					DrawWaitForServer(t);
					Update();
					Waitframe();
				}
				DrawWaitForServer(t);
				Update();
				Waitframe();
			}
			printf("PASS 2: Get user data...\n");
			// PASS 2: Get user data
			OpenPacket();
			OUT_GetAllIDs();
			OUT_GetHostID();
			OUT_GetAllUsernames();
			SendPacket();
			while(!InstructionReceived(MSG_GETALLUSERNAMES)){
				DrawWaitForServer(t);
				Update();
				Waitframe();
			}
			printf("PASS 3: Check In...\n");
			// PASS 3: Check in
			MultiworldData[MD_CHECKIN] = (1<<(ThisUserID()-1));
			if(ThisUserID()==HostID()){
				while(CountCheckIn()<NumUsers()){
					OpenPacket();
					OUT_CheckIn();
					SendPacket();
					DrawWaitForServer(t);
					Update();
					Waitframe();
				}
				OpenPacket();
				OUT_SendReady(ThisUserID());
				OUT_SendReady(0);
				SendPacket();
				while(!InstructionReceived(MSG_SENDREADY)){
					DrawWaitForServer(t);
					Update();
					Waitframe();
				}
			}
			else{
				while(!InstructionReceived(MSG_SENDREADY)){
					OpenPacket();
					OUT_CheckIn();
					SendPacket();
					DrawWaitForServer(t);
					Update();
					Waitframe();
				}
			}
			printf("PASS 4: Send info...\n");
			// PASS 4 (Host only): Send run info & costumes
			if(ThisUserID()==HostID()){
				OpenPacket();
				OUT_SendRunInfo();
				OUT_SendCostumes(0);
				OUT_CheckIn();
				SendPacket();
			} // Pass 4: (Client only): Send costumes
			else{
				OpenPacket();
				OUT_SendCostumes(0);
				SendPacket();
			}
			printf("PASS 5: Send ready...\n");
			// PASS 5: (Host only) Send ready
			if(ThisUserID()==HostID()){
				while(!InstructionReceived(MSG_SENDCOSTUMES)){
					DrawWaitForServer(t);
					Update();
					Waitframe();
				}
				OpenPacket();
				OUT_SendReady(0);
				OUT_SendReady(ThisUserID());
				SendPacket();
			}
			while(!InstructionReceived(MSG_SENDREADY)){
				DrawWaitForServer(t);
				Update();
				Waitframe();
			}
		}
		else{
			OpenPacket();
			OUT_SendCostumes(0);
			OUT_RequestCostumes();
			SendPacket();
		}
		int outfit[8];
		for(int i=0; i<6; ++i){
			outfit[0] = G[G_SHIRT+i];
			outfit[1] = G[G_SHIRTCOLOR+i];
			outfit[2] = G[G_PANTS+i];
			outfit[3] = G[G_PANTSCOLOR+i];
			outfit[4] = G[G_ACCESSORY1+i];
			outfit[5] = G[G_ACCESSORY1COLOR+i];
			outfit[6] = G[G_ACCESSORY2+i];
			outfit[7] = G[G_ACCESSORY2COLOR+i];
			SetUpOutfit(i, ThisUserID()-1, outfit);
		}
	}
	void DrawWaitForServer(int t){
		++t[0];
		t[0] %= 360;
		Screen->Rectangle(7, 0, 0, 255, 175, 0x0F, 1, 0, 0, 0, true, 64);
		int st = Round(6*(0.5+0.5*Sin(t[0]*2))) % 6;
		int str[] = "Waiting on server...";
		switch(st){
			case 0:
				Screen->DrawString(7, 128, 88, FONT_Z1, 0x01, -1, TF_CENTERED, str, 128, SHD_OUTLINED8, 0x0F);
				break;
			case 1:
			case 5:
				Screen->DrawString(7, 128, 88, FONT_Z1, 0x01, -1, TF_CENTERED, str, 64, SHD_OUTLINED8, 0x0F);
				Screen->DrawString(7, 128, 88, FONT_Z1, 0x01, -1, TF_CENTERED, str, 64, SHD_OUTLINED8, 0x0F);
				break;
			case 2:
			case 4:
				Screen->DrawString(7, 128, 88, FONT_Z1, 0x01, -1, TF_CENTERED, str, 64, SHD_OUTLINED8, 0x0F);
				break;
			case 3:
				break;
		}
		if(CountCheckIn()>0){
			int str2[16];
			sprintf(str2, "%d / %d", CountCheckIn(), NumUsers());
			Screen->DrawString(7, 8, 152, FONT_Z1, 0x01, -1, TF_NORMAL, str2, 128, SHD_OUTLINED8, 0x0F);
		}
	}
	int CountCheckIn(){
		int count;
		for(int i=0; i<16; ++i){
			if(MultiworldData[MD_CHECKIN]&(1<<i))
				++count;
		}
		return count;
	}
}

void SetMultiworldFlag(int loc){
	int idx = Floor(loc/32);
	int b = 1L << (loc%32);
	MultiworldData[MD_STARTBITFLAGS+idx] |= b;
}

void GiveItemAtLocSilent(int loc){
	int itemID = RandomizedItems[loc];
	switch(itemID){
		// Dashes
		case 170:
		case 178:
			if(Link->Item[170])
				itemID = 170;
			Link->Item[itemID] = true;
			FoundItems[itemID] = true;
			break;
		case 87:
			++Game->Counter[CR_HYMNSTONES];
			break;
		default:
			Link->Item[itemID] = true;
			FoundItems[itemID] = true;
			break;
	}
	SetMultiworldFlag(loc);
}

void SendMultiworldItem(int loc){
	if(G[G_MULTIPLAYERACTIVE]==2&&MultiworldData[MD_STARTSPLITS+loc]==ZLink::ThisUserID()&&!ZLink::FilterSentItems(loc)){
		ZLink::OpenPacket();
		ZLink::OUT_SendItem(loc);
		ZLink::SendPacket();
		SetMultiworldFlag(loc);
	}
}

bool IsMultiworld(){
	return G[G_MULTIPLAYERACTIVE]>=2;
}

ffc script GeodePickup{
	void run(int loc, int type){
		if(G[G_MULTIPLAYERACTIVE]!=3)
			Quit();
		bool active = MultiworldData[MD_STARTGEODE+loc] <= 0;
		while(true){
			while(active){
				int x = this->X;
				int y = this->Y+4*Sin(G[G_ANIM]*2);
				Screen->FastCombo(2, x, y, this->Data, 0, 128);
				if(RectCollision(Link->X+4, Link->Y+4, Link->X+11, Link->Y+11, x+4, y+4, x+11, y+11)){
					G[G_CURRENTGEODE] = type;
					RunEWeaponEffect(x, y, "GenParticle", {GP_GEODEBURST, type, 0});
					MultiworldData[MD_STARTGEODE+loc] = 300;
					active = false;
					ZLink::OpenPacket();
					ZLink::OUT_PickupGeode(loc, 300);
					ZLink::SendPacket();
				}
				else if(MultiworldData[MD_STARTGEODE+loc]){
					RunEWeaponEffect(x, y, "GenParticle", {GP_GEODEBURST, type, 2});
					active = false;
				}
				Waitframe();
			}
			while(!active){
				if(MultiworldData[MD_STARTGEODE+loc] <= 0){
					RunEWeaponEffect(this->X, this->Y, "GenParticle", {GP_GEODEBURST, type, 1});
					active = true;
				}
				Waitframe();
			}
		}
	}
}

void MakeGeodeExplosion(int target, int element, int x, int y, bool friendly, bool sendMessage){
	eweapon e = CreateEWeaponAt(EW_SCRIPT10, Clamp(x, 2, 238), Clamp(y, 2, 158));
	e->CollDetection = false;
	e->DrawYOffset = -1000;
	RunEWeaponScript(e, "GeodeCollision", {0, element, 64, friendly});
	if(sendMessage){
		int ghostsOnScreen[17];
		ZLink::OpenPacket();
		ZLink::OUT_GeodeCollision(target, element, x, y, Game->GetCurMap(), Game->GetCurScreen());
		SendGeodeEffect(ghostsOnScreen, element);
		ZLink::SendPacket();
	}
}

const int GE_NEUTRAL = 0;
const int GE_SOLAR = 1;
const int GE_LUNAR = 2;
const int GE_STELLAR = 3;
const int GE_SOLARLUNAR = 4;
const int GE_LUNARSTELLAR = 5;
const int GE_STELLARSOLAR = 6;
const int GE_COSMIC = 7;

int ResolveGeodeElementWeakness(int myElement, int theirElement){
	if(myElement==theirElement) // Element ties
		return 0;
	if(myElement&&!theirElement) // Having an element is better than nothing
		return 1;
	if(myElement==GE_COSMIC) //Cosmic trumps all
		return 1;
		
	switch(myElement){
		case GE_SOLAR:
			if(theirElement==GE_LUNAR)
				return 1;
			return -1;
			break;
		case GE_LUNAR:
			if(theirElement==GE_STELLAR)
				return 1;
			return -1;
			break;
		case GE_STELLAR:
			if(theirElement==GE_SOLAR)
				return 1;
			return -1;
			break;
		case GE_SOLARLUNAR:
			if(theirElement==GE_SOLAR||theirElement==GE_LUNAR||theirElement==GE_STELLAR)
				return 1;
			if(theirElement==GE_LUNARSTELLAR)
				return 1;
			return -1;
			break;
		case GE_LUNARSTELLAR:
			if(theirElement==GE_SOLAR||theirElement==GE_LUNAR||theirElement==GE_STELLAR)
				return 1;
			if(theirElement==GE_STELLARSOLAR)
				return 1;
			return -1;
			break;
		case GE_STELLARSOLAR:
			if(theirElement==GE_SOLAR||theirElement==GE_LUNAR||theirElement==GE_STELLAR)
				return 1;
			if(theirElement==GE_SOLARLUNAR)
				return 1;
			return -1;
			break;
	}
}

void SendGeodeEffect(int ghostsOnScreen, int effect){
	switch(effect){
		default:
			if(ghostsOnScreen[16]>0){
				for(int i=0; i<ghostsOnScreen[16]; ++i){
					ZLink::OUT_GeodeEffect(ghostsOnScreen[i], G[G_CURRENTGEODE], 1, GetCharID());
				}
			}
			else{
				ZLink::OUT_GeodeEffect(0, G[G_CURRENTGEODE], 0, GetCharID());
			}
			break;
	}
}

void UseGeodeAnimation(int userID, int geode, int charID){
	genericdata gd = Game->LoadGenericData(Game->GetGenericScript("GeodeUseAnim"));
	gd->InitD[0] = userID;
	gd->InitD[1] = geode;
	gd->InitD[2] = charID;
	gd->RunFrozen();
}

generic script GeodeUseAnim{
	enum{
		STATE,
		PAL,
		USERID,
		GEODE,
		NAME,
		TILE,
		CHARID,
		SCALE,
		OFFSETY,
		ENERGYW,
		ENERGYH,
		BGANIM,
		BGCOLOR
	};
	void run(int userID, int geode, int charID){
		int name[33];
		ZLink::GetUsername(name, userID);
		int palSolar[6]   = {0x01, 0x86, 0x87, 0x88, 0x89, 0x5B};
		int palLunar[6]   = {0x01, 0x72, 0x73, 0x74, 0x75, 0x7F};
		int palStellar[6] = {0x01, 0x96, 0x97, 0x98, 0x99, 0xBF};
		int palCosmic[6]  = {0x01, 0x76, 0x77, 0x78, 0x79, 0x59};
		untyped dat[16];
		switch(geode){
			case 1:
				dat[PAL] = palSolar;
				break;
			case 2:
				dat[PAL] = palLunar;
				break;
			case 3:
				dat[PAL] = palStellar;
				break;
			case 4:
				dat[PAL] = palSolar;
				break;
			case 5:
				dat[PAL] = palLunar;
				break;
			case 6:
				dat[PAL] = palStellar;
				break;
			case 7:
				dat[PAL] = palCosmic;
				break;
		}
		int pal = dat[PAL];
		dat[USERID] = userID;
		dat[GEODE] = geode;
		dat[NAME] = name;
		dat[TILE] = 104140;
		dat[CHARID] = charID;
		dat[SCALE] = 0.1;
		int bgAnimX[32];
		int bgAnimY[32];
		int bgAnimStep[32];
		for(int i=0; i<32; ++i){
			bgAnimX[i] = Rand(256);
			bgAnimY[i] = Rand(-56-4*8, 176+4*8);
			bgAnimStep[i] = Rand(75, 100)/100;
		}
		int bgAnim[5] = {pal[3], 0, bgAnimX, bgAnimY, bgAnimStep};
		dat[BGANIM] = bgAnim;
		for(int i=0; i<12; ++i){
			dat[OFFSETY] = Lerp(0, -32, i/11);
			dat[SCALE] = Lerp(0.1, 1, i/11);
			Draw(dat);
			Waitframe();
		}
		dat[TILE] = 104152;
		for(int i=0; i<24; ++i){
			Draw(dat);
			Waitframe();
		}
		dat[STATE] = 1;
		for(int i=0; i<24; ++i){
			Draw(dat);
			Waitframe();
		}
		dat[STATE] = 2;
		bgAnim[0] = pal[3];
		bgAnim[1] = 8;
		Game->PlaySound(94);
		for(int i=0; i<8; ++i){
			dat[ENERGYW] = Lerp(4, 8, i/7);
			dat[ENERGYH] = Lerp(4, 64, i/7);
			dat[OFFSETY] += 8;
			Draw(dat);
			Waitframe();
		}
		bgAnim[0] = pal[2];
		bgAnim[1] = 8;
		dat[BGCOLOR] = pal[3];
		for(int i=0; i<8; ++i){
			dat[ENERGYW] = Lerp(4, 128, i/7);
			dat[ENERGYH] = Lerp(64, 4, i/7);
			dat[OFFSETY] += 8;
			Draw(dat);
			Waitframe();
		}
		Game->PlaySound(75);
		bgAnim[0] = pal[1];
		bgAnim[1] = 12;
		dat[BGCOLOR] = pal[2];
		for(int i=0; i<12; ++i){
			dat[OFFSETY] += 12;
			Draw(dat);
			Waitframe();
		}
		bgAnim[0] = pal[0];
		bgAnim[1] = 16;
		dat[BGCOLOR] = pal[1];
		for(int i=0; i<12; ++i){
			dat[OFFSETY] += 16;
			Draw(dat);
			Waitframe();
		}
		bgAnim[0] = pal[1];
		bgAnim[1] = 24;
		dat[BGCOLOR] = pal[0];
		for(int i=0; i<48; ++i){
			if(i==16)
				dat[STATE] = 3;
			dat[OFFSETY] += 24;
			Draw(dat);
			Waitframe();
		}
	}
	void DrawBackground(untyped dat){
		int bgAnim = dat[BGANIM];
		int bgAnimX = bgAnim[2];
		int bgAnimY = bgAnim[3];
		int bgAnimStep = bgAnim[4];
		int w = Lerp(6, 3, (bgAnim[1]-8)/15);
		for(int i=0; i<32; ++i){
			bgAnimY[i] += bgAnimStep[i]*bgAnim[1];
			Screen->Ellipse(6, bgAnimX[i], bgAnimY[i], w, 4*bgAnim[1], bgAnim[0], 1, 0, 0, 0, true, 128);
			if(bgAnimY[i]>=176+4*bgAnim[1]&&dat[STATE]<3){
				bgAnimX[i] = Rand(256);
				bgAnimY[i] = -4*bgAnim[1]-56;
				bgAnimStep[i] = Rand(75, 100)/100;
			}
		}
	}
	void Draw(untyped dat){
		int pal = dat[PAL];
		int state = dat[STATE];
		int userID = dat[USERID];
		int geode = dat[GEODE];
		int name = dat[NAME];
		int charID = dat[CHARID];
		int tile = dat[TILE]+CharLTM(charID);
		int yOff = dat[OFFSETY];
		int scale = dat[SCALE];
		int bgCol = dat[BGCOLOR];
		bitmap plyr = Game->CreateBitmap(16, 32);
		bitmap scene = Game->CreateBitmap(256, 176);
		plyr->Clear(0);
		scene->Clear(0);
		scene->Ellipse(0, 128+Rand(-2, 2), 176-64+Rand(-2, 2), 128, 64, pal[5], 1, 0, 0, 0, true, 128);
		scene->Ellipse(0, 128+Rand(-2, 2), 176-64+Rand(-2, 2), 128*0.9, 64*0.9, pal[4], 1, 0, 0, 0, true, 128);
		scene->Ellipse(0, 128+Rand(-2, 2), 176-64+Rand(-2, 2), 128*0.75, 64*0.8, pal[3], 1, 0, 0, 0, true, 128);
		
		int xy[2];
		NetSpriteXY(xy, tile, charID);
		GBMP[BMP_MULTIPLAYERSPRITES]->Blit(0, plyr, NetSpritesheetX(charID, userID-1)+xy[0], NetSpritesheetY(charID, userID-1)+xy[1], 16, 32, 0, 0, 16, 32, 0, 0, 0, BITDX_NORMAL, 0, true);
		plyr->Blit(0, scene, 0, 0, 16, 32, 128-24, 176-64-96, 48, 96, 0, 0, 0, BITDX_NORMAL, 0, true);
		if(scale>=1){
			scene->DrawString(0, 128, 176-64+8, FONT_L, 0x01, -1, TF_CENTERED, name, 128, SHD_OUTLINED8, 0x0F);
		}
		int geodeX = 128-13*3;
		int geodeY = 176-64-32*3;
		if(state>0)
			scene->DrawTile(0, geodeX, geodeY, 72020+(geode-1)*20, 1, 1, 0, 48, 48, 0, 0, 0, 0, true, 128);
		Screen->Rectangle(6, 0, -56, 255, 175, bgCol, 1, 0, 0, 0, true, 128);
		if(state>1)
			DrawBackground(dat);
		scene->Blit(6, RT_SCREEN, 0, 0, 256, 176, 128-128*scale, 176-32-88*scale+yOff, 256*scale, 176*scale, 0, 0, 0, BITDX_NORMAL, 0, true);
		if(state>1)
			Screen->Ellipse(6, geodeX+24, geodeY+56+24+yOff, dat[ENERGYW], dat[ENERGYH], pal[Rand(1, 3)], 1, 0, 0, 0, true, 128);
		plyr->Free();
		scene->Free();
	}
}

int NetGhost_DMapRegion(int dmap){
	int loc = DMapLocation(dmap);
	switch(dmap){
		case 0:
		case 1:
		case 2:
		case 3:
		case 4:
		case 5:
		case 7:
		case 9:
		case 15:
		case 24:
		case 25:
		case 78:
			return LOC_OMAKA;
	}
	switch(loc){
		case LOC_PUNA:
		case LOC_OMAKA:
		case LOC_WAREHOUSE:
		case LOC_MANOR:
		case LOC_CATACOMBS:
			return LOC_OMAKA;
		case LOC_KAWI:
		case LOC_PIRATE:
			return LOC_KAWI;
		case LOC_MALKA:
			return LOC_MALKA;
		case LOC_JUNGLE:
		case LOC_WAHIOKALA:
		case LOC_HILLSIDE:
		case LOC_LAVAFLOWS:
		case LOC_JUNGLECAVE:
		case LOC_TEMPLEOUTSIDE:
		case LOC_JUNGLETEMPLE:
		case LOC_HOKU:
		case LOC_ALII:
		case LOC_OBSERVATORY:
			return LOC_WAHIOKALA;
		case LOC_SHOALS:
		case LOC_MINE:
			return LOC_SHOALS;
		case LOC_KAWAIHAE:
			return LOC_KAWAIHAE;
		case LOC_KUKULU:
		case LOC_PIRATE2:
			return LOC_KUKULU;
		case LOC_KIKALA:
			return LOC_KIKALA;
		case LOC_LEIPAI:
			return LOC_LEIPAI;
		case LOC_TULANE:
			return LOC_TULANE;
		case LOC_CARN:
			return LOC_CARN;
		case LOC_PYRAMID:
			return LOC_PYRAMID;
		case LOC_MIRAGE:
		case LOC_MUSHRUSH:
			return LOC_MIRAGE;
		case LOC_SILVER:
			return LOC_SILVER;
		case LOC_PONI:
		case LOC_LAKE:
		case LOC_MIST:
			return LOC_PONI;
	}
	return -1;
}

// Omaka Subregions
enum{
	OMAKA_SUB_OVERWORLD,
	OMAKA_SUB_WAREHOUSE,
	OMAKA_SUB_MANOR,
	OMAKA_SUB_CATACOMBS,
	OMAKA_SUB_PUNAHOUSE1,
	OMAKA_SUB_PUNAHOUSE2,
	OMAKA_SUB_PUNAHOUSE3,
	OMAKA_SUB_PUNAHOUSE4,
	OMAKA_SUB_CAVE1,
	OMAKA_SUB_CAVE2,
	OMAKA_SUB_PALAHOUSE1,
	OMAKA_SUB_PALAHOUSE2,
	OMAKA_SUB_PALAHOUSE3,
	OMAKA_SUB_PALAHOUSE4,
	OMAKA_SUB_PALAHOUSE5,
	OMAKA_SUB_PALAHOUSE6,
	OMAKA_SUB_PALAHOUSE7,
	OMAKA_SUB_PALAHOUSE8,
	OMAKA_SUB_PALAHOUSE9,
	OMAKA_SUB_PALAHOUSE10,
	OMAKA_SUB_PALAHOUSE11,
	OMAKA_SUB_PALASHOP1,
	OMAKA_SUB_PALASHOP2,
	OMAKA_SUB_PALASHOP3,
	OMAKA_SUB_BARRELHOUSE,
	OMAKA_SUB_PALACAVE
};

int NetGhost_DMapSubRegion(int dmap, int scrn){
	int locgen = NetGhost_DMapRegion(dmap);
	int loc = DMapLocation(dmap);
	int mapscrn = (Game->DMapMap[dmap]<<8) | scrn;
	switch(locgen){
		case LOC_OMAKA:
			switch(mapscrn){
				// Puna houses
				case 0x0258:
					return OMAKA_SUB_PUNAHOUSE1;
				case 0x0259:
					return OMAKA_SUB_PUNAHOUSE2;
				case 0x025A:
					return OMAKA_SUB_PUNAHOUSE3;
				case 0x025B:
					return OMAKA_SUB_PUNAHOUSE4;
				// Omaka caves
				case 0x0200:
					return OMAKA_SUB_CAVE1;
				case 0x0201:
				case 0x0202:
					return OMAKA_SUB_CAVE2;
				// Pala houses
				case 0x0228:
					return OMAKA_SUB_PALAHOUSE1;
				case 0x025C:
					return OMAKA_SUB_PALAHOUSE2;
				case 0x025D:
					return OMAKA_SUB_PALAHOUSE3;
				case 0x025E:
					return OMAKA_SUB_PALAHOUSE4;
				case 0x025F:
					return OMAKA_SUB_PALAHOUSE5;
				case 0x0268:
					return OMAKA_SUB_PALAHOUSE6;
				case 0x0269:
					return OMAKA_SUB_PALAHOUSE7;
				case 0x026B:
				case 0x026C:
					return OMAKA_SUB_PALAHOUSE8;
				case 0x024F:
					return OMAKA_SUB_PALAHOUSE9;
				case 0x026E:
					return OMAKA_SUB_PALAHOUSE10;
				case 0x026F:
					return OMAKA_SUB_PALAHOUSE11;
				case 0x0278:
					return OMAKA_SUB_PALASHOP1;
				case 0x0279:
					return OMAKA_SUB_PALASHOP2;
				case 0x027A:
					return OMAKA_SUB_PALASHOP3;
				case 0x027B:
					return OMAKA_SUB_BARRELHOUSE;
				case 0x0203:
					return OMAKA_SUB_PALACAVE;
			}
			switch(loc){
				case LOC_PUNA:
				case LOC_OMAKA:
				case LOC_PALA:
					return OMAKA_SUB_OVERWORLD;
				case LOC_WAREHOUSE:
					return OMAKA_SUB_WAREHOUSE;
				case LOC_MANOR:
					return OMAKA_SUB_MANOR;
				case LOC_CATACOMBS:
					return OMAKA_SUB_CATACOMBS;
			}
			break;
		case LOC_KAWI:
			switch(loc){
				case LOC_KAWI:
					return 0;
				case LOC_PIRATE:
					return 1;
			}
			break;
		case LOC_WAHIOKALA:
			if(dmap==13) // Caves
				return 5;
			switch(loc){
				case LOC_JUNGLE:
				case LOC_HILLSIDE:
				case LOC_LAVAFLOWS:
				case LOC_TEMPLEOUTSIDE:
				case LOC_HOKU:
					return 0;
				case LOC_JUNGLECAVE:
					return 1;
				case LOC_JUNGLETEMPLE:
					return 2;
				case LOC_ALII:
					return 3;
				case LOC_OBSERVATORY:
					return 4;
			}
			break;
		case LOC_SHOALS:
			switch(dmap){
				case 14: // Overworld
					return 0;
				case 17: // Mines
				case 21:
					return 1;
				case 22: // Caves
					return 2;
			}
			break;
		case LOC_KUKULU:
			switch(loc){
				case LOC_KUKULU:
					return 0;
				case LOC_PIRATE2:
					return 1;
			}
			break;
		case LOC_MIRAGE:
		case LOC_MUSHRUSH:
			switch(loc){
				case LOC_MIRAGE:
					return 0;
				case LOC_MUSHRUSH:
					return 1;
			}
			break;
		case LOC_PONI:
			switch(loc){
				case LOC_PONI:
				case LOC_LAKE:
					return 0;
				case LOC_MIST:
					return 1;
			}
	}
	return 0;
}

void NetGhost_GetTrueMapPos(int xy, int dmap, int scrn, int x, int y){
	xy[0] = (scrn%16);
	xy[1] = Floor(scrn/16);
	switch(dmap){
		// Omaka
		case 1: // Puna
			xy[0] += 4;
			xy[1] -= 8;
			break;
		case 2: // Pala
			//xy[0] -= 8;
			xy[1] += 6;
			break;
		// Wahiokala
		case 28: // Hoku
			xy[0] += 2;
			break;
		case 36: // Jungle 2
			xy[2] -= 2;
			break;
		// Kohi
		case 51: // Canyon Upper
			xy[0] -= 8;
			xy[1] -= 8;
			break;
		case 52: // Canyon Lakes
			xy[1] -= 11;
			break;
		
	}
	xy[0] *= 256;
	xy[1] *= 176;
	xy[0] += x;
	xy[1] += y;
}

void UpdateDockUserlist(int dmap){
	int loc = NetGhost_DMapRegion(dmap);
	MultiworldData[MD_DOCKLISTS+ZLink::ThisUserID()-1] = loc;
	ZLink::OpenPacket();
	ZLink::OUT_UpdateDockList(ZLink::ThisUserID(), loc);
	ZLink::SendPacket();
}

const int ED_ENTRANCES = 0;
const int ED_ENTRANCE_DEFINITIONS = 1;
const int SIZE_ED = 1;
const int ED_MAX_ENTRANCE_DEFINITIONS = 32;

enum{
	ED_ER_SUBR,
	ED_ER_LINK,
	ED_ER_DMAP,
	ED_ER_SCRN, // Map screen, not dmap screen
	ED_ER_X,
	ED_ER_Y,
	SIZE_ED_ER
};

// Load entrancedata into a buffer for a general location (island)
void EntranceData_Load(int loc, int buf){
	EntranceData_ResetConnections(buf);
	switch(loc){
		case LOC_OMAKA:
			// Puna houses
			EntranceData_AddConnection(buf, OMAKA_SUB_OVERWORLD, {1, 0x61, 24, 96},
										OMAKA_SUB_PUNAHOUSE1, {15, 0x58, 168, 160});
			EntranceData_AddConnection(buf, OMAKA_SUB_OVERWORLD, {1, 0x61, 152, 32},
										OMAKA_SUB_PUNAHOUSE2, {15, 0x59, 120, 160});
			EntranceData_AddConnection(buf, OMAKA_SUB_OVERWORLD, {1, 0x62, 72, 80},
										OMAKA_SUB_PUNAHOUSE3, {15, 0x5A, 88, 160});
			EntranceData_AddConnection(buf, OMAKA_SUB_OVERWORLD, {1, 0x72, 152, 48},
										OMAKA_SUB_PUNAHOUSE4, {15, 0x5B, 120, 160});
										
			// Caves
			EntranceData_AddConnection(buf, OMAKA_SUB_OVERWORLD, {0, 0x04, 16, 80},
										OMAKA_SUB_CAVE1, {7, 0x00, 56, 40});
			EntranceData_AddConnection(buf, OMAKA_SUB_OVERWORLD, {0, 0x46, 200, 96},
										OMAKA_SUB_CAVE1, {7, 0x02, 136, 112});
			EntranceData_AddConnection(buf, OMAKA_SUB_OVERWORLD, {2, 0x2A, 80, 56},
										OMAKA_SUB_PALACAVE, {7, 0x03, 88, 24});
										
			// Pala houses
			EntranceData_AddConnection(buf, OMAKA_SUB_OVERWORLD, {2, 0x19, 72, 80},
										OMAKA_SUB_PALAHOUSE1, {4, 0x28, 88, 144});
			EntranceData_AddConnection(buf, OMAKA_SUB_OVERWORLD, {2, 0x09, 104, 112},
										OMAKA_SUB_PALAHOUSE2, {4, 0x5C, 120, 160});
			EntranceData_AddConnection(buf, OMAKA_SUB_OVERWORLD, {2, 0x09, 232, 112},
										OMAKA_SUB_PALAHOUSE3, {4, 0x5D, 120, 160});
			EntranceData_AddConnection(buf, OMAKA_SUB_OVERWORLD, {2, 0x0A, 120, 112},
										OMAKA_SUB_PALAHOUSE4, {4, 0x5E, 120, 160});
			EntranceData_AddConnection(buf, OMAKA_SUB_OVERWORLD, {2, 0x0C, 88, 112},
										OMAKA_SUB_PALAHOUSE5, {4, 0x5F, 120, 160});
			EntranceData_AddConnection(buf, OMAKA_SUB_OVERWORLD, {2, 0x0C, 216, 112},
										OMAKA_SUB_PALAHOUSE6, {4, 0x68, 120, 160});
			EntranceData_AddConnection(buf, OMAKA_SUB_OVERWORLD, {2, 0x0D, 152, 112},
										OMAKA_SUB_PALAHOUSE7, {4, 0x69, 120, 160});
			EntranceData_AddConnection(buf, OMAKA_SUB_OVERWORLD, {2, 0x1A, 120, 80},
										OMAKA_SUB_PALAHOUSE8, {4, 0x6B, 168, 160});
			EntranceData_AddConnection(buf, OMAKA_SUB_OVERWORLD, {2, 0x1C, 72, 80},
										OMAKA_SUB_PALAHOUSE9, {4, 0x4F, 120, 160});
			EntranceData_AddConnection(buf, OMAKA_SUB_OVERWORLD, {2, 0x1C, 168, 80},
										OMAKA_SUB_PALAHOUSE10, {4, 0x6E, 120, 160});
			EntranceData_AddConnection(buf, OMAKA_SUB_OVERWORLD, {2, 0x3E, 104, 112},
										OMAKA_SUB_PALAHOUSE11, {4, 0x6F, 120, 160});
										
			// Pala shops
			EntranceData_AddConnection(buf, OMAKA_SUB_OVERWORLD, {2, 0x2C, 8, 80},
										OMAKA_SUB_PALASHOP1, {3, 0x78, 120, 160});
			EntranceData_AddConnection(buf, OMAKA_SUB_OVERWORLD, {2, 0x2C, 232, 80},
										OMAKA_SUB_PALASHOP2, {3, 0x79, 120, 160});
			EntranceData_AddConnection(buf, OMAKA_SUB_OVERWORLD, {2, 0x2D, 120, 80},
										OMAKA_SUB_PALASHOP3, {3, 0x7A, 120, 160});
										
			// Barrel house
			EntranceData_AddConnection(buf, OMAKA_SUB_OVERWORLD, {2, 0x3C, 88, 96},
										OMAKA_SUB_BARRELHOUSE, {5, 0x7B, 120, 160});
			
			// Warehouse
			EntranceData_AddConnection(buf, OMAKA_SUB_OVERWORLD, {2, 0x39, 88, 96},
										OMAKA_SUB_WAREHOUSE, {9, 0x73, 120, 160});
			
			// Manor
			EntranceData_AddConnection(buf, OMAKA_SUB_OVERWORLD, {2, 0x10, 208, 96},
										OMAKA_SUB_MANOR, {24, 0x3A, 120, 160});
			// Catacombs
			EntranceData_AddConnection(buf, OMAKA_SUB_OVERWORLD, {2, 0x19, 216, 112},
										OMAKA_SUB_CATACOMBS, {25, 0x7B, 120, 160});
			
			// Manor -> Catacombs
			EntranceData_AddConnection(buf, OMAKA_SUB_OVERWORLD, {24, 0x1E, 88, 80},
										OMAKA_SUB_CATACOMBS, {25, 0x4B, 40, 48});
			break;
	}
}

void EntranceData_ResetConnections(int buf){
	for(int i=0; i<32; ++i){
		int idx = (SIZE_ED+SIZE_ED_ER*ED_MAX_ENTRANCE_DEFINITIONS)*i;
		buf[idx+ED_ENTRANCES] = 0;
	}
}

// Define a two-way connection in the buffer
void EntranceData_AddConnection(int buf, int subr1, int arr1, int subr2, int arr2){
	int idx1 = (SIZE_ED+SIZE_ED_ER*ED_MAX_ENTRANCE_DEFINITIONS)*subr1;
	int idx2 = (SIZE_ED+SIZE_ED_ER*ED_MAX_ENTRANCE_DEFINITIONS)*subr2;
	
	// Add the contents of the first array as a new entrance and increment the number of entrances
	int nument = buf[idx1+ED_ENTRANCES];
	buf[idx1+ED_ENTRANCE_DEFINITIONS+nument*SIZE_ED_ER+ED_ER_SUBR] = subr2;
	buf[idx2+ED_ENTRANCE_DEFINITIONS+nument*SIZE_ED_ER+ED_ER_LINK] = idx1+ED_ENTRANCE_DEFINITIONS+nument*SIZE_ED_ER;
	for(int i=2; i<SIZE_ED_ER; ++i){
		buf[idx1+ED_ENTRANCE_DEFINITIONS+nument*SIZE_ED_ER+i] = arr1[i-2];
	}
	++buf[idx1+ED_ENTRANCES];
	
	// Add the contents of the previous array as a new entrance and increment the number of entrances
	nument = buf[idx2+ED_ENTRANCES];
	buf[idx2+ED_ENTRANCE_DEFINITIONS+nument*SIZE_ED_ER+ED_ER_SUBR] = subr1;
	buf[idx1+ED_ENTRANCE_DEFINITIONS+nument*SIZE_ED_ER+ED_ER_LINK] = idx2+ED_ENTRANCE_DEFINITIONS+nument*SIZE_ED_ER;
	for(int i=2; i<SIZE_ED_ER; ++i){
		buf[idx2+ED_ENTRANCE_DEFINITIONS+nument*SIZE_ED_ER+i] = arr2[i-2];
	}
	++buf[idx2+ED_ENTRANCES];
	
	if(MAPPOS_DEBUG){
		printf("\nAdd Connection\n");
		printf("idx1: %d\n\n", idx1);
		for(int i=2; i<SIZE_ED_ER; ++i){
			printf("buf[%d] = %d;\n", idx1+ED_ENTRANCE_DEFINITIONS+nument*SIZE_ED_ER+i, buf[idx1+ED_ENTRANCE_DEFINITIONS+nument*SIZE_ED_ER+i]);
		}
		printf("\nidx2: %d\n\n", idx2);
		for(int i=2; i<SIZE_ED_ER; ++i){
			printf("buf[%d] = %d;\n", idx2+ED_ENTRANCE_DEFINITIONS+nument*SIZE_ED_ER+i, buf[idx2+ED_ENTRANCE_DEFINITIONS+nument*SIZE_ED_ER+i]);
		}
	}
}

void EntranceData_GetNearest(int buf, int dsxy, int thissubregion, int targetsubregion){
	bool viewed[32];
	int queue[32];
	int queueOrigin[32];
	int queueSize;
	
	int idx = (SIZE_ED+SIZE_ED_ER*ED_MAX_ENTRANCE_DEFINITIONS)*thissubregion; // Index for the starting subregion
	int count = buf[idx+ED_ENTRANCES]; // Num entrances for the starting subregion
	
	if(MAPPOS_DEBUG)printf("Searching through entrances...\n");
	// Search through every region adjacent to the current one
	for(int i=0; i<count; ++i){
		int esr = buf[idx+ED_ENTRANCE_DEFINITIONS+i*SIZE_ED_ER+ED_ER_SUBR];
		viewed[esr] = true;
		// Add the adjacent region to a queue of new regions to check
		queue[queueSize] = esr;
		queueOrigin[queueSize] = idx+ED_ENTRANCE_DEFINITIONS*i+SIZE_ED_ER; // Set the origin index to that connection
		++queueSize;
		
		if(MAPPOS_DEBUG)printf("DMap: %d\nScreen: %d\n\n", buf[idx+ED_ENTRANCE_DEFINITIONS+i*SIZE_ED_ER+ED_ER_DMAP], buf[idx+ED_ENTRANCE_DEFINITIONS+i*SIZE_ED_ER+ED_ER_SCRN]);
		// If it's the target region, return that entrance
		if(esr==targetsubregion){
			for(int j=2; j<SIZE_ED_ER; ++j){
				dsxy[j-2] = buf[idx+ED_ENTRANCE_DEFINITIONS+i*SIZE_ED_ER+j];
				if(MAPPOS_DEBUG)printf("dsxy[%d] = %d\n", j-2, buf[idx+ED_ENTRANCE_DEFINITIONS+i*SIZE_ED_ER+j]);
			}
			if(MAPPOS_DEBUG)TraceNL();
			return;
		}
	}
	
	if(MAPPOS_DEBUG)printf("Searching through neighbors of entrances...\n");
	// Search through the queue for regions connected by adjacent regions
	for(int k=0; k<queueSize; ++k){
		idx = (SIZE_ED+SIZE_ED_ER*ED_MAX_ENTRANCE_DEFINITIONS)*queue[k];
		count = buf[idx+ED_ENTRANCES];
		for(int i=0; i<count; ++i){
			int esr = buf[idx+ED_ENTRANCE_DEFINITIONS+i*SIZE_ED_ER+ED_ER_SUBR];
			// If a connection is new, add that to the queue
			if(!viewed[esr]){
				queue[queueSize] = esr;
				queueOrigin[queueSize] = queueOrigin[k]; // Set the origin index to that of the start of the chain
				++queueSize;
				
				if(MAPPOS_DEBUG)printf("DMap: %d\nScreen: %d\n\n", buf[idx+ED_ER_DMAP], buf[idx+ED_ER_SCRN]);
				// If it's the target region, return that entrance
				if(esr==targetsubregion){
					idx = queueOrigin[k];
					for(int j=2; j<SIZE_ED_ER; ++j){
						dsxy[j-2] = buf[idx+j];
						if(MAPPOS_DEBUG)printf("dsxy[%d] = %d\n", j-2, buf[idx+j]);
					}
					return;
				}
			}
		}
	}
}