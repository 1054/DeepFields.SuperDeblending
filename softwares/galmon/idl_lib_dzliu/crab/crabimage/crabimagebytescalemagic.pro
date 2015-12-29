;FUNCTION SecondMax, ZARR
;    ZFIL = WHERE(ZARR LT MAX(ZARR),/NULL)
;    IF N_ELEMENTS(ZFIL) EQ 0 THEN BEGIN
;        RETURN, MAX(ZARR)
;    ENDIF ELSE BEGIN
;        RETURN, MAX(ZARR[ZFIL])
;    ENDELSE
;END
;
;
;PRO CIBSM_GHIS, InputArray, NBIN=NBIN, SBIN=SBIN, HIS=ZHIS, CEN=ZCEN, ARR=ZARR
;    ; Quickly get hist
;    ZARR = DOUBLE(InputArray[WHERE(FINITE(InputArray),/NULL)])
;    ZARR = ZARR[WHERE(ABS(ZARR-MEAN(ZARR)) LE 10.0*STDDEV(ZARR),/NULL)]
;    ZTOT = N_ELEMENTS(ZARR)
;    NBIN = LONG(2) ; (MAX(ZARR)-MIN(ZARR))/STDDEV(ZARR)
;    ZHIS = HISTOGRAM(ZARR,NBINS=NBIN,LOCATIONS=ZCEN)
;    WHILE NBIN GT 0 AND NBIN LT 1e5 DO BEGIN ; down to resolving 20% total pixels
;        ; SecondMax(ZHIS) GT 0.20*ZTOT AND 
;        NBIN = NBIN + NBIN^0.2*4.0*ALOG10(NBIN) & SBIN = (MAX(ZARR)-MIN(ZARR))/DOUBLE(NBIN)
;        IF NBIN GT 0 THEN ZHIS = HISTOGRAM(ZARR,NBINS=NBIN,LOCATIONS=ZCEN)
;    ENDWHILE
;    Debug = 1
;END
;
;
;PRO CIBSM_PHIS, InputArray, NBINS=ZBIN, HIS=ZHIS, CEN=ZCEN, MEAN=ZMEAN, MEDIAN=ZMEDIAN, SIGMA=ZSIGMA, PEAKCEN=ZPEAKCEN, PEAKHIS=ZPEAKHIS, $
;                            DoPlot=DoPlot, OverPlot=OverPlot, Color=Color
;    ; Quickly plot hist
;    CIBSM_GHIS, InputArray, NBIN=ZBIN, SBIN=SBIN, HIS=ZHIS, CEN=ZCEN, ARR=ZARR
;    
;    ; Statistics
;    ZSIGMA  = STDDEV(ZARR)
;    ZMEAN   = MEAN(ZARR)
;    ZMEDIAN = MEDIAN(ZARR)
;    ZPEAKCEN = TOTAL(ZCEN*ZHIS)/TOTAL(ZHIS)
;    ZPEAKIND = (WHERE(ABS(ZCEN-ZPEAKCEN) EQ MIN(ABS(ZCEN-ZPEAKCEN))))[0]
;    ZPEAKHIS = ZHIS[ZPEAKIND]
;    ZMINIMUM = MIN(ZARR)
;    ZMAXIMUM = MAX(ZARR)
;    ZDIFFERN = ZMAXIMUM-ZMINIMUM
;    ZCEN = ZCEN - ZPEAKCEN
;    
;    ; Within 3 Sigma Central Gaussian Fit
;    ZPEAKARRAY = ZARR[WHERE(ABS(ZARR-ZPEAKCEN) LE 3.0*ZSIGMA)]
;    ZPEAKSIGMA = STDDEV(ZPEAKARRAY)
;    ZPEAKCENTRE = MEAN(ZPEAKARRAY)
;    ZPEAKHEIGHT = MEDIAN(ZHIS[ZPEAKIND-2:ZPEAKIND+2]) ; <TODO> Peak of central gaussian? Should derived by solving linear regression. 
;    ZGAUSSIAN = GAUSSIAN(ZCEN,[1.0d,ZPEAKCENTRE,ZPEAKSIGMA],/DOUBLE) * ZPEAKHEIGHT
;    ; Plot
;    DoPlot = 1
;    IF KEYWORD_SET(DoPlot) THEN BEGIN
;        ZPLT_BAR = (10.0*ZSIGMA)
;        IF N_ELEMENTS(OverPlot) EQ 0 THEN XRAN = [-ZPLT_BAR,ZPLT_BAR]
;        ZPLT_VAR = PLOT(ZCEN,ZHIS,/YLOG,/HISTOGRAM,Color=Color,XRANGE=XRAN,OverPlot=OverPlot)
;        IF N_ELEMENTS(OverPlot) EQ 0 THEN OverPlot=ZPLT_VAR
;        ZPLT_BAR = (3.0*ZSIGMA)
;        ZPLT_VA2 = PLOT([ZPLT_BAR,ZPLT_BAR],[1,MAX(ZHIS)],LINESTYLE='dash',COLOR='blue',OverPlot=OverPlot)
;        ZPLT_BAR = -(3.0*ZSIGMA)
;        ZPLT_VA3 = PLOT([ZPLT_BAR,ZPLT_BAR],[1,MAX(ZHIS)],LINESTYLE='dash',COLOR='blue',OverPlot=OverPlot)
;        ; Gaussian Fit
;        ZGAU = ZGAUSSIAN
;        ZPLT_VAG = PLOT(ZCEN,ZGAU,Color=Color,YRANGE=OverPlot.yrange,OverPlot=OverPlot)
;    ENDIF
;END




