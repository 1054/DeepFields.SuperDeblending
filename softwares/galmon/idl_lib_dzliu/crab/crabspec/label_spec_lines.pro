PRO label_spec_lines, LineNamePattern, LineNameList=LineNameList, LineFreqList=LineFreqList, LineWaveList=LineWaveList, NOPLOT=NOPLOT
    
    IF N_ELEMENTS(LineNamePattern) EQ 0 THEN BEGIN
        PRINT, 'Usage:'
        PRINT, '    label_spec_lines, "H2O", LineNameList=LineNameList, LineFreqList=LineFreqList, LineWaveList=LineWaveList, /NoPlot'
        PRINT, '    '
        RETURN
    ENDIF
    
    LabLineData = [ { Name:"H2O(111-000)", Freq:1113.34301 } , $
                    { Name:"H2O(202-111)", Freq: 987.92676 } , $
                    { Name:"H2O(211-202)", Freq: 752.03314 } , $
                    { Name:"H2O(220-211)", Freq:1228.78872 } , $
                    { Name:"H2O(312-221)", Freq:1153.12682 } , $
                    { Name:"H2O(312-303)", Freq:1097.36479 } , $
                    { Name:"H2O(321-312)", Freq:1162.91160 } , $
                    { Name:"H2O(322-313)", Freq:1919.35953 } , $
                    { Name:"H2O(422-331)", Freq: 916.17158 } , $
                    { Name:"H2O(422-413)", Freq:1207.63873 } , $
                    { Name:"H2O(423-330)", Freq: 448.00108 } , $
                    { Name:"H2O(523-432)", Freq:1918.48535 } , $
                    { Name:"H2O(523-514)", Freq:1410.61807 } , $
                    { Name:"[CI](3P1-3P0)", Freq:492.16065 } , $
                    { Name:"[CI](3P2-3P1)", Freq:809.34197 } , $
                    { Name:"TEST",         Freq:0000.00001 }   ]
    
    LineMatch = STREGEX(LabLineData.Name, LineNamePattern, /BOOLEAN)
    ;PRINT, LineMatch
    
    IF N_ELEMENTS(WHERE(LineMatch, /NULL)) EQ 0 THEN BEGIN
        MESSAGE, "No line found with line name pattern "+LineNamePattern, /CONTINUE
        RETURN
    ENDIF
    
    LineNameList = LabLineData.Name[WHERE(LineMatch)]
    LineFreqList = LabLineData.Freq[WHERE(LineMatch)] ; GHz
    LineWaveList = 299.792458/LineFreqList ; mm
    
    
    
    IF NOT KEYWORD_SET(NOPLOT) THEN BEGIN
        IF !X.CRANGE[1] GT !X.CRANGE[0] AND !Y.CRANGE[1] GT !Y.CRANGE[0] THEN BEGIN
            LinePlotYLength = !Y.CRANGE[1] -!Y.CRANGE[0]
            LinePlotYRange = [!Y.CRANGE[1] - 0.25*LinePlotYLength, !Y.CRANGE[1] - 0.02*LinePlotYLength]
            IF !D.NAME EQ 'PS' THEN LinePlotThick = 2.0 ELSE LinePlotThick = 1.0
            IF !D.NAME EQ 'PS' THEN LinePlotCharThick = 2.0 ELSE LinePlotCharThick = 1.0
            IF !D.NAME EQ 'PS' THEN LinePlotCharSize = 0.8 ELSE LinePlotCharSize = 1.2
            MESSAGE, "Labelling "+STRING(FORMAT='(I0)',N_ELEMENTS(LineFreqList))+" spec line names", /CONTINUE
            FOR LinePlotIndex=0,N_ELEMENTS(LineFreqList)-1 DO BEGIN
                IF LinePlotIndex LE N_ELEMENTS(COLOR)-1 THEN LinePlotColor=COLOR[LinePlotIndex] ELSE LinePlotColor='FF00FF'xL
               ;PLOTS, [LineFreqList[LinePlotIndex],LineFreqList[LinePlotIndex]], LinePlotYRange, LINESTYLE=2, COLOR=LinePlotColor, Thick=LinePlotThick
                XYOUTS, LineFreqList[LinePlotIndex], LinePlotYRange[1], LineNameList[LinePlotIndex], ALIGNMENT=1.0, ORIENTATION=90, $
                         CHARSIZE=LinePlotCharSize, CHARTHICK=LinePlotCharThick, COLOR=LinePlotColor
            ENDFOR
        ENDIF
    ENDIF
    
END