PRO CrabFigureBarplotHelper, Locates, Histo, BarLocates=BarLocates, SYMSIZE=SYMSIZE, THICK=THICK, $
                                             VERTICAL=VERTICAL, Horizonal=Horizonal, EXP=EXP, $
                                             PlotLocatLines=PlotLocatLines, XRange=XRange, YRange=YRange, $
                                             PlotHistoTexts=PlotHistoTexts,CHARSIZE=CHARSIZE,CHARTHICK=CHARTHICK, $
                                             DoNotPlot=DoNotPlot, TitleText=TitleText, $
                                             TitleCharSizeF=TitleCharSizeF, TitleCharThick=TitleCharThick
                                             
    
    IF N_ELEMENTS(Locates) EQ 0 OR N_ELEMENTS(Histo) EQ 0 THEN RETURN
    IF N_ELEMENTS(Locates) NE N_ELEMENTS(Histo) THEN RETURN
    IF N_ELEMENTS(Locates) LE 3 THEN RETURN
    IF Locates[1] LT Locates[0] THEN RETURN
    
    BarRoofWidth = Locates[1]-Locates[0]
    BarRoofHisto = Histo
    BarRoofLocat = Locates
    BarWallLocat = MAKE_ARRAY(N_ELEMENTS(Locates)+1,/DOUBLE,VALUE=0.0D)
    BarWallHisto = MAKE_ARRAY(N_ELEMENTS(Locates)+1,/DOUBLE,VALUE=0.0D)
    
    FOR i=0,N_ELEMENTS(Locates)-1 DO BEGIN
        IF i EQ 0 THEN BEGIN
            BarWallLocat[0] = Locates[0]-0.5*(Locates[1]-Locates[0])
            BarWallHisto[0] = Histo[0]
        ENDIF ELSE BEGIN
            BarWallLocat[i] = (Locates[i-1]+Locates[i])/2.0
            BarWallHisto[i] = MAX([Histo[i-1],Histo[i]])
        ENDELSE
        IF i EQ N_ELEMENTS(Locates)-1 THEN BEGIN
            BarWallLocat[i+1] = Locates[i]+0.5*(Locates[i]-Locates[i-1])
            BarWallHisto[i+1] = Histo[i]
        ENDIF
    ENDFOR
    
    BarLocates = BarWallLocat
    
    IF KEYWORD_SET(EXP) THEN BarWallLocat = 10^BarWallLocat
    IF KEYWORD_SET(EXP) THEN YLog=1
    
    ; Plot Bin Walls
    FOR i=0,N_ELEMENTS(BarWallLocat)-1 DO BEGIN
        IF KEYWORD_SET(VERTICAL) AND NOT KEYWORD_SET(DoNotPlot) THEN BEGIN
            PLOTS, [BarWallLocat[i],BarWallLocat[i]], [0,BarWallHisto[i]], SYMSIZE=SYMSIZE, THICK=THICK
        ENDIF
        IF KEYWORD_SET(Horizonal) AND NOT KEYWORD_SET(DoNotPlot) THEN BEGIN
            PLOTS, [0,BarWallHisto[i]], [BarWallLocat[i],BarWallLocat[i]], SYMSIZE=SYMSIZE, THICK=THICK
        ENDIF
    ENDFOR
    
    ; Plot Bin Roofs
    FOR i=0,N_ELEMENTS(BarRoofHisto)-1 DO BEGIN
        IF KEYWORD_SET(VERTICAL) AND NOT KEYWORD_SET(DoNotPlot) THEN BEGIN
            PLOTS, [BarWallLocat[i],BarWallLocat[i+1]], [BarRoofHisto[i],BarRoofHisto[i]], SYMSIZE=SYMSIZE, THICK=THICK
        ENDIF
        IF KEYWORD_SET(Horizonal) AND NOT KEYWORD_SET(DoNotPlot) THEN BEGIN
            PLOTS, [BarRoofHisto[i],BarRoofHisto[i]], [BarWallLocat[i],BarWallLocat[i+1]], SYMSIZE=SYMSIZE, THICK=THICK
        ENDIF
    ENDFOR
    
    ; Plot Bin PlotLocatLines
    FOR i=0,N_ELEMENTS(BarWallLocat)-1 DO BEGIN
        IF KEYWORD_SET(PlotLocatLines) AND KEYWORD_SET(VERTICAL) AND N_ELEMENTS(YRange) EQ 2 AND NOT KEYWORD_SET(DoNotPlot) THEN BEGIN
            PLOTS, [BarWallLocat[i],BarWallLocat[i]], [YRange], Color=cgColor('Charcoal'), LineStyle=2, Thick=1.5
        ENDIF
        IF KEYWORD_SET(PlotLocatLines) AND KEYWORD_SET(Horizonal) AND N_ELEMENTS(XRange) EQ 2 AND NOT KEYWORD_SET(DoNotPlot) THEN BEGIN
            PLOTS, [XRange], [BarWallLocat[i],BarWallLocat[i]], Color=cgColor('Charcoal'), LineStyle=2, Thick=1.5
        ENDIF
    ENDFOR
    
;    ; Plot Bin PlotHistoTexts
;    FOR i=0,N_ELEMENTS(BarRoofHisto)-1 DO BEGIN
;        IF KEYWORD_SET(VERTICAL) THEN BEGIN
;            XYOUTS, BarRoofLocat[i], BarRoofHisto[i], ALIGNMENT=0.5, /Data
;        ENDIF
;        IF KEYWORD_SET(Horizonal) THEN BEGIN
;            XYOUTS, BarRoofHisto[i], BarRoofLocat[i], ALIGNMENT=0.0, /Data
;        ENDIF
;    ENDFOR
    
    ; Plot Title
    IF N_ELEMENTS(TitleText) EQ 1 AND NOT KEYWORD_SET(DoNotPlot) THEN BEGIN
        IF N_ELEMENTS(TitleCharSizeF) EQ 0 THEN TitleCharSizeF=1.0
        IF N_ELEMENTS(TitleCharThick) EQ 0 THEN TitleCharThick=3.5
        XYOUTS, 0.5*(!X.Window[0]+!X.Window[1]), !Y.Window[0]+0.9*(!Y.Window[1]-!Y.Window[0]), /Normal, $
                TitleText, CharSize=TitleCharSizeF, CharThick=TitleCharThick, Alignment=0.5
    ENDIF
    
    
    RETURN
END