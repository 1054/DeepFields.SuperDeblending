FUNCTION CrabImageCrop, InputFitsOrImage, NewSize, Extension=Extension, CornerXY=CornerXY, CornerIJ=CornerIJ, CentreXY=CentreXY, $
                                                   ShiftedXY=ShiftedXY, FractionalXY=FractiXY, NAXIS=NAXIS, $
                                                   Odd=Odd, Even=Even, FITSHeader=FITSHeader, $
                                                   PadNaN=PadNaN, PadZero=PadZero, PadNoise=PadNoise, NoiseLevel=NoiseLevel, $
                                                   Debug=Debug, Verbose=Verbose, Status=FitsOK
; 
; Cut or pad the InputImage to the new size NewSize. 
; 
; Only integer NewSize allowed! Only integer CentreXY allowed!
; 
; When the input NewSize has even numbers, the even number will minus 1 to be an odd number!
; 
; If the InputImage is smaller than the NewSize, then we will pad the new image with NaN value. 
; If the InputImage is larger than the NewSize, then we will cut the input image to make the new image. 
; Note that both padding and cutting can be performed simutaneously. 
; E.g. CentreXY is close to the left edge of the InputImage, and far from the right edge, and NewSize is large, 
;      then we will pad the left and cut the right of the InputImage, and return the new image. 
; 
; If an CentreXY is given, then use it as the centre of the new image. 
; 
; CornerIJ is i1:i2 j1:j2
; 
; 
; Updated: 
;   2014-06-13 Add new param CornerXY
; 
    
    
    
    IF KEYWORD_SET(Verbose) THEN Silent=!NULL ELSE Silent=1
    
    
    ; 
    ; Prepare the Crop/Cut
    ; 
    ; 2 situations: 
    ;   (1) set CornerXY = [x1,x2,y1,y2]
    ;   (2) set CentreXY = [xc,yc] and NewSize=[w,h]
    ; 
    IF N_ELEMENTS(CornerIJ) GT 0 THEN BEGIN ; CornerIJ has the highest priority
        ; IF SET CornerIJ (int)
        IF N_ELEMENTS(CornerIJ) NE 4 THEN BEGIN
            MESSAGE, "The input CornerXY should contain 4 items: x1,x2,y1,y2, in physical coordinate, with number starting from 1."
        ENDIF ELSE BEGIN
            ; swap if input range is inversed ; -- modified since 20160723
            IF CornerIJ[0] GT CornerIJ[1] THEN BEGIN
                TempI = CornerIJ[0]
                CornerIJ[0] = CornerIJ[1]
                CornerIJ[1] = TempI
            ENDIF
            IF CornerIJ[2] GT CornerIJ[3] THEN BEGIN
                TempJ = CornerIJ[2]
                CornerIJ[2] = CornerIJ[3]
                CornerIJ[3] = TempJ
            ENDIF
            ; 
            FractiIJ = DOUBLE(CornerIJ)-ROUND(CornerIJ) ; -- modified since 20160723
            FractiXY = [FractiIJ[0],FractiIJ[2]] ; x1, y1 -- [0.0,0.0] -- modified since 20160723
            CentreXY = [(DOUBLE(CornerIJ[0])+DOUBLE(CornerIJ[1]))/2.0,(DOUBLE(CornerIJ[2])+DOUBLE(CornerIJ[3]))/2.0]
            CornerIJ = ROUND(CornerIJ)
            ; Width_IJ = CornerIJ[1] - CornerIJ[0]
            ; Hight_IJ = CornerIJ[3] - CornerIJ[2]
        ENDELSE
    ENDIF ELSE IF N_ELEMENTS(CornerXY) GT 0 THEN BEGIN ; CornerXY has the second high priority
        ; IF SET CornerXY (float)
        IF N_ELEMENTS(CornerXY) NE 4 THEN BEGIN
            MESSAGE, "The input CornerXY should contain 4 items: x1,x2,y1,y2, in physical coordinate, with number starting from 1."
        ENDIF ELSE BEGIN
            CentreXY = [(DOUBLE(CornerXY[0])+DOUBLE(CornerXY[1]))/2.0,(DOUBLE(CornerXY[2])+DOUBLE(CornerXY[3]))/2.0]
            FractiXY = [DOUBLE(CornerXY[0])-ROUND(CornerXY[0]),DOUBLE(CornerXY[2])-ROUND(CornerXY[2])]
            CornerIJ = [ROUND(CornerXY[0]-1-FractiXY[0]),ROUND(CornerXY[1]-1-FractiXY[0]),ROUND(CornerXY[2]-1-FractiXY[1]),ROUND(CornerXY[3]-1-FractiXY[1])]
            ; Width_IJ = CornerIJ[1] - CornerIJ[0]
            ; Hight_IJ = CornerIJ[3] - CornerIJ[2]
        ENDELSE
    ENDIF ELSE IF N_ELEMENTS(CentreXY) GT 0 THEN BEGIN
        ; IF SET CentreXY (float) AND NewSize (float)
        IF N_ELEMENTS(CentreXY) NE 2 THEN BEGIN
            MESSAGE, "The input CentreXY should contain 2 items: xc,yc, in physical coordinate, with number starting from 1."
        ENDIF ELSE IF N_ELEMENTS(NewSize) NE 2 THEN BEGIN
            MESSAGE, "The input NewSize should contain 2 items: [width,height], in unit of pixel."
        ENDIF ELSE BEGIN
            ; make odd or even
            Sides_IJ = ROUND(NewSize)
            IF KEYWORD_SET(Odd) AND Sides_IJ[0] MOD 2 EQ 0 THEN Sides_IJ[0] = Sides_IJ[0]-1
            IF KEYWORD_SET(Odd) AND Sides_IJ[1] MOD 2 EQ 0 THEN Sides_IJ[1] = Sides_IJ[1]-1
            IF KEYWORD_SET(Even) AND Sides_IJ[0] MOD 2 EQ 1 THEN Sides_IJ[0] = Sides_IJ[0]-1
            IF KEYWORD_SET(Even) AND Sides_IJ[1] MOD 2 EQ 1 THEN Sides_IJ[1] = Sides_IJ[1]-1
            RadiusXY = (DOUBLE(Sides_IJ)-1.0)/2.0
            CornerXY = [DOUBLE(CentreXY[0])-RadiusXY[0],DOUBLE(CentreXY[0])+RadiusXY[0],$
                        DOUBLE(CentreXY[1])-RadiusXY[1],DOUBLE(CentreXY[1])+RadiusXY[1]]
            FractiXY = [DOUBLE(CentreXY[0])-(CornerXY[0]+CornerXY[1])/2.0,DOUBLE(CentreXY[1])-(CornerXY[2]+CornerXY[3])/2.0]
            CornerIJ = ROUND(CornerXY)-1
            ; Width_IJ = CornerIJ[1] - CornerIJ[0]
            ; Hight_IJ = CornerIJ[3] - CornerIJ[2]
        ENDELSE
    ENDIF ELSE BEGIN
        PRINT, 'Usage: '
        PRINT, '    CrabImageCrop, InputFitsOrImage, NewSize, Extension=Extension, CornerXY=CornerXY, CentreXY=CentreXY'
        MESSAGE, 'Invalid input, sorry. '
    ENDELSE
    
    IF KEYWORD_SET(DEBUG) THEN PRINT, "DEBUG: CornerIJ = ", CornerIJ
    IF KEYWORD_SET(DEBUG) THEN PRINT, "DEBUG: CornerXY = ", CornerXY
    IF KEYWORD_SET(DEBUG) THEN PRINT, "DEBUG: CentreXY = ", CentreXY
    
    
    ; Corners might be outside of image
    
    
    ; Mapping from old coordinate to new coordinate
    LX = CornerIJ[0]
    UX = CornerIJ[1]
    LY = CornerIJ[2]
    UY = CornerIJ[3]
    SX = CornerIJ[1]-CornerIJ[0]+1
    SY = CornerIJ[3]-CornerIJ[2]+1
    
    ; <Corrected><20150603><dzliu>
    ; If the selected range is all negative
    IF LX LT  0 AND UX LT  0 THEN RETURN, MAKE_ARRAY(SX,SY,/DOUBLE,VALUE=0.0D)
    IF LY LT  0 AND UY LT  0 THEN RETURN, MAKE_ARRAY(SX,SY,/DOUBLE,VALUE=0.0D)
    ; IF LX GT NX AND UX GT NX THEN RETURN, MAKE_ARRAY(SX,SY,/DOUBLE,VALUE=0.0D)
    ; IF LY GT NY AND UY GT NY THEN RETURN, MAKE_ARRAY(SX,SY,/DOUBLE,VALUE=0.0D)
    
    
    IF LX LT  0 THEN LEX = -LX     ELSE LEX = 0 ; Lower Excess X
    IF LY LT  0 THEN LEY = -LY     ELSE LEY = 0 ; Lower Excess Y
    ; IF UX GE NX THEN UEX = UX-NX+1 ELSE UEX = 0 ; Upper Excess X
    ; IF UY GE NY THEN UEY = UY-NY+1 ELSE UEY = 0 ; Upper Excess Y
    
    
    
    IF SIZE(InputFitsOrImage,/TNAME) EQ "STRING" THEN BEGIN
        ; 
        ; Prepare to read fits 
        ; Note that we need to check whether filename contains extension
        IF NOT KEYWORD_SET(Extension) THEN BEGIN
            IF STRMATCH(InputFitsOrImage,"*.fits*\[*\]*",/FOLD_CASE) THEN BEGIN
                InputFitsFileName = STRMID(InputFitsOrImage,0,STRPOS(STRLOWCASE(InputFitsOrImage),".fits")+4)
                InputFitsRemainStr = STRMID(InputFitsOrImage,STRPOS(STRLOWCASE(InputFitsOrImage),".fits")+5)
                InputFitsFoundPos1 = STRPOS(InputFitsRemainStr,"[")
                InputFitsFoundPos2 = STRPOS(InputFitsRemainStr,"]")
                InputFitsExtension = STRMID(InputFitsRemainStr,InputFitsFoundPos1+1,InputFitsFoundPos2-InputFitsFoundPos1-1)
                InputFitsExtension = FIX(InputFitsExtension)
            ENDIF ELSE BEGIN
                InputFitsFileName = InputFitsOrImage
                InputFitsExtension = 0
            ENDELSE
        ENDIF
        ; 
        IF FILE_TEST(InputFitsFileName) THEN BEGIN
            ; Read fits header first
            InputFitsHeader = HeadFits(InputFitsFileName,Exten=InputFitsExtension)
            NX = FXPAR(InputFitsHeader,'NAXIS1')
            NY = FXPAR(InputFitsHeader,'NAXIS2')
            ; Now read fits
            ; Note that we need to decide whether to cut Y range when reading the fits
            IF LX GE NX THEN RETURN, []
            IF LY GE NY THEN RETURN, []
            IF LX LT  0 THEN LEX = -LX     ELSE LEX = 0 ; Lower Excess X
            IF LY LT  0 THEN LEY = -LY     ELSE LEY = 0 ; Lower Excess Y
            IF UX GE NX THEN UEX = UX-NX+1 ELSE UEX = 0 ; Upper Excess X
            IF UY GE NY THEN UEY = UY-NY+1 ELSE UEY = 0 ; Upper Excess Y
            InputImage = MRDFITS(InputFitsFileName,InputFitsExtension,InputFitsHeader,RANGE=[(LY+LEY),(UY-UEY)],Status=FitsOK,Silent=Silent)
           ;<added><20150625><dzliu>; fix problem, check (SIZE(InputImage,/DIM))[1]
            IF (SIZE(InputImage,/DIM))[1] EQ (UY-UEY)-(LY+LEY)+1 THEN BEGIN
            InUseImage = InputImage[(LX+LEX):(UX-UEX),*] & ENDIF ELSE BEGIN
            InUseImage = InputImage[(LX+LEX):(UX-UEX), (LY+LEY):(UY-UEY)] & ENDELSE ; apply yrange in MRDFITS now
            FITSHeader = InputFitsHeader
        ENDIF ELSE BEGIN
            MESSAGE, 'CrabImageCrop: Read fits error! Please check '+InputFitsFileName
            RETURN, []
        ENDELSE
    ENDIF ELSE BEGIN
        InputImage = InputFitsOrImage
        IF SIZE(InputImage,/N_DIM) EQ 2 THEN BEGIN
            NX = (SIZE(InputImage,/DIM))[0]
            NY = (SIZE(InputImage,/DIM))[1]
            IF LX LT  0 THEN LEX = -LX     ELSE LEX = 0 ; Lower Excess X
            IF LY LT  0 THEN LEY = -LY     ELSE LEY = 0 ; Lower Excess Y
            IF UX GE NX THEN UEX = UX-NX+1 ELSE UEX = 0 ; Upper Excess X
            IF UY GE NY THEN UEY = UY-NY+1 ELSE UEY = 0 ; Upper Excess Y
            ;<DEBUG>;PRINT, STRING(FORMAT='(I0)',(LX+LEX)),":",STRING(FORMAT='(I0)',(UX-UEX)),",",STRING(FORMAT='(I0)',(LY+LEY)),":",STRING(FORMAT='(I0)',(UY-UEY))," NX=",STRING(FORMAT='(I0)',NX)," NY=",STRING(FORMAT='(I0)',NY)
            InUseImage = InputImage[(LX+LEX):(UX-UEX), (LY+LEY):(UY-UEY)]
        ENDIF ELSE BEGIN
            MESSAGE, 'CrabImageCrop: Read fits error! Please check this!'
            RETURN, []
        ENDELSE
    ENDELSE
    
    
    
    
    ; Output Image
    OutputImage = MAKE_ARRAY(SX,SY,/DOUBLE,VALUE=0.d)
    
    IF KEYWORD_SET(PadNaN) THEN $
    OutputImage = MAKE_ARRAY(SX,SY,/DOUBLE,VALUE=!VALUES.D_NAN)
    
    IF KEYWORD_SET(PadZero) THEN $
    OutputImage = MAKE_ARRAY(SX,SY,/DOUBLE,VALUE=0.d)
    
    ArithmeticException = !Except & !Except = 0
    
    IF KEYWORD_SET(PadNoise) AND N_ELEMENTS(NoiseLevel) EQ 1 THEN BEGIN
        OutputImage = RANDOMN(!PI,SX,SY,/DOUBLE)*NoiseLevel
        ; Copying image from input to output (when adding noise)
        OutputImage[(LEX):(SX-1-UEX),(LEY):(SY-1-UEY)] = $
        OutputImage[(LEX):(SX-1-UEX),(LEY):(SY-1-UEY)] + InUseImage[*,*]
    ENDIF ELSE BEGIN
        ; Copying image from input to output (when padding zero)
        OutputImage[(LEX):(SX-1-UEX),(LEY):(SY-1-UEY)] = InUseImage[*,*]
    ENDELSE
    
    ArithmeticError = check_math(MASK=32) & !Except = ArithmeticException ; Clear floating underflow
    
    
    ;;; ShiftedXY from InputImage(m,n) => OutputImage(i,j) is
    ;;; ShiftedXY = [double(-IndexOfLeftX),double(-IndexOfLeftY)]
    ShiftedXY = [DOUBLE(LX+LEX),DOUBLE(LY+LEY)]
    NAXIS = [SX,SY]
    
    IF N_ELEMENTS(FITSHeader) EQ 0 AND N_ELEMENTS(InputFitsHeader) GT 0 THEN FITSHeader = InputFitsHeader
    IF N_ELEMENTS(FITSHeader) GE 1 AND SIZE(FITSHeader,/TNAME) EQ "STRING" THEN BEGIN
        IF SXPAR(FITSHeader,'CRPIX1') NE "" AND SXPAR(FITSHeader,'CRPIX2') NE "" THEN BEGIN
            CRPIX1 = DOUBLE(SXPAR(FITSHeader,'CRPIX1'))
            CRPIX2 = DOUBLE(SXPAR(FITSHeader,'CRPIX2'))
            SXADDPAR, FITSHeader, 'NAXIS1', SX
            SXADDPAR, FITSHeader, 'NAXIS2', SY
            SXADDPAR, FITSHeader, 'CRPIX1', CRPIX1-ShiftedXY[0]
            SXADDPAR, FITSHeader, 'CRPIX2', CRPIX2-ShiftedXY[1]
