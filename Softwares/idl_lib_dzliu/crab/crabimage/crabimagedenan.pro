PRO CrabImageDeNaN, InputFitsOrImage, Extension=Extension
    
    IF SIZE(InputFitsOrImage,/TNAME) EQ 'STRING' THEN BEGIN
        IF FILE_TEST(InputFitsOrImage) THEN BEGIN
            IF N_ELEMENTS(Extension) EQ 0 THEN Extension=0
            FitsImage = MRDFITS(InputFitsOrImage,Extension,FitsHeader)
            FitsFile = InputFitsOrImage
        ENDIF ELSE BEGIN
            MESSAGE, 'CrabImageDeNaN: Fits file not found! '+InputFitsOrImage
            RETURN
        ENDELSE
    ENDIF ELSE BEGIN
        ;<TODO> if input is directly an image ?
        MESSAGE, 'CrabImageDeNaN: Please input a fits file!'
        RETURN
    ENDELSE
    
    IF SIZE(InputFitsOrImage,/N_DIM) EQ 2 THEN BEGIN
        FitsImage = InputFitsOrImage
    ENDIF
    
    IF SIZE(FitsImage,/N_DIM) GE 2 THEN BEGIN
        DeNaNImage = FitsImage
        DeNaNFilter = WHERE(~FINITE(FitsImage),/NULL)
        IF N_ELEMENTS(DeNaNFilter) GT 0 THEN BEGIN
            DeNaNImage[DeNaNFilter] = 0.0D
        ENDIF ELSE BEGIN
            MESSAGE, 'CrabImageDeNaN: Fits image is good! No NaN found!' 
            RETURN
        ENDELSE
        ; make header
        IF N_ELEMENTS(FitsHeader) EQ 0 THEN BEGIN
            MKHDR, FitsImage, FitsHeader
        ENDIF
        ; save fits
        ; PRINT, FitsFile
        IF N_ELEMENTS(FitsFile) EQ 1 THEN BEGIN
            FitsName = FILE_BASENAME(FitsFile,'.fits')+'_denan.fits'
            MWRFITS, DeNaNImage, FitsName, FitsHeader, /CREATE
        ENDIF
    ENDIF


END
