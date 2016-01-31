; 
; CrabReadFitsImage 
; Read an image from a fits file.
; 
; History:
;     2013-09-07   Keyword RemoveNaN
; 
FUNCTION CrabReadFitsImage, FitsFile, FitsExtension, $
                            FITSHEADER= FitsHeader,$
                            FITSASTR  = FitsAstr,  $
                            NAXIS     = NAxis,     $
                            PIXSCALE  = PixScale,  $ ; one value
                            PIXSIZES  = PixSizes,  $ ; a two dim array
                            MAXPIXEL  = MaxPixel,  $
                            DISTOCENT = DisToCent, $ ; an array
                            ZUNIT     = ZUnit,     $ ; flux unit of each pixel
                            BUNIT     = BUnit,     $ ; flux unit of each pixel
                            VERBOSE   = Verbose,   $
                            SILENCE   = Silence,   $
                            DOUBLE    = Double,    $
                            REMOVENAN = RemoveNaN, $
                            ArrayI    = ArrayI,    $ ; an one dimension array containing each pixel's i coordinate (starting from 0)
                            ArrayJ    = ArrayJ,    $ ; an one dimension array containing each pixel's j coordinate (starting from 0)
                            ArrayX    = ArrayX,    $ ; an one dimension array containing each pixel's x distance to center
                            ArrayY    = ArrayY,    $ ; an one dimension array containing each pixel's y distance to center
                            ArrayR    = ArrayR,    $ ; an one dimension array containing each pixel's distance to center
                     NoUnitConversion = NoUnitConversion  
    
    
    ; Check Input FitsFile
    IF N_ELEMENTS(FitsFile) EQ 0 OR SIZE(FitsFile,/TYPE) NE 7 THEN MESSAGE, 'Input FitsFile '+FitsFile+' is invalid! Exit!'
    ; IF N_ELEMENTS(FitsFile) EQ 0 OR SIZE(FitsFile,/TYPE) NE 7 THEN PRINT, 'CrabReadFitsImage: Input FitsFile is invalid! Exit!'
    ; IF N_ELEMENTS(FitsFile) EQ 0 OR SIZE(FitsFile,/TYPE) NE 7 THEN RETURN, []
    IF FILE_TEST(FitsFile,/READ) NE 1 THEN MESSAGE, 'Input FitsFile '+FitsFile+' does not exist! Exit!'
    ; IF FILE_TEST(FitsFile,/READ) NE 1 THEN PRINT, 'CrabReadFitsImage: Input FitsFile does not exist! Exit!'
    ; IF FILE_TEST(FitsFile,/READ) NE 1 THEN RETURN, []
    IF NOT Keyword_Set(Silence) THEN MESSAGE, /CONTINUE, 'Reading ' + FitsFile
    
    
    ; 
    FitsHeader = []
    FitsImage = []
    
    
    ; 
    IF N_ELEMENTS(FitsExtension) EQ 0 THEN FitsExtension = 0
    
    
    ; Examine each extension
    ; Read Image,Header,NAXIS
    FITS_INFO, FitsFile, /SILENT, N_EXT=NExt
    IF FitsExtension EQ -1 THEN BEGIN ; read the last image but all headers
        FOR IExt=0,NExt DO BEGIN
            FitsImage = MRDFITS(FitsFile, IExt, ExtHeader, /SILENT)
