PRO CrabDeconvolveFitsImage, FitsFile, 
    
    ; <TODO><TEST>
    KernelDir = ''
    KernelFile = '/data/'
    
    FOREACH DataFile, FitsFile DO BEGIN
        IF DataFile EQ "" THEN BEGIN 
            PRINT, 'Warning! '+DataFile+' not found! Skipping!'
            CONTINUE
        ENDIF
        CrabImageDeconvolve()
    ENDFOREACH
    
END