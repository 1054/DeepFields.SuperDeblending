; 
; Please refer to CrabTelescope.pro
; 



FUNCTION RecognizeTelescope, SearchText
    S_Telescope  = ""
    IF S_Telescope EQ "" THEN IF STRMATCH(SearchText,'*Herschel*',/FOLD_CASE) THEN S_Telescope = 'Herschel'
    IF S_Telescope EQ "" THEN IF STRMATCH(SearchText,'*PACS*'    ,/FOLD_CASE) THEN S_Telescope = 'Herschel'
    IF S_Telescope EQ "" THEN IF STRMATCH(SearchText,'*SPIRE*'   ,/FOLD_CASE) THEN S_Telescope = 'Herschel'
    IF S_Telescope EQ "" THEN IF STRMATCH(SearchText,'*Spitzer*' ,/FOLD_CASE) THEN S_Telescope = 'Spitzer'
    IF S_Telescope EQ "" THEN IF STRMATCH(SearchText,'*IRAC*'    ,/FOLD_CASE) THEN S_Telescope = 'Spitzer'
    IF S_Telescope EQ "" THEN IF STRMATCH(SearchText,'*MIPS*'    ,/FOLD_CASE) THEN S_Telescope = 'Spitzer'
    IF S_Telescope EQ "" THEN IF STRMATCH(SearchText,'*WISE*'    ,/FOLD_CASE) THEN S_Telescope = 'WISE'
    IF S_Telescope EQ "" THEN IF STRMATCH(SearchText,'*Subaru*'  ,/FOLD_CASE) THEN S_Telescope = 'Subaru'
    IF S_Telescope EQ "" THEN IF STRMATCH(SearchText,'*[^A-Z]MODS[^A-Z]*'   ) THEN S_Telescope = 'Subaru'
    IF S_Telescope EQ "" THEN IF STRMATCH(SearchText,'*WFC3*'    ,/FOLD_CASE) THEN S_Telescope = 'Hubble'
    IF S_Telescope EQ "" THEN IF STRMATCH(SearchText,'*IRSX*'    ,/FOLD_CASE) THEN S_Telescope = 'Spitzer'
    IF S_Telescope EQ "" THEN IF STRMATCH(SearchText,'*VLA*'     ,/FOLD_CASE) THEN S_Telescope = 'VLA'
    RETURN, S_Telescope
END