; 
; Aim:
;     Please refer to CrabTelescope.pro
; 
; Last update: 
;     20170228 dzliu -- search by base name first, then by the full path. Added more matches. 
; 



FUNCTION RecognizeFilter, InputText, Wavelength=S_Wavelength, Frequency=S_Frequency
    S_Filter = ''
    S_Wavelength = 0.0D
    S_Frequency = 0.0D
    SearchList = []
    
    IF STRPOS(InputText,'/') GE 0 AND STRPOS(InputText,'/',/REVERSE_SEARCH) LT STRLEN(InputText)-1 THEN BEGIN
        SearchList = [STRMID(InputText,STRPOS(InputText,'/',/REVERSE_SEARCH)), InputText] ; search by file or folder base name first, then by the full path
    ENDIF ELSE BEGIN
        SearchList = [InputText]
    ENDELSE
    
    FOREACH SearchText, SearchList DO BEGIN
        
        CleanText = CrabStringClean(SearchText, TextsToRemove=['_','-',' '])
        
        IF S_Filter EQ '' THEN IF STRMATCH(CleanText,'*F435W*'        ,/FOLD_CASE) THEN BEGIN & S_Filter='F435W'  & S_Wavelength=0.435D-6 & ENDIF
        IF S_Filter EQ '' THEN IF STRMATCH(CleanText,'*F606W*'        ,/FOLD_CASE) THEN BEGIN & S_Filter='F606W'  & S_Wavelength=0.606D-6 & ENDIF
        IF S_Filter EQ '' THEN IF STRMATCH(CleanText,'*F775W*'        ,/FOLD_CASE) THEN BEGIN & S_Filter='F775W'  & S_Wavelength=0.775D-6 & ENDIF
        IF S_Filter EQ '' THEN IF STRMATCH(CleanText,'*F850L*'        ,/FOLD_CASE) THEN BEGIN & S_Filter='F850LP' & S_Wavelength=0.850D-6 & ENDIF
        
        IF S_Filter EQ '' THEN IF STRMATCH(CleanText,'*F105W*'        ,/FOLD_CASE) THEN BEGIN & S_Filter='F105W' & S_Wavelength=1.05D-6  & ENDIF
        IF S_Filter EQ '' THEN IF STRMATCH(CleanText,'*F125W*'        ,/FOLD_CASE) THEN BEGIN & S_Filter='F125W' & S_Wavelength=1.25D-6  & ENDIF
        IF S_Filter EQ '' THEN IF STRMATCH(CleanText,'*F160W*'        ,/FOLD_CASE) THEN BEGIN & S_Filter='F160W' & S_Wavelength=1.60D-6  & ENDIF
        
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*IRAC3.6*'      ,/FOLD_CASE)   THEN BEGIN & S_Filter='3.6' & S_Wavelength=3.6D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*IRAC4.5*'      ,/FOLD_CASE)   THEN BEGIN & S_Filter='4.5' & S_Wavelength=4.5D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*IRAC5.8*'      ,/FOLD_CASE)   THEN BEGIN & S_Filter='5.8' & S_Wavelength=5.8D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*IRAC8.0*'      ,/FOLD_CASE)   THEN BEGIN & S_Filter='8.0' & S_Wavelength=8.0D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*IRACch1*'      ,/FOLD_CASE)   THEN BEGIN & S_Filter='3.6' & S_Wavelength=3.6D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*IRACch2*'      ,/FOLD_CASE)   THEN BEGIN & S_Filter='4.5' & S_Wavelength=4.5D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*IRACch3*'      ,/FOLD_CASE)   THEN BEGIN & S_Filter='5.8' & S_Wavelength=5.8D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*IRACch4*'      ,/FOLD_CASE)   THEN BEGIN & S_Filter='8.0' & S_Wavelength=8.0D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*IRAC1'         ,/FOLD_CASE)   THEN BEGIN & S_Filter='3.6' & S_Wavelength=3.6D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*IRAC2'         ,/FOLD_CASE)   THEN BEGIN & S_Filter='4.5' & S_Wavelength=4.5D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*IRAC3'         ,/FOLD_CASE)   THEN BEGIN & S_Filter='5.8' & S_Wavelength=5.8D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*IRAC4'         ,/FOLD_CASE)   THEN BEGIN & S_Filter='8.0' & S_Wavelength=8.0D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*IRAC1[^1-9.]*' ,/FOLD_CASE)   THEN BEGIN & S_Filter='3.6' & S_Wavelength=3.6D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*IRAC2[^1-9.]*' ,/FOLD_CASE)   THEN BEGIN & S_Filter='4.5' & S_Wavelength=4.5D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*IRAC3[^1-9.]*' ,/FOLD_CASE)   THEN BEGIN & S_Filter='5.8' & S_Wavelength=5.8D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*IRAC4[^1-9.]*' ,/FOLD_CASE)   THEN BEGIN & S_Filter='8.0' & S_Wavelength=8.0D-6 & ENDIF
        
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*SubaruY*'     ,/FOLD_CASE) THEN BEGIN & S_Filter='Y'  & S_Wavelength=1.02D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*SubaruJ*'     ,/FOLD_CASE) THEN BEGIN & S_Filter='J'  & S_Wavelength=1.26D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*SubaruH*'     ,/FOLD_CASE) THEN BEGIN & S_Filter='H'  & S_Wavelength=1.64D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*SubaruK*'     ,/FOLD_CASE) THEN BEGIN & S_Filter='K'  & S_Wavelength=2.15D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*SubaruKs*'    ,/FOLD_CASE) THEN BEGIN & S_Filter='Ks' & S_Wavelength=2.20D-6 & ENDIF
        
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*MODSJ*'                  ) THEN BEGIN & S_Filter='J'  & S_Wavelength=1.26D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*MODSH*'                  ) THEN BEGIN & S_Filter='H'  & S_Wavelength=1.64D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*MODSK*'                  ) THEN BEGIN & S_Filter='K'  & S_Wavelength=2.15D-6 & ENDIF
        
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*VISTAKs*'     ,/FOLD_CASE) THEN BEGIN & S_Filter='Ks' & S_Wavelength=2.20D-6 & ENDIF
        
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*WIRCAMKs*'    ,/FOLD_CASE) THEN BEGIN & S_Filter='Ks' & S_Wavelength=2.20D-6 & ENDIF

        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*MIPS24*'       ,/FOLD_CASE)   THEN BEGIN & S_Filter='24'  & S_Wavelength=24D-6  & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*MIPS70*'       ,/FOLD_CASE)   THEN BEGIN & S_Filter='70'  & S_Wavelength=70D-6  & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*MIPS160*'      ,/FOLD_CASE)   THEN BEGIN & S_Filter='160' & S_Wavelength=160D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*MIPSch1*'      ,/FOLD_CASE)   THEN BEGIN & S_Filter='24'  & S_Wavelength=24D-6  & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*MIPSch2*'      ,/FOLD_CASE)   THEN BEGIN & S_Filter='70'  & S_Wavelength=70D-6  & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*MIPSch3*'      ,/FOLD_CASE)   THEN BEGIN & S_Filter='160' & S_Wavelength=160D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*MIPS1[^1-9.]*' ,/FOLD_CASE)   THEN BEGIN & S_Filter='24'  & S_Wavelength=24D-6  & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*MIPS2[^1-9.]*' ,/FOLD_CASE)   THEN BEGIN & S_Filter='70'  & S_Wavelength=70D-6  & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*MIPS3[^1-9.]*' ,/FOLD_CASE)   THEN BEGIN & S_Filter='160' & S_Wavelength=160D-6 & ENDIF
        
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*PACS70*'             ,/FOLD_CASE) THEN BEGIN & S_Filter='70'  & S_Wavelength=70D-6  & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*PACS100*'            ,/FOLD_CASE) THEN BEGIN & S_Filter='100' & S_Wavelength=100D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*PACS160*'            ,/FOLD_CASE) THEN BEGIN & S_Filter='160' & S_Wavelength=160D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*PACS*BLUE*'          ,/FOLD_CASE) THEN BEGIN & S_Filter='70'  & S_Wavelength=70D-6  & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*PACS*GREEN*'         ,/FOLD_CASE) THEN BEGIN & S_Filter='100' & S_Wavelength=100D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*PACS*RED*'           ,/FOLD_CASE) THEN BEGIN & S_Filter='160' & S_Wavelength=160D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*pep*COSMOS*BLUE*'    ,/FOLD_CASE) THEN BEGIN & S_Filter='70'  & S_Wavelength=70D-6  & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*pep*COSMOS*GREEN*'   ,/FOLD_CASE) THEN BEGIN & S_Filter='100' & S_Wavelength=100D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*pep*COSMOS*RED*'     ,/FOLD_CASE) THEN BEGIN & S_Filter='160' & S_Wavelength=160D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*pgh*GOODS*BLUE*'     ,/FOLD_CASE) THEN BEGIN & S_Filter='70'  & S_Wavelength=70D-6  & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*pgh*GOODS*GREEN* '   ,/FOLD_CASE) THEN BEGIN & S_Filter='100' & S_Wavelength=100D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*pgh*GOODS*RED*'      ,/FOLD_CASE) THEN BEGIN & S_Filter='160' & S_Wavelength=160D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*PACS1[^0-9]*'        ,/FOLD_CASE) THEN BEGIN & S_Filter='70'  & S_Wavelength=70D-6  & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*PACS2[^0-9]*'        ,/FOLD_CASE) THEN BEGIN & S_Filter='100' & S_Wavelength=100D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*PACS3[^0-9]*'        ,/FOLD_CASE) THEN BEGIN & S_Filter='160' & S_Wavelength=160D-6 & ENDIF
        
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*SPIRE250*'     ,/FOLD_CASE) THEN BEGIN & S_Filter='250' & S_Wavelength=250D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*SPIRE350*'     ,/FOLD_CASE) THEN BEGIN & S_Filter='350' & S_Wavelength=350D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*SPIRE500*'     ,/FOLD_CASE) THEN BEGIN & S_Filter='500' & S_Wavelength=500D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*250SMAP*'      ,/FOLD_CASE) THEN BEGIN & S_Filter='250' & S_Wavelength=250D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*350SMAP*'      ,/FOLD_CASE) THEN BEGIN & S_Filter='350' & S_Wavelength=350D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*500SMAP*'      ,/FOLD_CASE) THEN BEGIN & S_Filter='500' & S_Wavelength=500D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*SPIRE*PSW*'    ,/FOLD_CASE) THEN BEGIN & S_Filter='250' & S_Wavelength=250D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*SPIRE*PMW*'    ,/FOLD_CASE) THEN BEGIN & S_Filter='350' & S_Wavelength=350D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*SPIRE*PLW*'    ,/FOLD_CASE) THEN BEGIN & S_Filter='500' & S_Wavelength=500D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*SPIRE1[^0-9]*' ,/FOLD_CASE) THEN BEGIN & S_Filter='250' & S_Wavelength=250D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*SPIRE2[^0-9]*' ,/FOLD_CASE) THEN BEGIN & S_Filter='350' & S_Wavelength=350D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*SPIRE3[^0-9]*' ,/FOLD_CASE) THEN BEGIN & S_Filter='500' & S_Wavelength=500D-6 & ENDIF
        
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*S2CLS*'        ,/FOLD_CASE) THEN BEGIN & S_Filter='850' & S_Wavelength=850D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*SCUBA2*'       ,/FOLD_CASE) THEN BEGIN & S_Filter='850' & S_Wavelength=850D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*LABOCA*'       ,/FOLD_CASE) THEN BEGIN & S_Filter='870' & S_Wavelength=870D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*aztec*'        ,/FOLD_CASE) THEN BEGIN & S_Filter='1100' & S_Wavelength=1100D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*mambo*'        ,/FOLD_CASE) THEN BEGIN & S_Filter='1200' & S_Wavelength=1200D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*NIKA1mm*'      ,/FOLD_CASE) THEN BEGIN & S_Filter='1mm' & S_Wavelength=1100D-6 & ENDIF
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*NIKA2mm*'      ,/FOLD_CASE) THEN BEGIN & S_Filter='2mm' & S_Wavelength=2050D-6 & ENDIF
        
        IF S_Filter EQ "" THEN IF STRMATCH(CleanText,'*[^A-z]975ks[^A-z]*' ,/FOLD_CASE) THEN S_Filter = '975ks'
    
    ENDFOREACH
    
    IF S_Wavelength NE 0 THEN S_Frequency = 2.99792458D8/S_Wavelength
    
    RETURN, S_Filter
END