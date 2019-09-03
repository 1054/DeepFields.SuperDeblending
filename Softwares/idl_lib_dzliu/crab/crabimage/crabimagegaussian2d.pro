FUNCTION CrabImageGaussian2D, FWHM=INPUT_FWHM, NPIXEL=INPUT_NPIXEL, PA=INPUT_PA, CENTEROID=INPUT_CENTEROID, XArray=INPUT_X, YArray=INPUT_Y, LOG10GAUSSIAN=LOG10GAUSSIAN
    ; Check input args
    IF N_ELEMENTS(INPUT_FWHM) EQ 1 THEN FWHM = [INPUT_FWHM[0], INPUT_FWHM[0]] ELSE FWHM = INPUT_FWHM
    IF N_ELEMENTS(INPUT_NPIXEL) EQ 1 THEN NPIXEL = [INPUT_NPIXEL[0], INPUT_NPIXEL[0]] ELSE NPIXEL = INPUT_NPIXEL
    IF N_ELEMENTS(INPUT_PA) EQ 0 THEN PA = 0.0 ELSE PA = INPUT_PA
    IF N_ELEMENTS(FWHM) GE 2 AND $
       N_ELEMENTS(NPIXEL) GE 2 AND $
       N_ELEMENTS(PA) GE 1 THEN BEGIN
        
        ; referenece: https://www.harrisgeospatial.com/docs/gauss2dfit.html
        
        ; Define a,b axis
        nx = FIX(NPIXEL[0]) ; 301L
        ny = FIX(NPIXEL[1]) ; 301L
        
        ; Create 2D coordinate array
        X = FINDGEN(nx) # REPLICATE(1.0, ny)
        Y = REPLICATE(1.0, nx) # FINDGEN(ny)
        
        ; Define input function parameters:
        aFWHM = DOUBLE(FWHM[0]) ; 30.0
        bFWHM = DOUBLE(FWHM[1]) ; 20.0
        aAxis = aFWHM / (2.0D*sqrt(2.0*alog(2.0)))
        bAxis = bFWHM / (2.0D*sqrt(2.0*alog(2.0)))
        ;PA = 30.0
        h = 0.5D*nx ; centeroid offset
        k = 0.5D*ny ; centeroid offset
        IF N_ELEMENTS(CENTEROID) GE 2 THEN BEGIN
            h = CENTEROID[0]
            k = CENTEROID[1]
        ENDIF
        tilt = (-90.0-DOUBLE(PA[0])) ; tilt values: +X = 0, +Y = -90, ... (clock-wise direction)
        IF tilt LT -90.0 THEN BEGIN
            tilt = tilt + 180.0
        ENDIF
        tilt = tilt/180.0*!PI
        A = [ 0.0D, 1.0D, aAxis, bAxis, h, k, tilt] ; bias, normalization, a, b, h, k, PA
        
        ; Create an ellipse:
        xprime = DOUBLE(X - h) * cos(tilt) - DOUBLE(Y - k) * sin(tilt)
        yprime = DOUBLE(X - h) * sin(tilt) + DOUBLE(Y - k) * cos(tilt)
        U = (xprime/aAxis)^2 + (yprime/bAxis)^2
        
        ; Create gaussian Z:
        Zideal = A[0] + A[1] * EXP(-U/2.0D)
        Z = Zideal
        
        LOG10GAUSSIAN = ALOG10(A[1]) + (-U/2.0D)*ALOG10(EXP(1.0D))
        
        ; Return
        RETURN, Z
    ENDIF
    RETURN, !NULL
END


FUNCTION create_Gaussian_2D, FWHM=FWHM, NPIXEL=NPIXEL, PA=PA, CENTEROID=CENTEROID, XArray=X, YArray=Y
    RETURN, CrabImageGaussian2D(FWHM=FWHM, NPIXEL=NPIXEL, PA=PA, CENTEROID=CENTEROID, XArray=X, YArray=Y)
END


