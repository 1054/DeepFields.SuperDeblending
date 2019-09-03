PRO CrabImageHistogram, InputArray, $
                        LOCATIONS = ZCent, $
                        HISTOGRAM = ZHist, $
                        NORMALIZE = NORMALIZE, $
                        NBINS = NBINS, $
                        ZMIN = ZMin, $
                        ZMAX = ZMax, $
                        ZMEAN = ZMean, $
                        ZSIGMA = ZSigma, $
                        Clip = doClip, $
                        Plot = doPlot
    
    ZClip = WHERE(FINITE(InputArray),/NULL)
    ZVect = InputArray[ZClip]
    
    
    IF KEYWORD_SET(doClip) THEN BEGIN
        ; 10 Sigma Clip
        ZSigX = STDDEV(ZVect)
        ZClip = WHERE(ABS(ZVect-MEAN(ZVect)) LE 10.0*ZSigX, /NULL)
        ZVect = ZVect[ZClip]
        
        ; 5 Sigma Clip
        ZSigV = STDDEV(ZVect)
        ZClip = WHERE(ABS(ZVect-MEAN(ZVect)) LE 5.0*ZSigV, /NULL)
        ZVect = ZVect[ZClip]
    ENDIF
    
    
    ; Get Statistics
    ZSigma = STDDEV(ZVect)
    ZMean = MEAN(ZVect)
    ZMin = MIN(ZVect)
    ZMax = MAX(ZVect)
    ZSigX = ZSigma ; compatible 
    ZSigV = ZSigma ; compatible 
    
    
    ; Get Histogram
    IF N_ELEMENTS(NBINS) EQ 0 THEN NBINS = 200
    ZHist = HISTOGRAM(ZVect,NBINS=NBINS,LOCATIONS=ZCent)
    
    IF KEYWORD_SET(NORMALIZE) THEN BEGIN
        ZHist = DOUBLE(ZHist) / MAX(ZHist)
    ENDIF
    
;    NBINS = LONG(2)
;    WHILE NBINS GT 0 AND NBINS LE 2000 DO BEGIN
;        ZHist = HISTOGRAM(ZVect,NBINS=NBINS,LOCATIONS=ZCent)
;        IF TOTAL(DOUBLE(ZHist)/MAX(ZHist) GT 0.2) GT 7 THEN BREAK
;        NBINS = NBINS + NBINS^0.2*4.0*ALOG10(NBINS) & SBINS = (MAX(ZVect)-MIN(ZVect))/DOUBLE(NBINS)
;    ENDWHILE
    
    
    ; doPlot = 0
    IF KEYWORD_SET(doPlot) THEN BEGIN
        ZPlot = Plot(ZCent,ZHist,/YLOG,/HISTOGRAM)
        ZPlo2 = PLOT([ZMean,ZMean],[1,MAX(ZHist)],LINESTYLE='dot',COLOR='purple',OverPlot=ZPlot)
        ZPlo2 = PLOT([ZMean+ZSigV*1.,ZMean+ZSigV*1.],[1,MAX(ZHist)],LINESTYLE='dash',COLOR='dodger blue',OverPlot=ZPlot)
        ZPlo2 = PLOT([ZMean-ZSigV*1.,ZMean-ZSigV*1.],[1,MAX(ZHist)],LINESTYLE='dash',COLOR='dodger blue',OverPlot=ZPlot)
        ZPlo2 = PLOT([ZMean+ZSigV*3.,ZMean+ZSigV*3.],[1,MAX(ZHist)],LINESTYLE='dash',COLOR='blue',OverPlot=ZPlot)
        ZPlo2 = PLOT([ZMean-ZSigV*3.,ZMean-ZSigV*3.],[1,MAX(ZHist)],LINESTYLE='dash',COLOR='blue',OverPlot=ZPlot)
        ZPlo2 = PLOT([ZMean+ZSigV*5.,ZMean+ZSigV*5.],[1,MAX(ZHist)],LINESTYLE='dash',COLOR='midnight blue',OverPlot=ZPlot)
        ZPlo2 = PLOT([ZMean-ZSigV*5.,ZMean-ZSigV*5.],[1,MAX(ZHist)],LINESTYLE='dash',COLOR='midnight blue',OverPlot=ZPlot)
        PRINT, FORMAT='(A,g0.6)', 'doPlot! ZSigma=', ZSigma
    ENDIF
    
    ; PRINT, FORMAT='(A,g0.6,A,g0.6,A,g0.6,A,g0.6)', 'doPlot! ZSigma=', ZSigma, ' HSigma=', STDDEV(ZHist), ' HMean=', MEAN(ZHist), ' HMedian=', MEDIAN(ZHist)
    
    RETURN
END