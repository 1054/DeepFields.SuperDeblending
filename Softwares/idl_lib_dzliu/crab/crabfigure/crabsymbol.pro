; 
; format a given string to symcat or symbol
; symcat is for plot procedure, while symbol is for plot function
; e.g. CrabSymbol('CIRCLE',/SYMCAT) => cgSYMCAT('Filled Circle')
; 
FUNCTION CrabSymbol, InputString, COLOR=COLOR, FILLED=FILLED, SYMCAT=SYMCAT, SYMBOL=SYMBOL, THICK=THICK, $
                                  UPPERLIMIT=UPPERLIMIT ;<Added><20160430>; 
    
    IF N_ELEMENTS(InputString) GE 1 THEN SymType=InputString[0] ELSE RETURN,!NULL
    
    IF NOT KEYWORD_SET(SYMCAT) AND NOT KEYWORD_SET(SYMBOL) THEN SYMCAT = 1 ; defaultly we use plot_procedure
    IF     KEYWORD_SET(SYMCAT) AND     KEYWORD_SET(SYMBOL) THEN SYMBOL = 0 ; defaultly we use plot_procedure
    IF KEYWORD_SET(UPPERLIMIT) THEN SYMCAT = 0 ; upper limit mode
    
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
        
    ENDIF ELSE BEGIN
        
        ; plot as upper limit arrow 
        ; <Added><20160430>
        ; <TODO> NEED XValue YValue
        
                mArL = 3.0  ;; arrow root-to-top height/length
                mArS = 2.8  ;; arrow root-to-hat height/length
                mArH = 1.5  ;; arrow root-to-shouder height/length 
                mArW = 0.6  ;; arrow shouder width
                mArT = 0.02 ;; arrow root thick
                IF UPPERLIMIT EQ 3 THEN BEGIN                                                                                               ; Left-Down Arrow Symbol
                    USERSYM,[-0.06,-3.26,-2.8,-3.5,-1.0,-3.14,+0.04],[+0.06,-3.14,-1.0,-3.5,-2.8,-3.26,-0.06],THICK=THICK,COLOR=COLOR       ; Left-Down Arrow Symbol /FILL
                    OPLOT,XValue,YValue,PSYM=8,SYMSIZE=SymSize*0.7,THICK=THICK,COLOR=COLOR                                                  ; Show XYUpLimit
                ENDIF ELSE IF UPPERLIMIT EQ 2 THEN BEGIN                                                                                    ; Down Arrow Symbol
                    USERSYM,[-1.3,-1.3,1.3,1.3],[-0.07,0.07,0.07,-0.07],THICK=THICK,COLOR=COLOR,/FILL                                       ; Down Arrow Symbol
                    OPLOT,XValue,YValue,PSYM=8,SYMSIZE=SymSize*0.7,THICK=THICK,COLOR=COLOR                                                  ; Down Arrow Symbol
                    USERSYM,[-mArT,-mArT,-mArW,+0,+mArW,+mArT,+mArT],[+0,-mArS,-mArH,-mArL,-mArH,-mArS,+0],THICK=THICK,COLOR=COLOR          ; Down Arrow Symbol /FILL
                    OPLOT,XValue,YValue,PSYM=8,SYMSIZE=SymSize*0.7,THICK=THICK,COLOR=COLOR                                                  ; Show YUpLimit
                ENDIF ELSE IF UPPERLIMIT EQ 1 THEN BEGIN                                                                                    ; Left Arrow Symbol
                    USERSYM,[0,0],[+mArW,-mArW],THICK=THICK,COLOR=COLOR                                                                     ; Show XUpLimit
                    OPLOT,XValue,YValue,PSYM=8,SYMSIZE=SymSize*0.7,THICK=THICK,COLOR=COLOR                                                  ; Show XUpLimit
                    USERSYM,[+0,-mArS],[0,0],THICK=THICK,COLOR=COLOR                                                                        ; Show XUpLimit
                    OPLOT,XValue,YValue,PSYM=8,SYMSIZE=SymSize*0.7,THICK=THICK,COLOR=COLOR                                                  ; Show XUpLimit
                    USERSYM,[-mArH,-mArS,-mArH],[+mArW,0,-mArW],THICK=THICK,COLOR=COLOR                                                     ; Show XUpLimit
                    OPLOT,XValue,YValue,PSYM=8,SYMSIZE=SymSize*0.7,THICK=THICK,COLOR=COLOR                                                  ; Show XUpLimit
                ENDIF
        
    ENDELSE
    
    
    
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