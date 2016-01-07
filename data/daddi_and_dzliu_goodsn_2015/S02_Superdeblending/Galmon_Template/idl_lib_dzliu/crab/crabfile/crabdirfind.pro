; Find a directory which exists. 
; return the fully qualified path. 
; 
FUNCTION CrabDirFind, SearchPattern, AllDirs=AllDirs
    TestDir = FILE_SEARCH( SearchPattern, /MARK_DIRECTORY, $
                           /EXPAND_ENVIRONMENT, /EXPAND_TILDE, /FOLD_CASE, /FULLY_QUALIFY_PATH)
    AllDirs = []
    
    IF N_ELEMENTS(TestDir) EQ 0 THEN BEGIN
        MESSAGE, 'CrabDirFind: Could not find any directory according to the search pattern '+SearchPattern
        RETURN, !NULL
    ENDIF
    
    OutputDir = TestDir[0]
    IF OutputDir EQ "" THEN BEGIN
        MESSAGE, 'CrabDirFind: Could not find any directory according to the search pattern '+SearchPattern
        RETURN, !NULL
    ENDIF
    
    AllDirs = TestDir
    RETURN, OutputDir
END