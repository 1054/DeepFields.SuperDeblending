; 
; Please refer to CrabTelescope.pro
; 


    
FUNCTION CrabTelescopeRecognizePSF, FitsFilePath
    CrabTelescopeRecognize, FitsFilePath, Telescope=Telescope, Instrument=Instrument, Filter=Filter, $
                                          Wavelength=Wavelength, Frequency=Frequency
    RETURN, RecognizePSF(Instrument+Filter)
END