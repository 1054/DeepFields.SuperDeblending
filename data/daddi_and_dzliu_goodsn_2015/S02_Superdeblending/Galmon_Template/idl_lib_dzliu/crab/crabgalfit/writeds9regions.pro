

PRO writeDS9Regions, INPUT_File, Pix_X, Pix_Y
    
    
    
    IF N_ELEMENTS(Pix_X) NE N_ELEMENTS(Pix_Y) THEN BEGIN
        RETURN
    ENDIF
    
    Pix_N = N_ELEMENTS(Pix_X)
    
    OPENW, FileUnit, INPUT_File, /GET_LUN
    PRINTF, FileUnit, "# Region file format: DS9 version 4.1"
    PRINTF, FileUnit, 'global color=green dashlist=8 3 width=1 font="helvetica 9 normal roman" select=1 highlite=1 dash=0 fixed=0 edit=1 move=0 delete=1 include=1 source=1'
    PRINTF, FileUnit, "image"
    
    FOR i=0,Pix_N-1 DO BEGIN
        PRINTF, FileUnit, FORMAT='("circle(", F0.3, ",", F0.3, ",5.0) # text={ID", I0, "} color=yellow")', Pix_X[i], Pix_Y[i], i+1
    ENDFOR
    
    PRINTF, FileUnit, ''
    CLOSE,  FileUnit
    FREE_LUN, FileUnit
END