; 
; FINDGEN
; 
FUNCTION CrabArrayINDGEN, fStart, fEnd, fStep, fCount=fCount, Log=Log
    
    NewArray = []
    
    IF N_ELEMENTS(fCount) GT 0 AND N_ELEMENTS(fStep) EQ 0 THEN BEGIN
        IF KEYWORD_SET(Log) THEN BEGIN
            fStep = (ALOG10(fEnd)-ALOG10(fStart))/DOUBLE(fCount-1)
        ENDIF ELSE BEGIN
            fStep = (fEnd-fStart)/DOUBLE(fCount-1)
        ENDELSE 
    ENDIF
    
    IF N_ELEMENTS(fStep) EQ 0 THEN fStep=1.0
    
    IF KEYWORD_SET(Log) THEN BEGIN
        fCount = (ALOG10(fEnd)-ALOG10(fStart))/fStep+1
    ENDIF ELSE BEGIN
        fCount = (fEnd-fStart)/fStep+1
    ENDELSE
    
    IF fCount GT 0 THEN BEGIN
        IF KEYWORD_SET(Log) THEN BEGIN
            NewArray = FINDGEN(LONG(fCount)) * DOUBLE(fStep) + ALOG10(fStart)
        ENDIF ELSE BEGIN
            NewArray = FINDGEN(LONG(fCount)) * DOUBLE(fStep) + fStart
        ENDELSE
        ; NewArray = FINDGEN(LONG(fCount)) * DOUBLE(fStep) + fStart
    ENDIF
    
    IF KEYWORD_SET(Log) THEN BEGIN
        NewArray = 10^NewArray
    ENDIF ELSE BEGIN
        NewArray = NewArray
    ENDELSE
    
    RETURN, NewArray
    
END