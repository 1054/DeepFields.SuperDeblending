; 
; 
; 
; 
;
; 
; 
PRO CrabImageXY2AD, PosX, PosY, InputFitsOrHeader, PosRA, PosDec, StartsFromOne=StartsFromOne, Verbose=Verbose, Debug=Debug, Print=Print
    
    
    ; Check Input 
    IF N_ELEMENTS(InputFitsOrHeader) EQ 0 THEN BEGIN
        MESSAGE, 'Usage: CrabImageXY2AD, PosX, PosY, InputFitsOrHeader, PosRA, PosDec'
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
    
    ; 
    EXTAST, FitsHeader, FitsAstr
    CRPIX1 = ''; <20180219> added a pre-definition 
    CRPIX2 = ''; <20180219> added a pre-definition 
    CRVAL1 = ''; <20180219> added a pre-definition 
    CRVAL2 = ''; <20180219> added a pre-definition 
    CRPIX1 = CrabStringReadInfo(FitsHeader,"CRPIX1") ; sxpar(FitsHeader,"CRPIX1") ; <20180219> fxpar --> sxpar no difference
    CRPIX2 = CrabStringReadInfo(FitsHeader,"CRPIX2") ; sxpar(FitsHeader,"CRPIX2") ; <20180219> fxpar --> sxpar no difference
    CRVAL1 = CrabStringReadInfo(FitsHeader,"CRVAL1") ; sxpar(FitsHeader,"CRVAL1") ; <20180219> fxpar --> sxpar no difference
    CRVAL2 = CrabStringReadInfo(FitsHeader,"CRVAL2") ; sxpar(FitsHeader,"CRVAL2") ; <20180219> fxpar --> sxpar no difference
    newRA1 = 0.0D
    newDec1 = 0.0D
    newRA2 = 0.0D
    newDec2 = 0.0D
    XY2AD, DOUBLE(CRPIX1),     DOUBLE(CRPIX2),     FitsAstr, newRA1, newDec1
    XY2AD, DOUBLE(CRPIX1)-1.0, DOUBLE(CRPIX2)-1.0, FitsAstr, newRA2, newDec2 ; as far as my test, this one is correct! XY2AD/ARRAY coordinate is different from DS9/GALFIT coordinate
    strRA1 = STRING(FORMAT='(F0.7)',newRA1)
    strRA2 = STRING(FORMAT='(F0.7)',newRA2)
    strDec1 = STRING(FORMAT='(F0.7)',newDec1)
    strDec2 = STRING(FORMAT='(F0.7)',newDec2)
    IF KEYWORD_SET(Debug) THEN BEGIN
        PRINT, FORMAT='(A,F0.2,A,F0.2,A,F0.7,A,F0.7)', "CrabImageXY2AD: Checking CRPIX1=", CRPIX1, " CRPIX2=", CRPIX2, " CRVAL1=", CRVAL1, "  CRVAL2=", CRVAL2
        PRINT, FORMAT='(A,F0.2,A,F0.2,A,F0.7,A,F0.7)', "                         CRPIX1=", CRPIX1, " CRPIX2=", CRPIX2, " newRA1=", newRA1, " newDec1=",  newDec1
        PRINT, FORMAT='(A,F0.2,A,F0.2,A,F0.7,A,F0.7)', "                         CRPIX1=", CRPIX1, " CRPIX2=", CRPIX2, " newRA2=", newRA2, " newDec2=",  newDec2
    ENDIF
    
    ; Check if PosX PosY starts from zero or one
    IF strRA1 EQ STRING(FORMAT='(F0.7)',DOUBLE(CRVAL1)) AND strDec1 EQ STRING(FORMAT='(F0.7)',DOUBLE(CRVAL2)) THEN BEGIN
        ;<20180219> STRING(FORMAT='(F0.7)',CRVAL1) --> STRING(FORMAT='(F0.7)',DOUBLE(CRVAL1)) ; IMPORTANT !
        ;<20180219> STRING(FORMAT='(F0.7)',CRVAL2) --> STRING(FORMAT='(F0.7)',DOUBLE(CRVAL2)) ; IMPORTANT !
        ; if this situation, then XY2AD coordinate is consistent with PosXY coordinate, 
        IF KEYWORD_SET(Verbose) THEN BEGIN
            PRINT, FORMAT='(A,F0.2,A,F0.2,A,F0.7,A,F0.7)', "CrabImageXY2AD: Checking CRPIX1=", CRPIX1, " CRPIX2=", CRPIX2, " CRVAL1=", CRVAL1, "  CRVAL2=", CRVAL2
            PRINT, FORMAT='(A,F0.2,A,F0.2,A,F0.7,A,F0.7)', "                         CRPIX1=", CRPIX1, " CRPIX2=", CRPIX2, " newRA1=", newRA1, " newDec1=",  newDec1
        ENDIF
        XY2AD, PosX, PosY, FitsAstr, PosRA, PosDec
    ENDIF ELSE IF strRA2 EQ STRING(FORMAT='(F0.7)',DOUBLE(CRVAL1)) AND strDec2 EQ STRING(FORMAT='(F0.7)',DOUBLE(CRVAL2)) THEN BEGIN
        ;<20180219> STRING(FORMAT='(F0.7)',CRVAL1) --> STRING(FORMAT='(F0.7)',DOUBLE(CRVAL1)) ; IMPORTANT !
        ;<20180219> STRING(FORMAT='(F0.7)',CRVAL2) --> STRING(FORMAT='(F0.7)',DOUBLE(CRVAL2)) ; IMPORTANT !
        ; if this situation, then XY2AD coordinate is inconsistent with PosXY coordinate, need -1.0
        IF KEYWORD_SET(Verbose) THEN BEGIN
            PRINT, FORMAT='(A,F0.2,A,F0.2,A,F0.7,A,F0.7)', "CrabImageXY2AD: Checking CRPIX1=", CRPIX1, " CRPIX2=", CRPIX2, " CRVAL1=", CRVAL1, "  CRVAL2=", CRVAL2
            PRINT, FORMAT='(A,F0.2,A,F0.2,A,F0.7,A,F0.7)', "                         CRPIX1=", CRPIX1, " CRPIX2=", CRPIX2, " newRA2=", newRA2, " newDec2=",  newDec2
        ENDIF
        XY2AD, PosX-1.0, PosY-1.0, FitsAstr, PosRA, PosDec
    ENDIF ELSE BEGIN
        MESSAGE, "Call XY2AD failed! Unknown problem?", /CONTINUE
        MESSAGE, "STRING(FORMAT='(F0.7)',DOUBLE(CRVAL1)) = " + STRING(FORMAT='(F0.7)',DOUBLE(CRVAL1)) + ", " + "strRA1 = " + strRA1, /CONTINUE
        MESSAGE, "STRING(FORMAT='(F0.7)',DOUBLE(CRVAL2)) = " + STRING(FORMAT='(F0.7)',DOUBLE(CRVAL2)) + ", " + "strDec1 = " + strDec1, /CONTINUE
        MESSAGE, "STRING(FORMAT='(F0.7)',DOUBLE(CRVAL1)) = " + STRING(FORMAT='(F0.7)',DOUBLE(CRVAL1)) + ", " + "strRA2 = " + strRA2, /CONTINUE
        MESSAGE, "STRING(FORMAT='(F0.7)',DOUBLE(CRVAL2)) = " + STRING(FORMAT='(F0.7)',DOUBLE(CRVAL2)) + " (" + CRVAL2 + ")" + ", " + "strDec2 = " + strDec2, /CONTINUE
        MESSAGE, "Error!"
    ENDELSE
    
    ; Print
    IF N_ELEMENTS(Print) GT 0 AND SIZE(Print,/TNAME) NE "STRING" THEN BEGIN
        EQUINOX = fxpar(FitsHeader,"EQUINOX")
        IF N_ELEMENTS(EQUINOX) EQ 0 THEN EQUINOX=2000
        PRINT, ""
        PRINT, FORMAT='("#",A11,A12,A11,A15,A15)', "X", "Y", "EQUINOX", "RA", "Dec"
        PRINT, "#"
        FOR i=0,N_ELEMENTS(PosX)-1 DO BEGIN
            PRINT, FORMAT='(F12.2,F12.2,A7,I-4,F15.7,F15.7)', PosX[i], PosY[i], "J", EQUINOX, PosRA[i], PosDec[i]
        ENDFOR
        PRINT, ""
    ENDIF ELSE IF N_ELEMENTS(Print) GT 0 AND SIZE(Print,/TNAME) EQ "STRING" THEN BEGIN
        EQUINOX = fxpar(FitsHeader,"EQUINOX")
        IF N_ELEMENTS(EQUINOX) EQ 0 THEN EQUINOX=2000
        OPENW, fp, Print, /GET_LUN
        PRINTF, fp, FORMAT='("#",A11,A12,A11,A15,A15)', "X", "Y", "EQUINOX", "RA", "Dec"
        PRINTF, fp, "#"
        FOR i=0,N_ELEMENTS(PosX)-1 DO BEGIN
            PRINTF, fp, FORMAT='(F12.2,F12.2,A7,I-4,F15.7,F15.7)', PosX[i], PosY[i], "J", EQUINOX, PosRA[i], PosDec[i]
        ENDFOR
        PRINTF, fp, ""
        CLOSE, fp
        FREE_LUN, fp
    ENDIF
    
    RETURN
    
END
    