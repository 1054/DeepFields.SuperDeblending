; 
; Please refer to CrabTelescope.pro
; 



PRO CrabTelescopeRecognize, FitsFilePath, Telescope=Telescope, Instrument=Instrument, Filter=Filter, $
                                          Wavelength=Wavelength, Frequency=Frequency, PSF=PSF
    IF SIZE(FitsFilePath,/TYPE) NE 7 THEN BEGIN
        PRINT, 'CrabTelescopeRecognize: FitsFilePath is the path to the fits file.'
        RETURN
    ENDIF
    NameFilters  = ['_photo','_phot','_ch','-','_',',','.',' ']
    FitsFileName = FILE_BASENAME(FitsFilePath)
    DataFileName = CrabStringCleaning(FitsFileName, NameFilters) ; search file name first
    DataFilePath = CrabStringCleaning(FitsFilePath, NameFilters) ; then search file path second
    Telescope    = ""
    Instrument   = ""
    Filter       = ""
    Wavelength   = 0.0D
    Frequency    = 0.0D
    PSF          = 0.0D
    PSFGauss     = 0.0D   ;;; some photos were convolved to certain gaussian psf. 
    FOREACH SearchText, [DataFileName,DataFilePath] DO BEGIN
        IF Telescope  EQ ""  THEN Telescope  = RecognizeTelescope(SearchText)
        IF Instrument EQ ""  THEN Instrument = RecognizeInstrument(SearchText)
        IF Filter     EQ ""  THEN Filter     = RecognizeFilter(SearchText, Wavelength=Wavelength, Frequency=Frequency)
        IF PSFGauss   EQ 0.D THEN PSFGauss   = RecognizePSFGaussian(SearchText)
    ENDFOREACH
    IF PSFGauss EQ 0.D AND Instrument+Filter NE "" THEN BEGIN
        PSF = RecognizePSF(Instrument+Filter)
    ENDIF ELSE PSF = PSFGauss
END