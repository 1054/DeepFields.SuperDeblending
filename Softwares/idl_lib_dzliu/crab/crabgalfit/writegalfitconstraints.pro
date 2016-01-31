

PRO writeGalfitConstraints, INPUT_File, Pix_X, Pix_Y, Constraint_Mag=Constraint_Mag, Constraint_X=Constraint_X, Constraint_Y=Constraint_Y
    
    IF N_ELEMENTS(Constraint_Mag) EQ 0 AND N_ELEMENTS(Constraint_X) EQ 0 AND N_ELEMENTS(Constraint_Y) EQ 0 THEN BEGIN
        INPUT_File="none"
        RETURN
    ENDIF
    
    IF N_ELEMENTS(Pix_X) NE N_ELEMENTS(Pix_Y) THEN BEGIN
        RETURN
    ENDIF
    
    Pix_N = N_ELEMENTS(Pix_X)
    
    OPENW, FileUnit, INPUT_File, /GET_LUN
    
    IF N_ELEMENTS(Constraint_Mag) GE 2 THEN BEGIN
        FOR i=0,N_ELEMENTS(Pix_X)-1 DO BEGIN
            IF N_ELEMENTS(Constraint_Mag) GT (2*i+0) THEN Constraint_Mag_1 = Constraint_Mag[2*i+0] ELSE Constraint_Mag_1 = Constraint_Mag[0]
            IF N_ELEMENTS(Constraint_Mag) GT (2*i+1) THEN Constraint_Mag_2 = Constraint_Mag[2*i+1] ELSE Constraint_Mag_2 = Constraint_Mag[1]
            PRINTF, FileUnit, STRING(FORMAT='(I6,"   mag ",F0.2,"  to  ",F0.2)',i+1,Constraint_Mag_1,Constraint_Mag_2)
        ENDFOR
    ENDIF
    
    IF N_ELEMENTS(Constraint_X) GE 2 THEN BEGIN
        FOR i=0,N_ELEMENTS(Pix_X)-1 DO BEGIN
            IF N_ELEMENTS(Constraint_X) GT (2*i+0) THEN Constraint_X_1 = Constraint_X[2*i+0] ELSE Constraint_X_1 = Constraint_X[0]
            IF N_ELEMENTS(Constraint_X) GT (2*i+1) THEN Constraint_X_2 = Constraint_X[2*i+1] ELSE Constraint_X_2 = Constraint_X[1]
            PRINTF, FileUnit, STRING(FORMAT='(I6,"   x ",F0.2,"    ",F0.2)',i+1,Constraint_X_1,Constraint_X_2)
        ENDFOR
    ENDIF
    
    IF N_ELEMENTS(Constraint_Y) GE 2 THEN BEGIN
        FOR i=0,N_ELEMENTS(Pix_Y)-1 DO BEGIN
            IF N_ELEMENTS(Constraint_Y) GT (2*i+0) THEN Constraint_Y_1 = Constraint_Y[2*i+0] ELSE Constraint_Y_1 = Constraint_Y[0]
            IF N_ELEMENTS(Constraint_Y) GT (2*i+1) THEN Constraint_Y_2 = Constraint_Y[2*i+1] ELSE Constraint_Y_2 = Constraint_Y[1]
            PRINTF, FileUnit, STRING(FORMAT='(I6,"   y ",F0.2,"    ",F0.2)',i+1,Constraint_Y_1,Constraint_Y_2)
        ENDFOR
    ENDIF
    
    PRINTF, FileUnit, ''
    CLOSE,  FileUnit
    FREE_LUN, FileUnit
END