cp ../SExtractor_OutputList.* .

psfex SExtractor_OutputList.fits -c default.psfex

output is SExtractor_OutputList.psf

idl
data = mrdfits('SExtractor_OutputList.psf', 1, header_1)
print, TAG_NAMES(data) ; PSF_MASK
image_1 = data.PSF_MASK[*,*,0]
image_2 = data.PSF_MASK[*,*,1]
image_3 = data.PSF_MASK[*,*,2]
image_4 = data.PSF_MASK[*,*,3]
image_5 = data.PSF_MASK[*,*,4]
image_6 = data.PSF_MASK[*,*,5]
mwrfits, image_1, 'image_1.fits', /create
mwrfits, image_2, 'image_2.fits', /create
mwrfits, image_3, 'image_3.fits', /create
mwrfits, image_4, 'image_4.fits', /create
mwrfits, image_5, 'image_5.fits', /create
mwrfits, image_6, 'image_6.fits', /create
exit

cp image_1.fits image_psf.fits
cp image_psf.fits ../../all.irac.1.psf.dzliu.fits


