; 
; Main Program 
;              -- AstroDepthFaireMontage
;              -- ; old name: 
;              -- ; AstroDepthMakeStamp
;                 (See code below)
;  



; ############################ ;
; Subroutine ReadOneLineSTRMID ;
; ############################ ;

FUNCTION ReadOneLineSTRMID, fline, fs1, fs2, ftext=ftext, fnext=fnext
    otext = ''
    IF SIZE(fs1,/TNAME) EQ "STRING" THEN BEGIN
        fp1 = STRPOS(fline,fs1)+strlen(fs1)
    ENDIF ELSE BEGIN
        fp1 = LONG(fs1)
    ENDELSE
    IF fp1 GE 0 THEN BEGIN
        IF SIZE(fs2,/TNAME) EQ "STRING" THEN BEGIN
            IF STRLEN(fs2) GT 0 THEN BEGIN
                IF STRPOS(fline,fs2,fp1) GT 0 THEN BEGIN
                    fp2 = STRPOS(fline,fs2,fp1)
                ENDIF ELSE BEGIN
                    fp2 = STRLEN(fline)
                ENDELSE
            ENDIF ELSE BEGIN
                fp2 = STRLEN(fline)
            ENDELSE
        ENDIF ELSE BEGIN
            fp2 = LONG(fs2)
        ENDELSE
        IF fp2 GE 0 THEN BEGIN
            ftext = STRMID(fline,fp1,fp2-fp1)
            otext = STRTRIM(ftext,2)
            IF SIZE(fs2,/TNAME) EQ "STRING" THEN BEGIN
                fnext = ftext+fs2
            ENDIF ELSE BEGIN
                fnext = fp2+fs2
            ENDELSE
        ENDIF
    ENDIF
    RETURN, otext
END

; ########################## ;
; Subroutine ReadDS9Reg_Fast ;
; ########################## ;

PRO ReadDS9Reg_Fast, DS9RegFile, RA=oRA, DEC=oDEC, RAD=oRAD, LABEL=oLABEL, COLOR=oCOLOR, LDASH=oLDASH, $
                     Circles=Circles, CircleLabels=CircleLabels, CircleColors=CircleColors, CircleDashed=CircleDashed
    ; DS9RegFile = '/Users/dliu/Working/2014-CEA/Data/Level_3_SciData/Lagache/ds9.1160.Adds.fk5.reg'
    oRA = []
    oDEC = []
    oRAD = []
    oLABEL = []
    oCOLOR = []
    oLDASH = []
    oTHICK = []
    GlobalLABEL = ''
    GlobalCOLOR = 'green'
    GlobalLDASH = 0
    GlobalTHICK = 2.0
    ; read ds9 region file
    IF FILE_TEST(DS9RegFile) THEN BEGIN
        MESSAGE, 'Reading ds9 region file '+DS9RegFile, /CONTINUE, /INFORM
        ; read global <added><20150717><dzliu>
        OPENR, lun, DS9RegFile, /GET_LUN
        WHILE ~EOF(lun) DO BEGIN
            linetext = '' & READF, lun, linetext
            IF STRMATCH(linetext,'global *') THEN BEGIN
                linecontents = STRSPLIT(linetext,/ex)
                FOREACH linecontent, linecontents DO BEGIN
                    IF STRMATCH(linecontent,'color=*') THEN GlobalCOLOR=STRMID(linecontent,STRPOS(linecontent,'=')+1)
                    IF STRMATCH(linecontent,'dash=*') THEN GlobalLDASH=FIX(STRMID(linecontent,STRPOS(linecontent,'=')+1))
                    IF STRMATCH(linecontent,'width=*') THEN GlobalTHICK=(STRMID(linecontent,STRPOS(linecontent,'=')+1))
                ENDFOREACH
                BREAK
            ENDIF
        ENDWHILE
        FREE_LUN, lun
        ; read list 
        READCOL, DS9RegFile, FORMAT='(A,F,F,F,A,A)', delimiter=',)("#', sCIRCLE, fRA, fDEC, fRAD, sBLANK, sTEXT, /SILENT ;<TODO> make sure sBLANK ; <TODO> fRAD must be arcsec
        sLABEL = (STREGEX(sTEXT,'text={([^{}]*)}',/SUBEXPR,/EXTRACT))[-1,*]
        sCOLOR = (STREGEX(sTEXT,'color=([^ ]*)',/SUBEXPR,/EXTRACT))[-1,*]
        sLDASH = (STREGEX(sTEXT,'dash=([^ ]*)',/SUBEXPR,/EXTRACT))[-1,*]
        sTHICK = (STREGEX(sTEXT,'width=([^ ]*)',/SUBEXPR,/EXTRACT))[-1,*]
        oRA = fRA
        oDEC = fDEC
        oRAD = fRAD
        oLABEL = REPLICATE(GlobalLABEL,N_ELEMENTS(sCIRCLE)) & iWHERE = WHERE(sLABEL NE '',/NULL) & IF N_ELEMENTS(iWHERE) GT 0 THEN oLABEL[iWHERE] =     sLABEL[iWHERE]
        oCOLOR = REPLICATE(GlobalCOLOR,N_ELEMENTS(sCIRCLE)) & iWHERE = WHERE(sCOLOR NE '',/NULL) & IF N_ELEMENTS(iWHERE) GT 0 THEN oCOLOR[iWHERE] =     sCOLOR[iWHERE]
        oLDASH = REPLICATE(GlobalLDASH,N_ELEMENTS(sCIRCLE)) & iWHERE = WHERE(sLDASH NE '',/NULL) & IF N_ELEMENTS(iWHERE) GT 0 THEN oLDASH[iWHERE] = FIX(sLDASH[iWHERE])
        oTHICK = REPLICATE(GlobalTHICK,N_ELEMENTS(sCIRCLE)) & iWHERE = WHERE(sTHICK NE '',/NULL) & IF N_ELEMENTS(iWHERE) GT 0 THEN oTHICK[iWHERE] =    (sTHICK[iWHERE])
    ENDIF ELSE BEGIN
        MESSAGE, 'Error! ds9 region file '+DS9RegFile+' not found!'
    ENDELSE
    ; make circles
    IF N_ELEMENTS(oRA) GT 0 THEN BEGIN
        Circles = REPLICATE({x:0.0d,y:0.0d,r:0.0d},N_ELEMENTS(oRA))
        Circles.x = oRA
        Circles.y = oDEC
        Circles.r = oRAD
        CircleLabels = oLABEL
        CircleColors = oCOLOR
        CircleThicks = oTHICK
        CircleDashed = oLDASH
    ENDIF
    
