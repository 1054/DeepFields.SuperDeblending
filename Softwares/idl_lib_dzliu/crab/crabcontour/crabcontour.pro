PRO CrabContour, InputArrayZ, InputArrayX, InputArrayY, $
                 Position=Position
    
    ; Get the current color table vectors.
    TVLCT, CC_R, CC_G, CC_B, /GET
    
    ; Set up PostScript device for working with colors.
    IF !D.Name EQ 'PS' THEN Device, COLOR=1, BITS_PER_PIXEL=8
    
    
    
    ; Color Number
    ncolors = 256
    
    ; Determine the position of the color bar in the window.
    IF KEYWORD_SET(vertical) THEN BEGIN
        
        bar = REPLICATE(1B,20) # BINDGEN(ncolors)
        
    ENDIF ELSE BEGIN
        
        bar = BINDGEN(ncolors) # REPLICATE(1B, 20)
        
    ENDELSE
    
    
    
END
