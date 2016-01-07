; 
; Please refer to CrabTelescope.pro
; 


    
FUNCTION RecognizeFrequency, SearchText, GHz=GHz
    S_Filter = RecognizeFilter(SearchText, Wavelength=S_Wavelength, Frequency=S_Frequency)
    IF KEYWORD_SET(GHz) THEN S_Frequency=S_Frequency/1D9
    IF S_Filter NE '' THEN RETURN, S_Frequency
    RETURN, !VALUES.D_NAN
END