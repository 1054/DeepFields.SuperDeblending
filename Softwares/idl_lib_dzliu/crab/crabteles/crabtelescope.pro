; This program can recognize telescope information from a text string like data file name. 
; e.g. FileName = "somesource_pacs_160um_xxxx_yyyy.fits"
; then we can recognize that this data file is Herschel/PACS/160.
; 
; Updated: 
;          2013-05-17
;          2014-06-26 -- seperate all subroutines
; Support: 
;          Herschel
;          Spitzer
;          <TODO> 
; Subfile: RecognizeTelescope.pro
;          RecognizeInstrument.pro
;          RecognizeFilter.pro
;          RecognizeFrequency.pro
;          RecognizePSFGaussian.pro
;          RecognizePSF.pro
;          CrabTelescopeRecognizePSF.pro
;          CrabTelescopeRecognize.pro
;


PRO CrabTelescope
    PRINT, 'CrabTelescope: '
    PRINT, '               PRINT, RecognizeTelescope("file_xxx_mips24_xxx.fits")'
    PRINT, '               PRINT, RecognizeInstrument("file_xxx_mips24_xxx.fits")'
    PRINT, '               PRINT, RecognizeFilter("file_xxx_mips24_xxx.fits")'
END
