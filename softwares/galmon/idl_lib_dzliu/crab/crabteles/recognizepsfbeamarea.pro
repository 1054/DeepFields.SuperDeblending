; 
; Please refer to CrabTelescope.pro
; 


    
FUNCTION RecognizePSFBeamArea, InstrumentFilterID, Steradian=Steradian
    PointSpreadFuncBeam = 0.0d & PointSpreadFuncBeamSr = 0.0d
    ; Herschel Telescope PACS Instrument "pacs_om.pdf" "Table 3.1"
    IF InstrumentFilterID EQ "PACS70"  THEN BEGIN PointSpreadFuncBeam = 0.0d & PointSpreadFuncBeamSr = 0.0d & ENDIF ; ScanSpeed=20"/s PIXSCALE=1.40
    IF InstrumentFilterID EQ "PACS100" THEN BEGIN PointSpreadFuncBeam = 0.0d & PointSpreadFuncBeamSr = 0.0d & ENDIF ; ScanSpeed=20"/s 
    IF InstrumentFilterID EQ "PACS160" THEN BEGIN PointSpreadFuncBeam = 0.0d & PointSpreadFuncBeamSr = 0.0d & ENDIF ; ScanSpeed=20"/s PIXSCALE=2.85
    ; Herschel Telescope SPIRE Instrument "spire_om.odf" "Table 5.2"
    IF InstrumentFilterID EQ "SPIRE250" THEN BEGIN PointSpreadFuncBeam = 423.d  & PointSpreadFuncBeamSr = 0.9942d-8 & ENDIF ; PIXSCALE=6
    IF InstrumentFilterID EQ "SPIRE350" THEN BEGIN PointSpreadFuncBeam = 751.d  & PointSpreadFuncBeamSr = 1.765d-8  & ENDIF ; PIXSCALE=10
    IF InstrumentFilterID EQ "SPIRE500" THEN BEGIN PointSpreadFuncBeam = 1587.d & PointSpreadFuncBeamSr = 3.730d-8  & ENDIF ; PIXSCALE=14
    ; Spitzer Telescope IRAC Instrument "IRAC_Instrument_Handbook.pdf" "Table 2.1"
;    IF InstrumentFilterID EQ "IRAC3.6" THEN PointSpreadFuncBeam = []
    ; Spitzer Telescope MIPS Instrument "Stansberry et al. 2007" "Fig. 2"
;    IF InstrumentFilterID EQ "MIPS160" THEN PointSpreadFuncBeam = [38.3d] ; PIXSCALE=2.45 "MIPS_Handbook" "Table 4.9"
    ; Spitzer Telescope MIPS Instrument "Aniano et al. 2012" "Table 6"
    IF InstrumentFilterID EQ "MIPS24"  THEN BEGIN PointSpreadFuncBeam = 0.0d & PointSpreadFuncBeamSr = 0.0d & ENDIF ; PIXSCALE=2.45 "MIPS_Handbook" "Table 4.9"
    IF InstrumentFilterID EQ "MIPS70"  THEN BEGIN PointSpreadFuncBeam = 0.0d & PointSpreadFuncBeamSr = 0.0d & ENDIF ; PIXSCALE=4.0  "MIPS_Handbook" "Table 4.9"
    IF InstrumentFilterID EQ "MIPS160" THEN BEGIN PointSpreadFuncBeam = 0.0d & PointSpreadFuncBeamSr = 0.0d & ENDIF ; PIXSCALE=8.0  "MIPS_Handbook" "Table 4.9"
    IF KEYWORD_SET(Steradian) THEN RETURN, PointSpreadFuncBeamSr
    RETURN, PointSpreadFuncBeam
END