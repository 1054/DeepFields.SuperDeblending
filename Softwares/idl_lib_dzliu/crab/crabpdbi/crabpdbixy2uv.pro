; 
; 
; ObsFrequency in GHz
; 
FUNCTION CrabPdBIXY2UV, SkyPlane, ObsFrequency, NewDimension=NewDimension, PixScale=PixScale, PixPeriod=PixPeriod
    
    IF N_ELEMENTS(ObsFrequency) EQ 0 THEN RETURN, !NULL
    IF N_ELEMENTS(PixScale) EQ 0 THEN PixScale=[1.0,1.0]
    IF N_ELEMENTS(PixScale) EQ 1 THEN PixScale=[PixScale,PixScale]
    TempDimX = (SIZE(SkyPlane,/DIM))[0]
    TempDimY = (SIZE(SkyPlane,/DIM))[1]
    IF N_ELEMENTS(NewDimension) NE 2 THEN NewDimension = [TempDimX,TempDimY]
    TempCenU = FLOAT(NewDimension[0]-1)/2.0
    TempCenV = FLOAT(NewDimension[1]-1)/2.0
    TempCenX = FLOAT(TempDimX-1)/2.0
    TempCenY = FLOAT(TempDimY-1)/2.0
    TempArrX = FLOAT(INDGEN(TempDimX,TempDimY) MOD TempDimX) - TempCenX
    TempArrY = FLOAT(INDGEN(TempDimX,TempDimY)  /  TempDimX) - TempCenY
    VisPlane = MAKE_ARRAY(NewDimension[0],NewDimension[1],/COMPLEX,VALUE=COMPLEX(!VALUES.F_NAN,!VALUES.F_NAN))
    FOR j=0,NewDimension[1]-1 DO BEGIN ; loop v coordinate
       FOR i=0,NewDimension[0]-1 DO BEGIN ; loop u coordinate
          PixPeriod = PixScale/3600.0/180.0*!PI*ObsFrequency*1e9/2.99792458e8
          TempUVXY = TempArrX*(i-TempCenU)*PixPeriod[0]+TempArrY*(j-TempCenV)*PixPeriod[1]
          ;<TODO><TEST> TempUVXY = (TempArrX*(i-TempCenU)+TempArrY*(j-TempCenV))/128. ;<TODO><TEST>
          ;<TODO><TEST> TempUVXY = (TempArrX*(i-TempCenU)/TempDimX+TempArrY*(j-TempCenV)/TempDimY)*3 ;<TODO><TEST>
          TempFlag = WHERE(FINITE(SkyPlane),/NULL) ; do not count NaN
          IF N_ELEMENTS(TempFlag) GT 0 THEN BEGIN
             TempPlane = SkyPlane[TempFlag]*EXP(-2.0*!PI*COMPLEX(0,1)*TempUVXY[TempFlag]) ; rad - m
             VisPlane[i,j] = TOTAL(TempPlane)
          ENDIF ELSE BEGIN
             VisPlane[i,j] = COMPLEX(!VALUES.F_NAN,!VALUES.F_NAN)
          ENDELSE
       ENDFOR
    ENDFOR
    RETURN, VisPlane
END