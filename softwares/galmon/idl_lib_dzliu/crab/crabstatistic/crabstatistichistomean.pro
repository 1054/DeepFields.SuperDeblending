; 
; Calculate the MEAN of InputArray in each bin of the ReferArray
; 
FUNCTION CrabStatisticHistoMean, InputArray, ReferArray, BinCount=BinCount, BinSize=BinSize, NoZero=NoZero, $
                                             BinCentreLocate=BinCentreLocate, BinEdgeLocate=BinEdgeLocate, $
                                             BinCentreHeight=BinCentreHeight, BinEdgeHeight=BinEdgeHeight ; these two will be modified
    
    ; must provide ReferArray
    IF N_ELEMENTS(ReferArray) EQ 0 THEN BEGIN
        MESSAGE, 'CrabStatisticHistoMean: Error! ReferArray is invalid!'
        RETURN, !NULL
    ENDIF
    
    ; Check BinEdgeLocate -- this is the array that defines the edge of each bin
    IF N_ELEMENTS(BinEdgeLocate) GT 0 THEN BEGIN
        ; do nothing
        BinCount = N_ELEMENTS(BinEdgeLocate)-1
    ENDIF ELSE IF N_ELEMENTS(BinCount)+N_ELEMENTS(BinSize) GT 0 THEN BEGIN
        ; calc the histogram of ReferArray
        TempArray = CrabStatisticHistogram(ReferArray, BinCount=BinCount, BinSize=BinSize, NoZero=NoZero, $
                                                       BinEdgeLocate=BinEdgeLocate, BinEdgeHeight=BinEdgeHeight)
    ENDIF ELSE IF N_ELEMENTS(BinCentreLocate) GT 0 THEN BEGIN
        ; if we have only input the BinCentreLocate, then we can calculate BinEdgeLocate
        BinSize  = BinCentreLocate[1]-BinCentreLocate[0] ; <TODO> Check whether the BinSize is the same between all BinCentreLocate[i]
        BinCount = N_ELEMENTS(BinCentreLocate) ; then N_ELEMENTS(BinEdgeLocate)==BinCount+1
        BinEdgeLocate = MAKE_ARRAY(BinCount+1,/DOUBLE,VALUE=0.0D)
        FOR i=0,BinCount-1 DO BEGIN
            BinEdgeLocate[i] = BinCentreLocate[i] - 0.5*BinSize
            IF i EQ BinCount-1 THEN BEGIN
                BinEdgeLocate[BinCount] = BinCentreLocate[BinCount-1] + 0.5*BinSize
            ENDIF
        ENDFOR
    ENDIF ELSE BEGIN
        MESSAGE, 'CrabStatisticHistoMean: Error! You should provide either BinEdgeLocate or BinCount or BinSize!'
    ENDELSE
    
    ; Now we have BinEdgeLocate, calculate the mean of InputArray in each bin, defined by BinEdgeLocate
    BinCentreHeight = MAKE_ARRAY(BinCount,/DOUBLE,VALUE=0.0D)
    FOR i=0, BinCount-1 DO BEGIN
        TempArray = InputArray[WHERE(ReferArray GE BinEdgeLocate[i] AND ReferArray LT BinEdgeLocate[i+1],/NULL)]
        IF N_ELEMENTS(TempArray) GT 0 THEN BEGIN
            IF KEYWORD_SET(NoZero) THEN BEGIN
                TempArray = TempArray[WHERE(TempArray GT 0.0,/NULL)]
            ENDIF
            IF N_ELEMENTS(TempArray) GT 0 THEN BEGIN
                BinCentreHeight[i] = MEAN([TempArray]) ; the mean IRColor for all sources in one bin
            ENDIF
        ENDIF
    ENDFOR
    
    ; Now calc BinEdgeHeight
    BinEdgeHeight = MAKE_ARRAY(BinCount+1,/DOUBLE,VALUE=0.0D)
    FOR i=1, BinCount-1 DO BEGIN
        BinEdgeHeight[i] = MAX([BinCentreHeight[i-1],BinCentreHeight[i]])
    ENDFOR
    BinEdgeHeight[0] = BinCentreHeight[0]
    BinEdgeHeight[BinCount] = BinCentreHeight[BinCount-1]
    
    
    RETURN, BinCentreHeight
    
END