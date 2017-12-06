; 
; This is an IDL code to test source peak flux density before and after convolution
; 
PRO test_f_peak
    
    
    PIXSCALE = 0.0498263D
    
    Source_Maj = 0.323522D
    Source_Min = 0.133194D
    Source_PA = 0.0D ; 73.6298D
    Source_ftotal = 0.0407223 ; Jy integrated over source pxiels
    Source_fpeak = 0.0221818
    
    Beam_Maj = 7.875274452898D-05 * 3600.0 
    Beam_Min = 5.774965716733D-05 * 3600.0
    Beam_PA = 82.89898681641D
    Beam_area = 0.0667859 ; arcsec square
    
    Source_fint = Source_ftotal * (Beam_area/PIXSCALE^2)
    Source_Image = PSF_Gaussian(FWHM=([Source_Maj,Source_Min])/PIXSCALE, NPIXEL=501, /DOUBLE, /NORMALIZE) * Source_fint
    
    Source_intrinsic_area_in_beam_unit = (!PI/(4*alog(2.0))*(Source_Maj*Source_Min))/Beam_area
    print, 'Source_area_in_beam_unit: ', Source_intrinsic_area_in_beam_unit
    print, 'Source intrinsic peak from model image: ', max(Source_Image)
    print, 'Source intrinsic peak from computation: ', Source_ftotal / Source_intrinsic_area_in_beam_unit
    
    Beam_Image = PSF_Gaussian(FWHM=([Beam_Maj,Beam_Min])/PIXSCALE, NPIXEL=101, /DOUBLE)
    
    mwrfits, Source_Image, 'Source_Image_unrotated.fits', /create
    mwrfits, Source_Image, 'Beam_Image_unrotated.fits', /create
    
    image = mrdfits('Source_Image_unrotated.fits', 0, header)
    sxaddpar, header, 'PIXSCALE', PIXSCALE
    hrot, image, header, Source_Image, Source_Image_Header, (Source_PA+90), -1, -1, 2
    
    image = mrdfits('Beam_Image_unrotated.fits', 0, header)
    sxaddpar, header, 'PIXSCALE', PIXSCALE
    hrot, image, header, Beam_Image, Beam_Image_Header, (Beam_PA+90), -1, -1, 2
    
    mwrfits, Source_Image, 'Source_Image.fits', Source_Image_Header, /create
    mwrfits, Source_Image, 'Beam_Image.fits', Beam_Image_Header, /create
    
    return
    
    image = mrdfits('Source_Image.fits', 0, header)
    kernel_image = mrdfits('Beam_Image.fits', 0, kernel_header)
    do_we_write = 1
    
    resolve_routine, 'convolve_image'
    do_the_convolution,image,header,kernel_image,kernel_header,result_image,result_header,$
                       result_kernel_image,result_kernel_header,do_we_write
    
    fits_write,'Convolved_Image.fits',result_image,result_header
    fits_write,'Kernel_Image.fits',result_kernel_image,result_kernel_header

    
END