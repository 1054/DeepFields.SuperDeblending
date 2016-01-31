; Flux Density values are in the unit of [Jy/pixel] or [MJy/sr]
; Luminosity values are actually \nu L_{\nu}
; This program will convert [Jy/pixel] into [L_solar]
; 
FUNCTION jyperpix2solarlumin, FluxInJyPerPix, Distance=SourceDistance, Frequency=ObsFrequency
    LuminosityInSolarLumin = []
    FOREACH FluxOneValue, FluxInJyPerPix DO BEGIN
        LuminOneValue = FluxOneValue *1D-23*4D*!PI* (SourceDistance*1D6*3.086D18)^2 *ObsFrequency*1D9
        LuminOneValue = LuminOneValue / 3.86D33
        LuminosityInSolarLumin = [ LuminosityInSolarLumin, LuminOneValue ]
    ENDFOREACH
    IF N_ELEMENTS(LuminosityInSolarLumin) EQ 1 THEN LuminosityInSolarLumin=LuminosityInSolarLumin[0]
    RETURN, LuminosityInSolarLumin
END