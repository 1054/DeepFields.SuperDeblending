;
; linear regression based on LINMIX_ERR
; <TODO> X and Y can only be fit in log space
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                   this is the LINMIX_ERR Bayesian Method function                                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PRO CrabStatisticLinMixRegression,            XArray, YArray,           $
                                              XError, YError,           $
                                             XRange = XRange,           $
                                             YRange = YRange,           $
                                               XLog = XLog,             $
                                               YLog = YLog,             $
                                    FixSlopeToUnity = FixSlopeToUnity,  $
                                    FixSlopeToValue = FixSlopeToValue,  $
                                   SaveResultToFile = SaveResultToFile, $
                                   SaveResultToData = SaveResultToData, $ 
                                         SetVerbose = SetVerbose,       $
                                    SetFastConverge = SetFastConverge,  $
                                       MaxIteration = MaxIteration,     $
                                               Note = Note
                                               
    ; Remove NaN and zero values
    ANOZ = (FINITE(XArray) AND FINITE(YArray))
    ArithmeticExcept = !Except & !Except = 0
    IF N_ELEMENTS(XRange) EQ 2 THEN ANOZ = (ANOZ GT 0 AND XArray GE XRange[0] AND XArray LE XRange[1])
    IF N_ELEMENTS(YRange) EQ 2 THEN ANOZ = (ANOZ GT 0 AND YArray GE YRange[0] AND YArray LE YRange[1])
    IF N_ELEMENTS(XRange) EQ 0 THEN ANOZ = (ANOZ GT 0 AND XArray GT 0)
    IF N_ELEMENTS(YRange) EQ 0 THEN ANOZ = (ANOZ GT 0 AND YArray GT 0)
;    IF N_ELEMENTS(XArray) GT 0 THEN ANOZ = (ANOZ GT 0 AND XArray GT 0) ; <TODO> XArray GT 0
;    IF N_ELEMENTS(YArray) GT 0 THEN ANOZ = (ANOZ GT 0 AND YArray GT 0) ; <TODO> YArray GT 0
;    IF N_ELEMENTS(XError) GT 0 THEN ANOZ = (ANOZ GT 0 AND XError GT 0) ; <TODO> XError GT 0, we will ignore all uplimits!
;    IF N_ELEMENTS(YError) GT 0 THEN ANOZ = (ANOZ GT 0 AND YError GT 0) ; <TODO> YError GT 0, we will ignore all uplimits!
    ArithmeticQuiet = CHECK_MATH(MASK=32) & !Except = ArithmeticExcept
    INOZ = WHERE(ANOZ GT 0, /NULL) ; index non-zero
    IF INOZ EQ !NULL THEN PRINT, 'CrabStatisticLinMixRegression: No valid data in input array!'
    IF INOZ EQ !NULL THEN RETURN
    
    
    ; Refine data array
    FITX = XArray[INOZ] & IF N_ELEMENTS(XError) GT 0 THEN FITXERR = XError[INOZ] ELSE FITXERR = FITX * 0.0
    FITY = YArray[INOZ] & IF N_ELEMENTS(YError) GT 0 THEN FITYERR = YError[INOZ] ELSE FITYERR = FITY * 0.0
    
    
    ; Check data array n_elements
    IF N_ELEMENTS(FITX) LE 10 THEN BEGIN
        PRINT, 'CrabStatisticLinMixRegression: Valid data is not enough! less than 10 data points!'
        RETURN
    ENDIF
    
    
    ; Log
    IF KEYWORD_SET(XLog) THEN BEGIN FITXERR=FITXERR/FITX & FITX = ALOG10(FITX) & ENDIF 
    IF KEYWORD_SET(YLog) THEN BEGIN FITYERR=FITYERR/FITY & FITY = ALOG10(FITY) & ENDIF
    
    
    ; call linmix_err in log-log space
    ArithmeticExcept = !Except & !Except = 0
    IF N_ELEMENTS(MaxIteration) EQ 0 THEN MaxIteration=500
    linmix_err, FITX, FITY, POST, $ ; LINMIX_ERR must input ALOG10(XArray) and ALOG10(YArray)!
