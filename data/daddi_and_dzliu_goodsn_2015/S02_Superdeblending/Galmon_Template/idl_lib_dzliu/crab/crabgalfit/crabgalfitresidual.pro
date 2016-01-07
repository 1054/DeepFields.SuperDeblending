

PRO CrabGalfitResidual, Galfit_results, Galfit_SCI_Fits, Galfit_RMS_Fits, Galfit_PSF_Fits, Verbose=Verbose, DoNotSaveFits=DoNotSaveFits, $
                        Galfit_X=xx, Galfit_Y=yy, Galfit_Mag=mm, Galfit_Err=me, Galfit_Flux=ff, Galfit_FErr=fe, Galfit_RMS=ee
    
    ; spawn, "rm galfit.01 fit.log fit.stdout"
    
    ; Read results_ximax_xdate
    ; use default params
   ;CD, "/Users/dliu/Working/2014-CEA/Data/Level_3_SciData/GOODS-North-Do1160-ReTry"
   ;CD, "/Users/dliu/Working/2014-CEA/Data/Level_3_SciData/GOODS-North-Do1160-ReTry-5/doing1160_Step4_Galfit_20140520/"
   ;CD, "/Users/dliu/Working/2014-CEA/Data/Level_3_SciData/GOODS-North/doing1160_Step5_PostGalfit_201406_255_NoInitialGuess/"
    CD, "/Users/dliu/Working/2014-CEA/Tool/Level_3_SciData/GalFit/doing1160/"
    IF N_ELEMENTS(Galfit_SCI_Fits) EQ 0 THEN Galfit_SCI_Fits = "combined_maw0_4_azw0_5_sig_astro_subfaintDL.fits"
    IF N_ELEMENTS(Galfit_RMS_Fits) EQ 0 THEN Galfit_RMS_Fits = "combined_maw0_4_azw0_5_rms.fits"
    IF N_ELEMENTS(Galfit_PSF_Fits) EQ 0 THEN Galfit_PSF_Fits = "totPSFnew.fits"
   ;IF N_ELEMENTS(Galfit_results)  EQ 0 THEN Galfit_results  = "results_1160_201406" ; <TODO>
    IF N_ELEMENTS(Galfit_results)  EQ 0 THEN Galfit_results  = "results_1160_201408" ; <TODO>
    
    IF NOT FILE_TEST(Galfit_results) THEN MESSAGE, "Error! Galfit result is invalid! ("+Galfit_results+")"
    
    PRINT, "CrabGalfitResidual"
    PRINT, "Galfit_SCI_Fits = " + Galfit_SCI_Fits
    PRINT, "Galfit_RMS_Fits = " + Galfit_RMS_Fits
    PRINT, "Galfit_PSF_Fits = " + Galfit_PSF_Fits
    PRINT, "Galfit_results  = " + Galfit_results
    
    IF NOT KEYWORD_SET(Verbose) THEN Silent=1
    
    IF STRMATCH(Galfit_results,"*.fits",/F) THEN BEGIN
        ; input is the galfit output fits
        ; get galfit result
        xx = [] & yy = [] & mm = [] & me = [] & ff = [] & fe = [] & nn = 0
        Galfit_ResImage = MRDFITS(Galfit_results,2,Galfit_ResHead,Silent=Silent)
        i = 0
        WHILE 1 EQ 1 DO BEGIN ; only runI are within block, runJ are outside block but within buffer. 
            COMP_i = fxpar(Galfit_ResHead,STRING(FORMAT='("COMP_",I0)',i+1))
            IF STRMATCH(COMP_i,"*psf*",/F) THEN BEGIN
                XC_i = fxpar(Galfit_ResHead,STRING(FORMAT='(I0,"_XC")',i+1))
                YC_i = fxpar(Galfit_ResHead,STRING(FORMAT='(I0,"_YC")',i+1))
                MAG_i = fxpar(Galfit_ResHead,STRING(FORMAT='(I0,"_MAG")',i+1))
                XC_i = CrabStringClean(XC_i,TextsToRemove=["*","[","]"])
                YC_i = CrabStringClean(YC_i,TextsToRemove=["*","[","]"])
                MAG_i = CrabStringClean(MAG_i,TextsToRemove=["*","[","]"])
                IF STRPOS(XC_i,'+/-') GT -1 THEN X_iF = DOUBLE(STRMID(XC_i,0,STRPOS(XC_i,'+/-'))) ELSE X_iF = DOUBLE(STRMID(XC_i,0))
                IF STRPOS(YC_i,'+/-') GT -1 THEN Y_iF = DOUBLE(STRMID(YC_i,0,STRPOS(YC_i,'+/-'))) ELSE Y_iF = DOUBLE(STRMID(YC_i,0))
                IF STRPOS(MAG_i,'+/-') GT -1 THEN Mag_iF = DOUBLE(STRMID(MAG_i,0,STRPOS(MAG_i,'+/-'))) ELSE Mag_iF = DOUBLE(STRMID(MAG_i,0))
                IF STRPOS(MAG_i,'+/-') GT -1 THEN Err_iF = DOUBLE(STRMID(MAG_i,STRPOS(MAG_i,'+/-')+3)) ELSE Err_iF = 0.0
                
                Flux_iF = 10^((Mag_iF-0.0)/(-2.5)) ; <TODO> magnitude to flux!
                FErr_iF = Flux_iF*Err_iF/1.08574   ; <TODO> magnitude to flux!
                IF KEYWORD_SET(Verbose) THEN PRINT, i+1, X_iF, Y_iF, Mag_iF, Err_iF, Flux_iF, FErr_iF
                
