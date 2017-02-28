; 
; Please refer to CrabTelescope.pro
; 


    
FUNCTION RecognizePSFGaussian, FitsFilePath
    PosGauss = -1
    PSFSize  = 0.D   ;;; <TODO> two-dimension gaussian??
    StrGauss = ''
    FitsFileName = FILE_BASENAME(FitsFilePath, '.fits')
    IF PosGauss EQ -1 THEN StrGauss = '_Gaussian_'
    IF PosGauss EQ -1 THEN PosGauss = STRPOS(FitsFileName, StrGauss)
    IF PosGauss EQ -1 THEN StrGauss = '_Gauss_'
    IF PosGauss EQ -1 THEN PosGauss = STRPOS(FitsFileName, '_Gauss_')
    IF PosGauss EQ -1 THEN RETURN, ""
    PosStart = PosGauss+STRLEN(StrGauss)
    PosEnd = STRPOS(FitsFileName, '_', PosStart)
    IF PosEnd   NE -1 THEN PosEnd = PosEnd - PosStart
    PSFText = STRMID(FitsFileName, PosGauss+STRLEN(StrGauss), PosEnd)
    PSFSize = Double(PSFText)
    RETURN, PSFSize
END