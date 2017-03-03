#!/bin/bash
"/Users/dzliu/Cloud/Github/DeepFields.SuperDeblending/Softwares"/CrabFitsImageArithmetic image_sci_input.fits '*' '+1.0' image_sci.fits      -remove-nan
"/Users/dzliu/Cloud/Github/DeepFields.SuperDeblending/Softwares"/CrabFitsImageArithmetic image_sci_input.fits '*' '-1.0' image_negative.fits -remove-nan
"/Users/dzliu/Cloud/Github/DeepFields.SuperDeblending/Softwares"/CrabFitsImageArithmetic image_sci.fits '*' 0.0 image_zero.fits -remove-nan
"/Users/dzliu/Cloud/Github/DeepFields.SuperDeblending/Softwares"/CrabFitsImageArithmetic image_zero.fits '+' 1.0 image_rms.fits -remove-nan
"/Users/dzliu/Cloud/Github/DeepFields.SuperDeblending/Softwares"/CrabFitsImageArithmetic image_psf_input.fits '*' 1.0 image_psf.fits -remove-nan