;                IF ABS(X_iF-543.8157) LT 0.9 AND ABS(Y_iF-484.2304) LT 0.9 THEN BEGIN
;                    PRINT, 'DEBUG! ID9710 GN10' 
;                ENDIF
                
                xx = [ xx, X_iF ]
                yy = [ yy, Y_iF ]
                mm = [ mm, Mag_iF ]
                me = [ me, Err_iF ]
                ff = [ ff, Flux_iF ]
                fe = [ fe, FErr_iF ]
                nn = nn + 1
            ENDIF ELSE BEGIN
                BREAK
            ENDELSE
            i = i+1
        ENDWHILE
        Galfit_ResName = STRMID(Galfit_results,0,STRPOS(Galfit_results,".fits"))
    ENDIF ELSE IF STRMATCH(Galfit_results,"results_*",/F) THEN BEGIN
        ; if input is Daddi's supermongo + galfit output table "results_XXX_YYYYYYY"
        readcol, Galfit_results, FORMAT='(F,F,F,F,F,F,F)', xx, yy, ee, mm, me, ra, de, COUNT=nn, Silent=Silent
        vk = WHERE(mm GT -99 AND mm LE 20,/NULL)
        ff = mm*0.0
        fe = mm*0.0
        ff[vk] = 10^((mm[vk]-0.0)/(-2.5)) ; <TODO> convert magnitude to flux!
        fe[vk] = me[vk]*ff[vk]/1.08574    ; <TODO> convert magnitude to flux!
