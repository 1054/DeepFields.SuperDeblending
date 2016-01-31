

PRO CrabGalfit, CrabGalfit_Input, WorkDir=WorkDir, MyDir=MyDir, Output=Galfit_results, Catalog_File=Catalog_File, $
                Galfit_SCI_Fits=Galfit_SCI_Fits, Galfit_RMS_Fits=Galfit_RMS_Fits, Galfit_PSF_Fits=Galfit_PSF_Fits
    
    
    ; Define WorkDir
    IF N_ELEMENTS(CrabGalfit_Input) EQ 1 THEN BEGIN
        ; check and read Params from CrabGalfit_Input file (special format)
        IF NOT FILE_TEST(CrabGalfit_Input) THEN MESSAGE, "Error! CrabGalfit Input file does not exist! ("+CrabGalfit_Input+")"
        WorkDir           = FILE_DIRNAME(CrabGalfit_Input)
        Galfit_SCI_Fits   = CrabTableReadInfo(CrabGalfit_Input,"SCI_Fits",/GiveWarning)
        Galfit_RMS_Fits   = CrabTableReadInfo(CrabGalfit_Input,"RMS_Fits",/GiveWarning)
        Galfit_PSF_Fits   = CrabTableReadInfo(CrabGalfit_Input,"PSF_Fits",/GiveWarning)
        Galfit_results    = CrabTableReadInfo(CrabGalfit_Input,"Results",/GiveWarning)
        Catalog_File      = CrabTableReadInfo(CrabGalfit_Input,"Catalog",/GiveWarning)
        DoExclude         = CrabTableReadInfo(CrabGalfit_Input,"Exclude",/GiveWarning,/Int)
        xstep             = CrabTableReadInfo(CrabGalfit_Input,"xstep",/GiveWarning,/Int)
        ystep             = CrabTableReadInfo(CrabGalfit_Input,"ystep",/GiveWarning,/Int)
        gbuff             = CrabTableReadInfo(CrabGalfit_Input,"gbuff",/GiveWarning,/Int)
        fbuff             = CrabTableReadInfo(CrabGalfit_Input,"fbuff",/GiveWarning,/Int)
    ENDIF ELSE BEGIN
        ; 
        ; MESSAGE, "Warning! No input file! Will use default values!", /CONTINUE
        ; use default params
        IF N_ELEMENTS(WorkDir)         EQ 0 THEN MESSAGE, "Error! WorkDir not given!"
        IF N_ELEMENTS(Galfit_SCI_Fits) EQ 0 THEN Galfit_SCI_Fits = "" ; <TODO>
        IF N_ELEMENTS(Galfit_RMS_Fits) EQ 0 THEN Galfit_RMS_Fits = "" ; <TODO>
        IF N_ELEMENTS(Galfit_PSF_Fits) EQ 0 THEN Galfit_PSF_Fits = "" ; <TODO>
        IF N_ELEMENTS(Galfit_results)  EQ 0 THEN Galfit_results  = "" ; <TODO>
        IF N_ELEMENTS(Catalog_File)    EQ 0 THEN Catalog_File = "" ; <TODO>
        IF STRMATCH(Catalog_File,"SED*",/F) THEN DoExclude = 1
        IF N_ELEMENTS(xstep) EQ 0 THEN xstep=70
        IF N_ELEMENTS(ystep) EQ 0 THEN ystep=70
        IF N_ELEMENTS(gbuff) EQ 0 THEN gbuff=21
        IF N_ELEMENTS(fbuff) EQ 0 THEN fbuff=1
    ENDELSE
    
    
    
    ; Go!
    
    
    
    ; Compile Lib
    ; IF N_ELEMENTS(ScriptDir) EQ 0 THEN ScriptDir = "/Users/dliu/Working/2014-CEA/Data/Level_3_SciData/Correct_Galfit_Error"
    ; CD, ScriptDir
    ; RESOLVE_ROUTINE, "writeGalfitConstraints", /COMPILE_FULL_FILE, /EITHER
    ; RESOLVE_ROUTINE, "writeGalfitInput", /COMPILE_FULL_FILE, /EITHER
    ; RESOLVE_ROUTINE, "writeDS9Regions", /COMPILE_FULL_FILE, /EITHER
    ; RESOLVE_ROUTINE, "CrabGalfitResidual", /COMPILE_FULL_FILE, /EITHER
    
    ; Fits Name and Fits Extension
    IF STRMATCH(Galfit_SCI_Fits,'*.fits\[*\]',/F) THEN BEGIN
        temp_str_split = STREGEX(Galfit_SCI_Fits,'(.*\.fits)\[([0-9]*)\]',/FOLD_CASE,/SUBEXPR,/EXTRACT)
        Galfit_SCI_Fits = temp_str_split[1]
        Galfit_SCI_Exts = FIX(temp_str_split[2])
    ENDIF ELSE BEGIN
        Galfit_SCI_Exts = 0
    ENDELSE
    IF STRMATCH(Galfit_RMS_Fits,'*.fits\[*\]',/F) THEN BEGIN
        temp_str_split = STREGEX(Galfit_RMS_Fits,'(.*\.fits)\[([0-9]*)\]',/FOLD_CASE,/SUBEXPR,/EXTRACT)
        Galfit_RMS_Fits = temp_str_split[1]
        Galfit_RMS_Exts = FIX(temp_str_split[2])
    ENDIF ELSE BEGIN
        Galfit_RMS_Exts = 0
    ENDELSE
    IF STRMATCH(Galfit_PSF_Fits,'*.fits\[*\]',/F) THEN BEGIN
        temp_str_split = STREGEX(Galfit_PSF_Fits,'(.*\.fits)\[([0-9]*)\]',/FOLD_CASE,/SUBEXPR,/EXTRACT)
        Galfit_PSF_Fits = temp_str_split[1]
        Galfit_PSF_Exts = FIX(temp_str_split[2])
    ENDIF ELSE BEGIN
        Galfit_PSF_Exts = 0
    ENDELSE
    
    PRINT, "Galfit_SCI_Fits = ", Galfit_SCI_Fits
    PRINT, "Galfit_SCI_Exts = ", Galfit_SCI_Exts
    PRINT, "Galfit_RMS_Fits = ", Galfit_RMS_Fits
    PRINT, "Galfit_RMS_Exts = ", Galfit_RMS_Exts
    PRINT, "Galfit_PSF_Fits = ", Galfit_PSF_Fits
    PRINT, "Galfit_PSF_Exts = ", Galfit_PSF_Exts
    
    
    ; Read Sci Image and PSF Image
    CD, WorkDir
    Galfit_SCI_Image = CrabReadFitsImage(Galfit_SCI_Fits,Galfit_SCI_Exts,FitsHeader=Galfit_SCI_Header,NAXIS=Galfit_SCI_NAxis)
    Galfit_RMS_Image = CrabReadFitsImage(Galfit_RMS_Fits,Galfit_RMS_Exts,FitsHeader=Galfit_RMS_Header,NAXIS=Galfit_RMS_NAxis)
    Galfit_PSF_Image = CrabReadFitsImage(Galfit_PSF_Fits,Galfit_PSF_Exts,FitsHeader=Galfit_PSF_Header,NAXIS=Galfit_PSF_NAxis)
    Galfit_PSF_Image = DOUBLE(Galfit_PSF_Image)/MAX(Galfit_PSF_Image,/NAN)
    ; Galfit_SCI_Image = MRDFITS(Galfit_SCI_Fits,Galfit_SCI_Exts,Galfit_SCI_Header);& Galfit_SCI_Image[WHERE(Galfit_SCI_Image EQ 0.0)]=!VALUES.D_NAN
    ; Galfit_RMS_Image = MRDFITS(Galfit_RMS_Fits,Galfit_RMS_Exts,Galfit_RMS_Header);& Galfit_RMS_Image[WHERE(Galfit_RMS_Image GT 1.0)]=!VALUES.D_NAN
    ; Galfit_PSF_Image = MRDFITS(Galfit_PSF_Fits,Galfit_PSF_Exts,Galfit_PSF_Header) & Galfit_PSF_Image=DOUBLE(Galfit_PSF_Image)/MAX(Galfit_PSF_Image,/NAN)
    ; Galfit_SCI_NAxis = SIZE(Galfit_SCI_Image,/DIM)
    ; Galfit_PSF_NAxis = SIZE(Galfit_PSF_Image,/DIM)
    
    RETURN
    
    ; Read Catalog
    IF NOT KEYWORD_SET(DoExclude) THEN BEGIN
        readcol, Catalog_File, FORMAT=('(A,F,F)'), COMMENT='#', catID, catRA, catDec
        Filter = !NULL
    ENDIF ELSE BEGIN
        readcol, Catalog_File, FORMAT=('(A,F,F,I)'), COMMENT='#', catID, catRA, catDec, Exclude
        Filter = WHERE(Exclude EQ 0)
        ; 
        IF N_ELEMENTS(Filter) GT 0 THEN BEGIN
            catID_F = catID & catID = catID[Filter]
            catRA_F = catRA & catRA = catRA[Filter]
            catDec_F = catDec & catDec = catDec[Filter]
        ENDIF
    ENDELSE
    
    ; NAXIS
    NAXIS1 = fxpar(Galfit_SCI_Header,"NAXIS1")
    NAXIS2 = fxpar(Galfit_SCI_Header,"NAXIS2")
    
    ; ra,dec to x,y
    CrabImageAD2XY, catRA, catDec, Galfit_SCI_Header, catX, catY ; <TODO> AD2XY coordinate starts from 0, while ds9/galfit coordinate starts from 1. <Corrected>
    ; ; EXTAST+AD2XY is old way and now is replaced by CrabImageAD2XY, which can automatically check AD2XY +-1
    ; EXTAST, Galfit_SCI_Header, Galfit_SCI_Astr
    ; AD2XY, catRA, catDec, Galfit_SCI_Astr, catX, catY ; <TODO> AD2XY coordinate starts from 0, while ds9/galfit coordinate starts from 1. <Corrected>
    ; catI = LONG(catX)       ; <TODO> AD2XY/ARRAY coordinate
    ; catJ = LONG(catY)       ; <TODO> AD2XY/ARRAY coordinate
    ; catK = catJ*NAXIS1+catI ; <TODO> AD2XY/ARRAY coordinate (array index starts from 0)
    ; catX = catX + 1.0       ; <TODO> ds9/galfit coordinate = AD2XY/ARRAY coordinate + 1
    ; catY = catY + 1.0       ; <TODO> ds9/galfit coordinate = AD2XY/ARRAY coordinate + 1
    
    ; mag magerr
    fitX = MAKE_ARRAY(N_ELEMENTS(catID),/DOUBLE,VALUE=0.0D)
    fitY = MAKE_ARRAY(N_ELEMENTS(catID),/DOUBLE,VALUE=0.0D)
    fitRMS = MAKE_ARRAY(N_ELEMENTS(catID),/DOUBLE,VALUE=0.0D)
    fitMag = MAKE_ARRAY(N_ELEMENTS(catID),/DOUBLE,VALUE=0.0D)
    fitErr = MAKE_ARRAY(N_ELEMENTS(catID),/DOUBLE,VALUE=0.0D)
    fitFlux = MAKE_ARRAY(N_ELEMENTS(catID),/DOUBLE,VALUE=0.0D)
    fitFErr = MAKE_ARRAY(N_ELEMENTS(catID),/DOUBLE,VALUE=0.0D)
    
    
    ; Prepare subdir "run_my_galfit"
    IF N_ELEMENTS(MyDir) EQ 0 THEN MyDir = "run_my_galfit"
    IF NOT FILE_TEST(MyDir,/DIR) THEN BEGIN
        FILE_MKDIR, MyDir
        CD, MyDir
        SPAWN, "ln -s ../"+Galfit_SCI_Fits+" "+Galfit_SCI_Fits
        SPAWN, "ln -s ../"+Galfit_RMS_Fits+" "+Galfit_RMS_Fits
        SPAWN, "ln -s ../"+Galfit_PSF_Fits+" "+Galfit_PSF_Fits
        SPAWN, "rm fit*.log galfit.* tmp*.fits"
    ENDIF ELSE BEGIN
        CD, MyDir
        IF NOT FILE_TEST(Galfit_SCI_Fits) THEN SPAWN, "ln -s ../"+Galfit_SCI_Fits+" "+Galfit_SCI_Fits
       ;SPAWN, "rm fit*.log galfit.* tmp*.fits"
    ENDELSE
    
    
    ; Run 1st Galfit
    xloop=1 & yloop=1 & iloop=1 ; galfit coordinate starts from 1, just like ds9 coordinate, and the CRPIX coordinate.
    icount=0
    WHILE 1 EQ 1 DO BEGIN
        ; this block
        xlower=xloop & xupper=xloop+xstep;-1
        ylower=yloop & yupper=yloop+ystep;-1
        ; is this block smaller than 1/3 step length
        ; IF 1.0*(NAXIS1-xlower)*(NAXIS2-ylower) LE 0.2*xstep*ystep OR (NAXIS1-xlower) LE 0 OR (NAXIS2-ylower) LE 0 THEN BREAK
        ; is this block out of the image?
        IF xlower GT NAXIS1 THEN BEGIN
            IF ylower LT NAXIS2 THEN BEGIN
                yloop = yloop + ystep
                xloop = 1
            ENDIF ELSE BEGIN
                BREAK
            ENDELSE
        ENDIF
        ; which sources are within this block
        runI = WHERE(catX GT xlower AND catX LT xupper AND catY GT ylower AND catY LT yupper,/NULL)
        ; 
        PRINT, STRING(FORMAT='("[",I0,",",I0,",",I0,",",I0,"]"," ","(",F0.2,",",F0.2,")"," ",I0," ",I0)',xlower,xupper,ylower,yupper,(xlower+xupper)/2.0,(ylower+yupper)/2.0,N_ELEMENTS(runI),icount)
        ; 
        runTrigger = (N_ELEMENTS(runI) GT 0)
        ; <TODO><DEBUG>
        ; runTrigger = (N_ELEMENTS(runI) GT 0) AND (CrabArrayContains(catID[runI],564))
        ; 
        IF runTrigger THEN BEGIN
            ; which sources are within buffer of this block 
            xevenlower=xlower-gbuff-fbuff & xevenupper=xupper+gbuff+fbuff
            yevenlower=ylower-gbuff-fbuff & yevenupper=yupper+gbuff+fbuff
            runJ = WHERE(catX GT xevenlower AND catX LT xevenupper AND catY GT yevenlower AND catY LT yevenupper,/NULL)
            runJ = CrabArrayRemoveValue(runJ,runI) ; runI are within block, runJ are outside block but within buffer.
            runK = [ runI, runJ ] ; sorted -> within block first, within buffer later. 
            runX = catX[runK]
            runY = catY[runK]
            ; 
            ; 
            ; try to preliminarily estimate flux and magnitude
            ; firstly measure peak flux pixel
            ; runF = Galfit_SCI_Image[catK[runK]] / MAX(Galfit_PSF_Image) ; this is old method, consistent with new method
            runF = CrabImagePixelValue(Galfit_SCI_Image,runX,runY,/Cubic,/StartsFromOne) / MAX(Galfit_PSF_Image)
            ; 
            ; then relate to nearby object matrix
            FOR i=0,N_ELEMENTS(runF)-1 DO BEGIN
                difR=(runX-runX[i])^2+(runY-runY[i])^2 ; e.g. 3 objects within 1 pix^2, then
                nomR=9.0 ; <TODO> PSF Radius=FWHM/2 in pixel unit
                difR[WHERE(difR LT nomR)]=nomR ; including itself, TOTAL(difR)=4+(*nomR), 4+ objects share this flux
                difR=difR/nomR ; normalize diffR, then TOTAL(difR)=4+
                ; PRINT, catID[runK[i]], catX[runK[i]], catY[runK[i]], Galfit_SCI_Image[catK[runK[i]]], TOTAL(nomR/difR) ; and TOTAL(1.0/difR)=4+
                runF[i]=runF[i]*(1/difR[i])/TOTAL(1/difR)
            ENDFOR
            ; then convert to magnitude
