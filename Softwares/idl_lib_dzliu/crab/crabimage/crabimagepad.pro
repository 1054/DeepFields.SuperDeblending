; 
; 
; 
; 
;
; CentreXY is useless. 
; 
FUNCTION CrabImagePad, InputImage, PadLeft=PadLeft, PadRight=PadRight, PadTop=PadTop, PadBottom=PadBottom, $
                                   PadValue=PadValue, CentreXY=CentreXY
    
    
    ; Check Input 
    IF SIZE(InputImage,/N_DIM) NE 2 THEN BEGIN
        PRINT, 'Usage: CrabImagePad, InputImage, PadLeft=PadLeft, PadRight=PadRight, PadTop=PadTop, PadBottom=PadBottom'
        RETURN,[]
    ENDIF
    
    ; Check Input
    IF N_ELEMENTS(PadLeft)   EQ 0 THEN PadLeft   = 0 ELSE PadLeft   = FIX(PadLeft)
    IF N_ELEMENTS(PadRight)  EQ 0 THEN PadRight  = 0 ELSE PadRight  = FIX(PadRight)
    IF N_ELEMENTS(PadTop)    EQ 0 THEN PadTop    = 0 ELSE PadTop    = FIX(PadTop)
    IF N_ELEMENTS(PadBottom) EQ 0 THEN PadBottom = 0 ELSE PadBottom = FIX(PadBottom)
    IF N_ELEMENTS(PadValue)  EQ 0 THEN PadValue  = 0.0D
    
    IF PadLeft EQ 0 AND PadRight EQ 0 AND PadTop EQ 0 AND PadBottom EQ 0 THEN RETURN, InputImage
    
    
    ; Image Size
    InputSize = Size(InputImage,/DIMENSIONS)
    InputWidth = InputSize[0]
    InputHeight = InputSize[1]
    
    
    ; Output Size
    OutputSize = InputSize
    OutputSize[0] += PadLeft + PadRight
    OutputSize[1] += PadTop + PadBottom
    OutputWidth = OutputSize[0]
    OutputHeight = OutputSize[1]
    
    IF OutputSize[0] LE 0 OR OutputSize[1] LE 0 THEN RETURN, []
    
    
    ; 
    I00 = [           0  ,            0   ] ; the left bottom point in input image coordinate
    I11 = [  InputWidth-1,  InputHeight-1 ] ; the right top point in input image coordinate
    O00 = [           0  ,            0   ] ; the left bottom point in output image coordinate
    O11 = [ OutputWidth-1, OutputHeight-1 ] ; the right top point in output image coordinate
    
    ILX =             0 & ILY =              0   ;  Input Image Lower X & Lower Y
    IUX =  InputWidth-1 & IUY =  InputHeight-1   ;  Input Image Upper X & Upper Y
    OLX =             0 & OLY =              0   ; Output Image Lower X & Lower Y
    OUX = OutputWidth-1 & OUY = OutputHeight-1   ; Output Image Upper X & Upper Y
                                                 ; OutputImage[OLX:OUX,OLY:OUY] = InputImage[ILX:IUX,ILY:IUY]
    
    IF PadLeft   GE 0 THEN OLX += PadLeft   ELSE ILX += ABS(PadLeft) 
    IF PadRight  GE 0 THEN OUX -= PadRight  ELSE IUX -= ABS(PadRight)
    IF PadBottom GE 0 THEN OLY += PadBottom ELSE ILY += ABS(PadBottom) 
    IF PadTop    GE 0 THEN OUY -= PadTop    ELSE IUY -= ABS(PadTop)
    ; e.g. PadLeft=+10, ILX=0, OLX=10, OIMG[10:OUX,OLY:OUY]=IIMG[0:IUX,ILY:IUY], add 10 pixels to the left 
    ; e.g. PadLeft=-20, ILX=20, OLX=0, OIMG[0:OUX,OLY:OUY]=IIMG[20:IUX,ILY:IUY], cut 20 pixels from the left 
    
    IF ILX LT 0 OR ILY LT 0 OR OLX LT 0 OR OLY LT 0 THEN RETURN, []
    IF IUX GE  InputWidth OR IUY GE  InputHeight THEN RETURN, []
    IF OUX GE OutputWidth OR OUY GE OutputHeight THEN RETURN, []
    
    OutputImage = MAKE_ARRAY(OutputWidth,OutputHeight,/DOUBLE,VALUE=PadValue)
    OutputImage[OLX:OUX,OLY:OUY] = InputImage[ILX:IUX,ILY:IUY]
    
    RETURN, OutputImage
    
END
    