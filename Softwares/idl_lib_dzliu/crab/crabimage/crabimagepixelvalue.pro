; 
; 
; 
; 
;
; 
; 
FUNCTION CrabImagePixelValue, InputImage, PixPosX, PixPosY, Direct=Direct, Cubic=Cubic, StartsFromOne=StartsFromOne, Verbose=Verbose
    
    
    ; Check Input 
    IF SIZE(InputImage,/N_DIM) NE 2 THEN BEGIN
        PRINT, 'Usage: CrabImagePixelValue, InputImage, PixPosX, PixPosY, Cubic=Cubic'
        RETURN,[]
    ENDIF
    
    ; Check Input
    IF N_ELEMENTS(PixPosX) EQ 0 OR N_ELEMENTS(PixPosY) EQ 0 OR N_ELEMENTS(PixPosX) NE N_ELEMENTS(PixPosY) THEN RETURN, []
    
    ; 
    PosXMin = 0
    PosXMax = (SIZE(InputImage,/DIM))[0]-1
    PosYMin = 0
    PosYMax = (SIZE(InputImage,/DIM))[1]-1
    IF KEYWORD_SET(StartsFromOne) THEN BEGIN
        PosXMin=PosXMin+1
        PosXMax=PosXMax+1
        PosYMin=PosYMin+1
        PosYMax=PosYMax+1
    ENDIF
    
    ; 
    PixValues = []
    FOR i=0,N_ELEMENTS(PixPosY)-1 DO BEGIN
        PosX = PixPosX[i]
        PosY = PixPosY[i]
        
        fPosX = DOUBLE(PosX)
        iPosX = FIX(fPosX)
        dPosX = fPosX-DOUBLE(iPosX)
        IF dPosX LT 0.0 THEN BEGIN dPosX=dPosX+1.0 & iPosX=iPosX-1 & ENDIF & bPosX = 1.0-dPosX
        
        fPosY = DOUBLE(PosY)
        iPosY = FIX(fPosY)
        dPosY = fPosY-DOUBLE(iPosY)
        IF dPosY LT 0.0 THEN BEGIN dPosY=dPosY+1.0 & iPosY=iPosY-1 & ENDIF & bPosY = 1.0-dPosY
        
        IF PosX GE PosXMin AND PosY GE PosYMin AND PosX LE PosXMax AND PosY LE PosYMax THEN BEGIN
            ; interpolate (bilinear interpolation)
            PixLowerLeft = 0.0
            PixUpperLeft  = 0.0
            PixLowerRight  = 0.0
            PixUpperRight  = 0.0
            IF bPosX GT 0.0 AND bPosY GT 0.0 THEN PixLowerLeft  = InputImage[iPosX-PosXMin+0,iPosY-PosYMin+0] * bPosX * bPosY
            IF bPosX GT 0.0 AND dPosY GT 0.0 THEN PixUpperLeft  = InputImage[iPosX-PosXMin+0,iPosY-PosYMin+1] * bPosX * dPosY
            IF dPosX GT 0.0 AND bPosY GT 0.0 THEN PixLowerRight = InputImage[iPosX-PosXMin+1,iPosY-PosYMin+0] * dPosX * bPosY
            IF dPosX GT 0.0 AND dPosY GT 0.0 THEN PixUpperRight = InputImage[iPosX-PosXMin+1,iPosY-PosYMin+1] * dPosX * dPosY
            PixValue = PixLowerLeft + PixUpperLeft + PixLowerRight + PixUpperRight
            ; interpolate (bicubic interpolation)
            IF N_ELEMENTS(Cubic) EQ 1 AND PosX GE PosXMin+1 AND PosY GE PosYMin+1 AND PosX LE PosXMax-1 AND PosY LE PosYMax-1 THEN BEGIN
                IF Cubic GT 0 THEN Cubic=-0.5 ELSE Cubic=DOUBLE(Cubic)
                ; dfmX? see http://en.wikipedia.org/wiki/Bicubic_interpolation
                dfmX_ = (Cubic*1.0)*ABS(1.0+dPosX)^3 - (Cubic*5.0)*ABS(1.0+dPosX)^2 + (Cubic*8.0)*ABS(1.0+dPosX) - (Cubic*4.0) ; dPosX=0-1, so ABS(1.0+dPosX)=1-2  
                dfmX0 = (Cubic+2.0)*ABS(0.0-dPosX)^3 - (Cubic+3.0)*ABS(0.0-dPosX)^2 + 1.0                                      ; dPosX=0-1, so ABS(0.0-dPosX)=0-1
                dfmX1 = (Cubic+2.0)*ABS(1.0-dPosX)^3 - (Cubic+3.0)*ABS(1.0-dPosX)^2 + 1.0                                      ; dPosX=0-1, so ABS(1.0-dPosX)=0-1
                dfmX2 = (Cubic*1.0)*ABS(2.0-dPosX)^3 - (Cubic*5.0)*ABS(2.0-dPosX)^2 + (Cubic*8.0)*ABS(2.0-dPosX) - (Cubic*4.0) ; dPosX=0-1, so ABS(2.0-dPosX)=1-2
                dfmY_ = (Cubic*1.0)*ABS(1.0+dPosY)^3 - (Cubic*5.0)*ABS(1.0+dPosY)^2 + (Cubic*8.0)*ABS(1.0+dPosY) - (Cubic*4.0) ; dPosY=0-1, so ABS(1.0+dPosY)=1-2
                dfmY0 = (Cubic+2.0)*ABS(0.0-dPosY)^3 - (Cubic+3.0)*ABS(0.0-dPosY)^2 + 1.0                                      ; dPosY=0-1, so ABS(0.0-dPosY)=0-1
                dfmY1 = (Cubic+2.0)*ABS(1.0-dPosY)^3 - (Cubic+3.0)*ABS(1.0-dPosY)^2 + 1.0                                      ; dPosY=0-1, so ABS(1.0-dPosY)=0-1
                dfmY2 = (Cubic*1.0)*ABS(2.0-dPosY)^3 - (Cubic*5.0)*ABS(2.0-dPosY)^2 + (Cubic*8.0)*ABS(2.0-dPosY) - (Cubic*4.0) ; dPosY=0-1, so ABS(2.0-dPosY)=1-2
                
                IMG__ = InputImage[iPosX-PosXMin-1,iPosY-PosYMin-1] * dfmX_ * dfmY_
                IMG_0 = InputImage[iPosX-PosXMin-1,iPosY-PosYMin+0] * dfmX_ * dfmY0
                IMG_1 = InputImage[iPosX-PosXMin-1,iPosY-PosYMin+1] * dfmX_ * dfmY1
                IMG_2 = InputImage[iPosX-PosXMin-1,iPosY-PosYMin+2] * dfmX_ * dfmY2
                IMG0_ = InputImage[iPosX-PosXMin+0,iPosY-PosYMin-1] * dfmX0 * dfmY_
                IMG00 = InputImage[iPosX-PosXMin+0,iPosY-PosYMin+0] * dfmX0 * dfmY0
                IMG01 = InputImage[iPosX-PosXMin+0,iPosY-PosYMin+1] * dfmX0 * dfmY1
                IMG02 = InputImage[iPosX-PosXMin+0,iPosY-PosYMin+2] * dfmX0 * dfmY2
                IMG1_ = InputImage[iPosX-PosXMin+1,iPosY-PosYMin-1] * dfmX1 * dfmY_
                IMG10 = InputImage[iPosX-PosXMin+1,iPosY-PosYMin+0] * dfmX1 * dfmY0
                IMG11 = InputImage[iPosX-PosXMin+1,iPosY-PosYMin+1] * dfmX1 * dfmY1
                IMG12 = InputImage[iPosX-PosXMin+1,iPosY-PosYMin+2] * dfmX1 * dfmY2
                IMG2_ = InputImage[iPosX-PosXMin+2,iPosY-PosYMin-1] * dfmX2 * dfmY_
                IMG20 = InputImage[iPosX-PosXMin+2,iPosY-PosYMin+0] * dfmX2 * dfmY0
                IMG21 = InputImage[iPosX-PosXMin+2,iPosY-PosYMin+1] * dfmX2 * dfmY1
                IMG22 = InputImage[iPosX-PosXMin+2,iPosY-PosYMin+2] * dfmX2 * dfmY2
                
                PixValue  =   IMG__ + IMG_0 + IMG_1 + IMG_2 + $
                              IMG0_ + IMG00 + IMG01 + IMG02 + $
                              IMG1_ + IMG10 + IMG11 + IMG12 + $
                              IMG2_ + IMG20 + IMG21 + IMG22 
            ENDIF
        ENDIF
        
        IF KEYWORD_SET(Verbose) THEN BEGIN
            PRINT, FORMAT='("X=",F-10.3,"Y=",F-10.3,"Value=",G-13.5,"DirectValue=",G-13.5)', PixPosX[i], PixPosY[i], PixValue, InputImage[iPosX-PosXMin+0,iPosY-PosYMin+0]
        ENDIF
        
        IF KEYWORD_SET(Direct) THEN BEGIN
            PixValue = InputImage[iPosX-PosXMin+0,iPosY-PosYMin+0]
        ENDIF
        
        PixValues = [ PixValues, PixValue ]
        
    ENDFOR
    
    IF N_ELEMENTS(PixValues) EQ 1 THEN RETURN, PixValues[0]
    RETURN, PixValues
    
END
    