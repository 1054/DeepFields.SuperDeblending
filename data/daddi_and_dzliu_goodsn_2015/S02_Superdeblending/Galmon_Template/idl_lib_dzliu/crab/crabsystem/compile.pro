PRO compile, Dir, Depth=Depth, FOLD_CASE=FOLD_CASE, Verbose=Verbose
    
    ;;;--- Check Input Variables ---;;;
    IF N_PARAMS() LT 1 THEN BEGIN
        PRINT, 'Usage:'
        PRINT, '    compile, Dir, Depth=Depth, FOLD_CASE=FOLD_CASE, Verbose=Verbose'
        PRINT, 'Aim:'
        PRINT, '    Search and compile all idl pro files under a certain directory.'
        PRINT, '    If Depth is set larger than 1, then subdirectories with '
        PRINT, '    depth smaller than Depth will be searched as well.'
        RETURN
    ENDIF
    
    ;;;--- Check Input Depth ---;;;
    IF N_ELEMENTS(Depth) EQ 0 THEN Depth=1
    IF Depth LE 0 THEN RETURN
    
    ;;;--- Check Input Directory ---;;;
    SearchDir = FILE_SEARCH(Dir,/MARK_DIRECTORY,FOLD_CASE=FOLD_CASE,$
                            /FULLY_QUALIFY_PATH,/EXPAND_ENVIRONMENT,/EXPAND_TILDE)
    IF SearchDir EQ "" THEN RETURN
    IF N_ELEMENTS(SearchDir) GT 1 THEN SearchDir=SearchDir[0]
    IF KEYWORD_SET(Verbose) THEN $
        PRINT,'Searching pro files under "'+SearchDir+'" within '+STRTRIM(Depth,2)+' depth ...'
    
    ;;;--- Check IDL !PATH ---;;;
    IDL_PATH_BACKUP = !PATH
    ;;;--- Add to IDL !PATH ---;;;
    IF NOT STRMATCH(!PATH,'*'+SearchDir+'*') THEN $
        !PATH = !PATH+':'+SearchDir
    
    CurrentDepth = Depth
    CurrentDirs  = [SearchDir]
    WHILE CurrentDepth GE 1 DO BEGIN
        IF KEYWORD_SET(Verbose) THEN PRINT,''
        IF KEYWORD_SET(Verbose) THEN PRINT,'*************************** Current Depth '+$
                                           STRTRIM(Depth-CurrentDepth+1,2)+ ' '+$
                                           '***************************'
        IF KEYWORD_SET(Verbose) THEN PRINT,CurrentDirs
        NextDirs = []
        FOREACH CurrentDir,CurrentDirs DO BEGIN
            ;;;
            ;;;--- Check Current Directory ---;;;
            IF CurrentDir EQ "" THEN CONTINUE
            ;;;
            ;;;--- Add to IDL !PATH ---;;;
            IF NOT STRMATCH(!PATH,'*'+CurrentDir+'*') THEN $
                !PATH = !PATH+':'+CurrentDir
            ;;; 
            IF KEYWORD_SET(Verbose) THEN PRINT,''
            IF KEYWORD_SET(Verbose) THEN PRINT,CurrentDir+'*.pro'
            ;;;
            ;;;--- Search *.pro in Current Directory ---;;;
            SubPros = FILE_SEARCH(CurrentDir+'*.pro',/TEST_READ,FOLD_CASE=FOLD_CASE,$
                                  /FULLY_QUALIFY_PATH,/EXPAND_ENVIRONMENT,/EXPAND_TILDE)
            ;;;
            ;;;--- Compile *.pro in Current Directory ---;;;
            FOREACH SubPro, SubPros DO BEGIN
                IF SubPro NE "" THEN BEGIN
                    ;.compile "'"+SubPro+"'"
                    SubProName = FILE_BASENAME(SubPro)   ; get pro name
                    SubProName = STRMID(SubProName,0,STRLEN(SubProName)-4)
                    cc = EXECUTE("PRINT,SubProName")
                    cc = EXECUTE("RESOLVE_ROUTINE,"+"'"+SubProName+"'"+",/COMPILE_FULL_FILE,/EITHER")
                    cc = EXECUTE("RESOLVE_ROUTINE,"+"'"+SubProName+"'"+",/COMPILE_FULL_FILE,/EITHER") ; repeat in case sometimes failed <20150206>
                    ;;;;;;;PRINT,SubProName
                    ;;;;;;;RESOLVE_ALL,"'"+SubProName+"'",/CONTINUE_ON_ERROR
                ENDIF
            ENDFOREACH
            ;;;
            ;;;--- Search SubDirs in Current Directory ---;;;
            SubDirs = FILE_SEARCH(CurrentDir+'*',/MARK_DIRECTORY,/TEST_DIR,FOLD_CASE=FOLD_CASE,$
                                  /FULLY_QUALIFY_PATH,/EXPAND_ENVIRONMENT,/EXPAND_TILDE)
            ;;;
            ;;;--- Prepare Next Search Directories ---;;;
            NextDirs = [NextDirs, SubDirs]
        ENDFOREACH
        CurrentDepth = CurrentDepth-1
        CurrentDirs = NextDirs
    ENDWHILE
    RESOLVE_ALL,/CONTINUE_ON_ERROR
    !PATH=IDL_PATH_BACKUP
END