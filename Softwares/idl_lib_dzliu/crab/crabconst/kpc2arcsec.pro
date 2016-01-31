FUNCTION kpc2arcsec, SizeInKpc, Distance=Distance, Print=Print
    ; SizeInKpc in kpc
    ; Distance in Mpc
    kpc2arcsec = 3600D*180D/!PI/1D3/Double(Distance)
    SizeInArcsec = kpc2arcsec * Double(SizeInKpc)
    IF KEYWORD_SET(Print) THEN Print, FORMAT='(F16.6,A)', SizeInArcsec, ' "'
    RETURN, SizeInArcsec
END

FUNCTION pc2arcsec, SizeInPc, Distance=Distance, Print=Print
    ; SizeInKpc in pc
    ; Distance in pc
    pc2arcsec = 3600D*180D/!PI/Double(Distance)
    SizeInArcsec = pc2arcsec * Double(SizeInPc)
    IF KEYWORD_SET(Print) THEN Print, FORMAT='(F16.6,A)', SizeInArcsec, ' "'
    RETURN, SizeInArcsec
END