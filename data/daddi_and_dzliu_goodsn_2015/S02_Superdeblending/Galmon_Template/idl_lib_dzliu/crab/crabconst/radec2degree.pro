PRO RADec2Degree, RADecStr, RADecInDegree=RADecDeg, Print=Print, DEBUG=DEBUG, ConvertToJ2000=ConvertToJ2000
    IF SIZE(RADecStr,/TNAME) NE 'STRING' THEN RETURN
   ;IF N_ELEMENTS(Print) EQ 0 THEN Print=1
    FOREACH RADecVSTR, RADecStr DO BEGIN
        hmsdms2degdeg, RADecStr, RADecDeg, Print=Print, DEBUG=DEBUG, ConvertToJ2000=ConvertToJ2000
    ENDFOREACH
END