; <TODO>    ; runM = runF*0.0+10.0 ; <TODO> mag start value = 5.0
; <TODO>    ; vK = WHERE(runF GT 0,/NULL)                                          ; <TODO> convert flux to magnitude
; <TODO>    ; IF N_ELEMENTS(vK) GT 0 THEN runM[vK] = -2.5*ALOG10(runF[vK]/1.0)+0.0 ; <TODO> convert flux to magnitude!
; <TODO>    ; print
; <TODO>    ; FOR i=0,N_ELEMENTS(runK)-1 DO BEGIN
; <TODO>    ;     PRINT, catID[runK[i]], catX[runK[i]], catY[runK[i]], Galfit_SCI_Image[catK[runK[i]]], runF[i], runM[i]
; <TODO>    ; ENDFOR
;           ; 
;           
;           runM = runF*0.0+10.0
;           
            ; <TODO><DEBUG> exclude negatives
            runM = runF*0.0+10.0
            Constraint_Mag = []
            Vary_Mag = []
            FOR i=0,N_ELEMENTS(runF)-1 DO BEGIN
                IF runF[i] LE 0.3 THEN BEGIN
                    Constraint_Mag_1 = +50.0
                    Constraint_Mag_2 = +50.0
                    Vary_Mag_Flag = 0
                    runM[i] = 50.0
                ENDIF ELSE BEGIN
                    Constraint_Mag_1 = -10.0
                    Constraint_Mag_2 = +20.0
                    Vary_Mag_Flag = 1
                ENDELSE
                Constraint_Mag = [ Constraint_Mag, Constraint_Mag_1, Constraint_Mag_2 ]
                Vary_Mag = [ Vary_Mag, Vary_Mag_Flag ]
            ENDFOR
