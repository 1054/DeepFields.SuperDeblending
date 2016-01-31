; 
; linear regression based on MPFIT
; <TODO> X and Y can only be fit in log space
; 
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                    this is the function called by MPFIT                                           ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FUNCTION CrabStatisticLogFitFunction, p, x=x, y=y, sigma_x=sigma_x, sigma_y=sigma_y, Text=Text, _EXTRA=extra
    a = p[0] ; slope
    b = p[1] ; intercept
    f = 10^(a*alog10(x)) * b ; model 
                             ; <Corrected><20131028><DzLiu> old "10^(a*alog10(x)+b)"
;   resid = (y - f) / sqrt(sigma_y^2 + ((a*b*x^(a-1))*sigma_x)^2) ; from chentao
;   resid = (y - f) / sqrt(sigma_y^2 + (y*a*sigma_x/x)^2) ; mine y = 10 ^ (a*lg(x)+lg(b))
    resid = (alog10(y) - alog10(f)) / sqrt(sigma_y^2/y^2 + (a*sigma_x)^2/x^2)     ; mine lg(y) = a * lg(x) + lg(b)
    ;;; residual = (y - model) / error
    ;;; the error comes from two parts: 1 is from y itself, 2 is from the relation with (x): y = 10 ^ (a*lg(x)+lg(b))
    ;;; accd. y = 10^(a*lg(x)) * b
    ;;; since Sigma(lg(y)) = Simga(y)/y
    ;;; thus  Sigma(y) = y * Sigma(lg(y))
    ;;;                = y * Sigma(a*lg(x)+lg(b))
    ;;;                = y * Sigma(a*lg(x))
    ;;;                = y * a*Sigma(lg(x))
    ;;;                = y * a*Sigma(x)/x
    ExtraInfo = ""
    IF SIZE(Text,/TYPE) EQ 7 THEN BEGIN
        ExtraIndex = WHERE(ABS(resid) EQ MAX(ABS(resid)))
        IF ExtraIndex LT N_ELEMENTS(Text) THEN BEGIN
            ExtraInfo = " MaxChiSQ (" + Text[ExtraIndex] + $
                                " x=" + STRTRIM(x[ExtraIndex],2) + "," + $
                                " y=" + STRTRIM(y[ExtraIndex],2) + "," + $
                                " f=" + STRTRIM(f[ExtraIndex],2) + ")"
        ENDIF
        ;;; note that some outlier would influence the result quite a lot!
    ENDIF
;    PRINT, 'LOGXYFunction - '+'('+STRTRIM(a,2)+','+STRTRIM(b,2)+')'+$
;           ' Chi-Square '+'('+STRTRIM(TOTAL(resid^2),2)+')'+' '+ExtraInfo
    RETURN, resid
END




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                    this is the function called by MPFIT                                           ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FUNCTION CrabStatisticLinFitFunction, p, x=x, y=y, sigma_x=sigma_x, sigma_y=sigma_y, Text=Text, _EXTRA=extra
    a = p[0] ; slope
    b = p[1] ; intercept
    f = a*x + b ; model 
                             ; <Corrected><20131028><DzLiu> old "10^(a*alog10(x)+b)"
