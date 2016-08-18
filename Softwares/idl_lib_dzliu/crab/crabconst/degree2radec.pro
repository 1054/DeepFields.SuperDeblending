PRO Degree2RADec, RAInDegree, DecInDegree, RADecStr=RADecStr, Print=Print, FORMAT=FORMAT, PRECISION=PRECISION, DEBUG=DEBUG, SeparateByColon=SeparateByColon, SeparateByNothing=SeparateByNothing, SeparateByhmsdms=SeparateByhmsdms
    IF N_ELEMENTS(RAInDegree) EQ 0 OR N_ELEMENTS(DecInDegree) EQ 0 THEN BEGIN
        PRINT, 'Usage: Degree2RADec, RAInDegree, DecInDegree, RADecStr=RADecStr, Print=Print'
        PRINT, 'Example: Degree2RADec, 189.0, 62.0, /Print'
        RETURN
    ENDIF
   ;IF N_ELEMENTS(Print) EQ 0 THEN Print=1
    RADecStr = []
    FOR i=0,N_ELEMENTS(RAInDegree)-1 DO BEGIN
    	IF N_ELEMENTS(DecInDegree)-1 GE i THEN BEGIN
    		degdeg2hmsdms, [RAInDegree[i], DecInDegree[i]], TempStr, Print=Print, FORMAT=FORMAT, PRECISION=PRECISION, DEBUG=DEBUG, SeparateByColon=SeparateByColon, SeparateByNothing=SeparateByNothing, SeparateByhmsdms=SeparateByhmsdms
    		RADecStr = [RADecStr, TempStr]
    	ENDIF ELSE BEGIN
    		PRINT, 'Warning! Input RA and Dec do not have the same dimension! Skipping RA='+STRING(FORMAT='(F0.7)',RAInDegree[i])
        ENDELSE
    ENDFOR
END