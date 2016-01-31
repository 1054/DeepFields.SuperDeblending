; CrabImageMaxPoint
; CrabImageMaxPixel
; CrabImageMinPixel
; CrabImageCentrePoint
; CrabImageSkyValue
; CrabImageNaNFilter
; ImageNaNFilter
; CrabImageStat


FUNCTION CrabImageStat
    RETURN, 0
END



FUNCTION CrabImageMaxPoint, GalaxyImage, MaxPeaks=MaxPeaks, $
                            MaxPercent=MaxPercent, MaxValue=MaxValue, $
                            AllPeaks=AllPeaks,$
                            NoCheck=NoCheck, DoCheck=DoCheck, DoGlitchCheck=DoGlitchCheck, OutputFile=OutputFile
    ; 
    IF SIZE(GalaxyImage,/N_DIM) NE 2 THEN RETURN, !NULl
    ; Find the MAX point of the image, which should be considered as the centre of the source.
    ImageSize = SIZE(GalaxyImage,/DIMENSION)
    DenanImage = GalaxyImage
    DenanImage[WHERE(~FINITE(DenanImage))] = MIN(DenanImage,/NAN) ; 0.d
    ; Setup Structure
    ; OnePeak = {Position:[0.0,0.0],MaxValue:0.0D,MinValue:0.0D,PixPosList:MAKE_ARRAY(),PixValues:[0.0]}
    ListPeaks = []
    ; Loop to find peaks
    ; ImageMaxValue = !Values.D_NAN
    CurLoopFlag = -1 ; starts from -1
    CurLoopNumb = 1
    CurMaxIndex = 0
    CurMaxPixel = [0.0,0.0]
    CurMaxValue = !Values.D_NAN
    CurMinValue = MIN(DenanImage,/NAN)
    TotMaxValue = MAX(DenanImage,/NAN)
    TotMinValue = MIN(DenanImage,/NAN)
    CurPixPositList = []
    CurPixValueList = []
    ; Use MaxPeaks to limit the number of peaks we want to find
    IF N_ELEMENTS(MaxPeaks) EQ 0 AND N_ELEMENTS(MaxPercent) EQ 0 THEN MaxPercent=0.5 ; defaultly we use MaxPercent to constrain
   ;WHILE CurLoopFlag NE -2 DO BEGIN
    WHILE 1 EQ 1 DO BEGIN
        CurMaxValue = MAX(DenanImage,/NAN)
        CurMaxIndex = WHERE(DenanImage EQ CurMaxValue,/NULL)
        IF N_ELEMENTS(MaxPercent) EQ 1 THEN BEGIN
            IF (CurMaxValue-CurMinValue) LE MaxPercent*(TotMaxValue-TotMinValue) THEN BREAK ; MaxPercent=50%
        ENDIF
        IF N_ELEMENTS(MaxPeaks) EQ 1 THEN BEGIN
            IF N_ELEMENTS(ListPeaks) LE MaxPeaks THEN BREAK
        ENDIF
        IF (CurMaxValue-TotMinValue) EQ 0 THEN BEGIN
            PRINT, 'CrabImageMaxPoint: Looped all pixels! Wonderful! Will finish loop now!'
            BREAK
        ENDIF
        CurMinIndex = WHERE(DenanImage EQ TotMinValue,/NULL) ; all looped pixels will set to TotMinValue
        CurLoopPercent = N_ELEMENTS(CurMinIndex)*1.0/N_ELEMENTS(DenanImage) ; calculate the percent of looped pixel number
        IF CurLoopPercent GE 0.1 THEN BEGIN ; we will finish loop if 10% pixels have been looped
            ;PRINT, 'CrabImageMaxPoint: Looped more than 10% of all pixels! Will finish loop now!'
            ;BREAK
        ENDIF
        IF (CurLoopPercent*1000.0 - FIX(CurLoopPercent*1000.0)) LE 0.001 THEN BEGIN ; 0.1% 0.2% 0.3%
            PRINT, 'CrabImageMaxPoint: Looped more than '+STRING(FORMAT='(F0.1)',CurLoopPercent*100.0)+'% of all pixels! Keep going!'
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
    MaxValue = ListPeaks[0].MaxValue
    
    
    
    IF N_ELEMENTS(OutputFile) EQ 1 AND SIZE(OutputFile,/TNAME) EQ "STRING" THEN BEGIN
        OPENW, OutputUnit, OutputFile, /GET_LUN
        PRINTF, OutputUnit, "          Id           X           Y       PixCount    PeakMaxValue    PeakMinValue            PeakCentroid"
        
        TVZoom=800
        TVWindow=6
        CrabImageQuickPlot, GalaxyImage, TVZoom=TVZoom, TVWindow=TVWindow
        FOREACH OnePeak, ListPeaks DO BEGIN
            PRINTF, OutputUnit, FORMAT='(I12,I12,I12,I15,G16.6,G16.6,A24)', OnePeak.Id, OnePeak.Position[0], OnePeak.Position[1], $
                    OnePeak.PixCount, OnePeak.MaxValue, OnePeak.MinValue, STRING(FORMAT='("[",F0.3,",",F0.3,"]")',OnePeak.Centroid)
            
            ; TVCircle, SQRT(N_ELEMENTS(*OnePeak.PixValues)/!PI)*TVZoom, OnePeak.Position[0]*TVZoom, OnePeak.Position[1]*TVZoom
            CrabImageTVCircle, [OnePeak.Pixel,OnePeak.PixCount], Normal=ImageSize
            
            XYOUTS, OnePeak.Position[0]*TVZoom, OnePeak.Position[1]*TVZoom, STRING(FORMAT='(I0)',OnePeak.Id), /DEVICE, COLOR=cgColor('red')
            
        ENDFOREACH
        CLOSE, OutputUnit
        FREE_LUN, OutputUnit
        OutputPNG = OutputFile+'.png'
        ; WSET, TVWindow
        ; WRITE_PNG, OutputPNG, TVRD(/TRUE)
    ENDIF
    
    AllPeaks = ListPeaks
    
    RETURN, MaxValue
