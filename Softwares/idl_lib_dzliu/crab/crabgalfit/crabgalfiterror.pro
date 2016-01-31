

PRO CrabGalfitError
    
    ; Define Galfit Results
;    Galfit_RES_Fits = "results_100_my_galfit.res.fits"
;    Galfit_RES_Table = "results_100_my_galfit"
    Galfit_RES_Fits = "FIT_goodsn_100_Map_20140417_ExclNewMap_vary.fits"
    Galfit_RES_Table = "results_100_20140417_ExclNewMap_vary"
    
    ; Define Sci Image and PSF Image
    IF N_ELEMENTS(WorkDir) EQ 0 THEN WorkDir="/Users/dliu/Working/2014-CEA/Data/Level_3_SciData/GOODS-North-Do100-NewPSF"
    IF N_ELEMENTS(Galfit_SCI_Fits) EQ 0 THEN Galfit_SCI_Fits = "pgh_goodsn_green_Map_v1.0_sci_subfaintDL.fits"
    IF N_ELEMENTS(Galfit_RMS_Fits) EQ 0 THEN Galfit_RMS_Fits = "pgh_goodsn_green_Map_v1.0_rms_DL.fits"
    IF N_ELEMENTS(Galfit_PSF_Fits) EQ 0 THEN Galfit_PSF_Fits = "pgh_goodsn_green_Psf_v1.0.fits"
    
    ; Define Catalog
