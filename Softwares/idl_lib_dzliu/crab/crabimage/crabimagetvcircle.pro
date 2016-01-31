; 
; TVCircle
; 
; Note that the coordinate of Circles are the image coordinates starting from 1 rather than 0 !
; 
PRO CrabImageTVCircle, Circles, CircleColors=CircleColors, CircleDashed=CircleDashed, CircleLabels=CircleLabels, CircleThicks=CircleThicks, $
                       FitsHeaderContainingWCS=FitsHeaderContainingWCS, $
                       POSITION=POSITION, ImageRect=ImageRect, ImageSize=ImageSize, NoClip=NoClip, $
                       TVSize=TVSize, TVPositionIJ=TVPositionIJ, $
                       Silent=Silent
                       ; <TODO> CircleLabelCharSize=CircleLabelCharSize, 
    
    
    ; Check Circles
    IF N_ELEMENTS(Circles) EQ 0 THEN BEGIN
        IF NOT KEYWORD_SET(Silent) THEN PRINT, 'CrabImageTVCircle: No circles input. '
        RETURN
    ENDIF
    
    
;    ; Check Device X or Win
;    IF !D.NAME EQ 'X' OR !D.NAME EQ 'Win' THEN BEGIN
;        DEVICE, GET_SCREEN_SIZE=ScnSize
;        WinId = !D.WINDOW
;        WinTitle = STRING(FORMAT='("IDL ",I0)',WinId)
;    ENDIF
    
    
    ; Check Parameters <20140718><DzLIU>
    IF N_ELEMENTS(TVPositionIJ) EQ 4 THEN BEGIN
        ImageRect = TVPositionIJ
    ENDIF
    IF N_ELEMENTS(POSITION) EQ 4 THEN BEGIN
        ImageRect = POSITION
    ENDIF
    
    
    ; Check Normalization
    IF N_ELEMENTS(ImageRect) EQ 4 THEN BEGIN ; x0 y0 x1 y1
        IF ImageRect[0] GE 0.0 AND ImageRect[0] LE 1.0 AND ImageRect[1] GE 0.0 AND ImageRect[1] LE 1.0 THEN BEGIN
            ImageRect[0] = ImageRect[0]*!D.X_SIZE
            ImageRect[1] = ImageRect[1]*!D.Y_SIZE
        ENDIF
        IF ImageRect[2] GE 0.0 AND ImageRect[2] LE 1.0 AND ImageRect[3] GE 0.0 AND ImageRect[3] LE 1.0 THEN BEGIN
            ImageRect[2] = ImageRect[2]*!D.X_SIZE
            ImageRect[3] = ImageRect[3]*!D.Y_SIZE
        ENDIF
    ENDIF ELSE BEGIN
        ; <TODO> 
        ; IF !D.NAME EQ 'PS' THEN BEGIN
        ;     ImageRect = [0.0,0.0,!D.X_SIZE,!D.Y_SIZE]
        ; ENDIF ELSE BEGIN
        ;     ImageRect = [0.0,0.0,!D.X_SIZE,!D.Y_SIZE]
        ; ENDELSE
        ImageRect = [0.0,0.0,!D.X_SIZE,!D.Y_SIZE]
        ; <TODO>
        ; MESSAGE, 'Error! Could not determine ImageRect!? <BUG>'
    ENDELSE
    
    IF N_ELEMENTS(ImageSize) EQ 0 AND !D.NAME EQ 'PS' AND N_ELEMENTS(FitsHeaderContainingWCS) EQ 0 THEN BEGIN ; <TODO><20141017><DzLIU> ; <TODO><20141206><DzLIU>
        PRINT, 'CrabImageTVCircle: Warning! When plotting on to PS file, we would better set ImageSize to [NAXIS1,NAXIS2], otherwise we might get strange figure.'
    ENDIF
    
    
    