END 
    
    
    
FUNCTION CrabImagePeaks, GalaxyImage, MaxPeaks=MaxPeaks, MaxPercent=MaxPercent, MaxValue=MaxValue, NoCheck=NoCheck, DoCheck=DoCheck, DoGlitchCheck=DoGlitchCheck, OutputFile=OutputFile
    RETURN, CrabImageMaxPoint(GalaxyImage, MaxPeaks=MaxPeaks, MaxPercent=MaxPercent, MaxValue=MaxValue, NoCheck=NoCheck, DoCheck=DoCheck, DoGlitchCheck=DoGlitchCheck, OutputFile=OutputFile)
END





FUNCTION CrabImageCentrePoint, GalaxyImage, CentreValue=CentreValue
    ; Find the centre pixel. 
    ImageSize = SIZE(GalaxyImage,/DIMENSION)
    DenanImage = GalaxyImage
    DenanImage[WHERE(~FINITE(DenanImage))] = MIN(DenanImage,/NAN) ; 0.d
    ImageCentrePosX  = ImageSize[0]*1.0/2.0 ; starts from 0
    ImageCentrePosY  = ImageSize[1]*1.0/2.0 ; starts from 0
    ImageCentreVLB = DenanImage[LONG(ImageCentrePosX)+0,LONG(ImageCentrePosY)+0] ; left bottom
    ImageCentreVLT = DenanImage[LONG(ImageCentrePosX)+0,LONG(ImageCentrePosY)+1] ; left top
    ImageCentreVRT = DenanImage[LONG(ImageCentrePosX)+1,LONG(ImageCentrePosY)+1] ; right top
    ImageCentreVRB = DenanImage[LONG(ImageCentrePosX)+1,LONG(ImageCentrePosY)+0] ; right bottom
    IF N_ELEMENTS(DoInterpolation) THEN BEGIN
        ImageCentreValue = ImageCentreVLB ; <TODO> interpolation???
    ENDIF ELSE BEGIN
        ImageCentrePosX  = LONG(ImageCentrePosX)
        ImageCentrePosY  = LONG(ImageCentrePosY)
        ImageCentreValue = ImageCentreVLB
    ENDELSE
    ImageCentrePos = [ImageCentrePosX,ImageCentrePosY]
    CentreValue = ImageCentreValue
    RETURN, ImageCentrePos
END



