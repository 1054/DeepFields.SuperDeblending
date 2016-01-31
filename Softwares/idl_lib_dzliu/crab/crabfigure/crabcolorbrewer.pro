; 
; provide a list of colors
; 
FUNCTION CrabColorBrewer, BrColorIndex, Colorfull=Colorfull
    
    ; Firebrick - Red - Orange - Yellow - Grass - Green - Naval - Blue - Purple
    ; BrColors = ['42019e'xL,'4f3ed5'xL,'436df4'xL,'61aefd'xL,'8be0fe'xL,'bfffff'xL,'98f5e6'xL,'a4ddab'xL,'a5c266'xL,'bd8832'xL,'a24f5e'xL]
    BrColors = ['42019e'xL,'4f3ed5'xL,'436df4'xL,'61aefd'xL,'8be0fe'xL,'a4ddab'xL,'a5c266'xL,'bd8832'xL,'a24f5e'xL]
    
    IF KEYWORD_SET(Colorfull) THEN BEGIN
        BrColors = ['7f0000'xL,'4865ef'xL,'9ed4fd'xL,'8eddad'xL,'438423'xL,'294500'xL,'c4cc7b'xL,'be8c2b'xL,'814008'xL]
        ;            red        orange   light orange light green green   dark green   
    ENDIF
    
    
    IF N_ELEMENTS(BrColorIndex) GT 0 THEN BEGIN
        BrCI = BrColorIndex MOD (N_ELEMENTS(BrColors)-1)
        RETURN, BrColors[BrCI]
    ENDIF
    
    RETURN, BrColors
    
END