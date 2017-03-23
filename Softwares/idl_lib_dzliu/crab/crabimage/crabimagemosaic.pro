; 
; Mosaic multiple images
; 
; Last update: 
;     2015-01-20 add PowerLawScale parameter
;     2015-01-23 set when no CrossBelong, we still plot cross
;     2017-03-06 WithTexts; TelTexts EQ 'N/A'
; 
PRO CrabImageMosaic, InputConfigFile, InputFits=InputFits, InputExts=InputExts, InputRect=InputRect, Verbose=Verbose, SaveEPS=SaveEPS, $
                     WithCircles=Circles, WithCircleColors=CircleColors, WithCircleWidth=CircleWidth, WithCircleHeight=CircleHeight, $
                                          WithCircleDashed=CircleDashed, WithCircleLabels=CircleLabels, WithCircleThicks=CircleThicks, $
                                          WithCircleBelong=CircleBelong, $
                     WithCrosses=Crosses, WithCrossColors=CrossColors, WithCrossThicks=CrossThicks, $
                                          WithCrossBelong=CrossBelong, $
                     WithTexts=WithTexts, WithTextCharSize=WithTextCharSize, WithTextCharThick=WithTextCharThick, $
                                          PowerLawScale=PowerLawScale, $
                                          ForceOneRow=ForceOneRow, $
                                          ForceLayout=ForceLayout
    
    
    IF KEYWORD_SET(Verbose) THEN Silent=!NULL ELSE Silent=1
    
    ; <TODO><DEBUG>
    ; InputConfigFile = "/Users/dliu/Working/2014-CEA/Tool/Level_3_SciData/Stamps/cutout_Id622/cutout_list"
    IF N_ELEMENTS(InputConfigFile) EQ 1 THEN BEGIN
        ; <TODO>
        ; Dir
        InputConfigDir = FILE_DIRNAME(InputConfigFile,/MARK_DIR)
        CD, InputConfigDir
        ; 
        ; 
        IF NOT FILE_TEST(InputConfigFile) THEN BEGIN
            MESSAGE, "CrabImageMosaic: Error! InputConfigFile does not exist!"
        ENDIF
        ; 
        ; read fits list
        InputFits = []
        InputExts = []
        InputRect = [] ; x1,x2,y1,y2
        OPENR, fp, InputConfigFile, /GET_LUN
        fp_line = ""
        WHILE ~EOF(fp) DO BEGIN
            READF, fp, fp_line
            fp_line = STRTRIM(fp_line,2)
            IF STRMATCH(fp_line,"#*") THEN CONTINUE
            IF STRMATCH(fp_line,"*.fits*") THEN BEGIN
                ; ()
                IF STRMATCH(fp_line,"*.fits*\(*\)") THEN BEGIN
                    ts_rect = STRMID(fp_line,STRPOS(fp_line,'(',/REVERSE_SEARCH)+1,STRPOS(fp_line,')',/REVERSE_SEARCH)-STRPOS(fp_line,'(',/REVERSE_SEARCH)-1)
                    ts_rect = CrabStringReplace(ts_rect,':',' ')
                    ts_rect = CrabStringReplace(ts_rect,',',' ')
                    ts_rect = CrabStringReplace(ts_rect,';',' ')
                    tr_rect = DOUBLE(STRSPLIT(ts_rect,' ',/EXT))
                    ts_rect = STRING(FORMAT='("(",F0.3,":",F0.3,",",F0.3,":",F0.3,")")',tr_rect[0],tr_rect[1],tr_rect[2],tr_rect[3]) 
                            ; round brackets means image position staring from 1 rather than array index starting from 0
                    tm_rect = { x1:tr_rect[0], x2:tr_rect[1], y1:tr_rect[2], y2:tr_rect[3], width:tr_rect[1]-tr_rect[0]+1, height:tr_rect[3]-tr_rect[2]+1 }
                    fp_line = STRMID(fp_line,0,STRPOS(fp_line,'(',/REVERSE_SEARCH))
                    fp_line = STRTRIM(fp_line,2)
                ENDIF ELSE BEGIN
                    tm_rect = { x1:0.0D, x2:0.0D, y1:0.0D, y2:0.0D, width:0.0D, height:0.0D }
                ENDELSE
                ; []
                IF STRMATCH(fp_line,"*.fits*\[*\]") THEN BEGIN
                    tm_fits = STRMID(fp_line,0,STRPOS(fp_line,'[',/REVERSE_SEARCH))
                    ts_exts = STRMID(fp_line,STRPOS(fp_line,'[',/REVERSE_SEARCH)+1,STRPOS(fp_line,']',/REVERSE_SEARCH)-STRPOS(fp_line,'[',/REVERSE_SEARCH)-1)
                    tm_exts = FIX(ts_exts)
                    fp_line = STRMID(fp_line,0,STRPOS(fp_line,'[',/REVERSE_SEARCH))
                    fp_line = STRTRIM(fp_line,2)
                ENDIF ELSE BEGIN
                    tm_exts = 0
                ENDELSE
                ; fits
                IF STRMATCH(fp_line,"*.fits") THEN BEGIN
                    tm_fits = fp_line
                ENDIF ELSE BEGIN
                    CONTINUE
                ENDELSE
                InputFits = [ InputFits, tm_fits ]
                InputExts = [ InputExts, tm_exts ]
                InputRect = [ InputRect, tm_rect ] ; dimension is 4 x number of fits
            ENDIF
        ENDWHILE
        CLOSE, fp
        FREE_LUN, fp
    ENDIF ELSE BEGIN
        ; <TODO> IF INPUT IS STRING ARRAY <TODO>
        ; <TODO>
        ; <TODO>
        ; <TODO>
        ; <TODO>
        ; <TODO> 
        ; <TODO> 
    ENDELSE
    
    
    
    
    ; RESOLVE_ROUTINE, 'crabtelescope', /COMPILE_FULL_FILE, /EITHER, /NO_RECOMPILE
    
    
    
    ; calc number of rows and columns
    NumbFits = N_ELEMENTS(InputFits)
    NumbRows = 1
    NumbCols = 1
    IF N_ELEMENTS(ForceLayout) GE 2 THEN BEGIN
        NumbCols = ForceLayout[0]
        NumbRows = ForceLayout[1]
    ENDIF ELSE IF KEYWORD_SET(ForceOneRow) THEN BEGIN
        NumbCols = NumbFits
    ENDIF ELSE BEGIN
        FOR j=1,NumbFits DO BEGIN
            FOR i=j,NumbFits DO BEGIN
                IF NumbFits EQ i*j AND i-j LT SQRT(NumbFits) THEN BEGIN
                    NumbRows = j
                    NumbCols = i
                    BREAK ; find an exact multiplication
                ENDIF
            ENDFOR
        ENDFOR
        WHILE NumbFits GT NumbCols*NumbRows DO BEGIN
            IF NumbCols LE 1+SQRT(NumbFits) THEN BEGIN
                NumbCols = NumbCols + 1
            ENDIF ELSE BEGIN
                NumbRows = NumbRows + 1
                NumbCols = NumbRows
            ENDELSE
            IF NumbFits EQ NumbCols*NumbRows THEN BREAK
        ENDWHILE
    ENDELSE
    
    IF KEYWORD_SET(Verbose) THEN BEGIN
        PRINT, FORMAT='("Number of input fits: ",I0)', NumbFits
        PRINT, FORMAT='("Making a grid layout: ",I0,"x",I0)', NumbCols, NumbRows
    ENDIF
    
    
    ; calc step of rows and columns
    StepSpacingX = 0.024/DOUBLE(NumbCols)
    StepSpacingY = 0.024/DOUBLE(NumbRows)
    StepCols = (1.0-1.0*StepSpacingX)/DOUBLE(NumbCols) ; Step = Width + 1*Spacing
    StepRows = (1.0-1.0*StepSpacingY)/DOUBLE(NumbRows) ; Step = Width + 1*Spacing   Full Width = N * Step + 1*SpacingLeft
    ; StepCols = 1.0/DOUBLE(NumbCols)
    ; StepRows = 1.0/DOUBLE(NumbRows)
    
    ; calc lowerleft (LL) and upperright (UR)
    ; Pos_LL_X = FINDGEN(NumbCols)*StepCols + 0.5*StepSpacingX
    ; Pos_LL_Y = FINDGEN(NumbRows)*StepRows + 0.5*StepSpacingY
    Pos_LL_X = FINDGEN(NumbCols)*StepCols + 1.0*StepSpacingX
    Pos_LL_Y = REVERSE(FINDGEN(NumbRows))*StepRows + 1.0*StepSpacingY
    Pos_UR_X = Pos_LL_X + StepCols - StepSpacingX
    Pos_UR_Y = Pos_LL_Y + StepRows - StepSpacingY
    Pos_LL = [ Pos_LL_X, Pos_LL_Y ]
    Pos_UR = [ Pos_UR_X, Pos_UR_Y ]
    MosaicRect = []
    FOR i=0,NumbFits-1 DO BEGIN
        tm_icol = i MOD NumbCols
        tm_irow = FIX(i/NumbCols)
        tm_ipos = [ Pos_LL_X[tm_icol], Pos_UR_X[tm_icol], Pos_LL_Y[tm_irow], Pos_UR_Y[tm_irow] ]
        tm_rstr = STRING(FORMAT='("[",F0.3,":",F0.3,",",F0.3,":",F0.3,"]")', tm_ipos[0], tm_ipos[1], tm_ipos[2], tm_ipos[3])
        tm_rect = { x1:Pos_LL_X[tm_icol], x2:Pos_UR_X[tm_icol], y1:Pos_LL_Y[tm_irow], y2:Pos_UR_Y[tm_irow], $
                    width:StepCols-StepSpacingX, height:StepRows-StepSpacingY }
                  ; position:tm_ipos, width:tm_ipos[1]-tm_ipos[0], height:tm_ipos[3]-tm_ipos[2] }
        MosaicRect = [ MosaicRect, tm_rect ]
        IF KEYWORD_SET(Verbose) THEN PRINT, FORMAT='("Mosaic (",I0,",",I0,")"," ",A)', tm_icol+1, tm_irow+1, tm_rstr
    ENDFOR 
    
    ; Decide device
    IF NOT KEYWORD_SET(SaveEPS) THEN BEGIN
        WSCSize = GET_SCREEN_SIZE()
    ENDIF ELSE BEGIN
        SET_PLOT, 'PS', /copy, /interpolate
        WSCSize = [50000,50000] ; 30cmx30cm max size
    ENDELSE
    
    ; Decide Window Size
    WDPSize = [ NumbCols, NumbRows ] * 2L
    WHILE WDPSize[0] LT 0.7*WSCSize[0] AND WDPSize[1] LT 0.7*WSCSize[1] DO BEGIN
        WDPSize = WDPSize + [ NumbCols, NumbRows ] * 2
    ENDWHILE
    IF NOT KEYWORD_SET(SaveEPS) THEN BEGIN
        WINDOW, 1, XSIZE=WDPSize[0], YSIZE=WDPSize[1], XPOS=WSCSize[0]-WDPSize[0]-20, YPOS=30 ;<TODO>; PS? WINDOW?
    ENDIF ELSE BEGIN
        IF SIZE(SaveEPS,/TNAME) NE "STRING" THEN SaveEPS='CrabImageMosaic.SaveEPS.EPS' 
        DEVICE, FILENAME=SaveEPS, XSIZE=WDPSize[0]/1000.0, YSIZE=WDPSize[1]/1000.0, /ENCAPSULATED, COLOR=1, BITS_PER_PIXEL=8;, DECOMPOSED=0
        PRINT, 'Page size '+STRING(FORMAT='(F0.1)',WDPSize[0]/1000.0)+' x '+STRING(FORMAT='(F0.1)',WDPSize[1]/1000.0)+' cm'
    ENDELSE
    
    
    ; Plot Frames
    FOR i=0,NumbFits-1 DO BEGIN
        tm_icol = i MOD NumbCols
        tm_irow = FIX(i/NumbCols)
        tm_xarr = [0,1,1,0,0]*MosaicRect[i].width  + MosaicRect[i].x1
        tm_yarr = [1,1,0,0,1]*MosaicRect[i].height + MosaicRect[i].y1
        PLOTS, tm_xarr, tm_yarr, /NORMAL, COLOR=cgColor('green'), THICK=1
    ENDFOR
    
    ; Plot Cutouts
    FOR i=0,NumbFits-1 DO BEGIN
        EachFits = InputFits[i]
        EachExts = InputExts[i]
        EachRect = InputRect[i]
        PRINT, '--- ', EachFits
        IF FILE_TEST(EachFits) THEN BEGIN
            
            ; Read fits header 
            IF EachExts LT 0 THEN EachExts = 0
            FitsHeader = HeadFits(EachFits,EXTEN=EachExts)
            FitsHeader0 = FitsHeader
            ExtAst, FitsHeader0, FitsWCS0
            FitsNY = FXPAR(FitsHeader,'NAXIS2')
            FitsNX = FXPAR(FitsHeader,'NAXIS1')
            
            ; Set fractional pixel
            ; FracPix = {x:EachRect.x1-FIX(EachRect.x1),y:EachRect.y1-FIX(EachRect.y1)}
            ; PRINT, EachRect.x1-FracPix.x, EachRect.x2-FracPix.x, EachRect.y1-FracPix.y, EachRect.y2-FracPix.y
            
            ; Cut large image
            IF EachRect.x2 GT EachRect.x1 AND EachRect.y2 GT EachRect.y1 THEN BEGIN
                ; extended a little bit the cut rect
                ExtendPix = 1.0D
                ExtendRect = EachRect
                ExtendRect.x1 = ExtendRect.x1 - ExtendPix
                ExtendRect.x2 = ExtendRect.x2 + ExtendPix
                ExtendRect.y1 = ExtendRect.y1 - ExtendPix
                ExtendRect.y2 = ExtendRect.y2 + ExtendPix
                ExtendRect.width = ExtendRect.x2 - ExtendRect.x1 + 1 ;<CORRECTED>+1
                ExtendRect.height = ExtendRect.y2 - ExtendRect.y1 + 1 ;<CORRECTED>+1
                CornerXY = DOUBLE([ExtendRect.x1,ExtendRect.x2,ExtendRect.y1,ExtendRect.y2])
                CutsImage = CrabImageCrop(EachFits,Extension=EachExts,CornerXY=CornerXY,NAXIS=CutsSizes,FitsHeader=FitsHeader,ShiftedXY=ShiftedXY,FractionalXY=FracXY,Status=FitsOK)
                ; ExtendRatio = [DOUBLE(ExtendRect.width)/DOUBLE(EachRect.width),DOUBLE(ExtendRect.height)/DOUBLE(EachRect.height)]
                ExtendRatio = [DOUBLE(CutsSizes[0])/DOUBLE(EachRect.width),DOUBLE(CutsSizes[1])/DOUBLE(EachRect.height)]
                ExtAst, FitsHeader, CutsWCS
            ENDIF ELSE BEGIN
                ExtendPix = 0
                FracXY = [0.0,0.0]
                CutsImage = MRDFITS(EachFits,EachExts,FitsHeader,STATUS=FitsOK,SILENT=Silent)
                ExtendRatio = [1.0,1.0]
                ExtAst, FitsHeader, CutsWCS
            ENDELSE
            
            
            