FUNCTION CrabImageSumPixel, GalaxyImage, SumValue=SumValue
    ; Sum all valid pixels
    ValidFlag = WHERE(FINITE(GalaxyImage),SumPix,/NULL)
    SumValue = TOTAL(GalaxyImage[ValidFlag],/DOUBLE)
    RETURN, SumPix
END 



FUNCTION CrabImageSumValue, GalaxyImage, SumPixelNumber=SumPixelNumber
    ; Sum all valid pixels
    SumPixelNumber = CrabImageSumPixel(GalaxyImage,SumValue)
    RETURN, SumValue
END



FUNCTION CrabImageSkyValue, InputImage, CentreXY=CentreXY, InnerRadius=InnerRadius, OuterRadius=OuterRadius, $
                                        SkyMod = SkyMod, SkySigma = SkySigma, SkySkew = SkySkew, ArrayR = ArrayR
    ; Source Image
    IF SIZE(InputImage,/N_DIM) NE 2 THEN RETURN, !VALUES.D_NAN
    ImageSize = SIZE(InputImage,/DIM)
    ImageIndex = Indgen(ImageSize[0]*ImageSize[1],/L64)
    ; Centre Position
    IF N_ELEMENTS(CentreXY) NE 2 THEN BEGIN
        CentreX = LONG(ImageSize[0]-1)/2 ; make it integer
        CentreY = LONG(ImageSize[1]-1)/2 ; make it integer
    ENDIF ELSE BEGIN
        CentreX = LONG(CentreXY[0]) ; starts from 0
        CentreY = LONG(CentreXY[1]) ; starts from 0
    ENDELSE
    ; InnerRadius OuterRadius
    RadiusLimit = MIN( [ CentreX, ImageSize[0]-CentreX, CentreY, ImageSize[1]-CentreY ] )
    IF N_ELEMENTS(InnerRadius) EQ 0 THEN InnerRad = RadiusLimit * 0.5d ELSE InnerRad = InnerRadius
    IF N_ELEMENTS(OuterRadius) EQ 0 THEN OuterRad = RadiusLimit * 1.0d ELSE OuterRad = OuterRadius
    IF InnerRad LE 1.0 THEN InnerRad = RadiusLimit * InnerRadius
    IF OuterRad LE 2.0 THEN OuterRad = RadiusLimit * OuterRadius
    ; Image Index & ArrayX & ArrayY & ArrayR
    ImageIndex = Indgen(ImageSize[0]*ImageSize[1],/L64)
    ArrayX = Double( ImageIndex mod ImageSize[0] ) - CentreX
    ArrayY = Double( ImageIndex  /  ImageSize[0] ) - CentreY   ;;; IMPORTANT CORRECTION FROM "ImageSize[1]" TO "ImageSize[0]" FATAL ERROR CORRECTED 2013-05-23!
    ArrayR = SQRT(ArrayX^2+ArrayY^2)
    mmmflag = MAKE_ARRAY(ImageSize[0],ImageSize[1],VALUE=0,/INTEGER)
    mmmflag[WHERE(ArrayR GE InnerRad AND ArrayR LE OuterRad)] = 1 ; this matches the aper.pro
    mmmflag[WHERE(InputImage EQ 0)] = 0 ; <TODO> <TEST> usually 0 values are NaN corrected values.
    ; Sky Index & Value
    mmmindex = WHERE(mmmflag EQ 1, mmmcount)
    mmmidmap = MAKE_ARRAY(3,mmmcount,/DOUBLE,VALUE=0.D)
    mmmidmap[0,*] = mmmindex mod ImageSize[0]
    mmmidmap[1,*] = mmmindex / ImageSize[0]
    mmmidmap[2,*] = InputImage[LONG(mmmidmap[0,*]),LONG(mmmidmap[1,*])]
    mmmsky = InputImage[ WHERE(mmmflag EQ 1) ]
    mmmsky = mmmsky[WHERE(FINITE(mmmsky))]
