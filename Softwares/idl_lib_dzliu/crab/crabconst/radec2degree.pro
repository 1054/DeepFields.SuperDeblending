PRO RADec2Degree, RADecStr, RADecInDegree=RADecDeg, Print=Print, DEBUG=DEBUG, ConvertToJ2000=ConvertToJ2000
    IF SIZE(RADecStr,/TNAME) NE 'STRING' THEN BEGIN
        PRINT, 'Usage: RADec2Degree, RADecStr, RADecInDegree=RADecDeg, Print=Print'
        PRINT, 'Example: RADec2Degree, "60:20:00 02:00:00", /Print'
        RETURN
    ENDIF
   ;IF N_ELEMENTS(Print) EQ 0 THEN Print=1
    FOREACH RADecVSTR, RADecStr DO BEGIN
        hmsdms2degdeg, RADecStr, RADecDeg, Print=Print, DEBUG=DEBUG, ConvertToJ2000=ConvertToJ2000
    ENDFOREACH
END