;   resid = (y - f) / sqrt(sigma_y^2 + ((a*b*x^(a-1))*sigma_x)^2) ; from chentao
;   resid = (y - f) / sqrt(sigma_y^2 + (y*a*sigma_x/x)^2) ; mine y = 10 ^ (a*lg(x)+lg(b))
    resid = (y - f) / sqrt(sigma_y^2 + (a*sigma_x)^2)     ; mine y = a * x + b
    ;;; residual = (y - model) / error
    ;;; the error comes from two parts: 1 is from y itself, 2 is from the relation with (x): y = 10 ^ (a*lg(x)+lg(b))
    ;;; accd. y = 10^(a*lg(x)) * b
    ;;; since Sigma(lg(y)) = Simga(y)/y
    ;;; thus  Sigma(y) = y * Sigma(lg(y))
    ;;;                = y * Sigma(a*lg(x)+lg(b))
    ;;;                = y * Sigma(a*lg(x))
    ;;;                = y * a*Sigma(lg(x))
    ;;;                = y * a*Sigma(x)/x
    ExtraInfo = ""
    IF SIZE(Text,/TYPE) EQ 7 THEN BEGIN
        ExtraIndex = WHERE(ABS(resid) EQ MAX(ABS(resid)))
        IF ExtraIndex LT N_ELEMENTS(Text) THEN BEGIN
            ExtraInfo = " MaxChiSQ (" + Text[ExtraIndex] + $
                                " x=" + STRTRIM(x[ExtraIndex],2) + "," + $
                                " y=" + STRTRIM(y[ExtraIndex],2) + "," + $
                                " f=" + STRTRIM(f[ExtraIndex],2) + ")"
        ENDIF
        ;;; note that some outlier would influence the result quite a lot!
    ENDIF
;    PRINT, 'LOGXYFunction - '+'('+STRTRIM(a,2)+','+STRTRIM(b,2)+')'+$
;           ' Chi-Square '+'('+STRTRIM(TOTAL(resid^2),2)+')'+' '+ExtraInfo
    RETURN, resid
END



; 
; 
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                             this is the main function                                             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PRO CrabStatisticLinearRegression,            XArray, YArray,           $
                                              XError, YError,           $
                                             XRange = XRange,           $
                                             YRange = YRange,           $
                                               XLog = XLog,             $
                                               YLog = YLog,             $
                                    FixSlopeToUnity = FixSlopeToUnity,  $
                                    FixSlopeToValue = FixSlopeToValue,  $
                                     InitSlopeValue = InitSlopeValue,   $
                                   SaveResultToFile = SaveResultToFile, $
                                   SaveResultToData = SaveResultToData, $ 
                                         SetVerbose = SetVerbose,       $
                                               Note = Note
    
    ; Remove zero values
    ANOZ = (FINITE(XArray) AND FINITE(YArray))
    IF N_ELEMENTS(XRange) EQ 2 THEN ANOZ = (ANOZ GT 0 AND XArray GE XRange[0] AND XArray LE XRange[1])
    IF N_ELEMENTS(YRange) EQ 2 THEN ANOZ = (ANOZ GT 0 AND YArray GE YRange[0] AND YArray LE YRange[1])
    IF N_ELEMENTS(XRange) EQ 0 THEN ANOZ = (ANOZ GT 0 AND XArray GT 0)
    IF N_ELEMENTS(YRange) EQ 0 THEN ANOZ = (ANOZ GT 0 AND YArray GT 0)