;   mmmsky = mmmsky[WHERE(mmmsky NE 0.d)] ; <TODO> <TEST> this can prevent mmm error
    mmmskymod = 0.d & mmmskysigma = 0.d & mmmskyskew = 0.d
    IF N_ELEMENTS(mmmsky) GT 9 THEN BEGIN
        mmm, mmmsky, mmmskymod, mmmskysigma, mmmskyskew
        SkyValue = mmmskymod     &   SkyMod   = mmmskymod
        SkySigma = mmmskysigma   &   SkySkew  = mmmskyskew
    ENDIF ELSE BEGIN
        SkyValue = !VALUES.D_NAN   &   SkyMod   = !VALUES.D_NAN
        SkySigma = !VALUES.D_NAN   &   SkySkew  = !VALUES.D_NAN
        Print, 'ImageSkyValue: Unable to calculate image sky value. '
    ENDELSE
    RETURN, SkyValue
END



FUNCTION CrabImageNaNFilter, InputImage, ReplacedValue=ReplacedValue, ReplacedIndex=ReplacedIndex, OVERWRITE=OVERWRITE
    ; <TODO> same as CrabImageDeNaN ??
    IF SIZE(InputImage,/N_DIM) NE 2 THEN PRINT, 'Usage: CrabImageNaNFilter, InputImage, ReplacedValue=ReplacedValue'
    IF SIZE(InputImage,/N_DIM) NE 2 THEN RETURN, []
    IF N_ELEMENTS(ReplacedValue) EQ 0 THEN ReplacedValue=0.0D
    MaskNaN = WHERE(~FINITE(InputImage))
    ReplacedImage = InputImage
    ReplacedImage[MaskNaN] = ReplacedValue
    ReplacedIndex = MaskNaN
    IF KEYWORD_SET(OVERWRITE) THEN InputImage = ReplacedImage
    RETURN, ReplacedImage
END



FUNCTION ImageNaNFilter, InputImage, ReplacedValue=ReplacedValue, ReplacedIndex=ReplacedIndex, OVERWRITE=OVERWRITE
    RETURN, CrabImageNaNFilter(InputImage, ReplacedValue=ReplacedValue, ReplacedIndex=ReplacedIndex, OVERWRITE=OVERWRITE)
END







PRO CrabImageStat, InputFileOrImage, InputHeaderIfInputImage, DoPlot=DoPlot, PRINT=PRINT, $ 
                   PixScale=PixScale, PixSizes=PixSizes, CenPix=CenPix, CenPos=CenPos, CenValue=CenValue, $
                   SumPix=SumPix, SumValue=SumValue, MaxPix=MaxPix, MaxPos=MaxPos, MaxValue=MaxValue
    