;       readcol, Galfit_results, FORMAT='(F,F,F,F,F,F,F,I,F,F)', xx, yy, ee, mm, me, ra, de, id, ff, fe, COUNT=nn, Silent=Silent
        Galfit_ResName = Galfit_results
    ENDIF ELSE BEGIN
        MESSAGE, "Error! Unsupport galfit result!"
    ENDELSE
    
    
    IF KEYWORD_SET(DoNotSaveFits) THEN BEGIN
        RETURN
    ENDIF
    
    
    ; Read Images
    Galfit_SCI_Image = MRDFITS(Galfit_SCI_Fits,0,Galfit_SCI_Header,Silent=Silent);& Galfit_SCI_Image[WHERE(Galfit_SCI_Image EQ 0.0)]=!VALUES.D_NAN
    Galfit_RMS_Image = MRDFITS(Galfit_RMS_Fits,0,Galfit_RMS_Header,Silent=Silent);& Galfit_RMS_Image[WHERE(Galfit_RMS_Image GT 1.0)]=!VALUES.D_NAN
    Galfit_PSF_Image = MRDFITS(Galfit_PSF_Fits,0,Galfit_PSF_Header,Silent=Silent) & Galfit_PSF_Image=DOUBLE(Galfit_PSF_Image)/TOTAL(Galfit_PSF_Image,/DOUBLE,/NAN)
    
    ; Check PSF Image NAXIS
    sx = FIX(fxpar(Galfit_PSF_Header,"NAXIS1"))
    sy = FIX(fxpar(Galfit_PSF_Header,"NAXIS2"))
    IF sx MOD 2 NE 1 OR sy MOD 2 NE 1 THEN BEGIN
        MESSAGE, 'Debug! PSF image has even dimension(s)! TODO!' ; <TODO> PSF image even dimensions => odd dimensions
    ENDIF
    
    ; Run CrabImageShift for models subtraction
    FOR i=0,nn-1 DO BEGIN
        ; get sci image info
        nx = FIX(fxpar(Galfit_SCI_Header,"NAXIS1"))
        ny = FIX(fxpar(Galfit_SCI_Header,"NAXIS2"))
        sx = FIX(fxpar(Galfit_PSF_Header,"NAXIS1")-1)/2
        sy = FIX(fxpar(Galfit_PSF_Header,"NAXIS2")-1)/2
        IF (xx[i]) LE 0 OR (yy[i]) LE 0 THEN CONTINUE ; <TODO> invalid model!
        fx = xx[i] & fy = yy[i]
        ix = FIX(fx) & iy = FIX(fy) ; <TODO> these coordinates start from 1
        dx = fx-DOUBLE(ix) & dy = fy-DOUBLE(iy) ; fractional part of x,y position (will be shifted by this fractional positions)