;           <Corrected><20140701><DZLIU
;           FitsImage = FitsImage[*,*,0]
;           <Corrected><20140701><DZLIU
            FitsHeader = [FitsHeader,ExtHeader]
            NAxis = SIZE(FitsImage,/DIMENSIONS)
            IF N_ELEMENTS(NAxis) EQ 3 THEN BEGIN & FitsImage = FitsImage[*,*,0] & NAxis=NAxis[0:1] & ENDIF
            ; IF N_ELEMENTS(NAxis) EQ 2 THEN BREAK
        ENDFOR
    ENDIF ELSE BEGIN ; read specified fits extension
        IF NExt EQ 0 THEN BEGIN ; if the fits has only 1 data cube but no extension like PACS images
            IExt = 0
            FitsImage = MRDFITS(FitsFile, IExt, ExtHeader, /SILENT)
            FitsHeader = ExtHeader
            NAxis = SIZE(FitsImage,/DIMENSIONS)
            
            ; PRINT, "NAxis = ", NAxis
            ; <TODO> for reading fits image with more than 3 naxis
            ; WHILE N_ELEMENTS(NAxis) GT 3 DO BEGIN
            ;     NAxis[N_ELEMENTS(NAxis)-2] = NAxis[N_ELEMENTS(NAxis)-2] * NAxis[N_ELEMENTS(NAxis)-1]
            ;     NAxis[N_ELEMENTS(NAxis)-1] = 1
            ;     NAxis=NAxis[0:N_ELEMENTS(NAxis)-2]
            ; ENDWHILE
            ; PRINT, "NAxis = ", NAxis
            
            IF N_ELEMENTS(NAxis) GE 3 THEN BEGIN 
                IF FitsExtension LT NAxis[2] THEN BEGIN
                    FitsImage = FitsImage[*,*,FitsExtension] & NAxis=NAxis[0:1]
                ENDIF ELSE BEGIN ; FitsExtension exceeds the image number
                    MESSAGE, "Fits file only contains " + STRING(FORMAT="I0",NAxis[2]) + " images, but required fits extension number is " + STRING(FitsExtension,FORMAT='(I0)')
                    RETURN, []
                ENDELSE
            ENDIF ELSE BEGIN
                IF FitsExtension EQ 0 THEN BEGIN
                    FitsImage = FitsImage & NAxis=NAxis
                ENDIF ELSE BEGIN ; FitsExtension exceeds the image number
                    MESSAGE, "The required fits extension number " + STRING(FitsExtension,FORMAT='(I0)') + " is out of the allowed range in fits image " + FitsFile
                    RETURN, []
                ENDELSE
            ENDELSE
        ENDIF ELSE BEGIN ; if the fits has multiple extensions
            IF FitsExtension LT NExt THEN BEGIN
                IExt = FitsExtension
                FitsImage = MRDFITS(FitsFile, IExt, ExtHeader, /SILENT)
                FitsHeader = ExtHeader
                NAxis = SIZE(FitsImage,/DIMENSIONS)
            ENDIF ELSE BEGIN ; FitsExtension exceeds the image number
                MESSAGE, "The required fits extension number " + STRING(FitsExtension,FORMAT='(I0)') + " is out of the allowed range 0-" + STRING(NExt-1,FORMAT='(I0)') + " in fits image " + FitsFile
                RETURN, []
            ENDELSE
        ENDELSE
    ENDELSE
    
    IF N_ELEMENTS(FitsImage) EQ 0 THEN MESSAGE, 'Failed to read fits image from ' + FitsFile
    IF N_ELEMENTS(FitsImage) EQ 0 THEN RETURN, []
    
    IF KEYWORD_SET(Double) THEN FitsImage = DOUBLE(FitsImage)
    
    ; PRINT, FitsImage[10,10]
    
    
    ; EXTAST
    EXTAST, FitsHeader, FitsAstr, FitsAstrError
    
    
    ; PIXSCALE
    PixSizes = [0.d,0.d] ; arcsec
    IF PixSizes[0] EQ 0.d THEN PixSizes[0] = ABS(DOUBLE(SXPAR(FitsHeader,'CD1_1')))*3600.d
    IF PixSizes[0] EQ 0.d THEN PixSizes[0] = ABS(DOUBLE(SXPAR(FitsHeader,'CDELT1')))*3600.d
    IF PixSizes[0] EQ 0.d THEN PixSizes[0] = ABS(DOUBLE(SXPAR(FitsHeader,'PIXSCALE')))
    IF PixSizes[0] EQ 0.d THEN PixSizes[0] = ABS(DOUBLE(SXPAR(FitsHeader,'PFOV')))
    IF PixSizes[1] EQ 0.d THEN PixSizes[1] = ABS(DOUBLE(SXPAR(FitsHeader,'CD2_2')))*3600.d
    IF PixSizes[1] EQ 0.d THEN PixSizes[1] = ABS(DOUBLE(SXPAR(FitsHeader,'CDELT2')))*3600.d
    IF PixSizes[1] EQ 0.d THEN PixSizes[1] = ABS(DOUBLE(SXPAR(FitsHeader,'PIXSCALE')))
    IF PixSizes[1] EQ 0.d THEN PixSizes[1] = ABS(DOUBLE(SXPAR(FitsHeader,'PFOV')))
    PixScale = PixSizes[1]
    IF PixScale EQ 0.d THEN Print, 'CrabReadFitsImage: Cannot decide pixel size?'
    
    
    ; MAXPIXEL
    unFitsImage = FitsImage
    unFitsImage[WHERE(~FINITE(unFitsImage))] = MIN(FitsImage,/NAN)
    MaxPixID = WHERE(unFitsImage EQ MAX(FitsImage,/NAN))
    MaxPixel = [ LONG(MaxPixID[0] MOD NAxis[0]), LONG(MaxPixID[0] / NAxis[0]) ]
    CentreX = MaxPixel[0] ; LONG(ImageSize[0]-1)/2
    CentreY = MaxPixel[1] ; LONG(ImageSize[1]-1)/2
    
    
    ; DISTOCENTRE
    ImageSize = NAxis
    ImageIndex = Indgen(ImageSize[0]*ImageSize[1],/L64)
    ArrayI = Double( ImageIndex mod ImageSize[0] )
    ArrayJ = Double( ImageIndex  /  ImageSize[0] )
    ArrayX = Double( ImageIndex mod ImageSize[0] ) - CentreX
    ArrayY = Double( ImageIndex  /  ImageSize[0] ) - CentreY
    ArrayR = SQRT(ArrayX^2+ArrayY^2)
    DisToCent = MAKE_ARRAY(ImageSize[0], ImageSize[1], /INTEGER, VALUE=0)
    DisToCent[ImageIndex] = ArrayR[ImageIndex]
    
    
    ; ZUNIT
    ; <TODO>
    
    
    ; REMOVENAN
    IF KEYWORD_SET(RemoveNaN) THEN BEGIN
        FitsImage[WHERE(~FINITE(FitsImage))] = 0.0D
    ENDIF
    
    ; Convert Unit to Jy/pixel
    IF NOT KEYWORD_SET(NoUnitConversion) THEN BEGIN
        ZUnit = SXPAR(FitsHeader,'PHOTFLAM',COMMENT=ZUnitComment)
        IF !ERR EQ 0 THEN BEGIN ; no err = FitsHeader has 'PHOTFLAM' keyword
            FUnit = STRTRIM(ZUnit,2)
            FUCom = STRTRIM(ZUnitComment,2)
            FUKey = 'PHOTFLAM'
        ENDIF
        ZUnit = SXPAR(FitsHeader,'PHOTFNU',COMMENT=ZUnitComment)
        IF !ERR EQ 0 THEN BEGIN ; no err = FitsHeader has 'PHOTFNU' keyword
            FUnit = STRTRIM(ZUnit,2)
            FUCom = STRTRIM(ZUnitComment,2)
            FUKey = 'PHOTFNU'
        ENDIF
        ZUnit = SXPAR(FitsHeader,'ZUNIT',COMMENT=ZUnitComment)
        IF !ERR EQ 0 THEN BEGIN ; no err = FitsHeader has 'ZUNIT' keyword
            FUnit = STRTRIM(ZUnit,2)
            FUCom = STRTRIM(ZUnitComment,2)
            FUKey = 'ZUNIT'
        ENDIF
        BUnit = SXPAR(FitsHeader,'BUNIT',COMMENT=BUnitComment) ; BUNIT has higher priority
        IF !ERR EQ 0 THEN BEGIN ; no err = FitsHeader has 'BUNIT' keyword
            FUnit = STRTRIM(BUnit,2)
            FUCom = STRTRIM(BUnitComment,2)
            FUKey = 'BUNIT'
        ENDIF
        ; 
        IF N_ELEMENTS(FUnit) EQ 1 THEN BEGIN
            IF STRMATCH(FUCom,'*ergs/cm2/Ang/electron*',/F) THEN BEGIN
                ETime = SXPAR(FitsHeader,'EXPTIME',COMMENT=ETimeComment)
                IF !ERR EQ 0 THEN BEGIN ; no err = FitsHeader has 'EXPTIME' keyword
                    EWave = SXPAR(FitsHeader,'PHOTPLAM',COMMENT=EWaveComment)
                    IF !ERR EQ 0 THEN BEGIN ; no err = FitsHeader has 'PHOTPLAM' keyword
                        FConv = Double(FUnit) * 1d23 / Double(ETime) / (2.99792458e8/1d-10/(Double(EWave))^2)
                        FitsImage = FitsImage * FConv
                       ;FXADDPAR, FitsHeader, FUKey,      FUnit, 'converted '+'ergs/cm2/Ang/electron'+' to '+'Jy/pixel'+' by '+STRING(FORMAT='(G0.6)',FConv) ;<Corrected><20150206><DzLIU>; new unit should be Jy/pixel
                        FXADDPAR, FitsHeader, FUKey, 'Jy/pixel', 'converted '+'ergs/cm2/Ang/electron'+' to '+'Jy/pixel'+' by '+STRING(FORMAT='(G0.6)',FConv) ;<Corrected><20150206><DzLIU>; new unit should be Jy/pixel
                        IF NOT KEYWORD_SET(Silence) THEN MESSAGE, /CONTINUE, 'Converted '+FUKey+' ergs/cm2/Ang/electron'+' to '+'Jy/pixel'+' by '+STRING(FORMAT='(G0.6)',FConv)
                    ENDIF
                ENDIF
            ENDIF
            IF STRMATCH(FUCom,'*Jy*sec/electron*',/F) THEN BEGIN
                ETime = SXPAR(FitsHeader,'EXPTIME',COMMENT=ETimeComment)
                IF !ERR EQ 0 THEN BEGIN ; no err = FitsHeader has 'EXPTIME' keyword
                    EWave = SXPAR(FitsHeader,'PHOTPLAM',COMMENT=EWaveComment)
                    IF !ERR EQ 0 THEN BEGIN ; no err = FitsHeader has 'PHOTPLAM' keyword
                        FConv = Double(FUnit) / Double(ETime)
                        FitsImage = FitsImage * FConv
                       ;FXADDPAR, FitsHeader, FUKey,      FUnit, 'converted '+'Jy*sec/electron'+' to '+'Jy/pixel'+' by '+STRING(FORMAT='(G0.6)',FConv) ;<Corrected><20150206><DzLIU>; new unit should be Jy/pixel
                        FXADDPAR, FitsHeader, FUKey, 'Jy/pixel', 'converted '+'Jy*sec/electron'+' to '+'Jy/pixel'+' by '+STRING(FORMAT='(G0.6)',FConv) ;<Corrected><20150206><DzLIU>; new unit should be Jy/pixel
                        IF NOT KEYWORD_SET(Silence) THEN MESSAGE, /CONTINUE, 'Converted '+FUKey+' Jy*sec/electron'+' to '+'Jy/pixel'+' by '+STRING(FORMAT='(G0.6)',FConv)
                    ENDIF
                ENDIF
            ENDIF
            IF FUnit EQ 'MJy/sr' AND NOT STRMATCH(FUCom,'*converted MJy/sr to Jy/pixel by*',/F) THEN BEGIN
                FConv = 2.350443e-5 * PixSizes[0] * PixSizes[1]
                FitsImage = FitsImage * FConv
               ;FXADDPAR, FitsHeader, FUKey,      FUnit, 'converted '+FUnit+' to '+'Jy/pixel'+' by '+STRING(FORMAT='(G0.6)',FConv) ;<Corrected><20150206><DzLIU>; new unit should be Jy/pixel
                FXADDPAR, FitsHeader, FUKey, 'Jy/pixel', 'converted '+FUnit+' to '+'Jy/pixel'+' by '+STRING(FORMAT='(G0.6)',FConv) ;<Corrected><20150206><DzLIU>; new unit should be Jy/pixel
                IF NOT KEYWORD_SET(Silence) THEN MESSAGE, /CONTINUE, 'Converted '+FUKey+' '+FUnit+' to '+'Jy/pixel'+' by '+STRING(FORMAT='(G0.6)',FConv)
            ENDIF
            IF FUnit EQ 'Jy/beam' THEN BEGIN
                PSFBeamArea = RecognizePSFBeamArea(RecognizeInstrument(FitsFile)+RecognizeFilter(FitsFile)) ; arcsec^2
                PSFBeamSizes = RecognizePSF(RecognizeInstrument(FitsFile)+RecognizeFilter(FitsFile)) ; arcsec^2
                IF PSFBeamArea EQ 0.0 THEN PSFBeamArea = !PI*PSFBeamSizes[0]*PSFBeamSizesp[1] ;<TODO>;
                IF PSFBeamArea EQ 0.0 THEN MESSAGE, 'CrabReadFitsImage: Error when converting the flux unit '+FUnit+' to Jy/pixel!'
                FConv = 1.0d / PSFBeamArea * PixSizes[0] * PixSizes[1] ; PSF beam area should be solid angle (cone), pixel area should be rectangle
                FitsImage = FitsImage * FConv
               ;FXADDPAR, FitsHeader, FUKey,      FUnit, 'converted '+FUnit+' to '+'Jy/pixel'+' by '+STRING(FORMAT='(G0.6)',FConv) ;<Corrected><20150206><DzLIU>; new unit should be Jy/pixel
                FXADDPAR, FitsHeader, FUKey, 'Jy/pixel', 'converted '+FUnit+' to '+'Jy/pixel'+' by '+STRING(FORMAT='(G0.6)',FConv) ;<Corrected><20150206><DzLIU>; new unit should be Jy/pixel
               ;PRINT,    FitsHeader ;<TODO><DEBUG>#
                IF NOT KEYWORD_SET(Silence) THEN MESSAGE, /CONTINUE, 'Converted '+FUKey+' '+FUnit+' to '+'Jy/pixel'+' by '+STRING(FORMAT='(G0.6)',FConv)+' using beam area '+STRING(FORMAT='(G0.6)',PSFBeamArea)
            ENDIF
            IF STRMATCH(FUnit,'Jy/pixel',/FOLD_CASE) THEN BEGIN
                IF NOT KEYWORD_SET(Silence) THEN MESSAGE, /CONTINUE, 'Confirmed '+FUKey+'='+FUnit
            ENDIF
        ENDIF
    ENDIF
    
    
        
    ; Return
    RETURN, FitsImage
    
END
