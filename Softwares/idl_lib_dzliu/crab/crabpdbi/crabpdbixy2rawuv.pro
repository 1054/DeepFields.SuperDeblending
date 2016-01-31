; 
; 
; ObsFrequency in GHz
; 
FUNCTION CrabPdBIXY2RawUV, VisU, VisV, SkyPlane, ObsFrequency, NewDimension=NewDimension, PixScale=PixScale, PixPeriod=PixPeriod
    
    IF N_ELEMENTS(ObsFrequency) EQ 0 THEN RETURN, !NULL
    IF N_ELEMENTS(VisU) NE N_ELEMENTS(VisV) THEN RETURN, !NULL
    IF N_ELEMENTS(PixScale) EQ 0 THEN PixScale=[1.0,1.0]
    IF N_ELEMENTS(PixScale) EQ 1 THEN PixScale=[PixScale,PixScale]
    TempDimX = (SIZE(SkyPlane,/DIM))[0]
    TempDimY = (SIZE(SkyPlane,/DIM))[1]
    TempCenX = FLOAT(TempDimX-1)/2.0
    TempCenY = FLOAT(TempDimY-1)/2.0
    TempArrX = FLOAT(INDGEN(TempDimX,TempDimY) MOD TempDimX) - TempCenX
    TempArrY = FLOAT(INDGEN(TempDimX,TempDimY)  /  TempDimX) - TempCenY
    VisData = MAKE_ARRAY(N_ELEMENTS(VisU),/COMPLEX,VALUE=COMPLEX(!VALUES.F_NAN,!VALUES.F_NAN))
    FOR i=0,N_ELEMENTS(VisU)-1 DO BEGIN ; loop raw-u-v coordinate
          PixPeriod = PixScale/3600.0/180.0*!PI*ObsFrequency*1e9/2.99792458e8
          TempUVXY = TempArrX*(VisU[i])*PixPeriod[0]+TempArrY*(VisU[i])*PixPeriod[1]
          TempFlag = WHERE(FINITE(SkyPlane),/NULL) ; do not count NaN
          IF N_ELEMENTS(TempFlag) GT 0 THEN BEGIN
             TempPlane = SkyPlane[TempFlag]*EXP(-2.0*!PI*COMPLEX(0,1)*TempUVXY[TempFlag]) ; rad - m
             VisData[i] = TOTAL(TempPlane)
             IF N_ELEMENTS(NewDimension) EQ 2 THEN VisData[i] = VisData[i] / SQRT(FLOAT(NewDimension[0]*NewDimension[1]))
          ENDIF ELSE BEGIN
             VisData[i] = COMPLEX(!VALUES.F_NAN,!VALUES.F_NAN)
          ENDELSE
    ENDFOR
    RETURN, VisData
END