; 
; 
; 
; 
;
; 
; 
PRO CrabImageAD2XY, PosRA, PosDec, InputFitsOrHeader, PosX, PosY, FitsAstr=FitsAstr, StartsFromOne=StartsFromOne, Verbose=Verbose, DoNotCheck=DoNotCheck, Debug=Debug, Print=Print
    
    
    ; Check Input 
    IF N_ELEMENTS(InputFitsOrHeader) EQ 0 THEN BEGIN
        MESSAGE, 'Usage: CrabImageAD2XY, PosRA, PosDec, InputFitsOrHeader, PosX, PosY'
        RETURN
    ENDIF
    
    ; Check Input
    IF N_ELEMENTS(InputFitsOrHeader) EQ 1 AND SIZE(InputFitsOrHeader,/TNAME) EQ "STRING" THEN BEGIN
        IF NOT KEYWORD_SET(Verbose) THEN Silent=1
        FitsImage = MRDFITS(InputFitsOrHeader,0,FitsHeader,Silent=Silent)
    ENDIF
    IF N_ELEMENTS(InputFitsOrHeader) GT 1 AND SIZE(InputFitsOrHeader,/TNAME) EQ "STRING" THEN BEGIN
        FitsHeader = InputFitsOrHeader
    ENDIF
    IF SIZE(InputFitsOrHeader,/TNAME) EQ "STRUCT" THEN BEGIN
        FitsAstr = InputFitsOrHeader
        CRPIX1 = DOUBLE(FitsAstr.CRPIX[0])
        CRPIX2 = DOUBLE(FitsAstr.CRPIX[1])
        CRVAL1 = DOUBLE(FitsAstr.CRVAL[0])
        CRVAL2 = DOUBLE(FitsAstr.CRVAL[1])
        EQUINOX = 'J2000'
    ENDIF ELSE BEGIN
        FitsHeader = InputFitsOrHeader
        EXTAST, FitsHeader, FitsAstr
        CRPIX1 = DOUBLE(fxpar(FitsHeader,"CRPIX1"))
        CRPIX2 = DOUBLE(fxpar(FitsHeader,"CRPIX2"))
        CRVAL1 = DOUBLE(fxpar(FitsHeader,"CRVAL1"))
        CRVAL2 = DOUBLE(fxpar(FitsHeader,"CRVAL2"))
        EQUINOX = fxpar(FitsHeader,"EQUINOX")
    ENDELSE
    
    ; 
    AD2XY, CRVAL1, CRVAL2, FitsAstr, refX1, refY1 ; AD2XY/XY2AD/ARRAY coordinate starts from 0
    refX2 = refX1+1.0d & refY2 = refY1+1.0d       ; DS9/PHYSIC/GALFIT coordinate starts from 1
    strFM = '(G0.3)' ; F0.2 G0.5
    strX1 = STRING(FORMAT=strFM,refX1)
    strY1 = STRING(FORMAT=strFM,refY1)
    strX2 = STRING(FORMAT=strFM,refX2)
    strY2 = STRING(FORMAT=strFM,refY2)
    chkXC = STRING(FORMAT=strFM,CRPIX1)
    chkYC = STRING(FORMAT=strFM,CRPIX2)
    IF KEYWORD_SET(Debug) THEN BEGIN
        PRINT, FORMAT='(A,F0.7,A,F0.7,A,F0.2,A,F0.2)', "CrabImageAD2XY: Checking CRVAL1=", CRVAL1, " CRVAL2=", CRVAL2, " CRPIX1=", CRPIX1, " CRPIX2=", CRPIX2
        PRINT, FORMAT='(A,F0.7,A,F0.7,A,F0.2,A,F0.2)', "                         CRVAL1=", CRVAL1, " CRVAL2=", CRVAL2, "  refX1=",  refX1, "  refY1=",  refY1
        PRINT, FORMAT='(A,F0.7,A,F0.7,A,F0.2,A,F0.2)', "                         CRVAL1=", CRVAL1, " CRVAL2=", CRVAL2, "  refX2=",  refX2, "  refY2=",  refY2
    ENDIF
    IF NOT KEYWORD_SET(DoNotCheck) OR KEYWORD_SET(Debug) THEN BEGIN
        IF strX1 EQ chkXC AND strY1 EQ chkYC THEN BEGIN
            ; if this situation, then AD2XY coordinate is consistent with PosXY coordinate, 
            IF KEYWORD_SET(Verbose) THEN BEGIN
                PRINT, FORMAT='(A,F0.7,A,F0.7,A,F0.2,A,F0.2)', "CrabImageAD2XY: Checking CRVAL1=", CRVAL1, " CRVAL2=", CRVAL2, " CRPIX1=", CRPIX1, " CRPIX2=", CRPIX2
                PRINT, FORMAT='(A,F0.7,A,F0.7,A,F0.2,A,F0.2)', "                         CRVAL1=", CRVAL1, " CRVAL2=", CRVAL2, "  refX1=",  refX1, "  refY1=",  refY1
            ENDIF
            AD2XY, PosRA, PosDec, FitsAstr, PosX, PosY
        ENDIF ELSE IF strX2 EQ chkXC AND strY2 EQ chkYC THEN BEGIN
            ; if this situation, then AD2XY coordinate is inconsistent with PosXY coordinate, need -1.0
            IF KEYWORD_SET(Verbose) THEN BEGIN
                PRINT, FORMAT='(A,F0.7,A,F0.7,A,F0.2,A,F0.2)', "CrabImageAD2XY: Checking CRVAL1=", CRVAL1, " CRVAL2=", CRVAL2, " CRPIX1=", CRPIX1, " CRPIX2=", CRPIX2
                PRINT, FORMAT='(A,F0.7,A,F0.7,A,F0.2,A,F0.2)', "                         CRVAL1=", CRVAL1, " CRVAL2=", CRVAL2, "  refX2=",  refX2, "  refY2=",  refY2
            ENDIF
            AD2XY, PosRA, PosDec, FitsAstr, PosX, PosY
            PosX = PosX+1.0d & PosY=PosY+1.0d
        ENDIF ELSE BEGIN
            MESSAGE, "CrabImageAD2XY: call AD2XY failed! Unknown problem?"
        ENDELSE
    ENDIF ELSE BEGIN
            AD2XY, PosRA, PosDec, FitsAstr, PosX, PosY
            PosX = PosX+1.0d & PosY=PosY+1.0d
    ENDELSE
    
    ; Print
    IF N_ELEMENTS(Print) GT 0 AND SIZE(Print,/TNAME) NE "STRING" THEN BEGIN
        
        IF N_ELEMENTS(EQUINOX) EQ 0 THEN EQUINOX=2000
        PRINT, ""
        PRINT, FORMAT='("#",A14,A15,A11,A12,A12)', "RA", "Dec", "EQUINOX", "X", "Y"
        PRINT, "#"
        FOR i=0,N_ELEMENTS(PosX)-1 DO BEGIN
            PRINT, FORMAT='(F15.7,F15.7,A7,I-4,F12.2,F12.2)', PosRA[i], PosDec[i], "J", EQUINOX, PosX[i], PosY[i]
        ENDFOR
        PRINT, ""
    ENDIF ELSE IF N_ELEMENTS(Print) GT 0 AND SIZE(Print,/TNAME) EQ "STRING" THEN BEGIN
        IF N_ELEMENTS(EQUINOX) EQ 0 THEN EQUINOX=2000
        OPENW, fp, Print, /GET_LUN
        PRINTF, fp, FORMAT='("#",A14,A15,A11,A12,A12)', "RA", "Dec", "EQUINOX", "X", "Y"
        PRINTF, fp, "#"
        FOR i=0,N_ELEMENTS(PosX)-1 DO BEGIN
            PRINTF, fp, FORMAT='(F15.7,F15.7,A7,I-4,F12.2,F12.2)', PosRA[i], PosDec[i], "J", EQUINOX, PosX[i], PosY[i]
        ENDFOR
        PRINTF, fp, ""
        CLOSE, fp
        FREE_LUN, fp
    ENDIF
    
    RETURN
    
END
    