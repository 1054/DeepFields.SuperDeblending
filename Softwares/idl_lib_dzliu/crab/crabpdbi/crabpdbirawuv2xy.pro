; 
; 
; ObsFrequency in GHz
; 
FUNCTION CrabPdBIRawUV2XY, VisU, VisV, VisData, ObsFrequency, NewDimension=NewDimension, PixScale=PixScale, PixPeriod=PixPeriod
    
    IF N_ELEMENTS(VisU) NE N_ELEMENTS(VisV) THEN RETURN, !NULL
    IF N_ELEMENTS(VisU) NE N_ELEMENTS(VisData) THEN RETURN, !NULL
    IF N_ELEMENTS(ObsFrequency) EQ 0 THEN RETURN, !NULL
    IF N_ELEMENTS(PixScale) EQ 0 THEN PixScale=[1.0,1.0]
    IF N_ELEMENTS(PixScale) EQ 1 THEN PixScale=[PixScale,PixScale]
    
    IF N_ELEMENTS(NewDimension) NE 2 THEN NewDimension = [128,128]
    TempCenX = FLOAT(NewDimension[0]-1)/2.0
    TempCenY = FLOAT(NewDimension[1]-1)/2.0
    SkyPlane = MAKE_ARRAY(NewDimension[0],NewDimension[1],/COMPLEX,VALUE=!VALUES.F_NAN)
    FOR j=0,NewDimension[1]-1 DO BEGIN ; loop y coordinate
       FOR i=0,NewDimension[0]-1 DO BEGIN ; loop x coordinate
          PixPeriod = PixScale/3600.0/180.0*!PI*ObsFrequency*1e9/2.99792458e8
          TempUVXY = VisU*(i-TempCenX)*PixPeriod[0]+VisV*(j-TempCenY)*PixPeriod[1]
          TempFlag = WHERE(FINITE(VisData),/NULL) ; do not count NaN
          IF N_ELEMENTS(TempFlag) GT 0 THEN BEGIN
             TempPlane = VisData[TempFlag]*EXP(+2.0*!PI*COMPLEX(0,1)*TempUVXY[TempFlag]) ; rad - m
             SkyPlane[i,j] = TOTAL(TempPlane)
             IF N_ELEMENTS(NewDimension) EQ 2 THEN SkyPlane[i,j] = SkyPlane[i,j] / SQRT(FLOAT(NewDimension[0]*NewDimension[1]))
          ENDIF ELSE BEGIN
             SkyPlane[i,j] = COMPLEX(!VALUES.F_NAN,!VALUES.F_NAN)
          ENDELSE
       ENDFOR
    ENDFOR
    RETURN, SkyPlane
    
END