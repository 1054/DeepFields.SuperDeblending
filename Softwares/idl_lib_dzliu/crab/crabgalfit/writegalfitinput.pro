

PRO writeGalfitInput, INPUT_File, OUT_Fits, SCI_Fits, RMS_Fits, PSF_Fits, Pix_X, Pix_Y, Pix_Mag, Pix_Flag, $
                                  Constraints=Constraints, FittingRegion=FittingRegion, ConvolveBox=ConvolveBox, MagZeroPoint=MagZeroPoint, $
                                  PlateScale=PlateScale,   MagStartValue=MagStartValue, Vary_X=Vary_X, Vary_Y=Vary_Y, Vary_Mag=Vary_Mag, $
                                  Sky=Sky
    
    IF FILE_TEST(SCI_Fits) EQ 0 THEN MESSAGE, 'writeGalfitInput: Error! Input SCI_Fits is invalid!'
    SCI_Image = MRDFITS(SCI_Fits,0,SCI_Header,/Silent)
    SCI_NAXIS = SIZE(SCI_Image,/DIM)
    
    IF N_ELEMENTS(Constraints)   EQ 0 THEN Constraints = ""
    IF N_ELEMENTS(FittingRegion) EQ 0 THEN FittingRegion = [1,SCI_NAXIS[0],1,SCI_NAXIS[1]] 
                                   ; <TODO> Strange! When input [0,NAXIS1-1,0,NAXIS2-1], lower-left (x,y) (ra,dec) are good, 
                                   ; but upper-right missed 1 row 1 column of pixels!
                                   ; Thus here we must set [0,NAXIS1,0,NAXIS2]  
    IF N_ELEMENTS(ConvolveBox)   EQ 0 THEN ConvolveBox = [80,80]
    IF N_ELEMENTS(MagZeroPoint)  EQ 0 THEN MagZeroPoint = 0.0
    IF N_ELEMENTS(MagStartValue) EQ 0 THEN MagStartValue = 10.0
    IF N_ELEMENTS(PlateScale)    EQ 0 THEN PlateScale = [0.06,0.06]
    IF N_ELEMENTS(Sky)           EQ 0 THEN Sky = 0.0
    
    IF N_ELEMENTS(Pix_X) EQ 0 OR N_ELEMENTS(Pix_Y) EQ 0 THEN MESSAGE, 'writeGalfitInput: Error! Invalid Pix_X or Pix_Y!'
    IF N_ELEMENTS(Pix_X) NE N_ELEMENTS(Pix_Y) THEN MESSAGE, 'writeGalfitInput: Error! Invalid Pix_X or Pix_Y!'
    
    IF N_ELEMENTS(Pix_Mag)  EQ 0 THEN Pix_Mag=REPLICATE(MagStartValue,N_ELEMENTS(Pix_X))
    IF N_ELEMENTS(Pix_Flag) EQ 0 THEN Pix_Flag=REPLICATE(0,N_ELEMENTS(Pix_X)) ; Flag 1 means fit but not save into output image
    
    IF N_ELEMENTS(Vary_X)        EQ 0 THEN Vary_X   = REPLICATE(1,N_ELEMENTS(Pix_X))
    IF N_ELEMENTS(Vary_Y)        EQ 0 THEN Vary_Y   = REPLICATE(1,N_ELEMENTS(Pix_X))
    IF N_ELEMENTS(Vary_Mag)      EQ 0 THEN Vary_Mag = REPLICATE(1,N_ELEMENTS(Pix_X))
    IF N_ELEMENTS(Vary_X)        EQ 1 THEN Vary_X   = REPLICATE(Vary_X[0],N_ELEMENTS(Pix_X))
    IF N_ELEMENTS(Vary_Y)        EQ 1 THEN Vary_Y   = REPLICATE(Vary_Y[0],N_ELEMENTS(Pix_X))
    IF N_ELEMENTS(Vary_Mag)      EQ 1 THEN Vary_Mag = REPLICATE(Vary_Mag[0],N_ELEMENTS(Pix_X))
    
    OPENW, FileUnit, INPUT_File, /GET_LUN
    PRINTF, FileUnit, 'A) '+STRTRIM(SCI_Fits,2)
    PRINTF, FileUnit, 'B) '+STRTRIM(OUT_Fits,2)
    PRINTF, FileUnit, 'C) '+STRTRIM(RMS_Fits,2)
    PRINTF, FileUnit, 'D) '+STRTRIM(PSF_Fits,2)
    PRINTF, FileUnit, 'E) 1'                       ; PSF Fine-Sampling Factor
    PRINTF, FileUnit, 'F) none'                    ; Bad Pixel Mask
    PRINTF, FileUnit, 'G) '+STRTRIM(Constraints,2) ; Parameter Coupling CONSTRAINTS
    PRINTF, FileUnit, 'H) '+STRING(FORMAT='(I0," ",I0," ",I0," ",I0)',$ ; Fitting Region
       FittingRegion[0],FittingRegion[1],FittingRegion[2],FittingRegion[3])
    PRINTF, FileUnit, 'I) '+STRING(FORMAT='(I0," ",I0)',ConvolveBox)  ; Convolution Box Size
    PRINTF, FileUnit, 'J) '+STRING(FORMAT='(F0.2)',MagZeroPoint)    ; Magnitude Zeropoint
    PRINTF, FileUnit, 'K) '+STRING(FORMAT='(F0.3," ",F0.3)',$       ; Plate Scale (arcsec) only for King and the Nuker profiles
       PlateScale[0],PlateScale[1]) 
    PRINTF, FileUnit, 'O) regular'  ; Interaction Window
    PRINTF, FileUnit, 'P) 0'  ; Options: 0 for normal
    PRINTF, FileUnit, ''
    PRINTF, FileUnit, ''
    FOR i=0,N_ELEMENTS(Pix_X)-1 DO BEGIN
        PRINTF, FileUnit, '0) psf'
        PRINTF, FileUnit, '1) '+STRING(FORMAT='(F0.3," ",F0.3," ",I0," ",I0)',Pix_X[i],Pix_Y[i],Vary_X[i],Vary_Y[i])
        PRINTF, FileUnit, '3) '+STRING(FORMAT='(F0.3," ",I0)',Pix_Mag[i],Vary_Mag[i])
        PRINTF, FileUnit, 'Z) 0'
        PRINTF, FileUnit, ''
        PRINTF, FileUnit, ''
    ENDFOR
    PRINTF, FileUnit, '0) sky'
    PRINTF, FileUnit, '1) '+STRING(FORMAT='(F0.3," ",I0)',Sky,0)
    PRINTF, FileUnit, '2) 0 0'
    PRINTF, FileUnit, '3) 0 0'
    PRINTF, FileUnit, 'Z) 0'
    PRINTF, FileUnit, ''
    PRINTF, FileUnit, ''
    CLOSE,  FileUnit
    FREE_LUN, FileUnit
END