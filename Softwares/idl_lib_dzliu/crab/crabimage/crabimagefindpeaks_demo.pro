PRO crabimagefindpeaks_demo
    
    FitsFile = '/Users/dliu/Working/2014-CEA-ExtraDataProduct/COSMOS_Photo/uvista_cosmos/cosmos_cluster_d14ae_uvista_Ks_image.fits'
    FitsIMG = CrabReadFitsImage(FitsFile) 
    FoundPeaks = CrabImageFindPeaks(FitsIMG,MaxPeakNumber=50,/DoPlot)
    
END


; 
; Dependencies:
;     CrabReadFitsImage
;     CrabImageFindPeaks
;     CrabImageQuickPlot
;     CrabImageTVCircle
;     CrabImageAD2XY
;     CrabArrayINDGEN