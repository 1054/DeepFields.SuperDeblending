; CrabImagePowerLawScale


FUNCTION CrabImagePowerLawScale, InputImage, PowerIndex, MAX=ZMAX, MIN=ZMIN, PERCENT=PERCENT, NORMAL=NORMAL, ByteScale=ByteScale
    ImageSize = Size(InputImage,/DIMENSIONS)
    IF N_ELEMENTS(ImageSize) NE 2 THEN RETURN,[]
    
    ScaledImage = InputImage
    
    ; Mask NAN Values
    MaskNaN = WHERE(~FINITE(InputImage))
    ScaledImage[MaskNaN] = 0.d
    
    ; ZMAX ZMIN
    IF N_ELEMENTS(ZMIN) EQ 1 THEN BEGIN
        SINDEX = WHERE(ScaledImage LT ZMIN,/NULL)
        IF N_ELEMENTS(SINDEX) GT 0 THEN ScaledImage[SINDEX]=ZMIN
    ENDIF
    IF N_ELEMENTS(ZMAX) EQ 1 THEN BEGIN
        SINDEX = WHERE(ScaledImage GT ZMAX,/NULL)
        IF N_ELEMENTS(SINDEX) GT 0 THEN ScaledImage[SINDEX]=ZMAX
    ENDIF
    
    ; PowerIndex Positive Values
    ArithmeticException = !Except & !Except = 0
    MaskVal = WHERE(ScaledImage GT 0.d)
    ScaledImage[MaskVal] = ScaledImage[MaskVal]^PowerIndex
    ArithmeticError = check_math() & !Except = ArithmeticException ; Clear floating underflow
    
    ; PowerIndex Negative Values <TODO> choose whether to do this or not. 
    IF 1 EQ 0 THEN BEGIN
    ArithmeticException = !Except & !Except = 0
    MaskVal = WHERE(ScaledImage LT 0.d)
    ScaledImage[MaskVal] = -(-ScaledImage[MaskVal])^PowerIndex
    ArithmeticError = check_math() & !Except = ArithmeticException ; Clear floating underflow
    ENDIF
    
    ; ZMIN ZMAX Changed
    IF N_ELEMENTS(ZMIN) EQ 1 THEN BEGIN
        IF ZMIN GT 0.0 THEN ZMIN = ZMIN^PowerIndex ELSE ZMIN = -(-ZMIN)^PowerIndex
    ENDIF
    IF N_ELEMENTS(ZMAX) EQ 1 THEN BEGIN
        IF ZMAX GT 0.0 THEN ZMAX = ZMAX^PowerIndex ELSE ZMAX = -(-ZMAX)^PowerIndex
    ENDIF
    
    
    ArithmeticException = !Except & !Except = 0
    ScaledImage[MaskNaN] = !VALUES.D_NAN
    ArithmeticError = check_math() & !Except = ArithmeticException ; Clear floating underflow
    
    
    ; scale by precentage
    ; -- note that ZMIN ZMAX only take effect when 0<ZMIN<1 and 0<ZMAX<1
    IF N_ELEMENTS(PERCENT) EQ 2 THEN BEGIN
        PERCZMIN = MIN(ScaledImage,/NAN)
        PERCZMAX = MAX(ScaledImage,/NAN)
        PERCNBIN = 2000
        HistoValues = HISTOGRAM(ScaledImage, MIN=MIN(ScaledImage,/NAN), MAX=MAX(ScaledImage,/NAN), NBINS=PERCNBIN, LOCATIONS=HistoLocates, /NAN)
        FOR i=0,PERCNBIN-1 DO BEGIN
            HistoCumula = TOTAL(HistoValues[0:i])/TOTAL(HistoValues)
            ;;PRINT, HistoCumula, PERCENT[0]
            IF HistoCumula LE PERCENT[0] THEN PERCZMIN = HistoLocates[i]
            IF HistoCumula GT PERCENT[0] THEN BREAK
        ENDFOR
        FOR i=PERCNBIN-1,0,-1 DO BEGIN
            HistoCumula = TOTAL(HistoValues[0:i])/TOTAL(HistoValues)
            ;;PRINT, HistoCumula, PERCENT[1]
            IF HistoCumula GE PERCENT[1] THEN PERCZMAX = HistoLocates[i]
            IF HistoCumula LT PERCENT[1] THEN BREAK
        ENDFOR
        ;;PERCZMIN = (MAX(ScaledImage)-MIN(ScaledImage))*PERCENT[0]+MIN(ScaledImage)
        ;;PERCZMAX = (MAX(ScaledImage)-MIN(ScaledImage))*PERCENT[1]+MIN(ScaledImage)
        SINDEX = WHERE(ScaledImage LT PERCZMIN,/NULL)
        IF N_ELEMENTS(SINDEX) GT 0 THEN ScaledImage[SINDEX]=PERCZMIN
        SINDEX = WHERE(ScaledImage GT PERCZMAX,/NULL)
        IF N_ELEMENTS(SINDEX) GT 0 THEN ScaledImage[SINDEX]=PERCZMAX
        PRINT, 'ZMIN ZMAX ', PERCZMIN, PERCZMAX
    ENDIF
    
    
    ; byte scale
    IF KEYWORD_SET(ByteScale) THEN BEGIN
        ScaledImage = BYTSCL(ScaledImage,/NAN)
    ENDIF
    
    
    
    ; normalization
    IF N_ELEMENTS(NORMAL) EQ 1 THEN BEGIN
        ; normalization
        NORMZVAL = (MAX(ScaledImage)-MIN(ScaledImage))*FLOAT(NORMAL)
        ScaledImage = ScaledImage + NORMZVAL
        IF KEYWORD_SET(ByteScale) THEN BEGIN
            IF N_ELEMENTS(WHERE(ScaledImage GT 255, /NULL)) GT 0 THEN BEGIN
                ScaledImage[WHERE(ScaledImage GT 255, /NULL)] = 255
            ENDIF
        ENDIF
    ENDIF
    
    
    ; <TODO><debug>
    PRINT, 'CrabImagePowerLawScale: ScaledImage: MIN MAX MEAN ', MIN(ScaledImage,/NAN), MAX(ScaledImage,/NAN), MEAN(ScaledImage,/NAN)
    
    RETURN, ScaledImage
    
END