;    IF N_ELEMENTS(XArray) GT 0 THEN ANOZ = (ANOZ GT 0 AND XArray GT 0) ; <TODO> XArray GT 0
;    IF N_ELEMENTS(YArray) GT 0 THEN ANOZ = (ANOZ GT 0 AND YArray GT 0) ; <TODO> YArray GT 0
;    IF N_ELEMENTS(XError) GT 0 THEN ANOZ = (ANOZ GT 0 AND XError GT 0) ; <TODO> XError GT 0
;    IF N_ELEMENTS(YError) GT 0 THEN ANOZ = (ANOZ GT 0 AND YError GT 0) ; <TODO> YError GT 0
    INOZ = WHERE(ANOZ GT 0, /NULL) ; index non-zero
    IF INOZ EQ !NULL THEN PRINT, 'CrabStatisticLinearRegression: No valid data in input array!'
    IF INOZ EQ !NULL THEN RETURN
    
    
    ; Refine data array
    FITX = XArray[INOZ] & IF N_ELEMENTS(XError) GT 0 THEN FITXERR = XError[INOZ] ELSE FITXERR = FITX * 0.0
    FITY = YArray[INOZ] & IF N_ELEMENTS(YError) GT 0 THEN FITYERR = YError[INOZ] ELSE FITYERR = FITY * 0.0
    
    
    ; Log - enter log space
    IF KEYWORD_SET(XLog) THEN BEGIN FITXERR=FITXERR/FITX & FITX = ALOG10(FITX) & ENDIF
    IF KEYWORD_SET(YLog) THEN BEGIN FITYERR=FITYERR/FITY & FITY = ALOG10(FITY) & ENDIF
    
    
    ; set initial parameters
    ParInfo = REPLICATE( {value:0.D, step:0.D, fixed:0, limited:[0,0], limits:[0.D,0.D]}, 2 )
    ParInit = [ 0.D, 0.D ]
    
    
    ; estimate initial parameters
    IF NOT KEYWORD_SET(FixSlopeToUnity) AND N_ELEMENTS(FixSlopeToValue) EQ 0 AND N_ELEMENTS(InitSlopeValue) EQ 0 THEN BEGIN
        ; method 1 - fit by FITEXY
        FITEXY, FITX, FITY, PreInter, PreSlope, PreParamErr, X_SIGMA=FITXERR, Y_SIGMA=FITYERR
        LinFitbyFITEXY = { Slope:[PreSlope,PreParamErr[1]], Intercept:[PreInter,PreParamErr[0]] }
        ; method 2 - fit by SIXLIN
        SIXLIN, FITX, FITY, PreInter, PreInterErr, PreSlope, PreSlopeErr
        LinFitbySIXLIN = { Slope:[PreSlope[2],PreSlopeErr[2]], Intercept:[PreInter[2],PreInterErr[2]] }
        ; set initial parameters
        ParInit = [ LinFitbySIXLIN.Slope[0], 10^(LinFitbySIXLIN.Intercept[0]) ]
    ENDIF ELSE IF N_ELEMENTS(FixSlopeToValue) EQ 1 AND N_ELEMENTS(InitSlopeValue) EQ 0 THEN BEGIN
        ; fix slope to unity or not?
        ParInfo[0].VALUE = DOUBLE(FixSlopeToValue) & ParInfo[0].FIXED = 1
        ParInit[0] = DOUBLE(FixSlopeToValue) & ParInit[1] = ( MEAN( FITY - (FITX*DOUBLE(FixSlopeToValue)), /DOUBLE) )
    ENDIF ELSE IF KEYWORD_SET(FixSlopeToUnity) AND N_ELEMENTS(InitSlopeValue) EQ 0 THEN BEGIN
        ; fix slope to unity or not?
        ParInfo[0].VALUE = 1.0 & ParInfo[0].FIXED = 1
        ParInit[0] = 1.0 & ParInit[1] = ( MEAN( FITY-FITX,/DOUBLE) )
    ENDIF ELSE IF N_ELEMENTS(InitSlopeValue) EQ 1 THEN BEGIN
        ParInit[0] = InitSlopeValue & ParInit[1] = ( MEAN( FITY-InitSlopeValue*FITX,/DOUBLE) )
    ENDIF
    
    
    ; set iteration function <TODO>  fit lg(x) lg(y) 
    ; ParValue = MPFIT('CrabStatisticLinFitFunction', ParInit, PARINFO=ParInfo, $ ; [PreSlope,PreInter]
    ;                   FUNCTARGS={X:FITX, Y:FITY, SIGMA_X:FITXERR, SIGMA_Y:FITYERR}, $
    ;                   PERROR=ParError, STATUS=FitStatus, QUIET=(~KEYWORD_SET(SetVerbose)))
    
    
    ; Log - restore to normal
    IF KEYWORD_SET(XLog) THEN BEGIN FITX = 10^(FITX) & FITXERR=FITXERR*FITX & ENDIF
    IF KEYWORD_SET(YLog) THEN BEGIN FITY = 10^(FITY) & FITYERR=FITYERR*FITY & ENDIF
    
    
    ; set iteration function <TODO>  fit lg(x) lg(y) 
    ParValue = MPFIT('CrabStatisticLogFitFunction', ParInit, PARINFO=ParInfo, $ ; [PreSlope,PreInter]
                      FUNCTARGS={X:FITX, Y:FITY, SIGMA_X:FITXERR, SIGMA_Y:FITYERR}, $
                      PERROR=ParError, STATUS=FitStatus, QUIET=(~KEYWORD_SET(SetVerbose)))
    
    
    
    
    
