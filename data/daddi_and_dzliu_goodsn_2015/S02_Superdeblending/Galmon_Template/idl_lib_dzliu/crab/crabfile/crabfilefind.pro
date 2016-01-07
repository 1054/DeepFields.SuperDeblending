; Find a file which exists. 
; return the fully qualified path. 
; 
FUNCTION CrabFileFind, SearchPattern, AllFiles=AllFiles
    TestFile = FILE_SEARCH( SearchPattern, /TEST_READ, $
                            /EXPAND_ENVIRONMENT, /EXPAND_TILDE, /FOLD_CASE, /FULLY_QUALIFY_PATH)
    AllFiles = []
    
    IF N_ELEMENTS(TestFile) EQ 0 THEN BEGIN
        MESSAGE, 'CrabFileFind: Could not find any file according to the search pattern '+SearchPattern
        RETURN, !NULL
    ENDIF
    
    OutputFile = TestFile[0]
    IF OutputFile EQ "" THEN BEGIN
        MESSAGE, 'CrabFileFind: Could not find any file according to the search pattern '+SearchPattern
        RETURN, !NULL
    ENDIF
    
    AllFiles = TestFile
    RETURN, OutputFile
END