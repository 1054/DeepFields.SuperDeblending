; Test whether a directory exists. 
; If exist, return 1, and replace the input directory variable with a fully qualified path. 
; else return 0.
FUNCTION CrabDirCheck, InputDir, GiveError=GiveError, MakeDir=MakeDir
    ; if input is !NULL then return false
    IF N_ELEMENTS(InputDir) EQ 0 THEN BEGIN
        IF KEYWORD_SET(GiveError) THEN MESSAGE, 'CrabDirCheck: InputDir is empty string!'
        RETURN, 0
    ENDIF
    ; 
    TestDir = FILE_SEARCH( InputDir, /MARK_DIRECTORY, $
                           /EXPAND_ENVIRONMENT, /EXPAND_TILDE, /FOLD_CASE, /FULLY_QUALIFY_PATH)
    IF N_ELEMENTS(TestDir) EQ 0 THEN BEGIN
        IF KEYWORD_SET(GiveError) THEN MESSAGE, 'CrabDirCheck: InputDir '+InputDir+' does not exist!'
        IF KEYWORD_SET(MakeDir) THEN BEGIN FILE_MKDIR,InputDir & CheckAgain=CrabDirCheck(InputDir) & ENDIF
        IF KEYWORD_SET(CheckAgain) THEN RETURN, 1 ELSE RETURN, 0
    ENDIF
    TestDir = TestDir[0]
    IF TestDir EQ "" THEN BEGIN
        IF KEYWORD_SET(GiveError) THEN MESSAGE, 'CrabDirCheck: InputDir '+InputDir+' does not exist!'
        IF KEYWORD_SET(MakeDir) THEN BEGIN FILE_MKDIR,InputDir & CheckAgain=CrabDirCheck(InputDir) & ENDIF
        IF KEYWORD_SET(CheckAgain) THEN RETURN, 1 ELSE RETURN, 0
    ENDIF
    InputDir = TestDir
    RETURN, 1
END