;    ; Check Device PS
;    IF N_ELEMENTS(TVPositionIJ) EQ 4 THEN BEGIN ; TVPositionIJ has the highest priority
;;        ImageSize = [TVPositionIJ[2]-TVPositionIJ[0], TVPositionIJ[3]-TVPositionIJ[1]]
;        TVSize = [TVPositionIJ[2]-TVPositionIJ[0], TVPositionIJ[3]-TVPositionIJ[1]]
;        IF TVPositionIJ[0] GE 0.0 AND TVPositionIJ[0] LE 1.0 AND TVPositionIJ[2] GE 0.0 AND TVPositionIJ[2] LE 1.0 THEN BEGIN
;;            ImageSize[0]=ImageSize[0]*!D.X_SIZE
;            TVSize[0]=TVSize[0]*!D.X_SIZE
;        ENDIF
;        IF TVPositionIJ[1] GE 0.0 AND TVPositionIJ[1] LE 1.0 AND TVPositionIJ[3] GE 0.0 AND TVPositionIJ[3] LE 1.0 THEN BEGIN
;;            ImageSize[1]=ImageSize[1]*!D.Y_SIZE
;            TVSize[1]=TVSize[1]*!D.Y_SIZE
;        ENDIF
;    ENDIF ELSE BEGIN ;<TODO><Added><DzLIU><20140717>
;        TVSize = [!D.X_SIZE,!D.Y_SIZE]
;    ENDELSE
;    IF !D.NAME NE 'PS' AND N_ELEMENTS(ImageSize) EQ 2 AND N_ELEMENTS(TVSize) NE 2 THEN BEGIN
;        TVSize=ImageSize
;    ENDIF
;    IF !D.NAME EQ 'PS' AND N_ELEMENTS(ImageSize) EQ 2 AND N_ELEMENTS(TVSize) NE 2 THEN BEGIN
;        TVSize=ImageSize
;    ENDIF
;    IF !D.NAME EQ 'PS' AND N_ELEMENTS(ImageSize) NE 2 AND N_ELEMENTS(TVSize) NE 2 THEN BEGIN
;        MESSAGE, 'CrabImageTVCircle: When plotting to PS, please set TVSize=NAXIS to convert to image coordinate!'
;        RETURN
;    ENDIF
;    IF !D.NAME EQ 'PS' AND N_ELEMENTS(TVSize) NE 2 THEN BEGIN
;        MESSAGE, 'CrabImageTVCircle: When plotting to PS, please set TVSize=NAXIS to convert to image coordinate!'
;        RETURN
;    ENDIF
    
    
    ; Check TVSize
    ; [!D.X_SIZE,!D.Y_SIZE] ; !D.XY_SIZE is the full window/device size, while the ImageSize is the coordinate!
    ;                       ; if device is PS, then TVSize elements are in unit of 1e-3 cm
    
    ; Check CircleColors
    IF SIZE(CircleColors,/TNAME) EQ "STRING" THEN BEGIN
        CColors = FINDGEN(N_ELEMENTS(CircleColors))
        FOR i=0,N_ELEMENTS(CircleColors)-1 DO CColors[i]=cgColor(CircleColors[i])
    ENDIF ELSE IF SIZE(CircleColors,/TNAME) EQ "FLOAT" OR SIZE(CircleColors,/TNAME) EQ "DOUBLE" THEN BEGIN
        LOADCT, 13
        CColors = BYTSCL(CircleColors)
    ENDIF ELSE IF SIZE(CircleColors,/TNAME) EQ "LONG" THEN BEGIN
        ; no need to change
        CColors = CircleColors
        ;Device, COLOR=1, BITS_PER_PIXEL=8
    ENDIF ELSE IF SIZE(CircleColors,/TNAME) EQ "INT" THEN BEGIN
        ; no need to change
    ENDIF ELSE BEGIN
        CColors = !NULL
    ENDELSE
    
    ; Check CircleDashed
    IF N_ELEMENTS(CircleDashed) GT 0 THEN BEGIN
        CDashed = CircleDashed
    ENDIF
    
    ; Check CircleLabels
    IF N_ELEMENTS(CircleLabels) GT 0 THEN BEGIN
        CLabels = CircleLabels
    ENDIF
    
    ; Check CircleThicks
    IF N_ELEMENTS(CircleThicks) GT 0 THEN BEGIN
        CThicks = CircleThicks
    ENDIF
    
    ; Check CircleLabelCharSize
    IF N_ELEMENTS(CircleLabelCharSize) GT 0 THEN BEGIN
        CLabChs = CircleLabelCharSize
    ENDIF
    
    
    ; Check Input Circles
    ; IF N_ELEMENTS(Circles) LT 3 THEN BEGIN
    ;     MESSAGE, 'No circles!'
    ; ENDIF
    IF SIZE(Circles,/TNAME) EQ 'STRUCT' THEN BEGIN
        CircleCount = N_ELEMENTS(Circles)
        CPosX = Circles.(0)
        CPosY = Circles.(1)
        CPosR = Circles.(2)
        CPixI = CPosX-1
        CPixJ = CPosY-1
        CPixR = CPosR
    ENDIF ELSE BEGIN
        CircleCount = FIX(N_ELEMENTS(Circles)/3.0)
        CI = INDGEN(CircleCount)
        CPosX = Circles[CI*3+0]
        CPosY = Circles[CI*3+1]
        CPosR = Circles[CI*3+2]
        CPixI = CPosX-1
        CPixJ = CPosY-1
        CPixR = CPosR
    ENDELSE
    
    ; WCS AD2XY
    IF N_ELEMENTS(FitsHeaderContainingWCS) GT 0 THEN BEGIN
        CPosRA  = CPosX
        CPosDec = CPosY
        CrabImageAD2XY, CPosRA, CPosDec, FitsHeaderContainingWCS, CPixX, CPixY, /DoNotCheck, FitsAstr=FitsAstr
        CPixI = CPixX - 1
        CPixJ = CPixY - 1
        CPixR = CPixR / (FitsAstr.CD[1,1]*FitsAstr.CDELT[1]*3600.0d)
    ENDIF
    
    ; Loop each circle
    FOR CI=0,CircleCount-1 DO BEGIN
        
        ; Color
        IF CI LT N_ELEMENTS(CColors) THEN CColor=CColors[CI] ELSE IF N_ELEMENTS(CColors) GT 0 THEN CColor=CColors[-1] ELSE CColor=cgColor('green')
        
        ; Thick
        IF CI LT N_ELEMENTS(CThicks) THEN CThick=CThicks[CI] ELSE IF N_ELEMENTS(CThicks) GT 0 THEN CThick=CThicks[-1] ELSE CThick=2.0 ; !NULL
        
        ; LDash
        IF CI LT N_ELEMENTS(CDashed) THEN CLDash=CDashed[CI] ELSE IF N_ELEMENTS(CDashed) GT 0 THEN CLDash=CDashed[-1] ELSE CLDash=0 ; !NULL
        
        ; Label
        IF CI LT N_ELEMENTS(CLabels) THEN CLabel=CLabels[CI] ELSE IF N_ELEMENTS(CLabels) GT 0 THEN CLabel=CLabels[-1] ELSE CLabel=!NULL
        
        ; Label CharSize
        IF CI LT N_ELEMENTS(CLabChs) THEN CLabCh=CLabChs[CI] ELSE IF N_ELEMENTS(CLabChs) GT 0 THEN CLabCh=CLabChs[-1] ELSE CLabCh=1.0
        
        
