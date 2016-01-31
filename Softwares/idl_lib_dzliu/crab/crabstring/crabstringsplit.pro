; ------------------------------------------------------------------------------------------------------
; CrabStringSplit --- 
;                 if input "[1,2,3,4,5.3]" then output ["1","2","3","4","5.3"]
; ------------------------------------------------------------------------------------------------------
FUNCTION CrabStringSplit, Str, Splitter=Splitter, RemoveBrackets=RemoveBrackets, Compress=Compress
    IF N_PARAMS() LT 1 THEN BEGIN
        MESSAGE,'CrabStringSplit requires at least 1 parameter: Str.'
        RETURN,[]
    ENDIF
    SizeOfStr  = SIZE(Str)
    IF SizeOfStr[N_ELEMENTS(SizeOfStr)-2] NE 7 THEN BEGIN
        MESSAGE,'Parameter Str must be of string type.'
        RETURN,[]
    ENDIF
    ;;; Default Setting
    IF N_ELEMENTS(Splitter) LE 0       THEN Splitter=','
    IF N_ELEMENTS(RemoveBrackets) LE 0 THEN RemoveBrackets=1
    IF N_ELEMENTS(Compress) LE 0       THEN Compress=1
    ;;; Remove '='
    StrCopy = STRCOMPRESS(STRMID(Str,strpos(Str,'=')+1),/REMOVE_ALL)
    ;;; Remove Brackets
    StrCopy = CrabStringReplace(StrCopy,'{',' ')
    StrCopy = CrabStringReplace(StrCopy,'}',' ')
    StrCopy = CrabStringReplace(StrCopy,'[',' ')
    StrCopy = CrabStringReplace(StrCopy,']',' ')
    StrCopy = CrabStringReplace(StrCopy,'(',' ')
    StrCopy = CrabStringReplace(StrCopy,')',' ')
;    ;;; Remove Brackets
;    IF RemoveBrackets GE 1 THEN BEGIN
;        StrNew = StrCopy
;        ;;; Remove 3 Types of Brackets
;        BracketPairs = [ ['{','}'], ['[',']'], ['(',')'] ]
;        FOR j=0,2 DO BEGIN
;            Pos1 = STRPOS(StrCopy,BracketPairs[0,j])
;            Pos2 = STRPOS(StrCopy,BracketPairs[1,j])
;            IF Pos1 GE 0 AND Pos2 GE 0 AND Pos2 GT Pos1 THEN $
;                      StrNew = STRMID(StrCopy,Pos1+1,Pos2-Pos1-1)
;            IF STRPOS(StrNew,Splitter) GE 0 THEN StrCopy = StrNew
;        ENDFOR
;    ENDIF
    ;;; Compress
    IF Compress GE 1 AND STRPOS(Splitter,' ') LE -1 THEN BEGIN
        StrCopy = STRCOMPRESS(StrCopy,/REMOVE_ALL)
    ENDIF
    ;;; Extract
    StrSplit   = STRSPLIT(StrCopy,Splitter,/EXTRACT,/REGEX)
    RETURN,      StrSplit
END