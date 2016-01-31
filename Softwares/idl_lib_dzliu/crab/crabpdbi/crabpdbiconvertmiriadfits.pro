PRO CrabPdBIConvertMiriadFits, InputFitsFile, OutputFitsFile
    
    ; 
    FitsData = MRDFITS(InputFitsFile, 0, FitsHead)
    
    ; PRINT, TAG_NAMES(FitsData)
    
    VisNumber = SIZE(FitsData,/DIM) ; SXPAR(FitsHead,'GCOUNT')
    
    HELP, FitsData
    HELP, FitsData[0]
    HELP, FitsData[0].PARAMS ; Array[6, 75450]
    HELP, FitsData[0].ARRAY ; Array[3, 1, 90, 75450]
    PRINT, SXPAR(FitsHead, 'PTYPE1') ;; should be UU
    PRINT, SXPAR(FitsHead, 'PTYPE2') ;; should be VV
    PRINT, SXPAR(FitsHead, 'PTYPE3') ;; should be WW
    PRINT, SXPAR(FitsHead, 'PTYPE4') ;; should be DATE
    PRINT, SXPAR(FitsHead, 'PTYPE5') ;; should be DATE
    PRINT, SXPAR(FitsHead, 'PTYPE6') ;; should be BASELINE
    PRINT, SXPAR(FitsHead, 'PTYPE7') ;; should be FREQSEL
    PRINT, SXPAR(FitsHead, 'CTYPE1') ;; should be 0
    PRINT, SXPAR(FitsHead, 'CTYPE2') ;; should be COMPLEX
    PRINT, SXPAR(FitsHead, 'CTYPE3') ;; should be STOKES
    PRINT, SXPAR(FitsHead, 'CTYPE4') ;; should be FREQ
    PRINT, SXPAR(FitsHead, 'CTYPE5') ;; should be IF
    PRINT, SXPAR(FitsHead, 'CTYPE6') ;; should be RA
    PRINT, SXPAR(FitsHead, 'CTYPE7') ;; should be DEC
    
    ; Prepare Standard CASA uvfits format
    ; PARAM contains 7 items
    SinglePARAM = MAKE_ARRAY(7,/FLOAT,VALUE=0.0) ;; UU, VV, WW, DATE, DATE, BASELINE, FREQSEL
    UpdatePARAM = MAKE_ARRAY(7,VisNumber,/FLOAT,VALUE=0.0) ;; UU, VV, WW, DATE, DATE, BASELINE, FREQSEL
    ; ARRAY contains 
    
    
    ; Copy 
    UpdatePARAM[0,*] = FitsData.PARAMS[0] ;; UU
    UpdatePARAM[1,*] = FitsData.PARAMS[1] ;; VV
    UpdatePARAM[2,*] = FitsData.PARAMS[2] ;; WW
    UpdatePARAM[5,*] = FitsData.PARAMS[3] ;; BASELINE
    UpdatePARAM[4,*] = FitsData.PARAMS[4] ;; DATE
    SXADDPAR,FitsHead,'NAXIS',7 ;; set PARAM dimension 7 : UU, VV, WW, DATE, DATE, BASELINE, FREQSEL
    SXADDPAR,FitsHead,'NAXIS7',1
    SXADDPAR,FitsHead,'PCOUNT',7
    SXADDPAR,FitsHead,'PTYPE4','DATE'
    SXADDPAR,FitsHead,'PTYPE6','BASELINE'
    SXADDPAR,FitsHead,'PTYPE7','FREQSEL'
    SXADDPAR,FitsHead,'PZERO7',0.00000000000E+00
    SXADDPAR,FitsHead,'PSCAL7',1.00000000000E+00
    SXADDPAR,FitsHead,'CTYPE7',SXPAR(FitsHead,'CTYPE6') ;; put DEC CTYPE7
    SXADDPAR,FitsHead,'CRVAL7',SXPAR(FitsHead,'CRVAL6')
    SXADDPAR,FitsHead,'CRPIX7',SXPAR(FitsHead,'CRPIX6')
    SXADDPAR,FitsHead,'CDELT7',SXPAR(FitsHead,'CDELT6')
    SXADDPAR,FitsHead,'CTYPE6',SXPAR(FitsHead,'CTYPE5') ;; put RA CTYPE 6
    SXADDPAR,FitsHead,'CRVAL6',SXPAR(FitsHead,'CRVAL5')
    SXADDPAR,FitsHead,'CRPIX6',SXPAR(FitsHead,'CRPIX5')
    SXADDPAR,FitsHead,'CDELT6',SXPAR(FitsHead,'CDELT5')
    SXADDPAR,FitsHead,'CTYPE5','IF' ;; put IF CTYPE 5
    SXADDPAR,FitsHead,'CRVAL5',1.00000000000E+00
    SXADDPAR,FitsHead,'CRPIX5',1.00000000000E+00
    SXADDPAR,FitsHead,'CDELT5',1.00000000000E+00
    
    ; Update
    PRINT, FitsHead
    
    ; Write
    MWRFITS, FitsData.ARRAY, 'new.fits', FitsHead, /Create, Group=UpdatePARAM
    
    

END