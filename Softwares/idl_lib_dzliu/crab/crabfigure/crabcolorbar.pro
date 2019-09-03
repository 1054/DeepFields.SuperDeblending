; 
; provide a list of colors
; 
PRO CrabColorBar, Value_Colors, Rect = Rect, Size = Size, Position = Position, $
                  Labels = Labels, LabelAlignment = LabelAlignment, LabelCharSizes = LabelCharSizes, LabelCharThicks = LabelCharThicks, LabelFormats = LabelFormats
    
    ; Set the colorbar rectangle
    Plot_ColorBar_Rect = [0.85,0.60,0.90,0.95] ; X1,Y1,X2,Y2
    ; Read input position
    IF N_ELEMENTS(Position) EQ 2 THEN BEGIN
        ; if the input is a position for the colorbar
        Plot_ColorBar_Rect[2] = Position[0] + (Plot_ColorBar_Rect[2]-Plot_ColorBar_Rect[0])
        Plot_ColorBar_Rect[3] = Position[1] + (Plot_ColorBar_Rect[3]-Plot_ColorBar_Rect[1])
        Plot_ColorBar_Rect[0] = Position[0]
        Plot_ColorBar_Rect[1] = Position[1]
    ENDIF
    ; Read input position
    IF N_ELEMENTS(Size) EQ 2 THEN BEGIN
        ; if the input is a position for the colorbar
        Plot_ColorBar_Rect[2] = Plot_ColorBar_Rect[0] + (Size[0])
        Plot_ColorBar_Rect[3] = Plot_ColorBar_Rect[1] + (Size[1])
    ENDIF
    ; Read input argument
    IF N_ELEMENTS(Rect) EQ 4 THEN BEGIN
        ; if the input is a rectangle for the colorbar
        Plot_ColorBar_Rect = Rect
    ENDIF
    ; Plot the colorbar
    FOR i = 0, N_ELEMENTS(Value_Colors)-1 DO BEGIN
        Plot_ColorBar_PolyX = [ Plot_ColorBar_Rect[0] +  0    * (Plot_ColorBar_Rect[2]-Plot_ColorBar_Rect[0]), $
                                Plot_ColorBar_Rect[0] +  0    * (Plot_ColorBar_Rect[2]-Plot_ColorBar_Rect[0]), $
                                Plot_ColorBar_Rect[0] +  1    * (Plot_ColorBar_Rect[2]-Plot_ColorBar_Rect[0]), $
                                Plot_ColorBar_Rect[0] +  1    * (Plot_ColorBar_Rect[2]-Plot_ColorBar_Rect[0]), $
                                Plot_ColorBar_Rect[0] +  0    * (Plot_ColorBar_Rect[2]-Plot_ColorBar_Rect[0]) ]
        Plot_ColorBar_PolyY = [ Plot_ColorBar_Rect[1] +  i    * (Plot_ColorBar_Rect[3]-Plot_ColorBar_Rect[1])/DOUBLE(N_ELEMENTS(Value_Colors)), $
                                Plot_ColorBar_Rect[1] + (i+1) * (Plot_ColorBar_Rect[3]-Plot_ColorBar_Rect[1])/DOUBLE(N_ELEMENTS(Value_Colors)), $
                                Plot_ColorBar_Rect[1] + (i+1) * (Plot_ColorBar_Rect[3]-Plot_ColorBar_Rect[1])/DOUBLE(N_ELEMENTS(Value_Colors)), $
                                Plot_ColorBar_Rect[1] +  i    * (Plot_ColorBar_Rect[3]-Plot_ColorBar_Rect[1])/DOUBLE(N_ELEMENTS(Value_Colors)), $
                                Plot_ColorBar_Rect[1] +  i    * (Plot_ColorBar_Rect[3]-Plot_ColorBar_Rect[1])/DOUBLE(N_ELEMENTS(Value_Colors)) ]
        ; 
        POLYFILL, Plot_ColorBar_PolyX, Plot_ColorBar_PolyY, /NORMAL, Color = Value_Colors[i]
        ; 
        IF N_ELEMENTS(Labels) GT i THEN BEGIN
            IF N_ELEMENTS(LabelAlignment) EQ 0 THEN LabelAlignment = 1.0
            IF N_ELEMENTS(LabelCharSizes) GT 0 AND N_ELEMENTS(LabelCharSizes) LE i THEN LabelCharSizes = [LabelCharSizes, LabelCharSizes[-1]]
            IF N_ELEMENTS(LabelCharSizes) GT i THEN LabelCharSize = LabelCharSizes[i] ELSE LabelCharSize = 1.0
            IF N_ELEMENTS(LabelCharThicks) GT 0 AND N_ELEMENTS(LabelCharThicks) LE i THEN LabelCharThicks = [LabelCharThicks, LabelCharThicks[-1]]
            IF N_ELEMENTS(LabelCharThicks) GT i THEN LabelCharThick = LabelCharThicks[i] ELSE LabelCharThick = 2.5
            IF N_ELEMENTS(LabelFormats) GT 0 AND N_ELEMENTS(LabelFormats) LE i THEN LabelFormats = [LabelFormats, LabelFormats[-1]]  
            IF N_ELEMENTS(LabelFormats) GT i THEN LabelFormat = LabelFormats[i] ELSE LabelFormat = '(A)'
            IF STRMID(LabelFormat,0,1) NE '(' THEN LabelFormat = '('+LabelFormat
            IF STRMID(LabelFormat,STRLEN(LabelFormat)-1,1) NE ')' THEN LabelFormat = LabelFormat+')'
            LabelStr = STRING(FORMAT=LabelFormat, Labels[i])
            ;LabelHeightInPixel = 12.0 ; assumed 12pt
            ;LabelHeight = LabelHeightInPixel / !D.Y_VSIZE ; normalized by plot y pixel size
            MarginPix = 0.0
            IF !D.NAME EQ 'PS' THEN MarginPix = 0.003 ; 1000.0 pixels = 1 cm
            
            IF ABS(FLOAT(LabelAlignment)-0.5) LT 0.05 THEN BEGIN
                ; align center
                XYOUTS, MEAN(Plot_ColorBar_PolyX[0:3]), MIN(Plot_ColorBar_PolyY[0:3]), LabelStr, ALIGNMENT=LabelAlignment, /NORMAL, Color = Value_Colors[i], CharThick=2
            ENDIF ELSE IF FLOAT(LabelAlignment) LT 0.5 THEN BEGIN
                ; align left
                XYOUTS, MIN(Plot_ColorBar_PolyX[0:3])-MarginPix, MIN(Plot_ColorBar_PolyY[0:3]), LabelStr, ALIGNMENT=1, /NORMAL, Color = Value_Colors[i], CharThick=2
            ENDIF ELSE IF FLOAT(LabelAlignment) GT 0.5 THEN BEGIN
                ; align right
                XYOUTS, MAX(Plot_ColorBar_PolyX[0:3])+MarginPix, MIN(Plot_ColorBar_PolyY[0:3]), LabelStr, ALIGNMENT=0, /NORMAL, Color = Value_Colors[i], CharThick=2
            ENDIF
        ENDIF
    ENDFOR
    
END