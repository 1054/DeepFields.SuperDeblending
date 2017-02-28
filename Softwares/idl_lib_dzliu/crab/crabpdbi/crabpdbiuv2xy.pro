; 
; 
; ObsFrequency in GHz
; 
FUNCTION CrabPdBIUV2XY, VisPlane, ObsFrequency, NewDimension=NewDimension, PixScale=PixScale, PixPeriod=PixPeriod
    
    IF N_ELEMENTS(ObsFrequency) EQ 0 THEN RETURN, !NULL
    IF N_ELEMENTS(PixScale) EQ 0 THEN PixScale=[1.0,1.0]
    IF N_ELEMENTS(PixScale) EQ 1 THEN PixScale=[PixScale,PixScale]
    TempDimX = (SIZE(VisPlane,/DIM))[0]
    TempDimY = (SIZE(VisPlane,/DIM))[1]
    IF N_ELEMENTS(NewDimension) NE 2 THEN NewDimension = [TempDimX,TempDimY]
    TempCenX = FLOAT(NewDimension[0]-1)/2.0
    TempCenY = FLOAT(NewDimension[1]-1)/2.0
    TempCenU = FLOAT(TempDimX-1)/2.0
    TempCenV = FLOAT(TempDimY-1)/2.0
    TempArrU = FLOAT(INDGEN(TempDimX,TempDimY) MOD TempDimX) - TempCenU
    TempArrV = FLOAT(INDGEN(TempDimX,TempDimY)  /  TempDimX) - TempCenV
    SkyPlane = MAKE_ARRAY(NewDimension[0],NewDimension[1],/COMPLEX,VALUE=COMPLEX(!VALUES.F_NAN,!VALUES.F_NAN))
    FOR j=0,NewDimension[1]-1 DO BEGIN ; loop y coordinate
       FOR i=0,NewDimension[0]-1 DO BEGIN ; loop x coordinate
          PixPeriod = PixScale/3600.0/180.0*!PI*ObsFrequency*1e9/2.99792458e8
          TempUVXY = TempArrU*(i-TempCenX)*PixPeriod[0]+TempArrV*(j-TempCenY)*PixPeriod[1]
          ;<TODO><TEST> TempUVXY = (TempArrU*(i-TempCenX)+TempArrV*(j-TempCenY))/128. ;<TODO><TEST>
          ;<TODO><TEST> TempUVXY = (TempArrU*(i-TempCenX)/TempDimX+TempArrV*(j-TempCenY)/TempDimY)*3 ;<TODO><TEST> 
          TempFlag = WHERE(FINITE(VisPlane),/NULL) ; do not count NaN
          IF N_ELEMENTS(TempFlag) GT 0 THEN BEGIN
             TempPlane = VisPlane[TempFlag]*EXP(+2.0*!PI*COMPLEX(0,1)*TempUVXY[TempFlag]) ; rad - m
             SkyPlane[i,j] = TOTAL(TempPlane)
          ENDIF ELSE BEGIN
             SkyPlane[i,j] = COMPLEX(!VALUES.F_NAN,!VALUES.F_NAN)
          ENDELSE
       ENDFOR
    ENDFOR
    RETURN, SkyPlane
    
END