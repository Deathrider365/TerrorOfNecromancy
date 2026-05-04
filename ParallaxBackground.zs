namespace Parallax
{
    enum ParallaxLayerFlags
    {
        PLF_IS_SCREEN              = 0x001L, // Uses DrawScreen()
        PLF_TRANS                  = 0x002L,
        PLF_LERP_X                 = 0x004L,
        PLF_LERP_Y                 = 0x008L,
        PLF_NO_WRAP_X              = 0x010L,
        PLF_NO_WRAP_Y              = 0x020L,
        PLF_LERP_X_USES_MAP_POS    = 0x040L,
        PLF_LERP_Y_USES_MAP_POS    = 0x080L,
        PLF_VELOCITY_IGNORES_SCALE = 0x100L
    };

    enum ParallaxLayerComboFlags
    {
        FLAG_DEFINITION_USE_SCREEN_DRAWS,
        FLAG_DEFINITION_TRANSPARENT,
        FLAG_DEFINITION_LOWER_FLOOR,
        FLAG_DEFINITION_LERP_X,
        FLAG_DEFINITION_LERP_Y,
        FLAG_DEFINITION_LERP_X_USES_MAP_POS,
        FLAG_DEFINITION_LERP_Y_USES_MAP_POS,
        FLAG_DEFINITION_NO_WRAP_X,
        FLAG_DEFINITION_NO_WRAP_Y,
        FLAG_DEFINITION_RANDOMIZE_STARTING_POSITION,
        FLAG_DEFINITION_VELOCITY_IGNORES_SCALE
    };

    enum ParallaxLayerAttributes
    {
        ATTRIBUTE_DEFINITION_BG_COLOR,
        ATTRIBUTE_DEFINITION_UPDATE_FRAMES,
        ATTRIBUTE_DEFINITION_STARTING_X,
        ATTRIBUTE_DEFINITION_STARTING_Y,
        ATTRIBUTE_DEFINITION_WIDTH,
        ATTRIBUTE_DEFINITION_HEIGHT,
        ATTRIBUTE_DEFINITION_LERP_MIN_X,
        ATTRIBUTE_DEFINITION_LERP_MAX_X,
        ATTRIBUTE_DEFINITION_LERP_MIN_Y,
        ATTRIBUTE_DEFINITION_LERP_MAX_Y,
        ATTRIBUTE_DEFINITION_LERP_EDGE_BUFFER
    };

    enum ParallaxLayerInitD
    {
        INITD_CONFIG_COMBO,
        INITD_CONFIG_NUM_COMBOS,
        INITD_CONFIG_FLOOR_MAP,
        INITD_CONFIG_FLOOR_SCREEN,
        INITD_CONFIG_TEMPORARY,

        INITD_DEFINITION_LAYER = 0,
        INITD_DEFINITION_SOURCE_MAP,
        INITD_DEFINITION_SOURCE_SCREEN,
        INITD_DEFINITION_VX,
        INITD_DEFINITION_VY,
        INITD_DEFINITION_PARALLAX_X,
        INITD_DEFINITION_PARALLAX_Y,
        INITD_DEFINITION_SCALE
    };

    enum ParallaxLayerArray
    {
        PLARRAY_CURRENT_LAYERS,
        PLARRAY_NEW_LAYERS,
        PLARRAY_BACKUP_LAYERS
    };

    ParallaxContainer ParallaxLayers;

    int RegionScreenOrigin()
    {
        return Region->OriginScreenIndex*10000;
    }

    class ParallaxContainer
    {
        ParallaxLayer CurrentLayers[0]; // The currently displaying set of layers
        ParallaxLayer NewLayers[0]; // Used when scroll warping into a screen with a different set of layers
        ParallaxLayer BackupLayers[0]; // Used to to store persistent layers underneath temporary ones

        bitmap DrawChecker;

        int LastDMap,LastScreen; // Used for detecting screen changes
        int NoScrollLastDMap,NoScrollLastScreen; // Timing jank used for finding true map positions during scrolling
        int LayerSourceDMap,LayerSourceScreen; // Used for detecting temp layer changes
        int RefCombos,RefCombosCount; // Used for comparing against new sets of layers
        int LowerFloorMap,LowerFloorScreen; // Used for comparing against new sets of layers
        int LastX,LastY; // Used for tracking viewport scrolling
        bool TemporaryLayer; // This layer will disappear upon changing screens/dmaps
        bool LayerCreatedByDMap; // Will disappear upon changing dmap if TemporaryLayer is set
        bool WasScrolling; // In the middle of a scrolling animation between two different parallax regions
        bool DisposeOfTempLayer; // Set when scrolling to a new screen when there is a temp layer
        bool ScrollingBGTransition; // Set every frame when scrolling between two screens with different layers. Used for communication.
        bool HasDrawn; // True if the script has drawn this frame
        bool ContinueFrame; // True if this is a continue frame (opening wipe)
        bool DrawFailed; // True if a draw has failed the previous frame
        int DrawCheckerColor; // Color used by the draw checker
        int BackupRefs[4]; // Backups of RefCombos, RefCombosCount, LowerFloorMap, and LowerFloorScreen, for use with IsDifferent()

        int Slot_ConfigParallaxFFC;

        ParallaxContainer()
        {
            Slot_ConfigParallaxFFC = Game->GetFFCScript("ConfigParallaxFFC");
            DrawChecker = Game->CreateBitmap(1, 1);

            Init();
        }

        // Reset variables when created
        void Init()
        {
            LastDMap = -1;
            LastScreen = Game->CurScreen;
            NoScrollLastDMap = -1;
            NoScrollLastScreen = RegionScreenOrigin();
            LayerSourceDMap = -1;
            ResetParallax();
            ClearLayerFloorAndComboData();
            TemporaryLayer = false;
            WasScrolling = false;
            DisposeOfTempLayer = false;
            ScrollingBGTransition = false;
        }

        // Clears data about the current layer, when cleaning up temporary layers
        void ClearLayerFloorAndComboData()
        {
            LowerFloorMap = 0;
            LowerFloorScreen = 0;
            RefCombos = 0;
            RefCombosCount = 0;
        }

        // Called when starting or ending a scroll to reset the parallax tracking, since scrolling uses a different reference point
        void ResetParallax()
        {
            LastX = Viewport->X;
            LastY = Viewport->Y;
        }

        // Called every frame
        void Update()
        {
            Screen->DrawOrigin = DRAW_ORIGIN_PLAYING_FIELD;
            
            UpdateScreenChanges();
            UpdateScrolling();
            UpdateLayers(false);
            HasDrawn = false;
            ContinueFrame = false;
        }

        // Returns true if draw commands were unable to execute the previous frame
        bool CheckCanDrawDesync()
        {
            int prevColor = DrawCheckerColor;
            DrawCheckerColor = (DrawCheckerColor+1)%0xF;
            int getPixel = DrawChecker->GetPixel(0, 0);
            DrawChecker->PutPixel(0, 0, 0, DrawCheckerColor, 0, 0, 0, OP_OPAQUE);
            // The result of GetPixel is the color from the previous frame, because draws are deferred.
            // This means we can't tell if bitmap draws failed this frame, but we can tell 
            // if the previous call's did and run them again! 
            bool hasPixel = getPixel==prevColor;
            return !hasPixel;
        }

        // Called by the generic script to preload layers off of scripts
        void Preload()
        {
            bool found = RunFFCScriptsRemote();
            if(found)
            {
                UpdateLayers(true);
                HasDrawn = true;
            }
        }

        // Update tracking of screen changes
        void UpdateScreenChanges()
        {
            if(LastScreen!=Game->CurScreen||LastDMap!=Game->CurDMap)
            {
                if(TemporaryLayer)
                {
                    DisposeOfTempLayer = CanLayerDispose();
                    if(DisposeOfTempLayer)
                        TemporaryLayer = false;
                }
            }
            if(Game->Scrolling[SCROLL_DIR]==-1&&(NoScrollLastScreen!=RegionScreenOrigin()||NoScrollLastDMap!=Game->CurDMap))
            {
                NoScrollLastScreen = RegionScreenOrigin();
                NoScrollLastDMap = Game->CurDMap;
            }
            LastScreen = Game->CurScreen;
            LastDMap = Game->CurDMap;
        }

        // Process things that happen during scrolling
        void UpdateScrolling()
        {
            // // ContinueFrame is not cleared during preload, so if this is check, we known this is the frame following a continue.
            // // Viewport X and Y are not valid during continue, so the parallax must be reset afterwards.
            if(ContinueFrame)
                ResetParallax();
            // If just started scrolling
            if(Game->Scrolling[SCROLL_DIR]>-1)
            {
                if(!WasScrolling)
                {
                    ResetParallax();
                }
                // If layers will be disposed of but there's a backup to fall back on, do that
                if(DisposeOfTempLayer&&SizeOfArray(BackupLayers))
                {
                    LoadBackupLayers(PLARRAY_NEW_LAYERS);
                    DisposeOfTempLayer = false;
                }
                WasScrolling = true;
            }
            // ...Otherwise when stopping
            else
            {
                if(WasScrolling)
                {
                    ResetParallax();
                    // DisposeOfTempLayer is cleared when a new layer is assigned
                    // So this branch should only run if entering a truly empty screen
                    if(DisposeOfTempLayer)
                    {
                        ClearVisibleLayers();
                        ClearLayerFloorAndComboData();
                    }
                    // Otherwise we swap the new layers to the active layers
                    else
                    {
                        TransferNewLayers();
                    }
                    DisposeOfTempLayer = false;
                }
                WasScrolling = false;
            }

            // If not scrolling but disposing of a layer, just get rid of it here
            if(Game->Scrolling[SCROLL_DIR]==-1&&DisposeOfTempLayer)
            {
                ClearVisibleLayers();
                DisposeOfTempLayer = false;
                ClearLayerFloorAndComboData();
                LoadBackupLayers(PLARRAY_NEW_LAYERS);
            }
        }

        // Update the layers
        void UpdateLayers(bool preload)
        {
            int sz = SizeOfArray(CurrentLayers);
            int szNew = SizeOfArray(NewLayers);
            // Transition Type 1: The backgrounds are different
            ScrollingBGTransition = (szNew>0&&Game->Scrolling[SCROLL_DIR]>-1);
            // Transition Type 2: Scrolling off a temp layer screen
            if(DisposeOfTempLayer&&Game->Scrolling[SCROLL_DIR]>-1)
                ScrollingBGTransition = true;
            // Get movement based on viewport scrolling
            int dX = Viewport->X-LastX;
            int dY = Viewport->Y-LastY;
            LastX = Viewport->X;
            LastY = Viewport->Y;
            // Call update functions on Current and New layers
            if(preload)
            {
                for(int i=0; i<sz; ++i)
                {
                    CurrentLayers[i]->UpdatePreload();
                }
                for(int i=0; i<szNew; ++i)
                {
                    NewLayers[i]->UpdatePreload();
                }
            }
            else
            {
                for(int i=0; i<sz; ++i)
                {
                    CurrentLayers[i]->Update(dX, dY);
                }
                for(int i=0; i<szNew; ++i)
                {
                    NewLayers[i]->Update(dX, dY);
                }
            }
        }

        // Returns true if conditions are met to dispose of a layer
        bool CanLayerDispose()
        {
            if(!TemporaryLayer)
                return false;
            if(LayerCreatedByDMap)
                return LayerSourceDMap!=Game->CurDMap;
            else
                return (LayerSourceDMap!=Game->CurDMap||LayerSourceScreen!=RegionScreenOrigin());
        }

        // Update layers for FFCs carrying the script
        bool RunFFCScriptsRemote()
        {
            bool ret;
            for(int i=1; i<=MAX_FFC; ++i)
            {
                ffc f = Screen->LoadFFC(i);
                if(f->Script==Slot_ConfigParallaxFFC)
                {
                    ConfigParallaxFFC.runRemote(f);
                    ret = true;
                }
            }
            return ret;
        }

        // Add a new layer onto the list
        void Add(combodata cd, int floorMap, int floorScreen, bool scrolling)
        {
            ParallaxLayer pl = new ParallaxLayer(cd, floorMap, floorScreen);
            if(scrolling)
            {
                ArrayPushBack(NewLayers, pl);
                pl->IsNew = true;
            }
            else
            {
                ArrayPushBack(CurrentLayers, pl);
                pl->IsNew = false;
            }
        }

        // Clear the active Current and New layers
        void ClearVisibleLayers()
        {
            TemporaryLayer = false;
            Clear(PLARRAY_CURRENT_LAYERS);
            Clear(PLARRAY_NEW_LAYERS);
        }

        // Clear a specific layer list
        void Clear(ParallaxLayerArray which)
        {
            switch(which)
            {
                case PLARRAY_CURRENT_LAYERS:
                {
                    ResizeArray(CurrentLayers, 0);
                    break;
                }
                case PLARRAY_NEW_LAYERS:
                {
                    ResizeArray(NewLayers, 0);
                    break;
                }
                case PLARRAY_BACKUP_LAYERS:
                {
                    ResizeArray(BackupLayers, 0);
                    break;
                }
            }
        }

        // Transfer layers from the New list to the Current one, if there are any New layers
        void TransferNewLayers()
        {
            int sz = SizeOfArray(NewLayers);
            if(sz>0)
            {
                Clear(PLARRAY_CURRENT_LAYERS);
                for(int i=0; i<sz; ++i)
                {
                    NewLayers[i]->IsNew = false;
                    ArrayPushBack(CurrentLayers, NewLayers[i]);
                }
                Clear(PLARRAY_NEW_LAYERS);
            }
        }

        // Transfers Backup layers to the New or Current list, if there are any Backup layers
        void LoadBackupLayers(ParallaxLayerArray toWhich)
        {
            int sz = SizeOfArray(BackupLayers);
            if(sz>0)
            {
                Clear(toWhich);
                for(int i=0; i<sz; ++i)
                {
                    if(toWhich==PLARRAY_CURRENT_LAYERS)
                    {
                        BackupLayers[i]->IsNew = false;
                        ArrayPushBack(CurrentLayers, BackupLayers[i]);
                    }
                    else
                    {
                        BackupLayers[i]->IsNew = true;
                        ArrayPushBack(NewLayers, BackupLayers[i]);
                    }
                }
                RefCombos = BackupRefs[0];
                RefCombosCount = BackupRefs[1];
                LowerFloorMap = BackupRefs[2];
                LowerFloorScreen = BackupRefs[3];
            }
        }

        // Transfers layers from the New or Current list to the Backup layers
        void SaveBackupLayers(ParallaxLayerArray fromWhich)
        {
            int sz;
            if(fromWhich==PLARRAY_CURRENT_LAYERS)
                sz = SizeOfArray(CurrentLayers);
            else
                sz = SizeOfArray(NewLayers);
            if(sz>0)
            {
                Clear(PLARRAY_BACKUP_LAYERS);
                for(int i=0; i<sz; ++i)
                {
                    if(fromWhich==PLARRAY_CURRENT_LAYERS)
                        ArrayPushBack(BackupLayers, CurrentLayers[i]);
                    else
                        ArrayPushBack(BackupLayers, NewLayers[i]);
                }
                BackupRefs[0] = RefCombos;
                BackupRefs[1] = RefCombosCount;
                BackupRefs[2] = LowerFloorMap;
                BackupRefs[3] = LowerFloorScreen;
            }
        }
    }

    class ParallaxLayer
    {
        bitmap LayerBitmap;
        bitmap ScreenBitmap;
        int Layer;
        int X,Y;
        int VX,VY;
        int ParallaxVX,ParallaxVY;
        int LerpMinX,LerpMaxX;
        int LerpMinY,LerpMaxY;
        int LerpEdgeBuffer;
        int Width,Height;
        int SourceMap,SourceScreen;
        int Scale;
        int BGColor;
        int UpdateFrames;
        int UpdateFreq;
        long Flags;

        bool IsNew;

        ParallaxLayer(combodata cd, int floorMap, int floorScreen)
        {
            ParallaxDefinition.Load(cd, this, floorMap, floorScreen);
            if(Width<=0)
                Width = 256;
            if(Height<=0)
                Height = DMapViewportHeight();
            LayerBitmap = Game->CreateBitmap(Width*2, Height*2);
            ScreenBitmap = Game->CreateBitmap(256, 232);
            RefreshBitmap();
        }

        // Runs every frame to update the position of the layer and then draw it
        void Update(int dX, int dY)
        {
            if(UpdateFreq>0)
            {
                ++UpdateFrames;
                if(UpdateFrames>=UpdateFreq)
                {
                    UpdateFrames = 0;
                    RefreshBitmap();
                }
            }
            
            UpdateMotion(dX, dY);
            UpdateLerp();
            UpdateWrap();
            Draw();
        }

        // Runs on preload frames after being newly created off an FFC, for drawing during certain timings
        void UpdatePreload()
        {
            UpdateLerp();
            UpdateWrap();
            Draw();
        }

        // Redraws the whole bitmap used for the layer. Expensive so ideally only called when it needs to be
        void RefreshBitmap()
        {
            LayerBitmap->ClearToColor(0, BGColor);
            int w = Ceiling(Width/256);
            int h = Ceiling(Height/176);
            for(int x=0; x<w; ++x)
            {
                for(int y=0; y<h; ++y)
                {
                    int scrn = Clamp(SourceScreen+x+y*16, 0x00, 0x7F);
                    if(Flags&PLF_IS_SCREEN)
                        LayerBitmap->DrawScreen(0, SourceMap, scrn, x*256, y*176, 0);
                    else
                        LayerBitmap->DrawLayer(0, SourceMap, scrn, 0, x*256, y*176, 0, OP_OPAQUE);
                }
            }
            LayerBitmap->Rectangle(0, Width, 0, LayerBitmap->Width, LayerBitmap->Height, 0x00, 1, 0, 0, 0, true, OP_OPAQUE);
            LayerBitmap->Rectangle(0, 0, Height, LayerBitmap->Width, LayerBitmap->Height, 0x00, 1, 0, 0, 0, true, OP_OPAQUE);
            for(int i=0; i<4; ++i)
            {
                int x = i%2;
                int y = Floor(i/2);
                bool drawCopy = true;
                switch(i)
                {
                    case 0:
                        drawCopy = false;
                        break;
                    case 1:
                        if(Flags&PLF_NO_WRAP_X)
                            drawCopy = false;
                        break;
                    case 2:
                        if(Flags&PLF_NO_WRAP_Y)
                            drawCopy = false;
                        break;
                    case 3:
                        if((Flags&PLF_NO_WRAP_X)||(Flags&PLF_NO_WRAP_Y))
                            drawCopy = false;
                        break;
                }
                if(drawCopy)
                    LayerBitmap->Blit(0, LayerBitmap, 0, 0, Width, Height, x*Width, y*Height, Width, Height, 0, 0, 0, BITDX_NORMAL, 0, false);
            }
        }

        // Moves the layer based on time and viewport movement
        void UpdateMotion(int dX, int dY)
        {
            if(Scale==0)
                printf("Scale is 0!\n");
            if(Flags&PLF_VELOCITY_IGNORES_SCALE)
            {
                X -= VX/Scale;
                Y -= VY/Scale;
                X += dX*ParallaxVX/Scale;
                Y += dY*ParallaxVY/Scale;
            }
            else
            {
                X -= VX;
                Y -= VY;
                X += dX*ParallaxVX;
                Y += dY*ParallaxVY;
            }
            if(ParallaxLayers->ScrollingBGTransition)
            {
                if(ParallaxVX!=0&&Game->Scrolling[SCROLL_DIR]>=DIR_LEFT)
                    X -= dX*1/Scale;
                if(ParallaxVY!=0&&Game->Scrolling[SCROLL_DIR]<DIR_LEFT)
                    Y -= dY*1/Scale;
            }
            //UpdateMotionDebug(4, 0.1);
        }

        // For debugging motion stuff
        void UpdateMotionDebug(int layerStep, int scaleStep)
        {
            if(Link->InputEx1)
            {
                X += (Link->InputLeft?-layerStep:0) + (Link->InputRight?layerStep:0);
                Y += (Link->InputUp?-layerStep:0) + (Link->InputDown?layerStep:0);
                if(Link->PressL)
                    Scale -= scaleStep;
                else if(Link->PressR)
                    Scale += scaleStep;
                Link->Stun = 1;
            }
        }

        // Moves the layer based on viewport position when lerp is enabled
        void UpdateLerp()
        {
            int vw = 256;
            int vh = DMapViewportHeight();
            int xClamped,yClamped;
            int edgeBuf = LerpEdgeBuffer/Scale;
            if(Flags&PLF_LERP_X)
            {
                int vpX = Viewport->X;
                int rW = Region->Width;
                if(Game->Scrolling[SCROLL_DIR]>-1)
                {
                    if(IsNew)
                    {
                        vpX = Game->Scrolling[SCROLL_NEW_VIEWPORT_X];
                        rW = Game->Scrolling[SCROLL_NEW_REGION_SCREEN_WIDTH]*256;
                        if(Game->Scrolling[SCROLL_DIR]<DIR_LEFT)
                            vpX = Viewport->X-Game->Scrolling[SCROLL_NEW_REGION_DELTA_X];
                    }
                    else
                    {
                        vpX = Game->Scrolling[SCROLL_OLD_VIEWPORT_X];
                        rW = Game->Scrolling[SCROLL_OLD_REGION_SCREEN_WIDTH]*256;
                        if(Game->Scrolling[SCROLL_DIR]<DIR_LEFT)
                            vpX = Viewport->X;
                    }
                }
                int pct;
                int topBufDiff, bottomBufDiff;
                if(LerpEdgeBuffer>0)
                {
                    topBufDiff = Min(vpX, LerpEdgeBuffer)/Scale;
                    bottomBufDiff = (LerpEdgeBuffer - Max(0, vpX-(rW-vw-LerpEdgeBuffer)))/Scale;
                }
                if(Flags&PLF_LERP_X_USES_MAP_POS)
                {
                    int globalViewportX = (RegionScreenOrigin()%16)*256+Viewport->X;
                    if(Game->Scrolling[SCROLL_DIR]>-1)
                        globalViewportX = (ParallaxLayers->NoScrollLastScreen%16)*256+Viewport->X;
                    pct = globalViewportX/(256*15);
                    X = Lerp(LerpMinX, LerpMaxX, pct);
                }
                else
                {
                    pct = (rW-vw)==0?0:vpX/(rW-vw);
                    if(rW-vw<=0)
                        X = Lerp(LerpMinX, LerpMaxX, 0.5);
                    else
                        X = Lerp(LerpMinX+topBufDiff, LerpMaxX-bottomBufDiff, pct);
                }
                X = Clamp(X, Min(LerpMinX, LerpMaxX), Max(LerpMinX, LerpMaxX));
            }
            if(Flags&PLF_LERP_Y)
            {
                int vpY = Viewport->Y;
                int rH = Region->Height;
                if(Game->Scrolling[SCROLL_DIR]>-1)
                {
                    if(IsNew)
                    {
                        vpY = Game->Scrolling[SCROLL_NEW_VIEWPORT_Y];
                        rH = Game->Scrolling[SCROLL_NEW_REGION_SCREEN_HEIGHT]*176;
                        if(Game->Scrolling[SCROLL_DIR]>=DIR_LEFT)
                            vpY = Viewport->Y-Game->Scrolling[SCROLL_NEW_REGION_DELTA_Y];
                    }
                    else
                    {
                        vpY = Game->Scrolling[SCROLL_OLD_VIEWPORT_Y];
                        rH = Game->Scrolling[SCROLL_OLD_REGION_SCREEN_HEIGHT]*176;
                        if(Game->Scrolling[SCROLL_DIR]>=DIR_LEFT)
                            vpY = Viewport->Y;
                    }
                }
                int pct;
                int topBufDiff, bottomBufDiff;
                if(LerpEdgeBuffer>0)
                {
                    topBufDiff = Min(vpY, LerpEdgeBuffer)/Scale;
                    bottomBufDiff = (LerpEdgeBuffer - Max(0, vpY-(rH-vh-LerpEdgeBuffer)))/Scale;
                }
                if(Flags&PLF_LERP_Y_USES_MAP_POS)
                {
                    int globalViewportY = Floor(RegionScreenOrigin()/16)*176+Viewport->Y;
                    if(Game->Scrolling[SCROLL_DIR]>-1)
                        globalViewportY = Floor(ParallaxLayers->NoScrollLastScreen/16)*176+Viewport->Y;
                    pct = globalViewportY/(176*7);
                    Y = Lerp(LerpMinY, LerpMaxY, pct);
                }
                else
                {
                    pct = (rH-vh)==0?0:vpY/(rH-vh);
                    if(rH-vh<=0)
                        Y = Lerp(LerpMinY, LerpMaxY, 0.5);
                    else
                        Y = Lerp(LerpMinY+topBufDiff, LerpMaxY-bottomBufDiff, pct);
                }
                Y = Clamp(Y, Min(LerpMinY, LerpMaxY), Max(LerpMinY, LerpMaxY));
            }
        }

        // Keeps the layer view wrapped, if wrapping is enabled
        void UpdateWrap()
        {
            if(!(Flags&PLF_NO_WRAP_X))
                X = wrap(X, Width);
            if(!(Flags&PLF_NO_WRAP_Y))
                Y = wrap(Y, Height);
        }

        // Draw the layer to the screen
        void Draw()
        {
            if(ParallaxLayers->HasDrawn)
                return;
            Screen->DrawOrigin = DRAW_ORIGIN_PLAYING_FIELD;
            int vw = 256;
            int vh = DMapViewportHeight();
            ScreenBitmap->Clear(0);
            int wSample = Floor(vw/Scale);
            int hSample = Floor(vh/Scale);
            WrapBlit(LayerBitmap, 0, ScreenBitmap, X, Y, wSample, hSample, 0, 0, vw, vh, 0, 0, 0, BITDX_NORMAL, 0, false, Flags&PLF_NO_WRAP_X, Flags&PLF_NO_WRAP_Y);
            int xoff,yoff;
            if(ParallaxLayers->ScrollingBGTransition)
            {
                // Get scrolling offsets
                if(IsNew)
                {
                    xoff = Game->Scrolling[SCROLL_NX];
                    yoff = Game->Scrolling[SCROLL_NY];
                }
                else
                {
                    xoff = Game->Scrolling[SCROLL_OX];
                    yoff = Game->Scrolling[SCROLL_OY];
                }
                // Don't draw offset for screen realignment
                if(Game->Scrolling[SCROLL_DIR]<DIR_LEFT)
                    xoff = 0;
                else
                    yoff = 0;
                // When extended viewport is on
                if(vh>176)
                {
                    // Weird offset for the upper screen of a vertical scroll
                    if(Game->Scrolling[SCROLL_DIR]==DIR_UP&&IsNew)
                        yoff -= 56;
                    else if(Game->Scrolling[SCROLL_DIR]==DIR_DOWN&&!IsNew)
                        yoff -= 56;
                }
            }
            // Small viewport draws lower on the screen
            if(vh==176)
                yoff += 56;
            else if(IsMessyVerticalScroll())
                yoff += vh-Viewport->Height;
            //int offsetY = vh-Viewport->Height+56;
            Screen->DrawOrigin = DRAW_ORIGIN_SCREEN;
            ScreenBitmap->Blit(Layer, RT_SCREEN, 0, 0, vw, vh, xoff, yoff, vw, vh, 0, 0, 0, (Flags&PLF_TRANS)?BITDX_TRANS:BITDX_NORMAL, 0, BGColor==0);
        }
        // Returns true if scrolling vertically onto a new screen that will change the size of the viewport
        bool IsMessyVerticalScroll()
        {
            if(ParallaxLayers->ScrollingBGTransition)
            {
                if(Game->Scrolling[SCROLL_DIR]<DIR_LEFT&&Game->Scrolling[SCROLL_NEW_REGION_SCREEN_HEIGHT]!=Game->Scrolling[SCROLL_OLD_REGION_SCREEN_HEIGHT]==1)
                {
                    return Game->Scrolling[SCROLL_NEW_REGION_SCREEN_HEIGHT]==1||Game->Scrolling[SCROLL_OLD_REGION_SCREEN_HEIGHT]==1;
                }
            }
            return false;
        }

        // Blit that wraps around the edges to fit the destination rect
        void WrapBlit(bitmap b, int layer, bitmap target, int sx, int sy, int sw, int sh, int dx, int dy, int dw, int dh, int rotation = 0, int cx = 0, int cy = 0, int mode = 0, int lit = 0, bool mask = true, bool noWrapX = false, bool noWrapY = false)
        {
            int vpH = DMapViewportHeight();

            // The bitmap contains four copies of itself for wrapping so the true size is halved
            int w = b->Width/2;
            int h = b->Height/2;
            if(!noWrapX)
                sx = wrap(sx, w);
            if(!noWrapY)
                sy = wrap(sy, h);
            // Unit source: This is the source rect but clamped to the bitmap's size
            int uSrcW = Ceiling(Min(sw, w));
            int uSrcH = Ceiling(Min(sh, h));
            // If the viewport goes outside the bitmap but there's no wrap, ignore unit scale
            if(noWrapX&&(sx<0||sx+sw>=w))
                uSrcW = sw;
            if(noWrapY&&(sy<0||sy+sh>=h))
                uSrcH = sh;
            // Scaling for destination units. 
            // Represents how many times the original source rect can fit inside the unit source rect
            int scaleX = Min(uSrcW/sw, 1);
            int scaleY = Min(uSrcH/sh, 1);
            // Unit dest: Size and offset for drawn sections
            int uDestW = Ceiling(dw*scaleX);
            int uDestH = Ceiling(dh*scaleY);
            // Repeat counts: Number of units drawn in a grid on each axis
            int repX = Ceiling(dw/uDestW);
            int repY = Ceiling(dh/uDestH);

            int dXOff = 0;
            int dYOff = 0;
            if(noWrapX)
            {
                if(uSrcW<256)
                {
                    dXOff = sx*scaleX;
                    sx = 0;
                }
                repX = 1;
            }
            if(noWrapY)
            {
                if(uSrcH<vpH)
                {
                    dYOff = sy*scaleY;
                    sy = 0;
                }
                repY = 1;
            }
            uSrcW = Ceiling(uSrcW);
            uSrcH = Ceiling(uSrcH);
            for(int xx=0; xx<repX; ++xx)
            {
                for(int yy=0; yy<repY; ++yy)
                {
                    ClampedBlit(b, layer, target, Round(sx), Round(sy), uSrcW, uSrcH, uDestW*xx+dXOff, uDestH*yy+dYOff, uDestW, uDestH, rotation, cx, cy, mode, lit, mask);
                }
            }

        }

        // Blit that's clamped to the screen, to prevent a crash
        void ClampedBlit(bitmap b, int layer, untyped target, int sx, int sy, int sw, int sh, int dx, int dy, int dw, int dh, int rotation = 0, int cx = 0, int cy = 0, int mode = 0, int lit = 0, bool mask = true)
        {
            sx = Floor(sx);
            sy = Floor(sy);
            dx = Floor(dx);
            dy = Floor(dy);
            // Scaling multipier for the dest rect
            int scx = (dw/sw);
            int scy = (dh/sh);
            // Clipped the left side, shrink width and offset right to compensate
            if(sx<0)
            {
                int shave = -sx;
                sw -= shave;
                sx += shave;
                int dshave = Floor(shave*scx);
                dw -= dshave;
                dx += dshave;
            }
            // Clipped the right side, shrink width
            if(sx+sw>b->Width)
            {
                int shave = Abs(b->Width-(sx+sw));
                sw -= shave;
                int dshave = Floor(shave*scx);
                dw -= dshave;
            }
            // Clipped the top side, shrink height and offset down to compensate
            if(sy<0)
            {
                int shave = -sy;
                sh -= shave;
                sy += shave;
                int dshave = Floor(shave*scy);
                dh -= dshave;
                dy += dshave;
            }
            // Clipped the bottom side, shrink height
            if(sy+sh>b->Height)
            {
                int shave = Abs(b->Height-(sy+sh));
                sh -= shave;
                int dshave = Floor(shave*scy);
                dh -= dshave;
            }
            // Don't bother if the whole source rect is out of bounds
            if(sw>0&&sh>0)
                b->Blit(layer, target, sx, sy, sw, sh, dx, dy, dw, dh, rotation, cx, cy, mode, lit, mask);
        }
    }

    // Returns the max height for the viewport for the current DMap
    // Even if it's shrunk be being in a smaller region, it will still return 232 for an extended viewport
    int DMapViewportHeight()
    {
        dmapdata dmd = Game->LoadDMapData(Game->CurDMap);
        if(dmd->Flagset[DMFS_EXTENDEDVIEWPORT])
            return 232;
        return 176;
    }

    @InitScript(0)
    global script ParallaxInit
    {
        void run()
        {
            RunGenericScript(CheckGenericScript("ParallaxGeneric"));
            RunGenericScript(CheckGenericScript("ParallaxGenericEvents"));
        }
    }
    generic script ParallaxGeneric
    {
        void run()
        {
            this->ReloadState[GENSCR_ST_RELOAD] = true;
            this->ReloadState[GENSCR_ST_CONTINUE] = true;
            RunGenericScript(CheckGenericScript("ParallaxGenericEvents"));
            
            Screen->DrawOrigin = DRAW_ORIGIN_SCREEN;
            if(!ParallaxLayers)
            {
                ParallaxLayers = new ParallaxContainer();
            }

            ParallaxLayers->DrawChecker->Clear(0);
            ParallaxLayers->DrawCheckerColor = 0x00;

            while(true)
            {
                WaitTo(SCR_TIMING_WAITDRAW);
                ParallaxLayers->Update();
                Waitframe();
            }
        }
    }

    generic script ParallaxGenericEvents
    {
        void run()
        {
            this->EventListen[GENSCR_EVENT_INIT] = true;
            this->EventListen[GENSCR_EVENT_CONTINUE] = true;
            this->EventListen[GENSCR_EVENT_FFC_PRELOAD] = true;
            while(true)
            {
                switch(WaitEvent())
                {
                    case GENSCR_EVENT_INIT:
                    case GENSCR_EVENT_CONTINUE:
                        ParallaxLayers->ClearVisibleLayers();
                        ParallaxLayers->Clear(PLARRAY_BACKUP_LAYERS);
                        ParallaxLayers->ClearLayerFloorAndComboData();
                        ParallaxLayers->ContinueFrame = true;
                        break;
                    case GENSCR_EVENT_FFC_PRELOAD:
                        ParallaxLayers->Preload();
                        if(ParallaxLayers->ContinueFrame)
                            ParallaxLayers->HasDrawn = false;
                        break;
                }
            }
        }
    }

    @InitD0("Combo Reference"),
    @InitDHelp0("This is the first of the combos to reference for the layers."),
    @InitD1("Num Combos"),
    @InitDHelp1("This many combos will be used for layer data, each combo representing a layer to add."),
    @InitD2("Floor Map"),
    @InitDHelp2("If a layer has the flag \"Lower Floor\" checked, this map will be used instead of the one indicated by the combo."),
    @InitD3("Floor Screen"),
    @InitDHelp3("If a layer has the flag \"Lower Floor\" checked, this screen will be used instead of the one indicated by the combo."),
    @InitDType3("H"),
    @InitD4("Temporary"),
    @InitDHelp4("If checked, this layer will only persist for the current screen."),
    @InitDType4("B")
    ffc script ConfigParallaxFFC
    {
        void run()
        {
            if(this->Flags[FFCF_PRELOAD])
                Waitframe();
            // Most of the time this function is being called via generic script via preload timing
            runRemote(this, ParallaxLayers->CheckCanDrawDesync());
            while(true)
                Waitframe();
        }
        void runRemote(ffc this, bool forceReplace=false)
        {
            int refCombos = this->InitD[INITD_CONFIG_COMBO];
            int refCombosCount = this->InitD[INITD_CONFIG_NUM_COMBOS];
            int floorMap = this->InitD[INITD_CONFIG_FLOOR_MAP];
            int floorScreen = this->InitD[INITD_CONFIG_FLOOR_SCREEN];
            bool temporary = this->InitD[INITD_CONFIG_TEMPORARY];
            if(!refCombosCount)
                refCombosCount = 1;
            // This needs to be called to keep the color of the checker bitmap synced
            if(!forceReplace)
                ParallaxLayers->CheckCanDrawDesync();
            if(forceReplace||IsDifferent(refCombos, refCombosCount, floorMap, floorScreen))
            {
                if(Game->Scrolling[SCROLL_DIR]==-1)
                    ParallaxLayers->ClearVisibleLayers();
                else
                    ParallaxLayers->Clear(PLARRAY_NEW_LAYERS);
                for(int i=0; i<refCombosCount; ++i)
                {
                    combodata cd = Game->LoadComboData(refCombos+i);
                    ParallaxLayers->Add(cd, floorMap, floorScreen, Game->Scrolling[SCROLL_DIR]>-1);
                    ParallaxLayers->TemporaryLayer = temporary;
                    ParallaxLayers->LayerCreatedByDMap = false;
                }
                if(!temporary)
                    ParallaxLayers->SaveBackupLayers(Game->Scrolling[SCROLL_DIR]>-1?PLARRAY_NEW_LAYERS:PLARRAY_CURRENT_LAYERS);
                ParallaxLayers->RefCombos = refCombos;
                ParallaxLayers->RefCombosCount = refCombosCount;
                ParallaxLayers->LowerFloorMap = floorMap;
                ParallaxLayers->LowerFloorScreen = floorScreen;
                ParallaxLayers->LayerSourceDMap = Game->CurDMap;
                ParallaxLayers->LayerSourceScreen = RegionScreenOrigin();
            }
        }
        bool IsDifferent(int refCombos, int refCombosCount, int floorMap, int floorScreen)
        {
            bool differentScreen = (ParallaxLayers->LayerSourceDMap!=Game->CurDMap||ParallaxLayers->LayerSourceScreen!=RegionScreenOrigin());
            if(ParallaxLayers->TemporaryLayer&&!ParallaxLayers->LayerCreatedByDMap)
                return differentScreen;
            if(floorMap>0)
            {
                if(ParallaxLayers->LowerFloorMap!=floorMap||ParallaxLayers->LowerFloorScreen!=floorScreen)
                    return true;
            }
            if(ParallaxLayers->RefCombos!=refCombos||ParallaxLayers->RefCombosCount!=refCombosCount)
                return true;
            return false;
        }
    }

    @InitD0("Combo Reference"),
    @InitDHelp0("This is the first of the combos to reference for the layers."),
    @InitD1("Num Combos"),
    @InitDHelp1("This many combos will be used for layer data, each combo representing a layer to add."),
    @InitD2("Floor Map"),
    @InitDHelp2("If a layer has the flag \"Lower Floor\" checked, this map will be used instead of the one indicated by the combo. Pretty useless on a dmap."),
    @InitD3("Floor Screen"),
    @InitDHelp3("If a layer has the flag \"Lower Floor\" checked, this screen will be used instead of the one indicated by the combo. Pretty useless on a dmap."),
    @InitDType3("H"),
    @InitD4("Temporary"),
    @InitDHelp4("If checked, this layer will only persist for the current screen."),
    @InitDType4("B")
    dmapdata script ConfigParallaxDMap
    {
        void run(int refCombos, int refCombosCount, int floorMap, int floorScreen, bool temporary)
        {
            if(!refCombosCount)
                refCombosCount = 1;
            tryLoad(refCombos, refCombosCount, floorMap, floorScreen, temporary);
            Waitframe();
            tryLoad(refCombos, refCombosCount, floorMap, floorScreen, temporary);
        }
        void runRemote(dmapdata this)
        {
            int refCombos = this->InitD[INITD_CONFIG_COMBO];
            int refCombosCount = this->InitD[INITD_CONFIG_NUM_COMBOS];
            int floorMap = this->InitD[INITD_CONFIG_FLOOR_MAP];
            int floorScreen = this->InitD[INITD_CONFIG_FLOOR_SCREEN];
            bool temporary = this->InitD[INITD_CONFIG_TEMPORARY];
            if(!refCombosCount)
                refCombosCount = 1;
            tryLoad(refCombos, refCombosCount, floorMap, floorScreen, temporary);
        }
        void tryLoad(int refCombos, int refCombosCount, int floorMap, int floorScreen, bool temporary)
        {
            if(IsDifferent(refCombos, refCombosCount, floorMap, floorScreen))
            {
                if(Game->Scrolling[SCROLL_DIR]==-1)
                    ParallaxLayers->ClearVisibleLayers();
                else
                    ParallaxLayers->Clear(PLARRAY_NEW_LAYERS);
                for(int i=0; i<refCombosCount; ++i)
                {
                    combodata cd = Game->LoadComboData(refCombos+i);
                    ParallaxLayers->Add(cd, floorMap, floorScreen, Game->Scrolling[SCROLL_DIR]>-1);
                    ParallaxLayers->TemporaryLayer = temporary;
                    ParallaxLayers->LayerCreatedByDMap = true;
                }
                if(!temporary)
                    ParallaxLayers->SaveBackupLayers(Game->Scrolling[SCROLL_DIR]>-1?PLARRAY_NEW_LAYERS:PLARRAY_CURRENT_LAYERS);
                ParallaxLayers->RefCombos = refCombos;
                ParallaxLayers->RefCombosCount = refCombosCount;
                ParallaxLayers->LowerFloorMap = floorMap;
                ParallaxLayers->LowerFloorScreen = floorScreen;
                ParallaxLayers->LayerSourceDMap = Game->CurDMap;
                ParallaxLayers->LayerSourceScreen = RegionScreenOrigin();
            }
        }
        bool IsDifferent(int refCombos, int refCombosCount, int floorMap, int floorScreen)
        {
            bool differentScreen = (ParallaxLayers->LayerSourceDMap!=Game->CurDMap||ParallaxLayers->LayerSourceScreen!=RegionScreenOrigin());
            if(ParallaxLayers->TemporaryLayer)
                return differentScreen;
            if(floorMap>0)
            {
                if(ParallaxLayers->LowerFloorMap!=floorMap||ParallaxLayers->LowerFloorScreen!=floorScreen)
                    return true;
            }
            if(ParallaxLayers->RefCombos!=refCombos||ParallaxLayers->RefCombosCount!=refCombosCount)
                return true;
            return false;
        }
    }

    // Flags
    @Flag0("Use Screen Draws"),
    @FlagHelp0("If checked, the layer will use full screen draws, which are slower but show layers."),
    @Flag1("Transparent"),
    @FlagHelp1("If checked, the layer will use transparency."),
    @Flag2("Lower Floor"),
    @FlagHelp2("If checked, the map and screen properties will be ignored and instead the \"Floor Map\" and \"Floor Screen\" properties from the parent script will be used."),
    @Flag3("Lerp X"),
    @FlagHelp3("If checked, the layer's X position uses linear interpolation instead of using parallax VX and VY."),
    @Flag4("Lerp Y"),
    @FlagHelp4("If checked, the layer's X position uses linear interpolation instead of using parallax VX and VY."),
    @Flag5("Lerp X Uses Map Position"),
    @FlagHelp5("If checked and \"Lerp X\" is also checked, the lerped position is lerped based on Link's position on the map."),
    @Flag6("Lerp Y Uses Map Position"),
    @FlagHelp6("If checked and \"Lerp Y\" is also checked, the lerped position is lerped based on Link's position on the map."),
    @Flag7("No Wrap X"),
    @FlagHelp7("If checked, the layer will not wrap around on the X axis."),
    @Flag8("No Wrap Y"),
    @FlagHelp8("If checked, the layer will not wrap around on the Y axis."),
    @Flag9("Randomize Starting Position"),
    @FlagHelp9("If checked, he starting position of the layer will be randomzied based on its size."),
    @Flag10("Velocity Ignores Scale"),
    @FlagHelp10("If checked, the layer's movement will be the same no matter its scale."),
    // InitD
    @InitD0("Layer"),
    @InitDHelp0("The layer this layer will be drawn to."),
    @InitD1("Source Map"),
    @InitDHelp1("The map for the screen used as a reference for this layer."),
    @InitD2("Source Screen"),
    @InitDHelp2("The screen used as a reference for this layer. Layer visuals will extend down from the top-left, referencing other screens if big enough."),
    @InitDType2("H"),
    @InitD3("VX"),
    @InitDHelp3("How much the layer moves along the X axis each frame."),
    @InitD4("VY"),
    @InitDHelp4("How much the layer moves along the Y axis each frame."),
    @InitD5("Parallax X"),
    @InitDHelp5("How much the layer moves along with the viewport on the X axis when scrolling."),
    @InitD6("Parallax Y"),
    @InitDHelp6("How much the layer moves along with the viewport on the Y axis when scrolling."),
    @InitD7("Scale"),
    @InitDHelp7("Scaling multiplier for the layer, defaults to 1 if left at 0."),
    // Attributes
    @Attribute0("Background Color"),
    @AttributeHelp0("Background color drawn behind the layer. 0 for transparent."),
    @Attribute1("Update Frames"),
    @AttributeHelp1("How frequently the layer should update, for animated layers. If 0, it's static."),
    @Attribute2("Starting X"),
    @AttributeHelp2("The starting X position for the layer."),
    @Attribute3("Starting Y"),
    @AttributeHelp3("The starting Y position for the layer."),
    @Attribute4("Width"),
    @AttributeHelp4("The width of the layer in pixels."),
    @Attribute5("Height"),
    @AttributeHelp5("The height of the layer in pixels."),
    @Attribute6("Lerp Min X"),
    @AttributeHelp6("If using a linear interpolation, this is the minimum X position of the layer."),
    @Attribute7("Lerp Max X"),
    @AttributeHelp7("If using a linear interpolation, this is the maximum X position of the layer."),
    @Attribute8("Lerp Min Y"),
    @AttributeHelp8("If using a linear interpolation, this is the minimum Y position of the layer."),
    @Attribute9("Lerp Max Y"),
    @AttributeHelp9("If using a linear interpolation, this is the maximum Y position of the layer."),
    @Attribute10("Lerp Edge Buffer"),
    @AttributeHelp10("If using default lerp positions, the layer's min and max positions will be kept this many pixels away from the edges of the region.")
    combodata script ParallaxDefinition
    {
        void run()
        {

        }
        void Load(combodata cd, ParallaxLayer lyr, int floorMap, int floorScreen)
        {
            int vw = 256;
            int vh = DMapViewportHeight();

            // Flags
            if(cd->Flags[FLAG_DEFINITION_USE_SCREEN_DRAWS])
                lyr->Flags |= PLF_IS_SCREEN;
            if(cd->Flags[FLAG_DEFINITION_TRANSPARENT])
                lyr->Flags |= PLF_TRANS;
            if(cd->Flags[FLAG_DEFINITION_LERP_X])
                lyr->Flags |= PLF_LERP_X;
            if(cd->Flags[FLAG_DEFINITION_LERP_Y])
                lyr->Flags |= PLF_LERP_Y;
            if(cd->Flags[FLAG_DEFINITION_NO_WRAP_X])
                lyr->Flags |= PLF_NO_WRAP_X;
            if(cd->Flags[FLAG_DEFINITION_NO_WRAP_Y])
                lyr->Flags |= PLF_NO_WRAP_Y;
            if(cd->Flags[FLAG_DEFINITION_LERP_X_USES_MAP_POS])
                lyr->Flags |= PLF_LERP_X_USES_MAP_POS;
            if(cd->Flags[FLAG_DEFINITION_LERP_Y_USES_MAP_POS])
                lyr->Flags |= PLF_LERP_Y_USES_MAP_POS;
            if(cd->Flags[FLAG_DEFINITION_VELOCITY_IGNORES_SCALE])
                lyr->Flags |= PLF_VELOCITY_IGNORES_SCALE;
            // Starting Position
            lyr->X = -cd->Attributes[ATTRIBUTE_DEFINITION_STARTING_X];
            lyr->Y = -cd->Attributes[ATTRIBUTE_DEFINITION_STARTING_Y];
            // Size Stuff
            if(cd->Flags[FLAG_DEFINITION_LOWER_FLOOR])
            {
                lyr->Flags |= PLF_IS_SCREEN;
                lyr->SourceMap = floorMap;
                lyr->SourceScreen = floorScreen;
                lyr->Width = Max(Region->Width, vw);
                lyr->Height = Max(Region->Height, vh);
            }
            else
            {
                lyr->SourceMap = cd->InitD[INITD_DEFINITION_SOURCE_MAP];
                lyr->SourceScreen = cd->InitD[INITD_DEFINITION_SOURCE_SCREEN];
                lyr->Width = cd->Attributes[ATTRIBUTE_DEFINITION_WIDTH];
                lyr->Height = cd->Attributes[ATTRIBUTE_DEFINITION_HEIGHT];
                if(!lyr->Width)
                    lyr->Width = 256;
                if(!lyr->Height)
                    lyr->Height = 176;
            }
            // Randomize position
            if(cd->Flags[FLAG_DEFINITION_RANDOMIZE_STARTING_POSITION])
            {
                lyr->X = Rand(lyr->Width);
                lyr->Y = Rand(lyr->Height);
            }
            // Scale
            lyr->Scale = cd->InitD[INITD_DEFINITION_SCALE];
            if(lyr->Scale<=0)
                lyr->Scale = 1;
            // Lerp Stuff
            lyr->LerpMinX = -cd->Attributes[ATTRIBUTE_DEFINITION_LERP_MIN_X];
            lyr->LerpMaxX = -cd->Attributes[ATTRIBUTE_DEFINITION_LERP_MAX_X];
            lyr->LerpMinY = -cd->Attributes[ATTRIBUTE_DEFINITION_LERP_MIN_Y];
            lyr->LerpMaxY = -cd->Attributes[ATTRIBUTE_DEFINITION_LERP_MAX_Y];
            lyr->LerpEdgeBuffer = cd->Attributes[ATTRIBUTE_DEFINITION_LERP_EDGE_BUFFER];
            int edgeBuf = lyr->LerpEdgeBuffer/lyr->Scale;
            if(lyr->LerpMinX==lyr->LerpMaxX)
            {
                lyr->LerpMinX = -edgeBuf;
                lyr->LerpMaxX = (lyr->Width+edgeBuf)-(vw/lyr->Scale);
            }
            if(lyr->LerpMinY==lyr->LerpMaxY)
            {
                lyr->LerpMinY = -edgeBuf;
                lyr->LerpMaxY = (lyr->Height+edgeBuf)-(vh/lyr->Scale);
            }
            // Velocity
            lyr->VX = cd->InitD[INITD_DEFINITION_VX];
            lyr->VY = cd->InitD[INITD_DEFINITION_VY];
            lyr->ParallaxVX = cd->InitD[INITD_DEFINITION_PARALLAX_X];
            lyr->ParallaxVY = cd->InitD[INITD_DEFINITION_PARALLAX_Y];
            // Everything else
            lyr->BGColor = cd->Attributes[ATTRIBUTE_DEFINITION_BG_COLOR];
            lyr->UpdateFreq = cd->Attributes[ATTRIBUTE_DEFINITION_UPDATE_FRAMES];
            lyr->Layer = cd->InitD[INITD_DEFINITION_LAYER];
        }
    }
}