;        ; Zoom from TVSize to !DSize -- if the image is not full screen ---- NOW we input an FitsHeaderContainingWCS to define the data coordinate!
;        ; Use FitsHeaderContainingWCS to map from data coordinate to device coordinate!
;        ; <TODO>???<TODO>
        
        
        ; Cut part of circle if outside of FoV
        IF N_ELEMENTS(ImageSize) EQ 2 THEN BEGIN ; if you set TVPositionIJ, then TVSize is calculated automatically. 
            ZoomI = 1.0D / (ImageSize[0]-1.0d) * (ImageRect[2]-ImageRect[0])
            ZoomJ = 1.0D / (ImageSize[1]-1.0d) * (ImageRect[3]-ImageRect[1])
            CPixI[CI] = CPixI[CI] * ZoomI
            CPixJ[CI] = CPixJ[CI] * ZoomJ
            CPixR[CI] = CPixR[CI] * ZoomJ
        ENDIF
        
        
        ; Prepare Circles
        CArrT = FINDGEN(360,START=1) ; 1-360
        CArrT = CrabArrayINDGEN(0.0d,360.0d,1.0d) ; <TODO> 0.0d,360.0d,10.0d for small circles
        IF CLDash EQ 1 THEN CArrT = CrabArrayINDGEN(0.0d,360.0d,12.0d)
        CArrI = CPixI[CI] + CPixR[CI]*COS(CArrT/180.d*!PI)
        CArrJ = CPixJ[CI] + CPixR[CI]*SIN(CArrT/180.d*!PI)
        CUnit = (CArrI[1]-CArrI[0])^2+(CArrJ[1]-CArrJ[0])^2 ; <Added><20150107> new method for plotting and clipping
        
        
        ;<DEBUG>
        NoClip = !NULL ; <corrected><20150505><dzliu> NoClip = 0 --> NoClip = !NULL -- otherwise some circles are not shown. 
        
        
        ; Exclude outside circles and/or Cut the outside part of circle
        IF NOT KEYWORD_SET(NoClip) THEN BEGIN
            CInvd = WHERE(CArrI GE 0 AND CArrI LE (ImageRect[2]-ImageRect[0]) AND CArrJ GE 0 AND CArrJ LE (ImageRect[3]-ImageRect[1]), /NULL) 
            IF N_ELEMENTS(CInvd) LE 1 THEN CONTINUE ; <Corrected><20140909><DzLIU> N_ELEMENTS(CInvd) LE 1
            CArrI = CArrI[CInvd] ; <Corrected><20140909><20141206><DzLIU>
            CArrJ = CArrJ[CInvd] ; <Corrected><20140909><20141206><DzLIU>
            ;<TODO> ; do clip left
            ;<TODO> IF N_ELEMENTS(WHERE(CArrI LT 0,/NULL)) GT 0 THEN BEGIN
            ;<TODO> ENDIF
        ENDIF
        
        
        ; Position
        IF ImageRect[0] GT 0.0 THEN BEGIN
            CArrI = CArrI + ImageRect[0]
            CPixI[CI] = CPixI[CI] + ImageRect[0]
        ENDIF
        IF ImageRect[1] GT 0.0 THEN BEGIN
            CArrJ = CArrJ + ImageRect[1]
            CPixJ[CI] = CPixJ[CI] + ImageRect[1]
        ENDIF
        
        
        ; Do plot with dots ? <TODO>
