FUNCTION kkms2kkmspc2, FluxInKkms, Distance=Distance, BeamSize=BeamSize, Redshift=Redshift, Print=Print
    ; FluxInKkms in [K km/s]
    ; Distance in [Mpc]
    ; BeamSize in [arcsec]
    ; a = kkms2kkmspc2(3.81,Distance=56,BeamSize=28,/PRINT)
    IF N_ELEMENTS(FluxInKkms) EQ 0 THEN PRINT, "kkms2kkmspc2, FluxInKkms, Distance=Distance, BeamSize=BeamSize, Redshift=Redshift, Print=Print"
    IF N_ELEMENTS(FluxInKkms) EQ 0 THEN RETURN, !VALUES.D_NAN
    IF N_ELEMENTS(Redshift) EQ 0 THEN Redshift=0.0D
    LuminInKkms = 23.5D * !PI / (4.0*alog(2.0)) * DOUBLE(BeamSize)^2 * DOUBLE(Distance)^2 * DOUBLE(FluxInKkms) * (1.0+Redshift)^(-3)
    IF KEYWORD_SET(Print) THEN Print, FORMAT='(E15.6,A)', LuminInKkms, ' K km s-1 pc2'
    RETURN, LuminInKkms
END

FUNCTION jykms2kkmspc2, FluxInJykms, Distance=Distance, RestFreq=RestFreq, ObsFreq=ObsFreq, Redshift=Redshift, Print=Print
    ; FluxInJykms in [Jy km/s]
    ; Distance in [Mpc]
    ; BeamSize in [arcsec]
    ; a = kkms2kkmspc2(3.81,Distance=56,BeamSize=28,/PRINT)
    IF N_ELEMENTS(FluxInJykms) EQ 0 THEN PRINT, "jykms2kkmspc2, FluxInJykms, Distance=Distance, RestFreq=RestFreq, ObsFreq=ObsFreq, Redshift=Redshift, Print=Print"
    IF N_ELEMENTS(FluxInJykms) EQ 0 THEN RETURN, !VALUES.D_NAN
    IF N_ELEMENTS(Redshift) EQ 0 THEN Redshift=0.0D
    IF N_ELEMENTS(RestFreq) EQ 0 AND N_ELEMENTS(ObsFreq) EQ N_ELEMENTS(FluxInJykms) THEN RestFreq = ObsFreq*(Redshift+1.0d) ELSE MESSAGE, 'jykms2kkmspc2: Error! Could not determine frequency!'
    LuminInKkms = 3.25D7 * DOUBLE(Distance)^2 / (RestFreq/(1.0+Redshift))^2 * DOUBLE(FluxInJykms) * (1.0+Redshift)^(-3)
    IF KEYWORD_SET(Print) THEN Print, FORMAT='(E15.6,A)', LuminInKkms, ' K km s-1 pc2'
    RETURN, LuminInKkms
END

FUNCTION kkmspc22kkms, LuminInKkms, Distance=Distance, BeamSize=BeamSize, Redshift=Redshift, Print=Print
    ; LuminInKkms in [K km s^-1 pc^2]
    ; Distance in [Mpc]
    ; BeamSize in [arcsec]
    ; a = kkms2kkmspc2(3.81,Distance=56,BeamSize=28,/PRINT)
    IF N_ELEMENTS(Redshift) EQ 0 THEN Redshift=0.0D
    FluxInKkms = LuminInKkms / 23.5D / !PI * (4.0*alog(2.0)) / DOUBLE(BeamSize)^2 / DOUBLE(Distance)^2 / (1.0+Redshift)^(-3)
    IF KEYWORD_SET(Print) THEN Print, FORMAT='(E15.6,A)', FluxInKkms, ' K km s-1'
    RETURN, FluxInKkms
END

FUNCTION kkmspc22jykms, LuminInKkms, Distance=Distance, RestFreq=RestFreq, ObsFreq=ObsFreq, Redshift=Redshift, Print=Print
    ; LuminInKkms in [K km s^-1 pc^2]
    ; Distance in [Mpc]
    ; BeamSize in [arcsec]
    ; a = kkms2kkmspc2(3.81,Distance=56,BeamSize=28,/PRINT)
    IF N_ELEMENTS(LuminInKkms) EQ 0 THEN PRINT, "kkmspc22jykms, LuminInKkms, Distance=Distance, RestFreq=RestFreq, ObsFreq=ObsFreq, Redshift=Redshift, Print=Print"
    IF N_ELEMENTS(LuminInKkms) EQ 0 THEN RETURN, !VALUES.D_NAN
    IF N_ELEMENTS(Redshift) EQ 0 THEN Redshift=0.0D
    IF N_ELEMENTS(RestFreq) EQ 0 AND N_ELEMENTS(ObsFreq) EQ N_ELEMENTS(LuminInKkms) THEN RestFreq = ObsFreq*(Redshift+1.0d)
    IF N_ELEMENTS(RestFreq) EQ 0 THEN MESSAGE, 'kkmspc22jykms: Error! Could not determine frequency!'
    FluxInJykms = LuminInKkms / 3.25D7 / DOUBLE(Distance)^2 * (RestFreq/(1.0+Redshift))^2 / (1.0+Redshift)^(-3)
    IF KEYWORD_SET(Print) THEN Print, FORMAT='(E15.6,A)', FluxInJykms, ' Jy km s-1'
    RETURN, FluxInJykms
END
