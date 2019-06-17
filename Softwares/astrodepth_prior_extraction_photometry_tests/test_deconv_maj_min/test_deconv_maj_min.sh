#!/bin/bash
# 

cd $(dirname ${BASH_SOURCE[0]})

cp ../astrodepth_prior_extraction_photometry_go_galfit.sm .

echo "macro read astrodepth_prior_extraction_photometry_go_galfit.sm calc_deconvolved_sizes 5.0 4.0 90.0 1.0 1.0 0.0" | sm

echo "macro read astrodepth_prior_extraction_photometry_go_galfit.sm calc_deconvolved_sizes 5.0 4.9 200.0 2.0 1.5 180.0" | sm
