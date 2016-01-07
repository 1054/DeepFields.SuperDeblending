; 
; List all subfiles under an InputDir
; 
; PRINT, CrabDirSubFileList('/Appli*/exelis/idl/lib/cr*/cr*')
; 
FUNCTION CrabDirSubFileList, InputDirPattern
    InputDirList = FILE_SEARCH( InputDirPattern, /MARK_DIRECTORY, $
                               /EXPAND_ENVIRONMENT, /EXPAND_TILDE, /FOLD_CASE, /FULLY_QUALIFY_PATH)
    IF N_ELEMENTS(InputDirList) EQ 0 THEN RETURN, []
    
    ; OK, now we got the existed InputDirList
    AllSubFileList = []
    FOREACH InputDirPath, InputDirList DO BEGIN
        OneSubFileList = FILE_SEARCH(InputDirPath+'*',/TEST_READ,/FULLY_QUALIFY_PATH)
        FOREACH OneSubFilePath, OneSubFileList DO BEGIN
            IF OneSubFilePath NE '' THEN AllSubFileList = [ AllSubFileList, OneSubFilePath ]
        ENDFOREACH
    ENDFOREACH
    
    ; Return
    RETURN, AllSubFileList
END