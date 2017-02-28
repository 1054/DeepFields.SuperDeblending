PRO hmsdms2degdeg, hmsdms, degdeg, Print=Print, DEBUG=DEBUG, ConvertToJ2000=ConvertToJ2000
    
;    hmsdms = " 10h 23m 30.83s +19d 51' 51.88'' "
;    hmsdms = " 10h23m30.6s +19d51m54s "
    
    IF SIZE(hmsdms,/TYPE) NE 7 THEN BEGIN
        PRINT, 'Usage: hmsdms2degdeg, "10h 23m 30.83s +19d 51m 51.88s", OutputDegree, /PRINT'
        RETURN
    ENDIF
    StrHMSDMS  = STRLOWCASE(hmsdms)
    ;
    hmsdms = STRTRIM(hmsdms,2)
    ; 
    ; RA
    ; 
    PosHH = -1
    IF PosHH LE 0 THEN PosHH = STRPOS(hmsdms,'h',0)
    IF PosHH LE 0 THEN PosHH = STRPOS(hmsdms,":",0)
    IF PosHH LE 0 THEN PosHH = STRPOS(hmsdms," ",0)
    IF PosHH GT 0 THEN BEGIN
        SHour = STRMID(hmsdms, 0, PosHH)
        DHour = Double(STRMID(hmsdms, 0, PosHH))
        PosHM = -1
        IF PosHM LE 0 THEN PosHM = STRPOS(hmsdms,'m',PosHH+1)
        IF PosHM LE 0 THEN PosHM = STRPOS(hmsdms,":",PosHH+1)
        IF PosHM LE 0 THEN PosHM = STRPOS(hmsdms," ",PosHH+1)
        IF PosHM GT 0 THEN BEGIN
            SMinute = STRMID(hmsdms,PosHH+1, PosHM-PosHH-1)
            DMinute = Double(STRMID(hmsdms,PosHH+1, PosHM-PosHH-1))
            PosHS = -1
            IF PosHS LE 0 THEN PosHS = STRPOS(hmsdms,'s',PosHM+1)
            IF PosHS LE 0 THEN PosHS = STRPOS(hmsdms," ",PosHM+1)
            IF PosHS LE 0 THEN PosHS = STRLEN(hmsdms) ; <Corrected><20140418><DZLIU>
            IF PosHS GT 0 THEN BEGIN
                SSecond = STRMID(hmsdms,PosHM+1, PosHS-PosHM-1)
                IF KEYWORD_SET(DEBUG) THEN PRINT, "SHour=", SHour, " ", "SMinute=", SMinute, " ", "SSecond=", SSecond
                DSecond = Double(STRMID(hmsdms,PosHM+1, PosHS-PosHM-1))
            ENDIF ELSE BEGIN
                DSecond = 0.0D
            ENDELSE
        ENDIF ELSE BEGIN
            DMinute = 0.0D
            DSecond = 0.0D
        ENDELSE
    ENDIF ELSE BEGIN
        DHour = 0.0D
        DMinute = 0.0D
        DSecond = 0.0D
    ENDELSE
    ; 
    ; Dec
    ; 
    PosAD = -1
    IF PosAD LE 0 THEN PosAD = STRPOS(hmsdms,"d",PosHS+1)
    IF PosAD LE 0 THEN PosAD = STRPOS(hmsdms,":",PosHS+1)
    IF PosAD LE 0 THEN PosAD = STRPOS(hmsdms," ",PosHS+1)
    IF PosAD GT 0 THEN BEGIN
        SArcDeg = STRMID(hmsdms,PosHS+1, PosAD-PosHS-1)
        DArcDeg = Double(STRMID(hmsdms,PosHS+1, PosAD-PosHS-1))
        PosAM = -1
        IF PosAM LE 0 THEN PosAM = STRPOS(hmsdms,"m",PosAD+1)
        IF PosAM LE 0 THEN PosAM = STRPOS(hmsdms,"'",PosAD+1)
        IF PosAM LE 0 THEN PosAM = STRPOS(hmsdms,":",PosAD+1)
        IF PosAM LE 0 THEN PosAM = STRPOS(hmsdms," ",PosAD+1)
        IF PosAM GT 0 THEN BEGIN
            SArcMin = STRMID(hmsdms,PosAD+1, PosAM-PosAD-1)
            DArcMin = Double(STRMID(hmsdms,PosAD+1, PosAM-PosAD-1))
            PosAS = -1
            IF PosAS LE 0 THEN PosAS = STRPOS(hmsdms,"s",PosAM+1)
            IF PosAS LE 0 THEN PosAS = STRPOS(hmsdms,'"',PosAM+1)
            IF PosAS LE 0 THEN PosAS = STRPOS(hmsdms,"''",PosAM+1)
            IF PosAS LE 0 THEN PosAS = STRPOS(hmsdms," ",PosAM+1)
            IF PosAS LE 0 THEN PosAS = STRLEN(hmsdms) ; <Corrected><20140418><DZLIU>
            IF PosAS GT 0 THEN BEGIN
                SArcSec = STRMID(hmsdms,PosAM+1, PosAS-PosAM-1)
                IF KEYWORD_SET(DEBUG) THEN PRINT, "SArcDeg=", SArcDeg, " ", "SArcMin=", SArcMin, " ", "SArcSec=", SArcSec
                DArcSec = Double(STRMID(hmsdms,PosAM+1, PosAS-PosAM-1))
            ENDIF ELSE BEGIN
                DArcSec = 0.0D
            ENDELSE
        ENDIF ELSE BEGIN
            DArcMin = 0.0D
            DArcSec = 0.0D
        ENDELSE
    ENDIF ELSE BEGIN
        DArcDeg = 0.0D
        DArcMin = 0.0D
        DArcSec = 0.0D
    ENDELSE
    
    IF DHour   LT 0 THEN RASign = -1D  
    IF DHour   GT 0 THEN RASign = +1D
    IF DHour   EQ 0 THEN BEGIN
       IF STRMID(STRTRIM(STRING(DHour),2),0,1) EQ '-' THEN RASign=-1D ELSE RASign=+1D & ENDIF
    IF DArcDeg LT 0 THEN DecSign = -1D
    IF DArcDeg GT 0 THEN DecSign = +1D
    IF DArcDeg EQ 0 THEN BEGIN
       IF STRMID(STRTRIM(STRING(DArcDeg),2),0,1) EQ '-' THEN DecSign=-1D ELSE DecSign=+1D & ENDIF
    
    degdeg = [ 0.0D, 0.0D ]
    degdeg[0] = RASign * ( (DSecond/60.0D + DMinute)/60.0D + ABS(DHour) ) / 24.0 * 360.0D
    degdeg[1] = DecSign * ( (DArcSec/60.0D + DArcMin)/60.0D + ABS(DArcDeg) )
    
    
    ; 
    ; Added: 2014-05-26: if input is B1950, then convert to J2000
    ; 
    IF KEYWORD_SET(ConvertToJ2000) THEN BEGIN
        B1950RA = degdeg[0]
        B1950Dec = degdeg[1]
        jprecess, B1950RA, B1950Dec, J2000RA, J2000Dec
        degdeg[0] = J2000RA
        degdeg[1] = J2000Dec
    ENDIF
    
    
    IF KEYWORD_SET(Print) THEN BEGIN
        PRINT, FORMAT='(A," ",F0.12," ",F0.12)', 'RA Dec J2000 is', degdeg[0], degdeg[1]
    ENDIF
    
    ; 
    ; Note that this is just a coordinate!
    ; The RA Dec unit length is different!
    ; (RA_pt1_deg - RA_pt2_deg) != (Dec_pt1_deg - Dec_pt2_deg)
    ; (RA_pt1_deg - RA_pt2_deg) * cos(Dec_pt1?2?_deg) = (Dec_pt1_deg - Dec_pt2_deg)   (only when pt1 and pt2 has similar Dec)
    ; 
    
END