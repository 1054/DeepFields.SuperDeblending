; 
; TVCross
; 
; Note that the coordinate of Crosses are the image coordinates starting from 1 rather than 0 !
; 
PRO CrabImageTVCross,  Crosses, CrossColors=CrossColors, CrossLabels=CrossLabels, CrossThicks=CrossThicks, $
                       FitsHeaderContainingWCS=FitsHeaderContainingWCS, $
                       POSITION=POSITION, ImageRect=ImageRect, ImageSize=ImageSize, NoClip=NoClip, $
                       TVSize=TVSize, TVPositionIJ=TVPositionIJ, $
                       Silent=Silent
                       ; <TODO> CrossLabelCharSize=CrossLabelCharSize, 
    
    
    ; Check Crosses
    IF N_ELEMENTS(Crosses) EQ 0 THEN BEGIN
        IF NOT KEYWORD_SET(Silent) THEN PRINT, 'CrabImageTVCross: No Crosses input. '
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
        ImageRect = [0.0,0.0,!D.X_SIZE,!D.Y_SIZE]
        ; <TODO>
        ; MESSAGE, 'Error! Could not determine ImageRect!? <BUG>'
    ENDELSE
    
    IF N_ELEMENTS(ImageSize) EQ 0 AND !D.NAME EQ 'PS' AND N_ELEMENTS(FitsHeaderContainingWCS) EQ 0 THEN BEGIN ; <TODO><20141017><DzLIU> ; <TODO><20141206><DzLIU>
        PRINT, 'CrabImageTVCross: Warning! When plotting on to PS file, we would better set ImageSize to [NAXIS1,NAXIS2], otherwise we might get strange figure.'
    ENDIF
    
    
    
    ; Check Device PS
