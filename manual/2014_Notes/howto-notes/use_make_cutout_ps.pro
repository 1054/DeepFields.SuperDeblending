; 
; This script need these data:
;   In current dir, subdirs are named as "cutout_Id***" for each galaxy (see <TODO> subdir name)
;   In each "cutout_Id***", a text file "cutout_list" contains a list of fits file names
;   In each "cutout_Id***", one cutout photo for each wavelength (these photo has already been cutout by supermongo script)
;   Then this IDL script will read all photos and combine to make one large picture, maybe also with ds9 regions shown
;   This script uses the "imrange" function in "use_make_cutouts_Raphael.pro" to make better TV, which is from Raphael
;   And also remember to set GEOMETRY in the code (see <TODO> Set GEOMETRY Here)
;   
;   Input: use_make_cutout_ps, 10255
;   
;   Then it will cd "cutout_Id10255" and read "cutout_list"
;   
;   Output: "./o_cutout_plots/cutout_Id10255.pdf"
; 
PRO use_make_cutout_ps, cutout_Ids, XSIZE=XSIZE, YSIZE=YSIZE
    
    ; 
    ; make multi-wavelength cutouts
    ; 
    
    ; <NOT USED> Now we input the source list
    ; cutout_dirs = FILE_SEARCH('cutout_Id*',/TEST_DIR)
    
    ; Check Output Dir
    output_dir = 'o_cutout_plots' ; output to a new dir under current dir
    IF NOT FILE_TEST(output_dir,/DIR) THEN FILE_MKDIR, output_dir
    
    ; Check Input Source Id List "cutout_Ids"
    IF N_ELEMENTS(cutout_Ids) GE 1 THEN BEGIN
        cutout_dirs = []
        FOREACH cutout_Id, cutout_Ids DO BEGIN
            IF SIZE(cutout_Id,/TNAME) NE 'STRING' THEN BEGIN
                cutout_IdStr = STRTRIM(STRING(cutout_Id,FORMAT='(I0)'),2)
            ENDIF ELSE BEGIN
                cutout_IdStr = cutout_Id
            ENDELSE
            cutout_dirp = FILE_SEARCH('cutout_Id'+cutout_IdStr,/TEST_DIR) ; <TODO> subdir name
            IF N_ELEMENTS(cutout_dirp) GE 1 AND cutout_dirp[0] NE '' THEN BEGIN
                cutout_dirs = [ cutout_dirs, cutout_dirp ]
            ENDIF
        ENDFOREACH
    ENDIF ELSE BEGIN
        MESSAGE, 'make_cutout_ps: please input cutout_Ids! e.g. 10255'
    ENDELSE
    
    ; PRINT, cutout_dirs
    ; RETURN
    
    IF NOT KEYWORD_SET(XSIZE) THEN XSIZE=30
    IF NOT KEYWORD_SET(YSIZE) THEN YSIZE=24
    
    ; <TODO> 
    TempNumber = 0
    
    FOREACH cutout_dir, cutout_dirs DO BEGIN
        ; 
        CD, cutout_dir
        
        ; Check Cutout Fits
        IF NOT FILE_TEST('cutout_list') THEN BEGIN
            CD, '..'
            MESSAGE, 'make_cutout_ps: could not found cutout_list in '+cutout_dir
            CONTINUE
        ENDIF
        
        ; Read Cutout Fits
        readcol, 'cutout_list', cutout_list, FORMAT='(A)'
        
        ; Prepare Plot PS
        SET_PLOT, 'PS'
        DEVICE, FILENAME=cutout_dir+'.ps', DECOMPOSED=1, COLOR=1, BITS_PER_PIXEL=8, /ENCAPSULATED, /PREVIEW, XSIZE=30, YSIZE=24 
              ; When run DEVICE procedure, the FILENAME shall not contain Directory!
        
        ; Loop each Cutout Fits and Plot
        FOR cnumb=0,N_ELEMENTS(cutout_list)-1 DO BEGIN
            
            ; one_band_cutout_file
            cfile = cutout_list[cnumb]
            
            ; one_band_cutout_image
            fits_read, cfile, image, header
            extast, header, hastro
            
            ; scale image use function
            ; <TODO>
            ; tune zscl to make TV looking better
            zscl = [0.3,10,0.001]
            IF STRMATCH(cfile,'*IRAC1*',/F) THEN zscl = [0.8,10,0.005]
            IF STRMATCH(cfile,'*IRAC2*',/F) THEN zscl = [0.8,10,0.005]
            IF STRMATCH(cfile,'*IRAC3*',/F) THEN zscl = [1.0,10,0.018]
            IF STRMATCH(cfile,'*IRAC4*',/F) THEN zscl = [1.0,10,0.018]
            IF STRMATCH(cfile,'*IRSX*',/F)  THEN zscl = [1.1,10,0.021]
            IF STRMATCH(cfile,'*MIPS*',/F)  THEN zscl = [1.0,10,0.019]
            IF STRMATCH(cfile,'*PACS100*',/F) THEN zscl = [1.4,10,0.021]
            IF STRMATCH(cfile,'*PACS160*',/F) THEN zscl = [1.2,10,0.019]
            IF STRMATCH(cfile,'*SPIRE*',/F)   THEN zscl = [2.0,10,0.017]
            irngi = imrange(image,[zscl[0],zscl[1]]) ; THIS IS FROM RAPHAEL's CODE "cutouts.pro"
            imready = bytscl(asinh((irngi[0]>image<irngi[1])/zscl[2])); THIS IS FROM RAPHAEL's CODE "cutouts.pro"
            
            GEOM = [5,4] ; item count 5x4=20pic ; <TODO> Set GEOMETRY Here!
            RECT = [FLOAT(FIX(cnumb MOD GEOM[0])), FLOAT(GEOM[1])-1.0-FLOAT(FIX(cnumb/GEOM[0]))] ; normalized to 1.0 GEOM unit
            POSITION = [FLOAT(RECT[0])/FLOAT(GEOM[0]),FLOAT(RECT[1])/FLOAT(GEOM[1]),FLOAT(RECT[0]+1.0)/FLOAT(GEOM[0]),FLOAT(RECT[1]+1.0)/FLOAT(GEOM[1])]
            
            print, cfile, POSITION
            
            IF !D.NAME EQ 'X' THEN BEGIN
                imready = congrid(imready, XSIZE*(1.0/FLOAT(GEOM[0])-0.001), YSIZE*(1.0/FLOAT(GEOM[1])-0.001))
                TV, imready, POSITION[0]+0.0005, POSITION[1]+0.0005, /NORMAL
            ENDIF
            IF !D.NAME EQ 'PS' THEN BEGIN
                TV, imready, POSITION[0]+0.0025, POSITION[1]+0.0025, /NORMAL, XSIZE=1.0/FLOAT(GEOM[0])-0.005, YSIZE=1.0/FLOAT(GEOM[1])-0.005
            ENDIF
            
            ; Show some text information
            regQX = 0.72*(1.0/FLOAT(GEOM[0])-0.005) + POSITION[0]+0.0025
            regQY = 0.96*(1.0/FLOAT(GEOM[1])-0.005) + POSITION[1]+0.0025
            ObjName = fxpar(header,'OBJECT')
            XYOUTS, regQX, regQY, /NORMAL, ObjName, ALIGN=0.5, CHARSIZE=0.8, CHARTHICK=2.8, COLOR='FFFFFF'xL
            
            ; Show some text information
            regQX = 0.72*(1.0/FLOAT(GEOM[0])-0.005) + POSITION[0]+0.0025
            regQY = 0.91*(1.0/FLOAT(GEOM[1])-0.005) + POSITION[1]+0.0025
            PixScale = DOUBLE(fxpar(header,'CD2_2'))
            FoVSize = PixScale * hastro.naxis[1] * 3600.0
            XYOUTS, regQX, regQY, /NORMAL, 'FoV '+STRTRIM(STRING(FoVSize,FORMAT='(F0.1)'),2)+'"', ALIGN=0.5, CHARSIZE=0.8, CHARTHICK=2.8, COLOR='FFFFFF'xL
            
            ; Skip empty image
            IF TOTAL(image,/NAN) EQ 0.0 THEN BEGIN
                regQX = 0.72*(1.0/FLOAT(GEOM[0])-0.005) + POSITION[0]+0.0025
                regQY = 0.86*(1.0/FLOAT(GEOM[1])-0.005) + POSITION[1]+0.0025
                XYOUTS, regQX, regQY, /NORMAL, 'Object out of image!', ALIGN=0.5, CHARSIZE=0.8, CHARTHICK=2.8, COLOR='FFFFFF'xL
                CONTINUE
            ENDIF
            
            ; <TODO>
            ; Because each photo has a different FoV, thus we might want to plot dashed lines to indicate 
            ; what's the physical scale of one photo on another photo (white dashed lines)
            IF STRMATCH(cfile,'*_IRSX16*',/FOLD_CASE) THEN BEGIN
                regQX1 = 0.00*(1.0/FLOAT(GEOM[0])-0.005) + POSITION[0]+0.0025
                regQY1 = 1.00*(1.0/FLOAT(GEOM[1])-0.005) + POSITION[1]+0.0025
                regQX2 = 0.50*(1.0/FLOAT(GEOM[0])-0.005) + POSITION[0]+0.0025
                regQY2 = 0.66*(1.0/FLOAT(GEOM[1])-0.005) + POSITION[1]+0.0025
                PLOTS, [regQX1,regQX2],[regQY1,regQY2], /NORMAL, LINESTYLE=1, COLOR='FFFFFF'xL
                regQX1 = 0.00*(1.0/FLOAT(GEOM[0])-0.005) + POSITION[0]+0.0025
                regQY1 = 0.00*(1.0/FLOAT(GEOM[1])-0.005) + POSITION[1]+0.0025
                regQX2 = 0.50*(1.0/FLOAT(GEOM[0])-0.005) + POSITION[0]+0.0025
                regQY2 = 0.33*(1.0/FLOAT(GEOM[1])-0.005) + POSITION[1]+0.0025
                PLOTS, [regQX1,regQX2],[regQY1,regQY2], /NORMAL, LINESTYLE=1, COLOR='FFFFFF'xL
            ENDIF
            IF STRMATCH(cfile,'*_SPIRE250*',/FOLD_CASE) THEN BEGIN
                regQX1 = 0.00*(1.0/FLOAT(GEOM[0])-0.005) + POSITION[0]+0.0025
                regQY1 = 1.00*(1.0/FLOAT(GEOM[1])-0.005) + POSITION[1]+0.0025
                regQX2 = 0.50*(1.0/FLOAT(GEOM[0])-0.005) + POSITION[0]+0.0025
                regQY2 = 0.72*(1.0/FLOAT(GEOM[1])-0.005) + POSITION[1]+0.0025
                PLOTS, [regQX1,regQX2],[regQY1,regQY2], /NORMAL, LINESTYLE=1, COLOR='FFFFFF'xL
                regQX1 = 0.00*(1.0/FLOAT(GEOM[0])-0.005) + POSITION[0]+0.0025
                regQY1 = 0.00*(1.0/FLOAT(GEOM[1])-0.005) + POSITION[1]+0.0025
                regQX2 = 0.50*(1.0/FLOAT(GEOM[0])-0.005) + POSITION[0]+0.0025
                regQY2 = 0.28*(1.0/FLOAT(GEOM[1])-0.005) + POSITION[1]+0.0025
                PLOTS, [regQX1,regQX2],[regQY1,regQY2], /NORMAL, LINESTYLE=1, COLOR='FFFFFF'xL
            ENDIF
            IF STRMATCH(cfile,'*_SPIRE350*',/FOLD_CASE) THEN BEGIN
                regQX1 = 0.00*(1.0/FLOAT(GEOM[0])-0.005) + POSITION[0]+0.0025
                regQY1 = 1.00*(1.0/FLOAT(GEOM[1])-0.005) + POSITION[1]+0.0025
                regQX2 = 0.50*(1.0/FLOAT(GEOM[0])-0.005) + POSITION[0]+0.0025
                regQY2 = 0.84*(1.0/FLOAT(GEOM[1])-0.005) + POSITION[1]+0.0025
                PLOTS, [regQX1,regQX2],[regQY1,regQY2], /NORMAL, LINESTYLE=1, COLOR='FFFFFF'xL
                regQX1 = 0.00*(1.0/FLOAT(GEOM[0])-0.005) + POSITION[0]+0.0025
                regQY1 = 0.00*(1.0/FLOAT(GEOM[1])-0.005) + POSITION[1]+0.0025
                regQX2 = 0.50*(1.0/FLOAT(GEOM[0])-0.005) + POSITION[0]+0.0025
                regQY2 = 0.16*(1.0/FLOAT(GEOM[1])-0.005) + POSITION[1]+0.0025
                PLOTS, [regQX1,regQX2],[regQY1,regQY2], /NORMAL, LINESTYLE=1, COLOR='FFFFFF'xL
            ENDIF
            IF STRMATCH(cfile,'*_SPIRE500*',/FOLD_CASE) THEN BEGIN
                regQX1 = 0.00*(1.0/FLOAT(GEOM[0])-0.005) + POSITION[0]+0.0025
                regQY1 = 1.00*(1.0/FLOAT(GEOM[1])-0.005) + POSITION[1]+0.0025
                regQX2 = 0.50*(1.0/FLOAT(GEOM[0])-0.005) + POSITION[0]+0.0025
                regQY2 = 0.88*(1.0/FLOAT(GEOM[1])-0.005) + POSITION[1]+0.0025
                PLOTS, [regQX1,regQX2],[regQY1,regQY2], /NORMAL, LINESTYLE=1, COLOR='FFFFFF'xL
                regQX1 = 0.00*(1.0/FLOAT(GEOM[0])-0.005) + POSITION[0]+0.0025
                regQY1 = 0.00*(1.0/FLOAT(GEOM[1])-0.005) + POSITION[1]+0.0025
                regQX2 = 0.50*(1.0/FLOAT(GEOM[0])-0.005) + POSITION[0]+0.0025
                regQY2 = 0.12*(1.0/FLOAT(GEOM[1])-0.005) + POSITION[1]+0.0025
                PLOTS, [regQX1,regQX2],[regQY1,regQY2], /NORMAL, LINESTYLE=1, COLOR='FFFFFF'xL
                regQX1 = 0.50*(1.0/FLOAT(GEOM[0])-0.005) + POSITION[0]+0.0025
                regQY1 = 0.55*(1.0/FLOAT(GEOM[1])-0.005) + POSITION[1]+0.0025
                regQX2 = 1.00*(1.0/FLOAT(GEOM[0])-0.005) + POSITION[0]+0.0025
                regQY2 = 1.00*(1.0/FLOAT(GEOM[1])-0.005) + POSITION[1]+0.0025
                PLOTS, [regQX1,regQX2],[regQY1,regQY2], /NORMAL, LINESTYLE=1, COLOR='FFFFFF'xL
                regQX1 = 0.50*(1.0/FLOAT(GEOM[0])-0.005) + POSITION[0]+0.0025
                regQY1 = 0.45*(1.0/FLOAT(GEOM[1])-0.005) + POSITION[1]+0.0025
                regQX2 = 1.00*(1.0/FLOAT(GEOM[0])-0.005) + POSITION[0]+0.0025
                regQY2 = 0.00*(1.0/FLOAT(GEOM[1])-0.005) + POSITION[1]+0.0025
                PLOTS, [regQX1,regQX2],[regQY1,regQY2], /NORMAL, LINESTYLE=1, COLOR='FFFFFF'xL
            ENDIF
            
            
            
            
            
            
            
            ; read ds9 region files and TV
            regfile = FILE_BASENAME(cfile,'.fits')+'.ds9.reg'
            ; <TODO> if you do not want to show ds9 regions on the cutouts, just do not write *.ds9.reg files
            IF FILE_TEST(regfile) THEN BEGIN ; AND STRMATCH(regfile,'*_ACS_*',/FOLD_CASE) AND 1 EQ 0 
                OPENR, regunit, regfile, /GET_LUN
                regline = ''
                WHILE ~EOF(regunit) DO BEGIN
                    READF, regunit, regline
                   ;IF STRMATCH(regline,'box\(*\)*{7966}*') THEN BEGIN
                    IF STRMATCH(regline,'box\(*\)*') THEN BEGIN
                        ; regline = 'box(189.3947449,62.2542953,1",1",0) # color=yellow width=1 text={7966} dash=0 fixed=1 move=0 rotate=0'
                        regline = STRMID(regline,STRPOS(regline,'box(')+4)
                        regRA = DOUBLE(STRMID(regline,0,STRPOS(regline,',')))
                        regline = STRMID(regline,STRPOS(regline,',')+1)
                        regDec = DOUBLE(STRMID(regline,0,STRPOS(regline,',')))
                        regline = STRMID(regline,STRPOS(regline,',')+1)
                        regline = STRMID(regline,STRPOS(regline,'color=')+6)
                        regColor = STRMID(regline,0,STRPOS(regline,' '))
                        regline = STRMID(regline,STRPOS(regline,'text={')+6)
                        regText = STRMID(regline,0,STRPOS(regline,'}'))
                        ; print, regRA, regDec, regColor, regText
                        ; now we need to convert ra,dec to x,y
                        ad2xy, regRA, regDec, hastro, regX, regY
                        regPX = regX/FLOAT(hastro.naxis[0]-1.0)
                        regPY = regY/FLOAT(hastro.naxis[1]-1.0)
                        IF !D.NAME EQ 'X' THEN BEGIN
                            regQX = regPX*(1.0/FLOAT(GEOM[0])-0.001) + POSITION[0]+0.0005
                            regQY = regPY*(1.0/FLOAT(GEOM[1])-0.001) + POSITION[1]+0.0005
                        ENDIF
                        IF !D.NAME EQ 'PS' THEN BEGIN
                            regQX = regPX*(1.0/FLOAT(GEOM[0])-0.005) + POSITION[0]+0.0025
                            regQY = regPY*(1.0/FLOAT(GEOM[1])-0.005) + POSITION[1]+0.0025
                        ENDIF
                        IF regPX GE -0.02 AND regPX LE 1.02 AND regPY GE -0.02 AND regPY LE 1.02 THEN BEGIN
                            ; MESSAGE, '<DEBUG>'
                            PRINT, regfile, regRA, regDec, regX, regY, regPX, regPY, regQX, regQY
                            IF STRMATCH(regColor,'yellow',/FOLD_CASE) THEN newColor='00FFFF'xL
                            IF STRMATCH(regColor,'orange',/FOLD_CASE) THEN newColor='00A5FF'xL ; '00D7FF'xL
                            IF STRMATCH(regColor,'magenta',/FOLD_CASE) THEN newColor='CC3299'xL
                            IF STRMATCH(regColor,'red',/FOLD_CASE) THEN newColor='3C14DC'xL
                            IF STRMATCH(regColor,'blue',/FOLD_CASE) THEN newColor='FFBF00'xL
                            PLOTS, regQX, regQY, /NORMAL, PSYM=6, COLOR=newColor, SYMSIZE=2.0
                            XYOUTS, regQX, regQY+0.01, /NORMAL, regText, ALIGN=0.5, COLOR=newColor, CHARSIZE=0.5, CHARTHICK=2.0
                                   ; Shall not use cgXXX! cgXXX will make the map dirty!
                        ENDIF
                    ENDIF
                ENDWHILE
                CLOSE, regunit
                FREE_LUN, regunit
            ENDIF
            
        ENDFOR
        
        DEVICE, /CLOSE
        
        ; <TODO> TempNumber
        TempNumber = TempNumber + 1
        
        ; Convert PS to PDF
        SPAWN, 'ps2pdf -dEPSCrop '+cutout_dir+'.ps'+' ' +'../'+output_dir+'/'+cutout_dir+'.pdf'
        ; SPAWN, 'ps2pdf -dEPSCrop '+cutout_dir+'.ps'+' ' +'../'+output_dir+'/'+'HighChi2_'+STRING(FORMAT='(I0)',TempNumber)+'_'+cutout_dir+'.pdf'
        ; MESSAGE, '<DEBUG>'
        
        ; CD back
        CD, '..'
    
    ENDFOREACH
    
END