; 
; divide the first input ValueWithError1 by the second input ValueWithError2 with errors
; the new error will calculated according to error propagation law
; 
FUNCTION CrabStatDivide, ValueWithError1, ValueWithError2
    
    IF N_ELEMENTS(ValueWithError1) EQ 0 OR N_ELEMENTS(ValueWithError2) EQ 0 THEN BEGIN
        MESSAGE, 'CrabStatisticMultiply: input values are invalid!'
    ENDIF
    
    ; if input is data structure
    InputValue1 = 0.0D
    InputError1 = 0.0D
    IF SIZE(ValueWithError1,/TNAME) EQ 'STRUCT' THEN BEGIN 
        IF CrabStringMatch(TAG_NAMES(ValueWithError1),['VALUE','ERROR'],/YES_OR_NO) THEN BEGIN
            InputValue1 = DOUBLE(ValueWithError1.VALUE)
            InputError1 = DOUBLE(ValueWithError1.ERROR)
        ENDIF
    ENDIF
    IF SIZE(ValueWithError1,/TNAME) NE 'STRUCT' THEN BEGIN
        IF N_ELEMENTS(ValueWithError1) GE 2 THEN BEGIN
            InputValue1 = DOUBLE(ValueWithError1[0])
            InputError1 = DOUBLE(ValueWithError1[1])
        ENDIF
    ENDIF
    
    InputValue2 = 0.0D
    InputError2 = 0.0D
    IF SIZE(ValueWithError2,/TNAME) EQ 'STRUCT' THEN BEGIN 
        IF CrabStringMatch(TAG_NAMES(ValueWithError2),['VALUE','ERROR'],/YES_OR_NO) THEN BEGIN
            InputValue2 = DOUBLE(ValueWithError2.VALUE)
            InputError2 = DOUBLE(ValueWithError2.ERROR)
        ENDIF
    ENDIF
    IF SIZE(ValueWithError2,/TNAME) NE 'STRUCT' THEN BEGIN
        IF N_ELEMENTS(ValueWithError2) GE 2 THEN BEGIN
            InputValue2 = DOUBLE(ValueWithError2[0])
            InputError2 = DOUBLE(ValueWithError2[1])
        ENDIF
    ENDIF
    
    ; multiply
    NewValue = 0.0
    NewError = 0.0
    IF InputValue1 NE 0.0 AND InputValue2 NE 0.0 AND InputError1 NE 0.0 AND InputError2 NE 0.0 THEN BEGIN
        NewError = SQRT( (InputError1/InputValue1)^2 + (InputError2/InputValue2)^2 )
    ENDIF
    IF FINITE(InputValue1) AND FINITE(InputValue2) THEN BEGIN
        NewValue = InputValue1 / InputValue2
    ENDIF
    IF InputValue1 NE 0.0 AND InputValue2 NE 0.0 AND InputError1 NE 0.0 AND InputError2 NE 0.0 THEN BEGIN
        NewError = NewError * NewValue
    ENDIF
    
    ; return
    RETURN, {Value:NewValue,Error:NewError}
    
END