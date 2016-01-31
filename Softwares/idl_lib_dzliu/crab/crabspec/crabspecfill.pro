; 
; This code will fill a spectrum
; 
PRO CrabSpecFill, freq, flux, Velocity=Velocity, BarStyle=BarStyle, Histogram=Histogram, THICK=THICK, COLOR=COLOR, LINE_FILL=LINE_FILL, ORIENTATION=ORIENTATION, SPACING=SPACING
    
    ; check input
    IF N_ELEMENTS(freq) EQ 0 THEN MESSAGE, 'CrabSpecFill: Error! freq contains no data!'
    IF N_ELEMENTS(flux) EQ 0 THEN MESSAGE, 'CrabSpecFill: Error! flux contains no data!'
    IF N_ELEMENTS(freq) EQ 1 THEN MESSAGE, 'CrabSpecFill: Error! freq contains only one data point!'
    IF N_ELEMENTS(flux) EQ 1 THEN MESSAGE, 'CrabSpecFill: Error! flux contains only one data point!'
    IF N_ELEMENTS(flux) NE N_ELEMENTS(freq) THEN MESSAGE, 'CrabSpecFill: Error! flux and freq have different dimensions!'
    
    ; check keywords
    IF KEYWORD_SET(Histogram) THEN BarStyle=1
    
    ; use polyfill to fill the space under spectrum
    FOR i=0,N_ELEMENTS(freq)-1 DO BEGIN
        IF i EQ N_ELEMENTS(freq)-1 THEN half_freq = (freq[i]-freq[i-1])/2.0 ELSE half_freq = (freq[i+1]-freq[i])/2.0
        IF KEYWORD_SET(BarStyle) THEN BEGIN
            IF flux[i] GT 0 THEN BEGIN
                POLYFILL, [freq[i]-half_freq,freq[i]-half_freq,freq[i]+half_freq,freq[i]+half_freq], $
                          [0.00000          ,flux[i]          ,flux[i]          ,0.00000          ], $
                          THICK=THICK, COLOR=COLOR, LINE_FILL=LINE_FILL, ORIENTATION=ORIENTATION, SPACING=SPACING
            ENDIF
        ENDIF ELSE BEGIN
            IF i LT N_ELEMENTS(freq)-1 THEN BEGIN
                IF (flux[i] GT 0 OR flux[i+1] GT 0) THEN BEGIN
                POLYFILL, [freq[i],freq[i],freq[i+1],freq[i+1]], $
                          [0.00000,flux[i],flux[i+1],0.0000000], $
                          THICK=THICK, COLOR=COLOR, LINE_FILL=LINE_FILL, ORIENTATION=ORIENTATION, SPACING=SPACING
                ENDIF
            ENDIF
        ENDELSE
    ENDFOR
    
END