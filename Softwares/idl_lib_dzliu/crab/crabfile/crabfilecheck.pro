; Test whether a file exists.
; If exist, return 1, and replace the input file path variable with a fully qualified path. 
; else return 0.
FUNCTION CrabFileCheck, InputFilePath, NOWARNING=NOWARNING, PREFIX=PREFIX, NOEXIST=NOEXIST
    ; set prefix
    IF N_ELEMENTS(PREFIX) EQ 0 THEN PREFIX="" ELSE PREFIX=PREFIX+": "
    ; check input file path variable type
    IF N_ELEMENTS(InputFilePath) NE 1 OR SIZE(InputFilePath,/TYPE) NE 7 THEN BEGIN
        IF NOT KEYWORD_SET(NOWARNING) THEN NULL = DIALOG_MESSAGE(PREFIX+'InputFilePath incorrect! Please check the input variable.')
        RETURN, 0 ; means FALSE
    ENDIF
    ; check input file exist
    IF NOT KEYWORD_SET(NOEXIST) THEN BEGIN
        TestFilePath = FILE_SEARCH( InputFilePath, /TEST_READ, /EXPAND_ENVIRONMENT, /EXPAND_TILDE, /FOLD_CASE, /FULLY_QUALIFY_PATH)
        IF N_ELEMENTS(TestFilePath) EQ 0 THEN RETURN, 0
        TestFilePath = TestFilePath[0]
    ENDIF ELSE BEGIN
        TestFilePath = InputFilePath
    ENDELSE
    IF TestFilePath EQ "" THEN BEGIN
        IF NOT KEYWORD_SET(NOWARNING) THEN NULL = DIALOG_MESSAGE(PREFIX+'InputFilePath '+InputFilePath+' does not exists!')
        RETURN, 0 ; means FALSE
    ENDIF
    InputFilePath = TestFilePath
    RETURN, 1
END
;FUNCTION CrabTestFilePath, InputDir, InputFileName, OutputFilePath=OutputFilePath
;    TestFilePath = FILE_SEARCH( InputDir, InputFileName, /TEST_READ, $
;                                /EXPAND_ENVIRONMENT, /EXPAND_TILDE, /FOLD_CASE, /FULLY_QUALIFY_PATH)
;    IF N_ELEMENTS(TestFilePath) EQ 0 THEN RETURN, 0
;    TestFilePath = TestFilePath[0]
;    IF TestFilePath EQ "" THEN RETURN, 0
;    OutputFilePath = TestFilePath
;    RETURN, 1
;END