;            ; Set an edge pixel
;            EdgePix = {x:1.0,y:1.0} ; show outer pixels
;            
;            ; FitsRect
;            IF EachRect.y2 GT EachRect.y1 AND EachRect.y2 LE FitsNY THEN BEGIN
;                CutRange = {i1:FIX(EachRect.x1-FracPix.x-EdgePix.x)-1,i2:FIX(EachRect.x2-FracPix.x+EdgePix.x)-1,$
;                            j1:FIX(EachRect.y1-FracPix.y-EdgePix.y)-1,j2:FIX(EachRect.y2-FracPix.y+EdgePix.y)-1} ; i,j are index starting from 0
;                FitsImage = MRDFITS(EachFits,EachExts,FitsHeader,STATUS=FitsOK,/SILENT,RANGE=[CutRange.j1,CutRange.j2])
;                IF FitsOK EQ 0 THEN EXTAST, FitsHeader, CutsWCS
;                IF FitsOK EQ 0 THEN CutsImage = DOUBLE(FitsImage[CutRange.x1:CutRange.x2,*])
;                IF FitsOK EQ 0 THEN CutsWCS.NAXIS[0] = CutRange.x2-CutRange.x1+1.0-2.0*EdgePix.x ; use to calc FoV
;                IF FitsOK EQ 0 THEN CutsWCS.NAXIS[1] = CutRange.y2-CutRange.y1+1.0-2.0*EdgePix.y ; use to calc FoV
;                IF FitsOK EQ 0 THEN ExtendRatio = [(CutRange.x2-CutRange.x1-2.0*EdgePix.x)/(CutRange.x2-CutRange.x1),$
;                                                 (CutRange.y2-CutRange.y1-2.0*EdgePix.y)/(CutRange.y2-CutRange.y1)]
;            ENDIF ELSE BEGIN
;                CutRange = !NULL
;                FitsImage = MRDFITS(EachFits,EachExts,FitsHeader,STATUS=FitsOK,/SILENT)
;                IF FitsOK EQ 0 THEN EXTAST, FitsHeader, CutsWCS
;                IF FitsOK EQ 0 THEN CutsImage = DOUBLE(FitsImage)
;                IF FitsOK EQ 0 THEN ExtendRatio = [1.0,1.0]
;            ENDELSE
            
            
            ; 
            IF FitsOK EQ 0 AND N_ELEMENTS(CutsImage) GT 0 THEN BEGIN
                
                ; Zoom Each Cutout to Plot Size
                ; ExtendRatio = [1.0,1.0]
                ZoomSizes = [ WDPSize[0]*MosaicRect[i].width, WDPSize[1]*MosaicRect[i].height ]
                IF !D.NAME EQ 'PS' THEN ZoomSizes=ZoomSizes/20.0
                ZoomTimes = 1.0d/CutsSizes*ZoomSizes*ExtendRatio
                ZoomImage = frebin(CutsImage, ZoomSizes[0]*ExtendRatio[0], ZoomSizes[1]*ExtendRatio[1]) ; multiply ExtendRatio, so that the each rect matches the mosaic rect
                
                ; ------ check CutsWCS
                ; CrabImageAD2XY, 189.3781281, 62.2162323, CutsWCS, TempX, TempY
                ; PRINT, TempX, TempY
                
                
                ; ------ debug CutsWCS
                ; CutsWCS.CRPIX = 0.5*CutsWCS.NAXIS+1.0
                ; CutsWCS.CRVAL = [189.3781281, 62.2162323]
                
                
                ZoomWCS = CutsWCS
                IF ZoomWCS.CDELT[0] NE 1.0 AND ZoomWCS.CDELT[1] NE 1.0 THEN BEGIN
                    ZoomWCS.CDELT[0] = ZoomWCS.CDELT[0]/ZoomTimes[0]
                    ZoomWCS.CDELT[1] = ZoomWCS.CDELT[1]/ZoomTimes[1]
                ENDIF ELSE BEGIN
                    ZoomWCS.CD[0,0] = ZoomWCS.CD[0,0]/ZoomTimes[0]
                    ZoomWCS.CD[1,1] = ZoomWCS.CD[1,1]/ZoomTimes[1]
                ENDELSE
                ; ------ Now zoom. What is zoom? Zoom is scaling the full width and full height. 
                ; ------ for a pixel image(x,y) array(i,j) device(i+0.5,j+0.5)
                ; ------ new-device(zoomW*(i+0.5),zoomH*(j+0.5))
                ; ------ new-array(zoomW*(i+0.5)-0.5,zoomH*(j+0.5)-0.5)
                ; ------ new-image(zoomW*(i+0.5)+0.5,zoomH*(j+0.5)+0.5)
                ; ------ new-image(zoomW*(x-0.5)+0.5,zoomH*(y-0.5)+0.5) -- the way we calc zoomed CRPIX
                ZoomWCS.CRPIX = (ZoomWCS.CRPIX-0.5)*ZoomTimes+0.5 ; ZoomWCS.CRPIX = (ZoomWCS.CRPIX-1.0)*ZoomTimes+1.0 ; <Corrected><20140912><DzLIU><Lagache> ;
                ; ------ CutsImage has observed pixel size, and dimension equals (FoV+buffer)
                ; ------ ZoomImage has screen display pixel size, and dimension equals (FoV+buffer)
                
                ; Offset (the buffer actually)
                ; OffsetFX = (FracXY[0]+ExtendPix)/CutsWCS.NAXIS[0]*ZoomSizes[0]/CutsWCS.NAXIS[0]*MosaicRect[i].width
                ; OffsetFY = (FracXY[1]+ExtendPix)/CutsWCS.NAXIS[1]*ZoomSizes[1]/CutsWCS.NAXIS[1]*MosaicRect[i].height
                ; PadX1cuts = (FracXY[0]+ExtendPix)
                ; PadY1cuts = (FracXY[1]+ExtendPix)
                PadX1 = (FracXY[0]+ExtendPix)/EachRect.width*ZoomSizes[0]
                PadY1 = (FracXY[1]+ExtendPix)/EachRect.height*ZoomSizes[1]
                PadX2 = (CutsSizes[0]-EachRect.width)/EachRect.width*ZoomSizes[0] - PadX1
                PadY2 = (CutsSizes[1]-EachRect.height)/EachRect.height*ZoomSizes[1] - PadY1
                
                
                ; Cut after offset
                Cut2Image = CrabImagePad(ZoomImage,PadLeft=-PadX1,PadBottom=-PadY1,PadRight=-PadX2,PadTop=-PadY2)
                Cut2Sizes = SIZE(Cut2Image,/DIM)
                
                Cut2WCS = ZoomWCS
                Cut2WCS.CRPIX = ZoomWCS.CRPIX - [PadX1,PadY1]
                