;               XSIG=(ALOG10(FITX+FITXERR)-ALOG10(FITX)+ALOG10(FITX)-ALOG10(FITX-FITXERR))/2.0D, $
;               YSIG=(ALOG10(FITY+FITYERR)-ALOG10(FITY)+ALOG10(FITY)-ALOG10(FITY-FITYERR))/2.0D, $
                XSIG=FITXERR, YSIG=FITYERR, $ ; error propagation
                SILENT=1, MAXITER=MaxIteration, METRO=SetFastConverge ; <TODO> /METRO, 
    ArithmeticQuiet = CHECK_MATH(MASK=32) & !Except = ArithmeticExcept
    
    
    ; save linmix_err output
    ParValue = [ MEAN(POST.BETA),   MEAN(POST.ALPHA)   ] ; ParValue[0] is Slope, ParValue[1] is Intercept.
    ParError = [ STDDEV(POST.BETA), STDDEV(POST.ALPHA) ] ; ParError[0] is Slope, ParError[1] is Intercept.
    IF KEYWORD_SET(YLog) THEN BEGIN   ; <Corrected><20140328><DZLIU>
        ParValue[1] = 10^(ParValue[1])
        ParError[1] = ParError[1]*ParValue[1]
    ENDIF
    Correlation_LinMix = MEAN(POST.CORR)
    Dispersion_LinMix  = MEAN(POST.SIGSQR) ;; ???<TODO> 0.02 ??? whereas Dispersion=0.33 ???
    
    
    ParError[0] = 1.0 * ParError[0] ; <TODO> 1.1 sigma confidence? <TODO>
    
    
    ; save linmix_err output
    LinMixAlpha = POST.ALPHA ; intercept distribution
    LinMixBeta  = POST.BETA  ; slope distribution 
    ;;; HisCnt = HISTOGRAM(LinMixBeta, LOCATIONS=HisLoc, BINSIZE=0.01)
    ;;; P = BARPLOT(HisLoc,HisCnt)
    
    
    ; calc correlation and dispersion
    Correlation = CORRELATE( FITX, FITY, /DOUBLE )
    IF KEYWORD_SET(YLog) THEN BEGIN   ; <Corrected><20140909><DzLIU>
        Dispersion = STDDEV( FITY - (ParValue[0]*FITX+ALOG10(ParValue[1])), /DOUBLE ) ; <Corrected><20131125><DzLiu> ; calc in log-log space,
    ENDIF ELSE BEGIN
        Dispersion = STDDEV( FITY - (ParValue[0]*FITX+ParValue[1]), /DOUBLE ) ; <Corrected><20140909><DzLIU>
    ENDELSE
;   HistPROVALUES = HISTOGRAM( FITY - (ParValue[0]*FITX+ALOG10(ParValue[1])), LOCATIONS=HistLOCATIONS, NBINS=21 ) ; so this has dex unit.
;   HistGraph = BarPlot( HistLOCATIONS, HistPROVALUES )
    
    
    ; Log - restore to normal
    IF KEYWORD_SET(XLog) THEN BEGIN FITX = 10^(FITX) & FITXERR=FITXERR*FITX & ENDIF
    IF KEYWORD_SET(YLog) THEN BEGIN FITY = 10^(FITY) & FITYERR=FITYERR*FITY & ENDIF
    
    
    ; print message 
    PRINT, 'CrabStatisticLinMixRegression: Fitting ' + STRING(FORMAT='(I0)',N_ELEMENTS(FITY)) + ' data points. ' 
    
    
    ; store result
    IF SaveResultToData EQ !NULL THEN SaveResultToData = OBJ_NEW('CrabStatisticLinFitData') ; <TODO> append to SaveResultToData?
    LinFitbyLINMIX = SaveResultToData->CreateLine( [ParValue[0],ParError[0]], $ ; slope N is the log index   ; intercept A = 10^xxx
                                                   [ParValue[1],ParError[1]],$ ; intercept A = 10^xxx
                                                   XArray = FITX, XRange = XRange, XLog = XLog, YLog = YLog, $
                                                   Correlation = Correlation, Dispersion = Dispersion, Note = Note )
    
    
    PRINT, 'CrabStatisticLinMixRegression: Fitted Slope ' + STRING(FORMAT='(F0.6)', LinFitbyLINMIX.Slope[0])
    PRINT, 'CrabStatisticLinMixRegression: Fitted Intercept ' + STRING(FORMAT='(F0.6)', LinFitbyLINMIX.Intercept[0])
    PRINT, 'CrabStatisticLinMixRegression: Fitted Correlation ' + STRING(FORMAT='(F0.6)', LinFitbyLINMIX.Correlation)
    PRINT, 'CrabStatisticLinMixRegression: Fitted Dispersion ' + STRING(FORMAT='(F0.6)', LinFitbyLINMIX.Dispersion)
    
    ; save result to file
    IF N_ELEMENTS(SaveResultToFile) EQ 1 AND SIZE(SaveResultToFile,/TYPE) EQ 7 THEN BEGIN
        OPENW,  SaveFileLUN, SaveResultToFile, /GET_LUN, /APPEND
        PRINTF, SaveFileLUN, '# '
        PRINTF, SaveFileLUN, '# CrabStatisticLinMixRegression done with ' + STRING(FORMAT='(I0)',N_ELEMENTS(FITY)) + ' data points. '
        PRINTF, SaveFileLUN, '# Current Time ' + SYSTIME() + '.'
        PRINTF, SaveFileLUN, 'Slope          = ' + STRING(FORMAT='(F0.6)', LinFitbyLINMIX.Slope[0])
        PRINTF, SaveFileLUN, 'SlopeError     = ' + STRING(FORMAT='(F0.6)', LinFitbyLINMIX.Slope[1])
        PRINTF, SaveFileLUN, 'Intercept      = ' + STRING(FORMAT='(F0.6)', LinFitbyLINMIX.Intercept[0])
        PRINTF, SaveFileLUN, 'InterceptError = ' + STRING(FORMAT='(F0.6)', LinFitbyLINMIX.Intercept[1])
        CLOSE,  SaveFileLUN
        FREE_LUN, SaveFileLUN
    ENDIF
    
    
    ; save result to data
    SaveResultToData->addLine, LinFitbyLINMIX
    
END