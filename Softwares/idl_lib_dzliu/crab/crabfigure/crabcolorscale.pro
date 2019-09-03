; 
; provide a list of colors
; 
FUNCTION CrabColorScale, Value, Value_Array, $
                         Value_Colors = Value_Colors, $
                         Value_Values = Value_Values, $
                         Rainbow = Rainbow, $
                         IceCream = IceCream
    
    IF NOT KEYWORD_SET(IceCream) AND $
       NOT KEYWORD_SET(SuperMongo) AND $
       NOT KEYWORD_SET(Rainbow) THEN BEGIN
        Rainbow = 1
    ENDIF
    
    IF KEYWORD_SET(IceCream) THEN BEGIN
        Value_Colors = [ '29C9FF'xL, $
                         '295EFF'xL, $
                         '5E29FF'xL, $
                         'C929FF'xL, $
                         'FF29C9'xL, $
                         'FF295E'xL, $
                         'FF5E29'xL, $
                         'FFC929'xL, $
                         'C9FF29'xL, $
                         '5EFF29'xL, $
                         '29FF5E'xL, $
                         '29FFC9'xL, $
                         '66D9FF'xL, $
                         'A3E8FF'xL, $
                         'FF8C66'xL, $
                         'FFBAA3'xL  ] ; 'RRGGBB'xL ; http://www.colorschemer.com/online.html Set RGB #29C9FF
    ENDIF
    
    IF KEYWORD_SET(Rainbow) THEN BEGIN
        Value_Colors = [ 'FF191B'xL, $
                         'FB5817'xL, $
                         'F79815'xL, $
                         'F3D713'xL, $
                         'CAF011'xL, $
                         '86EC10'xL, $
                         '43E80E'xL, $
                         '0CE417'xL, $
                         '0AE154'xL, $
                         '09DD91'xL, $
                         '07D9CC'xL, $
                         '05A6D5'xL, $
                         '0466D2'xL, $
                         '0227CE'xL, $
                         '1801CA'xL, $
                         '5000C7'xL  ]
    ENDIF
    
    IF N_ELEMENTS(Value_Array) EQ 0 THEN Value_Array = [0, 255]
    Value_Min = MIN(Value_Array,/NAN)
    Value_Max = MAX(Value_Array,/NAN)
    
    Value_Index = (Value - Value_Min) / (Value_Max - Value_Min) * (N_ELEMENTS(Value_Colors)-1)
    
    IF Value_Index GT (N_ELEMENTS(Value_Colors)-1) THEN BEGIN
        Value_Index = (N_ELEMENTS(Value_Colors)-1)
    ENDIF
    IF Value_Index LT 0 THEN BEGIN
        Value_Index = 0
    ENDIF
    
    ; Output a 'Value_Values' array corresponding to the 'Value_Colors' array. 
    Value_Values = []
    FOR i = 0, N_ELEMENTS(Value_Colors)-1 DO BEGIN
        Value_Values = [Value_Values, DOUBLE(i) / (N_ELEMENTS(Value_Colors)-1) * (Value_Max - Value_Min) + Value_Min]
    ENDFOR
    
    RETURN, Value_Colors[FIX(Value_Index)]
    
END