; 
; Tune ZScale
; 
FUNCTION CrabImageByteScaleMagic, InputImage, SigmaRange=SigmaRange, Verbose=Verbose
    
    IF TOTAL(InputImage,/NAN) EQ 0.0 THEN RETURN, InputImage
    
    BytedImage = InputImage
    
    CrabImageHistogram, BytedImage, MIN=ZMIN, MAX=ZMAX, MEAN=ZMEAN, SIGMA=ZSIG;, /Plot
    
    BYTMIN=ZMEAN-1.5*ZSIG
    BYTMAX=ZMEAN+4.5*ZSIG
    
    IF N_ELEMENTS(SigmaRange) GE 2 THEN BEGIN
        IF SigmaRange[1] GT SigmaRange[0] THEN BEGIN
            BYTMIN=ZMEAN+SigmaRange[0]*ZSIG
            BYTMAX=ZMEAN+SigmaRange[1]*ZSIG
            ;PRINT, 'BYTMIN', BYTMIN
            ;PRINT, 'BYTMAX', BYTMAX
        ENDIF
    ENDIF
    IF N_ELEMENTS(SigmaRange) EQ 1 THEN BEGIN
        BYTMIN=ZMIN+SigmaRange*ZSIG
    ENDIF
    
   ;BytedImage = BYTSCL(BytedImage,MIN=ZMIN-0.*ZSIG,MAX=ZMAX+2.*ZSIG,/NAN)
   ;BytedImage = BYTSCL(BytedImage,MIN=ZMEAN-1.5*ZSIG,MAX=ZMEAN+4.5*ZSIG,/NAN)
    BytedImage = BYTSCL(BytedImage,MIN=BYTMIN,MAX=BYTMAX,/NAN)
    
    RETURN, BytedImage
    
