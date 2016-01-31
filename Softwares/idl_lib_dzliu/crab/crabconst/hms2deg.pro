PRO hms2deg, hms, deg, Print=Print
    
;    hms = '10h23m30.6s'     ; --- NED
;    hms = '10h 23m 30.83s'  ; --- HSA Spec
;    hms = '10h 23m 30.93s'  ; --- HSA Photo A
;    hms = '10h 23m 30.93s'  ; --- HSA Photo B
    
    ; 
    
    IF SIZE(hms,/TYPE) NE 7 THEN BEGIN
        PRINT, 'Usage: hms2deg, "10h23m30.6s", OutputDegree, /PRINT'
        RETURN
    ENDIF
    StrHMS  = STRLOWCASE(STRTRIM(hms,2))
    PosH    = STRPOS(hms,'h')
    PosM    = STRPOS(hms,'m')
    PosS    = STRPOS(hms,'s')
    IF PosH+PosM+PosS LE 3 THEN RETURN
    DHour   = Double(STRMID(hms,0,PosH))
    DMinute = Double(STRMID(hms,PosH+1,PosM-PosH-1))
    DSecond = Double(STRMID(hms,PosM+1,PosS-PosM-1))
    
    deg = ( (DSecond/60.0 + DMinute)/60.0 + DHour ) / 24.0 * 360.0D
    
    IF KEYWORD_SET(PRINT) THEN BEGIN
        PRINT, FORMAT='(F0.12)', deg
    ENDIF
    
END