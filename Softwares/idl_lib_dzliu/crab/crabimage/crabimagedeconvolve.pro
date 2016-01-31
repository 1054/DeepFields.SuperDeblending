; 
; This program will deconvolve an image
; 
; 
; 
; 
FUNCTION CrabImageDeconvolve, GalaxyImage, PsfImage, IterationLimit=IterationLimit, 
    
    IF N_ELEMENTS(IterationLimit) EQ 0 THEN IterationLimit=50
    
    IdealImage = 
    VagueImage = 
    
END