; 
; Please refer to crabimagestat.pro
; 
FUNCTION CrabImageMinPixel, GalaxyImage, MinValue=MinValue, MinPosIJ=MinPosIJ, NoCheck=NoCheck
    DenanImage = GalaxyImage
    TempId = WHERE(~FINITE(DenanImage),/NULL)
    IF N_ELEMENTS(TempId) GT 0 THEN DenanImage[TempId]=MAX(DenanImage,/NAN) ; 0.d
    MinValue = MIN(DenanImage,/NAN)
    MinId = WHERE(DenanImage EQ MinValue,/NULL)
    MinPosIJ = MAKE_ARRAY(N_ELEMENTS(MinId)*2)
    TempId = INDGEN(N_ELEMENTS(MinId))
    MinPosIJ[TempId*2+0] = LONG( MinId MOD ((SIZE(DenanImage,/DIM))[0]) )
    MinPosIJ[TempId*2+1] = LONG( MinId  /  ((SIZE(DenanImage,/DIM))[0]) )
    RETURN, MinPosIJ ; MIN(DenanImage,/NAN)
END
