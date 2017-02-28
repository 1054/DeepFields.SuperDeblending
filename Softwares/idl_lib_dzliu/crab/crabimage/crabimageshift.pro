; 
; 
; 
; 
;
; CentreXY is useless. 
; 
FUNCTION CrabImageShift, InputImage, ShiftX=ShiftX, ShiftY=ShiftY, PeriodEdge=PeriodEdge, Cubic=Cubic
    
    
    ; Check Input 
    IF SIZE(InputImage,/N_DIM) NE 2 THEN BEGIN
        PRINT, 'Usage: CrabImageShift, InputImage, ShiftX=ShiftX, ShiftY=ShiftY'
        RETURN,[]
    ENDIF
    
    ; Check Input
    IF ShiftX EQ 0 AND ShiftY EQ 0 THEN RETURN, InputImage
    
    
    ; Integer + Fraction
    fShiftX = DOUBLE(ShiftX)
    iShiftX = FIX(fShiftX)
    dShiftX = fShiftX-DOUBLE(iShiftX)
    bShiftX = 1.0-dShiftX
    
    fShiftY = DOUBLE(ShiftY)
    iShiftY = FIX(fShiftY)
    dShiftY = fShiftY-DOUBLE(iShiftY)
    bShiftY = 1.0-dShiftY
    
    IF dShiftX LT 0.0 THEN BEGIN
        dShiftX = dShiftX + 1.0
        iShiftX = iShiftX - 1
    ENDIF
    IF dShiftY LT 0.0 THEN BEGIN
        dShiftY = dShiftY + 1.0
        iShiftY = iShiftY - 1
    ENDIF
    
    ; Shift Integer Portion
    IF iShiftX NE 0 OR iShiftY NE 0 THEN BEGIN
        TempImage = SHIFT(InputImage,iShiftX,iShiftY) 
    ENDIF ELSE BEGIN
        TempImage = InputImage
    ENDELSE
    IF dShiftX EQ 0.0 AND dShiftY EQ 0.0 THEN RETURN, TempImage

    
    ; Shift Fractional Portion (bilinear interpolation)
    IF N_ELEMENTS(Cubic) EQ 0 THEN BEGIN
        IMGLowerLeft  = SHIFT(TempImage,0,0) * bShiftX * bShiftY
        IMGUpperLeft  = SHIFT(TempImage,0,1) * bShiftX * dShiftY
        IMGLowerRight = SHIFT(TempImage,1,0) * dShiftX * bShiftY
        IMGUpperRight = SHIFT(TempImage,1,1) * dShiftX * dShiftY
        IF NOT KEYWORD_SET(PeriodEdge) THEN BEGIN
            IMGUpperLeft[*,0]  = 0.0 ; y=0 clean first row
            IMGLowerRight[0,*] = 0.0 ; x=0 clean first column
            IMGUpperRight[*,0] = 0.0 ; y=0 clean first row
            IMGUpperRight[0,*] = 0.0 ; x=0 clean first column
        ENDIF
        OutputImage = IMGLowerLeft + IMGUpperLeft + IMGLowerRight + IMGUpperRight
    ENDIF
    
        
    ; Shift Fractional Portion (bicubic interpolation)
    IF N_ELEMENTS(Cubic) EQ 1 THEN BEGIN
        IF Cubic GT 0 THEN Cubic=-0.5 ELSE Cubic=DOUBLE(Cubic)
        ; dfmX? see http://en.wikipedia.org/wiki/Bicubic_interpolation
        dx = dShiftX & dy = dShiftY
        dfmX_ = (Cubic*1.0)*ABS(1.0+dx)^3 - (Cubic*5.0)*ABS(1.0+dx)^2 + (Cubic*8.0)*ABS(1.0+dx) - (Cubic*4.0) ; dx=0-1, so ABS(1.0+dx)=1-2  
        dfmX0 = (Cubic+2.0)*ABS(0.0-dx)^3 - (Cubic+3.0)*ABS(0.0-dx)^2 + 1.0                                   ; dx=0-1, so ABS(0.0-dx)=0-1
        dfmX1 = (Cubic+2.0)*ABS(1.0-dx)^3 - (Cubic+3.0)*ABS(1.0-dx)^2 + 1.0                                   ; dx=0-1, so ABS(1.0-dx)=0-1
        dfmX2 = (Cubic*1.0)*ABS(2.0-dx)^3 - (Cubic*5.0)*ABS(2.0-dx)^2 + (Cubic*8.0)*ABS(2.0-dx) - (Cubic*4.0) ; dx=0-1, so ABS(2.0-dx)=1-2
        dfmY_ = (Cubic*1.0)*ABS(1.0+dy)^3 - (Cubic*5.0)*ABS(1.0+dy)^2 + (Cubic*8.0)*ABS(1.0+dy) - (Cubic*4.0) ; dy=0-1, so ABS(1.0+dy)=1-2
        dfmY0 = (Cubic+2.0)*ABS(0.0-dy)^3 - (Cubic+3.0)*ABS(0.0-dy)^2 + 1.0                                   ; dy=0-1, so ABS(0.0-dy)=0-1
        dfmY1 = (Cubic+2.0)*ABS(1.0-dy)^3 - (Cubic+3.0)*ABS(1.0-dy)^2 + 1.0                                   ; dy=0-1, so ABS(1.0-dy)=0-1
        dfmY2 = (Cubic*1.0)*ABS(2.0-dy)^3 - (Cubic*5.0)*ABS(2.0-dy)^2 + (Cubic*8.0)*ABS(2.0-dy) - (Cubic*4.0) ; dy=0-1, so ABS(2.0-dy)=1-2
        
        IMG__ = SHIFT(TempImage,-1,-1) * dfmX_ * dfmY_
        IMG_0 = SHIFT(TempImage,-1,+0) * dfmX_ * dfmY0
        IMG_1 = SHIFT(TempImage,-1,+1) * dfmX_ * dfmY1
        IMG_2 = SHIFT(TempImage,-1,+2) * dfmX_ * dfmY2
        IMG0_ = SHIFT(TempImage,+0,-1) * dfmX0 * dfmY_
        IMG00 = SHIFT(TempImage,+0,+0) * dfmX0 * dfmY0
        IMG01 = SHIFT(TempImage,+0,+1) * dfmX0 * dfmY1
        IMG02 = SHIFT(TempImage,+0,+2) * dfmX0 * dfmY2
        IMG1_ = SHIFT(TempImage,+1,-1) * dfmX1 * dfmY_
        IMG10 = SHIFT(TempImage,+1,+0) * dfmX1 * dfmY0
        IMG11 = SHIFT(TempImage,+1,+1) * dfmX1 * dfmY1
        IMG12 = SHIFT(TempImage,+1,+2) * dfmX1 * dfmY2
        IMG2_ = SHIFT(TempImage,+2,-1) * dfmX2 * dfmY_
        IMG20 = SHIFT(TempImage,+2,+0) * dfmX2 * dfmY0
        IMG21 = SHIFT(TempImage,+2,+1) * dfmX2 * dfmY1
        IMG22 = SHIFT(TempImage,+2,+2) * dfmX2 * dfmY2
        
        IF NOT KEYWORD_SET(PeriodEdge) THEN BEGIN
            NAXIS1 = (SIZE(IMG00,/DIM))[0]
            IMG__[NAXIS1-1,*] = 0 ; clean last column
            IMG_0[NAXIS1-1,*] = 0 ; clean last column
            IMG_1[NAXIS1-1,*] = 0 ; clean last column 
            IMG_2[NAXIS1-1,*] = 0 ; clean last column
            IMG1_[0,*]        = 0 ; clean first column
            IMG10[0,*]        = 0 ; clean first column
            IMG11[0,*]        = 0 ; clean first column
            IMG12[0,*]        = 0 ; clean first column
            IMG2_[0:1,*]      = 0 ; clean first and second column
            IMG20[0:1,*]      = 0 ; clean first and second column
            IMG21[0:1,*]      = 0 ; clean first and second column
            IMG22[0:1,*]      = 0 ; clean first and second column
            NAXIS2 = (SIZE(IMG00,/DIM))[1]
            IMG__[*,NAXIS2-1] = 0 ; clean last row
            IMG0_[*,NAXIS2-1] = 0 ; clean last row
            IMG1_[*,NAXIS2-1] = 0 ; clean last row
            IMG2_[*,NAXIS2-1] = 0 ; clean last row
            IMG_1[*,0]        = 0 ; clean first row
            IMG01[*,0]        = 0 ; clean first row
            IMG11[*,0]        = 0 ; clean first row
            IMG21[*,0]        = 0 ; clean first row
            IMG_2[*,0:1]      = 0 ; clean first and second row
            IMG02[*,0:1]      = 0 ; clean first and second row
            IMG12[*,0:1]      = 0 ; clean first and second row
            IMG22[*,0:1]      = 0 ; clean first and second row
        ENDIF
        OutputImage = IMG__ + IMG_0 + IMG_1 + IMG_2 + $
                      IMG0_ + IMG00 + IMG01 + IMG02 + $
                      IMG1_ + IMG10 + IMG11 + IMG12 + $
                      IMG2_ + IMG20 + IMG21 + IMG22 
    ENDIF
    
    RETURN, OutputImage
    
END
    