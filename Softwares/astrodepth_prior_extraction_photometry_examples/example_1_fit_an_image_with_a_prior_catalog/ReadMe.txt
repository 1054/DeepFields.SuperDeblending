
Here is an example of using "astrodepth_prior_extraction_photometry"



Step 0.1 -- preparing image
    
    The image is copied from A3COSMOS dataset v20170604: 
    
        2012.1.00978.S_SB1_GB1_MB1_AzTEC-5_sci.spw0_1_2_3*.fits
    
    and renamed as:
    
        Input_image/sci.spw0_1_2_3.cont.I.image.fits



Step 0.2 -- preparing PSF
    
    ~/Cloud/Github/AlmaCosmos/Softwares/almacosmos_generate_PSF_Gaussian_2D.py \
        "Input_image/sci.spw0_1_2_3.cont.I.image.fits" \
        "Input_image/sci.spw0_1_2_3.cont.I.image.psf.fits"
    
    

Step 0.3 -- preparing prior source catalog
    
    # requires Topcat (http://www.star.bris.ac.uk/~mbt/topcat/)
    
    ~/Cloud/Github/AlmaCosmos/Softwares/almacosmos_topcat_query_catalog_sources_within_fits_image_field_of_view \
        "/Users/dzliu/Work/AlmaCosmos/Catalogs/COSMOS2015_Laigle2016/COSMOS2015_Laigle+_v1.1.fits" \
        "Input_image/sci.spw0_1_2_3.cont.I.image.fits" \
        "Input_catalog/Catalog_Laigle_2016_ID_RA_Dec_Photo-z_Example.txt" \
        -RA ALPHA_J2000 -Dec DELTA_J2000 -keepcols NUMBER ALPHA_J2000 DELTA_J2000 ZPDF






Step 1 -- now let us run the photometry code
    
    bash
    
    source ../../SETUP.bash
    
    astrodepth_prior_extraction_photometry \
        -cat Input_catalog/Catalog_Laigle_2016_ID_RA_Dec_Photo-z_Example.txt \
        -sci Input_image/sci.spw0_1_2_3.cont.I.image.fits \
        -psf Input_image/sci.spw0_1_2_3.cont.I.image.psf.fits \
        -steps "getpix" "galfit" "gaussian" "sersic" "final" "negative" \
        -out "Output_dir" \
        -outname "output_name"
    
    
    # some other trials
    # -psf 2012.1.00978.S_SB1_GB1_MB1_AzTEC-5_sci.spw0_1_2_3.cont.I.clean-beam.fits \
    # -pba 2012.1.00978.S_SB1_GB1_MB1_AzTEC-5_sci.spw0_1_2_3.cont.I.pb.fits \
    # -rms-value 3.799788753e-05 \
    
    
    # Note that now in default the code will just go the "getpix" step. 
    # Please input an argument "-steps getpix galfit" to let the code run also "galfit" fit_n1 fit_0 fit_1 step. 
    # And input the argument "-steps getpix galfit gaussian" to let the code run also "gaussian" fit_2 steps. 






Step 2 -- now read the photometry results
    
    astrodepth_prior_extraction_photometry_read_results Output_dir
    








