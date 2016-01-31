PRO resolve_crab, dir_path
    
    ;; Crab Path
    CuPh = dir_path ;; (FILE_SEARCH(!DIR,'crab/',/TEST_DIR,/MARK_DIR))[0]
    PRINT, CuPh
    IF CuPh EQ '' THEN RETURN
    CD, CuPh, Current=PrPh
    
    
    ;; CrabString
    CD, 'crabstring'
    RESOLVE_ROUTINE, 'CrabStringClean', /COMPILE_FULL_FILE, /IS_FUNCTION ;; the filename.pro on disk must be all lowercase! 
    RESOLVE_ROUTINE, 'CrabStringFindWholeWord', /IS_FUNCTION
    RESOLVE_ROUTINE, 'CrabStringMatch', /IS_FUNCTION
    RESOLVE_ROUTINE, 'CrabStringReplace', /IS_FUNCTION
    RESOLVE_ROUTINE, 'CrabStringSplit', /IS_FUNCTION ;; called 'CrabStringReplace'
    RESOLVE_ROUTINE, 'CrabStringReadInfo', /IS_FUNCTION ;; called 'CrabStringReplace' and 'CrabStringSplit'
    RESOLVE_ROUTINE, 'cgsymbol', /IS_FUNCTION
    RESOLVE_ROUTINE, 'PrintValueWithError', /IS_FUNCTION ;; called 'cgsymbol'
    RESOLVE_ROUTINE, 'CrabString', /COMPILE_FULL_FILE, /EITHER
    CD, '..'
    
    
    ;; CrabFile
    CD, 'crabfile'
    RESOLVE_ROUTINE, 'crabdircheck', /IS_FUNCTION
    RESOLVE_ROUTINE, 'crabfilecheck', /IS_FUNCTION
    RESOLVE_ROUTINE, 'crabdirclean', /EITHER ;; called 'CrabDirCheck'
    RESOLVE_ROUTINE, 'convertps2pdf', /EITHER
    CD, '..'
    
    
    ;; CrabTable
    CD, 'crabtable'
    RESOLVE_ROUTINE, 'CrabTableReadInfo', /IS_FUNCTION
    RESOLVE_ROUTINE, 'CrabTableReadColumn', /IS_FUNCTION
    RESOLVE_ROUTINE, 'CrabTableReadRow', /IS_FUNCTION
    RESOLVE_ROUTINE, 'CrabTableReadItem', /IS_FUNCTION
    RESOLVE_ROUTINE, 'CrabTableWriteInfo', /EITHER
    RESOLVE_ROUTINE, 'CrabTableFilter', /EITHER
    CD, '..'
    
    ;; CrabTelescope
    CD, 'crabteles'
    RESOLVE_ROUTINE, 'CrabTelescope', /COMPILE_FULL_FILE, /EITHER
    CD, '..'
    
    ;; CrabImage
    CD, 'crabimage'
    RESOLVE_ROUTINE, 'CrabImageStat', /COMPILE_FULL_FILE, /EITHER
    CD, '..'
    
    ;; Return
    CD, PrPh
    
END
