
Here is an example of using "astrodepth_prior_extraction_photometry"



Prepare images:

cp '/Volumes/GoogleDrive/Team Drives/A3COSMOS/Data/ALMA_full_archive/Calibrated_Images_by_Benjamin/v20170604/'*/2012.1.00978.S_SB1_GB1_MB1_AzTEC-5_sci.spw0_1_2_3* \
    .



Then run as follows: 

bash
source ../SETUP
astrodepth_prior_extraction_photometry \
    -cat Catalog_Laigle_2016_ID_RA_Dec_Photo-z_Example_2.txt \
    -sci 2012.1.00978.S_SB1_GB1_MB1_AzTEC-5_sci.spw0_1_2_3.cont.I.image.fits \
    -psf 2012.1.00978.S_SB1_GB1_MB1_AzTEC-5_sci.spw0_1_2_3.cont.I.clean-beam.fits \
    -pba 2012.1.00978.S_SB1_GB1_MB1_AzTEC-5_sci.spw0_1_2_3.cont.I.pb.fits \
    -rms-value 3.799788753e-05 \
    -steps "getpix" "galfit" "gaussian" "sersic" "negative" \
    -out "output_dir_2"
    










Note that now in default the code will just go the "getpix" step. 
Please input an argument "-steps getpix galfit" to let the code run also "galfit" fit_n1 fit_0 fit_1 step. 
And input the argument "-steps getpix galfit gaussian" to let the code run also "gaussian" fit_2 steps. 

For example: 

astrodepth_prior_extraction_photometry -sci sci.spw0_1_2_3.cont.I.image.fits -psf sci.spw0_1_2_3.cont.I.psf.fits -cat Catalog_Laigle_2016_ID_RA_Dec_Photo-z_Example.txt -out "output_dir" -outname "output_name" -steps "getpix" "galfit" "gaussian"




