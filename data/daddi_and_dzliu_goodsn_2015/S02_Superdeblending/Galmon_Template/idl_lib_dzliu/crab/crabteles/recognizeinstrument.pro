; 
; Please refer to CrabTelescope.pro
; 



FUNCTION RecognizeInstrument, InputText
    S_Instrument = ""
    SearchText = InputText
    ; SearchText = CrabStringClean(InputText,TextsToRemove=['_',' '])
    ; IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*ACS*F435W*',/FOLD_CASE) THEN S_Instrument = 'ACS'
    ; IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*ACS*F606W*',/FOLD_CASE) THEN S_Instrument = 'ACS'
    ; IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*ACS*F775W*',/FOLD_CASE) THEN S_Instrument = 'ACS'
    ; IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*ACS*F850L*',/FOLD_CASE) THEN S_Instrument = 'ACS'
    ; IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*WFC3*F105W*',/FOLD_CASE) THEN S_Instrument = 'WFC3'
    ; IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*WFC3*F125W*',/FOLD_CASE) THEN S_Instrument = 'WFC3'
    ; IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*WFC3*F160W*',/FOLD_CASE) THEN S_Instrument = 'WFC3'
    ; IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*IRAC1[^0-9]*',/FOLD_CASE) OR STRMATCH(SearchText,'*IRACch1*',/FOLD_CASE) THEN S_Instrument = 'IRAC'
    ; IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*IRAC2[^0-9]*',/FOLD_CASE) OR STRMATCH(SearchText,'*IRACch2*',/FOLD_CASE) THEN S_Instrument = 'IRAC'
    ; IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*IRAC3[^0-9]*',/FOLD_CASE) OR STRMATCH(SearchText,'*IRACch3*',/FOLD_CASE) THEN S_Instrument = 'IRAC'
    ; IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*IRAC4[^0-9]*',/FOLD_CASE) OR STRMATCH(SearchText,'*IRACch4*',/FOLD_CASE) THEN S_Instrument = 'IRAC'
    ; IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*PACS70*',/FOLD_CASE) OR STRMATCH(SearchText,'*PACS*BLUE*',/FOLD_CASE) THEN S_Instrument = 'PACS'
    ; IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*PACS100*',/FOLD_CASE) OR STRMATCH(SearchText,'*PACS*GREEN*',/FOLD_CASE) THEN S_Instrument = 'PACS'
    ; IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*PACS160*',/FOLD_CASE) OR STRMATCH(SearchText,'*PACS160*RED*',/FOLD_CASE) THEN S_Instrument = 'PACS'
    ; IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*SPIRE250*',/FOLD_CASE) OR STRMATCH(SearchText,'*SPIRE*PSW*',/FOLD_CASE) THEN S_Instrument = 'SPIRE'
    ; IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*SPIRE350*',/FOLD_CASE) OR STRMATCH(SearchText,'*SPIRE*PMW*',/FOLD_CASE) THEN S_Instrument = 'SPIRE'
    ; IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*SPIRE500*',/FOLD_CASE) OR STRMATCH(SearchText,'*SPIRE*PLW*',/FOLD_CASE) THEN S_Instrument = 'SPIRE'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^A-z]ACS[^A-z]*'       ,/FOLD_CASE) THEN S_Instrument = 'ACS'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^A-z]ACS'              ,/FOLD_CASE) THEN S_Instrument = 'ACS'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,       'ACS[^A-z]*'       ,/FOLD_CASE) THEN S_Instrument = 'ACS'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^A-z]WFC3[^A-z]*'      ,/FOLD_CASE) THEN S_Instrument = 'WFC3'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^A-z]WFC3'             ,/FOLD_CASE) THEN S_Instrument = 'WFC3'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,       'WFC3[^A-z]*'      ,/FOLD_CASE) THEN S_Instrument = 'WFC3'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^A-z]IRAC[^A-z]*'      ,/FOLD_CASE) THEN S_Instrument = 'IRAC'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^A-z]IRAC'             ,/FOLD_CASE) THEN S_Instrument = 'IRAC'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,       'IRAC[^A-z]*'      ,/FOLD_CASE) THEN S_Instrument = 'IRAC'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^A-z]MIPS[^A-z]*'      ,/FOLD_CASE) THEN S_Instrument = 'MIPS'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^A-z]MIPS'             ,/FOLD_CASE) THEN S_Instrument = 'MIPS'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,       'MIPS[^A-z]*'      ,/FOLD_CASE) THEN S_Instrument = 'MIPS'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^A-z]PACS[^A-z]*'      ,/FOLD_CASE) THEN S_Instrument = 'PACS'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^A-z]PACS'             ,/FOLD_CASE) THEN S_Instrument = 'PACS'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,       'PACS[^A-z]*'      ,/FOLD_CASE) THEN S_Instrument = 'PACS'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^A-z]SPIRE[^A-z]*'     ,/FOLD_CASE) THEN S_Instrument = 'SPIRE'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^A-z]SPIRE'            ,/FOLD_CASE) THEN S_Instrument = 'SPIRE'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,       'SPIRE[^A-z]*'     ,/FOLD_CASE) THEN S_Instrument = 'SPIRE'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^A-z]IRSX[^A-z]*'      ,/FOLD_CASE) THEN S_Instrument = 'IRSX'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^A-z]IRSX'             ,/FOLD_CASE) THEN S_Instrument = 'IRSX'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,       'IRSX[^A-z]*'      ,/FOLD_CASE) THEN S_Instrument = 'IRSX'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^A-z]WIRCAM[^A-z]*'    ,/FOLD_CASE) THEN S_Instrument = 'WIRCAM Ks' ; NIR imager at CFHT
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^A-z]WIRCAM'           ,/FOLD_CASE) THEN S_Instrument = 'WIRCAM Ks'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,       'WIRCAM[^A-z]*'    ,/FOLD_CASE) THEN S_Instrument = 'WIRCAM Ks'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^A-Z]MODS[^A-Z]*_J*'              ) THEN S_Instrument = 'Subaru J'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^A-Z]MODS_J*'                     ) THEN S_Instrument = 'Subaru J'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^A-Z]MODS[^A-Z]*_H*'              ) THEN S_Instrument = 'Subaru H'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^A-Z]MODS_H*'                     ) THEN S_Instrument = 'Subaru H'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^A-Z]MODS[^A-Z]*_K*'              ) THEN S_Instrument = 'Subaru Ks'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^A-Z]MODS_K*'                     ) THEN S_Instrument = 'Subaru Ks'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^A-Z]MODS[^A-Z]*'                 ) THEN S_Instrument = 'Subaru' ; NIR imager at Subaru (aka MOIRSC)
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^A-Z]MODS'                        ) THEN S_Instrument = 'Subaru'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,       'MODS[^A-Z]*'                 ) THEN S_Instrument = 'Subaru'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^A-z]wdriz[^A-z]*'     ,/FOLD_CASE) THEN S_Instrument = 'IRS PUI' ; IRS peak-up imaging (2 filters: 13-18 and 18-26 microns)
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^A-z]wdriz'            ,/FOLD_CASE) THEN S_Instrument = 'IRS PUI'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,       'wdriz[^A-z]*'     ,/FOLD_CASE) THEN S_Instrument = 'IRS PUI'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^A-z]VLA[^A-z]*'       ,/FOLD_CASE) THEN S_Instrument = 'VLA'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^A-z]VLA'              ,/FOLD_CASE) THEN S_Instrument = 'VLA'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,       'VLA[^A-z]*'       ,/FOLD_CASE) THEN S_Instrument = 'VLA'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^A-z]975ks[^A-z]*'     ,/FOLD_CASE) THEN S_Instrument = 'Chandra'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*1160*'                  ,/FOLD_CASE) THEN S_Instrument = '1.16mm'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*combined_maw0_4_azw0_5*',/FOLD_CASE) THEN S_Instrument = '1.16mm'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*pgh_goodsn_green*'      ,/FOLD_CASE) THEN S_Instrument = 'PACS 100'
    IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*pgh_goodsn_red*'        ,/FOLD_CASE) THEN S_Instrument = 'PACS 160'
    RETURN, S_Instrument
END
