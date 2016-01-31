; 
; Please refer to CrabTelescope.pro
; 


    
FUNCTION CrabTelescopeFindFits, FitsFileDir, FitsPhotoType, Pattern=Pattern
    ; find fits photos under certain directory, which corresponds to some FitsPhotoType
    FoundFits = []
    CInstru = RecognizeInstrument(FitsPhotoType)
    CFilter = RecognizeFilter(FitsPhotoType)
    ; additional name pattern
    IF N_ELEMENTS(Pattern) EQ 1 AND SIZE(Pattern,/TNAME) EQ 'STRING' THEN BEGIN
        AddPattern = Pattern
        IF NOT STRMATCH(AddPattern,'\**') THEN AddPattern='*'+AddPattern
        IF NOT STRMATCH(AddPattern,'*\*') THEN AddPattern=AddPattern+'*'
    ENDIF
    ; PRINT, CInstru+CFilter
    IF CInstru NE '' AND CFilter NE '' AND FILE_TEST(FitsFileDir) THEN BEGIN
        AllSubFiles = FILE_SEARCH(FitsFileDir,'*.fits')
        IF N_ELEMENTS(AllSubFiles) GT 0 THEN BEGIN
            FOREACH OneSubFile, AllSubFiles DO BEGIN
                IF OneSubFile NE '' THEN BEGIN
                    OneSubName = FILE_BASENAME(OneSubFile)
                    OneInstru = RecognizeInstrument(OneSubName)
                    OneFilter = RecognizeFilter(OneSubName)
                    IF CInstru EQ OneInstru AND CFilter EQ OneFilter THEN BEGIN
                        IF N_ELEMENTS(AddPattern) EQ 1 THEN BEGIN
                            IF NOT STRMATCH(OneSubName,AddPattern,/F) THEN CONTINUE 
                        ENDIF
                        FoundFits = [FoundFits, OneSubFile]
                    ENDIF
                ENDIF
            ENDFOREACH
        ENDIF
    ENDIF
    RETURN, FoundFits
END
