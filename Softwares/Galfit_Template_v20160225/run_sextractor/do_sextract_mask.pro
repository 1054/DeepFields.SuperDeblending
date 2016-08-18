PRO do_SExtract_Mask, FITPhoto = FITPhoto, RMSPhoto = RMSPhoto
    
    ; usage:
    ;        idl -e 'do_SExtract_Mask'
    
    ; define fits image
    
    IF N_ELEMENTS(FITPhoto) EQ 0 OR N_ELEMENTS(RMSPhoto) EQ 0 THEN MESSAGE, 'Example: do_SExtract_Mask, FITPhoto = "../FIT_goodsn_100_Map_201512_vary.fits", RMSPhoto = "../pgh_goodsn_green_Map_v1.0_rms_DL.fits"'
    ; FITPhoto = '../FIT_goodsn_100_Map_201512_vary.fits'
    ; RMSPhoto = '../pgh_goodsn_green_Map_v1.0_rms_DL.fits'
    
    ; use a fits image and a catalog
    
    FitsImage = CrabReadFitsImage(FITPhoto,1,FitsHeader=FitsHeader,FitsAstr=FitsAstr,NAXIS=NAXIS,PIXSCALE=PixScale)
    FitsImage = MRDFITS(FITPhoto,2)
    
    OutputMask   = 'SExtractor_Mask.fits'
    OutputSignal = 'SExtractor_Signal.fits'
    OutputNoise  = 'SExtractor_Noise.fits'
    OutputWeight = 'SExtractor_Weight.fits'
    
    ShrinkPixel = FIX(5.0/PixScale)+1 ; we shrink 5.0 arcsec to the border of field area to avoid detecting sources too close to the border. 
    
    ; Triangulate 3 times to define the field area
    
    PerimeterPI = []
    PerimeterPJ = []
    PerimeterID = []
    IF NOT FILE_TEST("perimeter.txt") OR 1 EQ 1 THEN BEGIN
        CatTXT = 'irac_mips_fluxes_hdfn.dat' ; do not change this, this defines the field area
        readcol, CatTXT, FORMAT='(F,F,I)', CatRA, CatDEC, CatID
        ad2xy, CatRA, CatDEC, FitsAstr, CatPI, CatPJ
        FOR i = 0, 10 DO BEGIN
            Triangulate, CatPI, CatPJ, Triangles, Hull ; http://www.idlcoyote.com/tips/convex_hull.html
            PerimeterPI = [PerimeterPI, CatPI[Hull]]
            PerimeterPJ = [PerimeterPJ, CatPJ[Hull]]
            PerimeterID = [PerimeterID, CatID[Hull]]
            CatPI[Hull] = -1
            CatPJ[Hull] = -1
            CatID[Hull] = -1
            CooID = WHERE(CatPI GE 0 AND CatPJ GE 0, /NULL)
            CatPI = CatPI[CooID]
            CatPJ = CatPJ[CooID]
            CatID = CatID[CooID]
        ENDFOR
        CrabTablePrintC, "perimeter.txt", PerimeterID, PerimeterPI, PerimeterPJ
        SPAWN, 'CrabTable2ds9reg perimeter.txt perimeter.ds9.reg -image -radius 5'
    ENDIF ELSE BEGIN
        readcol, "perimeter.txt", FORMAT='(I,F,F)', PerimeterID, PerimeterPI, PerimeterPJ
    ENDELSE
    
    Mask = FitsImage*0
    
    ; now mask the fits image by catalog sources
    ; if a pixel falls within catalog sources then mask=1 otherwise mask=0
    
    FOR j = FIX(MIN(PerimeterPJ)-1), FIX(MAX(PerimeterPJ)+1) DO BEGIN
        iLeft = 0
        iRight = -1
        FOR i = 0, NAXIS[0]-1, 1 DO BEGIN
            ; find two closest Perimeter points (from Left)
            distance = (PerimeterPI-i)^2 + (PerimeterPJ-j)^2
            iothers = where((PerimeterPJ-j) GE 0, /NULL) & IF N_ELEMENTS(iothers) EQ 0 THEN CONTINUE
            iclose1 = where(distance eq min(distance[iothers]), /null)
            iothers = where((PerimeterPJ-j) LE 0, /NULL) & IF N_ELEMENTS(iothers) EQ 0 THEN CONTINUE
            iclose2 = where(distance eq min(distance[iothers]), /null)
            iborder = interpol([PerimeterPI[iclose1],PerimeterPI[iclose2]],[PerimeterPJ[iclose1],PerimeterPJ[iclose2]],j)
            IF i GE iborder THEN BEGIN
                iLeft = i
                BREAK
            ENDIF
        ENDFOR
        FOR i = NAXIS[0]-1, 0, -1 DO BEGIN
            ; find two closest Perimeter points (from Right)
            distance = (PerimeterPI-i)^2 + (PerimeterPJ-j)^2
            iothers = where((PerimeterPJ-j) GE 0, /NULL) & IF N_ELEMENTS(iothers) EQ 0 THEN CONTINUE
            iclose1 = where(distance eq min(distance[iothers]), /null)
            iothers = where((PerimeterPJ-j) LE 0, /NULL) & IF N_ELEMENTS(iothers) EQ 0 THEN CONTINUE
            iclose2 = where(distance eq min(distance[iothers]), /null)
            ;iclose1 = where(distance eq min(distance))
            ;iothers = where(distance ne min(distance))
            ;iclose2 = where(distance eq min(distance[iothers]), /null)
            iborder = interpol([PerimeterPI[iclose1],PerimeterPI[iclose2]],[PerimeterPJ[iclose1],PerimeterPJ[iclose2]],j)
            IF i LE iborder THEN BEGIN
                iRight = i
                BREAK
            ENDIF
        ENDFOR
        ; mask=1 in between
        ; print, iLeft, iRight, j
        ; IF iLeft LE iRight THEN BEGIN
        ;     Mask[iLeft:iRight,j] = 1
        ; ENDIF
        
        IF iLeft+ShrinkPixel LE iRight-ShrinkPixel AND j LT NAXIS[1] THEN BEGIN
            Mask[iLeft+ShrinkPixel:iRight-ShrinkPixel,j] = 1 ;<TODO>; use smaller sky area, by shrinking 15 pixel border
        ENDIF
    ENDFOR
    
    MKHDR, OutputHeader, Mask
    PUTAST, OutputHeader, FitsAstr
    MWRFITS, Mask, OutputMask, OutputHeader, /Create
    
    Signal = FitsImage * Mask
    Signal[WHERE(Mask EQ 0)] = !VALUES.D_NAN
    MKHDR, OutputHeader, Signal
    PUTAST, OutputHeader, FitsAstr
    MWRFITS, Signal, OutputSignal, OutputHeader, /Create
    
    RmsImage = MRDFITS(RMSPhoto)
    Noise = RmsImage
    Noise[WHERE(Mask EQ 0)] = !VALUES.D_NAN
    MKHDR, OutputHeader, Noise
    PUTAST, OutputHeader, FitsAstr
    MWRFITS, Noise, OutputNoise, OutputHeader, /Create
    
    Weight = RmsImage
    Weight[WHERE(Mask NE 0)] = 1/(RmsImage[WHERE(Mask NE 0)]^2)
    Weight[WHERE(Mask EQ 0)] = 1e20
    MKHDR, OutputHeader, Weight
    PUTAST, OutputHeader, FitsAstr
    MWRFITS, Weight, OutputWeight, OutputHeader, /Create
    
    
    
END
