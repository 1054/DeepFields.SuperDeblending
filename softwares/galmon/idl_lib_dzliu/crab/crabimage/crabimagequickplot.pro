; Points   --- [x1,y1,x2,y2,x3,y3]
; Circles  --- [x1,y1,r1,x2,y2,r2,x3,y3,r3]
; 
; 2014-06-09 update WithPointColor=PointColor
; 
PRO CrabImageQuickPlot, GalaxyImage, SavePNG=SavePNG, SaveEPS=SaveEPS, Position=Position, FitsHeaderContainingWCS=FitsHeaderContainingWCS, $
                        WithPoints=Points,  WithPointColor=PointColor, WithPointWidth=PointWidth, WithPointHeight=PointHeight, WithPointLabels=PointLabels, $
                        WithLines=LineDots, WithLineColor=LineColor, WithLineThick=LineThick, WithLineDash=LineDash, $
                        WithCircles=Circles, WithCircleColors=CircleColors, WithCircleWidth=CircleWidth, WithCircleHeight=CircleHeight, WithCircleLabels=CircleLabels, $
                        WithCrosses=Crosses, WithCrossColors=CrossColors, WithCrossLabels=CrossLabels, WithCrossThicks=CrossThicks, $
                        TVZoom=TVZoom, TVScale=TVScale, TVNOSCL=TVNOSCL, ZScale=ZScale, ZNormalize=ZNormalize, $
                        TVWindow=TVWindow, TVTitle=TVTitle, TVPosition=TVPosition, Color=Color, $
                        TVReverseColor=TVReverseColor
    
    
    DeNaNImage = GalaxyImage
    DeNaNImage[WHERE(~FINITE(DeNaNImage))] = 0.0D
    ImageSize = SIZE(DeNaNImage,/DIMENSION)
    
    
    ; SaveEPS
    IF KEYWORD_SET(SaveEPS) THEN BEGIN
        IF 27.0/ImageSize[1]*ImageSize[0] LT 297.0 THEN BEGIN ;<Added><20150802><dzliu> do not exceed 10 A4 paper
            OpenPS, SaveEPS, XSize=27.0/ImageSize[1]*ImageSize[0], YSize=27.0
        ENDIF ELSE BEGIN
            OpenPS, SaveEPS, XSize=297.0, YSize=297.0/ImageSize[0]*ImageSize[1]
        ENDELSE
    ENDIF
    
    
    ; TV Position
    IF !D.NAME EQ 'X' OR !D.NAME EQ 'Win' THEN BEGIN
        IF N_ELEMENTS(TVPosition) GE 2 THEN BEGIN
            ScreenSize = GET_SCREEN_SIZE(Resolution=ScreenRes)
            IF TVPosition[0] LE 1.0 THEN TVPosition[0]=LONG(TVPosition[0]*ScreenSize[0]) ELSE TVPosition[0]=LONG(TVPosition[0])
            IF TVPosition[1] LE 1.0 THEN TVPosition[1]=LONG(TVPosition[1]*ScreenSize[1]) ELSE TVPosition[1]=LONG(TVPosition[1])
        ENDIF
    ENDIF
    
    
    ; TV Zoom
    ; TVZoom has two types: one is scaling factor (<100.0), one is the absolute Y length (>100.0).
    IF !D.NAME EQ 'X' OR !D.NAME EQ 'Win' THEN BEGIN
        IF N_ELEMENTS(TVZoom) GE 1 THEN BEGIN
            TVZoom = Double(TVZoom[0])
        ENDIF ELSE BEGIN
            ScreenSize = GET_SCREEN_SIZE(Resolution=ScreenRes)
            TVZoom = ScreenSize[1]*0.75
        ENDELSE
    ENDIF ELSE IF !D.NAME EQ 'PS' THEN BEGIN
        IF N_ELEMENTS(TVZoom) GE 1 THEN BEGIN
            TVZoom = Double(TVZoom[0])
        ENDIF ELSE BEGIN
            TVSize = [!D.X_SIZE,!D.Y_SIZE]
            TVZoom = 1.0 ; <TODO>
        ENDELSE
    ENDIF
    IF TVZoom GE 100.0 THEN TVZoom=TVZoom/double(ImageSize[1]) ; e.g. TVZoom=900 then set Y side length to 900px.
    
    
    ; Zoom the image
    ImageZoomFactor  = TVZoom ; Zoom image smaller to YSIZE=700
    ImageZoomToXSize = ImageSize[0]
    ImageZoomToYSize = ImageSize[1]
    IF ImageZoomFactor NE 1.0 THEN BEGIN
        ImageZoomToXSize = long(ImageZoomFactor*double(ImageSize[0])+0.5)
        ImageZoomToYSize = long(ImageZoomFactor*double(ImageSize[1])+0.5)
        ArithmExcept=!Except & !Except=0
        ImageZoomed = FREBIN(DeNaNImage, ImageZoomToXSize, ImageZoomToYSize, /TOTAL) ; <TODO> Float Underflow?
        ArithmSilent=CHECK_MATH() & !Except=ArithmExcept
    ENDIF ELSE BEGIN
        ImageZoomed = DeNaNImage
    ENDELSE
    
    
    ; TV Window
    IF N_ELEMENTS(TVWindow) EQ 0 THEN TVWindow=1 ELSE TVWindow=FIX(TVWindow)
    IF !D.NAME EQ 'X' OR !D.NAME EQ 'Win' THEN BEGIN
        IF N_ELEMENTS(TVPosition) NE 2 THEN BEGIN
            Window, TVWindow, XSIZE=ImageZoomToXSize, YSIZE=ImageZoomToYSize, TITLE=TVTitle 
        ENDIF ELSE BEGIN
            Window, TVWindow, XSIZE=ImageZoomToXSize, YSIZE=ImageZoomToYSize, TITLE=TVTitle, XPOS=TVPosition[0], YPOS=TVPosition[1]
        ENDELSE
    ENDIF ELSE IF !D.NAME EQ 'PS' THEN BEGIN
        ; already opened eps above
    ENDIF
    
    ; TV Scale
    IF N_ELEMENTS(TVScale) EQ 0 THEN TVScale=0.8d ELSE TVScale=Double(TVScale)
    
    
    ; Plot the image
    IF NOT KEYWORD_SET(TVScale) OR KEYWORD_SET(TVNOSCL) THEN BEGIN
        
        
         
    ENDIF ELSE BEGIN
        
        ; TVSCL, CrabImagePowerLawScale(ImageZoomed,TVScale), /NAN ; <TODO> ; THIS IS ORIGINAL WAY
        ; PRINT, MIN(GalaxyImage), MAX(GalaxyImage), MIN(ImageZoomed), MAX(ImageZoomed)
        IF N_ELEMENTS(TVScale) EQ 0 THEN TVScale = 1.0
        IF N_ELEMENTS(TVScale) EQ 5 THEN BEGIN
            ZMIN = (MAX(ImageZoomed)-MIN(ImageZoomed))*TVScale[0]+MIN(ImageZoomed)
            ZMAX = (MAX(ImageZoomed)-MIN(ImageZoomed))*TVScale[1]+MIN(ImageZoomed)
            ZPER = [ TVScale[2], TVScale[3] ]
            PSCL = TVScale[4]
        ENDIF ELSE IF N_ELEMENTS(TVScale) EQ 3 THEN BEGIN
            ZMIN = MIN(ImageZoomed)
            ZMAX = MAX(ImageZoomed)
            ZPER = [ TVScale[0], TVScale[1] ]
            PSCL = TVScale[2]
        ENDIF ELSE BEGIN
            ZMIN = MIN(ImageZoomed)
            ZMAX = MAX(ImageZoomed)
            ZPER = []
            PSCL = TVScale[0]
        ENDELSE
        ; ZScale, the absolute value for ZMIN ZMAX
        IF N_ELEMENTS(ZScale) EQ 2 THEN BEGIN
            IF ZScale[0] LT ZScale[1] THEN BEGIN
            ZMIN = ZScale[0]
            ZMAX = ZScale[1]
            ENDIF ELSE BEGIN
            ZScale = [ZMIN,ZMAX]
            ENDELSE
        ENDIF ELSE BEGIN
            ZScale = [ZMIN,ZMAX]
        ENDELSE
        ; ZNormalize
        IF N_ELEMENTS(ZNormalize) EQ 1 THEN BEGIN
            ZNOM = ZNormalize
        ENDIF ELSE BEGIN
            ZNOM = []
        ENDELSE
        ;<TODO>; POWERSCALE
        ; ImagePowerScaled = CrabImagePowerLawScale(ImageZoomed,PSCL,MIN=ZMIN,MAX=ZMAX,PERCENT=ZPER,NORMAL=ZNOM,/ByteScale)
        ; ImageBytesScaled = BYTSCL(ImagePowerScaled,MIN=ZMIN,MAX=ZMAX,/NAN)
        ImagePowerScaled = CrabImagePowerLawScale(ImageZoomed,PSCL,MIN=ZMIN,MAX=ZMAX,PERCENT=ZPER,NORMAL=ZNOM,/ByteScale)
        ImageBytesScaled = ImagePowerScaled
        
        IF KEYWORD_SET(TVReverseColor) THEN BEGIN
            ImageBytesScaled = 255-ImageBytesScaled
            ImageBytesScaled = ImageBytesScaled + 15 ; <TODO> add normalization
            IF N_ELEMENTS(WHERE(ImageBytesScaled GT 255,/NULL)) GT 0 THEN ImageBytesScaled[WHERE(ImageBytesScaled GT 255)] = 255
        ENDIF
        
        ; <TODO><DEBUG> draw border
        ;; ImageBytesScaled[0:1,*] = 255
        ;; ImageBytesScaled[-1,*] = 255
        ;; ImageBytesScaled[*,0:1] = 255
        ;; ImageBytesScaled[*,-1] = 255
        
        ; TV
        IF N_ELEMENTS(Position) EQ 4 THEN BEGIN
            ImageOldSize = SIZE(ImageBytesScaled,/DIM)
            ImageNewSize = DOUBLE(ImageOldSize)*[(Position[2]-Position[0]),(Position[3]-Position[1])]
            ImageBytesScaled = frebin(ImageBytesScaled, ImageNewSize[0], ImageNewSize[1])
            ImageZoomFactor = ImageZoomFactor * MEAN(ImageNewSize/ImageOldSize)
        ENDIF
        
        ; Color
        IF NOT KEYWORD_SET(Color) THEN BEGIN
            IF !D.NAME EQ 'PS' THEN DEVICE, COLOR=0
            DEVICE, GET_DECOMPOSED=old_decomposed, DECOMPOSED = 0
        ENDIF ELSE BEGIN
            TempColorTriple = []
            IF SIZE(Color,/TNAME) EQ 'STRING' THEN BEGIN
                TempColorTriple = cgColor(Color, /Triple)
            ENDIF ELSE IF N_ELEMENTS(Color) EQ 3 THEN BEGIN
                TempColorTriple = REFORM(Color, 1, 3)
            ENDIF ELSE IF SIZE(Color,/TNAME) EQ 'LONG' THEN BEGIN
                TempColorTriple_B = (Color)/2L^16
                TempColorTriple_G = (Color-TempColorTriple_B*2L^16)/2L^8
                TempColorTriple_R = (Color-TempColorTriple_B*2L^16-TempColorTriple_G*2L^8)
                TempColorTriple = REFORM([TempColorTriple_R,TempColorTriple_G,TempColorTriple_B], 1, 3)
            ENDIF
            IF N_ELEMENTS(TempColorTriple) GT 0 THEN BEGIN
                ImageBytesGrey = ImageBytesScaled
                ImageBytesRGB = MAKE_ARRAY(3,(SIZE(ImageBytesGrey,/DIM))[0],(SIZE(ImageBytesGrey,/DIM))[1],/BYTE,VALUE=0)
                ImageBytesRGB[0,*,*] = BYTE( FLOAT(TempColorTriple[0,0])/255.0 * ImageBytesGrey[*,*] )
                ImageBytesRGB[1,*,*] = BYTE( FLOAT(TempColorTriple[0,1])/255.0 * ImageBytesGrey[*,*] )
                ImageBytesRGB[2,*,*] = BYTE( FLOAT(TempColorTriple[0,2])/255.0 * ImageBytesGrey[*,*] )
                ImageBytesScaled = ImageBytesRGB
            ENDIF ELSE BEGIN
                ; if user specified Color=3dDataArray, instead of some Color=cgColor('dogger blue'), or Color=[172,128,100], 
                ; then we assume the user input Color=3dDataArray is the 
                ImageBytesR = REFORM(Color[0,*,*])
                ImageBytesG = REFORM(Color[1,*,*])
                ImageBytesB = REFORM(Color[2,*,*])
                ImageBytesScaledR = frebin(ImageBytesR, ImageZoomToXSize, ImageZoomToYSize)
                ImageBytesScaledG = frebin(ImageBytesG, ImageZoomToXSize, ImageZoomToYSize)
                ImageBytesScaledB = frebin(ImageBytesB, ImageZoomToXSize, ImageZoomToYSize)
                ImageBytesScaledR = BYTSCL(ImageBytesScaledR)
                ImageBytesScaledB = BYTSCL(ImageBytesScaledB)
                ImageBytesScaledG = BYTSCL(ImageBytesScaledG)
                ImageBytesScaled = MAKE_ARRAY(3,(SIZE(ImageBytesScaledR,/DIM))[0],(SIZE(ImageBytesScaledR,/DIM))[1],/BYTE,VALUE=0)
                ImageBytesScaled[0,*,*] = BYTE( ImageBytesScaledR )
                ImageBytesScaled[1,*,*] = BYTE( ImageBytesScaledG )
                ImageBytesScaled[2,*,*] = BYTE( ImageBytesScaledB )
            ENDELSE
        ENDELSE
        
        ; <TODO><debug>
        PRINT, 'ImageBytesScaled: MIN MAX MEAN ', MIN(ImageBytesScaled), MAX(ImageBytesScaled), MEAN(ImageBytesScaled)
        
        ; TV
        IF N_ELEMENTS(Position) EQ 4 THEN BEGIN
            ImageDoSmallClip = 0.00 ; <TODO>
            TV, ImageBytesScaled, Position[0]+ImageDoSmallClip, Position[1]+ImageDoSmallClip, XSIZE=(Position[2]-Position[0]-ImageDoSmallClip-ImageDoSmallClip), YSIZE=(Position[3]-Position[1]-ImageDoSmallClip-ImageDoSmallClip), /NAN, /Normal, TRUE=KEYWORD_SET(Color) ; <TODO> NOT TESTED !
        ENDIF ELSE IF N_ELEMENTS(Position) EQ 2 THEN BEGIN
            TV, ImageBytesScaled, Position[0], Position[1], /NAN, /Normal, TRUE=KEYWORD_SET(Color) ; <TODO> NOT TESTED !
        ENDIF ELSE BEGIN
            TV, ImageBytesScaled, /NAN, TRUE=KEYWORD_SET(Color)
        ENDELSE
        
        ; Color
        IF NOT KEYWORD_SET(Color) THEN BEGIN
            DEVICE, DECOMPOSED = old_decomposed
            IF !D.NAME EQ 'PS' THEN DEVICE, COLOR=1
        ENDIF
    ENDELSE
    
    
    ; Plot Points
    FOR PointId=0,(N_ELEMENTS(Points)/2)-1 DO BEGIN
        ; Plot Symbol
        PtWidth = 6 ; 20
        IF N_ELEMENTS(PointWidth) GT 0 THEN BEGIN
            IF PointId LT N_ELEMENTS(PointWidth) THEN BEGIN
                PtWidth = PointWidth[PointId]
            ENDIF ELSE BEGIN
                PtWidth = PointWidth[N_ELEMENTS(PointWidth)-1]
            ENDELSE
            PtWidth = FIX(PtWidth)
        ENDIF
        PtHeight = 6 ; 20
        IF N_ELEMENTS(PointHeight) GT 0 THEN BEGIN
            IF PointId LT N_ELEMENTS(PointHeight) THEN BEGIN
                PtHeight = PointHeight[PointId]
            ENDIF ELSE BEGIN
                PtHeight = PointHeight[N_ELEMENTS(PointHeight)-1]
            ENDELSE
            PtHeight = FIX(PtHeight)
        ENDIF
        ; Plot Color
        PtColor = '33FFAA'xL
        IF N_ELEMENTS(PointColor) GT 0 THEN BEGIN
            IF PointId LT N_ELEMENTS(PointColor) THEN BEGIN
                PtColor = PointColor[PointId]
            ENDIF ELSE BEGIN
                PtColor = PointColor[N_ELEMENTS(PointColor)-1]
            ENDELSE
            IF SIZE(PtColor,/TNAME) EQ "STRING" THEN PtColor=cgColor(PtColor)
        ENDIF
        ; Plot now
        PLOTS, FINDGEN(PtWidth)*00+Points[2*PointId+0]*ImageZoomFactor, FINDGEN(PtHeight)-PtHeight/2+Points[2*PointId+1]*ImageZoomFactor, $
               SYMSIZE=0.5, COLOR=PtColor, /DEVICE
        PLOTS, FINDGEN(PtWidth)-PtWidth/2+Points[2*PointId+0]*ImageZoomFactor, FINDGEN(PtHeight)*00+Points[2*PointId+1]*ImageZoomFactor, $
               SYMSIZE=0.5, COLOR=PtColor, /DEVICE
        ; Plot Point Labels
        IF N_ELEMENTS(PointLabels) GT 0 THEN BEGIN
            IF PointId LT N_ELEMENTS(PointLabels) THEN BEGIN
                PtLabel = PointLabels[PointId]
            ENDIF ELSE BEGIN
                PtLabel = ""
            ENDELSE
            IF SIZE(PtLabel,/TNAME) NE "STRING" THEN PtLabel=STRTRIM(STRING(PtLabel),2)
            IF STRLEN(PtLabel) GT 0 THEN XYOUTS, Points[2*PointId+0]*ImageZoomFactor, Points[2*PointId+1]*ImageZoomFactor, PtLabel, COLOR=PtColor, /DEVICE
        ENDIF
    ENDFOR
    
    
    ; Plot Lines <TODO> please input normalized coordinates
    FOR LineDotsId=0,(N_ELEMENTS(LineDots)/2)-1 DO BEGIN
        IF LineDotsId EQ 0 THEN BEGIN
            LineXArr = []
            LineYArr = []
        ENDIF
        IF FINITE(LineDots[2*LineDotsId+0]) AND FINITE(LineDots[2*LineDotsId+1]) THEN BEGIN
            LineXArr = [LineXArr, LineDots[2*LineDotsId+0]]
            LineYArr = [LineYArr, LineDots[2*LineDotsId+1]]
        ENDIF
        IF LineDotsId EQ (N_ELEMENTS(LineDots)/2)-1 OR ~FINITE(LineDots[2*LineDotsId+0]) OR ~FINITE(LineDots[2*LineDotsId+1]) THEN BEGIN
            IF N_ELEMENTS(LineDash) EQ 0 THEN LineDash=2
            IF N_ELEMENTS(LineColor) EQ 0 THEN LineColor=cgColor('green')
            PLOTS, LineXArr, LineYArr, LineStyle=LineDash, Color=LineColor, Thick=LineThick, /NORMAL
            ;;PRINT, 'Debug: CrabImageQuickPlot: Plotting with lines'
            LineXArr = []
            LineYArr = []
        ENDIF
    ENDFOR
    
    
    ; Plot Circles
    CrabImageTVCircle, Circles, CircleColors=CircleColors, CircleLabels=CircleLabels, ImageSize=ImageSize, FitsHeaderContainingWCS=FitsHeaderContainingWCS, /Silent
    CrabImageTVCross, Crosses, CrossColors=CrossColors, CrossLabels=CrossLabels, CrossThicks=CrossThicks, ImageSize=ImageSize, FitsHeaderContainingWCS=FitsHeaderContainingWCS, /Silent
    
    
    ; Save EPS
    IF KEYWORD_SET(SaveEPS) THEN BEGIN
        DEVICE, /CLOSE
        SET_PLOT, 'X'
        PRINT, 'ClosePS: '+SaveEPS
    ENDIF
    
    ; Save PNG
    IF N_ELEMENTS(SavePNG) EQ 1 THEN BEGIN
        IF !VERSION.OS EQ 'darwin' THEN BEGIN
            DEVICE, GET_WINDOW_POSITION=winPos, GET_SCREEN_SIZE=scnSize
           ;PRINT, 'screencapture -P -x -o -R '+STRING(FORMAT='(I0,",",I0,",",I0,",",I0)',winPos[0],scnSize[1]-!D.Y_SIZE+16,!D.X_SIZE,!D.Y_SIZE)+ ' '+SavePNG
           ;SPAWN, 'screencapture -P -x -o -R '+STRING(FORMAT='(I0,",",I0,",",I0,",",I0)',winPos[0],scnSize[1]-!D.Y_SIZE+16,!D.X_SIZE,!D.Y_SIZE)+ ' '+SavePNG
           ;PRINT, 'screencapture -x -o -R'+STRING(FORMAT='(I0,",",I0,",",I0,",",I0)',winPos[0],scnSize[1]-!D.Y_SIZE+16,!D.X_SIZE,!D.Y_SIZE)+ ' '+SavePNG
            SPAWN, 'screencapture -x -o -R'+STRING(FORMAT='(I0,",",I0,",",I0,",",I0)',winPos[0],scnSize[1]-!D.Y_SIZE+16,!D.X_SIZE,!D.Y_SIZE)+ ' '+SavePNG
        ENDIF ELSE BEGIN
            WSET, TVWindow
            ScrCopy = TVRD(/true)
            WRITE_IMAGE, SavePNG, 'PNG', ScrCopy, /RGB
        ENDELSE
    ENDIF
    
END
    