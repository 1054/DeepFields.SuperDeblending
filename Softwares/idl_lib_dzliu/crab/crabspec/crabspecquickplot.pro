; 
; This function plots
; 
PRO CrabSpecQuickPlot, XArray, YArray, SaveEPS=SaveEPS, AxesColor=AxesColor, Color=Color, Thick=Thick, XTitle=XTitle, YTitle=YTitle, Title=Title, XSize=XSize, YSize=YSize, XRange=XRange, YRange=YRange, XStyle=XStyle, YStyle=YStyle, Redshift=Redshift, Continue=Continue, Overplot=Overplot, Fill=Fill, Base=Base, NoData=NoData, Position=Position
    
    ;; 
    IF N_ELEMENTS(XArray) LE 0 OR N_ELEMENTS(YArray) LE 0 THEN BEGIN
        ;; 
        MESSAGE, "Usage: CrabSpecQuickPlot, XArray, YArray"
        RETURN
    ENDIF
    
    
    IF NOT KEYWORD_SET(Overplot) THEN BEGIN
        
        ; SaveEPS
        IF KEYWORD_SET(SaveEPS) THEN BEGIN
            OpenPS, SaveEPS, XSize=45.0, YSize=3.0
        ENDIF
        
        ; TV Window
        IF N_ELEMENTS(TVWindow) EQ 0 THEN TVWindow=1 ELSE TVWindow=FIX(TVWindow)
        IF !D.NAME EQ 'X' OR !D.NAME EQ 'Win' THEN BEGIN
            IF N_ELEMENTS(TVPosition) NE 2 THEN BEGIN
                Window, TVWindow, XSIZE=1200, YSIZE=400, TITLE=TVTitle 
            ENDIF ELSE BEGIN
                Window, TVWindow, XSIZE=1200, YSIZE=400, TITLE=TVTitle, XPOS=TVPosition[0], YPOS=TVPosition[1]
            ENDELSE
        ENDIF ELSE IF !D.NAME EQ 'PS' THEN BEGIN
            ; already opened eps above
        ENDIF
        
        ; Axes range 
        IF N_ELEMENTS(XStyle) EQ 0 THEN XStyle = 1
        IF N_ELEMENTS(YStyle) EQ 0 THEN YStyle = 1
        
        ; Plot spec
        PLOT, XArray, YArray, /NODATA, Position=Position, XTitle=XTitle, YTitle=YTitle, CharSize=1.25, CharThick=2.5, Thick=5.0, Color=AxesColor, PSYM=10, Font=1, XRange=XRange, YRange=YRange, XStyle=XStyle, YStyle=YStyle, XTickLen=0.15, YTickLen=0.01
        
    ENDIF
    
    
    
    IF NOT KEYWORD_SET(NoData) THEN BEGIN
        
        ; Plot spec
        IF KEYWORD_SET(Fill) THEN BEGIN
            IF N_ELEMENTS(Base) EQ 0 THEN Base=0.0 ; Base=!Y.CRange[0]
            XArray_Filled = [XArray[0],XArray[0],XArray,XArray[N_ELEMENTS(XArray)-1],XArray[N_ELEMENTS(XArray)-1]]
            YArray_Filled = [Base,Base,YArray,Base,Base]
            IF N_ELEMENTS(WHERE(YArray_Filled LT !Y.CRange[0],/NULL)) GT 0 THEN YArray_Filled[WHERE(YArray_Filled LT !Y.CRange[0],/NULL)] = !Y.CRange[0]
            IF N_ELEMENTS(WHERE(YArray_Filled GT !Y.CRange[1],/NULL)) GT 0 THEN YArray_Filled[WHERE(YArray_Filled GT !Y.CRange[1],/NULL)] = !Y.CRange[1]
            POLYFILL, XArray_Filled, YArray_Filled, THICK=Thick/2.0, Color=Color, NoClip=0
        ENDIF 
            XArray_Plot = XArray
            YArray_Plot = YArray
            IF N_ELEMENTS(WHERE(YArray_Plot LT !Y.CRange[0],/NULL)) GT 0 THEN YArray_Plot[WHERE(YArray_Plot LT !Y.CRange[0],/NULL)] = !Y.CRange[0]
            IF N_ELEMENTS(WHERE(YArray_Plot GT !Y.CRange[1],/NULL)) GT 0 THEN YArray_Plot[WHERE(YArray_Plot GT !Y.CRange[1],/NULL)] = !Y.CRange[1]
            OPLOT, XArray_Plot, YArray_Plot, COLOR=Color, THICK=Thick, PSYM=10
        
        
        
    ENDIF
    
    ;; plot lines
    ;IF N_ELEMENTS(Redshift) GT 0 THEN BEGIN
    ;    CrabSpecPlotCO, ColXs, ColYs, Redshift=Redshift, Color="magenta", CharThick=2.2
    ;ENDIF
    
    
    ; Save EPS
    IF !D.NAME EQ 'PS' AND NOT KEYWORD_SET(Continue) THEN BEGIN
        DEVICE, /CLOSE
        SET_PLOT, 'X'
        ;PRINT, 'ClosePS: '+SaveEPS
    ENDIF
    
END