; 
; Please refer to CrabTelescope.pro
; 


    
FUNCTION RecognizePSF, InstrumentFilterID
    PointSpreadFuncFWHM = [0.d,0.d]
    ; Herschel Telescope PACS Instrument "pacs_om.pdf" "Table 3.1"
    IF InstrumentFilterID EQ "PACS70"  THEN PointSpreadFuncFWHM = [5.46d, 5.76d]                   ; ScanSpeed=20"/s PIXSCALE=1.40
    IF InstrumentFilterID EQ "PACS100" THEN PointSpreadFuncFWHM = [6.69d, 6.89d]                   ; ScanSpeed=20"/s 
    IF InstrumentFilterID EQ "PACS160" THEN PointSpreadFuncFWHM = [10.65d, 12.13d, 9.3d] ;[x,y,PA] ; ScanSpeed=20"/s PIXSCALE=2.85
    ; Herschel Telescope SPIRE Instrument "spire_om.odf" "Table 5.2"
    IF InstrumentFilterID EQ "SPIRE250" THEN PointSpreadFuncFWHM = [18.3d, 17.0d] ; PIXSCALE=6
    IF InstrumentFilterID EQ "SPIRE350" THEN PointSpreadFuncFWHM = [24.7d, 23.2d] ; PIXSCALE=10
    IF InstrumentFilterID EQ "SPIRE500" THEN PointSpreadFuncFWHM = [37.0d, 33.4d] ; PIXSCALE=14
    ; Spitzer Telescope IRAC Instrument "IRAC_Instrument_Handbook.pdf" "Table 2.1"
;    IF InstrumentFilterID EQ "IRAC3.6" THEN PointSpreadFuncFWHM = []
    ; Spitzer Telescope MIPS Instrument "Stansberry et al. 2007" "Fig. 2"
;    IF InstrumentFilterID EQ "MIPS160" THEN PointSpreadFuncFWHM = [38.3d] ; PIXSCALE=2.45 "MIPS_Handbook" "Table 4.9"
    ; Spitzer Telescope MIPS Instrument "Aniano et al. 2012" "Table 6"
    IF InstrumentFilterID EQ "MIPS24"  THEN PointSpreadFuncFWHM = [6.5d, 6.5d]  ; PIXSCALE=2.45 "MIPS_Handbook" "Table 4.9"
    IF InstrumentFilterID EQ "MIPS70"  THEN PointSpreadFuncFWHM = [18.7d,18.7d] ; PIXSCALE=4.0  "MIPS_Handbook" "Table 4.9"
    IF InstrumentFilterID EQ "MIPS160" THEN PointSpreadFuncFWHM = [38.8d,38.8d] ; PIXSCALE=8.0  "MIPS_Handbook" "Table 4.9"
    RETURN, PointSpreadFuncFWHM
END