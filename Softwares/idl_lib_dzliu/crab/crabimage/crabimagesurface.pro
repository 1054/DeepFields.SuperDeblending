PRO CrabImageSurface, GalaxyImage, SkyRadii=SkyRadii
    ; 
    ImageSize = SIZE(GalaxyImage,/DIMENSION)
    DenanImage = GalaxyImage
    DenanImage[WHERE(~FINITE(DenanImage))] = 0.d
    ImageIndex = Indgen(ImageSize[0]*ImageSize[1],/L64)
    CentreX = LONG(ImageSize[0]-1)/2
    CentreY = LONG(ImageSize[1]-1)/2
    ArrayX = Double( ImageIndex mod ImageSize[0] ) - CentreX
    ArrayY = Double( ImageIndex  /  ImageSize[0] ) - CentreY
    ArrayR = SQRT(ArrayX^2+ArrayY^2)
    DisToCent = MAKE_ARRAY(ImageSize[0], ImageSize[1], /INTEGER, VALUE=0)
    DisToCent[ImageIndex] = ArrayR[ImageIndex]
    
    ShrinkImage = DenanImage
    IF N_ELEMENTS(SkyRadii) EQ 2 THEN BEGIN
        ShrinkImage[WHERE(DisToCent LT SkyRadii[0])] = 0.D
        ShrinkImage[WHERE(DisToCent GT SkyRadii[1])] = 0.D
    ENDIF
    
    S = SURFACE(ShrinkImage)
    
END

