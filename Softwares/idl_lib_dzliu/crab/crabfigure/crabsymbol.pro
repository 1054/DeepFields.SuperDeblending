; 
; format a given string to symcat or symbol
; symcat is for plot procedure, while symbol is for plot function
; e.g. CrabSymbol('CIRCLE',/SYMCAT) => cgSYMCAT('Filled Circle')
; 
FUNCTION CrabSymbol, InputString, COLOR=COLOR, FILLED=FILLED, SYMCAT=SYMCAT, SYMBOL=SYMBOL, THICK=THICK
    
    IF N_ELEMENTS(InputString) GE 1 THEN SymType=InputString[0] ELSE RETURN,!NULL
    
    IF NOT KEYWORD_SET(SYMCAT) AND NOT KEYWORD_SET(SYMBOL) THEN SYMCAT = 1 ; defaultly we use plot_procedure
    IF     KEYWORD_SET(SYMCAT) AND     KEYWORD_SET(SYMBOL) THEN SYMBOL = 0 ; defaultly we use plot_procedure
    
    

    IF KEYWORD_SET(SYMCAT) THEN BEGIN
        
        ; read input
        InputSymType = SymType
        
        ; arrows?
        IF STRMATCH(InputSymType,'*left*arrow*',/FOLD_CASE) THEN BEGIN
            USERSYM,[+0,-5.0,-2.5,-4.5,-2.5,-5.0],[+0,+0.0,-1.8,+0.0,+1.8,+0.0],COLOR=COLOR
            RETURN, 8
        ENDIF
        IF STRMATCH(InputSymType,'*down*arrow*',/FOLD_CASE) THEN BEGIN
            USERSYM,[+0,+0.0,-1.8,+0.0,+1.8,+0.0],[+0,-5.0,-2.5,-4.5,-2.5,-5.0],COLOR=COLOR
            RETURN, 8
        ENDIF
        IF STRMATCH(InputSymType,'*left*down*arrow*',/FOLD_CASE) THEN BEGIN
            USERSYM,[+0,-3.5,-2.8,-3.2,-1.0,-3.5],[+0,-3.5,-1.0,-3.2,-2.8,-3.5],COLOR=COLOR
            RETURN, 8
        ENDIF
        
        ; fill? open?
        IF STRMATCH(InputSymType,'*fill*',/FOLD_CASE) THEN FILLED=1
        IF STRMATCH(InputSymType,'*open*',/FOLD_CASE) THEN FILLED=0
        
        ; square?
        IF STRMATCH(InputSymType,'*square*',/FOLD_CASE) THEN BEGIN
            IF KEYWORD_SET(FILLED)  THEN SymType='Filled Square' ELSE SymType='Open Square'
        ENDIF
        
        ; diamond?
        IF STRMATCH(InputSymType,'*diamond*',/FOLD_CASE) THEN BEGIN 
            IF KEYWORD_SET(FILLED) THEN SymType='Filled Diamond' ELSE SymType='Open Diamond'
        ENDIF
        
        ; circle?
        IF STRMATCH(InputSymType,'*circle*',/FOLD_CASE) THEN BEGIN 
            IF KEYWORD_SET(FILLED) THEN SymType='Filled Circle' ELSE SymType='Open Circle'
        ENDIF
        
        ; circle x?
        IF STRMATCH(InputSymType,'*circle x*',/FOLD_CASE) THEN BEGIN 
            UserSym, [1,.866, .707, .500, 0,-.500,-.707,-.866,-1, $
                       -.866,-.707,-.500, 0, .500, .707, .866, 1, $
                        .866,.707,-.707,    0, .707,-.707], $
                     [0,.500, .707, .866, 1, .866, .707, .500, 0, $
                       -.500,-.707,-.866,-1,-.866,-.707,-.500, 0, $
                        .500,.707,-.707,    0,-.707, .707], THICK=THICK, COLOR=COLOR
            RETURN, 8
        ENDIF
        
        ; triangle?
        IF STRMATCH(InputSymType,'*triangle*',/FOLD_CASE) THEN BEGIN 
            IF KEYWORD_SET(FILLED) THEN SymType='Filled Up Triangle' ELSE SymType='Open Up Triangle'
        ENDIF
        
        ; down triangle?
        IF STRMATCH(InputSymType,'*down*triangle*',/FOLD_CASE) THEN BEGIN 
            IF KEYWORD_SET(FILLED) THEN SymType='Filled Down Triangle' ELSE SymType='Open Down Triangle'
        ENDIF
        
        ; return
        RETURN, cgSYMCAT(SymType,THICK=THICK,COLOR=COLOR)
    ENDIF
    
    
    
;    IF KEYWORD_SET(SYMBOL) THEN BEGIN
;        
;        ; arrows?
;        IF STRMATCH(SymType,'*left*arrow*',/FOLD_CASE) THEN BEGIN
;            ; <TODO>
;        ENDIF
;        IF STRMATCH(SymType,'*down*arrow*',/FOLD_CASE) THEN BEGIN
;            ; <TODO>
;        ENDIF
;        IF STRMATCH(SymType,'*left*down*arrow*',/FOLD_CASE) THEN BEGIN
;            ; <TODO>
;        ENDIF
;        
;        ; square?
;        IF STRMATCH(SymType,'*square*',/F)      THEN SymType='Square'
;        IF STRMATCH(SymType,'fill*square*',/F)  THEN FILLED=1
;        IF STRMATCH(SymType,'open*square*',/F)  THEN FILLED=0
;        
;        ; diamond?
;        IF STRMATCH(SymType,'*diamond*',/F)     THEN SymType='Diamond'
;        IF STRMATCH(SymType,'fill*diamond*',/F) THEN FILLED=1
;        IF STRMATCH(SymType,'open*diamond*',/F) THEN FILLED=0
;        
;        ; circle?
;        IF STRMATCH(SymType,'*circle*',/F)      THEN SymType='Circle'
;        IF STRMATCH(SymType,'fill*circle*',/F)  THEN FILLED=1
;        IF STRMATCH(SymType,'open*circle*',/F)  THEN FILLED=0
;        
;        ; return
;        RETURN, SymType
;    ENDIF
    
    RETURN, !NULL
    
END