;                CrabImageAD2XY, 189.1147461, 62.2050095, FitsWCS0, TempX, TempY, /DoNotCheck
;                PRINT, TempX, TempY
;                FitsWCS0.CRPIX = FitsWCS0.CRPIX-100.0
;                CrabImageAD2XY, 189.1147461, 62.2050095, FitsWCS0, TempX, TempY, /DoNotCheck
;                PRINT, TempX, TempY
;                FitsWCS0.CRPIX = FitsWCS0.CRPIX-1900.0
;                CrabImageAD2XY, 189.1147461, 62.2050095, FitsWCS0, TempX, TempY, /DoNotCheck
;                PRINT, TempX, TempY
;                FitsWCS0.CRPIX = FitsWCS0.CRPIX+2000.0-ShiftedXY
;                CrabImageAD2XY, 189.1147461, 62.2050095, FitsWCS0, TempX, TempY, /DoNotCheck
;                PRINT, TempX, TempY
;                CrabImageAD2XY, 189.1147461, 62.2050095, CutsWCS, TempX, TempY, /DoNotCheck
;                PRINT, TempX, TempY, (CutsSizes[0]+1.0)/2.0, (CutsSizes[1]+1.0)/2.0
;                CrabImageAD2XY, 189.1147461, 62.2050095, ZoomWCS, TempX, TempY, /DoNotCheck
;                PRINT, TempX, TempY, (ZoomSizes[0]+1.0)/2.0, (ZoomSizes[1]+1.0)/2.0
;                CrabImageAD2XY, 189.1147461, 62.2050095, Cut2WCS, TempX, TempY, /DoNotCheck
;                PRINT, TempX, TempY, (Cut2Sizes[0]+1.0)/2.0, (Cut2Sizes[1]+1.0)/2.0 ; Good! Now we confirmed that Object is exactly at centre. 
                
                
                IF Cut2Image EQ !NULL THEN BEGIN
                    PRINT, 'Cut2Image is null!'
                ENDIF
                
                ; Convert float data to Byte
                IF N_ELEMENTS(PowerLawScale) EQ 0 THEN BEGIN
                    ByteImage = CrabImageByteScaleMagic(Cut2Image,/Verbose) ; <TODO> default automatic way
                ENDIF ELSE BEGIN
                    IF N_ELEMENTS(PowerLawScale) EQ 2*NumbFits THEN BEGIN
                        ByteImage = CrabImageByteScaleMagic(Cut2Image,SigmaRange=[PowerLawScale[2*i],PowerLawScale[2*i+1]],/Verbose) ; <TODO>
                    ENDIF ELSE IF SIZE(PowerLawScale,/TNAME) EQ 'OBJREF' THEN BEGIN
                        IF PowerLawScale.hasKey(EachFits) THEN BEGIN
                        ByteImage = CrabImageByteScaleMagic(Cut2Image,SigmaRange=PowerLawScale[EachFits],/Verbose)
                        ENDIF ELSE BEGIN
                        ByteImage = CrabImageByteScaleMagic(Cut2Image,/Verbose) ; <TODO> default automatic way
                        ENDELSE
                        ; <Updated><20160317> Now we can input like dictionary structure!
                        ; for example, if we input InputFits=['aaa.fits','bbb.fits'], and PowerLawScale=[-1,3,-2,6], then we will scale 'aaa.fits' to -1sigma -> 3sigma, and 'bbb.fits' to -2sigma -> 6sigma. 
                        ; or if we input InputFits=['aaa.fits','bbb.fits'], and PowerLawScale=HASH('bbb.fits',[-2,6]), then we will scale only 'bbb.fits' to -2sigma -> 6sigma, but 'aaa.fits' in automatic way. 
                    ENDIF ELSE BEGIN
                       ;ByteImage = CrabImageByteScaleMagic(Cut2Image,PowerLawScale,/Verbose) ; <TODO> default automatic way
                       ;ByteImage = CrabImagePowerLawScale(Cut2Image,PowerLawScale,MIN=0.0,/ByteScale)
                       ;MESSAGE, 'Warning! PowerLawScale has wrong dimenstion and will not be applied.', /CONTINUE
                        ByteImage = CrabImageByteScaleMagic(Cut2Image,/Verbose) ; <TODO> default automatic way
                    ENDELSE
                ENDELSE
                TrueImage = MAKE_ARRAY(3,Cut2Sizes[0],Cut2Sizes[1],/BYTE,VALUE=0)
                TrueImage[0,*,*]=ByteImage[*,*] & TrueImage[1,*,*]=ByteImage[*,*] & TrueImage[2,*,*]=ByteImage[*,*]
                IF !D.NAME EQ 'PS' THEN DEVICE, COLOR=0
                TV, TrueImage, MosaicRect[i].x1, $; - OffsetFX, $ ;+0.003*MosaicRect[i].width
                               MosaicRect[i].y1, $; - OffsetFY, $ ;+0.005*MosaicRect[i].height
                               XSIZE=MosaicRect[i].width, YSIZE=MosaicRect[i].height, /NORMAL, /TRUE
                IF !D.NAME EQ 'PS' THEN DEVICE, COLOR=1
                ; Device, Get_Visual_Depth=thisDepth & PRINT, thisDepth
                ; PRINT, 'DEBUG'
                
                ; Calc FoV
                PixScale = [ CutsWCS.CD[0,0]*CutsWCS.CDELT[0]*3600.0, CutsWCS.CD[1,1]*CutsWCS.CDELT[1]*3600.0 ]
                FoVStrut = { width:-PixScale[0]*EachRect.width,height:PixScale[1]*EachRect.height, unit:'"' }
                ; IF N_ELEMENTS(FoVArray) EQ 0 THEN FoVArray = [ FoVStrut ] ELSE FoVArray = [ FoVArray, FoVStrut ]
                
                
                
                
                ; 
                ; WithCircles
                IF !D.NAME EQ 'PS' THEN BEGIN 
                    Cut2WCS.CD=Cut2WCS.CD/20.0
                    Cut2WCS.CRPIX=(Cut2WCS.CRPIX-1.0)*20.0+1.0
                ENDIF
                IF N_ELEMENTS(CircleBelong) GT 0 AND N_ELEMENTS(CircleBelong) EQ N_ELEMENTS(Circles) THEN BEGIN
                    OneCutCirclesId = WHERE(CircleBelong EQ i+1,/NULL) ; <TODO> Circles belong to which cutout? ID starts from 1.
                    IF N_ELEMENTS(OneCutCirclesId) GT 0 AND N_ELEMENTS(Circles) GT 0 THEN OneCutCircles = Circles[OneCutCirclesId] ELSE OneCutCircles = []
                    IF N_ELEMENTS(OneCutCirclesId) GT 0 AND N_ELEMENTS(CircleColors) GT 0 THEN OneCutCircleColors = CircleColors[OneCutCirclesId] ELSE OneCutCircleColors = []
                    IF N_ELEMENTS(OneCutCirclesId) GT 0 AND N_ELEMENTS(CircleDashed) GT 0 THEN OneCutCircleDashed = CircleDashed[OneCutCirclesId] ELSE OneCutCircleDashed = []
                    IF N_ELEMENTS(OneCutCirclesId) GT 0 AND N_ELEMENTS(CircleLabels) GT 0 THEN OneCutCircleLabels = CircleLabels[OneCutCirclesId] ELSE OneCutCircleLabels = []
                    IF N_ELEMENTS(OneCutCirclesId) GT 0 AND N_ELEMENTS(CircleThicks) GT 0 THEN OneCutCircleThicks = CircleThicks[OneCutCirclesId] ELSE OneCutCircleThicks = []
                    CrabImageTVCircle, OneCutCircles, CircleColors=OneCutCircleColors, CircleDashed=OneCutCircleDashed, CircleLabels=OneCutCircleLabels, FitsHeader=Cut2WCS, $
                                                      CircleThicks=OneCutCircleThicks, $
                                       TVPosition=[MosaicRect[i].x1,MosaicRect[i].y1,MosaicRect[i].x2,MosaicRect[i].y2]
                ENDIF ELSE BEGIN
                    CrabImageTVCircle, Circles, CircleColors=CircleColors, CircleDashed=CircleDashed, CircleLabels=CircleLabels, FitsHeader=Cut2WCS, $
                                                CircleThicks=CircleThicks, $
                                       TVPosition=[MosaicRect[i].x1,MosaicRect[i].y1,MosaicRect[i].x2,MosaicRect[i].y2]
                ENDELSE
                ; 
                ; WithCrosses
                IF N_ELEMENTS(CrossBelong) GT 0 AND N_ELEMENTS(CrossBelong) EQ N_ELEMENTS(Crosses) THEN BEGIN
                    OneCutCrosssId = WHERE(CrossBelong EQ i+1,/NULL) ; <TODO> Crosss belong to which cutout? ID starts from 1.
                    CrabImageTVCross, Crosses, CrossColors=CrossColors, CrossLabels=CrossLabels, CrossThicks=CrossThicks, FitsHeader=Cut2WCS, $
                                      TVPosition=[MosaicRect[i].x1,MosaicRect[i].y1,MosaicRect[i].x2,MosaicRect[i].y2]
                ENDIF ELSE BEGIN
                    CrabImageTVCross, Crosses, CrossColors=CrossColors, CrossLabels=CrossLabels, CrossThicks=CrossThicks, FitsHeader=Cut2WCS, $
                                      TVPosition=[MosaicRect[i].x1,MosaicRect[i].y1,MosaicRect[i].x2,MosaicRect[i].y2]
                ENDELSE
                ; 
                ; Old Version of WithCircles
