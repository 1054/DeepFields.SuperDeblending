; 
; Histogram
; 
FUNCTION CrabStatisticHistogram, InputArray, BinCount=BinCount, BinSize=BinSize, $
                                             BinCentreLocate=BinCentreLocate, BinCentreHeight=BinCentreHeight, $
                                             BinEdgeLocate=BinEdgeLocate, BinEdgeHeight=BinEdgeHeight, NoZero=NoZero
    
    IF N_ELEMENTS(InputArray) EQ 0 THEN BEGIN
        MESSAGE, 'CrabStatisticHistogram: input values are invalid!'
    ENDIF
    
    ; 
    IF N_ELEMENTS(BinCount) EQ 1 THEN BEGIN
        MinMaxValue = CrabMinMax(InputArray, NoZero=NoZero)
        MinMaxWidth = MinMaxValue[1]-MinMaxValue[0]
        BinSize = DOUBLE(MinMaxWidth)/DOUBLE(BinCount-1)
    ENDIF ELSE IF N_ELEMENTS(BinSize) EQ 1 THEN BEGIN
        MinMaxValue = CrabMinMax(InputArray, NoZero=NoZero)
        MinMaxWidth = MinMaxValue[1]-MinMaxValue[0]
        BinCount = FIX(DOUBLE(MinMaxWidth)/DOUBLE(BinSize)) + 1
    ENDIF
    
    
    BinCentreLocate = MAKE_ARRAY(BinCount,/DOUBLE,VALUE=0.0D)
    BinCentreHeight = MAKE_ARRAY(BinCount,/DOUBLE,VALUE=0.0D)
    BinEdgeLocate = MAKE_ARRAY(BinCount+1,/DOUBLE,VALUE=0.0D)
    BinEdgeHeight = MAKE_ARRAY(BinCount+1,/DOUBLE,VALUE=0.0D)
    
    FOR i=0,BinCount-1 DO BEGIN
        BinCentreLocate[i] = MinMaxValue[0] + DOUBLE(i)*DOUBLE(BinSize)
    ENDFOR
    
    FOR i=0,BinCount DO BEGIN
        BinEdgeLocate[i] = MinMaxValue[0] - 0.5D*DOUBLE(BinSize) + DOUBLE(i)*DOUBLE(BinSize)
    ENDFOR
    
    FOR i=0,BinCount-1 DO BEGIN
        HistoIndex = WHERE(InputArray GE BinEdgeLocate[i] AND InputArray LT BinEdgeLocate[i+1], HistoCount)
        BinCentreHeight[i] = HistoCount
    ENDFOR
    
    FOR i=1,BinCount-1 DO BEGIN
        BinEdgeHeight[i] = MAX([BinCentreHeight[i-1],BinCentreHeight[i]])
    ENDFOR
    BinEdgeHeight[0] = BinCentreHeight[0]
    BinEdgeHeight[BinCount] = BinCentreHeight[BinCount-1]
    
    ; return
    RETURN, BinCentreHeight
    
END