END

; ##################### ;
; Subroutine ReadDS9Reg ;
; ##################### ;

PRO ReadDS9Reg, DS9RegFile, RA=oRA, DEC=oDEC, RAD=oRAD, LABEL=oLABEL, COLOR=oCOLOR, LDASH=oLDASH, $
                Circles=Circles, CircleLabels=CircleLabels, CircleColors=CircleColors, CircleDashed=CircleDashed
    
    ; DS9RegFile = '/Users/dliu/Working/2014-CEA/Data/Level_3_SciData/Lagache/ds9.1160.Adds.fk5.reg'
    
    oRA = []
    oDEC = []
    oRAD = []
    oLABEL = []
    oCOLOR = []
    oLDASH = []
    GlobalLABEL = ''
    GlobalCOLOR = 'green'
    GlobalLDASH = 0
    
    IF FILE_TEST(DS9RegFile) THEN BEGIN
        ; Message
        MESSAGE, 'Reading ds9 region file '+DS9RegFile, /CONTINUE, /INFORM
        OPENR, fp, DS9RegFile, /GET_LUN
        fl = ''
        WHILE ~EOF(fp) DO BEGIN
            READF, fp, fl
            IF STRMATCH(fl,'global color=*',/F) THEN BEGIN
                fs1 = 'global color='
                fs2 = ' '
                fp1 = STRPOS(fl,fs1)+strlen(fs1)
                fp2 = STRPOS(fl,fs2,fp1)
                ft  = STRMID(fl,fp1,fp2-fp1)
                GlobalCOLOR = STRTRIM(ft,2)
            ENDIF
            IF STRMATCH(fl,'global *dash=*',/F) THEN BEGIN
                ft = ReadOneLineSTRMID(fl, 'dash=', ' ')
                GlobalLDASH = ft
            ENDIF
            IF STRMATCH(fl,'circle(*',/F) THEN BEGIN
                fRA = ReadOneLineSTRMID(fl, 'circle(', ',', ftext=ft, fnext=fs)  ; PRINT, ft, fRA
                fDEC = ReadOneLineSTRMID(fl, fs, ',', ftext=ft, fnext=fs)        ; PRINT, ft, fDEC
                fRAD = ReadOneLineSTRMID(fl, fs, '"', ftext=ft, fnext=fs)        ; PRINT, ft, fRAD
                fLABEL = GlobalLABEL
                fCOLOR = GlobalCOLOR
                fLDASH = GlobalLDASH
                IF STRMATCH(fl,'*text=*',/F) THEN fLABEL = ReadOneLineSTRMID(fl, 'text={', '}', ftext=ft, fnext=fs) ; PRINT, ft, fLABEL
                IF STRMATCH(fl,'*color=*',/F) THEN fCOLOR = ReadOneLineSTRMID(fl, 'color=', ' ', ftext=ft, fnext=fs) ; PRINT, ft, fCOLOR
                IF STRMATCH(fl,'*dash=*',/F) THEN fLDASH = FIX(ReadOneLineSTRMID(fl, 'dash=',' ',ftext=ft, fnext=fs)) ; PRINT, ft, fLDASH ; <modified><20150505><dzliu>
                ; PRINT, fRA, " ", fDEC, " ", fRAD, " ", fLABEL, " ", fCOLOR, " ", fLDASH
                oRA = [ oRA, fRA ]
                oDEC = [ oDEC, fDEC ]
                oRAD = [ oRAD, fRAD ]
                oLABEL = [ oLABEL, fLABEL ]
                oCOLOR = [ oCOLOR, fCOLOR ]
                oLDASH = [ oLDASH, fLDASH ]
            ENDIF
        ENDWHILE
        CLOSE, fp
        FREE_LUN, fp
    ENDIF ELSE BEGIN
        MESSAGE, 'Error! ds9 region file '+DS9RegFile+' not found!'
    ENDELSE
    
    ; make circles
    IF N_ELEMENTS(oRA) GT 0 THEN BEGIN
        Circles = REPLICATE({x:0.0d,y:0.0d,r:0.0d},N_ELEMENTS(oRA))
        Circles.x = oRA
        Circles.y = oDEC
        Circles.r = oRAD
        CircleLabels = oLABEL
        CircleColors = oCOLOR
        CircleDashed = oLDASH
    ENDIF
    
