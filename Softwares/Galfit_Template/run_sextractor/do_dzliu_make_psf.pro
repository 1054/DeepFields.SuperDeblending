PRO do_dzliu_make_psf
    
    ; usage:
    ;        idl -e 'do_dzliu_make_psf'
    
    ; define fits image
    
    data = mrdfits('SExtractor_OutputList.psf',1)
    dims = SIZE(data.PSF_MASK,/DIM)
    ;help, data
    print, tag_names(data)
    ;
    mwrfits, data.PSF_MASK[*,*,0], 'psfex_temp_image1.fits', /create
    mwrfits, data.PSF_MASK[*,*,1], 'psfex_temp_image2.fits', /create
    mwrfits, data.PSF_MASK[*,*,2], 'psfex_temp_image3.fits', /create
    psfimage = data.PSF_MASK[*,*,0]
    psfdimen = SIZE(psfimage,/DIM)
    psfimage = psfimage / TOTAL(psfimage,/DOUBLE)
    ;
    print, "PSF Image Dimension: "+STRING(FORMAT='(I0," x ",I0)',psfdimen[0],psfdimen[1])
    print, "PSF Image Maximum: "+STRING(FORMAT='(G0)',MAX(psfimage,/NAN))
    print, "PSF Image Total: "+STRING(FORMAT='(G0)',TOTAL(psfimage,/DOUBLE))
    ; 
    spawn, 'cp -i psfex_temp_image1.fits psf.fits'
    
END
