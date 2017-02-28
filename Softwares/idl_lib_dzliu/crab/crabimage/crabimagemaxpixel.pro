; 
; Please refer to crabimagestat.pro
; 
FUNCTION CrabImageMaxPixel, GalaxyImage, MaxValue=MaxValue, MaxPosIJ=MaxPosIJ, NoCheck=NoCheck
    DenanImage = GalaxyImage
    TempId = WHERE(~FINITE(DenanImage),/NULL)
    IF N_ELEMENTS(TempId) GT 0 THEN DenanImage[TempId]=MIN(DenanImage,/NAN) ; 0.d
    MaxValue = MAX(DenanImage,/NAN)
    MaxId = WHERE(DenanImage EQ MaxValue,/NULL)
    MaxPosIJ = MAKE_ARRAY(N_ELEMENTS(MaxId)*2)
    TempId = INDGEN(N_ELEMENTS(MaxId))
    MaxPosIJ[TempId*2+0] = LONG( MaxId MOD ((SIZE(DenanImage,/DIM))[0]) )
    MaxPosIJ[TempId*2+1] = LONG( MaxId  /  ((SIZE(DenanImage,/DIM))[0]) )
    RETURN, MaxPosIJ ; MAX(DenanImage,/NAN)
END
