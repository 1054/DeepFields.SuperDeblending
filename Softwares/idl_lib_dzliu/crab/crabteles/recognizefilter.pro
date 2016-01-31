; 
; Please refer to CrabTelescope.pro
; 



FUNCTION RecognizeFilter, InputText, Wavelength=S_Wavelength, Frequency=S_Frequency
    S_Filter = ''
    S_Wavelength = 0.0D
    S_Frequency = 0.0D
    SearchText = CrabStringClean(InputText,TextsToRemove=['_',' '])
    
    IF S_Filter EQ '' THEN IF STRMATCH(SearchText,'*F435W*'        ,/FOLD_CASE) THEN BEGIN & S_Filter='F435W'  & S_Wavelength=0.435D-6 & ENDIF
    IF S_Filter EQ '' THEN IF STRMATCH(SearchText,'*F606W*'        ,/FOLD_CASE) THEN BEGIN & S_Filter='F606W'  & S_Wavelength=0.606D-6 & ENDIF
    IF S_Filter EQ '' THEN IF STRMATCH(SearchText,'*F775W*'        ,/FOLD_CASE) THEN BEGIN & S_Filter='F775W'  & S_Wavelength=0.775D-6 & ENDIF
    IF S_Filter EQ '' THEN IF STRMATCH(SearchText,'*F850L*'        ,/FOLD_CASE) THEN BEGIN & S_Filter='F850LP' & S_Wavelength=0.850D-6 & ENDIF
    
    IF S_Filter EQ '' THEN IF STRMATCH(SearchText,'*F105W*'        ,/FOLD_CASE) THEN BEGIN & S_Filter='F105W' & S_Wavelength=1.05D-6  & ENDIF
    IF S_Filter EQ '' THEN IF STRMATCH(SearchText,'*F125W*'        ,/FOLD_CASE) THEN BEGIN & S_Filter='F125W' & S_Wavelength=1.25D-6  & ENDIF
    IF S_Filter EQ '' THEN IF STRMATCH(SearchText,'*F160W*'        ,/FOLD_CASE) THEN BEGIN & S_Filter='F160W' & S_Wavelength=1.60D-6  & ENDIF
    
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*IRAC3.6*'      ,/FOLD_CASE)   THEN BEGIN & S_Filter='3.6' & S_Wavelength=3.6D-6 & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*IRAC4.5*'      ,/FOLD_CASE)   THEN BEGIN & S_Filter='4.5' & S_Wavelength=4.5D-6 & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*IRAC5.8*'      ,/FOLD_CASE)   THEN BEGIN & S_Filter='5.8' & S_Wavelength=5.8D-6 & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*IRAC8.0*'      ,/FOLD_CASE)   THEN BEGIN & S_Filter='8.0' & S_Wavelength=8.0D-6 & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*IRACch1*'      ,/FOLD_CASE)   THEN BEGIN & S_Filter='3.6' & S_Wavelength=3.6D-6 & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*IRACch2*'      ,/FOLD_CASE)   THEN BEGIN & S_Filter='4.5' & S_Wavelength=4.5D-6 & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*IRACch3*'      ,/FOLD_CASE)   THEN BEGIN & S_Filter='5.8' & S_Wavelength=5.8D-6 & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*IRACch4*'      ,/FOLD_CASE)   THEN BEGIN & S_Filter='8.0' & S_Wavelength=8.0D-6 & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*IRAC1'         ,/FOLD_CASE)   THEN BEGIN & S_Filter='3.6' & S_Wavelength=3.6D-6 & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*IRAC2'         ,/FOLD_CASE)   THEN BEGIN & S_Filter='4.5' & S_Wavelength=4.5D-6 & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*IRAC3'         ,/FOLD_CASE)   THEN BEGIN & S_Filter='5.8' & S_Wavelength=5.8D-6 & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*IRAC4'         ,/FOLD_CASE)   THEN BEGIN & S_Filter='8.0' & S_Wavelength=8.0D-6 & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*IRAC1[^1-9.]*' ,/FOLD_CASE)   THEN BEGIN & S_Filter='3.6' & S_Wavelength=3.6D-6 & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*IRAC2[^1-9.]*' ,/FOLD_CASE)   THEN BEGIN & S_Filter='4.5' & S_Wavelength=4.5D-6 & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*IRAC3[^1-9.]*' ,/FOLD_CASE)   THEN BEGIN & S_Filter='5.8' & S_Wavelength=5.8D-6 & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*IRAC4[^1-9.]*' ,/FOLD_CASE)   THEN BEGIN & S_Filter='8.0' & S_Wavelength=8.0D-6 & ENDIF
    
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*Subaru*_Y[^A-Z]*'  ,/FOLD_CASE) THEN BEGIN & S_Filter='Y'  & S_Wavelength=1.02D-6 & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*Subaru*_J[^A-Z]*'  ,/FOLD_CASE) THEN BEGIN & S_Filter='J'  & S_Wavelength=1.26D-6 & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*Subaru*_H[^A-Z]*'  ,/FOLD_CASE) THEN BEGIN & S_Filter='H'  & S_Wavelength=1.64D-6 & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*Subaru*_K[^A-Z]*'  ,/FOLD_CASE) THEN BEGIN & S_Filter='K'  & S_Wavelength=2.15D-6 & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*Subaru*_Ks[^A-Z]*' ,/FOLD_CASE) THEN BEGIN & S_Filter='Ks' & S_Wavelength=2.20D-6 & ENDIF

    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*MIPS24*'       ,/FOLD_CASE)   THEN BEGIN & S_Filter='24'  & S_Wavelength=24D-6  & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*MIPS70*'       ,/FOLD_CASE)   THEN BEGIN & S_Filter='70'  & S_Wavelength=70D-6  & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*MIPS160*'      ,/FOLD_CASE)   THEN BEGIN & S_Filter='160' & S_Wavelength=160D-6 & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*MIPSch1*'      ,/FOLD_CASE)   THEN BEGIN & S_Filter='24'  & S_Wavelength=24D-6  & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*MIPSch2*'      ,/FOLD_CASE)   THEN BEGIN & S_Filter='70'  & S_Wavelength=70D-6  & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*MIPSch3*'      ,/FOLD_CASE)   THEN BEGIN & S_Filter='160' & S_Wavelength=160D-6 & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*MIPS1[^1-9.]*' ,/FOLD_CASE)   THEN BEGIN & S_Filter='24'  & S_Wavelength=24D-6  & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*MIPS2[^1-9.]*' ,/FOLD_CASE)   THEN BEGIN & S_Filter='70'  & S_Wavelength=70D-6  & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*MIPS3[^1-9.]*' ,/FOLD_CASE)   THEN BEGIN & S_Filter='160' & S_Wavelength=160D-6 & ENDIF
    
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*PACS70*'       ,/FOLD_CASE) THEN BEGIN & S_Filter='70'  & S_Wavelength=70D-6  & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*PACS100*'      ,/FOLD_CASE) THEN BEGIN & S_Filter='100' & S_Wavelength=100D-6 & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*PACS160*'      ,/FOLD_CASE) THEN BEGIN & S_Filter='160' & S_Wavelength=160D-6 & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*PACS*BLUE*'    ,/FOLD_CASE) THEN BEGIN & S_Filter='70'  & S_Wavelength=70D-6  & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*PACS*GREEN*'   ,/FOLD_CASE) THEN BEGIN & S_Filter='100' & S_Wavelength=100D-6 & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*PACS*RED*'     ,/FOLD_CASE) THEN BEGIN & S_Filter='160' & S_Wavelength=160D-6 & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*PACS1[^0-9]*'  ,/FOLD_CASE) THEN BEGIN & S_Filter='70'  & S_Wavelength=70D-6  & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*PACS2[^0-9]*'  ,/FOLD_CASE) THEN BEGIN & S_Filter='100' & S_Wavelength=100D-6 & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*PACS3[^0-9]*'  ,/FOLD_CASE) THEN BEGIN & S_Filter='160' & S_Wavelength=160D-6 & ENDIF
    
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*SPIRE250*'     ,/FOLD_CASE) THEN BEGIN & S_Filter='250' & S_Wavelength=250D-6 & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*SPIRE350*'     ,/FOLD_CASE) THEN BEGIN & S_Filter='350' & S_Wavelength=350D-6 & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*SPIRE500*'     ,/FOLD_CASE) THEN BEGIN & S_Filter='500' & S_Wavelength=500D-6 & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*SPIRE*PSW*'    ,/FOLD_CASE) THEN BEGIN & S_Filter='250' & S_Wavelength=250D-6 & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*SPIRE*PMW*'    ,/FOLD_CASE) THEN BEGIN & S_Filter='350' & S_Wavelength=350D-6 & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*SPIRE*PLW*'    ,/FOLD_CASE) THEN BEGIN & S_Filter='500' & S_Wavelength=500D-6 & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*SPIRE1[^0-9]*' ,/FOLD_CASE) THEN BEGIN & S_Filter='250' & S_Wavelength=250D-6 & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*SPIRE2[^0-9]*' ,/FOLD_CASE) THEN BEGIN & S_Filter='350' & S_Wavelength=350D-6 & ENDIF
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*SPIRE3[^0-9]*' ,/FOLD_CASE) THEN BEGIN & S_Filter='500' & S_Wavelength=500D-6 & ENDIF
    
    IF S_Filter EQ "" THEN IF STRMATCH(SearchText,'*[^A-z]975ks[^A-z]*' ,/FOLD_CASE) THEN S_Filter = '975ks'
    
    ; 
    IF S_Wavelength NE 0 THEN S_Frequency = 2.99792458D8/S_Wavelength
    RETURN, S_Filter
END