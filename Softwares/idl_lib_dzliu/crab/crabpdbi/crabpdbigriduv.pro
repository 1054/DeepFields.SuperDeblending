; 
; make grid from raw VisData(VisU,VisV) to DirtyVisPlane(VisU,VisV)
; 
FUNCTION CrabPdBIGridUV, VisU, VisV, VisData, BufferRadius=BufferRadius, NewDimension=NewDimension, Count=Count
    
    IF N_ELEMENTS(NewDimension) NE 2 THEN NewDimension = [ROUND(MAX(ABS(VisU)*2+1)),ROUND(MAX(ABS(VisV)*2+1))] ; <TODO> PdBI Correlator 128x128
    DirtyVisPlane = MAKE_ARRAY(NewDimension[0],NewDimension[1],/COMPLEX,VALUE=COMPLEX(!VALUES.F_NAN,!VALUES.F_NAN))
    TempCenU = FLOAT(NewDimension[0]-1)/2.0
    TempCenV = FLOAT(NewDimension[1]-1)/2.0
    TempArrI = VisU + TempCenU ; this is array index starting from 0 to DIM[0]-1
    TempArrJ = VisV + TempCenV ; this is array index starting from 0 to DIM[1]-1
    Count = 0
    FOR i=0,N_ELEMENTS(VisU)-1 DO BEGIN
        IF FINITE(TempArrI[i]) AND FINITE(TempArrJ[i]) THEN BEGIN
            TempPosI = ROUND(TempArrI[i]) ; this is array index starting from 0 to DIM[0]-1
            TempPosJ = ROUND(TempArrJ[i]) ; this is array index starting from 0 to DIM[1]-1
            TempRadR = SQRT((TempArrI-TempPosI)^2+(TempArrJ-TempPosJ)^2)
            IF N_ELEMENTS(BufferRadius) GE 1 THEN TempBufR = BufferRadius[0] ELSE TempBufR = 1.5 ; <TODO> max distance limit in pixel <TODO>
            TempFlag = WHERE(TempRadR LE TempBufR, /NULL)
            IF N_ELEMENTS(TempFlag) GT 0 THEN BEGIN
                IF TempPosI GE 0 AND TempPosI LT NewDimension[0] AND TempPosJ GE 0 AND TempPosJ LT NewDimension[1] THEN BEGIN
                    DirtyVisPlane[TempPosI,TempPosJ] = MEAN(VisData[TempFlag])
                    Count = Count + 1
                ENDIF
                TempArrI[TempFlag] = !VALUES.F_NAN
                TempArrJ[TempFlag] = !VALUES.F_NAN
            ENDIF
            ;IF i GE 500 THEN BREAK
        ENDIF
    ENDFOR
    RETURN, DirtyVisPlane
    
END