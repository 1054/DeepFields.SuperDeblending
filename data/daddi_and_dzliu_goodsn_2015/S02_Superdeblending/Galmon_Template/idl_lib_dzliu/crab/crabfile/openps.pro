; 
; Updated: 2014-06-26 openPS
; 
PRO OpenPS, PSFile, XSize=XSizeInCM, YSize=YSizeInCM
    
    IF SIZE(PSFile,/TNAME) NE 'STRING' THEN MESSAGE, 'Usage: OpenPS, PSFile'
    IF NOT STRMATCH(PSFile,'*.ps',/F) AND NOT STRMATCH(PSFile,'*.eps',/F) THEN MESSAGE, 'Example: OpenPS, "/tmp/look.eps"'
    
    IF !D.Name EQ 'PS' THEN BEGIN
        DEVICE, /CLOSE
    ENDIF
    
    SET_PLOT, 'PS'
    DEVICE, FILENAME=PSFile, /COLOR, BITS_PER_PIXEL=8, DECOMPOSED=1, /ENCAPSULATED, XSIZE=XSizeInCM, YSIZE=YSizeInCM, LANGUAGE_LEVEL=2, SET_FONT='NGC', /TT_FONT
    
    PRINT, 'OpenPS: '+PSFile
    
END