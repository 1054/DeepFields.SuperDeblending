PRO JointPDF, SaveFile, InputFileList
    
    ; SaveFile is some xxx.pdf
    
    IF STRMATCH(!VERSION.OS_FAMILY,'*Windows*',/FOLD_CASE) THEN BEGIN
        ExecStr = 'D: & cd D:\GreenSoftware\GhostScript\9.06\bin & '
        ExecStr = ExecStr + 'gswin32.exe -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE="'+SaveFile+'"  -dBATCH '
        FOREACH InputFilePath, InputFileList DO BEGIN
            ExecStr = ExecStr + '"' + InputFilePath + '"' + ' '
        ENDFOREACH
        SPAWN, CrabStringReplace(ExecStr,'/','\')
    ENDIF
    IF STRMATCH(!VERSION.OS_FAMILY,'*unix*',/FOLD_CASE) THEN BEGIN
        ExecStr = 'cd "'+FILE_DIRNAME(SaveFile)+'" & '
        ExecStr = ExecStr + 'gs -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE="'+SaveFile+'"  -dBATCH '
        FOREACH InputFilePath, InputFileList DO BEGIN
            ExecStr = ExecStr + '"' + InputFilePath + '"' + ' '
        ENDFOREACH
        ExecStr = ExecStr + ' & pause()'
        SPAWN, ExecStr
    ENDIF
    
    PRINT, 'JointPDF: OUTPUT '+SaveFile
    
END