;                IF N_ELEMENTS(Circles) GE 3 THEN CircleNo=LONG(N_ELEMENTS(Circles)/3) ELSE CircleNo=0
;                FOR CircleId=0,CircleNo-1 DO BEGIN
;                    ; Circles [ra1,dec1,radiusInArcsec]
;                    AD2XY, Circles[CircleId*3+0], Circles[CircleId*3+1], CutsWCS, CirclePixX, CirclePixY ; CutsWCS is the WCS of ExtendImage
;                    AD2XY, Circles[CircleId*3+0], Circles[CircleId*3+1], FitsWCS0, CirclePixX0, CirclePixY0 ; FitsWCS0 is the WCS of InputImage
;                    ; PRINT, "DEBUG"
;                    ; PRINT, FORMAT='(F15.7,F15.7)', CirclePixX+1.0+ShiftedXY[0], CirclePixY+1.0+ShiftedXY[1]
;                    ; PRINT, FORMAT='(F15.7,F15.7)', CirclePixX0+1.0, CirclePixY0+1.0
;                    ; PRINT, " "
;                    CirclePixX = CirclePixX+1.0 - (FracXY[0]+ExtendPix) - 0.5 ; the first +1.0 is because in AD2XY the XY is array index starting from 0 
;                    CirclePixY = CirclePixY+1.0 - (FracXY[1]+ExtendPix) - 0.5 ; the last -0.5 is because on screen XY is pixel coordinate, and the starting 
;                                                                              ; pixel has a centre coordinate of 1,1, but its device coordinate is actually
;                                                                              ; 0.5,0.5 
;                                                                              ; 3 suites of coordinates -- <TODO> 
;                    IF CirclePixX LT 0.0 OR CirclePixX GT EachRect.width THEN CONTINUE
;                    IF CirclePixY LT 0.0 OR CirclePixY GT EachRect.height THEN CONTINUE
;                    CirclePixX = (MosaicRect[i].x1+MosaicRect[i].width*CirclePixX/EachRect.width)*WDPSize[0]
;                    CirclePixY = (MosaicRect[i].y1+MosaicRect[i].height*CirclePixY/EachRect.height)*WDPSize[1]
;                    CircleRadX = Circles[CircleId*3+2]/MEAN(ABS(PixScale))
;                    CircleRadY = Circles[CircleId*3+2]/MEAN(ABS(PixScale))
;                    CircleRadX = (MosaicRect[i].width*CircleRadX/EachRect.width)*WDPSize[0]
;                    CircleRadY = (MosaicRect[i].height*CircleRadY/EachRect.height)*WDPSize[1]
;                    CirclePixR = MEAN([CircleRadX,CircleRadY])
;                    
;                    ; Color
;                    IF CircleId LT N_ELEMENTS(CircleColors) THEN BEGIN
;                        CircleColorX = CircleColors[CircleId]
;                    ENDIF ELSE IF N_ELEMENTS(CircleColors) GT 0 THEN BEGIN
;                        CircleColorX = CircleColors[-1]
;                    ENDIF ELSE BEGIN
;                        CircleColorX = "green"
;                    ENDELSE
;                    IF SIZE(CircleColorX,/TNAME) EQ 'STRING' THEN BEGIN
;                        CircleColorX = cgColor(CircleColorX)
;                    ENDIF