END





























; ###################################### ;
; ###################################### ;
;                                        ;
; Main Program -- GalMon                 ;
;                                        ;
; ###################################### ;
; ###################################### ;

PRO GalMon, PriorCatalog, SelectID, PhotoList, RegionList, SaveEPS=SaveEPS, Verbose=Verbose, RA=RA, Dec=Dec, ForceOneRow=ForceOneRow, ForceOneRadius=ForceOneRadius, WithTextCharSize=TextCharSize, WithTextCharThick=TextCharThick, WithCircleThicks=CircleThicks, PowerLawScale=PowerLawScale
    
    IF N_ELEMENTS(PriorCatalog) EQ 1 AND N_ELEMENTS(SelectID) EQ 1 THEN BEGIN
        IF FILE_TEST(PriorCatalog) EQ 0 THEN MESSAGE, 'PriorCatalog does not exist! Please check '+PriorCatalog
        ; Read Catalog and Select Object
        ReadCol, FORMAT='(L,D,D)', COMMENT='#', PriorCatalog, ObjID, ObjRA, ObjDEC    
        ObjSe = WHERE(ObjID EQ SelectID,/NULL)    
        IF N_ELEMENTS(ObjSe) EQ 0 THEN MESSAGE, "FindObjectAndMakeCutouts: No object found! Please check object ID "+SelectID
        PRINT, FORMAT='("Found object ID",I0," RA Dec ",F0.7," ",F0.7)', SelectID, ObjRA[ObjSe], ObjDEC[ObjSe]
    ENDIF ELSE IF N_ELEMENTS(RA) EQ 1 AND N_ELEMENTS(Dec) EQ 1 THEN BEGIN
        ObjSe = 0
        IF SIZE(RA,/TNAME) EQ 'STRING' AND SIZE(DEC,/TNAME) EQ 'STRING' THEN BEGIN
            hms2deg, RA+" "+Dec, TempRADEC
            ObjRA = [TempRADEC[0]]
            ObjDEC = [TempRADEC[1]]
            degdeg2hmsdms, [ObjRA[ObjSe],ObjDEC[ObjSe]], TempRADECstring, /SeparateByNothing
            SelectID = "J"+TempRADECstring
        ENDIF ELSE BEGIN
            ObjRA = [RA]
            ObjDEC = [Dec]
            degdeg2hmsdms, [ObjRA[ObjSe],ObjDEC[ObjSe]], TempRADECstring, /SeparateByNothing
            SelectID = "J"+TempRADECstring
        ENDELSE
        PRINT, FORMAT='("Centering at RA Dec ",F0.7," ",F0.7)', ObjRA[ObjSe], ObjDEC[ObjSe]
    ENDIF ELSE BEGIN
        MESSAGE, 'Usage: AstroDepthFaireMontage, PriorCatalog, SelectID, RA=RA, Dec=Dec, PhotoList, RegionList, SaveEPS=SaveEPS, Verbose=Verbose'
    ENDELSE
    
    IF N_ELEMENTS(PhotoList) EQ 0 THEN BEGIN
        ; MESSAGE, 'Usage: AstroDepthFaireMontage, PriorCatalog, SelectID, PhotoList, RegionList, SaveEPS=SaveEPS, Verbose=Verbose'
        PhotoList = "iPhotoList.txt"
        IF FILE_TEST(PhotoList) EQ 0 THEN BEGIN
            MESSAGE, 'Error! No PhotoList give, not exist! Please check '+PhotoList
        ENDIF ELSE BEGIN
            MESSAGE, 'Warning! No PhotoList given, but found '+PhotoList+' under current directory. Using this one. ', /CONTINUE, /INFORM
        ENDELSE
    ENDIF ELSE BEGIN
        IF FILE_TEST(PhotoList) EQ 0 THEN BEGIN
            MESSAGE, 'Error! PhotoList does not exist! Please check '+PhotoList
        ENDIF
    ENDELSE
    
    IF N_ELEMENTS(RegionList) EQ 0 THEN BEGIN
        RegionList = "iRegionList.txt"
        IF FILE_TEST(RegionList) EQ 0 THEN BEGIN
            RegionList = !NULL
            MESSAGE, 'Warning! No RegionList given, there will be no region circles.', /CONTINUE
        ENDIF ELSE BEGIN
            MESSAGE, 'Warning! No RegionList given, but found '+RegionList+' under current directory. Using this one. ', /CONTINUE, /INFORM
        ENDELSE
    ENDIF ELSE BEGIN
        IF FILE_TEST(RegionList) EQ 0 THEN BEGIN
            MESSAGE, 'Error! RegionList does not exist! Please check '+RegionList
        ENDIF
    ENDELSE
    
    IF N_ELEMENTS(SaveEPS) EQ 0 THEN BEGIN
        SaveEPS = STRING(FORMAT='(I0)',SelectID)+'.eps'
    ENDIF
    
    
    ; Read PhotoList and Field of View
    ; PhotoList = "PhotoList.txt"
    ReadCol, FORMAT='(A,I,D)', COMMENT='#', PhotoList, InputFits, InputExts, InputFoVs
    InputRect = REPLICATE( { x1:0.0D, x2:0.0D, y1:0.0D, y2:0.0D, width:0.0D, height:0.0D } , N_ELEMENTS(InputFits) )
    
    
    FOR i=0,N_ELEMENTS(InputFits)-1 DO BEGIN
        
        IF InputFits[i] EQ '' THEN CONTINUE
        
        IF NOT FILE_TEST(InputFits[i]) THEN MESSAGE, 'Error! Fits file '+InputFits[i]+' not found!'
        
        FoVX = InputFoVs[i] ; 10.0 ; " diameter
        FoVY = InputFoVs[i] ; 10.0 ; " diameter
        
        FitsHeader = HeadFits(InputFits[i],EXTEN=InputExts[i])
        ExtAst, FitsHeader, FitsWCS
        PixScale = [ FitsWCS.CD[0,0]*FitsWCS.CDELT[0]*3600.0, FitsWCS.CD[1,1]*FitsWCS.CDELT[1]*3600.0 ] ; "/pix
        AD2XY, ObjRA[ObjSe], ObjDEC[ObjSe], FitsWCS, ObjX, ObjY
        ObjX = ObjX + 1.0D
        ObjY = ObjY + 1.0D
        ; PRINT, FORMAT='(F0.7," ",F0.7," ",F0.3," ",F0.3)', ObjRA[ObjSe], ObjDEC[ObjSe], ObjX, ObjY
        ObjX1 = ObjX-0.5*(FoVX/ABS(PixScale)-1)
        ObjY1 = ObjY-0.5*(FoVY/ABS(PixScale)-1)
        ObjX2 = ObjX+0.5*(FoVX/ABS(PixScale)-1)
        ObjY2 = ObjY+0.5*(FoVY/ABS(PixScale)-1)
        ; PRINT, ObjX2-ObjX1, ObjY2-ObjY1
        InputRect[i].x1 = ObjX1
        InputRect[i].x2 = ObjX2
        InputRect[i].y1 = ObjY1
        InputRect[i].y2 = ObjY2
        InputRect[i].width = ObjX2-ObjX1+1.0D
        InputRect[i].height = ObjY2-ObjY1+1.0D
        ; <TODO> if we want to shift the FoV center, uncomment the lines below -- usually for very large FoV
        ; InputRect[i].x1 = InputRect[i].x1 - InputRect[i].width*0.18 ; <TODO> shift the FoV center
        ; InputRect[i].x2 = InputRect[i].x2 - InputRect[i].width*0.18 ; <TODO> shift the FoV center
        ; InputRect[i].y1 = InputRect[i].y1 + InputRect[i].height*0.20 ; <TODO> shift the FoV center
        ; InputRect[i].y2 = InputRect[i].y2 + InputRect[i].height*0.20 ; <TODO> shift the FoV center
        ; PRINT, FORMAT='("RECT: ",F12.3," ",F12.3," ",F12.3," ",F12.3)', InputRect[i].x1, InputRect[i].y1, InputRect[i].width, InputRect[i].height
        
    ENDFOR
    
    ; Prepare Circles
    Circles = []
    CircleColors = []
    CircleLabels = []
    CircleDashed = []
    CircleBelong = []
    
    
    ; Read RegionList
    IF N_ELEMENTS(RegionList) GT 0 THEN BEGIN
        ; RegionList = "RegionList.txt"
        ReadCol, FORMAT='(A,A)', COMMENT='#', DELIMITER=' ', RegionList, RegionFiles, RegionFrames
        FOR i=0,N_ELEMENTS(RegionFiles)-1 DO BEGIN
            DS9RegFile = RegionFiles[i]
            ReadDS9Reg_Fast, DS9RegFile, Circles=CirclesIncl, CircleColors=CircleColorsIncl, CircleLabels=CircleLabelsIncl, CircleDashed=CircleDashedIncl
            TempFrames = FIX(STRSPLIT(RegionFrames[i],',',/extract))
            ; <TODO> 
            ; <modified><20150505><dzliu> redefine circle radius
            ; CirclesIncl.r = CirclesIncl.r * 0.0 + 4.0 ; <TODO> 
            ; <modified><20150917><dzliu> ForceOneRadius
            IF KEYWORD_SET(ForceOneRadius) THEN BEGIN 
                CirclesIncl.r = CirclesIncl.r * 0.0 + FLOAT(ForceOneRadius)
            ENDIF
            FOREACH TempFrame, TempFrames DO BEGIN
                Circles = [Circles,CirclesIncl]
                CircleColors = [CircleColors,CircleColorsIncl]
                CircleLabels = [CircleLabels,CircleLabelsIncl]
                CircleDashed = [CircleDashed,CircleDashedIncl]
                CircleBelong = [CircleBelong,REPLICATE(TempFrame,N_ELEMENTS(CirclesIncl))] ; <TODO> TempFrame is the TempFrame-th image, starting from 1. 
            ENDFOREACH
        ENDFOR
    ENDIF
    
    
    ; 
    Crosses = {x:ObjRA[ObjSe[0]], y:ObjDEC[ObjSe[0]], r:4.0d}
    CrossColors = 'green'