;    IF !D.NAME EQ 'PS' THEN BEGIN
;        IF N_ELEMENTS(TVPositionIJ) EQ 4 THEN BEGIN ; TVPositionIJ has the highest priority ; x0 y0 x1 y1
;            TVSize = [TVPositionIJ[2]-TVPositionIJ[0], TVPositionIJ[3]-TVPositionIJ[1]]
;            IF TVPositionIJ[0] GE 0.0 AND TVPositionIJ[0] LE 1.0 AND TVPositionIJ[2] GE 0.0 AND TVPositionIJ[2] LE 1.0 THEN BEGIN
;                TVSize[0]=TVSize[0]*!D.X_SIZE
;            ENDIF
;            IF TVPositionIJ[1] GE 0.0 AND TVPositionIJ[1] LE 1.0 AND TVPositionIJ[3] GE 0.0 AND TVPositionIJ[3] LE 1.0 THEN BEGIN
;                TVSize[1]=TVSize[1]*!D.Y_SIZE
;            ENDIF
;        ENDIF ELSE BEGIN ;<TODO><Added><DzLIU><20140717>
;            TVSize = [!D.X_SIZE,!D.Y_SIZE]
;            TVPositionIJ = [0,0,!D.X_SIZE,!D.Y_SIZE]
;        ENDELSE
;        IF N_ELEMENTS(TVSize) NE 2 THEN BEGIN
;            MESSAGE, 'CrabImageTVCross: When plotting to PS, please set TVSize=NAXIS to convert to image coordinate!'
;            RETURN
;        ENDIF
;        IF N_ELEMENTS(TVSize) NE 2 THEN BEGIN
;            MESSAGE, 'CrabImageTVCross: When plotting to PS, please set TVSize=NAXIS to convert to image coordinate!'
;            RETURN
;        ENDIF
;    ENDIF
    
    ; Check TVSize
    ; [!D.X_SIZE,!D.Y_SIZE] ; !D.XY_SIZE is the full window/device size, while the ImageSize is the coordinate!
    ;                       ; if device is PS, then TVSize elements are in unit of 1e-3 cm
    
    ; Check CrossColors
    IF SIZE(CrossColors,/TNAME) EQ "STRING" THEN BEGIN
        CColors = FINDGEN(N_ELEMENTS(CrossColors))
        FOR i=0,N_ELEMENTS(CrossColors)-1 DO CColors[i]=cgColor(CrossColors[i])
    ENDIF ELSE IF SIZE(CrossColors,/TNAME) EQ "FLOAT" OR SIZE(CrossColors,/TNAME) EQ "DOUBLE" THEN BEGIN
        LOADCT, 13
        CColors = BYTSCL(CrossColors)
    ENDIF ELSE IF SIZE(CrossColors,/TNAME) EQ "LONG" THEN BEGIN
        ; no need to change
        CColors = CrossColors
        Device, COLOR=1, BITS_PER_PIXEL=8, DECOMPOSED=1
    ENDIF ELSE IF SIZE(CrossColors,/TNAME) EQ "INT" THEN BEGIN
        ; no need to change
    ENDIF ELSE BEGIN
        CColors = !NULL
    ENDELSE
    
    ; Check CrossThicks
    IF N_ELEMENTS(CrossThicks) GT 0 THEN BEGIN
        CThicks = CrossThicks
    ENDIF
    
    ; Check CrossLabels
    IF N_ELEMENTS(CrossLabels) GT 0 THEN BEGIN
        CLabels = CrossLabels
    ENDIF
    
    ; Check CrossLabelCharSize
    IF N_ELEMENTS(CrossLabelCharSize) GT 0 THEN BEGIN
        CLabChs = CrossLabelCharSize
    ENDIF
    
    
    ; Check Input Crosses
    ; IF N_ELEMENTS(Crosses) LT 3 THEN BEGIN
    ;     MESSAGE, 'No Crosses!'
    ; ENDIF
    IF SIZE(Crosses,/TNAME) EQ 'STRUCT' THEN BEGIN
        CrossCount = N_ELEMENTS(Crosses)
        CPosX = Crosses.(0)
        CPosY = Crosses.(1)
        CPosR = Crosses.(2)
        CPixI = CPosX-1
        CPixJ = CPosY-1
        CPixR = CPosR
    ENDIF ELSE BEGIN
        CrossCount = FIX(N_ELEMENTS(Crosses)/3.0)
        CI = INDGEN(CrossCount)
        CPosX = Crosses[CI*3+0]
        CPosY = Crosses[CI*3+1]
        CPosR = Crosses[CI*3+2]
        CPixI = CPosX-1
        CPixJ = CPosY-1
        CPixR = CPosR
    ENDELSE
    
    ; WCS AD2XY
    IF N_ELEMENTS(FitsHeaderContainingWCS) GT 0 THEN BEGIN
        CPosRA  = CPosX
        CPosDec = CPosY
        CrabImageAD2XY, CPosRA, CPosDec, FitsHeaderContainingWCS, CPixX, CPixY, /DoNotCheck, FitsAstr=FitsAstr;, /Verbose
        CPixI = CPixX - 1
        CPixJ = CPixY - 1
        CPixR = CPixR / (FitsAstr.CD[1,1]*FitsAstr.CDELT[1]*3600.0d)
    ENDIF
    
    FOR CI=0,CrossCount-1 DO BEGIN
        
        ; Color
        IF CI LT N_ELEMENTS(CColors) THEN CColor=CColors[CI] ELSE IF N_ELEMENTS(CColors) GT 0 THEN CColor=CColors[-1] ELSE CColor=cgColor('wheat')
        
        ; Thick
        IF CI LT N_ELEMENTS(CThicks) THEN CThick=CThicks[CI] ELSE IF N_ELEMENTS(CThicks) GT 0 THEN CThick=CThicks[-1] ELSE CThick=1.0 ; <TOOD> line thickness
        
        ; Label
        IF CI LT N_ELEMENTS(CLabels) THEN CLabel=CLabels[CI] ELSE IF N_ELEMENTS(CLabels) GT 0 THEN CLabel=CLabels[-1] ELSE CLabel=!NULL
        
        ; Label CharSize
        IF CI LT N_ELEMENTS(CLabChs) THEN CLabCh=CLabChs[CI] ELSE IF N_ELEMENTS(CLabChs) GT 0 THEN CLabCh=CLabChs[-1] ELSE CLabCh=0.25
        
        
        ; Cut part of cross if outside of FoV
        IF N_ELEMENTS(ImageSize) EQ 2 THEN BEGIN ; if you set TVPositionIJ, then TVSize is calculated automatically. 
            ZoomI = 1.0D / (ImageSize[0]-1.0d) * (ImageRect[2]-ImageRect[0])
            ZoomJ = 1.0D / (ImageSize[1]-1.0d) * (ImageRect[3]-ImageRect[1])
            CPixI[CI] = CPixI[CI] * ZoomI
            CPixJ[CI] = CPixJ[CI] * ZoomJ
            CPixR[CI] = CPixR[CI] * ZoomJ
        ENDIF
        
        
        ; PS
        ; IF !D.NAME EQ 'PS' THEN CPixR[CI] = CPixR[CI]/10.0
        
        
        ; Prepare Crosses
        CArrT = [0.38*CPixR[CI],1.00*CPixR[CI]] ; generate an array from 0.38*CPixR[CI] to 1.00*CPixR[CI]
        CArrM = [0.00,0.00]
        CArrI = CPixI[CI] + ([CArrM,CArrM,-REVERSE(CArrT),CArrT])
        CArrJ = CPixJ[CI] + ([-REVERSE(CArrT),CArrT,CArrM,CArrM])
        
        
        ;<DEBUG>
        NoClip = !NULL ; <corrected><20150505><dzliu> NoClip = 0 --> NoClip = !NULL -- otherwise some crosses are not shown. 
        
        
        ; Exclude outside crosses and/or Cut the outside part of cross
        IF NOT KEYWORD_SET(NoClip) THEN BEGIN
            CInvd = WHERE(CArrI GE 0 AND CArrI LE (ImageRect[2]-ImageRect[0]) AND CArrJ GE 0 AND CArrJ LE (ImageRect[3]-ImageRect[1]), /NULL) 
            IF N_ELEMENTS(CInvd) LE 1 THEN CONTINUE ; <Corrected><20140909><DzLIU>
            ; CArrI = CArrI[CInvd]
            ; CArrJ = CArrJ[CInvd]
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
        
        
        ; PRINT, FORMAT='(2F20.12,2F15.3)', CPosX[CI], CPosY[CI], CPixI[CI], CPixJ[CI]
        
        
        ; Do plot with dots ? <TODO>
        ; PLOTS, CArrI, CArrJ, /DEVICE, Color=CColor, Thick=CThick, PSYM=3
        
        ; Do plot with line ? <TODO>
        FOR i=0,3 DO BEGIN
            CArrT = INDGEN(N_ELEMENTS(CArrI)/4)+N_ELEMENTS(CArrI)/4*i ; CArrI and CArrJ have the same dimension
            PLOTS, [MIN(CArrI[CArrT]),MAX(CArrI[CArrT])], [MIN(CArrJ[CArrT]),MAX(CArrJ[CArrT])], /DEVICE, Color=CColor, Thick=CThick, LINESTYLE=0, NoClip=NoClip
        ENDFOR
        
        
        ; Label
        IF N_ELEMENTS(CLabel) GT 0 THEN BEGIN
            IF CLabel NE '' THEN BEGIN
                ; XYOUTS, MEAN(CArrI), MEAN(CArrJ), CLabel, /DEVICE, CharSize=-1, Width=CCharWidth
                ; CCharSize = 0.36*CPixR[CI]
                ; CCharSize = 0.36*CPixR[CI] / !D.Y_CH_SIZE
                ; CCharThick = 0.36*CPixR[CI] / !D.Y_CH_SIZE
                ; IF !D.NAME EQ 'PS' THEN CCharThick = CCharThick * 2.0
                ; XYOUTS, MEAN(CArrI), MEAN(CArrJ), CLabel, /DEVICE, Color=CColor, ALIGN=0.5, CharSize=CCharSize, CharThick=CCharThick
                ;
                ;<modified><20151209><dzliu>
                CCharSize = CLabCh
                CCharThick = 0.36*CPixR[CI] / !D.Y_CH_SIZE
                IF !D.NAME EQ 'PS' THEN CCharThick = CCharThick * 3.0
                XYOUTS, MEAN(CArrI), MEAN([MEAN(CArrJ),MAX(CArrJ)]), CLabel, /DEVICE, Color=CColor, ALIGN=0.5, CharSize=CCharSize, CharThick=CCharThick
            ENDIF
        ENDIF
        
    ENDFOR
     
    
    
END