;                    ; Thick
;                    IF CircleId LT N_ELEMENTS(CircleThicks) THEN BEGIN
;                        CircleThickX = CircleThicks[CircleId]
;                    ENDIF ELSE IF N_ELEMENTS(CircleThicks) GT 0 THEN BEGIN
;                        CircleThickX = CircleThicks[-1]
;                    ENDIF ELSE BEGIN
;                        CircleThickX = 2
;                    ENDELSE
;                    
;                    ; TV
;                    TVCircle, CirclePixR, CirclePixX, CirclePixY, COLOR=CircleColorX, THICK=CircleThickX
;                    ; TVCircle, Circles[CircleId*3+2]*ImageZoomFactor, Circles[CircleId*3+0]*ImageZoomFactor, Circles[CircleId*3+1]*ImageZoomFactor
;                    
;                    ; Label
;                    IF CircleId LT N_ELEMENTS(CircleLabels) THEN BEGIN
;                        CircleLabelX = CircleLabels[CircleId]
;                        IF SIZE(CircleLabelX,/TNAME) NE 'STRING' THEN CircleLabelX = STRTRIM(STRING(CircleLabelX),2)
;                        XYOUTS, CirclePixX, CirclePixY, CircleLabelX, COLOR=CircleColorX, ALIGNMENT=0.1, /Device
;                    ENDIF
;                ENDFOR
                
                
                
                ; 
                ; <TODO> 2014-09-09
                ; Polyfill Text Background
                ;; pfill_x = CrabArrayINDGEN(MosaicRect[i].x1, MosaicRect[i].x2, fCount=100)
                ;; pfill_y = CrabArrayINDGEN(MosaicRect[i].y2-0.09*MosaicRect[i].height, MosaicRect[i].y2, fCount=n_elements(pfill_x)/(MosaicRect[i].width)*(0.09*MosaicRect[i].height))
                ;; for pfill_i=0,n_elements(pfill_y)-1 do PLOTS, pfill_x, replicate(pfill_y[pfill_i],n_elements(pfill_x)), /NORMAL, PSYM=3, COLOR=cgColor('magenta')
                ; PolyFill, [MosaicRect[i].x1, MosaicRect[i].x2, MosaicRect[i].x2, MosaicRect[i].x1], $
                ;           [MosaicRect[i].y2-0.08*MosaicRect[i].height, MosaicRect[i].y2-0.08*MosaicRect[i].height, MosaicRect[i].y2, MosaicRect[i].y2], $
                ;           /NORMAL, /LINE_FILL, LineStyle=1, SPACING=0.05, ORIENTATION=+45, PSYM=4, COLOR=cgColor('magenta');'F5FFF5'xL
                ; PolyFill, [MosaicRect[i].x1, MosaicRect[i].x2, MosaicRect[i].x2, MosaicRect[i].x1], $
                ;           [MosaicRect[i].y2-0.08*MosaicRect[i].height, MosaicRect[i].y2-0.08*MosaicRect[i].height, MosaicRect[i].y2, MosaicRect[i].y2], $
                ;           /NORMAL, /LINE_FILL, LineStyle=1, SPACING=0.05, ORIENTATION=-45, PSYM=4, COLOR=cgColor('magenta');'F5FFF5'xL
                
                
                ; 
                ; Show Text
                IF (FoVStrut.width-FoVStrut.height) LE 0.0001*(FoVStrut.width+FoVStrut.height) THEN BEGIN
                    FoVTexts = STRING(FORMAT='("FoV ",F0.2,A1)', FoVStrut.width, FoVStrut.unit)
                ENDIF ELSE BEGIN
                    FoVTexts = STRING(FORMAT='("FoV ",F0.2,A1,"x",F0.2,A1)', FoVStrut.width, FoVStrut.unit, FoVStrut.height, FoVStrut.unit)
                ENDELSE
                IF N_ELEMENTS(WithTextCharSize) EQ 0 THEN WithTextCharSize=1.05
                IF N_ELEMENTS(WithTextCharThick) EQ 0 THEN WithTextCharThick=3.85
                IF WithTextCharSize LT 1.5 THEN BEGIN
                    XYOUTS, MosaicRect[i].x2-0.01*MosaicRect[i].width, MosaicRect[i].y2-0.08*MosaicRect[i].height, FoVTexts, $
                            ALIGNMENT=1.0, COLOR='000000'xL, CHARSIZE=WithTextCharSize, CHARTHICK=WithTextCharThick+10, /NORMAL
                    XYOUTS, MosaicRect[i].x2-0.01*MosaicRect[i].width, MosaicRect[i].y2-0.08*MosaicRect[i].height, FoVTexts, $
                            ALIGNMENT=1.0, COLOR=cgColor('green'), CHARSIZE=WithTextCharSize, CHARTHICK=WithTextCharThick, /NORMAL
                ENDIF ELSE BEGIN
                    XYOUTS, MosaicRect[i].x1+0.01*MosaicRect[i].width, MosaicRect[i].y2-0.24*MosaicRect[i].height, FoVTexts, $
                            ALIGNMENT=0.0, COLOR='000000'xL, CHARSIZE=WithTextCharSize, CHARTHICK=WithTextCharThick+10, /NORMAL
                    XYOUTS, MosaicRect[i].x1+0.01*MosaicRect[i].width, MosaicRect[i].y2-0.24*MosaicRect[i].height, FoVTexts, $
                            ALIGNMENT=0.0, COLOR=cgColor('green'), CHARSIZE=WithTextCharSize, CHARTHICK=WithTextCharThick, /NORMAL
                ENDELSE
                
                
                ; 
                ; Show Text 
                IF N_ELEMENTS(WithTexts) GT 0 AND N_ELEMENTS(WithTexts) GT i THEN BEGIN 
                    TelTexts = WithTexts[i]
                    IF STRPOS(TelTexts,'--') GT 0 THEN TelTexts = CrabStringReplace(TelTexts,'--',' ')
                ENDIF ELSE BEGIN
                    TelTexts = 'N/A'
                ENDELSE
                IF TelTexts EQ '' OR TelTexts EQ ' ' OR TelTexts EQ 'N/A' OR TelTexts EQ 'n/a' THEN BEGIN
                    TelTexts = RecognizeInstrument(EachFits)+' '+RecognizeFilter(EachFits)
                ENDIF
                IF TelTexts EQ '' OR TelTexts EQ ' ' OR TelTexts EQ 'N/A' OR TelTexts EQ 'n/a' THEN BEGIN
                    ;PRINT, "Recognizing instrument and filter from FitsHeader" ; +FitsHeader[N_ELEMENTS(FitsHeader)-3]
                    TelTexts = RecognizeInstrument(FitsHeader)+' '+RecognizeFilter(FitsHeader)
                ENDIF
                PRINT, "Recognized instrument and filter: "+TelTexts
                IF N_ELEMENTS(WithTextCharSize) EQ 0 THEN WithTextCharSize=1.05
                IF N_ELEMENTS(WithTextCharThick) EQ 0 THEN WithTextCharThick=3.85
                IF WithTextCharSize LT 1.5 THEN BEGIN
                    XYOUTS, MosaicRect[i].x1+0.02*MosaicRect[i].width, MosaicRect[i].y2-0.08*MosaicRect[i].height, TelTexts, $
                            ALIGNMENT=0.0, COLOR='000000'xL, CHARSIZE=WithTextCharSize, CHARTHICK=WithTextCharThick+10.0, /NORMAL
                    XYOUTS, MosaicRect[i].x1+0.02*MosaicRect[i].width, MosaicRect[i].y2-0.08*MosaicRect[i].height, TelTexts, $
                            ALIGNMENT=0.0, COLOR=cgColor('green'), CHARSIZE=WithTextCharSize, CHARTHICK=WithTextCharThick, /NORMAL
                ENDIF ELSE BEGIN
                    XYOUTS, MosaicRect[i].x1+0.01*MosaicRect[i].width, MosaicRect[i].y2-0.12*MosaicRect[i].height, TelTexts, $
                            ALIGNMENT=0.0, COLOR='000000'xL, CHARSIZE=WithTextCharSize, CHARTHICK=WithTextCharThick+10.0, /NORMAL
                    XYOUTS, MosaicRect[i].x1+0.01*MosaicRect[i].width, MosaicRect[i].y2-0.12*MosaicRect[i].height, TelTexts, $
                            ALIGNMENT=0.0, COLOR=cgColor('green'), CHARSIZE=WithTextCharSize, CHARTHICK=WithTextCharThick, /NORMAL
                ENDELSE
                
                
                
                
            ENDIF ELSE BEGIN
            
                PRINT, STRTRIM(FitsOK,2), " ", "Error to cut ", EachFits, "!"
                InvalidText = "Out of FoV!"
                XYOUTS, MosaicRect[i].x2-0.01*MosaicRect[i].width, MosaicRect[i].y2-0.08*MosaicRect[i].height, InvalidText, $
                        ALIGNMENT=1.0, COLOR='000000'xL, CHARSIZE=1.05, CHARTHICK=13.85, /NORMAL
                XYOUTS, MosaicRect[i].x2-0.01*MosaicRect[i].width, MosaicRect[i].y2-0.08*MosaicRect[i].height, InvalidText, $
                        ALIGNMENT=1.0, COLOR=cgColor('green'), CHARSIZE=1.05, CHARTHICK=3.85, /NORMAL
                ; Show Text 
                IF N_ELEMENTS(WithTexts) GT 0 AND N_ELEMENTS(WithTexts) GT i THEN BEGIN 
                    TelTexts = WithTexts[i]
                ENDIF ELSE BEGIN
                    TelTexts = RecognizeInstrument(EachFits)
                ENDELSE
                XYOUTS, MosaicRect[i].x1+0.02*MosaicRect[i].width, MosaicRect[i].y2-0.08*MosaicRect[i].height, TelTexts, $
                        ALIGNMENT=0.0, COLOR='000000'xL, CHARSIZE=1.05, CHARTHICK=13.85, /NORMAL
                XYOUTS, MosaicRect[i].x1+0.02*MosaicRect[i].width, MosaicRect[i].y2-0.08*MosaicRect[i].height, TelTexts, $
                        ALIGNMENT=0.0, COLOR=cgColor('green'), CHARSIZE=1.05, CHARTHICK=3.85, /NORMAL
            
            ENDELSE
            
        ENDIF ELSE BEGIN
            
            
            PRINT, STRTRIM(FitsOK,2), " ", "Error to read ", EachFits, "!"
            InvalidText = "Invalid File!"
            XYOUTS, MosaicRect[i].x2-0.01*MosaicRect[i].width, MosaicRect[i].y2-0.08*MosaicRect[i].height, InvalidText, $
                    ALIGNMENT=1.0, COLOR='000000'xL, CHARSIZE=1.05, CHARTHICK=13.85, /NORMAL ; 'F5FFF5'xL
            XYOUTS, MosaicRect[i].x2-0.01*MosaicRect[i].width, MosaicRect[i].y2-0.08*MosaicRect[i].height, InvalidText, $
                    ALIGNMENT=1.0, COLOR=cgColor('green'), CHARSIZE=1.05, CHARTHICK=3.85, /NORMAL
            TelTexts = RecognizeInstrument(EachFits)
            XYOUTS, MosaicRect[i].x1+0.02*MosaicRect[i].width, MosaicRect[i].y2-0.08*MosaicRect[i].height, TelTexts, $
                    ALIGNMENT=0.0, COLOR='000000'xL, CHARSIZE=1.05, CHARTHICK=13.85, /NORMAL
            XYOUTS, MosaicRect[i].x1+0.02*MosaicRect[i].width, MosaicRect[i].y2-0.08*MosaicRect[i].height, TelTexts, $
                    ALIGNMENT=0.0, COLOR=cgColor('green'), CHARSIZE=1.05, CHARTHICK=3.85, /NORMAL
            
 
        ENDELSE
    ENDFOR
    
    ; Plot Frames again
    FOR i=0,NumbFits-1 DO BEGIN
        tm_icol = i MOD NumbCols
        tm_irow = FIX(i/NumbCols)
        tm_xarr = [0,1,1,0,0]*MosaicRect[i].width  + MosaicRect[i].x1
        tm_yarr = [1,1,0,0,1]*MosaicRect[i].height + MosaicRect[i].y1
        PLOTS, tm_xarr, tm_yarr, /NORMAL, COLOR=cgColor('green'), THICK=1
    ENDFOR
    
    
    IF NOT KEYWORD_SET(SaveEPS) THEN BEGIN
        ;
    ENDIF ELSE BEGIN
        DEVICE, /CLOSE
        SET_PLOT, 'X'
    ENDELSE
    
END