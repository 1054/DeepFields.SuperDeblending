
Here is an example of using "astrodepth_prior_extraction_photometry"

Please run the following code: 

bash
source ../SETUP
astrodepth_prior_extraction_photometry -sci sci.spw0_1_2_3.cont.I.image.fits -psf sci.spw0_1_2_3.cont.I.psf.fits -cat Catalog_Laigle_2016_ID_RA_Dec_Photo-z_Example.txt -out "output_dir" -outname "output_name"










Note that now in default the code will just go the "getpix" step. 
Please input an argument "-steps getpix galfit" to let the code run also "galfit" fit_n1 fit_0 fit_1 step. 
And input the argument "-steps getpix galfit gaussian" to let the code run also "gaussian" fit_2 steps. 

For example: 

astrodepth_prior_extraction_photometry -sci sci.spw0_1_2_3.cont.I.image.fits -psf sci.spw0_1_2_3.cont.I.psf.fits -cat Catalog_Laigle_2016_ID_RA_Dec_Photo-z_Example.txt -out "output_dir" -outname "output_name" -steps "getpix" "galfit" "gaussian"