;        ; <TODO><DEBUG> ;
;        IF (fx-409.729)^2+(fy-726.193)^2 LE 0.5 THEN BEGIN
;            PRINT, 'DEBUG'
;            dx = 0.99
;            dy = 0.00
;        ENDIF ELSE CONTINUE
        ; print info
        IF KEYWORD_SET(Verbose) THEN BEGIN
            PRINT, FORMAT='(A,I0,A,I0," ","(",F0.1,"%)"," ","[",F0.3,",",F0.3,"]")', "Recovering model ", i+1, " of ", nn, FLOAT(i+1)/nn*100.0, fx, fy
        ENDIF
        ; pad mod image to slightly bigger (for later convolution)
        ModPiece = Galfit_PSF_Image*ff[i]
        ModPiece = CrabImagePad(ModPiece,PadLeft=10,PadRight=10,PadBottom=10,PadTop=10)
        ; shift mod image by convolution
        ModPiece = CrabImageShift(ModPiece,ShiftX=1-(1-dx),ShiftY=1-(1-dy),/Cubic)
        ; ModPiece = CrabImageShift(ModPiece,ShiftX=dx,ShiftY=dy,/Cubic) ; Note that dx dy SHOULD NOT larger than 10.0 (of course) ; ,/Cubic
        ; get mod image info
        sx = FIX((SIZE(ModPiece,/DIM))[0]-1)/2
        sy = FIX((SIZE(ModPiece,/DIM))[1]-1)/2
        ; pad mod image to the size of sci image
        px = ix-1-sx  & py = iy-1-sy ; pad left and bottom ; <TODO> here xx,yy are ds9/GALFIT coordinate and start from 1
        ax = nx-ix-sx & ay = ny-iy-sy ; add right and top  ; <TODO> here xx,yy are ds9/GALFIT coordinate and start from 1
        ModPiece = CrabImagePad(ModPiece,PadLeft=px,PadRight=ax,PadBottom=py,PadTop=ay)
        ; add model
        IF i EQ 0 OR N_ELEMENTS(ModImage) EQ 0 THEN ModImage = ModPiece ELSE ModImage = ModImage + ModPiece
        ; 
        ; DEBUG
        ; PRINT, "adding model "+STRING(FORMAT='("X=",F-12.3,"Y=",F-12.3,"Flux=",F-13.5,"Peak=",F-13.5)',fx,fy,ff[i],ff[i]*MAX(Galfit_PSF_Image))
        ; MWRFITS, ModPiece, "test_model_piece.fits", /CREATE
        ; SPAWN, "ds9 test_model_piece.fits &"
        ; 
        ; DEBUG
        ; PRINT, "sci image dimensions are "+STRING(FORMAT='(I0,",",I0)',nx,ny)
        ; PRINT, "mod image dimensions are "+STRING(FORMAT='(I0,",",I0)',(SIZE(ModImage,/DIM))[0],(SIZE(ModImage,/DIM))[1])
        ; PRINT, "test pad 1 "+STRING(FORMAT='("x=",F0.3," ","y=",F0.3)',fx,fy)
        ; MWRFITS, ModImage, "test_pad_1_Cubic.fits", /CREATE
        ; SPAWN, "ds9 -tile test_pad_1_Linear.fits test_pad_1_Cubic.fits &"
        ; RETURN
        ; 
    ENDFOR
    OriImage = Galfit_SCI_Image
    OriImage[WHERE(~FINITE(OriImage))] = 0.0
    OriHeader = Galfit_SCI_Header
    sxaddpar, OriHeader, "OBJECT", "Observed Image"
    sxaddpar, OriHeader, "HISTORY", CrabStringCurrentTime()
    sxaddpar, OriHeader, "HISTORY", "On this map "+STRING(FORMAT='(I0)',nn)+" sources are fitted by galfit."
    sxaddpar, OriHeader, "HISTORY", "See "+Galfit_results
    sxaddpar, OriHeader, "HISTORY", " "
    MWRFITS, OriImage, Galfit_ResName+".res.fits", OriHeader, /CREATE, Silent=Silent
    
    ModHeader = Galfit_SCI_Header
    IF N_ELEMENTS(Galfit_ResHead) GT 0 THEN BEGIN
        sxdelpar, Galfit_ResHead, ["END","XTENSION","BITPIX","NAXIS","NAXIS1","NAXIS2","OBJECT"]
        sxdelpar, ModHeader, "END"
        ModHeader = [ ModHeader, Galfit_ResHead ] ; <TODO>
        ModHeader = [ ModHeader, CrabStringPadSpace(" ",TotalLength=80) ]
        ModHeader = [ ModHeader, CrabStringPadSpace(" ",TotalLength=80) ]
        ModHeader = [ ModHeader, CrabStringPadSpace(" ",TotalLength=80) ]
    ENDIF
    sxaddpar, ModHeader, "OBJECT", "Models Image"
    sxaddpar, ModHeader, "HISTORY", CrabStringCurrentTime()
    sxaddpar, ModHeader, "HISTORY", "Model of "+STRING(FORMAT='(I0)',nn)+" sources which are fitted by galfit."
    sxaddpar, ModHeader, "HISTORY", "See "+Galfit_results
    sxaddpar, ModHeader, "HISTORY", " "
    ; sxaddpar, ModHeader, "END"
    MWRFITS, ModImage, Galfit_ResName+".res.fits", ModHeader, Silent=Silent
    
    ResImage = OriImage - ModImage
    ResHeader = Galfit_SCI_Header
    sxaddpar, ResHeader, "OBJECT", "Residual Image"
    sxaddpar, ResHeader, "HISTORY", CrabStringCurrentTime()
    sxaddpar, ResHeader, "HISTORY", "Subtracted "+STRING(FORMAT='(I0)',nn)+" sources which are fitted by galfit."
    sxaddpar, ResHeader, "HISTORY", "See "+Galfit_results
    sxaddpar, ResHeader, "HISTORY", " "
    MWRFITS, ResImage, Galfit_ResName+".res.fits", ResHeader, Silent=Silent
    
    ; ResHeader[0] = CrabStringPadSpace("SIMPLE  =                    T",TotalLength=80,/PadTrailing)
    ResHeader = Galfit_SCI_Header
    sxaddpar, ResHeader, "OBJECT", "Residual Image"
    sxaddpar, ResHeader, "HISTORY", CrabStringCurrentTime()
    sxaddpar, ResHeader, "HISTORY", "Subtracted "+STRING(FORMAT='(I0)',nn)+" sources which are fitted by galfit."
    sxaddpar, ResHeader, "HISTORY", "See "+Galfit_results
    sxaddpar, ResHeader, "HISTORY", " "
    MWRFITS, ResImage, Galfit_ResName+".residual.fits", ResHeader, /CREATE, Silent=Silent
    
    PRINT, 'Done!'
    
    RETURN
    
END