;    InputFilePath = 'E:/Temp/Herschel/NGC3227/HIPE9/phot/NGC3227_PACS_Phot_blue_Scanamorphos_pacs70_0.fits'
;    InputFilePath = 'E:/Temp/Herschel/NGC3227/HIPE9/phot/hpacs_25HPPMADB_155.88_p19.86_v1.0_18231249388680856.fits'
;    InputFilePath = 'E:/Temp/Herschel/NGC3227/HIPE10/phot/NGC3227_PACS_Photo_blue_Scanamorphos_pacs70_0.fits'
    
    ; 
    PRINT=1
    
    ; CHECK INPUT
    IF N_ELEMENTS(InputFileOrImage) EQ 0 THEN BEGIN
        MESSAGE, 'Usage: CrabImageStat, InputFileOrImage'
        RETURN
    ENDIF
    IF SIZE(InputFileOrImage,/TNAME) EQ "STRING" THEN BEGIN
        InputImage = CrabReadFitsImage(InputFileOrImage, FITSHEADER=Header, PIXSCALE=PixScale, PIXSIZES=PixSizes, NAXIS=NAxis, /DOUBLE) ; <TODO> , ZUNIT=ZUnit
        IF N_ELEMENTS(InputImage) LE 1 THEN MESSAGE, "CrabImageStat: Error! Input image is invalid! ("+InputFileOrImage+")"
        IF KEYWORD_SET(PRINT) THEN BEGIN
            PRINT, FORMAT='(A,A)',   'Image File Path ------------------- : '+ CrabStringPadSpace(InputFileOrImage,/PadLeading,TotalLength=32)
        ENDIF
    ENDIF ELSE BEGIN
        InputImage = InputFileOrImage
        IF N_ELEMENTS(InputHeaderIfInputImage) LE 1 THEN MESSAGE, "CrabImageStat: Error! If you input image then must input header!"
        Header = InputHeaderIfInputImage
        ; NAXIS
        NAxis = [FXPAR(Header,'NAXIS1'),FXPAR(Header,'NAXIS2')]
        ; PIXSCALE
        PixSizes = [0.d,0.d] ; arcsec
        IF PixSizes[0] EQ 0.d THEN PixSizes[0] = ABS(DOUBLE(SXPAR(Header,'CD1_1')))*3600.d
        IF PixSizes[0] EQ 0.d THEN PixSizes[0] = ABS(DOUBLE(SXPAR(Header,'CDELT1')))*3600.d
        IF PixSizes[0] EQ 0.d THEN PixSizes[0] = ABS(DOUBLE(SXPAR(Header,'PIXSCALE')))
        IF PixSizes[0] EQ 0.d THEN PixSizes[0] = ABS(DOUBLE(SXPAR(Header,'PFOV')))
        IF PixSizes[1] EQ 0.d THEN PixSizes[1] = ABS(DOUBLE(SXPAR(Header,'CD2_2')))*3600.d
        IF PixSizes[1] EQ 0.d THEN PixSizes[1] = ABS(DOUBLE(SXPAR(Header,'CDELT2')))*3600.d
        IF PixSizes[1] EQ 0.d THEN PixSizes[1] = ABS(DOUBLE(SXPAR(Header,'PIXSCALE')))
        IF PixSizes[1] EQ 0.d THEN PixSizes[1] = ABS(DOUBLE(SXPAR(Header,'PFOV')))
        PixScale = PixSizes[0]
        IF PixScale EQ 0.d THEN Print, 'CrabReadFitsImage: Cannot decide pixel size?'
    ENDELSE
    ; GET MAXIMUM PIXEL
    MaxPix = CrabImageMaxPixel(InputImage, MaxValue=MaxValue)
    ; GET CENTRAL PIXEL
    CenPix = CrabImageCentrePoint(InputImage, CentreValue=CenValue)
    ; GET SUM OF PIXELS
    SumPix = CrabImageSumPixel(InputImage, SumValue=SumValue)
    ; DO PLOT
    IF KEYWORD_SET(DoPlot) THEN CrabImageQuickPlot, InputImage, WithPoints=[MaxPix,CenPix], TVScale=0.3
    extast, Header, Astr
    xy2ad, CenPix[0], CenPix[1], Astr, CenPosX, CenPosY
    xy2ad, MaxPix[0], MaxPix[1], Astr, MaxPosX, MaxPosY
    CenPos = [Double(CenPosX), Double(CenPosY)]
    MaxPos = [Double(MaxPosX), Double(MaxPosY)]
    ; PRINT
    IF KEYWORD_SET(PRINT) THEN BEGIN
       ;PRINT, FORMAT='(A,A)',       'Image File Path ------------------- : '+ InputFilePath
        PRINT, FORMAT='(A,2I16)',    'Image Dimension ------------- [pix] : ', NAxis[0], NAxis[1]
        PRINT, FORMAT='(A,2F16.6)',  'Image Dimension ------------- [ " ] : ', NAxis[0]*PixSizes[0], NAxis[1]*PixSizes[1]
        PRINT, FORMAT='(A,2F16.6)',  'Image Pixel Size ------------ [ " ] : ', PixSizes
        PRINT, FORMAT='(A,2I16)',    'Central Pixel Position ------ [pix] : ', CenPix
        PRINT, FORMAT='(A,2F16.6)',  'Central Pixel Position ------ [deg] : ', CenPos
        PRINT, FORMAT='(A,1F32.12)', 'Central Pixel Flux ------- [Jy/pix] : ', CenValue
        PRINT, FORMAT='(A,2I16)',    'Maximum Flux Position ------- [pix] : ', MaxPix
        PRINT, FORMAT='(A,2F16.6)',  'Maximum Flux Position ------- [deg] : ', MaxPos
        PRINT, FORMAT='(A,1F32.12)', 'Maximum Flux ------------- [Jy/pix] : ', MaxValue
        PRINT, FORMAT='(A,1I32)',    'Sum of Valid Pixel Number --- [pix] : ', SumPix
        PRINT, FORMAT='(A,1F32.12)', 'Sum of Valid Pixel Values --- [pix] : ', SumValue
        PRINT, '  '
    ENDIF
    
END