;           Vary_Mag=[-10,20]
;           Vary_Mag=[runM,runM] & Vary_Mag[INDGEN(N_ELEMENTS(runM))*2+0]=runM-1.0 & Vary_Mag[INDGEN(N_ELEMENTS(runM))*2+1]=runM+1.0
;           Vary_X=[runX,runX] & Vary_X[INDGEN(N_ELEMENTS(runX))*2+0]=runX-0.5 & Vary_X[INDGEN(N_ELEMENTS(runX))*2+1]=runX+0.5
;           Vary_Y=[runY,runY] & Vary_Y[INDGEN(N_ELEMENTS(runY))*2+0]=runY-0.5 & Vary_Y[INDGEN(N_ELEMENTS(runY))*2+1]=runY+0.5
            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
            ; FIRST STEP ON OBSERVED IMAGE ;
            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
            ; setup galfit input
            run_galfit_input = "run_galfit_"+STRING(FORMAT='(I0)',iloop)+".input"
            run_galfit_costr = "run_galfit_"+STRING(FORMAT='(I0)',iloop)+".constraints"
            run_galfit_output = "run_galfit_"+STRING(FORMAT='(I0)',iloop)+".fits"
            run_galfit_stdout = "run_galfit_"+STRING(FORMAT='(I0)',iloop)+".stdout"
            run_galfit_residual = "run_galfit_"+STRING(FORMAT='(I0)',iloop)+".residual.fits"
            run_galfit_textfile = "run_galfit_"+STRING(FORMAT='(I0)',iloop)+".txt"
            run_galfit_logfile = "run_galfit_"+STRING(FORMAT='(I0)',iloop)+".log"
            run_galfit_ds9reg = "run_galfit_"+STRING(FORMAT='(I0)',iloop)+".ds9.reg"
            ; prepare galfit!
            writeGalfitConstraints, run_galfit_costr, runX, runY, Constraint_Mag=Constraint_Mag
                                  ; Constraint_Mag=[-10,20], Constraint_X=[-0.5,0.5], Constraint_Y=[-0.5,0.5]
            writeGalfitInput, run_galfit_input, run_galfit_output, Galfit_SCI_Fits, Galfit_RMS_Fits, Galfit_PSF_Fits, runX, runY, runM, $
                            ; FittingRegion=[xevenlower,xevenupper,yevenlower,yevenupper], MagStartValue=5.0, Vary_Mag=1, Vary_X=0, Vary_Y=0, Constraints=run_galfit_costr
                              FittingRegion=[xevenlower,xevenupper,yevenlower,yevenupper], Vary_Mag=Vary_Mag, Vary_X=0, Vary_Y=0, Constraints=run_galfit_costr
            writeDS9Regions, run_galfit_ds9reg, runX-xevenlower, runY-yevenlower ; <TODO> xevenlower+1??
            ; run galfit!
            PRINT, "galfit -imax 300 "+run_galfit_input+" > "+run_galfit_stdout
            SPAWN, "galfit -imax 300 "+run_galfit_input+" > "+run_galfit_stdout & WAIT, 0.2
            SPAWN, "mv galfit.01 "+run_galfit_textfile
            SPAWN, "mv fit.log "+run_galfit_logfile
            ; save galfit residual
            CrabGalfitResidual, run_galfit_output, Galfit_SCI_Fits, Galfit_RMS_Fits, Galfit_PSF_Fits, DoNotSaveFits=1, $
                                Galfit_X=xx, Galfit_Y=yy, Galfit_Mag=mm, Galfit_Err=me, Galfit_Flux=ff, Galfit_FErr=fe
            fitX[runI] = xx[0:N_ELEMENTS(runI)-1]
            fitY[runI] = yy[0:N_ELEMENTS(runI)-1]
            fitMag[runI] = mm[0:N_ELEMENTS(runI)-1]
            fitErr[runI] = me[0:N_ELEMENTS(runI)-1]
            fitFlux[runI] = ff[0:N_ELEMENTS(runI)-1]
            fitFErr[runI] = fe[0:N_ELEMENTS(runI)-1]
            icount = icount + N_ELEMENTS(runI)
            
            ; get noise for each source from noise map Galfit_RMS_Image
            FOR i=0,N_ELEMENTS(runI)-1 DO BEGIN
               ;fitRMS[runI[i]] = STDDEV(Galfit_RMS_Image[LONG(catX[runI[i]])-1:LONG(catX[runI[i]])+1,LONG(catY[runI[i]])-1:LONG(catY[runI[i]])+1]) ; <TODO> array oversubscript!
                fitRMS[runI[i]] = MEAN(Galfit_RMS_Image[LONG(catX[runI[i]]-1)-1:LONG(catX[runI[i]]-1)+1,LONG(catY[runI[i]]-1)-1:LONG(catY[runI[i]]-1)+1]) ; <TODO> array oversubscript!
                                                                                                                     ; <TODO> ds9/galfit coordinate = AD2XY/ARRAY coordinate + 1
                                                                                                                     ; <Corrected><20140430><DZLIU>
            ENDFOR
            
            ; print results
            results_file = "../results_table_running_"+MyDir
            OPENW, results_io, results_file, /GET_LUN
            PRINTF, results_io, FORMAT='("#",A15," ",A16," ",A16," ",A16," ",A16," ",A26," ",A18," ",A18," ",A18," ",A18)', $
                                "X", "Y", "RMS", "Mag", "MagErr", "RA", "Dec", "ID", "Flux", "FluxErr"
            PRINTF, results_io, "#"
            FOR i=0,N_ELEMENTS(catID)-1 DO BEGIN
                PRINTF, results_io, FORMAT='(F16.3," ",F16.3," ",G16.3," ",F16.3," ",G16.3," ",F26.7," ",F18.7," ",A18," ",F18.7," ",F18.7)', $ ; <TODO> final table format
                                    fitX[i], fitY[i], fitRMS[i], fitMag[i], fitErr[i], catRA[i], catDec[i], catID[i], fitFlux[i]*1000.0, fitFErr[i]*1000.0
            ENDFOR
            CLOSE, results_io
            FREE_LUN, results_io
            
        ENDIF
        ; next block
        xloop = xloop + xstep
        ; yloop = yloop + ystep
        iloop = iloop + 1
    ENDWHILE
    CD, ".."
    
    
    ; filter ; <TODO>
    ; IF N_ELEMENTS(Filter) GT 0 THEN BEGIN
    ;     fitX_F = MAKE_ARRAY(N_ELEMENTS(catID_F),/DOUBLE,VALUE=-99D) & fitX_F[Filter] = fitX & fitX = fitX_F
    ;     fitY_F = MAKE_ARRAY(N_ELEMENTS(catID_F),/DOUBLE,VALUE=-99D) & fitY_F[Filter] = fitY & fitY = fitY_F
    ;     fitRMS_F = MAKE_ARRAY(N_ELEMENTS(catID_F),/DOUBLE,VALUE=-99D) & fitRMS_F[Filter] = fitRMS & fitRMS = fitRMS_F
    ;     fitMag_F = MAKE_ARRAY(N_ELEMENTS(catID_F),/DOUBLE,VALUE=+99D) & fitMag_F[Filter] = fitMag & fitMag = fitMag_F
    ;     fitErr_F = MAKE_ARRAY(N_ELEMENTS(catID_F),/DOUBLE,VALUE=-99D) & fitErr_F[Filter] = fitErr & fitErr = fitErr_F
    ;     catID = catID_F
    ;     catRA = catRA_F
    ;     catDec = catDec_F
    ;     fitFlux_F = MAKE_ARRAY(N_ELEMENTS(catID_F),/DOUBLE,VALUE=-99D) & fitFlux_F[Filter] = fitFlux & fitFlux = fitFlux_F
    ;     fitFErr_F = MAKE_ARRAY(N_ELEMENTS(catID_F),/DOUBLE,VALUE=-99D) & fitFErr_F[Filter] = fitFErr & fitFErr = fitFErr_F
    ; ENDIF
    
    
    ; save final gafit result table
    OPENW, results_io, Galfit_results, /GET_LUN
    PRINTF, results_io, FORMAT='("#",A15," ",A16," ",A16," ",A16," ",A16," ",A26," ",A18," ",A18," ",A18," ",A18)', $
                        "X", "Y", "RMS", "Mag", "MagErr", "RA", "Dec", "ID", "Flux", "FluxErr"
    PRINTF, results_io, "#"
    FOR i=0,N_ELEMENTS(catID)-1 DO BEGIN
        PRINTF, results_io, FORMAT='(F16.3," ",F16.3," ",G16.3," ",F16.3," ",G16.3," ",F26.7," ",F18.7," ",A18," ",F18.7," ",F18.7)', $ ; <TODO> final table format
                            fitX[i], fitY[i], fitRMS[i], fitMag[i], fitErr[i], catRA[i], catDec[i], catID[i], fitFlux[i], fitFErr[i]
    ENDFOR
    CLOSE, results_io
    FREE_LUN, results_io
    
    
    ; save final galfit residual
    CrabGalfitResidual, Galfit_results, Galfit_SCI_Fits, Galfit_RMS_Fits, Galfit_PSF_Fits
    
    
    PRINT, 'myGalfit Done!'
    
    
    RETURN
    
END
