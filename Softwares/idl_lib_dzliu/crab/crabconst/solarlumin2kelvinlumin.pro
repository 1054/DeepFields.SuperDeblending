; 
; 
; 
FUNCTION SolarLumin2KelvinLumin, SolarLumin, LineName=LineName, Redshift=Redshift
    
    
    IF N_ELEMENTS(LineName) EQ 0 THEN RETURN, []
    
    
    KelvinLumin = 0.0D
    
    CleanLineName = CrabStringClean(LineName,TextsToRemove=['(',')',' '])
    IF STRMATCH(CleanLineName,'CO1-0*',/F) THEN BEGIN
        KelvinLumin = DOUBLE(SolarLumin) / 0.000048728372
    ENDIF
    IF STRMATCH(CleanLineName,'CO2-1*',/F) THEN BEGIN
        KelvinLumin = DOUBLE(SolarLumin) / 0.00038980460
    ENDIF
    IF STRMATCH(CleanLineName,'CO3-2*',/F) THEN BEGIN
        KelvinLumin = DOUBLE(SolarLumin) / 0.0013154650
    ENDIF
    IF STRMATCH(CleanLineName,'CO4-3*',/F) THEN BEGIN
        KelvinLumin = DOUBLE(SolarLumin) / 0.0031177223
    ENDIF
    IF STRMATCH(CleanLineName,'CO5-4*',/F) THEN BEGIN
        KelvinLumin = DOUBLE(SolarLumin) / 0.0060882548
    ENDIF
    IF STRMATCH(CleanLineName,'CO6-5*',/F) THEN BEGIN
        KelvinLumin = DOUBLE(SolarLumin) / 0.01051829
    ENDIF
    IF STRMATCH(CleanLineName,'CO7-6*',/F) THEN BEGIN
        KelvinLumin = DOUBLE(SolarLumin) / 3.1814084D-11 / (806.6518060)^3
    ENDIF
    IF STRMATCH(CleanLineName,'CO8-7*',/F) THEN BEGIN
        KelvinLumin = DOUBLE(SolarLumin) / 3.1814084D-11 / (921.7997000)^3
    ENDIF
    IF STRMATCH(CleanLineName,'CO9-8*',/F) THEN BEGIN
        KelvinLumin = DOUBLE(SolarLumin) / 3.1814084D-11 / (1036.9123930)^3
    ENDIF
    IF STRMATCH(CleanLineName,'CO10-9*',/F) THEN BEGIN
        KelvinLumin = DOUBLE(SolarLumin) / 3.1814084D-11 / (1151.9854520)^3
    ENDIF
    IF STRMATCH(CleanLineName,'CO11-10*',/F) THEN BEGIN
        KelvinLumin = DOUBLE(SolarLumin) / 3.1814084D-11 / (1267.0144860)^3
    ENDIF
    IF STRMATCH(CleanLineName,'CO12-11*',/F) THEN BEGIN
        KelvinLumin = DOUBLE(SolarLumin) / 3.1814084D-11 / (1381.9951050)^3
    ENDIF
    ; see https://159.226.71.207:8901/Wiki/doku.php?id=k_km_s-1_pc2_to_luminosity
    
    
    IF N_ELEMENTS(Redshift) EQ 1 AND KelvinLumin NE 0.0 THEN BEGIN
        KelvinLumin = KelvinLumin / (1.0d  + DOUBLE(Redshift))
    ENDIF
    
    
    RETURN, KelvinLumin
    
END