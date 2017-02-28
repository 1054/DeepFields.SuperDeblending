; 
; Aim:
;     Please refer to CrabTelescope.pro
; 
; Last update: 
;     20170228 dzliu -- search by base name first, then by the full path. Added more matches. 
; 



FUNCTION RecognizeInstrument, InputText
    S_Instrument = ""
    SearchList = []
    
    IF STRPOS(InputText,'/') GE 0 AND STRPOS(InputText,'/',/REVERSE_SEARCH) LT STRLEN(InputText)-1 THEN BEGIN
        SearchList = [STRMID(InputText,STRPOS(InputText,'/',/REVERSE_SEARCH)), InputText] ; search by file or folder base name first, then by the full path
    ENDIF ELSE BEGIN
        SearchList = [InputText]
    ENDELSE
    
    FOREACH SearchText, SearchList DO BEGIN
        
        CleanText = CrabStringClean(SearchText, TextsToRemove=['_','-',' '])
        
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*2MASS*'                 ,/FOLD_CASE) THEN S_Instrument = '2MASS'
        
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*VISTAKs*'               ,/FOLD_CASE) THEN S_Instrument = 'VISTA'
        
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*WISEPhoto*'             ,/FOLD_CASE) THEN S_Instrument = 'WISE'
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*ac51w1int3*'            ,/FOLD_CASE) THEN S_Instrument = 'WISE'
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*ac51w2int3*'            ,/FOLD_CASE) THEN S_Instrument = 'WISE'
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*ac51w3int3*'            ,/FOLD_CASE) THEN S_Instrument = 'WISE'
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*ac51w4int3*'            ,/FOLD_CASE) THEN S_Instrument = 'WISE'
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*WISE3.4*'               ,/FOLD_CASE) THEN S_Instrument = 'WISE'
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*WISE4.6*'               ,/FOLD_CASE) THEN S_Instrument = 'WISE'
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*WISE12*'                ,/FOLD_CASE) THEN S_Instrument = 'WISE'
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*WISE22*'                ,/FOLD_CASE) THEN S_Instrument = 'WISE'
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*WISEMAP3.4*'            ,/FOLD_CASE) THEN S_Instrument = 'WISE' ; Aniano Kernels
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*WISEMAP4.6*'            ,/FOLD_CASE) THEN S_Instrument = 'WISE' ; Aniano Kernels
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*WISEMAP11.6*'           ,/FOLD_CASE) THEN S_Instrument = 'WISE' ; Aniano Kernels
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*WISEMAP22.0*'           ,/FOLD_CASE) THEN S_Instrument = 'WISE' ; Aniano Kernels
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*WISEch1*'               ,/FOLD_CASE) THEN S_Instrument = 'WISE'
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*WISEch2*'               ,/FOLD_CASE) THEN S_Instrument = 'WISE'
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*WISEch3*'               ,/FOLD_CASE) THEN S_Instrument = 'WISE'
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*WISEch4*'               ,/FOLD_CASE) THEN S_Instrument = 'WISE'
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*WISEw1*'                ,/FOLD_CASE) THEN S_Instrument = 'WISE'
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*WISEw2*'                ,/FOLD_CASE) THEN S_Instrument = 'WISE'
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*WISEw3*'                ,/FOLD_CASE) THEN S_Instrument = 'WISE'
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*WISEw4*'                ,/FOLD_CASE) THEN S_Instrument = 'WISE'
        
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*IRACPhoto*'             ,/FOLD_CASE) THEN S_Instrument = 'IRAC' ;<20160807>
        
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*pgh*goodsn*green*'      ,/FOLD_CASE) THEN S_Instrument = 'PACS' ;<20160803>
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*pgh*goodsn*red*'        ,/FOLD_CASE) THEN S_Instrument = 'PACS' ;<20160803>
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*pep*cosmos*green*'      ,/FOLD_CASE) THEN S_Instrument = 'PACS' ;<20170228>
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*pep*cosmos*red*'        ,/FOLD_CASE) THEN S_Instrument = 'PACS' ;<20170228>
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*PACS70*'                ,/FOLD_CASE) THEN S_Instrument = 'PACS' ;<20161128>
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*PACS100*'               ,/FOLD_CASE) THEN S_Instrument = 'PACS' ;<20161128>
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*PACS160*'               ,/FOLD_CASE) THEN S_Instrument = 'PACS' ;<20161128>
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*PACSPhoto*'             ,/FOLD_CASE) THEN S_Instrument = 'PACS' ;<20161128>
        
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*SPIRE250*'              ,/FOLD_CASE) THEN S_Instrument = 'SPIRE' ;<20160809>
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*SPIRE350*'              ,/FOLD_CASE) THEN S_Instrument = 'SPIRE' ;<20160809>
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*SPIRE500*'              ,/FOLD_CASE) THEN S_Instrument = 'SPIRE' ;<20160809>
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*250SMAP*'               ,/FOLD_CASE) THEN S_Instrument = 'SPIRE' ;<20160809>
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*350SMAP*'               ,/FOLD_CASE) THEN S_Instrument = 'SPIRE' ;<20160809>
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*500SMAP*'               ,/FOLD_CASE) THEN S_Instrument = 'SPIRE' ;<20160809>
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*SPIREPhoto*'            ,/FOLD_CASE) THEN S_Instrument = 'SPIRE' ;<20160809>
        
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*S2CLS*'                 ,/FOLD_CASE) THEN S_Instrument = 'SCUBA2'
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*SCUBA2*'                ,/FOLD_CASE) THEN S_Instrument = 'SCUBA2'
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*LABOCA*'                ,/FOLD_CASE) THEN S_Instrument = 'LABOCA'
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*aztec*'                 ,/FOLD_CASE) THEN S_Instrument = 'AzTEC'
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*mambo*'                 ,/FOLD_CASE) THEN S_Instrument = 'MAMBO'
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*1160*'                  ,/FOLD_CASE) THEN S_Instrument = '1.16mm'
        IF S_Instrument EQ "" THEN IF STRMATCH(CleanText, '*combinedmaw04azw05*'    ,/FOLD_CASE) THEN S_Instrument = '1.16mm' ;<20160803>
        
        
        
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^a-zA-Z]ACS[^a-zA-Z]*'       ,/FOLD_CASE) THEN S_Instrument = 'ACS'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^a-zA-Z]ACS'                 ,/FOLD_CASE) THEN S_Instrument = 'ACS'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,          'ACS[^a-zA-Z]*'       ,/FOLD_CASE) THEN S_Instrument = 'ACS'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,          'ACS'                 ,/FOLD_CASE) THEN S_Instrument = 'ACS'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^a-zA-Z]WFC3[^a-zA-Z]*'      ,/FOLD_CASE) THEN S_Instrument = 'WFC3'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^a-zA-Z]WFC3'                ,/FOLD_CASE) THEN S_Instrument = 'WFC3'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,          'WFC3[^a-zA-Z]*'      ,/FOLD_CASE) THEN S_Instrument = 'WFC3'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,          'WFC3'                ,/FOLD_CASE) THEN S_Instrument = 'WFC3'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^a-zA-Z]IRAC[^a-zA-Z]*'      ,/FOLD_CASE) THEN S_Instrument = 'IRAC'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^a-zA-Z]IRAC'                ,/FOLD_CASE) THEN S_Instrument = 'IRAC'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,          'IRAC[^a-zA-Z]*'      ,/FOLD_CASE) THEN S_Instrument = 'IRAC'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,          'IRAC'                ,/FOLD_CASE) THEN S_Instrument = 'IRAC'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^a-zA-Z]MIPS[^a-zA-Z]*'      ,/FOLD_CASE) THEN S_Instrument = 'MIPS'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^a-zA-Z]MIPS'                ,/FOLD_CASE) THEN S_Instrument = 'MIPS'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,          'MIPS[^a-zA-Z]*'      ,/FOLD_CASE) THEN S_Instrument = 'MIPS'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,          'MIPS'                ,/FOLD_CASE) THEN S_Instrument = 'MIPS'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^a-zA-Z]PACS[^a-zA-Z]*'      ,/FOLD_CASE) THEN S_Instrument = 'PACS'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^a-zA-Z]PACS'                ,/FOLD_CASE) THEN S_Instrument = 'PACS'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,          'PACS[^a-zA-Z]*'      ,/FOLD_CASE) THEN S_Instrument = 'PACS'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,          'PACS'                ,/FOLD_CASE) THEN S_Instrument = 'PACS'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^a-zA-Z]SPIRE[^a-zA-Z]*'     ,/FOLD_CASE) THEN S_Instrument = 'SPIRE'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^a-zA-Z]SPIRE'               ,/FOLD_CASE) THEN S_Instrument = 'SPIRE'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,          'SPIRE[^a-zA-Z]*'     ,/FOLD_CASE) THEN S_Instrument = 'SPIRE'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,          'SPIRE'               ,/FOLD_CASE) THEN S_Instrument = 'SPIRE'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^a-zA-Z]IRSX[^a-zA-Z]*'      ,/FOLD_CASE) THEN S_Instrument = 'IRSX'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^a-zA-Z]IRSX'                ,/FOLD_CASE) THEN S_Instrument = 'IRSX'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,          'IRSX[^a-zA-Z]*'      ,/FOLD_CASE) THEN S_Instrument = 'IRSX'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,          'IRSX'                ,/FOLD_CASE) THEN S_Instrument = 'IRSX'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^a-zA-Z]wdriz[^a-zA-Z]*'     ,/FOLD_CASE) THEN S_Instrument = 'IRS PUI' ; IRS peak-up imaging (2 filters: 13-18 and 18-26 microns)
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^a-zA-Z]wdriz'               ,/FOLD_CASE) THEN S_Instrument = 'IRS PUI'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,          'wdriz[^a-zA-Z]*'     ,/FOLD_CASE) THEN S_Instrument = 'IRS PUI'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,          'wdriz'               ,/FOLD_CASE) THEN S_Instrument = 'IRS PUI'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^a-zA-Z]WIRCAM[^a-zA-Z]*'    ,/FOLD_CASE) THEN S_Instrument = 'WIRCAM' ; NIR imager at CFHT
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^a-zA-Z]WIRCAM'              ,/FOLD_CASE) THEN S_Instrument = 'WIRCAM'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,          'WIRCAM[^a-zA-Z]*'    ,/FOLD_CASE) THEN S_Instrument = 'WIRCAM'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,          'WIRCAM'              ,/FOLD_CASE) THEN S_Instrument = 'WIRCAM'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^a-zA-Z]MODS[^a-zA-Z]*_J*'              ) THEN S_Instrument = 'Subaru J'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^a-zA-Z]MODS_J*'                        ) THEN S_Instrument = 'Subaru J'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^a-zA-Z]MODS[^a-zA-Z]*_H*'              ) THEN S_Instrument = 'Subaru H'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^a-zA-Z]MODS_H*'                        ) THEN S_Instrument = 'Subaru H'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^a-zA-Z]MODS[^a-zA-Z]*_K*'              ) THEN S_Instrument = 'Subaru Ks'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^a-zA-Z]MODS_K*'                        ) THEN S_Instrument = 'Subaru Ks'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^a-zA-Z]MODS[^a-zA-Z]*'                 ) THEN S_Instrument = 'Subaru' ; NIR imager at Subaru (aka MOIRSC)
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^a-zA-Z]MODS'                           ) THEN S_Instrument = 'Subaru'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,          'MODS[^a-zA-Z]*'                 ) THEN S_Instrument = 'Subaru'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,          'MODS'                           ) THEN S_Instrument = 'Subaru'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^a-zA-Z]Subaru[^a-zA-Z]*'    ,/FOLD_CASE) THEN S_Instrument = 'Subaru'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^a-zA-Z]Subaru'              ,/FOLD_CASE) THEN S_Instrument = 'Subaru'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,          'Subaru[^a-zA-Z]*'    ,/FOLD_CASE) THEN S_Instrument = 'Subaru'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,          'Subaru'              ,/FOLD_CASE) THEN S_Instrument = 'Subaru'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^a-zA-Z]VLA[^a-zA-Z]*'       ,/FOLD_CASE) THEN S_Instrument = 'VLA'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^a-zA-Z]VLA'                 ,/FOLD_CASE) THEN S_Instrument = 'VLA'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,          'VLA[^a-zA-Z]*'       ,/FOLD_CASE) THEN S_Instrument = 'VLA'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,          'VLA'                 ,/FOLD_CASE) THEN S_Instrument = 'VLA'
        IF S_Instrument EQ "" THEN IF STRMATCH(SearchText,'*[^a-zA-Z]975ks[^a-zA-Z]*'     ,/FOLD_CASE) THEN S_Instrument = 'Chandra'
        
    ENDFOREACH
    
    RETURN, S_Instrument
END