;    ArithmeticException = !Except & !Except = 0
;    
;;    ZARR = InputImage[*]-MIN(InputImage[*],/NAN)+1e-6*ABS(MIN(InputImage[*],/NAN))
;;    ZARR = ZARR/MAX(ZARR,/NAN)*1d5
;;    ZARR = ALOG10(ZARR)
;    
;;    ZARR = InputImage[*]
;    
;    DoPlot = 0
;    
;    ; Get Hist
;    CIBSM_PHIS, InputImage, HIS=ZHIS, CEN=ZCEN, PEAKCEN=ZPEAKCEN, PEAKHIS=ZPEAKHIS, SIGMA=ZSIGMA, OVERPLOT=ZPLT_VAR, DoPlot=DoPlot
;    
;    ; Min Max
;    ZMIN = ZPEAKCEN-0.5*ZSIGMA
;    ZMAX = ZPEAKCEN+10.0*ZSIGMA
;    ZLEV = [0.5,0.5,0.5,0.5,0.45,0.40,0.3,0.2,0.1,0.05]
;    ZLEV = EXP(CrabArrayINDGEN(6.,1,fCount=10))
;    
;    ; Fen Bin
;    ZFenBin = CrabArrayFenBin(InputImage,Levels=ZLEV,Count=10,MIN=ZMIN,MAX=ZMAX,BinEdges=BinEdges,BinCentres=BinCentres,Verbose=Verbose)
;    WHILE BinCentres[-1] EQ 0.0 DO BinCentres=BinCentres[0:N_ELEMENTS(BinCentres)-2]
;    IF KEYWORD_SET(DoPlot) THEN BEGIN
;        FOREACH BinEdge, BinEdges DO BEGIN
;            ZPlotPX = PLOT([BinEdge,BinEdge],[1,MAX(ZHIS)],LINESTYLE='dash',COLOR='blue',OverPlot=ZPLT_VAR)
;        ENDFOREACH
;    ENDIF
;    
;    ; Saturate
;    SaturImage = InputImage
;    SaturFilter = WHERE(InputImage GT ZMAX,/NULL)
;    IF N_ELEMENTS(SaturFilter) GT 0 THEN SaturImage[SaturFilter]=ZMAX
;    
;    ; aaF ccF
;    aaF = [MIN(SaturImage),BinCentres,ZMAX]
;    ccF = [CrabArrayINDGEN(0.0,255.,fCount=N_ELEMENTS(BinCentres)+2)]
;    ssI = SORT(SaturImage[*])
;    TdF = SaturImage[ssI]
;    EdF = INTERPOL(ccF,aaF,TdF)
;;   EdF = SPLINE(aaF,ccF,TdF)
;    BytedImage = SaturImage
;    BytedImage[ssI] = EdF[*]
;    IF KEYWORD_SET(Verbose) THEN BEGIN
;        PRINT, '      Splining pixel value to byte value: '
;        FOR i=0,N_ELEMENTS(aaF)-1 DO BEGIN
;            PRINT, FORMAT='("      ",g20.7,I20)', aaF[i], ccF[i]
;        ENDFOR
;    ENDIF
;    
;    ; Do Plot
;    IF KEYWORD_SET(DoPlot) THEN BEGIN
;        I = IMAGE(BytedImage)
;    ENDIF
    