;   ParError = 1.0 * ParError ; <TODO> 3 sigma confidence? <TODO>
    
    
    
    ; Log - enter log space
    IF KEYWORD_SET(XLog) THEN BEGIN FITXERR=FITXERR/FITX & FITX = ALOG10(FITX) & ENDIF
    IF KEYWORD_SET(YLog) THEN BEGIN FITYERR=FITYERR/FITY & FITY = ALOG10(FITY) & ENDIF
    
    
    
    ; calc correlation and dispersion
    Correlation = CORRELATE( FITX, FITY, /DOUBLE )
    Dispersion = STDDEV( FITY - (ParValue[0]*FITX+ParValue[1]), /DOUBLE ) ; <Corrected><20140909><DzLIU>
;    Dispersion = STDDEV( FITY - (ParValue[0]*FITX+ALOG10(ParValue[1])), /DOUBLE ) ; <Corrected><20131125><DzLiu> ; calc in log-log space,
;    HistPROVALUES = HISTOGRAM( FITY - (ParValue[0]*FITX+ALOG10(ParValue[1])), LOCATIONS=HistLOCATIONS, NBINS=21 ) ; so this has dex unit.
;    HistGraph = BarPlot( HistLOCATIONS, HistPROVALUES )
    
    
    
    ; Log - restore to normal
    IF KEYWORD_SET(XLog) THEN BEGIN FITX = 10^(FITX) & FITXERR=FITXERR*FITX & ENDIF
    IF KEYWORD_SET(YLog) THEN BEGIN FITY = 10^(FITY) & FITYERR=FITYERR*FITY & ENDIF
    
    
    ; print message 
    PRINT, 'CrabStatisticLinearRegression: Fitting ' + STRING(FORMAT='(I0)',N_ELEMENTS(FITY)) + ' data points. ' 
    
    
    ; if input no error
    IF N_ELEMENTS(ParError) EQ 0 THEN ParError=[0.0,0.0]
    
    ; store result
    IF SaveResultToData EQ !NULL THEN SaveResultToData = OBJ_NEW('CrabStatisticLinFitData') ; <TODO> append to SaveResultToData?
    LinFitbyMPFIT = SaveResultToData->createLine( [ParValue[0],ParError[0]], [ParValue[1],ParError[1]], $ 
                                                   XArray = FITX, XRange = XRange, XLog = XLog, YLog = YLog, $
                                                   Correlation = Correlation, Dispersion = Dispersion, Note = Note )
    
    
    ; save result to file
    IF N_ELEMENTS(SaveResultToFile) EQ 1 AND SIZE(SaveResultToFile,/TYPE) EQ 7 THEN BEGIN
        OPENW,  SaveFileLUN, SaveResultToFile, /GET_LUN, /APPEND
        PRINTF, SaveFileLUN, '# '
        PRINTF, SaveFileLUN, '# CrabStatisticLinearRegression done with ' + STRING(FORMAT='(I0)',N_ELEMENTS(FITY)) + ' data points. '
        PRINTF, SaveFileLUN, '# Current Time ' + SYSTIME() + '.'
        PRINTF, SaveFileLUN, 'Slope          = ' + STRING(FORMAT='(F0.6)', LinFitbyMPFIT.Slope[0])
        PRINTF, SaveFileLUN, 'SlopeError     = ' + STRING(FORMAT='(F0.6)', LinFitbyMPFIT.Slope[1])
        PRINTF, SaveFileLUN, 'Intercept      = ' + STRING(FORMAT='(F0.6)', LinFitbyMPFIT.Intercept[0])
        PRINTF, SaveFileLUN, 'InterceptError = ' + STRING(FORMAT='(F0.6)', LinFitbyMPFIT.Intercept[1])
        CLOSE,  SaveFileLUN
        FREE_LUN, SaveFileLUN
    ENDIF
    
    
    ; save result to data
    SaveResultToData->addLine, LinFitbyMPFIT
    
END