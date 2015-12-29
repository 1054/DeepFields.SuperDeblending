; 
; clean files or dirs under a dir
; 
PRO CrabDirClean,   DirPath,   CleanFileNamePattern = CleanFileNamePattern,  $
                                KeepFileNamePattern = KeepFileNamePattern, $
                                           MaxDepth = MaxDepth
    
    
    InputDirPath = DirPath
    IF NOT CrabDirCheck(InputDirPath) THEN MESSAGE, 'CrabDirClean: input dir path is invalid!'
    
    
    AllSubDirList = []
    AllSubFileList = []
    
    ; SubDirList
    TodoDirList = [{Depth:0,Path:DirPath}]
    TodoDepth = 0
    
    REPEAT BEGIN
        TodoDirList_OLD = TodoDirList
        TodoDirList_NEW = []
        TodoCount = N_ELEMENTS(TodoDirList_OLD)
        FOR TodoId=0,TodoCount-1 DO BEGIN
            IF TodoDirList_OLD[TodoId].Depth EQ TodoDepth THEN BEGIN
                
;               SubDirList = FILE_SEARCH(TodoDirList_OLD[TodoId].Path,'*',/TEST_DIR,/MARK_DIR)
;               SubFileList = FILE_SEARCH(TodoDirList_OLD[TodoId].Path,'*',/TEST_READ,/TEST_WRITE,/TEST_REGULAR)
                
                SubDirList = FILE_SEARCH(TodoDirList_OLD[TodoId].Path+'*',/TEST_DIR,/MARK_DIR)
                SubFileList = FILE_SEARCH(TodoDirList_OLD[TodoId].Path+'*',/TEST_READ,/TEST_WRITE,/TEST_REGULAR)
                
                IF SubDirList[0] NE '' THEN BEGIN ; have sub dirs
                    FOREACH SubDirPath, SubDirList DO BEGIN
                        AllSubDirList  = [  AllSubDirList, {Depth:TodoDepth+1,Path:SubDirPath}  ]
                        TodoDirList_NEW = [ TodoDirList_NEW, {Depth:TodoDepth+1,Path:SubDirPath} ]
                    ENDFOREACH
                ENDIF
                
                IF SubFileList[0] NE '' THEN BEGIN ; have sub files
                    FOREACH SubFilePath, SubFileList DO BEGIN
                        AllSubFileList = [ AllSubFileList, {Depth:TodoDepth+1,Path:SubFilePath} ]
                    ENDFOREACH
                ENDIF
            ENDIF
        ENDFOR
        TodoDirList = TodoDirList_NEW
        TodoDepth++
        IF N_ELEMENTS(MaxDepth) EQ 1 AND TodoDepth GT MaxDepth THEN TodoDirList=[]
    ENDREP UNTIL N_ELEMENTS(TodoDirList) EQ 0
    
    ; <TODO><TODO><TODO>
;    IF STRMATCH(!VERSION.OS_FAMILY,'*Windows*',/FOLD_CASE) THEN BEGIN
;        IF KEYWORD_SET(UseIDLInternalMode) THEN BEGIN
;            FILE_DELETE, /QUIET, 
;        ENDIF
;    ENDIF
    
    
    ;
    ; <TODO><TODO><TODO>
    ;
    
    
END