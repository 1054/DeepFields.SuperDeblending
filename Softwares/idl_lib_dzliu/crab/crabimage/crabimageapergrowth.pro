PRO CrabImageAperGrowth, GalaxyImage, CenterXY
    ; 
    CD, '/Users/dliu/Temp/WFC3-longbowcluster/ibs43a010/gopointspreadfit/'
    SciImage = CrabReadFitsImage('ibs43a010_drz.fits',FitsHeader=FitsHeader,NAXIS=NAXIS)
    
    GalaxyImage = SciImage
    CenterXY = [491,572]
    
    ; 
    IF N_ELEMENTS(GalaxyImage) EQ 0 THEN MESSAGE, 'CrabImageAperGrowth: Error! GalaxyImage is invalid!'
    IF SIZE(GalaxyImage,/N_DIM) NE 2 THEN MESSAGE, 'CrabImageAperGrowth: Error! GalaxyImage should be 2 dimension!'
    NAXIS = SIZE(GalaxyImage,/DIM)
    
    ; Crop image
    CropedSize = [201,201]
    IF NAXIS[0] LT 201 THEN CropedSize[0] = NAXIS[0]
    IF NAXIS[1] LT 201 THEN CropedSize[1] = NAXIS[1]
    CropedImage = CrabImageCrop(GalaxyImage,CropedSize,CentreXY=CenterXY,ShiftedXY=ShiftedXY)
    CropedCenter = Centroid(CropedImage) + 1.0
    CrabImageQuickPlot, CropedImage, TVSCALE=0.1
    CrabImageTVCross, [CropedCenter[0],CropedCenter[1],3.0], ImageSize=CropedSize, CrossColors=['purple']
    CentroidXY = CropedCenter + ShiftedXY
END