;    
;    
;;   ZMIN = MIN(InputImage,/NAN) & ZMAX = MAX(InputImage,/NAN) & ZDIS = ZMAX-ZMIN & ZMMF = ZMAX/ZMIN
;    ZMIN = MIN(ZARR,/NAN) & ZMAX = MAX(ZARR,/NAN) & ZDIS = ZMAX-ZMIN & ZMMF = ZMAX/ZMIN
;    
;    ; ZPER = 0.05 & ZMIN = ZMIN+ZPER*ZDIS
;    ; ZPER = 0.45 & ZMAX = ZMAX-ZPER*ZDIS
;    ; PRINT, ZMIN, ZMAX
;    
;    ; WINDOW, 2, XSIZE=(SIZE(InputImage,/DIM))[0], YSIZE=(SIZE(InputImage,/DIM))[1]
;    ; TVSCL, InputImage
;    
;    
;;    ZTOT = N_ELEMENTS(ZARR)
;;    ZBIN = LONG(2) ; FIX(ZTOT^0.2)
;;    ZHIS = HISTOGRAM(ZARR,NBINS=ZBIN,LOCATIONS=ZCEN)
;;    WHILE MAX(ZHIS) GT 0.10*ZTOT AND ZBIN GT 0 AND ZBIN LT 1e5 DO BEGIN ; analyzed 30% total pixels
;;        ZBIN = ZBIN + LONG(ZBIN^0.2*4.0*ALOG10(ZBIN))
;;        IF ZBIN GT 0 THEN ZHIS = HISTOGRAM(ZARR,NBINS=ZBIN,LOCATIONS=ZCEN)
;;    ENDWHILE
;;    ZSCL = ALOG10(N_ELEMENTS(WHERE(ZHIS GT 0.01*ZTOT,/NULL)))/ALOG10(ZBIN)*1.5
;;    ZSCL = 2.1
;;    PRINT, ZBIN, N_ELEMENTS(WHERE(ZHIS GT 0.01*ZTOT,/NULL)), ZSCL
;    
;;    BytedImage = CrabImagePowerLawScale(InputImage,ZSCL)
;    BytedImage = InputImage
;    
;    ; <TODO> Construct ZConvertArray(ZCONVER) -- LT HISTOGRAM CENTRE
;    ZMIN = ZPEAKCEN-2.0*ZSIGMA
;    ZCONVER = BytedImage * 0.0d
;    ZFILTER = WHERE(BytedImage GE ZPEAKCEN)
;    ZCONVER[ZFILTER] = 0.3d*(BytedImage[ZFILTER]-ZPEAKCEN) ; 0.0d
;    ZFILTER = WHERE(BytedImage LT ZPEAKCEN)
;    ZCONVER[ZFILTER] = 0.3d*(ZPEAKCEN-BytedImage[ZFILTER])
;    Conv1Image = BytedImage + ZCONVER
;    ; <TODO> Construct ZConvertArray(ZCONVER) -- GT HISTOGRAM CENTRE
;    ZSCL = 0.5
;    ZCONVER = BytedImage
;    ZFILTER = WHERE(BytedImage LE ZPEAKCEN)
;    ZCONVER[ZFILTER] = 1.0d
;    ZFILTER = WHERE(BytedImage GT ZPEAKCEN)
;    ZCONVER[ZFILTER] = EXP(-((BytedImage[ZFILTER]-ZPEAKCEN)/ZSIGMA/5.0d)^(1.0d/ZSCL))
;    Conv2Image = Conv1Image * ZCONVER
;    ConvdImage = Conv2Image
;    
;    BytedImage = BYTSCL(ConvdImage,MIN=ZMIN,MAX=ZMAX,/NAN)
;    
;    ; <TODO> Test
;    ZIMG_VA2 = IMAGE(BytedImage,TITLE='ZIMG_VA2')
;    ZPLT_VA2 = PLOT([ZMIN,ZMIN],[1,MAX(ZHIS)],LINESTYLE='dash',COLOR='green',OverPlot=ZPLT_VAR)
;    PRINT, '--- MIN-ZMIN-ZMAX-MAX   ',MIN(ConvdImage,/NAN), ZMIN, ZMAX, MAX(ConvdImage,/NAN)
;    
;    CIBSM_PHIS, ConvdImage, OVERPLOT=ZPLT_VAR, Color='magenta'
;    
;    ; <TODO> Test
;;    BytedImage = BytedImage + ZCONVER
;;    CIBSM_PHIS, BytedImage, OVERPLOT=ZPLT_VAR, Color='magenta'
;;    ZMIN = ZPEAKCEN-2.0*ZSIGMA
;;    Byte3Image = BYTSCL(BytedImage,MIN=ZMIN,MAX=ZMAX,/NAN)
;;    ZIMG_VA3 = IMAGE(Byte3Image,TITLE='ZIMG_VA3')
;;    PRINT, '--- MIN-ZMIN-ZMAX-MAX   ',MIN(BytedImage,/NAN), ZMIN, ZMAX, MAX(BytedImage,/NAN)
;    
;    ZBIN = 3000 ; BytedImage
;    ZHIS = HISTOGRAM(BytedImage[*],NBINS=ZBIN,LOCATIONS=ZCEN)
;    ; PRINT, ZBIN, ZHIS[0:10]
;    
;    ZMIN = MIN(BytedImage,/NAN) & ZMAX = MAX(BytedImage,/NAN) & ZDIS = ZMAX-ZMIN
;    
;    ZHIS = HISTOGRAM(BytedImage[*],NBINS=ZBIN,LOCATIONS=ZCEN) ; use previous ZBIN
;    
;    ArithmeticError = check_math() & !Except = ArithmeticException ; Clear floating underflow
;    
;    FOR i=0,ZBIN-1 DO BEGIN
;        IF TOTAL(ZHIS[0:i]) GT 0.0*ZTOT THEN BEGIN ; faint-end we remove <30% faintest pixels
;            ZMIN = ZCEN[i]
;            BREAK
;        ENDIF
;    ENDFOR
;    FOR i=ZBIN-1,0,-1 DO BEGIN
;        IF ZHIS[i] GT 1 THEN BEGIN ; bright-end we show most pixels but salute the most extreme cases where ZHIS=1
;            ZMAX = ZCEN[i]
;            BREAK
;        ENDIF
;    ENDFOR
;    
;    IF KEYWORD_SET(Verbose) THEN BEGIN
;        PRINT, '--- MIN-ZMIN-ZMAX-MAX   ',MIN(BytedImage,/NAN), ZMIN, ZMAX, MAX(BytedImage,/NAN)
;        PRINT, '--- ZSCL   ',ZSCL
;        PRINT, '--- ZASM   ',ZASM
;    ENDIF
;    
;    BytedImage = BYTSCL(BytedImage,MIN=ZMIN,MAX=ZMAX,/NAN)
    
;    RETURN, BytedImage
    
END
    