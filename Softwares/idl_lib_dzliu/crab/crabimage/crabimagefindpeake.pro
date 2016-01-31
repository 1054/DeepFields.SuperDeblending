FUNCTION CrabImageFindPeakE, GalaxyImage, InitPosX, InitPosY, $
                                           MaxPeakNumber=MaxPeakNumber, $
                                           MaxPeakValue=MaxPeakValue, $
                                           MaxAreaPercent=MaxAreaPercent, $
                                           AllPeaks=AllPeaks,$
                                           NoCheck=NoCheck, DoPlot=DoPlot, DoCheck=DoCheck, DoGlitchCheck=DoGlitchCheck, OutputFile=OutputFile
    ; 
    IF SIZE(GalaxyImage,/N_DIM) NE 2 THEN RETURN, !NULl
    ; Find the MAX point of the image, which should be considered as the centre of the source.
    ImageSize = SIZE(GalaxyImage,/DIMENSION)
    DenanImage = GalaxyImage
    DenanImage[WHERE(~FINITE(DenanImage))] = MIN(DenanImage,/NAN) ; 0.d
    
    ; Setup Peak Data Structure
    LePeak = {Position:[0.0,0.0],MaxValue:0.0D,MinValue:0.0D,PixLists:PTR_NEW(),PixValues:[0.0]}
    
    
    ; Loop to find peaks
    ; ImageMaxValue = !Values.D_NAN
    CurLoopFlag = -1 ; starts from -1
    CurLoopNumb = 1
    CurMaxIndex = 0
    CurLoopPosX = InitPosX
    CurLoopPosY = InitPosY
    ; Use MaxPeakNumber to limit the number of peaks we want to find
    IF N_ELEMENTS(MaxAreaPercent) EQ 0 THEN MaxAreaPercent=0.5 ; defaultly we use MaxAreaPercent to constrain
   ;WHILE CurLoopFlag NE -2 DO BEGIN
    WHILE 1 EQ 1 DO BEGIN
        DenanImage[CurLoopPosX-1,CurLoopPosY-1]
        CurMaxValue = MAX(DenanImage,/NAN)
        CurMaxIndex = WHERE(DenanImage EQ CurMaxValue,/NULL)
        IF N_ELEMENTS(MaxAreaPercent) EQ 1 THEN BEGIN
            IF (N_ELEMENTS(LePeak->PixLists)) GE MaxAreaPercent*(N_ELEMENTS(DenanImage)) THEN BREAK ; MaxAreaPercent=50%
        ENDIF
        IF (N_ELEMENTS(LePeak->PixLists)) EQ (N_ELEMENTS(DenanImage)) THEN BEGIN
            PRINT, 'CrabImageFindPeaks: Looped all pixels! Wonderful! Will finish loop now!'
            BREAK
        ENDIF
        CurMinIndex = WHERE(DenanImage EQ TotMinValue,/NULL) ; all looped pixels will set to TotMinValue
        CurLoopPercent = (N_ELEMENTS(LePeak->PixLists))/(N_ELEMENTS(DenanImage)) ; calculate the percent of looped pixel number
        IF CurLoopPercent GE 0.1 THEN BEGIN ; we will finish loop if 10% pixels have been looped
            ;PRINT, 'CrabImageFindPeaks: Looped more than 10% of all pixels! Will finish loop now!'
            ;BREAK
        ENDIF
        IF (CurLoopPercent*1000.0 - FIX(CurLoopPercent*1000.0)) LE 0.01 THEN BEGIN ; 0.1% 0.2% 0.3%
            PRINT, 'CrabImageFindPeaks: Looped more than '+STRING(FORMAT='(F0.1)',CurLoopPercent*100.0)+'% of all pixels! Keep going!'
        ENDIF
        ; 
        ; OK, go on to check current max pixel
        ; Check whether it belongs to one peak or it is a new isolated peak
        ;  
        IF N_ELEMENTS(CurMaxIndex) GT 0 THEN BEGIN
            CurMaxIndex = CurMaxIndex[0]
            CurMaxPixel = [ LONG(CurMaxIndex MOD ImageSize[0]), LONG(CurMaxIndex/ImageSize[0]) ]
            ; check whether this max pixel is adjacent to one of the ListPeaks
            CurLoopFlag = -1
            DiffX = [-1]
            DiffY = [-1]
            
            IF N_ELEMENTS(ListPeaks) GT 0 THEN BEGIN
                ; sort the nearest peak centres
                DiffX = ABS(ListPeaks.Position[0] - CurMaxPixel[0])
                DiffY = ABS(ListPeaks.Position[1] - CurMaxPixel[1])
                DiffR = DiffX^2 + DiffY^2
                LoopI = SORT(DiffR) ; INDGEN(N_ELEMENTS(ListPeaks))-1
                ; then check whether this max pix belongs to one of found peaks
                FOREACH i, LoopI DO BEGIN
                    DiffX = ABS( *ListPeaks[i].PixI - CurMaxPixel[0])
                    DiffY = ABS( *ListPeaks[i].PixJ - CurMaxPixel[1])
                    IF MIN(DiffX) LE 1 AND MIN(DiffY) LE 1 THEN BEGIN
                        CurLoopFlag = i
                        ; IF CurLoopFlag EQ 16 AND DiffR[i] GT 15 THEN BEGIN ; <TODO><DEBUG>
                        ;     PRINT, 'Peak position: ', ListPeaks[i].Position[0], ListPeaks[i].Position[1]
                        ;     PRINT, 'Current posit: ', CurMaxPixel[0], CurMaxPixel[1]
                        ;     PRINT, 'DEBUG! 16!'
                        ; ENDIF
                        BREAK
                    ENDIF
                ENDFOREACH
            ENDIF
            ; if not, then we found a new peak
            IF CurLoopFlag EQ -1 THEN BEGIN ; create new peak
                OnePeak = {  Id:N_ELEMENTS(ListPeaks), Pixel:CurMaxPixel, Position:CurMaxPixel+1.0, $
                             MaxValue:CurMaxValue, MinValue:0.0D, Centroid:[0.0D,0.0D], $
                             PixI:PTR_NEW(/ALLOCATE), PixJ:PTR_NEW(/ALLOCATE), $
                             PosX:PTR_NEW(/ALLOCATE), PosY:PTR_NEW(/ALLOCATE), $
                             PixValues:PTR_NEW(/ALLOCATE), PixCount:0L }
                (*OnePeak.PixI)  = [ CurMaxPixel[0] ]
                (*OnePeak.PixJ)  = [ CurMaxPixel[1] ]
                (*OnePeak.PosX)  = [ CurMaxPixel[0]+1.0 ]
                (*OnePeak.PosY)  = [ CurMaxPixel[1]+1.0 ]
                (*OnePeak.PixValues) = [ CurMaxValue ]
                OnePeak.MinValue = MIN((*OnePeak.PixValues))
                OnePeak.Centroid = [ TOTAL((*OnePeak.PixValues)*(*OnePeak.PosX))/TOTAL((*OnePeak.PixValues)),$
                                     TOTAL((*OnePeak.PixValues)*(*OnePeak.PosY))/TOTAL((*OnePeak.PixValues)) ]
                OnePeak.PixCount = N_ELEMENTS((*OnePeak.PixValues))
                ;PRINT, FORMAT='(A,I0,A,I0)', "PeakId=",OnePeak.Id," PeakX=",OnePeak.Position CurMaxPixel[0], CurMaxPixel[2]
                ListPeaks = [ ListPeaks, OnePeak ]
                CurLoopFlag = N_ELEMENTS(ListPeaks)-1
            ; if yes, then we just add this point to the matched peak
            ENDIF ELSE BEGIN
                OnePeak = ListPeaks[CurLoopFlag]
                (*OnePeak.PixI)  = [ (*OnePeak.PixI), CurMaxPixel[0] ]
                (*OnePeak.PixJ)  = [ (*OnePeak.PixJ), CurMaxPixel[1] ]
                (*OnePeak.PosX)  = [ (*OnePeak.PosX), CurMaxPixel[0]+1.0 ]
                (*OnePeak.PosY)  = [ (*OnePeak.PosY), CurMaxPixel[1]+1.0 ]
                (*OnePeak.PixValues) = [ (*OnePeak.PixValues), CurMaxValue ]
                OnePeak.MinValue = MIN((*OnePeak.PixValues))
                OnePeak.Centroid = [ TOTAL((*OnePeak.PixValues)*(*OnePeak.PosX))/TOTAL((*OnePeak.PixValues)),$
                                     TOTAL((*OnePeak.PixValues)*(*OnePeak.PosY))/TOTAL((*OnePeak.PixValues)) ]
                OnePeak.PixCount = N_ELEMENTS((*OnePeak.PixValues))
                ListPeaks[CurLoopFlag] = OnePeak
            ENDELSE
            
            ;; ; check that the points adjacent to the max point have values no smaller than 1/3 of the max value. 
            ;; ; this can avoid the bad points be recognized as the max point. 
            ;; IF KEYWORD_SET(DoCheck) AND NOT KEYWORD_SET(NoCheck) THEN BEGIN
            ;;     TempMaxPointCheck = GalaxyImage[CurMaxPixel[0]-1,CurMaxPixel[1]-1] + $
            ;;                         GalaxyImage[CurMaxPixel[0]-1,CurMaxPixel[1]+1] + $
            ;;                         GalaxyImage[CurMaxPixel[0]+1,CurMaxPixel[1]+1] + $
            ;;                         GalaxyImage[CurMaxPixel[0]+1,CurMaxPixel[1]-1]
            ;;     IF TempMaxPointCheck LT 0.1*CurMaxValue THEN ImageMaxValue = !Values.D_NAN ; <TODO> 0.3
            ;;     IF TempMaxValue EQ 0 THEN ImageMaxValue = 0 ; <TODO> 0
            ;; ENDIF
            
            ; prepare to find next max point
            DenanImage[CurMaxIndex] = CurMinValue
            CurLoopNumb = CurLoopNumb + 1
        ENDIF
    ENDWHILE
    PRINT, 'CrabImageFindPeaks: Looped as many as '+STRING(FORMAT='(F0.3)',CurLoopPercent*100.0)+'% of all pixels!'
   ;MaxValue = ListPeaks[0].MaxValue
    
    
    IF KEYWORD_SET(DoPlot) THEN BEGIN
        TVZoom=800
        TVWindow=6
        
        CrabImageQuickPlot, GalaxyImage, TVZoom=TVZoom, TVWindow=TVWindow, TVScale=0.2
        
        PRINT, FORMAT='("#",A11,A12,A12,A15,A16,A16,A24)', 'ID', "I", "J", "CircRad", "MaxPixValue", "MinPixValue", "ReadPosIJ"
        
        FOREACH OnePeak, ListPeaks DO BEGIN
            
            IF (OnePeak.Centroid)[0] LE 0.0 THEN BEGIN
                PRINT, 'DEBUG!!!'
            ENDIF
            
            ; TVCircle, SQRT(N_ELEMENTS(*OnePeak.PixValues)/!PI)*TVZoom, OnePeak.Position[0]*TVZoom, OnePeak.Position[1]*TVZoom
            
            CircRad = (OnePeak.PixCount)^0.25
            IF CircRad LT 1.0 THEN CircRad = 1.0
            
            CrabImageTVCircle, [OnePeak.Pixel[0],OnePeak.Pixel[1],CircRad], ImageSize=ImageSize, $
                               CircleLabels=[STRING(FORMAT='(I0)',OnePeak.Id)]
            PRINT, FORMAT='(I12,I12,I12,F15.6,G16.6,G16.6,A24)', OnePeak.Id, OnePeak.Position[0], OnePeak.Position[1], $
                   CircRad, OnePeak.MaxValue, OnePeak.MinValue, STRING(FORMAT='("[",F0.3,",",F0.3,"]")',OnePeak.Centroid)
            ; XYOUTS, OnePeak.Position[0]*TVZoom, OnePeak.Position[1]*TVZoom, STRING(FORMAT='(I0)',OnePeak.Id), /DEVICE, COLOR=cgColor('red')
            
        ENDFOREACH
    ENDIF
    
    
    IF N_ELEMENTS(OutputFile) EQ 1 AND SIZE(OutputFile,/TNAME) EQ "STRING" THEN BEGIN
        OPENW, OutputUnit, OutputFile, /GET_LUN
        PRINTF, OutputUnit, "          Id           X           Y       PixCount    PeakMaxValue    PeakMinValue            PeakCentroid"
        FOREACH OnePeak, ListPeaks DO BEGIN
            PRINTF, OutputUnit, FORMAT='(I12,I12,I12,I15,G16.6,G16.6,A24)', OnePeak.Id, OnePeak.Position[0], OnePeak.Position[1], $
                    OnePeak.PixCount, OnePeak.MaxValue, OnePeak.MinValue, STRING(FORMAT='("[",F0.3,",",F0.3,"]")',OnePeak.Centroid)
        ENDFOREACH
        CLOSE, OutputUnit
        FREE_LUN, OutputUnit
        ; OutputPNG = OutputFile+'.png'
        ; WSET, TVWindow
        ; WRITE_PNG, OutputPNG, TVRD(/TRUE)
    ENDIF
    
    AllPeaks = ListPeaks
    
    RETURN, AllPeaks
END
