PRO CrabImageMaskRMS, InputFitsFile, InputThresholdValue, InputMaskValue, OutputFitsFile, Extension=Extension
    
    ; 
    IF N_ELEMENTS(InputFitsFile) EQ 0 THEN BEGIN
        PRINT, "CrabImageMaskRMS: InputFitsFile, OutputFitsFile, Extension=Extension"
        PRINT, "CrabImageMaskRMS: This code will read one rms image and mask all pixels that"
        PRINT, "CrabImageMaskRMS: have pixel value greater or equal the InputThresholdValue "
        PRINT, "CrabImageMaskRMS: with the InputMaskValue and finally save as OutputFitsFile"
        RETURN
    ENDIF
    
    ;
    IF N_ELEMENTS(Extension) EQ 0 THEN Extension=0
    FitsImage = MRDFITS(InputFitsFile,Extension,FitsHeader)
    FitsIndex_MaskPixel = WHERE(FitsImage GT InputThresholdValue,/NULL)
    IF N_ELEMENTS(FitsIndex_MaskPixel) GT 0 THEN BEGIN
        FitsImage[FitsIndex_MaskPixel] = InputMaskValue ; InputThresholdValue
    ENDIF
    
    ; additionally we exam all isolated pixels
    NAXIS = SIZE(FitsImage,/DIM)
    NAXIS1 = NAXIS[0] & NAXIS2 = NAXIS[1]
    ; 13 23 33
    ; 12 22 32
    ; 11 21 31
    FitsImage_12 = FitsImage*0.0+InputMaskValue ; left   x-1
    FitsImage_32 = FitsImage*0.0+InputMaskValue ; right  x+1
    FitsImage_21 = FitsImage*0.0+InputMaskValue ; bottom y-1
    FitsImage_23 = FitsImage*0.0+InputMaskValue ; top    y+1
    FitsImage_12[1:NAXIS1-1,0:NAXIS2-1] = FitsImage[0:NAXIS1-2,0:NAXIS2-1] ; left pixel value array
    FitsImage_32[0:NAXIS1-2,0:NAXIS2-1] = FitsImage[1:NAXIS1-1,0:NAXIS2-1] ; right pixel value array
    FitsImage_21[0:NAXIS1-1,1:NAXIS2-1] = FitsImage[0:NAXIS1-1,0:NAXIS2-2] ; bottom pixel value array
    FitsImage_23[0:NAXIS1-1,0:NAXIS2-2] = FitsImage[0:NAXIS1-1,1:NAXIS2-1] ; top pixel value array
    FitsImage_MeanBound = (FitsImage_12+FitsImage_32+FitsImage_21+FitsImage_23)/4.0
    FitsIndex_MeanBound = WHERE(FitsImage_MeanBound EQ InputMaskValue,/NULL)
    IF N_ELEMENTS(FitsIndex_MeanBound) GT 0 THEN BEGIN
        FitsImage[FitsIndex_MeanBound] = InputMaskValue ; Findout isolated good pixel and mask it also
    ENDIF
    
    MWRFITS, FitsImage, OutputFitsFile, FitsHeader, /CREATE
    
    PRINT, "CrabImageMaskRMS: Successfully saved to "+OutputFitsFile

END