;        PLOTS, CArrI, CArrJ, /DEVICE, Color=CColor, Thick=CThick, PSYM=3
        
        ; Do plot with line ? <TODO>
;        IF !D.NAME EQ 'X' THEN BEGIN
;            !P.CLIP[2] = !D.X_SIZE
;            !P.CLIP[3] = !D.Y_SIZE
;        ENDIF
;        PLOTS, CArrI, CArrJ, /DEVICE, Color=CColor, Thick=CThick, LINESTYLE=CLDash, NoClip=NoClip
        FOR CPltN = 0,N_ELEMENTS(CArrI)-1 DO BEGIN ; <Added><20150107> new method for plotting and clipping
            IF CPltN EQ 0 THEN BEGIN
                IF (CArrI[N_ELEMENTS(CArrI)-1]-CArrI[0])^2+(CArrJ[N_ELEMENTS(CArrJ)-1]-CArrJ[0])^2 LE 3.168*CUnit THEN BEGIN
                    PLOTS, [CArrI[N_ELEMENTS(CArrI)-1],CArrI[0]], [CArrJ[N_ELEMENTS(CArrJ)-1],CArrJ[0]], $
                          /DEVICE, Color=CColor, Thick=CThick, LINESTYLE=CLDash, NoClip=NoClip
                ENDIF
            ENDIF ELSE BEGIN
                IF (CArrI[CPltN-1]-CArrI[CPltN])^2+(CArrJ[CPltN-1]-CArrJ[CPltN])^2 LE 3.168*CUnit THEN BEGIN ; <corrected><20150505><dzliu> 3.068*CUnit --> 3.168*CUnit -- otherwise some circles are not shown. 
                    PLOTS, CArrI[CPltN-1:CPltN], CArrJ[CPltN-1:CPltN], $
                          /DEVICE, Color=CColor, Thick=CThick, LINESTYLE=CLDash, NoClip=NoClip
                ENDIF
            ENDELSE
        ENDFOR
        
        
        ; Label
        IF N_ELEMENTS(CLabel) GT 0 THEN BEGIN
            IF CLabel NE '' THEN BEGIN
                CCharSize = 0.36*CPixR[CI] / !D.Y_CH_SIZE
                CCharThick = 0.36*CPixR[CI] / !D.Y_CH_SIZE
                IF !D.NAME EQ 'PS' THEN CCharThick = CCharThick * 2.0
                XYOUTS, MEAN(CArrI), MAX(CArrJ), CLabel, /DEVICE, Color=CColor, ALIGN=0.5, CharSize=CCharSize, CharThick=CCharThick; CharSize=1.25 ; <TODO> Y use MEAN(CArrJ)
                      ; <TODO> if we want to show the label right above the circle, use Y = MAX(CArrJ)
                      ; <TODO> if we want to show the label almost at the center of the circle, use Y = MEAN(CArrJ)
            ENDIF
        ENDIF
        
    ENDFOR
     
    
    
END