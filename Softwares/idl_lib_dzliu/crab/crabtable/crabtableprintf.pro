; Print the content of a table to a file. 
; 
; Last update: 2018-01-22, Format for all columns.
; 
; Example:
;     dfmt = read_table('GOODSN_FIR+mm_Catalog_20170905_all_columns_v7.colfmt.txt', /TEXT)
;     dtab = read_table('GOODSN_FIR+mm_Catalog_20170905_all_columns_v7.ascii.txt', HEAD=1)
;     CrabTablePrintF, 'GOODSN_FIR+mm_Catalog_20170905_all_columns_v7.ascii.cds', dtab, format=dfmt[2,*], padding=' '
; 
PRO CrabTablePrintF, FilePathOrFileUnit, TableDataArray, Format=Format, Padding=Padding, APPEND=APPEND, $
                                                         PrependColumn1=PrependColumn1, PrependFormat1=PrependFormat1, $
                                                         PrependColumn2=PrependColumn2, PrependFormat2=PrependFormat2, $
                                                         PrependColumn3=PrependColumn3, PrependFormat3=PrependFormat3
    
    ; check table data
    IF SIZE(TableDataArray,/N_DIM) NE 2 THEN BEGIN
      MESSAGE, 'CrabTablePrintF: TableDataArray is not two-dimension! '
    ENDIF
    
    ; check output file
    IF SIZE(FilePathOrFileUnit,/TNAME) EQ 'UNDEFINED' THEN BEGIN
        MESSAGE, 'CrabTablePrintF: FilePathOrFileUnit is not set! '
    ENDIF ELSE IF SIZE(FilePathOrFileUnit,/TNAME) EQ 'LONG' THEN BEGIN
        OutputFileUnit = FilePathOrFileUnit
    ENDIF ELSE IF SIZE(FilePathOrFileUnit,/TNAME) EQ 'STRING' THEN BEGIN
        OutputFilePath = FilePathOrFileUnit
        OPENW, OutputFileUnit, OutputFilePath, /GET_LUN, APPEND=APPEND
    ENDIF ELSE BEGIN
        MESSAGE, 'CrabTablePrintF: FilePathOrFileUnit is invalid! '+FilePathOrFileUnit
    ENDELSE
    
    ; check table dimension
    TableDim = SIZE(TableDataArray,/DIM)
    
    ; check format
    IF SIZE(Format,/TNAME) EQ 'STRING' THEN BEGIN
        OutputFormat = Format
    ENDIF
    
    ; loop each row (line)
    FOR YId = 0, TableDim[1]-1 DO BEGIN
        OutputLine = ''
        IF N_ELEMENTS(PrependColumn1) EQ TableDim[1] THEN BEGIN
            OutputLine = OutputLine + STRING(FORMAT=PrependFormat1,PrependColumn1[YId])
        ENDIF
        IF N_ELEMENTS(PrependColumn2) EQ TableDim[1] THEN BEGIN
            OutputLine = OutputLine + STRING(FORMAT=PrependFormat2,PrependColumn2[YId])
        ENDIF
        IF N_ELEMENTS(PrependColumn3) EQ TableDim[1] THEN BEGIN
            OutputLine = OutputLine + STRING(FORMAT=PrependFormat3,PrependColumn3[YId])
        ENDIF
        ; loop each col (cell)
        FOR XId = 0, TableDim[0]-1 DO BEGIN
            ; determine col format
            IF N_ELEMENTS(OutputFormat) GT 0 AND XId LE N_ELEMENTS(OutputFormat) THEN BEGIN
                XFmt = OutputFormat[XId]
                IF STRMID(XFmt,0,1) NE '(' THEN XFmt = '('+XFmt
                IF STRMID(XFmt,STRLEN(XFmt)-1,1) NE '(' THEN XFmt = XFmt+')'
            ENDIF ELSE BEGIN
                XFmt = !NULL
            ENDELSE
            ; append cell string
            OutputText = ''
            OutputText = STRING(FORMAT=XFmt,TableDataArray[XId,YId])
            OutputLine = OutputLine + OutputText
            ; padding
            IF N_ELEMENTS(Padding) GT 0 THEN BEGIN
                IF XId NE TableDim[0]-1 THEN BEGIN
                    OutputLine = OutputLine + Padding
                ENDIF
            ENDIF
        ENDFOR
        ; print one row (line)
        PRINTF, OutputFileUnit, OutputLine
    ENDFOR
    
    ;;;Close
    CLOSE, OutputFileUnit
    FREE_LUN, OutputFileUnit
    
END