;            TODO
        ENDIF 
    ENDIF
    
    
    
    RETURN, OutputImage
    
END



FUNCTION CrabImageCutOrPad, InputImage, NewSize, CentreXY=CentreXY, ShiftedXY=ShiftedXY, $
                            NAXIS=NAXIS, Odd=Odd, Even=Even, $
                            PadNaN=PadNaN, PadZero=PadZero, PadNoise=PadNoise, NoiseLevel=NoiseLevel, Debug=Debug, Verbose=Verbose
 RETURN, CrabImageCrop(     InputImage, NewSize, CentreXY=CentreXY, ShiftedXY=ShiftedXY, $
                            NAXIS=NAXIS, Odd=Odd, Even=Even, $
                            PadNaN=PadNaN, PadZero=PadZero, PadNoise=PadNoise, NoiseLevel=NoiseLevel, Debug=Debug, Verbose=Verbose )
END


FUNCTION CrabCutOrPadImage, InputImage, NewSize, CentreXY=CentreXY, ShiftedXY=ShiftedXY, $
                            NAXIS=NAXIS, Odd=Odd, Even=Even, $
                            PadNaN=PadNaN, PadZero=PadZero, PadNoise=PadNoise, NoiseLevel=NoiseLevel, Debug=Debug, Verbose=Verbose
 RETURN, CrabImageCrop(     InputImage, NewSize, CentreXY=CentreXY, ShiftedXY=ShiftedXY, $
                            NAXIS=NAXIS, Odd=Odd, Even=Even, $
                            PadNaN=PadNaN, PadZero=PadZero, PadNoise=PadNoise, NoiseLevel=NoiseLevel, Debug=Debug, Verbose=Verbose )
END