;   CrossColors = 'firebrick'
    
;   ; <TODO><DEBUG>
;   CircleFilter = WHERE(CircleLabels EQ 'ID12646',/NULL) ; <TODO><DEBUG>
;   Circles = Circles[CircleFilter]                       ; <TODO><DEBUG>
;   CircleColors = CircleColors[CircleFilter]             ; <TODO><DEBUG>
;   CircleLabels = CircleLabels[CircleFilter]             ; <TODO><DEBUG>
;   Circles = []
    
    
;   ; <TODO> Select ID 13161,13207,13107,9710 and show with colorful crosses
;   Cid = WHERE(CircleLabels EQ 'ID9710', /NULL)
;   Crosses = [Crosses,Circles[Cid[0]]]
;   Cid = WHERE(CircleLabels EQ 'ID13161', /NULL)
;   Crosses = [Crosses,Circles[Cid[0]]]
;   Cid = WHERE(CircleLabels EQ 'ID13207', /NULL)
;   Crosses = [Crosses,Circles[Cid[0]]]
;   Cid = WHERE(CircleLabels EQ 'ID13107', /NULL)
;   Crosses = [Crosses,Circles[Cid[0]]]
;   ;               green      cyan       orange     red        purple
;   CrossColors = ['19D119'xL,'FFD119'xL,'0066FF'xL,'0000CC'xL,'9900CC'xL]
;   Crosses.r[*] = 7.5d ; <TODO>
    
    
;   ; <TODO>
;   Cid = WHERE(CircleDashed NE 0) & Circles[Cid].x = -1 & Circles[Cid].y = -1 ; <TODO> if we want to show dashed circles, comment this. default is off (show dashed circles).
    
    
    ; <TODO>
    IF N_ELEMENTS(CircleDashed) GT 0 THEN BEGIN
    Cid = WHERE(CircleDashed NE 0) & CircleLabels[Cid] = "" ; <TODO> if we want to show dahsed labels, comment this. default is on (hide dahsed labels).  
    ENDIF
    
    
