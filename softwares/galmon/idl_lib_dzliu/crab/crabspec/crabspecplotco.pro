; 
; This function plots CO lines
; 
PRO CrabSpecPlotCO, InputFrequency, InputFluxDensity, Redshift=Redshift, Color=Color, Thick=Thick, CharThick=CharThick
    
    ;; 
    lab_co_lines, J_Upper_Range=[0,15], LineNameList=LineNameList, LineFreqList=LineFreqList, LineWaveList=LineWaveList
    PRINT, LineNameList, LineFreqList
    
    ;;
    IF N_ELEMENTS(Redshift) GT 0 THEN BEGIN
        LineFreqList = LineFreqList / (1.0+Redshift[0])
    ENDIF
    
    ;; 
;    i = INDGEN(N_ELEMENTS(LineFreqList),START=0)*2
;    j = INDGEN(N_ELEMENTS(LineFreqList),START=0)*2+1
;    PlotXArr = MAKE_ARRAY(2*N_ELEMENTS(LineFreqList),/DOUBLE)
;    PlotYArr = MAKE_ARRAY(2*N_ELEMENTS(LineFreqList),/DOUBLE)
;    PlotXArr[i] = LineFreqList
;    PlotXArr[j] = LineFreqList
;    PlotYArr[i] = -500
;    PlotYArr[j] = 500
    
    ;;
    IF SIZE(Color,/TNAME) EQ "STRING" THEN PlotColor=cgColor(Color)
    
    ;; 
    MaxFluxDensity = MAX(InputFluxDensity)
    MinFluxDensity = MIN(InputFluxDensity)
    FOR i=0,N_ELEMENTS(LineFreqList)-1 DO BEGIN
        TempDiff = ABS(InputFrequency-LineFreqList[i])
        TempIndex = WHERE(TempDiff EQ MIN(TempDiff) AND TempDiff LE 5.0, /NULL)
        PlotXArr = [0.0,0.0]
        PlotYArr = [0.0,0.0]
        IF N_ELEMENTS(TempIndex) GT 0 THEN BEGIN
            TempIndex = TempIndex[0]
            PlotXArr[0] = LineFreqList[i]
            PlotXArr[1] = LineFreqList[i]
            PlotXCen    = LineFreqList[i]
            IF InputFluxDensity[TempIndex] LT 0.5*(MaxFluxDensity-MinFluxDensity) THEN BEGIN
                PlotYArr[0] = InputFluxDensity[TempIndex]+0.05*(MaxFluxDensity-MinFluxDensity)
                PlotYArr[1] = MaxFluxDensity-0.15*(MaxFluxDensity-MinFluxDensity)
                PlotYCen    = MaxFluxDensity-0.05*(MaxFluxDensity-MinFluxDensity)
            ENDIF ELSE BEGIN
                PlotYArr[0] = InputFluxDensity[TempIndex]-0.35*(MaxFluxDensity-MinFluxDensity)
                PlotYArr[1] = MinFluxDensity+0.15*(MaxFluxDensity-MinFluxDensity)
                PlotYCen    = MinFluxDensity+0.05*(MaxFluxDensity-MinFluxDensity)
            ENDELSE
            PLOTS, PlotXArr, PlotYArr, Color=PlotColor, LINESTYLE=2, Thick=Thick
            XYOUTS, PlotXCen, PlotYCen, LineNameList[i], Color=PlotColor, CharThick=CharThick, ALIGNMENT=0.5
        ENDIF
    ENDFOR
    
    
    RETURN
    
END