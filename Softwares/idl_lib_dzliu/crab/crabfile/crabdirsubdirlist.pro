; 
; List all subdirs under an InputDir
; 
; PRINT, CrabDirSubDirList('/Appli*/exelis/idl/lib/cr*')
; 
FUNCTION CrabDirSubDirList, InputDirPattern
    InputDirList = FILE_SEARCH( InputDirPattern, /MARK_DIRECTORY, $
                               /EXPAND_ENVIRONMENT, /EXPAND_TILDE, /FOLD_CASE, /FULLY_QUALIFY_PATH)
    IF N_ELEMENTS(InputDirList) EQ 0 THEN RETURN, []
    
    ; OK, now we got the existed InputDirList
    AllSubDirList = []
    FOREACH InputDirPath, InputDirList DO BEGIN
        OneSubDirList = FILE_SEARCH(InputDirPath+'*',/TEST_DIR,/MARK_DIR,/FULLY_QUALIFY_PATH)
        FOREACH OneSubDirPath, OneSubDirList DO BEGIN
            IF OneSubDirPath NE '' THEN AllSubDirList = [ AllSubDirList, OneSubDirPath ]
        ENDFOREACH
    ENDFOREACH
    
    ; Return
    RETURN, AllSubDirList
END