;   ; <TODO>
;   CircleLabels = [] ; <TODO> if we want to hide all labels, uncomment this. default is on. 
    
    
    CrabImageMosaic, InputFits=InputFits, InputExts=InputExts, InputRect=InputRect, SaveEPS=SaveEPS, $
                     WithCircles=Circles, WithCircleColors=CircleColors, WithCircleDashed=CircleDashed, $
                     WithCircleBelong=CircleBelong, WithCircleLabels=CircleLabels, WithCircleThicks=CircleThicks, $ ; CircleLabels ; [ObjRA[ObjSe],ObjDEC[ObjSe],3.0D]
                     WithCrosses=Crosses, WithCrossColors=CrossColors, $
                     WithCrossBelong=CrossBelong, Verbose=Verbose, ForceOneRow=ForceOneRow, WithTextCharSize=TextCharSize, WithTextCharThick=TextCharThick, $
                     PowerLawScale=PowerLawScale
    
    ; screencapture
    ; DEVICE, GET_WINDOW_POSITION=winPos, GET_SCREEN_SIZE=scnSize
    ; screencapture -R x1,y-y1,
    ; PRINT, 'screencapture -P -x -o -R '+STRING(FORMAT='(I0,",",I0,",",I0,",",I0)',winPos[0],scnSize[1]-!D.Y_SIZE+16,!D.X_SIZE,!D.Y_SIZE)+ '  Snapshot.PNG'
    ; SPAWN, 'screencapture -P -x -o -R '+STRING(FORMAT='(I0,",",I0,",",I0,",",I0)',winPos[0],scnSize[1]-!D.Y_SIZE+16,!D.X_SIZE,!D.Y_SIZE)+ '  Snapshot.PNG'
    
    ; xwininfo
    ; SPAWN, '/opt/local/bin/xwd -name "IDL 1" -out Snapshot.xwd'
    ; Snapshot = CrabReadXWDImage("Snapshot.xwd",R,G,B)
    ; WRITE_PNG, "Snapshot.png", Snapshot ,R,G,B
    ; SPAWN, 'open Snapshot.png'
    ; PRINT, 'Snapshot has been saved to Snapshot.png under current dir. '
    
    ConvertPS2PDF, SaveEPS
    
    ; Done
    PRINT, 'Done!'
    
END
