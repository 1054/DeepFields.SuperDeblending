FUNCTION CrabShrinkFitsImage, FitsImage, NewSize, FitsHeader=FitsHeader, $
                              CentreXY=CentreXY, NAXIS=NAXIS, Odd=Odd, Even=Even, $
                              OriCentreXY=OriCentreXY, NewCentreXY=NewCentreXY
    
    ; Readin Fits Image
    OriImage = CrabReadFitsImage(FitsImage, FitsHeader=FitsHeader, NAXIS=OldSize, PIXSCALE=PixelSize, /NoUnitConversion)
    
    ; Shrink image by a centre
    IF N_ELEMENTS(CentreXY) EQ 2 THEN BEGIN
        CentreXY = DOUBLE(CentreXY)
    ENDIF ELSE BEGIN
        CentreXY = DOUBLE(OldSize-1.0D)/2.0D
    ENDELSE
    
    ; Shrink image to new size
    IF KEYWORD_SET(Odd)  AND ((NewSize[0] MOD 2) EQ 0) THEN NewSize[0]=LONG(NewSize[0])-1L
    IF KEYWORD_SET(Odd)  AND ((NewSize[1] MOD 2) EQ 0) THEN NewSize[1]=LONG(NewSize[1])-1L
    IF KEYWORD_SET(Even) AND ((NewSize[0] MOD 2) EQ 1) THEN NewSize[0]=LONG(NewSize[0])-1L
    IF KEYWORD_SET(Even) AND ((NewSize[1] MOD 2) EQ 1) THEN NewSize[1]=LONG(NewSize[1])-1L
    NewRadius = DOUBLE(NewSize-1L)/2.0
    LLP = DOUBLE(CentreXY-NewRadius) ; Double Type Lower Left Pixel on original image
    IF LLP[0] GE 0.0 THEN LLP[0]=LLP[0]+0.5 ELSE LLP[0]=LLP[0]-0.5   ; 四舍五入
    IF LLP[1] GE 0.0 THEN LLP[1]=LLP[1]+0.5 ELSE LLP[1]=LLP[1]-0.5   ; 四舍五入
    LLP = LONG(LLP)                  ; Long Int Type Lower Left Pixel on original image
    URP = LLP + NewSize - 1L         ; Long Int Type Upper Right Pixel on original image
    OriCentreXY = DOUBLE(LLP)+NewRadius
    PRINT, 'CrabShrinkFitsImage: Shrinking image from old size '+CrabStringPrintArray(OldSize)+' to new size '+CrabStringPrintArray(NewSize)+$
                               ' according to centre '+CrabStringPrintArray(OriCentreXY,PRECISION=2)+'.'
    NewCentreXY = NewRadius
    
    ; NewImage
    IF LLP[0] GE 0 THEN OriX1=LLP[0] ELSE OriX1=0                                 ; if llp[0]>=0 then cut left
    IF LLP[0] GE 0 THEN NewX1=0 ELSE NewX1=-LLP[0]                                ;              else pad left
    IF LLP[1] GE 0 THEN OriY1=LLP[1] ELSE OriY1=0                                 ; if llp[1]>=0 then cut bottom
    IF LLP[1] GE 0 THEN NewY1=0 ELSE NewY1=-LLP[1]                                ;              else pad bottom
    IF URP[0] LT OldSize[0] THEN OriX2=URP[0] ELSE OriX2=OldSize[0]-1             ; if URP[0]<OldSize[0] then cut right
    IF URP[0] LT OldSize[0] THEN NewX2=NewSize[0]-1 ELSE NewX2=URP[0]-OldSize[0]  ;                      else pad right
    IF URP[1] LT OldSize[1] THEN OriY2=URP[1] ELSE OriY2=OldSize[1]-1             ; if URP[1]<OldSize[1] then cut top
    IF URP[1] LT OldSize[1] THEN NewY2=NewSize[1]-1 ELSE NewY2=URP[1]-OldSize[1]  ;                      else pad top
    PRINT, STRING(FORMAT='(A,A,I0,A,I0,A,I0,A,I0,A,I0,A,I0,A,I0,A,I0,A)','CrabShrinkFitsImage: Shrinking image with transformation',$
           'NewImage[',NewX1,':',NewX2,',',NewY1,':',NewY2,'] = OriImage[',OriX1,':',OriX2,',',OriY1,':',OriY2,']')
    NewImage = MAKE_ARRAY(NewSize[0],NewSize[1],/DOUBLE,VALUE=0.0D)
    NewImage[NewX1:NewX2,NewY1:NewY2] = OriImage[OriX1:OriX2,OriY1:OriY2]
    
    ; NAXIS
    NAXIS1 = NewSize[0]
    NAXIS2 = NewSize[1]
    CRPIX1 = DOUBLE(SXPAR(FitsHeader,'CRPIX1'))-DOUBLE(LLP[0])
    CRPIX2 = DOUBLE(SXPAR(FitsHeader,'CRPIX2'))-DOUBLE(LLP[1])
    
    ; FITSHeader
;    PRINT, 'CrabShrinkFitsImage: Old NAXIS1='+STRTRIM(SXPAR(FitsHeader,'NAXIS1'),2)+' NAXIS2='+STRTRIM(SXPAR(FitsHeader,'NAXIS2'),2)+', '+$
;                                'New NAXIS1='+STRTRIM(NAXIS1,2)+' NAXIS2='+STRTRIM(NAXIS2,2)+'. '
    SXADDPAR, FitsHeader, 'NAXIS',  2
    SXADDPAR, FitsHeader, 'NAXIS1', NAXIS1
    SXADDPAR, FitsHeader, 'NAXIS2', NAXIS2
    SXDELPAR, FitsHeader, 'NAXIS3'
    SXADDPAR, FitsHeader, 'CRPIX1', CRPIX1
    SXADDPAR, FitsHeader, 'CRPIX2', CRPIX2
    
    
    ; RETURN
    RETURN, NewImage
    
END