;    IF N_ELEMENTS(Catalog_File) EQ 0 THEN Catalog_File = "RadioOwenMIPS24_priors_April18_2014.txt" ; <TODO>
;    IF N_ELEMENTS(Catalog_File) EQ 0 THEN Catalog_File = "SED_predictions_1160_my_galfit_run_4_updated.csv"
    IF N_ELEMENTS(Catalog_File) EQ 0 THEN Catalog_File = "SED_predictions_100_20140415_vary.csv"
    DoExclude = 1
    
    
    ; Go!
    
    
    ; Read Sci Image and PSF Image
    CD, WorkDir
    Galfit_SCI_Image = MRDFITS(Galfit_SCI_Fits,0,Galfit_SCI_Header);& Galfit_SCI_Image[WHERE(Galfit_SCI_Image EQ 0.0)]=!VALUES.D_NAN
    Galfit_RMS_Image = MRDFITS(Galfit_RMS_Fits,0,Galfit_RMS_Header);& Galfit_RMS_Image[WHERE(Galfit_RMS_Image GT 1.0)]=!VALUES.D_NAN
    Galfit_PSF_Image = MRDFITS(Galfit_PSF_Fits,0,Galfit_PSF_Header) & Galfit_PSF_Image=DOUBLE(Galfit_PSF_Image)/TOTAL(Galfit_PSF_Image,/DOUBLE,/NAN)
    Galfit_SCI_NAxis = SIZE(Galfit_SCI_Image,/DIM)
    Galfit_PSF_NAxis = SIZE(Galfit_PSF_Image,/DIM)
    
    ; Read Galfit fitted residual map
    ; Galfit_RES_Fits = "results_my_galfit_final_run_5.res.fits"
    GalRES_OriImage = MRDFITS(Galfit_RES_Fits,0,GalRES_OriHeader)
    GalRES_SimImage = MRDFITS(Galfit_RES_Fits,1,GalRES_SimHeader)
    GalRES_ResImage = MRDFITS(Galfit_RES_Fits,2,GalRES_ResHeader)
    NAXIS1 = fxpar(GalRES_ResHeader,"NAXIS1")
    NAXIS2 = fxpar(GalRES_ResHeader,"NAXIS2")
    MATRIX1 = INDGEN(NAXIS1,NAXIS2,/LONG) MOD NAXIS1
    MATRIX2 = INDGEN(NAXIS1,NAXIS2,/LONG)  /  NAXIS1
    MATRIX1 = DOUBLE(MATRIX1+1) ; xy array subscript matrix
    MATRIX2 = DOUBLE(MATRIX2+1) ; xy array subscript matrix
    
    ; Read Galfit output result table
    ; Galfit_RES_Table = "results_my_galfit_final_run_5"
    readcol, Galfit_RES_Table, FORMAT='(F,F,F,F,F,F,F)', fitX, fitY, fitRMS, fitMag, fitErr, fitRA, fitDec
    
    ; Read Catalog
    IF NOT KEYWORD_SET(DoExclude) THEN BEGIN
        readcol, Catalog_File, FORMAT=('(I,F,F)'), catID, catRA, catDec
        Filter = !NULL
    ENDIF ELSE BEGIN
        readcol, Catalog_File, FORMAT=('(I,F,F,I)'), catID, catRA, catDec, Exclude
        Filter = WHERE(Exclude EQ 0)
        IF N_ELEMENTS(Filter) GT 0 THEN BEGIN
            catID_F = catID & catID = catID[Filter]
            catRA_F = catRA & catRA = catRA[Filter]
            catDec_F = catDec & catDec = catDec[Filter]
        ENDIF
    ENDELSE
    
    ; Convert magnitude to flux
    fitFlux = 10^((fitMag-0.0)/(-2.5))*1000.0 ; <TODO> magnitude to flux!
    fitFErr = fitFlux*fitErr/1.08574          ; <TODO> magnitude to flux!
    
    ; Get Galfit residual peak intensity
    rsiPeak = CrabImagePixelValue(GalRES_ResImage,fitX,fitY,/StartsFromOne) ;<TODO>;StartsFromOne
    rsiFlux = ABS(rsiPeak) / MAX(Galfit_PSF_Image)
    addFErr = rsiFlux*0.0
    
    ; then relate to nearby object matrix
    FOR i=0,N_ELEMENTS(rsiFlux)-1 DO BEGIN
        ; calc residual map intensity <TODO> Uncertainty Part 1 - confusion noise from unknown background sources
        difR=(fitX-fitX[i])^2+(fitY-fitY[i])^2 ; e.g. 3 objects within 1 pix^2, then
        nomR=9.0 ; <TODO> PSF Radius=FWHM/2 in pixel unit
        difR[WHERE(difR LT nomR)]=nomR ; including itself, TOTAL(difR)=4+(*nomR), 4+ objects share this flux
        difR=difR/nomR ; normalize diffR, then TOTAL(difR)=4+
        addFErr[i]=rsiFlux[i]*(rsiFlux[i]/difR[i])/TOTAL(rsiFlux/difR)
        IF catID[i] EQ 8968 THEN BEGIN ; <TODO> DEBUG
        PRINT, "ID", catID[i], "   X", fitX[i], "   Y", fitY[i], "   FitFlux", fitFlux[i], "   FitFErr", fitFErr[i], "   ResPeak", rsiPeak[i], "   ResFlux", rsiFlux[i], "   Add+1", addFErr[i]
        ENDIF
        ; calc residual map within PSF pixel inflation <TODO> Uncertainty Part 2 - pixel inflation noise
        difR=(MATRIX1-fitX[i])^2+(MATRIX2-fitY[i])^2
        indR=GalRES_ResImage[WHERE(difR LE nomR*2.0,/NULL)]
        IF N_ELEMENTS(indR) GT 0 THEN addFErr[i]=addFErr[i]+STDDEV(indR)
    ENDFOR
    
    ; Convert flux error to magnitude error
    newFErr = fitFErr+addFErr
    newErr = fitErr
    vK = WHERE(fitFlux GT 0,/NULL) ; flux non zero
    IF N_ELEMENTS(vK) GT 0 THEN newErr[vK] = (newFErr)/fitFlux*1.08574 ; <TODO> flux error to magnitude error!
    FOR i=0,N_ELEMENTS(newErr)-1 DO BEGIN
        IF catID[i] EQ 18911 THEN BEGIN ; <TODO> DEBUG
            PRINT, FORMAT='("ID",I6,"   Old FErr",F9.3,"   New FErr",F9.3,"   Old MagErr",E12.3,"   New MagErr",E12.3)', catID[i], fitFErr[i], newFErr[i], fitErr[i], newErr[i]
        ENDIF
    ENDFOR
    
    ; Update final Galfit output result table
    Galfit_NEW_Table = Galfit_RES_Table+"_updated"
    OPENW, results_io, Galfit_NEW_Table, /GET_LUN
    PRINTF, results_io, FORMAT='("#",A15," ",A16," ",A16," ",A16," ",A16," ",A26," ",A18," ",A15," ",A18," ",A18," ",A18)', "X", "Y", "RMS", "Mag", "MagErr", "RA", "Dec", "Id", "Flux", "FluxErr", "OldFErr"
    PRINTF, results_io, "#"
    FOR i=0,N_ELEMENTS(catRA)-1 DO BEGIN
        PRINTF, results_io, FORMAT='(F16.3," ",F16.3," ",G16.3," ",F16.3," ",G16.3," ",F26.7," ",F18.7," ",I15," ",F18.7," ",F18.7," ",F18.7)', $ ; <TODO> final table format
                            fitX[i], fitY[i], fitRMS[i], fitMag[i], newErr[i], catRA[i], catDec[i], catID[i], fitFlux[i], newFErr[i], fitFErr[i]
    ENDFOR
    CLOSE, results_io
    FREE_LUN, results_io
    
    PRINT, "Updated "+Galfit_NEW_Table
    
    RETURN
    
END