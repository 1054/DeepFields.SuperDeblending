FUNCTION CrabImageGridMap, InputArrayX, InputArrayY, InputArrayZ, AxisX, AxisY
; 
; Make a gridded map with input XArray, YArray and ZArray
; 
    
    ; Check Input
    IF N_ELEMENTS(InputXArray) NE N_ELEMENTS(InputYArray) OR N_ELEMENTS(InputYArray) NE N_ELEMENTS(InputZArray) OR N_ELEMENTS(InputZArray) NE N_ELEMENTS(InputXArray) THEN BEGIN
        MESSAGE, 'Usage: CrabImageGridMap, InputXArray, InputYArray, InputZArray, AxisX, AxisY'
        RETURN, []
    ENDIF
    
    IF N_ELEMENTS(AxisX) LE 0 OR N_ELEMENTS(AxisY) LE 0 THEN BEGIN
        MESSAGE, 'Usage: CrabImageGridMap, InputXArray, InputYArray, InputZArray, AxisX, AxisY'
        RETURN, []
    ENDIF
    NAXIS = [N_ELEMENTS(AxisX),N_ELEMENTS(AxisY)] ; NAXIS IS AN 2-ELEMENT ARRAY. SHOULD NOT EXCEED 32766. 
    
    ; AxisX = CrabArrayINDGEN(0,NAXIS[0]-1,0.1) ;<TODO> or we can input AxisXY
    ; AxisY = CrabArrayINDGEN(0,NAXIS[1]-1,0.1) ;<TODO> or we can input AxisXY
    AxisZ = MAKE_ARRAY(N_ELEMENTS(AxisX),N_ELEMENTS(AxisY),/DOUBLE,VALUE=!VALUES.D_NAN)
    
    
    PixSX = DOUBLE(AxisX[1]-AxisX[0]) ; <TODO> or we can input this
    PixSY = DOUBLE(AxisY[1]-AxisY[0]) ; <TODO> or we can input this
    
    
    ArrayX = DOUBLE(InputArrayX)
    ArrayY = DOUBLE(InputArrayY)
    ArrayZ = DOUBLE(InputArrayZ)
    FOR j=0,NAXIS[1]-1 DO BEGIN
        FOR i=0,NAXIS[0]-1 DO BEGIN
            k = j*NAXIS[0] + i
            ; 
            ; METHOD 1 -- naive mapping
            ; 
            FiltX1 = AxisX[i]-0.5*PixSX
            FiltX2 = AxisX[i]+0.5*PixSX
            FiltY1 = AxisY[j]-0.5*PixSY
            FiltY2 = AxisY[j]+0.5*PixSY
            IF ABS(FiltX1-1.8) LT 0.1 AND ABS(FiltY1-3.5) LT 0.1 THEN BEGIN
                PRINT, "DEBUG"
            ENDIF
            Filter = WHERE(ArrayX GE FiltX1 AND ArrayX LT FiltX2 AND ArrayY GE FiltY1 AND ArrayY LT FiltY2, /NULL)
            IF N_ELEMENTS(Filter) GT 0 THEN BEGIN
                AxisZ[i,j] = MEAN(ArrayZ[Filter])
            ENDIF
            ; 
            ; METHOD 2 -- <TODO>
            ; 
            ;;;;;; 
            ; 
            ; METHOD 3 -- <TODO>
            ; 
            ;;;;;;
        ENDFOR
    ENDFOR
    
    RETURN, AxisZ
END