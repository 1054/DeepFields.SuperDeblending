; 
; Last update: 
;      2015-07-27 dzliu now allow an array of degdeg
; 
; 
; 
PRO degdeg2hmsdms, degdeg, hmsdms, Print=Print, FORMAT=FORMAT, PRECISION=PRECISION, DEBUG=DEBUG, SeparateByColon=SeparateByColon, SeparateByNothing=SeparateByNothing, SeparateByhmsdms=SeparateByhmsdms

;    hmsdms = " 10h 23m 30.83s +19d 51' 51.88'' "
;    hmsdms = " 10h23m30.6s +19d51m54s "
    
    IF N_ELEMENTS(degdeg) EQ 0 THEN BEGIN
        PRINT, 'Usage: degdeg2hmsdms, [189.09677,62.20982], OutputRADECstring, /PRINT   ---> 12:36:23.224 +62:12:35.35'
        RETURN
    ENDIF
    ; check input dimension
    IF SIZE(degdeg,/N_DIM) EQ 1 THEN BEGIN
        DegRA = degdeg[0]
        DegDec = degdeg[1]
    ENDIF ELSE BEGIN
        DegRA = degdeg[0,*]
        DegDec = degdeg[1,*]
    ENDELSE
    ; calc hour minute second arcdeg arcmin arcsec
    DHour = FIX(DegRA/180.0*12.0) 
    DMinute = FIX((DegRA/180.0*12.0-DHour)*60.0)
    DSecond = FLOAT(((DegRA/180.0*12.0-DHour)*60.0-DMinute)*60.0)
    DArcDeg = FIX(DegDec)
    DArcMin = FIX((DegDec-DArcDeg)*60.0)
    DArcSec = FLOAT(((DegDec-DArcDeg)*60.0-DArcMin)*60.0)
    StrSign = MAKE_ARRAY(N_ELEMENTS(DegDec),/STRING,VALUE="+")
    IF N_ELEMENTS(WHERE(DegDec LT 0.0, /NULL)) GT 0 THEN BEGIN
        StrSign[WHERE(DegDec LT 0.0, /NULL)] = "-"
    ENDIF
    ;IF degdeg[1] GE 0 THEN StrSign = "+" ELSE StrSign = "-"
    
    ;StrHMSDMS  = ""
    StrHMSDMS = MAKE_ARRAY(N_ELEMENTS(DegDec),/STRING,VALUE="")
    
    ;Precision <TODO> can only be one dimension
    PrecisionRA = 3
    PrecisionDEC = 2
    IF N_ELEMENTS(PRECISION) EQ 1 THEN BEGIN
        PrecisionRA = PRECISION
        PrecisionDEC = PRECISION
    ENDIF
    IF N_ELEMENTS(PRECISION) EQ 2 THEN BEGIN
        PrecisionRA = PRECISION[0]
        PrecisionDEC = PRECISION[1]
    ENDIF
    IF N_ELEMENTS(PRECISION) GT 2 THEN BEGIN
        PrecisionRA = PRECISION[0]
        PrecisionDEC = PRECISION[1]
        MESSAGE, /CONTINUE, 'Warning: input PRECISION has dimension greater than 2! We will only take first 2 values as the precisions of RA and Dec. '
    ENDIF
    
    ;FmtHMSDMS
    IF N_ELEMENTS(FORMAT) GT 0 THEN BEGIN
        FmtHMSDMS = FORMAT
        IF N_ELEMENTS(FORMAT) GT 1 AND N_ELEMENTS(FORMAT) NE N_ELEMENTS(DegDec) THEN BEGIN
            MESSAGE, "Error! FORMAT has a dimension different than input degdeg array!"
        ENDIF
    ENDIF ELSE BEGIN
        FmtPrsHMS = STRING(FORMAT='("F0",I0,".",I0)',PrecisionRA+3,PrecisionRA) ; default is F06.3
        FmtPrsDMS = STRING(FORMAT='("F0",I0,".",I0)',PrecisionDEC+3,PrecisionDEC) ; default is F05.2
        FmtHMSDMS = MAKE_ARRAY(N_ELEMENTS(DegDec),/STRING,VALUE='(I0,":",I02,":",'+FmtPrsHMS+'," ",A,I0,":",I02,":",'+FmtPrsDMS+')') ; default format 12:00:26.321 +62:20:34.22
    ENDELSE
    IF KEYWORD_SET(SeparateByNothing) THEN BEGIN
        FmtHMSDMS = MAKE_ARRAY(N_ELEMENTS(DegDec),/STRING,VALUE='(I0,I02,'+FmtPrsHMS+',A,I0,I02,'+FmtPrsDMS+')')
    ENDIF
    IF KEYWORD_SET(SeparateByhmsdms) THEN BEGIN
        FmtHMSDMS = MAKE_ARRAY(N_ELEMENTS(DegDec),/STRING,VALUE='(I0,"h",I02,"m",'+FmtPrsHMS+',"s"," ",A,I0,"d",I02,"m",'+FmtPrsDMS+',"s")')
    ENDIF
    IF KEYWORD_SET(SeparateByColon) THEN BEGIN
        FmtHMSDMS = MAKE_ARRAY(N_ELEMENTS(DegDec),/STRING,VALUE='(I0,":",I02,":",'+FmtPrsHMS+'," ",A,I0,":",I02,":",'+FmtPrsDMS+')')
    ENDIF
    
    FOR i = 0, N_ELEMENTS(StrHMSDMS)-1 DO BEGIN
        StrHMSDMS[i] = STRING(FORMAT=FmtHMSDMS[i],DHour[i],DMinute[i],DSecond[i],StrSign[i],DArcDeg[i],DArcMin[i],DArcSec[i])
        IF KEYWORD_SET(Print) THEN BEGIN
            PRINT, FORMAT='(A,A)', 'RA Dec J2000 is ', StrHMSDMS[i]
        ENDIF
    ENDFOR
    
    
    IF N_ELEMENTS(StrHMSDMS) EQ 1 THEN BEGIN
        hmsdms = StrHMSDMS[0]
    ENDIF ELSE BEGIN
        hmsdms = StrHMSDMS
    ENDELSE
        
END