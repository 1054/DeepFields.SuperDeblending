FUNCTION arcsec2kpc, SizeInArcsec, Distance=Distance, Print=Print
    ; SizeInArcsec in arcsec
    ; Distance in Mpc
    kpc2arcsec = 3600D*180D/!PI/1D3/Double(Distance)
    SizeInKpc = Double(SizeInArcsec) / kpc2arcsec
    IF KEYWORD_SET(Print) THEN Print, FORMAT='(F16.6,A)', SizeInKpc, ' "'
    RETURN, SizeInKpc
END