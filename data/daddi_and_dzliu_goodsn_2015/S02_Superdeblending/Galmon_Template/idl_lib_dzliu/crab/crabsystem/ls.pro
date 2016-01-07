PRO ls, File=File
    lscommand = 'ls'
    IF STRMATCH(!VERSION.OS_FAMILY,'Windows*',/FOLD_CASE) THEN BEGIN
        lscommand = 'dir /b'
    ENDIF
    IF STRMATCH(!VERSION.OS_FAMILY,'unix*',/FOLD_CASE) THEN BEGIN
        lscommand = 'ls'
    ENDIF
    IF N_ELEMENTS(File) GE 1 THEN BEGIN
        spawn,lscommand+' '+'"'+File+'"',output
    ENDIF ELSE BEGIN
        spawn,lscommand,output
    ENDELSE
    IF STRMATCH(!VERSION.OS_FAMILY,'Windows*',/FOLD_CASE) THEN BEGIN
        print, output
    ENDIF
    IF STRMATCH(!VERSION.OS_FAMILY,'unix*',/FOLD_CASE) THEN BEGIN
        print, output
    ENDIF
END